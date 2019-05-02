; Copyright (c) 2014-2019, Alessandro Gatti - frob.it
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; 1. Redistributions of source code must retain the above copyright notice,
;    this list of conditions and the following disclaimer.
;
; 2. Redistributions in binary form must reproduce the above copyright notice,
;    this list of conditions and the following disclaimer in the documentation
;    and/or other materials provided with the distribution.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.
		
		org	$1000

ZEROPAGE_0	equ	$0
ZEROPAGE_1	equ	$1
ZEROPAGE_2	equ	$2
ZEROPAGE_3	equ	$3
ZEROPAGE_4	equ	$4
ZEROPAGE_5	equ	$5
ZEROPAGE_6	equ	$6
ZEROPAGE_7	equ	$7
ZEROPAGE_8	equ	$8
ZEROPAGE_9	equ	$9
ZEROPAGE_A	equ	$A
ZEROPAGE_B	equ	$B
ZEROPAGE_C	equ	$C
ZEROPAGE_D	equ	$D
ZEROPAGE_E	equ	$E
ZEROPAGE_F	equ	$F

		; $0x

		BRK
		ORA	A,(ZEROPAGE_0,X)
		ORA	A,ZEROPAGE_0,S
		SEB	#$1,ZEROPAGE_0
		ORA	A,ZEROPAGE_0
		ASL	ZEROPAGE_0
		ORAL	A,(ZEROPAGE_0)
		PHP
		ORA	A,#$00
		ASL	A
		PHD
		SEB	#$1,datablockabs
		ORA	A,datablockabs
		ASL	datablockabs
		ORA	A,$FF0000

		; $1x

		BPL	row_1_target
		ORA	A,(ZEROPAGE_1),Y
row_1_target	ORA	A,(ZEROPAGE_1)
		ORA	A,(ZEROPAGE_1,S),Y
		CLB	#$2,ZEROPAGE_1
		ORA	A,ZEROPAGE_1,X
		ASL	ZEROPAGE_1,X
		ORAL	A,(ZEROPAGE_1),Y
		CLC
		ORA	A,datablockabs,Y
		DEC	A
		TAS
		CLB	#$2,datablockabs
		ORA	A,datablockabs,X
		ASL	datablockabs,X
		ORA	A,$FF1111,X
 
		; $2x

row_2		JSR	farcode
		AND	A,(ZEROPAGE_2,X)
		JSR	$FF2222
		AND	A,ZEROPAGE_2,S
		BBS	#$01,ZEROPAGE_2,row_2
		AND	A,ZEROPAGE_2
		ROL	ZEROPAGE_2
		ANDL	A,(ZEROPAGE_2)
		PLP
		AND	A,#$22
		ROL	A
		PLD
		BBS	#$01,datablockabs,row_2
		AND	A,datablockabs
		ROL	datablockabs
		AND	A,$FF2222
 
		; $3x

row_3		BMI	row_3_target
		AND	A,(ZEROPAGE_3),Y
row_3_target	AND	A,(ZEROPAGE_3)
		AND	A,(ZEROPAGE_3,S),Y
		BBC	#$01,ZEROPAGE_3,row_3
		AND	A,ZEROPAGE_3,X
		ROL	ZEROPAGE_3,X
		ANDL	A,(ZEROPAGE_3),Y
		SEC
		AND	A,datablockabs,Y
		INC	A
		TSA
		BBC	#$01,datablockabs,row_3
		AND	A,datablockabs,X
		ROL	datablockabs,X
		AND	A,$FF3333,X

		; $4x

		RTI
		EOR	A,(ZEROPAGE_4,X)
		EOR	A,ZEROPAGE_3,S
		MVP	$440000,$440000
		EOR	A,ZEROPAGE_4
		LSR	ZEROPAGE_4
		EORL	A,(ZEROPAGE_4)
		PHA
		EOR	A,#$44
		LSR	A
		PHG
		JMP	farcode
		EOR	A,datablockabs
		LSR	datablockabs
		EOR	A,$FF4444

		; $5x

		BVC	row_5_target
		EOR	A,(ZEROPAGE_5),Y
row_5_target	EOR	A,(ZEROPAGE_5)
		EOR	A,(ZEROPAGE_5,S),Y
		MVN	$550000,$550000
		EOR	A,ZEROPAGE_5,X
		LSR	ZEROPAGE_5,X
		EORL	A,(ZEROPAGE_5),Y
		CLI
		EOR	A,datablockabs,Y
		PHY
		TCD
		JMP	$FF5555
		EOR	A,datablockabs,X
		LSR	datablockabs,X
		EOR	A,$FF5555,X

		; $6x

		RTS
		ADC	A,(ZEROPAGE_6,X)
		PER	datablockabs
		ADC	A,ZEROPAGE_6,S
		LDM	#$66,ZEROPAGE_6
		ADC	A,ZEROPAGE_6
		ROR	ZEROPAGE_6
		ADCL	A,(ZEROPAGE_6)
		PLA
		ADC	A,#$66
		ROR	A
		RTL
		JMP	(datablockabs)
		ADC	A,datablockabs
		ROR	datablockabs
		ADC	A,$FF6666

		; $7x

		BVS	row_7_target
		ADC	A,(ZEROPAGE_7),Y
