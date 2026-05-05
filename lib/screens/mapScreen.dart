import 'package:flutter/material.dart';

class Project2 extends StatelessWidget {
  const Project2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Add Listing",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Where is the location?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Enter location here",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text("Map Preview"),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Select on the map",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}