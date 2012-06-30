;PISCA
LIST P=16F628
INCLUDE<P16F628.INC>

#define BANK0 BCF STATUS,RP0
#define BANK1 BSF STATUS,RP0

#define BOTAO_P1 	PORTA,0
#define BOTAO_P2 	PORTA,1
#define BOTAO_P3 	PORTA,2
#define BOTAO_P4 	PORTA,3
#define BOTAO_START PORTA,4
#define BOTAO_N_PS 	PORTA,5

#define SHOCK_LED_P1 	PORTB,0
#define SHOCK_LED_P2 	PORTB,1
#define SHOCK_LED_P3 	PORTB,2
#define SHOCK_LED_P4 	PORTB,3

#define ENABLED_LED_P3 	PORTB,4
#define ENABLED_LED_P4 	PORTB,5

#define START_LED	PORTB,6

COUNTER 		equ 0x20
LAST_COUNTER 	equ 0x21
BOT				equ 0x22
LAST_BOT  		equ 0x23
COUNT1 	  		equ 0x24
COUNT2 	  		equ 0x25
COUNT3 	  		equ 0x26

ORG 0X00
GOTO INICIO

INICIO
	BANK1
	MOVLW 	B'00111111'
	MOVWF 	TRISA
	MOVLW 	B'00000000'
	MOVWF 	TRISB
	BANK0
	CLRF 	PORTA
	clrf 	PORTB
	bsf 	ENABLED_LED_P3
	bsf 	ENABLED_LED_P4
	movlw	0
	movwf	COUNTER
	movwf	LAST_COUNTER ;
	movwf	BOT
	movwf 	LAST_BOT
	clrf 	BOT

START
	clrwdt ; limpa watchdog 
	btfsc 	BOTAO_N_PS
	goto 	SET_N_PS ; vai setar numero de jogadores
	BTFSC	BOTAO_START
	;GOTO 	MAIN ; SE O BOTAO FOI PRESSIONADO VAI PRA MAIN
	goto	DELAY_LED
	GOTO 	START

SET_N_PS
	btfss 	ENABLED_LED_P3
	goto 	SET_P3 ; se não setado, vai setar
	btfss 	ENABLED_LED_P4
	goto 	SET_P4 ; se não setado, vai setar
	goto 	DISABLE_P3P4 ; se todos estiverem setados, vai desetar o 3 e 4

SET_P3
	bsf 	ENABLED_LED_P3 ; ativa jogador 3
	bcf 	BOT,2 ; seta estado do botao jogador 3
	movlw 	1 ; contador começa em 1
	movwf 	COUNTER ; salva o valor de W em COUNTER
	movwf	LAST_COUNTER
	movwf 	LAST_COUNTER ; salva o valor de W em LAST_COUNTER
	movf 	BOT,W ; salva ultima configuracao de jogadores em LAST_BOT
	movwf	LAST_BOT
	goto 	WAIT	

SET_P4
	bsf 	ENABLED_LED_P4 ; ativa jogador 4
	bcf 	BOT,3 ; seta estado do botao jogador 4
	movlw 	0 ; contador começa em 0
	movwf 	COUNTER ; salva o valor de W em COUNTER
	movwf 	LAST_COUNTER ; salva o valor de W em LAST_COUNTER
	movf 	BOT,W ; salva ultima configuracao de jogadores em LAST_BOT
	movwf	LAST_BOT
	goto 	WAIT

DISABLE_P3P4
	bcf 	ENABLED_LED_P3 ; desativa led jogadores 3
	bsf 	BOT, 2 ; setar estado do botao do jogador 3
	bcf 	ENABLED_LED_P4 ; desativa led jogadores 4
	bsf 	BOT,3 ; setar estado do botao do jogador 4
	movlw 	2 ; contador começa em 2
	movwf 	COUNTER ; salva o valor de W em COUNTER
	movwf 	LAST_COUNTER ; salva o valor de W em LAST_COUNTER
	movf	BOT,W
	movwf 	LAST_BOT ; salva ultima configuracao de jogadores
	movf	LAST_BOT,W ; debug
	goto 	WAIT

WAIT ; loop para esperar desapertar o botão de selecionar número de jogadores
	btfss 	BOTAO_N_PS
	goto 	START ; se desapertado
	clrwdt ; limpa watchdog
	goto 	WAIT 

MAIN
	BTFSC	BOTAO_P1; TESTE SE O BOTAO ESTA PRESSIONADO 
	CALL 	BOTAO_P1_PRESS; SE PRESSIONADO entra na rotina
	BTFSC	BOTAO_P2
	CALL 	BOTAO_P2_PRESS
	BTFSC	BOTAO_P3
	CALL 	BOTAO_P3_PRESS
	BTFSC 	BOTAO_P4
	CALL 	BOTAO_P4_PRESS
	CALL 	CHECK_COUNTER
	clrwdt ;limpa watchdog
	GOTO 	MAIN

