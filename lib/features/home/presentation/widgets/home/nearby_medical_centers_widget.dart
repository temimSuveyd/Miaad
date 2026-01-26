// import 'package:doctorbooking/features/home/data/mock/mock_doctor_data.dart';
// import 'package:doctorbooking/features/home/data/models/doctor_model.dart';
// import 'package:doctorbooking/features/home/presentation/cubit/home_cubit/home_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../../../../core/theme/app_theme.dart';

// class MedicalCenter {
//   final String name;
//   final String imageUrl;

//   MedicalCenter(this.name, this.imageUrl);
// }

// class NearbyMedicalCentersWidget extends StatelessWidget {
//   const NearbyMedicalCentersWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SliverList.builder(
//       // scrollDirection: Axis.horizontal,
//       itemCount: MockDoctorData.topDoctors.length,
//       itemBuilder: (context, index) {
//         final doctor = MockDoctorData.topDoctors[index];
//         final doctorInfo = MockDoctorData.doctorInfo;
//         final cubit = context.read<HomeCubit>();
//         return MedicalCenterCard(
//           doctorModel: doctor,
//           onTap: () => cubit.goToDoctorDetailsPage(
//             doctorInfoModel: doctorInfo,
//             doctorModel: doctor,
//           ),
//         );
//       },
//     );
//   }
// }

// class MedicalCenterCard extends StatelessWidget {
//   final DoctorModel doctorModel;
//   final Function() onTap;

//   const MedicalCenterCard({
//     super.key,
//     required this.doctorModel,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(AppTheme.spacing16),
//         margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
//         decoration: BoxDecoration(
//           color: AppTheme.cardBackground,

//           borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
//               child: Container(
//                 width: 110,
//                 height: 110,
//                 decoration: BoxDecoration(
//                   color: AppTheme.textSecondary.withValues(alpha: 0.1),
//                   image: DecorationImage(
//                     image: NetworkImage(doctorModel.imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: AppTheme.spacing16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     doctorModel.name,
//                     style: AppTheme.bodyLarge.copyWith(
//                       fontWeight: FontWeight.w600,
//                       color: AppTheme.textPrimary,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: AppTheme.spacing4),
//                   Text(
//                     doctorModel.specialty,
//                     style: AppTheme.bodyMedium.copyWith(
//                       color: AppTheme.textSecondary,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: AppTheme.spacing4),
//                   Row(
//                     children: [
//                       const Icon(
//                         Iconsax.location5,
//                         size: 14,
//                         color: AppTheme.textSecondary,
//                       ),
//                       const SizedBox(width: AppTheme.spacing4),
//                       Expanded(
//                         child: Text(
//                           'Golden Cardiology Center',
//                           style: AppTheme.caption.copyWith(
//                             color: AppTheme.textSecondary,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: AppTheme.spacing4),
//                   Row(
//                     children: [
//                       const Icon(Iconsax.star1, size: 14, color: Colors.amber),
//                       const SizedBox(width: AppTheme.spacing4),
//                       Text(
//                         '${doctorModel.rating}',
//                         style: AppTheme.caption.copyWith(
//                           color: AppTheme.textPrimary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(width: AppTheme.spacing4),
//                       Text(
//                         '(${doctorModel.reviews} Reviews)',
//                         style: AppTheme.caption.copyWith(
//                           color: AppTheme.textSecondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
