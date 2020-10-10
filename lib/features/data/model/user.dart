class User {
  final String id;
  final String firstName;
  final String lastName;

  const User({this.id, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName']
    );
  }
}
