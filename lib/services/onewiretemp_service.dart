import 'dart:io';

class OneWireTempService {
  static const String _baseDir = '/sys/bus/w1/devices/';
  static const String _tempFile = 'w1_slave';

  static Future<List<Map<String, dynamic>>> readTemperatures() async {
    final List<Map<String, dynamic>> results = [];

    final Directory baseDir = Directory(_baseDir);
    if (!await baseDir.exists()) {
      throw Exception('1-wire devices directory not found');
    }

    final List<FileSystemEntity> entities = await baseDir.list().toList();
    for (final FileSystemEntity entity in entities) {
      if (entity is Directory) {
        final File tempFile = File('${entity.path}/$_tempFile');
        if (await tempFile.exists()) {
          final String contents = await tempFile.readAsString();
          final String id = entity.path.split('/').last;
          final double? temp = _parseTemperature(contents);
          results.add({'id': id, 'temp': temp});
        }
      }
    }

    return results;
  }

  static double? _parseTemperature(String contents) {
    final RegExp regex = RegExp('t=(\\d+)');
    final Match? match = regex.firstMatch(contents);
    if (match != null) {
      final String tempString = match.group(1)!;
      final double temp = double.parse(tempString) / 1000.0;
      return temp;
    } else {
      return null;
    }
  }
}
