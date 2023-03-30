func linspace<T>(
  from start: T,
  through end: T,
  in samples: Int
) -> StrideThrough<T> where T: FloatingPoint, T == T.Stride {
  return stride(from: start, through: end, by: (end - start) / T(samples))
}
