import 'package:flutter/material.dart';
import 'package:planify/src/pages/adicionartarefa.dart';
import 'package:planify/src/pages/chatdaia.dart';
import 'package:planify/src/pages/criarevento.dart';
import 'package:planify/src/pages/criarprojeto.dart';
import 'package:planify/src/pages/criartime.dart';
import 'package:planify/src/pages/detalhesdastarefas.dart';
import 'package:planify/src/pages/perfil.dart';
import 'dart:math';
import 'login.dart';
import 'cadastro.dart';
import 'habits.dart';


class Inicial extends StatefulWidget {
  const Inicial({super.key});

  @override
  _InicialState createState() => _InicialState();
}

class _InicialState extends State<Inicial> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(color: Colors.black),
            const AnimatedBlurredBackground(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 134),
                  Text(
                    "WELCOME",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Barlow',
                      color: Colors.white,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback:
                        (bounds) => LinearGradient(
                          colors: [Color(0xFF3254FF), Color(0xFFCDA2FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 0.6],
                        ).createShader(bounds),
                    child: Text(
                      "PLANIFY",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Barlow',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 34),
                  Text(
                    "Thousands of people are using planify\n to better organize themselves",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                      color: const Color.fromARGB(228, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 38),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: _isButtonPressed ? 28 : 24,
                        vertical: _isButtonPressed ? 16 : 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6735B1), Color(0xFFAB82E9)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF714DA6),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Get started",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 29,
                            height: 29,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Color(0xFFA370F0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "  DON´T HAVE AN ACCOUNT? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navega para a página de cadastro
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CadastroPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "SIGN UP", // O texto que será um link
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBF99F8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const HabitsPage(), // substitua pelo nome do widget da sua tela
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Ir para tela de hábitos",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  /* botao para tela adicionar tarefa  */
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const AddTaskPage(), // substitua pelo nome do widget da sua tela
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Ir para tela de adicionar tarefa ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  /* botao criar grupo */
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateTeamPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Ir para tela de criar grupo ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  /* ir para tela chat da ia */
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(title: "Chatia", ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Ir para tela de chatdaia",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                   /* ir para tela criar projeto */
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateProjectScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Ir para tela de criar projeto",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  /* ir para telha detalhes da tarefa */
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsTaskPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Ir para detalhes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                      /* ir para telha criar evento */
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsTaskPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Ir para criar evento",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
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

class AnimatedBlurredBackground extends StatefulWidget {
  const AnimatedBlurredBackground({super.key});

  @override
  AnimatedBlurredBackgroundState createState() =>
      AnimatedBlurredBackgroundState();
}

class AnimatedBlurredBackgroundState extends State<AnimatedBlurredBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: BlurredGradientPainter(_controller.value, context),
        );
      },
    );
  }
}

class BlurredGradientPainter extends CustomPainter {
  final double animationValue;
  final BuildContext context;

  BlurredGradientPainter(this.animationValue, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()..maskFilter = MaskFilter.blur(BlurStyle.normal, 100);

    // Cores do gradiente
    List<List<Color>> gradientColors = [
      [Color(0xFF7526D4), Color(0xFFAB82E9)], // Roxo
      [Color(0xFF2C26D4), Color(0xFF497FF5)], // Azul
      [Color(0xFFF549D6), Color(0xFFAB82E9)], // Rosa
    ];

   
    List<Offset> positions = [
      Offset(
        size.width * (0.2 + 0.1 * sin(animationValue * pi * 2)),
        size.height * (0.2 + 0.1 * sin(animationValue * pi * 2)),
      ),
      Offset(
        size.width * (0.7 + 0.2 * cos(animationValue * pi * 2)),
        size.height * (0.5 + 0.2 * sin(animationValue * pi * 2)),
      ),
      Offset(
        size.width * (0.4 + 0.3 * sin(animationValue * pi * 2)),
        size.height * (0.8 + 0.2 * cos(animationValue * pi * 2)),
      ),
    ];

    // Tamanho dos círculos é proporcional à largura da tela
    double circleSize = size.width * 0.4;

    // Desenhando os círculos com gradiente
    for (int i = 0; i < gradientColors.length; i++) {
      paint.shader = LinearGradient(
        colors: gradientColors[i],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: positions[i], radius: circleSize));

      canvas.drawCircle(positions[i], circleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
