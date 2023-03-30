extension Methods {
  struct SystemSimpleIteration {
    let function1: Function2
    let function2: Function2

    let phiFunction1: Function2
    let phiFunction2: Function2

    let phiDerivative11: Function2
    let phiDerivative12: Function2
    let phiDerivative21: Function2
    let phiDerivative22: Function2

    let interval1: Interval
    let interval2: Interval

    let tolerance: Double

    func run() throws -> SystemOutput {
      try self.run(
        x1: self.interval1.to,
        x2: self.interval2.to,
        iterationsCount: 0
      )
    }

    private func run(
      x1: Double,
      x2: Double,
      iterationsCount: Int
    ) throws -> SystemOutput {
      guard self.phiDerivative11(x1, x2) + self.phiDerivative12(x1, x2) < 1,
            self.phiDerivative21(x1, x2) + self.phiDerivative22(x1, x2) < 1 else {
        throw Error.common
      }

      let nextX1 = self.phiFunction1(x1, x2)
      let nextX2 = self.phiFunction2(x1, x2)

      let errorX1 = abs(nextX1 - x1)
      let errorX2 = abs(nextX2 - x2)

      guard errorX1 < self.tolerance, errorX2 < self.tolerance else {
        return try self.run(
          x1: nextX1,
          x2: nextX2,
          iterationsCount: iterationsCount + 1
        )
      }

      return .init(
        roots: (nextX1, nextX2),
        valuesInRoots: (
          self.function1(nextX1, nextX2),
          self.function2(nextX1, nextX2)
        ),
        errors: (errorX1, errorX2),
        iterationsCount: iterationsCount
      )
    }
  }
}
