#importonce

.const PLAYERPOSMIN = 50
.const PLAYERPOSMAX = 230
.const BALLMIN = 100
.const BALLMAX = 180
.const MAXSCORE = $11 //binary decimal digit
.enum {IDLE, INIT, THROW_IN, PLAY, OUT}
.enum {NONE, LEFT, RIGHT, BOTH}

.label VIC = $d000
.label SID = $d400
.label PORTA = $dc00
.label CIDDRA = $dc02
.label TIME = $00a0
.enum {BLK, WHT, RED, CYN, PUR, GRN, BLU, YEL}

.namespace vic {
    .label screen = $0400
    .label colorram = $d800
    .label sprite_ptr = 2040
    .label v = $d000
    .label raster = $d012
    .label sprite_on = $d015
    .label collision = $d01e
    .label bordcol = $d020
    .label backcol = $d021
    
}

.namespace kernel {
    .label chrout = $ffd2
}

.macro MoveWord(word, adr) {
    lda #<(word)
    sta adr
    lda #>(word)
    sta adr + 1
}

.macro AddAToWord(adr) {
    clc
    adc adr
    sta adr
    lda #0
    adc adr + 1
    sta adr + 1
}

.macro AddByteToWord(byte,adr) {
    lda #byte
    clc
    adc adr
    sta adr
    lda #0
    adc adr + 1
    sta adr + 1
}

.macro MinMax(min,max) {
    cmp #min
    bcs !+
    lda #min
    jmp !++
!:  cmp #max
    bcc !+
    lda #max
!:  
}