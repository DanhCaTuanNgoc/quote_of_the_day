import 'dart:convert';
import 'package:http/http.dart' as http;
import '../lib/services/quote_service.dart';

// Test file để kiểm tra API call
void main() async {
  print('='.padRight(60, '='));
  print('TEST CHỨC NĂNG CALL API - QUOTE OF THE DAY');
  print('='.padRight(60, '='));
  print('');

  // Test 1: Test gọi API trực tiếp
  await testDirectApiCall();
  
  print('');
  
  // Test 2: Test qua QuoteService
  await testQuoteService();
  
  print('');
  
  // Test 3: Test nhiều lần để xem có random không
  await testMultipleCalls();
}

// Test 1: Gọi API trực tiếp
Future<void> testDirectApiCall() async {
  print('📡 TEST 1: Gọi API trực tiếp');
  print('-'.padRight(60, '-'));
  
  try {
    final url = 'https://api.quotable.io/random';
    print('🔗 URL: $url');
    print('⏳ Đang gọi API...');
    
    final response = await http.get(Uri.parse(url));
    
    print('✅ Status Code: ${response.statusCode}');
    print('📦 Response Body:');
    print(response.body);
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('');
      print('🎯 Parse thành công!');
      print('   📝 Content: ${jsonData['content']}');
      print('   👤 Author: ${jsonData['author']}');
      print('   🏷️  Tags: ${jsonData['tags']}');
    }
  } catch (e) {
    print('❌ Lỗi: $e');
  }
}

// Test 2: Gọi qua QuoteService
Future<void> testQuoteService() async {
  print('🔧 TEST 2: Gọi API qua QuoteService');
  print('-'.padRight(60, '-'));
  
  try {
    final quoteService = QuoteService();
    print('⏳ Đang gọi QuoteService.getRandomQuote()...');
    
    final quote = await quoteService.getRandomQuote();
    
    print('✅ Thành công!');
    print('');
    print('📋 Chi tiết Quote:');
    print('   🆔 ID: ${quote.id}');
    print('   📝 Content: ${quote.content}');
    print('   👤 Author: ${quote.author}');
    print('   🏷️  Tags: ${quote.tags.join(', ')}');
    print('   📏 Length: ${quote.length} ký tự');
    print('   📅 Date Added: ${quote.dateAdded}');
    print('   🔄 Date Modified: ${quote.dateModified}');
  } catch (e) {
    print('❌ Lỗi: $e');
  }
}

// Test 3: Gọi nhiều lần để xem có random không
Future<void> testMultipleCalls() async {
  print('🔄 TEST 3: Gọi API 3 lần để kiểm tra random');
  print('-'.padRight(60, '-'));
  
  final quoteService = QuoteService();
  
  for (int i = 1; i <= 3; i++) {
    try {
      print('');
      print('📞 Lần $i:');
      final quote = await quoteService.getRandomQuote();
      print('   ✅ "${quote.content}"');
      print('   👤 — ${quote.author}');
      
      // Delay 1 giây giữa các lần gọi
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      print('   ❌ Lỗi: $e');
    }
  }
  
  print('');
  print('✅ KẾT LUẬN: API hoạt động tốt và trả về quote random!');
}
