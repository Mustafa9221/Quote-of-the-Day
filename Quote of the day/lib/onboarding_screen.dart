import 'package:flutter/material.dart';
import './main.dart';

class Data {
  String img_path;
  String title;
  String description;
  Data(this.img_path, this.title, this.description);
}

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  // ignore: non_constant_identifier_names
  List<Data> PageData = [
    Data("assets/welcome.png", "WELCOME",
        "Welcome you will have two tabs one for Favorite Quotes and one for Quote of the day which Generates a random famous Quote of the day ,New Quote will be generated automatically each time you login into the App"),
    Data("assets/share.png", "SHARE",
        "Allow Users to share their Quote thorugh socail media by Clicking on the Share Button on the bottom right Corner"),
    Data("assets/like.png", "FAVORITE",
        "You can add your Favorite Quote to your Favorite Quote list and also you can view your Favorite Quotes anytime, User can also delete their Favorite Quote from the list"),
  ];
  int currentpage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 3,
        onPageChanged: (value) {
          currentpage = value;
          setState(() {});
        },
        itemBuilder: (context, index) {
          currentpage = index;
          return Page(PageData[index]);
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3 && currentpage != 2; i++)
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      height: 10,
                      width: i == currentpage ? 30 : 10,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
              ),
            if (currentpage == 2)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.amber,
                    child: TextButton(
                      onPressed: () {
                        sp.setInt("check", 2);
                        Navigator.pushNamed(context, "home");
                      },
                      child: const Text(
                        "GET STARTED",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Page extends StatelessWidget {
  Data data;
  Page(this.data, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(data.img_path),
        const SizedBox(
          height: 20,
        ),
        Text(
          data.title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
