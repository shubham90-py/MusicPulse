//
//  SecondViewController.swift
//  MusicTrack
//
//  Created by Neosoft on 24/01/24.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var musicTrackingTableView: UITableView!
    
    let cellReuseIdentifier = "MusicTrackTableViewCell"
    var musicTracks: [MusicTrack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMusicTracks()
        configureUI()
      
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func configureUI() {
        
        musicTrackingTableView.register(UINib(nibName: "MusicTrackTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicTrackTableViewCell")
        musicTrackingTableView.dataSource = self
        musicTrackingTableView.delegate = self
        musicTrackingTableView.backgroundColor = UIColor.black
        
        musicTrackingTableView.bounces = false
        musicTrackingTableView.bouncesZoom = false
        musicTrackingTableView.alwaysBounceVertical = false
        musicTrackingTableView.alwaysBounceHorizontal = false

        musicTrackingTableView.reloadData()
    }

    func loadMusicTracks() {
            APIManager.loadMusicTracks { [weak self] musicTracks in
                if let musicTracks = musicTracks {
                    // Filter the music tracks where topTrack is true
                    self?.musicTracks = musicTracks.filter { $0.topTrack }
                    
                    DispatchQueue.main.async {
                        self?.musicTrackingTableView.reloadData()
                    }
                } else {
                    // Handle the case when musicTracks is nil (e.g., show an error message)
                }
            }
        }
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? MusicTrackTableViewCell else {
            return UITableViewCell()
        }
        
        var track = musicTracks[indexPath.row]
        cell.lblTitleName.text = track.name
        cell.lblArtisttDetailName.text = track.artist
        
        if let coverURL = URL(string: "https://cms.samespace.com/assets/\(track.cover)") {
            URLSession.shared.dataTask(with: coverURL) { data, _, error in
                guard let data = data, error == nil else {
                    print("Failed to fetch album cover image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let coverImage = UIImage(data: data)
                
                // Update the cell's image on the main thread
                DispatchQueue.main.async {
                    cell.coverImageView.image = coverImage
                }
            }.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicTrackingTableView.deselectRow(at: indexPath, animated: true)
        
        let position = indexPath.row
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "player") as? PlayerViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        vc.musicTracks = musicTracks
        vc.selectedMusicTrackIndex = position
        present(vc, animated: true)
        
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}






