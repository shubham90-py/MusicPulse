//
//  MusicTrackModel.swift
//  MusicTrack
//
//  Created by Neosoft on 20/01/24.
//

import Foundation
import UIKit

struct MusicTrack: Decodable {
    
    let id: Int
    let status: String
    let userCreated: String
    let dateCreated: String
    let userUpdated: String
    let dateUpdated: String
    let name: String
    let artist: String
    let accent: String
    let cover: String
    let topTrack: Bool
    let url: String
    
    
    var coverImage: UIImage?

    enum CodingKeys: String, CodingKey {
        case id, status, userCreated = "user_created", dateCreated = "date_created", userUpdated = "user_updated", dateUpdated = "date_updated", name, artist, accent, cover, topTrack = "top_track", url
    }
}


struct MusicTracksResponse: Decodable {
    let data: [MusicTrack]
}
