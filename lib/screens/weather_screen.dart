import 'dart:convert'; // for json.decode
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_2/constants.dart';
import 'package:weather_app_2/widget/additional_information.dart';
import 'package:weather_app_2/widget/hourly_forcast.dart';

import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityname = 'london';
    try {
      setState(() {
        isLoading = true;
      });
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openWeatherApiKey'));

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }

      return data;
    } catch (e) {
      throw 'Sorry, An unexpected error occured';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              getCurrentWeather();
            },
            icon: const Icon(
              Icons.refresh,
              size: 30,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'] - 273.15;
          final weatherCondition = data['list'][0]['weather'][0]['main'];
          final humidity = data['list'][0]['main']['humidity'];
          final pressure = data['list'][0]['main']['pressure'];
          final windSpeed = data['list'][0]['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '${currentTemp.toStringAsFixed(1)}°C',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                (weatherCondition == 'Clouds' ||
                                        weatherCondition == 'Rain')
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                weatherCondition,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < weatherForecastList.length - 1; i++)
                //         HourlyForecast(
                //           weatherIcon: (data['list'][1]['weather'][0]['main'] ==
                //                       'Clouds' ||
                //                   data['list'][1]['weather'][0]['main'] ==
                //                       'Rain')
                //               ? Icons.cloud
                //               : Icons.sunny,
                //           time: '00.00',
                //           weather:
                //               '${(data['list'][i + 1]['main']['temp'] - 273.15).toStringAsFixed(1)}°C',
                //         ),
                //     ],
                //   ),
                // ),

                SizedBox(
                  height: 150,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data['list'].length - 1,
                      itemBuilder: (context, index) {
                        final hours = data['list'][index + 1];
                        final hourlyForecasts = hours['main']['temp'];
                        final hourlySky = hours['weather'][0]['main'];

                        DateTime time = DateTime.parse(hours['dt_txt']);

                        return HourlyForecast(
                          time: DateFormat.j().format(time),
                          weatherIcon:
                              hourlySky == 'Clouds' || hourlySky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                          weather:
                              '${(hourlyForecasts - 273.15).toStringAsFixed(1)}°C',
                        );
                      }),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInformation(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      weatherValue: humidity.toString(),
                    ),
                    AdditionalInformation(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      weatherValue: windSpeed.toString(),
                    ),
                    AdditionalInformation(
                      icon: Icons.swap_vertical_circle_outlined,
                      label: 'Pressure',
                      weatherValue: pressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
