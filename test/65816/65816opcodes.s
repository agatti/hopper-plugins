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
		
		cpu	65816

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

		assume	m:1
		assume	x:1

row_0		BRK
		ORA	(ZEROPAGE_0,X)
		COP	#$00
		ORA	ZEROPAGE_0,S
		TSB	ZEROPAGE_0
		ORA	ZEROPAGE_0
		ASL	ZEROPAGE_0
		ORAL	(ZEROPAGE_0)
		PHP
		ORA	#$00
		ASL
		PHD
		TSB	datablockabs
		ORA	datablockabs
		ASL	datablockabs
		ORA	$FF0000
		JMP	row_1

row_1		BPL	row_1_target
		ORA	(ZEROPAGE_1),Y
row_1_target	ORA	(ZEROPAGE_1)
		ORA	(ZEROPAGE_1,S),Y
		TRB	ZEROPAGE_1
		ORA	ZEROPAGE_1,X
		ASL	ZEROPAGE_1,X
		ORAL	(ZEROPAGE_1),Y
		CLC
		ORA	datablockabs,Y
		INC
		TCS
		TRB	datablockabs
		ORA	datablockabs,X
		ASL	datablockabs,X
		ORA	$FF1111,X
		JMP	row_2

row_2		JSR	farcode
		AND	(ZEROPAGE_2,X)
		JSR	$FF2222
		AND	ZEROPAGE_2,S
		BIT	ZEROPAGE_2
		AND	ZEROPAGE_2
		ROL	ZEROPAGE_2
		ANDL	(ZEROPAGE_2)
		PLP
		AND	#$22
		ROL
		PLD
		BIT	datablockabs
		AND	datablockabs
		ROL	datablockabs
		AND	$FF2222
		JMP	row_3

row_3		BMI	row_3_target
		AND	(ZEROPAGE_3),Y
row_3_target	AND	(ZEROPAGE_3)
		AND	(ZEROPAGE_3,S),Y
		BIT	ZEROPAGE_3,X
		AND	ZEROPAGE_3,X
		ROL	ZEROPAGE_3,X
		ANDL	(ZEROPAGE_3),Y
		SEC
		AND	datablockabs,Y
		DEC
		TSC
		BIT	datablockabs,X
		AND	datablockabs,X
		ROL	datablockabs,X
		AND	$FF3333,X
		JMP	row_4

row_4		RTI
		EOR	(ZEROPAGE_4,X)
		BYT	$42 ; WDM
		EOR	ZEROPAGE_3,S
		MVP	$440000, $440000
		EOR	ZEROPAGE_4
		LSR	ZEROPAGE_4
		EORL	(ZEROPAGE_4)
		PHA
		EOR	#$44
		LSR
		PHK
		JMP	farcode
		EOR	datablockabs
		LSR	datablockabs
		EOR	$FF4444
		JMP	row_5
	
row_5		BVC	row_5_target
		EOR	(ZEROPAGE_5),Y
row_5_target	EOR	(ZEROPAGE_5)
		EOR	(ZEROPAGE_5,S),Y
		MVN	$550000, $550000
		EOR	ZEROPAGE_5,X
		LSR	ZEROPAGE_5,X
		EORL	(ZEROPAGE_5),Y
		CLI
		EOR	datablockabs,Y
		PHY
		TCD
		JMP	$FF5555
		EOR	datablockabs,X
		LSR	datablockabs,X
		EOR	$FF5555,X
		JMP	row_6
	
row_6		RTS
		ADC	(ZEROPAGE_6,X)
		PER	datablockabs
		ADC	ZEROPAGE_6,S
		STZ	ZEROPAGE_6
		ADC	ZEROPAGE_6
		ROR	ZEROPAGE_6
		ADCL	(ZEROPAGE_6)
		PLA
		ADC	#$66
		ROR
		RTL
		JMP	(datablockabs)
		ADC	datablockabs
		ROR	datablockabs
		ADC	$FF6666
		JMP	row_7
	
row_7		BVS	row_7_target
		ADC	(ZEROPAGE_7),Y
row_7_target	ADC	(ZEROPAGE_7)
		ADC	(ZEROPAGE_7,S),Y
		STZ	ZEROPAGE_7,X
		ADC	ZEROPAGE_7,X
		ROR	ZEROPAGE_7,X
		ADCL	(ZEROPAGE_7),Y
		SEI
		ADC	datablockabs,Y
		PLY
		TDC
		JMP	(datablockabs,X)
		ADC	datablockabs,X
		ROR	datablockabs,X
		ADC	$FF7777,X
		JMP	row_8
	
