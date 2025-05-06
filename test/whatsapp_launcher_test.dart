import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:whatsapp_launcher/whatsapp_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncher extends Mock implements UrlLauncherPlatform {}

void main() {
  late MockUrlLauncher mockLauncher;

  setUp(() {
    mockLauncher = MockUrlLauncher();
    UrlLauncherPlatform.instance = mockLauncher;
  });

  test('launchWhatsAppMessage should return true if launch is successful', () async {
    when(mockLauncher.canLaunch(any as String)).thenAnswer((_) async => true);
    when(
      mockLauncher.launch(
        any as String,
        useSafariVC: anyNamed('useSafariVC') ?? false,
        useWebView: anyNamed('useWebView') ?? false,
        enableJavaScript: anyNamed('enableJavaScript') ?? false,
        enableDomStorage: anyNamed('enableDomStorage') ?? false,
        universalLinksOnly: anyNamed('universalLinksOnly') ?? false,
        headers: anyNamed('headers') ?? const <String, String>{},
        webOnlyWindowName: anyNamed('webOnlyWindowName'),
      ),
    ).thenAnswer((_) async => true);

    final result = await WhatsAppLauncher.launchWhatsAppMessage(
      phoneNumber: '918107037133',
      message: 'Hello!',
    );

    expect(result, true);
  });
}
