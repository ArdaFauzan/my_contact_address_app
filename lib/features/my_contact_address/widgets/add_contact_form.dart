import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_contact_address_app/core/utils/dialog_helper.dart';
import 'package:my_contact_address_app/core/widgets/custom_text_field.dart';
import 'package:my_contact_address_app/features/my_contact_address/repositories/contact_repository.dart';

class AddContactForm extends ConsumerStatefulWidget {
  const AddContactForm({super.key});

  @override
  ConsumerState<AddContactForm> createState() => _AddContactFormState();
}

class _AddContactFormState extends ConsumerState<AddContactForm> {
  // Key to identify and validate the form
  final _formKey = GlobalKey<FormState>();

  // State to track if the user has attempted to save (triggers auto-validation)
  bool _isAutoValidating = false;

  // Controllers to get the text/input from the TextField forms
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // State to show the loading indicator
  bool _isLoading = false;

  @override
  void dispose() {
    // REQUIRED: Clean up the controllers when the widget is destroyed (e.g., pop-up closed)
    // to prevent memory leaks and performance issues.
    // This is automatically called by Flutter, no need to call it manually.
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> handleSave() async {
    // Turn on auto-validation only after the user presses the save button for the first time
    setState(() {
      _isAutoValidating = true;
    });

    // First, check if the form data is valid according to the 'validator' rules.
    // If the form is invalid (e.g., empty required fields), stop the process and show errors.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; // Show the loading indicator
    });

    final newContact = {
      // Remember: use .text to get the string value (not the controller object)
      'name': _nameController.text,
      'address': _addressController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      // FieldValue.serverTimestamp() gets the highly accurate time directly from the Firebase server
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Saving process via Repository
    try {
      final repository = ref.read(contactRepositoryProvider);
      await repository.addContact(newContact);

      // Check if widget is still active/alive on the screen (due to the await delay above)
      // If the widget is not active, it means the pop-up dialog has been closed, so we don't need to do anything.
      // If you don't check this, you will get a runtime error because the widget is no longer active, and your apps will crash.
      // So we need to check if the widget is still mounted before updating the state.
      if (mounted) {
        // Show SnackBar success message using ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact added successfully')),
        );
        // Close the pop-up dialog
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        // Show SnackBar error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add contact. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Specific widget for creating pop-up dialogs
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final confirmExit = await DialogHelper.showConfirmation(context: context);
        if (confirmExit) {
          SystemNavigator.pop(); // Close app
        }
      },
      child: AlertDialog(
        title: const Text('Add New Contact'),
        // For scrollable content when keyboard appear
        content: SingleChildScrollView(
          // For Form validation and state management
          child: Form(
            key: _formKey,
            // Validation will only be active after the first save attempt
            autovalidateMode: _isAutoValidating
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(controller: _nameController, labelText: 'Name'),
                CustomTextField(
                  controller: _addressController,
                  labelText: 'Address',
                ),
                CustomTextField(
                  controller: _phoneController,
                  labelText: 'Phone',
                  isNumber: true, // For activate numpad keyboard
                ),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                ),
              ],
            ),
          ),
          // Allows the form area to be scrolled when the phone keyboard appears
        ),
        actions: [
          TextButton(
            // Plain text button (no background/shadow) for secondary actions (Cancel)
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            // Button with background color & shadow for primary actions (Save)
            onPressed: _isLoading
                ? null
                : handleSave, // Disable button while loading is in progress
            child: _isLoading
                ? const SizedBox(
                    // Empty box to enforce a specific size (so the loading spinner fits perfectly)
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
