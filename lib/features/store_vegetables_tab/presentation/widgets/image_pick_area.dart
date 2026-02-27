import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ImagePickerBox extends StatelessWidget {
  const ImagePickerBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: const Color.fromARGB(255, 80, 79, 79),
          dashPattern: [10, 5],
          strokeWidth: 2,
          radius: const Radius.circular(12),
          padding: EdgeInsets.zero,
        ),
        child: InkWell(
          onTap: () {
            // open image picker
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.file_upload_outlined, size: 28),
                  SizedBox(height: 5),
                  Text(
                    "Click to upload image",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}