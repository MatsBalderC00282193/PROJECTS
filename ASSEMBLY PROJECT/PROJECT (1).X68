*-------------------------------------------------------
* NAME C00282193 MATS BALDER
* CYBERSECURITY GROUP B
* DATE 08/03/24
*-------------------------------------------------------
*-------------------------------------------------------
* STARTING MEMORY ADDRESS FOR THE PROGRAMME $1000
*-------------------------------------------------------
    
    ORG $1000

*-------------------------------------------------------
*CHOOSE TO BE A PLUMBER OR A RABBIT 
*-------------------------------------------------------

*-------------------------------------------------------
*VALIDATION VALUES TO BE USED, MODIFY AS NEEDED
*ADD ADDITIONAL VALIDATION VALUES AS REQUIRED
*-------------------------------------------------------
EXIT        EQU 0      USED TO EXIT ASSEMBLY PROGRAM
MIN_POTIONS EQU 1      MIN NUMBER OF POTIONS
MAX_POTIONS EQU 9      MAX NUMBER OF POTIONS
MIN_WEAPONS EQU 1      MIN WEAPONS
MAX_WEAPONS EQU 2      MAX WEAPONS
WIN_POINT   EQU 5      POINTS ACCUMILATED ON WIN
LOSE_POINT  EQU 8      POINTS DEDUCTED ON A LOSS
MINE_LOC    EQU 100    USED BELOW FOR SOME SIMPLE COLLISION DETECTION USING CMP


*START OF GAME
START:
    MOVE.B #200,$8000 ENEMY1HP
    MOVE.W #300,$8100 ENEMY2HP
    MOVE.B #1,$8200 DEFAULT IS SWORD
    MOVE.B #5,$9100 AMOUNT OF POTIONS
    MOVE.L  #1,$6000 
    LEA  $6000,A7
    MOVE.B  #100,$9000 PLAYERHP
    LEA     $4000,A3   ASSIGN ADDRESS A3 TO THAT MEMORY LOCATION
    BSR     WELCOME    BRANCH TO THE WELCOME SUBROUTINE
    BSR     GAME       BRANCH TO THE GAME SUBROUTINE
*GAME LOOP
    ORG     $3000      THE REST OF THE PROGRAM IS TO BE LOCATED FROM 3000 ONWARDS

*-------------------------------------------------------
*-------------------GAME SUBROUTINE---------------------
*-------------------------------------------------------
GAME:
    BSR     GAMELOOP   BRANCH TO GAMELOOP SUBROUTINE
    RTS                RETURN FROM GAME: SUBROUTINE
          
END:
    SIMHALT

*-------------------------------------------------------
*-------------------WELCOME SUBROUTINE------------------
*-------------------------------------------------------
WELCOME:
    LEA     WELCOME_MSG,A1  ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0          MOVE LITERAL 14 TO DO
    TRAP    #15             TRAP AND INTERPRET VALUE IN D0
    RTS                     RETURN FROM WELCOME: SUBROUTINE

*-------------------------------------------------------
*---------GAMEPLAY INPUT VALUES SUBROUTINE--------------
*-------------------------------------------------------    


*-------------------------------------------------------
*----------------GAMELOOP (MAIN LOOP)-------------------
*------------------------------------------------------- 
GAMELOOP:
    BSR     CLEARSCREEN    CLEARS THE SCREEN         
    BRA     GAMEPLAY        BRANCH TO GAMEPLAY SUBROUTINE

*-------------------------------------------------------
*----------------UPDATE QUEST PROGRESS------------------
*  COMPLETE QUEST
*------------------------------------------------------- 

*-------------------------------------------------------
*-----------------DRAW QUEST UPDATES--------------------
* DRAW THE GAME PROGRESS INFORMATION, STATUS REGARDING
* QUEST
*------------------------------------------------------- 

*-------------------------------------------------------
*--------------------POTIONS INVENTORY---------------------
* NUMBER OF POTIONS TO BE USED IN A QUEST 
*------------------------------------------------------- 


*-------------------------------------------------------
*-------------------------WEAPONS-----------------------
* NUMBER OF WEAPONS
*-------------------------------------------------------   
WEAPONS:
     MOVE.B  $8200,D3 *This puts what the current weapon is into D3
    LEA CHANGEWEAPON,A1
    MOVE.B  #14,D0
    TRAP    #15 *all code before this shows change weapon text
    MOVE.B #4,D0
    TRAP #15  
    MOVE.B D1,D1 *takes your input and puts it into D1
    MOVE.B D1,$8200 *you put whats the new weapon into the weapon address location 
    CMP D1,D3 *compare the new weapon you want with the old weapon you have
    BEQ ALREADYUSED *branch if equal to already using weapon
    BNE WEAPONCHANGE *change weapon if not equal 
    CMP D1,D3 
    BEQ ALREADYUSED
    BRA WEAPONS
  
WEAPONCHANGE:
    LEA WEAPONCHANGED,A1 *shows weapon changed text
    MOVE.B  #14,D0
    TRAP    #15 *loads text
    MOVE.B #4,D0
    TRAP #15  *takes input
    BRA FIGHTSCENE *goes back to fight scene

ALREADYUSED:
    LEA ALREADYUSING,A1 *loads already using text
    MOVE.B  #14,D0
    TRAP    #15 *loads text
    MOVE.B  #4,D0
    TRAP #15  *takes input
    BRA WEAPONS *goes back to start of weapons
   
WEAPONS2:
     MOVE.B  $8200,D3 *This puts what the current weapon is into D3
    LEA CHANGEWEAPON,A1
    MOVE.B  #14,D0
    TRAP    #15 *all code before this shows change weapon text
    MOVE.B #4,D0
    TRAP #15  
    MOVE.B D1,D1 *takes your input and puts it into D1
    MOVE.B D1,$8200 *you put whats the new weapon into the weapon address location 
    CMP D1,D3 *compare the new weapon you want with the old weapon you have
    BEQ ALREADYUSED2 *branch if equal to already using weapon
    BNE WEAPONCHANGE2 *change weapon if not equal 
    CMP D1,D3 
    BEQ ALREADYUSED2
    BRA WEAPONS2 WEAPONCHANGE2 * same code as before
  
