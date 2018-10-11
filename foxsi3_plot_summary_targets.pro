PRO foxsi3_plot_summary_targets, saveplots = saveplots, dir=dir

;+
; DESCRIPTION
;   This procedure plot the scatter plot and linear regression between values such as average rate of counts and percentage of good events
;   
; KEYWORDS
;   saveplots: set to 1 to save plots in png format. Default is 0
;   dir: give the path to the directory in which to save the plots. Default is current.
;   
; CALLS
;   foxsi3_target_summary
;   
; EXAMPLE
;   foxsi,2018
;   foxsi3_plot_summary_targets, /saveplots, dir='C:\Users\SMusset\Documents\GitHub\FOXSI3-analysis\'
; HISTORY
;-

  cd, current=current
  DEFAULT, saveplots, 0
  DEFAULT, dir, current

  sophie_linecolors
  cs = 2
  th=3
  xr=[-10,510]

  foxsi3_target_summary, total_counts=total_counts, good_events=good_events, bad_events=bad_events, avg_rate_total=avg_rate_total, avg_rate_good=avg_rate_good, loud=0
  
  avg_rate_total_1d = [reform(avg_rate_total[*,0]),reform(avg_rate_total[*,1]), reform(avg_rate_total[*,2]),reform(avg_rate_total[*,3]),reform(avg_rate_total[*,4])]
  avg_rate_good_1d = [reform(avg_rate_good[*,0]),reform(avg_rate_good[*,1]), reform(avg_rate_good[*,2]),reform(avg_rate_good[*,3]),reform(avg_rate_good[*,4])]
  good_events_1d = [reform(good_events[*,0]),reform(good_events[*,1]), reform(good_events[*,2]),reform(good_events[*,3]),reform(good_events[*,4])]
  total_counts_1d = [reform(total_counts[*,0]),reform(total_counts[*,1]), reform(total_counts[*,2]),reform(total_counts[*,3]),reform(total_counts[*,4])]
  
  res = regress(avg_rate_total_1d, avg_rate_good_1d, correlation=correlation, const=const, sigma=sigma, yfit=yfit, ftest=ftest, status=status )
  
  window, 0, xsize=1000, ysize=800
  plot, avg_rate_total_1d, yfit, xtitle='rate of total events', ytitle='rate of good events', xr=xr, /xstyle, chars=cs, thick=th, xth=th, yth=th, charth=th, background=1, color=0
  oplot, avg_rate_total_1d, avg_rate_good_1d, psym=4, symsize=cs, thick=2*th, color=3
  al_legend, ['correlation '+strtrim(correlation,2), 'slope coefficient '+strtrim(res[0],2)], chars=cs, charthick=th, box=0
  IF saveplots EQ 1 THEN write_png, dir+'foxsi3_totalrate_vs_goodrate.png' , tvrd(/true)
  
  good100 = good_events_1d/total_counts_1d*100.
  res = regress(avg_rate_total_1d, good100, correlation=correlation, const=const, sigma=sigma, yfit=yfit, ftest=ftest, status=status )
 
  window, 1, xsize=1000, ysize=800
  plot, avg_rate_total_1d, yfit, xtitle='rate of total events', ytitle='percentage of good events', xr=xr, /xstyle, chars=cs, thick=th, xth=th, yth=th, charth=th, background=1, color=0
  oplot, avg_rate_total_1d, good100, psym=4, symsize=cs, thick=2*th, color=3
  al_legend, ['correlation '+strtrim(correlation,2), 'slope coefficient '+strtrim(res[0],2)], chars=cs, charthick=th, box=0
  IF saveplots EQ 1 THEN write_png, dir+'foxsi3_totalrate_vs_goodper100.png' , tvrd(/true)

  res = regress(avg_rate_good_1d, good100, correlation=correlation, const=const, sigma=sigma, yfit=yfit, ftest=ftest, status=status )

  window, 2, xsize=1000, ysize=800
  xr=[-10,400]
  plot, avg_rate_good_1d, yfit, xtitle='rate of good events', ytitle='percentage of good events', xr=xr, /xstyle, chars=cs, thick=th, xth=th, yth=th, charth=th, background=1, color=0
  oplot, avg_rate_good_1d, good100, psym=4, symsize=cs, thick=2*th, color=3
  al_legend, ['correlation '+strtrim(correlation,2), 'slope coefficient '+strtrim(res[0],2)], chars=cs, charthick=th, box=0
  IF saveplots EQ 1 THEN write_png, dir+'foxsi3_goodrate_vs_goodper100.png' , tvrd(/true)
  
  window, 3, xsize=1200, ysize=800
  targets = indgen(5)+1
  yr=minmax(total_counts)
  plot, targets, total_counts[0,*], psym=10, xtitle='targets', ytitle='total number of events', xr=[0,6], /xstyle, yr=yr, /ylog, chars=cs, thick=th, xth=th, yth=th, charth=th, background=1, color=0
  col = [3,5,8,10,13,17]
  FOR k=0,5 DO oplot, targets, total_counts[k,*], psym=10, color=col[k], thick=th*2
  al_legend, ['D0','D2','D3','D4','D5','D6'], chars=cs, charth=th, textcolor=col, box=0
  IF saveplots EQ 1 THEN write_png, dir+'foxsi3_totalevents_vs_target.png' , tvrd(/true)

  window, 4, xsize=1200, ysize=800
  targets = indgen(5)+1
  yr=minmax(avg_rate_total)
  plot, targets, avg_rate_total[0,*], psym=10, xtitle='targets', ytitle='average rate of events (/s)', xr=[0,6], /xstyle, yr=yr, /ylog, chars=cs, thick=th, xth=th, yth=th, charth=th, background=1, color=0
  col = [3,5,8,10,13,17]
  FOR k=0,5 DO oplot, targets, avg_rate_total[k,*], psym=10, color=col[k], thick=th*2
  al_legend, ['D0','D2','D3','D4','D5','D6'], chars=cs, charth=th, textcolor=col, box=0
  IF saveplots EQ 1 THEN write_png, dir+'foxsi3_eventrate_vs_target.png' , tvrd(/true)

  window, 5, xsize=1200, ysize=800
  targets = indgen(5)+1
  yr=minmax(avg_rate_good)
  plot, targets, avg_rate_good[0,*], psym=10, xtitle='targets', ytitle='average rate of good events (/s)', xr=[0,6], /xstyle, yr=yr, /ylog, chars=cs, thick=th, xth=th, yth=th, charth=th, background=1, color=0
  col = [3,5,8,10,13,17]
  FOR k=0,5 DO oplot, targets, avg_rate_good[k,*], psym=10, color=col[k], thick=th*2
  al_legend, ['D0','D2','D3','D4','D5','D6'], chars=cs, charth=th, textcolor=col, box=0
  IF saveplots EQ 1 THEN write_png, dir+'foxsi3_goodeventrate_vs_target.png' , tvrd(/true)


END