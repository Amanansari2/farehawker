class GroupBooking {
  final int direction;
  final String groupBooking;
  final String origin;
  final String destination;
  final String depDate;
  final String retDate;
  final String adult;
  final String child;
  final String infant;
  final String contactNumber;
  final String contactEmail;

  GroupBooking({
    required this.direction,
    required this.groupBooking,
    required this.origin,
    required this.destination,
    required this.depDate,
    required this.retDate,
    required this.adult,
    required this.child,
    required this.infant,
    required this.contactNumber,
    required this.contactEmail,
  });

  Map<String, dynamic> toJson() {
    return {
      'direction': direction,
      'group_booking': groupBooking,
      'origin': origin,
      'destination': destination,
      'dep_date': depDate,
      'ret_date': retDate,
      'adult': adult,
      'child': child,
      'infant': infant,
      'c_num': contactNumber,
      'c_email': contactEmail,
    };
  }
  factory GroupBooking.fromJson(Map<String, dynamic> json) {
    return GroupBooking(
      direction: json['direction'],
      groupBooking: json['group_booking'],
      origin: json['origin'],
      destination: json['destination'],
      depDate: json['dep_date'],
      retDate: json['ret_date'],
      adult: json['adult'],
      child: json['child'],
      infant: json['infant'],
      contactNumber: json['c_num'],
      contactEmail: json['c_email'],
    );
  }
}
