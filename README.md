# Adashi Workplace

Flutter starter for voluntary workplace Adashi groups. An organization introduces the platform; employees discover circles, agree to rules, contribute a fixed amount each month, and receive the pooled amount in an agreed rotation.

## Current demo

- Employee dashboard with monthly commitment and active groups.
- Group discovery and details, capacity, projected payout, and sample rules.
- Rule acceptance before a join request; requests remain pending organizer approval.
- Contribution reporting with a confirmation dialog. A report is not a verified payment.
- Contribution records and a six-month sample payout calendar.
- Responsive content width and Material 3 navigation.

All organizations, people, dates, and financial records are fictional. State is kept in memory and resets on restart. No authentication, server, payment processing, payroll deductions, or real reminders are connected. The optional demo reference is not persisted. Never enter real financial data into this demo.

## Run the web demo

Install the stable Flutter SDK, then:

```sh
git clone https://github.com/Shedrackmadeit/adashi-workplace.git
cd adashi-workplace
git checkout feature/flutter-starter
flutter pub get
flutter run -d chrome
```

The web entry point is included. To generate native platform scaffolding when ready:

```sh
flutter create --platforms=android,ios --project-name adashi_workplace .
```

Review generated changes before committing; iOS builds require macOS and Xcode.

## Checks

```sh
flutter analyze
flutter test
flutter build web --release
```

GitHub Actions runs these on pull requests and main pushes, and uploads the web build as an artifact. This does not publish a live website. Local verification could not run in the originating Codex session because its process helper failed; use the Actions result as the build evidence.

## Code layout

- `lib/main.dart`: dashboard, navigation, group details, and demo interactions.
- `lib/models.dart`: sample groups and guarded join/report transitions.
- `test/`: membership eligibility, duplicate report prevention, and UI flows.
- `web/`: web entry point.

## Product boundaries

Participation is voluntary. Employment verification cannot guarantee payment. A member must continue contributing after their turn until the cycle ends. The projected payout assumes all places are filled and contributions collected.

Before real use, implement authentication, organization isolation, durable records, role-based access, organizer approval and receipt verification, agreed payout orders, late-payment rules, and employee-exit handling. Decide whether payments remain outside the app or use a payment partner or payroll before integrating money movement.

This hand-written Flutter application is developed separately from the FlutterFlow visual project. It has not been connected or synchronized with FlutterFlow.
