import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:retrofit/dio.dart';
import 'package:trival_admin/data_source/network_data/config/apisubdomain.dart';
import 'package:trival_admin/data_source/network_data/config/restclient.dart';
import 'package:trival_admin/models/response/all_product_res.dart';
import 'package:trival_admin/views/create_product_screen.dart';
import 'package:trival_admin/views/edit_product_screen.dart';
import 'package:trival_admin/widgets/common_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var rest = new RestClient(new Dio(), baseUrl: domainServer);

  int getCrossAxisCount() {
    double w = MediaQuery.of(context).size.width;
    if (w < 600) return 2;
    if (w < 1000) return 3;
    return 4;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Admin"),
        leading: IconButton(
          onPressed: () {
            setState(() {});
          },
          icon: Icon(Icons.refresh_outlined),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => CreateProductScreen(),
              ).then((value) {
                if (value is bool && value == true) setState(() {});
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<HttpResponse<AllProductRes>?>(
        future: rest.getProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          List<CatDetail>? data = [];
          data = snapshot.data?.data.data;
          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: data?.length ?? 0,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Divider(),
                Text(
                  "${data![index].nameCat}",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Divider(),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data[index].products?.length ?? 0,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(),
                    childAspectRatio: 16 / 10,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, i) {
                    ProductDetail productDetail = data![index].products![i];
                    return ItemProduct(
                      rest: rest,
                      product: productDetail,
                      onUpdate: (_) async {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => EditProductScreen(product: _),
                        ).then((value) {
                          if (value is bool && value == true) setState(() {});
                        });
                      },
                      onDelete: (_) async {
                        await rest.deleteProducts(id: _);
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

typedef Future<void> OnFuntion(dynamic value);

class ItemProduct extends StatefulWidget {
  final RestClient? rest;
  final ProductDetail? product;
  final OnFuntion? onUpdate;
  final OnFuntion? onDelete;

  const ItemProduct({Key? key, required this.rest, required this.product, this.onUpdate, this.onDelete}) : super(key: key);

  @override
  _ItemProductState createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  bool _isLoadding = false;
  bool _showOption = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onHover: (_) {
            if (_)
              setState(() {
                _showOption = true;
              });
            else {
              setState(() {
                _showOption = false;
              });
            }
          },
          onTap: () {},
          hoverColor: Colors.blue.shade100,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GridView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.product!.image!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.product!.image!.length == 1 ? 1 : 2,
                        childAspectRatio: 16 / 9,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) => Image.network(
                        "$domainServer${widget.product!.image![index]}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.yellow.shade100,
                    child: Text(widget.product!.name!, textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: _showOption,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "${widget.product!.image!.length}",
              style: Theme.of(context).textTheme.headline6!.copyWith(backgroundColor: Colors.white),
            ),
          ),
        ),
        Visibility(
          visible: _showOption,
          child: Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onHover: (_) {
                if (_)
                  setState(() {
                    _showOption = true;
                  });
                else {
                  setState(() {
                    _showOption = false;
                  });
                }
              },
              onTap: () {},
              child: Container(
                color: Colors.white.withOpacity(0.9),
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          widget.onUpdate!(widget.product);
                        },
                        icon: Icon(Icons.edit_outlined)),
                    IconButton(
                      onPressed: () {
                        showCommonDialog(context, title: "Confirm delete", onTapYes: () async {
                          setState(() {
                            _isLoadding = true;
                          });
                          await widget.onDelete!(widget.product!.id);
                          setState(() {
                            _isLoadding = false;
                          });
                        });
                      },
                      icon: Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: _isLoadding,
          child: Container(
            color: Colors.white30,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}
