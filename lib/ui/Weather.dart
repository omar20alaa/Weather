import 'package:weather/util/utils.dart' as util;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {

  String city_entered;

  Future goToNextScreen(BuildContext context) async
  {
    Map result = await Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context) {
          return new changeCity();
      }));

    if (result != null && result.containsKey('enter'))
      {
        print(result['enter'].toString());
        city_entered = result['enter'];
      }
  }

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Weather'),
        backgroundColor: Colors.blueAccent.shade700,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () {goToNextScreen(context);},
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/weather.jpg',
              width: 490.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.90),
            child: new Text(
              '${city_entered == null ? util.defaultCity : city_entered}',
              style: cityStyle(),
            ),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 310.0, 0.0, 0.0),
            child: updateTempWidget(city_entered)
          )
        ],
      ),
    );
  }
}

Future<Map> getWeather(String appId, String city) async {
  String apiUrl =
      'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
      '${util.appId}&units=imperial';
  http.Response response = await http.get(apiUrl);
  return jsonDecode(response.body);
}


Widget updateTempWidget(String city){
    return new FutureBuilder(
      future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot)
      {
          if(snapshot.hasData)
            {
              Map content = snapshot.data;
              return new Container(
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text(
                          content['main']['temp'].toString() + " F",
                      style: new TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 49.9,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                      ),

                      subtitle: new ListTile(
                        title: new Text(
                          "Humidity: ${content['main']['humidity'].toString()}\n"
                              "Min:  ${content['main']['temp_min'].toString()}F\n"
                              "Max:  ${content['main']['temp_max'].toString()} F ",
                          style: extraData(),
                        ),
                      ),

                    )
                  ],
                ),
              );
            }
          else
            {
              return new Container();
            }
      });
}

class changeCity extends StatelessWidget{

  var city_field_controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/weather.jpg',
                width: 490.0,
                fit: BoxFit.fill
            ),
          ),

          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: city_field_controller,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  onPressed: (){
                    Navigator.pop(context , {
                      'enter' : city_field_controller.text
                    });
                  },
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                  child: new Text('Get Weather'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.black87,
      fontSize: 49.9,
      fontStyle: FontStyle.normal);
}

TextStyle extraData() {
  return new TextStyle(
    color: Colors.white70,
    fontSize: 17.9,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}


TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 49.9,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}
