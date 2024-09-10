import 'package:flutter/material.dart';
import 'package:bottrack/pages/map.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isObscure = true;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _register() async {
    String nama = namaController.text;
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    String apiUrl = 'https://security-xploit7.my.id/register.php';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'nama': nama,
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        _showAlertDialog('Sukses', 'Registrasi Berhasil', true);
      } else {
        _showAlertDialog(
            'Error', 'Registrasi Gagal: ${data['message']}', false);
      }
    } else {
      _showAlertDialog('Error', 'Terjadi kesalahan pada server', false);
    }
  }

  void _showAlertDialog(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
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
                                    controller: namaController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Nama",
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
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 84, 59, 246),
                                ),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.email,
                                    color: Color.fromARGB(255, 84, 59, 246)),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
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
                    SizedBox(height: 40),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 84, 59, 246),
                          Color.fromRGBO(143, 148, 251, 1),
                        ]),
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: _register,
                          child: Text(
                            "Register",
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
