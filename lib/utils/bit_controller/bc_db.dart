import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SettingsDB {

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

