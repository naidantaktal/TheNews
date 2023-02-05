//
//  TheNewsTests.swift
//  TheNewsTests
//
//  Created by Найдан Тактал on 05.02.2023.
//


import XCTest

@testable import TheNews

class TheNewsTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {


        UserDefaults.standard.removeObject(forKey: Settings.CategoryKey)
        UserDefaults.standard.removeObject(forKey: Settings.StyleKey)
    }

    func testUserDefaultsPropertyWrapperDefaultSetter() throws {
        let value = UserDefaultsConfig.savedCategory

        XCTAssertTrue(value.rawValue == Settings.CategoryDefault.rawValue)
    }

    func testUserDefaultsPropertyWrapperSetter() throws {
        let category = NewsCategory.entertainment
        UserDefaultsConfig.savedCategory = category

        let value = UserDefaultsConfig.savedCategory
        XCTAssertTrue(value.rawValue == category.rawValue)
    }

    func testDefaultConfiguration() throws {
        let settings = Settings()

        XCTAssertTrue(settings.category.rawValue == Settings.CategoryDefault.rawValue)
        XCTAssertTrue(settings.style.rawValue == Settings.StyleDefault.rawValue)
    }

    func testViewStyleIsTable() {
        let style = NewsViewModel.Style.cnn

        XCTAssertFalse(style.isTable)
    }

    func testChangingCategoryConfiguration() throws {
        var settings = Settings()

        let category = NewsCategory.business
        settings.category = category

        XCTAssertTrue(settings.category.rawValue == category.rawValue)
    }

    func testChangingStyleConfiguration() throws {
        var settings = Settings()

        let style = NewsViewModel.Style.cnn
        settings.style = style

        XCTAssertTrue(settings.style.rawValue == style.rawValue)
    }

    func testPerformanceExample() throws {
        measure {
        }
    }

}
