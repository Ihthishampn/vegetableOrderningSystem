import 'package:flutter/material.dart';
import 'package:vegetable_ordering_system/features/sales_report/domain/entities/sales_report.dart';
import 'sales_report_card.dart';

class SalesReportList extends StatelessWidget {
  final List<SalesReport> reports;

  const SalesReportList({super.key, required this.reports});

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
        return SalesReportCard(report: report, index: index + 1);
      },
    );
  }
}
