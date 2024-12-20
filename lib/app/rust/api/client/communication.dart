// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.4.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<SplitSink < WebSocketStream < impl AsyncRead + AsyncWrite + Unpin > , Message >>>
abstract class SplitSinkWebSocketStreamImplAsyncReadAsyncWriteUnpinMessage
    implements RustOpaqueInterface {}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<SplitStream < WebSocketStream < MaybeTlsStream < TcpStream > > >>>
abstract class SplitStreamWebSocketStreamMaybeTlsStreamTcpStream
    implements RustOpaqueInterface {}

class WebSocketClient {
  final String url;

  const WebSocketClient({
    required this.url,
  });

  Future<void> connectToServer() => RustLib.instance.api
          .crateApiClientCommunicationWebSocketClientConnectToServer(
        that: this,
      );

  static Future<void> handleIncomingMessages(
          {required SplitStreamWebSocketStreamMaybeTlsStreamTcpStream read}) =>
      RustLib.instance.api
          .crateApiClientCommunicationWebSocketClientHandleIncomingMessages(
              read: read);

  // HINT: Make it `#[frb(sync)]` to let it become the default constructor of Dart class.
  static Future<WebSocketClient> newInstance(
          {required String ip, required int port}) =>
      RustLib.instance.api
          .crateApiClientCommunicationWebSocketClientNew(ip: ip, port: port);

  static Future<void> readAndSendMessages(
          {required SplitSinkWebSocketStreamImplAsyncReadAsyncWriteUnpinMessage
              write}) =>
      RustLib.instance.api
          .crateApiClientCommunicationWebSocketClientReadAndSendMessages(
              write: write);

  @override
  int get hashCode => url.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WebSocketClient &&
          runtimeType == other.runtimeType &&
          url == other.url;
}
