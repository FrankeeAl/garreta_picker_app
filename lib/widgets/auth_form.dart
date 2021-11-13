import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../models/auth.dart';
import '../models/http_exception.dart';
import '../pages/main_page.dart';

//import 'package:lottie/lottie.dart';
//import 'package:garreta_picker_app/pages/qr_scan_page.dart';

class AuthFormWidget extends StatefulWidget {
  const AuthFormWidget({Key? key}) : super(key: key);

  @override
  _AuthFormWidgetState createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final emailController = TextEditingController();
  String password = '';
  bool isPasswordVisible = false;

  String qrCode = '';
  //Animation
  AnimationController? _controller;
  Animation<Size>? _heightAnimation;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    emailController.addListener(
      () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    //_controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            buildEmailField(),
            const SizedBox(height: 20),
            buildPasswordField(),
            const SizedBox(height: 20),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //   buttonWidget(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(20.0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(5),
                      ),
                      onPressed: () {
                        _submit();
                      },
                      label: Text('LOGIN',
                          style: Theme.of(context).textTheme.headline2),
                      icon: const Icon(Icons.login_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        title: const Text('An error occured.'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).signin(
        _authData['email']!,
        _authData['password']!,
      );

      Navigator.of(context).pushReplacementNamed(MainPage.routeName);
    } on HttpException catch (e) {
      var errorMessage = 'Authentication fail.';
      // switch (e.toString()) {}
      if (e.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email already in use, try another one.';
      } else if (e.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'Sorry, not a valid email.';
      } else if (e.toString().contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
        errorMessage = 'Too many attempts, try again later.';
      } else if (e.toString().contains('OPERATION_NOT_ALLOWED')) {
        errorMessage = 'Operation not allowed.';
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Sorry,could find email.';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Please enter a valid password';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password, try again.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      var errorMessage =
          'Could not authenticate as of the moment, try again later.';
      _showErrorDialog(errorMessage);
      print(e.toString());
    }
    // Provider.of<Merchants>(context, listen: false).fetchMerchant();
    // var merchantName = Provider.of<Merchants>(context, listen: false).getName;

    setState(() {
      _isLoading = false;
    });
  }

  Widget buildEmailField() => TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Email',
        hintText: 'name@example.com',
        prefixIcon: const Icon(Icons.mail),
        suffixIcon: emailController.text.isEmpty
            ? Container(width: 0)
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => emailController.clear(),
              ),
      ),
      onSaved: (value) {
        _authData['email'] = value!;
      },
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      textInputAction: TextInputAction.done,
      validator: (email) {
        bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email!);
        if (!emailValid) {
          return 'Email not valid.';
        } else if (email.isEmpty) {
          return 'Enter a valid email.';
        }
        return null;
      });

  Widget buildPasswordField() => TextFormField(
        onChanged: (value) => setState(() => password = value),
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Password',
            //hintText: 'Your password...',
            // errorText: 'Something went wrong',
            //prefixIcon: const Icon(Icons.password),
            suffixIcon: IconButton(
              icon: isPasswordVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () =>
                  setState(() => isPasswordVisible = !isPasswordVisible),
            )),
        obscureText: !isPasswordVisible,
        textInputAction: TextInputAction.done,
        onSaved: (value) {
          _authData['password'] = value!;
        },
      );

  Widget buttonWidget() => ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          elevation: MaterialStateProperty.all(10),
        ),
        onPressed: _submit,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image(
                  image: AssetImage('assets/images/qr_scan.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('QR scan ',
                  style: Theme.of(context).textTheme.headline2),
            ),
          ],
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#FC2E20',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;
      setState(() {
        this.qrCode = qrCode;
        print(qrCode);
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    } catch (e) {
      rethrow;
    }
  }
}
