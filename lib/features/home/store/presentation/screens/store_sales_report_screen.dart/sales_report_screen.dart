import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vegetable_ordering_system/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:vegetable_ordering_system/features/sales_report/presentation/provider/sales_report_provider.dart';
import 'package:vegetable_ordering_system/features/home/store/presentation/widgets/sales_report_body.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth > 600 ? 22.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sales Reports', style: TextStyle(fontSize: titleFontSize)),
      ),
      body: SalesReportBody(
        selectedDate: selectedDate,
        onDateTap: _showCalendar,
      ),
    );
  }
}
