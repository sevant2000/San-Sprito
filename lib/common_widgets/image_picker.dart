import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';
import 'package:san_sprito/common_widgets/common_button.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(List<String>) onFileNamesChanged;
  final Function(List<File>) onFilesChanged;
  final Future<void> Function(List<File>) uploadFunction;
  final bool? btnLoading;

  const ImagePickerWidget({
    super.key,
    required this.onFileNamesChanged,
    required this.onFilesChanged,
    required this.uploadFunction,
    this.btnLoading,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  void _updateFiles() {
    final files = _selectedImages.map((xfile) => File(xfile.path)).toList();
    widget.onFileNamesChanged(_selectedImages.map((img) => img.name).toList());
    widget.onFilesChanged(files);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only select up to 2 images.')),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImages.add(image); // ✅ Must be inside setState
          _updateFiles();
        });
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or upload at least one image.')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      await widget.uploadFunction(
        _selectedImages.map((xfile) => File(xfile.path)).toList(),
      );

      setState(() {
        _selectedImages.clear(); // ✅ Clear images after successful upload
        _updateFiles(); // Notify parent about the updated (now empty) list
        _isUploading = false;
      });
    } catch (e) {
      debugPrint("Upload error: $e");
      setState(() => _isUploading = false);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    _updateFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isUploading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: CommonColor.logoBGColor),
            ),
          )
        else if (_selectedImages.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(_selectedImages.length, (index) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_selectedImages[index].path),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CommonColor.logoBGColor,
              ),
              child: IconButton(
                onPressed:
                    _isUploading ? null : () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CommonColor.logoBGColor,
              ),
              child: IconButton(
                onPressed:
                    _isUploading ? null : () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            CommonButton(
              onPressed: _uploadImages,
              text: "Submit",
              icon: Icons.send,
              isLoading: widget.btnLoading ?? false,
            ),
          ],
        ),
      ],
    );
  }
}
