enum Methods {
  typealias Function = (Double) -> Double
  typealias Function2 = (Double, Double) -> Double

  struct Interval: Equatable {
    let from: Double
    let to: Double

    func contains(_ value: Double) -> Bool {
      (from...to).contains(value)
    }
  }

  struct Output: Equatable {
    let root: Double
    let valueInRoot: Double
    let iterationsCount: Int
  }

  struct SystemOutput {
    let roots: (Double, Double)
    let valuesInRoots: (Double, Double)
    let errors: (Double, Double)
    let iterationsCount: Int
  }

  enum Error: Swift.Error {
    case common
    case incorrectRootsCount
    case derivativeIsZero
    case phiDerivativeNotLessOne
  }
}
