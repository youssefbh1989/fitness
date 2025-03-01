
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../blocs/community/community_bloc.dart';
import '../../blocs/community/community_event.dart';
import '../../blocs/community/community_state.dart';
import '../../widgets/post_item.dart';
import 'create_post_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityBloc>().add(LoadPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search
            },
          ),
        ],
      ),
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CommunityBloc>().add(LoadPostsEvent());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(SizeConfig.defaultPadding),
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return PostItem(
                    post: post,
                    onLike: () {
                      if (post.isLiked) {
                        context.read<CommunityBloc>().add(UnlikePostEvent(postId: post.id));
                      } else {
                        context.read<CommunityBloc>().add(LikePostEvent(postId: post.id));
                      }
                    },
                    onComment: () {
                      // Navigate to comments screen
                    },
                    onProfile: () {
                      // Navigate to user profile
                    },
                  );
                },
              ),
            );
          } else if (state is CommunityError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CommunityBloc>().add(LoadPostsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          ).then((_) {
            // Refresh posts after returning from create post screen
            context.read<CommunityBloc>().add(LoadPostsEvent());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
