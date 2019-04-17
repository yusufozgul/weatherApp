//
//  DetailVCTest.swift
//  WeatherAppUITests
//
//  Created by Yusuf Özgül on 15.04.2019.
//  Copyright © 2019 Yusuf Özgül. All rights reserved.
//

import XCTest

class DetailVCTest: XCTestCase {
    
    let weatherApp = XCUIApplication()
    
    let labelIDArray = ["dayLabel", "degreeLabel", "weatherDetailLabel", "cellDayLabel", "cellMaxDegree", "cellMinDegree"]
    var selectedCity = ""

    override func setUp()
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        weatherApp.launch()
        if weatherApp.collectionViews.cells.count > 0
        {
            //        Open DetailVC
            let cityCell = weatherApp.collectionViews.cells.element(boundBy: 0)
            selectedCity = cityCell.staticTexts["cityLabel"].label
            cityCell.tap()
        }
        else
        {
            addCity()
        }


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDetailVC()
    {
        /*
         DetailVC'deki elemanlar kontrol ediliyor. TableView, label, etc
 */
        let detailVC = weatherApp.otherElements.containing(.navigationBar, identifier: selectedCity).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        
        
        XCTAssertTrue(detailVC.exists, "DetailVC sorunu")
        
//        Temel Labelların ve tableview cell'deki labelların kontrolü
        for labelID in labelIDArray {
            XCTAssertTrue(detailVC.staticTexts.matching(identifier: labelID).element.exists, "\(labelID) Sorunu")
        }
        let tableView = weatherApp.tables
        XCTAssertTrue(tableView.cells.count == 5, "Tableview cell sorunu") // ttableView'da toplam gösterilmesi gereken cell'in 5 olup olmadığı kontrol ediliyor.

    }
    
    func testSelectOtherDay()
    {
        let detailVC = weatherApp.otherElements.containing(.navigationBar, identifier: selectedCity).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        let tableView = weatherApp.tables
//        Cell tıklamalarında Gerekli alanların değişip değişmediği kontol ediliyor.
        for number in 0...4
        {
            tableView.cells.element(boundBy: number).tap()
            XCTAssertTrue(detailVC.staticTexts["dayLabel"].label == tableView.cells.element(boundBy: number).staticTexts["cellDayLabel"].label, "\(number) indexli cell gün adını set edemiyor.")
            XCTAssertTrue(detailVC.staticTexts["degreeLabel"].label == tableView.cells.element(boundBy: number).staticTexts["cellMaxDegree"].label, "\(number) indexli cell max dereceyi set edemiyor.")
        }
        
    }
    func testBackSegue()
    {
        /*
         Detaylar ekranından geriye dönüş segue'sinin kontrolü
 */
        if weatherApp.collectionViews.cells.count > 0
        {
            let backButton = weatherApp.navigationBars.buttons.firstMatch
            backButton.tap()
            XCTAssertTrue(weatherApp.navigationBars["Hava Durumu"].exists, "DetailVC'den geriye Segue sorunu")
        }
        
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
