import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final _broker = 'test.mosquitto.org';
  final _port = 1883;
  final _topic = 'toxic/sprayer';

  late MqttServerClient _client;

  Function(bool isConnected)? onStatusChange;

  Future<void> connect() async {
    _client = MqttServerClient(_broker, '');
    _client.port = _port;
    _client.logging(on: false);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('toxic_sprayer_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    _client.connectionMessage = connMess;

    try {
      await _client.connect();

      if (_client.connectionStatus?.state == MqttConnectionState.connected) {
        onStatusChange?.call(true);
      } else {
        onStatusChange?.call(false);
        _client.disconnect();
      }
    } catch (e) {
      onStatusChange?.call(false);
      _client.disconnect();
    }
  }


  void _onDisconnected() {
    onStatusChange?.call(false);
  }

  void publishSpray(String sprayerId) {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString('SPRAY $sprayerId');

    _client.publishMessage(
      _topic,
      MqttQos.atMostOnce,
      builder.payload!,
    );
  }


  void disconnect() {
    _client.disconnect();
  }
}
