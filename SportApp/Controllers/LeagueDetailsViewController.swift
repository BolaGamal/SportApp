//
//  LeagueDetailsViewController.swift
//  SportApp
//
//  Created by Pola on 2/22/22.
//  Copyright © 2022 Pola. All rights reserved.
//

import UIKit
import CoreData

class LeagueDetailsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionUpcomingEventsOutLet: UICollectionView!
    @IBOutlet weak var collectionLatestEventsOutlet: UICollectionView!
    @IBOutlet weak var collectionTeamsOutlet: UICollectionView!
    
    
    var getLeagueDetails : Countrys?
    var getLeagueState: [NSManagedObject] = []
    let coredata = CoreDataManager.shared
    let networkManager : NetworkManager = NetworkManager.shared
    var teamsApiArr : [Teams] = []
    var latestEventsApiArr : [Events] = []
    var upcomingEventsApiArr : [Events] = []
    var strLeagueId = ""
    var strLeagueName = ""
    var newLeagueName = ""
    var latestRound = ""
    var upcomingRound = ""
    let activityIndecator = UIActivityIndicatorView(style:.large)
    var itemFavorite : UIBarButtonItem?
    var isFavorite : Bool = false
    let defaults = UserDefaults.standard
    var favoriteStateUserDefault : Bool = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        title = strLeagueName
        itemFavorite = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(addToFavorite))
        self.navigationItem.rightBarButtonItem  = itemFavorite
        

        favoriteStateUserDefault = defaults.object(forKey: strLeagueId) as? Bool ?? false
        if favoriteStateUserDefault {
            itemFavorite?.image = UIImage(systemName: "star.fill")
            isFavorite = true
        }
        
    }
    
    @objc func addToFavorite(){
        if isFavorite{
            itemFavorite?.image = UIImage(systemName: "star")
            isFavorite = false

            defaults.removeObject(forKey: strLeagueId)
            coredata.deleteData(strLeagueId)
            
            
        }else{ //theFirstTime
            itemFavorite?.image = UIImage(systemName: "star.fill")
            isFavorite = true
            
            defaults.set(true, forKey: strLeagueId)
            coredata.saveData(leauges: getLeagueDetails!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicatorLoading()
        networkManager.sendRequestEventsResults("https://www.thesportsdb.com/api/v1/json/2/eventsround.php?id=\(strLeagueId)&r=\(upcomingRound)") { (array, error) in
            self.upcomingEventsApiArr = array!
            DispatchQueue.main.async {
                self.collectionUpcomingEventsOutLet.reloadData()
                self.activityIndecator.stopAnimating()
            }
        }
        
        self.activityIndicatorLoading()
        networkManager.sendRequestEventsResults("https://www.thesportsdb.com/api/v1/json/2/eventsround.php?id=\(strLeagueId)&r=\(latestRound)") { (array, error) in
            self.latestEventsApiArr = array!
            DispatchQueue.main.async {
                self.collectionLatestEventsOutlet.reloadData()
                self.activityIndecator.stopAnimating()
            }
        }
        
        if strLeagueName.contains(" ") {
            let leagueName = strLeagueName.replacingOccurrences(of:" ", with:"%20", options: .literal, range: nil)
            self.newLeagueName = leagueName
        }
        self.activityIndicatorLoading()
        networkManager.sendRequestTeams("https://www.thesportsdb.com/api/v1/json/2/search_all_teams.php?l=\(newLeagueName)") { (array, error) in
            self.teamsApiArr = array!
            DispatchQueue.main.async {
                self.collectionTeamsOutlet.reloadData()
                self.activityIndecator.stopAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionUpcomingEventsOutLet:
            return upcomingEventsApiArr.count
        case collectionLatestEventsOutlet:
            return latestEventsApiArr.count
        case collectionTeamsOutlet:
            return teamsApiArr.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case collectionUpcomingEventsOutLet:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath)
            let strEvent : UILabel =  cell.viewWithTag(1) as! UILabel
            let dateEvent : UILabel =  cell.viewWithTag(2) as! UILabel
            let strTime : UILabel =  cell.viewWithTag(3) as! UILabel
            if let imgTeam : UIImageView = cell.viewWithTag(4) as? UIImageView {
                imgTeam.sd_setImage(with: URL(string: upcomingEventsApiArr[indexPath.row].strThumb!), placeholderImage: UIImage(named: "placeHolder"))
            }
            strEvent.text = upcomingEventsApiArr[indexPath.row].strEvent
            dateEvent.text = upcomingEventsApiArr[indexPath.row].dateEvent
            strTime.text = upcomingEventsApiArr[indexPath.row].strTime
            return cell
            
        case collectionLatestEventsOutlet:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestCell", for: indexPath)
            let strEvent : UILabel =  cell.viewWithTag(1) as! UILabel
            let homeScore : UILabel =  cell.viewWithTag(3) as! UILabel
            let wayScore : UILabel =  cell.viewWithTag(4) as! UILabel
            let date : UILabel =  cell.viewWithTag(5) as! UILabel
            let time : UILabel =  cell.viewWithTag(6) as! UILabel
            if let imgTeam : UIImageView = cell.viewWithTag(7) as? UIImageView {
                imgTeam.sd_setImage(with: URL(string: latestEventsApiArr[indexPath.row].strThumb!), placeholderImage: UIImage(named: "placeHolder"))
            }
            strEvent.text = latestEventsApiArr[indexPath.row].strEvent
            homeScore.text = latestEventsApiArr[indexPath.row].intHomeScore
            wayScore.text = latestEventsApiArr[indexPath.row].intAwayScore
            date.text = latestEventsApiArr[indexPath.row].dateEvent
            time.text = latestEventsApiArr[indexPath.row].strTime
            
            return cell
            
        case collectionTeamsOutlet:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamsCell", for: indexPath)
            
            if let imgTeam : UIImageView = cell.viewWithTag(10) as? UIImageView {
                imgTeam.sd_setImage(with: URL(string: teamsApiArr[indexPath.row].strTeamBadge!), placeholderImage: UIImage(named: "placeHolder"))
            }
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collectionUpcomingEventsOutLet:
            return CGSize(width: self.view.frame.width , height: self.view.frame.width * 0.55)
        case collectionLatestEventsOutlet:
            return CGSize(width: self.view.frame.width , height: self.view.frame.width * 0.6)
        case collectionTeamsOutlet:
            return CGSize(width: self.view.frame.width * 0.4, height: self.view.frame.width * 0.4)
        default:
            return CGSize()
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == collectionTeamsOutlet {
//            let resultsTeam = self.storyboard?.instantiateViewController(identifier: "ResultsViewController")  as! ResultsViewController
//            resultsTeam.strTeam = teamsApiArr[indexPath.row].strTeam ?? ""
//            resultsTeam.strTeamJersey = teamsApiArr[indexPath.row].strTeamJersey ?? ""
//            resultsTeam.strStadium = teamsApiArr[indexPath.row].strStadium!
//            resultsTeam.strStadiumThumb = teamsApiArr[indexPath.row].strStadiumThumb ?? ""
//            resultsTeam.strTeamBadge = teamsApiArr[indexPath.row].strTeamBadge ?? ""
//            resultsTeam.strFacebook = teamsApiArr[indexPath.row].strFacebook ?? ""
//            resultsTeam.intFormedYear = teamsApiArr[indexPath.row].intFormedYear ?? ""
//            resultsTeam.strYouTube = teamsApiArr[indexPath.row].strYoutube ?? ""
//            resultsTeam.strWebSite = teamsApiArr[indexPath.row].strWebsite ?? ""
//            resultsTeam.strTwitter = teamsApiArr[indexPath.row].strTwitter ?? ""
//            resultsTeam.strInstagram = teamsApiArr[indexPath.row].strInstagram ?? ""
//            self.navigationController?.pushViewController(resultsTeam, animated: true)
//        }
//    }	
    
    func activityIndicatorLoading() { // loading...
        activityIndecator.center = view.center
        view.addSubview(activityIndecator)
        activityIndecator.startAnimating()
    }
    
    
    
  
    @IBSegueAction func openTeam(_ coder: NSCoder, sender: Any?) -> ResultsViewController? {
        guard let cell = sender as? UICollectionViewCell, let indexPath =
            self.collectionTeamsOutlet.indexPath(for: cell) else {
                return nil
        }
        
        let team = teamsApiArr[indexPath.row]
        return ResultsViewController(coder: coder, team: team)
    }
    
}
