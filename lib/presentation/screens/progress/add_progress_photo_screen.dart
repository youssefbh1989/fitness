
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/utils/size_config.dart';
import '../../widgets/custom_app_bar.dart';

class AddProgressPhotoScreen extends StatefulWidget {
  const AddProgressPhotoScreen({Key? key}) : super(key: key);

  @override
  State<AddProgressPhotoScreen> createState() => _AddProgressPhotoScreenState();
}

class _AddProgressPhotoScreenState extends State<AddProgressPhotoScreen> {
  File? _frontPhoto;
  File? _sidePhoto;
  File? _backPhoto;
  final _notesController = TextEditingController();
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          switch (type) {
            case 'front':
              _frontPhoto = File(image.path);
              break;
            case 'side':
              _sidePhoto = File(image.path);
              break;
            case 'back':
              _backPhoto = File(image.path);
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _savePhotos() async {
    if (_frontPhoto == null && _sidePhoto == null && _backPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please take at least one photo')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Implement actual save logic with repository
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress photos saved successfully')),
      );
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _weightController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Progress Photos',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Take Photos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            Row(
              children: [
                Expanded(child: _buildPhotoBox('Front', 'front', _frontPhoto)),
                const SizedBox(width: 12),
                Expanded(child: _buildPhotoBox('Side', 'side', _sidePhoto)),
                const SizedBox(width: 12),
                Expanded(child: _buildPhotoBox('Back', 'back', _backPhoto)),
              ],
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.03),
            Text(
              'Measurements (Optional)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            TextField(
              controller: _bodyFatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Body Fat (%)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.03),
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Add any notes about your progress...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.03),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _savePhotos,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Progress'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoBox(String label, String type, File? photo) {
    return GestureDetector(
      onTap: () => _pickImage(type),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          image: photo != null
              ? DecorationImage(
                  image: FileImage(photo),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: photo == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 32,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 16),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
