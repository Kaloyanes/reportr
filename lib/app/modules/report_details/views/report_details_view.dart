import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reportr/app/components/map_switcher.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controllers/report_details_controller.dart';

class ReportDetailsView extends GetView<ReportDetailsController> {
  const ReportDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReportDetailsController());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => controller.delete(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                controller.report.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: Get.height / 1.7,
            ),
            child: Obx(
              () => PageView(
                pageSnapping: true,
                controller: controller.pageController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Hero(
                      tag: Get.arguments["thumbnail"],
                      child: CachedNetworkImage(
                        imageUrl: Get.arguments["thumbnail"],
                        imageBuilder: (context, imageProvider) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        fadeInDuration: 400.milliseconds,
                      ),
                    ),
                  ),
                  for (var image in controller.photos.sublist(1))
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        imageBuilder: (context, imageProvider) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        fadeInDuration: 400.milliseconds,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Center(
            child: Obx(
              () => SmoothPageIndicator(
                controller: controller.pageController, // PageController
                count: controller.photos.length,
                effect: WormEffect(
                  activeDotColor: Theme.of(context).colorScheme.primaryContainer,
                ),
                onDotClicked: (index) => controller.pageController.animateToPage(
                  index,
                  duration: 600.milliseconds,
                  curve: Curves.easeOutQuint,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                foregroundImage: CachedNetworkImageProvider(controller.reporter.photoUrl),
                                child: const Icon(Icons.person),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(controller.reporter.name),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.calendar_month),
                              Text(
                                controller.formatter.format(
                                  controller.report.date,
                                ),
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Card(
                  child: Column(
                    children: [
                      Text("Описание", style: Theme.of(context).textTheme.headlineSmall),
                      const Divider(),
                      Text(
                        controller.report.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: MapSwitcher(
                          child: GoogleMap(
                            onTap: (argument) => launchUrlString(
                                "geo:${controller.report.location.latitude},${controller.report.location.longitude}?q=${controller.report.location.latitude},${controller.report.location.longitude}(Report place)"),
                            mapType: MapType.hybrid,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(controller.report.location.latitude, controller.report.location.longitude),
                              zoom: 18,
                            ),
                            mapToolbarEnabled: false,
                            liteModeEnabled: true,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Оценете доклада по приоритет",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: controller.reportRating.value,
                  allowHalfRating: true,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onRatingUpdate: (va) => controller.reportRating.value = va,
                  glowRadius: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => AnimatedContainer(
                    duration: 500.milliseconds,
                    curve: Curves.easeOutCubic,
                    constraints: controller.reportRating.value > 0 &&
                            !controller.hasRated.value &&
                            controller.reportRating.value != controller.report.rating
                        ? BoxConstraints.expand(height: 70, width: Get.width)
                        : const BoxConstraints.expand(height: 0, width: 0),
                    child: ElevatedButton(onPressed: () => controller.updateRating(), child: const Text("Оценете")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
