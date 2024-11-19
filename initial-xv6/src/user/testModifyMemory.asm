
user/_testModifyMemory:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
#include "kernel/types.h"
#include "kernel/memlayout.h"
#include "user/user.h"

void simpletest() {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
  10:	00001517          	auipc	a0,0x1
  14:	8d050513          	addi	a0,a0,-1840 # 8e0 <malloc+0x10a>
  18:	00000097          	auipc	ra,0x0
  1c:	706080e7          	jalr	1798(ra) # 71e <printf>
  
  char *p = sbrk(sz);
  20:	05555537          	lui	a0,0x5555
  24:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x5554544>
  28:	00000097          	auipc	ra,0x0
  2c:	40e080e7          	jalr	1038(ra) # 436 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  30:	57fd                	li	a5,-1
  32:	06f50763          	beq	a0,a5,a0 <simpletest+0xa0>
  36:	8a2a                	mv	s4,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  // Initialize memory with parent's pid
  for(char *q = p; q < p + sz; q += 4096){
  38:	05556937          	lui	s2,0x5556
  3c:	992a                	add	s2,s2,a0
  3e:	84aa                	mv	s1,a0
  40:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  42:	00000097          	auipc	ra,0x0
  46:	3ec080e7          	jalr	1004(ra) # 42e <getpid>
  4a:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  4c:	94ce                	add	s1,s1,s3
  4e:	ff249ae3          	bne	s1,s2,42 <simpletest+0x42>
  }

  int pid = fork();
  52:	00000097          	auipc	ra,0x0
  56:	354080e7          	jalr	852(ra) # 3a6 <fork>
  if(pid < 0){
  5a:	06054463          	bltz	a0,c2 <simpletest+0xc2>
    printf("fork() failed\n");
    exit(-1);
  }

  // Modify memory
  if(pid == 0) {
  5e:	cd3d                	beqz	a0,dc <simpletest+0xdc>
    (*p) = 69;
    exit(0);
  }

  wait(0);
  60:	4501                	li	a0,0
  62:	00000097          	auipc	ra,0x0
  66:	354080e7          	jalr	852(ra) # 3b6 <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  6a:	faaab537          	lui	a0,0xfaaab
  6e:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa9a9c>
  72:	00000097          	auipc	ra,0x0
  76:	3c4080e7          	jalr	964(ra) # 436 <sbrk>
  7a:	57fd                	li	a5,-1
  7c:	06f50863          	beq	a0,a5,ec <simpletest+0xec>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  80:	00001517          	auipc	a0,0x1
  84:	8b050513          	addi	a0,a0,-1872 # 930 <malloc+0x15a>
  88:	00000097          	auipc	ra,0x0
  8c:	696080e7          	jalr	1686(ra) # 71e <printf>
}
  90:	70a2                	ld	ra,40(sp)
  92:	7402                	ld	s0,32(sp)
  94:	64e2                	ld	s1,24(sp)
  96:	6942                	ld	s2,16(sp)
  98:	69a2                	ld	s3,8(sp)
  9a:	6a02                	ld	s4,0(sp)
  9c:	6145                	addi	sp,sp,48
  9e:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  a0:	055555b7          	lui	a1,0x5555
  a4:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5554544>
  a8:	00001517          	auipc	a0,0x1
  ac:	84850513          	addi	a0,a0,-1976 # 8f0 <malloc+0x11a>
  b0:	00000097          	auipc	ra,0x0
  b4:	66e080e7          	jalr	1646(ra) # 71e <printf>
    exit(-1);
  b8:	557d                	li	a0,-1
  ba:	00000097          	auipc	ra,0x0
  be:	2f4080e7          	jalr	756(ra) # 3ae <exit>
    printf("fork() failed\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	84650513          	addi	a0,a0,-1978 # 908 <malloc+0x132>
  ca:	00000097          	auipc	ra,0x0
  ce:	654080e7          	jalr	1620(ra) # 71e <printf>
    exit(-1);
  d2:	557d                	li	a0,-1
  d4:	00000097          	auipc	ra,0x0
  d8:	2da080e7          	jalr	730(ra) # 3ae <exit>
    (*p) = 69;
  dc:	04500793          	li	a5,69
  e0:	00fa0023          	sb	a5,0(s4)
    exit(0);
  e4:	00000097          	auipc	ra,0x0
  e8:	2ca080e7          	jalr	714(ra) # 3ae <exit>
    printf("sbrk(-%d) failed\n", sz);
  ec:	055555b7          	lui	a1,0x5555
  f0:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5554544>
  f4:	00001517          	auipc	a0,0x1
  f8:	82450513          	addi	a0,a0,-2012 # 918 <malloc+0x142>
  fc:	00000097          	auipc	ra,0x0
 100:	622080e7          	jalr	1570(ra) # 71e <printf>
    exit(-1);
 104:	557d                	li	a0,-1
 106:	00000097          	auipc	ra,0x0
 10a:	2a8080e7          	jalr	680(ra) # 3ae <exit>

000000000000010e <main>:

int main(void) {
 10e:	1141                	addi	sp,sp,-16
 110:	e406                	sd	ra,8(sp)
 112:	e022                	sd	s0,0(sp)
 114:	0800                	addi	s0,sp,16
  simpletest();
 116:	00000097          	auipc	ra,0x0
 11a:	eea080e7          	jalr	-278(ra) # 0 <simpletest>
  return 0;
 11e:	4501                	li	a0,0
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 130:	00000097          	auipc	ra,0x0
 134:	fde080e7          	jalr	-34(ra) # 10e <main>
  exit(0);
 138:	4501                	li	a0,0
 13a:	00000097          	auipc	ra,0x0
 13e:	274080e7          	jalr	628(ra) # 3ae <exit>

0000000000000142 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 148:	87aa                	mv	a5,a0
 14a:	0585                	addi	a1,a1,1
 14c:	0785                	addi	a5,a5,1
 14e:	fff5c703          	lbu	a4,-1(a1)
 152:	fee78fa3          	sb	a4,-1(a5)
 156:	fb75                	bnez	a4,14a <strcpy+0x8>
    ;
  return os;
}
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret

000000000000015e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 164:	00054783          	lbu	a5,0(a0)
 168:	cb91                	beqz	a5,17c <strcmp+0x1e>
 16a:	0005c703          	lbu	a4,0(a1)
 16e:	00f71763          	bne	a4,a5,17c <strcmp+0x1e>
    p++, q++;
 172:	0505                	addi	a0,a0,1
 174:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 176:	00054783          	lbu	a5,0(a0)
 17a:	fbe5                	bnez	a5,16a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 17c:	0005c503          	lbu	a0,0(a1)
}
 180:	40a7853b          	subw	a0,a5,a0
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strlen>:

