import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../widgets/auth_form.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  static const routeName = '/sign-in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(),
          //    Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  width: 170,
                  child: Text(
                    'Welcome To Garreta Picker',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Center(
                  child: Lottie.asset('assets/lottie/76994-sign-in.json'),
                  //  'https://assets8.lottiefiles.com/private_files/lf30_fkfbivy0.json'),
                ),
              ),
            ],
          ),

          const Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: AuthFormWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
