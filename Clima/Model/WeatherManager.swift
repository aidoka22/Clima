//
//  WeatherManager.swift
//  Clima
//
//  Created by Айдана Шарипбай on 23.08.2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate  {
    func didUpdateWeather(weather: WeatherModel)
}


struct WeatherManager{
    let weatherURL =
    "https://api.openweathermap.org/data/2.5/weather?appid=1760effb33076fb96153a5a01cf7cc1c&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequest(urlString: urlString)
    }
    
    func performRequest(urlString:String){
        //1.Create a URL
        if let url = URL(string: urlString){
            //2.Create a URLSession
            let session  = URLSession(configuration: .default)
            //Give a session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData : safeData){
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            //Start the task
            task.resume()
        }
        
    }
    
    func parseJSON (weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
            
        }catch{
            print(error)
            return nil
        }
    }
    
}
