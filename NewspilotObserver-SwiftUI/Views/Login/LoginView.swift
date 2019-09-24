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
    
    @ObservedObject var loginSettings:LoginSettings = LoginSettings()
    @ObservedObject var loginHandler:LoginHandler = LoginHandler()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Newspilot")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 150)

                TextField("Username", text: $loginSettings.login)
                    .textContentType(.none)
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
                    .padding()
                    .background(lightGreyColor)
                    .cornerRadius(5.0)
                    .padding()
                
                NavigationLink(destination: OrganizationList(newspilot:loginHandler.newspilot)  , tag: ConnectionStatus.connected, selection: $loginHandler.connectionStatus) {
                    Button(action:{
                        self.loginHandler.login(login: self.loginSettings.login, password: self.password, server: self.loginSettings.server)
                    }){
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.blue)
                            .cornerRadius(15.0)
                    }
                }
            
                Spacer()
                if loginHandler.connectionStatus == .connecting {
                    Text("Trying to login, please wait...").foregroundColor(.white)
                } else if loginHandler.connectionStatus == .connected {
                    Text("Successful login").foregroundColor(.white)
                }else{
                    Text("Help").foregroundColor(.white)
                }
            }.background(SwiftUI.Color.black.edgesIgnoringSafeArea(.all))
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        //        LoginView(loginSettings:LoginSettings(login:"calle", server:"testserver"))
    }
}