WEAPONCHANGE2:
    LEA WEAPONCHANGED,A1 *shows weapon changed text
    MOVE.B  #14,D0
    TRAP    #15 *loads text
    MOVE.B #4,D0
    TRAP #15  *takes input
    BRA FIGHTSCENE2 *goes back to fight scene

ALREADYUSED2:
    LEA ALREADYUSING,A1 *loads already using text
    MOVE.B  #14,D0
    TRAP    #15 *loads text
    MOVE.B  #4,D0
    TRAP #15  *takes input
    BRA WEAPONS2 *goes back to start of weapons


    
*-------------------------------------------------------
*---GAME PLAY (QUEST PROGRESS)--------------------------
*------------------------------------------------------- 
*-------------------------------------------------------
*---SCENES--------------------------
*------------------------------------------------------- 

GAMEPLAY:
    BRA     STARTSCREEN  *go to start

STARTSCREEN:
    BSR HUD
    LEA   WEAPONSGIVEN, A1   ; Load the address of WEAPONCHOICE into A1
    MOVE  #14, D0             ; Function code for reading a string from keyboard
    TRAP  #15                 ; Trap to read the string from keyboard
    MOVE  #4, D0              ; Function code for printing a character
    TRAP  #15                 ; Trap to print the entered character
    BSR CLEARSCREEN     *clear screen
    BRA   SCENEPART1  *goes to next scene

SCENEPART1:
    BSR HUD *shows health and how much you have
    LEA SCENE1, A1 *loads scene1 
    MOVE #14,D0
    TRAP #15 *loads text on screen
    MOVE #4,D0
    TRAP #15 *takes input 
    BSR CLEARSCREEN *clears screen
    BRA  SCENEPART2 *branch to next scene
SCENEPART2:
    BSR HUD *shows health and how much you have
    LEA SCENE11, A1 *loads scene
    MOVE.B #0,D1 *make sure it empty
    MOVE #14,D0
    TRAP #15 *shows text on screen
    MOVE #4,D0
    TRAP #15 *take input
    LEA SCENE11CHOICE,A1 * shows choices in scene 
    MOVE #14,D0
    TRAP #15 *loads the choices you have on screen
    MOVE #4,D0
    TRAP #15 *takes input
    CMP  #0,D1
    BEQ SCENEPART3 *if 0 goes to this scenepart3
    CMP  #1,D1
    BEQ SCENEPART4 *if 1 goes to scenepart4
    BNE PICKACHOICE1 *if none picked goes pickachoice and then back to start
    
SCENEPART3:
    BSR CLEARSCREEN * clears screen
    BSR HUD *shows health and how much you have
    LEA SCENE112, A1 *shows scene 
    MOVE.B #0,D6 
    MOVE.B $9100,D6
    ADD.B #1,D6
    MOVE.B D6,$9100
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA  SCENEPART4 *branch to next scene
SCENEPART4:
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows health and how much you have
    MOVE.B #0,D1
    LEA SCENE113, A1 *shows scene
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BSR CLEARSCREEN *clears screen
    CMP  #1,D0
    BRA  SCENEPART5 *goes to next scene
 
    
SCENEPART5:
    BSR HUD *shows health and how much you have
    MOVE.B #0,D1
    LEA SCENE2, A1 *shows scene
    MOVE.B #0,D1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    LEA SCENE2CHOICE,A1 *loads scene
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    CMP  #1,D1
    BEQ  DIARYPICKED1 *goes to scene
    CMP  #0,D1
    BEQ SCENEWITHDESK21 *goes to scene
    BNE PICKACHOICE5 *if nothing picked tells you to 
    
DIARYPICKED1:
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows health and how much you have
    MOVE.B #0,D1
    LEA DIARY1,A1    *loads scene 
    MOVE.B #0,D1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    LEA SCENEDIARY1,A1 *loads scene
    MOVE.B #0,D1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    CMP  #0,D1
    BEQ  SCENEWITHDESK2 *branch if equal to next scene
    CMP  #1,D1
    BRA  SCENEPART6 *branch to scene

SCENEWITHDESK2:
    BSR CLEARSCREEN *clear screen
    BSR HUD *shows health and how much you have
    MOVE.B #0,D1
    LEA  SCENE2DESK,A1  *loads scene
    MOVE.B #0,D6
    MOVE.B $9100,D6
    ADD.B #1,D6
    MOVE.B D6,$9100 
    MOVE.B #0,D1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    CMP  #1,D1
    BEQ  SCENEPART6 *branch if equal to scene
    BNE PICKACHOICE3 *branch if not equal to pick a choice 
SCENEWITHDESK21:
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows health and how much you have
    LEA  SCENE2DESK1,A1   *loads scene
    MOVE.B #0,D6
    MOVE.B $9100,D6
    ADD.B #1,D6
    MOVE.B D6,$9100
    MOVE.B #0,D1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    CMP  #0,D1
    BEQ  DIARYPICKED12 *branch if equal
    CMP  #1,D1
    BRA  SCENEPART6 *branch to scene

DIARYPICKED12:
    BSR CLEARSCREEN *clear screen
    BSR HUD *shows health and how much you have
    MOVE.B #0,D1
    LEA DIARY1,A1  *load scene 
    MOVE.B #0,D1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    LEA SCENEDIARY12,A1 *load scene
    MOVE.B #0,D1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    CMP  #1,D1
    BEQ  SCENEPART6 *branch if equal to next scene
    BNE PICKACHOICE3 *if nothing picked tells you pick something

SCENEPART6:
    BSR HUD *shows health and how much you have
    MOVE.B #0,D1
    LEA SCENE21, A1 *loads scene
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA  FIGHTSCENE *branch to fight
SCENEPART8: 
    BSR HUD *shows health and how much you have
    MOVE.B #0,D1
    LEA SCENE3, A1 *loads scene
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    CMP  #0,D1 read scroll
    BEQ  READSCROLLA *branch if equal to scene
    CMP  #1,D1 search desk
    BEQ  SEARCHDESK3A *branch if equal to scene
    CMP  #2,D1 move ahead
    BEQ SCENEPART10 *branch if equal to scene
    BNE PICKACHOICE8 * if nothing picked tells you to
