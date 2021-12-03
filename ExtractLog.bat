@echo off
REM This batch file uses the Unix like utilities grep, sed and sort from Windows 10.

REM Process the command line arguments:
if "%1"=="--help" goto HELP
if "%1"=="-?" goto HELP
if "%1"=="/?" goto HELP

REM Check for Quiet mode:
if "%1"=="-Q" (
	REM Set Quiet flag:
	set QuietFlag=REM
	shift
) else (
echo %~nx0 v1.00 %~t0
%QuietFlag% echo.
)

if "%1"=="" (
    REM No Args:
    %QuietFlag% <nul (set/p z=No logfile specified, extracting from )
    set LOGFILE=*Voyager.log
    set EXTRACT=Voyager_Extract.log
    set EXTRACTMP="%TMP%\Voyager_Extract.log"
) else if not exist "%1" (
    REM Args does not exist:
    %QuietFlag% echo "%1" does not exist.
    goto END
) else if not exist %1\NUL (
    REM Args is a file:
	%QuietFlag% <nul (set/p z='%1' is a file, extracting from )
	set LOGFILE="%1"
	set EXTRACT="%~dp1%~n1_Extract.log"
	set EXTRACTMP="%TMP%\%~n1_Extract.log"
) else if not exist %1\*Voyager.log (
    REM Args is a directory without log files!
    %QuietFlag% echo "%1" does not contain any Voyager log files.
    goto END
) else (
    REM Args is a directory:
	%QuietFlag% <nul (set/p z='%1' is a directory, extracting from )
	set LOGFILE="%1\*Voyager.log"
	set EXTRACT="%1\%~n1_Extract.log"
	set EXTRACTMP="%TMP%\%~n1_Extract.log"
)

%QuietFlag% echo %LOGFILE% to %EXTRACT% via %EXTRACTMP%.
%QuietFlag% echo.

REM Change into the batch file directory so it can be run from the NotePad++ Run menu:
pushd %~pd0

if "%1"=="" (
	if not exist *Voyager.log goto END
)


:RUN_VOYAGER
REM 2020-04-11 18:28:13 357 - DEBUG     - [Ambiente                     ] - [New                                          ] - Application Start : Release 2.2.8h - Built 2020-04-08
%QuietFlag% <nul (set/p z=Extracting - Run Voyager2   - )
grep.exe -E -h "Application Start" %LOGFILE% | sed.exe "s/- DEBUG.*- \[.* \] - \[.* \] -/- Run Voyager2   -/" > %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Application Start" %LOGFILE% | grep.exe -E -h -c "^.*$"

:LOAD_PROFILE
REM 2020-04-11 18:28:16 389 - INFO      - [Ambiente                     ] - [New                                          ] - File "BeamTech + Tigra RGB" loaded as Actual Setting Profile
%QuietFlag% <nul (set/p z=Extracting - Load Profile   - )
grep.exe -E -h "loaded as Actual Setting Profile" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Load Profile   -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "loaded as Actual Setting Profile" %LOGFILE% | grep.exe -E -h -c "^.*$"

:TERMINATE_VOYAGER
REM 2020-04-12 09:18:33 466 - INFO      - [Common                       ] - [TerminaVoyagerSilent                         ] - Closing Application : User Request
%QuietFlag% <nul (set/p z=Extracting - Exit Voyager2  - )
grep.exe -E -h "Closing Application" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Exit Voyager2  -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Closing Application" %LOGFILE% | grep.exe -E -h -c "^.*$"

:RUN_SCRIPT
REM 2020-04-08 14:33:21 229 - EVENTO    - [DragScript Run               ] - [START_SCRIPT_Code                            ] - Script Started
%QuietFlag% <nul (set/p z=Extracting - Run Script     - )
grep.exe -E -h "Script Started" %LOGFILE% | sed.exe "s/- EVENTO.*- \[.* \] - \[.* \] -/- Run Script     -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Script Started" %LOGFILE% | grep.exe -E -h -c "^.*$"

:END_SCRIPT
REM 2020-04-12 07:03:55 280 - INFO      - [DRAG_SCRIPT                  ] - [Funzione                                     ] - Action Time [DRAG_SCRIPT] => 12 [h] 31 [m] 17 [s] 
%QuietFlag% <nul (set/p z=Extracting - End Script     - )
grep.exe -E -h "Action Time \[DRAG_SCRIPT\]" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- End Script     -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Action Time \[DRAG_SCRIPT\]" %LOGFILE% | grep.exe -E -h -c "^.*$"

