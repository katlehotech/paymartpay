import 'package:flutter/material.dart';
import 'homeViews/friends_page.dart';
import 'homeViews/home_page.dart';
import 'homeViews/pay_page.dart';
import 'homeViews/transactions_page.dart';
import 'homeViews/wallet_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
 State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _viewIndex = 0; // this is the first view of the PageView
  final PageController _pageViewController = PageController(
      initialPage: 0, // this is the first view of the PageView
      viewportFraction: 1 // it should show a full page
  );

  // Allows the clicking of the 3rd BottomNavigationBarItem
  // The 3rd button is hidden under the FAB
  void bottomNavBarClick(int index) {
    setState(() {
      _viewIndex = index;
      _pageViewController.jumpToPage(_viewIndex);
    });
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF0D47A1),
                Color(0xFF1976D2),
                Color(0xFF42A5F5),
              ],
            ),
          ),
        ),
        title: const Text('PayMart'),
        // add qr code icon button action
        actions: <Widget>[
          // a textbutton for showing amount you have R2370.50
          TextButton(
            onPressed: () {
              // do something
            },
            child: const Text(
              'R2370.50',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.qr_code),
            tooltip: 'Scan QR Code',
            onPressed: () {
              // do something
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageViewController,
        onPageChanged: (int index) {
          setState(() {
            _viewIndex = index;
          });
        },
        children: const <Widget>[
          HomePage(),
          TransactionsPage(),
          PayPage(),
          FriendsPage(),
          WalletPage(),
        ],
      ),
      // add a bottom sheet with 5 items (home, wallet) and a floating action button in the middle
      bottomNavigationBar: Stack(
        //overflow: Overflow.visible,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
      Positioned(
      child: BottomNavigationBar(
        elevation: 4.0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _viewIndex,
        onTap: (int index) {
          setState(() {
            _viewIndex = index;
            _pageViewController.jumpToPage(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Transactions",
              ),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: "PAY",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Friends"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: "Wallet"
    ),
        ],
      ),
    ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 0.0,
            width: 58.0,
            height: 58.0,
            child: FloatingActionButton(
              onPressed: () {
                bottomNavBarClick(2);
              },
              mini: false,
              highlightElevation: 0.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0))),
              child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                            ),
                          ),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: const Icon(
                  Icons.center_focus_weak,
                  size: 24.0,
                ),
              ),
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 8.0,
            child: const Text("PAY",
                style: TextStyle(color: Colors.white, fontSize: 12.0)),
          )
        ],
      ),
    );

  }
}
