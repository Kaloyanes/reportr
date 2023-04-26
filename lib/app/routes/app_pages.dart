import 'package:get/get.dart';

import '../modules/chats/bindings/chats_binding.dart';
import '../modules/chats/views/chats_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/my_reports/bindings/my_reports_binding.dart';
import '../modules/my_reports/views/my_reports_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/report_details/bindings/report_details_binding.dart';
import '../modules/report_details/views/report_details_view.dart';
import '../modules/sign_in/bindings/sign_in_binding.dart';
import '../modules/sign_in/views/sign_in_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/worker_manager/bindings/worker_manager_binding.dart';
import '../modules/worker_manager/views/worker_manager_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_DETAILS,
      page: () => const ReportDetailsView(),
      binding: ReportDetailsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHATS,
      page: () => const ChatsView(),
      binding: ChatsBinding(),
    ),
    GetPage(
      name: _Paths.WORKER_MANAGER,
      page: () => const WorkerManagerView(),
      binding: WorkerManagerBinding(),
    ),
    GetPage(
      name: _Paths.MY_REPORTS,
      page: () => const MyReportsView(),
      binding: MyReportsBinding(),
    ),
  ];
}
