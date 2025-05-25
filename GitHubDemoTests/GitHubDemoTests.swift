//
//  GitHubDemoTests.swift
//  GitHubDemoTests
//
//  Created by 朱彥睿 on 2024/8/17.
//

import XCTest
import ComposableArchitecture

@testable import GitHubDemo

final class GitHubDemoTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    @MainActor
    func testLoadUserListSuccess() async {
        let user = User(
            avatarPath: "https://avatars.githubusercontent.com/u/3?v=4",
            login: "pjhyett",
            siteAdmin: false,
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
        )

        let store = TestStore(initialState: ListViewModel.State()) {
            ListViewModel()
        } withDependencies: {
            $0.serviceClient.getUserList = { _ in
                [user]
            }
        }

        await store.send(.viewDidLoad)

        // 因為 viewDidLoad -> paginated(1)
        await store.receive(.paginated(since: 1)) {
            $0.isFetching = true
        }

        // paginated(1) -> 成功後送 userList(.success)
        await store.receive(.userList(.success([user]))) {
            $0.users = [user]
            $0.loadedPage = 1
            $0.isFetching = false
        }
    }
    
    @MainActor
    func testLoadUserListFail() async {
        let store = TestStore(initialState: ListViewModel.State()) {
            ListViewModel()
        } withDependencies: {
            $0.serviceClient.getUserList = { _ in
                throw UserError.decodingError
            }
        }
        
        
        await store.send(.viewDidLoad)

        await store.receive(.paginated(since: 1)) {
            $0.isFetching = true
        }

        await store.receive(.userList(.failure(.decodingError))) {
            $0.isFetching = false
            $0.errorMsg = UserError.decodingError.localizedDescription
        }
    }
    
    @MainActor
    func testLoadNextPageSuccess() async {
        let user1 = User(
            avatarPath: "https://avatars.githubusercontent.com/u/3?v=4",
            login: "pjhyett",
            siteAdmin: false,
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
        )
        let user2 = User(
            avatarPath: "https://avatars.githubusercontent.com/u/3?v=4",
            login: "pjhyett",
            siteAdmin: false,
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        )
        
        let store = TestStore(initialState: ListViewModel.State(users: [user1], loadedPage: 1)) {
            ListViewModel()
        } withDependencies: {
            $0.serviceClient.getUserList = { _ in [user2] }
        }

        await store.send(.paginated(since: 2)) {
            $0.isFetching = true
        }

        await store.receive(.userList(.success([user2]))) {
            $0.users = [user1, user2]
            $0.loadedPage = 2
            $0.isFetching = false
        }
    }
    
    @MainActor
    func testEmptyUserList() async {
        let store = TestStore(initialState: ListViewModel.State()) {
            ListViewModel()
        } withDependencies: {
            $0.serviceClient.getUserList = { _ in [] }
        }
        
        await store.send(.paginated(since: 1)) {
            $0.isFetching = true
        }
        
        await store.receive(.userList(.success([]))) {
            $0.users = []
            $0.loadedPage = 1
            $0.isFetching = false
        }
        XCTAssert(store.state.users.isEmpty)
    }
}
