import 'dart:io';

class ConstanteServer {
  static String serverURL = Platform.isAndroid
      ? 'https://10.0.2.2:8000'
      : 'http://127.0.0.1:8000';
}
