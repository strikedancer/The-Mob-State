import 'package:flutter/material.dart';

import 'black_market_screen.dart';

/// Back-compat route: handelswaren now live under [BlackMarketScreen] (first tab).
class TradeScreen extends StatelessWidget {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlackMarketScreen(initialTabIndex: 0);
  }
}
