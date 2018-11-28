PRO foxsi3_make_maps, target, map0, map2, map3, map4, map5, mapinfo=mapinfo, save_map=save_map, dir=dir

; target is a number between 1 and 5
;
; example
;   foxsi3_make_maps, 1, map0, map2, map3, map4, map5
;

DEFAULT, dir, 'C:\Users\SMusset\Documents\RESEARCH\FOXSI\Science_Analysis\foxsi3\data\'

  COMMON FOXSI_PARAM

  tr = [[t1_start, t1_end], [t2_start, t2_end], [t3_start, t3_end], [t4_pos0_start, t4_pos0_end], [t4_pos1_start, t4_pos1_end]]
  center = [[cen1_pos0], [cen2_pos0], [cen3_pos0], [cen4_pos0], [cen4_pos1]]
 ; er=[6,20]
  targ = ['1', '2', '3', '4_pos0', '4_pos1']
 ; energy = strtrim(er[0],2)+'-'+strtrim(er[1],2)+'keV'

  loadct, 49
  cs=3.5
  th=3

  k=target-1

    map0 = foxsi_image_map( data_lvl2_d0, center[*,k], trange=tr[*,k], er=er )
    map2 = foxsi_image_map( data_lvl2_d2, center[*,k], trange=tr[*,k], er=er )
    map4 = foxsi_image_map( data_lvl2_d4, center[*,k], trange=tr[*,k], er=er )
    map6 = foxsi_image_map( data_lvl2_d6, center[*,k], trange=tr[*,k], er=er )
    map3 = foxsi_image_map( data_lvl2_d3, center[*,k], trange=tr[*,k], er=er, /cdte )
    map5 = foxsi_image_map( data_lvl2_d5, center[*,k], trange=tr[*,k], er=er, /cdte )

  IF keyword_set(mapinfo) THEN BEGIN
    i=where(map0.data gt 0, n0)
    i=where(map2.data gt 0, n2)
    i=where(map3.data gt 0, n3)
    i=where(map4.data gt 0, n4)
    i=where(map5.data gt 0, n5)
    i=where(map6.data gt 0, n6)
    print, 'number of non zero pixels in maps: ', n0, n2, n3, n4, n5, n6

  ENDIF

  IF keyword_set(save_map) AND save_map EQ 1 THEN BEGIN
    map2fits, map0, dir+'foxsi3_target'+strtrim(target,2)+'_det0.fits'
    map2fits, map2, dir+'foxsi3_target'+strtrim(target,2)+'_det2.fits'
    map2fits, map3, dir+'foxsi3_target'+strtrim(target,2)+'_det3.fits'
    map2fits, map4, dir+'foxsi3_target'+strtrim(target,2)+'_det4.fits'
    map2fits, map5, dir+'foxsi3_target'+strtrim(target,2)+'_det5.fits'
    map2fits, map6, dir+'foxsi3_target'+strtrim(target,2)+'_det6.fits'
  ENDIF


END