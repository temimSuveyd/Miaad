// import 'package:doctorbooking/features/profile/presentation/cubit/settings_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:uni_size/uni_size.dart';
// import '../../../../core/theme/app_theme.dart';
// import '../../../../core/services/snackbar_service.dart';

// class NotificationManager extends StatefulWidget {
//   const NotificationManager({super.key});

//   @override
//   State<NotificationManager> createState() => _NotificationManagerState();
// }

// class _NotificationManagerState extends State<NotificationManager> 
//     with SingleTickerProviderStateMixin {
//   late AnimationController _badgeAnimationController;
//   late Animation<double> _badgeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _badgeAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _badgeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _badgeAnimationController, curve: Curves.elasticOut),
//     );
    
//     // Listen to notification stream
//     context.read<SettingsCubit>().notificationStream.listen((notificationData) {
//       _handleNotificationUpdate(notificationData);
//     });
//   }

//   @override
//   void dispose() {
//     _badgeAnimationController.dispose();
//     super.dispose();
//   }

//   void _handleNotificationUpdate(Map<String, dynamic> notificationData) {
//     switch (notificationData['type']) {
//       case 'new_notification':
//         _showNotificationToast(notificationData['data'] as Map<String, dynamic>);
//         break;
//       case 'notification_read':
//         // Update badge count if needed
//         break;
//       case 'settings_updated':
//         // Handle settings updates
//         break;
//       case 'history_cleared':
//         SnackbarService.showSuccess(
//           context: context,
//           title: 'نجاح',
//           message: 'تم مسح سجل الإشعارات',
//         );
//         break;
//     }
//   }

//   void _showNotificationToast(Map<String, dynamic> notificationData) {
//     final title = notificationData['title'] as String? ?? '';
//     final body = notificationData['body'] as String? ?? '';
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               _getNotificationIcon(notificationData['channel'] as String?),
//               color: Colors.white,
//               size: 16.dp,
//             ),
//             SizedBox(width: AppTheme.spacing8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     title,
//                     style: AppTheme.textTheme.titleMedium?.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   if (body.isNotEmpty) ...[
//                     SizedBox(height: 2.dp),
//                     Text(
//                       body,
//                       style: AppTheme.textTheme.bodySmall?.copyWith(
//                         color: Colors.white70,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: _getNotificationColor(notificationData['channel'] as String?),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 4),
//         action: SnackBarAction(
//           label: 'عرض',
//           textColor: Colors.white,
//           onPressed: () {
//             // Navigate to notification history or handle notification action
//             Navigator.pushNamed(context, '/notification_history');
//           },
//         ),
//       ),
//     );
//   }

//   Color _getNotificationColor(String? channel) {
//     switch (channel) {
//       case 'appointments':
//         return AppTheme.categoryTeal;
//       case 'messages':
//         return AppTheme.categoryPurple;
//       case 'promotions':
//         return AppTheme.categoryOrange;
//       case 'health_tips':
//         return AppTheme.categoryGreen;
//       default:
//         return AppTheme.primaryColor;
//     }
//   }

//   IconData _getNotificationIcon(String? channel) {
//     switch (channel) {
//       case 'appointments':
//         return Iconsax.calendar5;
//       case 'messages':
//         return Iconsax.sms;
//       case 'promotions':
//         return Iconsax.tag;
//       case 'health_tips':
//         return Iconsax.heart;
//       default:
//         return Iconsax.notification;
//     }
//   }

//   String _formatTimestamp(String timestamp) {
//     if (timestamp.isEmpty) return '';

//     try {
//       final dateTime = DateTime.parse(timestamp);
//       final now = DateTime.now();
//       final difference = now.difference(dateTime);

//       if (difference.inDays > 0) {
//         return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
//       } else if (difference.inHours > 0) {
//         return 'اليوم الساعة ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
//       } else if (difference.inMinutes > 0) {
//         return 'منذ ${difference.inMinutes} دقائق';
//       } else {
//         return 'الآن';
//       }
//     } catch (e) {
//       return timestamp;
//     }
//   }

//   // Method to send appointment notification from anywhere in the app
//   static Future<void> sendAppointmentNotification({
//     required BuildContext context,
//     required String doctorName,
//     required String appointmentTime,
//     required String appointmentDate,
//   }) async {
//     try {
//       final settingsCubit = context.read<SettingsCubit>();
//       await settingsCubit.sendAppointmentNotification(
//         doctorName: doctorName,
//         appointmentTime: appointmentTime,
//         appointmentDate: appointmentDate,
//       );
      
//       SnackbarService.showSuccess(
//         context: context,
//         title: 'نجاح',
//         message: 'تم إرسال تذكير بالموعيد',
//       );
//     } catch (e) {
//       SnackbarService.showError(
//         context: context,
//         title: 'خطأ',
//         message: 'فشل في إرسال الإشعار: ${e.toString()}',
//       );
//     }
//   }

