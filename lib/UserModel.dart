
class User {
  final String name;
  final String company;
  final String address;
  final String gstin;
  final String pin;
  final String email;
  final String contact;
  final int id;

  User(
      {this.id,
      this.name,
      this.company,
      this.address,
      this.gstin,
      this.pin,
      this.email,
      this.contact});

  Map<String, dynamic> serialize() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'address': address,
      'gstin': gstin,
      'pin': pin,
      'email': email,
      'contact': contact
    };
  }

  @override
  String toString() {
    return "User{id:$id,name:$name,company:$company,address:$address,gstin:$gstin,pin:$pin,email:$email,contact:$contact}";
  }
}
