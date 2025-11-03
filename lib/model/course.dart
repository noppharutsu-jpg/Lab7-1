class Course {
  final String courseCode;
  final String courseName;
  final int credit;

  Course({
    required this.courseCode,
    required this.courseName,
    required this.credit,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseCode: json['course_code'],
      courseName: json['course_name'],
      credit: int.tryParse(json['credit'].toString()) ?? 0,
    );
  }

  // --- เพิ่มฟังก์ชันนี้เข้าไป ---
  Map<String, dynamic> toJson() {
    return {
      'course_code': courseCode,
      'course_name': courseName,
      // แปลง credit กลับเป็น String ตอนส่งข้อมูล
      'credit': credit.toString(), 
    };
  }
}