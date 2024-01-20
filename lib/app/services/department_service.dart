import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reportr/app/models/department_model.dart';
import 'package:uuid/uuid.dart';

class DepartmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createDepartment(String description) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) return;

      String ownerId = user.uid;
      String departmentId = const Uuid().v4();

      Department newDepartment = Department(
        id: departmentId,
        description: description,
        ownerId: ownerId,
      );

      await _firestore.collection('departments').doc(departmentId).set(newDepartment.toMap());
    } catch (e) {
      print('Error creating department: $e');
    }
  }

  Future<void> assignReportToDepartment(String reportId, String departmentId) async {
    try {
      await _firestore.collection('reports').doc(reportId).update({
        'departmentId': departmentId,
      });
    } catch (e) {
      print('Error assigning report to department: $e');
    }
  }

  Future<List<Department>> getDepartmentsByOwner() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) return [];

      QuerySnapshot querySnapshot =
          await _firestore.collection('departments').where('ownerId', isEqualTo: user.uid).get();

      return querySnapshot.docs.map((doc) => Department.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      print('Error getting departments: $e');
      return [];
    }
  }
}
