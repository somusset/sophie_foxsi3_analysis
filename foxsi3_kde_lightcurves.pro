FUNCTION foxsi3_kde, lvl2, sample=sample, nsa=nsa, _extra=_extra

  ;+
  ; DESCRIPTION
  ;   This function returns the density of events over time for a given level2 FOXSI3 data file
  ;   
  ; INPUT
  ;   lvl2: level2 data file
  ;   
  ; KEYWORD
  ;   in: nsa: number of points where the density is sampled
  ;   out: sample: time corresponding at the location where the density is sampled
  ;   
  ; CALLS
  ;   kde.pro
  ;   
  ; EXAMPLE
  ;   foxsi, 2018
  ;   kde0 = foxsi3_kde(data_lvl2_d0, sample=sample0, /gauss)
  ;   
  ; HISTORY
  ;   2018/10/11 - SMusset (UMN) - Initial release
  ;   
  ; TBD:
  ;   add extra keyword to be able to choose energy range and only good events
  ;-
  
  COMMON foxsi_param
  
  DEFAULT, nsa, 500.
  print, nsa
  distance = lvl2.wsmr_time - lvl2[0].wsmr_time
  distmax = max(distance)
  
  array = [-1.*reverse(distance), distance[1:n_elements(distance)-2], distmax*2+reverse(distance)]
  
  sample = indgen(nsa)/nsa*distmax
  density = kde(array, sample, _extra=_extra)
  
  sample = sample + lvl2[0].wsmr_time - tlaunch
  
  RETURN, density
END


PRO foxsi3_kde_lightcurves, saveplot=saveplot, dir=dir, _extra=_extra

  ;+
  ; DESCRIPTION
  ;   This procedure plots the density distribution of the events for all detectors
  ;   
  ; KEYWORD
  ;   saveplot: set to save plot in png form
  ;   dir: path to the directory where to save the plot
  ;   
  ; CALLS
  ;   foxsi3_kde.pro
  ;   kde.pro
  ;   sophie_linecolors.pro
  ;   
  ; EXAMPLE
  ;   foxsi, 2018
  ;   foxsi3_kde_lightcurves, nsa=20., /trian
  ; 
  ; HISTORY
  ;   2018/10/11 - SMusset (UMN) - Initial release
  ;-

  COMMON foxsi_param

  cd, current=current
  DEFAULT, saveplot, 0
  DEFAULT, dir, current
  cs=2.2
  th=4
  tb = anytim(t0) + [t1_start, t2_start, t3_start, t4_pos0_start, t4_pos1_start]
  te = anytim(t0) + [t1_end, t2_end, t3_end, t4_pos0_end, t4_pos1_end]


  kde0 = foxsi3_kde(data_lvl2_d0, sample=sample0, _extra=_extra)
  kde2 = foxsi3_kde(data_lvl2_d2, sample=sample2, _extra=_extra)
  kde3 = foxsi3_kde(data_lvl2_d3, sample=sample3, _extra=_extra)
  kde4 = foxsi3_kde(data_lvl2_d4, sample=sample4, _extra=_extra)
  kde5 = foxsi3_kde(data_lvl2_d5, sample=sample5, _extra=_extra)
  kde6 = foxsi3_kde(data_lvl2_d6, sample=sample6, _extra=_extra)

  yr = minmax([kde0, kde2, kde3, kde4, kde5, kde6])
  col = [3,5,8,10,13,17]

  window, xs=1200, ys=800
  utplot, anytim( anytim(t0)+sample0, /yo), kde0, yr=yr, chars=cs, thick=th, xth=th, yth=th, charth=th, background=1, color=0, ytitle='density estimate'
  al_legend, ['D0','D2','D3','D4','D5','D6'], chars=cs, charth=th, textcolor=col, box=0
  outyr = !y.crange
  FOR k=0,4 DO outplot, anytim([tb[k],tb[k]],/yo), outyr, th=th, linestyle=0, col=0
  FOR k=0,4 DO outplot, anytim([te[k],te[k]],/yo), outyr, th=th, linestyle=1, col=0
  outplot, anytim( anytim(t0)+sample0, /yo), kde0, thick=2*th, col=col[0], linestyle=0
  outplot, anytim( anytim(t0)+sample2, /yo), kde2, thick=2*th, col=col[1], linestyle=0
  outplot, anytim( anytim(t0)+sample3, /yo), kde3, thick=2*th, col=col[2], linestyle=0
  outplot, anytim( anytim(t0)+sample4, /yo), kde4, thick=2*th, col=col[3], linestyle=0
  outplot, anytim( anytim(t0)+sample5, /yo), kde5, thick=2*th, col=col[4], linestyle=0
  outplot, anytim( anytim(t0)+sample6, /yo), kde6, thick=2*th, col=col[5], linestyle=0
  ;al_legend, ['D0','D2','D3','D4','D5','D6'], chars=cs, charth=th, textcolor=col, box=0
  IF saveplot EQ 1 THEN write_png, dir+'foxsi3_kde.png' , tvrd(/true)

  
END