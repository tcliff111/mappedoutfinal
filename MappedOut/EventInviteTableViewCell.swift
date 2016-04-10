//
//  EventInviteTableViewCell.swift
//  MappedOut
//
//  Created by Thomas Clifford on 4/8/16.
//  Copyright © 2016 Codepath. All rights reserved.
//

import UIKit

class EventInviteTableViewCell: UITableViewCell {

    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventAddress: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventStartTime: UILabel!
    @IBOutlet var eventEndTime: UILabel!
    @IBOutlet var eventPicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
