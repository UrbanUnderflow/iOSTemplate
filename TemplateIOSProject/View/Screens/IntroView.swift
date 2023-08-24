//
//  IntroView.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import SwiftUI
import AVKit

class IntroViewViewModel: ObservableObject {
    var serviceManager: ServiceManager
    var appCoordinator: AppCoordinator
    @Published var loginPressed: Bool = false
    @Published var newUser: Bool = false
    
    init(serviceManager: ServiceManager, appCoordinator: AppCoordinator) {
        self.serviceManager = serviceManager
        self.appCoordinator = appCoordinator
    }
    
    func newUserButtonPressed(){
        self.loginPressed = true
        self.newUser = true
    }
    
    func existingUserButtonPressed() {
        self.loginPressed = true
        self.newUser = false
    }
    
}

struct IntroView: View {
    @ObservedObject var viewModel: IntroViewViewModel
    @State private var selection = 0
    private let url = Bundle.main.url(forResource: "background_video", withExtension: "mov")!
    
    var body: some View {
        ZStack {
            PlayerView(url: url)
                .edgesIgnoringSafeArea(.all)
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
            if !viewModel.loginPressed {
                Group {
                    VStack {
                        Text("Path")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                        
                        TabView(selection: $selection) {
                            // Onboarding texts
                            OnboardingView(title: "Journaling", description: "Journaling is a powerful tool for self-reflection and personal growth.")
                            OnboardingView(title: "Self-Discovery", description: "Discover your strengths, weaknesses, and passions to help guide your path forward.")
                            OnboardingView(title: "Exploration", description: "Explore new opportunities and experiences to expand your horizons.")
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.existingUserButtonPressed()
                            }) {
                                Text("Returning User")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.black)
                            .cornerRadius(30)
                            Spacer()
                                .frame(width:20)
                            Button(action: {
                                viewModel.newUserButtonPressed()
                            }) {
                                Text("New User")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(30)
                            Spacer()
                        }
                        .padding(.bottom, 50)
                    }
                }
                .foregroundColor(.white)
            } else {
                LoginView(viewModel: LoginViewModel(appCoordinator: viewModel.appCoordinator, isSignUp: viewModel.newUser))
            }
        }
    }
}


struct OnboardingView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.title2)
                .bold()
            Text(description)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}


struct IntroScreen_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(viewModel: IntroViewViewModel(serviceManager: ServiceManager(), appCoordinator: AppCoordinator(serviceManager: ServiceManager())))
    }
}

