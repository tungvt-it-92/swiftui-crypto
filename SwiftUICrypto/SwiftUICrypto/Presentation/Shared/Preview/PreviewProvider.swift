//
//  PreviewProvider.swift
//  SwiftUICrypto
//
//#if DEBUG
import Foundation

// Helper for ISO 8601 dates
@MainActor private let isoFormatter = ISO8601DateFormatter()

@MainActor let previewMarketData = MarketData(
    activeCryptocurrencies: 17055,
    upcomingIcos: 0,
    ongoingIcos: 49,
    endedIcos: 3376,
    markets: 1300,
    totalMarketCap: [
        "btc": 32895176.620890114,
        "usd": 2772501357230.9385
    ],
    totalVolume: [
        "btc": 1021096.3045046378,
        "usd": 86060972486.3061,
        "aed": 316101951942.2023
    ],
    marketCapPercentage: [
        "btc": 60.34509322985012,
        "eth": 6.975324345081208,
        "usdt": 5.205349382795324,
    ],
    marketCapChangePercentage24hUsd: -0.586787764447509,
    updatedAt: 1744547615
)

@MainActor let previewStatistics: [StatisticModel] = [
    StatisticModel(title: "Total Market Cap", value: "2772501357230.9385"),
    StatisticModel(title: "Total Volume", value: "86060972486.3061", percentageChange: -1.5),
    StatisticModel(title: "Market Cap Change 24h", value: "10234567", percentageChange: 5.05)
]

@MainActor let previewCoin = CoinModel(
    id: "bitcoin",
    symbol: "BTC",
    name: "Bitcoin",
    marketCapRank: 1,
    image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
    currentPrice: 65000.75,
    marketCap: 1_283_456_789_123,
    fullyDilutedValuation: 1_365_000_000_000,
    totalVolume: 45_678_901_234,
    high24h: 67000.50,
    low24h: 64000.25,
    priceChange24h: -500.30,
    priceChangePercentage24h: -0.76,
    marketCapChange24h: -10_234_567_890,
    marketCapChangePercentage24h: -0.79,
    circulatingSupply: 19_750_000.0,
    totalSupply: 21_000_000.0,
    maxSupply: 21_000_000.0,
    ath: 73777.00,
    athChangePercentage: -11.87,
    athDate: isoFormatter.date(from: "2024-11-10T14:30:00Z")!,
    atl: 67.81,
    atlChangePercentage: 95788.12,
    atlDate: isoFormatter.date(from: "2013-07-06T00:00:00Z")!,
    roi: nil,
    lastUpdated: isoFormatter.date(from: "2025-04-11T10:00:00Z")!,
    sparklineIn7d: Sparkline(
        price: [
            1804.7458060517372,
            1800.7182087305052,
            1819.26515723935,
            1827.5945877548909,
            1831.3864683139946,
            1784.5597333187225,
            1786.09764839746,
            1797.8511395587539,
            1796.888925199396,
            1804.963948836221,
            1794.9736288077643,
            1797.062447494226,
            1822.4400553622188,
            1805.1571281947615,
            1811.5014364967367,
            1822.3780657123782,
            1818.0398321561038,
            1819.51137614555,
            1812.8636402718714,
            1822.9654232307414,
            1819.5936705575245,
            1815.860451984037,
            1809.9871992560159,
            1808.663361680511,
            1809.801015819122,
            1807.7390191347956,
            1812.3059331693933,
            1813.1866854103878,
            1821.4246333198307,
            1818.4233490241245,
            1806.9314297084081,
            1795.3744531238297,
            1787.4737030867018,
            1790.7087499444021,
            1782.4719890365761,
            1784.4874965063464,
            1786.7694931989558,
            1792.4364113031302,
            1782.7331739986682,
            1789.278140615678,
            1793.0997146048924,
            1796.6380815832538,
            1806.9138407099463,
            1809.9297371672026,
            1809.434839850118,
            1805.1078594380404,
            1807.9472372444998,
            1808.8749205844604,
            1810.8210811459035,
            1799.6307752714176,
            1797.5117465541487,
            1794.3250437978866,
            1790.1826036744876,
            1789.2709971059512,
            1789.114643994225,
            1780.061395487873,
            1749.859587047862,
            1765.6265727420903,
            1756.727373954113,
            1737.663523014378,
            1675.5697634244402,
            1620.3216757769314,
            1627.820963133028,
            1574.8485493893695,
            1587.400199993651,
            1569.2502317173878,
            1579.0366252686324,
            1572.9546621100367,
            1577.2224353717515,
            1565.1872416501783,
            1543.7195986582446,
            1542.1405014686475,
            1539.1343681109986,
            1431.7317354788427,
            1460.1188971347758,
            1493.115630454946,
            1487.765036007936,
            1491.2079592407495,
            1486.0197395366854,
            1515.6760555564645,
            1555.6202657817064,
            1574.7623344333686,
            1555.5145894643515,
            1531.161143174932,
            1566.5648149141439,
            1552.5939219454385,
            1543.62719075936,
            1569.1290084604236,
            1566.060939150459,
            1577.9143266235733,
            1559.033144324226,
            1545.9965073253238,
            1589.4781875632534,
            1587.433571256241,
            1582.9388271174212,
            1593.7402813338936,
            1589.5081752833983,
            1576.4087961751945,
            1568.6030176924403,
            1565.41422380073,
            1567.9861019608727,
            1567.461828513284,
            1585.158743096009,
            1570.8989520894415,
            1566.5822594492706,
            1536.7393707592653,
            1530.232743959875,
            1486.7267307453815,
            1479.79022044931,
            1474.0968320977308,
            1465.476595278921,
            1478.0534038986498,
            1474.6995604681726,
            1464.1916779991018,
            1472.0913986626454,
            1462.5771439997247,
            1430.3791903784584,
            1421.8459890371487,
            1417.3548396971037,
            1439.624520978951,
            1456.005481835613,
            1462.9931072898971,
            1484.6836862497428,
            1479.3059548587523,
            1479.2525492423724,
            1487.1895788545642,
            1454.009697853938,
            1462.0541733047864,
            1489.4620843877572,
            1474.9756956905615,
            1485.5789774077023,
            1501.2146933764227,
            1612.3027649058047,
            1631.2756871894896,
            1640.8830289237035,
            1662.0227558580898,
            1672.6973219065605,
            1668.8850763920027,
            1667.065136499343,
            1642.0219005229399,
            1636.4754111543862,
            1634.3886406450013,
            1610.8155533221197,
            1621.158711016868,
            1618.6424586971982,
            1593.1487806169844,
            1591.0134626922077,
            1590.5117591784185,
            1592.5110264398857,
            1587.2489308190861,
            1592.9332467243082,
            1592.7089123491185,
            1573.7319379017276,
            1569.4207455322828,
            1501.1248472301354,
            1507.6805806308703,
            1509.5122743804031,
            1518.104264103272,
            1518.5308649601548,
            1529.4643317661541,
            1523.7207535690857,
            1525.0304095343854,
            1521.3245487030365,
            1510.667697486076,
            1539.2395572310618,
            1535.9051542755703,
            1542.7191125656489,
            1546.200169622373
        ]
    ),
    favorite: true,
    currentHolding: 1224,
    currentHoldingValue: 10000000
)

