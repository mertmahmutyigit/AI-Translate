import 'package:ai/screens/settingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ai/utility/dil_secimi.dart';
import 'package:ai/utility/translate_metini.dart';
import 'package:ai/utility/translate_ceviri.dart';

class PromptScreen extends StatefulWidget {
  final VoidCallback showHomeScreen;

  const PromptScreen({super.key, required this.showHomeScreen});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  // Değişkenler
  String? selectedCountryFrom;
  String? selectedCountryTo;
  TextEditingController controller = TextEditingController();
  String _translatedText = '';
  bool _loading = false;

  // Kaydedilen dil seçimlerini güncelleme işlevi
  void _handleLanguageChangeFrom(String? newCountry) {
    setState(() {
      selectedCountryFrom = newCountry;
    });
  }

  // Kaydedilen dil seçimlerini güncelleme işlevi
  void _handleLanguageChangeTo(String? newCountry) {
    setState(() {
      selectedCountryTo = newCountry;
    });
  }

  Future<void> _translateText() async {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('API_KEY ortam değişkeni bulunamadı');
      return;
    }

    final inputText = controller.text;
    final fromLang = selectedCountryFrom;
    final toLang = selectedCountryTo;

    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ne çeviriyorsunuz?')),
      );
      return; }

    if (fromLang == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hangi dilden çeviri yapıyorsunuz?')),
      );
      return;
    }

    if (toLang == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hangi dile çeviri yapıyorsunuz?')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [
        Content.text('Sadece "$inputText" metnini $fromLang dilinden $toLang diline çevirin')
      ];
      final response = await model.generateContent(content);

      setState(() {
        _translatedText = response.text!;
      });

      print('$_translatedText');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Metin çevirisi başarısız oldu')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),

      // İçerik etrafında boşluk
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Metin çevirisi ve text_field simgesi için kap
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF6D1B7B).withOpacity(0.8),
                    width: 0.2,
                  ),
                ),
              ),
              child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
  // Metin çevirisi
  Text(
    "Metin Çevirisi",
    style: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w300,
      color: const Color(0xFF000000),
    ),
  ),
  // Ayarlar butonu
 IconButton(
                    icon: Icon(Icons.settings),
                    color: const Color(0xFF000000),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
],
              ),
            ),

           
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  // Dilden dil seçimi
                  Expanded(
                    flex: 1,
                    child: LanguageDropdown(
                      onLanguageChanged: _handleLanguageChangeFrom,
                    ),
                  ),
                  Icon(
                    Icons.swap_horiz_rounded,
                    color: const Color(0xFF6D1B7B).withOpacity(0.3),
                    size: 20.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: LanguageDropdown(
                      onLanguageChanged: _handleLanguageChangeTo,
                    ),
                  ),
                ],
              ),
            ),

            // Seçilen dilden çeviri için etrafında boşluk
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        height: 1.4,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Çevrilecek Dilden ',
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        if (selectedCountryFrom != null)
                          TextSpan(
                            text: '$selectedCountryFrom',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF000000),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Çevrilecek metin için kap
            Container(
              width: double.infinity,
              height: 180.0,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: const Color(0xFFFFFFFF),
                border: Border.all(
                  color: const Color(0xFF6D1B7B).withOpacity(0.8),
                  width: 0.2,
                ),
              ),
              child: TranslateFrom(controller: controller),
            ),

            // Seçilen dile çeviri için etrafında boşluk
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        height: 1.4,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Çevrilecek Dile ',
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        if (selectedCountryTo != null)
                          TextSpan(
                            text: '$selectedCountryTo',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF000000),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Çevrilmiş metin için kap
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                width: double.infinity,
                height: 223.0,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(
                    color: const Color(0xFF6D1B7B).withOpacity(0.8),
                    width: 0.2,
                  ),
                ),
                child: _loading
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6D1B7B).withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const CircularProgressIndicator(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      )
                    : TranslateTo(translatedText: _translatedText),
              ),
            ),

            // Çevir düğmesi
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _translateText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6D1B7B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: Text(
                    'Çevir',
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
