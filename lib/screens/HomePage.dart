import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_real_estate/providers/Agent_Provider.dart';
import '../Widget/estate_card_2D.dart';
import '../providers/AuthProvider.dart';
import '../providers/estate_provider.dart';
import '../Widget/Navidation_bar.dart';
import '../Widget/TopAgentIcon.dart';
import '../Widget/estate_cards.dart';
import '../Widget/responsive_function.dart';
import '../providers/favourite_provider.dart';
import 'ProfileScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCountry = "Cairo, Egypt";

  final List<String> countries = [
    "Cairo, Maadi",
    "Giza, Sheikh Zayed City",
    "Red Sea, Hurghada",
    "Cairo, Heliopolis",
    "Giza, 6th of October City",
  ];


  void showCountryList() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(countries[index]),
              onTap: () {
                setState(() {
                  selectedCountry = countries[index];
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final estateProvider = context.watch<EstateProvider>();
    final estatesList = estateProvider.allEstates;
    final agentProvider = context.watch<AgentProvider>();
    final topAgents = agentProvider.allAgent;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(r(12, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: r(20, context)),

              Row(
                children: [
                  GestureDetector(
                    onTap: showCountryList,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: r(10, context), vertical: r(10, context)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(r(30, context)),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: r(18, context), color: const Color(0xFF234F87)),
                          SizedBox(width: r(5, context)),
                          Text(selectedCountry, style: TextStyle(fontSize: r(12, context), color: const Color(0xFF234F87))),
                          Icon(Icons.keyboard_arrow_down, size: r(18, context), color: const Color(0xFF234F87)),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  iconActionBtn(Icons.notifications_none, context, "/NotificationScreen"),
                  SizedBox(width: r(10, context)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(userId: authProvider.userId),
                        ),
                      );
                    },                    child: CircleAvatar(
                      radius: r(20, context),
                      backgroundImage: AssetImage(authProvider.userImage),
                    ),
                  ),
                ],
              ),

              SizedBox(height: r(20, context)),
              Text("Hey, ${authProvider.userName}!", style: TextStyle(fontSize: r(22, context), fontWeight: FontWeight.bold, color: const Color(0xFF234F87))),
              Text("Let's start exploring", style: TextStyle(fontSize: r(24, context), color: const Color(0xFF234F87))),

              SizedBox(height: r(20, context)),

              GestureDetector(
                onTap: () => Navigator.pushNamed(context, "/Search_Page"),
                child: Container(
                  padding: EdgeInsets.all(r(15, context)),
                  decoration: BoxDecoration(color: const Color(0xFFF5F4F8), borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xFF252B5C)),
                      SizedBox(width: 10),
                      Text("Search modern house...", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),

              SizedBox(height: r(20, context)),

              sectionHeader("Featured Estates", "view all", () => Navigator.pushNamed(context, "/FeatureList")),
              estateCards(
                estatesList,
                    (size) => r(size, context),
                    (index) {
                  estateProvider.toggleFavourite(estatesList[index], context.read<FavouriteProvider>(), authProvider.userId);
                },
                Axis.horizontal,
                3,
              ),

              SizedBox(height: r(20, context)),

              sectionHeader("Top Estate Agent", "explore", () => Navigator.pushNamed(context, "/Top_Agent_Page")),
              top_agent(topAgents, (size) => r(size, context)),

              SizedBox(height: r(30, context)),
              Text("Explore Nearby Estates", style: TextStyle(fontSize: r(18, context), fontWeight: FontWeight.bold, color: const Color(0xFF252B5C))),
              SizedBox(height: r(15, context)),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: estatesList.length > 6 ? 6 : estatesList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: r(15, context),
                  crossAxisSpacing: r(15, context),
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, i) => EstateCard2D(item: estatesList[i]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottom_Navigation_Bar(context, 0),
    );
  }

  Widget sectionHeader(String title, String btnText, VoidCallback onTap) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: r(18, context), fontWeight: FontWeight.bold, color: const Color(0xFF252B5C))),
        const Spacer(),
        TextButton(onPressed: onTap, child: Text(btnText)),
      ],
    );
  }

  Widget iconActionBtn(IconData icon, BuildContext context, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: r(40, context), height: r(40, context),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300)),
        child: Icon(icon, size: r(20, context)),
      ),
    );
  }
}