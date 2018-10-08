PRO foxsi3_error_flag_time_evolution, data, tlaunch, ground=ground, year=year, binsize=binsize, charsize=charsize, thick=thick

; +
;     DESCRIPTION
; this function analyze the time evolution of the error flag in a foxsi file.
;
;     INPUT
; data      IDL FOXSI data structure for one detector
; 
;     KEYWORDS
; ground    Set to 1 if the data is made with no WSMR_TIME stamp in the IDL data file
; year      USEFUL ONLY IF GROUND IS SET. Set to the year if not foxsi3 flight data. Default is 2018
; binsize   Default is 20sec. This is for the lightcurves / time bins
; 
;     EXAMPLE
; foxsi3_error_flag_time_evolution, data_lvl2_d0, /ground
;-

  ;----------------;
  ; initialization ;
  ;----------------;
  
  DEFAULT, ground, 0
  DEFAULT, year, 2018
  DEFAULT, binsize, 20
  DEFAULT, charsize, 2
  DEFAULT, thick, 3
  
  IF ground EQ 1 THEN BEGIN
    IF year EQ 2018 THEN tl_sec = 48617.74 ELSE print, 'time of the launch is not known'
    data.wsmr_time = 2.*data.frame_counter /1000. + tl_sec ; in seconds
  ENDIF

  detnum = data[0].det_num
  nevents = n_elements(data)
  flags = bytarr(nevents,7)
  
  ;--------------------;
  ; create lightcurves ;
  ;--------------------;
  
  ; selection good data
  good = where(data.error_flag EQ 0)
  ; initialize time with t=0 for launch
  time_all = data.wsmr_time - tlaunch
  time_lightcurve = data[good].wsmr_time - tlaunch
  ; create histogram
  all_counts  = histogram(time_all, locations=locall, binsize=binsize)
  good_counts = histogram(time_lightcurve, locations=loclightcurve, binsize=binsize)
  
  ;------------------;
  ; read error flags ;
  ;------------------;

  FOR k=0, nevents-1 DO BEGIN
      decflag = FIX(data[k].error_flag)
      dec2bin, decflag, bin, /quiet
      binflag = reverse(bin)
      flags[k,*] = binflag[0:6]
  ENDFOR

  time0 = data[where(flags[*,0] EQ 1)].wsmr_time - tlaunch
  flag0 = histogram(time0, locations=loc0, binsize=binsize)
  time1 = data[where(flags[*,1] EQ 1)].wsmr_time - tlaunch
  flag1 = histogram(time1, locations=loc1, binsize=binsize)
  time2 = data[where(flags[*,2] EQ 1)].wsmr_time - tlaunch
  flag2 = histogram(time2, locations=loc2, binsize=binsize)
  ;time3 = data[where(flags[*,3] EQ 1)].wsmr_time - tlaunch
  ;flag3 = histogram(time3, locations=loc3, binsize=binsize)
  flag3=[0]
  time4 = data[where(flags[*,4] EQ 1)].wsmr_time - tlaunch
  flag4 = histogram(time4, locations=loc4, binsize=binsize)
  time5 = data[where(flags[*,5] EQ 1)].wsmr_time - tlaunch
  flag5 = histogram(time5, locations=loc5, binsize=binsize)
  time6 = data[where(flags[*,6] EQ 1)].wsmr_time - tlaunch
  flag6 = histogram(time5, locations=loc6, binsize=binsize)

  ;--------------;
  ; plot results ;
  ;--------------;
  
  maxflag = max([flag0,flag1,flag2,flag3,flag4,flag5,flag6])
  minflag = min([flag0,flag1,flag2,flag3,flag4,flag5,flag6])
  yr = [minflag, maxflag]
  yrn = minmax([yr, good_counts, all_counts]) 
  
  sophie_linecolors
  colorss = [2,3,5,7,8,10,12 ]
  plot, loc0, flag0, psym=10, chars=charsize, charth=thick, xth=thick, yth=thick, th=thick, background=1, color=0, yr=yrn, $
    title='FOXSI 3 detector '+strtrim(detnum,2), xtitle='Time after launch (seconds)';, ystyle=8, ytitle='error flags'
  oplot, loc0, flag0, psym=10, th=thick, color=colorss[0]
  oplot, loc1, flag1, psym=10, th=thick, color=colorss[1]
  oplot, loc2, flag2, psym=10, th=thick, color=colorss[2]
  ;oplot, loc3, flag3, psym=10, th=thick, color=8
  oplot, loc4, flag4, psym=10, th=thick, color=colorss[4]
  oplot, loc5, flag5, psym=10, th=thick, color=colorss[5]
  oplot, loc6, flag6, psym=10, th=thick, color=colorss[6]
  
 ; yrn = minmax([good_counts, all_counts]) 
 ; AXIS, YAXIS=1, YR=YRN, YTITLE='FOXSI lightcurves', CHARTHICK=THICK, yth=thick, charsize = charsize, /save
  oplot, loclightcurve, good_counts, psym=10, th=2*thick, color=0
  oplot, locall, all_counts, psym=10, th=2*thick, color=14
  al_legend, ['good counts', 'all counts', 'flag 0', 'flag 1', 'flag 2', 'flag 3', 'flag 4', 'flag 5', 'flag 6'], textcolors=[0,14,colorss], box=0, charsize=charsize, thick=thick, charthick=thick
  
  write_png, 'foxsi3_errorflags_d'+strtrim(detnum,2)+'_time_evolution.png', tvrd(/true) 
  
END