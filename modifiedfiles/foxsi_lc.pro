FUNCTION	foxsi_lc, data, dt=dt, stop=stop, good=good, energy=energy, year=year, $
					start_time=start_time, end_time=end_time
					
	;	+
	;	DESCRIPTION
	;	  produces a FOXSI lightcurve given a FOXSI level2 data structure.
	;	
	;	INPUTS
	;	  data: a foxsi level2 structure
	;	  
	;	KEYWORDS  
	;   dt: the time binning in seconds. Constant for entire curve. Default is 10 seconds
	;   stop: set to 1 for the function to stop before returning the result
	;   good: set to 1 to select only 'good' events (no error flags)
	;   energy: 2-element array specifying the energy range. default is [4,15]
	;   year: year of the flight
	;   start_time: in number of seconds after launch
	;   end_time: in number of seconds after launch
	;  
  ; EXAMPLE
  ;   lc = foxsi_lc(data_lvl2_d0, year=2018)
  ;
	; HISTORY
	;		Created routine sometime in 2014!  LG
	;		2015/01    - LG - Updated for FOXSI-2 flight.
	;		2015/03/12 - LG	- Added START_TIME and END_TIME keywords so that array sizes can be controlled.
	;		2018/10/11 - SMusset (UMN) - updated documentation + added the 2018 option for keyword 'year'
	;-
	
	COMMON FOXSI_PARAM
	default, dt, 10		; default time step is 10 sec
	default, energy, [4.,15.]

	; perform cuts.
	data_mod = data
	if keyword_set(good) then data_mod = data_mod[ where( data_mod.error_flag eq 0 ) ]
	data_mod = data_mod[ where( data_mod.hit_energy[1] ge energy[0] and $
									data_mod.hit_energy[1] lt energy[1] ) ]
	
	nEvts = n_elements(data_mod)
	
	; determine time range
	times = data_mod.wsmr_time
	t1 = times[0]
	t2 = times[nEvts-1]
	
	; If start and end times are set, use those instead.
	if keyword_set( start_time ) then t1 = start_time + t_launch
	if keyword_set( end_time )   then t2 = end_time   + t_launch	
	
	nInt = fix( (t2 - t1) / dt )
	if nInt eq 0 then begin
		nInt = 1
		dt = t2-t1
	endif
	
	time_array = t1 + dt*findgen(nInt+1)
	lc = fltarr( nInt )

	for i=0, nInt-1 do begin
		j = where( data_mod.wsmr_time ge time_array[i] and $
				   data_mod.wsmr_time lt time_array[i+1] )
		if j[0] gt -1 then lc[i] = n_elements(j)	
	endfor
	
	time_mean = get_edges(time_array,/mean)
	
	CASE year OF
		2012: date = '2012-nov-02'
		2014: date = '2014-dec-11'
		2018: date = '2018-sep-07'
	ENDCASE
	curve=create_struct('time',anytim(date)+time_mean[0],'persec', double(lc[0])/dt)
	curve = replicate(curve, nInt)
	curve.time = anytim(date)+time_mean
	curve.persec = float(lc)/dt
	
	if keyword_set(stop) then stop
	
	return, curve

END