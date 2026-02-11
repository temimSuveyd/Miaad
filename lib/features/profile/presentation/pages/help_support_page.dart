import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uni_size/uni_size.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/snackbar_service.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'المساعدة والدعم',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontSize: 18.dp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textPrimary,
            size: 20.dp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppTheme.spacing20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Column(
                children: [
                  Icon(
                    Iconsax.support,
                    size: 48.dp,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(height: AppTheme.spacing12),
                  Text(
                    'كيف يمكننا مساعدتك؟',
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontSize: 18.dp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing8),
                  Text(
                    'نحن هنا لمساعدتك في أي وقت',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppTheme.spacing24),

            // Contact Options
            Text(
              'طرق التواصل',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                fontSize: 16.dp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppTheme.spacing16),

            // Phone Support
            _buildContactOption(
              icon: Iconsax.call,
              title: 'الدعم الهاتفي',
              subtitle: 'اتصل بنا على الرقم',
              value: '+966 50 123 4567',
              onTap: () => _makePhoneCall('+966501234567'),
            ),

            SizedBox(height: AppTheme.spacing12),

            // Email Support
            _buildContactOption(
              icon: Iconsax.sms,
              title: 'البريد الإلكتروني',
              subtitle: 'أرسل لنا بريداً إلكترونياً',
              value: 'support@doctorbooking.com',
              onTap: () => _sendEmail('support@doctorbooking.com'),
            ),

            SizedBox(height: AppTheme.spacing12),

            // WhatsApp Support
            _buildContactOption(
              icon: Iconsax.message,
              title: 'WhatsApp',
              subtitle: 'تواصل معنا عبر WhatsApp',
              value: '+966 50 123 4567',
              onTap: () => _openWhatsApp('+966501234567'),
            ),

            SizedBox(height: AppTheme.spacing24),

            // Frequently Asked Questions
            Text(
              'الأسئلة الشائعة',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                fontSize: 16.dp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppTheme.spacing16),

            _buildFAQItem(
              question: 'كيف يمكنني حجز موعد مع طبيب؟',
              answer: 'يمكنك حجز موعد من خلال البحث عن الطبيب المناسب واختيار الوقت المتاح لك.',
            ),

            _buildFAQItem(
              question: 'كيف يمكنني إلغاء موعدي؟',
              answer: 'يمكنك إلغاء الموعد من صفحة مواعيدي قبل 24 ساعة من الموعد المحدد.',
            ),

            _buildFAQItem(
              question: 'هل يمكنني تغيير معلوماتي الشخصية؟',
              answer: 'نعم، يمكنك تحديث معلوماتك الشخصية من صفحة الإعدادات.',
            ),

            _buildFAQItem(
              question: 'كيف يمكنني الدفع؟',
              answer: 'يمكنك الدفع عبر البطاقة الائتمانية أو الدفع عند الزيارة حسب سياسة العيادة.',
            ),

            SizedBox(height: AppTheme.spacing24),

            // Additional Help
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Column(
                children: [
                  Icon(
                    Iconsax.info_circle,
                    size: 32.dp,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(height: AppTheme.spacing12),
                  Text(
                    'هل تحتاج مساعدة إضافية؟',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      fontSize: 16.dp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing8),
                  Text(
                    'فريق الدعم متاح من الساعة 9 صباحاً حتى 10 مساءً طوال أيام الأسبوع',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Row(
          children: [
            Container(
              width: 48.dp,
              height: 48.dp,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                icon,
                size: 24.dp,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      fontSize: 14.dp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.dp),
                  Text(
                    subtitle,
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12.dp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.dp),
                  Text(
                    value,
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.dp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.dp,
              color: AppTheme.textSecondary.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(
        top: AppTheme.spacing8,
        bottom: AppTheme.spacing16,
      ),
      title: Text(
        question,
        style: AppTheme.textTheme.titleMedium?.copyWith(
          fontSize: 14.dp,
          fontWeight: FontWeight.w500,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(right: AppTheme.spacing16),
          child: Text(
            answer,
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              fontSize: 13.dp,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      SnackbarService.showError(
        context: context,
        title: 'خطأ',
        message: 'لا يمكن فتح تطبيق الهاتف',
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=استفسار من تطبيق حجز الأطباء',
    );
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      SnackbarService.showError(
        context: context,
        title: 'خطأ',
        message: 'لا يمكن فتح تطبيق البريد',
      );
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri launchUri = Uri.parse('https://wa.me/$phoneNumber');
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      SnackbarService.showError(
        context: context,
        title: 'خطأ',
        message: 'لا يمكن فتح WhatsApp',
      );
    }
  }
}
