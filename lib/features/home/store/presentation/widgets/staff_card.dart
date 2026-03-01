import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vegetable_ordering_system/features/store_staff/domain/entities/staff.dart';
import 'package:vegetable_ordering_system/features/store_staff/presentation/provider/staff_provider.dart';
import '../pages/add_staff_page.dart';

class StaffCard extends StatelessWidget {
  final Staff staff;

  const StaffCard({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final bool active = staff.isActive;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            staff.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _infoRow('Phone', staff.phone),
          _infoRow('Email', staff.email),
          _infoRow('Position', staff.position),
          _infoRow(
            'Joined',
            '${staff.dateOfJoining.day}/${staff.dateOfJoining.month}/${staff.dateOfJoining.year}',
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 32,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddStaffPage(staff: staff),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 32,
                padding: const EdgeInsets.only(left: 10, right: 2),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: active
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      active ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: active ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Transform.scale(
                      scale: 0.65,
                      child: Switch(
                        value: active,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (val) async {
                          final provider = Provider.of<StaffProvider>(
                            context,
                            listen: false,
                          );
                          await provider.toggleStaffStatus(staff.id, val);
                        },
                        activeColor: Colors.green,
                        activeTrackColor: Colors.green.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
