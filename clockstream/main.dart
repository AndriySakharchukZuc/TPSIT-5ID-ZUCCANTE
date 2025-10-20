import 'dart:async';

main() async {
  var stream = oscillatore(const Duration(seconds: 1));

  orologio(stream).listen((data) {
    print(data);
  });
}

Stream<int> orologio(Stream<String> oscillatore) async* {
  int seconds = 0;
  await for (final s in oscillatore) {
    yield seconds++;
  }
}

Stream<String> oscillatore(Duration interval) async* {
  while (true) {
    await Future.delayed(interval);
    yield "tick";
  }
}
