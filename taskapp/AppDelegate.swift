//
//  AppDelegate.swift
//  taskapp
//
//  Created by 林正悟 on 2020/05/28.
//  Copyright © 2020 seisei-zero. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
//このcurrentは何？class funcって何？クラス？メソッド？？？？？？？？？？？？？？？？？？？？？？？
        center.requestAuthorization(options: [.alert, .sound]){
            (granted, error) in
// アプリの初回起動時にユーザーに許可を求めるアラートを表示させる。
        }
        center.delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent : UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void){
        completionHandler([.alert, .sound])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

