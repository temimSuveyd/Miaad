import '../models/doctor_model.dart';

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
  static final DoctorModel doctor = const DoctorModel(
    id: 1,
    name: 'Dr. Randy Wigham',
    specialty: 'General Practitioner',
    rating: 4.8,
    reviews: 4279,
    price: '\$25.00/hr',
    imageUrl:
        'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
  );

  // معلومات إضافية للطبيب
  static final Map<String, dynamic> doctorInfo = {
    'name': doctor.name,
    'specialty': doctor.specialty,
    'hospital': 'RSUD Gatot Subroto',
    'rating': doctor.rating,
    'reviewCount': doctor.reviews,
    'price': doctor.price,
    'imageUrl': doctor.imageUrl,
    'experienceYears': 14, // منذ 2010
    'patientsCount': 2456,
    'reviewsCount': 4.8,
    'aboutText':
        'General practice since 2010, experienced in family medicine and preventive care. Dr. Randy Wigham is dedicated to providing comprehensive healthcare services to patients of all ages.',
    'workingTime': 'Monday - Friday, 08:00 AM - 20:00 PM',
    'strNumber': '4726482464',
    'practicePlace': 'RSUD Gatot Subroto',
    'practiceYears': '2010 - Present',
    'location': 'Jakarta, Indonesia',
    'latitude': -6.2088, // Jakarta coordinates
    'longitude': 106.8456,
  };

  static final List<Map<String, dynamic>> reviews = [
    {
      'userName': 'Jane Cooper',
      'userImage': 'https://i.pravatar.cc/100?u=jane',
      'rating': 5.0,
      'reviewText':
          'Dr. Randy Wigham is an excellent general practitioner. Very thorough and takes time to explain everything clearly.',
      'date': 'Today',
    },
    {
      'userName': 'Robert Fox',
      'userImage': 'https://i.pravatar.cc/100?u=robert',
      'rating': 5.0,
      'reviewText':
          'Great experience! Dr. Wigham is very professional and caring. Highly recommend for family medicine.',
      'date': 'Yesterday',
    },
    {
      'userName': 'Sarah Johnson',
      'userImage': 'https://i.pravatar.cc/100?u=sarah',
      'rating': 4.5,
      'reviewText':
          'Very knowledgeable doctor with excellent preventive care advice. The clinic is well-organized.',
      'date': '2 days ago',
    },
  ];
}
