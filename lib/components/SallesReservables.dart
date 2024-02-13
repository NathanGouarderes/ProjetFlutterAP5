import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projetflutterap5/service/FetchDatas.dart';

class SallesReservables extends StatefulWidget {
  const SallesReservables({super.key});

  @override
  State<SallesReservables> createState() => _SallesReservablesState();
}

class _SallesReservablesState extends State<SallesReservables> {
  late Future<Response> futureSalles;
  late Future<Response> futureClasse;

  @override
  void initState() {
    super.initState();
    futureSalles = FetchData().getSalle();
    futureClasse = FetchData().getClasse();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([futureSalles, futureClasse]),
      builder: (context, AsyncSnapshot<List<Response>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          var responseSalle = snapshot.data![0].data;
          var responseClasse = snapshot.data![1].data;
          List<dynamic> classeFiltree = List<dynamic>.from(responseClasse);
          List<dynamic> salleFiltree = List<dynamic>.from(responseSalle);
          bool conditionRemplie = false;

          return ElevatedButton(
            onPressed: () async {
              for (var classe in classeFiltree) {
                for (var salle in salleFiltree) {
                  if (classe['classe'].startsWith("AP") && !classe['classe'].endsWith("3")) {
                    if (salle["nom"].startsWith("J-2") && salle["reserve"] == false && salle['type'] != "Réunion") {
                      //print("La classe ${classe["classe"]} peut aller dans la salle ${salle["nom"]} ayant l'ID ${salle["id"]}. La valeur de reserve est : ${salle['reserve']}");
                      //await FetchData().updateReserveStatus(salle['id'], true);
                      await FetchData().testReservationPar(salle['id'], true, classe['classe'], 4, 4);
                      var updatedSalleData = await FetchData().getSalle();
                      var updatedSalleList = List<dynamic>.from(updatedSalleData.data);
                      salleFiltree = updatedSalleList;
                      setState(() {});
                      break;
                    }
                  }
                  else{
                    if(classe['classe'].startsWith("AD")){
                      if(!salle['nom'].startsWith("J-2") && salle['reserve'] == false && salle['type'] != "Réunion"){
                        //print("${classe['classe']} dans ${salle['nom']}");
                        FetchData().testReservationPar(salle['id'], true, classe['classe'], 4, 4);
                        var updatedSalleData = await FetchData().getSalle();
                        var updatedSalleList = List<dynamic>.from(updatedSalleData.data);
                        salleFiltree = updatedSalleList;
                        setState(() {});
                        break;
                      }
                    }
                    else{
                      if(classe['classe'].startsWith("CIR")){
                        if(!salle['nom'].startsWith('J-2') && salle['reserve'] == false){
                          FetchData().testReservationPar(salle['id'], true, classe['classe'], 4, 4);
                          break;
                        }
                      }
                    }
                  }
                }
              }
            },
            child: Text("Réserver les salles filtrées"),
          );
        }
      },
    );
  }
}
