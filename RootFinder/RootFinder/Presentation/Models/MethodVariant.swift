enum MethodVariant: CaseIterable {
  case newton
  case secant
  case simpleIteration
}

extension MethodVariant {
  var name: String {
    switch self {
    case .newton:
      return "Newton"

    case .secant:
      return "Secant"

    case .simpleIteration:
      return "Simple Iteration"
    }
  }
}
