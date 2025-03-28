import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TranslateFrom extends StatefulWidget {
  final TextEditingController controller;
  const TranslateFrom({super.key, required this.controller});

  @override
  State<TranslateFrom> createState() => _TranslateFromState();
}

class _TranslateFromState extends State<TranslateFrom> {
  int _wordCount = 0;
  final int _wordLimit = 50;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateWordCount);
  }

  void _updateWordCount() {
    final text = widget.controller.text;
    setState(() {
      _wordCount = _countWords(text);
      if (_wordCount > _wordLimit) {
        widget.controller.value = widget.controller.value.copyWith(
          text: _truncateTextToWordLimit(text, _wordLimit),
          selection: TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length),
          ),
        );
        _wordCount = _wordLimit;
      }
    });
  }

  int _countWords(String text) {
    if (text.isEmpty) {
      return 0;
    }
    final words = text.trim().split(RegExp(r'\s+'));
    return words.length;
  }

  String _truncateTextToWordLimit(String text, int wordLimit) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length <= wordLimit) {
      return text;
    }
    return words.take(wordLimit).join(' ');
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateWordCount);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              controller: widget.controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Çevrilecek bir şeyiniz mi var?',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 28.0,
                  color: const Color(0xFF6D1B7B).withOpacity(0.1),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelStyle: GoogleFonts.poppins(
                  color: const Color(0xFF000000),
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 12.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xFF6D1B7B).withOpacity(0.8),
                  width: 0.2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_wordCount/$_wordLimit kelime',
                  style: GoogleFonts.poppins(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
