class MyContactAddressModel {
  // Properties of the contact model
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final DateTime createdAt;
  final DateTime updateAt;

  // Constructor
  const MyContactAddressModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.updateAt,
  });

  // Factory method to create a model instance from Firestore data (Map)
  factory MyContactAddressModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return MyContactAddressModel(
      id: documentId,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'] != null
          ? map['createdAt'].toDate()
          : DateTime.now(),
      updateAt: map['updateAt'] != null
          ? map['updateAt'].toDate()
          : DateTime.now(),
    );
  }

  // Method to convert the model back into a Map (for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'createdAt': createdAt,
      'updateAt': updateAt,
    };
  }
}