uint
strlen(const char *s)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 190:	00054783          	lbu	a5,0(a0)
 194:	cf91                	beqz	a5,1b0 <strlen+0x26>
 196:	0505                	addi	a0,a0,1
 198:	87aa                	mv	a5,a0
 19a:	86be                	mv	a3,a5
 19c:	0785                	addi	a5,a5,1
 19e:	fff7c703          	lbu	a4,-1(a5)
 1a2:	ff65                	bnez	a4,19a <strlen+0x10>
 1a4:	40a6853b          	subw	a0,a3,a0
 1a8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
  for(n = 0; s[n]; n++)
 1b0:	4501                	li	a0,0
 1b2:	bfe5                	j	1aa <strlen+0x20>

00000000000001b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e422                	sd	s0,8(sp)
 1b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ba:	ca19                	beqz	a2,1d0 <memset+0x1c>
 1bc:	87aa                	mv	a5,a0
 1be:	1602                	slli	a2,a2,0x20
 1c0:	9201                	srli	a2,a2,0x20
 1c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ca:	0785                	addi	a5,a5,1
 1cc:	fee79de3          	bne	a5,a4,1c6 <memset+0x12>
  }
  return dst;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret

00000000000001d6 <strchr>:

char*
strchr(const char *s, char c)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	cb99                	beqz	a5,1f6 <strchr+0x20>
    if(*s == c)
 1e2:	00f58763          	beq	a1,a5,1f0 <strchr+0x1a>
  for(; *s; s++)
 1e6:	0505                	addi	a0,a0,1
 1e8:	00054783          	lbu	a5,0(a0)
 1ec:	fbfd                	bnez	a5,1e2 <strchr+0xc>
      return (char*)s;
  return 0;
 1ee:	4501                	li	a0,0
}
 1f0:	6422                	ld	s0,8(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret
  return 0;
 1f6:	4501                	li	a0,0
 1f8:	bfe5                	j	1f0 <strchr+0x1a>

00000000000001fa <gets>:

char*
gets(char *buf, int max)
{
 1fa:	711d                	addi	sp,sp,-96
 1fc:	ec86                	sd	ra,88(sp)
 1fe:	e8a2                	sd	s0,80(sp)
 200:	e4a6                	sd	s1,72(sp)
 202:	e0ca                	sd	s2,64(sp)
 204:	fc4e                	sd	s3,56(sp)
 206:	f852                	sd	s4,48(sp)
 208:	f456                	sd	s5,40(sp)
 20a:	f05a                	sd	s6,32(sp)
 20c:	ec5e                	sd	s7,24(sp)
 20e:	1080                	addi	s0,sp,96
 210:	8baa                	mv	s7,a0
 212:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 214:	892a                	mv	s2,a0
 216:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 218:	4aa9                	li	s5,10
 21a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 21c:	89a6                	mv	s3,s1
 21e:	2485                	addiw	s1,s1,1
 220:	0344d863          	bge	s1,s4,250 <gets+0x56>
    cc = read(0, &c, 1);
 224:	4605                	li	a2,1
 226:	faf40593          	addi	a1,s0,-81
 22a:	4501                	li	a0,0
 22c:	00000097          	auipc	ra,0x0
 230:	19a080e7          	jalr	410(ra) # 3c6 <read>
    if(cc < 1)
 234:	00a05e63          	blez	a0,250 <gets+0x56>
    buf[i++] = c;
 238:	faf44783          	lbu	a5,-81(s0)
 23c:	00f90023          	sb	a5,0(s2) # 5556000 <base+0x5554ff0>
    if(c == '\n' || c == '\r')
 240:	01578763          	beq	a5,s5,24e <gets+0x54>
 244:	0905                	addi	s2,s2,1
 246:	fd679be3          	bne	a5,s6,21c <gets+0x22>
    buf[i++] = c;
 24a:	89a6                	mv	s3,s1
 24c:	a011                	j	250 <gets+0x56>
 24e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 250:	99de                	add	s3,s3,s7
 252:	00098023          	sb	zero,0(s3) # 1000 <freep>
  return buf;
}
 256:	855e                	mv	a0,s7
 258:	60e6                	ld	ra,88(sp)
 25a:	6446                	ld	s0,80(sp)
 25c:	64a6                	ld	s1,72(sp)
 25e:	6906                	ld	s2,64(sp)
 260:	79e2                	ld	s3,56(sp)
 262:	7a42                	ld	s4,48(sp)
 264:	7aa2                	ld	s5,40(sp)
 266:	7b02                	ld	s6,32(sp)
 268:	6be2                	ld	s7,24(sp)
 26a:	6125                	addi	sp,sp,96
 26c:	8082                	ret

000000000000026e <stat>:

int
stat(const char *n, struct stat *st)
{
 26e:	1101                	addi	sp,sp,-32
 270:	ec06                	sd	ra,24(sp)
 272:	e822                	sd	s0,16(sp)
 274:	e04a                	sd	s2,0(sp)
 276:	1000                	addi	s0,sp,32
 278:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27a:	4581                	li	a1,0
 27c:	00000097          	auipc	ra,0x0
 280:	172080e7          	jalr	370(ra) # 3ee <open>
  if(fd < 0)
 284:	02054663          	bltz	a0,2b0 <stat+0x42>
 288:	e426                	sd	s1,8(sp)
 28a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 28c:	85ca                	mv	a1,s2
 28e:	00000097          	auipc	ra,0x0
 292:	178080e7          	jalr	376(ra) # 406 <fstat>
 296:	892a                	mv	s2,a0
  close(fd);
 298:	8526                	mv	a0,s1
 29a:	00000097          	auipc	ra,0x0
 29e:	13c080e7          	jalr	316(ra) # 3d6 <close>
  return r;
 2a2:	64a2                	ld	s1,8(sp)
}
 2a4:	854a                	mv	a0,s2
 2a6:	60e2                	ld	ra,24(sp)
 2a8:	6442                	ld	s0,16(sp)
 2aa:	6902                	ld	s2,0(sp)
 2ac:	6105                	addi	sp,sp,32
 2ae:	8082                	ret
    return -1;
 2b0:	597d                	li	s2,-1
 2b2:	bfcd                	j	2a4 <stat+0x36>

00000000000002b4 <atoi>:

int
atoi(const char *s)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ba:	00054683          	lbu	a3,0(a0)
 2be:	fd06879b          	addiw	a5,a3,-48
 2c2:	0ff7f793          	zext.b	a5,a5
 2c6:	4625                	li	a2,9
 2c8:	02f66863          	bltu	a2,a5,2f8 <atoi+0x44>
 2cc:	872a                	mv	a4,a0
  n = 0;
 2ce:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2d0:	0705                	addi	a4,a4,1
 2d2:	0025179b          	slliw	a5,a0,0x2
 2d6:	9fa9                	addw	a5,a5,a0
 2d8:	0017979b          	slliw	a5,a5,0x1
 2dc:	9fb5                	addw	a5,a5,a3
 2de:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e2:	00074683          	lbu	a3,0(a4)
 2e6:	fd06879b          	addiw	a5,a3,-48
 2ea:	0ff7f793          	zext.b	a5,a5
 2ee:	fef671e3          	bgeu	a2,a5,2d0 <atoi+0x1c>
  return n;
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
  n = 0;
 2f8:	4501                	li	a0,0
 2fa:	bfe5                	j	2f2 <atoi+0x3e>

00000000000002fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e422                	sd	s0,8(sp)
 300:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 302:	02b57463          	bgeu	a0,a1,32a <memmove+0x2e>
    while(n-- > 0)
 306:	00c05f63          	blez	a2,324 <memmove+0x28>
 30a:	1602                	slli	a2,a2,0x20
 30c:	9201                	srli	a2,a2,0x20
 30e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 312:	872a                	mv	a4,a0
      *dst++ = *src++;
 314:	0585                	addi	a1,a1,1
 316:	0705                	addi	a4,a4,1
 318:	fff5c683          	lbu	a3,-1(a1)
 31c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 320:	fef71ae3          	bne	a4,a5,314 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
    dst += n;
 32a:	00c50733          	add	a4,a0,a2
    src += n;
 32e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 330:	fec05ae3          	blez	a2,324 <memmove+0x28>
 334:	fff6079b          	addiw	a5,a2,-1
 338:	1782                	slli	a5,a5,0x20
 33a:	9381                	srli	a5,a5,0x20
 33c:	fff7c793          	not	a5,a5
 340:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 342:	15fd                	addi	a1,a1,-1
 344:	177d                	addi	a4,a4,-1
 346:	0005c683          	lbu	a3,0(a1)
 34a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 34e:	fee79ae3          	bne	a5,a4,342 <memmove+0x46>
 352:	bfc9                	j	324 <memmove+0x28>

0000000000000354 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e422                	sd	s0,8(sp)
 358:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 35a:	ca05                	beqz	a2,38a <memcmp+0x36>
 35c:	fff6069b          	addiw	a3,a2,-1
 360:	1682                	slli	a3,a3,0x20
 362:	9281                	srli	a3,a3,0x20
 364:	0685                	addi	a3,a3,1
 366:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 368:	00054783          	lbu	a5,0(a0)
 36c:	0005c703          	lbu	a4,0(a1)
 370:	00e79863          	bne	a5,a4,380 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 374:	0505                	addi	a0,a0,1
    p2++;
 376:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 378:	fed518e3          	bne	a0,a3,368 <memcmp+0x14>
  }
  return 0;
 37c:	4501                	li	a0,0
 37e:	a019                	j	384 <memcmp+0x30>
      return *p1 - *p2;
 380:	40e7853b          	subw	a0,a5,a4
}
 384:	6422                	ld	s0,8(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret
  return 0;
 38a:	4501                	li	a0,0
 38c:	bfe5                	j	384 <memcmp+0x30>

000000000000038e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 38e:	1141                	addi	sp,sp,-16
 390:	e406                	sd	ra,8(sp)
 392:	e022                	sd	s0,0(sp)
 394:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 396:	00000097          	auipc	ra,0x0
 39a:	f66080e7          	jalr	-154(ra) # 2fc <memmove>
}
 39e:	60a2                	ld	ra,8(sp)
 3a0:	6402                	ld	s0,0(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret

00000000000003a6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a6:	4885                	li	a7,1
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ae:	4889                	li	a7,2
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b6:	488d                	li	a7,3
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3be:	4891                	li	a7,4
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <read>:
.global read
read:
 li a7, SYS_read
 3c6:	4895                	li	a7,5
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <write>:
.global write
write:
 li a7, SYS_write
 3ce:	48c1                	li	a7,16
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <close>:
.global close
close:
 li a7, SYS_close
 3d6:	48d5                	li	a7,21
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <kill>:
.global kill
kill:
 li a7, SYS_kill
 3de:	4899                	li	a7,6
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e6:	489d                	li	a7,7
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <open>:
.global open
open:
 li a7, SYS_open
 3ee:	48bd                	li	a7,15
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f6:	48c5                	li	a7,17
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fe:	48c9                	li	a7,18
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 406:	48a1                	li	a7,8
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <link>:
.global link
link:
 li a7, SYS_link
 40e:	48cd                	li	a7,19
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 416:	48d1                	li	a7,20
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41e:	48a5                	li	a7,9
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <dup>:
.global dup
dup:
 li a7, SYS_dup
 426:	48a9                	li	a7,10
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42e:	48ad                	li	a7,11
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 436:	48b1                	li	a7,12
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43e:	48b5                	li	a7,13
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 446:	48b9                	li	a7,14
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 44e:	48d9                	li	a7,22
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 456:	1101                	addi	sp,sp,-32
 458:	ec06                	sd	ra,24(sp)
 45a:	e822                	sd	s0,16(sp)
 45c:	1000                	addi	s0,sp,32
 45e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 462:	4605                	li	a2,1
 464:	fef40593          	addi	a1,s0,-17
 468:	00000097          	auipc	ra,0x0
 46c:	f66080e7          	jalr	-154(ra) # 3ce <write>
}
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	6105                	addi	sp,sp,32
 476:	8082                	ret

