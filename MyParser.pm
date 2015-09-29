########################################################################################
#
#    This file was generated using Parse::Eyapp version 1.182.
#
# (c) Parse::Yapp Copyright 1998-2001 Francois Desarmenien.
# (c) Parse::Eyapp Copyright 2006-2008 Casiano Rodriguez-Leon. Universidad de La Laguna.
#        Don't edit this file, use source file 'MyParser.eyp' instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
########################################################################################
package MyParser;
use strict;

push @MyParser::ISA, 'Parse::Eyapp::Driver';




BEGIN {
  # This strange way to load the modules is to guarantee compatibility when
  # using several standalone and non-standalone Eyapp parsers

  require Parse::Eyapp::Driver unless Parse::Eyapp::Driver->can('YYParse');
  require Parse::Eyapp::Node unless Parse::Eyapp::Node->can('hnew'); 
}
  

sub unexpendedInput { defined($_) ? substr($_, (defined(pos $_) ? pos $_ : 0)) : '' }

#line 3 "MyParser.eyp"

use feature qw( switch );

my %ops = (
	MOV => [1, 0b00001000],
	ADD => [1, 0b00010000],
	ADC => [1, 0b00011000],
	SUB => [1, 0b00100000],
	SBB => [1, 0b00101000],
	MUL => [2, 0b11000000, 0b00],
	IMUL => [2, 0b11000000, 0b01],
	DIV => [2, 0b11000000, 0b10],
	IDIV => [2, 0b11000000, 0b11],
	AND => [1, 0b00110000],
	OR => [1, 0b00111000],
	XOR => [1, 0b01000000],
	NOT => [2, 0b11000001, 0b00],
	NEG => [2, 0b11000001, 0b01],
	INC => [2, 0b11000001, 0b10],
	DEC => [2, 0b11000001, 0b11],
	TEST => [1, 0b10000000],
	SAL => [1, 0b01001000],
	SHL => [1, 0b01001000],
	SAR => [1, 0b01010000],
	SHR => [1, 0b01011000],
	RCL => [1, 0b01100000],
	RCR => [1, 0b01101000],
	ROL => [1, 0b01110000],
	ROR => [1, 0b01111000],
	CMP => [1, 0b10001000],
	JMP => [2, 0b11000100, 0b00],
	JE => [2, 0b11000100, 0b01],
	JNE => [2, 0b11000100, 0b10],
	JA => [2, 0b11000100, 0b11],
	JAE => [2, 0b11000101, 0b00],
	JB => [2, 0b11000101, 0b01],
	JBE => [2, 0b11000101, 0b10],
	JG => [2, 0b11000101, 0b11],
	JGE => [2, 0b11000110, 0b00],
	JL => [2, 0b11000110, 0b01],
	JLE => [2, 0b11000110, 0b10],
	JS => [2, 0b11000110, 0b11],
	JNS => [2, 0b11000111, 0b00],
	JO => [2, 0b11000111, 0b01],
	JNO => [2, 0b11000111, 0b10],
	JCRZ => [2, 0b11000111, 0b11],
	LOOP => [2, 0b11001000, 0b00],
	LOOPE => [2, 0b11001000, 0b01],
	LOOPNE => [2, 0b11001000, 0b10],
	PUSH => [2, 0b11001100, 0b00],
	POP => [2, 0b11001100, 0b01],
	CALL => [2, 0b11001100, 0b10],
	RET => [3, 0b11111110, 0b00000000],
	SYS => [4, 0b11111111],
	DB => [100, 0],
	DW => [100, 1]
);
my %regs = (
	R0 => {id => 0b0011, no => 0},
	RH0 => {id => 0b0010, no => 0},
	RL0 => {id => 0b0001, no => 0},
	R1 => {id => 0b0111, no => 1},
	RH1 => {id => 0b0110, no => 1},
	RL1 => {id => 0b0101, no => 1},
	R2 => {id => 0b1011, no => 2},
	RH2 => {id => 0b1010, no => 2},
	RL2 => {id => 0b1001, no => 2},
	R3 => {id => 0b1111, no => 3},
	RH3 => {id => 0b1110, no => 3},
	RL3 => {id => 0b1101, no => 3},
	R4 => {id => 0b0000, no => 4},
	R5 => {id => 0b0100, no => 5},
	R6 => {id => 0b1000, no => 6},
	R7 => {id => 0b1100, no => 7},
);


