import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/report_details_controller.dart';

class ReportDetailsView extends GetView<ReportDetailsController> {
  const ReportDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReportDetailsController());
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.report.title),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: Get.height / 1.7,
            ),
            child: PageView(
              pageSnapping: true,
              controller: controller.pageController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Hero(
                    tag: controller.photos[0],
                    child: CachedNetworkImage(
                      imageUrl: controller.photos[0],
                      imageBuilder: (context, imageProvider) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
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
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      fadeInDuration: 400.milliseconds,
                    ),
                  ),
              ],
            ),
          ),
          Center(
            child: SmoothPageIndicator(
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
                              const Icon(Icons.person),
                              Text(
                                controller.report.reporterId == "anon" ? "Анонимен" : controller.report.reporterId,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
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
                      Text("Описание", style: Theme.of(context).textTheme.headlineMedium),
                      const Divider(),
                      Text(controller.report.description, style: Theme.of(context).textTheme.bodyLarge)
                    ],
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
