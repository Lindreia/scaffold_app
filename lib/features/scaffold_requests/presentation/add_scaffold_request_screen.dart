import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddScaffoldRequestScreen extends StatefulWidget {
  AddScaffoldRequestScreen({super.key});

  @override
  State<AddScaffoldRequestScreen> createState() =>
      _AddScaffoldRequestScreenState();
}

class _AddScaffoldRequestScreenState extends State<AddScaffoldRequestScreen> {
  final _client = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();

  final _subcontractor = TextEditingController();
  final _location = TextEditingController();
  final _type = TextEditingController();
  final _height = TextEditingController();
  final _capacity = TextEditingController();
  final _contact = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _description = TextEditingController();

  DateTime? _dateRequired;
  DateTime? _removalDate;

  Future<void> _pickDate(Function(DateTime) setter) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setter(picked);
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _client.auth.currentUser;

    await _client.from('scaffold_requests').insert({
      'subcontractor_name': _subcontractor.text,
      'location': _location.text,
      'scaffold_type': _type.text,
      'height': _height.text,
      'weight_capacity': _capacity.text,
      'contact_person': _contact.text,
      'phone': _phone.text,
      'email': _email.text,
      'description': _description.text,
      'date_required': _dateRequired?.toIso8601String(),
      'removal_date': _removalDate?.toIso8601String(),
      'created_by': user?.id,
      'status': 'pending',
    });

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER IMAGE RIBBON
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/blueprint_scaffold.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(24),
              color: Colors.black.withOpacity(0.4),
              child: Text(
                "Add Scaffold Request",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // WHITE CONTENT AREA
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _field("Subcontractor Name", _subcontractor),
                    _field("Location", _location),
                    _field("Scaffold Type", _type),
                    _field("Height", _height),
                    _field("Weight Capacity", _capacity),
                    _field("Contact Person", _contact),
                    _field("Phone", _phone),
                    _field("Email", _email),
                    _field("Description", _description, maxLines: 3),

                    SizedBox(height: 20),

                    _datePicker(
                      label: "Date Required",
                      value: _dateRequired,
                      onPick: () => _pickDate((d) => _dateRequired = d),
                    ),

                    SizedBox(height: 12),

                    _datePicker(
                      label: "Removal Date",
                      value: _removalDate,
                      onPick: () => _pickDate((d) => _removalDate = d),
                    ),

                    SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade800,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Submit Request",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _datePicker({
    required String label,
    required DateTime? value,
    required VoidCallback onPick,
  }) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value == null
              ? "$label: Select Date"
              : "$label: ${value.day}/${value.month}/${value.year}",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
