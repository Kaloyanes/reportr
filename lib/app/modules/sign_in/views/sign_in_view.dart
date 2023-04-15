import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignInController());
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Влизане",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: controller.emailController,
                decoration: const InputDecoration(
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
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    label: const Text("Парола"),
                    suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                  ),
                  obscureText: controller.hidePassword.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Попълнете полето";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => controller.forgotPassword(),
                  child: const Text("Забравена парола?"),
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () => controller.login(),
                icon: const Icon(Icons.login),
                label: const Text("Влез"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
