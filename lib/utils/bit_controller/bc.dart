
class BC {

	
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

		//SettingsDB().updateBits( _bits );
	}
}