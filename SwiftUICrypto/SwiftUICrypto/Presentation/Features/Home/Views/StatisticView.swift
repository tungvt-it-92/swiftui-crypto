//
//  MarketDataView.swift
//  SwiftUICrypto
//
import SwiftUI

struct StatisticColumn: View {
    let statisticsModel: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statisticsModel.title)
                .foregroundStyle(Color.theme.secondaryTextColor)
                .font(.caption)
            
            Text(statisticsModel.value)
                .foregroundStyle(Color.theme.accentColor)
                .bold()
            
            if let percentageChange = statisticsModel.percentageChange {
                HStack {
                    Image(systemName: "triangle.fill")
                        .rotationEffect(
                            percentageChange < 0 ?
                            Angle(degrees: 180) : Angle(degrees: 0)
                        )
                    Text(percentageChange.asPercentageString())
                }
                .foregroundStyle(
                    percentageChange < 0 ?
                    Color.red : Color.green
                )
            }
        }
    }
}

struct StatisticView: View {
    let statisticModels: [StatisticModel]
    let showPortfolioColumn: Bool
    let parentWidth: CGFloat
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(statisticModels, id: \.self) { statisticModel in
                StatisticColumn(statisticsModel: statisticModel)
                    .frame(
                        width: (parentWidth - 30) / 3,
                        alignment: .center
                    )
            }
        }
        .frame(
            width: parentWidth - 30,
            alignment: showPortfolioColumn ? .trailing : .leading
        )
    }
}

#if DEBUG

#Preview(traits: .sizeThatFitsLayout) {
    StatisticView(
        statisticModels: previewStatistics,
        showPortfolioColumn: false,
        parentWidth: 300
    )
}

#endif