@MainActor let previewCoinDetailModel = CoinDetailModel(
    id: "bitcoin",
    symbol: "btc",
    name: "Bitcoin",
    description: Description(
        en: """
        Bitcoin is the first successful internet money based on peer-to-peer technology; whereby no central bank or authority is involved in the transaction and production of the Bitcoin currency. It was created by an anonymous individual/group under the name, Satoshi Nakamoto. The source code is available publicly as an open source project, anybody can look at it and be part of the developmental process.\r\n\r\nBitcoin is changing the way we see money as we speak. The idea was to produce a means of exchange, independent of any central authority, that could be transferred electronically in a secure, verifiable and immutable way. It is a decentralized peer-to-peer internet currency making mobile payment easy, very low transaction fees, protects your identity, and it works anywhere all the time with no central authority and banks.\r\n\r\nBitcoin is designed to have only 21 million BTC ever created, thus making it a deflationary currency. Bitcoin uses the SHA-256 hashing algorithm with an average transaction confirmation time of 10 minutes. Miners today are mining Bitcoin using ASIC chip dedicated to only mining Bitcoin, and the hash rate has shot up to peta hashes.\r\n\r\nBeing the first successful online cryptography currency, Bitcoin has inspired other alternative currencies such as Litecoin, Peercoin, Primecoin, and so on.\r\n\r\nThe cryptocurrency then took off with the innovation of the turing-complete smart contract by Ethereum which led to the development of other amazing projects such as EOS, Tron, and even crypto-collectibles such as CryptoKitties.
        """
    ),
    image: ImageInfo(large: "https://example.com/bitcoin-large.png"),
    categories: ["Cryptocurrency", "Blockchain"],
    links: Link(homepage: ["https://bitcoin.org"], subredditUrl: "https://reddit.com/r/Bitcoin"),
    hashingAlgorithm: "SHA-256",
    blockTimeInMinutes: 10.0
)

@MainActor
struct PreviewDataProvider {
    static let shared = PreviewDataProvider()
    
    let previewHomeVM = HomeViewModel()
    
    private init() {
        let eth = CoinModel(
            id: "ethereum",
            symbol: "Ethereum",
            name: "eth",
            marketCapRank: 1,
            image: "https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628",
            currentPrice: 2000
        )
        let tether = CoinModel(
            id: "tether",
            symbol: "usdt",
            name: "Tether",
            marketCapRank: 2,
            image: "https://coin-images.coingecko.com/coins/images/325/large/Tether.png?1696501661",
            currentPrice: 1000
        )
        let ripple = CoinModel(
            id: "ripple",
            symbol: "xrp",
            name: "XRP",
            marketCapRank: 3,
            image: "https://coin-images.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png?1696501442",
            currentPrice: 500
        )
        let binancecoin = CoinModel(
            id: "binancecoin",
            symbol: "bnb",
            name: "BNB",
            marketCapRank: 4,
            image: "https://coin-images.coingecko.com/coins/images/825/large/bnb-icon2_2x.png?1696501970",
            currentPrice: 200
        )
        let solana = CoinModel(
            id: "solana",
            symbol: "sol",
            name: "Solana",
            marketCapRank: 5,
            image: "https://coin-images.coingecko.com/coins/images/4128/large/solana.png?1718769756",
            currentPrice: 50
        )
        
        previewHomeVM.filteredCoins = [
            previewCoin,
            eth,
            tether,
            ripple,
            binancecoin,
            solana
        ]
    }
}


//#endif
