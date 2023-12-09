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
    
    var body: some View {
        Map(position: $position, interactionModes: [.rotate, .zoom]) {
            UserAnnotation()
            
            if let center = locationManager.location {
                MapCircle(center: center, radius: 1000)
                    .foregroundStyle(.tint.opacity(0.2))
                    .stroke(.tint, lineWidth: 2)
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
    }
}

#Preview {
    MapView()
}
