//
//  PlaceLookupView.swift
//  LocationAndPlaceLookup
//
//  Created by Daniel Harris on 12/04/2025.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    let locationManager: LocationManager // Passed in from the parent View
    @State var placeVM = PlaceLookupViewModel()
    @State private var searchText = ""
    @State private var searchTask: Task<Void, Never>?
    @State private var searchRegion = MKCoordinateRegion()
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack {
            List(placeVM.places) { place in
                VStack(alignment: .leading){
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Location Search")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onAppear { // Only need to get searchRegion when View appears
            searchRegion = locationManager.getRegionAroundCurrentLocation() ?? MKCoordinateRegion()
            
        }
        .onDisappear(){
            searchTask?.cancel() // Cancel any outstanding Task when View dismisses
        }
        .onChange(of: searchText) {oldValue, newValue in
            searchTask?.cancel() // Stop any existing tasks that haven't been completed
            // If search string is empty, clear out the list
            guard !newValue.isEmpty else {
                placeVM.places.removeAll()
                return
            }
            // Create a new search task
            searchTask = Task {
                do{
                    // Wait 300ms before running the current task. Any typing before the task has run cancels the old task. This prevents searches happening quickly if a user types fast, and will reduce chances Apple cuts of search because too many searches execute too quickly
                    try await Task.sleep(for: .milliseconds(300))
                    // Check if task was called during sleep - if so, return & wait for new task to run, or more typing to happen
                    if Task.isCancelled { return }
                    if searchText == newValue {
                        try await placeVM.search(text: newValue, region: searchRegion)
                    }
                } catch {
                    if !Task.isCancelled {
                        print("😡 ERROR: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

#Preview {
    PlaceLookupView(locationManager: LocationManager())
}
