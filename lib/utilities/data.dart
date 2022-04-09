import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nyxx/nyxx.dart';
import 'package:path/path.dart';
import 'package:rpmtw_api_client/rpmtw_api_client.dart';
import 'package:rpmtw_discord_bot/model/covid19_info.dart';
import 'package:rpmtw_discord_bot/utilities/log.dart';
import 'package:rpmtw_discord_bot/utilities/extension.dart';

Snowflake get rpmtwDiscordServerID => 815819580840607807.toSnowflake();
Snowflake get logChannelID => 934595900528025640.toSnowflake();
Snowflake get siongsngUserID => 645588343228334080.toSnowflake();
Snowflake get voiceChannelID => 832895058281758740.toSnowflake();

late final Logger _logger;
Logger get logger => _logger;
late bool kDebugMode;

class Data {
  static late final Box _chefBox;
  static late final Box _covid19Box;

  static Box get chefBox => _chefBox;
  static Box get covid19Box => _covid19Box;

  static Future<void> init() async {
    load();
    RPMTWApiClient.init();
    String path = absolute(Directory.current.path, 'data');
    Hive.init(path);
    Hive.registerAdapter(Covid19InfoAdapter());
    _chefBox = await Hive.openBox('chefBox');
    _covid19Box = await Hive.openBox('covid19Box');
    await initializeDateFormatting("zh-TW");

    kDebugMode = env['DEBUG_MODE']?.toBool() ?? false;
  }

  static Future<void> initOnReady(INyxxWebsocket client) async {
    ITextChannel channel =
        await client.fetchChannel<ITextChannel>(logChannelID);
    _logger = Logger(client, channel);
  }
}
