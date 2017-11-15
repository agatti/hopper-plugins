# Copyright (c) 2014-2017, Alessandro Gatti - frob.it
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
# SUBSTITUTE GOODS OR SERVICES# LOSS OF USE, DATA, OR PROFITS# OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

.PHONY: all clean

ASL=asl
P2BIN=p2bin
RM=rm
TEST_FILES=jump.s opcodes.s switch.s synthetic8x300.s synthetic8x305.s
OBJECT_FILES=$(patsubst %.s,%.p,$(TEST_FILES))
BINARY_FILES=$(patsubst %.p,%.bin,$(OBJECT_FILES))

%.p: %.s
	@$(ASL) -o $@ $<

%.bin: %.p
	@$(P2BIN) -r "$$"-"$$" $< $@

all: $(BINARY_FILES)

clean:
	@$(RM) -f $(OBJECT_FILES) $(BINARY_FILES)

