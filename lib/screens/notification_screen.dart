import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<String> categories = const [
    "All",
    "Review",
    "Sold",
    "House",
    "Villa",
    "Apartment",
  ];

  int selectedIndex = 0;

  final List<Map<String, dynamic>> todayList = const [
    {
      "name": "Emmett Perry",
      "msg": "Just messaged you...",
      "time": "10 mins ago",
      "img": "assets/images/top_Agent/Shape-3.png",
    },
    {
      "name": "Geraldo",
      "msg": "Just giving 5 Star review...",
      "time": "40 mins ago",
      "img": "assets/images/top_Agent/Shape-1.png",
    },
  ];

  final List<Map<String, dynamic>> olderList = const [
    {
      "name": "Velma Cole",
      "msg": "Just favorited your listing...",
      "time": "Yesterday",
      "img": "assets/images/top_Agent/Shape-2.png",
    },
    {
      "name": "Velma Cole",
      "msg": "Just favorited your listing...",
      "time": "Yesterday",
      "img": "assets/images/top_Agent/Shape-3.png",
    },
    {
      "name": "Velma Cole",
      "msg": "Just favorited your listing...",
      "time": "Yesterday",
      "img": "assets/images/top_Agent/Shape-4.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final double scale = (width / 375).clamp(0.85, 1.3);
    double r(double size) => size * scale;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: r(20), vertical: r(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5F4F8),
                    ),
                  ),
                  Text("Notification",style: TextStyle(fontWeight: FontWeight.bold),),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete_outline),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5F4F8),
                    ),
                  ),
                ],
              ),
            ),



            SizedBox(height: r(25)),

            SizedBox(
              height: r(40),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                padding: EdgeInsets.symmetric(horizontal: r(20)),
                itemBuilder: (context, index) {
                  final bool isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: Container(
                      margin: EdgeInsets.only(right: r(12)),
                      padding: EdgeInsets.symmetric(horizontal: r(20)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF254D60)
                            : const Color(0xFFF5F4F8),
                        borderRadius: BorderRadius.circular(r(20)),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          fontSize: r(13),
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF254D60),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: r(30)),

            sectionTitle("Today", r),

            ListView.builder(
              itemCount: todayList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return notificationItem(todayList[index], r);
              },
            ),

            SizedBox(height: r(20)),

            sectionTitle("Older notifications", r),

            ListView.builder(
              itemCount: olderList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return notificationItem(olderList[index], r);
              },
            ),

            SizedBox(height: r(20)),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text, double Function(double) r) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r(25)),
      child: Text(
        text,
        style: TextStyle(fontSize: r(18), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget notificationItem(
    Map<String, dynamic> data,
    double Function(double) r,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: r(20), vertical: r(8)),
      padding: EdgeInsets.all(r(15)),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F8),
        borderRadius: BorderRadius.circular(r(25)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: r(25), backgroundImage: AssetImage(data["img"])),

          SizedBox(width: r(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["name"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: r(14),
                  ),
                ),
                Text(
                  data["msg"],
                  style: TextStyle(color: Colors.grey, fontSize: r(13)),
                ),
                Text(
                  data["time"],
                  style: TextStyle(color: Colors.blueGrey, fontSize: r(11)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


