//
//  ChartView.swift
//  SwiftUICrypto
//


import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var trimPercentage: CGFloat = 0.0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7d?.price ?? []
        maxY = data.max() ?? 0.0
        minY = data.min() ?? 0.0
        lineColor = data.last.valueOrZero() > data.first.valueOrZero() ? Color.theme.greenColor : Color.theme.redColor
        endingDate = coin.lastUpdated ?? Date()
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60) // 7 days
    }
    
    var body: some View {
        VStack {
            chartBodyView
                .background(
                    chartHorizontalAxisView
                        
                )
                .overlay(chartHorizontalAxisLabelsView, alignment: .leading)
            
            chartDateLabelsView
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryTextColor)
        .animation(.linear(duration: 1), value: trimPercentage)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                trimPercentage = 1
            }
        }
    }
}

extension ChartView {
    private var chartBodyView: some View {
        GeometryReader { proxy in
            Path { path in
                for index in data.indices {
                    let xPosition = proxy.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxisHeight = maxY - minY
                    let yDataValue = data[index] - minY
                    let yPosition = (1 - yDataValue / yAxisHeight) * proxy.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    } else {
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
            }
            .trim(from: 0, to: trimPercentage)
            .stroke(
                lineColor,
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.3), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
    }
    
    private var chartHorizontalAxisView: some View {
        VStack {
            Group {
                Divider()
                Spacer()
                Divider()
                Spacer()
                Divider()
            }
        }
    }
    
    private var chartHorizontalAxisLabelsView: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
                .offset(CGSize(width: 0, height: -20))
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabelsView: some View {
        HStack {
            Text(startingDate.shortDateString)
            Spacer()
            Text(endingDate.shortDateString)
        }
    }
}

#Preview {
    ChartView(coin: previewCoin)
        .frame(height: 200)
}