row_7_target	ADC	A,(ZEROPAGE_7)
		ADC	A,(ZEROPAGE_7,S),Y
		LDM	#$77,ZEROPAGE_7,X
		ADC	A,ZEROPAGE_7,X
		ROR	ZEROPAGE_7,X
		ADCL	A,(ZEROPAGE_7),Y
		SEI
		ADC	A,datablockabs,Y
		PLY
		TDA
		JMP	(datablockabs,X)
		ADC	A,datablockabs,X
		ROR	datablockabs,X
		ADC	A,$FF7777,X

		; $8x

		BRA	row_8_target
		STA	A,(ZEROPAGE_8,X)
row_8_target	BRAL	$8888
		STA	A,ZEROPAGE_8,S
		STY	ZEROPAGE_8
		STA	A,ZEROPAGE_8
		STX	ZEROPAGE_8
		STAL	A,(ZEROPAGE_8)
		DEY
		TXA
		PHT
		STY	datablockabs
		STA	A,datablockabs
		STX	datablockabs
		STA	A,$FF8888

		; $9x

		BCC	row_9_target
		STA	A,(ZEROPAGE_9),Y
row_9_target	STA	A,(ZEROPAGE_9)
		STA	A,(ZEROPAGE_9,S),Y
		STY	ZEROPAGE_9,X
		STA	A,ZEROPAGE_9,X
		STX	ZEROPAGE_9,Y
		STAL	A,(ZEROPAGE_9),Y
		TYA
		STA	A,datablockabs,Y
		TXS
		TXY
		LDM	#$99,datablockabs
		STA	A,datablockabs,X
		LDM	#$99,datablockabs,X
		STA	A,$FF9999,X

		; $Ax

		LDY	#$AA
		LDA	A,(ZEROPAGE_A,X)
		LDX	#$AA
		LDA	A,ZEROPAGE_A,S
		LDY	ZEROPAGE_A
		LDA	A,ZEROPAGE_A
		LDX	ZEROPAGE_A
		LDAL	A,(ZEROPAGE_A)
		TAY
		LDA	A,#$AA
		TAX
		PLT
		LDY	datablockabs
		LDA	A,datablockabs
		LDX	datablockabs
		LDA	A,$FFAAAA

		; $Bx

		BCS	row_b_target
		LDA	A,(ZEROPAGE_B),Y
row_b_target	LDA	A,(ZEROPAGE_B)
		LDA	A,(ZEROPAGE_B,S),Y
		LDY	ZEROPAGE_B,X
		LDA	A,ZEROPAGE_B,X
		LDX	ZEROPAGE_B,Y
		LDAL	A,(ZEROPAGE_B),Y
		CLV
		LDA	A,datablockabs,Y
		TSX
		TYX
		LDY	datablockabs,X
		LDA	A,datablockabs,X
		LDX	datablockabs,Y
		LDA	A,$FFBBBB,X

		; $Cx

		CPY	#$CC
		CMP	A,(ZEROPAGE_C,X)
		REP	#$CC
		CMP	A,ZEROPAGE_C,S
		CPY	ZEROPAGE_C
		CMP	A,ZEROPAGE_C
		DEC	ZEROPAGE_C
		CMPL	A,(ZEROPAGE_C)
		INY
		CMP	A,#$CC
		DEX
		WIT
		CPY	datablockabs
		CMP	A,datablockabs
		DEC	datablockabs
		CMP	A,$FFCCCC

		; $Dx

		BNE	row_d_target
		CMP	A,(ZEROPAGE_D),Y
row_d_target	CMP	A,(ZEROPAGE_D)
		CMP	A,(ZEROPAGE_D,S),Y
		PEI	(ZEROPAGE_D)
		CMP	A,ZEROPAGE_D,X
		DEC	ZEROPAGE_D,X
		CMPL	A,(ZEROPAGE_D),Y
		CLM
		CMP	A,datablockabs,Y
		PHX
		STP
		JMPL	(farcode)
		CMP	A,datablockabs,X
		DEC	datablockabs,X
		CMP	A,$FFDDDD,X

		; $Ex

		CPX	#$EE
		SBC	A,(ZEROPAGE_E,X)
		SEP	#$EE
		SBC	A,ZEROPAGE_E,S
		CPX	ZEROPAGE_E
		SBC	A,ZEROPAGE_E
		INC	ZEROPAGE_E
		SBCL	A,(ZEROPAGE_E)
		INX
		SBC	A,#$EE
		NOP
		PSH	#$EE
		CPX	datablockabs
		SBC	A,datablockabs
		INC	datablockabs
		SBC	A,$FFEEEE

		; $Fx

		BEQ	row_f_target
		SBC	A,(ZEROPAGE_F),Y
row_f_target	SBC	A,(ZEROPAGE_F)
		SBC	A,(ZEROPAGE_F,S),Y
		PEA	$1000
		SBC	A,ZEROPAGE_F,X
		INC	ZEROPAGE_F,X
		SBCL	A,(ZEROPAGE_F),Y
		SEM
		SBC	A,datablockabs,Y
		PLX
		PUL	#$EE
		JSR	(datablockabs,X)
		SBC	A,datablockabs,X
		INC	datablockabs,X
		SBC	A,$FFFFFF,X

		RTS

datablockabs	ADR	$1234

farcode		RTI
