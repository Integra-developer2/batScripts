@echo off
setlocal DisableDelayedExpansion
ENDLOCAL
CALL T:\PDFtoPDF\Dev\PDFtoPDF_DEFAULTS.bat %1


rem -------- LEGENDA ---------------------------------------------------------------------------------------------------------------------
rem _X_ = COORDINATA(mm) ORIZZONTALE A PARTIRE DA SINISTRA
rem _Y_ = COORDINATA(mm) VERTICALE A PARTIRE DAL BASSO
rem _W_ = LARGHEZZA(mm) A PARTIRE DA X CONTINUANDO VERSO L'ALTO - W=WIDTH
rem _H_ = ALTEZZA(mm) A PARTIRE DA Y CONTINUANDO VERSO DESTRA - H=HEIGHT
rem _L_ = MARGINE(mm) SINISTRO - L=LEFT
rem _T_ = MARGINE(mm) SUPERIORE - T=TOP
rem _Z_ = ZOOM(%) - Z=ZOOM
rem _S_ = DIMENSIONE(pt) CARATTERE - S=SIZE
rem _P_ = PERCORSO FILE - P=PATH
rem _C_ = COLONNA GRIGLIA - C=COLUMN
rem _F_ = FORMATO TESTO DI USCITA - F=FORMAT
rem _V_ = VALORE DEL TESTO - V=VALUE
rem _B_ = VALORE PRIMA - B=BEFORE
rem _E_ = VALORE ESTRAZIONE - E=EXTRACT
rem _A_ = VALORE DOPO - A=AFTER
rem --------------------------------------------------------------------------------------------------------------------------------------


rem -------- GLOBALI ---------------------------------------------------------------------------------------------------------------------
rem 0=NON ESEGUE L'OPERAZIONE
rem 1=ESEGUE L'OPERAZIONE
rem ------
rem GENERA_LOG=0 o 1 o 2 - 1:CREA UN FILE LOG.TXT CON QUELLO CHE L'ELABORAZIONE "VEDE"; 2:CREA UN FILE REPORT.TXT I REPORTS DELL'ELABORAZIONE
rem GENERA_BARCODE=[AR=(RACCOMANDATE AR)-RG=(RACCOMANDATE GIUDIZIARIE)-AG=(ATTI GIUDIZIARI)-0=(NIENTE)] - GENERA IL BARCODE SULLA LETTERA
rem SPOSTA_INDIRIZZO=0 o 1 - SPOSTA L'INDIRIZZO IN UNA NUOVA POSIZIONE
rem SPOSTA_TESTO=0 o 1 - SPOSTA UN TESTO IN UNA NUOVA POSIZIONE
rem GENERA_DATAMATRIX=0 o 1 - GENERA IL DATAMATRIX SULLA LETTERA
rem NASCONDI_ZONA=0 o 1 - NASCONDI ZONA DESIDERATA
rem ATTO_IN_BARCODE=0 o 1  - NASCONDE IL CODICE ATTO E LO CONVERTE IN BARCODE
rem RINOMINA_FILE=0 o 1  - rinomina il file prima della stampa, in modo da poterne impostare l'ordinamento

SET "GENERA_LOG=0"
SET "GENERA_BARCODE=0"
SET "SPOSTA_TESTO=0"
SET "SPOSTA_INDIRIZZO=0"
SET "GENERA_DATAMATRIX=0"
SET "GENERA_DATAMATRIX_PM=1"
SET "ATTO_IN_BARCODE=0"
SET "BARCODE_TEXT=1"
SET "NASCONDI_ZONA=0"
SET "ELIMINA_PAGINE=0"
SET "ESCLUDI_PAGINE=0"
SET "RINOMINA_FILE=1"
SET "INSERISCI_IMMAGINE=0"
SET "TESTO_DA_GRIGLIA=0"
SET "COVER_DUPLEX=1"
rem ---------------------------------------------------------------------------------------------------------------------------------------


rem -------- PARAMETRI LETTERA Search -----------------------------------------------------------------------------------------------------
rem identificazione documento con o numero pag. oppure ricerca zona 
rem ---spazio [ ]*--- tutti i valoti .*-------  almeno in carattere .+ ----ricerca su ultima pagina (?p1) mettere L al posto di 1 (?pL)
rem -- pulisci spazi ---- (?nospaces)------ d'accapo e spazio---[\n ]* In caso di caratteri invisibili [^A-Z0-9]*--ricerca piu serch cstumer----------rem----------(?:Cod\.[ ]*Fiscale|Partita[ ]*IVA)[ ]*" 



