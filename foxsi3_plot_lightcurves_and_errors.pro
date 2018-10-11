PRO foxsi3_plot_lightcurves_and_errors, lc, detnum, saveplots=saveplots, dir=dir

;+
; DESCRIPTION
;   This procedure takes a FOXSI lightcurve calculated with the function FOXSI_LC and plot the lightcurve with error bars in color shadow,
;   in linear and log scale
;   
; INPUTS
;   lc: the lightcurve (result of the foxsi_lc function)
;   detnum: the detector number
;   
; KEYWORDS
;   saveplots: set to 1 to save png plots. Default is 0
;   dir: path to the directory where to save the plots. Default is current directory
;   
; CALLS
;   sophie_linecolors
;   
; EXAMPLE
;   foxsi, 2018
;   lc0 = foxsi_lc(data_lvl2_d0, dt=10, year=2018)
;   foxsi3_plot_lightcurves_and_errors, lc0, 0
;   
; HISTORY
;   2018/10/11 - SMusset (UMN) - initial release
;   
; TBD
;   add extra keyword to be able to choose energy range and only good events - this should be included in the name of the plot
;-

COMMON FOXSI_PARAM

; define default
cd, current=current
DEFAULT, saveplots, 0
DEFAULT, dir, current
cs = 3
th = 4

; find the time bin
nlc = n_elements(lc)
dt = lc[1].time - lc[0].time

tb = anytim(t0) + [t1_start, t2_start, t3_start, t4_pos0_start, t4_pos1_start]
te = anytim(t0) + [t1_end, t2_end, t3_end, t4_pos0_end, t4_pos1_end]

timedouble = DBLARR(2*nlc)
lcdouble = DBLARR(2*nlc)

FOR k=0, nlc-1 DO BEGIN
  timedouble[2*k] = lc[k].time - dt/2.
  timedouble[2*k+1] = lc[k].time + dt/2.
  lcdouble[2*k] = lc[k].persec
  lcdouble[2*k+1] = lc[k].persec
ENDFOR

sophie_linecolors
default, ymin, min(lcdouble-sqrt(lcdouble))-0.1
default, ymax, max(lcdouble+sqrt(lcdouble))+0.1

xrange = minmax(timedouble) - timedouble[0]
utplot, anytim(timedouble,/yo), lcdouble, background=1, color=0, xth=th, yth=th, charth=th, chars=cs, /ylog, yr=[0.01,ymax], xsty=1, title='FOXSI 3 Detector '+strtrim(detnum, 2), ytitle='Event rate (sec-1)'
outyr = !y.crange
yr = [10.^outyr[0], 10.^outyr[1]]
FOR k=0,4 DO outplot, anytim([tb[k],tb[k]],/yo), yr, th=th, linestyle=0, col=0
FOR k=0,4 DO outplot, anytim([te[k],te[k]],/yo), yr, th=th, linestyle=1, col=0
axis, xaxis=1, xr=xrange, /save, xsty=1;, xth=2, color=0
polyfill, [timedouble[0], timedouble, timedouble[2*nlc-1]]-timedouble[0],   [0, lcdouble+sqrt(lcdouble)/2., 0], col=6
polyfill, [timedouble[0], timedouble, timedouble[2*nlc-1]]-timedouble[0],   [0, lcdouble-sqrt(lcdouble)/2., 0], col=1
oplot, timedouble-timedouble[0], lcdouble, color=0, thick=th+1
; replot the original axis
utplot, anytim(timedouble,/yo), lcdouble, background=1, color=0, xth=th, yth=th, charth=th, chars=cs, /ylog, yr=[0.01,ymax], xsty=1, /nodata, /noerase

IF SAVEPLOTS EQ 1 THEN write_png, DIR+'foxsi3_lightcurve_d'+strtrim(detnum,2)+'_'+strtrim(round(dt),2)+'_sec_logscale.png', tvrd(/true)


utplot, anytim(timedouble,/yo), lcdouble, background=1, color=0, xth=th, yth=th, charth=th, chars=cs, yr=[ymin,ymax], xsty=1, title='FOXSI 3 Detector '+strtrim(detnum, 2), ytitle='Event rate (sec-1)'
outyr = !y.crange
FOR k=0,4 DO outplot, anytim([tb[k],tb[k]],/yo), outyr, th=th, linestyle=0, col=0
FOR k=0,4 DO outplot, anytim([te[k],te[k]],/yo), outyr, th=th, linestyle=1, col=0
axis, xaxis=1, xr=xrange, /save, xsty=1;, xth=2, color=0
polyfill, [timedouble[0], timedouble, timedouble[2*nlc-1]]-timedouble[0],   [0, lcdouble+sqrt(lcdouble)/2., 0], col=6
polyfill, [timedouble[0], timedouble, timedouble[2*nlc-1]]-timedouble[0],   [0, lcdouble-sqrt(lcdouble)/2., 0], col=1
oplot, timedouble-timedouble[0], lcdouble, color=0, thick=th+1
; replot the original axis
utplot, anytim(timedouble,/yo), lcdouble, background=1, color=0, xth=th, yth=th, charth=th, chars=cs, yr=[ymin,ymax], xsty=1, /nodata, /noerase

IF SAVEPLOTS EQ 1 THEN write_png, DIR+'foxsi3_lightcurve_d'+strtrim(detnum,2)+'_'+strtrim(round(dt),2)+'_sec.png', tvrd(/true)


END