import XCTest
@testable import RootFinder

final class SystemSimpleIterationMethodTests: XCTestCase {
  func testSystemSimpleIterationMethod() throws {
    let tolerance = 0.01
    let method = Methods.SystemSimpleIteration(
      function1: { x1, x2 in
        0.1 * x1 * x1 + x1 + 0.2 * x2 * x2 - 0.3
      },
      function2: { x1, x2 in
        0.2 * x1 * x1 + x2 + 0.1 * x1 * x2 - 0.7
      },
      phiFunction1: { x1, x2 in
        0.3 - 0.1 * x1 * x1 - 0.2 * x2 * x2
      },
      phiFunction2: { x1, x2 in
        0.7 - 0.2 * x1 * x1 - 0.1 * x1 * x2
      },
      phiDerivative11: { x1, _ in
        -0.2 * x1
      },
      phiDerivative12: { _, x2 in
        -0.4 * x2
      },
      phiDerivative21: { x1, x2 in
        -0.4 * x1 - 0.1 * x2
      },
      phiDerivative22: { x1, _ in
        -0.1 * x1
      },
      interval1: .init(from: 0.0, to: 1.0),
      interval2: .init(from: 0.0, to: 1.0),
      tolerance: tolerance
    )
    let output = try method.run()
    XCTAssertEqual(output.roots.0, 0.207, accuracy: tolerance)
    XCTAssertEqual(output.roots.1, 0.679, accuracy: tolerance)

    XCTAssertEqual(output.valuesInRoots.0, 0.0, accuracy: tolerance)
    XCTAssertEqual(output.valuesInRoots.1, 0.0, accuracy: tolerance)

    XCTAssertLessThan(output.errors.0, tolerance)
    XCTAssertLessThan(output.errors.1, tolerance)

    XCTAssertEqual(output.iterationsCount, 4)
  }
}
