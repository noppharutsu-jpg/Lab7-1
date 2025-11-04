import 'package:flutter/material.dart';
import '../model/student.dart'; // แก้ไข path ไปยัง model
import '../services/api_service.dart'; // import ApiService ที่เราสร้างขึ้นมาใหม่

class EditStudentScreen extends StatefulWidget {
  final Student student; // เปลี่ยนเป็น required ไม่ต้องเป็น nullable
  const EditStudentScreen({super.key, required this.student});
  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  // ไม่ต้องสร้างตัวแปร student อีก เพราะเรามี widget.student อยู่แล้ว
  late TextEditingController nameController;
  late TextEditingController codeController;
  late String dropdownValue;
  
  @override
  void initState() {
    super.initState();
    // ใช้ข้อมูลจาก widget.student โดยตรง
    codeController = TextEditingController(text: widget.student.studentCode);
    nameController = TextEditingController(text: widget.student.studentName);
    dropdownValue = widget.student.gender;
  }

  // สร้างฟังก์ชันสำหรับจัดการการกดปุ่ม Save
  Future<void> _onSave() async {
    final updatedStudent = Student(
      studentCode: widget.student.studentCode, // ใช้ code เดิมเสมอ
      studentName: nameController.text,
      gender: dropdownValue,
    );

    // เรียกใช้ ApiService
    bool success = await ApiService.updateStudent(updatedStudent);
    
    // ตรวจสอบ context ก่อนใช้งาน Navigator
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('แก้ไขข้อมูลสำเร็จ'), backgroundColor: Colors.green),
      );
      // ส่งค่า true กลับไปบอกหน้าก่อนหน้าว่ามีการเปลี่ยนแปลงข้อมูล
      Navigator.pop(context, true); 
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการแก้ไข'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Student"),
        actions: [
          IconButton(
            onPressed: _onSave, // เรียกใช้ฟังก์ชัน _onSave
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0), // เพิ่ม padding ให้สวยงาม
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: codeController,
              enabled: false, // รหัสนักเรียนไม่ควรแก้ไขได้
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Student Code',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Student Name',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: dropdownValue, // ใช้ value แทน initialValue
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: ['F', 'M'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}