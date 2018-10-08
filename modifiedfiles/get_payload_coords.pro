;+
; :Description:
;   This function takes a 2D position (or [2,N] array of positions) in detector pixel coordinates
;   and transforms it to payload coordinates.  For each detector, the origin is in its center.
;   The returned coordinates account for the individual detector rotation as designed.
;   Rotations or translations due to misalignments in the assembly are not included.
; 
; :Inputs:
;         COORDS:                A 2xN array containing [x,y] positions in detector pixel coordinates
;         DETECTOR:        Specifies the detector.  Each detector has a different rotation.
;         
; :Keyword:
;         CDTE: Set to 1 to specify that we have a CdTe detector: the pixel size is different        
;
; :RETURN VALUE:
;   A 2XN array containing [x,y] positions in payload coordinates (arcseconds).
;      The reference frame is the same as that on the GSE.
;
; :History:
;   2018-Sep-26 Sophie added CdTe keyword and CdTe pixel size and reflexion in y direction for FOXSI3 CdTe
;   ?? Initial release      
;         
;--  

FUNCTION GET_PAYLOAD_COORDS, COORDS, DETECTOR, CDTE = CDTE, STOP = STOP

DEFAULT, CDTE, 0

        case detector of
                0: rotation =  82.5
                1: rotation =  75.0
                2: rotation = -67.5
                3: rotation = -75.0
                4: rotation =  97.5
                5: rotation =  90.0
                6: rotation = -60.0
        else: begin
                print, 'Detector number out of range (0-6).'
                return, -1
              end
        endcase
        
        ; extract coordinates in pixels
        x = coords[0,*]
        y = coords[1,*]

        ; If FOXSI3 CdTe detector, apply reflexion in y coordinates (see documentation in the file "")
        IF CDTE EQ 1 THEN y = 123.-y
        
        ; Transform pixel coordinates into arcseconds. Angular size of one strip is Tan-1(75um/2m)=7.735"
        ; Also recenter the coordinates so the origin is in the middle of the detector and the pixel numbers
        ; are tied to the middle of the strips.
        IF CDTE EQ 1 THEN pix_microm = 60. ELSE pix_microm = 75. ; pixel size in micrometers
        pix_arcsec = atan(pix_microm*1e-6/2.)*3600.*180/!pi
        ;pix_arcsec = 7.735
        x_arc = ( x - 63.5 )*pix_arcsec
        y_arc = ( y - 63.5 )*pix_arcsec

        if keyword_set(stop) then stop

        ; Transform to payload coordinates by applying the relevant rotation.
        rotation = rotation*!pi/180        ; switch to radians
        x_arc_rot = x_arc*cos( rotation ) - y_arc*sin( rotation )
        y_arc_rot = x_arc*sin( rotation ) + y_arc*cos( rotation )
        
        ; Kluge to fix the vertical reflection problem found during post-flight alignment check
        y_arc_rot = (-1)*y_arc_rot

        ; additional reflection for FOXSI3 CdTe

        return, reform([x_arc_rot,y_arc_rot],[2,n_elements(x_arc_rot)])

END