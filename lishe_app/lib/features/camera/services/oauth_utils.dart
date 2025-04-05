import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Utility class for OAuth signature generation
class OAuthUtils {
  /// Generate OAuth signature using HMAC-SHA1
  static String generateSignature(
    String method,
    String url,
    Map<String, dynamic> params,
    String consumerSecret,
    String? tokenSecret,
  ) {
    // Sort parameters alphabetically
    final sortedParams = params.keys.toList()..sort();
    final paramString = sortedParams
        .map((key) => '$key=${Uri.encodeComponent(params[key].toString())}')
        .join('&');

    // Create signature base string
    final signatureBaseString = [
      method.toUpperCase(),
      Uri.encodeComponent(url),
      Uri.encodeComponent(paramString),
    ].join('&');

    // Create signing key
    final signingKey = [
      Uri.encodeComponent(consumerSecret),
      tokenSecret != null ? Uri.encodeComponent(tokenSecret) : '',
    ].join('&');

    // Generate HMAC-SHA1 signature
    final hmac = Hmac(sha1, utf8.encode(signingKey));
    final signature = hmac.convert(utf8.encode(signatureBaseString));

    // Base64 encode the signature
    return base64Encode(signature.bytes);
  }

  /// Generate a random nonce for OAuth
  static String generateNonce() {
    final random = Random.secure();
    final nonce = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Encode(nonce).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  /// Generate current timestamp for OAuth
  static String generateTimestamp() {
    return (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  }
}
