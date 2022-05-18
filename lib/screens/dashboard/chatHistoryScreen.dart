import 'dart:async';
import 'dart:convert';
import 'package:category/chat/repo/route_argument.dart';
import 'package:category/modals/apiError.dart';
import 'package:category/modals/apiResponse.dart';
import 'package:category/modals/user.dart';
import 'package:category/utils/sharedPrefs.dart';
import 'package:category/widgets/noConnection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/services.dart';

class ChatHistory extends StatefulWidget {
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {

  ApiResponse _apiResponse = ApiResponse();
  Welcome _userInfo;

  bool isInternetAvailable = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  List<QueryDocumentSnapshot> chatHistory = [];

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState((){
          isInternetAvailable = true;
        });
        break;
      default:
        setState(() => isInternetAvailable = false);
        break;
    }
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }


  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _userInfo = Welcome.fromJson(json.decode(SharedPrefs().token));
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(AppLocalizations.of(context).chat,
            style: TextStyle(
              color: brown,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsetsDirectional.only(start: 16, bottom: 16, end: 16),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: TextField(
                    style: TextStyle(
                        color: Colors.black54, fontSize: 15),
                    onSubmitted: (value) {
                      print(value);
                    },
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 8),
                        prefixIcon: Icon(Icons.search,
                            color: Colors.grey[500]),
                        suffixIcon: Visibility(
                            visible: false,
                            maintainSize: true,
                            maintainState: true,
                            maintainAnimation: true,
                            child: Icon(Icons.search)),
                        hintText: AppLocalizations.of(context)
                            .searchAndDiscover,
                        hintStyle: TextStyle(
                            fontSize: 13, color: Colors.grey[500]),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(
                height: med.height*0.02,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("Users").where('chattedWith', arrayContains: _userInfo.userData.id).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData){
                      chatHistory = snapshot.data.docs;
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 16.0, start: 16),
                        child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data =
                              snapshot.data.docs[index].data();
                              List<dynamic> lastMessages = data['lastMessages'];
                              return InkWell(
                                onTap: (){
                                  print("Conversation Id :::::::::::::::::::::::: ${chatHistory[index].data()["id"]}");
                                  Navigator.of(context).pushNamed('/chat',
                                      arguments: RouteArgument(
                                          param1: data['id'],
                                          param2: data['profileImageUrl'].length > 0
                                              ? data['profileImageUrl']
                                              : 'default',
                                          param3: data['username'] ?? 'User'));
                                },
                                child: Container(
                                  height: med.height*0.08,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: med.height*0.07,
                                        width: med.width*0.2,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: data['profileImageUrl'].isEmpty ? AssetImage("assets/icons/user.png",) : NetworkImage(data['profileImageUrl']),
                                              fit: BoxFit.contain,
                                            )
                                        ),
                                      ),
                                      // Name
                                      Container(
                                        width: med.width*0.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              child: Text(data['username'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            /* SizedBox(
                                              height: med.height*0.01,
                                            ),*/
                                            Container(
                                              child: Text(
                                                "📧 ${data['email']}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: med.width*0.15,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        ),
                      );
                    }
                    else{
                      return Center(child: CircularProgressIndicator(backgroundColor: brown,),);
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );

  }
}


