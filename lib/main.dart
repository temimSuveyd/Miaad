import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/config/supabase_config.dart';
import 'core/services/service_locator.dart';
import 'core/routing/presentation/pages/route_config_page.dart';
import 'core/routing/presentation/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  await initServiceLocator();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar', 'SA'),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      initialRoute: AppRoutes.initial,
      getPages: RouteConfigPage.getPages(),
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
