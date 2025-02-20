import InlineSnapshotTesting
import TestCases
import XCTest

@MainActor
final class OptionalTests: BaseIntegrationTests {
  override func setUp() {
    super.setUp()
    self.app.buttons["Optional"].tap()
    self.clearLogs()
    // SnapshotTesting.isRecording = true
  }

  func testBasics() {
    self.app.buttons["Toggle"].tap()
    self.assertLogs {
      """
      BasicsView.body
      OptionalView.body
      Store<BasicsView.Feature.State?, BasicsView.Feature.Action>.init
      Store<BasicsView.Feature.State?, BasicsView.Feature.Action>.scope
      Store<BasicsView.Feature.State?, BasicsView.Feature.Action>.scope
      Store<PresentationState<BasicsView.Feature.State>, PresentationAction<BasicsView.Feature.Action>>.scope
      StoreOf<BasicsView.Feature>.init
      StoreOf<BasicsView.Feature>.init
      StoreOf<OptionalView.Feature>.scope
      StoreOf<OptionalView.Feature>.scope
      """
    }
    self.app.buttons["Increment"].tap()
    self.assertLogs {
      """
      BasicsView.body
      OptionalView.body
      Store<BasicsView.Feature.State?, BasicsView.Feature.Action>.scope
      Store<BasicsView.Feature.State?, BasicsView.Feature.Action>.scope
      Store<BasicsView.Feature.State?, BasicsView.Feature.Action>.scope
      Store<PresentationState<BasicsView.Feature.State>, PresentationAction<BasicsView.Feature.Action>>.scope
      StoreOf<BasicsView.Feature>.scope
      StoreOf<OptionalView.Feature>.scope
      StoreOf<OptionalView.Feature>.scope
      """
    }
  }

  func testParentObserveChild() {
    self.app.buttons["Toggle"].tap()
    self.app.buttons["Increment"].tap()
    self.clearLogs()
    self.app.buttons["Observe count"].tap()
    XCTAssertEqual(self.app.staticTexts["Count: 1"].exists, true)
    self.assertLogs {
      """
      OptionalView.body
      StoreOf<OptionalView.Feature>.scope
      """
    }
    self.app.buttons["Increment"].tap()
    self.assertLogs {
      """
      BasicsView.body
      OptionalView.body
      Store<BasicsView.Feature.State?, BasicsView.Feature.Action>.scope
      Store<BasicsView.Feature.State?, BasicsView.Feature.Action>.scope
      Store<BasicsView.Feature.State?, BasicsView.Feature.Action>.scope
      Store<PresentationState<BasicsView.Feature.State>, PresentationAction<BasicsView.Feature.Action>>.scope
      StoreOf<BasicsView.Feature>.scope
      StoreOf<OptionalView.Feature>.scope
      StoreOf<OptionalView.Feature>.scope
      """
    }
  }
}
