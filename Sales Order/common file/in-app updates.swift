//
//  in-app updates.swift
//  Sales Order
//
//  Created by Mani V on 03/10/24.
//
import Foundation
import SwiftUI

class UpdateManager: ObservableObject {
    
    @Published var isUpdateAvailable: Bool = false
    @Published var appStoreVersion: String?
    @Published var errorMessage: String?
    
    // Check for update by querying the iTunes Lookup API
    func checkForUpdate() {
        guard let bundleID = Bundle.main.bundleIdentifier,
              let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)") else {
            self.errorMessage = "Failed to get Bundle ID or URL."
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching app version: \(error?.localizedDescription ?? "Unknown error")"
                }
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String {
                    print(json)
                    print(results)
                    print(appStoreVersion)
                    
                    // Get the current version of the app
                    if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        print("App Store Version: \(appStoreVersion), Current Version: \(currentVersion)")
                        
                        // Compare the current version with the App Store version
                        DispatchQueue.main.async {
                            if currentVersion != appStoreVersion {
                                self.isUpdateAvailable = true
                                self.appStoreVersion = appStoreVersion
                            } else {
                                self.errorMessage = "App is already up-to-date."
                            }
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error parsing JSON: \(error)"
                }
            }
        }
        task.resume()
    }
    
    // Prompt user to update the app
    func promptUserToUpdate() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/6478862577") else {
            self.errorMessage = "Invalid App Store URL."
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            self.errorMessage = "Cannot open App Store URL."
        }
    }
}
