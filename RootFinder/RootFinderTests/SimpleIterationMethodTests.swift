import XCTest
@testable import RootFinder

final class SimpleIterationMethodTests: XCTestCase {
  func testSimpleIterationMethod() throws {
    let tolerance = 0.01
    let method = Methods.SimpleIteration(
      function: FunctionVariant.first.function, // x^3 - x + 4
      derivative: FunctionVariant.first.firstDerivative, // 3x^2 - 1
      interval: .init(from: -2, to: -1),
      tolerance: tolerance
    )
    let output = try method.run()
    XCTAssertEqual(output.root, -1.79661, accuracy: tolerance)
    XCTAssertEqual(output.valueInRoot, -0.00253, accuracy: tolerance)
    XCTAssertEqual(output.iterationsCount, 3)
  }
}
