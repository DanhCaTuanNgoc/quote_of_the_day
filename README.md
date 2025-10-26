# Quote of the Day 📜

Ứng dụng Flutter hiển thị câu nói ngẫu nhiên từ API công khai, thực hành về **FutureBuilder**, **xử lý 3 trạng thái async**, và **Model class với JSON parsing**.

## 📱 Screenshot

<p align="center">
  <img src="Quoet of the day screenshot.png" alt="Quote of the Day App Screenshot" width="300">
</p>

## 🎯 Mục tiêu học tập

Dự án này giúp bạn nắm vững các kiến thức quan trọng:

### 1. **FutureBuilder**
- Hiểu cách sử dụng `FutureBuilder` để xử lý dữ liệu async
- Biết cách quản lý `Future` trong StatefulWidget
- Nắm được vòng đời của `ConnectionState`

### 2. **Xử lý 3 trạng thái**

#### ⏳ **LOADING** (Đang tải)
```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return CircularProgressIndicator(); // Hiện loading indicator
}
```
- **Khi nào:** Future đang chạy, chưa có kết quả
- **Hiển thị:** `CircularProgressIndicator` + text "Đang tải quote..."
- **Mục đích:** Cung cấp feedback cho user khi đang chờ dữ liệu

#### ❌ **ERROR** (Có lỗi)
```dart
if (snapshot.hasError) {
  return Text('Lỗi: ${snapshot.error}'); // Hiện thông báo lỗi
}
```
- **Khi nào:** Future hoàn thành nhưng có lỗi (throw Exception)
- **Hiển thị:** Icon lỗi + thông báo lỗi chi tiết + nút "Thử lại"
- **Mục đích:** Xử lý gracefully khi có lỗi mạng hoặc API

#### ✅ **SUCCESS** (Thành công)
```dart
if (snapshot.hasData) {
  final quote = snapshot.data!; // Lấy dữ liệu
  return Text(quote.content); // Hiển thị dữ liệu
}
```
- **Khi nào:** Future hoàn thành thành công với dữ liệu
- **Hiển thị:** Quote content + author + tags + nút refresh
- **Mục đích:** Hiển thị dữ liệu đẹp mắt cho user

### 3. **Model Class & JSON Parsing**

#### Tạo class QuoteModel
```dart
class QuoteModel {
  final String id;
  final String content;
  final String author;
  
  // Constructor
  QuoteModel({required this.id, required this.content, required this.author});
  
  // Hàm fromJson - Chuyển JSON thành Object
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['_id'],
      content: json['content'],
      author: json['author'],
    );
  }
  
  // Hàm toJson - Chuyển Object thành JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'author': author,
    };
  }
}
```

---

## 📁 Cấu trúc dự án & Nhiệm vụ của các file

```
lib/
├── main.dart                         # File chính - UI và FutureBuilder
├── models/
│   └── quote_model.dart             # Model class cho Quote
└── services/
    ├── quote_service.dart           # Service gọi API (production)
    └── quote_service_dev.dart       # Service gọi API (development - SSL bypass)
```

### 📄 **main.dart**
**Nhiệm vụ:**
- Khởi tạo ứng dụng Flutter
- Tạo UI chính với `FutureBuilder`
- Xử lý và hiển thị **3 trạng thái**: Loading, Error, Success
- Quản lý state với `StatefulWidget`
- Cung cấp nút refresh để load quote mới

**Kiến thức áp dụng:**
- `FutureBuilder` widget
- `ConnectionState` enum
- `AsyncSnapshot` để kiểm tra trạng thái
- `setState()` để cập nhật UI
- Material Design widgets (Card, Chip, Button...)

### 📄 **models/quote_model.dart**
**Nhiệm vụ:**
- Định nghĩa cấu trúc dữ liệu Quote
- Chứa hàm `fromJson()` để parse JSON → Dart object
- Chứa hàm `toJson()` để chuyển Dart object → JSON

**Kiến thức áp dụng:**
- Class và Constructor
- Factory constructor
- JSON serialization/deserialization
- Type safety với Dart

**Ví dụ JSON từ API:**
```json
{
  "_id": "abc123",
  "content": "Life is what happens when you're busy making other plans.",
  "author": "John Lennon",
  "tags": ["life", "inspirational"],
  "length": 58
}
```

### 📄 **services/quote_service.dart**
**Nhiệm vụ:**
- Gọi API REST từ `api.quotable.io`
- Xử lý HTTP request/response
- Parse JSON response thành QuoteModel
- Throw Exception khi có lỗi

**Kiến thức áp dụng:**
- HTTP requests với package `http`
- Async/Await pattern
- Error handling với try-catch
- Future<T> return type

