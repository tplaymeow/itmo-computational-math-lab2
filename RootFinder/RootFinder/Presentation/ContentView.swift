import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      if let chartData = self.chartData {
        ChartView(data: chartData)
      }

      Form {
        Picker("Type", selection: self.$type) {
          ForEach(InputType.allCases, id: \.self) { type in
            Text(type.name).tag(type)
          }
        }

        switch self.type {
        case .function:
          Picker("Method", selection: self.$method) {
            ForEach(MethodVariant.allCases, id: \.self) { method in
              Text(method.name).tag(method)
            }
          }

          Picker("Function", selection: self.$function) {
            ForEach(FunctionVariant.allCases, id: \.self) { function in
              Text(function.name).tag(function)
            }
          }

        case .sysytem:
          Picker("System", selection: self.$system) {
            ForEach(SystemVariant.allCases, id: \.self) { system in
              Text(system.name).tag(system)
            }
          }
        }

        switch self.type {
        case .function:
          TextField(
            "Interval from",
            value: self.$intervalFrom,
            formatter: self.numberFormatter
          )

          TextField(
            "Interval to",
            value: self.$intervalTo,
            formatter: self.numberFormatter
          )

        case .sysytem:
          TextField(
            "Interval from (x1)",
            value: self.$interval1From,
            formatter: self.numberFormatter
          )

          TextField(
            "Interval to (x1)",
            value: self.$interval1To,
            formatter: self.numberFormatter
          )

          TextField(
            "Interval from (x2)",
            value: self.$interval2From,
            formatter: self.numberFormatter
          )

          TextField(
            "Interval to (x2)",
            value: self.$interval2To,
            formatter: self.numberFormatter
          )
        }

        TextField(
          "Tolerance",
          value: self.$tolerance,
          formatter: self.numberFormatter
        )

        Button(
          "Find root",
          action: self.calculate
        )
      }

      switch self.type {
      case .function:
        if let output = self.output {
          Text("x = \(output.root)")
          Text("f(x) = \(output.valueInRoot)")
          Text("Iterations: \(output.iterationsCount)")
        }

      case .sysytem:
        if let output = self.systemOutput {
          Text("x1 = \(output.roots.0); x2 = \(output.roots.1)")
          Text("f1(x1,x2) = \(output.valuesInRoots.0); f2(x1,x2) = \(output.valuesInRoots.1)")
          Text("Δx1 = \(output.errors.0); Δx2 = \(output.errors.1)")
          Text("Iterations: \(output.iterationsCount)")
        }
      }

      if let errorMessage = self.errorMessage {
        Text(errorMessage)
      }
    }
    .padding()
  }

  @State
  private var type: InputType = .function

  @State
  private var system: SystemVariant = .first
  @State
  private var interval1From: Double = 0.0
  @State
  private var interval1To: Double = 1.0
  @State
  private var interval2From: Double = 0.0
  @State
  private var interval2To: Double = 1.0
  @State
  private var systemOutput: Methods.SystemOutput?

  @State
  private var method: MethodVariant = .newton
  @State
  private var function: FunctionVariant = .first
  @State
  private var intervalFrom: Double = 0.0
  @State
  private var intervalTo: Double = 1.0
  @State
  private var output: Methods.Output?

  @State
  private var tolerance: Double = 0.001
  @State
  private var errorMessage: String?

  private let numberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 4
    return formatter
  }()

  private var chartData: [Points] {
    switch self.type {
    case .function:
      let intervalSize = self.intervalTo - self.intervalFrom
      guard intervalSize > 0 else {
        return []
      }

      let points = linspace(
        from: self.intervalFrom - 0.1 * intervalSize,
        through: self.intervalTo + 0.1 * intervalSize,
        in: 100
      ).map { x in
        Point(x: x, y: self.function.function(x))
      }

      return [points]

    case .sysytem:
      return []
    }
  }

  private func calculate() {
    self.output = nil
    self.systemOutput = nil

    switch self.type {
    case .function:
      let interval = Methods.Interval(from: self.intervalFrom, to: self.intervalTo)
      switch method {
      case .newton:
        let method = Methods.Newton(
          function: self.function.function,
          firstDerivative: self.function.firstDerivative,
          secondDerivative: self.function.secondDerivative,
          interval: interval,
          tolerance: self.tolerance
        )
        do {
          self.output = try method.run()
          self.errorMessage = nil
        } catch {
          switch error as? Methods.Error {
          case .derivativeIsZero:
            self.errorMessage = "Error: Zero derivative"

          case .incorrectRootsCount:
            self.errorMessage = "Error: Incorrect roots count"

          default:
            self.errorMessage = "Error"
          }
        }

      case .secant:
        let method = Methods.Secant(
          function: self.function.function,
          interval: interval,
          tolerance: self.tolerance
        )
        do {
          self.output = try method.run()
          self.errorMessage = nil
        } catch {
          switch error as? Methods.Error {
          case .incorrectRootsCount:
            self.errorMessage = "Error: Incorrect roots count"

          default:
            self.errorMessage = "Error"
          }
        }

      case .simpleIteration:
        let method = Methods.SimpleIteration(
          function: self.function.function,
          derivative: self.function.firstDerivative,
          interval: interval,
          tolerance: self.tolerance
        )
        do {
          self.output = try method.run()
          self.errorMessage = nil
        } catch {
          switch error as? Methods.Error {
          case .incorrectRootsCount:
            self.errorMessage = "Error: Incorrect roots count"

          case .phiDerivativeNotLessOne:
            self.errorMessage = "Error: q >= 1"

          default:
            self.errorMessage = "Error"
          }
        }
      }

    case .sysytem:
      let method = Methods.SystemSimpleIteration(
        function1: self.system.function1,
        function2: self.system.function2,
        phiFunction1: self.system.phiFunction1,
        phiFunction2: self.system.phiFunction2,
        phiDerivative11: self.system.phiDerivative11,
        phiDerivative12: self.system.phiDerivative12,
        phiDerivative21: self.system.phiDerivative21,
        phiDerivative22: self.system.phiDerivative22,
        interval1: .init(from: self.interval1From, to: self.interval1To),
        interval2: .init(from: self.interval2From, to: self.interval2To),
        tolerance: self.tolerance
      )
      do {
        self.systemOutput = try method.run()
        self.errorMessage = nil
      } catch {
        switch error as? Methods.Error {
        case .common:
          self.errorMessage = "Error: q >= 1"

        default:
          self.errorMessage = "Error"
        }
      }
    }
  }
}
