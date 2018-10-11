PRO foxsi3_produce_lightcurves, dt, dir=dir, er=er

;+
; DESCRIPTION
;   This is a wrapper that plots all the lightcurves for the foxsi3 flight (HXR detectors) with a given bin size dt
;   
; INPUT
;   dt: time bin size in seconds
;   
; KEYWORDS
;   dir: path to the directory where the plots are saved. Default is current directory
;   er: array of two values. Energy range for the lightcurves  
;   
; CALLS
;   foxsi_lc
;   foxsi3_plot_lightcurves_and_errors
;   
; EXAMPLE
;   foxsi,2018
;   foxsi3_produce_lightcurves, 8, dir='C:\Users\SMusset\Documents\GitHub\FOXSI3-analysis\'
;   
; HISTORY
;   2018/10/11 - SMusset (UMN) - Initial release
;   
; TBD:
;   add extra keyword to be able to choose energy range and only good events
;-

COMMON FOXSI_PARAM

cd, current=current
DEFAULT, dir, current

lc0 = foxsi_lc(data_lvl2_d0, dt=dt, year=2018)
lc2 = foxsi_lc(data_lvl2_d2, dt=dt, year=2018)
lc3 = foxsi_lc(data_lvl2_d3, dt=dt, year=2018)
lc4 = foxsi_lc(data_lvl2_d4, dt=dt, year=2018)
lc5 = foxsi_lc(data_lvl2_d5, dt=dt, year=2018)
lc6 = foxsi_lc(data_lvl2_d6, dt=dt, year=2018)

foxsi3_plot_lightcurves_and_errors, lc0, 0, /saveplots, dir=dir
foxsi3_plot_lightcurves_and_errors, lc2, 2, /saveplots, dir=dir
foxsi3_plot_lightcurves_and_errors, lc3, 3, /saveplots, dir=dir
foxsi3_plot_lightcurves_and_errors, lc4, 4, /saveplots, dir=dir
foxsi3_plot_lightcurves_and_errors, lc5, 5, /saveplots, dir=dir
foxsi3_plot_lightcurves_and_errors, lc6, 6, /saveplots, dir=dir

END