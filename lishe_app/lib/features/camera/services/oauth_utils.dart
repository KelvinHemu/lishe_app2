import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// Utility class for handling OAuth 1.0 authentication
class OAuthUtils {
  final String consumerKey;
  final String consumerSecret;
  String accessToken;
  String accessTokenSecret;

  // OAuth endpoints
  static const String _requestTokenUrl =
      'https://authentication.fatsecret.com/oauth/request_token';
  static const String _authorizeUrl =
      'https://authentication.fatsecret.com/oauth/authorize';
  static const String _accessTokenUrl =
      'https://authentication.fatsecret.com/oauth/access_token';

  OAuthUtils({
    required this.consumerKey,
    required this.consumerSecret,
    this.accessToken = '',
    this.accessTokenSecret = '',
  });

  /// Get request token for 3-legged OAuth
  Future<Map<String, String>> getRequestToken(
      {String callbackUrl = 'oob'}) async {
    final params = {
      'oauth_callback': callbackUrl,
    };

    final response = await makeRequest(
      method: 'POST',
      url: _requestTokenUrl,
      parameters: params,
      includeOAuthToken: false,
    );

    if (response.statusCode == 200) {
      final tokenData = Uri.splitQueryString(response.body);
      return tokenData;
    } else {
      throw Exception('Failed to get request token: ${response.statusCode}');
    }
  }

  /// Get authorization URL for user to approve access
  String getAuthorizationUrl(String requestToken) {
    return '$_authorizeUrl?oauth_token=$requestToken';
  }

  /// Exchange request token for access token
  Future<Map<String, String>> getAccessToken({
    required String requestToken,
    required String requestTokenSecret,
    required String verifier,
  }) async {
    // Update temporary credentials
    accessToken = requestToken;
    accessTokenSecret = requestTokenSecret;

    final params = {
      'oauth_verifier': verifier,
    };

    final response = await makeRequest(
      method: 'POST',
      url: _accessTokenUrl,
      parameters: params,
    );

    if (response.statusCode == 200) {
      final tokenData = Uri.splitQueryString(response.body);
      // Update permanent credentials
      accessToken = tokenData['oauth_token'] ?? '';
      accessTokenSecret = tokenData['oauth_token_secret'] ?? '';
      return tokenData;
    } else {
      throw Exception('Failed to get access token: ${response.statusCode}');
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated =>
      accessToken.isNotEmpty && accessTokenSecret.isNotEmpty;

  /// Clear authentication tokens
  void clearAuthentication() {
    accessToken = '';
    accessTokenSecret = '';
  }

  /// Generate a nonce for OAuth 1.0
  String generateNonce() {
    final random = Random.secure();
    final nonce = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Encode(nonce).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  /// Generate timestamp for OAuth 1.0
  String generateTimestamp() {
    return (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
  }

  /// Percent encode a string according to RFC3986
  String percentEncode(String input) {
    return Uri.encodeComponent(input)
        .replaceAll('+', '%20')
        .replaceAll('*', '%2A')
        .replaceAll('%7E', '~');
  }

  /// Create the signature base string for OAuth 1.0
  String createSignatureBaseString({
    required String method,
    required String url,
    required Map<String, String> parameters,
  }) {
    // Sort parameters by name and value
    final sortedParams = parameters.keys.toList()..sort();
    final normalizedParams = sortedParams.map((key) {
      return '$key=${percentEncode(parameters[key]!)}';
    }).join('&');

    // Create signature base string
    return [
      method.toUpperCase(),
      percentEncode(url),
      percentEncode(normalizedParams),
    ].join('&');
  }

  /// Generate the OAuth 1.0 signature
  String generateSignature({
    required String method,
    required String url,
    required Map<String, String> parameters,
  }) {
    final signatureBaseString = createSignatureBaseString(
      method: method,
      url: url,
      parameters: parameters,
    );

    // Create signing key
    final signingKey = [
      percentEncode(consumerSecret),
      percentEncode(accessTokenSecret),
    ].join('&');

    // Generate HMAC-SHA1 signature
    final hmac = Hmac(sha1, utf8.encode(signingKey));
    final signature = hmac.convert(utf8.encode(signatureBaseString));
    return base64Encode(signature.bytes);
  }

  /// Make an OAuth 1.0 signed request
  Future<http.Response> makeRequest({
    required String method,
    required String url,
    required Map<String, String> parameters,
    bool includeOAuthToken = true,
  }) async {
    final headers = generateOAuthHeaders(
      method: method,
      url: url,
      parameters: parameters,
      includeOAuthToken: includeOAuthToken,
    );

    if (method.toUpperCase() == 'GET') {
      final queryString = parameters.entries
          .map((e) => '${e.key}=${percentEncode(e.value)}')
          .join('&');
      final fullUrl = '$url?$queryString';
      return await http.get(Uri.parse(fullUrl), headers: headers);
    } else {
      return await http.post(
        Uri.parse(url),
        headers: headers,
        body: parameters,
      );
    }
  }

  /// Add OAuth 1.0 headers to a request
  Map<String, String> generateOAuthHeaders({
    required String method,
    required String url,
    required Map<String, String> parameters,
    bool includeOAuthToken = true,
  }) {
    final timestamp = generateTimestamp();
    final nonce = generateNonce();

    // Add OAuth parameters
    final oauthParams = {
      'oauth_consumer_key': consumerKey,
      'oauth_nonce': nonce,
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp': timestamp,
      'oauth_version': '1.0',
      if (includeOAuthToken && accessToken.isNotEmpty)
        'oauth_token': accessToken,
      ...parameters,
    };

    // Generate signature
    final signature = generateSignature(
      method: method,
      url: url,
      parameters: oauthParams,
    );

    // Create Authorization header
    final authParams = {
      'oauth_consumer_key': consumerKey,
      'oauth_nonce': nonce,
      'oauth_signature': percentEncode(signature),
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp': timestamp,
      'oauth_version': '1.0',
      if (includeOAuthToken && accessToken.isNotEmpty)
        'oauth_token': accessToken,
    };

    final authHeader =
        authParams.entries.map((e) => '${e.key}="${e.value}"').join(',');

    return {
      'Authorization': 'OAuth $authHeader',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
  }
}
