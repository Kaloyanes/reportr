import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reportr/app/models/department_model.dart';
import 'package:uuid/uuid.dart';

class DepartmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Department?> createDepartment(String name, String description) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) return null;

      String ownerId = user.uid;
      String departmentId = const Uuid().v4();

      Department newDepartment = Department(
        id: departmentId,
        name: name,
        description: description,
        ownerId: ownerId,
      );

      await _firestore
          .collection('departments')
          .doc(departmentId)
          .set(newDepartment.toMap());

      return newDepartment;
    } catch (e) {
      print('Error creating department: $e');
    }
  }

  Future<void> deleteDepartment(String departmentId) async {
    try {
      await _firestore.collection('departments').doc(departmentId).delete();
    } catch (e) {
      print('Error deleting department: $e');
    }

    // every worker that has the same departmentId as the deleted department will be assigned to the default department
    try {
      await _firestore
          .collection('users')
          .where('departmentId', isEqualTo: departmentId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({
            'departmentId': '',
          });
        }
      });
    } catch (e) {
      print('Error reassigning workers to default department: $e');
    }
  }

  Future<void> assignReportToDepartment(
      String reportId, String departmentId) async {
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

      QuerySnapshot querySnapshot = await _firestore
          .collection('departments')
          .where('ownerId', isEqualTo: user.uid)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              Department.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error getting departments: $e');
      return [];
    }
  }

  Future assignUserToDepartment(String userId, String departmentId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'departmentId': departmentId,
      });
    } catch (e) {
      print('Error assigning user to department: $e');
    }
  }
}
