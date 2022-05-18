import 'package:category/chat/chat.dart';
import 'package:category/screens/account.dart';
import 'package:category/screens/auth.dart';
import 'package:category/screens/brands.dart';
import 'package:category/screens/cart.dart';
import 'package:category/screens/category.dart';
import 'package:category/screens/changePassword.dart';
import 'package:category/screens/codeVerification.dart';
import 'package:category/screens/country.dart';
import 'package:category/screens/currency.dart';
import 'package:category/screens/dashboard/alerts.dart';
import 'package:category/screens/dashboard/customerHome.dart';
import 'package:category/screens/dashboard/customerHomeExtended.dart';
import 'package:category/screens/dashboard/dashboard.dart';
import 'package:category/screens/dashboard/fav.dart';
import 'package:category/screens/dashboard/home.dart';
import 'package:category/screens/dashboard/subStoreDetail.dart';
import 'package:category/screens/dashboard1/screen/account.dart';
import 'package:category/screens/dashboard1/screen/addProduct.dart';
import 'package:category/screens/dashboard1/screen/changePassword.dart';
import 'package:category/screens/dashboard1/screen/createDiscountOffer.dart';
import 'package:category/screens/dashboard1/screen/currency.dart';
import 'package:category/screens/dashboard1/screen/dashboard/alert_details.dart';
import 'package:category/screens/dashboard1/screen/dashboard/deals.dart';
import 'package:category/screens/dashboard1/screen/dashboard/editMainStore.dart';
import 'package:category/screens/dashboard1/screen/dashboard/forYou.dart';
import 'package:category/screens/dashboard1/screen/showStatusMessage.dart';
import '../screens/dashboard1/screen/createMainStore.dart';
import 'package:category/screens/dashboard1/screen/dashboard/dashboard.dart';
import 'package:category/screens/dashboard1/screen/dashboard/subStore.dart';
import 'package:category/screens/dashboard1/screen/editProduct.dart';
import 'package:category/screens/dashboard1/screen/language.dart';
import 'package:category/screens/dashboard1/screen/location.dart';
import 'package:category/screens/dashboard1/screen/makeStore.dart';
import 'package:category/screens/dashboard1/screen/productDetail.dart';
import 'package:category/screens/dashboard1/screen/setting.dart';
import 'package:category/screens/dashboard1/screen/storePreference.dart';
import 'package:category/screens/dashboard1/screen/switchAccount.dart';
import 'package:category/screens/dashboard1/widgets/drawer_widget.dart';
import 'package:category/screens/language.dart';
import 'package:category/screens/notification.dart';
import 'package:category/screens/productDetail.dart';
import 'package:category/screens/settings.dart';
import 'package:category/screens/shoppingPreference.dart';
import 'package:category/screens/signIn.dart';
import 'package:category/screens/signUp.dart';
import 'package:category/screens/splash.dart';
import 'package:category/screens/stores.dart';
import 'package:flutter/material.dart';
import 'package:category/screens/category.dart';

class RouteGeneratorPartner {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => Splash());
      case '/auth':
        return MaterialPageRoute(builder: (_) => Auth());
      case '/signIn':
        return MaterialPageRoute(builder: (_) => SignIn());
      case '/signUp':
        return MaterialPageRoute(builder: (_) => SignUp());
      case '/category':
        return MaterialPageRoute(builder: (_) => Category());
      case '/changePassword':
        return MaterialPageRoute(builder: (_) => ChangePassword());
      case '/productDetailPartner':
        return MaterialPageRoute(builder: (_) => ProductDetails(product: args));
      case '/EditProductPartner':
        return MaterialPageRoute(builder: (_) => EditProduct(prod: args));
      case '/switchaccountPartner':
        return MaterialPageRoute(builder: (_) => SwitchAccount());
      case '/makestorePartner':
        return MaterialPageRoute(builder: (_) => MakeStore(storeId: args,));
      case '/makeMainStore':
        return MaterialPageRoute(builder: (_) => MakeMainStore(mainStore: args,));
      case '/LanguagePartner':
        return MaterialPageRoute(builder: (_) => Language());
      case '/countryPartner':
        return MaterialPageRoute(builder: (_) => Country1());
      case '/CurrencyPartner':
        return MaterialPageRoute(builder: (_) => Currency1());
      case '/storePreferencePartner':
        return MaterialPageRoute(builder: (_) => StorePreference());
      case '/substorePartner':
        return MaterialPageRoute(builder: (_) => SubStore(subStore: args));
      case '/account1':
        return MaterialPageRoute(builder: (_) => Account1());
      case '/addProduct':
        return MaterialPageRoute(builder: (_) => AddProduct(routeArguments: args));
      case '/dashboardPartner':
        return MaterialPageRoute(builder: (_) => DashboardPartner());
      case '/CodeVerification':
        return MaterialPageRoute(builder: (_) => CodeVerification(routeArguments: args,));
      case '/subStoreDetails':
        return MaterialPageRoute(builder: (_) => SubStoreDetails());
      case '/chat':
        return MaterialPageRoute(builder: (_) => Chat(routeArgument: args));
      case '/AlertPartner':
        return MaterialPageRoute(builder: (_) => Alerts());
      case '/DealsPartner':
        return MaterialPageRoute(builder: (_) => Reports());
      case '/EditMainStorePartner':
        return MaterialPageRoute(builder: (_) => EditMainStore(routeArguments: args));
      case '/FavPartner':
        return MaterialPageRoute(builder: (_) => Fav());
      case '/ForYouPatner':
        return MaterialPageRoute(builder: (_) => Sale());
      case '/HomePartner':
        return MaterialPageRoute(builder: (_) => Home());
      case '/CreateDiscountOfferPartner':
        return MaterialPageRoute(builder: (_) => CreateDiscountOffer(routeArguments: args));
      case '/ShowStatusMessagePartner':
        return MaterialPageRoute(builder: (_) => StatusMessage());
      case '/AlertDetailsPartner':
        return MaterialPageRoute(builder: (_) => AlertDetails());

    // case '/setting':
    //   return MaterialPageRoute(builder: (_) => Setting());

      default:
        return null;
    }
  }
}