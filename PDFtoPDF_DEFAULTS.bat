@echo off
setlocal DisableDelayedExpansion
ENDLOCAL

rem -------- LEGENDA ------------------------------------------------------
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
rem _U_ = COLONNA GRIGLIA CON VALORE UNIVOCI - U=UNIQUE
rem _M_ = MATCH DA ESTRARRE DAL VALORE - M=MATCH
rem _F_ = FORMATO TESTO DI USCITA - F=FORMAT
rem _V_ = VALORE DEL TESTO - V=VALUE
rem _B_ = VALORE PRIMA - B=BEFORE
rem _E_ = VALORE ESTRAZIONE - E=EXTRACT
rem _A_ = VALORE DOPO - A=AFTER
rem _I_ = PAGINA DOVE INSERIRE - I=INSERT
rem -----------------------------------------------------------------------


rem -------- GLOBALI ------------------------------------------------------
rem 0=NON ESEGUE L'OPERAZIONE
rem 1=ESEGUE L'OPERAZIONE
rem ------
rem GENERA_LOG=0 o 1 - CREA UN FILE LOG.TXT CON QUELLO CHE L'ELABORAZIONE "VEDE"
rem GENERA_BARCODE=AR o AG o 0 - GENERA IL BARCODE SULLA LETTERA
rem SPOSTA_INDIRIZZO=0 o 1 - SPOSTA L'INDIRIZZO IN UNA NUOVA POSIZIONE
rem GENERA_DATAMATRIX=0 o 1 - GENERA IL DATAMATRIX SULLA LETTERA
rem NASCONDI_ZONA=0 o 1 - NASCONDI ZONA DESIDERATA
rem ATTO_IN_BARCODE=0 o 1  - NASCONDE IL CODICE ATTO E LO CONVERTE IN BARCODE
rem ------
SET "PROCEDURA_ACCURATA=0"
SET "RIMUOVI_INUTILIZZATI=1"
SET "RIMUOVI_MODULI=0"
SET "RIMUOVI_MODULI_LETTERA=0"
SET "PROFILO_UNIONE=0"
SET "PAUSA_PRESTAMPA=0"
SET "GENERA_LOG=0"
SET "GENERA_BARCODE=0"
SET "SPOSTA_TESTO=0"
SET "SPOSTA_INDIRIZZO=0"
SET "GENERA_DATAMATRIX=0"
SET "GENERA_DATAMATRIX_PM=0"
SET "ATTO_IN_BARCODE=0"
SET "NASCONDI_ZONA=0"
SET "ELIMINA_PAGINE=0"
SET "ESCLUDI_PAGINE=0"
SET "DISATTIVA_VERTICALE=0"
SET "RINOMINA_FILE=1"
SET "INSERISCI_IMMAGINE=0"
SET "INSERISCI_TESTO=0"
SET "TESTO_DA_GRIGLIA=1"
SET "BARCODE_TEXT=1"
SET "PRINT_SIZE=A4"
SET "FORZA_DESTINATARIO_WHOLESALE=0"
SET "COVER_DUPLEX=1"
SET "PRINT_POSTSCRIPT_FOLDER="
SET "COVER_INDIRIZZO=1"
rem -----------------------------------------------------------------------

rem -------- PARAMETRI GRIGLIA ------------------------------------------------------
SET "GRID=%~1\Esportazione.xlsx"
SET "GRID_C_UNIQUE=A"
SET "GRID_C_PAGES=S"
rem -----------------------------------------------------------------------

rem -------- PARAMETRI COVERSIONE IMMAGINE MATCH ------------------------------------------------------
SET "MATCH_RECT_X_CONV=100"
SET "MATCH_RECT_Y_CONV=240"
SET "MATCH_RECT_W_CONV=100"
SET "MATCH_RECT_H_CONV=20"

SET "MATCH_FIND_B_CONV="
SET "MATCH_FIND_E_CONV=[^\n]+"
SET "MATCH_FIND_A_CONV=\n+DESTINATARIO\s*AVVISO"
rem -----------------------------------------------------------------------

