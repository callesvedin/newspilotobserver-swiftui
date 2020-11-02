//
//  SwiftUIView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Newspilot
import LocalAuthentication
#if os(macOS)
import Cocoa
#else
import UIKit
#endif


func getBiometricType() -> String {
  let context = LAContext()

  _ = context.canEvaluatePolicy(
    .deviceOwnerAuthenticationWithBiometrics,
    error: nil)
  switch context.biometryType {
  case .faceID:
    return "faceid"
  case .touchID:
    // In iOS 14 and later, you can use "touchid" here
    if #available(iOS 14.0, *) {
        return "touchid"
    }else{
        return "lock"
    }
  case .none:
    return "lock"
  @unknown default:
    return "lock"
  }
}

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
//let backgroundColor = Color(red: 24/255, green: 0, blue: 54/255, opacity: 1.0)
//let buttonColor = Color(red: 85.0/255.0, green: 48.0/255.0, blue: 243.0/255.0, opacity: 1.0)

struct LoginView: View {
    @State var password:String = ""
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var loginSettings:LoginSettings = LoginSettings()
    @ObservedObject var loginHandler = LoginHandler.shared
    
    let dismissKeyboard: () -> Void = {
        #if os(macOS)
            NSApplication.shared.sendAction(#selector(NSResponder.resignFirstResponder), to: nil, from: nil)
        #else
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
     
    }
    
    func tryBiometricAuthentication() {
      let context = LAContext()
      var error: NSError?

      if context.canEvaluatePolicy(
        .deviceOwnerAuthenticationWithBiometrics,
        error: &error) {

        let reason = "Authenticate to login with stored Newspilot password."
        context.evaluatePolicy(
          .deviceOwnerAuthenticationWithBiometrics,
          localizedReason: reason) { authenticated, error in

          DispatchQueue.main.async {
            if authenticated {
                self.password = loginHandler.getStoredPassword(server: loginSettings.server, login: loginSettings.login)
                loginHandler.login(login: self.loginSettings.login, password: self.password, server: self.loginSettings.server)
            } else {
              if let errorString = error?.localizedDescription {
                print("Error in biometric policy evaluation: \(errorString)")
              }
            }
          }
        }
      } else {        
        if let errorString = error?.localizedDescription {
          print("Error in biometric policy evaluation: \(errorString)")
        }
      }
    }
    
    
    var body: some View {
            ZStack {
                Color.navigaBackground
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("Naviga_Logo_Light_Horizontal").resizable().scaledToFit().frame(width: nil, height: 30, alignment: .bottomTrailing)
                    }.padding()
                }
                VStack() {
                    Spacer()
                    Text("Newspilot")
                        .font(Font.titleFont)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 50)
                    
                    TextField("Username", text: $loginSettings.login,onCommit: dismissKeyboard)
                        .font(Font.bodyFont)                        
                        .textContentType(.none)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.navigaTextFieldBackground)
                        .cornerRadius(5.0)
                        .padding()

                    
                    ZStack(alignment:Alignment.trailing) {
                        SecureField("Password", text: $password,onCommit: dismissKeyboard)
                        .font(Font.bodyFont)
                        .padding()
                        .background(Color.navigaTextFieldBackground)
                        .cornerRadius(5.0)
                        .padding()
                        
                        Button(action: {
                            tryBiometricAuthentication()
                        }, label: {
                            Image(systemName: getBiometricType())
                        })
                        .font(Font.title).accentColor(.secondary)
                        .padding(.horizontal,30)
                    }
                    TextField("Server", text: $loginSettings.server,onCommit: dismissKeyboard)
                        .font(Font.bodyFont)
                        .textContentType(.none)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.navigaTextFieldBackground)
                        .cornerRadius(5.0)
                        .padding()
                    
                    if loginHandler.connectionStatus == .connectionFailed {
                        Text("Connection failed. Please try again").foregroundColor(Color.red)
                    }else if loginHandler.connectionStatus == .authenticationFailed {
//                        Image(systemName: "lock.slash.fill").font(Font.title.weight(.regular)).foregroundColor(.gray)
                        Text("Incorrect username or password").foregroundColor(.red)
                    }
                    else{
                        Text(" ")
                    }
                    Button(action:{
                        dismissKeyboard()
                        self.loginHandler.login(login: self.loginSettings.login, password: self.password, server: self.loginSettings.server)
                    }){
                        HStack {
                            if loginHandler.connectionStatus == .connecting {
                                if #available(iOS 13, *) {
                                    ActivityIndicator(isAnimating: .constant(true), style: .medium)
                                }else{
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                }
                            }else{                                
                                Image(systemName: "lock.fill").font(Font.headline.weight(.regular))
                                    .foregroundColor(.white).padding(4)
                            }
                            
                            Text("Login")
                                .padding(.leading, 15)
                                .font(Font.buttonFont)
                                .foregroundColor(.white)
                        }
                        .frame(width: 180, height: 50)
                        .background(Color.navigaButtonBackground)
                        .cornerRadius(15.0).padding(.top, 10)
                    }                
                    
                    Spacer()
                }
                    
            .frame(minWidth: 200, idealWidth: 300, maxWidth: 400, minHeight: 400, idealHeight: 500, maxHeight: nil, alignment: .top)
            .padding(.bottom, keyboard.currentHeight)
            .animation(.easeOut(duration: 0.16))
                
                
        }.edgesIgnoringSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static let devices = [PreviewDevice(rawValue: "iPhone 11"),
                   PreviewDevice(rawValue: "iPhone SE"),
                   PreviewDevice(rawValue: "iPad Pro (12.9-inch) (4th generation)")]
    
    static var previews: some View {
        
        Group {
            ForEach (devices, id: \.rawValue) {device in
                LoginView()
                    .previewDevice(device)
                    .previewDisplayName(device.rawValue)
                    .environment(\.colorScheme, .dark)
                
                LoginView()
                    .previewDevice(device)
                    .previewDisplayName(device.rawValue)
                    .environment(\.colorScheme, .light)
            }
        }        
    }
}
