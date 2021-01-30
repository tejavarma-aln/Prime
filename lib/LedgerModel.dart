class Ledger {
  final int id;
  final String name;
  final String ledParent;
  final String address;
  final String state;
  final String country;
  final String pin;
  final String contact;
  final String email;
  final String gstin;

  Ledger({this.id, this.name, this.ledParent, this.address, this.state, this.country,
      this.pin, this.contact, this.email, this.gstin});

  Map<String, dynamic> serialize() {
    return {
      'id': id,
      'name': name,
      'ledParent': ledParent,
      'address': address,
      'state': state,
      'country': country,
      'pin': pin,
      'contact': contact,
      'email': email,
      'gstin': gstin
    };
  }

  @override
  String toString() {
    return "Ledger{id:$id,name:$name,ledParent:$ledParent,address:$address,state:$state,country:$country,pin:$pin,contact:$contact,email:$email,gstin:$gstin}";
  }
}
