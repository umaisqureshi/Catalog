import 'package:category/screens/dashboard/deals.dart';
import 'package:category/screens/dashboard/fav.dart';
import 'package:category/screens/dashboard/forYou.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'alerts.dart';
import 'customerHome.dart';
import 'customerHomeExtended.dart';
import 'home.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool home2=true;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _selectedPageIndex = 0;
  List<Map<String, dynamic>> _pages;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _pages = [
      {
        'page':Home(),
      },
      {
        'page': ForYou(),
      },
      {
        'page': Deals(),
      },
      {
        'page': Fav(),
      },
      {
        'page': Alerts(),
      },
      {
        'page': CustomerHome(),
      },
      {
        'page': CustomerHomeExtended(),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: Colors.white,
        ),
        child: BottomNavigationBar(
          elevation: 2,
          onTap: _selectPage,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Color(0xFFb58563),
          type: BottomNavigationBarType.fixed,

          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(

            fontSize: 12
          ),
          currentIndex: _selectedPageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 20,
              ),
              label: AppLocalizations.of(context).home,

            ),
            BottomNavigationBarItem(
              icon: Icon(

                Icons.find_in_page,
                size: 20,
              ),

              label: AppLocalizations.of(context).forYou,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.tag,
                size: 20,
              ),
              label: AppLocalizations.of(context).deals,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: 20,
              ),
              label: AppLocalizations.of(context).favourites,
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.notifications,size: 20,),
              label: AppLocalizations.of(context).alerts,
            ),
          ],
        ),

      ),
    );
  }
}
