;PISCA
LIST P=16F877
INCLUDE<P16F877A.INC>

#define BANK0 BCF STATUS,RP0
#define BANK1 BSF STATUS,RP0

#define DIR_BUTTON 	PORTD,0 ;botao de direcao
#define STEP_BUTTON	PORTD,1 ;botao de passo

#define STEP1	B'00000100'
#define STEP2	B'00001100'
#define STEP3	B'00001000'
#define STEP4	B'00011000'
#define STEP5	B'00010000'
#define STEP6	B'00110000'
#define STEP7	B'00100000'
#define STEP8	B'00100100'

#define STATE1	B'00000001'
#define STATE2	B'00000010'
#define STATE3	B'00000100'
#define STATE4	B'00001000'
#define STATE5	B'00010000'
#define STATE6	B'00100000'
#define STATE7	B'01000000'
#define STATE8	B'10000000'

#define	D1		D'5'
#define	D2		D'70'
#define	D3		D'255'

REG				equ 0x20
CUR_STATE		equ 0x21
COUNT1			equ 0x22
COUNT2			equ 0x23
COUNT3			equ 0x24

ORG 0X00
GOTO INICIO

INICIO
	BANK1
	MOVLW 	B'00000011'
	MOVWF 	TRISD
	BANK0
	CLRF 	PORTD
	movlw	B'00000010' ;sentido horario com simples 1
	movwf	REG
	movlw	STATE1 ;carrega valor de STATE1 em W
	movwf	CUR_STATE ;salva W em CUR_STATE
	movlw	STEP1
	movwf	PORTD

CHECK_CUR_STATE ;checa estado corrente
	btfsc	CUR_STATE,0 ;STATE1
	goto	STATE1_OPT
	btfsc	CUR_STATE,1 ;STATE2
	goto	STATE2_OPT
	btfsc	CUR_STATE,2 ;STATE3
	goto	STATE3_OPT
	btfsc	CUR_STATE,3 ;STATE4
	goto	STATE4_OPT
	btfsc	CUR_STATE,4 ;STATE5
	goto	STATE5_OPT
	btfsc	CUR_STATE,5 ;STATE6
	goto	STATE6_OPT
	btfsc	CUR_STATE,6 ;STATE7
	goto	STATE7_OPT
	btfsc	CUR_STATE,7 ;STATE8
	goto	STATE8_OPT
	goto CHECK_CUR_STATE

	
;################## STATE 1 ################################################
STATE1_OPT ;sentido do proximo passo
	btfss	REG,0 ; bit indicador de sentido
	goto	CW_STATE1; horário
	goto	CCW_STATE1; anti-horário

CW_STATE1 ;escolhe de tipo passo no sentido horário
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE2
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE2
	btfsc	REG,3 ;bit indicador do meio passo
	goto	S2_SET_STATE2 ;meio passo é igual ao passo simples 2 neste caso

CCW_STATE1 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE8
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE8
	btfsc	REG,3 ;HA_STATE_REG
	goto	S2_SET_STATE8 ; meio passo é igual ao passo simples 2

;################## STATE 2 ################################################
STATE2_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STATE2
	goto	CCW_STATE2

CW_STATE2 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE3
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE3
	btfsc	REG,3 ;HA_STATE_REG
	goto	S1_SET_STATE3 ; meio passo é igual ao passo simples 1

CCW_STATE2 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE1
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE1
	btfsc	REG,3 ;HA_STATE_REG
	goto	S1_SET_STATE1 ; meio passo é igual ao passo simples 1

;################## STATE 3 ################################################
STATE3_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STATE3
	goto	CCW_STATE3

CW_STATE3 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE4
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE4
	btfsc	REG,3 ;HA_STATE_REG
	goto	S2_SET_STATE4 ; meio passo é igual ao passo simples 2

CCW_STATE3 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE2
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE2
	btfsc	REG,3 ;HA_STATE_REG
	goto	S2_SET_STATE2 ; meio passo é igual ao passo simples 2

;################## STATE 4 ################################################
STATE4_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STATE4
	goto	CCW_STATE4

CW_STATE4 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE5
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE5
	btfsc	REG,3 ;HA_STATE_REG
	goto	S1_SET_STATE5 ; meio passo é igual ao passo simples 1

