import 'package:flutter/material.dart';
import 'student_screen.dart';    // Import หน้า Student
import 'course_screen.dart';     // Import หน้า Course
import 'exam_result_screen.dart'; // Import หน้า ExamResult

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ตัวแปรสำหรับเก็บว่ากำลังเลือกเมนูไหนอยู่ (0=Student, 1=Course, 2=Result)
  int _selectedIndex = 0; 

  // รายการของหน้าจอทั้งหมดที่เราต้องการสลับ
  static const List<Widget> _screens = <Widget>[
    StudentScreen(),
    CourseScreen(),
    ExamResultScreen(),
  ];

  // ฟังก์ชันที่จะทำงานเมื่อผู้ใช้กดที่เมนู
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // อัปเดตค่า index ที่เลือก
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body จะแสดงหน้าจอตาม _selectedIndex ที่เลือก
      body: _screens.elementAt(_selectedIndex), 
      
      // ส่วนของเมนูด้านล่าง
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // เมนูที่ 1: Student
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Students',
          ),
          // เมนูที่ 2: Course
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          // เมนูที่ 3: Exam Results
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Results',
          ),
        ],
        currentIndex: _selectedIndex, // บอกให้รู้ว่าเมนูไหนกำลังถูกเลือกอยู่
        onTap: _onItemTapped,      // เมื่อกดเมนู ให้เรียกใช้ฟังก์ชัน _onItemTapped
      ),
    );
  }
}