import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_contact_address_app/core/utils/dialog_helper.dart';
import 'package:my_contact_address_app/features/my_contact_address/models/my_contact_address_model.dart';
import 'package:my_contact_address_app/features/my_contact_address/repositories/contact_repository.dart';
import 'package:my_contact_address_app/features/my_contact_address/screens/my_contact_address_detail_screen.dart';
import 'package:my_contact_address_app/features/my_contact_address/widgets/add_contact_form.dart';

class MyContactAddressScreen extends ConsumerWidget {
  const MyContactAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the stream provider from Riverpod
    final contactsStream = ref.watch(contactsStreamProvider);

    return PopScope(
      canPop:
          false, // If false, it will disable the auto close pop-up. If true, it will enable the auto close pop-up.
      onPopInvokedWithResult: (didPop, result) async {
        // This will exit if the pop is successful (e.g. navigating back)
        if (didPop) return;

        // Call the reusable confirmation dialog
        final confirmExit = await DialogHelper.showConfirmation(context: context);
        if (confirmExit) {
          SystemNavigator.pop(); // Close app if user chooses 'Yes'
        }
      },
      child: Scaffold(
        // Top app bar section
        appBar: AppBar(
          title: const Text("My Contact Address"),
          backgroundColor: Colors.greenAccent,
        ),
        // StreamBuilder listens to real-time updates via Repository
        body: contactsStream.when(
          data: (snapshot) {
            final data = snapshot.docs;

            // Handle Empty Data
            if (data.isEmpty) {
              return const Center(
                child: Text(
                  "No contact address found. Try adding one.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            // View if state success
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final doc = data[index];
                final mapData = doc.data() as Map<String, dynamic>;

                // Parsing raw data from Firebase to Model
                final contact = MyContactAddressModel.fromMap(mapData, doc.id);

                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyContactAddressDetailScreen(contact: contact),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              const Center(child: Text('Failed to load data')),
        ),
        // Floating button at the bottom right to add new contacts
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show the AddContactForm inside a dialog pop-up
            showDialog(
              context: context,
              builder: (context) => const AddContactForm(),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
