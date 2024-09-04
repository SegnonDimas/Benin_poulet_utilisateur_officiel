import 'package:flutter/material.dart';

class SliverAppBarTest extends StatefulWidget {
  const SliverAppBarTest({super.key});

  @override
  State<SliverAppBarTest> createState() => _SliverAppBarTestState();
}

class _SliverAppBarTestState extends State<SliverAppBarTest> {
  ScrollController controller = ScrollController();

  List<String> text = [
    'Text 0',
    'Text 1',
    'Message 2',
    'Text 3',
    'Parole 4',
    'Text 5',
    'Text 16',
    'Écrit 7',
    'Text 8',
    'Text 91',
  ];
  List<String> list = [];

  @override
  Widget build(BuildContext context) {
    List<String> list = text;
    return SafeArea(
      child: Scaffold(
          body: Wrap(
              children: List.generate(text.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [ChoiceChip(label: Text('label'), selected: true)],
          ) /*Chip(
            avatar: const Icon(Icons.account_circle),
            backgroundColor: Colors.blue,
            label: AppText(text: list[index]),
            deleteIcon: const Icon(
              Icons.close_rounded,
              color: Colors.black,
            ),
            onDeleted: () {
              setState(() {
                list.removeWhere((contain) {
                  return list[index].contains('Text') ? true : false;
                });
              });
            },
          )*/
          ,
        );
      }))),
    );
  }
}
