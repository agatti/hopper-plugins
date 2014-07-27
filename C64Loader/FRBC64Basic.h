/*!
 Copyright (c) 2014, Alessandro Gatti
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef C64Basic_h
#define C64Basic_h

static const char * const FRBC64BasicTokens[256] = {
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    "END", "FOR", "NEXT", "DATA", "INPUT#", "INPUT",
    "DIM", "READ", "LET", "GOTO", "RUN", "IF",
    "RESTORE", "GOSUB", "RETURN", "REM", "STOP", "ON",
    "WAIT", "LOAD", "SAVE", "VERIFY", "DEF", "POKE",
    "PRINT#", "PRINT", "CONT", "LIST", "CLR", "CMD",
    "SYS", "OPEN", "CLOSE", "GET", "NEW", "TAB(", "TO",
    "FN", "SPC(", "THEN", "NOT", "STEP", "+", "-", "*",
    "/", "^", "AND", "OR", ">", "=", "<", "SGN", "INT",
    "ABS", "USR", "FRE", "POS", "SQR", "RND", "LOG",
    "EXP", "COS", "SIN", "TAN", "PEEK", "LEN", "STR$",
    "VAL", "ASC", "CHR$", "LEFT$", "RIGHT$", "MID$",
    "GO", NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, "PI",
};

static const char * const FRBC64PetsciiCharacters[256] = {
    "{$00}", "{$01}", "{$02}", "{$03}", "{$04}", "{WHITE}", "{$06}",
    "{$07}", "{$08}", "{$09}", "{$0A}", "{$0B}", "{$0C}", "{$0D}",
    "{LOWERCASE}", "{$0F}", "{$10}", "{DOWN}", "{RVSON}", "{HOME}",
    "{DELETE}", "{$15}", "{$16}", "{$17}", "{$18}", "{$19}", "{$1A}",
    "{$1B}", "{RED}", "{RIGHT}", "{GREEN}", "{BLUE}", " ", "!", "\"", "#",
    "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1",
    "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?",
    "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[",
    "\\", "]", "^", "_", "{$60}", "{$61}", "{$62}", "{$63}", "{$64}",
    "{$65}", "{$66}", "{$67}", "{$68}", "{$69}", "{$6A}", "{$6B}", "{$6C}",
    "{$6D}", "{$6E}", "{$6F}", "{$70}", "{$71}", "{$72}", "{$73}", "{$74}",
    "{$75}", "{$76}", "{$77}", "{$78}", "{$79}", "{$7A}", "{$7B}", "{$7C}",
    "{$7D}", "{PI}", "{$7F}", "{$80}", "{ORANGE}", "{$82}", "{$83}",
    "{$84}", "{F1}", "{F3}", "{F5}", "{F7}", "{F2}", "{F4}", "{F6}", "{F8}",
    "{SHIFT-ENTER}", "{UPPERCASE}", "{$8F}", "{BLACK}", "{UP}", "{RVSOFF}",
    "{CLR}", "{INS}", "{BROWN}", "{LRED}", "{GREY1}", "{GREY2}", "{LGREEN}",
    "{LBLUE}", "{GREY3}", "{PURPLE}", "{LEFT}", "{YELLOW}", "{CYAN}",
    "{SHIFT-SPACE}", "{$A1}", "{$A2}", "{$A3}", "{$A4}", "{$A5}", "{$A6}",
    "{$A7}", "{$A8}", "{$A9}", "{$AA}", "{$AB}", "{$AC}", "{$AD}", "{$AE}",
    "{$AF}", "{$B0}", "{$B1}", "{$B2}", "{$B3}", "{$B4}", "{$B5}", "{$B6}",
    "{$B7}", "{$B8}", "{$B9}", "{$BA}", "{$BB}", "{$BC}", "{$BD}", "{$BE}",
    "{$BF}", "{$C0}", "{$C1}", "{$C2}", "{$C3}", "{$C4}", "{$C5}", "{$C6}",
    "{$C7}", "{$C8}", "{$C9}", "{$CA}", "{$CB}", "{$CC}", "{$CD}", "{$CE}",
    "{$CF}", "{$D0}", "{$D1}", "{$D2}", "{$D3}", "{$D4}", "{$D5}", "{$D6}",
    "{$D7}", "{$D8}", "{$D9}", "{$DA}", "{$DB}", "{$DC}", "{$DD}", "{$DE}",
    "{$DF}", "{$E0}", "{$E1}", "{$E2}", "{$E3}", "{$E4}", "{$E5}", "{$E6}",
    "{$E7}", "{$E8}", "{$E9}", "{$EA}", "{$EB}", "{$EC}", "{$ED}", "{$EE}",
    "{$EF}", "{$F0}", "{$F1}", "{$F2}", "{$F3}", "{$F4}", "{$F5}", "{$F6}",
    "{$F7}", "{$F8}", "{$F9}", "{$FA}", "{$FB}", "{$FC}", "{$FD}", "{$FE}",
    "{$FF}",
};

#endif
