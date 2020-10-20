//
//  LoginHandler.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-24.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import Foundation
import Combine
import Newspilot
import SDWebImage
import os.log

enum ConnectionStatus {
    case notConnected, connecting, connected, authenticationFailed, connectionFailed
}


class LoginHandler: ObservableObject {
    @Published var connectionStatus:ConnectionStatus! = .notConnected
    @Published var loggedIn:Bool = false
    
    static let shared = LoginHandler()
    
    var newspilot:Newspilot {
        get {
            NewspilotManager.shared
        }
    }
    
    private init() {        
        newspilot.addConnectionCallback(){ [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .Connected:
                    self?.connectionStatus = .connected
                case .Disconnected(let reason,let error):
                    os_log("Connection lost. Reason: %@. Error:%@", log:.newspilot, type: .info, reason ?? "-", error.debugDescription)
                    self?.connectionStatus = .notConnected
                }
            }
        }
    }
    
    
    
    func login(login:String, password:String, server:String) {
        connectionStatus = .connecting
        newspilot.disconnect()
                
        newspilot.connect(server:server,login: login, password: password, callback: {[weak self] result in
            switch result {
            case .failure(let error):
                os_log("Could not connect to newspilot. Error:%@", log: .newspilot, type: .debug, error.localizedDescription)
                
                DispatchQueue.main.async {
                    switch error {
                    case .httpError(let errorCode, _) where errorCode == 401:
                        self?.connectionStatus = .authenticationFailed
                        self?.loggedIn = false
                    default:
                        self?.connectionStatus = .connectionFailed
                        self?.loggedIn = false
                    }
                }
                
            case .success(let sessionId):
                os_log("Connected. Got new sessionId:%d", log: .newspilot, type: .debug, sessionId)
                self?.updateStoredPassword(server:server, login:login, password:password)
                DispatchQueue.main.async {
                    SDWebImageDownloader.shared.config.username = login;
                    SDWebImageDownloader.shared.config.password = password;

                    self?.loggedIn = true
                    self?.connectionStatus = .connected
                }
                
            }
        })
    }
    
    func logout() {
        loggedIn = false
        newspilot.disconnect()
    }
    
    func getStoredPassword(server:String, login:String) -> String {
      let kcw = KeychainWrapper()
      if let password = try? kcw.getGenericPasswordFor(
        account: login,
        service: server) {
        return password
      }

      return ""
    }
    
    func updateStoredPassword(server:String, login:String, password: String) {
      let kcw = KeychainWrapper()
      do {
        try kcw.storeGenericPasswordFor(
          account: login,
          service: server,
          password: password)
      } catch let error as KeychainWrapperError {
        print("Exception setting password: \(error.message ?? "no message")")
      } catch {
        print("An error occurred setting the password.")
      }
    }
}
