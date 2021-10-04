import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getWeather();
  }

  String cityName = 'London'; //Default City

  final TextEditingController _controller = TextEditingController();

  var temp = '80';
  var description = 'Mostly cloudy';
  var mainWeather = 'Rain';
  var humidity = '80';
  var windSpeed = '0.50';
  var clouds = '65';//These values will change after changing the location
  
  Future getWeather() async {
    //Getting Weather information from api
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid={Your Api Key here}'); //Sign in to openweathermap.org then get your api key
    final weather = await http.get(url);
    final response = json.decode(weather.body);

    setState(() {
      temp = response['main']['temp'].toString();
      description = response['weather'][0]['description'];
      mainWeather = response['weather'][0]['main'];
      humidity = response['main']['humidity'].toString();
      windSpeed = response['wind']['speed'].toString();
      clouds = response['clouds']['all'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 8),
                color: Colors.blue.shade400,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 8, left: 10),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 25),
                        SizedBox(
                          width: 200,
                          height: 70,
                          child: TextField(
                            controller: _controller,
                            onChanged: (value) {
                              cityName = value;
                              getWeather();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Enter city name',
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 20),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, right: 10),
                      child: Icon(
                        Icons.more_vert_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.lightBlue, Colors.blue, Colors.blueAccent],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    SizedBox(
                      height: 220,
                      child: mainWeather == 'Rain'
                          ? const Rain()
                          : mainWeather == 'Clear'
                              ? const Clear()
                              : mainWeather == 'Haze'
                                  ? const Haze()
                                  : const DefaultWeather(), //display image according to Weather
                    ),
                    Text(
                      temp.toString() + '\u00B0',  // u00B0 is unicode for degree symbol
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Location: " + cityName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Column(
                children: [
                  MainWeather(mainWeather: mainWeather),
                  Clouds(clouds: clouds),
                  Humidity(humidity: humidity),
                  WindSpeed(windSpeed: windSpeed)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WindSpeed extends StatelessWidget {
  const WindSpeed({
    Key? key,
    required this.windSpeed,
  }) : super(key: key);

  final String windSpeed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  height: 40,
                  width: 40,
                  child:
                      Image.asset('assets/images/wind.png', fit: BoxFit.cover)),
              const SizedBox(
                width: 20,
              ),
              const Text('Wind Speed',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Text(windSpeed,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class Rain extends StatelessWidget {
  const Rain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      child: Image.asset(
        'assets/images/rainy.png',
        height: 300,
        width: 300,
      ),
      opacity: 0.6,
      color: Colors.black,
      offset: const Offset(5, 5),
      sigma: 7,
    );
  }
}

class Haze extends StatelessWidget {
  const Haze({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      child: Image.asset(
        'assets/images/thunderStrom.png',
        height: 300,
        width: 300,
      ),
      opacity: 0.6,
      color: Colors.black,
      offset: const Offset(5, 5),
      sigma: 7, // Default: 2
    );
  }
}

class Clear extends StatelessWidget {
  const Clear({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      child: Image.asset(
        'assets/images/sun.png',
        height: 220,
        width: 220,
      ),
      opacity: 0.6,
      color: Colors.black,
      offset: const Offset(5, 5),
      sigma: 7, // Default: 2
    );
  }
}

class DefaultWeather extends StatelessWidget {
  const DefaultWeather({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      child: Image.asset(
        'assets/images/defaultWeather.png',
        height: 220,
        width: 220,
      ),
      opacity: 0.6,
      color: Colors.black,
      offset: const Offset(5, 5),
      sigma: 7, // Default: 2
    );
  }
}

class Humidity extends StatelessWidget {
  const Humidity({
    Key? key,
    required this.humidity,
  }) : super(key: key);

  final String humidity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset('assets/images/humidity.png',
                      fit: BoxFit.cover)),
              const SizedBox(
                width: 20,
              ),
              const Text('Humidity',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Text(humidity,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class Clouds extends StatelessWidget {
  const Clouds({
    Key? key,
    required this.clouds,
  }) : super(key: key);

  final String clouds;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset('assets/images/clouds.png',
                      fit: BoxFit.cover)),
              const SizedBox(
                width: 20,
              ),
              const Text('Clouds',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Text(clouds,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class MainWeather extends StatelessWidget {
  const MainWeather({
    Key? key,
    required this.mainWeather,
  }) : super(key: key);

  final String mainWeather;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset('assets/images/weather.png',
                      fit: BoxFit.cover)),
              const SizedBox(
                width: 20,
              ),
              const Text('Weather',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          Text(mainWeather,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
