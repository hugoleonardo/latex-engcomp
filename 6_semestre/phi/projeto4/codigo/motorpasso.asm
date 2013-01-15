;PISCA
LIST P=16F877
INCLUDE<P16F877A.INC>

#define BANK0 BCF STATUS,RP0
#define BANK1 BSF STATUS,RP0

#define DIR_BUTTON 	PORTD,0 ;botao de direcao
#define STEP_BUTTON	PORTD,1 ;botao de passo
#define COIL1		PORTD,2 ;bobina 1
#define COIL2		PORTD,3 ;bobina 2
#define COIL3		PORTD,4 ;bobina 3
#define COIL4		PORTD,5 ;bobina 4
;#define DIR_REG		W,0 ;0=CW e 1=CCW
;#define S1_STEP_REG W,1
;#define S2_STEP_REG W,2
;#define HA_STEP_REG W,3
#define STEP1	B'00000001'
#define STEP2	B'00000010'
#define STEP3	B'00000100'
#define STEP4	B'00001000'
#define STEP5	B'00010000'
#define STEP6	B'00100000'
#define STEP7	B'01000000'
#define STEP8	B'10000000'
#define	D1		D'1'
#define	D2		D'10'
#define	D3		D'5'

REG				equ 0x20
CUR_STEP		equ 0x21
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
	movlw	STEP1
	movwf	CUR_STEP
	movlw	STEP1 ;carrega valor de STEP1 em W
	movwf	CUR_STEP ;salva W em CUR_STEP
	bsf		COIL1

CHECK_CUR_STEP ;checa estado corrente
	call	CHECK_DIR_BUTTON
	call	CHECK_STEP_BUTTON
	btfsc	CUR_STEP,0 ;STEP1 ;se ligada
	goto	STEP1_OPT
	btfsc	CUR_STEP,1 ;STEP2 ;se ligada
	goto	STEP2_OPT
	btfsc	CUR_STEP,2 ;STEP3 ;se ligada
	goto	STEP3_OPT
	btfsc	CUR_STEP,3 ;STEP4 ;se ligada
	goto	STEP4_OPT
	btfsc	CUR_STEP,4 ;STEP5 ;se ligada
	goto	STEP5_OPT
	btfsc	CUR_STEP,5 ;STEP6 ;se ligada
	goto	STEP6_OPT
	btfsc	CUR_STEP,6 ;STEP7 ;se ligada
	goto	STEP7_OPT
	btfsc	CUR_STEP,7 ;STEP8 ;se ligada
	goto	STEP8_OPT
	goto CHECK_CUR_STEP

	
;################## STEP 1 ################################################ OK
STEP1_OPT ;sentido do proximo passo
	btfss	REG,0 ;DIR_REG
	goto	CW_STEP1; Clock-wise
	goto	CCW_STEP1; Counter Clock-wise

CW_STEP1 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;S1_STEP_REG
	goto	S1_CW_ROT_STEP1
	btfsc	REG,2 ;S2_STEP_REG
	goto	S2_CW_ROT_STEP1
	btfsc	REG,3 ;HA_STEP_REG
	goto	HA_CW_ROT_STEP1

CCW_STEP1 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; S1_STEP_REG
	goto	S1_CCW_ROT_STEP1
	btfsc	REG,2 ; S2_STEP_REG
	goto	S2_CCW_ROT_STEP1
	btfsc	REG,3 ; HA_STEP_REG
	goto	HA_CCW_ROT_STEP1

S1_CW_ROT_STEP1 ;seta passo simples 1 no sentido horario(0)...nada muda
	movlw	STEP2 ;copia combinação de bits do passo 2 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
 	goto	CHECK_CUR_STEP

S1_CCW_ROT_STEP1 ;seta passo simples 1 no sentido anti-horario(1)
	bcf		COIL1
	bcf		COIL2
	bcf		COIL3
	bsf		COIL4
	movlw	STEP8 ;copia combinação de bits do passo 8 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP	

