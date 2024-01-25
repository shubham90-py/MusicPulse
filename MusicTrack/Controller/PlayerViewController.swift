//
//  PlayerViewController.swift
//  MusicTrack
//
//  Created by Neosoft on 22/01/24.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var holder: UIView!
    @IBOutlet weak var musicTrackCollectionView: UICollectionView!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.layer.cornerRadius = playPauseButton.frame.size.width / 2
            playPauseButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var lblMusicName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    
    @IBOutlet weak var musicPlaySlider: UISlider!
    @IBOutlet weak var lblMusicStartingTime: UILabel!
    @IBOutlet weak var lblMusicEndingTime: UILabel!
    
    var timer: Timer?
    var isPlayerReady = false
    
    var player: AVAudioPlayer?
    public var musicTracks: [MusicTrack] = []
    var selectedMusicTrackIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        musicPlayerSetup()
        requestAudioPermissions()
       
    }

    func musicPlayerSetup() {
        guard selectedMusicTrackIndex < musicTracks.count else {
            return
        }

        let selectedMusicTrack = musicTracks[selectedMusicTrackIndex]

        guard let musicURL = URL(string: selectedMusicTrack.url) else {
            return
        }

        print("Music URL: \(musicURL)")

        URLSession.shared.dataTask(with: musicURL) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching audio data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                self.player = try AVAudioPlayer(data: data)
                self.player?.delegate = self
                self.player?.prepareToPlay()
                self.isPlayerReady = true
            } catch let error {
                print("Error initializing AVAudioPlayer: \(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                self.updateUI()
            }

        }.resume()

        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateEndingTimeLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimerLabel() {
            let currentTime = player?.currentTime ?? 0
            let minutes = Int(currentTime) / 60
            let seconds = Int(currentTime) % 60

            lblMusicStartingTime.text = String(format: "%02d:%02d", minutes, seconds)
        
    }
    
    @objc func updateEndingTimeLabel() {
        guard let duration = player?.duration else {
            return
        }
        
        let totalMinutes = Int(duration) / 60
        let totalSeconds = Int(duration) % 60
        
        lblMusicEndingTime.text = String(format: "%02d:%02d", totalMinutes, totalSeconds)
    }

    func configUI() {
        musicPlaySlider.setThumbImage(UIImage(), for: .normal)
        self.musicTrackCollectionView.dataSource = self
        self.musicTrackCollectionView.delegate = self
        self.musicTrackCollectionView.register(UINib(nibName: "MusicTrackCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: MusicTrackCollectionViewCell.collectionCellIdentifier())

        if let flowLayout = musicTrackCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        updateUI()
    }
    
    func requestAudioPermissions() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }

   
    
    @IBAction func playPauseButtonAction(_ sender: Any) {
        if(player?.isPlaying == true) {
            player?.stop()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        } else {
            player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            musicPlaySlider.maximumValue = Float(player?.duration ?? 0)
            
        }
    }
    
    @objc func updateSlider() {
        musicPlaySlider.value = Float(player?.currentTime ?? 0)
    }
    
    
    @IBAction func didTapBackButtonAction(_ sender: Any) {
        if selectedMusicTrackIndex > 0 {
            selectedMusicTrackIndex -= 1
            updateUI()
        }
        
    }
    
    @IBAction func didTapNextButtonAction(_ sender: Any) {
        if selectedMusicTrackIndex < (musicTracks.count - 1) {
            selectedMusicTrackIndex += 1
           
            updateUI()
            playMusic()
        }
    }
    private func playMusic() {
           player?.stop()
           player?.currentTime = 0
           player?.prepareToPlay()
           player?.play()
           playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
           musicPlaySlider.maximumValue = Float(player?.duration ?? 0)
       }
       
   
    
    @IBAction func changeActionTime(_ sender: Any) {
        player?.stop()
        player?.currentTime = TimeInterval(musicPlaySlider.value)
        player?.prepareToPlay()
        player?.play()
        updateTimerLabel()
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    func updateUI() {
        // Update the collection view based on the selected index
        let indexPath = IndexPath(item: selectedMusicTrackIndex, section: 0)
        musicTrackCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateBackgroundColor()

    }
    
    func updateBackgroundColor() {
        let selectedMusicTrack = musicTracks[selectedMusicTrackIndex]
        
        // Convert the accent color hex to UIColor
        let accentColor = UIColor(hex: selectedMusicTrack.accent)
        
        // Set the background color of backgroundView
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.backgroundColor = accentColor
        }
        // Set the name and artist labels
        lblMusicName.text = selectedMusicTrack.name
        lblArtistName.text = selectedMusicTrack.artist
    }
}

extension PlayerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicTracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = musicTrackCollectionView.dequeueReusableCell(withReuseIdentifier: MusicTrackCollectionViewCell.collectionCellIdentifier(), for: indexPath) as? MusicTrackCollectionViewCell else {
            return UICollectionViewCell()
        }
        let musicTrack = musicTracks[indexPath.item]

        // Set the placeholder image initially
        cell.musicTrackImageView.image = UIImage(systemName: "pause.fill")

        // Fetch and set album cover image
        if let coverURL = URL(string: "https://cms.samespace.com/assets/\(musicTrack.cover)") {
            URLSession.shared.dataTask(with: coverURL) { data, _, error in
                guard let data = data, error == nil else {
                    print("Failed to fetch album cover image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let coverImage = UIImage(data: data)

                // Update the cell's image on the main thread
                DispatchQueue.main.async {
                    cell.musicTrackImageView.image = coverImage
                }
            }.resume()
        }

        return cell
    }
}


extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