rem -------- PARAMETRI COVERSIONE IMMAGINE ESTRAZIONE ------------------------------------------------------
SET "RECT_X_CONV=100"
SET "RECT_Y_CONV=240"
SET "RECT_W_CONV=100"
SET "RECT_H_CONV=20"

SET "FIND_B_CONV="
SET "FIND_E_CONV=[^\n]+"
SET "FIND_A_CONV=\n+DESTINATARIO\s*AVVISO"

SET "FONT_S_CONV=10"

SET "POSZ_X_CONV=10"
SET "POSZ_Y_CONV=10"
SET "ZOOM_S_CONV=100"

rem -----------------------------------------------------------------------

rem -------- PARAMETRI LETTERA MATCH ------------------------------------------------------
SET "MATCH_RECT_X_LETT=0"
SET "MATCH_RECT_Y_LETT=0"
SET "MATCH_RECT_W_LETT=650"
SET "MATCH_RECT_H_LETT=650"

SET "MATCH_FIND_B_LETT="
SET "MATCH_FIND_E_LETT=.*"
SET "MATCH_FIND_A_LETT="
rem -----------------------------------------------------------------------

rem -------- PARAMETRI LETTERA ESTRAZIONE ------------------------------------------------------
SET "RECT_X_LETT=106"
SET "RECT_Y_LETT=210"
SET "RECT_W_LETT=107"
SET "RECT_H_LETT=21"

SET "FIND_B_LETT=(?p1)\*"
SET "FIND_E_LETT=[A-Z]{2}[0-9]+"
SET "FIND_A_LETT=\*"

SET "TRAY_N_LETT="
SET "SCAL_E_LETT="
SET "DPI_N_LETT=0"
rem -----------------------------------------------------------------------

rem -------- PARAMETRI PAGAMENTO MATCH ------------------------------------------------------
SET "MATCH_RECT_X_PAGA=0"
SET "MATCH_RECT_Y_PAGA=0"
SET "MATCH_RECT_W_PAGA=650"
SET "MATCH_RECT_H_PAGA=650"

SET "MATCH_FIND_B_PAGA="
SET "MATCH_FIND_E_PAGA=.*"
SET "MATCH_FIND_A_PAGA="
rem -----------------------------------------------------------------------

rem -------- PARAMETRI PAGAMENTO ESTRAZIONE ----------------------------------------------------
SET "RECT_X_PAGA=0"
SET "RECT_Y_PAGA=0"
SET "RECT_W_PAGA=650"
SET "RECT_H_PAGA=650"

SET "FIND_B_PAGA="
SET "FIND_E_PAGA=[A-Z]{2}[0-9]+"
SET "FIND_A_PAGA=[\s]*(?:123|896|451)[ ]*>"

SET "SCAL_E_PAGA="
SET "TRAY_N_PAGA="
SET "DPI_N_PAGA=200"
rem -----------------------------------------------------------------------

rem -------- MARGINI BOZZA/PRE-STAMPA -------------------------------------
SET "PREV_T_LETT=0"
SET "PREV_L_LETT=0"
SET "PREV_Z_LETT=100"

SET "PREV_T_PAGA=0"
SET "PREV_L_PAGA=0"
SET "PREV_Z_PAGA=100"

SET "PREV_T_ALLS=0"
SET "PREV_L_ALLS=0"
SET "PREV_Z_ALLS=100"
rem -----------------------------------------------------------------------

rem -------- MARGINI CANO -------------------------------------------------
SET "CANO_T_LETT=0"
SET "CANO_L_LETT=0"
SET "CANO_Z_LETT=100"

SET "CANO_T_PAGA=0"
SET "CANO_L_PAGA=0"
SET "CANO_Z_PAGA=100"

SET "CANO_T_ALLS=0"
SET "CANO_L_ALLS=0"
SET "CANO_Z_ALLS=100"
rem -----------------------------------------------------------------------

