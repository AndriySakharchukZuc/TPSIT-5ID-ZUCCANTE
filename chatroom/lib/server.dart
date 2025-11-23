import 'dart:io';

class ChatServer {
  late ServerSocket _server;
  List<ChatClient> _clients = [];

  Future<void> start() async {
    _server = await ServerSocket.bind(InternetAddress.anyIPv4, 3000);
    _server.listen(_handleConnection);
  }

  void _handleConnection(Socket socket) {
    print('Connection from ${socket.remoteAddress.address}:${socket.remotePort}');
    var client = ChatClient(this, socket);
    _clients.add(client);
    socket.write("Please enter your nickname:\n");
  }

  void removeClient(ChatClient client) {
    _clients.remove(client);
  }

  void distributeMessage(ChatClient client, String message) {
    for (var c in _clients) {
      if (c != client) {
        c.write(message + "\n");
      }
    }
  }
}

class ChatClient {
  final ChatServer _server;
  late Socket _socket;
  String? _address;
  int? _port;
  String? nickname;
  final StringBuffer _buffer = StringBuffer();

  ChatClient(this._server, Socket s) {
    _socket = s;
    _address = s.remoteAddress.address;
    _port = s.remotePort;

    _socket.listen(
      _messageHandler,
      onError: _errorHandler,
      onDone: _finishedHandler,
    );
  }

  void _messageHandler(List<int> data) {
    _buffer.write(String.fromCharCodes(data));
    List<String> lines = _buffer.toString().split('\n');
    _buffer.clear();
    if (lines.last.isNotEmpty) {
      _buffer.write(lines.removeLast());
    }
    for (String line in lines) {
      String msg = line.trim();
      if (msg.isNotEmpty) {
        if (nickname == null) {
          nickname = msg;
        } else {
          String sender = nickname ?? '$_address:$_port';
          _server.distributeMessage(this, '$sender: $msg');
        }
      }
    }
  }

  void _errorHandler(dynamic error) {
    print('$_address:$_port Error: $error');
    _server.removeClient(this);
    _socket.close();
  }

  void _finishedHandler() {
    print('$_address:$_port Disconnected');
    _server.removeClient(this);
    _socket.close();
  }

  void write(String message) {
    _socket.write(message);
  }
}

void main() async {
  final server = ChatServer();
  await server.start();
}