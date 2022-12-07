import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/content_onboarding.dart';
import '../screens/permission_handler.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
      _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: 300.0,
                      ),
                      Text(
                        contents[i].title,
                        style: 
                          GoogleFonts.bebasNeue(
                            fontSize: 40,
                          ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        contents[i].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            contents.length,
            (index) => buildDot(index, context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.all(60),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                if(currentIndex == contents.length -1){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_)=> const PermissionHandler(),
                    ),
                  );
                }
                _controller?.nextPage(
                  duration: const Duration(milliseconds: 100), 
                  curve: Curves.bounceIn,
                );
              },
              child: Text(
                currentIndex == contents.length -1 ? "Continue": "Next",
                style: 
                  GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ), 
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 :10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