//   // Method to send message notification from anywhere in the app
//   static Future<void> sendMessageNotification({
//     required BuildContext context,
//     required String senderName,
//     required String message,
//     String? senderAvatar,
//   }) async {
//     try {
//       final settingsCubit = context.read<SettingsCubit>();
//       await settingsCubit.sendMessageNotification(
//         senderName: senderName,
//         message: message,
//         senderAvatar: senderAvatar,
//       );
      
//       SnackbarService.showSuccess(
//         context: context,
//         title: 'نجاح',
//         message: 'تم إرسال الرسالة',
//       );
//     } catch (e) {
//       SnackbarService.showError(
//         context: context,
//         title: 'خطأ',
//         message: 'فشل في إرسال الرسالة: ${e.toString()}',
//       );
//     }
//   }

//   // Method to send promotional notification from anywhere in the app
//   static Future<void> sendPromotionalNotification({
//     required BuildContext context,
//     required String title,
//     required String description,
//     required String discountCode,
//   }) async {
//     try {
//       final settingsCubit = context.read<SettingsCubit>();
//       await settingsCubit.sendAppointmentNotification(
//         doctorName: 'النظام',
//         appointmentTime: 'الآن',
//         appointmentDate: DateTime.now().toString().split(' ')[0],
//       );
      
//       SnackbarService.showSuccess(
//         context: context,
//         title: 'نجاح',
//         message: 'تم إرسال العرض الترويجي',
//       );
//     } catch (e) {
//       SnackbarService.showError(
//         context: context,
//         title: 'خطأ',
//         message: 'فشل في إرسال العرض: ${e.toString()}',
//       );
//     }
//   }

//   // Method to get unread notification count
//   static Future<int> getUnreadNotificationCount(BuildContext context) async {
//     try {
//       final settingsCubit = context.read<SettingsCubit>();
//       final notifications = await settingsCubit.getNotificationHistory();
      
//       int unreadCount = 0;
//       for (var notification in notifications) {
//         final isRead = notification['read'] as bool? ?? false;
//         if (!isRead) {
//           unreadCount++;
//         }
//       }
      
//       return unreadCount;
//     } catch (e) {
//       return 0;
//     }
//   }

//   // Method to mark all notifications as read
//   static Future<void> markAllNotificationsAsRead(BuildContext context) async {
//     try {
//       final settingsCubit = context.read<SettingsCubit>();
//       final notifications = await settingsCubit.getNotificationHistory();
      
//       for (var notification in notifications) {
//         final isRead = notification['read'] as bool? ?? false;
//         if (!isRead) {
//           await settingsCubit.markNotificationAsRead(notification['id'] as String);
//         }
//       }
      
//       SnackbarService.showSuccess(
//         context: context,
//         title: 'نجاح',
//         message: 'تم تعليم جميع الإشعارات كمقروءة',
//       );
//     } catch (e) {
//       SnackbarService.showError(
//         context: context,
//         title: 'خطأ',
//         message: 'فشل في تعيين الإشعارات: ${e.toString()}',
//       );
//     }
//   }

//   // Method to clear all notifications
//   static Future<void> clearAllNotifications(BuildContext context) async {
//     try {
//       final settingsCubit = context.read<SettingsCubit>();
//       await settingsCubit.clearNotificationHistory();
      
