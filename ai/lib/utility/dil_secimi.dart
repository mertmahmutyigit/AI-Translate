import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageDropdown extends StatefulWidget {
  final ValueChanged<String?> onLanguageChanged;

  const LanguageDropdown({Key? key, required this.onLanguageChanged})
      : super(key: key);

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  final List<Map<String, String>> languageData = [
    {
      'countryLanguage': 'İngilizce - ABD',
      'countryImage': 'assets/images/usa.png'
    },
    {'countryLanguage': 'Türkçe', 'countryImage': 'assets/images/turk.png'},
    {
      'countryLanguage': 'İngilizce - İngiltere',
      'countryImage': 'assets/images/britain.png'
    },
    {'countryLanguage': 'Rusça', 'countryImage': 'assets/images/russia.png'},
    {'countryLanguage': 'İtalyanca', 'countryImage': 'assets/images/italy.png'},
    {'countryLanguage': 'Almanca', 'countryImage': 'assets/images/germany.png'},
    {'countryLanguage': 'Fransızca', 'countryImage': 'assets/images/france.png'},
    {'countryLanguage': 'İspanyolca', 'countryImage': 'assets/images/spain.png'},
  ];

  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xFFFFFFFF),
        border: Border.all(
          color: const Color(0xFF6D1B7B).withOpacity(0.8),
          width: 0.1,
        ),
      ),
      child: DropdownButton<String>(
        value: selectedCountry,
        hint: Text(
          "Dil Seçimi",
          style: GoogleFonts.poppins(
            fontSize: 14.0,
            color: const Color(0xFF000000),
          ),
        ),
        icon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFF6D1B7B).withOpacity(0.3),
          ),
        ),
        underline: Container(
          color: Colors.transparent,
        ),
        dropdownColor: const Color(0xFFFFFFFF),
        isExpanded: true, // Dropdown menünün genişliğini ayarla
        items: languageData.map((country) {
          return DropdownMenuItem<String>(
            value: country['countryLanguage'],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    country['countryImage']!,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded( // Metni sarmalayarak taşmayı önle
                  child: Text(
                    country['countryLanguage']!,
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: selectedCountry == country['countryLanguage']
                          ? const Color(0xFF000000)
                          : const Color(0xFF6D1B7B).withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedCountry = newValue;
          });
          widget.onLanguageChanged(newValue);
        },
      ),
    );
  }
}
