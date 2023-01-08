checkForOut: {
    lda game_state
    cmp #OUT
    beq !+
    rts

!:  jsr incrementScore
    lda score1
    cmp #MAXSCORE
    beq !won+
    lda score2
    cmp #MAXSCORE
    beq !won+
    
    lda #THROW_IN
    sta game_state
    
    rts
!won:
    //change to idle state
    lda #IDLE
    sta game_state
    lda #4
    sta vic.sprite_on

    rts
}

computerPlayer: {
    lda playing
    cmp #NONE
    beq !return+
    cmp #BOTH
    beq !return+
    cmp #LEFT 
    beq !move_right+

!move_left:
    //check for button press
    lda buttons
    and #4
    beq !activate_both+
    //move left player
    lda bally
    sbc #5
    sta player1y
    rts

!move_right:
    //check for button press
    lda buttons
    and #8
    beq !activate_both+
    lda bally
    sbc #5
    sta player2y
    rts

!activate_both:
    lda #BOTH
    sta playing
!return:
    rts
}


