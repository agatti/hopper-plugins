; Copyright (c) 2014-2017, Alessandro Gatti - frob.it
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

		; $890x

		MPY	(ZEROPAGE_0,X)
		MPY	ZEROPAGE_0,S
		MPY	ZEROPAGE_0
		MPYL	(ZEROPAGE_0)
		MPY	#$00
		MPY	datablockabs
		MPY	$FF0000

		; $891x

		MPY	(ZEROPAGE_1),Y
		MPY	(ZEROPAGE_1)
		MPY	(ZEROPAGE_1,S),Y
		MPYL	(ZEROPAGE_1),Y
		MPY	datablockabs,Y
		MPY	datablockabs,X
		MPY	$FF0000,X

		; $892x

		DIV	(ZEROPAGE_2,X)
		DIV	ZEROPAGE_2,S
		DIV	ZEROPAGE_2
		DIVL	(ZEROPAGE_2)
		XAB
		DIV	#$22
		DIV	datablockabs
		DIV	$FF0000

		; $893x

		DIV	(ZEROPAGE_3),Y
		DIV	(ZEROPAGE_3)
		DIV	(ZEROPAGE_3,S),Y
		DIVL	(ZEROPAGE_3),Y
		DIV	datablockabs,Y
		DIV	datablockabs,X
		DIV	$FF0000,X

		; $894x

		RLA	#$44

		; $89Cx

		LDT	#$55

		RTS

datablockabs	ADR	$1234

