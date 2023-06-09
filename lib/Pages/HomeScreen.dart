import 'package:flutter/material.dart';

import '../Widgets/AppBar.dart';
import '../Widgets/ImageSlider.dart';
import '../Widgets/NearByStores.dart';
import '../Widgets/TopPickedStores.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<AuthProvider>(context);
    // final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [MyAppBar()];
        },
        //homepage body
        body: ListView(
          children: [
            ImageSlider(),
            Container(
                height: 190,
                color: Colors.green[100],
                child: Expanded(child: TopPickedStores())),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: NearByStores(),
            ),
          ],
        ),
      ),
    );
  }
}