rem -------- MARGINI RICO -------------------------------------------------
SET "RICO_T_LETT=0"
SET "RICO_L_LETT=0"
SET "RICO_Z_LETT=100"

SET "RICO_T_PAGA=0"
SET "RICO_L_PAGA=0"
SET "RICO_Z_PAGA=100"

SET "RICO_T_ALLS=0"
SET "RICO_L_ALLS=0"
SET "RICO_Z_ALLS=100"
rem -----------------------------------------------------------------------

rem -------- MARGINI Stampa su File ---------------------------------------
SET "FILE_T_LETT=0"
SET "FILE_L_LETT=0"
SET "FILE_Z_LETT=100"

SET "FILE_T_PAGA=0"
SET "FILE_L_PAGA=0"
SET "FILE_Z_PAGA=100"

SET "FILE_T_ALLS=0"
SET "FILE_L_ALLS=0"
SET "FILE_Z_ALLS=100"
rem -----------------------------------------------------------------------

rem -------- MARGINI Stampa su OCT ---------------------------------------
SET "OCTS_T_LETT=0"
SET "OCTS_L_LETT=0"
SET "OCTS_Z_LETT=100"

SET "OCTS_T_PAGA=0"
SET "OCTS_L_PAGA=0"
SET "OCTS_Z_PAGA=100"

SET "OCTS_T_ALLS=0"
SET "OCTS_L_ALLS=0"
SET "OCTS_Z_ALLS=100"
rem -----------------------------------------------------------------------

rem -------- CONVERTI CODICE ATTO IN BARCODE ------------------------------
SET "RECT_X_CODE=106"
SET "RECT_Y_CODE=210"
SET "RECT_W_CODE=107"
SET "RECT_H_CODE=21"

SET "FIND_B_CODE=(?p1)\*"
SET "FIND_E_CODE=[A-Z]{2}[0-9]+"
SET "FIND_A_CODE=\*"

SET "FONT_S_CODE=8"

SET "POSZ_X_CODE=120"
SET "POSZ_Y_CODE=225"
SET "ZOOM_S_CODE=100"

SET "HIDE_X_CODE=%RECT_X_CODE%"
SET "HIDE_Y_CODE=%RECT_Y_CODE%"
SET "HIDE_W_CODE=%RECT_W_CODE%"
SET "HIDE_H_CODE=%RECT_H_CODE%"

SET "GRID_C_CODE="

rem -------- CONVERTI CODICE ATTO IN BARCODE TESTO ------------------------------
SET "RECT_X_BARCODETEXT=%RECT_X_LETT%"
SET "RECT_Y_BARCODETEXT=%RECT_Y_LETT%"
SET "RECT_W_BARCODETEXT=%RECT_W_LETT%"
SET "RECT_H_BARCODETEXT=%RECT_H_LETT%"

SET "FIND_B_BARCODETEXT=%FIND_B_LETT%"
SET "FIND_E_BARCODETEXT=%FIND_E_LETT%"
SET "FIND_A_BARCODETEXT=%FIND_A_LETT%"

SET "FONT_S_BARCODETEXT=8"

SET "POSZ_X_BARCODETEXT=120"
SET "POSZ_Y_BARCODETEXT=225"
SET "ZOOM_S_BARCODETEXT=100"

SET "HIDE_X_BARCODETEXT=%RECT_X_BARCODETEXT%"
SET "HIDE_Y_BARCODETEXT=%RECT_Y_BARCODETEXT%"
SET "HIDE_W_BARCODETEXT=%RECT_W_BARCODETEXT%"
SET "HIDE_H_BARCODETEXT=%RECT_H_BARCODETEXT%"

SET "GRID_C_BARCODETEXT="

rem -------- INSERISCI TESTO DA GRIGLIA ------------------------------
SET "RECT_X_GRIDTEXT=%RECT_X_LETT%"
SET "RECT_Y_GRIDTEXT=%RECT_Y_LETT%"
SET "RECT_W_GRIDTEXT=%RECT_W_LETT%"
SET "RECT_H_GRIDTEXT=%RECT_H_LETT%"

