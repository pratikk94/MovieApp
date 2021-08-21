import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:movies_app/movie.dart';

//Stateful and stateless widget -> Main3.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies app',
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
      home: MyHomePage(title: 'Movies app'),
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

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
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
          // Here we take the value from the MyHomePage object that was created
          // by the App.build method, and use it to set our appbar title.
          title: Row(
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                    controller: myController,
                    cursorColor: Colors.white
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  //Spend time on stateful and stateless widget.
                  setState(() {
                    _getMovies(myController.text);
                  });

                },
                child: Text('TextButton'),


              )
            ],
          ),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getMovies(myController.text),
            builder: (BuildContext context,AsyncSnapshot snapshot){

              if(snapshot.data==null){
                return Container(
                  child: Text("No movies found"),
                );
              }


              return ListView.builder(
                // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     childAspectRatio: 0.75
                // ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context,int index){
                    return Container(
                      color: const Color(0xD3D3D3),
                      child: Column(
                        children: [
                          Row(
                              children: [
                                ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 160,
                                      minHeight: 160,
                                      maxWidth: 160,
                                      maxHeight: 160,
                                    ),

                                    child: Image.network("https://image.tmdb.org/t/p/w185/"+snapshot.data[index].posterPath, fit: BoxFit.contain)),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(snapshot.data[index].originalTitle,textAlign:TextAlign.start, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),maxLines: 1),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(snapshot.data[index].overview,textAlign:TextAlign.start, style: TextStyle(fontSize: 14),maxLines: 10),
                                      ),
                                    ],
                                  ),
                                ),

                              ]
                          ),
                          Divider(thickness: 5,)
                        ],
                      ),
                    );
                  }
              );
            },
          ),
        )
    );
  }

  Future<List<Movie>> _getMovies(String movieName) async{

    print("0 ->");
    var url = Uri.parse("https://api.themoviedb.org/3/search/movie?api_key=753d7942043deaba39f0e512331e2414&language=en-US&query="+movieName+"&page=1&include_adult=false");
    List<Movie> movies = [];

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      String data = response.body;
      var jsonData = jsonDecode(data);
      for (var i = 0; i < jsonData["results"].length; i++) {
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



    }
    return movies;

  }


}
