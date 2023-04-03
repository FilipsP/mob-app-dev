import 'package:flutter/material.dart';
import 'package:mob_app_dev/camera_home.dart';
import 'package:mob_app_dev/counter.dart';
import 'package:mob_app_dev/microphone_home.dart';
import 'item.dart';
import 'package:icon_forest/amazingneoicons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'SourceSansPro',
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const CircleAvatar(
      radius: 450, // set the radius of the circle
      backgroundImage: NetworkImage(
          'https://blog.soundcloud.com/wp-content/uploads/2011/11/kitten.jpg'),
      backgroundColor: Colors.white,
      // set the background image of the circle
    ),
    const Counter(title: 'Counter'),
    const Text(
      'Index 2: Business',
      style: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text(
          'Mob App Dev',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 5,
                offset: Offset(1.3, 2),
              ),
            ],
          ),
        ),
      ),
      //dropdown menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera test'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CameraHome(),
                ),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.mic),
                title: const Text('Microphone Test'),
                onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MicrophoneHome(),
                      ),
                    )),
            ListTile(
              leading: const Icon(AmazingNeoIcons.angle_double_down),
              title: const Text('Discount'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Item(
                    shop: 'Sugar House',
                    title: 'Cake "Amore"',
                    image: 'assets/images/cake.jpg',
                    description:
                        'Life should be sweet without too much effort. '
                        'Choose from Master Quality products that your soul desires and celebrate every day. '
                        'A rich selection satisfies the needs of even the most demanding food connoisseur.',
                    price: 12.99,
                    pricePerKg: 12.99,
                    discount: 50,
                  ),
                ),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Template',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
