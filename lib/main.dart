import 'package:flutter/material.dart';
import 'models.dart';

void main() => runApp(const AdashiApp());

class AdashiApp extends StatelessWidget {
  const AdashiApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Adashi Workplace',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF087F6D),
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    ),
    home: const WorkplaceHome(),
  );
}

class WorkplaceHome extends StatefulWidget {
  const WorkplaceHome({super.key});

  @override
  State<WorkplaceHome> createState() => _WorkplaceHomeState();
}

class _WorkplaceHomeState extends State<WorkplaceHome> {
  final groups = demoGroups();
  int selected = 0;

  Future<void> openGroup(AdashiGroup group) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => GroupDetails(group: group),
    ));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final joined = groups.where((g) => g.joined).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Adashi Workplace')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('DEMO WORKSPACE • Example organization\n'
                    'Sample data only. No money moves. Changes reset when the app restarts.'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                ['Welcome back', 'Workplace groups', 'Contribution records', 'Payout calendar'][selected],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                ['Save together, with a clear view of every turn.',
                 'Explore circles in your example workplace.',
                 'Reported contributions still need organizer confirmation.',
                 'Illustrative schedule for the Staff Monthly Circle.'][selected],
              ),
              const SizedBox(height: 20),
              if (selected == 0) ...[
                Wrap(spacing: 12, runSpacing: 12, children: [
                  SummaryCard(label: 'Monthly commitment',
                    value: money(joined.fold<int>(0, (sum, g) => sum + g.amount))),
                  SummaryCard(label: 'Active circles', value: '${joined.length}'),
                  const SummaryCard(label: 'Your planned turn', value: 'December 2026'),
                ]),
                const SizedBox(height: 24),
                Text('Your circles', style: Theme.of(context).textTheme.titleLarge),
                for (final group in joined) groupCard(group),
              ],
              if (selected == 1)
                for (final group in groups) groupCard(group),
              if (selected == 2)
                for (final group in joined)
                  Card(child: ListTile(
                    leading: Icon(group.status == ContributionStatus.due
                        ? Icons.schedule : Icons.pending_actions),
                    title: Text(group.name),
                    subtitle: Text('October 2026 • ${money(group.amount)}\n'
                        '${group.status == ContributionStatus.due ? "Due 15 October" : "Reported • awaiting confirmation"}'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => openGroup(group),
                  )),
              if (selected == 3)
                for (final group in joined) ...[
                  Text(group.name, style: Theme.of(context).textTheme.titleLarge),
                  ...scheduleTiles(group),
                ],
              const SizedBox(height: 24),
              const Text('Joining is voluntary. Workplace membership does not guarantee payment or payout.'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (value) => setState(() => selected = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), label: 'Groups'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Records'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Payouts'),
        ],
      ),
    );
  }

  Widget groupCard(AdashiGroup group) => Card(
    margin: const EdgeInsets.only(top: 12),
    child: ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: const CircleAvatar(child: Icon(Icons.groups)),
      title: Text(group.name),
      subtitle: Text('${money(group.amount)} / month • ${group.members}/${group.capacity} members\n'
          '${group.joined ? "Active member" : group.requested ? "Request pending" : "Open for requests"}'),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: () => openGroup(group),
    ),
  );
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 240,
    child: Card(child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label),
        const SizedBox(height: 10),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ]),
    )),
  );
}

const months = ['October 2026', 'November 2026', 'December 2026',
  'January 2027', 'February 2027', 'March 2027'];

List<Widget> scheduleTiles(AdashiGroup group) => [
  for (var i = 0; i < group.recipients.length; i++)
    Card(child: ListTile(
      leading: CircleAvatar(child: Text('${i + 1}')),
      title: Text(group.recipients[i]),
      subtitle: Text(months[i]),
      trailing: Text(money(group.projectedPayout)),
    )),
];

class GroupDetails extends StatefulWidget {
  const GroupDetails({super.key, required this.group});
  final AdashiGroup group;

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  bool accepted = false;
  final reference = TextEditingController();

  @override
  void dispose() {
    reference.dispose();
    super.dispose();
  }

  Future<void> report() async {
    reference.clear();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Report a demo contribution'),
        content: SingleChildScrollView(child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This records a claim only. An organizer must confirm receipt. '
                'Do not enter real bank details.'),
            const SizedBox(height: 12),
            TextField(controller: reference, decoration: const InputDecoration(
              labelText: 'Optional demo reference',
            )),
          ],
        )),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Submit report')),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() => widget.group.reportContribution());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo report saved. Awaiting confirmation.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView(padding: const EdgeInsets.all(20), children: [
          const Text('DEMO • Sample rules and dates'),
          const SizedBox(height: 16),
          Text(money(group.amount), style: Theme.of(context).textTheme.headlineLarge),
          const Text('Monthly contribution'),
          const SizedBox(height: 16),
          Text('Projected payout: ${money(group.projectedPayout)}'),
          Text('${group.members} of ${group.capacity} places filled'),
          const Text('Projected payout assumes a full group and all contributions received.'),
          const SizedBox(height: 24),
          Text('Group rules', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('• Contributions are due on the 15th each month.\n'
              '• Everyone agrees to the payout order before the cycle starts.\n'
              '• Continue contributing after your payout until the cycle ends.\n'
              '• Late contributions are flagged for organizer follow-up; payouts wait for collection.\n'
              '• Leaving employment does not automatically end your remaining commitment.\n'
              '• Employer support does not imply a payout guarantee.'),
          const SizedBox(height: 20),
          if (!group.joined) ...[
            if (!group.requested)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('I accept these sample group rules'),
                value: accepted,
                onChanged: (value) => setState(() => accepted = value ?? false),
              ),
            FilledButton(
              onPressed: accepted && !group.requested && group.members < group.capacity
                ? () => setState(() => group.requestMembership(acceptedRules: accepted))
                : null,
              child: Text(group.requested ? 'Request pending organizer approval' : 'Request to join'),
            ),
            const SizedBox(height: 12),
            const Text('Proposed start: November 2026. Final payout order is agreed when the group fills.'),
          ],
          if (group.joined) ...[
            FilledButton.icon(
              onPressed: group.status == ContributionStatus.due ? report : null,
              icon: const Icon(Icons.receipt_long),
              label: Text(group.status == ContributionStatus.due
                  ? 'Report demo contribution' : 'Reported • awaiting confirmation'),
            ),
            const SizedBox(height: 24),
            Text('Agreed payout order', style: Theme.of(context).textTheme.titleLarge),
            ...scheduleTiles(group),
          ],
        ]),
      )),
    );
  }
}