CCW_STATE4 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE3
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE3
	btfsc	REG,3 ;HA_STATE_REG
	goto	S1_SET_STATE3 ; meio passo é igual ao passo simples 1

;################## STATE 5 ################################################
STATE5_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STATE5
	goto	CCW_STATE5

CW_STATE5 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE6
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE6
	btfsc	REG,3 ;HA_STATE_REG
	goto	S2_SET_STATE6 ; meio passo é igual ao passo simples 2

CCW_STATE5 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE4
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE4
	btfsc	REG,3 ;HA_STATE_REG
	goto	S2_SET_STATE4 ; meio passo é igual ao passo simples 2

;################## STATE 6 ################################################
STATE6_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STATE6
	goto	CCW_STATE6

CW_STATE6 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE7
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE7
	btfsc	REG,3 ;HA_STATE_REG
	goto	S1_SET_STATE7 ; meio passo é igual ao passo simples 1

CCW_STATE6 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE5
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE5
	btfsc	REG,3 ;HA_STATE_REG
	goto	S1_SET_STATE5 ; meio passo é igual ao passo simples 1

;################## STATE 7 ################################################
STATE7_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STATE7
	goto	CCW_STATE7

CW_STATE7 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE8
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE8
	btfsc	REG,3 ;HA_STATE_REG
	goto	S2_SET_STATE8 ; meio passo é igual ao passo simples 2

CCW_STATE7 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; bit indicador do passo simples 1
	goto	S1_SET_STATE6
	btfsc	REG,2 ; bit indicador do passo simples 2
	goto	S1_SET_STATE6
	btfsc	REG,3 ; HA_STATE_REG
	goto	S2_SET_STATE6 ; meio passo é igual ao passo simples 2

;################## STATE 8 ################################################
STATE8_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STATE8
	goto	CCW_STATE8

CW_STATE8 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;bit indicador do passo simples 1
	goto	S1_SET_STATE1
	btfsc	REG,2 ;bit indicador do passo simples 2
	goto	S2_SET_STATE1
	btfsc	REG,3 ;HA_STATE_REG
	goto	S1_SET_STATE1 ; meio passo é igual ao passo simples 1

CCW_STATE8 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; S1_STATE1_REG
	goto	S1_SET_STATE7
	btfsc	REG,2 ; bit indicador do passo simples 2
	goto	S2_SET_STATE7
	btfsc	REG,3 ; HA_STATE_REG
	goto	S1_SET_STATE7 ; meio passo é igual ao passo simples 1

;########## STATE 1 ###################

S1_SET_STATE1
	movlw	STEP1 ;passo 1
	movwf	PORTD ;grava no PORTD
	movlw	STATE1 ;copia combinação de bits do estado 1 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
S2_SET_STATE1
	movlw	STEP2 ;passo 2
	movwf	PORTD ;grava no PORTD
	movlw	STATE1 ;copia combinação de bits do estado 1 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY ;tempo que a bobina fica acionada e leitura dos botões
	goto	CHECK_CUR_STATE

;########## STATE 2 ###################
S1_SET_STATE2
	movlw	STEP1
	movwf	PORTD
	movlw	STATE2 ;copia combinação de bits do estado 2 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY 
	goto	CHECK_CUR_STATE
S2_SET_STATE2
	movlw	STEP2
	movwf	PORTD
	movlw	STATE2 ;copia combinação de bits do estado 2 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
;########## STATE 3 ###################
S1_SET_STATE3
	movlw	STEP3
	movwf	PORTD
	movlw	STATE3 ;copia combinação de bits do estado 3 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
S2_SET_STATE3
	movlw	STEP4
	movwf	PORTD
	movlw	STATE3 ;copia combinação de bits do estado 3 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
;########## STATE 4 ###################
S1_SET_STATE4
	movlw	STEP3
	movwf	PORTD
	movlw	STATE4 ;copia combinação de bits do estado 4 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
S2_SET_STATE4
	movlw	STEP4
	movwf	PORTD
	movlw	STATE4 ;copia combinação de bits do estado 4 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
;########## STATE 5 ###################
S1_SET_STATE5
	movlw	STEP5
	movwf	PORTD
	movlw	STATE5 ;copia combinação de bits do estado 5 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
S2_SET_STATE5
	movlw	STEP6
	movwf	PORTD
	movlw	STATE5 ;copia combinação de bits do estado 5 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
