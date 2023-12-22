//
//  CreateNoteViewModel.swift
//  NearbyNotes
//
//  Created by Emilio Schepis on 15/12/23.
//

import Factory
import Foundation
import PhotosUI
import Supabase
import SwiftUI

class CreateNoteViewModel: ObservableObject {
    @Injected(\.supabase) private var supabase
    @Injected(\.authenticationManager) private var authenticationManager
    @Injected(\.locationManager) private var locationManager
    
    @Published var content = ""
    @Published var image: PhotosPickerItem?
    
    var canCreate: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        authenticationManager.currentUser != nil &&
        locationManager.location != nil
    }
    
    @MainActor func createNote() async throws {
        guard let profileId = authenticationManager.currentUser?.id.uuidString else {
            return
        }
        
        guard let location = locationManager.location else {
            return
        }
        
        var filePath: String?
        
        if let image {
            guard let contentType = image.supportedContentTypes.first else {
                return
            }
            
            guard let mimeType = contentType.preferredMIMEType else {
                return
            }
            
            guard let fileExtension = contentType.preferredFilenameExtension else {
                return
            }
            
            guard let imageData = try await image.loadTransferable(type: Data.self) else {
                return
            }
            
            let fileName = "\(UUID().uuidString.lowercased()).\(fileExtension)"
            let fileOptions = FileOptions(contentType: mimeType)
            
            filePath = "\(profileId.lowercased())/\(fileName)"
            
            try await supabase.storage
                .from("images")
                .upload(path: filePath!, file: imageData, options: fileOptions)
        }
        
        try await supabase.database
            .from("notes")
            .insert([
                "content": content,
                "profile_id": profileId,
                "location": "SRID=4326;POINT(\(location.longitude) \(location.latitude))",
                "image": filePath
            ])
            .execute()
    }
}
