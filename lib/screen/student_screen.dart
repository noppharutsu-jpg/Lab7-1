import 'package:flutter/material.dart';
import '../model/student.dart';
import '../services/api_service.dart'; // Import ApiService
import 'edit_student_screen.dart';
import 'add_student_screen.dart'; // Import หน้า Add ใหม่

class StudentScreen extends StatefulWidget {
  static const routeName = '/';
  const StudentScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _StudentScreenState();
  }
}

class _StudentScreenState extends State<StudentScreen> {
  late Future<List<Student>> studentsFuture;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    setState(() {
      studentsFuture = ApiService.fetchStudents();
    });
  }

  void _navigateToAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddStudentScreen()),
    );
    // ถ้าหน้า Add ส่งผลลัพธ์กลับมาว่ามีการเพิ่มข้อมูลสำเร็จ ให้โหลดใหม่
    if (result == true) {
      _loadStudents();
    }
  }

  void _navigateToEditScreen(Student student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(student: student),
      ),
    );
    // ถ้าหน้า Edit ส่งผลลัพธ์กลับมาว่ามีการแก้ไขสำเร็จ ให้โหลดใหม่
    if (result == true) {
      _loadStudents();
    }
  }

  void _deleteStudent(String studentCode) async {
      bool success = await ApiService.deleteStudent(studentCode);
      if(success){
        if (!mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ลบข้อมูลสำเร็จ'), backgroundColor: Colors.green),
          );
          _loadStudents(); // โหลดข้อมูลใหม่หลังลบ
      } else {
        if (!mounted) return;
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('เกิดข้อผิดพลาดในการลบ'), backgroundColor: Colors.red),
          );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        actions: [
          IconButton(
            onPressed: _navigateToAddScreen, // เรียกใช้ฟังก์ชันเพิ่ม
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          final students = snapshot.data!;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                title: Text(student.studentName),
                subtitle: Text(student.studentCode),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _navigateToEditScreen(student),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteStudent(student.studentCode),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadStudents,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}