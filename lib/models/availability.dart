class RoomAvailability {
  String roomName, bedNumber;
  bool available;

  RoomAvailability({required this.bedNumber, required this.roomName, required this.available});

  factory RoomAvailability.fromMap(Map<String, dynamic> map) {
    return RoomAvailability(
        bedNumber: map['bedNumber'], available: map['available'], roomName: map['roomName']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'bedNumber': bedNumber, 'available': available,'roomName': roomName};
    return map;
  }
}
