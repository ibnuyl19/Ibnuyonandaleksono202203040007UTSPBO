import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  final String apiUrl = 'https://pokeapi.co/api/v2/pokemon?limit=20'; // Mengambil 20 Pokémon

  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> results = jsonResponse['results'];

      // Mendapatkan detail setiap Pokémon
      List<Pokemon> pokemons = [];
      for (var result in results) {
        final detailResponse = await http.get(Uri.parse(result['url']));
        if (detailResponse.statusCode == 200) {
          final detailJson = json.decode(detailResponse.body);
          pokemons.add(Pokemon.fromJson(detailJson));
        }
      }
      return pokemons;
    } else {
      throw Exception('Failed to load pokemons');
    }
  }
}
