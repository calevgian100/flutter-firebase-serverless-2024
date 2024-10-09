import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_do_app/translator/logic/translator_service.dart';

class TranslatorScreen extends StatelessWidget {
  TranslatorScreen({super.key});

  final textToTranslate = TextEditingController();

  bool _receivedData(
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
  ) {
    return snapshot.connectionState == ConnectionState.active &&
        snapshot.hasData &&
        (snapshot.data!.data() as Map<String, dynamic>)
            .containsKey('translated');
  }

  List<Widget> _getTranslations(Map<String, dynamic> translated) {
    return translated.entries.map(
      (entry) {
        return Text('${entry.key}: ${entry.value}');
      },
    ).toList();
  }

  Future<void> _translate() async {
    await TranslatorService.translateText(textToTranslate.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _customTextField(),
            _translateButton(),
            _translationStream(),
          ],
        ),
      ),
    );
  }

  Widget _customTextField() {
    return TextField(
      controller: textToTranslate,
      decoration: const InputDecoration(labelText: 'Add text to translate'),
      keyboardType: TextInputType.multiline,
      maxLines: 5,
    );
  }

  Widget _translateButton() {
    return SizedBox(
      height: 50,
      width: 200,
      child: ElevatedButton(
        onPressed: _translate,
        child: const Text('Translate!'),
      ),
    );
  }

  Widget _translationStream() {
    return StreamBuilder(
      stream: TranslatorService.listenToTranslations(),
      builder: (context, snapshot) {
        if (_receivedData(snapshot)) {
          return Column(
            children: _getTranslations(snapshot.data!['translated']),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
