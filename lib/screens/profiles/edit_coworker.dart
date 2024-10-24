import 'package:flutter/material.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:greenhouse/widgets/editing_text_form.dart';

class EditCoworkerScreen extends StatefulWidget {
  const EditCoworkerScreen({
    super.key,
  });

  @override
  State<EditCoworkerScreen> createState() => _EditCoworkerScreenState();
}

class _EditCoworkerScreenState extends State<EditCoworkerScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _roleController;
  late TextEditingController _iconUrlController;
  late TextEditingController _userIdController;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _roleController = TextEditingController();
    _iconUrlController = TextEditingController();
    _userIdController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go back', style: TextStyle(fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage("widget.profile.iconUrl"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditingTextForm(
                        hintText: "First name",
                        valueController: _firstNameController,
                        placeholderText: "widget.profile.firstName",
                      ),
                      EditingTextForm(
                        hintText: "Last name",
                        valueController: _lastNameController,
                        placeholderText: "widget.profile.lastName",
                      ),
                      EditingTextForm(
                        hintText: "Role within the company",
                        valueController: _roleController,
                        placeholderText: "widget.profile.role",
                      ),
                      EditingTextForm(
                        hintText: "Username",
                        valueController: _userIdController,
                        placeholderText: "widget.profile.userId",
                      ),
                      EditingTextForm(
                        hintText: "Image",
                        valueController: _iconUrlController,
                        placeholderText: "widget.profile.iconUrl",
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Color(0xFF67864A),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: Color(0xFF4C6444),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () async {},
                          child: const Text(
                            "Edit employee profile",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Delete employee',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GreenhouseBottomNavigationBar(),
    );
  }
}
