//
//  File.swift
//  WeatherApp
//
//  Created by Yusuf Özgül on 30.03.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import Foundation

public struct WeatherDetailModel
{
    var today: TodayDetail
    var dayLater1: Day1Detail
    var dayLater2: Day2Detail
    var dayLater3: Day3Detail
    var dayLater4: Day4Detail
}

public struct TodayDetail
{
    public var detailText: String
    public var date: String = ""
    public var max: String = ""
    public var min: String = ""
    public var icon: String = ""
}
public struct Day1Detail
{
    public var date: String = ""
    public var max: String = ""
    public var min: String = ""
    public var icon: String = ""
}
public struct Day2Detail
{
    public var date: String = ""
    public var max: String = ""
    public var min: String = ""
    public var icon: String = ""
}
public struct Day3Detail
{
    public var date: String = ""
    public var max: String = ""
    public var min: String = ""
    public var icon: String = ""
}
public struct Day4Detail
{
    public var date: String = ""
    public var max: String = ""
    public var min: String = ""
    public var icon: String = ""
}
