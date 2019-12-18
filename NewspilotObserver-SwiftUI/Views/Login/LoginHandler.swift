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
import os.log

enum ConnectionStatus {
    case notConnected, connecting, connected, authenticationFailed, connectionFailed
}

class LoginHandler: ObservableObject {
    @Published var connectionStatus:ConnectionStatus! = .notConnected
    
    var newspilot:Newspilot = Newspilot()
    
    func login(login:String, password:String, server:String) {
        connectionStatus = .connecting
        newspilot.disconnect()
        newspilot = Newspilot(server: server, login:login, password: password)
        
        //TODO: Check this- https://stackoverflow.com/questions/56595542/use-navigationbutton-with-a-server-request-in-swiftui
        newspilot.connect(callback: {[weak self] result in
            switch result {
            case .failure(let error):
                os_log("Could not connect to newspilot. Error:%@", log: .newspilot, type: .debug, error.localizedDescription)
                
                DispatchQueue.main.async {
                    switch error {
                    case .httpError(let errorCode, _) where errorCode == 401:
                        self?.connectionStatus = .authenticationFailed
                    default:
                        self?.connectionStatus = .connectionFailed
                    }
                }

            case .success(let sessionId):
                os_log("Connected. Got new sessionId:%d", log: .newspilot, type: .debug, sessionId)
                
                DispatchQueue.main.async {                    
                    self?.connectionStatus = .connected
                }
                
            }
        })
    }
    
}
