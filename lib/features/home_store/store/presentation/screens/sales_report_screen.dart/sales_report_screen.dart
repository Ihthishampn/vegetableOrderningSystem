import 'package:flutter/material.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  String selectedShop = "All";
  DateTime? selectedDate;

  // Mock data for the report list
  final List<Map<String, dynamic>> reports = [
    {
      "shop": "Green Valley Store",
      "date": "24/11/2025, 04:30am",
      "items": [
        "1 Ridge gourd 20 Kg",
        "2 Carrot 15 Kg",
        "3 Cauliflower 10 Kg",
        "4 Tomato 20 Box",
        "5 Green chili 15 Kg",
      ],
    },
    {
      "shop": "Fresh Harvest Market",
      "date": "24/11/2025, 04:30am",
      "items": [
        "1 Ridge gourd 20 Kg",
        "2 Carrot 15 Kg",
        "3 Cauliflower 10 Kg",
        "4 Tomato 20 Box",
        "5 Green chili 15 Kg",
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Sales Report",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Filter Section (Dropdown and Calendar)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Shop Dropdown Filter
                Expanded(
                  child: _buildDropdownFilter(
                    value: selectedShop,
                    hint: "Filter by Shop",
                    icon: Icons.filter_list,
                    items: [
                      "All",
                      "Veg Graam",
                      "Green Haven",
                      "Veggie Delight",
                      "Harvest Basket",
                    ],
                    onChanged: (val) => setState(() => selectedShop = val!),
                  ),
                ),
                const SizedBox(width: 12),
                // Date Picker Filter
                Expanded(
                  child: _buildFilterButton(
                    selectedDate == null
                        ? "Filter by Date"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    Icons.calendar_today,
                    _showCalendar,
                  ),
                ),
              ],
            ),
          ),

          // 2. Summary Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildSummaryCard(
                  "Total Orders",
                  "300",
                  const Color(0xFFCDEBFF),
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  "Complete Orders",
                  "200",
                  const Color(0xFFCFFFE2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Scrollable Report List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reports.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _buildReportCard(reports[index], index + 1),
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Dropdown style filter
  Widget _buildDropdownFilter({
    required String value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48, // Fixed height to match the Date button
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value == "All" ? null : value,
          hint: Row(
            children: [
              Icon(icon, size: 18, color: Colors.black54),
              const SizedBox(width: 8),
              Text(
                hint,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.black54,
          ),
          isExpanded: true,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Helper: Generic Filter Button (used for Date)
  Widget _buildFilterButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48, // Fixed height to match the Dropdown
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Icon(icon, size: 18, color: Colors.black54),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Summary Card Widget
  Widget _buildSummaryCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            Text(
              count,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Detailed Report Card with Error-Safe Parsing
  Widget _buildReportCard(Map<String, dynamic> data, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$index. ${data['shop']}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),
          ...data['items'].map<Widget>((item) {
            List<String> parts = item.split(' ');
            String quantity = "";
            String name = item;

            // Logic to separate Name and Quantity (last two words) safely
            if (parts.length >= 2) {
              quantity =
                  "${parts[parts.length - 2]} ${parts[parts.length - 1]}";
              name = parts.sublist(0, parts.length - 2).join(' ');
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    quantity,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const Divider(height: 24, thickness: 0.5),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              data['date'] ?? "",
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // Standard Flutter Calendar Logic
  Future<void> _showCalendar() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2D2926), // Match your dark theme color
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => selectedDate = picked);
  }
}
