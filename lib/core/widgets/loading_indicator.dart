import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}

// class LoadingIndicator extends StatelessWidget {
//   const LoadingIndicator({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(color: Colors.black.withOpacity(0.4)),
//
//         // markazda kartochka
//         Center(
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: const CircularProgressIndicator(),
//           ),
//         ),
//       ],
//     );
//   }
// }
