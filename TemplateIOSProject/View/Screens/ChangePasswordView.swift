//
//  ChangePasswordView.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import SwiftUI

class ChangePasswordViewModel: ObservableObject {
    @Published var appCoordinator: AppCoordinator
    @Published var serviceManager: ServiceManager
    @Published var toastMessage: String = "Password Changed Successfully"
    @Published var showToast: Bool = false
    
    init(appCoordinator: AppCoordinator, serviceManager: ServiceManager) {
        self.serviceManager = serviceManager
        self.appCoordinator = appCoordinator
    }
}

struct ChangePasswordView: View {
    @ObservedObject var viewModel: ChangePasswordViewModel
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        ZStack {
            Color.primaryBlue
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    Text("Change Password")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.secondaryWhite)
                        .padding(.bottom, 16)
                    
                    Text("Enter your old password, new password, and confirm your new password to update your account password.")
                        .foregroundColor(Color.secondaryWhite)
                        .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Old Password")
                            .foregroundColor(.secondaryWhite)
                            .bold()
                        
                        TextFieldWithIcon(text: $oldPassword, placeholder: "Old Password", iconName: "Lock", isSecure: true)
                            .padding(.bottom)
                        
                        Text("New Password")
                            .foregroundColor(.secondaryWhite)
                            .bold()
                        
                        TextFieldWithIcon(text: $newPassword, placeholder: "New Password", iconName: "Lock", isSecure: true)
                            .padding(.bottom)
                        
                        Text("Confirm New Password")
                            .foregroundColor(.secondaryWhite)
                            .bold()
                        
                        TextFieldWithIcon(text: $confirmPassword, placeholder: "Confirm New Password", iconName: "Lock", isSecure: true)
                            .padding(.bottom)
                    }
                    ConfirmationButton(title: "Update Password", type: .secondaryLargeConfirmation) {
                        viewModel.serviceManager.firebaseService.changePassword(oldPassword: oldPassword, newPassword: newPassword) { result in
                                switch result {
                                case .success:
                                    // Handle successful password change
                                    print("Password changed successfully")
                                    showSuccessToast()
                                case .failure(let error):
                                    // Handle error
                                    print("Error changing password: \(error.localizedDescription)")
                                    showErrorToast()
                                }
                            }
                    }
                    .padding(.top)
                    
                    ConfirmationButton(title: "Cancel", type: .clearButton) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.viewModel.appCoordinator.showHomeScreen()
                        }
                    }
                    
                }
                .padding()
                .padding(.top, 64)
                .padding(.horizontal)
            }
            // Toast notification
            if viewModel.showToast {
                VStack {
                    Spacer()
                    ToastView(message: viewModel.toastMessage, backgroundColor: Color.secondaryBlue, textColor: .white, icon: .sfSymbol(.check))
                    .padding()
                }
            }
        }
        .ignoresSafeArea(.all)
    }
    
    func showSuccessToast() {
        // Handle successful password change
        print("Password changed successfully")
        viewModel.toastMessage = "Password changed successfully"
        viewModel.showToast = true
        
        // Hide toast after a few seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            viewModel.showToast = false
        }
    }
    
    func showErrorToast() {
        // Handle successful password change
        print("Password changed was unsuccessful")
        viewModel.toastMessage = "Password changed was unsuccessful"
        viewModel.showToast = true
        
        // Hide toast after a few seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            viewModel.showToast = false
        }
    }
}


struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(viewModel: ChangePasswordViewModel(appCoordinator: AppCoordinator(serviceManager: ServiceManager()), serviceManager: ServiceManager()))
    }
}
