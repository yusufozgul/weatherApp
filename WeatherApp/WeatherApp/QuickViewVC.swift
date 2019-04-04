//
//  ViewController.swift
//  WeatherApp
//
//  Created by Yusuf Özgül on 28.03.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import UIKit

class QuickViewVC: UIViewController
{
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var infoLAbel: UILabel!
    
    var citysCode: [String:String] = [:] // kullanılabilir şehirler dizisi
    var savedCity: [String:String] = [:] // kayıtlı şehirler dizisi
    var selectCity: [String:String] = [:] // Detayları görünecek şehir dictionarysi
    
    var citysName: [String] = []
    var maxTemperature: [String] = []
    var minTemperature: [String] = []
    var dayIcon: [Int] = []
    
    let apiKey = "FA26YLIvWfOaCBniO8YtkGpknT53hk8M" // Accuweather API Key
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        Update view
        navigationItem.title = "Hava Durumu"
        
//        load save city info
        savedCity = UserDefaults.standard.value(forKey: "savedCity") as? [String : String] ?? [:]
        
//        Eklenen şehir yoksa bilgi verilir.
        if savedCity.isEmpty
        {
            infoLAbel.isHidden = false
            infoLAbel.text = "Lütfen Şehir ekleyiniz."
        }
        else
        {
//        NetworkActivity show
            loading.startAnimating()
        }
//        fetch weather and city info
        self.fetchCitys()
        self.fetchWeatherInfo()
    }
    func fetchCitys()
    {
        if let urlStirng = URL(string: "https://raw.githubusercontent.com/yusufozgul/weatherApp/master/il.json")
        {
            loading.startAnimating()
            let task = URLSession.shared.dataTask(with: urlStirng) { (data, response, error) in
                if error != nil
                {
                    print(error!.localizedDescription)
                }
                else
                {
                    do
                    {
                        let cityDecoder = JSONDecoder()
                        let cities = try cityDecoder.decode([String:String].self, from: data!)
                        
                        for city in cities
                        {
                            self.citysCode.updateValue(city.value, forKey: city.key)
                        }
                    } catch
                    {
                        print("Parse Error \(error)")
                    }
                }
            }
            task.resume()
        }
        else
        {
            print("URL HATA")
        }
    }
    func fetchWeatherInfo()
    {
        citysName.removeAll()
        maxTemperature.removeAll()
        minTemperature.removeAll()
        dayIcon.removeAll()
        
        for city in savedCity
        {
//            Fetch and parse weather info
            if let urlStirng = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(city.value)?apikey=\(apiKey)&language=tr-tr&metric=true")
            {
                let task = URLSession.shared.dataTask(with: urlStirng) { (data, response, error) in
                    if error != nil
                    {
                        print(error!.localizedDescription)
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            do
                            {
                                let weatherDecoder = JSONDecoder()
                                weatherDecoder.dateDecodingStrategy = .secondsSince1970
                                let weather = try weatherDecoder.decode(WeatherResponse.self, from: data!)
                                
                                self.citysName.append(city.key.capitalizingFirstLetter)
                                self.maxTemperature.append((weather.dailyForecasts.first?.temperature.maximum.value.degreeFormat)!)
                                self.minTemperature.append((weather.dailyForecasts.first?.temperature.minimum.value.degreeFormat)!)
                                self.dayIcon.append((weather.dailyForecasts.first?.day.icon)!)
                                
                                self.weatherCollectionView.reloadData()
                            }
                            catch
                            {
                                print("Parse Hatası \(error)")
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }

    @IBAction func addNewCity(_ sender: Any)
    {
        let addCity = UIAlertController(title: "Yeni Şehir Ekleme", message: "Lütfen şehir adını giriniz", preferredStyle: .alert)
        addCity.addTextField()
        
        let saveCity = UIAlertAction(title: "Ekle", style: .default) { _ in
            let answer = addCity.textFields![0].text?.uppercased()
            
            if self.citysCode[answer!] != nil
            {
                self.infoLAbel.isHidden = true
                self.savedCity.updateValue(self.citysCode[answer!]!, forKey: answer!)
                UserDefaults.standard.set(self.savedCity, forKey: "savedCity")
                UserDefaults.standard.synchronize()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.loading.startAnimating()
                self.fetchWeatherInfo()
            }
            else
            {
                let noFindCity = UIAlertController(title: "UYARI", message: "Eklemek istediğiniz şehir bulunamadı", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
                noFindCity.addAction(cancelAction)
                self.present(noFindCity, animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        addCity.addAction(cancelAction)
        addCity.addAction(saveCity)
        
        present(addCity, animated: true)
    }
}
// cityVC için collectionview fonksiyonları extension'ı
extension QuickViewVC: UICollectionViewDelegate, UICollectionViewDataSource
{
//    Hücre sayısı
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return citysName.count
    }
//    Hücre yapılandırması
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        self.loading.stopAnimating()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityCell", for: indexPath) as? cityCell
        {
            cell.cityName.text = citysName[indexPath.row]
            cell.maxTemperature.text = maxTemperature[indexPath.row]
            cell.minTemperature.text = minTemperature[indexPath.row]
            
            switch dayIcon[indexPath.row]
            {
            case 1...5:
                cell.weatherIcon.image = UIImage(named: "sun")
            case 6...8, 11:
                cell.weatherIcon.image = UIImage(named: "cloud")
            case 12...14, 16, 17:
                cell.weatherIcon.image = UIImage(named: "rain")
            case 15, 18:
                cell.weatherIcon.image = UIImage(named: "thunder")
            case 19, 22...26, 29:
                cell.weatherIcon.image = UIImage(named: "snowflake")
            case 32:
                cell.weatherIcon.image = UIImage(named: "wind")
            default:
                cell.weatherIcon.image = UIImage(named: "notFound")
            }
            return cell
        }
        else
        {
            return cityCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectCity.removeAll()
        selectCity.updateValue(citysCode[citysName[indexPath.row].uppercased()]!, forKey: "code")
        selectCity.updateValue(citysName[indexPath.row], forKey: "city")

        if !(selectCity.values.isEmpty)
        {
            performSegue(withIdentifier: "showWeatherDetails", sender: nil)
        }
    }
}
extension QuickViewVC
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showWeatherDetails" && !(selectCity.values.isEmpty)
        {
            let detailVC = segue.destination as! WeatherDetail
            detailVC.selectCity["code"] = selectCity["code"]!
            detailVC.selectCity["city"] = selectCity["city"]!
            detailVC.apiKey = apiKey
        }
        
    }
}
