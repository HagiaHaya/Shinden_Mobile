import 'package:flutter/material.dart';

String getChangelog() {
  List<String> logs = [
    'Wersja: 1.0.8+9',
    '- Przebudowano wygląd karty Pobrane',
    '- Przebudowano stronę główną (znowu)',
    ' ',
    'Wersja: 1.0.7+8',
    '- Pobieranie filmów jest bardziej czytelne',
    '- Naprawiono wyszukiwanie poprzez kilka gatunków',
    '- Przebudowanie drawera',
    '- Dodanie funkcjonalnych tagów do wybranego anime',
    '- Przebudowanie strony głównej',
    '- Uzupełnienie powiązanych',
    '- Naprawiono problem z wygaszającym się ekranem',
    ' ',
    'Wersja: 1.0.6+7',
    '- Widok anime ładuje się automatycznie zgodnie z stronami',
    '- Dodano obsługę CDA',
    '- Dodano obsługę VK',
    '- Przebudowano wygląd strony głównej',
    '- Przebudowano system wyświetlania anime',
    '- Przebudowano okno wyszukiwania anime',
    '- Przebudowano system opisu anime',
    '- Wdrożono początki pobierania anime',
    ' ',
    'Wersja: 1.0.5+6',
    '- Wprowadzono API do logowania',
    '- Naprawiono wyświetlanie obrazów',
    '- Dodano obsługę każdej jakości OpenLoad',
    '- Dodano obsługę MP4Upload',
    '- Wprowadzono automatyczne logowanie',
    ' ',
    'Podziękowania dla: ',
    '- XopyIP za ogarnięcie tego wszystkiego',
    '- SmutnyTomek za testowanie aplikacji',
  ];
  String ret = "";
  for (int i = 0; i < logs.length; i++) {
    ret += logs[i] + "\r\n";
  }
  return ret;
}

Text generateChangelog() {
  return Text(getChangelog(),
      style: TextStyle(
        color: Colors.white70,
        fontSize: 15.0,
      ));
}
//TODO: Dodawanie do ulubionych
//TODO: Ładowanie ulubionych
//TODO: Dodanie statystyk anime - user-userpage
