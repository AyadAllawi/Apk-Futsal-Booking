// add_lapangan.dart
import 'package:flutter/material.dart';
import 'package:futsal_booking/model/lapangan/field_model.dart';
import 'package:futsal_booking/services/lapangan/field_services.dart';

class AddFieldScreen extends StatefulWidget {
  final Function onFieldAdded;
  final Datum? field;

  const AddFieldScreen({super.key, required this.onFieldAdded, this.field});
  static const id = '/add';

  @override
  _AddFieldScreenState createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.field != null) {
      _nameController.text = widget.field!.name ?? '';
      _priceController.text = widget.field!.pricePerHour ?? '';
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (widget.field == null) {
          // Tambah baru
          await FieldService.addField(
            _nameController.text,
            _priceController.text,
          );
        } else {
          // Edit existing
          final updatedField = widget.field!.copyWith(
            name: _nameController.text,
            pricePerHour: _priceController.text,
          );
          await FieldService.updateField(updatedField);
        }

        widget.onFieldAdded();
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Lapangan berhasil disimpan")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan lapangan: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
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
                decoration: InputDecoration(
                  labelText: "Nama Lapangan",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama lapangan harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Harga per Jam",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga harus diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Simpan"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
