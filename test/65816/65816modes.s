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
		
		cpu	65816
		page	0
		org	$1000

		assume	m:1
		assume	x:1

		ADC	#$11
		AND	#$22
		BIT	#$33
		CMP	#$44
		CPX	#$55
		CPY	#$66
		EOR	#$77
		LDA	#$88
		LDX	#$99
		LDY	#$AA
		ORA	#$BB
		SBC	#$CC

		assume	m:0
		assume	x:1

		ADC	#$1111
		AND	#$2222
		BIT	#$3333
		CMP	#$4444
		CPX	#$55
		CPY	#$66
		EOR	#$7777
		LDA	#$8888
		LDX	#$99
		LDY	#$AA
		ORA	#$BBBB
		SBC	#$CCCC

		assume	m:1
		assume	x:0

		ADC	#$11
		AND	#$22
		BIT	#$33
		CMP	#$44
		CPX	#$5555
		CPY	#$6666
		EOR	#$77
		LDA	#$88
		LDX	#$9999
		LDY	#$AAAA
		ORA	#$BB
		SBC	#$CC

		assume	m:0
		assume	x:0

		ADC	#$1111
		AND	#$2222
		BIT	#$3333
		CMP	#$4444
		CPX	#$5555
		CPY	#$6666
		EOR	#$7777
		LDA	#$8888
		LDX	#$9999
		LDY	#$AAAA
		ORA	#$BBBB
		SBC	#$CCCC
