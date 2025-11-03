class ExamResult {
  final int id;
  final String studentCode;
  final String studentName;
  final String courseCode;
  final String courseName;
  final int point;

  ExamResult({
    required this.id,
    required this.studentCode,
    required this.studentName,
    required this.courseCode,
    required this.courseName,
    required this.point,
  });

  // Factory constructor สำหรับแปลง JSON ที่ได้รับจาก API
  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: int.tryParse(json['id'].toString()) ?? 0,
      studentCode: json['student_code'] ?? '',
      studentName: json['student_name'] ?? '',
      courseCode: json['course_code'] ?? '',
      courseName: json['course_name'] ?? '',
      point: int.tryParse(json['point'].toString()) ?? 0,
    );
  }

  // ฟังก์ชันสำหรับแปลง Object เป็น JSON เพื่อส่งไปให้ API (สำหรับ Add/Update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_code': studentCode,
      'course_code': courseCode,
      'point': point.toString(),
    };
  }
}