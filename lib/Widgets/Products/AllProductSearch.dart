import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gift_mart/Models/ProductModel.dart';

import '../Cart/Counter.dart';

class AllProductSearch extends StatelessWidget {
  final String offer;
  final AllProduct allProducts;
  final DocumentSnapshot document;
  const AllProductSearch(
      {Key? key,
      required this.offer,
      required this.allProducts,
      required this.document})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        child: Row(children: [
          Stack(
            children: [
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    height: 140,
                    width: 130,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                            tag:
                                'product${allProducts.document!['productName']}',
                            child: Image.network(
                                allProducts.document!['productImage']))),
                  ),
                ),
              ),
              if (allProducts.document!['comparedPrice'] >
                  allProducts.document!['price'])
                Container(
                  decoration: const BoxDecoration(
                    // color: Theme.of(context).primaryColor,
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 3, bottom: 3),
                    child: Text(
                      '${offer}% OFF',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allProducts.document!['brand'],
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            allProducts.document!['productName'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                  '\N${allProducts.document!['price'].toStringAsFixed(00)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 10),
                              if (allProducts.document!['comparedPrice'] >
                                  allProducts.document!['price'])
                                Text(
                                    '\N${allProducts.document!['comparedPrice'].toStringAsFixed(00)}',
                                    style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 12))
                            ],
                          ),
                        ]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CounterForCard(allProducts.document!),
                          ],
                        ),
                      ),
                    ],
                  )
                ]),
          )
        ]),
      ),
    );
  }
}
