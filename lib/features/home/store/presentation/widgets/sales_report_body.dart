import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/store_orders_tab/presentation/provider/order_provider.dart';
import 'package:vegetable_ordering_system/features/sales_report/presentation/provider/sales_report_provider.dart';
import 'sales_report_list.dart';
import 'sales_filter_dropdown.dart';
import 'date_filter_button.dart';
import 'summary_card.dart';


class SalesReportBody extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onDateTap;

  const SalesReportBody({super.key, required this.selectedDate, required this.onDateTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesReportProvider>(
      builder: (context, salesReportProvider, _) {
        if (salesReportProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (salesReportProvider.error != null) {
          return Center(child: Text('Error: ${salesReportProvider.error}'));
        }

        final shops = salesReportProvider.getAllShopNames();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: SalesFilterDropdown(
                      value: salesReportProvider.selectedShop,
                      shops: shops,
                      onChanged: (val) =>
                          salesReportProvider.setSelectedShop(val!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DateFilterButton(
                      selectedDate: selectedDate,
                      onTap: onDateTap,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Consumer<OrderProvider>(
                    builder: (context, orderProvider, _) {
                      return SummaryCard(
                        title: "Total Orders",
                        count: "${orderProvider.allOrders.length}",
                        color: const Color(0xFFCDEBFF),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  SummaryCard(
                    title: "Completed Orders",
                    count: "${salesReportProvider.allReports.length}",
                    color: const Color(0xFFCFFFE2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: SalesReportList(
                reports: salesReportProvider.filteredReports,
              ),
            ),
          ],
        );
      },
    );
  }
}
