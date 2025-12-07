import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

class CountryService {
  static const String _apiUrl = 'https://restcountries.com/v3.1/all?fields=name,cca2,flags';

  Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Convert JSON to Country objects and sort alphabetically
        final countries = data
            .map((json) => Country.fromJson(json))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
        
        return countries;
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching countries: $e');
    }
  }
}
