//
//  AirButtonView.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 2/3/1403 AP.
//

import SwiftUI

struct AirButtonView: View {
    let title: String
    let width: Double
    let buttonColor = Color(#colorLiteral(red: 0.1261326373, green: 0.8177895546, blue: 0.6941453218, alpha: 1))
    
    var body: some View {
        Button(action: {
            
        }, label: {
            Text(title)
                .font(.headline)
                .padding()
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .frame(width: width, height: 40)
                .background(buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        })
        .shadow(color: .gray, radius: 2)
    }
}

#Preview {
    AirButtonView(title: "Reserve", width: 140)
}
