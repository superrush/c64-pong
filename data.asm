.align $0100
    * = *   "Data Segment"

numbers:
.byte 108,98,123, 225,32,97, 225, 32, 97, 225,32,97, 124,226,126 //0
.byte  32,32,123,  32,32,97,  32, 32, 97,  32,32,97,  32, 32,126 //1
.byte 108,98,123,  32,32,97, 225,226,126, 225,32,32, 124,226,126 //2
.byte 108,98,123,  32,32,97, 124,226, 97,  32,32,97, 124,226,126 //3
.byte 108,32,123, 225,32,97, 124,226, 97,  32,32,97,  32, 32,126 //4
.byte 108,98,123, 225,32,32, 124,226, 97,  32,32,97, 124,226,126 //5
.byte 108,98,123, 225,32,32, 225,226, 97, 225,32,97, 124,226,126 //6
.byte 108,98,123,  32,32,97,  32, 32, 97,  32,32,97,  32, 32,126 //7
.byte 108,98,123, 225,32,97, 225,226, 97, 225,32,97, 124,226,126 //8
.byte 108,98,123, 225,32,97, 124,226, 97,  32,32,97, 124,226,126 //9
.fill 5,[32,32,32] //leer

.align $0100 
    * = *   "Sprite Data"

player:
.fill 21,[0,60,0]
.byte 0

ball:
.fill 5,[240,0,0]
.fill 16,[0,0,0]
.byte 0

    * = *   "Global Variables"
frame_counter: .byte 0
player1y: .byte 100
player2y: .byte 150
score1: .byte 0
score2: .byte 0
ballx: .byte 200, 0
balldx: .byte 1, 0
bally: .byte 200
balldy: .byte 1
ballx_ctr: .byte 0
ballx_n: .byte 1 //number of movements in x-direction before y-direction
// ballx_n=ff -> no movement in y direction
collision_ctr: .byte 0
speed: .byte 4
counter: .byte 0
paddle1: .byte 0
paddle2: .byte 0
buttons: .byte 0
pause: .byte 0
game_state: .byte 0
directions: .byte 1,1,2,2,3,$ff,3,2,2,1,1
sound_timer: .byte 0
playing: .byte 0