S2_CW_ROT_STEP1 ;seta passo simples 2 no sentido horario(0)...nada muda
	movlw	STEP2 ;copia combinação de bits do passo 2 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

S2_CCW_ROT_STEP1 ;seta passo simples 2 no sentido anti-horario(1)
	bsf		COIL1
	bcf		COIL2
	bcf		COIL3
	bsf		COIL4
	movlw	STEP8 ;copia combinação de bits do passo 8 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CW_ROT_STEP1 ;seta meio passo no sentido horario(0)
	bsf		COIL1
	bsf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP2 ;copia combinação de bits do passo 2 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CCW_ROT_STEP1 ;seta meio passo no sentido anti-horario(1)
	bsf		COIL1
	bcf		COIL2
	bcf		COIL3
	bsf		COIL4
	movlw	STEP8 ;copia combinação de bits do passo 8 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

;################## STEP 2 ################################################ OK
STEP2_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STEP2
	goto	CCW_STEP2

CW_STEP2 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1; S1_STEP_REG
	goto	S1_CW_ROT_STEP2
	btfsc	REG,2; S2_STEP_REG
	goto	S2_CW_ROT_STEP2
	btfsc	REG,3; HA_STEP_REG
	goto	HA_CW_ROT_STEP2

CCW_STEP2 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; S1_STEP_REG
	goto	S1_CCW_ROT_STEP2
	btfsc	REG,2 ; S2_STEP_REG
	goto	S2_CCW_ROT_STEP2
	btfsc	REG,3 ; HA_STEP_REG
	goto	HA_CCW_ROT_STEP2

S1_CW_ROT_STEP2 ;seta passo simples 1 no sentido horario(0)
	bcf		COIL1
	bsf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP3 ;copia combinação de bits do passo 3 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

S1_CCW_ROT_STEP2 ;seta passo simples 1 no sentido anti-horario(1)...nada muda
	movlw	STEP1 ;copia combinação de bits do passo 1 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP	

S2_CW_ROT_STEP2 ;seta passo simples 2 no sentido horario(0)
	bcf		COIL1
	bsf		COIL2
	bsf		COIL3
	bcf		COIL4
	movlw	STEP3 ;copia combinação de bits do passo 3 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

S2_CCW_ROT_STEP2 ;seta passo simples 2 no sentido anti-horario(1)...nada muda
	movlw	STEP1 ;copia combinação de bits do passo 1 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

HA_CW_ROT_STEP2 ;seta meio passo no sentido horario(0)
	bcf		COIL1
	bsf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP3 ;copia combinação de bits do passo 3 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CCW_ROT_STEP2 ;seta meio passo no sentido anti-horario(1)
	bsf		COIL1
	bcf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP1 ;copia combinação de bits do passo 1 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

;################## STEP 3 ################################################ OK
STEP3_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STEP3
	goto	CCW_STEP3

CW_STEP3 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;S1_STEP_REG
	goto	S1_CW_ROT_STEP3
	btfsc	REG,2 ;S2_STEP_REG
	goto	S2_CW_ROT_STEP3
	btfsc	REG,3 ;HA_STEP_REG
	goto	HA_CW_ROT_STEP3

CCW_STEP3 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; S1_STEP_REG
	goto	S1_CCW_ROT_STEP3
	btfsc	REG,2 ; S2_STEP_REG
	goto	S2_CCW_ROT_STEP3
	btfsc	REG,3 ; HA_STEP_REG
	goto	HA_CCW_ROT_STEP3

S1_CW_ROT_STEP3 ;seta passo simples 1 no sentido horario(0)...nada muda
	movlw	STEP4 ;copia combinação de bits do passo 4 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

S1_CCW_ROT_STEP3 ;seta passo simples 1 no sentido anti-horario(1)
	bsf		COIL1
	bcf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP2 ;copia combinação de bits do passo 2 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP	

