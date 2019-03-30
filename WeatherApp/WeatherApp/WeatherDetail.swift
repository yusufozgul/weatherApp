//
//  WeatherDetail.swift
//  WeatherApp
//
//  Created by Yusuf Özgül on 28.03.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

class WeatherDetail: UIViewController
{
    @IBOutlet weak var maxDegree: UILabel!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var detailTableView: UITableView!
    
    var dateArray: [String] = []
    var maxDegreeArray: [String] = []
    var minDegreeArray: [String] = []
    var iconArray: [String] = []
    
    var cityCode: String = ""
    var cityName: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        update view
        navigationItem.title = cityName.capitalizingFirstLetter()
        fetchWeatherDetails()
        print(cityCode)
    }

    func fetchWeatherDetails()
    {        
        if let urlStirng = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(cityCode)?apikey=FA26YLIvWfOaCBniO8YtkGpknT53hk8M&language=tr-tr&metric=true")
        {
             let task = URLSession.shared.dataTask(with: urlStirng) { (data, response, error) in
                if error != nil
                {
                    print("HATA")
                }
                else
                {
                    let weather = DetailsDecoder.init().decoder(response: data!)
                    self.maxDegree.text = weather.today.max
                    self.detailText.text = weather.today.detailText
                    
                    self.dateArray.append(weather.dayLater1.date)
                    self.dateArray.append(weather.dayLater2.date)
                    self.dateArray.append(weather.dayLater3.date)
                    self.dateArray.append(weather.dayLater4.date)
                    
                    self.maxDegreeArray.append(weather.dayLater1.max)
                    self.maxDegreeArray.append(weather.dayLater2.max)
                    self.maxDegreeArray.append(weather.dayLater3.max)
                    self.maxDegreeArray.append(weather.dayLater4.max)

                    self.minDegreeArray.append(weather.dayLater1.min)
                    self.minDegreeArray.append(weather.dayLater2.min)
                    self.minDegreeArray.append(weather.dayLater3.min)
                    self.minDegreeArray.append(weather.dayLater4.min)
                    
                    self.iconArray.append(weather.dayLater1.icon)
                    self.iconArray.append(weather.dayLater2.icon)
                    self.iconArray.append(weather.dayLater3.icon)
                    self.iconArray.append(weather.dayLater4.icon)
                    
                    self.detailTableView.reloadData()
                }
            }
            task.resume()
        }
    }
}

extension WeatherDetail: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? DetailTableView
        {
            cell.dateLabel.text = dateArray[indexPath.row]
            cell.maxDegree.text = maxDegreeArray[indexPath.row]
            cell.minDegree.text = minDegreeArray[indexPath.row]
            switch iconArray[indexPath.row]
            {
            case ("1"), ("2"), ("3"), ("4"), ("5"):
                cell.dayIcon.image = UIImage(named: "sun")
            case ("6"), ("7"), ("8"), ("11"):
                cell.dayIcon.image = UIImage(named: "cloud")
            case ("12"), ("13"), ("14"), ("16"), ("17"):
                cell.dayIcon.image = UIImage(named: "rain")
            case ("15"), ("18"):
                cell.dayIcon.image = UIImage(named: "thunder")
            case ("19"), ("22"), ("23"), ("24"), ("25"), ("26"), ("29"):
                cell.dayIcon.image = UIImage(named: "snowflake")
            case ("32"):
                cell.dayIcon.image = UIImage(named: "wind")
            default:
                cell.dayIcon.image = UIImage(named: "notFound")
            }
            return cell
        }
        else
        {
            return DetailTableView()
        }
    }
}
// İl ismini ilk harifi büyük olacak şekilde güncelleme extension
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
