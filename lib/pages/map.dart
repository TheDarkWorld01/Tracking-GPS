import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:bottrack/pages/login.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  late Timer _timer;
  LatLng _currentPosition = LatLng(-7.5628965, 110.817339);
  final String apiUrl = 'https://security-xploit7.my.id/api/';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _fetchData();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchData(); // Update every 10 seconds
    });
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latitude = double.parse(data['latitude'].toString());
        final longitude = double.parse(data['longitude'].toString());

        setState(() {
          _currentPosition = LatLng(latitude, longitude);
          _mapController.move(_currentPosition, _mapController.zoom);
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(); 
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robo Track'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 144, 204, 253),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop(); // Close drawer
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentPosition,
          zoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1Ijoic2VjeHBsb2l0NyIsImEiOiJjbG40cnljZHYwMmpkMmxwaG9ibzFnYWUyIn0.ptAgffbjXp7xRjXNoWl4RQ',
              'id': 'mapbox/streets-v11',
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _currentPosition,
                builder: (ctx) => Image.asset(
                  'assets/img/motor.png',
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