S2_CW_ROT_STEP3 ;seta passo simples 2 no sentido horario(0)...nada muda
	movlw	STEP4 ;copia combinação de bits do passo 4 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

S2_CCW_ROT_STEP3 ;seta passo simples 2 no sentido anti-horario(1)
	bsf		COIL1
	bsf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP2 ;copia combinação de bits do passo 2 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CW_ROT_STEP3 ;seta meio passo no sentido horario(0)
	bcf		COIL1
	bsf		COIL2
	bsf		COIL3
	bcf		COIL4
	movlw	STEP4 ;copia combinação de bits do passo 4 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CCW_ROT_STEP3 ;seta meio passo no sentido anti-horario(1)
	bsf		COIL1
	bsf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP2 ;copia combinação de bits do passo 2 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

;################## STEP 4 ################################################
STEP4_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STEP4
	goto	CCW_STEP4

CW_STEP4 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;S1_STEP_REG
	goto	S1_CW_ROT_STEP4
	btfsc	REG,2 ;S2_STEP_REG
	goto	S2_CW_ROT_STEP4
	btfsc	REG,3 ;HA_STEP_REG
	goto	HA_CW_ROT_STEP4

CCW_STEP4 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; S1_STEP1_REG
	goto	S1_CCW_ROT_STEP4
	btfsc	REG,2 ; S2_STEP_REG
	goto	S2_CCW_ROT_STEP4
	btfsc	REG,3 ; HA_STEP_REG
	goto	HA_CCW_ROT_STEP4

S1_CW_ROT_STEP4 ;seta passo simples 1 no sentido horario(0)
	bcf		COIL1
	bcf		COIL2
	bsf		COIL3
	bcf		COIL4
	movlw	STEP5 ;copia combinação de bits do passo 5 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

S1_CCW_ROT_STEP4 ;seta passo simples 1 no sentido anti-horario(1)...nada muda
	movlw	STEP3 ;copia combinação de bits do passo 3 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP	

S2_CW_ROT_STEP4 ;seta passo simples 2 no sentido horario(0)
	bcf		COIL1
	bcf		COIL2
	bsf		COIL3
	bsf		COIL4
	movlw	STEP5 ;copia combinação de bits do passo 5 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

S2_CCW_ROT_STEP4 ;seta passo simples 2 no sentido anti-horario(1)..nada muda
	movlw	STEP3 ;copia combinação de bits do passo 3 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

HA_CW_ROT_STEP4 ;seta meio passo no sentido horario(0)
	bcf		COIL1
	bcf		COIL2
	bsf		COIL3
	bcf		COIL4
	movlw	STEP5 ;copia combinação de bits do passo 5 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CCW_ROT_STEP4 ;seta meio passo no sentido anti-horario(1)
	bcf		COIL1
	bsf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP3 ;copia combinação de bits do passo 3 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

;################## STEP 5 ################################################
STEP5_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STEP5
	goto	CCW_STEP5

CW_STEP5 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;S1_STEP_REG
	goto	S1_CW_ROT_STEP5
	btfsc	REG,2 ;S2_STEP_REG
	goto	S2_CW_ROT_STEP5
	btfsc	REG,3 ;HA_STEP_REG
	goto	HA_CW_ROT_STEP5

CCW_STEP5 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; S1_STEP_REG
	goto	S1_CCW_ROT_STEP5
	btfsc	REG,2 ; S2_STEP_REG
	goto	S2_CCW_ROT_STEP5
	btfsc	REG,3 ; HA_STEP_REG
	goto	HA_CCW_ROT_STEP5

S1_CW_ROT_STEP5 ;seta passo simples 1 no sentido horario(0)...nada muda
	movlw	STEP6 ;copia combinação de bits do passo 6 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

