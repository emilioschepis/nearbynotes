//
//  MapView.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 09/12/23.
//

import Factory
import MapKit
import SwiftUI

struct MapView: View {
    @InjectedObject(\.locationManager) private var locationManager
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    let radius: Double
    let notes: [Note]
    @Binding var selectedNote: Note?
    
    var body: some View {
        Map(position: $position, selection: $selectedNote) {
            UserAnnotation()
            
            if let center = locationManager.location {
                MapCircle(center: center, radius: radius)
                    .foregroundStyle(.tint.opacity(0.2))
                    .stroke(.tint, lineWidth: 2)
            }
            
            ForEach(notes) {
                Marker("", systemImage: "text.bubble.fill", coordinate: $0.coordinate)
                    .annotationTitles(.hidden)
                    .tag($0)
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .mapControls {
            MapUserLocationButton()
        }
    }
}

#Preview {
    MapView(radius: 1000, notes: [.example], selectedNote: .constant(nil))
}
