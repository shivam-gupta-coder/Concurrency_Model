
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a6010113          	addi	sp,sp,-1440 # 80008a60 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000003a:	6318                	ld	a4,0(a4)
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	8d070713          	addi	a4,a4,-1840 # 80008920 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	43e78793          	addi	a5,a5,1086 # 800064a0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbc657>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	f7678793          	addi	a5,a5,-138 # 80001022 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000010a:	04c05663          	blez	a2,80000156 <consolewrite+0x56>
    8000010e:	fc26                	sd	s1,56(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00002097          	auipc	ra,0x2
    8000012e:	754080e7          	jalr	1876(ra) # 8000287e <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7e4080e7          	jalr	2020(ra) # 8000091e <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    8000014c:	74e2                	ld	s1,56(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	a039                	j	80000162 <consolewrite+0x62>
    80000156:	4901                	li	s2,0
    80000158:	a029                	j	80000162 <consolewrite+0x62>
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	79a2                	ld	s3,40(sp)
    8000015e:	7a02                	ld	s4,32(sp)
    80000160:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80000162:	854a                	mv	a0,s2
    80000164:	60a6                	ld	ra,72(sp)
    80000166:	6406                	ld	s0,64(sp)
    80000168:	7942                	ld	s2,48(sp)
    8000016a:	6161                	addi	sp,sp,80
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018c:	00011517          	auipc	a0,0x11
    80000190:	8d450513          	addi	a0,a0,-1836 # 80010a60 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	bf4080e7          	jalr	-1036(ra) # 80000d88 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019c:	00011497          	auipc	s1,0x11
    800001a0:	8c448493          	addi	s1,s1,-1852 # 80010a60 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a4:	00011917          	auipc	s2,0x11
    800001a8:	95490913          	addi	s2,s2,-1708 # 80010af8 <cons+0x98>
  while(n > 0){
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
    while(cons.r == cons.w){
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
      if(killed(myproc())){
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	b80080e7          	jalr	-1152(ra) # 80001d3c <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	504080e7          	jalr	1284(ra) # 800026c8 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	242080e7          	jalr	578(ra) # 80002414 <sleep>
    while(cons.r == cons.w){
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00011717          	auipc	a4,0x11
    800001ec:	87870713          	addi	a4,a4,-1928 # 80010a60 <cons>
    800001f0:	0017869b          	addiw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	andi	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000206:	4691                	li	a3,4
    80000208:	04db8a63          	beq	s7,a3,8000025c <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	addi	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	60e080e7          	jalr	1550(ra) # 80002828 <either_copyout>
    80000222:	57fd                	li	a5,-1
    80000224:	04f50a63          	beq	a0,a5,80000278 <consoleread+0x10a>
      break;

    dst++;
    80000228:	0a05                	addi	s4,s4,1
    --n;
    8000022a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000022c:	47a9                	li	a5,10
    8000022e:	06fb8163          	beq	s7,a5,80000290 <consoleread+0x122>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	bfa5                	j	800001ac <consoleread+0x3e>
        release(&cons.lock);
    80000236:	00011517          	auipc	a0,0x11
    8000023a:	82a50513          	addi	a0,a0,-2006 # 80010a60 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	bfe080e7          	jalr	-1026(ra) # 80000e3c <release>
        return -1;
    80000246:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000248:	60e6                	ld	ra,88(sp)
    8000024a:	6446                	ld	s0,80(sp)
    8000024c:	64a6                	ld	s1,72(sp)
    8000024e:	6906                	ld	s2,64(sp)
    80000250:	79e2                	ld	s3,56(sp)
    80000252:	7a42                	ld	s4,48(sp)
    80000254:	7aa2                	ld	s5,40(sp)
    80000256:	7b02                	ld	s6,32(sp)
    80000258:	6125                	addi	sp,sp,96
    8000025a:	8082                	ret
      if(n < target){
    8000025c:	0009871b          	sext.w	a4,s3
    80000260:	01677a63          	bgeu	a4,s6,80000274 <consoleread+0x106>
        cons.r--;
    80000264:	00011717          	auipc	a4,0x11
    80000268:	88f72a23          	sw	a5,-1900(a4) # 80010af8 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000027a:	00010517          	auipc	a0,0x10
    8000027e:	7e650513          	addi	a0,a0,2022 # 80010a60 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	bba080e7          	jalr	-1094(ra) # 80000e3c <release>
  return target - n;
    8000028a:	413b053b          	subw	a0,s6,s3
    8000028e:	bf6d                	j	80000248 <consoleread+0xda>
    80000290:	6be2                	ld	s7,24(sp)
    80000292:	b7e5                	j	8000027a <consoleread+0x10c>

0000000080000294 <consputc>:
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e406                	sd	ra,8(sp)
    80000298:	e022                	sd	s0,0(sp)
    8000029a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000029c:	10000793          	li	a5,256
    800002a0:	00f50a63          	beq	a0,a5,800002b4 <consputc+0x20>
    uartputc_sync(c);
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	59c080e7          	jalr	1436(ra) # 80000840 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	58a080e7          	jalr	1418(ra) # 80000840 <uartputc_sync>
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	574080e7          	jalr	1396(ra) # 80000840 <uartputc_sync>
    800002d4:	bfe1                	j	800002ac <consputc+0x18>

00000000800002d6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002d6:	1101                	addi	sp,sp,-32
    800002d8:	ec06                	sd	ra,24(sp)
    800002da:	e822                	sd	s0,16(sp)
    800002dc:	e426                	sd	s1,8(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e2:	00010517          	auipc	a0,0x10
    800002e6:	77e50513          	addi	a0,a0,1918 # 80010a60 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	a9e080e7          	jalr	-1378(ra) # 80000d88 <acquire>

  switch(c){
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48563          	beq	s1,a5,8000039e <consoleintr+0xc8>
    800002f8:	0297c963          	blt	a5,s1,8000032a <consoleintr+0x54>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48c63          	beq	s1,a5,800003f6 <consoleintr+0x120>
    80000302:	47c1                	li	a5,16
    80000304:	10f49f63          	bne	s1,a5,80000422 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80000308:	00002097          	auipc	ra,0x2
    8000030c:	5cc080e7          	jalr	1484(ra) # 800028d4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000310:	00010517          	auipc	a0,0x10
    80000314:	75050513          	addi	a0,a0,1872 # 80010a60 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	b24080e7          	jalr	-1244(ra) # 80000e3c <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6105                	addi	sp,sp,32
    80000328:	8082                	ret
  switch(c){
    8000032a:	07f00793          	li	a5,127
    8000032e:	0cf48463          	beq	s1,a5,800003f6 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000332:	00010717          	auipc	a4,0x10
    80000336:	72e70713          	addi	a4,a4,1838 # 80010a60 <cons>
    8000033a:	0a072783          	lw	a5,160(a4)
    8000033e:	09872703          	lw	a4,152(a4)
    80000342:	9f99                	subw	a5,a5,a4
    80000344:	07f00713          	li	a4,127
    80000348:	fcf764e3          	bltu	a4,a5,80000310 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    8000034c:	47b5                	li	a5,13
    8000034e:	0cf48d63          	beq	s1,a5,80000428 <consoleintr+0x152>
      consputc(c);
    80000352:	8526                	mv	a0,s1
    80000354:	00000097          	auipc	ra,0x0
    80000358:	f40080e7          	jalr	-192(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000035c:	00010797          	auipc	a5,0x10
    80000360:	70478793          	addi	a5,a5,1796 # 80010a60 <cons>
    80000364:	0a07a683          	lw	a3,160(a5)
    80000368:	0016871b          	addiw	a4,a3,1
    8000036c:	0007061b          	sext.w	a2,a4
    80000370:	0ae7a023          	sw	a4,160(a5)
    80000374:	07f6f693          	andi	a3,a3,127
    80000378:	97b6                	add	a5,a5,a3
    8000037a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000037e:	47a9                	li	a5,10
    80000380:	0cf48b63          	beq	s1,a5,80000456 <consoleintr+0x180>
    80000384:	4791                	li	a5,4
    80000386:	0cf48863          	beq	s1,a5,80000456 <consoleintr+0x180>
    8000038a:	00010797          	auipc	a5,0x10
    8000038e:	76e7a783          	lw	a5,1902(a5) # 80010af8 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800003a0:	00010717          	auipc	a4,0x10
    800003a4:	6c070713          	addi	a4,a4,1728 # 80010a60 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b0:	00010497          	auipc	s1,0x10
    800003b4:	6b048493          	addi	s1,s1,1712 # 80010a60 <cons>
    while(cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	02f70a63          	beq	a4,a5,800003ee <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c6:	01874703          	lbu	a4,24(a4)
    800003ca:	03270463          	beq	a4,s2,800003f2 <consoleintr+0x11c>
      cons.e--;
    800003ce:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	ebe080e7          	jalr	-322(ra) # 80000294 <consputc>
    while(cons.e != cons.w &&
    800003de:	0a04a783          	lw	a5,160(s1)
    800003e2:	09c4a703          	lw	a4,156(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xe8>
    800003ea:	6902                	ld	s2,0(sp)
    800003ec:	b715                	j	80000310 <consoleintr+0x3a>
    800003ee:	6902                	ld	s2,0(sp)
    800003f0:	b705                	j	80000310 <consoleintr+0x3a>
    800003f2:	6902                	ld	s2,0(sp)
    800003f4:	bf31                	j	80000310 <consoleintr+0x3a>
    if(cons.e != cons.w){
    800003f6:	00010717          	auipc	a4,0x10
    800003fa:	66a70713          	addi	a4,a4,1642 # 80010a60 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
      cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00010717          	auipc	a4,0x10
    80000410:	6ef72a23          	sw	a5,1780(a4) # 80010b00 <cons+0xa0>
      consputc(BACKSPACE);
    80000414:	10000513          	li	a0,256
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	e7c080e7          	jalr	-388(ra) # 80000294 <consputc>
    80000420:	bdc5                	j	80000310 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000422:	ee0487e3          	beqz	s1,80000310 <consoleintr+0x3a>
    80000426:	b731                	j	80000332 <consoleintr+0x5c>
      consputc(c);
    80000428:	4529                	li	a0,10
    8000042a:	00000097          	auipc	ra,0x0
    8000042e:	e6a080e7          	jalr	-406(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000432:	00010797          	auipc	a5,0x10
    80000436:	62e78793          	addi	a5,a5,1582 # 80010a60 <cons>
    8000043a:	0a07a703          	lw	a4,160(a5)
    8000043e:	0017069b          	addiw	a3,a4,1
    80000442:	0006861b          	sext.w	a2,a3
    80000446:	0ad7a023          	sw	a3,160(a5)
    8000044a:	07f77713          	andi	a4,a4,127
    8000044e:	97ba                	add	a5,a5,a4
    80000450:	4729                	li	a4,10
    80000452:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000456:	00010797          	auipc	a5,0x10
    8000045a:	6ac7a323          	sw	a2,1702(a5) # 80010afc <cons+0x9c>
        wakeup(&cons.r);
    8000045e:	00010517          	auipc	a0,0x10
    80000462:	69a50513          	addi	a0,a0,1690 # 80010af8 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	012080e7          	jalr	18(ra) # 80002478 <wakeup>
    8000046e:	b54d                	j	80000310 <consoleintr+0x3a>

0000000080000470 <consoleinit>:

void
consoleinit(void)
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e406                	sd	ra,8(sp)
    80000474:	e022                	sd	s0,0(sp)
    80000476:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000478:	00008597          	auipc	a1,0x8
    8000047c:	b8858593          	addi	a1,a1,-1144 # 80008000 <etext>
    80000480:	00010517          	auipc	a0,0x10
    80000484:	5e050513          	addi	a0,a0,1504 # 80010a60 <cons>
    80000488:	00001097          	auipc	ra,0x1
    8000048c:	870080e7          	jalr	-1936(ra) # 80000cf8 <initlock>

  uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	354080e7          	jalr	852(ra) # 800007e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000498:	00241797          	auipc	a5,0x241
    8000049c:	b7878793          	addi	a5,a5,-1160 # 80241010 <devsw>
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	cce70713          	addi	a4,a4,-818 # 8000016e <consoleread>
    800004a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004aa:	00000717          	auipc	a4,0x0
    800004ae:	c5670713          	addi	a4,a4,-938 # 80000100 <consolewrite>
    800004b2:	ef98                	sd	a4,24(a5)
}
    800004b4:	60a2                	ld	ra,8(sp)
    800004b6:	6402                	ld	s0,0(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret

00000000800004bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004bc:	7179                	addi	sp,sp,-48
    800004be:	f406                	sd	ra,40(sp)
    800004c0:	f022                	sd	s0,32(sp)
    800004c2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0xe>
    800004c6:	08054963          	bltz	a0,80000558 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00008617          	auipc	a2,0x8
    800004da:	2a260613          	addi	a2,a2,674 # 80008778 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

  if(sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
    buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000051a:	02e05b63          	blez	a4,80000550 <printint+0x94>
    8000051e:	ec26                	sd	s1,24(sp)
    80000520:	e84a                	sd	s2,16(sp)
    80000522:	fd040793          	addi	a5,s0,-48
    80000526:	00e784b3          	add	s1,a5,a4
    8000052a:	fff78913          	addi	s2,a5,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	377d                	addiw	a4,a4,-1
    80000532:	1702                	slli	a4,a4,0x20
    80000534:	9301                	srli	a4,a4,0x20
    80000536:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000053a:	fff4c503          	lbu	a0,-1(s1)
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	d56080e7          	jalr	-682(ra) # 80000294 <consputc>
  while(--i >= 0)
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	ff2499e3          	bne	s1,s2,8000053a <printint+0x7e>
    8000054c:	64e2                	ld	s1,24(sp)
    8000054e:	6942                	ld	s2,16(sp)
}
    80000550:	70a2                	ld	ra,40(sp)
    80000552:	7402                	ld	s0,32(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
    x = -xx;
    80000558:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
    x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00010797          	auipc	a5,0x10
    80000570:	5a07aa23          	sw	zero,1460(a5) # 80010b20 <pr+0x18>
  printf("panic: ");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	a9450513          	addi	a0,a0,-1388 # 80008008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	a8250513          	addi	a0,a0,-1406 # 80008010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	00008717          	auipc	a4,0x8
    800005a4:	34f72023          	sw	a5,832(a4) # 800088e0 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	f06a                	sd	s10,32(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00010d17          	auipc	s10,0x10
    800005ce:	556d2d03          	lw	s10,1366(s10) # 80010b20 <pr+0x18>
  if(locking)
    800005d2:	040d1463          	bnez	s10,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050b63          	beqz	a0,8000077c <printf+0x1d2>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	ec6e                	sd	s11,24(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000608:	00008a97          	auipc	s5,0x8
    8000060c:	170a8a93          	addi	s5,s5,368 # 80008778 <digits>
    switch(c){
    80000610:	07300c13          	li	s8,115
    80000614:	06400d93          	li	s11,100
    80000618:	a0b1                	j	80000664 <printf+0xba>
    acquire(&pr.lock);
    8000061a:	00010517          	auipc	a0,0x10
    8000061e:	4ee50513          	addi	a0,a0,1262 # 80010b08 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	766080e7          	jalr	1894(ra) # 80000d88 <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	9e250513          	addi	a0,a0,-1566 # 80008020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c46080e7          	jalr	-954(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	2985                	addiw	s3,s3,1
    80000658:	013a07b3          	add	a5,s4,s3
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c0>
    if(c != '%'){
    80000664:	ff6515e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c783          	lbu	a5,0(a5)
    80000672:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000676:	10078b63          	beqz	a5,8000078c <printf+0x1e2>
    switch(c){
    8000067a:	05778a63          	beq	a5,s7,800006ce <printf+0x124>
    8000067e:	02fbf663          	bgeu	s7,a5,800006aa <printf+0x100>
    80000682:	09878863          	beq	a5,s8,80000712 <printf+0x168>
    80000686:	07800713          	li	a4,120
    8000068a:	0ce79563          	bne	a5,a4,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85e6                	mv	a1,s9
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e1c080e7          	jalr	-484(ra) # 800004bc <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	09678f63          	beq	a5,s6,80000748 <printf+0x19e>
    800006ae:	0bb79363          	bne	a5,s11,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4605                	li	a2,1
    800006c0:	45a9                	li	a1,10
    800006c2:	4388                	lw	a0,0(a5)
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	df8080e7          	jalr	-520(ra) # 800004bc <printint>
      break;
    800006cc:	b769                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006de:	03000513          	li	a0,48
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	bb2080e7          	jalr	-1102(ra) # 80000294 <consputc>
  consputc('x');
    800006ea:	07800513          	li	a0,120
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	ba6080e7          	jalr	-1114(ra) # 80000294 <consputc>
    800006f6:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b92080e7          	jalr	-1134(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x14e>
    80000710:	b799                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x190>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d905                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b6c080e7          	jalr	-1172(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x17e>
    80000738:	bf39                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073a:	00008497          	auipc	s1,0x8
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x17e>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b4a080e7          	jalr	-1206(ra) # 80000294 <consputc>
      break;
    80000752:	b711                	j	80000656 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b3e080e7          	jalr	-1218(ra) # 80000294 <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b34080e7          	jalr	-1228(ra) # 80000294 <consputc>
      break;
    80000768:	b5fd                	j	80000656 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	6de2                	ld	s11,24(sp)
  if(locking)
    8000077c:	020d1263          	bnez	s10,800007a0 <printf+0x1f6>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	7d02                	ld	s10,32(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	6de2                	ld	s11,24(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d2>
    release(&pr.lock);
    800007a0:	00010517          	auipc	a0,0x10
    800007a4:	36850513          	addi	a0,a0,872 # 80010b08 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	694080e7          	jalr	1684(ra) # 80000e3c <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d6>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1101                	addi	sp,sp,-32
    800007b4:	ec06                	sd	ra,24(sp)
    800007b6:	e822                	sd	s0,16(sp)
    800007b8:	e426                	sd	s1,8(sp)
    800007ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007bc:	00010497          	auipc	s1,0x10
    800007c0:	34c48493          	addi	s1,s1,844 # 80010b08 <pr>
    800007c4:	00008597          	auipc	a1,0x8
    800007c8:	86c58593          	addi	a1,a1,-1940 # 80008030 <etext+0x30>
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	52a080e7          	jalr	1322(ra) # 80000cf8 <initlock>
  pr.locking = 1;
    800007d6:	4785                	li	a5,1
    800007d8:	cc9c                	sw	a5,24(s1)
}
    800007da:	60e2                	ld	ra,24(sp)
    800007dc:	6442                	ld	s0,16(sp)
    800007de:	64a2                	ld	s1,8(sp)
    800007e0:	6105                	addi	sp,sp,32
    800007e2:	8082                	ret

00000000800007e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ec:	100007b7          	lui	a5,0x10000
    800007f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f4:	10000737          	lui	a4,0x10000
    800007f8:	f8000693          	li	a3,-128
    800007fc:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000800:	468d                	li	a3,3
    80000802:	10000637          	lui	a2,0x10000
    80000806:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000080e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000812:	10000737          	lui	a4,0x10000
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	00008597          	auipc	a1,0x8
    80000824:	81858593          	addi	a1,a1,-2024 # 80008038 <etext+0x38>
    80000828:	00010517          	auipc	a0,0x10
    8000082c:	30050513          	addi	a0,a0,768 # 80010b28 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	4c8080e7          	jalr	1224(ra) # 80000cf8 <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000840:	1101                	addi	sp,sp,-32
    80000842:	ec06                	sd	ra,24(sp)
    80000844:	e822                	sd	s0,16(sp)
    80000846:	e426                	sd	s1,8(sp)
    80000848:	1000                	addi	s0,sp,32
    8000084a:	84aa                	mv	s1,a0
  push_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	4f0080e7          	jalr	1264(ra) # 80000d3c <push_off>

  if(panicked){
    80000854:	00008797          	auipc	a5,0x8
    80000858:	08c7a783          	lw	a5,140(a5) # 800088e0 <panicked>
    8000085c:	eb85                	bnez	a5,8000088c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000864:	00074783          	lbu	a5,0(a4)
    80000868:	0207f793          	andi	a5,a5,32
    8000086c:	dfe5                	beqz	a5,80000864 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086e:	0ff4f513          	zext.b	a0,s1
    80000872:	100007b7          	lui	a5,0x10000
    80000876:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	562080e7          	jalr	1378(ra) # 80000ddc <pop_off>
}
    80000882:	60e2                	ld	ra,24(sp)
    80000884:	6442                	ld	s0,16(sp)
    80000886:	64a2                	ld	s1,8(sp)
    80000888:	6105                	addi	sp,sp,32
    8000088a:	8082                	ret
    for(;;)
    8000088c:	a001                	j	8000088c <uartputc_sync+0x4c>

000000008000088e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088e:	00008797          	auipc	a5,0x8
    80000892:	05a7b783          	ld	a5,90(a5) # 800088e8 <uart_tx_r>
    80000896:	00008717          	auipc	a4,0x8
    8000089a:	05a73703          	ld	a4,90(a4) # 800088f0 <uart_tx_w>
    8000089e:	06f70f63          	beq	a4,a5,8000091c <uartstart+0x8e>
{
    800008a2:	7139                	addi	sp,sp,-64
    800008a4:	fc06                	sd	ra,56(sp)
    800008a6:	f822                	sd	s0,48(sp)
    800008a8:	f426                	sd	s1,40(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	ec4e                	sd	s3,24(sp)
    800008ae:	e852                	sd	s4,16(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	e05a                	sd	s6,0(sp)
    800008b4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b6:	10000937          	lui	s2,0x10000
    800008ba:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008bc:	00010a97          	auipc	s5,0x10
    800008c0:	26ca8a93          	addi	s5,s5,620 # 80010b28 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	00008497          	auipc	s1,0x8
    800008c8:	02448493          	addi	s1,s1,36 # 800088e8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	00008997          	auipc	s3,0x8
    800008d4:	02098993          	addi	s3,s3,32 # 800088f0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	00094703          	lbu	a4,0(s2)
    800008dc:	02077713          	andi	a4,a4,32
    800008e0:	c705                	beqz	a4,80000908 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e2:	01f7f713          	andi	a4,a5,31
    800008e6:	9756                	add	a4,a4,s5
    800008e8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ec:	0785                	addi	a5,a5,1
    800008ee:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008f0:	8526                	mv	a0,s1
    800008f2:	00002097          	auipc	ra,0x2
    800008f6:	b86080e7          	jalr	-1146(ra) # 80002478 <wakeup>
    WriteReg(THR, c);
    800008fa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fe:	609c                	ld	a5,0(s1)
    80000900:	0009b703          	ld	a4,0(s3)
    80000904:	fcf71ae3          	bne	a4,a5,800008d8 <uartstart+0x4a>
  }
}
    80000908:	70e2                	ld	ra,56(sp)
    8000090a:	7442                	ld	s0,48(sp)
    8000090c:	74a2                	ld	s1,40(sp)
    8000090e:	7902                	ld	s2,32(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6aa2                	ld	s5,8(sp)
    80000916:	6b02                	ld	s6,0(sp)
    80000918:	6121                	addi	sp,sp,64
    8000091a:	8082                	ret
    8000091c:	8082                	ret

000000008000091e <uartputc>:
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
    8000092e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000930:	00010517          	auipc	a0,0x10
    80000934:	1f850513          	addi	a0,a0,504 # 80010b28 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	450080e7          	jalr	1104(ra) # 80000d88 <acquire>
  if(panicked){
    80000940:	00008797          	auipc	a5,0x8
    80000944:	fa07a783          	lw	a5,-96(a5) # 800088e0 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	00008717          	auipc	a4,0x8
    8000094e:	fa673703          	ld	a4,-90(a4) # 800088f0 <uart_tx_w>
    80000952:	00008797          	auipc	a5,0x8
    80000956:	f967b783          	ld	a5,-106(a5) # 800088e8 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00010997          	auipc	s3,0x10
    80000962:	1ca98993          	addi	s3,s3,458 # 80010b28 <uart_tx_lock>
    80000966:	00008497          	auipc	s1,0x8
    8000096a:	f8248493          	addi	s1,s1,-126 # 800088e8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	00008917          	auipc	s2,0x8
    80000972:	f8290913          	addi	s2,s2,-126 # 800088f0 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	a96080e7          	jalr	-1386(ra) # 80002414 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00010497          	auipc	s1,0x10
    80000998:	19448493          	addi	s1,s1,404 # 80010b28 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	00008797          	auipc	a5,0x8
    800009ac:	f4e7b423          	sd	a4,-184(a5) # 800088f0 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	482080e7          	jalr	1154(ra) # 80000e3c <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xb4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e422                	sd	s0,8(sp)
    800009d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009e0:	0007c783          	lbu	a5,0(a5)
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb81                	beqz	a5,800009f6 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	6422                	ld	s0,8(sp)
    800009f2:	0141                	addi	sp,sp,16
    800009f4:	8082                	ret
    return -1;
    800009f6:	557d                	li	a0,-1
    800009f8:	bfe5                	j	800009f0 <uartgetc+0x1c>

00000000800009fa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a04:	54fd                	li	s1,-1
    80000a06:	a029                	j	80000a10 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	8ce080e7          	jalr	-1842(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	fc4080e7          	jalr	-60(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a18:	fe9518e3          	bne	a0,s1,80000a08 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1c:	00010497          	auipc	s1,0x10
    80000a20:	10c48493          	addi	s1,s1,268 # 80010b28 <uart_tx_lock>
    80000a24:	8526                	mv	a0,s1
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	362080e7          	jalr	866(ra) # 80000d88 <acquire>
  uartstart();
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	e60080e7          	jalr	-416(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	404080e7          	jalr	1028(ra) # 80000e3c <release>
}
    80000a40:	60e2                	ld	ra,24(sp)
    80000a42:	6442                	ld	s0,16(sp)
    80000a44:	64a2                	ld	s1,8(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret

0000000080000a4a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a4a:	7179                	addi	sp,sp,-48
    80000a4c:	f406                	sd	ra,40(sp)
    80000a4e:	f022                	sd	s0,32(sp)
    80000a50:	ec26                	sd	s1,24(sp)
    80000a52:	e84a                	sd	s2,16(sp)
    80000a54:	e44e                	sd	s3,8(sp)
    80000a56:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a58:	03451793          	slli	a5,a0,0x34
    80000a5c:	e3d9                	bnez	a5,80000ae2 <kfree+0x98>
    80000a5e:	84aa                	mv	s1,a0
    80000a60:	00241797          	auipc	a5,0x241
    80000a64:	74878793          	addi	a5,a5,1864 # 802421a8 <end>
    80000a68:	06f56d63          	bltu	a0,a5,80000ae2 <kfree+0x98>
    80000a6c:	47c5                	li	a5,17
    80000a6e:	07ee                	slli	a5,a5,0x1b
    80000a70:	06f57963          	bgeu	a0,a5,80000ae2 <kfree+0x98>
    panic("kfree");

 

  acquire(&ref_page_lock);
    80000a74:	00010517          	auipc	a0,0x10
    80000a78:	0ec50513          	addi	a0,a0,236 # 80010b60 <ref_page_lock>
    80000a7c:	00000097          	auipc	ra,0x0
    80000a80:	30c080e7          	jalr	780(ra) # 80000d88 <acquire>

  if(reference_counter[((uint64)pa)/PGSIZE] <=0 ){
    80000a84:	00c4d913          	srli	s2,s1,0xc
    80000a88:	00291713          	slli	a4,s2,0x2
    80000a8c:	00010797          	auipc	a5,0x10
    80000a90:	10c78793          	addi	a5,a5,268 # 80010b98 <reference_counter>
    80000a94:	97ba                	add	a5,a5,a4
    80000a96:	439c                	lw	a5,0(a5)
    80000a98:	04f05d63          	blez	a5,80000af2 <kfree+0xa8>
    panic("decrementing freed page");
  }
  release(&ref_page_lock);
    80000a9c:	00010997          	auipc	s3,0x10
    80000aa0:	0c498993          	addi	s3,s3,196 # 80010b60 <ref_page_lock>
    80000aa4:	854e                	mv	a0,s3
    80000aa6:	00000097          	auipc	ra,0x0
    80000aaa:	396080e7          	jalr	918(ra) # 80000e3c <release>

  acquire(&ref_page_lock);
    80000aae:	854e                	mv	a0,s3
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	2d8080e7          	jalr	728(ra) # 80000d88 <acquire>

  if(reference_counter[((uint64)pa)/PGSIZE] ==1){
    80000ab8:	00291713          	slli	a4,s2,0x2
    80000abc:	00010797          	auipc	a5,0x10
    80000ac0:	0dc78793          	addi	a5,a5,220 # 80010b98 <reference_counter>
    80000ac4:	97ba                	add	a5,a5,a4
    80000ac6:	439c                	lw	a5,0(a5)
    80000ac8:	4705                	li	a4,1
    80000aca:	02e78c63          	beq	a5,a4,80000b02 <kfree+0xb8>
    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);
  }
  else if (reference_counter[((uint64)pa)/PGSIZE] > 1){
    80000ace:	4705                	li	a4,1
    80000ad0:	08f74263          	blt	a4,a5,80000b54 <kfree+0x10a>
    reference_counter[((uint64)pa)/PGSIZE]-=1;
    release(&ref_page_lock);
  }

}
    80000ad4:	70a2                	ld	ra,40(sp)
    80000ad6:	7402                	ld	s0,32(sp)
    80000ad8:	64e2                	ld	s1,24(sp)
    80000ada:	6942                	ld	s2,16(sp)
    80000adc:	69a2                	ld	s3,8(sp)
    80000ade:	6145                	addi	sp,sp,48
    80000ae0:	8082                	ret
    panic("kfree");
    80000ae2:	00007517          	auipc	a0,0x7
    80000ae6:	55e50513          	addi	a0,a0,1374 # 80008040 <etext+0x40>
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	a76080e7          	jalr	-1418(ra) # 80000560 <panic>
    panic("decrementing freed page");
    80000af2:	00007517          	auipc	a0,0x7
    80000af6:	55650513          	addi	a0,a0,1366 # 80008048 <etext+0x48>
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	a66080e7          	jalr	-1434(ra) # 80000560 <panic>
    reference_counter[((uint64)pa)/PGSIZE] = 0;
    80000b02:	090a                	slli	s2,s2,0x2
    80000b04:	00010797          	auipc	a5,0x10
    80000b08:	09478793          	addi	a5,a5,148 # 80010b98 <reference_counter>
    80000b0c:	97ca                	add	a5,a5,s2
    80000b0e:	0007a023          	sw	zero,0(a5)
    release(&ref_page_lock);
    80000b12:	894e                	mv	s2,s3
    80000b14:	854e                	mv	a0,s3
    80000b16:	00000097          	auipc	ra,0x0
    80000b1a:	326080e7          	jalr	806(ra) # 80000e3c <release>
    memset(pa, 1, PGSIZE);
    80000b1e:	6605                	lui	a2,0x1
    80000b20:	4585                	li	a1,1
    80000b22:	8526                	mv	a0,s1
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	360080e7          	jalr	864(ra) # 80000e84 <memset>
    acquire(&kmem.lock);
    80000b2c:	00010997          	auipc	s3,0x10
    80000b30:	04c98993          	addi	s3,s3,76 # 80010b78 <kmem>
    80000b34:	854e                	mv	a0,s3
    80000b36:	00000097          	auipc	ra,0x0
    80000b3a:	252080e7          	jalr	594(ra) # 80000d88 <acquire>
    r->next = kmem.freelist;
    80000b3e:	03093783          	ld	a5,48(s2)
    80000b42:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000b44:	02993823          	sd	s1,48(s2)
    release(&kmem.lock);
    80000b48:	854e                	mv	a0,s3
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	2f2080e7          	jalr	754(ra) # 80000e3c <release>
    80000b52:	b749                	j	80000ad4 <kfree+0x8a>
    reference_counter[((uint64)pa)/PGSIZE]-=1;
    80000b54:	090a                	slli	s2,s2,0x2
    80000b56:	00010717          	auipc	a4,0x10
    80000b5a:	04270713          	addi	a4,a4,66 # 80010b98 <reference_counter>
    80000b5e:	974a                	add	a4,a4,s2
    80000b60:	37fd                	addiw	a5,a5,-1
    80000b62:	c31c                	sw	a5,0(a4)
    release(&ref_page_lock);
    80000b64:	00010517          	auipc	a0,0x10
    80000b68:	ffc50513          	addi	a0,a0,-4 # 80010b60 <ref_page_lock>
    80000b6c:	00000097          	auipc	ra,0x0
    80000b70:	2d0080e7          	jalr	720(ra) # 80000e3c <release>
}
    80000b74:	b785                	j	80000ad4 <kfree+0x8a>

0000000080000b76 <freerange>:
{
    80000b76:	7179                	addi	sp,sp,-48
    80000b78:	f406                	sd	ra,40(sp)
    80000b7a:	f022                	sd	s0,32(sp)
    80000b7c:	ec26                	sd	s1,24(sp)
    80000b7e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b80:	6785                	lui	a5,0x1
    80000b82:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b86:	00e504b3          	add	s1,a0,a4
    80000b8a:	777d                	lui	a4,0xfffff
    80000b8c:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000b8e:	94be                	add	s1,s1,a5
    80000b90:	0295e463          	bltu	a1,s1,80000bb8 <freerange+0x42>
    80000b94:	e84a                	sd	s2,16(sp)
    80000b96:	e44e                	sd	s3,8(sp)
    80000b98:	e052                	sd	s4,0(sp)
    80000b9a:	892e                	mv	s2,a1
    kfree(p);
    80000b9c:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000b9e:	6985                	lui	s3,0x1
    kfree(p);
    80000ba0:	01448533          	add	a0,s1,s4
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	ea6080e7          	jalr	-346(ra) # 80000a4a <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000bac:	94ce                	add	s1,s1,s3
    80000bae:	fe9979e3          	bgeu	s2,s1,80000ba0 <freerange+0x2a>
    80000bb2:	6942                	ld	s2,16(sp)
    80000bb4:	69a2                	ld	s3,8(sp)
    80000bb6:	6a02                	ld	s4,0(sp)
}
    80000bb8:	70a2                	ld	ra,40(sp)
    80000bba:	7402                	ld	s0,32(sp)
    80000bbc:	64e2                	ld	s1,24(sp)
    80000bbe:	6145                	addi	sp,sp,48
    80000bc0:	8082                	ret

0000000080000bc2 <kinit>:
{
    80000bc2:	7179                	addi	sp,sp,-48
    80000bc4:	f406                	sd	ra,40(sp)
    80000bc6:	f022                	sd	s0,32(sp)
    80000bc8:	ec26                	sd	s1,24(sp)
    80000bca:	e84a                	sd	s2,16(sp)
    80000bcc:	e44e                	sd	s3,8(sp)
    80000bce:	e052                	sd	s4,0(sp)
    80000bd0:	1800                	addi	s0,sp,48
  initlock(&kmem.lock, "kmem");
    80000bd2:	00007597          	auipc	a1,0x7
    80000bd6:	48e58593          	addi	a1,a1,1166 # 80008060 <etext+0x60>
    80000bda:	00010517          	auipc	a0,0x10
    80000bde:	f9e50513          	addi	a0,a0,-98 # 80010b78 <kmem>
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	116080e7          	jalr	278(ra) # 80000cf8 <initlock>
  initlock(&ref_page_lock,"refrence_counter");
    80000bea:	00007597          	auipc	a1,0x7
    80000bee:	47e58593          	addi	a1,a1,1150 # 80008068 <etext+0x68>
    80000bf2:	00010517          	auipc	a0,0x10
    80000bf6:	f6e50513          	addi	a0,a0,-146 # 80010b60 <ref_page_lock>
    80000bfa:	00000097          	auipc	ra,0x0
    80000bfe:	0fe080e7          	jalr	254(ra) # 80000cf8 <initlock>
  for(uint64 i = 0; i < (PHYSTOP / PGSIZE); i++) {
    80000c02:	00010497          	auipc	s1,0x10
    80000c06:	f9648493          	addi	s1,s1,-106 # 80010b98 <reference_counter>
    80000c0a:	00230a17          	auipc	s4,0x230
    80000c0e:	f8ea0a13          	addi	s4,s4,-114 # 80230b98 <pid_lock>
    acquire(&ref_page_lock);
    80000c12:	00010917          	auipc	s2,0x10
    80000c16:	f4e90913          	addi	s2,s2,-178 # 80010b60 <ref_page_lock>
    reference_counter[i] = 1; // Set initial reference count to 1 for all pages
    80000c1a:	4985                	li	s3,1
    acquire(&ref_page_lock);
    80000c1c:	854a                	mv	a0,s2
    80000c1e:	00000097          	auipc	ra,0x0
    80000c22:	16a080e7          	jalr	362(ra) # 80000d88 <acquire>
    reference_counter[i] = 1; // Set initial reference count to 1 for all pages
    80000c26:	0134a023          	sw	s3,0(s1)
    release(&ref_page_lock);
    80000c2a:	854a                	mv	a0,s2
    80000c2c:	00000097          	auipc	ra,0x0
    80000c30:	210080e7          	jalr	528(ra) # 80000e3c <release>
  for(uint64 i = 0; i < (PHYSTOP / PGSIZE); i++) {
    80000c34:	0491                	addi	s1,s1,4
    80000c36:	ff4493e3          	bne	s1,s4,80000c1c <kinit+0x5a>
  freerange(end, (void*)PHYSTOP);
    80000c3a:	45c5                	li	a1,17
    80000c3c:	05ee                	slli	a1,a1,0x1b
    80000c3e:	00241517          	auipc	a0,0x241
    80000c42:	56a50513          	addi	a0,a0,1386 # 802421a8 <end>
    80000c46:	00000097          	auipc	ra,0x0
    80000c4a:	f30080e7          	jalr	-208(ra) # 80000b76 <freerange>
}
    80000c4e:	70a2                	ld	ra,40(sp)
    80000c50:	7402                	ld	s0,32(sp)
    80000c52:	64e2                	ld	s1,24(sp)
    80000c54:	6942                	ld	s2,16(sp)
    80000c56:	69a2                	ld	s3,8(sp)
    80000c58:	6a02                	ld	s4,0(sp)
    80000c5a:	6145                	addi	sp,sp,48
    80000c5c:	8082                	ret

0000000080000c5e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000c5e:	1101                	addi	sp,sp,-32
    80000c60:	ec06                	sd	ra,24(sp)
    80000c62:	e822                	sd	s0,16(sp)
    80000c64:	e426                	sd	s1,8(sp)
    80000c66:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000c68:	00010517          	auipc	a0,0x10
    80000c6c:	f1050513          	addi	a0,a0,-240 # 80010b78 <kmem>
    80000c70:	00000097          	auipc	ra,0x0
    80000c74:	118080e7          	jalr	280(ra) # 80000d88 <acquire>
  r = kmem.freelist;
    80000c78:	00010497          	auipc	s1,0x10
    80000c7c:	f184b483          	ld	s1,-232(s1) # 80010b90 <kmem+0x18>
  if(r)
    80000c80:	c0bd                	beqz	s1,80000ce6 <kalloc+0x88>
    80000c82:	e04a                	sd	s2,0(sp)
    kmem.freelist = r->next;
    80000c84:	609c                	ld	a5,0(s1)
    80000c86:	00010917          	auipc	s2,0x10
    80000c8a:	eda90913          	addi	s2,s2,-294 # 80010b60 <ref_page_lock>
    80000c8e:	02f93823          	sd	a5,48(s2)
  release(&kmem.lock);
    80000c92:	00010517          	auipc	a0,0x10
    80000c96:	ee650513          	addi	a0,a0,-282 # 80010b78 <kmem>
    80000c9a:	00000097          	auipc	ra,0x0
    80000c9e:	1a2080e7          	jalr	418(ra) # 80000e3c <release>

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000ca2:	6605                	lui	a2,0x1
    80000ca4:	4595                	li	a1,5
    80000ca6:	8526                	mv	a0,s1
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	1dc080e7          	jalr	476(ra) # 80000e84 <memset>
    acquire(&ref_page_lock);
    80000cb0:	854a                	mv	a0,s2
    80000cb2:	00000097          	auipc	ra,0x0
    80000cb6:	0d6080e7          	jalr	214(ra) # 80000d88 <acquire>
    reference_counter[((uint64)r)/PGSIZE]  = 1;
    80000cba:	00c4d713          	srli	a4,s1,0xc
    80000cbe:	070a                	slli	a4,a4,0x2
    80000cc0:	00010797          	auipc	a5,0x10
    80000cc4:	ed878793          	addi	a5,a5,-296 # 80010b98 <reference_counter>
    80000cc8:	97ba                	add	a5,a5,a4
    80000cca:	4705                	li	a4,1
    80000ccc:	c398                	sw	a4,0(a5)
    release(&ref_page_lock);
    80000cce:	854a                	mv	a0,s2
    80000cd0:	00000097          	auipc	ra,0x0
    80000cd4:	16c080e7          	jalr	364(ra) # 80000e3c <release>
  }
  return (void*)r;
    80000cd8:	6902                	ld	s2,0(sp)
}
    80000cda:	8526                	mv	a0,s1
    80000cdc:	60e2                	ld	ra,24(sp)
    80000cde:	6442                	ld	s0,16(sp)
    80000ce0:	64a2                	ld	s1,8(sp)
    80000ce2:	6105                	addi	sp,sp,32
    80000ce4:	8082                	ret
  release(&kmem.lock);
    80000ce6:	00010517          	auipc	a0,0x10
    80000cea:	e9250513          	addi	a0,a0,-366 # 80010b78 <kmem>
    80000cee:	00000097          	auipc	ra,0x0
    80000cf2:	14e080e7          	jalr	334(ra) # 80000e3c <release>
  if(r){
    80000cf6:	b7d5                	j	80000cda <kalloc+0x7c>

0000000080000cf8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e422                	sd	s0,8(sp)
    80000cfc:	0800                	addi	s0,sp,16
  lk->name = name;
    80000cfe:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000d00:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000d04:	00053823          	sd	zero,16(a0)
}
    80000d08:	6422                	ld	s0,8(sp)
    80000d0a:	0141                	addi	sp,sp,16
    80000d0c:	8082                	ret

0000000080000d0e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000d0e:	411c                	lw	a5,0(a0)
    80000d10:	e399                	bnez	a5,80000d16 <holding+0x8>
    80000d12:	4501                	li	a0,0
  return r;
}
    80000d14:	8082                	ret
{
    80000d16:	1101                	addi	sp,sp,-32
    80000d18:	ec06                	sd	ra,24(sp)
    80000d1a:	e822                	sd	s0,16(sp)
    80000d1c:	e426                	sd	s1,8(sp)
    80000d1e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000d20:	6904                	ld	s1,16(a0)
    80000d22:	00001097          	auipc	ra,0x1
    80000d26:	ffe080e7          	jalr	-2(ra) # 80001d20 <mycpu>
    80000d2a:	40a48533          	sub	a0,s1,a0
    80000d2e:	00153513          	seqz	a0,a0
}
    80000d32:	60e2                	ld	ra,24(sp)
    80000d34:	6442                	ld	s0,16(sp)
    80000d36:	64a2                	ld	s1,8(sp)
    80000d38:	6105                	addi	sp,sp,32
    80000d3a:	8082                	ret

0000000080000d3c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000d3c:	1101                	addi	sp,sp,-32
    80000d3e:	ec06                	sd	ra,24(sp)
    80000d40:	e822                	sd	s0,16(sp)
    80000d42:	e426                	sd	s1,8(sp)
    80000d44:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d46:	100024f3          	csrr	s1,sstatus
    80000d4a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000d4e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d50:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000d54:	00001097          	auipc	ra,0x1
    80000d58:	fcc080e7          	jalr	-52(ra) # 80001d20 <mycpu>
    80000d5c:	5d3c                	lw	a5,120(a0)
    80000d5e:	cf89                	beqz	a5,80000d78 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d60:	00001097          	auipc	ra,0x1
    80000d64:	fc0080e7          	jalr	-64(ra) # 80001d20 <mycpu>
    80000d68:	5d3c                	lw	a5,120(a0)
    80000d6a:	2785                	addiw	a5,a5,1
    80000d6c:	dd3c                	sw	a5,120(a0)
}
    80000d6e:	60e2                	ld	ra,24(sp)
    80000d70:	6442                	ld	s0,16(sp)
    80000d72:	64a2                	ld	s1,8(sp)
    80000d74:	6105                	addi	sp,sp,32
    80000d76:	8082                	ret
    mycpu()->intena = old;
    80000d78:	00001097          	auipc	ra,0x1
    80000d7c:	fa8080e7          	jalr	-88(ra) # 80001d20 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d80:	8085                	srli	s1,s1,0x1
    80000d82:	8885                	andi	s1,s1,1
    80000d84:	dd64                	sw	s1,124(a0)
    80000d86:	bfe9                	j	80000d60 <push_off+0x24>

0000000080000d88 <acquire>:
{
    80000d88:	1101                	addi	sp,sp,-32
    80000d8a:	ec06                	sd	ra,24(sp)
    80000d8c:	e822                	sd	s0,16(sp)
    80000d8e:	e426                	sd	s1,8(sp)
    80000d90:	1000                	addi	s0,sp,32
    80000d92:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d94:	00000097          	auipc	ra,0x0
    80000d98:	fa8080e7          	jalr	-88(ra) # 80000d3c <push_off>
  if(holding(lk))
    80000d9c:	8526                	mv	a0,s1
    80000d9e:	00000097          	auipc	ra,0x0
    80000da2:	f70080e7          	jalr	-144(ra) # 80000d0e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000da6:	4705                	li	a4,1
  if(holding(lk))
    80000da8:	e115                	bnez	a0,80000dcc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000daa:	87ba                	mv	a5,a4
    80000dac:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000db0:	2781                	sext.w	a5,a5
    80000db2:	ffe5                	bnez	a5,80000daa <acquire+0x22>
  __sync_synchronize();
    80000db4:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000db8:	00001097          	auipc	ra,0x1
    80000dbc:	f68080e7          	jalr	-152(ra) # 80001d20 <mycpu>
    80000dc0:	e888                	sd	a0,16(s1)
}
    80000dc2:	60e2                	ld	ra,24(sp)
    80000dc4:	6442                	ld	s0,16(sp)
    80000dc6:	64a2                	ld	s1,8(sp)
    80000dc8:	6105                	addi	sp,sp,32
    80000dca:	8082                	ret
    panic("acquire");
    80000dcc:	00007517          	auipc	a0,0x7
    80000dd0:	2b450513          	addi	a0,a0,692 # 80008080 <etext+0x80>
    80000dd4:	fffff097          	auipc	ra,0xfffff
    80000dd8:	78c080e7          	jalr	1932(ra) # 80000560 <panic>

0000000080000ddc <pop_off>:

void
pop_off(void)
{
    80000ddc:	1141                	addi	sp,sp,-16
    80000dde:	e406                	sd	ra,8(sp)
    80000de0:	e022                	sd	s0,0(sp)
    80000de2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000de4:	00001097          	auipc	ra,0x1
    80000de8:	f3c080e7          	jalr	-196(ra) # 80001d20 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000dec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000df0:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000df2:	e78d                	bnez	a5,80000e1c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000df4:	5d3c                	lw	a5,120(a0)
    80000df6:	02f05b63          	blez	a5,80000e2c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000dfa:	37fd                	addiw	a5,a5,-1
    80000dfc:	0007871b          	sext.w	a4,a5
    80000e00:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000e02:	eb09                	bnez	a4,80000e14 <pop_off+0x38>
    80000e04:	5d7c                	lw	a5,124(a0)
    80000e06:	c799                	beqz	a5,80000e14 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000e0c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000e10:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000e14:	60a2                	ld	ra,8(sp)
    80000e16:	6402                	ld	s0,0(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret
    panic("pop_off - interruptible");
    80000e1c:	00007517          	auipc	a0,0x7
    80000e20:	26c50513          	addi	a0,a0,620 # 80008088 <etext+0x88>
    80000e24:	fffff097          	auipc	ra,0xfffff
    80000e28:	73c080e7          	jalr	1852(ra) # 80000560 <panic>
    panic("pop_off");
    80000e2c:	00007517          	auipc	a0,0x7
    80000e30:	27450513          	addi	a0,a0,628 # 800080a0 <etext+0xa0>
    80000e34:	fffff097          	auipc	ra,0xfffff
    80000e38:	72c080e7          	jalr	1836(ra) # 80000560 <panic>

0000000080000e3c <release>:
{
    80000e3c:	1101                	addi	sp,sp,-32
    80000e3e:	ec06                	sd	ra,24(sp)
    80000e40:	e822                	sd	s0,16(sp)
    80000e42:	e426                	sd	s1,8(sp)
    80000e44:	1000                	addi	s0,sp,32
    80000e46:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000e48:	00000097          	auipc	ra,0x0
    80000e4c:	ec6080e7          	jalr	-314(ra) # 80000d0e <holding>
    80000e50:	c115                	beqz	a0,80000e74 <release+0x38>
  lk->cpu = 0;
    80000e52:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000e56:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000e5a:	0f50000f          	fence	iorw,ow
    80000e5e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000e62:	00000097          	auipc	ra,0x0
    80000e66:	f7a080e7          	jalr	-134(ra) # 80000ddc <pop_off>
}
    80000e6a:	60e2                	ld	ra,24(sp)
    80000e6c:	6442                	ld	s0,16(sp)
    80000e6e:	64a2                	ld	s1,8(sp)
    80000e70:	6105                	addi	sp,sp,32
    80000e72:	8082                	ret
    panic("release");
    80000e74:	00007517          	auipc	a0,0x7
    80000e78:	23450513          	addi	a0,a0,564 # 800080a8 <etext+0xa8>
    80000e7c:	fffff097          	auipc	ra,0xfffff
    80000e80:	6e4080e7          	jalr	1764(ra) # 80000560 <panic>

0000000080000e84 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e84:	1141                	addi	sp,sp,-16
    80000e86:	e422                	sd	s0,8(sp)
    80000e88:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e8a:	ca19                	beqz	a2,80000ea0 <memset+0x1c>
    80000e8c:	87aa                	mv	a5,a0
    80000e8e:	1602                	slli	a2,a2,0x20
    80000e90:	9201                	srli	a2,a2,0x20
    80000e92:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e96:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e9a:	0785                	addi	a5,a5,1
    80000e9c:	fee79de3          	bne	a5,a4,80000e96 <memset+0x12>
  }
  return dst;
}
    80000ea0:	6422                	ld	s0,8(sp)
    80000ea2:	0141                	addi	sp,sp,16
    80000ea4:	8082                	ret

0000000080000ea6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ea6:	1141                	addi	sp,sp,-16
    80000ea8:	e422                	sd	s0,8(sp)
    80000eaa:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000eac:	ca05                	beqz	a2,80000edc <memcmp+0x36>
    80000eae:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000eb2:	1682                	slli	a3,a3,0x20
    80000eb4:	9281                	srli	a3,a3,0x20
    80000eb6:	0685                	addi	a3,a3,1
    80000eb8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000eba:	00054783          	lbu	a5,0(a0)
    80000ebe:	0005c703          	lbu	a4,0(a1)
    80000ec2:	00e79863          	bne	a5,a4,80000ed2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000ec6:	0505                	addi	a0,a0,1
    80000ec8:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000eca:	fed518e3          	bne	a0,a3,80000eba <memcmp+0x14>
  }

  return 0;
    80000ece:	4501                	li	a0,0
    80000ed0:	a019                	j	80000ed6 <memcmp+0x30>
      return *s1 - *s2;
    80000ed2:	40e7853b          	subw	a0,a5,a4
}
    80000ed6:	6422                	ld	s0,8(sp)
    80000ed8:	0141                	addi	sp,sp,16
    80000eda:	8082                	ret
  return 0;
    80000edc:	4501                	li	a0,0
    80000ede:	bfe5                	j	80000ed6 <memcmp+0x30>

0000000080000ee0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000ee0:	1141                	addi	sp,sp,-16
    80000ee2:	e422                	sd	s0,8(sp)
    80000ee4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000ee6:	c205                	beqz	a2,80000f06 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000ee8:	02a5e263          	bltu	a1,a0,80000f0c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000eec:	1602                	slli	a2,a2,0x20
    80000eee:	9201                	srli	a2,a2,0x20
    80000ef0:	00c587b3          	add	a5,a1,a2
{
    80000ef4:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ef6:	0585                	addi	a1,a1,1
    80000ef8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdbce59>
    80000efa:	fff5c683          	lbu	a3,-1(a1)
    80000efe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000f02:	feb79ae3          	bne	a5,a1,80000ef6 <memmove+0x16>

  return dst;
}
    80000f06:	6422                	ld	s0,8(sp)
    80000f08:	0141                	addi	sp,sp,16
    80000f0a:	8082                	ret
  if(s < d && s + n > d){
    80000f0c:	02061693          	slli	a3,a2,0x20
    80000f10:	9281                	srli	a3,a3,0x20
    80000f12:	00d58733          	add	a4,a1,a3
    80000f16:	fce57be3          	bgeu	a0,a4,80000eec <memmove+0xc>
    d += n;
    80000f1a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000f1c:	fff6079b          	addiw	a5,a2,-1
    80000f20:	1782                	slli	a5,a5,0x20
    80000f22:	9381                	srli	a5,a5,0x20
    80000f24:	fff7c793          	not	a5,a5
    80000f28:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000f2a:	177d                	addi	a4,a4,-1
    80000f2c:	16fd                	addi	a3,a3,-1
    80000f2e:	00074603          	lbu	a2,0(a4)
    80000f32:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000f36:	fef71ae3          	bne	a4,a5,80000f2a <memmove+0x4a>
    80000f3a:	b7f1                	j	80000f06 <memmove+0x26>

0000000080000f3c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000f3c:	1141                	addi	sp,sp,-16
    80000f3e:	e406                	sd	ra,8(sp)
    80000f40:	e022                	sd	s0,0(sp)
    80000f42:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000f44:	00000097          	auipc	ra,0x0
    80000f48:	f9c080e7          	jalr	-100(ra) # 80000ee0 <memmove>
}
    80000f4c:	60a2                	ld	ra,8(sp)
    80000f4e:	6402                	ld	s0,0(sp)
    80000f50:	0141                	addi	sp,sp,16
    80000f52:	8082                	ret

0000000080000f54 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000f54:	1141                	addi	sp,sp,-16
    80000f56:	e422                	sd	s0,8(sp)
    80000f58:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000f5a:	ce11                	beqz	a2,80000f76 <strncmp+0x22>
    80000f5c:	00054783          	lbu	a5,0(a0)
    80000f60:	cf89                	beqz	a5,80000f7a <strncmp+0x26>
    80000f62:	0005c703          	lbu	a4,0(a1)
    80000f66:	00f71a63          	bne	a4,a5,80000f7a <strncmp+0x26>
    n--, p++, q++;
    80000f6a:	367d                	addiw	a2,a2,-1
    80000f6c:	0505                	addi	a0,a0,1
    80000f6e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000f70:	f675                	bnez	a2,80000f5c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000f72:	4501                	li	a0,0
    80000f74:	a801                	j	80000f84 <strncmp+0x30>
    80000f76:	4501                	li	a0,0
    80000f78:	a031                	j	80000f84 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000f7a:	00054503          	lbu	a0,0(a0)
    80000f7e:	0005c783          	lbu	a5,0(a1)
    80000f82:	9d1d                	subw	a0,a0,a5
}
    80000f84:	6422                	ld	s0,8(sp)
    80000f86:	0141                	addi	sp,sp,16
    80000f88:	8082                	ret

0000000080000f8a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f8a:	1141                	addi	sp,sp,-16
    80000f8c:	e422                	sd	s0,8(sp)
    80000f8e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f90:	87aa                	mv	a5,a0
    80000f92:	86b2                	mv	a3,a2
    80000f94:	367d                	addiw	a2,a2,-1
    80000f96:	02d05563          	blez	a3,80000fc0 <strncpy+0x36>
    80000f9a:	0785                	addi	a5,a5,1
    80000f9c:	0005c703          	lbu	a4,0(a1)
    80000fa0:	fee78fa3          	sb	a4,-1(a5)
    80000fa4:	0585                	addi	a1,a1,1
    80000fa6:	f775                	bnez	a4,80000f92 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000fa8:	873e                	mv	a4,a5
    80000faa:	9fb5                	addw	a5,a5,a3
    80000fac:	37fd                	addiw	a5,a5,-1
    80000fae:	00c05963          	blez	a2,80000fc0 <strncpy+0x36>
    *s++ = 0;
    80000fb2:	0705                	addi	a4,a4,1
    80000fb4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000fb8:	40e786bb          	subw	a3,a5,a4
    80000fbc:	fed04be3          	bgtz	a3,80000fb2 <strncpy+0x28>
  return os;
}
    80000fc0:	6422                	ld	s0,8(sp)
    80000fc2:	0141                	addi	sp,sp,16
    80000fc4:	8082                	ret

0000000080000fc6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000fc6:	1141                	addi	sp,sp,-16
    80000fc8:	e422                	sd	s0,8(sp)
    80000fca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000fcc:	02c05363          	blez	a2,80000ff2 <safestrcpy+0x2c>
    80000fd0:	fff6069b          	addiw	a3,a2,-1
    80000fd4:	1682                	slli	a3,a3,0x20
    80000fd6:	9281                	srli	a3,a3,0x20
    80000fd8:	96ae                	add	a3,a3,a1
    80000fda:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000fdc:	00d58963          	beq	a1,a3,80000fee <safestrcpy+0x28>
    80000fe0:	0585                	addi	a1,a1,1
    80000fe2:	0785                	addi	a5,a5,1
    80000fe4:	fff5c703          	lbu	a4,-1(a1)
    80000fe8:	fee78fa3          	sb	a4,-1(a5)
    80000fec:	fb65                	bnez	a4,80000fdc <safestrcpy+0x16>
    ;
  *s = 0;
    80000fee:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ff2:	6422                	ld	s0,8(sp)
    80000ff4:	0141                	addi	sp,sp,16
    80000ff6:	8082                	ret

0000000080000ff8 <strlen>:

int
strlen(const char *s)
{
    80000ff8:	1141                	addi	sp,sp,-16
    80000ffa:	e422                	sd	s0,8(sp)
    80000ffc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ffe:	00054783          	lbu	a5,0(a0)
    80001002:	cf91                	beqz	a5,8000101e <strlen+0x26>
    80001004:	0505                	addi	a0,a0,1
    80001006:	87aa                	mv	a5,a0
    80001008:	86be                	mv	a3,a5
    8000100a:	0785                	addi	a5,a5,1
    8000100c:	fff7c703          	lbu	a4,-1(a5)
    80001010:	ff65                	bnez	a4,80001008 <strlen+0x10>
    80001012:	40a6853b          	subw	a0,a3,a0
    80001016:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80001018:	6422                	ld	s0,8(sp)
    8000101a:	0141                	addi	sp,sp,16
    8000101c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000101e:	4501                	li	a0,0
    80001020:	bfe5                	j	80001018 <strlen+0x20>

0000000080001022 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001022:	1141                	addi	sp,sp,-16
    80001024:	e406                	sd	ra,8(sp)
    80001026:	e022                	sd	s0,0(sp)
    80001028:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000102a:	00001097          	auipc	ra,0x1
    8000102e:	ce6080e7          	jalr	-794(ra) # 80001d10 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80001032:	00008717          	auipc	a4,0x8
    80001036:	8c670713          	addi	a4,a4,-1850 # 800088f8 <started>
  if(cpuid() == 0){
    8000103a:	c139                	beqz	a0,80001080 <main+0x5e>
    while(started == 0)
    8000103c:	431c                	lw	a5,0(a4)
    8000103e:	2781                	sext.w	a5,a5
    80001040:	dff5                	beqz	a5,8000103c <main+0x1a>
      ;
    __sync_synchronize();
    80001042:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80001046:	00001097          	auipc	ra,0x1
    8000104a:	cca080e7          	jalr	-822(ra) # 80001d10 <cpuid>
    8000104e:	85aa                	mv	a1,a0
    80001050:	00007517          	auipc	a0,0x7
    80001054:	07850513          	addi	a0,a0,120 # 800080c8 <etext+0xc8>
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	552080e7          	jalr	1362(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80001060:	00000097          	auipc	ra,0x0
    80001064:	0d8080e7          	jalr	216(ra) # 80001138 <kvminithart>
    trapinithart();   // install kernel trap vector
    80001068:	00002097          	auipc	ra,0x2
    8000106c:	b58080e7          	jalr	-1192(ra) # 80002bc0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001070:	00005097          	auipc	ra,0x5
    80001074:	474080e7          	jalr	1140(ra) # 800064e4 <plicinithart>
  }

  scheduler();        
    80001078:	00001097          	auipc	ra,0x1
    8000107c:	1ea080e7          	jalr	490(ra) # 80002262 <scheduler>
    consoleinit();
    80001080:	fffff097          	auipc	ra,0xfffff
    80001084:	3f0080e7          	jalr	1008(ra) # 80000470 <consoleinit>
    printfinit();
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	72a080e7          	jalr	1834(ra) # 800007b2 <printfinit>
    printf("\n");
    80001090:	00007517          	auipc	a0,0x7
    80001094:	f8050513          	addi	a0,a0,-128 # 80008010 <etext+0x10>
    80001098:	fffff097          	auipc	ra,0xfffff
    8000109c:	512080e7          	jalr	1298(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    800010a0:	00007517          	auipc	a0,0x7
    800010a4:	01050513          	addi	a0,a0,16 # 800080b0 <etext+0xb0>
    800010a8:	fffff097          	auipc	ra,0xfffff
    800010ac:	502080e7          	jalr	1282(ra) # 800005aa <printf>
    printf("\n");
    800010b0:	00007517          	auipc	a0,0x7
    800010b4:	f6050513          	addi	a0,a0,-160 # 80008010 <etext+0x10>
    800010b8:	fffff097          	auipc	ra,0xfffff
    800010bc:	4f2080e7          	jalr	1266(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	b02080e7          	jalr	-1278(ra) # 80000bc2 <kinit>
    kvminit();       // create kernel page table
    800010c8:	00000097          	auipc	ra,0x0
    800010cc:	326080e7          	jalr	806(ra) # 800013ee <kvminit>
    kvminithart();   // turn on paging
    800010d0:	00000097          	auipc	ra,0x0
    800010d4:	068080e7          	jalr	104(ra) # 80001138 <kvminithart>
    procinit();      // process table
    800010d8:	00001097          	auipc	ra,0x1
    800010dc:	b76080e7          	jalr	-1162(ra) # 80001c4e <procinit>
    trapinit();      // trap vectors
    800010e0:	00002097          	auipc	ra,0x2
    800010e4:	ab8080e7          	jalr	-1352(ra) # 80002b98 <trapinit>
    trapinithart();  // install kernel trap vector
    800010e8:	00002097          	auipc	ra,0x2
    800010ec:	ad8080e7          	jalr	-1320(ra) # 80002bc0 <trapinithart>
    plicinit();      // set up interrupt controller
    800010f0:	00005097          	auipc	ra,0x5
    800010f4:	3da080e7          	jalr	986(ra) # 800064ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800010f8:	00005097          	auipc	ra,0x5
    800010fc:	3ec080e7          	jalr	1004(ra) # 800064e4 <plicinithart>
    binit();         // buffer cache
    80001100:	00002097          	auipc	ra,0x2
    80001104:	4ae080e7          	jalr	1198(ra) # 800035ae <binit>
    iinit();         // inode table
    80001108:	00003097          	auipc	ra,0x3
    8000110c:	b64080e7          	jalr	-1180(ra) # 80003c6c <iinit>
    fileinit();      // file table
    80001110:	00004097          	auipc	ra,0x4
    80001114:	b14080e7          	jalr	-1260(ra) # 80004c24 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001118:	00005097          	auipc	ra,0x5
    8000111c:	4d4080e7          	jalr	1236(ra) # 800065ec <virtio_disk_init>
    userinit();      // first user process
    80001120:	00001097          	auipc	ra,0x1
    80001124:	f22080e7          	jalr	-222(ra) # 80002042 <userinit>
    __sync_synchronize();
    80001128:	0ff0000f          	fence
    started = 1;
    8000112c:	4785                	li	a5,1
    8000112e:	00007717          	auipc	a4,0x7
    80001132:	7cf72523          	sw	a5,1994(a4) # 800088f8 <started>
    80001136:	b789                	j	80001078 <main+0x56>

0000000080001138 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001138:	1141                	addi	sp,sp,-16
    8000113a:	e422                	sd	s0,8(sp)
    8000113c:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000113e:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001142:	00007797          	auipc	a5,0x7
    80001146:	7be7b783          	ld	a5,1982(a5) # 80008900 <kernel_pagetable>
    8000114a:	83b1                	srli	a5,a5,0xc
    8000114c:	577d                	li	a4,-1
    8000114e:	177e                	slli	a4,a4,0x3f
    80001150:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001152:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001156:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000115a:	6422                	ld	s0,8(sp)
    8000115c:	0141                	addi	sp,sp,16
    8000115e:	8082                	ret

0000000080001160 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001160:	7139                	addi	sp,sp,-64
    80001162:	fc06                	sd	ra,56(sp)
    80001164:	f822                	sd	s0,48(sp)
    80001166:	f426                	sd	s1,40(sp)
    80001168:	f04a                	sd	s2,32(sp)
    8000116a:	ec4e                	sd	s3,24(sp)
    8000116c:	e852                	sd	s4,16(sp)
    8000116e:	e456                	sd	s5,8(sp)
    80001170:	e05a                	sd	s6,0(sp)
    80001172:	0080                	addi	s0,sp,64
    80001174:	84aa                	mv	s1,a0
    80001176:	89ae                	mv	s3,a1
    80001178:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000117a:	57fd                	li	a5,-1
    8000117c:	83e9                	srli	a5,a5,0x1a
    8000117e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001180:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001182:	04b7f263          	bgeu	a5,a1,800011c6 <walk+0x66>
    panic("walk");
    80001186:	00007517          	auipc	a0,0x7
    8000118a:	f5a50513          	addi	a0,a0,-166 # 800080e0 <etext+0xe0>
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	3d2080e7          	jalr	978(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001196:	060a8663          	beqz	s5,80001202 <walk+0xa2>
    8000119a:	00000097          	auipc	ra,0x0
    8000119e:	ac4080e7          	jalr	-1340(ra) # 80000c5e <kalloc>
    800011a2:	84aa                	mv	s1,a0
    800011a4:	c529                	beqz	a0,800011ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800011a6:	6605                	lui	a2,0x1
    800011a8:	4581                	li	a1,0
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	cda080e7          	jalr	-806(ra) # 80000e84 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800011b2:	00c4d793          	srli	a5,s1,0xc
    800011b6:	07aa                	slli	a5,a5,0xa
    800011b8:	0017e793          	ori	a5,a5,1
    800011bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800011c0:	3a5d                	addiw	s4,s4,-9
    800011c2:	036a0063          	beq	s4,s6,800011e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800011c6:	0149d933          	srl	s2,s3,s4
    800011ca:	1ff97913          	andi	s2,s2,511
    800011ce:	090e                	slli	s2,s2,0x3
    800011d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800011d2:	00093483          	ld	s1,0(s2)
    800011d6:	0014f793          	andi	a5,s1,1
    800011da:	dfd5                	beqz	a5,80001196 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800011dc:	80a9                	srli	s1,s1,0xa
    800011de:	04b2                	slli	s1,s1,0xc
    800011e0:	b7c5                	j	800011c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800011e2:	00c9d513          	srli	a0,s3,0xc
    800011e6:	1ff57513          	andi	a0,a0,511
    800011ea:	050e                	slli	a0,a0,0x3
    800011ec:	9526                	add	a0,a0,s1
}
    800011ee:	70e2                	ld	ra,56(sp)
    800011f0:	7442                	ld	s0,48(sp)
    800011f2:	74a2                	ld	s1,40(sp)
    800011f4:	7902                	ld	s2,32(sp)
    800011f6:	69e2                	ld	s3,24(sp)
    800011f8:	6a42                	ld	s4,16(sp)
    800011fa:	6aa2                	ld	s5,8(sp)
    800011fc:	6b02                	ld	s6,0(sp)
    800011fe:	6121                	addi	sp,sp,64
    80001200:	8082                	ret
        return 0;
    80001202:	4501                	li	a0,0
    80001204:	b7ed                	j	800011ee <walk+0x8e>

0000000080001206 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001206:	57fd                	li	a5,-1
    80001208:	83e9                	srli	a5,a5,0x1a
    8000120a:	00b7f463          	bgeu	a5,a1,80001212 <walkaddr+0xc>
    return 0;
    8000120e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001210:	8082                	ret
{
    80001212:	1141                	addi	sp,sp,-16
    80001214:	e406                	sd	ra,8(sp)
    80001216:	e022                	sd	s0,0(sp)
    80001218:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000121a:	4601                	li	a2,0
    8000121c:	00000097          	auipc	ra,0x0
    80001220:	f44080e7          	jalr	-188(ra) # 80001160 <walk>
  if(pte == 0)
    80001224:	c105                	beqz	a0,80001244 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001226:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001228:	0117f693          	andi	a3,a5,17
    8000122c:	4745                	li	a4,17
    return 0;
    8000122e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001230:	00e68663          	beq	a3,a4,8000123c <walkaddr+0x36>
}
    80001234:	60a2                	ld	ra,8(sp)
    80001236:	6402                	ld	s0,0(sp)
    80001238:	0141                	addi	sp,sp,16
    8000123a:	8082                	ret
  pa = PTE2PA(*pte);
    8000123c:	83a9                	srli	a5,a5,0xa
    8000123e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001242:	bfcd                	j	80001234 <walkaddr+0x2e>
    return 0;
    80001244:	4501                	li	a0,0
    80001246:	b7fd                	j	80001234 <walkaddr+0x2e>

0000000080001248 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001248:	715d                	addi	sp,sp,-80
    8000124a:	e486                	sd	ra,72(sp)
    8000124c:	e0a2                	sd	s0,64(sp)
    8000124e:	fc26                	sd	s1,56(sp)
    80001250:	f84a                	sd	s2,48(sp)
    80001252:	f44e                	sd	s3,40(sp)
    80001254:	f052                	sd	s4,32(sp)
    80001256:	ec56                	sd	s5,24(sp)
    80001258:	e85a                	sd	s6,16(sp)
    8000125a:	e45e                	sd	s7,8(sp)
    8000125c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000125e:	c639                	beqz	a2,800012ac <mappages+0x64>
    80001260:	8aaa                	mv	s5,a0
    80001262:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001264:	777d                	lui	a4,0xfffff
    80001266:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000126a:	fff58993          	addi	s3,a1,-1
    8000126e:	99b2                	add	s3,s3,a2
    80001270:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001274:	893e                	mv	s2,a5
    80001276:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000127a:	6b85                	lui	s7,0x1
    8000127c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001280:	4605                	li	a2,1
    80001282:	85ca                	mv	a1,s2
    80001284:	8556                	mv	a0,s5
    80001286:	00000097          	auipc	ra,0x0
    8000128a:	eda080e7          	jalr	-294(ra) # 80001160 <walk>
    8000128e:	cd1d                	beqz	a0,800012cc <mappages+0x84>
    if(*pte & PTE_V)
    80001290:	611c                	ld	a5,0(a0)
    80001292:	8b85                	andi	a5,a5,1
    80001294:	e785                	bnez	a5,800012bc <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001296:	80b1                	srli	s1,s1,0xc
    80001298:	04aa                	slli	s1,s1,0xa
    8000129a:	0164e4b3          	or	s1,s1,s6
    8000129e:	0014e493          	ori	s1,s1,1
    800012a2:	e104                	sd	s1,0(a0)
    if(a == last)
    800012a4:	05390063          	beq	s2,s3,800012e4 <mappages+0x9c>
    a += PGSIZE;
    800012a8:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800012aa:	bfc9                	j	8000127c <mappages+0x34>
    panic("mappages: size");
    800012ac:	00007517          	auipc	a0,0x7
    800012b0:	e3c50513          	addi	a0,a0,-452 # 800080e8 <etext+0xe8>
    800012b4:	fffff097          	auipc	ra,0xfffff
    800012b8:	2ac080e7          	jalr	684(ra) # 80000560 <panic>
      panic("mappages: remap");
    800012bc:	00007517          	auipc	a0,0x7
    800012c0:	e3c50513          	addi	a0,a0,-452 # 800080f8 <etext+0xf8>
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	29c080e7          	jalr	668(ra) # 80000560 <panic>
      return -1;
    800012cc:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800012ce:	60a6                	ld	ra,72(sp)
    800012d0:	6406                	ld	s0,64(sp)
    800012d2:	74e2                	ld	s1,56(sp)
    800012d4:	7942                	ld	s2,48(sp)
    800012d6:	79a2                	ld	s3,40(sp)
    800012d8:	7a02                	ld	s4,32(sp)
    800012da:	6ae2                	ld	s5,24(sp)
    800012dc:	6b42                	ld	s6,16(sp)
    800012de:	6ba2                	ld	s7,8(sp)
    800012e0:	6161                	addi	sp,sp,80
    800012e2:	8082                	ret
  return 0;
    800012e4:	4501                	li	a0,0
    800012e6:	b7e5                	j	800012ce <mappages+0x86>

00000000800012e8 <kvmmap>:
{
    800012e8:	1141                	addi	sp,sp,-16
    800012ea:	e406                	sd	ra,8(sp)
    800012ec:	e022                	sd	s0,0(sp)
    800012ee:	0800                	addi	s0,sp,16
    800012f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800012f2:	86b2                	mv	a3,a2
    800012f4:	863e                	mv	a2,a5
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	f52080e7          	jalr	-174(ra) # 80001248 <mappages>
    800012fe:	e509                	bnez	a0,80001308 <kvmmap+0x20>
}
    80001300:	60a2                	ld	ra,8(sp)
    80001302:	6402                	ld	s0,0(sp)
    80001304:	0141                	addi	sp,sp,16
    80001306:	8082                	ret
    panic("kvmmap");
    80001308:	00007517          	auipc	a0,0x7
    8000130c:	e0050513          	addi	a0,a0,-512 # 80008108 <etext+0x108>
    80001310:	fffff097          	auipc	ra,0xfffff
    80001314:	250080e7          	jalr	592(ra) # 80000560 <panic>

0000000080001318 <kvmmake>:
{
    80001318:	1101                	addi	sp,sp,-32
    8000131a:	ec06                	sd	ra,24(sp)
    8000131c:	e822                	sd	s0,16(sp)
    8000131e:	e426                	sd	s1,8(sp)
    80001320:	e04a                	sd	s2,0(sp)
    80001322:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001324:	00000097          	auipc	ra,0x0
    80001328:	93a080e7          	jalr	-1734(ra) # 80000c5e <kalloc>
    8000132c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000132e:	6605                	lui	a2,0x1
    80001330:	4581                	li	a1,0
    80001332:	00000097          	auipc	ra,0x0
    80001336:	b52080e7          	jalr	-1198(ra) # 80000e84 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000133a:	4719                	li	a4,6
    8000133c:	6685                	lui	a3,0x1
    8000133e:	10000637          	lui	a2,0x10000
    80001342:	100005b7          	lui	a1,0x10000
    80001346:	8526                	mv	a0,s1
    80001348:	00000097          	auipc	ra,0x0
    8000134c:	fa0080e7          	jalr	-96(ra) # 800012e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001350:	4719                	li	a4,6
    80001352:	6685                	lui	a3,0x1
    80001354:	10001637          	lui	a2,0x10001
    80001358:	100015b7          	lui	a1,0x10001
    8000135c:	8526                	mv	a0,s1
    8000135e:	00000097          	auipc	ra,0x0
    80001362:	f8a080e7          	jalr	-118(ra) # 800012e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001366:	4719                	li	a4,6
    80001368:	004006b7          	lui	a3,0x400
    8000136c:	0c000637          	lui	a2,0xc000
    80001370:	0c0005b7          	lui	a1,0xc000
    80001374:	8526                	mv	a0,s1
    80001376:	00000097          	auipc	ra,0x0
    8000137a:	f72080e7          	jalr	-142(ra) # 800012e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000137e:	00007917          	auipc	s2,0x7
    80001382:	c8290913          	addi	s2,s2,-894 # 80008000 <etext>
    80001386:	4729                	li	a4,10
    80001388:	80007697          	auipc	a3,0x80007
    8000138c:	c7868693          	addi	a3,a3,-904 # 8000 <_entry-0x7fff8000>
    80001390:	4605                	li	a2,1
    80001392:	067e                	slli	a2,a2,0x1f
    80001394:	85b2                	mv	a1,a2
    80001396:	8526                	mv	a0,s1
    80001398:	00000097          	auipc	ra,0x0
    8000139c:	f50080e7          	jalr	-176(ra) # 800012e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800013a0:	46c5                	li	a3,17
    800013a2:	06ee                	slli	a3,a3,0x1b
    800013a4:	4719                	li	a4,6
    800013a6:	412686b3          	sub	a3,a3,s2
    800013aa:	864a                	mv	a2,s2
    800013ac:	85ca                	mv	a1,s2
    800013ae:	8526                	mv	a0,s1
    800013b0:	00000097          	auipc	ra,0x0
    800013b4:	f38080e7          	jalr	-200(ra) # 800012e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800013b8:	4729                	li	a4,10
    800013ba:	6685                	lui	a3,0x1
    800013bc:	00006617          	auipc	a2,0x6
    800013c0:	c4460613          	addi	a2,a2,-956 # 80007000 <_trampoline>
    800013c4:	040005b7          	lui	a1,0x4000
    800013c8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800013ca:	05b2                	slli	a1,a1,0xc
    800013cc:	8526                	mv	a0,s1
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	f1a080e7          	jalr	-230(ra) # 800012e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800013d6:	8526                	mv	a0,s1
    800013d8:	00000097          	auipc	ra,0x0
    800013dc:	7d2080e7          	jalr	2002(ra) # 80001baa <proc_mapstacks>
}
    800013e0:	8526                	mv	a0,s1
    800013e2:	60e2                	ld	ra,24(sp)
    800013e4:	6442                	ld	s0,16(sp)
    800013e6:	64a2                	ld	s1,8(sp)
    800013e8:	6902                	ld	s2,0(sp)
    800013ea:	6105                	addi	sp,sp,32
    800013ec:	8082                	ret

00000000800013ee <kvminit>:
{
    800013ee:	1141                	addi	sp,sp,-16
    800013f0:	e406                	sd	ra,8(sp)
    800013f2:	e022                	sd	s0,0(sp)
    800013f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	f22080e7          	jalr	-222(ra) # 80001318 <kvmmake>
    800013fe:	00007797          	auipc	a5,0x7
    80001402:	50a7b123          	sd	a0,1282(a5) # 80008900 <kernel_pagetable>
}
    80001406:	60a2                	ld	ra,8(sp)
    80001408:	6402                	ld	s0,0(sp)
    8000140a:	0141                	addi	sp,sp,16
    8000140c:	8082                	ret

000000008000140e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000140e:	715d                	addi	sp,sp,-80
    80001410:	e486                	sd	ra,72(sp)
    80001412:	e0a2                	sd	s0,64(sp)
    80001414:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001416:	03459793          	slli	a5,a1,0x34
    8000141a:	e39d                	bnez	a5,80001440 <uvmunmap+0x32>
    8000141c:	f84a                	sd	s2,48(sp)
    8000141e:	f44e                	sd	s3,40(sp)
    80001420:	f052                	sd	s4,32(sp)
    80001422:	ec56                	sd	s5,24(sp)
    80001424:	e85a                	sd	s6,16(sp)
    80001426:	e45e                	sd	s7,8(sp)
    80001428:	8a2a                	mv	s4,a0
    8000142a:	892e                	mv	s2,a1
    8000142c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000142e:	0632                	slli	a2,a2,0xc
    80001430:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001434:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001436:	6b05                	lui	s6,0x1
    80001438:	0935fb63          	bgeu	a1,s3,800014ce <uvmunmap+0xc0>
    8000143c:	fc26                	sd	s1,56(sp)
    8000143e:	a8a9                	j	80001498 <uvmunmap+0x8a>
    80001440:	fc26                	sd	s1,56(sp)
    80001442:	f84a                	sd	s2,48(sp)
    80001444:	f44e                	sd	s3,40(sp)
    80001446:	f052                	sd	s4,32(sp)
    80001448:	ec56                	sd	s5,24(sp)
    8000144a:	e85a                	sd	s6,16(sp)
    8000144c:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000144e:	00007517          	auipc	a0,0x7
    80001452:	cc250513          	addi	a0,a0,-830 # 80008110 <etext+0x110>
    80001456:	fffff097          	auipc	ra,0xfffff
    8000145a:	10a080e7          	jalr	266(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    8000145e:	00007517          	auipc	a0,0x7
    80001462:	cca50513          	addi	a0,a0,-822 # 80008128 <etext+0x128>
    80001466:	fffff097          	auipc	ra,0xfffff
    8000146a:	0fa080e7          	jalr	250(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    8000146e:	00007517          	auipc	a0,0x7
    80001472:	cca50513          	addi	a0,a0,-822 # 80008138 <etext+0x138>
    80001476:	fffff097          	auipc	ra,0xfffff
    8000147a:	0ea080e7          	jalr	234(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    8000147e:	00007517          	auipc	a0,0x7
    80001482:	cd250513          	addi	a0,a0,-814 # 80008150 <etext+0x150>
    80001486:	fffff097          	auipc	ra,0xfffff
    8000148a:	0da080e7          	jalr	218(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000148e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001492:	995a                	add	s2,s2,s6
    80001494:	03397c63          	bgeu	s2,s3,800014cc <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001498:	4601                	li	a2,0
    8000149a:	85ca                	mv	a1,s2
    8000149c:	8552                	mv	a0,s4
    8000149e:	00000097          	auipc	ra,0x0
    800014a2:	cc2080e7          	jalr	-830(ra) # 80001160 <walk>
    800014a6:	84aa                	mv	s1,a0
    800014a8:	d95d                	beqz	a0,8000145e <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800014aa:	6108                	ld	a0,0(a0)
    800014ac:	00157793          	andi	a5,a0,1
    800014b0:	dfdd                	beqz	a5,8000146e <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800014b2:	3ff57793          	andi	a5,a0,1023
    800014b6:	fd7784e3          	beq	a5,s7,8000147e <uvmunmap+0x70>
    if(do_free){
    800014ba:	fc0a8ae3          	beqz	s5,8000148e <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800014be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800014c0:	0532                	slli	a0,a0,0xc
    800014c2:	fffff097          	auipc	ra,0xfffff
    800014c6:	588080e7          	jalr	1416(ra) # 80000a4a <kfree>
    800014ca:	b7d1                	j	8000148e <uvmunmap+0x80>
    800014cc:	74e2                	ld	s1,56(sp)
    800014ce:	7942                	ld	s2,48(sp)
    800014d0:	79a2                	ld	s3,40(sp)
    800014d2:	7a02                	ld	s4,32(sp)
    800014d4:	6ae2                	ld	s5,24(sp)
    800014d6:	6b42                	ld	s6,16(sp)
    800014d8:	6ba2                	ld	s7,8(sp)
  }
}
    800014da:	60a6                	ld	ra,72(sp)
    800014dc:	6406                	ld	s0,64(sp)
    800014de:	6161                	addi	sp,sp,80
    800014e0:	8082                	ret

00000000800014e2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800014e2:	1101                	addi	sp,sp,-32
    800014e4:	ec06                	sd	ra,24(sp)
    800014e6:	e822                	sd	s0,16(sp)
    800014e8:	e426                	sd	s1,8(sp)
    800014ea:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800014ec:	fffff097          	auipc	ra,0xfffff
    800014f0:	772080e7          	jalr	1906(ra) # 80000c5e <kalloc>
    800014f4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800014f6:	c519                	beqz	a0,80001504 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800014f8:	6605                	lui	a2,0x1
    800014fa:	4581                	li	a1,0
    800014fc:	00000097          	auipc	ra,0x0
    80001500:	988080e7          	jalr	-1656(ra) # 80000e84 <memset>
  return pagetable;
}
    80001504:	8526                	mv	a0,s1
    80001506:	60e2                	ld	ra,24(sp)
    80001508:	6442                	ld	s0,16(sp)
    8000150a:	64a2                	ld	s1,8(sp)
    8000150c:	6105                	addi	sp,sp,32
    8000150e:	8082                	ret

0000000080001510 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001510:	7179                	addi	sp,sp,-48
    80001512:	f406                	sd	ra,40(sp)
    80001514:	f022                	sd	s0,32(sp)
    80001516:	ec26                	sd	s1,24(sp)
    80001518:	e84a                	sd	s2,16(sp)
    8000151a:	e44e                	sd	s3,8(sp)
    8000151c:	e052                	sd	s4,0(sp)
    8000151e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001520:	6785                	lui	a5,0x1
    80001522:	04f67863          	bgeu	a2,a5,80001572 <uvmfirst+0x62>
    80001526:	8a2a                	mv	s4,a0
    80001528:	89ae                	mv	s3,a1
    8000152a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000152c:	fffff097          	auipc	ra,0xfffff
    80001530:	732080e7          	jalr	1842(ra) # 80000c5e <kalloc>
    80001534:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001536:	6605                	lui	a2,0x1
    80001538:	4581                	li	a1,0
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	94a080e7          	jalr	-1718(ra) # 80000e84 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001542:	4779                	li	a4,30
    80001544:	86ca                	mv	a3,s2
    80001546:	6605                	lui	a2,0x1
    80001548:	4581                	li	a1,0
    8000154a:	8552                	mv	a0,s4
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	cfc080e7          	jalr	-772(ra) # 80001248 <mappages>
  memmove(mem, src, sz);
    80001554:	8626                	mv	a2,s1
    80001556:	85ce                	mv	a1,s3
    80001558:	854a                	mv	a0,s2
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	986080e7          	jalr	-1658(ra) # 80000ee0 <memmove>
}
    80001562:	70a2                	ld	ra,40(sp)
    80001564:	7402                	ld	s0,32(sp)
    80001566:	64e2                	ld	s1,24(sp)
    80001568:	6942                	ld	s2,16(sp)
    8000156a:	69a2                	ld	s3,8(sp)
    8000156c:	6a02                	ld	s4,0(sp)
    8000156e:	6145                	addi	sp,sp,48
    80001570:	8082                	ret
    panic("uvmfirst: more than a page");
    80001572:	00007517          	auipc	a0,0x7
    80001576:	bf650513          	addi	a0,a0,-1034 # 80008168 <etext+0x168>
    8000157a:	fffff097          	auipc	ra,0xfffff
    8000157e:	fe6080e7          	jalr	-26(ra) # 80000560 <panic>

0000000080001582 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001582:	1101                	addi	sp,sp,-32
    80001584:	ec06                	sd	ra,24(sp)
    80001586:	e822                	sd	s0,16(sp)
    80001588:	e426                	sd	s1,8(sp)
    8000158a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000158c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000158e:	00b67d63          	bgeu	a2,a1,800015a8 <uvmdealloc+0x26>
    80001592:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001594:	6785                	lui	a5,0x1
    80001596:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001598:	00f60733          	add	a4,a2,a5
    8000159c:	76fd                	lui	a3,0xfffff
    8000159e:	8f75                	and	a4,a4,a3
    800015a0:	97ae                	add	a5,a5,a1
    800015a2:	8ff5                	and	a5,a5,a3
    800015a4:	00f76863          	bltu	a4,a5,800015b4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800015a8:	8526                	mv	a0,s1
    800015aa:	60e2                	ld	ra,24(sp)
    800015ac:	6442                	ld	s0,16(sp)
    800015ae:	64a2                	ld	s1,8(sp)
    800015b0:	6105                	addi	sp,sp,32
    800015b2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800015b4:	8f99                	sub	a5,a5,a4
    800015b6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800015b8:	4685                	li	a3,1
    800015ba:	0007861b          	sext.w	a2,a5
    800015be:	85ba                	mv	a1,a4
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	e4e080e7          	jalr	-434(ra) # 8000140e <uvmunmap>
    800015c8:	b7c5                	j	800015a8 <uvmdealloc+0x26>

00000000800015ca <uvmalloc>:
  if(newsz < oldsz)
    800015ca:	0ab66b63          	bltu	a2,a1,80001680 <uvmalloc+0xb6>
{
    800015ce:	7139                	addi	sp,sp,-64
    800015d0:	fc06                	sd	ra,56(sp)
    800015d2:	f822                	sd	s0,48(sp)
    800015d4:	ec4e                	sd	s3,24(sp)
    800015d6:	e852                	sd	s4,16(sp)
    800015d8:	e456                	sd	s5,8(sp)
    800015da:	0080                	addi	s0,sp,64
    800015dc:	8aaa                	mv	s5,a0
    800015de:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800015e0:	6785                	lui	a5,0x1
    800015e2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015e4:	95be                	add	a1,a1,a5
    800015e6:	77fd                	lui	a5,0xfffff
    800015e8:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800015ec:	08c9fc63          	bgeu	s3,a2,80001684 <uvmalloc+0xba>
    800015f0:	f426                	sd	s1,40(sp)
    800015f2:	f04a                	sd	s2,32(sp)
    800015f4:	e05a                	sd	s6,0(sp)
    800015f6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015f8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800015fc:	fffff097          	auipc	ra,0xfffff
    80001600:	662080e7          	jalr	1634(ra) # 80000c5e <kalloc>
    80001604:	84aa                	mv	s1,a0
    if(mem == 0){
    80001606:	c915                	beqz	a0,8000163a <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80001608:	6605                	lui	a2,0x1
    8000160a:	4581                	li	a1,0
    8000160c:	00000097          	auipc	ra,0x0
    80001610:	878080e7          	jalr	-1928(ra) # 80000e84 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001614:	875a                	mv	a4,s6
    80001616:	86a6                	mv	a3,s1
    80001618:	6605                	lui	a2,0x1
    8000161a:	85ca                	mv	a1,s2
    8000161c:	8556                	mv	a0,s5
    8000161e:	00000097          	auipc	ra,0x0
    80001622:	c2a080e7          	jalr	-982(ra) # 80001248 <mappages>
    80001626:	ed05                	bnez	a0,8000165e <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001628:	6785                	lui	a5,0x1
    8000162a:	993e                	add	s2,s2,a5
    8000162c:	fd4968e3          	bltu	s2,s4,800015fc <uvmalloc+0x32>
  return newsz;
    80001630:	8552                	mv	a0,s4
    80001632:	74a2                	ld	s1,40(sp)
    80001634:	7902                	ld	s2,32(sp)
    80001636:	6b02                	ld	s6,0(sp)
    80001638:	a821                	j	80001650 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    8000163a:	864e                	mv	a2,s3
    8000163c:	85ca                	mv	a1,s2
    8000163e:	8556                	mv	a0,s5
    80001640:	00000097          	auipc	ra,0x0
    80001644:	f42080e7          	jalr	-190(ra) # 80001582 <uvmdealloc>
      return 0;
    80001648:	4501                	li	a0,0
    8000164a:	74a2                	ld	s1,40(sp)
    8000164c:	7902                	ld	s2,32(sp)
    8000164e:	6b02                	ld	s6,0(sp)
}
    80001650:	70e2                	ld	ra,56(sp)
    80001652:	7442                	ld	s0,48(sp)
    80001654:	69e2                	ld	s3,24(sp)
    80001656:	6a42                	ld	s4,16(sp)
    80001658:	6aa2                	ld	s5,8(sp)
    8000165a:	6121                	addi	sp,sp,64
    8000165c:	8082                	ret
      kfree(mem);
    8000165e:	8526                	mv	a0,s1
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	3ea080e7          	jalr	1002(ra) # 80000a4a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001668:	864e                	mv	a2,s3
    8000166a:	85ca                	mv	a1,s2
    8000166c:	8556                	mv	a0,s5
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	f14080e7          	jalr	-236(ra) # 80001582 <uvmdealloc>
      return 0;
    80001676:	4501                	li	a0,0
    80001678:	74a2                	ld	s1,40(sp)
    8000167a:	7902                	ld	s2,32(sp)
    8000167c:	6b02                	ld	s6,0(sp)
    8000167e:	bfc9                	j	80001650 <uvmalloc+0x86>
    return oldsz;
    80001680:	852e                	mv	a0,a1
}
    80001682:	8082                	ret
  return newsz;
    80001684:	8532                	mv	a0,a2
    80001686:	b7e9                	j	80001650 <uvmalloc+0x86>

0000000080001688 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001688:	7179                	addi	sp,sp,-48
    8000168a:	f406                	sd	ra,40(sp)
    8000168c:	f022                	sd	s0,32(sp)
    8000168e:	ec26                	sd	s1,24(sp)
    80001690:	e84a                	sd	s2,16(sp)
    80001692:	e44e                	sd	s3,8(sp)
    80001694:	e052                	sd	s4,0(sp)
    80001696:	1800                	addi	s0,sp,48
    80001698:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000169a:	84aa                	mv	s1,a0
    8000169c:	6905                	lui	s2,0x1
    8000169e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800016a0:	4985                	li	s3,1
    800016a2:	a829                	j	800016bc <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800016a4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800016a6:	00c79513          	slli	a0,a5,0xc
    800016aa:	00000097          	auipc	ra,0x0
    800016ae:	fde080e7          	jalr	-34(ra) # 80001688 <freewalk>
      pagetable[i] = 0;
    800016b2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800016b6:	04a1                	addi	s1,s1,8
    800016b8:	03248163          	beq	s1,s2,800016da <freewalk+0x52>
    pte_t pte = pagetable[i];
    800016bc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800016be:	00f7f713          	andi	a4,a5,15
    800016c2:	ff3701e3          	beq	a4,s3,800016a4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800016c6:	8b85                	andi	a5,a5,1
    800016c8:	d7fd                	beqz	a5,800016b6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800016ca:	00007517          	auipc	a0,0x7
    800016ce:	abe50513          	addi	a0,a0,-1346 # 80008188 <etext+0x188>
    800016d2:	fffff097          	auipc	ra,0xfffff
    800016d6:	e8e080e7          	jalr	-370(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    800016da:	8552                	mv	a0,s4
    800016dc:	fffff097          	auipc	ra,0xfffff
    800016e0:	36e080e7          	jalr	878(ra) # 80000a4a <kfree>
}
    800016e4:	70a2                	ld	ra,40(sp)
    800016e6:	7402                	ld	s0,32(sp)
    800016e8:	64e2                	ld	s1,24(sp)
    800016ea:	6942                	ld	s2,16(sp)
    800016ec:	69a2                	ld	s3,8(sp)
    800016ee:	6a02                	ld	s4,0(sp)
    800016f0:	6145                	addi	sp,sp,48
    800016f2:	8082                	ret

00000000800016f4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800016f4:	1101                	addi	sp,sp,-32
    800016f6:	ec06                	sd	ra,24(sp)
    800016f8:	e822                	sd	s0,16(sp)
    800016fa:	e426                	sd	s1,8(sp)
    800016fc:	1000                	addi	s0,sp,32
    800016fe:	84aa                	mv	s1,a0
  if(sz > 0)
    80001700:	e999                	bnez	a1,80001716 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001702:	8526                	mv	a0,s1
    80001704:	00000097          	auipc	ra,0x0
    80001708:	f84080e7          	jalr	-124(ra) # 80001688 <freewalk>
}
    8000170c:	60e2                	ld	ra,24(sp)
    8000170e:	6442                	ld	s0,16(sp)
    80001710:	64a2                	ld	s1,8(sp)
    80001712:	6105                	addi	sp,sp,32
    80001714:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001716:	6785                	lui	a5,0x1
    80001718:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000171a:	95be                	add	a1,a1,a5
    8000171c:	4685                	li	a3,1
    8000171e:	00c5d613          	srli	a2,a1,0xc
    80001722:	4581                	li	a1,0
    80001724:	00000097          	auipc	ra,0x0
    80001728:	cea080e7          	jalr	-790(ra) # 8000140e <uvmunmap>
    8000172c:	bfd9                	j	80001702 <uvmfree+0xe>

000000008000172e <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    8000172e:	715d                	addi	sp,sp,-80
    80001730:	e486                	sd	ra,72(sp)
    80001732:	e0a2                	sd	s0,64(sp)
    80001734:	e062                	sd	s8,0(sp)
    80001736:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80001738:	10060163          	beqz	a2,8000183a <uvmcopy+0x10c>
    8000173c:	fc26                	sd	s1,56(sp)
    8000173e:	f84a                	sd	s2,48(sp)
    80001740:	f44e                	sd	s3,40(sp)
    80001742:	f052                	sd	s4,32(sp)
    80001744:	ec56                	sd	s5,24(sp)
    80001746:	e85a                	sd	s6,16(sp)
    80001748:	e45e                	sd	s7,8(sp)
    8000174a:	8b2a                	mv	s6,a0
    8000174c:	8aae                	mv	s5,a1
    8000174e:	8a32                	mv	s4,a2
    80001750:	4901                	li	s2,0
    }
        
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
      goto err;
    }
    acquire(&ref_page_lock);
    80001752:	0000f997          	auipc	s3,0xf
    80001756:	40e98993          	addi	s3,s3,1038 # 80010b60 <ref_page_lock>
    reference_counter[pa/PGSIZE]+=1;
    8000175a:	0000fb97          	auipc	s7,0xf
    8000175e:	43eb8b93          	addi	s7,s7,1086 # 80010b98 <reference_counter>
    80001762:	a0b5                	j	800017ce <uvmcopy+0xa0>
      panic("uvmcopy: pte should exist");
    80001764:	00007517          	auipc	a0,0x7
    80001768:	a3450513          	addi	a0,a0,-1484 # 80008198 <etext+0x198>
    8000176c:	fffff097          	auipc	ra,0xfffff
    80001770:	df4080e7          	jalr	-524(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001774:	00007517          	auipc	a0,0x7
    80001778:	a4450513          	addi	a0,a0,-1468 # 800081b8 <etext+0x1b8>
    8000177c:	fffff097          	auipc	ra,0xfffff
    80001780:	de4080e7          	jalr	-540(ra) # 80000560 <panic>
      *pte&=(~PTE_W);
    80001784:	9bed                	andi	a5,a5,-5
    80001786:	1007e793          	ori	a5,a5,256
    8000178a:	e11c                	sd	a5,0(a0)
      flags&=(~PTE_W);
    8000178c:	3fb77713          	andi	a4,a4,1019
    80001790:	10076713          	ori	a4,a4,256
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80001794:	86a6                	mv	a3,s1
    80001796:	6605                	lui	a2,0x1
    80001798:	85ca                	mv	a1,s2
    8000179a:	8556                	mv	a0,s5
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	aac080e7          	jalr	-1364(ra) # 80001248 <mappages>
    800017a4:	8c2a                	mv	s8,a0
    800017a6:	e939                	bnez	a0,800017fc <uvmcopy+0xce>
    acquire(&ref_page_lock);
    800017a8:	854e                	mv	a0,s3
    800017aa:	fffff097          	auipc	ra,0xfffff
    800017ae:	5de080e7          	jalr	1502(ra) # 80000d88 <acquire>
    reference_counter[pa/PGSIZE]+=1;
    800017b2:	80a9                	srli	s1,s1,0xa
    800017b4:	94de                	add	s1,s1,s7
    800017b6:	409c                	lw	a5,0(s1)
    800017b8:	2785                	addiw	a5,a5,1
    800017ba:	c09c                	sw	a5,0(s1)
    release(&ref_page_lock);
    800017bc:	854e                	mv	a0,s3
    800017be:	fffff097          	auipc	ra,0xfffff
    800017c2:	67e080e7          	jalr	1662(ra) # 80000e3c <release>
  for(i = 0; i < sz; i += PGSIZE){
    800017c6:	6785                	lui	a5,0x1
    800017c8:	993e                	add	s2,s2,a5
    800017ca:	07497063          	bgeu	s2,s4,8000182a <uvmcopy+0xfc>
    if((pte = walk(old, i, 0)) == 0)
    800017ce:	4601                	li	a2,0
    800017d0:	85ca                	mv	a1,s2
    800017d2:	855a                	mv	a0,s6
    800017d4:	00000097          	auipc	ra,0x0
    800017d8:	98c080e7          	jalr	-1652(ra) # 80001160 <walk>
    800017dc:	d541                	beqz	a0,80001764 <uvmcopy+0x36>
    if((*pte & PTE_V) == 0)
    800017de:	611c                	ld	a5,0(a0)
    800017e0:	0017f713          	andi	a4,a5,1
    800017e4:	db41                	beqz	a4,80001774 <uvmcopy+0x46>
    pa = PTE2PA(*pte);
    800017e6:	00a7d493          	srli	s1,a5,0xa
    800017ea:	04b2                	slli	s1,s1,0xc
    flags = PTE_FLAGS(*pte);
    800017ec:	0007871b          	sext.w	a4,a5
    if(!(*pte & PTE_W) == 0){
    800017f0:	0047f693          	andi	a3,a5,4
    800017f4:	fac1                	bnez	a3,80001784 <uvmcopy+0x56>
    flags = PTE_FLAGS(*pte);
    800017f6:	3ff77713          	andi	a4,a4,1023
    800017fa:	bf69                	j	80001794 <uvmcopy+0x66>
    // --------
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800017fc:	4685                	li	a3,1
    800017fe:	00c95613          	srli	a2,s2,0xc
    80001802:	4581                	li	a1,0
    80001804:	8556                	mv	a0,s5
    80001806:	00000097          	auipc	ra,0x0
    8000180a:	c08080e7          	jalr	-1016(ra) # 8000140e <uvmunmap>
  return -1;
    8000180e:	5c7d                	li	s8,-1
    80001810:	74e2                	ld	s1,56(sp)
    80001812:	7942                	ld	s2,48(sp)
    80001814:	79a2                	ld	s3,40(sp)
    80001816:	7a02                	ld	s4,32(sp)
    80001818:	6ae2                	ld	s5,24(sp)
    8000181a:	6b42                	ld	s6,16(sp)
    8000181c:	6ba2                	ld	s7,8(sp)
}
    8000181e:	8562                	mv	a0,s8
    80001820:	60a6                	ld	ra,72(sp)
    80001822:	6406                	ld	s0,64(sp)
    80001824:	6c02                	ld	s8,0(sp)
    80001826:	6161                	addi	sp,sp,80
    80001828:	8082                	ret
    8000182a:	74e2                	ld	s1,56(sp)
    8000182c:	7942                	ld	s2,48(sp)
    8000182e:	79a2                	ld	s3,40(sp)
    80001830:	7a02                	ld	s4,32(sp)
    80001832:	6ae2                	ld	s5,24(sp)
    80001834:	6b42                	ld	s6,16(sp)
    80001836:	6ba2                	ld	s7,8(sp)
    80001838:	b7dd                	j	8000181e <uvmcopy+0xf0>
  return 0;
    8000183a:	4c01                	li	s8,0
    8000183c:	b7cd                	j	8000181e <uvmcopy+0xf0>

000000008000183e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000183e:	1141                	addi	sp,sp,-16
    80001840:	e406                	sd	ra,8(sp)
    80001842:	e022                	sd	s0,0(sp)
    80001844:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001846:	4601                	li	a2,0
    80001848:	00000097          	auipc	ra,0x0
    8000184c:	918080e7          	jalr	-1768(ra) # 80001160 <walk>
  if(pte == 0)
    80001850:	c901                	beqz	a0,80001860 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001852:	611c                	ld	a5,0(a0)
    80001854:	9bbd                	andi	a5,a5,-17
    80001856:	e11c                	sd	a5,0(a0)
}
    80001858:	60a2                	ld	ra,8(sp)
    8000185a:	6402                	ld	s0,0(sp)
    8000185c:	0141                	addi	sp,sp,16
    8000185e:	8082                	ret
    panic("uvmclear");
    80001860:	00007517          	auipc	a0,0x7
    80001864:	97850513          	addi	a0,a0,-1672 # 800081d8 <etext+0x1d8>
    80001868:	fffff097          	auipc	ra,0xfffff
    8000186c:	cf8080e7          	jalr	-776(ra) # 80000560 <panic>

0000000080001870 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001870:	18068463          	beqz	a3,800019f8 <copyout+0x188>
{
    80001874:	7119                	addi	sp,sp,-128
    80001876:	fc86                	sd	ra,120(sp)
    80001878:	f8a2                	sd	s0,112(sp)
    8000187a:	f4a6                	sd	s1,104(sp)
    8000187c:	ecce                	sd	s3,88(sp)
    8000187e:	e8d2                	sd	s4,80(sp)
    80001880:	e4d6                	sd	s5,72(sp)
    80001882:	e0da                	sd	s6,64(sp)
    80001884:	0100                	addi	s0,sp,128
    80001886:	8a2a                	mv	s4,a0
    80001888:	8aae                	mv	s5,a1
    8000188a:	8b32                	mv	s6,a2
    8000188c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000188e:	74fd                	lui	s1,0xfffff
    80001890:	8ced                	and	s1,s1,a1

    if(va0 >= MAXVA || va0%PGSIZE !=0){
    80001892:	57fd                	li	a5,-1
    80001894:	83e9                	srli	a5,a5,0x1a
    80001896:	1697e363          	bltu	a5,s1,800019fc <copyout+0x18c>
    8000189a:	f0ca                	sd	s2,96(sp)
    8000189c:	fc5e                	sd	s7,56(sp)
    8000189e:	f862                	sd	s8,48(sp)
    800018a0:	f466                	sd	s9,40(sp)
    800018a2:	f06a                	sd	s10,32(sp)
    800018a4:	ec6e                	sd	s11,24(sp)
    }
    pte_t*my_pte = walk(pagetable,va0,0);

    //checking validity and permissions of the page
    if(my_pte == 0) return -1;
    if( (*my_pte&PTE_V) == 0 || (*my_pte&PTE_U) == 0 )return -1;
    800018a6:	4dc5                	li	s11,17
        // no memory left kill the process
         return -1;
        // exit(-1);
      }
      
      memmove(new_page,(char*)pa,PGSIZE);
    800018a8:	6c85                	lui	s9,0x1
      uvmunmap(pagetable,PGROUNDUP(va0),1,1); //free physical page as freeing will manage the reference counting
    800018aa:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800018ae:	f8f43423          	sd	a5,-120(s0)
    if(va0 >= MAXVA || va0%PGSIZE !=0){
    800018b2:	5d7d                	li	s10,-1
    800018b4:	01ad5d13          	srli	s10,s10,0x1a
    800018b8:	a09d                	j	8000191e <copyout+0xae>
        release(&ref_page_lock);
    800018ba:	0000f517          	auipc	a0,0xf
    800018be:	2a650513          	addi	a0,a0,678 # 80010b60 <ref_page_lock>
    800018c2:	fffff097          	auipc	ra,0xfffff
    800018c6:	57a080e7          	jalr	1402(ra) # 80000e3c <release>
        return -1;
    800018ca:	557d                	li	a0,-1
    800018cc:	7906                	ld	s2,96(sp)
    800018ce:	7be2                	ld	s7,56(sp)
    800018d0:	7c42                	ld	s8,48(sp)
    800018d2:	7ca2                	ld	s9,40(sp)
    800018d4:	7d02                	ld	s10,32(sp)
    800018d6:	6de2                	ld	s11,24(sp)
    800018d8:	a299                	j	80001a1e <copyout+0x1ae>
        return -1;
      }

    }

    pa0 = walkaddr(pagetable, va0);
    800018da:	85a6                	mv	a1,s1
    800018dc:	8552                	mv	a0,s4
    800018de:	00000097          	auipc	ra,0x0
    800018e2:	928080e7          	jalr	-1752(ra) # 80001206 <walkaddr>
    if(pa0 == 0)
    800018e6:	16050563          	beqz	a0,80001a50 <copyout+0x1e0>
      return -1;
    n = PGSIZE - (dstva - va0);
    800018ea:	01948bb3          	add	s7,s1,s9
    800018ee:	415b8933          	sub	s2,s7,s5
    if(n > len)
    800018f2:	0129f363          	bgeu	s3,s2,800018f8 <copyout+0x88>
    800018f6:	894e                	mv	s2,s3
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800018f8:	409a84b3          	sub	s1,s5,s1
    800018fc:	0009061b          	sext.w	a2,s2
    80001900:	85da                	mv	a1,s6
    80001902:	9526                	add	a0,a0,s1
    80001904:	fffff097          	auipc	ra,0xfffff
    80001908:	5dc080e7          	jalr	1500(ra) # 80000ee0 <memmove>

    len -= n;
    8000190c:	412989b3          	sub	s3,s3,s2
    src += n;
    80001910:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80001912:	0c098b63          	beqz	s3,800019e8 <copyout+0x178>
    if(va0 >= MAXVA || va0%PGSIZE !=0){
    80001916:	0f7d6563          	bltu	s10,s7,80001a00 <copyout+0x190>
    8000191a:	84de                	mv	s1,s7
    8000191c:	8ade                	mv	s5,s7
    pte_t*my_pte = walk(pagetable,va0,0);
    8000191e:	4601                	li	a2,0
    80001920:	85a6                	mv	a1,s1
    80001922:	8552                	mv	a0,s4
    80001924:	00000097          	auipc	ra,0x0
    80001928:	83c080e7          	jalr	-1988(ra) # 80001160 <walk>
    8000192c:	8baa                	mv	s7,a0
    if(my_pte == 0) return -1;
    8000192e:	c16d                	beqz	a0,80001a10 <copyout+0x1a0>
    if( (*my_pte&PTE_V) == 0 || (*my_pte&PTE_U) == 0 )return -1;
    80001930:	00053903          	ld	s2,0(a0)
    80001934:	01197793          	andi	a5,s2,17
    80001938:	0fb79c63          	bne	a5,s11,80001a30 <copyout+0x1c0>
    if(PTE_COW&(*my_pte)){
    8000193c:	10097793          	andi	a5,s2,256
    80001940:	dfc9                	beqz	a5,800018da <copyout+0x6a>
      uint64 pa = PTE2PA(*my_pte);
    80001942:	00a95913          	srli	s2,s2,0xa
    80001946:	0932                	slli	s2,s2,0xc
      acquire(&ref_page_lock);
    80001948:	0000f517          	auipc	a0,0xf
    8000194c:	21850513          	addi	a0,a0,536 # 80010b60 <ref_page_lock>
    80001950:	fffff097          	auipc	ra,0xfffff
    80001954:	438080e7          	jalr	1080(ra) # 80000d88 <acquire>
      if(reference_counter[pa/PGSIZE] <= 0){
    80001958:	00a95793          	srli	a5,s2,0xa
    8000195c:	0000f717          	auipc	a4,0xf
    80001960:	23c70713          	addi	a4,a4,572 # 80010b98 <reference_counter>
    80001964:	97ba                	add	a5,a5,a4
    80001966:	439c                	lw	a5,0(a5)
    80001968:	f4f059e3          	blez	a5,800018ba <copyout+0x4a>
      release(&ref_page_lock);
    8000196c:	0000f517          	auipc	a0,0xf
    80001970:	1f450513          	addi	a0,a0,500 # 80010b60 <ref_page_lock>
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	4c8080e7          	jalr	1224(ra) # 80000e3c <release>
      flags =PTE_FLAGS(*my_pte);
    8000197c:	000bbb83          	ld	s7,0(s7)
      flags&= ~PTE_COW;
    80001980:	2ffbfb93          	andi	s7,s7,767
    80001984:	004beb93          	ori	s7,s7,4
      if( (new_page = kalloc()) == 0 ){
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	2d6080e7          	jalr	726(ra) # 80000c5e <kalloc>
    80001990:	8c2a                	mv	s8,a0
    80001992:	c55d                	beqz	a0,80001a40 <copyout+0x1d0>
      memmove(new_page,(char*)pa,PGSIZE);
    80001994:	8666                	mv	a2,s9
    80001996:	85ca                	mv	a1,s2
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	548080e7          	jalr	1352(ra) # 80000ee0 <memmove>
      uvmunmap(pagetable,PGROUNDUP(va0),1,1); //free physical page as freeing will manage the reference counting
    800019a0:	f8843783          	ld	a5,-120(s0)
    800019a4:	00f485b3          	add	a1,s1,a5
    800019a8:	4685                	li	a3,1
    800019aa:	4605                	li	a2,1
    800019ac:	77fd                	lui	a5,0xfffff
    800019ae:	8dfd                	and	a1,a1,a5
    800019b0:	8552                	mv	a0,s4
    800019b2:	00000097          	auipc	ra,0x0
    800019b6:	a5c080e7          	jalr	-1444(ra) # 8000140e <uvmunmap>
      if(mappages(pagetable, va0, PGSIZE, (uint64)new_page, flags) != 0){
    800019ba:	875e                	mv	a4,s7
    800019bc:	86e2                	mv	a3,s8
    800019be:	8666                	mv	a2,s9
    800019c0:	85a6                	mv	a1,s1
    800019c2:	8552                	mv	a0,s4
    800019c4:	00000097          	auipc	ra,0x0
    800019c8:	884080e7          	jalr	-1916(ra) # 80001248 <mappages>
    800019cc:	d519                	beqz	a0,800018da <copyout+0x6a>
        kfree(new_page);  // Clean up new_page if mapping fails
    800019ce:	8562                	mv	a0,s8
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	07a080e7          	jalr	122(ra) # 80000a4a <kfree>
        return -1;
    800019d8:	557d                	li	a0,-1
    800019da:	7906                	ld	s2,96(sp)
    800019dc:	7be2                	ld	s7,56(sp)
    800019de:	7c42                	ld	s8,48(sp)
    800019e0:	7ca2                	ld	s9,40(sp)
    800019e2:	7d02                	ld	s10,32(sp)
    800019e4:	6de2                	ld	s11,24(sp)
    800019e6:	a825                	j	80001a1e <copyout+0x1ae>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800019e8:	4501                	li	a0,0
    800019ea:	7906                	ld	s2,96(sp)
    800019ec:	7be2                	ld	s7,56(sp)
    800019ee:	7c42                	ld	s8,48(sp)
    800019f0:	7ca2                	ld	s9,40(sp)
    800019f2:	7d02                	ld	s10,32(sp)
    800019f4:	6de2                	ld	s11,24(sp)
    800019f6:	a025                	j	80001a1e <copyout+0x1ae>
    800019f8:	4501                	li	a0,0
}
    800019fa:	8082                	ret
      return -1;
    800019fc:	557d                	li	a0,-1
    800019fe:	a005                	j	80001a1e <copyout+0x1ae>
    80001a00:	557d                	li	a0,-1
    80001a02:	7906                	ld	s2,96(sp)
    80001a04:	7be2                	ld	s7,56(sp)
    80001a06:	7c42                	ld	s8,48(sp)
    80001a08:	7ca2                	ld	s9,40(sp)
    80001a0a:	7d02                	ld	s10,32(sp)
    80001a0c:	6de2                	ld	s11,24(sp)
    80001a0e:	a801                	j	80001a1e <copyout+0x1ae>
    if(my_pte == 0) return -1;
    80001a10:	557d                	li	a0,-1
    80001a12:	7906                	ld	s2,96(sp)
    80001a14:	7be2                	ld	s7,56(sp)
    80001a16:	7c42                	ld	s8,48(sp)
    80001a18:	7ca2                	ld	s9,40(sp)
    80001a1a:	7d02                	ld	s10,32(sp)
    80001a1c:	6de2                	ld	s11,24(sp)
}
    80001a1e:	70e6                	ld	ra,120(sp)
    80001a20:	7446                	ld	s0,112(sp)
    80001a22:	74a6                	ld	s1,104(sp)
    80001a24:	69e6                	ld	s3,88(sp)
    80001a26:	6a46                	ld	s4,80(sp)
    80001a28:	6aa6                	ld	s5,72(sp)
    80001a2a:	6b06                	ld	s6,64(sp)
    80001a2c:	6109                	addi	sp,sp,128
    80001a2e:	8082                	ret
    if( (*my_pte&PTE_V) == 0 || (*my_pte&PTE_U) == 0 )return -1;
    80001a30:	557d                	li	a0,-1
    80001a32:	7906                	ld	s2,96(sp)
    80001a34:	7be2                	ld	s7,56(sp)
    80001a36:	7c42                	ld	s8,48(sp)
    80001a38:	7ca2                	ld	s9,40(sp)
    80001a3a:	7d02                	ld	s10,32(sp)
    80001a3c:	6de2                	ld	s11,24(sp)
    80001a3e:	b7c5                	j	80001a1e <copyout+0x1ae>
         return -1;
    80001a40:	557d                	li	a0,-1
    80001a42:	7906                	ld	s2,96(sp)
    80001a44:	7be2                	ld	s7,56(sp)
    80001a46:	7c42                	ld	s8,48(sp)
    80001a48:	7ca2                	ld	s9,40(sp)
    80001a4a:	7d02                	ld	s10,32(sp)
    80001a4c:	6de2                	ld	s11,24(sp)
    80001a4e:	bfc1                	j	80001a1e <copyout+0x1ae>
      return -1;
    80001a50:	557d                	li	a0,-1
    80001a52:	7906                	ld	s2,96(sp)
    80001a54:	7be2                	ld	s7,56(sp)
    80001a56:	7c42                	ld	s8,48(sp)
    80001a58:	7ca2                	ld	s9,40(sp)
    80001a5a:	7d02                	ld	s10,32(sp)
    80001a5c:	6de2                	ld	s11,24(sp)
    80001a5e:	b7c1                	j	80001a1e <copyout+0x1ae>

0000000080001a60 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001a60:	caa5                	beqz	a3,80001ad0 <copyin+0x70>
{
    80001a62:	715d                	addi	sp,sp,-80
    80001a64:	e486                	sd	ra,72(sp)
    80001a66:	e0a2                	sd	s0,64(sp)
    80001a68:	fc26                	sd	s1,56(sp)
    80001a6a:	f84a                	sd	s2,48(sp)
    80001a6c:	f44e                	sd	s3,40(sp)
    80001a6e:	f052                	sd	s4,32(sp)
    80001a70:	ec56                	sd	s5,24(sp)
    80001a72:	e85a                	sd	s6,16(sp)
    80001a74:	e45e                	sd	s7,8(sp)
    80001a76:	e062                	sd	s8,0(sp)
    80001a78:	0880                	addi	s0,sp,80
    80001a7a:	8b2a                	mv	s6,a0
    80001a7c:	8a2e                	mv	s4,a1
    80001a7e:	8c32                	mv	s8,a2
    80001a80:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001a82:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a84:	6a85                	lui	s5,0x1
    80001a86:	a01d                	j	80001aac <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001a88:	018505b3          	add	a1,a0,s8
    80001a8c:	0004861b          	sext.w	a2,s1
    80001a90:	412585b3          	sub	a1,a1,s2
    80001a94:	8552                	mv	a0,s4
    80001a96:	fffff097          	auipc	ra,0xfffff
    80001a9a:	44a080e7          	jalr	1098(ra) # 80000ee0 <memmove>

    len -= n;
    80001a9e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001aa2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001aa4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001aa8:	02098263          	beqz	s3,80001acc <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001aac:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001ab0:	85ca                	mv	a1,s2
    80001ab2:	855a                	mv	a0,s6
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	752080e7          	jalr	1874(ra) # 80001206 <walkaddr>
    if(pa0 == 0)
    80001abc:	cd01                	beqz	a0,80001ad4 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001abe:	418904b3          	sub	s1,s2,s8
    80001ac2:	94d6                	add	s1,s1,s5
    if(n > len)
    80001ac4:	fc99f2e3          	bgeu	s3,s1,80001a88 <copyin+0x28>
    80001ac8:	84ce                	mv	s1,s3
    80001aca:	bf7d                	j	80001a88 <copyin+0x28>
  }
  return 0;
    80001acc:	4501                	li	a0,0
    80001ace:	a021                	j	80001ad6 <copyin+0x76>
    80001ad0:	4501                	li	a0,0
}
    80001ad2:	8082                	ret
      return -1;
    80001ad4:	557d                	li	a0,-1
}
    80001ad6:	60a6                	ld	ra,72(sp)
    80001ad8:	6406                	ld	s0,64(sp)
    80001ada:	74e2                	ld	s1,56(sp)
    80001adc:	7942                	ld	s2,48(sp)
    80001ade:	79a2                	ld	s3,40(sp)
    80001ae0:	7a02                	ld	s4,32(sp)
    80001ae2:	6ae2                	ld	s5,24(sp)
    80001ae4:	6b42                	ld	s6,16(sp)
    80001ae6:	6ba2                	ld	s7,8(sp)
    80001ae8:	6c02                	ld	s8,0(sp)
    80001aea:	6161                	addi	sp,sp,80
    80001aec:	8082                	ret

0000000080001aee <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001aee:	cacd                	beqz	a3,80001ba0 <copyinstr+0xb2>
{
    80001af0:	715d                	addi	sp,sp,-80
    80001af2:	e486                	sd	ra,72(sp)
    80001af4:	e0a2                	sd	s0,64(sp)
    80001af6:	fc26                	sd	s1,56(sp)
    80001af8:	f84a                	sd	s2,48(sp)
    80001afa:	f44e                	sd	s3,40(sp)
    80001afc:	f052                	sd	s4,32(sp)
    80001afe:	ec56                	sd	s5,24(sp)
    80001b00:	e85a                	sd	s6,16(sp)
    80001b02:	e45e                	sd	s7,8(sp)
    80001b04:	0880                	addi	s0,sp,80
    80001b06:	8a2a                	mv	s4,a0
    80001b08:	8b2e                	mv	s6,a1
    80001b0a:	8bb2                	mv	s7,a2
    80001b0c:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001b0e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001b10:	6985                	lui	s3,0x1
    80001b12:	a825                	j	80001b4a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001b14:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7fdbce58>
    80001b18:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001b1a:	37fd                	addiw	a5,a5,-1
    80001b1c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001b20:	60a6                	ld	ra,72(sp)
    80001b22:	6406                	ld	s0,64(sp)
    80001b24:	74e2                	ld	s1,56(sp)
    80001b26:	7942                	ld	s2,48(sp)
    80001b28:	79a2                	ld	s3,40(sp)
    80001b2a:	7a02                	ld	s4,32(sp)
    80001b2c:	6ae2                	ld	s5,24(sp)
    80001b2e:	6b42                	ld	s6,16(sp)
    80001b30:	6ba2                	ld	s7,8(sp)
    80001b32:	6161                	addi	sp,sp,80
    80001b34:	8082                	ret
    80001b36:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001b3a:	9742                	add	a4,a4,a6
      --max;
    80001b3c:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001b40:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001b44:	04e58663          	beq	a1,a4,80001b90 <copyinstr+0xa2>
{
    80001b48:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001b4a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001b4e:	85a6                	mv	a1,s1
    80001b50:	8552                	mv	a0,s4
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	6b4080e7          	jalr	1716(ra) # 80001206 <walkaddr>
    if(pa0 == 0)
    80001b5a:	cd0d                	beqz	a0,80001b94 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80001b5c:	417486b3          	sub	a3,s1,s7
    80001b60:	96ce                	add	a3,a3,s3
    if(n > max)
    80001b62:	00d97363          	bgeu	s2,a3,80001b68 <copyinstr+0x7a>
    80001b66:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001b68:	955e                	add	a0,a0,s7
    80001b6a:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001b6c:	c695                	beqz	a3,80001b98 <copyinstr+0xaa>
    80001b6e:	87da                	mv	a5,s6
    80001b70:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001b72:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001b76:	96da                	add	a3,a3,s6
    80001b78:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001b7a:	00f60733          	add	a4,a2,a5
    80001b7e:	00074703          	lbu	a4,0(a4)
    80001b82:	db49                	beqz	a4,80001b14 <copyinstr+0x26>
        *dst = *p;
    80001b84:	00e78023          	sb	a4,0(a5)
      dst++;
    80001b88:	0785                	addi	a5,a5,1
    while(n > 0){
    80001b8a:	fed797e3          	bne	a5,a3,80001b78 <copyinstr+0x8a>
    80001b8e:	b765                	j	80001b36 <copyinstr+0x48>
    80001b90:	4781                	li	a5,0
    80001b92:	b761                	j	80001b1a <copyinstr+0x2c>
      return -1;
    80001b94:	557d                	li	a0,-1
    80001b96:	b769                	j	80001b20 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001b98:	6b85                	lui	s7,0x1
    80001b9a:	9ba6                	add	s7,s7,s1
    80001b9c:	87da                	mv	a5,s6
    80001b9e:	b76d                	j	80001b48 <copyinstr+0x5a>
  int got_null = 0;
    80001ba0:	4781                	li	a5,0
  if(got_null){
    80001ba2:	37fd                	addiw	a5,a5,-1
    80001ba4:	0007851b          	sext.w	a0,a5
}
    80001ba8:	8082                	ret

0000000080001baa <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80001baa:	7139                	addi	sp,sp,-64
    80001bac:	fc06                	sd	ra,56(sp)
    80001bae:	f822                	sd	s0,48(sp)
    80001bb0:	f426                	sd	s1,40(sp)
    80001bb2:	f04a                	sd	s2,32(sp)
    80001bb4:	ec4e                	sd	s3,24(sp)
    80001bb6:	e852                	sd	s4,16(sp)
    80001bb8:	e456                	sd	s5,8(sp)
    80001bba:	e05a                	sd	s6,0(sp)
    80001bbc:	0080                	addi	s0,sp,64
    80001bbe:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001bc0:	0022f497          	auipc	s1,0x22f
    80001bc4:	40848493          	addi	s1,s1,1032 # 80230fc8 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001bc8:	8b26                	mv	s6,s1
    80001bca:	00a36937          	lui	s2,0xa36
    80001bce:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001bd2:	0932                	slli	s2,s2,0xc
    80001bd4:	46d90913          	addi	s2,s2,1133
    80001bd8:	0936                	slli	s2,s2,0xd
    80001bda:	df590913          	addi	s2,s2,-523
    80001bde:	093a                	slli	s2,s2,0xe
    80001be0:	6cf90913          	addi	s2,s2,1743
    80001be4:	040009b7          	lui	s3,0x4000
    80001be8:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001bea:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001bec:	00235a97          	auipc	s5,0x235
    80001bf0:	1dca8a93          	addi	s5,s5,476 # 80236dc8 <tickslock>
    char *pa = kalloc();
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	06a080e7          	jalr	106(ra) # 80000c5e <kalloc>
    80001bfc:	862a                	mv	a2,a0
    if (pa == 0)
    80001bfe:	c121                	beqz	a0,80001c3e <proc_mapstacks+0x94>
    uint64 va = KSTACK((int)(p - proc));
    80001c00:	416485b3          	sub	a1,s1,s6
    80001c04:	858d                	srai	a1,a1,0x3
    80001c06:	032585b3          	mul	a1,a1,s2
    80001c0a:	2585                	addiw	a1,a1,1
    80001c0c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001c10:	4719                	li	a4,6
    80001c12:	6685                	lui	a3,0x1
    80001c14:	40b985b3          	sub	a1,s3,a1
    80001c18:	8552                	mv	a0,s4
    80001c1a:	fffff097          	auipc	ra,0xfffff
    80001c1e:	6ce080e7          	jalr	1742(ra) # 800012e8 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001c22:	17848493          	addi	s1,s1,376
    80001c26:	fd5497e3          	bne	s1,s5,80001bf4 <proc_mapstacks+0x4a>
  }
}
    80001c2a:	70e2                	ld	ra,56(sp)
    80001c2c:	7442                	ld	s0,48(sp)
    80001c2e:	74a2                	ld	s1,40(sp)
    80001c30:	7902                	ld	s2,32(sp)
    80001c32:	69e2                	ld	s3,24(sp)
    80001c34:	6a42                	ld	s4,16(sp)
    80001c36:	6aa2                	ld	s5,8(sp)
    80001c38:	6b02                	ld	s6,0(sp)
    80001c3a:	6121                	addi	sp,sp,64
    80001c3c:	8082                	ret
      panic("kalloc");
    80001c3e:	00006517          	auipc	a0,0x6
    80001c42:	5aa50513          	addi	a0,a0,1450 # 800081e8 <etext+0x1e8>
    80001c46:	fffff097          	auipc	ra,0xfffff
    80001c4a:	91a080e7          	jalr	-1766(ra) # 80000560 <panic>

0000000080001c4e <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001c4e:	7139                	addi	sp,sp,-64
    80001c50:	fc06                	sd	ra,56(sp)
    80001c52:	f822                	sd	s0,48(sp)
    80001c54:	f426                	sd	s1,40(sp)
    80001c56:	f04a                	sd	s2,32(sp)
    80001c58:	ec4e                	sd	s3,24(sp)
    80001c5a:	e852                	sd	s4,16(sp)
    80001c5c:	e456                	sd	s5,8(sp)
    80001c5e:	e05a                	sd	s6,0(sp)
    80001c60:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001c62:	00006597          	auipc	a1,0x6
    80001c66:	58e58593          	addi	a1,a1,1422 # 800081f0 <etext+0x1f0>
    80001c6a:	0022f517          	auipc	a0,0x22f
    80001c6e:	f2e50513          	addi	a0,a0,-210 # 80230b98 <pid_lock>
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	086080e7          	jalr	134(ra) # 80000cf8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001c7a:	00006597          	auipc	a1,0x6
    80001c7e:	57e58593          	addi	a1,a1,1406 # 800081f8 <etext+0x1f8>
    80001c82:	0022f517          	auipc	a0,0x22f
    80001c86:	f2e50513          	addi	a0,a0,-210 # 80230bb0 <wait_lock>
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	06e080e7          	jalr	110(ra) # 80000cf8 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001c92:	0022f497          	auipc	s1,0x22f
    80001c96:	33648493          	addi	s1,s1,822 # 80230fc8 <proc>
  {
    initlock(&p->lock, "proc");
    80001c9a:	00006b17          	auipc	s6,0x6
    80001c9e:	56eb0b13          	addi	s6,s6,1390 # 80008208 <etext+0x208>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001ca2:	8aa6                	mv	s5,s1
    80001ca4:	00a36937          	lui	s2,0xa36
    80001ca8:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001cac:	0932                	slli	s2,s2,0xc
    80001cae:	46d90913          	addi	s2,s2,1133
    80001cb2:	0936                	slli	s2,s2,0xd
    80001cb4:	df590913          	addi	s2,s2,-523
    80001cb8:	093a                	slli	s2,s2,0xe
    80001cba:	6cf90913          	addi	s2,s2,1743
    80001cbe:	040009b7          	lui	s3,0x4000
    80001cc2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001cc4:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001cc6:	00235a17          	auipc	s4,0x235
    80001cca:	102a0a13          	addi	s4,s4,258 # 80236dc8 <tickslock>
    initlock(&p->lock, "proc");
    80001cce:	85da                	mv	a1,s6
    80001cd0:	8526                	mv	a0,s1
    80001cd2:	fffff097          	auipc	ra,0xfffff
    80001cd6:	026080e7          	jalr	38(ra) # 80000cf8 <initlock>
    p->state = UNUSED;
    80001cda:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001cde:	415487b3          	sub	a5,s1,s5
    80001ce2:	878d                	srai	a5,a5,0x3
    80001ce4:	032787b3          	mul	a5,a5,s2
    80001ce8:	2785                	addiw	a5,a5,1
    80001cea:	00d7979b          	slliw	a5,a5,0xd
    80001cee:	40f987b3          	sub	a5,s3,a5
    80001cf2:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001cf4:	17848493          	addi	s1,s1,376
    80001cf8:	fd449be3          	bne	s1,s4,80001cce <procinit+0x80>
  }
}
    80001cfc:	70e2                	ld	ra,56(sp)
    80001cfe:	7442                	ld	s0,48(sp)
    80001d00:	74a2                	ld	s1,40(sp)
    80001d02:	7902                	ld	s2,32(sp)
    80001d04:	69e2                	ld	s3,24(sp)
    80001d06:	6a42                	ld	s4,16(sp)
    80001d08:	6aa2                	ld	s5,8(sp)
    80001d0a:	6b02                	ld	s6,0(sp)
    80001d0c:	6121                	addi	sp,sp,64
    80001d0e:	8082                	ret

0000000080001d10 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001d10:	1141                	addi	sp,sp,-16
    80001d12:	e422                	sd	s0,8(sp)
    80001d14:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d16:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001d18:	2501                	sext.w	a0,a0
    80001d1a:	6422                	ld	s0,8(sp)
    80001d1c:	0141                	addi	sp,sp,16
    80001d1e:	8082                	ret

0000000080001d20 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001d20:	1141                	addi	sp,sp,-16
    80001d22:	e422                	sd	s0,8(sp)
    80001d24:	0800                	addi	s0,sp,16
    80001d26:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001d28:	2781                	sext.w	a5,a5
    80001d2a:	079e                	slli	a5,a5,0x7
  return c;
}
    80001d2c:	0022f517          	auipc	a0,0x22f
    80001d30:	e9c50513          	addi	a0,a0,-356 # 80230bc8 <cpus>
    80001d34:	953e                	add	a0,a0,a5
    80001d36:	6422                	ld	s0,8(sp)
    80001d38:	0141                	addi	sp,sp,16
    80001d3a:	8082                	ret

0000000080001d3c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001d3c:	1101                	addi	sp,sp,-32
    80001d3e:	ec06                	sd	ra,24(sp)
    80001d40:	e822                	sd	s0,16(sp)
    80001d42:	e426                	sd	s1,8(sp)
    80001d44:	1000                	addi	s0,sp,32
  push_off();
    80001d46:	fffff097          	auipc	ra,0xfffff
    80001d4a:	ff6080e7          	jalr	-10(ra) # 80000d3c <push_off>
    80001d4e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001d50:	2781                	sext.w	a5,a5
    80001d52:	079e                	slli	a5,a5,0x7
    80001d54:	0022f717          	auipc	a4,0x22f
    80001d58:	e4470713          	addi	a4,a4,-444 # 80230b98 <pid_lock>
    80001d5c:	97ba                	add	a5,a5,a4
    80001d5e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	07c080e7          	jalr	124(ra) # 80000ddc <pop_off>
  return p;
}
    80001d68:	8526                	mv	a0,s1
    80001d6a:	60e2                	ld	ra,24(sp)
    80001d6c:	6442                	ld	s0,16(sp)
    80001d6e:	64a2                	ld	s1,8(sp)
    80001d70:	6105                	addi	sp,sp,32
    80001d72:	8082                	ret

0000000080001d74 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001d74:	1141                	addi	sp,sp,-16
    80001d76:	e406                	sd	ra,8(sp)
    80001d78:	e022                	sd	s0,0(sp)
    80001d7a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	fc0080e7          	jalr	-64(ra) # 80001d3c <myproc>
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	0b8080e7          	jalr	184(ra) # 80000e3c <release>

  if (first)
    80001d8c:	00007797          	auipc	a5,0x7
    80001d90:	b047a783          	lw	a5,-1276(a5) # 80008890 <first.1>
    80001d94:	eb89                	bnez	a5,80001da6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001d96:	00001097          	auipc	ra,0x1
    80001d9a:	e8c080e7          	jalr	-372(ra) # 80002c22 <usertrapret>
}
    80001d9e:	60a2                	ld	ra,8(sp)
    80001da0:	6402                	ld	s0,0(sp)
    80001da2:	0141                	addi	sp,sp,16
    80001da4:	8082                	ret
    first = 0;
    80001da6:	00007797          	auipc	a5,0x7
    80001daa:	ae07a523          	sw	zero,-1302(a5) # 80008890 <first.1>
    fsinit(ROOTDEV);
    80001dae:	4505                	li	a0,1
    80001db0:	00002097          	auipc	ra,0x2
    80001db4:	e3c080e7          	jalr	-452(ra) # 80003bec <fsinit>
    80001db8:	bff9                	j	80001d96 <forkret+0x22>

0000000080001dba <allocpid>:
{
    80001dba:	1101                	addi	sp,sp,-32
    80001dbc:	ec06                	sd	ra,24(sp)
    80001dbe:	e822                	sd	s0,16(sp)
    80001dc0:	e426                	sd	s1,8(sp)
    80001dc2:	e04a                	sd	s2,0(sp)
    80001dc4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001dc6:	0022f917          	auipc	s2,0x22f
    80001dca:	dd290913          	addi	s2,s2,-558 # 80230b98 <pid_lock>
    80001dce:	854a                	mv	a0,s2
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	fb8080e7          	jalr	-72(ra) # 80000d88 <acquire>
  pid = nextpid;
    80001dd8:	00007797          	auipc	a5,0x7
    80001ddc:	abc78793          	addi	a5,a5,-1348 # 80008894 <nextpid>
    80001de0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001de2:	0014871b          	addiw	a4,s1,1
    80001de6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001de8:	854a                	mv	a0,s2
    80001dea:	fffff097          	auipc	ra,0xfffff
    80001dee:	052080e7          	jalr	82(ra) # 80000e3c <release>
}
    80001df2:	8526                	mv	a0,s1
    80001df4:	60e2                	ld	ra,24(sp)
    80001df6:	6442                	ld	s0,16(sp)
    80001df8:	64a2                	ld	s1,8(sp)
    80001dfa:	6902                	ld	s2,0(sp)
    80001dfc:	6105                	addi	sp,sp,32
    80001dfe:	8082                	ret

0000000080001e00 <proc_pagetable>:
{
    80001e00:	1101                	addi	sp,sp,-32
    80001e02:	ec06                	sd	ra,24(sp)
    80001e04:	e822                	sd	s0,16(sp)
    80001e06:	e426                	sd	s1,8(sp)
    80001e08:	e04a                	sd	s2,0(sp)
    80001e0a:	1000                	addi	s0,sp,32
    80001e0c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001e0e:	fffff097          	auipc	ra,0xfffff
    80001e12:	6d4080e7          	jalr	1748(ra) # 800014e2 <uvmcreate>
    80001e16:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001e18:	c121                	beqz	a0,80001e58 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001e1a:	4729                	li	a4,10
    80001e1c:	00005697          	auipc	a3,0x5
    80001e20:	1e468693          	addi	a3,a3,484 # 80007000 <_trampoline>
    80001e24:	6605                	lui	a2,0x1
    80001e26:	040005b7          	lui	a1,0x4000
    80001e2a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e2c:	05b2                	slli	a1,a1,0xc
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	41a080e7          	jalr	1050(ra) # 80001248 <mappages>
    80001e36:	02054863          	bltz	a0,80001e66 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001e3a:	4719                	li	a4,6
    80001e3c:	05893683          	ld	a3,88(s2)
    80001e40:	6605                	lui	a2,0x1
    80001e42:	020005b7          	lui	a1,0x2000
    80001e46:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e48:	05b6                	slli	a1,a1,0xd
    80001e4a:	8526                	mv	a0,s1
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	3fc080e7          	jalr	1020(ra) # 80001248 <mappages>
    80001e54:	02054163          	bltz	a0,80001e76 <proc_pagetable+0x76>
}
    80001e58:	8526                	mv	a0,s1
    80001e5a:	60e2                	ld	ra,24(sp)
    80001e5c:	6442                	ld	s0,16(sp)
    80001e5e:	64a2                	ld	s1,8(sp)
    80001e60:	6902                	ld	s2,0(sp)
    80001e62:	6105                	addi	sp,sp,32
    80001e64:	8082                	ret
    uvmfree(pagetable, 0);
    80001e66:	4581                	li	a1,0
    80001e68:	8526                	mv	a0,s1
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	88a080e7          	jalr	-1910(ra) # 800016f4 <uvmfree>
    return 0;
    80001e72:	4481                	li	s1,0
    80001e74:	b7d5                	j	80001e58 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e76:	4681                	li	a3,0
    80001e78:	4605                	li	a2,1
    80001e7a:	040005b7          	lui	a1,0x4000
    80001e7e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e80:	05b2                	slli	a1,a1,0xc
    80001e82:	8526                	mv	a0,s1
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	58a080e7          	jalr	1418(ra) # 8000140e <uvmunmap>
    uvmfree(pagetable, 0);
    80001e8c:	4581                	li	a1,0
    80001e8e:	8526                	mv	a0,s1
    80001e90:	00000097          	auipc	ra,0x0
    80001e94:	864080e7          	jalr	-1948(ra) # 800016f4 <uvmfree>
    return 0;
    80001e98:	4481                	li	s1,0
    80001e9a:	bf7d                	j	80001e58 <proc_pagetable+0x58>

0000000080001e9c <proc_freepagetable>:
{
    80001e9c:	1101                	addi	sp,sp,-32
    80001e9e:	ec06                	sd	ra,24(sp)
    80001ea0:	e822                	sd	s0,16(sp)
    80001ea2:	e426                	sd	s1,8(sp)
    80001ea4:	e04a                	sd	s2,0(sp)
    80001ea6:	1000                	addi	s0,sp,32
    80001ea8:	84aa                	mv	s1,a0
    80001eaa:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001eac:	4681                	li	a3,0
    80001eae:	4605                	li	a2,1
    80001eb0:	040005b7          	lui	a1,0x4000
    80001eb4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001eb6:	05b2                	slli	a1,a1,0xc
    80001eb8:	fffff097          	auipc	ra,0xfffff
    80001ebc:	556080e7          	jalr	1366(ra) # 8000140e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ec0:	4681                	li	a3,0
    80001ec2:	4605                	li	a2,1
    80001ec4:	020005b7          	lui	a1,0x2000
    80001ec8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001eca:	05b6                	slli	a1,a1,0xd
    80001ecc:	8526                	mv	a0,s1
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	540080e7          	jalr	1344(ra) # 8000140e <uvmunmap>
  uvmfree(pagetable, sz);
    80001ed6:	85ca                	mv	a1,s2
    80001ed8:	8526                	mv	a0,s1
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	81a080e7          	jalr	-2022(ra) # 800016f4 <uvmfree>
}
    80001ee2:	60e2                	ld	ra,24(sp)
    80001ee4:	6442                	ld	s0,16(sp)
    80001ee6:	64a2                	ld	s1,8(sp)
    80001ee8:	6902                	ld	s2,0(sp)
    80001eea:	6105                	addi	sp,sp,32
    80001eec:	8082                	ret

0000000080001eee <freeproc>:
{
    80001eee:	1101                	addi	sp,sp,-32
    80001ef0:	ec06                	sd	ra,24(sp)
    80001ef2:	e822                	sd	s0,16(sp)
    80001ef4:	e426                	sd	s1,8(sp)
    80001ef6:	1000                	addi	s0,sp,32
    80001ef8:	84aa                	mv	s1,a0
  printf("Process %d had %d page faults\n", p->pid, p->pagefaultcount);
    80001efa:	17452603          	lw	a2,372(a0)
    80001efe:	590c                	lw	a1,48(a0)
    80001f00:	00006517          	auipc	a0,0x6
    80001f04:	31050513          	addi	a0,a0,784 # 80008210 <etext+0x210>
    80001f08:	ffffe097          	auipc	ra,0xffffe
    80001f0c:	6a2080e7          	jalr	1698(ra) # 800005aa <printf>
  if (p->trapframe)
    80001f10:	6ca8                	ld	a0,88(s1)
    80001f12:	c509                	beqz	a0,80001f1c <freeproc+0x2e>
    kfree((void *)p->trapframe);
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	b36080e7          	jalr	-1226(ra) # 80000a4a <kfree>
  p->trapframe = 0;
    80001f1c:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001f20:	68a8                	ld	a0,80(s1)
    80001f22:	c511                	beqz	a0,80001f2e <freeproc+0x40>
    proc_freepagetable(p->pagetable, p->sz);
    80001f24:	64ac                	ld	a1,72(s1)
    80001f26:	00000097          	auipc	ra,0x0
    80001f2a:	f76080e7          	jalr	-138(ra) # 80001e9c <proc_freepagetable>
  p->pagetable = 0;
    80001f2e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001f32:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001f36:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001f3a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001f3e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001f42:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001f46:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001f4a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001f4e:	0004ac23          	sw	zero,24(s1)
}
    80001f52:	60e2                	ld	ra,24(sp)
    80001f54:	6442                	ld	s0,16(sp)
    80001f56:	64a2                	ld	s1,8(sp)
    80001f58:	6105                	addi	sp,sp,32
    80001f5a:	8082                	ret

0000000080001f5c <allocproc>:
{
    80001f5c:	1101                	addi	sp,sp,-32
    80001f5e:	ec06                	sd	ra,24(sp)
    80001f60:	e822                	sd	s0,16(sp)
    80001f62:	e426                	sd	s1,8(sp)
    80001f64:	e04a                	sd	s2,0(sp)
    80001f66:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001f68:	0022f497          	auipc	s1,0x22f
    80001f6c:	06048493          	addi	s1,s1,96 # 80230fc8 <proc>
    80001f70:	00235917          	auipc	s2,0x235
    80001f74:	e5890913          	addi	s2,s2,-424 # 80236dc8 <tickslock>
    acquire(&p->lock);
    80001f78:	8526                	mv	a0,s1
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	e0e080e7          	jalr	-498(ra) # 80000d88 <acquire>
    if (p->state == UNUSED)
    80001f82:	4c9c                	lw	a5,24(s1)
    80001f84:	cf81                	beqz	a5,80001f9c <allocproc+0x40>
      release(&p->lock);
    80001f86:	8526                	mv	a0,s1
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	eb4080e7          	jalr	-332(ra) # 80000e3c <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001f90:	17848493          	addi	s1,s1,376
    80001f94:	ff2492e3          	bne	s1,s2,80001f78 <allocproc+0x1c>
  return 0;
    80001f98:	4481                	li	s1,0
    80001f9a:	a0ad                	j	80002004 <allocproc+0xa8>
  p->pid = allocpid();
    80001f9c:	00000097          	auipc	ra,0x0
    80001fa0:	e1e080e7          	jalr	-482(ra) # 80001dba <allocpid>
    80001fa4:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001fa6:	4785                	li	a5,1
    80001fa8:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	cb4080e7          	jalr	-844(ra) # 80000c5e <kalloc>
    80001fb2:	892a                	mv	s2,a0
    80001fb4:	eca8                	sd	a0,88(s1)
    80001fb6:	cd31                	beqz	a0,80002012 <allocproc+0xb6>
  p->pagetable = proc_pagetable(p);
    80001fb8:	8526                	mv	a0,s1
    80001fba:	00000097          	auipc	ra,0x0
    80001fbe:	e46080e7          	jalr	-442(ra) # 80001e00 <proc_pagetable>
    80001fc2:	892a                	mv	s2,a0
    80001fc4:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001fc6:	c135                	beqz	a0,8000202a <allocproc+0xce>
  memset(&p->context, 0, sizeof(p->context));
    80001fc8:	07000613          	li	a2,112
    80001fcc:	4581                	li	a1,0
    80001fce:	06048513          	addi	a0,s1,96
    80001fd2:	fffff097          	auipc	ra,0xfffff
    80001fd6:	eb2080e7          	jalr	-334(ra) # 80000e84 <memset>
  p->context.ra = (uint64)forkret;
    80001fda:	00000797          	auipc	a5,0x0
    80001fde:	d9a78793          	addi	a5,a5,-614 # 80001d74 <forkret>
    80001fe2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001fe4:	60bc                	ld	a5,64(s1)
    80001fe6:	6705                	lui	a4,0x1
    80001fe8:	97ba                	add	a5,a5,a4
    80001fea:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001fec:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80001ff0:	1604a823          	sw	zero,368(s1)
  p->ctime = ticks;
    80001ff4:	00007797          	auipc	a5,0x7
    80001ff8:	91c7a783          	lw	a5,-1764(a5) # 80008910 <ticks>
    80001ffc:	16f4a623          	sw	a5,364(s1)
  p->pagefaultcount =0;
    80002000:	1604aa23          	sw	zero,372(s1)
}
    80002004:	8526                	mv	a0,s1
    80002006:	60e2                	ld	ra,24(sp)
    80002008:	6442                	ld	s0,16(sp)
    8000200a:	64a2                	ld	s1,8(sp)
    8000200c:	6902                	ld	s2,0(sp)
    8000200e:	6105                	addi	sp,sp,32
    80002010:	8082                	ret
    freeproc(p);
    80002012:	8526                	mv	a0,s1
    80002014:	00000097          	auipc	ra,0x0
    80002018:	eda080e7          	jalr	-294(ra) # 80001eee <freeproc>
    release(&p->lock);
    8000201c:	8526                	mv	a0,s1
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	e1e080e7          	jalr	-482(ra) # 80000e3c <release>
    return 0;
    80002026:	84ca                	mv	s1,s2
    80002028:	bff1                	j	80002004 <allocproc+0xa8>
    freeproc(p);
    8000202a:	8526                	mv	a0,s1
    8000202c:	00000097          	auipc	ra,0x0
    80002030:	ec2080e7          	jalr	-318(ra) # 80001eee <freeproc>
    release(&p->lock);
    80002034:	8526                	mv	a0,s1
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	e06080e7          	jalr	-506(ra) # 80000e3c <release>
    return 0;
    8000203e:	84ca                	mv	s1,s2
    80002040:	b7d1                	j	80002004 <allocproc+0xa8>

0000000080002042 <userinit>:
{
    80002042:	1101                	addi	sp,sp,-32
    80002044:	ec06                	sd	ra,24(sp)
    80002046:	e822                	sd	s0,16(sp)
    80002048:	e426                	sd	s1,8(sp)
    8000204a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000204c:	00000097          	auipc	ra,0x0
    80002050:	f10080e7          	jalr	-240(ra) # 80001f5c <allocproc>
    80002054:	84aa                	mv	s1,a0
  initproc = p;
    80002056:	00007797          	auipc	a5,0x7
    8000205a:	8aa7b923          	sd	a0,-1870(a5) # 80008908 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000205e:	03400613          	li	a2,52
    80002062:	00007597          	auipc	a1,0x7
    80002066:	83e58593          	addi	a1,a1,-1986 # 800088a0 <initcode>
    8000206a:	6928                	ld	a0,80(a0)
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	4a4080e7          	jalr	1188(ra) # 80001510 <uvmfirst>
  p->sz = PGSIZE;
    80002074:	6785                	lui	a5,0x1
    80002076:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80002078:	6cb8                	ld	a4,88(s1)
    8000207a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    8000207e:	6cb8                	ld	a4,88(s1)
    80002080:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002082:	4641                	li	a2,16
    80002084:	00006597          	auipc	a1,0x6
    80002088:	1ac58593          	addi	a1,a1,428 # 80008230 <etext+0x230>
    8000208c:	15848513          	addi	a0,s1,344
    80002090:	fffff097          	auipc	ra,0xfffff
    80002094:	f36080e7          	jalr	-202(ra) # 80000fc6 <safestrcpy>
  p->cwd = namei("/");
    80002098:	00006517          	auipc	a0,0x6
    8000209c:	1a850513          	addi	a0,a0,424 # 80008240 <etext+0x240>
    800020a0:	00002097          	auipc	ra,0x2
    800020a4:	59e080e7          	jalr	1438(ra) # 8000463e <namei>
    800020a8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800020ac:	478d                	li	a5,3
    800020ae:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800020b0:	8526                	mv	a0,s1
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	d8a080e7          	jalr	-630(ra) # 80000e3c <release>
}
    800020ba:	60e2                	ld	ra,24(sp)
    800020bc:	6442                	ld	s0,16(sp)
    800020be:	64a2                	ld	s1,8(sp)
    800020c0:	6105                	addi	sp,sp,32
    800020c2:	8082                	ret

00000000800020c4 <growproc>:
{
    800020c4:	1101                	addi	sp,sp,-32
    800020c6:	ec06                	sd	ra,24(sp)
    800020c8:	e822                	sd	s0,16(sp)
    800020ca:	e426                	sd	s1,8(sp)
    800020cc:	e04a                	sd	s2,0(sp)
    800020ce:	1000                	addi	s0,sp,32
    800020d0:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800020d2:	00000097          	auipc	ra,0x0
    800020d6:	c6a080e7          	jalr	-918(ra) # 80001d3c <myproc>
    800020da:	84aa                	mv	s1,a0
  sz = p->sz;
    800020dc:	652c                	ld	a1,72(a0)
  if (n > 0)
    800020de:	01204c63          	bgtz	s2,800020f6 <growproc+0x32>
  else if (n < 0)
    800020e2:	02094663          	bltz	s2,8000210e <growproc+0x4a>
  p->sz = sz;
    800020e6:	e4ac                	sd	a1,72(s1)
  return 0;
    800020e8:	4501                	li	a0,0
}
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	64a2                	ld	s1,8(sp)
    800020f0:	6902                	ld	s2,0(sp)
    800020f2:	6105                	addi	sp,sp,32
    800020f4:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    800020f6:	4691                	li	a3,4
    800020f8:	00b90633          	add	a2,s2,a1
    800020fc:	6928                	ld	a0,80(a0)
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	4cc080e7          	jalr	1228(ra) # 800015ca <uvmalloc>
    80002106:	85aa                	mv	a1,a0
    80002108:	fd79                	bnez	a0,800020e6 <growproc+0x22>
      return -1;
    8000210a:	557d                	li	a0,-1
    8000210c:	bff9                	j	800020ea <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000210e:	00b90633          	add	a2,s2,a1
    80002112:	6928                	ld	a0,80(a0)
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	46e080e7          	jalr	1134(ra) # 80001582 <uvmdealloc>
    8000211c:	85aa                	mv	a1,a0
    8000211e:	b7e1                	j	800020e6 <growproc+0x22>

0000000080002120 <fork>:
{
    80002120:	7139                	addi	sp,sp,-64
    80002122:	fc06                	sd	ra,56(sp)
    80002124:	f822                	sd	s0,48(sp)
    80002126:	f04a                	sd	s2,32(sp)
    80002128:	e456                	sd	s5,8(sp)
    8000212a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000212c:	00000097          	auipc	ra,0x0
    80002130:	c10080e7          	jalr	-1008(ra) # 80001d3c <myproc>
    80002134:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	e26080e7          	jalr	-474(ra) # 80001f5c <allocproc>
    8000213e:	12050063          	beqz	a0,8000225e <fork+0x13e>
    80002142:	e852                	sd	s4,16(sp)
    80002144:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002146:	048ab603          	ld	a2,72(s5)
    8000214a:	692c                	ld	a1,80(a0)
    8000214c:	050ab503          	ld	a0,80(s5)
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	5de080e7          	jalr	1502(ra) # 8000172e <uvmcopy>
    80002158:	04054a63          	bltz	a0,800021ac <fork+0x8c>
    8000215c:	f426                	sd	s1,40(sp)
    8000215e:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80002160:	048ab783          	ld	a5,72(s5)
    80002164:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80002168:	058ab683          	ld	a3,88(s5)
    8000216c:	87b6                	mv	a5,a3
    8000216e:	058a3703          	ld	a4,88(s4)
    80002172:	12068693          	addi	a3,a3,288
    80002176:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000217a:	6788                	ld	a0,8(a5)
    8000217c:	6b8c                	ld	a1,16(a5)
    8000217e:	6f90                	ld	a2,24(a5)
    80002180:	01073023          	sd	a6,0(a4)
    80002184:	e708                	sd	a0,8(a4)
    80002186:	eb0c                	sd	a1,16(a4)
    80002188:	ef10                	sd	a2,24(a4)
    8000218a:	02078793          	addi	a5,a5,32
    8000218e:	02070713          	addi	a4,a4,32
    80002192:	fed792e3          	bne	a5,a3,80002176 <fork+0x56>
  np->trapframe->a0 = 0;
    80002196:	058a3783          	ld	a5,88(s4)
    8000219a:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000219e:	0d0a8493          	addi	s1,s5,208
    800021a2:	0d0a0913          	addi	s2,s4,208
    800021a6:	150a8993          	addi	s3,s5,336
    800021aa:	a015                	j	800021ce <fork+0xae>
    freeproc(np);
    800021ac:	8552                	mv	a0,s4
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	d40080e7          	jalr	-704(ra) # 80001eee <freeproc>
    release(&np->lock);
    800021b6:	8552                	mv	a0,s4
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	c84080e7          	jalr	-892(ra) # 80000e3c <release>
    return -1;
    800021c0:	597d                	li	s2,-1
    800021c2:	6a42                	ld	s4,16(sp)
    800021c4:	a071                	j	80002250 <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    800021c6:	04a1                	addi	s1,s1,8
    800021c8:	0921                	addi	s2,s2,8
    800021ca:	01348b63          	beq	s1,s3,800021e0 <fork+0xc0>
    if (p->ofile[i])
    800021ce:	6088                	ld	a0,0(s1)
    800021d0:	d97d                	beqz	a0,800021c6 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800021d2:	00003097          	auipc	ra,0x3
    800021d6:	ae4080e7          	jalr	-1308(ra) # 80004cb6 <filedup>
    800021da:	00a93023          	sd	a0,0(s2)
    800021de:	b7e5                	j	800021c6 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800021e0:	150ab503          	ld	a0,336(s5)
    800021e4:	00002097          	auipc	ra,0x2
    800021e8:	c4e080e7          	jalr	-946(ra) # 80003e32 <idup>
    800021ec:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800021f0:	4641                	li	a2,16
    800021f2:	158a8593          	addi	a1,s5,344
    800021f6:	158a0513          	addi	a0,s4,344
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	dcc080e7          	jalr	-564(ra) # 80000fc6 <safestrcpy>
  pid = np->pid;
    80002202:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002206:	8552                	mv	a0,s4
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	c34080e7          	jalr	-972(ra) # 80000e3c <release>
  acquire(&wait_lock);
    80002210:	0022f497          	auipc	s1,0x22f
    80002214:	9a048493          	addi	s1,s1,-1632 # 80230bb0 <wait_lock>
    80002218:	8526                	mv	a0,s1
    8000221a:	fffff097          	auipc	ra,0xfffff
    8000221e:	b6e080e7          	jalr	-1170(ra) # 80000d88 <acquire>
  np->parent = p;
    80002222:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002226:	8526                	mv	a0,s1
    80002228:	fffff097          	auipc	ra,0xfffff
    8000222c:	c14080e7          	jalr	-1004(ra) # 80000e3c <release>
  acquire(&np->lock);
    80002230:	8552                	mv	a0,s4
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	b56080e7          	jalr	-1194(ra) # 80000d88 <acquire>
  np->state = RUNNABLE;
    8000223a:	478d                	li	a5,3
    8000223c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002240:	8552                	mv	a0,s4
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	bfa080e7          	jalr	-1030(ra) # 80000e3c <release>
  return pid;
    8000224a:	74a2                	ld	s1,40(sp)
    8000224c:	69e2                	ld	s3,24(sp)
    8000224e:	6a42                	ld	s4,16(sp)
}
    80002250:	854a                	mv	a0,s2
    80002252:	70e2                	ld	ra,56(sp)
    80002254:	7442                	ld	s0,48(sp)
    80002256:	7902                	ld	s2,32(sp)
    80002258:	6aa2                	ld	s5,8(sp)
    8000225a:	6121                	addi	sp,sp,64
    8000225c:	8082                	ret
    return -1;
    8000225e:	597d                	li	s2,-1
    80002260:	bfc5                	j	80002250 <fork+0x130>

0000000080002262 <scheduler>:
{
    80002262:	7139                	addi	sp,sp,-64
    80002264:	fc06                	sd	ra,56(sp)
    80002266:	f822                	sd	s0,48(sp)
    80002268:	f426                	sd	s1,40(sp)
    8000226a:	f04a                	sd	s2,32(sp)
    8000226c:	ec4e                	sd	s3,24(sp)
    8000226e:	e852                	sd	s4,16(sp)
    80002270:	e456                	sd	s5,8(sp)
    80002272:	e05a                	sd	s6,0(sp)
    80002274:	0080                	addi	s0,sp,64
    80002276:	8792                	mv	a5,tp
  int id = r_tp();
    80002278:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000227a:	00779a93          	slli	s5,a5,0x7
    8000227e:	0022f717          	auipc	a4,0x22f
    80002282:	91a70713          	addi	a4,a4,-1766 # 80230b98 <pid_lock>
    80002286:	9756                	add	a4,a4,s5
    80002288:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000228c:	0022f717          	auipc	a4,0x22f
    80002290:	94470713          	addi	a4,a4,-1724 # 80230bd0 <cpus+0x8>
    80002294:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    80002296:	498d                	li	s3,3
        p->state = RUNNING;
    80002298:	4b11                	li	s6,4
        c->proc = p;
    8000229a:	079e                	slli	a5,a5,0x7
    8000229c:	0022fa17          	auipc	s4,0x22f
    800022a0:	8fca0a13          	addi	s4,s4,-1796 # 80230b98 <pid_lock>
    800022a4:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800022a6:	00235917          	auipc	s2,0x235
    800022aa:	b2290913          	addi	s2,s2,-1246 # 80236dc8 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800022ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800022b2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800022b6:	10079073          	csrw	sstatus,a5
    800022ba:	0022f497          	auipc	s1,0x22f
    800022be:	d0e48493          	addi	s1,s1,-754 # 80230fc8 <proc>
    800022c2:	a811                	j	800022d6 <scheduler+0x74>
      release(&p->lock);
    800022c4:	8526                	mv	a0,s1
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	b76080e7          	jalr	-1162(ra) # 80000e3c <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800022ce:	17848493          	addi	s1,s1,376
    800022d2:	fd248ee3          	beq	s1,s2,800022ae <scheduler+0x4c>
      acquire(&p->lock);
    800022d6:	8526                	mv	a0,s1
    800022d8:	fffff097          	auipc	ra,0xfffff
    800022dc:	ab0080e7          	jalr	-1360(ra) # 80000d88 <acquire>
      if (p->state == RUNNABLE)
    800022e0:	4c9c                	lw	a5,24(s1)
    800022e2:	ff3791e3          	bne	a5,s3,800022c4 <scheduler+0x62>
        p->state = RUNNING;
    800022e6:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800022ea:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800022ee:	06048593          	addi	a1,s1,96
    800022f2:	8556                	mv	a0,s5
    800022f4:	00001097          	auipc	ra,0x1
    800022f8:	83a080e7          	jalr	-1990(ra) # 80002b2e <swtch>
        c->proc = 0;
    800022fc:	020a3823          	sd	zero,48(s4)
    80002300:	b7d1                	j	800022c4 <scheduler+0x62>

0000000080002302 <sched>:
{
    80002302:	7179                	addi	sp,sp,-48
    80002304:	f406                	sd	ra,40(sp)
    80002306:	f022                	sd	s0,32(sp)
    80002308:	ec26                	sd	s1,24(sp)
    8000230a:	e84a                	sd	s2,16(sp)
    8000230c:	e44e                	sd	s3,8(sp)
    8000230e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002310:	00000097          	auipc	ra,0x0
    80002314:	a2c080e7          	jalr	-1492(ra) # 80001d3c <myproc>
    80002318:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	9f4080e7          	jalr	-1548(ra) # 80000d0e <holding>
    80002322:	c93d                	beqz	a0,80002398 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002324:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002326:	2781                	sext.w	a5,a5
    80002328:	079e                	slli	a5,a5,0x7
    8000232a:	0022f717          	auipc	a4,0x22f
    8000232e:	86e70713          	addi	a4,a4,-1938 # 80230b98 <pid_lock>
    80002332:	97ba                	add	a5,a5,a4
    80002334:	0a87a703          	lw	a4,168(a5)
    80002338:	4785                	li	a5,1
    8000233a:	06f71763          	bne	a4,a5,800023a8 <sched+0xa6>
  if (p->state == RUNNING)
    8000233e:	4c98                	lw	a4,24(s1)
    80002340:	4791                	li	a5,4
    80002342:	06f70b63          	beq	a4,a5,800023b8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002346:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000234a:	8b89                	andi	a5,a5,2
  if (intr_get())
    8000234c:	efb5                	bnez	a5,800023c8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000234e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002350:	0022f917          	auipc	s2,0x22f
    80002354:	84890913          	addi	s2,s2,-1976 # 80230b98 <pid_lock>
    80002358:	2781                	sext.w	a5,a5
    8000235a:	079e                	slli	a5,a5,0x7
    8000235c:	97ca                	add	a5,a5,s2
    8000235e:	0ac7a983          	lw	s3,172(a5)
    80002362:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002364:	2781                	sext.w	a5,a5
    80002366:	079e                	slli	a5,a5,0x7
    80002368:	0022f597          	auipc	a1,0x22f
    8000236c:	86858593          	addi	a1,a1,-1944 # 80230bd0 <cpus+0x8>
    80002370:	95be                	add	a1,a1,a5
    80002372:	06048513          	addi	a0,s1,96
    80002376:	00000097          	auipc	ra,0x0
    8000237a:	7b8080e7          	jalr	1976(ra) # 80002b2e <swtch>
    8000237e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002380:	2781                	sext.w	a5,a5
    80002382:	079e                	slli	a5,a5,0x7
    80002384:	993e                	add	s2,s2,a5
    80002386:	0b392623          	sw	s3,172(s2)
}
    8000238a:	70a2                	ld	ra,40(sp)
    8000238c:	7402                	ld	s0,32(sp)
    8000238e:	64e2                	ld	s1,24(sp)
    80002390:	6942                	ld	s2,16(sp)
    80002392:	69a2                	ld	s3,8(sp)
    80002394:	6145                	addi	sp,sp,48
    80002396:	8082                	ret
    panic("sched p->lock");
    80002398:	00006517          	auipc	a0,0x6
    8000239c:	eb050513          	addi	a0,a0,-336 # 80008248 <etext+0x248>
    800023a0:	ffffe097          	auipc	ra,0xffffe
    800023a4:	1c0080e7          	jalr	448(ra) # 80000560 <panic>
    panic("sched locks");
    800023a8:	00006517          	auipc	a0,0x6
    800023ac:	eb050513          	addi	a0,a0,-336 # 80008258 <etext+0x258>
    800023b0:	ffffe097          	auipc	ra,0xffffe
    800023b4:	1b0080e7          	jalr	432(ra) # 80000560 <panic>
    panic("sched running");
    800023b8:	00006517          	auipc	a0,0x6
    800023bc:	eb050513          	addi	a0,a0,-336 # 80008268 <etext+0x268>
    800023c0:	ffffe097          	auipc	ra,0xffffe
    800023c4:	1a0080e7          	jalr	416(ra) # 80000560 <panic>
    panic("sched interruptible");
    800023c8:	00006517          	auipc	a0,0x6
    800023cc:	eb050513          	addi	a0,a0,-336 # 80008278 <etext+0x278>
    800023d0:	ffffe097          	auipc	ra,0xffffe
    800023d4:	190080e7          	jalr	400(ra) # 80000560 <panic>

00000000800023d8 <yield>:
{
    800023d8:	1101                	addi	sp,sp,-32
    800023da:	ec06                	sd	ra,24(sp)
    800023dc:	e822                	sd	s0,16(sp)
    800023de:	e426                	sd	s1,8(sp)
    800023e0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800023e2:	00000097          	auipc	ra,0x0
    800023e6:	95a080e7          	jalr	-1702(ra) # 80001d3c <myproc>
    800023ea:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800023ec:	fffff097          	auipc	ra,0xfffff
    800023f0:	99c080e7          	jalr	-1636(ra) # 80000d88 <acquire>
  p->state = RUNNABLE;
    800023f4:	478d                	li	a5,3
    800023f6:	cc9c                	sw	a5,24(s1)
  sched();
    800023f8:	00000097          	auipc	ra,0x0
    800023fc:	f0a080e7          	jalr	-246(ra) # 80002302 <sched>
  release(&p->lock);
    80002400:	8526                	mv	a0,s1
    80002402:	fffff097          	auipc	ra,0xfffff
    80002406:	a3a080e7          	jalr	-1478(ra) # 80000e3c <release>
}
    8000240a:	60e2                	ld	ra,24(sp)
    8000240c:	6442                	ld	s0,16(sp)
    8000240e:	64a2                	ld	s1,8(sp)
    80002410:	6105                	addi	sp,sp,32
    80002412:	8082                	ret

0000000080002414 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002414:	7179                	addi	sp,sp,-48
    80002416:	f406                	sd	ra,40(sp)
    80002418:	f022                	sd	s0,32(sp)
    8000241a:	ec26                	sd	s1,24(sp)
    8000241c:	e84a                	sd	s2,16(sp)
    8000241e:	e44e                	sd	s3,8(sp)
    80002420:	1800                	addi	s0,sp,48
    80002422:	89aa                	mv	s3,a0
    80002424:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002426:	00000097          	auipc	ra,0x0
    8000242a:	916080e7          	jalr	-1770(ra) # 80001d3c <myproc>
    8000242e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80002430:	fffff097          	auipc	ra,0xfffff
    80002434:	958080e7          	jalr	-1704(ra) # 80000d88 <acquire>
  release(lk);
    80002438:	854a                	mv	a0,s2
    8000243a:	fffff097          	auipc	ra,0xfffff
    8000243e:	a02080e7          	jalr	-1534(ra) # 80000e3c <release>

  // Go to sleep.
  p->chan = chan;
    80002442:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002446:	4789                	li	a5,2
    80002448:	cc9c                	sw	a5,24(s1)

  sched();
    8000244a:	00000097          	auipc	ra,0x0
    8000244e:	eb8080e7          	jalr	-328(ra) # 80002302 <sched>

  // Tidy up.
  p->chan = 0;
    80002452:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002456:	8526                	mv	a0,s1
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	9e4080e7          	jalr	-1564(ra) # 80000e3c <release>
  acquire(lk);
    80002460:	854a                	mv	a0,s2
    80002462:	fffff097          	auipc	ra,0xfffff
    80002466:	926080e7          	jalr	-1754(ra) # 80000d88 <acquire>
}
    8000246a:	70a2                	ld	ra,40(sp)
    8000246c:	7402                	ld	s0,32(sp)
    8000246e:	64e2                	ld	s1,24(sp)
    80002470:	6942                	ld	s2,16(sp)
    80002472:	69a2                	ld	s3,8(sp)
    80002474:	6145                	addi	sp,sp,48
    80002476:	8082                	ret

0000000080002478 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002478:	7139                	addi	sp,sp,-64
    8000247a:	fc06                	sd	ra,56(sp)
    8000247c:	f822                	sd	s0,48(sp)
    8000247e:	f426                	sd	s1,40(sp)
    80002480:	f04a                	sd	s2,32(sp)
    80002482:	ec4e                	sd	s3,24(sp)
    80002484:	e852                	sd	s4,16(sp)
    80002486:	e456                	sd	s5,8(sp)
    80002488:	0080                	addi	s0,sp,64
    8000248a:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000248c:	0022f497          	auipc	s1,0x22f
    80002490:	b3c48493          	addi	s1,s1,-1220 # 80230fc8 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002494:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    80002496:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002498:	00235917          	auipc	s2,0x235
    8000249c:	93090913          	addi	s2,s2,-1744 # 80236dc8 <tickslock>
    800024a0:	a811                	j	800024b4 <wakeup+0x3c>
      }
      release(&p->lock);
    800024a2:	8526                	mv	a0,s1
    800024a4:	fffff097          	auipc	ra,0xfffff
    800024a8:	998080e7          	jalr	-1640(ra) # 80000e3c <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800024ac:	17848493          	addi	s1,s1,376
    800024b0:	03248663          	beq	s1,s2,800024dc <wakeup+0x64>
    if (p != myproc())
    800024b4:	00000097          	auipc	ra,0x0
    800024b8:	888080e7          	jalr	-1912(ra) # 80001d3c <myproc>
    800024bc:	fea488e3          	beq	s1,a0,800024ac <wakeup+0x34>
      acquire(&p->lock);
    800024c0:	8526                	mv	a0,s1
    800024c2:	fffff097          	auipc	ra,0xfffff
    800024c6:	8c6080e7          	jalr	-1850(ra) # 80000d88 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    800024ca:	4c9c                	lw	a5,24(s1)
    800024cc:	fd379be3          	bne	a5,s3,800024a2 <wakeup+0x2a>
    800024d0:	709c                	ld	a5,32(s1)
    800024d2:	fd4798e3          	bne	a5,s4,800024a2 <wakeup+0x2a>
        p->state = RUNNABLE;
    800024d6:	0154ac23          	sw	s5,24(s1)
    800024da:	b7e1                	j	800024a2 <wakeup+0x2a>
    }
  }
}
    800024dc:	70e2                	ld	ra,56(sp)
    800024de:	7442                	ld	s0,48(sp)
    800024e0:	74a2                	ld	s1,40(sp)
    800024e2:	7902                	ld	s2,32(sp)
    800024e4:	69e2                	ld	s3,24(sp)
    800024e6:	6a42                	ld	s4,16(sp)
    800024e8:	6aa2                	ld	s5,8(sp)
    800024ea:	6121                	addi	sp,sp,64
    800024ec:	8082                	ret

00000000800024ee <reparent>:
{
    800024ee:	7179                	addi	sp,sp,-48
    800024f0:	f406                	sd	ra,40(sp)
    800024f2:	f022                	sd	s0,32(sp)
    800024f4:	ec26                	sd	s1,24(sp)
    800024f6:	e84a                	sd	s2,16(sp)
    800024f8:	e44e                	sd	s3,8(sp)
    800024fa:	e052                	sd	s4,0(sp)
    800024fc:	1800                	addi	s0,sp,48
    800024fe:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80002500:	0022f497          	auipc	s1,0x22f
    80002504:	ac848493          	addi	s1,s1,-1336 # 80230fc8 <proc>
      pp->parent = initproc;
    80002508:	00006a17          	auipc	s4,0x6
    8000250c:	400a0a13          	addi	s4,s4,1024 # 80008908 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80002510:	00235997          	auipc	s3,0x235
    80002514:	8b898993          	addi	s3,s3,-1864 # 80236dc8 <tickslock>
    80002518:	a029                	j	80002522 <reparent+0x34>
    8000251a:	17848493          	addi	s1,s1,376
    8000251e:	01348d63          	beq	s1,s3,80002538 <reparent+0x4a>
    if (pp->parent == p)
    80002522:	7c9c                	ld	a5,56(s1)
    80002524:	ff279be3          	bne	a5,s2,8000251a <reparent+0x2c>
      pp->parent = initproc;
    80002528:	000a3503          	ld	a0,0(s4)
    8000252c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000252e:	00000097          	auipc	ra,0x0
    80002532:	f4a080e7          	jalr	-182(ra) # 80002478 <wakeup>
    80002536:	b7d5                	j	8000251a <reparent+0x2c>
}
    80002538:	70a2                	ld	ra,40(sp)
    8000253a:	7402                	ld	s0,32(sp)
    8000253c:	64e2                	ld	s1,24(sp)
    8000253e:	6942                	ld	s2,16(sp)
    80002540:	69a2                	ld	s3,8(sp)
    80002542:	6a02                	ld	s4,0(sp)
    80002544:	6145                	addi	sp,sp,48
    80002546:	8082                	ret

0000000080002548 <exit>:
{
    80002548:	7179                	addi	sp,sp,-48
    8000254a:	f406                	sd	ra,40(sp)
    8000254c:	f022                	sd	s0,32(sp)
    8000254e:	ec26                	sd	s1,24(sp)
    80002550:	e84a                	sd	s2,16(sp)
    80002552:	e44e                	sd	s3,8(sp)
    80002554:	e052                	sd	s4,0(sp)
    80002556:	1800                	addi	s0,sp,48
    80002558:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	7e2080e7          	jalr	2018(ra) # 80001d3c <myproc>
    80002562:	89aa                	mv	s3,a0
  if (p == initproc)
    80002564:	00006797          	auipc	a5,0x6
    80002568:	3a47b783          	ld	a5,932(a5) # 80008908 <initproc>
    8000256c:	0d050493          	addi	s1,a0,208
    80002570:	15050913          	addi	s2,a0,336
    80002574:	02a79363          	bne	a5,a0,8000259a <exit+0x52>
    panic("init exiting");
    80002578:	00006517          	auipc	a0,0x6
    8000257c:	d1850513          	addi	a0,a0,-744 # 80008290 <etext+0x290>
    80002580:	ffffe097          	auipc	ra,0xffffe
    80002584:	fe0080e7          	jalr	-32(ra) # 80000560 <panic>
      fileclose(f);
    80002588:	00002097          	auipc	ra,0x2
    8000258c:	780080e7          	jalr	1920(ra) # 80004d08 <fileclose>
      p->ofile[fd] = 0;
    80002590:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    80002594:	04a1                	addi	s1,s1,8
    80002596:	01248563          	beq	s1,s2,800025a0 <exit+0x58>
    if (p->ofile[fd])
    8000259a:	6088                	ld	a0,0(s1)
    8000259c:	f575                	bnez	a0,80002588 <exit+0x40>
    8000259e:	bfdd                	j	80002594 <exit+0x4c>
  begin_op();
    800025a0:	00002097          	auipc	ra,0x2
    800025a4:	29e080e7          	jalr	670(ra) # 8000483e <begin_op>
  iput(p->cwd);
    800025a8:	1509b503          	ld	a0,336(s3)
    800025ac:	00002097          	auipc	ra,0x2
    800025b0:	a82080e7          	jalr	-1406(ra) # 8000402e <iput>
  end_op();
    800025b4:	00002097          	auipc	ra,0x2
    800025b8:	304080e7          	jalr	772(ra) # 800048b8 <end_op>
  p->cwd = 0;
    800025bc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800025c0:	0022e497          	auipc	s1,0x22e
    800025c4:	5f048493          	addi	s1,s1,1520 # 80230bb0 <wait_lock>
    800025c8:	8526                	mv	a0,s1
    800025ca:	ffffe097          	auipc	ra,0xffffe
    800025ce:	7be080e7          	jalr	1982(ra) # 80000d88 <acquire>
  reparent(p);
    800025d2:	854e                	mv	a0,s3
    800025d4:	00000097          	auipc	ra,0x0
    800025d8:	f1a080e7          	jalr	-230(ra) # 800024ee <reparent>
  wakeup(p->parent);
    800025dc:	0389b503          	ld	a0,56(s3)
    800025e0:	00000097          	auipc	ra,0x0
    800025e4:	e98080e7          	jalr	-360(ra) # 80002478 <wakeup>
  acquire(&p->lock);
    800025e8:	854e                	mv	a0,s3
    800025ea:	ffffe097          	auipc	ra,0xffffe
    800025ee:	79e080e7          	jalr	1950(ra) # 80000d88 <acquire>
  p->xstate = status;
    800025f2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800025f6:	4795                	li	a5,5
    800025f8:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    800025fc:	00006797          	auipc	a5,0x6
    80002600:	3147a783          	lw	a5,788(a5) # 80008910 <ticks>
    80002604:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    80002608:	8526                	mv	a0,s1
    8000260a:	fffff097          	auipc	ra,0xfffff
    8000260e:	832080e7          	jalr	-1998(ra) # 80000e3c <release>
  sched();
    80002612:	00000097          	auipc	ra,0x0
    80002616:	cf0080e7          	jalr	-784(ra) # 80002302 <sched>
  panic("zombie exit");
    8000261a:	00006517          	auipc	a0,0x6
    8000261e:	c8650513          	addi	a0,a0,-890 # 800082a0 <etext+0x2a0>
    80002622:	ffffe097          	auipc	ra,0xffffe
    80002626:	f3e080e7          	jalr	-194(ra) # 80000560 <panic>

000000008000262a <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000262a:	7179                	addi	sp,sp,-48
    8000262c:	f406                	sd	ra,40(sp)
    8000262e:	f022                	sd	s0,32(sp)
    80002630:	ec26                	sd	s1,24(sp)
    80002632:	e84a                	sd	s2,16(sp)
    80002634:	e44e                	sd	s3,8(sp)
    80002636:	1800                	addi	s0,sp,48
    80002638:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000263a:	0022f497          	auipc	s1,0x22f
    8000263e:	98e48493          	addi	s1,s1,-1650 # 80230fc8 <proc>
    80002642:	00234997          	auipc	s3,0x234
    80002646:	78698993          	addi	s3,s3,1926 # 80236dc8 <tickslock>
  {
    acquire(&p->lock);
    8000264a:	8526                	mv	a0,s1
    8000264c:	ffffe097          	auipc	ra,0xffffe
    80002650:	73c080e7          	jalr	1852(ra) # 80000d88 <acquire>
    if (p->pid == pid)
    80002654:	589c                	lw	a5,48(s1)
    80002656:	01278d63          	beq	a5,s2,80002670 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000265a:	8526                	mv	a0,s1
    8000265c:	ffffe097          	auipc	ra,0xffffe
    80002660:	7e0080e7          	jalr	2016(ra) # 80000e3c <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002664:	17848493          	addi	s1,s1,376
    80002668:	ff3491e3          	bne	s1,s3,8000264a <kill+0x20>
  }
  return -1;
    8000266c:	557d                	li	a0,-1
    8000266e:	a829                	j	80002688 <kill+0x5e>
      p->killed = 1;
    80002670:	4785                	li	a5,1
    80002672:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80002674:	4c98                	lw	a4,24(s1)
    80002676:	4789                	li	a5,2
    80002678:	00f70f63          	beq	a4,a5,80002696 <kill+0x6c>
      release(&p->lock);
    8000267c:	8526                	mv	a0,s1
    8000267e:	ffffe097          	auipc	ra,0xffffe
    80002682:	7be080e7          	jalr	1982(ra) # 80000e3c <release>
      return 0;
    80002686:	4501                	li	a0,0
}
    80002688:	70a2                	ld	ra,40(sp)
    8000268a:	7402                	ld	s0,32(sp)
    8000268c:	64e2                	ld	s1,24(sp)
    8000268e:	6942                	ld	s2,16(sp)
    80002690:	69a2                	ld	s3,8(sp)
    80002692:	6145                	addi	sp,sp,48
    80002694:	8082                	ret
        p->state = RUNNABLE;
    80002696:	478d                	li	a5,3
    80002698:	cc9c                	sw	a5,24(s1)
    8000269a:	b7cd                	j	8000267c <kill+0x52>

000000008000269c <setkilled>:

void setkilled(struct proc *p)
{
    8000269c:	1101                	addi	sp,sp,-32
    8000269e:	ec06                	sd	ra,24(sp)
    800026a0:	e822                	sd	s0,16(sp)
    800026a2:	e426                	sd	s1,8(sp)
    800026a4:	1000                	addi	s0,sp,32
    800026a6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800026a8:	ffffe097          	auipc	ra,0xffffe
    800026ac:	6e0080e7          	jalr	1760(ra) # 80000d88 <acquire>
  p->killed = 1;
    800026b0:	4785                	li	a5,1
    800026b2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800026b4:	8526                	mv	a0,s1
    800026b6:	ffffe097          	auipc	ra,0xffffe
    800026ba:	786080e7          	jalr	1926(ra) # 80000e3c <release>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret

00000000800026c8 <killed>:

int killed(struct proc *p)
{
    800026c8:	1101                	addi	sp,sp,-32
    800026ca:	ec06                	sd	ra,24(sp)
    800026cc:	e822                	sd	s0,16(sp)
    800026ce:	e426                	sd	s1,8(sp)
    800026d0:	e04a                	sd	s2,0(sp)
    800026d2:	1000                	addi	s0,sp,32
    800026d4:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800026d6:	ffffe097          	auipc	ra,0xffffe
    800026da:	6b2080e7          	jalr	1714(ra) # 80000d88 <acquire>
  k = p->killed;
    800026de:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800026e2:	8526                	mv	a0,s1
    800026e4:	ffffe097          	auipc	ra,0xffffe
    800026e8:	758080e7          	jalr	1880(ra) # 80000e3c <release>
  return k;
}
    800026ec:	854a                	mv	a0,s2
    800026ee:	60e2                	ld	ra,24(sp)
    800026f0:	6442                	ld	s0,16(sp)
    800026f2:	64a2                	ld	s1,8(sp)
    800026f4:	6902                	ld	s2,0(sp)
    800026f6:	6105                	addi	sp,sp,32
    800026f8:	8082                	ret

00000000800026fa <wait>:
{
    800026fa:	715d                	addi	sp,sp,-80
    800026fc:	e486                	sd	ra,72(sp)
    800026fe:	e0a2                	sd	s0,64(sp)
    80002700:	fc26                	sd	s1,56(sp)
    80002702:	f84a                	sd	s2,48(sp)
    80002704:	f44e                	sd	s3,40(sp)
    80002706:	f052                	sd	s4,32(sp)
    80002708:	ec56                	sd	s5,24(sp)
    8000270a:	e85a                	sd	s6,16(sp)
    8000270c:	e45e                	sd	s7,8(sp)
    8000270e:	e062                	sd	s8,0(sp)
    80002710:	0880                	addi	s0,sp,80
    80002712:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002714:	fffff097          	auipc	ra,0xfffff
    80002718:	628080e7          	jalr	1576(ra) # 80001d3c <myproc>
    8000271c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000271e:	0022e517          	auipc	a0,0x22e
    80002722:	49250513          	addi	a0,a0,1170 # 80230bb0 <wait_lock>
    80002726:	ffffe097          	auipc	ra,0xffffe
    8000272a:	662080e7          	jalr	1634(ra) # 80000d88 <acquire>
    havekids = 0;
    8000272e:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    80002730:	4a15                	li	s4,5
        havekids = 1;
    80002732:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002734:	00234997          	auipc	s3,0x234
    80002738:	69498993          	addi	s3,s3,1684 # 80236dc8 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    8000273c:	0022ec17          	auipc	s8,0x22e
    80002740:	474c0c13          	addi	s8,s8,1140 # 80230bb0 <wait_lock>
    80002744:	a0d1                	j	80002808 <wait+0x10e>
          pid = pp->pid;
    80002746:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000274a:	000b0e63          	beqz	s6,80002766 <wait+0x6c>
    8000274e:	4691                	li	a3,4
    80002750:	02c48613          	addi	a2,s1,44
    80002754:	85da                	mv	a1,s6
    80002756:	05093503          	ld	a0,80(s2)
    8000275a:	fffff097          	auipc	ra,0xfffff
    8000275e:	116080e7          	jalr	278(ra) # 80001870 <copyout>
    80002762:	04054163          	bltz	a0,800027a4 <wait+0xaa>
          freeproc(pp);
    80002766:	8526                	mv	a0,s1
    80002768:	fffff097          	auipc	ra,0xfffff
    8000276c:	786080e7          	jalr	1926(ra) # 80001eee <freeproc>
          release(&pp->lock);
    80002770:	8526                	mv	a0,s1
    80002772:	ffffe097          	auipc	ra,0xffffe
    80002776:	6ca080e7          	jalr	1738(ra) # 80000e3c <release>
          release(&wait_lock);
    8000277a:	0022e517          	auipc	a0,0x22e
    8000277e:	43650513          	addi	a0,a0,1078 # 80230bb0 <wait_lock>
    80002782:	ffffe097          	auipc	ra,0xffffe
    80002786:	6ba080e7          	jalr	1722(ra) # 80000e3c <release>
}
    8000278a:	854e                	mv	a0,s3
    8000278c:	60a6                	ld	ra,72(sp)
    8000278e:	6406                	ld	s0,64(sp)
    80002790:	74e2                	ld	s1,56(sp)
    80002792:	7942                	ld	s2,48(sp)
    80002794:	79a2                	ld	s3,40(sp)
    80002796:	7a02                	ld	s4,32(sp)
    80002798:	6ae2                	ld	s5,24(sp)
    8000279a:	6b42                	ld	s6,16(sp)
    8000279c:	6ba2                	ld	s7,8(sp)
    8000279e:	6c02                	ld	s8,0(sp)
    800027a0:	6161                	addi	sp,sp,80
    800027a2:	8082                	ret
            release(&pp->lock);
    800027a4:	8526                	mv	a0,s1
    800027a6:	ffffe097          	auipc	ra,0xffffe
    800027aa:	696080e7          	jalr	1686(ra) # 80000e3c <release>
            release(&wait_lock);
    800027ae:	0022e517          	auipc	a0,0x22e
    800027b2:	40250513          	addi	a0,a0,1026 # 80230bb0 <wait_lock>
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	686080e7          	jalr	1670(ra) # 80000e3c <release>
            return -1;
    800027be:	59fd                	li	s3,-1
    800027c0:	b7e9                	j	8000278a <wait+0x90>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800027c2:	17848493          	addi	s1,s1,376
    800027c6:	03348463          	beq	s1,s3,800027ee <wait+0xf4>
      if (pp->parent == p)
    800027ca:	7c9c                	ld	a5,56(s1)
    800027cc:	ff279be3          	bne	a5,s2,800027c2 <wait+0xc8>
        acquire(&pp->lock);
    800027d0:	8526                	mv	a0,s1
    800027d2:	ffffe097          	auipc	ra,0xffffe
    800027d6:	5b6080e7          	jalr	1462(ra) # 80000d88 <acquire>
        if (pp->state == ZOMBIE)
    800027da:	4c9c                	lw	a5,24(s1)
    800027dc:	f74785e3          	beq	a5,s4,80002746 <wait+0x4c>
        release(&pp->lock);
    800027e0:	8526                	mv	a0,s1
    800027e2:	ffffe097          	auipc	ra,0xffffe
    800027e6:	65a080e7          	jalr	1626(ra) # 80000e3c <release>
        havekids = 1;
    800027ea:	8756                	mv	a4,s5
    800027ec:	bfd9                	j	800027c2 <wait+0xc8>
    if (!havekids || killed(p))
    800027ee:	c31d                	beqz	a4,80002814 <wait+0x11a>
    800027f0:	854a                	mv	a0,s2
    800027f2:	00000097          	auipc	ra,0x0
    800027f6:	ed6080e7          	jalr	-298(ra) # 800026c8 <killed>
    800027fa:	ed09                	bnez	a0,80002814 <wait+0x11a>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800027fc:	85e2                	mv	a1,s8
    800027fe:	854a                	mv	a0,s2
    80002800:	00000097          	auipc	ra,0x0
    80002804:	c14080e7          	jalr	-1004(ra) # 80002414 <sleep>
    havekids = 0;
    80002808:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000280a:	0022e497          	auipc	s1,0x22e
    8000280e:	7be48493          	addi	s1,s1,1982 # 80230fc8 <proc>
    80002812:	bf65                	j	800027ca <wait+0xd0>
      release(&wait_lock);
    80002814:	0022e517          	auipc	a0,0x22e
    80002818:	39c50513          	addi	a0,a0,924 # 80230bb0 <wait_lock>
    8000281c:	ffffe097          	auipc	ra,0xffffe
    80002820:	620080e7          	jalr	1568(ra) # 80000e3c <release>
      return -1;
    80002824:	59fd                	li	s3,-1
    80002826:	b795                	j	8000278a <wait+0x90>

0000000080002828 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002828:	7179                	addi	sp,sp,-48
    8000282a:	f406                	sd	ra,40(sp)
    8000282c:	f022                	sd	s0,32(sp)
    8000282e:	ec26                	sd	s1,24(sp)
    80002830:	e84a                	sd	s2,16(sp)
    80002832:	e44e                	sd	s3,8(sp)
    80002834:	e052                	sd	s4,0(sp)
    80002836:	1800                	addi	s0,sp,48
    80002838:	84aa                	mv	s1,a0
    8000283a:	892e                	mv	s2,a1
    8000283c:	89b2                	mv	s3,a2
    8000283e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002840:	fffff097          	auipc	ra,0xfffff
    80002844:	4fc080e7          	jalr	1276(ra) # 80001d3c <myproc>
  if (user_dst)
    80002848:	c08d                	beqz	s1,8000286a <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    8000284a:	86d2                	mv	a3,s4
    8000284c:	864e                	mv	a2,s3
    8000284e:	85ca                	mv	a1,s2
    80002850:	6928                	ld	a0,80(a0)
    80002852:	fffff097          	auipc	ra,0xfffff
    80002856:	01e080e7          	jalr	30(ra) # 80001870 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000285a:	70a2                	ld	ra,40(sp)
    8000285c:	7402                	ld	s0,32(sp)
    8000285e:	64e2                	ld	s1,24(sp)
    80002860:	6942                	ld	s2,16(sp)
    80002862:	69a2                	ld	s3,8(sp)
    80002864:	6a02                	ld	s4,0(sp)
    80002866:	6145                	addi	sp,sp,48
    80002868:	8082                	ret
    memmove((char *)dst, src, len);
    8000286a:	000a061b          	sext.w	a2,s4
    8000286e:	85ce                	mv	a1,s3
    80002870:	854a                	mv	a0,s2
    80002872:	ffffe097          	auipc	ra,0xffffe
    80002876:	66e080e7          	jalr	1646(ra) # 80000ee0 <memmove>
    return 0;
    8000287a:	8526                	mv	a0,s1
    8000287c:	bff9                	j	8000285a <either_copyout+0x32>

000000008000287e <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000287e:	7179                	addi	sp,sp,-48
    80002880:	f406                	sd	ra,40(sp)
    80002882:	f022                	sd	s0,32(sp)
    80002884:	ec26                	sd	s1,24(sp)
    80002886:	e84a                	sd	s2,16(sp)
    80002888:	e44e                	sd	s3,8(sp)
    8000288a:	e052                	sd	s4,0(sp)
    8000288c:	1800                	addi	s0,sp,48
    8000288e:	892a                	mv	s2,a0
    80002890:	84ae                	mv	s1,a1
    80002892:	89b2                	mv	s3,a2
    80002894:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002896:	fffff097          	auipc	ra,0xfffff
    8000289a:	4a6080e7          	jalr	1190(ra) # 80001d3c <myproc>
  if (user_src)
    8000289e:	c08d                	beqz	s1,800028c0 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    800028a0:	86d2                	mv	a3,s4
    800028a2:	864e                	mv	a2,s3
    800028a4:	85ca                	mv	a1,s2
    800028a6:	6928                	ld	a0,80(a0)
    800028a8:	fffff097          	auipc	ra,0xfffff
    800028ac:	1b8080e7          	jalr	440(ra) # 80001a60 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800028b0:	70a2                	ld	ra,40(sp)
    800028b2:	7402                	ld	s0,32(sp)
    800028b4:	64e2                	ld	s1,24(sp)
    800028b6:	6942                	ld	s2,16(sp)
    800028b8:	69a2                	ld	s3,8(sp)
    800028ba:	6a02                	ld	s4,0(sp)
    800028bc:	6145                	addi	sp,sp,48
    800028be:	8082                	ret
    memmove(dst, (char *)src, len);
    800028c0:	000a061b          	sext.w	a2,s4
    800028c4:	85ce                	mv	a1,s3
    800028c6:	854a                	mv	a0,s2
    800028c8:	ffffe097          	auipc	ra,0xffffe
    800028cc:	618080e7          	jalr	1560(ra) # 80000ee0 <memmove>
    return 0;
    800028d0:	8526                	mv	a0,s1
    800028d2:	bff9                	j	800028b0 <either_copyin+0x32>

00000000800028d4 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800028d4:	715d                	addi	sp,sp,-80
    800028d6:	e486                	sd	ra,72(sp)
    800028d8:	e0a2                	sd	s0,64(sp)
    800028da:	fc26                	sd	s1,56(sp)
    800028dc:	f84a                	sd	s2,48(sp)
    800028de:	f44e                	sd	s3,40(sp)
    800028e0:	f052                	sd	s4,32(sp)
    800028e2:	ec56                	sd	s5,24(sp)
    800028e4:	e85a                	sd	s6,16(sp)
    800028e6:	e45e                	sd	s7,8(sp)
    800028e8:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800028ea:	00005517          	auipc	a0,0x5
    800028ee:	72650513          	addi	a0,a0,1830 # 80008010 <etext+0x10>
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	cb8080e7          	jalr	-840(ra) # 800005aa <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800028fa:	0022f497          	auipc	s1,0x22f
    800028fe:	82648493          	addi	s1,s1,-2010 # 80231120 <proc+0x158>
    80002902:	00234917          	auipc	s2,0x234
    80002906:	61e90913          	addi	s2,s2,1566 # 80236f20 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000290a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000290c:	00006997          	auipc	s3,0x6
    80002910:	9a498993          	addi	s3,s3,-1628 # 800082b0 <etext+0x2b0>
    printf("%d %s %s", p->pid, state, p->name);
    80002914:	00006a97          	auipc	s5,0x6
    80002918:	9a4a8a93          	addi	s5,s5,-1628 # 800082b8 <etext+0x2b8>
    printf("\n");
    8000291c:	00005a17          	auipc	s4,0x5
    80002920:	6f4a0a13          	addi	s4,s4,1780 # 80008010 <etext+0x10>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002924:	00006b97          	auipc	s7,0x6
    80002928:	e6cb8b93          	addi	s7,s7,-404 # 80008790 <states.0>
    8000292c:	a00d                	j	8000294e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000292e:	ed86a583          	lw	a1,-296(a3)
    80002932:	8556                	mv	a0,s5
    80002934:	ffffe097          	auipc	ra,0xffffe
    80002938:	c76080e7          	jalr	-906(ra) # 800005aa <printf>
    printf("\n");
    8000293c:	8552                	mv	a0,s4
    8000293e:	ffffe097          	auipc	ra,0xffffe
    80002942:	c6c080e7          	jalr	-916(ra) # 800005aa <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002946:	17848493          	addi	s1,s1,376
    8000294a:	03248263          	beq	s1,s2,8000296e <procdump+0x9a>
    if (p->state == UNUSED)
    8000294e:	86a6                	mv	a3,s1
    80002950:	ec04a783          	lw	a5,-320(s1)
    80002954:	dbed                	beqz	a5,80002946 <procdump+0x72>
      state = "???";
    80002956:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002958:	fcfb6be3          	bltu	s6,a5,8000292e <procdump+0x5a>
    8000295c:	02079713          	slli	a4,a5,0x20
    80002960:	01d75793          	srli	a5,a4,0x1d
    80002964:	97de                	add	a5,a5,s7
    80002966:	6390                	ld	a2,0(a5)
    80002968:	f279                	bnez	a2,8000292e <procdump+0x5a>
      state = "???";
    8000296a:	864e                	mv	a2,s3
    8000296c:	b7c9                	j	8000292e <procdump+0x5a>
  }
}
    8000296e:	60a6                	ld	ra,72(sp)
    80002970:	6406                	ld	s0,64(sp)
    80002972:	74e2                	ld	s1,56(sp)
    80002974:	7942                	ld	s2,48(sp)
    80002976:	79a2                	ld	s3,40(sp)
    80002978:	7a02                	ld	s4,32(sp)
    8000297a:	6ae2                	ld	s5,24(sp)
    8000297c:	6b42                	ld	s6,16(sp)
    8000297e:	6ba2                	ld	s7,8(sp)
    80002980:	6161                	addi	sp,sp,80
    80002982:	8082                	ret

0000000080002984 <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    80002984:	711d                	addi	sp,sp,-96
    80002986:	ec86                	sd	ra,88(sp)
    80002988:	e8a2                	sd	s0,80(sp)
    8000298a:	e4a6                	sd	s1,72(sp)
    8000298c:	e0ca                	sd	s2,64(sp)
    8000298e:	fc4e                	sd	s3,56(sp)
    80002990:	f852                	sd	s4,48(sp)
    80002992:	f456                	sd	s5,40(sp)
    80002994:	f05a                	sd	s6,32(sp)
    80002996:	ec5e                	sd	s7,24(sp)
    80002998:	e862                	sd	s8,16(sp)
    8000299a:	e466                	sd	s9,8(sp)
    8000299c:	e06a                	sd	s10,0(sp)
    8000299e:	1080                	addi	s0,sp,96
    800029a0:	8b2a                	mv	s6,a0
    800029a2:	8bae                	mv	s7,a1
    800029a4:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    800029a6:	fffff097          	auipc	ra,0xfffff
    800029aa:	396080e7          	jalr	918(ra) # 80001d3c <myproc>
    800029ae:	892a                	mv	s2,a0

  acquire(&wait_lock);
    800029b0:	0022e517          	auipc	a0,0x22e
    800029b4:	20050513          	addi	a0,a0,512 # 80230bb0 <wait_lock>
    800029b8:	ffffe097          	auipc	ra,0xffffe
    800029bc:	3d0080e7          	jalr	976(ra) # 80000d88 <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    800029c0:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    800029c2:	4a15                	li	s4,5
        havekids = 1;
    800029c4:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    800029c6:	00234997          	auipc	s3,0x234
    800029ca:	40298993          	addi	s3,s3,1026 # 80236dc8 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    800029ce:	0022ed17          	auipc	s10,0x22e
    800029d2:	1e2d0d13          	addi	s10,s10,482 # 80230bb0 <wait_lock>
    800029d6:	a8e9                	j	80002ab0 <waitx+0x12c>
          pid = np->pid;
    800029d8:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    800029dc:	1684a783          	lw	a5,360(s1)
    800029e0:	00fc2023          	sw	a5,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    800029e4:	16c4a703          	lw	a4,364(s1)
    800029e8:	9f3d                	addw	a4,a4,a5
    800029ea:	1704a783          	lw	a5,368(s1)
    800029ee:	9f99                	subw	a5,a5,a4
    800029f0:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800029f4:	000b0e63          	beqz	s6,80002a10 <waitx+0x8c>
    800029f8:	4691                	li	a3,4
    800029fa:	02c48613          	addi	a2,s1,44
    800029fe:	85da                	mv	a1,s6
    80002a00:	05093503          	ld	a0,80(s2)
    80002a04:	fffff097          	auipc	ra,0xfffff
    80002a08:	e6c080e7          	jalr	-404(ra) # 80001870 <copyout>
    80002a0c:	04054363          	bltz	a0,80002a52 <waitx+0xce>
          freeproc(np);
    80002a10:	8526                	mv	a0,s1
    80002a12:	fffff097          	auipc	ra,0xfffff
    80002a16:	4dc080e7          	jalr	1244(ra) # 80001eee <freeproc>
          release(&np->lock);
    80002a1a:	8526                	mv	a0,s1
    80002a1c:	ffffe097          	auipc	ra,0xffffe
    80002a20:	420080e7          	jalr	1056(ra) # 80000e3c <release>
          release(&wait_lock);
    80002a24:	0022e517          	auipc	a0,0x22e
    80002a28:	18c50513          	addi	a0,a0,396 # 80230bb0 <wait_lock>
    80002a2c:	ffffe097          	auipc	ra,0xffffe
    80002a30:	410080e7          	jalr	1040(ra) # 80000e3c <release>
  }
}
    80002a34:	854e                	mv	a0,s3
    80002a36:	60e6                	ld	ra,88(sp)
    80002a38:	6446                	ld	s0,80(sp)
    80002a3a:	64a6                	ld	s1,72(sp)
    80002a3c:	6906                	ld	s2,64(sp)
    80002a3e:	79e2                	ld	s3,56(sp)
    80002a40:	7a42                	ld	s4,48(sp)
    80002a42:	7aa2                	ld	s5,40(sp)
    80002a44:	7b02                	ld	s6,32(sp)
    80002a46:	6be2                	ld	s7,24(sp)
    80002a48:	6c42                	ld	s8,16(sp)
    80002a4a:	6ca2                	ld	s9,8(sp)
    80002a4c:	6d02                	ld	s10,0(sp)
    80002a4e:	6125                	addi	sp,sp,96
    80002a50:	8082                	ret
            release(&np->lock);
    80002a52:	8526                	mv	a0,s1
    80002a54:	ffffe097          	auipc	ra,0xffffe
    80002a58:	3e8080e7          	jalr	1000(ra) # 80000e3c <release>
            release(&wait_lock);
    80002a5c:	0022e517          	auipc	a0,0x22e
    80002a60:	15450513          	addi	a0,a0,340 # 80230bb0 <wait_lock>
    80002a64:	ffffe097          	auipc	ra,0xffffe
    80002a68:	3d8080e7          	jalr	984(ra) # 80000e3c <release>
            return -1;
    80002a6c:	59fd                	li	s3,-1
    80002a6e:	b7d9                	j	80002a34 <waitx+0xb0>
    for (np = proc; np < &proc[NPROC]; np++)
    80002a70:	17848493          	addi	s1,s1,376
    80002a74:	03348463          	beq	s1,s3,80002a9c <waitx+0x118>
      if (np->parent == p)
    80002a78:	7c9c                	ld	a5,56(s1)
    80002a7a:	ff279be3          	bne	a5,s2,80002a70 <waitx+0xec>
        acquire(&np->lock);
    80002a7e:	8526                	mv	a0,s1
    80002a80:	ffffe097          	auipc	ra,0xffffe
    80002a84:	308080e7          	jalr	776(ra) # 80000d88 <acquire>
        if (np->state == ZOMBIE)
    80002a88:	4c9c                	lw	a5,24(s1)
    80002a8a:	f54787e3          	beq	a5,s4,800029d8 <waitx+0x54>
        release(&np->lock);
    80002a8e:	8526                	mv	a0,s1
    80002a90:	ffffe097          	auipc	ra,0xffffe
    80002a94:	3ac080e7          	jalr	940(ra) # 80000e3c <release>
        havekids = 1;
    80002a98:	8756                	mv	a4,s5
    80002a9a:	bfd9                	j	80002a70 <waitx+0xec>
    if (!havekids || p->killed)
    80002a9c:	c305                	beqz	a4,80002abc <waitx+0x138>
    80002a9e:	02892783          	lw	a5,40(s2)
    80002aa2:	ef89                	bnez	a5,80002abc <waitx+0x138>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002aa4:	85ea                	mv	a1,s10
    80002aa6:	854a                	mv	a0,s2
    80002aa8:	00000097          	auipc	ra,0x0
    80002aac:	96c080e7          	jalr	-1684(ra) # 80002414 <sleep>
    havekids = 0;
    80002ab0:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002ab2:	0022e497          	auipc	s1,0x22e
    80002ab6:	51648493          	addi	s1,s1,1302 # 80230fc8 <proc>
    80002aba:	bf7d                	j	80002a78 <waitx+0xf4>
      release(&wait_lock);
    80002abc:	0022e517          	auipc	a0,0x22e
    80002ac0:	0f450513          	addi	a0,a0,244 # 80230bb0 <wait_lock>
    80002ac4:	ffffe097          	auipc	ra,0xffffe
    80002ac8:	378080e7          	jalr	888(ra) # 80000e3c <release>
      return -1;
    80002acc:	59fd                	li	s3,-1
    80002ace:	b79d                	j	80002a34 <waitx+0xb0>

0000000080002ad0 <update_time>:

void update_time()
{
    80002ad0:	7179                	addi	sp,sp,-48
    80002ad2:	f406                	sd	ra,40(sp)
    80002ad4:	f022                	sd	s0,32(sp)
    80002ad6:	ec26                	sd	s1,24(sp)
    80002ad8:	e84a                	sd	s2,16(sp)
    80002ada:	e44e                	sd	s3,8(sp)
    80002adc:	1800                	addi	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002ade:	0022e497          	auipc	s1,0x22e
    80002ae2:	4ea48493          	addi	s1,s1,1258 # 80230fc8 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002ae6:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    80002ae8:	00234917          	auipc	s2,0x234
    80002aec:	2e090913          	addi	s2,s2,736 # 80236dc8 <tickslock>
    80002af0:	a811                	j	80002b04 <update_time+0x34>
    {
      p->rtime++;
    }
    release(&p->lock);
    80002af2:	8526                	mv	a0,s1
    80002af4:	ffffe097          	auipc	ra,0xffffe
    80002af8:	348080e7          	jalr	840(ra) # 80000e3c <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002afc:	17848493          	addi	s1,s1,376
    80002b00:	03248063          	beq	s1,s2,80002b20 <update_time+0x50>
    acquire(&p->lock);
    80002b04:	8526                	mv	a0,s1
    80002b06:	ffffe097          	auipc	ra,0xffffe
    80002b0a:	282080e7          	jalr	642(ra) # 80000d88 <acquire>
    if (p->state == RUNNING)
    80002b0e:	4c9c                	lw	a5,24(s1)
    80002b10:	ff3791e3          	bne	a5,s3,80002af2 <update_time+0x22>
      p->rtime++;
    80002b14:	1684a783          	lw	a5,360(s1)
    80002b18:	2785                	addiw	a5,a5,1
    80002b1a:	16f4a423          	sw	a5,360(s1)
    80002b1e:	bfd1                	j	80002af2 <update_time+0x22>
  }
    80002b20:	70a2                	ld	ra,40(sp)
    80002b22:	7402                	ld	s0,32(sp)
    80002b24:	64e2                	ld	s1,24(sp)
    80002b26:	6942                	ld	s2,16(sp)
    80002b28:	69a2                	ld	s3,8(sp)
    80002b2a:	6145                	addi	sp,sp,48
    80002b2c:	8082                	ret

0000000080002b2e <swtch>:
    80002b2e:	00153023          	sd	ra,0(a0)
    80002b32:	00253423          	sd	sp,8(a0)
    80002b36:	e900                	sd	s0,16(a0)
    80002b38:	ed04                	sd	s1,24(a0)
    80002b3a:	03253023          	sd	s2,32(a0)
    80002b3e:	03353423          	sd	s3,40(a0)
    80002b42:	03453823          	sd	s4,48(a0)
    80002b46:	03553c23          	sd	s5,56(a0)
    80002b4a:	05653023          	sd	s6,64(a0)
    80002b4e:	05753423          	sd	s7,72(a0)
    80002b52:	05853823          	sd	s8,80(a0)
    80002b56:	05953c23          	sd	s9,88(a0)
    80002b5a:	07a53023          	sd	s10,96(a0)
    80002b5e:	07b53423          	sd	s11,104(a0)
    80002b62:	0005b083          	ld	ra,0(a1)
    80002b66:	0085b103          	ld	sp,8(a1)
    80002b6a:	6980                	ld	s0,16(a1)
    80002b6c:	6d84                	ld	s1,24(a1)
    80002b6e:	0205b903          	ld	s2,32(a1)
    80002b72:	0285b983          	ld	s3,40(a1)
    80002b76:	0305ba03          	ld	s4,48(a1)
    80002b7a:	0385ba83          	ld	s5,56(a1)
    80002b7e:	0405bb03          	ld	s6,64(a1)
    80002b82:	0485bb83          	ld	s7,72(a1)
    80002b86:	0505bc03          	ld	s8,80(a1)
    80002b8a:	0585bc83          	ld	s9,88(a1)
    80002b8e:	0605bd03          	ld	s10,96(a1)
    80002b92:	0685bd83          	ld	s11,104(a1)
    80002b96:	8082                	ret

0000000080002b98 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002b98:	1141                	addi	sp,sp,-16
    80002b9a:	e406                	sd	ra,8(sp)
    80002b9c:	e022                	sd	s0,0(sp)
    80002b9e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002ba0:	00005597          	auipc	a1,0x5
    80002ba4:	75858593          	addi	a1,a1,1880 # 800082f8 <etext+0x2f8>
    80002ba8:	00234517          	auipc	a0,0x234
    80002bac:	22050513          	addi	a0,a0,544 # 80236dc8 <tickslock>
    80002bb0:	ffffe097          	auipc	ra,0xffffe
    80002bb4:	148080e7          	jalr	328(ra) # 80000cf8 <initlock>
}
    80002bb8:	60a2                	ld	ra,8(sp)
    80002bba:	6402                	ld	s0,0(sp)
    80002bbc:	0141                	addi	sp,sp,16
    80002bbe:	8082                	ret

0000000080002bc0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002bc0:	1141                	addi	sp,sp,-16
    80002bc2:	e422                	sd	s0,8(sp)
    80002bc4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bc6:	00004797          	auipc	a5,0x4
    80002bca:	84a78793          	addi	a5,a5,-1974 # 80006410 <kernelvec>
    80002bce:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002bd2:	6422                	ld	s0,8(sp)
    80002bd4:	0141                	addi	sp,sp,16
    80002bd6:	8082                	ret

0000000080002bd8 <iscowpage>:


int iscowpage(uint64 va){
    80002bd8:	1101                	addi	sp,sp,-32
    80002bda:	ec06                	sd	ra,24(sp)
    80002bdc:	e822                	sd	s0,16(sp)
    80002bde:	e426                	sd	s1,8(sp)
    80002be0:	1000                	addi	s0,sp,32
    80002be2:	84aa                	mv	s1,a0
  pte_t *pte;
  struct proc *p = myproc();
    80002be4:	fffff097          	auipc	ra,0xfffff
    80002be8:	158080e7          	jalr	344(ra) # 80001d3c <myproc>
  
  return va < p->sz  && ((pte = walk(p->pagetable, va, 0))!=0) && (*pte & PTE_V) && (*pte & PTE_COW); 
    80002bec:	653c                	ld	a5,72(a0)
    80002bee:	00f4e863          	bltu	s1,a5,80002bfe <iscowpage+0x26>
    80002bf2:	4501                	li	a0,0
}
    80002bf4:	60e2                	ld	ra,24(sp)
    80002bf6:	6442                	ld	s0,16(sp)
    80002bf8:	64a2                	ld	s1,8(sp)
    80002bfa:	6105                	addi	sp,sp,32
    80002bfc:	8082                	ret
  return va < p->sz  && ((pte = walk(p->pagetable, va, 0))!=0) && (*pte & PTE_V) && (*pte & PTE_COW); 
    80002bfe:	4601                	li	a2,0
    80002c00:	85a6                	mv	a1,s1
    80002c02:	6928                	ld	a0,80(a0)
    80002c04:	ffffe097          	auipc	ra,0xffffe
    80002c08:	55c080e7          	jalr	1372(ra) # 80001160 <walk>
    80002c0c:	87aa                	mv	a5,a0
    80002c0e:	4501                	li	a0,0
    80002c10:	d3f5                	beqz	a5,80002bf4 <iscowpage+0x1c>
    80002c12:	6388                	ld	a0,0(a5)
    80002c14:	10157513          	andi	a0,a0,257
    80002c18:	eff50513          	addi	a0,a0,-257
    80002c1c:	00153513          	seqz	a0,a0
    80002c20:	bfd1                	j	80002bf4 <iscowpage+0x1c>

0000000080002c22 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002c22:	1141                	addi	sp,sp,-16
    80002c24:	e406                	sd	ra,8(sp)
    80002c26:	e022                	sd	s0,0(sp)
    80002c28:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002c2a:	fffff097          	auipc	ra,0xfffff
    80002c2e:	112080e7          	jalr	274(ra) # 80001d3c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c32:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002c36:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c38:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002c3c:	00004697          	auipc	a3,0x4
    80002c40:	3c468693          	addi	a3,a3,964 # 80007000 <_trampoline>
    80002c44:	00004717          	auipc	a4,0x4
    80002c48:	3bc70713          	addi	a4,a4,956 # 80007000 <_trampoline>
    80002c4c:	8f15                	sub	a4,a4,a3
    80002c4e:	040007b7          	lui	a5,0x4000
    80002c52:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002c54:	07b2                	slli	a5,a5,0xc
    80002c56:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c58:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002c5c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002c5e:	18002673          	csrr	a2,satp
    80002c62:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002c64:	6d30                	ld	a2,88(a0)
    80002c66:	6138                	ld	a4,64(a0)
    80002c68:	6585                	lui	a1,0x1
    80002c6a:	972e                	add	a4,a4,a1
    80002c6c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002c6e:	6d38                	ld	a4,88(a0)
    80002c70:	00000617          	auipc	a2,0x0
    80002c74:	14660613          	addi	a2,a2,326 # 80002db6 <usertrap>
    80002c78:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002c7a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c7c:	8612                	mv	a2,tp
    80002c7e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c80:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002c84:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002c88:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c8c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002c90:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002c92:	6f18                	ld	a4,24(a4)
    80002c94:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002c98:	6928                	ld	a0,80(a0)
    80002c9a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002c9c:	00004717          	auipc	a4,0x4
    80002ca0:	40070713          	addi	a4,a4,1024 # 8000709c <userret>
    80002ca4:	8f15                	sub	a4,a4,a3
    80002ca6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002ca8:	577d                	li	a4,-1
    80002caa:	177e                	slli	a4,a4,0x3f
    80002cac:	8d59                	or	a0,a0,a4
    80002cae:	9782                	jalr	a5
}
    80002cb0:	60a2                	ld	ra,8(sp)
    80002cb2:	6402                	ld	s0,0(sp)
    80002cb4:	0141                	addi	sp,sp,16
    80002cb6:	8082                	ret

0000000080002cb8 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002cb8:	1101                	addi	sp,sp,-32
    80002cba:	ec06                	sd	ra,24(sp)
    80002cbc:	e822                	sd	s0,16(sp)
    80002cbe:	e426                	sd	s1,8(sp)
    80002cc0:	e04a                	sd	s2,0(sp)
    80002cc2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002cc4:	00234917          	auipc	s2,0x234
    80002cc8:	10490913          	addi	s2,s2,260 # 80236dc8 <tickslock>
    80002ccc:	854a                	mv	a0,s2
    80002cce:	ffffe097          	auipc	ra,0xffffe
    80002cd2:	0ba080e7          	jalr	186(ra) # 80000d88 <acquire>
  ticks++;
    80002cd6:	00006497          	auipc	s1,0x6
    80002cda:	c3a48493          	addi	s1,s1,-966 # 80008910 <ticks>
    80002cde:	409c                	lw	a5,0(s1)
    80002ce0:	2785                	addiw	a5,a5,1
    80002ce2:	c09c                	sw	a5,0(s1)
  update_time();
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	dec080e7          	jalr	-532(ra) # 80002ad0 <update_time>
  //   // {
  //   //   p->wtime++;
  //   // }
  //   release(&p->lock);
  // }
  wakeup(&ticks);
    80002cec:	8526                	mv	a0,s1
    80002cee:	fffff097          	auipc	ra,0xfffff
    80002cf2:	78a080e7          	jalr	1930(ra) # 80002478 <wakeup>
  release(&tickslock);
    80002cf6:	854a                	mv	a0,s2
    80002cf8:	ffffe097          	auipc	ra,0xffffe
    80002cfc:	144080e7          	jalr	324(ra) # 80000e3c <release>
}
    80002d00:	60e2                	ld	ra,24(sp)
    80002d02:	6442                	ld	s0,16(sp)
    80002d04:	64a2                	ld	s1,8(sp)
    80002d06:	6902                	ld	s2,0(sp)
    80002d08:	6105                	addi	sp,sp,32
    80002d0a:	8082                	ret

0000000080002d0c <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d0c:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80002d10:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80002d12:	0a07d163          	bgez	a5,80002db4 <devintr+0xa8>
{
    80002d16:	1101                	addi	sp,sp,-32
    80002d18:	ec06                	sd	ra,24(sp)
    80002d1a:	e822                	sd	s0,16(sp)
    80002d1c:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80002d1e:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80002d22:	46a5                	li	a3,9
    80002d24:	00d70c63          	beq	a4,a3,80002d3c <devintr+0x30>
  else if (scause == 0x8000000000000001L)
    80002d28:	577d                	li	a4,-1
    80002d2a:	177e                	slli	a4,a4,0x3f
    80002d2c:	0705                	addi	a4,a4,1
    return 0;
    80002d2e:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002d30:	06e78163          	beq	a5,a4,80002d92 <devintr+0x86>
  }
}
    80002d34:	60e2                	ld	ra,24(sp)
    80002d36:	6442                	ld	s0,16(sp)
    80002d38:	6105                	addi	sp,sp,32
    80002d3a:	8082                	ret
    80002d3c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002d3e:	00003097          	auipc	ra,0x3
    80002d42:	7de080e7          	jalr	2014(ra) # 8000651c <plic_claim>
    80002d46:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002d48:	47a9                	li	a5,10
    80002d4a:	00f50963          	beq	a0,a5,80002d5c <devintr+0x50>
    else if (irq == VIRTIO0_IRQ)
    80002d4e:	4785                	li	a5,1
    80002d50:	00f50b63          	beq	a0,a5,80002d66 <devintr+0x5a>
    return 1;
    80002d54:	4505                	li	a0,1
    else if (irq)
    80002d56:	ec89                	bnez	s1,80002d70 <devintr+0x64>
    80002d58:	64a2                	ld	s1,8(sp)
    80002d5a:	bfe9                	j	80002d34 <devintr+0x28>
      uartintr();
    80002d5c:	ffffe097          	auipc	ra,0xffffe
    80002d60:	c9e080e7          	jalr	-866(ra) # 800009fa <uartintr>
    if (irq)
    80002d64:	a839                	j	80002d82 <devintr+0x76>
      virtio_disk_intr();
    80002d66:	00004097          	auipc	ra,0x4
    80002d6a:	ce0080e7          	jalr	-800(ra) # 80006a46 <virtio_disk_intr>
    if (irq)
    80002d6e:	a811                	j	80002d82 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002d70:	85a6                	mv	a1,s1
    80002d72:	00005517          	auipc	a0,0x5
    80002d76:	58e50513          	addi	a0,a0,1422 # 80008300 <etext+0x300>
    80002d7a:	ffffe097          	auipc	ra,0xffffe
    80002d7e:	830080e7          	jalr	-2000(ra) # 800005aa <printf>
      plic_complete(irq);
    80002d82:	8526                	mv	a0,s1
    80002d84:	00003097          	auipc	ra,0x3
    80002d88:	7bc080e7          	jalr	1980(ra) # 80006540 <plic_complete>
    return 1;
    80002d8c:	4505                	li	a0,1
    80002d8e:	64a2                	ld	s1,8(sp)
    80002d90:	b755                	j	80002d34 <devintr+0x28>
    if (cpuid() == 0)
    80002d92:	fffff097          	auipc	ra,0xfffff
    80002d96:	f7e080e7          	jalr	-130(ra) # 80001d10 <cpuid>
    80002d9a:	c901                	beqz	a0,80002daa <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002d9c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002da0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002da2:	14479073          	csrw	sip,a5
    return 2;
    80002da6:	4509                	li	a0,2
    80002da8:	b771                	j	80002d34 <devintr+0x28>
      clockintr();
    80002daa:	00000097          	auipc	ra,0x0
    80002dae:	f0e080e7          	jalr	-242(ra) # 80002cb8 <clockintr>
    80002db2:	b7ed                	j	80002d9c <devintr+0x90>
}
    80002db4:	8082                	ret

0000000080002db6 <usertrap>:
{
    80002db6:	7139                	addi	sp,sp,-64
    80002db8:	fc06                	sd	ra,56(sp)
    80002dba:	f822                	sd	s0,48(sp)
    80002dbc:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dbe:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002dc2:	1007f793          	andi	a5,a5,256
    80002dc6:	e7c9                	bnez	a5,80002e50 <usertrap+0x9a>
    80002dc8:	f426                	sd	s1,40(sp)
    80002dca:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002dcc:	00003797          	auipc	a5,0x3
    80002dd0:	64478793          	addi	a5,a5,1604 # 80006410 <kernelvec>
    80002dd4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002dd8:	fffff097          	auipc	ra,0xfffff
    80002ddc:	f64080e7          	jalr	-156(ra) # 80001d3c <myproc>
    80002de0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002de2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002de4:	14102773          	csrr	a4,sepc
    80002de8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002dea:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002dee:	47a1                	li	a5,8
    80002df0:	06f70e63          	beq	a4,a5,80002e6c <usertrap+0xb6>
  else if ((which_dev = devintr()) != 0)
    80002df4:	00000097          	auipc	ra,0x0
    80002df8:	f18080e7          	jalr	-232(ra) # 80002d0c <devintr>
    80002dfc:	892a                	mv	s2,a0
    80002dfe:	24051863          	bnez	a0,8000304e <usertrap+0x298>
    80002e02:	14202773          	csrr	a4,scause
else if((r_scause() == 15 || r_scause() == 13) && iscowpage(r_stval()) ){ 
    80002e06:	47bd                	li	a5,15
    80002e08:	0af70c63          	beq	a4,a5,80002ec0 <usertrap+0x10a>
    80002e0c:	14202773          	csrr	a4,scause
    80002e10:	47b5                	li	a5,13
    80002e12:	0af70763          	beq	a4,a5,80002ec0 <usertrap+0x10a>
    80002e16:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002e1a:	5890                	lw	a2,48(s1)
    80002e1c:	00005517          	auipc	a0,0x5
    80002e20:	52450513          	addi	a0,a0,1316 # 80008340 <etext+0x340>
    80002e24:	ffffd097          	auipc	ra,0xffffd
    80002e28:	786080e7          	jalr	1926(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e2c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e30:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e34:	00005517          	auipc	a0,0x5
    80002e38:	53c50513          	addi	a0,a0,1340 # 80008370 <etext+0x370>
    80002e3c:	ffffd097          	auipc	ra,0xffffd
    80002e40:	76e080e7          	jalr	1902(ra) # 800005aa <printf>
    setkilled(p);
    80002e44:	8526                	mv	a0,s1
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	856080e7          	jalr	-1962(ra) # 8000269c <setkilled>
    80002e4e:	a091                	j	80002e92 <usertrap+0xdc>
    80002e50:	f426                	sd	s1,40(sp)
    80002e52:	f04a                	sd	s2,32(sp)
    80002e54:	ec4e                	sd	s3,24(sp)
    80002e56:	e852                	sd	s4,16(sp)
    80002e58:	e456                	sd	s5,8(sp)
    80002e5a:	e05a                	sd	s6,0(sp)
    panic("usertrap: not from user mode");
    80002e5c:	00005517          	auipc	a0,0x5
    80002e60:	4c450513          	addi	a0,a0,1220 # 80008320 <etext+0x320>
    80002e64:	ffffd097          	auipc	ra,0xffffd
    80002e68:	6fc080e7          	jalr	1788(ra) # 80000560 <panic>
    if (killed(p))
    80002e6c:	00000097          	auipc	ra,0x0
    80002e70:	85c080e7          	jalr	-1956(ra) # 800026c8 <killed>
    80002e74:	e121                	bnez	a0,80002eb4 <usertrap+0xfe>
    p->trapframe->epc += 4;
    80002e76:	6cb8                	ld	a4,88(s1)
    80002e78:	6f1c                	ld	a5,24(a4)
    80002e7a:	0791                	addi	a5,a5,4
    80002e7c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e7e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e82:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e86:	10079073          	csrw	sstatus,a5
    syscall();
    80002e8a:	00000097          	auipc	ra,0x0
    80002e8e:	438080e7          	jalr	1080(ra) # 800032c2 <syscall>
  if (killed(p))
    80002e92:	8526                	mv	a0,s1
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	834080e7          	jalr	-1996(ra) # 800026c8 <killed>
    80002e9c:	1c051063          	bnez	a0,8000305c <usertrap+0x2a6>
  usertrapret();
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	d82080e7          	jalr	-638(ra) # 80002c22 <usertrapret>
    80002ea8:	74a2                	ld	s1,40(sp)
    80002eaa:	7902                	ld	s2,32(sp)
}
    80002eac:	70e2                	ld	ra,56(sp)
    80002eae:	7442                	ld	s0,48(sp)
    80002eb0:	6121                	addi	sp,sp,64
    80002eb2:	8082                	ret
      exit(-1);
    80002eb4:	557d                	li	a0,-1
    80002eb6:	fffff097          	auipc	ra,0xfffff
    80002eba:	692080e7          	jalr	1682(ra) # 80002548 <exit>
    80002ebe:	bf65                	j	80002e76 <usertrap+0xc0>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ec0:	14302573          	csrr	a0,stval
else if((r_scause() == 15 || r_scause() == 13) && iscowpage(r_stval()) ){ 
    80002ec4:	00000097          	auipc	ra,0x0
    80002ec8:	d14080e7          	jalr	-748(ra) # 80002bd8 <iscowpage>
    80002ecc:	d529                	beqz	a0,80002e16 <usertrap+0x60>
    80002ece:	ec4e                	sd	s3,24(sp)
    80002ed0:	e852                	sd	s4,16(sp)
    80002ed2:	e456                	sd	s5,8(sp)
    struct proc *p = myproc();
    80002ed4:	fffff097          	auipc	ra,0xfffff
    80002ed8:	e68080e7          	jalr	-408(ra) # 80001d3c <myproc>
    80002edc:	892a                	mv	s2,a0
    80002ede:	14302af3          	csrr	s5,stval
    p->pagefaultcount++;
    80002ee2:	17452783          	lw	a5,372(a0)
    80002ee6:	2785                	addiw	a5,a5,1
    80002ee8:	16f52a23          	sw	a5,372(a0)
    pte_t *req_pte = walk(p->pagetable, va, 0);
    80002eec:	4601                	li	a2,0
    80002eee:	85d6                	mv	a1,s5
    80002ef0:	6928                	ld	a0,80(a0)
    80002ef2:	ffffe097          	auipc	ra,0xffffe
    80002ef6:	26e080e7          	jalr	622(ra) # 80001160 <walk>
    80002efa:	8a2a                	mv	s4,a0
    if(req_pte == 0 || (*req_pte & PTE_V) == 0) {
    80002efc:	c501                	beqz	a0,80002f04 <usertrap+0x14e>
    80002efe:	611c                	ld	a5,0(a0)
    80002f00:	8b85                	andi	a5,a5,1
    80002f02:	eb89                	bnez	a5,80002f14 <usertrap+0x15e>
      p->killed = 1;
    80002f04:	4785                	li	a5,1
    80002f06:	02f92423          	sw	a5,40(s2)
      exit(-1);
    80002f0a:	557d                	li	a0,-1
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	63c080e7          	jalr	1596(ra) # 80002548 <exit>
    uint64 pa = PTE2PA(*req_pte);
    80002f14:	000a3983          	ld	s3,0(s4)
    80002f18:	00a9d993          	srli	s3,s3,0xa
    80002f1c:	09b2                	slli	s3,s3,0xc
    if(pa == 0){
    80002f1e:	06098163          	beqz	s3,80002f80 <usertrap+0x1ca>
    acquire(&ref_page_lock);
    80002f22:	0000e517          	auipc	a0,0xe
    80002f26:	c3e50513          	addi	a0,a0,-962 # 80010b60 <ref_page_lock>
    80002f2a:	ffffe097          	auipc	ra,0xffffe
    80002f2e:	e5e080e7          	jalr	-418(ra) # 80000d88 <acquire>
    if(reference_counter[pa/PGSIZE] > 1) {
    80002f32:	00a9d713          	srli	a4,s3,0xa
    80002f36:	0000e797          	auipc	a5,0xe
    80002f3a:	c6278793          	addi	a5,a5,-926 # 80010b98 <reference_counter>
    80002f3e:	97ba                	add	a5,a5,a4
    80002f40:	439c                	lw	a5,0(a5)
    80002f42:	4705                	li	a4,1
    80002f44:	04f74763          	blt	a4,a5,80002f92 <usertrap+0x1dc>
    else if(reference_counter[pa/PGSIZE] == 1) {
    80002f48:	4705                	li	a4,1
    80002f4a:	0ee78163          	beq	a5,a4,8000302c <usertrap+0x276>
      p->killed = 1;
    80002f4e:	4785                	li	a5,1
    80002f50:	02f92423          	sw	a5,40(s2)
      release(&ref_page_lock);
    80002f54:	0000e517          	auipc	a0,0xe
    80002f58:	c0c50513          	addi	a0,a0,-1012 # 80010b60 <ref_page_lock>
    80002f5c:	ffffe097          	auipc	ra,0xffffe
    80002f60:	ee0080e7          	jalr	-288(ra) # 80000e3c <release>
      exit(-1);
    80002f64:	557d                	li	a0,-1
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	5e2080e7          	jalr	1506(ra) # 80002548 <exit>
    p->trapframe->epc = r_sepc();
    80002f6e:	05893783          	ld	a5,88(s2)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f72:	14102773          	csrr	a4,sepc
    80002f76:	ef98                	sd	a4,24(a5)
else if((r_scause() == 15 || r_scause() == 13) && iscowpage(r_stval()) ){ 
    80002f78:	69e2                	ld	s3,24(sp)
    80002f7a:	6a42                	ld	s4,16(sp)
    80002f7c:	6aa2                	ld	s5,8(sp)
    80002f7e:	bf11                	j	80002e92 <usertrap+0xdc>
      p->killed = 1;
    80002f80:	4785                	li	a5,1
    80002f82:	02f92423          	sw	a5,40(s2)
      exit(-1);
    80002f86:	557d                	li	a0,-1
    80002f88:	fffff097          	auipc	ra,0xfffff
    80002f8c:	5c0080e7          	jalr	1472(ra) # 80002548 <exit>
    80002f90:	bf49                	j	80002f22 <usertrap+0x16c>
    80002f92:	e05a                	sd	s6,0(sp)
      release(&ref_page_lock);
    80002f94:	0000e517          	auipc	a0,0xe
    80002f98:	bcc50513          	addi	a0,a0,-1076 # 80010b60 <ref_page_lock>
    80002f9c:	ffffe097          	auipc	ra,0xffffe
    80002fa0:	ea0080e7          	jalr	-352(ra) # 80000e3c <release>
      uint flags = PTE_FLAGS(*req_pte);
    80002fa4:	000a3b03          	ld	s6,0(s4)
      flags &= ~PTE_COW;
    80002fa8:	2ffb7b13          	andi	s6,s6,767
    80002fac:	004b6b13          	ori	s6,s6,4
      char *new_page = kalloc();
    80002fb0:	ffffe097          	auipc	ra,0xffffe
    80002fb4:	cae080e7          	jalr	-850(ra) # 80000c5e <kalloc>
    80002fb8:	8a2a                	mv	s4,a0
      if(new_page == 0){
    80002fba:	c129                	beqz	a0,80002ffc <usertrap+0x246>
    uint64 page_va = PGROUNDDOWN(va);
    80002fbc:	77fd                	lui	a5,0xfffff
    80002fbe:	00fafab3          	and	s5,s5,a5
      memmove(new_page, (char*)pa, PGSIZE);
    80002fc2:	6605                	lui	a2,0x1
    80002fc4:	85ce                	mv	a1,s3
    80002fc6:	8552                	mv	a0,s4
    80002fc8:	ffffe097          	auipc	ra,0xffffe
    80002fcc:	f18080e7          	jalr	-232(ra) # 80000ee0 <memmove>
      uvmunmap(p->pagetable, page_va, 1, 1);  // free the page so that reference counter can get updated.
    80002fd0:	4685                	li	a3,1
    80002fd2:	4605                	li	a2,1
    80002fd4:	85d6                	mv	a1,s5
    80002fd6:	05093503          	ld	a0,80(s2)
    80002fda:	ffffe097          	auipc	ra,0xffffe
    80002fde:	434080e7          	jalr	1076(ra) # 8000140e <uvmunmap>
      if(mappages(p->pagetable, page_va, PGSIZE, (uint64)new_page, flags) != 0) {
    80002fe2:	875a                	mv	a4,s6
    80002fe4:	86d2                	mv	a3,s4
    80002fe6:	6605                	lui	a2,0x1
    80002fe8:	85d6                	mv	a1,s5
    80002fea:	05093503          	ld	a0,80(s2)
    80002fee:	ffffe097          	auipc	ra,0xffffe
    80002ff2:	25a080e7          	jalr	602(ra) # 80001248 <mappages>
    80002ff6:	ed01                	bnez	a0,8000300e <usertrap+0x258>
    80002ff8:	6b02                	ld	s6,0(sp)
    80002ffa:	bf95                	j	80002f6e <usertrap+0x1b8>
        p->killed = 1;
    80002ffc:	4785                	li	a5,1
    80002ffe:	02f92423          	sw	a5,40(s2)
        exit(-1);
    80003002:	557d                	li	a0,-1
    80003004:	fffff097          	auipc	ra,0xfffff
    80003008:	544080e7          	jalr	1348(ra) # 80002548 <exit>
    8000300c:	bf45                	j	80002fbc <usertrap+0x206>
        kfree(new_page);
    8000300e:	8552                	mv	a0,s4
    80003010:	ffffe097          	auipc	ra,0xffffe
    80003014:	a3a080e7          	jalr	-1478(ra) # 80000a4a <kfree>
        p->killed = 1;
    80003018:	4785                	li	a5,1
    8000301a:	02f92423          	sw	a5,40(s2)
        exit(-1);
    8000301e:	557d                	li	a0,-1
    80003020:	fffff097          	auipc	ra,0xfffff
    80003024:	528080e7          	jalr	1320(ra) # 80002548 <exit>
    80003028:	6b02                	ld	s6,0(sp)
    8000302a:	b791                	j	80002f6e <usertrap+0x1b8>
      release(&ref_page_lock);
    8000302c:	0000e517          	auipc	a0,0xe
    80003030:	b3450513          	addi	a0,a0,-1228 # 80010b60 <ref_page_lock>
    80003034:	ffffe097          	auipc	ra,0xffffe
    80003038:	e08080e7          	jalr	-504(ra) # 80000e3c <release>
      *req_pte &= ~PTE_COW;
    8000303c:	000a3783          	ld	a5,0(s4)
    80003040:	eff7f793          	andi	a5,a5,-257
      *req_pte |= PTE_W;
    80003044:	0047e793          	ori	a5,a5,4
    80003048:	00fa3023          	sd	a5,0(s4)
    8000304c:	b70d                	j	80002f6e <usertrap+0x1b8>
  if (killed(p))
    8000304e:	8526                	mv	a0,s1
    80003050:	fffff097          	auipc	ra,0xfffff
    80003054:	678080e7          	jalr	1656(ra) # 800026c8 <killed>
    80003058:	c901                	beqz	a0,80003068 <usertrap+0x2b2>
    8000305a:	a011                	j	8000305e <usertrap+0x2a8>
    8000305c:	4901                	li	s2,0
    exit(-1);
    8000305e:	557d                	li	a0,-1
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	4e8080e7          	jalr	1256(ra) # 80002548 <exit>
  if (which_dev == 2)
    80003068:	4789                	li	a5,2
    8000306a:	e2f91be3          	bne	s2,a5,80002ea0 <usertrap+0xea>
    yield();
    8000306e:	fffff097          	auipc	ra,0xfffff
    80003072:	36a080e7          	jalr	874(ra) # 800023d8 <yield>
    80003076:	b52d                	j	80002ea0 <usertrap+0xea>

0000000080003078 <kerneltrap>:
{
    80003078:	7179                	addi	sp,sp,-48
    8000307a:	f406                	sd	ra,40(sp)
    8000307c:	f022                	sd	s0,32(sp)
    8000307e:	ec26                	sd	s1,24(sp)
    80003080:	e84a                	sd	s2,16(sp)
    80003082:	e44e                	sd	s3,8(sp)
    80003084:	1800                	addi	s0,sp,48
    80003086:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000308a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000308e:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80003092:	1004f793          	andi	a5,s1,256
    80003096:	cb85                	beqz	a5,800030c6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003098:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000309c:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    8000309e:	ef85                	bnez	a5,800030d6 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    800030a0:	00000097          	auipc	ra,0x0
    800030a4:	c6c080e7          	jalr	-916(ra) # 80002d0c <devintr>
    800030a8:	cd1d                	beqz	a0,800030e6 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800030aa:	4789                	li	a5,2
    800030ac:	06f50a63          	beq	a0,a5,80003120 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800030b0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800030b4:	10049073          	csrw	sstatus,s1
}
    800030b8:	70a2                	ld	ra,40(sp)
    800030ba:	7402                	ld	s0,32(sp)
    800030bc:	64e2                	ld	s1,24(sp)
    800030be:	6942                	ld	s2,16(sp)
    800030c0:	69a2                	ld	s3,8(sp)
    800030c2:	6145                	addi	sp,sp,48
    800030c4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800030c6:	00005517          	auipc	a0,0x5
    800030ca:	2ca50513          	addi	a0,a0,714 # 80008390 <etext+0x390>
    800030ce:	ffffd097          	auipc	ra,0xffffd
    800030d2:	492080e7          	jalr	1170(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    800030d6:	00005517          	auipc	a0,0x5
    800030da:	2e250513          	addi	a0,a0,738 # 800083b8 <etext+0x3b8>
    800030de:	ffffd097          	auipc	ra,0xffffd
    800030e2:	482080e7          	jalr	1154(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    800030e6:	85ce                	mv	a1,s3
    800030e8:	00005517          	auipc	a0,0x5
    800030ec:	2f050513          	addi	a0,a0,752 # 800083d8 <etext+0x3d8>
    800030f0:	ffffd097          	auipc	ra,0xffffd
    800030f4:	4ba080e7          	jalr	1210(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800030f8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800030fc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003100:	00005517          	auipc	a0,0x5
    80003104:	2e850513          	addi	a0,a0,744 # 800083e8 <etext+0x3e8>
    80003108:	ffffd097          	auipc	ra,0xffffd
    8000310c:	4a2080e7          	jalr	1186(ra) # 800005aa <printf>
    panic("kerneltrap");
    80003110:	00005517          	auipc	a0,0x5
    80003114:	2f050513          	addi	a0,a0,752 # 80008400 <etext+0x400>
    80003118:	ffffd097          	auipc	ra,0xffffd
    8000311c:	448080e7          	jalr	1096(ra) # 80000560 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003120:	fffff097          	auipc	ra,0xfffff
    80003124:	c1c080e7          	jalr	-996(ra) # 80001d3c <myproc>
    80003128:	d541                	beqz	a0,800030b0 <kerneltrap+0x38>
    8000312a:	fffff097          	auipc	ra,0xfffff
    8000312e:	c12080e7          	jalr	-1006(ra) # 80001d3c <myproc>
    80003132:	4d18                	lw	a4,24(a0)
    80003134:	4791                	li	a5,4
    80003136:	f6f71de3          	bne	a4,a5,800030b0 <kerneltrap+0x38>
    yield();
    8000313a:	fffff097          	auipc	ra,0xfffff
    8000313e:	29e080e7          	jalr	670(ra) # 800023d8 <yield>
    80003142:	b7bd                	j	800030b0 <kerneltrap+0x38>

0000000080003144 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003144:	1101                	addi	sp,sp,-32
    80003146:	ec06                	sd	ra,24(sp)
    80003148:	e822                	sd	s0,16(sp)
    8000314a:	e426                	sd	s1,8(sp)
    8000314c:	1000                	addi	s0,sp,32
    8000314e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	bec080e7          	jalr	-1044(ra) # 80001d3c <myproc>
  switch (n) {
    80003158:	4795                	li	a5,5
    8000315a:	0497e163          	bltu	a5,s1,8000319c <argraw+0x58>
    8000315e:	048a                	slli	s1,s1,0x2
    80003160:	00005717          	auipc	a4,0x5
    80003164:	66070713          	addi	a4,a4,1632 # 800087c0 <states.0+0x30>
    80003168:	94ba                	add	s1,s1,a4
    8000316a:	409c                	lw	a5,0(s1)
    8000316c:	97ba                	add	a5,a5,a4
    8000316e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80003170:	6d3c                	ld	a5,88(a0)
    80003172:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003174:	60e2                	ld	ra,24(sp)
    80003176:	6442                	ld	s0,16(sp)
    80003178:	64a2                	ld	s1,8(sp)
    8000317a:	6105                	addi	sp,sp,32
    8000317c:	8082                	ret
    return p->trapframe->a1;
    8000317e:	6d3c                	ld	a5,88(a0)
    80003180:	7fa8                	ld	a0,120(a5)
    80003182:	bfcd                	j	80003174 <argraw+0x30>
    return p->trapframe->a2;
    80003184:	6d3c                	ld	a5,88(a0)
    80003186:	63c8                	ld	a0,128(a5)
    80003188:	b7f5                	j	80003174 <argraw+0x30>
    return p->trapframe->a3;
    8000318a:	6d3c                	ld	a5,88(a0)
    8000318c:	67c8                	ld	a0,136(a5)
    8000318e:	b7dd                	j	80003174 <argraw+0x30>
    return p->trapframe->a4;
    80003190:	6d3c                	ld	a5,88(a0)
    80003192:	6bc8                	ld	a0,144(a5)
    80003194:	b7c5                	j	80003174 <argraw+0x30>
    return p->trapframe->a5;
    80003196:	6d3c                	ld	a5,88(a0)
    80003198:	6fc8                	ld	a0,152(a5)
    8000319a:	bfe9                	j	80003174 <argraw+0x30>
  panic("argraw");
    8000319c:	00005517          	auipc	a0,0x5
    800031a0:	27450513          	addi	a0,a0,628 # 80008410 <etext+0x410>
    800031a4:	ffffd097          	auipc	ra,0xffffd
    800031a8:	3bc080e7          	jalr	956(ra) # 80000560 <panic>

00000000800031ac <fetchaddr>:
{
    800031ac:	1101                	addi	sp,sp,-32
    800031ae:	ec06                	sd	ra,24(sp)
    800031b0:	e822                	sd	s0,16(sp)
    800031b2:	e426                	sd	s1,8(sp)
    800031b4:	e04a                	sd	s2,0(sp)
    800031b6:	1000                	addi	s0,sp,32
    800031b8:	84aa                	mv	s1,a0
    800031ba:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800031bc:	fffff097          	auipc	ra,0xfffff
    800031c0:	b80080e7          	jalr	-1152(ra) # 80001d3c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800031c4:	653c                	ld	a5,72(a0)
    800031c6:	02f4f863          	bgeu	s1,a5,800031f6 <fetchaddr+0x4a>
    800031ca:	00848713          	addi	a4,s1,8
    800031ce:	02e7e663          	bltu	a5,a4,800031fa <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800031d2:	46a1                	li	a3,8
    800031d4:	8626                	mv	a2,s1
    800031d6:	85ca                	mv	a1,s2
    800031d8:	6928                	ld	a0,80(a0)
    800031da:	fffff097          	auipc	ra,0xfffff
    800031de:	886080e7          	jalr	-1914(ra) # 80001a60 <copyin>
    800031e2:	00a03533          	snez	a0,a0
    800031e6:	40a00533          	neg	a0,a0
}
    800031ea:	60e2                	ld	ra,24(sp)
    800031ec:	6442                	ld	s0,16(sp)
    800031ee:	64a2                	ld	s1,8(sp)
    800031f0:	6902                	ld	s2,0(sp)
    800031f2:	6105                	addi	sp,sp,32
    800031f4:	8082                	ret
    return -1;
    800031f6:	557d                	li	a0,-1
    800031f8:	bfcd                	j	800031ea <fetchaddr+0x3e>
    800031fa:	557d                	li	a0,-1
    800031fc:	b7fd                	j	800031ea <fetchaddr+0x3e>

00000000800031fe <fetchstr>:
{
    800031fe:	7179                	addi	sp,sp,-48
    80003200:	f406                	sd	ra,40(sp)
    80003202:	f022                	sd	s0,32(sp)
    80003204:	ec26                	sd	s1,24(sp)
    80003206:	e84a                	sd	s2,16(sp)
    80003208:	e44e                	sd	s3,8(sp)
    8000320a:	1800                	addi	s0,sp,48
    8000320c:	892a                	mv	s2,a0
    8000320e:	84ae                	mv	s1,a1
    80003210:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003212:	fffff097          	auipc	ra,0xfffff
    80003216:	b2a080e7          	jalr	-1238(ra) # 80001d3c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000321a:	86ce                	mv	a3,s3
    8000321c:	864a                	mv	a2,s2
    8000321e:	85a6                	mv	a1,s1
    80003220:	6928                	ld	a0,80(a0)
    80003222:	fffff097          	auipc	ra,0xfffff
    80003226:	8cc080e7          	jalr	-1844(ra) # 80001aee <copyinstr>
    8000322a:	00054e63          	bltz	a0,80003246 <fetchstr+0x48>
  return strlen(buf);
    8000322e:	8526                	mv	a0,s1
    80003230:	ffffe097          	auipc	ra,0xffffe
    80003234:	dc8080e7          	jalr	-568(ra) # 80000ff8 <strlen>
}
    80003238:	70a2                	ld	ra,40(sp)
    8000323a:	7402                	ld	s0,32(sp)
    8000323c:	64e2                	ld	s1,24(sp)
    8000323e:	6942                	ld	s2,16(sp)
    80003240:	69a2                	ld	s3,8(sp)
    80003242:	6145                	addi	sp,sp,48
    80003244:	8082                	ret
    return -1;
    80003246:	557d                	li	a0,-1
    80003248:	bfc5                	j	80003238 <fetchstr+0x3a>

000000008000324a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000324a:	1101                	addi	sp,sp,-32
    8000324c:	ec06                	sd	ra,24(sp)
    8000324e:	e822                	sd	s0,16(sp)
    80003250:	e426                	sd	s1,8(sp)
    80003252:	1000                	addi	s0,sp,32
    80003254:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	eee080e7          	jalr	-274(ra) # 80003144 <argraw>
    8000325e:	c088                	sw	a0,0(s1)
}
    80003260:	60e2                	ld	ra,24(sp)
    80003262:	6442                	ld	s0,16(sp)
    80003264:	64a2                	ld	s1,8(sp)
    80003266:	6105                	addi	sp,sp,32
    80003268:	8082                	ret

000000008000326a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000326a:	1101                	addi	sp,sp,-32
    8000326c:	ec06                	sd	ra,24(sp)
    8000326e:	e822                	sd	s0,16(sp)
    80003270:	e426                	sd	s1,8(sp)
    80003272:	1000                	addi	s0,sp,32
    80003274:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	ece080e7          	jalr	-306(ra) # 80003144 <argraw>
    8000327e:	e088                	sd	a0,0(s1)
}
    80003280:	60e2                	ld	ra,24(sp)
    80003282:	6442                	ld	s0,16(sp)
    80003284:	64a2                	ld	s1,8(sp)
    80003286:	6105                	addi	sp,sp,32
    80003288:	8082                	ret

000000008000328a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000328a:	7179                	addi	sp,sp,-48
    8000328c:	f406                	sd	ra,40(sp)
    8000328e:	f022                	sd	s0,32(sp)
    80003290:	ec26                	sd	s1,24(sp)
    80003292:	e84a                	sd	s2,16(sp)
    80003294:	1800                	addi	s0,sp,48
    80003296:	84ae                	mv	s1,a1
    80003298:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000329a:	fd840593          	addi	a1,s0,-40
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	fcc080e7          	jalr	-52(ra) # 8000326a <argaddr>
  return fetchstr(addr, buf, max);
    800032a6:	864a                	mv	a2,s2
    800032a8:	85a6                	mv	a1,s1
    800032aa:	fd843503          	ld	a0,-40(s0)
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	f50080e7          	jalr	-176(ra) # 800031fe <fetchstr>
}
    800032b6:	70a2                	ld	ra,40(sp)
    800032b8:	7402                	ld	s0,32(sp)
    800032ba:	64e2                	ld	s1,24(sp)
    800032bc:	6942                	ld	s2,16(sp)
    800032be:	6145                	addi	sp,sp,48
    800032c0:	8082                	ret

00000000800032c2 <syscall>:
[SYS_waitx]   sys_waitx,
};

void
syscall(void)
{
    800032c2:	1101                	addi	sp,sp,-32
    800032c4:	ec06                	sd	ra,24(sp)
    800032c6:	e822                	sd	s0,16(sp)
    800032c8:	e426                	sd	s1,8(sp)
    800032ca:	e04a                	sd	s2,0(sp)
    800032cc:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800032ce:	fffff097          	auipc	ra,0xfffff
    800032d2:	a6e080e7          	jalr	-1426(ra) # 80001d3c <myproc>
    800032d6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800032d8:	05853903          	ld	s2,88(a0)
    800032dc:	0a893783          	ld	a5,168(s2)
    800032e0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800032e4:	37fd                	addiw	a5,a5,-1 # ffffffffffffefff <end+0xffffffff7fdbce57>
    800032e6:	4755                	li	a4,21
    800032e8:	00f76f63          	bltu	a4,a5,80003306 <syscall+0x44>
    800032ec:	00369713          	slli	a4,a3,0x3
    800032f0:	00005797          	auipc	a5,0x5
    800032f4:	4e878793          	addi	a5,a5,1256 # 800087d8 <syscalls>
    800032f8:	97ba                	add	a5,a5,a4
    800032fa:	639c                	ld	a5,0(a5)
    800032fc:	c789                	beqz	a5,80003306 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800032fe:	9782                	jalr	a5
    80003300:	06a93823          	sd	a0,112(s2)
    80003304:	a839                	j	80003322 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003306:	15848613          	addi	a2,s1,344
    8000330a:	588c                	lw	a1,48(s1)
    8000330c:	00005517          	auipc	a0,0x5
    80003310:	10c50513          	addi	a0,a0,268 # 80008418 <etext+0x418>
    80003314:	ffffd097          	auipc	ra,0xffffd
    80003318:	296080e7          	jalr	662(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000331c:	6cbc                	ld	a5,88(s1)
    8000331e:	577d                	li	a4,-1
    80003320:	fbb8                	sd	a4,112(a5)
  }
}
    80003322:	60e2                	ld	ra,24(sp)
    80003324:	6442                	ld	s0,16(sp)
    80003326:	64a2                	ld	s1,8(sp)
    80003328:	6902                	ld	s2,0(sp)
    8000332a:	6105                	addi	sp,sp,32
    8000332c:	8082                	ret

000000008000332e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000332e:	1101                	addi	sp,sp,-32
    80003330:	ec06                	sd	ra,24(sp)
    80003332:	e822                	sd	s0,16(sp)
    80003334:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003336:	fec40593          	addi	a1,s0,-20
    8000333a:	4501                	li	a0,0
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	f0e080e7          	jalr	-242(ra) # 8000324a <argint>
  exit(n);
    80003344:	fec42503          	lw	a0,-20(s0)
    80003348:	fffff097          	auipc	ra,0xfffff
    8000334c:	200080e7          	jalr	512(ra) # 80002548 <exit>
  return 0; // not reached
}
    80003350:	4501                	li	a0,0
    80003352:	60e2                	ld	ra,24(sp)
    80003354:	6442                	ld	s0,16(sp)
    80003356:	6105                	addi	sp,sp,32
    80003358:	8082                	ret

000000008000335a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000335a:	1141                	addi	sp,sp,-16
    8000335c:	e406                	sd	ra,8(sp)
    8000335e:	e022                	sd	s0,0(sp)
    80003360:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003362:	fffff097          	auipc	ra,0xfffff
    80003366:	9da080e7          	jalr	-1574(ra) # 80001d3c <myproc>
}
    8000336a:	5908                	lw	a0,48(a0)
    8000336c:	60a2                	ld	ra,8(sp)
    8000336e:	6402                	ld	s0,0(sp)
    80003370:	0141                	addi	sp,sp,16
    80003372:	8082                	ret

0000000080003374 <sys_fork>:

uint64
sys_fork(void)
{
    80003374:	1141                	addi	sp,sp,-16
    80003376:	e406                	sd	ra,8(sp)
    80003378:	e022                	sd	s0,0(sp)
    8000337a:	0800                	addi	s0,sp,16
  return fork();
    8000337c:	fffff097          	auipc	ra,0xfffff
    80003380:	da4080e7          	jalr	-604(ra) # 80002120 <fork>
}
    80003384:	60a2                	ld	ra,8(sp)
    80003386:	6402                	ld	s0,0(sp)
    80003388:	0141                	addi	sp,sp,16
    8000338a:	8082                	ret

000000008000338c <sys_wait>:

uint64
sys_wait(void)
{
    8000338c:	1101                	addi	sp,sp,-32
    8000338e:	ec06                	sd	ra,24(sp)
    80003390:	e822                	sd	s0,16(sp)
    80003392:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003394:	fe840593          	addi	a1,s0,-24
    80003398:	4501                	li	a0,0
    8000339a:	00000097          	auipc	ra,0x0
    8000339e:	ed0080e7          	jalr	-304(ra) # 8000326a <argaddr>
  return wait(p);
    800033a2:	fe843503          	ld	a0,-24(s0)
    800033a6:	fffff097          	auipc	ra,0xfffff
    800033aa:	354080e7          	jalr	852(ra) # 800026fa <wait>
}
    800033ae:	60e2                	ld	ra,24(sp)
    800033b0:	6442                	ld	s0,16(sp)
    800033b2:	6105                	addi	sp,sp,32
    800033b4:	8082                	ret

00000000800033b6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800033b6:	7179                	addi	sp,sp,-48
    800033b8:	f406                	sd	ra,40(sp)
    800033ba:	f022                	sd	s0,32(sp)
    800033bc:	ec26                	sd	s1,24(sp)
    800033be:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800033c0:	fdc40593          	addi	a1,s0,-36
    800033c4:	4501                	li	a0,0
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	e84080e7          	jalr	-380(ra) # 8000324a <argint>
  addr = myproc()->sz;
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	96e080e7          	jalr	-1682(ra) # 80001d3c <myproc>
    800033d6:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800033d8:	fdc42503          	lw	a0,-36(s0)
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	ce8080e7          	jalr	-792(ra) # 800020c4 <growproc>
    800033e4:	00054863          	bltz	a0,800033f4 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800033e8:	8526                	mv	a0,s1
    800033ea:	70a2                	ld	ra,40(sp)
    800033ec:	7402                	ld	s0,32(sp)
    800033ee:	64e2                	ld	s1,24(sp)
    800033f0:	6145                	addi	sp,sp,48
    800033f2:	8082                	ret
    return -1;
    800033f4:	54fd                	li	s1,-1
    800033f6:	bfcd                	j	800033e8 <sys_sbrk+0x32>

00000000800033f8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800033f8:	7139                	addi	sp,sp,-64
    800033fa:	fc06                	sd	ra,56(sp)
    800033fc:	f822                	sd	s0,48(sp)
    800033fe:	f04a                	sd	s2,32(sp)
    80003400:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003402:	fcc40593          	addi	a1,s0,-52
    80003406:	4501                	li	a0,0
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	e42080e7          	jalr	-446(ra) # 8000324a <argint>
  acquire(&tickslock);
    80003410:	00234517          	auipc	a0,0x234
    80003414:	9b850513          	addi	a0,a0,-1608 # 80236dc8 <tickslock>
    80003418:	ffffe097          	auipc	ra,0xffffe
    8000341c:	970080e7          	jalr	-1680(ra) # 80000d88 <acquire>
  ticks0 = ticks;
    80003420:	00005917          	auipc	s2,0x5
    80003424:	4f092903          	lw	s2,1264(s2) # 80008910 <ticks>
  while (ticks - ticks0 < n)
    80003428:	fcc42783          	lw	a5,-52(s0)
    8000342c:	c3b9                	beqz	a5,80003472 <sys_sleep+0x7a>
    8000342e:	f426                	sd	s1,40(sp)
    80003430:	ec4e                	sd	s3,24(sp)
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003432:	00234997          	auipc	s3,0x234
    80003436:	99698993          	addi	s3,s3,-1642 # 80236dc8 <tickslock>
    8000343a:	00005497          	auipc	s1,0x5
    8000343e:	4d648493          	addi	s1,s1,1238 # 80008910 <ticks>
    if (killed(myproc()))
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	8fa080e7          	jalr	-1798(ra) # 80001d3c <myproc>
    8000344a:	fffff097          	auipc	ra,0xfffff
    8000344e:	27e080e7          	jalr	638(ra) # 800026c8 <killed>
    80003452:	ed15                	bnez	a0,8000348e <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003454:	85ce                	mv	a1,s3
    80003456:	8526                	mv	a0,s1
    80003458:	fffff097          	auipc	ra,0xfffff
    8000345c:	fbc080e7          	jalr	-68(ra) # 80002414 <sleep>
  while (ticks - ticks0 < n)
    80003460:	409c                	lw	a5,0(s1)
    80003462:	412787bb          	subw	a5,a5,s2
    80003466:	fcc42703          	lw	a4,-52(s0)
    8000346a:	fce7ece3          	bltu	a5,a4,80003442 <sys_sleep+0x4a>
    8000346e:	74a2                	ld	s1,40(sp)
    80003470:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003472:	00234517          	auipc	a0,0x234
    80003476:	95650513          	addi	a0,a0,-1706 # 80236dc8 <tickslock>
    8000347a:	ffffe097          	auipc	ra,0xffffe
    8000347e:	9c2080e7          	jalr	-1598(ra) # 80000e3c <release>
  return 0;
    80003482:	4501                	li	a0,0
}
    80003484:	70e2                	ld	ra,56(sp)
    80003486:	7442                	ld	s0,48(sp)
    80003488:	7902                	ld	s2,32(sp)
    8000348a:	6121                	addi	sp,sp,64
    8000348c:	8082                	ret
      release(&tickslock);
    8000348e:	00234517          	auipc	a0,0x234
    80003492:	93a50513          	addi	a0,a0,-1734 # 80236dc8 <tickslock>
    80003496:	ffffe097          	auipc	ra,0xffffe
    8000349a:	9a6080e7          	jalr	-1626(ra) # 80000e3c <release>
      return -1;
    8000349e:	557d                	li	a0,-1
    800034a0:	74a2                	ld	s1,40(sp)
    800034a2:	69e2                	ld	s3,24(sp)
    800034a4:	b7c5                	j	80003484 <sys_sleep+0x8c>

00000000800034a6 <sys_kill>:

uint64
sys_kill(void)
{
    800034a6:	1101                	addi	sp,sp,-32
    800034a8:	ec06                	sd	ra,24(sp)
    800034aa:	e822                	sd	s0,16(sp)
    800034ac:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800034ae:	fec40593          	addi	a1,s0,-20
    800034b2:	4501                	li	a0,0
    800034b4:	00000097          	auipc	ra,0x0
    800034b8:	d96080e7          	jalr	-618(ra) # 8000324a <argint>
  return kill(pid);
    800034bc:	fec42503          	lw	a0,-20(s0)
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	16a080e7          	jalr	362(ra) # 8000262a <kill>
}
    800034c8:	60e2                	ld	ra,24(sp)
    800034ca:	6442                	ld	s0,16(sp)
    800034cc:	6105                	addi	sp,sp,32
    800034ce:	8082                	ret

00000000800034d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800034d0:	1101                	addi	sp,sp,-32
    800034d2:	ec06                	sd	ra,24(sp)
    800034d4:	e822                	sd	s0,16(sp)
    800034d6:	e426                	sd	s1,8(sp)
    800034d8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800034da:	00234517          	auipc	a0,0x234
    800034de:	8ee50513          	addi	a0,a0,-1810 # 80236dc8 <tickslock>
    800034e2:	ffffe097          	auipc	ra,0xffffe
    800034e6:	8a6080e7          	jalr	-1882(ra) # 80000d88 <acquire>
  xticks = ticks;
    800034ea:	00005497          	auipc	s1,0x5
    800034ee:	4264a483          	lw	s1,1062(s1) # 80008910 <ticks>
  release(&tickslock);
    800034f2:	00234517          	auipc	a0,0x234
    800034f6:	8d650513          	addi	a0,a0,-1834 # 80236dc8 <tickslock>
    800034fa:	ffffe097          	auipc	ra,0xffffe
    800034fe:	942080e7          	jalr	-1726(ra) # 80000e3c <release>
  return xticks;
}
    80003502:	02049513          	slli	a0,s1,0x20
    80003506:	9101                	srli	a0,a0,0x20
    80003508:	60e2                	ld	ra,24(sp)
    8000350a:	6442                	ld	s0,16(sp)
    8000350c:	64a2                	ld	s1,8(sp)
    8000350e:	6105                	addi	sp,sp,32
    80003510:	8082                	ret

0000000080003512 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003512:	7139                	addi	sp,sp,-64
    80003514:	fc06                	sd	ra,56(sp)
    80003516:	f822                	sd	s0,48(sp)
    80003518:	f426                	sd	s1,40(sp)
    8000351a:	f04a                	sd	s2,32(sp)
    8000351c:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    8000351e:	fd840593          	addi	a1,s0,-40
    80003522:	4501                	li	a0,0
    80003524:	00000097          	auipc	ra,0x0
    80003528:	d46080e7          	jalr	-698(ra) # 8000326a <argaddr>
  argaddr(1, &addr1); // user virtual memory
    8000352c:	fd040593          	addi	a1,s0,-48
    80003530:	4505                	li	a0,1
    80003532:	00000097          	auipc	ra,0x0
    80003536:	d38080e7          	jalr	-712(ra) # 8000326a <argaddr>
  argaddr(2, &addr2);
    8000353a:	fc840593          	addi	a1,s0,-56
    8000353e:	4509                	li	a0,2
    80003540:	00000097          	auipc	ra,0x0
    80003544:	d2a080e7          	jalr	-726(ra) # 8000326a <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    80003548:	fc040613          	addi	a2,s0,-64
    8000354c:	fc440593          	addi	a1,s0,-60
    80003550:	fd843503          	ld	a0,-40(s0)
    80003554:	fffff097          	auipc	ra,0xfffff
    80003558:	430080e7          	jalr	1072(ra) # 80002984 <waitx>
    8000355c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000355e:	ffffe097          	auipc	ra,0xffffe
    80003562:	7de080e7          	jalr	2014(ra) # 80001d3c <myproc>
    80003566:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003568:	4691                	li	a3,4
    8000356a:	fc440613          	addi	a2,s0,-60
    8000356e:	fd043583          	ld	a1,-48(s0)
    80003572:	6928                	ld	a0,80(a0)
    80003574:	ffffe097          	auipc	ra,0xffffe
    80003578:	2fc080e7          	jalr	764(ra) # 80001870 <copyout>
    return -1;
    8000357c:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    8000357e:	00054f63          	bltz	a0,8000359c <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    80003582:	4691                	li	a3,4
    80003584:	fc040613          	addi	a2,s0,-64
    80003588:	fc843583          	ld	a1,-56(s0)
    8000358c:	68a8                	ld	a0,80(s1)
    8000358e:	ffffe097          	auipc	ra,0xffffe
    80003592:	2e2080e7          	jalr	738(ra) # 80001870 <copyout>
    80003596:	00054a63          	bltz	a0,800035aa <sys_waitx+0x98>
    return -1;
  return ret;
    8000359a:	87ca                	mv	a5,s2
    8000359c:	853e                	mv	a0,a5
    8000359e:	70e2                	ld	ra,56(sp)
    800035a0:	7442                	ld	s0,48(sp)
    800035a2:	74a2                	ld	s1,40(sp)
    800035a4:	7902                	ld	s2,32(sp)
    800035a6:	6121                	addi	sp,sp,64
    800035a8:	8082                	ret
    return -1;
    800035aa:	57fd                	li	a5,-1
    800035ac:	bfc5                	j	8000359c <sys_waitx+0x8a>

00000000800035ae <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800035ae:	7179                	addi	sp,sp,-48
    800035b0:	f406                	sd	ra,40(sp)
    800035b2:	f022                	sd	s0,32(sp)
    800035b4:	ec26                	sd	s1,24(sp)
    800035b6:	e84a                	sd	s2,16(sp)
    800035b8:	e44e                	sd	s3,8(sp)
    800035ba:	e052                	sd	s4,0(sp)
    800035bc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800035be:	00005597          	auipc	a1,0x5
    800035c2:	e7a58593          	addi	a1,a1,-390 # 80008438 <etext+0x438>
    800035c6:	00234517          	auipc	a0,0x234
    800035ca:	81a50513          	addi	a0,a0,-2022 # 80236de0 <bcache>
    800035ce:	ffffd097          	auipc	ra,0xffffd
    800035d2:	72a080e7          	jalr	1834(ra) # 80000cf8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800035d6:	0023c797          	auipc	a5,0x23c
    800035da:	80a78793          	addi	a5,a5,-2038 # 8023ede0 <bcache+0x8000>
    800035de:	0023c717          	auipc	a4,0x23c
    800035e2:	a6a70713          	addi	a4,a4,-1430 # 8023f048 <bcache+0x8268>
    800035e6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800035ea:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800035ee:	00234497          	auipc	s1,0x234
    800035f2:	80a48493          	addi	s1,s1,-2038 # 80236df8 <bcache+0x18>
    b->next = bcache.head.next;
    800035f6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800035f8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800035fa:	00005a17          	auipc	s4,0x5
    800035fe:	e46a0a13          	addi	s4,s4,-442 # 80008440 <etext+0x440>
    b->next = bcache.head.next;
    80003602:	2b893783          	ld	a5,696(s2)
    80003606:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003608:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000360c:	85d2                	mv	a1,s4
    8000360e:	01048513          	addi	a0,s1,16
    80003612:	00001097          	auipc	ra,0x1
    80003616:	4e8080e7          	jalr	1256(ra) # 80004afa <initsleeplock>
    bcache.head.next->prev = b;
    8000361a:	2b893783          	ld	a5,696(s2)
    8000361e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003620:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003624:	45848493          	addi	s1,s1,1112
    80003628:	fd349de3          	bne	s1,s3,80003602 <binit+0x54>
  }
}
    8000362c:	70a2                	ld	ra,40(sp)
    8000362e:	7402                	ld	s0,32(sp)
    80003630:	64e2                	ld	s1,24(sp)
    80003632:	6942                	ld	s2,16(sp)
    80003634:	69a2                	ld	s3,8(sp)
    80003636:	6a02                	ld	s4,0(sp)
    80003638:	6145                	addi	sp,sp,48
    8000363a:	8082                	ret

000000008000363c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000363c:	7179                	addi	sp,sp,-48
    8000363e:	f406                	sd	ra,40(sp)
    80003640:	f022                	sd	s0,32(sp)
    80003642:	ec26                	sd	s1,24(sp)
    80003644:	e84a                	sd	s2,16(sp)
    80003646:	e44e                	sd	s3,8(sp)
    80003648:	1800                	addi	s0,sp,48
    8000364a:	892a                	mv	s2,a0
    8000364c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000364e:	00233517          	auipc	a0,0x233
    80003652:	79250513          	addi	a0,a0,1938 # 80236de0 <bcache>
    80003656:	ffffd097          	auipc	ra,0xffffd
    8000365a:	732080e7          	jalr	1842(ra) # 80000d88 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000365e:	0023c497          	auipc	s1,0x23c
    80003662:	a3a4b483          	ld	s1,-1478(s1) # 8023f098 <bcache+0x82b8>
    80003666:	0023c797          	auipc	a5,0x23c
    8000366a:	9e278793          	addi	a5,a5,-1566 # 8023f048 <bcache+0x8268>
    8000366e:	02f48f63          	beq	s1,a5,800036ac <bread+0x70>
    80003672:	873e                	mv	a4,a5
    80003674:	a021                	j	8000367c <bread+0x40>
    80003676:	68a4                	ld	s1,80(s1)
    80003678:	02e48a63          	beq	s1,a4,800036ac <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000367c:	449c                	lw	a5,8(s1)
    8000367e:	ff279ce3          	bne	a5,s2,80003676 <bread+0x3a>
    80003682:	44dc                	lw	a5,12(s1)
    80003684:	ff3799e3          	bne	a5,s3,80003676 <bread+0x3a>
      b->refcnt++;
    80003688:	40bc                	lw	a5,64(s1)
    8000368a:	2785                	addiw	a5,a5,1
    8000368c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000368e:	00233517          	auipc	a0,0x233
    80003692:	75250513          	addi	a0,a0,1874 # 80236de0 <bcache>
    80003696:	ffffd097          	auipc	ra,0xffffd
    8000369a:	7a6080e7          	jalr	1958(ra) # 80000e3c <release>
      acquiresleep(&b->lock);
    8000369e:	01048513          	addi	a0,s1,16
    800036a2:	00001097          	auipc	ra,0x1
    800036a6:	492080e7          	jalr	1170(ra) # 80004b34 <acquiresleep>
      return b;
    800036aa:	a8b9                	j	80003708 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800036ac:	0023c497          	auipc	s1,0x23c
    800036b0:	9e44b483          	ld	s1,-1564(s1) # 8023f090 <bcache+0x82b0>
    800036b4:	0023c797          	auipc	a5,0x23c
    800036b8:	99478793          	addi	a5,a5,-1644 # 8023f048 <bcache+0x8268>
    800036bc:	00f48863          	beq	s1,a5,800036cc <bread+0x90>
    800036c0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800036c2:	40bc                	lw	a5,64(s1)
    800036c4:	cf81                	beqz	a5,800036dc <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800036c6:	64a4                	ld	s1,72(s1)
    800036c8:	fee49de3          	bne	s1,a4,800036c2 <bread+0x86>
  panic("bget: no buffers");
    800036cc:	00005517          	auipc	a0,0x5
    800036d0:	d7c50513          	addi	a0,a0,-644 # 80008448 <etext+0x448>
    800036d4:	ffffd097          	auipc	ra,0xffffd
    800036d8:	e8c080e7          	jalr	-372(ra) # 80000560 <panic>
      b->dev = dev;
    800036dc:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800036e0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800036e4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800036e8:	4785                	li	a5,1
    800036ea:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800036ec:	00233517          	auipc	a0,0x233
    800036f0:	6f450513          	addi	a0,a0,1780 # 80236de0 <bcache>
    800036f4:	ffffd097          	auipc	ra,0xffffd
    800036f8:	748080e7          	jalr	1864(ra) # 80000e3c <release>
      acquiresleep(&b->lock);
    800036fc:	01048513          	addi	a0,s1,16
    80003700:	00001097          	auipc	ra,0x1
    80003704:	434080e7          	jalr	1076(ra) # 80004b34 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003708:	409c                	lw	a5,0(s1)
    8000370a:	cb89                	beqz	a5,8000371c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000370c:	8526                	mv	a0,s1
    8000370e:	70a2                	ld	ra,40(sp)
    80003710:	7402                	ld	s0,32(sp)
    80003712:	64e2                	ld	s1,24(sp)
    80003714:	6942                	ld	s2,16(sp)
    80003716:	69a2                	ld	s3,8(sp)
    80003718:	6145                	addi	sp,sp,48
    8000371a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000371c:	4581                	li	a1,0
    8000371e:	8526                	mv	a0,s1
    80003720:	00003097          	auipc	ra,0x3
    80003724:	0f8080e7          	jalr	248(ra) # 80006818 <virtio_disk_rw>
    b->valid = 1;
    80003728:	4785                	li	a5,1
    8000372a:	c09c                	sw	a5,0(s1)
  return b;
    8000372c:	b7c5                	j	8000370c <bread+0xd0>

000000008000372e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000372e:	1101                	addi	sp,sp,-32
    80003730:	ec06                	sd	ra,24(sp)
    80003732:	e822                	sd	s0,16(sp)
    80003734:	e426                	sd	s1,8(sp)
    80003736:	1000                	addi	s0,sp,32
    80003738:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000373a:	0541                	addi	a0,a0,16
    8000373c:	00001097          	auipc	ra,0x1
    80003740:	492080e7          	jalr	1170(ra) # 80004bce <holdingsleep>
    80003744:	cd01                	beqz	a0,8000375c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003746:	4585                	li	a1,1
    80003748:	8526                	mv	a0,s1
    8000374a:	00003097          	auipc	ra,0x3
    8000374e:	0ce080e7          	jalr	206(ra) # 80006818 <virtio_disk_rw>
}
    80003752:	60e2                	ld	ra,24(sp)
    80003754:	6442                	ld	s0,16(sp)
    80003756:	64a2                	ld	s1,8(sp)
    80003758:	6105                	addi	sp,sp,32
    8000375a:	8082                	ret
    panic("bwrite");
    8000375c:	00005517          	auipc	a0,0x5
    80003760:	d0450513          	addi	a0,a0,-764 # 80008460 <etext+0x460>
    80003764:	ffffd097          	auipc	ra,0xffffd
    80003768:	dfc080e7          	jalr	-516(ra) # 80000560 <panic>

000000008000376c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000376c:	1101                	addi	sp,sp,-32
    8000376e:	ec06                	sd	ra,24(sp)
    80003770:	e822                	sd	s0,16(sp)
    80003772:	e426                	sd	s1,8(sp)
    80003774:	e04a                	sd	s2,0(sp)
    80003776:	1000                	addi	s0,sp,32
    80003778:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000377a:	01050913          	addi	s2,a0,16
    8000377e:	854a                	mv	a0,s2
    80003780:	00001097          	auipc	ra,0x1
    80003784:	44e080e7          	jalr	1102(ra) # 80004bce <holdingsleep>
    80003788:	c925                	beqz	a0,800037f8 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000378a:	854a                	mv	a0,s2
    8000378c:	00001097          	auipc	ra,0x1
    80003790:	3fe080e7          	jalr	1022(ra) # 80004b8a <releasesleep>

  acquire(&bcache.lock);
    80003794:	00233517          	auipc	a0,0x233
    80003798:	64c50513          	addi	a0,a0,1612 # 80236de0 <bcache>
    8000379c:	ffffd097          	auipc	ra,0xffffd
    800037a0:	5ec080e7          	jalr	1516(ra) # 80000d88 <acquire>
  b->refcnt--;
    800037a4:	40bc                	lw	a5,64(s1)
    800037a6:	37fd                	addiw	a5,a5,-1
    800037a8:	0007871b          	sext.w	a4,a5
    800037ac:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800037ae:	e71d                	bnez	a4,800037dc <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800037b0:	68b8                	ld	a4,80(s1)
    800037b2:	64bc                	ld	a5,72(s1)
    800037b4:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800037b6:	68b8                	ld	a4,80(s1)
    800037b8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800037ba:	0023b797          	auipc	a5,0x23b
    800037be:	62678793          	addi	a5,a5,1574 # 8023ede0 <bcache+0x8000>
    800037c2:	2b87b703          	ld	a4,696(a5)
    800037c6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800037c8:	0023c717          	auipc	a4,0x23c
    800037cc:	88070713          	addi	a4,a4,-1920 # 8023f048 <bcache+0x8268>
    800037d0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800037d2:	2b87b703          	ld	a4,696(a5)
    800037d6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800037d8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800037dc:	00233517          	auipc	a0,0x233
    800037e0:	60450513          	addi	a0,a0,1540 # 80236de0 <bcache>
    800037e4:	ffffd097          	auipc	ra,0xffffd
    800037e8:	658080e7          	jalr	1624(ra) # 80000e3c <release>
}
    800037ec:	60e2                	ld	ra,24(sp)
    800037ee:	6442                	ld	s0,16(sp)
    800037f0:	64a2                	ld	s1,8(sp)
    800037f2:	6902                	ld	s2,0(sp)
    800037f4:	6105                	addi	sp,sp,32
    800037f6:	8082                	ret
    panic("brelse");
    800037f8:	00005517          	auipc	a0,0x5
    800037fc:	c7050513          	addi	a0,a0,-912 # 80008468 <etext+0x468>
    80003800:	ffffd097          	auipc	ra,0xffffd
    80003804:	d60080e7          	jalr	-672(ra) # 80000560 <panic>

0000000080003808 <bpin>:

void
bpin(struct buf *b) {
    80003808:	1101                	addi	sp,sp,-32
    8000380a:	ec06                	sd	ra,24(sp)
    8000380c:	e822                	sd	s0,16(sp)
    8000380e:	e426                	sd	s1,8(sp)
    80003810:	1000                	addi	s0,sp,32
    80003812:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003814:	00233517          	auipc	a0,0x233
    80003818:	5cc50513          	addi	a0,a0,1484 # 80236de0 <bcache>
    8000381c:	ffffd097          	auipc	ra,0xffffd
    80003820:	56c080e7          	jalr	1388(ra) # 80000d88 <acquire>
  b->refcnt++;
    80003824:	40bc                	lw	a5,64(s1)
    80003826:	2785                	addiw	a5,a5,1
    80003828:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000382a:	00233517          	auipc	a0,0x233
    8000382e:	5b650513          	addi	a0,a0,1462 # 80236de0 <bcache>
    80003832:	ffffd097          	auipc	ra,0xffffd
    80003836:	60a080e7          	jalr	1546(ra) # 80000e3c <release>
}
    8000383a:	60e2                	ld	ra,24(sp)
    8000383c:	6442                	ld	s0,16(sp)
    8000383e:	64a2                	ld	s1,8(sp)
    80003840:	6105                	addi	sp,sp,32
    80003842:	8082                	ret

0000000080003844 <bunpin>:

void
bunpin(struct buf *b) {
    80003844:	1101                	addi	sp,sp,-32
    80003846:	ec06                	sd	ra,24(sp)
    80003848:	e822                	sd	s0,16(sp)
    8000384a:	e426                	sd	s1,8(sp)
    8000384c:	1000                	addi	s0,sp,32
    8000384e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003850:	00233517          	auipc	a0,0x233
    80003854:	59050513          	addi	a0,a0,1424 # 80236de0 <bcache>
    80003858:	ffffd097          	auipc	ra,0xffffd
    8000385c:	530080e7          	jalr	1328(ra) # 80000d88 <acquire>
  b->refcnt--;
    80003860:	40bc                	lw	a5,64(s1)
    80003862:	37fd                	addiw	a5,a5,-1
    80003864:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003866:	00233517          	auipc	a0,0x233
    8000386a:	57a50513          	addi	a0,a0,1402 # 80236de0 <bcache>
    8000386e:	ffffd097          	auipc	ra,0xffffd
    80003872:	5ce080e7          	jalr	1486(ra) # 80000e3c <release>
}
    80003876:	60e2                	ld	ra,24(sp)
    80003878:	6442                	ld	s0,16(sp)
    8000387a:	64a2                	ld	s1,8(sp)
    8000387c:	6105                	addi	sp,sp,32
    8000387e:	8082                	ret

0000000080003880 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003880:	1101                	addi	sp,sp,-32
    80003882:	ec06                	sd	ra,24(sp)
    80003884:	e822                	sd	s0,16(sp)
    80003886:	e426                	sd	s1,8(sp)
    80003888:	e04a                	sd	s2,0(sp)
    8000388a:	1000                	addi	s0,sp,32
    8000388c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000388e:	00d5d59b          	srliw	a1,a1,0xd
    80003892:	0023c797          	auipc	a5,0x23c
    80003896:	c2a7a783          	lw	a5,-982(a5) # 8023f4bc <sb+0x1c>
    8000389a:	9dbd                	addw	a1,a1,a5
    8000389c:	00000097          	auipc	ra,0x0
    800038a0:	da0080e7          	jalr	-608(ra) # 8000363c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800038a4:	0074f713          	andi	a4,s1,7
    800038a8:	4785                	li	a5,1
    800038aa:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800038ae:	14ce                	slli	s1,s1,0x33
    800038b0:	90d9                	srli	s1,s1,0x36
    800038b2:	00950733          	add	a4,a0,s1
    800038b6:	05874703          	lbu	a4,88(a4)
    800038ba:	00e7f6b3          	and	a3,a5,a4
    800038be:	c69d                	beqz	a3,800038ec <bfree+0x6c>
    800038c0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800038c2:	94aa                	add	s1,s1,a0
    800038c4:	fff7c793          	not	a5,a5
    800038c8:	8f7d                	and	a4,a4,a5
    800038ca:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800038ce:	00001097          	auipc	ra,0x1
    800038d2:	148080e7          	jalr	328(ra) # 80004a16 <log_write>
  brelse(bp);
    800038d6:	854a                	mv	a0,s2
    800038d8:	00000097          	auipc	ra,0x0
    800038dc:	e94080e7          	jalr	-364(ra) # 8000376c <brelse>
}
    800038e0:	60e2                	ld	ra,24(sp)
    800038e2:	6442                	ld	s0,16(sp)
    800038e4:	64a2                	ld	s1,8(sp)
    800038e6:	6902                	ld	s2,0(sp)
    800038e8:	6105                	addi	sp,sp,32
    800038ea:	8082                	ret
    panic("freeing free block");
    800038ec:	00005517          	auipc	a0,0x5
    800038f0:	b8450513          	addi	a0,a0,-1148 # 80008470 <etext+0x470>
    800038f4:	ffffd097          	auipc	ra,0xffffd
    800038f8:	c6c080e7          	jalr	-916(ra) # 80000560 <panic>

00000000800038fc <balloc>:
{
    800038fc:	711d                	addi	sp,sp,-96
    800038fe:	ec86                	sd	ra,88(sp)
    80003900:	e8a2                	sd	s0,80(sp)
    80003902:	e4a6                	sd	s1,72(sp)
    80003904:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003906:	0023c797          	auipc	a5,0x23c
    8000390a:	b9e7a783          	lw	a5,-1122(a5) # 8023f4a4 <sb+0x4>
    8000390e:	10078f63          	beqz	a5,80003a2c <balloc+0x130>
    80003912:	e0ca                	sd	s2,64(sp)
    80003914:	fc4e                	sd	s3,56(sp)
    80003916:	f852                	sd	s4,48(sp)
    80003918:	f456                	sd	s5,40(sp)
    8000391a:	f05a                	sd	s6,32(sp)
    8000391c:	ec5e                	sd	s7,24(sp)
    8000391e:	e862                	sd	s8,16(sp)
    80003920:	e466                	sd	s9,8(sp)
    80003922:	8baa                	mv	s7,a0
    80003924:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003926:	0023cb17          	auipc	s6,0x23c
    8000392a:	b7ab0b13          	addi	s6,s6,-1158 # 8023f4a0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000392e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003930:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003932:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003934:	6c89                	lui	s9,0x2
    80003936:	a061                	j	800039be <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003938:	97ca                	add	a5,a5,s2
    8000393a:	8e55                	or	a2,a2,a3
    8000393c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003940:	854a                	mv	a0,s2
    80003942:	00001097          	auipc	ra,0x1
    80003946:	0d4080e7          	jalr	212(ra) # 80004a16 <log_write>
        brelse(bp);
    8000394a:	854a                	mv	a0,s2
    8000394c:	00000097          	auipc	ra,0x0
    80003950:	e20080e7          	jalr	-480(ra) # 8000376c <brelse>
  bp = bread(dev, bno);
    80003954:	85a6                	mv	a1,s1
    80003956:	855e                	mv	a0,s7
    80003958:	00000097          	auipc	ra,0x0
    8000395c:	ce4080e7          	jalr	-796(ra) # 8000363c <bread>
    80003960:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003962:	40000613          	li	a2,1024
    80003966:	4581                	li	a1,0
    80003968:	05850513          	addi	a0,a0,88
    8000396c:	ffffd097          	auipc	ra,0xffffd
    80003970:	518080e7          	jalr	1304(ra) # 80000e84 <memset>
  log_write(bp);
    80003974:	854a                	mv	a0,s2
    80003976:	00001097          	auipc	ra,0x1
    8000397a:	0a0080e7          	jalr	160(ra) # 80004a16 <log_write>
  brelse(bp);
    8000397e:	854a                	mv	a0,s2
    80003980:	00000097          	auipc	ra,0x0
    80003984:	dec080e7          	jalr	-532(ra) # 8000376c <brelse>
}
    80003988:	6906                	ld	s2,64(sp)
    8000398a:	79e2                	ld	s3,56(sp)
    8000398c:	7a42                	ld	s4,48(sp)
    8000398e:	7aa2                	ld	s5,40(sp)
    80003990:	7b02                	ld	s6,32(sp)
    80003992:	6be2                	ld	s7,24(sp)
    80003994:	6c42                	ld	s8,16(sp)
    80003996:	6ca2                	ld	s9,8(sp)
}
    80003998:	8526                	mv	a0,s1
    8000399a:	60e6                	ld	ra,88(sp)
    8000399c:	6446                	ld	s0,80(sp)
    8000399e:	64a6                	ld	s1,72(sp)
    800039a0:	6125                	addi	sp,sp,96
    800039a2:	8082                	ret
    brelse(bp);
    800039a4:	854a                	mv	a0,s2
    800039a6:	00000097          	auipc	ra,0x0
    800039aa:	dc6080e7          	jalr	-570(ra) # 8000376c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800039ae:	015c87bb          	addw	a5,s9,s5
    800039b2:	00078a9b          	sext.w	s5,a5
    800039b6:	004b2703          	lw	a4,4(s6)
    800039ba:	06eaf163          	bgeu	s5,a4,80003a1c <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    800039be:	41fad79b          	sraiw	a5,s5,0x1f
    800039c2:	0137d79b          	srliw	a5,a5,0x13
    800039c6:	015787bb          	addw	a5,a5,s5
    800039ca:	40d7d79b          	sraiw	a5,a5,0xd
    800039ce:	01cb2583          	lw	a1,28(s6)
    800039d2:	9dbd                	addw	a1,a1,a5
    800039d4:	855e                	mv	a0,s7
    800039d6:	00000097          	auipc	ra,0x0
    800039da:	c66080e7          	jalr	-922(ra) # 8000363c <bread>
    800039de:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039e0:	004b2503          	lw	a0,4(s6)
    800039e4:	000a849b          	sext.w	s1,s5
    800039e8:	8762                	mv	a4,s8
    800039ea:	faa4fde3          	bgeu	s1,a0,800039a4 <balloc+0xa8>
      m = 1 << (bi % 8);
    800039ee:	00777693          	andi	a3,a4,7
    800039f2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800039f6:	41f7579b          	sraiw	a5,a4,0x1f
    800039fa:	01d7d79b          	srliw	a5,a5,0x1d
    800039fe:	9fb9                	addw	a5,a5,a4
    80003a00:	4037d79b          	sraiw	a5,a5,0x3
    80003a04:	00f90633          	add	a2,s2,a5
    80003a08:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003a0c:	00c6f5b3          	and	a1,a3,a2
    80003a10:	d585                	beqz	a1,80003938 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a12:	2705                	addiw	a4,a4,1
    80003a14:	2485                	addiw	s1,s1,1
    80003a16:	fd471ae3          	bne	a4,s4,800039ea <balloc+0xee>
    80003a1a:	b769                	j	800039a4 <balloc+0xa8>
    80003a1c:	6906                	ld	s2,64(sp)
    80003a1e:	79e2                	ld	s3,56(sp)
    80003a20:	7a42                	ld	s4,48(sp)
    80003a22:	7aa2                	ld	s5,40(sp)
    80003a24:	7b02                	ld	s6,32(sp)
    80003a26:	6be2                	ld	s7,24(sp)
    80003a28:	6c42                	ld	s8,16(sp)
    80003a2a:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003a2c:	00005517          	auipc	a0,0x5
    80003a30:	a5c50513          	addi	a0,a0,-1444 # 80008488 <etext+0x488>
    80003a34:	ffffd097          	auipc	ra,0xffffd
    80003a38:	b76080e7          	jalr	-1162(ra) # 800005aa <printf>
  return 0;
    80003a3c:	4481                	li	s1,0
    80003a3e:	bfa9                	j	80003998 <balloc+0x9c>

0000000080003a40 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003a40:	7179                	addi	sp,sp,-48
    80003a42:	f406                	sd	ra,40(sp)
    80003a44:	f022                	sd	s0,32(sp)
    80003a46:	ec26                	sd	s1,24(sp)
    80003a48:	e84a                	sd	s2,16(sp)
    80003a4a:	e44e                	sd	s3,8(sp)
    80003a4c:	1800                	addi	s0,sp,48
    80003a4e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003a50:	47ad                	li	a5,11
    80003a52:	02b7e863          	bltu	a5,a1,80003a82 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003a56:	02059793          	slli	a5,a1,0x20
    80003a5a:	01e7d593          	srli	a1,a5,0x1e
    80003a5e:	00b504b3          	add	s1,a0,a1
    80003a62:	0504a903          	lw	s2,80(s1)
    80003a66:	08091263          	bnez	s2,80003aea <bmap+0xaa>
      addr = balloc(ip->dev);
    80003a6a:	4108                	lw	a0,0(a0)
    80003a6c:	00000097          	auipc	ra,0x0
    80003a70:	e90080e7          	jalr	-368(ra) # 800038fc <balloc>
    80003a74:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003a78:	06090963          	beqz	s2,80003aea <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80003a7c:	0524a823          	sw	s2,80(s1)
    80003a80:	a0ad                	j	80003aea <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003a82:	ff45849b          	addiw	s1,a1,-12
    80003a86:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003a8a:	0ff00793          	li	a5,255
    80003a8e:	08e7e863          	bltu	a5,a4,80003b1e <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003a92:	08052903          	lw	s2,128(a0)
    80003a96:	00091f63          	bnez	s2,80003ab4 <bmap+0x74>
      addr = balloc(ip->dev);
    80003a9a:	4108                	lw	a0,0(a0)
    80003a9c:	00000097          	auipc	ra,0x0
    80003aa0:	e60080e7          	jalr	-416(ra) # 800038fc <balloc>
    80003aa4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003aa8:	04090163          	beqz	s2,80003aea <bmap+0xaa>
    80003aac:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003aae:	0929a023          	sw	s2,128(s3)
    80003ab2:	a011                	j	80003ab6 <bmap+0x76>
    80003ab4:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003ab6:	85ca                	mv	a1,s2
    80003ab8:	0009a503          	lw	a0,0(s3)
    80003abc:	00000097          	auipc	ra,0x0
    80003ac0:	b80080e7          	jalr	-1152(ra) # 8000363c <bread>
    80003ac4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003ac6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003aca:	02049713          	slli	a4,s1,0x20
    80003ace:	01e75593          	srli	a1,a4,0x1e
    80003ad2:	00b784b3          	add	s1,a5,a1
    80003ad6:	0004a903          	lw	s2,0(s1)
    80003ada:	02090063          	beqz	s2,80003afa <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003ade:	8552                	mv	a0,s4
    80003ae0:	00000097          	auipc	ra,0x0
    80003ae4:	c8c080e7          	jalr	-884(ra) # 8000376c <brelse>
    return addr;
    80003ae8:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003aea:	854a                	mv	a0,s2
    80003aec:	70a2                	ld	ra,40(sp)
    80003aee:	7402                	ld	s0,32(sp)
    80003af0:	64e2                	ld	s1,24(sp)
    80003af2:	6942                	ld	s2,16(sp)
    80003af4:	69a2                	ld	s3,8(sp)
    80003af6:	6145                	addi	sp,sp,48
    80003af8:	8082                	ret
      addr = balloc(ip->dev);
    80003afa:	0009a503          	lw	a0,0(s3)
    80003afe:	00000097          	auipc	ra,0x0
    80003b02:	dfe080e7          	jalr	-514(ra) # 800038fc <balloc>
    80003b06:	0005091b          	sext.w	s2,a0
      if(addr){
    80003b0a:	fc090ae3          	beqz	s2,80003ade <bmap+0x9e>
        a[bn] = addr;
    80003b0e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003b12:	8552                	mv	a0,s4
    80003b14:	00001097          	auipc	ra,0x1
    80003b18:	f02080e7          	jalr	-254(ra) # 80004a16 <log_write>
    80003b1c:	b7c9                	j	80003ade <bmap+0x9e>
    80003b1e:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003b20:	00005517          	auipc	a0,0x5
    80003b24:	98050513          	addi	a0,a0,-1664 # 800084a0 <etext+0x4a0>
    80003b28:	ffffd097          	auipc	ra,0xffffd
    80003b2c:	a38080e7          	jalr	-1480(ra) # 80000560 <panic>

0000000080003b30 <iget>:
{
    80003b30:	7179                	addi	sp,sp,-48
    80003b32:	f406                	sd	ra,40(sp)
    80003b34:	f022                	sd	s0,32(sp)
    80003b36:	ec26                	sd	s1,24(sp)
    80003b38:	e84a                	sd	s2,16(sp)
    80003b3a:	e44e                	sd	s3,8(sp)
    80003b3c:	e052                	sd	s4,0(sp)
    80003b3e:	1800                	addi	s0,sp,48
    80003b40:	89aa                	mv	s3,a0
    80003b42:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003b44:	0023c517          	auipc	a0,0x23c
    80003b48:	97c50513          	addi	a0,a0,-1668 # 8023f4c0 <itable>
    80003b4c:	ffffd097          	auipc	ra,0xffffd
    80003b50:	23c080e7          	jalr	572(ra) # 80000d88 <acquire>
  empty = 0;
    80003b54:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003b56:	0023c497          	auipc	s1,0x23c
    80003b5a:	98248493          	addi	s1,s1,-1662 # 8023f4d8 <itable+0x18>
    80003b5e:	0023d697          	auipc	a3,0x23d
    80003b62:	40a68693          	addi	a3,a3,1034 # 80240f68 <log>
    80003b66:	a039                	j	80003b74 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b68:	02090b63          	beqz	s2,80003b9e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003b6c:	08848493          	addi	s1,s1,136
    80003b70:	02d48a63          	beq	s1,a3,80003ba4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003b74:	449c                	lw	a5,8(s1)
    80003b76:	fef059e3          	blez	a5,80003b68 <iget+0x38>
    80003b7a:	4098                	lw	a4,0(s1)
    80003b7c:	ff3716e3          	bne	a4,s3,80003b68 <iget+0x38>
    80003b80:	40d8                	lw	a4,4(s1)
    80003b82:	ff4713e3          	bne	a4,s4,80003b68 <iget+0x38>
      ip->ref++;
    80003b86:	2785                	addiw	a5,a5,1
    80003b88:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003b8a:	0023c517          	auipc	a0,0x23c
    80003b8e:	93650513          	addi	a0,a0,-1738 # 8023f4c0 <itable>
    80003b92:	ffffd097          	auipc	ra,0xffffd
    80003b96:	2aa080e7          	jalr	682(ra) # 80000e3c <release>
      return ip;
    80003b9a:	8926                	mv	s2,s1
    80003b9c:	a03d                	j	80003bca <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b9e:	f7f9                	bnez	a5,80003b6c <iget+0x3c>
      empty = ip;
    80003ba0:	8926                	mv	s2,s1
    80003ba2:	b7e9                	j	80003b6c <iget+0x3c>
  if(empty == 0)
    80003ba4:	02090c63          	beqz	s2,80003bdc <iget+0xac>
  ip->dev = dev;
    80003ba8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003bac:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003bb0:	4785                	li	a5,1
    80003bb2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003bb6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003bba:	0023c517          	auipc	a0,0x23c
    80003bbe:	90650513          	addi	a0,a0,-1786 # 8023f4c0 <itable>
    80003bc2:	ffffd097          	auipc	ra,0xffffd
    80003bc6:	27a080e7          	jalr	634(ra) # 80000e3c <release>
}
    80003bca:	854a                	mv	a0,s2
    80003bcc:	70a2                	ld	ra,40(sp)
    80003bce:	7402                	ld	s0,32(sp)
    80003bd0:	64e2                	ld	s1,24(sp)
    80003bd2:	6942                	ld	s2,16(sp)
    80003bd4:	69a2                	ld	s3,8(sp)
    80003bd6:	6a02                	ld	s4,0(sp)
    80003bd8:	6145                	addi	sp,sp,48
    80003bda:	8082                	ret
    panic("iget: no inodes");
    80003bdc:	00005517          	auipc	a0,0x5
    80003be0:	8dc50513          	addi	a0,a0,-1828 # 800084b8 <etext+0x4b8>
    80003be4:	ffffd097          	auipc	ra,0xffffd
    80003be8:	97c080e7          	jalr	-1668(ra) # 80000560 <panic>

0000000080003bec <fsinit>:
fsinit(int dev) {
    80003bec:	7179                	addi	sp,sp,-48
    80003bee:	f406                	sd	ra,40(sp)
    80003bf0:	f022                	sd	s0,32(sp)
    80003bf2:	ec26                	sd	s1,24(sp)
    80003bf4:	e84a                	sd	s2,16(sp)
    80003bf6:	e44e                	sd	s3,8(sp)
    80003bf8:	1800                	addi	s0,sp,48
    80003bfa:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003bfc:	4585                	li	a1,1
    80003bfe:	00000097          	auipc	ra,0x0
    80003c02:	a3e080e7          	jalr	-1474(ra) # 8000363c <bread>
    80003c06:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003c08:	0023c997          	auipc	s3,0x23c
    80003c0c:	89898993          	addi	s3,s3,-1896 # 8023f4a0 <sb>
    80003c10:	02000613          	li	a2,32
    80003c14:	05850593          	addi	a1,a0,88
    80003c18:	854e                	mv	a0,s3
    80003c1a:	ffffd097          	auipc	ra,0xffffd
    80003c1e:	2c6080e7          	jalr	710(ra) # 80000ee0 <memmove>
  brelse(bp);
    80003c22:	8526                	mv	a0,s1
    80003c24:	00000097          	auipc	ra,0x0
    80003c28:	b48080e7          	jalr	-1208(ra) # 8000376c <brelse>
  if(sb.magic != FSMAGIC)
    80003c2c:	0009a703          	lw	a4,0(s3)
    80003c30:	102037b7          	lui	a5,0x10203
    80003c34:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003c38:	02f71263          	bne	a4,a5,80003c5c <fsinit+0x70>
  initlog(dev, &sb);
    80003c3c:	0023c597          	auipc	a1,0x23c
    80003c40:	86458593          	addi	a1,a1,-1948 # 8023f4a0 <sb>
    80003c44:	854a                	mv	a0,s2
    80003c46:	00001097          	auipc	ra,0x1
    80003c4a:	b60080e7          	jalr	-1184(ra) # 800047a6 <initlog>
}
    80003c4e:	70a2                	ld	ra,40(sp)
    80003c50:	7402                	ld	s0,32(sp)
    80003c52:	64e2                	ld	s1,24(sp)
    80003c54:	6942                	ld	s2,16(sp)
    80003c56:	69a2                	ld	s3,8(sp)
    80003c58:	6145                	addi	sp,sp,48
    80003c5a:	8082                	ret
    panic("invalid file system");
    80003c5c:	00005517          	auipc	a0,0x5
    80003c60:	86c50513          	addi	a0,a0,-1940 # 800084c8 <etext+0x4c8>
    80003c64:	ffffd097          	auipc	ra,0xffffd
    80003c68:	8fc080e7          	jalr	-1796(ra) # 80000560 <panic>

0000000080003c6c <iinit>:
{
    80003c6c:	7179                	addi	sp,sp,-48
    80003c6e:	f406                	sd	ra,40(sp)
    80003c70:	f022                	sd	s0,32(sp)
    80003c72:	ec26                	sd	s1,24(sp)
    80003c74:	e84a                	sd	s2,16(sp)
    80003c76:	e44e                	sd	s3,8(sp)
    80003c78:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003c7a:	00005597          	auipc	a1,0x5
    80003c7e:	86658593          	addi	a1,a1,-1946 # 800084e0 <etext+0x4e0>
    80003c82:	0023c517          	auipc	a0,0x23c
    80003c86:	83e50513          	addi	a0,a0,-1986 # 8023f4c0 <itable>
    80003c8a:	ffffd097          	auipc	ra,0xffffd
    80003c8e:	06e080e7          	jalr	110(ra) # 80000cf8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003c92:	0023c497          	auipc	s1,0x23c
    80003c96:	85648493          	addi	s1,s1,-1962 # 8023f4e8 <itable+0x28>
    80003c9a:	0023d997          	auipc	s3,0x23d
    80003c9e:	2de98993          	addi	s3,s3,734 # 80240f78 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003ca2:	00005917          	auipc	s2,0x5
    80003ca6:	84690913          	addi	s2,s2,-1978 # 800084e8 <etext+0x4e8>
    80003caa:	85ca                	mv	a1,s2
    80003cac:	8526                	mv	a0,s1
    80003cae:	00001097          	auipc	ra,0x1
    80003cb2:	e4c080e7          	jalr	-436(ra) # 80004afa <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003cb6:	08848493          	addi	s1,s1,136
    80003cba:	ff3498e3          	bne	s1,s3,80003caa <iinit+0x3e>
}
    80003cbe:	70a2                	ld	ra,40(sp)
    80003cc0:	7402                	ld	s0,32(sp)
    80003cc2:	64e2                	ld	s1,24(sp)
    80003cc4:	6942                	ld	s2,16(sp)
    80003cc6:	69a2                	ld	s3,8(sp)
    80003cc8:	6145                	addi	sp,sp,48
    80003cca:	8082                	ret

0000000080003ccc <ialloc>:
{
    80003ccc:	7139                	addi	sp,sp,-64
    80003cce:	fc06                	sd	ra,56(sp)
    80003cd0:	f822                	sd	s0,48(sp)
    80003cd2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003cd4:	0023b717          	auipc	a4,0x23b
    80003cd8:	7d872703          	lw	a4,2008(a4) # 8023f4ac <sb+0xc>
    80003cdc:	4785                	li	a5,1
    80003cde:	06e7f463          	bgeu	a5,a4,80003d46 <ialloc+0x7a>
    80003ce2:	f426                	sd	s1,40(sp)
    80003ce4:	f04a                	sd	s2,32(sp)
    80003ce6:	ec4e                	sd	s3,24(sp)
    80003ce8:	e852                	sd	s4,16(sp)
    80003cea:	e456                	sd	s5,8(sp)
    80003cec:	e05a                	sd	s6,0(sp)
    80003cee:	8aaa                	mv	s5,a0
    80003cf0:	8b2e                	mv	s6,a1
    80003cf2:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003cf4:	0023ba17          	auipc	s4,0x23b
    80003cf8:	7aca0a13          	addi	s4,s4,1964 # 8023f4a0 <sb>
    80003cfc:	00495593          	srli	a1,s2,0x4
    80003d00:	018a2783          	lw	a5,24(s4)
    80003d04:	9dbd                	addw	a1,a1,a5
    80003d06:	8556                	mv	a0,s5
    80003d08:	00000097          	auipc	ra,0x0
    80003d0c:	934080e7          	jalr	-1740(ra) # 8000363c <bread>
    80003d10:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003d12:	05850993          	addi	s3,a0,88
    80003d16:	00f97793          	andi	a5,s2,15
    80003d1a:	079a                	slli	a5,a5,0x6
    80003d1c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003d1e:	00099783          	lh	a5,0(s3)
    80003d22:	cf9d                	beqz	a5,80003d60 <ialloc+0x94>
    brelse(bp);
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	a48080e7          	jalr	-1464(ra) # 8000376c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003d2c:	0905                	addi	s2,s2,1
    80003d2e:	00ca2703          	lw	a4,12(s4)
    80003d32:	0009079b          	sext.w	a5,s2
    80003d36:	fce7e3e3          	bltu	a5,a4,80003cfc <ialloc+0x30>
    80003d3a:	74a2                	ld	s1,40(sp)
    80003d3c:	7902                	ld	s2,32(sp)
    80003d3e:	69e2                	ld	s3,24(sp)
    80003d40:	6a42                	ld	s4,16(sp)
    80003d42:	6aa2                	ld	s5,8(sp)
    80003d44:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003d46:	00004517          	auipc	a0,0x4
    80003d4a:	7aa50513          	addi	a0,a0,1962 # 800084f0 <etext+0x4f0>
    80003d4e:	ffffd097          	auipc	ra,0xffffd
    80003d52:	85c080e7          	jalr	-1956(ra) # 800005aa <printf>
  return 0;
    80003d56:	4501                	li	a0,0
}
    80003d58:	70e2                	ld	ra,56(sp)
    80003d5a:	7442                	ld	s0,48(sp)
    80003d5c:	6121                	addi	sp,sp,64
    80003d5e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003d60:	04000613          	li	a2,64
    80003d64:	4581                	li	a1,0
    80003d66:	854e                	mv	a0,s3
    80003d68:	ffffd097          	auipc	ra,0xffffd
    80003d6c:	11c080e7          	jalr	284(ra) # 80000e84 <memset>
      dip->type = type;
    80003d70:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003d74:	8526                	mv	a0,s1
    80003d76:	00001097          	auipc	ra,0x1
    80003d7a:	ca0080e7          	jalr	-864(ra) # 80004a16 <log_write>
      brelse(bp);
    80003d7e:	8526                	mv	a0,s1
    80003d80:	00000097          	auipc	ra,0x0
    80003d84:	9ec080e7          	jalr	-1556(ra) # 8000376c <brelse>
      return iget(dev, inum);
    80003d88:	0009059b          	sext.w	a1,s2
    80003d8c:	8556                	mv	a0,s5
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	da2080e7          	jalr	-606(ra) # 80003b30 <iget>
    80003d96:	74a2                	ld	s1,40(sp)
    80003d98:	7902                	ld	s2,32(sp)
    80003d9a:	69e2                	ld	s3,24(sp)
    80003d9c:	6a42                	ld	s4,16(sp)
    80003d9e:	6aa2                	ld	s5,8(sp)
    80003da0:	6b02                	ld	s6,0(sp)
    80003da2:	bf5d                	j	80003d58 <ialloc+0x8c>

0000000080003da4 <iupdate>:
{
    80003da4:	1101                	addi	sp,sp,-32
    80003da6:	ec06                	sd	ra,24(sp)
    80003da8:	e822                	sd	s0,16(sp)
    80003daa:	e426                	sd	s1,8(sp)
    80003dac:	e04a                	sd	s2,0(sp)
    80003dae:	1000                	addi	s0,sp,32
    80003db0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003db2:	415c                	lw	a5,4(a0)
    80003db4:	0047d79b          	srliw	a5,a5,0x4
    80003db8:	0023b597          	auipc	a1,0x23b
    80003dbc:	7005a583          	lw	a1,1792(a1) # 8023f4b8 <sb+0x18>
    80003dc0:	9dbd                	addw	a1,a1,a5
    80003dc2:	4108                	lw	a0,0(a0)
    80003dc4:	00000097          	auipc	ra,0x0
    80003dc8:	878080e7          	jalr	-1928(ra) # 8000363c <bread>
    80003dcc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003dce:	05850793          	addi	a5,a0,88
    80003dd2:	40d8                	lw	a4,4(s1)
    80003dd4:	8b3d                	andi	a4,a4,15
    80003dd6:	071a                	slli	a4,a4,0x6
    80003dd8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003dda:	04449703          	lh	a4,68(s1)
    80003dde:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003de2:	04649703          	lh	a4,70(s1)
    80003de6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003dea:	04849703          	lh	a4,72(s1)
    80003dee:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003df2:	04a49703          	lh	a4,74(s1)
    80003df6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003dfa:	44f8                	lw	a4,76(s1)
    80003dfc:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003dfe:	03400613          	li	a2,52
    80003e02:	05048593          	addi	a1,s1,80
    80003e06:	00c78513          	addi	a0,a5,12
    80003e0a:	ffffd097          	auipc	ra,0xffffd
    80003e0e:	0d6080e7          	jalr	214(ra) # 80000ee0 <memmove>
  log_write(bp);
    80003e12:	854a                	mv	a0,s2
    80003e14:	00001097          	auipc	ra,0x1
    80003e18:	c02080e7          	jalr	-1022(ra) # 80004a16 <log_write>
  brelse(bp);
    80003e1c:	854a                	mv	a0,s2
    80003e1e:	00000097          	auipc	ra,0x0
    80003e22:	94e080e7          	jalr	-1714(ra) # 8000376c <brelse>
}
    80003e26:	60e2                	ld	ra,24(sp)
    80003e28:	6442                	ld	s0,16(sp)
    80003e2a:	64a2                	ld	s1,8(sp)
    80003e2c:	6902                	ld	s2,0(sp)
    80003e2e:	6105                	addi	sp,sp,32
    80003e30:	8082                	ret

0000000080003e32 <idup>:
{
    80003e32:	1101                	addi	sp,sp,-32
    80003e34:	ec06                	sd	ra,24(sp)
    80003e36:	e822                	sd	s0,16(sp)
    80003e38:	e426                	sd	s1,8(sp)
    80003e3a:	1000                	addi	s0,sp,32
    80003e3c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e3e:	0023b517          	auipc	a0,0x23b
    80003e42:	68250513          	addi	a0,a0,1666 # 8023f4c0 <itable>
    80003e46:	ffffd097          	auipc	ra,0xffffd
    80003e4a:	f42080e7          	jalr	-190(ra) # 80000d88 <acquire>
  ip->ref++;
    80003e4e:	449c                	lw	a5,8(s1)
    80003e50:	2785                	addiw	a5,a5,1
    80003e52:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e54:	0023b517          	auipc	a0,0x23b
    80003e58:	66c50513          	addi	a0,a0,1644 # 8023f4c0 <itable>
    80003e5c:	ffffd097          	auipc	ra,0xffffd
    80003e60:	fe0080e7          	jalr	-32(ra) # 80000e3c <release>
}
    80003e64:	8526                	mv	a0,s1
    80003e66:	60e2                	ld	ra,24(sp)
    80003e68:	6442                	ld	s0,16(sp)
    80003e6a:	64a2                	ld	s1,8(sp)
    80003e6c:	6105                	addi	sp,sp,32
    80003e6e:	8082                	ret

0000000080003e70 <ilock>:
{
    80003e70:	1101                	addi	sp,sp,-32
    80003e72:	ec06                	sd	ra,24(sp)
    80003e74:	e822                	sd	s0,16(sp)
    80003e76:	e426                	sd	s1,8(sp)
    80003e78:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003e7a:	c10d                	beqz	a0,80003e9c <ilock+0x2c>
    80003e7c:	84aa                	mv	s1,a0
    80003e7e:	451c                	lw	a5,8(a0)
    80003e80:	00f05e63          	blez	a5,80003e9c <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003e84:	0541                	addi	a0,a0,16
    80003e86:	00001097          	auipc	ra,0x1
    80003e8a:	cae080e7          	jalr	-850(ra) # 80004b34 <acquiresleep>
  if(ip->valid == 0){
    80003e8e:	40bc                	lw	a5,64(s1)
    80003e90:	cf99                	beqz	a5,80003eae <ilock+0x3e>
}
    80003e92:	60e2                	ld	ra,24(sp)
    80003e94:	6442                	ld	s0,16(sp)
    80003e96:	64a2                	ld	s1,8(sp)
    80003e98:	6105                	addi	sp,sp,32
    80003e9a:	8082                	ret
    80003e9c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003e9e:	00004517          	auipc	a0,0x4
    80003ea2:	66a50513          	addi	a0,a0,1642 # 80008508 <etext+0x508>
    80003ea6:	ffffc097          	auipc	ra,0xffffc
    80003eaa:	6ba080e7          	jalr	1722(ra) # 80000560 <panic>
    80003eae:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003eb0:	40dc                	lw	a5,4(s1)
    80003eb2:	0047d79b          	srliw	a5,a5,0x4
    80003eb6:	0023b597          	auipc	a1,0x23b
    80003eba:	6025a583          	lw	a1,1538(a1) # 8023f4b8 <sb+0x18>
    80003ebe:	9dbd                	addw	a1,a1,a5
    80003ec0:	4088                	lw	a0,0(s1)
    80003ec2:	fffff097          	auipc	ra,0xfffff
    80003ec6:	77a080e7          	jalr	1914(ra) # 8000363c <bread>
    80003eca:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ecc:	05850593          	addi	a1,a0,88
    80003ed0:	40dc                	lw	a5,4(s1)
    80003ed2:	8bbd                	andi	a5,a5,15
    80003ed4:	079a                	slli	a5,a5,0x6
    80003ed6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003ed8:	00059783          	lh	a5,0(a1)
    80003edc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003ee0:	00259783          	lh	a5,2(a1)
    80003ee4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003ee8:	00459783          	lh	a5,4(a1)
    80003eec:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ef0:	00659783          	lh	a5,6(a1)
    80003ef4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003ef8:	459c                	lw	a5,8(a1)
    80003efa:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003efc:	03400613          	li	a2,52
    80003f00:	05b1                	addi	a1,a1,12
    80003f02:	05048513          	addi	a0,s1,80
    80003f06:	ffffd097          	auipc	ra,0xffffd
    80003f0a:	fda080e7          	jalr	-38(ra) # 80000ee0 <memmove>
    brelse(bp);
    80003f0e:	854a                	mv	a0,s2
    80003f10:	00000097          	auipc	ra,0x0
    80003f14:	85c080e7          	jalr	-1956(ra) # 8000376c <brelse>
    ip->valid = 1;
    80003f18:	4785                	li	a5,1
    80003f1a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003f1c:	04449783          	lh	a5,68(s1)
    80003f20:	c399                	beqz	a5,80003f26 <ilock+0xb6>
    80003f22:	6902                	ld	s2,0(sp)
    80003f24:	b7bd                	j	80003e92 <ilock+0x22>
      panic("ilock: no type");
    80003f26:	00004517          	auipc	a0,0x4
    80003f2a:	5ea50513          	addi	a0,a0,1514 # 80008510 <etext+0x510>
    80003f2e:	ffffc097          	auipc	ra,0xffffc
    80003f32:	632080e7          	jalr	1586(ra) # 80000560 <panic>

0000000080003f36 <iunlock>:
{
    80003f36:	1101                	addi	sp,sp,-32
    80003f38:	ec06                	sd	ra,24(sp)
    80003f3a:	e822                	sd	s0,16(sp)
    80003f3c:	e426                	sd	s1,8(sp)
    80003f3e:	e04a                	sd	s2,0(sp)
    80003f40:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003f42:	c905                	beqz	a0,80003f72 <iunlock+0x3c>
    80003f44:	84aa                	mv	s1,a0
    80003f46:	01050913          	addi	s2,a0,16
    80003f4a:	854a                	mv	a0,s2
    80003f4c:	00001097          	auipc	ra,0x1
    80003f50:	c82080e7          	jalr	-894(ra) # 80004bce <holdingsleep>
    80003f54:	cd19                	beqz	a0,80003f72 <iunlock+0x3c>
    80003f56:	449c                	lw	a5,8(s1)
    80003f58:	00f05d63          	blez	a5,80003f72 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003f5c:	854a                	mv	a0,s2
    80003f5e:	00001097          	auipc	ra,0x1
    80003f62:	c2c080e7          	jalr	-980(ra) # 80004b8a <releasesleep>
}
    80003f66:	60e2                	ld	ra,24(sp)
    80003f68:	6442                	ld	s0,16(sp)
    80003f6a:	64a2                	ld	s1,8(sp)
    80003f6c:	6902                	ld	s2,0(sp)
    80003f6e:	6105                	addi	sp,sp,32
    80003f70:	8082                	ret
    panic("iunlock");
    80003f72:	00004517          	auipc	a0,0x4
    80003f76:	5ae50513          	addi	a0,a0,1454 # 80008520 <etext+0x520>
    80003f7a:	ffffc097          	auipc	ra,0xffffc
    80003f7e:	5e6080e7          	jalr	1510(ra) # 80000560 <panic>

0000000080003f82 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003f82:	7179                	addi	sp,sp,-48
    80003f84:	f406                	sd	ra,40(sp)
    80003f86:	f022                	sd	s0,32(sp)
    80003f88:	ec26                	sd	s1,24(sp)
    80003f8a:	e84a                	sd	s2,16(sp)
    80003f8c:	e44e                	sd	s3,8(sp)
    80003f8e:	1800                	addi	s0,sp,48
    80003f90:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003f92:	05050493          	addi	s1,a0,80
    80003f96:	08050913          	addi	s2,a0,128
    80003f9a:	a021                	j	80003fa2 <itrunc+0x20>
    80003f9c:	0491                	addi	s1,s1,4
    80003f9e:	01248d63          	beq	s1,s2,80003fb8 <itrunc+0x36>
    if(ip->addrs[i]){
    80003fa2:	408c                	lw	a1,0(s1)
    80003fa4:	dde5                	beqz	a1,80003f9c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003fa6:	0009a503          	lw	a0,0(s3)
    80003faa:	00000097          	auipc	ra,0x0
    80003fae:	8d6080e7          	jalr	-1834(ra) # 80003880 <bfree>
      ip->addrs[i] = 0;
    80003fb2:	0004a023          	sw	zero,0(s1)
    80003fb6:	b7dd                	j	80003f9c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003fb8:	0809a583          	lw	a1,128(s3)
    80003fbc:	ed99                	bnez	a1,80003fda <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003fbe:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003fc2:	854e                	mv	a0,s3
    80003fc4:	00000097          	auipc	ra,0x0
    80003fc8:	de0080e7          	jalr	-544(ra) # 80003da4 <iupdate>
}
    80003fcc:	70a2                	ld	ra,40(sp)
    80003fce:	7402                	ld	s0,32(sp)
    80003fd0:	64e2                	ld	s1,24(sp)
    80003fd2:	6942                	ld	s2,16(sp)
    80003fd4:	69a2                	ld	s3,8(sp)
    80003fd6:	6145                	addi	sp,sp,48
    80003fd8:	8082                	ret
    80003fda:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003fdc:	0009a503          	lw	a0,0(s3)
    80003fe0:	fffff097          	auipc	ra,0xfffff
    80003fe4:	65c080e7          	jalr	1628(ra) # 8000363c <bread>
    80003fe8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003fea:	05850493          	addi	s1,a0,88
    80003fee:	45850913          	addi	s2,a0,1112
    80003ff2:	a021                	j	80003ffa <itrunc+0x78>
    80003ff4:	0491                	addi	s1,s1,4
    80003ff6:	01248b63          	beq	s1,s2,8000400c <itrunc+0x8a>
      if(a[j])
    80003ffa:	408c                	lw	a1,0(s1)
    80003ffc:	dde5                	beqz	a1,80003ff4 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003ffe:	0009a503          	lw	a0,0(s3)
    80004002:	00000097          	auipc	ra,0x0
    80004006:	87e080e7          	jalr	-1922(ra) # 80003880 <bfree>
    8000400a:	b7ed                	j	80003ff4 <itrunc+0x72>
    brelse(bp);
    8000400c:	8552                	mv	a0,s4
    8000400e:	fffff097          	auipc	ra,0xfffff
    80004012:	75e080e7          	jalr	1886(ra) # 8000376c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004016:	0809a583          	lw	a1,128(s3)
    8000401a:	0009a503          	lw	a0,0(s3)
    8000401e:	00000097          	auipc	ra,0x0
    80004022:	862080e7          	jalr	-1950(ra) # 80003880 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004026:	0809a023          	sw	zero,128(s3)
    8000402a:	6a02                	ld	s4,0(sp)
    8000402c:	bf49                	j	80003fbe <itrunc+0x3c>

000000008000402e <iput>:
{
    8000402e:	1101                	addi	sp,sp,-32
    80004030:	ec06                	sd	ra,24(sp)
    80004032:	e822                	sd	s0,16(sp)
    80004034:	e426                	sd	s1,8(sp)
    80004036:	1000                	addi	s0,sp,32
    80004038:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000403a:	0023b517          	auipc	a0,0x23b
    8000403e:	48650513          	addi	a0,a0,1158 # 8023f4c0 <itable>
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	d46080e7          	jalr	-698(ra) # 80000d88 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000404a:	4498                	lw	a4,8(s1)
    8000404c:	4785                	li	a5,1
    8000404e:	02f70263          	beq	a4,a5,80004072 <iput+0x44>
  ip->ref--;
    80004052:	449c                	lw	a5,8(s1)
    80004054:	37fd                	addiw	a5,a5,-1
    80004056:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004058:	0023b517          	auipc	a0,0x23b
    8000405c:	46850513          	addi	a0,a0,1128 # 8023f4c0 <itable>
    80004060:	ffffd097          	auipc	ra,0xffffd
    80004064:	ddc080e7          	jalr	-548(ra) # 80000e3c <release>
}
    80004068:	60e2                	ld	ra,24(sp)
    8000406a:	6442                	ld	s0,16(sp)
    8000406c:	64a2                	ld	s1,8(sp)
    8000406e:	6105                	addi	sp,sp,32
    80004070:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004072:	40bc                	lw	a5,64(s1)
    80004074:	dff9                	beqz	a5,80004052 <iput+0x24>
    80004076:	04a49783          	lh	a5,74(s1)
    8000407a:	ffe1                	bnez	a5,80004052 <iput+0x24>
    8000407c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000407e:	01048913          	addi	s2,s1,16
    80004082:	854a                	mv	a0,s2
    80004084:	00001097          	auipc	ra,0x1
    80004088:	ab0080e7          	jalr	-1360(ra) # 80004b34 <acquiresleep>
    release(&itable.lock);
    8000408c:	0023b517          	auipc	a0,0x23b
    80004090:	43450513          	addi	a0,a0,1076 # 8023f4c0 <itable>
    80004094:	ffffd097          	auipc	ra,0xffffd
    80004098:	da8080e7          	jalr	-600(ra) # 80000e3c <release>
    itrunc(ip);
    8000409c:	8526                	mv	a0,s1
    8000409e:	00000097          	auipc	ra,0x0
    800040a2:	ee4080e7          	jalr	-284(ra) # 80003f82 <itrunc>
    ip->type = 0;
    800040a6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800040aa:	8526                	mv	a0,s1
    800040ac:	00000097          	auipc	ra,0x0
    800040b0:	cf8080e7          	jalr	-776(ra) # 80003da4 <iupdate>
    ip->valid = 0;
    800040b4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800040b8:	854a                	mv	a0,s2
    800040ba:	00001097          	auipc	ra,0x1
    800040be:	ad0080e7          	jalr	-1328(ra) # 80004b8a <releasesleep>
    acquire(&itable.lock);
    800040c2:	0023b517          	auipc	a0,0x23b
    800040c6:	3fe50513          	addi	a0,a0,1022 # 8023f4c0 <itable>
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	cbe080e7          	jalr	-834(ra) # 80000d88 <acquire>
    800040d2:	6902                	ld	s2,0(sp)
    800040d4:	bfbd                	j	80004052 <iput+0x24>

00000000800040d6 <iunlockput>:
{
    800040d6:	1101                	addi	sp,sp,-32
    800040d8:	ec06                	sd	ra,24(sp)
    800040da:	e822                	sd	s0,16(sp)
    800040dc:	e426                	sd	s1,8(sp)
    800040de:	1000                	addi	s0,sp,32
    800040e0:	84aa                	mv	s1,a0
  iunlock(ip);
    800040e2:	00000097          	auipc	ra,0x0
    800040e6:	e54080e7          	jalr	-428(ra) # 80003f36 <iunlock>
  iput(ip);
    800040ea:	8526                	mv	a0,s1
    800040ec:	00000097          	auipc	ra,0x0
    800040f0:	f42080e7          	jalr	-190(ra) # 8000402e <iput>
}
    800040f4:	60e2                	ld	ra,24(sp)
    800040f6:	6442                	ld	s0,16(sp)
    800040f8:	64a2                	ld	s1,8(sp)
    800040fa:	6105                	addi	sp,sp,32
    800040fc:	8082                	ret

00000000800040fe <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800040fe:	1141                	addi	sp,sp,-16
    80004100:	e422                	sd	s0,8(sp)
    80004102:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004104:	411c                	lw	a5,0(a0)
    80004106:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004108:	415c                	lw	a5,4(a0)
    8000410a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000410c:	04451783          	lh	a5,68(a0)
    80004110:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004114:	04a51783          	lh	a5,74(a0)
    80004118:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000411c:	04c56783          	lwu	a5,76(a0)
    80004120:	e99c                	sd	a5,16(a1)
}
    80004122:	6422                	ld	s0,8(sp)
    80004124:	0141                	addi	sp,sp,16
    80004126:	8082                	ret

0000000080004128 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004128:	457c                	lw	a5,76(a0)
    8000412a:	10d7e563          	bltu	a5,a3,80004234 <readi+0x10c>
{
    8000412e:	7159                	addi	sp,sp,-112
    80004130:	f486                	sd	ra,104(sp)
    80004132:	f0a2                	sd	s0,96(sp)
    80004134:	eca6                	sd	s1,88(sp)
    80004136:	e0d2                	sd	s4,64(sp)
    80004138:	fc56                	sd	s5,56(sp)
    8000413a:	f85a                	sd	s6,48(sp)
    8000413c:	f45e                	sd	s7,40(sp)
    8000413e:	1880                	addi	s0,sp,112
    80004140:	8b2a                	mv	s6,a0
    80004142:	8bae                	mv	s7,a1
    80004144:	8a32                	mv	s4,a2
    80004146:	84b6                	mv	s1,a3
    80004148:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000414a:	9f35                	addw	a4,a4,a3
    return 0;
    8000414c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000414e:	0cd76a63          	bltu	a4,a3,80004222 <readi+0xfa>
    80004152:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004154:	00e7f463          	bgeu	a5,a4,8000415c <readi+0x34>
    n = ip->size - off;
    80004158:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000415c:	0a0a8963          	beqz	s5,8000420e <readi+0xe6>
    80004160:	e8ca                	sd	s2,80(sp)
    80004162:	f062                	sd	s8,32(sp)
    80004164:	ec66                	sd	s9,24(sp)
    80004166:	e86a                	sd	s10,16(sp)
    80004168:	e46e                	sd	s11,8(sp)
    8000416a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000416c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004170:	5c7d                	li	s8,-1
    80004172:	a82d                	j	800041ac <readi+0x84>
    80004174:	020d1d93          	slli	s11,s10,0x20
    80004178:	020ddd93          	srli	s11,s11,0x20
    8000417c:	05890613          	addi	a2,s2,88
    80004180:	86ee                	mv	a3,s11
    80004182:	963a                	add	a2,a2,a4
    80004184:	85d2                	mv	a1,s4
    80004186:	855e                	mv	a0,s7
    80004188:	ffffe097          	auipc	ra,0xffffe
    8000418c:	6a0080e7          	jalr	1696(ra) # 80002828 <either_copyout>
    80004190:	05850d63          	beq	a0,s8,800041ea <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004194:	854a                	mv	a0,s2
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	5d6080e7          	jalr	1494(ra) # 8000376c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000419e:	013d09bb          	addw	s3,s10,s3
    800041a2:	009d04bb          	addw	s1,s10,s1
    800041a6:	9a6e                	add	s4,s4,s11
    800041a8:	0559fd63          	bgeu	s3,s5,80004202 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    800041ac:	00a4d59b          	srliw	a1,s1,0xa
    800041b0:	855a                	mv	a0,s6
    800041b2:	00000097          	auipc	ra,0x0
    800041b6:	88e080e7          	jalr	-1906(ra) # 80003a40 <bmap>
    800041ba:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800041be:	c9b1                	beqz	a1,80004212 <readi+0xea>
    bp = bread(ip->dev, addr);
    800041c0:	000b2503          	lw	a0,0(s6)
    800041c4:	fffff097          	auipc	ra,0xfffff
    800041c8:	478080e7          	jalr	1144(ra) # 8000363c <bread>
    800041cc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800041ce:	3ff4f713          	andi	a4,s1,1023
    800041d2:	40ec87bb          	subw	a5,s9,a4
    800041d6:	413a86bb          	subw	a3,s5,s3
    800041da:	8d3e                	mv	s10,a5
    800041dc:	2781                	sext.w	a5,a5
    800041de:	0006861b          	sext.w	a2,a3
    800041e2:	f8f679e3          	bgeu	a2,a5,80004174 <readi+0x4c>
    800041e6:	8d36                	mv	s10,a3
    800041e8:	b771                	j	80004174 <readi+0x4c>
      brelse(bp);
    800041ea:	854a                	mv	a0,s2
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	580080e7          	jalr	1408(ra) # 8000376c <brelse>
      tot = -1;
    800041f4:	59fd                	li	s3,-1
      break;
    800041f6:	6946                	ld	s2,80(sp)
    800041f8:	7c02                	ld	s8,32(sp)
    800041fa:	6ce2                	ld	s9,24(sp)
    800041fc:	6d42                	ld	s10,16(sp)
    800041fe:	6da2                	ld	s11,8(sp)
    80004200:	a831                	j	8000421c <readi+0xf4>
    80004202:	6946                	ld	s2,80(sp)
    80004204:	7c02                	ld	s8,32(sp)
    80004206:	6ce2                	ld	s9,24(sp)
    80004208:	6d42                	ld	s10,16(sp)
    8000420a:	6da2                	ld	s11,8(sp)
    8000420c:	a801                	j	8000421c <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000420e:	89d6                	mv	s3,s5
    80004210:	a031                	j	8000421c <readi+0xf4>
    80004212:	6946                	ld	s2,80(sp)
    80004214:	7c02                	ld	s8,32(sp)
    80004216:	6ce2                	ld	s9,24(sp)
    80004218:	6d42                	ld	s10,16(sp)
    8000421a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000421c:	0009851b          	sext.w	a0,s3
    80004220:	69a6                	ld	s3,72(sp)
}
    80004222:	70a6                	ld	ra,104(sp)
    80004224:	7406                	ld	s0,96(sp)
    80004226:	64e6                	ld	s1,88(sp)
    80004228:	6a06                	ld	s4,64(sp)
    8000422a:	7ae2                	ld	s5,56(sp)
    8000422c:	7b42                	ld	s6,48(sp)
    8000422e:	7ba2                	ld	s7,40(sp)
    80004230:	6165                	addi	sp,sp,112
    80004232:	8082                	ret
    return 0;
    80004234:	4501                	li	a0,0
}
    80004236:	8082                	ret

0000000080004238 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004238:	457c                	lw	a5,76(a0)
    8000423a:	10d7ee63          	bltu	a5,a3,80004356 <writei+0x11e>
{
    8000423e:	7159                	addi	sp,sp,-112
    80004240:	f486                	sd	ra,104(sp)
    80004242:	f0a2                	sd	s0,96(sp)
    80004244:	e8ca                	sd	s2,80(sp)
    80004246:	e0d2                	sd	s4,64(sp)
    80004248:	fc56                	sd	s5,56(sp)
    8000424a:	f85a                	sd	s6,48(sp)
    8000424c:	f45e                	sd	s7,40(sp)
    8000424e:	1880                	addi	s0,sp,112
    80004250:	8aaa                	mv	s5,a0
    80004252:	8bae                	mv	s7,a1
    80004254:	8a32                	mv	s4,a2
    80004256:	8936                	mv	s2,a3
    80004258:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000425a:	00e687bb          	addw	a5,a3,a4
    8000425e:	0ed7ee63          	bltu	a5,a3,8000435a <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004262:	00043737          	lui	a4,0x43
    80004266:	0ef76c63          	bltu	a4,a5,8000435e <writei+0x126>
    8000426a:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000426c:	0c0b0d63          	beqz	s6,80004346 <writei+0x10e>
    80004270:	eca6                	sd	s1,88(sp)
    80004272:	f062                	sd	s8,32(sp)
    80004274:	ec66                	sd	s9,24(sp)
    80004276:	e86a                	sd	s10,16(sp)
    80004278:	e46e                	sd	s11,8(sp)
    8000427a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000427c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004280:	5c7d                	li	s8,-1
    80004282:	a091                	j	800042c6 <writei+0x8e>
    80004284:	020d1d93          	slli	s11,s10,0x20
    80004288:	020ddd93          	srli	s11,s11,0x20
    8000428c:	05848513          	addi	a0,s1,88
    80004290:	86ee                	mv	a3,s11
    80004292:	8652                	mv	a2,s4
    80004294:	85de                	mv	a1,s7
    80004296:	953a                	add	a0,a0,a4
    80004298:	ffffe097          	auipc	ra,0xffffe
    8000429c:	5e6080e7          	jalr	1510(ra) # 8000287e <either_copyin>
    800042a0:	07850263          	beq	a0,s8,80004304 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800042a4:	8526                	mv	a0,s1
    800042a6:	00000097          	auipc	ra,0x0
    800042aa:	770080e7          	jalr	1904(ra) # 80004a16 <log_write>
    brelse(bp);
    800042ae:	8526                	mv	a0,s1
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	4bc080e7          	jalr	1212(ra) # 8000376c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800042b8:	013d09bb          	addw	s3,s10,s3
    800042bc:	012d093b          	addw	s2,s10,s2
    800042c0:	9a6e                	add	s4,s4,s11
    800042c2:	0569f663          	bgeu	s3,s6,8000430e <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800042c6:	00a9559b          	srliw	a1,s2,0xa
    800042ca:	8556                	mv	a0,s5
    800042cc:	fffff097          	auipc	ra,0xfffff
    800042d0:	774080e7          	jalr	1908(ra) # 80003a40 <bmap>
    800042d4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800042d8:	c99d                	beqz	a1,8000430e <writei+0xd6>
    bp = bread(ip->dev, addr);
    800042da:	000aa503          	lw	a0,0(s5)
    800042de:	fffff097          	auipc	ra,0xfffff
    800042e2:	35e080e7          	jalr	862(ra) # 8000363c <bread>
    800042e6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800042e8:	3ff97713          	andi	a4,s2,1023
    800042ec:	40ec87bb          	subw	a5,s9,a4
    800042f0:	413b06bb          	subw	a3,s6,s3
    800042f4:	8d3e                	mv	s10,a5
    800042f6:	2781                	sext.w	a5,a5
    800042f8:	0006861b          	sext.w	a2,a3
    800042fc:	f8f674e3          	bgeu	a2,a5,80004284 <writei+0x4c>
    80004300:	8d36                	mv	s10,a3
    80004302:	b749                	j	80004284 <writei+0x4c>
      brelse(bp);
    80004304:	8526                	mv	a0,s1
    80004306:	fffff097          	auipc	ra,0xfffff
    8000430a:	466080e7          	jalr	1126(ra) # 8000376c <brelse>
  }

  if(off > ip->size)
    8000430e:	04caa783          	lw	a5,76(s5)
    80004312:	0327fc63          	bgeu	a5,s2,8000434a <writei+0x112>
    ip->size = off;
    80004316:	052aa623          	sw	s2,76(s5)
    8000431a:	64e6                	ld	s1,88(sp)
    8000431c:	7c02                	ld	s8,32(sp)
    8000431e:	6ce2                	ld	s9,24(sp)
    80004320:	6d42                	ld	s10,16(sp)
    80004322:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004324:	8556                	mv	a0,s5
    80004326:	00000097          	auipc	ra,0x0
    8000432a:	a7e080e7          	jalr	-1410(ra) # 80003da4 <iupdate>

  return tot;
    8000432e:	0009851b          	sext.w	a0,s3
    80004332:	69a6                	ld	s3,72(sp)
}
    80004334:	70a6                	ld	ra,104(sp)
    80004336:	7406                	ld	s0,96(sp)
    80004338:	6946                	ld	s2,80(sp)
    8000433a:	6a06                	ld	s4,64(sp)
    8000433c:	7ae2                	ld	s5,56(sp)
    8000433e:	7b42                	ld	s6,48(sp)
    80004340:	7ba2                	ld	s7,40(sp)
    80004342:	6165                	addi	sp,sp,112
    80004344:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004346:	89da                	mv	s3,s6
    80004348:	bff1                	j	80004324 <writei+0xec>
    8000434a:	64e6                	ld	s1,88(sp)
    8000434c:	7c02                	ld	s8,32(sp)
    8000434e:	6ce2                	ld	s9,24(sp)
    80004350:	6d42                	ld	s10,16(sp)
    80004352:	6da2                	ld	s11,8(sp)
    80004354:	bfc1                	j	80004324 <writei+0xec>
    return -1;
    80004356:	557d                	li	a0,-1
}
    80004358:	8082                	ret
    return -1;
    8000435a:	557d                	li	a0,-1
    8000435c:	bfe1                	j	80004334 <writei+0xfc>
    return -1;
    8000435e:	557d                	li	a0,-1
    80004360:	bfd1                	j	80004334 <writei+0xfc>

0000000080004362 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004362:	1141                	addi	sp,sp,-16
    80004364:	e406                	sd	ra,8(sp)
    80004366:	e022                	sd	s0,0(sp)
    80004368:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000436a:	4639                	li	a2,14
    8000436c:	ffffd097          	auipc	ra,0xffffd
    80004370:	be8080e7          	jalr	-1048(ra) # 80000f54 <strncmp>
}
    80004374:	60a2                	ld	ra,8(sp)
    80004376:	6402                	ld	s0,0(sp)
    80004378:	0141                	addi	sp,sp,16
    8000437a:	8082                	ret

000000008000437c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000437c:	7139                	addi	sp,sp,-64
    8000437e:	fc06                	sd	ra,56(sp)
    80004380:	f822                	sd	s0,48(sp)
    80004382:	f426                	sd	s1,40(sp)
    80004384:	f04a                	sd	s2,32(sp)
    80004386:	ec4e                	sd	s3,24(sp)
    80004388:	e852                	sd	s4,16(sp)
    8000438a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000438c:	04451703          	lh	a4,68(a0)
    80004390:	4785                	li	a5,1
    80004392:	00f71a63          	bne	a4,a5,800043a6 <dirlookup+0x2a>
    80004396:	892a                	mv	s2,a0
    80004398:	89ae                	mv	s3,a1
    8000439a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000439c:	457c                	lw	a5,76(a0)
    8000439e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800043a0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043a2:	e79d                	bnez	a5,800043d0 <dirlookup+0x54>
    800043a4:	a8a5                	j	8000441c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800043a6:	00004517          	auipc	a0,0x4
    800043aa:	18250513          	addi	a0,a0,386 # 80008528 <etext+0x528>
    800043ae:	ffffc097          	auipc	ra,0xffffc
    800043b2:	1b2080e7          	jalr	434(ra) # 80000560 <panic>
      panic("dirlookup read");
    800043b6:	00004517          	auipc	a0,0x4
    800043ba:	18a50513          	addi	a0,a0,394 # 80008540 <etext+0x540>
    800043be:	ffffc097          	auipc	ra,0xffffc
    800043c2:	1a2080e7          	jalr	418(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043c6:	24c1                	addiw	s1,s1,16
    800043c8:	04c92783          	lw	a5,76(s2)
    800043cc:	04f4f763          	bgeu	s1,a5,8000441a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043d0:	4741                	li	a4,16
    800043d2:	86a6                	mv	a3,s1
    800043d4:	fc040613          	addi	a2,s0,-64
    800043d8:	4581                	li	a1,0
    800043da:	854a                	mv	a0,s2
    800043dc:	00000097          	auipc	ra,0x0
    800043e0:	d4c080e7          	jalr	-692(ra) # 80004128 <readi>
    800043e4:	47c1                	li	a5,16
    800043e6:	fcf518e3          	bne	a0,a5,800043b6 <dirlookup+0x3a>
    if(de.inum == 0)
    800043ea:	fc045783          	lhu	a5,-64(s0)
    800043ee:	dfe1                	beqz	a5,800043c6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800043f0:	fc240593          	addi	a1,s0,-62
    800043f4:	854e                	mv	a0,s3
    800043f6:	00000097          	auipc	ra,0x0
    800043fa:	f6c080e7          	jalr	-148(ra) # 80004362 <namecmp>
    800043fe:	f561                	bnez	a0,800043c6 <dirlookup+0x4a>
      if(poff)
    80004400:	000a0463          	beqz	s4,80004408 <dirlookup+0x8c>
        *poff = off;
    80004404:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004408:	fc045583          	lhu	a1,-64(s0)
    8000440c:	00092503          	lw	a0,0(s2)
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	720080e7          	jalr	1824(ra) # 80003b30 <iget>
    80004418:	a011                	j	8000441c <dirlookup+0xa0>
  return 0;
    8000441a:	4501                	li	a0,0
}
    8000441c:	70e2                	ld	ra,56(sp)
    8000441e:	7442                	ld	s0,48(sp)
    80004420:	74a2                	ld	s1,40(sp)
    80004422:	7902                	ld	s2,32(sp)
    80004424:	69e2                	ld	s3,24(sp)
    80004426:	6a42                	ld	s4,16(sp)
    80004428:	6121                	addi	sp,sp,64
    8000442a:	8082                	ret

000000008000442c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000442c:	711d                	addi	sp,sp,-96
    8000442e:	ec86                	sd	ra,88(sp)
    80004430:	e8a2                	sd	s0,80(sp)
    80004432:	e4a6                	sd	s1,72(sp)
    80004434:	e0ca                	sd	s2,64(sp)
    80004436:	fc4e                	sd	s3,56(sp)
    80004438:	f852                	sd	s4,48(sp)
    8000443a:	f456                	sd	s5,40(sp)
    8000443c:	f05a                	sd	s6,32(sp)
    8000443e:	ec5e                	sd	s7,24(sp)
    80004440:	e862                	sd	s8,16(sp)
    80004442:	e466                	sd	s9,8(sp)
    80004444:	1080                	addi	s0,sp,96
    80004446:	84aa                	mv	s1,a0
    80004448:	8b2e                	mv	s6,a1
    8000444a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000444c:	00054703          	lbu	a4,0(a0)
    80004450:	02f00793          	li	a5,47
    80004454:	02f70263          	beq	a4,a5,80004478 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004458:	ffffe097          	auipc	ra,0xffffe
    8000445c:	8e4080e7          	jalr	-1820(ra) # 80001d3c <myproc>
    80004460:	15053503          	ld	a0,336(a0)
    80004464:	00000097          	auipc	ra,0x0
    80004468:	9ce080e7          	jalr	-1586(ra) # 80003e32 <idup>
    8000446c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000446e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80004472:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004474:	4b85                	li	s7,1
    80004476:	a875                	j	80004532 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80004478:	4585                	li	a1,1
    8000447a:	4505                	li	a0,1
    8000447c:	fffff097          	auipc	ra,0xfffff
    80004480:	6b4080e7          	jalr	1716(ra) # 80003b30 <iget>
    80004484:	8a2a                	mv	s4,a0
    80004486:	b7e5                	j	8000446e <namex+0x42>
      iunlockput(ip);
    80004488:	8552                	mv	a0,s4
    8000448a:	00000097          	auipc	ra,0x0
    8000448e:	c4c080e7          	jalr	-948(ra) # 800040d6 <iunlockput>
      return 0;
    80004492:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004494:	8552                	mv	a0,s4
    80004496:	60e6                	ld	ra,88(sp)
    80004498:	6446                	ld	s0,80(sp)
    8000449a:	64a6                	ld	s1,72(sp)
    8000449c:	6906                	ld	s2,64(sp)
    8000449e:	79e2                	ld	s3,56(sp)
    800044a0:	7a42                	ld	s4,48(sp)
    800044a2:	7aa2                	ld	s5,40(sp)
    800044a4:	7b02                	ld	s6,32(sp)
    800044a6:	6be2                	ld	s7,24(sp)
    800044a8:	6c42                	ld	s8,16(sp)
    800044aa:	6ca2                	ld	s9,8(sp)
    800044ac:	6125                	addi	sp,sp,96
    800044ae:	8082                	ret
      iunlock(ip);
    800044b0:	8552                	mv	a0,s4
    800044b2:	00000097          	auipc	ra,0x0
    800044b6:	a84080e7          	jalr	-1404(ra) # 80003f36 <iunlock>
      return ip;
    800044ba:	bfe9                	j	80004494 <namex+0x68>
      iunlockput(ip);
    800044bc:	8552                	mv	a0,s4
    800044be:	00000097          	auipc	ra,0x0
    800044c2:	c18080e7          	jalr	-1000(ra) # 800040d6 <iunlockput>
      return 0;
    800044c6:	8a4e                	mv	s4,s3
    800044c8:	b7f1                	j	80004494 <namex+0x68>
  len = path - s;
    800044ca:	40998633          	sub	a2,s3,s1
    800044ce:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800044d2:	099c5863          	bge	s8,s9,80004562 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800044d6:	4639                	li	a2,14
    800044d8:	85a6                	mv	a1,s1
    800044da:	8556                	mv	a0,s5
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	a04080e7          	jalr	-1532(ra) # 80000ee0 <memmove>
    800044e4:	84ce                	mv	s1,s3
  while(*path == '/')
    800044e6:	0004c783          	lbu	a5,0(s1)
    800044ea:	01279763          	bne	a5,s2,800044f8 <namex+0xcc>
    path++;
    800044ee:	0485                	addi	s1,s1,1
  while(*path == '/')
    800044f0:	0004c783          	lbu	a5,0(s1)
    800044f4:	ff278de3          	beq	a5,s2,800044ee <namex+0xc2>
    ilock(ip);
    800044f8:	8552                	mv	a0,s4
    800044fa:	00000097          	auipc	ra,0x0
    800044fe:	976080e7          	jalr	-1674(ra) # 80003e70 <ilock>
    if(ip->type != T_DIR){
    80004502:	044a1783          	lh	a5,68(s4)
    80004506:	f97791e3          	bne	a5,s7,80004488 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000450a:	000b0563          	beqz	s6,80004514 <namex+0xe8>
    8000450e:	0004c783          	lbu	a5,0(s1)
    80004512:	dfd9                	beqz	a5,800044b0 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004514:	4601                	li	a2,0
    80004516:	85d6                	mv	a1,s5
    80004518:	8552                	mv	a0,s4
    8000451a:	00000097          	auipc	ra,0x0
    8000451e:	e62080e7          	jalr	-414(ra) # 8000437c <dirlookup>
    80004522:	89aa                	mv	s3,a0
    80004524:	dd41                	beqz	a0,800044bc <namex+0x90>
    iunlockput(ip);
    80004526:	8552                	mv	a0,s4
    80004528:	00000097          	auipc	ra,0x0
    8000452c:	bae080e7          	jalr	-1106(ra) # 800040d6 <iunlockput>
    ip = next;
    80004530:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004532:	0004c783          	lbu	a5,0(s1)
    80004536:	01279763          	bne	a5,s2,80004544 <namex+0x118>
    path++;
    8000453a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000453c:	0004c783          	lbu	a5,0(s1)
    80004540:	ff278de3          	beq	a5,s2,8000453a <namex+0x10e>
  if(*path == 0)
    80004544:	cb9d                	beqz	a5,8000457a <namex+0x14e>
  while(*path != '/' && *path != 0)
    80004546:	0004c783          	lbu	a5,0(s1)
    8000454a:	89a6                	mv	s3,s1
  len = path - s;
    8000454c:	4c81                	li	s9,0
    8000454e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004550:	01278963          	beq	a5,s2,80004562 <namex+0x136>
    80004554:	dbbd                	beqz	a5,800044ca <namex+0x9e>
    path++;
    80004556:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004558:	0009c783          	lbu	a5,0(s3)
    8000455c:	ff279ce3          	bne	a5,s2,80004554 <namex+0x128>
    80004560:	b7ad                	j	800044ca <namex+0x9e>
    memmove(name, s, len);
    80004562:	2601                	sext.w	a2,a2
    80004564:	85a6                	mv	a1,s1
    80004566:	8556                	mv	a0,s5
    80004568:	ffffd097          	auipc	ra,0xffffd
    8000456c:	978080e7          	jalr	-1672(ra) # 80000ee0 <memmove>
    name[len] = 0;
    80004570:	9cd6                	add	s9,s9,s5
    80004572:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004576:	84ce                	mv	s1,s3
    80004578:	b7bd                	j	800044e6 <namex+0xba>
  if(nameiparent){
    8000457a:	f00b0de3          	beqz	s6,80004494 <namex+0x68>
    iput(ip);
    8000457e:	8552                	mv	a0,s4
    80004580:	00000097          	auipc	ra,0x0
    80004584:	aae080e7          	jalr	-1362(ra) # 8000402e <iput>
    return 0;
    80004588:	4a01                	li	s4,0
    8000458a:	b729                	j	80004494 <namex+0x68>

000000008000458c <dirlink>:
{
    8000458c:	7139                	addi	sp,sp,-64
    8000458e:	fc06                	sd	ra,56(sp)
    80004590:	f822                	sd	s0,48(sp)
    80004592:	f04a                	sd	s2,32(sp)
    80004594:	ec4e                	sd	s3,24(sp)
    80004596:	e852                	sd	s4,16(sp)
    80004598:	0080                	addi	s0,sp,64
    8000459a:	892a                	mv	s2,a0
    8000459c:	8a2e                	mv	s4,a1
    8000459e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800045a0:	4601                	li	a2,0
    800045a2:	00000097          	auipc	ra,0x0
    800045a6:	dda080e7          	jalr	-550(ra) # 8000437c <dirlookup>
    800045aa:	ed25                	bnez	a0,80004622 <dirlink+0x96>
    800045ac:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800045ae:	04c92483          	lw	s1,76(s2)
    800045b2:	c49d                	beqz	s1,800045e0 <dirlink+0x54>
    800045b4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045b6:	4741                	li	a4,16
    800045b8:	86a6                	mv	a3,s1
    800045ba:	fc040613          	addi	a2,s0,-64
    800045be:	4581                	li	a1,0
    800045c0:	854a                	mv	a0,s2
    800045c2:	00000097          	auipc	ra,0x0
    800045c6:	b66080e7          	jalr	-1178(ra) # 80004128 <readi>
    800045ca:	47c1                	li	a5,16
    800045cc:	06f51163          	bne	a0,a5,8000462e <dirlink+0xa2>
    if(de.inum == 0)
    800045d0:	fc045783          	lhu	a5,-64(s0)
    800045d4:	c791                	beqz	a5,800045e0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800045d6:	24c1                	addiw	s1,s1,16
    800045d8:	04c92783          	lw	a5,76(s2)
    800045dc:	fcf4ede3          	bltu	s1,a5,800045b6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800045e0:	4639                	li	a2,14
    800045e2:	85d2                	mv	a1,s4
    800045e4:	fc240513          	addi	a0,s0,-62
    800045e8:	ffffd097          	auipc	ra,0xffffd
    800045ec:	9a2080e7          	jalr	-1630(ra) # 80000f8a <strncpy>
  de.inum = inum;
    800045f0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045f4:	4741                	li	a4,16
    800045f6:	86a6                	mv	a3,s1
    800045f8:	fc040613          	addi	a2,s0,-64
    800045fc:	4581                	li	a1,0
    800045fe:	854a                	mv	a0,s2
    80004600:	00000097          	auipc	ra,0x0
    80004604:	c38080e7          	jalr	-968(ra) # 80004238 <writei>
    80004608:	1541                	addi	a0,a0,-16
    8000460a:	00a03533          	snez	a0,a0
    8000460e:	40a00533          	neg	a0,a0
    80004612:	74a2                	ld	s1,40(sp)
}
    80004614:	70e2                	ld	ra,56(sp)
    80004616:	7442                	ld	s0,48(sp)
    80004618:	7902                	ld	s2,32(sp)
    8000461a:	69e2                	ld	s3,24(sp)
    8000461c:	6a42                	ld	s4,16(sp)
    8000461e:	6121                	addi	sp,sp,64
    80004620:	8082                	ret
    iput(ip);
    80004622:	00000097          	auipc	ra,0x0
    80004626:	a0c080e7          	jalr	-1524(ra) # 8000402e <iput>
    return -1;
    8000462a:	557d                	li	a0,-1
    8000462c:	b7e5                	j	80004614 <dirlink+0x88>
      panic("dirlink read");
    8000462e:	00004517          	auipc	a0,0x4
    80004632:	f2250513          	addi	a0,a0,-222 # 80008550 <etext+0x550>
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	f2a080e7          	jalr	-214(ra) # 80000560 <panic>

000000008000463e <namei>:

struct inode*
namei(char *path)
{
    8000463e:	1101                	addi	sp,sp,-32
    80004640:	ec06                	sd	ra,24(sp)
    80004642:	e822                	sd	s0,16(sp)
    80004644:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004646:	fe040613          	addi	a2,s0,-32
    8000464a:	4581                	li	a1,0
    8000464c:	00000097          	auipc	ra,0x0
    80004650:	de0080e7          	jalr	-544(ra) # 8000442c <namex>
}
    80004654:	60e2                	ld	ra,24(sp)
    80004656:	6442                	ld	s0,16(sp)
    80004658:	6105                	addi	sp,sp,32
    8000465a:	8082                	ret

000000008000465c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000465c:	1141                	addi	sp,sp,-16
    8000465e:	e406                	sd	ra,8(sp)
    80004660:	e022                	sd	s0,0(sp)
    80004662:	0800                	addi	s0,sp,16
    80004664:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004666:	4585                	li	a1,1
    80004668:	00000097          	auipc	ra,0x0
    8000466c:	dc4080e7          	jalr	-572(ra) # 8000442c <namex>
}
    80004670:	60a2                	ld	ra,8(sp)
    80004672:	6402                	ld	s0,0(sp)
    80004674:	0141                	addi	sp,sp,16
    80004676:	8082                	ret

0000000080004678 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004678:	1101                	addi	sp,sp,-32
    8000467a:	ec06                	sd	ra,24(sp)
    8000467c:	e822                	sd	s0,16(sp)
    8000467e:	e426                	sd	s1,8(sp)
    80004680:	e04a                	sd	s2,0(sp)
    80004682:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004684:	0023d917          	auipc	s2,0x23d
    80004688:	8e490913          	addi	s2,s2,-1820 # 80240f68 <log>
    8000468c:	01892583          	lw	a1,24(s2)
    80004690:	02892503          	lw	a0,40(s2)
    80004694:	fffff097          	auipc	ra,0xfffff
    80004698:	fa8080e7          	jalr	-88(ra) # 8000363c <bread>
    8000469c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000469e:	02c92603          	lw	a2,44(s2)
    800046a2:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800046a4:	00c05f63          	blez	a2,800046c2 <write_head+0x4a>
    800046a8:	0023d717          	auipc	a4,0x23d
    800046ac:	8f070713          	addi	a4,a4,-1808 # 80240f98 <log+0x30>
    800046b0:	87aa                	mv	a5,a0
    800046b2:	060a                	slli	a2,a2,0x2
    800046b4:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800046b6:	4314                	lw	a3,0(a4)
    800046b8:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800046ba:	0711                	addi	a4,a4,4
    800046bc:	0791                	addi	a5,a5,4
    800046be:	fec79ce3          	bne	a5,a2,800046b6 <write_head+0x3e>
  }
  bwrite(buf);
    800046c2:	8526                	mv	a0,s1
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	06a080e7          	jalr	106(ra) # 8000372e <bwrite>
  brelse(buf);
    800046cc:	8526                	mv	a0,s1
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	09e080e7          	jalr	158(ra) # 8000376c <brelse>
}
    800046d6:	60e2                	ld	ra,24(sp)
    800046d8:	6442                	ld	s0,16(sp)
    800046da:	64a2                	ld	s1,8(sp)
    800046dc:	6902                	ld	s2,0(sp)
    800046de:	6105                	addi	sp,sp,32
    800046e0:	8082                	ret

00000000800046e2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800046e2:	0023d797          	auipc	a5,0x23d
    800046e6:	8b27a783          	lw	a5,-1870(a5) # 80240f94 <log+0x2c>
    800046ea:	0af05d63          	blez	a5,800047a4 <install_trans+0xc2>
{
    800046ee:	7139                	addi	sp,sp,-64
    800046f0:	fc06                	sd	ra,56(sp)
    800046f2:	f822                	sd	s0,48(sp)
    800046f4:	f426                	sd	s1,40(sp)
    800046f6:	f04a                	sd	s2,32(sp)
    800046f8:	ec4e                	sd	s3,24(sp)
    800046fa:	e852                	sd	s4,16(sp)
    800046fc:	e456                	sd	s5,8(sp)
    800046fe:	e05a                	sd	s6,0(sp)
    80004700:	0080                	addi	s0,sp,64
    80004702:	8b2a                	mv	s6,a0
    80004704:	0023da97          	auipc	s5,0x23d
    80004708:	894a8a93          	addi	s5,s5,-1900 # 80240f98 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000470c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000470e:	0023d997          	auipc	s3,0x23d
    80004712:	85a98993          	addi	s3,s3,-1958 # 80240f68 <log>
    80004716:	a00d                	j	80004738 <install_trans+0x56>
    brelse(lbuf);
    80004718:	854a                	mv	a0,s2
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	052080e7          	jalr	82(ra) # 8000376c <brelse>
    brelse(dbuf);
    80004722:	8526                	mv	a0,s1
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	048080e7          	jalr	72(ra) # 8000376c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000472c:	2a05                	addiw	s4,s4,1
    8000472e:	0a91                	addi	s5,s5,4
    80004730:	02c9a783          	lw	a5,44(s3)
    80004734:	04fa5e63          	bge	s4,a5,80004790 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004738:	0189a583          	lw	a1,24(s3)
    8000473c:	014585bb          	addw	a1,a1,s4
    80004740:	2585                	addiw	a1,a1,1
    80004742:	0289a503          	lw	a0,40(s3)
    80004746:	fffff097          	auipc	ra,0xfffff
    8000474a:	ef6080e7          	jalr	-266(ra) # 8000363c <bread>
    8000474e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004750:	000aa583          	lw	a1,0(s5)
    80004754:	0289a503          	lw	a0,40(s3)
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	ee4080e7          	jalr	-284(ra) # 8000363c <bread>
    80004760:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004762:	40000613          	li	a2,1024
    80004766:	05890593          	addi	a1,s2,88
    8000476a:	05850513          	addi	a0,a0,88
    8000476e:	ffffc097          	auipc	ra,0xffffc
    80004772:	772080e7          	jalr	1906(ra) # 80000ee0 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004776:	8526                	mv	a0,s1
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	fb6080e7          	jalr	-74(ra) # 8000372e <bwrite>
    if(recovering == 0)
    80004780:	f80b1ce3          	bnez	s6,80004718 <install_trans+0x36>
      bunpin(dbuf);
    80004784:	8526                	mv	a0,s1
    80004786:	fffff097          	auipc	ra,0xfffff
    8000478a:	0be080e7          	jalr	190(ra) # 80003844 <bunpin>
    8000478e:	b769                	j	80004718 <install_trans+0x36>
}
    80004790:	70e2                	ld	ra,56(sp)
    80004792:	7442                	ld	s0,48(sp)
    80004794:	74a2                	ld	s1,40(sp)
    80004796:	7902                	ld	s2,32(sp)
    80004798:	69e2                	ld	s3,24(sp)
    8000479a:	6a42                	ld	s4,16(sp)
    8000479c:	6aa2                	ld	s5,8(sp)
    8000479e:	6b02                	ld	s6,0(sp)
    800047a0:	6121                	addi	sp,sp,64
    800047a2:	8082                	ret
    800047a4:	8082                	ret

00000000800047a6 <initlog>:
{
    800047a6:	7179                	addi	sp,sp,-48
    800047a8:	f406                	sd	ra,40(sp)
    800047aa:	f022                	sd	s0,32(sp)
    800047ac:	ec26                	sd	s1,24(sp)
    800047ae:	e84a                	sd	s2,16(sp)
    800047b0:	e44e                	sd	s3,8(sp)
    800047b2:	1800                	addi	s0,sp,48
    800047b4:	892a                	mv	s2,a0
    800047b6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800047b8:	0023c497          	auipc	s1,0x23c
    800047bc:	7b048493          	addi	s1,s1,1968 # 80240f68 <log>
    800047c0:	00004597          	auipc	a1,0x4
    800047c4:	da058593          	addi	a1,a1,-608 # 80008560 <etext+0x560>
    800047c8:	8526                	mv	a0,s1
    800047ca:	ffffc097          	auipc	ra,0xffffc
    800047ce:	52e080e7          	jalr	1326(ra) # 80000cf8 <initlock>
  log.start = sb->logstart;
    800047d2:	0149a583          	lw	a1,20(s3)
    800047d6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800047d8:	0109a783          	lw	a5,16(s3)
    800047dc:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800047de:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800047e2:	854a                	mv	a0,s2
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	e58080e7          	jalr	-424(ra) # 8000363c <bread>
  log.lh.n = lh->n;
    800047ec:	4d30                	lw	a2,88(a0)
    800047ee:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800047f0:	00c05f63          	blez	a2,8000480e <initlog+0x68>
    800047f4:	87aa                	mv	a5,a0
    800047f6:	0023c717          	auipc	a4,0x23c
    800047fa:	7a270713          	addi	a4,a4,1954 # 80240f98 <log+0x30>
    800047fe:	060a                	slli	a2,a2,0x2
    80004800:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004802:	4ff4                	lw	a3,92(a5)
    80004804:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004806:	0791                	addi	a5,a5,4
    80004808:	0711                	addi	a4,a4,4
    8000480a:	fec79ce3          	bne	a5,a2,80004802 <initlog+0x5c>
  brelse(buf);
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	f5e080e7          	jalr	-162(ra) # 8000376c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004816:	4505                	li	a0,1
    80004818:	00000097          	auipc	ra,0x0
    8000481c:	eca080e7          	jalr	-310(ra) # 800046e2 <install_trans>
  log.lh.n = 0;
    80004820:	0023c797          	auipc	a5,0x23c
    80004824:	7607aa23          	sw	zero,1908(a5) # 80240f94 <log+0x2c>
  write_head(); // clear the log
    80004828:	00000097          	auipc	ra,0x0
    8000482c:	e50080e7          	jalr	-432(ra) # 80004678 <write_head>
}
    80004830:	70a2                	ld	ra,40(sp)
    80004832:	7402                	ld	s0,32(sp)
    80004834:	64e2                	ld	s1,24(sp)
    80004836:	6942                	ld	s2,16(sp)
    80004838:	69a2                	ld	s3,8(sp)
    8000483a:	6145                	addi	sp,sp,48
    8000483c:	8082                	ret

000000008000483e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000483e:	1101                	addi	sp,sp,-32
    80004840:	ec06                	sd	ra,24(sp)
    80004842:	e822                	sd	s0,16(sp)
    80004844:	e426                	sd	s1,8(sp)
    80004846:	e04a                	sd	s2,0(sp)
    80004848:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000484a:	0023c517          	auipc	a0,0x23c
    8000484e:	71e50513          	addi	a0,a0,1822 # 80240f68 <log>
    80004852:	ffffc097          	auipc	ra,0xffffc
    80004856:	536080e7          	jalr	1334(ra) # 80000d88 <acquire>
  while(1){
    if(log.committing){
    8000485a:	0023c497          	auipc	s1,0x23c
    8000485e:	70e48493          	addi	s1,s1,1806 # 80240f68 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004862:	4979                	li	s2,30
    80004864:	a039                	j	80004872 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004866:	85a6                	mv	a1,s1
    80004868:	8526                	mv	a0,s1
    8000486a:	ffffe097          	auipc	ra,0xffffe
    8000486e:	baa080e7          	jalr	-1110(ra) # 80002414 <sleep>
    if(log.committing){
    80004872:	50dc                	lw	a5,36(s1)
    80004874:	fbed                	bnez	a5,80004866 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004876:	5098                	lw	a4,32(s1)
    80004878:	2705                	addiw	a4,a4,1
    8000487a:	0027179b          	slliw	a5,a4,0x2
    8000487e:	9fb9                	addw	a5,a5,a4
    80004880:	0017979b          	slliw	a5,a5,0x1
    80004884:	54d4                	lw	a3,44(s1)
    80004886:	9fb5                	addw	a5,a5,a3
    80004888:	00f95963          	bge	s2,a5,8000489a <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000488c:	85a6                	mv	a1,s1
    8000488e:	8526                	mv	a0,s1
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	b84080e7          	jalr	-1148(ra) # 80002414 <sleep>
    80004898:	bfe9                	j	80004872 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000489a:	0023c517          	auipc	a0,0x23c
    8000489e:	6ce50513          	addi	a0,a0,1742 # 80240f68 <log>
    800048a2:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800048a4:	ffffc097          	auipc	ra,0xffffc
    800048a8:	598080e7          	jalr	1432(ra) # 80000e3c <release>
      break;
    }
  }
}
    800048ac:	60e2                	ld	ra,24(sp)
    800048ae:	6442                	ld	s0,16(sp)
    800048b0:	64a2                	ld	s1,8(sp)
    800048b2:	6902                	ld	s2,0(sp)
    800048b4:	6105                	addi	sp,sp,32
    800048b6:	8082                	ret

00000000800048b8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800048b8:	7139                	addi	sp,sp,-64
    800048ba:	fc06                	sd	ra,56(sp)
    800048bc:	f822                	sd	s0,48(sp)
    800048be:	f426                	sd	s1,40(sp)
    800048c0:	f04a                	sd	s2,32(sp)
    800048c2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800048c4:	0023c497          	auipc	s1,0x23c
    800048c8:	6a448493          	addi	s1,s1,1700 # 80240f68 <log>
    800048cc:	8526                	mv	a0,s1
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	4ba080e7          	jalr	1210(ra) # 80000d88 <acquire>
  log.outstanding -= 1;
    800048d6:	509c                	lw	a5,32(s1)
    800048d8:	37fd                	addiw	a5,a5,-1
    800048da:	0007891b          	sext.w	s2,a5
    800048de:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800048e0:	50dc                	lw	a5,36(s1)
    800048e2:	e7b9                	bnez	a5,80004930 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800048e4:	06091163          	bnez	s2,80004946 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800048e8:	0023c497          	auipc	s1,0x23c
    800048ec:	68048493          	addi	s1,s1,1664 # 80240f68 <log>
    800048f0:	4785                	li	a5,1
    800048f2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800048f4:	8526                	mv	a0,s1
    800048f6:	ffffc097          	auipc	ra,0xffffc
    800048fa:	546080e7          	jalr	1350(ra) # 80000e3c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800048fe:	54dc                	lw	a5,44(s1)
    80004900:	06f04763          	bgtz	a5,8000496e <end_op+0xb6>
    acquire(&log.lock);
    80004904:	0023c497          	auipc	s1,0x23c
    80004908:	66448493          	addi	s1,s1,1636 # 80240f68 <log>
    8000490c:	8526                	mv	a0,s1
    8000490e:	ffffc097          	auipc	ra,0xffffc
    80004912:	47a080e7          	jalr	1146(ra) # 80000d88 <acquire>
    log.committing = 0;
    80004916:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000491a:	8526                	mv	a0,s1
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	b5c080e7          	jalr	-1188(ra) # 80002478 <wakeup>
    release(&log.lock);
    80004924:	8526                	mv	a0,s1
    80004926:	ffffc097          	auipc	ra,0xffffc
    8000492a:	516080e7          	jalr	1302(ra) # 80000e3c <release>
}
    8000492e:	a815                	j	80004962 <end_op+0xaa>
    80004930:	ec4e                	sd	s3,24(sp)
    80004932:	e852                	sd	s4,16(sp)
    80004934:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004936:	00004517          	auipc	a0,0x4
    8000493a:	c3250513          	addi	a0,a0,-974 # 80008568 <etext+0x568>
    8000493e:	ffffc097          	auipc	ra,0xffffc
    80004942:	c22080e7          	jalr	-990(ra) # 80000560 <panic>
    wakeup(&log);
    80004946:	0023c497          	auipc	s1,0x23c
    8000494a:	62248493          	addi	s1,s1,1570 # 80240f68 <log>
    8000494e:	8526                	mv	a0,s1
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	b28080e7          	jalr	-1240(ra) # 80002478 <wakeup>
  release(&log.lock);
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffc097          	auipc	ra,0xffffc
    8000495e:	4e2080e7          	jalr	1250(ra) # 80000e3c <release>
}
    80004962:	70e2                	ld	ra,56(sp)
    80004964:	7442                	ld	s0,48(sp)
    80004966:	74a2                	ld	s1,40(sp)
    80004968:	7902                	ld	s2,32(sp)
    8000496a:	6121                	addi	sp,sp,64
    8000496c:	8082                	ret
    8000496e:	ec4e                	sd	s3,24(sp)
    80004970:	e852                	sd	s4,16(sp)
    80004972:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004974:	0023ca97          	auipc	s5,0x23c
    80004978:	624a8a93          	addi	s5,s5,1572 # 80240f98 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000497c:	0023ca17          	auipc	s4,0x23c
    80004980:	5eca0a13          	addi	s4,s4,1516 # 80240f68 <log>
    80004984:	018a2583          	lw	a1,24(s4)
    80004988:	012585bb          	addw	a1,a1,s2
    8000498c:	2585                	addiw	a1,a1,1
    8000498e:	028a2503          	lw	a0,40(s4)
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	caa080e7          	jalr	-854(ra) # 8000363c <bread>
    8000499a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000499c:	000aa583          	lw	a1,0(s5)
    800049a0:	028a2503          	lw	a0,40(s4)
    800049a4:	fffff097          	auipc	ra,0xfffff
    800049a8:	c98080e7          	jalr	-872(ra) # 8000363c <bread>
    800049ac:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800049ae:	40000613          	li	a2,1024
    800049b2:	05850593          	addi	a1,a0,88
    800049b6:	05848513          	addi	a0,s1,88
    800049ba:	ffffc097          	auipc	ra,0xffffc
    800049be:	526080e7          	jalr	1318(ra) # 80000ee0 <memmove>
    bwrite(to);  // write the log
    800049c2:	8526                	mv	a0,s1
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	d6a080e7          	jalr	-662(ra) # 8000372e <bwrite>
    brelse(from);
    800049cc:	854e                	mv	a0,s3
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	d9e080e7          	jalr	-610(ra) # 8000376c <brelse>
    brelse(to);
    800049d6:	8526                	mv	a0,s1
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	d94080e7          	jalr	-620(ra) # 8000376c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800049e0:	2905                	addiw	s2,s2,1
    800049e2:	0a91                	addi	s5,s5,4
    800049e4:	02ca2783          	lw	a5,44(s4)
    800049e8:	f8f94ee3          	blt	s2,a5,80004984 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800049ec:	00000097          	auipc	ra,0x0
    800049f0:	c8c080e7          	jalr	-884(ra) # 80004678 <write_head>
    install_trans(0); // Now install writes to home locations
    800049f4:	4501                	li	a0,0
    800049f6:	00000097          	auipc	ra,0x0
    800049fa:	cec080e7          	jalr	-788(ra) # 800046e2 <install_trans>
    log.lh.n = 0;
    800049fe:	0023c797          	auipc	a5,0x23c
    80004a02:	5807ab23          	sw	zero,1430(a5) # 80240f94 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004a06:	00000097          	auipc	ra,0x0
    80004a0a:	c72080e7          	jalr	-910(ra) # 80004678 <write_head>
    80004a0e:	69e2                	ld	s3,24(sp)
    80004a10:	6a42                	ld	s4,16(sp)
    80004a12:	6aa2                	ld	s5,8(sp)
    80004a14:	bdc5                	j	80004904 <end_op+0x4c>

0000000080004a16 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004a16:	1101                	addi	sp,sp,-32
    80004a18:	ec06                	sd	ra,24(sp)
    80004a1a:	e822                	sd	s0,16(sp)
    80004a1c:	e426                	sd	s1,8(sp)
    80004a1e:	e04a                	sd	s2,0(sp)
    80004a20:	1000                	addi	s0,sp,32
    80004a22:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004a24:	0023c917          	auipc	s2,0x23c
    80004a28:	54490913          	addi	s2,s2,1348 # 80240f68 <log>
    80004a2c:	854a                	mv	a0,s2
    80004a2e:	ffffc097          	auipc	ra,0xffffc
    80004a32:	35a080e7          	jalr	858(ra) # 80000d88 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004a36:	02c92603          	lw	a2,44(s2)
    80004a3a:	47f5                	li	a5,29
    80004a3c:	06c7c563          	blt	a5,a2,80004aa6 <log_write+0x90>
    80004a40:	0023c797          	auipc	a5,0x23c
    80004a44:	5447a783          	lw	a5,1348(a5) # 80240f84 <log+0x1c>
    80004a48:	37fd                	addiw	a5,a5,-1
    80004a4a:	04f65e63          	bge	a2,a5,80004aa6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004a4e:	0023c797          	auipc	a5,0x23c
    80004a52:	53a7a783          	lw	a5,1338(a5) # 80240f88 <log+0x20>
    80004a56:	06f05063          	blez	a5,80004ab6 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004a5a:	4781                	li	a5,0
    80004a5c:	06c05563          	blez	a2,80004ac6 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004a60:	44cc                	lw	a1,12(s1)
    80004a62:	0023c717          	auipc	a4,0x23c
    80004a66:	53670713          	addi	a4,a4,1334 # 80240f98 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004a6a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004a6c:	4314                	lw	a3,0(a4)
    80004a6e:	04b68c63          	beq	a3,a1,80004ac6 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004a72:	2785                	addiw	a5,a5,1
    80004a74:	0711                	addi	a4,a4,4
    80004a76:	fef61be3          	bne	a2,a5,80004a6c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004a7a:	0621                	addi	a2,a2,8
    80004a7c:	060a                	slli	a2,a2,0x2
    80004a7e:	0023c797          	auipc	a5,0x23c
    80004a82:	4ea78793          	addi	a5,a5,1258 # 80240f68 <log>
    80004a86:	97b2                	add	a5,a5,a2
    80004a88:	44d8                	lw	a4,12(s1)
    80004a8a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	fffff097          	auipc	ra,0xfffff
    80004a92:	d7a080e7          	jalr	-646(ra) # 80003808 <bpin>
    log.lh.n++;
    80004a96:	0023c717          	auipc	a4,0x23c
    80004a9a:	4d270713          	addi	a4,a4,1234 # 80240f68 <log>
    80004a9e:	575c                	lw	a5,44(a4)
    80004aa0:	2785                	addiw	a5,a5,1
    80004aa2:	d75c                	sw	a5,44(a4)
    80004aa4:	a82d                	j	80004ade <log_write+0xc8>
    panic("too big a transaction");
    80004aa6:	00004517          	auipc	a0,0x4
    80004aaa:	ad250513          	addi	a0,a0,-1326 # 80008578 <etext+0x578>
    80004aae:	ffffc097          	auipc	ra,0xffffc
    80004ab2:	ab2080e7          	jalr	-1358(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004ab6:	00004517          	auipc	a0,0x4
    80004aba:	ada50513          	addi	a0,a0,-1318 # 80008590 <etext+0x590>
    80004abe:	ffffc097          	auipc	ra,0xffffc
    80004ac2:	aa2080e7          	jalr	-1374(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004ac6:	00878693          	addi	a3,a5,8
    80004aca:	068a                	slli	a3,a3,0x2
    80004acc:	0023c717          	auipc	a4,0x23c
    80004ad0:	49c70713          	addi	a4,a4,1180 # 80240f68 <log>
    80004ad4:	9736                	add	a4,a4,a3
    80004ad6:	44d4                	lw	a3,12(s1)
    80004ad8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004ada:	faf609e3          	beq	a2,a5,80004a8c <log_write+0x76>
  }
  release(&log.lock);
    80004ade:	0023c517          	auipc	a0,0x23c
    80004ae2:	48a50513          	addi	a0,a0,1162 # 80240f68 <log>
    80004ae6:	ffffc097          	auipc	ra,0xffffc
    80004aea:	356080e7          	jalr	854(ra) # 80000e3c <release>
}
    80004aee:	60e2                	ld	ra,24(sp)
    80004af0:	6442                	ld	s0,16(sp)
    80004af2:	64a2                	ld	s1,8(sp)
    80004af4:	6902                	ld	s2,0(sp)
    80004af6:	6105                	addi	sp,sp,32
    80004af8:	8082                	ret

0000000080004afa <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004afa:	1101                	addi	sp,sp,-32
    80004afc:	ec06                	sd	ra,24(sp)
    80004afe:	e822                	sd	s0,16(sp)
    80004b00:	e426                	sd	s1,8(sp)
    80004b02:	e04a                	sd	s2,0(sp)
    80004b04:	1000                	addi	s0,sp,32
    80004b06:	84aa                	mv	s1,a0
    80004b08:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004b0a:	00004597          	auipc	a1,0x4
    80004b0e:	aa658593          	addi	a1,a1,-1370 # 800085b0 <etext+0x5b0>
    80004b12:	0521                	addi	a0,a0,8
    80004b14:	ffffc097          	auipc	ra,0xffffc
    80004b18:	1e4080e7          	jalr	484(ra) # 80000cf8 <initlock>
  lk->name = name;
    80004b1c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004b20:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004b24:	0204a423          	sw	zero,40(s1)
}
    80004b28:	60e2                	ld	ra,24(sp)
    80004b2a:	6442                	ld	s0,16(sp)
    80004b2c:	64a2                	ld	s1,8(sp)
    80004b2e:	6902                	ld	s2,0(sp)
    80004b30:	6105                	addi	sp,sp,32
    80004b32:	8082                	ret

0000000080004b34 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004b34:	1101                	addi	sp,sp,-32
    80004b36:	ec06                	sd	ra,24(sp)
    80004b38:	e822                	sd	s0,16(sp)
    80004b3a:	e426                	sd	s1,8(sp)
    80004b3c:	e04a                	sd	s2,0(sp)
    80004b3e:	1000                	addi	s0,sp,32
    80004b40:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b42:	00850913          	addi	s2,a0,8
    80004b46:	854a                	mv	a0,s2
    80004b48:	ffffc097          	auipc	ra,0xffffc
    80004b4c:	240080e7          	jalr	576(ra) # 80000d88 <acquire>
  while (lk->locked) {
    80004b50:	409c                	lw	a5,0(s1)
    80004b52:	cb89                	beqz	a5,80004b64 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004b54:	85ca                	mv	a1,s2
    80004b56:	8526                	mv	a0,s1
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	8bc080e7          	jalr	-1860(ra) # 80002414 <sleep>
  while (lk->locked) {
    80004b60:	409c                	lw	a5,0(s1)
    80004b62:	fbed                	bnez	a5,80004b54 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004b64:	4785                	li	a5,1
    80004b66:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004b68:	ffffd097          	auipc	ra,0xffffd
    80004b6c:	1d4080e7          	jalr	468(ra) # 80001d3c <myproc>
    80004b70:	591c                	lw	a5,48(a0)
    80004b72:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004b74:	854a                	mv	a0,s2
    80004b76:	ffffc097          	auipc	ra,0xffffc
    80004b7a:	2c6080e7          	jalr	710(ra) # 80000e3c <release>
}
    80004b7e:	60e2                	ld	ra,24(sp)
    80004b80:	6442                	ld	s0,16(sp)
    80004b82:	64a2                	ld	s1,8(sp)
    80004b84:	6902                	ld	s2,0(sp)
    80004b86:	6105                	addi	sp,sp,32
    80004b88:	8082                	ret

0000000080004b8a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004b8a:	1101                	addi	sp,sp,-32
    80004b8c:	ec06                	sd	ra,24(sp)
    80004b8e:	e822                	sd	s0,16(sp)
    80004b90:	e426                	sd	s1,8(sp)
    80004b92:	e04a                	sd	s2,0(sp)
    80004b94:	1000                	addi	s0,sp,32
    80004b96:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b98:	00850913          	addi	s2,a0,8
    80004b9c:	854a                	mv	a0,s2
    80004b9e:	ffffc097          	auipc	ra,0xffffc
    80004ba2:	1ea080e7          	jalr	490(ra) # 80000d88 <acquire>
  lk->locked = 0;
    80004ba6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004baa:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004bae:	8526                	mv	a0,s1
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	8c8080e7          	jalr	-1848(ra) # 80002478 <wakeup>
  release(&lk->lk);
    80004bb8:	854a                	mv	a0,s2
    80004bba:	ffffc097          	auipc	ra,0xffffc
    80004bbe:	282080e7          	jalr	642(ra) # 80000e3c <release>
}
    80004bc2:	60e2                	ld	ra,24(sp)
    80004bc4:	6442                	ld	s0,16(sp)
    80004bc6:	64a2                	ld	s1,8(sp)
    80004bc8:	6902                	ld	s2,0(sp)
    80004bca:	6105                	addi	sp,sp,32
    80004bcc:	8082                	ret

0000000080004bce <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004bce:	7179                	addi	sp,sp,-48
    80004bd0:	f406                	sd	ra,40(sp)
    80004bd2:	f022                	sd	s0,32(sp)
    80004bd4:	ec26                	sd	s1,24(sp)
    80004bd6:	e84a                	sd	s2,16(sp)
    80004bd8:	1800                	addi	s0,sp,48
    80004bda:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004bdc:	00850913          	addi	s2,a0,8
    80004be0:	854a                	mv	a0,s2
    80004be2:	ffffc097          	auipc	ra,0xffffc
    80004be6:	1a6080e7          	jalr	422(ra) # 80000d88 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004bea:	409c                	lw	a5,0(s1)
    80004bec:	ef91                	bnez	a5,80004c08 <holdingsleep+0x3a>
    80004bee:	4481                	li	s1,0
  release(&lk->lk);
    80004bf0:	854a                	mv	a0,s2
    80004bf2:	ffffc097          	auipc	ra,0xffffc
    80004bf6:	24a080e7          	jalr	586(ra) # 80000e3c <release>
  return r;
}
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	70a2                	ld	ra,40(sp)
    80004bfe:	7402                	ld	s0,32(sp)
    80004c00:	64e2                	ld	s1,24(sp)
    80004c02:	6942                	ld	s2,16(sp)
    80004c04:	6145                	addi	sp,sp,48
    80004c06:	8082                	ret
    80004c08:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c0a:	0284a983          	lw	s3,40(s1)
    80004c0e:	ffffd097          	auipc	ra,0xffffd
    80004c12:	12e080e7          	jalr	302(ra) # 80001d3c <myproc>
    80004c16:	5904                	lw	s1,48(a0)
    80004c18:	413484b3          	sub	s1,s1,s3
    80004c1c:	0014b493          	seqz	s1,s1
    80004c20:	69a2                	ld	s3,8(sp)
    80004c22:	b7f9                	j	80004bf0 <holdingsleep+0x22>

0000000080004c24 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004c24:	1141                	addi	sp,sp,-16
    80004c26:	e406                	sd	ra,8(sp)
    80004c28:	e022                	sd	s0,0(sp)
    80004c2a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004c2c:	00004597          	auipc	a1,0x4
    80004c30:	99458593          	addi	a1,a1,-1644 # 800085c0 <etext+0x5c0>
    80004c34:	0023c517          	auipc	a0,0x23c
    80004c38:	47c50513          	addi	a0,a0,1148 # 802410b0 <ftable>
    80004c3c:	ffffc097          	auipc	ra,0xffffc
    80004c40:	0bc080e7          	jalr	188(ra) # 80000cf8 <initlock>
}
    80004c44:	60a2                	ld	ra,8(sp)
    80004c46:	6402                	ld	s0,0(sp)
    80004c48:	0141                	addi	sp,sp,16
    80004c4a:	8082                	ret

0000000080004c4c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004c4c:	1101                	addi	sp,sp,-32
    80004c4e:	ec06                	sd	ra,24(sp)
    80004c50:	e822                	sd	s0,16(sp)
    80004c52:	e426                	sd	s1,8(sp)
    80004c54:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004c56:	0023c517          	auipc	a0,0x23c
    80004c5a:	45a50513          	addi	a0,a0,1114 # 802410b0 <ftable>
    80004c5e:	ffffc097          	auipc	ra,0xffffc
    80004c62:	12a080e7          	jalr	298(ra) # 80000d88 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004c66:	0023c497          	auipc	s1,0x23c
    80004c6a:	46248493          	addi	s1,s1,1122 # 802410c8 <ftable+0x18>
    80004c6e:	0023d717          	auipc	a4,0x23d
    80004c72:	3fa70713          	addi	a4,a4,1018 # 80242068 <disk>
    if(f->ref == 0){
    80004c76:	40dc                	lw	a5,4(s1)
    80004c78:	cf99                	beqz	a5,80004c96 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004c7a:	02848493          	addi	s1,s1,40
    80004c7e:	fee49ce3          	bne	s1,a4,80004c76 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004c82:	0023c517          	auipc	a0,0x23c
    80004c86:	42e50513          	addi	a0,a0,1070 # 802410b0 <ftable>
    80004c8a:	ffffc097          	auipc	ra,0xffffc
    80004c8e:	1b2080e7          	jalr	434(ra) # 80000e3c <release>
  return 0;
    80004c92:	4481                	li	s1,0
    80004c94:	a819                	j	80004caa <filealloc+0x5e>
      f->ref = 1;
    80004c96:	4785                	li	a5,1
    80004c98:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004c9a:	0023c517          	auipc	a0,0x23c
    80004c9e:	41650513          	addi	a0,a0,1046 # 802410b0 <ftable>
    80004ca2:	ffffc097          	auipc	ra,0xffffc
    80004ca6:	19a080e7          	jalr	410(ra) # 80000e3c <release>
}
    80004caa:	8526                	mv	a0,s1
    80004cac:	60e2                	ld	ra,24(sp)
    80004cae:	6442                	ld	s0,16(sp)
    80004cb0:	64a2                	ld	s1,8(sp)
    80004cb2:	6105                	addi	sp,sp,32
    80004cb4:	8082                	ret

0000000080004cb6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004cb6:	1101                	addi	sp,sp,-32
    80004cb8:	ec06                	sd	ra,24(sp)
    80004cba:	e822                	sd	s0,16(sp)
    80004cbc:	e426                	sd	s1,8(sp)
    80004cbe:	1000                	addi	s0,sp,32
    80004cc0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004cc2:	0023c517          	auipc	a0,0x23c
    80004cc6:	3ee50513          	addi	a0,a0,1006 # 802410b0 <ftable>
    80004cca:	ffffc097          	auipc	ra,0xffffc
    80004cce:	0be080e7          	jalr	190(ra) # 80000d88 <acquire>
  if(f->ref < 1)
    80004cd2:	40dc                	lw	a5,4(s1)
    80004cd4:	02f05263          	blez	a5,80004cf8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004cd8:	2785                	addiw	a5,a5,1
    80004cda:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004cdc:	0023c517          	auipc	a0,0x23c
    80004ce0:	3d450513          	addi	a0,a0,980 # 802410b0 <ftable>
    80004ce4:	ffffc097          	auipc	ra,0xffffc
    80004ce8:	158080e7          	jalr	344(ra) # 80000e3c <release>
  return f;
}
    80004cec:	8526                	mv	a0,s1
    80004cee:	60e2                	ld	ra,24(sp)
    80004cf0:	6442                	ld	s0,16(sp)
    80004cf2:	64a2                	ld	s1,8(sp)
    80004cf4:	6105                	addi	sp,sp,32
    80004cf6:	8082                	ret
    panic("filedup");
    80004cf8:	00004517          	auipc	a0,0x4
    80004cfc:	8d050513          	addi	a0,a0,-1840 # 800085c8 <etext+0x5c8>
    80004d00:	ffffc097          	auipc	ra,0xffffc
    80004d04:	860080e7          	jalr	-1952(ra) # 80000560 <panic>

0000000080004d08 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004d08:	7139                	addi	sp,sp,-64
    80004d0a:	fc06                	sd	ra,56(sp)
    80004d0c:	f822                	sd	s0,48(sp)
    80004d0e:	f426                	sd	s1,40(sp)
    80004d10:	0080                	addi	s0,sp,64
    80004d12:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004d14:	0023c517          	auipc	a0,0x23c
    80004d18:	39c50513          	addi	a0,a0,924 # 802410b0 <ftable>
    80004d1c:	ffffc097          	auipc	ra,0xffffc
    80004d20:	06c080e7          	jalr	108(ra) # 80000d88 <acquire>
  if(f->ref < 1)
    80004d24:	40dc                	lw	a5,4(s1)
    80004d26:	04f05c63          	blez	a5,80004d7e <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004d2a:	37fd                	addiw	a5,a5,-1
    80004d2c:	0007871b          	sext.w	a4,a5
    80004d30:	c0dc                	sw	a5,4(s1)
    80004d32:	06e04263          	bgtz	a4,80004d96 <fileclose+0x8e>
    80004d36:	f04a                	sd	s2,32(sp)
    80004d38:	ec4e                	sd	s3,24(sp)
    80004d3a:	e852                	sd	s4,16(sp)
    80004d3c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004d3e:	0004a903          	lw	s2,0(s1)
    80004d42:	0094ca83          	lbu	s5,9(s1)
    80004d46:	0104ba03          	ld	s4,16(s1)
    80004d4a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004d4e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004d52:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004d56:	0023c517          	auipc	a0,0x23c
    80004d5a:	35a50513          	addi	a0,a0,858 # 802410b0 <ftable>
    80004d5e:	ffffc097          	auipc	ra,0xffffc
    80004d62:	0de080e7          	jalr	222(ra) # 80000e3c <release>

  if(ff.type == FD_PIPE){
    80004d66:	4785                	li	a5,1
    80004d68:	04f90463          	beq	s2,a5,80004db0 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004d6c:	3979                	addiw	s2,s2,-2
    80004d6e:	4785                	li	a5,1
    80004d70:	0527fb63          	bgeu	a5,s2,80004dc6 <fileclose+0xbe>
    80004d74:	7902                	ld	s2,32(sp)
    80004d76:	69e2                	ld	s3,24(sp)
    80004d78:	6a42                	ld	s4,16(sp)
    80004d7a:	6aa2                	ld	s5,8(sp)
    80004d7c:	a02d                	j	80004da6 <fileclose+0x9e>
    80004d7e:	f04a                	sd	s2,32(sp)
    80004d80:	ec4e                	sd	s3,24(sp)
    80004d82:	e852                	sd	s4,16(sp)
    80004d84:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004d86:	00004517          	auipc	a0,0x4
    80004d8a:	84a50513          	addi	a0,a0,-1974 # 800085d0 <etext+0x5d0>
    80004d8e:	ffffb097          	auipc	ra,0xffffb
    80004d92:	7d2080e7          	jalr	2002(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004d96:	0023c517          	auipc	a0,0x23c
    80004d9a:	31a50513          	addi	a0,a0,794 # 802410b0 <ftable>
    80004d9e:	ffffc097          	auipc	ra,0xffffc
    80004da2:	09e080e7          	jalr	158(ra) # 80000e3c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004da6:	70e2                	ld	ra,56(sp)
    80004da8:	7442                	ld	s0,48(sp)
    80004daa:	74a2                	ld	s1,40(sp)
    80004dac:	6121                	addi	sp,sp,64
    80004dae:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004db0:	85d6                	mv	a1,s5
    80004db2:	8552                	mv	a0,s4
    80004db4:	00000097          	auipc	ra,0x0
    80004db8:	3a2080e7          	jalr	930(ra) # 80005156 <pipeclose>
    80004dbc:	7902                	ld	s2,32(sp)
    80004dbe:	69e2                	ld	s3,24(sp)
    80004dc0:	6a42                	ld	s4,16(sp)
    80004dc2:	6aa2                	ld	s5,8(sp)
    80004dc4:	b7cd                	j	80004da6 <fileclose+0x9e>
    begin_op();
    80004dc6:	00000097          	auipc	ra,0x0
    80004dca:	a78080e7          	jalr	-1416(ra) # 8000483e <begin_op>
    iput(ff.ip);
    80004dce:	854e                	mv	a0,s3
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	25e080e7          	jalr	606(ra) # 8000402e <iput>
    end_op();
    80004dd8:	00000097          	auipc	ra,0x0
    80004ddc:	ae0080e7          	jalr	-1312(ra) # 800048b8 <end_op>
    80004de0:	7902                	ld	s2,32(sp)
    80004de2:	69e2                	ld	s3,24(sp)
    80004de4:	6a42                	ld	s4,16(sp)
    80004de6:	6aa2                	ld	s5,8(sp)
    80004de8:	bf7d                	j	80004da6 <fileclose+0x9e>

0000000080004dea <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004dea:	715d                	addi	sp,sp,-80
    80004dec:	e486                	sd	ra,72(sp)
    80004dee:	e0a2                	sd	s0,64(sp)
    80004df0:	fc26                	sd	s1,56(sp)
    80004df2:	f44e                	sd	s3,40(sp)
    80004df4:	0880                	addi	s0,sp,80
    80004df6:	84aa                	mv	s1,a0
    80004df8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004dfa:	ffffd097          	auipc	ra,0xffffd
    80004dfe:	f42080e7          	jalr	-190(ra) # 80001d3c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004e02:	409c                	lw	a5,0(s1)
    80004e04:	37f9                	addiw	a5,a5,-2
    80004e06:	4705                	li	a4,1
    80004e08:	04f76863          	bltu	a4,a5,80004e58 <filestat+0x6e>
    80004e0c:	f84a                	sd	s2,48(sp)
    80004e0e:	892a                	mv	s2,a0
    ilock(f->ip);
    80004e10:	6c88                	ld	a0,24(s1)
    80004e12:	fffff097          	auipc	ra,0xfffff
    80004e16:	05e080e7          	jalr	94(ra) # 80003e70 <ilock>
    stati(f->ip, &st);
    80004e1a:	fb840593          	addi	a1,s0,-72
    80004e1e:	6c88                	ld	a0,24(s1)
    80004e20:	fffff097          	auipc	ra,0xfffff
    80004e24:	2de080e7          	jalr	734(ra) # 800040fe <stati>
    iunlock(f->ip);
    80004e28:	6c88                	ld	a0,24(s1)
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	10c080e7          	jalr	268(ra) # 80003f36 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004e32:	46e1                	li	a3,24
    80004e34:	fb840613          	addi	a2,s0,-72
    80004e38:	85ce                	mv	a1,s3
    80004e3a:	05093503          	ld	a0,80(s2)
    80004e3e:	ffffd097          	auipc	ra,0xffffd
    80004e42:	a32080e7          	jalr	-1486(ra) # 80001870 <copyout>
    80004e46:	41f5551b          	sraiw	a0,a0,0x1f
    80004e4a:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004e4c:	60a6                	ld	ra,72(sp)
    80004e4e:	6406                	ld	s0,64(sp)
    80004e50:	74e2                	ld	s1,56(sp)
    80004e52:	79a2                	ld	s3,40(sp)
    80004e54:	6161                	addi	sp,sp,80
    80004e56:	8082                	ret
  return -1;
    80004e58:	557d                	li	a0,-1
    80004e5a:	bfcd                	j	80004e4c <filestat+0x62>

0000000080004e5c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004e5c:	7179                	addi	sp,sp,-48
    80004e5e:	f406                	sd	ra,40(sp)
    80004e60:	f022                	sd	s0,32(sp)
    80004e62:	e84a                	sd	s2,16(sp)
    80004e64:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004e66:	00854783          	lbu	a5,8(a0)
    80004e6a:	cbc5                	beqz	a5,80004f1a <fileread+0xbe>
    80004e6c:	ec26                	sd	s1,24(sp)
    80004e6e:	e44e                	sd	s3,8(sp)
    80004e70:	84aa                	mv	s1,a0
    80004e72:	89ae                	mv	s3,a1
    80004e74:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e76:	411c                	lw	a5,0(a0)
    80004e78:	4705                	li	a4,1
    80004e7a:	04e78963          	beq	a5,a4,80004ecc <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e7e:	470d                	li	a4,3
    80004e80:	04e78f63          	beq	a5,a4,80004ede <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e84:	4709                	li	a4,2
    80004e86:	08e79263          	bne	a5,a4,80004f0a <fileread+0xae>
    ilock(f->ip);
    80004e8a:	6d08                	ld	a0,24(a0)
    80004e8c:	fffff097          	auipc	ra,0xfffff
    80004e90:	fe4080e7          	jalr	-28(ra) # 80003e70 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004e94:	874a                	mv	a4,s2
    80004e96:	5094                	lw	a3,32(s1)
    80004e98:	864e                	mv	a2,s3
    80004e9a:	4585                	li	a1,1
    80004e9c:	6c88                	ld	a0,24(s1)
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	28a080e7          	jalr	650(ra) # 80004128 <readi>
    80004ea6:	892a                	mv	s2,a0
    80004ea8:	00a05563          	blez	a0,80004eb2 <fileread+0x56>
      f->off += r;
    80004eac:	509c                	lw	a5,32(s1)
    80004eae:	9fa9                	addw	a5,a5,a0
    80004eb0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004eb2:	6c88                	ld	a0,24(s1)
    80004eb4:	fffff097          	auipc	ra,0xfffff
    80004eb8:	082080e7          	jalr	130(ra) # 80003f36 <iunlock>
    80004ebc:	64e2                	ld	s1,24(sp)
    80004ebe:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004ec0:	854a                	mv	a0,s2
    80004ec2:	70a2                	ld	ra,40(sp)
    80004ec4:	7402                	ld	s0,32(sp)
    80004ec6:	6942                	ld	s2,16(sp)
    80004ec8:	6145                	addi	sp,sp,48
    80004eca:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004ecc:	6908                	ld	a0,16(a0)
    80004ece:	00000097          	auipc	ra,0x0
    80004ed2:	400080e7          	jalr	1024(ra) # 800052ce <piperead>
    80004ed6:	892a                	mv	s2,a0
    80004ed8:	64e2                	ld	s1,24(sp)
    80004eda:	69a2                	ld	s3,8(sp)
    80004edc:	b7d5                	j	80004ec0 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004ede:	02451783          	lh	a5,36(a0)
    80004ee2:	03079693          	slli	a3,a5,0x30
    80004ee6:	92c1                	srli	a3,a3,0x30
    80004ee8:	4725                	li	a4,9
    80004eea:	02d76a63          	bltu	a4,a3,80004f1e <fileread+0xc2>
    80004eee:	0792                	slli	a5,a5,0x4
    80004ef0:	0023c717          	auipc	a4,0x23c
    80004ef4:	12070713          	addi	a4,a4,288 # 80241010 <devsw>
    80004ef8:	97ba                	add	a5,a5,a4
    80004efa:	639c                	ld	a5,0(a5)
    80004efc:	c78d                	beqz	a5,80004f26 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80004efe:	4505                	li	a0,1
    80004f00:	9782                	jalr	a5
    80004f02:	892a                	mv	s2,a0
    80004f04:	64e2                	ld	s1,24(sp)
    80004f06:	69a2                	ld	s3,8(sp)
    80004f08:	bf65                	j	80004ec0 <fileread+0x64>
    panic("fileread");
    80004f0a:	00003517          	auipc	a0,0x3
    80004f0e:	6d650513          	addi	a0,a0,1750 # 800085e0 <etext+0x5e0>
    80004f12:	ffffb097          	auipc	ra,0xffffb
    80004f16:	64e080e7          	jalr	1614(ra) # 80000560 <panic>
    return -1;
    80004f1a:	597d                	li	s2,-1
    80004f1c:	b755                	j	80004ec0 <fileread+0x64>
      return -1;
    80004f1e:	597d                	li	s2,-1
    80004f20:	64e2                	ld	s1,24(sp)
    80004f22:	69a2                	ld	s3,8(sp)
    80004f24:	bf71                	j	80004ec0 <fileread+0x64>
    80004f26:	597d                	li	s2,-1
    80004f28:	64e2                	ld	s1,24(sp)
    80004f2a:	69a2                	ld	s3,8(sp)
    80004f2c:	bf51                	j	80004ec0 <fileread+0x64>

0000000080004f2e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004f2e:	00954783          	lbu	a5,9(a0)
    80004f32:	12078963          	beqz	a5,80005064 <filewrite+0x136>
{
    80004f36:	715d                	addi	sp,sp,-80
    80004f38:	e486                	sd	ra,72(sp)
    80004f3a:	e0a2                	sd	s0,64(sp)
    80004f3c:	f84a                	sd	s2,48(sp)
    80004f3e:	f052                	sd	s4,32(sp)
    80004f40:	e85a                	sd	s6,16(sp)
    80004f42:	0880                	addi	s0,sp,80
    80004f44:	892a                	mv	s2,a0
    80004f46:	8b2e                	mv	s6,a1
    80004f48:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f4a:	411c                	lw	a5,0(a0)
    80004f4c:	4705                	li	a4,1
    80004f4e:	02e78763          	beq	a5,a4,80004f7c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f52:	470d                	li	a4,3
    80004f54:	02e78a63          	beq	a5,a4,80004f88 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f58:	4709                	li	a4,2
    80004f5a:	0ee79863          	bne	a5,a4,8000504a <filewrite+0x11c>
    80004f5e:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004f60:	0cc05463          	blez	a2,80005028 <filewrite+0xfa>
    80004f64:	fc26                	sd	s1,56(sp)
    80004f66:	ec56                	sd	s5,24(sp)
    80004f68:	e45e                	sd	s7,8(sp)
    80004f6a:	e062                	sd	s8,0(sp)
    int i = 0;
    80004f6c:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004f6e:	6b85                	lui	s7,0x1
    80004f70:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004f74:	6c05                	lui	s8,0x1
    80004f76:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004f7a:	a851                	j	8000500e <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004f7c:	6908                	ld	a0,16(a0)
    80004f7e:	00000097          	auipc	ra,0x0
    80004f82:	248080e7          	jalr	584(ra) # 800051c6 <pipewrite>
    80004f86:	a85d                	j	8000503c <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004f88:	02451783          	lh	a5,36(a0)
    80004f8c:	03079693          	slli	a3,a5,0x30
    80004f90:	92c1                	srli	a3,a3,0x30
    80004f92:	4725                	li	a4,9
    80004f94:	0cd76a63          	bltu	a4,a3,80005068 <filewrite+0x13a>
    80004f98:	0792                	slli	a5,a5,0x4
    80004f9a:	0023c717          	auipc	a4,0x23c
    80004f9e:	07670713          	addi	a4,a4,118 # 80241010 <devsw>
    80004fa2:	97ba                	add	a5,a5,a4
    80004fa4:	679c                	ld	a5,8(a5)
    80004fa6:	c3f9                	beqz	a5,8000506c <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80004fa8:	4505                	li	a0,1
    80004faa:	9782                	jalr	a5
    80004fac:	a841                	j	8000503c <filewrite+0x10e>
      if(n1 > max)
    80004fae:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004fb2:	00000097          	auipc	ra,0x0
    80004fb6:	88c080e7          	jalr	-1908(ra) # 8000483e <begin_op>
      ilock(f->ip);
    80004fba:	01893503          	ld	a0,24(s2)
    80004fbe:	fffff097          	auipc	ra,0xfffff
    80004fc2:	eb2080e7          	jalr	-334(ra) # 80003e70 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004fc6:	8756                	mv	a4,s5
    80004fc8:	02092683          	lw	a3,32(s2)
    80004fcc:	01698633          	add	a2,s3,s6
    80004fd0:	4585                	li	a1,1
    80004fd2:	01893503          	ld	a0,24(s2)
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	262080e7          	jalr	610(ra) # 80004238 <writei>
    80004fde:	84aa                	mv	s1,a0
    80004fe0:	00a05763          	blez	a0,80004fee <filewrite+0xc0>
        f->off += r;
    80004fe4:	02092783          	lw	a5,32(s2)
    80004fe8:	9fa9                	addw	a5,a5,a0
    80004fea:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004fee:	01893503          	ld	a0,24(s2)
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	f44080e7          	jalr	-188(ra) # 80003f36 <iunlock>
      end_op();
    80004ffa:	00000097          	auipc	ra,0x0
    80004ffe:	8be080e7          	jalr	-1858(ra) # 800048b8 <end_op>

      if(r != n1){
    80005002:	029a9563          	bne	s5,s1,8000502c <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80005006:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000500a:	0149da63          	bge	s3,s4,8000501e <filewrite+0xf0>
      int n1 = n - i;
    8000500e:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80005012:	0004879b          	sext.w	a5,s1
    80005016:	f8fbdce3          	bge	s7,a5,80004fae <filewrite+0x80>
    8000501a:	84e2                	mv	s1,s8
    8000501c:	bf49                	j	80004fae <filewrite+0x80>
    8000501e:	74e2                	ld	s1,56(sp)
    80005020:	6ae2                	ld	s5,24(sp)
    80005022:	6ba2                	ld	s7,8(sp)
    80005024:	6c02                	ld	s8,0(sp)
    80005026:	a039                	j	80005034 <filewrite+0x106>
    int i = 0;
    80005028:	4981                	li	s3,0
    8000502a:	a029                	j	80005034 <filewrite+0x106>
    8000502c:	74e2                	ld	s1,56(sp)
    8000502e:	6ae2                	ld	s5,24(sp)
    80005030:	6ba2                	ld	s7,8(sp)
    80005032:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80005034:	033a1e63          	bne	s4,s3,80005070 <filewrite+0x142>
    80005038:	8552                	mv	a0,s4
    8000503a:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000503c:	60a6                	ld	ra,72(sp)
    8000503e:	6406                	ld	s0,64(sp)
    80005040:	7942                	ld	s2,48(sp)
    80005042:	7a02                	ld	s4,32(sp)
    80005044:	6b42                	ld	s6,16(sp)
    80005046:	6161                	addi	sp,sp,80
    80005048:	8082                	ret
    8000504a:	fc26                	sd	s1,56(sp)
    8000504c:	f44e                	sd	s3,40(sp)
    8000504e:	ec56                	sd	s5,24(sp)
    80005050:	e45e                	sd	s7,8(sp)
    80005052:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80005054:	00003517          	auipc	a0,0x3
    80005058:	59c50513          	addi	a0,a0,1436 # 800085f0 <etext+0x5f0>
    8000505c:	ffffb097          	auipc	ra,0xffffb
    80005060:	504080e7          	jalr	1284(ra) # 80000560 <panic>
    return -1;
    80005064:	557d                	li	a0,-1
}
    80005066:	8082                	ret
      return -1;
    80005068:	557d                	li	a0,-1
    8000506a:	bfc9                	j	8000503c <filewrite+0x10e>
    8000506c:	557d                	li	a0,-1
    8000506e:	b7f9                	j	8000503c <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80005070:	557d                	li	a0,-1
    80005072:	79a2                	ld	s3,40(sp)
    80005074:	b7e1                	j	8000503c <filewrite+0x10e>

0000000080005076 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005076:	7179                	addi	sp,sp,-48
    80005078:	f406                	sd	ra,40(sp)
    8000507a:	f022                	sd	s0,32(sp)
    8000507c:	ec26                	sd	s1,24(sp)
    8000507e:	e052                	sd	s4,0(sp)
    80005080:	1800                	addi	s0,sp,48
    80005082:	84aa                	mv	s1,a0
    80005084:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005086:	0005b023          	sd	zero,0(a1)
    8000508a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000508e:	00000097          	auipc	ra,0x0
    80005092:	bbe080e7          	jalr	-1090(ra) # 80004c4c <filealloc>
    80005096:	e088                	sd	a0,0(s1)
    80005098:	cd49                	beqz	a0,80005132 <pipealloc+0xbc>
    8000509a:	00000097          	auipc	ra,0x0
    8000509e:	bb2080e7          	jalr	-1102(ra) # 80004c4c <filealloc>
    800050a2:	00aa3023          	sd	a0,0(s4)
    800050a6:	c141                	beqz	a0,80005126 <pipealloc+0xb0>
    800050a8:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800050aa:	ffffc097          	auipc	ra,0xffffc
    800050ae:	bb4080e7          	jalr	-1100(ra) # 80000c5e <kalloc>
    800050b2:	892a                	mv	s2,a0
    800050b4:	c13d                	beqz	a0,8000511a <pipealloc+0xa4>
    800050b6:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800050b8:	4985                	li	s3,1
    800050ba:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800050be:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800050c2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800050c6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800050ca:	00003597          	auipc	a1,0x3
    800050ce:	53658593          	addi	a1,a1,1334 # 80008600 <etext+0x600>
    800050d2:	ffffc097          	auipc	ra,0xffffc
    800050d6:	c26080e7          	jalr	-986(ra) # 80000cf8 <initlock>
  (*f0)->type = FD_PIPE;
    800050da:	609c                	ld	a5,0(s1)
    800050dc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800050e0:	609c                	ld	a5,0(s1)
    800050e2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800050e6:	609c                	ld	a5,0(s1)
    800050e8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800050ec:	609c                	ld	a5,0(s1)
    800050ee:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800050f2:	000a3783          	ld	a5,0(s4)
    800050f6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800050fa:	000a3783          	ld	a5,0(s4)
    800050fe:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005102:	000a3783          	ld	a5,0(s4)
    80005106:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000510a:	000a3783          	ld	a5,0(s4)
    8000510e:	0127b823          	sd	s2,16(a5)
  return 0;
    80005112:	4501                	li	a0,0
    80005114:	6942                	ld	s2,16(sp)
    80005116:	69a2                	ld	s3,8(sp)
    80005118:	a03d                	j	80005146 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000511a:	6088                	ld	a0,0(s1)
    8000511c:	c119                	beqz	a0,80005122 <pipealloc+0xac>
    8000511e:	6942                	ld	s2,16(sp)
    80005120:	a029                	j	8000512a <pipealloc+0xb4>
    80005122:	6942                	ld	s2,16(sp)
    80005124:	a039                	j	80005132 <pipealloc+0xbc>
    80005126:	6088                	ld	a0,0(s1)
    80005128:	c50d                	beqz	a0,80005152 <pipealloc+0xdc>
    fileclose(*f0);
    8000512a:	00000097          	auipc	ra,0x0
    8000512e:	bde080e7          	jalr	-1058(ra) # 80004d08 <fileclose>
  if(*f1)
    80005132:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005136:	557d                	li	a0,-1
  if(*f1)
    80005138:	c799                	beqz	a5,80005146 <pipealloc+0xd0>
    fileclose(*f1);
    8000513a:	853e                	mv	a0,a5
    8000513c:	00000097          	auipc	ra,0x0
    80005140:	bcc080e7          	jalr	-1076(ra) # 80004d08 <fileclose>
  return -1;
    80005144:	557d                	li	a0,-1
}
    80005146:	70a2                	ld	ra,40(sp)
    80005148:	7402                	ld	s0,32(sp)
    8000514a:	64e2                	ld	s1,24(sp)
    8000514c:	6a02                	ld	s4,0(sp)
    8000514e:	6145                	addi	sp,sp,48
    80005150:	8082                	ret
  return -1;
    80005152:	557d                	li	a0,-1
    80005154:	bfcd                	j	80005146 <pipealloc+0xd0>

0000000080005156 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005156:	1101                	addi	sp,sp,-32
    80005158:	ec06                	sd	ra,24(sp)
    8000515a:	e822                	sd	s0,16(sp)
    8000515c:	e426                	sd	s1,8(sp)
    8000515e:	e04a                	sd	s2,0(sp)
    80005160:	1000                	addi	s0,sp,32
    80005162:	84aa                	mv	s1,a0
    80005164:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005166:	ffffc097          	auipc	ra,0xffffc
    8000516a:	c22080e7          	jalr	-990(ra) # 80000d88 <acquire>
  if(writable){
    8000516e:	02090d63          	beqz	s2,800051a8 <pipeclose+0x52>
    pi->writeopen = 0;
    80005172:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005176:	21848513          	addi	a0,s1,536
    8000517a:	ffffd097          	auipc	ra,0xffffd
    8000517e:	2fe080e7          	jalr	766(ra) # 80002478 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005182:	2204b783          	ld	a5,544(s1)
    80005186:	eb95                	bnez	a5,800051ba <pipeclose+0x64>
    release(&pi->lock);
    80005188:	8526                	mv	a0,s1
    8000518a:	ffffc097          	auipc	ra,0xffffc
    8000518e:	cb2080e7          	jalr	-846(ra) # 80000e3c <release>
    kfree((char*)pi);
    80005192:	8526                	mv	a0,s1
    80005194:	ffffc097          	auipc	ra,0xffffc
    80005198:	8b6080e7          	jalr	-1866(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    8000519c:	60e2                	ld	ra,24(sp)
    8000519e:	6442                	ld	s0,16(sp)
    800051a0:	64a2                	ld	s1,8(sp)
    800051a2:	6902                	ld	s2,0(sp)
    800051a4:	6105                	addi	sp,sp,32
    800051a6:	8082                	ret
    pi->readopen = 0;
    800051a8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800051ac:	21c48513          	addi	a0,s1,540
    800051b0:	ffffd097          	auipc	ra,0xffffd
    800051b4:	2c8080e7          	jalr	712(ra) # 80002478 <wakeup>
    800051b8:	b7e9                	j	80005182 <pipeclose+0x2c>
    release(&pi->lock);
    800051ba:	8526                	mv	a0,s1
    800051bc:	ffffc097          	auipc	ra,0xffffc
    800051c0:	c80080e7          	jalr	-896(ra) # 80000e3c <release>
}
    800051c4:	bfe1                	j	8000519c <pipeclose+0x46>

00000000800051c6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800051c6:	711d                	addi	sp,sp,-96
    800051c8:	ec86                	sd	ra,88(sp)
    800051ca:	e8a2                	sd	s0,80(sp)
    800051cc:	e4a6                	sd	s1,72(sp)
    800051ce:	e0ca                	sd	s2,64(sp)
    800051d0:	fc4e                	sd	s3,56(sp)
    800051d2:	f852                	sd	s4,48(sp)
    800051d4:	f456                	sd	s5,40(sp)
    800051d6:	1080                	addi	s0,sp,96
    800051d8:	84aa                	mv	s1,a0
    800051da:	8aae                	mv	s5,a1
    800051dc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800051de:	ffffd097          	auipc	ra,0xffffd
    800051e2:	b5e080e7          	jalr	-1186(ra) # 80001d3c <myproc>
    800051e6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800051e8:	8526                	mv	a0,s1
    800051ea:	ffffc097          	auipc	ra,0xffffc
    800051ee:	b9e080e7          	jalr	-1122(ra) # 80000d88 <acquire>
  while(i < n){
    800051f2:	0d405863          	blez	s4,800052c2 <pipewrite+0xfc>
    800051f6:	f05a                	sd	s6,32(sp)
    800051f8:	ec5e                	sd	s7,24(sp)
    800051fa:	e862                	sd	s8,16(sp)
  int i = 0;
    800051fc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800051fe:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80005200:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005204:	21c48b93          	addi	s7,s1,540
    80005208:	a089                	j	8000524a <pipewrite+0x84>
      release(&pi->lock);
    8000520a:	8526                	mv	a0,s1
    8000520c:	ffffc097          	auipc	ra,0xffffc
    80005210:	c30080e7          	jalr	-976(ra) # 80000e3c <release>
      return -1;
    80005214:	597d                	li	s2,-1
    80005216:	7b02                	ld	s6,32(sp)
    80005218:	6be2                	ld	s7,24(sp)
    8000521a:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000521c:	854a                	mv	a0,s2
    8000521e:	60e6                	ld	ra,88(sp)
    80005220:	6446                	ld	s0,80(sp)
    80005222:	64a6                	ld	s1,72(sp)
    80005224:	6906                	ld	s2,64(sp)
    80005226:	79e2                	ld	s3,56(sp)
    80005228:	7a42                	ld	s4,48(sp)
    8000522a:	7aa2                	ld	s5,40(sp)
    8000522c:	6125                	addi	sp,sp,96
    8000522e:	8082                	ret
      wakeup(&pi->nread);
    80005230:	8562                	mv	a0,s8
    80005232:	ffffd097          	auipc	ra,0xffffd
    80005236:	246080e7          	jalr	582(ra) # 80002478 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000523a:	85a6                	mv	a1,s1
    8000523c:	855e                	mv	a0,s7
    8000523e:	ffffd097          	auipc	ra,0xffffd
    80005242:	1d6080e7          	jalr	470(ra) # 80002414 <sleep>
  while(i < n){
    80005246:	05495f63          	bge	s2,s4,800052a4 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    8000524a:	2204a783          	lw	a5,544(s1)
    8000524e:	dfd5                	beqz	a5,8000520a <pipewrite+0x44>
    80005250:	854e                	mv	a0,s3
    80005252:	ffffd097          	auipc	ra,0xffffd
    80005256:	476080e7          	jalr	1142(ra) # 800026c8 <killed>
    8000525a:	f945                	bnez	a0,8000520a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000525c:	2184a783          	lw	a5,536(s1)
    80005260:	21c4a703          	lw	a4,540(s1)
    80005264:	2007879b          	addiw	a5,a5,512
    80005268:	fcf704e3          	beq	a4,a5,80005230 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000526c:	4685                	li	a3,1
    8000526e:	01590633          	add	a2,s2,s5
    80005272:	faf40593          	addi	a1,s0,-81
    80005276:	0509b503          	ld	a0,80(s3)
    8000527a:	ffffc097          	auipc	ra,0xffffc
    8000527e:	7e6080e7          	jalr	2022(ra) # 80001a60 <copyin>
    80005282:	05650263          	beq	a0,s6,800052c6 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005286:	21c4a783          	lw	a5,540(s1)
    8000528a:	0017871b          	addiw	a4,a5,1
    8000528e:	20e4ae23          	sw	a4,540(s1)
    80005292:	1ff7f793          	andi	a5,a5,511
    80005296:	97a6                	add	a5,a5,s1
    80005298:	faf44703          	lbu	a4,-81(s0)
    8000529c:	00e78c23          	sb	a4,24(a5)
      i++;
    800052a0:	2905                	addiw	s2,s2,1
    800052a2:	b755                	j	80005246 <pipewrite+0x80>
    800052a4:	7b02                	ld	s6,32(sp)
    800052a6:	6be2                	ld	s7,24(sp)
    800052a8:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800052aa:	21848513          	addi	a0,s1,536
    800052ae:	ffffd097          	auipc	ra,0xffffd
    800052b2:	1ca080e7          	jalr	458(ra) # 80002478 <wakeup>
  release(&pi->lock);
    800052b6:	8526                	mv	a0,s1
    800052b8:	ffffc097          	auipc	ra,0xffffc
    800052bc:	b84080e7          	jalr	-1148(ra) # 80000e3c <release>
  return i;
    800052c0:	bfb1                	j	8000521c <pipewrite+0x56>
  int i = 0;
    800052c2:	4901                	li	s2,0
    800052c4:	b7dd                	j	800052aa <pipewrite+0xe4>
    800052c6:	7b02                	ld	s6,32(sp)
    800052c8:	6be2                	ld	s7,24(sp)
    800052ca:	6c42                	ld	s8,16(sp)
    800052cc:	bff9                	j	800052aa <pipewrite+0xe4>

00000000800052ce <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800052ce:	715d                	addi	sp,sp,-80
    800052d0:	e486                	sd	ra,72(sp)
    800052d2:	e0a2                	sd	s0,64(sp)
    800052d4:	fc26                	sd	s1,56(sp)
    800052d6:	f84a                	sd	s2,48(sp)
    800052d8:	f44e                	sd	s3,40(sp)
    800052da:	f052                	sd	s4,32(sp)
    800052dc:	ec56                	sd	s5,24(sp)
    800052de:	0880                	addi	s0,sp,80
    800052e0:	84aa                	mv	s1,a0
    800052e2:	892e                	mv	s2,a1
    800052e4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800052e6:	ffffd097          	auipc	ra,0xffffd
    800052ea:	a56080e7          	jalr	-1450(ra) # 80001d3c <myproc>
    800052ee:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800052f0:	8526                	mv	a0,s1
    800052f2:	ffffc097          	auipc	ra,0xffffc
    800052f6:	a96080e7          	jalr	-1386(ra) # 80000d88 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800052fa:	2184a703          	lw	a4,536(s1)
    800052fe:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005302:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005306:	02f71963          	bne	a4,a5,80005338 <piperead+0x6a>
    8000530a:	2244a783          	lw	a5,548(s1)
    8000530e:	cf95                	beqz	a5,8000534a <piperead+0x7c>
    if(killed(pr)){
    80005310:	8552                	mv	a0,s4
    80005312:	ffffd097          	auipc	ra,0xffffd
    80005316:	3b6080e7          	jalr	950(ra) # 800026c8 <killed>
    8000531a:	e10d                	bnez	a0,8000533c <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000531c:	85a6                	mv	a1,s1
    8000531e:	854e                	mv	a0,s3
    80005320:	ffffd097          	auipc	ra,0xffffd
    80005324:	0f4080e7          	jalr	244(ra) # 80002414 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005328:	2184a703          	lw	a4,536(s1)
    8000532c:	21c4a783          	lw	a5,540(s1)
    80005330:	fcf70de3          	beq	a4,a5,8000530a <piperead+0x3c>
    80005334:	e85a                	sd	s6,16(sp)
    80005336:	a819                	j	8000534c <piperead+0x7e>
    80005338:	e85a                	sd	s6,16(sp)
    8000533a:	a809                	j	8000534c <piperead+0x7e>
      release(&pi->lock);
    8000533c:	8526                	mv	a0,s1
    8000533e:	ffffc097          	auipc	ra,0xffffc
    80005342:	afe080e7          	jalr	-1282(ra) # 80000e3c <release>
      return -1;
    80005346:	59fd                	li	s3,-1
    80005348:	a0a5                	j	800053b0 <piperead+0xe2>
    8000534a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000534c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000534e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005350:	05505463          	blez	s5,80005398 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80005354:	2184a783          	lw	a5,536(s1)
    80005358:	21c4a703          	lw	a4,540(s1)
    8000535c:	02f70e63          	beq	a4,a5,80005398 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005360:	0017871b          	addiw	a4,a5,1
    80005364:	20e4ac23          	sw	a4,536(s1)
    80005368:	1ff7f793          	andi	a5,a5,511
    8000536c:	97a6                	add	a5,a5,s1
    8000536e:	0187c783          	lbu	a5,24(a5)
    80005372:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005376:	4685                	li	a3,1
    80005378:	fbf40613          	addi	a2,s0,-65
    8000537c:	85ca                	mv	a1,s2
    8000537e:	050a3503          	ld	a0,80(s4)
    80005382:	ffffc097          	auipc	ra,0xffffc
    80005386:	4ee080e7          	jalr	1262(ra) # 80001870 <copyout>
    8000538a:	01650763          	beq	a0,s6,80005398 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000538e:	2985                	addiw	s3,s3,1
    80005390:	0905                	addi	s2,s2,1
    80005392:	fd3a91e3          	bne	s5,s3,80005354 <piperead+0x86>
    80005396:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005398:	21c48513          	addi	a0,s1,540
    8000539c:	ffffd097          	auipc	ra,0xffffd
    800053a0:	0dc080e7          	jalr	220(ra) # 80002478 <wakeup>
  release(&pi->lock);
    800053a4:	8526                	mv	a0,s1
    800053a6:	ffffc097          	auipc	ra,0xffffc
    800053aa:	a96080e7          	jalr	-1386(ra) # 80000e3c <release>
    800053ae:	6b42                	ld	s6,16(sp)
  return i;
}
    800053b0:	854e                	mv	a0,s3
    800053b2:	60a6                	ld	ra,72(sp)
    800053b4:	6406                	ld	s0,64(sp)
    800053b6:	74e2                	ld	s1,56(sp)
    800053b8:	7942                	ld	s2,48(sp)
    800053ba:	79a2                	ld	s3,40(sp)
    800053bc:	7a02                	ld	s4,32(sp)
    800053be:	6ae2                	ld	s5,24(sp)
    800053c0:	6161                	addi	sp,sp,80
    800053c2:	8082                	ret

00000000800053c4 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800053c4:	1141                	addi	sp,sp,-16
    800053c6:	e422                	sd	s0,8(sp)
    800053c8:	0800                	addi	s0,sp,16
    800053ca:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800053cc:	8905                	andi	a0,a0,1
    800053ce:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800053d0:	8b89                	andi	a5,a5,2
    800053d2:	c399                	beqz	a5,800053d8 <flags2perm+0x14>
      perm |= PTE_W;
    800053d4:	00456513          	ori	a0,a0,4
    return perm;
}
    800053d8:	6422                	ld	s0,8(sp)
    800053da:	0141                	addi	sp,sp,16
    800053dc:	8082                	ret

00000000800053de <exec>:

int
exec(char *path, char **argv)
{
    800053de:	df010113          	addi	sp,sp,-528
    800053e2:	20113423          	sd	ra,520(sp)
    800053e6:	20813023          	sd	s0,512(sp)
    800053ea:	ffa6                	sd	s1,504(sp)
    800053ec:	fbca                	sd	s2,496(sp)
    800053ee:	0c00                	addi	s0,sp,528
    800053f0:	892a                	mv	s2,a0
    800053f2:	dea43c23          	sd	a0,-520(s0)
    800053f6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800053fa:	ffffd097          	auipc	ra,0xffffd
    800053fe:	942080e7          	jalr	-1726(ra) # 80001d3c <myproc>
    80005402:	84aa                	mv	s1,a0

  begin_op();
    80005404:	fffff097          	auipc	ra,0xfffff
    80005408:	43a080e7          	jalr	1082(ra) # 8000483e <begin_op>

  if((ip = namei(path)) == 0){
    8000540c:	854a                	mv	a0,s2
    8000540e:	fffff097          	auipc	ra,0xfffff
    80005412:	230080e7          	jalr	560(ra) # 8000463e <namei>
    80005416:	c135                	beqz	a0,8000547a <exec+0x9c>
    80005418:	f3d2                	sd	s4,480(sp)
    8000541a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000541c:	fffff097          	auipc	ra,0xfffff
    80005420:	a54080e7          	jalr	-1452(ra) # 80003e70 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005424:	04000713          	li	a4,64
    80005428:	4681                	li	a3,0
    8000542a:	e5040613          	addi	a2,s0,-432
    8000542e:	4581                	li	a1,0
    80005430:	8552                	mv	a0,s4
    80005432:	fffff097          	auipc	ra,0xfffff
    80005436:	cf6080e7          	jalr	-778(ra) # 80004128 <readi>
    8000543a:	04000793          	li	a5,64
    8000543e:	00f51a63          	bne	a0,a5,80005452 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005442:	e5042703          	lw	a4,-432(s0)
    80005446:	464c47b7          	lui	a5,0x464c4
    8000544a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000544e:	02f70c63          	beq	a4,a5,80005486 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005452:	8552                	mv	a0,s4
    80005454:	fffff097          	auipc	ra,0xfffff
    80005458:	c82080e7          	jalr	-894(ra) # 800040d6 <iunlockput>
    end_op();
    8000545c:	fffff097          	auipc	ra,0xfffff
    80005460:	45c080e7          	jalr	1116(ra) # 800048b8 <end_op>
  }
  return -1;
    80005464:	557d                	li	a0,-1
    80005466:	7a1e                	ld	s4,480(sp)
}
    80005468:	20813083          	ld	ra,520(sp)
    8000546c:	20013403          	ld	s0,512(sp)
    80005470:	74fe                	ld	s1,504(sp)
    80005472:	795e                	ld	s2,496(sp)
    80005474:	21010113          	addi	sp,sp,528
    80005478:	8082                	ret
    end_op();
    8000547a:	fffff097          	auipc	ra,0xfffff
    8000547e:	43e080e7          	jalr	1086(ra) # 800048b8 <end_op>
    return -1;
    80005482:	557d                	li	a0,-1
    80005484:	b7d5                	j	80005468 <exec+0x8a>
    80005486:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005488:	8526                	mv	a0,s1
    8000548a:	ffffd097          	auipc	ra,0xffffd
    8000548e:	976080e7          	jalr	-1674(ra) # 80001e00 <proc_pagetable>
    80005492:	8b2a                	mv	s6,a0
    80005494:	30050f63          	beqz	a0,800057b2 <exec+0x3d4>
    80005498:	f7ce                	sd	s3,488(sp)
    8000549a:	efd6                	sd	s5,472(sp)
    8000549c:	e7de                	sd	s7,456(sp)
    8000549e:	e3e2                	sd	s8,448(sp)
    800054a0:	ff66                	sd	s9,440(sp)
    800054a2:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054a4:	e7042d03          	lw	s10,-400(s0)
    800054a8:	e8845783          	lhu	a5,-376(s0)
    800054ac:	14078d63          	beqz	a5,80005606 <exec+0x228>
    800054b0:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800054b2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054b4:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800054b6:	6c85                	lui	s9,0x1
    800054b8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800054bc:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800054c0:	6a85                	lui	s5,0x1
    800054c2:	a0b5                	j	8000552e <exec+0x150>
      panic("loadseg: address should exist");
    800054c4:	00003517          	auipc	a0,0x3
    800054c8:	14450513          	addi	a0,a0,324 # 80008608 <etext+0x608>
    800054cc:	ffffb097          	auipc	ra,0xffffb
    800054d0:	094080e7          	jalr	148(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    800054d4:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800054d6:	8726                	mv	a4,s1
    800054d8:	012c06bb          	addw	a3,s8,s2
    800054dc:	4581                	li	a1,0
    800054de:	8552                	mv	a0,s4
    800054e0:	fffff097          	auipc	ra,0xfffff
    800054e4:	c48080e7          	jalr	-952(ra) # 80004128 <readi>
    800054e8:	2501                	sext.w	a0,a0
    800054ea:	28a49863          	bne	s1,a0,8000577a <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    800054ee:	012a893b          	addw	s2,s5,s2
    800054f2:	03397563          	bgeu	s2,s3,8000551c <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800054f6:	02091593          	slli	a1,s2,0x20
    800054fa:	9181                	srli	a1,a1,0x20
    800054fc:	95de                	add	a1,a1,s7
    800054fe:	855a                	mv	a0,s6
    80005500:	ffffc097          	auipc	ra,0xffffc
    80005504:	d06080e7          	jalr	-762(ra) # 80001206 <walkaddr>
    80005508:	862a                	mv	a2,a0
    if(pa == 0)
    8000550a:	dd4d                	beqz	a0,800054c4 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000550c:	412984bb          	subw	s1,s3,s2
    80005510:	0004879b          	sext.w	a5,s1
    80005514:	fcfcf0e3          	bgeu	s9,a5,800054d4 <exec+0xf6>
    80005518:	84d6                	mv	s1,s5
    8000551a:	bf6d                	j	800054d4 <exec+0xf6>
    sz = sz1;
    8000551c:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005520:	2d85                	addiw	s11,s11,1
    80005522:	038d0d1b          	addiw	s10,s10,56
    80005526:	e8845783          	lhu	a5,-376(s0)
    8000552a:	08fdd663          	bge	s11,a5,800055b6 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000552e:	2d01                	sext.w	s10,s10
    80005530:	03800713          	li	a4,56
    80005534:	86ea                	mv	a3,s10
    80005536:	e1840613          	addi	a2,s0,-488
    8000553a:	4581                	li	a1,0
    8000553c:	8552                	mv	a0,s4
    8000553e:	fffff097          	auipc	ra,0xfffff
    80005542:	bea080e7          	jalr	-1046(ra) # 80004128 <readi>
    80005546:	03800793          	li	a5,56
    8000554a:	20f51063          	bne	a0,a5,8000574a <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    8000554e:	e1842783          	lw	a5,-488(s0)
    80005552:	4705                	li	a4,1
    80005554:	fce796e3          	bne	a5,a4,80005520 <exec+0x142>
    if(ph.memsz < ph.filesz)
    80005558:	e4043483          	ld	s1,-448(s0)
    8000555c:	e3843783          	ld	a5,-456(s0)
    80005560:	1ef4e963          	bltu	s1,a5,80005752 <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005564:	e2843783          	ld	a5,-472(s0)
    80005568:	94be                	add	s1,s1,a5
    8000556a:	1ef4e863          	bltu	s1,a5,8000575a <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    8000556e:	df043703          	ld	a4,-528(s0)
    80005572:	8ff9                	and	a5,a5,a4
    80005574:	1e079763          	bnez	a5,80005762 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005578:	e1c42503          	lw	a0,-484(s0)
    8000557c:	00000097          	auipc	ra,0x0
    80005580:	e48080e7          	jalr	-440(ra) # 800053c4 <flags2perm>
    80005584:	86aa                	mv	a3,a0
    80005586:	8626                	mv	a2,s1
    80005588:	85ca                	mv	a1,s2
    8000558a:	855a                	mv	a0,s6
    8000558c:	ffffc097          	auipc	ra,0xffffc
    80005590:	03e080e7          	jalr	62(ra) # 800015ca <uvmalloc>
    80005594:	e0a43423          	sd	a0,-504(s0)
    80005598:	1c050963          	beqz	a0,8000576a <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000559c:	e2843b83          	ld	s7,-472(s0)
    800055a0:	e2042c03          	lw	s8,-480(s0)
    800055a4:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800055a8:	00098463          	beqz	s3,800055b0 <exec+0x1d2>
    800055ac:	4901                	li	s2,0
    800055ae:	b7a1                	j	800054f6 <exec+0x118>
    sz = sz1;
    800055b0:	e0843903          	ld	s2,-504(s0)
    800055b4:	b7b5                	j	80005520 <exec+0x142>
    800055b6:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800055b8:	8552                	mv	a0,s4
    800055ba:	fffff097          	auipc	ra,0xfffff
    800055be:	b1c080e7          	jalr	-1252(ra) # 800040d6 <iunlockput>
  end_op();
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	2f6080e7          	jalr	758(ra) # 800048b8 <end_op>
  p = myproc();
    800055ca:	ffffc097          	auipc	ra,0xffffc
    800055ce:	772080e7          	jalr	1906(ra) # 80001d3c <myproc>
    800055d2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800055d4:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800055d8:	6985                	lui	s3,0x1
    800055da:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800055dc:	99ca                	add	s3,s3,s2
    800055de:	77fd                	lui	a5,0xfffff
    800055e0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800055e4:	4691                	li	a3,4
    800055e6:	6609                	lui	a2,0x2
    800055e8:	964e                	add	a2,a2,s3
    800055ea:	85ce                	mv	a1,s3
    800055ec:	855a                	mv	a0,s6
    800055ee:	ffffc097          	auipc	ra,0xffffc
    800055f2:	fdc080e7          	jalr	-36(ra) # 800015ca <uvmalloc>
    800055f6:	892a                	mv	s2,a0
    800055f8:	e0a43423          	sd	a0,-504(s0)
    800055fc:	e519                	bnez	a0,8000560a <exec+0x22c>
  if(pagetable)
    800055fe:	e1343423          	sd	s3,-504(s0)
    80005602:	4a01                	li	s4,0
    80005604:	aaa5                	j	8000577c <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005606:	4901                	li	s2,0
    80005608:	bf45                	j	800055b8 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000560a:	75f9                	lui	a1,0xffffe
    8000560c:	95aa                	add	a1,a1,a0
    8000560e:	855a                	mv	a0,s6
    80005610:	ffffc097          	auipc	ra,0xffffc
    80005614:	22e080e7          	jalr	558(ra) # 8000183e <uvmclear>
  stackbase = sp - PGSIZE;
    80005618:	7bfd                	lui	s7,0xfffff
    8000561a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000561c:	e0043783          	ld	a5,-512(s0)
    80005620:	6388                	ld	a0,0(a5)
    80005622:	c52d                	beqz	a0,8000568c <exec+0x2ae>
    80005624:	e9040993          	addi	s3,s0,-368
    80005628:	f9040c13          	addi	s8,s0,-112
    8000562c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000562e:	ffffc097          	auipc	ra,0xffffc
    80005632:	9ca080e7          	jalr	-1590(ra) # 80000ff8 <strlen>
    80005636:	0015079b          	addiw	a5,a0,1
    8000563a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000563e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005642:	13796863          	bltu	s2,s7,80005772 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005646:	e0043d03          	ld	s10,-512(s0)
    8000564a:	000d3a03          	ld	s4,0(s10)
    8000564e:	8552                	mv	a0,s4
    80005650:	ffffc097          	auipc	ra,0xffffc
    80005654:	9a8080e7          	jalr	-1624(ra) # 80000ff8 <strlen>
    80005658:	0015069b          	addiw	a3,a0,1
    8000565c:	8652                	mv	a2,s4
    8000565e:	85ca                	mv	a1,s2
    80005660:	855a                	mv	a0,s6
    80005662:	ffffc097          	auipc	ra,0xffffc
    80005666:	20e080e7          	jalr	526(ra) # 80001870 <copyout>
    8000566a:	10054663          	bltz	a0,80005776 <exec+0x398>
    ustack[argc] = sp;
    8000566e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005672:	0485                	addi	s1,s1,1
    80005674:	008d0793          	addi	a5,s10,8
    80005678:	e0f43023          	sd	a5,-512(s0)
    8000567c:	008d3503          	ld	a0,8(s10)
    80005680:	c909                	beqz	a0,80005692 <exec+0x2b4>
    if(argc >= MAXARG)
    80005682:	09a1                	addi	s3,s3,8
    80005684:	fb8995e3          	bne	s3,s8,8000562e <exec+0x250>
  ip = 0;
    80005688:	4a01                	li	s4,0
    8000568a:	a8cd                	j	8000577c <exec+0x39e>
  sp = sz;
    8000568c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005690:	4481                	li	s1,0
  ustack[argc] = 0;
    80005692:	00349793          	slli	a5,s1,0x3
    80005696:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fdbcde8>
    8000569a:	97a2                	add	a5,a5,s0
    8000569c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800056a0:	00148693          	addi	a3,s1,1
    800056a4:	068e                	slli	a3,a3,0x3
    800056a6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800056aa:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800056ae:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800056b2:	f57966e3          	bltu	s2,s7,800055fe <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800056b6:	e9040613          	addi	a2,s0,-368
    800056ba:	85ca                	mv	a1,s2
    800056bc:	855a                	mv	a0,s6
    800056be:	ffffc097          	auipc	ra,0xffffc
    800056c2:	1b2080e7          	jalr	434(ra) # 80001870 <copyout>
    800056c6:	0e054863          	bltz	a0,800057b6 <exec+0x3d8>
  p->trapframe->a1 = sp;
    800056ca:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800056ce:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800056d2:	df843783          	ld	a5,-520(s0)
    800056d6:	0007c703          	lbu	a4,0(a5)
    800056da:	cf11                	beqz	a4,800056f6 <exec+0x318>
    800056dc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800056de:	02f00693          	li	a3,47
    800056e2:	a039                	j	800056f0 <exec+0x312>
      last = s+1;
    800056e4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800056e8:	0785                	addi	a5,a5,1
    800056ea:	fff7c703          	lbu	a4,-1(a5)
    800056ee:	c701                	beqz	a4,800056f6 <exec+0x318>
    if(*s == '/')
    800056f0:	fed71ce3          	bne	a4,a3,800056e8 <exec+0x30a>
    800056f4:	bfc5                	j	800056e4 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    800056f6:	4641                	li	a2,16
    800056f8:	df843583          	ld	a1,-520(s0)
    800056fc:	158a8513          	addi	a0,s5,344
    80005700:	ffffc097          	auipc	ra,0xffffc
    80005704:	8c6080e7          	jalr	-1850(ra) # 80000fc6 <safestrcpy>
  oldpagetable = p->pagetable;
    80005708:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000570c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80005710:	e0843783          	ld	a5,-504(s0)
    80005714:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005718:	058ab783          	ld	a5,88(s5)
    8000571c:	e6843703          	ld	a4,-408(s0)
    80005720:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005722:	058ab783          	ld	a5,88(s5)
    80005726:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000572a:	85e6                	mv	a1,s9
    8000572c:	ffffc097          	auipc	ra,0xffffc
    80005730:	770080e7          	jalr	1904(ra) # 80001e9c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005734:	0004851b          	sext.w	a0,s1
    80005738:	79be                	ld	s3,488(sp)
    8000573a:	7a1e                	ld	s4,480(sp)
    8000573c:	6afe                	ld	s5,472(sp)
    8000573e:	6b5e                	ld	s6,464(sp)
    80005740:	6bbe                	ld	s7,456(sp)
    80005742:	6c1e                	ld	s8,448(sp)
    80005744:	7cfa                	ld	s9,440(sp)
    80005746:	7d5a                	ld	s10,432(sp)
    80005748:	b305                	j	80005468 <exec+0x8a>
    8000574a:	e1243423          	sd	s2,-504(s0)
    8000574e:	7dba                	ld	s11,424(sp)
    80005750:	a035                	j	8000577c <exec+0x39e>
    80005752:	e1243423          	sd	s2,-504(s0)
    80005756:	7dba                	ld	s11,424(sp)
    80005758:	a015                	j	8000577c <exec+0x39e>
    8000575a:	e1243423          	sd	s2,-504(s0)
    8000575e:	7dba                	ld	s11,424(sp)
    80005760:	a831                	j	8000577c <exec+0x39e>
    80005762:	e1243423          	sd	s2,-504(s0)
    80005766:	7dba                	ld	s11,424(sp)
    80005768:	a811                	j	8000577c <exec+0x39e>
    8000576a:	e1243423          	sd	s2,-504(s0)
    8000576e:	7dba                	ld	s11,424(sp)
    80005770:	a031                	j	8000577c <exec+0x39e>
  ip = 0;
    80005772:	4a01                	li	s4,0
    80005774:	a021                	j	8000577c <exec+0x39e>
    80005776:	4a01                	li	s4,0
  if(pagetable)
    80005778:	a011                	j	8000577c <exec+0x39e>
    8000577a:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000577c:	e0843583          	ld	a1,-504(s0)
    80005780:	855a                	mv	a0,s6
    80005782:	ffffc097          	auipc	ra,0xffffc
    80005786:	71a080e7          	jalr	1818(ra) # 80001e9c <proc_freepagetable>
  return -1;
    8000578a:	557d                	li	a0,-1
  if(ip){
    8000578c:	000a1b63          	bnez	s4,800057a2 <exec+0x3c4>
    80005790:	79be                	ld	s3,488(sp)
    80005792:	7a1e                	ld	s4,480(sp)
    80005794:	6afe                	ld	s5,472(sp)
    80005796:	6b5e                	ld	s6,464(sp)
    80005798:	6bbe                	ld	s7,456(sp)
    8000579a:	6c1e                	ld	s8,448(sp)
    8000579c:	7cfa                	ld	s9,440(sp)
    8000579e:	7d5a                	ld	s10,432(sp)
    800057a0:	b1e1                	j	80005468 <exec+0x8a>
    800057a2:	79be                	ld	s3,488(sp)
    800057a4:	6afe                	ld	s5,472(sp)
    800057a6:	6b5e                	ld	s6,464(sp)
    800057a8:	6bbe                	ld	s7,456(sp)
    800057aa:	6c1e                	ld	s8,448(sp)
    800057ac:	7cfa                	ld	s9,440(sp)
    800057ae:	7d5a                	ld	s10,432(sp)
    800057b0:	b14d                	j	80005452 <exec+0x74>
    800057b2:	6b5e                	ld	s6,464(sp)
    800057b4:	b979                	j	80005452 <exec+0x74>
  sz = sz1;
    800057b6:	e0843983          	ld	s3,-504(s0)
    800057ba:	b591                	j	800055fe <exec+0x220>

00000000800057bc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800057bc:	7179                	addi	sp,sp,-48
    800057be:	f406                	sd	ra,40(sp)
    800057c0:	f022                	sd	s0,32(sp)
    800057c2:	ec26                	sd	s1,24(sp)
    800057c4:	e84a                	sd	s2,16(sp)
    800057c6:	1800                	addi	s0,sp,48
    800057c8:	892e                	mv	s2,a1
    800057ca:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800057cc:	fdc40593          	addi	a1,s0,-36
    800057d0:	ffffe097          	auipc	ra,0xffffe
    800057d4:	a7a080e7          	jalr	-1414(ra) # 8000324a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800057d8:	fdc42703          	lw	a4,-36(s0)
    800057dc:	47bd                	li	a5,15
    800057de:	02e7eb63          	bltu	a5,a4,80005814 <argfd+0x58>
    800057e2:	ffffc097          	auipc	ra,0xffffc
    800057e6:	55a080e7          	jalr	1370(ra) # 80001d3c <myproc>
    800057ea:	fdc42703          	lw	a4,-36(s0)
    800057ee:	01a70793          	addi	a5,a4,26
    800057f2:	078e                	slli	a5,a5,0x3
    800057f4:	953e                	add	a0,a0,a5
    800057f6:	611c                	ld	a5,0(a0)
    800057f8:	c385                	beqz	a5,80005818 <argfd+0x5c>
    return -1;
  if(pfd)
    800057fa:	00090463          	beqz	s2,80005802 <argfd+0x46>
    *pfd = fd;
    800057fe:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005802:	4501                	li	a0,0
  if(pf)
    80005804:	c091                	beqz	s1,80005808 <argfd+0x4c>
    *pf = f;
    80005806:	e09c                	sd	a5,0(s1)
}
    80005808:	70a2                	ld	ra,40(sp)
    8000580a:	7402                	ld	s0,32(sp)
    8000580c:	64e2                	ld	s1,24(sp)
    8000580e:	6942                	ld	s2,16(sp)
    80005810:	6145                	addi	sp,sp,48
    80005812:	8082                	ret
    return -1;
    80005814:	557d                	li	a0,-1
    80005816:	bfcd                	j	80005808 <argfd+0x4c>
    80005818:	557d                	li	a0,-1
    8000581a:	b7fd                	j	80005808 <argfd+0x4c>

000000008000581c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000581c:	1101                	addi	sp,sp,-32
    8000581e:	ec06                	sd	ra,24(sp)
    80005820:	e822                	sd	s0,16(sp)
    80005822:	e426                	sd	s1,8(sp)
    80005824:	1000                	addi	s0,sp,32
    80005826:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005828:	ffffc097          	auipc	ra,0xffffc
    8000582c:	514080e7          	jalr	1300(ra) # 80001d3c <myproc>
    80005830:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005832:	0d050793          	addi	a5,a0,208
    80005836:	4501                	li	a0,0
    80005838:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000583a:	6398                	ld	a4,0(a5)
    8000583c:	cb19                	beqz	a4,80005852 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000583e:	2505                	addiw	a0,a0,1
    80005840:	07a1                	addi	a5,a5,8
    80005842:	fed51ce3          	bne	a0,a3,8000583a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005846:	557d                	li	a0,-1
}
    80005848:	60e2                	ld	ra,24(sp)
    8000584a:	6442                	ld	s0,16(sp)
    8000584c:	64a2                	ld	s1,8(sp)
    8000584e:	6105                	addi	sp,sp,32
    80005850:	8082                	ret
      p->ofile[fd] = f;
    80005852:	01a50793          	addi	a5,a0,26
    80005856:	078e                	slli	a5,a5,0x3
    80005858:	963e                	add	a2,a2,a5
    8000585a:	e204                	sd	s1,0(a2)
      return fd;
    8000585c:	b7f5                	j	80005848 <fdalloc+0x2c>

000000008000585e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000585e:	715d                	addi	sp,sp,-80
    80005860:	e486                	sd	ra,72(sp)
    80005862:	e0a2                	sd	s0,64(sp)
    80005864:	fc26                	sd	s1,56(sp)
    80005866:	f84a                	sd	s2,48(sp)
    80005868:	f44e                	sd	s3,40(sp)
    8000586a:	ec56                	sd	s5,24(sp)
    8000586c:	e85a                	sd	s6,16(sp)
    8000586e:	0880                	addi	s0,sp,80
    80005870:	8b2e                	mv	s6,a1
    80005872:	89b2                	mv	s3,a2
    80005874:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005876:	fb040593          	addi	a1,s0,-80
    8000587a:	fffff097          	auipc	ra,0xfffff
    8000587e:	de2080e7          	jalr	-542(ra) # 8000465c <nameiparent>
    80005882:	84aa                	mv	s1,a0
    80005884:	14050e63          	beqz	a0,800059e0 <create+0x182>
    return 0;

  ilock(dp);
    80005888:	ffffe097          	auipc	ra,0xffffe
    8000588c:	5e8080e7          	jalr	1512(ra) # 80003e70 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005890:	4601                	li	a2,0
    80005892:	fb040593          	addi	a1,s0,-80
    80005896:	8526                	mv	a0,s1
    80005898:	fffff097          	auipc	ra,0xfffff
    8000589c:	ae4080e7          	jalr	-1308(ra) # 8000437c <dirlookup>
    800058a0:	8aaa                	mv	s5,a0
    800058a2:	c539                	beqz	a0,800058f0 <create+0x92>
    iunlockput(dp);
    800058a4:	8526                	mv	a0,s1
    800058a6:	fffff097          	auipc	ra,0xfffff
    800058aa:	830080e7          	jalr	-2000(ra) # 800040d6 <iunlockput>
    ilock(ip);
    800058ae:	8556                	mv	a0,s5
    800058b0:	ffffe097          	auipc	ra,0xffffe
    800058b4:	5c0080e7          	jalr	1472(ra) # 80003e70 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800058b8:	4789                	li	a5,2
    800058ba:	02fb1463          	bne	s6,a5,800058e2 <create+0x84>
    800058be:	044ad783          	lhu	a5,68(s5)
    800058c2:	37f9                	addiw	a5,a5,-2
    800058c4:	17c2                	slli	a5,a5,0x30
    800058c6:	93c1                	srli	a5,a5,0x30
    800058c8:	4705                	li	a4,1
    800058ca:	00f76c63          	bltu	a4,a5,800058e2 <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800058ce:	8556                	mv	a0,s5
    800058d0:	60a6                	ld	ra,72(sp)
    800058d2:	6406                	ld	s0,64(sp)
    800058d4:	74e2                	ld	s1,56(sp)
    800058d6:	7942                	ld	s2,48(sp)
    800058d8:	79a2                	ld	s3,40(sp)
    800058da:	6ae2                	ld	s5,24(sp)
    800058dc:	6b42                	ld	s6,16(sp)
    800058de:	6161                	addi	sp,sp,80
    800058e0:	8082                	ret
    iunlockput(ip);
    800058e2:	8556                	mv	a0,s5
    800058e4:	ffffe097          	auipc	ra,0xffffe
    800058e8:	7f2080e7          	jalr	2034(ra) # 800040d6 <iunlockput>
    return 0;
    800058ec:	4a81                	li	s5,0
    800058ee:	b7c5                	j	800058ce <create+0x70>
    800058f0:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800058f2:	85da                	mv	a1,s6
    800058f4:	4088                	lw	a0,0(s1)
    800058f6:	ffffe097          	auipc	ra,0xffffe
    800058fa:	3d6080e7          	jalr	982(ra) # 80003ccc <ialloc>
    800058fe:	8a2a                	mv	s4,a0
    80005900:	c531                	beqz	a0,8000594c <create+0xee>
  ilock(ip);
    80005902:	ffffe097          	auipc	ra,0xffffe
    80005906:	56e080e7          	jalr	1390(ra) # 80003e70 <ilock>
  ip->major = major;
    8000590a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000590e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005912:	4905                	li	s2,1
    80005914:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005918:	8552                	mv	a0,s4
    8000591a:	ffffe097          	auipc	ra,0xffffe
    8000591e:	48a080e7          	jalr	1162(ra) # 80003da4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005922:	032b0d63          	beq	s6,s2,8000595c <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005926:	004a2603          	lw	a2,4(s4)
    8000592a:	fb040593          	addi	a1,s0,-80
    8000592e:	8526                	mv	a0,s1
    80005930:	fffff097          	auipc	ra,0xfffff
    80005934:	c5c080e7          	jalr	-932(ra) # 8000458c <dirlink>
    80005938:	08054163          	bltz	a0,800059ba <create+0x15c>
  iunlockput(dp);
    8000593c:	8526                	mv	a0,s1
    8000593e:	ffffe097          	auipc	ra,0xffffe
    80005942:	798080e7          	jalr	1944(ra) # 800040d6 <iunlockput>
  return ip;
    80005946:	8ad2                	mv	s5,s4
    80005948:	7a02                	ld	s4,32(sp)
    8000594a:	b751                	j	800058ce <create+0x70>
    iunlockput(dp);
    8000594c:	8526                	mv	a0,s1
    8000594e:	ffffe097          	auipc	ra,0xffffe
    80005952:	788080e7          	jalr	1928(ra) # 800040d6 <iunlockput>
    return 0;
    80005956:	8ad2                	mv	s5,s4
    80005958:	7a02                	ld	s4,32(sp)
    8000595a:	bf95                	j	800058ce <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000595c:	004a2603          	lw	a2,4(s4)
    80005960:	00003597          	auipc	a1,0x3
    80005964:	cc858593          	addi	a1,a1,-824 # 80008628 <etext+0x628>
    80005968:	8552                	mv	a0,s4
    8000596a:	fffff097          	auipc	ra,0xfffff
    8000596e:	c22080e7          	jalr	-990(ra) # 8000458c <dirlink>
    80005972:	04054463          	bltz	a0,800059ba <create+0x15c>
    80005976:	40d0                	lw	a2,4(s1)
    80005978:	00003597          	auipc	a1,0x3
    8000597c:	cb858593          	addi	a1,a1,-840 # 80008630 <etext+0x630>
    80005980:	8552                	mv	a0,s4
    80005982:	fffff097          	auipc	ra,0xfffff
    80005986:	c0a080e7          	jalr	-1014(ra) # 8000458c <dirlink>
    8000598a:	02054863          	bltz	a0,800059ba <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000598e:	004a2603          	lw	a2,4(s4)
    80005992:	fb040593          	addi	a1,s0,-80
    80005996:	8526                	mv	a0,s1
    80005998:	fffff097          	auipc	ra,0xfffff
    8000599c:	bf4080e7          	jalr	-1036(ra) # 8000458c <dirlink>
    800059a0:	00054d63          	bltz	a0,800059ba <create+0x15c>
    dp->nlink++;  // for ".."
    800059a4:	04a4d783          	lhu	a5,74(s1)
    800059a8:	2785                	addiw	a5,a5,1
    800059aa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800059ae:	8526                	mv	a0,s1
    800059b0:	ffffe097          	auipc	ra,0xffffe
    800059b4:	3f4080e7          	jalr	1012(ra) # 80003da4 <iupdate>
    800059b8:	b751                	j	8000593c <create+0xde>
  ip->nlink = 0;
    800059ba:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800059be:	8552                	mv	a0,s4
    800059c0:	ffffe097          	auipc	ra,0xffffe
    800059c4:	3e4080e7          	jalr	996(ra) # 80003da4 <iupdate>
  iunlockput(ip);
    800059c8:	8552                	mv	a0,s4
    800059ca:	ffffe097          	auipc	ra,0xffffe
    800059ce:	70c080e7          	jalr	1804(ra) # 800040d6 <iunlockput>
  iunlockput(dp);
    800059d2:	8526                	mv	a0,s1
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	702080e7          	jalr	1794(ra) # 800040d6 <iunlockput>
  return 0;
    800059dc:	7a02                	ld	s4,32(sp)
    800059de:	bdc5                	j	800058ce <create+0x70>
    return 0;
    800059e0:	8aaa                	mv	s5,a0
    800059e2:	b5f5                	j	800058ce <create+0x70>

00000000800059e4 <sys_dup>:
{
    800059e4:	7179                	addi	sp,sp,-48
    800059e6:	f406                	sd	ra,40(sp)
    800059e8:	f022                	sd	s0,32(sp)
    800059ea:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800059ec:	fd840613          	addi	a2,s0,-40
    800059f0:	4581                	li	a1,0
    800059f2:	4501                	li	a0,0
    800059f4:	00000097          	auipc	ra,0x0
    800059f8:	dc8080e7          	jalr	-568(ra) # 800057bc <argfd>
    return -1;
    800059fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800059fe:	02054763          	bltz	a0,80005a2c <sys_dup+0x48>
    80005a02:	ec26                	sd	s1,24(sp)
    80005a04:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005a06:	fd843903          	ld	s2,-40(s0)
    80005a0a:	854a                	mv	a0,s2
    80005a0c:	00000097          	auipc	ra,0x0
    80005a10:	e10080e7          	jalr	-496(ra) # 8000581c <fdalloc>
    80005a14:	84aa                	mv	s1,a0
    return -1;
    80005a16:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005a18:	00054f63          	bltz	a0,80005a36 <sys_dup+0x52>
  filedup(f);
    80005a1c:	854a                	mv	a0,s2
    80005a1e:	fffff097          	auipc	ra,0xfffff
    80005a22:	298080e7          	jalr	664(ra) # 80004cb6 <filedup>
  return fd;
    80005a26:	87a6                	mv	a5,s1
    80005a28:	64e2                	ld	s1,24(sp)
    80005a2a:	6942                	ld	s2,16(sp)
}
    80005a2c:	853e                	mv	a0,a5
    80005a2e:	70a2                	ld	ra,40(sp)
    80005a30:	7402                	ld	s0,32(sp)
    80005a32:	6145                	addi	sp,sp,48
    80005a34:	8082                	ret
    80005a36:	64e2                	ld	s1,24(sp)
    80005a38:	6942                	ld	s2,16(sp)
    80005a3a:	bfcd                	j	80005a2c <sys_dup+0x48>

0000000080005a3c <sys_read>:
{
    80005a3c:	7179                	addi	sp,sp,-48
    80005a3e:	f406                	sd	ra,40(sp)
    80005a40:	f022                	sd	s0,32(sp)
    80005a42:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005a44:	fd840593          	addi	a1,s0,-40
    80005a48:	4505                	li	a0,1
    80005a4a:	ffffe097          	auipc	ra,0xffffe
    80005a4e:	820080e7          	jalr	-2016(ra) # 8000326a <argaddr>
  argint(2, &n);
    80005a52:	fe440593          	addi	a1,s0,-28
    80005a56:	4509                	li	a0,2
    80005a58:	ffffd097          	auipc	ra,0xffffd
    80005a5c:	7f2080e7          	jalr	2034(ra) # 8000324a <argint>
  if(argfd(0, 0, &f) < 0)
    80005a60:	fe840613          	addi	a2,s0,-24
    80005a64:	4581                	li	a1,0
    80005a66:	4501                	li	a0,0
    80005a68:	00000097          	auipc	ra,0x0
    80005a6c:	d54080e7          	jalr	-684(ra) # 800057bc <argfd>
    80005a70:	87aa                	mv	a5,a0
    return -1;
    80005a72:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005a74:	0007cc63          	bltz	a5,80005a8c <sys_read+0x50>
  return fileread(f, p, n);
    80005a78:	fe442603          	lw	a2,-28(s0)
    80005a7c:	fd843583          	ld	a1,-40(s0)
    80005a80:	fe843503          	ld	a0,-24(s0)
    80005a84:	fffff097          	auipc	ra,0xfffff
    80005a88:	3d8080e7          	jalr	984(ra) # 80004e5c <fileread>
}
    80005a8c:	70a2                	ld	ra,40(sp)
    80005a8e:	7402                	ld	s0,32(sp)
    80005a90:	6145                	addi	sp,sp,48
    80005a92:	8082                	ret

0000000080005a94 <sys_write>:
{
    80005a94:	7179                	addi	sp,sp,-48
    80005a96:	f406                	sd	ra,40(sp)
    80005a98:	f022                	sd	s0,32(sp)
    80005a9a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005a9c:	fd840593          	addi	a1,s0,-40
    80005aa0:	4505                	li	a0,1
    80005aa2:	ffffd097          	auipc	ra,0xffffd
    80005aa6:	7c8080e7          	jalr	1992(ra) # 8000326a <argaddr>
  argint(2, &n);
    80005aaa:	fe440593          	addi	a1,s0,-28
    80005aae:	4509                	li	a0,2
    80005ab0:	ffffd097          	auipc	ra,0xffffd
    80005ab4:	79a080e7          	jalr	1946(ra) # 8000324a <argint>
  if(argfd(0, 0, &f) < 0)
    80005ab8:	fe840613          	addi	a2,s0,-24
    80005abc:	4581                	li	a1,0
    80005abe:	4501                	li	a0,0
    80005ac0:	00000097          	auipc	ra,0x0
    80005ac4:	cfc080e7          	jalr	-772(ra) # 800057bc <argfd>
    80005ac8:	87aa                	mv	a5,a0
    return -1;
    80005aca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005acc:	0007cc63          	bltz	a5,80005ae4 <sys_write+0x50>
  return filewrite(f, p, n);
    80005ad0:	fe442603          	lw	a2,-28(s0)
    80005ad4:	fd843583          	ld	a1,-40(s0)
    80005ad8:	fe843503          	ld	a0,-24(s0)
    80005adc:	fffff097          	auipc	ra,0xfffff
    80005ae0:	452080e7          	jalr	1106(ra) # 80004f2e <filewrite>
}
    80005ae4:	70a2                	ld	ra,40(sp)
    80005ae6:	7402                	ld	s0,32(sp)
    80005ae8:	6145                	addi	sp,sp,48
    80005aea:	8082                	ret

0000000080005aec <sys_close>:
{
    80005aec:	1101                	addi	sp,sp,-32
    80005aee:	ec06                	sd	ra,24(sp)
    80005af0:	e822                	sd	s0,16(sp)
    80005af2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005af4:	fe040613          	addi	a2,s0,-32
    80005af8:	fec40593          	addi	a1,s0,-20
    80005afc:	4501                	li	a0,0
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	cbe080e7          	jalr	-834(ra) # 800057bc <argfd>
    return -1;
    80005b06:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005b08:	02054463          	bltz	a0,80005b30 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005b0c:	ffffc097          	auipc	ra,0xffffc
    80005b10:	230080e7          	jalr	560(ra) # 80001d3c <myproc>
    80005b14:	fec42783          	lw	a5,-20(s0)
    80005b18:	07e9                	addi	a5,a5,26
    80005b1a:	078e                	slli	a5,a5,0x3
    80005b1c:	953e                	add	a0,a0,a5
    80005b1e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005b22:	fe043503          	ld	a0,-32(s0)
    80005b26:	fffff097          	auipc	ra,0xfffff
    80005b2a:	1e2080e7          	jalr	482(ra) # 80004d08 <fileclose>
  return 0;
    80005b2e:	4781                	li	a5,0
}
    80005b30:	853e                	mv	a0,a5
    80005b32:	60e2                	ld	ra,24(sp)
    80005b34:	6442                	ld	s0,16(sp)
    80005b36:	6105                	addi	sp,sp,32
    80005b38:	8082                	ret

0000000080005b3a <sys_fstat>:
{
    80005b3a:	1101                	addi	sp,sp,-32
    80005b3c:	ec06                	sd	ra,24(sp)
    80005b3e:	e822                	sd	s0,16(sp)
    80005b40:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005b42:	fe040593          	addi	a1,s0,-32
    80005b46:	4505                	li	a0,1
    80005b48:	ffffd097          	auipc	ra,0xffffd
    80005b4c:	722080e7          	jalr	1826(ra) # 8000326a <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005b50:	fe840613          	addi	a2,s0,-24
    80005b54:	4581                	li	a1,0
    80005b56:	4501                	li	a0,0
    80005b58:	00000097          	auipc	ra,0x0
    80005b5c:	c64080e7          	jalr	-924(ra) # 800057bc <argfd>
    80005b60:	87aa                	mv	a5,a0
    return -1;
    80005b62:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b64:	0007ca63          	bltz	a5,80005b78 <sys_fstat+0x3e>
  return filestat(f, st);
    80005b68:	fe043583          	ld	a1,-32(s0)
    80005b6c:	fe843503          	ld	a0,-24(s0)
    80005b70:	fffff097          	auipc	ra,0xfffff
    80005b74:	27a080e7          	jalr	634(ra) # 80004dea <filestat>
}
    80005b78:	60e2                	ld	ra,24(sp)
    80005b7a:	6442                	ld	s0,16(sp)
    80005b7c:	6105                	addi	sp,sp,32
    80005b7e:	8082                	ret

0000000080005b80 <sys_link>:
{
    80005b80:	7169                	addi	sp,sp,-304
    80005b82:	f606                	sd	ra,296(sp)
    80005b84:	f222                	sd	s0,288(sp)
    80005b86:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b88:	08000613          	li	a2,128
    80005b8c:	ed040593          	addi	a1,s0,-304
    80005b90:	4501                	li	a0,0
    80005b92:	ffffd097          	auipc	ra,0xffffd
    80005b96:	6f8080e7          	jalr	1784(ra) # 8000328a <argstr>
    return -1;
    80005b9a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005b9c:	12054663          	bltz	a0,80005cc8 <sys_link+0x148>
    80005ba0:	08000613          	li	a2,128
    80005ba4:	f5040593          	addi	a1,s0,-176
    80005ba8:	4505                	li	a0,1
    80005baa:	ffffd097          	auipc	ra,0xffffd
    80005bae:	6e0080e7          	jalr	1760(ra) # 8000328a <argstr>
    return -1;
    80005bb2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005bb4:	10054a63          	bltz	a0,80005cc8 <sys_link+0x148>
    80005bb8:	ee26                	sd	s1,280(sp)
  begin_op();
    80005bba:	fffff097          	auipc	ra,0xfffff
    80005bbe:	c84080e7          	jalr	-892(ra) # 8000483e <begin_op>
  if((ip = namei(old)) == 0){
    80005bc2:	ed040513          	addi	a0,s0,-304
    80005bc6:	fffff097          	auipc	ra,0xfffff
    80005bca:	a78080e7          	jalr	-1416(ra) # 8000463e <namei>
    80005bce:	84aa                	mv	s1,a0
    80005bd0:	c949                	beqz	a0,80005c62 <sys_link+0xe2>
  ilock(ip);
    80005bd2:	ffffe097          	auipc	ra,0xffffe
    80005bd6:	29e080e7          	jalr	670(ra) # 80003e70 <ilock>
  if(ip->type == T_DIR){
    80005bda:	04449703          	lh	a4,68(s1)
    80005bde:	4785                	li	a5,1
    80005be0:	08f70863          	beq	a4,a5,80005c70 <sys_link+0xf0>
    80005be4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005be6:	04a4d783          	lhu	a5,74(s1)
    80005bea:	2785                	addiw	a5,a5,1
    80005bec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005bf0:	8526                	mv	a0,s1
    80005bf2:	ffffe097          	auipc	ra,0xffffe
    80005bf6:	1b2080e7          	jalr	434(ra) # 80003da4 <iupdate>
  iunlock(ip);
    80005bfa:	8526                	mv	a0,s1
    80005bfc:	ffffe097          	auipc	ra,0xffffe
    80005c00:	33a080e7          	jalr	826(ra) # 80003f36 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005c04:	fd040593          	addi	a1,s0,-48
    80005c08:	f5040513          	addi	a0,s0,-176
    80005c0c:	fffff097          	auipc	ra,0xfffff
    80005c10:	a50080e7          	jalr	-1456(ra) # 8000465c <nameiparent>
    80005c14:	892a                	mv	s2,a0
    80005c16:	cd35                	beqz	a0,80005c92 <sys_link+0x112>
  ilock(dp);
    80005c18:	ffffe097          	auipc	ra,0xffffe
    80005c1c:	258080e7          	jalr	600(ra) # 80003e70 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005c20:	00092703          	lw	a4,0(s2)
    80005c24:	409c                	lw	a5,0(s1)
    80005c26:	06f71163          	bne	a4,a5,80005c88 <sys_link+0x108>
    80005c2a:	40d0                	lw	a2,4(s1)
    80005c2c:	fd040593          	addi	a1,s0,-48
    80005c30:	854a                	mv	a0,s2
    80005c32:	fffff097          	auipc	ra,0xfffff
    80005c36:	95a080e7          	jalr	-1702(ra) # 8000458c <dirlink>
    80005c3a:	04054763          	bltz	a0,80005c88 <sys_link+0x108>
  iunlockput(dp);
    80005c3e:	854a                	mv	a0,s2
    80005c40:	ffffe097          	auipc	ra,0xffffe
    80005c44:	496080e7          	jalr	1174(ra) # 800040d6 <iunlockput>
  iput(ip);
    80005c48:	8526                	mv	a0,s1
    80005c4a:	ffffe097          	auipc	ra,0xffffe
    80005c4e:	3e4080e7          	jalr	996(ra) # 8000402e <iput>
  end_op();
    80005c52:	fffff097          	auipc	ra,0xfffff
    80005c56:	c66080e7          	jalr	-922(ra) # 800048b8 <end_op>
  return 0;
    80005c5a:	4781                	li	a5,0
    80005c5c:	64f2                	ld	s1,280(sp)
    80005c5e:	6952                	ld	s2,272(sp)
    80005c60:	a0a5                	j	80005cc8 <sys_link+0x148>
    end_op();
    80005c62:	fffff097          	auipc	ra,0xfffff
    80005c66:	c56080e7          	jalr	-938(ra) # 800048b8 <end_op>
    return -1;
    80005c6a:	57fd                	li	a5,-1
    80005c6c:	64f2                	ld	s1,280(sp)
    80005c6e:	a8a9                	j	80005cc8 <sys_link+0x148>
    iunlockput(ip);
    80005c70:	8526                	mv	a0,s1
    80005c72:	ffffe097          	auipc	ra,0xffffe
    80005c76:	464080e7          	jalr	1124(ra) # 800040d6 <iunlockput>
    end_op();
    80005c7a:	fffff097          	auipc	ra,0xfffff
    80005c7e:	c3e080e7          	jalr	-962(ra) # 800048b8 <end_op>
    return -1;
    80005c82:	57fd                	li	a5,-1
    80005c84:	64f2                	ld	s1,280(sp)
    80005c86:	a089                	j	80005cc8 <sys_link+0x148>
    iunlockput(dp);
    80005c88:	854a                	mv	a0,s2
    80005c8a:	ffffe097          	auipc	ra,0xffffe
    80005c8e:	44c080e7          	jalr	1100(ra) # 800040d6 <iunlockput>
  ilock(ip);
    80005c92:	8526                	mv	a0,s1
    80005c94:	ffffe097          	auipc	ra,0xffffe
    80005c98:	1dc080e7          	jalr	476(ra) # 80003e70 <ilock>
  ip->nlink--;
    80005c9c:	04a4d783          	lhu	a5,74(s1)
    80005ca0:	37fd                	addiw	a5,a5,-1
    80005ca2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005ca6:	8526                	mv	a0,s1
    80005ca8:	ffffe097          	auipc	ra,0xffffe
    80005cac:	0fc080e7          	jalr	252(ra) # 80003da4 <iupdate>
  iunlockput(ip);
    80005cb0:	8526                	mv	a0,s1
    80005cb2:	ffffe097          	auipc	ra,0xffffe
    80005cb6:	424080e7          	jalr	1060(ra) # 800040d6 <iunlockput>
  end_op();
    80005cba:	fffff097          	auipc	ra,0xfffff
    80005cbe:	bfe080e7          	jalr	-1026(ra) # 800048b8 <end_op>
  return -1;
    80005cc2:	57fd                	li	a5,-1
    80005cc4:	64f2                	ld	s1,280(sp)
    80005cc6:	6952                	ld	s2,272(sp)
}
    80005cc8:	853e                	mv	a0,a5
    80005cca:	70b2                	ld	ra,296(sp)
    80005ccc:	7412                	ld	s0,288(sp)
    80005cce:	6155                	addi	sp,sp,304
    80005cd0:	8082                	ret

0000000080005cd2 <sys_unlink>:
{
    80005cd2:	7151                	addi	sp,sp,-240
    80005cd4:	f586                	sd	ra,232(sp)
    80005cd6:	f1a2                	sd	s0,224(sp)
    80005cd8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005cda:	08000613          	li	a2,128
    80005cde:	f3040593          	addi	a1,s0,-208
    80005ce2:	4501                	li	a0,0
    80005ce4:	ffffd097          	auipc	ra,0xffffd
    80005ce8:	5a6080e7          	jalr	1446(ra) # 8000328a <argstr>
    80005cec:	1a054a63          	bltz	a0,80005ea0 <sys_unlink+0x1ce>
    80005cf0:	eda6                	sd	s1,216(sp)
  begin_op();
    80005cf2:	fffff097          	auipc	ra,0xfffff
    80005cf6:	b4c080e7          	jalr	-1204(ra) # 8000483e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005cfa:	fb040593          	addi	a1,s0,-80
    80005cfe:	f3040513          	addi	a0,s0,-208
    80005d02:	fffff097          	auipc	ra,0xfffff
    80005d06:	95a080e7          	jalr	-1702(ra) # 8000465c <nameiparent>
    80005d0a:	84aa                	mv	s1,a0
    80005d0c:	cd71                	beqz	a0,80005de8 <sys_unlink+0x116>
  ilock(dp);
    80005d0e:	ffffe097          	auipc	ra,0xffffe
    80005d12:	162080e7          	jalr	354(ra) # 80003e70 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005d16:	00003597          	auipc	a1,0x3
    80005d1a:	91258593          	addi	a1,a1,-1774 # 80008628 <etext+0x628>
    80005d1e:	fb040513          	addi	a0,s0,-80
    80005d22:	ffffe097          	auipc	ra,0xffffe
    80005d26:	640080e7          	jalr	1600(ra) # 80004362 <namecmp>
    80005d2a:	14050c63          	beqz	a0,80005e82 <sys_unlink+0x1b0>
    80005d2e:	00003597          	auipc	a1,0x3
    80005d32:	90258593          	addi	a1,a1,-1790 # 80008630 <etext+0x630>
    80005d36:	fb040513          	addi	a0,s0,-80
    80005d3a:	ffffe097          	auipc	ra,0xffffe
    80005d3e:	628080e7          	jalr	1576(ra) # 80004362 <namecmp>
    80005d42:	14050063          	beqz	a0,80005e82 <sys_unlink+0x1b0>
    80005d46:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005d48:	f2c40613          	addi	a2,s0,-212
    80005d4c:	fb040593          	addi	a1,s0,-80
    80005d50:	8526                	mv	a0,s1
    80005d52:	ffffe097          	auipc	ra,0xffffe
    80005d56:	62a080e7          	jalr	1578(ra) # 8000437c <dirlookup>
    80005d5a:	892a                	mv	s2,a0
    80005d5c:	12050263          	beqz	a0,80005e80 <sys_unlink+0x1ae>
  ilock(ip);
    80005d60:	ffffe097          	auipc	ra,0xffffe
    80005d64:	110080e7          	jalr	272(ra) # 80003e70 <ilock>
  if(ip->nlink < 1)
    80005d68:	04a91783          	lh	a5,74(s2)
    80005d6c:	08f05563          	blez	a5,80005df6 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005d70:	04491703          	lh	a4,68(s2)
    80005d74:	4785                	li	a5,1
    80005d76:	08f70963          	beq	a4,a5,80005e08 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005d7a:	4641                	li	a2,16
    80005d7c:	4581                	li	a1,0
    80005d7e:	fc040513          	addi	a0,s0,-64
    80005d82:	ffffb097          	auipc	ra,0xffffb
    80005d86:	102080e7          	jalr	258(ra) # 80000e84 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005d8a:	4741                	li	a4,16
    80005d8c:	f2c42683          	lw	a3,-212(s0)
    80005d90:	fc040613          	addi	a2,s0,-64
    80005d94:	4581                	li	a1,0
    80005d96:	8526                	mv	a0,s1
    80005d98:	ffffe097          	auipc	ra,0xffffe
    80005d9c:	4a0080e7          	jalr	1184(ra) # 80004238 <writei>
    80005da0:	47c1                	li	a5,16
    80005da2:	0af51b63          	bne	a0,a5,80005e58 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005da6:	04491703          	lh	a4,68(s2)
    80005daa:	4785                	li	a5,1
    80005dac:	0af70f63          	beq	a4,a5,80005e6a <sys_unlink+0x198>
  iunlockput(dp);
    80005db0:	8526                	mv	a0,s1
    80005db2:	ffffe097          	auipc	ra,0xffffe
    80005db6:	324080e7          	jalr	804(ra) # 800040d6 <iunlockput>
  ip->nlink--;
    80005dba:	04a95783          	lhu	a5,74(s2)
    80005dbe:	37fd                	addiw	a5,a5,-1
    80005dc0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005dc4:	854a                	mv	a0,s2
    80005dc6:	ffffe097          	auipc	ra,0xffffe
    80005dca:	fde080e7          	jalr	-34(ra) # 80003da4 <iupdate>
  iunlockput(ip);
    80005dce:	854a                	mv	a0,s2
    80005dd0:	ffffe097          	auipc	ra,0xffffe
    80005dd4:	306080e7          	jalr	774(ra) # 800040d6 <iunlockput>
  end_op();
    80005dd8:	fffff097          	auipc	ra,0xfffff
    80005ddc:	ae0080e7          	jalr	-1312(ra) # 800048b8 <end_op>
  return 0;
    80005de0:	4501                	li	a0,0
    80005de2:	64ee                	ld	s1,216(sp)
    80005de4:	694e                	ld	s2,208(sp)
    80005de6:	a84d                	j	80005e98 <sys_unlink+0x1c6>
    end_op();
    80005de8:	fffff097          	auipc	ra,0xfffff
    80005dec:	ad0080e7          	jalr	-1328(ra) # 800048b8 <end_op>
    return -1;
    80005df0:	557d                	li	a0,-1
    80005df2:	64ee                	ld	s1,216(sp)
    80005df4:	a055                	j	80005e98 <sys_unlink+0x1c6>
    80005df6:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005df8:	00003517          	auipc	a0,0x3
    80005dfc:	84050513          	addi	a0,a0,-1984 # 80008638 <etext+0x638>
    80005e00:	ffffa097          	auipc	ra,0xffffa
    80005e04:	760080e7          	jalr	1888(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e08:	04c92703          	lw	a4,76(s2)
    80005e0c:	02000793          	li	a5,32
    80005e10:	f6e7f5e3          	bgeu	a5,a4,80005d7a <sys_unlink+0xa8>
    80005e14:	e5ce                	sd	s3,200(sp)
    80005e16:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e1a:	4741                	li	a4,16
    80005e1c:	86ce                	mv	a3,s3
    80005e1e:	f1840613          	addi	a2,s0,-232
    80005e22:	4581                	li	a1,0
    80005e24:	854a                	mv	a0,s2
    80005e26:	ffffe097          	auipc	ra,0xffffe
    80005e2a:	302080e7          	jalr	770(ra) # 80004128 <readi>
    80005e2e:	47c1                	li	a5,16
    80005e30:	00f51c63          	bne	a0,a5,80005e48 <sys_unlink+0x176>
    if(de.inum != 0)
    80005e34:	f1845783          	lhu	a5,-232(s0)
    80005e38:	e7b5                	bnez	a5,80005ea4 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e3a:	29c1                	addiw	s3,s3,16
    80005e3c:	04c92783          	lw	a5,76(s2)
    80005e40:	fcf9ede3          	bltu	s3,a5,80005e1a <sys_unlink+0x148>
    80005e44:	69ae                	ld	s3,200(sp)
    80005e46:	bf15                	j	80005d7a <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80005e48:	00003517          	auipc	a0,0x3
    80005e4c:	80850513          	addi	a0,a0,-2040 # 80008650 <etext+0x650>
    80005e50:	ffffa097          	auipc	ra,0xffffa
    80005e54:	710080e7          	jalr	1808(ra) # 80000560 <panic>
    80005e58:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005e5a:	00003517          	auipc	a0,0x3
    80005e5e:	80e50513          	addi	a0,a0,-2034 # 80008668 <etext+0x668>
    80005e62:	ffffa097          	auipc	ra,0xffffa
    80005e66:	6fe080e7          	jalr	1790(ra) # 80000560 <panic>
    dp->nlink--;
    80005e6a:	04a4d783          	lhu	a5,74(s1)
    80005e6e:	37fd                	addiw	a5,a5,-1
    80005e70:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005e74:	8526                	mv	a0,s1
    80005e76:	ffffe097          	auipc	ra,0xffffe
    80005e7a:	f2e080e7          	jalr	-210(ra) # 80003da4 <iupdate>
    80005e7e:	bf0d                	j	80005db0 <sys_unlink+0xde>
    80005e80:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005e82:	8526                	mv	a0,s1
    80005e84:	ffffe097          	auipc	ra,0xffffe
    80005e88:	252080e7          	jalr	594(ra) # 800040d6 <iunlockput>
  end_op();
    80005e8c:	fffff097          	auipc	ra,0xfffff
    80005e90:	a2c080e7          	jalr	-1492(ra) # 800048b8 <end_op>
  return -1;
    80005e94:	557d                	li	a0,-1
    80005e96:	64ee                	ld	s1,216(sp)
}
    80005e98:	70ae                	ld	ra,232(sp)
    80005e9a:	740e                	ld	s0,224(sp)
    80005e9c:	616d                	addi	sp,sp,240
    80005e9e:	8082                	ret
    return -1;
    80005ea0:	557d                	li	a0,-1
    80005ea2:	bfdd                	j	80005e98 <sys_unlink+0x1c6>
    iunlockput(ip);
    80005ea4:	854a                	mv	a0,s2
    80005ea6:	ffffe097          	auipc	ra,0xffffe
    80005eaa:	230080e7          	jalr	560(ra) # 800040d6 <iunlockput>
    goto bad;
    80005eae:	694e                	ld	s2,208(sp)
    80005eb0:	69ae                	ld	s3,200(sp)
    80005eb2:	bfc1                	j	80005e82 <sys_unlink+0x1b0>

0000000080005eb4 <sys_open>:

uint64
sys_open(void)
{
    80005eb4:	7131                	addi	sp,sp,-192
    80005eb6:	fd06                	sd	ra,184(sp)
    80005eb8:	f922                	sd	s0,176(sp)
    80005eba:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005ebc:	f4c40593          	addi	a1,s0,-180
    80005ec0:	4505                	li	a0,1
    80005ec2:	ffffd097          	auipc	ra,0xffffd
    80005ec6:	388080e7          	jalr	904(ra) # 8000324a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005eca:	08000613          	li	a2,128
    80005ece:	f5040593          	addi	a1,s0,-176
    80005ed2:	4501                	li	a0,0
    80005ed4:	ffffd097          	auipc	ra,0xffffd
    80005ed8:	3b6080e7          	jalr	950(ra) # 8000328a <argstr>
    80005edc:	87aa                	mv	a5,a0
    return -1;
    80005ede:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005ee0:	0a07ce63          	bltz	a5,80005f9c <sys_open+0xe8>
    80005ee4:	f526                	sd	s1,168(sp)

  begin_op();
    80005ee6:	fffff097          	auipc	ra,0xfffff
    80005eea:	958080e7          	jalr	-1704(ra) # 8000483e <begin_op>

  if(omode & O_CREATE){
    80005eee:	f4c42783          	lw	a5,-180(s0)
    80005ef2:	2007f793          	andi	a5,a5,512
    80005ef6:	cfd5                	beqz	a5,80005fb2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005ef8:	4681                	li	a3,0
    80005efa:	4601                	li	a2,0
    80005efc:	4589                	li	a1,2
    80005efe:	f5040513          	addi	a0,s0,-176
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	95c080e7          	jalr	-1700(ra) # 8000585e <create>
    80005f0a:	84aa                	mv	s1,a0
    if(ip == 0){
    80005f0c:	cd41                	beqz	a0,80005fa4 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005f0e:	04449703          	lh	a4,68(s1)
    80005f12:	478d                	li	a5,3
    80005f14:	00f71763          	bne	a4,a5,80005f22 <sys_open+0x6e>
    80005f18:	0464d703          	lhu	a4,70(s1)
    80005f1c:	47a5                	li	a5,9
    80005f1e:	0ee7e163          	bltu	a5,a4,80006000 <sys_open+0x14c>
    80005f22:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005f24:	fffff097          	auipc	ra,0xfffff
    80005f28:	d28080e7          	jalr	-728(ra) # 80004c4c <filealloc>
    80005f2c:	892a                	mv	s2,a0
    80005f2e:	c97d                	beqz	a0,80006024 <sys_open+0x170>
    80005f30:	ed4e                	sd	s3,152(sp)
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	8ea080e7          	jalr	-1814(ra) # 8000581c <fdalloc>
    80005f3a:	89aa                	mv	s3,a0
    80005f3c:	0c054e63          	bltz	a0,80006018 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005f40:	04449703          	lh	a4,68(s1)
    80005f44:	478d                	li	a5,3
    80005f46:	0ef70c63          	beq	a4,a5,8000603e <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005f4a:	4789                	li	a5,2
    80005f4c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005f50:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005f54:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005f58:	f4c42783          	lw	a5,-180(s0)
    80005f5c:	0017c713          	xori	a4,a5,1
    80005f60:	8b05                	andi	a4,a4,1
    80005f62:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005f66:	0037f713          	andi	a4,a5,3
    80005f6a:	00e03733          	snez	a4,a4
    80005f6e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005f72:	4007f793          	andi	a5,a5,1024
    80005f76:	c791                	beqz	a5,80005f82 <sys_open+0xce>
    80005f78:	04449703          	lh	a4,68(s1)
    80005f7c:	4789                	li	a5,2
    80005f7e:	0cf70763          	beq	a4,a5,8000604c <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80005f82:	8526                	mv	a0,s1
    80005f84:	ffffe097          	auipc	ra,0xffffe
    80005f88:	fb2080e7          	jalr	-78(ra) # 80003f36 <iunlock>
  end_op();
    80005f8c:	fffff097          	auipc	ra,0xfffff
    80005f90:	92c080e7          	jalr	-1748(ra) # 800048b8 <end_op>

  return fd;
    80005f94:	854e                	mv	a0,s3
    80005f96:	74aa                	ld	s1,168(sp)
    80005f98:	790a                	ld	s2,160(sp)
    80005f9a:	69ea                	ld	s3,152(sp)
}
    80005f9c:	70ea                	ld	ra,184(sp)
    80005f9e:	744a                	ld	s0,176(sp)
    80005fa0:	6129                	addi	sp,sp,192
    80005fa2:	8082                	ret
      end_op();
    80005fa4:	fffff097          	auipc	ra,0xfffff
    80005fa8:	914080e7          	jalr	-1772(ra) # 800048b8 <end_op>
      return -1;
    80005fac:	557d                	li	a0,-1
    80005fae:	74aa                	ld	s1,168(sp)
    80005fb0:	b7f5                	j	80005f9c <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80005fb2:	f5040513          	addi	a0,s0,-176
    80005fb6:	ffffe097          	auipc	ra,0xffffe
    80005fba:	688080e7          	jalr	1672(ra) # 8000463e <namei>
    80005fbe:	84aa                	mv	s1,a0
    80005fc0:	c90d                	beqz	a0,80005ff2 <sys_open+0x13e>
    ilock(ip);
    80005fc2:	ffffe097          	auipc	ra,0xffffe
    80005fc6:	eae080e7          	jalr	-338(ra) # 80003e70 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005fca:	04449703          	lh	a4,68(s1)
    80005fce:	4785                	li	a5,1
    80005fd0:	f2f71fe3          	bne	a4,a5,80005f0e <sys_open+0x5a>
    80005fd4:	f4c42783          	lw	a5,-180(s0)
    80005fd8:	d7a9                	beqz	a5,80005f22 <sys_open+0x6e>
      iunlockput(ip);
    80005fda:	8526                	mv	a0,s1
    80005fdc:	ffffe097          	auipc	ra,0xffffe
    80005fe0:	0fa080e7          	jalr	250(ra) # 800040d6 <iunlockput>
      end_op();
    80005fe4:	fffff097          	auipc	ra,0xfffff
    80005fe8:	8d4080e7          	jalr	-1836(ra) # 800048b8 <end_op>
      return -1;
    80005fec:	557d                	li	a0,-1
    80005fee:	74aa                	ld	s1,168(sp)
    80005ff0:	b775                	j	80005f9c <sys_open+0xe8>
      end_op();
    80005ff2:	fffff097          	auipc	ra,0xfffff
    80005ff6:	8c6080e7          	jalr	-1850(ra) # 800048b8 <end_op>
      return -1;
    80005ffa:	557d                	li	a0,-1
    80005ffc:	74aa                	ld	s1,168(sp)
    80005ffe:	bf79                	j	80005f9c <sys_open+0xe8>
    iunlockput(ip);
    80006000:	8526                	mv	a0,s1
    80006002:	ffffe097          	auipc	ra,0xffffe
    80006006:	0d4080e7          	jalr	212(ra) # 800040d6 <iunlockput>
    end_op();
    8000600a:	fffff097          	auipc	ra,0xfffff
    8000600e:	8ae080e7          	jalr	-1874(ra) # 800048b8 <end_op>
    return -1;
    80006012:	557d                	li	a0,-1
    80006014:	74aa                	ld	s1,168(sp)
    80006016:	b759                	j	80005f9c <sys_open+0xe8>
      fileclose(f);
    80006018:	854a                	mv	a0,s2
    8000601a:	fffff097          	auipc	ra,0xfffff
    8000601e:	cee080e7          	jalr	-786(ra) # 80004d08 <fileclose>
    80006022:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80006024:	8526                	mv	a0,s1
    80006026:	ffffe097          	auipc	ra,0xffffe
    8000602a:	0b0080e7          	jalr	176(ra) # 800040d6 <iunlockput>
    end_op();
    8000602e:	fffff097          	auipc	ra,0xfffff
    80006032:	88a080e7          	jalr	-1910(ra) # 800048b8 <end_op>
    return -1;
    80006036:	557d                	li	a0,-1
    80006038:	74aa                	ld	s1,168(sp)
    8000603a:	790a                	ld	s2,160(sp)
    8000603c:	b785                	j	80005f9c <sys_open+0xe8>
    f->type = FD_DEVICE;
    8000603e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80006042:	04649783          	lh	a5,70(s1)
    80006046:	02f91223          	sh	a5,36(s2)
    8000604a:	b729                	j	80005f54 <sys_open+0xa0>
    itrunc(ip);
    8000604c:	8526                	mv	a0,s1
    8000604e:	ffffe097          	auipc	ra,0xffffe
    80006052:	f34080e7          	jalr	-204(ra) # 80003f82 <itrunc>
    80006056:	b735                	j	80005f82 <sys_open+0xce>

0000000080006058 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006058:	7175                	addi	sp,sp,-144
    8000605a:	e506                	sd	ra,136(sp)
    8000605c:	e122                	sd	s0,128(sp)
    8000605e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006060:	ffffe097          	auipc	ra,0xffffe
    80006064:	7de080e7          	jalr	2014(ra) # 8000483e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006068:	08000613          	li	a2,128
    8000606c:	f7040593          	addi	a1,s0,-144
    80006070:	4501                	li	a0,0
    80006072:	ffffd097          	auipc	ra,0xffffd
    80006076:	218080e7          	jalr	536(ra) # 8000328a <argstr>
    8000607a:	02054963          	bltz	a0,800060ac <sys_mkdir+0x54>
    8000607e:	4681                	li	a3,0
    80006080:	4601                	li	a2,0
    80006082:	4585                	li	a1,1
    80006084:	f7040513          	addi	a0,s0,-144
    80006088:	fffff097          	auipc	ra,0xfffff
    8000608c:	7d6080e7          	jalr	2006(ra) # 8000585e <create>
    80006090:	cd11                	beqz	a0,800060ac <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006092:	ffffe097          	auipc	ra,0xffffe
    80006096:	044080e7          	jalr	68(ra) # 800040d6 <iunlockput>
  end_op();
    8000609a:	fffff097          	auipc	ra,0xfffff
    8000609e:	81e080e7          	jalr	-2018(ra) # 800048b8 <end_op>
  return 0;
    800060a2:	4501                	li	a0,0
}
    800060a4:	60aa                	ld	ra,136(sp)
    800060a6:	640a                	ld	s0,128(sp)
    800060a8:	6149                	addi	sp,sp,144
    800060aa:	8082                	ret
    end_op();
    800060ac:	fffff097          	auipc	ra,0xfffff
    800060b0:	80c080e7          	jalr	-2036(ra) # 800048b8 <end_op>
    return -1;
    800060b4:	557d                	li	a0,-1
    800060b6:	b7fd                	j	800060a4 <sys_mkdir+0x4c>

00000000800060b8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800060b8:	7135                	addi	sp,sp,-160
    800060ba:	ed06                	sd	ra,152(sp)
    800060bc:	e922                	sd	s0,144(sp)
    800060be:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800060c0:	ffffe097          	auipc	ra,0xffffe
    800060c4:	77e080e7          	jalr	1918(ra) # 8000483e <begin_op>
  argint(1, &major);
    800060c8:	f6c40593          	addi	a1,s0,-148
    800060cc:	4505                	li	a0,1
    800060ce:	ffffd097          	auipc	ra,0xffffd
    800060d2:	17c080e7          	jalr	380(ra) # 8000324a <argint>
  argint(2, &minor);
    800060d6:	f6840593          	addi	a1,s0,-152
    800060da:	4509                	li	a0,2
    800060dc:	ffffd097          	auipc	ra,0xffffd
    800060e0:	16e080e7          	jalr	366(ra) # 8000324a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800060e4:	08000613          	li	a2,128
    800060e8:	f7040593          	addi	a1,s0,-144
    800060ec:	4501                	li	a0,0
    800060ee:	ffffd097          	auipc	ra,0xffffd
    800060f2:	19c080e7          	jalr	412(ra) # 8000328a <argstr>
    800060f6:	02054b63          	bltz	a0,8000612c <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800060fa:	f6841683          	lh	a3,-152(s0)
    800060fe:	f6c41603          	lh	a2,-148(s0)
    80006102:	458d                	li	a1,3
    80006104:	f7040513          	addi	a0,s0,-144
    80006108:	fffff097          	auipc	ra,0xfffff
    8000610c:	756080e7          	jalr	1878(ra) # 8000585e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006110:	cd11                	beqz	a0,8000612c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006112:	ffffe097          	auipc	ra,0xffffe
    80006116:	fc4080e7          	jalr	-60(ra) # 800040d6 <iunlockput>
  end_op();
    8000611a:	ffffe097          	auipc	ra,0xffffe
    8000611e:	79e080e7          	jalr	1950(ra) # 800048b8 <end_op>
  return 0;
    80006122:	4501                	li	a0,0
}
    80006124:	60ea                	ld	ra,152(sp)
    80006126:	644a                	ld	s0,144(sp)
    80006128:	610d                	addi	sp,sp,160
    8000612a:	8082                	ret
    end_op();
    8000612c:	ffffe097          	auipc	ra,0xffffe
    80006130:	78c080e7          	jalr	1932(ra) # 800048b8 <end_op>
    return -1;
    80006134:	557d                	li	a0,-1
    80006136:	b7fd                	j	80006124 <sys_mknod+0x6c>

0000000080006138 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006138:	7135                	addi	sp,sp,-160
    8000613a:	ed06                	sd	ra,152(sp)
    8000613c:	e922                	sd	s0,144(sp)
    8000613e:	e14a                	sd	s2,128(sp)
    80006140:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80006142:	ffffc097          	auipc	ra,0xffffc
    80006146:	bfa080e7          	jalr	-1030(ra) # 80001d3c <myproc>
    8000614a:	892a                	mv	s2,a0
  
  begin_op();
    8000614c:	ffffe097          	auipc	ra,0xffffe
    80006150:	6f2080e7          	jalr	1778(ra) # 8000483e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80006154:	08000613          	li	a2,128
    80006158:	f6040593          	addi	a1,s0,-160
    8000615c:	4501                	li	a0,0
    8000615e:	ffffd097          	auipc	ra,0xffffd
    80006162:	12c080e7          	jalr	300(ra) # 8000328a <argstr>
    80006166:	04054d63          	bltz	a0,800061c0 <sys_chdir+0x88>
    8000616a:	e526                	sd	s1,136(sp)
    8000616c:	f6040513          	addi	a0,s0,-160
    80006170:	ffffe097          	auipc	ra,0xffffe
    80006174:	4ce080e7          	jalr	1230(ra) # 8000463e <namei>
    80006178:	84aa                	mv	s1,a0
    8000617a:	c131                	beqz	a0,800061be <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000617c:	ffffe097          	auipc	ra,0xffffe
    80006180:	cf4080e7          	jalr	-780(ra) # 80003e70 <ilock>
  if(ip->type != T_DIR){
    80006184:	04449703          	lh	a4,68(s1)
    80006188:	4785                	li	a5,1
    8000618a:	04f71163          	bne	a4,a5,800061cc <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000618e:	8526                	mv	a0,s1
    80006190:	ffffe097          	auipc	ra,0xffffe
    80006194:	da6080e7          	jalr	-602(ra) # 80003f36 <iunlock>
  iput(p->cwd);
    80006198:	15093503          	ld	a0,336(s2)
    8000619c:	ffffe097          	auipc	ra,0xffffe
    800061a0:	e92080e7          	jalr	-366(ra) # 8000402e <iput>
  end_op();
    800061a4:	ffffe097          	auipc	ra,0xffffe
    800061a8:	714080e7          	jalr	1812(ra) # 800048b8 <end_op>
  p->cwd = ip;
    800061ac:	14993823          	sd	s1,336(s2)
  return 0;
    800061b0:	4501                	li	a0,0
    800061b2:	64aa                	ld	s1,136(sp)
}
    800061b4:	60ea                	ld	ra,152(sp)
    800061b6:	644a                	ld	s0,144(sp)
    800061b8:	690a                	ld	s2,128(sp)
    800061ba:	610d                	addi	sp,sp,160
    800061bc:	8082                	ret
    800061be:	64aa                	ld	s1,136(sp)
    end_op();
    800061c0:	ffffe097          	auipc	ra,0xffffe
    800061c4:	6f8080e7          	jalr	1784(ra) # 800048b8 <end_op>
    return -1;
    800061c8:	557d                	li	a0,-1
    800061ca:	b7ed                	j	800061b4 <sys_chdir+0x7c>
    iunlockput(ip);
    800061cc:	8526                	mv	a0,s1
    800061ce:	ffffe097          	auipc	ra,0xffffe
    800061d2:	f08080e7          	jalr	-248(ra) # 800040d6 <iunlockput>
    end_op();
    800061d6:	ffffe097          	auipc	ra,0xffffe
    800061da:	6e2080e7          	jalr	1762(ra) # 800048b8 <end_op>
    return -1;
    800061de:	557d                	li	a0,-1
    800061e0:	64aa                	ld	s1,136(sp)
    800061e2:	bfc9                	j	800061b4 <sys_chdir+0x7c>

00000000800061e4 <sys_exec>:

uint64
sys_exec(void)
{
    800061e4:	7121                	addi	sp,sp,-448
    800061e6:	ff06                	sd	ra,440(sp)
    800061e8:	fb22                	sd	s0,432(sp)
    800061ea:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800061ec:	e4840593          	addi	a1,s0,-440
    800061f0:	4505                	li	a0,1
    800061f2:	ffffd097          	auipc	ra,0xffffd
    800061f6:	078080e7          	jalr	120(ra) # 8000326a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800061fa:	08000613          	li	a2,128
    800061fe:	f5040593          	addi	a1,s0,-176
    80006202:	4501                	li	a0,0
    80006204:	ffffd097          	auipc	ra,0xffffd
    80006208:	086080e7          	jalr	134(ra) # 8000328a <argstr>
    8000620c:	87aa                	mv	a5,a0
    return -1;
    8000620e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006210:	0e07c263          	bltz	a5,800062f4 <sys_exec+0x110>
    80006214:	f726                	sd	s1,424(sp)
    80006216:	f34a                	sd	s2,416(sp)
    80006218:	ef4e                	sd	s3,408(sp)
    8000621a:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000621c:	10000613          	li	a2,256
    80006220:	4581                	li	a1,0
    80006222:	e5040513          	addi	a0,s0,-432
    80006226:	ffffb097          	auipc	ra,0xffffb
    8000622a:	c5e080e7          	jalr	-930(ra) # 80000e84 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000622e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80006232:	89a6                	mv	s3,s1
    80006234:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006236:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000623a:	00391513          	slli	a0,s2,0x3
    8000623e:	e4040593          	addi	a1,s0,-448
    80006242:	e4843783          	ld	a5,-440(s0)
    80006246:	953e                	add	a0,a0,a5
    80006248:	ffffd097          	auipc	ra,0xffffd
    8000624c:	f64080e7          	jalr	-156(ra) # 800031ac <fetchaddr>
    80006250:	02054a63          	bltz	a0,80006284 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80006254:	e4043783          	ld	a5,-448(s0)
    80006258:	c7b9                	beqz	a5,800062a6 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000625a:	ffffb097          	auipc	ra,0xffffb
    8000625e:	a04080e7          	jalr	-1532(ra) # 80000c5e <kalloc>
    80006262:	85aa                	mv	a1,a0
    80006264:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006268:	cd11                	beqz	a0,80006284 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000626a:	6605                	lui	a2,0x1
    8000626c:	e4043503          	ld	a0,-448(s0)
    80006270:	ffffd097          	auipc	ra,0xffffd
    80006274:	f8e080e7          	jalr	-114(ra) # 800031fe <fetchstr>
    80006278:	00054663          	bltz	a0,80006284 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000627c:	0905                	addi	s2,s2,1
    8000627e:	09a1                	addi	s3,s3,8
    80006280:	fb491de3          	bne	s2,s4,8000623a <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006284:	f5040913          	addi	s2,s0,-176
    80006288:	6088                	ld	a0,0(s1)
    8000628a:	c125                	beqz	a0,800062ea <sys_exec+0x106>
    kfree(argv[i]);
    8000628c:	ffffa097          	auipc	ra,0xffffa
    80006290:	7be080e7          	jalr	1982(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006294:	04a1                	addi	s1,s1,8
    80006296:	ff2499e3          	bne	s1,s2,80006288 <sys_exec+0xa4>
  return -1;
    8000629a:	557d                	li	a0,-1
    8000629c:	74ba                	ld	s1,424(sp)
    8000629e:	791a                	ld	s2,416(sp)
    800062a0:	69fa                	ld	s3,408(sp)
    800062a2:	6a5a                	ld	s4,400(sp)
    800062a4:	a881                	j	800062f4 <sys_exec+0x110>
      argv[i] = 0;
    800062a6:	0009079b          	sext.w	a5,s2
    800062aa:	078e                	slli	a5,a5,0x3
    800062ac:	fd078793          	addi	a5,a5,-48
    800062b0:	97a2                	add	a5,a5,s0
    800062b2:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800062b6:	e5040593          	addi	a1,s0,-432
    800062ba:	f5040513          	addi	a0,s0,-176
    800062be:	fffff097          	auipc	ra,0xfffff
    800062c2:	120080e7          	jalr	288(ra) # 800053de <exec>
    800062c6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062c8:	f5040993          	addi	s3,s0,-176
    800062cc:	6088                	ld	a0,0(s1)
    800062ce:	c901                	beqz	a0,800062de <sys_exec+0xfa>
    kfree(argv[i]);
    800062d0:	ffffa097          	auipc	ra,0xffffa
    800062d4:	77a080e7          	jalr	1914(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062d8:	04a1                	addi	s1,s1,8
    800062da:	ff3499e3          	bne	s1,s3,800062cc <sys_exec+0xe8>
  return ret;
    800062de:	854a                	mv	a0,s2
    800062e0:	74ba                	ld	s1,424(sp)
    800062e2:	791a                	ld	s2,416(sp)
    800062e4:	69fa                	ld	s3,408(sp)
    800062e6:	6a5a                	ld	s4,400(sp)
    800062e8:	a031                	j	800062f4 <sys_exec+0x110>
  return -1;
    800062ea:	557d                	li	a0,-1
    800062ec:	74ba                	ld	s1,424(sp)
    800062ee:	791a                	ld	s2,416(sp)
    800062f0:	69fa                	ld	s3,408(sp)
    800062f2:	6a5a                	ld	s4,400(sp)
}
    800062f4:	70fa                	ld	ra,440(sp)
    800062f6:	745a                	ld	s0,432(sp)
    800062f8:	6139                	addi	sp,sp,448
    800062fa:	8082                	ret

00000000800062fc <sys_pipe>:

uint64
sys_pipe(void)
{
    800062fc:	7139                	addi	sp,sp,-64
    800062fe:	fc06                	sd	ra,56(sp)
    80006300:	f822                	sd	s0,48(sp)
    80006302:	f426                	sd	s1,40(sp)
    80006304:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006306:	ffffc097          	auipc	ra,0xffffc
    8000630a:	a36080e7          	jalr	-1482(ra) # 80001d3c <myproc>
    8000630e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006310:	fd840593          	addi	a1,s0,-40
    80006314:	4501                	li	a0,0
    80006316:	ffffd097          	auipc	ra,0xffffd
    8000631a:	f54080e7          	jalr	-172(ra) # 8000326a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000631e:	fc840593          	addi	a1,s0,-56
    80006322:	fd040513          	addi	a0,s0,-48
    80006326:	fffff097          	auipc	ra,0xfffff
    8000632a:	d50080e7          	jalr	-688(ra) # 80005076 <pipealloc>
    return -1;
    8000632e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006330:	0c054463          	bltz	a0,800063f8 <sys_pipe+0xfc>
  fd0 = -1;
    80006334:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006338:	fd043503          	ld	a0,-48(s0)
    8000633c:	fffff097          	auipc	ra,0xfffff
    80006340:	4e0080e7          	jalr	1248(ra) # 8000581c <fdalloc>
    80006344:	fca42223          	sw	a0,-60(s0)
    80006348:	08054b63          	bltz	a0,800063de <sys_pipe+0xe2>
    8000634c:	fc843503          	ld	a0,-56(s0)
    80006350:	fffff097          	auipc	ra,0xfffff
    80006354:	4cc080e7          	jalr	1228(ra) # 8000581c <fdalloc>
    80006358:	fca42023          	sw	a0,-64(s0)
    8000635c:	06054863          	bltz	a0,800063cc <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006360:	4691                	li	a3,4
    80006362:	fc440613          	addi	a2,s0,-60
    80006366:	fd843583          	ld	a1,-40(s0)
    8000636a:	68a8                	ld	a0,80(s1)
    8000636c:	ffffb097          	auipc	ra,0xffffb
    80006370:	504080e7          	jalr	1284(ra) # 80001870 <copyout>
    80006374:	02054063          	bltz	a0,80006394 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006378:	4691                	li	a3,4
    8000637a:	fc040613          	addi	a2,s0,-64
    8000637e:	fd843583          	ld	a1,-40(s0)
    80006382:	0591                	addi	a1,a1,4
    80006384:	68a8                	ld	a0,80(s1)
    80006386:	ffffb097          	auipc	ra,0xffffb
    8000638a:	4ea080e7          	jalr	1258(ra) # 80001870 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000638e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006390:	06055463          	bgez	a0,800063f8 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006394:	fc442783          	lw	a5,-60(s0)
    80006398:	07e9                	addi	a5,a5,26
    8000639a:	078e                	slli	a5,a5,0x3
    8000639c:	97a6                	add	a5,a5,s1
    8000639e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800063a2:	fc042783          	lw	a5,-64(s0)
    800063a6:	07e9                	addi	a5,a5,26
    800063a8:	078e                	slli	a5,a5,0x3
    800063aa:	94be                	add	s1,s1,a5
    800063ac:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800063b0:	fd043503          	ld	a0,-48(s0)
    800063b4:	fffff097          	auipc	ra,0xfffff
    800063b8:	954080e7          	jalr	-1708(ra) # 80004d08 <fileclose>
    fileclose(wf);
    800063bc:	fc843503          	ld	a0,-56(s0)
    800063c0:	fffff097          	auipc	ra,0xfffff
    800063c4:	948080e7          	jalr	-1720(ra) # 80004d08 <fileclose>
    return -1;
    800063c8:	57fd                	li	a5,-1
    800063ca:	a03d                	j	800063f8 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800063cc:	fc442783          	lw	a5,-60(s0)
    800063d0:	0007c763          	bltz	a5,800063de <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800063d4:	07e9                	addi	a5,a5,26
    800063d6:	078e                	slli	a5,a5,0x3
    800063d8:	97a6                	add	a5,a5,s1
    800063da:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800063de:	fd043503          	ld	a0,-48(s0)
    800063e2:	fffff097          	auipc	ra,0xfffff
    800063e6:	926080e7          	jalr	-1754(ra) # 80004d08 <fileclose>
    fileclose(wf);
    800063ea:	fc843503          	ld	a0,-56(s0)
    800063ee:	fffff097          	auipc	ra,0xfffff
    800063f2:	91a080e7          	jalr	-1766(ra) # 80004d08 <fileclose>
    return -1;
    800063f6:	57fd                	li	a5,-1
}
    800063f8:	853e                	mv	a0,a5
    800063fa:	70e2                	ld	ra,56(sp)
    800063fc:	7442                	ld	s0,48(sp)
    800063fe:	74a2                	ld	s1,40(sp)
    80006400:	6121                	addi	sp,sp,64
    80006402:	8082                	ret
	...

0000000080006410 <kernelvec>:
    80006410:	7111                	addi	sp,sp,-256
    80006412:	e006                	sd	ra,0(sp)
    80006414:	e40a                	sd	sp,8(sp)
    80006416:	e80e                	sd	gp,16(sp)
    80006418:	ec12                	sd	tp,24(sp)
    8000641a:	f016                	sd	t0,32(sp)
    8000641c:	f41a                	sd	t1,40(sp)
    8000641e:	f81e                	sd	t2,48(sp)
    80006420:	fc22                	sd	s0,56(sp)
    80006422:	e0a6                	sd	s1,64(sp)
    80006424:	e4aa                	sd	a0,72(sp)
    80006426:	e8ae                	sd	a1,80(sp)
    80006428:	ecb2                	sd	a2,88(sp)
    8000642a:	f0b6                	sd	a3,96(sp)
    8000642c:	f4ba                	sd	a4,104(sp)
    8000642e:	f8be                	sd	a5,112(sp)
    80006430:	fcc2                	sd	a6,120(sp)
    80006432:	e146                	sd	a7,128(sp)
    80006434:	e54a                	sd	s2,136(sp)
    80006436:	e94e                	sd	s3,144(sp)
    80006438:	ed52                	sd	s4,152(sp)
    8000643a:	f156                	sd	s5,160(sp)
    8000643c:	f55a                	sd	s6,168(sp)
    8000643e:	f95e                	sd	s7,176(sp)
    80006440:	fd62                	sd	s8,184(sp)
    80006442:	e1e6                	sd	s9,192(sp)
    80006444:	e5ea                	sd	s10,200(sp)
    80006446:	e9ee                	sd	s11,208(sp)
    80006448:	edf2                	sd	t3,216(sp)
    8000644a:	f1f6                	sd	t4,224(sp)
    8000644c:	f5fa                	sd	t5,232(sp)
    8000644e:	f9fe                	sd	t6,240(sp)
    80006450:	c29fc0ef          	jal	80003078 <kerneltrap>
    80006454:	6082                	ld	ra,0(sp)
    80006456:	6122                	ld	sp,8(sp)
    80006458:	61c2                	ld	gp,16(sp)
    8000645a:	7282                	ld	t0,32(sp)
    8000645c:	7322                	ld	t1,40(sp)
    8000645e:	73c2                	ld	t2,48(sp)
    80006460:	7462                	ld	s0,56(sp)
    80006462:	6486                	ld	s1,64(sp)
    80006464:	6526                	ld	a0,72(sp)
    80006466:	65c6                	ld	a1,80(sp)
    80006468:	6666                	ld	a2,88(sp)
    8000646a:	7686                	ld	a3,96(sp)
    8000646c:	7726                	ld	a4,104(sp)
    8000646e:	77c6                	ld	a5,112(sp)
    80006470:	7866                	ld	a6,120(sp)
    80006472:	688a                	ld	a7,128(sp)
    80006474:	692a                	ld	s2,136(sp)
    80006476:	69ca                	ld	s3,144(sp)
    80006478:	6a6a                	ld	s4,152(sp)
    8000647a:	7a8a                	ld	s5,160(sp)
    8000647c:	7b2a                	ld	s6,168(sp)
    8000647e:	7bca                	ld	s7,176(sp)
    80006480:	7c6a                	ld	s8,184(sp)
    80006482:	6c8e                	ld	s9,192(sp)
    80006484:	6d2e                	ld	s10,200(sp)
    80006486:	6dce                	ld	s11,208(sp)
    80006488:	6e6e                	ld	t3,216(sp)
    8000648a:	7e8e                	ld	t4,224(sp)
    8000648c:	7f2e                	ld	t5,232(sp)
    8000648e:	7fce                	ld	t6,240(sp)
    80006490:	6111                	addi	sp,sp,256
    80006492:	10200073          	sret
    80006496:	00000013          	nop
    8000649a:	00000013          	nop
    8000649e:	0001                	nop

00000000800064a0 <timervec>:
    800064a0:	34051573          	csrrw	a0,mscratch,a0
    800064a4:	e10c                	sd	a1,0(a0)
    800064a6:	e510                	sd	a2,8(a0)
    800064a8:	e914                	sd	a3,16(a0)
    800064aa:	6d0c                	ld	a1,24(a0)
    800064ac:	7110                	ld	a2,32(a0)
    800064ae:	6194                	ld	a3,0(a1)
    800064b0:	96b2                	add	a3,a3,a2
    800064b2:	e194                	sd	a3,0(a1)
    800064b4:	4589                	li	a1,2
    800064b6:	14459073          	csrw	sip,a1
    800064ba:	6914                	ld	a3,16(a0)
    800064bc:	6510                	ld	a2,8(a0)
    800064be:	610c                	ld	a1,0(a0)
    800064c0:	34051573          	csrrw	a0,mscratch,a0
    800064c4:	30200073          	mret
	...

00000000800064ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800064ca:	1141                	addi	sp,sp,-16
    800064cc:	e422                	sd	s0,8(sp)
    800064ce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800064d0:	0c0007b7          	lui	a5,0xc000
    800064d4:	4705                	li	a4,1
    800064d6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800064d8:	0c0007b7          	lui	a5,0xc000
    800064dc:	c3d8                	sw	a4,4(a5)
}
    800064de:	6422                	ld	s0,8(sp)
    800064e0:	0141                	addi	sp,sp,16
    800064e2:	8082                	ret

00000000800064e4 <plicinithart>:

void
plicinithart(void)
{
    800064e4:	1141                	addi	sp,sp,-16
    800064e6:	e406                	sd	ra,8(sp)
    800064e8:	e022                	sd	s0,0(sp)
    800064ea:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800064ec:	ffffc097          	auipc	ra,0xffffc
    800064f0:	824080e7          	jalr	-2012(ra) # 80001d10 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800064f4:	0085171b          	slliw	a4,a0,0x8
    800064f8:	0c0027b7          	lui	a5,0xc002
    800064fc:	97ba                	add	a5,a5,a4
    800064fe:	40200713          	li	a4,1026
    80006502:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006506:	00d5151b          	slliw	a0,a0,0xd
    8000650a:	0c2017b7          	lui	a5,0xc201
    8000650e:	97aa                	add	a5,a5,a0
    80006510:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006514:	60a2                	ld	ra,8(sp)
    80006516:	6402                	ld	s0,0(sp)
    80006518:	0141                	addi	sp,sp,16
    8000651a:	8082                	ret

000000008000651c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000651c:	1141                	addi	sp,sp,-16
    8000651e:	e406                	sd	ra,8(sp)
    80006520:	e022                	sd	s0,0(sp)
    80006522:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006524:	ffffb097          	auipc	ra,0xffffb
    80006528:	7ec080e7          	jalr	2028(ra) # 80001d10 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000652c:	00d5151b          	slliw	a0,a0,0xd
    80006530:	0c2017b7          	lui	a5,0xc201
    80006534:	97aa                	add	a5,a5,a0
  return irq;
}
    80006536:	43c8                	lw	a0,4(a5)
    80006538:	60a2                	ld	ra,8(sp)
    8000653a:	6402                	ld	s0,0(sp)
    8000653c:	0141                	addi	sp,sp,16
    8000653e:	8082                	ret

0000000080006540 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006540:	1101                	addi	sp,sp,-32
    80006542:	ec06                	sd	ra,24(sp)
    80006544:	e822                	sd	s0,16(sp)
    80006546:	e426                	sd	s1,8(sp)
    80006548:	1000                	addi	s0,sp,32
    8000654a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000654c:	ffffb097          	auipc	ra,0xffffb
    80006550:	7c4080e7          	jalr	1988(ra) # 80001d10 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006554:	00d5151b          	slliw	a0,a0,0xd
    80006558:	0c2017b7          	lui	a5,0xc201
    8000655c:	97aa                	add	a5,a5,a0
    8000655e:	c3c4                	sw	s1,4(a5)
}
    80006560:	60e2                	ld	ra,24(sp)
    80006562:	6442                	ld	s0,16(sp)
    80006564:	64a2                	ld	s1,8(sp)
    80006566:	6105                	addi	sp,sp,32
    80006568:	8082                	ret

000000008000656a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000656a:	1141                	addi	sp,sp,-16
    8000656c:	e406                	sd	ra,8(sp)
    8000656e:	e022                	sd	s0,0(sp)
    80006570:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006572:	479d                	li	a5,7
    80006574:	04a7cc63          	blt	a5,a0,800065cc <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006578:	0023c797          	auipc	a5,0x23c
    8000657c:	af078793          	addi	a5,a5,-1296 # 80242068 <disk>
    80006580:	97aa                	add	a5,a5,a0
    80006582:	0187c783          	lbu	a5,24(a5)
    80006586:	ebb9                	bnez	a5,800065dc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006588:	00451693          	slli	a3,a0,0x4
    8000658c:	0023c797          	auipc	a5,0x23c
    80006590:	adc78793          	addi	a5,a5,-1316 # 80242068 <disk>
    80006594:	6398                	ld	a4,0(a5)
    80006596:	9736                	add	a4,a4,a3
    80006598:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000659c:	6398                	ld	a4,0(a5)
    8000659e:	9736                	add	a4,a4,a3
    800065a0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800065a4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800065a8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800065ac:	97aa                	add	a5,a5,a0
    800065ae:	4705                	li	a4,1
    800065b0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800065b4:	0023c517          	auipc	a0,0x23c
    800065b8:	acc50513          	addi	a0,a0,-1332 # 80242080 <disk+0x18>
    800065bc:	ffffc097          	auipc	ra,0xffffc
    800065c0:	ebc080e7          	jalr	-324(ra) # 80002478 <wakeup>
}
    800065c4:	60a2                	ld	ra,8(sp)
    800065c6:	6402                	ld	s0,0(sp)
    800065c8:	0141                	addi	sp,sp,16
    800065ca:	8082                	ret
    panic("free_desc 1");
    800065cc:	00002517          	auipc	a0,0x2
    800065d0:	0ac50513          	addi	a0,a0,172 # 80008678 <etext+0x678>
    800065d4:	ffffa097          	auipc	ra,0xffffa
    800065d8:	f8c080e7          	jalr	-116(ra) # 80000560 <panic>
    panic("free_desc 2");
    800065dc:	00002517          	auipc	a0,0x2
    800065e0:	0ac50513          	addi	a0,a0,172 # 80008688 <etext+0x688>
    800065e4:	ffffa097          	auipc	ra,0xffffa
    800065e8:	f7c080e7          	jalr	-132(ra) # 80000560 <panic>

00000000800065ec <virtio_disk_init>:
{
    800065ec:	1101                	addi	sp,sp,-32
    800065ee:	ec06                	sd	ra,24(sp)
    800065f0:	e822                	sd	s0,16(sp)
    800065f2:	e426                	sd	s1,8(sp)
    800065f4:	e04a                	sd	s2,0(sp)
    800065f6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800065f8:	00002597          	auipc	a1,0x2
    800065fc:	0a058593          	addi	a1,a1,160 # 80008698 <etext+0x698>
    80006600:	0023c517          	auipc	a0,0x23c
    80006604:	b9050513          	addi	a0,a0,-1136 # 80242190 <disk+0x128>
    80006608:	ffffa097          	auipc	ra,0xffffa
    8000660c:	6f0080e7          	jalr	1776(ra) # 80000cf8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006610:	100017b7          	lui	a5,0x10001
    80006614:	4398                	lw	a4,0(a5)
    80006616:	2701                	sext.w	a4,a4
    80006618:	747277b7          	lui	a5,0x74727
    8000661c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006620:	18f71c63          	bne	a4,a5,800067b8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006624:	100017b7          	lui	a5,0x10001
    80006628:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000662a:	439c                	lw	a5,0(a5)
    8000662c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000662e:	4709                	li	a4,2
    80006630:	18e79463          	bne	a5,a4,800067b8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006634:	100017b7          	lui	a5,0x10001
    80006638:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000663a:	439c                	lw	a5,0(a5)
    8000663c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000663e:	16e79d63          	bne	a5,a4,800067b8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006642:	100017b7          	lui	a5,0x10001
    80006646:	47d8                	lw	a4,12(a5)
    80006648:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000664a:	554d47b7          	lui	a5,0x554d4
    8000664e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006652:	16f71363          	bne	a4,a5,800067b8 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006656:	100017b7          	lui	a5,0x10001
    8000665a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000665e:	4705                	li	a4,1
    80006660:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006662:	470d                	li	a4,3
    80006664:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006666:	10001737          	lui	a4,0x10001
    8000666a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000666c:	c7ffe737          	lui	a4,0xc7ffe
    80006670:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47dbc5b7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006674:	8ef9                	and	a3,a3,a4
    80006676:	10001737          	lui	a4,0x10001
    8000667a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000667c:	472d                	li	a4,11
    8000667e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006680:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006684:	439c                	lw	a5,0(a5)
    80006686:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000668a:	8ba1                	andi	a5,a5,8
    8000668c:	12078e63          	beqz	a5,800067c8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006690:	100017b7          	lui	a5,0x10001
    80006694:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006698:	100017b7          	lui	a5,0x10001
    8000669c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800066a0:	439c                	lw	a5,0(a5)
    800066a2:	2781                	sext.w	a5,a5
    800066a4:	12079a63          	bnez	a5,800067d8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800066a8:	100017b7          	lui	a5,0x10001
    800066ac:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800066b0:	439c                	lw	a5,0(a5)
    800066b2:	2781                	sext.w	a5,a5
  if(max == 0)
    800066b4:	12078a63          	beqz	a5,800067e8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    800066b8:	471d                	li	a4,7
    800066ba:	12f77f63          	bgeu	a4,a5,800067f8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    800066be:	ffffa097          	auipc	ra,0xffffa
    800066c2:	5a0080e7          	jalr	1440(ra) # 80000c5e <kalloc>
    800066c6:	0023c497          	auipc	s1,0x23c
    800066ca:	9a248493          	addi	s1,s1,-1630 # 80242068 <disk>
    800066ce:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800066d0:	ffffa097          	auipc	ra,0xffffa
    800066d4:	58e080e7          	jalr	1422(ra) # 80000c5e <kalloc>
    800066d8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800066da:	ffffa097          	auipc	ra,0xffffa
    800066de:	584080e7          	jalr	1412(ra) # 80000c5e <kalloc>
    800066e2:	87aa                	mv	a5,a0
    800066e4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800066e6:	6088                	ld	a0,0(s1)
    800066e8:	12050063          	beqz	a0,80006808 <virtio_disk_init+0x21c>
    800066ec:	0023c717          	auipc	a4,0x23c
    800066f0:	98473703          	ld	a4,-1660(a4) # 80242070 <disk+0x8>
    800066f4:	10070a63          	beqz	a4,80006808 <virtio_disk_init+0x21c>
    800066f8:	10078863          	beqz	a5,80006808 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800066fc:	6605                	lui	a2,0x1
    800066fe:	4581                	li	a1,0
    80006700:	ffffa097          	auipc	ra,0xffffa
    80006704:	784080e7          	jalr	1924(ra) # 80000e84 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006708:	0023c497          	auipc	s1,0x23c
    8000670c:	96048493          	addi	s1,s1,-1696 # 80242068 <disk>
    80006710:	6605                	lui	a2,0x1
    80006712:	4581                	li	a1,0
    80006714:	6488                	ld	a0,8(s1)
    80006716:	ffffa097          	auipc	ra,0xffffa
    8000671a:	76e080e7          	jalr	1902(ra) # 80000e84 <memset>
  memset(disk.used, 0, PGSIZE);
    8000671e:	6605                	lui	a2,0x1
    80006720:	4581                	li	a1,0
    80006722:	6888                	ld	a0,16(s1)
    80006724:	ffffa097          	auipc	ra,0xffffa
    80006728:	760080e7          	jalr	1888(ra) # 80000e84 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000672c:	100017b7          	lui	a5,0x10001
    80006730:	4721                	li	a4,8
    80006732:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006734:	4098                	lw	a4,0(s1)
    80006736:	100017b7          	lui	a5,0x10001
    8000673a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000673e:	40d8                	lw	a4,4(s1)
    80006740:	100017b7          	lui	a5,0x10001
    80006744:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006748:	649c                	ld	a5,8(s1)
    8000674a:	0007869b          	sext.w	a3,a5
    8000674e:	10001737          	lui	a4,0x10001
    80006752:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006756:	9781                	srai	a5,a5,0x20
    80006758:	10001737          	lui	a4,0x10001
    8000675c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006760:	689c                	ld	a5,16(s1)
    80006762:	0007869b          	sext.w	a3,a5
    80006766:	10001737          	lui	a4,0x10001
    8000676a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000676e:	9781                	srai	a5,a5,0x20
    80006770:	10001737          	lui	a4,0x10001
    80006774:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006778:	10001737          	lui	a4,0x10001
    8000677c:	4785                	li	a5,1
    8000677e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006780:	00f48c23          	sb	a5,24(s1)
    80006784:	00f48ca3          	sb	a5,25(s1)
    80006788:	00f48d23          	sb	a5,26(s1)
    8000678c:	00f48da3          	sb	a5,27(s1)
    80006790:	00f48e23          	sb	a5,28(s1)
    80006794:	00f48ea3          	sb	a5,29(s1)
    80006798:	00f48f23          	sb	a5,30(s1)
    8000679c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800067a0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800067a4:	100017b7          	lui	a5,0x10001
    800067a8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800067ac:	60e2                	ld	ra,24(sp)
    800067ae:	6442                	ld	s0,16(sp)
    800067b0:	64a2                	ld	s1,8(sp)
    800067b2:	6902                	ld	s2,0(sp)
    800067b4:	6105                	addi	sp,sp,32
    800067b6:	8082                	ret
    panic("could not find virtio disk");
    800067b8:	00002517          	auipc	a0,0x2
    800067bc:	ef050513          	addi	a0,a0,-272 # 800086a8 <etext+0x6a8>
    800067c0:	ffffa097          	auipc	ra,0xffffa
    800067c4:	da0080e7          	jalr	-608(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    800067c8:	00002517          	auipc	a0,0x2
    800067cc:	f0050513          	addi	a0,a0,-256 # 800086c8 <etext+0x6c8>
    800067d0:	ffffa097          	auipc	ra,0xffffa
    800067d4:	d90080e7          	jalr	-624(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800067d8:	00002517          	auipc	a0,0x2
    800067dc:	f1050513          	addi	a0,a0,-240 # 800086e8 <etext+0x6e8>
    800067e0:	ffffa097          	auipc	ra,0xffffa
    800067e4:	d80080e7          	jalr	-640(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    800067e8:	00002517          	auipc	a0,0x2
    800067ec:	f2050513          	addi	a0,a0,-224 # 80008708 <etext+0x708>
    800067f0:	ffffa097          	auipc	ra,0xffffa
    800067f4:	d70080e7          	jalr	-656(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    800067f8:	00002517          	auipc	a0,0x2
    800067fc:	f3050513          	addi	a0,a0,-208 # 80008728 <etext+0x728>
    80006800:	ffffa097          	auipc	ra,0xffffa
    80006804:	d60080e7          	jalr	-672(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    80006808:	00002517          	auipc	a0,0x2
    8000680c:	f4050513          	addi	a0,a0,-192 # 80008748 <etext+0x748>
    80006810:	ffffa097          	auipc	ra,0xffffa
    80006814:	d50080e7          	jalr	-688(ra) # 80000560 <panic>

0000000080006818 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006818:	7159                	addi	sp,sp,-112
    8000681a:	f486                	sd	ra,104(sp)
    8000681c:	f0a2                	sd	s0,96(sp)
    8000681e:	eca6                	sd	s1,88(sp)
    80006820:	e8ca                	sd	s2,80(sp)
    80006822:	e4ce                	sd	s3,72(sp)
    80006824:	e0d2                	sd	s4,64(sp)
    80006826:	fc56                	sd	s5,56(sp)
    80006828:	f85a                	sd	s6,48(sp)
    8000682a:	f45e                	sd	s7,40(sp)
    8000682c:	f062                	sd	s8,32(sp)
    8000682e:	ec66                	sd	s9,24(sp)
    80006830:	1880                	addi	s0,sp,112
    80006832:	8a2a                	mv	s4,a0
    80006834:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006836:	00c52c83          	lw	s9,12(a0)
    8000683a:	001c9c9b          	slliw	s9,s9,0x1
    8000683e:	1c82                	slli	s9,s9,0x20
    80006840:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006844:	0023c517          	auipc	a0,0x23c
    80006848:	94c50513          	addi	a0,a0,-1716 # 80242190 <disk+0x128>
    8000684c:	ffffa097          	auipc	ra,0xffffa
    80006850:	53c080e7          	jalr	1340(ra) # 80000d88 <acquire>
  for(int i = 0; i < 3; i++){
    80006854:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006856:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006858:	0023cb17          	auipc	s6,0x23c
    8000685c:	810b0b13          	addi	s6,s6,-2032 # 80242068 <disk>
  for(int i = 0; i < 3; i++){
    80006860:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006862:	0023cc17          	auipc	s8,0x23c
    80006866:	92ec0c13          	addi	s8,s8,-1746 # 80242190 <disk+0x128>
    8000686a:	a0ad                	j	800068d4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000686c:	00fb0733          	add	a4,s6,a5
    80006870:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006874:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006876:	0207c563          	bltz	a5,800068a0 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000687a:	2905                	addiw	s2,s2,1
    8000687c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000687e:	05590f63          	beq	s2,s5,800068dc <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006882:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006884:	0023b717          	auipc	a4,0x23b
    80006888:	7e470713          	addi	a4,a4,2020 # 80242068 <disk>
    8000688c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000688e:	01874683          	lbu	a3,24(a4)
    80006892:	fee9                	bnez	a3,8000686c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006894:	2785                	addiw	a5,a5,1
    80006896:	0705                	addi	a4,a4,1
    80006898:	fe979be3          	bne	a5,s1,8000688e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000689c:	57fd                	li	a5,-1
    8000689e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800068a0:	03205163          	blez	s2,800068c2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800068a4:	f9042503          	lw	a0,-112(s0)
    800068a8:	00000097          	auipc	ra,0x0
    800068ac:	cc2080e7          	jalr	-830(ra) # 8000656a <free_desc>
      for(int j = 0; j < i; j++)
    800068b0:	4785                	li	a5,1
    800068b2:	0127d863          	bge	a5,s2,800068c2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800068b6:	f9442503          	lw	a0,-108(s0)
    800068ba:	00000097          	auipc	ra,0x0
    800068be:	cb0080e7          	jalr	-848(ra) # 8000656a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800068c2:	85e2                	mv	a1,s8
    800068c4:	0023b517          	auipc	a0,0x23b
    800068c8:	7bc50513          	addi	a0,a0,1980 # 80242080 <disk+0x18>
    800068cc:	ffffc097          	auipc	ra,0xffffc
    800068d0:	b48080e7          	jalr	-1208(ra) # 80002414 <sleep>
  for(int i = 0; i < 3; i++){
    800068d4:	f9040613          	addi	a2,s0,-112
    800068d8:	894e                	mv	s2,s3
    800068da:	b765                	j	80006882 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800068dc:	f9042503          	lw	a0,-112(s0)
    800068e0:	00451693          	slli	a3,a0,0x4

  if(write)
    800068e4:	0023b797          	auipc	a5,0x23b
    800068e8:	78478793          	addi	a5,a5,1924 # 80242068 <disk>
    800068ec:	00a50713          	addi	a4,a0,10
    800068f0:	0712                	slli	a4,a4,0x4
    800068f2:	973e                	add	a4,a4,a5
    800068f4:	01703633          	snez	a2,s7
    800068f8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800068fa:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800068fe:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006902:	6398                	ld	a4,0(a5)
    80006904:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006906:	0a868613          	addi	a2,a3,168
    8000690a:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000690c:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000690e:	6390                	ld	a2,0(a5)
    80006910:	00d605b3          	add	a1,a2,a3
    80006914:	4741                	li	a4,16
    80006916:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006918:	4805                	li	a6,1
    8000691a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000691e:	f9442703          	lw	a4,-108(s0)
    80006922:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006926:	0712                	slli	a4,a4,0x4
    80006928:	963a                	add	a2,a2,a4
    8000692a:	058a0593          	addi	a1,s4,88
    8000692e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006930:	0007b883          	ld	a7,0(a5)
    80006934:	9746                	add	a4,a4,a7
    80006936:	40000613          	li	a2,1024
    8000693a:	c710                	sw	a2,8(a4)
  if(write)
    8000693c:	001bb613          	seqz	a2,s7
    80006940:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006944:	00166613          	ori	a2,a2,1
    80006948:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000694c:	f9842583          	lw	a1,-104(s0)
    80006950:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006954:	00250613          	addi	a2,a0,2
    80006958:	0612                	slli	a2,a2,0x4
    8000695a:	963e                	add	a2,a2,a5
    8000695c:	577d                	li	a4,-1
    8000695e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006962:	0592                	slli	a1,a1,0x4
    80006964:	98ae                	add	a7,a7,a1
    80006966:	03068713          	addi	a4,a3,48
    8000696a:	973e                	add	a4,a4,a5
    8000696c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006970:	6398                	ld	a4,0(a5)
    80006972:	972e                	add	a4,a4,a1
    80006974:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006978:	4689                	li	a3,2
    8000697a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000697e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006982:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006986:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000698a:	6794                	ld	a3,8(a5)
    8000698c:	0026d703          	lhu	a4,2(a3)
    80006990:	8b1d                	andi	a4,a4,7
    80006992:	0706                	slli	a4,a4,0x1
    80006994:	96ba                	add	a3,a3,a4
    80006996:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000699a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000699e:	6798                	ld	a4,8(a5)
    800069a0:	00275783          	lhu	a5,2(a4)
    800069a4:	2785                	addiw	a5,a5,1
    800069a6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800069aa:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800069ae:	100017b7          	lui	a5,0x10001
    800069b2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800069b6:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800069ba:	0023b917          	auipc	s2,0x23b
    800069be:	7d690913          	addi	s2,s2,2006 # 80242190 <disk+0x128>
  while(b->disk == 1) {
    800069c2:	4485                	li	s1,1
    800069c4:	01079c63          	bne	a5,a6,800069dc <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800069c8:	85ca                	mv	a1,s2
    800069ca:	8552                	mv	a0,s4
    800069cc:	ffffc097          	auipc	ra,0xffffc
    800069d0:	a48080e7          	jalr	-1464(ra) # 80002414 <sleep>
  while(b->disk == 1) {
    800069d4:	004a2783          	lw	a5,4(s4)
    800069d8:	fe9788e3          	beq	a5,s1,800069c8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800069dc:	f9042903          	lw	s2,-112(s0)
    800069e0:	00290713          	addi	a4,s2,2
    800069e4:	0712                	slli	a4,a4,0x4
    800069e6:	0023b797          	auipc	a5,0x23b
    800069ea:	68278793          	addi	a5,a5,1666 # 80242068 <disk>
    800069ee:	97ba                	add	a5,a5,a4
    800069f0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800069f4:	0023b997          	auipc	s3,0x23b
    800069f8:	67498993          	addi	s3,s3,1652 # 80242068 <disk>
    800069fc:	00491713          	slli	a4,s2,0x4
    80006a00:	0009b783          	ld	a5,0(s3)
    80006a04:	97ba                	add	a5,a5,a4
    80006a06:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006a0a:	854a                	mv	a0,s2
    80006a0c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006a10:	00000097          	auipc	ra,0x0
    80006a14:	b5a080e7          	jalr	-1190(ra) # 8000656a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006a18:	8885                	andi	s1,s1,1
    80006a1a:	f0ed                	bnez	s1,800069fc <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006a1c:	0023b517          	auipc	a0,0x23b
    80006a20:	77450513          	addi	a0,a0,1908 # 80242190 <disk+0x128>
    80006a24:	ffffa097          	auipc	ra,0xffffa
    80006a28:	418080e7          	jalr	1048(ra) # 80000e3c <release>
}
    80006a2c:	70a6                	ld	ra,104(sp)
    80006a2e:	7406                	ld	s0,96(sp)
    80006a30:	64e6                	ld	s1,88(sp)
    80006a32:	6946                	ld	s2,80(sp)
    80006a34:	69a6                	ld	s3,72(sp)
    80006a36:	6a06                	ld	s4,64(sp)
    80006a38:	7ae2                	ld	s5,56(sp)
    80006a3a:	7b42                	ld	s6,48(sp)
    80006a3c:	7ba2                	ld	s7,40(sp)
    80006a3e:	7c02                	ld	s8,32(sp)
    80006a40:	6ce2                	ld	s9,24(sp)
    80006a42:	6165                	addi	sp,sp,112
    80006a44:	8082                	ret

0000000080006a46 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006a46:	1101                	addi	sp,sp,-32
    80006a48:	ec06                	sd	ra,24(sp)
    80006a4a:	e822                	sd	s0,16(sp)
    80006a4c:	e426                	sd	s1,8(sp)
    80006a4e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006a50:	0023b497          	auipc	s1,0x23b
    80006a54:	61848493          	addi	s1,s1,1560 # 80242068 <disk>
    80006a58:	0023b517          	auipc	a0,0x23b
    80006a5c:	73850513          	addi	a0,a0,1848 # 80242190 <disk+0x128>
    80006a60:	ffffa097          	auipc	ra,0xffffa
    80006a64:	328080e7          	jalr	808(ra) # 80000d88 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006a68:	100017b7          	lui	a5,0x10001
    80006a6c:	53b8                	lw	a4,96(a5)
    80006a6e:	8b0d                	andi	a4,a4,3
    80006a70:	100017b7          	lui	a5,0x10001
    80006a74:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006a76:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006a7a:	689c                	ld	a5,16(s1)
    80006a7c:	0204d703          	lhu	a4,32(s1)
    80006a80:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006a84:	04f70863          	beq	a4,a5,80006ad4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006a88:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006a8c:	6898                	ld	a4,16(s1)
    80006a8e:	0204d783          	lhu	a5,32(s1)
    80006a92:	8b9d                	andi	a5,a5,7
    80006a94:	078e                	slli	a5,a5,0x3
    80006a96:	97ba                	add	a5,a5,a4
    80006a98:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006a9a:	00278713          	addi	a4,a5,2
    80006a9e:	0712                	slli	a4,a4,0x4
    80006aa0:	9726                	add	a4,a4,s1
    80006aa2:	01074703          	lbu	a4,16(a4)
    80006aa6:	e721                	bnez	a4,80006aee <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006aa8:	0789                	addi	a5,a5,2
    80006aaa:	0792                	slli	a5,a5,0x4
    80006aac:	97a6                	add	a5,a5,s1
    80006aae:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006ab0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006ab4:	ffffc097          	auipc	ra,0xffffc
    80006ab8:	9c4080e7          	jalr	-1596(ra) # 80002478 <wakeup>

    disk.used_idx += 1;
    80006abc:	0204d783          	lhu	a5,32(s1)
    80006ac0:	2785                	addiw	a5,a5,1
    80006ac2:	17c2                	slli	a5,a5,0x30
    80006ac4:	93c1                	srli	a5,a5,0x30
    80006ac6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006aca:	6898                	ld	a4,16(s1)
    80006acc:	00275703          	lhu	a4,2(a4)
    80006ad0:	faf71ce3          	bne	a4,a5,80006a88 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006ad4:	0023b517          	auipc	a0,0x23b
    80006ad8:	6bc50513          	addi	a0,a0,1724 # 80242190 <disk+0x128>
    80006adc:	ffffa097          	auipc	ra,0xffffa
    80006ae0:	360080e7          	jalr	864(ra) # 80000e3c <release>
}
    80006ae4:	60e2                	ld	ra,24(sp)
    80006ae6:	6442                	ld	s0,16(sp)
    80006ae8:	64a2                	ld	s1,8(sp)
    80006aea:	6105                	addi	sp,sp,32
    80006aec:	8082                	ret
      panic("virtio_disk_intr status");
    80006aee:	00002517          	auipc	a0,0x2
    80006af2:	c7250513          	addi	a0,a0,-910 # 80008760 <etext+0x760>
    80006af6:	ffffa097          	auipc	ra,0xffffa
    80006afa:	a6a080e7          	jalr	-1430(ra) # 80000560 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