rem --misure rettangolo search
SET "MATCH_RECT_X_LETT=0"
SET "MATCH_RECT_Y_LETT=0"
SET "MATCH_RECT_W_LETT=210"
SET "MATCH_RECT_H_LETT=297"
rem --misure prima nel mezzo e dopo search
SET "MATCH_FIND_B_LETT=(?p1)"
SET "MATCH_FIND_E_LETT=.*"
SET "MATCH_FIND_A_LETT="
rem --eventuale search per pagina (indicare n° Pagina) oppure valore da cercare (es. comune di anzio)
SET "MATCH_FIND_E_LETT=%MATCH_FIND_E_LETT%"
SET "MATCH_FIND_B_LETT=%MATCH_FIND_B_LETT%"
rem --------------------------------------------------------------------------------------------------------------------------------------


rem -------- PARAMETRI LETTERA Customer Number--------------------------------------------------------------------------------------------
SET "RECT_X_LETT=0"
SET "RECT_Y_LETT=0"
SET "RECT_W_LETT=210"
SET "RECT_H_LETT=300"
rem --PRIMA
SET "FIND_B_LETT=(?oRect)CUSTOMER\_CODE\:LETTERA\_[ ]*"
rem --CuSTUMAR NUMBER DA ESTRARRE (NON TOCCARE)
SET "FIND_E_LETT=[A-Z0-9]{9}"
rem --DOPO
SET "FIND_A_LETT="

SET "TRAY_N_LETT="
SET "DPI_N_LETT=300"
rem --------------------------------------------------------------------------------------------------------------------------------------


rem -------- PARAMETRI Pagamenti Search --------------------------------------------------------------------------------------------------
rem identificazione documento con o numero pag. oppure ricerca zona 
rem ---spazio [ ]*--- tutti i valoti .*-------  almeno in carattere .+ ----ricerca su ultima pagina (?p1) mettere L al posto di 1 (?pL)
rem -- pulisci spazi ---- (?nospaces)

rem --misure rettangolo search
SET "MATCH_RECT_X_PAGA=0"
SET "MATCH_RECT_Y_PAGA=0"
SET "MATCH_RECT_W_PAGA=210"
SET "MATCH_RECT_H_PAGA=297"
rem --misure prima nel mezzo e dopo search
SET "MATCH_FIND_B_PAGA=(?oRect)"
SET "MATCH_FIND_E_PAGA=CUSTOMER_CODE:PAGAMENTO"
SET "MATCH_FIND_A_PAGA="
rem --------------------------------------------------------------------------------------------------------------------------------------


rem -------- PARAMETRI PAGAMENTO Customer Number -----------------------------------------------------------------------------------------
SET "RECT_X_PAGA=0"
SET "RECT_Y_PAGA=0"
SET "RECT_W_PAGA=210"
SET "RECT_H_PAGA=300"
rem --PRIMA
SET "FIND_B_PAGA="
rem --customer number da estrarre (non toccare)
SET "FIND_E_PAGA=.*"
rem --dopo
SET "FIND_A_PAGA="

SET "TRAY_N_PAGA="
SET "DPI_N_PAGA=300"
rem --------------------------------------------------------------------------------------------------------------------------------------


rem -------- MARGINI BOZZA/PRE-STAMPA ----------------------------------------------------------------------------------------------------
SET "PREV_T_LETT=0"
SET "PREV_L_LETT=0"
SET "PREV_Z_LETT=100"

SET "PREV_T_PAGA=0"
SET "PREV_L_PAGA=0"
SET "PREV_Z_PAGA=100"

SET "PREV_T_ALLS=0"
SET "PREV_L_ALLS=0"
SET "PREV_Z_ALLS=100"
rem --------------------------------------------------------------------------------------------------------------------------------------
rem -------- INSERISCI TESTO DA GRIGLIA ------------------------------
SET "RECT_X_GRIDTEXT=%RECT_X_LETT%"
SET "RECT_Y_GRIDTEXT=%RECT_Y_LETT%"
SET "RECT_W_GRIDTEXT=%RECT_W_LETT%"
SET "RECT_H_GRIDTEXT=%RECT_H_LETT%"

SET "FIND_B_GRIDTEXT=%FIND_B_LETT%"
SET "FIND_E_GRIDTEXT=%FIND_E_LETT%"
SET "FIND_A_GRIDTEXT=%FIND_A_LETT%"

SET "FONT_S_GRIDTEXT=6.5"

