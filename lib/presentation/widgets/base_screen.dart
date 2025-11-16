
import 'package:flutter/material.dart';
import 'loading_widget.dart';
import 'error_retry_widget.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget? body;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  const BaseScreen({
    Key? key,
    required this.title,
    this.body,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
        actions: actions,
      ),
      body: _buildBody(),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const LoadingWidget();
    }

    if (errorMessage != null) {
      return ErrorRetryWidget(
        message: errorMessage!,
        onRetry: onRetry ?? () {},
      );
    }

    return body ?? const SizedBox.shrink();
  }
}
