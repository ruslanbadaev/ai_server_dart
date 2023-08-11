import 'dart:async';

import 'package:ai_server_dart/providers/socket_provider.dart';
import 'package:ai_server_dart/providers/static_provider.dart';

// import 'file:///Users/uesr_name/Desktop/flutterPlugin/flutterPlugin/lib/file.dart';
// import r'file:C:\Users\rusik\Desktop\projects\stable-diffusion-2\stable-diffusion\socket_provider2.dart';

Future<void> main() async {
  SocketProvider socketProvider = SocketProvider();
  // StaticProvider staticProvider = StaticProvider();

  socketProvider.runSocketServer();
  // staticProvider.runStatic();
}
