// import 'package:flutter/material.dart';
// import 'home_widget.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               _signInButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _signInButton() {
//     return OutlineButton(
//         splashColor: Theme.of(context).accentColor,
//         onPressed: () {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) {
//                 return Home();
//               },
//             ),
//           );
//         },
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
//         highlightElevation: 0,
//         borderSide: BorderSide(color: Theme.of(context).primaryColor),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Image(image: AssetImage('assets/googleLogo.png'), height: 35.0),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10),
//                 child: Text(
//                   'Sign in with Google',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.grey,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }
