import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saku_pengeluaran/main.dart';

void main() {
  testWidgets('shows onboarding and navigates to login', (tester) async {
    _setMobileViewport(tester);
    await tester.pumpWidget(const SakuApp());

    expect(find.text('Kelola Uangmu Lebih Cepat'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Pantau Saku Tanpa Ribet'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Masuk'), findsWidgets);
  });

  testWidgets('logs in and opens history tab', (tester) async {
    _setMobileViewport(tester);
    await tester.pumpWidget(const SakuApp());

    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan email'),
      'asadel@saku.test',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Masukkan password'),
      'password123',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Hei, Asadel!'), findsOneWidget);
    expect(find.text('Catatan Terakhir'), findsOneWidget);

    await tester.tap(find.text('Budgeting'));
    await tester.pumpAndSettle();

    expect(find.text('Budget'), findsWidgets);
    expect(find.text('Katagori budget'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Saku Insight'));
    await tester.pumpAndSettle();

    expect(find.text('Pertanyaan Cepat'), findsOneWidget);
    expect(find.text('Tanya AI...'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Tambah Catatan'), findsOneWidget);
    expect(find.text('Hutang'), findsOneWidget);
    expect(find.text('Jatuh Tempo'), findsOneWidget);

    await tester.tap(find.text('Beri Pinjaman'));
    await tester.pumpAndSettle();

    expect(find.text('Dompet'), findsOneWidget);
    expect(find.text('BSI'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Riwayat').last);
    await tester.pumpAndSettle();

    expect(find.text('Cari catatan...'), findsOneWidget);
    expect(find.text('Makanan'), findsOneWidget);

    await tester.tap(find.text('Grafik').last);
    await tester.pumpAndSettle();

    expect(find.text('Pilih Periode'), findsOneWidget);
    expect(find.text('Pengeluaran'), findsOneWidget);

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();

    expect(find.text('List Dompet'), findsOneWidget);
    expect(find.text('Informasi Akun'), findsOneWidget);
  });
}

void _setMobileViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
