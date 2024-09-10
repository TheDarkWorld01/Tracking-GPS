import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:bottrack/pages/register.dart';
import 'package:bottrack/pages/map.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // API URL yang baru
    String apiUrl = 'https://security-xploit7.my.id/login.php';
    final response = await http.post(Uri.parse(apiUrl),
        body: {'username': username, 'password': password});

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        _showAlertDialog('Berhasil', 'Anda Berhasil Login', isSuccess: true);
      } else {
        _showAlertDialog('Gagal', 'Maaf, username dan password tidak sesuai');
      }
    } else {
      _showAlertDialog('Error', 'Terjadi kesalahan pada server');
    }
  }

  void _showAlertDialog(String title, String content,
      {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/bg.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 25,
                      width: 350,
                      height: 370,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img/trackicon.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Color.fromARGB(255, 84, 59, 246)),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 84, 59, 246),
                                ),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.person,
                                    color: Color.fromARGB(255, 84, 59, 246)),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.lock,
                                    color: Color.fromARGB(255, 84, 59, 246)),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: _isObscure,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _togglePasswordVisibility,
                                  icon: _isObscure
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                  color: Colors.grey[700],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Color.fromARGB(255, 84, 59, 246),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 84, 59, 246),
                            Color.fromRGBO(143, 148, 251, 1),
                          ]),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
