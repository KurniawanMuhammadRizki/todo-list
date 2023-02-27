import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key, required this.submitAuthFormFn}) : super(key: key);
  final Function(
      {required String email,
      required String username,
      required String password,
      required bool isLogin}) submitAuthFormFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _islogin = true;
  String _email = '';
  String _username = '';
  String _password = '';

  void submitForm() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        widget.submitAuthFormFn(
          email: _email,
          username: _username,
          password: _password,
          isLogin: _islogin,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              key: Key('email'),
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@'))
                  return 'Mohon masukkan format email yang benar';

                return null;
              },
              onSaved: (value) {
                _email = value ?? '';
              }),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 15,
          ),
          if (!_islogin)
            TextFormField(
              key: Key('username'),
              // ignore: prefer_const_constructors
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6)
                  return 'Username harus memiliki minimal 6 karakter';

                return null;
              },
              onSaved: (value) {
                _username = value ?? '';
              },
            ),
          if (!_islogin)
            // ignore: prefer_const_constructors
            SizedBox(
              height: 15,
            ),
          TextFormField(
            key: Key('password'),
            obscureText: true,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6)
                return 'Password harus memiliki minimal 6 karakter';

              return null;
            },
            onSaved: (value) {
              _password = value ?? '';
            },
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: submitForm,
            child: Text(_islogin ? 'Masuk' : 'Daftar'),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  _islogin = !_islogin;
                });
              },
              child: Text(_islogin ? 'Daftar Akun Baru' : 'Sudah Punya Akun')),
        ],
      ),
    );
  }
}
