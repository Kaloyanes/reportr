import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:reportr/app/services/auth_service.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final hidePassword = true.obs;

  Future login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      await AuthService().login(emailController.text.trim(), passwordController.text.trim());
    } on FirebaseException catch (e) {
      showError(e.message!);

      return;
    }

    Get.back();
    Get.back();
    ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text("Успешно влязохте в акаунта си")));
  }

  Future forgotPassword() async {
    var forgotFormKey = GlobalKey<FormState>();
    var emailForgotController = TextEditingController(text: emailController.text.trim());

    var email = await showDialog<String>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text("Забравена парола"),
        content: Form(
          key: forgotFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Моля въведете Емайла ви, и ние ще ви изпратим линк на пощата за да въведете нова парола",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailForgotController,
                decoration: const InputDecoration(
                  isCollapsed: false,
                  label: Text("Емайл"),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Попълнете полето";
                  }

                  if (!value.isEmail) return "Неправилен имейл";
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          FilledButton.tonal(
            onPressed: () => Get.back(result: "return"),
            child: const Text("Откажи"),
          ),
          FilledButton.tonal(
            onPressed: () {
              if (forgotFormKey.currentState!.validate()) Get.back(result: emailForgotController.text.trim());
            },
            child: const Text("Изпрати"),
          ),
        ],
      ).animate().scaleXY(
            duration: 500.ms,
            curve: Curves.fastLinearToSlowEaseIn,
          ),
    );

    if (email == "return" || email == null) return;

    try {
      await AuthService().forgotPassword(email);
    } on FirebaseAuthException catch (e) {
      showError(e.message!);
      return;
    }

    ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(content: Text("Изпратен е линк на вашия емайл")));
  }

  void showError(String message) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning),
        title: Text(message),
      ),
    );
  }
}
