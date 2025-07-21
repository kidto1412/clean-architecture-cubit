import 'package:analytic_invest/core/theme/theme.dart';
import 'package:analytic_invest/features/register/presentation/pages/register_page.dart';
import 'package:analytic_invest/global/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Login',
              style: blackTextStyle,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 20.0),
            child: Text(
              'Ayo investasi',
              style: greyTextStyle,
            ),
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
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              )),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Lupa password",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Expanded(child: Divider(thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("Atau", style: TextStyle(color: Colors.black54)),
              ),
              Expanded(child: Divider(thickness: 1)),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Belum punya akun?"),
                ),
                Container(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text('Daftar',
                            style: TextStyle(color: Colors.blue))))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