READSCROLLA: 
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows health and how much you have
    MOVE.B #0,D1
    LEA SCROLL1,A1 *loads scene
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    CMP #0,D1
    BEQ SEARCHDESK3B *branch if equal to scene
    CMP #1,D1
    BEQ SCENEPART10 *branch if equal to scene
    BNE READSCROLLA *if nothing picked goes to start
    
READSCROLLB: 
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows health and how much you have
    MOVE.B #0,D1
    LEA SCROLL2,A1 *loads scene
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15 
    CMP #1,D1
    BEQ SCENEPART10 *branch if equal to scene
    BNE READSCROLLB   *if nothing picked goes to start

SEARCHDESK3A:
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows health and how much health you have
    MOVE.B #0,D1
    LEA  SCENE31,A1  *loads scene
    MOVE.B #0,D6 *checks if d6 empty
    MOVE.B $9100,D6 *loads potion amount into d6
    ADD.B #1,D6 *adds 1 more potion
    MOVE.B D6,$9100  *loads new potion amount to 9100
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15 
    MOVE #4,D0 *takes input
    TRAP #15
    CMP  #0,D1 *checks if 0
    BEQ  READSCROLLB *branch if equal to scene
    CMP  #1,D1 *checks if 1
    BEQ  SCENEPART10 *branch if equal to scene
    BNE PICKACHOICE3 *tells you to pick a choice
SEARCHDESK3B:
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *checks d1 empty
    LEA  SCENE31A,A1   *loads scene
    MOVE.B #0,D6 *check d6 epmty
    MOVE.B $9100,D6 *puts potion amount to d6
    ADD.B #1,D6 *adds new potion
    MOVE.B D6,$9100  *puts new potion amount 9100
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BRA SCENEPART10 

SCENEPART10:
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows hp and amount 
    MOVE.B #0,D1 *checks d1 empty
    LEA  SCENE32,A1    *loads scene
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA FIGHTSCENE2 *goes t ofightscene 2

SCENEPART11:
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *checks d1 empty
    LEA  SCENE4,A1    *loads scene
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA SCENEPART12 *branch to next part
  
SCENEPART12: 
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *shows hp and amount
    LEA SCENE41,A1 *loads scene
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA SCENEPART13 *goes to next part
SCENEPART13:
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *checks d1 empty
    LEA SCENE5,A1 *loads scene
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15 
    BSR CLEARSCREEN *clears screen
    BRA SCENEPART14 *goes next part
SCENEPART14:
    BSR HUD  *shows hp and amount
    MOVE.B #0,D1 *checks d1 empty
    LEA SCENE51,A1 *loads scene
    MOVE.B #0,D1
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA SCENEPART15 *goes next part
SCENEPART15: 
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *checks d1 empty
    LEA SCENE52,A1 *loads scene
    MOVE.B #0,D1
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA SCENEPART16 *goes next part
SCENEPART16:
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *checks d1 empty
    LEA SCENE53,A1 *loads scene
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *screen clear
    BRA SCENEPART17 *goes next part
SCENEPART17:
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *checks d1 empty
    LEA SCENE54,A1 *loads scene
    MOVE.B #0,D1
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA DRAGONFIGHT *goes to dragon fight
DRAGONFIGHT:
    BSR HUD *shows hp and amount
    LEA FIGHTDRAGONSCENE1,A1 *loads scene
    MOVE.B #0,D1 *checks d1 empty
    BSR CLEARSCREEN *clearsscreen
    BSR HUD *shows hp and amount
    LEA DRAGONATTACK1,A1 *loads scene
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR DRAGONHITS1 *goes to subroutine dragonhits
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows hp and amount
    LEA FIGHTDRAGONSCENE2,A1 *loads scene
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows hp and amount
    LEA DRAGONATTACK2,A1 *loads text
    MOVE.B #0,D1
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows hp and amount
    LEA SCENE55,A1 *loads scene
    MOVE.B #0,D1 *checks d1 empty
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows health and how much you have
    LEA FIGHTDRAGONSCENE3,A1 *loads scene
    MOVE.B #0,D1
    MOVE #14,D0 *shows text on screen
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15    
    LEA SCENE56,A1 *loads scene
    MOVE.B #0,D1
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA ENDSCENE *branch to endscene

DRAGONHITS1:
    MOVE.B #0,D1 *check if d1 empty
    MOVE.B $9000,D1 *puts player hp into d1
    SUB #50,D1 *take away 50 from d1
    CMP #0,D1 *checks if 0
    BLE GAMEOVER *if less than goes game over
    MOVE.B D1,$9000 *moves new hp to 9000
    RTS *returns 
*-------------------------------------------------------
*---SCENE FOR IF NO CHOICE PICKED--------------------------
*------------------------------------------------------- 

PICKACHOICE1:
    MOVE.B #0,D1 *checks d1 empty
    LEA PICKACHOICESCREEN,A1 *loads scene
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA SCENEPART2 *branches to top 
PICKACHOICE2:
    MOVE.B #0,D1 *checks d1 empty
    LEA PICKACHOICESCREEN,A1 *loads scene
    MOVE #14,D0 *loads scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA SCENEPART3 *branch to top of scene again

PICKACHOICE3:
    MOVE.B #0,D1 *checks d1 empty
    LEA PICKACHOICESCREEN,A1 *loads scene
    MOVE #14,D0 *shows scene
    TRAP #15 
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA DIARYPICKED1 *back to start

PICKACHOICE5: 
    MOVE.B #0,D1
    LEA PICKACHOICESCREEN,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BSR CLEARSCREEN
    BRA SCENEPART5

PICKACHOICE4:
    MOVE.B #0,D1
    LEA PICKACHOICESCREEN,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BSR CLEARSCREEN
    BRA FIGHTSCENE
    
PICKACHOICE8:
    MOVE.B #0,D1

    LEA PICKACHOICESCREEN,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BSR CLEARSCREEN
    BRA SCENEPART8
PICKACHOICE6:
    MOVE.B #0,D1

    LEA PICKACHOICESCREEN,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BSR CLEARSCREEN
    BRA SCENEPART5
PICKACHOICE11:
    MOVE.B #0,D1
    LEA PICKACHOICESCREEN,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    BSR CLEARSCREEN
    BRA SEARCHDESK3B
   *all these code before just go to top if input isnt picked right
    
*-------------------------------------------------------
*---FIGHT 1 CODE--------------------------
*------------------------------------------------------- 

