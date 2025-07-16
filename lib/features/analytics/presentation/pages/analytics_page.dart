import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/analytics_cubit.dart';
import '../cubit/analytics_state.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Analytics'),
      ),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is AnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AnalyticsCubit>().refreshAnalytics(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AnalyticsLoaded) {
            if (state.analytics.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No analytics data available',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<AnalyticsCubit>().loadAnalytics(),
                      child: const Text('Load Analytics'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<AnalyticsCubit>().refreshAnalytics(),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.analytics.length,
                itemBuilder: (context, index) {
                  final analysis = state.analytics[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            _getRecommendationColor(analysis.recommendation),
                        child: Text(
                          analysis.symbol.substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        analysis.companyName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Symbol: ${analysis.symbol}'),
                          Text(
                              'Risk Score: ${analysis.riskScore.toStringAsFixed(1)}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${analysis.currentPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getRecommendationColor(
                                  analysis.recommendation),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              analysis.recommendation.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to details page
                        _showAnalysisDetails(context, analysis);
                      },
                    ),
                  );
                },
              ),
            );
          }

          // Initial state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Press the button to load analytics',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<AnalyticsCubit>().loadAnalytics(),
                  child: const Text('Load Analytics'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AnalyticsCubit>().refreshAnalytics(),
        tooltip: 'Refresh Analytics',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Color _getRecommendationColor(String recommendation) {
    switch (recommendation.toLowerCase()) {
      case 'buy':
        return Colors.green;
      case 'sell':
        return Colors.red;
      case 'hold':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showAnalysisDetails(BuildContext context, analysis) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(analysis.companyName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Symbol: ${analysis.symbol}'),
              Text(
                  'Current Price: \$${analysis.currentPrice.toStringAsFixed(2)}'),
              Text(
                  'Target Price: \$${analysis.targetPrice.toStringAsFixed(2)}'),
              Text('Recommendation: ${analysis.recommendation}'),
              Text('Risk Score: ${analysis.riskScore.toStringAsFixed(1)}'),
              Text(
                  'Analysis Date: ${analysis.analysisDate.toString().split(' ')[0]}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
