import 'dart:io';

import 'package:shop/data/services/edit_code_service.dart';


final editCodeService = EditCodeService();

Future<void> main() async {
  final file = File('lib/features/screens/profile/view/profile_screen.dart');
  print('Processing file: ${file.path}');
  final content = await file.readAsString();

  final updatedCode = await editCodeService.editCode(
    fileContent: content,
    instruction: "still under the bottom bar why please adjust this  "
  );

  if (updatedCode != null) {
    await file.writeAsString(updatedCode);
    print("✅ Updated ${file.path}");
  } else {
    print("❌ Failed to update ${file.path}");
  }
}
