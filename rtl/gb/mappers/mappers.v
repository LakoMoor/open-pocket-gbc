// Tang Nano 20K: rarely used mappers are disabled to save logic (their outputs become
// constant and synthesis removes them). Build with DEFS="-D ALL_MAPPERS" to keep all.
`ifdef ALL_MAPPERS
`define MAPPER_EN(x) x
`else
`define MAPPER_EN(x) 1'b0
`endif

module mappers(
	input         reset,

	input         clk_sys,
	input         ce_cpu,
	input         ce_cpu2x,
	input         speed,

	input         mbc1,
	input         mbc1m,
	input         mbc2,
	input         mbc3,
	input         mbc30,
	input         mbc5,
	input         mbc6,
	input         mbc7,
	input         mmm01,
	input         huc1,
	input         huc3,
	input         gb_camera,
	input         tama,
	input         rocket,
	input         sachen,
	input         wisdom_tree,
	input         mani161,

	input         megaduck,
	input         duck_md0_mode,

	input         isGBC_game,

	input  [15:0] joystick_analog_0,

	input         ce_32k,
	input  [32:0] RTC_time,
	output [31:0] RTC_timestampOut,
	output [47:0] RTC_savedtimeOut,
	output        RTC_inuse,

	input         bk_wr,
	input         bk_rtc_wr,
	input  [16:0] bk_addr,
	input  [15:0] bk_data,
	input  [63:0] img_size,

	input         savestate_load,
	input  [15:0] savestate_data,
	output [15:0] savestate_back,
	input  [63:0] savestate_data2,
	output [63:0] savestate_back2,

	input         has_ram,
	input   [3:0] ram_mask,
	input   [8:0] rom_mask,

	input  [14:0] cart_addr,
	input         cart_a15,

	input   [7:0] cart_mbc_type,

	input         cart_rd,
	input         cart_wr,
	input   [7:0] cart_di,
	output        cart_oe,

	input   [7:0] rom_di,
	output  [7:0] rom_do,

	input         nCS,

	input         cram_rd,
	input   [7:0] cram_di,    // input from Cart RAM q
	output  [7:0] cram_do,    // output to CPU
	output [16:0] cram_addr,

	output  [7:0] cram_wr_do, // For writing to Cart RAM directly without CPU (MBC7 EEPROM)
	output        cram_wr,

	output [22:0] mbc_addr,
	output        ram_enabled,
	output        has_battery,
	output        rumbling

);

// tri-state buses replaced by wired-OR (tools/fix_mappers.py)
wire [7:0] cram_do_b__map_mbc1;
wire [7:0] cram_do_b__map_mbc2;
wire [7:0] cram_do_b__map_mbc3;
wire [7:0] cram_do_b__map_mbc5;
wire [7:0] cram_do_b__map_mbc6;
wire [7:0] cram_do_b__map_mbc7;
wire [7:0] cram_do_b__map_mmm01;
wire [7:0] cram_do_b__map_huc1;
wire [7:0] cram_do_b__map_huc3;
wire [7:0] cram_do_b__map_gb_camera;
wire [7:0] cram_do_b__map_tama;
wire [7:0] cram_do_b__map_rocket;
wire [7:0] cram_do_b__map_sachen;
wire [7:0] cram_do_b__map_megaduck;
wire [7:0] cram_do_b__map_misc;
wire [7:0] cram_do_b = ((mbc1 | no_mapper_multi_bank) | (mbc2) | (mbc3) | (mbc5) | (mbc6) | (mbc7) | (mmm01) | (huc1) | (huc3) | (gb_camera) | (tama) | (rocket) | (sachen) | (megaduck) | (~reset & (wisdom_tree | mani161))) ? (cram_do_b__map_mbc1 | cram_do_b__map_mbc2 | cram_do_b__map_mbc3 | cram_do_b__map_mbc5 | cram_do_b__map_mbc6 | cram_do_b__map_mbc7 | cram_do_b__map_mmm01 | cram_do_b__map_huc1 | cram_do_b__map_huc3 | cram_do_b__map_gb_camera | cram_do_b__map_tama | cram_do_b__map_rocket | cram_do_b__map_sachen | cram_do_b__map_megaduck | cram_do_b__map_misc) : ~0;
wire [7:0] rom_do_b__map_rocket;
wire [7:0] rom_do_b = ((mbc1 | no_mapper_multi_bank) | (mbc2) | (mbc3) | (mbc5) | (mbc6) | (mbc7) | (mmm01) | (huc1) | (huc3) | (gb_camera) | (tama) | (rocket) | (sachen) | (megaduck) | (~reset & (wisdom_tree | mani161))) ? (rom_do_b__map_rocket) : ~0;
wire [22:0] mbc_addr_b__map_mbc1;
wire [22:0] mbc_addr_b__map_mbc2;
wire [22:0] mbc_addr_b__map_mbc3;
wire [22:0] mbc_addr_b__map_mbc5;
wire [22:0] mbc_addr_b__map_mbc6;
wire [22:0] mbc_addr_b__map_mbc7;
wire [22:0] mbc_addr_b__map_mmm01;
wire [22:0] mbc_addr_b__map_huc1;
wire [22:0] mbc_addr_b__map_huc3;
wire [22:0] mbc_addr_b__map_gb_camera;
wire [22:0] mbc_addr_b__map_tama;
wire [22:0] mbc_addr_b__map_rocket;
wire [22:0] mbc_addr_b__map_sachen;
wire [22:0] mbc_addr_b__map_megaduck;
wire [22:0] mbc_addr_b__map_misc;
wire [22:0] mbc_addr_b = mbc_addr_b__map_mbc1 | mbc_addr_b__map_mbc2 | mbc_addr_b__map_mbc3 | mbc_addr_b__map_mbc5 | mbc_addr_b__map_mbc6 | mbc_addr_b__map_mbc7 | mbc_addr_b__map_mmm01 | mbc_addr_b__map_huc1 | mbc_addr_b__map_huc3 | mbc_addr_b__map_gb_camera | mbc_addr_b__map_tama | mbc_addr_b__map_rocket | mbc_addr_b__map_sachen | mbc_addr_b__map_megaduck | mbc_addr_b__map_misc;
wire [16:0] cram_addr_b__map_mbc1;
wire [16:0] cram_addr_b__map_mbc2;
wire [16:0] cram_addr_b__map_mbc3;
wire [16:0] cram_addr_b__map_mbc5;
wire [16:0] cram_addr_b__map_mbc6;
wire [16:0] cram_addr_b__map_mbc7;
wire [16:0] cram_addr_b__map_mmm01;
wire [16:0] cram_addr_b__map_huc1;
wire [16:0] cram_addr_b__map_huc3;
wire [16:0] cram_addr_b__map_gb_camera;
wire [16:0] cram_addr_b__map_tama;
wire [16:0] cram_addr_b__map_rocket;
wire [16:0] cram_addr_b__map_sachen;
wire [16:0] cram_addr_b__map_megaduck;
wire [16:0] cram_addr_b__map_misc;
wire [16:0] cram_addr_b = cram_addr_b__map_mbc1 | cram_addr_b__map_mbc2 | cram_addr_b__map_mbc3 | cram_addr_b__map_mbc5 | cram_addr_b__map_mbc6 | cram_addr_b__map_mbc7 | cram_addr_b__map_mmm01 | cram_addr_b__map_huc1 | cram_addr_b__map_huc3 | cram_addr_b__map_gb_camera | cram_addr_b__map_tama | cram_addr_b__map_rocket | cram_addr_b__map_sachen | cram_addr_b__map_megaduck | cram_addr_b__map_misc;
wire  ram_enabled_b__map_mbc1;
wire  ram_enabled_b__map_mbc2;
wire  ram_enabled_b__map_mbc3;
wire  ram_enabled_b__map_mbc5;
wire  ram_enabled_b__map_mbc6;
wire  ram_enabled_b__map_mbc7;
wire  ram_enabled_b__map_mmm01;
wire  ram_enabled_b__map_huc1;
wire  ram_enabled_b__map_huc3;
wire  ram_enabled_b__map_gb_camera;
wire  ram_enabled_b__map_tama;
wire  ram_enabled_b__map_rocket;
wire  ram_enabled_b__map_sachen;
wire  ram_enabled_b__map_megaduck;
wire  ram_enabled_b__map_misc;
wire  ram_enabled_b = ram_enabled_b__map_mbc1 | ram_enabled_b__map_mbc2 | ram_enabled_b__map_mbc3 | ram_enabled_b__map_mbc5 | ram_enabled_b__map_mbc6 | ram_enabled_b__map_mbc7 | ram_enabled_b__map_mmm01 | ram_enabled_b__map_huc1 | ram_enabled_b__map_huc3 | ram_enabled_b__map_gb_camera | ram_enabled_b__map_tama | ram_enabled_b__map_rocket | ram_enabled_b__map_sachen | ram_enabled_b__map_megaduck | ram_enabled_b__map_misc;
wire  has_battery_b__map_mbc1;
wire  has_battery_b__map_mbc2;
wire  has_battery_b__map_mbc3;
wire  has_battery_b__map_mbc5;
wire  has_battery_b__map_mbc6;
wire  has_battery_b__map_mbc7;
wire  has_battery_b__map_mmm01;
wire  has_battery_b__map_huc1;
wire  has_battery_b__map_huc3;
wire  has_battery_b__map_gb_camera;
wire  has_battery_b__map_tama;
wire  has_battery_b__map_rocket;
wire  has_battery_b__map_sachen;
wire  has_battery_b__map_megaduck;
wire  has_battery_b__map_misc;
wire  has_battery_b = has_battery_b__map_mbc1 | has_battery_b__map_mbc2 | has_battery_b__map_mbc3 | has_battery_b__map_mbc5 | has_battery_b__map_mbc6 | has_battery_b__map_mbc7 | has_battery_b__map_mmm01 | has_battery_b__map_huc1 | has_battery_b__map_huc3 | has_battery_b__map_gb_camera | has_battery_b__map_tama | has_battery_b__map_rocket | has_battery_b__map_sachen | has_battery_b__map_megaduck | has_battery_b__map_misc;
wire [15:0] savestate_back_b__map_mbc1;
wire [15:0] savestate_back_b__map_mbc2;
wire [15:0] savestate_back_b__map_mbc3;
wire [15:0] savestate_back_b__map_mbc5;
wire [15:0] savestate_back_b__map_mbc7;
wire [15:0] savestate_back_b__map_huc1;
wire [15:0] savestate_back_b__map_gb_camera;
wire [15:0] savestate_back_b__map_rocket;
wire [15:0] savestate_back_b__map_megaduck;
wire [15:0] savestate_back_b__map_misc;
wire [15:0] savestate_back_b = savestate_back_b__map_mbc1 | savestate_back_b__map_mbc2 | savestate_back_b__map_mbc3 | savestate_back_b__map_mbc5 | savestate_back_b__map_mbc7 | savestate_back_b__map_huc1 | savestate_back_b__map_gb_camera | savestate_back_b__map_rocket | savestate_back_b__map_megaduck | savestate_back_b__map_misc;
wire [63:0] savestate_back2_b__map_mbc6;
wire [63:0] savestate_back2_b__map_mbc7;
wire [63:0] savestate_back2_b__map_mmm01;
wire [63:0] savestate_back2_b__map_huc3;
wire [63:0] savestate_back2_b__map_tama;
wire [63:0] savestate_back2_b__map_sachen;
wire [63:0] savestate_back2_b = savestate_back2_b__map_mbc6 | savestate_back2_b__map_mbc7 | savestate_back2_b__map_mmm01 | savestate_back2_b__map_huc3 | savestate_back2_b__map_tama | savestate_back2_b__map_sachen;
wire [7:0] cram_wr_do_b__map_mbc7;
wire [7:0] cram_wr_do_b__map_tama;
wire [7:0] cram_wr_do_b = cram_wr_do_b__map_mbc7 | cram_wr_do_b__map_tama;
wire  cram_wr_b__map_mbc7;
wire  cram_wr_b__map_tama;
wire  cram_wr_b = cram_wr_b__map_mbc7 | cram_wr_b__map_tama;
wire  cart_oe_b__map_mbc3;
wire  cart_oe_b__map_mbc7;
wire  cart_oe_b__map_huc1;
wire  cart_oe_b__map_huc3;
wire  cart_oe_b__map_gb_camera;
wire  cart_oe_b__map_tama;
wire  cart_oe_b = cart_oe_b__map_mbc3 | cart_oe_b__map_mbc7 | cart_oe_b__map_huc1 | cart_oe_b__map_huc3 | cart_oe_b__map_gb_camera | cart_oe_b__map_tama;
wire [31:0] RTC_timestampOut_b__map_mbc3;
wire [31:0] RTC_timestampOut_b__map_huc3;
wire [31:0] RTC_timestampOut_b = RTC_timestampOut_b__map_mbc3 | RTC_timestampOut_b__map_huc3;
wire [47:0] RTC_savedtimeOut_b__map_mbc3;
wire [47:0] RTC_savedtimeOut_b__map_huc3;
wire [47:0] RTC_savedtimeOut_b = RTC_savedtimeOut_b__map_mbc3 | RTC_savedtimeOut_b__map_huc3;
wire  RTC_inuse_b__map_mbc3;
wire  RTC_inuse_b__map_huc3;
wire  RTC_inuse_b = RTC_inuse_b__map_mbc3 | RTC_inuse_b__map_huc3;














wire ce = speed ? ce_cpu2x : ce_cpu;
wire no_mapper = ~(mbc1 | mbc2 | mbc3 | mbc5 | mbc6 | mbc7 | mmm01 | huc1 | huc3 | gb_camera | tama | rocket | sachen | wisdom_tree | mani161 | megaduck);
wire no_mapper_single_bank = no_mapper & ~rom_mask[1];
wire no_mapper_multi_bank  = no_mapper &  rom_mask[1]; // size > 32KB
wire rom_override = (rocket);
wire cart_oe_override = (mbc3 | mbc7 | huc1 | huc3 | gb_camera | tama);

mbc1 map_mbc1 (
	.enable           ( mbc1 | no_mapper_multi_bank ),
	.mbc1m            ( mbc1m ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data ),
	.savestate_back_b ( savestate_back_b__map_mbc1 ),

	.has_ram          ( has_ram  ),
	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_mbc1 ),
	.cram_addr_b      ( cram_addr_b__map_mbc1 ),

	.mbc_addr_b       ( mbc_addr_b__map_mbc1 ),
	.ram_enabled_b    ( ram_enabled_b__map_mbc1 ),
	.has_battery_b    ( has_battery_b__map_mbc1 )
);

mbc2 map_mbc2 (
	.enable           ( mbc2 ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data ),
	.savestate_back_b ( savestate_back_b__map_mbc2 ),

	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_mbc2 ),
	.cram_addr_b      ( cram_addr_b__map_mbc2 ),

	.mbc_addr_b       ( mbc_addr_b__map_mbc2 ),
	.ram_enabled_b    ( ram_enabled_b__map_mbc2 ),
	.has_battery_b    ( has_battery_b__map_mbc2 )
);

mbc3 map_mbc3 (
	.enable            ( mbc3 ),
	.reset             ( reset ),
	.mbc30             ( mbc30 ),

	.clk_sys           ( clk_sys ),
	.ce_cpu            ( ce ),

	.savestate_load    ( savestate_load ),
	.savestate_data    ( savestate_data ),
	.savestate_back_b  ( savestate_back_b__map_mbc3 ),

	.ce_32k            ( ce_32k            ),
	.RTC_time          ( RTC_time         ),
	.RTC_timestampOut_b( RTC_timestampOut_b__map_mbc3 ),
	.RTC_savedtimeOut_b( RTC_savedtimeOut_b__map_mbc3 ),
	.RTC_inuse_b       ( RTC_inuse_b__map_mbc3 ),

	.bk_wr             ( bk_wr     ),
	.bk_rtc_wr         ( bk_rtc_wr ),
	.bk_addr           ( bk_addr   ),
	.bk_data           ( bk_data   ),
	.img_size          ( img_size  ),

	.has_ram           ( has_ram  ),
	.ram_mask          ( ram_mask ),
	.rom_mask          ( rom_mask ),

	.cart_addr         ( cart_addr     ),
	.cart_a15          ( cart_a15      ),

	.cart_mbc_type     ( cart_mbc_type ),

	.cart_rd           ( cart_rd ),
	.cart_wr           ( cart_wr ),
	.cart_di           ( cart_di ),
	.cart_oe_b         ( cart_oe_b__map_mbc3 ),

	.nCS               ( nCS      ),

	.cram_di           ( cram_di     ),
	.cram_do_b         ( cram_do_b__map_mbc3 ),
	.cram_addr_b       ( cram_addr_b__map_mbc3 ),

	.mbc_addr_b        ( mbc_addr_b__map_mbc3 ),
	.ram_enabled_b     ( ram_enabled_b__map_mbc3 ),
	.has_battery_b     ( has_battery_b__map_mbc3 )
);

mbc5 map_mbc5 (
	.enable           ( mbc5 ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data ),
	.savestate_back_b ( savestate_back_b__map_mbc5 ),

	.has_ram          ( has_ram  ),
	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),
	.cart_mbc_type    ( cart_mbc_type ),

	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_mbc5 ),
	.cram_addr_b      ( cram_addr_b__map_mbc5 ),

	.mbc_addr_b       ( mbc_addr_b__map_mbc5 ),
	.ram_enabled_b    ( ram_enabled_b__map_mbc5 ),
	.has_battery_b    ( has_battery_b__map_mbc5 ),
	.rumbling         ( rumbling )
);

mbc6 map_mbc6 (
	.enable           ( `MAPPER_EN(mbc6) ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data2 ),
	.savestate_back_b ( savestate_back2_b__map_mbc6 ),

	.has_ram          ( has_ram  ),
	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_mbc6 ),
	.cram_addr_b      ( cram_addr_b__map_mbc6 ),

	.mbc_addr_b       ( mbc_addr_b__map_mbc6 ),
	.ram_enabled_b    ( ram_enabled_b__map_mbc6 ),
	.has_battery_b    ( has_battery_b__map_mbc6 )
);

