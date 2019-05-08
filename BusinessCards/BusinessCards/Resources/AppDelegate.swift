//
//  AppDelegate.swift
//  BusinessCards
//
//  Created by Artem on 15/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainAndCategoriesViewController = storyboard.instantiateViewController(withIdentifier: "MainAndCategoriesViewController") as! MainAndCategoriesViewController
        mainAndCategoriesViewController.viewModelOfCards = MainAndCategoriesViewModel<CardRecord>(realmService: DBService<CardRecord>())
        mainAndCategoriesViewController.viewModelOfCategories = MainAndCategoriesViewModel<CategoryRecord>(realmService: DBService<CategoryRecord>())
        
        let navigationController = UINavigationController(rootViewController: mainAndCategoriesViewController)
        window?.rootViewController = navigationController
        return true
    }
}
