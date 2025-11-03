import 'package:flutter/material.dart';
import '../model/course.dart'; // เปลี่ยนเป็น Course model
import '../services/api_service.dart'; // Import ApiService
import 'edit_course_screen.dart'; // เปลี่ยนเป็น EditCourseScreen
import 'add_course_screen.dart';  // เปลี่ยนเป็น AddCourseScreen

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _CourseScreenState();
  }
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<List<Course>> coursesFuture;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    setState(() {
      coursesFuture = ApiService.fetchCourses();
    });
  }

  void _navigateToAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCourseScreen()),
    );
    if (result == true) {
      _loadCourses();
    }
  }

  void _navigateToEditScreen(Course course) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCourseScreen(course: course),
      ),
    );
    if (result == true) {
      _loadCourses();
    }
  }

  void _deleteCourse(String courseCode) async {
      bool success = await ApiService.deleteCourse(courseCode);
      if(success){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ลบข้อมูลสำเร็จ'), backgroundColor: Colors.green),
          );
          _loadCourses(); // โหลดข้อมูลใหม่หลังลบ
      } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('เกิดข้อผิดพลาดในการลบ'), backgroundColor: Colors.red),
          );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course List'), // เปลี่ยน Title
        actions: [
          IconButton(
            onPressed: _navigateToAddScreen,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses found.')); // เปลี่ยนข้อความ
          }

          final courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return ListTile(
                title: Text(course.courseName), // เปลี่ยนเป็น courseName
                subtitle: Text("Credits: ${course.credit}"), // เปลี่ยน Subtitle ให้เหมาะสม
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _navigateToEditScreen(course),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCourse(course.courseCode), // เปลี่ยนเป็น courseCode
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadCourses,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}