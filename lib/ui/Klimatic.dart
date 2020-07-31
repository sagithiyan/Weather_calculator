import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/utils.dart' as util;

class Klimatic extends StatefulWidget {
  @override
   _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async{
    Map results =await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder:(BuildContext context){
        return new ChangeCity();
      } )
    );
    if (results !=null && results.containsKey('enter')){
      _cityEntered = results['enter'];
      //print(results['enter'].toString());
    }
  }
  void showStuff() async{
    Map data = await getWeather(util.appId, util.deafaultCity);
    print(data.toString());
  }
  @override

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Weather Calculator'),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: (){_goToNextScreen(context);})
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/wj.jpg',
            width:500.0,
            height: 1200.0,
            fit: BoxFit.fill,),
          ),
          new Container(
            alignment: Alignment.topRight,
              margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
              child: new Text(
                '${_cityEntered==null ? util.deafaultCity : _cityEntered}',
              style: cityStyle(),),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
            width: 65.0,
          ),
          //container which will have our weather data
          new Container(
            margin: const EdgeInsets.fromLTRB(50.0, 295.0, 10.0, 0.0),
            child:updateTempWidget(_cityEntered),

          )

        ],
      ),
    );
  }

  Future<Map> getWeather(String appId,String city)async {
    String apiUrl='http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.appId}&units=metric';


    http.Response response =await http.get(apiUrl);

    return json.decode(response.body);


  }
  Widget updateTempWidget(String city){
    return new FutureBuilder(
      future: getWeather(util.appId, city==null ?util.deafaultCity:city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        //where we get alll of the json data,we setup widgets etc.
          if (snapshot.hasData){
            Map content = snapshot.data;
            return new Container(

              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(content['main']['temp'].toString() +"°C ",
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 65.9,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                    ),),
                    subtitle: new ListTile(
                      title: new Text(
                         "Humidity:${content['main']['humidity'].toString()}\n"
                             "Min:${content['main']['temp_min'].toString()} °C \n"
                             "Max:${content['main']['temp_max'].toString()} °C ",

                      style: extraData(),

                      ),
                    ),
                  )
                ],
              ),
            );

          }else {
            return new Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: new Text('Change City'),
        centerTitle: true,

      ),
      body: new Stack(
        children: <Widget>[
     new Center(
       child: new Image.asset('images/edit.jpg',
       width: 490.0,
         height: 1200.0,
         fit: BoxFit.fill,
       ),
     ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,

                ),

              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'enter':_cityFieldController.text
                      });
                    },
                    textColor: Colors.white70,
                    color: Colors.black,
                    child: new Text('View Weather')),
              )
            ],
          )

        ],
      ),
    );
  }
}

TextStyle extraData(){
  return new TextStyle(
      color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 20.0,

  );
}

TextStyle cityStyle(){

  return new TextStyle(
    color: Colors.white,
    fontSize: 35.9,
    fontStyle: FontStyle.italic
  );
}

TextStyle tempStyle(){
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 55.0
  );
}