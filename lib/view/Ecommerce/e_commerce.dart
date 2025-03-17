import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:uthix_app/UpcomingPage.dart';
import 'package:uthix_app/modal/nav_itemStudent.dart';
import 'package:uthix_app/modal/navbarWidgetStudent.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/Buy_TextBooks.dart';
import 'package:uthix_app/view/Student_Pages/Buy_Books/StudentSearch.dart';
import 'package:uthix_app/view/Student_Pages/Files/files.dart';
import 'package:uthix_app/view/Student_Pages/HomePages/HomePage.dart';
import 'package:uthix_app/view/Student_Pages/Student%20Account%20Details/Student_AccountPage.dart';
import 'package:uthix_app/view/Student_Pages/Student_Chat/stud_chat.dart';

class ECommerce extends StatefulWidget {
  const ECommerce({Key? key}) : super(key: key);

  @override
  State<ECommerce> createState() => _ECommerceState();
}

class _ECommerceState extends State<ECommerce> {
  int selectedIndex = 2;
  final String imageBaseUrl = 'https://admin.uthix.com/storage/image/category/';
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index != 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => navStudItems[index]["page"]),
      ).then((_) {
        setState(() {
          selectedIndex = 2;
        });
      });
    }
  }

  Future<void> fetchCategories() async {
    try {
      final dio = Dio();
      // Fetch parent categories from the API endpoint.
      final response =
          await dio.get('https://admin.uthix.com/api/parent-categories');
      if (response.statusCode == 200 && response.data['status'] == true) {
        final jsonData = response.data;
        if (jsonData.containsKey('data') && jsonData['data'] is List) {
          setState(() {
            categories = (jsonData['data'] as List).map((item) {
              return {
                'id': item['id'],
                'cat_title': item['cat_title'] ?? '',
                'cat_image': item['cat_image'] != null
                    ? '$imageBaseUrl${item['cat_image']}'
                    : '',
                'cat_slug': item['cat_slug'] ?? '',
              };
            }).toList();
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background image with opacity overlay.
            Positioned.fill(
              child: Opacity(
                opacity: 0.30,
                child: Image.asset("assets/registration/splash.png",
                    fit: BoxFit.cover),
              ),
            ),
            // Top header with user greeting.
            Container(
              height: 100,
              width: double.infinity,
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(43, 92, 116, 1)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 30),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            offset: const Offset(0, 0),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_2_outlined,
                          size: 25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "Hello User!!",
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Main content area.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Center(
                    child: Image.asset(
                      "assets/ecommerce/main.png",
                      width: 340,
                      height: 256,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Categories",
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(10),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 2.0,
                                mainAxisSpacing: 1.0,
                                childAspectRatio: 1.35,
                              ),
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                return buildGridItem(
                                    context, categories[index]);
                              },
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Bottom navigation bar.
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Center(
                child: NavbarStudent(
                  onItemTapped: onItemTapped,
                  selectedIndex: selectedIndex,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        int categoryId = category['id'];
        // If the selected category is "TextBook" (id == 1), navigate to BuyTextBooks.
        // Otherwise, navigate to StudentSearch passing the category id.
        if (categoryId == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuyTextBooks(categoryId: categoryId),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentSearch(categoryId: categoryId),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                category['cat_image'],
                width: 150,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150,
                  height: 130,
                  color: Colors.grey,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.white),
                ),
              ),
            ),
            Container(
              width: 150,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromRGBO(205, 205, 205, 0.16),
                    const Color.fromRGBO(0, 0, 0, 0.71).withOpacity(0.4),
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    category['cat_title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
