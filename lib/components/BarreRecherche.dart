import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projetflutterap5/service/FetchDatas.dart';
class BarreRecherche extends StatefulWidget {
  final Function(String) onSelectionChanged;

  const BarreRecherche({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  State<BarreRecherche> createState() => _BarreRechercheState();
}

class _BarreRechercheState extends State<BarreRecherche> {
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
    return FutureBuilder(
        future: Future.wait([futureClasse, futureSalle]),
        builder: (context, AsyncSnapshot<List<Response>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          } else {
            var responseDataClasse = snapshot.data![0].data;
            var responseDataSalle = snapshot.data![1].data;
            List<String> listClasse = [];
            for(var classe in responseDataClasse){
              listClasse.add(classe['classe']);

            }
            print(listClasse);
            String dropdownValue = listClasse.first;
            return DropdownButton(
                value: dropdownValue,
                items: listClasse.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value! ?? '';
                    print(dropdownValue);
                    widget.onSelectionChanged(dropdownValue);
                  });
                });
          }
        });

  }
}