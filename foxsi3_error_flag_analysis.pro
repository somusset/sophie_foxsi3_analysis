FUNCTION foxsi3_error_flag_analysis, error_flag, th=th, cs=cs

; this function takes an array of error flags and process it

default, th, 3
default, cs, 2.5

n_events = n_elements(error_flag)
binary_flags = bytarr(n_events,16)

good = where(error_flag EQ 0, ngood)
bad = where(error_flag NE 0, nbad)

IF (nbad+ngood) NE n_events THEN print, 'sum problem !'

print, 'number of events = ', n_events
print, 'number of good events = ', ngood
print, 'number of bad events = ', nbad


FOR k=0, n_events-1 DO BEGIN
  dec2bin, error_flag[k], bin, /quiet
  binary_flags[k,*] = bin
ENDFOR

tot_num_flags = reverse([total(binary_flags[*,0]), total(binary_flags[*,1]), total(binary_flags[*,2]), $
                 total(binary_flags[*,3]), total(binary_flags[*,4]), total(binary_flags[*,5]), $
                 total(binary_flags[*,6]), total(binary_flags[*,7]), total(binary_flags[*,8]), $
                 total(binary_flags[*,9]), total(binary_flags[*,10]), total(binary_flags[*,11]), $
                 total(binary_flags[*,12]), total(binary_flags[*,13]), total(binary_flags[*,14]), $
                 total(binary_flags[*,15]) ])

PLOT, indgen(16)+1, tot_num_flags, psym=10, chars=cs, thick=th, xth=th, yth=th, charth=th

print, fix(tot_num_flags)

return, tot_num_flags

END