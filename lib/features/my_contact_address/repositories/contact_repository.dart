import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_contact_address_app/features/my_contact_address/data/contacts.dart';

class ContactRepository {
  final FirebaseFirestore _firestore;

  // Constructor: allow passing an instance, or default to standard instance
  ContactRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Get stream of contacts for the UI
  Stream<QuerySnapshot> getContactsStream() {
    return _firestore
        .collection(collectionName)
        .orderBy(orderBy, descending: isOrderDescending)
        .snapshots();
  }

  // Add a new contact to Firestore
  Future<void> addContact(Map<String, dynamic> contactData) async {
    await _firestore.collection(collectionName).add(contactData);
  }
}

// Riverpod Providers
// Basic provider to provide access to ContactRepository
final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  return ContactRepository();
});

// StreamProvider to monitor the stream of contacts from Firestore in real-time
final contactsStreamProvider = StreamProvider<QuerySnapshot>((ref) {
  // Get the stream of contacts from the repository
  final repository = ref.watch(contactRepositoryProvider);
  // Return the stream of contacts
  return repository.getContactsStream();
});
