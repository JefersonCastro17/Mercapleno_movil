// Minimal ApiClient stub for local module analysis and development.

class ApiClient {
  ApiClient();

  /// Simulate a GET request. Override with real implementation when integrating.
  Future<Map<String, dynamic>> get(String path) async {
    return <String, dynamic>{};
  }

  /// Simulate a POST request. Override with real implementation when integrating.
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    return <String, dynamic>{};
  }
}
