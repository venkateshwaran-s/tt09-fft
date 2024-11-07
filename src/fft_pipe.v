// Author: Venkateshwaran S
// Date: 22-Sept-2021

// Radix-2 8-Point DIT[FFT/IFFT] architecture: The design performs bit-reversal internally at input and outputs are in-order
// Pipelined

`timescale 1ns/1ns

module tt_um_venkat_fft_rx2_8pt_pipe(
                clk,            // Clock
                mode,           // Mode: 0-FFT, 1-IFFT
                reset,          // Reset Operation
                xin_r0,         // Inputs: 0 to 7 (Real part)
                xin_r1,
                xin_r2,
                xin_r3,
                xin_r4,
                xin_r5,
                xin_r6,
                xin_r7,
                xin_i0,         // Inputs: 0 to 7 (Imaginary Part)             
                xin_i1,
                xin_i2,
                xin_i3,
                xin_i4,
                xin_i5,
                xin_i6,
                xin_i7,
                y0_r,           // Outputs: 0 to 7 (Real Part)
                y1_r,
                y2_r,
                y3_r,
                y4_r,
                y5_r,
                y6_r,
                y7_r,
                y0_i,           // Outputs: 0 to 7 (Real Part)
                y1_i,
                y2_i,
                y3_i,
                y4_i,
                y5_i,
                y6_i,
                y7_i);
  
  // clk : Input clock
  // mode: 0-FFT and 1-IFFT
  // reset: Active High
  input clk,mode,reset;
  // Input Real and Imaginary counterparts
  input signed [15:0] xin_r0, xin_r1, xin_r2, xin_r3, xin_r4, xin_r5, xin_r6, xin_r7, xin_i0, xin_i1, xin_i2, xin_i3, xin_i4, xin_i5, xin_i6, xin_i7;
  // Output Real and Imaginary counterparts
  output reg signed [15:0]y0_r, y1_r, y2_r, y3_r, y4_r, y5_r, y6_r, y7_r, y0_i, y1_i, y2_i, y3_i, y4_i, y5_i, y6_i, y7_i;
  // Pruned input signals
  reg signed [18:0] x0_rn,x1_rn,x2_rn,x3_rn,x4_rn,x5_rn,x6_rn,x7_rn,x0_in,x1_in,x2_in,x3_in,x4_in,x5_in,x6_in,x7_in;
  wire signed [15:0] x0_r,x1_r,x2_r,x3_r,x4_r,x5_r,x6_r,x7_r,x0_i,x1_i,x2_i,x3_i,x4_i,x5_i,x6_i,x7_i;
  // Output from Butteryfly Pipeline 
  wire signed[15:0] y0_r1,y1_r1,y2_r1,y3_r1,y4_r1,y5_r1,y6_r1,y7_r1,y0_i1,y1_i1,y2_i1,y3_i1,y4_i1,y5_i1,y6_i1,y7_i1;
  
  always@(posedge clk)
    begin
        // FFT Operation
        if (mode==0)//fft
        begin
            // Fixed Point representation: Q4.15
            // MSB bit extension to support three stage addition
            x0_rn <= {{3{xin_r0[15]}}, xin_r0};
            x1_rn <= {{3{xin_r1[15]}}, xin_r1};
            x2_rn <= {{3{xin_r2[15]}}, xin_r2};
            x3_rn <= {{3{xin_r3[15]}}, xin_r3};
            x4_rn <= {{3{xin_r4[15]}}, xin_r4};
            x5_rn <= {{3{xin_r5[15]}}, xin_r5};
            x6_rn <= {{3{xin_r6[15]}}, xin_r6};
            x7_rn <= {{3{xin_r7[15]}}, xin_r7};
            x0_in <= {{3{xin_i0[15]}}, xin_i0};
            x1_in <= {{3{xin_i1[15]}}, xin_i1};
            x2_in <= {{3{xin_i2[15]}}, xin_i2};
            x3_in <= {{3{xin_i3[15]}}, xin_i3};
            x4_in <= {{3{xin_i4[15]}}, xin_i4};
            x5_in <= {{3{xin_i5[15]}}, xin_i5};
            x6_in <= {{3{xin_i6[15]}}, xin_i6};
            x7_in <= {{3{xin_i7[15]}}, xin_i7};
          
            // Output drivers of FFT Module from Butterfly Pipeline
            y0_r <= y0_r1;
            y1_r <= y1_r1;
            y2_r <= y2_r1;
            y3_r <= y3_r1;
            y4_r <= y4_r1;
            y5_r <= y5_r1;
            y6_r <= y6_r1;
            y7_r <= y7_r1;
            y0_i <= y0_i1;
            y1_i <= y1_i1;
            y2_i <= y2_i1;
            y3_i <= y3_i1;
            y4_i <= y4_i1;
            y5_i <= y5_i1;
            y6_i <= y6_i1;
            y7_i <= y7_i1;
        end
  	    else
        // IFFT Operation
        // Step 1: Swap Real and Imaginary parts at Input
        // Step 2: Swap Real and Imaginary parts at Output
        // Step 3: Divide Output by 8

        // Fixed Point representation: Q4.15
        // MSB bit extension to support three stage addition   
        begin
            x0_rn <= {{3{xin_i0[15]}}, xin_i0};
            x1_rn <= {{3{xin_i1[15]}}, xin_i1};
            x2_rn <= {{3{xin_i2[15]}}, xin_i2};
            x3_rn <= {{3{xin_i3[15]}}, xin_i3};
            x4_rn <= {{3{xin_i4[15]}}, xin_i4};
            x5_rn <= {{3{xin_i5[15]}}, xin_i5};
            x6_rn <= {{3{xin_i6[15]}}, xin_i6};
            x7_rn <= {{3{xin_i7[15]}}, xin_i7};
            x0_in <= {{3{xin_r0[15]}}, xin_r0};
            x1_in <= {{3{xin_r1[15]}}, xin_r1};
            x2_in <= {{3{xin_r2[15]}}, xin_r2};
            x3_in <= {{3{xin_r3[15]}}, xin_r3};
            x4_in <= {{3{xin_r4[15]}}, xin_r4};
            x5_in <= {{3{xin_r5[15]}}, xin_r5};
            x6_in <= {{3{xin_r6[15]}}, xin_r6};
            x7_in <= {{3{xin_r7[15]}}, xin_r7};
          
            // Output drivers of FFT Module from Butterfly Pipeline (for IFFT Mode)
            y0_i <= y0_r1 / 8;
            y0_r <= y0_i1 / 8;
            y4_r <= y4_i1 / 8;
            y4_i <= y4_r1 / 8;

            y1_i <= y1_r1 / 8;
            y1_r <= y1_i1 / 8;
            y5_i <= y5_r1 / 8;
            y5_r <= y5_i1 / 8;

            y2_i <= y2_r1 / 8;
            y2_r <= y2_i1 / 8;
            y6_i <= y6_r1 / 8;
            y6_r <= y6_i1 / 8;

            y3_i <= y3_r1 / 8;
            y3_r <= y3_i1 / 8;
            y7_i <= y7_r1 / 8;         
            y7_r <= y7_i1 / 8;        
        end
    end

  // Fixed Point representation: Q4.12
  // Ignoring 3-LSB bits to preserve 16-bit format
  assign x0_r = x0_rn[18:3];
  assign x1_r = x1_rn[18:3];
  assign x2_r = x2_rn[18:3];
  assign x3_r = x3_rn[18:3];
  assign x4_r = x4_rn[18:3];
  assign x5_r = x5_rn[18:3];
  assign x6_r = x6_rn[18:3];
  assign x7_r = x7_rn[18:3];
  
  assign x0_i = x0_in[18:3];
  assign x1_i = x1_in[18:3];
  assign x2_i = x2_in[18:3];
  assign x3_i = x3_in[18:3];
  assign x4_i = x4_in[18:3];
  assign x5_i = x5_in[18:3];
  assign x6_i = x6_in[18:3];
  assign x7_i = x7_in[18:3];
  
  // Instantiate the Butteryfly Pipeline
  // Pass the pruned signals as input
  // Output after butterfly operation
  butterfly_pipe butterfly_pipe(.clk(clk), .reset(reset), .x0_r(x0_r), .x1_r(x1_r), .x2_r(x2_r), .x3_r(x3_r), .x4_r(x4_r), .x5_r(x5_r), .x6_r(x6_r), .x7_r(x7_r), .x0_i(x0_i), .x1_i(x1_i), .x2_i(x2_i), .x3_i(x3_i), .x4_i(x4_i), .x5_i(x5_i), .x6_i(x6_i), .x7_i(x7_i), .y0_r(y0_r1), .y1_r(y1_r1), .y2_r(y2_r1), .y3_r(y3_r1), .y4_r(y4_r1), .y5_r(y5_r1), .y6_r(y6_r1), .y7_r(y7_r1), .y0_i(y0_i1), .y1_i(y1_i1), .y2_i(y2_i1), .y3_i(y3_i1), .y4_i(y4_i1), .y5_i(y5_i1), .y6_i(y6_i1), .y7_i(y7_i1));

endmodule: tt_um_venkat_fft_rx2_8pt_pipe

module butterfly_pipe(
                clk,            // Clock
                reset,          // Reset Operation
                x0_r,           // Inputs: 0 to 7 (Imaginary Part) from top module
                x1_r,
                x2_r,
                x3_r,
                x4_r,
                x5_r,
                x6_r,
                x7_r,
                x0_i,
                x1_i,
                x2_i,
                x3_i,
                x4_i,
                x5_i,
                x6_i,
                x7_i,
                y0_r,           // Inputs: 0 to 7 (Real Part) from top module
                y1_r,
                y2_r,
                y3_r,
                y4_r,
                y5_r,
                y6_r,
                y7_r,
                y0_i,
                y1_i,
                y2_i,
                y3_i,
                y4_i,
                y5_i,
                y6_i,
                y7_i);
  // clk : Input clock
  // reset: Active High           
  input clk,reset;
  // Pruned input signals
  input signed [15:0] x0_r,x1_r,x2_r,x3_r,x4_r,x5_r,x6_r,x7_r,x0_i,x1_i,x2_i,x3_i,x4_i,x5_i,x6_i,x7_i;
  // Butterfly Pipeline output signals 
  output signed [15:0] y0_r,y1_r,y2_r,y3_r,y4_r,y5_r,y6_r,y7_r,y0_i,y1_i,y2_i,y3_i,y4_i,y5_i,y6_i,y7_i;
  // Stage: 1 intermediate outputs
  reg signed [15:0] a0_r,a1_r,a2_r,a3_r,a4_r,a5_r,a6_r,a7_r,a0_i,a1_i,a2_i,a3_i,a4_i,a5_i,a6_i,a7_i;
  // Stage: 2 intermediate outputs
  reg signed [15:0] h0_r,h1_r,h2_r,h3_r,h4_r,h5_r,h6_r,h7_r,h0_i,h1_i,h2_i,h3_i,h4_i,h5_i,h6_i,h7_i;
  // Multiplier outputs
  wire signed[31:0] s1_04r, s1_04i, s1_26r, s1_26i, s1_15r, s1_15i, s1_37r, s1_37i; // Stage: 1
  wire signed[31:0] s2_02r, s2_02i, s2_13r, s2_13i, s2_46r, s2_46i, s2_57r, s2_57i; // Stage: 2
  wire signed[31:0] s3_04r, s3_04i, s3_15r, s3_15i, s3_26r, s3_26i, s3_37r, s3_37i; // Stage: 3

  // Cyclic Twiddle factors (TF): Real and Imaginary Parts (Preset)
  // Signed 2's Compilement form
  // Fixed point representation: Q1.15 

  // TF: 0 
  parameter signed [15:0] w0_r = 16'h7FFF;  // +1 
  parameter signed [15:0] w0_i = 16'h0000;  // +j0
  // TF: 1
  parameter signed [15:0] w1_r = 16'h5A82;  // +0.707
  parameter signed [15:0] w1_i = 16'hA57E;  // -j0.707
  // TF: 2
  parameter signed [15:0] w2_r = 16'h0000;  // +0
  parameter signed [15:0] w2_i = 16'h8000;  // -j1
  // TF: 3
  parameter signed [15:0] w3_r = 16'hA57E;  // -0.707
  parameter signed [15:0] w3_i = 16'hA57E;  // -j0.707

  // Results in Fixed Point representation: Q5.27
  // Multiplication results in doubling of total bits
  // One new integer bit is created 
  // (a + jb) * (c + jd) = Re(a*c - b*d) + Img(a*d + c*b)

  // MULTIPLIER STAGE
  // *** INPUT BIT REVERSED ORDERR ***

  //STAGE: 1
  assign s1_04r = x4_r*w0_r - x4_i*w0_i;
  assign s1_04i = x4_i*w0_r + x4_r*w0_i;
  assign s1_26r = x6_r*w0_r - x6_i*w0_i;
  assign s1_26i = x6_i*w0_r + x6_r*w0_i;
  assign s1_15r = x5_r*w0_r - x5_i*w0_i;
  assign s1_15i = x5_i*w0_r + x5_r*w0_i;
  assign s1_37r = x7_r*w0_r - x7_i*w0_i;
  assign s1_37i = x7_i*w0_r + x7_r*w0_i;
  
  // STAGE: 2
  assign s2_02r = a2_r*w0_r - a2_i*w0_i;
  assign s2_02i = a2_i*w0_r + a2_r*w0_i;
  assign s2_46r = a6_r*w0_r - a6_i*w0_i;
  assign s2_46i = a6_i*w0_r + a6_r*w0_i;
  assign s2_13r = a3_r*w2_r - a3_i*w2_i;
  assign s2_13i = a3_i*w2_r + a3_r*w2_i;
  assign s2_57r = a7_r*w2_r - a7_i*w2_i;
  assign s2_57i = a7_i*w2_r + a7_r*w2_i;
  
  // STAGE: 3
  assign s3_04r = h4_r*w0_r - h4_i*w0_i;
  assign s3_04i = h4_i*w0_r + h4_r*w0_i;
  assign s3_15r = h5_r*w1_r - h5_i*w1_i;
  assign s3_15i = h5_i*w1_r + h5_r*w1_i;
  assign s3_26r = h6_r*w2_r - h6_i*w2_i;
  assign s3_26i = h6_i*w2_r + h6_r*w2_i;
  assign s3_37r = h7_r*w3_r - h7_i*w3_i;
  assign s3_37i = h7_i*w3_r + h7_r*w3_i;
  
  // Output drivers of FFT Module (both FFT and IFFT Mode)
  // STAGE: 3
  // Pair: 1
  assign y0_r = h0_r + s3_04r[30:15];
  assign y0_i = h0_i + s3_04i[30:15];
  assign y4_r = h0_r - s3_04r[30:15];
  assign y4_i = h0_i - s3_04i[30:15];

  // Pair: 2
  assign y1_r = h1_r + s3_15r[30:15];
  assign y1_i = h1_i + s3_15i[30:15];
  assign y5_r = h1_r - s3_15r[30:15];
  assign y5_i = h1_i - s3_15i[30:15];
  
  // Pair: 3
  assign y2_r = h2_r + s3_26r[30:15];
  assign y2_i = h2_i + s3_26i[30:15];
  assign y6_r = h2_r - s3_26r[30:15];
  assign y6_i = h2_i - s3_26i[30:15];
  
  // Pair: 4
  assign y3_r = h3_r + s3_37r[30:15];
  assign y3_i = h3_i + s3_37i[30:15];
  assign y7_r = h3_r - s3_37r[30:15];
  assign y7_i = h3_i - s3_37i[30:15];

  
  always@(posedge clk)
    begin
        if(reset == 1)
        begin
            // Fixed Point Representation: Q4.12
            // Initialization

            // STAGE: 1
            // Pair: 1
            a0_r <= 0;
            a0_i <= 0;
            a1_r <= 0;
            a1_i <= 0; 

            // Pair: 2
            a2_r <= 0;
            a2_i <= 0;
            a3_r <= 0;
            a3_i <= 0;

            // Pair: 3
            a4_r <= 0;
            a4_i <= 0;
            a5_r <= 0;
            a5_i <= 0;

            // Pair: 4
            a6_r <= 0;
            a6_i <= 0;
            a7_r <= 0;
            a7_i <= 0;

            // STAGE: 2
            // Pair: 1
            h0_r <= 0;
            h0_i <= 0;
            h2_r <= 0;
            h2_i <= 0;

            // Pair: 2
            h1_r <= 0;
            h1_i <= 0;
            h3_r <= 0;
            h3_i <= 0;

            // Pair: 3
            h4_r <= 0;
            h4_i <= 0;
            h6_r <= 0;
            h6_i <= 0;

            // Pair: 4
            h5_r <= 0;
            h5_i <= 0;
            h7_r <= 0;
            h7_i <= 0;
        end
    else
        begin
            // Results in Fixed Point representation: Q4.12
            // Ignoring 3-MSB bits to preserve 16-bit format

            // ADDER-SUBTRACTOR STAGE
            // STAGE: 1 
            // Pair: 1
            a0_r <= x0_r + s1_04r[30:15];//4.12
            a0_i <= x0_i + s1_04i[30:15];
            a1_r <= x0_r - s1_04r[30:15];
            a1_i <= x0_i - s1_04i[30:15];

            // Pair: 2
            a2_r <= x2_r + s1_26r[30:15];
            a2_i <= x2_i + s1_26i[30:15];
            a3_r <= x2_r - s1_26r[30:15];
            a3_i <= x2_i - s1_26i[30:15];

            // Pair: 3
            a4_r <= x1_r + s1_15r[30:15];
            a4_i <= x1_i + s1_15i[30:15];
            a5_r <= x1_r - s1_15r[30:15];
            a5_i <= x1_i - s1_15i[30:15]; 

            // Pair: 4
            a6_r <= x3_r + s1_37r[30:15];
            a6_i <= x3_i + s1_37i[30:15];
            a7_r <= x3_r - s1_37r[30:15];
            a7_i <= x3_i - s1_37i[30:15];
           
            // STAGE: 2
            // Pair: 1
            h0_r <= a0_r + s2_02r[30:15];
            h0_i <= a0_i + s2_02i[30:15];
            h2_r <= a0_r - s2_02r[30:15];
            h2_i <= a0_i - s2_02i[30:15];

            // Pair: 2
            h1_r <= a1_r + s2_13r[30:15];
            h1_i <= a1_i + s2_13i[30:15];
            h3_r <= a1_r - s2_13r[30:15];
            h3_i <= a1_i - s2_13i[30:15];

            // Pair: 3
            h4_r <= a4_r + s2_46r[30:15];
            h4_i <= a4_i + s2_46i[30:15];
            h6_r <= a4_r - s2_46r[30:15];
            h6_i <= a4_i - s2_46i[30:15];

            // Pair: 4
            h5_r <= a5_r + s2_57r[30:15];
            h5_i <= a5_i + s2_57i[30:15];
            h7_r <= a5_r - s2_57r[30:15];
            h7_i <= a5_i - s2_57i[30:15];
        end
    end

endmodule: butterfly_pipe
  
  
