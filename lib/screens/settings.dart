// import 'package:category/utils/constant.dart';
// import 'package:category/widgets/backIconWidget.dart';
// import 'package:category/widgets/bottomBarWidget.dart';
// import 'package:category/widgets/textWidget.dart';
// import 'package:category/widgets/tileWidget.dart';
// import 'package:category/widgets/topBarWidget.dart';
// import 'package:flutter/material.dart';
//
// import 'dashboard1/widgets/buttonWidget.dart';
//
// class Settings extends StatefulWidget {
//   @override
//   _SettingsState createState() => _SettingsState();
// }
//
// class _SettingsState extends State<Settings> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             centerTitle: true,
//             elevation: 0,
//             title: TextWidget(
//               text: 'Main Menu',
//               textSize: 18,
//               isBold: true,
//               textColor: primary,
//             ),
//           ),
//            body: Stack(
//         children: [
//
//              Padding(
//             padding:  EdgeInsets.only(top: size.height*0.03),
//                child: ListView(
//               children: [
//
//                 SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(right:size.width*0.68),
//                           child: Text("Account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
//                         ),
//                         SizedBox(height: 10,),
//                         TileWidget(
//                           function: () =>
//                               Navigator.pushNamed(context, '/account'),
//                           leadingWidget: Row(
//                             children: [
//                               Image.asset(
//                                 'assets/images/user.png',
//                                 scale: 2,
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'Jhon Smith',
//                               ),
//                             ],
//                           ),
//                         ),
//                         TileWidget(
//                           function: () =>
//                               Navigator.pushNamed(context, '/changePassword'),
//                           trailingWidget: TextWidget(
//                             text: "******",
//                             textSize: 14,
//                             isBold: true,
//                             textColor: primary.withOpacity(0.4),
//                           ),
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'Change Password',
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.topLeft,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 6),
//                             child: TextWidget(
//                               text: 'Preferences',
//                               textColor: primary.withOpacity(0.3),
//                               textSize: 18,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 3,),
//                         TileWidget(
//                           function: ()=>
//                               Navigator.pushNamed(context, '/Language'),
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'Language',
//                           ),
//                           trailingWidget: TextWidget(
//                             textSize: 16,
//                             textColor: primary.withOpacity(0.4),
//                             text: 'English',
//                           ),
//                         ),
//                         TileWidget(
//                           function: () =>
//                               Navigator.pushNamed(context, '/country'),
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'Location',
//                           ),
//                           trailingWidget: TextWidget(
//                             textSize: 16,
//                             textColor: primary.withOpacity(0.4),
//                             text: 'New York City',
//                           ),
//                         ),
//                         TileWidget(
//                           function: () =>
//                               Navigator.pushNamed(context, '/Currency'),
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'Currency',
//                           ),
//                           trailingWidget: TextWidget(
//                             textSize: 16,
//                             textColor: primary.withOpacity(0.4),
//                             text: '\$',
//                           ),
//                         ),
//                         TileWidget(
//                           function: () =>
//                               Navigator.pushNamed(context, '/shoppingPreference'),
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'Shopping Preference',
//                           ),
//                         ),
//                         TileWidget(
//                           function: () => Navigator.pushNamed(context, '/brands'),
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'Add your Favourite Brands',
//                           ),
//                         ),
//                         TileWidget(
//                           function: () => Navigator.pushNamed(context, '/Stores'),
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'Add your Favourite Stores',
//                           ),
//                         ),
//
//
//
//                         Align(
//                           alignment: Alignment.topLeft,
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 20,vertical: 6),
//                             child: TextWidget(
//                               text: 'Support',
//                               textColor: primary.withOpacity(0.3),
//                               textSize: 18,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 3,),
//                         TileWidget(
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'FAQ',
//                           ),
//                         ),
//                         TileWidget(
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'Contact Us',
//                           ),
//                         ),
//                         TileWidget(
//                           leadingWidget: TextWidget(
//                             textSize: 16,
//                             isBold: true,
//                             textColor: primary,
//                             text: 'About Us',
//                           ),
//                         ),
//                         SizedBox(
//                           height: size.height*0.01,
//                         ),
//                         ButtonWidget(
//                           buttonHeight: 50,
//                           buttonWidth: MediaQuery.of(context).size.width,
//                           function: () =>
//                               Navigator.pushNamed(context, '/auth'),
//                           roundedBorder: 10,
//                           buttonColor: Color(0xFFb58563),
//                           widget: TextWidget(
//                             text: 'Logout',
//                             isBold: true,
//                             textSize: 18,
//                             textColor: grey,
//                           ),
//                         ),
//                         SizedBox(
//                           height: size.height*0.07,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }
