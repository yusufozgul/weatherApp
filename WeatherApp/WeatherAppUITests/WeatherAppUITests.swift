//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Yusuf Özgül on 12.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import XCTest

class WeatherAppUITests: XCTestCase {
    
    let weatherApp = XCUIApplication()
    let elementArray = ["cityLabel", "maxDegreeLabel", "minDegreeLabel"]

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        weatherApp.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCollectionView()
    {
        /*
 CollectionView'daki elemntler kontrol belirli şartlara göre kontrol ediliyor. Hata durumunda hangi element sorunu varsa döndürülüyor.
 */
        
//        Collection View kontrolü
        let collectionView = weatherApp.otherElements.containing(.navigationBar, identifier:"Hava Durumu").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element
        XCTAssertTrue(collectionView.exists)

//        Eklenmiş şehir yoksa kontroller atlanıyor
        if weatherApp.collectionViews.cells.count > 0
        {
            //        Collection View cell kontrolü
            let collectionViewCell = weatherApp.collectionViews.cells.element(boundBy: 0)
            XCTAssertTrue(collectionViewCell.exists, "CollectionView cell sorunu")
            
            XCTAssertTrue(collectionViewCell.exists, "")
            XCTAssertTrue(collectionViewCell.staticTexts.firstMatch.exists, "")
            XCTAssertTrue(collectionViewCell.images.firstMatch.exists, "")
            
//            Cell'deki elemanlar kontol ediliyor.
            for element in elementArray
            {
                XCTAssertTrue(collectionViewCell.staticTexts.matching(identifier: element).element.exists, "\(element) Sorunu")
            }
            XCTAssertTrue(weatherApp.otherElements.images.matching(identifier: "weatherIcon").element.exists, "Weather icon sorunu")
            
        }
        else
        {
//            Kayıtlı şehir yoksa gösterilen bilgi label'ı ve activity indicator test ediliyor
            XCTAssertTrue(weatherApp.staticTexts.matching(identifier: "infoLabel").element.exists, "Bilgi Label sorunu")
            XCTAssertTrue(weatherApp.otherElements.activityIndicators.matching(identifier: "loadingIndicator").element.exists, "Loading Indicator sorunu")
            
//            Şehir eklenip test yeniden başlatıldı.
            addCity()
            
        }
    }
    
    func testSegueToDetailVC()
    {
        /*
         CollectionView'da ilk cell'e tıklandığı zaman segue işleminin yaplıp yapılmadığı kontol ediliyor. Bunun için DetailVC'deki navigation bar title'ı ile seçilen şehirin uyuşup uyuşmadığına bakılıyor.
 */
        if weatherApp.collectionViews.cells.count > 0
        {
            let collectionViewCell = weatherApp.collectionViews.cells.element(boundBy: 0)
            let selectedCityName = collectionViewCell.staticTexts["cityLabel"].label
            collectionViewCell.tap()
            XCTAssertTrue(weatherApp.navigationBars[selectedCityName].exists, "Segue Sorunu")
        }
        else
        {
            addCity()
        }
    }
    
    func testAddCityAlert()
    {
//        Şehir ekleme penceresinin doğru gösterilip gösterilmemesi kontrolü
        let addButton = weatherApp.navigationBars["Hava Durumu"]
        XCTAssertTrue(addButton.buttons["Ekle"].exists, "Şehir Ekle butonunda sorun")
        addButton.buttons["Ekle"].tap()
        
        let addAlert = weatherApp.alerts["Yeni Şehir Ekleme"]
        XCTAssertTrue(addAlert.exists, "Şehir Ekleme Alertinde bir sorun")
        XCTAssertTrue(addAlert.buttons["Ekle"].exists, "Şehir Ekleme Alerti Ekle butonunda sorun")
        XCTAssertTrue(addAlert.buttons["İptal"].exists, "Şehir Ekleme Alerti İptal butonunda sorun")

    }
    
    func testAddCityFail()
    {
//        Şehir eklemede bulunayan şehir girilmesi sonucu hata penceresinin gösterilmesi kontrolü
        let wrongCity = "Teksas"
        
        let addButton = weatherApp.navigationBars["Hava Durumu"]
        XCTAssertTrue(addButton.buttons["Ekle"].exists, "Şehir Ekle butonunda sorun")
        addButton.buttons["Ekle"].tap()
        
        let addAlert = weatherApp.alerts["Yeni Şehir Ekleme"]
        XCTAssertTrue(addAlert.exists, "Şehir Ekleme Alertinde bir sorun")
        XCTAssertTrue(addAlert.buttons["Ekle"].exists, "Şehir Ekleme Alerti Ekle butonunda sorun")
        XCTAssertTrue(addAlert.buttons["İptal"].exists, "Şehir Ekleme Alerti İptal butonunda sorun")
        
        addAlert.typeText(wrongCity)
        addAlert.buttons["Ekle"].tap()
        
        let notFoundAlert = weatherApp.alerts["UYARI"]
        XCTAssertTrue(notFoundAlert.exists, "Uyarı alertinde sorun")
        XCTAssertTrue(notFoundAlert.buttons["Tamam"].exists, "Uyarı alerti butonunda sorun")
        notFoundAlert.buttons["Tamam"].tap()
    }
    func addCity()
    {
//        Şehir olaması durumunda şehir eklenmesi sağlanıyor.
        let addButton = weatherApp.navigationBars["Hava Durumu"]
        addButton.buttons["Ekle"].tap()
        
        let addAlert = weatherApp.alerts["Yeni Şehir Ekleme"]
        addAlert.typeText("Antalya")
        addAlert.buttons["Ekle"].tap()
        XCTFail("Şehir eklendi testi yeniden başlatınız.")
    }
}
