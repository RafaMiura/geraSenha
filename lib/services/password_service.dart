import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class PasswordService {
  // Webservice para geração de senhas
  static const String _apiUrl = 'https://api.passwordwolf.com/';

  /// Gera uma senha usando webservice
  static Future<String> generatePasswordFromWebService({
    int length = 12,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecialChars = true,
  }) async {
    try {
      final params = {
        'length': length.toString(),
        'upper': includeUppercase.toString(),
        'lower': includeLowercase.toString(),
        'numbers': includeNumbers.toString(),
        'special': includeSpecialChars.toString(),
        'repeat': '1',
      };

      final uri = Uri.parse(_apiUrl).replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data[0]['password'] as String;
        }
      }

      // Fallback para geração local se o webservice falhar
      return _generatePasswordLocally(
        length: length,
        includeUppercase: includeUppercase,
        includeLowercase: includeLowercase,
        includeNumbers: includeNumbers,
        includeSpecialChars: includeSpecialChars,
      );
    } catch (e) {
      // Fallback para geração local em caso de erro
      return _generatePasswordLocally(
        length: length,
        includeUppercase: includeUppercase,
        includeLowercase: includeLowercase,
        includeNumbers: includeNumbers,
        includeSpecialChars: includeSpecialChars,
      );
    }
  }

  /// Gera senha localmente como fallback
  static String _generatePasswordLocally({
    int length = 12,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecialChars = true,
  }) {
    String chars = '';

    if (includeUppercase) chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (includeLowercase) chars += 'abcdefghijklmnopqrstuvwxyz';
    if (includeNumbers) chars += '0123456789';
    if (includeSpecialChars) chars += '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    if (chars.isEmpty) {
      chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    }

    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Gera senha local simples (método original)
  static String generatePasswordSimple({int length = 12}) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
