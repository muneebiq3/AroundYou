import 'package:flutter/material.dart';
import 'package:around_you/theme/colors.dart';
import 'package:around_you/theme/images.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  Widget _headerStatic(String title, String sub) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colors.subtitle
            ),
          ),
          const SizedBox(height: 5),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colors.title
            ),
          )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        iconTheme: const IconThemeData(color: colors.primary),
        title: const Text("Job Details"),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              Icons.cloud_upload,
              size: 28,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                Images.google, 
                height: 150
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Google Company",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.title
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "App Developer",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colors.subtitle
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                _headerStatic("Salary", "\$85,000"),
                _headerStatic("Employees", "45,000"),
                _headerStatic("Location", "New York, USA")
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    Images.doc,
                    height: 25,
                    color: colors.icon,
                  )
                ),
                Expanded(
                  child: Image.asset(
                    Images.museum,
                    height: 25,
                    color: colors.icon,
                  )
                ),
                Expanded(
                  child: Image.asset(
                    Images.clock,
                    height: 25,
                    color: colors.icon,
                  )
                ),
                Expanded(
                  child: Image.asset(
                    Images.map,
                    height: 25,
                    color: colors.icon,
                  )
                ),
              ],
            ),
            const Divider(
              color: colors.icon,
              height: 40,
            ),
            const SizedBox(height: 10),
            const Text(
              "Job Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.title
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
              style: TextStyle(
                fontSize: 15,
                color: colors.subtitle
              ),
            ),
            TextButton(
              onPressed: () {}, 
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero)
              ),
              child: const Text(
                "Read More", 
                style: TextStyle(
                  color: colors.primary, 
                  fontSize: 15
                )
              )
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: const Center(
                    child: Text(
                      "Apply Now",
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.background,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  width: 50,
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: colors.primary
                    )
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bookmark_border,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}