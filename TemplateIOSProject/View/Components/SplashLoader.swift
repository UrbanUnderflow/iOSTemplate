//
//  SplashLoader.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import SwiftUI
import AVFoundation

class SplashLoaderViewModel: ObservableObject {
    var serviceManager: ServiceManager
    var appCoordinator: AppCoordinator
    
    init(serviceManager: ServiceManager, appCoordinator: AppCoordinator) {
        self.serviceManager = serviceManager
        self.appCoordinator = appCoordinator
    }
}

struct SplashLoader: View {
    @State var viewModel: SplashLoaderViewModel
    @State private var selection = 0
    private let videoURL = Bundle.main.url(forResource: "broll3", withExtension: "mov")!
    @State private var hasPlayedSoundEffect = false
    let soundEffect = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "chirping", withExtension: "mp3")!)
    
    var body: some View {
        ZStack {
            PlayerView(url: videoURL)
                .edgesIgnoringSafeArea(.all)
                .opacity(selection == 0 ? 0 : 1) // Set initial opacity to 0
                .animation(.easeInOut(duration: 1)) // Add animation
            VStack {
                Spacer()
                Text("Path")
                    .font(.system(size: 62, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .opacity(selection == 0 ? 0 : 1)
                    .animation(.easeInOut(duration: 1))
                    .onAppear {
                        self.selection = 1
                    }
                Spacer()
            }
        }
        .onAppear {
            if !hasPlayedSoundEffect {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    soundEffect?.play()
                    hasPlayedSoundEffect = true
                }
            }
        }
    }
}

struct SplashLoader_Previews: PreviewProvider {
    static var previews: some View {
        SplashLoader(viewModel: SplashLoaderViewModel(serviceManager: ServiceManager(), appCoordinator: AppCoordinator(serviceManager: ServiceManager())))
    }
}
