
import Foundation

struct WeatherResponse: Codable
{
	let headline: Headline
	let dailyForecasts: [DailyForecast]

	enum CodingKeys: String, CodingKey
    {
		case headline = "Headline"
		case dailyForecasts = "DailyForecasts"
	}
}

struct DailyForecast: Codable
{
	let epochDate: Date
	let temperature: Temperature
	let day, night: Day
	let sources: [String]
    let mobileLink: String
    let link: String

	enum CodingKeys: String, CodingKey
    {
		case epochDate = "EpochDate"
		case temperature = "Temperature"
		case day = "Day"
		case night = "Night"
		case sources = "Sources"
		case mobileLink = "MobileLink"
		case link = "Link"
	}
}

struct Day: Codable {
	let icon: Int
	let iconPhrase: String

	enum CodingKeys: String, CodingKey
    {
		case icon = "Icon"
		case iconPhrase = "IconPhrase"
	}
}

struct Temperature: Codable {
    let minimum: TemperatureValue
    let maximum: TemperatureValue

	enum CodingKeys: String, CodingKey
    {
		case minimum = "Minimum"
		case maximum = "Maximum"
	}
}

struct TemperatureValue: Codable
{
	let value: Double
	let unit: Unit
	let unitType: Int

	enum CodingKeys: String, CodingKey
    {
		case value = "Value"
		case unit = "Unit"
		case unitType = "UnitType"
	}
}

enum Unit: String, Codable
{
	case c = "C"
}

struct Headline: Codable
{
	let effectiveEpochDate: Date
	let severity: Int
	let text, category: String
	let endEpochDate: Date
    let mobileLink: String
    let link: String

	enum CodingKeys: String, CodingKey
    {
		case effectiveEpochDate = "EffectiveEpochDate"
		case severity = "Severity"
		case text = "Text"
		case category = "Category"
		case endEpochDate = "EndEpochDate"
		case mobileLink = "MobileLink"
		case link = "Link"
	}
}
