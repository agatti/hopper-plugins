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
		
		cpu	65c02

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

row_0		BRK
		ORA	(ZEROPAGE_0,X)
		TSB	ZEROPAGE_0
		ORA	ZEROPAGE_0
		ASL	ZEROPAGE_0
		RMB0	ZEROPAGE_0
		PHP
		ORA	$00
		ASL
		TSB	datablockabs
		ORA	datablockabs
		ASL	datablockabs
		BBR0	ZEROPAGE_0,row_1
		JMP	row_1

row_1		BPL	row_1_target
		ORA	(ZEROPAGE_1),Y
row_1_target	ORA	(ZEROPAGE_1)
		TRB	ZEROPAGE_1
		ORA	ZEROPAGE_1,X
		ASL	ZEROPAGE_1,X
		RMB1	ZEROPAGE_1
		CLC
		ORA	datablockabs,Y
		INC
		TRB	datablockabs
		ORA	datablockabs,X
		ASL	datablockabs,X
		BBR1	ZEROPAGE_1,row_2
		JMP	row_2

row_2		JSR	farcode
		AND	(ZEROPAGE_2,X)
		BIT	ZEROPAGE_2
		AND	ZEROPAGE_2
		ROL	ZEROPAGE_2
		RMB2	ZEROPAGE_2
		PLP
		AND	#$22
		ROL
		BIT	datablockabs
		AND	datablockabs
		ROL	datablockabs
		BBR2	ZEROPAGE_2,row_3
		JMP	row_3
		
row_3		BMI	row_3_target
		AND	(ZEROPAGE_3),Y
row_3_target	AND	(ZEROPAGE_3)
		BIT	ZEROPAGE_3,X
		AND	ZEROPAGE_3,X
		ROL	ZEROPAGE_3,X
		RMB3	ZEROPAGE_3
		SEC
		AND	datablockabs,Y
		DEC
		BIT	datablockabs,X
		AND	datablockabs,X
		ROL	datablockabs,X
		BBR3	ZEROPAGE_3,row_4
		JMP	row_4

row_4		RTI
		EOR	(ZEROPAGE_4,X)
		EOR	ZEROPAGE_4
		LSR	ZEROPAGE_4
		RMB4	ZEROPAGE_4
		PHA
		EOR	#$44
		LSR
		JMP	farcode
		EOR	datablockabs
		LSR	datablockabs
		BBR4	ZEROPAGE_4,row_5
		JMP	row_5

row_5		BVC	row_5_target
		EOR	(ZEROPAGE_5),Y
row_5_target	EOR	ZEROPAGE_5,X
		LSR	ZEROPAGE_5,X
		RMB5	ZEROPAGE_5
		CLI
		EOR	datablockabs,Y
		PHY
		EOR	datablockabs,X
		LSR	datablockabs,X
		BBR5	ZEROPAGE_5,row_6
		JMP	row_6

row_6		RTS
		ADC	(ZEROPAGE_6,X)
		STZ	ZEROPAGE_6
		ADC	ZEROPAGE_6
		ROR	ZEROPAGE_6
		RMB6	ZEROPAGE_6
		PLA
		ADC	#$66
		ROR
		JMP	farcode
		ADC	datablockabs
		ROR	datablockabs
		BBR6	ZEROPAGE_6,row_7
		JMP	row_7

row_7		BVS	row_7_target
		ADC	(ZEROPAGE_7),Y
row_7_target	ADC	(ZEROPAGE_7)
		STZ	ZEROPAGE_7,X
		ADC	ZEROPAGE_7,X
		ROR	ZEROPAGE_7,X
		RMB7	ZEROPAGE_7
		SEI
		ADC	datablockabs,Y
		PLY
		JMP	(farcode,X)
		ADC	datablockabs,X
		ROR	datablockabs,X
		BBR7	ZEROPAGE_7,row_8
		JMP	row_8

