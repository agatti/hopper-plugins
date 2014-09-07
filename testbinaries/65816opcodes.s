; Copyright (c) 2014, Alessandro Gatti - frob.it
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
		
#define ZEROPAGE_0 $0
#define ZEROPAGE_1 $1
#define ZEROPAGE_2 $2
#define ZEROPAGE_3 $3
#define ZEROPAGE_4 $4
#define ZEROPAGE_5 $5
#define ZEROPAGE_6 $6
#define ZEROPAGE_7 $7
#define ZEROPAGE_8 $8
#define ZEROPAGE_9 $9
#define ZEROPAGE_A $a
#define ZEROPAGE_B $b
#define ZEROPAGE_C $c
#define ZEROPAGE_D $d
#define ZEROPAGE_E $e
#define ZEROPAGE_F $f

		*=$1000

row0 		BRK
		ORA (ZEROPAGE_0,X)
		COP #$00
		ORA ZEROPAGE_0,S
		TSB ZEROPAGE_0
		ORA ZEROPAGE_0
		ASL ZEROPAGE_0
		ORA [ZEROPAGE_0]
		PHP
		ORA #$00
		ASL
		PHD
		TSB datablockabs
		ORA datablockabs
		ASL datablockabs
		ORA @datablockabs+@$FF0000
		JMP row1

row1		BPL row1_target
 		ORA (ZEROPAGE_1),Y
row1_target	ORA (ZEROPAGE_1)
		ORA (ZEROPAGE_1,S),Y
		TRB ZEROPAGE_1
		ORA ZEROPAGE_1,X
 		ASL ZEROPAGE_1,X
		ORA [ZEROPAGE_1],Y
		CLC
		ORA datablockabs,Y
		INC
		TCS
		TRB datablockabs
		ORA datablockabs,X
		ASL datablockabs,X
		ORA @datablockabs+@$FF0000,X
		JMP row2

row2		JSR farcode
 		AND (ZEROPAGE_2,X)
		JSR @datablockabs+@$FF0000
		AND ZEROPAGE_2,S
 		BIT ZEROPAGE_2
 		AND ZEROPAGE_2
 		ROL ZEROPAGE_2
		AND [ZEROPAGE_2]
 		PLP
 		AND #$22
 		ROL
		PLD
 		BIT datablockabs
 		AND datablockabs
 		ROL datablockabs
		AND @datablockabs+@$FF0000
 		JMP row3

row3		BMI row3_target
 		AND (ZEROPAGE_3),Y
row3_target	AND (ZEROPAGE_3)
		AND (ZEROPAGE_3,S),Y
		BIT ZEROPAGE_3,X
		AND ZEROPAGE_3,X
 		ROL ZEROPAGE_3,X
		AND [ZEROPAGE_3],Y
 		SEC
 		AND datablockabs,Y
		DEC
		TSC
		BIT datablockabs,X
 		AND datablockabs,X
 		ROL datablockabs,X
		AND @datablockabs+@$FF0000,X
 		JMP row4

row4		RTI
 		EOR (ZEROPAGE_4,X)
		.byte $42 ; WDM
		EOR ZEROPAGE_3,S
		MVP $4444 ; Should be $44, $44 instead
		EOR ZEROPAGE_4
 		LSR ZEROPAGE_4
		EOR [ZEROPAGE_4]
 		PHA
 		EOR #$44
 		LSR
		PHK
 		JMP farcode
 		EOR datablockabs
 		LSR datablockabs
		EOR @datablockabs+@$FF0000
 		JMP row5
 
row5		BVC row5_target
 		EOR (ZEROPAGE_5),Y
row5_target	EOR (ZEROPAGE_5)
		EOR (ZEROPAGE_5,S),Y
		MVN $5555 ; Should be $55, $55 instead
		EOR ZEROPAGE_5,X
 		LSR ZEROPAGE_5,X
		EOR [ZEROPAGE_5],Y
 		CLI
 		EOR datablockabs,Y
		PHY
		TCD
		JMP @datablockabs+@$FF0000
 		EOR datablockabs,X
 		LSR datablockabs,X
		EOR @datablockabs+@$FF0000,X
 		JMP row6
 
row6		RTS
 		ADC (ZEROPAGE_6,X)
		PER datablockabs
		ADC ZEROPAGE_6,S
		STZ ZEROPAGE_6
 		ADC ZEROPAGE_6
 		ROR ZEROPAGE_6
		ADC [ZEROPAGE_6]
 		PLA
 		ADC #$66
 		ROR
		RTL
 		JMP (datablockabs)
 		ADC datablockabs
 		ROR datablockabs
		ADC @datablockabs+@$FF0000
 		JMP row7
 
row7		BVS row7_target
 		ADC (ZEROPAGE_7),Y
