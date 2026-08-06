import 'dart:convert';

abstract final class JwtDecoder {
  const JwtDecoder._();

  /// Returns true if the given JWT token is expired (or malformed).
  /// Uses a 10-second buffer to consider tokens expiring very soon as expired.
  static bool isExpired(String token) {
    if (token.isEmpty) return true;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payloadStr = _decodeBase64(parts[1]);
      final payloadMap = jsonDecode(payloadStr);

      if (payloadMap is! Map<String, dynamic> || !payloadMap.containsKey('exp')) {
        return false;
      }

      final exp = payloadMap['exp'];
      if (exp is! int) return false;

      final currentTimeInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // 10 second safety buffer
      return currentTimeInSeconds >= (exp - 10);
    } catch (_) {
      return true;
    }
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string');
    }
    return utf8.decode(base64Url.decode(output));
  }
}
