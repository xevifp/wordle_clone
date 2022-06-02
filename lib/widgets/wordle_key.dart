import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle_clone/providers/game_state_provider.dart';


class WordleKey extends ConsumerWidget {
  final String letter;
  const WordleKey(this.letter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget keyCap;
    double width = 50;
    if (letter == '_'){
      keyCap = Icon(Icons.keyboard_return, size: 32,);
    } else if (letter == '<') {
      keyCap = Icon(Icons.backspace_outlined, size: 32,);
    } else {
      width = 40;
      keyCap = Text(letter, style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold),
      );
    }

    return Container(
      width: width,
      height: 60,
      alignment: Alignment.center,
      //padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: Color.fromARGB(44, 44, 44, 44)
      ),
      child: InkWell(
        onTap: () {
          ref.read(gameStateProvider.notifier).updateCurrentAttempt(letter);
        },
        child: keyCap,
      ),
    );
  }
}