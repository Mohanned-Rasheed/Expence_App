import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SginInPage extends StatelessWidget {
  SginInPage({super.key});
  final _formKey = GlobalKey<FormState>();

  final Email = TextEditingController();
  final Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width * 0.1,
                    right: MediaQuery.sizeOf(context).width * 0.1,
                    top: MediaQuery.sizeOf(context).height * 0.45),
                child: Column(
                  children: [
                    TextFormField(
                      controller: Email,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          hintText: "Email",
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                          ),
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.02,
                    ),
                    TextFormField(
                      controller: Password,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                          ),
                          hintText: "Password",
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.07,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue.shade300),
                          shadowColor: MaterialStateProperty.all(Colors.black),
                          enableFeedback: false,
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              left: MediaQuery.sizeOf(context).width * 0.32,
                              right: MediaQuery.sizeOf(context).width * 0.32)),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: Email.text, password: Password.text);
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("wrong-password Or Email")));
                          }
                        },
                        child: Text(
                          "Sgin In",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                            style: const ButtonStyle(
                              enableFeedback: false,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/sginup");
                            },
                            child: const Text(
                              "Sgin up",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
