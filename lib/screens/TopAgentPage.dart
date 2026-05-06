import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widget/responsive_function.dart';
import '../providers/Agent_Provider.dart';
import '../screens/ProfileScreen.dart';

class Top_Agent_Page extends StatelessWidget {
  const Top_Agent_Page({super.key});

  @override
  Widget build(BuildContext context) {
    final agentProvider = context.watch<AgentProvider>();
    final topAgents = agentProvider.allAgent;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF252B5C)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r(20, context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top Estate Agent",
                  style: TextStyle(
                    fontSize: r(22, context),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF252B5C),
                  ),
                ),
                SizedBox(height: r(5, context)),
                Text(
                  "Find the best recommendations place to live",
                  style: TextStyle(color: Colors.grey, fontSize: r(14, context)),
                ),
              ],
            ),
          ),
          SizedBox(height: r(20, context)),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(r(20, context)),
              itemCount: topAgents.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: r(15, context),
                mainAxisSpacing: r(15, context),
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, i) {
                final agent = topAgents[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userId: agent.id.toString()),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F4F8),
                      borderRadius: BorderRadius.circular(r(25, context)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: r(12, context),
                          left: r(12, context),
                          child: Container(
                            padding: EdgeInsets.all(r(6, context)),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8BC34A),
                              borderRadius: BorderRadius.circular(r(8, context)),
                            ),
                            child: Text(
                              "#${i + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: r(35, context),
                                backgroundImage: AssetImage(agent.image),
                              ),
                              SizedBox(height: r(10, context)),
                              Text(
                                agent.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF252B5C),
                                  fontSize: r(14, context),
                                ),
                              ),
                              SizedBox(height: r(4, context)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  Text(
                                    " ${agent.rating}",
                                    style: TextStyle(
                                      fontSize: r(12, context),
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}