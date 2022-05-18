import 'package:cached_network_image/cached_network_image.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'app_colors.dart';
import 'repo/route_argument.dart';
import 'controller/chat_controller.dart';

class Chat extends StatefulWidget {
  final RouteArgument routeArgument;

  Chat({Key key, @required this.routeArgument}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  AnimationController _controller;
  String userId;
  num userLat;
  num userLng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1.0,
        leading: Padding(
          padding: const EdgeInsetsDirectional.all(8.0),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            clipBehavior: Clip.hardEdge,
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(brown),
                ),
                padding: EdgeInsets.all(15.0),
              ),
              imageUrl: widget.routeArgument.param2,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          widget.routeArgument.param3,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: ChatScreen(
        peerId: widget.routeArgument.param1,
        peerAvatar: widget.routeArgument.param2,
        peerName: widget.routeArgument.param3,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;

  ChatScreen(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName})
      : super(key: key);

  @override
  State createState() => ChatScreenState(
      peerId: peerId, peerAvatar: peerAvatar, peerName: peerName);
}

class ChatScreenState extends StateMVC<ChatScreen> {
  String peerId;
  String peerAvatar;
  final String peerName;
  ChatController _con;

  ChatScreenState(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.peerName})
      : super(ChatController()) {
    this._con = controller;
  }

  @override
  void initState() {
    super.initState();
    _con.focusNode.addListener(_con.onFocusChange);
    _con.listScrollController.addListener(_con.scrollListener);
    _con.init(peerId);
  }

  @override
  void dispose() async {
    super.dispose();
    _con.onBackPress();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // List of messages
            _con.buildListMessage(peerAvatar),
            _con.buildInput(peerId),
          ],
        ),
        _con.buildLoading()
      ],
    );
  }
}