SET "POSZ_X_GRIDTEXT=120"
SET "POSZ_Y_GRIDTEXT=242.8"

SET "HIDE_X_GRIDTEXT=0"
SET "HIDE_Y_GRIDTEXT=0"
SET "HIDE_W_GRIDTEXT=0"
SET "HIDE_H_GRIDTEXT=0"

SET "GRID_C_GRIDTEXT=I"


rem -------- CONVERTI CODICE ATTO IN BARCODE ---------------------------------------------------------------------------------------------
rem prende i valori impostati nel castomer number lettere (non toccare)
SET "RECT_X_CODE=%RECT_X_LETT%"
SET "RECT_Y_CODE=%RECT_Y_LETT%"
SET "RECT_W_CODE=%RECT_W_LETT%"
SET "RECT_H_CODE=%RECT_H_LETT%"
SET "ZOOM_S_CODE=100"
rem prende i valori impostati nel castomer number lettere (non toccare)
SET "FIND_B_CODE=%FIND_B_LETT%"
SET "FIND_E_CODE=%FIND_E_LETT%"
SET "FIND_A_CODE=%FIND_A_LETT%"
rem ---------Posizione Bar Code Atto -----------------------------
SET "POSZ_X_CODE=120"
SET "POSZ_Y_CODE=244.8"
rem ---------Dimensione Carattere Bar Code Atto-----------------------------
SET "FONT_S_CODE=6.5"
rem ---------Zona da coprire con Bianco (0 nessuna oppure misure dove coprire)-----------------------------
SET "HIDE_X_CODE=0"
SET "HIDE_Y_CODE=0"
SET "HIDE_W_CODE=0"
SET "HIDE_H_CODE=0"
SET "GRID_C_CODE=L"
rem ---------------------------------------------------------------------------------------------------------------------------------------
rem -------- CONVERTI CODICE ATTO IN BARCODE TESTO ------------------------------
SET "RECT_X_BARCODETEXT=%RECT_X_LETT%"
SET "RECT_Y_BARCODETEXT=%RECT_Y_LETT%"
SET "RECT_W_BARCODETEXT=%RECT_W_LETT%"
SET "RECT_H_BARCODETEXT=%RECT_H_LETT%"

SET "FIND_B_BARCODETEXT=%FIND_B_LETT%"
SET "FIND_E_BARCODETEXT=%FIND_E_LETT%"
SET "FIND_A_BARCODETEXT=%FIND_A_LETT%"

SET "FONT_S_BARCODETEXT=8"

SET "POSZ_X_BARCODETEXT=165"
SET "POSZ_Y_BARCODETEXT=248.5"
SET "ZOOM_S_BARCODETEXT=100"

SET "HIDE_X_BARCODETEXT=0"
SET "HIDE_Y_BARCODETEXT=0"
SET "HIDE_W_BARCODETEXT=0"
SET "HIDE_H_BARCODETEXT=0"

SET "GRID_C_BARCODETEXT=rowIndex"

rem -------- GENERA BARCODE AG/AR SULLA LETTERA ------------------------------------------------------------------------------------------
rem ---------Posizione Bar Code ----------------------------
SET "POSZ_X_BARCODE=30"
SET "POSZ_Y_BARCODE=220"
rem per poste Italiane non toccare 
SET "ZOOM_S_BARCODE=100"
rem ---------Dimensione Carattere Bar Code a Barre da non variare-----------------------------
SET "FONT_S_BARCODE=11"
rem ---------Font Barcode da non toccare ----------------------------
SET "FONT_P_BARCODE=C:\Windows\Fonts\tt0646z_.ttf"
rem ---------PARAMETRI DI IMPORTAZIONE DELLA GRIGLIA DA NON TOCCARE ----------------------------
rem ---Inserisci "rowIndex" al posto del valore di "GRID_C_BARCODE", per ordinare secondo le righe della griglia
SET "GRID_C_BARCODE=S"
rem --------------------------------------------------------------------------------------------------------------------------------------


rem -------- INSERISCI CAMPO NOTE OPPURE AUTORIZZAZIONE SULLA LETTERA O ALTRO-------------------------------------------------------------

