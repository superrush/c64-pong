//
// PONG Game
// (c) superrush 2023
//

#import "definitions.asm"

BasicUpstart2(main)
    .align $0100
    * = * "Pong Program"

#import "init.asm"
#import "game.asm"
#import "sprites.asm"
#import "score.asm"
#import "paddle.asm"
#import "sound.asm"
#import "data.asm"

main: {
    jsr initScreen
    jsr resetSID
    jsr showScore
    lda #IDLE
    sta game_state

main_loop:
!:  lda vic.raster
    cmp #251
    bne !-
    inc frame_counter
    //inc vic.bordcol
    lda speed
    sta counter

repeat:  
    lda game_state
    cmp #IDLE
    beq idle
    cmp #INIT
    beq throw
    cmp #THROW_IN
    beq throw
    cmp #PLAY
    beq play

idle:
    jsr moveBall
    jsr setSpritePositions
    jsr initGame
    jmp next

throw:    
    jsr throwInBall
    jsr updatePlayerPositions
    jsr setSpritePositions
    jmp next

play:
    jsr moveBall
    jsr checkForOut
    jsr updatePlayerPositions
    jsr computerPlayer
    jsr setSpritePositions
    jsr checkCollision

next:
    jsr stopSound
    dec counter
    bne repeat

    //dec vic.bordcol
    jmp main_loop

end:
    rts
}

