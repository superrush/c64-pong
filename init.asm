initGame: {
    //check for button press
    jsr checkPaddles
    lda buttons
    and #12
    eor #12 //links = 4, rechts = 8
    lsr
    lsr //->links = 1, rechts = 2
    sta playing
    beq !+
    //button has been pressed
    lda #INIT
    sta game_state
    lda #3 //turn on player sprites
    sta vic.sprite_on
    lda #0  //reset score
    sta score1
    sta score2
    jsr showScore
    clc 
    lda frame_counter
    adc #25
    sta pause //init pause
!:  rts
}

initScreen: {
    //Initialize Screen
    lda #BLK
    sta vic.bordcol
    sta vic.backcol
    
    ldy #WHT
    jsr clearScreen
    
    //draw middle line
.label scr = $fe
    MoveWord(vic.screen+19,$fe)    
    ldx #0
    ldy #25
!:  lda #124
    sta (scr,x)
    AddByteToWord($28,scr)
    dey
    bne !-

    //Initialize Sprites
    lda #(player/64)
    sta vic.sprite_ptr
    sta vic.sprite_ptr+1
    lda #(ball / 64)
    sta vic.sprite_ptr+2
    //set sprite colors
    lda #WHT
    sta vic.v+39
    sta vic.v+40
    sta vic.v+41
    //turn sprites 1-2 on
    lda #4
    sta vic.v+21

    lda #24
    sta vic.v+0
    lda #64
    sta vic.v+2

    jsr setSpritePositions
    rts
}

//clear screen and fill colorram with value in y register
clearScreen: {
    ldx #$00
    loop:
    lda #$20
    sta vic.screen,x
    sta vic.screen+$0100,x
    sta vic.screen+$0200,x
    sta vic.screen+$0300,x
    tya
    sta vic.colorram,x
    sta vic.colorram+$0100,x
    sta vic.colorram+$0200,x
    sta vic.colorram+$0300,x
    inx
    bne loop
    rts
}
