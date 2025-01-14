import 'package:flutter/material.dart';
import 'package:around_you/screens/job_details_screen.dart';
import 'package:around_you/screens/profile_screen.dart';
import 'package:around_you/theme/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String? errorMessage = '';
  String? userName = "User";
  String? userDesignation = "Unemployed";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void fetchUserDetails() async {
    try {
      
      User? user = _auth.currentUser; // Get logged-in user
      if (user == null) {
        return;
      }

      QuerySnapshot usersCollection = await FirebaseFirestore.instance.collection('Users').get();

      for (var doc in usersCollection.docs) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(doc.id)
          .get();
            
        // Check for the matching user uid in the sub-collection
        if (userDoc.exists && userDoc['id'] == user.uid) {
          setState(() {
            userName = userDoc['Name']; // Update the userName variable
            userDesignation = userDoc['Designation'];
          });
          break; // Exit the loop once the user is found
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user name: $e');
    }
  }

  Widget _recommendedJobs(
    BuildContext context, {
      required String img,
      required String company,
      required String title,
      required String sub,  
      bool isActive = false
    }
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF266DD1) : const Color(0xFFEEEEF1).withOpacity(0.8),
            borderRadius: BorderRadius.circular(7)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Image.asset(img),
              ),
              const SizedBox(height: 16),
              Text (
                company,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.white38 : const Color(0xFF898C8D)
                ),
              ),
              const SizedBox(height: 6),
              Text (
                title,
                style: TextStyle(
                  fontSize: 17,
                  color: isActive ? Colors.white : const Color(0xFF343740),
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 6),
              Text (
                sub,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.white38 : const Color(0xFF898C8D),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobCard(
    BuildContext context, {
      required String img,
      required String title,
      required String subtitle,
      required String salary,  
    }
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const JobDetailsScreen()
            )
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEF1).withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEF1),
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Image.asset(img),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF898C8D),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF343740),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                salary,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF343740),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF266DD1), // Darker shade
                Color(0xFF90B3E9), // Primary theme color
                Color(0xFFB3CFF1), // Lighter shade
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(Images.user),
                        ),
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen()
                            )
                          );
                        },
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$userName",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "$userDesignation",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFB3CFF1)
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find your perfect job",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEF1).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "What are you looking for?",
                              border: InputBorder.none
                            ),
                          ),
                        )
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF266DD1),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recommended",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _recommendedJobs(
                                context, 
                                img: Images.google, 
                                company: "Google",
                                title: "App Developer",
                                sub: "\$45,500 Onsite",
                                isActive: true
                              ),
                              _recommendedJobs(
                                context, 
                                img: Images.dropbox, 
                                company: "Dropbox",
                                title: "Web Developer",
                                sub: "\$65,500 Remote",
                                isActive: false
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Recent Jobs",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF343740),
                          fontSize: 18
                        ),
                      ),
                      _jobCard(
                        context, 
                        img: Images.gitlab, 
                        title: "Gitlab", 
                        subtitle: "UX Developer", 
                        salary: "\$75,800"
                      ),
                      _jobCard(
                        context, 
                        img: Images.bitbucket, 
                        title: "Bitbucket", 
                        subtitle: "App Developer", 
                        salary: "\$45,800"
                      ),
                      _jobCard(
                        context, 
                        img: Images.slack, 
                        title: "Slack", 
                        subtitle: "Web Developer", 
                        salary: "\$85,800"
                      ),
                      _jobCard(
                        context, 
                        img: Images.dropbox, 
                        title: "Dropbox", 
                        subtitle: "AI Engineer", 
                        salary: "\$95,800"
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}