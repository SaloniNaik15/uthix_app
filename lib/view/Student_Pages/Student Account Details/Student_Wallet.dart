import 'package:flutter/material.dart';

class StudentWallet extends StatefulWidget {
  const StudentWallet({super.key});

  @override
  State<StudentWallet> createState() => _StudentWalletState();
}

class _StudentWalletState extends State<StudentWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xFF605F5F),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Section (Title + Balance in a Row)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Wallet Title & Description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wallet",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Urbanist",
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Credit id added to your wallet\nwith every order",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Urbanist",
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // Wallet Balance Container
                Container(
                  width: 100,
                  height: 100,
                  //padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFF2B5C74),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:Color(0xFF4C7D2B),
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet, size: 25, color: Colors.green),
                      SizedBox(height: 5),
                      Text(
                        "₹299",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Wallet",
                        style: TextStyle(fontSize: 10,fontFamily: "Urbanist", color: Colors.white),
                      ),
                      Text(
                        "Balance",
                        style: TextStyle(fontSize: 10,fontFamily: "Urbanist", color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Cashback & Wallet Usage Sections
            _buildWalletFeature(
              number: "1",
              title: "Receive cashback with every order",
              description: "50% cashback will be credited to your wallet with every order",
            ),
            SizedBox(height: 20),
            _buildWalletFeature(
              number: "2",
              title: "Save more by using wallet cash",
              description: "Buy items and get various discounts by using wallet cash",
            ),
          ],
        ),
      ),
    );
  }

  // Wallet Feature Widget
  Widget _buildWalletFeature({required String number, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontFamily: "Urbanist",fontWeight: FontWeight.bold,),
              ),
              SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(fontSize: 14,fontFamily: "Urbanist"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
