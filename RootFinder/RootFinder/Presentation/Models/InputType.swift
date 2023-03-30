enum InputType: CaseIterable {
  case function
  case sysytem
}

extension InputType {
  var name: String {
    switch self {
    case .function:
      return "Function"

    case .sysytem:
      return "System"
    }
  }
}
