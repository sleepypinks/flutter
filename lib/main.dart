import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Studio - Flutter',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // A widget which will be started on application startup
      home: MyHomePage(title: 'Space Space for Doggos ❤️'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // The title text which will be shown on the action bar
          title: Text(title),
        ),
        body: Column(children: [CatButton()]));
  }
}

class MenuItem extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  const MenuItem(
      {Key? key,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(imageUrl),
          Text(name),
          Text(description),
          Text(price),
          SizedBox(height: 50),
        ]);
  }
}

class CatButton extends StatefulWidget {
  State<CatButton> createState() => CreateCatButton();
}

class CreateCatButton extends State<CatButton> {
  bool clickedState = false;
  String imageUrl = "";
  String buttonCaption = "Which Doggo Are You? Click to find out!";
  //final String buttonCaption = "Which Cat 🐱 Are You? Click to find out!";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              getCat(http.Client());
            },
            child: Text(buttonCaption),
          ),
          if (clickedState) Image.network(imageUrl),
        ],
      ),
    );
  }

//I tried so much to run this for cats but my request kept throwing an error! :(
//So, I watched did the studio with people from the studio!
  void getCat(http.Client client) async {
    final response =
        await client.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    //var statusCodes = [100, 101, 200, 205]
    //final _random = new Random();
    //var element = list[_random.nextInt(list.length)];
    //var url = 'https://http.cat/' + '$element'
    //await client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        clickedState = true;
        final parsed = jsonDecode(response.body);
        imageUrl = parsed['message'].toString();
        buttonCaption = "Here's your doggo. Try again for more!";
      });
    } else {
      clickedState = false;
      buttonCaption = "We failed to load your doggo. Try again :(!";
      throw Exception('Failed to load doggo');
    }
  }
}
