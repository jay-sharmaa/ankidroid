import 'package:ankidroid/utils/AppBar.dart';
import 'package:ankidroid/utils/CustomDrawer.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<bool> completedDays = [true, false, true, true, false, true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageName: "Profile"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Last 7 Day Streak",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                bool done = completedDays[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      completedDays[index] = !completedDays[index];
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? Colors.green : Colors.grey[300],
                      border: Border.all(color: Colors.black26),
                    ),
                    child: done
                        ? const Icon(Icons.circle, size: 18, color: Colors.yellow)
                        : null,
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),
            Text(
              "${completedDays.where((e) => e).length}/7 Days Done ✅",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}