import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './onboarding_screen.dart';

late SharedPreferences sp;
late var check;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  check = await sp.getInt("check");
  print(check);
  Response response =
      await get(Uri.parse("https://api.quotable.io/quotes/random"));
  var data = jsonDecode(response.body);
  List info = data.toList();
  String author = info[0]["author"].toString();
  String quote = info[0]["content"].toString();
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    // ignore: unrelated_type_equality_checks

    initialRoute: check == 1 ? "Onboard" : "home",
    routes: {
      "Onboard": (context) => OnBoard(),
      "home": (context) => DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Quotes'),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Quote of the day'),
                    Tab(text: 'Favorites'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  QuoteTab(author, quote),
                  FavoriteTab(),
                ],
              ),
            ),
          )
    },
  ));
}

// ignore: must_be_immutable
class QuoteTab extends StatefulWidget {
  late String author, quote;
  QuoteTab(author, quote) {
    this.author = author;
    this.quote = quote;
  }
  @override
  State<QuoteTab> createState() => _QuoteTabState();
}

class _QuoteTabState extends State<QuoteTab> {
  List<String> data = [];
  int setbutton = 0;
  void savedata() async {
    await sp.setStringList("quotes", data);
  }

  void getsharedpref() async {
    data = sp.getStringList("quotes")!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsharedpref();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.author,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.quote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.topLeft,
          child: Row(children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () async {
                      if (setbutton == 0) {
                        data.insert(0, "${widget.quote} by ${widget.author}");
                        savedata();
                        setbutton = 1;
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      setbutton == 0
                          ? Icons.favorite_border_outlined
                          : Icons.favorite_rounded,
                      color: setbutton == 0 ? Colors.white : Colors.red,
                      size: 40,
                    )),
              ),
            ),
            IconButton(
                onPressed: () async {
                  await Share.share(widget.quote);
                },
                icon: Icon(
                  Icons.share,
                  size: 40,
                )),
          ]),
        ),
      ],
    );
  }
}

class FavoriteTab extends StatefulWidget {
  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  List<String> quotes = [];
  Future getdata() async {
    quotes = sp.getStringList("quotes")!;
  }

  void savedata() async {
    await sp.setStringList("quotes", quotes);
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return quotes.length == 0
        ? Center(
            child: Text(
              "NO FAVORITES",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          )
        : ListView.builder(
            itemCount: (quotes.length),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: Column(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.blueGrey.shade800,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                quotes[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.center,
                            onPressed: () {
                              quotes.removeAt(index);
                              savedata();
                              getdata();
                              setState(() {});
                            },
                            icon: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  )
                ]),
              );
            },
          );
  }
}
