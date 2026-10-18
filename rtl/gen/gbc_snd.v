module ereg_savestatev_Barch_0_34_63_0_0d12c86699a623151760f96a58ab62407ca52986
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [63:0] din,
   output [63:0] dout);
  reg [63:0] dout_buffer;
  wire [9:0] adri;
  wire n4326;
  wire n4327;
  wire n4328;
  wire n4329;
  wire n4330;
  wire n4331;
  wire n4332;
  wire n4333;
  wire n4334;
  wire n4335;
  wire n4336;
  wire n4337;
  wire n4338;
  wire n4339;
  wire n4340;
  wire n4341;
  wire n4342;
  wire n4343;
  wire n4344;
  wire n4345;
  wire n4346;
  wire n4347;
  wire n4348;
  wire n4349;
  wire n4350;
  wire n4351;
  wire n4352;
  wire n4353;
  wire n4354;
  wire n4355;
  wire n4356;
  wire n4357;
  wire n4358;
  wire n4359;
  wire n4360;
  wire n4361;
  wire n4362;
  wire n4363;
  wire n4364;
  wire n4365;
  wire n4366;
  wire n4367;
  wire n4368;
  wire n4369;
  wire n4370;
  wire n4371;
  wire n4372;
  wire n4373;
  wire n4374;
  wire n4375;
  wire n4376;
  wire n4377;
  wire n4378;
  wire n4379;
  wire n4380;
  wire n4381;
  wire n4382;
  wire n4383;
  wire n4384;
  wire n4385;
  wire n4386;
  wire n4387;
  wire n4388;
  wire n4389;
  wire n4390;
  wire n4391;
  wire [63:0] n4392;
  wire [63:0] n4393;
  wire [63:0] n4395;
  wire n4398;
  wire n4399;
  wire n4400;
  wire n4402;
  wire n4403;
  wire n4404;
  wire n4406;
  wire n4407;
  wire n4408;
  wire n4410;
  wire n4411;
  wire n4412;
  wire n4414;
  wire n4415;
  wire n4416;
  wire n4418;
  wire n4419;
  wire n4420;
  wire n4422;
  wire n4423;
  wire n4424;
  wire n4426;
  wire n4427;
  wire n4428;
  wire n4430;
  wire n4431;
  wire n4432;
  wire n4434;
  wire n4435;
  wire n4436;
  wire n4438;
  wire n4439;
  wire n4440;
  wire n4442;
  wire n4443;
  wire n4444;
  wire n4446;
  wire n4447;
  wire n4448;
  wire n4450;
  wire n4451;
  wire n4452;
  wire n4454;
  wire n4455;
  wire n4456;
  wire n4458;
  wire n4459;
  wire n4460;
  wire n4462;
  wire n4463;
  wire n4464;
  wire n4466;
  wire n4467;
  wire n4468;
  wire n4470;
  wire n4471;
  wire n4472;
  wire n4474;
  wire n4475;
  wire n4476;
  wire n4478;
  wire n4479;
  wire n4480;
  wire n4482;
  wire n4483;
  wire n4484;
  wire n4486;
  wire n4487;
  wire n4488;
  wire n4490;
  wire n4491;
  wire n4492;
  wire n4494;
  wire n4495;
  wire n4496;
  wire n4498;
  wire n4499;
  wire n4500;
  wire n4502;
  wire n4503;
  wire n4504;
  wire n4506;
  wire n4507;
  wire n4508;
  wire n4510;
  wire n4511;
  wire n4512;
  wire n4514;
  wire n4515;
  wire n4516;
  wire n4518;
  wire n4519;
  wire n4520;
  wire n4522;
  wire n4523;
  wire n4524;
  wire n4526;
  wire n4527;
  wire n4528;
  wire n4530;
  wire n4531;
  wire n4532;
  wire n4534;
  wire n4535;
  wire n4536;
  wire n4538;
  wire n4539;
  wire n4540;
  wire n4542;
  wire n4543;
  wire n4544;
  wire n4546;
  wire n4547;
  wire n4548;
  wire n4550;
  wire n4551;
  wire n4552;
  wire n4554;
  wire n4555;
  wire n4556;
  wire n4558;
  wire n4559;
  wire n4560;
  wire n4562;
  wire n4563;
  wire n4564;
  wire n4566;
  wire n4567;
  wire n4568;
  wire n4570;
  wire n4571;
  wire n4572;
  wire n4574;
  wire n4575;
  wire n4576;
  wire n4578;
  wire n4579;
  wire n4580;
  wire n4582;
  wire n4583;
  wire n4584;
  wire n4586;
  wire n4587;
  wire n4588;
  wire n4590;
  wire n4591;
  wire n4592;
  wire n4594;
  wire n4595;
  wire n4596;
  wire n4598;
  wire n4599;
  wire n4600;
  wire n4602;
  wire n4603;
  wire n4604;
  wire n4606;
  wire n4607;
  wire n4608;
  wire n4610;
  wire n4611;
  wire n4612;
  wire n4614;
  wire n4615;
  wire n4616;
  wire n4618;
  wire n4619;
  wire n4620;
  wire n4622;
  wire n4623;
  wire n4624;
  wire n4626;
  wire n4627;
  wire n4628;
  wire n4630;
  wire n4631;
  wire n4632;
  wire n4634;
  wire n4635;
  wire n4636;
  wire n4638;
  wire n4639;
  wire n4640;
  wire n4642;
  wire n4643;
  wire n4644;
  wire n4646;
  wire n4647;
  wire n4648;
  wire n4650;
  wire n4651;
  wire n4652;
  wire [63:0] n4654;
  reg [63:0] n4655;
  assign bus_dout = n4654; //(module output)
  assign dout = dout_buffer; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:59:11 */
  always @*
    dout_buffer = n4655; // (isignal)
  initial
    dout_buffer = 64'b1010110111100010100010110100001100001011100101011001010100000110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:61:11 */
  assign adri = 10'b0000100010; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:25 */
  assign n4326 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:32 */
  assign n4327 = bus_wren & n4326;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4328 = bus_din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4329 = bus_din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4330 = bus_din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4331 = bus_din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4332 = bus_din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4333 = bus_din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4334 = bus_din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4335 = bus_din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4336 = bus_din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4337 = bus_din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4338 = bus_din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4339 = bus_din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4340 = bus_din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4341 = bus_din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4342 = bus_din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4343 = bus_din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4344 = bus_din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4345 = bus_din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4346 = bus_din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4347 = bus_din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4348 = bus_din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4349 = bus_din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4350 = bus_din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4351 = bus_din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4352 = bus_din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4353 = bus_din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4354 = bus_din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4355 = bus_din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4356 = bus_din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4357 = bus_din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4358 = bus_din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4359 = bus_din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4360 = bus_din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4361 = bus_din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4362 = bus_din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4363 = bus_din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4364 = bus_din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4365 = bus_din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4366 = bus_din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4367 = bus_din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4368 = bus_din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4369 = bus_din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4370 = bus_din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4371 = bus_din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4372 = bus_din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4373 = bus_din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4374 = bus_din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4375 = bus_din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4376 = bus_din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4377 = bus_din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4378 = bus_din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4379 = bus_din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4380 = bus_din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4381 = bus_din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4382 = bus_din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4383 = bus_din[55]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4384 = bus_din[56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4385 = bus_din[57]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4386 = bus_din[58]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4387 = bus_din[59]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4388 = bus_din[60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4389 = bus_din[61]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4390 = bus_din[62]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4391 = bus_din[63]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n4392 = {n4391, n4390, n4389, n4388, n4387, n4386, n4385, n4384, n4383, n4382, n4381, n4380, n4379, n4378, n4377, n4376, n4375, n4374, n4373, n4372, n4371, n4370, n4369, n4368, n4367, n4366, n4365, n4364, n4363, n4362, n4361, n4360, n4359, n4358, n4357, n4356, n4355, n4354, n4353, n4352, n4351, n4350, n4349, n4348, n4347, n4346, n4345, n4344, n4343, n4342, n4341, n4340, n4339, n4338, n4337, n4336, n4335, n4334, n4333, n4332, n4331, n4330, n4329, n4328};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n4393 = n4327 ? n4392 : dout_buffer;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:71:10 */
  assign n4395 = bus_rst ? 64'b1010110111100010100010110100001100001011100101011001010100000110 : n4393;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4398 = din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4399 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4400 = n4399 ? n4398 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4402 = din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4403 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4404 = n4403 ? n4402 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4406 = din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4407 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4408 = n4407 ? n4406 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4410 = din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4411 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4412 = n4411 ? n4410 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4414 = din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4415 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4416 = n4415 ? n4414 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4418 = din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4419 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4420 = n4419 ? n4418 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4422 = din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4423 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4424 = n4423 ? n4422 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4426 = din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4427 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4428 = n4427 ? n4426 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4430 = din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4431 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4432 = n4431 ? n4430 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4434 = din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4435 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4436 = n4435 ? n4434 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4438 = din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4439 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4440 = n4439 ? n4438 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4442 = din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4443 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4444 = n4443 ? n4442 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4446 = din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4447 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4448 = n4447 ? n4446 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4450 = din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4451 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4452 = n4451 ? n4450 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4454 = din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4455 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4456 = n4455 ? n4454 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4458 = din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4459 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4460 = n4459 ? n4458 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4462 = din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4463 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4464 = n4463 ? n4462 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4466 = din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4467 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4468 = n4467 ? n4466 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4470 = din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4471 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4472 = n4471 ? n4470 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4474 = din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4475 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4476 = n4475 ? n4474 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4478 = din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4479 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4480 = n4479 ? n4478 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4482 = din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4483 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4484 = n4483 ? n4482 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4486 = din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4487 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4488 = n4487 ? n4486 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4490 = din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4491 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4492 = n4491 ? n4490 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4494 = din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4495 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4496 = n4495 ? n4494 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4498 = din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4499 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4500 = n4499 ? n4498 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4502 = din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4503 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4504 = n4503 ? n4502 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4506 = din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4507 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4508 = n4507 ? n4506 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4510 = din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4511 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4512 = n4511 ? n4510 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4514 = din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4515 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4516 = n4515 ? n4514 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4518 = din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4519 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4520 = n4519 ? n4518 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4522 = din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4523 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4524 = n4523 ? n4522 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4526 = din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4527 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4528 = n4527 ? n4526 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4530 = din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4531 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4532 = n4531 ? n4530 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4534 = din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4535 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4536 = n4535 ? n4534 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4538 = din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4539 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4540 = n4539 ? n4538 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4542 = din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4543 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4544 = n4543 ? n4542 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4546 = din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4547 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4548 = n4547 ? n4546 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4550 = din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4551 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4552 = n4551 ? n4550 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4554 = din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4555 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4556 = n4555 ? n4554 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4558 = din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4559 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4560 = n4559 ? n4558 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4562 = din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4563 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4564 = n4563 ? n4562 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4566 = din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4567 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4568 = n4567 ? n4566 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4570 = din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4571 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4572 = n4571 ? n4570 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4574 = din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4575 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4576 = n4575 ? n4574 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4578 = din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4579 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4580 = n4579 ? n4578 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4582 = din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4583 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4584 = n4583 ? n4582 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4586 = din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4587 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4588 = n4587 ? n4586 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4590 = din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4591 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4592 = n4591 ? n4590 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4594 = din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4595 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4596 = n4595 ? n4594 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4598 = din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4599 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4600 = n4599 ? n4598 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4602 = din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4603 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4604 = n4603 ? n4602 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4606 = din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4607 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4608 = n4607 ? n4606 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4610 = din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4611 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4612 = n4611 ? n4610 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4614 = din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4615 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4616 = n4615 ? n4614 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4618 = din[55]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4619 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4620 = n4619 ? n4618 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4622 = din[56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4623 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4624 = n4623 ? n4622 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4626 = din[57]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4627 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4628 = n4627 ? n4626 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4630 = din[58]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4631 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4632 = n4631 ? n4630 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4634 = din[59]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4635 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4636 = n4635 ? n4634 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4638 = din[60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4639 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4640 = n4639 ? n4638 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4642 = din[61]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4643 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4644 = n4643 ? n4642 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4646 = din[62]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4647 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4648 = n4647 ? n4646 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4650 = din[63]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4651 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4652 = n4651 ? n4650 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:51:7 */
  assign n4654 = {n4652, n4648, n4644, n4640, n4636, n4632, n4628, n4624, n4620, n4616, n4612, n4608, n4604, n4600, n4596, n4592, n4588, n4584, n4580, n4576, n4572, n4568, n4564, n4560, n4556, n4552, n4548, n4544, n4540, n4536, n4532, n4528, n4524, n4520, n4516, n4512, n4508, n4504, n4500, n4496, n4492, n4488, n4484, n4480, n4476, n4472, n4468, n4464, n4460, n4456, n4452, n4448, n4444, n4440, n4436, n4432, n4428, n4424, n4420, n4416, n4412, n4408, n4404, n4400};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:69:7 */
  always @(posedge clk)
    n4655 <= n4395;
  initial
    n4655 = 64'b1010110111100010100010110100001100001011100101011001010100000110;
endmodule

module ereg_savestatev_Barch_0_33_63_0_858f4169ab81acdb5e41a52b3572d5380f34b951
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [63:0] din,
   output [63:0] dout);
  reg [63:0] dout_buffer;
  wire [9:0] adri;
  wire n3988;
  wire n3989;
  wire n3990;
  wire n3991;
  wire n3992;
  wire n3993;
  wire n3994;
  wire n3995;
  wire n3996;
  wire n3997;
  wire n3998;
  wire n3999;
  wire n4000;
  wire n4001;
  wire n4002;
  wire n4003;
  wire n4004;
  wire n4005;
  wire n4006;
  wire n4007;
  wire n4008;
  wire n4009;
  wire n4010;
  wire n4011;
  wire n4012;
  wire n4013;
  wire n4014;
  wire n4015;
  wire n4016;
  wire n4017;
  wire n4018;
  wire n4019;
  wire n4020;
  wire n4021;
  wire n4022;
  wire n4023;
  wire n4024;
  wire n4025;
  wire n4026;
  wire n4027;
  wire n4028;
  wire n4029;
  wire n4030;
  wire n4031;
  wire n4032;
  wire n4033;
  wire n4034;
  wire n4035;
  wire n4036;
  wire n4037;
  wire n4038;
  wire n4039;
  wire n4040;
  wire n4041;
  wire n4042;
  wire n4043;
  wire n4044;
  wire n4045;
  wire n4046;
  wire n4047;
  wire n4048;
  wire n4049;
  wire n4050;
  wire n4051;
  wire n4052;
  wire n4053;
  wire [63:0] n4054;
  wire [63:0] n4055;
  wire [63:0] n4057;
  wire n4060;
  wire n4061;
  wire n4062;
  wire n4064;
  wire n4065;
  wire n4066;
  wire n4068;
  wire n4069;
  wire n4070;
  wire n4072;
  wire n4073;
  wire n4074;
  wire n4076;
  wire n4077;
  wire n4078;
  wire n4080;
  wire n4081;
  wire n4082;
  wire n4084;
  wire n4085;
  wire n4086;
  wire n4088;
  wire n4089;
  wire n4090;
  wire n4092;
  wire n4093;
  wire n4094;
  wire n4096;
  wire n4097;
  wire n4098;
  wire n4100;
  wire n4101;
  wire n4102;
  wire n4104;
  wire n4105;
  wire n4106;
  wire n4108;
  wire n4109;
  wire n4110;
  wire n4112;
  wire n4113;
  wire n4114;
  wire n4116;
  wire n4117;
  wire n4118;
  wire n4120;
  wire n4121;
  wire n4122;
  wire n4124;
  wire n4125;
  wire n4126;
  wire n4128;
  wire n4129;
  wire n4130;
  wire n4132;
  wire n4133;
  wire n4134;
  wire n4136;
  wire n4137;
  wire n4138;
  wire n4140;
  wire n4141;
  wire n4142;
  wire n4144;
  wire n4145;
  wire n4146;
  wire n4148;
  wire n4149;
  wire n4150;
  wire n4152;
  wire n4153;
  wire n4154;
  wire n4156;
  wire n4157;
  wire n4158;
  wire n4160;
  wire n4161;
  wire n4162;
  wire n4164;
  wire n4165;
  wire n4166;
  wire n4168;
  wire n4169;
  wire n4170;
  wire n4172;
  wire n4173;
  wire n4174;
  wire n4176;
  wire n4177;
  wire n4178;
  wire n4180;
  wire n4181;
  wire n4182;
  wire n4184;
  wire n4185;
  wire n4186;
  wire n4188;
  wire n4189;
  wire n4190;
  wire n4192;
  wire n4193;
  wire n4194;
  wire n4196;
  wire n4197;
  wire n4198;
  wire n4200;
  wire n4201;
  wire n4202;
  wire n4204;
  wire n4205;
  wire n4206;
  wire n4208;
  wire n4209;
  wire n4210;
  wire n4212;
  wire n4213;
  wire n4214;
  wire n4216;
  wire n4217;
  wire n4218;
  wire n4220;
  wire n4221;
  wire n4222;
  wire n4224;
  wire n4225;
  wire n4226;
  wire n4228;
  wire n4229;
  wire n4230;
  wire n4232;
  wire n4233;
  wire n4234;
  wire n4236;
  wire n4237;
  wire n4238;
  wire n4240;
  wire n4241;
  wire n4242;
  wire n4244;
  wire n4245;
  wire n4246;
  wire n4248;
  wire n4249;
  wire n4250;
  wire n4252;
  wire n4253;
  wire n4254;
  wire n4256;
  wire n4257;
  wire n4258;
  wire n4260;
  wire n4261;
  wire n4262;
  wire n4264;
  wire n4265;
  wire n4266;
  wire n4268;
  wire n4269;
  wire n4270;
  wire n4272;
  wire n4273;
  wire n4274;
  wire n4276;
  wire n4277;
  wire n4278;
  wire n4280;
  wire n4281;
  wire n4282;
  wire n4284;
  wire n4285;
  wire n4286;
  wire n4288;
  wire n4289;
  wire n4290;
  wire n4292;
  wire n4293;
  wire n4294;
  wire n4296;
  wire n4297;
  wire n4298;
  wire n4300;
  wire n4301;
  wire n4302;
  wire n4304;
  wire n4305;
  wire n4306;
  wire n4308;
  wire n4309;
  wire n4310;
  wire n4312;
  wire n4313;
  wire n4314;
  wire [63:0] n4316;
  reg [63:0] n4317;
  assign bus_dout = n4316; //(module output)
  assign dout = dout_buffer; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:59:11 */
  always @*
    dout_buffer = n4317; // (isignal)
  initial
    dout_buffer = 64'b1100001100101001100001111101001010101010001101000000010001001000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:61:11 */
  assign adri = 10'b0000100001; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:25 */
  assign n3988 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:32 */
  assign n3989 = bus_wren & n3988;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3990 = bus_din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3991 = bus_din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3992 = bus_din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3993 = bus_din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3994 = bus_din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3995 = bus_din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3996 = bus_din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3997 = bus_din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3998 = bus_din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3999 = bus_din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4000 = bus_din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4001 = bus_din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4002 = bus_din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4003 = bus_din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4004 = bus_din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4005 = bus_din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4006 = bus_din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4007 = bus_din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4008 = bus_din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4009 = bus_din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4010 = bus_din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4011 = bus_din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4012 = bus_din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4013 = bus_din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4014 = bus_din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4015 = bus_din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4016 = bus_din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4017 = bus_din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4018 = bus_din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4019 = bus_din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4020 = bus_din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4021 = bus_din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4022 = bus_din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4023 = bus_din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4024 = bus_din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4025 = bus_din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4026 = bus_din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4027 = bus_din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4028 = bus_din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4029 = bus_din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4030 = bus_din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4031 = bus_din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4032 = bus_din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4033 = bus_din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4034 = bus_din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4035 = bus_din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4036 = bus_din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4037 = bus_din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4038 = bus_din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4039 = bus_din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4040 = bus_din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4041 = bus_din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4042 = bus_din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4043 = bus_din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4044 = bus_din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4045 = bus_din[55]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4046 = bus_din[56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4047 = bus_din[57]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4048 = bus_din[58]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4049 = bus_din[59]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4050 = bus_din[60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4051 = bus_din[61]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4052 = bus_din[62]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n4053 = bus_din[63]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n4054 = {n4053, n4052, n4051, n4050, n4049, n4048, n4047, n4046, n4045, n4044, n4043, n4042, n4041, n4040, n4039, n4038, n4037, n4036, n4035, n4034, n4033, n4032, n4031, n4030, n4029, n4028, n4027, n4026, n4025, n4024, n4023, n4022, n4021, n4020, n4019, n4018, n4017, n4016, n4015, n4014, n4013, n4012, n4011, n4010, n4009, n4008, n4007, n4006, n4005, n4004, n4003, n4002, n4001, n4000, n3999, n3998, n3997, n3996, n3995, n3994, n3993, n3992, n3991, n3990};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n4055 = n3989 ? n4054 : dout_buffer;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:71:10 */
  assign n4057 = bus_rst ? 64'b1100001100101001100001111101001010101010001101000000010001001000 : n4055;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4060 = din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4061 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4062 = n4061 ? n4060 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4064 = din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4065 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4066 = n4065 ? n4064 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4068 = din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4069 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4070 = n4069 ? n4068 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4072 = din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4073 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4074 = n4073 ? n4072 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4076 = din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4077 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4078 = n4077 ? n4076 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4080 = din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4081 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4082 = n4081 ? n4080 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4084 = din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4085 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4086 = n4085 ? n4084 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4088 = din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4089 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4090 = n4089 ? n4088 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4092 = din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4093 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4094 = n4093 ? n4092 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4096 = din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4097 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4098 = n4097 ? n4096 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4100 = din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4101 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4102 = n4101 ? n4100 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4104 = din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4105 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4106 = n4105 ? n4104 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4108 = din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4109 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4110 = n4109 ? n4108 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4112 = din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4113 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4114 = n4113 ? n4112 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4116 = din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4117 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4118 = n4117 ? n4116 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4120 = din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4121 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4122 = n4121 ? n4120 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4124 = din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4125 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4126 = n4125 ? n4124 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4128 = din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4129 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4130 = n4129 ? n4128 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4132 = din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4133 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4134 = n4133 ? n4132 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4136 = din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4137 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4138 = n4137 ? n4136 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4140 = din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4141 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4142 = n4141 ? n4140 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4144 = din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4145 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4146 = n4145 ? n4144 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4148 = din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4149 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4150 = n4149 ? n4148 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4152 = din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4153 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4154 = n4153 ? n4152 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4156 = din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4157 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4158 = n4157 ? n4156 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4160 = din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4161 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4162 = n4161 ? n4160 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4164 = din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4165 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4166 = n4165 ? n4164 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4168 = din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4169 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4170 = n4169 ? n4168 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4172 = din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4173 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4174 = n4173 ? n4172 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4176 = din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4177 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4178 = n4177 ? n4176 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4180 = din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4181 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4182 = n4181 ? n4180 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4184 = din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4185 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4186 = n4185 ? n4184 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4188 = din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4189 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4190 = n4189 ? n4188 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4192 = din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4193 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4194 = n4193 ? n4192 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4196 = din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4197 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4198 = n4197 ? n4196 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4200 = din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4201 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4202 = n4201 ? n4200 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4204 = din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4205 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4206 = n4205 ? n4204 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4208 = din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4209 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4210 = n4209 ? n4208 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4212 = din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4213 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4214 = n4213 ? n4212 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4216 = din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4217 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4218 = n4217 ? n4216 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4220 = din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4221 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4222 = n4221 ? n4220 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4224 = din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4225 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4226 = n4225 ? n4224 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4228 = din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4229 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4230 = n4229 ? n4228 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4232 = din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4233 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4234 = n4233 ? n4232 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4236 = din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4237 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4238 = n4237 ? n4236 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4240 = din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4241 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4242 = n4241 ? n4240 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4244 = din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4245 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4246 = n4245 ? n4244 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4248 = din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4249 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4250 = n4249 ? n4248 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4252 = din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4253 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4254 = n4253 ? n4252 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4256 = din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4257 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4258 = n4257 ? n4256 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4260 = din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4261 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4262 = n4261 ? n4260 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4264 = din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4265 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4266 = n4265 ? n4264 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4268 = din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4269 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4270 = n4269 ? n4268 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4272 = din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4273 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4274 = n4273 ? n4272 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4276 = din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4277 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4278 = n4277 ? n4276 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4280 = din[55]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4281 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4282 = n4281 ? n4280 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4284 = din[56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4285 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4286 = n4285 ? n4284 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4288 = din[57]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4289 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4290 = n4289 ? n4288 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4292 = din[58]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4293 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4294 = n4293 ? n4292 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4296 = din[59]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4297 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4298 = n4297 ? n4296 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4300 = din[60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4301 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4302 = n4301 ? n4300 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4304 = din[61]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4305 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4306 = n4305 ? n4304 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4308 = din[62]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4309 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4310 = n4309 ? n4308 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n4312 = din[63]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n4313 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n4314 = n4313 ? n4312 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:51:7 */
  assign n4316 = {n4314, n4310, n4306, n4302, n4298, n4294, n4290, n4286, n4282, n4278, n4274, n4270, n4266, n4262, n4258, n4254, n4250, n4246, n4242, n4238, n4234, n4230, n4226, n4222, n4218, n4214, n4210, n4206, n4202, n4198, n4194, n4190, n4186, n4182, n4178, n4174, n4170, n4166, n4162, n4158, n4154, n4150, n4146, n4142, n4138, n4134, n4130, n4126, n4122, n4118, n4114, n4110, n4106, n4102, n4098, n4094, n4090, n4086, n4082, n4078, n4074, n4070, n4066, n4062};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:69:7 */
  always @(posedge clk)
    n4317 <= n4057;
  initial
    n4317 = 64'b1100001100101001100001111101001010101010001101000000010001001000;
endmodule

module ereg_savestatev_Barch_0_30_62_0_cf0b42666ef5e37edea0ab8e173e42c196d03814
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [62:0] din,
   output [62:0] dout);
  reg [62:0] dout_buffer;
  wire [9:0] adri;
  wire n3654;
  wire n3655;
  wire n3656;
  wire n3657;
  wire n3658;
  wire n3659;
  wire n3660;
  wire n3661;
  wire n3662;
  wire n3663;
  wire n3664;
  wire n3665;
  wire n3666;
  wire n3667;
  wire n3668;
  wire n3669;
  wire n3670;
  wire n3671;
  wire n3672;
  wire n3673;
  wire n3674;
  wire n3675;
  wire n3676;
  wire n3677;
  wire n3678;
  wire n3679;
  wire n3680;
  wire n3681;
  wire n3682;
  wire n3683;
  wire n3684;
  wire n3685;
  wire n3686;
  wire n3687;
  wire n3688;
  wire n3689;
  wire n3690;
  wire n3691;
  wire n3692;
  wire n3693;
  wire n3694;
  wire n3695;
  wire n3696;
  wire n3697;
  wire n3698;
  wire n3699;
  wire n3700;
  wire n3701;
  wire n3702;
  wire n3703;
  wire n3704;
  wire n3705;
  wire n3706;
  wire n3707;
  wire n3708;
  wire n3709;
  wire n3710;
  wire n3711;
  wire n3712;
  wire n3713;
  wire n3714;
  wire n3715;
  wire n3716;
  wire n3717;
  wire n3718;
  wire [62:0] n3719;
  wire [62:0] n3720;
  wire [62:0] n3722;
  wire n3725;
  wire n3726;
  wire n3727;
  wire n3729;
  wire n3730;
  wire n3731;
  wire n3733;
  wire n3734;
  wire n3735;
  wire n3737;
  wire n3738;
  wire n3739;
  wire n3741;
  wire n3742;
  wire n3743;
  wire n3745;
  wire n3746;
  wire n3747;
  wire n3749;
  wire n3750;
  wire n3751;
  wire n3753;
  wire n3754;
  wire n3755;
  wire n3757;
  wire n3758;
  wire n3759;
  wire n3761;
  wire n3762;
  wire n3763;
  wire n3765;
  wire n3766;
  wire n3767;
  wire n3769;
  wire n3770;
  wire n3771;
  wire n3773;
  wire n3774;
  wire n3775;
  wire n3777;
  wire n3778;
  wire n3779;
  wire n3781;
  wire n3782;
  wire n3783;
  wire n3785;
  wire n3786;
  wire n3787;
  wire n3789;
  wire n3790;
  wire n3791;
  wire n3793;
  wire n3794;
  wire n3795;
  wire n3797;
  wire n3798;
  wire n3799;
  wire n3801;
  wire n3802;
  wire n3803;
  wire n3805;
  wire n3806;
  wire n3807;
  wire n3809;
  wire n3810;
  wire n3811;
  wire n3813;
  wire n3814;
  wire n3815;
  wire n3817;
  wire n3818;
  wire n3819;
  wire n3821;
  wire n3822;
  wire n3823;
  wire n3825;
  wire n3826;
  wire n3827;
  wire n3829;
  wire n3830;
  wire n3831;
  wire n3833;
  wire n3834;
  wire n3835;
  wire n3837;
  wire n3838;
  wire n3839;
  wire n3841;
  wire n3842;
  wire n3843;
  wire n3845;
  wire n3846;
  wire n3847;
  wire n3849;
  wire n3850;
  wire n3851;
  wire n3853;
  wire n3854;
  wire n3855;
  wire n3857;
  wire n3858;
  wire n3859;
  wire n3861;
  wire n3862;
  wire n3863;
  wire n3865;
  wire n3866;
  wire n3867;
  wire n3869;
  wire n3870;
  wire n3871;
  wire n3873;
  wire n3874;
  wire n3875;
  wire n3877;
  wire n3878;
  wire n3879;
  wire n3881;
  wire n3882;
  wire n3883;
  wire n3885;
  wire n3886;
  wire n3887;
  wire n3889;
  wire n3890;
  wire n3891;
  wire n3893;
  wire n3894;
  wire n3895;
  wire n3897;
  wire n3898;
  wire n3899;
  wire n3901;
  wire n3902;
  wire n3903;
  wire n3905;
  wire n3906;
  wire n3907;
  wire n3909;
  wire n3910;
  wire n3911;
  wire n3913;
  wire n3914;
  wire n3915;
  wire n3917;
  wire n3918;
  wire n3919;
  wire n3921;
  wire n3922;
  wire n3923;
  wire n3925;
  wire n3926;
  wire n3927;
  wire n3929;
  wire n3930;
  wire n3931;
  wire n3933;
  wire n3934;
  wire n3935;
  wire n3937;
  wire n3938;
  wire n3939;
  wire n3941;
  wire n3942;
  wire n3943;
  wire n3945;
  wire n3946;
  wire n3947;
  wire n3949;
  wire n3950;
  wire n3951;
  wire n3953;
  wire n3954;
  wire n3955;
  wire n3957;
  wire n3958;
  wire n3959;
  wire n3961;
  wire n3962;
  wire n3963;
  wire n3965;
  wire n3966;
  wire n3967;
  wire n3969;
  wire n3970;
  wire n3971;
  wire n3973;
  wire n3974;
  wire n3975;
  wire [63:0] n3978;
  reg [62:0] n3979;
  assign bus_dout = n3978; //(module output)
  assign dout = dout_buffer; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:59:11 */
  always @*
    dout_buffer = n3979; // (isignal)
  initial
    dout_buffer = 63'b000000000000000000000000000000000000000000000000000000000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:61:11 */
  assign adri = 10'b0000011110; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:25 */
  assign n3654 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:32 */
  assign n3655 = bus_wren & n3654;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3656 = bus_din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3657 = bus_din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3658 = bus_din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3659 = bus_din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3660 = bus_din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3661 = bus_din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3662 = bus_din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3663 = bus_din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3664 = bus_din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3665 = bus_din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3666 = bus_din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3667 = bus_din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3668 = bus_din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3669 = bus_din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3670 = bus_din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3671 = bus_din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3672 = bus_din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3673 = bus_din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3674 = bus_din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3675 = bus_din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3676 = bus_din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3677 = bus_din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3678 = bus_din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3679 = bus_din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3680 = bus_din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3681 = bus_din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3682 = bus_din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3683 = bus_din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3684 = bus_din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3685 = bus_din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3686 = bus_din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3687 = bus_din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3688 = bus_din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3689 = bus_din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3690 = bus_din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3691 = bus_din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3692 = bus_din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3693 = bus_din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3694 = bus_din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3695 = bus_din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3696 = bus_din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3697 = bus_din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3698 = bus_din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3699 = bus_din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3700 = bus_din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3701 = bus_din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3702 = bus_din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3703 = bus_din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3704 = bus_din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3705 = bus_din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3706 = bus_din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3707 = bus_din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3708 = bus_din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3709 = bus_din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3710 = bus_din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3711 = bus_din[55]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3712 = bus_din[56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3713 = bus_din[57]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3714 = bus_din[58]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3715 = bus_din[59]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3716 = bus_din[60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3717 = bus_din[61]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3718 = bus_din[62]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n3719 = {n3718, n3717, n3716, n3715, n3714, n3713, n3712, n3711, n3710, n3709, n3708, n3707, n3706, n3705, n3704, n3703, n3702, n3701, n3700, n3699, n3698, n3697, n3696, n3695, n3694, n3693, n3692, n3691, n3690, n3689, n3688, n3687, n3686, n3685, n3684, n3683, n3682, n3681, n3680, n3679, n3678, n3677, n3676, n3675, n3674, n3673, n3672, n3671, n3670, n3669, n3668, n3667, n3666, n3665, n3664, n3663, n3662, n3661, n3660, n3659, n3658, n3657, n3656};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n3720 = n3655 ? n3719 : dout_buffer;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:71:10 */
  assign n3722 = bus_rst ? 63'b000000000000000000000000000000000000000000000000000000000000000 : n3720;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3725 = din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3726 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3727 = n3726 ? n3725 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3729 = din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3730 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3731 = n3730 ? n3729 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3733 = din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3734 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3735 = n3734 ? n3733 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3737 = din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3738 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3739 = n3738 ? n3737 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3741 = din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3742 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3743 = n3742 ? n3741 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3745 = din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3746 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3747 = n3746 ? n3745 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3749 = din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3750 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3751 = n3750 ? n3749 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3753 = din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3754 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3755 = n3754 ? n3753 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3757 = din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3758 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3759 = n3758 ? n3757 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3761 = din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3762 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3763 = n3762 ? n3761 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3765 = din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3766 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3767 = n3766 ? n3765 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3769 = din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3770 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3771 = n3770 ? n3769 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3773 = din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3774 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3775 = n3774 ? n3773 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3777 = din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3778 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3779 = n3778 ? n3777 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3781 = din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3782 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3783 = n3782 ? n3781 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3785 = din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3786 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3787 = n3786 ? n3785 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3789 = din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3790 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3791 = n3790 ? n3789 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3793 = din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3794 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3795 = n3794 ? n3793 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3797 = din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3798 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3799 = n3798 ? n3797 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3801 = din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3802 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3803 = n3802 ? n3801 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3805 = din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3806 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3807 = n3806 ? n3805 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3809 = din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3810 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3811 = n3810 ? n3809 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3813 = din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3814 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3815 = n3814 ? n3813 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3817 = din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3818 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3819 = n3818 ? n3817 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3821 = din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3822 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3823 = n3822 ? n3821 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3825 = din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3826 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3827 = n3826 ? n3825 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3829 = din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3830 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3831 = n3830 ? n3829 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3833 = din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3834 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3835 = n3834 ? n3833 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3837 = din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3838 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3839 = n3838 ? n3837 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3841 = din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3842 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3843 = n3842 ? n3841 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3845 = din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3846 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3847 = n3846 ? n3845 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3849 = din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3850 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3851 = n3850 ? n3849 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3853 = din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3854 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3855 = n3854 ? n3853 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3857 = din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3858 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3859 = n3858 ? n3857 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3861 = din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3862 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3863 = n3862 ? n3861 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3865 = din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3866 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3867 = n3866 ? n3865 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3869 = din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3870 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3871 = n3870 ? n3869 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3873 = din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3874 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3875 = n3874 ? n3873 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3877 = din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3878 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3879 = n3878 ? n3877 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3881 = din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3882 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3883 = n3882 ? n3881 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3885 = din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3886 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3887 = n3886 ? n3885 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3889 = din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3890 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3891 = n3890 ? n3889 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3893 = din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3894 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3895 = n3894 ? n3893 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3897 = din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3898 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3899 = n3898 ? n3897 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3901 = din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3902 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3903 = n3902 ? n3901 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3905 = din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3906 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3907 = n3906 ? n3905 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3909 = din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3910 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3911 = n3910 ? n3909 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3913 = din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3914 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3915 = n3914 ? n3913 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3917 = din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3918 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3919 = n3918 ? n3917 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3921 = din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3922 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3923 = n3922 ? n3921 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3925 = din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3926 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3927 = n3926 ? n3925 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3929 = din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3930 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3931 = n3930 ? n3929 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3933 = din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3934 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3935 = n3934 ? n3933 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3937 = din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3938 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3939 = n3938 ? n3937 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3941 = din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3942 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3943 = n3942 ? n3941 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3945 = din[55]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3946 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3947 = n3946 ? n3945 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3949 = din[56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3950 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3951 = n3950 ? n3949 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3953 = din[57]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3954 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3955 = n3954 ? n3953 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3957 = din[58]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3958 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3959 = n3958 ? n3957 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3961 = din[59]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3962 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3963 = n3962 ? n3961 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3965 = din[60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3966 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3967 = n3966 ? n3965 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3969 = din[61]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3970 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3971 = n3970 ? n3969 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3973 = din[62]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3974 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3975 = n3974 ? n3973 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:51:7 */
  assign n3978 = {1'b0, n3975, n3971, n3967, n3963, n3959, n3955, n3951, n3947, n3943, n3939, n3935, n3931, n3927, n3923, n3919, n3915, n3911, n3907, n3903, n3899, n3895, n3891, n3887, n3883, n3879, n3875, n3871, n3867, n3863, n3859, n3855, n3851, n3847, n3843, n3839, n3835, n3831, n3827, n3823, n3819, n3815, n3811, n3807, n3803, n3799, n3795, n3791, n3787, n3783, n3779, n3775, n3771, n3767, n3763, n3759, n3755, n3751, n3747, n3743, n3739, n3735, n3731, n3727};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:69:7 */
  always @(posedge clk)
    n3979 <= n3722;
  initial
    n3979 = 63'b000000000000000000000000000000000000000000000000000000000000000;
endmodule

module ereg_savestatev_Barch_0_29_54_0_cf0b42666ef5e37edea0ab8e173e42c196d03814
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [54:0] din,
   output [54:0] dout);
  reg [54:0] dout_buffer;
  wire [9:0] adri;
  wire n3352;
  wire n3353;
  wire n3354;
  wire n3355;
  wire n3356;
  wire n3357;
  wire n3358;
  wire n3359;
  wire n3360;
  wire n3361;
  wire n3362;
  wire n3363;
  wire n3364;
  wire n3365;
  wire n3366;
  wire n3367;
  wire n3368;
  wire n3369;
  wire n3370;
  wire n3371;
  wire n3372;
  wire n3373;
  wire n3374;
  wire n3375;
  wire n3376;
  wire n3377;
  wire n3378;
  wire n3379;
  wire n3380;
  wire n3381;
  wire n3382;
  wire n3383;
  wire n3384;
  wire n3385;
  wire n3386;
  wire n3387;
  wire n3388;
  wire n3389;
  wire n3390;
  wire n3391;
  wire n3392;
  wire n3393;
  wire n3394;
  wire n3395;
  wire n3396;
  wire n3397;
  wire n3398;
  wire n3399;
  wire n3400;
  wire n3401;
  wire n3402;
  wire n3403;
  wire n3404;
  wire n3405;
  wire n3406;
  wire n3407;
  wire n3408;
  wire [54:0] n3409;
  wire [54:0] n3410;
  wire [54:0] n3412;
  wire n3415;
  wire n3416;
  wire n3417;
  wire n3419;
  wire n3420;
  wire n3421;
  wire n3423;
  wire n3424;
  wire n3425;
  wire n3427;
  wire n3428;
  wire n3429;
  wire n3431;
  wire n3432;
  wire n3433;
  wire n3435;
  wire n3436;
  wire n3437;
  wire n3439;
  wire n3440;
  wire n3441;
  wire n3443;
  wire n3444;
  wire n3445;
  wire n3447;
  wire n3448;
  wire n3449;
  wire n3451;
  wire n3452;
  wire n3453;
  wire n3455;
  wire n3456;
  wire n3457;
  wire n3459;
  wire n3460;
  wire n3461;
  wire n3463;
  wire n3464;
  wire n3465;
  wire n3467;
  wire n3468;
  wire n3469;
  wire n3471;
  wire n3472;
  wire n3473;
  wire n3475;
  wire n3476;
  wire n3477;
  wire n3479;
  wire n3480;
  wire n3481;
  wire n3483;
  wire n3484;
  wire n3485;
  wire n3487;
  wire n3488;
  wire n3489;
  wire n3491;
  wire n3492;
  wire n3493;
  wire n3495;
  wire n3496;
  wire n3497;
  wire n3499;
  wire n3500;
  wire n3501;
  wire n3503;
  wire n3504;
  wire n3505;
  wire n3507;
  wire n3508;
  wire n3509;
  wire n3511;
  wire n3512;
  wire n3513;
  wire n3515;
  wire n3516;
  wire n3517;
  wire n3519;
  wire n3520;
  wire n3521;
  wire n3523;
  wire n3524;
  wire n3525;
  wire n3527;
  wire n3528;
  wire n3529;
  wire n3531;
  wire n3532;
  wire n3533;
  wire n3535;
  wire n3536;
  wire n3537;
  wire n3539;
  wire n3540;
  wire n3541;
  wire n3543;
  wire n3544;
  wire n3545;
  wire n3547;
  wire n3548;
  wire n3549;
  wire n3551;
  wire n3552;
  wire n3553;
  wire n3555;
  wire n3556;
  wire n3557;
  wire n3559;
  wire n3560;
  wire n3561;
  wire n3563;
  wire n3564;
  wire n3565;
  wire n3567;
  wire n3568;
  wire n3569;
  wire n3571;
  wire n3572;
  wire n3573;
  wire n3575;
  wire n3576;
  wire n3577;
  wire n3579;
  wire n3580;
  wire n3581;
  wire n3583;
  wire n3584;
  wire n3585;
  wire n3587;
  wire n3588;
  wire n3589;
  wire n3591;
  wire n3592;
  wire n3593;
  wire n3595;
  wire n3596;
  wire n3597;
  wire n3599;
  wire n3600;
  wire n3601;
  wire n3603;
  wire n3604;
  wire n3605;
  wire n3607;
  wire n3608;
  wire n3609;
  wire n3611;
  wire n3612;
  wire n3613;
  wire n3615;
  wire n3616;
  wire n3617;
  wire n3619;
  wire n3620;
  wire n3621;
  wire n3623;
  wire n3624;
  wire n3625;
  wire n3627;
  wire n3628;
  wire n3629;
  wire n3631;
  wire n3632;
  wire n3633;
  wire [63:0] n3644;
  reg [54:0] n3645;
  assign bus_dout = n3644; //(module output)
  assign dout = dout_buffer; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:59:11 */
  always @*
    dout_buffer = n3645; // (isignal)
  initial
    dout_buffer = 55'b0000000000000000000000000000000000000000000000000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:61:11 */
  assign adri = 10'b0000011101; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:25 */
  assign n3352 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:32 */
  assign n3353 = bus_wren & n3352;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3354 = bus_din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3355 = bus_din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3356 = bus_din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3357 = bus_din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3358 = bus_din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3359 = bus_din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3360 = bus_din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3361 = bus_din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3362 = bus_din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3363 = bus_din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3364 = bus_din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3365 = bus_din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3366 = bus_din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3367 = bus_din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3368 = bus_din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3369 = bus_din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3370 = bus_din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3371 = bus_din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3372 = bus_din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3373 = bus_din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3374 = bus_din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3375 = bus_din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3376 = bus_din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3377 = bus_din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3378 = bus_din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3379 = bus_din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3380 = bus_din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3381 = bus_din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3382 = bus_din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3383 = bus_din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3384 = bus_din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3385 = bus_din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3386 = bus_din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3387 = bus_din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3388 = bus_din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3389 = bus_din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3390 = bus_din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3391 = bus_din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3392 = bus_din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3393 = bus_din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3394 = bus_din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3395 = bus_din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3396 = bus_din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3397 = bus_din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3398 = bus_din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3399 = bus_din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3400 = bus_din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3401 = bus_din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3402 = bus_din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3403 = bus_din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3404 = bus_din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3405 = bus_din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3406 = bus_din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3407 = bus_din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3408 = bus_din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n3409 = {n3408, n3407, n3406, n3405, n3404, n3403, n3402, n3401, n3400, n3399, n3398, n3397, n3396, n3395, n3394, n3393, n3392, n3391, n3390, n3389, n3388, n3387, n3386, n3385, n3384, n3383, n3382, n3381, n3380, n3379, n3378, n3377, n3376, n3375, n3374, n3373, n3372, n3371, n3370, n3369, n3368, n3367, n3366, n3365, n3364, n3363, n3362, n3361, n3360, n3359, n3358, n3357, n3356, n3355, n3354};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n3410 = n3353 ? n3409 : dout_buffer;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:71:10 */
  assign n3412 = bus_rst ? 55'b0000000000000000000000000000000000000000000000000000000 : n3410;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3415 = din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3416 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3417 = n3416 ? n3415 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3419 = din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3420 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3421 = n3420 ? n3419 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3423 = din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3424 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3425 = n3424 ? n3423 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3427 = din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3428 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3429 = n3428 ? n3427 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3431 = din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3432 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3433 = n3432 ? n3431 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3435 = din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3436 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3437 = n3436 ? n3435 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3439 = din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3440 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3441 = n3440 ? n3439 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3443 = din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3444 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3445 = n3444 ? n3443 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3447 = din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3448 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3449 = n3448 ? n3447 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3451 = din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3452 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3453 = n3452 ? n3451 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3455 = din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3456 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3457 = n3456 ? n3455 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3459 = din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3460 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3461 = n3460 ? n3459 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3463 = din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3464 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3465 = n3464 ? n3463 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3467 = din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3468 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3469 = n3468 ? n3467 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3471 = din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3472 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3473 = n3472 ? n3471 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3475 = din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3476 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3477 = n3476 ? n3475 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3479 = din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3480 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3481 = n3480 ? n3479 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3483 = din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3484 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3485 = n3484 ? n3483 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3487 = din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3488 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3489 = n3488 ? n3487 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3491 = din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3492 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3493 = n3492 ? n3491 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3495 = din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3496 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3497 = n3496 ? n3495 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3499 = din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3500 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3501 = n3500 ? n3499 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3503 = din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3504 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3505 = n3504 ? n3503 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3507 = din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3508 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3509 = n3508 ? n3507 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3511 = din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3512 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3513 = n3512 ? n3511 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3515 = din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3516 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3517 = n3516 ? n3515 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3519 = din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3520 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3521 = n3520 ? n3519 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3523 = din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3524 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3525 = n3524 ? n3523 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3527 = din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3528 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3529 = n3528 ? n3527 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3531 = din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3532 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3533 = n3532 ? n3531 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3535 = din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3536 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3537 = n3536 ? n3535 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3539 = din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3540 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3541 = n3540 ? n3539 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3543 = din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3544 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3545 = n3544 ? n3543 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3547 = din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3548 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3549 = n3548 ? n3547 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3551 = din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3552 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3553 = n3552 ? n3551 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3555 = din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3556 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3557 = n3556 ? n3555 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3559 = din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3560 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3561 = n3560 ? n3559 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3563 = din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3564 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3565 = n3564 ? n3563 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3567 = din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3568 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3569 = n3568 ? n3567 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3571 = din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3572 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3573 = n3572 ? n3571 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3575 = din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3576 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3577 = n3576 ? n3575 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3579 = din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3580 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3581 = n3580 ? n3579 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3583 = din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3584 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3585 = n3584 ? n3583 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3587 = din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3588 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3589 = n3588 ? n3587 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3591 = din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3592 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3593 = n3592 ? n3591 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3595 = din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3596 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3597 = n3596 ? n3595 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3599 = din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3600 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3601 = n3600 ? n3599 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3603 = din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3604 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3605 = n3604 ? n3603 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3607 = din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3608 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3609 = n3608 ? n3607 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3611 = din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3612 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3613 = n3612 ? n3611 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3615 = din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3616 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3617 = n3616 ? n3615 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3619 = din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3620 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3621 = n3620 ? n3619 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3623 = din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3624 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3625 = n3624 ? n3623 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3627 = din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3628 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3629 = n3628 ? n3627 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3631 = din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3632 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3633 = n3632 ? n3631 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:51:7 */
  assign n3644 = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, n3633, n3629, n3625, n3621, n3617, n3613, n3609, n3605, n3601, n3597, n3593, n3589, n3585, n3581, n3577, n3573, n3569, n3565, n3561, n3557, n3553, n3549, n3545, n3541, n3537, n3533, n3529, n3525, n3521, n3517, n3513, n3509, n3505, n3501, n3497, n3493, n3489, n3485, n3481, n3477, n3473, n3469, n3465, n3461, n3457, n3453, n3449, n3445, n3441, n3437, n3433, n3429, n3425, n3421, n3417};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:69:7 */
  always @(posedge clk)
    n3645 <= n3412;
  initial
    n3645 = 55'b0000000000000000000000000000000000000000000000000000000;
endmodule

module ereg_savestatev_Barch_0_28_63_0_cf0b42666ef5e37edea0ab8e173e42c196d03814
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [63:0] din,
   output [63:0] dout);
  reg [63:0] dout_buffer;
  wire [9:0] adri;
  wire n3014;
  wire n3015;
  wire n3016;
  wire n3017;
  wire n3018;
  wire n3019;
  wire n3020;
  wire n3021;
  wire n3022;
  wire n3023;
  wire n3024;
  wire n3025;
  wire n3026;
  wire n3027;
  wire n3028;
  wire n3029;
  wire n3030;
  wire n3031;
  wire n3032;
  wire n3033;
  wire n3034;
  wire n3035;
  wire n3036;
  wire n3037;
  wire n3038;
  wire n3039;
  wire n3040;
  wire n3041;
  wire n3042;
  wire n3043;
  wire n3044;
  wire n3045;
  wire n3046;
  wire n3047;
  wire n3048;
  wire n3049;
  wire n3050;
  wire n3051;
  wire n3052;
  wire n3053;
  wire n3054;
  wire n3055;
  wire n3056;
  wire n3057;
  wire n3058;
  wire n3059;
  wire n3060;
  wire n3061;
  wire n3062;
  wire n3063;
  wire n3064;
  wire n3065;
  wire n3066;
  wire n3067;
  wire n3068;
  wire n3069;
  wire n3070;
  wire n3071;
  wire n3072;
  wire n3073;
  wire n3074;
  wire n3075;
  wire n3076;
  wire n3077;
  wire n3078;
  wire n3079;
  wire [63:0] n3080;
  wire [63:0] n3081;
  wire [63:0] n3083;
  wire n3086;
  wire n3087;
  wire n3088;
  wire n3090;
  wire n3091;
  wire n3092;
  wire n3094;
  wire n3095;
  wire n3096;
  wire n3098;
  wire n3099;
  wire n3100;
  wire n3102;
  wire n3103;
  wire n3104;
  wire n3106;
  wire n3107;
  wire n3108;
  wire n3110;
  wire n3111;
  wire n3112;
  wire n3114;
  wire n3115;
  wire n3116;
  wire n3118;
  wire n3119;
  wire n3120;
  wire n3122;
  wire n3123;
  wire n3124;
  wire n3126;
  wire n3127;
  wire n3128;
  wire n3130;
  wire n3131;
  wire n3132;
  wire n3134;
  wire n3135;
  wire n3136;
  wire n3138;
  wire n3139;
  wire n3140;
  wire n3142;
  wire n3143;
  wire n3144;
  wire n3146;
  wire n3147;
  wire n3148;
  wire n3150;
  wire n3151;
  wire n3152;
  wire n3154;
  wire n3155;
  wire n3156;
  wire n3158;
  wire n3159;
  wire n3160;
  wire n3162;
  wire n3163;
  wire n3164;
  wire n3166;
  wire n3167;
  wire n3168;
  wire n3170;
  wire n3171;
  wire n3172;
  wire n3174;
  wire n3175;
  wire n3176;
  wire n3178;
  wire n3179;
  wire n3180;
  wire n3182;
  wire n3183;
  wire n3184;
  wire n3186;
  wire n3187;
  wire n3188;
  wire n3190;
  wire n3191;
  wire n3192;
  wire n3194;
  wire n3195;
  wire n3196;
  wire n3198;
  wire n3199;
  wire n3200;
  wire n3202;
  wire n3203;
  wire n3204;
  wire n3206;
  wire n3207;
  wire n3208;
  wire n3210;
  wire n3211;
  wire n3212;
  wire n3214;
  wire n3215;
  wire n3216;
  wire n3218;
  wire n3219;
  wire n3220;
  wire n3222;
  wire n3223;
  wire n3224;
  wire n3226;
  wire n3227;
  wire n3228;
  wire n3230;
  wire n3231;
  wire n3232;
  wire n3234;
  wire n3235;
  wire n3236;
  wire n3238;
  wire n3239;
  wire n3240;
  wire n3242;
  wire n3243;
  wire n3244;
  wire n3246;
  wire n3247;
  wire n3248;
  wire n3250;
  wire n3251;
  wire n3252;
  wire n3254;
  wire n3255;
  wire n3256;
  wire n3258;
  wire n3259;
  wire n3260;
  wire n3262;
  wire n3263;
  wire n3264;
  wire n3266;
  wire n3267;
  wire n3268;
  wire n3270;
  wire n3271;
  wire n3272;
  wire n3274;
  wire n3275;
  wire n3276;
  wire n3278;
  wire n3279;
  wire n3280;
  wire n3282;
  wire n3283;
  wire n3284;
  wire n3286;
  wire n3287;
  wire n3288;
  wire n3290;
  wire n3291;
  wire n3292;
  wire n3294;
  wire n3295;
  wire n3296;
  wire n3298;
  wire n3299;
  wire n3300;
  wire n3302;
  wire n3303;
  wire n3304;
  wire n3306;
  wire n3307;
  wire n3308;
  wire n3310;
  wire n3311;
  wire n3312;
  wire n3314;
  wire n3315;
  wire n3316;
  wire n3318;
  wire n3319;
  wire n3320;
  wire n3322;
  wire n3323;
  wire n3324;
  wire n3326;
  wire n3327;
  wire n3328;
  wire n3330;
  wire n3331;
  wire n3332;
  wire n3334;
  wire n3335;
  wire n3336;
  wire n3338;
  wire n3339;
  wire n3340;
  wire [63:0] n3342;
  reg [63:0] n3343;
  assign bus_dout = n3342; //(module output)
  assign dout = dout_buffer; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:59:11 */
  always @*
    dout_buffer = n3343; // (isignal)
  initial
    dout_buffer = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:61:11 */
  assign adri = 10'b0000011100; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:25 */
  assign n3014 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:32 */
  assign n3015 = bus_wren & n3014;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3016 = bus_din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3017 = bus_din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3018 = bus_din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3019 = bus_din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3020 = bus_din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3021 = bus_din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3022 = bus_din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3023 = bus_din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3024 = bus_din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3025 = bus_din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3026 = bus_din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3027 = bus_din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3028 = bus_din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3029 = bus_din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3030 = bus_din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3031 = bus_din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3032 = bus_din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3033 = bus_din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3034 = bus_din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3035 = bus_din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3036 = bus_din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3037 = bus_din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3038 = bus_din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3039 = bus_din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3040 = bus_din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3041 = bus_din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3042 = bus_din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3043 = bus_din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3044 = bus_din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3045 = bus_din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3046 = bus_din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3047 = bus_din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3048 = bus_din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3049 = bus_din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3050 = bus_din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3051 = bus_din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3052 = bus_din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3053 = bus_din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3054 = bus_din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3055 = bus_din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3056 = bus_din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3057 = bus_din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3058 = bus_din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3059 = bus_din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3060 = bus_din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3061 = bus_din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3062 = bus_din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3063 = bus_din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3064 = bus_din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3065 = bus_din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3066 = bus_din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3067 = bus_din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3068 = bus_din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3069 = bus_din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3070 = bus_din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3071 = bus_din[55]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3072 = bus_din[56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3073 = bus_din[57]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3074 = bus_din[58]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3075 = bus_din[59]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3076 = bus_din[60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3077 = bus_din[61]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3078 = bus_din[62]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:79:44 */
  assign n3079 = bus_din[63]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n3080 = {n3079, n3078, n3077, n3076, n3075, n3074, n3073, n3072, n3071, n3070, n3069, n3068, n3067, n3066, n3065, n3064, n3063, n3062, n3061, n3060, n3059, n3058, n3057, n3056, n3055, n3054, n3053, n3052, n3051, n3050, n3049, n3048, n3047, n3046, n3045, n3044, n3043, n3042, n3041, n3040, n3039, n3038, n3037, n3036, n3035, n3034, n3033, n3032, n3031, n3030, n3029, n3028, n3027, n3026, n3025, n3024, n3023, n3022, n3021, n3020, n3019, n3018, n3017, n3016};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:77:13 */
  assign n3081 = n3015 ? n3080 : dout_buffer;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:71:10 */
  assign n3083 = bus_rst ? 64'b0000000000000000000000000000000000000000000000000000000000000000 : n3081;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3086 = din[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3087 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3088 = n3087 ? n3086 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3090 = din[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3091 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3092 = n3091 ? n3090 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3094 = din[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3095 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3096 = n3095 ? n3094 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3098 = din[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3099 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3100 = n3099 ? n3098 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3102 = din[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3103 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3104 = n3103 ? n3102 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3106 = din[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3107 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3108 = n3107 ? n3106 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3110 = din[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3111 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3112 = n3111 ? n3110 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3114 = din[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3115 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3116 = n3115 ? n3114 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3118 = din[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3119 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3120 = n3119 ? n3118 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3122 = din[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3123 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3124 = n3123 ? n3122 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3126 = din[10]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3127 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3128 = n3127 ? n3126 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3130 = din[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3131 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3132 = n3131 ? n3130 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3134 = din[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3135 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3136 = n3135 ? n3134 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3138 = din[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3139 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3140 = n3139 ? n3138 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3142 = din[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3143 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3144 = n3143 ? n3142 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3146 = din[15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3147 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3148 = n3147 ? n3146 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3150 = din[16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3151 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3152 = n3151 ? n3150 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3154 = din[17]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3155 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3156 = n3155 ? n3154 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3158 = din[18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3159 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3160 = n3159 ? n3158 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3162 = din[19]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3163 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3164 = n3163 ? n3162 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3166 = din[20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3167 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3168 = n3167 ? n3166 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3170 = din[21]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3171 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3172 = n3171 ? n3170 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3174 = din[22]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3175 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3176 = n3175 ? n3174 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3178 = din[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3179 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3180 = n3179 ? n3178 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3182 = din[24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3183 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3184 = n3183 ? n3182 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3186 = din[25]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3187 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3188 = n3187 ? n3186 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3190 = din[26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3191 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3192 = n3191 ? n3190 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3194 = din[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3195 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3196 = n3195 ? n3194 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3198 = din[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3199 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3200 = n3199 ? n3198 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3202 = din[29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3203 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3204 = n3203 ? n3202 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3206 = din[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3207 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3208 = n3207 ? n3206 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3210 = din[31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3211 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3212 = n3211 ? n3210 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3214 = din[32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3215 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3216 = n3215 ? n3214 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3218 = din[33]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3219 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3220 = n3219 ? n3218 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3222 = din[34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3223 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3224 = n3223 ? n3222 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3226 = din[35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3227 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3228 = n3227 ? n3226 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3230 = din[36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3231 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3232 = n3231 ? n3230 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3234 = din[37]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3235 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3236 = n3235 ? n3234 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3238 = din[38]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3239 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3240 = n3239 ? n3238 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3242 = din[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3243 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3244 = n3243 ? n3242 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3246 = din[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3247 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3248 = n3247 ? n3246 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3250 = din[41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3251 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3252 = n3251 ? n3250 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3254 = din[42]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3255 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3256 = n3255 ? n3254 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3258 = din[43]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3259 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3260 = n3259 ? n3258 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3262 = din[44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3263 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3264 = n3263 ? n3262 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3266 = din[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3267 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3268 = n3267 ? n3266 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3270 = din[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3271 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3272 = n3271 ? n3270 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3274 = din[47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3275 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3276 = n3275 ? n3274 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3278 = din[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3279 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3280 = n3279 ? n3278 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3282 = din[49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3283 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3284 = n3283 ? n3282 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3286 = din[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3287 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3288 = n3287 ? n3286 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3290 = din[51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3291 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3292 = n3291 ? n3290 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3294 = din[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3295 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3296 = n3295 ? n3294 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3298 = din[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3299 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3300 = n3299 ? n3298 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3302 = din[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3303 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3304 = n3303 ? n3302 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3306 = din[55]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3307 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3308 = n3307 ? n3306 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3310 = din[56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3311 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3312 = n3311 ? n3310 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3314 = din[57]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3315 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3316 = n3315 ? n3314 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3318 = din[58]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3319 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3320 = n3319 ? n3318 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3322 = din[59]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3323 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3324 = n3323 ? n3322 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3326 = din[60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3327 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3328 = n3327 ? n3326 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3330 = din[61]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3331 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3332 = n3331 ? n3330 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3334 = din[62]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3335 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3336 = n3335 ? n3334 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:25 */
  assign n3338 = din[63]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:42 */
  assign n3339 = bus_adr == adri;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:91:29 */
  assign n3340 = n3339 ? n3338 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:51:7 */
  assign n3342 = {n3340, n3336, n3332, n3328, n3324, n3320, n3316, n3312, n3308, n3304, n3300, n3296, n3292, n3288, n3284, n3280, n3276, n3272, n3268, n3264, n3260, n3256, n3252, n3248, n3244, n3240, n3236, n3232, n3228, n3224, n3220, n3216, n3212, n3208, n3204, n3200, n3196, n3192, n3188, n3184, n3180, n3176, n3172, n3168, n3164, n3160, n3156, n3152, n3148, n3144, n3140, n3136, n3132, n3128, n3124, n3120, n3116, n3112, n3108, n3104, n3100, n3096, n3092, n3088};
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:69:7 */
  always @(posedge clk)
    n3343 <= n3083;
  initial
    n3343 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
endmodule

module apu_dac_Bapu_dac_arch
  (input  clk,
   input  ce,
   input  dac_en,
   input  dac_invert,
   input  [3:0] dac_input,
   output [8:0] dac_output);
  reg [6:0] dac_decay_timer;
  wire [8:0] dac_analog;
  wire [31:0] n2954;
  wire n2956;
  wire [31:0] n2957;
  wire [31:0] n2959;
  wire [6:0] n2960;
  wire [6:0] n2962;
  wire [6:0] n2964;
  wire [3:0] n2977;
  wire [8:0] n2979;
  wire [4:0] n2981;
  wire [8:0] n2983;
  wire [8:0] n2984;
  wire [31:0] n2985;
  wire n2987;
  wire n2989;
  wire [8:0] n2991;
  wire n2993;
  wire [8:0] n2995;
  wire [8:0] n2996;
  wire [8:0] n2997;
  wire [8:0] n2998;
  wire [8:0] n2999;
  wire [6:0] n3002;
  reg [6:0] n3003;
  wire [8:0] n3004;
  reg [8:0] n3005;
  assign dac_output = dac_analog; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1690:18 */
  always @*
    dac_decay_timer = n3003; // (isignal)
  initial
    dac_decay_timer = 7'b0000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1692:18 */
  assign dac_analog = n3005; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1715:52 */
  assign n2954 = {25'b0, dac_decay_timer};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1715:52 */
  assign n2956 = $signed(n2954) > $signed(32'b00000000000000000000000000000000);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1716:76 */
  assign n2957 = {25'b0, dac_decay_timer};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1716:76 */
  assign n2959 = n2957 - 32'b00000000000000000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1716:60 */
  assign n2960 = n2959[6:0];  // trunc
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1715:33 */
  assign n2962 = n2956 ? n2960 : 7'b1100100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1712:25 */
  assign n2964 = dac_en ? 7'b1100100 : n2962;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1701:44 */
  assign n2977 = dac_input ^ 4'b0111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1701:56 */
  assign n2979 = {n2977, 5'b00000};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1703:43 */
  assign n2981 = {1'b0, dac_input};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1703:49 */
  assign n2983 = {n2981, 4'b0000};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1700:17 */
  assign n2984 = dac_invert ? n2979 : n2983;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1729:47 */
  assign n2985 = {25'b0, dac_decay_timer};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1729:47 */
  assign n2987 = n2985 == 32'b00000000000000000000000000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1730:47 */
  assign n2989 = $signed(dac_analog) < $signed(9'b000000000);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1731:66 */
  assign n2991 = dac_analog + 9'b000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1732:50 */
  assign n2993 = $signed(dac_analog) > $signed(9'b000000000);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1733:66 */
  assign n2995 = dac_analog - 9'b000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1732:33 */
  assign n2996 = n2993 ? n2995 : dac_analog;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1730:33 */
  assign n2997 = n2989 ? n2991 : n2996;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1729:25 */
  assign n2998 = n2987 ? n2997 : dac_analog;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1727:25 */
  assign n2999 = dac_en ? n2984 : n2998;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1711:17 */
  assign n3002 = ce ? n2964 : dac_decay_timer;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1711:17 */
  always @(posedge clk)
    n3003 <= n3002;
  initial
    n3003 = 7'b0000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1726:17 */
  assign n3004 = ce ? n2999 : dac_analog;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1726:17 */
  always @(posedge clk)
    n3005 <= n3004;
endmodule

module ereg_savestate_Barch_0_5368d06e7557ca14ab5ed84d83875d7beccb6f6c
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [63:0] din,
   output [63:0] dout);
  wire [63:0] \ireg_savestatev.bus_dout ;
  wire [63:0] \ireg_savestatev.dout ;
  assign bus_dout = \ireg_savestatev.bus_dout ; //(module output)
  assign dout = \ireg_savestatev.dout ; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:142:9 */
  ereg_savestatev_Barch_0_34_63_0_0d12c86699a623151760f96a58ab62407ca52986 ireg_savestatev (
    .clk(clk),
    .bus_din(bus_din),
    .bus_adr(bus_adr),
    .bus_wren(bus_wren),
    .bus_rst(bus_rst),
    .din(din),
    .bus_dout(\ireg_savestatev.bus_dout ),
    .dout(\ireg_savestatev.dout ));
endmodule

module ereg_savestate_Barch_0_064cc145e4df328cf2334547b447688a1ad7096d
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [63:0] din,
   output [63:0] dout);
  wire [63:0] \ireg_savestatev.bus_dout ;
  wire [63:0] \ireg_savestatev.dout ;
  assign bus_dout = \ireg_savestatev.bus_dout ; //(module output)
  assign dout = \ireg_savestatev.dout ; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:142:9 */
  ereg_savestatev_Barch_0_33_63_0_858f4169ab81acdb5e41a52b3572d5380f34b951 ireg_savestatev (
    .clk(clk),
    .bus_din(bus_din),
    .bus_adr(bus_adr),
    .bus_wren(bus_wren),
    .bus_rst(bus_rst),
    .din(din),
    .bus_dout(\ireg_savestatev.bus_dout ),
    .dout(\ireg_savestatev.dout ));
endmodule

module ereg_savestate_Barch_0_ade93475e281eb6d3855f121ed91338fdf98769f
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [62:0] din,
   output [62:0] dout);
  wire [63:0] \ireg_savestatev.bus_dout ;
  wire [62:0] \ireg_savestatev.dout ;
  assign bus_dout = \ireg_savestatev.bus_dout ; //(module output)
  assign dout = \ireg_savestatev.dout ; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:142:9 */
  ereg_savestatev_Barch_0_30_62_0_cf0b42666ef5e37edea0ab8e173e42c196d03814 ireg_savestatev (
    .clk(clk),
    .bus_din(bus_din),
    .bus_adr(bus_adr),
    .bus_wren(bus_wren),
    .bus_rst(bus_rst),
    .din(din),
    .bus_dout(\ireg_savestatev.bus_dout ),
    .dout(\ireg_savestatev.dout ));
endmodule

module ereg_savestate_Barch_0_a95deab68965e2f133920ceea7156bf77acd65ac
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [54:0] din,
   output [54:0] dout);
  wire [63:0] \ireg_savestatev.bus_dout ;
  wire [54:0] \ireg_savestatev.dout ;
  assign bus_dout = \ireg_savestatev.bus_dout ; //(module output)
  assign dout = \ireg_savestatev.dout ; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:142:9 */
  ereg_savestatev_Barch_0_29_54_0_cf0b42666ef5e37edea0ab8e173e42c196d03814 ireg_savestatev (
    .clk(clk),
    .bus_din(bus_din),
    .bus_adr(bus_adr),
    .bus_wren(bus_wren),
    .bus_rst(bus_rst),
    .din(din),
    .bus_dout(\ireg_savestatev.bus_dout ),
    .dout(\ireg_savestatev.dout ));
endmodule

module ereg_savestate_Barch_0_424347de9c0cdc6ce5cf6cbd4fe64dcf1f51e87c
  (input  clk,
   input  [63:0] bus_din,
   input  [9:0] bus_adr,
   input  bus_wren,
   input  bus_rst,
   output [63:0] bus_dout,
   input  [63:0] din,
   output [63:0] dout);
  wire [63:0] \ireg_savestatev.bus_dout ;
  wire [63:0] \ireg_savestatev.dout ;
  assign bus_dout = \ireg_savestatev.bus_dout ; //(module output)
  assign dout = \ireg_savestatev.dout ; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/bus_savestates.vhd:142:9 */
  ereg_savestatev_Barch_0_28_63_0_cf0b42666ef5e37edea0ab8e173e42c196d03814 ireg_savestatev (
    .clk(clk),
    .bus_din(bus_din),
    .bus_adr(bus_adr),
    .bus_wren(bus_wren),
    .bus_rst(bus_rst),
    .din(din),
    .bus_dout(\ireg_savestatev.bus_dout ),
    .dout(\ireg_savestatev.dout ));
endmodule

module gbc_snd
  (input  clk,
   input  ce,
   input  apu_framecount_en,
   input  reset,
   input  is_gbc,
   input  remove_pops,
   input  s1_read,
   input  s1_write,
   input  [6:0] s1_addr,
   output [7:0] s1_readdata,
   input  [7:0] s1_writedata,
   output [15:0] snd_left,
   output [15:0] snd_right,
   input  [63:0] SaveStateBus_Din,
   input  [9:0] SaveStateBus_Adr,
   input  SaveStateBus_wren,
   input  SaveStateBus_rst,
   output [63:0] SaveStateBus_Dout);
  wire en_snd2;
  wire en_snd4;
  wire en_snden2;
  wire en_snden4;
  wire en_len;
  wire en_len_r;
  wire en_env;
  wire en_sweep;
  wire snd_enable;
  wire [2:0] sq1_swper;
  wire sq1_swdir;
  wire sq1_swdir_change;
  wire [2:0] sq1_swshift;
  wire [1:0] sq1_duty;
  wire [6:0] sq1_slen;
  wire [3:0] sq1_svol;
  wire sq1_out;
  wire sq1_envsgn;
  wire sq1_envsgn_old;
  wire [2:0] sq1_envper;
  wire [2:0] sq1_envper_old;
  wire [10:0] sq1_freq;
  wire sq1_trigger;
  wire sq1_lenchk;
  wire [10:0] sq1_fr2;
  wire [3:0] sq1_vol;
  wire sq1_nr2change;
  wire sq1_lenchange;
  wire sq1_lenquirk;
  wire sq1_freqchange;
  wire sq1_playing;
  wire [3:0] sq1_wav;
  wire sq1_suppressed;
  wire sq2_out;
  wire [1:0] sq2_duty;
  wire [6:0] sq2_slen;
  wire [3:0] sq2_svol;
  wire sq2_nr2change;
  wire sq2_lenchange;
  wire sq2_lenquirk;
  wire sq2_envsgn;
  wire [2:0] sq2_envper;
  wire sq2_envsgn_old;
  wire [2:0] sq2_envper_old;
  wire [10:0] sq2_freq;
  wire sq2_trigger;
  wire sq2_lenchk;
  wire [3:0] sq2_vol;
  wire sq2_playing;
  wire [3:0] sq2_wav;
  wire sq2_suppressed;
  wire wav_enable;
  wire [8:0] wav_slen;
  wire wav_lenchange;
  wire wav_lenquirk;
  wire [1:0] wav_volsh;
  wire [10:0] wav_freq;
  wire wav_trigger;
  wire wav_lenchk;
  wire [4:0] wav_index;
  wire [1:0] wav_access;
  wire wav_playing;
  wire [3:0] wav_wav;
  wire [127:0] wav_ram;
  wire [3:0] wav_wav_r;
  wire [6:0] noi_slen;
  wire noi_lenchange;
  wire noi_lenquirk;
  wire [3:0] noi_svol;
  wire noi_nr2change;
  wire noi_envsgn;
  wire [2:0] noi_envper;
  wire noi_envsgn_old;
  wire [2:0] noi_envper_old;
  wire [3:0] noi_freqsh;
  wire noi_freqchange;
  wire noi_short;
  wire [2:0] noi_div;
  wire noi_trigger;
  wire noi_lenchk;
  wire [3:0] noi_vol;
  wire noi_playing;
  wire [3:0] noi_wav;
  wire [7:0] ch_map;
  wire [7:0] ch_vol;
  reg [2:0] framecnt;
  wire sq1_trigger_r;
  wire sq2_trigger_r;
  wire wav_trigger_r;
  wire noi_trigger_r;
  wire s1_write_r;
  wire [447:0] reg_wired_or;
  wire [63:0] ss_sound1;
  wire [63:0] ss_sound1_back;
  wire [54:0] ss_sound2;
  wire [54:0] ss_sound2_back;
  wire [62:0] ss_sound3;
  wire [62:0] ss_sound3_back;
  wire [63:0] ss_wave1;
  wire [63:0] ss_wave1_back;
  wire [63:0] ss_wave2;
  wire [63:0] ss_wave2_back;
  wire [63:0] ss_wave1_gbc;
  wire [63:0] ss_wave2_gbc;
  wire sq1_dac_en;
  wire sq2_dac_en;
  wire noi_dac_en;
  wire [8:0] sq1_dac_out;
  wire [8:0] sq2_dac_out;
  wire [8:0] wav_dac_out;
  wire [8:0] noi_dac_out;
  wire [63:0] \ireg_savestate_sound1.bus_dout ;
  wire [63:0] \ireg_savestate_sound2.bus_dout ;
  wire [63:0] \ireg_savestate_sound3.bus_dout ;
  wire [63:0] \ireg_savestate_wave1.bus_dout ;
  wire [63:0] \ireg_savestate_wave2.bus_dout ;
  wire [63:0] \ireg_savestate_wave1_gbc.bus_dout ;
  wire [63:0] \ireg_savestate_wave2_gbc.bus_dout ;
  wire [63:0] n22;
  wire [63:0] n23;
  wire [63:0] n24;
  wire [63:0] n25;
  wire [63:0] n26;
  wire [63:0] n27;
  wire [63:0] n28;
  wire [63:0] n29;
  wire [63:0] n30;
  wire [63:0] n31;
  wire [63:0] n32;
  wire [63:0] n33;
  wire [63:0] n34;
  wire n36;
  wire n37;
  reg [1:0] frame_sequencer_clkcnt;
  wire [2:0] n44;
  wire n46;
  wire n47;
  wire n48;
  wire n49;
  wire n50;
  wire n51;
  wire n52;
  wire [31:0] n53;
  wire n55;
  wire [31:0] n56;
  wire n58;
  wire n59;
  wire [31:0] n60;
  wire n62;
  wire n63;
  wire [31:0] n64;
  wire n66;
  wire n67;
  wire n70;
  wire [31:0] n71;
  wire n73;
  wire [31:0] n74;
  wire n76;
  wire n77;
  wire n80;
  wire [31:0] n81;
  wire n83;
  wire n86;
  wire [31:0] n87;
  wire n89;
  wire [31:0] n90;
  wire [31:0] n92;
  wire [2:0] n93;
  wire [2:0] n95;
  wire n97;
  wire n100;
  wire n103;
  wire [2:0] n105;
  wire n106;
  wire n107;
  wire n108;
  wire n109;
  wire n110;
  wire [1:0] n112;
  wire n113;
  wire n116;
  wire n118;
  wire n121;
  wire n122;
  wire n123;
  wire [1:0] n124;
  wire n126;
  wire n128;
  wire n130;
  wire n132;
  wire n134;
  wire n136;
  wire [2:0] n138;
  wire [1:0] n140;
  wire n141;
  wire n142;
  wire n143;
  wire n144;
  wire n145;
  wire n146;
  wire [2:0] n147;
  wire [1:0] n149;
  wire [3:0] n161;
  wire [3:0] n162;
  wire [3:0] n163;
  wire [3:0] n164;
  wire [3:0] n165;
  wire [3:0] n166;
  wire [3:0] n167;
  wire [3:0] n168;
  wire [3:0] n169;
  wire [3:0] n170;
  wire [3:0] n171;
  wire [3:0] n172;
  wire [3:0] n173;
  wire [3:0] n174;
  wire [3:0] n175;
  wire [3:0] n176;
  wire [3:0] n177;
  wire [3:0] n178;
  wire [3:0] n179;
  wire [3:0] n180;
  wire [3:0] n181;
  wire [3:0] n182;
  wire [3:0] n183;
  wire [3:0] n184;
  wire [3:0] n185;
  wire [3:0] n186;
  wire [3:0] n187;
  wire [3:0] n188;
  wire [3:0] n189;
  wire [3:0] n190;
  wire [3:0] n191;
  wire [3:0] n192;
  reg [2:0] write_registers_sq1_trigger_cnt;
  reg [2:0] write_registers_sq2_trigger_cnt;
  reg [2:0] write_registers_noi_trigger_cnt;
  reg [1:0] write_registers_wav_trigger_cnt;
  wire [2:0] n201;
  wire n202;
  wire [2:0] n203;
  wire [1:0] n204;
  wire [6:0] n205;
  wire [3:0] n206;
  wire n207;
  wire [2:0] n208;
  wire [10:0] n209;
  wire n210;
  wire n211;
  wire [1:0] n212;
  wire [6:0] n213;
  wire [3:0] n214;
  wire n215;
  wire [2:0] n216;
  wire [10:0] n217;
  wire n218;
  wire n219;
  wire n220;
  wire [1:0] n221;
  wire [10:0] n222;
  wire n223;
  wire n224;
  wire [6:0] n225;
  wire [3:0] n226;
  wire n227;
  wire [2:0] n228;
  wire [3:0] n229;
  wire n230;
  wire [2:0] n231;
  wire n232;
  wire n233;
  wire [7:0] n234;
  wire [7:0] n235;
  wire [3:0] n236;
  wire [3:0] n237;
  wire [3:0] n238;
  wire [3:0] n239;
  wire [3:0] n240;
  wire [3:0] n241;
  wire [3:0] n242;
  wire [3:0] n243;
  wire [3:0] n244;
  wire [3:0] n245;
  wire [3:0] n246;
  wire [3:0] n247;
  wire [3:0] n248;
  wire [3:0] n249;
  wire [3:0] n250;
  wire [3:0] n251;
  wire [3:0] n252;
  wire [3:0] n253;
  wire [3:0] n254;
  wire [3:0] n255;
  wire [3:0] n256;
  wire [3:0] n257;
  wire [3:0] n258;
  wire [3:0] n259;
  wire [3:0] n260;
  wire [3:0] n261;
  wire [3:0] n262;
  wire [3:0] n263;
  wire [3:0] n264;
  wire [3:0] n265;
  wire [3:0] n266;
  wire [3:0] n267;
  wire [3:0] n268;
  wire [3:0] n269;
  wire [3:0] n270;
  wire [3:0] n271;
  wire [3:0] n272;
  wire [3:0] n273;
  wire [3:0] n274;
  wire [3:0] n275;
  wire [3:0] n276;
  wire [3:0] n277;
  wire [3:0] n278;
  wire [3:0] n279;
  wire [3:0] n280;
  wire [3:0] n281;
  wire [3:0] n282;
  wire [3:0] n283;
  wire [3:0] n284;
  wire [3:0] n285;
  wire [3:0] n286;
  wire [3:0] n287;
  wire [3:0] n288;
  wire [3:0] n289;
  wire [3:0] n290;
  wire [3:0] n291;
  wire [3:0] n292;
  wire [3:0] n293;
  wire [3:0] n294;
  wire [3:0] n295;
  wire [3:0] n296;
  wire [3:0] n297;
  wire [3:0] n298;
  wire [3:0] n299;
  wire [127:0] n300;
  wire [127:0] n301;
  wire [127:0] n302;
  wire n303;
  wire n305;
  wire [2:0] n307;
  wire n309;
  wire [2:0] n310;
  wire n312;
  wire [2:0] n314;
  wire n316;
  wire [2:0] n317;
  wire n319;
  wire [1:0] n321;
  wire n323;
  wire [1:0] n324;
  wire n326;
  wire [2:0] n328;
  wire n330;
  wire [2:0] n331;
  wire n332;
  wire n333;
  wire n334;
  wire n335;
  wire [2:0] n336;
  wire [2:0] n337;
  wire [2:0] n338;
  wire [1:0] n339;
  wire [10:0] n340;
  wire n341;
  wire n342;
  wire n344;
  wire n345;
  wire [1:0] n346;
  wire n348;
  wire n349;
  wire n350;
  wire n352;
  wire n354;
  wire n355;
  wire n357;
  wire n358;
  wire n360;
  wire n361;
  wire n362;
  wire n363;
  wire n364;
  wire [2:0] n365;
  wire n366;
  wire n367;
  wire n370;
  wire n371;
  wire [2:0] n372;
  wire n374;
  wire [1:0] n375;
  wire [1:0] n376;
  wire [5:0] n377;
  wire [6:0] n379;
  wire [6:0] n380;
  wire n382;
  wire [3:0] n383;
  wire n384;
  wire [2:0] n385;
  wire n387;
  wire n389;
  wire n390;
  wire n391;
  wire [2:0] n394;
  wire [2:0] n395;
  wire n396;
  wire n397;
  wire n398;
  wire n399;
  wire n402;
  wire n403;
  wire [2:0] n404;
  wire n406;
  wire [1:0] n407;
  wire [1:0] n408;
  wire [5:0] n409;
  wire [6:0] n411;
  wire [6:0] n412;
  wire n414;
  wire [3:0] n415;
  wire n416;
  wire [2:0] n417;
  wire n419;
  wire n421;
  wire n422;
  wire n423;
  wire [2:0] n426;
  wire [2:0] n427;
  wire n428;
  wire n429;
  wire n430;
  wire n431;
  wire n434;
  wire n435;
  wire [2:0] n436;
  wire n438;
  wire n439;
  wire n441;
  wire [8:0] n443;
  wire [8:0] n444;
  wire n446;
  wire [1:0] n447;
  wire n449;
  wire n451;
  wire n452;
  wire n453;
  wire [1:0] n455;
  wire n456;
  wire n457;
  wire n458;
  wire n459;
  wire n462;
  wire n463;
  wire [2:0] n464;
  wire n466;
  wire [5:0] n467;
  wire [6:0] n469;
  wire [6:0] n470;
  wire n472;
  wire [3:0] n473;
  wire n474;
  wire [2:0] n475;
  wire n477;
  wire [3:0] n478;
  wire n479;
  wire [2:0] n480;
  wire n482;
  wire n483;
  wire n484;
  wire n485;
  wire [2:0] n488;
  wire [2:0] n489;
  wire n490;
  wire n491;
  wire n492;
  wire n493;
  wire n496;
  wire n497;
  wire n499;
  wire n501;
  wire n503;
  wire n504;
  wire n505;
  wire n506;
  wire [6:0] n508;
  wire [6:0] n510;
  wire [8:0] n512;
  wire [6:0] n514;
  wire [2:0] n516;
  wire n518;
  wire [2:0] n520;
  wire [1:0] n522;
  wire n523;
  wire [3:0] n525;
  wire n527;
  wire [2:0] n529;
  wire [10:0] n531;
  wire n533;
  wire n535;
  wire [1:0] n537;
  wire n538;
  wire [3:0] n540;
  wire n542;
  wire [2:0] n544;
  wire [10:0] n546;
  wire n548;
  wire n550;
  wire n552;
  wire n553;
  wire [1:0] n555;
  wire [10:0] n557;
  wire n559;
  wire n561;
  wire n562;
  wire [3:0] n564;
  wire n566;
  wire [2:0] n568;
  wire [3:0] n570;
  wire n572;
  wire [2:0] n574;
  wire n576;
  wire n578;
  wire [7:0] n580;
  wire [7:0] n582;
  wire n584;
  wire [2:0] n586;
  wire [2:0] n588;
  wire [2:0] n590;
  wire [1:0] n592;
  wire n594;
  wire [3:0] n595;
  wire [3:0] n596;
  wire [3:0] n597;
  wire n599;
  wire n600;
  wire n601;
  wire n602;
  wire [4:0] n604;
  wire [4:0] n607;
  wire [3:0] n609;
  wire [31:0] n611;
  wire [31:0] n613;
  wire [4:0] n614;
  wire [4:0] n616;
  wire [3:0] n618;
  wire [127:0] n620;
  wire n623;
  wire n625;
  wire n626;
  wire n628;
  wire n629;
  wire n631;
  wire n632;
  wire n634;
  wire n635;
  wire n637;
  wire n638;
  wire n640;
  wire n641;
  wire n643;
  wire n644;
  wire n646;
  wire n647;
  wire n649;
  wire n650;
  wire n652;
  wire n653;
  wire n655;
  wire n656;
  wire n658;
  wire n659;
  wire n661;
  wire n662;
  wire n664;
  wire n665;
  wire n667;
  wire n668;
  wire [21:0] n669;
  reg n670;
  reg [2:0] n671;
  reg n672;
  reg n674;
  reg [2:0] n675;
  reg [1:0] n676;
  reg [6:0] n677;
  reg [3:0] n678;
  reg n679;
  reg n680;
  reg [2:0] n681;
  reg [2:0] n682;
  wire [7:0] n683;
  wire [7:0] n684;
  reg [7:0] n685;
  wire [2:0] n686;
  wire [2:0] n687;
  reg [2:0] n688;
  reg n689;
  reg n690;
  reg n693;
  reg n696;
  reg n698;
  reg [1:0] n699;
  reg [6:0] n700;
  reg [3:0] n701;
  reg n704;
  reg n707;
  reg n709;
  reg n710;
  reg [2:0] n711;
  reg n712;
  reg [2:0] n713;
  wire [7:0] n714;
  wire [7:0] n715;
  reg [7:0] n716;
  wire [2:0] n717;
  wire [2:0] n718;
  reg [2:0] n719;
  reg n720;
  reg n721;
  reg n722;
  reg [8:0] n723;
  reg n726;
  reg n728;
  reg [1:0] n729;
  wire [7:0] n730;
  wire [7:0] n731;
  reg [7:0] n732;
  wire [2:0] n733;
  wire [2:0] n734;
  reg [2:0] n735;
  reg n736;
  reg n737;
  reg [127:0] n738;
  reg [6:0] n739;
  reg n742;
  reg n744;
  reg [3:0] n745;
  reg n748;
  reg n749;
  reg [2:0] n750;
  reg n751;
  reg [2:0] n752;
  reg [3:0] n753;
  reg n756;
  reg n757;
  reg [2:0] n758;
  reg n759;
  reg n760;
  reg [7:0] n761;
  reg [7:0] n762;
  reg n763;
  reg [2:0] n764;
  reg [2:0] n765;
  reg [2:0] n766;
  reg [1:0] n767;
  wire n770;
  wire [2:0] n771;
  wire n772;
  wire n774;
  wire [2:0] n776;
  wire [1:0] n777;
  wire [6:0] n778;
  wire [3:0] n779;
  wire n780;
  wire n781;
  wire [2:0] n782;
  wire [2:0] n783;
  wire [10:0] n784;
  wire [10:0] n785;
  wire n786;
  wire n787;
  wire n789;
  wire n792;
  wire n795;
  wire [1:0] n797;
  wire [6:0] n798;
  wire [3:0] n799;
  wire n801;
  wire n804;
  wire n807;
  wire n809;
  wire [2:0] n810;
  wire n811;
  wire [2:0] n812;
  wire [10:0] n813;
  wire [10:0] n814;
  wire n815;
  wire n816;
  wire n817;
  wire [8:0] n818;
  wire n820;
  wire n823;
  wire [1:0] n825;
  wire [10:0] n826;
  wire [10:0] n827;
  wire n828;
  wire n829;
  wire [127:0] n830;
  wire [6:0] n831;
  wire n833;
  wire n836;
  wire [3:0] n838;
  wire n840;
  wire n842;
  wire [2:0] n843;
  wire n844;
  wire [2:0] n845;
  wire [3:0] n846;
  wire n848;
  wire n850;
  wire [2:0] n851;
  wire n852;
  wire n853;
  wire [7:0] n854;
  wire [7:0] n855;
  wire n856;
  wire [2:0] n857;
  wire [2:0] n858;
  wire [2:0] n859;
  wire [1:0] n860;
  wire n863;
  wire n864;
  wire n865;
  wire n866;
  wire n867;
  wire n868;
  wire n869;
  wire n870;
  wire n871;
  wire n872;
  wire n873;
  wire n874;
  wire [10:0] n875;
  wire n876;
  wire n877;
  wire n878;
  wire n879;
  wire n880;
  wire n881;
  wire n882;
  wire n883;
  wire n884;
  wire n885;
  wire n886;
  wire n887;
  wire n888;
  wire n889;
  wire n890;
  wire n891;
  wire n892;
  wire n893;
  wire n894;
  wire n895;
  wire n896;
  wire n897;
  wire n898;
  wire n899;
  wire n900;
  wire n901;
  wire n902;
  wire n903;
  wire n904;
  wire n905;
  wire n906;
  wire n907;
  wire n908;
  wire n909;
  wire n910;
  wire n911;
  wire n912;
  wire n913;
  wire n914;
  wire n915;
  wire n916;
  wire n917;
  wire n918;
  wire n919;
  wire n920;
  wire [2:0] n921;
  wire [2:0] n922;
  wire [2:0] n923;
  wire [1:0] n924;
  wire n927;
  wire [2:0] n928;
  wire n929;
  wire n930;
  wire [2:0] n931;
  wire [1:0] n932;
  wire [6:0] n933;
  wire [3:0] n934;
  wire n935;
  wire n936;
  wire [2:0] n937;
  wire [2:0] n938;
  wire [10:0] n939;
  wire n940;
  wire n941;
  wire n942;
  wire n943;
  wire n944;
  wire [1:0] n945;
  wire [6:0] n946;
  wire [3:0] n947;
  wire n948;
  wire n949;
  wire n950;
  wire n951;
  wire [2:0] n952;
  wire n953;
  wire [2:0] n954;
  wire [10:0] n955;
  wire n956;
  wire n957;
  wire n958;
  wire [8:0] n959;
  wire n960;
  wire n961;
  wire [1:0] n962;
  wire [10:0] n963;
  wire n964;
  wire n965;
  wire [127:0] n966;
  wire [6:0] n967;
  wire n968;
  wire n969;
  wire [3:0] n970;
  wire n971;
  wire n972;
  wire [2:0] n973;
  wire n974;
  wire [2:0] n975;
  wire [3:0] n976;
  wire n977;
  wire n978;
  wire [2:0] n979;
  wire n980;
  wire n981;
  wire [7:0] n982;
  wire [7:0] n983;
  wire n985;
  wire [2:0] n987;
  wire [2:0] n989;
  wire [2:0] n991;
  wire [1:0] n993;
  wire [3:0] n1065;
  wire [4:0] n1066;
  wire [7:0] n1067;
  wire n1069;
  wire [7:0] n1071;
  wire n1073;
  wire [4:0] n1074;
  wire [7:0] n1075;
  wire n1077;
  wire n1079;
  wire [1:0] n1081;
  wire [7:0] n1083;
  wire n1085;
  wire [7:0] n1087;
  wire n1089;
  wire [4:0] n1090;
  wire [7:0] n1091;
  wire n1093;
  wire n1095;
  wire [1:0] n1097;
  wire [7:0] n1099;
  wire n1101;
  wire [7:0] n1103;
  wire n1105;
  wire n1107;
  wire [2:0] n1109;
  wire [7:0] n1111;
  wire n1113;
  wire n1115;
  wire [1:0] n1117;
  wire [7:0] n1119;
  wire n1121;
  wire n1123;
  wire [4:0] n1124;
  wire [7:0] n1125;
  wire n1127;
  wire [4:0] n1128;
  wire [7:0] n1129;
  wire n1131;
  wire [1:0] n1133;
  wire [7:0] n1135;
  wire n1137;
  wire [3:0] n1138;
  wire [3:0] n1139;
  wire [3:0] n1140;
  wire n1142;
  wire n1143;
  wire n1144;
  wire n1145;
  wire [4:0] n1147;
  wire [4:0] n1150;
  wire [31:0] n1153;
  wire [31:0] n1155;
  wire [4:0] n1156;
  wire [4:0] n1158;
  wire [7:0] n1161;
  wire [7:0] n1163;
  wire n1166;
  wire n1168;
  wire n1169;
  wire n1171;
  wire n1172;
  wire n1174;
  wire n1175;
  wire n1177;
  wire n1178;
  wire n1180;
  wire n1181;
  wire n1183;
  wire n1184;
  wire n1186;
  wire n1187;
  wire n1189;
  wire n1190;
  wire n1192;
  wire n1193;
  wire n1195;
  wire n1196;
  wire n1198;
  wire n1199;
  wire n1201;
  wire n1202;
  wire n1204;
  wire n1205;
  wire n1207;
  wire n1208;
  wire n1210;
  wire n1211;
  wire n1213;
  wire n1215;
  wire [3:0] n1217;
  wire [4:0] n1218;
  wire [5:0] n1219;
  wire [6:0] n1220;
  wire [7:0] n1221;
  wire n1223;
  wire [3:0] n1225;
  localparam [7:0] n1226 = 8'b00000000;
  wire [3:0] n1227;
  wire [3:0] n1228;
  wire [7:0] n1229;
  wire [7:0] n1231;
  wire n1233;
  wire [3:0] n1235;
  localparam [7:0] n1236 = 8'b00000000;
  wire [3:0] n1237;
  wire [3:0] n1238;
  wire [7:0] n1239;
  wire [7:0] n1241;
  wire n1243;
  wire [23:0] n1244;
  reg [7:0] n1251;
  reg [10:0] square1_sq1_fcnt;
  reg [2:0] square1_sq1_phase;
  reg [6:0] square1_sq1_len;
  reg [3:0] square1_sq1_envcnt;
  reg [3:0] square1_sq1_swcnt;
  reg [11:0] square1_sq1_swfr;
  reg square1_sq1_sweep_en;
  reg square1_sweep_calculate;
  reg square1_sweep_update;
  reg square1_sweep_negate;
  reg [1:0] square1_sq1_sduty;
  reg [10:0] square1_sq1_trigger_freq;
  wire [4:0] n1271;
  wire n1273;
  wire n1276;
  wire n1278;
  wire n1279;
  wire [3:0] n1281;
  wire n1283;
  wire [10:0] n1284;
  wire [3:0] n1285;
  wire [6:0] n1286;
  wire [11:0] n1288;
  wire [11:0] n1290;
  wire n1291;
  wire [31:0] n1292;
  wire n1294;
  wire [31:0] n1295;
  wire [31:0] n1297;
  wire [2:0] n1298;
  wire [2:0] n1300;
  wire [10:0] n1301;
  wire n1303;
  wire [10:0] n1304;
  wire [2:0] n1305;
  wire [1:0] n1306;
  wire n1307;
  wire [10:0] n1308;
  wire n1309;
  wire n1310;
  wire n1318;
  wire n1325;
  wire n1332;
  wire n1339;
  wire [3:0] n1340;
  reg n1341;
  wire n1342;
  wire n1343;
  wire n1344;
  wire [2:0] n1345;
  wire [1:0] n1346;
  wire n1348;
  wire n1350;
  wire n1351;
  wire [6:0] n1353;
  wire [6:0] n1354;
  wire n1355;
  wire [3:0] n1357;
  wire n1359;
  wire n1361;
  wire [3:0] n1363;
  wire [3:0] n1365;
  wire n1367;
  wire n1368;
  wire n1370;
  wire n1372;
  wire [3:0] n1373;
  wire n1374;
  wire n1375;
  wire [3:0] n1376;
  wire n1377;
  wire n1378;
  wire [11:0] n1380;
  wire n1382;
  wire [9:0] n1383;
  wire [11:0] n1385;
  wire n1387;
  wire [8:0] n1388;
  wire [11:0] n1390;
  wire n1392;
  wire [7:0] n1393;
  wire [11:0] n1395;
  wire n1397;
  wire [6:0] n1398;
  wire [11:0] n1400;
  wire n1402;
  wire [5:0] n1403;
  wire [11:0] n1405;
  wire n1407;
  wire [4:0] n1408;
  wire [11:0] n1410;
  wire n1412;
  wire [3:0] n1413;
  wire [11:0] n1415;
  wire n1417;
  wire [11:0] n1419;
  wire [7:0] n1420;
  reg [11:0] n1421;
  wire [11:0] n1423;
  wire [11:0] n1424;
  wire [11:0] n1426;
  wire [11:0] n1427;
  wire [11:0] n1428;
  wire n1431;
  wire [11:0] n1433;
  wire n1435;
  wire n1436;
  wire n1438;
  wire n1440;
  wire n1441;
  wire [10:0] n1442;
  wire [10:0] n1443;
  wire n1446;
  wire n1448;
  wire n1449;
  wire n1451;
  wire n1452;
  wire n1454;
  wire n1455;
  wire n1457;
  wire [11:0] n1460;
  wire n1461;
  wire n1462;
  wire n1463;
  wire n1465;
  wire n1466;
  wire [3:0] n1468;
  wire n1470;
  wire n1472;
  wire [3:0] n1474;
  wire [3:0] n1475;
  wire n1477;
  wire [3:0] n1479;
  wire [3:0] n1480;
  wire [3:0] n1481;
  wire n1483;
  wire [3:0] n1485;
  wire [3:0] n1487;
  wire [3:0] n1488;
  wire [3:0] n1489;
  wire n1490;
  wire [3:0] n1491;
  wire n1493;
  wire n1494;
  wire n1495;
  wire n1496;
  wire n1497;
  wire n1498;
  wire n1499;
  wire n1500;
  wire n1502;
  wire [3:0] n1504;
  wire [3:0] n1506;
  wire [11:0] n1508;
  wire n1510;
  wire n1511;
  wire n1512;
  wire [3:0] n1513;
  wire n1514;
  wire n1515;
  wire n1516;
  wire n1517;
  wire n1518;
  wire n1519;
  wire n1520;
  wire [7:0] n1522;
  wire [7:0] n1524;
  wire [7:0] n1525;
  wire n1526;
  wire [7:0] n1528;
  wire [7:0] n1529;
  wire n1531;
  wire n1533;
  wire n1534;
  wire n1536;
  wire n1537;
  wire n1538;
  wire n1539;
  wire [7:0] n1541;
  wire [7:0] n1542;
  wire n1544;
  wire n1545;
  wire [7:0] n1547;
  wire [7:0] n1548;
  wire [3:0] n1549;
  wire [4:0] n1550;
  wire n1552;
  wire n1553;
  wire n1554;
  wire n1556;
  wire [3:0] n1557;
  wire n1558;
  wire n1560;
  wire [10:0] n1562;
  wire n1563;
  wire n1564;
  wire [10:0] n1565;
  wire n1566;
  wire n1567;
  wire n1568;
  wire n1570;
  wire n1572;
  wire n1574;
  wire n1575;
  wire n1578;
  wire n1581;
  wire n1583;
  wire n1585;
  wire [3:0] n1587;
  wire [3:0] n1589;
  wire [4:0] n1590;
  wire n1592;
  wire n1593;
  wire n1594;
  wire n1595;
  wire n1597;
  wire n1599;
  wire [3:0] n1601;
  wire [3:0] n1603;
  wire n1605;
  wire n1606;
  wire [6:0] n1609;
  wire [6:0] n1610;
  wire [10:0] n1611;
  wire [3:0] n1612;
  wire n1613;
  wire n1614;
  wire [10:0] n1615;
  wire n1616;
  wire [3:0] n1617;
  wire [3:0] n1618;
  wire n1619;
  wire n1620;
  wire n1622;
  wire [6:0] n1624;
  wire n1626;
  wire [10:0] n1628;
  wire [3:0] n1630;
  wire n1631;
  wire n1633;
  wire n1635;
  wire n1637;
  wire [10:0] n1639;
  wire [2:0] n1641;
  wire [6:0] n1642;
  wire [3:0] n1644;
  wire [3:0] n1646;
  wire [11:0] n1650;
  wire n1652;
  wire n1654;
  wire n1656;
  wire n1658;
  wire [1:0] n1660;
  wire [10:0] n1661;
  wire n1664;
  wire [10:0] n1665;
  wire [3:0] n1666;
  wire n1667;
  wire n1668;
  wire n1669;
  wire n1670;
  wire [10:0] n1671;
  wire [2:0] n1672;
  wire [6:0] n1673;
  wire [3:0] n1674;
  wire [3:0] n1675;
  wire [11:0] n1677;
  wire n1678;
  wire n1679;
  wire n1680;
  wire n1681;
  wire [1:0] n1682;
  wire n1683;
  wire n1687;
  wire [10:0] n1688;
  wire [3:0] n1689;
  wire n1690;
  wire n1691;
  wire n1693;
  wire n1695;
  wire [10:0] n1697;
  wire [2:0] n1699;
  wire [6:0] n1701;
  wire [3:0] n1703;
  wire [3:0] n1705;
  wire [11:0] n1709;
  wire n1711;
  wire n1713;
  wire n1715;
  wire n1717;
  wire [1:0] n1719;
  wire [10:0] n1721;
  reg [10:0] square2_sq2_fcnt;
  reg [2:0] square2_sq2_phase;
  reg [6:0] square2_sq2_len;
  reg [3:0] square2_sq2_envcnt;
  reg [1:0] square2_sq2_sduty;
  reg [10:0] square2_sq2_trigger_freq;
  wire [4:0] n1756;
  wire n1758;
  wire n1761;
  wire n1763;
  wire n1764;
  wire [3:0] n1766;
  wire n1768;
  wire [3:0] n1769;
  wire [6:0] n1770;
  wire [11:0] n1772;
  wire [11:0] n1774;
  wire n1775;
  wire [31:0] n1776;
  wire n1778;
  wire [31:0] n1779;
  wire [31:0] n1781;
  wire [2:0] n1782;
  wire [2:0] n1784;
  wire [10:0] n1785;
  wire n1787;
  wire [10:0] n1788;
  wire [2:0] n1789;
  wire [1:0] n1790;
  wire n1791;
  wire [10:0] n1792;
  wire n1793;
  wire n1794;
  wire n1802;
  wire n1809;
  wire n1816;
  wire n1823;
  wire [3:0] n1824;
  reg n1825;
  wire n1826;
  wire n1827;
  wire n1828;
  wire [2:0] n1829;
  wire [1:0] n1830;
  wire n1832;
  wire n1834;
  wire n1835;
  wire [6:0] n1837;
  wire [6:0] n1838;
  wire n1839;
  wire n1841;
  wire n1842;
  wire [3:0] n1844;
  wire n1846;
  wire n1848;
  wire [3:0] n1850;
  wire [3:0] n1851;
  wire n1853;
  wire [3:0] n1855;
  wire [3:0] n1856;
  wire [3:0] n1857;
  wire n1859;
  wire [3:0] n1861;
  wire [3:0] n1863;
  wire [3:0] n1864;
  wire [3:0] n1865;
  wire n1866;
  wire [3:0] n1867;
  wire n1869;
  wire n1870;
  wire n1872;
  wire [3:0] n1874;
  wire n1875;
  wire n1876;
  wire [3:0] n1877;
  wire n1878;
  wire n1879;
  wire n1880;
  wire n1881;
  wire [7:0] n1883;
  wire [7:0] n1885;
  wire [7:0] n1886;
  wire n1887;
  wire [7:0] n1889;
  wire [7:0] n1890;
  wire n1892;
  wire n1894;
  wire n1895;
  wire n1897;
  wire n1898;
  wire n1899;
  wire n1900;
  wire [7:0] n1902;
  wire [7:0] n1903;
  wire n1905;
  wire n1906;
  wire [7:0] n1908;
  wire [7:0] n1909;
  wire [3:0] n1910;
  wire [4:0] n1911;
  wire n1913;
  wire n1914;
  wire n1915;
  wire n1917;
  wire [3:0] n1918;
  wire n1919;
  wire n1921;
  wire [10:0] n1923;
  wire n1924;
  wire n1925;
  wire [10:0] n1926;
  wire n1927;
  wire n1928;
  wire n1929;
  wire n1931;
  wire [4:0] n1932;
  wire n1934;
  wire n1935;
  wire n1936;
  wire n1937;
  wire n1939;
  wire n1941;
  wire [3:0] n1943;
  wire [3:0] n1945;
  wire n1947;
  wire n1948;
  wire [6:0] n1951;
  wire [6:0] n1952;
  wire [3:0] n1953;
  wire n1954;
  wire n1955;
  wire [10:0] n1956;
  wire n1957;
  wire [3:0] n1958;
  wire [6:0] n1960;
  wire n1962;
  wire [3:0] n1964;
  wire n1966;
  wire n1968;
  wire n1970;
  wire [10:0] n1972;
  wire [2:0] n1974;
  wire [6:0] n1975;
  wire [3:0] n1977;
  wire [1:0] n1979;
  wire [10:0] n1980;
  wire n1983;
  wire [3:0] n1984;
  wire n1985;
  wire n1986;
  wire n1987;
  wire [10:0] n1988;
  wire [2:0] n1989;
  wire [6:0] n1990;
  wire [3:0] n1991;
  wire [1:0] n1992;
  wire n1993;
  wire n1997;
  wire [3:0] n1998;
  wire n1999;
  wire n2001;
  wire n2003;
  wire [10:0] n2005;
  wire [2:0] n2007;
  wire [6:0] n2009;
  wire [3:0] n2011;
  wire [1:0] n2013;
  wire [10:0] n2015;
  reg [10:0] wave_wav_fcnt;
  reg [8:0] wave_wav_len;
  reg wave_wav_shift_r;
  reg [10:0] wave_wav_trigger_freq;
  wire n2039;
  wire n2041;
  wire [2:0] n2042;
  wire [3:0] n2044;
  wire n2046;
  wire [1:0] n2047;
  wire [3:0] n2049;
  wire n2051;
  wire [2:0] n2052;
  reg [3:0] n2054;
  wire [3:0] n2056;
  wire [3:0] n2058;
  wire n2059;
  wire [4:0] n2060;
  wire [1:0] n2061;
  wire [8:0] n2062;
  wire n2064;
  wire [1:0] n2066;
  wire [1:0] n2067;
  wire [11:0] n2069;
  wire [11:0] n2071;
  wire n2072;
  wire [10:0] n2073;
  wire [10:0] n2074;
  wire n2077;
  wire [10:0] n2078;
  wire n2080;
  wire n2082;
  wire n2084;
  wire n2087;
  wire n2088;
  wire n2089;
  wire n2090;
  wire [4:0] n2092;
  wire [4:0] n2094;
  wire [4:0] n2097;
  wire [4:0] n2100;
  wire [1:0] n2102;
  wire [3:0] n2103;
  wire [4:0] n2105;
  wire [1:0] n2106;
  wire [3:0] n2107;
  wire n2109;
  wire n2110;
  wire n2112;
  wire n2113;
  wire [8:0] n2115;
  wire [8:0] n2116;
  wire n2117;
  wire n2119;
  wire n2120;
  wire n2121;
  wire n2122;
  wire n2124;
  wire n2125;
  wire n2126;
  wire n2127;
  wire [10:0] n2128;
  wire n2129;
  wire n2130;
  wire n2132;
  wire n2133;
  wire [8:0] n2136;
  wire [8:0] n2137;
  wire n2139;
  wire [10:0] n2140;
  wire n2141;
  wire [8:0] n2143;
  wire [4:0] n2145;
  wire [1:0] n2147;
  wire n2149;
  wire [3:0] n2151;
  wire n2153;
  wire [10:0] n2155;
  wire [8:0] n2156;
  wire n2158;
  wire [10:0] n2161;
  wire [4:0] n2162;
  wire [1:0] n2163;
  wire n2164;
  wire [3:0] n2165;
  wire n2166;
  wire [10:0] n2167;
  wire [8:0] n2168;
  wire n2169;
  wire n2172;
  wire [4:0] n2173;
  wire [1:0] n2174;
  wire n2175;
  wire [3:0] n2176;
  wire n2178;
  wire [10:0] n2180;
  wire [8:0] n2182;
  wire n2184;
  wire [10:0] n2188;
  reg [19:0] noise_noi_period;
  reg [19:0] noise_noi_fcnt;
  reg [14:0] noise_noi_lfsr;
  reg [6:0] noise_noi_len;
  reg [2:0] noise_noi_envcnt;
  reg noise_noi_out;
  wire [4:0] n2210;
  wire n2212;
  wire n2215;
  wire [3:0] n2218;
  wire n2220;
  wire [3:0] n2221;
  wire [6:0] n2222;
  wire n2223;
  wire [6:0] n2225;
  wire n2226;
  wire n2228;
  wire n2229;
  wire n2230;
  wire n2231;
  wire n2232;
  wire [13:0] n2233;
  wire [14:0] n2234;
  wire n2235;
  wire n2236;
  wire [7:0] n2237;
  wire [5:0] n2238;
  wire [14:0] n2239;
  wire n2240;
  wire [19:0] n2242;
  wire [19:0] n2243;
  wire [14:0] n2244;
  wire [14:0] n2245;
  wire n2246;
  wire [19:0] n2248;
  wire n2249;
  wire n2250;
  wire n2252;
  wire n2253;
  wire n2255;
  wire [6:0] n2257;
  wire [6:0] n2258;
  wire n2259;
  wire n2261;
  wire n2262;
  wire n2264;
  wire n2265;
  wire n2267;
  wire n2268;
  wire [2:0] n2270;
  wire n2272;
  wire n2274;
  wire [3:0] n2276;
  wire [3:0] n2277;
  wire n2279;
  wire [3:0] n2281;
  wire [3:0] n2282;
  wire [3:0] n2283;
  wire [3:0] n2284;
  wire [2:0] n2285;
  wire n2286;
  wire [2:0] n2287;
  wire n2288;
  wire n2289;
  wire n2290;
  wire n2291;
  wire [7:0] n2293;
  wire [7:0] n2295;
  wire [7:0] n2296;
  wire n2297;
  wire [7:0] n2299;
  wire [7:0] n2300;
  wire n2302;
  wire n2304;
  wire n2305;
  wire n2307;
  wire n2308;
  wire n2309;
  wire n2310;
  wire [7:0] n2312;
  wire [7:0] n2313;
  wire n2315;
  wire n2316;
  wire [7:0] n2318;
  wire [7:0] n2319;
  wire [3:0] n2320;
  wire [3:0] n2321;
  wire n2323;
  localparam [19:0] n2324 = 20'b00000000000000000000;
  wire [14:0] n2325;
  wire n2328;
  wire n2330;
  wire n2331;
  wire n2332;
  wire [30:0] n2333;
  wire [31:0] n2334;
  wire [19:0] n2335;
  wire [19:0] n2336;
  wire [19:0] n2337;
  wire [19:0] n2338;
  wire n2339;
  wire n2340;
  wire n2342;
  wire n2343;
  wire [6:0] n2346;
  wire [6:0] n2347;
  wire [3:0] n2348;
  wire n2350;
  wire [14:0] n2352;
  wire n2353;
  wire [2:0] n2354;
  wire [4:0] n2355;
  wire n2357;
  wire n2359;
  wire [3:0] n2361;
  wire n2363;
  wire n2365;
  wire [19:0] n2366;
  wire [19:0] n2368;
  wire [14:0] n2370;
  wire [6:0] n2371;
  wire [2:0] n2373;
  wire n2375;
  wire [3:0] n2378;
  wire n2379;
  wire n2380;
  wire [19:0] n2381;
  wire [19:0] n2382;
  wire [14:0] n2383;
  wire [6:0] n2384;
  wire [2:0] n2385;
  wire n2386;
  wire [3:0] n2389;
  wire n2390;
  wire n2392;
  wire [19:0] n2393;
  wire [19:0] n2395;
  wire [14:0] n2397;
  wire [6:0] n2399;
  wire [2:0] n2401;
  wire n2403;
  wire n2418;
  wire [8:0] sq1_dac_n2419;
  wire n2422;
  wire [8:0] sq2_dac_n2423;
  wire n2426;
  wire [8:0] wav_dac_n2427;
  wire n2430;
  wire [8:0] noi_dac_n2431;
  wire n2439;
  wire [10:0] n2441;
  wire [10:0] n2442;
  wire [10:0] n2444;
  wire n2446;
  wire [10:0] n2448;
  wire [10:0] n2449;
  wire [10:0] n2451;
  wire n2453;
  wire [10:0] n2454;
  wire [10:0] n2455;
  wire [10:0] n2456;
  wire n2457;
  wire [10:0] n2458;
  wire [10:0] n2459;
  wire [10:0] n2460;
  wire n2461;
  wire [10:0] n2462;
  wire [10:0] n2463;
  wire [10:0] n2464;
  wire n2465;
  wire [10:0] n2466;
  wire [10:0] n2467;
  wire [10:0] n2468;
  wire n2469;
  wire [10:0] n2470;
  wire [10:0] n2471;
  wire [10:0] n2472;
  wire n2473;
  wire [10:0] n2474;
  wire [10:0] n2475;
  wire [10:0] n2476;
  wire [2:0] n2477;
  wire [4:0] n2479;
  wire [4:0] n2482;
  wire [15:0] n2483;
  wire [15:0] n2484;
  wire [15:0] n2485;
  wire [15:0] n2487;
  wire [15:0] n2488;
  wire [2:0] n2489;
  wire [4:0] n2491;
  wire [4:0] n2494;
  wire [15:0] n2495;
  wire [15:0] n2496;
  wire [15:0] n2497;
  wire [15:0] n2499;
  wire [15:0] n2500;
  wire [447:0] n2503;
  wire [63:0] n2504;
  wire [54:0] n2505;
  wire [62:0] n2506;
  wire [63:0] n2507;
  wire [63:0] n2508;
  reg n2509;
  reg n2510;
  reg n2511;
  reg n2512;
  reg n2513;
  reg n2514;
  reg n2515;
  reg [2:0] n2516;
  reg n2517;
  reg n2518;
  reg [2:0] n2519;
  reg [1:0] n2520;
  reg [6:0] n2521;
  reg [3:0] n2522;
  reg n2523;
  reg n2524;
  reg n2525;
  reg [2:0] n2526;
  reg [2:0] n2527;
  reg [10:0] n2528;
  reg n2529;
  reg n2530;
  reg [10:0] n2531;
  reg [3:0] n2532;
  reg n2533;
  reg n2534;
  reg n2535;
  reg n2536;
  reg n2537;
  reg n2538;
  reg n2539;
  reg [1:0] n2540;
  reg [6:0] n2541;
  reg [3:0] n2542;
  reg n2543;
  reg n2544;
  reg n2545;
  reg n2546;
  reg [2:0] n2547;
  reg n2548;
  reg [2:0] n2549;
  reg [10:0] n2550;
  reg n2551;
  reg n2552;
  reg [3:0] n2553;
  reg n2554;
  reg n2555;
  reg n2556;
  reg [8:0] n2557;
  reg n2558;
  reg n2559;
  reg [1:0] n2560;
  reg [10:0] n2561;
  reg n2562;
  reg n2563;
  reg [4:0] n2564;
  reg [1:0] n2565;
  reg n2566;
  reg [127:0] n2567;
  reg [3:0] n2568;
  reg [6:0] n2569;
  reg n2570;
  reg n2571;
  reg [3:0] n2572;
  reg n2573;
  reg n2574;
  reg [2:0] n2575;
  reg n2576;
  reg [2:0] n2577;
  reg [3:0] n2578;
  reg n2579;
  reg n2580;
  reg [2:0] n2581;
  reg n2582;
  reg n2583;
  reg [3:0] n2584;
  reg n2585;
  reg [7:0] n2586;
  reg [7:0] n2587;
  reg [2:0] n2588;
  reg n2589;
  reg n2590;
  reg n2591;
  reg n2592;
  reg n2593;
  reg [1:0] n2594;
  reg [2:0] n2595;
  reg [2:0] n2596;
  reg [2:0] n2597;
  reg [1:0] n2598;
  reg [10:0] n2599;
  reg [2:0] n2600;
  reg [6:0] n2601;
  reg [3:0] n2602;
  reg [3:0] n2603;
  reg [11:0] n2604;
  reg n2605;
  reg n2606;
  reg n2607;
  reg n2608;
  reg [1:0] n2609;
  reg [10:0] n2610;
  reg [10:0] n2611;
  reg [2:0] n2612;
  reg [6:0] n2613;
  reg [3:0] n2614;
  reg [1:0] n2615;
  reg [10:0] n2616;
  reg [10:0] n2617;
  reg [8:0] n2618;
  reg n2619;
  reg [10:0] n2620;
  reg [19:0] n2621;
  reg [19:0] n2622;
  reg [14:0] n2623;
  reg [6:0] n2624;
  reg [2:0] n2625;
  reg n2626;
  wire n2629; // mem_rd
  wire n2632; // mem_rd
  wire n2635; // mem_rd
  wire n2638; // mem_rd
  wire n2641; // mem_rd
  wire n2644; // mem_rd
  wire n2647; // mem_rd
  wire n2650; // mem_rd
  wire n2651;
  wire n2652;
  wire n2653;
  wire n2654;
  wire n2655;
  wire n2656;
  wire n2657;
  wire n2658;
  wire n2659;
  wire n2660;
  wire n2661;
  wire n2662;
  wire n2663;
  wire n2664;
  wire n2665;
  wire n2666;
  wire n2667;
  wire n2668;
  wire n2669;
  wire n2670;
  wire n2671;
  wire n2672;
  wire n2673;
  wire n2674;
  wire n2675;
  wire n2676;
  wire n2677;
  wire n2678;
  wire n2679;
  wire n2680;
  wire n2681;
  wire n2682;
  wire n2683;
  wire n2684;
  wire n2685;
  wire n2686;
  wire n2687;
  wire n2688;
  wire n2689;
  wire n2690;
  wire n2691;
  wire n2692;
  wire n2693;
  wire n2694;
  wire n2695;
  wire n2696;
  wire n2697;
  wire n2698;
  wire n2699;
  wire n2700;
  wire n2701;
  wire n2702;
  wire n2703;
  wire n2704;
  wire n2705;
  wire n2706;
  wire n2707;
  wire n2708;
  wire n2709;
  wire n2710;
  wire n2711;
  wire n2712;
  wire n2713;
  wire n2714;
  wire n2715;
  wire n2716;
  wire n2717;
  wire n2718;
  wire n2719;
  wire n2720;
  wire [3:0] n2721;
  wire [3:0] n2722;
  wire [3:0] n2723;
  wire [3:0] n2724;
  wire [3:0] n2725;
  wire [3:0] n2726;
  wire [3:0] n2727;
  wire [3:0] n2728;
  wire [3:0] n2729;
  wire [3:0] n2730;
  wire [3:0] n2731;
  wire [3:0] n2732;
  wire [3:0] n2733;
  wire [3:0] n2734;
  wire [3:0] n2735;
  wire [3:0] n2736;
  wire [3:0] n2737;
  wire [3:0] n2738;
  wire [3:0] n2739;
  wire [3:0] n2740;
  wire [3:0] n2741;
  wire [3:0] n2742;
  wire [3:0] n2743;
  wire [3:0] n2744;
  wire [3:0] n2745;
  wire [3:0] n2746;
  wire [3:0] n2747;
  wire [3:0] n2748;
  wire [3:0] n2749;
  wire [3:0] n2750;
  wire [3:0] n2751;
  wire [3:0] n2752;
  wire [3:0] n2753;
  wire [3:0] n2754;
  wire [3:0] n2755;
  wire [3:0] n2756;
  wire [3:0] n2757;
  wire [3:0] n2758;
  wire [3:0] n2759;
  wire [3:0] n2760;
  wire [3:0] n2761;
  wire [3:0] n2762;
  wire [3:0] n2763;
  wire [3:0] n2764;
  wire [3:0] n2765;
  wire [3:0] n2766;
  wire [3:0] n2767;
  wire [3:0] n2768;
  wire [3:0] n2769;
  wire [3:0] n2770;
  wire [3:0] n2771;
  wire [3:0] n2772;
  wire [3:0] n2773;
  wire [3:0] n2774;
  wire [3:0] n2775;
  wire [3:0] n2776;
  wire [3:0] n2777;
  wire [3:0] n2778;
  wire [3:0] n2779;
  wire [3:0] n2780;
  wire [3:0] n2781;
  wire [3:0] n2782;
  wire [3:0] n2783;
  wire [3:0] n2784;
  wire [127:0] n2785;
  wire n2786;
  wire n2787;
  wire n2788;
  wire n2789;
  wire n2790;
  wire n2791;
  wire n2792;
  wire n2793;
  wire n2794;
  wire n2795;
  wire n2796;
  wire n2797;
  wire n2798;
  wire n2799;
  wire n2800;
  wire n2801;
  wire n2802;
  wire n2803;
  wire n2804;
  wire n2805;
  wire n2806;
  wire n2807;
  wire n2808;
  wire n2809;
  wire n2810;
  wire n2811;
  wire n2812;
  wire n2813;
  wire n2814;
  wire n2815;
  wire n2816;
  wire n2817;
  wire n2818;
  wire n2819;
  wire n2820;
  wire n2821;
  wire n2822;
  wire n2823;
  wire n2824;
  wire n2825;
  wire n2826;
  wire n2827;
  wire n2828;
  wire n2829;
  wire n2830;
  wire n2831;
  wire n2832;
  wire n2833;
  wire n2834;
  wire n2835;
  wire n2836;
  wire n2837;
  wire n2838;
  wire n2839;
  wire n2840;
  wire n2841;
  wire n2842;
  wire n2843;
  wire n2844;
  wire n2845;
  wire n2846;
  wire n2847;
  wire n2848;
  wire n2849;
  wire n2850;
  wire n2851;
  wire n2852;
  wire n2853;
  wire n2854;
  wire n2855;
  wire [3:0] n2856;
  wire [3:0] n2857;
  wire [3:0] n2858;
  wire [3:0] n2859;
  wire [3:0] n2860;
  wire [3:0] n2861;
  wire [3:0] n2862;
  wire [3:0] n2863;
  wire [3:0] n2864;
  wire [3:0] n2865;
  wire [3:0] n2866;
  wire [3:0] n2867;
  wire [3:0] n2868;
  wire [3:0] n2869;
  wire [3:0] n2870;
  wire [3:0] n2871;
  wire [3:0] n2872;
  wire [3:0] n2873;
  wire [3:0] n2874;
  wire [3:0] n2875;
  wire [3:0] n2876;
  wire [3:0] n2877;
  wire [3:0] n2878;
  wire [3:0] n2879;
  wire [3:0] n2880;
  wire [3:0] n2881;
  wire [3:0] n2882;
  wire [3:0] n2883;
  wire [3:0] n2884;
  wire [3:0] n2885;
  wire [3:0] n2886;
  wire [3:0] n2887;
  wire [3:0] n2888;
  wire [3:0] n2889;
  wire [3:0] n2890;
  wire [3:0] n2891;
  wire [3:0] n2892;
  wire [3:0] n2893;
  wire [3:0] n2894;
  wire [3:0] n2895;
  wire [3:0] n2896;
  wire [3:0] n2897;
  wire [3:0] n2898;
  wire [3:0] n2899;
  wire [3:0] n2900;
  wire [3:0] n2901;
  wire [3:0] n2902;
  wire [3:0] n2903;
  wire [3:0] n2904;
  wire [3:0] n2905;
  wire [3:0] n2906;
  wire [3:0] n2907;
  wire [3:0] n2908;
  wire [3:0] n2909;
  wire [3:0] n2910;
  wire [3:0] n2911;
  wire [3:0] n2912;
  wire [3:0] n2913;
  wire [3:0] n2914;
  wire [3:0] n2915;
  wire [3:0] n2916;
  wire [3:0] n2917;
  wire [3:0] n2918;
  wire [3:0] n2919;
  wire [127:0] n2920;
  wire [3:0] n2921;
  wire [3:0] n2922;
  wire [3:0] n2923;
  assign s1_readdata = n1251; //(module output)
  assign snd_left = n2500; //(module output)
  assign snd_right = n2488; //(module output)
  assign SaveStateBus_Dout = n34; //(module output)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:55:12 */
  assign en_snd2 = n36; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:56:12 */
  assign en_snd4 = n37; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:58:12 */
  assign en_snden2 = n2509; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:59:12 */
  assign en_snden4 = n2510; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:61:12 */
  assign en_len = n2511; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:62:12 */
  assign en_len_r = n2512; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:63:12 */
  assign en_env = n2513; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:64:12 */
  assign en_sweep = n2514; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:66:12 */
  assign snd_enable = n2515; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:68:12 */
  assign sq1_swper = n2516; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:69:12 */
  assign sq1_swdir = n2517; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:70:12 */
  assign sq1_swdir_change = n2518; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:71:12 */
  assign sq1_swshift = n2519; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:72:12 */
  assign sq1_duty = n2520; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:73:12 */
  assign sq1_slen = n2521; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:74:12 */
  assign sq1_svol = n2522; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:76:12 */
  assign sq1_out = n2523; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:78:12 */
  assign sq1_envsgn = n2524; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:79:12 */
  assign sq1_envsgn_old = n2525; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:80:12 */
  assign sq1_envper = n2526; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:81:12 */
  assign sq1_envper_old = n2527; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:82:12 */
  assign sq1_freq = n2528; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:83:12 */
  assign sq1_trigger = n2529; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:84:12 */
  assign sq1_lenchk = n2530; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:87:12 */
  assign sq1_fr2 = n2531; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:88:12 */
  assign sq1_vol = n2532; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:89:12 */
  assign sq1_nr2change = n2533; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:90:12 */
  assign sq1_lenchange = n2534; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:91:12 */
  assign sq1_lenquirk = n2535; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:92:12 */
  assign sq1_freqchange = n2536; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:94:12 */
  assign sq1_playing = n2537; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:95:12 */
  assign sq1_wav = n1281; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:96:12 */
  assign sq1_suppressed = n2538; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:98:12 */
  assign sq2_out = n2539; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:100:12 */
  assign sq2_duty = n2540; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:101:12 */
  assign sq2_slen = n2541; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:102:12 */
  assign sq2_svol = n2542; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:103:12 */
  assign sq2_nr2change = n2543; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:104:12 */
  assign sq2_lenchange = n2544; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:105:12 */
  assign sq2_lenquirk = n2545; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:106:12 */
  assign sq2_envsgn = n2546; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:107:12 */
  assign sq2_envper = n2547; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:108:12 */
  assign sq2_envsgn_old = n2548; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:109:12 */
  assign sq2_envper_old = n2549; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:110:12 */
  assign sq2_freq = n2550; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:111:12 */
  assign sq2_trigger = n2551; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:112:12 */
  assign sq2_lenchk = n2552; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:114:12 */
  assign sq2_vol = n2553; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:115:12 */
  assign sq2_playing = n2554; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:116:12 */
  assign sq2_wav = n1766; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:117:12 */
  assign sq2_suppressed = n2555; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:119:12 */
  assign wav_enable = n2556; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:120:12 */
  assign wav_slen = n2557; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:121:12 */
  assign wav_lenchange = n2558; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:122:12 */
  assign wav_lenquirk = n2559; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:123:12 */
  assign wav_volsh = n2560; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:124:12 */
  assign wav_freq = n2561; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:125:12 */
  assign wav_trigger = n2562; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:126:12 */
  assign wav_lenchk = n2563; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:127:12 */
  assign wav_index = n2564; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:128:12 */
  assign wav_access = n2565; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:129:12 */
  assign wav_playing = n2566; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:130:12 */
  assign wav_wav = n2056; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:131:12 */
  assign wav_ram = n2567; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:132:12 */
  assign wav_wav_r = n2568; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:134:12 */
  assign noi_slen = n2569; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:135:12 */
  assign noi_lenchange = n2570; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:136:12 */
  assign noi_lenquirk = n2571; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:137:12 */
  assign noi_svol = n2572; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:138:12 */
  assign noi_nr2change = n2573; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:139:12 */
  assign noi_envsgn = n2574; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:140:12 */
  assign noi_envper = n2575; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:141:12 */
  assign noi_envsgn_old = n2576; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:142:12 */
  assign noi_envper_old = n2577; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:143:12 */
  assign noi_freqsh = n2578; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:144:12 */
  assign noi_freqchange = n2579; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:145:12 */
  assign noi_short = n2580; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:146:12 */
  assign noi_div = n2581; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:147:12 */
  assign noi_trigger = n2582; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:148:12 */
  assign noi_lenchk = n2583; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:150:12 */
  assign noi_vol = n2584; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:151:12 */
  assign noi_playing = n2585; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:152:12 */
  assign noi_wav = n2218; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:154:12 */
  assign ch_map = n2586; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:155:12 */
  assign ch_vol = n2587; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:156:12 */
  always @*
    framecnt = n2588; // (isignal)
  initial
    framecnt = 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:158:12 */
  assign sq1_trigger_r = n2589; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:159:12 */
  assign sq2_trigger_r = n2590; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:160:12 */
  assign wav_trigger_r = n2591; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:161:12 */
  assign noi_trigger_r = n2592; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:162:12 */
  assign s1_write_r = n2593; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:166:12 */
  assign reg_wired_or = n2503; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:169:12 */
  assign ss_sound1_back = n2504; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:171:12 */
  assign ss_sound2_back = n2505; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:173:12 */
  assign ss_sound3_back = n2506; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:176:12 */
  assign ss_wave1_back = n2507; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:178:12 */
  assign ss_wave2_back = n2508; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:184:16 */
  assign sq1_dac_en = n1276; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:185:16 */
  assign sq2_dac_en = n1761; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:187:16 */
  assign noi_dac_en = n2215; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:189:16 */
  assign sq1_dac_out = sq1_dac_n2419; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:190:16 */
  assign sq2_dac_out = sq2_dac_n2423; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:191:16 */
  assign wav_dac_out = wav_dac_n2427; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:192:16 */
  assign noi_dac_out = noi_dac_n2431; // (signal)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:196:4 */
  ereg_savestate_Barch_0_424347de9c0cdc6ce5cf6cbd4fe64dcf1f51e87c ireg_savestate_sound1 (
    .clk(clk),
    .bus_din(SaveStateBus_Din),
    .bus_adr(SaveStateBus_Adr),
    .bus_wren(SaveStateBus_wren),
    .bus_rst(SaveStateBus_rst),
    .din(ss_sound1_back),
    .bus_dout(\ireg_savestate_sound1.bus_dout ),
    .dout(ss_sound1));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:197:4 */
  ereg_savestate_Barch_0_a95deab68965e2f133920ceea7156bf77acd65ac ireg_savestate_sound2 (
    .clk(clk),
    .bus_din(SaveStateBus_Din),
    .bus_adr(SaveStateBus_Adr),
    .bus_wren(SaveStateBus_wren),
    .bus_rst(SaveStateBus_rst),
    .din(ss_sound2_back),
    .bus_dout(\ireg_savestate_sound2.bus_dout ),
    .dout(ss_sound2));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:198:4 */
  ereg_savestate_Barch_0_ade93475e281eb6d3855f121ed91338fdf98769f ireg_savestate_sound3 (
    .clk(clk),
    .bus_din(SaveStateBus_Din),
    .bus_adr(SaveStateBus_Adr),
    .bus_wren(SaveStateBus_wren),
    .bus_rst(SaveStateBus_rst),
    .din(ss_sound3_back),
    .bus_dout(\ireg_savestate_sound3.bus_dout ),
    .dout(ss_sound3));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:200:4 */
  ereg_savestate_Barch_0_064cc145e4df328cf2334547b447688a1ad7096d ireg_savestate_wave1 (
    .clk(clk),
    .bus_din(SaveStateBus_Din),
    .bus_adr(SaveStateBus_Adr),
    .bus_wren(SaveStateBus_wren),
    .bus_rst(SaveStateBus_rst),
    .din(ss_wave1_back),
    .bus_dout(\ireg_savestate_wave1.bus_dout ),
    .dout(ss_wave1));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:201:4 */
  ereg_savestate_Barch_0_5368d06e7557ca14ab5ed84d83875d7beccb6f6c ireg_savestate_wave2 (
    .clk(clk),
    .bus_din(SaveStateBus_Din),
    .bus_adr(SaveStateBus_Adr),
    .bus_wren(SaveStateBus_wren),
    .bus_rst(SaveStateBus_rst),
    .din(ss_wave2_back),
    .bus_dout(\ireg_savestate_wave2.bus_dout ),
    .dout(ss_wave2));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:202:4 */
  ereg_savestate_Barch_0_064cc145e4df328cf2334547b447688a1ad7096d ireg_savestate_wave1_gbc (
    .clk(clk),
    .bus_din(SaveStateBus_Din),
    .bus_adr(SaveStateBus_Adr),
    .bus_wren(SaveStateBus_wren),
    .bus_rst(SaveStateBus_rst),
    .din(ss_wave1_back),
    .bus_dout(\ireg_savestate_wave1_gbc.bus_dout ),
    .dout(ss_wave1_gbc));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:203:4 */
  ereg_savestate_Barch_0_5368d06e7557ca14ab5ed84d83875d7beccb6f6c ireg_savestate_wave2_gbc (
    .clk(clk),
    .bus_din(SaveStateBus_Din),
    .bus_adr(SaveStateBus_Adr),
    .bus_wren(SaveStateBus_wren),
    .bus_rst(SaveStateBus_rst),
    .din(ss_wave2_back),
    .bus_dout(\ireg_savestate_wave2_gbc.bus_dout ),
    .dout(ss_wave2_gbc));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:209:41 */
  assign n22 = reg_wired_or[447:384]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:61 */
  assign n23 = reg_wired_or[383:320]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:46 */
  assign n24 = n22 | n23;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:61 */
  assign n25 = reg_wired_or[319:256]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:46 */
  assign n26 = n24 | n25;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:61 */
  assign n27 = reg_wired_or[255:192]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:46 */
  assign n28 = n26 | n27;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:61 */
  assign n29 = reg_wired_or[191:128]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:46 */
  assign n30 = n28 | n29;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:61 */
  assign n31 = reg_wired_or[127:64]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:46 */
  assign n32 = n30 | n31;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:61 */
  assign n33 = reg_wired_or[63:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:211:46 */
  assign n34 = n32 | n33;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:216:19 */
  assign n36 = ce & en_snden2;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:217:19 */
  assign n37 = ce & en_snden4;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:232:18 */
  always @*
    frame_sequencer_clkcnt = n2594; // (isignal)
  initial
    frame_sequencer_clkcnt = 2'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:237:75 */
  assign n44 = ss_sound1[3:1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:238:55 */
  assign n46 = ss_sound1[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:239:55 */
  assign n47 = ss_sound1[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:240:55 */
  assign n48 = ss_sound1[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:241:55 */
  assign n49 = ss_sound1[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:242:55 */
  assign n50 = ss_sound1[8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:243:55 */
  assign n51 = ss_sound1[9]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:244:42 */
  assign n52 = ~snd_enable;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:61 */
  assign n53 = {29'b0, framecnt};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:61 */
  assign n55 = n53 == 32'b00000000000000000000000000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:77 */
  assign n56 = {29'b0, framecnt};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:77 */
  assign n58 = n56 == 32'b00000000000000000000000000000010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:65 */
  assign n59 = n55 | n58;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:93 */
  assign n60 = {29'b0, framecnt};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:93 */
  assign n62 = n60 == 32'b00000000000000000000000000000100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:81 */
  assign n63 = n59 | n62;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:109 */
  assign n64 = {29'b0, framecnt};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:109 */
  assign n66 = n64 == 32'b00000000000000000000000000000110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:97 */
  assign n67 = n63 | n66;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:262:49 */
  assign n70 = n67 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:265:61 */
  assign n71 = {29'b0, framecnt};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:265:61 */
  assign n73 = n71 == 32'b00000000000000000000000000000010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:265:77 */
  assign n74 = {29'b0, framecnt};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:265:77 */
  assign n76 = n74 == 32'b00000000000000000000000000000110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:265:65 */
  assign n77 = n73 | n76;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:265:49 */
  assign n80 = n77 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:268:61 */
  assign n81 = {29'b0, framecnt};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:268:61 */
  assign n83 = n81 == 32'b00000000000000000000000000000111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:268:49 */
  assign n86 = n83 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:272:61 */
  assign n87 = {29'b0, framecnt};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:272:61 */
  assign n89 = $signed(n87) < $signed(32'b00000000000000000000000000000111);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:273:78 */
  assign n90 = {29'b0, framecnt};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:273:78 */
  assign n92 = n90 + 32'b00000000000000000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:273:69 */
  assign n93 = n92[2:0];  // trunc
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:272:49 */
  assign n95 = n89 ? n93 : 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:261:41 */
  assign n97 = apu_framecount_en ? n70 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:261:41 */
  assign n100 = apu_framecount_en ? n86 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:261:41 */
  assign n103 = apu_framecount_en ? n80 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:255:33 */
  assign n105 = n110 ? n95 : framecnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:255:33 */
  assign n106 = ce ? n97 : en_len;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:255:33 */
  assign n107 = ce ? en_len : en_len_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:255:33 */
  assign n108 = ce ? n100 : en_env;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:255:33 */
  assign n109 = ce ? n103 : en_sweep;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:255:33 */
  assign n110 = apu_framecount_en & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:282:58 */
  assign n112 = frame_sequencer_clkcnt + 2'b01;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:283:50 */
  assign n113 = n112[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:283:41 */
  assign n116 = n113 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:289:51 */
  assign n118 = n112 == 2'b11;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:289:41 */
  assign n121 = n118 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:280:33 */
  assign n122 = ce ? n116 : en_snden2;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:280:33 */
  assign n123 = ce ? n121 : en_snden4;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:280:33 */
  assign n124 = ce ? n112 : frame_sequencer_clkcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:244:25 */
  assign n126 = n52 ? 1'b0 : n122;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:244:25 */
  assign n128 = n52 ? 1'b0 : n123;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:244:25 */
  assign n130 = n52 ? 1'b0 : n106;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:244:25 */
  assign n132 = n52 ? 1'b0 : n107;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:244:25 */
  assign n134 = n52 ? 1'b0 : n108;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:244:25 */
  assign n136 = n52 ? 1'b0 : n109;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:244:25 */
  assign n138 = n52 ? 3'b000 : n105;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:244:25 */
  assign n140 = n52 ? 2'b00 : n124;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:235:25 */
  assign n141 = reset ? n47 : n126;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:235:25 */
  assign n142 = reset ? n48 : n128;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:235:25 */
  assign n143 = reset ? n49 : n130;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:235:25 */
  assign n144 = reset ? n46 : n132;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:235:25 */
  assign n145 = reset ? n50 : n134;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:235:25 */
  assign n146 = reset ? n51 : n136;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:235:25 */
  assign n147 = reset ? n44 : n138;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:235:25 */
  assign n149 = reset ? 2'b00 : n140;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n161 = wav_ram[127:124]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n162 = wav_ram[63:60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n163 = wav_ram[123:120]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n164 = wav_ram[59:56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n165 = wav_ram[119:116]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n166 = wav_ram[55:52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n167 = wav_ram[115:112]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n168 = wav_ram[51:48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n169 = wav_ram[111:108]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n170 = wav_ram[47:44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n171 = wav_ram[107:104]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n172 = wav_ram[43:40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n173 = wav_ram[103:100]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n174 = wav_ram[39:36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n175 = wav_ram[99:96]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n176 = wav_ram[35:32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n177 = wav_ram[95:92]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n178 = wav_ram[31:28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n179 = wav_ram[91:88]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n180 = wav_ram[27:24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n181 = wav_ram[87:84]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n182 = wav_ram[23:20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n183 = wav_ram[83:80]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n184 = wav_ram[19:16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n185 = wav_ram[79:76]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n186 = wav_ram[15:12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n187 = wav_ram[75:72]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n188 = wav_ram[11:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n189 = wav_ram[71:68]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n190 = wav_ram[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:357:67 */
  assign n191 = wav_ram[67:64]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:358:67 */
  assign n192 = wav_ram[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:363:18 */
  always @*
    write_registers_sq1_trigger_cnt = n2595; // (isignal)
  initial
    write_registers_sq1_trigger_cnt = 3'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:364:18 */
  always @*
    write_registers_sq2_trigger_cnt = n2596; // (isignal)
  initial
    write_registers_sq2_trigger_cnt = 3'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:365:18 */
  always @*
    write_registers_noi_trigger_cnt = n2597; // (isignal)
  initial
    write_registers_noi_trigger_cnt = 3'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:366:18 */
  always @*
    write_registers_wav_trigger_cnt = n2598; // (isignal)
  initial
    write_registers_wav_trigger_cnt = 2'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:374:57 */
  assign n201 = ss_sound1[13:11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:375:57 */
  assign n202 = ss_sound1[14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:376:57 */
  assign n203 = ss_sound1[17:15]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:377:57 */
  assign n204 = ss_sound1[19:18]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:378:57 */
  assign n205 = ss_sound3[22:16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:379:57 */
  assign n206 = ss_sound1[29:26]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:380:57 */
  assign n207 = ss_sound1[30]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:381:57 */
  assign n208 = ss_sound1[33:31]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:382:57 */
  assign n209 = ss_sound1[44:34]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:383:57 */
  assign n210 = ss_sound1[45]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:384:57 */
  assign n211 = ss_sound1[46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:386:57 */
  assign n212 = ss_sound1[48:47]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:387:57 */
  assign n213 = ss_sound1[55:49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:388:57 */
  assign n214 = ss_sound1[59:56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:389:57 */
  assign n215 = ss_sound1[60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:390:57 */
  assign n216 = ss_sound1[63:61]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:391:57 */
  assign n217 = ss_sound2[10:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:392:57 */
  assign n218 = ss_sound2[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:393:57 */
  assign n219 = ss_sound2[12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:395:57 */
  assign n220 = ss_sound2[13]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:396:57 */
  assign n221 = ss_sound2[15:14]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:397:57 */
  assign n222 = ss_sound2[26:16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:398:57 */
  assign n223 = ss_sound2[27]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:399:57 */
  assign n224 = ss_sound2[28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:404:57 */
  assign n225 = ss_sound2[35:29]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:405:57 */
  assign n226 = ss_sound2[39:36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:406:57 */
  assign n227 = ss_sound2[40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:407:57 */
  assign n228 = ss_sound2[43:41]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:408:57 */
  assign n229 = ss_sound2[47:44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:409:57 */
  assign n230 = ss_sound2[48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:410:57 */
  assign n231 = ss_sound2[51:49]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:411:57 */
  assign n232 = ss_sound2[52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:412:57 */
  assign n233 = ss_sound2[53]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:414:57 */
  assign n234 = ss_sound3[7:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:415:57 */
  assign n235 = ss_sound3[15:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n236 = ss_wave1_gbc[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n237 = ss_wave2_gbc[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n238 = ss_wave1_gbc[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n239 = ss_wave2_gbc[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n240 = ss_wave1_gbc[11:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n241 = ss_wave2_gbc[11:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n242 = ss_wave1_gbc[15:12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n243 = ss_wave2_gbc[15:12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n244 = ss_wave1_gbc[19:16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n245 = ss_wave2_gbc[19:16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n246 = ss_wave1_gbc[23:20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n247 = ss_wave2_gbc[23:20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n248 = ss_wave1_gbc[27:24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n249 = ss_wave2_gbc[27:24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n250 = ss_wave1_gbc[31:28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n251 = ss_wave2_gbc[31:28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n252 = ss_wave1_gbc[35:32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n253 = ss_wave2_gbc[35:32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n254 = ss_wave1_gbc[39:36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n255 = ss_wave2_gbc[39:36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n256 = ss_wave1_gbc[43:40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n257 = ss_wave2_gbc[43:40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n258 = ss_wave1_gbc[47:44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n259 = ss_wave2_gbc[47:44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n260 = ss_wave1_gbc[51:48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n261 = ss_wave2_gbc[51:48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n262 = ss_wave1_gbc[55:52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n263 = ss_wave2_gbc[55:52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n264 = ss_wave1_gbc[59:56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n265 = ss_wave2_gbc[59:56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:421:79 */
  assign n266 = ss_wave1_gbc[63:60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:422:79 */
  assign n267 = ss_wave2_gbc[63:60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n268 = ss_wave1[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n269 = ss_wave2[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n270 = ss_wave1[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n271 = ss_wave2[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n272 = ss_wave1[11:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n273 = ss_wave2[11:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n274 = ss_wave1[15:12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n275 = ss_wave2[15:12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n276 = ss_wave1[19:16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n277 = ss_wave2[19:16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n278 = ss_wave1[23:20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n279 = ss_wave2[23:20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n280 = ss_wave1[27:24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n281 = ss_wave2[27:24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n282 = ss_wave1[31:28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n283 = ss_wave2[31:28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n284 = ss_wave1[35:32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n285 = ss_wave2[35:32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n286 = ss_wave1[39:36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n287 = ss_wave2[39:36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n288 = ss_wave1[43:40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n289 = ss_wave2[43:40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n290 = ss_wave1[47:44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n291 = ss_wave2[47:44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n292 = ss_wave1[51:48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n293 = ss_wave2[51:48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n294 = ss_wave1[55:52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n295 = ss_wave2[55:52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n296 = ss_wave1[59:56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n297 = ss_wave2[59:56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:426:75 */
  assign n298 = ss_wave1[63:60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:427:75 */
  assign n299 = ss_wave2[63:60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:419:33 */
  assign n300 = {n268, n270, n272, n274, n276, n278, n280, n282, n284, n286, n288, n290, n292, n294, n296, n298, n269, n271, n273, n275, n277, n279, n281, n283, n285, n287, n289, n291, n293, n295, n297, n299};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:419:33 */
  assign n301 = {n236, n238, n240, n242, n244, n246, n248, n250, n252, n254, n256, n258, n260, n262, n264, n266, n237, n239, n241, n243, n245, n247, n249, n251, n253, n255, n257, n259, n261, n263, n265, n267};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:419:33 */
  assign n302 = is_gbc ? n301 : n300;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:431:56 */
  assign n303 = ss_sound2[54]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:435:60 */
  assign n305 = write_registers_sq1_trigger_cnt == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:438:84 */
  assign n307 = write_registers_sq1_trigger_cnt - 3'b001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n309 = n332 ? 1'b0 : sq1_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:435:41 */
  assign n310 = n305 ? write_registers_sq1_trigger_cnt : n307;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:441:60 */
  assign n312 = write_registers_sq2_trigger_cnt == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:444:84 */
  assign n314 = write_registers_sq2_trigger_cnt - 3'b001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n316 = n333 ? 1'b0 : sq2_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:441:41 */
  assign n317 = n312 ? write_registers_sq2_trigger_cnt : n314;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:447:60 */
  assign n319 = write_registers_wav_trigger_cnt == 2'b00;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:450:84 */
  assign n321 = write_registers_wav_trigger_cnt - 2'b01;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n323 = n334 ? 1'b0 : wav_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:447:41 */
  assign n324 = n319 ? write_registers_wav_trigger_cnt : n321;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:453:60 */
  assign n326 = write_registers_noi_trigger_cnt == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:456:84 */
  assign n328 = write_registers_noi_trigger_cnt - 3'b001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n330 = n335 ? 1'b0 : noi_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:453:41 */
  assign n331 = n326 ? write_registers_noi_trigger_cnt : n328;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n332 = n305 & en_snd2;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n333 = n312 & en_snd2;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n334 = n319 & en_snd2;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n335 = n326 & en_snd2;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n336 = en_snd2 ? n310 : write_registers_sq1_trigger_cnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n337 = en_snd2 ? n317 : write_registers_sq2_trigger_cnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n338 = en_snd2 ? n331 : write_registers_noi_trigger_cnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:434:33 */
  assign n339 = en_snd2 ? n324 : write_registers_wav_trigger_cnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:476:33 */
  assign n340 = sq1_freqchange ? sq1_fr2 : sq1_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:66 */
  assign n341 = ~s1_write_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:51 */
  assign n342 = n341 & s1_write;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:105 */
  assign n344 = s1_addr == 7'b0100110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:94 */
  assign n345 = snd_enable | n344;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:127 */
  assign n346 = s1_addr[5:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:140 */
  assign n348 = n346 == 2'b11;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:117 */
  assign n349 = n345 | n348;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:158 */
  assign n350 = ~is_gbc;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:177 */
  assign n352 = s1_addr == 7'b0010001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:201 */
  assign n354 = s1_addr == 7'b0010110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:189 */
  assign n355 = n352 | n354;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:224 */
  assign n357 = s1_addr == 7'b0011011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:213 */
  assign n358 = n355 | n357;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:247 */
  assign n360 = s1_addr == 7'b0100000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:236 */
  assign n361 = n358 | n360;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:164 */
  assign n362 = n361 & n350;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:147 */
  assign n363 = n349 | n362;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:72 */
  assign n364 = n363 & n342;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:487:90 */
  assign n365 = s1_writedata[6:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:488:80 */
  assign n366 = s1_writedata[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:488:84 */
  assign n367 = ~n366;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:488:65 */
  assign n370 = n367 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:491:92 */
  assign n371 = s1_writedata[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:492:92 */
  assign n372 = s1_writedata[2:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:486:49 */
  assign n374 = s1_addr == 7'b0010000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:495:102 */
  assign n375 = s1_writedata[7:6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:494:65 */
  assign n376 = snd_enable ? n375 : sq1_duty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:497:132 */
  assign n377 = s1_writedata[5:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:497:109 */
  assign n379 = {1'b0, n377};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:497:109 */
  assign n380 = 7'b1000000 - n379;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:493:49 */
  assign n382 = s1_addr == 7'b0010001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:505:95 */
  assign n383 = s1_writedata[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:506:95 */
  assign n384 = s1_writedata[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:507:95 */
  assign n385 = s1_writedata[2:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:499:49 */
  assign n387 = s1_addr == 7'b0010010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:508:49 */
  assign n389 = s1_addr == 7'b0010011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:511:92 */
  assign n390 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:512:80 */
  assign n391 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:513:73 */
  assign n394 = sq1_playing ? 3'b010 : 3'b100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:512:65 */
  assign n395 = n391 ? n394 : n336;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:519:79 */
  assign n396 = ~sq1_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:519:101 */
  assign n397 = s1_writedata[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:519:85 */
  assign n398 = n397 & n396;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:519:111 */
  assign n399 = en_len_r & n398;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:519:65 */
  assign n402 = n399 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:522:102 */
  assign n403 = s1_writedata[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:523:102 */
  assign n404 = s1_writedata[2:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:510:49 */
  assign n406 = s1_addr == 7'b0010100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:528:102 */
  assign n407 = s1_writedata[7:6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:527:65 */
  assign n408 = snd_enable ? n407 : sq2_duty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:530:132 */
  assign n409 = s1_writedata[5:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:530:109 */
  assign n411 = {1'b0, n409};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:530:109 */
  assign n412 = 7'b1000000 - n411;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:526:49 */
  assign n414 = s1_addr == 7'b0010110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:537:95 */
  assign n415 = s1_writedata[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:539:95 */
  assign n416 = s1_writedata[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:540:95 */
  assign n417 = s1_writedata[2:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:532:49 */
  assign n419 = s1_addr == 7'b0010111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:541:49 */
  assign n421 = s1_addr == 7'b0011000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:544:92 */
  assign n422 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:545:80 */
  assign n423 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:546:73 */
  assign n426 = sq2_playing ? 3'b010 : 3'b100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:545:65 */
  assign n427 = n423 ? n426 : n337;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:552:79 */
  assign n428 = ~sq2_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:552:101 */
  assign n429 = s1_writedata[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:552:85 */
  assign n430 = n429 & n428;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:552:111 */
  assign n431 = en_len_r & n430;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:552:65 */
  assign n434 = n431 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:555:102 */
  assign n435 = s1_writedata[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:556:102 */
  assign n436 = s1_writedata[2:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:543:49 */
  assign n438 = s1_addr == 7'b0011001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:560:91 */
  assign n439 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:559:49 */
  assign n441 = s1_addr == 7'b0011010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:563:111 */
  assign n443 = {1'b0, s1_writedata};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:563:111 */
  assign n444 = 9'b100000000 - n443;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:561:49 */
  assign n446 = s1_addr == 7'b0011011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:566:90 */
  assign n447 = s1_writedata[6:5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:565:49 */
  assign n449 = s1_addr == 7'b0011100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:567:49 */
  assign n451 = s1_addr == 7'b0011101;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:570:92 */
  assign n452 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:571:80 */
  assign n453 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:571:65 */
  assign n455 = n453 ? 2'b10 : n339;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:574:79 */
  assign n456 = ~wav_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:574:101 */
  assign n457 = s1_writedata[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:574:85 */
  assign n458 = n457 & n456;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:574:111 */
  assign n459 = en_len_r & n458;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:574:65 */
  assign n462 = n459 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:577:102 */
  assign n463 = s1_writedata[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:578:102 */
  assign n464 = s1_writedata[2:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:569:49 */
  assign n466 = s1_addr == 7'b0011110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:582:132 */
  assign n467 = s1_writedata[5:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:582:109 */
  assign n469 = {1'b0, n467};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:582:109 */
  assign n470 = 7'b1000000 - n469;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:581:49 */
  assign n472 = s1_addr == 7'b0100000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:589:95 */
  assign n473 = s1_writedata[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:591:95 */
  assign n474 = s1_writedata[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:592:95 */
  assign n475 = s1_writedata[2:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:584:49 */
  assign n477 = s1_addr == 7'b0100001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:594:95 */
  assign n478 = s1_writedata[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:595:95 */
  assign n479 = s1_writedata[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:596:95 */
  assign n480 = s1_writedata[2:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:593:49 */
  assign n482 = s1_addr == 7'b0100010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:599:84 */
  assign n483 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:600:72 */
  assign n484 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:601:80 */
  assign n485 = ~noi_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:601:65 */
  assign n488 = n485 ? 3'b010 : 3'b100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:600:57 */
  assign n489 = n484 ? n488 : n338;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:607:71 */
  assign n490 = ~noi_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:607:93 */
  assign n491 = s1_writedata[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:607:77 */
  assign n492 = n491 & n490;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:607:103 */
  assign n493 = en_len_r & n492;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:607:57 */
  assign n496 = n493 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:610:83 */
  assign n497 = s1_writedata[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:598:49 */
  assign n499 = s1_addr == 7'b0100011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:613:49 */
  assign n501 = s1_addr == 7'b0100100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:615:49 */
  assign n503 = s1_addr == 7'b0100101;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:619:83 */
  assign n504 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:72 */
  assign n505 = s1_writedata[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:76 */
  assign n506 = ~n505;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n508 = n523 ? 7'b0000000 : sq1_slen;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n510 = n538 ? 7'b0000000 : sq2_slen;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n512 = n553 ? 9'b000000000 : wav_slen;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n514 = n562 ? 7'b0000000 : noi_slen;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n516 = n506 ? 3'b000 : sq1_swper;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n518 = n506 ? 1'b0 : sq1_swdir;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n520 = n506 ? 3'b000 : sq1_swshift;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n522 = n506 ? 2'b00 : sq1_duty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n523 = is_gbc & n506;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n525 = n506 ? 4'b0000 : sq1_svol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n527 = n506 ? 1'b0 : sq1_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n529 = n506 ? 3'b000 : sq1_envper;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n531 = n506 ? 11'b00000000000 : n340;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n533 = n506 ? 1'b0 : n309;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n535 = n506 ? 1'b0 : sq1_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n537 = n506 ? 2'b00 : sq2_duty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n538 = is_gbc & n506;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n540 = n506 ? 4'b0000 : sq2_svol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n542 = n506 ? 1'b0 : sq2_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n544 = n506 ? 3'b000 : sq2_envper;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n546 = n506 ? 11'b00000000000 : sq2_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n548 = n506 ? 1'b0 : n316;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n550 = n506 ? 1'b0 : sq2_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n552 = n506 ? 1'b0 : wav_enable;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n553 = is_gbc & n506;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n555 = n506 ? 2'b00 : wav_volsh;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n557 = n506 ? 11'b00000000000 : wav_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n559 = n506 ? 1'b0 : n323;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n561 = n506 ? 1'b0 : wav_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n562 = is_gbc & n506;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n564 = n506 ? 4'b0000 : noi_svol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n566 = n506 ? 1'b0 : noi_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n568 = n506 ? 3'b000 : noi_envper;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n570 = n506 ? 4'b0000 : noi_freqsh;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n572 = n506 ? 1'b0 : noi_short;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n574 = n506 ? 3'b000 : noi_div;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n576 = n506 ? 1'b0 : n330;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n578 = n506 ? 1'b0 : noi_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n580 = n506 ? 8'b00000000 : ch_map;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n582 = n506 ? 8'b00000000 : ch_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n584 = n506 ? 1'b0 : s1_write;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n586 = n506 ? 3'b000 : n336;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n588 = n506 ? 3'b000 : n337;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n590 = n506 ? 3'b000 : n338;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n592 = n506 ? 2'b00 : n339;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:618:49 */
  assign n594 = s1_addr == 7'b0100110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:678:111 */
  assign n595 = wav_index[4:1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:680:92 */
  assign n596 = s1_addr[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:677:57 */
  assign n597 = wav_playing ? n595 : n596;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:683:87 */
  assign n599 = $unsigned(wav_access) > $unsigned(2'b00);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:683:73 */
  assign n600 = is_gbc | n599;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:683:106 */
  assign n601 = ~wav_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:683:91 */
  assign n602 = n600 | n601;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:684:119 */
  assign n604 = {n597, 1'b0};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:73 */
  assign n607 = 5'b11111 - n604;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:107 */
  assign n609 = s1_writedata[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:87 */
  assign n611 = {27'b0, n604};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:87 */
  assign n613 = n611 + 32'b00000000000000000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:87 */
  assign n614 = n613[4:0];  // trunc
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:87 */
  assign n616 = 5'b11111 - n614;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:107 */
  assign n618 = s1_writedata[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:683:57 */
  assign n620 = n602 ? n2920 : wav_ram;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:49 */
  assign n623 = s1_addr == 7'b0110000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:64 */
  assign n625 = s1_addr == 7'b0110001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:64 */
  assign n626 = n623 | n625;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:76 */
  assign n628 = s1_addr == 7'b0110010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:76 */
  assign n629 = n626 | n628;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:88 */
  assign n631 = s1_addr == 7'b0110011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:88 */
  assign n632 = n629 | n631;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:100 */
  assign n634 = s1_addr == 7'b0110100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:100 */
  assign n635 = n632 | n634;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:112 */
  assign n637 = s1_addr == 7'b0110101;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:112 */
  assign n638 = n635 | n637;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:124 */
  assign n640 = s1_addr == 7'b0110110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:124 */
  assign n641 = n638 | n640;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:136 */
  assign n643 = s1_addr == 7'b0110111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:136 */
  assign n644 = n641 | n643;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:148 */
  assign n646 = s1_addr == 7'b0111000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:148 */
  assign n647 = n644 | n646;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:160 */
  assign n649 = s1_addr == 7'b0111001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:160 */
  assign n650 = n647 | n649;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:172 */
  assign n652 = s1_addr == 7'b0111010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:172 */
  assign n653 = n650 | n652;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:184 */
  assign n655 = s1_addr == 7'b0111011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:184 */
  assign n656 = n653 | n655;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:196 */
  assign n658 = s1_addr == 7'b0111100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:196 */
  assign n659 = n656 | n658;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:208 */
  assign n661 = s1_addr == 7'b0111101;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:208 */
  assign n662 = n659 | n661;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:220 */
  assign n664 = s1_addr == 7'b0111110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:220 */
  assign n665 = n662 | n664;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:232 */
  assign n667 = s1_addr == 7'b0111111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:676:232 */
  assign n668 = n665 | n667;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  assign n669 = {n668, n594, n503, n501, n499, n482, n477, n472, n466, n451, n449, n446, n441, n438, n421, n419, n414, n406, n389, n387, n382, n374};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n670 = snd_enable;
      22'b0100000000000000000000: n670 = n504;
      22'b0010000000000000000000: n670 = snd_enable;
      22'b0001000000000000000000: n670 = snd_enable;
      22'b0000100000000000000000: n670 = snd_enable;
      22'b0000010000000000000000: n670 = snd_enable;
      22'b0000001000000000000000: n670 = snd_enable;
      22'b0000000100000000000000: n670 = snd_enable;
      22'b0000000010000000000000: n670 = snd_enable;
      22'b0000000001000000000000: n670 = snd_enable;
      22'b0000000000100000000000: n670 = snd_enable;
      22'b0000000000010000000000: n670 = snd_enable;
      22'b0000000000001000000000: n670 = snd_enable;
      22'b0000000000000100000000: n670 = snd_enable;
      22'b0000000000000010000000: n670 = snd_enable;
      22'b0000000000000001000000: n670 = snd_enable;
      22'b0000000000000000100000: n670 = snd_enable;
      22'b0000000000000000010000: n670 = snd_enable;
      22'b0000000000000000001000: n670 = snd_enable;
      22'b0000000000000000000100: n670 = snd_enable;
      22'b0000000000000000000010: n670 = snd_enable;
      22'b0000000000000000000001: n670 = snd_enable;
      default: n670 = snd_enable;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n671 = sq1_swper;
      22'b0100000000000000000000: n671 = n516;
      22'b0010000000000000000000: n671 = sq1_swper;
      22'b0001000000000000000000: n671 = sq1_swper;
      22'b0000100000000000000000: n671 = sq1_swper;
      22'b0000010000000000000000: n671 = sq1_swper;
      22'b0000001000000000000000: n671 = sq1_swper;
      22'b0000000100000000000000: n671 = sq1_swper;
      22'b0000000010000000000000: n671 = sq1_swper;
      22'b0000000001000000000000: n671 = sq1_swper;
      22'b0000000000100000000000: n671 = sq1_swper;
      22'b0000000000010000000000: n671 = sq1_swper;
      22'b0000000000001000000000: n671 = sq1_swper;
      22'b0000000000000100000000: n671 = sq1_swper;
      22'b0000000000000010000000: n671 = sq1_swper;
      22'b0000000000000001000000: n671 = sq1_swper;
      22'b0000000000000000100000: n671 = sq1_swper;
      22'b0000000000000000010000: n671 = sq1_swper;
      22'b0000000000000000001000: n671 = sq1_swper;
      22'b0000000000000000000100: n671 = sq1_swper;
      22'b0000000000000000000010: n671 = sq1_swper;
      22'b0000000000000000000001: n671 = n365;
      default: n671 = sq1_swper;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n672 = sq1_swdir;
      22'b0100000000000000000000: n672 = n518;
      22'b0010000000000000000000: n672 = sq1_swdir;
      22'b0001000000000000000000: n672 = sq1_swdir;
      22'b0000100000000000000000: n672 = sq1_swdir;
      22'b0000010000000000000000: n672 = sq1_swdir;
      22'b0000001000000000000000: n672 = sq1_swdir;
      22'b0000000100000000000000: n672 = sq1_swdir;
      22'b0000000010000000000000: n672 = sq1_swdir;
      22'b0000000001000000000000: n672 = sq1_swdir;
      22'b0000000000100000000000: n672 = sq1_swdir;
      22'b0000000000010000000000: n672 = sq1_swdir;
      22'b0000000000001000000000: n672 = sq1_swdir;
      22'b0000000000000100000000: n672 = sq1_swdir;
      22'b0000000000000010000000: n672 = sq1_swdir;
      22'b0000000000000001000000: n672 = sq1_swdir;
      22'b0000000000000000100000: n672 = sq1_swdir;
      22'b0000000000000000010000: n672 = sq1_swdir;
      22'b0000000000000000001000: n672 = sq1_swdir;
      22'b0000000000000000000100: n672 = sq1_swdir;
      22'b0000000000000000000010: n672 = sq1_swdir;
      22'b0000000000000000000001: n672 = n371;
      default: n672 = sq1_swdir;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n674 = 1'b0;
      22'b0100000000000000000000: n674 = 1'b0;
      22'b0010000000000000000000: n674 = 1'b0;
      22'b0001000000000000000000: n674 = 1'b0;
      22'b0000100000000000000000: n674 = 1'b0;
      22'b0000010000000000000000: n674 = 1'b0;
      22'b0000001000000000000000: n674 = 1'b0;
      22'b0000000100000000000000: n674 = 1'b0;
      22'b0000000010000000000000: n674 = 1'b0;
      22'b0000000001000000000000: n674 = 1'b0;
      22'b0000000000100000000000: n674 = 1'b0;
      22'b0000000000010000000000: n674 = 1'b0;
      22'b0000000000001000000000: n674 = 1'b0;
      22'b0000000000000100000000: n674 = 1'b0;
      22'b0000000000000010000000: n674 = 1'b0;
      22'b0000000000000001000000: n674 = 1'b0;
      22'b0000000000000000100000: n674 = 1'b0;
      22'b0000000000000000010000: n674 = 1'b0;
      22'b0000000000000000001000: n674 = 1'b0;
      22'b0000000000000000000100: n674 = 1'b0;
      22'b0000000000000000000010: n674 = 1'b0;
      22'b0000000000000000000001: n674 = n370;
      default: n674 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n675 = sq1_swshift;
      22'b0100000000000000000000: n675 = n520;
      22'b0010000000000000000000: n675 = sq1_swshift;
      22'b0001000000000000000000: n675 = sq1_swshift;
      22'b0000100000000000000000: n675 = sq1_swshift;
      22'b0000010000000000000000: n675 = sq1_swshift;
      22'b0000001000000000000000: n675 = sq1_swshift;
      22'b0000000100000000000000: n675 = sq1_swshift;
      22'b0000000010000000000000: n675 = sq1_swshift;
      22'b0000000001000000000000: n675 = sq1_swshift;
      22'b0000000000100000000000: n675 = sq1_swshift;
      22'b0000000000010000000000: n675 = sq1_swshift;
      22'b0000000000001000000000: n675 = sq1_swshift;
      22'b0000000000000100000000: n675 = sq1_swshift;
      22'b0000000000000010000000: n675 = sq1_swshift;
      22'b0000000000000001000000: n675 = sq1_swshift;
      22'b0000000000000000100000: n675 = sq1_swshift;
      22'b0000000000000000010000: n675 = sq1_swshift;
      22'b0000000000000000001000: n675 = sq1_swshift;
      22'b0000000000000000000100: n675 = sq1_swshift;
      22'b0000000000000000000010: n675 = sq1_swshift;
      22'b0000000000000000000001: n675 = n372;
      default: n675 = sq1_swshift;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n676 = sq1_duty;
      22'b0100000000000000000000: n676 = n522;
      22'b0010000000000000000000: n676 = sq1_duty;
      22'b0001000000000000000000: n676 = sq1_duty;
      22'b0000100000000000000000: n676 = sq1_duty;
      22'b0000010000000000000000: n676 = sq1_duty;
      22'b0000001000000000000000: n676 = sq1_duty;
      22'b0000000100000000000000: n676 = sq1_duty;
      22'b0000000010000000000000: n676 = sq1_duty;
      22'b0000000001000000000000: n676 = sq1_duty;
      22'b0000000000100000000000: n676 = sq1_duty;
      22'b0000000000010000000000: n676 = sq1_duty;
      22'b0000000000001000000000: n676 = sq1_duty;
      22'b0000000000000100000000: n676 = sq1_duty;
      22'b0000000000000010000000: n676 = sq1_duty;
      22'b0000000000000001000000: n676 = sq1_duty;
      22'b0000000000000000100000: n676 = sq1_duty;
      22'b0000000000000000010000: n676 = sq1_duty;
      22'b0000000000000000001000: n676 = sq1_duty;
      22'b0000000000000000000100: n676 = sq1_duty;
      22'b0000000000000000000010: n676 = n376;
      22'b0000000000000000000001: n676 = sq1_duty;
      default: n676 = sq1_duty;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n677 = sq1_slen;
      22'b0100000000000000000000: n677 = n508;
      22'b0010000000000000000000: n677 = sq1_slen;
      22'b0001000000000000000000: n677 = sq1_slen;
      22'b0000100000000000000000: n677 = sq1_slen;
      22'b0000010000000000000000: n677 = sq1_slen;
      22'b0000001000000000000000: n677 = sq1_slen;
      22'b0000000100000000000000: n677 = sq1_slen;
      22'b0000000010000000000000: n677 = sq1_slen;
      22'b0000000001000000000000: n677 = sq1_slen;
      22'b0000000000100000000000: n677 = sq1_slen;
      22'b0000000000010000000000: n677 = sq1_slen;
      22'b0000000000001000000000: n677 = sq1_slen;
      22'b0000000000000100000000: n677 = sq1_slen;
      22'b0000000000000010000000: n677 = sq1_slen;
      22'b0000000000000001000000: n677 = sq1_slen;
      22'b0000000000000000100000: n677 = sq1_slen;
      22'b0000000000000000010000: n677 = sq1_slen;
      22'b0000000000000000001000: n677 = sq1_slen;
      22'b0000000000000000000100: n677 = sq1_slen;
      22'b0000000000000000000010: n677 = n380;
      22'b0000000000000000000001: n677 = sq1_slen;
      default: n677 = sq1_slen;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n678 = sq1_svol;
      22'b0100000000000000000000: n678 = n525;
      22'b0010000000000000000000: n678 = sq1_svol;
      22'b0001000000000000000000: n678 = sq1_svol;
      22'b0000100000000000000000: n678 = sq1_svol;
      22'b0000010000000000000000: n678 = sq1_svol;
      22'b0000001000000000000000: n678 = sq1_svol;
      22'b0000000100000000000000: n678 = sq1_svol;
      22'b0000000010000000000000: n678 = sq1_svol;
      22'b0000000001000000000000: n678 = sq1_svol;
      22'b0000000000100000000000: n678 = sq1_svol;
      22'b0000000000010000000000: n678 = sq1_svol;
      22'b0000000000001000000000: n678 = sq1_svol;
      22'b0000000000000100000000: n678 = sq1_svol;
      22'b0000000000000010000000: n678 = sq1_svol;
      22'b0000000000000001000000: n678 = sq1_svol;
      22'b0000000000000000100000: n678 = sq1_svol;
      22'b0000000000000000010000: n678 = sq1_svol;
      22'b0000000000000000001000: n678 = sq1_svol;
      22'b0000000000000000000100: n678 = n383;
      22'b0000000000000000000010: n678 = sq1_svol;
      22'b0000000000000000000001: n678 = sq1_svol;
      default: n678 = sq1_svol;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n679 = sq1_envsgn;
      22'b0100000000000000000000: n679 = n527;
      22'b0010000000000000000000: n679 = sq1_envsgn;
      22'b0001000000000000000000: n679 = sq1_envsgn;
      22'b0000100000000000000000: n679 = sq1_envsgn;
      22'b0000010000000000000000: n679 = sq1_envsgn;
      22'b0000001000000000000000: n679 = sq1_envsgn;
      22'b0000000100000000000000: n679 = sq1_envsgn;
      22'b0000000010000000000000: n679 = sq1_envsgn;
      22'b0000000001000000000000: n679 = sq1_envsgn;
      22'b0000000000100000000000: n679 = sq1_envsgn;
      22'b0000000000010000000000: n679 = sq1_envsgn;
      22'b0000000000001000000000: n679 = sq1_envsgn;
      22'b0000000000000100000000: n679 = sq1_envsgn;
      22'b0000000000000010000000: n679 = sq1_envsgn;
      22'b0000000000000001000000: n679 = sq1_envsgn;
      22'b0000000000000000100000: n679 = sq1_envsgn;
      22'b0000000000000000010000: n679 = sq1_envsgn;
      22'b0000000000000000001000: n679 = sq1_envsgn;
      22'b0000000000000000000100: n679 = n384;
      22'b0000000000000000000010: n679 = sq1_envsgn;
      22'b0000000000000000000001: n679 = sq1_envsgn;
      default: n679 = sq1_envsgn;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n680 = sq1_envsgn_old;
      22'b0100000000000000000000: n680 = sq1_envsgn_old;
      22'b0010000000000000000000: n680 = sq1_envsgn_old;
      22'b0001000000000000000000: n680 = sq1_envsgn_old;
      22'b0000100000000000000000: n680 = sq1_envsgn_old;
      22'b0000010000000000000000: n680 = sq1_envsgn_old;
      22'b0000001000000000000000: n680 = sq1_envsgn_old;
      22'b0000000100000000000000: n680 = sq1_envsgn_old;
      22'b0000000010000000000000: n680 = sq1_envsgn_old;
      22'b0000000001000000000000: n680 = sq1_envsgn_old;
      22'b0000000000100000000000: n680 = sq1_envsgn_old;
      22'b0000000000010000000000: n680 = sq1_envsgn_old;
      22'b0000000000001000000000: n680 = sq1_envsgn_old;
      22'b0000000000000100000000: n680 = sq1_envsgn_old;
      22'b0000000000000010000000: n680 = sq1_envsgn_old;
      22'b0000000000000001000000: n680 = sq1_envsgn_old;
      22'b0000000000000000100000: n680 = sq1_envsgn_old;
      22'b0000000000000000010000: n680 = sq1_envsgn_old;
      22'b0000000000000000001000: n680 = sq1_envsgn_old;
      22'b0000000000000000000100: n680 = sq1_envsgn;
      22'b0000000000000000000010: n680 = sq1_envsgn_old;
      22'b0000000000000000000001: n680 = sq1_envsgn_old;
      default: n680 = sq1_envsgn_old;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n681 = sq1_envper;
      22'b0100000000000000000000: n681 = n529;
      22'b0010000000000000000000: n681 = sq1_envper;
      22'b0001000000000000000000: n681 = sq1_envper;
      22'b0000100000000000000000: n681 = sq1_envper;
      22'b0000010000000000000000: n681 = sq1_envper;
      22'b0000001000000000000000: n681 = sq1_envper;
      22'b0000000100000000000000: n681 = sq1_envper;
      22'b0000000010000000000000: n681 = sq1_envper;
      22'b0000000001000000000000: n681 = sq1_envper;
      22'b0000000000100000000000: n681 = sq1_envper;
      22'b0000000000010000000000: n681 = sq1_envper;
      22'b0000000000001000000000: n681 = sq1_envper;
      22'b0000000000000100000000: n681 = sq1_envper;
      22'b0000000000000010000000: n681 = sq1_envper;
      22'b0000000000000001000000: n681 = sq1_envper;
      22'b0000000000000000100000: n681 = sq1_envper;
      22'b0000000000000000010000: n681 = sq1_envper;
      22'b0000000000000000001000: n681 = sq1_envper;
      22'b0000000000000000000100: n681 = n385;
      22'b0000000000000000000010: n681 = sq1_envper;
      22'b0000000000000000000001: n681 = sq1_envper;
      default: n681 = sq1_envper;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n682 = sq1_envper_old;
      22'b0100000000000000000000: n682 = sq1_envper_old;
      22'b0010000000000000000000: n682 = sq1_envper_old;
      22'b0001000000000000000000: n682 = sq1_envper_old;
      22'b0000100000000000000000: n682 = sq1_envper_old;
      22'b0000010000000000000000: n682 = sq1_envper_old;
      22'b0000001000000000000000: n682 = sq1_envper_old;
      22'b0000000100000000000000: n682 = sq1_envper_old;
      22'b0000000010000000000000: n682 = sq1_envper_old;
      22'b0000000001000000000000: n682 = sq1_envper_old;
      22'b0000000000100000000000: n682 = sq1_envper_old;
      22'b0000000000010000000000: n682 = sq1_envper_old;
      22'b0000000000001000000000: n682 = sq1_envper_old;
      22'b0000000000000100000000: n682 = sq1_envper_old;
      22'b0000000000000010000000: n682 = sq1_envper_old;
      22'b0000000000000001000000: n682 = sq1_envper_old;
      22'b0000000000000000100000: n682 = sq1_envper_old;
      22'b0000000000000000010000: n682 = sq1_envper_old;
      22'b0000000000000000001000: n682 = sq1_envper_old;
      22'b0000000000000000000100: n682 = sq1_envper;
      22'b0000000000000000000010: n682 = sq1_envper_old;
      22'b0000000000000000000001: n682 = sq1_envper_old;
      default: n682 = sq1_envper_old;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n683 = n531[7:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:82:12 */
  assign n684 = n340[7:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n685 = n684;
      22'b0100000000000000000000: n685 = n683;
      22'b0010000000000000000000: n685 = n684;
      22'b0001000000000000000000: n685 = n684;
      22'b0000100000000000000000: n685 = n684;
      22'b0000010000000000000000: n685 = n684;
      22'b0000001000000000000000: n685 = n684;
      22'b0000000100000000000000: n685 = n684;
      22'b0000000010000000000000: n685 = n684;
      22'b0000000001000000000000: n685 = n684;
      22'b0000000000100000000000: n685 = n684;
      22'b0000000000010000000000: n685 = n684;
      22'b0000000000001000000000: n685 = n684;
      22'b0000000000000100000000: n685 = n684;
      22'b0000000000000010000000: n685 = n684;
      22'b0000000000000001000000: n685 = n684;
      22'b0000000000000000100000: n685 = n684;
      22'b0000000000000000010000: n685 = n684;
      22'b0000000000000000001000: n685 = s1_writedata;
      22'b0000000000000000000100: n685 = n684;
      22'b0000000000000000000010: n685 = n684;
      22'b0000000000000000000001: n685 = n684;
      default: n685 = n684;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n686 = n531[10:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:82:12 */
  assign n687 = n340[10:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n688 = n687;
      22'b0100000000000000000000: n688 = n686;
      22'b0010000000000000000000: n688 = n687;
      22'b0001000000000000000000: n688 = n687;
      22'b0000100000000000000000: n688 = n687;
      22'b0000010000000000000000: n688 = n687;
      22'b0000001000000000000000: n688 = n687;
      22'b0000000100000000000000: n688 = n687;
      22'b0000000010000000000000: n688 = n687;
      22'b0000000001000000000000: n688 = n687;
      22'b0000000000100000000000: n688 = n687;
      22'b0000000000010000000000: n688 = n687;
      22'b0000000000001000000000: n688 = n687;
      22'b0000000000000100000000: n688 = n687;
      22'b0000000000000010000000: n688 = n687;
      22'b0000000000000001000000: n688 = n687;
      22'b0000000000000000100000: n688 = n687;
      22'b0000000000000000010000: n688 = n404;
      22'b0000000000000000001000: n688 = n687;
      22'b0000000000000000000100: n688 = n687;
      22'b0000000000000000000010: n688 = n687;
      22'b0000000000000000000001: n688 = n687;
      default: n688 = n687;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n689 = n309;
      22'b0100000000000000000000: n689 = n533;
      22'b0010000000000000000000: n689 = n309;
      22'b0001000000000000000000: n689 = n309;
      22'b0000100000000000000000: n689 = n309;
      22'b0000010000000000000000: n689 = n309;
      22'b0000001000000000000000: n689 = n309;
      22'b0000000100000000000000: n689 = n309;
      22'b0000000010000000000000: n689 = n309;
      22'b0000000001000000000000: n689 = n309;
      22'b0000000000100000000000: n689 = n309;
      22'b0000000000010000000000: n689 = n309;
      22'b0000000000001000000000: n689 = n309;
      22'b0000000000000100000000: n689 = n309;
      22'b0000000000000010000000: n689 = n309;
      22'b0000000000000001000000: n689 = n309;
      22'b0000000000000000100000: n689 = n309;
      22'b0000000000000000010000: n689 = n390;
      22'b0000000000000000001000: n689 = n309;
      22'b0000000000000000000100: n689 = n309;
      22'b0000000000000000000010: n689 = n309;
      22'b0000000000000000000001: n689 = n309;
      default: n689 = n309;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n690 = sq1_lenchk;
      22'b0100000000000000000000: n690 = n535;
      22'b0010000000000000000000: n690 = sq1_lenchk;
      22'b0001000000000000000000: n690 = sq1_lenchk;
      22'b0000100000000000000000: n690 = sq1_lenchk;
      22'b0000010000000000000000: n690 = sq1_lenchk;
      22'b0000001000000000000000: n690 = sq1_lenchk;
      22'b0000000100000000000000: n690 = sq1_lenchk;
      22'b0000000010000000000000: n690 = sq1_lenchk;
      22'b0000000001000000000000: n690 = sq1_lenchk;
      22'b0000000000100000000000: n690 = sq1_lenchk;
      22'b0000000000010000000000: n690 = sq1_lenchk;
      22'b0000000000001000000000: n690 = sq1_lenchk;
      22'b0000000000000100000000: n690 = sq1_lenchk;
      22'b0000000000000010000000: n690 = sq1_lenchk;
      22'b0000000000000001000000: n690 = sq1_lenchk;
      22'b0000000000000000100000: n690 = sq1_lenchk;
      22'b0000000000000000010000: n690 = n403;
      22'b0000000000000000001000: n690 = sq1_lenchk;
      22'b0000000000000000000100: n690 = sq1_lenchk;
      22'b0000000000000000000010: n690 = sq1_lenchk;
      22'b0000000000000000000001: n690 = sq1_lenchk;
      default: n690 = sq1_lenchk;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n693 = 1'b0;
      22'b0100000000000000000000: n693 = 1'b0;
      22'b0010000000000000000000: n693 = 1'b0;
      22'b0001000000000000000000: n693 = 1'b0;
      22'b0000100000000000000000: n693 = 1'b0;
      22'b0000010000000000000000: n693 = 1'b0;
      22'b0000001000000000000000: n693 = 1'b0;
      22'b0000000100000000000000: n693 = 1'b0;
      22'b0000000010000000000000: n693 = 1'b0;
      22'b0000000001000000000000: n693 = 1'b0;
      22'b0000000000100000000000: n693 = 1'b0;
      22'b0000000000010000000000: n693 = 1'b0;
      22'b0000000000001000000000: n693 = 1'b0;
      22'b0000000000000100000000: n693 = 1'b0;
      22'b0000000000000010000000: n693 = 1'b0;
      22'b0000000000000001000000: n693 = 1'b0;
      22'b0000000000000000100000: n693 = 1'b0;
      22'b0000000000000000010000: n693 = 1'b0;
      22'b0000000000000000001000: n693 = 1'b0;
      22'b0000000000000000000100: n693 = 1'b1;
      22'b0000000000000000000010: n693 = 1'b0;
      22'b0000000000000000000001: n693 = 1'b0;
      default: n693 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n696 = 1'b0;
      22'b0100000000000000000000: n696 = 1'b0;
      22'b0010000000000000000000: n696 = 1'b0;
      22'b0001000000000000000000: n696 = 1'b0;
      22'b0000100000000000000000: n696 = 1'b0;
      22'b0000010000000000000000: n696 = 1'b0;
      22'b0000001000000000000000: n696 = 1'b0;
      22'b0000000100000000000000: n696 = 1'b0;
      22'b0000000010000000000000: n696 = 1'b0;
      22'b0000000001000000000000: n696 = 1'b0;
      22'b0000000000100000000000: n696 = 1'b0;
      22'b0000000000010000000000: n696 = 1'b0;
      22'b0000000000001000000000: n696 = 1'b0;
      22'b0000000000000100000000: n696 = 1'b0;
      22'b0000000000000010000000: n696 = 1'b0;
      22'b0000000000000001000000: n696 = 1'b0;
      22'b0000000000000000100000: n696 = 1'b0;
      22'b0000000000000000010000: n696 = 1'b0;
      22'b0000000000000000001000: n696 = 1'b0;
      22'b0000000000000000000100: n696 = 1'b0;
      22'b0000000000000000000010: n696 = 1'b1;
      22'b0000000000000000000001: n696 = 1'b0;
      default: n696 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n698 = 1'b0;
      22'b0100000000000000000000: n698 = 1'b0;
      22'b0010000000000000000000: n698 = 1'b0;
      22'b0001000000000000000000: n698 = 1'b0;
      22'b0000100000000000000000: n698 = 1'b0;
      22'b0000010000000000000000: n698 = 1'b0;
      22'b0000001000000000000000: n698 = 1'b0;
      22'b0000000100000000000000: n698 = 1'b0;
      22'b0000000010000000000000: n698 = 1'b0;
      22'b0000000001000000000000: n698 = 1'b0;
      22'b0000000000100000000000: n698 = 1'b0;
      22'b0000000000010000000000: n698 = 1'b0;
      22'b0000000000001000000000: n698 = 1'b0;
      22'b0000000000000100000000: n698 = 1'b0;
      22'b0000000000000010000000: n698 = 1'b0;
      22'b0000000000000001000000: n698 = 1'b0;
      22'b0000000000000000100000: n698 = 1'b0;
      22'b0000000000000000010000: n698 = n402;
      22'b0000000000000000001000: n698 = 1'b0;
      22'b0000000000000000000100: n698 = 1'b0;
      22'b0000000000000000000010: n698 = 1'b0;
      22'b0000000000000000000001: n698 = 1'b0;
      default: n698 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n699 = sq2_duty;
      22'b0100000000000000000000: n699 = n537;
      22'b0010000000000000000000: n699 = sq2_duty;
      22'b0001000000000000000000: n699 = sq2_duty;
      22'b0000100000000000000000: n699 = sq2_duty;
      22'b0000010000000000000000: n699 = sq2_duty;
      22'b0000001000000000000000: n699 = sq2_duty;
      22'b0000000100000000000000: n699 = sq2_duty;
      22'b0000000010000000000000: n699 = sq2_duty;
      22'b0000000001000000000000: n699 = sq2_duty;
      22'b0000000000100000000000: n699 = sq2_duty;
      22'b0000000000010000000000: n699 = sq2_duty;
      22'b0000000000001000000000: n699 = sq2_duty;
      22'b0000000000000100000000: n699 = sq2_duty;
      22'b0000000000000010000000: n699 = sq2_duty;
      22'b0000000000000001000000: n699 = sq2_duty;
      22'b0000000000000000100000: n699 = n408;
      22'b0000000000000000010000: n699 = sq2_duty;
      22'b0000000000000000001000: n699 = sq2_duty;
      22'b0000000000000000000100: n699 = sq2_duty;
      22'b0000000000000000000010: n699 = sq2_duty;
      22'b0000000000000000000001: n699 = sq2_duty;
      default: n699 = sq2_duty;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n700 = sq2_slen;
      22'b0100000000000000000000: n700 = n510;
      22'b0010000000000000000000: n700 = sq2_slen;
      22'b0001000000000000000000: n700 = sq2_slen;
      22'b0000100000000000000000: n700 = sq2_slen;
      22'b0000010000000000000000: n700 = sq2_slen;
      22'b0000001000000000000000: n700 = sq2_slen;
      22'b0000000100000000000000: n700 = sq2_slen;
      22'b0000000010000000000000: n700 = sq2_slen;
      22'b0000000001000000000000: n700 = sq2_slen;
      22'b0000000000100000000000: n700 = sq2_slen;
      22'b0000000000010000000000: n700 = sq2_slen;
      22'b0000000000001000000000: n700 = sq2_slen;
      22'b0000000000000100000000: n700 = sq2_slen;
      22'b0000000000000010000000: n700 = sq2_slen;
      22'b0000000000000001000000: n700 = sq2_slen;
      22'b0000000000000000100000: n700 = n412;
      22'b0000000000000000010000: n700 = sq2_slen;
      22'b0000000000000000001000: n700 = sq2_slen;
      22'b0000000000000000000100: n700 = sq2_slen;
      22'b0000000000000000000010: n700 = sq2_slen;
      22'b0000000000000000000001: n700 = sq2_slen;
      default: n700 = sq2_slen;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n701 = sq2_svol;
      22'b0100000000000000000000: n701 = n540;
      22'b0010000000000000000000: n701 = sq2_svol;
      22'b0001000000000000000000: n701 = sq2_svol;
      22'b0000100000000000000000: n701 = sq2_svol;
      22'b0000010000000000000000: n701 = sq2_svol;
      22'b0000001000000000000000: n701 = sq2_svol;
      22'b0000000100000000000000: n701 = sq2_svol;
      22'b0000000010000000000000: n701 = sq2_svol;
      22'b0000000001000000000000: n701 = sq2_svol;
      22'b0000000000100000000000: n701 = sq2_svol;
      22'b0000000000010000000000: n701 = sq2_svol;
      22'b0000000000001000000000: n701 = sq2_svol;
      22'b0000000000000100000000: n701 = sq2_svol;
      22'b0000000000000010000000: n701 = sq2_svol;
      22'b0000000000000001000000: n701 = n415;
      22'b0000000000000000100000: n701 = sq2_svol;
      22'b0000000000000000010000: n701 = sq2_svol;
      22'b0000000000000000001000: n701 = sq2_svol;
      22'b0000000000000000000100: n701 = sq2_svol;
      22'b0000000000000000000010: n701 = sq2_svol;
      22'b0000000000000000000001: n701 = sq2_svol;
      default: n701 = sq2_svol;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n704 = 1'b0;
      22'b0100000000000000000000: n704 = 1'b0;
      22'b0010000000000000000000: n704 = 1'b0;
      22'b0001000000000000000000: n704 = 1'b0;
      22'b0000100000000000000000: n704 = 1'b0;
      22'b0000010000000000000000: n704 = 1'b0;
      22'b0000001000000000000000: n704 = 1'b0;
      22'b0000000100000000000000: n704 = 1'b0;
      22'b0000000010000000000000: n704 = 1'b0;
      22'b0000000001000000000000: n704 = 1'b0;
      22'b0000000000100000000000: n704 = 1'b0;
      22'b0000000000010000000000: n704 = 1'b0;
      22'b0000000000001000000000: n704 = 1'b0;
      22'b0000000000000100000000: n704 = 1'b0;
      22'b0000000000000010000000: n704 = 1'b0;
      22'b0000000000000001000000: n704 = 1'b1;
      22'b0000000000000000100000: n704 = 1'b0;
      22'b0000000000000000010000: n704 = 1'b0;
      22'b0000000000000000001000: n704 = 1'b0;
      22'b0000000000000000000100: n704 = 1'b0;
      22'b0000000000000000000010: n704 = 1'b0;
      22'b0000000000000000000001: n704 = 1'b0;
      default: n704 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n707 = 1'b0;
      22'b0100000000000000000000: n707 = 1'b0;
      22'b0010000000000000000000: n707 = 1'b0;
      22'b0001000000000000000000: n707 = 1'b0;
      22'b0000100000000000000000: n707 = 1'b0;
      22'b0000010000000000000000: n707 = 1'b0;
      22'b0000001000000000000000: n707 = 1'b0;
      22'b0000000100000000000000: n707 = 1'b0;
      22'b0000000010000000000000: n707 = 1'b0;
      22'b0000000001000000000000: n707 = 1'b0;
      22'b0000000000100000000000: n707 = 1'b0;
      22'b0000000000010000000000: n707 = 1'b0;
      22'b0000000000001000000000: n707 = 1'b0;
      22'b0000000000000100000000: n707 = 1'b0;
      22'b0000000000000010000000: n707 = 1'b0;
      22'b0000000000000001000000: n707 = 1'b0;
      22'b0000000000000000100000: n707 = 1'b1;
      22'b0000000000000000010000: n707 = 1'b0;
      22'b0000000000000000001000: n707 = 1'b0;
      22'b0000000000000000000100: n707 = 1'b0;
      22'b0000000000000000000010: n707 = 1'b0;
      22'b0000000000000000000001: n707 = 1'b0;
      default: n707 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n709 = 1'b0;
      22'b0100000000000000000000: n709 = 1'b0;
      22'b0010000000000000000000: n709 = 1'b0;
      22'b0001000000000000000000: n709 = 1'b0;
      22'b0000100000000000000000: n709 = 1'b0;
      22'b0000010000000000000000: n709 = 1'b0;
      22'b0000001000000000000000: n709 = 1'b0;
      22'b0000000100000000000000: n709 = 1'b0;
      22'b0000000010000000000000: n709 = 1'b0;
      22'b0000000001000000000000: n709 = 1'b0;
      22'b0000000000100000000000: n709 = 1'b0;
      22'b0000000000010000000000: n709 = 1'b0;
      22'b0000000000001000000000: n709 = 1'b0;
      22'b0000000000000100000000: n709 = n434;
      22'b0000000000000010000000: n709 = 1'b0;
      22'b0000000000000001000000: n709 = 1'b0;
      22'b0000000000000000100000: n709 = 1'b0;
      22'b0000000000000000010000: n709 = 1'b0;
      22'b0000000000000000001000: n709 = 1'b0;
      22'b0000000000000000000100: n709 = 1'b0;
      22'b0000000000000000000010: n709 = 1'b0;
      22'b0000000000000000000001: n709 = 1'b0;
      default: n709 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n710 = sq2_envsgn;
      22'b0100000000000000000000: n710 = n542;
      22'b0010000000000000000000: n710 = sq2_envsgn;
      22'b0001000000000000000000: n710 = sq2_envsgn;
      22'b0000100000000000000000: n710 = sq2_envsgn;
      22'b0000010000000000000000: n710 = sq2_envsgn;
      22'b0000001000000000000000: n710 = sq2_envsgn;
      22'b0000000100000000000000: n710 = sq2_envsgn;
      22'b0000000010000000000000: n710 = sq2_envsgn;
      22'b0000000001000000000000: n710 = sq2_envsgn;
      22'b0000000000100000000000: n710 = sq2_envsgn;
      22'b0000000000010000000000: n710 = sq2_envsgn;
      22'b0000000000001000000000: n710 = sq2_envsgn;
      22'b0000000000000100000000: n710 = sq2_envsgn;
      22'b0000000000000010000000: n710 = sq2_envsgn;
      22'b0000000000000001000000: n710 = n416;
      22'b0000000000000000100000: n710 = sq2_envsgn;
      22'b0000000000000000010000: n710 = sq2_envsgn;
      22'b0000000000000000001000: n710 = sq2_envsgn;
      22'b0000000000000000000100: n710 = sq2_envsgn;
      22'b0000000000000000000010: n710 = sq2_envsgn;
      22'b0000000000000000000001: n710 = sq2_envsgn;
      default: n710 = sq2_envsgn;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n711 = sq2_envper;
      22'b0100000000000000000000: n711 = n544;
      22'b0010000000000000000000: n711 = sq2_envper;
      22'b0001000000000000000000: n711 = sq2_envper;
      22'b0000100000000000000000: n711 = sq2_envper;
      22'b0000010000000000000000: n711 = sq2_envper;
      22'b0000001000000000000000: n711 = sq2_envper;
      22'b0000000100000000000000: n711 = sq2_envper;
      22'b0000000010000000000000: n711 = sq2_envper;
      22'b0000000001000000000000: n711 = sq2_envper;
      22'b0000000000100000000000: n711 = sq2_envper;
      22'b0000000000010000000000: n711 = sq2_envper;
      22'b0000000000001000000000: n711 = sq2_envper;
      22'b0000000000000100000000: n711 = sq2_envper;
      22'b0000000000000010000000: n711 = sq2_envper;
      22'b0000000000000001000000: n711 = n417;
      22'b0000000000000000100000: n711 = sq2_envper;
      22'b0000000000000000010000: n711 = sq2_envper;
      22'b0000000000000000001000: n711 = sq2_envper;
      22'b0000000000000000000100: n711 = sq2_envper;
      22'b0000000000000000000010: n711 = sq2_envper;
      22'b0000000000000000000001: n711 = sq2_envper;
      default: n711 = sq2_envper;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n712 = sq2_envsgn_old;
      22'b0100000000000000000000: n712 = sq2_envsgn_old;
      22'b0010000000000000000000: n712 = sq2_envsgn_old;
      22'b0001000000000000000000: n712 = sq2_envsgn_old;
      22'b0000100000000000000000: n712 = sq2_envsgn_old;
      22'b0000010000000000000000: n712 = sq2_envsgn_old;
      22'b0000001000000000000000: n712 = sq2_envsgn_old;
      22'b0000000100000000000000: n712 = sq2_envsgn_old;
      22'b0000000010000000000000: n712 = sq2_envsgn_old;
      22'b0000000001000000000000: n712 = sq2_envsgn_old;
      22'b0000000000100000000000: n712 = sq2_envsgn_old;
      22'b0000000000010000000000: n712 = sq2_envsgn_old;
      22'b0000000000001000000000: n712 = sq2_envsgn_old;
      22'b0000000000000100000000: n712 = sq2_envsgn_old;
      22'b0000000000000010000000: n712 = sq2_envsgn_old;
      22'b0000000000000001000000: n712 = sq2_envsgn;
      22'b0000000000000000100000: n712 = sq2_envsgn_old;
      22'b0000000000000000010000: n712 = sq2_envsgn_old;
      22'b0000000000000000001000: n712 = sq2_envsgn_old;
      22'b0000000000000000000100: n712 = sq2_envsgn_old;
      22'b0000000000000000000010: n712 = sq2_envsgn_old;
      22'b0000000000000000000001: n712 = sq2_envsgn_old;
      default: n712 = sq2_envsgn_old;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n713 = sq2_envper_old;
      22'b0100000000000000000000: n713 = sq2_envper_old;
      22'b0010000000000000000000: n713 = sq2_envper_old;
      22'b0001000000000000000000: n713 = sq2_envper_old;
      22'b0000100000000000000000: n713 = sq2_envper_old;
      22'b0000010000000000000000: n713 = sq2_envper_old;
      22'b0000001000000000000000: n713 = sq2_envper_old;
      22'b0000000100000000000000: n713 = sq2_envper_old;
      22'b0000000010000000000000: n713 = sq2_envper_old;
      22'b0000000001000000000000: n713 = sq2_envper_old;
      22'b0000000000100000000000: n713 = sq2_envper_old;
      22'b0000000000010000000000: n713 = sq2_envper_old;
      22'b0000000000001000000000: n713 = sq2_envper_old;
      22'b0000000000000100000000: n713 = sq2_envper_old;
      22'b0000000000000010000000: n713 = sq2_envper_old;
      22'b0000000000000001000000: n713 = sq2_envper;
      22'b0000000000000000100000: n713 = sq2_envper_old;
      22'b0000000000000000010000: n713 = sq2_envper_old;
      22'b0000000000000000001000: n713 = sq2_envper_old;
      22'b0000000000000000000100: n713 = sq2_envper_old;
      22'b0000000000000000000010: n713 = sq2_envper_old;
      22'b0000000000000000000001: n713 = sq2_envper_old;
      default: n713 = sq2_envper_old;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n714 = n546[7:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:110:12 */
  assign n715 = sq2_freq[7:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n716 = n715;
      22'b0100000000000000000000: n716 = n714;
      22'b0010000000000000000000: n716 = n715;
      22'b0001000000000000000000: n716 = n715;
      22'b0000100000000000000000: n716 = n715;
      22'b0000010000000000000000: n716 = n715;
      22'b0000001000000000000000: n716 = n715;
      22'b0000000100000000000000: n716 = n715;
      22'b0000000010000000000000: n716 = n715;
      22'b0000000001000000000000: n716 = n715;
      22'b0000000000100000000000: n716 = n715;
      22'b0000000000010000000000: n716 = n715;
      22'b0000000000001000000000: n716 = n715;
      22'b0000000000000100000000: n716 = n715;
      22'b0000000000000010000000: n716 = s1_writedata;
      22'b0000000000000001000000: n716 = n715;
      22'b0000000000000000100000: n716 = n715;
      22'b0000000000000000010000: n716 = n715;
      22'b0000000000000000001000: n716 = n715;
      22'b0000000000000000000100: n716 = n715;
      22'b0000000000000000000010: n716 = n715;
      22'b0000000000000000000001: n716 = n715;
      default: n716 = n715;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n717 = n546[10:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:110:12 */
  assign n718 = sq2_freq[10:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n719 = n718;
      22'b0100000000000000000000: n719 = n717;
      22'b0010000000000000000000: n719 = n718;
      22'b0001000000000000000000: n719 = n718;
      22'b0000100000000000000000: n719 = n718;
      22'b0000010000000000000000: n719 = n718;
      22'b0000001000000000000000: n719 = n718;
      22'b0000000100000000000000: n719 = n718;
      22'b0000000010000000000000: n719 = n718;
      22'b0000000001000000000000: n719 = n718;
      22'b0000000000100000000000: n719 = n718;
      22'b0000000000010000000000: n719 = n718;
      22'b0000000000001000000000: n719 = n718;
      22'b0000000000000100000000: n719 = n436;
      22'b0000000000000010000000: n719 = n718;
      22'b0000000000000001000000: n719 = n718;
      22'b0000000000000000100000: n719 = n718;
      22'b0000000000000000010000: n719 = n718;
      22'b0000000000000000001000: n719 = n718;
      22'b0000000000000000000100: n719 = n718;
      22'b0000000000000000000010: n719 = n718;
      22'b0000000000000000000001: n719 = n718;
      default: n719 = n718;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n720 = n316;
      22'b0100000000000000000000: n720 = n548;
      22'b0010000000000000000000: n720 = n316;
      22'b0001000000000000000000: n720 = n316;
      22'b0000100000000000000000: n720 = n316;
      22'b0000010000000000000000: n720 = n316;
      22'b0000001000000000000000: n720 = n316;
      22'b0000000100000000000000: n720 = n316;
      22'b0000000010000000000000: n720 = n316;
      22'b0000000001000000000000: n720 = n316;
      22'b0000000000100000000000: n720 = n316;
      22'b0000000000010000000000: n720 = n316;
      22'b0000000000001000000000: n720 = n316;
      22'b0000000000000100000000: n720 = n422;
      22'b0000000000000010000000: n720 = n316;
      22'b0000000000000001000000: n720 = n316;
      22'b0000000000000000100000: n720 = n316;
      22'b0000000000000000010000: n720 = n316;
      22'b0000000000000000001000: n720 = n316;
      22'b0000000000000000000100: n720 = n316;
      22'b0000000000000000000010: n720 = n316;
      22'b0000000000000000000001: n720 = n316;
      default: n720 = n316;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n721 = sq2_lenchk;
      22'b0100000000000000000000: n721 = n550;
      22'b0010000000000000000000: n721 = sq2_lenchk;
      22'b0001000000000000000000: n721 = sq2_lenchk;
      22'b0000100000000000000000: n721 = sq2_lenchk;
      22'b0000010000000000000000: n721 = sq2_lenchk;
      22'b0000001000000000000000: n721 = sq2_lenchk;
      22'b0000000100000000000000: n721 = sq2_lenchk;
      22'b0000000010000000000000: n721 = sq2_lenchk;
      22'b0000000001000000000000: n721 = sq2_lenchk;
      22'b0000000000100000000000: n721 = sq2_lenchk;
      22'b0000000000010000000000: n721 = sq2_lenchk;
      22'b0000000000001000000000: n721 = sq2_lenchk;
      22'b0000000000000100000000: n721 = n435;
      22'b0000000000000010000000: n721 = sq2_lenchk;
      22'b0000000000000001000000: n721 = sq2_lenchk;
      22'b0000000000000000100000: n721 = sq2_lenchk;
      22'b0000000000000000010000: n721 = sq2_lenchk;
      22'b0000000000000000001000: n721 = sq2_lenchk;
      22'b0000000000000000000100: n721 = sq2_lenchk;
      22'b0000000000000000000010: n721 = sq2_lenchk;
      22'b0000000000000000000001: n721 = sq2_lenchk;
      default: n721 = sq2_lenchk;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n722 = wav_enable;
      22'b0100000000000000000000: n722 = n552;
      22'b0010000000000000000000: n722 = wav_enable;
      22'b0001000000000000000000: n722 = wav_enable;
      22'b0000100000000000000000: n722 = wav_enable;
      22'b0000010000000000000000: n722 = wav_enable;
      22'b0000001000000000000000: n722 = wav_enable;
      22'b0000000100000000000000: n722 = wav_enable;
      22'b0000000010000000000000: n722 = wav_enable;
      22'b0000000001000000000000: n722 = wav_enable;
      22'b0000000000100000000000: n722 = wav_enable;
      22'b0000000000010000000000: n722 = wav_enable;
      22'b0000000000001000000000: n722 = n439;
      22'b0000000000000100000000: n722 = wav_enable;
      22'b0000000000000010000000: n722 = wav_enable;
      22'b0000000000000001000000: n722 = wav_enable;
      22'b0000000000000000100000: n722 = wav_enable;
      22'b0000000000000000010000: n722 = wav_enable;
      22'b0000000000000000001000: n722 = wav_enable;
      22'b0000000000000000000100: n722 = wav_enable;
      22'b0000000000000000000010: n722 = wav_enable;
      22'b0000000000000000000001: n722 = wav_enable;
      default: n722 = wav_enable;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n723 = wav_slen;
      22'b0100000000000000000000: n723 = n512;
      22'b0010000000000000000000: n723 = wav_slen;
      22'b0001000000000000000000: n723 = wav_slen;
      22'b0000100000000000000000: n723 = wav_slen;
      22'b0000010000000000000000: n723 = wav_slen;
      22'b0000001000000000000000: n723 = wav_slen;
      22'b0000000100000000000000: n723 = wav_slen;
      22'b0000000010000000000000: n723 = wav_slen;
      22'b0000000001000000000000: n723 = wav_slen;
      22'b0000000000100000000000: n723 = wav_slen;
      22'b0000000000010000000000: n723 = n444;
      22'b0000000000001000000000: n723 = wav_slen;
      22'b0000000000000100000000: n723 = wav_slen;
      22'b0000000000000010000000: n723 = wav_slen;
      22'b0000000000000001000000: n723 = wav_slen;
      22'b0000000000000000100000: n723 = wav_slen;
      22'b0000000000000000010000: n723 = wav_slen;
      22'b0000000000000000001000: n723 = wav_slen;
      22'b0000000000000000000100: n723 = wav_slen;
      22'b0000000000000000000010: n723 = wav_slen;
      22'b0000000000000000000001: n723 = wav_slen;
      default: n723 = wav_slen;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n726 = 1'b0;
      22'b0100000000000000000000: n726 = 1'b0;
      22'b0010000000000000000000: n726 = 1'b0;
      22'b0001000000000000000000: n726 = 1'b0;
      22'b0000100000000000000000: n726 = 1'b0;
      22'b0000010000000000000000: n726 = 1'b0;
      22'b0000001000000000000000: n726 = 1'b0;
      22'b0000000100000000000000: n726 = 1'b0;
      22'b0000000010000000000000: n726 = 1'b0;
      22'b0000000001000000000000: n726 = 1'b0;
      22'b0000000000100000000000: n726 = 1'b0;
      22'b0000000000010000000000: n726 = 1'b1;
      22'b0000000000001000000000: n726 = 1'b0;
      22'b0000000000000100000000: n726 = 1'b0;
      22'b0000000000000010000000: n726 = 1'b0;
      22'b0000000000000001000000: n726 = 1'b0;
      22'b0000000000000000100000: n726 = 1'b0;
      22'b0000000000000000010000: n726 = 1'b0;
      22'b0000000000000000001000: n726 = 1'b0;
      22'b0000000000000000000100: n726 = 1'b0;
      22'b0000000000000000000010: n726 = 1'b0;
      22'b0000000000000000000001: n726 = 1'b0;
      default: n726 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n728 = 1'b0;
      22'b0100000000000000000000: n728 = 1'b0;
      22'b0010000000000000000000: n728 = 1'b0;
      22'b0001000000000000000000: n728 = 1'b0;
      22'b0000100000000000000000: n728 = 1'b0;
      22'b0000010000000000000000: n728 = 1'b0;
      22'b0000001000000000000000: n728 = 1'b0;
      22'b0000000100000000000000: n728 = 1'b0;
      22'b0000000010000000000000: n728 = n462;
      22'b0000000001000000000000: n728 = 1'b0;
      22'b0000000000100000000000: n728 = 1'b0;
      22'b0000000000010000000000: n728 = 1'b0;
      22'b0000000000001000000000: n728 = 1'b0;
      22'b0000000000000100000000: n728 = 1'b0;
      22'b0000000000000010000000: n728 = 1'b0;
      22'b0000000000000001000000: n728 = 1'b0;
      22'b0000000000000000100000: n728 = 1'b0;
      22'b0000000000000000010000: n728 = 1'b0;
      22'b0000000000000000001000: n728 = 1'b0;
      22'b0000000000000000000100: n728 = 1'b0;
      22'b0000000000000000000010: n728 = 1'b0;
      22'b0000000000000000000001: n728 = 1'b0;
      default: n728 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n729 = wav_volsh;
      22'b0100000000000000000000: n729 = n555;
      22'b0010000000000000000000: n729 = wav_volsh;
      22'b0001000000000000000000: n729 = wav_volsh;
      22'b0000100000000000000000: n729 = wav_volsh;
      22'b0000010000000000000000: n729 = wav_volsh;
      22'b0000001000000000000000: n729 = wav_volsh;
      22'b0000000100000000000000: n729 = wav_volsh;
      22'b0000000010000000000000: n729 = wav_volsh;
      22'b0000000001000000000000: n729 = wav_volsh;
      22'b0000000000100000000000: n729 = n447;
      22'b0000000000010000000000: n729 = wav_volsh;
      22'b0000000000001000000000: n729 = wav_volsh;
      22'b0000000000000100000000: n729 = wav_volsh;
      22'b0000000000000010000000: n729 = wav_volsh;
      22'b0000000000000001000000: n729 = wav_volsh;
      22'b0000000000000000100000: n729 = wav_volsh;
      22'b0000000000000000010000: n729 = wav_volsh;
      22'b0000000000000000001000: n729 = wav_volsh;
      22'b0000000000000000000100: n729 = wav_volsh;
      22'b0000000000000000000010: n729 = wav_volsh;
      22'b0000000000000000000001: n729 = wav_volsh;
      default: n729 = wav_volsh;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n730 = n557[7:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:124:12 */
  assign n731 = wav_freq[7:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n732 = n731;
      22'b0100000000000000000000: n732 = n730;
      22'b0010000000000000000000: n732 = n731;
      22'b0001000000000000000000: n732 = n731;
      22'b0000100000000000000000: n732 = n731;
      22'b0000010000000000000000: n732 = n731;
      22'b0000001000000000000000: n732 = n731;
      22'b0000000100000000000000: n732 = n731;
      22'b0000000010000000000000: n732 = n731;
      22'b0000000001000000000000: n732 = s1_writedata;
      22'b0000000000100000000000: n732 = n731;
      22'b0000000000010000000000: n732 = n731;
      22'b0000000000001000000000: n732 = n731;
      22'b0000000000000100000000: n732 = n731;
      22'b0000000000000010000000: n732 = n731;
      22'b0000000000000001000000: n732 = n731;
      22'b0000000000000000100000: n732 = n731;
      22'b0000000000000000010000: n732 = n731;
      22'b0000000000000000001000: n732 = n731;
      22'b0000000000000000000100: n732 = n731;
      22'b0000000000000000000010: n732 = n731;
      22'b0000000000000000000001: n732 = n731;
      default: n732 = n731;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:620:57 */
  assign n733 = n557[10:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:124:12 */
  assign n734 = wav_freq[10:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n735 = n734;
      22'b0100000000000000000000: n735 = n733;
      22'b0010000000000000000000: n735 = n734;
      22'b0001000000000000000000: n735 = n734;
      22'b0000100000000000000000: n735 = n734;
      22'b0000010000000000000000: n735 = n734;
      22'b0000001000000000000000: n735 = n734;
      22'b0000000100000000000000: n735 = n734;
      22'b0000000010000000000000: n735 = n464;
      22'b0000000001000000000000: n735 = n734;
      22'b0000000000100000000000: n735 = n734;
      22'b0000000000010000000000: n735 = n734;
      22'b0000000000001000000000: n735 = n734;
      22'b0000000000000100000000: n735 = n734;
      22'b0000000000000010000000: n735 = n734;
      22'b0000000000000001000000: n735 = n734;
      22'b0000000000000000100000: n735 = n734;
      22'b0000000000000000010000: n735 = n734;
      22'b0000000000000000001000: n735 = n734;
      22'b0000000000000000000100: n735 = n734;
      22'b0000000000000000000010: n735 = n734;
      22'b0000000000000000000001: n735 = n734;
      default: n735 = n734;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n736 = n323;
      22'b0100000000000000000000: n736 = n559;
      22'b0010000000000000000000: n736 = n323;
      22'b0001000000000000000000: n736 = n323;
      22'b0000100000000000000000: n736 = n323;
      22'b0000010000000000000000: n736 = n323;
      22'b0000001000000000000000: n736 = n323;
      22'b0000000100000000000000: n736 = n323;
      22'b0000000010000000000000: n736 = n452;
      22'b0000000001000000000000: n736 = n323;
      22'b0000000000100000000000: n736 = n323;
      22'b0000000000010000000000: n736 = n323;
      22'b0000000000001000000000: n736 = n323;
      22'b0000000000000100000000: n736 = n323;
      22'b0000000000000010000000: n736 = n323;
      22'b0000000000000001000000: n736 = n323;
      22'b0000000000000000100000: n736 = n323;
      22'b0000000000000000010000: n736 = n323;
      22'b0000000000000000001000: n736 = n323;
      22'b0000000000000000000100: n736 = n323;
      22'b0000000000000000000010: n736 = n323;
      22'b0000000000000000000001: n736 = n323;
      default: n736 = n323;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n737 = wav_lenchk;
      22'b0100000000000000000000: n737 = n561;
      22'b0010000000000000000000: n737 = wav_lenchk;
      22'b0001000000000000000000: n737 = wav_lenchk;
      22'b0000100000000000000000: n737 = wav_lenchk;
      22'b0000010000000000000000: n737 = wav_lenchk;
      22'b0000001000000000000000: n737 = wav_lenchk;
      22'b0000000100000000000000: n737 = wav_lenchk;
      22'b0000000010000000000000: n737 = n463;
      22'b0000000001000000000000: n737 = wav_lenchk;
      22'b0000000000100000000000: n737 = wav_lenchk;
      22'b0000000000010000000000: n737 = wav_lenchk;
      22'b0000000000001000000000: n737 = wav_lenchk;
      22'b0000000000000100000000: n737 = wav_lenchk;
      22'b0000000000000010000000: n737 = wav_lenchk;
      22'b0000000000000001000000: n737 = wav_lenchk;
      22'b0000000000000000100000: n737 = wav_lenchk;
      22'b0000000000000000010000: n737 = wav_lenchk;
      22'b0000000000000000001000: n737 = wav_lenchk;
      22'b0000000000000000000100: n737 = wav_lenchk;
      22'b0000000000000000000010: n737 = wav_lenchk;
      22'b0000000000000000000001: n737 = wav_lenchk;
      default: n737 = wav_lenchk;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n738 = n620;
      22'b0100000000000000000000: n738 = wav_ram;
      22'b0010000000000000000000: n738 = wav_ram;
      22'b0001000000000000000000: n738 = wav_ram;
      22'b0000100000000000000000: n738 = wav_ram;
      22'b0000010000000000000000: n738 = wav_ram;
      22'b0000001000000000000000: n738 = wav_ram;
      22'b0000000100000000000000: n738 = wav_ram;
      22'b0000000010000000000000: n738 = wav_ram;
      22'b0000000001000000000000: n738 = wav_ram;
      22'b0000000000100000000000: n738 = wav_ram;
      22'b0000000000010000000000: n738 = wav_ram;
      22'b0000000000001000000000: n738 = wav_ram;
      22'b0000000000000100000000: n738 = wav_ram;
      22'b0000000000000010000000: n738 = wav_ram;
      22'b0000000000000001000000: n738 = wav_ram;
      22'b0000000000000000100000: n738 = wav_ram;
      22'b0000000000000000010000: n738 = wav_ram;
      22'b0000000000000000001000: n738 = wav_ram;
      22'b0000000000000000000100: n738 = wav_ram;
      22'b0000000000000000000010: n738 = wav_ram;
      22'b0000000000000000000001: n738 = wav_ram;
      default: n738 = wav_ram;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n739 = noi_slen;
      22'b0100000000000000000000: n739 = n514;
      22'b0010000000000000000000: n739 = noi_slen;
      22'b0001000000000000000000: n739 = noi_slen;
      22'b0000100000000000000000: n739 = noi_slen;
      22'b0000010000000000000000: n739 = noi_slen;
      22'b0000001000000000000000: n739 = noi_slen;
      22'b0000000100000000000000: n739 = n470;
      22'b0000000010000000000000: n739 = noi_slen;
      22'b0000000001000000000000: n739 = noi_slen;
      22'b0000000000100000000000: n739 = noi_slen;
      22'b0000000000010000000000: n739 = noi_slen;
      22'b0000000000001000000000: n739 = noi_slen;
      22'b0000000000000100000000: n739 = noi_slen;
      22'b0000000000000010000000: n739 = noi_slen;
      22'b0000000000000001000000: n739 = noi_slen;
      22'b0000000000000000100000: n739 = noi_slen;
      22'b0000000000000000010000: n739 = noi_slen;
      22'b0000000000000000001000: n739 = noi_slen;
      22'b0000000000000000000100: n739 = noi_slen;
      22'b0000000000000000000010: n739 = noi_slen;
      22'b0000000000000000000001: n739 = noi_slen;
      default: n739 = noi_slen;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n742 = 1'b0;
      22'b0100000000000000000000: n742 = 1'b0;
      22'b0010000000000000000000: n742 = 1'b0;
      22'b0001000000000000000000: n742 = 1'b0;
      22'b0000100000000000000000: n742 = 1'b0;
      22'b0000010000000000000000: n742 = 1'b0;
      22'b0000001000000000000000: n742 = 1'b0;
      22'b0000000100000000000000: n742 = 1'b1;
      22'b0000000010000000000000: n742 = 1'b0;
      22'b0000000001000000000000: n742 = 1'b0;
      22'b0000000000100000000000: n742 = 1'b0;
      22'b0000000000010000000000: n742 = 1'b0;
      22'b0000000000001000000000: n742 = 1'b0;
      22'b0000000000000100000000: n742 = 1'b0;
      22'b0000000000000010000000: n742 = 1'b0;
      22'b0000000000000001000000: n742 = 1'b0;
      22'b0000000000000000100000: n742 = 1'b0;
      22'b0000000000000000010000: n742 = 1'b0;
      22'b0000000000000000001000: n742 = 1'b0;
      22'b0000000000000000000100: n742 = 1'b0;
      22'b0000000000000000000010: n742 = 1'b0;
      22'b0000000000000000000001: n742 = 1'b0;
      default: n742 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n744 = 1'b0;
      22'b0100000000000000000000: n744 = 1'b0;
      22'b0010000000000000000000: n744 = 1'b0;
      22'b0001000000000000000000: n744 = 1'b0;
      22'b0000100000000000000000: n744 = n496;
      22'b0000010000000000000000: n744 = 1'b0;
      22'b0000001000000000000000: n744 = 1'b0;
      22'b0000000100000000000000: n744 = 1'b0;
      22'b0000000010000000000000: n744 = 1'b0;
      22'b0000000001000000000000: n744 = 1'b0;
      22'b0000000000100000000000: n744 = 1'b0;
      22'b0000000000010000000000: n744 = 1'b0;
      22'b0000000000001000000000: n744 = 1'b0;
      22'b0000000000000100000000: n744 = 1'b0;
      22'b0000000000000010000000: n744 = 1'b0;
      22'b0000000000000001000000: n744 = 1'b0;
      22'b0000000000000000100000: n744 = 1'b0;
      22'b0000000000000000010000: n744 = 1'b0;
      22'b0000000000000000001000: n744 = 1'b0;
      22'b0000000000000000000100: n744 = 1'b0;
      22'b0000000000000000000010: n744 = 1'b0;
      22'b0000000000000000000001: n744 = 1'b0;
      default: n744 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n745 = noi_svol;
      22'b0100000000000000000000: n745 = n564;
      22'b0010000000000000000000: n745 = noi_svol;
      22'b0001000000000000000000: n745 = noi_svol;
      22'b0000100000000000000000: n745 = noi_svol;
      22'b0000010000000000000000: n745 = noi_svol;
      22'b0000001000000000000000: n745 = n473;
      22'b0000000100000000000000: n745 = noi_svol;
      22'b0000000010000000000000: n745 = noi_svol;
      22'b0000000001000000000000: n745 = noi_svol;
      22'b0000000000100000000000: n745 = noi_svol;
      22'b0000000000010000000000: n745 = noi_svol;
      22'b0000000000001000000000: n745 = noi_svol;
      22'b0000000000000100000000: n745 = noi_svol;
      22'b0000000000000010000000: n745 = noi_svol;
      22'b0000000000000001000000: n745 = noi_svol;
      22'b0000000000000000100000: n745 = noi_svol;
      22'b0000000000000000010000: n745 = noi_svol;
      22'b0000000000000000001000: n745 = noi_svol;
      22'b0000000000000000000100: n745 = noi_svol;
      22'b0000000000000000000010: n745 = noi_svol;
      22'b0000000000000000000001: n745 = noi_svol;
      default: n745 = noi_svol;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n748 = 1'b0;
      22'b0100000000000000000000: n748 = 1'b0;
      22'b0010000000000000000000: n748 = 1'b0;
      22'b0001000000000000000000: n748 = 1'b0;
      22'b0000100000000000000000: n748 = 1'b0;
      22'b0000010000000000000000: n748 = 1'b0;
      22'b0000001000000000000000: n748 = 1'b1;
      22'b0000000100000000000000: n748 = 1'b0;
      22'b0000000010000000000000: n748 = 1'b0;
      22'b0000000001000000000000: n748 = 1'b0;
      22'b0000000000100000000000: n748 = 1'b0;
      22'b0000000000010000000000: n748 = 1'b0;
      22'b0000000000001000000000: n748 = 1'b0;
      22'b0000000000000100000000: n748 = 1'b0;
      22'b0000000000000010000000: n748 = 1'b0;
      22'b0000000000000001000000: n748 = 1'b0;
      22'b0000000000000000100000: n748 = 1'b0;
      22'b0000000000000000010000: n748 = 1'b0;
      22'b0000000000000000001000: n748 = 1'b0;
      22'b0000000000000000000100: n748 = 1'b0;
      22'b0000000000000000000010: n748 = 1'b0;
      22'b0000000000000000000001: n748 = 1'b0;
      default: n748 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n749 = noi_envsgn;
      22'b0100000000000000000000: n749 = n566;
      22'b0010000000000000000000: n749 = noi_envsgn;
      22'b0001000000000000000000: n749 = noi_envsgn;
      22'b0000100000000000000000: n749 = noi_envsgn;
      22'b0000010000000000000000: n749 = noi_envsgn;
      22'b0000001000000000000000: n749 = n474;
      22'b0000000100000000000000: n749 = noi_envsgn;
      22'b0000000010000000000000: n749 = noi_envsgn;
      22'b0000000001000000000000: n749 = noi_envsgn;
      22'b0000000000100000000000: n749 = noi_envsgn;
      22'b0000000000010000000000: n749 = noi_envsgn;
      22'b0000000000001000000000: n749 = noi_envsgn;
      22'b0000000000000100000000: n749 = noi_envsgn;
      22'b0000000000000010000000: n749 = noi_envsgn;
      22'b0000000000000001000000: n749 = noi_envsgn;
      22'b0000000000000000100000: n749 = noi_envsgn;
      22'b0000000000000000010000: n749 = noi_envsgn;
      22'b0000000000000000001000: n749 = noi_envsgn;
      22'b0000000000000000000100: n749 = noi_envsgn;
      22'b0000000000000000000010: n749 = noi_envsgn;
      22'b0000000000000000000001: n749 = noi_envsgn;
      default: n749 = noi_envsgn;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n750 = noi_envper;
      22'b0100000000000000000000: n750 = n568;
      22'b0010000000000000000000: n750 = noi_envper;
      22'b0001000000000000000000: n750 = noi_envper;
      22'b0000100000000000000000: n750 = noi_envper;
      22'b0000010000000000000000: n750 = noi_envper;
      22'b0000001000000000000000: n750 = n475;
      22'b0000000100000000000000: n750 = noi_envper;
      22'b0000000010000000000000: n750 = noi_envper;
      22'b0000000001000000000000: n750 = noi_envper;
      22'b0000000000100000000000: n750 = noi_envper;
      22'b0000000000010000000000: n750 = noi_envper;
      22'b0000000000001000000000: n750 = noi_envper;
      22'b0000000000000100000000: n750 = noi_envper;
      22'b0000000000000010000000: n750 = noi_envper;
      22'b0000000000000001000000: n750 = noi_envper;
      22'b0000000000000000100000: n750 = noi_envper;
      22'b0000000000000000010000: n750 = noi_envper;
      22'b0000000000000000001000: n750 = noi_envper;
      22'b0000000000000000000100: n750 = noi_envper;
      22'b0000000000000000000010: n750 = noi_envper;
      22'b0000000000000000000001: n750 = noi_envper;
      default: n750 = noi_envper;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n751 = noi_envsgn_old;
      22'b0100000000000000000000: n751 = noi_envsgn_old;
      22'b0010000000000000000000: n751 = noi_envsgn_old;
      22'b0001000000000000000000: n751 = noi_envsgn_old;
      22'b0000100000000000000000: n751 = noi_envsgn_old;
      22'b0000010000000000000000: n751 = noi_envsgn_old;
      22'b0000001000000000000000: n751 = noi_envsgn;
      22'b0000000100000000000000: n751 = noi_envsgn_old;
      22'b0000000010000000000000: n751 = noi_envsgn_old;
      22'b0000000001000000000000: n751 = noi_envsgn_old;
      22'b0000000000100000000000: n751 = noi_envsgn_old;
      22'b0000000000010000000000: n751 = noi_envsgn_old;
      22'b0000000000001000000000: n751 = noi_envsgn_old;
      22'b0000000000000100000000: n751 = noi_envsgn_old;
      22'b0000000000000010000000: n751 = noi_envsgn_old;
      22'b0000000000000001000000: n751 = noi_envsgn_old;
      22'b0000000000000000100000: n751 = noi_envsgn_old;
      22'b0000000000000000010000: n751 = noi_envsgn_old;
      22'b0000000000000000001000: n751 = noi_envsgn_old;
      22'b0000000000000000000100: n751 = noi_envsgn_old;
      22'b0000000000000000000010: n751 = noi_envsgn_old;
      22'b0000000000000000000001: n751 = noi_envsgn_old;
      default: n751 = noi_envsgn_old;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n752 = noi_envper_old;
      22'b0100000000000000000000: n752 = noi_envper_old;
      22'b0010000000000000000000: n752 = noi_envper_old;
      22'b0001000000000000000000: n752 = noi_envper_old;
      22'b0000100000000000000000: n752 = noi_envper_old;
      22'b0000010000000000000000: n752 = noi_envper_old;
      22'b0000001000000000000000: n752 = noi_envper;
      22'b0000000100000000000000: n752 = noi_envper_old;
      22'b0000000010000000000000: n752 = noi_envper_old;
      22'b0000000001000000000000: n752 = noi_envper_old;
      22'b0000000000100000000000: n752 = noi_envper_old;
      22'b0000000000010000000000: n752 = noi_envper_old;
      22'b0000000000001000000000: n752 = noi_envper_old;
      22'b0000000000000100000000: n752 = noi_envper_old;
      22'b0000000000000010000000: n752 = noi_envper_old;
      22'b0000000000000001000000: n752 = noi_envper_old;
      22'b0000000000000000100000: n752 = noi_envper_old;
      22'b0000000000000000010000: n752 = noi_envper_old;
      22'b0000000000000000001000: n752 = noi_envper_old;
      22'b0000000000000000000100: n752 = noi_envper_old;
      22'b0000000000000000000010: n752 = noi_envper_old;
      22'b0000000000000000000001: n752 = noi_envper_old;
      default: n752 = noi_envper_old;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n753 = noi_freqsh;
      22'b0100000000000000000000: n753 = n570;
      22'b0010000000000000000000: n753 = noi_freqsh;
      22'b0001000000000000000000: n753 = noi_freqsh;
      22'b0000100000000000000000: n753 = noi_freqsh;
      22'b0000010000000000000000: n753 = n478;
      22'b0000001000000000000000: n753 = noi_freqsh;
      22'b0000000100000000000000: n753 = noi_freqsh;
      22'b0000000010000000000000: n753 = noi_freqsh;
      22'b0000000001000000000000: n753 = noi_freqsh;
      22'b0000000000100000000000: n753 = noi_freqsh;
      22'b0000000000010000000000: n753 = noi_freqsh;
      22'b0000000000001000000000: n753 = noi_freqsh;
      22'b0000000000000100000000: n753 = noi_freqsh;
      22'b0000000000000010000000: n753 = noi_freqsh;
      22'b0000000000000001000000: n753 = noi_freqsh;
      22'b0000000000000000100000: n753 = noi_freqsh;
      22'b0000000000000000010000: n753 = noi_freqsh;
      22'b0000000000000000001000: n753 = noi_freqsh;
      22'b0000000000000000000100: n753 = noi_freqsh;
      22'b0000000000000000000010: n753 = noi_freqsh;
      22'b0000000000000000000001: n753 = noi_freqsh;
      default: n753 = noi_freqsh;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n756 = 1'b0;
      22'b0100000000000000000000: n756 = 1'b0;
      22'b0010000000000000000000: n756 = 1'b0;
      22'b0001000000000000000000: n756 = 1'b0;
      22'b0000100000000000000000: n756 = 1'b0;
      22'b0000010000000000000000: n756 = 1'b1;
      22'b0000001000000000000000: n756 = 1'b0;
      22'b0000000100000000000000: n756 = 1'b0;
      22'b0000000010000000000000: n756 = 1'b0;
      22'b0000000001000000000000: n756 = 1'b0;
      22'b0000000000100000000000: n756 = 1'b0;
      22'b0000000000010000000000: n756 = 1'b0;
      22'b0000000000001000000000: n756 = 1'b0;
      22'b0000000000000100000000: n756 = 1'b0;
      22'b0000000000000010000000: n756 = 1'b0;
      22'b0000000000000001000000: n756 = 1'b0;
      22'b0000000000000000100000: n756 = 1'b0;
      22'b0000000000000000010000: n756 = 1'b0;
      22'b0000000000000000001000: n756 = 1'b0;
      22'b0000000000000000000100: n756 = 1'b0;
      22'b0000000000000000000010: n756 = 1'b0;
      22'b0000000000000000000001: n756 = 1'b0;
      default: n756 = 1'b0;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n757 = noi_short;
      22'b0100000000000000000000: n757 = n572;
      22'b0010000000000000000000: n757 = noi_short;
      22'b0001000000000000000000: n757 = noi_short;
      22'b0000100000000000000000: n757 = noi_short;
      22'b0000010000000000000000: n757 = n479;
      22'b0000001000000000000000: n757 = noi_short;
      22'b0000000100000000000000: n757 = noi_short;
      22'b0000000010000000000000: n757 = noi_short;
      22'b0000000001000000000000: n757 = noi_short;
      22'b0000000000100000000000: n757 = noi_short;
      22'b0000000000010000000000: n757 = noi_short;
      22'b0000000000001000000000: n757 = noi_short;
      22'b0000000000000100000000: n757 = noi_short;
      22'b0000000000000010000000: n757 = noi_short;
      22'b0000000000000001000000: n757 = noi_short;
      22'b0000000000000000100000: n757 = noi_short;
      22'b0000000000000000010000: n757 = noi_short;
      22'b0000000000000000001000: n757 = noi_short;
      22'b0000000000000000000100: n757 = noi_short;
      22'b0000000000000000000010: n757 = noi_short;
      22'b0000000000000000000001: n757 = noi_short;
      default: n757 = noi_short;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n758 = noi_div;
      22'b0100000000000000000000: n758 = n574;
      22'b0010000000000000000000: n758 = noi_div;
      22'b0001000000000000000000: n758 = noi_div;
      22'b0000100000000000000000: n758 = noi_div;
      22'b0000010000000000000000: n758 = n480;
      22'b0000001000000000000000: n758 = noi_div;
      22'b0000000100000000000000: n758 = noi_div;
      22'b0000000010000000000000: n758 = noi_div;
      22'b0000000001000000000000: n758 = noi_div;
      22'b0000000000100000000000: n758 = noi_div;
      22'b0000000000010000000000: n758 = noi_div;
      22'b0000000000001000000000: n758 = noi_div;
      22'b0000000000000100000000: n758 = noi_div;
      22'b0000000000000010000000: n758 = noi_div;
      22'b0000000000000001000000: n758 = noi_div;
      22'b0000000000000000100000: n758 = noi_div;
      22'b0000000000000000010000: n758 = noi_div;
      22'b0000000000000000001000: n758 = noi_div;
      22'b0000000000000000000100: n758 = noi_div;
      22'b0000000000000000000010: n758 = noi_div;
      22'b0000000000000000000001: n758 = noi_div;
      default: n758 = noi_div;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n759 = n330;
      22'b0100000000000000000000: n759 = n576;
      22'b0010000000000000000000: n759 = n330;
      22'b0001000000000000000000: n759 = n330;
      22'b0000100000000000000000: n759 = n483;
      22'b0000010000000000000000: n759 = n330;
      22'b0000001000000000000000: n759 = n330;
      22'b0000000100000000000000: n759 = n330;
      22'b0000000010000000000000: n759 = n330;
      22'b0000000001000000000000: n759 = n330;
      22'b0000000000100000000000: n759 = n330;
      22'b0000000000010000000000: n759 = n330;
      22'b0000000000001000000000: n759 = n330;
      22'b0000000000000100000000: n759 = n330;
      22'b0000000000000010000000: n759 = n330;
      22'b0000000000000001000000: n759 = n330;
      22'b0000000000000000100000: n759 = n330;
      22'b0000000000000000010000: n759 = n330;
      22'b0000000000000000001000: n759 = n330;
      22'b0000000000000000000100: n759 = n330;
      22'b0000000000000000000010: n759 = n330;
      22'b0000000000000000000001: n759 = n330;
      default: n759 = n330;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n760 = noi_lenchk;
      22'b0100000000000000000000: n760 = n578;
      22'b0010000000000000000000: n760 = noi_lenchk;
      22'b0001000000000000000000: n760 = noi_lenchk;
      22'b0000100000000000000000: n760 = n497;
      22'b0000010000000000000000: n760 = noi_lenchk;
      22'b0000001000000000000000: n760 = noi_lenchk;
      22'b0000000100000000000000: n760 = noi_lenchk;
      22'b0000000010000000000000: n760 = noi_lenchk;
      22'b0000000001000000000000: n760 = noi_lenchk;
      22'b0000000000100000000000: n760 = noi_lenchk;
      22'b0000000000010000000000: n760 = noi_lenchk;
      22'b0000000000001000000000: n760 = noi_lenchk;
      22'b0000000000000100000000: n760 = noi_lenchk;
      22'b0000000000000010000000: n760 = noi_lenchk;
      22'b0000000000000001000000: n760 = noi_lenchk;
      22'b0000000000000000100000: n760 = noi_lenchk;
      22'b0000000000000000010000: n760 = noi_lenchk;
      22'b0000000000000000001000: n760 = noi_lenchk;
      22'b0000000000000000000100: n760 = noi_lenchk;
      22'b0000000000000000000010: n760 = noi_lenchk;
      22'b0000000000000000000001: n760 = noi_lenchk;
      default: n760 = noi_lenchk;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n761 = ch_map;
      22'b0100000000000000000000: n761 = n580;
      22'b0010000000000000000000: n761 = s1_writedata;
      22'b0001000000000000000000: n761 = ch_map;
      22'b0000100000000000000000: n761 = ch_map;
      22'b0000010000000000000000: n761 = ch_map;
      22'b0000001000000000000000: n761 = ch_map;
      22'b0000000100000000000000: n761 = ch_map;
      22'b0000000010000000000000: n761 = ch_map;
      22'b0000000001000000000000: n761 = ch_map;
      22'b0000000000100000000000: n761 = ch_map;
      22'b0000000000010000000000: n761 = ch_map;
      22'b0000000000001000000000: n761 = ch_map;
      22'b0000000000000100000000: n761 = ch_map;
      22'b0000000000000010000000: n761 = ch_map;
      22'b0000000000000001000000: n761 = ch_map;
      22'b0000000000000000100000: n761 = ch_map;
      22'b0000000000000000010000: n761 = ch_map;
      22'b0000000000000000001000: n761 = ch_map;
      22'b0000000000000000000100: n761 = ch_map;
      22'b0000000000000000000010: n761 = ch_map;
      22'b0000000000000000000001: n761 = ch_map;
      default: n761 = ch_map;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n762 = ch_vol;
      22'b0100000000000000000000: n762 = n582;
      22'b0010000000000000000000: n762 = ch_vol;
      22'b0001000000000000000000: n762 = s1_writedata;
      22'b0000100000000000000000: n762 = ch_vol;
      22'b0000010000000000000000: n762 = ch_vol;
      22'b0000001000000000000000: n762 = ch_vol;
      22'b0000000100000000000000: n762 = ch_vol;
      22'b0000000010000000000000: n762 = ch_vol;
      22'b0000000001000000000000: n762 = ch_vol;
      22'b0000000000100000000000: n762 = ch_vol;
      22'b0000000000010000000000: n762 = ch_vol;
      22'b0000000000001000000000: n762 = ch_vol;
      22'b0000000000000100000000: n762 = ch_vol;
      22'b0000000000000010000000: n762 = ch_vol;
      22'b0000000000000001000000: n762 = ch_vol;
      22'b0000000000000000100000: n762 = ch_vol;
      22'b0000000000000000010000: n762 = ch_vol;
      22'b0000000000000000001000: n762 = ch_vol;
      22'b0000000000000000000100: n762 = ch_vol;
      22'b0000000000000000000010: n762 = ch_vol;
      22'b0000000000000000000001: n762 = ch_vol;
      default: n762 = ch_vol;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n763 = s1_write;
      22'b0100000000000000000000: n763 = n584;
      22'b0010000000000000000000: n763 = s1_write;
      22'b0001000000000000000000: n763 = s1_write;
      22'b0000100000000000000000: n763 = s1_write;
      22'b0000010000000000000000: n763 = s1_write;
      22'b0000001000000000000000: n763 = s1_write;
      22'b0000000100000000000000: n763 = s1_write;
      22'b0000000010000000000000: n763 = s1_write;
      22'b0000000001000000000000: n763 = s1_write;
      22'b0000000000100000000000: n763 = s1_write;
      22'b0000000000010000000000: n763 = s1_write;
      22'b0000000000001000000000: n763 = s1_write;
      22'b0000000000000100000000: n763 = s1_write;
      22'b0000000000000010000000: n763 = s1_write;
      22'b0000000000000001000000: n763 = s1_write;
      22'b0000000000000000100000: n763 = s1_write;
      22'b0000000000000000010000: n763 = s1_write;
      22'b0000000000000000001000: n763 = s1_write;
      22'b0000000000000000000100: n763 = s1_write;
      22'b0000000000000000000010: n763 = s1_write;
      22'b0000000000000000000001: n763 = s1_write;
      default: n763 = s1_write;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n764 = n336;
      22'b0100000000000000000000: n764 = n586;
      22'b0010000000000000000000: n764 = n336;
      22'b0001000000000000000000: n764 = n336;
      22'b0000100000000000000000: n764 = n336;
      22'b0000010000000000000000: n764 = n336;
      22'b0000001000000000000000: n764 = n336;
      22'b0000000100000000000000: n764 = n336;
      22'b0000000010000000000000: n764 = n336;
      22'b0000000001000000000000: n764 = n336;
      22'b0000000000100000000000: n764 = n336;
      22'b0000000000010000000000: n764 = n336;
      22'b0000000000001000000000: n764 = n336;
      22'b0000000000000100000000: n764 = n336;
      22'b0000000000000010000000: n764 = n336;
      22'b0000000000000001000000: n764 = n336;
      22'b0000000000000000100000: n764 = n336;
      22'b0000000000000000010000: n764 = n395;
      22'b0000000000000000001000: n764 = n336;
      22'b0000000000000000000100: n764 = n336;
      22'b0000000000000000000010: n764 = n336;
      22'b0000000000000000000001: n764 = n336;
      default: n764 = n336;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n765 = n337;
      22'b0100000000000000000000: n765 = n588;
      22'b0010000000000000000000: n765 = n337;
      22'b0001000000000000000000: n765 = n337;
      22'b0000100000000000000000: n765 = n337;
      22'b0000010000000000000000: n765 = n337;
      22'b0000001000000000000000: n765 = n337;
      22'b0000000100000000000000: n765 = n337;
      22'b0000000010000000000000: n765 = n337;
      22'b0000000001000000000000: n765 = n337;
      22'b0000000000100000000000: n765 = n337;
      22'b0000000000010000000000: n765 = n337;
      22'b0000000000001000000000: n765 = n337;
      22'b0000000000000100000000: n765 = n427;
      22'b0000000000000010000000: n765 = n337;
      22'b0000000000000001000000: n765 = n337;
      22'b0000000000000000100000: n765 = n337;
      22'b0000000000000000010000: n765 = n337;
      22'b0000000000000000001000: n765 = n337;
      22'b0000000000000000000100: n765 = n337;
      22'b0000000000000000000010: n765 = n337;
      22'b0000000000000000000001: n765 = n337;
      default: n765 = n337;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n766 = n338;
      22'b0100000000000000000000: n766 = n590;
      22'b0010000000000000000000: n766 = n338;
      22'b0001000000000000000000: n766 = n338;
      22'b0000100000000000000000: n766 = n489;
      22'b0000010000000000000000: n766 = n338;
      22'b0000001000000000000000: n766 = n338;
      22'b0000000100000000000000: n766 = n338;
      22'b0000000010000000000000: n766 = n338;
      22'b0000000001000000000000: n766 = n338;
      22'b0000000000100000000000: n766 = n338;
      22'b0000000000010000000000: n766 = n338;
      22'b0000000000001000000000: n766 = n338;
      22'b0000000000000100000000: n766 = n338;
      22'b0000000000000010000000: n766 = n338;
      22'b0000000000000001000000: n766 = n338;
      22'b0000000000000000100000: n766 = n338;
      22'b0000000000000000010000: n766 = n338;
      22'b0000000000000000001000: n766 = n338;
      22'b0000000000000000000100: n766 = n338;
      22'b0000000000000000000010: n766 = n338;
      22'b0000000000000000000001: n766 = n338;
      default: n766 = n338;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:484:41 */
  always @*
    case (n669)
      22'b1000000000000000000000: n767 = n339;
      22'b0100000000000000000000: n767 = n592;
      22'b0010000000000000000000: n767 = n339;
      22'b0001000000000000000000: n767 = n339;
      22'b0000100000000000000000: n767 = n339;
      22'b0000010000000000000000: n767 = n339;
      22'b0000001000000000000000: n767 = n339;
      22'b0000000100000000000000: n767 = n339;
      22'b0000000010000000000000: n767 = n455;
      22'b0000000001000000000000: n767 = n339;
      22'b0000000000100000000000: n767 = n339;
      22'b0000000000010000000000: n767 = n339;
      22'b0000000000001000000000: n767 = n339;
      22'b0000000000000100000000: n767 = n339;
      22'b0000000000000010000000: n767 = n339;
      22'b0000000000000001000000: n767 = n339;
      22'b0000000000000000100000: n767 = n339;
      22'b0000000000000000010000: n767 = n339;
      22'b0000000000000000001000: n767 = n339;
      22'b0000000000000000000100: n767 = n339;
      22'b0000000000000000000010: n767 = n339;
      22'b0000000000000000000001: n767 = n339;
      default: n767 = n339;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n770 = n863 ? n670 : snd_enable;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n771 = n864 ? n671 : sq1_swper;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n772 = n865 ? n672 : sq1_swdir;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n774 = n364 ? n674 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n776 = n867 ? n675 : sq1_swshift;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n777 = n868 ? n676 : sq1_duty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n778 = n869 ? n677 : sq1_slen;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n779 = n870 ? n678 : sq1_svol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n780 = n871 ? n679 : sq1_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n781 = n872 ? n680 : sq1_envsgn_old;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n782 = n873 ? n681 : sq1_envper;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n783 = n874 ? n682 : sq1_envper_old;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n784 = {n688, n685};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n785 = n364 ? n784 : n340;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n786 = n364 ? n689 : n309;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n787 = n877 ? n690 : sq1_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n789 = n364 ? n693 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n792 = n364 ? n696 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n795 = n364 ? n698 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n797 = n881 ? n699 : sq2_duty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n798 = n882 ? n700 : sq2_slen;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n799 = n883 ? n701 : sq2_svol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n801 = n364 ? n704 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n804 = n364 ? n707 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n807 = n364 ? n709 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n809 = n887 ? n710 : sq2_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n810 = n888 ? n711 : sq2_envper;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n811 = n889 ? n712 : sq2_envsgn_old;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n812 = n890 ? n713 : sq2_envper_old;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n813 = {n719, n716};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n814 = n891 ? n813 : sq2_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n815 = n364 ? n720 : n316;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n816 = n893 ? n721 : sq2_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n817 = n894 ? n722 : wav_enable;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n818 = n895 ? n723 : wav_slen;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n820 = n364 ? n726 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n823 = n364 ? n728 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n825 = n898 ? n729 : wav_volsh;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n826 = {n735, n732};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n827 = n899 ? n826 : wav_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n828 = n364 ? n736 : n323;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n829 = n901 ? n737 : wav_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n830 = n902 ? n738 : wav_ram;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n831 = n903 ? n739 : noi_slen;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n833 = n364 ? n742 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n836 = n364 ? n744 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n838 = n906 ? n745 : noi_svol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n840 = n364 ? n748 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n842 = n908 ? n749 : noi_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n843 = n909 ? n750 : noi_envper;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n844 = n910 ? n751 : noi_envsgn_old;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n845 = n911 ? n752 : noi_envper_old;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n846 = n912 ? n753 : noi_freqsh;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n848 = n364 ? n756 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n850 = n914 ? n757 : noi_short;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n851 = n915 ? n758 : noi_div;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n852 = n364 ? n759 : n330;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n853 = n917 ? n760 : noi_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n854 = n918 ? n761 : ch_map;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n855 = n919 ? n762 : ch_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n856 = n364 ? n763 : s1_write;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n857 = n364 ? n764 : n336;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n858 = n364 ? n765 : n337;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n859 = n364 ? n766 : n338;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:483:33 */
  assign n860 = n364 ? n767 : n339;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n863 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n864 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n865 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n866 = ce ? n774 : sq1_swdir_change;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n867 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n868 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n869 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n870 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n871 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n872 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n873 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n874 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n875 = ce ? n785 : sq1_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n876 = ce ? n786 : sq1_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n877 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n878 = ce ? n789 : sq1_nr2change;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n879 = ce ? n792 : sq1_lenchange;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n880 = ce ? n795 : sq1_lenquirk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n881 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n882 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n883 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n884 = ce ? n801 : sq2_nr2change;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n885 = ce ? n804 : sq2_lenchange;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n886 = ce ? n807 : sq2_lenquirk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n887 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n888 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n889 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n890 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n891 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n892 = ce ? n815 : sq2_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n893 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n894 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n895 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n896 = ce ? n820 : wav_lenchange;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n897 = ce ? n823 : wav_lenquirk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n898 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n899 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n900 = ce ? n828 : wav_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n901 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n902 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n903 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n904 = ce ? n833 : noi_lenchange;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n905 = ce ? n836 : noi_lenquirk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n906 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n907 = ce ? n840 : noi_nr2change;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n908 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n909 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n910 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n911 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n912 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n913 = ce ? n848 : noi_freqchange;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n914 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n915 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n916 = ce ? n852 : noi_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n917 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n918 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n919 = n364 & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n920 = ce ? n856 : s1_write_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n921 = ce ? n857 : write_registers_sq1_trigger_cnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n922 = ce ? n858 : write_registers_sq2_trigger_cnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n923 = ce ? n859 : write_registers_noi_trigger_cnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:432:25 */
  assign n924 = ce ? n860 : write_registers_wav_trigger_cnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n927 = reset ? n303 : n770;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n928 = reset ? n201 : n771;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n929 = reset ? n202 : n772;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n930 = reset ? sq1_swdir_change : n866;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n931 = reset ? n203 : n776;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n932 = reset ? n204 : n777;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n933 = reset ? n205 : n778;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n934 = reset ? n206 : n779;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n935 = reset ? n207 : n780;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n936 = reset ? sq1_envsgn_old : n781;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n937 = reset ? n208 : n782;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n938 = reset ? sq1_envper_old : n783;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n939 = reset ? n209 : n875;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n940 = reset ? n211 : n876;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n941 = reset ? n210 : n787;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n942 = reset ? sq1_nr2change : n878;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n943 = reset ? sq1_lenchange : n879;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n944 = reset ? sq1_lenquirk : n880;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n945 = reset ? n212 : n797;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n946 = reset ? n213 : n798;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n947 = reset ? n214 : n799;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n948 = reset ? sq2_nr2change : n884;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n949 = reset ? sq2_lenchange : n885;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n950 = reset ? sq2_lenquirk : n886;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n951 = reset ? n215 : n809;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n952 = reset ? n216 : n810;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n953 = reset ? sq2_envsgn_old : n811;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n954 = reset ? sq2_envper_old : n812;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n955 = reset ? n217 : n814;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n956 = reset ? n219 : n892;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n957 = reset ? n218 : n816;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n958 = reset ? n220 : n817;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n959 = reset ? wav_slen : n818;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n960 = reset ? wav_lenchange : n896;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n961 = reset ? wav_lenquirk : n897;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n962 = reset ? n221 : n825;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n963 = reset ? n222 : n827;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n964 = reset ? n223 : n900;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n965 = reset ? n224 : n829;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n966 = reset ? n302 : n830;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n967 = reset ? n225 : n831;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n968 = reset ? noi_lenchange : n904;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n969 = reset ? noi_lenquirk : n905;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n970 = reset ? n226 : n838;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n971 = reset ? noi_nr2change : n907;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n972 = reset ? n227 : n842;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n973 = reset ? n228 : n843;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n974 = reset ? noi_envsgn_old : n844;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n975 = reset ? noi_envper_old : n845;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n976 = reset ? n229 : n846;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n977 = reset ? noi_freqchange : n913;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n978 = reset ? n230 : n850;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n979 = reset ? n231 : n851;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n980 = reset ? n232 : n916;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n981 = reset ? n233 : n853;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n982 = reset ? n234 : n854;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n983 = reset ? n235 : n855;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n985 = reset ? 1'b0 : n920;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n987 = reset ? 3'b000 : n921;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n989 = reset ? 3'b000 : n922;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n991 = reset ? 3'b000 : n923;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:372:25 */
  assign n993 = reset ? 2'b00 : n924;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:707:36 */
  assign n1065 = {1'b1, sq1_swper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:707:48 */
  assign n1066 = {n1065, sq1_swdir};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:707:60 */
  assign n1067 = {n1066, sq1_swshift};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:706:13 */
  assign n1069 = s1_addr == 7'b0010000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:709:41 */
  assign n1071 = {sq1_duty, 6'b111111};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:708:13 */
  assign n1073 = s1_addr == 7'b0010001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:711:41 */
  assign n1074 = {sq1_svol, sq1_envsgn};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:711:54 */
  assign n1075 = {n1074, sq1_envper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:710:13 */
  assign n1077 = s1_addr == 7'b0010010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:712:13 */
  assign n1079 = s1_addr == 7'b0010011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:715:36 */
  assign n1081 = {1'b1, sq1_lenchk};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:715:49 */
  assign n1083 = {n1081, 6'b111111};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:714:13 */
  assign n1085 = s1_addr == 7'b0010100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:719:41 */
  assign n1087 = {sq2_duty, 6'b111111};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:718:13 */
  assign n1089 = s1_addr == 7'b0010110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:721:41 */
  assign n1090 = {sq2_svol, sq2_envsgn};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:721:54 */
  assign n1091 = {n1090, sq2_envper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:720:13 */
  assign n1093 = s1_addr == 7'b0010111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:722:13 */
  assign n1095 = s1_addr == 7'b0011000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:725:36 */
  assign n1097 = {1'b1, sq2_lenchk};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:725:49 */
  assign n1099 = {n1097, 6'b111111};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:724:13 */
  assign n1101 = s1_addr == 7'b0011001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:729:43 */
  assign n1103 = {wav_enable, 7'b1111111};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:728:13 */
  assign n1105 = s1_addr == 7'b0011010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:730:13 */
  assign n1107 = s1_addr == 7'b0011011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:733:36 */
  assign n1109 = {1'b1, wav_volsh};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:733:48 */
  assign n1111 = {n1109, 5'b11111};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:732:13 */
  assign n1113 = s1_addr == 7'b0011100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:734:13 */
  assign n1115 = s1_addr == 7'b0011101;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:737:36 */
  assign n1117 = {1'b1, wav_lenchk};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:737:49 */
  assign n1119 = {n1117, 6'b111111};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:736:13 */
  assign n1121 = s1_addr == 7'b0011110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:740:13 */
  assign n1123 = s1_addr == 7'b0100000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:743:41 */
  assign n1124 = {noi_svol, noi_envsgn};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:743:54 */
  assign n1125 = {n1124, noi_envper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:742:13 */
  assign n1127 = s1_addr == 7'b0100001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:745:43 */
  assign n1128 = {noi_freqsh, noi_short};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:745:55 */
  assign n1129 = {n1128, noi_div};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:744:13 */
  assign n1131 = s1_addr == 7'b0100010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:747:36 */
  assign n1133 = {1'b1, noi_lenchk};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:747:49 */
  assign n1135 = {n1133, 6'b111111};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:746:13 */
  assign n1137 = s1_addr == 7'b0100011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:752:66 */
  assign n1138 = wav_index[4:1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:754:47 */
  assign n1139 = s1_addr[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:751:17 */
  assign n1140 = wav_playing ? n1138 : n1139;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:757:47 */
  assign n1142 = $unsigned(wav_access) > $unsigned(2'b00);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:757:33 */
  assign n1143 = is_gbc | n1142;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:757:66 */
  assign n1144 = ~wav_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:757:51 */
  assign n1145 = n1143 | n1144;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:758:94 */
  assign n1147 = {n1140, 1'b0};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:759:64 */
  assign n1150 = 5'b11111 - n1147;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:759:102 */
  assign n1153 = {27'b0, n1147};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:759:102 */
  assign n1155 = n1153 + 32'b00000000000000000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:759:102 */
  assign n1156 = n1155[4:0];  // trunc
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:759:102 */
  assign n1158 = 5'b11111 - n1156;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:759:79 */
  assign n1161 = {n2921, n2922};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:757:17 */
  assign n1163 = n1145 ? n1161 : 8'b11111111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:13 */
  assign n1166 = s1_addr == 7'b0110000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:28 */
  assign n1168 = s1_addr == 7'b0110001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:28 */
  assign n1169 = n1166 | n1168;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:40 */
  assign n1171 = s1_addr == 7'b0110010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:40 */
  assign n1172 = n1169 | n1171;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:52 */
  assign n1174 = s1_addr == 7'b0110011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:52 */
  assign n1175 = n1172 | n1174;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:64 */
  assign n1177 = s1_addr == 7'b0110100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:64 */
  assign n1178 = n1175 | n1177;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:76 */
  assign n1180 = s1_addr == 7'b0110101;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:76 */
  assign n1181 = n1178 | n1180;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:88 */
  assign n1183 = s1_addr == 7'b0110110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:88 */
  assign n1184 = n1181 | n1183;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:100 */
  assign n1186 = s1_addr == 7'b0110111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:100 */
  assign n1187 = n1184 | n1186;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:112 */
  assign n1189 = s1_addr == 7'b0111000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:112 */
  assign n1190 = n1187 | n1189;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:124 */
  assign n1192 = s1_addr == 7'b0111001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:124 */
  assign n1193 = n1190 | n1192;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:136 */
  assign n1195 = s1_addr == 7'b0111010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:136 */
  assign n1196 = n1193 | n1195;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:148 */
  assign n1198 = s1_addr == 7'b0111011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:148 */
  assign n1199 = n1196 | n1198;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:160 */
  assign n1201 = s1_addr == 7'b0111100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:160 */
  assign n1202 = n1199 | n1201;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:172 */
  assign n1204 = s1_addr == 7'b0111101;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:172 */
  assign n1205 = n1202 | n1204;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:184 */
  assign n1207 = s1_addr == 7'b0111110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:184 */
  assign n1208 = n1205 | n1207;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:196 */
  assign n1210 = s1_addr == 7'b0111111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:750:196 */
  assign n1211 = n1208 | n1210;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:765:13 */
  assign n1213 = s1_addr == 7'b0100100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:767:13 */
  assign n1215 = s1_addr == 7'b0100101;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:770:43 */
  assign n1217 = {snd_enable, 3'b111};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:770:51 */
  assign n1218 = {n1217, noi_playing};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:770:65 */
  assign n1219 = {n1218, wav_playing};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:770:79 */
  assign n1220 = {n1219, sq2_playing};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:770:93 */
  assign n1221 = {n1220, sq1_playing};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:769:25 */
  assign n1223 = s1_addr == 7'b0100110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:776:21 */
  assign n1225 = sq2_playing ? sq2_wav : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:23:9 */
  assign n1227 = n1226[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:779:21 */
  assign n1228 = sq1_playing ? sq1_wav : n1227;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:774:19 */
  assign n1229 = {n1225, n1228};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:774:19 */
  assign n1231 = is_gbc ? n1229 : 8'b11111111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:773:13 */
  assign n1233 = s1_addr == 7'b1110110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:788:21 */
  assign n1235 = noi_playing ? noi_wav : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:23:9 */
  assign n1237 = n1236[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:791:21 */
  assign n1238 = wav_playing ? wav_wav : n1237;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:786:19 */
  assign n1239 = {n1235, n1238};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:786:19 */
  assign n1241 = is_gbc ? n1239 : 8'b11111111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:785:13 */
  assign n1243 = s1_addr == 7'b1110111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:704:9 */
  assign n1244 = {n1243, n1233, n1223, n1215, n1213, n1211, n1137, n1131, n1127, n1123, n1121, n1115, n1113, n1107, n1105, n1101, n1095, n1093, n1089, n1085, n1079, n1077, n1073, n1069};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:704:9 */
  always @*
    case (n1244)
      24'b100000000000000000000000: n1251 = n1241;
      24'b010000000000000000000000: n1251 = n1231;
      24'b001000000000000000000000: n1251 = n1221;
      24'b000100000000000000000000: n1251 = ch_map;
      24'b000010000000000000000000: n1251 = ch_vol;
      24'b000001000000000000000000: n1251 = n1163;
      24'b000000100000000000000000: n1251 = n1135;
      24'b000000010000000000000000: n1251 = n1129;
      24'b000000001000000000000000: n1251 = n1125;
      24'b000000000100000000000000: n1251 = 8'b11111111;
      24'b000000000010000000000000: n1251 = n1119;
      24'b000000000001000000000000: n1251 = 8'b11111111;
      24'b000000000000100000000000: n1251 = n1111;
      24'b000000000000010000000000: n1251 = 8'b11111111;
      24'b000000000000001000000000: n1251 = n1103;
      24'b000000000000000100000000: n1251 = n1099;
      24'b000000000000000010000000: n1251 = 8'b11111111;
      24'b000000000000000001000000: n1251 = n1091;
      24'b000000000000000000100000: n1251 = n1087;
      24'b000000000000000000010000: n1251 = n1083;
      24'b000000000000000000001000: n1251 = 8'b11111111;
      24'b000000000000000000000100: n1251 = n1075;
      24'b000000000000000000000010: n1251 = n1071;
      24'b000000000000000000000001: n1251 = n1067;
      default: n1251 = 8'b11111111;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:810:26 */
  always @*
    square1_sq1_fcnt = n2599; // (isignal)
  initial
    square1_sq1_fcnt = 11'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:811:26 */
  always @*
    square1_sq1_phase = n2600; // (isignal)
  initial
    square1_sq1_phase = 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:812:26 */
  always @*
    square1_sq1_len = n2601; // (isignal)
  initial
    square1_sq1_len = 7'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:813:26 */
  always @*
    square1_sq1_envcnt = n2602; // (isignal)
  initial
    square1_sq1_envcnt = 4'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:814:26 */
  always @*
    square1_sq1_swcnt = n2603; // (isignal)
  initial
    square1_sq1_swcnt = 4'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:816:26 */
  always @*
    square1_sq1_swfr = n2604; // (isignal)
  initial
    square1_sq1_swfr = 12'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:818:26 */
  always @*
    square1_sq1_sweep_en = n2605; // (isignal)
  initial
    square1_sq1_sweep_en = 1'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:819:26 */
  always @*
    square1_sweep_calculate = n2606; // (isignal)
  initial
    square1_sweep_calculate = 1'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:820:26 */
  always @*
    square1_sweep_update = n2607; // (isignal)
  initial
    square1_sweep_update = 1'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:821:26 */
  always @*
    square1_sweep_negate = n2608; // (isignal)
  initial
    square1_sweep_negate = 1'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:822:26 */
  always @*
    square1_sq1_sduty = n2609; // (isignal)
  initial
    square1_sq1_sduty = 2'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:823:26 */
  always @*
    square1_sq1_trigger_freq = n2610; // (isignal)
  initial
    square1_sq1_trigger_freq = 11'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:828:29 */
  assign n1271 = {sq1_svol, sq1_envsgn};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:828:42 */
  assign n1273 = n1271 == 5'b00000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:828:17 */
  assign n1276 = n1273 ? 1'b0 : 1'b1;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:832:53 */
  assign n1278 = ~sq1_suppressed;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:832:34 */
  assign n1279 = n1278 & sq1_out;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:832:17 */
  assign n1281 = n1279 ? sq1_vol : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:840:63 */
  assign n1283 = ss_sound3[23]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:841:63 */
  assign n1284 = ss_sound3[34:24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:844:63 */
  assign n1285 = ss_sound3[38:35]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:862:33 */
  assign n1286 = sq1_lenchange ? sq1_slen : square1_sq1_len;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:872:82 */
  assign n1288 = {1'b0, square1_sq1_fcnt};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:872:94 */
  assign n1290 = n1288 + 12'b000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:873:76 */
  assign n1291 = n1290[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:875:87 */
  assign n1292 = {29'b0, square1_sq1_phase};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:875:87 */
  assign n1294 = $signed(n1292) < $signed(32'b00000000000000000000000000000111);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:875:120 */
  assign n1295 = {29'b0, square1_sq1_phase};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:875:120 */
  assign n1297 = n1295 + 32'b00000000000000000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:875:97 */
  assign n1298 = n1297[2:0];  // trunc
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:875:73 */
  assign n1300 = n1294 ? n1298 : 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:879:93 */
  assign n1301 = n1290[10:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:869:41 */
  assign n1303 = n1343 ? 1'b0 : sq1_suppressed;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:873:65 */
  assign n1304 = n1291 ? sq1_freq : n1301;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:871:49 */
  assign n1305 = n1309 ? n1300 : square1_sq1_phase;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:871:49 */
  assign n1306 = n1310 ? sq1_duty : square1_sq1_sduty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:871:49 */
  assign n1307 = n1291 & sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:869:41 */
  assign n1308 = n1344 ? n1304 : square1_sq1_fcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:871:49 */
  assign n1309 = n1291 & sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:871:49 */
  assign n1310 = n1291 & sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:884:65 */
  assign n1318 = n1306 == 2'b00;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:885:65 */
  assign n1325 = n1306 == 2'b01;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:886:65 */
  assign n1332 = n1306 == 2'b10;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:887:65 */
  assign n1339 = n1306 == 2'b11;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:883:49 */
  assign n1340 = {n1339, n1332, n1325, n1318};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:883:49 */
  always @*
    case (n1340)
      4'b1000: n1341 = n2638;
      4'b0100: n1341 = n2635;
      4'b0010: n1341 = n2632;
      4'b0001: n1341 = n2629;
      default: n1341 = sq1_out;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:869:41 */
  assign n1342 = en_snd4 ? n1341 : sq1_out;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:869:41 */
  assign n1343 = n1307 & en_snd4;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:869:41 */
  assign n1344 = sq1_playing & en_snd4;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:869:41 */
  assign n1345 = en_snd4 ? n1305 : square1_sq1_phase;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:869:41 */
  assign n1346 = en_snd4 ? n1306 : square1_sq1_sduty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:893:57 */
  assign n1348 = en_len | sq1_lenquirk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:894:60 */
  assign n1350 = $unsigned(n1286) > $unsigned(7'b0000000);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:894:64 */
  assign n1351 = sq1_lenchk & n1350;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:895:111 */
  assign n1353 = n1286 - 7'b0000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:893:41 */
  assign n1354 = n1355 ? n1353 : n1286;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:893:41 */
  assign n1355 = n1351 & n1348;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:903:99 */
  assign n1357 = square1_sq1_swcnt - 4'b0001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:904:62 */
  assign n1359 = n1357 == 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:907:78 */
  assign n1361 = sq1_swper == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:910:90 */
  assign n1363 = {1'b0, sq1_swper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:907:65 */
  assign n1365 = n1361 ? 4'b1000 : n1363;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:914:101 */
  assign n1367 = sq1_swper != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:914:87 */
  assign n1368 = n1367 & square1_sq1_sweep_en;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:902:41 */
  assign n1370 = n1377 ? 1'b1 : square1_sweep_calculate;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:902:41 */
  assign n1372 = n1378 ? 1'b1 : square1_sweep_update;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:904:49 */
  assign n1373 = n1359 ? n1365 : n1357;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:904:49 */
  assign n1374 = n1368 & n1359;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:904:49 */
  assign n1375 = n1368 & n1359;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:902:41 */
  assign n1376 = en_sweep ? n1373 : square1_sq1_swcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:902:41 */
  assign n1377 = n1374 & en_sweep;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:902:41 */
  assign n1378 = n1375 & en_sweep;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:928:116 */
  assign n1380 = {1'b0, sq1_fr2};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:928:73 */
  assign n1382 = sq1_swshift == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:929:126 */
  assign n1383 = sq1_fr2[10:1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:929:108 */
  assign n1385 = {2'b00, n1383};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:929:73 */
  assign n1387 = sq1_swshift == 3'b001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:930:127 */
  assign n1388 = sq1_fr2[10:2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:930:109 */
  assign n1390 = {3'b000, n1388};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:930:73 */
  assign n1392 = sq1_swshift == 3'b010;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:931:128 */
  assign n1393 = sq1_fr2[10:3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:931:110 */
  assign n1395 = {4'b0000, n1393};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:931:73 */
  assign n1397 = sq1_swshift == 3'b011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:932:129 */
  assign n1398 = sq1_fr2[10:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:932:111 */
  assign n1400 = {5'b00000, n1398};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:932:73 */
  assign n1402 = sq1_swshift == 3'b100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:933:130 */
  assign n1403 = sq1_fr2[10:5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:933:112 */
  assign n1405 = {6'b000000, n1403};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:933:73 */
  assign n1407 = sq1_swshift == 3'b101;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:934:131 */
  assign n1408 = sq1_fr2[10:6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:934:113 */
  assign n1410 = {7'b0000000, n1408};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:934:73 */
  assign n1412 = sq1_swshift == 3'b110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:935:132 */
  assign n1413 = sq1_fr2[10:7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:935:114 */
  assign n1415 = {8'b00000000, n1413};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:935:73 */
  assign n1417 = sq1_swshift == 3'b111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:936:115 */
  assign n1419 = {1'b0, sq1_fr2};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:927:65 */
  assign n1420 = {n1417, n1412, n1407, n1402, n1397, n1392, n1387, n1382};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:927:65 */
  always @*
    case (n1420)
      8'b10000000: n1421 = n1415;
      8'b01000000: n1421 = n1410;
      8'b00100000: n1421 = n1405;
      8'b00010000: n1421 = n1400;
      8'b00001000: n1421 = n1395;
      8'b00000100: n1421 = n1390;
      8'b00000010: n1421 = n1385;
      8'b00000001: n1421 = n1380;
      default: n1421 = n1419;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:939:94 */
  assign n1423 = {1'b0, sq1_fr2};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:939:115 */
  assign n1424 = n1423 - n1421;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:942:94 */
  assign n1426 = {1'b0, sq1_fr2};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:942:115 */
  assign n1427 = n1426 + n1421;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:938:65 */
  assign n1428 = sq1_swdir ? n1424 : n1427;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:938:65 */
  assign n1431 = sq1_swdir ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:926:49 */
  assign n1433 = n1370 ? n1428 : square1_sq1_swfr;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:926:49 */
  assign n1435 = n1370 ? 1'b0 : n1370;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:923:41 */
  assign n1436 = n1463 ? n1431 : square1_sweep_negate;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:951:79 */
  assign n1438 = sq1_swper != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:951:104 */
  assign n1440 = sq1_swshift != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:951:88 */
  assign n1441 = n1440 & n1438;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:952:116 */
  assign n1442 = n1433[10:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:923:41 */
  assign n1443 = n1455 ? n1442 : sq1_fr2;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:951:65 */
  assign n1446 = n1441 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:949:49 */
  assign n1448 = n1452 ? 1'b1 : n1435;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:949:49 */
  assign n1449 = n1441 & n1372;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:949:49 */
  assign n1451 = n1372 ? n1446 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:949:49 */
  assign n1452 = n1441 & n1372;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:923:41 */
  assign n1454 = n1462 ? 1'b0 : n1372;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:923:41 */
  assign n1455 = n1449 & square1_sq1_sweep_en;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:923:41 */
  assign n1457 = square1_sq1_sweep_en ? n1451 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:923:41 */
  assign n1460 = square1_sq1_sweep_en ? n1433 : square1_sq1_swfr;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:923:41 */
  assign n1461 = square1_sq1_sweep_en ? n1448 : n1370;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:923:41 */
  assign n1462 = n1372 & square1_sq1_sweep_en;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:923:41 */
  assign n1463 = n1370 & square1_sq1_sweep_en;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:962:80 */
  assign n1465 = sq1_envper != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:962:65 */
  assign n1466 = n1465 & en_env;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:964:117 */
  assign n1468 = square1_sq1_envcnt - 4'b0001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:966:79 */
  assign n1470 = n1468 == 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:968:92 */
  assign n1472 = sq1_vol != 4'b1111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:969:143 */
  assign n1474 = sq1_vol + 4'b0001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:968:81 */
  assign n1475 = n1472 ? n1474 : sq1_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:972:92 */
  assign n1477 = sq1_vol != 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:973:143 */
  assign n1479 = sq1_vol - 4'b0001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:972:81 */
  assign n1480 = n1477 ? n1479 : sq1_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:967:73 */
  assign n1481 = sq1_envsgn ? n1475 : n1480;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:978:87 */
  assign n1483 = sq1_envper == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:981:99 */
  assign n1485 = {1'b0, sq1_envper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:978:73 */
  assign n1487 = n1483 ? 4'b1000 : n1485;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1488 = n1511 ? n1481 : sq1_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:966:65 */
  assign n1489 = n1470 ? n1487 : n1468;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:962:49 */
  assign n1490 = n1470 & n1466;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:962:49 */
  assign n1491 = n1466 ? n1489 : square1_sq1_envcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:988:82 */
  assign n1493 = n1354 == 7'b0000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:988:70 */
  assign n1494 = n1493 & sq1_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:989:100 */
  assign n1495 = n1460[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:989:88 */
  assign n1496 = n1495 & square1_sq1_sweep_en;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:989:65 */
  assign n1497 = n1494 | n1496;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:990:88 */
  assign n1498 = sq1_swdir_change & square1_sq1_sweep_en;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:990:115 */
  assign n1499 = n1436 & n1498;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:990:65 */
  assign n1500 = n1497 | n1499;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1502 = n1512 ? 1'b0 : sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:988:49 */
  assign n1504 = n1500 ? 4'b0000 : n1491;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1506 = n1514 ? 4'b0000 : n1376;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1508 = n1515 ? 12'b000000000000 : n1460;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1510 = n1516 ? 1'b0 : square1_sq1_sweep_en;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1511 = n1490 & sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1512 = n1500 & sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1513 = sq1_playing ? n1504 : square1_sq1_envcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1514 = n1500 & sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1515 = n1500 & sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:960:41 */
  assign n1516 = n1500 & sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1000:82 */
  assign n1517 = ~sq1_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1000:66 */
  assign n1518 = n1517 & sq1_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1000:89 */
  assign n1519 = n1518 | sq1_nr2change;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1000:113 */
  assign n1520 = sq1_playing & n1519;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1003:70 */
  assign n1522 = {4'b0000, sq1_vol};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1006:92 */
  assign n1524 = n1522 + 8'b00000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1005:49 */
  assign n1525 = sq1_envsgn ? n1524 : n1522;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1009:64 */
  assign n1526 = sq1_envsgn ^ sq1_envsgn_old;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1010:85 */
  assign n1528 = 8'b00010000 - n1525;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1009:49 */
  assign n1529 = n1526 ? n1528 : n1525;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1013:64 */
  assign n1531 = sq1_envper != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1013:95 */
  assign n1533 = sq1_envper_old == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1013:75 */
  assign n1534 = n1533 & n1531;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1013:120 */
  assign n1536 = n1529 != 8'b00000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1013:104 */
  assign n1537 = n1536 & n1534;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1013:151 */
  assign n1538 = ~sq1_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1013:135 */
  assign n1539 = n1538 & n1537;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1014:90 */
  assign n1541 = n1529 - 8'b00000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1013:49 */
  assign n1542 = n1539 ? n1541 : n1529;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1017:68 */
  assign n1544 = sq1_envper_old != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1017:78 */
  assign n1545 = sq1_envsgn & n1544;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1018:90 */
  assign n1547 = n1542 - 8'b00000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1017:49 */
  assign n1548 = n1545 ? n1547 : n1542;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1021:87 */
  assign n1549 = n1548[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1025:61 */
  assign n1550 = {1'b0, sq1_svol};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1025:61 */
  assign n1552 = n1550 == 5'b00000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1025:86 */
  assign n1553 = ~sq1_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1025:71 */
  assign n1554 = n1553 & n1552;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1000:41 */
  assign n1556 = n1558 ? 1'b0 : n1502;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1000:41 */
  assign n1557 = n1520 ? n1549 : n1488;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1000:41 */
  assign n1558 = n1554 & n1520;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1031:62 */
  assign n1560 = sq1_playing & sq1_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1031:41 */
  assign n1562 = n1560 ? 11'b00000000000 : n1308;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1035:58 */
  assign n1563 = ~sq1_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1035:64 */
  assign n1564 = sq1_trigger & n1563;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1035:41 */
  assign n1565 = n1564 ? sq1_freq : square1_sq1_trigger_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:80 */
  assign n1566 = ~sq1_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:64 */
  assign n1567 = n1566 & sq1_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1044:64 */
  assign n1568 = ~sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1570 = n1614 ? 1'b1 : n1303;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1051:63 */
  assign n1572 = sq1_swper != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1051:87 */
  assign n1574 = sq1_swshift != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1051:72 */
  assign n1575 = n1572 | n1574;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1051:49 */
  assign n1578 = n1575 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1055:64 */
  assign n1581 = sq1_swshift != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1583 = n1620 ? 1'b1 : n1461;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1058:62 */
  assign n1585 = sq1_swper == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1061:82 */
  assign n1587 = {1'b0, sq1_swper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1058:49 */
  assign n1589 = n1585 ? 4'b1000 : n1587;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1068:66 */
  assign n1590 = {1'b0, sq1_svol};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1068:66 */
  assign n1592 = n1590 == 5'b00000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1068:91 */
  assign n1593 = ~sq1_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1068:76 */
  assign n1594 = n1593 & n1592;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1068:52 */
  assign n1595 = ~n1594;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1597 = n1613 ? 1'b1 : n1556;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1073:63 */
  assign n1599 = sq1_envper == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1076:83 */
  assign n1601 = {1'b0, sq1_envper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1073:49 */
  assign n1603 = n1599 ? 4'b1000 : n1601;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1079:60 */
  assign n1605 = n1354 == 7'b0000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1080:85 */
  assign n1606 = en_len_r & sq1_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1080:65 */
  assign n1609 = n1606 ? 7'b0111111 : 7'b1000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1610 = n1616 ? n1609 : n1354;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1611 = n1567 ? sq1_freq : n1443;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1612 = n1567 ? sq1_svol : n1557;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1613 = n1595 & n1567;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1614 = n1568 & n1567;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1615 = n1567 ? n1565 : n1562;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1616 = n1605 & n1567;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1617 = n1567 ? n1603 : n1513;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1618 = n1567 ? n1589 : n1506;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1619 = n1567 ? n1578 : n1510;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1620 = n1581 & n1567;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1040:41 */
  assign n1622 = n1567 ? 1'b0 : n1436;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1108:41 */
  assign n1624 = is_gbc ? 7'b0000000 : n1286;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1626 = snd_enable ? n1342 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1628 = snd_enable ? n1611 : 11'b00000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1630 = snd_enable ? n1612 : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1631 = n1667 ? n1457 : sq1_freqchange;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1633 = snd_enable ? n1597 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1635 = snd_enable ? n1570 : 1'b1;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1637 = snd_enable ? sq1_trigger : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1639 = snd_enable ? n1615 : 11'b00000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1641 = snd_enable ? n1345 : 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1642 = snd_enable ? n1610 : n1624;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1644 = snd_enable ? n1617 : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1646 = snd_enable ? n1618 : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1650 = snd_enable ? n1508 : 12'b000000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1652 = snd_enable ? n1619 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1654 = snd_enable ? n1583 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1656 = snd_enable ? n1454 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1658 = snd_enable ? n1622 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:868:33 */
  assign n1660 = snd_enable ? n1346 : 2'b00;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1661 = n1683 ? n1565 : square1_sq1_trigger_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1664 = ce ? n1626 : sq1_out;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1665 = ce ? n1628 : sq1_fr2;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1666 = ce ? n1630 : sq1_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1667 = snd_enable & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1668 = ce ? n1633 : sq1_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1669 = ce ? n1635 : sq1_suppressed;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1670 = ce ? n1637 : sq1_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1671 = ce ? n1639 : square1_sq1_fcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1672 = ce ? n1641 : square1_sq1_phase;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1673 = ce ? n1642 : square1_sq1_len;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1674 = ce ? n1644 : square1_sq1_envcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1675 = ce ? n1646 : square1_sq1_swcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1677 = ce ? n1650 : square1_sq1_swfr;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1678 = ce ? n1652 : square1_sq1_sweep_en;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1679 = ce ? n1654 : square1_sweep_calculate;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1680 = ce ? n1656 : square1_sweep_update;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1681 = ce ? n1658 : square1_sweep_negate;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1682 = ce ? n1660 : square1_sq1_sduty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:861:25 */
  assign n1683 = snd_enable & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1687 = reset ? 1'b0 : n1664;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1688 = reset ? n1284 : n1665;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1689 = reset ? n1285 : n1666;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1690 = reset ? sq1_freqchange : n1631;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1691 = reset ? n1283 : n1668;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1693 = reset ? 1'b1 : n1669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1695 = reset ? 1'b0 : n1670;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1697 = reset ? 11'b00000000000 : n1671;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1699 = reset ? 3'b000 : n1672;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1701 = reset ? 7'b0000000 : n1673;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1703 = reset ? 4'b0000 : n1674;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1705 = reset ? 4'b0000 : n1675;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1709 = reset ? 12'b000000000000 : n1677;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1711 = reset ? 1'b0 : n1678;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1713 = reset ? 1'b0 : n1679;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1715 = reset ? 1'b0 : n1680;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1717 = reset ? 1'b0 : n1681;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1719 = reset ? 2'b00 : n1682;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:839:25 */
  assign n1721 = reset ? 11'b00000000000 : n1661;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1123:26 */
  always @*
    square2_sq2_fcnt = n2611; // (isignal)
  initial
    square2_sq2_fcnt = 11'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1124:26 */
  always @*
    square2_sq2_phase = n2612; // (isignal)
  initial
    square2_sq2_phase = 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1125:26 */
  always @*
    square2_sq2_len = n2613; // (isignal)
  initial
    square2_sq2_len = 7'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1126:26 */
  always @*
    square2_sq2_envcnt = n2614; // (isignal)
  initial
    square2_sq2_envcnt = 4'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1127:26 */
  always @*
    square2_sq2_sduty = n2615; // (isignal)
  initial
    square2_sq2_sduty = 2'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1128:26 */
  always @*
    square2_sq2_trigger_freq = n2616; // (isignal)
  initial
    square2_sq2_trigger_freq = 11'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1133:29 */
  assign n1756 = {sq2_svol, sq2_envsgn};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1133:42 */
  assign n1758 = n1756 == 5'b00000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1133:17 */
  assign n1761 = n1758 ? 1'b0 : 1'b1;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1137:53 */
  assign n1763 = ~sq2_suppressed;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1137:34 */
  assign n1764 = n1763 & sq2_out;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1137:17 */
  assign n1766 = n1764 ? sq2_vol : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1145:71 */
  assign n1768 = ss_sound3[39]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1148:71 */
  assign n1769 = ss_sound3[43:40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1158:33 */
  assign n1770 = sq2_lenchange ? sq2_slen : square2_sq2_len;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1168:74 */
  assign n1772 = {1'b0, square2_sq2_fcnt};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1168:86 */
  assign n1774 = n1772 + 12'b000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1169:68 */
  assign n1775 = n1774[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1171:79 */
  assign n1776 = {29'b0, square2_sq2_phase};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1171:79 */
  assign n1778 = $signed(n1776) < $signed(32'b00000000000000000000000000000111);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1171:112 */
  assign n1779 = {29'b0, square2_sq2_phase};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1171:112 */
  assign n1781 = n1779 + 32'b00000000000000000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1171:89 */
  assign n1782 = n1781[2:0];  // trunc
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1171:65 */
  assign n1784 = n1778 ? n1782 : 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1175:85 */
  assign n1785 = n1774[10:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1165:41 */
  assign n1787 = n1827 ? 1'b0 : sq2_suppressed;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1169:57 */
  assign n1788 = n1775 ? sq2_freq : n1785;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1167:49 */
  assign n1789 = n1793 ? n1784 : square2_sq2_phase;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1167:49 */
  assign n1790 = n1794 ? sq2_duty : square2_sq2_sduty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1167:49 */
  assign n1791 = n1775 & sq2_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1165:41 */
  assign n1792 = n1828 ? n1788 : square2_sq2_fcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1167:49 */
  assign n1793 = n1775 & sq2_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1167:49 */
  assign n1794 = n1775 & sq2_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1180:57 */
  assign n1802 = n1790 == 2'b00;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1181:57 */
  assign n1809 = n1790 == 2'b01;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1182:57 */
  assign n1816 = n1790 == 2'b10;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1183:57 */
  assign n1823 = n1790 == 2'b11;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1179:49 */
  assign n1824 = {n1823, n1816, n1809, n1802};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1179:49 */
  always @*
    case (n1824)
      4'b1000: n1825 = n2650;
      4'b0100: n1825 = n2647;
      4'b0010: n1825 = n2644;
      4'b0001: n1825 = n2641;
      default: n1825 = sq2_out;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1165:41 */
  assign n1826 = en_snd4 ? n1825 : sq2_out;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1165:41 */
  assign n1827 = n1791 & en_snd4;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1165:41 */
  assign n1828 = sq2_playing & en_snd4;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1165:41 */
  assign n1829 = en_snd4 ? n1789 : square2_sq2_phase;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1165:41 */
  assign n1830 = en_snd4 ? n1790 : square2_sq2_sduty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1189:57 */
  assign n1832 = en_len | sq2_lenquirk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1190:60 */
  assign n1834 = $unsigned(n1770) > $unsigned(7'b0000000);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1190:64 */
  assign n1835 = sq2_lenchk & n1834;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1191:103 */
  assign n1837 = n1770 - 7'b0000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1189:41 */
  assign n1838 = n1839 ? n1837 : n1770;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1189:41 */
  assign n1839 = n1835 & n1832;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1198:80 */
  assign n1841 = sq2_envper != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1198:65 */
  assign n1842 = n1841 & en_env;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1200:109 */
  assign n1844 = square2_sq2_envcnt - 4'b0001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1202:71 */
  assign n1846 = n1844 == 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1204:92 */
  assign n1848 = sq2_vol != 4'b1111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1205:135 */
  assign n1850 = sq2_vol + 4'b0001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1204:81 */
  assign n1851 = n1848 ? n1850 : sq2_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1208:92 */
  assign n1853 = sq2_vol != 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1209:135 */
  assign n1855 = sq2_vol - 4'b0001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1208:81 */
  assign n1856 = n1853 ? n1855 : sq2_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1203:65 */
  assign n1857 = sq2_envsgn ? n1851 : n1856;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1214:79 */
  assign n1859 = sq2_envper == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1217:99 */
  assign n1861 = {1'b0, sq2_envper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1214:65 */
  assign n1863 = n1859 ? 4'b1000 : n1861;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1195:41 */
  assign n1864 = n1875 ? n1857 : sq2_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1202:57 */
  assign n1865 = n1846 ? n1863 : n1844;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1198:49 */
  assign n1866 = n1846 & n1842;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1198:49 */
  assign n1867 = n1842 ? n1865 : square2_sq2_envcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1224:81 */
  assign n1869 = n1838 == 7'b0000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1224:69 */
  assign n1870 = n1869 & sq2_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1195:41 */
  assign n1872 = n1876 ? 1'b0 : sq2_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1224:49 */
  assign n1874 = n1870 ? 4'b0000 : n1867;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1195:41 */
  assign n1875 = n1866 & sq2_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1195:41 */
  assign n1876 = n1870 & sq2_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1195:41 */
  assign n1877 = sq2_playing ? n1874 : square2_sq2_envcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1231:82 */
  assign n1878 = ~sq2_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1231:66 */
  assign n1879 = n1878 & sq2_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1231:89 */
  assign n1880 = n1879 | sq2_nr2change;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1231:113 */
  assign n1881 = sq2_playing & n1880;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1235:70 */
  assign n1883 = {4'b0000, sq2_vol};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1238:84 */
  assign n1885 = n1883 + 8'b00000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1237:49 */
  assign n1886 = sq2_envsgn ? n1885 : n1883;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1241:64 */
  assign n1887 = sq2_envsgn ^ sq2_envsgn_old;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1242:77 */
  assign n1889 = 8'b00010000 - n1886;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1241:49 */
  assign n1890 = n1887 ? n1889 : n1886;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1245:64 */
  assign n1892 = sq2_envper != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1245:95 */
  assign n1894 = sq2_envper_old == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1245:75 */
  assign n1895 = n1894 & n1892;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1245:120 */
  assign n1897 = n1890 != 8'b00000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1245:104 */
  assign n1898 = n1897 & n1895;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1245:151 */
  assign n1899 = ~sq2_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1245:135 */
  assign n1900 = n1899 & n1898;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1246:82 */
  assign n1902 = n1890 - 8'b00000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1245:49 */
  assign n1903 = n1900 ? n1902 : n1890;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1249:68 */
  assign n1905 = sq2_envper_old != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1249:78 */
  assign n1906 = sq2_envsgn & n1905;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1250:82 */
  assign n1908 = n1903 - 8'b00000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1249:49 */
  assign n1909 = n1906 ? n1908 : n1903;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1253:87 */
  assign n1910 = n1909[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1257:61 */
  assign n1911 = {1'b0, sq2_svol};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1257:61 */
  assign n1913 = n1911 == 5'b00000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1257:86 */
  assign n1914 = ~sq2_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1257:71 */
  assign n1915 = n1914 & n1913;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1231:41 */
  assign n1917 = n1919 ? 1'b0 : n1872;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1231:41 */
  assign n1918 = n1881 ? n1910 : n1864;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1231:41 */
  assign n1919 = n1915 & n1881;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1263:62 */
  assign n1921 = sq2_playing & sq2_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1263:41 */
  assign n1923 = n1921 ? 11'b00000000000 : n1792;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1267:58 */
  assign n1924 = ~sq2_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1267:64 */
  assign n1925 = sq2_trigger & n1924;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1267:41 */
  assign n1926 = n1925 ? sq2_freq : square2_sq2_trigger_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:80 */
  assign n1927 = ~sq2_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:64 */
  assign n1928 = n1927 & sq2_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1277:64 */
  assign n1929 = ~sq2_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:41 */
  assign n1931 = n1955 ? 1'b1 : n1787;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1284:66 */
  assign n1932 = {1'b0, sq2_svol};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1284:66 */
  assign n1934 = n1932 == 5'b00000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1284:91 */
  assign n1935 = ~sq2_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1284:76 */
  assign n1936 = n1935 & n1934;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1284:52 */
  assign n1937 = ~n1936;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:41 */
  assign n1939 = n1954 ? 1'b1 : n1917;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1289:63 */
  assign n1941 = sq2_envper == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1292:75 */
  assign n1943 = {1'b0, sq2_envper};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1289:49 */
  assign n1945 = n1941 ? 4'b1000 : n1943;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1295:60 */
  assign n1947 = n1838 == 7'b0000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1296:77 */
  assign n1948 = en_len_r & sq2_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1296:57 */
  assign n1951 = n1948 ? 7'b0111111 : 7'b1000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:41 */
  assign n1952 = n1957 ? n1951 : n1838;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:41 */
  assign n1953 = n1928 ? sq2_svol : n1918;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:41 */
  assign n1954 = n1937 & n1928;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:41 */
  assign n1955 = n1929 & n1928;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:41 */
  assign n1956 = n1928 ? n1926 : n1923;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:41 */
  assign n1957 = n1947 & n1928;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1272:41 */
  assign n1958 = n1928 ? n1945 : n1877;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1313:41 */
  assign n1960 = is_gbc ? 7'b0000000 : n1770;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1962 = snd_enable ? n1826 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1964 = snd_enable ? n1953 : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1966 = snd_enable ? n1939 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1968 = snd_enable ? n1931 : 1'b1;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1970 = snd_enable ? sq2_trigger : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1972 = snd_enable ? n1956 : 11'b00000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1974 = snd_enable ? n1829 : 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1975 = snd_enable ? n1952 : n1960;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1977 = snd_enable ? n1958 : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1164:33 */
  assign n1979 = snd_enable ? n1830 : 2'b00;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1980 = n1993 ? n1926 : square2_sq2_trigger_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1983 = ce ? n1962 : sq2_out;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1984 = ce ? n1964 : sq2_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1985 = ce ? n1966 : sq2_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1986 = ce ? n1968 : sq2_suppressed;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1987 = ce ? n1970 : sq2_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1988 = ce ? n1972 : square2_sq2_fcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1989 = ce ? n1974 : square2_sq2_phase;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1990 = ce ? n1975 : square2_sq2_len;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1991 = ce ? n1977 : square2_sq2_envcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1992 = ce ? n1979 : square2_sq2_sduty;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1157:25 */
  assign n1993 = snd_enable & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n1997 = reset ? 1'b0 : n1983;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n1998 = reset ? n1769 : n1984;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n1999 = reset ? n1768 : n1985;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n2001 = reset ? 1'b1 : n1986;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n2003 = reset ? 1'b0 : n1987;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n2005 = reset ? 11'b00000000000 : n1988;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n2007 = reset ? 3'b000 : n1989;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n2009 = reset ? 7'b0000000 : n1990;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n2011 = reset ? 4'b0000 : n1991;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n2013 = reset ? 2'b00 : n1992;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1144:25 */
  assign n2015 = reset ? 11'b00000000000 : n1980;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1324:26 */
  always @*
    wave_wav_fcnt = n2617; // (isignal)
  initial
    wave_wav_fcnt = 11'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1325:26 */
  always @*
    wave_wav_len = n2618; // (isignal)
  initial
    wave_wav_len = 9'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1326:26 */
  always @*
    wave_wav_shift_r = n2619; // (isignal)
  initial
    wave_wav_shift_r = 1'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1330:26 */
  always @*
    wave_wav_trigger_freq = n2620; // (isignal)
  initial
    wave_wav_trigger_freq = 11'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1332:32 */
  assign n2039 = ~wav_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1336:33 */
  assign n2041 = wav_volsh == 2'b01;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1337:74 */
  assign n2042 = wav_wav_r[3:1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1337:63 */
  assign n2044 = {1'b0, n2042};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1337:33 */
  assign n2046 = wav_volsh == 2'b10;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1338:75 */
  assign n2047 = wav_wav_r[3:2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1338:64 */
  assign n2049 = {2'b00, n2047};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1338:33 */
  assign n2051 = wav_volsh == 2'b11;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1335:25 */
  assign n2052 = {n2051, n2046, n2041};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1335:25 */
  always @*
    case (n2052)
      3'b100: n2054 = n2049;
      3'b010: n2054 = n2044;
      3'b001: n2054 = wav_wav_r;
      default: n2054 = 4'b0000;
    endcase
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1332:17 */
  assign n2056 = n2039 ? 4'b0000 : n2054;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1345:63 */
  assign n2058 = ss_sound3[49:46]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1346:63 */
  assign n2059 = ss_sound3[50]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1349:72 */
  assign n2060 = ss_sound3[55:51]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1350:72 */
  assign n2061 = ss_sound3[57:56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1356:33 */
  assign n2062 = wav_lenchange ? wav_slen : wave_wav_len;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1363:55 */
  assign n2064 = $unsigned(wav_access) > $unsigned(2'b00);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1364:74 */
  assign n2066 = wav_access - 2'b01;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1363:41 */
  assign n2067 = n2064 ? n2066 : wav_access;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1372:82 */
  assign n2069 = {1'b0, wave_wav_fcnt};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1372:94 */
  assign n2071 = n2069 + 12'b000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1373:76 */
  assign n2072 = n2071[11]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1377:93 */
  assign n2073 = n2071[10:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1373:65 */
  assign n2074 = n2072 ? wav_freq : n2073;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1373:65 */
  assign n2077 = n2072 ? 1'b1 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1369:41 */
  assign n2078 = n2082 ? n2074 : wave_wav_fcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1371:49 */
  assign n2080 = wav_playing ? n2077 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1369:41 */
  assign n2082 = wav_playing & en_snd2;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1369:41 */
  assign n2084 = en_snd2 ? n2080 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1382:80 */
  assign n2087 = ~wav_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1382:64 */
  assign n2088 = n2087 & wav_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1387:84 */
  assign n2089 = ~wave_wav_shift_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1387:68 */
  assign n2090 = n2089 & n2084;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1388:89 */
  assign n2092 = wav_index + 5'b00001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1389:108 */
  assign n2094 = wav_index + 5'b00001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1389:87 */
  assign n2097 = 5'b11111 - n2094;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1387:49 */
  assign n2100 = n2090 ? n2092 : wav_index;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1387:49 */
  assign n2102 = n2090 ? 2'b10 : n2067;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1387:49 */
  assign n2103 = n2090 ? n2923 : wav_wav_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1382:41 */
  assign n2105 = n2088 ? 5'b00000 : n2100;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1382:41 */
  assign n2106 = n2088 ? n2067 : n2102;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1382:41 */
  assign n2107 = n2088 ? wav_wav_r : n2103;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1382:41 */
  assign n2109 = n2088 ? 1'b0 : n2084;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1396:57 */
  assign n2110 = en_len | wav_lenquirk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1397:60 */
  assign n2112 = $unsigned(n2062) > $unsigned(9'b000000000);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1397:64 */
  assign n2113 = wav_lenchk & n2112;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1398:111 */
  assign n2115 = n2062 - 9'b000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1396:41 */
  assign n2116 = n2117 ? n2115 : n2062;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1396:41 */
  assign n2117 = n2113 & n2110;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1404:82 */
  assign n2119 = n2116 == 9'b000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1404:70 */
  assign n2120 = n2119 & wav_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1404:101 */
  assign n2121 = ~wav_enable;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1404:87 */
  assign n2122 = n2120 | n2121;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1402:41 */
  assign n2124 = n2125 ? 1'b0 : wav_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1402:41 */
  assign n2125 = n2122 & wav_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1409:58 */
  assign n2126 = ~wav_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1409:64 */
  assign n2127 = wav_trigger & n2126;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1409:41 */
  assign n2128 = n2127 ? wav_freq : wave_wav_trigger_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1414:80 */
  assign n2129 = ~wav_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1414:64 */
  assign n2130 = n2129 & wav_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1418:60 */
  assign n2132 = n2116 == 9'b000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1419:77 */
  assign n2133 = en_len_r & wav_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1419:57 */
  assign n2136 = n2133 ? 9'b011111111 : 9'b100000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1414:41 */
  assign n2137 = n2141 ? n2136 : n2116;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1414:41 */
  assign n2139 = n2130 ? 1'b1 : n2124;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1414:41 */
  assign n2140 = n2130 ? n2128 : n2078;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1414:41 */
  assign n2141 = n2132 & n2130;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1434:41 */
  assign n2143 = is_gbc ? 9'b000000000 : n2062;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1362:33 */
  assign n2145 = snd_enable ? n2105 : 5'b00000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1362:33 */
  assign n2147 = snd_enable ? n2106 : 2'b00;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1362:33 */
  assign n2149 = snd_enable ? n2139 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1362:33 */
  assign n2151 = snd_enable ? n2107 : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1362:33 */
  assign n2153 = snd_enable ? wav_trigger : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1362:33 */
  assign n2155 = snd_enable ? n2140 : 11'b00000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1362:33 */
  assign n2156 = snd_enable ? n2137 : n2143;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1362:33 */
  assign n2158 = snd_enable ? n2109 : 1'b0;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2161 = n2172 ? n2128 : wave_wav_trigger_freq;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2162 = ce ? n2145 : wav_index;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2163 = ce ? n2147 : wav_access;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2164 = ce ? n2149 : wav_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2165 = ce ? n2151 : wav_wav_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2166 = ce ? n2153 : wav_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2167 = ce ? n2155 : wave_wav_fcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2168 = ce ? n2156 : wave_wav_len;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2169 = ce ? n2158 : wave_wav_shift_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1355:25 */
  assign n2172 = snd_enable & ce;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1344:25 */
  assign n2173 = reset ? n2060 : n2162;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1344:25 */
  assign n2174 = reset ? n2061 : n2163;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1344:25 */
  assign n2175 = reset ? n2059 : n2164;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1344:25 */
  assign n2176 = reset ? n2058 : n2165;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1344:25 */
  assign n2178 = reset ? 1'b0 : n2166;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1344:25 */
  assign n2180 = reset ? 11'b00000000000 : n2167;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1344:25 */
  assign n2182 = reset ? 9'b000000000 : n2168;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1344:25 */
  assign n2184 = reset ? 1'b0 : n2169;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1344:25 */
  assign n2188 = reset ? 11'b00000000000 : n2161;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1445:26 */
  always @*
    noise_noi_period = n2621; // (isignal)
  initial
    noise_noi_period = 20'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1446:26 */
  always @*
    noise_noi_fcnt = n2622; // (isignal)
  initial
    noise_noi_fcnt = 20'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1447:26 */
  always @*
    noise_noi_lfsr = n2623; // (isignal)
  initial
    noise_noi_lfsr = 15'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1448:26 */
  always @*
    noise_noi_len = n2624; // (isignal)
  initial
    noise_noi_len = 7'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1449:26 */
  always @*
    noise_noi_envcnt = n2625; // (isignal)
  initial
    noise_noi_envcnt = 3'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1450:26 */
  always @*
    noise_noi_out = n2626; // (isignal)
  initial
    noise_noi_out = 1'bX;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1456:29 */
  assign n2210 = {noi_svol, noi_envsgn};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1456:42 */
  assign n2212 = n2210 == 5'b00000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1456:17 */
  assign n2215 = n2212 ? 1'b0 : 1'b1;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1460:17 */
  assign n2218 = noise_noi_out ? noi_vol : 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1469:63 */
  assign n2220 = ss_sound3[58]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1472:63 */
  assign n2221 = ss_sound3[62:59]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1478:33 */
  assign n2222 = noi_lenchange ? noi_slen : noise_noi_len;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:47 */
  assign n2223 = ~snd_enable;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1492:41 */
  assign n2225 = is_gbc ? 7'b0000000 : n2222;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1499:62 */
  assign n2226 = en_snd4 & noi_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1500:61 */
  assign n2228 = noise_noi_fcnt == 20'b00000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1502:81 */
  assign n2229 = noise_noi_lfsr[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1502:97 */
  assign n2230 = noise_noi_lfsr[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1502:85 */
  assign n2231 = n2229 ^ n2230;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1502:69 */
  assign n2232 = ~n2231;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1503:87 */
  assign n2233 = noise_noi_lfsr[14:1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1503:77 */
  assign n2234 = {n2232, n2233};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1447:26 */
  assign n2235 = n2234[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1505:57 */
  assign n2236 = noi_short ? n2232 : n2235;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1447:26 */
  assign n2237 = n2234[14:7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1447:26 */
  assign n2238 = n2234[5:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1447:26 */
  assign n2239 = {n2237, n2236, n2238};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1509:77 */
  assign n2240 = n2239[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1512:78 */
  assign n2242 = noise_noi_fcnt - 20'b00000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1500:49 */
  assign n2243 = n2228 ? noise_noi_period : n2242;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1500:49 */
  assign n2244 = {n2237, n2236, n2238};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1499:41 */
  assign n2245 = n2249 ? n2244 : noise_noi_lfsr;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1499:41 */
  assign n2246 = n2250 ? n2240 : noise_noi_out;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1499:41 */
  assign n2248 = n2226 ? n2243 : noise_noi_fcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1499:41 */
  assign n2249 = n2228 & n2226;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1499:41 */
  assign n2250 = n2228 & n2226;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1517:58 */
  assign n2252 = en_len | noi_lenquirk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1517:81 */
  assign n2253 = noi_lenchk & n2252;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1518:60 */
  assign n2255 = $unsigned(n2222) > $unsigned(7'b0000000);
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1519:103 */
  assign n2257 = n2222 - 7'b0000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1517:41 */
  assign n2258 = n2259 ? n2257 : n2222;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1517:41 */
  assign n2259 = n2255 & n2253;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1524:73 */
  assign n2261 = n2258 == 7'b0000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1524:61 */
  assign n2262 = n2261 & noi_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1524:41 */
  assign n2264 = n2262 ? 1'b0 : noi_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1529:62 */
  assign n2265 = en_env & noi_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1529:94 */
  assign n2267 = noi_envper != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1529:79 */
  assign n2268 = n2267 & n2265;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1530:101 */
  assign n2270 = noise_noi_envcnt - 3'b001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1532:63 */
  assign n2272 = n2270 == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1534:76 */
  assign n2274 = noi_vol != 4'b1111;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1535:119 */
  assign n2276 = noi_vol + 4'b0001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1534:65 */
  assign n2277 = n2274 ? n2276 : noi_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1538:76 */
  assign n2279 = noi_vol != 4'b0000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1539:119 */
  assign n2281 = noi_vol - 4'b0001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1538:65 */
  assign n2282 = n2279 ? n2281 : noi_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1533:57 */
  assign n2283 = noi_envsgn ? n2277 : n2282;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1529:41 */
  assign n2284 = n2286 ? n2283 : noi_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1532:49 */
  assign n2285 = n2272 ? noi_envper : n2270;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1529:41 */
  assign n2286 = n2272 & n2268;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1529:41 */
  assign n2287 = n2268 ? n2285 : noise_noi_envcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1549:58 */
  assign n2288 = ~noi_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1549:64 */
  assign n2289 = noi_trigger_r & n2288;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1549:89 */
  assign n2290 = n2289 | noi_nr2change;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1549:113 */
  assign n2291 = noi_playing & n2290;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1552:70 */
  assign n2293 = {4'b0000, noi_vol};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1555:92 */
  assign n2295 = n2293 + 8'b00000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1554:49 */
  assign n2296 = noi_envsgn ? n2295 : n2293;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1558:64 */
  assign n2297 = noi_envsgn ^ noi_envsgn_old;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1559:85 */
  assign n2299 = 8'b00010000 - n2296;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1558:49 */
  assign n2300 = n2297 ? n2299 : n2296;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1562:64 */
  assign n2302 = noi_envper != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1562:95 */
  assign n2304 = noi_envper_old == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1562:75 */
  assign n2305 = n2304 & n2302;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1562:120 */
  assign n2307 = n2300 != 8'b00000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1562:104 */
  assign n2308 = n2307 & n2305;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1562:151 */
  assign n2309 = ~noi_envsgn;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1562:135 */
  assign n2310 = n2309 & n2308;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1563:90 */
  assign n2312 = n2300 - 8'b00000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1562:49 */
  assign n2313 = n2310 ? n2312 : n2300;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1566:68 */
  assign n2315 = noi_envper_old != 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1566:78 */
  assign n2316 = noi_envsgn & n2315;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1567:90 */
  assign n2318 = n2313 - 8'b00000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1566:49 */
  assign n2319 = n2316 ? n2318 : n2313;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1570:87 */
  assign n2320 = n2319[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1549:41 */
  assign n2321 = n2291 ? n2320 : n2284;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1574:62 */
  assign n2323 = noi_trigger | noi_freqchange;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1445:26 */
  assign n2325 = n2324[19:5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1584:60 */
  assign n2328 = noi_div == 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1445:26 */
  assign n2330 = n2324[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1584:49 */
  assign n2331 = n2328 ? 1'b1 : n2330;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1445:26 */
  assign n2332 = n2324[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1588:78 */
  assign n2333 = {27'b0, noi_freqsh};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1588:74 */
  assign n2334 = {1'b0, n2333};  // uext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1445:26 */
  assign n2335 = {n2325, noi_div, n2331, n2332};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1588:74 */
  assign n2336 = n2335 << n2334;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1574:41 */
  assign n2337 = n2323 ? n2336 : noise_noi_period;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1574:41 */
  assign n2338 = n2323 ? n2336 : n2248;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1593:80 */
  assign n2339 = ~noi_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1593:64 */
  assign n2340 = n2339 & noi_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1599:60 */
  assign n2342 = n2258 == 7'b0000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1600:77 */
  assign n2343 = en_len_r & noi_lenchk;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1600:57 */
  assign n2346 = n2343 ? 7'b0111111 : 7'b1000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1593:41 */
  assign n2347 = n2353 ? n2346 : n2258;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1593:41 */
  assign n2348 = n2340 ? noi_svol : n2321;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1593:41 */
  assign n2350 = n2340 ? 1'b1 : n2264;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1593:41 */
  assign n2352 = n2340 ? 15'b000000000000000 : n2245;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1593:41 */
  assign n2353 = n2342 & n2340;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1593:41 */
  assign n2354 = n2340 ? noi_envper : n2287;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1608:53 */
  assign n2355 = {noi_svol, noi_envsgn};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1608:66 */
  assign n2357 = n2355 == 5'b00000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1608:41 */
  assign n2359 = n2357 ? 1'b0 : n2350;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:33 */
  assign n2361 = n2223 ? 4'b0000 : n2348;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:33 */
  assign n2363 = n2223 ? 1'b0 : n2359;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:33 */
  assign n2365 = n2223 ? 1'b0 : noi_trigger;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:33 */
  assign n2366 = n2223 ? noise_noi_period : n2337;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:33 */
  assign n2368 = n2223 ? 20'b00000000000000000000 : n2338;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:33 */
  assign n2370 = n2223 ? 15'b000000000000000 : n2352;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:33 */
  assign n2371 = n2223 ? n2225 : n2347;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:33 */
  assign n2373 = n2223 ? 3'b000 : n2354;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1485:33 */
  assign n2375 = n2223 ? 1'b0 : n2246;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1477:25 */
  assign n2378 = ce ? n2361 : noi_vol;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1477:25 */
  assign n2379 = ce ? n2363 : noi_playing;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1477:25 */
  assign n2380 = ce ? n2365 : noi_trigger_r;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1477:25 */
  assign n2381 = ce ? n2366 : noise_noi_period;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1477:25 */
  assign n2382 = ce ? n2368 : noise_noi_fcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1477:25 */
  assign n2383 = ce ? n2370 : noise_noi_lfsr;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1477:25 */
  assign n2384 = ce ? n2371 : noise_noi_len;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1477:25 */
  assign n2385 = ce ? n2373 : noise_noi_envcnt;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1477:25 */
  assign n2386 = ce ? n2375 : noise_noi_out;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1468:25 */
  assign n2389 = reset ? n2221 : n2378;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1468:25 */
  assign n2390 = reset ? n2220 : n2379;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1468:25 */
  assign n2392 = reset ? 1'b0 : n2380;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1468:25 */
  assign n2393 = reset ? noise_noi_period : n2381;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1468:25 */
  assign n2395 = reset ? 20'b00000000000000000000 : n2382;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1468:25 */
  assign n2397 = reset ? 15'b000000000000000 : n2383;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1468:25 */
  assign n2399 = reset ? 7'b0000000 : n2384;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1468:25 */
  assign n2401 = reset ? 3'b000 : n2385;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1468:25 */
  assign n2403 = reset ? 1'b0 : n2386;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1618:89 */
  assign n2418 = ~remove_pops;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1618:9 */
  apu_dac_Bapu_dac_arch sq1_dac (
    .clk(clk),
    .ce(ce),
    .dac_en(sq1_dac_en),
    .dac_invert(n2418),
    .dac_input(sq1_wav),
    .dac_output(sq1_dac_n2419));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1619:89 */
  assign n2422 = ~remove_pops;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1619:9 */
  apu_dac_Bapu_dac_arch sq2_dac (
    .clk(clk),
    .ce(ce),
    .dac_en(sq2_dac_en),
    .dac_invert(n2422),
    .dac_input(sq2_wav),
    .dac_output(sq2_dac_n2423));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1620:89 */
  assign n2426 = ~remove_pops;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1620:9 */
  apu_dac_Bapu_dac_arch wav_dac (
    .clk(clk),
    .ce(ce),
    .dac_en(wav_enable),
    .dac_invert(n2426),
    .dac_input(wav_wav),
    .dac_output(wav_dac_n2427));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1621:89 */
  assign n2430 = ~remove_pops;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1621:9 */
  apu_dac_Bapu_dac_arch noi_dac (
    .clk(clk),
    .ce(ce),
    .dac_en(noi_dac_en),
    .dac_invert(n2430),
    .dac_input(noi_wav),
    .dac_output(noi_dac_n2431));
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1645:34 */
  assign n2439 = ch_map[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1646:62 */
  assign n2441 = {{2{sq1_dac_out[8]}}, sq1_dac_out}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1646:62 */
  assign n2442 = 11'b00000000000 + n2441;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1645:25 */
  assign n2444 = n2439 ? n2442 : 11'b00000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1649:34 */
  assign n2446 = ch_map[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1650:61 */
  assign n2448 = {{2{sq1_dac_out[8]}}, sq1_dac_out}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1650:61 */
  assign n2449 = 11'b00000000000 + n2448;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1649:25 */
  assign n2451 = n2446 ? n2449 : 11'b00000000000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1645:34 */
  assign n2453 = ch_map[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1646:62 */
  assign n2454 = {{2{sq2_dac_out[8]}}, sq2_dac_out}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1646:62 */
  assign n2455 = n2444 + n2454;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1645:25 */
  assign n2456 = n2453 ? n2455 : n2444;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1649:34 */
  assign n2457 = ch_map[5]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1650:61 */
  assign n2458 = {{2{sq2_dac_out[8]}}, sq2_dac_out}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1650:61 */
  assign n2459 = n2451 + n2458;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1649:25 */
  assign n2460 = n2457 ? n2459 : n2451;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1645:34 */
  assign n2461 = ch_map[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1646:62 */
  assign n2462 = {{2{wav_dac_out[8]}}, wav_dac_out}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1646:62 */
  assign n2463 = n2456 + n2462;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1645:25 */
  assign n2464 = n2461 ? n2463 : n2456;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1649:34 */
  assign n2465 = ch_map[6]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1650:61 */
  assign n2466 = {{2{wav_dac_out[8]}}, wav_dac_out}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1650:61 */
  assign n2467 = n2460 + n2466;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1649:25 */
  assign n2468 = n2465 ? n2467 : n2460;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1645:34 */
  assign n2469 = ch_map[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1646:62 */
  assign n2470 = {{2{noi_dac_out[8]}}, noi_dac_out}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1646:62 */
  assign n2471 = n2464 + n2470;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1645:25 */
  assign n2472 = n2469 ? n2471 : n2464;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1649:34 */
  assign n2473 = ch_map[7]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1650:61 */
  assign n2474 = {{2{noi_dac_out[8]}}, noi_dac_out}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1650:61 */
  assign n2475 = n2468 + n2474;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1649:25 */
  assign n2476 = n2473 ? n2475 : n2468;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1654:64 */
  assign n2477 = ch_vol[2:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1654:56 */
  assign n2479 = {2'b00, n2477};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1654:78 */
  assign n2482 = n2479 + 5'b00001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1654:41 */
  assign n2483 = {{5{n2472[10]}}, n2472}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1654:41 */
  assign n2484 = {{11{n2482[4]}}, n2482}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1654:41 */
  assign n2485 = $signed(n2483) * $signed(n2484); // smul
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1656:55 */
  assign n2487 = n2485 << 31'b0000000000000000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1655:17 */
  assign n2488 = remove_pops ? n2487 : n2485;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1661:63 */
  assign n2489 = ch_vol[6:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1661:55 */
  assign n2491 = {2'b00, n2489};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1661:77 */
  assign n2494 = n2491 + 5'b00001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1661:40 */
  assign n2495 = {{5{n2476[10]}}, n2476}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1661:40 */
  assign n2496 = {{11{n2494[4]}}, n2494}; // sext
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1661:40 */
  assign n2497 = $signed(n2495) * $signed(n2496); // smul
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1663:54 */
  assign n2499 = n2497 << 31'b0000000000000000000000000000001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1662:17 */
  assign n2500 = remove_pops ? n2499 : n2497;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:166:12 */
  assign n2503 = {\ireg_savestate_sound1.bus_dout , \ireg_savestate_sound2.bus_dout , \ireg_savestate_sound3.bus_dout , \ireg_savestate_wave1.bus_dout , \ireg_savestate_wave2.bus_dout , \ireg_savestate_wave1_gbc.bus_dout , \ireg_savestate_wave2_gbc.bus_dout };
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:169:12 */
  assign n2504 = {sq2_envper, sq2_envsgn, sq2_svol, sq2_slen, sq2_duty, sq1_trigger, sq1_lenchk, sq1_freq, sq1_envper, sq1_envsgn, sq1_svol, 6'b000000, sq1_duty, sq1_swshift, sq1_swdir, sq1_swper, 1'b0, en_sweep, en_env, en_len, en_snden4, en_snden2, en_len_r, framecnt, 1'b0};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:171:12 */
  assign n2505 = {snd_enable, noi_lenchk, noi_trigger, noi_div, noi_short, noi_freqsh, noi_envper, noi_envsgn, noi_svol, noi_slen, wav_lenchk, wav_trigger, wav_freq, wav_volsh, wav_enable, sq2_trigger, sq2_lenchk, sq2_freq};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:173:12 */
  assign n2506 = {noi_vol, noi_playing, wav_access, wav_index, wav_playing, wav_wav_r, 2'b00, sq2_vol, sq2_playing, sq1_vol, sq1_fr2, sq1_playing, sq1_slen, ch_vol, ch_map};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:176:12 */
  assign n2507 = {n191, n189, n187, n185, n183, n181, n179, n177, n175, n173, n171, n169, n167, n165, n163, n161};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:178:12 */
  assign n2508 = {n192, n190, n188, n186, n184, n182, n180, n178, n176, n174, n172, n170, n168, n166, n164, n162};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:234:17 */
  always @(posedge clk)
    n2509 <= n141;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:234:17 */
  always @(posedge clk)
    n2510 <= n142;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:234:17 */
  always @(posedge clk)
    n2511 <= n143;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:234:17 */
  always @(posedge clk)
    n2512 <= n144;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:234:17 */
  always @(posedge clk)
    n2513 <= n145;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:234:17 */
  always @(posedge clk)
    n2514 <= n146;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2515 <= n927;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2516 <= n928;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2517 <= n929;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2518 <= n930;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2519 <= n931;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2520 <= n932;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2521 <= n933;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2522 <= n934;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2523 <= n1687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2524 <= n935;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2525 <= n936;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2526 <= n937;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2527 <= n938;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2528 <= n939;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2529 <= n940;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2530 <= n941;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2531 <= n1688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2532 <= n1689;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2533 <= n942;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2534 <= n943;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2535 <= n944;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2536 <= n1690;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2537 <= n1691;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2538 <= n1693;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2539 <= n1997;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2540 <= n945;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2541 <= n946;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2542 <= n947;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2543 <= n948;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2544 <= n949;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2545 <= n950;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2546 <= n951;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2547 <= n952;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2548 <= n953;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2549 <= n954;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2550 <= n955;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2551 <= n956;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2552 <= n957;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2553 <= n1998;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2554 <= n1999;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2555 <= n2001;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2556 <= n958;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2557 <= n959;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2558 <= n960;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2559 <= n961;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2560 <= n962;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2561 <= n963;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2562 <= n964;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2563 <= n965;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1343:17 */
  always @(posedge clk)
    n2564 <= n2173;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1343:17 */
  always @(posedge clk)
    n2565 <= n2174;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1343:17 */
  always @(posedge clk)
    n2566 <= n2175;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2567 <= n966;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1343:17 */
  always @(posedge clk)
    n2568 <= n2176;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2569 <= n967;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2570 <= n968;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2571 <= n969;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2572 <= n970;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2573 <= n971;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2574 <= n972;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2575 <= n973;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2576 <= n974;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2577 <= n975;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2578 <= n976;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2579 <= n977;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2580 <= n978;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2581 <= n979;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2582 <= n980;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2583 <= n981;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1467:17 */
  always @(posedge clk)
    n2584 <= n2389;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1467:17 */
  always @(posedge clk)
    n2585 <= n2390;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2586 <= n982;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2587 <= n983;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:234:17 */
  always @(posedge clk)
    n2588 <= n147;
  initial
    n2588 = 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2589 <= n1695;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2590 <= n2003;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1343:17 */
  always @(posedge clk)
    n2591 <= n2178;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1467:17 */
  always @(posedge clk)
    n2592 <= n2392;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2593 <= n985;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:234:17 */
  always @(posedge clk)
    n2594 <= n149;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2595 <= n987;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2596 <= n989;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2597 <= n991;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:370:17 */
  always @(posedge clk)
    n2598 <= n993;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2599 <= n1697;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2600 <= n1699;
  initial
    n2600 = 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2601 <= n1701;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2602 <= n1703;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2603 <= n1705;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2604 <= n1709;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2605 <= n1711;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2606 <= n1713;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2607 <= n1715;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2608 <= n1717;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2609 <= n1719;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:838:17 */
  always @(posedge clk)
    n2610 <= n1721;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2611 <= n2005;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2612 <= n2007;
  initial
    n2612 = 3'b000;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2613 <= n2009;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2614 <= n2011;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2615 <= n2013;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1143:17 */
  always @(posedge clk)
    n2616 <= n2015;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1343:17 */
  always @(posedge clk)
    n2617 <= n2180;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1343:17 */
  always @(posedge clk)
    n2618 <= n2182;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1343:17 */
  always @(posedge clk)
    n2619 <= n2184;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1343:17 */
  always @(posedge clk)
    n2620 <= n2188;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1467:17 */
  always @(posedge clk)
    n2621 <= n2393;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1467:17 */
  always @(posedge clk)
    n2622 <= n2395;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1467:17 */
  always @(posedge clk)
    n2623 <= n2397;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1467:17 */
  always @(posedge clk)
    n2624 <= n2399;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1467:17 */
  always @(posedge clk)
    n2625 <= n2401;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1467:17 */
  always @(posedge clk)
    n2626 <= n2403;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:884:98 */
  reg n2627[7:0] ; // memory
  initial begin
    n2627[7] = 1'b1;
    n2627[6] = 1'b0;
    n2627[5] = 1'b0;
    n2627[4] = 1'b0;
    n2627[3] = 1'b0;
    n2627[2] = 1'b0;
    n2627[1] = 1'b0;
    n2627[0] = 1'b0;
    end
  assign n2629 = n2627[n1305];
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:884:98 */
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:885:98 */
  reg n2630[7:0] ; // memory
  initial begin
    n2630[7] = 1'b1;
    n2630[6] = 1'b0;
    n2630[5] = 1'b0;
    n2630[4] = 1'b0;
    n2630[3] = 1'b0;
    n2630[2] = 1'b0;
    n2630[1] = 1'b0;
    n2630[0] = 1'b1;
    end
  assign n2632 = n2630[n1305];
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:885:98 */
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:886:98 */
  reg n2633[7:0] ; // memory
  initial begin
    n2633[7] = 1'b1;
    n2633[6] = 1'b1;
    n2633[5] = 1'b1;
    n2633[4] = 1'b0;
    n2633[3] = 1'b0;
    n2633[2] = 1'b0;
    n2633[1] = 1'b0;
    n2633[0] = 1'b1;
    end
  assign n2635 = n2633[n1305];
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:886:98 */
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:887:98 */
  reg n2636[7:0] ; // memory
  initial begin
    n2636[7] = 1'b0;
    n2636[6] = 1'b1;
    n2636[5] = 1'b1;
    n2636[4] = 1'b1;
    n2636[3] = 1'b1;
    n2636[2] = 1'b1;
    n2636[1] = 1'b1;
    n2636[0] = 1'b0;
    end
  assign n2638 = n2636[n1305];
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:887:98 */
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1180:90 */
  reg n2639[7:0] ; // memory
  initial begin
    n2639[7] = 1'b1;
    n2639[6] = 1'b0;
    n2639[5] = 1'b0;
    n2639[4] = 1'b0;
    n2639[3] = 1'b0;
    n2639[2] = 1'b0;
    n2639[1] = 1'b0;
    n2639[0] = 1'b0;
    end
  assign n2641 = n2639[n1789];
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1180:90 */
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1181:90 */
  reg n2642[7:0] ; // memory
  initial begin
    n2642[7] = 1'b1;
    n2642[6] = 1'b0;
    n2642[5] = 1'b0;
    n2642[4] = 1'b0;
    n2642[3] = 1'b0;
    n2642[2] = 1'b0;
    n2642[1] = 1'b0;
    n2642[0] = 1'b1;
    end
  assign n2644 = n2642[n1789];
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1181:90 */
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1182:90 */
  reg n2645[7:0] ; // memory
  initial begin
    n2645[7] = 1'b1;
    n2645[6] = 1'b1;
    n2645[5] = 1'b1;
    n2645[4] = 1'b0;
    n2645[3] = 1'b0;
    n2645[2] = 1'b0;
    n2645[1] = 1'b0;
    n2645[0] = 1'b1;
    end
  assign n2647 = n2645[n1789];
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1182:90 */
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1183:90 */
  reg n2648[7:0] ; // memory
  initial begin
    n2648[7] = 1'b0;
    n2648[6] = 1'b1;
    n2648[5] = 1'b1;
    n2648[4] = 1'b1;
    n2648[3] = 1'b1;
    n2648[2] = 1'b1;
    n2648[1] = 1'b1;
    n2648[0] = 1'b0;
    end
  assign n2650 = n2648[n1789];
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1183:90 */
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2651 = n607[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2652 = ~n2651;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2653 = n607[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2654 = ~n2653;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2655 = n2652 & n2654;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2656 = n2652 & n2653;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2657 = n2651 & n2654;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2658 = n2651 & n2653;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2659 = n607[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2660 = ~n2659;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2661 = n2655 & n2660;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2662 = n2655 & n2659;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2663 = n2656 & n2660;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2664 = n2656 & n2659;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2665 = n2657 & n2660;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2666 = n2657 & n2659;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2667 = n2658 & n2660;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2668 = n2658 & n2659;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2669 = n607[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2670 = ~n2669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2671 = n2661 & n2670;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2672 = n2661 & n2669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2673 = n2662 & n2670;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2674 = n2662 & n2669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2675 = n2663 & n2670;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2676 = n2663 & n2669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2677 = n2664 & n2670;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2678 = n2664 & n2669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2679 = n2665 & n2670;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2680 = n2665 & n2669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2681 = n2666 & n2670;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2682 = n2666 & n2669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2683 = n2667 & n2670;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2684 = n2667 & n2669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2685 = n2668 & n2670;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2686 = n2668 & n2669;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2687 = n607[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2688 = ~n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2689 = n2671 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2690 = n2671 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2691 = n2672 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2692 = n2672 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2693 = n2673 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2694 = n2673 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2695 = n2674 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2696 = n2674 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2697 = n2675 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2698 = n2675 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2699 = n2676 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2700 = n2676 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2701 = n2677 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2702 = n2677 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2703 = n2678 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2704 = n2678 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2705 = n2679 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2706 = n2679 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2707 = n2680 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2708 = n2680 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2709 = n2681 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2710 = n2681 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2711 = n2682 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2712 = n2682 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2713 = n2683 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2714 = n2683 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2715 = n2684 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2716 = n2684 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2717 = n2685 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2718 = n2685 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2719 = n2686 & n2688;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2720 = n2686 & n2687;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2721 = wav_ram[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2722 = n2689 ? n609 : n2721;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2723 = wav_ram[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2724 = n2690 ? n609 : n2723;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2725 = wav_ram[11:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2726 = n2691 ? n609 : n2725;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2727 = wav_ram[15:12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2728 = n2692 ? n609 : n2727;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2729 = wav_ram[19:16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2730 = n2693 ? n609 : n2729;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2731 = wav_ram[23:20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2732 = n2694 ? n609 : n2731;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2733 = wav_ram[27:24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2734 = n2695 ? n609 : n2733;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2735 = wav_ram[31:28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2736 = n2696 ? n609 : n2735;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2737 = wav_ram[35:32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2738 = n2697 ? n609 : n2737;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2739 = wav_ram[39:36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2740 = n2698 ? n609 : n2739;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2741 = wav_ram[43:40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2742 = n2699 ? n609 : n2741;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2743 = wav_ram[47:44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2744 = n2700 ? n609 : n2743;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2745 = wav_ram[51:48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2746 = n2701 ? n609 : n2745;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2747 = wav_ram[55:52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2748 = n2702 ? n609 : n2747;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2749 = wav_ram[59:56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2750 = n2703 ? n609 : n2749;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2751 = wav_ram[63:60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2752 = n2704 ? n609 : n2751;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2753 = wav_ram[67:64]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2754 = n2705 ? n609 : n2753;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2755 = wav_ram[71:68]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2756 = n2706 ? n609 : n2755;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2757 = wav_ram[75:72]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2758 = n2707 ? n609 : n2757;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2759 = wav_ram[79:76]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2760 = n2708 ? n609 : n2759;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2761 = wav_ram[83:80]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2762 = n2709 ? n609 : n2761;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2763 = wav_ram[87:84]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2764 = n2710 ? n609 : n2763;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2765 = wav_ram[91:88]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2766 = n2711 ? n609 : n2765;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2767 = wav_ram[95:92]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2768 = n2712 ? n609 : n2767;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2769 = wav_ram[99:96]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2770 = n2713 ? n609 : n2769;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2771 = wav_ram[103:100]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2772 = n2714 ? n609 : n2771;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2773 = wav_ram[107:104]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2774 = n2715 ? n609 : n2773;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2775 = wav_ram[111:108]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2776 = n2716 ? n609 : n2775;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2777 = wav_ram[115:112]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2778 = n2717 ? n609 : n2777;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2779 = wav_ram[119:116]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2780 = n2718 ? n609 : n2779;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2781 = wav_ram[123:120]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2782 = n2719 ? n609 : n2781;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2783 = wav_ram[127:124]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2784 = n2720 ? n609 : n2783;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:685:65 */
  assign n2785 = {n2784, n2782, n2780, n2778, n2776, n2774, n2772, n2770, n2768, n2766, n2764, n2762, n2760, n2758, n2756, n2754, n2752, n2750, n2748, n2746, n2744, n2742, n2740, n2738, n2736, n2734, n2732, n2730, n2728, n2726, n2724, n2722};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2786 = n616[4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2787 = ~n2786;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2788 = n616[3]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2789 = ~n2788;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2790 = n2787 & n2789;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2791 = n2787 & n2788;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2792 = n2786 & n2789;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2793 = n2786 & n2788;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2794 = n616[2]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2795 = ~n2794;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2796 = n2790 & n2795;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2797 = n2790 & n2794;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2798 = n2791 & n2795;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2799 = n2791 & n2794;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2800 = n2792 & n2795;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2801 = n2792 & n2794;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2802 = n2793 & n2795;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2803 = n2793 & n2794;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2804 = n616[1]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2805 = ~n2804;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2806 = n2796 & n2805;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2807 = n2796 & n2804;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2808 = n2797 & n2805;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2809 = n2797 & n2804;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2810 = n2798 & n2805;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2811 = n2798 & n2804;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2812 = n2799 & n2805;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2813 = n2799 & n2804;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2814 = n2800 & n2805;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2815 = n2800 & n2804;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2816 = n2801 & n2805;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2817 = n2801 & n2804;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2818 = n2802 & n2805;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2819 = n2802 & n2804;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2820 = n2803 & n2805;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2821 = n2803 & n2804;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2822 = n616[0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2823 = ~n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2824 = n2806 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2825 = n2806 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2826 = n2807 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2827 = n2807 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2828 = n2808 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2829 = n2808 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2830 = n2809 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2831 = n2809 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2832 = n2810 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2833 = n2810 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2834 = n2811 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2835 = n2811 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2836 = n2812 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2837 = n2812 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2838 = n2813 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2839 = n2813 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2840 = n2814 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2841 = n2814 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2842 = n2815 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2843 = n2815 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2844 = n2816 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2845 = n2816 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2846 = n2817 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2847 = n2817 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2848 = n2818 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2849 = n2818 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2850 = n2819 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2851 = n2819 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2852 = n2820 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2853 = n2820 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2854 = n2821 & n2823;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2855 = n2821 & n2822;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2856 = n2785[3:0]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2857 = n2824 ? n618 : n2856;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2858 = n2785[7:4]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2859 = n2825 ? n618 : n2858;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2860 = n2785[11:8]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2861 = n2826 ? n618 : n2860;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2862 = n2785[15:12]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2863 = n2827 ? n618 : n2862;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2864 = n2785[19:16]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2865 = n2828 ? n618 : n2864;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2866 = n2785[23:20]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2867 = n2829 ? n618 : n2866;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2868 = n2785[27:24]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2869 = n2830 ? n618 : n2868;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2870 = n2785[31:28]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2871 = n2831 ? n618 : n2870;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2872 = n2785[35:32]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2873 = n2832 ? n618 : n2872;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2874 = n2785[39:36]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2875 = n2833 ? n618 : n2874;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2876 = n2785[43:40]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2877 = n2834 ? n618 : n2876;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2878 = n2785[47:44]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2879 = n2835 ? n618 : n2878;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2880 = n2785[51:48]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2881 = n2836 ? n618 : n2880;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2882 = n2785[55:52]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2883 = n2837 ? n618 : n2882;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2884 = n2785[59:56]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2885 = n2838 ? n618 : n2884;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2886 = n2785[63:60]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2887 = n2839 ? n618 : n2886;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2888 = n2785[67:64]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2889 = n2840 ? n618 : n2888;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2890 = n2785[71:68]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2891 = n2841 ? n618 : n2890;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2892 = n2785[75:72]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2893 = n2842 ? n618 : n2892;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2894 = n2785[79:76]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2895 = n2843 ? n618 : n2894;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2896 = n2785[83:80]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2897 = n2844 ? n618 : n2896;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2898 = n2785[87:84]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2899 = n2845 ? n618 : n2898;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2900 = n2785[91:88]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2901 = n2846 ? n618 : n2900;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2902 = n2785[95:92]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2903 = n2847 ? n618 : n2902;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2904 = n2785[99:96]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2905 = n2848 ? n618 : n2904;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2906 = n2785[103:100]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2907 = n2849 ? n618 : n2906;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2908 = n2785[107:104]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2909 = n2850 ? n618 : n2908;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2910 = n2785[111:108]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2911 = n2851 ? n618 : n2910;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2912 = n2785[115:112]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2913 = n2852 ? n618 : n2912;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2914 = n2785[119:116]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2915 = n2853 ? n618 : n2914;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2916 = n2785[123:120]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2917 = n2854 ? n618 : n2916;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2918 = n2785[127:124]; // extract
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2919 = n2855 ? n618 : n2918;
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:686:65 */
  assign n2920 = {n2919, n2917, n2915, n2913, n2911, n2909, n2907, n2905, n2903, n2901, n2899, n2897, n2895, n2893, n2891, n2889, n2887, n2885, n2883, n2881, n2879, n2877, n2875, n2873, n2871, n2869, n2867, n2865, n2863, n2861, n2859, n2857};
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:759:64 */
  assign n2921 = wav_ram[n1150 * 4 +: 4]; //(Bmux)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:759:102 */
  assign n2922 = wav_ram[n1158 * 4 +: 4]; //(Bmux)
  /*# E:/tangnano20k_gbc_native/rtl/gb/gbc_snd.vhd:1389:87 */
  assign n2923 = wav_ram[n2097 * 4 +: 4]; //(Bmux)
endmodule