:EXIT_SCRIPT
REM 2020-04-17 07:05:44 887 - EVENTO    - [DragScript Run               ] - [END_SCRIPT_Code                              ] - Script Ended
%QuietFlag% <nul (set/p z=Extracting - Exit Script    - )
grep.exe -E -h "Script Ended" %LOGFILE% | sed.exe "s/- EVENTO.*- \[.* \] - \[.* \] -/- Exit Script    -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Script Ended" %LOGFILE% | grep.exe -E -h -c "^.*$"

:BLOCK
REM 2020-04-25 00:04:20 665 - EVENTO    - [DragScript Run               ] - [GET_NEXT_ISTRUZIONE_Code                     ] - Instruction [734]=> Block: Sequence_4
%QuietFlag% <nul (set/p z=Extracting - DragScrptBlock - )
grep.exe -E -h "GET_NEXT_ISTRUZIONE_Code.*=> Block:" %LOGFILE% | grep.exe -E -v "__" | sed.exe "s/- EVENTO.*- \[.* \] - \[.* \] -/- DragScrptBlock -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "GET_NEXT_ISTRUZIONE_Code.*=> Block:" %LOGFILE% | grep.exe -E -v "__" | grep.exe -E -h -c "^.*$"

:ENABLE_EVENTS
REM 2020-02-28 19:37:02 839 - INFO      - [DragScript Run               ] - [DO_ISTRUZIONE_Code                           ] - Run Action => Enable Events
%QuietFlag% <nul (set/p z=Extracting - Enable Events  - )
grep.exe -E -h "Run Action => Enable Events" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Enable Events  -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Run Action => Enable Events" %LOGFILE% | grep.exe -E -h -c "^.*$"

:DISABLE_EVENTS
REM 2020-02-28 20:13:04 287 - INFO      - [DragScript Run               ] - [DO_ISTRUZIONE_Code                           ] - Run Action => Disable Events
%QuietFlag% <nul (set/p z=Extracting - Disable Events - )
grep.exe -E -h "Run Action => Disable Events" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Disable Events -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Run Action => Disable Events" %LOGFILE% | grep.exe -E -h -c "^.*$"

:SUSPEND_EVENT
REM 2020-04-11 19:09:02 177 - EMERGENCY - [DragScript Run               ] - [ManageBroadcast_EmergencySuspend             ] - Emergency Suspend Event Received : RUNNING CODE
%QuietFlag% <nul (set/p z=Extracting - EmergencyEvent - SUSPEND )
grep.exe -E -h "Emergency Suspend Event Received : RUNNING CODE" %LOGFILE% | sed.exe "s/- EMERGENCY.*- \[.* \] - \[.* \] -/- EmergencyEvent -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Emergency Suspend Event Received : RUNNING CODE" %LOGFILE% | grep.exe -E -h -c "^.*$"

:SUSPEND_TIMEOUT
REM 2020-04-12 07:00:00 193 - WARNING   - [DragScript Run               ] - [SUSPEND_SCRIPT_Code                          ] - Emergency Suspend TIMEOUT : Request Exec of Emergency EXIT Code
%QuietFlag% <nul (set/p z=Extracting - EmergencyEvent - SUSPEND Timeout )
grep.exe -E -h "Emergency Suspend TIMEOUT : Request Exec of Emergency EXIT Code" %LOGFILE% | sed.exe "s/- WARNING.*- \[.* \] - \[.* \] -/- EmergencyEvent -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Emergency Suspend TIMEOUT : Request Exec of Emergency EXIT Code" %LOGFILE% | grep.exe -E -h -c "^.*$"

:RESUME_EVENT
REM 2020-04-09 21:19:17 606 - EMERGENCY - [DragScript Run               ] - [ManageBroadcast_EmergencyResume              ] - Emergency Resume Event Received : RUNNING CODE
%QuietFlag% <nul (set/p z=Extracting - EmergencyEvent - RESUME )
grep.exe -E -h "Emergency Resume Event Received : RUNNING CODE" %LOGFILE% | sed.exe "s/- EMERGENCY.*- \[.* \] - \[.* \] -/- EmergencyEvent -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Emergency Resume Event Received : RUNNING CODE" %LOGFILE% | grep.exe -E -h -c "^.*$"

