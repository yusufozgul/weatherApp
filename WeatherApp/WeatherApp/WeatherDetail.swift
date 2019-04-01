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
	@IBOutlet weak var detailText: UILabel!
	@IBOutlet weak var detailTableView: UITableView!

	var dailyForecast: [DailyForecast] = []
	
	var cityCode: String = ""
	var cityName: String = ""

	override func viewDidLoad()
	{
		super.viewDidLoad()
		//        update view

		navigationItem.title = cityName.capitalizingFirstLetter
		fetchWeatherDetails()
		print(cityCode)

	}

	func fetchWeatherDetails()
	{
		if let urlStirng = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(cityCode)?apikey=FA26YLIvWfOaCBniO8YtkGpknT53hk8M&language=tr-tr&metric=true")
		{
			let task = URLSession.shared.dataTask(with: urlStirng) { (data, response, error) in
				if error != nil {
					print("HATA")
				} else {
					DispatchQueue.main.async {
						do {

							print("Data: \(String(data: data!, encoding: .utf8)!)")
							let decoder = JSONDecoder()
							decoder.dateDecodingStrategy = .secondsSince1970
							let weather = try decoder.decode(WeatherResponce.self, from: data!)


							self.maxDegree.text = weather.dailyForecasts.first!.temperature.maximum.value.degreeFormat
							self.detailText.text = weather.headline.text
							self.dailyForecast = weather.dailyForecasts

							self.detailTableView.reloadData()
						} catch {
							print("Decoding Error: \(error)")
						}
					}
				}
			}
			task.resume()
		}
	}
}

extension Date {
	var weekDayName: String {
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
		dateFormatter.locale = NSLocale.current
		dateFormatter.dateFormat = "EEEE"
		return dateFormatter.string(from: self)
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
			let forcast = self.dailyForecast[indexPath.row]


			cell.dateLabel.text = forcast.epochDate.weekDayName
			cell.maxDegree.text = forcast.temperature.minimum.value.degreeFormat
			cell.minDegree.text = forcast.temperature.maximum.value.degreeFormat

			switch forcast.day.icon
			{
			case 1...5:
				cell.dayIcon.image = UIImage(named: "sun")
			case 6, 7, 8, 11:
				cell.dayIcon.image = UIImage(named: "cloud")
			case 12...17:
				cell.dayIcon.image = UIImage(named: "rain")
			case 15, 18:
				cell.dayIcon.image = UIImage(named: "thunder")
			case 19, 22, 23, 24, 25, 26, 29:
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
}
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
