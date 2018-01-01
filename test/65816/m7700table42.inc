; Copyright (c) 2014-2018, Alessandro Gatti - frob.it
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

		; $420x

		ORA	B,(ZEROPAGE_0,X)
		ORA	B,ZEROPAGE_0,S
		ORA	B,ZEROPAGE_0
		ORAL	B,(ZEROPAGE_0)
		ORA	B,#$00
		ASL	B
		ORA	B,datablockabs
		ORA	B,$FF0000

		; $421x

		ORA	B,(ZEROPAGE_1),Y
		ORA	B,(ZEROPAGE_1)
		ORA	B,(ZEROPAGE_1,S),Y
		ORA	B,ZEROPAGE_1,X
		ORAL	B,(ZEROPAGE_1),Y
		ORA	B,datablockabs,Y
		DEC	B
		TBS
		ORA	B,datablockabs,X
		ORA	B,$FF1111,X

		; $422x

		AND	B,(ZEROPAGE_2,X)
		AND	B,ZEROPAGE_2,S
		AND	B,ZEROPAGE_2
		ANDL	B,(ZEROPAGE_2)
		AND	B,#$22
		ROL	B
		AND	B,datablockabs
		AND	B,$FF2222

		; $423x

		AND	B,(ZEROPAGE_3),Y
		AND	B,(ZEROPAGE_3)
		AND	B,(ZEROPAGE_3,S),Y
		AND	B,ZEROPAGE_3,X
		ANDL	B,(ZEROPAGE_3),Y
		AND	B,datablockabs,Y
		INC	B
		TSB
		AND	B,datablockabs,X
		AND	B,$FF3333,X

		; $424x

		EOR	B,(ZEROPAGE_4,X)
		EOR	B,ZEROPAGE_3,S
		EOR	B,ZEROPAGE_4
		EORL	B,(ZEROPAGE_4)
		PHB
		EOR	B,#$44
		LSR	B
		EOR	B,datablockabs
		EOR	B,$FF4444

		; $425x

		EOR	B,(ZEROPAGE_5),Y
		EOR	B,(ZEROPAGE_5)
		EOR	B,(ZEROPAGE_5,S),Y
		EOR	B,ZEROPAGE_5,X
		EORL	B,(ZEROPAGE_5),Y
		EOR	B,datablockabs,Y
		TBD
		EOR	B,datablockabs,X
		EOR	B,$FF5555,X

		; $426x

		ADC	B,(ZEROPAGE_6,X)
		ADC	B,ZEROPAGE_6,S
		ADC	B,ZEROPAGE_6
		ADCL	B,(ZEROPAGE_6)
		PLB
		ADC	B,#$66
		ROR	B
		ADC	B,datablockabs
		ADC	B,$FF6666

		; $427x

		ADC	B,(ZEROPAGE_7),Y
		ADC	B,(ZEROPAGE_7)
		ADC	B,(ZEROPAGE_7,S),Y
		ADC	B,ZEROPAGE_7,X
		ADCL	B,(ZEROPAGE_7),Y
		ADC	B,datablockabs,Y
		TDB
		ADC	B,datablockabs,X
		ADC	B,$FF7777,X

		; $428x

		STA	B,(ZEROPAGE_8,X)
		STA	B,ZEROPAGE_8,S
		STA	B,ZEROPAGE_8
		STAL	B,(ZEROPAGE_8)
		TXB
		STA	B,datablockabs
		STA	B,$FF8888

		; $429x

		STA	B,(ZEROPAGE_9),Y
		STA	B,(ZEROPAGE_9)
		STA	B,(ZEROPAGE_9,S),Y
		STA	B,ZEROPAGE_9,X
		STAL	B,(ZEROPAGE_9),Y
		TYB
		STA	B,datablockabs,Y
		STA	B,datablockabs,X
		STA	B,$FF9999,X

		; $42Ax

		LDA	B,(ZEROPAGE_A,X)
		LDA	B,ZEROPAGE_A,S
		LDA	B,ZEROPAGE_A
		LDAL	B,(ZEROPAGE_A)
		TBY
		LDA	B,#$AA
		TBX
		LDA	B,datablockabs
		LDA	B,$FFAAAA

		; $42Bx

		LDA	B,(ZEROPAGE_B),Y
		LDA	B,(ZEROPAGE_B)
		LDA	B,(ZEROPAGE_B,S),Y
		LDA	B,ZEROPAGE_B,X
		LDAL	B,(ZEROPAGE_B),Y
		LDA	B,datablockabs,Y
		LDA	B,datablockabs,X
		LDA	B,$FFBBBB,X

		; $42Cx

		CMP	B,(ZEROPAGE_C,X)
		CMP	B,ZEROPAGE_C,S
		CMP	B,ZEROPAGE_C
		CMPL	B,(ZEROPAGE_C)
		CMP	B,#$CC
		CMP	B,datablockabs
		CMP	B,$FFCCCC

		; $42Dx

		CMP	B,(ZEROPAGE_D),Y
		CMP	B,(ZEROPAGE_D)
		CMP	B,(ZEROPAGE_D,S),Y
		CMP	B,ZEROPAGE_D,X
		CMPL	B,(ZEROPAGE_D),Y
		CMP	B,datablockabs,Y
		CMP	B,datablockabs,X
		CMP	B,$FFDDDD,X

		; $42Ex

		SBC	B,(ZEROPAGE_E,X)
		SBC	B,ZEROPAGE_E,S
		SBC	B,ZEROPAGE_E
		SBCL	B,(ZEROPAGE_E)
		SBC	B,#$EE
		SBC	B,datablockabs
		SBC	B,$FFEEEE

		; $42Fx

		SBC	B,(ZEROPAGE_F),Y
		SBC	B,(ZEROPAGE_F)
		SBC	B,(ZEROPAGE_F,S),Y
		SBC	B,ZEROPAGE_F,X
		SBCL	B,(ZEROPAGE_F),Y
		SBC	B,datablockabs,Y
		SBC	B,datablockabs,X
		SBC	B,$FFFFFF,X

		RTS

datablockabs	ADR	$1234

