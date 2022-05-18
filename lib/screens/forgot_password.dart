import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: med.height*0.1,
            ),

            //Image
            Center(
              child: Container(
                height: med.height*0.2,
                width: med.width*0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/forgot_pass.png"),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),

            SizedBox(
              height: med.height*0.07,
            ),

            //Forgot pasword Text
            Container(
              child: Text("Forgot Password?",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(
              height: med.height*0.03,
            ),

            Container(
              child: Text("Enter the email address associated",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            Container(
              child: Text("with your account",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),

            Container(
              width: med.width*0.6,
              child: RaisedButton(
                onPressed: (){},
                child: Text("Next"),
                color: Color(0xFFb58563),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
