HopperC64 0.0.1
---
A couple of simple plugins allowing Hopper to load and disassemble C64 executables.

Once built, copy C64Loader.hopperLoader to ~/Library/Application&nbsp;Support/Hopper/Plugins/Loader/, and copy MOS6502CPU.hopperCPU to ~/Library/Application&nbsp;Support/Hopper/Plugins/CPUs/.

### Caveats:

* The C64 File loader can also handle BASIC loader stubs if any are present, although the detokenizer for that is quite flaky and barely tested.  Invalid or improper BASIC code may crash the plugin, and bring Hopper down with it.

* The MOS 6502 CPU module does not recognise undocumented opcodes.
