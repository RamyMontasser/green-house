import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late HubConnection connection;

  final _controller = StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  Future<void> init() async {
    connection = HubConnectionBuilder()
        .withUrl("http://touchofnature.runasp.net/hubs/greenhouse")
        .withAutomaticReconnect()
        .build();

    connection.on("ReceiveSensorData", (data) {
      if (data != null && data.isNotEmpty) {
        final sensor = Map<String, dynamic>.from(data[0] as Map);
        _controller.add(sensor);
      }
    });

    await connection.start();
    debugPrint("SignalR Connected");
  }

  Future<void> stop() async {
    await connection.stop();
    await _controller.close();
  }
}
