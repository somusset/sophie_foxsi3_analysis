PRO foxsi3_target_summary, total_counts=total_counts, good_events=good_events, bad_events=bad_events, $
 avg_rate_total=avg_rate_total, avg_rate_good=avg_rate_good, loud=loud

;+
; PROJECT
;   FOXSI3 analysis
;   
; DESCRIPTION
;   This procedure is calculating the number of events and average rate in each target, for each HXR detector
;   during the FOXSI3 fligth
;   
; KEYWORDS
;   in:  LOUD, default is 1. When set, some messages and numbers will be printed
;   out: total_counts: number of counts for each detector and each target
;        good_events: number of good events for each detector and each target
;        bad_events: number of bad events for each detector and each target
;        avg_rate_total: average rate of counts for each detector and each target
;        avg_rate_good: average rate of good events for each detector and each target
;        
;  EXAMPLE
;    foxsi,2018
;    foxsi3_target_summary, total_counts=total_counts, good_events=good_events, bad_events=bad_events, avg_rate_total=avg_rate_total, avg_rate_good=avg_rate_good, loud=0
;  
;  HISTORY
;    2018/10/11 - SMusset (UMN) - initial release
;-

; load FOXSI parameters
COMMON FOXSI_PARAM


; define defaults and variables
DEFAULT, loud, 1

tb = tlaunch + [t1_start, t2_start, t3_start, t4_pos0_start, t4_pos1_start]
te = tlaunch + [t1_end  , t2_end,   t3_end,   t4_pos0_end,   t4_pos1_end]
duration = fltarr(5)
FOR k=0,4 DO duration[k] = te[k]-tb[k]
detnum = [0,2,3,4,5,6]
targets = ['1','2','3','4 pos0', '4 pos1']

; initialize output keywords
total_counts   = fltarr(6,5) ; total count per detector and per target
good_events    = fltarr(6,5) ; total good events per detector and per target
bad_events     = fltarr(6,5) ; total bad events per detector and per target
avg_rate_total = fltarr(6,5) ; average total count rate per detector and per target
avg_rate_good  = fltarr(6,5) ; average rate of good events per detector and per target

; enter loop over the detectors
FOR k=0,5 DO BEGIN
  IF k EQ 0 THEN lvl2 = data_lvl2_d0
  IF k EQ 1 THEN lvl2 = data_lvl2_d2
  IF k EQ 2 THEN lvl2 = data_lvl2_d3
  IF k EQ 3 THEN lvl2 = data_lvl2_d4
  IF k EQ 4 THEN lvl2 = data_lvl2_d5
  IF k EQ 5 THEN lvl2 = data_lvl2_d6
  
  IF loud EQ 1 THEN print, 'For detector ', strtrim(detnum[k],2),':'
  
  ; enter loop over targets
  FOR j=0,4 DO BEGIN
    selec = where(lvl2.wsmr_time GT tb[j] AND lvl2.wsmr_time LT te[j] )
    lvl2target = lvl2[selec]
    total_counts[k,j] = n_elements(selec)
    good = where(lvl2target.error_flag EQ 0)
    good_events[k,j] = n_elements(good)
    bad = where(lvl2target.error_flag NE 0)
    bad_events[k,j] = n_elements(bad)
    avg_rate_total[k,j] = n_elements(selec)/duration[j]
    avg_rate_good[k,j] = n_elements(good)/duration[j]
    check = n_elements(selec) - (n_elements(good)+n_elements(bad))
    IF check NE 0 THEN print, 'good + bad NE total for det ', detnum[k], ' and target ', targets[j]
    IF loud EQ 1 THEN BEGIN
      print, 'In target ', targets[j],': ', n_elements(selec), ' counts'
      print, '    with ', n_elements(good), ' good events (', strtrim(round(100.*n_elements(good)/n_elements(selec)),2),'%)
    ENDIF
  ENDFOR
  
  IF loud EQ 1 THEN print, '' 
ENDFOR

END