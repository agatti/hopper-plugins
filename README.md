Hopper Plugins
===

Plugins currently available in the repository:

**CPU plugins:**

* [6502](#6502-cpu-plugin)
* [65816](#65816-cpu-plugin)
* [8x300](#8x300-cpu-plugin)
* [TMS1000](#tms1000-cpu-plugin)

**File loader plugins:**

* [Apple 2](#apple-ii-file-loader-plugin)
* [Commodore binaries](#commodore-file-loader-plugin)
* [HEX binary files](#hex-binary-files)

**Tool plugins:**

* [Address space tools](#address-space-tools)

<hr/>

### **6502 CPU Plugin**

_version 0.2.2_

This CPU core plugin allows you to disassemble 6502/65C02 code, used in loads of home computers of the 70s, 80s, and early 90s, and in industrial automation or other specialised tasks where an MCU is needed.

This plugin can be referenced from the command line tool using `6502` as its identifer.

CPU backends currently supported: 6502, 65C02, 65N02, 65R02, 65S02, HuC6280, MELPS740, MOS6510, M37450, R6500, R65C02, R65C19, R65C29, SunPlus, W65C02S.

<details>
<summary>Supported CPUs list</summary>
<table>
<thead>
<tr><th>Manufacturer</th><th>Model</th><th>Provider</th><th>Datasheet</th></tr>
</thead>
<tbody>
<tr><td rowspan="2">Conexant</td><td>L27</td><td>Rockwell &rarr; R65C19</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-30/DSA-596220.pdf">Datasheet</a></td></tr>
<tr><td>L28</td><td>Rockwell &rarr; R65C19</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-6/DSA-112820.pdf">Datasheet</a></td></tr>
<tr><td rowspan="3">California Micro Devices</td><td>G65SC02</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetcatalog.com/datasheet/calmicro/G65SC02.pdf">Datasheet</a></td></tr>
<tr><td>G65SC150</td><td>Generic &rarr; 65C02</td><td><a href="http://http://archive.6502.org/datasheets/cmd_g65sc150_ctu_mar2000.pdf">Datasheet</a></td></tr>
<tr><td>G65SC151</td><td>Generic &rarr; 65C02</td><td><a href="http://archive.6502.org/datasheets/cmd_g65sc151_ctu_mar2000.pdf">Datasheet</a></td></tr>
<tr><td>GTE</td><td>GS65C02</td><td>Generic &rarr; 65C02</td><td><a href="http://archive.6502.org/datasheets/cmd_g65sc02_mpu_mar2000.pdf">Datasheet</a></td></tr>
<tr><td rowspan="10">Hua Ko Electronics</td><td>HKE65SC02</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td>HKE65SC03</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td>HKE65SC04</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td>HKE65SC05</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td>HKE65SC06</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td>HKE65SC07</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td>HKE65SC102</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td>HKE65SC103</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td>HKE65SC104</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td>HKE65SC105</td><td>Generic &rarr; 65C02</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0049001.pdf">Datasheet</a></td></tr>
<tr><td rowspan="2">HudsonSoft</td><td>HuC6280</td><td>HudsonSoft &rarr; HuC6280</td><td>N/A</td></tr>
<tr><td>HuC6280A</td><td>HudsonSoft &rarr; HuC6280</td><td>N/A</td></tr>
<tr><td rowspan="17">Mitsubishi</td><td>M37408</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37409</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37410</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37412</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37413</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37414</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37415</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37416</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37417</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37418</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37420</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37421</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37424</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37524</td><td>Mitsubishi &rarr; MELPS740</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0039232.pdf">Datasheet</a></td></tr>
<tr><td>M37450M2</td><td>Mitsubishi &rarr; M37450</td><td><a href="http://datasheets.chipdb.org/Mitsubishi/M37450.pdf">Datasheet</a></td></tr>
<tr><td>M37450M4</td><td>Mitsubishi &rarr; M37450</td><td><a href="http://datasheets.chipdb.org/Mitsubishi/M37450.pdf">Datasheet</a></td></tr>
<tr><td>M37450M8</td><td>Mitsubishi &rarr; M37450</td><td><a href="http://datasheets.chipdb.org/Mitsubishi/M37450.pdf">Datasheet</a></td></tr>
<tr><td rowspan="18">MOS</td><td>6502</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>6503</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>6504</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>6505</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>6506</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>6507</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>6508</td><td>Generic &rarr; 6502</td><td><a href="http://6502.org/documents/datasheets/mos/mos_6508_mpu.pdf">Datasheet</a></td></tr>
<tr><td>6509</td><td>Generic &rarr; 6502</td><td><a href="http://6502.org/documents/datasheets/mos/mos_6509_mpu.pdf">Datasheet</a></td></tr>
<tr><td>6510</td><td>MOS &rarr; 6510</td><td><a href="http://archive.6502.org/datasheets/mos_6510_mpu_nov_1982.pdf">Datasheet</a></td></tr>
<tr><td>6512</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>6513</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>6514</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>6515</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/mos_6500_mpu_nov_1985.pdf">Datasheet</a></td></tr>
<tr><td>7501</td><td>Generic &rarr; 6502</td><td>N/A</td></tr>
<tr><td>8500</td><td>Generic &rarr; 6502</td><td>N/A</td></tr>
<tr><td>8501</td><td>Generic &rarr; 6502</td><td>N/A</td></tr>
<tr><td>8502</td><td>Generic &rarr; 6502</td><td>N/A</td></tr>
<tr><td>8510</td><td>Generic &rarr; 6502</td><td>N/A</td></tr>
<tr><td>NCR</td><td>NCR65C02</td><td>Generic &rarr; 65C02</td><td><a href="pdf.datasheetarchive.com/datasheetsmain/Datasheets-110/DSAP0017899.pdf">Datasheet</a></td></tr>
<tr><td rowspan="3">Novatek</td><td>NT6880</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-022/DSA00385399.pdf">Datasheet</td></tr>
<tr><td>NT6881</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-06/DSA0092333.pdf">Datasheet</td></tr>
<tr><td>NT68P1</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-015/DSA00259184.pdf">Datasheet</td></tr>
<tr><td rowspan="3">Ricoh</td><td>RP2A03</td><td>Generic &rarr; 6502</td><td>N/A</td></tr>
<tr><td>RP2A07</td><td>Generic &rarr; 6502</td><td>N/A</td></tr>
<tr><td>RP65C02</td><td>Generic &rarr; 65C02</td><td>N/A</td></tr>
<tr><td rowspan="23">Rockwell</td><td>R6500/11</td><td>Rockwell &rarr; R6500</td><td><a href="http://www.buchty.net/ensoniq/files/r6500.pdf">Datasheet</a></td></tr>
<tr><td>R6500/12</td><td>Rockwell &rarr; R6500</td><td><a href="http://www.buchty.net/ensoniq/files/r6500.pdf">Datasheet</a></td></tr>
<tr><td>R6500/13</td><td>Rockwell &rarr; R6500</td><td><a href="http://archive.6502.org/datasheets/rockwell_r6511q_r6500-13.pdf">Datasheet</a></td></tr>
<tr><td>R6500/15</td><td>Rockwell &rarr; R6500</td><td><a href="http://www.buchty.net/ensoniq/files/r6500.pdf">Datasheet</a></td></tr>
<tr><td>R6500/16</td><td>Rockwell &rarr; R6500</td><td><a href="http://www.buchty.net/ensoniq/files/r6500.pdf">Datasheet</a></td></tr>
<tr><td>R6501</td><td>Rockwell &rarr; R6500</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6502</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6503</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6504</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6505</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6506</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6507</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6511</td><td>Rockwell &rarr; R6500</td><td><a href="http://archive.6502.org/datasheets/rockwell_r6511q_r6500-13.pdf">Datasheet</a></td></tr>
<tr><td>R6512</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6513</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6514</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R6515</td><td>Generic &rarr; 6502</td><td><a href="http://archive.6502.org/datasheets/rockwell_r650x_r651x.pdf">Datasheet</a></td></tr>
<tr><td>R65C00/21</td><td>Rockwell &rarr; R65C29</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Scans-055/DSAIH000103824.pdf">Datasheet</a></td></tr>
<tr><td>R65C02</td><td>Rockwell &rarr; R65C02</td><td><a href="http://6502.org/documents/datasheets/rockwell/rockwell_r65c00_microprocessors.pdf">Datasheet</a></td></tr>
<tr><td>R65C19</td><td>Rockwell &rarr; R65C19</td><td><a href="http://archive.6502.org/datasheets/rockwell_r65c19_microcomputer.pdf">Datasheet</a></td></tr>
<tr><td>R65C29</td><td>Rockwell &rarr; R65C29</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Scans-055/DSAIH000103824.pdf">Datasheet</a></td></tr>
<tr><td>R65C102</td><td>Rockwell &rarr; R65C29</td><td><a href="http://6502.org/documents/datasheets/rockwell/rockwell_r65c00_microprocessors.pdf">Datasheet</a></td></tr>
<tr><td>R65C112</td><td>Rockwell &rarr; R65C29</td><td><a href="http://6502.org/documents/datasheets/rockwell/rockwell_r65c00_microprocessors.pdf">Datasheet</a></td></tr>
<tr><td rowspan="50">Sunplus</td><td>SPL61A</td><td>Sunplus &rarr; 65N02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL130A</td><td>Sunplus &rarr; 65N02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL191A</td><td>Sunplus &rarr; 65N02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL256A</td><td>Sunplus &rarr; 65N02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL512A</td><td>Sunplus &rarr; 65N02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL512B</td><td>Sunplus &rarr; 65N02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL1000A</td><td>Sunplus &rarr; 65N02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL1000B</td><td>Sunplus &rarr; 65N02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLB10A</td><td>Sunplus &rarr; 65N02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPF02A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL02C</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL02D</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL03B</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL03C</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL05A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL05B</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL06A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL06B</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLB20A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLB20A1</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLB21A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLB22A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLB23A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLB24A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLB25A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLB26A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL128A</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPLG01</td><td>Sunplus &rarr; 65R02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPF06A1</td><td>Sunplus &rarr; 65S02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPF18A1</td><td>Sunplus &rarr; 65S02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPF20A</td><td>Sunplus &rarr; 65S02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPF30A1</td><td>Sunplus &rarr; 65S02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPF30B</td><td>Sunplus &rarr; 65S02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL02A</td><td>Sunplus &rarr; 65S02</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPCxxx</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPCRxxx</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPMCxx</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPFA64A</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPFA120A</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL08A</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL15A</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL15B</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL25B</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL25C</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL30A</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL31A</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL60A</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<tr><td>SPL190A</td><td>Sunplus &rarr; SunPlus</td><td><a href="http://read.pudn.com/downloads89/ebook/340950/6502%E6%8C%87%E4%BB%A4/sunplus_6502.pdf">Datasheet</a></td></tr>
<td>SPMC65P1504A</td><td>Generic &rarr; 6502</td><td><a href="http://www.chinaeds.com/zl/%B3%A3%D3%C3IC/S%CF%B5%C1%D0/SP/SPmc65p1504_1502_v11_cn.pdf">Datasheet</a></td></tr>
<tr><td>SPMC65P1502A</td><td>Generic &rarr; 6502</td><td><a href="http://www.chinaeds.com/zl/%B3%A3%D3%C3IC/S%CF%B5%C1%D0/SP/SPmc65p1504_1502_v11_cn.pdf">Datasheet</a></td></tr>
<tr><td rowspan="11">Synertek</td><td>SY6502</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY6503</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY6504</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY6505</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY6506</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY6507</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY6512</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY6513</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY6514</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY6515</td><td>Generic &rarr; 6502</td><td><a href="http://www.happytrees.org/main-files/datasheets/datasheet-Synertek-SY6500.pdf">Datasheet</a></td></tr>
<tr><td>SY65C02</td><td>Generic &rarr; 65C02</td><td>N/A</td></tr>
<tr><td rowspan="3">UMC</td><td>UM6502</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-39/DSA-774496.pdf">Datasheet</a></td></tr>
<tr><td>UM6507</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-39/DSA-774496.pdf">Datasheet</a></td></tr>
<tr><td>UM6512</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-39/DSA-774496.pdf">Datasheet</a></td></tr>
<tr><td rowspan="2">VLSI</td><td>6502A</td><td>Generic &rarr; 6502</td><td>N/A</td></tr>
<tr><td>VL65NC02</td><td>WDC &rarr; W65C02S</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Scans-091/DSAHI000173435.pdf">Datasheet</a></td></tr>
<tr><td rowspan="3">WDC</td><td>W65C02S</td><td>WDC &rarr; W65C02S</td><td><a href="http://www.6502.org/documents/datasheets/wdc/wdc_w65c02s_oct_19_2010.pdf">Datasheet</a></td></tr>
<tr><td>W65C134S</td><td>WDC &rarr; W65C02S</td><td><a href="http://archive.6502.org/datasheets/wdc_w65c134s_aug_31_2010.pdf">Datasheet</a></td></tr>
<tr><td>W65C02GPMCU</td><td>WDC &rarr; W65C02S</td><td><a href="http://www.westerndesigncenter.com/wdc/documentation/W65C02GPMCU_DS.pdf">Datasheet</a></td></tr>
<tr><td rowspan="10">Weltrend</td><td>WT5090</td><td>Generic &rarr; 6502</td><td><a href="#">N/A</a></td></tr>
<tr><td>WT5091</td><td>Generic &rarr; 6502</td><td><a href="#">N/A</a></td></tr>
<tr><td>WT50P6</td><td>Generic &rarr; 6502</td><td><a href="#">N/A</a></td></tr>
<tr><td>WT6148</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0041318.pdf">Datasheet</a></td></tr>
<tr><td>WT6160</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-03/DSA0041318.pdf">Datasheet</a></td></tr>
<tr><td>WT62P2</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Datasheet-05/DSA0078955.pdf">Datasheet</a></td></tr>
<tr><td>WT65F1</td><td>Generic &rarr; 6502</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-35/DSA-696231.pdf">Datasheet</td></tr>
<tr><td>WT6511</td><td>Generic &rarr; 6502</td><td><a href="#">N/A</td></tr>
<tr><td>WT6512</td><td>Generic &rarr; 6502</td><td><a href="#">N/A</td></tr>
<tr><td>WT6512F</td><td>Generic &rarr; 6502</td><td><a href="#">N/A</td></tr>
</tbody>
</table>
</details>

#### TODO for next version(s):

* Negation for hexadecimal, decimal, and octal types.
* Re-test 6502, 65C02, R6500, R65C02, and W65C02 backends.
* Write tests for the HuC6280 backend.
* Write tests for the R65C19 backend.
* Write tests for the R65C29 backend.
* Write tests for the MOS6510 backend.
* Properly handle the extra registers present in the R65C19 variant.
* Attempt to reject files too big for address-space reduced chip variants.
* Add support for more 6502 variants if any are found in the wild.
* Properly relocate files in the 64k address space with BSS sections around data segments.
* Alternate syntax for extended opcodes (i.e. BBS0 &rarr; BBS 0,...).

#### Future plans (need Hopper SDK changes):

* A way to properly model stack changes (ie. being able to increment and decrement the virtual stack pointer when encountering PHx or PLx instructions).
* Have a customised memory map with named registers for each chip (needs BSS support first).

#### Caveats:

* Undocumented opcodes are supported only in the MOS 6510 core, as it is quite unlikely that people used them on general applications.  The MOS 6510 is used in the Commodore C64 microcomputer, where all sort of trickery is commonly used.
* Rebuilding the test binaries requires having the [AS Macroassembler](http://www.alfsembler.de/) command line tools available in your `PATH` variable.

<hr/>

### **65816 CPU Plugin**

_version 0.2.1_

This CPU core plugin allows you to disassemble 65816/65802 code, used in some of home computers of the 80s, and early 90s, for industrial automation or other specialised tasks where a microcontroller is needed, and in the Super Nintendo/Super Famicom games console.

This plugin can be referenced from the command line tool using `65816` as its identifer.

CPU backends currently supported: 65816, MELPS 7700.

<details>
<summary>Supported CPUs list</summary>
<table>
<thead>
<tr><th>Manufacturer</th><th>Model</th><th>Provider</th><th>Datasheet</th></tr>
</thead>
<tbody>
<tr><td rowspan="2">California Micro Devices</td><td>G65SC816</td><td>Generic &rarr; 65816</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0047321.pdf">Datasheet</a></td></tr>
<tr><td>G65SC802</td><td>Generic &rarr; 65816</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-112/DSAP0047321.pdf">Datasheet</a></td></tr>
<tr><td rowspan="4">WDC</td><td>W65C816S</td><td>Generic &rarr; 65816</td><td><a href="http://archive.6502.org/datasheets/wdc_w65c816s_aug_4_2008.pdf">Datasheet</a></td></tr>
<tr><td>W65C802S</td><td>Generic &rarr; 65816</td><td><a href="#">N/A</a></td></tr>
<tr><td>W65C265S</td><td>Generic &rarr; 65816</td><td><a href="http://www.westerndesigncenter.com/wdc/documentation/w65c265s.pdf">Datasheet</a></td></tr>
<tr><td>W65C816GPMCU</td><td>Generic &rarr; 65816</td><td><a href="http://www.westerndesigncenter.com/wdc/documentation/W65C816GPMCU_DS.pdf">Datasheet</a></td></tr>
<tr><td rowspan="4">Mitsubishi</td><td>M37906M4C</td><td>Mitsubishi &rarr; M7700</td><td><a href="https://www.renesas.com/zh-tw/doc/products/mpumcu/001/e7906mxx.pdf">Datasheet</a></td></tr>
<tr><td>M37906M4H</td><td>Mitsubishi &rarr; M7700</td><td><a href="https://www.renesas.com/zh-tw/doc/products/mpumcu/001/e7906mxx.pdf">Datasheet</a></td></tr>
<tr><td>M37906M6C</td><td>Mitsubishi &rarr; M7700</td><td><a href="https://www.renesas.com/zh-tw/doc/products/mpumcu/001/e7906mxx.pdf">Datasheet</a></td></tr>
<tr><td>M37906M8C</td><td>Mitsubishi &rarr; M7700</td><td><a href="https://www.renesas.com/zh-tw/doc/products/mpumcu/001/e7906mxx.pdf">Datasheet</a></td></tr>
</tbody>
</table>
</details>

#### TODO for next version:

* Add support for more 65816 variants if any are found in the wild.
* Attempt to reject files too big for address-space reduced chip variants.
* Expand the generic 65816 test suite.
* Automatically add I/O register labels for MELPS 7700.
* Properly relocate files in the entire address space with BSS sections around data segments.
* Detect emulation bit being set or cleared.

#### Future plans (need Hopper SDK changes):

* A way to properly model stack changes (ie. being able to increment and decrement the virtual stack pointer when encountering PHx or PLx instructions).

#### Caveats:

* Rebuilding the test binaries requires having the [AS Macroassembler](http://www.alfsembler.de/) command line tools available in your `PATH` variable.
* The default CPU mode has both accumulator and index registers set to 8 bits each.  This can be changed via the usual Hopper CPU mode setting facilities.

<hr/>

### **8x300 CPU Plugin**

_version 0.1.1_

This CPU core plugin allows you to disassemble 8x300 code, used in early signal processing equipment in the 70s and early 80s.

This plugin can be referenced from the command line tool using `8x300` as its identifer.

CPU backends currently supported: 8x300, 8x305.

<details>
<summary>Supported CPUs list</summary>
<table>
<thead>
<tr><th>Manufacturer</th><th>Model</th><th>Provider</th><th>Datasheet</th></tr>
</thead>
<tbody>
<tr><td rowspan="2">AMD</td><td>AM29x305</td><td>Generic &rarr; 8x305</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-115/DSAP00756.pdf">Datasheet</td></tr>
<tr><td>AM29x305A</td><td>Generic &rarr; 8x305</td><td><a href="http://pdf.datasheetarchive.com/datasheetsmain/Datasheets-115/DSAP00756.pdf">Datasheet</a></td></tr>
<tr><td>Lansdale</td><td>SL8X305</td><td>Generic &rarr; 8x305</td><td><a href="http://www.lansdale.com/datasheets/sl8x305_rev0.pdf">Datasheet</a></td></tr>
<tr><td>Philips</td><td>S8X305I</td><td>Generic &rarr; 8x305</td><td><a href="#">N/A</a></td></tr>
<tr><td>Scientific Micro Systems</td><td>SMS300</td><td>Generic &rarr; 8x300</td><td><a href="#">N/A</a></td></tr>
<tr><td rowspan="6">Signetics</td><td>N8X300I</td><td>Generic &rarr; 8x300</td><td><a href="https://ia601607.us.archive.org/1/items/bitsavers_signetics8ep80_3401307/8x300_Data_Sheet_Sep80.pdf">Datasheet</a></td></tr>
<tr><td>S8X300-1</td><td>Generic &rarr; 8x300</td><td><a href="https://ia601607.us.archive.org/1/items/bitsavers_signetics8ep80_3401307/8x300_Data_Sheet_Sep80.pdf">Datasheet</a></td></tr>
<tr><td>S8X300-2</td><td>Generic &rarr; 8x300</td><td><a href="https://ia601607.us.archive.org/1/items/bitsavers_signetics8ep80_3401307/8x300_Data_Sheet_Sep80.pdf">Datasheet</a></td></tr>
<tr><td>N8X305A</td><td>Generic &rarr; 8x305</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Scans-063/DSA2IH00137808.pdf">Datasheet</a></td></tr>
<tr><td>N8X305I</td><td>Generic &rarr; 8x305</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Scans-063/DSA2IH00137808.pdf">Datasheet</a></td></tr>
<tr><td>N8X305N</td><td>Generic &rarr; 8x305</td><td><a href="http://pdf.datasheetarchive.com/indexerfiles/Scans-063/DSA2IH00137808.pdf">Datasheet</a></td></tr>
</table>
</details>

#### TODO for next version:

* Add support for more 8x300 variants if any are found in the wild.
* Attempt to reject files too big for address-space reduced chip variants.
* Automatic variable extraction for generated `SEL` opcodes.

#### Caveats

* Rebuilding the test binaries requires having the [AS Macroassembler](http://www.alfsembler.de/) command line tools available in your `PATH` variable.
* If MCCAP syntax is used, comments will still start with `;` rather than with `*` as expected.  As far as the author can see, this is something that cannot fixed by the plugin but by the Hopper authors directly.
* The MCCAP syntax does not support negation for constant operands, therefore attempting to mark a constant as negated will not yield anything.  Negation works as intended if using the AS syntax.

<hr/>

### **TMS1000 CPU Plugin**

_version 0.0.1_

This CPU core plugin allows you to disassemble Texas Instruments' TMS1000 series code, used in early embedded equipment and terminals.

This plugin can be referenced from the command line tool using `tms1000` as its identifer.

CPU backends currently supported: TMS1000, TMS1100.

<details>
<summary>Supported CPUs list</summary>
<table>
<thead>
<tr><th>Manufacturer</th><th>Model</th><th>Provider</th><th>Datasheet</th></tr>
</thead>
<tbody>
<tr><td rowspan="6">Texas Instruments</td><td>TMS1000</td><td>Texas Instruments &rarr; TMS1000</td><td><a href="https://en.wikichip.org/w/images/f/ff/TMS1000_Series_Programmer%27s_reference_manual.pdf">Datasheet</td></tr>
<tr><td>TMS1070</td><td>Texas Instruments &rarr; TMS1000</td><td><a href="https://en.wikichip.org/w/images/f/ff/TMS1000_Series_Programmer%27s_reference_manual.pdf">Datasheet</td></tr>
<tr><td>TMS1100</td><td>Texas Instruments &rarr; TMS1100</td><td><a href="https://en.wikichip.org/w/images/f/ff/TMS1000_Series_Programmer%27s_reference_manual.pdf">Datasheet</td></tr>
<tr><td>TMS1200</td><td>Texas Instruments &rarr; TMS1000</td><td><a href="https://en.wikichip.org/w/images/f/ff/TMS1000_Series_Programmer%27s_reference_manual.pdf">Datasheet</td></tr>
<tr><td>TMS1270</td><td>Texas Instruments &rarr; TMS1000</td><td><a href="https://en.wikichip.org/w/images/f/ff/TMS1000_Series_Programmer%27s_reference_manual.pdf">Datasheet</td></tr>
<tr><td>TMS1300</td><td>Texas Instruments &rarr; TMS1100</td><td><a href="https://en.wikichip.org/w/images/f/ff/TMS1000_Series_Programmer%27s_reference_manual.pdf">Datasheet</td></tr>
</table>
</details>

#### TODO for next version:

* Add support for more TMS1000 variants if any are found in the wild.
* Attempt to reject files too big for address-space reduced chip variants.
* Alternate syntax for A1ACC opcodes.

#### Caveats

* Rebuilding the test binaries requires having the [AS Macroassembler](http://www.alfsembler.de/) command line tools available in your `PATH` variable.

<hr/>

### **Apple II File Loader Plugin**

_version 0.0.1_

This file loader plugin allows you to load Apple ][ binaries in A2 format to be disassembled (or basically anything you can either `BLOAD` or `BRUN`). _(Please note that the plugin depends on the 6502 CPU core being installed in order to work properly)_

This plugin can be referenced from the command line tool using `a2` as its identifer.

#### TODO for next version:

* Add support for containers (Disk and Tape images).
* Add extra RAM/ROM sections depending on the chosen machine model.
* Automatically set predefined RAM/ROM labels according to Apple's development manual.

#### Caveats:

* The plugin currently defaults to use a 65c02 disassembler core even on machines that used a plain 6502, this will be fixed once a target machine selector will be implemented in the loader.
* The plugin can not handle BASIC files.

#### Future plans (need Hopper SDK changes):

* Automatically create virtual segments for Apple IIe, IIc, and IIgs bank-switched RAM.

### **Commodore File Loader Plugin**

_version 0.2.2_

This file loader plugin allows you to load Commodore binaries in PRG format to be disassembled.  _(Please note that the plugin depends on the 6502 CPU core being installed in order to work properly)_

This plugin can be referenced from the command line tool using `cbm` as its identifer.

#### TODO for next version:

* Add support for containers (Disk and Tape images).
* Add support for cartridges.

#### Caveats:

* The plugin can also handle BASIC loader stubs if any are present, although the detokeniser for that is quite flaky and barely tested.  Invalid or improper BASIC code **will** crash the plugin, and maybe bring Hopper down with it.

#### Future plans (need Hopper SDK changes):

* Properly relocate files in the 64k address space with BSS sections around data segments.
* Automatically fill labels for audio, video, and zero page locations and automatically create virtual segments for register banking.

<hr/>

### **HEX binary files**

_version 0.0.1_

This file loader plugin allows you to load binaries saved as ASCII HEX files.  Currently the plugin only support the following formats: Intel HEX.

This plugin can be referenced from the command line tool using `hex` as its identifer.

#### TODO for next version:

* Add full support for segments in Intel HEX files.
* Add support for Motorola S-Record files.
* Add support for Tektronix HEX files.
* Add support for MOS HEX files.

#### Caveats:

* The plugin cannot handle overlapping ranges, which can happen when flashing operations require writing memory out of order and hitting locations more than once.

<hr/>

### **Address space tools**

_version 0.0.2_

This tool plugin currently allows to map the full address space of the CPU chosen for the currently loaded file.  When dealing with firmware images and the like, especially on older architectures, the code already assumes a certain memory layout and memory amount.  If a block of code is loaded at a particular address and points to absolute memory locations it is a bit of a pain to handle the situation in Hopper since there is no way (that I know of) to create a segment from the UI.  This plugin solves this very specific situation.

This plugin can be referenced from the command line tool using `addressspace` as its identifer.

#### Caveats:

* Mapping the full address space of a 32 or 64 binary is **not recommended**, as the UI will act as if you have loaded a 4 GB/2 EB file.

<hr/>

## Installation instructions:

Checkout from Git, open `HopperPlugins.xcworkspace` in Xcode/AppCode, select the plugin you are interested in and then let Xcode/AppCode build the associated project; the plugin will be automatically copied to the appropriate paths (`~/Library/Application Support/Hopper/Plugins/v4/{CPUs,Loaders,Tools}`).  Once done, please close any open instances of Hopper and restart them.  That's all there is to it.

Keep in mind that these plugins require **Hopper 4.4.40** or later to work.  They may work on older versions but they are neither tested nor supported on anything older than v4.4.40.

If you are unable or unwilling to update your Hopper installation from v3 to v4 then build the code marked by the `v3api` git tag.  However, since the Hopper author allowed free upgrades from v3 licences to v4 licenses, v3 plugins are effectively unsupported as of v4 release.  It is strongly suggested to update your Hopper installation at your earliest opportunity.

## Need to get in touch?

Send an email to `a.gatti * frob.it` (yep, replace the asterisk, you know what to do), or try sending a message to `agatti@jabber.ccc.de` on Jabber if you so fancy.
