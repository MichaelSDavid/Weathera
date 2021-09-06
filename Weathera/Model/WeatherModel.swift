// Import(s)
import Foundation

// Weather data model
struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temp: Double
    
    // Show specific SF symbol based on weather condition
    var conditionName: String {
        switch conditionID {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }
    }
    
    // Round temp to nearest tenth
    var tempString: String {
        return String(format: "%.1f", temp)
    }
}
