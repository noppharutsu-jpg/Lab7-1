import 'package:flutter/material.dart';
import '../model/student.dart';
import '../model/course.dart';
import '../model/exam_result.dart';
import '../services/api_service.dart';

class AddExamResultScreen extends StatefulWidget {
  const AddExamResultScreen({super.key});

  @override
  State<AddExamResultScreen> createState() => _AddExamResultScreenState();
}

class _AddExamResultScreenState extends State<AddExamResultScreen> {
  late Future<List<Student>> _studentsFuture;
  late Future<List<Course>> _coursesFuture;
  
  String? _selectedStudentCode;
  String? _selectedCourseCode;
  final TextEditingController _pointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // โหลดข้อมูลนักเรียนและวิชาเมื่อหน้าจอถูกสร้าง
    _studentsFuture = ApiService.fetchStudents();
    _coursesFuture = ApiService.fetchCourses();
  }

  Future<void> _onSave() async {
    if (_selectedStudentCode == null || _selectedCourseCode == null || _pointController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกข้อมูลและกรอกคะแนนให้ครบถ้วน'), backgroundColor: Colors.orange),
      );
      return;
    }

    // สร้าง object สำหรับส่งข้อมูล (id และชื่อต่างๆ ไม่จำเป็นต้องใส่เพราะ API ไม่ได้ใช้)
    final newResult = ExamResult(
      id: 0, 
      studentCode: _selectedStudentCode!,
      courseCode: _selectedCourseCode!,
      point: int.tryParse(_pointController.text) ?? 0,
      studentName: '', 
      courseName: ''
    );

    bool success = await ApiService.addExamResult(newResult);
    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true); // ส่ง true กลับไปเพื่อบอกว่าเพิ่มสำเร็จ
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการเพิ่มข้อมูล'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exam Result'),
        actions: [
          IconButton(onPressed: _onSave, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for Students
            FutureBuilder<List<Student>>(
              future: _studentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Could not load students');
                }
                return DropdownButtonFormField<String>(
                  value: _selectedStudentCode,
                  hint: const Text('Select Student'),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: snapshot.data!.map((student) {
                    return DropdownMenuItem<String>(
                      value: student.studentCode,
                      child: Text(student.studentName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStudentCode = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            // Dropdown for Courses
            FutureBuilder<List<Course>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Could not load courses');
                }
                return DropdownButtonFormField<String>(
                  value: _selectedCourseCode,
                  hint: const Text('Select Course'),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  items: snapshot.data!.map((course) {
                    return DropdownMenuItem<String>(
                      value: course.courseCode,
                      child: Text(course.courseName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCourseCode = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            // TextField for Point
            TextField(
              controller: _pointController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Point',
              ),
            ),
          ],
        ),
      ),
    );
  }
}