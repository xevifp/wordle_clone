

import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle_clone/data/wordle_repo.dart';
import 'package:wordle_clone/providers/game_settings_provider.dart';


/*
A: unused
B: invalid
C: 
D:

*/

class GameState {
  final GameSettings settings;
  final List<String> validWords;
  final String correctWord; 
  final List<String> attempts;
  final int attempted;
  

  const GameState(
    {required this.validWords, 
    required this.correctWord, 
    required this.settings,
    required this.attempts,
    required this.attempted,
    });

  GameState clone(
    {List<String>? validWords, 
    String? correctWord, 
    List<String>? attempts, 
    int? attempted}){
    return GameState(
      validWords: validWords ?? this.validWords, 
      correctWord: correctWord ?? this.correctWord, 
      settings: this.settings, 
      attempted: attempted ?? this.attempted,
      attempts: attempts ?? this.attempts, 
      );
  }
}

class GameStateNotifier extends StateNotifier<GameState>{
  final Random rng = Random();

  GameStateNotifier(GameSettings settings) 
    :super(GameState(
      validWords: [], 
      correctWord: 'begin', 
      settings: settings, 
      attempts: [], 
      attempted: 0));

  Future<void> updateWords() async{
    final words = await loadWords(state.settings.wordsize);
    state = state.clone(
      validWords: words,
      correctWord: words[rng.nextInt(words.length -1)]
      );
    
  }   

  void newCorrectword(){
    state = state.clone(
      correctWord: state.validWords[rng.nextInt(state.validWords.length -1)]
    );
  }

  void updateCurrentAttempt(String key){
    final attempts = state.attempts;
      if (attempts.length <= state.attempted){  
        attempts.add('');   
      }   
    var currentAttempt = attempts[state.attempted];
    if (key == '_'){ // handle enter press

      if (currentAttempt.length < state.settings.wordsize){
        print('Paraula incompleta, presta atenció');
        return;
      }

      state = state.clone(
        attempted: state.attempted +1
      );


    } else if (key == '<'){ // handle backpress  
      if (currentAttempt.isEmpty){
        print('No es pot borrar un espai buit');
        return;
      }
      currentAttempt = currentAttempt.substring(0, currentAttempt.length -1);
      attempts[state.attempted] = currentAttempt;
      state = state.clone(
        attempts: attempts
      );
    } else {      
      if (currentAttempt.length >= state.settings.wordsize){
        print("t'has passat de lletres");
        return;
      }
      currentAttempt += key;
      attempts[state.attempted] = currentAttempt;
      state = state.clone(
        attempts: attempts
      );

    }

  }



}


final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref){
  final settings = ref.watch(gameSettingsProvider);
  final gameStateNotifier = GameStateNotifier(settings);
  gameStateNotifier.updateWords();
  return gameStateNotifier;
});