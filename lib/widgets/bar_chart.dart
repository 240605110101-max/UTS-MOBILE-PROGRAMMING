import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/data_point.dart';
import '../models/indicator.dart';
import '../utils/formatters.dart';

/// Diagram batang sederhana (tanpa package tambahan).
/// [points] harus berurutan dari tahun terlama ke terbaru.
class BarChart extends StatelessWidget {
  final List<DataPoint> points;
  final ValueKind kind;

  const BarChart({super.key, required this.points, required this.kind});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxAbs = points.fold<double>(0, (m, p) => math.max(m, p.value.abs()));

    return SizedBox(
      height: 190,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in points)
            Expanded(
              child: Tooltip(
                message: '${p.year}: ${formatValue(p.value, kind)}',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: maxAbs == 0
                                ? 0.02
                                : (p.value.abs() / maxAbs).clamp(0.02, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: p.value < 0 ? scheme.error : scheme.primary,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.year.toString().substring(2),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
