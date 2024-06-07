//
//  SearchBar.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 1/29/1403 AP.
//

import SwiftUI

struct SearchBar: View {
    @EnvironmentObject var viewModel: ExploreViewModel
    
    @Binding var search: String
    @FocusState var searchIsFocused: Bool
    
    var body: some View {
        HStack {
            
            TextField("Search or type a keyword", text: $search, onEditingChanged: { changed in
                
            })
                .padding(.horizontal, 3)
                .font(.headline)
                .focused($searchIsFocused)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.gray)
                        .font(.headline).bold()
                        .opacity(search.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            search = ""
                            searchIsFocused = false
                        }
                }
                
        }
        .foregroundStyle(.black.opacity(0.7))
        .padding(8)
        .overlay {
            Capsule()
                .stroke(lineWidth: 0.7)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .primary.opacity(0.4) ,radius: 4)
                
        }
        
    }
}

#Preview {
    SearchBar(search: .constant(""))
}