rem -------- AUTORIZZAZIONE MASSIVO e/o RACCOMANDATE -------------------------------------------------------------------------------------
rem ---------Testo da inserire su richiesta sul documento------------------------------------------------------
rem SET "TEXT_V_AUTH=SUD/00473/06.2014/CT"
REM SET "TEXT_V_AUTH=DCOPI2525"
rem ---------Posizione Testo da inserire su richiesta sul documento--------------------------------------------
SET "POSZ_X_AUTH=165"
SET "POSZ_Y_AUTH=242.8"
rem ----------Dimensione Carattere Testo da inserire su richiesta sul documento--------------------------------
SET "FONT_S_AUTH=6.5"
rem --------------------------------------------------------------------------------------------------------------------------------------
rem -------- INSERISCI TESTO AGGIUNTIVO SULLA LETTERA -----------------------
REM SET "TEXT_V_WORD=CENTRO-SUD/00960/04.2024"

SET "POSZ_X_WORD=165"
SET "POSZ_Y_WORD=244.8"

SET "FONT_S_WORD=6.5"

rem -------- GENERA DATAMATRIX SULLA LETTERA ---------------------------------------------------------------------------------------------
rem -------- Posizione DATAMATRIX SULLA LETTERA ------------------------------
SET "POSZ_X_DATAMATRIX=160"
SET "POSZ_Y_DATAMATRIX=247.8"
rem valore di defoult 150 zoom
SET "ZOOM_S_DATAMATRIX=160"
rem -------- Font DATAMATRIX SULLA LETTERA non toccare ------------------------------
SET "FONT_S_DATAMATRIX=0"
SET "GRID_C_DATAMATRIX=%GRID_C_BARCODE%"
rem --------------------------------------------------------------------------------------------------------------------------------------

rem -------- GENERA DATAMATRIX_PM SULLA LETTERA ------------------------------
SET "POSZ_X_DATAMATRIX_PM=115"
SET "POSZ_Y_DATAMATRIX_PM=242.8"
SET "ZOOM_S_DATAMATRIX_PM=175"

SET "FONT_S_DATAMATRIX_PM=0"
SET "GRID_C_DATAMATRIX_PM=AE"
rem -----------------------------------------------------------------------

rem --------------------------------------------------------------------------------------------------------------------------------------
rem PARAMETRI GRIGLIA PER: 

rem 1) importare i dati da griglia e scriverli su FILE/ 

SET "GRID=%~1\Esportazione.xlsx"
rem colonna con valori univoci:
SET "GRID_C_UNIQUE=S"

rem 2) Ordinare la stampa dei Pdf in Base alla griglia, definendo il customer number in parametri lettera e bollettini customer number. 

rem da non toccare 
SET "GRID_C_FILENAME=rowIndex"
rem --------------------------------------------------------------------------------------------------------------------------------------


rem -------- SPOSTA INDIRIZZO ------------------------------------------------------------------------------------------------------------
SET "RECT_X_INDZ=104"
SET "RECT_Y_INDZ=210"
SET "RECT_W_INDZ=107"
SET "RECT_H_INDZ=40"

rem --FORMULA PER FORMATTARE IL TESTO--SET "FIND_B_INDZ=(?s)(?:\s*([^\n]+?)\s*(\n|$)+)?(?:\s*([^\n]+?)\s*(\n|$)+)?(?:\s*([^\n]+?)\s*(\n|$)+)?(?:\s*([^\n]+?)\s*(\n|$)+)?(?:\s*([^\n]+?)\s*(\n|$)+)?"
SET "FIND_B_INDZ=(?p1)"
SET "FIND_E_INDZ=.+"
SET "FIND_A_INDZ=\*[A-Z]{2}[0-9]+\*"

SET "FONT_S_INDZ=10"
SET "LONG_W_INDZ=0"
SET "LONG_S_INDZ=8"

SET "POSZ_X_INDZ=135"
SET "POSZ_Y_INDZ=256"
SET "POSZ_W_INDZ=300"
SET "POSZ_H_INDZ=300"

SET "HIDE_X_INDZ=%RECT_X_INDZ%"
SET "HIDE_Y_INDZ=%RECT_Y_INDZ%"
SET "HIDE_W_INDZ=%RECT_W_INDZ%"
SET "HIDE_H_INDZ=%RECT_H_INDZ%"
rem -------------------------------------------------------------------------------------------------------------------------------------

rem -------- SPOSTA TESTO ------------------------------------------------------------------------------------------------------------
SET "RECT_X_TEXT=104"
SET "RECT_Y_TEXT=210"
SET "RECT_W_TEXT=107"
SET "RECT_H_TEXT=40"

SET "FIND_B_TEXT=(?p1)"
SET "FIND_E_TEXT=.+"
SET "FIND_A_TEXT=\*[A-Z]{2}[0-9]+\*"

