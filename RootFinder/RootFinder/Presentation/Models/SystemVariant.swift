import Foundation

enum SystemVariant: CaseIterable {
  case first
  case second
}

extension SystemVariant {
  var name: String {
    switch self {
    case .first:
      return """
      0.1x1^2 + x1 + 0.2x2^2 - 0.3 = 0
      0.2x1^2 + x2 + 0.1x1x2 - 0.7 = 0
      """

    case .second:
      return """
      x2+sin(x1)=0
      x2-sin(x1)=0
      """
    }
  }
}

extension SystemVariant {
  var function1: Methods.Function2 {
    switch self {
    case .first:
      return { x1, x2 in
        0.1 * x1 * x1 + x1 + 0.2 * x2 * x2 - 0.3
      }

    case .second:
      return { x1, x2 in
        x2 + sin(x1)
      }
    }
  }

  var function2: Methods.Function2 {
    switch self {
    case .first:
      return { x1, x2 in
        0.2 * x1 * x1 + x2 + 0.1 * x1 * x2 - 0.7
      }

    case .second:
      return { x1, x2 in
        x2 - sin(x1)
      }
    }
  }

  var phiFunction1: Methods.Function2 {
    switch self {
    case .first:
      return { x1, x2 in
        0.3 - 0.1 * x1 * x1 - 0.2 * x2 * x2
      }

    case .second:
      return { x1, x2 in
        asin(x2)
      }
    }
  }

  var phiFunction2: Methods.Function2 {
    switch self {
    case .first:
      return { x1, x2 in
        0.7 - 0.2 * x1 * x1 - 0.1 * x1 * x2
      }

    case .second:
      return { x1, x2 in
        sin(x1)
      }
    }
  }

  var phiDerivative11: Methods.Function2 {
    switch self {
    case .first:
      return { x1, _ in
        -0.2 * x1
      }

    case .second:
      return { x1, _ in
        0.0
      }
    }
  }

  var phiDerivative12: Methods.Function2 {
    switch self {
    case .first:
      return { _, x2 in
        -0.4 * x2
      }

    case .second:
      return { _, x2 in
        1 / sqrt(1 - x2 * x2)
      }
    }
  }

  var phiDerivative21: Methods.Function2 {
    switch self {
    case .first:
      return { x1, x2 in
        -0.4 * x1 - 0.1 * x2
      }

    case .second:
      return { x1, x2 in
        cos(x1)
      }
    }
  }

  var phiDerivative22: Methods.Function2 {
    switch self {
    case .first:
      return { x1, _ in
        -0.1 * x1
      }

    case .second:
      return { x1, _ in
        0.0
      }
    }
  }
}
