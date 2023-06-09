import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/CartServices.dart';
import '../Products/AddToCartWidget.dart';

class CounterWidget extends StatefulWidget {
  final DocumentSnapshot document;
  final int qty;
  final String docId;
  const CounterWidget(
      {super.key,
      required this.document,
      required this.qty,
      required this.docId});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final CartServices _cart = CartServices();
  int? _qty;
  bool _updating = false;
  bool _exists = true;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _qty = widget.qty;
    });

    return _exists
        ? Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 56,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Row(children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _updating = true;
                      });
                      if (_qty == 1) {
                        _cart.removeFromCart(widget.docId).then((value) {
                          setState(() {
                            _updating = false;
                            _exists = false;
                          });
                          _cart.checkCartData();
                        });
                      }
                      if (_qty! > 1) {
                        setState(() {});
                        var total = _qty! * widget.document['price'];
                        _cart
                            .updateCartQty(widget.docId, _qty, total)
                            .then((value) {
                          setState(() {
                            _updating = false;
                          });
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          _qty == 1 ? Icons.delete : Icons.remove,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 8, bottom: 8),
                      child: _updating
                          ? Container(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)),
                            )
                          : Text(_qty.toString()),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _updating = true;
                      });
                      var total = _qty! * widget.document['price'];

                      _cart
                          .updateCartQty(widget.docId, _qty, total)
                          .then((value) {
                        setState(() {
                          _updating = false;
                        });
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            )),
          )
        : AddToCartWidget(widget.document);
  }
}
