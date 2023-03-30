extension Methods {
  struct SimpleIteration {
    let function: Function
    let derivative: Function
    let interval: Interval
    let tolerance: Double

    func run() throws -> Output {
      guard self.function(self.interval.from) * self.function(self.interval.to) < 0 else {
        throw Error.incorrectRootsCount
      }

      let lambda = -1 / max(
        self.derivative(self.interval.from),
        self.derivative(self.interval.to)
      )
      let phi = { x in
        x + lambda * self.function(x)
      }
      let phiDerivative = { x in
        1 + lambda * self.derivative(x)
      }

      guard max(
        phiDerivative(self.interval.from),
        phiDerivative(self.interval.to)
      ) < 1 else {
        throw Error.phiDerivativeNotLessOne
      }

      return self.run(x: self.interval.from, iterationsCount: 0, phi: phi)
    }

    private func run(x: Double, iterationsCount: Int, phi: Function) -> Output {
      let nextX = phi(x)

      guard abs(nextX - x) > self.tolerance else {
        let valueInRoot = self.function(nextX)
        return Output(root: x, valueInRoot: valueInRoot, iterationsCount: iterationsCount + 1)
      }

      return self.run(x: nextX, iterationsCount: iterationsCount + 1, phi: phi)
    }
  }
}
