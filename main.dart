import 'dart:convert';
import 'dart:io';

import 'package:FearHungerTranslation/models/Common/command.dart';
import 'package:FearHungerTranslation/models/actor.dart';
import 'package:FearHungerTranslation/models/animation.dart';
import 'package:FearHungerTranslation/models/armor.dart';
import 'package:FearHungerTranslation/models/class.dart';
import 'package:FearHungerTranslation/models/common_event.dart';
import 'package:FearHungerTranslation/models/enemy.dart';
import 'package:FearHungerTranslation/models/item.dart';
import 'package:FearHungerTranslation/models/map.dart';
import 'package:FearHungerTranslation/models/map_info.dart';
import 'package:FearHungerTranslation/models/skill.dart';
import 'package:FearHungerTranslation/models/state.dart';
import 'package:FearHungerTranslation/models/system.dart';
import 'package:FearHungerTranslation/models/tileset.dart';
import 'package:FearHungerTranslation/models/troop.dart';
import 'package:FearHungerTranslation/models/weapon.dart';

Future<void> main() async {
  final specificFileName = ''; // Specify the file name if you only want to run a specific file
  final translationCode = 'en'; // ISO 639-1 codes
  final generateTranslationsFile = true;

  final jsonProcessor = JsonProcessor(translationCode, generateTranslationsFile);

  await jsonProcessor.processFile(specificFileName);
}

class JsonProcessor {
  final originDirectory;
  final String translationCode;
  final String translationsDirectory;
  final String outputDirectory;
  final bool generateTranslationsFile;
  int translationIndex = 0;
  bool emptyTranslationFile = true;
  bool isExistsTranslationFile = false;
  List<String> translatedStrings = [];
  File translationsFile = File('');

  JsonProcessor(this.translationCode, this.generateTranslationsFile)
      : originDirectory = 'data',
        translationsDirectory = 'translations/$translationCode',
        outputDirectory = 'output' {
    createDirectories();
  }

  void createDirectories() {
    final translationsDirectory = Directory(this.translationsDirectory);
    if (!translationsDirectory.existsSync() && generateTranslationsFile) {
      translationsDirectory.createSync(recursive: true);
    }

    final outputDirectory = Directory(this.outputDirectory);
    if (!outputDirectory.existsSync() && generateTranslationsFile) {
      outputDirectory.createSync(recursive: true);
    }
  }

  Future<void> processFile(String fileName) async {
    if (fileName.isEmpty) {
      final directory = Directory(originDirectory);
      final files = await directory.list();
      await for (final file in files) {
        if (file is File) {
          final fileName = file.path.split('\\').last;
          await processFile(fileName);
        }
      }
    } else {
      final filePath = '$originDirectory/$fileName';

      final file = File(filePath);
      if (!await file.exists()) {
        print('The file $filePath does not exist.');
        return;
      }

      if (generateTranslationsFile) {
        translationsFile = File('$translationsDirectory/${fileName.replaceAll('.json', '.txt')}');
        isExistsTranslationFile = await translationsFile.exists();
        if (!isExistsTranslationFile) {
          await translationsFile.create(recursive: true);
          isExistsTranslationFile = true;
        } else {
          final existingTranslations = await translationsFile.readAsString();
          if (existingTranslations.isNotEmpty) {
            final existingLines = existingTranslations.split('\n');
            translatedStrings.addAll(existingLines);
            emptyTranslationFile = false;
          }
        }
      }

      final fileContent = await file.readAsString();
      final jsonData = json.decode(fileContent);

      switch (fileName) {
        case 'Actors.json':
          await processActors(jsonData);
          break;
        case 'Animations.json':
          await processAnimations(jsonData);
          break;
        case 'Armors.json':
          await processArmors(jsonData);
          break;
        case 'Classes.json':
          await processClasses(jsonData);
          break;
        case 'CommonEvents.json':
          await processCommonEvents(jsonData);
          break;
        case 'Enemies.json':
          await processEnemies(jsonData);
          break;
        case 'Items.json':
          await processItems(jsonData);
          break;
        case 'MapInfos.json':
          await processMapInfos(jsonData);
          break;
        case 'Skills.json':
          await processSkills(jsonData);
          break;
        case 'States.json':
          await processStates(jsonData);
          break;
        case 'System.json':
          await processSystem(jsonData);
          break;
        case 'Tilesets.json':
          await processTilesets(jsonData);
          break;
        case 'Troops.json':
          await processTroops(jsonData);
          break;
        case 'Weapons.json':
          await processWeapons(jsonData);
          break;
        default:
          if (fileName.startsWith('Map') && fileName.length == 11 && fileName.endsWith('.json')) {
            final mapNumber = int.tryParse(fileName.substring(3, 6));
            if (mapNumber != null && mapNumber >= 1 && mapNumber <= 186) {
              await processMaps(jsonData);
              break;
            }
          }
          print('The file $filePath is not a valid JSON file.');
          break;
      }
      await _deleteLastLine();

      if (generateTranslationsFile && !emptyTranslationFile) {
        final outputFile = File('$outputDirectory/$fileName');
        await outputFile.writeAsString(json.encode(jsonData));
      }

      translatedStrings = [];
      translationIndex = 0;
      emptyTranslationFile = true;
      isExistsTranslationFile = false;
    }

    print('Done!');
  }

