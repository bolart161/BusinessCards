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
    var cardNetworkService = CardNetworkService()

    // swiftlint:disable:next discouraged_optional_collection
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.backgroundColor = .black
        window?.makeKeyAndVisible()
        var storyboard = UIStoryboard(name: "Main", bundle: nil)

        let mainAndCategoriesViewController = storyboard.instantiateViewController(withIdentifier: "MainAndCategoriesViewController")
         // swiftlint:disable:next force_unwrapping force_cast superfluous_disable_command
            as! MainAndCategoriesViewController
        mainAndCategoriesViewController.viewModelOfCards = MainAndCategoriesViewModel<CardRecord>(realmService: DBService<CardRecord>())
        mainAndCategoriesViewController.viewModelOfCategories = MainAndCategoriesViewModel<CategoryRecord>(realmService: DBService<CategoryRecord>())

        let navigationControllerOfMainScreen = UINavigationController(rootViewController: mainAndCategoriesViewController)

        storyboard = UIStoryboard(name: "MyCards", bundle: nil)
        let myCardsViewController = storyboard.instantiateViewController(withIdentifier: "MyCardsViewController")
            //swiftlint:disable:next force_unwrapping force_cast superfluous_disable_command
            as! MyCardsViewController
        myCardsViewController.viewModelOfCards = MyCardsViewModel<CardRecord>(realmService: DBService<CardRecord>())
        myCardsViewController.viewModelOfCategories = MyCardsViewModel<CategoryRecord>(realmService: DBService<CategoryRecord>())
        let navigationControllerOfMyCards = UINavigationController(rootViewController: myCardsViewController)

        navigationControllerOfMainScreen.tabBarItem = UITabBarItem(title: "Визитки", image: UIImage(named: .allCards), tag: 0)
        navigationControllerOfMyCards.tabBarItem = UITabBarItem(title: "My Cards", image: UIImage(named: .myCards), tag: 1)

        UITabBar.appearance().tintColor = .black
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [navigationControllerOfMainScreen, navigationControllerOfMyCards]
        window?.rootViewController = tabbarController
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let host = urlComponents?.host ?? ""
        let path = urlComponents?.path ?? ""

        window = UIWindow()
        window?.backgroundColor = .black
        window?.makeKeyAndVisible()
        var storyboard = UIStoryboard(name: "Main", bundle: nil)

        let mainAndCategoriesViewController = storyboard.instantiateViewController(withIdentifier: "MainAndCategoriesViewController")
            // swiftlint:disable:next force_unwrapping force_cast superfluous_disable_command
            as! MainAndCategoriesViewController
        mainAndCategoriesViewController.viewModelOfCards = MainAndCategoriesViewModel<CardRecord>(realmService: DBService<CardRecord>())
        mainAndCategoriesViewController.viewModelOfCategories = MainAndCategoriesViewModel<CategoryRecord>(realmService: DBService<CategoryRecord>())

        let navigationControllerOfMainScreen = UINavigationController(rootViewController: mainAndCategoriesViewController)

        storyboard = UIStoryboard(name: "MyCards", bundle: nil)
        let myCardsViewController = storyboard.instantiateViewController(withIdentifier: "MyCardsViewController")
            //swiftlint:disable:next force_unwrapping force_cast superfluous_disable_command
            as! MyCardsViewController
        myCardsViewController.viewModelOfCards = MyCardsViewModel<CardRecord>(realmService: DBService<CardRecord>())
        myCardsViewController.viewModelOfCategories = MyCardsViewModel<CategoryRecord>(realmService: DBService<CategoryRecord>())
        let navigationControllerOfMyCards = UINavigationController(rootViewController: myCardsViewController)

        storyboard = UIStoryboard(name: "CreateAndEditCard", bundle: nil)
        let createAndEditCardViewController = storyboard.instantiateViewController(withIdentifier: "createAndEditViewControllerID")
            as? CreateAndEditCardViewController
        createAndEditCardViewController?.setUrl(url: host + ":" + path)
        createAndEditCardViewController?.isMyFlag(isMy: false)
        if let createAndEditCardViewControllerPush = createAndEditCardViewController {
            navigationControllerOfMainScreen.pushViewController(createAndEditCardViewControllerPush, animated: true)
        }

        navigationControllerOfMainScreen.tabBarItem = UITabBarItem(title: "Визитки", image: UIImage(contentsOfFile: "AllCards"), tag: 0)
        navigationControllerOfMyCards.tabBarItem = UITabBarItem(title: "Мои", image: UIImage(contentsOfFile: "MyCards"), tag: 1)

        UITabBar.appearance().tintColor = .black
        let tabbarController = UITabBarController()
        tabbarController.viewControllers = [navigationControllerOfMainScreen, navigationControllerOfMyCards]
        window?.rootViewController = tabbarController
        return true
    }
}
