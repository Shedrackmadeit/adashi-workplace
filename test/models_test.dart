import 'package:flutter_test/flutter_test.dart';
import 'package:adashi_workplace/models.dart';

void main() {
  test('membership requires rules and cannot be requested twice', () {
    final group = demoGroups()[1];
    expect(group.requestMembership(acceptedRules: false), isFalse);
    expect(group.requested, isFalse);
    expect(group.requestMembership(acceptedRules: true), isTrue);
    expect(group.joined, isFalse);
    expect(group.requestMembership(acceptedRules: true), isFalse);
  });

  test('full groups reject requests', () {
    final group = AdashiGroup(id: 'full', name: 'Full', amount: 100,
      members: 2, capacity: 2, joined: false, recipients: ['A', 'B']);
    expect(group.requestMembership(acceptedRules: true), isFalse);
  });

  test('reports remain unconfirmed and cannot be duplicated', () {
    final groups = demoGroups();
    expect(groups[1].reportContribution(), isFalse);
    expect(groups[0].reportContribution(), isTrue);
    expect(groups[0].status, ContributionStatus.reported);
    expect(groups[0].reportContribution(), isFalse);
  });

  test('projected payout and money formatting', () {
    expect(demoGroups()[0].projectedPayout, 120000);
    expect(money(120000), 'NGN 120,000');
    expect(money(0), 'NGN 0');
  });
}
