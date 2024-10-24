import 'package:flutter/material.dart';
import 'package:greenhouse/models/company.dart';
import 'package:greenhouse/services/company_service.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:greenhouse/widgets/editing_text_form.dart';
import 'package:greenhouse/widgets/message_response.dart';

class EditCompanyScreen extends StatefulWidget {
  const EditCompanyScreen({
    super.key,
  });

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  final _companyService = CompanyService();
  Company? company;

  late TextEditingController _nameController;
  late TextEditingController _tinController;
  late TextEditingController _iconUrlController;

  Future<void> initialize() async {
    company = await _companyService.getCompanyByProfileId();
    setState(() {});
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _tinController = TextEditingController();
    _iconUrlController = TextEditingController();
    initialize();
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
                  backgroundImage: NetworkImage(company?.logoUrl ??
                      'https://miro.medium.com/v2/resize:fit:1260/1*ngNzwrRBDElDnf2CLF_Rbg.gif'),
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
                        hintText: "Name",
                        valueController: _nameController,
                        placeholderText: company?.name ?? 'Company name',
                      ),
                      EditingTextForm(
                        hintText: "Tin",
                        valueController: _tinController,
                        placeholderText: company?.tin ?? 'TIN',
                      ),
                      EditingTextForm(
                        hintText: "Image",
                        valueController: _iconUrlController,
                        placeholderText: company?.logoUrl ??
                            'https://miro.medium.com/v2/resize:fit:1260/1*ngNzwrRBDElDnf2CLF_Rbg.gif',
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
                          onPressed: () async {
                            void editCompany() {
                              try {
                                _companyService.updateCompany(
                                  Company(
                                    id: company?.id ?? '',
                                    name: _nameController.text,
                                    tin: _tinController.text,
                                    logoUrl: _iconUrlController.text,
                                  ),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                print('Failed to update company: $e');
                              }
                            }

                            messageResponse(
                              context,
                              "Are you sure you want to\nedit this profile?",
                              "Yes, Edit",
                              editCompany,
                            );
                          },
                          child: Text(
                            "Edit company profile",
                            style: TextStyle(color: Colors.white),
                          ),
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
