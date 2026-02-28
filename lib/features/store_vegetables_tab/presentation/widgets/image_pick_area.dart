import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerBox extends StatefulWidget {
  final Function(String?)? onImageSelected;

  const ImagePickerBox({super.key, this.onImageSelected, String? initialImageUrl});

  @override
  State<ImagePickerBox> createState() => _ImagePickerBoxState();
}

class _ImagePickerBoxState extends State<ImagePickerBox> {
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();
  final _imageUrlController = TextEditingController();

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() => _selectedImagePath = image.path);
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(image.path);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image selected successfully')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  void _showImageUrlDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Image URL'),
        content: TextField(
          controller: _imageUrlController,
          decoration: const InputDecoration(
            hintText: 'Enter image URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final url = _imageUrlController.text.trim();
              if (url.isNotEmpty) {
                setState(() => _selectedImagePath = url);
                if (widget.onImageSelected != null) {
                  widget.onImageSelected!(url);
                }
                _imageUrlController.clear();
                Navigator.pop(ctx);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image URL added')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: const Color.fromARGB(255, 80, 79, 79),
              dashPattern: [10, 5],
              strokeWidth: 2,
              radius: const Radius.circular(12),
              padding: EdgeInsets.zero,
            ),
            child: InkWell(
              onTap: _pickImageFromGallery,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                height: 150,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedImagePath != null
                            ? Icons.check_circle
                            : Icons.file_upload_outlined,
                        size: 28,
                        color: _selectedImagePath != null ? Colors.green : null,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _selectedImagePath != null
                            ? "Image selected"
                            : "Click to upload image",
                        style: TextStyle(
                          color: _selectedImagePath != null
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _showImageUrlDialog,
            icon: const Icon(Icons.link),
            label: const Text('Or paste image URL'),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
