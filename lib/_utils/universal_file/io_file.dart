import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import '../logger.dart';
import '../path_utils.dart';
import 'universal_file.dart';

class IoFileWriter implements UniversalFile {
  Directory? dataDir;

  @override
  String fileName;

  IoFileWriter(this.fileName);

  String get fullPath => p.join(dataDir?.path ?? "", fileName);

  Future<void> getDataPath() async {
    if (dataDir != null) return;
    String? dataPath = await PathUtil.dataPath;
    if (dataPath != null) {
      dataDir = Directory(dataPath);
      if (Platform.isWindows || Platform.isLinux) {
        createDirIfNotExists(dataDir!);
      }
    }
  }

  @override
  Future<String?> read() async {
    await getDataPath();
    log("Loading file @ $fullPath");
    if (await File(fullPath).exists()) {
      return await File(fullPath).readAsString().catchError((Object e) {
        log(e.toString());
        return e.toString();
      });
    }
    return null;
  }

  @override
  Future<void> write(String value, [bool append = false]) async {
    await getDataPath();
    log("[IoFileWriter] Writing file to: $fullPath");
    try {
      FileMode writeMode = append ? FileMode.append : FileMode.write;
      File(fullPath).writeAsString(value, mode: writeMode);
    } catch (e) {
      log("$e");
    }
  }

  static void createDirIfNotExists(Directory dir) async {
    // Create directory if it doesn't exist
    if (!await dir.exists()) {
      // Catch error since disk io can always fail.
      try {
        await dir.create(recursive: true);
      } catch (e) {
        log("$e");
      }
    }
  }
}

UniversalFile getPlatformFileWriter(String string) => IoFileWriter(string);
