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

		CPU	8x300

		ORG	$0

		; Test ADD opcode.

		ADD	R1,R1
		ADD	R2(1),R2
		ADD	4,R3

		; Test AND opcode.

		AND	R2,R2
		AND	R3(1),R3
		AND	3,R2

		; Test MOVE opcode.

		MOVE	R1,IVL
		MOVE	R5(4),R1
		MOVE	3,R3
	
		; Test NZT opcode.

		NZT	R4,*
		NZT	LIV1,*

		; Test XEC opcode.

		XEC	$0(R4)
		XEC	$1(R1)
		XEC	$1(liv2),2

		; Test XMIT opcode.

		XMIT	1,R1
		XMIT	0,R2
		XMIT	-1,R3

		; Test XOR opcode.

		XOR	R4,R1
		XOR	R5(1),R6
