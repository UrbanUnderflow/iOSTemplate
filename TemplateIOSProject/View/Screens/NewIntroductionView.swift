//
//  NewIntroductionView.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import Foundation
import SwiftUI

class NewUserIntroductionViewModel: ObservableObject {
    @Published var appCoordinator: AppCoordinator
    
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
}

struct NewUserIntroductionView: View {
    @State private var continuePressed: Bool = false
    @ObservedObject var viewModel: NewUserIntroductionViewModel
    
    var body: some View {
        ZStack {
            Color.primaryBlue
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    Text("Getting to know you.")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                }
                
                (Text("In the ") + Text("Identity phase").bold().foregroundColor(.blue) + Text(", we help you understand yourself better through a series of questions."))
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.leading)

                (Text("Your answers create a ") + Text("personalized experience").foregroundColor(.blue).bold() + Text(", helping the AI learn your interests, goals, and preferences."))
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.leading)

                (Text("Our goal: help you achieve ") + Text("personal growth").bold().foregroundColor(.blue) + Text(", make informed decisions, and discover tailored opportunities."))
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.leading)

                (Text("As the AI learns more about you, it provides ") + Text("accurate and relevant recommendations").bold().foregroundColor(.blue) + Text(", guiding your self-discovery and improvement journey."))
                    .foregroundColor(.white)
                    .padding()
                    .multilineTextAlignment(.leading)
                
                Spacer()
                ConfirmationButton(title: "Continue", type: ButtonType.secondaryBlue) {
                    //Show what ever we need to show for quicklifts
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 20)
            }
        }
    }
}
