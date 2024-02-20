import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String name) async {
  final response = await http.get(Uri.parse('https://swapi.dev/api/people/?search=$name'),

    
  
  );

 
  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['results'].isEmpty) {
      throw Exception('No character found with that name');
    }
    return Album.fromJson(jsonResponse['results'][0]);
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load character');
  }
}

class Album {
  final String name;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;

  const Album({required this.name, required this.height, required this.mass, required this.hairColor, required this.skinColor, required this.eyeColor, required this.birthYear, required this.gender});
 

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['name'],
      height: json['height'],
      mass: json['mass'],
      hairColor: json['hair_color'],
      skinColor: json['skin_color'],
      eyeColor: json['eye_color'],
      birthYear: json['birth_year'],
      gender: json['gender'],
    );
  }

}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              final name = _controller.text.trim();
              if (name.isNotEmpty) {
                _futureAlbum = createAlbum(name);
              }
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {

          return Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${snapshot.data!.name}'),
              Text('Height: ${snapshot.data!.height}'),
              Text('Mass: ${snapshot.data!.mass}'),
              Text('Hair Color: ${snapshot.data!.hairColor}'),
              Text('Skin Color: ${snapshot.data!.skinColor}'),
              Text('Eye Color: ${snapshot.data!.eyeColor}'),
              Text('Birth Year: ${snapshot.data!.birthYear}'),
              Text('Gender: ${snapshot.data!.gender}'),
            ],
          );
        } else {
          return const Text('No data');
        }
      },
    );
  }
}
