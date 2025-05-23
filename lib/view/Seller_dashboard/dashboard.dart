import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uthix_app/view/Seller_dashboard/Orders_Data/MyOrders.dart';
import '../../modal/Snackbar.dart';
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
  String? vendorLogo;
  String? storeName;

  @override
  void initState() {
    super.initState();
    _initializeData(); // Call the async function
  }

  Future<void> _initializeData() async {
    await _loadUserCredentials();
    await fetchParentCategories();
  }

  Future<void> _loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      setState(() {
        accessToken = token;
      });
      log("✅ Token Loaded: $accessToken");

      await fetchVendorInfo();
      await fetchParentCategories();
    } else {
      log("❌ Token is null or empty");
      // Optional: Navigate to login screen
    }
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
            SnackbarHelper.showMessage(
              context,
              message: "Store Already Created",
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

  Future<void> fetchVendorInfo() async {
    try {
      final response = await dio.get(
        'https://admin.uthix.com/api/vendor/profile',
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        log("Full Vendor Response: ${response.data}");
        setState(() {
          vendorLogo = data['logo']; // e.g., "1744607932.jpg"
          storeName = data['store_name']; // e.g., "sangeta books"
        });
        log("✅ Vendor Info - Store Name: $storeName | Logo: $vendorLogo");
      } else {
        log("❌ Vendor info fetch failed: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Error fetching vendor info: $e");
    }
  }
  Future<void> checkStoreAndUpload(BuildContext context) async {
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

      if (response.statusCode == 200) {
        final data = response.data;

        if (data["status"] == true) {
          // ✅ Store exists — proceed to upload
          showUploadMenu(context);
        } else {
          // ❌ Store doesn't exist — show snackbar
          if (context.mounted) {
            SnackbarHelper.showMessage(
              context,
              message: "Please create your store first.",
            );

          }
        }
      } else {
        log("❌ Store check failed: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Error during store check: $e");
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Seller Dashboard",
              style: TextStyle(
                fontSize: 20,
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
          ],
        ),
      ),
    );
  }

  Widget buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          vendorLogo != null
              ? CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://admin.uthix.com/storage/images/logos/$vendorLogo',
                  ),
                )
              : const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.store, color: Colors.white),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              storeName ?? "Store Name",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF605F5F),
              ),
              overflow: TextOverflow.ellipsis,
            ),
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
          checkStoreAndUpload(context);
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
    final parentContext = context;

    if (categories.isEmpty) {
      SnackbarHelper.showMessage(
        context,
        message: "No categories available!",
      );

      return;
    }

    // ✅ Reset selections here
    selectedCategory = null;
    selectedCategoryName = null;
    selectedSubcategory = null;

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

                            log("Selected Category: $selectedCategoryName (ID: $selectedCategory)");

                            Navigator.pop(context);

                            await fetchSubcategories(int.parse(categoryId));

                            if (subcategories.isNotEmpty) {
                              showSubcategoryMenu(
                                parentContext,
                                categoryId,
                                categoryName!,
                              );
                            } else {
                              // If no subcategories, navigate directly
                              Navigator.push(
                                parentContext,
                                MaterialPageRoute(
                                  builder: (context) => UploadData(
                                    categoryId: categoryId,
                                    categoryName: categoryName!,
                                    subcategoryId: null,
                                    subcategoryName: null,
                                  ),
                                ),
                              );
                            }
                          },
                          activeColor: const Color(0xFF2B5C74),
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

  void showSubcategoryMenu(BuildContext context, String parentCategoryId,
      String parentCategoryName) {
    selectedSubcategory = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Select a Subcategory"),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: subcategories.map((subcategory) {
                      final subcategoryName = subcategory['cat_title'];
                      final subcategoryId = subcategory['id'].toString();

                      return ListTile(
                        title: Text(subcategoryName ?? "Unknown"),
                        trailing: Radio<String>(
                          value: subcategoryId,
                          groupValue: selectedSubcategory,
                          onChanged: (value) async {
                            setState(() {
                              selectedSubcategory = value;
                            });

                            log("Selected Parent Category: $parentCategoryName (ID: $parentCategoryId)");
                            log("Selected Subcategory: $subcategoryName (ID: $subcategoryId)");

                            Navigator.pop(context);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadData(
                                  categoryId: parentCategoryId,
                                  categoryName: parentCategoryName,
                                  subcategoryId: subcategoryId,
                                  subcategoryName: subcategoryName!,
                                ),
                              ),
                            );
                          },
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
}
