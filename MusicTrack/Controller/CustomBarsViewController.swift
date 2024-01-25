//
//  CustomBarsViewController.swift
//  MusicTrack
//
//  Created by Neosoft on 23/01/24.
//

import UIKit

class CustomBarsViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet var selectedStateViews: [UILabel]!
    
    @IBOutlet weak var lblForYou: UILabel!
    @IBOutlet weak var lblTopTracks: UILabel!
    
    var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Load the FirstViewController
        handleSelectionTabView(current: 0)
        tabTappedWithTag(0)
    }

    func handleSelectionTabView(current state: Int) {
        selectedStateViews.forEach { selectedView in
            selectedView.isHidden = true
        }

        // Show the selected state view corresponding to the current tag
        if let selectedView = selectedStateViews.first(where: { $0.tag == state }) {
            selectedView.isHidden = false
            
        }
        
        
    }

    @IBAction func tabTapped(_ sender: UIButton) {
        let tag = sender.tag
        handleSelectionTabView(current: tag)
        tabTappedWithTag(tag)
        
        if tag == 0 {
            
        }
    }

    private func tabTappedWithTag(_ tag: Int) {
        // Remove any existing child view controllers
        children.forEach { $0.removeFromParent() }

        // Load the selected view controller
        if tag == 0 {
            let controller = main.instantiateViewController(withIdentifier: String(describing: FirstViewController.self))
            addChild(controller)
            
            containerView?.addSubview(controller.view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
            controller.didMove(toParent: self)
            
            // Set label colors for tag 0
            lblForYou.textColor = UIColor.white
            lblTopTracks.textColor = UIColor.gray
            
            
        } else if tag == 1 {
            let controller = main.instantiateViewController(withIdentifier: String(describing: SecondViewController.self))
            addChild(controller)
            containerView?.addSubview(controller.view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            controller.didMove(toParent: self)
            
            // Set label colors for tag 1
            lblForYou.textColor = UIColor.gray
            lblTopTracks.textColor = UIColor.white
            
            selectedStateViews.forEach { selectedView in
                selectedView.isHidden = false
                
            }
        }
    }
}