# Default lexical analyzer
our $LEX = sub {
    my $self = shift;
    my $pos;

    for (${$self->input}) {
      

      m{\G(\s+)}gc and $self->tokenline($1 =~ tr{\n}{});

      m{\G(\:|\+|\,|\[|\])}gc and return ($1, $1);

      /\G(OP1)/gc and return ($1, $1);
      /\G(OP2)/gc and return ($1, $1);
      /\G(OP3)/gc and return ($1, $1);
      /\G(OP4)/gc and return ($1, $1);
      /\G(OP100)/gc and return ($1, $1);
      /\G(ID)/gc and return ($1, $1);
      /\G(NUM)/gc and return ($1, $1);
      /\G(BYTE)/gc and return ($1, $1);
      /\G(WORD)/gc and return ($1, $1);
      /\G(REG)/gc and return ($1, $1);
      /\G(STR0)/gc and return ($1, $1);
      /\G(STR1)/gc and return ($1, $1);
      /\G(DFIN)/gc and return ($1, $1);
      /\G(DDIS1)/gc and return ($1, $1);
      /\G(DDIS2)/gc and return ($1, $1);
      /\G(DDMPR)/gc and return ($1, $1);


      return ('', undef) if ($_ eq '') || (defined(pos($_)) && (pos($_) >= length($_)));
      /\G\s*(\S+)/;
      my $near = substr($1,0,10); 

      return($near, $near);

     # die( "Error inside the lexical analyzer near '". $near
     #     ."'. Line: ".$self->line()
     #     .". File: '".$self->YYFilename()."'. No match found.\n");
    }
  }
;


#line 153 .\MyParser.pm

my $warnmessage =<< "EOFWARN";
Warning!: Did you changed the \@MyParser::ISA variable inside the header section of the eyapp program?
EOFWARN

