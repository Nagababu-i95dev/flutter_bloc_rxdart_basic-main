import 'dart:async';
import 'dart:io';
import 'dart:isolate';

Future<SendPort> initIsolate() async{
  var completer = Completer<SendPort>();
  var isolateToMainStream = ReceivePort();

  isolateToMainStream.listen((message) {
    if (message is SendPort){
    SendPort  mainToIsolateStream = message;
        completer.complete(mainToIsolateStream);
    }
    else
      {
        print ('[isolateToMainStream] $message');
      }
  });

  Isolate myIsolateInstance = await Isolate.spawn(myIsolate, isolateToMainStream.sendPort);
  return completer.future;

}

void myIsolate(SendPort isolateToMainStream){
  ReceivePort mainToIsolateStream = ReceivePort();
  isolateToMainStream.send(mainToIsolateStream.sendPort);
  mainToIsolateStream.listen((message) {
    print('[mainToIsolateStream] $message');
    exit(0);
  });
  isolateToMainStream.send('This is from myIsolate()');

}