import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmmmm/l10n/app_localizations.dart';

import '../../../manual_entry/presentation/screens/manual_entry_screen.dart';
import 'pdf_pages_screen.dart';

class ScanDocumentScreen extends StatefulWidget {
  const ScanDocumentScreen({super.key});

  @override
  State<ScanDocumentScreen> createState() => _ScanDocumentScreenState();
}

class _ScanDocumentScreenState extends State<ScanDocumentScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<File> _selectedImages = [];
  File? _selectedPdf;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanTitle),
        actions: [
          if (_selectedImages.isNotEmpty || _selectedPdf != null)
            TextButton(
              onPressed: _clearSelection,
              child: Text(l10n.scanClearSelection),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.scanSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _ActionCard(
              icon: Icons.camera_alt_outlined,
              title: l10n.scanFromCamera,
              subtitle: l10n.scanFromCameraHint,
              onTap: _captureFromCamera,
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.photo_library_outlined,
              title: l10n.scanFromGallery,
              subtitle: l10n.scanFromGalleryHint,
              onTap: _pickFromGallery,
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.picture_as_pdf_outlined,
              title: l10n.scanFromPdf,
              subtitle: l10n.scanFromPdfHint,
              onTap: _pickPdf,
            ),
            const SizedBox(height: 20),
            if (_selectedImages.isNotEmpty)
              _ImageSelectionGrid(
                images: _selectedImages,
                onRemove: _removeImage,
              ),
            if (_selectedPdf != null)
              _PdfCard(
                fileName: _selectedPdf!.path.split(Platform.pathSeparator).last,
              ),
            if (_selectedImages.isNotEmpty || _selectedPdf != null) ...[
              const SizedBox(height: 12),
              Text(
                _selectedImages.isNotEmpty
                    ? l10n.scanSelectedImages(_selectedImages.length)
                    : l10n.scanSelectedPdf,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _continueToManualEntry,
                  child: Text(l10n.scanContinue),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _captureFromCamera() async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (file == null) {
        return;
      }
      setState(() {
        _selectedPdf = null;
        _selectedImages.add(File(file.path));
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final files = await _imagePicker.pickMultiImage(imageQuality: 85);
      if (files.isEmpty) {
        return;
      }
      setState(() {
        _selectedPdf = null;
        _selectedImages.addAll(files.map((file) => File(file.path)));
      });
    } catch (error) {
      _showError(error.toString());
    }
  }

  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result == null || result.files.single.path == null) {
        return;
      }
      final pdfFile = File(result.files.single.path!);
      if (!mounted) {
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PdfPagesScreen(pdfFile: pdfFile),
        ),
      );
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _removeImage(File file) {
    setState(() {
      _selectedImages.remove(file);
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedImages.clear();
      _selectedPdf = null;
    });
  }

  void _continueToManualEntry() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ManualEntryScreen(
          attachmentImages: _selectedImages,
          attachmentPdf: _selectedPdf,
        ),
      ),
    );
  }

  void _showError(String message) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.scanError(message))),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageSelectionGrid extends StatelessWidget {
  const _ImageSelectionGrid({required this.images, required this.onRemove});

  final List<File> images;
  final ValueChanged<File> onRemove;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final file = images[index];
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                file,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: InkWell(
                onTap: () => onRemove(file),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PdfCard extends StatelessWidget {
  const _PdfCard({required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf, size: 36, color: Colors.redAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                fileName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
