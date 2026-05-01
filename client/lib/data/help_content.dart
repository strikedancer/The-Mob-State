import 'package:flutter/material.dart';

class HelpTopic {
  const HelpTopic({
    required this.id,
    required this.icon,
    required this.protocolPath,
  });

  final String id;
  final IconData icon;
  final String protocolPath;
}

const List<HelpTopic> helpTopics = [
  HelpTopic(
    id: 'dashboard',
    icon: Icons.dashboard,
    protocolPath: 'docs/module-protocols/dashboard.md',
  ),
  HelpTopic(
    id: 'crimes',
    icon: Icons.warning,
    protocolPath: 'docs/module-protocols/crimes.md',
  ),
  HelpTopic(
    id: 'jobs',
    icon: Icons.work,
    protocolPath: 'docs/module-protocols/jobs.md',
  ),
  HelpTopic(
    id: 'travel',
    icon: Icons.flight,
    protocolPath: 'docs/module-protocols/travel.md',
  ),
  HelpTopic(
    id: 'crew',
    icon: Icons.groups,
    protocolPath: 'docs/module-protocols/crew.md',
  ),
  HelpTopic(
    id: 'friends',
    icon: Icons.group,
    protocolPath: 'docs/module-protocols/friends.md',
  ),
  HelpTopic(
    id: 'messages',
    icon: Icons.chat,
    protocolPath: 'docs/module-protocols/messages.md',
  ),
  HelpTopic(
    id: 'inventory',
    icon: Icons.inventory,
    protocolPath: 'docs/module-protocols/inventory.md',
  ),
  HelpTopic(
    id: 'properties',
    icon: Icons.business,
    protocolPath: 'docs/module-protocols/properties.md',
  ),
  HelpTopic(
    id: 'bank',
    icon: Icons.account_balance,
    protocolPath: 'docs/module-protocols/bank.md',
  ),
  HelpTopic(
    id: 'casino',
    icon: Icons.casino,
    protocolPath: 'docs/module-protocols/casino.md',
  ),
  HelpTopic(
    id: 'trade',
    icon: Icons.shopping_bag,
    protocolPath: 'docs/module-protocols/trade.md',
  ),
  HelpTopic(
    id: 'black-market',
    icon: Icons.store,
    protocolPath: 'docs/module-protocols/black-market.md',
  ),
  HelpTopic(
    id: 'drugs',
    icon: Icons.local_pharmacy,
    protocolPath: 'docs/module-protocols/drugs.md',
  ),
  HelpTopic(
    id: 'nightclub',
    icon: Icons.nightlife,
    protocolPath: 'docs/module-protocols/nightclub.md',
  ),
  HelpTopic(
    id: 'crypto',
    icon: Icons.currency_bitcoin,
    protocolPath: 'docs/module-protocols/crypto.md',
  ),
  HelpTopic(
    id: 'smuggling',
    icon: Icons.local_shipping,
    protocolPath: 'docs/module-protocols/smuggling.md',
  ),
  HelpTopic(
    id: 'tools',
    icon: Icons.build,
    protocolPath: 'docs/module-protocols/tools.md',
  ),
  HelpTopic(
    id: 'court',
    icon: Icons.gavel,
    protocolPath: 'docs/module-protocols/court.md',
  ),
  HelpTopic(
    id: 'hitlist',
    icon: Icons.gps_fixed,
    protocolPath: 'docs/module-protocols/hitlist.md',
  ),
  HelpTopic(
    id: 'security',
    icon: Icons.shield,
    protocolPath: 'docs/module-protocols/security.md',
  ),
  HelpTopic(
    id: 'hospital',
    icon: Icons.local_hospital,
    protocolPath: 'docs/module-protocols/hospital.md',
  ),
  HelpTopic(
    id: 'prison',
    icon: Icons.gpp_bad,
    protocolPath: 'docs/module-protocols/prison.md',
  ),
  HelpTopic(
    id: 'vault',
    icon: Icons.lock,
    protocolPath: 'docs/module-protocols/payments.md',
  ),
  HelpTopic(
    id: 'garage',
    icon: Icons.directions_car,
    protocolPath: 'docs/module-protocols/garage.md',
  ),
  HelpTopic(
    id: 'marina',
    icon: Icons.directions_boat,
    protocolPath: 'docs/module-protocols/marina.md',
  ),
  HelpTopic(
    id: 'tuneshop',
    icon: Icons.tune,
    protocolPath: 'docs/module-protocols/tuneshop.md',
  ),
  HelpTopic(
    id: 'shooting-range',
    icon: Icons.gps_fixed,
    protocolPath: 'docs/module-protocols/shooting-range.md',
  ),
  HelpTopic(
    id: 'gym',
    icon: Icons.fitness_center,
    protocolPath: 'docs/module-protocols/gym.md',
  ),
  HelpTopic(
    id: 'ammo-factory',
    icon: Icons.factory,
    protocolPath: 'docs/module-protocols/ammo-factory.md',
  ),
  HelpTopic(
    id: 'school',
    icon: Icons.school,
    protocolPath: 'docs/module-protocols/school.md',
  ),
  HelpTopic(
    id: 'territory',
    icon: Icons.map,
    protocolPath: 'docs/module-protocols/territory.md',
  ),
  HelpTopic(
    id: 'prostitution',
    icon: Icons.favorite,
    protocolPath: 'docs/module-protocols/prostitution.md',
  ),
  HelpTopic(
    id: 'red-light-districts',
    icon: Icons.storefront,
    protocolPath: 'docs/module-protocols/red-light-districts.md',
  ),
  HelpTopic(
    id: 'achievements',
    icon: Icons.emoji_events,
    protocolPath: 'docs/module-protocols/achievements.md',
  ),
  HelpTopic(
    id: 'support-tickets',
    icon: Icons.support_agent,
    protocolPath: 'docs/module-protocols/messages.md',
  ),
  HelpTopic(
    id: 'settings',
    icon: Icons.settings,
    protocolPath: 'docs/module-protocols/settings.md',
  ),
  HelpTopic(
    id: 'premium',
    icon: Icons.workspace_premium,
    protocolPath: 'docs/module-protocols/payments.md',
  ),
];