sub new {
  my($class)=shift;
  ref($class) and $class=ref($class);

  warn $warnmessage unless __PACKAGE__->isa('Parse::Eyapp::Driver'); 
  my($self)=$class->SUPER::new( 
    yyversion => '1.182',
    yyGRAMMAR  =>
[#[productionNameAndLabel => lhs, [ rhs], bypass]]
  [ '_SUPERSTART' => '$start', [ 'line', '$end' ], 0 ],
  [ 'line_1' => 'line', [ 'label', '@1-1', 'op' ], 0 ],
  [ '_CODE' => '@1-1', [  ], 0 ],
  [ 'label_3' => 'label', [  ], 0 ],
  [ 'label_4' => 'label', [ 'ID', ':' ], 0 ],
  [ 'label_5' => 'label', [ 'ID', ':', 'NUM' ], 0 ],
  [ 'label_6' => 'label', [ ':', 'NUM' ], 0 ],
  [ 'op_7' => 'op', [  ], 0 ],
  [ 'op_8' => 'op', [ 'OP1', 'reg', ',', 'reg' ], 0 ],
  [ 'op_9' => 'op', [ 'OP1', 'reg', ',', 'mem' ], 0 ],
  [ 'op_10' => 'op', [ 'OP1', 'reg', ',', 'imm' ], 0 ],
  [ 'op_11' => 'op', [ 'OP1', 'mem', ',', 'reg' ], 0 ],
  [ 'op_12' => 'op', [ 'OP1', 'mem', ',', 'imm' ], 0 ],
  [ 'op_13' => 'op', [ 'OP2', 'reg' ], 0 ],
  [ 'op_14' => 'op', [ 'OP2', 'mem' ], 0 ],
  [ 'op_15' => 'op', [ 'OP2', 'imm' ], 0 ],
  [ 'op_16' => 'op', [ 'OP3' ], 0 ],
  [ 'op_17' => 'op', [ 'OP4', '@17-1', 'sysarg' ], 0 ],
  [ '_CODE' => '@17-1', [  ], 0 ],
  [ 'op_19' => 'op', [ 'OP100', 'NUM' ], 0 ],
  [ 'op_20' => 'op', [ 'OP100', 'STR0' ], 0 ],
  [ 'op_21' => 'op', [ 'OP100', 'STR1' ], 0 ],
  [ 'reg_22' => 'reg', [ 'REG' ], 0 ],
  [ 'sysarg_23' => 'sysarg', [ 'DFIN' ], 0 ],
  [ 'sysarg_24' => 'sysarg', [ 'sysddisop', '@24-1', ',', 'ID', ',', 'mem' ], 0 ],
  [ '_CODE' => '@24-1', [  ], 0 ],
  [ 'sysarg_26' => 'sysarg', [ 'DDMPR' ], 0 ],
  [ 'sysddisop_27' => 'sysddisop', [ 'DDIS1' ], 0 ],
  [ 'sysddisop_28' => 'sysddisop', [ 'DDIS2' ], 0 ],
  [ 'mem_29' => 'mem', [ 'size', '[', 'NUM', ']' ], 0 ],
  [ 'mem_30' => 'mem', [ 'size', '[', 'ID', ']' ], 0 ],
  [ 'mem_31' => 'mem', [ 'size', '[', 'REG', ']' ], 0 ],
  [ 'mem_32' => 'mem', [ 'size', '[', 'REG', '+', 'NUM', ']' ], 0 ],
  [ 'mem_33' => 'mem', [ 'size', '[', 'REG', '+', 'REG', '+', 'NUM', ']' ], 0 ],
  [ 'imm_34' => 'imm', [ 'size', 'NUM' ], 0 ],
  [ 'imm_35' => 'imm', [ 'size', 'ID' ], 0 ],
  [ 'size_36' => 'size', [  ], 0 ],
  [ 'size_37' => 'size', [ 'BYTE' ], 0 ],
  [ 'size_38' => 'size', [ 'WORD' ], 0 ],
],
    yyLABELS  =>
{
  '_SUPERSTART' => 0,
  'line_1' => 1,
  '_CODE' => 2,
  'label_3' => 3,
  'label_4' => 4,
  'label_5' => 5,
  'label_6' => 6,
  'op_7' => 7,
  'op_8' => 8,
  'op_9' => 9,
  'op_10' => 10,
  'op_11' => 11,
  'op_12' => 12,
  'op_13' => 13,
  'op_14' => 14,
  'op_15' => 15,
  'op_16' => 16,
  'op_17' => 17,
  '_CODE' => 18,
  'op_19' => 19,
  'op_20' => 20,
  'op_21' => 21,
  'reg_22' => 22,
  'sysarg_23' => 23,
  'sysarg_24' => 24,
  '_CODE' => 25,
  'sysarg_26' => 26,
  'sysddisop_27' => 27,
  'sysddisop_28' => 28,
  'mem_29' => 29,
  'mem_30' => 30,
  'mem_31' => 31,
  'mem_32' => 32,
  'mem_33' => 33,
  'imm_34' => 34,
  'imm_35' => 35,
  'size_36' => 36,
  'size_37' => 37,
  'size_38' => 38,
},
    yyTERMS  =>
{ '' => { ISSEMANTIC => 0 },
	'+' => { ISSEMANTIC => 0 },
	',' => { ISSEMANTIC => 0 },
	':' => { ISSEMANTIC => 0 },
	'[' => { ISSEMANTIC => 0 },
	']' => { ISSEMANTIC => 0 },
	BYTE => { ISSEMANTIC => 1 },
	DDIS1 => { ISSEMANTIC => 1 },
	DDIS2 => { ISSEMANTIC => 1 },
	DDMPR => { ISSEMANTIC => 1 },
	DFIN => { ISSEMANTIC => 1 },
	ID => { ISSEMANTIC => 1 },
	NUM => { ISSEMANTIC => 1 },
	OP1 => { ISSEMANTIC => 1 },
	OP100 => { ISSEMANTIC => 1 },
	OP2 => { ISSEMANTIC => 1 },
	OP3 => { ISSEMANTIC => 1 },
	OP4 => { ISSEMANTIC => 1 },
	REG => { ISSEMANTIC => 1 },
	STR0 => { ISSEMANTIC => 1 },
	STR1 => { ISSEMANTIC => 1 },
	WORD => { ISSEMANTIC => 1 },
	error => { ISSEMANTIC => 0 },
},
    yyFILENAME  => 'MyParser.eyp',
    yystates =>
[
	{#State 0
		ACTIONS => {
			'ID' => 2,
			":" => 1
		},
		DEFAULT => -3,
		GOTOS => {
			'label' => 3,
			'line' => 4
		}
	},
	{#State 1
		ACTIONS => {
			'NUM' => 5
		}
	},
	{#State 2
		ACTIONS => {
			":" => 6
		}
	},
	{#State 3
		DEFAULT => -2,
		GOTOS => {
			'@1-1' => 7
		}
	},
	{#State 4
		ACTIONS => {
			'' => 8
		}
	},
	{#State 5
		DEFAULT => -6
	},
	{#State 6
		ACTIONS => {
			'NUM' => 9
		},
		DEFAULT => -4
	},
	{#State 7
		ACTIONS => {
			'OP2' => 10,
			'OP1' => 12,
			'OP4' => 11,
			'OP3' => 13,
			'OP100' => 14
		},
		DEFAULT => -7,
		GOTOS => {
			'op' => 15
		}
	},
	{#State 8
		DEFAULT => 0
	},
	{#State 9
		DEFAULT => -5
	},
	{#State 10
		ACTIONS => {
			'WORD' => 16,
			'BYTE' => 18,
			'REG' => 22
		},
		DEFAULT => -36,
		GOTOS => {
			'imm' => 17,
			'reg' => 19,
			'mem' => 20,
			'size' => 21
		}
	},
	{#State 11
		DEFAULT => -18,
		GOTOS => {
			'@17-1' => 23
		}
	},
	{#State 12
		ACTIONS => {
			'WORD' => 16,
			'BYTE' => 18,
			'REG' => 22
		},
		DEFAULT => -36,
		GOTOS => {
			'reg' => 24,
			'mem' => 25,
			'size' => 26
		}
	},
	{#State 13
		DEFAULT => -16
	},
	{#State 14
		ACTIONS => {
			'NUM' => 28,
			'STR1' => 27,
			'STR0' => 29
		}
	},
	{#State 15
		DEFAULT => -1
	},
	{#State 16
		DEFAULT => -38
	},
	{#State 17
		DEFAULT => -15
	},
	{#State 18
		DEFAULT => -37
	},
	{#State 19
		DEFAULT => -13
	},
	{#State 20
		DEFAULT => -14
	},
	{#State 21
		ACTIONS => {
			'NUM' => 31,
			'ID' => 30,
			"[" => 32
		}
	},
	{#State 22
		DEFAULT => -22
	},
	{#State 23
		ACTIONS => {
			'DDIS1' => 33,
			'DFIN' => 35,
			'DDMPR' => 36,
			'DDIS2' => 38
		},
		GOTOS => {
			'sysddisop' => 34,
			'sysarg' => 37
		}
	},
	{#State 24
		ACTIONS => {
			"," => 39
		}
	},
	{#State 25
		ACTIONS => {
			"," => 40
		}
	},
	{#State 26
		ACTIONS => {
			"[" => 32
		}
	},
	{#State 27
		DEFAULT => -21
	},
	{#State 28
		DEFAULT => -19
	},
	{#State 29
		DEFAULT => -20
	},
	{#State 30
		DEFAULT => -35
	},
	{#State 31
		DEFAULT => -34
	},
	{#State 32
		ACTIONS => {
			'NUM' => 42,
			'ID' => 41,
			'REG' => 43
		}
	},
	{#State 33
		DEFAULT => -27
	},
	{#State 34
		DEFAULT => -25,
		GOTOS => {
			'@24-1' => 44
		}
	},
	{#State 35
		DEFAULT => -23
	},
	{#State 36
		DEFAULT => -26
	},
	{#State 37
		DEFAULT => -17
	},
	{#State 38
		DEFAULT => -28
	},
	{#State 39
		ACTIONS => {
			'WORD' => 16,
			'BYTE' => 18,
			'REG' => 22
		},
		DEFAULT => -36,
		GOTOS => {
			'imm' => 45,
			'reg' => 46,
			'mem' => 47,
			'size' => 21
		}
	},
	{#State 40
		ACTIONS => {
			'WORD' => 16,
			'BYTE' => 18,
			'REG' => 22
		},
		DEFAULT => -36,
		GOTOS => {
			'imm' => 48,
			'reg' => 49,
			'size' => 50
		}
	},
	{#State 41
		ACTIONS => {
			"]" => 51
		}
	},
	{#State 42
		ACTIONS => {
			"]" => 52
		}
	},
	{#State 43
		ACTIONS => {
			"+" => 53,
			"]" => 54
		}
	},
	{#State 44
		ACTIONS => {
			"," => 55
		}
	},
	{#State 45
		DEFAULT => -10
	},
	{#State 46
		DEFAULT => -8
	},
	{#State 47
		DEFAULT => -9
	},
	{#State 48
		DEFAULT => -12
	},
	{#State 49
		DEFAULT => -11
	},
	{#State 50
		ACTIONS => {
			'NUM' => 31,
			'ID' => 30
		}
	},
	{#State 51
		DEFAULT => -30
	},
	{#State 52
		DEFAULT => -29
	},
	{#State 53
		ACTIONS => {
			'NUM' => 56,
			'REG' => 57
		}
	},
	{#State 54
		DEFAULT => -31
	},
	{#State 55
		ACTIONS => {
			'ID' => 58
		}
	},
	{#State 56
		ACTIONS => {
			"]" => 59
		}
	},
	{#State 57
		ACTIONS => {
			"+" => 60
		}
	},
	{#State 58
		ACTIONS => {
			"," => 61
		}
	},
	{#State 59
		DEFAULT => -32
	},
	{#State 60
		ACTIONS => {
			'NUM' => 62
		}
	},
	{#State 61
		ACTIONS => {
			'WORD' => 16,
			'BYTE' => 18
		},
		DEFAULT => -36,
		GOTOS => {
			'mem' => 63,
			'size' => 26
		}
	},
	{#State 62
		ACTIONS => {
			"]" => 64
		}
	},
	{#State 63
		DEFAULT => -24
	},
	{#State 64
		DEFAULT => -33
	}
],
    yyrules  =>
[
	[#Rule _SUPERSTART
		 '$start', 2, undef
#line 618 .\MyParser.pm
	],
	[#Rule line_1
		 'line', 3,
sub {
#line 108 "MyParser.eyp"
my $label = $_[1]; my $op = $_[3]; 
			if (defined $op) {
				addOp($_[0], $op);
			}
			{label => $label, op => $op};
		}
#line 630 .\MyParser.pm
	],
	[#Rule _CODE
		 '@1-1', 0,
sub {
#line 101 "MyParser.eyp"
my $label = $_[1]; 
			init($_[0]);
			if (defined $label) {
				addLabel($_[0], $label->{name}, $label->{addr});
			}
		}
#line 642 .\MyParser.pm
	],
	[#Rule label_3
		 'label', 0,
sub {
#line 116 "MyParser.eyp"
 undef; }
#line 649 .\MyParser.pm
	],
	[#Rule label_4
		 'label', 2,
sub {
#line 117 "MyParser.eyp"
my $ID = $_[1];  {name => $ID, addr => undef}; }
#line 656 .\MyParser.pm
	],
	[#Rule label_5
		 'label', 3,
sub {
#line 118 "MyParser.eyp"
my $NUM = $_[3]; my $ID = $_[1];  {name => $ID, addr => $NUM}; }
#line 663 .\MyParser.pm
	],
	[#Rule label_6
		 'label', 2,
sub {
#line 119 "MyParser.eyp"
my $NUM = $_[2];  {name => undef, addr => $NUM}; }
#line 670 .\MyParser.pm
	],
	[#Rule op_7
		 'op', 0,
sub {
#line 122 "MyParser.eyp"
 undef; }
#line 677 .\MyParser.pm
	],
	[#Rule op_8
		 'op', 4,
sub {
#line 123 "MyParser.eyp"
my $arg2 = $_[4]; my $arg1 = $_[2];  [$_[1]->[1] | 0b000, $arg1->{id} << 4 | $arg2->{id}];  }
#line 684 .\MyParser.pm
	],
	[#Rule op_9
		 'op', 4,
sub {
#line 124 "MyParser.eyp"
my $arg2 = $_[4]; my $arg1 = $_[2];  [$_[1]->[1] | 0b001, $arg1->{id} << 4 | $arg2->{type}, $arg2->{num}]; }
#line 691 .\MyParser.pm
	],
	[#Rule op_10
		 'op', 4,
sub {
#line 125 "MyParser.eyp"
my $arg2 = $_[4]; my $arg1 = $_[2];  [$_[1]->[1] | 0b010, $arg1->{id} << 4 | $arg2->{type}, $arg2->{num}]; }
#line 698 .\MyParser.pm
	],
	[#Rule op_11
		 'op', 4,
sub {
#line 126 "MyParser.eyp"
my $arg2 = $_[4]; my $arg1 = $_[2];  [$_[1]->[1] | 0b011, $arg1->{type} << 4 | $arg2->{id}, $arg1->{num}]; }
#line 705 .\MyParser.pm
	],
	[#Rule op_12
		 'op', 4,
sub {
#line 127 "MyParser.eyp"
my $arg2 = $_[4]; my $arg1 = $_[2];  [$_[1]->[1] | 0b100, $arg1->{type} << 4 | getSize($arg1->{size}, $arg2->{size}), $arg1->{num}, $arg2->{num}]; }
#line 712 .\MyParser.pm
	],
	[#Rule op_13
		 'op', 2,
sub {
#line 128 "MyParser.eyp"
my $arg1 = $_[2];  [$_[1]->[1], $_[1]->[2] << 6 | 0b000000 | $arg1->{id}];  }
#line 719 .\MyParser.pm
	],
	[#Rule op_14
		 'op', 2,
sub {
#line 129 "MyParser.eyp"
my $arg1 = $_[2];  [$_[1]->[1], $_[1]->[2] << 6 | 0b010000 | getSize($arg1->{size}) << 5 | $arg1->{type}, $arg1->{num}];  }
#line 726 .\MyParser.pm
	],
	[#Rule op_15
		 'op', 2,
sub {
#line 130 "MyParser.eyp"
my $arg1 = $_[2];  [$_[1]->[1], $_[1]->[2] << 6 | 0b100000 | getSize($arg1->{size}), $arg1->{num}];  }
#line 733 .\MyParser.pm
	],
	[#Rule op_16
		 'op', 1,
sub {
#line 131 "MyParser.eyp"
 [$_[1]->[1], $_[1]->[2]];  }
#line 740 .\MyParser.pm
	],
	[#Rule op_17
		 'op', 3,
sub {
#line 132 "MyParser.eyp"
my $opd = $_[3];  $_[0]->YYLexer(\&MyLexer); [$_[1]->[1], @$opd]; }
#line 747 .\MyParser.pm
	],
	[#Rule _CODE
		 '@17-1', 0,
sub {
#line 132 "MyParser.eyp"
 $_[0]->YYLexer(\&SysArg1Lexer); }
#line 754 .\MyParser.pm
	],
	[#Rule op_19
		 'op', 2,
sub {
#line 133 "MyParser.eyp"
my $NUM = $_[2];  [($_[1]->[1]) ? @{getWordArray($NUM)} : ${getWordArray($NUM)}[1]]; }
#line 761 .\MyParser.pm
	],
	[#Rule op_20
		 'op', 2,
sub {
#line 134 "MyParser.eyp"
my $STR0 = $_[2];  [unpack('C*', $STR0), 0]; }
#line 768 .\MyParser.pm
	],
	[#Rule op_21
		 'op', 2,
sub {
#line 135 "MyParser.eyp"
my $STR1 = $_[2];  [unpack('C*', $STR1)]; }
#line 775 .\MyParser.pm
	],
	[#Rule reg_22
		 'reg', 1,
sub {
#line 138 "MyParser.eyp"
 $_[1]; }
#line 782 .\MyParser.pm
	],
	[#Rule sysarg_23
		 'sysarg', 1,
sub {
#line 142 "MyParser.eyp"
my $DFIN = $_[1]; 
				$_[0]->YYLexer(\&MyLexer);
				[$DFIN];
			}
#line 792 .\MyParser.pm
	],
	[#Rule sysarg_24
		 'sysarg', 6,
sub {
#line 147 "MyParser.eyp"
my $arg = $_[6]; my $type = $_[4]; my $op = $_[1]; 
				given (uc $type) {
					when('C') { return [$op | 0b0000, $arg->{num}]; }
					when('B') { return [$op | 0b0001, $arg->{num}]; }
					when('O') { return [$op | 0b0010, $arg->{num}]; }
					when('D') { return [$op | 0b0011, $arg->{num}]; }
					when('H') { return [$op | 0b0100, $arg->{num}]; }
					when('U') { return [$op | 0b0111, $arg->{num}]; }
					default { die "unknown dis type: %type"; }
				}
			}
#line 809 .\MyParser.pm
	],
	[#Rule _CODE
		 '@24-1', 0,
sub {
#line 146 "MyParser.eyp"
my $op = $_[1]; $_[0]->YYLexer(\&MyLexer);}
#line 816 .\MyParser.pm
	],
	[#Rule sysarg_26
		 'sysarg', 1,
sub {
#line 159 "MyParser.eyp"
my $DDMPR = $_[1]; 
				$_[0]->YYLexer(\&MyLexer);
				[$DDMPR];
			}
#line 826 .\MyParser.pm
	],
	[#Rule sysddisop_27
		 'sysddisop', 1, undef
#line 830 .\MyParser.pm
	],
	[#Rule sysddisop_28
		 'sysddisop', 1, undef
#line 834 .\MyParser.pm
	],
	[#Rule mem_29
		 'mem', 4,
sub {
#line 169 "MyParser.eyp"
my $NUM = $_[3];  {size => $_[1], num => getWordArray($NUM), type => 15}; }
#line 841 .\MyParser.pm
	],
	[#Rule mem_30
		 'mem', 4,
sub {
#line 171 "MyParser.eyp"
my $ID = $_[3]; 
				my $ref = [undef, undef];
				addUnsolvedLabel($_[0], $ID, $ref);
				{size => $_[1], num => $ref, type => 15};
			}
#line 852 .\MyParser.pm
	],
	[#Rule mem_31
		 'mem', 4,
sub {
#line 177 "MyParser.eyp"
my $REG = $_[3]; 
				my $type = $REG->{no};
				defined $type or die "Unsupported reg";
				{size => $_[1], num => getWordArray(0), type => $type};
			}
#line 863 .\MyParser.pm
	],
	[#Rule mem_32
		 'mem', 6,
sub {
#line 183 "MyParser.eyp"
my $NUM = $_[5]; my $REG = $_[3]; 
				my $type = $REG->{no};
				defined $type or die "Unsupported reg";
				{size => $_[1], num => getWordArray($NUM), type => $type};
			}
#line 874 .\MyParser.pm
	],
	[#Rule mem_33
		 'mem', 8,
sub {
#line 189 "MyParser.eyp"
my $NUM = $_[7]; my $reg1 = $_[3]; my $reg2 = $_[5]; 
				my $type1 = $reg1->{no};
				my $type2 = $reg2->{no};
				my $type;
				defined $type1 || defined $type2 or die "Unsupported reg";
				($type1, $type2) = ($type2, $type1) if ($type1 > $type2);
				given ($type1) {
					when(3) {
						given ($type2) {
							when(6) { $type = 8; }
							when(7) { $type = 9; }
						}
					}
					when(4) {
						given ($type2) {
							when(6) { $type = 10; }
							when(7) { $type = 11; }
						}
					}
					when(5) {
						given ($type2) {
							when(6) { $type = 12; }
							when(7) { $type = 13; }
						}
					}
				}
				{size => $_[1], num => getWordArray($NUM), type => $type};
			}
#line 908 .\MyParser.pm
	],
	[#Rule imm_34
		 'imm', 2,
sub {
#line 219 "MyParser.eyp"
my $NUM = $_[2];  {size => $_[1], num => getWordArray($NUM)}; }
#line 915 .\MyParser.pm
	],
	[#Rule imm_35
		 'imm', 2,
sub {
#line 221 "MyParser.eyp"
my $ID = $_[2]; 
				my $ref = [undef, undef];
				addUnsolvedLabel($_[0], $ID, $ref);
				{size => $_[1], num => $ref};
			}
#line 926 .\MyParser.pm
	],
	[#Rule size_36
		 'size', 0,
sub {
#line 228 "MyParser.eyp"
 undef; }
#line 933 .\MyParser.pm
	],
	[#Rule size_37
		 'size', 1,
sub {
#line 229 "MyParser.eyp"
 0; }
#line 940 .\MyParser.pm
	],
	[#Rule size_38
		 'size', 1,
sub {
#line 230 "MyParser.eyp"
 1; }
#line 947 .\MyParser.pm
	]
],
#line 950 .\MyParser.pm
    yybypass       => 0,
    yybuildingtree => 0,
    yyprefix       => '',
    yyaccessors    => {
   },
    yyconflicthandlers => {}
,
    yystateconflict => {  },
    @_,
  );
  bless($self,$class);

  $self->make_node_classes('TERMINAL', '_OPTIONAL', '_STAR_LIST', '_PLUS_LIST', 
         '_SUPERSTART', 
         'line_1', 
         '_CODE', 
         'label_3', 
         'label_4', 
         'label_5', 
         'label_6', 
         'op_7', 
         'op_8', 
         'op_9', 
         'op_10', 
         'op_11', 
         'op_12', 
         'op_13', 
         'op_14', 
         'op_15', 
         'op_16', 
         'op_17', 
         '_CODE', 
         'op_19', 
         'op_20', 
         'op_21', 
         'reg_22', 
         'sysarg_23', 
         'sysarg_24', 
         '_CODE', 
         'sysarg_26', 
         'sysddisop_27', 
         'sysddisop_28', 
         'mem_29', 
         'mem_30', 
         'mem_31', 
         'mem_32', 
         'mem_33', 
         'imm_34', 
         'imm_35', 
         'size_36', 
         'size_37', 
         'size_38', );
  $self;
}

