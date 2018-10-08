PRO foxsi3_det6_selection_tests

  f = 'data_180907_111001'

  restore, f+'_lvl1_allframes.sav'
  foxsi3_lvl1_image, data_lvl1_D6, 6, [367917,390593],im, pay=1, phys=0, plot_im=1, title=', target 1'
  
  xtot = fltarr(128)
  ytot = fltarr(128)
  FOR i=0,127 DO BEGIN
    xtot[i] = total(im[*,i])
    ytot[i] = total(im[i,*])
  ENDFOR
  
  ;PLOT, xtot, chars=2, psym=10
  PLOT, indgen(128), ytot, chars=2, psym=10, xr=[-1,128], /xstyle, yr=[0,1000]

  selection = where(ytot gt 5)
  b = where(ytot lt 200)
  
  s = scatterplot(data_lvl1_D6[367917:390593].HIT_XY_DET[0], data_lvl1_D6[367917:390593].HIT_XY_DET[1])

  target1 = data_lvl1_D6[367917:390593]
  goodevents = where(target1.error_flag EQ 0)
  target1good = target1[goodevents]
  
  nevents = n_elements(target1good)
  ban = intarr(nevents)
  FOR k=0, nevents -1 DO BEGIN
    xval = target1good[k].hit_xy_det[0]
    a = where(selection eq xval, na)
    IF na EQ 1 THEN ban[k]=1
  ENDFOR

  banni = where(ban eq 1)
  s = scatterplot(target1good.HIT_XY_DET[0], target1good.HIT_XY_DET[1], sym='+',aspect_ratio=1, dime=[1000,1000],sym_size=2, sym_thick=4, xtitle='pixels', ytitle='pixels')
  s2 = scatterplot(target1good[banni].HIT_XY_DET[0], target1good[banni].HIT_XY_DET[1], sym='+', sym_size=2, sym_thick=4, sym_color='red', /over)



  sophie_linecolors
;  plot, target1good.HIT_XY_DET[0], target1good.HIT_XY_DET[1], psym = 4
;  oplot, target1good[banni].HIT_XY_DET[0], target1good[banni].HIT_XY_DET[1], psym=4, color=4
  
  im2 = im
  im2[selection,*] = 0
  
  ct = colortable(1,/reverse)
  i = image(im2, rgb=ct, axis_style=2, dim=[1000,1000], xmajor=9, xminor=16, ymajor=9, yminor=16, margin=0.1, title='det 6, target 1, after selection')

  reste = where(ban eq 0)
  foxsi3_lvl1_image, target1good[reste], 6,im, pay=1, phys=0, plot_im=1, title=', target 1, bad channels excluded'


  stop

  restore, f+'_lvl2_si_ground.sav'
  
  goodevents = where(data_lvl2_d6.error_flag EQ 0)
  lvl2 = data_lvl2_d6[goodevents]
  
  nevents = n_elements(lvl2)
  ban = intarr(nevents)
  FOR k=0, nevents -1 DO BEGIN
    xval = lvl2[k].hit_xy_det[0]
    a = where(selection eq xval, na)
    IF na EQ 1 THEN ban[k]=1
  ENDFOR
  banni = where(ban eq 1)
  reste = where(ban eq 0)
  
  s = scatterplot(lvl2.hit_energy[0], lvl2.hit_energy[1], aspect_ratio=1, dime=[1500,900], sym_size=1, sym_thick=4, $
    xr=[-10,200], yr=[-10,100], sym='o', /sym_filled, xtitle='Energy (keV), n side', ytitle='Energy (keV), p side', title='det 6, target 1, selection' )
  s1 = scatterplot(lvl2[reste].hit_energy[0], lvl2[reste].hit_energy[1], sym='o', xr=[-10,200], yr=[-10,100], sym_size=1, sym_thick=4, /sym_filled, sym_color='red', /over )
  s2 = scatterplot(lvl2[reste].hit_energy[0], lvl2[reste].hit_energy[1], aspect_ratio=1, xr=[-10,200], yr=[-10,100],dime=[1500,900],$
     sym='o', sym_size=1, sym_thick=4, /sym_filled, xtitle='Energy (keV), n side', ytitle='Energy (keV), p side', title='det 6, target 1, after selection' )



;  plot, lvl2.hit_energy[0], lvl2.hit_energy[1], psym = 4
;  oplot, lvl2[banni].hit_energy[0], lvl2[banni].hit_energy[1], psym=4, color=4

  stop

END