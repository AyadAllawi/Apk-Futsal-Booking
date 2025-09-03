// add_field_screen.dart
import 'package:flutter/material.dart';
import 'package:futsal_booking/model/lapangan/field_model.dart';
import 'package:futsal_booking/services/lapangan/field_services.dart';

class AddFieldScreen extends StatefulWidget {
  final Function onFieldAdded;
  final Field? field; // jika edit, kirim data existing

  const AddFieldScreen({super.key, required this.onFieldAdded, this.field});

  @override
  _AddFieldScreenState createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Jika edit, isi form dengan data existing
    if (widget.field != null) {
      _nameController.text = widget.field!.nama;
      _priceController.text = widget.field!.pricePerHour.toString();
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.field == null) {
          // Tambah baru
          await FieldService.addField(
            _nameController.text,
            _priceController.text,
          );
        } else {
          // Edit existing
          await FieldService.updateField(
            widget.field!.id,
            _nameController.text,
            _priceController.text,
          );
        }

        widget.onFieldAdded();
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Lapangan berhasil disimpan")));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menyimpan lapangan")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.field == null ? "Tambah Lapangan" : "Edit Lapangan"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nama Lapangan"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama lapangan harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Harga per Jam"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text("Simpan")),
            ],
          ),
        ),
      ),
    );
  }
}
