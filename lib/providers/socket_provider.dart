import 'dart:developer';
import 'dart:io';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:process_run/shell.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class SocketProvider {
  final String bashScript = r"""
echo "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAApgAAAKYB3X3/OAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAANCSURBVEiJtZZPbBtFFMZ/M7ubXdtdb1xSFyeilBapySVU8h8OoFaooFSqiihIVIpQBKci6KEg9Q6H9kovIHoCIVQJJCKE1ENFjnAgcaSGC6rEnxBwA04Tx43t2FnvDAfjkNibxgHxnWb2e/u992bee7tCa00YFsffekFY+nUzFtjW0LrvjRXrCDIAaPLlW0nHL0SsZtVoaF98mLrx3pdhOqLtYPHChahZcYYO7KvPFxvRl5XPp1sN3adWiD1ZAqD6XYK1b/dvE5IWryTt2udLFedwc1+9kLp+vbbpoDh+6TklxBeAi9TL0taeWpdmZzQDry0AcO+jQ12RyohqqoYoo8RDwJrU+qXkjWtfi8Xxt58BdQuwQs9qC/afLwCw8tnQbqYAPsgxE1S6F3EAIXux2oQFKm0ihMsOF71dHYx+f3NND68ghCu1YIoePPQN1pGRABkJ6Bus96CutRZMydTl+TvuiRW1m3n0eDl0vRPcEysqdXn+jsQPsrHMquGeXEaY4Yk4wxWcY5V/9scqOMOVUFthatyTy8QyqwZ+kDURKoMWxNKr2EeqVKcTNOajqKoBgOE28U4tdQl5p5bwCw7BWquaZSzAPlwjlithJtp3pTImSqQRrb2Z8PHGigD4RZuNX6JYj6wj7O4TFLbCO/Mn/m8R+h6rYSUb3ekokRY6f/YukArN979jcW+V/S8g0eT/N3VN3kTqWbQ428m9/8k0P/1aIhF36PccEl6EhOcAUCrXKZXXWS3XKd2vc/TRBG9O5ELC17MmWubD2nKhUKZa26Ba2+D3P+4/MNCFwg59oWVeYhkzgN/JDR8deKBoD7Y+ljEjGZ0sosXVTvbc6RHirr2reNy1OXd6pJsQ+gqjk8VWFYmHrwBzW/n+uMPFiRwHB2I7ih8ciHFxIkd/3Omk5tCDV1t+2nNu5sxxpDFNx+huNhVT3/zMDz8usXC3ddaHBj1GHj/As08fwTS7Kt1HBTmyN29vdwAw+/wbwLVOJ3uAD1wi/dUH7Qei66PfyuRj4Ik9is+hglfbkbfR3cnZm7chlUWLdwmprtCohX4HUtlOcQjLYCu+fzGJH2QRKvP3UNz8bWk1qMxjGTOMThZ3kvgLI5AzFfo379UAAAAASUVORK5CYII=" | sed 's/data:image\/png;base64,//' | base64 -d > image.png

echo "Image saved as image.png"

""";

  // final uri = Uri(host: 'localhost', port: 3000 /* , path: 'ws://' */);
  // final uri = Uri.parse('ws://localhost:3000');
  WebSocketChannel? channel;
  void runSocketServer() async {
    try {
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
            runShellScript(bashScript, socket);
          });
        } else if (request.uri.path == '/picture') {
          final socket = await WebSocketTransformer.upgrade(request);
          print('Client connected!');

          // Listen for incoming messages from the client
          socket.listen((message) {
            print('Received message: $message');
            // socket.add('You sent: $message');

            runShellScript('python3 python_utils/photo_saver.py', socket);
          });
        } else {
          request.response.statusCode = HttpStatus.forbidden;
          request.response.close();
        }
      }
    } catch (e) {}
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
    try {
      var shell = Shell();

      List<ProcessResult> results = await shell.run(script);
      for (var result in results) {
        log(result.stdout.toString(), name: 'stdout');
        log(result.stderr.toString(), name: 'stderr');
        socket.add('out: ${result.stdout.toString()}');
        socket.add('err: ${result.stderr.toString()}');
      }
    } catch (e) {}
  }
}