  Future<String> _getTranslatedString(String originalString, {String suffix = '', String prefix = '', String? altString}) async {
    if (generateTranslationsFile && !emptyTranslationFile) {
      if (translationIndex < translatedStrings.length) {
        final translation = translatedStrings[translationIndex];
        translationIndex++;
        await _postTranslatedString(originalString, suffix: suffix, prefix: prefix, altString: altString);
        return translation;
      }
    }

    await _postTranslatedString(originalString, suffix: suffix, prefix: prefix, altString: altString);
    return originalString;
  }

  Future<void> _postTranslatedString(String translatedValue, {String suffix = '', String prefix = '', String? altString}) async {
    translationIndex++;
    altString ??= translatedValue;
    print('$prefix$altString$suffix');
    if (emptyTranslationFile && isExistsTranslationFile) {
      await translationsFile.writeAsString('$translatedValue\n', mode: FileMode.append);
    }
  }

  Future<void> _deleteLastLine() async {
    final fileContent = await translationsFile.readAsString();
    if (fileContent.isEmpty) {
      await translationsFile.delete();
      return;
    }

    if (isExistsTranslationFile) {
      final fileContentWithoutLastLine = fileContent.substring(0, fileContent.lastIndexOf('\n'));
      await translationsFile.writeAsString(fileContentWithoutLastLine);
    }
  }

