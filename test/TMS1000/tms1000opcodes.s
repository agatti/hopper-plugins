; Copyright (c) 2014-2020, Alessandro Gatti - frob.it
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

		CPU	tms1000

		; 0xh

		COMX
		A8AAC
		YNEA
		TAM
		TAMZA
		A10AAC
		A6AAC
		DAN
		TKA
		KNEZ
		TDO
		CLO
		RSTR
		SETR
		IA
		RETN

		; 1xh

		LDP	0
		LDP	1
		LDP	2
		LDP	3
		LDP	4
		LDP	5
		LDP	6
		LDP	7
		LDP	8
		LDP	9
		LDP	10
		LDP	11
		LDP	12
		LDP	13
		LDP	14
		LDP	15

		; 2xh

		TAMIY
		TMA
		TMY
		TYA
		TAY
		AMAAC
		MNEZ
		SAMAN
		IMAC
		ALEM
		DMAN
		IYC
		DYN
		CPAIZ
		XMA
		CLA

		; 3xh

		SBIT	0
		SBIT	1
		SBIT	2
		SBIT	3
		RBIT	0
		RBIT	1
		RBIT	2
		RBIT	3
		TBIT1	0
		TBIT1	1
		TBIT1	2
		TBIT1	3
		LDX	0
		LDX	1
		LDX	2
		LDX	3

		; 4xh

		TCY	0
		TCY	1
		TCY	2
		TCY	3
		TCY	4
		TCY	5
		TCY	6
		TCY	7
		TCY	8
		TCY	9
		TCY	10
		TCY	11
		TCY	12
		TCY	13
		TCY	14
		TCY	15

		; 5xh

		YNEC	0
		YNEC	1
		YNEC	2
		YNEC	3
		YNEC	4
		YNEC	5
		YNEC	6
		YNEC	7
		YNEC	8
		YNEC	9
		YNEC	10
		YNEC	11
		YNEC	12
		YNEC	13
		YNEC	14
		YNEC	15

		; 6xh

		TCMIY	0
		TCMIY	1
		TCMIY	2
		TCMIY	3
		TCMIY	4
		TCMIY	5
		TCMIY	6
		TCMIY	7
		TCMIY	8
		TCMIY	9
		TCMIY	10
		TCMIY	11
		TCMIY	12
		TCMIY	13
		TCMIY	14
		TCMIY	15

		; 7xh

		ALEC	0
		ALEC	1
		ALEC	2
		ALEC	3
		ALEC	4
		ALEC	5
		ALEC	6
		ALEC	7
		ALEC	8
		ALEC	9
		ALEC	10
		ALEC	11
		ALEC	12
		ALEC	13
		ALEC	14
		ALEC	15

		; 8xh

		BR	00h
		BR	01h
		BR	02h
		BR	03h
		BR	04h
		BR	05h
		BR	06h
		BR	07h
		BR	08h
		BR	09h
		BR	0Ah
		BR	0Bh
		BR	0Ch
		BR	0Dh
		BR	0Eh
		BR	0Fh

		; 9xh

		BR	10h
		BR	11h
		BR	12h
		BR	13h
		BR	14h
		BR	15h
		BR	16h
		BR	17h
		BR	18h
		BR	19h
		BR	1Ah
		BR	1Bh
		BR	1Ch
		BR	1Dh
		BR	1Eh
		BR	1Fh

		; Axh

		BR	20h
		BR	21h
		BR	22h
		BR	23h
		BR	24h
		BR	25h
		BR	26h
		BR	27h
		BR	28h
		BR	29h
		BR	2Ah
		BR	2Bh
		BR	2Ch
		BR	2Dh
		BR	2Eh
		BR	2Fh

		; Bxh

		BR	30h
		BR	31h
		BR	32h
		BR	33h
		BR	34h
		BR	35h
		BR	36h
		BR	37h
		BR	38h
		BR	39h
		BR	3Ah
		BR	3Bh
		BR	3Ch
		BR	3Dh
		BR	3Eh
		BR	3Fh

		; Cxh

		CALL	00h
		CALL	01h
		CALL	02h
		CALL	03h
		CALL	04h
		CALL	05h
		CALL	06h
		CALL	07h
		CALL	08h
		CALL	09h
		CALL	0Ah
		CALL	0Bh
		CALL	0Ch
		CALL	0Dh
		CALL	0Eh
		CALL	0Fh

		; Dxh

		CALL	10h
		CALL	11h
		CALL	12h
		CALL	13h
		CALL	14h
		CALL	15h
		CALL	16h
		CALL	17h
		CALL	18h
		CALL	19h
		CALL	1Ah
		CALL	1Bh
		CALL	1Ch
		CALL	1Dh
		CALL	1Eh
		CALL	1Fh

		; Exh

		CALL	20h
		CALL	21h
		CALL	22h
		CALL	23h
		CALL	24h
		CALL	25h
		CALL	26h
		CALL	27h
		CALL	28h
		CALL	29h
		CALL	2Ah
		CALL	2Bh
		CALL	2Ch
		CALL	2Dh
		CALL	2Eh
		CALL	2Fh

		; Fxh

		CALL	30h
		CALL	31h
		CALL	32h
		CALL	33h
		CALL	34h
		CALL	35h
		CALL	36h
		CALL	37h
		CALL	38h
		CALL	39h
		CALL	3Ah
		CALL	3Bh
		CALL	3Ch
		CALL	3Dh
		CALL	3Eh
		CALL	3Fh