S1_CCW_ROT_STEP5 ;seta passo simples 1 no sentido anti-horario(1)
	bcf		COIL1
	bsf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP4 ;copia combinação de bits do passo 4 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP	

S2_CW_ROT_STEP5 ;seta passo simples 2 no sentido horario(0)...nada muda
	movlw	STEP6 ;copia combinação de bits do passo 6 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

S2_CCW_ROT_STEP5 ;seta passo simples 2 no sentido anti-horario(1)
	bcf		COIL1
	bsf		COIL2
	bsf		COIL3
	bcf		COIL4
	movlw	STEP4 ;copia combinação de bits do passo 4 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CW_ROT_STEP5 ;seta meio passo no sentido horario(0)
	bcf		COIL1
	bcf		COIL2
	bsf		COIL3
	bsf		COIL4
	movlw	STEP6 ;copia combinação de bits do passo 6 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CCW_ROT_STEP5 ;seta meio passo no sentido anti-horario(1)
	bcf		COIL1
	bsf		COIL2
	bsf		COIL3
	bcf		COIL4
	movlw	STEP4 ;copia combinação de bits do passo 4 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

;################## STEP 6 ################################################
STEP6_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STEP6
	goto	CCW_STEP6

CW_STEP6 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;S1_STEP_REG
	goto	S1_CW_ROT_STEP6
	btfsc	REG,2 ;S2_STEP_REG
	goto	S2_CW_ROT_STEP6
	btfsc	REG,3 ;HA_STEP_REG
	goto	HA_CW_ROT_STEP6

CCW_STEP6 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; S1_STEP_REG
	goto	S1_CCW_ROT_STEP6
	btfsc	REG,2 ; S2_STEP_REG
	goto	S2_CCW_ROT_STEP6
	btfsc	REG,3 ; HA_STEP_REG
	goto	HA_CCW_ROT_STEP6

S1_CW_ROT_STEP6 ;seta passo simples 1 no sentido horario(0)
	bcf		COIL1
	bcf		COIL2
	bcf		COIL3
	bsf		COIL4
	movlw	STEP7 ;copia combinação de bits do passo 7 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

S1_CCW_ROT_STEP6 ;seta passo simples 1 no sentido anti-horario(1)...nada muda
	movlw	STEP5 ;copia combinação de bits do passo 5 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP	

S2_CW_ROT_STEP6 ;seta passo simples 2 no sentido horario(0)
	bsf		COIL1
	bcf		COIL2
	bcf		COIL3
	bsf		COIL4
	movlw	STEP7 ;copia combinação de bits do passo 7 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

S2_CCW_ROT_STEP6 ;seta passo simples 2 no sentido anti-horario(1)...nada muda
	movlw	STEP5 ;copia combinação de bits do passo 5 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

HA_CW_ROT_STEP6 ;seta meio passo no sentido horario(0)
	bcf		COIL1
	bcf		COIL2
	bcf		COIL3
	bsf		COIL4
	movlw	STEP7 ;copia combinação de bits do passo 7 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CCW_ROT_STEP6 ;seta meio passo no sentido anti-horario(1)
	bcf		COIL1
	bcf		COIL2
	bsf		COIL3
	bcf		COIL4
	movlw	STEP5 ;copia combinação de bits do passo 5 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

;################## STEP 7 ################################################
STEP7_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STEP7
	goto	CCW_STEP7

CW_STEP7 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;S1_STEP_REG
	goto	S1_CW_ROT_STEP7
	btfsc	REG,2 ;S2_STEP_REG
	goto	S2_CW_ROT_STEP7
	btfsc	REG,3 ;HA_STEP_REG
	goto	HA_CW_ROT_STEP7

CCW_STEP7 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; S1_STEP_REG
	goto	S1_CCW_ROT_STEP7
	btfsc	REG,2 ; S2_STEP_REG
	goto	S2_CCW_ROT_STEP7
	btfsc	REG,3 ; HA_STEP_REG
	goto	HA_CCW_ROT_STEP7

