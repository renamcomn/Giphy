import 'dart:convert';
import 'GifScreen.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override

  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    if(_search == null) {
      response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=d8ZN8nrAMrUXjKF4CrCo0SLG7bKCpQkg&limit=20&rating=G');
    } else {
      response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=d8ZN8nrAMrUXjKF4CrCo0SLG7bKCpQkg&q=$_search&limit=20&offset=$_offset&rating=G&lang=en');
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset('assets/images/header-logo.gif'),
        centerTitle: true,
      ),
        backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquisar Aqui!",
                  labelStyle: TextStyle(color: Colors.white,),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            )
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00ff99)),
                          strokeWidth: 5.0,
                        )
                      );
                  default:
                    if(snapshot.hasError) return Container(width: 0, height: 0,);
                    else return _createGiftTable(context, snapshot);
                }
              }
            ),
          )
        ],
      )
    );
  }

  Widget _createGiftTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
        itemCount: snapshot.data["data"].length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height_small"]["url"],
                height: 300.0,
                fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GifScreen(snapshot.data["data"][index]))
              );
            },
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height_small"]["url"]);
            },
          );
        }
    );
  }

}
