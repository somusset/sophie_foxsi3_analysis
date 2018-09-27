# FOXSI3-analysis

Contains commands and procedures used for the analysis of the active region target in FOXSI-3 (target 1 and 4).

; detector 0

Frame number 363769 is weird = frame_counter value is to high and HV value is 70 (134 is expected)
In the analysis we will exclude this frame

HV start ramping at frame number 358509 = this is +30sec

target 1 indices       363858      364045
target 2 indices       364046      364095
target 3 indices       364096      364342
target 4 indices       364343      364433

Assuming 4 sec lag at beginning of the target and 2 seconds uncertainty at the end

target 1 indices       363860      364042
target 2 indices       364048      364091
target 3 indices       364101      364339
target 4 indices       364351      364432

; detector 2

Frame to eliminate is number ;363631
target 1 indices       363705      363894
target 2 indices       363899      363941
target 3 indices       363948      364145
target 4 indices       364152      364214

; detector 6

Frame to eliminate is number 364224
target 1 indices       367917      390593
target 2 indices       392277      399642
target 3 indices       401730      462578
target 4 indices       465457      490574

; detector 4

Frame to eliminate is number 364461
target 1 indices       364512      364645
target 2 indices       364649      364678
target 3 indices       364684      364845
target 4 indices       364851      364905

; detector 3

Frame to eliminate is number 445
target 1 indices          535         689
target 2 indices          697         724
target 3 indices          729         939
target 4 indices          949        1033

; detector 5

Frame to eliminate is number 1242
target 1 indices         1325        1464
target 2 indices         1467        1500
target 3 indices         3235       57667
target 4 indices        57824       58303


To go to level 2, need calibration file, named as 'peaks_det108.sav'
==> ask Athiray

The level1 must be different for the CdTe detectors ==> check the level0 to level1 procedure and adapt