**Flow hoạt động:**
```
1. Gọi http.get(url)
2. Đợi response
3. Kiểm tra status code (200 = OK)
4. Parse JSON: json.decode(response.body)
5. Tạo object: QuoteModel.fromJson(jsonData)
6. Return QuoteModel hoặc throw Exception
```

### 📄 **services/quote_service_dev.dart**
**Nhiệm vụ:**
- Giống `quote_service.dart` nhưng bypass SSL certificate
- Chỉ dùng trong development khi có lỗi SSL

**Lưu ý:** Không dùng trong production!

---

## 🚀 Cách chạy dự án

### Bước 1: Cài đặt dependencies
```bash
flutter pub get
```

### Bước 2: Chạy trên thiết bị
```bash
# Kiểm tra thiết bị có sẵn
flutter devices

# Chạy trên Android
flutter run

# Hoặc chạy trên thiết bị cụ thể
flutter run -d <device_id>
```

### Bước 3: Test app
- Quan sát loading indicator khi app khởi động
- Xem quote được hiển thị sau khi load xong
- Click nút "Quote mới" để load quote khác
- Tắt WiFi và click refresh để xem error state

---

## 🧪 Testing

### Test thủ công
```bash
# Test gọi API trực tiếp
dart test/api_ssl_test.dart
```

### Test kết quả mong đợi:
- ✅ API trả về status code 200
- ✅ JSON được parse thành công
- ✅ Mỗi lần gọi trả về quote khác nhau (random)
- ✅ 3 trạng thái FutureBuilder hoạt động đúng

---

## 📚 API sử dụng

**API:** [Quotable API](https://api.quotable.io)

**Endpoint:** `GET https://api.quotable.io/random`

**Response mẫu:**
```json
{
  "_id": "YTqaIDVD0fX3",
  "content": "The way we communicate with others and with ourselves ultimately determines the quality of our lives.",
  "author": "Tony Robbins",
  "tags": ["Famous Quotes"],
  "authorSlug": "tony-robbins",
  "length": 101,
  "dateAdded": "2021-01-01",
  "dateModified": "2021-01-01"
}
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0  # Package để thực hiện HTTP requests
```

---

## 🎓 Kiến thức đã học

### 1. FutureBuilder
- Widget để build UI dựa trên Future
- Tự động rebuild khi Future thay đổi trạng thái
- Cung cấp `AsyncSnapshot` để kiểm tra trạng thái

### 2. Xử lý 3 trạng thái async
- **Loading:** `ConnectionState.waiting`
- **Error:** `snapshot.hasError`
- **Success:** `snapshot.hasData`

### 3. Model class với fromJson()
- Parse JSON thành Dart object
- Type safety và code organization
- Dễ maintain và test

### 4. HTTP Requests
- Gọi REST API với package `http`
- Xử lý response và status codes
- Error handling với try-catch

### 5. State Management cơ bản
- `StatefulWidget` và `State`
- `setState()` để rebuild UI
- Quản lý `Future` trong state

---

## 🎨 Screenshots

### Loading State
```
┌─────────────────────────┐
│   Quote of the Day      │
├─────────────────────────┤
│                         │
│          ⏳             │
│   Đang tải quote...     │
│                         │
└─────────────────────────┘
```

### Success State
```
┌─────────────────────────┐
│   Quote of the Day      │
├─────────────────────────┤
│         💬              │
│                         │
│  "Life is beautiful"    │
│                         │
│   — Unknown Author      │
│                         │
│  [tag1] [tag2]          │
│                         │
│   [Quote mới 🔄]        │
└─────────────────────────┘
```

### Error State
```
┌─────────────────────────┐
│   Quote of the Day      │
├─────────────────────────┤
│          ❌             │
│                         │
│   Lỗi: Không có mạng    │
│                         │
│    [Thử lại 🔄]         │
└─────────────────────────┘
```

---

## 🔧 Troubleshooting

### Lỗi SSL Certificate
Nếu gặp lỗi `CERTIFICATE_VERIFY_FAILED`:
- App đã được config để bypass SSL trong development
- File `quote_service_dev.dart` xử lý vấn đề này
- Trên thiết bị thật (Android/iOS) thường không gặp lỗi này

### Lỗi không có mạng
- App sẽ hiển thị thông báo lỗi rõ ràng
- Có nút "Thử lại" để user thử load lại

---

## 👨‍💻 Tác giả

**Bài tập:** Lập trình thiết bị di động - Chương 7  
**Chủ đề:** HTTP Requests, FutureBuilder, và JSON Parsing  
**Ngày:** 26/10/2025

---

## 📝 License

This project is for educational purposes.
