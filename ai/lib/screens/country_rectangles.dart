import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class CountryRectangles extends StatefulWidget {
  const CountryRectangles({super.key});

  @override
  State<CountryRectangles> createState() => _CountryRectanglesState();
}

class _CountryRectanglesState extends State<CountryRectangles> {
  final Random random = Random();
  final List<Map<String, String>> countryData = [
   {'countryName': 'Turkey', 'countryImage': 'assets/images/turk.png'},
    {'countryName': 'USA', 'countryImage': 'assets/images/usa.png'},
    {'countryName': 'Russia', 'countryImage': 'assets/images/russia.png'},
    {'countryName': 'Italy', 'countryImage': 'assets/images/italy.png'},
    {'countryName': 'Germany', 'countryImage': 'assets/images/germany.png'},
    {'countryName': 'France', 'countryImage': 'assets/images/france.png'},
    {'countryName': 'China', 'countryImage': 'assets/images/china.png'},
    {'countryName': 'England', 'countryImage': 'assets/images/britain.png'},
    {'countryName': 'Saudi', 'countryImage': 'assets/images/arabic.png'},
   
  ];

  String? selectedCountry;
  Color? backgroundColor;

  @override
  void initState() {
    super.initState();

    _randomize();
  }
  void _randomize() {
    setState(() {
      selectedCountry =
          countryData[random.nextInt(countryData.length)]['countryName'];
      backgroundColor =
          Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _randomize();
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 sütunlu düzen
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 2.0, // Kartların en boy oranı
        ),
        itemCount: countryData.length,
        itemBuilder: (context, index) {
          final country = countryData[index];
          bool isSelected = country['countryName'] == selectedCountry;
          return Card(
            elevation: 4,
            color: isSelected ? backgroundColor : const Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: isSelected
                    ? Colors.transparent
                    : const Color(0xFF6D1B7B).withOpacity(0.8),
                width: 0.4,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 15.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    country['countryImage']!,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    country['countryName']!,
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                      color: isSelected
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
