import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:reportr/app/components/back_button.dart';
import 'package:reportr/app/modules/sign_up/views/sign_up_view.dart';

import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignInController());
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
      ),
      body: Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "sign_in".tr,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: controller.emailController,
                decoration: InputDecoration(
                  label: Text("email".tr),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "fill_field".tr;
                  }

                  if (!value.isEmail) return "invalid_email".tr;
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
                    label: Text("password".tr),
                    suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                  ),
                  obscureText: controller.hidePassword.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "fill_field".tr;
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
                  child: Text("${"forgot_password".tr}?"),
                ),
              ),
              FilledButton.icon(
                style: const ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                    Size.fromWidth(200),
                  ),
                ),
                onPressed: () => controller.login(),
                icon: const Icon(Icons.login),
                label: Text("sign".tr),
              ),
              const SizedBox(
                height: 10,
              ),
              FilledButton.tonalIcon(
                style: const ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(
                    Size.fromWidth(200),
                  ),
                ),
                onPressed: () => Get.to(() => const SignUpView()),
                icon: const Icon(Icons.app_registration_rounded),
                label: Text("create_account".tr),
              )
            ],
          ),
        ),
      ),
    );
  }
}
