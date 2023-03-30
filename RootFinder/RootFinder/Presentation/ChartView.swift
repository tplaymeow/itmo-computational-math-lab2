import SwiftUI
import Charts

struct ChartView: View {
  var data: [Points] = []

  var body: some View {
    Chart {
      ForEach(data, id: \.self) { points in
        ForEach(points, id: \.self) { point in
          LineMark(
            x: .value("Index", point.x),
            y: .value("Value", point.y)
          )
          .interpolationMethod(.cardinal)
        }
      }
    }
    .foregroundStyle(Color.white)
    .padding(20)
    .cornerRadius(20)
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    ChartView()
  }
}
