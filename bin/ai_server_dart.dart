import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ai_server_dart/providers/socket_provider.dart';
import 'package:ai_server_dart/providers/static_provider.dart';
import 'package:alfred/alfred.dart';
import 'package:alfred/src/type_handlers/websocket_type_handler.dart';
import 'package:process_run/shell.dart';
import 'package:ai_server_dart/ai_server_dart.dart' as ai_server_dart;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
// import 'file:///Users/uesr_name/Desktop/flutterPlugin/flutterPlugin/lib/file.dart';
// import r'file:C:\Users\rusik\Desktop\projects\stable-diffusion-2\stable-diffusion\socket_provider2.dart';

Future<void> main() async {
  SocketProvider socketProvider = SocketProvider();
  StaticProvider staticProvider = StaticProvider();

  socketProvider.runSocketServer();
  staticProvider.runStatic();
}
