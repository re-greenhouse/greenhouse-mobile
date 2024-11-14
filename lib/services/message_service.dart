import 'dart:async';
import 'package:greenhouse/config.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class MessageService {
  final String stompUrl = Config.wsActiveMQ;
  late StompClient stompClient;
  bool isConnected = false;
  Completer<void> _connectionCompleter = Completer<void>();

  // Initialize the STOMP client
  void initializeStompClient() {
    stompClient = StompClient(
      config: StompConfig(
        url: stompUrl,
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        stompConnectHeaders: {
          'login': 'greenhouse',
          'passcode': 'champi202402',
        },
        webSocketConnectHeaders: {
          'login': 'greenhouse',
          'passcode': 'champi202402',
        },
      ),
    );

    stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    isConnected = true;
    _connectionCompleter.complete();
    print('Connected to STOMP server');
  }

  Future<void> sendMessage(String company, String message) async {
    initializeStompClient();
    final topic = '/topic/$company';

    // Wait for the connection to be established
    await _connectionCompleter.future;

    if (isConnected) {
      stompClient.send(
        destination: topic,
        body: message,
      );
      print('Message sent to $topic: $message');
    } else {
      print('STOMP client is not connected. Message not sent.');
    }
  }

  void disconnectClient() {
    stompClient.deactivate();
    isConnected = false;
    _connectionCompleter = Completer<void>();
  }
}