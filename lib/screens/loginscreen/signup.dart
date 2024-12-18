import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_app1/screens/components/mybutton.dart';
import 'package:recipe_app1/screens/components/mytextfield.dart';
import 'package:recipe_app1/screens/loginscreen/signin.dart';
import 'package:recipe_app1/screens/services/firestore.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FirestoreServices firestoreServices = FirestoreServices();

  // Future addUserDetails(String fullName, String email) async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please create your account here',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 50),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign up',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: nameController,
                    hintText: 'Full name',
                    prefixIcon: const Icon(Icons.person_2_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }

                      if (value.length < 5) {
                        return 'Full name must be at least 5 characters';
                      }

                      return null;
                    },
                    maxline: 1,
                  ),
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: emailController,
                    hintText: 'abc@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }

                      return null;
                    },
                    maxline: 1,
                  ),
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!value.contains(RegExp(r'[^\w]'))) {
                        return 'Password must contain at least one non-alphabetic character';
                      }
                      return null;
                    },
                    maxline: 1,
                  ),
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: confirmpasswordController,
                    hintText: 'Confirm password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!value.contains(RegExp(r'[A-Z]'))) {
                        return 'Password must contain at least one uppercase letter';
                      }
                      if (!value.contains(RegExp(r'[^\w]'))) {
                        return 'Password must contain at least one non-alphabetic character';
                      }
                      return null;
                    },
                    maxline: 1,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 250,
                    child: // Inside the onPressed callback:
                        MyButton(
                      text: 'Sign Up',
                      onPressed: () async {
                        // Validate the form before proceeding
                        if (_formKey.currentState!.validate()) {
                          // Show loading indicator
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset(
                                    'assets/lottie/Animation - 1707395406065.json',
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ),
                          );

                          try {
                            // Check if passwords match
                            if (passwordController.text ==
                                confirmpasswordController.text) {
                              // Passwords match, proceed with account creation
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              String uid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              await firestoreServices.createUserDocument(uid,
                                  nameController.text, emailController.text);

                              print('Account created');
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
                              await firestoreServices.addUserDetails(
                                  nameController.text, emailController.text);
                            } else {
                              // Passwords do not match, show an error
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Password Mismatch'),
                                    content: const Text(
                                        'The entered passwords do not match.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } catch (error) {
                            // Handle errors during account creation
                            Navigator.pop(context); // Close loading indicator
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content:
                                      Text('Error creating account: $error'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
