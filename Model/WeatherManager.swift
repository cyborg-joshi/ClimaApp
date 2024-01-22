//
//  WeatherManager.swift
//  Clima
//
//  Created by KANISHK on 21/01/24.


import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel)
    func didFailWithError(error : Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=b8911d344473eeec24f4934e9ec41046&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees , longitute : CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            // Give the session a task
            let task = session.dataTask(with: url)  { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                    
                }
                if let safeData = data {
                       if let weather =  self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather( self , weather : weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data)  -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        }

            
        }


