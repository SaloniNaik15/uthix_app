import 'package:flutter/material.dart';

class ReturnDetailsPage extends StatefulWidget {
  const ReturnDetailsPage({super.key});

  @override
  State<ReturnDetailsPage> createState() => _ReturnDetailsPageState();
}

class _ReturnDetailsPageState extends State<ReturnDetailsPage> {
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: const Text(
            "Return Details",
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Order Information", style: _titleStyle),
                  SizedBox(height: 10),
                  _InfoRow(label: "Order ID:", value: "74678698759669160"),
                  _InfoRow(label: "Purchase Date:", value: "Mar 25, 2025"),
                  _InfoRow(label: "Return Date:", value: "Mar 25, 2025"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Reason", style: _titleStyle),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Type reason here...",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/Seller_dashboard_images/book.jpg',
                          width: 80,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Book Name", style: _titleStyle),
                        SizedBox(height: 6),
                        Text("Quantity: 1",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text("₹1500",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Condition", style: _titleStyle),
                  const SizedBox(height: 10),
                  TextField(
                    controller: conditionController,
                    maxLines: 2,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Type condition here...",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Customer Information", style: _titleStyle),
                  SizedBox(height: 8),
                  Text("Michael Anderson"),
                  Text("+91 6789898776"),
                  Text("xyz street Mumbai India"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004B5F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Approve Return",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}

const _titleStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 16,
);

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
