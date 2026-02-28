import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/provider/auth_provider.dart';
import 'package:vegetable_ordering_system/features/sales_report/presentation/provider/sales_report_provider.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    // wait until after first frame to access providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final reportProvider = Provider.of<SalesReportProvider>(
        context,
        listen: false,
      );
      if (auth.uid != null) {
        reportProvider.initialize(auth.uid!);
      }
    });
  }

  Future<void> _showCalendar() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      if (!mounted) return;
      setState(() {
        selectedDate = picked;
      });
      final provider = Provider.of<SalesReportProvider>(context, listen: false);
      provider.fetchSalesReports(startDate: picked, endDate: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Reports')),
      body: Consumer<SalesReportProvider>(
        builder: (context, salesReportProvider, _) {
          if (salesReportProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (salesReportProvider.error != null) {
            return Center(child: Text('Error: ${salesReportProvider.error}'));
          }

          final shops = salesReportProvider.getUniqueShops();

          Widget listSection;
          if (salesReportProvider.filteredReports.isEmpty) {
            listSection = const Center(
              child: Text(
                'No sales reports found',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          } else {
            listSection = ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: salesReportProvider.filteredReports.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final report = salesReportProvider.filteredReports[index];
                return _buildReportCard(report, index + 1);
              },
            );
          }

          return Column(
            children: [
              // 1. Filter Section (Dropdown and Calendar)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildDropdownFilter(
                        value: salesReportProvider.selectedShop,
                        hint: "Filter by Shop",
                        icon: Icons.filter_list,
                        items: shops,
                        onChanged: (val) =>
                            salesReportProvider.setSelectedShop(val!),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                      "Total Reports",
                      "${salesReportProvider.filteredReports.length}",
                      const Color(0xFFCDEBFF),
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      "Total Sales",
                      "₹${salesReportProvider.totalSales.toStringAsFixed(2)}",
                      const Color(0xFFCFFFE2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Scrollable Report List
              Expanded(child: listSection),
            ],
          );
        },
      ),
    );
  }

  // Helper: Detailed Report Card with SalesReport data
  Widget _buildReportCard(dynamic report, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$index. ${report.shopName}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 12),
          ...report.items.map<Widget>((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.productName,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    "${item.quantity.toStringAsFixed(2)} ${item.unit}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "₹${item.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const Divider(height: 24, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ₹${report.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              Text(
                "${report.date.day}/${report.date.month}/${report.date.year}",
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
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
      height: 48,
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
        height: 48,
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
}
