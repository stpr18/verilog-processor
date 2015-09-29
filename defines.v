`define REG2BUS(r) (r | 8'h10)

`define BUS_COPY 8'h01
`define BUS_MEMORY 8'h02
`define BUS_CMDARG_1 8'h03
`define BUS_CMDARG_2 8'h04
`define BUS_ALU 8'h05
`define BUS_JMP 8'h06
`define BUS_PC 8'h07
`define BUS_SYS 8'h08
`define BUS_LOOP 8'h09
`define BUS_R0 `REG2BUS(`REG_R0)
`define BUS_RH0 `REG2BUS(`REG_RH0)
`define BUS_RL0 `REG2BUS(`REG_RL0)
`define BUS_R1 `REG2BUS(`REG_R1)
`define BUS_RH1 `REG2BUS(`REG_RH1)
`define BUS_RL1 `REG2BUS(`REG_RL1)
`define BUS_R2 `REG2BUS(`REG_R2)
`define BUS_RH2 `REG2BUS(`REG_RH2)
`define BUS_RL2 `REG2BUS(`REG_RL2)
`define BUS_R3 `REG2BUS(`REG_R3)
`define BUS_RH3 `REG2BUS(`REG_RH3)
`define BUS_RL3 `REG2BUS(`REG_RL3)
`define BUS_R4 `REG2BUS(`REG_R4)
`define BUS_R5 `REG2BUS(`REG_R5)
`define BUS_R6 `REG2BUS(`REG_R6)
`define BUS_R7 `REG2BUS(`REG_R7)

`define REG_R0 4'b0011
`define REG_RH0 4'b0010
`define REG_RL0 4'b0001
`define REG_R1 4'b0111
`define REG_RH1 4'b0110
`define REG_RL1 4'b0101
`define REG_R2 4'b1011
`define REG_RH2 4'b1010
`define REG_RL2 4'b1001
`define REG_R3 4'b1111
`define REG_RH3 4'b1110
`define REG_RL3 4'b1101
`define REG_R4 4'b0000
`define REG_R5 4'b0100
`define REG_R6 4'b1000
`define REG_R7 4'b1100

`define CMDARG_1_RR 3'b000
`define CMDARG_1_RM 3'b001
`define CMDARG_1_RI 3'b010
`define CMDARG_1_MR 3'b011
`define CMDARG_1_MI 3'b100
`define CMDARG_2_R 2'b00
`define CMDARG_2_M1 2'b01
`define CMDARG_2_M2 2'b11
`define CMDARG_2_I 2'b10

`define CMD_MOV 5'b00001
`define CMD_ADD 5'b00010
`define CMD_SUB 5'b00100
`define CMD_AND 5'b00110
`define CMD_OR 5'b00111
`define CMD_XOR 5'b01000
`define CMD_SAL 5'b01001
`define CMD_SAR 5'b01010
`define CMD_SHR 5'b01011
`define CMD_RCL 5'b01100
`define CMD_RCR 5'b01101
`define CMD_ROL 5'b01110
`define CMD_ROR 5'b01111
`define CMD_TEST 5'b10000
`define CMD_CMP 5'b10001
`define CMD_ALU_UPPER 6'b110000
`define CMD_MULDIV_UPPER 8'b11000000
`define CMD_JMP_UPPER 6'b110001
`define CMD_LOOP_UPPER 6'b110010
`define CMD_MUL_LOWER 4'b0000
`define CMD_IMUL_LOWER 4'b0001
`define CMD_DIV_LOWER 4'b0010
`define CMD_IDIV_LOWER 4'b0011
`define CMD_NOT_LOWER 4'b0100
`define CMD_NEG_LOWER 4'b0101
`define CMD_INC_LOWER 4'b0110
`define CMD_DEC_LOWER 4'b0111
// `define CMD_STACK_UPPER 6'b110011
// `define CMD_PUSH_LOWER 4'b0000
// `define CMD_POP_LOWER 4'b0001
`define CMD_SYS 8'b11111111

`define CMD_TYPE_MUL 4'b0000
`define CMD_TYPE_IMUL 4'b0001
`define CMD_TYPE_DIV 4'b0010
`define CMD_TYPE_IDIV 4'b0011
`define CMD_TYPE_NOT 4'b0000
`define CMD_TYPE_NEG 4'b0001
`define CMD_TYPE_INC 4'b0010
`define CMD_TYPE_DEC 4'b0011

`define CMD_TYPE_DFIN 4'b0000
`define CMD_TYPE_DDIS1 4'b0001
`define CMD_TYPE_DDIS2 4'b0011
`define CMD_TYPE_DMPR 4'b0100

`define CMDARG_DIS_C 4'b0000
`define CMDARG_DIS_B 4'b0001
`define CMDARG_DIS_O 4'b0010
`define CMDARG_DIS_D 4'b0011
`define CMDARG_DIS_H 4'b0100
`define CMDARG_DIS_U 4'b0111

`define ALU_ADD 5'b00000
`define ALU_SUB 5'b00001
`define ALU_AND 5'b00010
`define ALU_OR 5'b00011
`define ALU_XOR 5'b00100
`define ALU_MUL 5'b00101
`define ALU_DIV 5'b00110
`define ALU_IMUL 5'b00111
`define ALU_IDIV 5'b01000
`define ALU_NOT 5'b01001
`define ALU_NEG 5'b01010
`define ALU_INC 5'b01011
`define ALU_DEC 5'b01100
`define ALU_SAL 5'b01101
`define ALU_SAR 5'b01111
`define ALU_SHR 5'b10000
`define ALU_RCL 5'b10001
`define ALU_RCR 5'b10010
`define ALU_ROL 5'b10011
`define ALU_ROR 5'b10100

`define ALUF_ZF 0
`define ALUF_SF 1
`define ALUF_CF 2
`define ALUF_OF 3

`define JMP_FORCE 4'h0
`define JMP_E 4'h1
`define JMP_NE 4'h2
`define JMP_A 4'h3
`define JMP_AE 4'h4
`define JMP_B 4'h5
`define JMP_BE 4'h6
`define JMP_G 4'h7
`define JMP_GE 4'h8
`define JMP_L 4'h9
`define JMP_LE 4'hA
`define JMP_S 4'hB
`define JMP_NS 4'hC
`define JMP_O 4'hD
`define JMP_NO 4'hE
`define JMP_CRZ 4'hF

`define LOOP_NORMAL 2'b00
`define LOOP_E 2'b01
`define LOOP_NE 2'b10

`define STATE_FETCH 4'b0000
`define STATE_DECODE 4'b0001
`define STATE_EXECUTE 4'b0010
`define STATE_WRITE 4'b0011
// `define STATE_TEST 4'b0100
`define STATE_INIT 4'b1000