import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/services/department_service.dart';

class ApiService {
  final openAI = OpenAI.instance.build(
    token: "",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true,
  );

  Future<String> getDepartmentBasedOnReport(Report report) async {
    var departments = await DepartmentService().getDepartmentsByOwner();

    if (departments.isEmpty) {
      throw Exception("No departments found");
    }

    var response = await openAI.onCompletion(
      request: CompleteText(
        prompt: "Please review the provided report with name '${report.title}' and description '${report.description}', considering its description, name, and geolocation. Your task is to categorize the report into one of the predefined departments listed in [${departments.map((e) => "Name of Department: ${e.name}, Description of Department: ${e.description}")}]. If a department's name implies a specific purpose and the report originates from a location in close proximity to that department, assign the report directly to that department. However, if a department's focus is highly specialized, send the report to the designated department for that specific topic, even if the report's location is not geographically close to it.",
        model: DavinciModel(),
      ),
    );

    if (response == null) {
      throw Exception("No response from OpenAI");
    }

    return response.choices.first.text;
  }
}
