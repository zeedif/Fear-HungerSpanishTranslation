import 'dart:convert';
import 'dart:io';

void main() {
  final f1 = "lib/files/CommonEvents.json";
  final f2 = "lib/files/Troops.json";
  final filePaths = [f2, f1];

  final bloc = ParametersAnalyzer(enableRecursion: true);

  for (final filePath in filePaths) {
    bloc.processJsonFile(filePath);
  }

  bloc.parameterTypes.forEach((parameterType) {
    print(parameterType);
  });
}

class ParametersAnalyzer {
  final parameterTypes = <String>{};
  final bool enableRecursion;

  ParametersAnalyzer({required this.enableRecursion});

  void processJsonFile(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      print('The file $filePath does not exist.');
      return;
    }

    final fileContent = file.readAsStringSync();
    final jsonList = json.decode(fileContent);

    for (final jsonMap in jsonList) {
      final parameters = jsonMap['parameters'];
      if (parameters == null) {
        continue;
      }
      if (parameters is List) {
        final parameterType = _getParameterType(parameters);
        if (!parameterTypes.contains(parameterType)) {
          parameterTypes.add(parameterType);
        }
      } else if (parameters is Map<String, dynamic> && enableRecursion) {
        _exploreMap(parameters);
      }
    }
  }

  void _exploreMap(Map<String, dynamic> map) {
    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value is List) {
        final parameterType = _getParameterType(value);
        if (!parameterTypes.contains(parameterType)) {
          parameterTypes.add(parameterType);
        }
      } else if (value is Map<String, dynamic> && enableRecursion) {
        final parameterType = _getTypeString(key, value);
        if (!parameterTypes.contains(parameterType)) {
          parameterTypes.add(parameterType);
        }
        _exploreMap(value);
      } else {
        final parameterType = _getTypeString(key, value);
        if (!parameterTypes.contains(parameterType)) {
          parameterTypes.add(parameterType);
        }
      }
    }
  }

  String _getParameterType(List parameters) {
    final types = parameters.map((param) => _getTypeString(null, param));
    return 'List(${types.join(', ')})';
  }

  String _getTypeString(String? key, dynamic value) {
    if (value is Map<String, dynamic> && enableRecursion) {
      return _getMapTypeString(key, value);
    } else if (value is List && enableRecursion) {
      return _getListTypeString(key, value);
    } else {
      final typeString = value.runtimeType.toString();
      return key != null ? '$typeString $key' : typeString;
    }
  }

  String _getMapTypeString(String? key, Map<String, dynamic> map) {
    final typeStrings = map.entries.map((entry) => _getTypeString(entry.key, entry.value));
    final typeName = key != null ? 'Map<String, dynamic> $key' : 'Map<String, dynamic>';
    return '$typeName({${typeStrings.join(', ')}})';
  }

  String _getListTypeString(String? key, List list) {
    final typeStrings = list.map((item) => _getTypeString(null, item));
    final typeName = key != null ? ' $key' : '';
    return 'List(${typeStrings.join(', ')})$typeName';
  }
}
