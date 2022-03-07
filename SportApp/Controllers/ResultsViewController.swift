//
//  ResultsViewController.swift
//  SportApp
//
//  Created by Pola on 2/24/22.
//  Copyright © 2022 Pola. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var lblTeamOutLet: UILabel!
    @IBOutlet weak var lblYearOutlet: UILabel!
    @IBOutlet weak var lblStadiumOutlet: UILabel!
    @IBOutlet weak var imgBadgeOutlet: UIImageView!
    @IBOutlet weak var imgJerseyOutlet: UIImageView!
    @IBOutlet weak var imgStadiumOutlet: UIImageView!
    @IBOutlet weak var webSiteOutlet: UIButton!
    
    var strTeam = ""
    var strTeamBadge = ""
    var strFacebook = ""
    var strStadium = ""
    var strStadiumThumb = ""
    var strTeamJersey = ""
    var intFormedYear = ""
    var strYouTube = ""
    var strWebSite = ""
    var strInstagram = ""
    var strTwitter = ""
    var team : Teams
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
print(team)
        
//        lblTeamOutLet.text = strTeam
//        lblYearOutlet.text = intFormedYear
//        lblStadiumOutlet.text = strStadium
//        imgBadgeOutlet.sd_setImage(with: URL(string:strTeamBadge), placeholderImage: UIImage(named: "placeHolder"))
//        imgJerseyOutlet.sd_setImage(with: URL(string:strTeamJersey), placeholderImage: UIImage(named: "placeHolder"))
//        imgStadiumOutlet.sd_setImage(with: URL(string:strStadiumThumb), placeholderImage: UIImage(named: "placeHolder"))
    }
    
    init?(coder: NSCoder, team : Teams) {
        self.team = team
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func youTube(_ sender: Any) {
        if strYouTube.isEmpty {
            WarningAlert()
        }else{
            openURL(strYouTube)
        }
    }
    
    @IBAction func faceBook(_ sender: Any) {
        if strFacebook.isEmpty {
            WarningAlert()
        }else{
            openURL(strFacebook)
        }
    }
    
    @IBAction func webSite(_ sender: Any) {
        if strWebSite.isEmpty {
            WarningAlert()
        }else{
            openURL(strWebSite)
        }
    }
    
    @IBAction func instagram(_ sender: Any) {
        if strInstagram.isEmpty {
            WarningAlert()
        }else{
            openURL(strInstagram)
        }
    }
    
    @IBAction func twitter(_ sender: Any) {
        if strTwitter.isEmpty {
            WarningAlert()
        }else{
            openURL(strTwitter)
        }
    }
    
    func openURL(_ urlString: String) {
        let https = "https://"
        guard let url = URL(string: https+urlString) else {
            return
        }
        UIApplication.shared.open(url, completionHandler: { success in
            if success {
                print("opened")
            } else {
                print("failed")
            }
        })
    }
    
    func WarningAlert() {
        let alert = UIAlertController(title: "SORRY!!", message: "The requested URL was not found on this server", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
