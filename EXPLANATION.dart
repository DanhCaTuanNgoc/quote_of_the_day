/* 
 * HƯỚNG DẪN CHI TIẾT: Quote of the Day
 * ===================================
 * 
 * File này giải thích chi tiết cách hoạt động của từng phần trong dự án
 */

// ============================================================================
// 1. MODEL CLASS - QuoteModel (models/quote_model.dart)
// ============================================================================

/*
 * Model class là đại diện cho cấu trúc dữ liệu.
 * Nó giúp chuyển đổi giữa JSON (từ API) và Dart object.
 * 
 * VÍ DỤ JSON từ API:
 * {
 *   "_id": "abc123",
 *   "content": "Life is what happens when you're busy making other plans.",
 *   "author": "John Lennon",
 *   "tags": ["life", "inspirational"],
 *   "authorSlug": "john-lennon",
 *   "length": 58,
 *   "dateAdded": "2021-01-01",
 *   "dateModified": "2021-01-01"
 * }
 * 
 * Hàm fromJson sẽ chuyển JSON này thành QuoteModel object
 */

// ============================================================================
// 2. SERVICE - QuoteService (services/quote_service.dart)
// ============================================================================

/*
 * Service class chịu trách nhiệm gọi API và xử lý response
 * 
 * Quy trình:
 * 1. Tạo HTTP GET request đến https://api.quotable.io/random
 * 2. Đợi response từ server
 * 3. Kiểm tra status code (200 = thành công)
 * 4. Parse JSON response
 * 5. Chuyển JSON thành QuoteModel object bằng fromJson()
 * 6. Return QuoteModel hoặc throw Exception nếu lỗi
 * 
 * Future<QuoteModel> có nghĩa là hàm này sẽ:
 * - Chạy async (không block UI)
 * - Trả về QuoteModel trong tương lai (khi API response)
 */

// ============================================================================
// 3. FUTUREBUILDER - Xử lý 3 trạng thái
// ============================================================================

/*
 * FutureBuilder là widget đặc biệt để build UI dựa trên Future
 * 
 * TRẠNG THÁI 1: LOADING (ConnectionState.waiting)
 * - Khi: Future đang chạy, chưa có kết quả
 * - Hiển thị: CircularProgressIndicator + text "Đang tải quote..."
 * - Code:
 *   if (snapshot.connectionState == ConnectionState.waiting) {
 *     return CircularProgressIndicator();
 *   }
 * 
 * TRẠNG THÁI 2: ERROR (snapshot.hasError)
 * - Khi: Future hoàn thành nhưng có lỗi (throw Exception)
 * - Hiển thị: Icon lỗi + thông báo lỗi + nút "Thử lại"
 * - Code:
 *   if (snapshot.hasError) {
 *     return Text('Lỗi: ${snapshot.error}');
 *   }
 * 
 * TRẠNG THÁI 3: SUCCESS (snapshot.hasData)
 * - Khi: Future hoàn thành thành công, có dữ liệu
 * - Hiển thị: Quote content + author + tags + nút "Quote mới"
 * - Code:
 *   if (snapshot.hasData) {
 *     final quote = snapshot.data!;
 *     return Text(quote.content);
 *   }
 */

// ============================================================================
// 4. FLOW HOÀN CHỈNH
// ============================================================================

/*
 * Khi app khởi động:
 * 
 * 1. initState() được gọi
 *    └─> _quoteFuture = _quoteService.getRandomQuote();
 *        └─> Bắt đầu gọi API
 * 
 * 2. FutureBuilder build lần 1 (LOADING)
 *    └─> snapshot.connectionState == waiting
 *    └─> Hiển thị CircularProgressIndicator
 * 
 * 3. API response về
 *    └─> QuoteService parse JSON
 *    └─> Tạo QuoteModel object
 * 
 * 4. FutureBuilder build lần 2 (SUCCESS hoặc ERROR)
 *    └─> Nếu thành công: snapshot.hasData = true
 *        └─> Hiển thị quote content
 *    └─> Nếu lỗi: snapshot.hasError = true
 *        └─> Hiển thị thông báo lỗi
 * 
 * Khi click "Quote mới":
 * 
 * 1. _refreshQuote() được gọi
 *    └─> setState(() {
 *          _quoteFuture = _quoteService.getRandomQuote();
 *        });
 * 
 * 2. Widget rebuild
 *    └─> FutureBuilder nhận Future mới
 *    └─> Lặp lại flow từ bước 2
 */