:EXIT_EVENT
REM 2020-04-12 07:00:00 225 - EMERGENCY - [DragScript Run               ] - [ManageBroadcast_EmergencyExit                ] - Emergency Exit Event Received : RUNNING CODE
%QuietFlag% <nul (set/p z=Extracting - EmergencyEvent - EXIT )
grep.exe -E -h "Emergency Exit Event Received : RUNNING CODE" %LOGFILE% | sed.exe "s/- EMERGENCY.*- \[.* \] - \[.* \] -/- EmergencyEvent -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Emergency Exit Event Received : RUNNING CODE" %LOGFILE% | grep.exe -E -h -c "^.*$"

:CONNECT_SAETY_MONITOR
REM 2020-04-09 21:19:21 812 - EVENTO    - [DragScript Run               ] - [SETUP_CONNETTI_SAFMON_WAIT_Code              ] - Safety Monitor Control is Connected
%QuietFlag% <nul (set/p z=Extracting - Safety Monitor - Connected )
grep.exe -E -h "Safety Monitor Control is Connected" %LOGFILE% | sed.exe "s/- EVENTO.*- \[.* \] - \[.* \] -/- Safety Monitor -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Safety Monitor Control is Connected" %LOGFILE% | grep.exe -E -h -c "^.*$"

:DISCONNECT_SAFETY_MONITOR
REM 2020-02-28 21:52:37 458 - INFO      - [Ambiente                     ] - [NEW_DisconnettiSafMon                        ] - SafetyMonitor Disconnected
%QuietFlag% <nul (set/p z=Extracting - Safety Monitor - Disconnected )
grep.exe -E -h "SafetyMonitor Disconnected" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Safety Monitor -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "SafetyMonitor Disconnected" %LOGFILE% | grep.exe -E -h -c "^.*$"

:ASTRONOMICAL_NIGHT
REM 2020-04-13 17:34:00 666 - INFO      - [DragScript Run               ] - [TEMPORIZZAZIONI_ATTENDI_NOTTE_ASTRONOMICA_WAIT_Code] - Astronomical Night Start => 2020-04-13 19:23:00 End => 2020-04-14 05:17:00
REM 2021/11/30 21:23:31 609 - SUBTITLE  - [DragScript Run               ] - [TEMPORIZZAZIONI_ATTENDI_NOTTE_ASTRONOMICA_WAIT_Code] - Wait Astronomical Night Started
%QuietFlag% <nul (set/p z=Extracting - Astro Night    - )
grep.exe -E -h "Astronomical Night Start" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.*\] -/- Astro Night    -/" | sed.exe "s/- SUBTITLE.*- \[.* \] - \[.*\] -/- Astro Night    -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Astronomical Night Start" %LOGFILE% | grep.exe -E -h -c "^.*$"

:ASCOM_CONNECT
%QuietFlag% <nul (set/p z=Extracting - ASCOM Connect  - )
REM 2020-04-16 16:28:20 153 - INFO      - [DragScript Run               ] - [DO_ISTRUZIONE_Code                           ] - Run Action => Connect Setup
grep.exe -E -h "Run Action => Connect Setup" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- ASCOM Connect  -/" > %TMP%\TMP_Extract.txt
REM 2020-04-16 16:26:44 967 - SUBTITLE  - [DragScript Run               ] - [SETUP_CONNETTI_Code                          ] - Start Setup Connect (Timeout 60s)
grep.exe -E -h "Start Setup Connect" %LOGFILE% | sed.exe "s/- SUBTITLE.*- \[.* \] - \[.* \] -/- ASCOM Connect  -/" >> %TMP%\TMP_Extract.txt
REM 2020-04-16 16:28:20 169 - EVENTO    - [DragScript Run               ] - [SETUP_CONNETTI_Code                          ] - Setup is Already Connect
grep.exe -E -h "Setup is Already" %LOGFILE% | sed.exe "s/- EVENTO.*- \[.* \] - \[.* \] -/- ASCOM Connect  -/" >> %TMP%\TMP_Extract.txt
type %TMP%\TMP_Extract.txt >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% type %TMP%\TMP_Extract.txt | grep.exe -E -h -c "^.*$"
if exist %TMP%\TMP_Extract.txt del %TMP%\TMP_Extract.txt