SET "FONT_S_TEXT=10"

SET "POSZ_X_TEXT=135"
SET "POSZ_Y_TEXT=256"

SET "HIDE_X_TEXT=%RECT_X_TEXT%"
SET "HIDE_Y_TEXT=%RECT_Y_TEXT%"
SET "HIDE_W_TEXT=%RECT_W_TEXT%"
SET "HIDE_H_TEXT=%RECT_H_TEXT%"
rem -------------------------------------------------------------------------------------------------------------------------------------

rem -------- INSERISCI IMMAGINE -----------------------
SET "RECT_X_IMAG=0"
SET "RECT_Y_IMAG=0"
SET "RECT_W_IMAG=210"
SET "RECT_H_IMAG=300"

SET "FIND_B_IMAG=(?p1)"
SET "FIND_E_IMAG=.*"
SET "FIND_A_IMAG="

SET "SRCS_P_IMAG=%~1\immagine.png"

SET "POSZ_X_IMAG=30"
SET "POSZ_Y_IMAG=290"
SET "POSZ_W_IMAG=33.4"
SET "POSZ_H_IMAG=12"
rem -----------------------------------------------------------------------

rem -------- GENERA OMR -----------------------------------------------------------------------------------------------------------------
rem POSIZIONE CODICE OMR --------------------------------------------------
SET "POSZ_X_OMRS=200.5"
SET "POSZ_Y_OMRS=145"

rem MARGINI/ZOOM nelle pagine in cui appare l'OMR -------------------------
rem PRIMO SEARCH:
SET "RECT_X_OMRP=%MATCH_RECT_X_PAGA%"
SET "RECT_Y_OMRP=%MATCH_RECT_Y_PAGA%"
SET "RECT_W_OMRP=%MATCH_RECT_W_PAGA%"
SET "RECT_H_OMRP=%MATCH_RECT_H_PAGA%"

SET "FIND_B_OMRP=(?n)%MATCH_FIND_B_PAGA%"
SET "FIND_E_OMRP=%MATCH_FIND_E_PAGA%"
SET "FIND_A_OMRP=%MATCH_FIND_A_PAGA%"

rem SECONDO SEARCH se si verifica il PRIMO:
SET "RECT_X_OMRS=191"
SET "RECT_Y_OMRS=125"
SET "RECT_W_OMRS=22"
SET "RECT_H_OMRS=22"

SET "FIND_B_OMRS=(?oJob)(?OBJECTS_ALL)"
SET "FIND_E_OMRS=.+"
SET "FIND_A_OMRS="

rem MARGINI/ZOOM se vengono soddisfatti PRIMO e SECONDO match:
SET "PAGE_T_OMRS=0"
SET "PAGE_L_OMRS=0"
SET "PAGE_Z_OMRS=100"
rem ---------------------------------------------------------------------------------------------------------------------------------------


rem -------- NASCONDI ZONA -----------------------------------------------------------------------------------------------------------------
SET "RECT_X_ZONE=100"
SET "RECT_Y_ZONE=200"
SET "RECT_W_ZONE=200"
SET "RECT_H_ZONE=40"

SET "FIND_B_ZONE=(?p1)\*"
SET "FIND_E_ZONE=[A-Z]{2}[0-9]+"
SET "FIND_A_ZONE=\*"

SET "POSZ_X_ZONE=100"
SET "POSZ_Y_ZONE=200"

SET "HIDE_X_ZONE=%RECT_X_ZONE%"
SET "HIDE_Y_ZONE=%RECT_Y_ZONE%"
SET "HIDE_W_ZONE=%RECT_W_ZONE%"
SET "HIDE_H_ZONE=%RECT_H_ZONE%"
rem ---------------------------------------------------------------------------------------------------------------------------------------


rem -------- PARAMETRI ELIMINA PAGINE -----------------------------------------------------------------------------------------------------
SET "RECT_X_VOID=0"
SET "RECT_Y_VOID=0"
SET "RECT_W_VOID=210"
SET "RECT_H_VOID=297"

SET "FIND_B_VOID=(?n)(?OBJECTS_ALL)"
SET "FIND_E_VOID=[^\s]+"
SET "FIND_A_VOID="
rem ---------------------------------------------------------------------------------------------------------------------------------------

rem -------- PARAMETRI ESCLUDI PAGINE ----------------------------------------------------
SET "RECT_X_SKIP=0"
SET "RECT_Y_SKIP=0"
SET "RECT_W_SKIP=0"
SET "RECT_H_SKIP=0"

