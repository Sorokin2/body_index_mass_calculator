import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'bmi_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController(text: "user@example.com");
  final TextEditingController _passwordController = TextEditingController(text: "456321");
  bool _showError = false;

  void _login() {
    if (_emailController.text == "user@example.com" &&
        _passwordController.text == "456321") {
      setState(() {
        _showError = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BmiScreen()),
      );
    } else {
      setState(() {
        _showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Вход в приложение",
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Поле Email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Сдвигаем текст подписи вправо на 12 пикселей
                        const Padding(
                          padding: EdgeInsets.only(left: 0.0),
                          child: Text("Email", style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "example@gmail.com",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF4CAF50)),
                            ),
                            // Сдвигаем текст внутри поля вправо на 12 пикселей, убираем вертикальные отступы
                            contentPadding: EdgeInsets.only(left: 12.0, top: 0, bottom: 4),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Поле Пароль
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 0.0),
                          child: Text("Пароль", style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Введите пароль",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF4CAF50)),
                            ),
                            contentPadding: EdgeInsets.only(left: 12.0, top: 0, bottom: 4),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                        );
                      },
                      child: const Text(
                        "Зарегистрироваться",
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "ВОЙТИ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              if (_showError)
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    "Неверный email или пароль!",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}