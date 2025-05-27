import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  late IO.Socket socket;
  bool isConnected = false;

  SocketService._internal();
  // Android emulator:
  // final String baseUrl = 'http://10.0.2.2:3300/api/auth';
  final String baseUrl = 'https://api.connectmytask.xyz/api/messages';

  void connect() {

    if (isConnected) return; 
    socket = IO.io(
      // "http://10.0.2.2:3300/api",
      'https://api.connectmytask.xyz', // ← your server IP here
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('📡 Socket connected');
    });

    socket.onDisconnect((_) {
      print('❌ Socket disconnected');
    });
  }

  void onReceiveMessage(Function(dynamic) callback) {
    socket.on('receiveMessage', callback);
    print('📡 received message');
  }

  void dispose() {
    socket.dispose();
  }
}
