import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuoteService {
  // Base URL của API
  static const String baseUrl = 'https://api.quotable.io';

  // Hàm gọi API để lấy quote ngẫu nhiên
  Future<QuoteModel> getRandomQuote() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random'));

      if (response.statusCode == 200) {
        // Parse JSON và chuyển thành QuoteModel
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return QuoteModel.fromJson(jsonData);
      } else {
        throw Exception('Không thể tải quote. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gọi API: $e');
    }
  }
}
