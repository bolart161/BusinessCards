//
//  AppDelegate.swift
//  BusinessCards
//
//  Created by Artem on 15/04/2019.
//  Copyright © 2019 Artem Boltunov. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let cards = DBService<CardRecord>() // cards BD
        let categories = DBService<CategoryRecord>() // categories BD
        
        cards.deleteAll()
        categories.deleteAll()
        
        // make some categories
        let work = CategoryRecord(name: "Work")
        let cocoaHeads = CategoryRecord(name: "CocoaHeads 2019")
        let polytech = CategoryRecord(name: "Polytech")
        
        // make some cards
        let alena = CardRecord(name: "Alena", surname: "Mordvintseva", phone: "89215521714", isMy: true, category: polytech)
        // card with additional info
        let artemInfo: [String: String] = [.email: "bolart161@mail.ru", .company: "DreamTeam"]
        let artem = CardRecord(name: "Artem", surname: "Boltunov", phone: "89817521538", isMy: false, category: polytech, info: artemInfo)
        // or
        let sasha = CardRecord(name: "Sasha", surname: "Ponomarev", phone: "89995195882", isMy: false, category: cocoaHeads, info: [.address: "Купчино"])
        let maxim = CardRecord(name: "Maxim", surname: "Egorov", phone: "89697298209", isMy: false, category: work, info: [.company: "Янино", .email: "egorov@mail.ru"])
            
        // add categories and cards
        categories.add(work)
        categories.add(cocoaHeads)
        categories.add(polytech)
        cards.add(alena)
        cards.add(artem)
        cards.add(sasha)
        cards.add(maxim)
        
        // true -> native
        let allCards = cards.getAll()
        let peopleFromWork = cards.get(field: .category, value: work, sortBy: .name)
        // return results (many records)
        //print()
        
        // how to edit 
        //cards.edit(data: artem, value: [.company: "Mail.ru Group", .phone: "89111111111"])
        cards.edit(data: maxim, value: [.category: polytech])
        
        
        print("!!!")
        // при удалении категории удаляются все карты, с ней связанные
        
        var cardsWithWorkCategory = cards.get(field: .category, value: work)
        print(cardsWithWorkCategory)
        //categories.delete(cocoaHeads)
        //cards.deleteAll()
        let name = cards.get(field: .company, value: "DreamTeam")
        cardsWithWorkCategory = cards.get(field: .category, value: work)
        print(cardsWithWorkCategory)
        
        // избежать этого можно, заранее изменив CategoryRecord в карте
        cards.edit(data: sasha, value: [.category: polytech])
        print(cards.getAll())
        
        // deleteAll соответственно
//        let artem = CardRecord(name: "Atem", surname: <#T##String#>, phone: <#T##String#>, isMy: <#T##Bool#>, category: <#T##CategoryRecord#>, info: <#T##[String : String]?#>)
//        categories.add(CategoryRecord(name: "Work"))
//        categories.add(CategoryRecord(name: "Partners"))
//        categories.add(CategoryRecord(name: "Work"))
//        db2.add(CategoryRecord(name: "Work"))
//        db1.add(CardRecord(name: "Alena", surname: "Surname", phone: "89215521714", isMy: true, category: db2.get(field: .name, value: "Work").first!, info: [.company: "Polytech", .email: "my@mail.ru"]))
//
//        print(db1.getAll())
//        print(db1.getAll(sortBy: .name, ascending: true))
//
////        db1.add(CardRecord(name: "Name", surname: "Surname", phone: "89215521714", isMy: true, category: db2.get(field: .name, value: "Work").first!, info: [.company: "Polytech", .email: "my@mail.ru"]))
////        let record = db1.get(field: .name, value: "Alena").first!
////        print(record)
////        db1.edit(data: record, value: [.isMy: "Nope"])
//        print(db1.getAll())
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

