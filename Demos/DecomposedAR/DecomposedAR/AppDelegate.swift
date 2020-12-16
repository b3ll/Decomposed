//
//  AppDelegate.swift
//  DecomposedAR
//
//  Created by Adam Bell on 5/23/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var rootViewController: ViewController!
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    self.rootViewController = ViewController(nibName: nil, bundle: nil)

    self.window = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = rootViewController
    window!.makeKeyAndVisible()

    return true
  }

}

