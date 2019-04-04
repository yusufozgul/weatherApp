//
//  Extension.swift
//  WeatherApp
//
//  Created by Yusuf Özgül on 3.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

//Tarihi güne çevirme işlemi
extension Date {
    var weekDayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = Locale(identifier: "tr_tr")//.autoupdatingCurrent çalışmıyor 🤔 otomatik lokal format algılamada sorun olduğu için elle verdim.
        dateFormatter.dateFormat = "EEEE" // Gün çevirimi
        return dateFormatter.string(from: self)
    }
}

//Derece işareti ekleme işlemi
extension Double {
    var degreeFormat: String {
        return "\(self)°"
    }
}

// İl ismini ilk harifi büyük olacak şekilde güncelleme extension
extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter
    }
}