0000000000000478 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 478:	7139                	addi	sp,sp,-64
 47a:	fc06                	sd	ra,56(sp)
 47c:	f822                	sd	s0,48(sp)
 47e:	f426                	sd	s1,40(sp)
 480:	0080                	addi	s0,sp,64
 482:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 484:	c299                	beqz	a3,48a <printint+0x12>
 486:	0805cb63          	bltz	a1,51c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48a:	2581                	sext.w	a1,a1
  neg = 0;
 48c:	4881                	li	a7,0
 48e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 492:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 494:	2601                	sext.w	a2,a2
 496:	00000517          	auipc	a0,0x0
 49a:	50250513          	addi	a0,a0,1282 # 998 <digits>
 49e:	883a                	mv	a6,a4
 4a0:	2705                	addiw	a4,a4,1
 4a2:	02c5f7bb          	remuw	a5,a1,a2
 4a6:	1782                	slli	a5,a5,0x20
 4a8:	9381                	srli	a5,a5,0x20
 4aa:	97aa                	add	a5,a5,a0
 4ac:	0007c783          	lbu	a5,0(a5)
 4b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b4:	0005879b          	sext.w	a5,a1
 4b8:	02c5d5bb          	divuw	a1,a1,a2
 4bc:	0685                	addi	a3,a3,1
 4be:	fec7f0e3          	bgeu	a5,a2,49e <printint+0x26>
  if(neg)
 4c2:	00088c63          	beqz	a7,4da <printint+0x62>
    buf[i++] = '-';
 4c6:	fd070793          	addi	a5,a4,-48
 4ca:	00878733          	add	a4,a5,s0
 4ce:	02d00793          	li	a5,45
 4d2:	fef70823          	sb	a5,-16(a4)
 4d6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4da:	02e05c63          	blez	a4,512 <printint+0x9a>
 4de:	f04a                	sd	s2,32(sp)
 4e0:	ec4e                	sd	s3,24(sp)
 4e2:	fc040793          	addi	a5,s0,-64
 4e6:	00e78933          	add	s2,a5,a4
 4ea:	fff78993          	addi	s3,a5,-1
 4ee:	99ba                	add	s3,s3,a4
 4f0:	377d                	addiw	a4,a4,-1
 4f2:	1702                	slli	a4,a4,0x20
 4f4:	9301                	srli	a4,a4,0x20
 4f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fa:	fff94583          	lbu	a1,-1(s2)
 4fe:	8526                	mv	a0,s1
 500:	00000097          	auipc	ra,0x0
 504:	f56080e7          	jalr	-170(ra) # 456 <putc>
  while(--i >= 0)
 508:	197d                	addi	s2,s2,-1
 50a:	ff3918e3          	bne	s2,s3,4fa <printint+0x82>
 50e:	7902                	ld	s2,32(sp)
 510:	69e2                	ld	s3,24(sp)
}
 512:	70e2                	ld	ra,56(sp)
 514:	7442                	ld	s0,48(sp)
 516:	74a2                	ld	s1,40(sp)
 518:	6121                	addi	sp,sp,64
 51a:	8082                	ret
    x = -xx;
 51c:	40b005bb          	negw	a1,a1
    neg = 1;
 520:	4885                	li	a7,1
    x = -xx;
 522:	b7b5                	j	48e <printint+0x16>

