import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Model/tourist_destination.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _rating = 0.0;
  DateTime _visitDate = DateTime.now();
  String _category = 'ธรรมชาติ';
  final List<String> _categories = ['ธรรมชาติ', 'วัฒนธรรม', 'ผจญภัย', 'เมือง'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มสถานที่ท่องเที่ยว',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea( // ✅ ป้องกัน UI โดนทับ
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent.shade100, Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16), // ✅ เพิ่มระยะห่างด้านบน ป้องกัน UI ชิด AppBar

                  Center(
                    child: Text(
                      'กรอกข้อมูลสถานที่ท่องเที่ยว',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TextField - ชื่อสถานที่
                  _buildTextField(
                    label: 'ชื่อสถานที่',
                    validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกชื่อสถานที่' : null,
                    onSaved: (value) => _name = value!,
                  ),

                  const SizedBox(height: 16),

                  // TextField - คะแนน (0-5)
                  _buildTextField(
                    label: 'คะแนน (0-5)',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'กรุณากรอกคะแนน';
                      final rating = double.tryParse(value);
                      if (rating == null || rating < 0 || rating > 5) return 'คะแนนต้องอยู่ระหว่าง 0 ถึง 5';
                      return null;
                    },
                    onSaved: (value) => _rating = double.parse(value!),
                  ),

                  const SizedBox(height: 16),

                  // เลือกวันที่
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'วันที่เยี่ยมชม: ${DateFormat('d MMMM yyyy', 'th').format(_visitDate)}',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                    ),
                    trailing: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _visitDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() => _visitDate = pickedDate);
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Dropdown หมวดหมู่
                  DropdownButtonFormField<String>(
                    value: _category,
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category, style: GoogleFonts.poppins(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _category = value!),
                    decoration: _inputDecoration('หมวดหมู่'),
                    validator: (value) => value == null ? 'กรุณาเลือกหมวดหมู่' : null,
                  ),

                  const SizedBox(height: 24),

                  // ปุ่มเพิ่มสถานที่
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final newDestination = TouristDestination(
                            name: _name,
                            rating: _rating,
                            visitDate: _visitDate,
                            category: _category,
                          );
                          Navigator.pop(context, newDestination);
                        }
                      },
                      style: _buttonStyle(Colors.blueAccent),
                      child: const Text('เพิ่มสถานที่', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้าง TextField
  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return TextFormField(
      decoration: _inputDecoration(label),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }

  // สไตล์ InputDecoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.blueAccent),
    );
  }

  // สไตล์ปุ่ม
  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}