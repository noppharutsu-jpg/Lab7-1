import 'package:flutter/material.dart';
import '../model/exam_result.dart';
import '../services/api_service.dart';

class EditExamResultScreen extends StatefulWidget {
  final ExamResult result;
  const EditExamResultScreen({super.key, required this.result});

  @override
  State<EditExamResultScreen> createState() => _EditExamResultScreenState();
}

class _EditExamResultScreenState extends State<EditExamResultScreen> {
  late TextEditingController _pointController;

  @override
  void initState() {
    super.initState();
    _pointController = TextEditingController(text: widget.result.point.toString());
  }

  Future<void> _onSave() async {
    if (_pointController.text.isEmpty) {
      // Validation
      return;
    }

    // สร้าง object ใหม่ที่มี point ที่อัปเดตแล้ว
    final updatedResult = ExamResult(
      id: widget.result.id,
      studentCode: widget.result.studentCode,
      courseCode: widget.result.courseCode,
      point: int.tryParse(_pointController.text) ?? 0,
      studentName: widget.result.studentName,
      courseName: widget.result.courseName
    );

    bool success = await ApiService.updateExamResult(updatedResult);
    if (!mounted) return;

    if (success) {
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
        title: const Text('Edit Exam Result'),
        actions: [
          IconButton(onPressed: _onSave, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Student: ${widget.result.studentName}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Course: ${widget.result.courseName}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
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