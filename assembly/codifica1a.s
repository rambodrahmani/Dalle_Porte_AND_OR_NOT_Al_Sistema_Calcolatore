##
#
# File: codifica1a.s
#       Programma codifica1 (prima nuova versione del programma codifica):
#       - due file: il primo contiene il programma principale, il secondo
#         un sottoprogramma esamina, utilizzato dal primo file.
#
#       Il programma principale:
#       - legge caratteri fino alla fine della linea;
#       - per ogni carattere, oltre a stamparlo, richiama il sottoprogramma
#         esamina, quindi stampa il risultato prodotto da quest'ultimo.
#
#       Il sottoprogramma esamina:
#       - restituisce 8 caratteri in codifica ASCII, corrispondenti agli 8 bit
#         della codifica del carattere ricevuto.
#
#       Trasmissione dei dati fra programma e sottoprogramma:
#       - due variabili alfa e beta definite nel secondo file (esterno nel primo
#         file e globali nel secondo);
#         - alfa: contiene il codice del carattere, che il sottoprogramma deve
#           esaminare;
#         - beta: contiene l'indirizzo di una variabile array di 8 byte, dove il
#           sottoprogramma deve porre il risultato;
#       - il programma principale pone i dati in alfa e beta, quindi chiama
#         esamina.
#
#       Esempio di utilizzo:
#
#       [rambodrahmani@rr-workstation assembly]$ ./codifica 
#       rambod
#       r 01110010
#       a 01100001
#       m 01101101
#       b 01100010
#       o 01101111
#       d 01100100
#
# Author: Rambod Rahmani <rambodrahmani@autistici.org>
#         Created on 07/05/2019.
#
##

.INCLUDE "util.s"

.EXTERN alfa, beta, esamina

.DATA
    kappa:  .fill   8,  1

.GLOBAL _start

.TEXT
_start:

ancora:
    CALL    tastiera        # leggi il carattere digitato su tastiera in %AL
    CMPB    $'\n',  %AL     # se il carattere letto corrisponde al nuova linea
    JE      fine            # salta a fine
    MOVB    %AL,    %BL     # altrimenti, sposta il carattere letto in %BL
    CALL    video           # stampa a video il contenuto di %BL
    MOVB    $' ',   %BL     # mette in %BL la codifica ASCII di ' '
    CALL    video
    MOVB    %AL,    alfa(%RIP)
    LEAQ    kappa(%RIP), %RAX
    MOVQ    %RAX,   beta(%RIP)
    CALL    esamina
    LEAQ    kappa(%RIP), %RAX
    MOVQ    $0,     %RSI

ripeti:
    MOVB    (%RAX, %RSI), %BL
    CALL    video
    INCQ    %RSI
    CMPQ    $8, %RSI
    JB      ripeti
    MOVB    $'\n',  %BL
    CALL    video
    JMP     ancora

fine:
    JMP uscita

