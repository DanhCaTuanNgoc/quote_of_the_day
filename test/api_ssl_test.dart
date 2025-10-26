import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Test file để kiểm tra API call với SSL certificate bypass
// CHÚ Ý: Chỉ dùng để test, KHÔNG dùng trong production!

void main() async {
  // Bypass SSL certificate verification (CHỈ DÙNG ĐỂ TEST!)
  HttpOverrides.global = MyHttpOverrides();
  
  print('='.padRight(60, '='));
  print('TEST API - QUOTE OF THE DAY (SSL BYPASS)');
  print('='.padRight(60, '='));
  print('⚠️  CHÚ Ý: Đã bypass SSL certificate để test');
  print('');

  // Test 1: Test gọi API trực tiếp
  await testDirectApiCall();
  
  print('');
  
  // Test 2: Test nhiều lần
  await testMultipleCalls();
}

// Test 1: Gọi API trực tiếp
Future<void> testDirectApiCall() async {
  print('📡 TEST 1: Gọi API và parse dữ liệu');
  print('-'.padRight(60, '-'));
  
  try {
    final url = 'https://api.quotable.io/random';
    print('🔗 URL: $url');
    print('⏳ Đang gọi API...');
    
    final response = await http.get(Uri.parse(url));
    
    print('✅ Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('');
      print('🎯 THÀNH CÔNG! Đã lấy được quote:');
      print('━'.padRight(60, '━'));
      print('📝 Nội dung: "${jsonData['content']}"');
      print('👤 Tác giả: ${jsonData['author']}');
      print('🏷️  Tags: ${jsonData['tags']}');
      print('📏 Độ dài: ${jsonData['length']} ký tự');
      print('🆔 ID: ${jsonData['_id']}');
      print('━'.padRight(60, '━'));
    }
  } catch (e) {
    print('❌ Lỗi: $e');
  }
}

// Test 2: Gọi nhiều lần
Future<void> testMultipleCalls() async {
  print('🔄 TEST 2: Gọi API 5 lần để kiểm tra random');
  print('-'.padRight(60, '-'));
  
  final Set<String> uniqueQuotes = {};
  
  for (int i = 1; i <= 5; i++) {
    try {
      print('');
      print('📞 Lần $i:');
      
      final response = await http.get(Uri.parse('https://api.quotable.io/random'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final content = jsonData['content'] as String;
        final author = jsonData['author'] as String;
        
        uniqueQuotes.add(content);
        
        // Hiển thị quote ngắn gọn
        final shortContent = content.length > 60 
            ? '${content.substring(0, 60)}...' 
            : content;
        
        print('   ✅ "$shortContent"');
        print('   👤 — $author');
      }
      
      // Delay 500ms giữa các lần gọi
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      print('   ❌ Lỗi: $e');
    }
  }
  
  print('');
  print('━'.padRight(60, '━'));
  print('📊 THỐNG KÊ:');
  print('   • Số lần gọi: 5');
  print('   • Số quote unique: ${uniqueQuotes.length}');
  print('   • Tỷ lệ random: ${(uniqueQuotes.length / 5 * 100).toStringAsFixed(0)}%');
  print('━'.padRight(60, '━'));
  
  if (uniqueQuotes.length >= 3) {
    print('✅ KẾT LUẬN: API hoạt động HOÀN HẢO!');
    print('   - Gọi API thành công');
    print('   - Trả về dữ liệu đúng format JSON');
    print('   - Quote được random mỗi lần gọi');
    print('   - FutureBuilder sẽ hoạt động tốt với API này');
  } else {
    print('⚠️  KẾT LUẬN: API hoạt động nhưng random chưa tốt');
  }
}

// Class để bypass SSL certificate verification
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