SET "FIND_B_GRIDTEXT=%FIND_B_LETT%"
SET "FIND_E_GRIDTEXT=%FIND_E_LETT%"
SET "FIND_A_GRIDTEXT=%FIND_A_LETT%"

SET "FONT_S_GRIDTEXT=8"

SET "POSZ_X_GRIDTEXT=120"
SET "POSZ_Y_GRIDTEXT=225"

SET "HIDE_X_GRIDTEXT=%RECT_X_GRIDTEXT%"
SET "HIDE_Y_GRIDTEXT=%RECT_Y_GRIDTEXT%"
SET "HIDE_W_GRIDTEXT=%RECT_W_GRIDTEXT%"
SET "HIDE_H_GRIDTEXT=%RECT_H_GRIDTEXT%"

SET "GRID_C_GRIDTEXT="
rem -----------------------------------------------------------------------
rem -------- COVER INDIRIZZO ------------------------------

SET "RECT_X_GRIDADDRESS=%RECT_X_LETT%"
SET "RECT_Y_GRIDADDRESS=%RECT_Y_LETT%"
SET "RECT_W_GRIDADDRESS=%RECT_W_LETT%"
SET "RECT_H_GRIDADDRESS=%RECT_H_LETT%"

SET "FIND_B_GRIDADDRESS=%FIND_B_LETT%"
SET "FIND_E_GRIDADDRESS=%FIND_E_LETT%"
SET "FIND_A_GRIDADDRESS=%FIND_A_LETT%"

SET "FONT_S_GRIDADDRESS=10"

SET "LINE_H_GRIDADDRESS=4.2"

SET "POSZ_X_GRIDADDRESS=120"
SET "POSZ_Y_GRIDADDRESS=239"
SET "POSZ_W_GRIDADDRESS=300"
SET "POSZ_H_GRIDADDRESS=300"

SET "HIDE_X_GRIDADDRESS=0"
SET "HIDE_Y_GRIDADDRESS=0"
SET "HIDE_W_GRIDADDRESS=0"
SET "HIDE_H_GRIDADDRESS=0"

SET "GRID_C_GRIDADDRESS={V::UPPER::SPLITJOIN:(?<=\G.<#37#>):-\n}\n{AB::UPPER::REPLACE:^(.+)$:$1\\n}{W::UPPER::SPLITJOIN:(?<=\G.<#37#>):-\n} {X}\n{AA} {Y} {Z}"

rem -----------------------------------------------------------------------

SET "GRID_C_BARCODETIME=S"

rem -------- GENERA BARCODE AG/AR SULLA LETTERA ------------------------------------------------
SET "POSZ_X_BARCODE=35"
SET "POSZ_Y_BARCODE=235"
SET "ZOOM_S_BARCODE=100"

SET "FONT_S_BARCODE=11"
SET "FONT_P_BARCODE=C:\Windows\Fonts\tt0646z_.ttf"

SET "GRID_C_BARCODE=S"
rem -----------------------------------------------------------------------

rem -------- INSERISCI AUTORIZZAZIONE SULLA LETTERA -----------------------
SET "TEXT_V_AUTH="

SET "POSZ_X_AUTH=111"
SET "POSZ_Y_AUTH=230"

SET "FONT_S_AUTH=15"
rem -----------------------------------------------------------------------

rem -------- INSERISCI TESTO AGGIUNTIVO SULLA LETTERA -----------------------
SET "TEXT_V_WORD="

SET "POSZ_X_WORD=111"
SET "POSZ_Y_WORD=230"

SET "FONT_S_WORD=15"
rem -----------------------------------------------------------------------

rem -------- GENERA DATAMATRIX SULLA LETTERA ------------------------------
SET "POSZ_X_DATAMATRIX=120"
SET "POSZ_Y_DATAMATRIX=245"
SET "ZOOM_S_DATAMATRIX=175"

