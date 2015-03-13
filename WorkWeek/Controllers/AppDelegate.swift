import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var locationManager:CLLocationManager = {
        var manager = CLLocationManager()
        let auth = CLLocationManager.authorizationStatus()
        if auth != CLAuthorizationStatus.AuthorizedAlways {
            manager.requestAlwaysAuthorization()
        }
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 200
        manager.pausesLocationUpdatesAutomatically = true
        return manager
    }()

    lazy var workManager: WorkManager = {
        //TODO: Must implement this so that when the app terminates the data is not lost.
        //read from a store, maybe later
        return WorkManager()
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        if let options = launchOptions {
            if let locationOptions  = options[UIApplicationLaunchOptionsLocationKey] as? NSNumber {
                println("\(locationOptions)")

                //spin up a location delegate and point the location Manager to it.
                //move the location delegate to its own class
                let locationDelegate = TableViewController()
                locationManager.delegate = locationDelegate
                locationManager.startUpdatingLocation()
            }
        }

        //register some defaults
        let defaults: [NSObject: AnyObject] = [
            SettingsKey.hoursInWorkWeek.rawValue : NSNumber(int: 40),    // 40 hour work week
            SettingsKey.unpaidLunchTime.rawValue: NSNumber(double: 0.5), // Half Hour for lunch
            SettingsKey.resetDay.rawValue: NSNumber(int: 0),             // Sunday
            SettingsKey.resetHour.rawValue: NSNumber(int: 4),            // 4 am
            SettingsKey.workRadius.rawValue: NSNumber(int: 200),         // 200m work radius
        ]
        NSUserDefaults.standardUserDefaults().registerDefaults(defaults)

        //register for notifications
       application.registerUserNotificationSettings(
        UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        // types are UIUserNotificationType members

        return true
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("Got a local notification, while in foreground")
        //setting badge number to 0
        application.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(application: UIApplication) {
        println("Became Active")
        //clearing the app badge here too
        application.applicationIconBadgeNumber = 0
    }

}
