//
//  AppCoordinator.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/24/23.
//
import SwiftUI

protocol Screen {
    func makeView(serviceManager: ServiceManager, appCoordinator: AppCoordinator) -> AnyView
}

class AppCoordinator: ObservableObject {
    enum Screen {
        case splash
        case introView
        case registration
        case appIntro
        case home
        case changePassword
        case profile
        case freeTrial
    }
    
    @Published var currentScreen: Screen = .splash
    @Published var modalScreen: Screen?
    @ObservedObject var serviceManager: ServiceManager
    
    init(serviceManager: ServiceManager) {
        self.serviceManager = serviceManager
    }
    
    func handleLogin() {
        // Check if user is already authenticated, if yes move to the question screen
        if serviceManager.firebaseService.isAuthenticated {
            self.handleLoginSuccess()
        } else {
            showIntroScreen()
        }
    }
    
    func signUpUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        serviceManager.firebaseService.signUpWithEmailAndPassword(email: email, password: password) { result in
            switch result {
            case .success(_):
                completion(.success("success"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        serviceManager.firebaseService.signInWithEmailAndPassword(email: email, password: password) { result in
            switch result {
            case .success(_):
                completion(.success("success"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func handleLogout() {
        // Sign out the user and move back to the login screen
        do {
            try serviceManager.firebaseService.signOut()
            serviceManager.userService.user = nil
        } catch { error
            print(error)
        }
        showIntroScreen()
    }
    
    func handleLoginSuccess() {
        // Move to the question screen after successful login
        showHomeScreen()
    }
    
    ///This is a setter screen to handle setting the screens and adding transitions
    func setCurrentScreen(_ newScreen: Screen) {
        withAnimation {
            currentScreen = newScreen
        }
    }
    
    
    // Show Screens
    func showSplashScreen() {
        setCurrentScreen(.splash)
    }
    
    /// Show screen functions
    func showIntroScreen() {
        setCurrentScreen(.introView)
    }
    
    
    func showChangePassword() {
        currentScreen = .changePassword
    }
    
    func showProfile() {
        currentScreen = .profile
    }
    
    func showHomeScreen() {
        currentScreen = .home
    }
    
    func showAppIntro() {
        currentScreen = .appIntro
    }
}

extension AppCoordinator.Screen: Screen {
    func makeView(serviceManager: ServiceManager, appCoordinator: AppCoordinator) -> AnyView {
        switch self {
        case .splash:
            return AnyView(
                SplashLoader(viewModel: SplashLoaderViewModel(serviceManager: serviceManager, appCoordinator: appCoordinator))
                    .onAppear {
                        Task {
                            do {
                                try await serviceManager.configure()
                                await Task.sleep(5 * 1_000_000_000) // Wait for 5 seconds
                                await appCoordinator.handleLogin()
                            } catch {
                                print("Configuration failed: \(error)")
                            }
                        }
                    }
            )
        case .introView:
            return AnyView(
                IntroView(viewModel: IntroViewViewModel(serviceManager: serviceManager, appCoordinator: appCoordinator))
            )
        case .appIntro:
            return AnyView(
                NewUserIntroductionView(viewModel: NewUserIntroductionViewModel(appCoordinator: appCoordinator))
            )
        case .home:
            return AnyView(
                HomeView(viewModel: HomeViewModel(appCoordinator: appCoordinator, serviceManager: serviceManager))
            )
        case .changePassword:
            return AnyView(
                ChangePasswordView(viewModel: ChangePasswordViewModel(appCoordinator: appCoordinator, serviceManager: serviceManager))
            )
        case .profile:
            return AnyView(
                ProfileView(viewModel: ProfileViewModel(serviceManager: serviceManager, appCoordinator: appCoordinator))
            )
        case .registration:
            return AnyView(
                RegistrationView()
            )
        case .freeTrial:
            return AnyView(
                FreeTrialView()
            )
        }
    }
}

