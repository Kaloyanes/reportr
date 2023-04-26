import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/models/reporter_model.dart';
import 'package:reportr/app/modules/report_details/views/report_details_view.dart';
import 'package:reportr/app/modules/reports/components/report_tile_controller.dart';

class ReportTile extends GetView<ReportTileController> {
  const ReportTile({super.key, required this.report, required this.reporter});

  final Report report;
  final Reporter reporter;

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
        future: controller.getFirstImage(report),
        builder: (context, snapshot) {
          return InkWell(
            onTap: () async {
              Get.to(
                () => const ReportDetailsView(),
                arguments: {
                  "report": report,
                  "reporter": reporter,
                  "thumbnail": snapshot.data,
                },
              );
            },
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data == null ||
                        !snapshot.hasData) {
                      return const SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Container(
                      child: Hero(
                        createRectTween: (begin, end) => MaterialRectCenterArcTween(begin: begin, end: end),
                        tag: snapshot.data!,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: snapshot.data!,
                          imageBuilder: (context, imageProvider) => ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image(
                              image: imageProvider,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Expanded(
                    child: Text(
                      report.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18),
                      textAlign: TextAlign.left,
                      // softWrap: false,
                      maxLines: 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.formatter.format(report.date),
                    ),
                  ),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.outline,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: RatingBar.builder(
                        itemBuilder: (context, index) => const Icon(Icons.star),
                        onRatingUpdate: (val) {},
                        ignoreGestures: true,
                        initialRating: report.rating,
                        allowHalfRating: true,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    child: Row(
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(reporter.name),
                        ),
                      ],
                    ),
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