SET "FONT_S_DATAMATRIX=0"
SET "GRID_C_DATAMATRIX=%GRID_C_BARCODE%"
rem -----------------------------------------------------------------------

rem -------- GENERA DATAMATRIX_PM SULLA LETTERA ------------------------------
SET "POSZ_X_DATAMATRIX_PM=120"
SET "POSZ_Y_DATAMATRIX_PM=245"
SET "ZOOM_S_DATAMATRIX_PM=175"

SET "FONT_S_DATAMATRIX_PM=0"
SET "GRID_C_DATAMATRIX_PM=%GRID_C_BARCODE%"
rem -----------------------------------------------------------------------

rem -------- RINOMINA FILE ---------------------------------------------
SET "GRID_C_FILENAME=%GRID_C_BARCODE%"
rem -----------------------------------------------------------------------

rem -------- SPOSTA INDIRIZZO ---------------------------------------------
SET "RECT_X_INDZ=104"
SET "RECT_Y_INDZ=210"
SET "RECT_W_INDZ=107"
SET "RECT_H_INDZ=40"

SET "FIND_B_INDZ=(?p1)"
SET "FIND_E_INDZ=.+"
SET "FIND_A_INDZ=\*[A-Z]{2}[0-9]+\*"

SET "FONT_S_INDZ=10"
SET "LONG_W_INDZ=25"
SET "LONG_S_INDZ=8"

SET "POSZ_X_INDZ=135"
SET "POSZ_Y_INDZ=256"
SET "POSZ_W_INDZ=300"
SET "POSZ_H_INDZ=300"

SET "HIDE_X_INDZ=%RECT_X_INDZ%"
SET "HIDE_Y_INDZ=%RECT_Y_INDZ%"
SET "HIDE_W_INDZ=%RECT_W_INDZ%"
SET "HIDE_H_INDZ=%RECT_H_INDZ%"
rem -----------------------------------------------------------------------

rem -------- INSERISCI IMMAGINE -----------------------
SET "RECT_X_IMAG=%RECT_X_LETT%"
SET "RECT_Y_IMAG=%RECT_Y_LETT%"
SET "RECT_W_IMAG=%RECT_W_LETT%"
SET "RECT_H_IMAG=%RECT_H_LETT%"

SET "FIND_B_IMAG=(?dict:isCover)DICT_isCover="
SET "FIND_E_IMAG=(.+)"
SET "FIND_A_IMAG=\n"

SET "SRCS_P_IMAG=%~1\immagine.png"

SET "POSZ_X_IMAG=20"
SET "POSZ_Y_IMAG=270"
SET "POSZ_W_IMAG=20"
SET "POSZ_H_IMAG=270"

rem -----------------------------------------------------------------------


rem -------- GENERA OMR ---------------------------------------------------
SET "RECT_X_OMRP=0"
SET "RECT_Y_OMRP=0"
SET "RECT_W_OMRP=650"
SET "RECT_H_OMRP=650"

SET "FIND_B_OMRP=(?n)%FIND_B_PAGA%"
SET "FIND_E_OMRP=%FIND_E_PAGA%"
SET "FIND_A_OMRP=%FIND_A_PAGA%"

SET "RECT_X_OMRS=191"
SET "RECT_Y_OMRS=55"
SET "RECT_W_OMRS=24"
SET "RECT_H_OMRS=24"

SET "FIND_B_OMRS=(?o)(?OBJECTS_ALL)"
SET "FIND_E_OMRS=.+"
SET "FIND_A_OMRS="

SET "PAGE_T_OMRS=0"
SET "PAGE_L_OMRS=-2"
SET "PAGE_Z_OMRS=100"

SET "POSZ_X_OMRS=194"
SET "POSZ_Y_OMRS=57"

rem -----------------------------------------------------------------------

