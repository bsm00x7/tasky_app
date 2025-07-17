import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/features/home/constant/constant.dart';
import 'package:tasky/features/profile/userDetails.dart';
import 'package:tasky/features/welcom/welcom_page.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/service/preferences.dart';
import 'package:path/path.dart' as path;
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  bool isLoading = false;
  String? motivation;
  String? _selectedImage;

  @override
  void initState() {
    _loaddetails();
    super.initState();
  }
  void _loaddetails() async {
    setState(() {
      userName = PreferenceManager().getString(StorgeKey.username);
      motivation = PreferenceManager().getString(StorgeKey.motivation);
      _selectedImage = PreferenceManager().getString(StorgeKey.user_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: !isLoading
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: _selectedImage!=null ? FileImage(File(_selectedImage!)):AssetImage(
                              "assets/images/Leading element.png",
                            ),
                            radius: 50,
                            backgroundColor: Colors.transparent,
                          ),
                          GestureDetector(
                            onTap: ()  async{
                              _showOptionSourceImage(context, (File image) {
                                setState(() {
                                  _selectedImage = image.path;
                                });
                                _saveImageDirectory(image);
                              });
                            },

                            child: Icon(
                              Icons.camera_alt,
                              color: ThemeController().getterThemeMode() == ThemeMode.dark ?  const Color(0xffFFFCFC): const Color(0xff161F1B),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            userName!,
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall!.copyWith(fontSize: 20),
                          ),
                          Text(
                            motivation ??
                                "One task at a time. One step closer.",
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall!.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Profile Info",
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall!.copyWith(fontSize: 20),
                    ),
                    SizedBox(height: 6),
                    ListTile(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Userdetails();
                            },
                          ),
                        );
                        _loaddetails();
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: _buildSvgPicture("assets/images/profile.svg"),
                      title: Text(
                        "User Details",
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall!.copyWith(fontSize: 16),
                      ),
                      trailing: _buildSvgPicture("assets/images/Next.svg"),
                    ),
                    Divider(color:ThemeController().getterThemeMode() == ThemeMode.dark ?  Color(0xff6E6E6E): Color(0xffD1DAD6)),
                    SizedBox(height: 3),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: _buildSvgPicture("assets/images/moon.svg"),
                      title: Text(
                        "Dark Mode",
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall!.copyWith(fontSize: 16),
                      ),
                      trailing: ValueListenableBuilder(
                        valueListenable: ThemeController.theme,
                        builder: (BuildContext context, value, Widget? child) {
                          return Switch(
                            value: value == ThemeMode.dark,
                            onChanged: (bool? value) async {
                              ThemeController.toggleTheme();
                            },
                          );
                        },
                      ),
                    ),
                    Divider(color:ThemeController().getterThemeMode() == ThemeMode.dark ?  Color(0xff6E6E6E): Color(0xffD1DAD6)),
                    SizedBox(height: 3),

                    ListTile(
                      onTap: () async {
                        await PreferenceManager().remove(StorgeKey.username);
                        await PreferenceManager().remove(StorgeKey.motivation);
                        await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return WelcomHome();
                            },
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: _buildSvgPicture("assets/images/logout.svg"),
                      title: Text(
                        "Log Out",
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall!.copyWith(fontSize: 16),
                      ),
                      trailing: _buildSvgPicture("assets/images/Next.svg"),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  SvgPicture _buildSvgPicture(String Path) => SvgPicture.asset(
    Path,
    colorFilter: ColorFilter.mode(ThemeController().getterThemeMode() == ThemeMode.dark ? Color(0xffFFFCFC) : Color(0xff161F1B), BlendMode.srcIn)
  );

  void _showOptionSourceImage(BuildContext context, Function(File file) SavePhoto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Choose Image", style: Theme.of(context).textTheme.titleLarge),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  File imageFile = File(pickedImage.path);
                  SavePhoto(imageFile);
                }
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 10),
                  Text("Camera", style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  File imageFile = File(pickedImage.path);
                  SavePhoto(imageFile);
                }
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 10),
                  Text("Gallery", style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
          ],
        );
      },
    );
  }


  void _saveImageDirectory(File file)async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String fileName = path.basename(file.path);
    final dirFile =await File(file.path).copy('${appDocumentsDir.path}/${fileName}');
    await PreferenceManager().setString(StorgeKey.user_image,dirFile.path );
  }


}
