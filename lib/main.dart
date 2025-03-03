import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // เพิ่ม import นี้
import 'Provider/home_page.dart';

void main() async {
  // ต้องมี WidgetsFlutterBinding.ensureInitialized() สำหรับ async
  WidgetsFlutterBinding.ensureInitialized();
  // เริ่มต้น locale สำหรับ intl
  await initializeDateFormatting('th', null); // ใช้ 'th' สำหรับภาษาไทย หรือ 'en' สำหรับภาษาอังกฤษ
  runApp(const TouristDestinationApp());
}

class TouristDestinationApp extends StatelessWidget {
  const TouristDestinationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Destination App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}