#line 233 "MyParser.eyp"


sub getSize {
	if (defined $_[0] && defined $_[1] && $_[0] != $_[1]) {
		die "unmatched size $_[0] and $_[1]";
	}
	return $_[0] // $_[1] // 1;
}

sub getWordArray {
	return [$_[0] >> 8 & 0xFF, $_[0] & 0xFF];
}

sub MyLexer {
	my ($p) = shift;
	
	for ($p->YYData->{INPUT}) {
		m/\G\s+/gc;
		m/\G;.*/gc;
		$_ eq '' and return ('', undef);
		m/\G(0b[01]+)/igc and return ('NUM', oct $1);
		m/\G(0o?[0-7]+)/igc and return ('NUM', oct $1);
		m/\G(0x[0-9A-F]+)/igc and return ('NUM', oct $1);
		m/\G([\+\-]?[0-9]+)/gc and return ('NUM', $1);
		if (m/\G(\w+)/gc) {
			my $key = uc $1;
			exists $regs{$key} and return ('REG', $regs{$key});
			exists $ops{$key} and return ('OP' . $ops{$1}->[0], $ops{$1});
			$key eq 'BYTE' and return ('BYTE', undef);
			$key eq 'WORD' and return ('WORD', undef);
			return ('ID', $1);
		}
		m/\G\"((?:[^\\\"]|\\.)*)\"/igc and return ('STR0', unescape($1));
		m/\G\'((?:[^\\\']|\\.)*)\'/igc and return ('STR1', unescape($1));
		m/\G(.)/gcs and return ($1, $1)
	}
	return ('', undef);
}

