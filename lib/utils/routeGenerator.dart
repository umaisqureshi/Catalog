import 'package:category/chat/chat.dart';
import 'package:category/screens/account.dart';
import 'package:category/screens/auth.dart';
import 'package:category/screens/brands.dart';
import 'package:category/screens/cart.dart';
import 'package:category/screens/category.dart';
import 'package:category/screens/changePassword.dart';
import 'package:category/screens/checkout.dart';
import 'package:category/screens/codeVerification.dart';
import 'package:category/screens/country.dart';
import 'package:category/screens/creditCardScreen.dart';
import 'package:category/screens/currency.dart';
import 'package:category/screens/dashboard/alerts.dart';
import 'package:category/screens/dashboard/chatHistoryScreen.dart';
import 'package:category/screens/dashboard/customerHome.dart';
import 'package:category/screens/dashboard/customerHomeExtended.dart';
import 'package:category/screens/dashboard/dashboard.dart';
import 'package:category/screens/dashboard/deals.dart';
import 'package:category/screens/dashboard/fav.dart';
import 'package:category/screens/dashboard/fav_items.dart';
import 'package:category/screens/dashboard/fav_stores.dart';
import 'package:category/screens/dashboard/fav_subStore.dart';
import 'package:category/screens/dashboard/forYou.dart';
import 'package:category/screens/dashboard/home.dart';
import 'package:category/screens/dashboard/photo_view.dart';
import 'package:category/screens/dashboard/popularStore.dart';
import 'package:category/screens/dashboard/popular_stores.dart';
import 'package:category/screens/dashboard/promoCodesScreen.dart';
import 'package:category/screens/dashboard/subStoreDetail.dart';
import 'package:category/screens/dashboard1/screen/account.dart';
import 'package:category/screens/dashboard1/screen/addProduct.dart';
import 'package:category/screens/dashboard1/screen/changePassword.dart';
import 'package:category/screens/dashboard1/screen/currency.dart';
import 'package:category/screens/forgot_password.dart';
import 'package:category/screens/viewAllDeals.dart';
import 'package:category/screens/viewAllScreen.dart';
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

class RouteGeneratorCust {
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
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => Dashboard());
      case '/account':
        return MaterialPageRoute(builder: (_) => Account());
      case '/country':
        return MaterialPageRoute(builder: (_) => Country());
      case '/cart':
        return MaterialPageRoute(builder: (_) => CartScreen(data: args,));
      case '/shoppingPreference':
        return MaterialPageRoute(builder: (_) => ShoppingPreference());
      case '/brands':
        return MaterialPageRoute(builder: (_) => Brands());
      case '/changePassword':
        return MaterialPageRoute(builder: (_) => ChangePassword());
      case '/customerHome':
        return MaterialPageRoute(builder: (_) => CustomerHome(routeArguments: args,));
      case '/customerHomeExtended':
        return MaterialPageRoute(builder: (_) => CustomerHomeExtended(store: args,));
      case '/Notification':
        return MaterialPageRoute(builder: (_) => Notifications());
      case '/Stores':
        return MaterialPageRoute(builder: (_) => Stores());
      case '/Language':
        return MaterialPageRoute(builder: (_) => Language());
      case '/Currency':
        return MaterialPageRoute(builder: (_) => CurrencyScreen());
      case '/ProductDetail':
        return MaterialPageRoute(builder: (_) => ProductDetail(routeArguments: args,));
      case '/PromoCode':
        return MaterialPageRoute(builder: (_) => PromoCodesScreen());
      case '/Deals':
        return MaterialPageRoute(builder: (_) => Deals());
      case '/Fav':
        return MaterialPageRoute(builder: (_) => Fav());
      case '/FavItems':
        return MaterialPageRoute(builder: (_) => FavItems());
      case '/FavStores':
        return MaterialPageRoute(builder: (_) => FavStores());
      case '/FavSubStores':
        return MaterialPageRoute(builder: (_) => FavSubStore());
      case '/ForYou':
        return MaterialPageRoute(builder: (_) => ForYou());
      case '/Home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/PopularStoresLi':
        return MaterialPageRoute(builder: (_) => PopularStoresLi());
      case '/PopularStores':
        return MaterialPageRoute(builder: (_) => PopularStores());
      case '/SubStoreDetails':
        return MaterialPageRoute(builder: (_) => SubStoreDetails(store: args));
      case '/Alert':
        return MaterialPageRoute(builder: (_) => Alerts());
      case '/ChatHistory':
        return MaterialPageRoute(builder: (_) => ChatHistory());
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckOutScreen(routeArguments: args));
      case '/CreditCard':
        return MaterialPageRoute(builder: (_) => CreditCardScreen());
      case '/ForgotPassword':
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case '/ViewAllDeals':
        return MaterialPageRoute(builder: (_) => ViewAllDeals());
      case '/ViewAllScreen':
        return MaterialPageRoute(builder: (_) => ViewAllScreen(screenTitle: args));
      case '/Category':
        return MaterialPageRoute(builder: (_) => MakeMainStore(mainStore: args));
      case '/CodeVerification':
        return MaterialPageRoute(builder: (_) => CodeVerification(routeArguments: args));
      case '/chat':
        return MaterialPageRoute(builder: (_) => Chat(routeArgument: args));


      /*case '/changePasswordPartner':
        return MaterialPageRoute(builder: (_) => ChangePassword1());
      case '/productDetailPartner':
        return MaterialPageRoute(builder: (_) => ProductDetails());
      case '/EditProductPartner':
        return MaterialPageRoute(builder: (_) => EditProduct());
      case '/switchaccountPartner':
        return MaterialPageRoute(builder: (_) => SwitchAccount());
      case '/makestorePartner':
        return MaterialPageRoute(builder: (_) => MakeStore());
      case '/makeMainStore':
        return MaterialPageRoute(builder: (_) => MakeMainStore());
      case '/LanguagePartner':
        return MaterialPageRoute(builder: (_) => Language1());
      case '/countryPartner':
        return MaterialPageRoute(builder: (_) => Country1());
      case '/CurrencyPartner':
        return MaterialPageRoute(builder: (_) => Currency1());
      case '/storePreferencePartner':
        return MaterialPageRoute(builder: (_) => StorePreference());
      case '/substorePartner':
        return MaterialPageRoute(builder: (_) => SubStore());
      case '/account1':
        return MaterialPageRoute(builder: (_) => Account1());
      case '/addProduct':
        return MaterialPageRoute(builder: (_) => AddProduct());
      case '/dashboardPartner':
        return MaterialPageRoute(builder: (_) => DashboardPartner());
      case '/codeVerification':
        return MaterialPageRoute(builder: (_) => CodeVerification());
      case '/subStoreDetails':
        return MaterialPageRoute(builder: (_) => SubStoreDetails());
      case '/chat':
        return MaterialPageRoute(builder: (_) => Chat(routeArgument: args));*/
    // case '/setting':
    //   return MaterialPageRoute(builder: (_) => Setting());

      default:
        return null;
    }
  }
}