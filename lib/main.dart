import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fecha y Hora en Movimiento',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamController<DateTime> _streamController;
  late Timer _timer;
  final player = AudioPlayer(); 

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<DateTime>();
    _startTimer();
  }

  @override
  void dispose() {
    _streamController.close();
    _timer.cancel();
    player.dispose(); 
    super.dispose();
  }

  Future<void> _startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _streamController.add(DateTime.now());
    });

    String audioPath = 'assets/audio/audio1.mp3'; 
    await player.setAsset(audioPath); 
    await player.play(); 
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 10), 
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/imagen1.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: StreamBuilder<DateTime>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DateTime? now = snapshot.data;
                  if (now != null) {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                    String formattedTime = DateFormat('HH:mm:ss').format(now);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¡Hola Angelica!',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Hora Actual',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formattedTime,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Fecha Actual',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }

                return const CircularProgressIndicator(
                  color: Colors.blue,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
