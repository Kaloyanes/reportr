import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/modules/report_details/views/report_details_view.dart';
import 'package:reportr/app/modules/reports/components/report_tile_controller.dart';

class ReportTile extends GetView<ReportTileController> {
  const ReportTile({super.key, required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ReportTileController());
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: FutureBuilder(
        future: controller.getImages(report),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null || !snapshot.hasData) {
            return Container(
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return InkWell(
            onTap: () async {
              Get.to(
                () => const ReportDetailsView(),
                arguments: {
                  "report": report,
                  "images": snapshot.data,
                },
              );
            },
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: Hero(
                    tag: snapshot.data![0],
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data![0],
                      imageBuilder: (context, imageProvider) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: imageProvider,
                        ),
                      ),
                      fadeInDuration: 400.milliseconds,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    report.title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.outline,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(report.reporterId == "anon" ? "Анонимен" : "Hello world"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          controller.formatter.format(report.date),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
