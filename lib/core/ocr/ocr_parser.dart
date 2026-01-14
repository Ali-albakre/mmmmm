import 'package:mmmmm/features/settings/domain/entities/app_settings.dart';

class OcrResult {
  const OcrResult({
    this.invoiceNumber,
    this.date,
    this.totalAmount,
    this.currency,
    this.rawText,
  });

  final String? invoiceNumber;
  final DateTime? date;
  final num? totalAmount;
  final CurrencyCode? currency;
  final String? rawText;
}

class OcrParser {
  static OcrResult parse(String text) {
    final normalized = _normalizeDigits(text);
    final invoice = _extractInvoiceNumber(normalized);
    final date = _extractDate(normalized);
    final total = _extractTotalAmount(normalized);
    final currency = _extractCurrency(normalized);
    return OcrResult(
      invoiceNumber: invoice,
      date: date,
      totalAmount: total,
      currency: currency,
      rawText: text,
    );
  }

  static String _normalizeDigits(String text) {
    const arabic = '٠١٢٣٤٥٦٧٨٩';
    const eastern = '۰۱۲۳۴۵۶۷۸۹';
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      final arabicIndex = arabic.indexOf(char);
      if (arabicIndex != -1) {
        buffer.write(arabicIndex.toString());
        continue;
      }
      final easternIndex = eastern.indexOf(char);
      if (easternIndex != -1) {
        buffer.write(easternIndex.toString());
        continue;
      }
      buffer.write(char);
    }
    return buffer.toString();
  }

  static String? _extractInvoiceNumber(String text) {
    final lines = text.split(RegExp(r'\r?\n'));
    for (final line in lines) {
      final lowered = line.toLowerCase();
      if (!_hasInvoiceKeyword(lowered)) {
        continue;
      }
      final token = _firstTokenWithDigits(line);
      if (token != null) {
        return token;
      }
    }

    final patterns = [
      RegExp(
        r'(?:رقم\s*الفاتورة|رقم\s*فاتورة|فاتورة\s*رقم|رقم\s*المستند|رقم\s*السند|رقم)\s*[:#-]?\s*([0-9A-Z\-/]{2,})',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:invoice|inv|bill|no\.?)\s*[:#-]?\s*([0-9A-Z\-/]{2,})',
        caseSensitive: false,
      ),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1);
      }
    }
    return null;
  }

  static bool _hasInvoiceKeyword(String line) {
    return line.contains('رقم الفاتورة') ||
        line.contains('رقم فاتورة') ||
        line.contains('فاتورة رقم') ||
        line.contains('رقم المستند') ||
        line.contains('رقم السند') ||
        line.contains('رقم') ||
        line.contains('invoice') ||
        line.contains('inv') ||
        line.contains('bill') ||
        line.contains('no');
  }

  static String? _firstTokenWithDigits(String line) {
    final match = RegExp(r'([0-9A-Z][0-9A-Z\-/]{1,})', caseSensitive: false)
        .firstMatch(line);
    if (match == null) {
      return null;
    }
    return match.group(1);
  }

  static DateTime? _extractDate(String text) {
    final keywordDate = RegExp(
      r'(?:التاريخ|تاريخ|date)\s*[:\-]?\s*([0-9]{4}[/-][0-9]{1,2}[/-][0-9]{1,2}|[0-9]{1,2}[/-][0-9]{1,2}[/-][0-9]{4})',
      caseSensitive: false,
    );
    final keywordMatch = keywordDate.firstMatch(text);
    if (keywordMatch != null) {
      final parsed = _parseDateString(keywordMatch.group(1));
      if (parsed != null) {
        return parsed;
      }
    }

    final ymd = RegExp(r'(\d{4})[/-](\d{1,2})[/-](\d{1,2})').firstMatch(text);
    if (ymd != null) {
      final year = int.tryParse(ymd.group(1) ?? '');
      final month = int.tryParse(ymd.group(2) ?? '');
      final day = int.tryParse(ymd.group(3) ?? '');
      if (year != null && month != null && day != null) {
        return DateTime.tryParse(_formatDate(year, month, day));
      }
    }

    final dmy = RegExp(r'(\d{1,2})[/-](\d{1,2})[/-](\d{4})').firstMatch(text);
    if (dmy != null) {
      final day = int.tryParse(dmy.group(1) ?? '');
      final month = int.tryParse(dmy.group(2) ?? '');
      final year = int.tryParse(dmy.group(3) ?? '');
      if (year != null && month != null && day != null) {
        return DateTime.tryParse(_formatDate(year, month, day));
      }
    }

    return null;
  }

  static DateTime? _parseDateString(String? value) {
    if (value == null) {
      return null;
    }
    final ymd = RegExp(r'(\d{4})[/-](\d{1,2})[/-](\d{1,2})').firstMatch(value);
    if (ymd != null) {
      final year = int.tryParse(ymd.group(1) ?? '');
      final month = int.tryParse(ymd.group(2) ?? '');
      final day = int.tryParse(ymd.group(3) ?? '');
      if (year != null && month != null && day != null) {
        return DateTime.tryParse(_formatDate(year, month, day));
      }
    }
    final dmy = RegExp(r'(\d{1,2})[/-](\d{1,2})[/-](\d{4})').firstMatch(value);
    if (dmy != null) {
      final day = int.tryParse(dmy.group(1) ?? '');
      final month = int.tryParse(dmy.group(2) ?? '');
      final year = int.tryParse(dmy.group(3) ?? '');
      if (year != null && month != null && day != null) {
        return DateTime.tryParse(_formatDate(year, month, day));
      }
    }
    return null;
  }

  static String _formatDate(int year, int month, int day) {
    final mm = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');
    return '$year-$mm-$dd';
  }

  static num? _extractTotalAmount(String text) {
    final keywordPatterns = [
      RegExp(
        r'(?:الإجمالي|اجمالي|المجموع|المبلغ الإجمالي|الإجمالى|total|amount|grand\s*total)\s*[:\-]?\s*([0-9,.\s]+)',
        caseSensitive: false,
      ),
    ];
    for (final pattern in keywordPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final value = _parseAmount(match.group(1));
        if (value != null) {
          return value;
        }
      }
    }

    final lines = text.split(RegExp(r'\r?\n'));
    for (final line in lines) {
      final lower = line.toLowerCase();
      if (lower.contains('الإجمالي') ||
          lower.contains('اجمالي') ||
          lower.contains('المجموع') ||
          lower.contains('المبلغ الإجمالي') ||
          lower.contains('total') ||
          lower.contains('amount')) {
        final value = _extractLastNumber(line);
        if (value != null) {
          return value;
        }
      }
    }

    return _extractNumber(text);
  }

  static num? _parseAmount(String? raw) {
    if (raw == null) {
      return null;
    }
    final cleaned = raw.replaceAll(',', '').replaceAll(RegExp(r'[^0-9\.]'), '');
    return num.tryParse(cleaned);
  }

  static num? _extractNumber(String text) {
    final matches = RegExp(r'(\d+[\d,\.]*\d)').allMatches(text);
    num? best;
    for (final match in matches) {
      final raw = match.group(1) ?? '';
      final normalized = raw.replaceAll(',', '');
      final value = num.tryParse(normalized);
      if (value == null) {
        continue;
      }
      if (best == null || value > best) {
        best = value;
      }
    }
    return best;
  }

  static num? _extractLastNumber(String text) {
    final matches = RegExp(r'(\d+[\d,\.]*\d)').allMatches(text).toList();
    if (matches.isEmpty) {
      return null;
    }
    final raw = matches.last.group(1) ?? '';
    return _parseAmount(raw);
  }

  static CurrencyCode? _extractCurrency(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('sar') ||
        lower.contains('ر.س') ||
        lower.contains('ريال سعودي') ||
        lower.contains('سعودي')) {
      return CurrencyCode.sar;
    }
    if (lower.contains('yer') ||
        lower.contains('ر.ي') ||
        lower.contains('ريال يمني') ||
        lower.contains('يمني')) {
      return CurrencyCode.yer;
    }
    return null;
  }
}