FIGHTSCENE:
    BSR HUD *shows hp
    MOVE.B #0,D1 *checks d1 empty
    LEA FIGHTCHOICE,A1 *loads scene
    MOVE.B #0,D1
    MOVE.B #14,D0 *shows scene
    TRAP #15
    MOVE.B #4,D0 *takes input
    TRAP #15
    CMP  #0,D1 *checks if 0
    BEQ  CHECKER *goes to if 0
    CMP  #1,D1 *checks if 1
    BEQ  AMOUNTOFPOTIONS *goes to if 1
    CMP  #2,D1 *checks if 2
    BEQ  WEAPONS *goes to if 2
    CMP  #3,D1 *checks if 3
    BEQ  BLOCK *goes to block if 3
    BNE PICKACHOICE4
AMOUNTOFPOTIONS:
    MOVE.B #0,D4
    MOVE.B $9100,D4
    CMP #0,D4
    BEQ POTIONDENY1
    BNE POTIONCHECKER
   
    

POTIONCHECKER:
    MOVE.B #0,D1
    MOVE.B $9000,D1
    CMP #60,D1
    BLE POTIONUSED1
    BGE POTIONDENY
POTIONDENY:
    BSR CLEARSCREEN
    BSR HUD
    MOVE.B #0,D1
    LEA POTIONSNO,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4 ,D0
    TRAP #15
    BRA FIGHTSCENE
POTIONDENY1:
    BSR CLEARSCREEN
    BSR HUD
    MOVE.B #0,D1
    LEA POTIONSNO1,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4 ,D0
    TRAP #15
    BRA FIGHTSCENE
POTIONUSED1:
    MOVE.B #0,D5
    MOVE.B $9100,D5
    SUB #1,D5
    MOVE.B D5,$9100
    BRA POTIONUSED
POTIONUSED:
    BSR CLEARSCREEN
    BSR HUD
    MOVE.B #0,D1
    LEA POTIONDRANK,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    ADD.B #40,$9000
    BRA FIGHTSCENE
CHECKER:
     BRA ENEMYHPCHECK
CHECKER1:
     BRA PLAYERHPCHECK
CHECKER2:
     BRA PLAYERHPCHECK1
PLAYERHPCHECK1:
    CMP #0,$9000
    BLE LOSE
    BGE FIGHTSCENE
PLAYERHPCHECK:
    CMP #0,$9000
    BLE LOSE
    BGE FIGHTSCENE
LOSE:   
    BSR HUD
    MOVE.B #0,D1
    LEA LOSESCENE,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4,D0
    TRAP #15
    BSR CLEARSCREEN
    BRA GAMEOVER
ENEMYATTACKS:
    BSR HUD
    MOVE.B #0,D1
    MOVE.B $9000,D3 *move health from address 900 into d3
    SUB.L #20,D3 *take away 20 from my health in d3
    MOVE.B D3,$9000 * move the new health into address location 9000
    LEA DAMAGEDSCENE,A1 *loads message you been damaged
    MOVE #14,D0
    TRAP #15 *prints text
    MOVE #4,D0
    TRAP #15 *takes input
    BSR CLEARSCREEN
    BRA CHECKER2 *bra to checker2
ATTACKS:
    MOVE.B #0,D5
    MOVE.B $8200,D5
    CMP #1,D5
    BEQ SWORDATTACK
    CMP #2,D5
    BEQ MACEATTACK
    BNE ATTACKS
SWORDATTACK:
    BSR HUD 
    MOVE.B #0,D1
    MOVE.B #0,D4
    MOVE.B $8000,D4
    LEA SWORDATTACKSCENE,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    SUB #35,D4
    MOVE.B D4,$8000
    BSR CLEARSCREEN
    BRA ENEMYATTACKS
MACEATTACK:
    BSR HUD
    MOVE.B #0,D1
    MOVE.B #0,D4
    MOVE.B $8000,D4
    LEA MACEATTACKSCENE,A1
    MOVE #14,D0
    TRAP #15
    MOVE #4,D0
    TRAP #15
    SUB #50,D4
    MOVE.B D4,$8000
    BSR CLEARSCREEN
    BRA ENEMYATTACKS

ENEMYHPCHECK:
    MOVE.B $8000,D7
    CMP #100,D7
    BLE WINSCREEN
    BGE ATTACKS
ENEMYHPCHECK1:
    MOVE.B $8000,D7
    CMP #0,D7
    BEQ WINSCREEN
    BNE FIGHTSCENE
WINSCREEN:
    BSR HUD
    MOVE.B #0,D1
    LEA SCENE22,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4,D0
    TRAP #15
    BSR CLEARSCREEN
    BRA SCENEPART8

    
BLOCK:   
    BSR HUD
    MOVE.B #0,D1
    LEA BLOCKSCENE,A1
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4,D0
    TRAP #15
    BSR CLEARSCREEN
    BRA FIGHTSCENE
    *all comments are the same as fight scene 2
*-------------------------------------------------------
*---CODE FOR FIGHT SCENE 2--------------------------
*------------------------------------------------------- 
  
FIGHTSCENE2:
    BSR HUD *shows health and the amount you have
    MOVE.B #0,D1 *make sure d1 empty
    LEA FIGHTCHOICE,A1 *loads scene
    MOVE.B #0,D1 *make sure d1 empty
    MOVE.B #14,D0 *shows scene on screen
    TRAP #15 
    MOVE.B #4,D0 *takes input
    TRAP #15
    CMP  #0,D1 *checks if choice was 0
    BEQ  CHECKER3 *goes to checker
    CMP  #1,D1 *checks if choice was 1
    BEQ  AMOUNTOFPOTIONS1 *goes to potion screen
    CMP  #2,D1 *checks if choice was 2
    BEQ  WEAPONS2 *goes to weapons screen
    CMP  #3,D1 *checks if choice was 3
    BEQ  BLOCK1 *goes to block screen
    BNE PICKACHOICE4 *if nothing picked tells you to pick something
AMOUNTOFPOTIONS1:
    MOVE.B #0,D4 *checks if d4 empty
    MOVE.B $9100,D4 *moves amount of potions into d4
    CMP #0,D4 *checks if you have potions
    BEQ POTIONDENY2 *branch if equal to scene
    BNE POTIONCHECKER1 *branch if not equal to scene
   