// ============================================================================
// 5. ĐIỂM QUAN TRỌNG CẦN NHỚ
// ============================================================================

/*
 * ✅ ĐÚNG:
 * - Tạo Future trong initState() hoặc khi setState()
 * - Không tạo Future trực tiếp trong build()
 * - Sử dụng late Future<T> để khai báo
 * 
 * ❌ SAI:
 * FutureBuilder(
 *   future: _quoteService.getRandomQuote(), // SAI! Sẽ gọi API mỗi khi build
 *   ...
 * )
 * 
 * ✅ ĐÚNG:
 * late Future<QuoteModel> _quoteFuture;
 * 
 * @override
 * void initState() {
 *   super.initState();
 *   _quoteFuture = _quoteService.getRandomQuote(); // Chỉ gọi 1 lần
 * }
 * 
 * FutureBuilder(
 *   future: _quoteFuture, // ĐÚNG! Sử dụng biến đã lưu
 *   ...
 * )
 */

// ============================================================================
// 6. ERROR HANDLING
// ============================================================================

/*
 * Các loại lỗi có thể xảy ra:
 * 
 * 1. Lỗi mạng (No internet connection)
 *    └─> SocketException
 *    └─> FutureBuilder catch và hiển thị trong snapshot.error
 * 
 * 2. Lỗi HTTP (Status code != 200)
 *    └─> Service throw Exception
 *    └─> FutureBuilder catch và hiển thị
 * 
 * 3. Lỗi parse JSON (Invalid JSON format)
 *    └─> FormatException
 *    └─> FutureBuilder catch và hiển thị
 * 
 * Tất cả đều được xử lý trong:
 * if (snapshot.hasError) {
 *   return Text('Lỗi: ${snapshot.error}');
 * }
 */

// ============================================================================
// 7. TESTING
// ============================================================================

/*
 * Để test ứng dụng:
 * 
 * TEST LOADING STATE:
 * - Làm chậm mạng (throttle network)
 * - Quan sát CircularProgressIndicator xuất hiện
 * 
 * TEST ERROR STATE:
 * - Tắt mạng/WiFi
 * - Click "Quote mới"
 * - Quan sát thông báo lỗi xuất hiện
 * 
 * TEST SUCCESS STATE:
 * - Kết nối mạng bình thường
 * - Click "Quote mới" nhiều lần
 * - Quan sát quote mới được load
 */

// ============================================================================
// 8. DEPENDENCIES
// ============================================================================

/*
 * Package http:
 * - Cung cấp các hàm để thực hiện HTTP requests
 * - http.get() - GET request
 * - http.post() - POST request
 * - http.put() - PUT request
 * - http.delete() - DELETE request
 * 
 * Import:
 * import 'package:http/http.dart' as http;
 * 
 * Sử dụng:
 * final response = await http.get(Uri.parse('https://...'));
 */

// ============================================================================
// 9. TÓM TẮT
// ============================================================================

/*
 * Kiến thức đã học:
 * 
 * ✅ FutureBuilder - Widget để xử lý async data
 * ✅ 3 trạng thái: Loading, Error, Success
 * ✅ Model class với fromJson()
 * ✅ Service class để gọi API
 * ✅ HTTP requests với package http
 * ✅ JSON parsing
 * ✅ Error handling
 * ✅ State management với setState()
 * ✅ Async/Await pattern
 * ✅ Future<T> type
 * 
 * Kỹ năng quan trọng:
 * - Xử lý API calls trong Flutter
 * - Parse JSON thành Dart objects
 * - Quản lý các trạng thái async
 * - Tạo UI responsive với loading states
 * - Error handling gracefully
 */
