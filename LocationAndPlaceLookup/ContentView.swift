//
//  ContentView.swift
//  LocationAndPlaceLookup
//
//  Created by Daniel Harris on 12/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State var locationManager = LocationManager()
    @State var selectedPlace: Place?
    @State private var sheetIsPresented = false
    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(selectedPlace?.name ?? "n/a")
                    .font(.title2)
                Text(selectedPlace?.address ?? "n/a")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text("\(selectedPlace?.lattitude ?? 0.0), \(selectedPlace?.longitude ?? 0.0)")
            }
            
            Spacer()
            
            Button {
                sheetIsPresented.toggle()
            } label: {
                Image(systemName: "location.magnifyingglass")
                Text("Location Search")
            }
            .buttonStyle(.borderedProminent)
            .font(.title2)

        }
        .padding()
        .task {
            // Get user location when the view appears
            // Handle case if user already authorized location use
            if let location = locationManager.location {
                selectedPlace = await Place(location: location)
            }
            
            //Setup a location callback - this handles when new locations come in after the app launches - it will catch the first locationUpdate, which is what we need, otherwise we won't see the inforamtion in the VStack update after the user first authorizes location use.
            locationManager.locationUpdated = { location in
                    // We know we now have a new location, so use it to update the selectedPlace
                Task { // <- So we make it one with Task
                    selectedPlace = await Place(location: location)
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            PlaceLookupView(locationManager: locationManager, selectedPlace: $selectedPlace)
        }
    }
}

#Preview {
    ContentView()
}
