import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final specificFileName = ''; // Specify the file name if you only want to run a specific file
  final translationCode = 'en-US'; // ISO 639-1 codes
  final generateTranslationsFile = true;

  final translationsDirectory = 'translations/$translationCode';
  final outputDirectory = 'output';

  await Directory(translationsDirectory).create(recursive: true);
  await Directory(outputDirectory).create(recursive: true);

  if (specificFileName.isEmpty) {
    final nameFiles = List.generate(186, (index) => 'Map${(index + 1).toString().padLeft(3, '0')}');
    await Future.forEach(nameFiles, (nameFile) async {
      await processFile(nameFile, generateTranslationsFile, translationsDirectory, outputDirectory);
    });
  } else {
    await processFile(specificFileName, generateTranslationsFile, translationsDirectory, outputDirectory);
  }
}

Future<void> processFile(String fileName, bool generateTranslationsFile, String translationsDirectory, String outputDirectory) async {
  final filePath = 'data2/$fileName.json';
  final translationsFile = '$translationsDirectory/$fileName.txt';
  final outputFilePath = '$outputDirectory/$fileName.json';

  final messageProcessor = MessageProcessor(generateTranslationsFile, translationsFile, outputFilePath);
  await messageProcessor.processJsonFile(filePath);
}

class MessageProcessor {
  final bool generateTranslationsFile;
  final String translationsFile;
  final String outputDirectory;
  int translationIndex = 0;
  bool emptyTranslationFile = true;
  List<String> translatedStrings = [];

  MessageProcessor(this.generateTranslationsFile, this.translationsFile, this.outputDirectory);

  Future<void> processJsonFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      print('The file $filePath does not exist.');
      return;
    }

    final fileContent = await file.readAsString();
    final jsonData = json.decode(fileContent);

    if (jsonData is Map<String, dynamic>) {
      _traverseJson(jsonData);
      final updatedJsonContent = json.encode(jsonData);
      if (generateTranslationsFile && !emptyTranslationFile) {
        final outputFile = File(outputDirectory);
        await outputFile.writeAsString(updatedJsonContent);
      }
    }
  }

  void _traverseJson(Map<String, dynamic> jsonMap) {
    if (jsonMap.containsKey('code')) {
      final parameters = jsonMap['parameters'];

      if (jsonMap['code'] == 101) {
        final positionMap = {
          0: ' (superior) ',
          1: ' (centrado) ',
          2: ' (inferior) ',
        };
        final position = parameters[3] as int;
        final positionText = positionMap[position];

        print('____TEXT____\n$positionText');
        _appendTranslatedString('____TEXT____');
        translationIndex++;
      } else if (jsonMap['code'] == 102) {
        print('___CHOICE___');
        _appendTranslatedString('___CHOICE___');
        translationIndex++;
        for (var i = 0; i < parameters[0].length; i++) {
          final value = parameters[0][i];
          if (value is String) {
            final translatedValue = _getTranslatedString(value);
            print("(•) $translatedValue");
            _appendTranslatedString(translatedValue);
            parameters[0][i] = translatedValue;
          }
        }
      } else if (jsonMap['code'] == 105) {
        if (parameters.length > 3 && parameters[3] == 1) {
          print('_SCROLLTEXT_');
          _appendTranslatedString('____SHOW____');
          translationIndex++;
        } else if (parameters.length > 3 && parameters[3] == 2) {
          print('_SCROLLTEXT_\n (centrado) ');
          _appendTranslatedString('____SHOW____');
          translationIndex++;
        }
      } else if (jsonMap['code'] == 108) {
        for (var i = 0; i < parameters.length; i++) {
          final value = parameters[i];
          if (value is String) {
            final translatedValue = _getTranslatedString(value);
            final filteredTranslatedValue = translatedValue.replaceAll(RegExp(r'^(ChoiceMessage <WordWrap>|ChoiceHelp )'), '');
            print(filteredTranslatedValue);
            _appendTranslatedString(translatedValue);
            parameters[i] = translatedValue;
          }
        }
      } else if (jsonMap['code'] == 401 || jsonMap['code'] == 405) {
        for (var i = 0; i < parameters.length; i++) {
          final value = parameters[i];
          if (value is String) {
            final translatedValue = _getTranslatedString(value);
            print(translatedValue);
            _appendTranslatedString(translatedValue);
            parameters[i] = translatedValue;
          }
        }
      } else if (jsonMap['code'] == 402) {
        print("____WHEN____");
        final concatenatedParameters = parameters.join(' || ');
        print("[  $concatenatedParameters  ]");
      }
    }

    jsonMap.values.forEach((value) {
      if (value is Map<String, dynamic>) {
        _traverseJson(value);
      } else if (value is List<dynamic>) {
        _traverseList(value);
      }
    });
  }

  void _traverseList(List<dynamic> jsonList) {
    for (final item in jsonList) {
      if (item is Map<String, dynamic>) {
        _traverseJson(item);
      } else if (item is List<dynamic>) {
        _traverseList(item);
      }
    }
  }

  String _getTranslatedString(String originalString) {
    if (generateTranslationsFile) {
      if (translatedStrings.isEmpty && !emptyTranslationFile) {
        final translationsFile = File(this.translationsFile);
        if (!translationsFile.existsSync()) {
          translationsFile.createSync(recursive: true);
        } else {
          final existingTranslations = translationsFile.readAsStringSync();
          if (existingTranslations.isNotEmpty) {
            final existingLines = existingTranslations.split('\n');
            translatedStrings.addAll(existingLines);
            emptyTranslationFile = false;
          }
        }
      }

      if (translationIndex < translatedStrings.length) {
        final translation = translatedStrings[translationIndex];
        translationIndex++;
        return translation;
      }
    }

    return originalString;
  }

  void _appendTranslatedString(String translatedValue) {
    if (emptyTranslationFile) {
      final translationsFile = File(this.translationsFile);
      translationsFile.writeAsStringSync('$translatedValue\n', mode: FileMode.append);
    }
  }
}
