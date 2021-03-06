//
//  ContentView.swift
//  FormularyApp
//
//  Created by Andres Felipe Ocampo Eljaiek on 04/03/2021.
//

import SwiftUI

let lightGreyColor = Color(red: 239/255, green: 243/255, blue: 244/255)

struct ContentView: View {
    
    @ObservedObject private var userModelData = UserViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customer Information")) {
                    VStack(alignment:.leading) {
                        UserNameTextField(placeholder: "Name", title: "Name", text: self.$userModelData.name)
                            .autocapitalization(.none)
                            .padding(5)
                            .background(lightGreyColor)
                            .cornerRadius(5)
                            .shadow(radius: 1)
                        if !userModelData.nameMessage.isEmpty {
                            Text(userModelData.nameMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        UserNameTextField(placeholder: "Lastname", title: "Lastname", text: self.$userModelData.lastname)
                            .autocapitalization(.none)
                            .padding(5)
                            .background(lightGreyColor)
                            .cornerRadius(5)
                            .shadow(radius: 1)
                        if !userModelData.lastnameMessage.isEmpty {
                            Text(userModelData.lastnameMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        UserNameTextField(placeholder: "Email", title: "Email", text: self.$userModelData.email)
                            .autocapitalization(.none)
                            .padding(5)
                            .background(lightGreyColor)
                            .cornerRadius(5)
                            .shadow(radius: 1)
                        if !userModelData.emailMessage.isEmpty {
                            Text(userModelData.emailMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        UserNameTextField(placeholder: "Username", title: "Username", text: self.$userModelData.username)
                            .autocapitalization(.none)
                            .padding(5)
                            .background(lightGreyColor)
                            .cornerRadius(5)
                            .shadow(radius: 1)
                        if !userModelData.usernameMessage.isEmpty {
                            Text(userModelData.usernameMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                }
                Section(header: Text("Secure Information"), footer:Text(userModelData.passwordMessage).foregroundColor(.red)) {
                    
                    VStack(alignment: .leading) {
                        PasswordTextField(title: "Password", text: self.$userModelData.password)
                            .autocapitalization(.none)
                            .padding(5)
                            .background(lightGreyColor)
                            .cornerRadius(5)
                            .shadow(radius: 1)
                        
                        PasswordTextField(title: "Password Confirmation", text: self.$userModelData.passwordAgain)
                            .autocapitalization(.none)
                            .padding(5)
                            .background(lightGreyColor)
                            .cornerRadius(5)
                            .shadow(radius: 1)
                    }
                }
                
                Section {
                    Button(action: {
                        //
                    }, label: {
                        Text("Sign up")
                    }).disabled(!userModelData.isValid)
                }
            }
            .navigationTitle("Signup formulary")
        }
        
    }
}

struct UserNameTextField: View {
    var placeholder: String
    let title: String
    let text: Binding<String>

    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(Color.gray)
                .offset(y: text.wrappedValue.isEmpty ? 0 : -25)
                .scaleEffect(text.wrappedValue.isEmpty ? 1 : 0.8, anchor: .leading)
            TextField(placeholder, text: text).foregroundColor(Color.black)
        }
        .padding(.top, 15)
        .animation(.spring(response: 0.2, dampingFraction: 0.5))
    }
}

struct PasswordTextField: View {
    
    let title: String
    let text: Binding<String>

    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(Color.gray)
                .offset(y: text.wrappedValue.isEmpty ? 0 : -25)
                .scaleEffect(text.wrappedValue.isEmpty ? 1 : 0.8, anchor: .leading)
            SecureField("Password", text: text).foregroundColor(Color.black) // give TextField an empty placeholder
        }
        .padding(.top, 15)
        .animation(.spring(response: 0.2, dampingFraction: 0.5))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
