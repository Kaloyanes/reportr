import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:get/get.dart';
import 'package:reportr/app/models/department_model.dart';
import 'package:reportr/app/models/report_model.dart';
import 'package:reportr/app/services/department_service.dart';

class AiService {
  final openAI = OpenAI.instance.build(
    token: const String.fromEnvironment("open-ai-key", defaultValue: ""),
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true,
  );

  AiService() {
    printInfo(info: String.fromEnvironment("open-ai-key", defaultValue: ""));
  }

  Future<Department> getDepartmentBasedOnReport(Report report) async {
    var departments = await DepartmentService().getDepartmentsByOwner();

    if (departments.isEmpty) {
      throw Exception("No departments found");
    }

    var prompt =
        "Please review the provided report with name '${report.title}' and description '${report.description}', considering its description, name, and geolocation. Your task is to categorize the report into one of the predefined departments listed in [${departments.map((e) => "Name of The Department: '${e.name}', Description of The Department: ${e.description}")}]. If a department's name implies a specific purpose and the report originates from a location in close proximity to that department, assign the report directly to that department. However, if a department's focus is highly specialized, send the report to the designated department for that specific topic, even if the report's location is not geographically close to it. Just respond with the name of the department. Only the name of the department no comments about it. Not the description, just the name of the department which will be used to categorize the report.";

    var response = await openAI.onChatCompletion(
      request: ChatCompleteText(
        messages: [
          Messages(
            role: Role.system,
            content: prompt,
          ),
        ],
        model: GptTurboChatModel(),
      ),
    );

    if (response == null) {
      throw Exception("No response from OpenAI");
    }

    printInfo(info: response.choices.last.message?.content ?? "");

    var departmentResponse = response.choices.first.message?.content;

    if (departmentResponse == null) {
      throw Exception("No department name found in response");
    }
    printInfo(info: departmentResponse);

    for (var department in departments) {
      if (departmentResponse
              .toLowerCase()
              .contains(department.name.toLowerCase()) ||
          departmentResponse
              .toLowerCase()
              .contains(department.description.toLowerCase()) ||
          department.name
              .toLowerCase()
              .contains(departmentResponse.toLowerCase()) ||
          department.description
              .toLowerCase()
              .contains(departmentResponse.toLowerCase())) {
        return department;
      }
    }

    throw Exception("No department found");
  }
}
