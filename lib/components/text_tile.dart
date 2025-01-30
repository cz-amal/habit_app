import 'package:flutter/material.dart';
class TextTile extends StatefulWidget {
  final String text;
  const TextTile({super.key,required this.text});

  @override
  State<TextTile> createState() => _TextTileState();
}

class _TextTileState extends State<TextTile> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[900]),
      child: Text(
        widget.text,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );
  }
}
