import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/models/reporter_model.dart';
import 'package:reportr/app/modules/report_details/views/report_details_view.dart';
import 'package:reportr/app/modules/reports/components/report_tile_controller.dart';

class ReportTile extends GetView<ReportTileController> {
  const ReportTile({super.key, required this.report, required this.reporter, this.sender = false});

  final Report report;
  final Reporter reporter;
  final bool sender;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReportTileController());
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: FutureBuilder(
        future: controller.getFirstImage(report),
        builder: (context, snapshot) {
          return Material(
            child: InkWell(
              onTap: () async {
                if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null || !snapshot.hasData) {
                  return;
                }

                Get.to(
                  () => const ReportDetailsView(),
                  arguments: {
                    "report": report,
                    "reporter": reporter,
                    "thumbnail": snapshot.data,
                    "sender": sender,
                  },
                );
              },
              enableFeedback: true,
              child: Column(
                children: [
                  Builder(
                    builder: (context) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.data == null ||
                          !snapshot.hasData) {
                        return const SizedBox(
                          height: 250,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return Stack(
                        children: [
                          Container(
                            constraints: const BoxConstraints(
                              maxHeight: 250,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(snapshot.data!),
                              ),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                          ),
                          const Row(
                            children: [
                              Spacer(),
                              Stack(
                                children: [
                                  // Container(
                                  //   width: 70,
                                  //   height: 30,
                                  //   decoration: BoxDecoration(
                                  //     color: Theme.of(context).colorScheme.background.withAlpha(100),
                                  //     borderRadius: const BorderRadius.only(
                                  //       bottomLeft: Radius.circular(20),
                                  //     ),
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: [
                                  //       const Icon(
                                  //         Icons.star, color: Colors.yellow,
                                  //         // color: Theme.of(context).colorScheme.primary,
                                  //       ),
                                  //       Text(
                                  //         report.rating.toStringAsFixed(1),
                                  //         style: Theme.of(context).textTheme.labelLarge,
                                  //       ),
                                  //       // RatingBar.builder(
                                  //       //   itemBuilder: (context, index) => const Icon(Icons.star),
                                  //       //   onRatingUpdate: (val) {},
                                  //       //   ignoreGestures: true,
                                  //       //   initialRating: report.rating,
                                  //       //   allowHalfRating: true,
                                  //       // ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          foregroundImage: CachedNetworkImageProvider(reporter.photoUrl),
                          child: const Icon(Icons.person),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(reporter.name),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SizedBox(
                      height: 70,
                      child: Text(
                        report.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          controller.formatter.format(report.date),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Spacer(),
                        Text(
                          report.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