sub SysArg1Lexer {
	my ($p) = shift;
	
	for ($p->YYData->{INPUT}) {
		m/\G\s+/gc;
		$_ eq '' and return ('', undef);
		m/\GDFIN/igc and return ('DFIN', 0b00000000);
		m/\GDDIS1/igc and return ('DDIS1', 0b00010000);
		m/\GDDIS2/igc and return ('DDIS2', 0b00110000);
		m/\GDDMPR/igc and return ('DDMPR', 0b01000000);
		m/\G(.)/gcs and return ($1, $1)
	}
	return ('', undef);
}

sub init {
	exists $_[0]->YYData->{CmdPc} or $_[0]->YYData->{CmdPc} = 0;
	exists $_[0]->YYData->{Cmd} or $_[0]->YYData->{Cmd} = [];
	exists $_[0]->YYData->{Labels} or $_[0]->YYData->{Labels} = {};
	exists $_[0]->YYData->{UnsolvedLabels} or $_[0]->YYData->{UnsolvedLabels} = {};
}

sub addOp {
	my $parser = shift;
	my $op = shift;
	foreach my $bin (@$op) {
		if (ref $bin) {
			$parser->YYData->{CmdPc} += scalar @$bin;
		} else {
			$parser->YYData->{CmdPc} += 1;
		}
	}
	push @{$parser->YYData->{Cmd}}, $op;
}

