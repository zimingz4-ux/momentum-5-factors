# momentum-5-factors
# Momentum Strategy: Existence and Five-Factor Explanation

This project tests (1) whether a classic price momentum strategy (Winner-Minus-Loser, WML) generates significant returns in a recent U.S. equity sample, and (2) whether the Fama-French five-factor model can fully explain those returns.

## 1. Data Collection

- **Source:** CRSP Monthly Stock File, accessed via WRDS (CIZ format)
- **Sample period:** January 2016 – December 2025 (~10 years)
- **Universe filters:**
  - Common stock only (`sharetype == "NS"`)
  - Listed on NYSE, AMEX, or NASDAQ (`primaryexch` in `{N, A, Q}`)
  - Price ≥ $5
  - Excludes micro-cap stocks below the NYSE 20th percentile market cap breakpoint (recomputed monthly)
- **Factor data:** Fama-French five factors (Mkt-RF, SMB, HML, RMW, CMA) and the risk-free rate, from Ken French's Data Library

Raw data was cleaned by removing exact duplicate rows and rows with conflicting `(permno, month)` records, then reindexed to a continuous monthly calendar per stock so that rolling return calculations are never distorted by missing months.

## 2. Two-Stage Design

**Stage 1 — Does momentum exist?**
For formation periods J ∈ {3, 6} months and holding periods K ∈ {3, 6} months (1-month skip between formation and holding), stocks are ranked each month by past J-month cumulative return. The top and bottom deciles form the Winner and Loser portfolios. Both equal-weighted (EW) and value-weighted (VW) WML portfolios are built, using overlapping K-month holding periods. Significance is assessed via monthly return t-statistics and Sharpe ratios.

**Stage 2 — Can the five-factor model explain it?**
Each WML return series is regressed on the five Fama-French factors:

```
WML_t = α + β1(Mkt-RF)_t + β2(SMB)_t + β3(HML)_t + β4(RMW)_t + β5(CMA)_t + ε_t
```

A statistically significant intercept (α) indicates the five factors cannot fully account for momentum returns. Newey-West standard errors are used to account for potential autocorrelation.

## 3. Conclusion

- **Momentum exists:** WML portfolios show positive, mostly statistically significant average returns across J/K combinations, consistent with the classic momentum anomaly.
- **The five-factor model does not fully explain it:** Alpha is significant at the 5% level in most J/K/weighting combinations. The exception is the J=6, K=6, value-weighted specification, where significance weakens — suggesting the five factors explain momentum somewhat better over longer holding periods and among larger-cap stocks.
- **Low explanatory power overall:** R² values range from roughly 0.14 to 0.28, indicating the five factors capture only a modest share of WML's month-to-month variation, even where alpha is not statistically distinguishable from zero.

Together, these results support the view that momentum is a return pattern largely independent of the standard five-factor risk model.