mbc7 map_mbc7 (
	.enable           ( `MAPPER_EN(mbc7) ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),
	.ce_1x            ( ce_cpu ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data ),
	.savestate_back_b ( savestate_back_b__map_mbc7 ),
	.savestate_data2  ( savestate_data2 ),
	.savestate_back2_b( savestate_back2_b__map_mbc7 ),

	.joystick_analog_x  ( joystick_analog_0[7:0] ),
	.joystick_analog_y  ( joystick_analog_0[15:8] ),

	.has_ram          ( has_ram  ),
	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_rd          ( cart_rd ),
	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),
	.cart_oe_b        ( cart_oe_b__map_mbc7 ),

	.nCS              ( nCS      ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_mbc7 ),
	.cram_addr_b      ( cram_addr_b__map_mbc7 ),

	.cram_wr_do_b     ( cram_wr_do_b__map_mbc7 ),
	.cram_wr_b        ( cram_wr_b__map_mbc7 ),

	.mbc_addr_b       ( mbc_addr_b__map_mbc7 ),
	.ram_enabled_b    ( ram_enabled_b__map_mbc7 ),
	.has_battery_b    ( has_battery_b__map_mbc7 )
);

mmm01 map_mmm01 (
	.enable           ( `MAPPER_EN(mmm01) ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data2 ),
	.savestate_back_b ( savestate_back2_b__map_mmm01 ),

	.has_ram          ( has_ram  ),
	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_mmm01 ),
	.cram_addr_b      ( cram_addr_b__map_mmm01 ),

	.mbc_addr_b       ( mbc_addr_b__map_mmm01 ),
	.ram_enabled_b    ( ram_enabled_b__map_mmm01 ),
	.has_battery_b    ( has_battery_b__map_mmm01 )
);

