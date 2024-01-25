//
//  APIManager.swift
//  MusicTrack
//
//  Created by Neosoft on 21/01/24.
//

import Foundation

class APIManager {
    static func loadMusicTracks(completion: @escaping ([MusicTrack]?) -> Void) {
        let apiUrl = "https://cms.samespace.com/items/songs"

        guard let url = URL(string: apiUrl) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error loading data:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON String:", jsonString)
            }

            do {
                let decoder = JSONDecoder()
                let musicTracksResponse = try decoder.decode(MusicTracksResponse.self, from: data)
                completion(musicTracksResponse.data)
            } catch {
                print("Error decoding JSON:", error.localizedDescription)
                completion(nil)
            }
        }.resume()
    }
}
