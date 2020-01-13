//
//  SwiftUIView.swift
//  NewspilotObserver-SwiftUI
//
//  Created by carl-johan.svedin on 2019-09-17.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import SwiftUI
import Newspilot

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct LoginView: View {
    @State var password:String = ""
    @ObservedObject private var keyboard = KeyboardResponder()
    @ObservedObject var loginSettings:LoginSettings = LoginSettings()
    @EnvironmentObject var loginHandler:LoginHandler
    
    var body: some View {
            ZStack {
                Color.black
                VStack() {
                    Spacer()
                    Text("Newspilot")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 50)
                    
                    TextField("Username", text: $loginSettings.login)
                        .textContentType(.none)
                        .autocapitalization(.none)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding()
                    
                    TextField("Server", text: $loginSettings.server)
                        .textContentType(.none)
                        .autocapitalization(.none)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding()
                    
                    if loginHandler.connectionStatus == .connectionFailed {
                        Text("Connection failed. Please try again").foregroundColor(.red)
                    }else if loginHandler.connectionStatus == .authenticationFailed {
                        Image(systemName: "lock.slash.fill").font(Font.title.weight(.regular)).foregroundColor(.gray)
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
                                ActivityIndicator(isAnimating: .constant(true), style: .medium).foregroundColor(.white)
                            }else{                                
                                Image(systemName: "lock.fill").font(Font.headline.weight(.regular))
                                    .foregroundColor(.white)
                            }
                            
                            Text("LOGIN")
                                .padding(.leading, 20)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(15.0)
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
    static var previews: some View {
        Group {
        LoginView().environmentObject(LoginHandler())
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
        LoginView().environmentObject(LoginHandler())
                .previewDevice(PreviewDevice(rawValue: "iPad Air (3rd generation)"))
                .previewDisplayName("iPad Air (3rd generation)")
        }
    }
}