:ASCOM_DRIVERS
REM 2020-04-17 16:20:06 197 - INFO      - [Ambiente                     ] - [NEW_ConnettiCamera                           ] - Camera [QSI] Connected to Version QSI 583ws - [S/N 00504975]
REM 2020-04-17 16:20:06 215 - INFO      - [Ambiente                     ] - [NEW_ConnettiRuota                            ] - Filter Wheel [QSI_INTERNA] Connected to Version RGBLHa - 
REM 2020-04-17 16:20:16 425 - INFO      - [Ambiente                     ] - [NEW_ConnettiTelescope                        ] - Telescope [ASCOM_TELESCOPE] Connected to AstroPhysics V2 ASCOM Mount Driver 5.30.9
REM 2020-04-17 16:20:32 176 - INFO      - [Ambiente                     ] - [NEW_ConnettiGuide                            ] - Guiding System [PHD2] Connected to Version =2.6.7;Subversion=;Msg=1;2006007 - Unknow
REM 2020-04-17 16:20:45 393 - INFO      - [Ambiente                     ] - [NEW_ConnettiPlanetarium                      ] - Planetarium System [CARTES_DU_CIEL] Connected to Version n.d.
REM 2020-04-17 16:20:47 098 - INFO      - [Ambiente                     ] - [NEW_ConnettiPlateSolve                       ] - Plate Solving System [PLATESOLVE2] Connected to Version [2.29] - 2.00.0002 - [2016-10-12]
REM 2020-04-17 16:20:49 884 - INFO      - [Ambiente                     ] - [NEW_ConnettiBlindSolve                       ] - Blind Solving System [ALLSKY_PLATE_SOLVER] Connected to Version 1.4.5.9
REM 2020-04-17 16:20:53 993 - INFO      - [Ambiente                     ] - [NEW_ConnettiFocuserObject                    ] - Focuser Object [ASCOM] Connected to myFocuserPro2ASCOM
REM 2020-04-17 16:20:54 029 - INFO      - [Ambiente                     ] - [NEW_ConnettiFocusing                         ] - Autofocus [ROBOFIRE] Connected to Version 1.0.0 - Voyager Internal AutoFocus System
REM 2020-04-17 16:20:57 681 - INFO      - [Ambiente                     ] - [NEW_ConnettiObsCond                          ] - Observing Conditions [ASCOM] Connected to ASCOM Observing Conditions Hub (OCH). Version: 6.4.0.0
REM 2020-04-17 16:20:58 130 - INFO      - [Ambiente                     ] - [NEW_ConnettiSQM                              ] - SQM [ASCOM] Connected to SQM Serial driver by Martin Mangan. Version: 6.2
REM 2020-04-17 16:20:58 255 - INFO      - [Ambiente                     ] - [NEW_ConnettiSafMon                           ] - SafetyMonitor [ASCOM] Connected to Information about the driver itself. Version: 6.2.5821.20464
REM 2020-04-17 16:21:10 840 - INFO      - [Ambiente                     ] - [NEW_ConnettiDome                             ] - Dome [ASCOM_DOME] Connected to NexDome Control System
%QuietFlag% <nul (set/p z=Extracting - ASCOM Driver   - )
grep.exe -E -h "INFO.*NEW_Connetti" %LOGFILE% | grep.exe -E -v "Linking to" | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- ASCOM Driver   -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "INFO.*NEW_Connetti" %LOGFILE% | grep.exe -E -v -c "Linking to"

:PELTIER_COOLED
REM 2021/11/30 21:50:05 987 - INFO      - [Camera                       ] - [GestioneCooling                              ] - CCD Peltier Cooled
%QuietFlag% <nul (set/p z=Extracting - Peltier Cooled - )
grep.exe -E -h "CCD Peltier Cooled" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Peltier Cooled -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "CCD Peltier Cooled" %LOGFILE% | grep.exe -E -h -c "^.*$"