POTIONCHECKER1:
    MOVE.B #0,D1 *checks d1 is empty
    MOVE.B $9000,D1 *puts player health in d1
    CMP #60,D1 *checks if you under 60 hp
    BLE POTIONUSED2 *is less than goes to scene
    BGE POTIONDENY3 *is greater goes to scene
POTIONDENY2:
    BSR CLEARSCREEN *clears screen
    BSR HUD  *shows hp and amount
    MOVE.B #0,D1 *checks d1 is empty
    LEA POTIONSNO1,A1 *loads scene
    MOVE.B #14,D0 *loads scene onto screen
    TRAP #15
    MOVE.B #4 ,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA FIGHTSCENE2 *goes to fight scene
POTIONDENY3:
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows health and amount you have
    MOVE.B #0,D1 *checks if d1 empty
    LEA POTIONSNO,A1 *loads scene
    MOVE.B #14,D0 *shows scene
    TRAP #15
    MOVE.B #4 ,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA FIGHTSCENE2 *branch to fight
POTIONUSED2:
    MOVE.B #0,D5 *check its empty
    MOVE.B $9100,D5 *move amount of potions held into d5
    SUB #1,D5 *take away one as its being used
    MOVE.B D5,$9100 *move new amount into 9100
    BRA POTIONUSED3 *branch to next part
POTIONUSED3:
    BSR CLEARSCREEN *clear screen
    BSR HUD *shows health and your amount
    MOVE.B #0,D1 *checks it empty
    LEA POTIONDRANK,A1 *loads scene
    MOVE #14,D0 *shows scene on screen
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    ADD.B #40,$9000 *adds 40 hp to player health at 9000
    BSR CLEARSCREEN *clears screen
    BRA FIGHTSCENE2 *branch to fightscene2
CHECKER3:
     BRA ENEMYHPCHECK3 *branch to enemyhpcheck3
CHECKER4:
     BRA PLAYERHPCHECK2 *branch to playerhpcheck2
CHECKER5:
     BRA PLAYERHPCHECK3 *branch to playerhpcheck3
PLAYERHPCHECK2:
    CMP #0,$9000 *checks if hp at 0
    BLE LOSE *if less than 0 you go to lose
    BGE FIGHTSCENE2 *if greater go fight scene
PLAYERHPCHECK3:
    CMP #0,$9000 *checks if hp at 0
    BLE LOSE *if lower you go to lose scene
    BGE FIGHTSCENE2 *branch to fight if greater
ENEMYATTACKS2:
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *checks empty
    MOVE.B $9000,D3 *moves hp to d3
    SUB.L #20,D3 *takes 20 away from d3
    MOVE.B D3,$9000 *puts new hp into 9000
    LEA DAMAGEDSCENE,A1 *loads scene 
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen 
    BRA CHECKER4 *branch to checker 4
ATTACKS2:
    MOVE.B #0,D5 *checks d5 empty
    MOVE.B $8200,D5 *puts weapon held into d5
    CMP #1,D5 *checks if its 1 
    BEQ SWORDATTACK2 *if 1 its sword and goes to swordscene
    CMP #2,D5 *checks if its 2
    BEQ MACEATTACK2 *if its 2 its mace and goes to mace scene
    BNE ATTACKS2 *if not equal goes to start again
SWORDATTACK2: 
    BSR CLEARSCREEN *clears screen
    BSR HUD *hp and shows amount
    MOVE.B #0,D1 *checks d1 empty
    MOVE.B #0,D4 *checks d4 empty
    MOVE.W $8100,D4 *moves enemyhp into d4
    LEA SWORDATTACKSCENE,A1 *loads scene
    MOVE #14,D0 *shows scene
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    SUB #35,D4 *takes 35 away from d4
    MOVE.W D4,$8100 *puts new enemy hp into 8100
    BSR CLEARSCREEN *clears screen
    BRA ENEMYATTACKS2 *branch to next part
MACEATTACK2:
    BSR CLEARSCREEN *clears screen
    BSR HUD *hp and amount yo uhave
    MOVE.B #0,D1 *checks d1 empty
    MOVE.B #0,D4 *checks d4 empty
    MOVE.W $8100,D4 *puts enemyhp into d4
    LEA MACEATTACKSCENE,A1 *loads scene
    MOVE #14,D0 *shows scene on screen
    TRAP #15
    MOVE #4,D0 *takes input
    TRAP #15
    SUB #50,D4 *takes 50 from d4
    MOVE.W D4,$8100 *puts new enemyhp into 8100
    BSR CLEARSCREEN *clears screen
    BRA ENEMYATTACKS2 *branch to next part

ENEMYHPCHECK3:
    MOVE.W $8100,D7 *moves enemyhp to d7
    CMP #100,D7 *compares if its 100
    BLE WINSCREEN1 *if less go to win
    BGE ATTACKS2 *it greater to attacks2
WINSCREEN1:
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *checks d1 empty
    LEA SCENE33,A1 *loads scene
    MOVE.B #14,D0 *shows scene
    TRAP #15
    MOVE.B #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA SCENEPART11 *branch to next part

    
BLOCK1:   
    BSR CLEARSCREEN *clears screen
    BSR HUD *shows hp and amount
    MOVE.B #0,D1 *checks d1 empty
    LEA BLOCKSCENE,A1 *loads scene
    MOVE.B #14,D0 *shows scene
    TRAP #15
    MOVE.B #4,D0 *takes input
    TRAP #15
    BSR CLEARSCREEN *clear screen
    BRA FIGHTSCENE2 *branch to next part



ENDSCENE:
    BSR CLEARSCREEN *clears screen
    MOVE.B #0,D1 *checks d1 empty
    LEA ENDSCREEN,A1 *loads scene
    MOVE #14,D0 *shows scene
    TRAP #15
    BRA ENDGAME *branch to endgame
*NOT USED   
CLEARSCREEN: 
    MOVE.B  #11,D0      CLEAR SCREEN
    MOVE.W  #$FF00,D1
    TRAP    #15
    RTS
