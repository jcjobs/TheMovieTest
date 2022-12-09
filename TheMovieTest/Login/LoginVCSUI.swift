//
//  LoginVCSUI.swift
//  TheMovieTest
//
//  Created by Juan Carlos Perez Delgadillo on 24/11/22.
//

import SwiftUI
import Combine

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)

struct LoginVCSUI: View {
    private var viewModel: LoginProtocol = LoginVM()
    private var coordinator: CoordinatorProtocol

    @State private var isLoading = true
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var successLogin = false
    @State private var error: ErrorInfo?
    
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        let navigation = NavigationView {
            ZStack {
                BackgroundImage()
                
                VStack {
                    WelcomeText()
                    
                    ActivityIndicator(isAnimating: isLoading) {
                        $0.color = .green
                        $0.hidesWhenStopped = true
                    }
                    .padding(.bottom, 16)
                    
                    TextField("Username", text: $username)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom, 24)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(lightGreyColor)
                        .cornerRadius(5.0)
                        .padding(.bottom, 24)
                    
                    Button(action: {
                        viewModel.makeLogin(with: username, and: password)
                    }) {
                        LoginButtonContent()
                    }
                }
                .padding()
                
            }
            .alert(item: $error, content: { error in
                Alert(
                    title: Text(error.title),
                    message: Text(error.description),
                    dismissButton: .default(Text("Ok"), action: {
                        
                    })
                )
            })
        }
        .onAppear {
            print("LoginVCSUI appeared!")
        }
        .onDisappear {
            print("LoginVCSUI disappeared!")
        }
        //.padding(.init(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
        //.padding()
        .edgesIgnoringSafeArea(.all)
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        
        return navigation
            .onReceive(viewModel.isLoading.receive(on: RunLoop.main)) { outPut in
                isLoading = outPut
            }
            .onReceive(viewModel.loginSucced.receive(on: RunLoop.main)) { outPut in
                //error = ErrorInfo(id: 3, title: "Exito", description: "Success login...")
                self.successLogin = true

                coordinator.showHomeView()
            }
            .onReceive(viewModel.processError.receive(on: RunLoop.main)) { outPut in
                error = ErrorInfo(id: 3, title: "Error", description: outPut.localizedDescription)
            }
    }
}

#if DEBUG
struct LoginVCSUI_Previews: PreviewProvider {
    static var previews: some View {
        let coordinator = Coordinator()
        LoginVCSUI(coordinator: coordinator)
    }
}
#endif


struct WelcomeText : View {
    var body: some View {
        return Text("Welcome!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 24)
            .foregroundColor(.white)
    }
}

struct LoginButtonContent : View {
    var body: some View {
        return Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}
