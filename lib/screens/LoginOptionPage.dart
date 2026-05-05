import 'package:flutter/material.dart';

class LoginOptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> image = [
      "assets/images/loginOptionalPage/Rectangle_8.png",
      "assets/images/loginOptionalPage/Rectangle_9.png",
      "assets/images/loginOptionalPage/Rectangle_10.png",
      "assets/images/loginOptionalPage/Rectangle_11.png",
    ];

    double width = MediaQuery.of(context).size.width;

    double scale = (width / 375).clamp(0.85, 1.3);
    double r(double size) => size * scale;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
            children: [
              // 🔹 MAIN CONTAINER
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(r(12)),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      // 🔹 GRID (takes flexible space)
                      Expanded(
                        flex: 4,
                        child: GridView.builder(
                          itemCount: image.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: width < 600 ? 2 : 3,
                            crossAxisSpacing: r(10),
                            mainAxisSpacing: r(10),
                            childAspectRatio: 1.2,
                          ),
                          itemBuilder: (context, i) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(r(15)),
                              child: Image.asset(
                                image[i],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: r(15)),

                      // 🔹 TITLE
                      Text(
                        "Ready to explore?",
                        style: TextStyle(
                          fontSize: r(18),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: r(15)),

                      // 🔹 EMAIL BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: r(50),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, "/Login");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFF8BC83F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(r(12)),
                            ),
                          ),
                          label: Text(
                            "Continue with Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: r(14),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: r(10)),

                      Text("or", style: TextStyle(fontSize: r(14))),

                      SizedBox(height: r(10)),

                      // 🔹 SOCIAL BUTTONS
                      Row(
                        children: [
                          buildSocialButton("assets/images/google.png", r),
                          SizedBox(width: r(10)),
                          buildSocialButton("assets/images/facebook.png", r),
                        ],
                      ),

                      SizedBox(height: r(15)),

                      // 🔹 REGISTER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(fontSize: r(13)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/Register");
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: r(13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // 🔹 SOCIAL BUTTON
  Widget buildSocialButton(String url, double Function(double) r) {
    return Expanded(
      child: SizedBox(
        height: r(50),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r(12)),
            ),
          ),
          child: Image.asset(url, height: r(24)),
        ),
      ),
    );
  }
}