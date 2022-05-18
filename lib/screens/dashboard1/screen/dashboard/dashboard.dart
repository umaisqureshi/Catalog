import 'package:category/screens/dashboard1/screen/dashboard/deals.dart';
import 'package:category/screens/dashboard1/screen/dashboard/fav.dart';
import 'package:category/screens/dashboard1/screen/dashboard/forYou.dart';
import 'package:category/screens/dashboard1/screen/dashboard/home.dart';
import 'package:category/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'alerts.dart';
import 'chat.dart';

class DashboardPartner extends StatefulWidget {
  @override
  _DashboardPartnerState createState() => _DashboardPartnerState();
}

class _DashboardPartnerState extends State<DashboardPartner> {
  bool selectedColor=true;
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
        'page': Home(),
      },
      {
        'page':Sale(isLeft: true,)
      },
      {
        'page': Reports(),
      },
      {
        'page': Chat(),
      },
      {
        'page': Alerts(),
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
          elevation: 8,
          onTap: _selectPage,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFFb58563),
          backgroundColor: Colors.white,
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
                Icons.shopping_bag_rounded,
                size: 20,
              ),
              label: AppLocalizations.of(context).salesHeading,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.fileInvoiceDollar,
                size: 20,
              ),
              label: AppLocalizations.of(context).reports,
            ),
            BottomNavigationBarItem(
               icon: Icon(
              Icons.chat,
              size: 20,
            ),
              label: AppLocalizations.of(context).chat,
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
