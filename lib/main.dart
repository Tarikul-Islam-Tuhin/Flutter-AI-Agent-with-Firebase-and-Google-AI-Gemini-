import 'package:agentic_app_manager/agentic_app_manager/tools.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_ai/firebase_ai.dart';
import './agentic_app_manager/agentic_app_manager_demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(AgenticAppManagerDemo());
}

class TestAgent extends StatefulWidget {
  const TestAgent({super.key});

  @override
  State<TestAgent> createState() => _TestAgentState();
}

class _TestAgentState extends State<TestAgent> {
  String text = '';
  final TextEditingController _promptController = TextEditingController();

  Future<GenerateContentResponse> getContent() async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.0-flash',
      toolConfig: ToolConfig(
        functionCallingConfig: FunctionCallingConfig.any({
          'askConfirmation',
          'setFontFamily',
          'setFontSizeFactor',
          'setAppColor',
          'getDeviceInfo',
          'getBatteryInfo',
          'fileFeedback',
        }),
      ),
      tools: [
        Tool.functionDeclarations([askConfirmationTool, fontFamilyTool, fontSizeFactorTool, appThemeColorTool, deviceInfoTool, batteryInfoTool, fileFeedbackTool]),
      ],
    );

    final prompt = [Content.text(_promptController.text.isEmpty ? 'Write something about scholastica school bd' : _promptController.text)];

    // To generate text output, call generateContent with the text input
    final response = await model.generateContent(prompt);
    return response;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _promptController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 500,
                  child: FutureBuilder<GenerateContentResponse>(
                    future: getContent(),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Container(child: Text(asyncSnapshot.data?.text ?? ''));
                    },
                  ),
                ),
                TextField(controller: _promptController),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text('Ask Gemini'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