row_8		BRA	row_8_target
		STA	(ZEROPAGE_8,X)
row_8_target	STY	ZEROPAGE_8
		STA	ZEROPAGE_8
		STX	ZEROPAGE_8
		SMB0	ZEROPAGE_8
		DEY
		BIT	#$88
		TXA
		STY	datablockabs
		STA	datablockabs
		STX	datablockabs
		BBS0	ZEROPAGE_8,row_9
		JMP	row_9

row_9		BCC	row_9_target
		STA	(ZEROPAGE_9),Y
row_9_target	STA	(ZEROPAGE_9)
		STY	ZEROPAGE_9,X
		STA	ZEROPAGE_9,X
		STX	ZEROPAGE_9,Y
		SMB1	ZEROPAGE_9
		TYA
		STA	datablockabs,Y
		TXS
		STZ	datablockabs
		STA	datablockabs,X
		STZ	datablockabs,X
		BBS1	ZEROPAGE_9,row_a
		JMP	row_a

row_a		LDY	#$AA
		LDA	(ZEROPAGE_A,X)
		LDX	#$AA
		LDY	ZEROPAGE_A
		LDA	ZEROPAGE_A
		LDX	ZEROPAGE_A
		SMB2	ZEROPAGE_A
		TAY
		LDA	#$AA
		TAX
		LDY	datablockabs
		LDA	datablockabs
		LDX	datablockabs
		BBS2	ZEROPAGE_A,row_b
		JMP	row_b

row_b		BCS	row_b_target
		LDA	(ZEROPAGE_B),Y
row_b_target	LDA	(ZEROPAGE_B)
		LDY	ZEROPAGE_B,X
		LDA	ZEROPAGE_B,X
		LDX	ZEROPAGE_B,Y
		SMB3	ZEROPAGE_B
		CLV
		LDA	datablockabs,Y
		TSX
		LDY	datablockabs,X
		LDA	datablockabs,X
		LDX	datablockabs,Y
		BBS3	ZEROPAGE_B,row_c
		JMP	row_c

row_c		CPY	#$CC
		CMP	(ZEROPAGE_C,X)
		CPY	ZEROPAGE_C
		CMP	ZEROPAGE_C
		DEC	ZEROPAGE_C
		SMB4	ZEROPAGE_C
		INY
		CMP	#$CC
		DEX
		CPY	datablockabs
		CMP	datablockabs
		DEC	datablockabs
		BBS4	ZEROPAGE_C,row_d
		JMP	row_d

row_d		BNE	row_d_target
		CMP	(ZEROPAGE_D),Y
row_d_target	CMP	(ZEROPAGE_D)
		CMP	ZEROPAGE_D,X
		DEC	ZEROPAGE_D,X
		SMB5	ZEROPAGE_D
		CLD
		CMP	datablockabs,Y
		PHX
		CMP	datablockabs,X
		DEC	datablockabs,X
		BBS5	ZEROPAGE_D,row_e
		JMP	row_e

row_e		CPX	#$EE
		SBC	(ZEROPAGE_E,X)
		CPX	ZEROPAGE_E
		SBC	ZEROPAGE_E
		INC	ZEROPAGE_E
		SMB6	ZEROPAGE_E
		INX
		SBC	#$EE
		NOP
		CPX	datablockabs
		SBC	datablockabs
		INC	datablockabs
		BBS6	ZEROPAGE_E,row_f
		JMP	row_f

row_f		BEQ	row_f_target
		SBC	(ZEROPAGE_F),Y
row_f_target	SBC	(ZEROPAGE_F)
		SBC	ZEROPAGE_F,X
		INC	ZEROPAGE_F,X
		SMB7	ZEROPAGE_F
		SED
		SBC	datablockabs,Y
		PLX
		SBC	datablockabs,X
		INC	datablockabs,X
		BBS7	ZEROPAGE_F,end
		JMP	end

end		RTS

datablockabs	ADR	$1234

farcode		RTI
