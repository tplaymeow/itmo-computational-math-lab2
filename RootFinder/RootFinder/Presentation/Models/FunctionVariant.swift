import Foundation

enum FunctionVariant: CaseIterable {
  case first
  case second
  case third
}

extension FunctionVariant {
  var name: String {
    switch self {
    case .first:
      return "x^3 - x + 4"

    case .second:
      return "−1.38x^3 − 5.42x^2 + 2.57x + 10.95"

    case .third:
      return "sin(x)"
    }
  }
}

extension FunctionVariant {
  var function: Methods.Function {
    switch self {
    case .first:
      return { x in
        pow(x, 3) - x + 4
      }

    case .second:
      return { x in
        -1.38 * pow(x, 3) - 5.42 * pow(x, 2) + 2.57 * x + 10.95
      }

    case .third:
      return sin
    }
  }

  var firstDerivative: Methods.Function {
    switch self {
    case .first:
      return { x in
        3 * pow(x, 2) - 1
      }

    case .second:
      return { x in
        2.57 - 10.84 * x - 4.14 * pow(x, 2)
      }

    case .third:
      return cos
    }
  }

  var secondDerivative: Methods.Function {
    switch self {
    case .first:
      return { x in
        6 * x
      }

    case .second:
      return { x in
        -10.84 - 8.28 * x
      }

    case .third:
      return { x in
        -1 * sin(x)
      }
    }
  }
}
