import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:movies_app/movie.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getMovies(),
            builder: (BuildContext context,AsyncSnapshot snapshot){

              if(snapshot.data==null){
                return Container(
                  child: Text("No movies found"),
                );
              }


              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context,int index){
                    return ListTile(
                      title: Text(snapshot.data[index].originalTitle),
                    );
                  }
              );
            },
          ),
        )
    );
  }

  Future<List<Movie>> _getMovies() async{

    print("0 ->");
    var url = Uri.parse("https://api.themoviedb.org/3/search/movie?api_key=753d7942043deaba39f0e512331e2414&language=en-US&query=Avengers&page=1&include_adult=false");
    List<Movie> movies = [];

    http.Response response = await http.get(url);

    print("1 ->"+response.statusCode.toString());


    if (response.statusCode == 200) {
      String data = response.body;
      var jsonData = jsonDecode(data);
      print("2- > " + jsonData["results"].length.toString());

      print("Movie" + jsonData["results"][0].toString());
      for (var i = 0; i < jsonData["results"].length; i++) {
        print(jsonData["results"][i]["id"].toString());

        print(jsonData["results"][i]["backdrop_path"].toString());
        print(jsonData["results"][i]["id"].toString());
        print(jsonData["results"][i]["title"].toString());
        print(jsonData["results"][i]["overview"].toString());
        print(jsonData["results"][i]["poster_path"].toString());
        print(i);
        if(jsonData["results"][i]["id"]!=null) {
          Movie m = Movie(
              jsonData["results"][i]["backdrop_path"].toString(),
              jsonData["results"][i]["id"].toString(),
              jsonData["results"][i]["title"].toString(),
              jsonData["results"][i]["overview"].toString(),
              jsonData["results"][i]["poster_path"].toString());
          movies.add(m);
        }
      }


      print("Movie length" + movies.length.toString());

    }
    return movies;

  }


}
