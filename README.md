Hopper Plugins
===

Plugins currently available in the repository:

***

**MOS 6502 CPU** - _v0.0.3_

This CPU core plugin allows you to disassemble 6502 code, used in loads of home computers of the 70s, 80s, and early 90s, and in industrial automation or other specialised tasks where a microcontroller is needed.

###TODO for next version:

* Add support for other 6502 variants (65C02, 65SC02, W65C02S, R65C00, HuC6280, etc.)

###Caveats:

* Undocumented opcodes are not recognised.

* Offsets are not recognised as such, therefore if you try to cast an absolute value as an offset the plugin will happily ignore your request and not show the label name if one is present at the address shown (nor will create one if there is not).

**CBM File Loader** - _v0.0.3_

This file loader plugin allows you to load Commodore 16/116/64/+4/VIC20 binaries to be disassembled.  Commodore 128 files are currently not supported due to the fact that binaries may be bigger than 64k and thus something may need to be rearranged.  _(Please note that the plugin depends on the MOS6502 CPU core to be installed in order to work properly)_

###TODO for next version:

* Investigate Commodore 128 files support.
* Add support for containers (Disk and Tape images).
* Add support for cartdriges.
* Add support for BASIC versions different than V2 (the one present in the Commodore 64).

###Caveats:

* The plugin can also handle BASIC loader stubs if any are present, although the detokenizer for that is quite flaky and barely tested.  Invalid or improper BASIC code will probably crash the plugin, and bring Hopper down with it.

---

#Installation instructions:

Checkout from Git, open `HopperPlugins.xcworkspace` in Xcode, select the `Everything` scheme and then rebuild.  Once done, copy the bundles whose name ends in `.hopperLoader` into `~/Library/Application Support/Hopper/PlugIns/Loaders/` and the bundles whose name ends in `.hopperCPU` into `~/Library/Application Support/Hopper/PlugIns/CPUs/`.  Keep in mind that these plugins require **Hopper 3.3.3** or later to work.  They may work on older versions but they are neither tested nor supported on anything older than v3.3.3.

#Need to get in touch?

Shoot an email to `a.gatti * frob.it` (yep, replace the asterisk, you know what to do).

