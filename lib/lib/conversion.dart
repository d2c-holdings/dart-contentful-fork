Map<String, dynamic> map(dynamic input) =>
    input is Map<String, dynamic> ? input : Map.castFrom(input);

List<Map<String, dynamic>> listOfMaps(dynamic input) =>
    input is List<Map<String, dynamic>> ? input : List.castFrom(input);
