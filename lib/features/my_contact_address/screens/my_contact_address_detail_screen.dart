import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_contact_address_app/core/utils/dialog_helper.dart';
import 'package:my_contact_address_app/features/my_contact_address/models/my_contact_address_model.dart';

class MyContactAddressDetailScreen extends StatefulWidget {
  // 1. Prepare to receive data
  final MyContactAddressModel contact;

  // 2. Required this screen to receive data when called
  const MyContactAddressDetailScreen({super.key, required this.contact});

  @override
  State<MyContactAddressDetailScreen> createState() =>
      _MyContactAddressDetailScreenState();
}

class _MyContactAddressDetailScreenState
    extends State<MyContactAddressDetailScreen> {
  // Switch for PopScope
  bool _canPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop, // Switch for PopScope
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final confirmExit = await DialogHelper.showConfirmation(context: context);
        if (confirmExit) {
          SystemNavigator.pop(); // Close app
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detail Contact"),
          backgroundColor: Colors.greenAccent,

          // Custom back button
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // 1. Open PopScope switch (allow exit)
              setState(() {
                _canPop = true;
              });

              // 2. Give Flutter a millisecond to read the open switch, then force exit!
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) Navigator.pop(context);
              });
            },
          ),
          automaticallyImplyLeading: false, // Disable automatic back button
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3. Display the data to UI (because StatefulWidget, we must use 'widget.')
              Text(
                "Name: ${widget.contact.name}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Phone: ${widget.contact.phone}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Email: ${widget.contact.email}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Address: ${widget.contact.address}",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
