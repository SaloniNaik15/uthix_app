import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key});

  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  int selectedTab = 0;
  List<String> tabs = ["Trending", "Discount", "Expiring"];
  List<dynamic> coupons = [];

  @override
  void initState() {
    super.initState();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    try {
      var response = await Dio().get('https://admin.uthix.com/api/coupons');
      if (response.statusCode == 200 && response.data['status'] == true) {
        setState(() {
          coupons = response.data['coupons'];
        });
      }
    } catch (e) {
      print("Error fetching coupons: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Stack(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const Positioned(
                  top: 100,
                  left: 20,
                  child: Text(
                    "Coupons",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Urbanist',
                    ),
                  )),
              Positioned(
                top: 40,
                right: -10,
                child: Image.asset(
                  'assets/Student_Home_icons/student_cupon.png',
                  width: 80,
                  height: 80,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 2),
          color: const Color(0xFFEFEFEF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(tabs.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 33, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: selectedTab == index
                                  ? const Color(0xFF2B5C74)
                                  : Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: selectedTab == index
                                ? const Color(0xFF2B5C74)
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    return CouponCard(coupon: coupons[index]);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class CouponCard extends StatelessWidget {
  final Map<String, dynamic> coupon;

  const CouponCard({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: Image.asset(
                  "assets/Student_Home_icons/couponBook.png",
                  width: 100,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 20),
              const DottedDividerWithIcon(
                  height: double.infinity, color: Colors.grey),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${coupon["discount_value"]}% off ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "Code: ${coupon["code"]} ",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Expiry: ${coupon["expiration_date"]}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 30),
                      ),
                      child: const Text(
                        "View Products",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedDividerWithIcon extends StatelessWidget {
  final double height;
  final Color color;
  final IconData icon;

  const DottedDividerWithIcon({
    super.key,
    this.height = 90,
    this.color = Colors.grey,
    this.icon = CupertinoIcons.scissors_alt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 8; i++)
          Container(
            width: 2,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 2),
            color: color,
          ),
        Icon(icon, color: color, size: 20),
        for (int i = 0; i < 8; i++)
          Container(
            width: 2,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 2),
            color: color,
          ),
      ],
    );
  }
}
