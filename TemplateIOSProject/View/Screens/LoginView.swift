//
//  LoginView.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var appCoordinator: AppCoordinator
    @Published var email = ""
    @Published var password = ""
    @Published var isSignUp = false
    @Published var showPassword = false
    @Published var errorMessage: String?
    
    init(appCoordinator: AppCoordinator, isSignUp: Bool) {
        self.appCoordinator = appCoordinator
        self.isSignUp = isSignUp
    }
    
    func signUp(email: String, password: String) {
        self.appCoordinator.signUpUser(email: email, password: password) { result in
            switch result {
            case .success(let message):
                print(message)
                self.appCoordinator.serviceManager.userService.getUser { user, error in
                    //got user
                    print(user)
                }
                self.appCoordinator.showAppIntro()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signIn(email: String, password: String) {
        self.appCoordinator.signIn(email: email, password: password) { result in
            switch result {
            case .success(let message):
                print(message)
                self.appCoordinator.handleLogin()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Path")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                }
                Spacer()
            }
            VStack {
                Text(viewModel.isSignUp ? "Sign Up" : "Log In")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                
                TextFieldWithIcon(text: $viewModel.email, placeholder: "Email address", iconName: "Message", isSecure: false)
                    .padding(.horizontal, 20)
                Spacer()
                    .frame(height:20)
                TextFieldWithIcon(text: $viewModel.password, placeholder: "Password", iconName: "Lock", isSecure: true)
                    .padding(.horizontal, 20)
                
                HStack {
                    Spacer()
                    Text("Forgot Password?")
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 25)
                }
                
                if viewModel.isSignUp {
                    ConfirmationButton(title: "Sign Up", type: .secondaryLargeConfirmation) {
                        viewModel.signUp(email: viewModel.email, password: viewModel.password)

                    }
                    .padding(.horizontal, 16)
                } else {
                    ConfirmationButton(title: "Login", type: .secondaryLargeConfirmation) {
                        viewModel.signIn(email: viewModel.email, password: viewModel.password)
                    }
                    .padding(.horizontal, 16)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button(viewModel.isSignUp ? "Already have an account? Log in" : "Don't have an account? Sign up") {
                    viewModel.isSignUp.toggle()
                }
                .foregroundColor(.white)
                .padding(.top)
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(appCoordinator: AppCoordinator(serviceManager: ServiceManager()), isSignUp: true))
    }
}