rem -------- NASCONDI ZONA ------------------------------------------------
SET "RECT_X_ZONE=104"
SET "RECT_Y_ZONE=160"
SET "RECT_W_ZONE=107"
SET "RECT_H_ZONE=20"

SET "FIND_B_ZONE=(?p1)\*"
SET "FIND_E_ZONE=[A-Z]{2}[0-9]+"
SET "FIND_A_ZONE=\*"

SET "POSZ_X_ZONE=194"
SET "POSZ_Y_ZONE=57"

SET "HIDE_X_ZONE=%RECT_X_ZONE%"
SET "HIDE_Y_ZONE=%RECT_Y_ZONE%"
SET "HIDE_W_ZONE=%RECT_W_ZONE%"
SET "HIDE_H_ZONE=%RECT_H_ZONE%"
rem -----------------------------------------------------------------------

rem -------- PARAMETRI ELIMINA PAGINE ----------------------------------------------------
SET "RECT_X_VOID=20"
SET "RECT_Y_VOID=20"
SET "RECT_W_VOID=190"
SET "RECT_H_VOID=255"

SET "FIND_B_VOID=(?n)(?OBJECTS_ALL)"
SET "FIND_E_VOID=.+"
SET "FIND_A_VOID="
rem -----------------------------------------------------------------------

rem -------- PARAMETRI ESCLUDI PAGINE ----------------------------------------------------
SET "RECT_X_SKIP=20"
SET "RECT_Y_SKIP=20"
SET "RECT_W_SKIP=190"
SET "RECT_H_SKIP=255"

SET "FIND_B_SKIP=(?n)(?OBJECTS_ALL)"
SET "FIND_E_SKIP=.+"
SET "FIND_A_SKIP="
rem -----------------------------------------------------------------------

rem -------- PARAMETRI INSERIMENTO PAGINA DA GRIGLIA ----------------------
SET "RECT_X_FXLS=106"
SET "RECT_Y_FXLS=210"
SET "RECT_W_FXLS=107"
SET "RECT_H_FXLS=21"

SET "FIND_B_FXLS=(?p1)\*"
SET "FIND_E_FXLS=[A-Z]{2}[0-9]+"
SET "FIND_A_FXLS=\*"

SET "FONT_S_FXLS=10"
SET "POSZ_X_FXLS=106"
SET "POSZ_Y_FXLS=245"

SET "GRID_F_FXLS={V}\n{W} {X}\n{AA} {Y} {Z}\n\n*{A}*"
SET "GRID_G_FXLS={V}\n{W} {X}{AB::UPPER::REPLACE:^(.+)$:\\nLOCALITA' $1}\n{AA} {Y} {Z}\n\n\n\n\n\n\n\n\n\n\n\n\n*{A}*"
SET "GRID_C_FXLS=V"
SET "GRID_U_FXLS=A"
SET "GRID_M_FXLS=(.*)"

SET "LINE_H_FXLS="

SET "PAGE_I_FXLS=1"

SET "RELA_C_FXLS=U"

SET "RELA_X_FXLS=13"
SET "RELA_Y_FXLS=182"
SET "RELA_W_FXLS=185"
SET "RELA_H_FXLS=100"

SET "RELA_F_FXLS={H}"
SET "RELA_S_FXLS=6"

rem -----------------------------------------------------------------------

rem -------- PARAMETRI INSERIMENTO PAGINE DA FILE PDF ---------------------
SET "RECT_X_FPDF=106"
SET "RECT_Y_FPDF=210"
SET "RECT_W_FPDF=107"
SET "RECT_H_FPDF=21"

SET "FIND_B_FPDF=(?p1)\*"
SET "FIND_E_FPDF=[A-Z]{2}[0-9]+"
SET "FIND_A_FPDF=\*"

SET "PAGE_I_FPDF="
SET "PAGE_P_FPDF=%~1\extra.pdf"
rem -----------------------------------------------------------------------

