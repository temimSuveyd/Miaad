// Kullanım Örneği:
//
// AppointmentConfirmationDialog.show(
//   context: context,
//   doctorName: 'Dr. Ahmed Hassan',
//   specialty: 'Cardiologist',
//   date: '15 يناير 2024',
//   time: '10:00 AM',
//   doctorImageUrl: 'https://example.com/doctor.jpg', // opsiyonel
//   onConfirm: () {
//     // Randevu onaylandığında yapılacak işlemler
//     print('Randevu onaylandı!');
//     // API çağrısı yapabilirsiniz
//     // Navigator ile başka sayfaya yönlendirebilirsiniz
//   },
// );
//
// Veya manuel kullanım:
//
// showDialog(
//   context: context,
//   builder: (context) => AppointmentConfirmationDialog(
//     doctorName: 'Dr. Ahmed Hassan',
//     specialty: 'Cardiologist',
//     date: '15 يناير 2024',
//     time: '10:00 AM',
//     doctorImageUrl: 'https://example.com/doctor.jpg',
//     onConfirm: () {
//       Navigator.of(context).pop();
//       // Onay işlemleri
//     },
//     onCancel: () {
//       Navigator.of(context).pop();
//       // İptal işlemleri
//     },
//   ),
// );
