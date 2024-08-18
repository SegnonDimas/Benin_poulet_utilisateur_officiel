import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();
  var etat;
  int aleatoir = 0;
  int nombreEssai = 5;
  bool trouver = false;
  bool value = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    etat = Flash.on;
    aleatoir = 85;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: value ? Colors.white : Colors.grey.shade900,
        appBar: AppBar(
          // primary: false,
          leading: CupertinoSwitch(
              thumbColor: Colors.grey,
              trackColor: Colors.black,
              value: value,
              activeColor: Colors.white,
              onChanged: (bool value) {
                setState(() {
                  this.value = value;
                });
              }),
          title: AppText(
            text: "Codeur Plus...",
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          centerTitle: true,
          actions: [
            const Icon(
              Icons.flash_on_outlined,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                height: 35,
                width: 60,
                decoration: BoxDecoration(
                  color: value ? Colors.white : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: AppText(
                  text: "$nombreEssai",
                  fontSize: 25,
                  color: value ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: nombreEssai > 0
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    trouver ? Icons.done : Icons.question_mark,
                    color: trouver ? Colors.green : Colors.red,
                    size: 80,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 90,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: AppText(
                      text: trouver
                          ? "$aleatoir"
                          : nombreEssai == 0
                              ? "Ouf, GAME OVER"
                              : "* * *",
                      fontSize: 35,
                    ),
                  ),
                  AppText(
                    text: trouver
                        ? "Bravo, vous avez trouvé ..."
                        : 'Devinez le nombre magique',
                    overflow: TextOverflow.fade,
                    fontSize: 30,
                    textAlign: TextAlign.center,
                    color: !value ? Colors.white : Colors.black,
                  ),
                  TextFormField(
                    obscureText: false,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    //onChanged: widget.onChanged,
                    //onTap: widget.onTap,
                    //readOnly: widget.readOnly!,
                    style: TextStyle(
                        color: trouver ? Colors.green : Colors.red,
                        fontSize: 25),
                    decoration: const InputDecoration(
                      fillColor: Colors.black,
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.keyboard,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                    onFieldSubmitted: (String nombreEntre) {
                      if (nombreEntre == "$aleatoir") {
                        setState(() {
                          trouver = true;
                        });
                      } else {
                        setState(() {
                          trouver = false;
                          nombreEssai--;
                        });
                      }
                    },
                  ),
                  const Divider(),
                ],
              ))
            : Center(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        nombreEssai = 5;
                        controller.clear();
                      });
                    },
                    child: AppText(
                      text: 'Ouf, GAME OVER\nReprendre',
                      textAlign: TextAlign.center,
                      fontSize: 30,
                      color: Colors.red,
                    )),
              ),
      ),
    );
  }
}

enum Flash { on, off, auto }