huc1 map_huc1 (
	.enable           ( huc1 ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data ),
	.savestate_back_b ( savestate_back_b__map_huc1 ),

	.has_ram          ( has_ram  ),
	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_rd          ( cart_rd ),
	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),
	.cart_oe_b        ( cart_oe_b__map_huc1 ),

	.cram_rd          ( cram_rd ),
	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_huc1 ),
	.cram_addr_b      ( cram_addr_b__map_huc1 ),

	.mbc_addr_b       ( mbc_addr_b__map_huc1 ),
	.ram_enabled_b    ( ram_enabled_b__map_huc1 ),
	.has_battery_b    ( has_battery_b__map_huc1 )
);

huc3 map_huc3 (
	.enable            ( huc3 ),

	.clk_sys           ( clk_sys ),
	.ce_cpu            ( ce ),

	.savestate_load    ( savestate_load ),
	.savestate_data    ( savestate_data2 ),
	.savestate_back_b  ( savestate_back2_b__map_huc3 ),

	.ce_32k            ( ce_32k           ),
	.RTC_time          ( RTC_time         ),
	.RTC_timestampOut_b( RTC_timestampOut_b__map_huc3 ),
	.RTC_savedtimeOut_b( RTC_savedtimeOut_b__map_huc3 ),
	.RTC_inuse_b       ( RTC_inuse_b__map_huc3 ),

	.bk_rtc_wr         ( bk_rtc_wr ),
	.bk_addr           ( bk_addr   ),
	.bk_data           ( bk_data   ),

	.has_ram           ( has_ram  ),
	.ram_mask          ( ram_mask ),
	.rom_mask          ( rom_mask ),

	.cart_addr         ( cart_addr ),
	.cart_a15          ( cart_a15 ),

	.cart_mbc_type     ( cart_mbc_type ),

	.cart_rd           ( cart_rd ),
	.cart_wr           ( cart_wr ),
	.cart_di           ( cart_di ),
	.cart_oe_b         ( cart_oe_b__map_huc3 ),

	.nCS               ( nCS      ),

	.cram_di           ( cram_di ),
	.cram_do_b         ( cram_do_b__map_huc3 ),
	.cram_addr_b       ( cram_addr_b__map_huc3 ),

	.mbc_addr_b        ( mbc_addr_b__map_huc3 ),
	.ram_enabled_b     ( ram_enabled_b__map_huc3 ),
	.has_battery_b     ( has_battery_b__map_huc3 )
);


