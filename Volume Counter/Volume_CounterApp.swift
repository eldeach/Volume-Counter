//
//  Volume_CounterApp.swift
//  Volume Counter
//
//  Created by 이돈형 on 2023/05/08.
//

import SwiftUI
import GoogleMobileAds

@main
struct Volume_CounterApp: App {
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