:COOLER_TIMEOUT
REM 2021/11/30 22:04:59 940 - WARNING   - [Camera                       ] - [GestioneCooling                              ] - CCD Peltier Warmup Finished for Timeout
REM 2021/11/30 21:12:44 807 - WARNING   - [Camera                       ] - [GestioneCooling                              ] - CCD Peltier Cooling Finished for Timeout
%QuietFlag% <nul (set/p z=Extracting - Cooler Timeout - )
grep.exe -E -h "WARNING   - \[Camera" %LOGFILE% | sed.exe "s/- WARNING.*- \[.* \] - \[.* \] -/- Cooler Timeout -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "WARNING   - \[Camera" %LOGFILE% | grep.exe -E -h -c "^.*$"

:SEQUENCE_DONE
REM 2020-04-25 00:04:20 229 - INFO      - [SEQUENCE                     ] - [Funzione                                     ] - Action Time [SEQUENCE] => 2 [h] 1 [m] 11 [s] 
%QuietFlag% <nul (set/p z=Extracting - Sequence Done  - )
grep.exe -E -h "Action Time \[SEQUENCE\]" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Sequence Done  -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Action Time \[SEQUENCE\]" %LOGFILE% | grep.exe -E -h -c "^.*$"

:SEQUENCE_START
REM 2020-04-25 00:04:21 085 - INFO      - [DragScript Run               ] - [DO_ISTRUZIONE_Code                           ] - Run Action => Sequence: Start 00:00:00 [hh:mm:ss] - End 02:00:00 [hh:mm:ss] - C:\Users\fowle\Documents\Voyager\ConfigSequence\Scheduled_Sequences\Sequence_4.s2q
%QuietFlag% <nul (set/p z=Extracting - Sequence Start - )
grep.exe -E -h "Run Action => Sequence: Start" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Sequence Start -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Run Action => Sequence: Start" %LOGFILE% | grep.exe -E -h -c "^.*$"

:SEQUENCE_TOO_LOW
REM 2021-03-29 04:53:38 060 - WARNING   - [Sequence                     ] - [START_NEXT_ELEMENT_SEQUENCE_Code             ] - Target Is lower than requested Min Altitude 38 57 26.20  < 40 00 00.00 [DMS]
%QuietFlag% <nul (set/p z=Extracting - Target Too Low - )
grep.exe -E -h "Target Is lower than requested Min Altitude" %LOGFILE% | sed.exe "s/- WARNING.*- \[.* \] - \[.* \] -/- Target Too Low -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Target Is lower than requested Min Altitude" %LOGFILE% | grep.exe -E -h -c "^.*$"

:GUIDING_STATS
REM 2020-04-09 03:08:38 758 - INFO      - [Sequence                     ] - [EsposizioneOK                                ] - GUIDING Stats - RMS Error (RA=0.272 - DEC=0.255)
%QuietFlag% <nul (set/p z=Extracting - Guiding  Stats - )
grep.exe -E -h "Stats - RMS Error" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] - GUIDING Stats -/- Guiding Stats  -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Stats - RMS Error" %LOGFILE% | grep.exe -E -h -c "^.*$"

:GUIDE_STAR_LOST
REM 2020-04-01 01:34:53 255 - WARNING   - [Sequence                     ] - [ManageBroadcast_GuidingStarLost              ] - Event GUIDING STAR LOST - Lost Per Minute = 1
REM 2020-04-01 03:46:17 415 - EVENTO    - [Sequence                     ] - [ManageBroadcast_GuidingStarLost              ] - Event GUIDING STAR LOST
%QuietFlag% <nul (set/p z=Extracting - GuideStar Lost - )
grep.exe -E -h "GUIDING STAR LOST" %LOGFILE% | sed.exe "s/- WARNING.*- \[.* \] - \[.* \] -/- GuideStar Lost -/" | sed.exe "s/- EVENTO.* - Event GUIDING STAR LOST/- GuideStar Lost - Not integrating/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "GUIDING STAR LOST" %LOGFILE% | grep.exe -E -h -c "^.*$"

:GUIDE_START_ERROR
REM 2020-07-13 23:55:32 294 - WARNING   - [Sequence                     ] - [StartGuidingRetry                            ] - Start Guiding Error (Start Guide Failed (Error during PHD2 StartGuide [Auto] Command Request : [NON_ESEGUITO] Cannot initiate guide while guide is in progress))
%QuietFlag% <nul (set/p z=Extracting - GuideStart Err - )
grep.exe -E -h "Start Guiding Error" %LOGFILE% | sed.exe "s/- WARNING.*- \[.* \] - \[.* \] -/- GuideStart Err -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
grep.exe -E -h "Start Guiding Error" %LOGFILE% | grep.exe -E -h -c "^.*$"

:FOCUS_STAR
REM 2020-04-26 18:57:40 424 - INFO      - [FocusSlewAndBackStar         ] - [PRECISE_POINT_STAR_Code                      ] - Selected Star for Focus : Star HIP 52762 - RA 10:47:19 - DEC -57° 19' 31" - Mag. 6.96 - Distance 01° 27' 14" - Altitude 62 38 00.84  - Before Target - HA to Target -00:00:29 - HA to Meridian -01:49:48
%QuietFlag% <nul (set/p z=Extracting - AutoFocus Star - )
grep.exe -E -h "Selected Star for Focus" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- AutoFocus Star -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Selected Star for Focus" %LOGFILE% | grep.exe -E -h -c "^.*$"

