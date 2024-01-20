import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:reportr/app/services/department_service.dart';

class ApiService {
  final openAI = OpenAI.instance.build(
    token: "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",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
    enableLog: true,
  );

  // Based on a description, choose one of the departments
  Future<String> getDepartmentBasedOnReport(String description) async {
    var departments = await DepartmentService().getDepartmentsByOwner();

    if (departments.isEmpty) {
      throw Exception("No departments found");
    }

    var response = await openAI.onCompletion(
      request: CompleteText(
        prompt: "",
        model: DavinciModel(),
      ),
    );

    if (response == null) {
      throw Exception("No response from OpenAI");
    }

    return response.choices.first.text;
  }
}
