//
//  ViewController.swift
//  SportApp
//
//  Created by Pola on 2/21/22.
//  Copyright © 2022 Pola. All rights reserved.
//

import UIKit
import SDWebImage
import Reachability
import CoreData


class SportsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var pickerCountryOutlet: UIPickerView!
    @IBOutlet var selectCountryViewOutlet: UIView!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!

    @IBOutlet weak var noConnectionImgOutlet: UIImageView!
    var countryNameApiArr : [CountriesName] = []
    let networkManager : NetworkManager = NetworkManager.shared
    let activityIndecator = UIActivityIndicatorView(style:.large)
    var sportsArr : [Sports] = []
    let reachability = try! Reachability()
    var Connected : Bool?
    var strCountry = "England"
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        // self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        
    }
    override func viewWillAppear(_ animated: Bool) { checkNetwork() }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return sportsArr.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ctmCollectionCell
        
        if let img : UIImageView = cell.imageThumbOutlet  {
            img.sd_setImage(with: URL(string: sportsArr[indexPath.row].strSportThumb!), placeholderImage: UIImage(named: "placeHolder"))
        }
        cell.labelStrSportOutlet.text=sportsArr[indexPath.row].strSport!
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.499, height: self.view.frame.width * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let LeaguesVC = self.storyboard?.instantiateViewController(identifier: "LeaguesViewController") as! LeaguesViewController
        LeaguesVC.strSport = sportsArr[indexPath.row].strSport!
        LeaguesVC.strCountry = strCountry
        
        self.navigationController?.pushViewController(LeaguesVC, animated: true)
    }
    
    func activityIndicatorLoading() { // loading...
        activityIndecator.center = view.center
        view.addSubview(activityIndecator)
        activityIndecator.startAnimating()
    }
    
    
    //Picker Country Screen -----------------------------------------------------

    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryNameApiArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryNameApiArr[row].name_en
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.boldSystemFont(ofSize: 30)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = countryNameApiArr[row].name_en
        return pickerLabel!
    }
//--------------------------------------------------------------------------
    
    @IBAction func showAllSports(_ sender: Any) {
        if Connected == true {
             strCountry =  countryNameApiArr[pickerCountryOutlet.selectedRow(inComponent: 0)].name_en!
            selectCountryViewOutlet.isHidden = true
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }else {
            
            self.displayError(Title: "Failed to Fetch Data", Message: "Network Connection Errors", Button: "Dismiss")
        }
        
    }
    
    @IBAction func changeCountryItemBar(_ sender: Any) {
        selectCountryViewOutlet.isHidden = false
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    
    func getDataFromApi() {
        self.activityIndicatorLoading()
        networkManager.urlSessionCountriesName { array in
            self.countryNameApiArr = array
            DispatchQueue.main.async {
                self.activityIndecator.stopAnimating()
                self.pickerCountryOutlet.reloadAllComponents()
                self.pickerCountryOutlet.selectRow(66, inComponent:0, animated:false)
            }
        }
        
        self.activityIndicatorLoading()
        networkManager.urlSessionAllSports { array in
            self.sportsArr = array
            DispatchQueue.main.async {
                self.activityIndecator.stopAnimating()
                self.collectionViewOutlet.reloadData()
            }
        }
    }
    
    func checkNetwork() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.getDataFromApi()
                self.Connected = true
                self.noConnectionImgOutlet.isHidden = true
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            self.Connected = false
            self.noConnectionImgOutlet.isHidden = false
            self.displayError(Title: "Failed to Fetch Data", Message: "Network Connection Errors", Button: "Dismiss")
        }
        do {
            try reachability.startNotifier()
            
        }catch {
            print("Unable to start notifier")
        }
    }
    
    func displayError(Title:String, Message:String, Button:String) {
       let alert = UIAlertController(title:Title, message:Message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title:Button, style: .default, handler: nil))
       self.present(alert, animated: true, completion: nil)
    }
    
    
}


