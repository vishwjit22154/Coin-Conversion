//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateWeather(_ coinManager: CoinManager, coin : CoinModel)
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "363FA1FA-050D-404F-8D53-0DA18C07C8E1"
        
    var delegate: CoinManagerDelegate?

    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, coin: weather)
                    } //parses the data from JSON to data
                }
            }
        //4.run task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
           let decodedData = try decoder.decode(CoinData.self, from: weatherData)
            let ratee = decodedData.rate
            
            
            let weather = CoinModel(rate: ratee)
            
            
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
