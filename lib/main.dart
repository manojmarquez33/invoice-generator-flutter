import 'package:flutter/material.dart';
import 'package:invoice_generator/invoice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Invoice Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFF1493),
      ),
      home: MyAppScreen(),
    );
  }
}

class MyAppScreen extends StatefulWidget {
  @override
  _MyAppScreenState createState() => _MyAppScreenState();
}

class _MyAppScreenState extends State<MyAppScreen> {
  String shopName = 'Jeeva Admin Solution Services';
  Widget currentPage = InvoiceApp(); // Initialize the default page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Drawer(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70, // Change the background color to grey
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    height: 200,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xFFFF1493),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/profile.png',
                              width: 80, height: 80),
                          SizedBox(height: 8),
                          Text(
                            '$shopName',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Generate Invoice'),
                    onTap: () {
                      setState(() {
                        currentPage = InvoiceApp(); // Set the current page
                      });
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  ListTile(
                    title: Text('Menu Item 2'),
                    onTap: () {
                      // Handle menu item 2 tap here
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  ListTile(
                    title: Text('Menu Item 3'),
                    onTap: () {
                      // Handle menu item 3 tap here
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  ListTile(
                    title: Text('Menu Item 4'),
                    onTap: () {
                      // Handle menu item 4 tap here
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  ListTile(
                    title: Text('Menu Item 5'),
                    onTap: () {
                      // Handle menu item 5 tap here
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Expanded(
            child: currentPage, // Show the current page
          ),
        ],
      ),
    );
  }
}
