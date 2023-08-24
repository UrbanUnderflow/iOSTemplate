//
//  HomeView.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    let appCoordinator: AppCoordinator
    let serviceManager: ServiceManager
    
    @Published var showLoader = false
    
    init(appCoordinator: AppCoordinator, serviceManager: ServiceManager) {
        self.appCoordinator = appCoordinator
        self.serviceManager = serviceManager
    }
}

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(appCoordinator: AppCoordinator(serviceManager: ServiceManager()), serviceManager: ServiceManager()))
    }
}