  // * Actors
  Future<dynamic> processActors(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final actorData = Actor.fromJson(jsonData[i]);
      actorData.name = await _getTranslatedString(actorData.name);
      jsonData[i] = actorData.toJson();
    }
    return jsonData;
  }

  // * Animations
  Future<dynamic> processAnimations(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final animationData = Animation.fromJson(jsonData[i]);
      // animationData.name = await _getTranslatedString(animationData.name);
      print('animationData.name: ${animationData.name}');
      jsonData[i] = animationData.toJson();
    }
    return jsonData;
  }

  // * Armors
  Future<dynamic> processArmors(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final armorData = Armor.fromJson(jsonData[i]);
      // armorData.name = await _getTranslatedString(armorData.name);
      print('armorData.name: ${armorData.name}');
      jsonData[i] = armorData.toJson();
    }
    return jsonData;
  }

  // * Classes
  Future<dynamic> processClasses(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final classData = Class.fromJson(jsonData[i]);
      jsonData[i] = classData.toJson();
    }
    return jsonData;
  }

  // * CommonEvents
  Future<dynamic> processCommonEvents(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final commonEventData = CommonEvent.fromJson(jsonData[i]);
      // final list = commonEventData.list;
      await _processListCommand(commonEventData.list); // ! Check it; list debe asignarse a commonEventData.list?
      // commonEventData.list = list;
      jsonData[i] = commonEventData.toJson();
    }
    return jsonData;
  }

  // * Enemies
  Future<dynamic> processEnemies(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final enemyData = Enemy.fromJson(jsonData[i]);
      // enemyData.name = await _getTranslatedString(enemyData.name);
      print('enemyData.name: ${enemyData.name}');
      jsonData[i] = enemyData.toJson();
    }
    return jsonData;
  }

  // * Items
  Future<dynamic> processItems(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final itemData = Item.fromJson(jsonData[i]);
      // itemData.name = await _getTranslatedString(itemData.name);
      print('itemData.name: ${itemData.name}');
      jsonData[i] = itemData.toJson();
    }
    return jsonData;
  }

  // * Maps
  Future<dynamic> processMaps(Map<String, dynamic> jsonData) async {
    final mapData = DataMap.fromJson(jsonData);
    for (int i = 0; i < mapData.events.length; i++) {
      if (mapData.events[i] == null) {
        continue;
      }
      final eventData = mapData.events[i]!;
      for (int j = 0; j < eventData.pages.length; j++) {
        final pageData = eventData.pages[j];
        await _processListCommand(pageData.list);
      }
    }
    return jsonData;
  }

  // * MapInfos
  Future<dynamic> processMapInfos(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final mapInfoData = MapInfo.fromJson(jsonData[i]);
      // mapInfoData.name = await _getTranslatedString(mapInfoData.name);
      print('mapInfoData.name: ${mapInfoData.name}');
      jsonData[i] = mapInfoData;
    }
    return jsonData;
  }

  // * Skills
  Future<dynamic> processSkills(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final skillData = Skill.fromJson(jsonData[i]);
      // skillData.name = await _getTranslatedString(skillData.name);
      print('skillData.name: ${skillData.name}');
      jsonData[i] = skillData.toJson();
    }
    return jsonData;
  }

  // * States
  Future<dynamic> processStates(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final stateData = State.fromJson(jsonData[i]);
      // stateData.name = await _getTranslatedString(stateData.name);
      print('stateData.name: ${stateData.name}');
      jsonData[i] = stateData.toJson();
    }
    return jsonData;
  }

  // * System
  Future<dynamic> processSystem(Map<String, dynamic> jsonData) async {
    final systemData = System.fromJson(jsonData);
    for (int i = 0; i < systemData.armorTypes.length; i++) {
      print('systemData.armorTypes[$i]: ${systemData.armorTypes[i]}');
    }
    for (int i = 0; i < systemData.elements.length; i++) {
      print('systemData.elements[$i]: ${systemData.elements[i]}');
    }
    for (int i = 0; i < systemData.equipTypes.length; i++) {
      print('systemData.equipTypes[$i]: ${systemData.equipTypes[i]}');
    }
    for (int i = 0; i < systemData.skillTypes.length; i++) {
      print('systemData.skillTypes[$i]: ${systemData.skillTypes[i]}');
    }
    for (int i = 0; i < systemData.terms.basic.length; i++) {
      print('systemData.terms.basic[$i]: ${systemData.terms.basic[i]}');
    }
    for (int i = 0; i < systemData.terms.commands.length; i++) {
      print('systemData.terms.commands[$i]: ${systemData.terms.commands[i]}');
    }
    for (int i = 0; i < systemData.terms.params.length; i++) {
      print('systemData.terms.params[$i]: ${systemData.terms.params[i]}');
    }
    for (int i = 0; i < systemData.terms.messages.length; i++) {
      print('systemData.terms.messages[$i]: ${systemData.terms.messages[i]}');
    }
    for (int i = 0; i < systemData.weaponTypes.length; i++) {
      print('systemData.weaponTypes[$i]: ${systemData.weaponTypes[i]}');
    }
  }

  // * Tilesets
  Future<dynamic> processTilesets(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final tilesetData = Tileset.fromJson(jsonData[i]);
      // tilesetData.name = await _getTranslatedString(tilesetData.name);
      print('tilesetData.name: ${tilesetData.name}');
      jsonData[i] = tilesetData.toJson();
    }
    return jsonData;
  }

  // * Troops
  Future<dynamic> processTroops(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final troopData = Troop.fromJson(jsonData[i]);
      for (int j = 0; j < troopData.pages.length; j++) {
        final page = troopData.pages[j];
        // final list = page.list;
        await _processListCommand(page.list); // ! Check it; list debe asignarse a page.list?
        // page.list = list;
      }
      jsonData[i] = troopData.toJson();
    }
    return jsonData;
  }

  // * Weapons
  Future<dynamic> processWeapons(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] is! Map<String, dynamic>) {
        continue;
      }
      final weaponData = Weapon.fromJson(jsonData[i]);
      // weaponData['name'] = await _getTranslatedString(weaponData['name']);
      print('weaponData.name: ${weaponData.name}');
      jsonData[i] = weaponData;
    }
    return jsonData;
  }

  Future<void> _processListCommand(dynamic list) async {
    for (int i = 0; i < list.length; i++) {
      final commandData = list[i];
      int? nextCode;

      if (i + 1 < list.length) {
        final nextCommandData = list[i + 1];
        if (nextCommandData is Map<String, dynamic>) {
          nextCode = nextCommandData['code'] as int?;
        } else if (nextCommandData is Command) {
          nextCode = nextCommandData.code;
        }
      }

      if (commandData is Map<String, dynamic>) {
        await _processCommandMap(commandData, nextCode);
      } else if (commandData is List<dynamic>) {
        await _processListCommand(commandData);
      } else if (commandData is Command) {
        await _processCommandMap(commandData.toJson(), nextCode);
      }
    }
  }

  Future<void> _processCommandMap(Map<String, dynamic> commandData, int? nextCode) async {
    final parameters = commandData['parameters'];
    if (commandData['code'] == 101) {
      final positionMap = {
        0: ' (superior) ',
        1: ' (centrado) ',
        2: ' (inferior) ',
      };
      final position = parameters[3] as int;
      final positionText = positionMap[position];
      await _postTranslatedString('____TEXT____', suffix: '\n$positionText');
    } else if (commandData['code'] == 102) {
      await _postTranslatedString('___CHOICE___');
      for (var i = 0; i < parameters[0].length; i++) {
        final value = parameters[0][i];
        if (value is String) {
          final translatedValue = await _getTranslatedString(value, prefix: '(•) ');
          parameters[0][i] = translatedValue;
        }
      }
    } else if (commandData['code'] == 105) {
      // final positionMap = {
      //   0: ' (superior) ',
      //   1: ' (centrado) ',
      //   2: ' (inferior) ',
      // };
      // final position = parameters[3] as int;
      // final positionText = positionMap[position];
      await _postTranslatedString('____SHOW____', /*suffix: '\n$positionText',*/ altString: '_SCROLLTEXT_');
    } else if (commandData['code'] == 108) {
      for (var i = 0; i < parameters.length; i++) {
        final value = parameters[i];
        if (value is String) {
          // ? ¿Es necesario el if?
          final translatedValue = await _getTranslatedString(value);
          // final filteredTranslatedValue = translatedValue.replaceAll(RegExp(r'^(ChoiceMessage <WordWrap>|ChoiceHelp )'), '');
          // await _postTranslatedString(translatedValue);
          parameters[i] = translatedValue;
        } else {
          Exception('No es un String');
        }
      }
    } else if (commandData['code'] == 401 || commandData['code'] == 405) {
      for (var i = 0; i < parameters.length; i++) {
        final value = parameters[i];
        if (value is String) {
          final translatedValue = await _getTranslatedString(value);
          parameters[i] = translatedValue;
        }
      }
    } else if (commandData['code'] == 402 && nextCode == 101) {
      final concatenatedParameters = parameters.join(' || ');
      print("____WHEN____\n[  $concatenatedParameters  ]");
    } else if (parameters is List<dynamic>) {
      _processListCommand(parameters);
    }
  }

  // Future<String> _escapeSpecialCharacters(String value) async {
  //   final escapedValue = value.replaceAllMapped(RegExp(r'[\n\r\t]'), (match) {
  //     final specialCharacter = match.group(0);
  //     switch (specialCharacter) {
  //       case '\n':
  //         return '\\n';
  //       case '\r':
  //         return '\\r';
  //       case '\t':
  //         return '\\t';
  //       default:
  //         return specialCharacter!;
  //     }
  //   });

  //   return escapedValue;
  // }

  // Future<String> _unescapeSpecialCharacters(String value) async {
  //   final unescapedValue = value.replaceAllMapped(RegExp(r'\\[nrt]'), (match) {
  //     final escapedCharacter = match.group(0);
  //     switch (escapedCharacter) {
  //       case '\\n':
  //         return '\n';
  //       case '\\r':
  //         return '\r';
  //       case '\\t':
  //         return '\t';
  //       default:
  //         return escapedCharacter!;
  //     }
  //   });

  //   return unescapedValue;
  // }
}
