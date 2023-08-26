//
//  AppDelegate.swift
//  Internship
//
//  Created by Kristina Aleksiutina on 26.08.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private lazy var applicationAssembly = ApplicationAssembly()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        applicationAssembly.window = window
        applicationAssembly.start()
                
        return true
    }
}

