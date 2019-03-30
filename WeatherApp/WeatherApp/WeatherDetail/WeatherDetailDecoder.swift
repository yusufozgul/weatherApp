//
//  WeatherDetailDecoder.swift
//  WeatherApp
//
//  Created by Yusuf Özgül on 30.03.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

/*
 Json verileri parse edilerek WeatherDetailModel tipinde geri döndürüldü.
 bugüne ait veri için detay metni ayrı olarak parse edildi.
 Diğer günler için loop içinde switch ile doğru güne veriler aktarıldı.
 */
import Foundation

public class DetailsDecoder
{    
    //    JSON decode işlemleri
    public func decoder(response: Data) -> WeatherDetailModel
    {
        //        Weather struct'ı tipinde array oluşturup 5 günün verisi eklenir.
        let todayWeatherInfo : TodayDetail = TodayDetail(detailText: "", date: "", max: "", min: "", icon: "")
        let day1WeatherInfo: Day1Detail = Day1Detail(date: "", max: "", min: "", icon: "")
        let day2WeatherInfo: Day2Detail = Day2Detail(date: "", max: "", min: "", icon: "")
        let day3WeatherInfo: Day3Detail = Day3Detail(date: "", max: "", min: "", icon: "")
        let day4WeatherInfo: Day4Detail = Day4Detail(date: "", max: "", min: "", icon: "")
        
        var weatherInfo = WeatherDetailModel.init(today: todayWeatherInfo, dayLater1: day1WeatherInfo, dayLater2: day2WeatherInfo, dayLater3: day3WeatherInfo, dayLater4: day4WeatherInfo)
        do
        {
//            JSON serialization işlemi
            let results =  try JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject

//           Günün bilgi metni alınır
            if let detailText = results["Headline"]  as? [String: Any]
            {
                weatherInfo.today.detailText = String(describing: detailText["Text"]!)
            }
            
//            JSON verisindeki DailyForecasts arrayi gezilerek gün gün veriler oluşturulur.
            if let dayByDay = results["DailyForecasts"] as? [[String: Any]]
            {
                var loopNumber = 0
                for day in dayByDay
                {
                    switch loopNumber
                    {
                    case 0:
                        let epochDate = String(describing: day["EpochDate"]!)
                        weatherInfo.today.date = dateDecoder(epochDate: epochDate)
                        
                        if let dayTemperature = day["Temperature"] as? [String: Any]
                        {
                            if let maxTemp = dayTemperature["Maximum"] as? [String: Any]
                            {
                                weatherInfo.today.max = String(String(describing: maxTemp["Value"]!).prefix(4))
                            }
                            if let minTemp = dayTemperature["Minimum"] as? [String: Any]
                            {
                                weatherInfo.today.min = String(String(describing: minTemp["Value"]!).prefix(4))
                            }
                        }
                        if let icon = day["Day"] as? [String: Any]
                        {
                            weatherInfo.today.icon = String(describing: icon["Icon"]!)
                        }
                    case 1:
                        let epochDate = String(describing: day["EpochDate"]!)
                        weatherInfo.dayLater1.date = dateDecoder(epochDate: epochDate)
                        
                        if let dayTemperature = day["Temperature"] as? [String: Any]
                        {
                            if let maxTemp = dayTemperature["Maximum"] as? [String: Any]
                            {
                                weatherInfo.dayLater1.max = String(String(describing: maxTemp["Value"]!).prefix(4))
                            }
                            if let minTemp = dayTemperature["Minimum"] as? [String: Any]
                            {
                                weatherInfo.dayLater1.min = String(String(describing: minTemp["Value"]!).prefix(4))
                            }
                        }
                        if let icon = day["Day"] as? [String: Any]
                        {
                            weatherInfo.dayLater1.icon = String(describing: icon["Icon"]!)
                        }
                        
                    case 2:
                        let epochDate = String(describing: day["EpochDate"]!)
                        weatherInfo.dayLater2.date = dateDecoder(epochDate: epochDate)
                        
                        if let dayTemperature = day["Temperature"] as? [String: Any]
                        {
                            if let maxTemp = dayTemperature["Maximum"] as? [String: Any]
                            {
                                weatherInfo.dayLater2.max = String(String(describing: maxTemp["Value"]!).prefix(4))
                            }
                            if let minTemp = dayTemperature["Minimum"] as? [String: Any]
                            {
                                weatherInfo.dayLater2.min = String(String(describing: minTemp["Value"]!).prefix(4))
                            }
                        }
                        if let icon = day["Day"] as? [String: Any]
                        {
                            weatherInfo.dayLater2.icon = String(describing: icon["Icon"]!)
                        }
                    case 3:
                        let epochDate = String(describing: day["EpochDate"]!)
                        weatherInfo.dayLater3.date = dateDecoder(epochDate: epochDate)
                        
                        if let dayTemperature = day["Temperature"] as? [String: Any]
                        {
                            if let maxTemp = dayTemperature["Maximum"] as? [String: Any]
                            {
                                weatherInfo.dayLater3.max = String(String(describing: maxTemp["Value"]!).prefix(4))
                            }
                            if let minTemp = dayTemperature["Minimum"] as? [String: Any]
                            {
                                weatherInfo.dayLater3.min = String(String(describing: minTemp["Value"]!).prefix(4))
                            }
                        }
                        if let icon = day["Day"] as? [String: Any]
                        {
                            weatherInfo.dayLater3.icon = String(describing: icon["Icon"]!)
                        }
                    case 4:
                        let epochDate = String(describing: day["EpochDate"]!)
                        weatherInfo.dayLater4.date = dateDecoder(epochDate: epochDate)
                        
                        if let dayTemperature = day["Temperature"] as? [String: Any]
                        {
                            if let maxTemp = dayTemperature["Maximum"] as? [String: Any]
                            {
                                weatherInfo.dayLater4.max = String(String(describing: maxTemp["Value"]!).prefix(4))
                            }
                            if let minTemp = dayTemperature["Minimum"] as? [String: Any]
                            {
                                weatherInfo.dayLater4.min = String(String(describing: minTemp["Value"]!).prefix(4))
                            }
                        }
                        if let icon = day["Day"] as? [String: Any]
                        {
                            weatherInfo.dayLater4.icon = String(describing: icon["Icon"]!)
                        }
                    default: break
                    }
                    loopNumber += 1
                }
            }
        } catch {
            print("Hata")
        }
        return weatherInfo
    }
    
    //    Epoch Date decoder, Epoch tipindeki tarih bilgisi GG-AA-YYYY tipine dönüştürülür.
    public func dateDecoder(epochDate: String) -> String {
        let date = Date(timeIntervalSince1970: (Double(epochDate))!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "EEEE"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
