		.MEMORYMAP
		slotsize $10000
		defaultslot 0
		slot 0 $1000
		.ENDME

		.ROMBANKMAP
		bankstotal 1
		banksize $10000
		banks 1
		.ENDRO

		.ORG $0
		.ORGA $1000

row0:		NOP
		OR A,$00
		OR A,!$1234
		OR A,(X)
		OR A,($00+X)
		OR A,#$00
		OR $00,$01
