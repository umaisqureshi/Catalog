import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:category/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/sharedPrefs.dart';

class ChatController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  String id;
  String opponentId;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  File videoFile;
  bool isLoading;
  bool isShowSticker;
  String fileUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  ChatController() {
    this.scaffoldKey = GlobalKey<ScaffoldState>();
  }

  init(peerId) {
    groupChatId = '';
    isLoading = false;
    isShowSticker = false;
    fileUrl = '';
    opponentId = peerId;
    readLocal(peerId);
  }

  scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal(peerId) async {
    prefs = await SharedPreferences.getInstance();
    Welcome wel = Welcome.fromJson(json.decode(SharedPrefs().token));

    id = wel.userData.id;
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    FirebaseFirestore.instance.collection('Users').doc(id).update({
      'chattedWith': FieldValue.arrayUnion([peerId])
    });
    FirebaseFirestore.instance.collection('Users').doc(peerId).update({
      'chattedWith': FieldValue.arrayUnion([id])
    });
    setState(() {});
  }

  Future getImage(peerId) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
    }
  }

  Future getVideo(peerId) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getVideo(source: ImageSource.gallery);
    videoFile = File(pickedFile.path);

    if (videoFile != null) {
      setState(() {
        isLoading = true;
      });
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

 /* Future uploadFile(peerId, type) async {
    String fileName = type == 1
        ? '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg'
        : '${DateTime.now().millisecondsSinceEpoch.toString()}.mp4';
    var reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(
        type == 1 ? imageFile : videoFile,
        type == 2
            ? StorageMetadata(contentType: 'video/mp4')
            : StorageMetadata(contentType: 'image/jpeg'));
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) async {
      fileUrl = downloadUrl;

      setState(() {
        isLoading = false;
        onSendMessage(fileUrl, type, peerId);
      });
    }, onError: (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    });
  }*/

  /*Future<void> uploadThumbFile(file, time) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
    var reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =
        reference.putFile(file, StorageMetadata(contentType: 'image/jpeg'));
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(time)
          .update({'thumb': downloadUrl});
    }, onError: (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    });
  }*/

  void onSendMessage(String content, int type, peerId) {
    if (content.trim() != '') {
      textEditingController.clear();
      var time = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseFirestore.instance.collection("Users").doc(id).update({
        'lastMessages' : [{peerId: content}],
      },);
      FirebaseFirestore.instance.collection("Users").doc(peerId).update({
        'lastMessages' : [{id: content}],
      }, );
      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(time);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'content': content,
            'type': type,
            'thumb': 'N/A'
          },
        );
      }).whenComplete(() async {
        if (type == 2) {
        }
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {}
  }

  Widget buildItem(int index, DocumentSnapshot document, peerAvatar) {
    if (document.data()['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          (document.data()['type'] == 0)
              // Text
              ? Container(
                  child: Text(
                    document.data()['content'],
                    style: TextStyle(color: Colors.white,),
                  ),
                  padding: EdgeInsetsDirectional.only(start: 15.0, top: 10.0, end:15.0, bottom: 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: brown,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10), topLeft: Radius.circular(10),)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : document.data()['type'] == 1
                  // Image
                  ? Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    brown),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: brown,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'images/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document.data()['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                         /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullSizeImage(
                                      url: document.data()['content'])));*/
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  : document.data()['type'] == 2
                      // video
                      ? Stack(
                          children: [
                            Container(
                              child: FlatButton(
                                child: Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                brown),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(70.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Material(
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                    imageUrl: document.data()['thumb'],
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () {
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoPlayerScreen(
                                                videoUrl:
                                                    document.data()['content'],
                                              )));*/
                                },
                                padding: EdgeInsets.all(0),
                              ),
                              margin: EdgeInsets.only(
                                  bottom:
                                      isLastMessageRight(index) ? 20.0 : 10.0,
                                  right: 10.0),
                            ),
                            Container(
                                width: 200.0,
                                height: 200.0,
                                child: Center(
                                  child: Icon(
                                    Icons.play_circle_filled,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ))
                          ],
                        )
                      : Container(),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                /*isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  brown),
                            ),
                            width: 35.0,
                            height: 35.0,
                            padding: EdgeInsets.all(10.0),
                          ),
                          imageUrl: peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),*/
                document.data()['type'] == 0
                    ? Container(
                        child: Text(
                          document.data()['content'],
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: EdgeInsetsDirectional.only(start: 15.0, top: 10.0, end: 15.0, bottom: 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                              color: Colors.brown[100],
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10), )),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document.data()['type'] == 1
                        ? Container(
                            child: FlatButton(
                              child: Material(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          brown),
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    padding: EdgeInsets.all(70.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Material(
                                    child: Image.asset(
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  imageUrl: document.data()['content'],
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullSizeImage(
                                            url: document.data()['content'])));*/
                              },
                              padding: EdgeInsets.all(0),
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : document.data()['type'] == 2
                            ? Stack(
                                children: [
                                  Container(
                                    child: FlatButton(
                                      child: Material(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      brown),
                                            ),
                                            width: 200.0,
                                            height: 200.0,
                                            padding: EdgeInsets.all(70.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Material(
                                            child: Image.asset(
                                              'images/img_not_available.jpeg',
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8.0),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                          ),
                                          imageUrl: document.data()['thumb'],
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      onPressed: () {
                                        /*Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoPlayerScreen(
                                                      videoUrl: document
                                                          .data()['content'],
                                                    )));*/
                                      },
                                      padding: EdgeInsets.all(0),
                                    ),
                                    margin: EdgeInsets.only(left: 10.0),
                                  ),
                                  Container(
                                    width: 200.0,
                                    height: 200.0,
                                    child: Center(
                                      child: Icon(
                                        Icons.play_circle_filled,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
              ],
            ),
            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(
                              document.data()['timestamp'].toString()))),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

/*  getThumb(videoPathUrl, time) async {
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: videoPathUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      quality: 60,
    );
    uploadThumbFile(File(uint8list), time);
    print('thumb $uint8list');
  }*/

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    FirebaseFirestore.instance
        .collection("User")
        .doc(opponentId)
        .update({id: FieldValue.delete()});
    Navigator.pop(context);
    return Future.value(false);
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Center(
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: Colors.pink,
              ),
            )
          : Container(),
    );
  }

  Widget buildInput(peerId) {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          /*Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.perm_media),
                onPressed: () {
                  showBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      builder: (context) => Container(
                            height: 210,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Colors.pink.withOpacity(0.1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[50],
                                    blurRadius: 3,
                                    offset: Offset(0, 0),
                                    spreadRadius: 3)
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Pick Image',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        getImage(peerId);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        child: Icon(
                                          Icons.image,
                                          size: 50,
                                        ),
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blueGrey[200],
                                              spreadRadius: 3,
                                              offset: Offset(0, 0),
                                              blurRadius: 3,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        getVideo(peerId);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        child: Icon(
                                          Icons.video_library,
                                          size: 50,
                                        ),
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blueGrey[200],
                                              spreadRadius: 3,
                                              offset: Offset(0, 0),
                                              blurRadius: 3,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ));
                },
                color: brown,
              ),
            ),
            color: Colors.white,
          ),*/
          // Edit text
          Flexible(
            child: Container(
              padding: EdgeInsetsDirectional.only(start: 16),
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0, peerId);
                },
                style: TextStyle(fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: AppLocalizations.of(context).typeMessage,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send, ),
                onPressed: () =>
                    onSendMessage(textEditingController.text, 0, peerId),
                color: brown,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage(peerAvatar) {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(brown)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              brown)));
                } else {
                  listMessage.addAll(snapshot.data.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(
                        index, snapshot.data.docs[index], peerAvatar),
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
