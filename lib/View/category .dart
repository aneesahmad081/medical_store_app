// import 'package:flutter/material.dart';

// class DiabetesCareScreen extends StatelessWidget {
//   const DiabetesCareScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final categories = [
//       {'title': 'Sugar Substitute', 'image': 'assets/sugar.png'},
//       {'title': 'Juices & Vinegars', 'image': 'assets/juice.png'},
//       {'title': 'Vitamins Medicines', 'image': 'assets/vitamins.png'},
//     ];

//     final products = [
//       {
//         'name': 'Accu-check Active Test Strip',
//         'price': 112,
//         'image': 'assets/product.png',
//         'rating': 4.2,
//         'label': 'SALE',
//       },
//       {
//         'name': 'Omron HEM-8712 BP Monitor',
//         'price': 150,
//         'image': 'assets/product2.png',
//         'rating': 4.2,
//         'label': '15% OFF',
//       },
//       {
//         'name': 'Accu-check Active Test Strip',
//         'price': 112,
//         'image': 'assets/product.png',
//         'rating': 4.2,
//         'label': 'SALE',
//       },
//       {
//         'name': 'Omron HEM-8712 BP Monitor',
//         'price': 150,
//         'image': 'assets/product2.png',
//         'rating': 4.2,
//         'label': '15% OFF',
//       },
//     ];

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text(
//           "Diabetes Care",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Categories",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 100,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: categories.length,
//                   separatorBuilder: (_, __) => const SizedBox(width: 12),
//                   itemBuilder: (context, index) {
//                     return Container(
//                       width: 90,
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             blurRadius: 5,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundColor: Colors.blue.shade50,
//                             child: Image.asset(
//                               categories[index]['image']!,
//                               height: 30,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             categories[index]['title']!,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "All Products",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.65,
//                 ),
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   final product = products[index];
//                   return Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               blurRadius: 5,
//                               spreadRadius: 2,
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(12),
//                                 topRight: Radius.circular(12),
//                               ),
//                               child: Image.asset(
//                                 product['image']! as String,
//                                 height: 120,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     product['name']! as String,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "Rs.${product['price']}",
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black87,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 6,
//                                       vertical: 2,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.orange,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         const Icon(
//                                           Icons.star,
//                                           size: 14,
//                                           color: Colors.white,
//                                         ),
//                                         const SizedBox(width: 3),
//                                         Text(
//                                           product['rating'].toString(),
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (product['label'] != null)
//                         Positioned(
//                           top: 8,
//                           left: 8,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 2,
//                             ),
//                             decoration: BoxDecoration(
//                               color: (product['label'] as String) == 'SALE'
//                                   ? Colors.red
//                                   : Colors.green,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(
//                               product['label']! as String,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
