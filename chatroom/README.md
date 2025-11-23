# Chatroom

2 package tranne main.
- client.dart
- server.dart

## Client.dart

Classe che astrae gestione di Socket.
Socket client utilizza un buffer per accollare i blochi di testo fino a "\n".

#### Future<void> connect (String host, int port)
Avvia la connessione al server specificato

#### void send(String message)
Invia al socket messaggio di stringa.


## Server.dart

### ChatServer
La classe principeale si mette in ascolto sulla porta assegnata

#### Future<void> start()
Avvia il server e si mette in ascolto.

#### _handleConnection(Socket socket)
Metodo di callback che viene eseguito quando un client si connette.

#### void removeClient(ChatClient client)
Rimuove client da _clients

### ChatClient
Rappresenta dei client connessi. Contiene loro IP, Port e nickname.

#### _messageHandler(List<int> data)
Riceve i dati e li trasforma in string
Se il nickname e' null imposta primo messaggio come il nickname

#### _errorHandler(dynamic error) / _finishedHandler()
Gesticono la disconnessione o l'errore del client
