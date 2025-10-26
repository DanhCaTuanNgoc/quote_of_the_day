import 'package:flutter/material.dart';
import 'models/quote_model.dart';
import 'services/quote_service_dev.dart'; // Dùng dev version để bypass SSL

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuoteOfTheDayPage(),
    );
  }
}

class QuoteOfTheDayPage extends StatefulWidget {
  const QuoteOfTheDayPage({super.key});

  @override
  State<QuoteOfTheDayPage> createState() => _QuoteOfTheDayPageState();
}

class _QuoteOfTheDayPageState extends State<QuoteOfTheDayPage> {
  final QuoteService _quoteService = QuoteService();
  late Future<QuoteModel> _quoteFuture;

  @override
  void initState() {
    super.initState();
    // Khởi tạo Future khi widget được tạo
    _quoteFuture = _quoteService.getRandomQuote();
  }

  // Hàm để load lại quote mới
  void _refreshQuote() {
    setState(() {
      _quoteFuture = _quoteService.getRandomQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote of the Day'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: FutureBuilder<QuoteModel>(
            future: _quoteFuture,
            builder: (context, snapshot) {
              // Trạng thái 1: LOADING - Đang tải dữ liệu
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Đang tải quote...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                );
              }

              // Trạng thái 2: ERROR - Có lỗi xảy ra
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Lỗi: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _refreshQuote,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                );
              }

              // Trạng thái 3: SUCCESS - Có dữ liệu
              if (snapshot.hasData) {
                final quote = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon trang trí
                      const Icon(
                        Icons.format_quote,
                        size: 60,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 30),
                      
                      // Nội dung quote
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                '"${quote.content}"',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '— ${quote.author}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Hiển thị tags
                      if (quote.tags.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: quote.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: Colors.deepPurple.shade50,
                            );
                          }).toList(),
                        ),
                      
                      const SizedBox(height: 30),
                      
                      // Nút refresh
                      ElevatedButton.icon(
                        onPressed: _refreshQuote,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Quote mới'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                      
                   
                    ],
                  ),
                );
              }

              // Trường hợp không có dữ liệu
              return const Text('Không có dữ liệu');
            },
          ),
        ),
      ),
    );
  }
}
