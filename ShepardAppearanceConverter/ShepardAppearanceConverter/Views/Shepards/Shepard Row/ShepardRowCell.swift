//
//  ShepardRowCell.swift
//  ShepardAppearanceConverter
//
//  Created by Emily Ivie on 8/12/15.
//  Copyright © 2015 urdnot. All rights reserved.
//

import UIKit

public class ShepardRowCell: UITableViewCell {
    
    let DateMessage = "Last Played: %@"
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    public var photo: UIImage? {
        didSet {
            setupPage()
        }
    }
    public var name: String? {
        didSet {
            setupPage()
        }
    }
    public var date: String? {
        didSet {
            setupPage()
        }
    }
    public var title: String? {
        didSet {
            setupPage()
        }
    }
    
    func setupPage() {
        if let photo = self.photo {
            photoImageView.image = photo
            photoImageView.hidden = false
        } else {
            photoImageView.hidden = true
        }
        if nameLabel == nil { return }
        nameLabel.text = name ?? ""
        titleLabel.text = title
        dateLabel.text = String(format: DateMessage, date ?? "")
    }
    
}
