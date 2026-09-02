* ============================================================
* PANEL A DATA: Momentum existence test (Step 1)
* ============================================================
import delimited "wml_results_baseline.csv", clear

keep j k weight mean_monthly t_stat sharpe
reshape wide mean_monthly t_stat sharpe, i(j k) j(weight) string

rename mean_monthlyEW mean_ew
rename mean_monthlyVW mean_vw
rename t_statEW tstat_ew
rename t_statVW tstat_vw
rename sharpeEW sharpe_ew
rename sharpeVW sharpe_vw
sort j k

gen str12 mean_ew_s   = string(mean_ew,   "%9.3f")
gen str12 tstat_ew_s  = string(tstat_ew,  "%9.2f")
gen str12 sharpe_ew_s = string(sharpe_ew, "%9.2f")
gen str12 mean_vw_s   = string(mean_vw,   "%9.3f")
gen str12 tstat_vw_s  = string(tstat_vw,  "%9.2f")
gen str12 sharpe_vw_s = string(sharpe_vw, "%9.2f")

save "panelA_formatted.dta", replace

* ============================================================
* PANEL B DATA: Five-factor regression test (Step 2)
* ============================================================
import delimited "five_factor_regression_results.csv", clear

keep j k weight alpha alpha_t_stat_nw r_squared
reshape wide alpha alpha_t_stat_nw r_squared, i(j k) j(weight) string

rename alphaEW alpha_ew
rename alphaVW alpha_vw
rename alpha_t_stat_nwEW tstat_ew
rename alpha_t_stat_nwVW tstat_vw
rename r_squaredEW r2_ew
rename r_squaredVW r2_vw
sort j k

gen str12 alpha_ew_s = string(alpha_ew, "%9.3f")
gen str12 tstat_ew_s = string(tstat_ew, "%9.2f")
gen str12 r2_ew_s    = string(r2_ew,    "%9.3f")
gen str12 alpha_vw_s = string(alpha_vw, "%9.3f")
gen str12 tstat_vw_s = string(tstat_vw, "%9.2f")
gen str12 r2_vw_s    = string(r2_vw,    "%9.3f")

save "panelB_formatted.dta", replace

* ============================================================
* BUILD THE WORD DOCUMENT -- three-line academic table style
*   Using data()-based table creation for compatibility, then
*   applying border/bold formatting to the already-created table.
* ============================================================
putdocx clear
putdocx begin

putdocx paragraph, style(Title)
putdocx text ("Table 1")

putdocx paragraph
putdocx text ("Momentum Portfolio Performance and Five-Factor Alpha Tests"), bold

* ---------------- Panel A ----------------
putdocx paragraph
putdocx text ("Panel A: Average Excess Returns (Momentum Existence Test)"), italic

use "panelA_formatted.dta", clear
keep j k mean_ew_s tstat_ew_s sharpe_ew_s mean_vw_s tstat_vw_s sharpe_vw_s
rename mean_ew_s   ew_mean
rename tstat_ew_s  ew_tstat
rename sharpe_ew_s ew_sharpe
rename mean_vw_s   vw_mean
rename tstat_vw_s  vw_tstat
rename sharpe_vw_s vw_sharpe

putdocx table tblA = data("j k ew_mean ew_tstat ew_sharpe vw_mean vw_tstat vw_sharpe"), varnames border(all, nil) halign(center)

* bold the header row, add three-line borders
putdocx table tblA(1,.), bold border(top, single) border(bottom, single)
putdocx table tblA(5,.), border(bottom, single)

* ---------------- Panel B ----------------
putdocx paragraph
putdocx text ("Panel B: Five-Factor Alpha (Cannot Fully Explain Momentum)"), italic

use "panelB_formatted.dta", clear
keep j k alpha_ew_s tstat_ew_s r2_ew_s alpha_vw_s tstat_vw_s r2_vw_s
rename alpha_ew_s ew_alpha
rename tstat_ew_s ew_tstat
rename r2_ew_s    ew_r2
rename alpha_vw_s vw_alpha
rename tstat_vw_s vw_tstat
rename r2_vw_s    vw_r2

putdocx table tblB = data("j k ew_alpha ew_tstat ew_r2 vw_alpha vw_tstat vw_r2"), varnames border(all, nil) halign(center)

putdocx table tblB(1,.), bold border(top, single) border(bottom, single)
putdocx table tblB(5,.), border(bottom, single)

* ---------------- Note ----------------
putdocx paragraph
putdocx text ("Note: J = formation period (months); K = holding period (months); EW = equal-weighted, VW = value-weighted. mean = average monthly WML return; tstat = Newey-West adjusted t-statistic; sharpe = annualized Sharpe ratio; alpha = five-factor model intercept (monthly); r2 = regression R-squared."), italic

putdocx save "momentum_report_table_final.docx", replace

