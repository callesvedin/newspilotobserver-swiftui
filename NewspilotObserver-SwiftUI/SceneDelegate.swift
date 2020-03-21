//
//  SceneDelegate.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-06-29.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Use a UIHostingController as window root view controller
        if let windowScene = scene as? UIWindowScene {
            let loginHandler = LoginHandler()
            let organizationQuery = OrganizationsQuery(withNewspilot: loginHandler.newspilot)
            let statusQuery = StatusQuery(withNewspilot: loginHandler.newspilot)
            let pageFlagQuery = PageFlagQuery(withNewspilot: loginHandler.newspilot)
            let window = UIWindow(windowScene: windowScene)
            PageQueryManager.shared.setup(withNewspilot: loginHandler.newspilot)
            window.rootViewController = UIHostingController(rootView: ApplicationView()
                .environmentObject(loginHandler)
                .environmentObject(organizationQuery)
                .environmentObject(statusQuery)
                .environmentObject(pageFlagQuery)
            )

            
//            let newspilotManager = NewspilotManager(host:"localhost", login:"infomaker", password:"newspilot")
//            newspilotManager.connect()
//
//            let organizationQuery = OrganizationsQuery(withNewspilotManager:newspilotManager)
//            let organizationsView = OrganizationList().environmentObject(organizationQuery)
//
//            window.rootViewController = UIHostingController(rootView: organizationsView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        //(UIApplication.shared.delegate as? AppDelegate)?.saveContext()

        //        NewspilotManager.shared.applicationWillTerminate()
    }


}

