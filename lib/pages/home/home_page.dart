import 'package:flutter/cupertino.dart';

import '../../controllers/home_controller.dart';
import 'widgets/app_header.dart';
import 'widgets/fuel_card.dart';
import 'widgets/pi_status_card.dart';
import 'widgets/section_title.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _c = HomeController();

  @override
  void initState() {
    super.initState();
    _c.checkPi();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: _c,
        builder: (context, _) => ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 200),
          children: [
            const AppHeader(),
            const SizedBox(height: 20),
            PiStatusCard(
              host: _c.piHost,
              checking: _c.checking,
              online: _c.piOnline,
              onRefresh: _c.checkPi,
            ),
            const SizedBox(height: 28),
            const SectionTitle('Fuel prices'),
            const SizedBox(height: 12),
            for (int i = 0; i < _c.fuels.length; i++) ...[
              FuelCard(
                fuel: _c.fuels[i],
                selected: i == _c.selectedIndex,
                onTap: () => _c.select(i),
                onPriceChanged: (val) => _c.setPrice(val, index: i),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
