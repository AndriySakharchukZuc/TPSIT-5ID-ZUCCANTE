import 'dart:io';

class SocketClient {
  late Socket _socket;
  final StringBuffer _buffer = StringBuffer();
  Function(String)? onMessageReceived;

  Future<void> connect(String host, int port) async {
    try {
      _socket = await Socket.connect(host, port);
      _socket.listen(
        _dataHandler,
        onError: _errorHandler,
        onDone: _doneHandler,
        cancelOnError: false,
      );
    } catch (e) {
      print("Unable to connect: $e");
    }
  }

  void _dataHandler(List<int> data) {
    _buffer.write(String.fromCharCodes(data));
    List<String> lines = _buffer.toString().split('\n');
    _buffer.clear();
    _buffer.write(lines.removeLast());
    for (String line in lines) {
      String trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        onMessageReceived?.call(trimmed);
      }
    }
  }

  void _errorHandler(dynamic error, StackTrace trace) {
    print(error);
  }

  void _doneHandler() {
    _socket.destroy();
  }

  void send(String message) {
    _socket.write('$message\n');
  }
}