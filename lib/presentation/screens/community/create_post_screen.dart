
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../blocs/community/community_bloc.dart';
import '../../blocs/community/community_event.dart';
import '../../blocs/community/community_state.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  String? _imageUrl;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: _isSubmitting || _contentController.text.trim().isEmpty
                ? null
                : _submitPost,
            child: const Text('Post'),
          ),
        ],
      ),
      body: BlocListener<CommunityBloc, CommunityState>(
        listener: (context, state) {
          if (state is PostCreated) {
            Navigator.pop(context);
          } else if (state is CommunityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            setState(() {
              _isSubmitting = false;
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.defaultPadding),
          child: Column(
            children: [
              // User info
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
                  ),
                  SizedBox(width: SizeConfig.defaultPadding),
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              
              SizedBox(height: SizeConfig.defaultPadding),
              
              // Content input
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'What\'s on your mind?',
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              
              // Image preview
              if (_imageUrl != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () => setState(() {
                          _imageUrl = null;
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              
              // Action buttons
              SizedBox(height: SizeConfig.defaultPadding),
              Row(
                children: [
                  _buildActionButton(
                    icon: Icons.photo,
                    label: 'Photo',
                    onPressed: _pickImage,
                  ),
                  SizedBox(width: SizeConfig.defaultPadding),
                  _buildActionButton(
                    icon: Icons.location_on,
                    label: 'Location',
                    onPressed: () {
                      // Add location
                    },
                  ),
                  SizedBox(width: SizeConfig.defaultPadding),
                  _buildActionButton(
                    icon: Icons.tag,
                    label: 'Tag',
                    onPressed: () {
                      // Tag people
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPost() {
    if (_contentController.text.trim().isEmpty) return;
    
    setState(() {
      _isSubmitting = true;
    });
    
    context.read<CommunityBloc>().add(CreatePostEvent(
      content: _contentController.text.trim(),
      imageUrl: _imageUrl,
    ));
  }

  void _pickImage() {
    // This would normally use image_picker
    // For demo purposes, using a sample image
    setState(() {
      _imageUrl = 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b';
    });
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
