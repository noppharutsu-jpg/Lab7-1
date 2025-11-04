import 'package:flutter/material.dart';
import '../model/exam_result.dart';
import '../services/api_service.dart';
import 'add_exam_result_screen.dart';
import 'edit_exam_result_screen.dart';

class ExamResultScreen extends StatefulWidget {
  const ExamResultScreen({super.key});

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  late Future<List<ExamResult>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  void _loadResults() {
    setState(() {
      _resultsFuture = ApiService.fetchExamResults();
    });
  }

  // ฟังก์ชันสำหรับ Navigate ไปยังหน้า Add
  void _navigateToAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExamResultScreen()),
    );
    // ถ้ามีการเพิ่มข้อมูลสำเร็จ (ส่งค่า true กลับมา) ให้โหลดข้อมูลใหม่
    if (result == true) {
      _loadResults();
    }
  }

  // ฟังก์ชันสำหรับ Navigate ไปยังหน้า Edit
  void _navigateToEditScreen(ExamResult result) async {
    final navResult = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditExamResultScreen(result: result)),
    );
    // ถ้ามีการแก้ไขข้อมูลสำเร็จ (ส่งค่า true กลับมา) ให้โหลดข้อมูลใหม่
    if (navResult == true) {
      _loadResults();
    }
  }

  // ฟังก์ชันสำหรับลบข้อมูล
  void _deleteResult(int id) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Do you really want to delete this result?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      bool success = await ApiService.deleteExamResult(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'ลบข้อมูลสำเร็จ' : 'เกิดข้อผิดพลาดในการลบ'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
        if (success) {
          _loadResults();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddScreen, // เรียกใช้ฟังก์ชัน Add
          ),
        ],
      ),
      body: FutureBuilder<List<ExamResult>>(
        future: _resultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          }

          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(
                    result.studentName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(result.courseName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${result.point}',
                        style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToEditScreen(result), // เรียกใช้ฟังก์ชัน Edit
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteResult(result.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadResults,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}