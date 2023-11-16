import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/components/back_button.dart';
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
            toolbarHeight: 55,
            leadingWidth: 55,
            leading: const CustomBackButton(),
            forceElevated: innerBoxIsScrolled,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                "sign_up".tr,
              ),
              // expandedTitleScale: ,
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    label: Text(controller.rolePicked.value == "organization" ? "organization_name".tr : "name".tr),
                  ),
                  controller: controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "fill_field".tr;
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

                    if (value.trim() != controller.confirmPasswordController.text.trim()) {
                      return "passwords_do_not_match".tr;
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
                    label: Text("confirm_password".tr),
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
                    if (value.trim() != controller.passwordController.text.trim()) {
                      return "passwords_do_not_match".tr;
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
                      decoration: InputDecoration(label: Text("type_account".tr)),
                      value: "reporter",
                      items: [
                        DropdownMenuItem<String>(
                          value: "organization",
                          child: Text("organization".tr),
                        ),
                        DropdownMenuItem<String>(
                          value: "employee",
                          child: Text("employee".tr),
                        ),
                        DropdownMenuItem<String>(
                          value: "reporter",
                          child: Text("reporter".tr),
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
                label: Text("sign_up".tr),
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
            "organization_location".tr,
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
                    onMapCreated: (mapController) async {
                      if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
                        var darkmap = await rootBundle.loadString("lib/app/assets/darkMap.json");
                        await mapController.setMapStyle(darkmap);
                      }
                      controller.mapController = mapController;
                    },
                    onTap: (argument) => controller.pickLocation(),
                    initialCameraPosition: CameraPosition(
                      target: snapshot.data ?? const LatLng(40, 20),
                      zoom: 17,
                    ),
                    mapToolbarEnabled: false,
                    liteModeEnabled: true,
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
            title: Text('choose_color_for_organization'.tr),
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
          decoration: InputDecoration(
            label: Text("code".tr),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "fill_field".tr;
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
