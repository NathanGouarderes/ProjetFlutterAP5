import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projetflutterap5/service/FetchDatas.dart';

class SallesReserveesBtn extends StatefulWidget {
  const SallesReserveesBtn({super.key});

  @override
  State<SallesReserveesBtn> createState() => _SallesReserveesBtnState();
}

class _SallesReserveesBtnState extends State<SallesReserveesBtn> {
  late Future<Response> futureSalle;

  @override
  void initState() {
    super.initState();
    futureSalle = FetchData().getSalle();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureSalle,
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        } else {
          var responseSalle = snapshot.data?.data;

          if (responseSalle != null) {
            // Filtrer les salles réservées
            var sallesReservees = responseSalle.where((salle) => salle['reserve'] == true).toList();

            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Mettre à jour les salles réservées (libérer)
                    for (var salle in sallesReservees) {
                      FetchData().updateReserveStatus(salle['id'], false);
                    }

                    // Mettre à jour l'interface
                    setState(() {
                      futureSalle = FetchData().getSalle();
                    });
                  },
                  child: Text("Libérer les salles réservées"),
                ),
                for (var salle in sallesReservees)
                  ElevatedButton(onPressed: () {
                    FetchData().updateReserveStatus(salle["id"], false);
                    print("l'ID de la salle réservée est ${salle["id"]}");
                  },
                      child: Text("La salle ${salle["nom"]} est réservée"),
                  ),
              ],
            );
          }

          return ElevatedButton(
            onPressed: () {
              // ... Le reste de votre logique
            },
            child: Text("Afficher les salles réservées"),
          );
        }
      },
    );
  }
}