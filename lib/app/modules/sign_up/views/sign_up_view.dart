import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/components/map_switcher.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignUpController());

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar.large(
            centerTitle: true,
            title: Text(
              "Регистрация",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "Регистрация",
              ),
              expandedTitleScale: 2,
            ),
          ),
        ],
        body: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            children: [
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => TextFormField(
                  decoration: InputDecoration(
                    label: Text(controller.rolePicked.value == "organization" ? "Име на организацията" : "Име"),
                  ),
                  controller: controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Попълнете полето";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
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

                    if (value.trim() != controller.confirmPasswordController.text.trim()) {
                      return "Паролите не се съвпадат";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => TextFormField(
                  controller: controller.confirmPasswordController,
                  decoration: InputDecoration(
                    label: const Text("Повтори парола"),
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
                    if (value.trim() != controller.passwordController.text.trim()) {
                      return "Паролите не се съвпадат";
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Column(
                  children: [
                    DropdownButtonFormField(
                      decoration: const InputDecoration(label: Text("Вид акаунт")),
                      value: "reporter",
                      items: const [
                        DropdownMenuItem<String>(
                          value: "organization",
                          child: Text("Организация"),
                        ),
                        DropdownMenuItem<String>(
                          value: "employee",
                          child: Text("Работник"),
                        ),
                        DropdownMenuItem<String>(
                          value: "reporter",
                          child: Text("Докладващ"),
                        ),
                      ],
                      onChanged: (value) {
                        print(value);
                        controller.rolePicked.value = value as String;
                        switch (value) {
                          case "organization":
                            controller.optionalFields.value = Container(
                              child: organizationFields(context),
                            );
                            break;

                          case "employee":
                            controller.optionalFields.value = Container(
                              child: employeeFields(context),
                            );
                            break;

                          case "reporter":
                            controller.optionalFields.value = Container();
                            break;
                        }
                      },
                    ),
                    AnimatedSize(
                      duration: 700.ms,
                      curve: Curves.easeOutQuint,
                      alignment: Alignment.topCenter,
                      child: controller.optionalFields.value,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FilledButton.tonalIcon(
                onPressed: () => controller.register(),
                icon: const Icon(Icons.app_registration_rounded),
                label: const Text("Регистрирай"),
              ),
              SizedBox(
                height: Get.mediaQuery.viewPadding.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column organizationFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        const SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Локация на организацията",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 150,
          child: StreamBuilder(
            stream: controller.locationPicked.stream,
            initialData: controller.locationPicked.value,
            builder: (context, snapshot) {
              return MapSwitcher(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    onMapCreated: (mapController) => controller.mapController = mapController,
                    onTap: (argument) => controller.pickLocation(),
                    initialCameraPosition: CameraPosition(
                      target: snapshot.data ?? const LatLng(40, 20),
                      zoom: 17,
                    ),
                    mapToolbarEnabled: false,
                    liteModeEnabled: true,
                    mapType: MapType.hybrid,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Obx(
          () => ListTile(
            title: const Text('Изберете цвят на организацията'),
            trailing: ColorIndicator(
              width: 44,
              height: 44,
              borderRadius: 22,
              color: controller.organizationColor.value,
            ),
            onTap: () => controller.changeColor(),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Column employeeFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: controller.inviteCodeController,
          decoration: const InputDecoration(
            label: Text("Код"),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Попълнете полето";
            }

            return null;
          },
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
