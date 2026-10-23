import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    setState(() => _errorMessage = null);

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Валидация
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      setState(() => _errorMessage = "Заполните все поля");
      return;
    }
    if (firstName.length < 2 || lastName.length < 2) {
      setState(
          () => _errorMessage = "Имя и фамилия должны быть не короче 2 символов");
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMessage = "Введите корректный email");
      return;
    }
    if (password.length < 6) {
      setState(
          () => _errorMessage = "Пароль должен содержать минимум 6 символов");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      if (!mounted) return;

      // Проверяем, требуется ли подтверждение email
      if (response.session == null && response.user != null) {
        // Сессия не создана — скорее всего включено подтверждение email
        _showSuccess("Аккаунт создан! Проверьте почту для подтверждения.");
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.pop(context);
        return;
      }

      if (response.user != null) {
        _showSuccess("Аккаунт успешно создан!");
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        setState(() => _errorMessage = "Не удалось создать аккаунт");
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      String message;
      final msg = e.message.toLowerCase();
      if (msg.contains('already registered') ||
          msg.contains('already exists') ||
          msg.contains('user already registered')) {
        message = "Пользователь с таким email уже зарегистрирован";
      } else if (msg.contains('invalid email')) {
        message = "Введите корректный email";
      } else if (msg.contains('password')) {
        message = "Пароль слишком слабый";
      } else if (msg.contains('rate limit')) {
        message = "Слишком много запросов. Попробуйте позже.";
      } else {
        message = "Ошибка регистрации: ${e.message}";
      }
      setState(() => _errorMessage = message);
    } catch (_) {
      if (!mounted) return;
      setState(() =>
          _errorMessage = "Не удалось создать аккаунт. Проверьте подключение.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccess(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: const Color(0xFF4CAF50)),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                "Регистрация",
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
                    _buildCustomTextField(
                      "Имя",
                      "Введите ваше имя",
                      controller: _firstNameController,
                      inputFormatters: const [_NameTextInputFormatter()],
                    ),
                    const SizedBox(height: 15),
                    _buildCustomTextField(
                      "Фамилия",
                      "Введите вашу фамилию",
                      controller: _lastNameController,
                      inputFormatters: const [_NameTextInputFormatter()],
                    ),
                    const SizedBox(height: 15),
                    _buildCustomTextField(
                      "Email",
                      "example@gmail.com",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildCustomTextField(
                      "Пароль",
                      "Введите пароль",
                      controller: _passwordController,
                      isObscure: true,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text(
                        "Вернуться к странице входа",
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
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    disabledBackgroundColor: const Color(0xFFA5D6A7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "СОЗДАТЬ АККАУНТ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField(
    String label,
    String hint, {
    bool isObscure = false,
    TextEditingController? controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: isObscure,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4CAF50)),
            ),
            contentPadding:
                const EdgeInsets.only(left: 12.0, top: 0, bottom: 4),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

/// Форматтер, разрешающий буквы (латиница + кириллица), пробел и дефис.
///
/// В отличие от `FilteringTextInputFormatter.allow`, этот форматтер:
/// - корректно работает с IME / свайп-клавиатурами (проверяет всю строку,
///   а не отдельные кодовые единицы в промежуточном состоянии);
/// - поддерживает вставку из буфера обмена;
/// - явно перечисляет кириллицу, исключая сюрпризы диапазонов `а-я`.
class _NameTextInputFormatter extends TextInputFormatter {
  const _NameTextInputFormatter();

  static final RegExp _allowed = RegExp(
    r"[a-zA-Z"
    r"абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
    r"АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
    r"\s\-]",
    unicode: true,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Пустая строка (удаление всего) — всегда разрешаем.
    if (newValue.text.isEmpty) return newValue;

    // Проверяем, что каждый символ входит в разрешённый набор.
    final chars = newValue.text.characters;
    for (final ch in chars) {
      if (!_allowed.hasMatch(ch)) {
        return oldValue;
      }
    }
    return newValue;
  }
}