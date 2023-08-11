import 'dart:developer';
import 'dart:io';

// import 'package:dart_frog/dart_frog.dart';
// import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:alfred/alfred.dart';
import 'package:process_run/shell.dart';

class StaticProvider {
  void runStatic() async {
    final app = Alfred();

    /// Note the wildcard (*) this is very important!!
    app.get('/public/*', (req, res) => Directory('outputs'));
    app.get('/ls', (req, res) async {
      String data = await runShellScript('dir /a outputs');
      await res.send(data);
    });

    await app.listen(3001);
  }

  Future<String> runShellScript(String script) async {


        String resultsString = '';
        try {
    var shell = Shell();

    List<ProcessResult> results = await shell.run(script);

    for (var result in results) {
      log(result.stdout.toString(), name: 'stdout');

      resultsString += result.stdout;
    }
        } catch (e){
      
    }
    return resultsString;
  }
}
