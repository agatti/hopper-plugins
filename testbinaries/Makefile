# Copyright (c) 2014, Alessandro Gatti - frob.it
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

all: 6502opcodes.bin 6502jumps.bin 65c02opcodes.bin 65c02jumps.bin \
	65816opcodes.bin 65816per.bin r6500opcodes.bin r65c02opcodes.bin \
	w65c02sopcodes.bin

6502opcodes.bin: 6502opcodes.s
	xa -C -W -o 6502opcodes.bin 6502opcodes.s

6502jumps.bin: 6502jumps.s
	xa -C -W -o 6502jumps.bin 6502jumps.s

65c02opcodes.bin: 65c02opcodes.s
	xa -W -o 65c02opcodes.bin 65c02opcodes.s

65c02jumps.bin: 65c02jumps.s
	xa -W -o 65c02jumps.bin 65c02jumps.s

65816opcodes.bin: 65816opcodes.s
	xa -w -o 65816opcodes.bin 65816opcodes.s

65816per.bin: 65816per.s
	xa -w -o 65816per.bin 65816per.s

r6500opcodes.bin: r6500opcodes.s
	xa -W -o r6500opcodes.bin r6500opcodes.s

r65c02opcodes.bin: r65c02opcodes.s
	xa -W -o r65c02opcodes.bin r65c02opcodes.s

w65c02sopcodes.bin: w65c02sopcodes.s
	xa -w -o w65c02sopcodes.bin w65c02sopcodes.s

clean:
	rm -f *.bin *.o
