import 'package:baitap6/blocs/user_bloc.dart';
import 'package:baitap6/model/user_model.dart';
import 'package:baitap6/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'system.dart';
import 'color.dart';

class LoginScreen extends StatefulWidget {
  late UserBloc userBloc = new UserBloc();

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var obs = true;
  var subIcon = Icons.remove_red_eye;
  var controllerEmail = TextEditingController();
  var controllerPass = TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Stack(
        children: [
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return GestureDetector(
      onTap: () => hideKeyboardAndUnFocus(context),
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 128, right: 32, left: 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                'Phone number',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9796A1)),
              ),
              const SizedBox(
                height: 12,
              ),
              myTextFiled(
                  autoFocus: true,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter your phone number',
                  controller: controllerEmail),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9796A1),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              myTextFiled(
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Enter your password',
                  obscureText: obs,
                  suffixIcon: subIcon,
                  onTapSuffixIcon: hintPass,
                  controller: controllerPass),
              const SizedBox(
                height: 12,
              ),
              forgetPass(),
              const SizedBox(
                height: 12,
              ),
              loginButton(),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myTextFiled(
      {bool? autoFocus = false,
      TextEditingController? controller,
      required TextInputType keyboardType,
      bool obscureText = false,
      String? hintText,
      IconData? suffixIcon,
      VoidCallback? onTapSuffixIcon //chính là function
      }) {
    return Container(
      height: 64,
      child: TextField(
        autofocus: autoFocus!,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: [LengthLimitingTextInputFormatter(100)],
        textCapitalization: TextCapitalization.words,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: inputBorder)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepOrange)),
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obs = !obs;
                      if (obs == true) {
                        subIcon = Icons.add;
                      } else {
                        subIcon = Icons.remove_red_eye;
                      }
                    });
                  },
                  child: Icon(subIcon),
                )
              : null,
        ),
      ),
    );
  }

  Widget forgetPass() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(
          "Forget password?",
          style: TextStyle(color: Color(0xFFFE724C), fontSize: 14),
        ),
      ),
    );
  }

  Widget loginButton() {
    return Center(
      child: Container(
        width: 250,
        height: 60,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFFFE724C)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              shadowColor: MaterialStateProperty.all<Color>(Color(0xFFFE724C)),
              elevation: MaterialStateProperty.all(5)),
          onPressed: () async {
            //   UserModel u= await UserBloc().login(controllerEmail.text, controllerPass.text) ;

            widget.userBloc
                .login(controllerEmail.text, controllerPass.text, context);
          },
          child: Text(
            "Login",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.08),
          ),
        ),
      ),
    );
  }

  void hintPass() {
    print("hint pass");
  }
}
