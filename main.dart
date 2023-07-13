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
  final translationCode = 'es-ES'; // ISO 639-1 codes
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
  bool emptyTranslationFile = true;
  bool isExistsTranslationFile = false;
  Map<String, dynamic> translatedStrings = {};
  File translationsFile = File('');
  Map<String, String> outputJson = {};
  List<String> currentPath = [];

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
          if (fileName.endsWith('.json')) {
            await processFile(fileName);
          }
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
        translationsFile = File('$translationsDirectory/${fileName}');
        isExistsTranslationFile = await translationsFile.exists();
        if (!isExistsTranslationFile) {
          await translationsFile.create(recursive: true);
          isExistsTranslationFile = true;
        } else {
          final existingTranslations = await translationsFile.readAsString();
          if (existingTranslations.isNotEmpty) {
            translatedStrings = json.decode(existingTranslations);
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
              currentPath.add(fileName.substring(0, 6));
              await processMaps(jsonData);
              await currentPath.removeLast();
              break;
            }
          }
          print('The file $filePath is not a valid JSON file.');
          break;
      }
      await _deleteEmpty();

      if (generateTranslationsFile && !emptyTranslationFile) {
        final outputFile = File('$outputDirectory/$fileName');
        await outputFile.writeAsString(json.encode(jsonData));
      }

      if (translatedStrings.isNotEmpty && emptyTranslationFile) {
        await translationsFile.writeAsString(JsonEncoder.withIndent('  ').convert(translatedStrings));
      }

      translatedStrings.clear();
      emptyTranslationFile = true;
      isExistsTranslationFile = false;
    }

    if (generateTranslationsFile) print('The file $fileName has been processed.');
  }

  Future<String> _getTranslatedString(String originalString, String nameAttr, {String? altString}) async {
    currentPath.add(nameAttr);
    if (generateTranslationsFile && !emptyTranslationFile) {
      final translation = translatedStrings[currentPath.join('.')] ?? originalString;
      await _postTranslatedString(originalString, altString: translation);
      await currentPath.removeLast();
      return translation;
    }

    await _postTranslatedString(originalString, altString: altString);
    await currentPath.removeLast();
    return originalString;
  }

  Future<void> _postTranslatedString(String translatedValue, {String? altString}) async {
    if (!generateTranslationsFile) {
      altString ??= translatedValue;
      print('$altString');
    }
    if (emptyTranslationFile && isExistsTranslationFile) {
      final String path = currentPath.join('.');
      translatedStrings[path] = translatedValue;
    }
  }

  Future<void> _deleteEmpty() async {
    if (!isExistsTranslationFile) return;
    final fileContent = await translationsFile.readAsString();
    if (fileContent.isEmpty) {
      await translationsFile.delete();
      return;
    }
  }

  // * Actors
  Future<void> processActors(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final actorData = Actor.fromJson(jsonData[i]);
      actorData.name = await _getTranslatedString(actorData.name, 'Actor[$i].name');
      jsonData[i] = actorData.toJson();
    }
  }

  // * Animations
  Future<void> processAnimations(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final animationData = Animation.fromJson(jsonData[i]);
      jsonData[i] = animationData.toJson();
    }
  }

  // * Armors
  Future<void> processArmors(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final armorData = Armor.fromJson(jsonData[i]);
      armorData.name = await _getTranslatedString(armorData.name, 'Armor[$i].name');
      armorData.description = await _getTranslatedString(armorData.description, 'Armor[$i].description');
      jsonData[i] = armorData.toJson();
    }
  }

  // * Classes
  Future<void> processClasses(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final classData = Class.fromJson(jsonData[i]);
      print('Classes[$i].name: ${classData.name}'); // ! Check it
      print('Classes[$i].note: ${classData.note}'); // ! Check it
      jsonData[i] = classData.toJson();
    }
  }

  // * CommonEvents
  Future<void> processCommonEvents(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final commonEventData = CommonEvent.fromJson(jsonData[i]);
      currentPath.add('CommonEvent[$i]');
      await _processListCommand(commonEventData.list);
      jsonData[i] = commonEventData.toJson();
      await currentPath.removeLast();
    }
  }

  // * Enemies
  Future<void> processEnemies(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final enemyData = Enemy.fromJson(jsonData[i]);
      enemyData.name = await _getTranslatedString(enemyData.name, 'Enemy[$i].name');
      jsonData[i] = enemyData.toJson();
    }
  }

  // * Items
  Future<void> processItems(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final itemData = Item.fromJson(jsonData[i]);
      itemData.name = await _getTranslatedString(itemData.name, 'Item[$i].name');
      itemData.description = await _getTranslatedString(itemData.description, 'Item[$i].description');
      jsonData[i] = itemData.toJson();
    }
  }

  // * Maps
  Future<void> processMaps(Map<String, dynamic> jsonData) async {
    if (jsonData['events'] is bool) {
      return;
    }
    final mapData = DataMap.fromJson(jsonData);
    for (int i = 0; i < mapData.events.length; i++) {
      if (mapData.events[i] == null) {
        continue;
      }
      final eventData = mapData.events[i]!;
      for (int j = 0; j < eventData.pages.length; j++) {
        final pageData = eventData.pages[j];
        currentPath.add('Event[$i].Page[$j].list');
        await _processListCommand(pageData.list);
        await currentPath.removeLast();
      }
    }
  }

  // * MapInfos
  Future<void> processMapInfos(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final mapInfoData = MapInfo.fromJson(jsonData[i]);
      jsonData[i] = mapInfoData;
    }
  }

  // * Skills
  Future<void> processSkills(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final skillData = Skill.fromJson(jsonData[i]);
      skillData.name = await _getTranslatedString(skillData.name, 'Skill[$i].name');
      skillData.description = await _getTranslatedString(skillData.description, 'Skill[$i].description');
      skillData.note = await _getTranslatedString(skillData.note, 'Skill[$i].note');
      skillData.message1 = await _getTranslatedString(skillData.message1, 'Skill[$i].message1');
      skillData.message2 = await _getTranslatedString(skillData.message2, 'Skill[$i].message2');
      jsonData[i] = skillData.toJson();
    }
  }

  // * States
  Future<void> processStates(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final stateData = State.fromJson(jsonData[i]);
      stateData.name = await _getTranslatedString(stateData.name, 'State[$i].name');
      if (stateData.description != null) {
        stateData.description = await _getTranslatedString(stateData.description!, 'State[$i].description');
      }
      stateData.note = await _getTranslatedString(stateData.note, 'State[$i].note');
      stateData.message1 = await _getTranslatedString(stateData.message1, 'State[$i].message1');
      stateData.message2 = await _getTranslatedString(stateData.message2, 'State[$i].message2');
      stateData.message3 = await _getTranslatedString(stateData.message3, 'State[$i].message3');
      stateData.message4 = await _getTranslatedString(stateData.message4, 'State[$i].message4');
      jsonData[i] = stateData.toJson();
    }
  }

  // * System
  Future<void> processSystem(Map<String, dynamic> jsonData) async {
    final systemData = System.fromJson(jsonData);
    for (int i = 0; i < systemData.armorTypes.length; i++) {
      systemData.armorTypes[i] = await _getTranslatedString(systemData.armorTypes[i], 'System.armorTypes[$i]');
    }
    for (int i = 0; i < systemData.elements.length; i++) {
      systemData.elements[i] = await _getTranslatedString(systemData.elements[i], 'System.elements[$i]');
    }
    for (int i = 0; i < systemData.equipTypes.length; i++) {
      systemData.equipTypes[i] = await _getTranslatedString(systemData.equipTypes[i], 'System.equipTypes[$i]');
    }
    systemData.gameTitle = await _getTranslatedString(systemData.gameTitle, 'System.gameTitle');
    for (int i = 0; i < systemData.skillTypes.length; i++) {
      systemData.skillTypes[i] = await _getTranslatedString(systemData.skillTypes[i], 'System.skillTypes[$i]');
    }
    for (int i = 0; i < systemData.terms.basic.length; i++) {
      systemData.terms.basic[i] = await _getTranslatedString(systemData.terms.basic[i], 'System.terms.basic[$i]');
    }
    for (int i = 0; i < systemData.terms.commands.length; i++) {
      final command = systemData.terms.commands[i];
      if (command != null) {
        systemData.terms.commands[i] = await _getTranslatedString(command, 'System.terms.commands[$i]');
      }
    }
    for (int i = 0; i < systemData.terms.params.length; i++) {
      await _getTranslatedString(systemData.terms.params[i], 'System.terms.params[$i]');
    }
    for (int i = 0; i < systemData.terms.messages.keys.length; i++) {
      final key = systemData.terms.messages.keys.elementAt(i);
      systemData.terms.messages[key] = await _getTranslatedString(systemData.terms.messages[key]!, 'System.terms.messages[$key]');
    }
    for (int i = 0; i < systemData.weaponTypes.length; i++) {
      systemData.weaponTypes[i] = await _getTranslatedString(systemData.weaponTypes[i], 'System.weaponTypes[$i]');
    }
    jsonData.clear();
    jsonData.addAll(systemData.toJson());
  }

  // * Tilesets
  Future<void> processTilesets(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final tilesetData = Tileset.fromJson(jsonData[i]);
      // tilesetData.name = await _getTranslatedString(tilesetData.name, 'Tileset[$i].name');
      // print('tilesetData.name: ${tilesetData.name}');
      jsonData[i] = tilesetData.toJson();
    }
  }

  // * Troops
  Future<void> processTroops(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] == null) {
        continue;
      }
      final troopData = Troop.fromJson(jsonData[i]);
      for (int j = 0; j < troopData.pages.length; j++) {
        final page = troopData.pages[j];
        currentPath.add('Troop[$i].pages[$j]');
        await _processListCommand(page.list);
        await currentPath.removeLast();
      }
      jsonData[i] = troopData.toJson();
    }
  }

  // * Weapons
  Future<void> processWeapons(List<dynamic> jsonData) async {
    for (int i = 0; i < jsonData.length; i++) {
      if (jsonData[i] is! Map<String, dynamic>) {
        continue;
      }
      final weaponData = Weapon.fromJson(jsonData[i]);
      weaponData.name = await _getTranslatedString(weaponData.name, 'Weapon[$i].name');
      weaponData.description = await _getTranslatedString(weaponData.description, 'Weapon[$i].description');
      weaponData.note = await _getTranslatedString(weaponData.note, 'Weapon[$i].note');
      jsonData[i] = weaponData;
    }
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
        currentPath.add('command[$i]');
        await _processCommandMap(commandData, nextCode);
        await currentPath.removeLast();
      } else if (commandData is List<dynamic>) {
        currentPath.add('list[$i]');
        await _processListCommand(commandData);
        await currentPath.removeLast();
      } else if (commandData is Command) {
        currentPath.add('command[$i]');
        await _processCommandMap(commandData.toJson(), nextCode);
        await currentPath.removeLast();
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
      await _postTranslatedString('____TEXT____', altString: '____TEXT____\n$positionText');
    } else if (commandData['code'] == 102) {
      await _postTranslatedString('___CHOICE___');
      for (var i = 0; i < parameters[0].length; i++) {
        final value = parameters[0][i];
        if (value is String) {
          final translatedValue = await _getTranslatedString(value, 'textChoice[$i]', altString: '(•) $value');
          parameters[0][i] = translatedValue;
        }
      }
    } else if (commandData['code'] == 105) {
      await _postTranslatedString('_SCROLLTEXT_');
    } else if (commandData['code'] == 108) {
      for (var i = 0; i < parameters.length; i++) {
        final value = parameters[i];
        final translatedValue = await _getTranslatedString(value, 'textComment');
        parameters[i] = translatedValue;
      }
    } else if (commandData['code'] == 401 || commandData['code'] == 405) {
      for (var i = 0; i < parameters.length; i++) {
        final value = parameters[i];
        if (value is String) {
          final translatedValue = await _getTranslatedString(value, 'textData');
          parameters[i] = translatedValue;
        }
      }
    } else if (commandData['code'] == 402 && nextCode == 101 && !generateTranslationsFile) {
      final concatenatedParameters = parameters.join(' || ');
      print("____WHEN____\n[  $concatenatedParameters  ]");
    } else if (parameters is List<dynamic>) {
      _processListCommand(parameters);
    }
  }
}