SET "FIND_B_SKIP="
SET "FIND_E_SKIP="
SET "FIND_A_SKIP="
rem -----------------------------------------------------------------------
REM ----- LIMITE A 38 CARATTERI -------
rem -------- PARAMETRI INSERIMENTO PAGINA DA GRIGLIA --------------------------------------------------------------------------------------
SET "RECT_X_FXLS=%RECT_X_LETT%"
SET "RECT_Y_FXLS=%RECT_Y_LETT%"
SET "RECT_W_FXLS=%RECT_W_LETT%"
SET "RECT_H_FXLS=%RECT_H_LETT%"

SET "FIND_B_FXLS=(?p1)%FIND_B_LETT%"
SET "FIND_E_FXLS=%FIND_E_LETT%"
SET "FIND_A_FXLS=%FIND_A_LETT%"

SET "FONT_S_FXLS=10"
SET "POSZ_X_FXLS=115"
SET "POSZ_Y_FXLS=235"

SET "GRID_F_FXLS={V}\n{W} {X}\n{AA} {Y} {Z}\n\n\n\n\n\n\n\n\n\n\n\n\n*{A}*"
SET "GRID_C_FXLS=V"
SET "GRID_U_FXLS=A"
SET "GRID_M_FXLS=(.*)"

SET "LINE_H_FXLS=4.2"

SET "PAGE_I_FXLS=1"

SET "RELA_C_FXLS=U"

SET "RELA_X_FXLS=13"
SET "RELA_Y_FXLS=182"
SET "RELA_W_FXLS=185"
SET "RELA_H_FXLS=100"

SET "RELA_F_FXLS={H}"
SET "RELA_S_FXLS=6"

rem ----------------------------------------------------------------------------------------------------------------------------------------


rem -------- PARAMETRI INSERIMENTO PAGINE DA FILE PDF --------------------------------------------------------------------------------------
SET "RECT_X_FPDF=0"
SET "RECT_Y_FPDF=0"
SET "RECT_W_FPDF=0"
SET "RECT_H_FPDF=0"

SET "FIND_B_FPDF="
SET "FIND_E_FPDF="
SET "FIND_A_FPDF="

SET "PAGE_I_FPDF=+1"
SET "PAGE_P_FPDF=%~1\extra.pdf"
rem ----------------------------------------------------------------------------------------------------------------------------------------

rem -------- PARAMETRI DUPLEX A -------------------------------------------
SET "RECT_X_DUPLEX_A=0"
SET "RECT_Y_DUPLEX_A=0"
SET "RECT_W_DUPLEX_A=210"
SET "RECT_H_DUPLEX_A=300"

SET "FIND_B_DUPLEX_A=(?oRect)"
SET "FIND_E_DUPLEX_A=CUSTOMER_CODE:DUPLEX_A"
SET "FIND_A_DUPLEX_A="
rem -----------------------------------------------------------------------

rem -------- PARAMETRI DUPLEX B -------------------------------------------
SET "RECT_X_DUPLEX_B=0"
SET "RECT_Y_DUPLEX_B=0"
SET "RECT_W_DUPLEX_B=210"
SET "RECT_H_DUPLEX_B=300"

SET "FIND_B_DUPLEX_B=(?oRect)"
SET "FIND_E_DUPLEX_B=CUSTOMER_CODE:DUPLEX_B"
SET "FIND_A_DUPLEX_B="
rem -----------------------------------------------------------------------

rem -------- PARAMETRI DUPLEX C -------------------------------------------
SET "RECT_X_DUPLEX_C=0"
SET "RECT_Y_DUPLEX_C=0"
SET "RECT_W_DUPLEX_C=210"
SET "RECT_H_DUPLEX_C=300"

SET "FIND_B_DUPLEX_C=(?oRect)"
SET "FIND_E_DUPLEX_C=CUSTOMER_CODE:DUPLEX_C"
SET "FIND_A_DUPLEX_C="
rem -----------------------------------------------------------------------


rem -------- PAGINE ------------------------------------------------------------------------------------------------------------------------
SET "RECT_X_PAGE=0"
SET "RECT_Y_PAGE=180"
SET "RECT_W_PAGE=120"
SET "RECT_H_PAGE=120"

SET "FIND_B_PAGE="
SET "FIND_E_PAGE=.*"
SET "FIND_A_PAGE="
rem ----------------------------------------------------------------------------------------------------------------------------------------

CALL T:\PDFtoPDF\Dev\PDFtoPDF_UNIQUE.bat %1