import 'package:easy_localization/easy_localization.dart';

extension ApiLocalization on String? {
  String get localizedApi {
    final value = this?.trim();
    if (value == null || value.isEmpty) return '';

    final key = _apiKey(value);
    final translationKey = 'api.$key';
    final translated = translationKey.tr();

    return translated == translationKey ? value : translated;
  }

  String localizedApiFallback(String fallback) {
    final value = this?.trim();
    if (value == null || value.isEmpty) return fallback.tr();
    return value.localizedApi;
  }
}

String _apiKey(String value) {
  final buffer = StringBuffer();
  var previousWasSeparator = false;

  for (final codeUnit in value.toLowerCase().codeUnits) {
    final isDigit = codeUnit >= 48 && codeUnit <= 57;
    final isLetter = codeUnit >= 97 && codeUnit <= 122;

    if (isDigit || isLetter) {
      buffer.writeCharCode(codeUnit);
      previousWasSeparator = false;
    } else if (!previousWasSeparator && buffer.isNotEmpty) {
      buffer.write('_');
      previousWasSeparator = true;
    }
  }

  var key = buffer.toString();
  if (key.endsWith('_')) key = key.substring(0, key.length - 1);
  return key.isEmpty ? 'unknown' : key;
}
