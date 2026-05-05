import 'package:flutter/material.dart';
void showSuccessSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.55,
      child: Column(
        children: [
          const Spacer(),
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            "Success!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    ),
  );
}

void showErrorSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.55,
      child: Column(
        children: [
          const Spacer(),
          const Icon(Icons.error, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            "Something went wrong!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    ),
  );
}