:AUTOFOCUS
REM 2020-04-09 02:35:28 892 - INFO      - [Focus                        ] - [FINISH_Code                                  ] - Focus Done - Pos=414 HFD=2.407718 Star(X,Y)=836.7253 - 638.8029 Temperature=11.25 Focus Time=02:46
%QuietFlag% <nul (set/p z=Extracting - AutoFocus      - )
grep.exe -E -h "Focus Done" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- AutoFocus      -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Focus Done" %LOGFILE% | grep.exe -E -h -c "^.*$"

:START_FRAME
REM 2020-04-01 03:48:25 731 - SUBTITLE  - [Sequence                     ] - [START_NEXT_ELEMENT_SEQUENCE_Code             ] - Expose Be146_LIGHT_Red_240s_BIN1_-20C_006_20200401_034825_403_E.FIT
%QuietFlag% <nul (set/p z=Extracting - Start Exposure - )
grep.exe -E -h "START_NEXT_ELEMENT_SEQUENCE_Code             ] - Expose" %LOGFILE% | sed.exe "s/- SUBTITLE.*- \[.* \] - \[.* \] -/- Start Exposure -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "START_NEXT_ELEMENT_SEQUENCE_Code             ] - Expose" %LOGFILE% | grep.exe -E -h -c "^.*$"

:SAVE_FITS
REM 2020-04-17 02:21:04 939 - INFO      - [CameraShot                   ] - [FILE_SAVE_Code                               ] - File FIT Saved (NGC5128_LIGHT_Ha_1800s_BIN1_-20C_003_20200417_015037_266_E)
%QuietFlag% <nul (set/p z=Extracting - File FIT Saved - )
grep.exe -E -h "File FIT Saved" %LOGFILE% | grep.exe -E -v "SyncVoyager" | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- FIT File Saved -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "File FIT Saved" %LOGFILE% | grep.exe -E -v -c "SyncVoyager"

:DUSK_START
REM 2020-07-01 16:56:34 311 - INFO      - [DragScript Run               ] - [TEMPORIZZAZIONI_ATTENDI_DUSK_Code            ] - Dusk Start @ 2020-07-01 17:03:00
%QuietFlag% <nul (set/p z=Extracting - Dusk Start     - )
grep.exe -E -h " Dusk Start @ " %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Dusk Start     -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h " Dusk Start @ " %LOGFILE% | grep.exe -E -h -c "^.*$"

:DAWN_START
REM 2020-07-01 06:14:36 998 - INFO      - [DragScript Run               ] - [TEMPORIZZAZIONI_ATTENDI_DAWN_Code            ] - Dawn Start @ 2020-07-01 06:48:00
%QuietFlag% <nul (set/p z=Extracting - Dawn Start     - )
grep.exe -E -h " Dawn Start @ " %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Dawn Start     -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h " Dawn Start @ " %LOGFILE% | grep.exe -E -h -c "^.*$"

:FLAT_FRAME
REM 2020-07-01 17:11:51 242 - INFO      - [SkyFlat                      ] - [GET_EXPOSURE_TIME_Code                       ] - Mean ADU of 34240 in range with 10.541[s]
%QuietFlag% <nul (set/p z=Extracting - Flat Frame ADU - )
grep.exe -E -h "SkyFlat .* - Mean ADU of" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Flat Frame ADU -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "SkyFlat .* - Mean ADU of" %LOGFILE% | grep.exe -E -h -c "^.*$"

:PLATESOLVE
REM 2020-04-09 00:45:54 565 - INFO      - [PrecisePointing              ] - [CHECK_POINTING_ERROR_Code                    ] - For your info the Best Performance obtained from your Mount in this pointing is 00° 00' 09"[DMS]
%QuietFlag% <nul (set/p z=Extracting - Plate Solve    - )
grep.exe -E -h "For your info the Best Performance obtained from your Mount in this pointing is" %LOGFILE% | sed.exe "s/- INFO.*- \[.* \] - \[.* \] -/- Plate Solve    -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "For your info the Best Performance obtained from your Mount in this pointing is" %LOGFILE% | grep.exe -E -h -c "^.*$"

