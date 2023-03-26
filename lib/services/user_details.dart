class UserDetails {
  String firstName;
  String lastName;
  String phone;
  String email;
  String upiId;
  int balance;

  UserDetails(
      {this.firstName = '',
      required this.lastName,
      required this.email,
      required this.phone,
      required this.upiId,
      required this.balance});

  static UserDetails currentUser = UserDetails(lastName: '', email: '', phone: '', upiId: '', balance: 0);
}
