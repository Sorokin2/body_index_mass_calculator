import 'package:flutter/material.dart';
import 'profile_screen.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  bool _isCalculated = false;
  bool _showError = false;
  
  String _bmiResult = "";
  String _recommendation = "";

  void _calculateBmi() {
    // Сброс ошибок
    setState(() {
      _showError = false;
      _isCalculated = false;
    });

    final String heightText = _heightController.text.trim();
    final String weightText = _weightController.text.trim();

    // Проверка на пустые поля (п.9)
    if (heightText.isEmpty || weightText.isEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }

    final double? height = double.tryParse(heightText);
    final double? weight = double.tryParse(weightText);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      setState(() {
        _showError = true; // Можно вывести другую ошибку, но по ТЗ просят "Заполните все поля"
      });
      return;
    }

    // Расчет ИМТ
    double heightInMeters = height / 100;
    double bmi = weight / (heightInMeters * heightInMeters);

    String rec = "";
    // Логика рекомендаций (п.12)
    if (bmi <= 16) {
      rec = "Выраженный дефицит массы тела. Советуем набирать вес для здоровья.";
    } else if (bmi > 16 && bmi < 18.5) {
      rec = "Недостаточная масса тела. Рекомендуется увеличить массу тела.";
    } else if (bmi >= 18.5 && bmi < 25) {
      rec = "Норма. Ваш вес в здоровом диапазоне — поддерживайте его!";
    } else if (bmi >= 25 && bmi < 30) {
      rec = "Избыточная масса тела и предожирение. Желательно снизить вес для улучшения самочувствия.";
    } else if (bmi >= 30 && bmi < 35) {
      rec = "Ожирение. Рекомендуется уменьшить вес под контролем специалиста.";
    } else if (bmi >= 35 && bmi < 40) {
      rec = "Ожирение резкое. Необходимо снижение веса с медицинской поддержкой.";
    } else {
      rec = "Очень резкое ожирение. Требуется срочная коррекция веса под наблюдением врача.";
    }

    setState(() {
      _bmiResult = bmi.toStringAsFixed(1);
      _recommendation = rec;
      _isCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        // Выравнивание контента по центру (п.1, 2, 6)
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Заголовок (п.2)
              const Text(
                "Индекс массы тела",
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Карточка ввода (п.1, 10)
              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Персональные данные",
                      style: TextStyle(
                        color: Color(0xFF4CAF50), // п.4
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Рост (см)",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4CAF50))),
                      ),
                    ),
                    TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Вес (кг)",
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF4CAF50))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Кнопка Рассчитать (п.10)
              SizedBox(
                width: double.infinity, // Одинаковая ширина с карточкой
                height: 50,
                child: ElevatedButton(
                  onPressed: _calculateBmi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "РАССЧИТАТЬ",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              // Текст ошибки (п.9)
              if (_showError)
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    "Заполните все поля",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              
              const SizedBox(height: 20),
              
              // Карточка результата (п.5, 7, 8, 11)
              if (_isCalculated)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9), // п.5
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Надпись слева
                    children: [
                      const Text(
                        "Ваш индекс массы тела:",
                        style: TextStyle(
                          color: Color(0xFF4CAF50), // п.7
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          _bmiResult,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50), // п.7
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _recommendation,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF757575), fontSize: 14), // п.11
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      
      // Нижняя панель навигации (п.3)
      bottomNavigationBar: Container(
        height: 60, // Фиксированная высота
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3), // Тень сверху
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Кнопка Калькулятор (п.13)
            GestureDetector(
              onTap: () {
                // Мы уже на этой странице, ничего не делаем
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Калькулятор",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Кнопка Профиль (п.14)
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement( // Заменяем экран, чтобы не плодить стек
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Профиль",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}