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
import Cocoa


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
    if #available(macOS 11.0, *) {
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


class Login:ObservableObject{    
    @AppStorage("login") var login = ""
    @AppStorage("server") var server = ""
}

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var password:String = ""
    @StateObject var loginSettings = Login()
    @ObservedObject var loginHandler = LoginHandler.shared
        
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
                        Image("Naviga_Logo_Light_Horizontal").resizable().scaledToFit().frame(height: 30, alignment: .bottomTrailing)
                    }.padding()
                }
                VStack() {
                    Spacer()
                    Text("Newspilot")
                        .font(Font.titleFont)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 50)
                    
                    LoginTextField(label:"Username", text: $loginSettings.login)

                    
                    ZStack(alignment:Alignment.trailing) {
                        SecureField("Password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(Font.bodyFont)
                            .padding(6)
                            .background(colorScheme == .dark ? Color.navigaTextFieldBackground:Color.white)
                            .cornerRadius(5.0)
                            .padding(.vertical, 6)
                            
                                                
                        Button(action: {
                            tryBiometricAuthentication()
                        }, label: {
                            Image(systemName: getBiometricType())
                        })
                        .buttonStyle(PlainButtonStyle())
                        .accentColor(Color(UIColor.tertiaryLabel))
                        .padding(.horizontal,10)
                    }
                    .font(Font.bodyFont)
                    
                    LoginTextField(label:"Server", text: self.$loginSettings.server)
                    
                    if loginHandler.connectionStatus == .connectionFailed {
                        Text("Connection failed. Please try again").foregroundColor(Color.red)
                    }else if loginHandler.connectionStatus == .authenticationFailed {
                        Text("Incorrect username or password").foregroundColor(.red)
                    }
                    else{
                        Text(" ")
                    }
                    Button(action:{
                        self.loginHandler.login(login: self.loginSettings.login, password: self.password, server: self.loginSettings.server)
                    }){
                        HStack {
                            if loginHandler.connectionStatus == .connecting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle()).scaleEffect(x: 0.7, y: 0.7, anchor: .center)
                                        
                            }else{
                                
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.white)
                            }
                            Text("Login")
                        }
                        .foregroundColor(.white)
                        .font(Font.buttonFont)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.navigaButtonBackground)
                        .cornerRadius(16)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .keyboardShortcut(KeyEquivalent.return, modifiers: [.command])
                    .frame(width: 140, height:30)
                    .padding(.top, 10)                                       
                    
                    Spacer()
                }
                .padding()
                .frame(minWidth: 200, idealWidth: 300, maxWidth: 400, minHeight: 400, idealHeight: 800, maxHeight: nil, alignment: .top)
                .animation(.easeOut(duration: 0.16))
            }
            .frame(width: 600, height: 500, alignment: .center)
    }
}

struct LoginTextField: View {
    @Environment(\.colorScheme) var colorScheme
    let label:String
    var text:Binding<String>
    
    var body: some View {
        TextField(label, text: text)
            .textFieldStyle(PlainTextFieldStyle())
            .font(Font.bodyFont)
            .padding(6)
            .background(colorScheme == .dark ? Color.navigaTextFieldBackground:Color.white)
            .cornerRadius(5.0)
            .disableAutocorrection(true)
    }
}



struct LoginView_Previews: PreviewProvider {
    static let devices = [PreviewDevice(rawValue: "macOS")]
    
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


