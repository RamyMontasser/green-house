class SensorModel {
  final double temp;
  final double humidity;
  final int soil;
  final int light;
  final bool? isEnabled;

  SensorModel({
    required this.temp,
    required this.humidity,
    required this.soil,
    required this.light,
    this.isEnabled,
  });

  factory SensorModel.fromJson(Map<String, dynamic> data) {
    return SensorModel(
      temp: (data['temperature'] as num).toDouble(),
      humidity: (data['humidity'] as num).toDouble(),
      soil: data['soilMoisture'],
      light: data['lightDependentResistor'],
      isEnabled: data['enabled'],
    );
  }

  factory SensorModel.fromThresholdJson(Map<String, dynamic> data) {
    return SensorModel(
      temp: (data['tempThreshold'] as num).toDouble(),
      humidity: (data['humidityThreshold'] as num).toDouble(),
      soil: data['soilMoistureThreshold'],
      light: data['lightThreshold'],
      isEnabled: data['enabled'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      "temperature": temp,
      "humidity": humidity,
      "soilMoisture": soil,
      "lightDependentResistor": light,
      if (isEnabled != null) "enabled": isEnabled,
    };
  }
}