:PLATESOLVE_ERROR
REM 2020-04-07 04:53:19 094 - WARNING   - [PlateSolvingFile             ] - [SOLVE_FAIL_Code                              ] - Plate Solving Error : Solve Failed Maximum search limit exceeded
%QuietFlag% <nul (set/p z=Extracting - Plate Solve    - Error )
grep.exe -E -h "Plate Solving Error :" %LOGFILE% | sed.exe "s/- WARNING.*- \[.* \] - \[.* \] -/- Plate Solve    -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Plate Solving Error :" %LOGFILE% | grep.exe -E -h -c "^.*$"

:BLINDSOLVE_ERROR
REM 2020-04-07 05:01:09 242 - WARNING   - [BlindSolvingFile             ] - [SOLVE_FAIL_Code                              ] - Blind Solving Error : 13 - Time out (300 seconds).
%QuietFlag% <nul (set/p z=Extracting - Blind Solve    - Error )
grep.exe -E -h "Blind Solving Error :" %LOGFILE% | sed.exe "s/- WARNING.*- \[.* \] - \[.* \] -/- Blind Solve    -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Blind Solving Error :" %LOGFILE% | grep.exe -E -h -c "^.*$"

:MERIDAN_FLIP
REM 2020-04-17 21:38:22 436 - EVENTO    - [Sequence                     ] - [MeridianCheck                                ] - Starting Meridian Flip
%QuietFlag% <nul (set/p z=Extracting - Meridian Flip  - )
grep.exe -E -h "Starting Meridian Flip" %LOGFILE% | sed.exe "s/- EVENTO.*- \[.* \] - \[.* \] -/- Meridian Flip  -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "Starting Meridian Flip" %LOGFILE% | grep.exe -E -h -c "^.*$"

