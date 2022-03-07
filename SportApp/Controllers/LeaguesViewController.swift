//
//  LeaguesViewController.swift
//  SportApp
//
//  Created by Pola on 2/22/22.
//  Copyright © 2022 Pola. All rights reserved.
//

import UIKit


class LeaguesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var noDataImgViewOutlet: UIImageView!
    @IBOutlet weak var leagueTableViewOutlet: UITableView!
    
    
    let networkManager : NetworkManager = NetworkManager.shared
    var leaguesApiArr : [Countrys] = []
    var strSport = ""
    var strCountry = ""
    let activityIndecator = UIActivityIndicatorView(style:.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("sport:\(strSport), country:\(strCountry)")
        
        if strSport.contains(" ") {
            let sportName = strSport.replacingOccurrences(of:" ", with:"%20", options: .literal, range: nil)
            self.strSport=sportName
        }
        if strCountry.contains(" ") {
            let newCountry = strCountry.replacingOccurrences(of:" ", with:"%20", options: .literal, range: nil)
            self.strCountry=newCountry
        }
        
        
        self.activityIndicatorLoading()
        networkManager.sendRequest("https://www.thesportsdb.com/api/v1/json/2/search_all_leagues.php?c=\(strCountry)&s=\(strSport)") { (array, error) in
            self.leaguesApiArr = array!
            DispatchQueue.main.async {
                if self.leaguesApiArr.count > 0{
                    self.activityIndecator.stopAnimating()
                    self.leagueTableViewOutlet.reloadData()
                }else{
                    self.activityIndecator.stopAnimating()
                    self.noDataImgViewOutlet.isHidden=false
                    self.leagueTableViewOutlet.isHidden=true
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaguesApiArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath)
        
        if let strBadge : UIImageView = cell.viewWithTag(1) as? UIImageView {
            strBadge.sd_setImage(with: URL(string: leaguesApiArr[indexPath.row].strBadge!), placeholderImage: UIImage(named: "placeHolder"))
        }
        
        if let strLeague : UILabel = cell.viewWithTag(2) as? UILabel {
            strLeague.text=leaguesApiArr[indexPath.row].strLeague!
        }
        
        if let selectBtn : UIButton = cell.viewWithTag(3) as? UIButton{
            selectBtn.tag = indexPath.row
            selectBtn.addTarget(self, action: #selector(playYouTube(sender:)), for: .touchUpInside)
        }
        if let selectBtn : UIButton = cell.viewWithTag(4) as? UIButton{
            selectBtn.tag = indexPath.row
            selectBtn.addTarget(self, action: #selector(FaceBook(sender:)), for: .touchUpInside)
        }
        cell.contentView.layer.borderWidth = 7.5
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 7
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    @objc func playYouTube(sender : UIButton)  {
        if leaguesApiArr[sender.tag].strYoutube!.isEmpty {
            WarningAlert()
        }else{
            openURL(leaguesApiArr[sender.tag].strYoutube!)
        }
    }
    @objc func FaceBook(sender : UIButton)  {
        if leaguesApiArr[sender.tag].strFacebook!.isEmpty {
            WarningAlert()
        }else{
            openURL(leaguesApiArr[sender.tag].strFacebook!)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leagueDetailsVC  = self.storyboard?.instantiateViewController(identifier: "LeagueDetailsViewController") as! LeagueDetailsViewController
        leagueDetailsVC.getLeagueDetails = leaguesApiArr[indexPath.row]
        leagueDetailsVC.strLeagueName = leaguesApiArr[indexPath.row].strLeague!
        leagueDetailsVC.strLeagueId = leaguesApiArr[indexPath.row].idLeague!
        
        //"Egyptian Premier League"
        if (leaguesApiArr[indexPath.row].idLeague?.elementsEqual("4829"))!{
            leagueDetailsVC.upcomingRound = "13"
            leagueDetailsVC.latestRound = "11"
        }else {//"English Premier League"
            leagueDetailsVC.upcomingRound = "29"
            leagueDetailsVC.latestRound = "27"
        }
        self.navigationController?.pushViewController(leagueDetailsVC, animated: true)
    }
    
    func activityIndicatorLoading() { // loading...
        activityIndecator.center = view.center
        view.addSubview(activityIndecator)
        activityIndecator.startAnimating()
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
