//
//  FirstViewController.swift
//  MusicTrack
//
//  Created by Neosoft on 24/01/24.
//


import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var musicTrackingTableView: UITableView!
    private let cellReuseIdentifier = "MusicTrackTableViewCell"
    private var musicTracks: [MusicTrack] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadMusicTracks()
    }

    private func configureUI() {
        musicTrackingTableView.register(UINib(nibName: "MusicTrackTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        musicTrackingTableView.dataSource = self
        musicTrackingTableView.delegate = self
        musicTrackingTableView.backgroundColor = .black
        musicTrackingTableView.bounces = false
        musicTrackingTableView.bouncesZoom = false
        musicTrackingTableView.alwaysBounceVertical = false
        musicTrackingTableView.alwaysBounceHorizontal = false
        musicTrackingTableView.reloadData()
    }

    private func loadMusicTracks() {
        APIManager.loadMusicTracks { [weak self] musicTracks in
            if let musicTracks = musicTracks {
                self?.musicTracks = musicTracks
                DispatchQueue.main.async {
                    self?.musicTrackingTableView.reloadData()
                }
            } else {
                // Handle the case when musicTracks is nil (e.g., show an error message)
            }
        }
    }
}

extension FirstViewController: UITableViewDataSource, UITableViewDelegate {

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

        let track = musicTracks[indexPath.row]
        cell.configure(with: track)

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

extension MusicTrackTableViewCell {
    func configure(with track: MusicTrack) {
        lblTitleName.text = track.name
        lblArtisttDetailName.text = track.artist

        if let coverURL = URL(string: "https://cms.samespace.com/assets/\(track.cover)") {
            URLSession.shared.dataTask(with: coverURL) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    print("Failed to fetch album cover image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let coverImage = UIImage(data: data)

                // Update the cell's image on the main thread
                DispatchQueue.main.async {
                    self?.coverImageView.image = coverImage
                }
            }.resume()
        }
    }
}