0000000000000524 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 524:	715d                	addi	sp,sp,-80
 526:	e486                	sd	ra,72(sp)
 528:	e0a2                	sd	s0,64(sp)
 52a:	f84a                	sd	s2,48(sp)
 52c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52e:	0005c903          	lbu	s2,0(a1)
 532:	1a090a63          	beqz	s2,6e6 <vprintf+0x1c2>
 536:	fc26                	sd	s1,56(sp)
 538:	f44e                	sd	s3,40(sp)
 53a:	f052                	sd	s4,32(sp)
 53c:	ec56                	sd	s5,24(sp)
 53e:	e85a                	sd	s6,16(sp)
 540:	e45e                	sd	s7,8(sp)
 542:	8aaa                	mv	s5,a0
 544:	8bb2                	mv	s7,a2
 546:	00158493          	addi	s1,a1,1
  state = 0;
 54a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 54c:	02500a13          	li	s4,37
 550:	4b55                	li	s6,21
 552:	a839                	j	570 <vprintf+0x4c>
        putc(fd, c);
 554:	85ca                	mv	a1,s2
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	efe080e7          	jalr	-258(ra) # 456 <putc>
 560:	a019                	j	566 <vprintf+0x42>
    } else if(state == '%'){
 562:	01498d63          	beq	s3,s4,57c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 566:	0485                	addi	s1,s1,1
 568:	fff4c903          	lbu	s2,-1(s1)
 56c:	16090763          	beqz	s2,6da <vprintf+0x1b6>
    if(state == 0){
 570:	fe0999e3          	bnez	s3,562 <vprintf+0x3e>
      if(c == '%'){
 574:	ff4910e3          	bne	s2,s4,554 <vprintf+0x30>
        state = '%';
 578:	89d2                	mv	s3,s4
 57a:	b7f5                	j	566 <vprintf+0x42>
      if(c == 'd'){
 57c:	13490463          	beq	s2,s4,6a4 <vprintf+0x180>
 580:	f9d9079b          	addiw	a5,s2,-99
 584:	0ff7f793          	zext.b	a5,a5
 588:	12fb6763          	bltu	s6,a5,6b6 <vprintf+0x192>
 58c:	f9d9079b          	addiw	a5,s2,-99
 590:	0ff7f713          	zext.b	a4,a5
 594:	12eb6163          	bltu	s6,a4,6b6 <vprintf+0x192>
 598:	00271793          	slli	a5,a4,0x2
 59c:	00000717          	auipc	a4,0x0
 5a0:	3a470713          	addi	a4,a4,932 # 940 <malloc+0x16a>
 5a4:	97ba                	add	a5,a5,a4
 5a6:	439c                	lw	a5,0(a5)
 5a8:	97ba                	add	a5,a5,a4
 5aa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4685                	li	a3,1
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	ebe080e7          	jalr	-322(ra) # 478 <printint>
 5c2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b745                	j	566 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	ea2080e7          	jalr	-350(ra) # 478 <printint>
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b751                	j	566 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4641                	li	a2,16
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e86080e7          	jalr	-378(ra) # 478 <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b7a5                	j	566 <vprintf+0x42>
 600:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 602:	008b8c13          	addi	s8,s7,8
 606:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 60a:	03000593          	li	a1,48
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e46080e7          	jalr	-442(ra) # 456 <putc>
  putc(fd, 'x');
 618:	07800593          	li	a1,120
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	e38080e7          	jalr	-456(ra) # 456 <putc>
 626:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 628:	00000b97          	auipc	s7,0x0
 62c:	370b8b93          	addi	s7,s7,880 # 998 <digits>
 630:	03c9d793          	srli	a5,s3,0x3c
 634:	97de                	add	a5,a5,s7
 636:	0007c583          	lbu	a1,0(a5)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e1a080e7          	jalr	-486(ra) # 456 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 644:	0992                	slli	s3,s3,0x4
 646:	397d                	addiw	s2,s2,-1
 648:	fe0914e3          	bnez	s2,630 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 64c:	8be2                	mv	s7,s8
      state = 0;
 64e:	4981                	li	s3,0
 650:	6c02                	ld	s8,0(sp)
 652:	bf11                	j	566 <vprintf+0x42>
        s = va_arg(ap, char*);
 654:	008b8993          	addi	s3,s7,8
 658:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 65c:	02090163          	beqz	s2,67e <vprintf+0x15a>
        while(*s != 0){
 660:	00094583          	lbu	a1,0(s2)
 664:	c9a5                	beqz	a1,6d4 <vprintf+0x1b0>
          putc(fd, *s);
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	dee080e7          	jalr	-530(ra) # 456 <putc>
          s++;
 670:	0905                	addi	s2,s2,1
        while(*s != 0){
 672:	00094583          	lbu	a1,0(s2)
 676:	f9e5                	bnez	a1,666 <vprintf+0x142>
        s = va_arg(ap, char*);
 678:	8bce                	mv	s7,s3
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b5ed                	j	566 <vprintf+0x42>
          s = "(null)";
 67e:	00000917          	auipc	s2,0x0
 682:	2ba90913          	addi	s2,s2,698 # 938 <malloc+0x162>
        while(*s != 0){
 686:	02800593          	li	a1,40
 68a:	bff1                	j	666 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 68c:	008b8913          	addi	s2,s7,8
 690:	000bc583          	lbu	a1,0(s7)
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	dc0080e7          	jalr	-576(ra) # 456 <putc>
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b5d1                	j	566 <vprintf+0x42>
        putc(fd, c);
 6a4:	02500593          	li	a1,37
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	dac080e7          	jalr	-596(ra) # 456 <putc>
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bd4d                	j	566 <vprintf+0x42>
        putc(fd, '%');
 6b6:	02500593          	li	a1,37
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	d9a080e7          	jalr	-614(ra) # 456 <putc>
        putc(fd, c);
 6c4:	85ca                	mv	a1,s2
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	d8e080e7          	jalr	-626(ra) # 456 <putc>
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bd51                	j	566 <vprintf+0x42>
        s = va_arg(ap, char*);
 6d4:	8bce                	mv	s7,s3
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b579                	j	566 <vprintf+0x42>
 6da:	74e2                	ld	s1,56(sp)
 6dc:	79a2                	ld	s3,40(sp)
 6de:	7a02                	ld	s4,32(sp)
 6e0:	6ae2                	ld	s5,24(sp)
 6e2:	6b42                	ld	s6,16(sp)
 6e4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6e6:	60a6                	ld	ra,72(sp)
 6e8:	6406                	ld	s0,64(sp)
 6ea:	7942                	ld	s2,48(sp)
 6ec:	6161                	addi	sp,sp,80
 6ee:	8082                	ret

00000000000006f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f0:	715d                	addi	sp,sp,-80
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	addi	s0,sp,32
 6f8:	e010                	sd	a2,0(s0)
 6fa:	e414                	sd	a3,8(s0)
 6fc:	e818                	sd	a4,16(s0)
 6fe:	ec1c                	sd	a5,24(s0)
 700:	03043023          	sd	a6,32(s0)
 704:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 708:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70c:	8622                	mv	a2,s0
 70e:	00000097          	auipc	ra,0x0
 712:	e16080e7          	jalr	-490(ra) # 524 <vprintf>
}
 716:	60e2                	ld	ra,24(sp)
 718:	6442                	ld	s0,16(sp)
 71a:	6161                	addi	sp,sp,80
 71c:	8082                	ret

000000000000071e <printf>:

void
printf(const char *fmt, ...)
{
 71e:	711d                	addi	sp,sp,-96
 720:	ec06                	sd	ra,24(sp)
 722:	e822                	sd	s0,16(sp)
 724:	1000                	addi	s0,sp,32
 726:	e40c                	sd	a1,8(s0)
 728:	e810                	sd	a2,16(s0)
 72a:	ec14                	sd	a3,24(s0)
 72c:	f018                	sd	a4,32(s0)
 72e:	f41c                	sd	a5,40(s0)
 730:	03043823          	sd	a6,48(s0)
 734:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	00840613          	addi	a2,s0,8
 73c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 740:	85aa                	mv	a1,a0
 742:	4505                	li	a0,1
 744:	00000097          	auipc	ra,0x0
 748:	de0080e7          	jalr	-544(ra) # 524 <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6125                	addi	sp,sp,96
 752:	8082                	ret

0000000000000754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 754:	1141                	addi	sp,sp,-16
 756:	e422                	sd	s0,8(sp)
 758:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	00001797          	auipc	a5,0x1
 762:	8a27b783          	ld	a5,-1886(a5) # 1000 <freep>
 766:	a02d                	j	790 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 768:	4618                	lw	a4,8(a2)
 76a:	9f2d                	addw	a4,a4,a1
 76c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	6398                	ld	a4,0(a5)
 772:	6310                	ld	a2,0(a4)
 774:	a83d                	j	7b2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 776:	ff852703          	lw	a4,-8(a0)
 77a:	9f31                	addw	a4,a4,a2
 77c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 77e:	ff053683          	ld	a3,-16(a0)
 782:	a091                	j	7c6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	6398                	ld	a4,0(a5)
 786:	00e7e463          	bltu	a5,a4,78e <free+0x3a>
 78a:	00e6ea63          	bltu	a3,a4,79e <free+0x4a>
{
 78e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	fed7fae3          	bgeu	a5,a3,784 <free+0x30>
 794:	6398                	ld	a4,0(a5)
 796:	00e6e463          	bltu	a3,a4,79e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	fee7eae3          	bltu	a5,a4,78e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 79e:	ff852583          	lw	a1,-8(a0)
 7a2:	6390                	ld	a2,0(a5)
 7a4:	02059813          	slli	a6,a1,0x20
 7a8:	01c85713          	srli	a4,a6,0x1c
 7ac:	9736                	add	a4,a4,a3
 7ae:	fae60de3          	beq	a2,a4,768 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b6:	4790                	lw	a2,8(a5)
 7b8:	02061593          	slli	a1,a2,0x20
 7bc:	01c5d713          	srli	a4,a1,0x1c
 7c0:	973e                	add	a4,a4,a5
 7c2:	fae68ae3          	beq	a3,a4,776 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c8:	00001717          	auipc	a4,0x1
 7cc:	82f73c23          	sd	a5,-1992(a4) # 1000 <freep>
}
 7d0:	6422                	ld	s0,8(sp)
 7d2:	0141                	addi	sp,sp,16
 7d4:	8082                	ret

00000000000007d6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d6:	7139                	addi	sp,sp,-64
 7d8:	fc06                	sd	ra,56(sp)
 7da:	f822                	sd	s0,48(sp)
 7dc:	f426                	sd	s1,40(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e2:	02051493          	slli	s1,a0,0x20
 7e6:	9081                	srli	s1,s1,0x20
 7e8:	04bd                	addi	s1,s1,15
 7ea:	8091                	srli	s1,s1,0x4
 7ec:	0014899b          	addiw	s3,s1,1
 7f0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7f2:	00001517          	auipc	a0,0x1
 7f6:	80e53503          	ld	a0,-2034(a0) # 1000 <freep>
 7fa:	c915                	beqz	a0,82e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fe:	4798                	lw	a4,8(a5)
 800:	08977e63          	bgeu	a4,s1,89c <malloc+0xc6>
 804:	f04a                	sd	s2,32(sp)
 806:	e852                	sd	s4,16(sp)
 808:	e456                	sd	s5,8(sp)
 80a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 80c:	8a4e                	mv	s4,s3
 80e:	0009871b          	sext.w	a4,s3
 812:	6685                	lui	a3,0x1
 814:	00d77363          	bgeu	a4,a3,81a <malloc+0x44>
 818:	6a05                	lui	s4,0x1
 81a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 822:	00000917          	auipc	s2,0x0
 826:	7de90913          	addi	s2,s2,2014 # 1000 <freep>
  if(p == (char*)-1)
 82a:	5afd                	li	s5,-1
 82c:	a091                	j	870 <malloc+0x9a>
 82e:	f04a                	sd	s2,32(sp)
 830:	e852                	sd	s4,16(sp)
 832:	e456                	sd	s5,8(sp)
 834:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 836:	00000797          	auipc	a5,0x0
 83a:	7da78793          	addi	a5,a5,2010 # 1010 <base>
 83e:	00000717          	auipc	a4,0x0
 842:	7cf73123          	sd	a5,1986(a4) # 1000 <freep>
 846:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 848:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84c:	b7c1                	j	80c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 84e:	6398                	ld	a4,0(a5)
 850:	e118                	sd	a4,0(a0)
 852:	a08d                	j	8b4 <malloc+0xde>
  hp->s.size = nu;
 854:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 858:	0541                	addi	a0,a0,16
 85a:	00000097          	auipc	ra,0x0
 85e:	efa080e7          	jalr	-262(ra) # 754 <free>
  return freep;
 862:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 866:	c13d                	beqz	a0,8cc <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86a:	4798                	lw	a4,8(a5)
 86c:	02977463          	bgeu	a4,s1,894 <malloc+0xbe>
    if(p == freep)
 870:	00093703          	ld	a4,0(s2)
 874:	853e                	mv	a0,a5
 876:	fef719e3          	bne	a4,a5,868 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 87a:	8552                	mv	a0,s4
 87c:	00000097          	auipc	ra,0x0
 880:	bba080e7          	jalr	-1094(ra) # 436 <sbrk>
  if(p == (char*)-1)
 884:	fd5518e3          	bne	a0,s5,854 <malloc+0x7e>
        return 0;
 888:	4501                	li	a0,0
 88a:	7902                	ld	s2,32(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	a03d                	j	8c0 <malloc+0xea>
 894:	7902                	ld	s2,32(sp)
 896:	6a42                	ld	s4,16(sp)
 898:	6aa2                	ld	s5,8(sp)
 89a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 89c:	fae489e3          	beq	s1,a4,84e <malloc+0x78>
        p->s.size -= nunits;
 8a0:	4137073b          	subw	a4,a4,s3
 8a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a6:	02071693          	slli	a3,a4,0x20
 8aa:	01c6d713          	srli	a4,a3,0x1c
 8ae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74a73623          	sd	a0,1868(a4) # 1000 <freep>
      return (void*)(p + 1);
 8bc:	01078513          	addi	a0,a5,16
  }
}
 8c0:	70e2                	ld	ra,56(sp)
 8c2:	7442                	ld	s0,48(sp)
 8c4:	74a2                	ld	s1,40(sp)
 8c6:	69e2                	ld	s3,24(sp)
 8c8:	6121                	addi	sp,sp,64
 8ca:	8082                	ret
 8cc:	7902                	ld	s2,32(sp)
 8ce:	6a42                	ld	s4,16(sp)
 8d0:	6aa2                	ld	s5,8(sp)
 8d2:	6b02                	ld	s6,0(sp)
 8d4:	b7f5                	j	8c0 <malloc+0xea>
