import 'package:flutter/material.dart';
import 'package:projetflutterap5/components/AffichageClasse.dart';
import 'package:projetflutterap5/components/BarreRecherche.dart';
import 'package:projetflutterap5/components/SallesReservables.dart';
import 'package:projetflutterap5/components/SallesReserveesBtn.dart';
import 'package:projetflutterap5/components/TestComponent.dart';
import 'package:projetflutterap5/service/FetchDatas.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedClasse = "";
  FetchData fetchData = FetchData();

  void onDataChanged(String data) {
    setState(() {
      selectedClasse = data;
      print("Putain mais là ça dois se mettre à jour");
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchData.getSalle();
    fetchData.getClasse();
    return Scaffold(
      body: Column(
        children: [
          BarreRecherche(onSelectionChanged: onDataChanged),
          Expanded(
              child: Column(
                children: [
                  //TestComponent(),
                  SallesReserveesBtn(),
                  Expanded(
                      child: SallesReservables()
                  ),
                  Expanded(
                      child: AffichageClasse(key: Key(selectedClasse), selectedClasse: selectedClasse)
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}