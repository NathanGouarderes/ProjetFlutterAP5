import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projetflutterap5/components/BarreRecherche.dart';
import 'package:projetflutterap5/service/FetchDatas.dart';

class AffichageClasse extends StatefulWidget {
  final String selectedClasse;

  const AffichageClasse({Key? key, required this.selectedClasse})
      : super(key: key);


  @override
  State<AffichageClasse> createState() => _AffichageClasseState();
}

class _AffichageClasseState extends State<AffichageClasse> {
  late Future<Response> futureClasse;
  late Future<Response> futureSalle;

  @override
  void initState() {
    super.initState();
    futureClasse = FetchData().getClasse();
    futureSalle = FetchData().getSalle();
  }

  @override
  Widget build(BuildContext context) {
    // Utilisez la valeur sélectionnée ici
    print("Selected Classe: ${widget.selectedClasse}");

    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([futureClasse, futureSalle]),
        builder: (context, AsyncSnapshot<List<Response>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          } else {
            var responseDataClasse = snapshot.data![0].data;
            var responseDataSalle = snapshot.data![1].data;

            return ListView.builder(
              itemCount: responseDataClasse.length,
              itemBuilder: (BuildContext context, int index) {
                var classe = responseDataClasse[index];
                List<Widget> salleWidgets = [];

                for (var salle in responseDataSalle) {
                  if (classe['nombre'] < salle['places'] && salle['reserve'] == false) {
                    if (widget.selectedClasse.isNotEmpty &&
                        widget.selectedClasse == classe['classe']) {
                      //print("La salle ${classe['classe']} rentre dans la salle ${salle['nom']}");
                      salleWidgets.add(
                        ElevatedButton(
                          child: Text(
                              "La salle ${classe['classe']} rentre dans la salle ${salle['nom']}"),
                          onPressed: () {
                            print("L'ID est : ${salle['id']}");
                            if (salle['reserve'] == true) {
                              FetchData().updateReserveStatus(salle['id'], false);
                            } else {
                              FetchData().updateReserveStatus(salle['id'], true);
                            }
                            // Mettez à jour l'état après la réservation
                            setState(() {
                              futureClasse = FetchData().getClasse();
                              futureSalle = FetchData().getSalle();
                            });
                          },
                        ),
                      );
                    }
                  }
                }

                return Container(
                  child: Column(
                    children: salleWidgets.isEmpty
                        ? [
                      Text('Aucune salle ne convient à la classe ${classe['classe']}'),
                    ]
                        : salleWidgets,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}