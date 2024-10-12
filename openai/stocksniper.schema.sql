USE [StockSniper]
GO
/****** Object:  Table [dbo].[Analyses]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Analyses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockSummaryId] [int] NOT NULL,
	[CurrentQtr] [datetime2](7) NULL,
	[NextQtr] [datetime2](7) NULL,
	[CurrentYr] [int] NULL,
	[NextYr] [int] NULL,
	[EpsAnalystCountCurrentQtr] [int] NULL,
	[EpsAnalystCountNextQtr] [int] NULL,
	[EpsAnalystCountCurrentYr] [int] NULL,
	[EpsAnalystCountNextYr] [int] NULL,
	[EpsAverageEstimateCurrentQtr] [float] NULL,
	[EpsAverageEstimateNextQtr] [float] NULL,
	[EpsAverageEstimateCurrentYr] [float] NULL,
	[EpsAverageEstimateNextYr] [float] NULL,
	[EpsLowEstimateCurrentQtr] [float] NULL,
	[EpsLowEstimateNextQtr] [float] NULL,
	[EpsLowEstimateCurrentYr] [float] NULL,
	[EpsLowEstimateNextYr] [float] NULL,
	[EpsHighEstimateCurrentQtr] [float] NULL,
	[EpsHighEstimateNextQtr] [float] NULL,
	[EpsHighEstimateCurrentYr] [float] NULL,
	[EpsHighEstimateNextYr] [float] NULL,
	[EpsYearAgoCurrentQtr] [float] NULL,
	[EpsYearAgoNextQtr] [float] NULL,
	[EpsYearAgoCurrentYr] [float] NULL,
	[EpsYearAgoNextYr] [float] NULL,
	[RevAnalystCountCurrentQtr] [int] NULL,
	[RevAnalystCountNextQtr] [int] NULL,
	[RevAnalystCountCurrentYr] [int] NULL,
	[RevAnalystCountNextYr] [int] NULL,
	[RevAverageEstimateCurrentQtr] [float] NULL,
	[RevAverageEstimateNextQtr] [float] NULL,
	[RevAverageEstimateCurrentYr] [float] NULL,
	[RevAverageEstimateNextYr] [float] NULL,
	[RevLowEstimateCurrentQtr] [float] NULL,
	[RevLowEstimateNextQtr] [float] NULL,
	[RevLowEstimateCurrentYr] [float] NULL,
	[RevLowEstimateNextYr] [float] NULL,
	[RevHighEstimateCurrentQtr] [float] NULL,
	[RevHighEstimateNextQtr] [float] NULL,
	[RevHighEstimateCurrentYr] [float] NULL,
	[RevHighEstimateNextYr] [float] NULL,
	[RevLastYearSalesCurrentQtr] [float] NULL,
	[RevLastYearSalesNextQtr] [float] NULL,
	[RevLastYearSalesCurrentYr] [float] NULL,
	[RevLastYearSalesNextYr] [float] NULL,
	[RevLastSalesGrowthCurrentQtr] [float] NULL,
	[RevLastSalesGrowthNextQtr] [float] NULL,
	[RevLastSalesGrowthCurrentYr] [float] NULL,
	[RevLastSalesGrowthNextYr] [float] NULL,
	[RecommendationNumber] [float] NULL,
	[RecommendationText] [nvarchar](15) NULL,
	[TargetPriceAnalysts] [int] NULL,
	[TargetPriceCurrent] [decimal](18, 2) NULL,
	[TargetPriceAverage] [decimal](18, 2) NULL,
	[TargetPriceLow] [decimal](18, 2) NULL,
	[TargetPriceHigh] [decimal](18, 2) NULL,
	[AnalysisCreated] [datetime2](7) NOT NULL,
	[AnalysisUpdated] [datetime2](7) NULL,
 CONSTRAINT [PK_Analyses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BalanceSheets]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BalanceSheets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockSummaryId] [int] NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[TotalCurrentAssets] [float] NULL,
	[TotalLiabilities] [float] NULL,
	[TotalNonCurrentAssets] [float] NULL,
	[TotalStockHolderEquity] [float] NULL,
	[TotalAssets] [float] NULL,
	[TotalCurrentLiabilities] [float] NULL,
	[LongTermDebt] [float] NULL,
 CONSTRAINT [PK_BalanceSheets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CashFlows]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CashFlows](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockSummaryId] [int] NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[FreeCashFlow] [float] NULL,
	[NetCashFromInvestingActivities] [float] NULL,
	[NetCashFromOperatingActivities] [float] NULL,
	[NetChangeInCash] [float] NULL,
 CONSTRAINT [PK_CashFlows] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockSummaryId] [int] NOT NULL,
	[PostalAddress] [nvarchar](500) NULL,
	[WebsiteUrl] [nvarchar](500) NULL,
	[Narrative] [nvarchar](max) NULL,
	[Sector] [nvarchar](100) NULL,
	[Industry] [nvarchar](100) NULL,
	[FullTimeEmployees] [int] NULL,
	[GovernanceNarrative] [nvarchar](250) NULL,
	[GovernanceQualityScore] [int] NULL,
	[GovernanceQualityScoreDate] [datetime2](7) NULL,
 CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Executives]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Executives](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[Name] [nvarchar](150) NULL,
	[Title] [nvarchar](150) NULL,
	[Pay] [decimal](18, 2) NULL,
	[Exercised] [decimal](18, 2) NULL,
	[YearBorn] [int] NULL,
 CONSTRAINT [PK_Executives] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FinancialPerformances]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FinancialPerformances](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockSummaryId] [int] NOT NULL,
	[Symbol] [nvarchar](10) NOT NULL,
	[EarningsBeforeInterestAndTax] [float] NULL,
	[TotalRevenue] [float] NULL,
	[TotalAssets] [float] NULL,
	[ReturnOnCapitalEmployed] [float] NULL,
	[LongTermDebt] [float] NULL,
	[FreeCashFlow] [float] NULL,
	[FreeCashFlowPerShare] [float] NULL,
	[EarningsBeforeInterestAndTaxMargin] [float] NULL,
	[DebtToFreeCashFlowRatio] [float] NULL,
	[Date] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_FinancialPerformances] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncomeStatements]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncomeStatements](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockSummaryId] [int] NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[BasicAverageShares] [float] NULL,
	[BasicEps] [float] NULL,
	[CostOfRevenue] [float] NULL,
	[DilutedAverageShares] [float] NULL,
	[DilutedEps] [float] NULL,
	[GrossProfit] [float] NULL,
	[IncomeBeforeTax] [float] NULL,
	[IncomeFromContinuingOperations] [float] NULL,
	[IncomeTaxExpense] [float] NULL,
	[InterestExpense] [float] NULL,
	[NetIncome] [float] NULL,
	[NetIncomeAvailableToCommonShareholders] [float] NULL,
	[OperatingIncomeOrLoss] [float] NULL,
	[TotalOperatingExpenses] [float] NULL,
	[TotalRevenue] [float] NULL,
 CONSTRAINT [PK_IncomeStatements] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LseStockSymbols]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LseStockSymbols](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Symbol] [nvarchar](10) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Currency] [nvarchar](5) NOT NULL,
	[Added] [datetime2](7) NULL,
	[Updated] [datetime2](7) NULL,
	[Refreshed] [datetime2](7) NULL,
	[MarketCap] [decimal](20, 4) NULL,
	[Price] [decimal](18, 4) NULL,
	[Change] [decimal](18, 4) NULL,
	[ChangePercent] [decimal](9, 2) NULL,
	[RefreshStatus] [nvarchar](max) NULL,
 CONSTRAINT [PK_LseStockSymbols] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockAnalysisSummary]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockAnalysisSummary](
	[Id] [int] NOT NULL,
	[Source] [nvarchar](20) NOT NULL,
	[Symbol] [nvarchar](10) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[PreviousClose] [decimal](18, 2) NULL,
	[Open] [decimal](18, 2) NULL,
	[Bid] [nvarchar](50) NULL,
	[Ask] [nvarchar](50) NULL,
	[DaysRange] [nvarchar](50) NULL,
	[FiftyTwoWeekRange] [nvarchar](50) NULL,
	[AverageVolume] [int] NULL,
	[MarketCap] [decimal](18, 2) NULL,
	[Beta] [decimal](18, 2) NULL,
	[PeRatio] [decimal](18, 2) NULL,
	[EarningsPerShare] [decimal](18, 2) NULL,
	[EarningsDate] [datetime2](7) NULL,
	[ForwardDividend] [decimal](18, 2) NULL,
	[ForwardDividendYield] [decimal](18, 2) NULL,
	[ExDividendDate] [datetime2](7) NULL,
	[OneYearTargetEstimate] [decimal](18, 2) NULL,
	[CurrentQtr] [datetime2](7) NULL,
	[NextQtr] [datetime2](7) NULL,
	[CurrentYr] [int] NULL,
	[NextYr] [int] NULL,
	[EpsAnalystCountCurrentQtr] [int] NULL,
	[EpsAnalystCountNextQtr] [int] NULL,
	[EpsAnalystCountCurrentYr] [int] NULL,
	[EpsAnalystCountNextYr] [int] NULL,
	[EpsAverageEstimateCurrentQtr] [float] NULL,
	[EpsAverageEstimateNextQtr] [float] NULL,
	[EpsAverageEstimateCurrentYr] [float] NULL,
	[EpsAverageEstimateNextYr] [float] NULL,
	[EpsLowEstimateCurrentQtr] [float] NULL,
	[EpsLowEstimateNextQtr] [float] NULL,
	[EpsLowEstimateCurrentYr] [float] NULL,
	[EpsLowEstimateNextYr] [float] NULL,
	[EpsHighEstimateCurrentQtr] [float] NULL,
	[EpsHighEstimateNextQtr] [float] NULL,
	[EpsHighEstimateCurrentYr] [float] NULL,
	[EpsHighEstimateNextYr] [float] NULL,
	[EpsYearAgoCurrentQtr] [float] NULL,
	[EpsYearAgoNextQtr] [float] NULL,
	[EpsYearAgoCurrentYr] [float] NULL,
	[EpsYearAgoNextYr] [float] NULL,
	[RevAnalystCountCurrentQtr] [int] NULL,
	[RevAnalystCountNextQtr] [int] NULL,
	[RevAnalystCountCurrentYr] [int] NULL,
	[RevAnalystCountNextYr] [int] NULL,
	[RevAverageEstimateCurrentQtr] [float] NULL,
	[RevAverageEstimateNextQtr] [float] NULL,
	[RevAverageEstimateCurrentYr] [float] NULL,
	[RevAverageEstimateNextYr] [float] NULL,
	[RevLowEstimateCurrentQtr] [float] NULL,
	[RevLowEstimateNextQtr] [float] NULL,
	[RevLowEstimateCurrentYr] [float] NULL,
	[RevLowEstimateNextYr] [float] NULL,
	[RevHighEstimateCurrentQtr] [float] NULL,
	[RevHighEstimateNextQtr] [float] NULL,
	[RevHighEstimateCurrentYr] [float] NULL,
	[RevHighEstimateNextYr] [float] NULL,
	[RevLastYearSalesCurrentQtr] [float] NULL,
	[RevLastYearSalesNextQtr] [float] NULL,
	[RevLastYearSalesCurrentYr] [float] NULL,
	[RevLastYearSalesNextYr] [float] NULL,
	[RevLastSalesGrowthCurrentQtr] [float] NULL,
	[RevLastSalesGrowthNextQtr] [float] NULL,
	[RevLastSalesGrowthCurrentYr] [float] NULL,
	[RevLastSalesGrowthNextYr] [float] NULL,
	[RecommendationNumber] [float] NULL,
	[RecommendationText] [nvarchar](15) NULL,
	[TargetPriceAnalysts] [int] NULL,
	[TargetPriceCurrent] [decimal](18, 2) NULL,
	[TargetPriceAverage] [decimal](18, 2) NULL,
	[TargetPriceLow] [decimal](18, 2) NULL,
	[TargetPriceHigh] [decimal](18, 2) NULL,
	[AnalysisCreated] [datetime2](7) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockSummaries]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockSummaries](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Source] [nvarchar](20) NOT NULL,
	[Symbol] [nvarchar](10) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[PreviousClose] [decimal](18, 2) NULL,
	[Open] [decimal](18, 2) NULL,
	[Bid] [nvarchar](50) NULL,
	[Ask] [nvarchar](50) NULL,
	[DaysRange] [nvarchar](50) NULL,
	[FiftyTwoWeekRange] [nvarchar](50) NULL,
	[AverageVolume] [int] NULL,
	[MarketCap] [decimal](18, 2) NULL,
	[Beta] [decimal](18, 2) NULL,
	[PeRatio] [decimal](18, 2) NULL,
	[EarningsPerShare] [decimal](18, 2) NULL,
	[EarningsDate] [datetime2](7) NULL,
	[ForwardDividend] [decimal](18, 2) NULL,
	[ForwardDividendYield] [decimal](18, 2) NULL,
	[ExDividendDate] [datetime2](7) NULL,
	[OneYearTargetEstimate] [decimal](18, 2) NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateLastUpdated] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_StockSummaries] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StockSummaries] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [DateCreated]
GO
ALTER TABLE [dbo].[StockSummaries] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [DateLastUpdated]
GO
/****** Object:  StoredProcedure [dbo].[GetFinancialPerformanceMetrics]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE
	

 PROCEDURE [dbo].[GetFinancialPerformanceMetrics] @symbol NVARCHAR(10)
AS
SELECT ISNULL(t5.Id, 0) [Id]
	,t1.Id [StockSummaryId]
	,t1.Symbol
	,t2.OperatingIncomeOrLoss [EarningsBeforeInterestAndTax]
	,t2.TotalRevenue
	,t3.TotalAssets
	,t3.TotalCurrentLiabilities
	,(t2.OperatingIncomeOrLoss / NULLIF((t3.TotalAssets - t3.TotalCurrentLiabilities), 0)) * 100 [ReturnOnCapitalEmployed]
	,t3.LongTermDebt
	,t4.FreeCashFlow [FreeCashFlow]
	,t4.FreeCashFlow / NULLIF(t2.DilutedAverageShares, 0) [FreeCashFlowPerShare]
	,t2.DilutedEps
	,(t2.OperatingIncomeOrLoss / NULLIF(t2.TotalRevenue, 0)) * 100 [EarningsBeforeInterestAndTaxMargin]
	,t3.LongTermDebt / NULLIF(t4.FreeCashFlow, 0) [DebtToFreeCashFlowRatio]
	,t2.Date
FROM StockSummaries t1
JOIN IncomeStatements t2 ON t1.Id = t2.StockSummaryId
JOIN BalanceSheets t3 ON t1.Id = t3.StockSummaryId AND t2.Date = t3.Date
JOIN CashFlows t4 ON t1.Id = t4.StockSummaryId AND t2.Date = t4.Date
LEFT JOIN FinancialPerformances t5 on t5.Symbol = t1.Symbol AND t5.Date = t2.Date
WHERE t1.Symbol = @symbol
ORDER BY t2.Date;
GO
/****** Object:  StoredProcedure [dbo].[GetStockSummaryAnalysis]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE
	

 PROCEDURE [dbo].[GetStockSummaryAnalysis] @pageNumber INT
	,@rowsPerPage INT
	,@columnId SYSNAME
	,@sortDesc BIT
AS
BEGIN
	DECLARE @offsetRows INT = @rowsPerPage * (@pageNumber - 1);

	WITH RankedAnalyses
	AS (
		SELECT *
			,ROW_NUMBER() OVER (
				PARTITION BY StockSummaryId ORDER BY CurrentQtr DESC
				) AS Rnk
		FROM Analyses
		)
	SELECT t1.Id
		,t1.Source
		,t1.Symbol
		,t1.DateLastUpdated
		,t1.Name
		,t1.PreviousClose
		,t1.[Open]
		,t1.Bid
		,t1.Ask
		,t1.DaysRange
		,t1.FiftyTwoWeekRange
		,t1.AverageVolume
		,t1.MarketCap
		,t1.Beta
		,t1.PeRatio
		,t1.EarningsPerShare
		,t1.EarningsDate
		,t1.ForwardDividend
		,t1.ForwardDividendYield
		,t1.ExDividendDate
		,t1.OneYearTargetEstimate
		,t3.CurrentQtr
		,t3.NextQtr
		,t3.CurrentYr
		,t3.NextYr
		,t3.EpsAnalystCountCurrentQtr
		,t3.EpsAnalystCountNextQtr
		,t3.EpsAnalystCountCurrentYr
		,t3.EpsAnalystCountNextYr
		,t3.EpsAverageEstimateCurrentQtr
		,t3.EpsAverageEstimateNextQtr
		,t3.EpsAverageEstimateCurrentYr
		,t3.EpsAverageEstimateNextYr
		,t3.EpsLowEstimateCurrentQtr
		,t3.EpsLowEstimateNextQtr
		,t3.EpsLowEstimateCurrentYr
		,t3.EpsLowEstimateNextYr
		,t3.EpsHighEstimateCurrentQtr
		,t3.EpsHighEstimateNextQtr
		,t3.EpsHighEstimateCurrentYr
		,t3.EpsHighEstimateNextYr
		,t3.EpsYearAgoCurrentQtr
		,t3.EpsYearAgoNextQtr
		,t3.EpsYearAgoCurrentYr
		,t3.EpsYearAgoNextYr
		,t3.RevAnalystCountCurrentQtr
		,t3.RevAnalystCountNextQtr
		,t3.RevAnalystCountCurrentYr
		,t3.RevAnalystCountNextYr
		,t3.RevAverageEstimateCurrentQtr
		,t3.RevAverageEstimateNextQtr
		,t3.RevAverageEstimateCurrentYr
		,t3.RevAverageEstimateNextYr
		,t3.RevLowEstimateCurrentQtr
		,t3.RevLowEstimateNextQtr
		,t3.RevLowEstimateCurrentYr
		,t3.RevLowEstimateNextYr
		,t3.RevHighEstimateCurrentQtr
		,t3.RevHighEstimateNextQtr
		,t3.RevHighEstimateCurrentYr
		,t3.RevHighEstimateNextYr
		,t3.RevLastYearSalesCurrentQtr
		,t3.RevLastYearSalesNextQtr
		,t3.RevLastYearSalesCurrentYr
		,t3.RevLastYearSalesNextYr
		,t3.RevLastSalesGrowthCurrentQtr
		,t3.RevLastSalesGrowthNextQtr
		,t3.RevLastSalesGrowthCurrentYr
		,t3.RevLastSalesGrowthNextYr
		,t3.RecommendationNumber
		,t3.RecommendationText
		,t3.TargetPriceAnalysts
		,t3.TargetPriceCurrent
		,t3.TargetPriceAverage
		,t3.TargetPriceLow
		,t3.TargetPriceHigh
		,t3.AnalysisCreated
	FROM StockSummaries t1
	LEFT JOIN RankedAnalyses t3 ON t3.StockSummaryId = t1.Id
		AND t3.Rnk = 1
	ORDER BY CASE 
			WHEN t3.Rnk IS NULL
				THEN 1
			ELSE 0
			END
		,CASE 
			WHEN @columnId = 'id'
				AND @sortDesc = 0
				THEN t1.Id
			END ASC
		,CASE 
			WHEN @columnId = 'id'
				AND @sortDesc = 1
				THEN t1.Id
			END DESC
		,CASE 
			WHEN @columnId = 'symbol'
				AND @sortDesc = 0
				THEN t1.Symbol
			END ASC
		,CASE 
			WHEN @columnId = 'symbol'
				AND @sortDesc = 1
				THEN t1.Symbol
			END DESC
		,CASE 
			WHEN @columnId = 'dateLastUpdated'
				AND @sortDesc = 0
				THEN t1.DateLastUpdated
			END ASC
		,CASE 
			WHEN @columnId = 'dateLastUpdated'
				AND @sortDesc = 1
				THEN t1.DateLastUpdated
			END DESC
		,CASE 
			WHEN @columnId = 'name'
				AND @sortDesc = 0
				THEN t1.Name
			END ASC
		,CASE 
			WHEN @columnId = 'name'
				AND @sortDesc = 1
				THEN t1.Name
			END DESC
		,CASE 
			WHEN @columnId = 'previousClose'
				AND @sortDesc = 0
				THEN t1.PreviousClose
			END ASC
		,CASE 
			WHEN @columnId = 'previousClose'
				AND @sortDesc = 1
				THEN t1.PreviousClose
			END DESC
		,CASE 
			WHEN @columnId = 'peRatio'
				AND @sortDesc = 0
				THEN t1.PeRatio
			END ASC
		,CASE 
			WHEN @columnId = 'peRatio'
				AND @sortDesc = 1
				THEN t1.PeRatio
			END DESC
		,CASE 
			WHEN @columnId = 'daysRange'
				AND @sortDesc = 0
				THEN t1.DaysRange
			END ASC
		,CASE 
			WHEN @columnId = 'daysRange'
				AND @sortDesc = 1
				THEN t1.DaysRange
			END DESC
		,CASE 
			WHEN @columnId = 'fiftyTwoWeekRange'
				AND @sortDesc = 0
				THEN t1.FiftyTwoWeekRange
			END ASC
		,CASE 
			WHEN @columnId = 'fiftyTwoWeekRange'
				AND @sortDesc = 1
				THEN t1.FiftyTwoWeekRange
			END DESC
		,CASE 
			WHEN @columnId = 'averageVolume'
				AND @sortDesc = 0
				THEN t1.AverageVolume
			END ASC
		,CASE 
			WHEN @columnId = 'averageVolume'
				AND @sortDesc = 1
				THEN t1.AverageVolume
			END DESC
		,CASE 
			WHEN @columnId = 'marketCap'
				AND @sortDesc = 0
				THEN t1.MarketCap
			END ASC
		,CASE 
			WHEN @columnId = 'marketCap'
				AND @sortDesc = 1
				THEN t1.MarketCap
			END DESC
		,CASE 
			WHEN @columnId = 'earningsPerShare'
				AND @sortDesc = 0
				THEN t1.EarningsPerShare
			END ASC
		,CASE 
			WHEN @columnId = 'earningsPerShare'
				AND @sortDesc = 1
				THEN t1.EarningsPerShare
			END DESC
		,CASE 
			WHEN @columnId = 'forwardDividendYield'
				AND @sortDesc = 0
				THEN t1.ForwardDividendYield
			END ASC
		,CASE 
			WHEN @columnId = 'forwardDividendYield'
				AND @sortDesc = 1
				THEN t1.ForwardDividendYield
			END DESC
		,CASE 
			WHEN @columnId = 'recommendation'
				AND @sortDesc = 0
				THEN t3.RecommendationNumber
			END ASC
		,CASE 
			WHEN @columnId = 'recommendation'
				AND @sortDesc = 1
				THEN t3.RecommendationNumber
			END DESC OFFSET @offsetRows ROWS

	FETCH NEXT @rowsPerPage ROWS ONLY;
END;
GO
/****** Object:  StoredProcedure [dbo].[GetStockSummaryAnalysisCount]    Script Date: 27/08/2024 20:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE
	

 PROCEDURE [dbo].[GetStockSummaryAnalysisCount]
AS
BEGIN
	WITH RankedAnalyses
	AS (
		SELECT *
			,ROW_NUMBER() OVER (
				PARTITION BY StockSummaryId ORDER BY CurrentQtr DESC
				) AS Rnk
		FROM Analyses
		)
	SELECT COUNT(t1.Id) CountStockSummaryAnalyses
	FROM StockSummaries t1
	LEFT JOIN RankedAnalyses t3 ON t3.StockSummaryId = t1.Id
		AND t3.Rnk = 1
END;
GO
