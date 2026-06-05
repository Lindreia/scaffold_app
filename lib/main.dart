import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class ScaffoldRequestForm extends StatefulWidget {
  const ScaffoldRequestForm({super.key});

  @override
  State<ScaffoldRequestForm> createState() => _ScaffoldRequestFormState();
}

class _ScaffoldRequestFormState extends State<ScaffoldRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _client = Supabase.instance.client;

  final _subcontractor = TextEditingController();
  final _contact = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _location = TextEditingController();
  final _type = TextEditingController();
  final _height = TextEditingController();
  final _capacity = TextEditingController();
  final _description = TextEditingController();

  DateTime? _dateRequired;
  DateTime? _removalDate;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _photos = [];

  bool loading = false;

  Future<void> _pickPhotos() async {
    final picked = await _picker.pickMultiImage();
    if (picked != null && picked.isNotEmpty) {
      setState(() => _photos.addAll(picked));
    }
  }

  Future<void> _uploadPhotos(String requestId) async {
    final storage = _client.storage.from('attachments');

    for (final photo in _photos) {
      final bytes = await photo.readAsBytes();
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${p.basename(photo.path)}";
      final path = "requests/$requestId/$fileName";

      await storage.uploadBinary(path, bytes);
      final url = storage.getPublicUrl(path);

      await _client.from('scaffold_attachments').insert({
        'request_id': requestId,
        'file_url': url,
        'file_type': 'photo',
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_dateRequired == null || _removalDate == null) {
      return _alert("Please select both Date Required and Removal Date");
    }

    if (_removalDate!.isBefore(_dateRequired!)) {
      return _alert("Removal date cannot be before required date");
    }

    setState(() => loading = true);

    try {
      final result = await _client
          .from('scaffold_requests')
          .insert({
            'subcontractor_name': _subcontractor.text,
            'contact_person': _contact.text,
            'phone': _phone.text,
            'email': _email.text,
            'location': _location.text,
            'scaffold_type': _type.text,
            'height': _height.text,
            'weight_capacity': _capacity.text,
            'description': _description.text,
            'date_required': _dateRequired!.toIso8601String(),
            'removal_date': _removalDate!.toIso8601String(),
          })
          .select()
          .single();

      final requestId = result['id'];

      if (_photos.isNotEmpty) {
        await _uploadPhotos(requestId);
      }

      _alert("Scaffold request submitted successfully");
      _resetForm();
    } catch (e) {
      _alert("Error submitting request: $e");
    }

    setState(() => loading = false);
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _photos = [];
      _dateRequired = null;
      _removalDate = null;
    });
  }

  void _alert(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Notice"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> _pickDateRequired() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dateRequired = picked);
  }

  Future<void> _pickRemovalDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateRequired ?? DateTime.now(),
      firstDate: _dateRequired ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _removalDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102A44),
        title: const Text("Submit Scaffold Request"),
      ),
      body: Stack(
        children: [
          _buildForm(),
          if (loading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _field("Subcontractor Name", _subcontractor),
            _field("Contact Person", _contact),
            _field("Phone", _phone),
            _field("Email", _email),
            _field("Location", _location),
            _field("Scaffold Type", _type),
            _field("Height", _height),
            _field("Weight Capacity", _capacity),
            _field("Description", _description, maxLines: 4),
            const SizedBox(height: 20),
            _dateTile("Date Required", _dateRequired, _pickDateRequired),
            const SizedBox(height: 12),
            _dateTile("Removal Date", _removalDate, _pickRemovalDate),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickPhotos,
              child: const Text("Add Photos"),
            ),
            if (_photos.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _photos.map((p) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.file(
                        File(p.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _submit,
                child: const Text("Submit Request"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _dateTile(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          date == null
              ? label
              : "$label: ${DateFormat('dd MMM yyyy').format(date)}",
        ),
      ),
    );
  }
}
