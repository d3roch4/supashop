import 'package:diacritic/diacritic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_io/io.dart';

class StorageSupabaseUtil {
  static Future<String> saveImage(
      SupabaseClient supabase, String filePath, String idStore,
      [String? subDir]) async {
    final file = File(filePath);
    var bytes = await file.readAsBytes();
    var fileName = file.path.split(Platform.pathSeparator).last;
    fileName = removeDiacritics(fileName);
    var storageResponse = await supabase.storage.from('stores').uploadBinary(
        '$idStore${subDir != null ? '$subDir/' : ''}/$fileName', bytes,
        fileOptions: FileOptions(upsert: true));
    storageResponse = supabase.storage.from('bucket').getPublicUrl(
          storageResponse,
          // transform: TransformOptions(
          //   width: width,
          //   height: height,
          // ),
        );
    return storageResponse.replaceFirst('bucket', '');
  }
}