//
//  DestinationSearchView.swift
//  Airbnb
//
//  Created by Maryam Kaveh on 2/1/1403 AP.
//

import SwiftUI

enum SearchOptions {
    case location
    case dates
    case guests
}

struct DestinationSearchView: View {
    
    @StateObject var viewModel: ExploreViewModel
    
    @Binding var showDestinationSearchView: Bool
    @State private var selectedOption: SearchOptions = .location
    @State  var selectedStartDate: Date = Date()
    @State  var selectedEndDate: Date = Date()
    @State var selectedGuests: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            VStack(alignment: .leading) {
                if selectedOption == .location {
                    Text("Where to?")
                        .font(.headline).fontWeight(.bold)
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.caption)
                           
                    }
                    .padding(6)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(Color(.systemGray4))
                    }
                    
                } else {
                    CollapsedPickerView(title: "Where?", desc: "Add destination")
                }
            }
            .collapsibleSearchOptionStyle(selectedOption: .location)
            .frame(height: selectedOption == .location ? 155 : 64)
            .onTapGesture {
                withAnimation(.spring) {
                    selectedOption = .location
                }
            }
            
            // date selection
            VStack {
                if selectedOption == .dates {
                    VStack(alignment: .leading) {
                        Text("When's you trip?")
                            .font(.headline).fontWeight(.bold)
                        HStack {
                            
                            Text("From")
                                .foregroundStyle(.secondary)
                            Spacer()
                            DatePicker("", selection: $selectedStartDate, displayedComponents: .date)
                                
                        }
                        Divider()
                        HStack {
                            
                            Text("To")
                                .foregroundStyle(.secondary)
                            Spacer()
                            DatePicker("", selection: $selectedEndDate, displayedComponents: .date)
                        }
                        
                    }
                    
                } else {
                    CollapsedPickerView(title: "When?", desc: "Add dates")
                }
            }
            .collapsibleSearchOptionStyle(selectedOption: .dates)
            .frame(height: selectedOption == .dates ? 155 : 64)
            .onTapGesture {
                withAnimation(.spring) {
                    selectedOption = .dates
                }
            }
            
            // num guests selection
            VStack {
                if selectedOption == .guests {
                    VStack(alignment: .leading) {
                        Text("Who's coming?")
                            .font(.headline).fontWeight(.bold)
                        HStack {
                            Stepper {
                                Text("\(selectedGuests) Adults")
                                    .font(.subheadline).fontWeight(.semibold)
                            } onIncrement: {
                                selectedGuests += 1
                            } onDecrement: {
                                guard selectedGuests > 0 else {
                                    return
                                }
                                selectedGuests -= 1
                            }

                        }
                    }
                } else {
                    CollapsedPickerView(title: "Who", desc: "Add guests")
                }
            }
            .collapsibleSearchOptionStyle(selectedOption: .guests)
            .frame(height: selectedOption == .guests ? 155 : 64)
            .onTapGesture {
                withAnimation(.spring) {
                    selectedOption = .guests
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    withAnimation {
                      //viewModel.filterListingsByLocation()
                        showDestinationSearchView.toggle()
                    }
                }, label: {
                    Image(systemName: "xmark.circle")
                        .font(.headline.bold())
                        .foregroundStyle(.black.opacity(0.7))
                })
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
//                    viewModel.searchLocation = ""
//                    viewModel.filterListingsByLocation()
                } label: {
                    Text("Clear")
                        .font(.headline)
                    
                }
//                .opacity(viewModel.searchLocation == "" ? 0 : 1)

            }
        }
    }
    
}

#Preview {
    DestinationSearchView(viewModel: ExploreViewModel(service: NewsService(), bookmarkManager: BookmarkManager()), showDestinationSearchView: .constant(true), selectedStartDate: Date(), selectedEndDate: Date())
}

struct CollapsedPickerView: View {
    let title: String
    let desc: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .foregroundStyle(.gray)
                
                Spacer()
                Text(desc)
            }
            .font(.subheadline).fontWeight(.semibold)
        }
    }
}


struct CollapsibleSearchOptionStyle : ViewModifier {
    
   func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .primary.opacity(0.4), radius: 6)
    }
    
}

extension View {
    func collapsibleSearchOptionStyle(selectedOption: SearchOptions) -> some View {
        self.modifier(CollapsibleSearchOptionStyle())
    }
}
