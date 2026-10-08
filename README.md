# Adashi Workplace

A proposed B2B application that helps organizations introduce voluntary Adashi groups to employees and helps participants manage contributions and rotating payouts.

## The problem

Employees may not know which contribution groups are available or may hesitate to join because the rules, payment records, and payout schedule are unclear.

## How Adashi works

A group agrees to contribute a fixed amount weekly or monthly. Each round, the collected lump sum goes to one member. The rotation continues until every participant has received their turn. Members continue contributing after receiving their payout until the cycle is complete.

Example: 10 employees contribute NGN 20,000 each month. If everyone pays, one employee receives NGN 200,000 each month over a 10-month cycle.

## Proposed users

- Organization administrator: introduces the platform, invites employees, and verifies eligibility.
- Group organizer: proposes group rules, manages membership, and tracks contributions and payouts.
- Employee: discovers workplace groups, joins voluntarily, accepts the rules, and follows their contribution and payout schedule.

Organization participation does not automatically mean it guarantees payouts.

## Initial product scope

1. Organization accounts and employee invitations.
2. Private groups visible to eligible employees within their organization.
3. Group details: contribution amount, frequency, capacity, start date, and payout order.
4. Join requests and organizer approval.
5. Recorded member acceptance of group rules before a cycle starts.
6. Contribution records, payment confirmation, and reminders.
7. Payout schedules and recipient confirmation.
8. A history of changes to rules, payments, and payouts.

## Decisions to resolve before implementation

- Whether payments happen outside the app, through a payment partner, or through payroll.
- Who confirms payments and what evidence is required.
- How the payout order is agreed and whether changes require member approval.
- What happens when payments are late or incomplete.
- How remaining obligations are handled when an employee leaves the organization.
- Which records members, organizers, and organization administrators can access.
- Employer subscription pricing and the technology stack.

Payroll deductions, custody of funds, and guaranteed payouts are not assumed features. These require separate product decisions before implementation.

## Trust and privacy principles

- Participation is voluntary.
- Workplace verification provides accountability but does not guarantee future payment.
- Members can see the rules, schedule, and relevant group records before joining.
- Organization administrators receive only information needed for their role.
- Financial records and access permissions remain separated between organizations.
- Rule changes and payment corrections retain an audit history.

## Repository status

This repository currently contains the product outline. Application code, the technology stack, and deployment configuration have not been created yet.