S1_CW_ROT_STEP7 ;seta passo simples 1 no sentido horario(0)...nada muda
	movlw	STEP8 ;copia combinação de bits do passo 8 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

S1_CCW_ROT_STEP7 ;seta passo simples 1 no sentido anti-horario(1)
	bcf		COIL1
	bcf		COIL2
	bsf		COIL3
	bcf		COIL4
	movlw	STEP6 ;copia combinação de bits do passo 6 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP	

S2_CW_ROT_STEP7 ;seta passo simples 2 no sentido horario(0)...nada muda
	movlw	STEP8 ;copia combinação de bits do passo 8 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

S2_CCW_ROT_STEP7 ;seta passo simples 2 no sentido anti-horario(1)
	bcf		COIL1
	bcf		COIL2
	bsf		COIL3
	bsf		COIL4
	movlw	STEP6 ;copia combinação de bits do passo 6 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CW_ROT_STEP7 ;seta meio passo no sentido horario(0)
	bsf		COIL1
	bcf		COIL2
	bcf		COIL3
	bsf		COIL4
	movlw	STEP8 ;copia combinação de bits do passo 8 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CCW_ROT_STEP7 ;seta meio passo no sentido anti-horario(1)
	bcf		COIL1
	bcf		COIL2
	bsf		COIL3
	bsf		COIL4
	movlw	STEP6 ;copia combinação de bits do passo 6 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

;################## STEP 8 ################################################
STEP8_OPT ;sentido do proximo passo
	btfss	REG,0 ; DIR_REG
	goto	CW_STEP8
	goto	CCW_STEP8

CW_STEP8 ;escolha de tipo passo no sentido horário(0)
	btfsc	REG,1 ;S1_STEP_REG
	goto	S1_CW_ROT_STEP8
	btfsc	REG,2 ;S2_STEP_REG
	goto	S2_CW_ROT_STEP8
	btfsc	REG,3 ;HA_STEP_REG
	goto	HA_CW_ROT_STEP8

CCW_STEP8 ;escolha de tipo passo no sentido anti-horário(1)
	btfsc	REG,1 ; S1_STEP1_REG
	goto	S1_CCW_ROT_STEP8
	btfsc	REG,2 ; S2_STEP_REG
	goto	S2_CCW_ROT_STEP8
	btfsc	REG,3 ; HA_STEP_REG
	goto	HA_CCW_ROT_STEP8

S1_CW_ROT_STEP8 ;seta passo simples 1 no sentido horario(0)
	bsf		COIL1
	bcf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP1 ;copia combinação de bits do passo 1 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

S1_CCW_ROT_STEP8 ;seta passo simples 1 no sentido anti-horario(1)...nada muda
	movlw	STEP7 ;copia combinação de bits do passo 7 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP	

S2_CW_ROT_STEP8 ;seta passo simples 2 no sentido horario(0)
	bsf		COIL1
	bsf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP1 ;copia combinação de bits do passo 1 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

S2_CCW_ROT_STEP8 ;seta passo simples 2 no sentido anti-horario(1)...nada muda
	movlw	STEP7 ;copia combinação de bits do passo 7 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	;call	DELAY
	goto	CHECK_CUR_STEP

HA_CW_ROT_STEP8 ;seta meio passo no sentido horario(0)
	bsf		COIL1
	bcf		COIL2
	bcf		COIL3
	bcf		COIL4
	movlw	STEP1 ;copia combinação de bits do passo 1 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

HA_CCW_ROT_STEP8 ;seta meio passo no sentido anti-horario(1)
	bcf		COIL1
	bcf		COIL2
	bcf		COIL3
	bsf		COIL4
	movlw	STEP7 ;copia combinação de bits do passo 7 em W
	movwf	CUR_STEP ;salva valor de W em CUR_STEP
	call	DELAY
	goto	CHECK_CUR_STEP

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