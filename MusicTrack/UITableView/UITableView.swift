//
//  UITableView.swift
//  MusicTrack
//
//  Created by Neosoft on 20/01/24.
//



import UIKit
import Foundation
 
public extension UITableView {
    
    /*
     * Method name: registerCellNib
     * Description: use to register cell
     * Parameters: identifier of the cell
     * Return:  -
     */
    func registerCellNib(_ identifier: String ) {
        self.rowHeight = UITableView.automaticDimension
        self.tableFooterView = UIView()
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
}
    
