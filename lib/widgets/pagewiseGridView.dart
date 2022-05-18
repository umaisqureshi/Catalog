import 'package:category/api/storeApis.dart';
import 'package:category/modals/productsByStoresModal.dart';
import 'package:category/widgets/products.dart';
import 'package:flutter/material.dart';

import 'ProductCardView.dart';

class PagewiseGridView extends StatefulWidget {
  ProductsByStore products;
  String id;

  PagewiseGridView({this.products, this.id});

  @override
  _PagewiseGridViewState createState() => _PagewiseGridViewState();
}

class _PagewiseGridViewState extends State<PagewiseGridView> {
  ScrollController scrollController = ScrollController();
  List<Product> productsList;
  int currentPage = 1;

  @override
  void initState() {
    productsList = widget.products.products;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (scrollController.position.maxScrollExtent > scrollController.offset &&
            scrollController.position.maxScrollExtent - scrollController.offset <=
                50) {
          print('End Scroll');
          getProductsByStores(
              storeId: widget.id, page: currentPage + 1, limit: '2')
              .then((val) {
            currentPage = currentPage + 1;
            ProductsByStore _prod = val.Data;
            setState(() {
              productsList.addAll(_prod.products);
            });
          });
        }else{
          print("Scroll Not Updated");
        }
        return true;
      },
      child: GridView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: productsList.length,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: MediaQuery.of(context).size.width * 0.020,
          mainAxisSpacing: MediaQuery.of(context).size.width * 0.03,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/ProductDetail');
              },
              child: ProductCardView(
                  name: productsList[index].productName,
                  price: productsList[index].price.toString(),
                  Image: productsList[index].images[0]));
        },
      ),
    );
  }
}
