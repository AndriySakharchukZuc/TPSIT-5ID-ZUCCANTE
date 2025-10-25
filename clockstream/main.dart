import 'dart:async';
import 'dart:io';

main() async {
  var stream = ticker(const Duration(seconds: 1));
  var prova1 = 0;
  orologio(stream).listen((data) {
    prova1 += data;
  });
}

Stream<int> orologio(Stream<int> oscillatore) async* {
  int seconds = 0;
  await for (final s in oscillatore) {
    yield seconds++;
  }
}

Stream<int> ticker(Duration interval) async* {
  while (true) {
    await Future.delayed(interval);
    yield 1;
  }
}
