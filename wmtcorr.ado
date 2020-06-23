* Description: output correlation coefficient matrix to Stata interface, Word as well as LaTeX
* Author: Meiting Wang, Master, School of Economics, South-Central University for Nationalities
* Email: wangmeiting92@gmail.com
* Created on May 8, 2020


program define wmtcorr
version 15.1

syntax [varlist(numeric default=none)] [if] [in] [aw fw iw pw/] [using/] [, ///
	replace append B Bfmt(string) P Pfmt(string) STARAUX NOSTAR ///
	CORR PWCORR TItle(string) Alignment(string) PAGE(string)]


*--------设置默认格式------------
local b_default_fmt "%11.3f"
local p_default_fmt "%11.3f"


*--------输入选项不合规的报错信息-------
if ("`replace'`append'"!="")&("`using'"=="") {
	dis "{error:replace or append can't appear when you don't need to output result to a file.}"
	exit
}

if ("`replace'"!="")&("`append'"!="") {
	dis "{error:replace and append cannot appear at the same time.}"
	exit
}

if ("`staraux'"!="")&("`p'`pfmt'"=="") {
	dis "{error:staraux not allowed if no p-value reported.}"
	exit
}

if ("`staraux'"!="")&("`nostar'"!="") {
	dis "{error:staraux and nostar cannot appear at the same time.}"
	exit
}

if ("`corr'"!="")&("`pwcorr'"!="") {
	dis "{error:corr and pwcorr cannot appear at the same time.}"
	exit
}

if (~ustrregexm("`using'",".tex"))&("`alignment'`page'"!="") { 
	dis "{error:alignment and page can only be used in the LaTeX output.}"
	exit
}


*---------前期语句处理----------
*普通选项语句的处理
if "`varlist'" == "" {
	cap drop _est*
	qui ds, has(type numeric)
	local varlist "`r(varlist)'"
} //如果没有设定变量，则自动导入所有的数值变量。
if "`weight'" != "" {
	local weight "[`weight'=`exp']"
}
if "`using'" != "" {
	local us_ing "using `using'"
}
if "`title'" == "" {
	local title "Correlation coefficient matrix"
}

*b、p选项语句构建
if ustrregexm("`bfmt'", "\d") {
	local st_bp "b(`bfmt') "
}
else {
	local st_bp "b(`b_default_fmt') "
}
if ustrregexm("`pfmt'", "\d") {
	local st_bp "`st_bp'p(`pfmt') "
}
else if "`p'" == "p" {
	local st_bp "`st_bp'p(`p_default_fmt') "
}
local st_bp = ustrtrim("`st_bp'")

*corr、pwcorr语句构建
if "`corr'" != "" {
	local st_cp "listwise"
}
else if "`pwcorr'" != "" {
	local st_cp ""
}
else {
	local st_cp "listwise" //默认值
}

*star语句构建
if "`nostar'" != "" {
	local st_star "`nostar'"
}
else if "`staraux'" != "" {
	local st_star "`staraux' star(* 0.1 ** 0.05 *** 0.01)"
}
else {
	local st_star "star(* 0.1 ** 0.05 *** 0.01)"
}

*构建esttab中alignment()和page()内部的语句(LaTeX输出专属)
if "`alignment'" == "" {
	local alignment "math"
} //设置默认的alignment

if "`page'" != "" {
	local page ",`page'"
}

if "`alignment'" == "math" {
	local page "array`page'"
	local alignment ">{$}c<{$}"
}
else {
	local page "array,dcolumn`page'"
	local alignment "D{.}{.}{-1}"
}


*---------------------主程序-----------------------------
eststo clear
qui estpost correlate `varlist' `if' `in' `weight', matrix `st_cp'
esttab, compress ///
	unstack not noobs nogaps nomti nonum ///
	`st_star' `st_bp' title(`title')  //Stata 界面显示
if ustrregexm("`us_ing'",".rtf") {
	esttab `us_ing', compress `replace'`append' ///
		unstack not noobs nogaps nomti nonum ///
		`st_star' `st_bp' title(`title')
} //Word 显示
if ustrregexm("`us_ing'",".tex") { 
	preserve
	tokenize "`varlist'"
	local i = 1
	local st_coeflabels ""
	while "``i''" != ""{
		label var ``i'' "\multicolumn{1}{c}{``i''}"
		local st_coeflabels "`st_coeflabels'``i'' ``i++'' "
	}
	esttab `us_ing', compress `replace'`append' ///
		unstack not noobs nogaps nomti nonum ///
		`st_star' `st_bp' title(`title')  ///
		booktabs width(\hsize) label ///
		coeflabels(`st_coeflabels') page(`page')  alignment(`alignment')
	restore
} //LaTeX 显示
end
