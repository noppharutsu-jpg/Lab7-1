import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/student.dart';
import '../model/course.dart';
import '../model/exam_result.dart'; // <-- เพิ่ม import นี้

class ApiService {
  static const String baseUrl = 'http://192.168.56.1/Lab7_9.26/api';


  // --- Student Functions ---
static Future<List<Student>> fetchStudents() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/student.php'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Student.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load students: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching students: $e');
  }
}

  static Future<bool> addStudent(Student student) async {
    final response = await http.post(
      Uri.parse('$baseUrl/student.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(student.toJson()),
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateStudent(Student student) async {
    final response = await http.put(
      Uri.parse('$baseUrl/student.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(student.toJson()),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteStudent(String studentCode) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/student.php?student_code=$studentCode'),
    );
    return response.statusCode == 200;
  }

  // --- Course Functions ---
  static Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/course.php'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Course.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  static Future<bool> addCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/course.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(course.toJson()),
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateCourse(Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/course.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(course.toJson()),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteCourse(String courseCode) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/course.php?course_code=$courseCode'),
    );
    return response.statusCode == 200;
  }

  // --- ExamResult Functions (ส่วนที่เพิ่มเข้ามาใหม่) ---

  static Future<List<ExamResult>> fetchExamResults() async {
    final response = await http.get(Uri.parse('$baseUrl/exam_result.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ExamResult.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load exam results');
    }
  }

  static Future<bool> addExamResult(ExamResult result) async {
    final response = await http.post(
      Uri.parse('$baseUrl/exam_result.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'student_code': result.studentCode,
        'course_code': result.courseCode,
        'point': result.point.toString(),
      }),
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateExamResult(ExamResult result) async {
    final response = await http.put(
      Uri.parse('$baseUrl/exam_result.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'id': result.id,
        'point': result.point.toString(),
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteExamResult(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/exam_result.php?id=$id'),
    );
    return response.statusCode == 200;
  }
}