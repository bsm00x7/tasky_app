import 'package:flutter/material.dart';
import 'package:tasky/features/home/constant/constant.dart';
import 'package:tasky/service/preferences.dart';

import '../../core/colors/styles.dart';
import '../../core/theme/theme_controller.dart';
import '../../widgets/Text_Fild.dart';

class Userdetails extends StatelessWidget {
  Userdetails({super.key});

  final TextEditingController inputText = TextEditingController();
  final TextEditingController inputQuote = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: ThemeController().getterThemeMode() == ThemeMode.dark
              ? Color(0xffFFFCFC)
              : Color(0xff161F1B),
        ),
        title: Text("User Details"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Text(
                "User Name",
                style: Theme.of(
                  context,
                ).textTheme.displaySmall!.copyWith(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormFildWidget(
                inputText: inputText,
                hintError: 'Enter Your Full Name',
                hintLable: 'Enter New Name',
              ),
              SizedBox(height: 8),
              Text(
                "Motivation Quote",
                style: Theme.of(
                  context,
                ).textTheme.displaySmall!.copyWith(fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: inputQuote,
                maxLines: 6,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "One task at a time. One step closer.",
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState?.validate() ?? false) {
                      await PreferenceManager().setString(
                        StorgeKey.username,
                        inputText.value.text,
                      );
                    }
                    if (inputQuote.value.text.trim().isNotEmpty) {
                      PreferenceManager().setString(
                       StorgeKey.motivation,
                        inputQuote.value.text,
                      );
                      Navigator.pop(context);
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primryColor,
                    foregroundColor: AppColor.textColor,
                    minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  ),

                  child: Text("Save Change"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