gb_camera map_gb_camera (
	.enable           ( `MAPPER_EN(gb_camera) ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data ),
	.savestate_back_b ( savestate_back_b__map_gb_camera ),

	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_rd          ( cart_rd ),
	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),
	.cart_oe_b        ( cart_oe_b__map_gb_camera ),

	.cram_rd          ( cram_rd ),
	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_gb_camera ),
	.cram_addr_b      ( cram_addr_b__map_gb_camera ),

	.mbc_addr_b       ( mbc_addr_b__map_gb_camera ),
	.ram_enabled_b    ( ram_enabled_b__map_gb_camera ),
	.has_battery_b    ( has_battery_b__map_gb_camera )
);

// TODO: TAMA RTC
tama map_tama (
	.enable           ( `MAPPER_EN(tama) ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),
	.ce_32k           ( ce_32k   ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data2 ),
	.savestate_back_b ( savestate_back2_b__map_tama ),

	.has_ram          ( has_ram  ),
	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_rd          ( cart_rd ),
	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),
	.cart_oe_b        ( cart_oe_b__map_tama ),

	.nCS              ( nCS      ),

	.cram_rd          ( cram_rd ),
	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_tama ),
	.cram_addr_b      ( cram_addr_b__map_tama ),

	.cram_wr_do_b     ( cram_wr_do_b__map_tama ),
	.cram_wr_b        ( cram_wr_b__map_tama ),

	.mbc_addr_b       ( mbc_addr_b__map_tama ),
	.ram_enabled_b    ( ram_enabled_b__map_tama ),
	.has_battery_b    ( has_battery_b__map_tama )
);

