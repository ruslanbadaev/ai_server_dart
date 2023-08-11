import 'dart:developer';
import 'dart:io';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:process_run/shell.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketProvider {
  // final uri = Uri(host: 'localhost', port: 3000 /* , path: 'ws://' */);
  // final uri = Uri.parse('ws://localhost:3000');
  WebSocketChannel? channel;
  void runSocketServer() async {
    try{
    var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
    print('Listening on localhost:${server.port}');

    await for (HttpRequest request in server) {
      if (request.uri.path == '/ws') {
        final socket = await WebSocketTransformer.upgrade(request);
        print('Client connected!');

        // Listen for incoming messages from the client
        socket.listen((message) {
          print('Received message: $message');
          // socket.add('You sent: $message');
          runShellScript(message, socket);
        });
      } else if (request.uri.path == '/picture') {
        final socket = await WebSocketTransformer.upgrade(request);
        print('Client connected!');

        // Listen for incoming messages from the client
        socket.listen((message) {
          print('Received message: $message');
          // socket.add('You sent: $message');
          runShellScript(message, socket);
        });
      } else {
        request.response.statusCode = HttpStatus.forbidden;
        request.response.close();
      }
    }
        } catch (e){
      
    }
  }

//   void startImageUploadServer() async {
//   final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
//   print('Сервер запущен на порту ${server.port}');

//   await for (HttpRequest request in server) {
//     if (WebSocketTransformer.isUpgradeRequest(request)) {
//       WebSocketChannel channel = await WebSocketTransformer.upgrade(request);
//       print('Установлено новое соединение с клиентом');

//       channel.stream.listen(
//         (data) {
//           // Получение данных от клиента
//           String imageUrl = data.toString();

//           // Загрузка картинки по указанному URL
//           // В этом месте можно добавить логику загрузки и обработки картинки
//           // и отправить результат обратно клиенту через веб-сокет

//           // Отправка ответа клиенту
//           channel.sink.add('Картинка успешно загружена');
//         },
//         onDone: () {
//           // Закрытие соединения после завершения передачи данных
//           print('Соединение с клиентом закрыто');
//         },
//         onError: (error) {
//           // Обработка ошибок, если они возникнут во время передачи данных
//           print('Произошла ошибка при передаче данных: $error');
//         },
//       );
//     } else {
//       request.response.statusCode = HttpStatus.badRequest;
//       request.response.close();
//     }
//   }
// }

  void runShellScript(String script, WebSocket socket) async {

    try{
    var shell = Shell();

    List<ProcessResult> results = await shell.run(script);
    for (var result in results) {
      log(result.stdout.toString(), name: 'stdout');
      log(result.stderr.toString(), name: 'stderr');
      socket.add('out: ${result.stdout.toString()}');
      socket.add('err: ${result.stderr.toString()}');
    }
        } catch (e){
      
    }
  }
}
