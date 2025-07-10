import UIKit
import Flutter
import AdSupport
import AppTrackingTransparency

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1) Регіструємо плагіни
    GeneratedPluginRegistrant.register(with: self)

    // 2) Запитуємо ATT (тільки на iOS 14+)
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization { status in
        // Асинхронно обробляємо відповідь
        DispatchQueue.main.async {
          let rawIdfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
          let newIdfa: String
          if status == .authorized && !rawIdfa.isEmpty {
            newIdfa = rawIdfa
          } else {
            newIdfa = "00000000-0000-0000-0000-000000000000"
          }

          // Зберігаємо в UserDefaults — Flutter SharedPreferences під капотом читають саме звідси
          UserDefaults.standard.set(newIdfa, forKey: "advertising_id")

          print("ATT prompt result: \(status.rawValue)")
          print("Saved IDFA: \(newIdfa)")
        }
      }
    } else {
      // Для iOS <14 просто зберігаємо поточний IDFA без запиту
      let rawIdfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
      UserDefaults.standard.set(rawIdfa, forKey: "advertising_id")
      print("iOS <14, saved IDFA: \(rawIdfa)")
    }

    // 3) Продовжуємо запуск Flutter
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}