import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_weather/src/model/weather.dart';
import 'package:meta/meta.dart';

import 'package:flutter_weather/src/bloc/weather_event.dart';
import 'package:flutter_weather/src/bloc/weather_state.dart';
import 'package:flutter_weather/src/repository/weather_repository.dart';
import 'package:flutter_weather/src/api/http_exception.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({@required this.weatherRepository}) : super(WeatherEmpty()) {
    on<FetchWeather>((event, emit) => this._onFetchWeather(event, emit));
  }

  void _onFetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final Weather weather = await weatherRepository.getWeather(event.cityName,
          latitude: event.latitude, longitude: event.longitude);
      emit(WeatherLoaded(weather: weather));
    } catch (exception) {
      print(exception);
      if (exception is HTTPException) {
        emit(WeatherError(errorCode: exception.code));
      } else {
        emit(WeatherError(errorCode: 500));
      }
    }
  }
}