row7_target	ADC (ZEROPAGE_7)
		ADC (ZEROPAGE_7,S),Y
		STZ ZEROPAGE_7,X
		ADC ZEROPAGE_7,X
 		ROR ZEROPAGE_7,X
		ADC [ZEROPAGE_7],Y
 		SEI
 		ADC datablockabs,Y
		PLY
		TDC
		JMP (datablockabs,X)
 		ADC datablockabs,X
 		ROR datablockabs,X
		ADC @datablockabs+@$FF0000,X
 		JMP row8
 
row8		BRA row8_target
		STA (ZEROPAGE_8,X)
row8_target	BRL datablockabs
		STA ZEROPAGE_8,S
		STY ZEROPAGE_8
 		STA ZEROPAGE_8
 		STX ZEROPAGE_8
		STA [ZEROPAGE_8]
 		DEY
		BIT #$88
 		TXA
		PHB
 		STY datablockabs
 		STA datablockabs
 		STX datablockabs
		STA @datablockabs+@$FF0000
 		JMP row9
 
row9		BCC row9_target
 		STA (ZEROPAGE_9),Y
row9_target	STA (ZEROPAGE_9)
		STA (ZEROPAGE_9,S),Y
		STY ZEROPAGE_9,X
 		STA ZEROPAGE_9,X
 		STX ZEROPAGE_9,Y
		STA [ZEROPAGE_9],Y
 		TYA
 		STA datablockabs,Y
 		TXS
		TXY
 		STA datablockabs,X
		STZ datablockabs,X
		STA @datablockabs+@$FF0000,X
 		JMP rowa
 
rowa		LDY #$AA
 		LDA (ZEROPAGE_A,X)
 		LDX #$AA
		LDA ZEROPAGE_A,S
 		LDY ZEROPAGE_A
 		LDA ZEROPAGE_A
 		LDX ZEROPAGE_A
		LDA [ZEROPAGE_A]
 		TAY
 		LDA #$AA
 		TAX
		PLB
 		LDY datablockabs
 		LDA datablockabs
 		LDX datablockabs
		LDA @datablockabs+@$FF0000
 		JMP rowb
 
rowb		BCS rowb_target
 		LDA (ZEROPAGE_B),Y
rowb_target	LDA (ZEROPAGE_B)
		LDA (ZEROPAGE_B,S),Y
		LDY ZEROPAGE_B,X
 		LDA ZEROPAGE_B,X
 		LDX ZEROPAGE_B,Y
		LDA [ZEROPAGE_B],Y
 		CLV
 		LDA datablockabs,Y
 		TSX
		TYX
 		LDY datablockabs,X
 		LDA datablockabs,X
 		LDX datablockabs,Y
		LDA @datablockabs+@$FF0000,X
 		JMP rowc
 
rowc		CPY #$CC
 		CMP (ZEROPAGE_C,X)
		REP #$CC
		CMP ZEROPAGE_C,S
 		CPY ZEROPAGE_C
 		CMP ZEROPAGE_C
 		DEC ZEROPAGE_C
		CMP [ZEROPAGE_C]
 		INY
 		CMP #$CC
 		DEX
		WAI
 		CPY datablockabs
 		CMP datablockabs
 		DEC datablockabs
		CMP @datablockabs+@$FF0000
 		JMP rowd
 
rowd		BNE rowd_target
 		CMP (ZEROPAGE_D),Y
rowd_target	CMP (ZEROPAGE_D)
		CMP (ZEROPAGE_D,S),Y
		PEI (ZEROPAGE_D)
		CMP ZEROPAGE_D,X
 		DEC ZEROPAGE_D,X
		CMP [ZEROPAGE_D],Y
 		CLD
 		CMP datablockabs,Y
		PHX
		STP
		.byte $DC, $34, $12 ; JML (label)
 		CMP datablockabs,X
 		DEC datablockabs,X
		CMP @datablockabs+@$FF0000,X
 		JMP rowe
 
rowe		CPX #$EE
 		SBC (ZEROPAGE_E,X)
		SEP #$EE
		SBC ZEROPAGE_E,S
 		CPX ZEROPAGE_E
 		SBC ZEROPAGE_E
 		INC ZEROPAGE_E
		SBC [ZEROPAGE_E]
 		INX
 		SBC #$EE
 		NOP
		XBA
 		CPX datablockabs
 		SBC datablockabs
 		INC datablockabs
		SBC @datablockabs+@$FF0000
 		JMP rowf
 
rowf		BEQ rowf_target
 		SBC (ZEROPAGE_F),Y
rowf_target	SBC (ZEROPAGE_F)
		SBC (ZEROPAGE_F,S),Y
		PEA $1000
		SBC ZEROPAGE_F,X
 		INC ZEROPAGE_F,X
		SBC [ZEROPAGE_F],Y
 		SED
 		SBC datablockabs,Y
		PLX
		XCE
		JSR (datablockabs,X)
 		SBC datablockabs,X
 		INC datablockabs,X
		SBC @datablockabs+@$FF0000,X
 		JMP end

end		RTS

datablockabs	.word $1234

farcode		RTI
