* ============================================================
* FIGURE 1: Momentum existence (Panel A / Step 1)
*   Average monthly WML return, 95% CI, colored by significance
* ============================================================
import delimited "wml_results_baseline.csv", clear

gen combo = "J" + string(j) + "K" + string(k) + " " + weight
encode combo, gen(combo_id)

* recover SE from t-stat: t = mean / SE  ->  SE = mean / t
gen se_mean = mean_monthly / t_stat
gen ci_low  = mean_monthly - 1.96*se_mean
gen ci_high = mean_monthly + 1.96*se_mean
gen sig = abs(t_stat) > 1.96

twoway ///
    (rcap ci_low ci_high combo_id, lcolor(gs8)) ///
    (scatter mean_monthly combo_id if sig==1, mcolor(red) msymbol(D) msize(medium)) ///
    (scatter mean_monthly combo_id if sig==0, mcolor(gs8) msymbol(O) msize(medium)) ///
    , xlabel(1/8, valuelabel angle(45)) ///
      yline(0, lpattern(dash) lcolor(black)) ///
      ytitle("Average Monthly WML Return") ///
      xtitle("") ///
      title("Figure 1. Momentum Strategy: Average Excess Returns") ///
      subtitle("95% CI, Newey-West SE. Red = significant at 5% level") ///
      legend(order(2 "Significant (p<0.05)" 3 "Not significant") ///
             position(6) rows(1)) ///
      scheme(s1mono)

graph export "figure1_momentum_existence.png", replace width(1600) height(1000)

* ============================================================
* FIGURE 2: Five-factor alpha (Panel B / Step 2)
*   Same coefficient-plot style as Figure 1, for consistency
* ============================================================
import delimited "five_factor_regression_results.csv", clear

gen combo = "J" + string(j) + "K" + string(k) + " " + weight
encode combo, gen(combo_id)

gen se_alpha = alpha / alpha_t_stat_nw
gen ci_low  = alpha - 1.96*se_alpha
gen ci_high = alpha + 1.96*se_alpha
gen sig = abs(alpha_t_stat_nw) > 1.96

twoway ///
    (rcap ci_low ci_high combo_id, lcolor(gs8)) ///
    (scatter alpha combo_id if sig==1, mcolor(red) msymbol(D) msize(medium)) ///
    (scatter alpha combo_id if sig==0, mcolor(gs8) msymbol(O) msize(medium)) ///
    , xlabel(1/8, valuelabel angle(45)) ///
      yline(0, lpattern(dash) lcolor(black)) ///
      ytitle("Estimated Alpha (Monthly)") ///
      xtitle("") ///
      title("Figure 2. Five-Factor Model Cannot Fully Explain Momentum") ///
      subtitle("95% CI, Newey-West SE. Red = significant at 5% level") ///
      legend(order(2 "Significant (p<0.05)" 3 "Not significant") ///
             position(6) rows(1)) ///
      scheme(s1mono)

graph export "figure2_five_factor_alpha.png", replace width(1600) height(1000)

* ============================================================
* FIGURE 3: R-squared -- how much of WML variance the five
*   factors actually capture (separate from whether alpha=0)
* ============================================================
graph bar r_squared, over(combo, sort(r_squared) label(angle(45))) ///
    ytitle("R-squared") ///
    title("Figure 3. Five-Factor Model: Explained Variance of WML") ///
    subtitle("Low R-squared indicates momentum is largely unrelated to the five factors") ///
    scheme(s1mono) ///
    bar(1, color(gs8))

graph export "figure3_r_squared.png", replace width(1600) height(1000)
