//
//  favoriteViewController.swift
//  SportApp
//
//  Created by Pola on 2/28/22.
//  Copyright © 2022 Pola. All rights reserved.
//

import UIKit
import CoreData
import Reachability

class FavoriteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet weak var favoriteTableView: UITableView!
    let coredata = CoreDataManager.shared
    var savingLeagueName : [NSManagedObject] = []
    let networkManager : NetworkManager = NetworkManager.shared
    let activityIndecator = UIActivityIndicatorView(style:.large)
    let reachability = try! Reachability()
    var Connected : Bool?
    
    @IBOutlet weak var emptyFavoriteImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savingLeagueName = coredata.fetchData()
        if savingLeagueName.count==0 {
            emptyFavoriteImageView.isHidden=false
        } else {
            emptyFavoriteImageView.isHidden=true
        }
        self.favoriteTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savingLeagueName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let countryLabel = cell.viewWithTag(3) as! UILabel
        let sportLabel = cell.viewWithTag(4) as! UILabel
        let badgeImg = cell.viewWithTag(2) as! UIImageView
        let badgeUrlStr = savingLeagueName[indexPath.row].value(forKey: "strBadge") as? String ?? ""
        
        nameLabel.text = savingLeagueName[indexPath.row].value(forKey: "leagueName") as? String
        countryLabel.text = savingLeagueName[indexPath.row].value(forKey: "strCountry") as? String
        sportLabel.text = savingLeagueName[indexPath.row].value(forKey: "strSport") as? String
        badgeImg.sd_setImage(with: URL(string: badgeUrlStr), placeholderImage: UIImage(named: "placeHolder"))
        
        cell.contentView.layer.borderWidth = 6
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {return 185}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leagueDetailsVC  = self.storyboard?.instantiateViewController(identifier: "LeagueDetailsViewController") as! LeagueDetailsViewController
        let leagueName = savingLeagueName[indexPath.row].value(forKey: "leagueName") as! String
        let leagueId = savingLeagueName[indexPath.row].value(forKey: "leagueId") as! String
        leagueDetailsVC.strLeagueName = leagueName
        leagueDetailsVC.strLeagueId = leagueId
        
        //"Egyptian Premier League"
        if (leagueId.elementsEqual("4829")){
            leagueDetailsVC.upcomingRound = "13"
            leagueDetailsVC.latestRound = "11"
        }else {//"English Premier League"
            leagueDetailsVC.upcomingRound = "29"
            leagueDetailsVC.latestRound = "27"
        }
        checkNetwork()
        if Connected == true{
        self.navigationController?.pushViewController(leagueDetailsVC, animated: true)
        }else{
            displayError()
        }
    }
    
    
    func checkNetwork() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.Connected = true
                print("Reachable via WiFi")
                
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            self.Connected = false
        }
        do {
            try reachability.startNotifier()
            
        }catch {
            print("Unable to start notifier")
        }
    }
    
    func displayError() {
       let alert = UIAlertController(title: "Connection Lost",message:"Network Connection Errors",preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Dismiss",style: .default, handler: nil))
       self.present(alert, animated: true, completion: nil)
    }
    
}
