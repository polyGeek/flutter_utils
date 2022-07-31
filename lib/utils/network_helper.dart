import 'dart:async';
import 'dart:convert';
import 'package:flutter_utils/utils/eol.dart';
import 'package:http/http.dart' as http;



class NetworkHelper {

	static const String API_PATH 					= 'https://runpee.net/flutter/food/';
	static const String API_VERSION 			= 'v01';
	static const int SERVER_TIMEOUT_15 		= 15;

	/** ===============================================
	*  Network Responses
	*  ===============================================*/
	/// Server side errors
	static const String ERROR_						= 'ERROR_';
	static const String ERROR_UNKNOWN 		= 'ERROR_UNKNOWN';
	static const String ERROR_NO_DATA			= 'ERROR_NO_DATA';
	static const String ERROR_SERVER_500	= 'ERROR_500_SERVER';
	static const String ERROR_CONNECTION  = 'CONNECTION_ERROR';

	/// App side errors
	static const String ERROR_TIMEOUT			= 'ERROR_NETWORK_TIMEOUT';
	static const String ERROR_TRY_CATCH		= 'ERROR_TRY_CATCH';
	
	static String _lastErrorMsg = '';
	static String get lastErrorMsg => _lastErrorMsg;

	static final dynamic 	encoding = Encoding.getByName( 'utf-8' );
	static const dynamic	headers = {'Content-Type': 'application/json'};

	static Future<String> sendPostRequest( {
		required String 							uri,
		required Map<String, dynamic> map } ) async {

		_log( msg: '[ DATA SENT TO SERVER ] \n' + uri );
		_log( msg: map.toString(), isJson: true );

		/// Append the errors that might be returned programmatically from the API.
		map.addAll( {
			'error_no_data': ERROR_NO_DATA,
			'error_unknown': ERROR_UNKNOWN,
			'error_connection': ERROR_CONNECTION,
		} );

		String jsonBody = json.encode( map	 );

		http.Response response;

		try {

			var nowA = DateTime.now();
			response = await http.post(
				Uri.parse( NetworkHelper.API_PATH + NetworkHelper.API_VERSION +  uri ),
				headers: headers,
				body: jsonBody,
				encoding: encoding,
			).timeout( const Duration( seconds: SERVER_TIMEOUT_15 ) );

			_log( msg: '[ DATA FROM SERVER ]'
				"[load time: " + ( DateTime.now().millisecondsSinceEpoch - nowA.millisecondsSinceEpoch ).toString() + "ms]"
			);

		} on TimeoutException catch (_) {

			_log( msg: 'NETWORK_TIMEOUT >>> ' + uri );
			_lastErrorMsg = ERROR_TIMEOUT;
			return ERROR_TIMEOUT;

		} catch( e ) {

			_log( msg: 'ERROR CODE: NETWORK_TRY_CATCH >>> ' + e.toString() + ' uri: ' + uri );
			_lastErrorMsg = ERROR_TRY_CATCH;
			return ERROR_TRY_CATCH;
		}

		if( response.statusCode == 500 ) {

			_log( msg: 'ERROR CODE: SERVER_ERROR_500 >>> ' + uri );
			_lastErrorMsg = ERROR_SERVER_500;
			return ERROR_SERVER_500;

		} else if( response.statusCode == 200 ) {

			String body = response.body.toString();

			if( body.isEmpty || body.contains( ERROR_NO_DATA ) ) {

				_log( msg: 'ERROR CODE: NO_DATA >>> ' + uri );
				_lastErrorMsg = ERROR_NO_DATA;
				return ERROR_NO_DATA;

			} else if( body.contains( ERROR_CONNECTION )){

				_log( msg: 'ERROR CODE: NO_CONNECTION >>> ' + uri );
				_lastErrorMsg = ERROR_CONNECTION;
				return ERROR_CONNECTION;
			} else {


				return body;
			}

		} else {

			_log( msg: 'ERROR CODE: ERROR_UNKNOWN >>> ' );
			_lastErrorMsg = ERROR_UNKNOWN;
			return ERROR_UNKNOWN;

		}

	}

	static Map<String, dynamic> convertJsonStringToObject( {
		required String rawJson,
		required String collection
	} ) {


		rawJson = rawJson.substring( rawJson.indexOf( collection ) + collection.length + 3 );
		rawJson = rawJson.substring( 0, rawJson.indexOf( ']' ) );
		return jsonDecode( rawJson );
	}

	static const bool 		isDebug 	= true;
	static void _log( { required String msg, bool isJson=false, bool shout=false, bool fail=false } ) {
		if( isDebug ) {
      EOL.log(
        msg: msg,
        shout: shout,
        fail: fail,
        borderSide: 'N',
        borderTop: '~',
        color: EOL.NetworkHelper_combo_white_black,
      );
    }
  }
}