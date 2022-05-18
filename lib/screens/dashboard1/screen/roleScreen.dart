import 'package:flutter/material.dart';

enum Role { Partner,Customer }

class Category extends StatefulWidget {
  Role selectedRole;
  void onChanged(Role selectedRole) {}
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool isselected=true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
            ),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(0.72),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            /*decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/blackShade.png'),
                      fit: BoxFit.cover)),*/
            child: Column(
              children: [
                // SizedBox(
                //   height: 20,
                // ),
                Image.asset(
                  'assets/images/category-logo.png',width: size.width*0.4,height:size.height*0.4,
                ),
                // Spacer(),
                Padding(
                  padding:  EdgeInsets.only(bottom: size.height*0.04),
                  child: Text("What Role Do You Have?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.white),),
                ),
                Row(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.04),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            widget.selectedRole = Role.Partner;
                            widget.onChanged(widget.selectedRole);

                          });
                        },
                        child: Container(
                          width: size.width*0.4,
                          height: size.height*0.22,
                          decoration: BoxDecoration(
                              color:  widget.selectedRole == Role.Partner
                                  ? Color(0xFFFFFFFF)
                                  : Colors.white60,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: size.height*0.04,),
                              Image.asset('assets/images/partner.png',width: size.width*0.2,),
                              Padding(
                                padding:  EdgeInsets.only(top: size.height*0.02),
                                child: Text("Partner",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.1,),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            widget.selectedRole = Role.Customer;
                            widget.onChanged(widget.selectedRole);
                          });
                        },
                        child: Container(
                          width: size.width*0.4,
                          height: size.height*0.22,
                          decoration: BoxDecoration(
                              color:  widget.selectedRole == Role.Customer
                                  ? Color(0xFFFFFFFF)
                                  : Colors.white60,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: size.height*0.04,),
                              Image.asset('assets/images/coustmer.png',width: size.width*0.2,),
                              Padding(
                                padding:  EdgeInsets.only(top: size.height*0.02),
                                child: Text("Customer",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                /*   Spacer(),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Already Account ? ',
                        style: TextStyle(
                          color: white,
                        )),
                    TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: white,
                            fontWeight: FontWeight.bold),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(context, '/signIn'))
                  ])),*/
                SizedBox(height: size.height*0.07,),
                GestureDetector(
                  onTap:()=>Navigator.pushNamed(context, '/dashboard'),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFb58563),
                        borderRadius: BorderRadius.circular(25)
                    ),
                    width: size.width*0.4,
                    height: size.height*0.05,
                    child: Center(child: Text('Next',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}