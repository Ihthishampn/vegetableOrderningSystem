import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/sales_report/presentation/provider/sales_report_provider.dart';
import 'package:vegetable_ordering_system/features/sales_report/domain/entities/sales_report.dart';

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
      final auth = Provider.of<AuthViewModel>(context, listen: false);
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
      appBar: AppBar(centerTitle: true, title: const Text('Sales Reports')),
      body: Consumer<SalesReportProvider>(
        builder: (context, salesReportProvider, _) {
          if (salesReportProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (salesReportProvider.error != null) {
            return Center(child: Text('Error: ${salesReportProvider.error}'));
          }

          // Use all shops from shops collection, not just shops with sales data
          final shops = salesReportProvider.getAllShopNames();

          return Column(
            children: [
              // 1. Filter Section (Dropdown and Calendar)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _SalesFilterDropdown(
                        value: salesReportProvider.selectedShop,
                        shops: shops,
                        onChanged: (val) =>
                            salesReportProvider.setSelectedShop(val!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateFilterButton(
                        selectedDate: selectedDate,
                        onTap: _showCalendar,
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
                    Consumer<OrderProvider>(
                      builder: (context, orderProvider, _) {
                        return _SummarCard(
                          title: "Total Orders",
                          count: "${orderProvider.allOrders.length}",
                          color: const Color(0xFFCDEBFF),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _SummarCard(
                      title: "Completed Orders",
                      count: "${salesReportProvider.allReports.length}",
                      color: const Color(0xFFCFFFE2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Scrollable Report List
              Expanded(
                child: _SalesReportList(
                  reports: salesReportProvider.filteredReports,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Filter dropdown for selecting shop
class _SalesFilterDropdown extends StatelessWidget {
  final String value;
  final List<String> shops;
  final ValueChanged<String?> onChanged;

  const _SalesFilterDropdown({
    required this.value,
    required this.shops,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.filter_list, size: 18, color: Colors.black54),
              const SizedBox(width: 8),
              const Text(
                "Filter by Shop",
                style: TextStyle(fontSize: 12, color: Colors.black87),
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
          items: shops.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Filter button for selecting date
class _DateFilterButton extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const _DateFilterButton({required this.selectedDate, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = selectedDate == null
        ? "Filter by Date"
        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

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
                  Icon(Icons.calendar_today, size: 18, color: Colors.black54),
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
}

/// Summary card widget
class _SummarCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _SummarCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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

/// List of sales reports
class _SalesReportList extends StatelessWidget {
  final List<SalesReport> reports;

  const _SalesReportList({required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Center(
        child: Text(
          'No sales reports found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: reports.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = reports[index];
        return _SalesReportCard(report: report, index: index + 1);
      },
    );
  }
}

/// Individual sales report card
class _SalesReportCard extends StatelessWidget {
  final SalesReport report;
  final int index;

  const _SalesReportCard({required this.report, required this.index});

  @override
  Widget build(BuildContext context) {
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
            // Format quantity without decimals if it's a whole number
            final quantityDisplay = item.quantity % 1 == 0
                ? "${item.quantity.toInt()} ${item.unit}"
                : "${item.quantity.toStringAsFixed(2)} ${item.unit}";

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
                    quantityDisplay,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
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
}
