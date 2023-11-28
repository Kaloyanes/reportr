import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        height: 560,
        width: 50,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.all(7).add(const EdgeInsets.only(
          left: 5,
        )),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => {Get.back(), HapticFeedback.mediumImpact()},
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
