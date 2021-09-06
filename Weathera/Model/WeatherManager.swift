// Import(s)
import Foundation
import CoreLocation

// Init delegate
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

// Weather manager to communicate with the API
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&APPID=\(ProcessInfo.processInfo.environment["OWM_KEY"])&units=metric";
    
    var delegate: WeatherManagerDelegate?
    
    // Fetch either by city name...
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    // Or by latitude/longitude...
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    // Request with URLSession
    func performRequest(with urlString: String) {
        // Create URL
        if let url = URL(string: urlString) {
            // Create URLSession
            let session = URLSession(configuration: .default)
            
            // Give session a task (**optionally add brackets for arguments in closure)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // Start/resume task
            task.resume()
        }
         
    }
    
    // Parse JSON data received from API
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temp: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
