import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mmmmm/core/ocr/ocr_parser.dart';
import 'package:mmmmm/core/ocr/ocr_service.dart';
import 'package:mmmmm/features/manual_entry/presentation/screens/manual_entry_screen.dart';
import 'package:mmmmm/l10n/app_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class PdfPagesScreen extends StatefulWidget {
  const PdfPagesScreen({super.key, required this.pdfFile});

  final File pdfFile;

  @override
  State<PdfPagesScreen> createState() => _PdfPagesScreenState();
}

class _PdfPagesScreenState extends State<PdfPagesScreen> {
  late final OcrService _ocrService;
  final List<_PdfPageItem> _pages = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ocrService = OcrService();
    _loadPages();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pdfReviewTitle),
      ),
      body: SafeArea(
        child: _isLoading
            ? _LoadingState(message: l10n.pdfReviewProcessing)
            : _error != null
                ? _ErrorState(message: _error!)
                : _pages.isEmpty
                    ? _EmptyState(message: l10n.pdfReviewNoPages)
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _pages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final page = _pages[index];
                          return _PdfPageCard(
                            index: index + 1,
                            page: page,
                            onOpen: () => _openEntry(context, page),
                          );
                        },
                      ),
      ),
    );
  }

  Future<void> _loadPages() async {
    try {
      final document = await PdfDocument.openFile(widget.pdfFile.path);
      final tempDir = await getTemporaryDirectory();
      final items = <_PdfPageItem>[];
      for (var i = 1; i <= document.pagesCount; i++) {
        final page = await document.getPage(i);
        const targetWidth = 1200.0;
        final targetHeight = page.height / page.width * targetWidth;
        final pageImage = await page.render(
          width: targetWidth,
          height: targetHeight,
          format: PdfPageImageFormat.png,
        );
        if (pageImage == null) {
          throw Exception('Failed to render PDF page.');
        }
        final file = File(
          p.join(
            tempDir.path,
            'pdf_page_${DateTime.now().millisecondsSinceEpoch}_$i.png',
          ),
        );
        await file.writeAsBytes(pageImage.bytes, flush: true);
        await page.close();

        final ocrResult = await _ocrService.recognize([file]);
        items.add(
          _PdfPageItem(
            imageFile: file,
            ocrResult: ocrResult,
          ),
        );
      }
      await document.close();
      if (!mounted) {
        return;
      }
      setState(() {
        _pages
          ..clear()
          ..addAll(items);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  void _openEntry(BuildContext context, _PdfPageItem page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ManualEntryScreen(
          attachmentImages: [page.imageFile],
          prefillOcr: page.ocrResult,
        ),
      ),
    );
  }
}

class _PdfPageItem {
  const _PdfPageItem({
    required this.imageFile,
    required this.ocrResult,
  });

  final File imageFile;
  final OcrResult ocrResult;
}

class _PdfPageCard extends StatelessWidget {
  const _PdfPageCard({
    required this.index,
    required this.page,
    required this.onOpen,
  });

  final int index;
  final _PdfPageItem page;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.pdfReviewPageLabel(index),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                page.imageFile,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (page.ocrResult.invoiceNumber != null)
                  _InfoChip(
                    label: l10n.manualEntryOcrInvoice(page.ocrResult.invoiceNumber!),
                  ),
                if (page.ocrResult.date != null)
                  _InfoChip(
                    label: l10n.manualEntryOcrDate(
                      MaterialLocalizations.of(context)
                          .formatShortDate(page.ocrResult.date!),
                    ),
                  ),
                if (page.ocrResult.totalAmount != null)
                  _InfoChip(
                    label: l10n.manualEntryOcrTotal(page.ocrResult.totalAmount!),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onOpen,
                child: Text(l10n.pdfReviewOpenEntry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F1FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF3B6AF6),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(message),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, textAlign: TextAlign.center),
    );
  }
}

