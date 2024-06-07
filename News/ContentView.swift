//
//  ContentView.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 1/27/1403 AP.
//

import SwiftUI

struct ContentView: View {
    @State var showLaunchScreen: Bool = true
   
    var body: some View {
        ZStack {
            if !showLaunchScreen {
                MainTabView()
            } else {
                LaunchScreen()                
            }
        }
        .task {
            await requestAuthorization()
        }
    }
    
    func requestAuthorization() async {
        
       let success = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        guard success != nil else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut) {
                showLaunchScreen = false
            }
        }
    }
}

#Preview {
    ContentView()
}