:VOYAGER_WARNINGS
REM 2020-04-17 21:38:23 944 - WARNING   - [DragScript Run               ] - [VOY_SEQUENCE_WAIT_Code                       ] - ERROR (FINISHED) Sequence  : Shutdown Guide (Guide Stopping Failed (Error during PHD2 Stop_Capture Command Request : [NON_INOLTRATO] PHD2Client is busy now : [CMD_RUNNING]))
REM 2020-03-07 19:31:53 145 - WARNING   - [DragScript Run               ] - [DOME_OPEN_SHUTTER_WAIT_Code                  ] - ERROR (FINISHED) Open Dome Shutter  : Shutter result closing after starting opening !!!
REM Exclude 
REM 2020-05-03 06:30:00 162 - WARNING   - [DragScript Run               ] - [ManageBroadcast_EmergencyExit                ] - Emergency Exit received in Resume Wait Status, override
REM 2020-05-03 06:30:00 053 - WARNING   - [DragScript Run               ] - [SUSPEND_SCRIPT_Code                          ] - Emergency Suspend TIMEOUT
REM 2020-05-03 06:30:59 794 - WARNING   - [DragScript Run               ] - [SE_COUNTER_Code                              ] - Check Counter .. NOT MATCH != 0
%QuietFlag% <nul (set/p z=Extracting - Voyager WARN   - )
grep.exe -E -h "WARNING   - \[DragScript Run" %LOGFILE% | grep -E -v "Emergency Suspend TIMEOUT" | grep -E -v "Emergency Exit received in Resume Wait Status, override" | grep -E -v "Check Counter .. NOT MATCH != 0" | sed.exe "s/- WARNING.*- \[.* \] - \[.* \] -/- Voyager WARN   -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "WARNING   - \[DragScript Run" %LOGFILE% | grep -E -v "Emergency Suspend TIMEOUT" | grep -E -v "Emergency Exit received in Resume Wait Status, override" | grep -E -v "Check Counter .. NOT MATCH != 0" | grep.exe -E -h -c "^.*$"

:VOYAGER_ERRORS
REM 2020-03-29 20:47:31 977 - CRITICAL  - [FlipManager                  ] - [AggiornaFlipInfo                             ] - Flip Info Error : The scope is not connected
REM 2020-03-29 20:47:31 981 - CRITICAL  - [Telescopio                   ] - [PushFunction                                 ] - Error [1000] : Value was either too large or too small for a Double.
REM 2020-03-29 21:26:25 245 - CRITICAL  - [Ambiente                     ] - [NEW_ConnettiCamera                           ] - Cannot Connect Camera [QSI][Error : Not Connected]
REM 2020-03-29 21:26:25 276 - CRITICAL  - [Ambiente                     ] - [NEW_ConnettiRuota                            ] - Cannot Connect Filter Wheel [QSI_INTERNA][]
REM 2020-03-30 10:38:48 500 - CRITICAL  - [ServerListener               ] - [Funzione                                     ] - [S00005] Errore : Object reference not set to an instance of an object.
REM 2020-03-30 10:41:49 956 - CRITICAL  - [AutoFocus                    ] - [PushFunction                                 ] - Error Autofocus Push : Cannot access a disposed object.
REM 2020-03-30 10:42:15 926 - CRITICAL  - [Telescopio                   ] - [PushFunction                                 ] - Error [60000] : The RPC server is unavailable. (Exception from HRESULT: 0x800706BA)
%QuietFlag% <nul (set/p z=Extracting - Voyager ERROR  - )
grep.exe -E -h "CRITICAL  -" %LOGFILE% | sed.exe "s/- CRITICAL.*- \[.* \] - \[.* \] -/- Voyager ERROR  -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "CRITICAL  -" %LOGFILE% | grep.exe -E -h -c "^.*$"

:LOCAL_SIDEREAL_TIME:
REM 2020-03-30 10:36:15 125 - INFO      - [Telescopio                   ] - [PushFunction                                 ] - PierSide= pierEast (DRV)(0) ; LastGotoPierSide= pierEast (DRV) ; FlipStatus= FATTO ; MeridianQuery= IDLE ; LST= 21:48:06 (DRV) ; RA= 00:00:00 ; LST-RA= -02:11:54(-2.19827501075473) ; AZ= 00° 00' 00" ; ALT= 09° 01' 27"
%QuietFlag% <nul (set/p z=Extracting - Sidereal Time  - )
grep.exe -E -h -m1 "LST= [0-9][0-9]:[0-9][0-9]:[0-9][0-9]" %LOGFILE% | sed.exe -e "s/- INFO.*- \[.* \] - \[.* \] -/- Sidereal Time  -/" -e "s/- Sidereal Time  -.*LST=/- Sidereal Time  - LST =/" | sed.exe "s/(DRV).*$/(DRV)/">> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h -m1 "LST= [0-9][0-9]:[0-9][0-9]:[0-9][0-9]" %LOGFILE% | grep.exe -E -h -c "^.*$"

:SEND_EMAIL
REM 2020-04-25 07:06:01 949 - EVENTO    - [Send Email                   ] - [SENDMAIL_Code                                ] - Try Send Mail To => StellarBlu@aapt.net.au ; Subject => Powered Down for Exit
REM 2020-04-23 03:07:45 475 - EVENTO    - [Send Email                   ] - [SENDMAIL_Code                                ] - Try Send Mail To => StellarBlu@aapt.net.au ; Subject => Resuming ...
%QuietFlag% <nul (set/p z=Extracting - Send Email     - )
grep.exe -E -h "EVENTO.*- Try Send Mail To" %LOGFILE% | sed.exe -e "s/- EVENTO.*- \[.* \] - \[.* \] -/- Send Email     -/" >> %EXTRACTMP%
%QuietFlag% <nul (set/p z= ... )
%QuietFlag% grep.exe -E -h "EVENTO.*- Try Send Mail To" %LOGFILE% | grep.exe -E -h -c "^.*$"

:SORT
%QuietFlag% <nul (set/p z=Sorting ... )
REM gnuwin32 version
::sort.exe -u %EXTRACTMP% > %EXTRACT%.log
REM Windows10 native version
sort.exe %EXTRACTMP% > %EXTRACT%

popd

:CLEANUP
del %EXTRACTMP%

%QuietFlag% echo Done.

goto END

:HELP
echo %~nx0 [--help or -?] [-Q] or [log_file] or [log_dir]
echo      --help or -?  gets you this ...
echo      -Q  Quite mode
echo      if log_file and log_dir are not specified, processes all Voyager logs in the %~nx0 directory.
echo.
echo From Windows Explorer, you can ...
echo     double click on %~nx0 to process *Voyager.log in the current directory, or
echo     drag and drop a Voyager log file onto %~nx0 to process that file, or
echo     drag and drop a directory onto %~nx0 to process all Voyager log files in that directory.
echo.
echo     The %~nx0 window will close after 30 seconds.
goto END

:END
REM Wait 30 seconds before exiting...
%QuietFlag% ping -n 31 localhost >NUL
