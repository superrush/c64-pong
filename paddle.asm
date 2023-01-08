checkPaddles: {
    .label buffer = $fe
    
    sei
    lda CIDDRA
    sta buffer

    lda #$c0
    sta CIDDRA
    lda #$80
    sta PORTA
    
    ldy #$80
!:  nop
    dey
    bpl !-

    lda SID+25
    sta paddle1
    lda SID+26
    sta paddle2
    lda PORTA
    sta buttons
    lda buffer
    sta CIDDRA
    cli
    rts
}
