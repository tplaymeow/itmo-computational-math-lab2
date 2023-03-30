func product<L, R>(
  _ left: some Collection<L>,
  _ right: some Collection<R>
) -> [(L, R)] {
  left.flatMap { l in
    right.map { r in
      (l, r)
    }
  }
}
