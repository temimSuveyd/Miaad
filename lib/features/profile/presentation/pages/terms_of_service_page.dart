import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'شروط الاستخدام',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionWidget(
              title: '1. مقدمة',
              content:
                  'مرحباً بك في تطبيق حجز المواعيد الطبية. باستخدام هذا التطبيق، فإنك توافق على الالتزام بشروط الاستخدام هذه. يرجى قراءة هذه الشروط بعناية قبل استخدام التطبيق.',
            ),
            SizedBox(height: 24),
            _SectionWidget(
              title: '2. استخدام التطبيق',
              content:
                  'يمكنك استخدام هذا التطبيق لحجز المواعيد الطبية مع الأطباء المتاحين. يجب عليك تقديم معلومات صحيحة ودقيقة عند التسجيل وحجز المواعيد.',
            ),
            SizedBox(height: 24),
            _SectionWidget(
              title: '3. حجز المواعيد',
              content:
                  'عند حجز موعد، فإنك تلتزم بالحضور في الوقت المحدد. في حالة عدم القدرة على الحضور، يرجى إلغاء الموعد قبل 24 ساعة على الأقل من الموعد المحدد.',
            ),
            SizedBox(height: 24),
            _SectionWidget(
              title: '4. خصوصية البيانات',
              content:
                  'نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية والطبية. لن نشارك معلوماتك مع أطراف ثالثة دون موافقتك الصريحة، باستثناء ما هو مطلوب قانونياً.',
            ),
            SizedBox(height: 24),
            _SectionWidget(
              title: '5. المسؤوليات',
              content:
                  'التطبيق يوفر منصة لحجز المواعيد فقط. نحن غير مسؤولين عن جودة الخدمات الطبية المقدمة من قبل الأطباء. أي مشاكل طبية يجب مناقشتها مباشرة مع الطبيب المختص.',
            ),
            SizedBox(height: 24),
            _SectionWidget(
              title: '6. الدفع والرسوم',
              content:
                  'قد تطبق رسوم على بعض الخدمات المتاحة في التطبيق. سيتم إعلامك بأي رسوم قبل إتمام عملية الحجز. جميع المدفوعات نهائية وغير قابلة للاسترداد إلا في حالات استثنائية.',
            ),
            SizedBox(height: 24),
            _SectionWidget(
              title: '7. إلغاء الحساب',
              content:
                  'يمكنك إلغاء حسابك في أي وقت من خلال الاتصال بفريق الدعم. عند إلغاء الحساب، سيتم حذف جميع بياناتك الشخصية وفقاً لسياسة الخصوصية الخاصة بنا.',
            ),
            SizedBox(height: 24),
            _SectionWidget(
              title: '8. تعديل الشروط',
              content:
                  'نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم إشعارك بأي تغييرات مهمة عبر التطبيق أو البريد الإلكتروني. استمرارك في استخدام التطبيق يعني موافقتك على الشروط المحدثة.',
            ),
            SizedBox(height: 24),
            _SectionWidget(
              title: '9. الاتصال بنا',
              content:
                  'إذا كان لديك أي أسئلة حول شروط الاستخدام هذه، يرجى الاتصال بنا عبر البريد الإلكتروني: support@doctorbooking.com أو من خلال قسم الدعم في التطبيق.',
            ),
            SizedBox(height: 32),
            Text(
              'آخر تحديث: يناير 2026',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final String title;
  final String content;

  const _SectionWidget({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black54,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
