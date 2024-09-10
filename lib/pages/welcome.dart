import 'package:flutter/material.dart';
import 'package:bottrack/pages/login.dart';
// import 'package:robo_track/pages/register.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _introSlides = [
    IntroSlide(
      image: 'assets/img/1.png',
      text: 'Selamat datang di Robo-Track,aplikasi yang digunakan untuk mengontrol dan mengawasi pergerakan motor anda',
    ),
    IntroSlide(
      image: 'assets/img/2.png',
      text: 'Katakan selamat tinggal terhadap curanmor,karena adanya Robo-Track anda bisa lebih tenang terhadap keamanan motor anda',
    ),
    IntroSlide(
      image: 'assets/img/3.png',
      text: 'Dengan adanya sistem pelacakan secara realtime,anda dapat mengetahui posisi kendaraan ada berada setiap waktu',
    ),
    IntroSlide(
      image: 'assets/img/4.png',
      text: 'Mulai amankan kendaraan anda sekarang dengan membuat akun dan mendaftarkan kendaraan anda di sistem',
      showButton: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: _introSlides,
          ),
          Positioned(
            bottom: 30.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                _introSlides.length,
                (int index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    height: 10.0,
                    width: _currentPage == index ? 20.0 : 10.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroSlide extends StatelessWidget {
  final String image;
  final String text;
  final bool showButton;

  const IntroSlide({
    Key? key,
    required this.image,
    required this.text,
    this.showButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 200.0,
            height: 200.0,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Sora',
            ),
            textAlign: TextAlign.center,
          ),
          if (showButton) SizedBox(height: 40.0),
          if (showButton)
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  )
                );
              },
              child: Text('DAFTAR SEKARANG',
                style: TextStyle(
                  color: const Color.fromARGB(255, 245, 245, 245),
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }
}
