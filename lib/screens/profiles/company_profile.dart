import 'package:flutter/material.dart';
import 'package:greenhouse/models/company.dart';
import 'package:greenhouse/models/profile.dart';
import 'package:greenhouse/services/company_service.dart';
import 'package:greenhouse/services/profile_service.dart';
import 'package:greenhouse/widgets/avatar.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  final _companyService = CompanyService();
  final _profileService = ProfileService();

  Company? company;
  List<Profile> profiles = [];

  String searchQuery = '';

  Future<void> initialize() async {
    company = await _companyService.getCompanyByProfileId();
    profiles = await _profileService.getProfilesByCompany(company?.id ?? '');
    print(profiles);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go back', style: TextStyle(fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Center(
                child: Avatar(
                  imageUrl: company?.logoUrl ??
                      'https://miro.medium.com/v2/resize:fit:1260/1*ngNzwrRBDElDnf2CLF_Rbg.gif',
                  radius: 70,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _companyInfo("Company name", company?.name ?? ''),
                      _companyInfo("TIN", company?.tin ?? ''),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color(0xFFE1E1E1),
                ),
                child: _employeesSection(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GreenhouseBottomNavigationBar(),
    );
  }

  Widget _employeesSection(BuildContext context) {
    List<Profile> filteredCoworkers = profiles
        .where((profile) =>
            profile.firstName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            profile.lastName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            profile.role.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: filteredCoworkers.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Employees',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            } else if (index == 1) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search employees...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              );
            } else {
              Profile coworker = filteredCoworkers[index - 2];
              return CoworkerCard(
                name: '${coworker.firstName} ${coworker.lastName}',
                role: coworker.role,
                image: coworker.iconUrl,
              );
            }
          }),
    );
  }

  Widget _companyInfo(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(fontSize: 16, color: Color(0xFF444444)),
        ),
      ],
    );
  }
}

class CoworkerCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;

  const CoworkerCard({
    super.key,
    required this.name,
    required this.role,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      padding: EdgeInsets.all(7),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              image,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF727272),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
