throwInBall: {
    //check game state
    lda game_state
    cmp #THROW_IN
    beq !out+
    cmp #INIT
    beq !init+
    rts

!out:
    //ball was out, play sound
    jsr playSound3

!init:  
    //check if sprite has been turned off
    lda vic.sprite_on
    and #4
    beq !is_off+
    lda #3 //turn ball off
    sta vic.sprite_on
    clc
    lda frame_counter
    adc #25 //pause 25 frames = 1 sec
    sta pause
    rts

!is_off:
    lda frame_counter
    cmp pause
    beq !throw_ball+
    rts

!throw_ball:
    //x-Position in middle of screen
    lda #182
    sta ballx
    lda #0
    sta ballx+1
    //random y-Position
    lda TIME+2
    MinMax(BALLMIN,BALLMAX)
    sta bally
    //diagonal move
    lda #1
    sta ballx_n
    lda #0
    sta ballx_ctr
    //y-direction
    lda TIME+2
    and #1
    bne !+
    lda #$ff
!:  sta balldy
    //turn on sprite
    lda #7
    sta vic.sprite_on
    //set game state to play
    lda #PLAY
    sta game_state
    lda #4
    sta speed
    jsr playSound1
    rts
}

updatePlayerPositions: {
    jsr checkPaddles

    lda paddle1 
    MinMax(PLAYERPOSMIN,PLAYERPOSMAX)
    sta player1y

    lda paddle2
    MinMax(PLAYERPOSMIN,PLAYERPOSMAX)
    sta player2y

    rts
}


moveBall: {
    lda ballx_ctr
    cmp #$ff
    beq !+
    cmp ballx_n
    beq !++
!:  jsr moveBallX
    inc ballx_ctr
    rts
!://move in y-Direction and reset Counter
    lda #0
    sta ballx_ctr
    jsr moveBallY
    rts
}

checkCollision: {
    lda collision_ctr
    beq !+
    dec collision_ctr
    lda vic.collision //reset collision register
    rts
//check for collision
!:  lda vic.collision
    beq !+ //no collision
    lda #$10
    sta collision_ctr
    lda #0
    sta ballx_ctr
    jsr updateYDirection
    jsr invertBallX
    inc speed
!:  rts 
}

updateYDirection: {
    .label temp=$fe
    //.break
    lda ballx+1
    bne !pl2+
    //player 1 hit
    sec
    lda bally
    sbc player1y
    jmp !t+
!pl2: 
    //player 2 hit
    sec
    lda bally
    sbc player2y
!t: sta temp
    sec
    sbc #8
    bpl !down+
    lda #$ff
    sta balldy
    jmp !angle+
!down:
    lda #$01
    sta balldy
!angle:
    //set new angle
    lda temp
    MinMax(0,20)
    lsr
    tax
    lda directions,x
    sta ballx_n
    rts
}

setSpritePositions: {
    // set player positions
    lda player1y
    sta vic.v+1
    lda player2y
    sta vic.v+3

    //set ball position
    lda ballx
    sta vic.v+4
    lda ballx+1
    beq !+
    lda #6      //sprite 1 ist immer rechts, daher 2^1 + 2^2
    sta vic.v+16
    jmp !++
!:  lda #2
    sta vic.v+16 //sprite 1 plus 256 nach rechts

!:  lda bally
    sta vic.v+5
  
    rts
}

moveBallX: {
.label temp=$fe
//compute new position in temp
    clc
    lda ballx
    adc balldx
    sta temp
    lda ballx+1
    adc balldx+1
    sta temp+1

//check position
    sec
    lda temp
    sbc #<24
    lda temp+1
    sbc #>24
    bmi !out+
    sec
    lda temp
    sbc #<340
    lda temp+1
    sbc #>340
    bpl !out+
//position ok
    lda temp
    sta ballx
    lda temp+1
    sta ballx+1
    rts
//ball is out
!out:
    lda game_state
    cmp #PLAY
    bne invertBallX

    lda #OUT
    sta game_state
    rts
}

invertBallX: {
    jsr playSound1
    lda balldx
    eor #$ff
    sta balldx
    inc balldx
    lda balldx+1
    eor #$ff
    sta balldx+1
    rts
}

moveBallY: {
    clc
    lda bally
    adc balldy
    cmp #50
    bcc invertBallY
    cmp #246
    bcs invertBallY
    sta bally
    rts
}

invertBallY: {
    jsr playSound2
    lda balldy
    eor #$ff
    sta balldy
    inc balldy
    rts
}
