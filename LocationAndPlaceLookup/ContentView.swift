//
//  ContentView.swift
//  LocationAndPlaceLookup
//
//  Created by Daniel Harris on 12/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State var locationManager = LocationManager()
    
    
    var body: some View {
        VStack {
            Text("\(locationManager.location?.coordinate.latitude ?? 0.0), \((locationManager.location?.coordinate.longitude ?? 0.0))")
            let _ = print("\(locationManager.location?.coordinate.latitude ?? 0.0), \((locationManager.location?.coordinate.longitude ?? 0.0))")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
