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
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var maxDegree: UILabel!
	@IBOutlet weak var detailText: UILabel!
	@IBOutlet weak var detailTableView: UITableView!

	var dailyForecast: [DailyForecast] = []
    var today: Headline?
    var selectCity: [String:String] = [:] // Detayları görünecek şehir dictionarysi
    var apiKey = "" // Accuweather API key, QuickView'dan gönderiliyor.

	override func viewDidLoad()
	{
		super.viewDidLoad()
//        update view
        navigationItem.title = selectCity["city"]?.capitalizingFirstLetter
		fetchWeatherDetails()
	}

	func fetchWeatherDetails()
	{
        if let urlStirng = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(selectCity["code"]!)?apikey=\(apiKey)&language=tr-tr&metric=true")
        {
			let task = URLSession.shared.dataTask(with: urlStirng) { (data, response, error) in
				if error != nil {
					print(error!.localizedDescription)
				}
                else
                {
					DispatchQueue.main.async
                        {
						do {
							let decoder = JSONDecoder()
							decoder.dateDecodingStrategy = .secondsSince1970
							let weather = try decoder.decode(WeatherResponse.self, from: data!)

							self.maxDegree.text = weather.dailyForecasts.first!.temperature.maximum.value.degreeFormat
							self.detailText.text = weather.headline.text
                            self.today = weather.headline
							self.dailyForecast = weather.dailyForecasts

							self.detailTableView.reloadData()
						} catch {
							print("Parse Error \(error)")
						}
					}
				}
			}
			task.resume()
		}
	}
}

extension WeatherDetail: UITableViewDelegate, UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dailyForecast.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? DetailTableView
		{
			let weather = self.dailyForecast[indexPath.row]

            dayLabel.text = dailyForecast.first?.epochDate.weekDayName
			cell.dateLabel.text = weather.epochDate.weekDayName
			cell.maxDegree.text = weather.temperature.maximum.value.degreeFormat
			cell.minDegree.text = weather.temperature.minimum.value.degreeFormat
//            cell.selectionStyle

            switch weather.day.icon
            {
            case 1...5:
                cell.dayIcon.image = UIImage(named: "sun")
            case 6...8, 11:
                cell.dayIcon.image = UIImage(named: "cloud")
            case 12...14, 16, 17:
                cell.dayIcon.image = UIImage(named: "rain")
            case 15, 18:
                cell.dayIcon.image = UIImage(named: "thunder")
            case 19, 22...26, 29:
                cell.dayIcon.image = UIImage(named: "snowflake")
            case 32:
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let weather = self.dailyForecast[indexPath.row]
        
        dayLabel.text = weather.epochDate.weekDayName
        maxDegree.text = weather.temperature.maximum.value.degreeFormat
        
        if indexPath.row == 0 // Seçilen gün bugün ise detaylı text yazısı bilgisi getir.
        { detailText.text = today?.text }
        else // Seçilen gün bugün değilse genel durum bilgisini yazdır.
        { detailText.text = "\(weather.epochDate.weekDayName) \(weather.day.iconPhrase)" }
    }
}
