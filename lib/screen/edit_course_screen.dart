import 'package:flutter/material.dart';
import '../model/course.dart'; // แก้ไข path ไปยัง model
import '../services/api_service.dart'; // import ApiService

class EditCourseScreen extends StatefulWidget {
  final Course course; // เปลี่ยนเป็น Course
  const EditCourseScreen({super.key, required this.course});
  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  late TextEditingController nameController;
  late TextEditingController codeController;
  late TextEditingController creditController; // เปลี่ยนจาก gender เป็น credit

  @override
  void initState() {
    super.initState();
    // ใช้ข้อมูลจาก widget.course
    codeController = TextEditingController(text: widget.course.courseCode);
    nameController = TextEditingController(text: widget.course.courseName);
    creditController = TextEditingController(text: widget.course.credit.toString()); // แปลง int เป็น String
  }

  // สร้างฟังก์ชันสำหรับจัดการการกดปุ่ม Save
  Future<void> _onSave() async {
    final updatedCourse = Course(
      courseCode: widget.course.courseCode, // ใช้ code เดิมเสมอ
      courseName: nameController.text,
      credit: int.tryParse(creditController.text) ?? 0, // แปลง String กลับเป็น int
    );

    // เรียกใช้ ApiService
    bool success = await ApiService.updateCourse(updatedCourse);
    
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('แก้ไขข้อมูลสำเร็จ'), backgroundColor: Colors.green),
      );
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
        title: const Text("Edit Course"), // เปลี่ยน Title
        actions: [
          IconButton(
            onPressed: _onSave,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: codeController,
              enabled: false, // รหัสวิชาไม่ควรแก้ไขได้
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Course Code', // เปลี่ยน Label
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Course Name', // เปลี่ยน Label
              ),
            ),
            const SizedBox(height: 16),
            // เปลี่ยนจาก Dropdown เป็น TextField สำหรับ Credit
            TextField(
              controller: creditController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Credits', // เปลี่ยน Label
              ),
            ),
          ],
        ),
      ),
    );
  }
}