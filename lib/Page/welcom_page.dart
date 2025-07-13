import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tasky/Page/switch_screens.dart';

import '../core/colors/styles.dart';
import '../widgets/Text_Fild.dart';

class WelcomHome extends StatelessWidget {
  WelcomHome({super.key});

  final TextEditingController inputText = TextEditingController();

  // This KEY use for Form with TextForm Validetor
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    // So Row is only as big as its children
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Center content inside Row
                    children: [
                      Image.asset(
                        "assets/images/LogoTasky.png",
                        width: 42,
                        height: 42,
                      ),
                      const SizedBox(width: 16),
                      // Add some space between image and text
                       Text(
                        "Tasky",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 118),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome To Tasky ",
                        style: Theme.of(context).textTheme.displaySmall
                      ),
                      Image(
                        image: AssetImage(
                          "assets/images/waving-hand-medium-light-skin-tone-svgrepo-com 1.png",
                        ),
                        width: 28,
                        height: 28,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your productivity journey starts here. ",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16)
                  ),
                  SizedBox(height: 24),
                  SvgPicture.asset(
                    "assets/images/pana.svg",
                    width: 215,
                    height: 204,
                  ),
                  SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "FULL Name ",
                        style:Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16)
                      ),
                    ),
                  ),
                  // Text Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormFildWidget(
                      inputText: inputText,
                      hintError: "Please Enter Your Full Name",
                      hintLable: "Enter Your Full Name",
                    ),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_key.currentState?.validate() ?? false) {
                          final SharedPreferences perfs =
                              await SharedPreferences.getInstance();
                          await perfs.setString(
                            "username",
                            inputText.value.text,
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return SiwtchScreen();
                              },
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primryColor,
                        foregroundColor: AppColor.textColor,
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),

                      child: Text("Let’s Get Started"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
