extension Methods {
  struct Newton {
    let function: Function
    let firstDerivative: Function
    let secondDerivative: Function
    let interval: Interval
    let tolerance: Double

    func run() throws -> Output {
      guard self.function(self.interval.from) * self.function(self.interval.to) < 0 else {
        throw Error.incorrectRootsCount
      }

      let x = self.function(self.interval.from) * self.secondDerivative(self.interval.from) > 0
        ? self.interval.from
        : self.interval.to

      return try self.run(x: x, iterationsCount: 0)
    }

    private func run(x: Double, iterationsCount: Int) throws -> Output {
      let y = self.function(x)

      guard abs(y) > self.tolerance else {
        return Output(root: x, valueInRoot: y, iterationsCount: iterationsCount)
      }

      let dy = self.firstDerivative(x)

      guard abs(dy) > .ulpOfOne else {
        throw Error.derivativeIsZero
      }

      let nextX = x - y / dy

      guard abs(nextX - x) > self.tolerance else {
        let valueInRoot = self.function(nextX)
        return Output(root: x, valueInRoot: valueInRoot, iterationsCount: iterationsCount + 1)
      }

      return try self.run(x: nextX, iterationsCount: iterationsCount + 1)
    }
  }
}

