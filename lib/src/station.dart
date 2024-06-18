class Station {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  Station({required this.id, required this.name, required this.latitude, required this.longitude});
}

List<Station> stations = [
  Station(id: 1, name: "Station 1", latitude: 6.8566, longitude: 2.3522),
  Station(id: 2, name: "Station 2", latitude: 6.358844, longitude: 2.294351),
  Station(id: 3, name: "Station 3", latitude: 6.3566, longitude: 2.3622),
  Station(id: 4, name: "Station 4", latitude: 6.3666, longitude: 2.3522),
  Station(id: 5, name: "Station 5", latitude: 6.3466, longitude: 2.3522),
  Station(id: 6, name: "Station 6", latitude: 6.8566, longitude: 2.3422),
];
