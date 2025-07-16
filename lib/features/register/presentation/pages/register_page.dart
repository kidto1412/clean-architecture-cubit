import 'dart:io';

import 'package:analytic_invest/global/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: _showImageSourceDialog,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.white70)
                    : null,
              ),
            ),
          ),
          CustomTextField(
            label: 'Fullname',
            hint: 'Input Fullname',
            iconName: Icons.email_outlined,
          ),
          CustomTextField(
            label: 'Username / Email',
            hint: 'Input username / email',
            iconName: Icons.email_outlined,
          ),
          CustomTextField(
            label: 'Password',
            hint: 'Input password',
            obscureText: true,
            iconName: Icons.key,
          ),
          CustomTextField(
            label: 'Confirm Password',
            hint: 'Input confirm password',
            obscureText: true,
            iconName: Icons.key,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              )),
        ],
      )),
    );
  }

  Future<XFile?> _pickImage(ImageSource imageSource) async {
    final XFile? pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
