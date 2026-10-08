enum ContributionStatus { due, reported }

class AdashiGroup {
  AdashiGroup({
    required this.id,
    required this.name,
    required this.amount,
    required this.members,
    required this.capacity,
    required this.joined,
    required this.recipients,
    this.requested = false,
    this.status = ContributionStatus.due,
  });

  final String id;
  final String name;
  final int amount;
  final int members;
  final int capacity;
  final List<String> recipients;
  bool joined;
  bool requested;
  ContributionStatus status;

  int get projectedPayout => amount * capacity;

  bool requestMembership({required bool acceptedRules}) {
    if (!acceptedRules || joined || requested || members >= capacity) {
      return false;
    }
    requested = true;
    return true;
  }

  bool reportContribution() {
    if (!joined || status != ContributionStatus.due) return false;
    status = ContributionStatus.reported;
    return true;
  }
}

List<AdashiGroup> demoGroups() => [
  AdashiGroup(
    id: 'staff',
    name: 'Staff Monthly Circle',
    amount: 20000,
    members: 6,
    capacity: 6,
    joined: true,
    recipients: ['Amina', 'Chidi', 'You', 'Bola', 'Musa', 'Grace'],
  ),
  AdashiGroup(
    id: 'goals',
    name: 'New Year Goals',
    amount: 10000,
    members: 3,
    capacity: 5,
    joined: false,
    recipients: ['Tunde', 'Zainab', 'Emeka'],
  ),
];

String money(int amount) =>
    'NGN ${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
