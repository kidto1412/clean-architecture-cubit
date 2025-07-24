import 'dart:io';

import 'package:analytic_invest/core/theme/theme.dart';
import 'package:analytic_invest/features/register/domain/entities/user.dart';
import 'package:analytic_invest/features/register/presentation/cubit/register_cubit.dart';
import 'package:analytic_invest/features/register/presentation/cubit/register_state.dart';
import 'package:analytic_invest/global/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          BlocBuilder<RegisterCubit, RegisterState>(builder: (context, state) {
        return SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Register',
                  style: blackTextStyle,
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt,
                            size: 40, color: Colors.white70)
                        : null,
                  ),
                ),
              ),
              CustomTextField(
                label: 'Fullname',
                hint: 'Input Fullname',
                iconName: Icons.email_outlined,
                controllerl: name,
              ),
              CustomTextField(
                label: 'Email ',
                hint: 'Input Email',
                iconName: Icons.email_outlined,
                controllerl: email,
              ),
              CustomTextField(
                label: 'Username ',
                hint: 'Input username',
                iconName: Icons.person,
                controllerl: username,
              ),
              CustomTextField(
                label: 'Password',
                hint: 'Input password',
                obscureText: true,
                iconName: Icons.key,
                controllerl: password,
              ),
              CustomTextField(
                label: 'Confirm Password',
                hint: 'Input confirm password',
                obscureText: true,
                iconName: Icons.key,
                controllerl: confirmPassword,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  width: double.infinity,
                  height: 50,
                  child: state is RegisterLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            final user = User(
                              id: null,
                              name: name.text,
                              username: username.text,
                              password: confirmPassword.text,
                              email: email.text,
                              photo_profile: "",
                              created_at: DateTime.now(),
                              updated_at: DateTime.now(),
                            );
                            context.read<RegisterCubit>().register(user);
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                        )),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child:
                          Text("Atau", style: TextStyle(color: Colors.black54)),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Sudah punya akun?"),
                    ),
                    Container(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Masuk',
                                style: TextStyle(color: Colors.blue))))
                  ],
                ),
              ),
            ],
          ),
        ));
      }),
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
