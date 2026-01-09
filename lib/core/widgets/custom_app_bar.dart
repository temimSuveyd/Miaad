import 'package:doctorbooking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uni_size/uni_size.dart';

// ignore: non_constant_identifier_names
AppBar CustomAppBar({required String title, bool? showleading}) {
  return AppBar(
    backgroundColor: AppTheme.backgroundColor,
    elevation: 0,
    leading: showleading == true
        ? IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: AppTheme.textPrimary,
              size: 30.dp,
            ),
            onPressed: () => Get.back(),
          )
        : SizedBox(),

    title: Text(title, style: Theme.of(Get.context!).textTheme.titleLarge),
    centerTitle: true,
  );
}
