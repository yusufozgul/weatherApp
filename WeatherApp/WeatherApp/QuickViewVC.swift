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
    
    var citysCode: [String:String] = [:]
    var savedCity: [String:String] = [:]
    var selectCode: String = ""
    var selectCityName: String = ""
    
    var citysName: [String] = []
    var maxTemperature: [String] = []
    var minTemperature: [String] = []
    var dayIcon: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        Update view
        navigationItem.title = "Hava Durumu"
        
//        load save city info
        savedCity = UserDefaults.standard.value(forKey: "savedCity") as? [String : String] ?? [:]
        
//        Eklenen şehir yoksa bilgi verilir.
        if savedCity == [:]
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
            let task = URLSession.shared.dataTask(with: urlStirng) { (data, response, error) in
                if error != nil
                {
                    print("TASK HATA")
                }
                else
                {
                    let cityResults = try! JSONSerialization.jsonObject(with: data!, options: [])
                    guard let cityArray = cityResults as? [[String: String]] else {
                        print("PARSE ERROR")
                        return
                    }
                    
                    for city in cityArray[0]
                    {
                        self.citysCode.updateValue(city.value, forKey: city.key)
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
            if let urlStirng = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(city.value)?apikey=FA26YLIvWfOaCBniO8YtkGpknT53hk8M&language=tr-tr&metric=true")
            {
                let task = URLSession.shared.dataTask(with: urlStirng) { (data, response, error) in
                    if error != nil
                    {
                        print("HATA")
                    }
                    else
                    {
                        let weather = DayWeatherDecoder.init().decoder(response: data!)
                        self.citysName.append(city.key)
                        self.maxTemperature.append(weather.max)
                        self.minTemperature.append(weather.min)
                        self.dayIcon.append(weather.icon)
//                        CollectionView işlemi arkaplana atarak yenilenmesini sağladık.
 //                        Not: eğer arkaplana atmadan çalıştırılırsa autoLayout Engine hatalar oluşturuyor.
                        DispatchQueue.main.asyncAfter(deadline: .now())
                        {
                            self.weatherCollectionView.reloadData()
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
            case ("1"), ("2"), ("3"), ("4"), ("5"):
                cell.weatherIcon.image = UIImage(named: "sun")
            case ("6"), ("7"), ("8"), ("11"):
                cell.weatherIcon.image = UIImage(named: "cloud")
            case ("12"), ("13"), ("14"), ("16"), ("17"):
                cell.weatherIcon.image = UIImage(named: "rain")
            case ("15"), ("18"):
                cell.weatherIcon.image = UIImage(named: "thunder")
            case ("19"), ("22"), ("23"), ("24"), ("25"), ("26"), ("29"):
                cell.weatherIcon.image = UIImage(named: "snowflake")
            case ("32"):
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
        selectCode = citysCode[citysName[indexPath.row].uppercased()]!
        selectCityName = citysName[indexPath.row]
        if selectCode != ""
        {
            performSegue(withIdentifier: "showWeatherDetails", sender: nil)
        }
    }
}
extension QuickViewVC
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showWeatherDetails" && selectCode != ""
        {
            let detailVC = segue.destination as! WeatherDetail
            detailVC.cityCode = selectCode
            detailVC.cityName = selectCityName
        }
        
    }
}
