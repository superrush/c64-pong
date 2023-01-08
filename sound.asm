resetSID: {
    lda #0
    ldx #25
loop:
    dex
    sta SID,x
    bne loop

    rts
}

playSound1: {
    lda #9  //Attack/Decay
    sta SID+5 
    lda #9 //Sustain/Release
    sta SID+6
    lda #15 //Volume
    sta SID+24

    lda #50 //High frequency
    sta SID+1
    lda #100 //Low frequency
    sta SID

    lda #17 //Wave form
    sta SID+4
    lda frame_counter
    clc
    adc #5
    sta sound_timer
    rts
}

playSound2: {
    lda #9
    sta SID+5
    lda #9
    sta SID+6
    lda #15
    sta SID+24
    lda #30
    sta SID+1
    lda #100
    sta SID
    lda #17
    sta SID+4
    lda frame_counter
    clc
    adc #5
    sta sound_timer
    rts
}

playSound3: {
    lda #15  //Attack/Decay
    sta SID+5 
    lda #9 //Sustain/Release
    sta SID+6
    lda #15 //Volume
    sta SID+24

    lda frame_counter
    and #1
    beq !+
    lda #25
    jmp !++
!:  lda #20 //High frequency
!:  sta SID+1
    lda #100 //Low frequency
    sta SID

    lda #33 //Wave form
    sta SID+4
    lda frame_counter
    clc
    adc #5
    sta sound_timer
    rts
}

stopSound: {
    lda frame_counter
    cmp sound_timer
    bne !+
    jsr resetSID
!:  rts
}