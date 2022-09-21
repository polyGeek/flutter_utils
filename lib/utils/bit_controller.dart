import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BitController {

	
	static String _bits = '0' * 128;
	static bool isInit = false;
	
	static void init( { required String bits } ) {
		_bits = bits;
		isInit = true;
	}

	bool getValue( { required int index } ) {
		bool b = ( _bits[ index ] == '1' )? true : false;
		return b;
	}
	
	void setValue( { required int index, required bool booleanValue } ) {
		String before = _bits.substring(0, index);
		String after = _bits.substring(index + 1);

		_bits = before + ((booleanValue) ? '1' : '0') + after;

		_BitDB().updateBits( _bits );
	}
}




class _BitDB {

	void updateBits(String bits) async {
		Database db = await _openUserSettingsDatabase();
		String sql = "UPDATE settings set bits = '$bits' WHERE uKey = 1";
		await db.rawQuery(sql);
	}

	dynamic _openUserSettingsDatabase() async {

		return openDatabase(

			join( await getDatabasesPath(), 'bit_controller.db' ),

			onCreate: ( db, version ) {
				String sql = "CREATE TABLE settings ( "
						"uKey 								INTEGER PRIMARY KEY, "
						"bits 								TEXT 	"
						")";

				db.execute( sql );
			},
			version: 1,
		);
	}
}