;########## STATE 6 ###################
S1_SET_STATE6
	movlw	STEP5
	movwf	PORTD
	movlw	STATE6 ;copia combinação de bits do estado 6 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
S2_SET_STATE6
	movlw	STEP6
	movwf	PORTD
	movlw	STATE6 ;copia combinação de bits do estado 6 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
;########## STATE 7 ###################
S1_SET_STATE7
	movlw	STEP7
	movwf	PORTD
	movlw	STATE7 ;copia combinação de bits do estado 7 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
S2_SET_STATE7
	movlw	STEP8
	movwf	PORTD
	movlw	STATE7 ;copia combinação de bits do estado 7 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
;########## STATE 8 ###################
S1_SET_STATE8
	movlw	STEP7
	movwf	PORTD
	movlw	STATE8 ;copia combinação de bits do estado 8 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE
S2_SET_STATE8
	movlw	STEP8
	movwf	PORTD
	movlw	STATE8 ;copia combinação de bits do estado 8 em W
	movwf	CUR_STATE ;salva valor de W em CUR_STATE
	call	DELAY
	goto	CHECK_CUR_STATE

CHECK_DIR_BUTTON
	btfsc	DIR_BUTTON
	goto	CHANGE_DIR
	goto	CHECK_STEP_BUTTON

CHANGE_DIR
	btfsc	REG,0 ; DIR_REG
	goto	SET_CW_DIR ;muda para horario(0) se for 1
	btfss	REG,0
	goto	SET_CCW_DIR ;muda para anti-horario(1) se for 0	

SET_CW_DIR
	bcf		REG,0 ;muda para horario(0) se for 1
	goto 	WAIT_DIR_BUTTON

SET_CCW_DIR
	bsf		REG,0 ;muda para anti-horario(1) se for 0 
	goto 	WAIT_DIR_BUTTON

CHECK_STEP_BUTTON ;checa se botao de passo esta pressionado
	btfsc	STEP_BUTTON
	goto	CHANGE_STEP_TYPE
	goto	DELAY1

CHANGE_STEP_TYPE ;procura pra qual passo vai mudar...S1->S2->HA->S1...
	btfsc	REG,1 ; S1_STEP1_REG
	goto	SET_S2_STEP ;se é 1
	btfsc	REG,2 ; S2_STEP_REG
	goto	SET_HA_STEP
	btfsc	REG,3 ; HA_STEP_REG
	goto	SET_S1_STEP

SET_S1_STEP ;seta passo simples 1
	bcf		REG,3 ; HA_STEP_REG
	bsf		REG,1 ; S1_STEP1_REG
	goto 	WAIT_STEP_BUTTON

SET_S2_STEP ;seta passo simples 2
	bcf		REG,1 ; S1_STEP1_REG
	bsf		REG,2 ; S2_STEP_REG
	goto 	WAIT_STEP_BUTTON

SET_HA_STEP ;seta meio passo
	bcf		REG,2 ; S2_STEP_REG
	bsf		REG,3 ; HA_STEP_REG
	goto 	WAIT_STEP_BUTTON

WAIT_DIR_BUTTON ;loop para esperar despressionamento do botao de diracao
	btfss 	DIR_BUTTON
	return ;se despressionado
	clrwdt ;limpa watchdog
	goto 	WAIT_DIR_BUTTON

WAIT_STEP_BUTTON ;loop para esperar despressionamento do botao de passo
	btfss	STEP_BUTTON
	return ;se despressionado
	clrwdt ;limpa watchdog
	goto 	WAIT_STEP_BUTTON

DELAY
	MOVLW 	D1 ;D'4'
	MOVWF 	COUNT1

DELAY0
	MOVLW 	D2 ;D'80'
	MOVWF 	COUNT2
	DECFSZ 	COUNT1,F
	GOTO 	DELAY1
	return

DELAY1
	MOVLW 	D3 ;D'255'
	MOVWF 	COUNT3
	DECFSZ 	COUNT2,F
	GOTO 	DELAY2
	GOTO 	DELAY0

DELAY2
	DECFSZ 	COUNT3,F
	GOTO 	$-1
	goto	CHECK_DIR_BUTTON ; ->CHECK_STEP_BUTTON -> DELAY1
	;GOTO 	DELAY1

END