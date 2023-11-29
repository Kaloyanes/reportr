import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/modules/home/components/drawer/content/anon_content.dart';
import 'package:reportr/app/modules/home/components/drawer/content/user_content.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({
    super.key,
  });

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Get.mediaQuery.padding.top + 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  "ReportR",
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),

          // Content
          const Divider(),

          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Column(
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              }

              if (snapshot.hasData) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection("users").doc(snapshot.data!.uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return UserContent(role: snapshot.data!.data()!["role"]);
                  },
                );
              }

              return const AnonContent();
            },
          ),
          SizedBox(
            height: Get.mediaQuery.padding.bottom,
          ),
        ],
      ),
    );
  }
}
