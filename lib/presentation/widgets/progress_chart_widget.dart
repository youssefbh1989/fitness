
import 'package:flutter/material.dart';

class ProgressChartWidget extends StatelessWidget {
  final String title;
  final List<ProgressDataPoint> dataPoints;
  final String unit;
  final Color lineColor;
  final bool showAverage;
  
  const ProgressChartWidget({
    Key? key,
    required this.title,
    required this.dataPoints,
    required this.unit,
    this.lineColor = Colors.blue,
    this.showAverage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final maxValue = dataPoints.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final minValue = dataPoints.map((p) => p.value).reduce((a, b) => a < b ? a : b);
    
    // Calculate average if needed
    double average = 0;
    if (showAverage) {
      final sum = dataPoints.map((p) => p.value).reduce((a, b) => a + b);
      average = sum / dataPoints.length;
    }
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildChartStats(context, maxValue, minValue, average),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: ChartPainter(
                  dataPoints: dataPoints,
                  maxValue: maxValue * 1.1, // Add 10% padding
                  minValue: minValue > 0 ? minValue * 0.9 : minValue * 1.1, // Add padding
                  lineColor: lineColor,
                  showAverage: showAverage,
                  averageValue: average,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dataPoints.first.date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  dataPoints.last.date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChartStats(BuildContext context, double max, double min, double average) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          context,
          'Highest',
          '$max $unit',
          Icons.arrow_upward,
          Colors.green,
        ),
        _buildStatItem(
          context,
          'Lowest',
          '$min $unit',
          Icons.arrow_downward,
          Colors.red,
        ),
        if (showAverage)
          _buildStatItem(
            context,
            'Average',
            '${average.toStringAsFixed(1)} $unit',
            Icons.horizontal_rule,
            Colors.orange,
          ),
      ],
    );
  }
  
  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<ProgressDataPoint> dataPoints;
  final double maxValue;
  final double minValue;
  final Color lineColor;
  final bool showAverage;
  final double averageValue;
  
  ChartPainter({
    required this.dataPoints,
    required this.maxValue,
    required this.minValue,
    required this.lineColor,
    required this.showAverage,
    required this.averageValue,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
      
    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
      
    final averagePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    final valueRange = maxValue - minValue;
    
    // Draw axes
    final axesPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw y-axis
    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, size.height),
      axesPaint,
    );
    
    // Draw x-axis
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axesPaint,
    );
    
    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    for (int i = 1; i <= 4; i++) {
      final y = size.height - (i * size.height / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
    
    // Draw average line if needed
    if (showAverage) {
      final averageY = size.height - ((averageValue - minValue) / valueRange * size.height);
      
      final dashWidth = 5.0;
      final dashSpace = 5.0;
      var startX = 0.0;
      
      while (startX < size.width) {
        canvas.drawLine(
          Offset(startX, averageY),
          Offset(startX + dashWidth, averageY),
          averagePaint,
        );
        startX += dashWidth + dashSpace;
      }
    }
    
    // Draw data points and line
    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final x = i * size.width / (dataPoints.length - 1);
      final y = size.height - ((point.value - minValue) / valueRange * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      
      // Draw data point
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ProgressDataPoint {
  final double value;
  final String date;
  
  ProgressDataPoint({
    required this.value,
    required this.date,
  });
}
