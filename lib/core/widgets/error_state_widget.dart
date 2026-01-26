import 'package:flutter/material.dart';
import 'package:uni_size/uni_size.dart';
import '../theme/app_theme.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryButtonText;

  const ErrorStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.icon,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacing24.dp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Error Icon with Animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 80.dp,
                  height: 80.dp,
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon ?? Icons.error_outline_rounded,
                    size: 40.dp,
                    color: AppTheme.errorColor,
                  ),
                ),
              );
            },
          ),

          SizedBox(height: AppTheme.spacing20.dp),

          // Error Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppTheme.spacing8.dp),

          // Error Message
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          if (onRetry != null) ...[
            SizedBox(height: AppTheme.spacing24.dp),

            // Retry Button
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: Icon(Icons.refresh_rounded, size: 18.dp),
                      label: Text(
                        retryButtonText ?? 'إعادة المحاولة',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing20.dp,
                          vertical: AppTheme.spacing12.dp,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMedium.dp,
                          ),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

// Specific error widgets for different scenarios
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'مشكلة في الاتصال',
      message: 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
    );
  }
}

class ServerErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const ServerErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      title: 'خطأ في الخادم',
      message: 'حدث خطأ في الخادم، يرجى المحاولة مرة أخرى لاحقاً',
      icon: Icons.dns_rounded,
      onRetry: onRetry,
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacing24.dp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty Icon
          Container(
            width: 80.dp,
            height: 80.dp,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? Icons.inbox_rounded,
              size: 40.dp,
              color: AppTheme.textSecondary,
            ),
          ),

          SizedBox(height: AppTheme.spacing20.dp),

          // Empty Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppTheme.spacing8.dp),

          // Empty Message
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          if (onAction != null) ...[
            SizedBox(height: AppTheme.spacing24.dp),

            // Action Button
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing20.dp,
                  vertical: AppTheme.spacing12.dp,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium.dp),
                ),
              ),
              child: Text(actionText ?? 'تحديث'),
            ),
          ],
        ],
      ),
    );
  }
}