HUD:
    BSR     CLEARSCREEN                ; clear the screen
    MOVE.L  #0,D1
    LEA     HEATLH_MSG,     A1          ; load health message to A1
    MOVE.B  #14,            D0
    TRAP    #15
    MOVE.B  $9000,  D1     ; load player health to D1
    MOVE.B  D4, PLAYERHEALTH
    MOVE.B  #3,             D0
    TRAP    #15
    LEA     PLAYERHEALTH,A1
    MOVE.B  #14 ,D0
    TRAP #15
    LEA     NEWLINE,       A1          ; load new line
    MOVE.B  #14,            D0
    TRAP    #15
    RTS
    
GAMEOVER:
    LEA GAMEOVERSCENE,A1 *loads scene
    MOVE.B #14,D0 *shows scene on screen
    TRAP #15
    MOVE.B #4,D0 *TAKES INPUT
    TRAP #15
    BSR CLEARSCREEN *clears screen
    BRA ENDGAME *bra to endgame

*-------------------------------------------------------
*-----------------HEADS UP DISPLAY (SCORE)--------------
* RETRIEVES THE SCORE FROM MEMORY LOCATION
*-------------------------------------------------------   


*-------------------------------------------------------
*-----------------------BEING ATTACKED------------------
* THIS COULD BE USED FOR COLLISION DETECTION
*-------------------------------------------------------

*-------------------------------------------------------
*--------------------------LOOP-------------------------
*-------------------------------------------------------
*NOT USED
*-------------------------------------------------------
*------------------SCREEN DECORATION--------------------
*-------------------------------------------------------
*NOT USED

   
*-------------------------------------------------------
*------------------------REPLAY-------------------------
*-------------------------------------------------------

    
*-------------------------------------------------------
*-------------------DATA DELARATIONS--------------------
*-------------------------------------------------------
*NOT USED
WELCOME_MSG:    DC.B    '************************************************************'
                DC.B    $0D,$0A
                DC.B    'YOUR WEAPONS ARE A SWORD WITH A SHIELD AND MACE'
                DC.B    $0D,$0A
                DC.B    '************************************************************'
                DC.B    $0D,$0A,0
POTION_MSG:     DC.B    'POTION ....'
                DC.B    $0D,$0A
                DC.B    'ENTER POTION : ',0
POTIONS_MSG:    DC.B    'NUMBER OF POTIONS :5 ',0
WEAPONS_MSG:    DC.B    'EACH QUEST NEED AT LEAST 2 WEAPONS'
                DC.B    $0D,$0A
                DC.B    'MINIMUM REQUIREMENT IS 2 I.E. SWORD X 1 AND SPEER X 1.'
                DC.B    $0D,$0A
                DC.B    'ENTER # OF WEAPONS : ',0
GAMEPLAY_MSG:   DC.B    'ADD GAMEPLAY !',0
UPDATE_MSG:     DC.B    'UPDATE GAMEPLAY !',0
DRAW_MSG:       DC.B    'DRAW SCREEN !',0
HIT_MSG:        DC.B    'STRIKE!',0
MISS_MSG:       DC.B    'MISS!',0
LOOP_MSG:       DC.B    '.',0
REPLAY_MSG:     DC.B    'ENTER 0 TO QUIT ANY OTHER NUMBER TO REPLAY : ',0
HUD_MSG:        DC.B    'SCORE: ',0
*NOT USED
WEAPONSGIVEN    DC.B    '************************************************************',13,10
                DC.B    'REMEMBER TO KEEP IN MIND WHAT YOU HEALTH IS',13,10
                DC.B    'YOU HAVE A SWORD AND SHIELD AND ALSO A MACE AND 5 POTIONS',13,10
                DC.B    '                   PRESS ENTER',13,10

                DC.B    '************************************************************',0

WEAPONSCREEN:   DC.B   '************************************************************' ,13,10
                DC.B   'DO YOU WANT TO USE SWORD [1] OR MACE [2]:',13,10
                DC.B   '************************************************************',0

PICKACHOICESCREEN: DC.B '************************************************************',13,10
                DC.B    'PICK A CHOICE!:',13,10
                DC.B    '************************************************************',0

SCENE1:         DC.B    '************************************************************',13,10
                DC.B    'YOU ENTER AN ABANDONED OFFICE BUILDING WITH OVERGROWN VINES',13,10
                DC.B    'AND TREES SURROUNDING IT ',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0

SCENE11:        DC.B    '************************************************************',13,10
                DC.B    'YOU SEE A OFFICE CUBICAL WITH A DESK THAT CAN BE SEARCHED OR MOVE AHEAD',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE11CHOICE:  DC.B    '************************************************************',13,10
                DC.B    'DO YOU WANT TO SEARCH DESK [0] OR MOVE AHEAD [1]',13,10
                DC.B    '************************************************************',0
SCENE112:       DC.B    '************************************************************',13,10
                DC.B    'YOU SEARCH THE DESK AND FIND A HEALTH POTION',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE113:       DC.B    '************************************************************',13,10
                DC.B    'YOU OPEN THE DOOR AND MOVE INTO THE NEXT ROOM',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE2:         DC.B    '************************************************************',13,10
                DC.B    'YOU GET A EERIE FEELING FROM THIS ROOM AND SEE SOMETHING NEAR THE NEXT DOOR',13,10
                DC.B    'IN THIS ROOM THERE A DESK THAT CAN BE SEARCHED AND',13,10 
                DC.B    'A DIARY ON A DESK OR MOVE AHEAD TO NEXT ROOM',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE2CHOICE:   DC.B    '************************************************************',13,10
                DC.B    'DO YOU WANT TO SEARCH THE DESK[0] OR READ THE DIARY[1]:',13,10
                DC.B    '************************************************************',0
SCENE2DESK:     DC.B    '************************************************************',13,10
                DC.B    'YOU SEARCH THE DESK AND FIND A HEALTH POTION:',13,10
                DC.B    'MOVE AHEAD[1]:',13,10 
                DC.B    '************************************************************',0
SCENE2DESK1:    DC.B    '************************************************************',13,10
                DC.B    'YOU SEARCH THE DESK AND FIND A HEALTH POTION:',13,10
                DC.B    'DO YOU WANT TO READ DIARY [0] OR MOVE AHEAD[1]:',13,10
                DC.B    '************************************************************',0          
