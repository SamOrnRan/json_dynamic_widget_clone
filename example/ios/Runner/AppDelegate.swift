import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    NSString *mapsApiKey = [[NSProcessInfo processInfo] environment][@"MAPS_API_KEY"];
  if ([mapsApiKey length] == 0) {
    mapsApiKey = @"AIzaSyBHGOmtcSeVpiLXBHL1SYBqQxT9iReNJ_c";
  }
  [GMSServices provideAPIKey:mapsApiKey];
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
