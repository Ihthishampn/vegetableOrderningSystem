import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  /// Controller for the search input. The parent widget should provide one
  /// so it can read/clear the current value.
  final TextEditingController controller;

  /// Called whenever the text changes. Provides the current value.
  final ValueChanged<String>? onChanged;

  /// Optional callback when the clear button is tapped.
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // Light grey background
        borderRadius: BorderRadius.circular(12),
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: widget.controller,
        builder: (context, value, _) {
          return TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: value.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        widget.controller.clear();
                        if (widget.onClear != null) widget.onClear!();
                        if (widget.onChanged != null) widget.onChanged!('');
                      },
                      child: const Icon(Icons.clear, color: Colors.grey),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          );
        },
      ),
    );
  }
}
