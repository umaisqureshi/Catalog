import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullSizePhoto extends StatefulWidget {
  final String url;
  FullSizePhoto({Key key, @required this.url}) : super(key: key);

  @override
  _FullSizePhotoState createState() => _FullSizePhotoState();
}

class _FullSizePhotoState extends State<FullSizePhoto> {
  String img;

  @override
  void initState() {
    super.initState();
    img = widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        automaticallyImplyLeading: false,
        //backgroundColor: Colors.black,
        *//*leading: IconButton(onPressed: (){
          Navigator.of(context).pop(img);
        }, icon: Icon(Icons.arrow_back_ios),),*//*
        *//*actions: [
          IconButton(onPressed: () async {
            String model = await Navigator.of(context).pushNamed('/get-user-photos',
                arguments: img);
            if (model != null) {
              print(model);
            setState(() {
              img='null';
              img = model;
            });
            }
          }, icon: Icon(Icons.edit , color: Colors.white,))
        ],*//*
      ),*/
      body: PhotoView(imageProvider: CachedNetworkImageProvider(img))
    );
  }
}
