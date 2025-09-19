// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // For SystemUiOverlayStyle
// import 'package:get/get.dart';
// import 'package:pos/Services/Controllers/favourites_screen.dart';
// import 'package:pos/widgets/action_card.dart';

// class FavoriteScreen extends StatelessWidget {
//   const FavoriteScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final FavoritesController favoritesController = Get.find<FavoritesController>();
//     final screenWidth = MediaQuery.of(context).size.width;
//     // ignore: unused_local_variable
//     final screenHeight = MediaQuery.of(context).size.height;
//     final isTablet = screenWidth > 600;
//     final isLargeScreen = screenWidth > 900;

//     final allQuickActions = [
//       {
//         'title': 'New Sale',
//         'icon': Icons.add_shopping_cart,
//         'color': Colors.indigo[600]!,
//       },
//       {
//         'title': 'Inventory',
//         'icon': Icons.inventory,
//         'color': Colors.teal[400]!,
//       },
//       {
//         'title': 'Reports',
//         'icon': Icons.bar_chart,
//         'color': Colors.purple[400]!,
//       },
//       {
//         'title': 'Settings',
//         'icon': Icons.settings,
//         'color': Colors.deepOrange[400]!,
//       },
//       {
//         'title': 'Customers',
//         'icon': Icons.group,
//         'color': Colors.blue[400]!,
//       },
//       {
//         'title': 'Analytics',
//         'icon': Icons.analytics,
//         'color': Colors.green[400]!,
//       },
//     ];

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: const SystemUiOverlayStyle(
//         statusBarColor: Colors.deepOrangeAccent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Favorites',
//             style: TextStyle(
//               fontSize: (isLargeScreen ? 24.0 : screenWidth * 0.05).clamp(16.0, 26.0),
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               color: Colors.deepOrangeAccent,
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: EdgeInsets.only(right: (screenWidth * 0.04).clamp(8.0, 16.0)),
//               child: CircleAvatar(
//                 radius: (isLargeScreen ? 20.0 : screenWidth * 0.04).clamp(14.0, 22.0),
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   Icons.person,
//                   size: (isLargeScreen ? 24.0 : screenWidth * 0.045).clamp(16.0, 26.0),
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Container(
//           color: Colors.grey[100],
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final cardSize = (screenWidth *
//                       (isLargeScreen ? 0.22 : isTablet ? 0.28 : 0.3))
//                   .clamp(100.0, 200.0);
//               final spacing = (screenWidth * 0.02).clamp(8.0, 16.0);
//               return SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: (constraints.maxWidth * 0.05).toDouble(),
//                   vertical: (constraints.maxHeight * 0.02).toDouble(),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Favorite Actions',
//                       style: Theme.of(context).textTheme.headlineMedium ??
//                           const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 12),
//                     Obx(() {
//                       final favoriteActions = allQuickActions
//                           .where((action) => favoritesController
//                               .favoriteItems
//                               .contains(action['title'] as String))
//                           .toList();
//                       if (favoriteActions.isEmpty) {
//                         return const Center(
//                           child: Text(
//                             'No favorite actions yet',
//                             style: TextStyle(fontSize: 16, color: Colors.grey),
//                           ),
//                         );
//                       }
//                       return GridView.count(
//                         crossAxisCount: isLargeScreen ? 4 : isTablet ? 3 : 3,
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         mainAxisSpacing: spacing,
//                         crossAxisSpacing: spacing,
//                         children: favoriteActions.map((action) {
//                           return QuickActionCard(
//                             title: action['title'] as String,
//                             icon: action['icon'] as IconData,
//                             color: action['color'] as Color,
//                             cardSize: cardSize,
//                             isFavorite: true, // All cards here are favorites
//                             onFavoriteToggle: () {
//                               favoritesController.toggleFavorite(action['title'] as String);
//                             },
//                           );
//                         }).toList(),
//                       );
//                     }),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }