; Copyright (c) 2014-2021, Alessandro Gatti - frob.it
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
		
		cpu	melps740

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

row_0		BRK
		ORA	(ZEROPAGE_0,X)
		JSR	(ZEROPAGE_0)
		BBS	0,A,row_0
		;
		ORA	ZEROPAGE_0
		ASL	ZEROPAGE_0
		BBS	0,ZEROPAGE_0,row_0
		PHP
		ORA	#$0
		ASL
		SEB	0,A
		;
		ORA	datablockabs
		ASL	datablockabs
		SEB	0,ZEROPAGE_0

		; $1x

row_1		BPL	row_1_target
		ORA	(ZEROPAGE_1),Y
row_1_target	CLT
		BBC	0,A,row_1
		;
		ORA	ZEROPAGE_1,X
		ASL	ZEROPAGE_1,X
		BBC	0,ZEROPAGE_1,row_1
		CLC
		ORA	datablockabs,Y
		DEC
		CLB	0,A
		;
		ORA	datablockabs,X
		ASL	datablockabs,X
		CLB	0,ZEROPAGE_1

		; $2x

row_2		JSR	farcode
		AND	(ZEROPAGE_2,X)
		JSR	\$E0
		BBS	1,A,row_2
		BIT	ZEROPAGE_2
		AND	ZEROPAGE_2
		ROL	ZEROPAGE_2
		BBS	1,ZEROPAGE_2,row_2
		PLP
		AND	#$22
		ROL
		SEB	1,A
		BIT	datablockabs
		AND	datablockabs
		ROL	datablockabs
		SEB	1,ZEROPAGE_2
		
		; $3x

row_3		BMI	row_3_target
		AND	(ZEROPAGE_3),Y
row_3_target	SET
		BBC	1,A,row_3
		;
		AND	ZEROPAGE_3,X
		ROL	ZEROPAGE_3,X
		BBC	1,ZEROPAGE_3,row_3
		SEC
		AND	datablockabs,Y
		INC
		CLB	1,A
		LDM	#$33,ZEROPAGE_3
		AND	datablockabs,X
		ROL	datablockabs,X
		CLB	1,ZEROPAGE_3

		; $4x

row_4		RTI
		EOR	(ZEROPAGE_4,X)
		STP
		BBS	2,A,row_4
		COM	ZEROPAGE_4
		EOR	ZEROPAGE_4
		LSR	ZEROPAGE_4
		BBS	2,ZEROPAGE_4,row_4
		PHA
		EOR	#$44
		LSR
		SEB	2,A
		JMP	farcode
		EOR	datablockabs
		LSR	datablockabs
		SEB	2,ZEROPAGE_4

		; $5x

row_5		BVC	row_5_target
		EOR	(ZEROPAGE_5),Y
		;
row_5_target	BBC	2,A,row_5
		;
		EOR	ZEROPAGE_5,X
		LSR	ZEROPAGE_5,X
		BBC	2,ZEROPAGE_5,row_5
		CLI
		EOR	datablockabs,Y
		;
		CLB	2,A
		;
		EOR	datablockabs,X
		LSR	datablockabs,X
		CLB	2,ZEROPAGE_5

		; $6x

row_6		RTS
		ADC	(ZEROPAGE_6,X)
		MUL	ZEROPAGE_6,X
		BBS	3,A,row_6
		TST	ZEROPAGE_6
		ADC	ZEROPAGE_6
		ROR	ZEROPAGE_6
		BBS	3,ZEROPAGE_6,row_6
		PLA
		ADC	#$66
		ROR
		SEB	3,A
		JMP	(datablockabs)
		ADC	datablockabs
		ROR	datablockabs
		SEB	3,ZEROPAGE_6

		; $7x

row_7		BVS	row_7_target
		ADC	(ZEROPAGE_7),Y
		;
row_7_target	BBC	3,A,row_7
		;
		ADC	ZEROPAGE_7,X
		ROR	ZEROPAGE_7,X
		BBC	3,ZEROPAGE_7,row_7
		SEI
		ADC	datablockabs,Y
		;
		CLB	3,A
		;
		ADC	datablockabs,X
		ROR	datablockabs,X
		CLB	3,ZEROPAGE_7

		; $8x

row_8		BRA	row_8_target
		STA	(ZEROPAGE_8,X)
