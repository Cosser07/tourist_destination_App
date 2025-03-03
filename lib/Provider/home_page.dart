import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Import SharedPreferences
import 'dart:convert'; // ✅ ใช้แปลงข้อมูล JSON
import 'add_page.dart';
import '../Model/tourist_destination.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TouristDestination> destinations = [];

  @override
  void initState() {
    super.initState();
    _initializeData(); // ✅ เซ็ตค่าข้อมูลเริ่มต้นครั้งแรก
    _loadDestinations(); // ✅ โหลดข้อมูลจาก SharedPreferences
  }

  // ✅ เซ็ตข้อมูลครั้งแรก (หากยังไม่มีใน SharedPreferences)
  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    final hasData = prefs.getBool('hasData') ?? false;

    if (!hasData) {
      destinations = [
        TouristDestination(name: 'น้ำตก', rating: 5.0, visitDate: DateTime(2025, 3, 1), category: 'ธรรมชาติ'),
        TouristDestination(name: 'ภูทับเบิก', rating: 5.0, visitDate: DateTime(2025, 3, 3), category: 'ผจญภัย'),
        TouristDestination(name: 'บ้านเชียง', rating: 4.0, visitDate: DateTime(2025, 2, 12), category: 'วัฒนธรรม'),
        TouristDestination(name: 'เยาวราช', rating: 5.0, visitDate: DateTime(2025, 3, 3), category: 'เมือง'),
        TouristDestination(name: 'เขาสก', rating: 2.0, visitDate: DateTime(2025, 3, 3), category: 'ผจญภัย'),
      ];

      await _saveDestinations();
      await prefs.setBool('hasData', true);
    }
  }

  // ✅ บันทึกข้อมูลลง SharedPreferences
  Future<void> _saveDestinations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode(destinations.map((d) => d.toJson()).toList());
    await prefs.setString('destinations', jsonData);
  }

  // ✅ โหลดข้อมูลจาก SharedPreferences
  Future<void> _loadDestinations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('destinations');

    if (jsonData != null) {
      setState(() {
        destinations = (jsonDecode(jsonData) as List)
            .map((item) => TouristDestination.fromJson(item))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สถานที่ท่องเที่ยว',
          style: GoogleFonts.prompt(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent.shade100, Colors.white],
            ),
          ),
          child: destinations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.travel_explore, size: 80, color: Colors.blueAccent),
                      const SizedBox(height: 16),
                      Text(
                        'ยังไม่มีสถานที่ท่องเที่ยว',
                        style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ListView.builder(
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];
                      return Dismissible(
                        key: Key(destination.name),
                        onDismissed: (direction) {
                          setState(() {
                            destinations.removeAt(index);
                          });
                          _saveDestinations(); // ✅ บันทึกข้อมูลหลังจากลบ

                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${destination.name} ถูกลบแล้ว'),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        background: Container(
                          padding: const EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red.shade400,
                          ),
                          child: const Icon(Icons.delete, color: Colors.white, size: 30),
                        ),
                        child: Card(
                          elevation: 6,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadowColor: Colors.blueAccent.shade100,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              destination.name,
                              style: GoogleFonts.prompt(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '⭐ คะแนน: ${destination.rating} | 📍 หมวดหมู่: ${destination.category}',
                                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                                ),
                                Text(
                                  '📅 วันที่เยี่ยมชม: ${DateFormat('d MMMM yyyy', 'th').format(destination.visitDate)}',
                                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDestination = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const AddPage(),
              transitionsBuilder: (_, animation, __, child) {
                return SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
                  child: child,
                );
              },
            ),
          );
          if (newDestination != null) {
            setState(() {
              destinations.add(newDestination);
            });
            _saveDestinations(); // ✅ บันทึกข้อมูลหลังจากเพิ่ม

            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('เพิ่ม ${newDestination.name} สำเร็จ! 🎉'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}