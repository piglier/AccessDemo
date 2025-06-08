//
//  GitHubDemoUITests.swift
//  GitHubDemoUITests
//
//  Created by 朱彥睿 on 2024/8/17.
//

import XCTest

final class GitHubDemoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    // MARK: - 1. App 啟動後有資料

        func testListLoadsUsers() throws {
            let app = XCUIApplication()
            app.launch()

            // ❗️你在 ListViewController 的 collectionView 建議設定
            // collectionView.accessibilityIdentifier = "UserList"
            let list = app.collectionViews["UserList"]

            // 最多等 5 秒，等第一個 cell 出現
            let firstCell = list.cells.element(boundBy: 0)
            XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "使用者清單應該載入至少一筆資料")
        }

        // MARK: - 2. 點擊 cell 會開啟 Profile 畫面

        func testTapUserShowsProfile() throws {
            let app = XCUIApplication()
            app.launch()

            let list = app.collectionViews["UserList"]
            let firstCell = list.cells.element(boundBy: 0)
            XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
            firstCell.tap()

            // ❗️假設 Profile 介面有一個 label 或 navigation title
            // 並且你加上了 identifier "ProfileView"
            let profileView = app.otherElements["ProfileView"]
            XCTAssertTrue(profileView.waitForExistence(timeout: 3), "點擊使用者後應跳到 Profile 畫面")
        }

        // MARK: - 3. 滑到底部觸發分頁，載入更多 cell

        func testPaginationLoadsMoreUsers() throws {
            let app = XCUIApplication()
            app.launch()

            let list = app.collectionViews["UserList"]
            XCTAssertTrue(list.waitForExistence(timeout: 5))

            // 先記錄目前 cell 數
            let originalCount = list.cells.count
            XCTAssertGreaterThan(originalCount, 0, "初始應該有資料")

            // 滑到最底多次以觸發分頁
            for _ in 0..<5 {
                list.swipeUp(velocity: .fast)
            }
            // 最多等 5 秒，看 cell 數量是否增加
            let expectation = XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "count > %d", originalCount),
                object: list.cells
            )
            let result = XCTWaiter().wait(for: [expectation], timeout: 5)
            XCTAssertEqual(result, .completed, "分頁後 cell 數應該增加")
        }
}
