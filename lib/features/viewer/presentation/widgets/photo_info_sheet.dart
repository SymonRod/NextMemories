import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/photo_info_model.dart';
import '../providers/photo_info_provider.dart';

class PhotoInfoSheet extends ConsumerWidget {
  final int fileId;
  const PhotoInfoSheet({super.key, required this.fileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(photoInfoProvider(fileId));

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            const _Handle(),
            Expanded(
              child: infoAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Impossibile caricare i metadati: $e'),
                  ),
                ),
                data: (info) => _InfoContent(
                  info: info,
                  scrollController: scrollController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(80),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}

class _InfoContent extends StatelessWidget {
  final PhotoInfoModel info;
  final ScrollController scrollController;

  const _InfoContent({required this.info, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final exif = info.exif;
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        _Section(
          icon: Icons.image_outlined,
          title: 'File',
          rows: [
            _Row('Nome', info.basename),
            if (info.filename != null) _Row('Percorso', info.filename!),
            if (info.size != null)
              _Row('Dimensione', _formatBytes(info.size!)),
            if (info.width != null && info.height != null)
              _Row('Risoluzione', '${info.width} × ${info.height} px'),
            if (info.dateTaken != null)
              _Row('Data', _formatEpoch(info.dateTaken!)),
          ],
        ),
        if (exif != null) ...[
          if (exif.imageDescription != null)
            _Section(
              icon: Icons.notes_outlined,
              title: 'Descrizione',
              rows: [_Row('', exif.imageDescription!)],
            ),
          if (exif.make != null ||
              exif.model != null ||
              exif.software != null)
            _Section(
              icon: Icons.camera_alt_outlined,
              title: 'Camera',
              rows: [
                if (exif.make != null) _Row('Produttore', exif.make!),
                if (exif.model != null) _Row('Modello', exif.model!),
                if (exif.software != null) _Row('Software', exif.software!),
              ],
            ),
          if (exif.fNumber != null ||
              exif.iso != null ||
              exif.exposureTime != null ||
              exif.focalLength != null ||
              exif.exposureBias != null ||
              exif.meteringMode != null ||
              exif.flash != null)
            _Section(
              icon: Icons.tune_outlined,
              title: 'Impostazioni scatto',
              rows: [
                if (exif.fNumber != null)
                  _Row('Apertura', 'f/${_formatDouble(exif.fNumber!)}'),
                if (exif.exposureTime != null)
                  _Row('Tempo di posa', _formatExposure(exif.exposureTime!)),
                if (exif.iso != null)
                  _Row('ISO', exif.iso!.toString()),
                if (exif.focalLength != null)
                  _Row('Focale', '${_formatDouble(exif.focalLength!)} mm'),
                if (exif.exposureBias != null)
                  _Row('Comp. esposizione', '${_formatDouble(exif.exposureBias!)} EV'),
                if (exif.meteringMode != null)
                  _Row('Modalità misurazione', _meteringMode(exif.meteringMode!)),
                if (exif.flash != null)
                  _Row('Flash', _flash(exif.flash!)),
                if (exif.whiteBalance != null)
                  _Row('Bilanciamento bianco', exif.whiteBalance == 0 ? 'Auto' : 'Manuale'),
              ],
            ),
          if (exif.gpsLatitude != null && exif.gpsLongitude != null)
            _Section(
              icon: Icons.location_on_outlined,
              title: 'Posizione GPS',
              rows: [
                _Row('Latitudine', exif.gpsLatitude!.toStringAsFixed(6)),
                _Row('Longitudine', exif.gpsLongitude!.toStringAsFixed(6)),
                if (exif.gpsAltitude != null)
                  _Row('Altitudine', '${exif.gpsAltitude!.round()} m'),
              ],
            ),
        ],
      ],
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  String _formatEpoch(int epoch) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDouble(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  // Tempi brevi (<1s) mostrati come frazione "1/X s", tempi lunghi come "X.X s".
  String _formatExposure(double seconds) {
    if (seconds <= 0) return '$seconds s';
    if (seconds < 1) {
      final denom = (1 / seconds).round();
      return '1/$denom s';
    }
    return '${_formatDouble(seconds)} s';
  }

  String _meteringMode(int mode) => switch (mode) {
        1 => 'Media',
        2 => 'Media centrale',
        3 => 'Spot',
        4 => 'Multi-spot',
        5 => 'Matrix / Pattern',
        6 => 'Parziale',
        _ => 'Sconosciuta',
      };

  // Bit 0 = flash fired; bit 5-4 = strobe return; bit 3-2 = flash mode.
  String _flash(int value) => (value & 0x01) != 0 ? 'Attivato' : 'Non attivato';
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<_Row> rows;

  const _Section({
    required this.icon,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...rows.map((r) => r.build(context)),
        ],
      ),
    );
  }
}

class _Row {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
}
