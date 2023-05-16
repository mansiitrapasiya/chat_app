import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class Pdffilee extends StatefulWidget {
  final String path;
  const Pdffilee({super.key, required this.path});

  @override
  State<Pdffilee> createState() => _PdffileeState();
}

class _PdffileeState extends State<Pdffilee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const PDF(
        swipeHorizontal: true,
      ).cachedFromUrl(widget.path),
    );
  }
}