rem -------- PARAMETRI AGGIUNGI PAGINE VUOTE ---------------------
SET "RECT_X_BLNK=0"
SET "RECT_Y_BLNK=0"
SET "RECT_W_BLNK=0"
SET "RECT_H_BLNK=0"

SET "FIND_B_BLNK=(?pL)"
SET "FIND_E_BLNK="
SET "FIND_A_BLNK="

SET "PAGE_I_BLNK=+1"
SET "PAGE_P_BLNK=12"
rem -----------------------------------------------------------------------

rem -------- PARAMETRI DUPLEX A -------------------------------------------
SET "RECT_X_DUPLEX_A=0"
SET "RECT_Y_DUPLEX_A=0"
SET "RECT_W_DUPLEX_A=0"
SET "RECT_H_DUPLEX_A=0"

SET "FIND_B_DUPLEX_A="
SET "FIND_E_DUPLEX_A="
SET "FIND_A_DUPLEX_A="
rem -----------------------------------------------------------------------

rem -------- PARAMETRI DUPLEX B -------------------------------------------
SET "RECT_X_DUPLEX_B=0"
SET "RECT_Y_DUPLEX_B=0"
SET "RECT_W_DUPLEX_B=0"
SET "RECT_H_DUPLEX_B=0"

SET "FIND_B_DUPLEX_B="
SET "FIND_E_DUPLEX_B="
SET "FIND_A_DUPLEX_B="
rem -----------------------------------------------------------------------

rem -------- PARAMETRI DUPLEX C -------------------------------------------
SET "RECT_X_DUPLEX_C=0"
SET "RECT_Y_DUPLEX_C=0"
SET "RECT_W_DUPLEX_C=0"
SET "RECT_H_DUPLEX_C=0"

SET "FIND_B_DUPLEX_C="
SET "FIND_E_DUPLEX_C="
SET "FIND_A_DUPLEX_C="
rem -----------------------------------------------------------------------

rem -------- PARAMETRI DUPLEX D -------------------------------------------
SET "RECT_X_DUPLEX_D=0"
SET "RECT_Y_DUPLEX_D=0"
SET "RECT_W_DUPLEX_D=0"
SET "RECT_H_DUPLEX_D=0"

SET "FIND_B_DUPLEX_D="
SET "FIND_E_DUPLEX_D="
SET "FIND_A_DUPLEX_D="
rem -----------------------------------------------------------------------

rem -------- PAGINE -------------------------------------------------------
SET "RECT_X_PAGE=0"
SET "RECT_Y_PAGE=180"
SET "RECT_W_PAGE=120"
SET "RECT_H_PAGE=120"

SET "FIND_B_PAGE="
SET "FIND_E_PAGE=.*"
SET "FIND_A_PAGE="
rem -----------------------------------------------------------------------

SET "RECT_X_AUTH="
SET "RECT_Y_AUTH="
SET "RECT_W_AUTH="
SET "RECT_H_AUTH="
SET "FIND_B_AUTH="
SET "FIND_E_AUTH="
SET "FIND_A_AUTH="
SET "MATCH_RECT_X_AUTH="
SET "MATCH_RECT_Y_AUTH="
SET "MATCH_RECT_W_AUTH="
SET "MATCH_RECT_H_AUTH="
SET "MATCH_FIND_B_AUTH="
SET "MATCH_FIND_E_AUTH="
SET "MATCH_FIND_A_AUTH="

SET "RECT_X_WORD="
SET "RECT_Y_WORD="
SET "RECT_W_WORD="
SET "RECT_H_WORD="
SET "FIND_B_WORD="
SET "FIND_E_WORD="
SET "FIND_A_WORD="
SET "MATCH_RECT_X_WORD="
SET "MATCH_RECT_Y_WORD="
SET "MATCH_RECT_W_WORD="
SET "MATCH_RECT_H_WORD="
SET "MATCH_FIND_B_WORD="
SET "MATCH_FIND_E_WORD="
SET "MATCH_FIND_A_WORD="
SET "PDFtoPDF_DEFAULTS=OK"
