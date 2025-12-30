import '../models/doctor_model.dart';
import '../models/doctor_info_model.dart';
import '../models/review_model.dart';
import '../../../auth/data/models/user_model.dart';

// بيانات مؤقتة للطبيب والمستخدم
class MockDoctorData {
  // معلومات المستخدم المؤقت
  static const String userId = '5a4b4fc1-4c58-4d2c-baac-ef050fce8ce3';
  static const String userName = 'Omar Khalid';
  static const String userEmail = 'omar.khalid@example.com';
  static const String userPhone = '+44 7700 900123';

  // معلومات الطبيب المؤقت
  static const String doctorId = 'c463d1f4-0f02-4d95-a3a3-8fef93b42c45';

  // نموذج الطبيب
  static const DoctorModel doctor = DoctorModel(
    id: doctorId,
    name: 'Dr. Randy Wigham',
    specialty: 'General Practitioner',
    rating: 4.8,
    reviews: 4279,
    price: '\$25.00/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
  );

  // معلومات إضافية للطبيب
  static final DoctorInfoModel doctorInfo = DoctorInfoModel(
    aboutText:
        'General practice since 2010, experienced in family medicine and preventive care. Dr. Randy Wigham is dedicated to providing comprehensive healthcare services.',
    workingTime: 'Monday - Friday, 08:00 AM - 20:00 PM',
    strNumber: '4726482464',
    practicePlace: 'RSUD Gatot Subroto',
    practiceYears: '2010 - Present',
    location: 'Jakarta, Indonesia',
    latitude: -6.2088,
    longitude: 106.8456,
    reviews: [
      ReviewModel(
        user: const UserModel(
          id: 'user1',
          name: 'Jane Cooper',
          email: 'jane.cooper@example.com',
          imageUrl: 'https://i.pravatar.cc/100?u=jane',
        ),
        rating: 5.0,
        comment:
            'Dr. Randy Wigham is an excellent general practitioner. Very thorough and takes time to explain everything clearly.',
        date: DateTime(2024, 12, 28),
      ),
      ReviewModel(
        user: const UserModel(
          id: 'user2',
          name: 'Robert Fox',
          email: 'robert.fox@example.com',
          imageUrl: 'https://i.pravatar.cc/100?u=robert',
        ),
        rating: 5.0,
        comment:
            'Great experience! Dr. Wigham is very professional and caring. Highly recommend for family medicine.',
        date: DateTime(2024, 12, 27),
      ),
      ReviewModel(
        user: const UserModel(
          id: 'user3',
          name: 'Sarah Johnson',
          email: 'sarah.johnson@example.com',
          imageUrl: 'https://i.pravatar.cc/100?u=sarah',
        ),
        rating: 4.5,
        comment:
            'Very knowledgeable doctor with excellent preventive care advice. The clinic is well-organized.',
        date: DateTime(2024, 12, 26),
      ),
    ],
  );


static   List<DoctorInfoModel> topDoctors = [
  DoctorInfoModel(
      aboutText:
          'Dr. ${doctor.name} is a highly experienced ${doctor.specialty} with over 10 years of practice. Dedicated to providing exceptional patient care and staying updated with the latest medical advancements.',
      workingTime: 'Mon - Fri, 09:00 AM - 05:00 PM',
      strNumber: 'STR-${doctor.id.hashCode.abs() % 100000}',
      practicePlace: 'Medical Center, Downtown',
      practiceYears: '10+ years',
      location: 'Downtown Medical Center, Main Street',
      latitude: 37.7749,
      longitude: -122.4194,
      reviews: [
        ReviewModel(
          user: const UserModel(
            id: '1',
            name: 'أحمد محمد',
            email: 'ahmed@example.com',
            imageUrl: 'https://i.pravatar.cc/100?u=ahmed',
          ),
          rating: 5.0,
          comment: 'طبيب ممتاز ومتعاون جداً',
          date: DateTime(2024, 12, 15),
        ),
        ReviewModel(
          user: const UserModel(
            id: '2',
            name: 'فاطمة علي',
            email: 'fatima@example.com',
            imageUrl: 'https://i.pravatar.cc/100?u=fatima',
          ),
          rating: 4.5,
          comment: 'تجربة جيدة والعيادة نظيفة',
          date: DateTime(2024, 12, 10),
        ),
        ReviewModel(
          user: const UserModel(
            id: '3',
            name: 'محمود حسن',
            email: 'mahmoud@example.com',
            imageUrl: 'https://i.pravatar.cc/100?u=mahmoud',
          ),
          rating: 5.0,
          comment: 'أفضل طبيب في التخصص',
          date: DateTime(2024, 12, 5),
        ),
      ],
    ),
];



}
