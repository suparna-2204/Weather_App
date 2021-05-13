import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int temp;
  String city = 'Kolkata';
  int woeid = 2295386;
  String abbr = '';
  String error = '';

  String baseUrl =
      'https://www.metaweather.com/api/location/search/?query=';
  String locationUrl = 'https://www.metaweather.com/api/location/';

  initState() {
    super.initState();
    getWeather();
  }

  void search(String input) async {
    try {
      var response = await http.get(baseUrl + input);
      var result = json.decode(response.body)[0];

      setState(() {
        city = result["title"];
        woeid = result["woeid"];
        error = '';
      });
    } catch (e) {
      setState(() {
        error =
        "There is no city with this name";
      });
    }
  }

  void getWeather() async {
    var location = await http.get(locationUrl + woeid.toString());
    var result = json.decode(location.body);
    var consolidated_weather = result["consolidated_weather"];
    var data = consolidated_weather[0];

    setState(() {
      temp = data["the_temp"].round();
      abbr = data["weather_state_abbr"];
    });
  }

  void onSearch(String a) async {
    await search(a);
    await getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
          child: temp == null
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
            appBar: AppBar(
                title: Text('Flutter Weather App'),
                backgroundColor: Colors.blue
            ),
            backgroundColor: Colors.black,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        onSubmitted: (String input) {
                          onSearch(input);
                        },
                        style:
                        TextStyle(color: Colors.white, fontSize: 20),
                        decoration: InputDecoration(
                          hintText: 'Type a city',
                          hintStyle: TextStyle(
                              color: Colors.white, fontSize: 20),
                          prefixIcon:
                          Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(right: 30, left: 30),
                      child: Text(error,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red)),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        city,
                        style: TextStyle(
                            color: Colors.blue, fontSize: 50),
                      ),
                    ),
                    Center(
                      child: Image.network(
                        'https://www.metaweather.com/static/img/weather/png/' + abbr + '.png',
                        width: 100,
                      ),
                    ),
                    Center(
                      child: Text(
                        temp.toString() + '°C',
                        style: TextStyle(
                            color: Colors.blue, fontSize: 50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}