import UIKit
//import CoreLocation

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    // MARK: - Properties
    let workManager = WorkManager()
    let locationManager = LocationManager()

    // MARK: - Application Lifecycle
    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        application.registerUserNotificationSettings(
                        UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        registerDefaults()

        if let options = launchOptions {
            if let locationOptions  = options[UIApplicationLaunchOptionsLocationKey] as? NSNumber {
                workManager.resetDataIfNeeded()
                locationManager.manager.startUpdatingLocation()
            } else if let localNotification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                NSLog("Launched due to a local notification %@", localNotification)
            }
        }

        return true
    }

    public func applicationWillEnterForeground(application: UIApplication) {
        NSLog("AppDelegate: Entering Foreground")
        //if week has ended clear the work manages data
        workManager.resetDataIfNeeded()

        // Clear the badge if it is showing
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    public func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //show an alertview if the work week ends and we are in the foreground
        NSLog("Work Week Ended and we were in the foreground")
        let alert = UIAlertController(title: "WorkWeek", message: "Go Home!", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(defaultAction)
        // TODO: Finish This

    }

    /// Setup Default values in the NSUserDefaults
    func registerDefaults(standardDefaults: NSUserDefaults = Defaults.standard){
        //register some defaults
        let defaults: [NSObject: AnyObject] = [
            SettingsKey.hoursInWorkWeek.rawValue : NSNumber(int: 40),    // 40 hour work week
            SettingsKey.resetDay.rawValue: NSNumber(int: 0),             // Sunday
            SettingsKey.resetHour.rawValue: NSNumber(int: 4),            // 4 am
            SettingsKey.workRadius.rawValue: NSNumber(int: 200),         // 200m work radius
            SettingsKey.clearDate.rawValue: getDateForReset(0, 4, 0) ?? NSDate(),
        ]
        standardDefaults.registerDefaults(defaults)
    }
}