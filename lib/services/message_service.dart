import 'dart:async';
import 'dart:convert';
import 'package:greenhouse/config.dart';
import 'package:greenhouse/models/record.dart';
import 'package:greenhouse/services/user_preferences.dart';
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

  Future<void> sendMessage(String company, String message, String action, String cropId, String phase, {String? recordId, Payload? payload, List<Map<String, dynamic>>? differences}) async {
    initializeStompClient();
    final profileId = await UserPreferences.getProfileId();
    final topic = '/topic/$company';

    // Wait for the connection to be established
    await _connectionCompleter.future;
    phase = phase.toLowerCase();
    if (phase == 'preparation area') {
      phase = 'preparation_area';
    }
    if (isConnected) {
      final body = jsonEncode({
        'message': message,
        'action': action,
        'profileId': profileId,
        'cropId': cropId,
        'phase': phase,
        'recordId': recordId ?? '',
        'payload': payload ?? {},
        'differences': differences ?? [],
      });
      stompClient.send(
        destination: topic,
        body: body,
      );
      print('Message sent to $topic: $message');
    } else {
      print('STOMP client is not connected. Message not sent.');
    }
  }

  /*Future<void> sendUpdateRecordMessage(String company, String cropId, String phase, String recordId, Payload payload) async {
    initializeStompClient();
    final profileId = await UserPreferences.getProfileId();
    final user = await UserPreferences.getUsername();
    final topic = '/topic/$company/update';
    const action = 'edit';
    final message = "$user esta solicitando corregir un registro";

    // Wait for the connection to be established
    await _connectionCompleter.future;
    phase = phase.toLowerCase();
    if (phase == 'preparation area') {
      phase = 'preparation_area';
    }
    if (isConnected) {
      final body = jsonEncode({
        'message': message,
        'action': action,
        'profileId': profileId,
        'cropId': cropId,
        'phase': phase,
        'recordId': recordId,
        'payload': payload,
      });
      stompClient.send(
        destination: topic,
        body: body,
      );
      print('Message sent to $topic: $message');
    } else {
      print('STOMP client is not connected. Message not sent.');
    }
  }*/

  void disconnectClient() {
    stompClient.deactivate();
    isConnected = false;
    _connectionCompleter = Completer<void>();
  }
}