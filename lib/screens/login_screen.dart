import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text('Login',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 25),),
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              if (userProvider.user != null) {
                return IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    userProvider.logout();
                  },
                );
              } else {
                return SizedBox.shrink(); // Placeholder for logged out state
              }
            },
          ),
        ],
      ),
      body:



      Consumer<UserProvider>(

        builder: (context, userProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),


            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 100, color: Colors.amber[700]),
                SizedBox(height: 5),

                Center(child: Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.amber[700]),)),
                SizedBox(height: 10),
                // Username TextField
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Enter your username',

                    labelText: 'Username' ,
                    border: OutlineInputBorder(


                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Password TextField
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon:Icon( Icons.password),
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                // Login Button
                userProvider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () async {
                    String username = _usernameController.text.trim();
                    String password = _passwordController.text.trim();

                    // Basic validation
                    if (username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter username and password')),
                      );
                      return;
                    }

                    // Call login with hardcoded credentials
                    await userProvider.login(username, password);
                    if (userProvider.user != null) {
                      Navigator.pushReplacementNamed(context, '/');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed')),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                // Continue as Guest Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the main screen or product list screen
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Text('Continue as Guest'),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}
