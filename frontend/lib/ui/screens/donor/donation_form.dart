import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:giving_bridge/models/donation.dart';
import 'package:giving_bridge/services/donation_service.dart';
import 'package:giving_bridge/ui/widgets/custom_text_field.dart';
import 'package:giving_bridge/ui/widgets/primary_button.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DonationForm extends StatefulWidget {
  final Donation? donation; // Null for new donations, non-null for editing
  const DonationForm({super.key, this.donation});

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DonationCategory _selectedCategory;
  bool _isLoading = false;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.donation?.title);
    _descriptionController =
        TextEditingController(text: widget.donation?.description);
    _selectedCategory = DonationCategory.values.firstWhere(
      (c) =>
          c.toString().split('.').last ==
          (widget.donation?.category ?? 'other'),
      orElse: () => DonationCategory.other,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final donationService = context.read<DonationService>();
    bool success;

    File? image;
    if (_imageFile != null) {
      image = File(_imageFile!.path);
    }

    if (widget.donation == null) {
      // Create new donation
      success = await donationService.createDonation(
        CreateDonationRequest(
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory.toString().split('.').last,
        ),
        image: image,
      );
    } else {
      // Update existing donation (note: image update is not handled here)
      success = await donationService.updateDonation(
        widget.donation!.id,
        UpdateDonationRequest(
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory.toString().split('.').last,
        ),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pop(); // Close the modal
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(donationService.error ?? 'An error occurred.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.donation == null ? 'إضافة تبرع جديد' : 'تعديل التبرع',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildImagePicker(),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _titleController,
              labelText: 'عنوان التبرع',
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              labelText: 'الوصف',
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DonationCategory>(
              value: _selectedCategory,
              onChanged: (DonationCategory? newValue) {
                if (newValue != null) {
                  setState(() => _selectedCategory = newValue);
                }
              },
              items: DonationCategory.values.map((DonationCategory category) {
                return DropdownMenuItem<DonationCategory>(
                  value: category,
                  child: Text(category.toString().split('.').last),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: 'الفئة'),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: _submit,
              text: widget.donation == null ? 'إضافة' : 'حفظ التغييرات',
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _imageFile != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_imageFile!.path),
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Text(
                    'No Image Selected',
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text('Select Image'),
        ),
      ],
    );
  }
}
