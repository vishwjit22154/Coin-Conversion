//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Vishwajit Reddy on 27/08/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation
struct CoinModel{
    let rate: Int
    var rateString: String{
        return String(format: "%.1f", rate)
    }
}