row_8		BRA	row_8_target
		STA	(ZEROPAGE_8,X)
row_8_target	BRL	datablockabs
		STA	ZEROPAGE_8,S
		STY	ZEROPAGE_8
		STA	ZEROPAGE_8
		STX	ZEROPAGE_8
		STAL	(ZEROPAGE_8)
		DEY
		BIT	#$88
		TXA
		PHB
		STY	datablockabs
		STA	datablockabs
		STX	datablockabs
		STA	$FF8888
		JMP	row_9
	
row_9		BCC	row_9_target
		STA	(ZEROPAGE_9),Y
row_9_target	STA	(ZEROPAGE_9)
		STA	(ZEROPAGE_9,S),Y
		STY	ZEROPAGE_9,X
		STA	ZEROPAGE_9,X
		STX	ZEROPAGE_9,Y
		STAL	(ZEROPAGE_9),Y
		TYA
		STA	datablockabs,Y
		TXS
		TXY
		STA	datablockabs,X
		STZ	datablockabs,X
		STA	$FF9999,X
		JMP	row_a
	
row_a		LDY	#$AA
		LDA	(ZEROPAGE_A,X)
		LDX	#$AA
		LDA	ZEROPAGE_A,S
		LDY	ZEROPAGE_A
		LDA	ZEROPAGE_A
		LDX	ZEROPAGE_A
		LDAL	(ZEROPAGE_A)
		TAY
		LDA	#$AA
		TAX
		PLB
		LDY	datablockabs
		LDA	datablockabs
		LDX	datablockabs
		LDA	$FFAAAA
		JMP	row_b
	
row_b		BCS	row_b_target
		LDA	(ZEROPAGE_B),Y
row_b_target	LDA	(ZEROPAGE_B)
		LDA	(ZEROPAGE_B,S),Y
		LDY	ZEROPAGE_B,X
		LDA	ZEROPAGE_B,X
		LDX	ZEROPAGE_B,Y
		LDAL	(ZEROPAGE_B),Y
		CLV
		LDA	datablockabs,Y
		TSX
		TYX
		LDY	datablockabs,X
		LDA	datablockabs,X
		LDX	datablockabs,Y
		LDA	$FFBBBB,X
		JMP	row_c
	
row_c		CPY	#$CC
		CMP	(ZEROPAGE_C,X)
		REP	#$CC
		CMP	ZEROPAGE_C,S
		CPY	ZEROPAGE_C
		CMP	ZEROPAGE_C
		DEC	ZEROPAGE_C
		CMPL	(ZEROPAGE_C)
		INY
		CMP	#$CC
		DEX
		WAI
		CPY	datablockabs
		CMP	datablockabs
		DEC	datablockabs
		CMP	$FFCCCC
		JMP	row_d
	
row_d		BNE	row_d_target
		CMP	(ZEROPAGE_D),Y
row_d_target	CMP	(ZEROPAGE_D)
		CMP	(ZEROPAGE_D,S),Y
		PEI	(ZEROPAGE_D)
		CMP	ZEROPAGE_D,X
		DEC	ZEROPAGE_D,X
		CMPL	(ZEROPAGE_D),Y
		CLD
		CMP	datablockabs,Y
		PHX
		STP
		JML	datablockabs
		CMP	datablockabs,X
		DEC	datablockabs,X
		CMP	$FFDDDD,X
		JMP	row_e
	
row_e		CPX	#$EE
		SBC	(ZEROPAGE_E,X)
		SEP	#$EE
		SBC	ZEROPAGE_E,S
		CPX	ZEROPAGE_E
		SBC	ZEROPAGE_E
		INC	ZEROPAGE_E
		SBCL	(ZEROPAGE_E)
		INX
		SBC	#$EE
		NOP
		XBA
		CPX	datablockabs
		SBC	datablockabs
		INC	datablockabs
		SBC	$FFEEEE
		JMP	row_f
	
row_f		BEQ	row_f_target
		SBC	(ZEROPAGE_F),Y
row_f_target	SBC	(ZEROPAGE_F)
		SBC	(ZEROPAGE_F,S),Y
		PEA	$1000
		SBC	ZEROPAGE_F,X
		INC	ZEROPAGE_F,X
		SBCL	(ZEROPAGE_F),Y
		SED
		SBC	datablockabs,Y
		PLX
		XCE
		JSR	(datablockabs,X)
		SBC	datablockabs,X
		INC	datablockabs,X
		SBC	$FFFFFF,X
		JMP	end

end		RTS

datablockabs	ADR	$1234

farcode		RTI
