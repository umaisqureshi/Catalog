import 'package:flutter/material.dart';

class Horizontallist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
     width: size.width,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          width: size.width*0.45,
          height: size.height*0.14,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width:1.0,color: Color(0xFFF1F1F1))
          ),
          child: Row(
            children: [
              Container(
                width: size.width*0.3,
                color:Color(0xFFF1F1F1),
                child: Column(
                  children: [
                    Image.asset('assets/images/bluebag.png',width: 79,height: 79,),
                    SizedBox(height: size.height*0.004,),
                    Text("Blue Bag",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Color(0xFF0F1013)),),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding:EdgeInsets.only(left: size.width*0.05,top: size.height*0.02),
                      child: Icon(Icons.edit,color: Colors.black,),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.009,right: size.width*0.003,top: size.height*0.025),
                      child: Container(width: size.width*0.11,height: size.height*0.001,color: Color(0xFF707070),),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.03,top: size.height*0.009),
                      child: Icon(Icons.close,color: Color(0xFFFA0606),),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: size.width*0.45,
          height: size.height*0.14,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width:1.0,color: Color(0xFFF1F1F1))
          ),
          child: Row(
            children: [
              Container(
                width: size.width*0.3,
                color:Color(0xFFF1F1F1),
                child: Column(
                  children: [
                    Image.asset('assets/images/bluebag.png',width: 79,height: 79,),
                    SizedBox(height: size.height*0.004,),
                    Text("Blue Bag",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Color(0xFF0F1013)),),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding:EdgeInsets.only(left: size.width*0.05,top: size.height*0.02),
                      child: Icon(Icons.edit,color: Colors.black,),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.009,right: size.width*0.003,top: size.height*0.025),
                      child: Container(width: size.width*0.11,height: size.height*0.001,color: Color(0xFF707070),),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.03,top: size.height*0.009),
                      child: Icon(Icons.close,color: Color(0xFFFA0606),),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    /*  child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_location: 'images/cats/tshirt.png',
            image_caption: 'Shirt',
          ),

          Category(
            image_location: 'images/cats/dress.png',
            image_caption: 'Dress',
          ),

          Category(
            image_location: 'images/cats/jeans.png',
            image_caption: 'Jeans',
          ),

          Category(
            image_location: 'images/cats/formal.png',
            image_caption: 'Formal',
          ),

          Category(
            image_location: 'images/cats/informal.png',
            image_caption: 'Informal',
          ),

          Category(
            image_location: 'images/cats/accessories.png',
            image_caption: 'Accessories',
          ),

          Category(
            image_location: 'images/cats/shoe.png',
            image_caption: 'Shoes',
          ),
        ],
      ),*/
    );
  }
}

// class Category extends StatelessWidget {
//   final String image_location;
//   final String image_caption;
//
//   Category({this.image_location, this.image_caption});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: InkWell(
//         onTap: () {},
//         child: Container(
//           width: 100.0,
//           child: ListTile(
//               title: Image.asset(
//                 image_location,
//                 width: 100.0,
//                 height: 80.0,
//               ),
//               subtitle: Container(
//                 alignment: Alignment.topCenter,
//                 child: Text(image_caption, style: new TextStyle(fontSize: 12.0),),
//               )
//           ),
//         ),
//       ),
//     );
//   }
// }