rocket map_rocket (
	.enable           ( `MAPPER_EN(rocket) ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data ),
	.savestate_back_b ( savestate_back_b__map_rocket ),

	.has_ram          ( has_ram  ),
	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),

	.rom_di           ( rom_di ),
	.rom_do_b         ( rom_do_b__map_rocket ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_rocket ),
	.cram_addr_b      ( cram_addr_b__map_rocket ),

	.mbc_addr_b       ( mbc_addr_b__map_rocket ),
	.ram_enabled_b    ( ram_enabled_b__map_rocket ),
	.has_battery_b    ( has_battery_b__map_rocket )
);

sachen map_sachen (
	.enable           ( `MAPPER_EN(sachen) ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.isGBC_game       ( isGBC_game ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data2 ),
	.savestate_back_b ( savestate_back2_b__map_sachen ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),

	.nCS              ( nCS      ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_sachen ),
	.cram_addr_b      ( cram_addr_b__map_sachen ),

	.mbc_addr_b       ( mbc_addr_b__map_sachen ),
	.ram_enabled_b    ( ram_enabled_b__map_sachen ),
	.has_battery_b    ( has_battery_b__map_sachen )
);

megaduck map_megaduck (
	.enable           ( `MAPPER_EN(megaduck) ),
	.duck_md0_mode    ( duck_md0_mode ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data ),
	.savestate_back_b ( savestate_back_b__map_megaduck ),

	.has_ram          ( has_ram  ),
	.ram_mask         ( ram_mask ),
	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_mbc_type    ( cart_mbc_type ),

	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_megaduck ),
	.cram_addr_b      ( cram_addr_b__map_megaduck ),

	.mbc_addr_b       ( mbc_addr_b__map_megaduck ),
	.ram_enabled_b    ( ram_enabled_b__map_megaduck ),
	.has_battery_b    ( has_battery_b__map_megaduck )
);

// Mani 4-in-1 DMG 601 & Wisdom Tree 32KB bank mappers
misc_mapper map_misc (
	.enable           ( ~reset & (wisdom_tree | mani161) ),

	.clk_sys          ( clk_sys ),
	.ce_cpu           ( ce ),

	.mapper_sel       ( mani161 ),

	.savestate_load   ( savestate_load ),
	.savestate_data   ( savestate_data ),
	.savestate_back_b ( savestate_back_b__map_misc ),

	.rom_mask         ( rom_mask ),

	.cart_addr        ( cart_addr ),
	.cart_a15         ( cart_a15 ),

	.cart_wr          ( cart_wr ),
	.cart_di          ( cart_di ),

	.cram_di          ( cram_di ),
	.cram_do_b        ( cram_do_b__map_misc ),
	.cram_addr_b      ( cram_addr_b__map_misc ),

	.mbc_addr_b       ( mbc_addr_b__map_misc ),
	.ram_enabled_b    ( ram_enabled_b__map_misc ),
	.has_battery_b    ( has_battery_b__map_misc )
);

assign { cram_do } = { cram_do_b };
assign { savestate_back, savestate_back2 } = { savestate_back_b, savestate_back2_b };
assign { RTC_timestampOut, RTC_savedtimeOut, RTC_inuse } = { RTC_timestampOut_b, RTC_savedtimeOut_b, RTC_inuse_b };
assign { cram_wr_do, cram_wr } = { cram_wr_do_b, cram_wr_b };

assign mbc_addr = no_mapper_single_bank ? {8'd0, cart_addr[14:0]} : mbc_addr_b;
assign cram_addr = no_mapper_single_bank ? {4'd0, cart_addr[12:0]} : cram_addr_b;
assign has_battery = no_mapper_single_bank ? (cart_mbc_type == 8'h09) : has_battery_b;
assign ram_enabled = no_mapper_single_bank ? has_ram : ram_enabled_b;
assign rom_do = rom_override ? rom_do_b : rom_di;
assign cart_oe = cart_oe_override ? cart_oe_b : ((cart_rd & ~cart_a15) | (cram_rd & ram_enabled));

endmodule