SCENE21:        DC.B    '************************************************************',13,10
                DC.B    'YOU OPEN THE DOOR AND YOU GET INTO A FIGHT WITH THIS MUTATED LOOKING HUMAN',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE22:        DC.B    '************************************************************',13,10
                DC.B    'YOU WIN',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE23:        DC.B    '************************************************************',13,10
                DC.B    'YOU LOST THE FIGHT AND DIED',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
DIARY1:         DC.B    '************************************************************',13,10
                DC.B    'I WROTE DOWN A EMAIL I RECIEVED IT GOES LIKE THIS',13,10
                DC.B    'DEAR [REDACTED]',13,10
                DC.B    'WE ARE SENDING THIS TO WARN ABOUT THE INCOMING EVENT',13,10
                DC.B    ' HAPPENING WITHIN THE NEXT 5 DAYS',10,13
                DC.B    'FROM [REDACTED]',13,10
                DC.B    'THE REST OF THE EMAIL WAS CENSORED BY WHOEVER SENT IT BUT THIS WAS SENT ON',13,10  
                DC.B    ' 14/4/2030',13,10
                DC.B    'BEFORE THE GREAT EVENT IN 19/4/2030 BUT HOW DID THEY KNOW',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENEDIARY1:    DC.B    '************************************************************',13,10
                DC.B    'DO YOU WANT TO SEARCH THE DESK[0] OR MOVE AHEAD[1]:',13,10
                DC.B    '************************************************************',0
SCENEDIARY12:   DC.B    '************************************************************',13,10
                DC.B    'MOVE AHEAD[1]:',13,10
                DC.B    '************************************************************',0
SCENE24:        DC.B    '************************************************************',13,10
                DC.B    'YOU RECIEVED A HEALTH POTION',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE3:         DC.B    '************************************************************',13,10
                DC.B    'THIS ROOM LOOKS SIMILAR BUT SOME OF THE ROOM LOOKS LIKE ITS FROM THE PAST',13,10
                DC.B    'THE DESK LOOKS LIKE ITS FROM MEDIEVAL DAYS AND HAS A SCROLL[0]',13,10
                DC.B    'AND CAN ALSO BE SEARCHED[1]OR GO AHEAD AND OPEN THE DOOR[2]',13,10
                DC.B    '************************************************************',0
SCROLL1:        DC.B    '************************************************************',13,10
                DC.B    'THE SCROLL READ AS',13,10
                DC.B    'THE PROPHECY SAYS THAT THE GREAT CATACLYSM SHALL OCCUR WITHIN THE NEXT 5 DAYS',13,10
                DC.B    'THE REST IS JUST UNIMPORTANT UNTIL THTE END WHERE',13,10
                DC.B    'IT SAYS THE RIFT WILL INDUCE A GREAT CATACLYSM',13,10
                DC.B    'DO YOU WANT TO SEARCH THE DESK[0] OR MOVE AHEAD[1]',13,10
                DC.B    '************************************************************',0
SCENE31:        DC.B    '************************************************************',13,10
                DC.B    'YOU RECIEVED A HEALTH POTION',13,10
                DC.B    'DO YOU WANT TO READ THE SCROLL [0] OR MOVE AHEAD [1]' ,13,10
                DC.B    '************************************************************',0
SCENE31A:       DC.B    '************************************************************',13,10
                DC.B    'YOU RECIEVED A HEALTH POTION',13,10
                DC.B    'DO YOU WANT TO MOVE AHEAD [1]' ,13,10                
                DC.B    '************************************************************',0
SCROLL2:        DC.B    '************************************************************',13,10
                DC.B    'THE SCROLL READ AS',13,10
                DC.B    'THE PROPHECY SAYS THAT THE GREAT CATACLYSM SHALL OCCUR WITHIN THE NEXT 5 DAYS',13,10
                DC.B    'THE REST IS JUST UNIMPORTANT UNTIL THTE END WHERE',13,10
                DC.B    ' IT SAYS THE RIFT WILL INDUCE A GREAT CATACLYSM',13,10
                DC.B    'DO YOU WANT TO MOVE AHEAD[1]',13,10 
                DC.B    '************************************************************',0 
SCENE32:        DC.B    '************************************************************',13,10
                DC.B    'YOU MOVE AHEAD TO THE DOOR AND OPEN IT',13,10
                DC.B    'AS YOU OPEN IT THE DOOR IS KICKED OPEN AND YOU FALL TO THE GROUND',13,10
                DC.B    'YOU LOOK AS A KNIGHT APPEARS SAYING THAT HE WILL PROTECT THE KING',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE33:        DC.B    '************************************************************',13,10
                DC.B    'THE KNIGHT IS DEFEATED AND MOVE FORWARD',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE4:         DC.B    '************************************************************',13,10
                DC.B    'THIS ROOM APPEARS MORE WEIRD AS IT APPEARS SOME PARTS ARE GLITCHING',13,10
                DC.B    'THEN YOU LOOK AT YOU SEE THE NEXT DOOR SAYS GO NO FURTHER AND A PAGE TO READ',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE41:        DC.B    '************************************************************',13,10
                DC.B    'YOU SEE A PRINTED PAGE OF A EMAIL AND READ IT',13,10
                DC.B    'THE EMAIL IS MOSTLY REDACTED BUT SAYS THAT THE GREAT EVENT',13,10
                DC.B    ' SHALL OCCUR IN THE COMPANYS LAB',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE5:         DC.B    '************************************************************',13,10
                DC.B    'YOU WALK THROUGH THE DOOR AND SEE A LAB WITH A DESK THAT CAN BE',13,10
                DC.B    'SEARCHED OR GO AHEAD TO NEXT ROOM',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE51:        DC.B    '************************************************************',13,10
                DC.B    'YOU WALK FURTHER SEEING A RIFT OF SORT IN A CONTAINMENT ROOM',13,10
                DC.B    'THEN YOU SEE A MAN APPEAR OUT OF THE RIFT AND HE RUNS',13,10
                DC.B    ' INTO THE ROOM YOU ARE HIDING IN',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE52:        DC.B    '************************************************************',13,10
                DC.B    'THEN A GIANT CLAW APPEARS TO COME OUT OF THE GATE',13,10
                DC.B    'YOU WATCH AS YOU REALISE A DRAGON IS COMING OF THE RIFT AND',13,10
                DC.B    ' YOU BOTH START RUNNING AS IT COMES OUT',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE53:        DC.B    '************************************************************',13,10
                DC.B    'YOU ASK THE MAN WHOS RUNNING WITH YOU WHATS HAPPENING',13,10
                DC.B    'HE SAYS THAT THE GREAT CATACLYSM IS STILL ONGOING IN HIS WORLD',13,10
                DC.B    ' AND ITS CAUSING GREAT DESPAIR',13,10
                DC.B    'YOU REACH THE FIRST ROOM YOU ENTERED AS THE DRAGON FINALLY IS THROUGH THE RIFT',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE54:        DC.B    '************************************************************',13,10
                DC.B    'YOU LOOK AS THE DRAGONS HEAD AND CLAWS HAVE REACH THE ROOM AND YOU PREPARE TO FIGHT',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