//       SnackbarService.showSuccess(
//         context: context,
//         title: 'نجاح',
//         message: 'تم مسح جميع الإشعارات',
//       );
//     } catch (e) {
//       SnackbarService.showError(
//         context: context,
//         title: 'خطأ',
//         message: 'فشل في مسح الإشعارات: ${e.toString()}',
//       );
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Map<String, dynamic>>(
//       stream: context.read<SettingsCubit>().notificationStream,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox.shrink();
//         }

//         final notifications = snapshot.data ?? [];
//         final unreadCount = notifications.where((n) => 
//             !(n['read'] as bool? ?? false)).length;

//         return Column(
//           children: [
//             // Header with unread count
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(AppTheme.spacing16),
//               decoration: BoxDecoration(
//                 color: AppTheme.primaryColor,
//                 borderRadius: BorderRadius.vertical(
//                   bottom: Radius.circular(AppTheme.radiusLarge),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: AppTheme.spacing8),
//                       Text(
//                         'الإشعارات',
//                         style: AppTheme.textTheme.titleLarge?.copyWith(
//                           color: Colors.white,
//                           fontSize: 20.dp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       if (unreadCount > 0) ...[
//                         SizedBox(height: AppTheme.spacing4),
//                         Text(
//                           '$unreadCount إشعار غير مقروءة',
//                           style: AppTheme.textTheme.bodyMedium?.copyWith(
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
                  
//                   // Clear all button
//                   if (unreadCount > 0)
//                     TextButton(
//                       onPressed: () {
//                         NotificationManager.markAllNotificationsAsRead(context);
//                       },
//                       child: Text(
//                         'تعيين الكل كمقروء',
//                         style: AppTheme.textTheme.bodyMedium?.copyWith(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                 ],
//               ],
//             ),
//           ),

//             // Notification list
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   final notification = notifications[index];
//                   final isRead = notification['read'] as bool? ?? false;
//                   final timestamp = notification['timestamp'] as String? ?? '';
//                   final title = notification['title'] as String? ?? '';
//                   final body = notification['body'] as String? ?? '';
//                   final channel = notification['channel'] as String? ?? '';

//                   return Container(
//                     margin: EdgeInsets.only(bottom: AppTheme.spacing8),
//                     decoration: BoxDecoration(
//                       color: AppTheme.cardBackground,
//                       borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.05),
//                           blurRadius: 2.dp,
//                           offset: Offset(0, 1.dp),
//                         ),
//                       ],
//                     ),
//                     child: Material(
//                       color: Colors.transparent,
//                       child: InkWell(
//                         onTap: () {
//                           if (!isRead) {
//                             NotificationManager.markNotificationAsRead(
//                               context,
//                               notification['id'] as String,
//                             );
//                           }
//                         },
//                         borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
//                         child: Padding(
//                           padding: EdgeInsets.all(AppTheme.spacing12),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Notification Icon
//                               Container(
//                                 width: 32.dp,
//                                 height: 32.dp,
//                                 decoration: BoxDecoration(
//                                   color: _getNotificationColor(channel),
//                                   borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
//                                 ),
//                                 child: Icon(
//                                   _getNotificationIcon(channel),
//                                   color: Colors.white,
//                                   size: 16.dp,
//                                 ),
//                               ),

//                               SizedBox(width: AppTheme.spacing12),

//                               // Notification Content
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       title,
//                                       style: AppTheme.textTheme.titleMedium?.copyWith(
//                                         fontWeight: isRead 
//                                             ? FontWeight.normal 
//                                             : FontWeight.w600,
//                                         color: isRead 
//                                             ? AppTheme.textSecondary 
//                                             : AppTheme.textPrimary,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4.dp),
//                                     Text(
//                                       body,
//                                       style: AppTheme.textTheme.bodyMedium?.copyWith(
//                                         color: AppTheme.textSecondary,
//                                       ),
//                                       maxLines: 3,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: AppTheme.spacing8),
//                                     Text(
//                                       _formatTimestamp(timestamp),
//                                       style: AppTheme.textTheme.bodySmall?.copyWith(
//                                         color: AppTheme.textSecondary,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               // Delete Button
//                               if (!isRead)
//                                 IconButton(
//                                   icon: Icon(
//                                     Iconsax.trash,
//                                     color: AppTheme.errorColor,
//                                     size: 16.dp,
//                                   ),
//                                   onPressed: () {
//                                     _showDeleteNotificationDialog(context, notification);
//                                   },
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteNotificationDialog(BuildContext context, Map<String, dynamic> notification) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'حذف الإشعار',
//           style: AppTheme.textTheme.titleLarge?.copyWith(
//             fontSize: 16.dp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         content: Text(
//           'هل تريد حذف هذا الإشعار؟',
//           style: AppTheme.textTheme.bodyMedium,
//           textAlign: TextAlign.center,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'إلغاء',
//               style: AppTheme.textTheme.titleMedium?.copyWith(
//                 color: AppTheme.textSecondary,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // TODO: Implement delete notification logic
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     'سيتم حذف الإشعار',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   backgroundColor: AppTheme.errorColor,
//                   duration: const Duration(seconds: 2),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppTheme.errorColor,
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(
//                 horizontal: AppTheme.spacing24,
//                 vertical: AppTheme.spacing12,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
//               ),
//             ),
//             child: Text(
//               'حذف',
//               style: AppTheme.textTheme.titleMedium?.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Notification Badge Widget
// class NotificationBadge extends StatelessWidget {
//   final int count;
//   final Widget child;

//   const NotificationBadge({
//     super.key,
//     required this.count,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         child,
//         if (count > 0)
//           Positioned(
//             right: 0,
//             top: 0,
//             child: Container(
//               width: 18.dp,
//               height: 18.dp,
//               decoration: BoxDecoration(
//                 color: AppTheme.errorColor,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 2.dp),
//               ),
//               child: Center(
//                 child: Text(
//                   count > 99 ? '99+' : count.toString(),
//                   style: AppTheme.textTheme.bodySmall?.copyWith(
//                     color: Colors.white,
//                     fontSize: 10.dp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
