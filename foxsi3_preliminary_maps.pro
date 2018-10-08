PRO foxsi3_preliminary_maps

  f = 'data_180907_111001'
  dir = 'C:\Users\SMusset\Documents\RESEARCH\FOXSI\Calibration_and_Flight_activities\Lab_and_calibration\Calibration data and plots\wsmr\20180907\'

  cd ,'C:\Users\SMusset\Documents\RESEARCH\FOXSI\Science_Analysis\foxsi-science\parameters\'
  stop
 ; @param2018_20181003
  cd, dir
  restore, f+'_lvl2_si_ground.sav'

  detnum = ['0', '2', '4', '6']
  pos = [[cen1_pos0], [cen2_pos0], [cen3_pos0], [cen4_pos0], [cen4_pos1]]
  tb = [t1_start, t2_start, t3_start, t4_pos0_start, t4_pos1_start]
  te = [t1_end, t2_end, t3_end, t4_pos0_end, t4_pos1_end]
  target = ['1','2','3','4','4bis']
  ct = colortable(2,/reverse)
  
  FOR k=0, n_elements(detnum)-1 DO BEGIN
      if detnum[k] eq 0 then lvl2 = data_lvl2_D0
      if detnum[k] eq 2 then lvl2 = data_lvl2_D2
      if detnum[k] eq 3 then lvl2 = data_lvl2_D3
      if detnum[k] eq 4 then lvl2 = data_lvl2_D4
      if detnum[k] eq 5 then lvl2 = data_lvl2_D5
      if detnum[k] eq 6 then lvl2 = data_lvl2_D6

      lvl2.wsmr_time = 2.*lvl2.frame_counter /1000. + 48617.74 ; in seconds
      
      FOR j=0, n_elements(tb)-1 DO BEGIN
        map = foxsi_image_map( lvl2, pos[*,j], trange=[ tb[j], te[j] ], erange=[0,80] )
        window, xsize=1000, ysize=1000
        plot_map, map, /limb, chars=2, charth=3, red=reform(ct[*,0]), green=reform(ct[*,1]), blue=reform(ct[*,2]),/log, xth=3, yth=3, lth=2
        write_png,'foxsi3_image_target_'+target[j]+'_D'+detnum[k]+'_.png',tvrd(/true)
        map2fits, map, 'foxsi3_t'+target[j]+'_D'+detnum[k]+'.fits'
        stop
      ENDFOR

  ENDFOR

END