import 'package:dio/dio.dart';

class FetchData {
  final dio = Dio();

  Future<Response> getSalle() async {
    final response = await dio.get("http://localhost:3333/api/toutesSalles/");
    //print('Salles : $response');
    return response;
  }

  Future<Response> getClasse() async {
    final response = await dio.get("http://localhost:3333/api/classe/");
    //print('classe : $response');
    return response;
  }



  Future<Response> updateReserveStatus(int id, bool reserveStatus) async {
    try {
      final response = await dio
          .post("http://localhost:3333/api/salles/$id/updateReserve", data: {
        "reserve": reserveStatus,
      });
      print("Status code : ${response.statusCode}");
      if (response.statusCode == 200) {
        print('La valeur de reserve a été mise à jour avec succès');
      } else if (response.statusCode == 404) {
        print('La salle n\'a pas été trouvée');
      } else {
        print('Erreur inattendue: ${response.statusCode}');
      }
      return response;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<Response> testReservationPar(int id, bool reservationStatus, String classe, int duree, int heureDebut) async{
    try{
      final response = await dio.post("http://localhost:3333/api/salles/${id}/reserve", data: {
        "reserve" : reservationStatus,
        "reservePar" : classe,
        "duree" : duree,
        "heureDebut" : heureDebut
      });
      //print("La réservation pour l'URL '/api/salles/${id}/reserve' a le code ${response.statusCode}");
      if (response.statusCode == 200) {
        //print('La valeur de reserve a été mise à jour avec succès');
      } else if (response.statusCode == 404) {
        print('La salle n\'a pas été trouvée');
      } else {
        print('Erreur inattendue: ${response.statusCode}');
      }
      return response;
    }
    catch(error){
      print(error);
      rethrow;
    }
  }

}