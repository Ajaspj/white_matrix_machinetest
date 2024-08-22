import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:whitematrix/constants/colorconstants.dart/colorconstants.dart';
import 'package:whitematrix/view/loginscreen/loginscreen.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        scrollPhysics: BouncingScrollPhysics(),
        pages: [
          PageViewModel(
              titleWidget: Text(
                "Discover Amazing Products",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              bodyWidget: Text(
                "Explore a wide range of products at unbeatable prices. Your shopping adventure starts here!",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.justify,
              ),
              image: SvgPicture.asset(
                "assets/images/welcome1.svg",
                height: 250,
              )),
          PageViewModel(
              titleWidget: Text("Special Offers Just for You",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  textAlign: TextAlign.left),
              bodyWidget: Text(
                "Take advantage of exclusive discounts and offers tailored for you. Don’t miss out on great deals!",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              image: SvgPicture.asset(
                "assets/images/welcome2.svg",
                height: 250,
              )),
          PageViewModel(
              titleWidget: Text("Welcome",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
              bodyWidget: Text(
                "Welcome to the App...",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              image: SvgPicture.asset(
                "assets/images/welcome3.svg",
                height: 250,
              ))
        ],
        showSkipButton: true,
        skip: Text("Skip"),
        next: Icon(Icons.arrow_forward),
        done: Text("Done"),
        onDone: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
              (route) => false);
        },
        onSkip: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
              (route) => false);
        },
        dotsDecorator: DotsDecorator(
            color: ColorConstants.primaryBlack,
            size: Size.square(10),
            activeSize: Size(20, 10),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }
}
