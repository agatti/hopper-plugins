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

farjumps	JMP	$7FFF
		JMP	$8000
		JMP	$8001
		JMP	$FFFE
		JMP	$FFFF
jumpstart	NOP
		NOP
		JMP	jumpstart
		NOP
		NOP
loop		JMP	loop
		NOP
		BCC	bcc_forward
		NOP
bcc_forward	NOP
		NOP
		NOP
		NOP
bcc_backwards	NOP
		NOP
		NOP
		NOP
		BCC	bcc_backwards
		NOP
		BCS	bcs_forward
		NOP
bcs_forward	NOP
		NOP
		NOP
		NOP
bcs_backwards	NOP
		NOP
		NOP
		NOP
		BCS	bcs_backwards
		NOP
		BEQ	beq_forward
		NOP
beq_forward	NOP
		NOP
		NOP
		NOP
beq_backwards	NOP
		NOP
		NOP
		NOP
		BEQ	beq_backwards
		NOP
		BMI	bmi_forward
		NOP
bmi_forward	NOP
		NOP
		NOP
		NOP
bmi_backwards	NOP
		NOP
		NOP
		NOP
		BMI	bmi_backwards
		NOP
		BNE	bne_forward
		NOP
bne_forward	NOP
		NOP
		NOP
		NOP
bne_backwards	NOP
		NOP
		NOP
		NOP
		BNE	bne_backwards
		NOP
		BPL	bpl_forward
		NOP
bpl_forward	NOP
		NOP
		NOP
		NOP
bpl_backwards	NOP
		NOP
		NOP
		NOP
		BPL	bpl_backwards
		NOP
		BVC	bvc_forward
		NOP
bvc_forward	NOP
		NOP
		NOP
		NOP
bvc_backwards	NOP
		NOP
		NOP
		NOP
		BVC	bvc_backwards
		NOP
		BVS	bvs_forward
		NOP
bvs_forward	NOP
		NOP
		NOP
		NOP
bvs_backwards	NOP
		NOP
		NOP
		NOP
		BVS	bvs_backwards
		NOP
		JMP	jmp_forward
		NOP
jmp_forward	NOP
		NOP
		NOP
		NOP
jmp_backwards	NOP
		NOP
		NOP
		NOP
		JMP	jmp_backwards
		NOP
		JSR	jsr_forward
		NOP
jsr_forward	NOP
		NOP
		NOP
		NOP
jsr_backwards	NOP
		NOP
		NOP
		NOP
		JSR	jsr_backwards
		NOP
		BRA	bra_forward
		NOP
bra_forward	NOP
		NOP
		NOP
		NOP
bra_backwards	NOP
		NOP
		NOP
		NOP
		BRA	bra_backwards
		NOP

		RTS
