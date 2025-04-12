import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/MyOrders.dart';
import 'Create_Store_Data/CreateStore.dart';
import 'Inventory_data/Inventory.dart';
import 'Manage_store_Data/ManageStores.dart';
import 'Upload_Data/Upload.dart';
import 'User_setting/YourAccount.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  List<Map<String, String?>> categories = [];
  List<Map<String, String>> subcategories = [];
  bool isLoading = true;
  String? selectedCategory;
  String? selectedSubcategory;
  String? selectedCategoryName;
  String? email;
  String? password;
  String? accessToken;

  @override
  @override
  void initState() {
    super.initState();
    _initializeData(); // Call the async function
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchParentCategories();
  }

  Future<void> _saveSelectedCategory(
      String categoryId, String selectedCategory) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedCategoryId", categoryId);
    await prefs.setString("selectedCategoryName", selectedCategory);
    log("Saved selected category ID: $categoryId");
    log("Saved selected category NAme: $selectedCategory");
  }

  Future<void> _saveSelectedSubcategory(
      String subcategoryId, String subcategoryName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedSubcategoryId", subcategoryId);
    await prefs.setString("selectedSubcategoryName", subcategoryName);
    log("Saved selected subcategory ID: $subcategoryId");
    log("Saved selected subcategory Name: $subcategoryName");
  }

  Future<void> _loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString("email");
    String? savedPassword = prefs.getString("password");
    String? savedaccessToken = prefs.getString("auth_token");

    log("Retrieved Email: $savedEmail");
    log("Retrieved Password: $savedPassword");
    log("Retrieved acesstoken: $savedaccessToken");

    setState(() {
      email = savedEmail ?? "No Email Found";
      password = savedPassword ?? "No Password Found";
      accessToken = savedaccessToken ?? "No accesstoken";
    });
  }

  final Dio dio = Dio();

  /// Fetch Parent Categories (Where `parent_category_id` is null)
  Future<void> fetchParentCategories() async {
    try {
      final response = await dio.get(
        'https://admin.uthix.com/api/all-categories',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
        ),
      );

      log("API Response: ${response.data}");

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData.containsKey('categories') &&
            jsonData['categories'] is List) {
          setState(() {
            categories = List<Map<String, String>>.from(
              jsonData['categories']
                  .where((item) => item['parent_category_id'] == null)
                  .map((item) => {
                        "id": item['id'].toString(),
                        "cat_title": item['cat_title'].toString(),
                        "parent_category_id": "",
                      }),
            );
            isLoading = false;
          });

          log("Fetched Parent Categories: $categories");
        } else {
          log("Categories key not found.");
          setState(() => isLoading = false);
        }
      } else {
        log("API request failed: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      log("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchSubcategories(int parentId) async {
    try {
      final response = await dio.get(
        'https://admin.uthix.com/api/all-categories',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (jsonData.containsKey('categories') &&
            jsonData['categories'] is List) {
          setState(() {
            subcategories = List<Map<String, String>>.from(
              jsonData['categories']
                  .where((item) => item['parent_category_id'] == parentId)
                  .map((item) => {
                        "id": item['id'].toString(),
                        "cat_title": item['cat_title'].toString(),
                        "parent_category_id":
                            item['parent_category_id'].toString(),
                      }),
            );
          });

          log("Fetched Subcategories for Parent ID $parentId: $subcategories");

          if (mounted) {
            showSubcategoryMenu(
                context, parentId.toString(), 'Parent Category Name');
          }
        } else {
          log("Subcategories key not found.");
        }
      } else {
        log("API request failed: ${response.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<void> checkStoreAndNavigate(BuildContext context) async {
    try {
      final response = await dio.get(
        'https://admin.uthix.com/api/vendor-store-status',
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/json",
          },
        ),
      );

      log("Store Check Response: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data["status"] == true) {
          // Store already exists
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Store already created."),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          // Store doesn't exist, navigate to CreateStore
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateStore()),
            );
          }
        }
      } else {
        debugPrint("Store check failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error checking store: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Seller Dashboard",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.bold,
              color: Color(0xFF605F5F),
            ),
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey, thickness: 1),
          buildTopBar(),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/instructor/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: GridView.count(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.99,
                children: [
                  buildGridItem(
                    context,
                    'Upload',
                    'assets/Seller_dashboard_images/upload.png',
                    null,
                  ),
                  buildGridItem(
                    context,
                    'Inventory',
                    'assets/Seller_dashboard_images/inventory.png',
                    InventoryData(),
                  ),
                  buildGridItem(
                    context,
                    'Create Store',
                    'assets/Seller_dashboard_images/create_store.png',
                    null,
                  ),
                  buildGridItem(
                    context,
                    'Manage Stores',
                    'assets/Seller_dashboard_images/manage_stores.png',
                    ManageStoreData(),
                  ),
                  buildGridItem(
                    context,
                    'My Profile',
                    'assets/Seller_dashboard_images/my_profile.png',
                    YourAccount(),
                  ),
                  buildGridItem(
                    context,
                    'Orders',
                    'assets/Seller_dashboard_images/orders.png',
                    MyOrders(),
                  ),
                ],
              ),
            ),
          ),
          // Wrap the My Profile grid item in a Center widget
          // Wrap the My Profile grid item in a Center widget
        ],
      ),
    );
  }

  Widget buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const YourAccount()));
                },
                child: Image.asset('assets/icons/Ellipse.png', height: 40),
              ),
              const SizedBox(width: 5),
              const Text(
                "Revantaha Stationers",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF605F5F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGridItem(BuildContext context, String title, String imagePath,
      Widget? nextScreen) {
    return GestureDetector(
      onTap: () {
        if (title == 'Upload') {
          showUploadMenu(context);
        } else if (title == 'Create Store') {
          checkStoreAndNavigate(context);
        } else if (nextScreen != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => nextScreen));
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFFD2D2D2), width: 2),
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 135, fit: BoxFit.cover),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF605F5F),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void showUploadMenu(BuildContext context) {
    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No categories available")),
      );
      return;
    }

    selectedCategory = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Select a Category"),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: categories.map((category) {
                      final categoryName = category['cat_title'];
                      final categoryId = category['id'].toString();

                      return ListTile(
                        title: Text(categoryName ?? "Unknown"),
                        trailing: Radio<String>(
                          value: categoryId,
                          groupValue: selectedCategory,
                          onChanged: (value) async {
                            setDialogState(() {
                              selectedCategory = value;
                              selectedCategoryName = categoryName ?? "Unknown";
                            });

                            Navigator.pop(context);
                            _saveSelectedCategory(categoryId, categoryName!);

                            await fetchSubcategories(int.parse(categoryId));

                            if (subcategories.isNotEmpty) {
                              showSubcategoryMenu(
                                  context, categoryId, categoryName);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadData(),
                                ),
                              );
                            }
                          },
                          activeColor: const Color.fromRGBO(43, 96, 116, 1),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showSubcategoryMenu(
      BuildContext context, String parentId, String parentName) async {
    if (subcategories.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No subcategories available for $parentName")),
        );
      }
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (BuildContext dialogContext, StateSetter setDialogState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text("Select a Subcategory for $parentName"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: subcategories.map((subcategory) {
                    final subcategoryName =
                        subcategory['cat_title'] ?? "Unknown";
                    final subcategoryId = subcategory['id'].toString();

                    return ListTile(
                      title: Text(subcategoryName),
                      trailing: Radio<String>(
                        value: subcategoryId,
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setDialogState(() {
                            selectedCategory = value;
                            selectedCategoryName = subcategoryName;
                          });

                          // After selection, navigate to UploadData screen
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext); // Close the dialog
                          }

                          _saveSelectedSubcategory(
                              subcategoryId, subcategoryName);

                          // Ensure the page is still mounted before navigation
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadData(),
                              ),
                            );
                          }
                        },
                        activeColor: const Color.fromRGBO(43, 96, 116, 1),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      );
    });
  }
}
