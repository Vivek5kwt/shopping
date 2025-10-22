import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/controllers/analytics_controller.dart';

class SalesChart extends StatefulWidget {
  const SalesChart({super.key});

  @override
  State<SalesChart> createState() => _SalesChartState();
}

class _SalesChartState extends State<SalesChart> {
  @override
  void initState() {
    super.initState();
    // Load analytics when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<AnalyticsController>(
        context,
        listen: false,
      );
      controller.getAnalytics();
    });
  }

  int touchedIndex = -1;

  final Map<String, Color> categoryColors = {
    'Sports': Color(0xFF6C5CE7),
    'Clothing': Color(0xFFFF6B9D),
    'Electronics': Color(0xFF00B894),
    'Cosmetics': Color(0xFFFD79A8),
    'Books': Color(0xFF74B9FF),
    'Others': Color(0xFFFAB1A0),
  };

  final Map<String, IconData> categoryIcons = {
    'Sports': Icons.sports_basketball,
    'Clothing': Icons.checkroom,
    'Party Wears': Icons.party_mode,
    'Work Wears': Icons.work,
    'Sports Wears': Icons.sports,
    'Others': Icons.category,
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsController>(
      builder: (context, controller, child) {
        // Show loading indicator
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
            ),
          );
        }

        // Show message if no data
        if (controller.sales.isEmpty) {
          return Center(
            child: Text(
              'No sales data available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Convert sales list to map for easier access
        final Map<String, double> salesData = {
          for (var sale in controller.sales)
            sale.label: sale.earnings.toDouble(),
        };

        // Calculate max value for chart
        final maxY = salesData.values.reduce((a, b) => a > b ? a : b) * 1.2;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chart Container
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: maxY,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchCallback: (event, response) {
                              setState(() {
                                if (response != null &&
                                    response.spot != null &&
                                    event is FlTapUpEvent) {
                                  touchedIndex =
                                      response.spot!.touchedBarGroupIndex;
                                } else {
                                  touchedIndex = -1;
                                }
                              });
                            },
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (group) => Color(0xFF2D3748),
                              tooltipPadding: EdgeInsets.all(8),
                              tooltipMargin: 8,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                String category = salesData.keys.elementAt(
                                  groupIndex,
                                );
                                return BarTooltipItem(
                                  '$category\n\$${(rod.toY / 1000).toStringAsFixed(1)}k',
                                  TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < salesData.length) {
                                    String category = salesData.keys.elementAt(
                                      value.toInt(),
                                    );
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Icon(
                                        categoryIcons[category],
                                        color: Colors.black54,
                                        size: 20,
                                      ),
                                    );
                                  }
                                  return Text('');
                                },
                                reservedSize: 40,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 50,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '\$${(value / 1000).toInt()}k',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(color: Colors.grey, strokeWidth: 1);
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: salesData.entries.map((entry) {
                            int index = salesData.keys.toList().indexOf(
                              entry.key,
                            );
                            bool isTouched = index == touchedIndex;
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value,
                                  color: categoryColors[entry.key],
                                  width: isTouched ? 28 : 24,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: maxY,
                                    color: Colors.grey.withOpacity(0.07),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
