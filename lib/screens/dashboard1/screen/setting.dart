// import 'package:category/screens/dashboard1/utils/constant.dart';
// import 'package:category/screens/dashboard1/widgets/backIconWidget.dart';
// import 'package:category/screens/dashboard1/widgets/bottomBarWidget.dart';
// import 'package:category/screens/dashboard1/widgets/buttonWidget.dart';
// import 'package:category/screens/dashboard1/widgets/textWidget.dart';
// import 'package:category/screens/dashboard1/widgets/tileWidget.dart';
// import 'package:category/screens/dashboard1/widgets/topBarWidget.dart';
// import 'package:flutter/material.dart';
//
// class Setting extends StatefulWidget {
//   @override
//   _SettingState createState() => _SettingState();
// }
//
// class _SettingState extends State<Setting> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             title: TextWidget(
//               text: 'Main Menu',
//               textSize: 18,
//               textColor: primary,
//               isBold: true,
//             ),
//             centerTitle: true,
//             elevation: 0,
//           ),
//           body: Stack(
//             children: [
//               Padding(
//                 padding:  EdgeInsets.only(top: size.height*0.02),
//                 child: ListView(
//                   children: [
//
//                     SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(right:size.width*0.68),
//                               child: Text("Account",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
//                             ),
//                             SizedBox(height: 10,),
//                             TileWidget(
//                               function: () =>
//                                   Navigator.pushNamed(context, '/account1'),
//                               leadingWidget: Row(
//                                 children: [
//                                   Image.asset(
//                                     'assets/images/circle.png',
//                                     scale: 2,
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   TextWidget(
//                                     textSize: 16,
//                                     isBold: true,
//                                     textColor: primary,
//                                     text: 'Jhon Smith',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             TileWidget(
//                               function: () =>
//                                   Navigator.pushNamed(context, '/changePassword1'),
//                               trailingWidget: TextWidget(
//                                 text: "******",
//                                 textSize: 14,
//                                 isBold: true,
//                                 textColor: primary.withOpacity(0.4),
//                               ),
//                               leadingWidget: TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'Change Password',
//                               ),
//                             ),
//                             TileWidget(
//                               function: () =>
//                                   Navigator.pushNamed(context, '/switchaccount'),
//                               trailingWidget: TextWidget(
//                                 text: "Customer",
//                                 textSize: 14,
//                                 isBold: true,
//                                 textColor: primary.withOpacity(0.4),
//                               ),
//                               leadingWidget: TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'Switch Account',
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 20,vertical: 6),
//                                 child: TextWidget(
//                                   text: 'Preferences',
//                                   textColor: primary.withOpacity(0.3),
//                                   textSize: 18,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 3,),
//                             TileWidget(
//                               function: ()=>
//                                   Navigator.pushNamed(context, '/Language1'),
//                               leadingWidget: TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'Language',
//                               ),
//                               trailingWidget: TextWidget(
//                                 textSize: 16,
//                                 textColor: primary.withOpacity(0.4),
//                                 text: 'English',
//                               ),
//                             ),
//                             TileWidget(
//                               function: () =>
//                                   Navigator.pushNamed(context, '/country1'),
//                               leadingWidget: TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'Location',
//                               ),
//                               trailingWidget: TextWidget(
//                                 textSize: 16,
//                                 textColor: primary.withOpacity(0.4),
//                                 text: 'New York City',
//                               ),
//                             ),
//                             TileWidget(
//                               function: () =>
//                                   Navigator.pushNamed(context, '/Currency1'),
//                               leadingWidget: TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'Currency',
//                               ),
//                               trailingWidget: TextWidget(
//                                 textSize: 16,
//                                 textColor: primary.withOpacity(0.4),
//                                 text: '\$',
//                               ),
//                             ),
//                             TileWidget(
//                               function: () =>
//                                   Navigator.pushNamed(context, '/storePreference'),
//                               leadingWidget: TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'Store Preference',
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.topLeft,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 20,vertical: 6),
//                                 child: TextWidget(
//                                   text: 'Support',
//                                   textColor: primary.withOpacity(0.3),
//                                   textSize: 18,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 3,),
//                             TileWidget(
//                               leadingWidget: TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'FAQ',
//                               ),
//                             ),
//                             TileWidget(
//                               leadingWidget: TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'Contact Us',
//                               ),
//                             ),
//                             TileWidget(
//                               leadingWidget: TextWidget(
//                                 textSize: 16,
//                                 isBold: true,
//                                 textColor: primary,
//                                 text: 'About Us',
//                               ),
//                             ),
//                             SizedBox(
//                               height: size.height*0.01,
//                             ),
//                             ButtonWidget(
//                               buttonHeight: 50,
//                               buttonWidth: MediaQuery.of(context).size.width,
//                               function: () =>
//                                   Navigator.pushNamed(context, '/auth'),
//                               roundedBorder: 10,
//                               buttonColor: Color(0xFFb58563),
//                               widget: TextWidget(
//                                 text: 'Logout',
//                                 textSize: 18,
//                                 textColor: grey,
//                               ),
//                             ),
//                             SizedBox(
//                               height: size.height*0.07,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             ],
//           ),
//         ));
//   }
// }
//
