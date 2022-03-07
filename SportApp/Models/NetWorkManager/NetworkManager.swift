//
//  NetworkManager.swift
//  SportApp
//
//  Created by Pola on 2/21/22.
//  Copyright © 2022 Pola. All rights reserved.
//

import Foundation

class NetworkManager  {

    static let shared = NetworkManager()
    private init() {
    }
    
    func urlSessionAllSports(compeletion: @escaping (_ SportsArr:[Sports])-> Void) {
        guard let url = URL(string: "https://www.thesportsdb.com/api/v1/json/2/all_sports.php") else{ return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else{return}
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(SportsRoot.self, from: data)
                
                guard let sportsArr = result.sports else{return}
                compeletion(sportsArr)
                
            }catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func sendRequest(_ url: String?, completion: @escaping ([Countrys]?, Error?) -> Void) {
        guard let url = URL(string: url!) else{ return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {return}
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(CountrysRoot.self, from: data)
                guard let countryArr = result.countrys else{return}
                completion(countryArr,nil)
            }
            catch{
                completion(nil, error)
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    

    func urlSessionCountriesName(compeletion: @escaping (_ CountriesArr:[CountriesName])-> Void) {
        guard let url = URL(string: "https://www.thesportsdb.com/api/v1/json/2/all_countries.php") else{ return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else{return}
            do{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                let result = try decoder.decode(CountryNameRoot.self, from: data)
                guard let countryNameArr = result.countries else{return}
                compeletion(countryNameArr)
                
            }catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    func sendRequestTeams(_ url: String?, completion: @escaping ([Teams]?, Error?) -> Void) {
            guard let url = URL(string: url!) else{ return }
            let request = URLRequest(url: url)
            let session = URLSession(configuration: URLSessionConfiguration .default)
            let task = session.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let result = try decoder.decode(TeamsRoot.self, from: data)
                    guard let Array = result.teams else{return}
                    completion(Array,nil)
                }
                catch{
                    completion(nil, error)
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    
    
    func sendRequestEventsResults(_ url: String?, completion: @escaping ([Events]?, Error?) -> Void) {
            guard let url = URL(string: url!) else{ return }
            let request = URLRequest(url: url)
            let session = URLSession(configuration: URLSessionConfiguration .default)
            let task = session.dataTask(with: request) { data, response, error in
                guard let data = data else {return}
                //print(data)
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .useDefaultKeys
                    let result = try decoder.decode(EventsResultsRoot.self, from: data)
                    guard let array = result.events else{return}
//                    print(array.count)
//                    for element in array {
//                        print(element)
//                    }
                    completion(array,nil)
                }
                catch{
                    completion(nil, error)
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
        
}
