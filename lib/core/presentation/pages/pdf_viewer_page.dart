import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';

class PdfViewerPage extends StatelessWidget {
  final String title;
  final String assetPath;

  const PdfViewerPage({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.lightIconPrimary,
            size: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          // On utilise le style du corps en plus grand/gras si h3 n'est pas dispo
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      // Le composant SfPdfViewer gère le zoom et le scroll nativement
      body: SfPdfViewer.asset(assetPath),
    );
  }
}