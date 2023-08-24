//
//  ServiceManager.swift
//  QuickLifts
//
//  Created by Tremaine Grant on 6/27/23.
//

import Foundation
import Combine
import AppTrackingTransparency
import AdSupport

// Service Manager
class ServiceManager: ObservableObject {
    // Initialize services
    let firebaseService = FirebaseService.sharedInstance
    let userService = UserService.sharedInstance
    let notificationService = NotificationService.sharedInstance
    @Published var isConfigured = false

    func configure() async {
        do {
            // Do any other configuration here
            if self.firebaseService.isAuthenticated {
                self.userService.getUser { user, error in
                    
                    guard let u = self.userService.user else {
                        DispatchQueue.main.async {
                            self.isConfigured = true
                            self.requestTrackingAuthorization()
                        }
                        
                        return
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isConfigured = true
                    self.requestTrackingAuthorization()
                }
            }
        } catch {
            print(error)
            self.requestTrackingAuthorization()
        }
    }
    
    func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            // handle the authorization status
            switch status {
            case .authorized:
                // Tracking authorization dialog was shown
                // and permission has been granted.
                print("Permission granted.")
                print(ASIdentifierManager.shared().advertisingIdentifier)
            
            case .denied:
                // Tracking authorization dialog was
                // shown and permission has been denied.
                print("Permission denied.")
            
            case .notDetermined:
                // Tracking authorization dialog has not been shown.
                print("Permission not determined.")
            
            case .restricted:
                // The device is not eligible for tracking.
                print("Permission restricted.")
            
            @unknown default:
                print("Unknown status.")
            }
        })
    }
}
