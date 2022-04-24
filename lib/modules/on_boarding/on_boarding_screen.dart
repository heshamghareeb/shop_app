import 'package:flutter/material.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/styles/colors.dart';
import '../login/login_screen.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _boardController = PageController();

  final List<BoardingModel> boarding = [
    BoardingModel(
        image: 'assets/images/on_board1.jpg',
        title: 'OnBoarding1 Title',
        body: 'OnBoarding1 body'),
    BoardingModel(
        image: 'assets/images/on_board1.jpg',
        title: 'OnBoarding2 Title',
        body: 'OnBoarding2 body'),
    BoardingModel(
        image: 'assets/images/on_board1.jpg',
        title: 'OnBoarding3 Title',
        body: 'OnBoarding3 body'),
  ];

  bool isLast = false;

  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value!)navigateAndFinish(context, LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            text: 'SKIP',
            function: submit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _boardController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(height: 40),
            Row(children: [
              SmoothPageIndicator(
                controller: _boardController,
                count: boarding.length,
                effect: const ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: defaultColor,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5),
              ),
              const Spacer(),
              FloatingActionButton(
                onPressed: () {
                  if (isLast) {
                    submit();
                  } else {
                    _boardController.nextPage(
                        duration: const Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn);
                  }
                },
                child: const Icon(Icons.arrow_forward_ios),
              )
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Image.asset(model.image)),
      const SizedBox(height: 30),
      Text(model.title, style: const TextStyle(fontSize: 24)),
      const SizedBox(height: 15),
      Text(model.body, style: const TextStyle(fontSize: 14)),
      const SizedBox(height: 30),
    ]);
  }
}