CHECK_COUNTER
	movf 	COUNTER,W
	BTFSS 	COUNTER,0
	RETURN
	BTFSS 	COUNTER,1
	RETURN
	GOTO 	FIND_LOSER ; se COUNTER>=3

FIND_LOSER ;TEM QUE ACHAR O PRIMEIRO ZERO	
	BTFSS 	BOT,0
	bsf 	SHOCK_LED_P1 ; se jogador 1 perdeu
	BTFSS 	BOT,1
	bsf 	SHOCK_LED_P2 ; se jogador 2 perdeu
	BTFSS 	BOT,2
	bsf 	SHOCK_LED_P3 ; se jogador 3 perdeu
	BTFSS 	BOT,3
	bsf 	SHOCK_LED_P4 ; se jogador 4 perdeu
	GOTO 	DELAY_SHOCK

BOTAO_P1_PRESS
	BTFSC 	BOT,0
	RETURN
	bsf 	BOT,0 ; seta 1 no bit do jogador 1
	movf 	COUNTER,W ; carrega o valor de COUNTER em W
	addlw 	1 ; soma 1
	movwf 	COUNTER ; salva o valor de W em COUNTER
	RETURN
	
BOTAO_P2_PRESS
	BTFSC 	BOT,1
	RETURN
	bsf 	BOT,1 ; seta 1 no bit do jogador 1
	movf 	COUNTER,W ; carrega o valor de COUNTER em W
	addlw 	1 ; soma 1
	movwf 	COUNTER ; salva o valor de W em COUNTER
	RETURN

BOTAO_P3_PRESS
	BTFSC 	BOT,2
	RETURN
	bsf 	BOT,2 ; seta 1 no bit do jogador 1
	movf 	COUNTER,W ; carrega o valor de COUNTER em W
	addlw 	1 ; soma 1
	movwf 	COUNTER ; salva o valor de W em COUNTER
	RETURN

BOTAO_P4_PRESS
	BTFSC 	BOT,3
	RETURN
	bsf 	BOT,3 ; seta 1 no bit do jogador 1
	movf 	COUNTER,W ; carrega o valor de COUNTER em W
	addlw 1 ; soma 1
	movwf 	COUNTER ; salva o valor de W em COUNTER
	RETURN

DELAY_SHOCK
	MOVLW 	D'3'
	MOVWF 	COUNT1

DELAY0_SHOCK
	MOVLW 	D'100'
	MOVWF 	COUNT2
	DECFSZ 	COUNT1,F
	GOTO 	DELAY1_SHOCK
	movf 	LAST_COUNTER,W
	movwf	COUNTER
	movf 	LAST_BOT,W
	movwf 	BOT
	bcf 	SHOCK_LED_P1
	bcf 	SHOCK_LED_P2
	bcf 	SHOCK_LED_P3
	bcf 	SHOCK_LED_P4
	GOTO 	START

DELAY1_SHOCK
	MOVLW 	D'255'
	MOVWF 	COUNT3
	DECFSZ 	COUNT2,F
	GOTO 	DELAY2_SHOCK
	GOTO 	DELAY0_SHOCK

DELAY2_SHOCK
	DECFSZ 	COUNT3,F
	GOTO 	$-1
	GOTO 	DELAY1_SHOCK

DELAY_LED
	MOVLW 	D'6'
	MOVWF 	COUNT1
	bsf 	START_LED


DELAY0_LED
	MOVLW 	D'255'
	MOVWF 	COUNT2
	DECFSZ 	COUNT1,F
	GOTO 	DELAY1_LED
	bcf 	START_LED
	GOTO 	MAIN

DELAY1_LED
	MOVLW 	D'255'
	MOVWF 	COUNT3
	DECFSZ 	COUNT2,F
	GOTO 	DELAY2_LED
	GOTO 	DELAY0_LED

DELAY2_LED
	DECFSZ 	COUNT3,F
	GOTO 	$-1
	btfsc	BOTAO_P1 
	call 	SHOCK_P1
	btfsc	BOTAO_P2
	call 	SHOCK_P2
	btfsc	BOTAO_P3
	call 	SHOCK_P3
	btfsc 	BOTAO_P4
	call 	SHOCK_P4
	GOTO 	DELAY1_LED

SHOCK_P1
	bsf SHOCK_LED_P1
	goto DELAY_SHOCK

SHOCK_P2
	bsf SHOCK_LED_P2
	goto DELAY_SHOCK

SHOCK_P3
	bsf SHOCK_LED_P3
	goto DELAY_SHOCK

SHOCK_P4
	bsf SHOCK_LED_P4
	goto DELAY_SHOCK

END
