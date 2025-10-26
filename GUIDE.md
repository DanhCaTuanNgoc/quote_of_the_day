# Quote of the Day

Ứng dụng Flutter lấy và hiển thị câu nói ngẫu nhiên từ API công khai.

## 📋 Mô tả

Ứng dụng này thực hiện các yêu cầu sau:
- ✅ Gọi API public miễn phí (api.quotable.io/random)
- ✅ Sử dụng **FutureBuilder** để xử lý các trạng thái
- ✅ Xử lý 3 trạng thái: **Loading**, **Error**, và **Success**
- ✅ Tạo class **QuoteModel** với hàm **fromJson**
- ✅ Hiển thị CircularProgressIndicator khi đang tải
- ✅ Hiển thị thông báo lỗi khi có lỗi
- ✅ Hiển thị dữ liệu khi tải thành công

## 📁 Cấu trúc thư mục

```
lib/
├── main.dart                      # File chính, chứa UI và FutureBuilder
├── models/
│   └── quote_model.dart          # Model class với fromJson
└── services/
    └── quote_service.dart        # Service gọi API
```

## 🎯 Các thành phần chính

### 1. QuoteModel (models/quote_model.dart)
- Class model đại diện cho dữ liệu Quote
- Có hàm `fromJson()` để parse JSON thành object
- Có hàm `toJson()` để chuyển object thành JSON

### 2. QuoteService (services/quote_service.dart)
- Service để gọi API từ api.quotable.io
- Sử dụng package `http` để thực hiện HTTP GET request
- Xử lý response và chuyển đổi thành QuoteModel

### 3. Main UI (main.dart)
- Sử dụng **FutureBuilder** để xử lý async data
- Xử lý 3 trạng thái:
  - **Loading**: Hiển thị CircularProgressIndicator
  - **Error**: Hiển thị icon lỗi và thông báo
  - **Success**: Hiển thị nội dung quote đẹp mắt

## 🚀 Cách chạy

1. Cài đặt dependencies:
```bash
flutter pub get
```

2. Chạy ứng dụng:
```bash
flutter run
```

## 📦 Dependencies

- `flutter`: SDK Flutter
- `http: ^1.1.0`: Package để thực hiện HTTP requests

## 🎨 Tính năng

- Hiển thị quote ngẫu nhiên với UI đẹp mắt
- Hiển thị tên tác giả
- Hiển thị các tags liên quan
- Nút "Quote mới" để tải quote khác
- Xử lý lỗi mạng một cách graceful
- Loading indicator khi đang tải dữ liệu

## 📚 Kiến thức đã áp dụng

1. **FutureBuilder**: Widget để build UI dựa trên Future
2. **HTTP Requests**: Gọi API RESTful
3. **JSON Parsing**: Parse JSON response thành Dart objects
4. **Model Classes**: Tạo class với fromJson/toJson
5. **State Management**: Sử dụng setState để cập nhật UI
6. **Error Handling**: Xử lý các trường hợp lỗi
7. **Material Design**: Sử dụng các widget Material đẹp mắt

## 🔧 API được sử dụ

**API**: https://api.quotable.io/random

**Response Example**:
```json
{
  "_id": "abc123",
  "content": "The only way to do great work is to love what you do.",
  "author": "Steve Jobs",
  "tags": ["inspirational", "work"],
  "authorSlug": "steve-jobs",
  "length": 49,
  "dateAdded": "2021-01-01",
  "dateModified": "2021-01-01"
}
```

## 👨‍💻 Tác giả

Bài tập: Lập trình thiết bị di động - Chương 7
