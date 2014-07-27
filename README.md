Hopper Plugins
===

Plugins currently available in the repository:

###**6502 CPU Support** - _v0.0.6_

This CPU core plugin allows you to disassemble 6502/65C02 code, used in loads of home computers of the 70s, 80s, and early 90s, and in industrial automation or other specialised tasks where a microcontroller is needed.

CPUs currently supported:

* CMD: G65SC02-A
* Generic 6502 and 65C02 for chips by compatible vendors.
* HudsonSoft: HuC6280
* MOS: 6502, 6507, 6508, 6509, 6510, 7501, 8500, 8501, 8502
* Ricoh: 2A03
* Rockwell: R6500/11, R6500/12, R6500/15, R6500/16, R6502, R6503, R6504, R6505, R6505, R6507, R6512, R6513, R6514, R6515
* Synertek: 6502
* UMC: UM6502, UM6507, UM6512
* WDC: W65C02S

####TODO for next version:

* Add support for more 6502 variants if any are found in the wild.
* Attempt to reject files too big for address-space reduced chip variants.
* Add predefined hardware locations like RESET and NMI.

####Caveats:

* Undocumented opcodes are not recognised.

###**CBM File Loader** - _v0.0.4_

This file loader plugin allows you to load Commodore 16/116/64/+4/VIC20 binaries to be disassembled.  Commodore 128 files are currently not supported due to the fact that binaries may be bigger than 64k and thus something may need to be rearranged.  _(Please note that the plugin depends on the 6502 CPU core to be installed in order to work properly)_

####TODO for next version:

* Investigate Commodore 128 files support.
* Add support for containers (Disk and Tape images).
* Add support for cartdriges.
* Add support for BASIC versions different than V2 (the one present in the Commodore 64).

####Caveats:

* The plugin can also handle BASIC loader stubs if any are present, although the detokenizer for that is quite flaky and barely tested.  Invalid or improper BASIC code will probably crash the plugin, and bring Hopper down with it.

##Installation instructions:

Checkout from Git, open `HopperPlugins.xcworkspace` in Xcode, select the `Everything` scheme and then rebuild.  Once done, copy the bundles whose name ends in `.hopperLoader` into `~/Library/Application Support/Hopper/PlugIns/Loaders/` and the bundles whose name ends in `.hopperCPU` into `~/Library/Application Support/Hopper/PlugIns/CPUs/`.  Keep in mind that these plugins require **Hopper 3.3.5** or later to work.  They may work on older versions but they are neither tested nor supported on anything older than v3.3.5.

##Need to get in touch?

Shoot an email to `a.gatti * frob.it` (yep, replace the asterisk, you know what to do).

