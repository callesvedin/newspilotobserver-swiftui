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
    @Published var login = ""
    @Published var server = ""
    
    //    init(login:String, server:String) {
    //        self.login=login
    //        self.server=server
    //    }
}

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("login") var savedLogin = ""
    @AppStorage("server") var savedServer = ""
    
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
                
                TextField("", text:$loginSettings.login)
                    .font(Font.smallBodyFont)
                    .modifier(LoginTextField(label:"Username",text:loginSettings.login))
                
                
                ZStack(alignment:Alignment.trailing) {
                    SecureField("", text: $password)
                        .font(Font.smallBodyFont)
                        .modifier(LoginTextField(label:"Password",text:password))
                    
                                    
                    Button(action: {
                        tryBiometricAuthentication()
                    }, label: {
                        Image(systemName: getBiometricType())
                    })
                    .buttonStyle(PlainButtonStyle())
                    .accentColor(Color(UIColor.tertiaryLabel))
                    .padding(.horizontal,10)
                    .padding(.top, 25)
                }
                
                TextField("", text:$loginSettings.server)
                    .font(Font.smallBodyFont)
                    .modifier(LoginTextField(label:"Server",text:loginSettings.server))
                //                    LoginTextField(label:"Server", text: self.$loginSettings.server)
                
                if loginHandler.connectionStatus == .connectionFailed {
                    Text("Connection failed. Please try again").foregroundColor(Color.red)
                }else if loginHandler.connectionStatus == .authenticationFailed {
                    Text("Incorrect username or password").foregroundColor(.red)
                }
                else{
                    Text(" ")
                }
                Button(action:{
                    savedLogin = loginSettings.login
                    savedServer = loginSettings.server
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
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .frame(minWidth: 200, idealWidth: 300, maxWidth: 400, minHeight: 400, idealHeight: 800, maxHeight: nil, alignment: .top)
            .animation(.easeOut(duration: 0.16))
        }
        .ignoresSafeArea()
        .onAppear() {
            loginSettings.login = savedLogin
            loginSettings.server = savedServer
        }
    }
}


struct LoginTextField: ViewModifier {
    var buttonForegroundColor = Color.blue
    let label:String
    var text:String
    
    func body(content: Content) -> some View {
        return
            VStack(alignment: .leading,spacing:2) {
//                ZStack(alignment: .leading) {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(Color(NSColor.placeholderTextColor) )
//                        .offset(x:text.isEmpty ? 0 : -50)
//                        .scaleEffect(text.isEmpty ? 1 : 0.9, anchor: .leading)
                    //                    .opacity(text.isEmpty ? 0 : 1)
                    //                    .offset(y: text.isEmpty ? 20 : 0)
                    
                    content
                        .textFieldStyle(PlainTextFieldStyle())
                        .disableAutocorrection(true)
                    
  //              }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white)
                
            }
            .padding(.top, 15)
//        .animation(.spring(response: 0.4, dampingFraction: 0.5))
            
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