FIGHTDRAGONSCENE1:  DC.B    '************************************************************',13,10
                    DC.B   'YOU ATTACK THE DRAGON HITTING ITS RIGHT EYE MAKING IT RECIEVE 85 DAMAGE',13,10
                     DC.B    '                   PRESS ENTER',13,10
                    DC.B    '************************************************************',0
DRAGONATTACK1:  DC.B    '************************************************************',13,10 
                DC.B    'THE DRAGON HITS YOU WITH ITS CLAW AND YOU RECIEVE 50 DAMAGE',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
FIGHTDRAGONSCENE2:  DC.B    '************************************************************',13,10
                    DC.B 'YOU ATTACK AND SLASH THE DRAGONS FACE AND IT RECIEVES 60 DAMAGE',13,10
                     DC.B    '                   PRESS ENTER',13,10
                    DC.B    '************************************************************',0
DRAGONATTACK2:  DC.B    '************************************************************',13,10
                DC.B    'THE DRAGON THEN STARTS TO READY A BLAST FROM ITS MOUTH AND YOU JUMP OUT OF THE WAY',13,10
                DC.B    'BUT THE MAN WITH YOU DOESNT AND GETS INCINERATED BY THE BLAST',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE55:        DC.B    '************************************************************',13,10
                DC.B    'THE DRAGONS MOUTH REMAINS OPEN TO COOL OFF AND YOU CAN ATTACK NOW',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
FIGHTDRAGONSCENE3: DC.B    '************************************************************',13,10
                DC.B 'YOU ATTACK THE DRAGON PUTTING YOUR SWORD INTO ITS MOUTH AND RIPPING IT OPEN',13,10
                DC.B    'THE DRAGON HAS BECOME LIFELESS AS YOU HAVE SLAIN THE DRAGON',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SCENE56:        DC.B    '************************************************************',13,10
                DC.B    'AS YOU READY TO LEAVE YOU HEAR SOMETHING AND THEN A BIG BLAST',13,10
                DC.B    ' FROM THE RIFT HITS YOU',13,10
                DC.B    'YOU OPEN YOUR EYES APPEARING TO BE INFRONT OF A KING IN HIS THRONE ROOM',13,10
                DC.B    'THE KING THEN ANNOUNCES THAT THE DRAGON SLAYER HAS ARRIVED',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
ENDSCREEN:      DC.B    '************************************************************',13,10
                DC.B    'CONGRATULATIONS',13,10
                DC.B    'YOU BEAT THE GAME!',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
FIGHTCHOICE:    DC.B    '************************************************************',13,10
                DC.B    'DO YOU WANT TO ATTACK[0] USE POTIONS [1] CHANGE WEAPON [2] BLOCK [3]',13,10
                DC.B    '************************************************************',0
ATTACKEDSCREEN1: DC.B    '************************************************************',13,10
                DC.B    'YOU RECIEVE 15 DAMAGE',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
POTIONDRANK:    DC.B    '************************************************************',13,10
                DC.B    'YOU USED THE HEALTH POTION AND RECIEVED 40 HP',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
BLOCKSCENE:     DC.B    '************************************************************',13,10
                DC.B    'YOU BLOCKED THE INCOMING ATTACK',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
POTIONHPAMOUNT: DC.B 5
POTIONSNO:      DC.B    '************************************************************',13,10
                DC.B    'YOU HAVE TOO MUCH HEALTH TO HEAL :',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
POTIONSNO1:     DC.B    '************************************************************',13,10
                DC.B    'YOU HAVE NO POTIONS :',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
CHANGEWEAPON:   DC.B    '************************************************************',13,10
                DC.B    'DO YOU WANT TO USE SWORD [1] OR MACE [2]:',13,10
                DC.B    '************************************************************',0
SWORDDAMAGE:    DC.B 30
MACEDAMAGE:     DC.B 50
WEAPONCHANGED:  DC.B    '************************************************************',13,10
                DC.B    'YOU CHANGED WEAPON:',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
ALREADYUSING:   DC.B    '************************************************************',13,10
                DC.B    'YOU ARE ALREADY USING THIS WEAPON:',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
DAMAGEDSCENE:   DC.B    '************************************************************',13,10
                DC.B    'YOU TOOK 20 DAMAGE [1 TO CONTINUE]',13,10
                DC.B    '************************************************************',0
GAMEOVERSCENE:  DC.B    '************************************************************',13,10
                DC.B    'GAME OVER',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
LOSESCENE:      DC.B    '************************************************************',13,10
                DC.B    'YOU LOSE',13,10
                 DC.B    '                   PRESS ENTER',13,10
                DC.B    '************************************************************',0
SWORDATTACKSCENE:   DC.B    '************************************************************',13,10
                    DC.B   'YOU HIT HIM FOR 35 DAMAGE',13,10
                     DC.B    '                   PRESS ENTER',13,10
                    DC.B    '************************************************************',0
MACEATTACKSCENE: DC.B    '************************************************************',13,10
                 DC.B   'YOU HIT HIM FOR 50 DAMAGE',13,10
                  DC.B    '                   PRESS ENTER',13,10
                 DC.B    '************************************************************',0
HEATLH_MSG       DC.B   'HEALTH:',0
PLAYERHEALTH     DC.B 0
NEWLINE         DC.B   $0D,$0A,0
ENEMYHEALTH:    DC.B 1 ENEMY HEALTH                                                                                                                                                              
SCORE:      DS.W    1   RESERVE SPACE FOR SCORE
INPUT_VALUE:    DS.B 1  ; Reserve space for storing input character
ENDGAME:
    END START


















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
