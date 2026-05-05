import 'package:flutter/material.dart';
import 'package:smart_real_estate/screens/ProfileScreen.dart';

Widget top_agent(List Top_agent, double Function(double) r) {
  return SizedBox(
    height: r(100),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: Top_agent.length,
      itemBuilder: (context, i) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(userId: Top_agent[i].id), // مرر ID الوكيل هنا
              ),
            );
          },
          child: Container(
            margin: EdgeInsetsGeometry.symmetric(horizontal: r(10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: r(80),
                  width: r(80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border: Border.all(color: Color(0xFFF5F4F8), width: 1),
                  ),
                  child: ClipOval(
                    child: SizedBox.expand(
                      child: Image.asset(Top_agent[i].image, fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(width: r(10)),
                Text(Top_agent[i].name, style: TextStyle(fontSize: r(13))),
              ],
            ),
          ),
        );
      },
    ),
  );
}
