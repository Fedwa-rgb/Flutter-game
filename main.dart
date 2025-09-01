import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MemoryBoostSeniors());
}

class MemoryBoostSeniors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Boost Seniors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bestScore = 0;
  double fontSize = 18.0;
  bool highContrast = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bestScore = prefs.getInt('bestScore') ?? 0;
      fontSize = prefs.getDouble('fontSize') ?? 18.0;
      highContrast = prefs.getBool('highContrast') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: highContrast ? Colors.black : Colors.blue[50],
      appBar: AppBar(
        title: Text(
          'Memory Boost Seniors',
          style: TextStyle(
            fontSize: fontSize + 6,
            color: highContrast ? Colors.yellow : Colors.white,
          ),
        ),
        backgroundColor: highContrast ? Colors.black : Colors.blue[700],
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology,
              size: 100,
              color: highContrast ? Colors.yellow : Colors.blue[600],
            ),
            SizedBox(height: 30),
            Text(
              'Stimulez votre mémoire !',
              style: TextStyle(
                fontSize: fontSize + 8,
                fontWeight: FontWeight.bold,
                color: highContrast ? Colors.white : Colors.blue[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Meilleur score: $bestScore',
              style: TextStyle(
                fontSize: fontSize + 2,
                color: highContrast ? Colors.yellow : Colors.blue[600],
              ),
            ),
            SizedBox(height: 40),
            _buildGameButton(
              'Mémoriser des Mots',
              Icons.text_fields,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                    gameType: GameType.words,
                    fontSize: fontSize,
                    highContrast: highContrast,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildGameButton(
              'Mémoriser des Chiffres',
              Icons.numbers,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                    gameType: GameType.numbers,
                    fontSize: fontSize,
                    highContrast: highContrast,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildGameButton(
              'Séquences Mixtes',
              Icons.shuffle,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                    gameType: GameType.mixed,
                    fontSize: fontSize,
                    highContrast: highContrast,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(String title, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: highContrast ? Colors.yellow : Colors.blue[600],
          foregroundColor: highContrast ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: fontSize + 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: highContrast ? Colors.black : Colors.white,
              title: Text(
                'Paramètres',
                style: TextStyle(
                  color: highContrast ? Colors.white : Colors.black,
                  fontSize: fontSize + 4,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Taille du texte',
                    style: TextStyle(
                      color: highContrast ? Colors.white : Colors.black,
                      fontSize: fontSize,
                    ),
                  ),
                  Slider(
                    value: fontSize,
                    min: 14.0,
                    max: 28.0,
                    divisions: 7,
                    onChanged: (value) {
                      setDialogState(() {
                        fontSize = value;
                      });
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contraste élevé',
                        style: TextStyle(
                          color: highContrast ? Colors.white : Colors.black,
                          fontSize: fontSize,
                        ),
                      ),
                      Switch(
                        value: highContrast,
                        onChanged: (value) {
                          setDialogState(() {
                            highContrast = value;
                          });
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Sauvegarder',
                    style: TextStyle(
                      color: highContrast ? Colors.yellow : Colors.blue,
                      fontSize: fontSize,
                    ),
                  ),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setDouble('fontSize', fontSize);
                    await prefs.setBool('highContrast', highContrast);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

enum GameType { words, numbers, mixed }

class GameScreen extends StatefulWidget {
  final GameType gameType;
  final double fontSize;
  final bool highContrast;

  GameScreen({
    required this.gameType,
    required this.fontSize,
    required this.highContrast,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> wordsDatabase = [
    'Soleil', 'Jardin', 'Livre', 'Musique', 'Voyage', 'Famille', 'Bonheur',
    'Nature', 'Amitié', 'Sourire', 'Paix', 'Espoir', 'Liberté', 'Sagesse',
    'Courage', 'Beauté', 'Tendresse', 'Joie', 'Sérénité', 'Harmonie'
  ];

  List<String> currentSequence = [];
  List<String> userInput = [];
  int level = 1;
  int score = 0;
  bool showingSequence = false;
  bool inputPhase = false;
  bool gameOver = false;
  int currentDisplayIndex = 0;
  Timer? displayTimer;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      level = 1;
      score = 0;
      gameOver = false;
      _generateSequence();
    });
  }

  void _generateSequence() {
    currentSequence.clear();
    userInput.clear();
    
    int sequenceLength = 2 + level;
    
    for (int i = 0; i < sequenceLength; i++) {
      switch (widget.gameType) {
        case GameType.words:
          currentSequence.add(wordsDatabase[Random().nextInt(wordsDatabase.length)]);
          break;
        case GameType.numbers:
          currentSequence.add((Random().nextInt(99) + 1).toString());
          break;
        case GameType.mixed:
          if (Random().nextBool()) {
            currentSequence.add(wordsDatabase[Random().nextInt(wordsDatabase.length)]);
          } else {
            currentSequence.add((Random().nextInt(99) + 1).toString());
          }
          break;
      }
    }
    
    _showSequence();
  }

  void _showSequence() {
    setState(() {
      showingSequence = true;
      inputPhase = false;
      currentDisplayIndex = 0;
    });

    displayTimer = Timer.periodic(Duration(milliseconds: 1500), (timer) {
      if (currentDisplayIndex < currentSequence.length) {
        setState(() {
          currentDisplayIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          showingSequence = false;
          inputPhase = true;
        });
      }
    });
  }

  void _addToUserInput(String item) {
    if (!inputPhase || gameOver) return;

    setState(() {
      userInput.add(item);
    });

    if (userInput.length == currentSequence.length) {
      _checkAnswer();
    }
  }

  void _checkAnswer() {
    bool correct = true;
    for (int i = 0; i < currentSequence.length; i++) {
      if (userInput[i] != currentSequence[i]) {
        correct = false;
        break;
      }
    }

    if (correct) {
      setState(() {
        score += level * 10;
        level++;
        inputPhase = false;
      });
      
      Timer(Duration(seconds: 1), () {
        _generateSequence();
      });
    } else {
      setState(() {
        gameOver = true;
      });
      _saveScore();
      _showGameOverDialog();
    }
  }

  void _saveScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int bestScore = prefs.getInt('bestScore') ?? 0;
    if (score > bestScore) {
      await prefs.setInt('bestScore', score);
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: widget.highContrast ? Colors.black : Colors.white,
          title: Text(
            'Partie terminée',
            style: TextStyle(
              color: widget.highContrast ? Colors.white : Colors.black,
              fontSize: widget.fontSize + 4,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score final: $score',
                style: TextStyle(
                  color: widget.highContrast ? Colors.yellow : Colors.blue,
                  fontSize: widget.fontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Niveau atteint: $level',
                style: TextStyle(
                  color: widget.highContrast ? Colors.white : Colors.black,
                  fontSize: widget.fontSize,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Rejouer',
                style: TextStyle(
                  color: widget.highContrast ? Colors.yellow : Colors.blue,
                  fontSize: widget.fontSize,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
            ),
            TextButton(
              child: Text(
                'Menu principal',
                style: TextStyle(
                  color: widget.highContrast ? Colors.yellow : Colors.blue,
                  fontSize: widget.fontSize,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.highContrast ? Colors.black : Colors.blue[50],
      appBar: AppBar(
        title: Text(
          _getGameTitle(),
          style: TextStyle(
            fontSize: widget.fontSize + 2,
            color: widget.highContrast ? Colors.yellow : Colors.white,
          ),
        ),
        backgroundColor: widget.highContrast ? Colors.black : Colors.blue[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildScorePanel(),
            SizedBox(height: 30),
            _buildGameArea(),
            SizedBox(height: 30),
            if (inputPhase) _buildInputArea(),
          ],
        ),
      ),
    );
  }

  String _getGameTitle() {
    switch (widget.gameType) {
      case GameType.words:
        return 'Mémorisation de Mots';
      case GameType.numbers:
        return 'Mémorisation de Chiffres';
      case GameType.mixed:
        return 'Séquences Mixtes';
    }
  }

  Widget _buildScorePanel() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.highContrast ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                'Score',
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.highContrast ? Colors.white : Colors.grey[600],
                ),
              ),
              Text(
                '$score',
                style: TextStyle(
                  fontSize: widget.fontSize + 6,
                  fontWeight: FontWeight.bold,
                  color: widget.highContrast ? Colors.yellow : Colors.blue[700],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Niveau',
                style: TextStyle(
                  fontSize: widget.fontSize,
                  color: widget.highContrast ? Colors.white : Colors.grey[600],
                ),
              ),
              Text(
                '$level',
                style: TextStyle(
                  fontSize: widget.fontSize + 6,
                  fontWeight: FontWeight.bold,
                  color: widget.highContrast ? Colors.yellow : Colors.blue[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea() {
    if (showingSequence) {
      return Container(
        height: 200,
        child: Center(
          child: currentDisplayIndex > 0 && currentDisplayIndex <= currentSequence.length
              ? Text(
                  currentSequence[currentDisplayIndex - 1],
                  style: TextStyle(
                    fontSize: widget.fontSize + 12,
                    fontWeight: FontWeight.bold,
                    color: widget.highContrast ? Colors.yellow : Colors.blue[800],
                  ),
                )
              : Text(
                  'Mémorisez la séquence...',
                  style: TextStyle(
                    fontSize: widget.fontSize + 4,
                    color: widget.highContrast ? Colors.white : Colors.grey[600],
                  ),
                ),
        ),
      );
    } else if (inputPhase) {
      return Container(
        height: 200,
        child: Column(
          children: [
            Text(
              'Reproduisez la séquence:',
              style: TextStyle(
                fontSize: widget.fontSize + 2,
                fontWeight: FontWeight.bold,
                color: widget.highContrast ? Colors.white : Colors.blue[800],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: userInput.map((item) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: widget.highContrast ? Colors.yellow : Colors.blue[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        color: widget.highContrast ? Colors.black : Colors.blue[800],
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(
            color: widget.highContrast ? Colors.yellow : Colors.blue,
          ),
        ),
      );
    }
  }

  Widget _buildInputArea() {
    List<String> options = [];
    
    switch (widget.gameType) {
      case GameType.words:
        options = wordsDatabase.take(12).toList();
        break;
      case GameType.numbers:
        options = List.generate(12, (index) => (index + 1).toString());
        break;
      case GameType.mixed:
        options = [
          ...wordsDatabase.take(6),
          ...List.generate(6, (index) => (index + 1).toString())
        ];
        break;
    }
    
    options.shuffle();

    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () => _addToUserInput(options[index]),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.highContrast ? Colors.yellow : Colors.blue[600],
              foregroundColor: widget.highContrast ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              options[index],
              style: TextStyle(
                fontSize: widget.fontSize - 2,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    displayTimer?.cancel();
    super.dispose();
  }
}