row_8_target	RRF	ZEROPAGE_8
		BBS	4,A,row_8
		STY	ZEROPAGE_8
		STA	ZEROPAGE_8
		STX	ZEROPAGE_8
		BBS	4,ZEROPAGE_8,row_8
		DEY
		;
		TXA
		SEB	4,A
		STY	datablockabs
		STA	datablockabs
		STX	datablockabs
		SEB	4,ZEROPAGE_8

		; $9x

row_9		BCC	row_9_target
		STA	(ZEROPAGE_9),Y
		;
row_9_target	BBC	4,A,row_9
		STY	ZEROPAGE_9,X
		STA	ZEROPAGE_9,X
		STX	ZEROPAGE_9,Y
		BBC	4,ZEROPAGE_9,row_9
		TYA
		STA	datablockabs,Y
		TXS
		CLB	4,A
		;
		STA	datablockabs,X
		;
		CLB	4,ZEROPAGE_9

		; $Ax

row_a		LDY	#$AA
		LDA	(ZEROPAGE_A,X)
		LDX	#$AA
		BBS	5,A,row_a
		LDY	ZEROPAGE_A
		LDA	ZEROPAGE_A
		LDX	ZEROPAGE_A
		BBS	5,ZEROPAGE_A,row_a
		TAY
		LDA	#$AA
		TAX
		SEB	5,A
		LDY	datablockabs
		LDA	datablockabs
		LDX	datablockabs
		SEB	5,ZEROPAGE_A

		; $Bx

row_b		BCS	row_b_target
		LDA	(ZEROPAGE_B),Y
row_b_target	JMP	(ZEROPAGE_B)
		BBC	5,A,row_b
		LDY	ZEROPAGE_B,X
		LDA	ZEROPAGE_B,X
		LDX	ZEROPAGE_B,Y
		BBC	5,ZEROPAGE_B,row_b
		CLV
		LDA	datablockabs,Y
		TSX
		CLB	5,A
		LDY	datablockabs,X
		LDA	datablockabs,X
		LDX	datablockabs,Y
		CLB	5,ZEROPAGE_B

		; $Cx

row_c		CPY	#$CC
		CMP	(ZEROPAGE_C,X)
		WIT
		BBS	6,A,row_c
		CPY	ZEROPAGE_C
		CMP	ZEROPAGE_C
		DEC	ZEROPAGE_C
		BBS	6,ZEROPAGE_C,row_c
		INY
		CMP	#$CC
		DEX
		SEB	6,A
		CPY	datablockabs
		CMP	datablockabs
		DEC	datablockabs
		SEB	6,ZEROPAGE_C

		; $Dx

row_d		BNE	row_d_target
		CMP	(ZEROPAGE_D),Y
		;
row_d_target	BBC	6,A,row_d
		;
		CMP	ZEROPAGE_D,X
		DEC	ZEROPAGE_D,X
		BBC	6,ZEROPAGE_D,row_d
		CLD
		CMP	datablockabs,Y
		;
		CLB	6,A
		;
		CMP	datablockabs,X
		DEC	datablockabs,X
		CLB	7,ZEROPAGE_D

		; $Ex

row_e		CPX	#$EE
		SBC	(ZEROPAGE_E,X)
		DIV	ZEROPAGE_E,X
		BBS	7,A,row_e
		CPX	ZEROPAGE_E
		SBC	ZEROPAGE_E
		INC	ZEROPAGE_E
		BBS	7,ZEROPAGE_E,row_e
		INX
		SBC	#$EE
		NOP
		SEB	7,A
		CPX	datablockabs
		SBC	datablockabs
		INC	datablockabs
		SEB	7,ZEROPAGE_E

		; $Fx

row_f		BEQ	row_f_target
		SBC	(ZEROPAGE_F),Y
		;
row_f_target	BBC	7,A,row_f
		;
		SBC	ZEROPAGE_F,X
		INC	ZEROPAGE_F,X
		BBC	7,ZEROPAGE_F,row_f
		SED
		SBC	datablockabs,Y
		;
		CLB	7,A
		;
		SBC	datablockabs,X
		INC	datablockabs,X
		CLB	7,ZEROPAGE_7

end		RTS

datablockabs	ADR	$1234

farcode		RTI
