class AirQuality {
  int aqi;
  String cityName;
  String? message;
  double? co; // Carbon Monoxide
  double? no2; // Nitrogen Dioxide
  double? so2; // Sulfur Dioxide
  double? o3; // Ozone
  double? pm25; // PM2.5
  double? pm10; // PM10
  String updateTime;

  AirQuality({
    required this.aqi,
    required this.cityName,
    this.message,
    this.co,
    this.no2,
    this.so2,
    this.o3,
    this.pm25,
    this.pm10,
    required this.updateTime,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    var iaqi = json['data']['iaqi'];
    return AirQuality(
      aqi: json['data']['aqi'] is int
          ? json['data']['aqi']
          : int.parse(json['data']['aqi']),
      cityName: json['data']['city']['name'] as String,
      co: iaqi['co']?['v']?.toDouble(),
      no2: iaqi['no2']?['v']?.toDouble(),
      so2: iaqi['so2']?['v']?.toDouble(),
      o3: iaqi['o3']?['v']?.toDouble(),
      pm25: iaqi['pm25']?['v']?.toDouble(),
      pm10: iaqi['pm10']?['v']?.toDouble(),
      updateTime: json['data']['time']['s'] as String,
    );
  }

  @override
  String toString() {
    return 'AirQuality(aqi: $aqi, cityName: $cityName, message: $message, '
        'co: ${co != null ? '$co mg/m³' : 'Unknown'}, '
        'no2: ${no2 != null ? '$no2 µg/m³' : 'Unknown'}, '
        'so2: ${so2 != null ? '$so2 µg/m³' : 'Unknown'}, '
        'o3: ${o3 != null ? '$o3 µg/m³' : 'Unknown'}, '
        'pm25: ${pm25 != null ? '$pm25 µg/m³' : 'Unknown'}, '
        'pm10: ${pm10 != null ? '$pm10 µg/m³' : 'Unknown'}, '
        'updateTime: $updateTime)';
  }
}
