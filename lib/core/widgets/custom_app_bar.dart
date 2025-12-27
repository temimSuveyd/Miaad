import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
AppBar CustomAppBar({required String title}) {
  return AppBar(
    backgroundColor: AppTheme.backgroundColor,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.navigate_before,
        color: AppTheme.textPrimary,
        size: 30,
      ),
      onPressed: () => Get.back(),
    ),
    title: Text(
      title,
      style: Theme.of(Get.context!).textTheme.headlineMedium,
    ),
    centerTitle: true,
  );
}