sub addLabel {
	my $parser = shift;
	my $name = shift;
	my $addr = shift;
	
	if (defined $addr) {
		my $count = $addr - $parser->YYData->{CmdPc};
		if ($count > 0) {
			$parser->YYData->{CmdPc} = $addr;
			push @{$parser->YYData->{Cmd}}, [(undef) x $count];
		} else {
			print "Label addr is ignored: pc = ", $parser->YYData->{CmdPc}, " addr=$addr\n";
		}
	}
	
	if (defined $name) {
		if (exists $parser->YYData->{Labels}->{$name}) {
			print "Label '$name' is already exists, ignored.\n";
		} else {
			$parser->YYData->{Labels}->{$name} = $parser->YYData->{CmdPc};
		}
	}
}


sub addUnsolvedLabel {
	my $parser = shift;
	my $name = shift;
	my $ref = shift;
	my $ulabels = $parser->YYData->{UnsolvedLabels};
	exists $ulabels->{$name} or $ulabels->{$name} = [];
	push @{$ulabels->{$name}}, $ref;
}

sub solveLabels {
	my $parser = shift;
	while ((my $name, my $refs) = each %{$parser->YYData->{UnsolvedLabels}}) {
		exists $parser->YYData->{Labels}->{$name} or die "Label not found: name=$name";
		my $pc = $parser->YYData->{Labels}->{$name};
		foreach my $ref (@$refs) {
			my $addr = getWordArray($pc);
			@$ref[0,1] = @$addr;
		}
	}
}

sub unescape {
	my $str = shift;
	$str =~ s/\\n/\n/g;
	$str =~ s/\\r/\r/g;
	$str =~ s/\\t/\t/g;
	$str =~ s/\\(.)/$1/g;
	return $str;
}

__PACKAGE__->lexer(\&MyLexer);

1;

=for None

=cut


#line 1145 .\MyParser.pm



1;
