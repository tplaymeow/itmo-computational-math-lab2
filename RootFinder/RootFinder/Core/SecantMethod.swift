extension Methods {
  struct Secant {
    let function: Function
    let interval: Interval
    let tolerance: Double

    func run() throws -> Output {
      guard self.function(self.interval.from) * self.function(self.interval.to) < 0 else {
        throw Error.incorrectRootsCount
      }

      return self.run(
        from: self.interval.from,
        to: self.interval.to,
        iterationsCount: 0
      )
    }

    private func run(from: Double, to: Double, iterationsCount: Int) -> Output {
      let fromY = self.function(from)
      let toY = self.function(to)

      let nextX = (from * toY - to * fromY) / (toY - fromY)
      let y = self.function(nextX)

      guard abs(y) > self.tolerance else {
        return Output(root: nextX, valueInRoot: y, iterationsCount: iterationsCount)
      }

      guard abs(nextX - from) > self.tolerance, abs(nextX - to) > self.tolerance else {
        return Output(root: nextX, valueInRoot: y, iterationsCount: iterationsCount + 1)
      }

      return self.run(
        from: fromY * y < 0 ? from : nextX,
        to: toY * y < 0 ? to : nextX,
        iterationsCount: iterationsCount + 1
      )
    }
  }
}
