//increment score variable based on ball position
incrementScore: {
    sed
    clc

    lda ballx+1
    beq !player2_scores+

!player1_scores:
    lda score1
    adc #1
    sta score1
    jmp !return+

!player2_scores:
    lda score2
    adc #1
    sta score2

!return:
    cld
    jsr showScore
    rts
}
//display score on screen
showScore: {
//score player 1
    lda score1
    and #$0f
    ldx #10
    ldy #0
    jsr printScore
    lda score1
    and #$f0
    lsr
    lsr
    lsr
    lsr
    bne !+
    lda #$0a
!:  ldx #7
    ldy #0
    jsr printScore
//score player 2
    lda score2
    and #$0f
    ldx #30
    ldy #0
    jsr printScore
    lda score2
    and #$f0
    lsr
    lsr
    lsr
    lsr
    bne !+
    lda #$0a
!:  ldx #27
    ldy #0
    jsr printScore
    rts
}

//print score number at x/y coordinate
// a ... number between 0-9
// x ... x-Coordinate
// y ... y-Coordinate
printScore: {
//temporary variables
    .label target = $fc
    .label source = $fe
    pha

//compute target address    
    MoveWord(vic.screen,target)
//add row offset
    tya
    beq col_off
!loop:
    AddByteToWord($28, target)
    dey
    bne !loop-
col_off:
//add column offset
    txa
    AddAToWord(target)

//compute source address
    MoveWord(numbers,source)
    pla
    beq copy
    tax
!loop:
    AddByteToWord($0f, source)
    dex
    bne !loop-

copy:
    ldx #5
!loopx:
    ldy #2
!loopy:
    lda (source),y
    sta (target),y
    dey
    bpl !loopy-
    AddByteToWord($28, target) //advance to next row
    AddByteToWord(3, source)
    dex
    bne !loopx-

    rts
}

