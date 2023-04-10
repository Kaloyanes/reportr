import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/services/auth_service.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final showPassword = false.obs;

  Future login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      await AuthService()
          .login(emailController.text.trim(), passwordController.text.trim());
    } on FirebaseException catch (e) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: Text(e.message!),
        ),
      );
    }
  }
}
