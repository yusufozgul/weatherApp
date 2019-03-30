//
//  DayWeatherDecoder.swift
//  WeatherApp
//
//  Created by Yusuf Özgül on 30.03.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

/*
Json verileri parse edilerek DayWeatherModel tipinde geri döndürüldü.
*/
import Foundation
public class DayWeatherDecoder
{
    public var dayWeatherInfo = DayWeatherModel(max: "", min: "", icon: "")
    //    JSON decode işlemleri
    public func decoder(response: Data) -> DayWeatherModel
    {
        do
        {
//            JSON serialization işlemi
            let results =  try JSONSerialization.jsonObject(with: response, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
//            JSON verisindeki DailyForecasts dizisinden bugünün verisi elde edilir.
            if let dayResults = results["DailyForecasts"] as? [[String: Any]]
            {
                let day = dayResults.first
                if let dayTemperature = day!["Temperature"] as? [String: Any]
                {
                    if let maxTemp = dayTemperature["Maximum"] as? [String: Any]
                    {
                        dayWeatherInfo.max = String(String(describing: maxTemp["Value"]!).prefix(4))
                    }
                    if let minTemp = dayTemperature["Minimum"] as? [String: Any]
                    {
                        dayWeatherInfo.min = String(String(describing: minTemp["Value"]!).prefix(4))
                    }
                }
                if let icon = day!["Day"] as? [String: Any]
                {
                    dayWeatherInfo.icon = String(describing: icon["Icon"]!)
                }
            }
        } catch {
            print("Hata")
        }
        return dayWeatherInfo
    }

}
