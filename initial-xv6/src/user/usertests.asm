
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c90080e7          	jalr	-880(ra) # 5ca0 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c7e080e7          	jalr	-898(ra) # 5ca0 <open>
    if(fd >= 0){
      2a:	55fd                	li	a1,-1
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	15250513          	addi	a0,a0,338 # 6190 <malloc+0x108>
      46:	00006097          	auipc	ra,0x6
      4a:	f8a080e7          	jalr	-118(ra) # 5fd0 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	c10080e7          	jalr	-1008(ra) # 5c60 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	13050513          	addi	a0,a0,304 # 61b0 <malloc+0x128>
      88:	00006097          	auipc	ra,0x6
      8c:	f48080e7          	jalr	-184(ra) # 5fd0 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	bce080e7          	jalr	-1074(ra) # 5c60 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	12050513          	addi	a0,a0,288 # 61c8 <malloc+0x140>
      b0:	00006097          	auipc	ra,0x6
      b4:	bf0080e7          	jalr	-1040(ra) # 5ca0 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	bcc080e7          	jalr	-1076(ra) # 5c88 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	12250513          	addi	a0,a0,290 # 61e8 <malloc+0x160>
      ce:	00006097          	auipc	ra,0x6
      d2:	bd2080e7          	jalr	-1070(ra) # 5ca0 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	0ea50513          	addi	a0,a0,234 # 61d0 <malloc+0x148>
      ee:	00006097          	auipc	ra,0x6
      f2:	ee2080e7          	jalr	-286(ra) # 5fd0 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	b68080e7          	jalr	-1176(ra) # 5c60 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	0f650513          	addi	a0,a0,246 # 61f8 <malloc+0x170>
     10a:	00006097          	auipc	ra,0x6
     10e:	ec6080e7          	jalr	-314(ra) # 5fd0 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	b4c080e7          	jalr	-1204(ra) # 5c60 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	0f450513          	addi	a0,a0,244 # 6220 <malloc+0x198>
     134:	00006097          	auipc	ra,0x6
     138:	b7c080e7          	jalr	-1156(ra) # 5cb0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	0e050513          	addi	a0,a0,224 # 6220 <malloc+0x198>
     148:	00006097          	auipc	ra,0x6
     14c:	b58080e7          	jalr	-1192(ra) # 5ca0 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	0dc58593          	addi	a1,a1,220 # 6230 <malloc+0x1a8>
     15c:	00006097          	auipc	ra,0x6
     160:	b24080e7          	jalr	-1244(ra) # 5c80 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	0b850513          	addi	a0,a0,184 # 6220 <malloc+0x198>
     170:	00006097          	auipc	ra,0x6
     174:	b30080e7          	jalr	-1232(ra) # 5ca0 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	0bc58593          	addi	a1,a1,188 # 6238 <malloc+0x1b0>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	afa080e7          	jalr	-1286(ra) # 5c80 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	08c50513          	addi	a0,a0,140 # 6220 <malloc+0x198>
     19c:	00006097          	auipc	ra,0x6
     1a0:	b14080e7          	jalr	-1260(ra) # 5cb0 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	ae2080e7          	jalr	-1310(ra) # 5c88 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	ad8080e7          	jalr	-1320(ra) # 5c88 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	07650513          	addi	a0,a0,118 # 6240 <malloc+0x1b8>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	dfe080e7          	jalr	-514(ra) # 5fd0 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a84080e7          	jalr	-1404(ra) # 5c60 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a90080e7          	jalr	-1392(ra) # 5ca0 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	a70080e7          	jalr	-1424(ra) # 5c88 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	a6a080e7          	jalr	-1430(ra) # 5cb0 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	fec50513          	addi	a0,a0,-20 # 6268 <malloc+0x1e0>
     284:	00006097          	auipc	ra,0x6
     288:	a2c080e7          	jalr	-1492(ra) # 5cb0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	fd8a8a93          	addi	s5,s5,-40 # 6268 <malloc+0x1e0>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0xf3>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	9f4080e7          	jalr	-1548(ra) # 5ca0 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	9c2080e7          	jalr	-1598(ra) # 5c80 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	9ae080e7          	jalr	-1618(ra) # 5c80 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	9a8080e7          	jalr	-1624(ra) # 5c88 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	9c6080e7          	jalr	-1594(ra) # 5cb0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f6650513          	addi	a0,a0,-154 # 6278 <malloc+0x1f0>
     31a:	00006097          	auipc	ra,0x6
     31e:	cb6080e7          	jalr	-842(ra) # 5fd0 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	93c080e7          	jalr	-1732(ra) # 5c60 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	f6450513          	addi	a0,a0,-156 # 6298 <malloc+0x210>
     33c:	00006097          	auipc	ra,0x6
     340:	c94080e7          	jalr	-876(ra) # 5fd0 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	91a080e7          	jalr	-1766(ra) # 5c60 <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	f5250513          	addi	a0,a0,-174 # 62b0 <malloc+0x228>
     366:	00006097          	auipc	ra,0x6
     36a:	94a080e7          	jalr	-1718(ra) # 5cb0 <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	f3e98993          	addi	s3,s3,-194 # 62b0 <malloc+0x228>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	91a080e7          	jalr	-1766(ra) # 5ca0 <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	8e8080e7          	jalr	-1816(ra) # 5c80 <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	8e6080e7          	jalr	-1818(ra) # 5c88 <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	904080e7          	jalr	-1788(ra) # 5cb0 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	ef250513          	addi	a0,a0,-270 # 62b0 <malloc+0x228>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	8da080e7          	jalr	-1830(ra) # 5ca0 <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	e6258593          	addi	a1,a1,-414 # 6238 <malloc+0x1b0>
     3de:	00006097          	auipc	ra,0x6
     3e2:	8a2080e7          	jalr	-1886(ra) # 5c80 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	ee450513          	addi	a0,a0,-284 # 62d0 <malloc+0x248>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	bdc080e7          	jalr	-1060(ra) # 5fd0 <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00006097          	auipc	ra,0x6
     402:	862080e7          	jalr	-1950(ra) # 5c60 <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	eb250513          	addi	a0,a0,-334 # 62b8 <malloc+0x230>
     40e:	00006097          	auipc	ra,0x6
     412:	bc2080e7          	jalr	-1086(ra) # 5fd0 <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00006097          	auipc	ra,0x6
     41c:	848080e7          	jalr	-1976(ra) # 5c60 <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	e9850513          	addi	a0,a0,-360 # 62b8 <malloc+0x230>
     428:	00006097          	auipc	ra,0x6
     42c:	ba8080e7          	jalr	-1112(ra) # 5fd0 <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00006097          	auipc	ra,0x6
     436:	82e080e7          	jalr	-2002(ra) # 5c60 <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00006097          	auipc	ra,0x6
     440:	84c080e7          	jalr	-1972(ra) # 5c88 <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	e6c50513          	addi	a0,a0,-404 # 62b0 <malloc+0x228>
     44c:	00006097          	auipc	ra,0x6
     450:	864080e7          	jalr	-1948(ra) # 5cb0 <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00006097          	auipc	ra,0x6
     45a:	80a080e7          	jalr	-2038(ra) # 5c60 <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00006097          	auipc	ra,0x6
     4ae:	806080e7          	jalr	-2042(ra) # 5cb0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	7e6080e7          	jalr	2022(ra) # 5ca0 <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	7c2080e7          	jalr	1986(ra) # 5c88 <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	79e080e7          	jalr	1950(ra) # 5cb0 <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	d90a0a13          	addi	s4,s4,-624 # 62e0 <malloc+0x258>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	73e080e7          	jalr	1854(ra) # 5ca0 <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	70c080e7          	jalr	1804(ra) # 5c80 <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	706080e7          	jalr	1798(ra) # 5c88 <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	724080e7          	jalr	1828(ra) # 5cb0 <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	6e6080e7          	jalr	1766(ra) # 5c80 <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	6c6080e7          	jalr	1734(ra) # 5c70 <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	6c2080e7          	jalr	1730(ra) # 5c80 <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	6ba080e7          	jalr	1722(ra) # 5c88 <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	6ae080e7          	jalr	1710(ra) # 5c88 <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	cec50513          	addi	a0,a0,-788 # 62e8 <malloc+0x260>
     604:	00006097          	auipc	ra,0x6
     608:	9cc080e7          	jalr	-1588(ra) # 5fd0 <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	652080e7          	jalr	1618(ra) # 5c60 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	ce650513          	addi	a0,a0,-794 # 6300 <malloc+0x278>
     622:	00006097          	auipc	ra,0x6
     626:	9ae080e7          	jalr	-1618(ra) # 5fd0 <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	634080e7          	jalr	1588(ra) # 5c60 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	cf850513          	addi	a0,a0,-776 # 6330 <malloc+0x2a8>
     640:	00006097          	auipc	ra,0x6
     644:	990080e7          	jalr	-1648(ra) # 5fd0 <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	616080e7          	jalr	1558(ra) # 5c60 <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	d0e50513          	addi	a0,a0,-754 # 6360 <malloc+0x2d8>
     65a:	00006097          	auipc	ra,0x6
     65e:	976080e7          	jalr	-1674(ra) # 5fd0 <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	5fc080e7          	jalr	1532(ra) # 5c60 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	d0050513          	addi	a0,a0,-768 # 6370 <malloc+0x2e8>
     678:	00006097          	auipc	ra,0x6
     67c:	958080e7          	jalr	-1704(ra) # 5fd0 <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	5de080e7          	jalr	1502(ra) # 5c60 <exit>

000000000000068a <copyout>:
{
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69c:	4785                	li	a5,1
     69e:	07fe                	slli	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	cf2a0a13          	addi	s4,s4,-782 # 63a0 <malloc+0x318>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	b82a8a93          	addi	s5,s5,-1150 # 6238 <malloc+0x1b0>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	5da080e7          	jalr	1498(ra) # 5ca0 <open>
     6ce:	84aa                	mv	s1,a0
    if(fd < 0){
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	5a0080e7          	jalr	1440(ra) # 5c78 <read>
    if(n > 0){
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	5a2080e7          	jalr	1442(ra) # 5c88 <close>
    if(pipe(fds) < 0){
     6ee:	fa840513          	addi	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	57e080e7          	jalr	1406(ra) # 5c70 <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	57a080e7          	jalr	1402(ra) # 5c80 <write>
    if(n != 1){
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	55c080e7          	jalr	1372(ra) # 5c78 <read>
    if(n > 0){
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	55c080e7          	jalr	1372(ra) # 5c88 <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	550080e7          	jalr	1360(ra) # 5c88 <close>
  for(int ai = 0; ai < 2; ai++){
     740:	0921                	addi	s2,s2,8
     742:	fc040793          	addi	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	addi	sp,sp,96
     75a:	8082                	ret
      printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	c4c50513          	addi	a0,a0,-948 # 63a8 <malloc+0x320>
     764:	00006097          	auipc	ra,0x6
     768:	86c080e7          	jalr	-1940(ra) # 5fd0 <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	4f2080e7          	jalr	1266(ra) # 5c60 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	c4650513          	addi	a0,a0,-954 # 63c0 <malloc+0x338>
     782:	00006097          	auipc	ra,0x6
     786:	84e080e7          	jalr	-1970(ra) # 5fd0 <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	4d4080e7          	jalr	1236(ra) # 5c60 <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	bcc50513          	addi	a0,a0,-1076 # 6360 <malloc+0x2d8>
     79c:	00006097          	auipc	ra,0x6
     7a0:	834080e7          	jalr	-1996(ra) # 5fd0 <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	4ba080e7          	jalr	1210(ra) # 5c60 <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	c4250513          	addi	a0,a0,-958 # 63f0 <malloc+0x368>
     7b6:	00006097          	auipc	ra,0x6
     7ba:	81a080e7          	jalr	-2022(ra) # 5fd0 <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	4a0080e7          	jalr	1184(ra) # 5c60 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	c3c50513          	addi	a0,a0,-964 # 6408 <malloc+0x380>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	7fc080e7          	jalr	2044(ra) # 5fd0 <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	482080e7          	jalr	1154(ra) # 5c60 <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	addi	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	addi	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	a2650513          	addi	a0,a0,-1498 # 6220 <malloc+0x198>
     802:	00005097          	auipc	ra,0x5
     806:	4ae080e7          	jalr	1198(ra) # 5cb0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	a1250513          	addi	a0,a0,-1518 # 6220 <malloc+0x198>
     816:	00005097          	auipc	ra,0x5
     81a:	48a080e7          	jalr	1162(ra) # 5ca0 <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	a0e58593          	addi	a1,a1,-1522 # 6230 <malloc+0x1a8>
     82a:	00005097          	auipc	ra,0x5
     82e:	456080e7          	jalr	1110(ra) # 5c80 <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	454080e7          	jalr	1108(ra) # 5c88 <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	9e250513          	addi	a0,a0,-1566 # 6220 <malloc+0x198>
     846:	00005097          	auipc	ra,0x5
     84a:	45a080e7          	jalr	1114(ra) # 5ca0 <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	addi	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	420080e7          	jalr	1056(ra) # 5c78 <read>
  if(n != 4){
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	9b650513          	addi	a0,a0,-1610 # 6220 <malloc+0x198>
     872:	00005097          	auipc	ra,0x5
     876:	42e080e7          	jalr	1070(ra) # 5ca0 <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	9a250513          	addi	a0,a0,-1630 # 6220 <malloc+0x198>
     886:	00005097          	auipc	ra,0x5
     88a:	41a080e7          	jalr	1050(ra) # 5ca0 <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	addi	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	3e0080e7          	jalr	992(ra) # 5c78 <read>
     8a0:	8a2a                	mv	s4,a0
  if(n != 0){
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	3ca080e7          	jalr	970(ra) # 5c78 <read>
     8b6:	8a2a                	mv	s4,a0
  if(n != 0){
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	bdc58593          	addi	a1,a1,-1060 # 6498 <malloc+0x410>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	3ba080e7          	jalr	954(ra) # 5c80 <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	addi	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	3a0080e7          	jalr	928(ra) # 5c78 <read>
  if(n != 6){
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	addi	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	388080e7          	jalr	904(ra) # 5c78 <read>
  if(n != 2){
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	92250513          	addi	a0,a0,-1758 # 6220 <malloc+0x198>
     906:	00005097          	auipc	ra,0x5
     90a:	3aa080e7          	jalr	938(ra) # 5cb0 <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	378080e7          	jalr	888(ra) # 5c88 <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	36e080e7          	jalr	878(ra) # 5c88 <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	364080e7          	jalr	868(ra) # 5c88 <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	addi	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	af650513          	addi	a0,a0,-1290 # 6438 <malloc+0x3b0>
     94a:	00005097          	auipc	ra,0x5
     94e:	686080e7          	jalr	1670(ra) # 5fd0 <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	30c080e7          	jalr	780(ra) # 5c60 <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	afa50513          	addi	a0,a0,-1286 # 6458 <malloc+0x3d0>
     966:	00005097          	auipc	ra,0x5
     96a:	66a080e7          	jalr	1642(ra) # 5fd0 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	af650513          	addi	a0,a0,-1290 # 6468 <malloc+0x3e0>
     97a:	00005097          	auipc	ra,0x5
     97e:	656080e7          	jalr	1622(ra) # 5fd0 <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	2dc080e7          	jalr	732(ra) # 5c60 <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	afa50513          	addi	a0,a0,-1286 # 6488 <malloc+0x400>
     996:	00005097          	auipc	ra,0x5
     99a:	63a080e7          	jalr	1594(ra) # 5fd0 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	ac650513          	addi	a0,a0,-1338 # 6468 <malloc+0x3e0>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	626080e7          	jalr	1574(ra) # 5fd0 <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	2ac080e7          	jalr	684(ra) # 5c60 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	ae050513          	addi	a0,a0,-1312 # 64a0 <malloc+0x418>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	608080e7          	jalr	1544(ra) # 5fd0 <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	28e080e7          	jalr	654(ra) # 5c60 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	ae250513          	addi	a0,a0,-1310 # 64c0 <malloc+0x438>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	5ea080e7          	jalr	1514(ra) # 5fd0 <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	270080e7          	jalr	624(ra) # 5c60 <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	addi	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	ace50513          	addi	a0,a0,-1330 # 64e0 <malloc+0x458>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	286080e7          	jalr	646(ra) # 5ca0 <open>
  if(fd < 0){
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2a:	00006997          	auipc	s3,0x6
     a2e:	ade98993          	addi	s3,s3,-1314 # 6508 <malloc+0x480>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a32:	00006a97          	auipc	s5,0x6
     a36:	b0ea8a93          	addi	s5,s5,-1266 # 6540 <malloc+0x4b8>
  for(i = 0; i < N; i++){
     a3a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	23c080e7          	jalr	572(ra) # 5c80 <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	228080e7          	jalr	552(ra) # 5c80 <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a66:	2485                	addiw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	21a080e7          	jalr	538(ra) # 5c88 <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	a6850513          	addi	a0,a0,-1432 # 64e0 <malloc+0x458>
     a80:	00005097          	auipc	ra,0x5
     a84:	220080e7          	jalr	544(ra) # 5ca0 <open>
     a88:	84aa                	mv	s1,a0
  if(fd < 0){
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000c597          	auipc	a1,0xc
     a96:	1e658593          	addi	a1,a1,486 # cc78 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	1de080e7          	jalr	478(ra) # 5c78 <read>
  if(i != N*SZ*2){
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	1dc080e7          	jalr	476(ra) # 5c88 <close>
  if(unlink("small") < 0){
     ab4:	00006517          	auipc	a0,0x6
     ab8:	a2c50513          	addi	a0,a0,-1492 # 64e0 <malloc+0x458>
     abc:	00005097          	auipc	ra,0x5
     ac0:	1f4080e7          	jalr	500(ra) # 5cb0 <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	addi	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	a0a50513          	addi	a0,a0,-1526 # 64e8 <malloc+0x460>
     ae6:	00005097          	auipc	ra,0x5
     aea:	4ea080e7          	jalr	1258(ra) # 5fd0 <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	170080e7          	jalr	368(ra) # 5c60 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	a1c50513          	addi	a0,a0,-1508 # 6518 <malloc+0x490>
     b04:	00005097          	auipc	ra,0x5
     b08:	4cc080e7          	jalr	1228(ra) # 5fd0 <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	152080e7          	jalr	338(ra) # 5c60 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	a3650513          	addi	a0,a0,-1482 # 6550 <malloc+0x4c8>
     b22:	00005097          	auipc	ra,0x5
     b26:	4ae080e7          	jalr	1198(ra) # 5fd0 <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	134080e7          	jalr	308(ra) # 5c60 <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	a4250513          	addi	a0,a0,-1470 # 6578 <malloc+0x4f0>
     b3e:	00005097          	auipc	ra,0x5
     b42:	492080e7          	jalr	1170(ra) # 5fd0 <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	118080e7          	jalr	280(ra) # 5c60 <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	a4650513          	addi	a0,a0,-1466 # 6598 <malloc+0x510>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	476080e7          	jalr	1142(ra) # 5fd0 <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	0fc080e7          	jalr	252(ra) # 5c60 <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	a4250513          	addi	a0,a0,-1470 # 65b0 <malloc+0x528>
     b76:	00005097          	auipc	ra,0x5
     b7a:	45a080e7          	jalr	1114(ra) # 5fd0 <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	0e0080e7          	jalr	224(ra) # 5c60 <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	addi	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	addi	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	a3050513          	addi	a0,a0,-1488 # 65d0 <malloc+0x548>
     ba8:	00005097          	auipc	ra,0x5
     bac:	0f8080e7          	jalr	248(ra) # 5ca0 <open>
     bb0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb4:	0000c917          	auipc	s2,0xc
     bb8:	0c490913          	addi	s2,s2,196 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbc:	10c00a13          	li	s4,268
  if(fd < 0){
     bc0:	06054c63          	bltz	a0,c38 <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bc8:	40000613          	li	a2,1024
     bcc:	85ca                	mv	a1,s2
     bce:	854e                	mv	a0,s3
     bd0:	00005097          	auipc	ra,0x5
     bd4:	0b0080e7          	jalr	176(ra) # 5c80 <write>
     bd8:	40000793          	li	a5,1024
     bdc:	06f51c63          	bne	a0,a5,c54 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be0:	2485                	addiw	s1,s1,1
     be2:	ff4491e3          	bne	s1,s4,bc4 <writebig+0x3c>
  close(fd);
     be6:	854e                	mv	a0,s3
     be8:	00005097          	auipc	ra,0x5
     bec:	0a0080e7          	jalr	160(ra) # 5c88 <close>
  fd = open("big", O_RDONLY);
     bf0:	4581                	li	a1,0
     bf2:	00006517          	auipc	a0,0x6
     bf6:	9de50513          	addi	a0,a0,-1570 # 65d0 <malloc+0x548>
     bfa:	00005097          	auipc	ra,0x5
     bfe:	0a6080e7          	jalr	166(ra) # 5ca0 <open>
     c02:	89aa                	mv	s3,a0
  n = 0;
     c04:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c06:	0000c917          	auipc	s2,0xc
     c0a:	07290913          	addi	s2,s2,114 # cc78 <buf>
  if(fd < 0){
     c0e:	06054263          	bltz	a0,c72 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c12:	40000613          	li	a2,1024
     c16:	85ca                	mv	a1,s2
     c18:	854e                	mv	a0,s3
     c1a:	00005097          	auipc	ra,0x5
     c1e:	05e080e7          	jalr	94(ra) # 5c78 <read>
    if(i == 0){
     c22:	c535                	beqz	a0,c8e <writebig+0x106>
    } else if(i != BSIZE){
     c24:	40000793          	li	a5,1024
     c28:	0af51f63          	bne	a0,a5,ce6 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2c:	00092683          	lw	a3,0(s2)
     c30:	0c969a63          	bne	a3,s1,d04 <writebig+0x17c>
    n++;
     c34:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c36:	bff1                	j	c12 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c38:	85d6                	mv	a1,s5
     c3a:	00006517          	auipc	a0,0x6
     c3e:	99e50513          	addi	a0,a0,-1634 # 65d8 <malloc+0x550>
     c42:	00005097          	auipc	ra,0x5
     c46:	38e080e7          	jalr	910(ra) # 5fd0 <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	00005097          	auipc	ra,0x5
     c50:	014080e7          	jalr	20(ra) # 5c60 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c54:	8626                	mv	a2,s1
     c56:	85d6                	mv	a1,s5
     c58:	00006517          	auipc	a0,0x6
     c5c:	9a050513          	addi	a0,a0,-1632 # 65f8 <malloc+0x570>
     c60:	00005097          	auipc	ra,0x5
     c64:	370080e7          	jalr	880(ra) # 5fd0 <printf>
      exit(1);
     c68:	4505                	li	a0,1
     c6a:	00005097          	auipc	ra,0x5
     c6e:	ff6080e7          	jalr	-10(ra) # 5c60 <exit>
    printf("%s: error: open big failed!\n", s);
     c72:	85d6                	mv	a1,s5
     c74:	00006517          	auipc	a0,0x6
     c78:	9ac50513          	addi	a0,a0,-1620 # 6620 <malloc+0x598>
     c7c:	00005097          	auipc	ra,0x5
     c80:	354080e7          	jalr	852(ra) # 5fd0 <printf>
    exit(1);
     c84:	4505                	li	a0,1
     c86:	00005097          	auipc	ra,0x5
     c8a:	fda080e7          	jalr	-38(ra) # 5c60 <exit>
      if(n == MAXFILE - 1){
     c8e:	10b00793          	li	a5,267
     c92:	02f48a63          	beq	s1,a5,cc6 <writebig+0x13e>
  close(fd);
     c96:	854e                	mv	a0,s3
     c98:	00005097          	auipc	ra,0x5
     c9c:	ff0080e7          	jalr	-16(ra) # 5c88 <close>
  if(unlink("big") < 0){
     ca0:	00006517          	auipc	a0,0x6
     ca4:	93050513          	addi	a0,a0,-1744 # 65d0 <malloc+0x548>
     ca8:	00005097          	auipc	ra,0x5
     cac:	008080e7          	jalr	8(ra) # 5cb0 <unlink>
     cb0:	06054963          	bltz	a0,d22 <writebig+0x19a>
}
     cb4:	70e2                	ld	ra,56(sp)
     cb6:	7442                	ld	s0,48(sp)
     cb8:	74a2                	ld	s1,40(sp)
     cba:	7902                	ld	s2,32(sp)
     cbc:	69e2                	ld	s3,24(sp)
     cbe:	6a42                	ld	s4,16(sp)
     cc0:	6aa2                	ld	s5,8(sp)
     cc2:	6121                	addi	sp,sp,64
     cc4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc6:	10b00613          	li	a2,267
     cca:	85d6                	mv	a1,s5
     ccc:	00006517          	auipc	a0,0x6
     cd0:	97450513          	addi	a0,a0,-1676 # 6640 <malloc+0x5b8>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	2fc080e7          	jalr	764(ra) # 5fd0 <printf>
        exit(1);
     cdc:	4505                	li	a0,1
     cde:	00005097          	auipc	ra,0x5
     ce2:	f82080e7          	jalr	-126(ra) # 5c60 <exit>
      printf("%s: read failed %d\n", s, i);
     ce6:	862a                	mv	a2,a0
     ce8:	85d6                	mv	a1,s5
     cea:	00006517          	auipc	a0,0x6
     cee:	97e50513          	addi	a0,a0,-1666 # 6668 <malloc+0x5e0>
     cf2:	00005097          	auipc	ra,0x5
     cf6:	2de080e7          	jalr	734(ra) # 5fd0 <printf>
      exit(1);
     cfa:	4505                	li	a0,1
     cfc:	00005097          	auipc	ra,0x5
     d00:	f64080e7          	jalr	-156(ra) # 5c60 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d04:	8626                	mv	a2,s1
     d06:	85d6                	mv	a1,s5
     d08:	00006517          	auipc	a0,0x6
     d0c:	97850513          	addi	a0,a0,-1672 # 6680 <malloc+0x5f8>
     d10:	00005097          	auipc	ra,0x5
     d14:	2c0080e7          	jalr	704(ra) # 5fd0 <printf>
      exit(1);
     d18:	4505                	li	a0,1
     d1a:	00005097          	auipc	ra,0x5
     d1e:	f46080e7          	jalr	-186(ra) # 5c60 <exit>
    printf("%s: unlink big failed\n", s);
     d22:	85d6                	mv	a1,s5
     d24:	00006517          	auipc	a0,0x6
     d28:	98450513          	addi	a0,a0,-1660 # 66a8 <malloc+0x620>
     d2c:	00005097          	auipc	ra,0x5
     d30:	2a4080e7          	jalr	676(ra) # 5fd0 <printf>
    exit(1);
     d34:	4505                	li	a0,1
     d36:	00005097          	auipc	ra,0x5
     d3a:	f2a080e7          	jalr	-214(ra) # 5c60 <exit>

0000000000000d3e <unlinkread>:
{
     d3e:	7179                	addi	sp,sp,-48
     d40:	f406                	sd	ra,40(sp)
     d42:	f022                	sd	s0,32(sp)
     d44:	ec26                	sd	s1,24(sp)
     d46:	e84a                	sd	s2,16(sp)
     d48:	e44e                	sd	s3,8(sp)
     d4a:	1800                	addi	s0,sp,48
     d4c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d4e:	20200593          	li	a1,514
     d52:	00006517          	auipc	a0,0x6
     d56:	96e50513          	addi	a0,a0,-1682 # 66c0 <malloc+0x638>
     d5a:	00005097          	auipc	ra,0x5
     d5e:	f46080e7          	jalr	-186(ra) # 5ca0 <open>
  if(fd < 0){
     d62:	0e054563          	bltz	a0,e4c <unlinkread+0x10e>
     d66:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d68:	4615                	li	a2,5
     d6a:	00006597          	auipc	a1,0x6
     d6e:	98658593          	addi	a1,a1,-1658 # 66f0 <malloc+0x668>
     d72:	00005097          	auipc	ra,0x5
     d76:	f0e080e7          	jalr	-242(ra) # 5c80 <write>
  close(fd);
     d7a:	8526                	mv	a0,s1
     d7c:	00005097          	auipc	ra,0x5
     d80:	f0c080e7          	jalr	-244(ra) # 5c88 <close>
  fd = open("unlinkread", O_RDWR);
     d84:	4589                	li	a1,2
     d86:	00006517          	auipc	a0,0x6
     d8a:	93a50513          	addi	a0,a0,-1734 # 66c0 <malloc+0x638>
     d8e:	00005097          	auipc	ra,0x5
     d92:	f12080e7          	jalr	-238(ra) # 5ca0 <open>
     d96:	84aa                	mv	s1,a0
  if(fd < 0){
     d98:	0c054863          	bltz	a0,e68 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9c:	00006517          	auipc	a0,0x6
     da0:	92450513          	addi	a0,a0,-1756 # 66c0 <malloc+0x638>
     da4:	00005097          	auipc	ra,0x5
     da8:	f0c080e7          	jalr	-244(ra) # 5cb0 <unlink>
     dac:	ed61                	bnez	a0,e84 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00006517          	auipc	a0,0x6
     db6:	90e50513          	addi	a0,a0,-1778 # 66c0 <malloc+0x638>
     dba:	00005097          	auipc	ra,0x5
     dbe:	ee6080e7          	jalr	-282(ra) # 5ca0 <open>
     dc2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc4:	460d                	li	a2,3
     dc6:	00006597          	auipc	a1,0x6
     dca:	97258593          	addi	a1,a1,-1678 # 6738 <malloc+0x6b0>
     dce:	00005097          	auipc	ra,0x5
     dd2:	eb2080e7          	jalr	-334(ra) # 5c80 <write>
  close(fd1);
     dd6:	854a                	mv	a0,s2
     dd8:	00005097          	auipc	ra,0x5
     ddc:	eb0080e7          	jalr	-336(ra) # 5c88 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de0:	660d                	lui	a2,0x3
     de2:	0000c597          	auipc	a1,0xc
     de6:	e9658593          	addi	a1,a1,-362 # cc78 <buf>
     dea:	8526                	mv	a0,s1
     dec:	00005097          	auipc	ra,0x5
     df0:	e8c080e7          	jalr	-372(ra) # 5c78 <read>
     df4:	4795                	li	a5,5
     df6:	0af51563          	bne	a0,a5,ea0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfa:	0000c717          	auipc	a4,0xc
     dfe:	e7e74703          	lbu	a4,-386(a4) # cc78 <buf>
     e02:	06800793          	li	a5,104
     e06:	0af71b63          	bne	a4,a5,ebc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0a:	4629                	li	a2,10
     e0c:	0000c597          	auipc	a1,0xc
     e10:	e6c58593          	addi	a1,a1,-404 # cc78 <buf>
     e14:	8526                	mv	a0,s1
     e16:	00005097          	auipc	ra,0x5
     e1a:	e6a080e7          	jalr	-406(ra) # 5c80 <write>
     e1e:	47a9                	li	a5,10
     e20:	0af51c63          	bne	a0,a5,ed8 <unlinkread+0x19a>
  close(fd);
     e24:	8526                	mv	a0,s1
     e26:	00005097          	auipc	ra,0x5
     e2a:	e62080e7          	jalr	-414(ra) # 5c88 <close>
  unlink("unlinkread");
     e2e:	00006517          	auipc	a0,0x6
     e32:	89250513          	addi	a0,a0,-1902 # 66c0 <malloc+0x638>
     e36:	00005097          	auipc	ra,0x5
     e3a:	e7a080e7          	jalr	-390(ra) # 5cb0 <unlink>
}
     e3e:	70a2                	ld	ra,40(sp)
     e40:	7402                	ld	s0,32(sp)
     e42:	64e2                	ld	s1,24(sp)
     e44:	6942                	ld	s2,16(sp)
     e46:	69a2                	ld	s3,8(sp)
     e48:	6145                	addi	sp,sp,48
     e4a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4c:	85ce                	mv	a1,s3
     e4e:	00006517          	auipc	a0,0x6
     e52:	88250513          	addi	a0,a0,-1918 # 66d0 <malloc+0x648>
     e56:	00005097          	auipc	ra,0x5
     e5a:	17a080e7          	jalr	378(ra) # 5fd0 <printf>
    exit(1);
     e5e:	4505                	li	a0,1
     e60:	00005097          	auipc	ra,0x5
     e64:	e00080e7          	jalr	-512(ra) # 5c60 <exit>
    printf("%s: open unlinkread failed\n", s);
     e68:	85ce                	mv	a1,s3
     e6a:	00006517          	auipc	a0,0x6
     e6e:	88e50513          	addi	a0,a0,-1906 # 66f8 <malloc+0x670>
     e72:	00005097          	auipc	ra,0x5
     e76:	15e080e7          	jalr	350(ra) # 5fd0 <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	de4080e7          	jalr	-540(ra) # 5c60 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e84:	85ce                	mv	a1,s3
     e86:	00006517          	auipc	a0,0x6
     e8a:	89250513          	addi	a0,a0,-1902 # 6718 <malloc+0x690>
     e8e:	00005097          	auipc	ra,0x5
     e92:	142080e7          	jalr	322(ra) # 5fd0 <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	dc8080e7          	jalr	-568(ra) # 5c60 <exit>
    printf("%s: unlinkread read failed", s);
     ea0:	85ce                	mv	a1,s3
     ea2:	00006517          	auipc	a0,0x6
     ea6:	89e50513          	addi	a0,a0,-1890 # 6740 <malloc+0x6b8>
     eaa:	00005097          	auipc	ra,0x5
     eae:	126080e7          	jalr	294(ra) # 5fd0 <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	dac080e7          	jalr	-596(ra) # 5c60 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebc:	85ce                	mv	a1,s3
     ebe:	00006517          	auipc	a0,0x6
     ec2:	8a250513          	addi	a0,a0,-1886 # 6760 <malloc+0x6d8>
     ec6:	00005097          	auipc	ra,0x5
     eca:	10a080e7          	jalr	266(ra) # 5fd0 <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	d90080e7          	jalr	-624(ra) # 5c60 <exit>
    printf("%s: unlinkread write failed\n", s);
     ed8:	85ce                	mv	a1,s3
     eda:	00006517          	auipc	a0,0x6
     ede:	8a650513          	addi	a0,a0,-1882 # 6780 <malloc+0x6f8>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	0ee080e7          	jalr	238(ra) # 5fd0 <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	d74080e7          	jalr	-652(ra) # 5c60 <exit>

0000000000000ef4 <linktest>:
{
     ef4:	1101                	addi	sp,sp,-32
     ef6:	ec06                	sd	ra,24(sp)
     ef8:	e822                	sd	s0,16(sp)
     efa:	e426                	sd	s1,8(sp)
     efc:	e04a                	sd	s2,0(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	892a                	mv	s2,a0
  unlink("lf1");
     f02:	00006517          	auipc	a0,0x6
     f06:	89e50513          	addi	a0,a0,-1890 # 67a0 <malloc+0x718>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	da6080e7          	jalr	-602(ra) # 5cb0 <unlink>
  unlink("lf2");
     f12:	00006517          	auipc	a0,0x6
     f16:	89650513          	addi	a0,a0,-1898 # 67a8 <malloc+0x720>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	d96080e7          	jalr	-618(ra) # 5cb0 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f22:	20200593          	li	a1,514
     f26:	00006517          	auipc	a0,0x6
     f2a:	87a50513          	addi	a0,a0,-1926 # 67a0 <malloc+0x718>
     f2e:	00005097          	auipc	ra,0x5
     f32:	d72080e7          	jalr	-654(ra) # 5ca0 <open>
  if(fd < 0){
     f36:	10054763          	bltz	a0,1044 <linktest+0x150>
     f3a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3c:	4615                	li	a2,5
     f3e:	00005597          	auipc	a1,0x5
     f42:	7b258593          	addi	a1,a1,1970 # 66f0 <malloc+0x668>
     f46:	00005097          	auipc	ra,0x5
     f4a:	d3a080e7          	jalr	-710(ra) # 5c80 <write>
     f4e:	4795                	li	a5,5
     f50:	10f51863          	bne	a0,a5,1060 <linktest+0x16c>
  close(fd);
     f54:	8526                	mv	a0,s1
     f56:	00005097          	auipc	ra,0x5
     f5a:	d32080e7          	jalr	-718(ra) # 5c88 <close>
  if(link("lf1", "lf2") < 0){
     f5e:	00006597          	auipc	a1,0x6
     f62:	84a58593          	addi	a1,a1,-1974 # 67a8 <malloc+0x720>
     f66:	00006517          	auipc	a0,0x6
     f6a:	83a50513          	addi	a0,a0,-1990 # 67a0 <malloc+0x718>
     f6e:	00005097          	auipc	ra,0x5
     f72:	d52080e7          	jalr	-686(ra) # 5cc0 <link>
     f76:	10054363          	bltz	a0,107c <linktest+0x188>
  unlink("lf1");
     f7a:	00006517          	auipc	a0,0x6
     f7e:	82650513          	addi	a0,a0,-2010 # 67a0 <malloc+0x718>
     f82:	00005097          	auipc	ra,0x5
     f86:	d2e080e7          	jalr	-722(ra) # 5cb0 <unlink>
  if(open("lf1", 0) >= 0){
     f8a:	4581                	li	a1,0
     f8c:	00006517          	auipc	a0,0x6
     f90:	81450513          	addi	a0,a0,-2028 # 67a0 <malloc+0x718>
     f94:	00005097          	auipc	ra,0x5
     f98:	d0c080e7          	jalr	-756(ra) # 5ca0 <open>
     f9c:	0e055e63          	bgez	a0,1098 <linktest+0x1a4>
  fd = open("lf2", 0);
     fa0:	4581                	li	a1,0
     fa2:	00006517          	auipc	a0,0x6
     fa6:	80650513          	addi	a0,a0,-2042 # 67a8 <malloc+0x720>
     faa:	00005097          	auipc	ra,0x5
     fae:	cf6080e7          	jalr	-778(ra) # 5ca0 <open>
     fb2:	84aa                	mv	s1,a0
  if(fd < 0){
     fb4:	10054063          	bltz	a0,10b4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fb8:	660d                	lui	a2,0x3
     fba:	0000c597          	auipc	a1,0xc
     fbe:	cbe58593          	addi	a1,a1,-834 # cc78 <buf>
     fc2:	00005097          	auipc	ra,0x5
     fc6:	cb6080e7          	jalr	-842(ra) # 5c78 <read>
     fca:	4795                	li	a5,5
     fcc:	10f51263          	bne	a0,a5,10d0 <linktest+0x1dc>
  close(fd);
     fd0:	8526                	mv	a0,s1
     fd2:	00005097          	auipc	ra,0x5
     fd6:	cb6080e7          	jalr	-842(ra) # 5c88 <close>
  if(link("lf2", "lf2") >= 0){
     fda:	00005597          	auipc	a1,0x5
     fde:	7ce58593          	addi	a1,a1,1998 # 67a8 <malloc+0x720>
     fe2:	852e                	mv	a0,a1
     fe4:	00005097          	auipc	ra,0x5
     fe8:	cdc080e7          	jalr	-804(ra) # 5cc0 <link>
     fec:	10055063          	bgez	a0,10ec <linktest+0x1f8>
  unlink("lf2");
     ff0:	00005517          	auipc	a0,0x5
     ff4:	7b850513          	addi	a0,a0,1976 # 67a8 <malloc+0x720>
     ff8:	00005097          	auipc	ra,0x5
     ffc:	cb8080e7          	jalr	-840(ra) # 5cb0 <unlink>
  if(link("lf2", "lf1") >= 0){
    1000:	00005597          	auipc	a1,0x5
    1004:	7a058593          	addi	a1,a1,1952 # 67a0 <malloc+0x718>
    1008:	00005517          	auipc	a0,0x5
    100c:	7a050513          	addi	a0,a0,1952 # 67a8 <malloc+0x720>
    1010:	00005097          	auipc	ra,0x5
    1014:	cb0080e7          	jalr	-848(ra) # 5cc0 <link>
    1018:	0e055863          	bgez	a0,1108 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101c:	00005597          	auipc	a1,0x5
    1020:	78458593          	addi	a1,a1,1924 # 67a0 <malloc+0x718>
    1024:	00006517          	auipc	a0,0x6
    1028:	88c50513          	addi	a0,a0,-1908 # 68b0 <malloc+0x828>
    102c:	00005097          	auipc	ra,0x5
    1030:	c94080e7          	jalr	-876(ra) # 5cc0 <link>
    1034:	0e055863          	bgez	a0,1124 <linktest+0x230>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	64a2                	ld	s1,8(sp)
    103e:	6902                	ld	s2,0(sp)
    1040:	6105                	addi	sp,sp,32
    1042:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1044:	85ca                	mv	a1,s2
    1046:	00005517          	auipc	a0,0x5
    104a:	76a50513          	addi	a0,a0,1898 # 67b0 <malloc+0x728>
    104e:	00005097          	auipc	ra,0x5
    1052:	f82080e7          	jalr	-126(ra) # 5fd0 <printf>
    exit(1);
    1056:	4505                	li	a0,1
    1058:	00005097          	auipc	ra,0x5
    105c:	c08080e7          	jalr	-1016(ra) # 5c60 <exit>
    printf("%s: write lf1 failed\n", s);
    1060:	85ca                	mv	a1,s2
    1062:	00005517          	auipc	a0,0x5
    1066:	76650513          	addi	a0,a0,1894 # 67c8 <malloc+0x740>
    106a:	00005097          	auipc	ra,0x5
    106e:	f66080e7          	jalr	-154(ra) # 5fd0 <printf>
    exit(1);
    1072:	4505                	li	a0,1
    1074:	00005097          	auipc	ra,0x5
    1078:	bec080e7          	jalr	-1044(ra) # 5c60 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107c:	85ca                	mv	a1,s2
    107e:	00005517          	auipc	a0,0x5
    1082:	76250513          	addi	a0,a0,1890 # 67e0 <malloc+0x758>
    1086:	00005097          	auipc	ra,0x5
    108a:	f4a080e7          	jalr	-182(ra) # 5fd0 <printf>
    exit(1);
    108e:	4505                	li	a0,1
    1090:	00005097          	auipc	ra,0x5
    1094:	bd0080e7          	jalr	-1072(ra) # 5c60 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1098:	85ca                	mv	a1,s2
    109a:	00005517          	auipc	a0,0x5
    109e:	76650513          	addi	a0,a0,1894 # 6800 <malloc+0x778>
    10a2:	00005097          	auipc	ra,0x5
    10a6:	f2e080e7          	jalr	-210(ra) # 5fd0 <printf>
    exit(1);
    10aa:	4505                	li	a0,1
    10ac:	00005097          	auipc	ra,0x5
    10b0:	bb4080e7          	jalr	-1100(ra) # 5c60 <exit>
    printf("%s: open lf2 failed\n", s);
    10b4:	85ca                	mv	a1,s2
    10b6:	00005517          	auipc	a0,0x5
    10ba:	77a50513          	addi	a0,a0,1914 # 6830 <malloc+0x7a8>
    10be:	00005097          	auipc	ra,0x5
    10c2:	f12080e7          	jalr	-238(ra) # 5fd0 <printf>
    exit(1);
    10c6:	4505                	li	a0,1
    10c8:	00005097          	auipc	ra,0x5
    10cc:	b98080e7          	jalr	-1128(ra) # 5c60 <exit>
    printf("%s: read lf2 failed\n", s);
    10d0:	85ca                	mv	a1,s2
    10d2:	00005517          	auipc	a0,0x5
    10d6:	77650513          	addi	a0,a0,1910 # 6848 <malloc+0x7c0>
    10da:	00005097          	auipc	ra,0x5
    10de:	ef6080e7          	jalr	-266(ra) # 5fd0 <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	b7c080e7          	jalr	-1156(ra) # 5c60 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ec:	85ca                	mv	a1,s2
    10ee:	00005517          	auipc	a0,0x5
    10f2:	77250513          	addi	a0,a0,1906 # 6860 <malloc+0x7d8>
    10f6:	00005097          	auipc	ra,0x5
    10fa:	eda080e7          	jalr	-294(ra) # 5fd0 <printf>
    exit(1);
    10fe:	4505                	li	a0,1
    1100:	00005097          	auipc	ra,0x5
    1104:	b60080e7          	jalr	-1184(ra) # 5c60 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1108:	85ca                	mv	a1,s2
    110a:	00005517          	auipc	a0,0x5
    110e:	77e50513          	addi	a0,a0,1918 # 6888 <malloc+0x800>
    1112:	00005097          	auipc	ra,0x5
    1116:	ebe080e7          	jalr	-322(ra) # 5fd0 <printf>
    exit(1);
    111a:	4505                	li	a0,1
    111c:	00005097          	auipc	ra,0x5
    1120:	b44080e7          	jalr	-1212(ra) # 5c60 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1124:	85ca                	mv	a1,s2
    1126:	00005517          	auipc	a0,0x5
    112a:	79250513          	addi	a0,a0,1938 # 68b8 <malloc+0x830>
    112e:	00005097          	auipc	ra,0x5
    1132:	ea2080e7          	jalr	-350(ra) # 5fd0 <printf>
    exit(1);
    1136:	4505                	li	a0,1
    1138:	00005097          	auipc	ra,0x5
    113c:	b28080e7          	jalr	-1240(ra) # 5c60 <exit>

0000000000001140 <validatetest>:
{
    1140:	7139                	addi	sp,sp,-64
    1142:	fc06                	sd	ra,56(sp)
    1144:	f822                	sd	s0,48(sp)
    1146:	f426                	sd	s1,40(sp)
    1148:	f04a                	sd	s2,32(sp)
    114a:	ec4e                	sd	s3,24(sp)
    114c:	e852                	sd	s4,16(sp)
    114e:	e456                	sd	s5,8(sp)
    1150:	e05a                	sd	s6,0(sp)
    1152:	0080                	addi	s0,sp,64
    1154:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1156:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1158:	00005997          	auipc	s3,0x5
    115c:	78098993          	addi	s3,s3,1920 # 68d8 <malloc+0x850>
    1160:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1162:	6a85                	lui	s5,0x1
    1164:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1168:	85a6                	mv	a1,s1
    116a:	854e                	mv	a0,s3
    116c:	00005097          	auipc	ra,0x5
    1170:	b54080e7          	jalr	-1196(ra) # 5cc0 <link>
    1174:	01251f63          	bne	a0,s2,1192 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1178:	94d6                	add	s1,s1,s5
    117a:	ff4497e3          	bne	s1,s4,1168 <validatetest+0x28>
}
    117e:	70e2                	ld	ra,56(sp)
    1180:	7442                	ld	s0,48(sp)
    1182:	74a2                	ld	s1,40(sp)
    1184:	7902                	ld	s2,32(sp)
    1186:	69e2                	ld	s3,24(sp)
    1188:	6a42                	ld	s4,16(sp)
    118a:	6aa2                	ld	s5,8(sp)
    118c:	6b02                	ld	s6,0(sp)
    118e:	6121                	addi	sp,sp,64
    1190:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1192:	85da                	mv	a1,s6
    1194:	00005517          	auipc	a0,0x5
    1198:	75450513          	addi	a0,a0,1876 # 68e8 <malloc+0x860>
    119c:	00005097          	auipc	ra,0x5
    11a0:	e34080e7          	jalr	-460(ra) # 5fd0 <printf>
      exit(1);
    11a4:	4505                	li	a0,1
    11a6:	00005097          	auipc	ra,0x5
    11aa:	aba080e7          	jalr	-1350(ra) # 5c60 <exit>

00000000000011ae <bigdir>:
{
    11ae:	715d                	addi	sp,sp,-80
    11b0:	e486                	sd	ra,72(sp)
    11b2:	e0a2                	sd	s0,64(sp)
    11b4:	fc26                	sd	s1,56(sp)
    11b6:	f84a                	sd	s2,48(sp)
    11b8:	f44e                	sd	s3,40(sp)
    11ba:	f052                	sd	s4,32(sp)
    11bc:	ec56                	sd	s5,24(sp)
    11be:	e85a                	sd	s6,16(sp)
    11c0:	0880                	addi	s0,sp,80
    11c2:	89aa                	mv	s3,a0
  unlink("bd");
    11c4:	00005517          	auipc	a0,0x5
    11c8:	74450513          	addi	a0,a0,1860 # 6908 <malloc+0x880>
    11cc:	00005097          	auipc	ra,0x5
    11d0:	ae4080e7          	jalr	-1308(ra) # 5cb0 <unlink>
  fd = open("bd", O_CREATE);
    11d4:	20000593          	li	a1,512
    11d8:	00005517          	auipc	a0,0x5
    11dc:	73050513          	addi	a0,a0,1840 # 6908 <malloc+0x880>
    11e0:	00005097          	auipc	ra,0x5
    11e4:	ac0080e7          	jalr	-1344(ra) # 5ca0 <open>
  if(fd < 0){
    11e8:	0c054963          	bltz	a0,12ba <bigdir+0x10c>
  close(fd);
    11ec:	00005097          	auipc	ra,0x5
    11f0:	a9c080e7          	jalr	-1380(ra) # 5c88 <close>
  for(i = 0; i < N; i++){
    11f4:	4901                	li	s2,0
    name[0] = 'x';
    11f6:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fa:	00005a17          	auipc	s4,0x5
    11fe:	70ea0a13          	addi	s4,s4,1806 # 6908 <malloc+0x880>
  for(i = 0; i < N; i++){
    1202:	1f400b13          	li	s6,500
    name[0] = 'x';
    1206:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120a:	41f9571b          	sraiw	a4,s2,0x1f
    120e:	01a7571b          	srliw	a4,a4,0x1a
    1212:	012707bb          	addw	a5,a4,s2
    1216:	4067d69b          	sraiw	a3,a5,0x6
    121a:	0306869b          	addiw	a3,a3,48
    121e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1222:	03f7f793          	andi	a5,a5,63
    1226:	9f99                	subw	a5,a5,a4
    1228:	0307879b          	addiw	a5,a5,48
    122c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1230:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1234:	fb040593          	addi	a1,s0,-80
    1238:	8552                	mv	a0,s4
    123a:	00005097          	auipc	ra,0x5
    123e:	a86080e7          	jalr	-1402(ra) # 5cc0 <link>
    1242:	84aa                	mv	s1,a0
    1244:	e949                	bnez	a0,12d6 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1246:	2905                	addiw	s2,s2,1
    1248:	fb691fe3          	bne	s2,s6,1206 <bigdir+0x58>
  unlink("bd");
    124c:	00005517          	auipc	a0,0x5
    1250:	6bc50513          	addi	a0,a0,1724 # 6908 <malloc+0x880>
    1254:	00005097          	auipc	ra,0x5
    1258:	a5c080e7          	jalr	-1444(ra) # 5cb0 <unlink>
    name[0] = 'x';
    125c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1260:	1f400a13          	li	s4,500
    name[0] = 'x';
    1264:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1268:	41f4d71b          	sraiw	a4,s1,0x1f
    126c:	01a7571b          	srliw	a4,a4,0x1a
    1270:	009707bb          	addw	a5,a4,s1
    1274:	4067d69b          	sraiw	a3,a5,0x6
    1278:	0306869b          	addiw	a3,a3,48
    127c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1280:	03f7f793          	andi	a5,a5,63
    1284:	9f99                	subw	a5,a5,a4
    1286:	0307879b          	addiw	a5,a5,48
    128a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    128e:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1292:	fb040513          	addi	a0,s0,-80
    1296:	00005097          	auipc	ra,0x5
    129a:	a1a080e7          	jalr	-1510(ra) # 5cb0 <unlink>
    129e:	ed21                	bnez	a0,12f6 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a0:	2485                	addiw	s1,s1,1
    12a2:	fd4491e3          	bne	s1,s4,1264 <bigdir+0xb6>
}
    12a6:	60a6                	ld	ra,72(sp)
    12a8:	6406                	ld	s0,64(sp)
    12aa:	74e2                	ld	s1,56(sp)
    12ac:	7942                	ld	s2,48(sp)
    12ae:	79a2                	ld	s3,40(sp)
    12b0:	7a02                	ld	s4,32(sp)
    12b2:	6ae2                	ld	s5,24(sp)
    12b4:	6b42                	ld	s6,16(sp)
    12b6:	6161                	addi	sp,sp,80
    12b8:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12ba:	85ce                	mv	a1,s3
    12bc:	00005517          	auipc	a0,0x5
    12c0:	65450513          	addi	a0,a0,1620 # 6910 <malloc+0x888>
    12c4:	00005097          	auipc	ra,0x5
    12c8:	d0c080e7          	jalr	-756(ra) # 5fd0 <printf>
    exit(1);
    12cc:	4505                	li	a0,1
    12ce:	00005097          	auipc	ra,0x5
    12d2:	992080e7          	jalr	-1646(ra) # 5c60 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d6:	fb040613          	addi	a2,s0,-80
    12da:	85ce                	mv	a1,s3
    12dc:	00005517          	auipc	a0,0x5
    12e0:	65450513          	addi	a0,a0,1620 # 6930 <malloc+0x8a8>
    12e4:	00005097          	auipc	ra,0x5
    12e8:	cec080e7          	jalr	-788(ra) # 5fd0 <printf>
      exit(1);
    12ec:	4505                	li	a0,1
    12ee:	00005097          	auipc	ra,0x5
    12f2:	972080e7          	jalr	-1678(ra) # 5c60 <exit>
      printf("%s: bigdir unlink failed", s);
    12f6:	85ce                	mv	a1,s3
    12f8:	00005517          	auipc	a0,0x5
    12fc:	65850513          	addi	a0,a0,1624 # 6950 <malloc+0x8c8>
    1300:	00005097          	auipc	ra,0x5
    1304:	cd0080e7          	jalr	-816(ra) # 5fd0 <printf>
      exit(1);
    1308:	4505                	li	a0,1
    130a:	00005097          	auipc	ra,0x5
    130e:	956080e7          	jalr	-1706(ra) # 5c60 <exit>

0000000000001312 <pgbug>:
{
    1312:	7179                	addi	sp,sp,-48
    1314:	f406                	sd	ra,40(sp)
    1316:	f022                	sd	s0,32(sp)
    1318:	ec26                	sd	s1,24(sp)
    131a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1320:	00008497          	auipc	s1,0x8
    1324:	ce048493          	addi	s1,s1,-800 # 9000 <big>
    1328:	fd840593          	addi	a1,s0,-40
    132c:	6088                	ld	a0,0(s1)
    132e:	00005097          	auipc	ra,0x5
    1332:	96a080e7          	jalr	-1686(ra) # 5c98 <exec>
  pipe(big);
    1336:	6088                	ld	a0,0(s1)
    1338:	00005097          	auipc	ra,0x5
    133c:	938080e7          	jalr	-1736(ra) # 5c70 <pipe>
  exit(0);
    1340:	4501                	li	a0,0
    1342:	00005097          	auipc	ra,0x5
    1346:	91e080e7          	jalr	-1762(ra) # 5c60 <exit>

000000000000134a <badarg>:
{
    134a:	7139                	addi	sp,sp,-64
    134c:	fc06                	sd	ra,56(sp)
    134e:	f822                	sd	s0,48(sp)
    1350:	f426                	sd	s1,40(sp)
    1352:	f04a                	sd	s2,32(sp)
    1354:	ec4e                	sd	s3,24(sp)
    1356:	0080                	addi	s0,sp,64
    1358:	64b1                	lui	s1,0xc
    135a:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    135e:	597d                	li	s2,-1
    1360:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1364:	00005997          	auipc	s3,0x5
    1368:	e6498993          	addi	s3,s3,-412 # 61c8 <malloc+0x140>
    argv[0] = (char*)0xffffffff;
    136c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1370:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1374:	fc040593          	addi	a1,s0,-64
    1378:	854e                	mv	a0,s3
    137a:	00005097          	auipc	ra,0x5
    137e:	91e080e7          	jalr	-1762(ra) # 5c98 <exec>
  for(int i = 0; i < 50000; i++){
    1382:	34fd                	addiw	s1,s1,-1
    1384:	f4e5                	bnez	s1,136c <badarg+0x22>
  exit(0);
    1386:	4501                	li	a0,0
    1388:	00005097          	auipc	ra,0x5
    138c:	8d8080e7          	jalr	-1832(ra) # 5c60 <exit>

0000000000001390 <copyinstr2>:
{
    1390:	7155                	addi	sp,sp,-208
    1392:	e586                	sd	ra,200(sp)
    1394:	e1a2                	sd	s0,192(sp)
    1396:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1398:	f6840793          	addi	a5,s0,-152
    139c:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a0:	07800713          	li	a4,120
    13a4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13a8:	0785                	addi	a5,a5,1
    13aa:	fed79de3          	bne	a5,a3,13a4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13ae:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b2:	f6840513          	addi	a0,s0,-152
    13b6:	00005097          	auipc	ra,0x5
    13ba:	8fa080e7          	jalr	-1798(ra) # 5cb0 <unlink>
  if(ret != -1){
    13be:	57fd                	li	a5,-1
    13c0:	0ef51063          	bne	a0,a5,14a0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c4:	20100593          	li	a1,513
    13c8:	f6840513          	addi	a0,s0,-152
    13cc:	00005097          	auipc	ra,0x5
    13d0:	8d4080e7          	jalr	-1836(ra) # 5ca0 <open>
  if(fd != -1){
    13d4:	57fd                	li	a5,-1
    13d6:	0ef51563          	bne	a0,a5,14c0 <copyinstr2+0x130>
  ret = link(b, b);
    13da:	f6840593          	addi	a1,s0,-152
    13de:	852e                	mv	a0,a1
    13e0:	00005097          	auipc	ra,0x5
    13e4:	8e0080e7          	jalr	-1824(ra) # 5cc0 <link>
  if(ret != -1){
    13e8:	57fd                	li	a5,-1
    13ea:	0ef51b63          	bne	a0,a5,14e0 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13ee:	00007797          	auipc	a5,0x7
    13f2:	8c278793          	addi	a5,a5,-1854 # 7cb0 <malloc+0x1c28>
    13f6:	f4f43c23          	sd	a5,-168(s0)
    13fa:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    13fe:	f5840593          	addi	a1,s0,-168
    1402:	f6840513          	addi	a0,s0,-152
    1406:	00005097          	auipc	ra,0x5
    140a:	892080e7          	jalr	-1902(ra) # 5c98 <exec>
  if(ret != -1){
    140e:	57fd                	li	a5,-1
    1410:	0ef51963          	bne	a0,a5,1502 <copyinstr2+0x172>
  int pid = fork();
    1414:	00005097          	auipc	ra,0x5
    1418:	844080e7          	jalr	-1980(ra) # 5c58 <fork>
  if(pid < 0){
    141c:	10054363          	bltz	a0,1522 <copyinstr2+0x192>
  if(pid == 0){
    1420:	12051463          	bnez	a0,1548 <copyinstr2+0x1b8>
    1424:	00008797          	auipc	a5,0x8
    1428:	13c78793          	addi	a5,a5,316 # 9560 <big.0>
    142c:	00009697          	auipc	a3,0x9
    1430:	13468693          	addi	a3,a3,308 # a560 <big.0+0x1000>
      big[i] = 'x';
    1434:	07800713          	li	a4,120
    1438:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143c:	0785                	addi	a5,a5,1
    143e:	fed79de3          	bne	a5,a3,1438 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1442:	00009797          	auipc	a5,0x9
    1446:	10078f23          	sb	zero,286(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144a:	00007797          	auipc	a5,0x7
    144e:	2ae78793          	addi	a5,a5,686 # 86f8 <malloc+0x2670>
    1452:	6390                	ld	a2,0(a5)
    1454:	6794                	ld	a3,8(a5)
    1456:	6b98                	ld	a4,16(a5)
    1458:	6f9c                	ld	a5,24(a5)
    145a:	f2c43823          	sd	a2,-208(s0)
    145e:	f2d43c23          	sd	a3,-200(s0)
    1462:	f4e43023          	sd	a4,-192(s0)
    1466:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146a:	f3040593          	addi	a1,s0,-208
    146e:	00005517          	auipc	a0,0x5
    1472:	d5a50513          	addi	a0,a0,-678 # 61c8 <malloc+0x140>
    1476:	00005097          	auipc	ra,0x5
    147a:	822080e7          	jalr	-2014(ra) # 5c98 <exec>
    if(ret != -1){
    147e:	57fd                	li	a5,-1
    1480:	0af50e63          	beq	a0,a5,153c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1484:	55fd                	li	a1,-1
    1486:	00005517          	auipc	a0,0x5
    148a:	57250513          	addi	a0,a0,1394 # 69f8 <malloc+0x970>
    148e:	00005097          	auipc	ra,0x5
    1492:	b42080e7          	jalr	-1214(ra) # 5fd0 <printf>
      exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	7c8080e7          	jalr	1992(ra) # 5c60 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a0:	862a                	mv	a2,a0
    14a2:	f6840593          	addi	a1,s0,-152
    14a6:	00005517          	auipc	a0,0x5
    14aa:	4ca50513          	addi	a0,a0,1226 # 6970 <malloc+0x8e8>
    14ae:	00005097          	auipc	ra,0x5
    14b2:	b22080e7          	jalr	-1246(ra) # 5fd0 <printf>
    exit(1);
    14b6:	4505                	li	a0,1
    14b8:	00004097          	auipc	ra,0x4
    14bc:	7a8080e7          	jalr	1960(ra) # 5c60 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c0:	862a                	mv	a2,a0
    14c2:	f6840593          	addi	a1,s0,-152
    14c6:	00005517          	auipc	a0,0x5
    14ca:	4ca50513          	addi	a0,a0,1226 # 6990 <malloc+0x908>
    14ce:	00005097          	auipc	ra,0x5
    14d2:	b02080e7          	jalr	-1278(ra) # 5fd0 <printf>
    exit(1);
    14d6:	4505                	li	a0,1
    14d8:	00004097          	auipc	ra,0x4
    14dc:	788080e7          	jalr	1928(ra) # 5c60 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e0:	86aa                	mv	a3,a0
    14e2:	f6840613          	addi	a2,s0,-152
    14e6:	85b2                	mv	a1,a2
    14e8:	00005517          	auipc	a0,0x5
    14ec:	4c850513          	addi	a0,a0,1224 # 69b0 <malloc+0x928>
    14f0:	00005097          	auipc	ra,0x5
    14f4:	ae0080e7          	jalr	-1312(ra) # 5fd0 <printf>
    exit(1);
    14f8:	4505                	li	a0,1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	766080e7          	jalr	1894(ra) # 5c60 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1502:	567d                	li	a2,-1
    1504:	f6840593          	addi	a1,s0,-152
    1508:	00005517          	auipc	a0,0x5
    150c:	4d050513          	addi	a0,a0,1232 # 69d8 <malloc+0x950>
    1510:	00005097          	auipc	ra,0x5
    1514:	ac0080e7          	jalr	-1344(ra) # 5fd0 <printf>
    exit(1);
    1518:	4505                	li	a0,1
    151a:	00004097          	auipc	ra,0x4
    151e:	746080e7          	jalr	1862(ra) # 5c60 <exit>
    printf("fork failed\n");
    1522:	00006517          	auipc	a0,0x6
    1526:	93650513          	addi	a0,a0,-1738 # 6e58 <malloc+0xdd0>
    152a:	00005097          	auipc	ra,0x5
    152e:	aa6080e7          	jalr	-1370(ra) # 5fd0 <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	00004097          	auipc	ra,0x4
    1538:	72c080e7          	jalr	1836(ra) # 5c60 <exit>
    exit(747); // OK
    153c:	2eb00513          	li	a0,747
    1540:	00004097          	auipc	ra,0x4
    1544:	720080e7          	jalr	1824(ra) # 5c60 <exit>
  int st = 0;
    1548:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154c:	f5440513          	addi	a0,s0,-172
    1550:	00004097          	auipc	ra,0x4
    1554:	718080e7          	jalr	1816(ra) # 5c68 <wait>
  if(st != 747){
    1558:	f5442703          	lw	a4,-172(s0)
    155c:	2eb00793          	li	a5,747
    1560:	00f71663          	bne	a4,a5,156c <copyinstr2+0x1dc>
}
    1564:	60ae                	ld	ra,200(sp)
    1566:	640e                	ld	s0,192(sp)
    1568:	6169                	addi	sp,sp,208
    156a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156c:	00005517          	auipc	a0,0x5
    1570:	4b450513          	addi	a0,a0,1204 # 6a20 <malloc+0x998>
    1574:	00005097          	auipc	ra,0x5
    1578:	a5c080e7          	jalr	-1444(ra) # 5fd0 <printf>
    exit(1);
    157c:	4505                	li	a0,1
    157e:	00004097          	auipc	ra,0x4
    1582:	6e2080e7          	jalr	1762(ra) # 5c60 <exit>

0000000000001586 <truncate3>:
{
    1586:	7159                	addi	sp,sp,-112
    1588:	f486                	sd	ra,104(sp)
    158a:	f0a2                	sd	s0,96(sp)
    158c:	e8ca                	sd	s2,80(sp)
    158e:	1880                	addi	s0,sp,112
    1590:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1592:	60100593          	li	a1,1537
    1596:	00005517          	auipc	a0,0x5
    159a:	c8a50513          	addi	a0,a0,-886 # 6220 <malloc+0x198>
    159e:	00004097          	auipc	ra,0x4
    15a2:	702080e7          	jalr	1794(ra) # 5ca0 <open>
    15a6:	00004097          	auipc	ra,0x4
    15aa:	6e2080e7          	jalr	1762(ra) # 5c88 <close>
  pid = fork();
    15ae:	00004097          	auipc	ra,0x4
    15b2:	6aa080e7          	jalr	1706(ra) # 5c58 <fork>
  if(pid < 0){
    15b6:	08054463          	bltz	a0,163e <truncate3+0xb8>
  if(pid == 0){
    15ba:	e16d                	bnez	a0,169c <truncate3+0x116>
    15bc:	eca6                	sd	s1,88(sp)
    15be:	e4ce                	sd	s3,72(sp)
    15c0:	e0d2                	sd	s4,64(sp)
    15c2:	fc56                	sd	s5,56(sp)
    15c4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15c8:	00005a17          	auipc	s4,0x5
    15cc:	c58a0a13          	addi	s4,s4,-936 # 6220 <malloc+0x198>
      int n = write(fd, "1234567890", 10);
    15d0:	00005a97          	auipc	s5,0x5
    15d4:	4b0a8a93          	addi	s5,s5,1200 # 6a80 <malloc+0x9f8>
      int fd = open("truncfile", O_WRONLY);
    15d8:	4585                	li	a1,1
    15da:	8552                	mv	a0,s4
    15dc:	00004097          	auipc	ra,0x4
    15e0:	6c4080e7          	jalr	1732(ra) # 5ca0 <open>
    15e4:	84aa                	mv	s1,a0
      if(fd < 0){
    15e6:	06054e63          	bltz	a0,1662 <truncate3+0xdc>
      int n = write(fd, "1234567890", 10);
    15ea:	4629                	li	a2,10
    15ec:	85d6                	mv	a1,s5
    15ee:	00004097          	auipc	ra,0x4
    15f2:	692080e7          	jalr	1682(ra) # 5c80 <write>
      if(n != 10){
    15f6:	47a9                	li	a5,10
    15f8:	08f51363          	bne	a0,a5,167e <truncate3+0xf8>
      close(fd);
    15fc:	8526                	mv	a0,s1
    15fe:	00004097          	auipc	ra,0x4
    1602:	68a080e7          	jalr	1674(ra) # 5c88 <close>
      fd = open("truncfile", O_RDONLY);
    1606:	4581                	li	a1,0
    1608:	8552                	mv	a0,s4
    160a:	00004097          	auipc	ra,0x4
    160e:	696080e7          	jalr	1686(ra) # 5ca0 <open>
    1612:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1614:	02000613          	li	a2,32
    1618:	f9840593          	addi	a1,s0,-104
    161c:	00004097          	auipc	ra,0x4
    1620:	65c080e7          	jalr	1628(ra) # 5c78 <read>
      close(fd);
    1624:	8526                	mv	a0,s1
    1626:	00004097          	auipc	ra,0x4
    162a:	662080e7          	jalr	1634(ra) # 5c88 <close>
    for(int i = 0; i < 100; i++){
    162e:	39fd                	addiw	s3,s3,-1
    1630:	fa0994e3          	bnez	s3,15d8 <truncate3+0x52>
    exit(0);
    1634:	4501                	li	a0,0
    1636:	00004097          	auipc	ra,0x4
    163a:	62a080e7          	jalr	1578(ra) # 5c60 <exit>
    163e:	eca6                	sd	s1,88(sp)
    1640:	e4ce                	sd	s3,72(sp)
    1642:	e0d2                	sd	s4,64(sp)
    1644:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1646:	85ca                	mv	a1,s2
    1648:	00005517          	auipc	a0,0x5
    164c:	40850513          	addi	a0,a0,1032 # 6a50 <malloc+0x9c8>
    1650:	00005097          	auipc	ra,0x5
    1654:	980080e7          	jalr	-1664(ra) # 5fd0 <printf>
    exit(1);
    1658:	4505                	li	a0,1
    165a:	00004097          	auipc	ra,0x4
    165e:	606080e7          	jalr	1542(ra) # 5c60 <exit>
        printf("%s: open failed\n", s);
    1662:	85ca                	mv	a1,s2
    1664:	00005517          	auipc	a0,0x5
    1668:	40450513          	addi	a0,a0,1028 # 6a68 <malloc+0x9e0>
    166c:	00005097          	auipc	ra,0x5
    1670:	964080e7          	jalr	-1692(ra) # 5fd0 <printf>
        exit(1);
    1674:	4505                	li	a0,1
    1676:	00004097          	auipc	ra,0x4
    167a:	5ea080e7          	jalr	1514(ra) # 5c60 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    167e:	862a                	mv	a2,a0
    1680:	85ca                	mv	a1,s2
    1682:	00005517          	auipc	a0,0x5
    1686:	40e50513          	addi	a0,a0,1038 # 6a90 <malloc+0xa08>
    168a:	00005097          	auipc	ra,0x5
    168e:	946080e7          	jalr	-1722(ra) # 5fd0 <printf>
        exit(1);
    1692:	4505                	li	a0,1
    1694:	00004097          	auipc	ra,0x4
    1698:	5cc080e7          	jalr	1484(ra) # 5c60 <exit>
    169c:	eca6                	sd	s1,88(sp)
    169e:	e4ce                	sd	s3,72(sp)
    16a0:	e0d2                	sd	s4,64(sp)
    16a2:	fc56                	sd	s5,56(sp)
    16a4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16a8:	00005a17          	auipc	s4,0x5
    16ac:	b78a0a13          	addi	s4,s4,-1160 # 6220 <malloc+0x198>
    int n = write(fd, "xxx", 3);
    16b0:	00005a97          	auipc	s5,0x5
    16b4:	400a8a93          	addi	s5,s5,1024 # 6ab0 <malloc+0xa28>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16b8:	60100593          	li	a1,1537
    16bc:	8552                	mv	a0,s4
    16be:	00004097          	auipc	ra,0x4
    16c2:	5e2080e7          	jalr	1506(ra) # 5ca0 <open>
    16c6:	84aa                	mv	s1,a0
    if(fd < 0){
    16c8:	04054763          	bltz	a0,1716 <truncate3+0x190>
    int n = write(fd, "xxx", 3);
    16cc:	460d                	li	a2,3
    16ce:	85d6                	mv	a1,s5
    16d0:	00004097          	auipc	ra,0x4
    16d4:	5b0080e7          	jalr	1456(ra) # 5c80 <write>
    if(n != 3){
    16d8:	478d                	li	a5,3
    16da:	04f51c63          	bne	a0,a5,1732 <truncate3+0x1ac>
    close(fd);
    16de:	8526                	mv	a0,s1
    16e0:	00004097          	auipc	ra,0x4
    16e4:	5a8080e7          	jalr	1448(ra) # 5c88 <close>
  for(int i = 0; i < 150; i++){
    16e8:	39fd                	addiw	s3,s3,-1
    16ea:	fc0997e3          	bnez	s3,16b8 <truncate3+0x132>
  wait(&xstatus);
    16ee:	fbc40513          	addi	a0,s0,-68
    16f2:	00004097          	auipc	ra,0x4
    16f6:	576080e7          	jalr	1398(ra) # 5c68 <wait>
  unlink("truncfile");
    16fa:	00005517          	auipc	a0,0x5
    16fe:	b2650513          	addi	a0,a0,-1242 # 6220 <malloc+0x198>
    1702:	00004097          	auipc	ra,0x4
    1706:	5ae080e7          	jalr	1454(ra) # 5cb0 <unlink>
  exit(xstatus);
    170a:	fbc42503          	lw	a0,-68(s0)
    170e:	00004097          	auipc	ra,0x4
    1712:	552080e7          	jalr	1362(ra) # 5c60 <exit>
      printf("%s: open failed\n", s);
    1716:	85ca                	mv	a1,s2
    1718:	00005517          	auipc	a0,0x5
    171c:	35050513          	addi	a0,a0,848 # 6a68 <malloc+0x9e0>
    1720:	00005097          	auipc	ra,0x5
    1724:	8b0080e7          	jalr	-1872(ra) # 5fd0 <printf>
      exit(1);
    1728:	4505                	li	a0,1
    172a:	00004097          	auipc	ra,0x4
    172e:	536080e7          	jalr	1334(ra) # 5c60 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1732:	862a                	mv	a2,a0
    1734:	85ca                	mv	a1,s2
    1736:	00005517          	auipc	a0,0x5
    173a:	38250513          	addi	a0,a0,898 # 6ab8 <malloc+0xa30>
    173e:	00005097          	auipc	ra,0x5
    1742:	892080e7          	jalr	-1902(ra) # 5fd0 <printf>
      exit(1);
    1746:	4505                	li	a0,1
    1748:	00004097          	auipc	ra,0x4
    174c:	518080e7          	jalr	1304(ra) # 5c60 <exit>

0000000000001750 <exectest>:
{
    1750:	715d                	addi	sp,sp,-80
    1752:	e486                	sd	ra,72(sp)
    1754:	e0a2                	sd	s0,64(sp)
    1756:	f84a                	sd	s2,48(sp)
    1758:	0880                	addi	s0,sp,80
    175a:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    175c:	00005797          	auipc	a5,0x5
    1760:	a6c78793          	addi	a5,a5,-1428 # 61c8 <malloc+0x140>
    1764:	fcf43023          	sd	a5,-64(s0)
    1768:	00005797          	auipc	a5,0x5
    176c:	37078793          	addi	a5,a5,880 # 6ad8 <malloc+0xa50>
    1770:	fcf43423          	sd	a5,-56(s0)
    1774:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1778:	00005517          	auipc	a0,0x5
    177c:	36850513          	addi	a0,a0,872 # 6ae0 <malloc+0xa58>
    1780:	00004097          	auipc	ra,0x4
    1784:	530080e7          	jalr	1328(ra) # 5cb0 <unlink>
  pid = fork();
    1788:	00004097          	auipc	ra,0x4
    178c:	4d0080e7          	jalr	1232(ra) # 5c58 <fork>
  if(pid < 0) {
    1790:	04054763          	bltz	a0,17de <exectest+0x8e>
    1794:	fc26                	sd	s1,56(sp)
    1796:	84aa                	mv	s1,a0
  if(pid == 0) {
    1798:	ed41                	bnez	a0,1830 <exectest+0xe0>
    close(1);
    179a:	4505                	li	a0,1
    179c:	00004097          	auipc	ra,0x4
    17a0:	4ec080e7          	jalr	1260(ra) # 5c88 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    17a4:	20100593          	li	a1,513
    17a8:	00005517          	auipc	a0,0x5
    17ac:	33850513          	addi	a0,a0,824 # 6ae0 <malloc+0xa58>
    17b0:	00004097          	auipc	ra,0x4
    17b4:	4f0080e7          	jalr	1264(ra) # 5ca0 <open>
    if(fd < 0) {
    17b8:	04054263          	bltz	a0,17fc <exectest+0xac>
    if(fd != 1) {
    17bc:	4785                	li	a5,1
    17be:	04f50d63          	beq	a0,a5,1818 <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    17c2:	85ca                	mv	a1,s2
    17c4:	00005517          	auipc	a0,0x5
    17c8:	33c50513          	addi	a0,a0,828 # 6b00 <malloc+0xa78>
    17cc:	00005097          	auipc	ra,0x5
    17d0:	804080e7          	jalr	-2044(ra) # 5fd0 <printf>
      exit(1);
    17d4:	4505                	li	a0,1
    17d6:	00004097          	auipc	ra,0x4
    17da:	48a080e7          	jalr	1162(ra) # 5c60 <exit>
    17de:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    17e0:	85ca                	mv	a1,s2
    17e2:	00005517          	auipc	a0,0x5
    17e6:	26e50513          	addi	a0,a0,622 # 6a50 <malloc+0x9c8>
    17ea:	00004097          	auipc	ra,0x4
    17ee:	7e6080e7          	jalr	2022(ra) # 5fd0 <printf>
     exit(1);
    17f2:	4505                	li	a0,1
    17f4:	00004097          	auipc	ra,0x4
    17f8:	46c080e7          	jalr	1132(ra) # 5c60 <exit>
      printf("%s: create failed\n", s);
    17fc:	85ca                	mv	a1,s2
    17fe:	00005517          	auipc	a0,0x5
    1802:	2ea50513          	addi	a0,a0,746 # 6ae8 <malloc+0xa60>
    1806:	00004097          	auipc	ra,0x4
    180a:	7ca080e7          	jalr	1994(ra) # 5fd0 <printf>
      exit(1);
    180e:	4505                	li	a0,1
    1810:	00004097          	auipc	ra,0x4
    1814:	450080e7          	jalr	1104(ra) # 5c60 <exit>
    if(exec("echo", echoargv) < 0){
    1818:	fc040593          	addi	a1,s0,-64
    181c:	00005517          	auipc	a0,0x5
    1820:	9ac50513          	addi	a0,a0,-1620 # 61c8 <malloc+0x140>
    1824:	00004097          	auipc	ra,0x4
    1828:	474080e7          	jalr	1140(ra) # 5c98 <exec>
    182c:	02054163          	bltz	a0,184e <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    1830:	fdc40513          	addi	a0,s0,-36
    1834:	00004097          	auipc	ra,0x4
    1838:	434080e7          	jalr	1076(ra) # 5c68 <wait>
    183c:	02951763          	bne	a0,s1,186a <exectest+0x11a>
  if(xstatus != 0)
    1840:	fdc42503          	lw	a0,-36(s0)
    1844:	cd0d                	beqz	a0,187e <exectest+0x12e>
    exit(xstatus);
    1846:	00004097          	auipc	ra,0x4
    184a:	41a080e7          	jalr	1050(ra) # 5c60 <exit>
      printf("%s: exec echo failed\n", s);
    184e:	85ca                	mv	a1,s2
    1850:	00005517          	auipc	a0,0x5
    1854:	2c050513          	addi	a0,a0,704 # 6b10 <malloc+0xa88>
    1858:	00004097          	auipc	ra,0x4
    185c:	778080e7          	jalr	1912(ra) # 5fd0 <printf>
      exit(1);
    1860:	4505                	li	a0,1
    1862:	00004097          	auipc	ra,0x4
    1866:	3fe080e7          	jalr	1022(ra) # 5c60 <exit>
    printf("%s: wait failed!\n", s);
    186a:	85ca                	mv	a1,s2
    186c:	00005517          	auipc	a0,0x5
    1870:	2bc50513          	addi	a0,a0,700 # 6b28 <malloc+0xaa0>
    1874:	00004097          	auipc	ra,0x4
    1878:	75c080e7          	jalr	1884(ra) # 5fd0 <printf>
    187c:	b7d1                	j	1840 <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    187e:	4581                	li	a1,0
    1880:	00005517          	auipc	a0,0x5
    1884:	26050513          	addi	a0,a0,608 # 6ae0 <malloc+0xa58>
    1888:	00004097          	auipc	ra,0x4
    188c:	418080e7          	jalr	1048(ra) # 5ca0 <open>
  if(fd < 0) {
    1890:	02054a63          	bltz	a0,18c4 <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    1894:	4609                	li	a2,2
    1896:	fb840593          	addi	a1,s0,-72
    189a:	00004097          	auipc	ra,0x4
    189e:	3de080e7          	jalr	990(ra) # 5c78 <read>
    18a2:	4789                	li	a5,2
    18a4:	02f50e63          	beq	a0,a5,18e0 <exectest+0x190>
    printf("%s: read failed\n", s);
    18a8:	85ca                	mv	a1,s2
    18aa:	00005517          	auipc	a0,0x5
    18ae:	cee50513          	addi	a0,a0,-786 # 6598 <malloc+0x510>
    18b2:	00004097          	auipc	ra,0x4
    18b6:	71e080e7          	jalr	1822(ra) # 5fd0 <printf>
    exit(1);
    18ba:	4505                	li	a0,1
    18bc:	00004097          	auipc	ra,0x4
    18c0:	3a4080e7          	jalr	932(ra) # 5c60 <exit>
    printf("%s: open failed\n", s);
    18c4:	85ca                	mv	a1,s2
    18c6:	00005517          	auipc	a0,0x5
    18ca:	1a250513          	addi	a0,a0,418 # 6a68 <malloc+0x9e0>
    18ce:	00004097          	auipc	ra,0x4
    18d2:	702080e7          	jalr	1794(ra) # 5fd0 <printf>
    exit(1);
    18d6:	4505                	li	a0,1
    18d8:	00004097          	auipc	ra,0x4
    18dc:	388080e7          	jalr	904(ra) # 5c60 <exit>
  unlink("echo-ok");
    18e0:	00005517          	auipc	a0,0x5
    18e4:	20050513          	addi	a0,a0,512 # 6ae0 <malloc+0xa58>
    18e8:	00004097          	auipc	ra,0x4
    18ec:	3c8080e7          	jalr	968(ra) # 5cb0 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18f0:	fb844703          	lbu	a4,-72(s0)
    18f4:	04f00793          	li	a5,79
    18f8:	00f71863          	bne	a4,a5,1908 <exectest+0x1b8>
    18fc:	fb944703          	lbu	a4,-71(s0)
    1900:	04b00793          	li	a5,75
    1904:	02f70063          	beq	a4,a5,1924 <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    1908:	85ca                	mv	a1,s2
    190a:	00005517          	auipc	a0,0x5
    190e:	23650513          	addi	a0,a0,566 # 6b40 <malloc+0xab8>
    1912:	00004097          	auipc	ra,0x4
    1916:	6be080e7          	jalr	1726(ra) # 5fd0 <printf>
    exit(1);
    191a:	4505                	li	a0,1
    191c:	00004097          	auipc	ra,0x4
    1920:	344080e7          	jalr	836(ra) # 5c60 <exit>
    exit(0);
    1924:	4501                	li	a0,0
    1926:	00004097          	auipc	ra,0x4
    192a:	33a080e7          	jalr	826(ra) # 5c60 <exit>

000000000000192e <pipe1>:
{
    192e:	711d                	addi	sp,sp,-96
    1930:	ec86                	sd	ra,88(sp)
    1932:	e8a2                	sd	s0,80(sp)
    1934:	fc4e                	sd	s3,56(sp)
    1936:	1080                	addi	s0,sp,96
    1938:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    193a:	fa840513          	addi	a0,s0,-88
    193e:	00004097          	auipc	ra,0x4
    1942:	332080e7          	jalr	818(ra) # 5c70 <pipe>
    1946:	ed3d                	bnez	a0,19c4 <pipe1+0x96>
    1948:	e4a6                	sd	s1,72(sp)
    194a:	f852                	sd	s4,48(sp)
    194c:	84aa                	mv	s1,a0
  pid = fork();
    194e:	00004097          	auipc	ra,0x4
    1952:	30a080e7          	jalr	778(ra) # 5c58 <fork>
    1956:	8a2a                	mv	s4,a0
  if(pid == 0){
    1958:	c951                	beqz	a0,19ec <pipe1+0xbe>
  } else if(pid > 0){
    195a:	18a05b63          	blez	a0,1af0 <pipe1+0x1c2>
    195e:	e0ca                	sd	s2,64(sp)
    1960:	f456                	sd	s5,40(sp)
    close(fds[1]);
    1962:	fac42503          	lw	a0,-84(s0)
    1966:	00004097          	auipc	ra,0x4
    196a:	322080e7          	jalr	802(ra) # 5c88 <close>
    total = 0;
    196e:	8a26                	mv	s4,s1
    cc = 1;
    1970:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1972:	0000ba97          	auipc	s5,0xb
    1976:	306a8a93          	addi	s5,s5,774 # cc78 <buf>
    197a:	864a                	mv	a2,s2
    197c:	85d6                	mv	a1,s5
    197e:	fa842503          	lw	a0,-88(s0)
    1982:	00004097          	auipc	ra,0x4
    1986:	2f6080e7          	jalr	758(ra) # 5c78 <read>
    198a:	10a05a63          	blez	a0,1a9e <pipe1+0x170>
      for(i = 0; i < n; i++){
    198e:	0000b717          	auipc	a4,0xb
    1992:	2ea70713          	addi	a4,a4,746 # cc78 <buf>
    1996:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    199a:	00074683          	lbu	a3,0(a4)
    199e:	0ff4f793          	zext.b	a5,s1
    19a2:	2485                	addiw	s1,s1,1
    19a4:	0cf69b63          	bne	a3,a5,1a7a <pipe1+0x14c>
      for(i = 0; i < n; i++){
    19a8:	0705                	addi	a4,a4,1
    19aa:	fec498e3          	bne	s1,a2,199a <pipe1+0x6c>
      total += n;
    19ae:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19b2:	0019179b          	slliw	a5,s2,0x1
    19b6:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    19ba:	670d                	lui	a4,0x3
    19bc:	fb277fe3          	bgeu	a4,s2,197a <pipe1+0x4c>
        cc = sizeof(buf);
    19c0:	690d                	lui	s2,0x3
    19c2:	bf65                	j	197a <pipe1+0x4c>
    19c4:	e4a6                	sd	s1,72(sp)
    19c6:	e0ca                	sd	s2,64(sp)
    19c8:	f852                	sd	s4,48(sp)
    19ca:	f456                	sd	s5,40(sp)
    19cc:	f05a                	sd	s6,32(sp)
    19ce:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    19d0:	85ce                	mv	a1,s3
    19d2:	00005517          	auipc	a0,0x5
    19d6:	18650513          	addi	a0,a0,390 # 6b58 <malloc+0xad0>
    19da:	00004097          	auipc	ra,0x4
    19de:	5f6080e7          	jalr	1526(ra) # 5fd0 <printf>
    exit(1);
    19e2:	4505                	li	a0,1
    19e4:	00004097          	auipc	ra,0x4
    19e8:	27c080e7          	jalr	636(ra) # 5c60 <exit>
    19ec:	e0ca                	sd	s2,64(sp)
    19ee:	f456                	sd	s5,40(sp)
    19f0:	f05a                	sd	s6,32(sp)
    19f2:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    19f4:	fa842503          	lw	a0,-88(s0)
    19f8:	00004097          	auipc	ra,0x4
    19fc:	290080e7          	jalr	656(ra) # 5c88 <close>
    for(n = 0; n < N; n++){
    1a00:	0000bb17          	auipc	s6,0xb
    1a04:	278b0b13          	addi	s6,s6,632 # cc78 <buf>
    1a08:	416004bb          	negw	s1,s6
    1a0c:	0ff4f493          	zext.b	s1,s1
    1a10:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a14:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a16:	6a85                	lui	s5,0x1
    1a18:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9d>
{
    1a1c:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a1e:	0097873b          	addw	a4,a5,s1
    1a22:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a26:	0785                	addi	a5,a5,1
    1a28:	ff279be3          	bne	a5,s2,1a1e <pipe1+0xf0>
    1a2c:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a30:	40900613          	li	a2,1033
    1a34:	85de                	mv	a1,s7
    1a36:	fac42503          	lw	a0,-84(s0)
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	246080e7          	jalr	582(ra) # 5c80 <write>
    1a42:	40900793          	li	a5,1033
    1a46:	00f51c63          	bne	a0,a5,1a5e <pipe1+0x130>
    for(n = 0; n < N; n++){
    1a4a:	24a5                	addiw	s1,s1,9
    1a4c:	0ff4f493          	zext.b	s1,s1
    1a50:	fd5a16e3          	bne	s4,s5,1a1c <pipe1+0xee>
    exit(0);
    1a54:	4501                	li	a0,0
    1a56:	00004097          	auipc	ra,0x4
    1a5a:	20a080e7          	jalr	522(ra) # 5c60 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a5e:	85ce                	mv	a1,s3
    1a60:	00005517          	auipc	a0,0x5
    1a64:	11050513          	addi	a0,a0,272 # 6b70 <malloc+0xae8>
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	568080e7          	jalr	1384(ra) # 5fd0 <printf>
        exit(1);
    1a70:	4505                	li	a0,1
    1a72:	00004097          	auipc	ra,0x4
    1a76:	1ee080e7          	jalr	494(ra) # 5c60 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a7a:	85ce                	mv	a1,s3
    1a7c:	00005517          	auipc	a0,0x5
    1a80:	10c50513          	addi	a0,a0,268 # 6b88 <malloc+0xb00>
    1a84:	00004097          	auipc	ra,0x4
    1a88:	54c080e7          	jalr	1356(ra) # 5fd0 <printf>
          return;
    1a8c:	64a6                	ld	s1,72(sp)
    1a8e:	6906                	ld	s2,64(sp)
    1a90:	7a42                	ld	s4,48(sp)
    1a92:	7aa2                	ld	s5,40(sp)
}
    1a94:	60e6                	ld	ra,88(sp)
    1a96:	6446                	ld	s0,80(sp)
    1a98:	79e2                	ld	s3,56(sp)
    1a9a:	6125                	addi	sp,sp,96
    1a9c:	8082                	ret
    if(total != N * SZ){
    1a9e:	6785                	lui	a5,0x1
    1aa0:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9d>
    1aa4:	02fa0263          	beq	s4,a5,1ac8 <pipe1+0x19a>
    1aa8:	f05a                	sd	s6,32(sp)
    1aaa:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    1aac:	85d2                	mv	a1,s4
    1aae:	00005517          	auipc	a0,0x5
    1ab2:	0f250513          	addi	a0,a0,242 # 6ba0 <malloc+0xb18>
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	51a080e7          	jalr	1306(ra) # 5fd0 <printf>
      exit(1);
    1abe:	4505                	li	a0,1
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	1a0080e7          	jalr	416(ra) # 5c60 <exit>
    1ac8:	f05a                	sd	s6,32(sp)
    1aca:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1acc:	fa842503          	lw	a0,-88(s0)
    1ad0:	00004097          	auipc	ra,0x4
    1ad4:	1b8080e7          	jalr	440(ra) # 5c88 <close>
    wait(&xstatus);
    1ad8:	fa440513          	addi	a0,s0,-92
    1adc:	00004097          	auipc	ra,0x4
    1ae0:	18c080e7          	jalr	396(ra) # 5c68 <wait>
    exit(xstatus);
    1ae4:	fa442503          	lw	a0,-92(s0)
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	178080e7          	jalr	376(ra) # 5c60 <exit>
    1af0:	e0ca                	sd	s2,64(sp)
    1af2:	f456                	sd	s5,40(sp)
    1af4:	f05a                	sd	s6,32(sp)
    1af6:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1af8:	85ce                	mv	a1,s3
    1afa:	00005517          	auipc	a0,0x5
    1afe:	0c650513          	addi	a0,a0,198 # 6bc0 <malloc+0xb38>
    1b02:	00004097          	auipc	ra,0x4
    1b06:	4ce080e7          	jalr	1230(ra) # 5fd0 <printf>
    exit(1);
    1b0a:	4505                	li	a0,1
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	154080e7          	jalr	340(ra) # 5c60 <exit>

0000000000001b14 <exitwait>:
{
    1b14:	7139                	addi	sp,sp,-64
    1b16:	fc06                	sd	ra,56(sp)
    1b18:	f822                	sd	s0,48(sp)
    1b1a:	f426                	sd	s1,40(sp)
    1b1c:	f04a                	sd	s2,32(sp)
    1b1e:	ec4e                	sd	s3,24(sp)
    1b20:	e852                	sd	s4,16(sp)
    1b22:	0080                	addi	s0,sp,64
    1b24:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b26:	4901                	li	s2,0
    1b28:	06400993          	li	s3,100
    pid = fork();
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	12c080e7          	jalr	300(ra) # 5c58 <fork>
    1b34:	84aa                	mv	s1,a0
    if(pid < 0){
    1b36:	02054a63          	bltz	a0,1b6a <exitwait+0x56>
    if(pid){
    1b3a:	c151                	beqz	a0,1bbe <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b3c:	fcc40513          	addi	a0,s0,-52
    1b40:	00004097          	auipc	ra,0x4
    1b44:	128080e7          	jalr	296(ra) # 5c68 <wait>
    1b48:	02951f63          	bne	a0,s1,1b86 <exitwait+0x72>
      if(i != xstate) {
    1b4c:	fcc42783          	lw	a5,-52(s0)
    1b50:	05279963          	bne	a5,s2,1ba2 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b54:	2905                	addiw	s2,s2,1 # 3001 <sbrk8000+0x25>
    1b56:	fd391be3          	bne	s2,s3,1b2c <exitwait+0x18>
}
    1b5a:	70e2                	ld	ra,56(sp)
    1b5c:	7442                	ld	s0,48(sp)
    1b5e:	74a2                	ld	s1,40(sp)
    1b60:	7902                	ld	s2,32(sp)
    1b62:	69e2                	ld	s3,24(sp)
    1b64:	6a42                	ld	s4,16(sp)
    1b66:	6121                	addi	sp,sp,64
    1b68:	8082                	ret
      printf("%s: fork failed\n", s);
    1b6a:	85d2                	mv	a1,s4
    1b6c:	00005517          	auipc	a0,0x5
    1b70:	ee450513          	addi	a0,a0,-284 # 6a50 <malloc+0x9c8>
    1b74:	00004097          	auipc	ra,0x4
    1b78:	45c080e7          	jalr	1116(ra) # 5fd0 <printf>
      exit(1);
    1b7c:	4505                	li	a0,1
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	0e2080e7          	jalr	226(ra) # 5c60 <exit>
        printf("%s: wait wrong pid\n", s);
    1b86:	85d2                	mv	a1,s4
    1b88:	00005517          	auipc	a0,0x5
    1b8c:	05050513          	addi	a0,a0,80 # 6bd8 <malloc+0xb50>
    1b90:	00004097          	auipc	ra,0x4
    1b94:	440080e7          	jalr	1088(ra) # 5fd0 <printf>
        exit(1);
    1b98:	4505                	li	a0,1
    1b9a:	00004097          	auipc	ra,0x4
    1b9e:	0c6080e7          	jalr	198(ra) # 5c60 <exit>
        printf("%s: wait wrong exit status\n", s);
    1ba2:	85d2                	mv	a1,s4
    1ba4:	00005517          	auipc	a0,0x5
    1ba8:	04c50513          	addi	a0,a0,76 # 6bf0 <malloc+0xb68>
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	424080e7          	jalr	1060(ra) # 5fd0 <printf>
        exit(1);
    1bb4:	4505                	li	a0,1
    1bb6:	00004097          	auipc	ra,0x4
    1bba:	0aa080e7          	jalr	170(ra) # 5c60 <exit>
      exit(i);
    1bbe:	854a                	mv	a0,s2
    1bc0:	00004097          	auipc	ra,0x4
    1bc4:	0a0080e7          	jalr	160(ra) # 5c60 <exit>

0000000000001bc8 <twochildren>:
{
    1bc8:	1101                	addi	sp,sp,-32
    1bca:	ec06                	sd	ra,24(sp)
    1bcc:	e822                	sd	s0,16(sp)
    1bce:	e426                	sd	s1,8(sp)
    1bd0:	e04a                	sd	s2,0(sp)
    1bd2:	1000                	addi	s0,sp,32
    1bd4:	892a                	mv	s2,a0
    1bd6:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bda:	00004097          	auipc	ra,0x4
    1bde:	07e080e7          	jalr	126(ra) # 5c58 <fork>
    if(pid1 < 0){
    1be2:	02054c63          	bltz	a0,1c1a <twochildren+0x52>
    if(pid1 == 0){
    1be6:	c921                	beqz	a0,1c36 <twochildren+0x6e>
      int pid2 = fork();
    1be8:	00004097          	auipc	ra,0x4
    1bec:	070080e7          	jalr	112(ra) # 5c58 <fork>
      if(pid2 < 0){
    1bf0:	04054763          	bltz	a0,1c3e <twochildren+0x76>
      if(pid2 == 0){
    1bf4:	c13d                	beqz	a0,1c5a <twochildren+0x92>
        wait(0);
    1bf6:	4501                	li	a0,0
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	070080e7          	jalr	112(ra) # 5c68 <wait>
        wait(0);
    1c00:	4501                	li	a0,0
    1c02:	00004097          	auipc	ra,0x4
    1c06:	066080e7          	jalr	102(ra) # 5c68 <wait>
  for(int i = 0; i < 1000; i++){
    1c0a:	34fd                	addiw	s1,s1,-1
    1c0c:	f4f9                	bnez	s1,1bda <twochildren+0x12>
}
    1c0e:	60e2                	ld	ra,24(sp)
    1c10:	6442                	ld	s0,16(sp)
    1c12:	64a2                	ld	s1,8(sp)
    1c14:	6902                	ld	s2,0(sp)
    1c16:	6105                	addi	sp,sp,32
    1c18:	8082                	ret
      printf("%s: fork failed\n", s);
    1c1a:	85ca                	mv	a1,s2
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	e3450513          	addi	a0,a0,-460 # 6a50 <malloc+0x9c8>
    1c24:	00004097          	auipc	ra,0x4
    1c28:	3ac080e7          	jalr	940(ra) # 5fd0 <printf>
      exit(1);
    1c2c:	4505                	li	a0,1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	032080e7          	jalr	50(ra) # 5c60 <exit>
      exit(0);
    1c36:	00004097          	auipc	ra,0x4
    1c3a:	02a080e7          	jalr	42(ra) # 5c60 <exit>
        printf("%s: fork failed\n", s);
    1c3e:	85ca                	mv	a1,s2
    1c40:	00005517          	auipc	a0,0x5
    1c44:	e1050513          	addi	a0,a0,-496 # 6a50 <malloc+0x9c8>
    1c48:	00004097          	auipc	ra,0x4
    1c4c:	388080e7          	jalr	904(ra) # 5fd0 <printf>
        exit(1);
    1c50:	4505                	li	a0,1
    1c52:	00004097          	auipc	ra,0x4
    1c56:	00e080e7          	jalr	14(ra) # 5c60 <exit>
        exit(0);
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	006080e7          	jalr	6(ra) # 5c60 <exit>

0000000000001c62 <forkfork>:
{
    1c62:	7179                	addi	sp,sp,-48
    1c64:	f406                	sd	ra,40(sp)
    1c66:	f022                	sd	s0,32(sp)
    1c68:	ec26                	sd	s1,24(sp)
    1c6a:	1800                	addi	s0,sp,48
    1c6c:	84aa                	mv	s1,a0
    int pid = fork();
    1c6e:	00004097          	auipc	ra,0x4
    1c72:	fea080e7          	jalr	-22(ra) # 5c58 <fork>
    if(pid < 0){
    1c76:	04054163          	bltz	a0,1cb8 <forkfork+0x56>
    if(pid == 0){
    1c7a:	cd29                	beqz	a0,1cd4 <forkfork+0x72>
    int pid = fork();
    1c7c:	00004097          	auipc	ra,0x4
    1c80:	fdc080e7          	jalr	-36(ra) # 5c58 <fork>
    if(pid < 0){
    1c84:	02054a63          	bltz	a0,1cb8 <forkfork+0x56>
    if(pid == 0){
    1c88:	c531                	beqz	a0,1cd4 <forkfork+0x72>
    wait(&xstatus);
    1c8a:	fdc40513          	addi	a0,s0,-36
    1c8e:	00004097          	auipc	ra,0x4
    1c92:	fda080e7          	jalr	-38(ra) # 5c68 <wait>
    if(xstatus != 0) {
    1c96:	fdc42783          	lw	a5,-36(s0)
    1c9a:	ebbd                	bnez	a5,1d10 <forkfork+0xae>
    wait(&xstatus);
    1c9c:	fdc40513          	addi	a0,s0,-36
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	fc8080e7          	jalr	-56(ra) # 5c68 <wait>
    if(xstatus != 0) {
    1ca8:	fdc42783          	lw	a5,-36(s0)
    1cac:	e3b5                	bnez	a5,1d10 <forkfork+0xae>
}
    1cae:	70a2                	ld	ra,40(sp)
    1cb0:	7402                	ld	s0,32(sp)
    1cb2:	64e2                	ld	s1,24(sp)
    1cb4:	6145                	addi	sp,sp,48
    1cb6:	8082                	ret
      printf("%s: fork failed", s);
    1cb8:	85a6                	mv	a1,s1
    1cba:	00005517          	auipc	a0,0x5
    1cbe:	f5650513          	addi	a0,a0,-170 # 6c10 <malloc+0xb88>
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	30e080e7          	jalr	782(ra) # 5fd0 <printf>
      exit(1);
    1cca:	4505                	li	a0,1
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	f94080e7          	jalr	-108(ra) # 5c60 <exit>
{
    1cd4:	0c800493          	li	s1,200
        int pid1 = fork();
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	f80080e7          	jalr	-128(ra) # 5c58 <fork>
        if(pid1 < 0){
    1ce0:	00054f63          	bltz	a0,1cfe <forkfork+0x9c>
        if(pid1 == 0){
    1ce4:	c115                	beqz	a0,1d08 <forkfork+0xa6>
        wait(0);
    1ce6:	4501                	li	a0,0
    1ce8:	00004097          	auipc	ra,0x4
    1cec:	f80080e7          	jalr	-128(ra) # 5c68 <wait>
      for(int j = 0; j < 200; j++){
    1cf0:	34fd                	addiw	s1,s1,-1
    1cf2:	f0fd                	bnez	s1,1cd8 <forkfork+0x76>
      exit(0);
    1cf4:	4501                	li	a0,0
    1cf6:	00004097          	auipc	ra,0x4
    1cfa:	f6a080e7          	jalr	-150(ra) # 5c60 <exit>
          exit(1);
    1cfe:	4505                	li	a0,1
    1d00:	00004097          	auipc	ra,0x4
    1d04:	f60080e7          	jalr	-160(ra) # 5c60 <exit>
          exit(0);
    1d08:	00004097          	auipc	ra,0x4
    1d0c:	f58080e7          	jalr	-168(ra) # 5c60 <exit>
      printf("%s: fork in child failed", s);
    1d10:	85a6                	mv	a1,s1
    1d12:	00005517          	auipc	a0,0x5
    1d16:	f0e50513          	addi	a0,a0,-242 # 6c20 <malloc+0xb98>
    1d1a:	00004097          	auipc	ra,0x4
    1d1e:	2b6080e7          	jalr	694(ra) # 5fd0 <printf>
      exit(1);
    1d22:	4505                	li	a0,1
    1d24:	00004097          	auipc	ra,0x4
    1d28:	f3c080e7          	jalr	-196(ra) # 5c60 <exit>

0000000000001d2c <reparent2>:
{
    1d2c:	1101                	addi	sp,sp,-32
    1d2e:	ec06                	sd	ra,24(sp)
    1d30:	e822                	sd	s0,16(sp)
    1d32:	e426                	sd	s1,8(sp)
    1d34:	1000                	addi	s0,sp,32
    1d36:	32000493          	li	s1,800
    int pid1 = fork();
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	f1e080e7          	jalr	-226(ra) # 5c58 <fork>
    if(pid1 < 0){
    1d42:	00054f63          	bltz	a0,1d60 <reparent2+0x34>
    if(pid1 == 0){
    1d46:	c915                	beqz	a0,1d7a <reparent2+0x4e>
    wait(0);
    1d48:	4501                	li	a0,0
    1d4a:	00004097          	auipc	ra,0x4
    1d4e:	f1e080e7          	jalr	-226(ra) # 5c68 <wait>
  for(int i = 0; i < 800; i++){
    1d52:	34fd                	addiw	s1,s1,-1
    1d54:	f0fd                	bnez	s1,1d3a <reparent2+0xe>
  exit(0);
    1d56:	4501                	li	a0,0
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	f08080e7          	jalr	-248(ra) # 5c60 <exit>
      printf("fork failed\n");
    1d60:	00005517          	auipc	a0,0x5
    1d64:	0f850513          	addi	a0,a0,248 # 6e58 <malloc+0xdd0>
    1d68:	00004097          	auipc	ra,0x4
    1d6c:	268080e7          	jalr	616(ra) # 5fd0 <printf>
      exit(1);
    1d70:	4505                	li	a0,1
    1d72:	00004097          	auipc	ra,0x4
    1d76:	eee080e7          	jalr	-274(ra) # 5c60 <exit>
      fork();
    1d7a:	00004097          	auipc	ra,0x4
    1d7e:	ede080e7          	jalr	-290(ra) # 5c58 <fork>
      fork();
    1d82:	00004097          	auipc	ra,0x4
    1d86:	ed6080e7          	jalr	-298(ra) # 5c58 <fork>
      exit(0);
    1d8a:	4501                	li	a0,0
    1d8c:	00004097          	auipc	ra,0x4
    1d90:	ed4080e7          	jalr	-300(ra) # 5c60 <exit>

0000000000001d94 <createdelete>:
{
    1d94:	7175                	addi	sp,sp,-144
    1d96:	e506                	sd	ra,136(sp)
    1d98:	e122                	sd	s0,128(sp)
    1d9a:	fca6                	sd	s1,120(sp)
    1d9c:	f8ca                	sd	s2,112(sp)
    1d9e:	f4ce                	sd	s3,104(sp)
    1da0:	f0d2                	sd	s4,96(sp)
    1da2:	ecd6                	sd	s5,88(sp)
    1da4:	e8da                	sd	s6,80(sp)
    1da6:	e4de                	sd	s7,72(sp)
    1da8:	e0e2                	sd	s8,64(sp)
    1daa:	fc66                	sd	s9,56(sp)
    1dac:	0900                	addi	s0,sp,144
    1dae:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1db0:	4901                	li	s2,0
    1db2:	4991                	li	s3,4
    pid = fork();
    1db4:	00004097          	auipc	ra,0x4
    1db8:	ea4080e7          	jalr	-348(ra) # 5c58 <fork>
    1dbc:	84aa                	mv	s1,a0
    if(pid < 0){
    1dbe:	02054f63          	bltz	a0,1dfc <createdelete+0x68>
    if(pid == 0){
    1dc2:	c939                	beqz	a0,1e18 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1dc4:	2905                	addiw	s2,s2,1
    1dc6:	ff3917e3          	bne	s2,s3,1db4 <createdelete+0x20>
    1dca:	4491                	li	s1,4
    wait(&xstatus);
    1dcc:	f7c40513          	addi	a0,s0,-132
    1dd0:	00004097          	auipc	ra,0x4
    1dd4:	e98080e7          	jalr	-360(ra) # 5c68 <wait>
    if(xstatus != 0)
    1dd8:	f7c42903          	lw	s2,-132(s0)
    1ddc:	0e091263          	bnez	s2,1ec0 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1de0:	34fd                	addiw	s1,s1,-1
    1de2:	f4ed                	bnez	s1,1dcc <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1de4:	f8040123          	sb	zero,-126(s0)
    1de8:	03000993          	li	s3,48
    1dec:	5a7d                	li	s4,-1
    1dee:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1df2:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1df4:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1df6:	07400a93          	li	s5,116
    1dfa:	a28d                	j	1f5c <createdelete+0x1c8>
      printf("fork failed\n", s);
    1dfc:	85e6                	mv	a1,s9
    1dfe:	00005517          	auipc	a0,0x5
    1e02:	05a50513          	addi	a0,a0,90 # 6e58 <malloc+0xdd0>
    1e06:	00004097          	auipc	ra,0x4
    1e0a:	1ca080e7          	jalr	458(ra) # 5fd0 <printf>
      exit(1);
    1e0e:	4505                	li	a0,1
    1e10:	00004097          	auipc	ra,0x4
    1e14:	e50080e7          	jalr	-432(ra) # 5c60 <exit>
      name[0] = 'p' + pi;
    1e18:	0709091b          	addiw	s2,s2,112
    1e1c:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e20:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e24:	4951                	li	s2,20
    1e26:	a015                	j	1e4a <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e28:	85e6                	mv	a1,s9
    1e2a:	00005517          	auipc	a0,0x5
    1e2e:	cbe50513          	addi	a0,a0,-834 # 6ae8 <malloc+0xa60>
    1e32:	00004097          	auipc	ra,0x4
    1e36:	19e080e7          	jalr	414(ra) # 5fd0 <printf>
          exit(1);
    1e3a:	4505                	li	a0,1
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	e24080e7          	jalr	-476(ra) # 5c60 <exit>
      for(i = 0; i < N; i++){
    1e44:	2485                	addiw	s1,s1,1
    1e46:	07248863          	beq	s1,s2,1eb6 <createdelete+0x122>
        name[1] = '0' + i;
    1e4a:	0304879b          	addiw	a5,s1,48
    1e4e:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e52:	20200593          	li	a1,514
    1e56:	f8040513          	addi	a0,s0,-128
    1e5a:	00004097          	auipc	ra,0x4
    1e5e:	e46080e7          	jalr	-442(ra) # 5ca0 <open>
        if(fd < 0){
    1e62:	fc0543e3          	bltz	a0,1e28 <createdelete+0x94>
        close(fd);
    1e66:	00004097          	auipc	ra,0x4
    1e6a:	e22080e7          	jalr	-478(ra) # 5c88 <close>
        if(i > 0 && (i % 2 ) == 0){
    1e6e:	12905763          	blez	s1,1f9c <createdelete+0x208>
    1e72:	0014f793          	andi	a5,s1,1
    1e76:	f7f9                	bnez	a5,1e44 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e78:	01f4d79b          	srliw	a5,s1,0x1f
    1e7c:	9fa5                	addw	a5,a5,s1
    1e7e:	4017d79b          	sraiw	a5,a5,0x1
    1e82:	0307879b          	addiw	a5,a5,48
    1e86:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e8a:	f8040513          	addi	a0,s0,-128
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	e22080e7          	jalr	-478(ra) # 5cb0 <unlink>
    1e96:	fa0557e3          	bgez	a0,1e44 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e9a:	85e6                	mv	a1,s9
    1e9c:	00005517          	auipc	a0,0x5
    1ea0:	da450513          	addi	a0,a0,-604 # 6c40 <malloc+0xbb8>
    1ea4:	00004097          	auipc	ra,0x4
    1ea8:	12c080e7          	jalr	300(ra) # 5fd0 <printf>
            exit(1);
    1eac:	4505                	li	a0,1
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	db2080e7          	jalr	-590(ra) # 5c60 <exit>
      exit(0);
    1eb6:	4501                	li	a0,0
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	da8080e7          	jalr	-600(ra) # 5c60 <exit>
      exit(1);
    1ec0:	4505                	li	a0,1
    1ec2:	00004097          	auipc	ra,0x4
    1ec6:	d9e080e7          	jalr	-610(ra) # 5c60 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1eca:	f8040613          	addi	a2,s0,-128
    1ece:	85e6                	mv	a1,s9
    1ed0:	00005517          	auipc	a0,0x5
    1ed4:	d8850513          	addi	a0,a0,-632 # 6c58 <malloc+0xbd0>
    1ed8:	00004097          	auipc	ra,0x4
    1edc:	0f8080e7          	jalr	248(ra) # 5fd0 <printf>
        exit(1);
    1ee0:	4505                	li	a0,1
    1ee2:	00004097          	auipc	ra,0x4
    1ee6:	d7e080e7          	jalr	-642(ra) # 5c60 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1eea:	034bff63          	bgeu	s7,s4,1f28 <createdelete+0x194>
      if(fd >= 0)
    1eee:	02055863          	bgez	a0,1f1e <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1ef2:	2485                	addiw	s1,s1,1
    1ef4:	0ff4f493          	zext.b	s1,s1
    1ef8:	05548a63          	beq	s1,s5,1f4c <createdelete+0x1b8>
      name[0] = 'p' + pi;
    1efc:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1f00:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1f04:	4581                	li	a1,0
    1f06:	f8040513          	addi	a0,s0,-128
    1f0a:	00004097          	auipc	ra,0x4
    1f0e:	d96080e7          	jalr	-618(ra) # 5ca0 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f12:	00090463          	beqz	s2,1f1a <createdelete+0x186>
    1f16:	fd2b5ae3          	bge	s6,s2,1eea <createdelete+0x156>
    1f1a:	fa0548e3          	bltz	a0,1eca <createdelete+0x136>
        close(fd);
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	d6a080e7          	jalr	-662(ra) # 5c88 <close>
    1f26:	b7f1                	j	1ef2 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f28:	fc0545e3          	bltz	a0,1ef2 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f2c:	f8040613          	addi	a2,s0,-128
    1f30:	85e6                	mv	a1,s9
    1f32:	00005517          	auipc	a0,0x5
    1f36:	d4e50513          	addi	a0,a0,-690 # 6c80 <malloc+0xbf8>
    1f3a:	00004097          	auipc	ra,0x4
    1f3e:	096080e7          	jalr	150(ra) # 5fd0 <printf>
        exit(1);
    1f42:	4505                	li	a0,1
    1f44:	00004097          	auipc	ra,0x4
    1f48:	d1c080e7          	jalr	-740(ra) # 5c60 <exit>
  for(i = 0; i < N; i++){
    1f4c:	2905                	addiw	s2,s2,1
    1f4e:	2a05                	addiw	s4,s4,1
    1f50:	2985                	addiw	s3,s3,1
    1f52:	0ff9f993          	zext.b	s3,s3
    1f56:	47d1                	li	a5,20
    1f58:	02f90a63          	beq	s2,a5,1f8c <createdelete+0x1f8>
    for(pi = 0; pi < NCHILD; pi++){
    1f5c:	84e2                	mv	s1,s8
    1f5e:	bf79                	j	1efc <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f60:	2905                	addiw	s2,s2,1
    1f62:	0ff97913          	zext.b	s2,s2
    1f66:	2985                	addiw	s3,s3,1
    1f68:	0ff9f993          	zext.b	s3,s3
    1f6c:	03490a63          	beq	s2,s4,1fa0 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f70:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f72:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f76:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f7a:	f8040513          	addi	a0,s0,-128
    1f7e:	00004097          	auipc	ra,0x4
    1f82:	d32080e7          	jalr	-718(ra) # 5cb0 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f86:	34fd                	addiw	s1,s1,-1
    1f88:	f4ed                	bnez	s1,1f72 <createdelete+0x1de>
    1f8a:	bfd9                	j	1f60 <createdelete+0x1cc>
    1f8c:	03000993          	li	s3,48
    1f90:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f94:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f96:	08400a13          	li	s4,132
    1f9a:	bfd9                	j	1f70 <createdelete+0x1dc>
      for(i = 0; i < N; i++){
    1f9c:	2485                	addiw	s1,s1,1
    1f9e:	b575                	j	1e4a <createdelete+0xb6>
}
    1fa0:	60aa                	ld	ra,136(sp)
    1fa2:	640a                	ld	s0,128(sp)
    1fa4:	74e6                	ld	s1,120(sp)
    1fa6:	7946                	ld	s2,112(sp)
    1fa8:	79a6                	ld	s3,104(sp)
    1faa:	7a06                	ld	s4,96(sp)
    1fac:	6ae6                	ld	s5,88(sp)
    1fae:	6b46                	ld	s6,80(sp)
    1fb0:	6ba6                	ld	s7,72(sp)
    1fb2:	6c06                	ld	s8,64(sp)
    1fb4:	7ce2                	ld	s9,56(sp)
    1fb6:	6149                	addi	sp,sp,144
    1fb8:	8082                	ret

0000000000001fba <linkunlink>:
{
    1fba:	711d                	addi	sp,sp,-96
    1fbc:	ec86                	sd	ra,88(sp)
    1fbe:	e8a2                	sd	s0,80(sp)
    1fc0:	e4a6                	sd	s1,72(sp)
    1fc2:	e0ca                	sd	s2,64(sp)
    1fc4:	fc4e                	sd	s3,56(sp)
    1fc6:	f852                	sd	s4,48(sp)
    1fc8:	f456                	sd	s5,40(sp)
    1fca:	f05a                	sd	s6,32(sp)
    1fcc:	ec5e                	sd	s7,24(sp)
    1fce:	e862                	sd	s8,16(sp)
    1fd0:	e466                	sd	s9,8(sp)
    1fd2:	1080                	addi	s0,sp,96
    1fd4:	84aa                	mv	s1,a0
  unlink("x");
    1fd6:	00004517          	auipc	a0,0x4
    1fda:	26250513          	addi	a0,a0,610 # 6238 <malloc+0x1b0>
    1fde:	00004097          	auipc	ra,0x4
    1fe2:	cd2080e7          	jalr	-814(ra) # 5cb0 <unlink>
  pid = fork();
    1fe6:	00004097          	auipc	ra,0x4
    1fea:	c72080e7          	jalr	-910(ra) # 5c58 <fork>
  if(pid < 0){
    1fee:	02054b63          	bltz	a0,2024 <linkunlink+0x6a>
    1ff2:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1ff4:	06100913          	li	s2,97
    1ff8:	c111                	beqz	a0,1ffc <linkunlink+0x42>
    1ffa:	4905                	li	s2,1
    1ffc:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2000:	41c65a37          	lui	s4,0x41c65
    2004:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c551f5>
    2008:	698d                	lui	s3,0x3
    200a:	0399899b          	addiw	s3,s3,57 # 3039 <execout+0x27>
    if((x % 3) == 0){
    200e:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    2010:	4b85                	li	s7,1
      unlink("x");
    2012:	00004b17          	auipc	s6,0x4
    2016:	226b0b13          	addi	s6,s6,550 # 6238 <malloc+0x1b0>
      link("cat", "x");
    201a:	00005c17          	auipc	s8,0x5
    201e:	c8ec0c13          	addi	s8,s8,-882 # 6ca8 <malloc+0xc20>
    2022:	a825                	j	205a <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    2024:	85a6                	mv	a1,s1
    2026:	00005517          	auipc	a0,0x5
    202a:	a2a50513          	addi	a0,a0,-1494 # 6a50 <malloc+0x9c8>
    202e:	00004097          	auipc	ra,0x4
    2032:	fa2080e7          	jalr	-94(ra) # 5fd0 <printf>
    exit(1);
    2036:	4505                	li	a0,1
    2038:	00004097          	auipc	ra,0x4
    203c:	c28080e7          	jalr	-984(ra) # 5c60 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2040:	20200593          	li	a1,514
    2044:	855a                	mv	a0,s6
    2046:	00004097          	auipc	ra,0x4
    204a:	c5a080e7          	jalr	-934(ra) # 5ca0 <open>
    204e:	00004097          	auipc	ra,0x4
    2052:	c3a080e7          	jalr	-966(ra) # 5c88 <close>
  for(i = 0; i < 100; i++){
    2056:	34fd                	addiw	s1,s1,-1
    2058:	c895                	beqz	s1,208c <linkunlink+0xd2>
    x = x * 1103515245 + 12345;
    205a:	034907bb          	mulw	a5,s2,s4
    205e:	013787bb          	addw	a5,a5,s3
    2062:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    2066:	0357f7bb          	remuw	a5,a5,s5
    206a:	2781                	sext.w	a5,a5
    206c:	dbf1                	beqz	a5,2040 <linkunlink+0x86>
    } else if((x % 3) == 1){
    206e:	01778863          	beq	a5,s7,207e <linkunlink+0xc4>
      unlink("x");
    2072:	855a                	mv	a0,s6
    2074:	00004097          	auipc	ra,0x4
    2078:	c3c080e7          	jalr	-964(ra) # 5cb0 <unlink>
    207c:	bfe9                	j	2056 <linkunlink+0x9c>
      link("cat", "x");
    207e:	85da                	mv	a1,s6
    2080:	8562                	mv	a0,s8
    2082:	00004097          	auipc	ra,0x4
    2086:	c3e080e7          	jalr	-962(ra) # 5cc0 <link>
    208a:	b7f1                	j	2056 <linkunlink+0x9c>
  if(pid)
    208c:	020c8463          	beqz	s9,20b4 <linkunlink+0xfa>
    wait(0);
    2090:	4501                	li	a0,0
    2092:	00004097          	auipc	ra,0x4
    2096:	bd6080e7          	jalr	-1066(ra) # 5c68 <wait>
}
    209a:	60e6                	ld	ra,88(sp)
    209c:	6446                	ld	s0,80(sp)
    209e:	64a6                	ld	s1,72(sp)
    20a0:	6906                	ld	s2,64(sp)
    20a2:	79e2                	ld	s3,56(sp)
    20a4:	7a42                	ld	s4,48(sp)
    20a6:	7aa2                	ld	s5,40(sp)
    20a8:	7b02                	ld	s6,32(sp)
    20aa:	6be2                	ld	s7,24(sp)
    20ac:	6c42                	ld	s8,16(sp)
    20ae:	6ca2                	ld	s9,8(sp)
    20b0:	6125                	addi	sp,sp,96
    20b2:	8082                	ret
    exit(0);
    20b4:	4501                	li	a0,0
    20b6:	00004097          	auipc	ra,0x4
    20ba:	baa080e7          	jalr	-1110(ra) # 5c60 <exit>

00000000000020be <forktest>:
{
    20be:	7179                	addi	sp,sp,-48
    20c0:	f406                	sd	ra,40(sp)
    20c2:	f022                	sd	s0,32(sp)
    20c4:	ec26                	sd	s1,24(sp)
    20c6:	e84a                	sd	s2,16(sp)
    20c8:	e44e                	sd	s3,8(sp)
    20ca:	1800                	addi	s0,sp,48
    20cc:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20ce:	4481                	li	s1,0
    20d0:	3e800913          	li	s2,1000
    pid = fork();
    20d4:	00004097          	auipc	ra,0x4
    20d8:	b84080e7          	jalr	-1148(ra) # 5c58 <fork>
    if(pid < 0)
    20dc:	08054263          	bltz	a0,2160 <forktest+0xa2>
    if(pid == 0)
    20e0:	c115                	beqz	a0,2104 <forktest+0x46>
  for(n=0; n<N; n++){
    20e2:	2485                	addiw	s1,s1,1
    20e4:	ff2498e3          	bne	s1,s2,20d4 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20e8:	85ce                	mv	a1,s3
    20ea:	00005517          	auipc	a0,0x5
    20ee:	c0e50513          	addi	a0,a0,-1010 # 6cf8 <malloc+0xc70>
    20f2:	00004097          	auipc	ra,0x4
    20f6:	ede080e7          	jalr	-290(ra) # 5fd0 <printf>
    exit(1);
    20fa:	4505                	li	a0,1
    20fc:	00004097          	auipc	ra,0x4
    2100:	b64080e7          	jalr	-1180(ra) # 5c60 <exit>
      exit(0);
    2104:	00004097          	auipc	ra,0x4
    2108:	b5c080e7          	jalr	-1188(ra) # 5c60 <exit>
    printf("%s: no fork at all!\n", s);
    210c:	85ce                	mv	a1,s3
    210e:	00005517          	auipc	a0,0x5
    2112:	ba250513          	addi	a0,a0,-1118 # 6cb0 <malloc+0xc28>
    2116:	00004097          	auipc	ra,0x4
    211a:	eba080e7          	jalr	-326(ra) # 5fd0 <printf>
    exit(1);
    211e:	4505                	li	a0,1
    2120:	00004097          	auipc	ra,0x4
    2124:	b40080e7          	jalr	-1216(ra) # 5c60 <exit>
      printf("%s: wait stopped early\n", s);
    2128:	85ce                	mv	a1,s3
    212a:	00005517          	auipc	a0,0x5
    212e:	b9e50513          	addi	a0,a0,-1122 # 6cc8 <malloc+0xc40>
    2132:	00004097          	auipc	ra,0x4
    2136:	e9e080e7          	jalr	-354(ra) # 5fd0 <printf>
      exit(1);
    213a:	4505                	li	a0,1
    213c:	00004097          	auipc	ra,0x4
    2140:	b24080e7          	jalr	-1244(ra) # 5c60 <exit>
    printf("%s: wait got too many\n", s);
    2144:	85ce                	mv	a1,s3
    2146:	00005517          	auipc	a0,0x5
    214a:	b9a50513          	addi	a0,a0,-1126 # 6ce0 <malloc+0xc58>
    214e:	00004097          	auipc	ra,0x4
    2152:	e82080e7          	jalr	-382(ra) # 5fd0 <printf>
    exit(1);
    2156:	4505                	li	a0,1
    2158:	00004097          	auipc	ra,0x4
    215c:	b08080e7          	jalr	-1272(ra) # 5c60 <exit>
  if (n == 0) {
    2160:	d4d5                	beqz	s1,210c <forktest+0x4e>
  for(; n > 0; n--){
    2162:	00905b63          	blez	s1,2178 <forktest+0xba>
    if(wait(0) < 0){
    2166:	4501                	li	a0,0
    2168:	00004097          	auipc	ra,0x4
    216c:	b00080e7          	jalr	-1280(ra) # 5c68 <wait>
    2170:	fa054ce3          	bltz	a0,2128 <forktest+0x6a>
  for(; n > 0; n--){
    2174:	34fd                	addiw	s1,s1,-1
    2176:	f8e5                	bnez	s1,2166 <forktest+0xa8>
  if(wait(0) != -1){
    2178:	4501                	li	a0,0
    217a:	00004097          	auipc	ra,0x4
    217e:	aee080e7          	jalr	-1298(ra) # 5c68 <wait>
    2182:	57fd                	li	a5,-1
    2184:	fcf510e3          	bne	a0,a5,2144 <forktest+0x86>
}
    2188:	70a2                	ld	ra,40(sp)
    218a:	7402                	ld	s0,32(sp)
    218c:	64e2                	ld	s1,24(sp)
    218e:	6942                	ld	s2,16(sp)
    2190:	69a2                	ld	s3,8(sp)
    2192:	6145                	addi	sp,sp,48
    2194:	8082                	ret

0000000000002196 <kernmem>:
{
    2196:	715d                	addi	sp,sp,-80
    2198:	e486                	sd	ra,72(sp)
    219a:	e0a2                	sd	s0,64(sp)
    219c:	fc26                	sd	s1,56(sp)
    219e:	f84a                	sd	s2,48(sp)
    21a0:	f44e                	sd	s3,40(sp)
    21a2:	f052                	sd	s4,32(sp)
    21a4:	ec56                	sd	s5,24(sp)
    21a6:	0880                	addi	s0,sp,80
    21a8:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21aa:	4485                	li	s1,1
    21ac:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    21ae:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21b0:	69b1                	lui	s3,0xc
    21b2:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    21b6:	1003d937          	lui	s2,0x1003d
    21ba:	090e                	slli	s2,s2,0x3
    21bc:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21c0:	00004097          	auipc	ra,0x4
    21c4:	a98080e7          	jalr	-1384(ra) # 5c58 <fork>
    if(pid < 0){
    21c8:	02054963          	bltz	a0,21fa <kernmem+0x64>
    if(pid == 0){
    21cc:	c529                	beqz	a0,2216 <kernmem+0x80>
    wait(&xstatus);
    21ce:	fbc40513          	addi	a0,s0,-68
    21d2:	00004097          	auipc	ra,0x4
    21d6:	a96080e7          	jalr	-1386(ra) # 5c68 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21da:	fbc42783          	lw	a5,-68(s0)
    21de:	05479d63          	bne	a5,s4,2238 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21e2:	94ce                	add	s1,s1,s3
    21e4:	fd249ee3          	bne	s1,s2,21c0 <kernmem+0x2a>
}
    21e8:	60a6                	ld	ra,72(sp)
    21ea:	6406                	ld	s0,64(sp)
    21ec:	74e2                	ld	s1,56(sp)
    21ee:	7942                	ld	s2,48(sp)
    21f0:	79a2                	ld	s3,40(sp)
    21f2:	7a02                	ld	s4,32(sp)
    21f4:	6ae2                	ld	s5,24(sp)
    21f6:	6161                	addi	sp,sp,80
    21f8:	8082                	ret
      printf("%s: fork failed\n", s);
    21fa:	85d6                	mv	a1,s5
    21fc:	00005517          	auipc	a0,0x5
    2200:	85450513          	addi	a0,a0,-1964 # 6a50 <malloc+0x9c8>
    2204:	00004097          	auipc	ra,0x4
    2208:	dcc080e7          	jalr	-564(ra) # 5fd0 <printf>
      exit(1);
    220c:	4505                	li	a0,1
    220e:	00004097          	auipc	ra,0x4
    2212:	a52080e7          	jalr	-1454(ra) # 5c60 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2216:	0004c683          	lbu	a3,0(s1)
    221a:	8626                	mv	a2,s1
    221c:	85d6                	mv	a1,s5
    221e:	00005517          	auipc	a0,0x5
    2222:	b0250513          	addi	a0,a0,-1278 # 6d20 <malloc+0xc98>
    2226:	00004097          	auipc	ra,0x4
    222a:	daa080e7          	jalr	-598(ra) # 5fd0 <printf>
      exit(1);
    222e:	4505                	li	a0,1
    2230:	00004097          	auipc	ra,0x4
    2234:	a30080e7          	jalr	-1488(ra) # 5c60 <exit>
      exit(1);
    2238:	4505                	li	a0,1
    223a:	00004097          	auipc	ra,0x4
    223e:	a26080e7          	jalr	-1498(ra) # 5c60 <exit>

0000000000002242 <MAXVAplus>:
{
    2242:	7179                	addi	sp,sp,-48
    2244:	f406                	sd	ra,40(sp)
    2246:	f022                	sd	s0,32(sp)
    2248:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    224a:	4785                	li	a5,1
    224c:	179a                	slli	a5,a5,0x26
    224e:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2252:	fd843783          	ld	a5,-40(s0)
    2256:	c3a1                	beqz	a5,2296 <MAXVAplus+0x54>
    2258:	ec26                	sd	s1,24(sp)
    225a:	e84a                	sd	s2,16(sp)
    225c:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    225e:	54fd                	li	s1,-1
    pid = fork();
    2260:	00004097          	auipc	ra,0x4
    2264:	9f8080e7          	jalr	-1544(ra) # 5c58 <fork>
    if(pid < 0){
    2268:	02054b63          	bltz	a0,229e <MAXVAplus+0x5c>
    if(pid == 0){
    226c:	c539                	beqz	a0,22ba <MAXVAplus+0x78>
    wait(&xstatus);
    226e:	fd440513          	addi	a0,s0,-44
    2272:	00004097          	auipc	ra,0x4
    2276:	9f6080e7          	jalr	-1546(ra) # 5c68 <wait>
    if(xstatus != -1)  // did kernel kill child?
    227a:	fd442783          	lw	a5,-44(s0)
    227e:	06979463          	bne	a5,s1,22e6 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2282:	fd843783          	ld	a5,-40(s0)
    2286:	0786                	slli	a5,a5,0x1
    2288:	fcf43c23          	sd	a5,-40(s0)
    228c:	fd843783          	ld	a5,-40(s0)
    2290:	fbe1                	bnez	a5,2260 <MAXVAplus+0x1e>
    2292:	64e2                	ld	s1,24(sp)
    2294:	6942                	ld	s2,16(sp)
}
    2296:	70a2                	ld	ra,40(sp)
    2298:	7402                	ld	s0,32(sp)
    229a:	6145                	addi	sp,sp,48
    229c:	8082                	ret
      printf("%s: fork failed\n", s);
    229e:	85ca                	mv	a1,s2
    22a0:	00004517          	auipc	a0,0x4
    22a4:	7b050513          	addi	a0,a0,1968 # 6a50 <malloc+0x9c8>
    22a8:	00004097          	auipc	ra,0x4
    22ac:	d28080e7          	jalr	-728(ra) # 5fd0 <printf>
      exit(1);
    22b0:	4505                	li	a0,1
    22b2:	00004097          	auipc	ra,0x4
    22b6:	9ae080e7          	jalr	-1618(ra) # 5c60 <exit>
      *(char*)a = 99;
    22ba:	fd843783          	ld	a5,-40(s0)
    22be:	06300713          	li	a4,99
    22c2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22c6:	fd843603          	ld	a2,-40(s0)
    22ca:	85ca                	mv	a1,s2
    22cc:	00005517          	auipc	a0,0x5
    22d0:	a7450513          	addi	a0,a0,-1420 # 6d40 <malloc+0xcb8>
    22d4:	00004097          	auipc	ra,0x4
    22d8:	cfc080e7          	jalr	-772(ra) # 5fd0 <printf>
      exit(1);
    22dc:	4505                	li	a0,1
    22de:	00004097          	auipc	ra,0x4
    22e2:	982080e7          	jalr	-1662(ra) # 5c60 <exit>
      exit(1);
    22e6:	4505                	li	a0,1
    22e8:	00004097          	auipc	ra,0x4
    22ec:	978080e7          	jalr	-1672(ra) # 5c60 <exit>

00000000000022f0 <bigargtest>:
{
    22f0:	7179                	addi	sp,sp,-48
    22f2:	f406                	sd	ra,40(sp)
    22f4:	f022                	sd	s0,32(sp)
    22f6:	ec26                	sd	s1,24(sp)
    22f8:	1800                	addi	s0,sp,48
    22fa:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22fc:	00005517          	auipc	a0,0x5
    2300:	a5c50513          	addi	a0,a0,-1444 # 6d58 <malloc+0xcd0>
    2304:	00004097          	auipc	ra,0x4
    2308:	9ac080e7          	jalr	-1620(ra) # 5cb0 <unlink>
  pid = fork();
    230c:	00004097          	auipc	ra,0x4
    2310:	94c080e7          	jalr	-1716(ra) # 5c58 <fork>
  if(pid == 0){
    2314:	c121                	beqz	a0,2354 <bigargtest+0x64>
  } else if(pid < 0){
    2316:	0a054063          	bltz	a0,23b6 <bigargtest+0xc6>
  wait(&xstatus);
    231a:	fdc40513          	addi	a0,s0,-36
    231e:	00004097          	auipc	ra,0x4
    2322:	94a080e7          	jalr	-1718(ra) # 5c68 <wait>
  if(xstatus != 0)
    2326:	fdc42503          	lw	a0,-36(s0)
    232a:	e545                	bnez	a0,23d2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    232c:	4581                	li	a1,0
    232e:	00005517          	auipc	a0,0x5
    2332:	a2a50513          	addi	a0,a0,-1494 # 6d58 <malloc+0xcd0>
    2336:	00004097          	auipc	ra,0x4
    233a:	96a080e7          	jalr	-1686(ra) # 5ca0 <open>
  if(fd < 0){
    233e:	08054e63          	bltz	a0,23da <bigargtest+0xea>
  close(fd);
    2342:	00004097          	auipc	ra,0x4
    2346:	946080e7          	jalr	-1722(ra) # 5c88 <close>
}
    234a:	70a2                	ld	ra,40(sp)
    234c:	7402                	ld	s0,32(sp)
    234e:	64e2                	ld	s1,24(sp)
    2350:	6145                	addi	sp,sp,48
    2352:	8082                	ret
    2354:	00007797          	auipc	a5,0x7
    2358:	10c78793          	addi	a5,a5,268 # 9460 <args.1>
    235c:	00007697          	auipc	a3,0x7
    2360:	1fc68693          	addi	a3,a3,508 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2364:	00005717          	auipc	a4,0x5
    2368:	a0470713          	addi	a4,a4,-1532 # 6d68 <malloc+0xce0>
    236c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    236e:	07a1                	addi	a5,a5,8
    2370:	fed79ee3          	bne	a5,a3,236c <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2374:	00007597          	auipc	a1,0x7
    2378:	0ec58593          	addi	a1,a1,236 # 9460 <args.1>
    237c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2380:	00004517          	auipc	a0,0x4
    2384:	e4850513          	addi	a0,a0,-440 # 61c8 <malloc+0x140>
    2388:	00004097          	auipc	ra,0x4
    238c:	910080e7          	jalr	-1776(ra) # 5c98 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2390:	20000593          	li	a1,512
    2394:	00005517          	auipc	a0,0x5
    2398:	9c450513          	addi	a0,a0,-1596 # 6d58 <malloc+0xcd0>
    239c:	00004097          	auipc	ra,0x4
    23a0:	904080e7          	jalr	-1788(ra) # 5ca0 <open>
    close(fd);
    23a4:	00004097          	auipc	ra,0x4
    23a8:	8e4080e7          	jalr	-1820(ra) # 5c88 <close>
    exit(0);
    23ac:	4501                	li	a0,0
    23ae:	00004097          	auipc	ra,0x4
    23b2:	8b2080e7          	jalr	-1870(ra) # 5c60 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23b6:	85a6                	mv	a1,s1
    23b8:	00005517          	auipc	a0,0x5
    23bc:	a9050513          	addi	a0,a0,-1392 # 6e48 <malloc+0xdc0>
    23c0:	00004097          	auipc	ra,0x4
    23c4:	c10080e7          	jalr	-1008(ra) # 5fd0 <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00004097          	auipc	ra,0x4
    23ce:	896080e7          	jalr	-1898(ra) # 5c60 <exit>
    exit(xstatus);
    23d2:	00004097          	auipc	ra,0x4
    23d6:	88e080e7          	jalr	-1906(ra) # 5c60 <exit>
    printf("%s: bigarg test failed!\n", s);
    23da:	85a6                	mv	a1,s1
    23dc:	00005517          	auipc	a0,0x5
    23e0:	a8c50513          	addi	a0,a0,-1396 # 6e68 <malloc+0xde0>
    23e4:	00004097          	auipc	ra,0x4
    23e8:	bec080e7          	jalr	-1044(ra) # 5fd0 <printf>
    exit(1);
    23ec:	4505                	li	a0,1
    23ee:	00004097          	auipc	ra,0x4
    23f2:	872080e7          	jalr	-1934(ra) # 5c60 <exit>

00000000000023f6 <stacktest>:
{
    23f6:	7179                	addi	sp,sp,-48
    23f8:	f406                	sd	ra,40(sp)
    23fa:	f022                	sd	s0,32(sp)
    23fc:	ec26                	sd	s1,24(sp)
    23fe:	1800                	addi	s0,sp,48
    2400:	84aa                	mv	s1,a0
  pid = fork();
    2402:	00004097          	auipc	ra,0x4
    2406:	856080e7          	jalr	-1962(ra) # 5c58 <fork>
  if(pid == 0) {
    240a:	c115                	beqz	a0,242e <stacktest+0x38>
  } else if(pid < 0){
    240c:	04054463          	bltz	a0,2454 <stacktest+0x5e>
  wait(&xstatus);
    2410:	fdc40513          	addi	a0,s0,-36
    2414:	00004097          	auipc	ra,0x4
    2418:	854080e7          	jalr	-1964(ra) # 5c68 <wait>
  if(xstatus == -1)  // kernel killed child?
    241c:	fdc42503          	lw	a0,-36(s0)
    2420:	57fd                	li	a5,-1
    2422:	04f50763          	beq	a0,a5,2470 <stacktest+0x7a>
    exit(xstatus);
    2426:	00004097          	auipc	ra,0x4
    242a:	83a080e7          	jalr	-1990(ra) # 5c60 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    242e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2430:	77fd                	lui	a5,0xfffff
    2432:	97ba                	add	a5,a5,a4
    2434:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2438:	85a6                	mv	a1,s1
    243a:	00005517          	auipc	a0,0x5
    243e:	a4e50513          	addi	a0,a0,-1458 # 6e88 <malloc+0xe00>
    2442:	00004097          	auipc	ra,0x4
    2446:	b8e080e7          	jalr	-1138(ra) # 5fd0 <printf>
    exit(1);
    244a:	4505                	li	a0,1
    244c:	00004097          	auipc	ra,0x4
    2450:	814080e7          	jalr	-2028(ra) # 5c60 <exit>
    printf("%s: fork failed\n", s);
    2454:	85a6                	mv	a1,s1
    2456:	00004517          	auipc	a0,0x4
    245a:	5fa50513          	addi	a0,a0,1530 # 6a50 <malloc+0x9c8>
    245e:	00004097          	auipc	ra,0x4
    2462:	b72080e7          	jalr	-1166(ra) # 5fd0 <printf>
    exit(1);
    2466:	4505                	li	a0,1
    2468:	00003097          	auipc	ra,0x3
    246c:	7f8080e7          	jalr	2040(ra) # 5c60 <exit>
    exit(0);
    2470:	4501                	li	a0,0
    2472:	00003097          	auipc	ra,0x3
    2476:	7ee080e7          	jalr	2030(ra) # 5c60 <exit>

000000000000247a <textwrite>:
{
    247a:	7179                	addi	sp,sp,-48
    247c:	f406                	sd	ra,40(sp)
    247e:	f022                	sd	s0,32(sp)
    2480:	ec26                	sd	s1,24(sp)
    2482:	1800                	addi	s0,sp,48
    2484:	84aa                	mv	s1,a0
  printf("textwrite: starting test\n");
    2486:	00005517          	auipc	a0,0x5
    248a:	a2a50513          	addi	a0,a0,-1494 # 6eb0 <malloc+0xe28>
    248e:	00004097          	auipc	ra,0x4
    2492:	b42080e7          	jalr	-1214(ra) # 5fd0 <printf>
  pid = fork();
    2496:	00003097          	auipc	ra,0x3
    249a:	7c2080e7          	jalr	1986(ra) # 5c58 <fork>
  if(pid == 0) {
    249e:	c521                	beqz	a0,24e6 <textwrite+0x6c>
  } else if(pid < 0){
    24a0:	08054363          	bltz	a0,2526 <textwrite+0xac>
  printf("textwrite: parent waiting for child\n");
    24a4:	00005517          	auipc	a0,0x5
    24a8:	ac450513          	addi	a0,a0,-1340 # 6f68 <malloc+0xee0>
    24ac:	00004097          	auipc	ra,0x4
    24b0:	b24080e7          	jalr	-1244(ra) # 5fd0 <printf>
  wait(&xstatus);
    24b4:	fdc40513          	addi	a0,s0,-36
    24b8:	00003097          	auipc	ra,0x3
    24bc:	7b0080e7          	jalr	1968(ra) # 5c68 <wait>
  printf("textwrite: child exited with status %d\n", xstatus);
    24c0:	fdc42583          	lw	a1,-36(s0)
    24c4:	00005517          	auipc	a0,0x5
    24c8:	acc50513          	addi	a0,a0,-1332 # 6f90 <malloc+0xf08>
    24cc:	00004097          	auipc	ra,0x4
    24d0:	b04080e7          	jalr	-1276(ra) # 5fd0 <printf>
  if(xstatus == -1)  // kernel killed child?
    24d4:	fdc42503          	lw	a0,-36(s0)
    24d8:	57fd                	li	a5,-1
    24da:	06f50463          	beq	a0,a5,2542 <textwrite+0xc8>
    exit(xstatus);
    24de:	00003097          	auipc	ra,0x3
    24e2:	782080e7          	jalr	1922(ra) # 5c60 <exit>
    printf("textwrite: child process started\n");
    24e6:	00005517          	auipc	a0,0x5
    24ea:	9ea50513          	addi	a0,a0,-1558 # 6ed0 <malloc+0xe48>
    24ee:	00004097          	auipc	ra,0x4
    24f2:	ae2080e7          	jalr	-1310(ra) # 5fd0 <printf>
    printf("textwrite: child attempting to write to address 0\n");
    24f6:	00005517          	auipc	a0,0x5
    24fa:	a0250513          	addi	a0,a0,-1534 # 6ef8 <malloc+0xe70>
    24fe:	00004097          	auipc	ra,0x4
    2502:	ad2080e7          	jalr	-1326(ra) # 5fd0 <printf>
    *addr = 10;
    2506:	47a9                	li	a5,10
    2508:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    printf("textwrite: child write successful (unexpected!)\n");
    250c:	00005517          	auipc	a0,0x5
    2510:	a2450513          	addi	a0,a0,-1500 # 6f30 <malloc+0xea8>
    2514:	00004097          	auipc	ra,0x4
    2518:	abc080e7          	jalr	-1348(ra) # 5fd0 <printf>
    exit(1);
    251c:	4505                	li	a0,1
    251e:	00003097          	auipc	ra,0x3
    2522:	742080e7          	jalr	1858(ra) # 5c60 <exit>
    printf("%s: fork failed\n", s);
    2526:	85a6                	mv	a1,s1
    2528:	00004517          	auipc	a0,0x4
    252c:	52850513          	addi	a0,a0,1320 # 6a50 <malloc+0x9c8>
    2530:	00004097          	auipc	ra,0x4
    2534:	aa0080e7          	jalr	-1376(ra) # 5fd0 <printf>
    exit(1);
    2538:	4505                	li	a0,1
    253a:	00003097          	auipc	ra,0x3
    253e:	726080e7          	jalr	1830(ra) # 5c60 <exit>
    exit(0);
    2542:	4501                	li	a0,0
    2544:	00003097          	auipc	ra,0x3
    2548:	71c080e7          	jalr	1820(ra) # 5c60 <exit>

000000000000254c <manywrites>:
{
    254c:	711d                	addi	sp,sp,-96
    254e:	ec86                	sd	ra,88(sp)
    2550:	e8a2                	sd	s0,80(sp)
    2552:	e4a6                	sd	s1,72(sp)
    2554:	e0ca                	sd	s2,64(sp)
    2556:	fc4e                	sd	s3,56(sp)
    2558:	f456                	sd	s5,40(sp)
    255a:	1080                	addi	s0,sp,96
    255c:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    255e:	4981                	li	s3,0
    2560:	4911                	li	s2,4
    int pid = fork();
    2562:	00003097          	auipc	ra,0x3
    2566:	6f6080e7          	jalr	1782(ra) # 5c58 <fork>
    256a:	84aa                	mv	s1,a0
    if(pid < 0){
    256c:	02054d63          	bltz	a0,25a6 <manywrites+0x5a>
    if(pid == 0){
    2570:	c939                	beqz	a0,25c6 <manywrites+0x7a>
  for(int ci = 0; ci < nchildren; ci++){
    2572:	2985                	addiw	s3,s3,1
    2574:	ff2997e3          	bne	s3,s2,2562 <manywrites+0x16>
    2578:	f852                	sd	s4,48(sp)
    257a:	f05a                	sd	s6,32(sp)
    257c:	ec5e                	sd	s7,24(sp)
    257e:	4491                	li	s1,4
    int st = 0;
    2580:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2584:	fa840513          	addi	a0,s0,-88
    2588:	00003097          	auipc	ra,0x3
    258c:	6e0080e7          	jalr	1760(ra) # 5c68 <wait>
    if(st != 0)
    2590:	fa842503          	lw	a0,-88(s0)
    2594:	10051463          	bnez	a0,269c <manywrites+0x150>
  for(int ci = 0; ci < nchildren; ci++){
    2598:	34fd                	addiw	s1,s1,-1
    259a:	f0fd                	bnez	s1,2580 <manywrites+0x34>
  exit(0);
    259c:	4501                	li	a0,0
    259e:	00003097          	auipc	ra,0x3
    25a2:	6c2080e7          	jalr	1730(ra) # 5c60 <exit>
    25a6:	f852                	sd	s4,48(sp)
    25a8:	f05a                	sd	s6,32(sp)
    25aa:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    25ac:	00005517          	auipc	a0,0x5
    25b0:	8ac50513          	addi	a0,a0,-1876 # 6e58 <malloc+0xdd0>
    25b4:	00004097          	auipc	ra,0x4
    25b8:	a1c080e7          	jalr	-1508(ra) # 5fd0 <printf>
      exit(1);
    25bc:	4505                	li	a0,1
    25be:	00003097          	auipc	ra,0x3
    25c2:	6a2080e7          	jalr	1698(ra) # 5c60 <exit>
    25c6:	f852                	sd	s4,48(sp)
    25c8:	f05a                	sd	s6,32(sp)
    25ca:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    25cc:	06200793          	li	a5,98
    25d0:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    25d4:	0619879b          	addiw	a5,s3,97
    25d8:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    25dc:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    25e0:	fa840513          	addi	a0,s0,-88
    25e4:	00003097          	auipc	ra,0x3
    25e8:	6cc080e7          	jalr	1740(ra) # 5cb0 <unlink>
    25ec:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    25ee:	0000ab17          	auipc	s6,0xa
    25f2:	68ab0b13          	addi	s6,s6,1674 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    25f6:	8a26                	mv	s4,s1
    25f8:	0209ce63          	bltz	s3,2634 <manywrites+0xe8>
          int fd = open(name, O_CREATE | O_RDWR);
    25fc:	20200593          	li	a1,514
    2600:	fa840513          	addi	a0,s0,-88
    2604:	00003097          	auipc	ra,0x3
    2608:	69c080e7          	jalr	1692(ra) # 5ca0 <open>
    260c:	892a                	mv	s2,a0
          if(fd < 0){
    260e:	04054763          	bltz	a0,265c <manywrites+0x110>
          int cc = write(fd, buf, sz);
    2612:	660d                	lui	a2,0x3
    2614:	85da                	mv	a1,s6
    2616:	00003097          	auipc	ra,0x3
    261a:	66a080e7          	jalr	1642(ra) # 5c80 <write>
          if(cc != sz){
    261e:	678d                	lui	a5,0x3
    2620:	04f51e63          	bne	a0,a5,267c <manywrites+0x130>
          close(fd);
    2624:	854a                	mv	a0,s2
    2626:	00003097          	auipc	ra,0x3
    262a:	662080e7          	jalr	1634(ra) # 5c88 <close>
        for(int i = 0; i < ci+1; i++){
    262e:	2a05                	addiw	s4,s4,1
    2630:	fd49d6e3          	bge	s3,s4,25fc <manywrites+0xb0>
        unlink(name);
    2634:	fa840513          	addi	a0,s0,-88
    2638:	00003097          	auipc	ra,0x3
    263c:	678080e7          	jalr	1656(ra) # 5cb0 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    2640:	3bfd                	addiw	s7,s7,-1
    2642:	fa0b9ae3          	bnez	s7,25f6 <manywrites+0xaa>
      unlink(name);
    2646:	fa840513          	addi	a0,s0,-88
    264a:	00003097          	auipc	ra,0x3
    264e:	666080e7          	jalr	1638(ra) # 5cb0 <unlink>
      exit(0);
    2652:	4501                	li	a0,0
    2654:	00003097          	auipc	ra,0x3
    2658:	60c080e7          	jalr	1548(ra) # 5c60 <exit>
            printf("%s: cannot create %s\n", s, name);
    265c:	fa840613          	addi	a2,s0,-88
    2660:	85d6                	mv	a1,s5
    2662:	00005517          	auipc	a0,0x5
    2666:	95650513          	addi	a0,a0,-1706 # 6fb8 <malloc+0xf30>
    266a:	00004097          	auipc	ra,0x4
    266e:	966080e7          	jalr	-1690(ra) # 5fd0 <printf>
            exit(1);
    2672:	4505                	li	a0,1
    2674:	00003097          	auipc	ra,0x3
    2678:	5ec080e7          	jalr	1516(ra) # 5c60 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    267c:	86aa                	mv	a3,a0
    267e:	660d                	lui	a2,0x3
    2680:	85d6                	mv	a1,s5
    2682:	00004517          	auipc	a0,0x4
    2686:	c1650513          	addi	a0,a0,-1002 # 6298 <malloc+0x210>
    268a:	00004097          	auipc	ra,0x4
    268e:	946080e7          	jalr	-1722(ra) # 5fd0 <printf>
            exit(1);
    2692:	4505                	li	a0,1
    2694:	00003097          	auipc	ra,0x3
    2698:	5cc080e7          	jalr	1484(ra) # 5c60 <exit>
      exit(st);
    269c:	00003097          	auipc	ra,0x3
    26a0:	5c4080e7          	jalr	1476(ra) # 5c60 <exit>

00000000000026a4 <copyinstr3>:
{
    26a4:	7179                	addi	sp,sp,-48
    26a6:	f406                	sd	ra,40(sp)
    26a8:	f022                	sd	s0,32(sp)
    26aa:	ec26                	sd	s1,24(sp)
    26ac:	1800                	addi	s0,sp,48
  sbrk(8192);
    26ae:	6509                	lui	a0,0x2
    26b0:	00003097          	auipc	ra,0x3
    26b4:	638080e7          	jalr	1592(ra) # 5ce8 <sbrk>
  uint64 top = (uint64) sbrk(0);
    26b8:	4501                	li	a0,0
    26ba:	00003097          	auipc	ra,0x3
    26be:	62e080e7          	jalr	1582(ra) # 5ce8 <sbrk>
  if((top % PGSIZE) != 0){
    26c2:	03451793          	slli	a5,a0,0x34
    26c6:	e3c9                	bnez	a5,2748 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    26c8:	4501                	li	a0,0
    26ca:	00003097          	auipc	ra,0x3
    26ce:	61e080e7          	jalr	1566(ra) # 5ce8 <sbrk>
  if(top % PGSIZE){
    26d2:	03451793          	slli	a5,a0,0x34
    26d6:	e3d9                	bnez	a5,275c <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    26d8:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x45>
  *b = 'x';
    26dc:	07800793          	li	a5,120
    26e0:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    26e4:	8526                	mv	a0,s1
    26e6:	00003097          	auipc	ra,0x3
    26ea:	5ca080e7          	jalr	1482(ra) # 5cb0 <unlink>
  if(ret != -1){
    26ee:	57fd                	li	a5,-1
    26f0:	08f51363          	bne	a0,a5,2776 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    26f4:	20100593          	li	a1,513
    26f8:	8526                	mv	a0,s1
    26fa:	00003097          	auipc	ra,0x3
    26fe:	5a6080e7          	jalr	1446(ra) # 5ca0 <open>
  if(fd != -1){
    2702:	57fd                	li	a5,-1
    2704:	08f51863          	bne	a0,a5,2794 <copyinstr3+0xf0>
  ret = link(b, b);
    2708:	85a6                	mv	a1,s1
    270a:	8526                	mv	a0,s1
    270c:	00003097          	auipc	ra,0x3
    2710:	5b4080e7          	jalr	1460(ra) # 5cc0 <link>
  if(ret != -1){
    2714:	57fd                	li	a5,-1
    2716:	08f51e63          	bne	a0,a5,27b2 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    271a:	00005797          	auipc	a5,0x5
    271e:	59678793          	addi	a5,a5,1430 # 7cb0 <malloc+0x1c28>
    2722:	fcf43823          	sd	a5,-48(s0)
    2726:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    272a:	fd040593          	addi	a1,s0,-48
    272e:	8526                	mv	a0,s1
    2730:	00003097          	auipc	ra,0x3
    2734:	568080e7          	jalr	1384(ra) # 5c98 <exec>
  if(ret != -1){
    2738:	57fd                	li	a5,-1
    273a:	08f51c63          	bne	a0,a5,27d2 <copyinstr3+0x12e>
}
    273e:	70a2                	ld	ra,40(sp)
    2740:	7402                	ld	s0,32(sp)
    2742:	64e2                	ld	s1,24(sp)
    2744:	6145                	addi	sp,sp,48
    2746:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2748:	0347d513          	srli	a0,a5,0x34
    274c:	6785                	lui	a5,0x1
    274e:	40a7853b          	subw	a0,a5,a0
    2752:	00003097          	auipc	ra,0x3
    2756:	596080e7          	jalr	1430(ra) # 5ce8 <sbrk>
    275a:	b7bd                	j	26c8 <copyinstr3+0x24>
    printf("oops\n");
    275c:	00005517          	auipc	a0,0x5
    2760:	87450513          	addi	a0,a0,-1932 # 6fd0 <malloc+0xf48>
    2764:	00004097          	auipc	ra,0x4
    2768:	86c080e7          	jalr	-1940(ra) # 5fd0 <printf>
    exit(1);
    276c:	4505                	li	a0,1
    276e:	00003097          	auipc	ra,0x3
    2772:	4f2080e7          	jalr	1266(ra) # 5c60 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2776:	862a                	mv	a2,a0
    2778:	85a6                	mv	a1,s1
    277a:	00004517          	auipc	a0,0x4
    277e:	1f650513          	addi	a0,a0,502 # 6970 <malloc+0x8e8>
    2782:	00004097          	auipc	ra,0x4
    2786:	84e080e7          	jalr	-1970(ra) # 5fd0 <printf>
    exit(1);
    278a:	4505                	li	a0,1
    278c:	00003097          	auipc	ra,0x3
    2790:	4d4080e7          	jalr	1236(ra) # 5c60 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2794:	862a                	mv	a2,a0
    2796:	85a6                	mv	a1,s1
    2798:	00004517          	auipc	a0,0x4
    279c:	1f850513          	addi	a0,a0,504 # 6990 <malloc+0x908>
    27a0:	00004097          	auipc	ra,0x4
    27a4:	830080e7          	jalr	-2000(ra) # 5fd0 <printf>
    exit(1);
    27a8:	4505                	li	a0,1
    27aa:	00003097          	auipc	ra,0x3
    27ae:	4b6080e7          	jalr	1206(ra) # 5c60 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    27b2:	86aa                	mv	a3,a0
    27b4:	8626                	mv	a2,s1
    27b6:	85a6                	mv	a1,s1
    27b8:	00004517          	auipc	a0,0x4
    27bc:	1f850513          	addi	a0,a0,504 # 69b0 <malloc+0x928>
    27c0:	00004097          	auipc	ra,0x4
    27c4:	810080e7          	jalr	-2032(ra) # 5fd0 <printf>
    exit(1);
    27c8:	4505                	li	a0,1
    27ca:	00003097          	auipc	ra,0x3
    27ce:	496080e7          	jalr	1174(ra) # 5c60 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    27d2:	567d                	li	a2,-1
    27d4:	85a6                	mv	a1,s1
    27d6:	00004517          	auipc	a0,0x4
    27da:	20250513          	addi	a0,a0,514 # 69d8 <malloc+0x950>
    27de:	00003097          	auipc	ra,0x3
    27e2:	7f2080e7          	jalr	2034(ra) # 5fd0 <printf>
    exit(1);
    27e6:	4505                	li	a0,1
    27e8:	00003097          	auipc	ra,0x3
    27ec:	478080e7          	jalr	1144(ra) # 5c60 <exit>

00000000000027f0 <rwsbrk>:
{
    27f0:	1101                	addi	sp,sp,-32
    27f2:	ec06                	sd	ra,24(sp)
    27f4:	e822                	sd	s0,16(sp)
    27f6:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    27f8:	6509                	lui	a0,0x2
    27fa:	00003097          	auipc	ra,0x3
    27fe:	4ee080e7          	jalr	1262(ra) # 5ce8 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2802:	57fd                	li	a5,-1
    2804:	06f50463          	beq	a0,a5,286c <rwsbrk+0x7c>
    2808:	e426                	sd	s1,8(sp)
    280a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    280c:	7579                	lui	a0,0xffffe
    280e:	00003097          	auipc	ra,0x3
    2812:	4da080e7          	jalr	1242(ra) # 5ce8 <sbrk>
    2816:	57fd                	li	a5,-1
    2818:	06f50963          	beq	a0,a5,288a <rwsbrk+0x9a>
    281c:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    281e:	20100593          	li	a1,513
    2822:	00004517          	auipc	a0,0x4
    2826:	7ee50513          	addi	a0,a0,2030 # 7010 <malloc+0xf88>
    282a:	00003097          	auipc	ra,0x3
    282e:	476080e7          	jalr	1142(ra) # 5ca0 <open>
    2832:	892a                	mv	s2,a0
  if(fd < 0){
    2834:	06054963          	bltz	a0,28a6 <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    2838:	6785                	lui	a5,0x1
    283a:	94be                	add	s1,s1,a5
    283c:	40000613          	li	a2,1024
    2840:	85a6                	mv	a1,s1
    2842:	00003097          	auipc	ra,0x3
    2846:	43e080e7          	jalr	1086(ra) # 5c80 <write>
    284a:	862a                	mv	a2,a0
  if(n >= 0){
    284c:	06054a63          	bltz	a0,28c0 <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2850:	85a6                	mv	a1,s1
    2852:	00004517          	auipc	a0,0x4
    2856:	7de50513          	addi	a0,a0,2014 # 7030 <malloc+0xfa8>
    285a:	00003097          	auipc	ra,0x3
    285e:	776080e7          	jalr	1910(ra) # 5fd0 <printf>
    exit(1);
    2862:	4505                	li	a0,1
    2864:	00003097          	auipc	ra,0x3
    2868:	3fc080e7          	jalr	1020(ra) # 5c60 <exit>
    286c:	e426                	sd	s1,8(sp)
    286e:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2870:	00004517          	auipc	a0,0x4
    2874:	76850513          	addi	a0,a0,1896 # 6fd8 <malloc+0xf50>
    2878:	00003097          	auipc	ra,0x3
    287c:	758080e7          	jalr	1880(ra) # 5fd0 <printf>
    exit(1);
    2880:	4505                	li	a0,1
    2882:	00003097          	auipc	ra,0x3
    2886:	3de080e7          	jalr	990(ra) # 5c60 <exit>
    288a:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    288c:	00004517          	auipc	a0,0x4
    2890:	76450513          	addi	a0,a0,1892 # 6ff0 <malloc+0xf68>
    2894:	00003097          	auipc	ra,0x3
    2898:	73c080e7          	jalr	1852(ra) # 5fd0 <printf>
    exit(1);
    289c:	4505                	li	a0,1
    289e:	00003097          	auipc	ra,0x3
    28a2:	3c2080e7          	jalr	962(ra) # 5c60 <exit>
    printf("open(rwsbrk) failed\n");
    28a6:	00004517          	auipc	a0,0x4
    28aa:	77250513          	addi	a0,a0,1906 # 7018 <malloc+0xf90>
    28ae:	00003097          	auipc	ra,0x3
    28b2:	722080e7          	jalr	1826(ra) # 5fd0 <printf>
    exit(1);
    28b6:	4505                	li	a0,1
    28b8:	00003097          	auipc	ra,0x3
    28bc:	3a8080e7          	jalr	936(ra) # 5c60 <exit>
  close(fd);
    28c0:	854a                	mv	a0,s2
    28c2:	00003097          	auipc	ra,0x3
    28c6:	3c6080e7          	jalr	966(ra) # 5c88 <close>
  unlink("rwsbrk");
    28ca:	00004517          	auipc	a0,0x4
    28ce:	74650513          	addi	a0,a0,1862 # 7010 <malloc+0xf88>
    28d2:	00003097          	auipc	ra,0x3
    28d6:	3de080e7          	jalr	990(ra) # 5cb0 <unlink>
  fd = open("README", O_RDONLY);
    28da:	4581                	li	a1,0
    28dc:	00004517          	auipc	a0,0x4
    28e0:	ac450513          	addi	a0,a0,-1340 # 63a0 <malloc+0x318>
    28e4:	00003097          	auipc	ra,0x3
    28e8:	3bc080e7          	jalr	956(ra) # 5ca0 <open>
    28ec:	892a                	mv	s2,a0
  if(fd < 0){
    28ee:	02054963          	bltz	a0,2920 <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    28f2:	4629                	li	a2,10
    28f4:	85a6                	mv	a1,s1
    28f6:	00003097          	auipc	ra,0x3
    28fa:	382080e7          	jalr	898(ra) # 5c78 <read>
    28fe:	862a                	mv	a2,a0
  if(n >= 0){
    2900:	02054d63          	bltz	a0,293a <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2904:	85a6                	mv	a1,s1
    2906:	00004517          	auipc	a0,0x4
    290a:	75a50513          	addi	a0,a0,1882 # 7060 <malloc+0xfd8>
    290e:	00003097          	auipc	ra,0x3
    2912:	6c2080e7          	jalr	1730(ra) # 5fd0 <printf>
    exit(1);
    2916:	4505                	li	a0,1
    2918:	00003097          	auipc	ra,0x3
    291c:	348080e7          	jalr	840(ra) # 5c60 <exit>
    printf("open(rwsbrk) failed\n");
    2920:	00004517          	auipc	a0,0x4
    2924:	6f850513          	addi	a0,a0,1784 # 7018 <malloc+0xf90>
    2928:	00003097          	auipc	ra,0x3
    292c:	6a8080e7          	jalr	1704(ra) # 5fd0 <printf>
    exit(1);
    2930:	4505                	li	a0,1
    2932:	00003097          	auipc	ra,0x3
    2936:	32e080e7          	jalr	814(ra) # 5c60 <exit>
  close(fd);
    293a:	854a                	mv	a0,s2
    293c:	00003097          	auipc	ra,0x3
    2940:	34c080e7          	jalr	844(ra) # 5c88 <close>
  exit(0);
    2944:	4501                	li	a0,0
    2946:	00003097          	auipc	ra,0x3
    294a:	31a080e7          	jalr	794(ra) # 5c60 <exit>

000000000000294e <sbrkbasic>:
{
    294e:	7139                	addi	sp,sp,-64
    2950:	fc06                	sd	ra,56(sp)
    2952:	f822                	sd	s0,48(sp)
    2954:	ec4e                	sd	s3,24(sp)
    2956:	0080                	addi	s0,sp,64
    2958:	89aa                	mv	s3,a0
  pid = fork();
    295a:	00003097          	auipc	ra,0x3
    295e:	2fe080e7          	jalr	766(ra) # 5c58 <fork>
  if(pid < 0){
    2962:	02054f63          	bltz	a0,29a0 <sbrkbasic+0x52>
  if(pid == 0){
    2966:	e52d                	bnez	a0,29d0 <sbrkbasic+0x82>
    a = sbrk(TOOMUCH);
    2968:	40000537          	lui	a0,0x40000
    296c:	00003097          	auipc	ra,0x3
    2970:	37c080e7          	jalr	892(ra) # 5ce8 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2974:	57fd                	li	a5,-1
    2976:	04f50563          	beq	a0,a5,29c0 <sbrkbasic+0x72>
    297a:	f426                	sd	s1,40(sp)
    297c:	f04a                	sd	s2,32(sp)
    297e:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    2980:	400007b7          	lui	a5,0x40000
    2984:	97aa                	add	a5,a5,a0
      *b = 99;
    2986:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    298a:	6705                	lui	a4,0x1
      *b = 99;
    298c:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2990:	953a                	add	a0,a0,a4
    2992:	fef51de3          	bne	a0,a5,298c <sbrkbasic+0x3e>
    exit(1);
    2996:	4505                	li	a0,1
    2998:	00003097          	auipc	ra,0x3
    299c:	2c8080e7          	jalr	712(ra) # 5c60 <exit>
    29a0:	f426                	sd	s1,40(sp)
    29a2:	f04a                	sd	s2,32(sp)
    29a4:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    29a6:	00004517          	auipc	a0,0x4
    29aa:	6e250513          	addi	a0,a0,1762 # 7088 <malloc+0x1000>
    29ae:	00003097          	auipc	ra,0x3
    29b2:	622080e7          	jalr	1570(ra) # 5fd0 <printf>
    exit(1);
    29b6:	4505                	li	a0,1
    29b8:	00003097          	auipc	ra,0x3
    29bc:	2a8080e7          	jalr	680(ra) # 5c60 <exit>
    29c0:	f426                	sd	s1,40(sp)
    29c2:	f04a                	sd	s2,32(sp)
    29c4:	e852                	sd	s4,16(sp)
      exit(0);
    29c6:	4501                	li	a0,0
    29c8:	00003097          	auipc	ra,0x3
    29cc:	298080e7          	jalr	664(ra) # 5c60 <exit>
  wait(&xstatus);
    29d0:	fcc40513          	addi	a0,s0,-52
    29d4:	00003097          	auipc	ra,0x3
    29d8:	294080e7          	jalr	660(ra) # 5c68 <wait>
  if(xstatus == 1){
    29dc:	fcc42703          	lw	a4,-52(s0)
    29e0:	4785                	li	a5,1
    29e2:	02f70063          	beq	a4,a5,2a02 <sbrkbasic+0xb4>
    29e6:	f426                	sd	s1,40(sp)
    29e8:	f04a                	sd	s2,32(sp)
    29ea:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    29ec:	4501                	li	a0,0
    29ee:	00003097          	auipc	ra,0x3
    29f2:	2fa080e7          	jalr	762(ra) # 5ce8 <sbrk>
    29f6:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    29f8:	4901                	li	s2,0
    29fa:	6a05                	lui	s4,0x1
    29fc:	388a0a13          	addi	s4,s4,904 # 1388 <badarg+0x3e>
    2a00:	a01d                	j	2a26 <sbrkbasic+0xd8>
    2a02:	f426                	sd	s1,40(sp)
    2a04:	f04a                	sd	s2,32(sp)
    2a06:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    2a08:	85ce                	mv	a1,s3
    2a0a:	00004517          	auipc	a0,0x4
    2a0e:	69e50513          	addi	a0,a0,1694 # 70a8 <malloc+0x1020>
    2a12:	00003097          	auipc	ra,0x3
    2a16:	5be080e7          	jalr	1470(ra) # 5fd0 <printf>
    exit(1);
    2a1a:	4505                	li	a0,1
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	244080e7          	jalr	580(ra) # 5c60 <exit>
    2a24:	84be                	mv	s1,a5
    b = sbrk(1);
    2a26:	4505                	li	a0,1
    2a28:	00003097          	auipc	ra,0x3
    2a2c:	2c0080e7          	jalr	704(ra) # 5ce8 <sbrk>
    if(b != a){
    2a30:	04951c63          	bne	a0,s1,2a88 <sbrkbasic+0x13a>
    *b = 1;
    2a34:	4785                	li	a5,1
    2a36:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2a3a:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2a3e:	2905                	addiw	s2,s2,1
    2a40:	ff4912e3          	bne	s2,s4,2a24 <sbrkbasic+0xd6>
  pid = fork();
    2a44:	00003097          	auipc	ra,0x3
    2a48:	214080e7          	jalr	532(ra) # 5c58 <fork>
    2a4c:	892a                	mv	s2,a0
  if(pid < 0){
    2a4e:	04054e63          	bltz	a0,2aaa <sbrkbasic+0x15c>
  c = sbrk(1);
    2a52:	4505                	li	a0,1
    2a54:	00003097          	auipc	ra,0x3
    2a58:	294080e7          	jalr	660(ra) # 5ce8 <sbrk>
  c = sbrk(1);
    2a5c:	4505                	li	a0,1
    2a5e:	00003097          	auipc	ra,0x3
    2a62:	28a080e7          	jalr	650(ra) # 5ce8 <sbrk>
  if(c != a + 1){
    2a66:	0489                	addi	s1,s1,2
    2a68:	04a48f63          	beq	s1,a0,2ac6 <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    2a6c:	85ce                	mv	a1,s3
    2a6e:	00004517          	auipc	a0,0x4
    2a72:	69a50513          	addi	a0,a0,1690 # 7108 <malloc+0x1080>
    2a76:	00003097          	auipc	ra,0x3
    2a7a:	55a080e7          	jalr	1370(ra) # 5fd0 <printf>
    exit(1);
    2a7e:	4505                	li	a0,1
    2a80:	00003097          	auipc	ra,0x3
    2a84:	1e0080e7          	jalr	480(ra) # 5c60 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2a88:	872a                	mv	a4,a0
    2a8a:	86a6                	mv	a3,s1
    2a8c:	864a                	mv	a2,s2
    2a8e:	85ce                	mv	a1,s3
    2a90:	00004517          	auipc	a0,0x4
    2a94:	63850513          	addi	a0,a0,1592 # 70c8 <malloc+0x1040>
    2a98:	00003097          	auipc	ra,0x3
    2a9c:	538080e7          	jalr	1336(ra) # 5fd0 <printf>
      exit(1);
    2aa0:	4505                	li	a0,1
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	1be080e7          	jalr	446(ra) # 5c60 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2aaa:	85ce                	mv	a1,s3
    2aac:	00004517          	auipc	a0,0x4
    2ab0:	63c50513          	addi	a0,a0,1596 # 70e8 <malloc+0x1060>
    2ab4:	00003097          	auipc	ra,0x3
    2ab8:	51c080e7          	jalr	1308(ra) # 5fd0 <printf>
    exit(1);
    2abc:	4505                	li	a0,1
    2abe:	00003097          	auipc	ra,0x3
    2ac2:	1a2080e7          	jalr	418(ra) # 5c60 <exit>
  if(pid == 0)
    2ac6:	00091763          	bnez	s2,2ad4 <sbrkbasic+0x186>
    exit(0);
    2aca:	4501                	li	a0,0
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	194080e7          	jalr	404(ra) # 5c60 <exit>
  wait(&xstatus);
    2ad4:	fcc40513          	addi	a0,s0,-52
    2ad8:	00003097          	auipc	ra,0x3
    2adc:	190080e7          	jalr	400(ra) # 5c68 <wait>
  exit(xstatus);
    2ae0:	fcc42503          	lw	a0,-52(s0)
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	17c080e7          	jalr	380(ra) # 5c60 <exit>

0000000000002aec <sbrkmuch>:
{
    2aec:	7179                	addi	sp,sp,-48
    2aee:	f406                	sd	ra,40(sp)
    2af0:	f022                	sd	s0,32(sp)
    2af2:	ec26                	sd	s1,24(sp)
    2af4:	e84a                	sd	s2,16(sp)
    2af6:	e44e                	sd	s3,8(sp)
    2af8:	e052                	sd	s4,0(sp)
    2afa:	1800                	addi	s0,sp,48
    2afc:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2afe:	4501                	li	a0,0
    2b00:	00003097          	auipc	ra,0x3
    2b04:	1e8080e7          	jalr	488(ra) # 5ce8 <sbrk>
    2b08:	892a                	mv	s2,a0
  a = sbrk(0);
    2b0a:	4501                	li	a0,0
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	1dc080e7          	jalr	476(ra) # 5ce8 <sbrk>
    2b14:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2b16:	06400537          	lui	a0,0x6400
    2b1a:	9d05                	subw	a0,a0,s1
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	1cc080e7          	jalr	460(ra) # 5ce8 <sbrk>
  if (p != a) {
    2b24:	0ca49863          	bne	s1,a0,2bf4 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2b28:	4501                	li	a0,0
    2b2a:	00003097          	auipc	ra,0x3
    2b2e:	1be080e7          	jalr	446(ra) # 5ce8 <sbrk>
    2b32:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2b34:	00a4f963          	bgeu	s1,a0,2b46 <sbrkmuch+0x5a>
    *pp = 1;
    2b38:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2b3a:	6705                	lui	a4,0x1
    *pp = 1;
    2b3c:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2b40:	94ba                	add	s1,s1,a4
    2b42:	fef4ede3          	bltu	s1,a5,2b3c <sbrkmuch+0x50>
  *lastaddr = 99;
    2b46:	064007b7          	lui	a5,0x6400
    2b4a:	06300713          	li	a4,99
    2b4e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2b52:	4501                	li	a0,0
    2b54:	00003097          	auipc	ra,0x3
    2b58:	194080e7          	jalr	404(ra) # 5ce8 <sbrk>
    2b5c:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2b5e:	757d                	lui	a0,0xfffff
    2b60:	00003097          	auipc	ra,0x3
    2b64:	188080e7          	jalr	392(ra) # 5ce8 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2b68:	57fd                	li	a5,-1
    2b6a:	0af50363          	beq	a0,a5,2c10 <sbrkmuch+0x124>
  c = sbrk(0);
    2b6e:	4501                	li	a0,0
    2b70:	00003097          	auipc	ra,0x3
    2b74:	178080e7          	jalr	376(ra) # 5ce8 <sbrk>
  if(c != a - PGSIZE){
    2b78:	77fd                	lui	a5,0xfffff
    2b7a:	97a6                	add	a5,a5,s1
    2b7c:	0af51863          	bne	a0,a5,2c2c <sbrkmuch+0x140>
  a = sbrk(0);
    2b80:	4501                	li	a0,0
    2b82:	00003097          	auipc	ra,0x3
    2b86:	166080e7          	jalr	358(ra) # 5ce8 <sbrk>
    2b8a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2b8c:	6505                	lui	a0,0x1
    2b8e:	00003097          	auipc	ra,0x3
    2b92:	15a080e7          	jalr	346(ra) # 5ce8 <sbrk>
    2b96:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2b98:	0aa49a63          	bne	s1,a0,2c4c <sbrkmuch+0x160>
    2b9c:	4501                	li	a0,0
    2b9e:	00003097          	auipc	ra,0x3
    2ba2:	14a080e7          	jalr	330(ra) # 5ce8 <sbrk>
    2ba6:	6785                	lui	a5,0x1
    2ba8:	97a6                	add	a5,a5,s1
    2baa:	0af51163          	bne	a0,a5,2c4c <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2bae:	064007b7          	lui	a5,0x6400
    2bb2:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2bb6:	06300793          	li	a5,99
    2bba:	0af70963          	beq	a4,a5,2c6c <sbrkmuch+0x180>
  a = sbrk(0);
    2bbe:	4501                	li	a0,0
    2bc0:	00003097          	auipc	ra,0x3
    2bc4:	128080e7          	jalr	296(ra) # 5ce8 <sbrk>
    2bc8:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2bca:	4501                	li	a0,0
    2bcc:	00003097          	auipc	ra,0x3
    2bd0:	11c080e7          	jalr	284(ra) # 5ce8 <sbrk>
    2bd4:	40a9053b          	subw	a0,s2,a0
    2bd8:	00003097          	auipc	ra,0x3
    2bdc:	110080e7          	jalr	272(ra) # 5ce8 <sbrk>
  if(c != a){
    2be0:	0aa49463          	bne	s1,a0,2c88 <sbrkmuch+0x19c>
}
    2be4:	70a2                	ld	ra,40(sp)
    2be6:	7402                	ld	s0,32(sp)
    2be8:	64e2                	ld	s1,24(sp)
    2bea:	6942                	ld	s2,16(sp)
    2bec:	69a2                	ld	s3,8(sp)
    2bee:	6a02                	ld	s4,0(sp)
    2bf0:	6145                	addi	sp,sp,48
    2bf2:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2bf4:	85ce                	mv	a1,s3
    2bf6:	00004517          	auipc	a0,0x4
    2bfa:	53250513          	addi	a0,a0,1330 # 7128 <malloc+0x10a0>
    2bfe:	00003097          	auipc	ra,0x3
    2c02:	3d2080e7          	jalr	978(ra) # 5fd0 <printf>
    exit(1);
    2c06:	4505                	li	a0,1
    2c08:	00003097          	auipc	ra,0x3
    2c0c:	058080e7          	jalr	88(ra) # 5c60 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2c10:	85ce                	mv	a1,s3
    2c12:	00004517          	auipc	a0,0x4
    2c16:	55e50513          	addi	a0,a0,1374 # 7170 <malloc+0x10e8>
    2c1a:	00003097          	auipc	ra,0x3
    2c1e:	3b6080e7          	jalr	950(ra) # 5fd0 <printf>
    exit(1);
    2c22:	4505                	li	a0,1
    2c24:	00003097          	auipc	ra,0x3
    2c28:	03c080e7          	jalr	60(ra) # 5c60 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2c2c:	86aa                	mv	a3,a0
    2c2e:	8626                	mv	a2,s1
    2c30:	85ce                	mv	a1,s3
    2c32:	00004517          	auipc	a0,0x4
    2c36:	55e50513          	addi	a0,a0,1374 # 7190 <malloc+0x1108>
    2c3a:	00003097          	auipc	ra,0x3
    2c3e:	396080e7          	jalr	918(ra) # 5fd0 <printf>
    exit(1);
    2c42:	4505                	li	a0,1
    2c44:	00003097          	auipc	ra,0x3
    2c48:	01c080e7          	jalr	28(ra) # 5c60 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2c4c:	86d2                	mv	a3,s4
    2c4e:	8626                	mv	a2,s1
    2c50:	85ce                	mv	a1,s3
    2c52:	00004517          	auipc	a0,0x4
    2c56:	57e50513          	addi	a0,a0,1406 # 71d0 <malloc+0x1148>
    2c5a:	00003097          	auipc	ra,0x3
    2c5e:	376080e7          	jalr	886(ra) # 5fd0 <printf>
    exit(1);
    2c62:	4505                	li	a0,1
    2c64:	00003097          	auipc	ra,0x3
    2c68:	ffc080e7          	jalr	-4(ra) # 5c60 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2c6c:	85ce                	mv	a1,s3
    2c6e:	00004517          	auipc	a0,0x4
    2c72:	59250513          	addi	a0,a0,1426 # 7200 <malloc+0x1178>
    2c76:	00003097          	auipc	ra,0x3
    2c7a:	35a080e7          	jalr	858(ra) # 5fd0 <printf>
    exit(1);
    2c7e:	4505                	li	a0,1
    2c80:	00003097          	auipc	ra,0x3
    2c84:	fe0080e7          	jalr	-32(ra) # 5c60 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2c88:	86aa                	mv	a3,a0
    2c8a:	8626                	mv	a2,s1
    2c8c:	85ce                	mv	a1,s3
    2c8e:	00004517          	auipc	a0,0x4
    2c92:	5aa50513          	addi	a0,a0,1450 # 7238 <malloc+0x11b0>
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	33a080e7          	jalr	826(ra) # 5fd0 <printf>
    exit(1);
    2c9e:	4505                	li	a0,1
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	fc0080e7          	jalr	-64(ra) # 5c60 <exit>

0000000000002ca8 <sbrkarg>:
{
    2ca8:	7179                	addi	sp,sp,-48
    2caa:	f406                	sd	ra,40(sp)
    2cac:	f022                	sd	s0,32(sp)
    2cae:	ec26                	sd	s1,24(sp)
    2cb0:	e84a                	sd	s2,16(sp)
    2cb2:	e44e                	sd	s3,8(sp)
    2cb4:	1800                	addi	s0,sp,48
    2cb6:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2cb8:	6505                	lui	a0,0x1
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	02e080e7          	jalr	46(ra) # 5ce8 <sbrk>
    2cc2:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2cc4:	20100593          	li	a1,513
    2cc8:	00004517          	auipc	a0,0x4
    2ccc:	59850513          	addi	a0,a0,1432 # 7260 <malloc+0x11d8>
    2cd0:	00003097          	auipc	ra,0x3
    2cd4:	fd0080e7          	jalr	-48(ra) # 5ca0 <open>
    2cd8:	84aa                	mv	s1,a0
  unlink("sbrk");
    2cda:	00004517          	auipc	a0,0x4
    2cde:	58650513          	addi	a0,a0,1414 # 7260 <malloc+0x11d8>
    2ce2:	00003097          	auipc	ra,0x3
    2ce6:	fce080e7          	jalr	-50(ra) # 5cb0 <unlink>
  if(fd < 0)  {
    2cea:	0404c163          	bltz	s1,2d2c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2cee:	6605                	lui	a2,0x1
    2cf0:	85ca                	mv	a1,s2
    2cf2:	8526                	mv	a0,s1
    2cf4:	00003097          	auipc	ra,0x3
    2cf8:	f8c080e7          	jalr	-116(ra) # 5c80 <write>
    2cfc:	04054663          	bltz	a0,2d48 <sbrkarg+0xa0>
  close(fd);
    2d00:	8526                	mv	a0,s1
    2d02:	00003097          	auipc	ra,0x3
    2d06:	f86080e7          	jalr	-122(ra) # 5c88 <close>
  a = sbrk(PGSIZE);
    2d0a:	6505                	lui	a0,0x1
    2d0c:	00003097          	auipc	ra,0x3
    2d10:	fdc080e7          	jalr	-36(ra) # 5ce8 <sbrk>
  if(pipe((int *) a) != 0){
    2d14:	00003097          	auipc	ra,0x3
    2d18:	f5c080e7          	jalr	-164(ra) # 5c70 <pipe>
    2d1c:	e521                	bnez	a0,2d64 <sbrkarg+0xbc>
}
    2d1e:	70a2                	ld	ra,40(sp)
    2d20:	7402                	ld	s0,32(sp)
    2d22:	64e2                	ld	s1,24(sp)
    2d24:	6942                	ld	s2,16(sp)
    2d26:	69a2                	ld	s3,8(sp)
    2d28:	6145                	addi	sp,sp,48
    2d2a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2d2c:	85ce                	mv	a1,s3
    2d2e:	00004517          	auipc	a0,0x4
    2d32:	53a50513          	addi	a0,a0,1338 # 7268 <malloc+0x11e0>
    2d36:	00003097          	auipc	ra,0x3
    2d3a:	29a080e7          	jalr	666(ra) # 5fd0 <printf>
    exit(1);
    2d3e:	4505                	li	a0,1
    2d40:	00003097          	auipc	ra,0x3
    2d44:	f20080e7          	jalr	-224(ra) # 5c60 <exit>
    printf("%s: write sbrk failed\n", s);
    2d48:	85ce                	mv	a1,s3
    2d4a:	00004517          	auipc	a0,0x4
    2d4e:	53650513          	addi	a0,a0,1334 # 7280 <malloc+0x11f8>
    2d52:	00003097          	auipc	ra,0x3
    2d56:	27e080e7          	jalr	638(ra) # 5fd0 <printf>
    exit(1);
    2d5a:	4505                	li	a0,1
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	f04080e7          	jalr	-252(ra) # 5c60 <exit>
    printf("%s: pipe() failed\n", s);
    2d64:	85ce                	mv	a1,s3
    2d66:	00004517          	auipc	a0,0x4
    2d6a:	df250513          	addi	a0,a0,-526 # 6b58 <malloc+0xad0>
    2d6e:	00003097          	auipc	ra,0x3
    2d72:	262080e7          	jalr	610(ra) # 5fd0 <printf>
    exit(1);
    2d76:	4505                	li	a0,1
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	ee8080e7          	jalr	-280(ra) # 5c60 <exit>

0000000000002d80 <argptest>:
{
    2d80:	1101                	addi	sp,sp,-32
    2d82:	ec06                	sd	ra,24(sp)
    2d84:	e822                	sd	s0,16(sp)
    2d86:	e426                	sd	s1,8(sp)
    2d88:	e04a                	sd	s2,0(sp)
    2d8a:	1000                	addi	s0,sp,32
    2d8c:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2d8e:	4581                	li	a1,0
    2d90:	00004517          	auipc	a0,0x4
    2d94:	50850513          	addi	a0,a0,1288 # 7298 <malloc+0x1210>
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	f08080e7          	jalr	-248(ra) # 5ca0 <open>
  if (fd < 0) {
    2da0:	02054b63          	bltz	a0,2dd6 <argptest+0x56>
    2da4:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2da6:	4501                	li	a0,0
    2da8:	00003097          	auipc	ra,0x3
    2dac:	f40080e7          	jalr	-192(ra) # 5ce8 <sbrk>
    2db0:	567d                	li	a2,-1
    2db2:	fff50593          	addi	a1,a0,-1
    2db6:	8526                	mv	a0,s1
    2db8:	00003097          	auipc	ra,0x3
    2dbc:	ec0080e7          	jalr	-320(ra) # 5c78 <read>
  close(fd);
    2dc0:	8526                	mv	a0,s1
    2dc2:	00003097          	auipc	ra,0x3
    2dc6:	ec6080e7          	jalr	-314(ra) # 5c88 <close>
}
    2dca:	60e2                	ld	ra,24(sp)
    2dcc:	6442                	ld	s0,16(sp)
    2dce:	64a2                	ld	s1,8(sp)
    2dd0:	6902                	ld	s2,0(sp)
    2dd2:	6105                	addi	sp,sp,32
    2dd4:	8082                	ret
    printf("%s: open failed\n", s);
    2dd6:	85ca                	mv	a1,s2
    2dd8:	00004517          	auipc	a0,0x4
    2ddc:	c9050513          	addi	a0,a0,-880 # 6a68 <malloc+0x9e0>
    2de0:	00003097          	auipc	ra,0x3
    2de4:	1f0080e7          	jalr	496(ra) # 5fd0 <printf>
    exit(1);
    2de8:	4505                	li	a0,1
    2dea:	00003097          	auipc	ra,0x3
    2dee:	e76080e7          	jalr	-394(ra) # 5c60 <exit>

0000000000002df2 <sbrkbugs>:
{
    2df2:	1141                	addi	sp,sp,-16
    2df4:	e406                	sd	ra,8(sp)
    2df6:	e022                	sd	s0,0(sp)
    2df8:	0800                	addi	s0,sp,16
  int pid = fork();
    2dfa:	00003097          	auipc	ra,0x3
    2dfe:	e5e080e7          	jalr	-418(ra) # 5c58 <fork>
  if(pid < 0){
    2e02:	02054263          	bltz	a0,2e26 <sbrkbugs+0x34>
  if(pid == 0){
    2e06:	ed0d                	bnez	a0,2e40 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2e08:	00003097          	auipc	ra,0x3
    2e0c:	ee0080e7          	jalr	-288(ra) # 5ce8 <sbrk>
    sbrk(-sz);
    2e10:	40a0053b          	negw	a0,a0
    2e14:	00003097          	auipc	ra,0x3
    2e18:	ed4080e7          	jalr	-300(ra) # 5ce8 <sbrk>
    exit(0);
    2e1c:	4501                	li	a0,0
    2e1e:	00003097          	auipc	ra,0x3
    2e22:	e42080e7          	jalr	-446(ra) # 5c60 <exit>
    printf("fork failed\n");
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	03250513          	addi	a0,a0,50 # 6e58 <malloc+0xdd0>
    2e2e:	00003097          	auipc	ra,0x3
    2e32:	1a2080e7          	jalr	418(ra) # 5fd0 <printf>
    exit(1);
    2e36:	4505                	li	a0,1
    2e38:	00003097          	auipc	ra,0x3
    2e3c:	e28080e7          	jalr	-472(ra) # 5c60 <exit>
  wait(0);
    2e40:	4501                	li	a0,0
    2e42:	00003097          	auipc	ra,0x3
    2e46:	e26080e7          	jalr	-474(ra) # 5c68 <wait>
  pid = fork();
    2e4a:	00003097          	auipc	ra,0x3
    2e4e:	e0e080e7          	jalr	-498(ra) # 5c58 <fork>
  if(pid < 0){
    2e52:	02054563          	bltz	a0,2e7c <sbrkbugs+0x8a>
  if(pid == 0){
    2e56:	e121                	bnez	a0,2e96 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2e58:	00003097          	auipc	ra,0x3
    2e5c:	e90080e7          	jalr	-368(ra) # 5ce8 <sbrk>
    sbrk(-(sz - 3500));
    2e60:	6785                	lui	a5,0x1
    2e62:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6e>
    2e66:	40a7853b          	subw	a0,a5,a0
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	e7e080e7          	jalr	-386(ra) # 5ce8 <sbrk>
    exit(0);
    2e72:	4501                	li	a0,0
    2e74:	00003097          	auipc	ra,0x3
    2e78:	dec080e7          	jalr	-532(ra) # 5c60 <exit>
    printf("fork failed\n");
    2e7c:	00004517          	auipc	a0,0x4
    2e80:	fdc50513          	addi	a0,a0,-36 # 6e58 <malloc+0xdd0>
    2e84:	00003097          	auipc	ra,0x3
    2e88:	14c080e7          	jalr	332(ra) # 5fd0 <printf>
    exit(1);
    2e8c:	4505                	li	a0,1
    2e8e:	00003097          	auipc	ra,0x3
    2e92:	dd2080e7          	jalr	-558(ra) # 5c60 <exit>
  wait(0);
    2e96:	4501                	li	a0,0
    2e98:	00003097          	auipc	ra,0x3
    2e9c:	dd0080e7          	jalr	-560(ra) # 5c68 <wait>
  pid = fork();
    2ea0:	00003097          	auipc	ra,0x3
    2ea4:	db8080e7          	jalr	-584(ra) # 5c58 <fork>
  if(pid < 0){
    2ea8:	02054a63          	bltz	a0,2edc <sbrkbugs+0xea>
  if(pid == 0){
    2eac:	e529                	bnez	a0,2ef6 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2eae:	00003097          	auipc	ra,0x3
    2eb2:	e3a080e7          	jalr	-454(ra) # 5ce8 <sbrk>
    2eb6:	67ad                	lui	a5,0xb
    2eb8:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    2ebc:	40a7853b          	subw	a0,a5,a0
    2ec0:	00003097          	auipc	ra,0x3
    2ec4:	e28080e7          	jalr	-472(ra) # 5ce8 <sbrk>
    sbrk(-10);
    2ec8:	5559                	li	a0,-10
    2eca:	00003097          	auipc	ra,0x3
    2ece:	e1e080e7          	jalr	-482(ra) # 5ce8 <sbrk>
    exit(0);
    2ed2:	4501                	li	a0,0
    2ed4:	00003097          	auipc	ra,0x3
    2ed8:	d8c080e7          	jalr	-628(ra) # 5c60 <exit>
    printf("fork failed\n");
    2edc:	00004517          	auipc	a0,0x4
    2ee0:	f7c50513          	addi	a0,a0,-132 # 6e58 <malloc+0xdd0>
    2ee4:	00003097          	auipc	ra,0x3
    2ee8:	0ec080e7          	jalr	236(ra) # 5fd0 <printf>
    exit(1);
    2eec:	4505                	li	a0,1
    2eee:	00003097          	auipc	ra,0x3
    2ef2:	d72080e7          	jalr	-654(ra) # 5c60 <exit>
  wait(0);
    2ef6:	4501                	li	a0,0
    2ef8:	00003097          	auipc	ra,0x3
    2efc:	d70080e7          	jalr	-656(ra) # 5c68 <wait>
  exit(0);
    2f00:	4501                	li	a0,0
    2f02:	00003097          	auipc	ra,0x3
    2f06:	d5e080e7          	jalr	-674(ra) # 5c60 <exit>

0000000000002f0a <sbrklast>:
{
    2f0a:	7179                	addi	sp,sp,-48
    2f0c:	f406                	sd	ra,40(sp)
    2f0e:	f022                	sd	s0,32(sp)
    2f10:	ec26                	sd	s1,24(sp)
    2f12:	e84a                	sd	s2,16(sp)
    2f14:	e44e                	sd	s3,8(sp)
    2f16:	e052                	sd	s4,0(sp)
    2f18:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2f1a:	4501                	li	a0,0
    2f1c:	00003097          	auipc	ra,0x3
    2f20:	dcc080e7          	jalr	-564(ra) # 5ce8 <sbrk>
  if((top % 4096) != 0)
    2f24:	03451793          	slli	a5,a0,0x34
    2f28:	ebd9                	bnez	a5,2fbe <sbrklast+0xb4>
  sbrk(4096);
    2f2a:	6505                	lui	a0,0x1
    2f2c:	00003097          	auipc	ra,0x3
    2f30:	dbc080e7          	jalr	-580(ra) # 5ce8 <sbrk>
  sbrk(10);
    2f34:	4529                	li	a0,10
    2f36:	00003097          	auipc	ra,0x3
    2f3a:	db2080e7          	jalr	-590(ra) # 5ce8 <sbrk>
  sbrk(-20);
    2f3e:	5531                	li	a0,-20
    2f40:	00003097          	auipc	ra,0x3
    2f44:	da8080e7          	jalr	-600(ra) # 5ce8 <sbrk>
  top = (uint64) sbrk(0);
    2f48:	4501                	li	a0,0
    2f4a:	00003097          	auipc	ra,0x3
    2f4e:	d9e080e7          	jalr	-610(ra) # 5ce8 <sbrk>
    2f52:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2f54:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xcc>
  p[0] = 'x';
    2f58:	07800a13          	li	s4,120
    2f5c:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2f60:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2f64:	20200593          	li	a1,514
    2f68:	854a                	mv	a0,s2
    2f6a:	00003097          	auipc	ra,0x3
    2f6e:	d36080e7          	jalr	-714(ra) # 5ca0 <open>
    2f72:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2f74:	4605                	li	a2,1
    2f76:	85ca                	mv	a1,s2
    2f78:	00003097          	auipc	ra,0x3
    2f7c:	d08080e7          	jalr	-760(ra) # 5c80 <write>
  close(fd);
    2f80:	854e                	mv	a0,s3
    2f82:	00003097          	auipc	ra,0x3
    2f86:	d06080e7          	jalr	-762(ra) # 5c88 <close>
  fd = open(p, O_RDWR);
    2f8a:	4589                	li	a1,2
    2f8c:	854a                	mv	a0,s2
    2f8e:	00003097          	auipc	ra,0x3
    2f92:	d12080e7          	jalr	-750(ra) # 5ca0 <open>
  p[0] = '\0';
    2f96:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2f9a:	4605                	li	a2,1
    2f9c:	85ca                	mv	a1,s2
    2f9e:	00003097          	auipc	ra,0x3
    2fa2:	cda080e7          	jalr	-806(ra) # 5c78 <read>
  if(p[0] != 'x')
    2fa6:	fc04c783          	lbu	a5,-64(s1)
    2faa:	03479463          	bne	a5,s4,2fd2 <sbrklast+0xc8>
}
    2fae:	70a2                	ld	ra,40(sp)
    2fb0:	7402                	ld	s0,32(sp)
    2fb2:	64e2                	ld	s1,24(sp)
    2fb4:	6942                	ld	s2,16(sp)
    2fb6:	69a2                	ld	s3,8(sp)
    2fb8:	6a02                	ld	s4,0(sp)
    2fba:	6145                	addi	sp,sp,48
    2fbc:	8082                	ret
    sbrk(4096 - (top % 4096));
    2fbe:	0347d513          	srli	a0,a5,0x34
    2fc2:	6785                	lui	a5,0x1
    2fc4:	40a7853b          	subw	a0,a5,a0
    2fc8:	00003097          	auipc	ra,0x3
    2fcc:	d20080e7          	jalr	-736(ra) # 5ce8 <sbrk>
    2fd0:	bfa9                	j	2f2a <sbrklast+0x20>
    exit(1);
    2fd2:	4505                	li	a0,1
    2fd4:	00003097          	auipc	ra,0x3
    2fd8:	c8c080e7          	jalr	-884(ra) # 5c60 <exit>

0000000000002fdc <sbrk8000>:
{
    2fdc:	1141                	addi	sp,sp,-16
    2fde:	e406                	sd	ra,8(sp)
    2fe0:	e022                	sd	s0,0(sp)
    2fe2:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2fe4:	80000537          	lui	a0,0x80000
    2fe8:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2fea:	00003097          	auipc	ra,0x3
    2fee:	cfe080e7          	jalr	-770(ra) # 5ce8 <sbrk>
  volatile char *top = sbrk(0);
    2ff2:	4501                	li	a0,0
    2ff4:	00003097          	auipc	ra,0x3
    2ff8:	cf4080e7          	jalr	-780(ra) # 5ce8 <sbrk>
  *(top-1) = *(top-1) + 1;
    2ffc:	fff54783          	lbu	a5,-1(a0)
    3000:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x10d>
    3002:	0ff7f793          	zext.b	a5,a5
    3006:	fef50fa3          	sb	a5,-1(a0)
}
    300a:	60a2                	ld	ra,8(sp)
    300c:	6402                	ld	s0,0(sp)
    300e:	0141                	addi	sp,sp,16
    3010:	8082                	ret

0000000000003012 <execout>:
{
    3012:	715d                	addi	sp,sp,-80
    3014:	e486                	sd	ra,72(sp)
    3016:	e0a2                	sd	s0,64(sp)
    3018:	fc26                	sd	s1,56(sp)
    301a:	f84a                	sd	s2,48(sp)
    301c:	f44e                	sd	s3,40(sp)
    301e:	f052                	sd	s4,32(sp)
    3020:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    3022:	4901                	li	s2,0
    3024:	49bd                	li	s3,15
    int pid = fork();
    3026:	00003097          	auipc	ra,0x3
    302a:	c32080e7          	jalr	-974(ra) # 5c58 <fork>
    302e:	84aa                	mv	s1,a0
    if(pid < 0){
    3030:	02054063          	bltz	a0,3050 <execout+0x3e>
    } else if(pid == 0){
    3034:	c91d                	beqz	a0,306a <execout+0x58>
      wait((int*)0);
    3036:	4501                	li	a0,0
    3038:	00003097          	auipc	ra,0x3
    303c:	c30080e7          	jalr	-976(ra) # 5c68 <wait>
  for(int avail = 0; avail < 15; avail++){
    3040:	2905                	addiw	s2,s2,1
    3042:	ff3912e3          	bne	s2,s3,3026 <execout+0x14>
  exit(0);
    3046:	4501                	li	a0,0
    3048:	00003097          	auipc	ra,0x3
    304c:	c18080e7          	jalr	-1000(ra) # 5c60 <exit>
      printf("fork failed\n");
    3050:	00004517          	auipc	a0,0x4
    3054:	e0850513          	addi	a0,a0,-504 # 6e58 <malloc+0xdd0>
    3058:	00003097          	auipc	ra,0x3
    305c:	f78080e7          	jalr	-136(ra) # 5fd0 <printf>
      exit(1);
    3060:	4505                	li	a0,1
    3062:	00003097          	auipc	ra,0x3
    3066:	bfe080e7          	jalr	-1026(ra) # 5c60 <exit>
        if(a == 0xffffffffffffffffLL)
    306a:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    306c:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    306e:	6505                	lui	a0,0x1
    3070:	00003097          	auipc	ra,0x3
    3074:	c78080e7          	jalr	-904(ra) # 5ce8 <sbrk>
        if(a == 0xffffffffffffffffLL)
    3078:	01350763          	beq	a0,s3,3086 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    307c:	6785                	lui	a5,0x1
    307e:	97aa                	add	a5,a5,a0
    3080:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x10b>
      while(1){
    3084:	b7ed                	j	306e <execout+0x5c>
      for(int i = 0; i < avail; i++)
    3086:	01205a63          	blez	s2,309a <execout+0x88>
        sbrk(-4096);
    308a:	757d                	lui	a0,0xfffff
    308c:	00003097          	auipc	ra,0x3
    3090:	c5c080e7          	jalr	-932(ra) # 5ce8 <sbrk>
      for(int i = 0; i < avail; i++)
    3094:	2485                	addiw	s1,s1,1
    3096:	ff249ae3          	bne	s1,s2,308a <execout+0x78>
      close(1);
    309a:	4505                	li	a0,1
    309c:	00003097          	auipc	ra,0x3
    30a0:	bec080e7          	jalr	-1044(ra) # 5c88 <close>
      char *args[] = { "echo", "x", 0 };
    30a4:	00003517          	auipc	a0,0x3
    30a8:	12450513          	addi	a0,a0,292 # 61c8 <malloc+0x140>
    30ac:	faa43c23          	sd	a0,-72(s0)
    30b0:	00003797          	auipc	a5,0x3
    30b4:	18878793          	addi	a5,a5,392 # 6238 <malloc+0x1b0>
    30b8:	fcf43023          	sd	a5,-64(s0)
    30bc:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    30c0:	fb840593          	addi	a1,s0,-72
    30c4:	00003097          	auipc	ra,0x3
    30c8:	bd4080e7          	jalr	-1068(ra) # 5c98 <exec>
      exit(0);
    30cc:	4501                	li	a0,0
    30ce:	00003097          	auipc	ra,0x3
    30d2:	b92080e7          	jalr	-1134(ra) # 5c60 <exit>

00000000000030d6 <fourteen>:
{
    30d6:	1101                	addi	sp,sp,-32
    30d8:	ec06                	sd	ra,24(sp)
    30da:	e822                	sd	s0,16(sp)
    30dc:	e426                	sd	s1,8(sp)
    30de:	1000                	addi	s0,sp,32
    30e0:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    30e2:	00004517          	auipc	a0,0x4
    30e6:	38e50513          	addi	a0,a0,910 # 7470 <malloc+0x13e8>
    30ea:	00003097          	auipc	ra,0x3
    30ee:	bde080e7          	jalr	-1058(ra) # 5cc8 <mkdir>
    30f2:	e165                	bnez	a0,31d2 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    30f4:	00004517          	auipc	a0,0x4
    30f8:	1d450513          	addi	a0,a0,468 # 72c8 <malloc+0x1240>
    30fc:	00003097          	auipc	ra,0x3
    3100:	bcc080e7          	jalr	-1076(ra) # 5cc8 <mkdir>
    3104:	e56d                	bnez	a0,31ee <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3106:	20000593          	li	a1,512
    310a:	00004517          	auipc	a0,0x4
    310e:	21650513          	addi	a0,a0,534 # 7320 <malloc+0x1298>
    3112:	00003097          	auipc	ra,0x3
    3116:	b8e080e7          	jalr	-1138(ra) # 5ca0 <open>
  if(fd < 0){
    311a:	0e054863          	bltz	a0,320a <fourteen+0x134>
  close(fd);
    311e:	00003097          	auipc	ra,0x3
    3122:	b6a080e7          	jalr	-1174(ra) # 5c88 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3126:	4581                	li	a1,0
    3128:	00004517          	auipc	a0,0x4
    312c:	27050513          	addi	a0,a0,624 # 7398 <malloc+0x1310>
    3130:	00003097          	auipc	ra,0x3
    3134:	b70080e7          	jalr	-1168(ra) # 5ca0 <open>
  if(fd < 0){
    3138:	0e054763          	bltz	a0,3226 <fourteen+0x150>
  close(fd);
    313c:	00003097          	auipc	ra,0x3
    3140:	b4c080e7          	jalr	-1204(ra) # 5c88 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    3144:	00004517          	auipc	a0,0x4
    3148:	2c450513          	addi	a0,a0,708 # 7408 <malloc+0x1380>
    314c:	00003097          	auipc	ra,0x3
    3150:	b7c080e7          	jalr	-1156(ra) # 5cc8 <mkdir>
    3154:	c57d                	beqz	a0,3242 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    3156:	00004517          	auipc	a0,0x4
    315a:	30a50513          	addi	a0,a0,778 # 7460 <malloc+0x13d8>
    315e:	00003097          	auipc	ra,0x3
    3162:	b6a080e7          	jalr	-1174(ra) # 5cc8 <mkdir>
    3166:	cd65                	beqz	a0,325e <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    3168:	00004517          	auipc	a0,0x4
    316c:	2f850513          	addi	a0,a0,760 # 7460 <malloc+0x13d8>
    3170:	00003097          	auipc	ra,0x3
    3174:	b40080e7          	jalr	-1216(ra) # 5cb0 <unlink>
  unlink("12345678901234/12345678901234");
    3178:	00004517          	auipc	a0,0x4
    317c:	29050513          	addi	a0,a0,656 # 7408 <malloc+0x1380>
    3180:	00003097          	auipc	ra,0x3
    3184:	b30080e7          	jalr	-1232(ra) # 5cb0 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    3188:	00004517          	auipc	a0,0x4
    318c:	21050513          	addi	a0,a0,528 # 7398 <malloc+0x1310>
    3190:	00003097          	auipc	ra,0x3
    3194:	b20080e7          	jalr	-1248(ra) # 5cb0 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    3198:	00004517          	auipc	a0,0x4
    319c:	18850513          	addi	a0,a0,392 # 7320 <malloc+0x1298>
    31a0:	00003097          	auipc	ra,0x3
    31a4:	b10080e7          	jalr	-1264(ra) # 5cb0 <unlink>
  unlink("12345678901234/123456789012345");
    31a8:	00004517          	auipc	a0,0x4
    31ac:	12050513          	addi	a0,a0,288 # 72c8 <malloc+0x1240>
    31b0:	00003097          	auipc	ra,0x3
    31b4:	b00080e7          	jalr	-1280(ra) # 5cb0 <unlink>
  unlink("12345678901234");
    31b8:	00004517          	auipc	a0,0x4
    31bc:	2b850513          	addi	a0,a0,696 # 7470 <malloc+0x13e8>
    31c0:	00003097          	auipc	ra,0x3
    31c4:	af0080e7          	jalr	-1296(ra) # 5cb0 <unlink>
}
    31c8:	60e2                	ld	ra,24(sp)
    31ca:	6442                	ld	s0,16(sp)
    31cc:	64a2                	ld	s1,8(sp)
    31ce:	6105                	addi	sp,sp,32
    31d0:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    31d2:	85a6                	mv	a1,s1
    31d4:	00004517          	auipc	a0,0x4
    31d8:	0cc50513          	addi	a0,a0,204 # 72a0 <malloc+0x1218>
    31dc:	00003097          	auipc	ra,0x3
    31e0:	df4080e7          	jalr	-524(ra) # 5fd0 <printf>
    exit(1);
    31e4:	4505                	li	a0,1
    31e6:	00003097          	auipc	ra,0x3
    31ea:	a7a080e7          	jalr	-1414(ra) # 5c60 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    31ee:	85a6                	mv	a1,s1
    31f0:	00004517          	auipc	a0,0x4
    31f4:	0f850513          	addi	a0,a0,248 # 72e8 <malloc+0x1260>
    31f8:	00003097          	auipc	ra,0x3
    31fc:	dd8080e7          	jalr	-552(ra) # 5fd0 <printf>
    exit(1);
    3200:	4505                	li	a0,1
    3202:	00003097          	auipc	ra,0x3
    3206:	a5e080e7          	jalr	-1442(ra) # 5c60 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    320a:	85a6                	mv	a1,s1
    320c:	00004517          	auipc	a0,0x4
    3210:	14450513          	addi	a0,a0,324 # 7350 <malloc+0x12c8>
    3214:	00003097          	auipc	ra,0x3
    3218:	dbc080e7          	jalr	-580(ra) # 5fd0 <printf>
    exit(1);
    321c:	4505                	li	a0,1
    321e:	00003097          	auipc	ra,0x3
    3222:	a42080e7          	jalr	-1470(ra) # 5c60 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3226:	85a6                	mv	a1,s1
    3228:	00004517          	auipc	a0,0x4
    322c:	1a050513          	addi	a0,a0,416 # 73c8 <malloc+0x1340>
    3230:	00003097          	auipc	ra,0x3
    3234:	da0080e7          	jalr	-608(ra) # 5fd0 <printf>
    exit(1);
    3238:	4505                	li	a0,1
    323a:	00003097          	auipc	ra,0x3
    323e:	a26080e7          	jalr	-1498(ra) # 5c60 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3242:	85a6                	mv	a1,s1
    3244:	00004517          	auipc	a0,0x4
    3248:	1e450513          	addi	a0,a0,484 # 7428 <malloc+0x13a0>
    324c:	00003097          	auipc	ra,0x3
    3250:	d84080e7          	jalr	-636(ra) # 5fd0 <printf>
    exit(1);
    3254:	4505                	li	a0,1
    3256:	00003097          	auipc	ra,0x3
    325a:	a0a080e7          	jalr	-1526(ra) # 5c60 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    325e:	85a6                	mv	a1,s1
    3260:	00004517          	auipc	a0,0x4
    3264:	22050513          	addi	a0,a0,544 # 7480 <malloc+0x13f8>
    3268:	00003097          	auipc	ra,0x3
    326c:	d68080e7          	jalr	-664(ra) # 5fd0 <printf>
    exit(1);
    3270:	4505                	li	a0,1
    3272:	00003097          	auipc	ra,0x3
    3276:	9ee080e7          	jalr	-1554(ra) # 5c60 <exit>

000000000000327a <diskfull>:
{
    327a:	b9010113          	addi	sp,sp,-1136
    327e:	46113423          	sd	ra,1128(sp)
    3282:	46813023          	sd	s0,1120(sp)
    3286:	44913c23          	sd	s1,1112(sp)
    328a:	45213823          	sd	s2,1104(sp)
    328e:	45313423          	sd	s3,1096(sp)
    3292:	45413023          	sd	s4,1088(sp)
    3296:	43513c23          	sd	s5,1080(sp)
    329a:	43613823          	sd	s6,1072(sp)
    329e:	43713423          	sd	s7,1064(sp)
    32a2:	43813023          	sd	s8,1056(sp)
    32a6:	47010413          	addi	s0,sp,1136
    32aa:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    32ac:	00004517          	auipc	a0,0x4
    32b0:	20c50513          	addi	a0,a0,524 # 74b8 <malloc+0x1430>
    32b4:	00003097          	auipc	ra,0x3
    32b8:	9fc080e7          	jalr	-1540(ra) # 5cb0 <unlink>
  for(fi = 0; done == 0; fi++){
    32bc:	4a01                	li	s4,0
    name[0] = 'b';
    32be:	06200b13          	li	s6,98
    name[1] = 'i';
    32c2:	06900a93          	li	s5,105
    name[2] = 'g';
    32c6:	06700993          	li	s3,103
    32ca:	10c00b93          	li	s7,268
    32ce:	aabd                	j	344c <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    32d0:	b9040613          	addi	a2,s0,-1136
    32d4:	85e2                	mv	a1,s8
    32d6:	00004517          	auipc	a0,0x4
    32da:	1f250513          	addi	a0,a0,498 # 74c8 <malloc+0x1440>
    32de:	00003097          	auipc	ra,0x3
    32e2:	cf2080e7          	jalr	-782(ra) # 5fd0 <printf>
      break;
    32e6:	a821                	j	32fe <diskfull+0x84>
        close(fd);
    32e8:	854a                	mv	a0,s2
    32ea:	00003097          	auipc	ra,0x3
    32ee:	99e080e7          	jalr	-1634(ra) # 5c88 <close>
    close(fd);
    32f2:	854a                	mv	a0,s2
    32f4:	00003097          	auipc	ra,0x3
    32f8:	994080e7          	jalr	-1644(ra) # 5c88 <close>
  for(fi = 0; done == 0; fi++){
    32fc:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    32fe:	4481                	li	s1,0
    name[0] = 'z';
    3300:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3304:	08000993          	li	s3,128
    name[0] = 'z';
    3308:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    330c:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3310:	41f4d71b          	sraiw	a4,s1,0x1f
    3314:	01b7571b          	srliw	a4,a4,0x1b
    3318:	009707bb          	addw	a5,a4,s1
    331c:	4057d69b          	sraiw	a3,a5,0x5
    3320:	0306869b          	addiw	a3,a3,48
    3324:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3328:	8bfd                	andi	a5,a5,31
    332a:	9f99                	subw	a5,a5,a4
    332c:	0307879b          	addiw	a5,a5,48
    3330:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3334:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3338:	bb040513          	addi	a0,s0,-1104
    333c:	00003097          	auipc	ra,0x3
    3340:	974080e7          	jalr	-1676(ra) # 5cb0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3344:	60200593          	li	a1,1538
    3348:	bb040513          	addi	a0,s0,-1104
    334c:	00003097          	auipc	ra,0x3
    3350:	954080e7          	jalr	-1708(ra) # 5ca0 <open>
    if(fd < 0)
    3354:	00054963          	bltz	a0,3366 <diskfull+0xec>
    close(fd);
    3358:	00003097          	auipc	ra,0x3
    335c:	930080e7          	jalr	-1744(ra) # 5c88 <close>
  for(int i = 0; i < nzz; i++){
    3360:	2485                	addiw	s1,s1,1
    3362:	fb3493e3          	bne	s1,s3,3308 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    3366:	00004517          	auipc	a0,0x4
    336a:	15250513          	addi	a0,a0,338 # 74b8 <malloc+0x1430>
    336e:	00003097          	auipc	ra,0x3
    3372:	95a080e7          	jalr	-1702(ra) # 5cc8 <mkdir>
    3376:	12050963          	beqz	a0,34a8 <diskfull+0x22e>
  unlink("diskfulldir");
    337a:	00004517          	auipc	a0,0x4
    337e:	13e50513          	addi	a0,a0,318 # 74b8 <malloc+0x1430>
    3382:	00003097          	auipc	ra,0x3
    3386:	92e080e7          	jalr	-1746(ra) # 5cb0 <unlink>
  for(int i = 0; i < nzz; i++){
    338a:	4481                	li	s1,0
    name[0] = 'z';
    338c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3390:	08000993          	li	s3,128
    name[0] = 'z';
    3394:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3398:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    339c:	41f4d71b          	sraiw	a4,s1,0x1f
    33a0:	01b7571b          	srliw	a4,a4,0x1b
    33a4:	009707bb          	addw	a5,a4,s1
    33a8:	4057d69b          	sraiw	a3,a5,0x5
    33ac:	0306869b          	addiw	a3,a3,48
    33b0:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    33b4:	8bfd                	andi	a5,a5,31
    33b6:	9f99                	subw	a5,a5,a4
    33b8:	0307879b          	addiw	a5,a5,48
    33bc:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    33c0:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    33c4:	bb040513          	addi	a0,s0,-1104
    33c8:	00003097          	auipc	ra,0x3
    33cc:	8e8080e7          	jalr	-1816(ra) # 5cb0 <unlink>
  for(int i = 0; i < nzz; i++){
    33d0:	2485                	addiw	s1,s1,1
    33d2:	fd3491e3          	bne	s1,s3,3394 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    33d6:	03405e63          	blez	s4,3412 <diskfull+0x198>
    33da:	4481                	li	s1,0
    name[0] = 'b';
    33dc:	06200a93          	li	s5,98
    name[1] = 'i';
    33e0:	06900993          	li	s3,105
    name[2] = 'g';
    33e4:	06700913          	li	s2,103
    name[0] = 'b';
    33e8:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    33ec:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    33f0:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    33f4:	0304879b          	addiw	a5,s1,48
    33f8:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    33fc:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3400:	bb040513          	addi	a0,s0,-1104
    3404:	00003097          	auipc	ra,0x3
    3408:	8ac080e7          	jalr	-1876(ra) # 5cb0 <unlink>
  for(int i = 0; i < fi; i++){
    340c:	2485                	addiw	s1,s1,1
    340e:	fd449de3          	bne	s1,s4,33e8 <diskfull+0x16e>
}
    3412:	46813083          	ld	ra,1128(sp)
    3416:	46013403          	ld	s0,1120(sp)
    341a:	45813483          	ld	s1,1112(sp)
    341e:	45013903          	ld	s2,1104(sp)
    3422:	44813983          	ld	s3,1096(sp)
    3426:	44013a03          	ld	s4,1088(sp)
    342a:	43813a83          	ld	s5,1080(sp)
    342e:	43013b03          	ld	s6,1072(sp)
    3432:	42813b83          	ld	s7,1064(sp)
    3436:	42013c03          	ld	s8,1056(sp)
    343a:	47010113          	addi	sp,sp,1136
    343e:	8082                	ret
    close(fd);
    3440:	854a                	mv	a0,s2
    3442:	00003097          	auipc	ra,0x3
    3446:	846080e7          	jalr	-1978(ra) # 5c88 <close>
  for(fi = 0; done == 0; fi++){
    344a:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    344c:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    3450:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    3454:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    3458:	030a079b          	addiw	a5,s4,48
    345c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    3460:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3464:	b9040513          	addi	a0,s0,-1136
    3468:	00003097          	auipc	ra,0x3
    346c:	848080e7          	jalr	-1976(ra) # 5cb0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3470:	60200593          	li	a1,1538
    3474:	b9040513          	addi	a0,s0,-1136
    3478:	00003097          	auipc	ra,0x3
    347c:	828080e7          	jalr	-2008(ra) # 5ca0 <open>
    3480:	892a                	mv	s2,a0
    if(fd < 0){
    3482:	e40547e3          	bltz	a0,32d0 <diskfull+0x56>
    3486:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3488:	40000613          	li	a2,1024
    348c:	bb040593          	addi	a1,s0,-1104
    3490:	854a                	mv	a0,s2
    3492:	00002097          	auipc	ra,0x2
    3496:	7ee080e7          	jalr	2030(ra) # 5c80 <write>
    349a:	40000793          	li	a5,1024
    349e:	e4f515e3          	bne	a0,a5,32e8 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    34a2:	34fd                	addiw	s1,s1,-1
    34a4:	f0f5                	bnez	s1,3488 <diskfull+0x20e>
    34a6:	bf69                	j	3440 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    34a8:	00004517          	auipc	a0,0x4
    34ac:	04050513          	addi	a0,a0,64 # 74e8 <malloc+0x1460>
    34b0:	00003097          	auipc	ra,0x3
    34b4:	b20080e7          	jalr	-1248(ra) # 5fd0 <printf>
    34b8:	b5c9                	j	337a <diskfull+0x100>

00000000000034ba <iputtest>:
{
    34ba:	1101                	addi	sp,sp,-32
    34bc:	ec06                	sd	ra,24(sp)
    34be:	e822                	sd	s0,16(sp)
    34c0:	e426                	sd	s1,8(sp)
    34c2:	1000                	addi	s0,sp,32
    34c4:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    34c6:	00004517          	auipc	a0,0x4
    34ca:	05250513          	addi	a0,a0,82 # 7518 <malloc+0x1490>
    34ce:	00002097          	auipc	ra,0x2
    34d2:	7fa080e7          	jalr	2042(ra) # 5cc8 <mkdir>
    34d6:	04054563          	bltz	a0,3520 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    34da:	00004517          	auipc	a0,0x4
    34de:	03e50513          	addi	a0,a0,62 # 7518 <malloc+0x1490>
    34e2:	00002097          	auipc	ra,0x2
    34e6:	7ee080e7          	jalr	2030(ra) # 5cd0 <chdir>
    34ea:	04054963          	bltz	a0,353c <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    34ee:	00004517          	auipc	a0,0x4
    34f2:	06a50513          	addi	a0,a0,106 # 7558 <malloc+0x14d0>
    34f6:	00002097          	auipc	ra,0x2
    34fa:	7ba080e7          	jalr	1978(ra) # 5cb0 <unlink>
    34fe:	04054d63          	bltz	a0,3558 <iputtest+0x9e>
  if(chdir("/") < 0){
    3502:	00004517          	auipc	a0,0x4
    3506:	08650513          	addi	a0,a0,134 # 7588 <malloc+0x1500>
    350a:	00002097          	auipc	ra,0x2
    350e:	7c6080e7          	jalr	1990(ra) # 5cd0 <chdir>
    3512:	06054163          	bltz	a0,3574 <iputtest+0xba>
}
    3516:	60e2                	ld	ra,24(sp)
    3518:	6442                	ld	s0,16(sp)
    351a:	64a2                	ld	s1,8(sp)
    351c:	6105                	addi	sp,sp,32
    351e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3520:	85a6                	mv	a1,s1
    3522:	00004517          	auipc	a0,0x4
    3526:	ffe50513          	addi	a0,a0,-2 # 7520 <malloc+0x1498>
    352a:	00003097          	auipc	ra,0x3
    352e:	aa6080e7          	jalr	-1370(ra) # 5fd0 <printf>
    exit(1);
    3532:	4505                	li	a0,1
    3534:	00002097          	auipc	ra,0x2
    3538:	72c080e7          	jalr	1836(ra) # 5c60 <exit>
    printf("%s: chdir iputdir failed\n", s);
    353c:	85a6                	mv	a1,s1
    353e:	00004517          	auipc	a0,0x4
    3542:	ffa50513          	addi	a0,a0,-6 # 7538 <malloc+0x14b0>
    3546:	00003097          	auipc	ra,0x3
    354a:	a8a080e7          	jalr	-1398(ra) # 5fd0 <printf>
    exit(1);
    354e:	4505                	li	a0,1
    3550:	00002097          	auipc	ra,0x2
    3554:	710080e7          	jalr	1808(ra) # 5c60 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3558:	85a6                	mv	a1,s1
    355a:	00004517          	auipc	a0,0x4
    355e:	00e50513          	addi	a0,a0,14 # 7568 <malloc+0x14e0>
    3562:	00003097          	auipc	ra,0x3
    3566:	a6e080e7          	jalr	-1426(ra) # 5fd0 <printf>
    exit(1);
    356a:	4505                	li	a0,1
    356c:	00002097          	auipc	ra,0x2
    3570:	6f4080e7          	jalr	1780(ra) # 5c60 <exit>
    printf("%s: chdir / failed\n", s);
    3574:	85a6                	mv	a1,s1
    3576:	00004517          	auipc	a0,0x4
    357a:	01a50513          	addi	a0,a0,26 # 7590 <malloc+0x1508>
    357e:	00003097          	auipc	ra,0x3
    3582:	a52080e7          	jalr	-1454(ra) # 5fd0 <printf>
    exit(1);
    3586:	4505                	li	a0,1
    3588:	00002097          	auipc	ra,0x2
    358c:	6d8080e7          	jalr	1752(ra) # 5c60 <exit>

0000000000003590 <exitiputtest>:
{
    3590:	7179                	addi	sp,sp,-48
    3592:	f406                	sd	ra,40(sp)
    3594:	f022                	sd	s0,32(sp)
    3596:	ec26                	sd	s1,24(sp)
    3598:	1800                	addi	s0,sp,48
    359a:	84aa                	mv	s1,a0
  pid = fork();
    359c:	00002097          	auipc	ra,0x2
    35a0:	6bc080e7          	jalr	1724(ra) # 5c58 <fork>
  if(pid < 0){
    35a4:	04054663          	bltz	a0,35f0 <exitiputtest+0x60>
  if(pid == 0){
    35a8:	ed45                	bnez	a0,3660 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    35aa:	00004517          	auipc	a0,0x4
    35ae:	f6e50513          	addi	a0,a0,-146 # 7518 <malloc+0x1490>
    35b2:	00002097          	auipc	ra,0x2
    35b6:	716080e7          	jalr	1814(ra) # 5cc8 <mkdir>
    35ba:	04054963          	bltz	a0,360c <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    35be:	00004517          	auipc	a0,0x4
    35c2:	f5a50513          	addi	a0,a0,-166 # 7518 <malloc+0x1490>
    35c6:	00002097          	auipc	ra,0x2
    35ca:	70a080e7          	jalr	1802(ra) # 5cd0 <chdir>
    35ce:	04054d63          	bltz	a0,3628 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    35d2:	00004517          	auipc	a0,0x4
    35d6:	f8650513          	addi	a0,a0,-122 # 7558 <malloc+0x14d0>
    35da:	00002097          	auipc	ra,0x2
    35de:	6d6080e7          	jalr	1750(ra) # 5cb0 <unlink>
    35e2:	06054163          	bltz	a0,3644 <exitiputtest+0xb4>
    exit(0);
    35e6:	4501                	li	a0,0
    35e8:	00002097          	auipc	ra,0x2
    35ec:	678080e7          	jalr	1656(ra) # 5c60 <exit>
    printf("%s: fork failed\n", s);
    35f0:	85a6                	mv	a1,s1
    35f2:	00003517          	auipc	a0,0x3
    35f6:	45e50513          	addi	a0,a0,1118 # 6a50 <malloc+0x9c8>
    35fa:	00003097          	auipc	ra,0x3
    35fe:	9d6080e7          	jalr	-1578(ra) # 5fd0 <printf>
    exit(1);
    3602:	4505                	li	a0,1
    3604:	00002097          	auipc	ra,0x2
    3608:	65c080e7          	jalr	1628(ra) # 5c60 <exit>
      printf("%s: mkdir failed\n", s);
    360c:	85a6                	mv	a1,s1
    360e:	00004517          	auipc	a0,0x4
    3612:	f1250513          	addi	a0,a0,-238 # 7520 <malloc+0x1498>
    3616:	00003097          	auipc	ra,0x3
    361a:	9ba080e7          	jalr	-1606(ra) # 5fd0 <printf>
      exit(1);
    361e:	4505                	li	a0,1
    3620:	00002097          	auipc	ra,0x2
    3624:	640080e7          	jalr	1600(ra) # 5c60 <exit>
      printf("%s: child chdir failed\n", s);
    3628:	85a6                	mv	a1,s1
    362a:	00004517          	auipc	a0,0x4
    362e:	f7e50513          	addi	a0,a0,-130 # 75a8 <malloc+0x1520>
    3632:	00003097          	auipc	ra,0x3
    3636:	99e080e7          	jalr	-1634(ra) # 5fd0 <printf>
      exit(1);
    363a:	4505                	li	a0,1
    363c:	00002097          	auipc	ra,0x2
    3640:	624080e7          	jalr	1572(ra) # 5c60 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3644:	85a6                	mv	a1,s1
    3646:	00004517          	auipc	a0,0x4
    364a:	f2250513          	addi	a0,a0,-222 # 7568 <malloc+0x14e0>
    364e:	00003097          	auipc	ra,0x3
    3652:	982080e7          	jalr	-1662(ra) # 5fd0 <printf>
      exit(1);
    3656:	4505                	li	a0,1
    3658:	00002097          	auipc	ra,0x2
    365c:	608080e7          	jalr	1544(ra) # 5c60 <exit>
  wait(&xstatus);
    3660:	fdc40513          	addi	a0,s0,-36
    3664:	00002097          	auipc	ra,0x2
    3668:	604080e7          	jalr	1540(ra) # 5c68 <wait>
  exit(xstatus);
    366c:	fdc42503          	lw	a0,-36(s0)
    3670:	00002097          	auipc	ra,0x2
    3674:	5f0080e7          	jalr	1520(ra) # 5c60 <exit>

0000000000003678 <dirtest>:
{
    3678:	1101                	addi	sp,sp,-32
    367a:	ec06                	sd	ra,24(sp)
    367c:	e822                	sd	s0,16(sp)
    367e:	e426                	sd	s1,8(sp)
    3680:	1000                	addi	s0,sp,32
    3682:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3684:	00004517          	auipc	a0,0x4
    3688:	f3c50513          	addi	a0,a0,-196 # 75c0 <malloc+0x1538>
    368c:	00002097          	auipc	ra,0x2
    3690:	63c080e7          	jalr	1596(ra) # 5cc8 <mkdir>
    3694:	04054563          	bltz	a0,36de <dirtest+0x66>
  if(chdir("dir0") < 0){
    3698:	00004517          	auipc	a0,0x4
    369c:	f2850513          	addi	a0,a0,-216 # 75c0 <malloc+0x1538>
    36a0:	00002097          	auipc	ra,0x2
    36a4:	630080e7          	jalr	1584(ra) # 5cd0 <chdir>
    36a8:	04054963          	bltz	a0,36fa <dirtest+0x82>
  if(chdir("..") < 0){
    36ac:	00004517          	auipc	a0,0x4
    36b0:	f3450513          	addi	a0,a0,-204 # 75e0 <malloc+0x1558>
    36b4:	00002097          	auipc	ra,0x2
    36b8:	61c080e7          	jalr	1564(ra) # 5cd0 <chdir>
    36bc:	04054d63          	bltz	a0,3716 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    36c0:	00004517          	auipc	a0,0x4
    36c4:	f0050513          	addi	a0,a0,-256 # 75c0 <malloc+0x1538>
    36c8:	00002097          	auipc	ra,0x2
    36cc:	5e8080e7          	jalr	1512(ra) # 5cb0 <unlink>
    36d0:	06054163          	bltz	a0,3732 <dirtest+0xba>
}
    36d4:	60e2                	ld	ra,24(sp)
    36d6:	6442                	ld	s0,16(sp)
    36d8:	64a2                	ld	s1,8(sp)
    36da:	6105                	addi	sp,sp,32
    36dc:	8082                	ret
    printf("%s: mkdir failed\n", s);
    36de:	85a6                	mv	a1,s1
    36e0:	00004517          	auipc	a0,0x4
    36e4:	e4050513          	addi	a0,a0,-448 # 7520 <malloc+0x1498>
    36e8:	00003097          	auipc	ra,0x3
    36ec:	8e8080e7          	jalr	-1816(ra) # 5fd0 <printf>
    exit(1);
    36f0:	4505                	li	a0,1
    36f2:	00002097          	auipc	ra,0x2
    36f6:	56e080e7          	jalr	1390(ra) # 5c60 <exit>
    printf("%s: chdir dir0 failed\n", s);
    36fa:	85a6                	mv	a1,s1
    36fc:	00004517          	auipc	a0,0x4
    3700:	ecc50513          	addi	a0,a0,-308 # 75c8 <malloc+0x1540>
    3704:	00003097          	auipc	ra,0x3
    3708:	8cc080e7          	jalr	-1844(ra) # 5fd0 <printf>
    exit(1);
    370c:	4505                	li	a0,1
    370e:	00002097          	auipc	ra,0x2
    3712:	552080e7          	jalr	1362(ra) # 5c60 <exit>
    printf("%s: chdir .. failed\n", s);
    3716:	85a6                	mv	a1,s1
    3718:	00004517          	auipc	a0,0x4
    371c:	ed050513          	addi	a0,a0,-304 # 75e8 <malloc+0x1560>
    3720:	00003097          	auipc	ra,0x3
    3724:	8b0080e7          	jalr	-1872(ra) # 5fd0 <printf>
    exit(1);
    3728:	4505                	li	a0,1
    372a:	00002097          	auipc	ra,0x2
    372e:	536080e7          	jalr	1334(ra) # 5c60 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3732:	85a6                	mv	a1,s1
    3734:	00004517          	auipc	a0,0x4
    3738:	ecc50513          	addi	a0,a0,-308 # 7600 <malloc+0x1578>
    373c:	00003097          	auipc	ra,0x3
    3740:	894080e7          	jalr	-1900(ra) # 5fd0 <printf>
    exit(1);
    3744:	4505                	li	a0,1
    3746:	00002097          	auipc	ra,0x2
    374a:	51a080e7          	jalr	1306(ra) # 5c60 <exit>

000000000000374e <subdir>:
{
    374e:	1101                	addi	sp,sp,-32
    3750:	ec06                	sd	ra,24(sp)
    3752:	e822                	sd	s0,16(sp)
    3754:	e426                	sd	s1,8(sp)
    3756:	e04a                	sd	s2,0(sp)
    3758:	1000                	addi	s0,sp,32
    375a:	892a                	mv	s2,a0
  unlink("ff");
    375c:	00004517          	auipc	a0,0x4
    3760:	fec50513          	addi	a0,a0,-20 # 7748 <malloc+0x16c0>
    3764:	00002097          	auipc	ra,0x2
    3768:	54c080e7          	jalr	1356(ra) # 5cb0 <unlink>
  if(mkdir("dd") != 0){
    376c:	00004517          	auipc	a0,0x4
    3770:	eac50513          	addi	a0,a0,-340 # 7618 <malloc+0x1590>
    3774:	00002097          	auipc	ra,0x2
    3778:	554080e7          	jalr	1364(ra) # 5cc8 <mkdir>
    377c:	38051663          	bnez	a0,3b08 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3780:	20200593          	li	a1,514
    3784:	00004517          	auipc	a0,0x4
    3788:	eb450513          	addi	a0,a0,-332 # 7638 <malloc+0x15b0>
    378c:	00002097          	auipc	ra,0x2
    3790:	514080e7          	jalr	1300(ra) # 5ca0 <open>
    3794:	84aa                	mv	s1,a0
  if(fd < 0){
    3796:	38054763          	bltz	a0,3b24 <subdir+0x3d6>
  write(fd, "ff", 2);
    379a:	4609                	li	a2,2
    379c:	00004597          	auipc	a1,0x4
    37a0:	fac58593          	addi	a1,a1,-84 # 7748 <malloc+0x16c0>
    37a4:	00002097          	auipc	ra,0x2
    37a8:	4dc080e7          	jalr	1244(ra) # 5c80 <write>
  close(fd);
    37ac:	8526                	mv	a0,s1
    37ae:	00002097          	auipc	ra,0x2
    37b2:	4da080e7          	jalr	1242(ra) # 5c88 <close>
  if(unlink("dd") >= 0){
    37b6:	00004517          	auipc	a0,0x4
    37ba:	e6250513          	addi	a0,a0,-414 # 7618 <malloc+0x1590>
    37be:	00002097          	auipc	ra,0x2
    37c2:	4f2080e7          	jalr	1266(ra) # 5cb0 <unlink>
    37c6:	36055d63          	bgez	a0,3b40 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    37ca:	00004517          	auipc	a0,0x4
    37ce:	ec650513          	addi	a0,a0,-314 # 7690 <malloc+0x1608>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	4f6080e7          	jalr	1270(ra) # 5cc8 <mkdir>
    37da:	38051163          	bnez	a0,3b5c <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    37de:	20200593          	li	a1,514
    37e2:	00004517          	auipc	a0,0x4
    37e6:	ed650513          	addi	a0,a0,-298 # 76b8 <malloc+0x1630>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	4b6080e7          	jalr	1206(ra) # 5ca0 <open>
    37f2:	84aa                	mv	s1,a0
  if(fd < 0){
    37f4:	38054263          	bltz	a0,3b78 <subdir+0x42a>
  write(fd, "FF", 2);
    37f8:	4609                	li	a2,2
    37fa:	00004597          	auipc	a1,0x4
    37fe:	eee58593          	addi	a1,a1,-274 # 76e8 <malloc+0x1660>
    3802:	00002097          	auipc	ra,0x2
    3806:	47e080e7          	jalr	1150(ra) # 5c80 <write>
  close(fd);
    380a:	8526                	mv	a0,s1
    380c:	00002097          	auipc	ra,0x2
    3810:	47c080e7          	jalr	1148(ra) # 5c88 <close>
  fd = open("dd/dd/../ff", 0);
    3814:	4581                	li	a1,0
    3816:	00004517          	auipc	a0,0x4
    381a:	eda50513          	addi	a0,a0,-294 # 76f0 <malloc+0x1668>
    381e:	00002097          	auipc	ra,0x2
    3822:	482080e7          	jalr	1154(ra) # 5ca0 <open>
    3826:	84aa                	mv	s1,a0
  if(fd < 0){
    3828:	36054663          	bltz	a0,3b94 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    382c:	660d                	lui	a2,0x3
    382e:	00009597          	auipc	a1,0x9
    3832:	44a58593          	addi	a1,a1,1098 # cc78 <buf>
    3836:	00002097          	auipc	ra,0x2
    383a:	442080e7          	jalr	1090(ra) # 5c78 <read>
  if(cc != 2 || buf[0] != 'f'){
    383e:	4789                	li	a5,2
    3840:	36f51863          	bne	a0,a5,3bb0 <subdir+0x462>
    3844:	00009717          	auipc	a4,0x9
    3848:	43474703          	lbu	a4,1076(a4) # cc78 <buf>
    384c:	06600793          	li	a5,102
    3850:	36f71063          	bne	a4,a5,3bb0 <subdir+0x462>
  close(fd);
    3854:	8526                	mv	a0,s1
    3856:	00002097          	auipc	ra,0x2
    385a:	432080e7          	jalr	1074(ra) # 5c88 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    385e:	00004597          	auipc	a1,0x4
    3862:	ee258593          	addi	a1,a1,-286 # 7740 <malloc+0x16b8>
    3866:	00004517          	auipc	a0,0x4
    386a:	e5250513          	addi	a0,a0,-430 # 76b8 <malloc+0x1630>
    386e:	00002097          	auipc	ra,0x2
    3872:	452080e7          	jalr	1106(ra) # 5cc0 <link>
    3876:	34051b63          	bnez	a0,3bcc <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    387a:	00004517          	auipc	a0,0x4
    387e:	e3e50513          	addi	a0,a0,-450 # 76b8 <malloc+0x1630>
    3882:	00002097          	auipc	ra,0x2
    3886:	42e080e7          	jalr	1070(ra) # 5cb0 <unlink>
    388a:	34051f63          	bnez	a0,3be8 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    388e:	4581                	li	a1,0
    3890:	00004517          	auipc	a0,0x4
    3894:	e2850513          	addi	a0,a0,-472 # 76b8 <malloc+0x1630>
    3898:	00002097          	auipc	ra,0x2
    389c:	408080e7          	jalr	1032(ra) # 5ca0 <open>
    38a0:	36055263          	bgez	a0,3c04 <subdir+0x4b6>
  if(chdir("dd") != 0){
    38a4:	00004517          	auipc	a0,0x4
    38a8:	d7450513          	addi	a0,a0,-652 # 7618 <malloc+0x1590>
    38ac:	00002097          	auipc	ra,0x2
    38b0:	424080e7          	jalr	1060(ra) # 5cd0 <chdir>
    38b4:	36051663          	bnez	a0,3c20 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    38b8:	00004517          	auipc	a0,0x4
    38bc:	f2050513          	addi	a0,a0,-224 # 77d8 <malloc+0x1750>
    38c0:	00002097          	auipc	ra,0x2
    38c4:	410080e7          	jalr	1040(ra) # 5cd0 <chdir>
    38c8:	36051a63          	bnez	a0,3c3c <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    38cc:	00004517          	auipc	a0,0x4
    38d0:	f3c50513          	addi	a0,a0,-196 # 7808 <malloc+0x1780>
    38d4:	00002097          	auipc	ra,0x2
    38d8:	3fc080e7          	jalr	1020(ra) # 5cd0 <chdir>
    38dc:	36051e63          	bnez	a0,3c58 <subdir+0x50a>
  if(chdir("./..") != 0){
    38e0:	00004517          	auipc	a0,0x4
    38e4:	f5850513          	addi	a0,a0,-168 # 7838 <malloc+0x17b0>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	3e8080e7          	jalr	1000(ra) # 5cd0 <chdir>
    38f0:	38051263          	bnez	a0,3c74 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    38f4:	4581                	li	a1,0
    38f6:	00004517          	auipc	a0,0x4
    38fa:	e4a50513          	addi	a0,a0,-438 # 7740 <malloc+0x16b8>
    38fe:	00002097          	auipc	ra,0x2
    3902:	3a2080e7          	jalr	930(ra) # 5ca0 <open>
    3906:	84aa                	mv	s1,a0
  if(fd < 0){
    3908:	38054463          	bltz	a0,3c90 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    390c:	660d                	lui	a2,0x3
    390e:	00009597          	auipc	a1,0x9
    3912:	36a58593          	addi	a1,a1,874 # cc78 <buf>
    3916:	00002097          	auipc	ra,0x2
    391a:	362080e7          	jalr	866(ra) # 5c78 <read>
    391e:	4789                	li	a5,2
    3920:	38f51663          	bne	a0,a5,3cac <subdir+0x55e>
  close(fd);
    3924:	8526                	mv	a0,s1
    3926:	00002097          	auipc	ra,0x2
    392a:	362080e7          	jalr	866(ra) # 5c88 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    392e:	4581                	li	a1,0
    3930:	00004517          	auipc	a0,0x4
    3934:	d8850513          	addi	a0,a0,-632 # 76b8 <malloc+0x1630>
    3938:	00002097          	auipc	ra,0x2
    393c:	368080e7          	jalr	872(ra) # 5ca0 <open>
    3940:	38055463          	bgez	a0,3cc8 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3944:	20200593          	li	a1,514
    3948:	00004517          	auipc	a0,0x4
    394c:	f8050513          	addi	a0,a0,-128 # 78c8 <malloc+0x1840>
    3950:	00002097          	auipc	ra,0x2
    3954:	350080e7          	jalr	848(ra) # 5ca0 <open>
    3958:	38055663          	bgez	a0,3ce4 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    395c:	20200593          	li	a1,514
    3960:	00004517          	auipc	a0,0x4
    3964:	f9850513          	addi	a0,a0,-104 # 78f8 <malloc+0x1870>
    3968:	00002097          	auipc	ra,0x2
    396c:	338080e7          	jalr	824(ra) # 5ca0 <open>
    3970:	38055863          	bgez	a0,3d00 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3974:	20000593          	li	a1,512
    3978:	00004517          	auipc	a0,0x4
    397c:	ca050513          	addi	a0,a0,-864 # 7618 <malloc+0x1590>
    3980:	00002097          	auipc	ra,0x2
    3984:	320080e7          	jalr	800(ra) # 5ca0 <open>
    3988:	38055a63          	bgez	a0,3d1c <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    398c:	4589                	li	a1,2
    398e:	00004517          	auipc	a0,0x4
    3992:	c8a50513          	addi	a0,a0,-886 # 7618 <malloc+0x1590>
    3996:	00002097          	auipc	ra,0x2
    399a:	30a080e7          	jalr	778(ra) # 5ca0 <open>
    399e:	38055d63          	bgez	a0,3d38 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    39a2:	4585                	li	a1,1
    39a4:	00004517          	auipc	a0,0x4
    39a8:	c7450513          	addi	a0,a0,-908 # 7618 <malloc+0x1590>
    39ac:	00002097          	auipc	ra,0x2
    39b0:	2f4080e7          	jalr	756(ra) # 5ca0 <open>
    39b4:	3a055063          	bgez	a0,3d54 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    39b8:	00004597          	auipc	a1,0x4
    39bc:	fd058593          	addi	a1,a1,-48 # 7988 <malloc+0x1900>
    39c0:	00004517          	auipc	a0,0x4
    39c4:	f0850513          	addi	a0,a0,-248 # 78c8 <malloc+0x1840>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	2f8080e7          	jalr	760(ra) # 5cc0 <link>
    39d0:	3a050063          	beqz	a0,3d70 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    39d4:	00004597          	auipc	a1,0x4
    39d8:	fb458593          	addi	a1,a1,-76 # 7988 <malloc+0x1900>
    39dc:	00004517          	auipc	a0,0x4
    39e0:	f1c50513          	addi	a0,a0,-228 # 78f8 <malloc+0x1870>
    39e4:	00002097          	auipc	ra,0x2
    39e8:	2dc080e7          	jalr	732(ra) # 5cc0 <link>
    39ec:	3a050063          	beqz	a0,3d8c <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    39f0:	00004597          	auipc	a1,0x4
    39f4:	d5058593          	addi	a1,a1,-688 # 7740 <malloc+0x16b8>
    39f8:	00004517          	auipc	a0,0x4
    39fc:	c4050513          	addi	a0,a0,-960 # 7638 <malloc+0x15b0>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	2c0080e7          	jalr	704(ra) # 5cc0 <link>
    3a08:	3a050063          	beqz	a0,3da8 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	ebc50513          	addi	a0,a0,-324 # 78c8 <malloc+0x1840>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	2b4080e7          	jalr	692(ra) # 5cc8 <mkdir>
    3a1c:	3a050463          	beqz	a0,3dc4 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3a20:	00004517          	auipc	a0,0x4
    3a24:	ed850513          	addi	a0,a0,-296 # 78f8 <malloc+0x1870>
    3a28:	00002097          	auipc	ra,0x2
    3a2c:	2a0080e7          	jalr	672(ra) # 5cc8 <mkdir>
    3a30:	3a050863          	beqz	a0,3de0 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3a34:	00004517          	auipc	a0,0x4
    3a38:	d0c50513          	addi	a0,a0,-756 # 7740 <malloc+0x16b8>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	28c080e7          	jalr	652(ra) # 5cc8 <mkdir>
    3a44:	3a050c63          	beqz	a0,3dfc <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3a48:	00004517          	auipc	a0,0x4
    3a4c:	eb050513          	addi	a0,a0,-336 # 78f8 <malloc+0x1870>
    3a50:	00002097          	auipc	ra,0x2
    3a54:	260080e7          	jalr	608(ra) # 5cb0 <unlink>
    3a58:	3c050063          	beqz	a0,3e18 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3a5c:	00004517          	auipc	a0,0x4
    3a60:	e6c50513          	addi	a0,a0,-404 # 78c8 <malloc+0x1840>
    3a64:	00002097          	auipc	ra,0x2
    3a68:	24c080e7          	jalr	588(ra) # 5cb0 <unlink>
    3a6c:	3c050463          	beqz	a0,3e34 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3a70:	00004517          	auipc	a0,0x4
    3a74:	bc850513          	addi	a0,a0,-1080 # 7638 <malloc+0x15b0>
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	258080e7          	jalr	600(ra) # 5cd0 <chdir>
    3a80:	3c050863          	beqz	a0,3e50 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3a84:	00004517          	auipc	a0,0x4
    3a88:	05450513          	addi	a0,a0,84 # 7ad8 <malloc+0x1a50>
    3a8c:	00002097          	auipc	ra,0x2
    3a90:	244080e7          	jalr	580(ra) # 5cd0 <chdir>
    3a94:	3c050c63          	beqz	a0,3e6c <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3a98:	00004517          	auipc	a0,0x4
    3a9c:	ca850513          	addi	a0,a0,-856 # 7740 <malloc+0x16b8>
    3aa0:	00002097          	auipc	ra,0x2
    3aa4:	210080e7          	jalr	528(ra) # 5cb0 <unlink>
    3aa8:	3e051063          	bnez	a0,3e88 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3aac:	00004517          	auipc	a0,0x4
    3ab0:	b8c50513          	addi	a0,a0,-1140 # 7638 <malloc+0x15b0>
    3ab4:	00002097          	auipc	ra,0x2
    3ab8:	1fc080e7          	jalr	508(ra) # 5cb0 <unlink>
    3abc:	3e051463          	bnez	a0,3ea4 <subdir+0x756>
  if(unlink("dd") == 0){
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	b5850513          	addi	a0,a0,-1192 # 7618 <malloc+0x1590>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	1e8080e7          	jalr	488(ra) # 5cb0 <unlink>
    3ad0:	3e050863          	beqz	a0,3ec0 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3ad4:	00004517          	auipc	a0,0x4
    3ad8:	07450513          	addi	a0,a0,116 # 7b48 <malloc+0x1ac0>
    3adc:	00002097          	auipc	ra,0x2
    3ae0:	1d4080e7          	jalr	468(ra) # 5cb0 <unlink>
    3ae4:	3e054c63          	bltz	a0,3edc <subdir+0x78e>
  if(unlink("dd") < 0){
    3ae8:	00004517          	auipc	a0,0x4
    3aec:	b3050513          	addi	a0,a0,-1232 # 7618 <malloc+0x1590>
    3af0:	00002097          	auipc	ra,0x2
    3af4:	1c0080e7          	jalr	448(ra) # 5cb0 <unlink>
    3af8:	40054063          	bltz	a0,3ef8 <subdir+0x7aa>
}
    3afc:	60e2                	ld	ra,24(sp)
    3afe:	6442                	ld	s0,16(sp)
    3b00:	64a2                	ld	s1,8(sp)
    3b02:	6902                	ld	s2,0(sp)
    3b04:	6105                	addi	sp,sp,32
    3b06:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3b08:	85ca                	mv	a1,s2
    3b0a:	00004517          	auipc	a0,0x4
    3b0e:	b1650513          	addi	a0,a0,-1258 # 7620 <malloc+0x1598>
    3b12:	00002097          	auipc	ra,0x2
    3b16:	4be080e7          	jalr	1214(ra) # 5fd0 <printf>
    exit(1);
    3b1a:	4505                	li	a0,1
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	144080e7          	jalr	324(ra) # 5c60 <exit>
    printf("%s: create dd/ff failed\n", s);
    3b24:	85ca                	mv	a1,s2
    3b26:	00004517          	auipc	a0,0x4
    3b2a:	b1a50513          	addi	a0,a0,-1254 # 7640 <malloc+0x15b8>
    3b2e:	00002097          	auipc	ra,0x2
    3b32:	4a2080e7          	jalr	1186(ra) # 5fd0 <printf>
    exit(1);
    3b36:	4505                	li	a0,1
    3b38:	00002097          	auipc	ra,0x2
    3b3c:	128080e7          	jalr	296(ra) # 5c60 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3b40:	85ca                	mv	a1,s2
    3b42:	00004517          	auipc	a0,0x4
    3b46:	b1e50513          	addi	a0,a0,-1250 # 7660 <malloc+0x15d8>
    3b4a:	00002097          	auipc	ra,0x2
    3b4e:	486080e7          	jalr	1158(ra) # 5fd0 <printf>
    exit(1);
    3b52:	4505                	li	a0,1
    3b54:	00002097          	auipc	ra,0x2
    3b58:	10c080e7          	jalr	268(ra) # 5c60 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3b5c:	85ca                	mv	a1,s2
    3b5e:	00004517          	auipc	a0,0x4
    3b62:	b3a50513          	addi	a0,a0,-1222 # 7698 <malloc+0x1610>
    3b66:	00002097          	auipc	ra,0x2
    3b6a:	46a080e7          	jalr	1130(ra) # 5fd0 <printf>
    exit(1);
    3b6e:	4505                	li	a0,1
    3b70:	00002097          	auipc	ra,0x2
    3b74:	0f0080e7          	jalr	240(ra) # 5c60 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3b78:	85ca                	mv	a1,s2
    3b7a:	00004517          	auipc	a0,0x4
    3b7e:	b4e50513          	addi	a0,a0,-1202 # 76c8 <malloc+0x1640>
    3b82:	00002097          	auipc	ra,0x2
    3b86:	44e080e7          	jalr	1102(ra) # 5fd0 <printf>
    exit(1);
    3b8a:	4505                	li	a0,1
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	0d4080e7          	jalr	212(ra) # 5c60 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3b94:	85ca                	mv	a1,s2
    3b96:	00004517          	auipc	a0,0x4
    3b9a:	b6a50513          	addi	a0,a0,-1174 # 7700 <malloc+0x1678>
    3b9e:	00002097          	auipc	ra,0x2
    3ba2:	432080e7          	jalr	1074(ra) # 5fd0 <printf>
    exit(1);
    3ba6:	4505                	li	a0,1
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	0b8080e7          	jalr	184(ra) # 5c60 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3bb0:	85ca                	mv	a1,s2
    3bb2:	00004517          	auipc	a0,0x4
    3bb6:	b6e50513          	addi	a0,a0,-1170 # 7720 <malloc+0x1698>
    3bba:	00002097          	auipc	ra,0x2
    3bbe:	416080e7          	jalr	1046(ra) # 5fd0 <printf>
    exit(1);
    3bc2:	4505                	li	a0,1
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	09c080e7          	jalr	156(ra) # 5c60 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3bcc:	85ca                	mv	a1,s2
    3bce:	00004517          	auipc	a0,0x4
    3bd2:	b8250513          	addi	a0,a0,-1150 # 7750 <malloc+0x16c8>
    3bd6:	00002097          	auipc	ra,0x2
    3bda:	3fa080e7          	jalr	1018(ra) # 5fd0 <printf>
    exit(1);
    3bde:	4505                	li	a0,1
    3be0:	00002097          	auipc	ra,0x2
    3be4:	080080e7          	jalr	128(ra) # 5c60 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3be8:	85ca                	mv	a1,s2
    3bea:	00004517          	auipc	a0,0x4
    3bee:	b8e50513          	addi	a0,a0,-1138 # 7778 <malloc+0x16f0>
    3bf2:	00002097          	auipc	ra,0x2
    3bf6:	3de080e7          	jalr	990(ra) # 5fd0 <printf>
    exit(1);
    3bfa:	4505                	li	a0,1
    3bfc:	00002097          	auipc	ra,0x2
    3c00:	064080e7          	jalr	100(ra) # 5c60 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3c04:	85ca                	mv	a1,s2
    3c06:	00004517          	auipc	a0,0x4
    3c0a:	b9250513          	addi	a0,a0,-1134 # 7798 <malloc+0x1710>
    3c0e:	00002097          	auipc	ra,0x2
    3c12:	3c2080e7          	jalr	962(ra) # 5fd0 <printf>
    exit(1);
    3c16:	4505                	li	a0,1
    3c18:	00002097          	auipc	ra,0x2
    3c1c:	048080e7          	jalr	72(ra) # 5c60 <exit>
    printf("%s: chdir dd failed\n", s);
    3c20:	85ca                	mv	a1,s2
    3c22:	00004517          	auipc	a0,0x4
    3c26:	b9e50513          	addi	a0,a0,-1122 # 77c0 <malloc+0x1738>
    3c2a:	00002097          	auipc	ra,0x2
    3c2e:	3a6080e7          	jalr	934(ra) # 5fd0 <printf>
    exit(1);
    3c32:	4505                	li	a0,1
    3c34:	00002097          	auipc	ra,0x2
    3c38:	02c080e7          	jalr	44(ra) # 5c60 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3c3c:	85ca                	mv	a1,s2
    3c3e:	00004517          	auipc	a0,0x4
    3c42:	baa50513          	addi	a0,a0,-1110 # 77e8 <malloc+0x1760>
    3c46:	00002097          	auipc	ra,0x2
    3c4a:	38a080e7          	jalr	906(ra) # 5fd0 <printf>
    exit(1);
    3c4e:	4505                	li	a0,1
    3c50:	00002097          	auipc	ra,0x2
    3c54:	010080e7          	jalr	16(ra) # 5c60 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3c58:	85ca                	mv	a1,s2
    3c5a:	00004517          	auipc	a0,0x4
    3c5e:	bbe50513          	addi	a0,a0,-1090 # 7818 <malloc+0x1790>
    3c62:	00002097          	auipc	ra,0x2
    3c66:	36e080e7          	jalr	878(ra) # 5fd0 <printf>
    exit(1);
    3c6a:	4505                	li	a0,1
    3c6c:	00002097          	auipc	ra,0x2
    3c70:	ff4080e7          	jalr	-12(ra) # 5c60 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3c74:	85ca                	mv	a1,s2
    3c76:	00004517          	auipc	a0,0x4
    3c7a:	bca50513          	addi	a0,a0,-1078 # 7840 <malloc+0x17b8>
    3c7e:	00002097          	auipc	ra,0x2
    3c82:	352080e7          	jalr	850(ra) # 5fd0 <printf>
    exit(1);
    3c86:	4505                	li	a0,1
    3c88:	00002097          	auipc	ra,0x2
    3c8c:	fd8080e7          	jalr	-40(ra) # 5c60 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3c90:	85ca                	mv	a1,s2
    3c92:	00004517          	auipc	a0,0x4
    3c96:	bc650513          	addi	a0,a0,-1082 # 7858 <malloc+0x17d0>
    3c9a:	00002097          	auipc	ra,0x2
    3c9e:	336080e7          	jalr	822(ra) # 5fd0 <printf>
    exit(1);
    3ca2:	4505                	li	a0,1
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	fbc080e7          	jalr	-68(ra) # 5c60 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3cac:	85ca                	mv	a1,s2
    3cae:	00004517          	auipc	a0,0x4
    3cb2:	bca50513          	addi	a0,a0,-1078 # 7878 <malloc+0x17f0>
    3cb6:	00002097          	auipc	ra,0x2
    3cba:	31a080e7          	jalr	794(ra) # 5fd0 <printf>
    exit(1);
    3cbe:	4505                	li	a0,1
    3cc0:	00002097          	auipc	ra,0x2
    3cc4:	fa0080e7          	jalr	-96(ra) # 5c60 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3cc8:	85ca                	mv	a1,s2
    3cca:	00004517          	auipc	a0,0x4
    3cce:	bce50513          	addi	a0,a0,-1074 # 7898 <malloc+0x1810>
    3cd2:	00002097          	auipc	ra,0x2
    3cd6:	2fe080e7          	jalr	766(ra) # 5fd0 <printf>
    exit(1);
    3cda:	4505                	li	a0,1
    3cdc:	00002097          	auipc	ra,0x2
    3ce0:	f84080e7          	jalr	-124(ra) # 5c60 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3ce4:	85ca                	mv	a1,s2
    3ce6:	00004517          	auipc	a0,0x4
    3cea:	bf250513          	addi	a0,a0,-1038 # 78d8 <malloc+0x1850>
    3cee:	00002097          	auipc	ra,0x2
    3cf2:	2e2080e7          	jalr	738(ra) # 5fd0 <printf>
    exit(1);
    3cf6:	4505                	li	a0,1
    3cf8:	00002097          	auipc	ra,0x2
    3cfc:	f68080e7          	jalr	-152(ra) # 5c60 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3d00:	85ca                	mv	a1,s2
    3d02:	00004517          	auipc	a0,0x4
    3d06:	c0650513          	addi	a0,a0,-1018 # 7908 <malloc+0x1880>
    3d0a:	00002097          	auipc	ra,0x2
    3d0e:	2c6080e7          	jalr	710(ra) # 5fd0 <printf>
    exit(1);
    3d12:	4505                	li	a0,1
    3d14:	00002097          	auipc	ra,0x2
    3d18:	f4c080e7          	jalr	-180(ra) # 5c60 <exit>
    printf("%s: create dd succeeded!\n", s);
    3d1c:	85ca                	mv	a1,s2
    3d1e:	00004517          	auipc	a0,0x4
    3d22:	c0a50513          	addi	a0,a0,-1014 # 7928 <malloc+0x18a0>
    3d26:	00002097          	auipc	ra,0x2
    3d2a:	2aa080e7          	jalr	682(ra) # 5fd0 <printf>
    exit(1);
    3d2e:	4505                	li	a0,1
    3d30:	00002097          	auipc	ra,0x2
    3d34:	f30080e7          	jalr	-208(ra) # 5c60 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3d38:	85ca                	mv	a1,s2
    3d3a:	00004517          	auipc	a0,0x4
    3d3e:	c0e50513          	addi	a0,a0,-1010 # 7948 <malloc+0x18c0>
    3d42:	00002097          	auipc	ra,0x2
    3d46:	28e080e7          	jalr	654(ra) # 5fd0 <printf>
    exit(1);
    3d4a:	4505                	li	a0,1
    3d4c:	00002097          	auipc	ra,0x2
    3d50:	f14080e7          	jalr	-236(ra) # 5c60 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3d54:	85ca                	mv	a1,s2
    3d56:	00004517          	auipc	a0,0x4
    3d5a:	c1250513          	addi	a0,a0,-1006 # 7968 <malloc+0x18e0>
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	272080e7          	jalr	626(ra) # 5fd0 <printf>
    exit(1);
    3d66:	4505                	li	a0,1
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	ef8080e7          	jalr	-264(ra) # 5c60 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3d70:	85ca                	mv	a1,s2
    3d72:	00004517          	auipc	a0,0x4
    3d76:	c2650513          	addi	a0,a0,-986 # 7998 <malloc+0x1910>
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	256080e7          	jalr	598(ra) # 5fd0 <printf>
    exit(1);
    3d82:	4505                	li	a0,1
    3d84:	00002097          	auipc	ra,0x2
    3d88:	edc080e7          	jalr	-292(ra) # 5c60 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3d8c:	85ca                	mv	a1,s2
    3d8e:	00004517          	auipc	a0,0x4
    3d92:	c3250513          	addi	a0,a0,-974 # 79c0 <malloc+0x1938>
    3d96:	00002097          	auipc	ra,0x2
    3d9a:	23a080e7          	jalr	570(ra) # 5fd0 <printf>
    exit(1);
    3d9e:	4505                	li	a0,1
    3da0:	00002097          	auipc	ra,0x2
    3da4:	ec0080e7          	jalr	-320(ra) # 5c60 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3da8:	85ca                	mv	a1,s2
    3daa:	00004517          	auipc	a0,0x4
    3dae:	c3e50513          	addi	a0,a0,-962 # 79e8 <malloc+0x1960>
    3db2:	00002097          	auipc	ra,0x2
    3db6:	21e080e7          	jalr	542(ra) # 5fd0 <printf>
    exit(1);
    3dba:	4505                	li	a0,1
    3dbc:	00002097          	auipc	ra,0x2
    3dc0:	ea4080e7          	jalr	-348(ra) # 5c60 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3dc4:	85ca                	mv	a1,s2
    3dc6:	00004517          	auipc	a0,0x4
    3dca:	c4a50513          	addi	a0,a0,-950 # 7a10 <malloc+0x1988>
    3dce:	00002097          	auipc	ra,0x2
    3dd2:	202080e7          	jalr	514(ra) # 5fd0 <printf>
    exit(1);
    3dd6:	4505                	li	a0,1
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	e88080e7          	jalr	-376(ra) # 5c60 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3de0:	85ca                	mv	a1,s2
    3de2:	00004517          	auipc	a0,0x4
    3de6:	c4e50513          	addi	a0,a0,-946 # 7a30 <malloc+0x19a8>
    3dea:	00002097          	auipc	ra,0x2
    3dee:	1e6080e7          	jalr	486(ra) # 5fd0 <printf>
    exit(1);
    3df2:	4505                	li	a0,1
    3df4:	00002097          	auipc	ra,0x2
    3df8:	e6c080e7          	jalr	-404(ra) # 5c60 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3dfc:	85ca                	mv	a1,s2
    3dfe:	00004517          	auipc	a0,0x4
    3e02:	c5250513          	addi	a0,a0,-942 # 7a50 <malloc+0x19c8>
    3e06:	00002097          	auipc	ra,0x2
    3e0a:	1ca080e7          	jalr	458(ra) # 5fd0 <printf>
    exit(1);
    3e0e:	4505                	li	a0,1
    3e10:	00002097          	auipc	ra,0x2
    3e14:	e50080e7          	jalr	-432(ra) # 5c60 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3e18:	85ca                	mv	a1,s2
    3e1a:	00004517          	auipc	a0,0x4
    3e1e:	c5e50513          	addi	a0,a0,-930 # 7a78 <malloc+0x19f0>
    3e22:	00002097          	auipc	ra,0x2
    3e26:	1ae080e7          	jalr	430(ra) # 5fd0 <printf>
    exit(1);
    3e2a:	4505                	li	a0,1
    3e2c:	00002097          	auipc	ra,0x2
    3e30:	e34080e7          	jalr	-460(ra) # 5c60 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3e34:	85ca                	mv	a1,s2
    3e36:	00004517          	auipc	a0,0x4
    3e3a:	c6250513          	addi	a0,a0,-926 # 7a98 <malloc+0x1a10>
    3e3e:	00002097          	auipc	ra,0x2
    3e42:	192080e7          	jalr	402(ra) # 5fd0 <printf>
    exit(1);
    3e46:	4505                	li	a0,1
    3e48:	00002097          	auipc	ra,0x2
    3e4c:	e18080e7          	jalr	-488(ra) # 5c60 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3e50:	85ca                	mv	a1,s2
    3e52:	00004517          	auipc	a0,0x4
    3e56:	c6650513          	addi	a0,a0,-922 # 7ab8 <malloc+0x1a30>
    3e5a:	00002097          	auipc	ra,0x2
    3e5e:	176080e7          	jalr	374(ra) # 5fd0 <printf>
    exit(1);
    3e62:	4505                	li	a0,1
    3e64:	00002097          	auipc	ra,0x2
    3e68:	dfc080e7          	jalr	-516(ra) # 5c60 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3e6c:	85ca                	mv	a1,s2
    3e6e:	00004517          	auipc	a0,0x4
    3e72:	c7250513          	addi	a0,a0,-910 # 7ae0 <malloc+0x1a58>
    3e76:	00002097          	auipc	ra,0x2
    3e7a:	15a080e7          	jalr	346(ra) # 5fd0 <printf>
    exit(1);
    3e7e:	4505                	li	a0,1
    3e80:	00002097          	auipc	ra,0x2
    3e84:	de0080e7          	jalr	-544(ra) # 5c60 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3e88:	85ca                	mv	a1,s2
    3e8a:	00004517          	auipc	a0,0x4
    3e8e:	8ee50513          	addi	a0,a0,-1810 # 7778 <malloc+0x16f0>
    3e92:	00002097          	auipc	ra,0x2
    3e96:	13e080e7          	jalr	318(ra) # 5fd0 <printf>
    exit(1);
    3e9a:	4505                	li	a0,1
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	dc4080e7          	jalr	-572(ra) # 5c60 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3ea4:	85ca                	mv	a1,s2
    3ea6:	00004517          	auipc	a0,0x4
    3eaa:	c5a50513          	addi	a0,a0,-934 # 7b00 <malloc+0x1a78>
    3eae:	00002097          	auipc	ra,0x2
    3eb2:	122080e7          	jalr	290(ra) # 5fd0 <printf>
    exit(1);
    3eb6:	4505                	li	a0,1
    3eb8:	00002097          	auipc	ra,0x2
    3ebc:	da8080e7          	jalr	-600(ra) # 5c60 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3ec0:	85ca                	mv	a1,s2
    3ec2:	00004517          	auipc	a0,0x4
    3ec6:	c5e50513          	addi	a0,a0,-930 # 7b20 <malloc+0x1a98>
    3eca:	00002097          	auipc	ra,0x2
    3ece:	106080e7          	jalr	262(ra) # 5fd0 <printf>
    exit(1);
    3ed2:	4505                	li	a0,1
    3ed4:	00002097          	auipc	ra,0x2
    3ed8:	d8c080e7          	jalr	-628(ra) # 5c60 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3edc:	85ca                	mv	a1,s2
    3ede:	00004517          	auipc	a0,0x4
    3ee2:	c7250513          	addi	a0,a0,-910 # 7b50 <malloc+0x1ac8>
    3ee6:	00002097          	auipc	ra,0x2
    3eea:	0ea080e7          	jalr	234(ra) # 5fd0 <printf>
    exit(1);
    3eee:	4505                	li	a0,1
    3ef0:	00002097          	auipc	ra,0x2
    3ef4:	d70080e7          	jalr	-656(ra) # 5c60 <exit>
    printf("%s: unlink dd failed\n", s);
    3ef8:	85ca                	mv	a1,s2
    3efa:	00004517          	auipc	a0,0x4
    3efe:	c7650513          	addi	a0,a0,-906 # 7b70 <malloc+0x1ae8>
    3f02:	00002097          	auipc	ra,0x2
    3f06:	0ce080e7          	jalr	206(ra) # 5fd0 <printf>
    exit(1);
    3f0a:	4505                	li	a0,1
    3f0c:	00002097          	auipc	ra,0x2
    3f10:	d54080e7          	jalr	-684(ra) # 5c60 <exit>

0000000000003f14 <rmdot>:
{
    3f14:	1101                	addi	sp,sp,-32
    3f16:	ec06                	sd	ra,24(sp)
    3f18:	e822                	sd	s0,16(sp)
    3f1a:	e426                	sd	s1,8(sp)
    3f1c:	1000                	addi	s0,sp,32
    3f1e:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3f20:	00004517          	auipc	a0,0x4
    3f24:	c6850513          	addi	a0,a0,-920 # 7b88 <malloc+0x1b00>
    3f28:	00002097          	auipc	ra,0x2
    3f2c:	da0080e7          	jalr	-608(ra) # 5cc8 <mkdir>
    3f30:	e549                	bnez	a0,3fba <rmdot+0xa6>
  if(chdir("dots") != 0){
    3f32:	00004517          	auipc	a0,0x4
    3f36:	c5650513          	addi	a0,a0,-938 # 7b88 <malloc+0x1b00>
    3f3a:	00002097          	auipc	ra,0x2
    3f3e:	d96080e7          	jalr	-618(ra) # 5cd0 <chdir>
    3f42:	e951                	bnez	a0,3fd6 <rmdot+0xc2>
  if(unlink(".") == 0){
    3f44:	00003517          	auipc	a0,0x3
    3f48:	96c50513          	addi	a0,a0,-1684 # 68b0 <malloc+0x828>
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	d64080e7          	jalr	-668(ra) # 5cb0 <unlink>
    3f54:	cd59                	beqz	a0,3ff2 <rmdot+0xde>
  if(unlink("..") == 0){
    3f56:	00003517          	auipc	a0,0x3
    3f5a:	68a50513          	addi	a0,a0,1674 # 75e0 <malloc+0x1558>
    3f5e:	00002097          	auipc	ra,0x2
    3f62:	d52080e7          	jalr	-686(ra) # 5cb0 <unlink>
    3f66:	c545                	beqz	a0,400e <rmdot+0xfa>
  if(chdir("/") != 0){
    3f68:	00003517          	auipc	a0,0x3
    3f6c:	62050513          	addi	a0,a0,1568 # 7588 <malloc+0x1500>
    3f70:	00002097          	auipc	ra,0x2
    3f74:	d60080e7          	jalr	-672(ra) # 5cd0 <chdir>
    3f78:	e94d                	bnez	a0,402a <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3f7a:	00004517          	auipc	a0,0x4
    3f7e:	c7650513          	addi	a0,a0,-906 # 7bf0 <malloc+0x1b68>
    3f82:	00002097          	auipc	ra,0x2
    3f86:	d2e080e7          	jalr	-722(ra) # 5cb0 <unlink>
    3f8a:	cd55                	beqz	a0,4046 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3f8c:	00004517          	auipc	a0,0x4
    3f90:	c8c50513          	addi	a0,a0,-884 # 7c18 <malloc+0x1b90>
    3f94:	00002097          	auipc	ra,0x2
    3f98:	d1c080e7          	jalr	-740(ra) # 5cb0 <unlink>
    3f9c:	c179                	beqz	a0,4062 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3f9e:	00004517          	auipc	a0,0x4
    3fa2:	bea50513          	addi	a0,a0,-1046 # 7b88 <malloc+0x1b00>
    3fa6:	00002097          	auipc	ra,0x2
    3faa:	d0a080e7          	jalr	-758(ra) # 5cb0 <unlink>
    3fae:	e961                	bnez	a0,407e <rmdot+0x16a>
}
    3fb0:	60e2                	ld	ra,24(sp)
    3fb2:	6442                	ld	s0,16(sp)
    3fb4:	64a2                	ld	s1,8(sp)
    3fb6:	6105                	addi	sp,sp,32
    3fb8:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3fba:	85a6                	mv	a1,s1
    3fbc:	00004517          	auipc	a0,0x4
    3fc0:	bd450513          	addi	a0,a0,-1068 # 7b90 <malloc+0x1b08>
    3fc4:	00002097          	auipc	ra,0x2
    3fc8:	00c080e7          	jalr	12(ra) # 5fd0 <printf>
    exit(1);
    3fcc:	4505                	li	a0,1
    3fce:	00002097          	auipc	ra,0x2
    3fd2:	c92080e7          	jalr	-878(ra) # 5c60 <exit>
    printf("%s: chdir dots failed\n", s);
    3fd6:	85a6                	mv	a1,s1
    3fd8:	00004517          	auipc	a0,0x4
    3fdc:	bd050513          	addi	a0,a0,-1072 # 7ba8 <malloc+0x1b20>
    3fe0:	00002097          	auipc	ra,0x2
    3fe4:	ff0080e7          	jalr	-16(ra) # 5fd0 <printf>
    exit(1);
    3fe8:	4505                	li	a0,1
    3fea:	00002097          	auipc	ra,0x2
    3fee:	c76080e7          	jalr	-906(ra) # 5c60 <exit>
    printf("%s: rm . worked!\n", s);
    3ff2:	85a6                	mv	a1,s1
    3ff4:	00004517          	auipc	a0,0x4
    3ff8:	bcc50513          	addi	a0,a0,-1076 # 7bc0 <malloc+0x1b38>
    3ffc:	00002097          	auipc	ra,0x2
    4000:	fd4080e7          	jalr	-44(ra) # 5fd0 <printf>
    exit(1);
    4004:	4505                	li	a0,1
    4006:	00002097          	auipc	ra,0x2
    400a:	c5a080e7          	jalr	-934(ra) # 5c60 <exit>
    printf("%s: rm .. worked!\n", s);
    400e:	85a6                	mv	a1,s1
    4010:	00004517          	auipc	a0,0x4
    4014:	bc850513          	addi	a0,a0,-1080 # 7bd8 <malloc+0x1b50>
    4018:	00002097          	auipc	ra,0x2
    401c:	fb8080e7          	jalr	-72(ra) # 5fd0 <printf>
    exit(1);
    4020:	4505                	li	a0,1
    4022:	00002097          	auipc	ra,0x2
    4026:	c3e080e7          	jalr	-962(ra) # 5c60 <exit>
    printf("%s: chdir / failed\n", s);
    402a:	85a6                	mv	a1,s1
    402c:	00003517          	auipc	a0,0x3
    4030:	56450513          	addi	a0,a0,1380 # 7590 <malloc+0x1508>
    4034:	00002097          	auipc	ra,0x2
    4038:	f9c080e7          	jalr	-100(ra) # 5fd0 <printf>
    exit(1);
    403c:	4505                	li	a0,1
    403e:	00002097          	auipc	ra,0x2
    4042:	c22080e7          	jalr	-990(ra) # 5c60 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    4046:	85a6                	mv	a1,s1
    4048:	00004517          	auipc	a0,0x4
    404c:	bb050513          	addi	a0,a0,-1104 # 7bf8 <malloc+0x1b70>
    4050:	00002097          	auipc	ra,0x2
    4054:	f80080e7          	jalr	-128(ra) # 5fd0 <printf>
    exit(1);
    4058:	4505                	li	a0,1
    405a:	00002097          	auipc	ra,0x2
    405e:	c06080e7          	jalr	-1018(ra) # 5c60 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    4062:	85a6                	mv	a1,s1
    4064:	00004517          	auipc	a0,0x4
    4068:	bbc50513          	addi	a0,a0,-1092 # 7c20 <malloc+0x1b98>
    406c:	00002097          	auipc	ra,0x2
    4070:	f64080e7          	jalr	-156(ra) # 5fd0 <printf>
    exit(1);
    4074:	4505                	li	a0,1
    4076:	00002097          	auipc	ra,0x2
    407a:	bea080e7          	jalr	-1046(ra) # 5c60 <exit>
    printf("%s: unlink dots failed!\n", s);
    407e:	85a6                	mv	a1,s1
    4080:	00004517          	auipc	a0,0x4
    4084:	bc050513          	addi	a0,a0,-1088 # 7c40 <malloc+0x1bb8>
    4088:	00002097          	auipc	ra,0x2
    408c:	f48080e7          	jalr	-184(ra) # 5fd0 <printf>
    exit(1);
    4090:	4505                	li	a0,1
    4092:	00002097          	auipc	ra,0x2
    4096:	bce080e7          	jalr	-1074(ra) # 5c60 <exit>

000000000000409a <dirfile>:
{
    409a:	1101                	addi	sp,sp,-32
    409c:	ec06                	sd	ra,24(sp)
    409e:	e822                	sd	s0,16(sp)
    40a0:	e426                	sd	s1,8(sp)
    40a2:	e04a                	sd	s2,0(sp)
    40a4:	1000                	addi	s0,sp,32
    40a6:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    40a8:	20000593          	li	a1,512
    40ac:	00004517          	auipc	a0,0x4
    40b0:	bb450513          	addi	a0,a0,-1100 # 7c60 <malloc+0x1bd8>
    40b4:	00002097          	auipc	ra,0x2
    40b8:	bec080e7          	jalr	-1044(ra) # 5ca0 <open>
  if(fd < 0){
    40bc:	0e054d63          	bltz	a0,41b6 <dirfile+0x11c>
  close(fd);
    40c0:	00002097          	auipc	ra,0x2
    40c4:	bc8080e7          	jalr	-1080(ra) # 5c88 <close>
  if(chdir("dirfile") == 0){
    40c8:	00004517          	auipc	a0,0x4
    40cc:	b9850513          	addi	a0,a0,-1128 # 7c60 <malloc+0x1bd8>
    40d0:	00002097          	auipc	ra,0x2
    40d4:	c00080e7          	jalr	-1024(ra) # 5cd0 <chdir>
    40d8:	cd6d                	beqz	a0,41d2 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    40da:	4581                	li	a1,0
    40dc:	00004517          	auipc	a0,0x4
    40e0:	bcc50513          	addi	a0,a0,-1076 # 7ca8 <malloc+0x1c20>
    40e4:	00002097          	auipc	ra,0x2
    40e8:	bbc080e7          	jalr	-1092(ra) # 5ca0 <open>
  if(fd >= 0){
    40ec:	10055163          	bgez	a0,41ee <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    40f0:	20000593          	li	a1,512
    40f4:	00004517          	auipc	a0,0x4
    40f8:	bb450513          	addi	a0,a0,-1100 # 7ca8 <malloc+0x1c20>
    40fc:	00002097          	auipc	ra,0x2
    4100:	ba4080e7          	jalr	-1116(ra) # 5ca0 <open>
  if(fd >= 0){
    4104:	10055363          	bgez	a0,420a <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4108:	00004517          	auipc	a0,0x4
    410c:	ba050513          	addi	a0,a0,-1120 # 7ca8 <malloc+0x1c20>
    4110:	00002097          	auipc	ra,0x2
    4114:	bb8080e7          	jalr	-1096(ra) # 5cc8 <mkdir>
    4118:	10050763          	beqz	a0,4226 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    411c:	00004517          	auipc	a0,0x4
    4120:	b8c50513          	addi	a0,a0,-1140 # 7ca8 <malloc+0x1c20>
    4124:	00002097          	auipc	ra,0x2
    4128:	b8c080e7          	jalr	-1140(ra) # 5cb0 <unlink>
    412c:	10050b63          	beqz	a0,4242 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    4130:	00004597          	auipc	a1,0x4
    4134:	b7858593          	addi	a1,a1,-1160 # 7ca8 <malloc+0x1c20>
    4138:	00002517          	auipc	a0,0x2
    413c:	26850513          	addi	a0,a0,616 # 63a0 <malloc+0x318>
    4140:	00002097          	auipc	ra,0x2
    4144:	b80080e7          	jalr	-1152(ra) # 5cc0 <link>
    4148:	10050b63          	beqz	a0,425e <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    414c:	00004517          	auipc	a0,0x4
    4150:	b1450513          	addi	a0,a0,-1260 # 7c60 <malloc+0x1bd8>
    4154:	00002097          	auipc	ra,0x2
    4158:	b5c080e7          	jalr	-1188(ra) # 5cb0 <unlink>
    415c:	10051f63          	bnez	a0,427a <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    4160:	4589                	li	a1,2
    4162:	00002517          	auipc	a0,0x2
    4166:	74e50513          	addi	a0,a0,1870 # 68b0 <malloc+0x828>
    416a:	00002097          	auipc	ra,0x2
    416e:	b36080e7          	jalr	-1226(ra) # 5ca0 <open>
  if(fd >= 0){
    4172:	12055263          	bgez	a0,4296 <dirfile+0x1fc>
  fd = open(".", 0);
    4176:	4581                	li	a1,0
    4178:	00002517          	auipc	a0,0x2
    417c:	73850513          	addi	a0,a0,1848 # 68b0 <malloc+0x828>
    4180:	00002097          	auipc	ra,0x2
    4184:	b20080e7          	jalr	-1248(ra) # 5ca0 <open>
    4188:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    418a:	4605                	li	a2,1
    418c:	00002597          	auipc	a1,0x2
    4190:	0ac58593          	addi	a1,a1,172 # 6238 <malloc+0x1b0>
    4194:	00002097          	auipc	ra,0x2
    4198:	aec080e7          	jalr	-1300(ra) # 5c80 <write>
    419c:	10a04b63          	bgtz	a0,42b2 <dirfile+0x218>
  close(fd);
    41a0:	8526                	mv	a0,s1
    41a2:	00002097          	auipc	ra,0x2
    41a6:	ae6080e7          	jalr	-1306(ra) # 5c88 <close>
}
    41aa:	60e2                	ld	ra,24(sp)
    41ac:	6442                	ld	s0,16(sp)
    41ae:	64a2                	ld	s1,8(sp)
    41b0:	6902                	ld	s2,0(sp)
    41b2:	6105                	addi	sp,sp,32
    41b4:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    41b6:	85ca                	mv	a1,s2
    41b8:	00004517          	auipc	a0,0x4
    41bc:	ab050513          	addi	a0,a0,-1360 # 7c68 <malloc+0x1be0>
    41c0:	00002097          	auipc	ra,0x2
    41c4:	e10080e7          	jalr	-496(ra) # 5fd0 <printf>
    exit(1);
    41c8:	4505                	li	a0,1
    41ca:	00002097          	auipc	ra,0x2
    41ce:	a96080e7          	jalr	-1386(ra) # 5c60 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    41d2:	85ca                	mv	a1,s2
    41d4:	00004517          	auipc	a0,0x4
    41d8:	ab450513          	addi	a0,a0,-1356 # 7c88 <malloc+0x1c00>
    41dc:	00002097          	auipc	ra,0x2
    41e0:	df4080e7          	jalr	-524(ra) # 5fd0 <printf>
    exit(1);
    41e4:	4505                	li	a0,1
    41e6:	00002097          	auipc	ra,0x2
    41ea:	a7a080e7          	jalr	-1414(ra) # 5c60 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    41ee:	85ca                	mv	a1,s2
    41f0:	00004517          	auipc	a0,0x4
    41f4:	ac850513          	addi	a0,a0,-1336 # 7cb8 <malloc+0x1c30>
    41f8:	00002097          	auipc	ra,0x2
    41fc:	dd8080e7          	jalr	-552(ra) # 5fd0 <printf>
    exit(1);
    4200:	4505                	li	a0,1
    4202:	00002097          	auipc	ra,0x2
    4206:	a5e080e7          	jalr	-1442(ra) # 5c60 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    420a:	85ca                	mv	a1,s2
    420c:	00004517          	auipc	a0,0x4
    4210:	aac50513          	addi	a0,a0,-1364 # 7cb8 <malloc+0x1c30>
    4214:	00002097          	auipc	ra,0x2
    4218:	dbc080e7          	jalr	-580(ra) # 5fd0 <printf>
    exit(1);
    421c:	4505                	li	a0,1
    421e:	00002097          	auipc	ra,0x2
    4222:	a42080e7          	jalr	-1470(ra) # 5c60 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4226:	85ca                	mv	a1,s2
    4228:	00004517          	auipc	a0,0x4
    422c:	ab850513          	addi	a0,a0,-1352 # 7ce0 <malloc+0x1c58>
    4230:	00002097          	auipc	ra,0x2
    4234:	da0080e7          	jalr	-608(ra) # 5fd0 <printf>
    exit(1);
    4238:	4505                	li	a0,1
    423a:	00002097          	auipc	ra,0x2
    423e:	a26080e7          	jalr	-1498(ra) # 5c60 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4242:	85ca                	mv	a1,s2
    4244:	00004517          	auipc	a0,0x4
    4248:	ac450513          	addi	a0,a0,-1340 # 7d08 <malloc+0x1c80>
    424c:	00002097          	auipc	ra,0x2
    4250:	d84080e7          	jalr	-636(ra) # 5fd0 <printf>
    exit(1);
    4254:	4505                	li	a0,1
    4256:	00002097          	auipc	ra,0x2
    425a:	a0a080e7          	jalr	-1526(ra) # 5c60 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    425e:	85ca                	mv	a1,s2
    4260:	00004517          	auipc	a0,0x4
    4264:	ad050513          	addi	a0,a0,-1328 # 7d30 <malloc+0x1ca8>
    4268:	00002097          	auipc	ra,0x2
    426c:	d68080e7          	jalr	-664(ra) # 5fd0 <printf>
    exit(1);
    4270:	4505                	li	a0,1
    4272:	00002097          	auipc	ra,0x2
    4276:	9ee080e7          	jalr	-1554(ra) # 5c60 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    427a:	85ca                	mv	a1,s2
    427c:	00004517          	auipc	a0,0x4
    4280:	adc50513          	addi	a0,a0,-1316 # 7d58 <malloc+0x1cd0>
    4284:	00002097          	auipc	ra,0x2
    4288:	d4c080e7          	jalr	-692(ra) # 5fd0 <printf>
    exit(1);
    428c:	4505                	li	a0,1
    428e:	00002097          	auipc	ra,0x2
    4292:	9d2080e7          	jalr	-1582(ra) # 5c60 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4296:	85ca                	mv	a1,s2
    4298:	00004517          	auipc	a0,0x4
    429c:	ae050513          	addi	a0,a0,-1312 # 7d78 <malloc+0x1cf0>
    42a0:	00002097          	auipc	ra,0x2
    42a4:	d30080e7          	jalr	-720(ra) # 5fd0 <printf>
    exit(1);
    42a8:	4505                	li	a0,1
    42aa:	00002097          	auipc	ra,0x2
    42ae:	9b6080e7          	jalr	-1610(ra) # 5c60 <exit>
    printf("%s: write . succeeded!\n", s);
    42b2:	85ca                	mv	a1,s2
    42b4:	00004517          	auipc	a0,0x4
    42b8:	aec50513          	addi	a0,a0,-1300 # 7da0 <malloc+0x1d18>
    42bc:	00002097          	auipc	ra,0x2
    42c0:	d14080e7          	jalr	-748(ra) # 5fd0 <printf>
    exit(1);
    42c4:	4505                	li	a0,1
    42c6:	00002097          	auipc	ra,0x2
    42ca:	99a080e7          	jalr	-1638(ra) # 5c60 <exit>

00000000000042ce <iref>:
{
    42ce:	7139                	addi	sp,sp,-64
    42d0:	fc06                	sd	ra,56(sp)
    42d2:	f822                	sd	s0,48(sp)
    42d4:	f426                	sd	s1,40(sp)
    42d6:	f04a                	sd	s2,32(sp)
    42d8:	ec4e                	sd	s3,24(sp)
    42da:	e852                	sd	s4,16(sp)
    42dc:	e456                	sd	s5,8(sp)
    42de:	e05a                	sd	s6,0(sp)
    42e0:	0080                	addi	s0,sp,64
    42e2:	8b2a                	mv	s6,a0
    42e4:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    42e8:	00004a17          	auipc	s4,0x4
    42ec:	ad0a0a13          	addi	s4,s4,-1328 # 7db8 <malloc+0x1d30>
    mkdir("");
    42f0:	00003497          	auipc	s1,0x3
    42f4:	5d048493          	addi	s1,s1,1488 # 78c0 <malloc+0x1838>
    link("README", "");
    42f8:	00002a97          	auipc	s5,0x2
    42fc:	0a8a8a93          	addi	s5,s5,168 # 63a0 <malloc+0x318>
    fd = open("xx", O_CREATE);
    4300:	00004997          	auipc	s3,0x4
    4304:	9b098993          	addi	s3,s3,-1616 # 7cb0 <malloc+0x1c28>
    4308:	a891                	j	435c <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    430a:	85da                	mv	a1,s6
    430c:	00004517          	auipc	a0,0x4
    4310:	ab450513          	addi	a0,a0,-1356 # 7dc0 <malloc+0x1d38>
    4314:	00002097          	auipc	ra,0x2
    4318:	cbc080e7          	jalr	-836(ra) # 5fd0 <printf>
      exit(1);
    431c:	4505                	li	a0,1
    431e:	00002097          	auipc	ra,0x2
    4322:	942080e7          	jalr	-1726(ra) # 5c60 <exit>
      printf("%s: chdir irefd failed\n", s);
    4326:	85da                	mv	a1,s6
    4328:	00004517          	auipc	a0,0x4
    432c:	ab050513          	addi	a0,a0,-1360 # 7dd8 <malloc+0x1d50>
    4330:	00002097          	auipc	ra,0x2
    4334:	ca0080e7          	jalr	-864(ra) # 5fd0 <printf>
      exit(1);
    4338:	4505                	li	a0,1
    433a:	00002097          	auipc	ra,0x2
    433e:	926080e7          	jalr	-1754(ra) # 5c60 <exit>
      close(fd);
    4342:	00002097          	auipc	ra,0x2
    4346:	946080e7          	jalr	-1722(ra) # 5c88 <close>
    434a:	a889                	j	439c <iref+0xce>
    unlink("xx");
    434c:	854e                	mv	a0,s3
    434e:	00002097          	auipc	ra,0x2
    4352:	962080e7          	jalr	-1694(ra) # 5cb0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4356:	397d                	addiw	s2,s2,-1
    4358:	06090063          	beqz	s2,43b8 <iref+0xea>
    if(mkdir("irefd") != 0){
    435c:	8552                	mv	a0,s4
    435e:	00002097          	auipc	ra,0x2
    4362:	96a080e7          	jalr	-1686(ra) # 5cc8 <mkdir>
    4366:	f155                	bnez	a0,430a <iref+0x3c>
    if(chdir("irefd") != 0){
    4368:	8552                	mv	a0,s4
    436a:	00002097          	auipc	ra,0x2
    436e:	966080e7          	jalr	-1690(ra) # 5cd0 <chdir>
    4372:	f955                	bnez	a0,4326 <iref+0x58>
    mkdir("");
    4374:	8526                	mv	a0,s1
    4376:	00002097          	auipc	ra,0x2
    437a:	952080e7          	jalr	-1710(ra) # 5cc8 <mkdir>
    link("README", "");
    437e:	85a6                	mv	a1,s1
    4380:	8556                	mv	a0,s5
    4382:	00002097          	auipc	ra,0x2
    4386:	93e080e7          	jalr	-1730(ra) # 5cc0 <link>
    fd = open("", O_CREATE);
    438a:	20000593          	li	a1,512
    438e:	8526                	mv	a0,s1
    4390:	00002097          	auipc	ra,0x2
    4394:	910080e7          	jalr	-1776(ra) # 5ca0 <open>
    if(fd >= 0)
    4398:	fa0555e3          	bgez	a0,4342 <iref+0x74>
    fd = open("xx", O_CREATE);
    439c:	20000593          	li	a1,512
    43a0:	854e                	mv	a0,s3
    43a2:	00002097          	auipc	ra,0x2
    43a6:	8fe080e7          	jalr	-1794(ra) # 5ca0 <open>
    if(fd >= 0)
    43aa:	fa0541e3          	bltz	a0,434c <iref+0x7e>
      close(fd);
    43ae:	00002097          	auipc	ra,0x2
    43b2:	8da080e7          	jalr	-1830(ra) # 5c88 <close>
    43b6:	bf59                	j	434c <iref+0x7e>
    43b8:	03300493          	li	s1,51
    chdir("..");
    43bc:	00003997          	auipc	s3,0x3
    43c0:	22498993          	addi	s3,s3,548 # 75e0 <malloc+0x1558>
    unlink("irefd");
    43c4:	00004917          	auipc	s2,0x4
    43c8:	9f490913          	addi	s2,s2,-1548 # 7db8 <malloc+0x1d30>
    chdir("..");
    43cc:	854e                	mv	a0,s3
    43ce:	00002097          	auipc	ra,0x2
    43d2:	902080e7          	jalr	-1790(ra) # 5cd0 <chdir>
    unlink("irefd");
    43d6:	854a                	mv	a0,s2
    43d8:	00002097          	auipc	ra,0x2
    43dc:	8d8080e7          	jalr	-1832(ra) # 5cb0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    43e0:	34fd                	addiw	s1,s1,-1
    43e2:	f4ed                	bnez	s1,43cc <iref+0xfe>
  chdir("/");
    43e4:	00003517          	auipc	a0,0x3
    43e8:	1a450513          	addi	a0,a0,420 # 7588 <malloc+0x1500>
    43ec:	00002097          	auipc	ra,0x2
    43f0:	8e4080e7          	jalr	-1820(ra) # 5cd0 <chdir>
}
    43f4:	70e2                	ld	ra,56(sp)
    43f6:	7442                	ld	s0,48(sp)
    43f8:	74a2                	ld	s1,40(sp)
    43fa:	7902                	ld	s2,32(sp)
    43fc:	69e2                	ld	s3,24(sp)
    43fe:	6a42                	ld	s4,16(sp)
    4400:	6aa2                	ld	s5,8(sp)
    4402:	6b02                	ld	s6,0(sp)
    4404:	6121                	addi	sp,sp,64
    4406:	8082                	ret

0000000000004408 <openiputtest>:
{
    4408:	7179                	addi	sp,sp,-48
    440a:	f406                	sd	ra,40(sp)
    440c:	f022                	sd	s0,32(sp)
    440e:	ec26                	sd	s1,24(sp)
    4410:	1800                	addi	s0,sp,48
    4412:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4414:	00004517          	auipc	a0,0x4
    4418:	9dc50513          	addi	a0,a0,-1572 # 7df0 <malloc+0x1d68>
    441c:	00002097          	auipc	ra,0x2
    4420:	8ac080e7          	jalr	-1876(ra) # 5cc8 <mkdir>
    4424:	04054263          	bltz	a0,4468 <openiputtest+0x60>
  pid = fork();
    4428:	00002097          	auipc	ra,0x2
    442c:	830080e7          	jalr	-2000(ra) # 5c58 <fork>
  if(pid < 0){
    4430:	04054a63          	bltz	a0,4484 <openiputtest+0x7c>
  if(pid == 0){
    4434:	e93d                	bnez	a0,44aa <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4436:	4589                	li	a1,2
    4438:	00004517          	auipc	a0,0x4
    443c:	9b850513          	addi	a0,a0,-1608 # 7df0 <malloc+0x1d68>
    4440:	00002097          	auipc	ra,0x2
    4444:	860080e7          	jalr	-1952(ra) # 5ca0 <open>
    if(fd >= 0){
    4448:	04054c63          	bltz	a0,44a0 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    444c:	85a6                	mv	a1,s1
    444e:	00004517          	auipc	a0,0x4
    4452:	9c250513          	addi	a0,a0,-1598 # 7e10 <malloc+0x1d88>
    4456:	00002097          	auipc	ra,0x2
    445a:	b7a080e7          	jalr	-1158(ra) # 5fd0 <printf>
      exit(1);
    445e:	4505                	li	a0,1
    4460:	00002097          	auipc	ra,0x2
    4464:	800080e7          	jalr	-2048(ra) # 5c60 <exit>
    printf("%s: mkdir oidir failed\n", s);
    4468:	85a6                	mv	a1,s1
    446a:	00004517          	auipc	a0,0x4
    446e:	98e50513          	addi	a0,a0,-1650 # 7df8 <malloc+0x1d70>
    4472:	00002097          	auipc	ra,0x2
    4476:	b5e080e7          	jalr	-1186(ra) # 5fd0 <printf>
    exit(1);
    447a:	4505                	li	a0,1
    447c:	00001097          	auipc	ra,0x1
    4480:	7e4080e7          	jalr	2020(ra) # 5c60 <exit>
    printf("%s: fork failed\n", s);
    4484:	85a6                	mv	a1,s1
    4486:	00002517          	auipc	a0,0x2
    448a:	5ca50513          	addi	a0,a0,1482 # 6a50 <malloc+0x9c8>
    448e:	00002097          	auipc	ra,0x2
    4492:	b42080e7          	jalr	-1214(ra) # 5fd0 <printf>
    exit(1);
    4496:	4505                	li	a0,1
    4498:	00001097          	auipc	ra,0x1
    449c:	7c8080e7          	jalr	1992(ra) # 5c60 <exit>
    exit(0);
    44a0:	4501                	li	a0,0
    44a2:	00001097          	auipc	ra,0x1
    44a6:	7be080e7          	jalr	1982(ra) # 5c60 <exit>
  sleep(1);
    44aa:	4505                	li	a0,1
    44ac:	00002097          	auipc	ra,0x2
    44b0:	844080e7          	jalr	-1980(ra) # 5cf0 <sleep>
  if(unlink("oidir") != 0){
    44b4:	00004517          	auipc	a0,0x4
    44b8:	93c50513          	addi	a0,a0,-1732 # 7df0 <malloc+0x1d68>
    44bc:	00001097          	auipc	ra,0x1
    44c0:	7f4080e7          	jalr	2036(ra) # 5cb0 <unlink>
    44c4:	cd19                	beqz	a0,44e2 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    44c6:	85a6                	mv	a1,s1
    44c8:	00002517          	auipc	a0,0x2
    44cc:	77850513          	addi	a0,a0,1912 # 6c40 <malloc+0xbb8>
    44d0:	00002097          	auipc	ra,0x2
    44d4:	b00080e7          	jalr	-1280(ra) # 5fd0 <printf>
    exit(1);
    44d8:	4505                	li	a0,1
    44da:	00001097          	auipc	ra,0x1
    44de:	786080e7          	jalr	1926(ra) # 5c60 <exit>
  wait(&xstatus);
    44e2:	fdc40513          	addi	a0,s0,-36
    44e6:	00001097          	auipc	ra,0x1
    44ea:	782080e7          	jalr	1922(ra) # 5c68 <wait>
  exit(xstatus);
    44ee:	fdc42503          	lw	a0,-36(s0)
    44f2:	00001097          	auipc	ra,0x1
    44f6:	76e080e7          	jalr	1902(ra) # 5c60 <exit>

00000000000044fa <forkforkfork>:
{
    44fa:	1101                	addi	sp,sp,-32
    44fc:	ec06                	sd	ra,24(sp)
    44fe:	e822                	sd	s0,16(sp)
    4500:	e426                	sd	s1,8(sp)
    4502:	1000                	addi	s0,sp,32
    4504:	84aa                	mv	s1,a0
  unlink("stopforking");
    4506:	00004517          	auipc	a0,0x4
    450a:	93250513          	addi	a0,a0,-1742 # 7e38 <malloc+0x1db0>
    450e:	00001097          	auipc	ra,0x1
    4512:	7a2080e7          	jalr	1954(ra) # 5cb0 <unlink>
  int pid = fork();
    4516:	00001097          	auipc	ra,0x1
    451a:	742080e7          	jalr	1858(ra) # 5c58 <fork>
  if(pid < 0){
    451e:	04054563          	bltz	a0,4568 <forkforkfork+0x6e>
  if(pid == 0){
    4522:	c12d                	beqz	a0,4584 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4524:	4551                	li	a0,20
    4526:	00001097          	auipc	ra,0x1
    452a:	7ca080e7          	jalr	1994(ra) # 5cf0 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    452e:	20200593          	li	a1,514
    4532:	00004517          	auipc	a0,0x4
    4536:	90650513          	addi	a0,a0,-1786 # 7e38 <malloc+0x1db0>
    453a:	00001097          	auipc	ra,0x1
    453e:	766080e7          	jalr	1894(ra) # 5ca0 <open>
    4542:	00001097          	auipc	ra,0x1
    4546:	746080e7          	jalr	1862(ra) # 5c88 <close>
  wait(0);
    454a:	4501                	li	a0,0
    454c:	00001097          	auipc	ra,0x1
    4550:	71c080e7          	jalr	1820(ra) # 5c68 <wait>
  sleep(10); // one second
    4554:	4529                	li	a0,10
    4556:	00001097          	auipc	ra,0x1
    455a:	79a080e7          	jalr	1946(ra) # 5cf0 <sleep>
}
    455e:	60e2                	ld	ra,24(sp)
    4560:	6442                	ld	s0,16(sp)
    4562:	64a2                	ld	s1,8(sp)
    4564:	6105                	addi	sp,sp,32
    4566:	8082                	ret
    printf("%s: fork failed", s);
    4568:	85a6                	mv	a1,s1
    456a:	00002517          	auipc	a0,0x2
    456e:	6a650513          	addi	a0,a0,1702 # 6c10 <malloc+0xb88>
    4572:	00002097          	auipc	ra,0x2
    4576:	a5e080e7          	jalr	-1442(ra) # 5fd0 <printf>
    exit(1);
    457a:	4505                	li	a0,1
    457c:	00001097          	auipc	ra,0x1
    4580:	6e4080e7          	jalr	1764(ra) # 5c60 <exit>
      int fd = open("stopforking", 0);
    4584:	00004497          	auipc	s1,0x4
    4588:	8b448493          	addi	s1,s1,-1868 # 7e38 <malloc+0x1db0>
    458c:	4581                	li	a1,0
    458e:	8526                	mv	a0,s1
    4590:	00001097          	auipc	ra,0x1
    4594:	710080e7          	jalr	1808(ra) # 5ca0 <open>
      if(fd >= 0){
    4598:	02055763          	bgez	a0,45c6 <forkforkfork+0xcc>
      if(fork() < 0){
    459c:	00001097          	auipc	ra,0x1
    45a0:	6bc080e7          	jalr	1724(ra) # 5c58 <fork>
    45a4:	fe0554e3          	bgez	a0,458c <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    45a8:	20200593          	li	a1,514
    45ac:	00004517          	auipc	a0,0x4
    45b0:	88c50513          	addi	a0,a0,-1908 # 7e38 <malloc+0x1db0>
    45b4:	00001097          	auipc	ra,0x1
    45b8:	6ec080e7          	jalr	1772(ra) # 5ca0 <open>
    45bc:	00001097          	auipc	ra,0x1
    45c0:	6cc080e7          	jalr	1740(ra) # 5c88 <close>
    45c4:	b7e1                	j	458c <forkforkfork+0x92>
        exit(0);
    45c6:	4501                	li	a0,0
    45c8:	00001097          	auipc	ra,0x1
    45cc:	698080e7          	jalr	1688(ra) # 5c60 <exit>

00000000000045d0 <killstatus>:
{
    45d0:	7139                	addi	sp,sp,-64
    45d2:	fc06                	sd	ra,56(sp)
    45d4:	f822                	sd	s0,48(sp)
    45d6:	f426                	sd	s1,40(sp)
    45d8:	f04a                	sd	s2,32(sp)
    45da:	ec4e                	sd	s3,24(sp)
    45dc:	e852                	sd	s4,16(sp)
    45de:	0080                	addi	s0,sp,64
    45e0:	8a2a                	mv	s4,a0
    45e2:	06400913          	li	s2,100
    if(xst != -1) {
    45e6:	59fd                	li	s3,-1
    int pid1 = fork();
    45e8:	00001097          	auipc	ra,0x1
    45ec:	670080e7          	jalr	1648(ra) # 5c58 <fork>
    45f0:	84aa                	mv	s1,a0
    if(pid1 < 0){
    45f2:	02054f63          	bltz	a0,4630 <killstatus+0x60>
    if(pid1 == 0){
    45f6:	c939                	beqz	a0,464c <killstatus+0x7c>
    sleep(1);
    45f8:	4505                	li	a0,1
    45fa:	00001097          	auipc	ra,0x1
    45fe:	6f6080e7          	jalr	1782(ra) # 5cf0 <sleep>
    kill(pid1);
    4602:	8526                	mv	a0,s1
    4604:	00001097          	auipc	ra,0x1
    4608:	68c080e7          	jalr	1676(ra) # 5c90 <kill>
    wait(&xst);
    460c:	fcc40513          	addi	a0,s0,-52
    4610:	00001097          	auipc	ra,0x1
    4614:	658080e7          	jalr	1624(ra) # 5c68 <wait>
    if(xst != -1) {
    4618:	fcc42783          	lw	a5,-52(s0)
    461c:	03379d63          	bne	a5,s3,4656 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    4620:	397d                	addiw	s2,s2,-1
    4622:	fc0913e3          	bnez	s2,45e8 <killstatus+0x18>
  exit(0);
    4626:	4501                	li	a0,0
    4628:	00001097          	auipc	ra,0x1
    462c:	638080e7          	jalr	1592(ra) # 5c60 <exit>
      printf("%s: fork failed\n", s);
    4630:	85d2                	mv	a1,s4
    4632:	00002517          	auipc	a0,0x2
    4636:	41e50513          	addi	a0,a0,1054 # 6a50 <malloc+0x9c8>
    463a:	00002097          	auipc	ra,0x2
    463e:	996080e7          	jalr	-1642(ra) # 5fd0 <printf>
      exit(1);
    4642:	4505                	li	a0,1
    4644:	00001097          	auipc	ra,0x1
    4648:	61c080e7          	jalr	1564(ra) # 5c60 <exit>
        getpid();
    464c:	00001097          	auipc	ra,0x1
    4650:	694080e7          	jalr	1684(ra) # 5ce0 <getpid>
      while(1) {
    4654:	bfe5                	j	464c <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4656:	85d2                	mv	a1,s4
    4658:	00003517          	auipc	a0,0x3
    465c:	7f050513          	addi	a0,a0,2032 # 7e48 <malloc+0x1dc0>
    4660:	00002097          	auipc	ra,0x2
    4664:	970080e7          	jalr	-1680(ra) # 5fd0 <printf>
       exit(1);
    4668:	4505                	li	a0,1
    466a:	00001097          	auipc	ra,0x1
    466e:	5f6080e7          	jalr	1526(ra) # 5c60 <exit>

0000000000004672 <preempt>:
{
    4672:	7139                	addi	sp,sp,-64
    4674:	fc06                	sd	ra,56(sp)
    4676:	f822                	sd	s0,48(sp)
    4678:	f426                	sd	s1,40(sp)
    467a:	f04a                	sd	s2,32(sp)
    467c:	ec4e                	sd	s3,24(sp)
    467e:	e852                	sd	s4,16(sp)
    4680:	0080                	addi	s0,sp,64
    4682:	892a                	mv	s2,a0
  pid1 = fork();
    4684:	00001097          	auipc	ra,0x1
    4688:	5d4080e7          	jalr	1492(ra) # 5c58 <fork>
  if(pid1 < 0) {
    468c:	00054563          	bltz	a0,4696 <preempt+0x24>
    4690:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4692:	e105                	bnez	a0,46b2 <preempt+0x40>
    for(;;)
    4694:	a001                	j	4694 <preempt+0x22>
    printf("%s: fork failed", s);
    4696:	85ca                	mv	a1,s2
    4698:	00002517          	auipc	a0,0x2
    469c:	57850513          	addi	a0,a0,1400 # 6c10 <malloc+0xb88>
    46a0:	00002097          	auipc	ra,0x2
    46a4:	930080e7          	jalr	-1744(ra) # 5fd0 <printf>
    exit(1);
    46a8:	4505                	li	a0,1
    46aa:	00001097          	auipc	ra,0x1
    46ae:	5b6080e7          	jalr	1462(ra) # 5c60 <exit>
  pid2 = fork();
    46b2:	00001097          	auipc	ra,0x1
    46b6:	5a6080e7          	jalr	1446(ra) # 5c58 <fork>
    46ba:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    46bc:	00054463          	bltz	a0,46c4 <preempt+0x52>
  if(pid2 == 0)
    46c0:	e105                	bnez	a0,46e0 <preempt+0x6e>
    for(;;)
    46c2:	a001                	j	46c2 <preempt+0x50>
    printf("%s: fork failed\n", s);
    46c4:	85ca                	mv	a1,s2
    46c6:	00002517          	auipc	a0,0x2
    46ca:	38a50513          	addi	a0,a0,906 # 6a50 <malloc+0x9c8>
    46ce:	00002097          	auipc	ra,0x2
    46d2:	902080e7          	jalr	-1790(ra) # 5fd0 <printf>
    exit(1);
    46d6:	4505                	li	a0,1
    46d8:	00001097          	auipc	ra,0x1
    46dc:	588080e7          	jalr	1416(ra) # 5c60 <exit>
  pipe(pfds);
    46e0:	fc840513          	addi	a0,s0,-56
    46e4:	00001097          	auipc	ra,0x1
    46e8:	58c080e7          	jalr	1420(ra) # 5c70 <pipe>
  pid3 = fork();
    46ec:	00001097          	auipc	ra,0x1
    46f0:	56c080e7          	jalr	1388(ra) # 5c58 <fork>
    46f4:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    46f6:	02054e63          	bltz	a0,4732 <preempt+0xc0>
  if(pid3 == 0){
    46fa:	e525                	bnez	a0,4762 <preempt+0xf0>
    close(pfds[0]);
    46fc:	fc842503          	lw	a0,-56(s0)
    4700:	00001097          	auipc	ra,0x1
    4704:	588080e7          	jalr	1416(ra) # 5c88 <close>
    if(write(pfds[1], "x", 1) != 1)
    4708:	4605                	li	a2,1
    470a:	00002597          	auipc	a1,0x2
    470e:	b2e58593          	addi	a1,a1,-1234 # 6238 <malloc+0x1b0>
    4712:	fcc42503          	lw	a0,-52(s0)
    4716:	00001097          	auipc	ra,0x1
    471a:	56a080e7          	jalr	1386(ra) # 5c80 <write>
    471e:	4785                	li	a5,1
    4720:	02f51763          	bne	a0,a5,474e <preempt+0xdc>
    close(pfds[1]);
    4724:	fcc42503          	lw	a0,-52(s0)
    4728:	00001097          	auipc	ra,0x1
    472c:	560080e7          	jalr	1376(ra) # 5c88 <close>
    for(;;)
    4730:	a001                	j	4730 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4732:	85ca                	mv	a1,s2
    4734:	00002517          	auipc	a0,0x2
    4738:	31c50513          	addi	a0,a0,796 # 6a50 <malloc+0x9c8>
    473c:	00002097          	auipc	ra,0x2
    4740:	894080e7          	jalr	-1900(ra) # 5fd0 <printf>
     exit(1);
    4744:	4505                	li	a0,1
    4746:	00001097          	auipc	ra,0x1
    474a:	51a080e7          	jalr	1306(ra) # 5c60 <exit>
      printf("%s: preempt write error", s);
    474e:	85ca                	mv	a1,s2
    4750:	00003517          	auipc	a0,0x3
    4754:	71850513          	addi	a0,a0,1816 # 7e68 <malloc+0x1de0>
    4758:	00002097          	auipc	ra,0x2
    475c:	878080e7          	jalr	-1928(ra) # 5fd0 <printf>
    4760:	b7d1                	j	4724 <preempt+0xb2>
  close(pfds[1]);
    4762:	fcc42503          	lw	a0,-52(s0)
    4766:	00001097          	auipc	ra,0x1
    476a:	522080e7          	jalr	1314(ra) # 5c88 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    476e:	660d                	lui	a2,0x3
    4770:	00008597          	auipc	a1,0x8
    4774:	50858593          	addi	a1,a1,1288 # cc78 <buf>
    4778:	fc842503          	lw	a0,-56(s0)
    477c:	00001097          	auipc	ra,0x1
    4780:	4fc080e7          	jalr	1276(ra) # 5c78 <read>
    4784:	4785                	li	a5,1
    4786:	02f50363          	beq	a0,a5,47ac <preempt+0x13a>
    printf("%s: preempt read error", s);
    478a:	85ca                	mv	a1,s2
    478c:	00003517          	auipc	a0,0x3
    4790:	6f450513          	addi	a0,a0,1780 # 7e80 <malloc+0x1df8>
    4794:	00002097          	auipc	ra,0x2
    4798:	83c080e7          	jalr	-1988(ra) # 5fd0 <printf>
}
    479c:	70e2                	ld	ra,56(sp)
    479e:	7442                	ld	s0,48(sp)
    47a0:	74a2                	ld	s1,40(sp)
    47a2:	7902                	ld	s2,32(sp)
    47a4:	69e2                	ld	s3,24(sp)
    47a6:	6a42                	ld	s4,16(sp)
    47a8:	6121                	addi	sp,sp,64
    47aa:	8082                	ret
  close(pfds[0]);
    47ac:	fc842503          	lw	a0,-56(s0)
    47b0:	00001097          	auipc	ra,0x1
    47b4:	4d8080e7          	jalr	1240(ra) # 5c88 <close>
  printf("kill... ");
    47b8:	00003517          	auipc	a0,0x3
    47bc:	6e050513          	addi	a0,a0,1760 # 7e98 <malloc+0x1e10>
    47c0:	00002097          	auipc	ra,0x2
    47c4:	810080e7          	jalr	-2032(ra) # 5fd0 <printf>
  kill(pid1);
    47c8:	8526                	mv	a0,s1
    47ca:	00001097          	auipc	ra,0x1
    47ce:	4c6080e7          	jalr	1222(ra) # 5c90 <kill>
  kill(pid2);
    47d2:	854e                	mv	a0,s3
    47d4:	00001097          	auipc	ra,0x1
    47d8:	4bc080e7          	jalr	1212(ra) # 5c90 <kill>
  kill(pid3);
    47dc:	8552                	mv	a0,s4
    47de:	00001097          	auipc	ra,0x1
    47e2:	4b2080e7          	jalr	1202(ra) # 5c90 <kill>
  printf("wait... ");
    47e6:	00003517          	auipc	a0,0x3
    47ea:	6c250513          	addi	a0,a0,1730 # 7ea8 <malloc+0x1e20>
    47ee:	00001097          	auipc	ra,0x1
    47f2:	7e2080e7          	jalr	2018(ra) # 5fd0 <printf>
  wait(0);
    47f6:	4501                	li	a0,0
    47f8:	00001097          	auipc	ra,0x1
    47fc:	470080e7          	jalr	1136(ra) # 5c68 <wait>
  wait(0);
    4800:	4501                	li	a0,0
    4802:	00001097          	auipc	ra,0x1
    4806:	466080e7          	jalr	1126(ra) # 5c68 <wait>
  wait(0);
    480a:	4501                	li	a0,0
    480c:	00001097          	auipc	ra,0x1
    4810:	45c080e7          	jalr	1116(ra) # 5c68 <wait>
    4814:	b761                	j	479c <preempt+0x12a>

0000000000004816 <reparent>:
{
    4816:	7179                	addi	sp,sp,-48
    4818:	f406                	sd	ra,40(sp)
    481a:	f022                	sd	s0,32(sp)
    481c:	ec26                	sd	s1,24(sp)
    481e:	e84a                	sd	s2,16(sp)
    4820:	e44e                	sd	s3,8(sp)
    4822:	e052                	sd	s4,0(sp)
    4824:	1800                	addi	s0,sp,48
    4826:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4828:	00001097          	auipc	ra,0x1
    482c:	4b8080e7          	jalr	1208(ra) # 5ce0 <getpid>
    4830:	8a2a                	mv	s4,a0
    4832:	0c800913          	li	s2,200
    int pid = fork();
    4836:	00001097          	auipc	ra,0x1
    483a:	422080e7          	jalr	1058(ra) # 5c58 <fork>
    483e:	84aa                	mv	s1,a0
    if(pid < 0){
    4840:	02054263          	bltz	a0,4864 <reparent+0x4e>
    if(pid){
    4844:	cd21                	beqz	a0,489c <reparent+0x86>
      if(wait(0) != pid){
    4846:	4501                	li	a0,0
    4848:	00001097          	auipc	ra,0x1
    484c:	420080e7          	jalr	1056(ra) # 5c68 <wait>
    4850:	02951863          	bne	a0,s1,4880 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4854:	397d                	addiw	s2,s2,-1
    4856:	fe0910e3          	bnez	s2,4836 <reparent+0x20>
  exit(0);
    485a:	4501                	li	a0,0
    485c:	00001097          	auipc	ra,0x1
    4860:	404080e7          	jalr	1028(ra) # 5c60 <exit>
      printf("%s: fork failed\n", s);
    4864:	85ce                	mv	a1,s3
    4866:	00002517          	auipc	a0,0x2
    486a:	1ea50513          	addi	a0,a0,490 # 6a50 <malloc+0x9c8>
    486e:	00001097          	auipc	ra,0x1
    4872:	762080e7          	jalr	1890(ra) # 5fd0 <printf>
      exit(1);
    4876:	4505                	li	a0,1
    4878:	00001097          	auipc	ra,0x1
    487c:	3e8080e7          	jalr	1000(ra) # 5c60 <exit>
        printf("%s: wait wrong pid\n", s);
    4880:	85ce                	mv	a1,s3
    4882:	00002517          	auipc	a0,0x2
    4886:	35650513          	addi	a0,a0,854 # 6bd8 <malloc+0xb50>
    488a:	00001097          	auipc	ra,0x1
    488e:	746080e7          	jalr	1862(ra) # 5fd0 <printf>
        exit(1);
    4892:	4505                	li	a0,1
    4894:	00001097          	auipc	ra,0x1
    4898:	3cc080e7          	jalr	972(ra) # 5c60 <exit>
      int pid2 = fork();
    489c:	00001097          	auipc	ra,0x1
    48a0:	3bc080e7          	jalr	956(ra) # 5c58 <fork>
      if(pid2 < 0){
    48a4:	00054763          	bltz	a0,48b2 <reparent+0x9c>
      exit(0);
    48a8:	4501                	li	a0,0
    48aa:	00001097          	auipc	ra,0x1
    48ae:	3b6080e7          	jalr	950(ra) # 5c60 <exit>
        kill(master_pid);
    48b2:	8552                	mv	a0,s4
    48b4:	00001097          	auipc	ra,0x1
    48b8:	3dc080e7          	jalr	988(ra) # 5c90 <kill>
        exit(1);
    48bc:	4505                	li	a0,1
    48be:	00001097          	auipc	ra,0x1
    48c2:	3a2080e7          	jalr	930(ra) # 5c60 <exit>

00000000000048c6 <sbrkfail>:
{
    48c6:	7119                	addi	sp,sp,-128
    48c8:	fc86                	sd	ra,120(sp)
    48ca:	f8a2                	sd	s0,112(sp)
    48cc:	f4a6                	sd	s1,104(sp)
    48ce:	f0ca                	sd	s2,96(sp)
    48d0:	ecce                	sd	s3,88(sp)
    48d2:	e8d2                	sd	s4,80(sp)
    48d4:	e4d6                	sd	s5,72(sp)
    48d6:	0100                	addi	s0,sp,128
    48d8:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    48da:	fb040513          	addi	a0,s0,-80
    48de:	00001097          	auipc	ra,0x1
    48e2:	392080e7          	jalr	914(ra) # 5c70 <pipe>
    48e6:	e901                	bnez	a0,48f6 <sbrkfail+0x30>
    48e8:	f8040493          	addi	s1,s0,-128
    48ec:	fa840993          	addi	s3,s0,-88
    48f0:	8926                	mv	s2,s1
    if(pids[i] != -1)
    48f2:	5a7d                	li	s4,-1
    48f4:	a085                	j	4954 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    48f6:	85d6                	mv	a1,s5
    48f8:	00002517          	auipc	a0,0x2
    48fc:	26050513          	addi	a0,a0,608 # 6b58 <malloc+0xad0>
    4900:	00001097          	auipc	ra,0x1
    4904:	6d0080e7          	jalr	1744(ra) # 5fd0 <printf>
    exit(1);
    4908:	4505                	li	a0,1
    490a:	00001097          	auipc	ra,0x1
    490e:	356080e7          	jalr	854(ra) # 5c60 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4912:	00001097          	auipc	ra,0x1
    4916:	3d6080e7          	jalr	982(ra) # 5ce8 <sbrk>
    491a:	064007b7          	lui	a5,0x6400
    491e:	40a7853b          	subw	a0,a5,a0
    4922:	00001097          	auipc	ra,0x1
    4926:	3c6080e7          	jalr	966(ra) # 5ce8 <sbrk>
      write(fds[1], "x", 1);
    492a:	4605                	li	a2,1
    492c:	00002597          	auipc	a1,0x2
    4930:	90c58593          	addi	a1,a1,-1780 # 6238 <malloc+0x1b0>
    4934:	fb442503          	lw	a0,-76(s0)
    4938:	00001097          	auipc	ra,0x1
    493c:	348080e7          	jalr	840(ra) # 5c80 <write>
      for(;;) sleep(1000);
    4940:	3e800513          	li	a0,1000
    4944:	00001097          	auipc	ra,0x1
    4948:	3ac080e7          	jalr	940(ra) # 5cf0 <sleep>
    494c:	bfd5                	j	4940 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    494e:	0911                	addi	s2,s2,4
    4950:	03390563          	beq	s2,s3,497a <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4954:	00001097          	auipc	ra,0x1
    4958:	304080e7          	jalr	772(ra) # 5c58 <fork>
    495c:	00a92023          	sw	a0,0(s2)
    4960:	d94d                	beqz	a0,4912 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4962:	ff4506e3          	beq	a0,s4,494e <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4966:	4605                	li	a2,1
    4968:	faf40593          	addi	a1,s0,-81
    496c:	fb042503          	lw	a0,-80(s0)
    4970:	00001097          	auipc	ra,0x1
    4974:	308080e7          	jalr	776(ra) # 5c78 <read>
    4978:	bfd9                	j	494e <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    497a:	6505                	lui	a0,0x1
    497c:	00001097          	auipc	ra,0x1
    4980:	36c080e7          	jalr	876(ra) # 5ce8 <sbrk>
    4984:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4986:	597d                	li	s2,-1
    4988:	a021                	j	4990 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    498a:	0491                	addi	s1,s1,4
    498c:	01348f63          	beq	s1,s3,49aa <sbrkfail+0xe4>
    if(pids[i] == -1)
    4990:	4088                	lw	a0,0(s1)
    4992:	ff250ce3          	beq	a0,s2,498a <sbrkfail+0xc4>
    kill(pids[i]);
    4996:	00001097          	auipc	ra,0x1
    499a:	2fa080e7          	jalr	762(ra) # 5c90 <kill>
    wait(0);
    499e:	4501                	li	a0,0
    49a0:	00001097          	auipc	ra,0x1
    49a4:	2c8080e7          	jalr	712(ra) # 5c68 <wait>
    49a8:	b7cd                	j	498a <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    49aa:	57fd                	li	a5,-1
    49ac:	04fa0163          	beq	s4,a5,49ee <sbrkfail+0x128>
  pid = fork();
    49b0:	00001097          	auipc	ra,0x1
    49b4:	2a8080e7          	jalr	680(ra) # 5c58 <fork>
    49b8:	84aa                	mv	s1,a0
  if(pid < 0){
    49ba:	04054863          	bltz	a0,4a0a <sbrkfail+0x144>
  if(pid == 0){
    49be:	c525                	beqz	a0,4a26 <sbrkfail+0x160>
  wait(&xstatus);
    49c0:	fbc40513          	addi	a0,s0,-68
    49c4:	00001097          	auipc	ra,0x1
    49c8:	2a4080e7          	jalr	676(ra) # 5c68 <wait>
  if(xstatus != -1 && xstatus != 2)
    49cc:	fbc42783          	lw	a5,-68(s0)
    49d0:	577d                	li	a4,-1
    49d2:	00e78563          	beq	a5,a4,49dc <sbrkfail+0x116>
    49d6:	4709                	li	a4,2
    49d8:	08e79d63          	bne	a5,a4,4a72 <sbrkfail+0x1ac>
}
    49dc:	70e6                	ld	ra,120(sp)
    49de:	7446                	ld	s0,112(sp)
    49e0:	74a6                	ld	s1,104(sp)
    49e2:	7906                	ld	s2,96(sp)
    49e4:	69e6                	ld	s3,88(sp)
    49e6:	6a46                	ld	s4,80(sp)
    49e8:	6aa6                	ld	s5,72(sp)
    49ea:	6109                	addi	sp,sp,128
    49ec:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    49ee:	85d6                	mv	a1,s5
    49f0:	00003517          	auipc	a0,0x3
    49f4:	4c850513          	addi	a0,a0,1224 # 7eb8 <malloc+0x1e30>
    49f8:	00001097          	auipc	ra,0x1
    49fc:	5d8080e7          	jalr	1496(ra) # 5fd0 <printf>
    exit(1);
    4a00:	4505                	li	a0,1
    4a02:	00001097          	auipc	ra,0x1
    4a06:	25e080e7          	jalr	606(ra) # 5c60 <exit>
    printf("%s: fork failed\n", s);
    4a0a:	85d6                	mv	a1,s5
    4a0c:	00002517          	auipc	a0,0x2
    4a10:	04450513          	addi	a0,a0,68 # 6a50 <malloc+0x9c8>
    4a14:	00001097          	auipc	ra,0x1
    4a18:	5bc080e7          	jalr	1468(ra) # 5fd0 <printf>
    exit(1);
    4a1c:	4505                	li	a0,1
    4a1e:	00001097          	auipc	ra,0x1
    4a22:	242080e7          	jalr	578(ra) # 5c60 <exit>
    a = sbrk(0);
    4a26:	4501                	li	a0,0
    4a28:	00001097          	auipc	ra,0x1
    4a2c:	2c0080e7          	jalr	704(ra) # 5ce8 <sbrk>
    4a30:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4a32:	3e800537          	lui	a0,0x3e800
    4a36:	00001097          	auipc	ra,0x1
    4a3a:	2b2080e7          	jalr	690(ra) # 5ce8 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4a3e:	87ca                	mv	a5,s2
    4a40:	3e800737          	lui	a4,0x3e800
    4a44:	993a                	add	s2,s2,a4
    4a46:	6705                	lui	a4,0x1
      n += *(a+i);
    4a48:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    4a4c:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4a4e:	97ba                	add	a5,a5,a4
    4a50:	fef91ce3          	bne	s2,a5,4a48 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4a54:	8626                	mv	a2,s1
    4a56:	85d6                	mv	a1,s5
    4a58:	00003517          	auipc	a0,0x3
    4a5c:	48050513          	addi	a0,a0,1152 # 7ed8 <malloc+0x1e50>
    4a60:	00001097          	auipc	ra,0x1
    4a64:	570080e7          	jalr	1392(ra) # 5fd0 <printf>
    exit(1);
    4a68:	4505                	li	a0,1
    4a6a:	00001097          	auipc	ra,0x1
    4a6e:	1f6080e7          	jalr	502(ra) # 5c60 <exit>
    exit(1);
    4a72:	4505                	li	a0,1
    4a74:	00001097          	auipc	ra,0x1
    4a78:	1ec080e7          	jalr	492(ra) # 5c60 <exit>

0000000000004a7c <mem>:
{
    4a7c:	7139                	addi	sp,sp,-64
    4a7e:	fc06                	sd	ra,56(sp)
    4a80:	f822                	sd	s0,48(sp)
    4a82:	f426                	sd	s1,40(sp)
    4a84:	f04a                	sd	s2,32(sp)
    4a86:	ec4e                	sd	s3,24(sp)
    4a88:	0080                	addi	s0,sp,64
    4a8a:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4a8c:	00001097          	auipc	ra,0x1
    4a90:	1cc080e7          	jalr	460(ra) # 5c58 <fork>
    m1 = 0;
    4a94:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4a96:	6909                	lui	s2,0x2
    4a98:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x6d>
  if((pid = fork()) == 0){
    4a9c:	c115                	beqz	a0,4ac0 <mem+0x44>
    wait(&xstatus);
    4a9e:	fcc40513          	addi	a0,s0,-52
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	1c6080e7          	jalr	454(ra) # 5c68 <wait>
    if(xstatus == -1){
    4aaa:	fcc42503          	lw	a0,-52(s0)
    4aae:	57fd                	li	a5,-1
    4ab0:	06f50363          	beq	a0,a5,4b16 <mem+0x9a>
    exit(xstatus);
    4ab4:	00001097          	auipc	ra,0x1
    4ab8:	1ac080e7          	jalr	428(ra) # 5c60 <exit>
      *(char**)m2 = m1;
    4abc:	e104                	sd	s1,0(a0)
      m1 = m2;
    4abe:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4ac0:	854a                	mv	a0,s2
    4ac2:	00001097          	auipc	ra,0x1
    4ac6:	5c6080e7          	jalr	1478(ra) # 6088 <malloc>
    4aca:	f96d                	bnez	a0,4abc <mem+0x40>
    while(m1){
    4acc:	c881                	beqz	s1,4adc <mem+0x60>
      m2 = *(char**)m1;
    4ace:	8526                	mv	a0,s1
    4ad0:	6084                	ld	s1,0(s1)
      free(m1);
    4ad2:	00001097          	auipc	ra,0x1
    4ad6:	534080e7          	jalr	1332(ra) # 6006 <free>
    while(m1){
    4ada:	f8f5                	bnez	s1,4ace <mem+0x52>
    m1 = malloc(1024*20);
    4adc:	6515                	lui	a0,0x5
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	5aa080e7          	jalr	1450(ra) # 6088 <malloc>
    if(m1 == 0){
    4ae6:	c911                	beqz	a0,4afa <mem+0x7e>
    free(m1);
    4ae8:	00001097          	auipc	ra,0x1
    4aec:	51e080e7          	jalr	1310(ra) # 6006 <free>
    exit(0);
    4af0:	4501                	li	a0,0
    4af2:	00001097          	auipc	ra,0x1
    4af6:	16e080e7          	jalr	366(ra) # 5c60 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4afa:	85ce                	mv	a1,s3
    4afc:	00003517          	auipc	a0,0x3
    4b00:	40c50513          	addi	a0,a0,1036 # 7f08 <malloc+0x1e80>
    4b04:	00001097          	auipc	ra,0x1
    4b08:	4cc080e7          	jalr	1228(ra) # 5fd0 <printf>
      exit(1);
    4b0c:	4505                	li	a0,1
    4b0e:	00001097          	auipc	ra,0x1
    4b12:	152080e7          	jalr	338(ra) # 5c60 <exit>
      exit(0);
    4b16:	4501                	li	a0,0
    4b18:	00001097          	auipc	ra,0x1
    4b1c:	148080e7          	jalr	328(ra) # 5c60 <exit>

0000000000004b20 <sharedfd>:
{
    4b20:	7159                	addi	sp,sp,-112
    4b22:	f486                	sd	ra,104(sp)
    4b24:	f0a2                	sd	s0,96(sp)
    4b26:	e0d2                	sd	s4,64(sp)
    4b28:	1880                	addi	s0,sp,112
    4b2a:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4b2c:	00003517          	auipc	a0,0x3
    4b30:	3fc50513          	addi	a0,a0,1020 # 7f28 <malloc+0x1ea0>
    4b34:	00001097          	auipc	ra,0x1
    4b38:	17c080e7          	jalr	380(ra) # 5cb0 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4b3c:	20200593          	li	a1,514
    4b40:	00003517          	auipc	a0,0x3
    4b44:	3e850513          	addi	a0,a0,1000 # 7f28 <malloc+0x1ea0>
    4b48:	00001097          	auipc	ra,0x1
    4b4c:	158080e7          	jalr	344(ra) # 5ca0 <open>
  if(fd < 0){
    4b50:	06054063          	bltz	a0,4bb0 <sharedfd+0x90>
    4b54:	eca6                	sd	s1,88(sp)
    4b56:	e8ca                	sd	s2,80(sp)
    4b58:	e4ce                	sd	s3,72(sp)
    4b5a:	fc56                	sd	s5,56(sp)
    4b5c:	f85a                	sd	s6,48(sp)
    4b5e:	f45e                	sd	s7,40(sp)
    4b60:	892a                	mv	s2,a0
  pid = fork();
    4b62:	00001097          	auipc	ra,0x1
    4b66:	0f6080e7          	jalr	246(ra) # 5c58 <fork>
    4b6a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4b6c:	07000593          	li	a1,112
    4b70:	e119                	bnez	a0,4b76 <sharedfd+0x56>
    4b72:	06300593          	li	a1,99
    4b76:	4629                	li	a2,10
    4b78:	fa040513          	addi	a0,s0,-96
    4b7c:	00001097          	auipc	ra,0x1
    4b80:	eea080e7          	jalr	-278(ra) # 5a66 <memset>
    4b84:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4b88:	4629                	li	a2,10
    4b8a:	fa040593          	addi	a1,s0,-96
    4b8e:	854a                	mv	a0,s2
    4b90:	00001097          	auipc	ra,0x1
    4b94:	0f0080e7          	jalr	240(ra) # 5c80 <write>
    4b98:	47a9                	li	a5,10
    4b9a:	02f51f63          	bne	a0,a5,4bd8 <sharedfd+0xb8>
  for(i = 0; i < N; i++){
    4b9e:	34fd                	addiw	s1,s1,-1
    4ba0:	f4e5                	bnez	s1,4b88 <sharedfd+0x68>
  if(pid == 0) {
    4ba2:	04099963          	bnez	s3,4bf4 <sharedfd+0xd4>
    exit(0);
    4ba6:	4501                	li	a0,0
    4ba8:	00001097          	auipc	ra,0x1
    4bac:	0b8080e7          	jalr	184(ra) # 5c60 <exit>
    4bb0:	eca6                	sd	s1,88(sp)
    4bb2:	e8ca                	sd	s2,80(sp)
    4bb4:	e4ce                	sd	s3,72(sp)
    4bb6:	fc56                	sd	s5,56(sp)
    4bb8:	f85a                	sd	s6,48(sp)
    4bba:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4bbc:	85d2                	mv	a1,s4
    4bbe:	00003517          	auipc	a0,0x3
    4bc2:	37a50513          	addi	a0,a0,890 # 7f38 <malloc+0x1eb0>
    4bc6:	00001097          	auipc	ra,0x1
    4bca:	40a080e7          	jalr	1034(ra) # 5fd0 <printf>
    exit(1);
    4bce:	4505                	li	a0,1
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	090080e7          	jalr	144(ra) # 5c60 <exit>
      printf("%s: write sharedfd failed\n", s);
    4bd8:	85d2                	mv	a1,s4
    4bda:	00003517          	auipc	a0,0x3
    4bde:	38650513          	addi	a0,a0,902 # 7f60 <malloc+0x1ed8>
    4be2:	00001097          	auipc	ra,0x1
    4be6:	3ee080e7          	jalr	1006(ra) # 5fd0 <printf>
      exit(1);
    4bea:	4505                	li	a0,1
    4bec:	00001097          	auipc	ra,0x1
    4bf0:	074080e7          	jalr	116(ra) # 5c60 <exit>
    wait(&xstatus);
    4bf4:	f9c40513          	addi	a0,s0,-100
    4bf8:	00001097          	auipc	ra,0x1
    4bfc:	070080e7          	jalr	112(ra) # 5c68 <wait>
    if(xstatus != 0)
    4c00:	f9c42983          	lw	s3,-100(s0)
    4c04:	00098763          	beqz	s3,4c12 <sharedfd+0xf2>
      exit(xstatus);
    4c08:	854e                	mv	a0,s3
    4c0a:	00001097          	auipc	ra,0x1
    4c0e:	056080e7          	jalr	86(ra) # 5c60 <exit>
  close(fd);
    4c12:	854a                	mv	a0,s2
    4c14:	00001097          	auipc	ra,0x1
    4c18:	074080e7          	jalr	116(ra) # 5c88 <close>
  fd = open("sharedfd", 0);
    4c1c:	4581                	li	a1,0
    4c1e:	00003517          	auipc	a0,0x3
    4c22:	30a50513          	addi	a0,a0,778 # 7f28 <malloc+0x1ea0>
    4c26:	00001097          	auipc	ra,0x1
    4c2a:	07a080e7          	jalr	122(ra) # 5ca0 <open>
    4c2e:	8baa                	mv	s7,a0
  nc = np = 0;
    4c30:	8ace                	mv	s5,s3
  if(fd < 0){
    4c32:	02054563          	bltz	a0,4c5c <sharedfd+0x13c>
    4c36:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4c3a:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4c3e:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4c42:	4629                	li	a2,10
    4c44:	fa040593          	addi	a1,s0,-96
    4c48:	855e                	mv	a0,s7
    4c4a:	00001097          	auipc	ra,0x1
    4c4e:	02e080e7          	jalr	46(ra) # 5c78 <read>
    4c52:	02a05f63          	blez	a0,4c90 <sharedfd+0x170>
    4c56:	fa040793          	addi	a5,s0,-96
    4c5a:	a01d                	j	4c80 <sharedfd+0x160>
    printf("%s: cannot open sharedfd for reading\n", s);
    4c5c:	85d2                	mv	a1,s4
    4c5e:	00003517          	auipc	a0,0x3
    4c62:	32250513          	addi	a0,a0,802 # 7f80 <malloc+0x1ef8>
    4c66:	00001097          	auipc	ra,0x1
    4c6a:	36a080e7          	jalr	874(ra) # 5fd0 <printf>
    exit(1);
    4c6e:	4505                	li	a0,1
    4c70:	00001097          	auipc	ra,0x1
    4c74:	ff0080e7          	jalr	-16(ra) # 5c60 <exit>
        nc++;
    4c78:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4c7a:	0785                	addi	a5,a5,1
    4c7c:	fd2783e3          	beq	a5,s2,4c42 <sharedfd+0x122>
      if(buf[i] == 'c')
    4c80:	0007c703          	lbu	a4,0(a5)
    4c84:	fe970ae3          	beq	a4,s1,4c78 <sharedfd+0x158>
      if(buf[i] == 'p')
    4c88:	ff6719e3          	bne	a4,s6,4c7a <sharedfd+0x15a>
        np++;
    4c8c:	2a85                	addiw	s5,s5,1
    4c8e:	b7f5                	j	4c7a <sharedfd+0x15a>
  close(fd);
    4c90:	855e                	mv	a0,s7
    4c92:	00001097          	auipc	ra,0x1
    4c96:	ff6080e7          	jalr	-10(ra) # 5c88 <close>
  unlink("sharedfd");
    4c9a:	00003517          	auipc	a0,0x3
    4c9e:	28e50513          	addi	a0,a0,654 # 7f28 <malloc+0x1ea0>
    4ca2:	00001097          	auipc	ra,0x1
    4ca6:	00e080e7          	jalr	14(ra) # 5cb0 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4caa:	6789                	lui	a5,0x2
    4cac:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x6c>
    4cb0:	00f99763          	bne	s3,a5,4cbe <sharedfd+0x19e>
    4cb4:	6789                	lui	a5,0x2
    4cb6:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x6c>
    4cba:	02fa8063          	beq	s5,a5,4cda <sharedfd+0x1ba>
    printf("%s: nc/np test fails\n", s);
    4cbe:	85d2                	mv	a1,s4
    4cc0:	00003517          	auipc	a0,0x3
    4cc4:	2e850513          	addi	a0,a0,744 # 7fa8 <malloc+0x1f20>
    4cc8:	00001097          	auipc	ra,0x1
    4ccc:	308080e7          	jalr	776(ra) # 5fd0 <printf>
    exit(1);
    4cd0:	4505                	li	a0,1
    4cd2:	00001097          	auipc	ra,0x1
    4cd6:	f8e080e7          	jalr	-114(ra) # 5c60 <exit>
    exit(0);
    4cda:	4501                	li	a0,0
    4cdc:	00001097          	auipc	ra,0x1
    4ce0:	f84080e7          	jalr	-124(ra) # 5c60 <exit>

0000000000004ce4 <fourfiles>:
{
    4ce4:	7135                	addi	sp,sp,-160
    4ce6:	ed06                	sd	ra,152(sp)
    4ce8:	e922                	sd	s0,144(sp)
    4cea:	e526                	sd	s1,136(sp)
    4cec:	e14a                	sd	s2,128(sp)
    4cee:	fcce                	sd	s3,120(sp)
    4cf0:	f8d2                	sd	s4,112(sp)
    4cf2:	f4d6                	sd	s5,104(sp)
    4cf4:	f0da                	sd	s6,96(sp)
    4cf6:	ecde                	sd	s7,88(sp)
    4cf8:	e8e2                	sd	s8,80(sp)
    4cfa:	e4e6                	sd	s9,72(sp)
    4cfc:	e0ea                	sd	s10,64(sp)
    4cfe:	fc6e                	sd	s11,56(sp)
    4d00:	1100                	addi	s0,sp,160
    4d02:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4d04:	00003797          	auipc	a5,0x3
    4d08:	2bc78793          	addi	a5,a5,700 # 7fc0 <malloc+0x1f38>
    4d0c:	f6f43823          	sd	a5,-144(s0)
    4d10:	00003797          	auipc	a5,0x3
    4d14:	2b878793          	addi	a5,a5,696 # 7fc8 <malloc+0x1f40>
    4d18:	f6f43c23          	sd	a5,-136(s0)
    4d1c:	00003797          	auipc	a5,0x3
    4d20:	2b478793          	addi	a5,a5,692 # 7fd0 <malloc+0x1f48>
    4d24:	f8f43023          	sd	a5,-128(s0)
    4d28:	00003797          	auipc	a5,0x3
    4d2c:	2b078793          	addi	a5,a5,688 # 7fd8 <malloc+0x1f50>
    4d30:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4d34:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4d38:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4d3a:	4481                	li	s1,0
    4d3c:	4a11                	li	s4,4
    fname = names[pi];
    4d3e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4d42:	854e                	mv	a0,s3
    4d44:	00001097          	auipc	ra,0x1
    4d48:	f6c080e7          	jalr	-148(ra) # 5cb0 <unlink>
    pid = fork();
    4d4c:	00001097          	auipc	ra,0x1
    4d50:	f0c080e7          	jalr	-244(ra) # 5c58 <fork>
    if(pid < 0){
    4d54:	04054063          	bltz	a0,4d94 <fourfiles+0xb0>
    if(pid == 0){
    4d58:	cd21                	beqz	a0,4db0 <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4d5a:	2485                	addiw	s1,s1,1
    4d5c:	0921                	addi	s2,s2,8
    4d5e:	ff4490e3          	bne	s1,s4,4d3e <fourfiles+0x5a>
    4d62:	4491                	li	s1,4
    wait(&xstatus);
    4d64:	f6c40513          	addi	a0,s0,-148
    4d68:	00001097          	auipc	ra,0x1
    4d6c:	f00080e7          	jalr	-256(ra) # 5c68 <wait>
    if(xstatus != 0)
    4d70:	f6c42a83          	lw	s5,-148(s0)
    4d74:	0c0a9863          	bnez	s5,4e44 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4d78:	34fd                	addiw	s1,s1,-1
    4d7a:	f4ed                	bnez	s1,4d64 <fourfiles+0x80>
    4d7c:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4d80:	00008a17          	auipc	s4,0x8
    4d84:	ef8a0a13          	addi	s4,s4,-264 # cc78 <buf>
    if(total != N*SZ){
    4d88:	6d05                	lui	s10,0x1
    4d8a:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x20>
  for(i = 0; i < NCHILD; i++){
    4d8e:	03400d93          	li	s11,52
    4d92:	a22d                	j	4ebc <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4d94:	85e6                	mv	a1,s9
    4d96:	00002517          	auipc	a0,0x2
    4d9a:	0c250513          	addi	a0,a0,194 # 6e58 <malloc+0xdd0>
    4d9e:	00001097          	auipc	ra,0x1
    4da2:	232080e7          	jalr	562(ra) # 5fd0 <printf>
      exit(1);
    4da6:	4505                	li	a0,1
    4da8:	00001097          	auipc	ra,0x1
    4dac:	eb8080e7          	jalr	-328(ra) # 5c60 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4db0:	20200593          	li	a1,514
    4db4:	854e                	mv	a0,s3
    4db6:	00001097          	auipc	ra,0x1
    4dba:	eea080e7          	jalr	-278(ra) # 5ca0 <open>
    4dbe:	892a                	mv	s2,a0
      if(fd < 0){
    4dc0:	04054763          	bltz	a0,4e0e <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4dc4:	1f400613          	li	a2,500
    4dc8:	0304859b          	addiw	a1,s1,48
    4dcc:	00008517          	auipc	a0,0x8
    4dd0:	eac50513          	addi	a0,a0,-340 # cc78 <buf>
    4dd4:	00001097          	auipc	ra,0x1
    4dd8:	c92080e7          	jalr	-878(ra) # 5a66 <memset>
    4ddc:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4dde:	00008997          	auipc	s3,0x8
    4de2:	e9a98993          	addi	s3,s3,-358 # cc78 <buf>
    4de6:	1f400613          	li	a2,500
    4dea:	85ce                	mv	a1,s3
    4dec:	854a                	mv	a0,s2
    4dee:	00001097          	auipc	ra,0x1
    4df2:	e92080e7          	jalr	-366(ra) # 5c80 <write>
    4df6:	85aa                	mv	a1,a0
    4df8:	1f400793          	li	a5,500
    4dfc:	02f51763          	bne	a0,a5,4e2a <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4e00:	34fd                	addiw	s1,s1,-1
    4e02:	f0f5                	bnez	s1,4de6 <fourfiles+0x102>
      exit(0);
    4e04:	4501                	li	a0,0
    4e06:	00001097          	auipc	ra,0x1
    4e0a:	e5a080e7          	jalr	-422(ra) # 5c60 <exit>
        printf("create failed\n", s);
    4e0e:	85e6                	mv	a1,s9
    4e10:	00003517          	auipc	a0,0x3
    4e14:	1d050513          	addi	a0,a0,464 # 7fe0 <malloc+0x1f58>
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	1b8080e7          	jalr	440(ra) # 5fd0 <printf>
        exit(1);
    4e20:	4505                	li	a0,1
    4e22:	00001097          	auipc	ra,0x1
    4e26:	e3e080e7          	jalr	-450(ra) # 5c60 <exit>
          printf("write failed %d\n", n);
    4e2a:	00003517          	auipc	a0,0x3
    4e2e:	1c650513          	addi	a0,a0,454 # 7ff0 <malloc+0x1f68>
    4e32:	00001097          	auipc	ra,0x1
    4e36:	19e080e7          	jalr	414(ra) # 5fd0 <printf>
          exit(1);
    4e3a:	4505                	li	a0,1
    4e3c:	00001097          	auipc	ra,0x1
    4e40:	e24080e7          	jalr	-476(ra) # 5c60 <exit>
      exit(xstatus);
    4e44:	8556                	mv	a0,s5
    4e46:	00001097          	auipc	ra,0x1
    4e4a:	e1a080e7          	jalr	-486(ra) # 5c60 <exit>
          printf("wrong char\n", s);
    4e4e:	85e6                	mv	a1,s9
    4e50:	00003517          	auipc	a0,0x3
    4e54:	1b850513          	addi	a0,a0,440 # 8008 <malloc+0x1f80>
    4e58:	00001097          	auipc	ra,0x1
    4e5c:	178080e7          	jalr	376(ra) # 5fd0 <printf>
          exit(1);
    4e60:	4505                	li	a0,1
    4e62:	00001097          	auipc	ra,0x1
    4e66:	dfe080e7          	jalr	-514(ra) # 5c60 <exit>
      total += n;
    4e6a:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e6e:	660d                	lui	a2,0x3
    4e70:	85d2                	mv	a1,s4
    4e72:	854e                	mv	a0,s3
    4e74:	00001097          	auipc	ra,0x1
    4e78:	e04080e7          	jalr	-508(ra) # 5c78 <read>
    4e7c:	02a05063          	blez	a0,4e9c <fourfiles+0x1b8>
    4e80:	00008797          	auipc	a5,0x8
    4e84:	df878793          	addi	a5,a5,-520 # cc78 <buf>
    4e88:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4e8c:	0007c703          	lbu	a4,0(a5)
    4e90:	fa971fe3          	bne	a4,s1,4e4e <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4e94:	0785                	addi	a5,a5,1
    4e96:	fed79be3          	bne	a5,a3,4e8c <fourfiles+0x1a8>
    4e9a:	bfc1                	j	4e6a <fourfiles+0x186>
    close(fd);
    4e9c:	854e                	mv	a0,s3
    4e9e:	00001097          	auipc	ra,0x1
    4ea2:	dea080e7          	jalr	-534(ra) # 5c88 <close>
    if(total != N*SZ){
    4ea6:	03a91863          	bne	s2,s10,4ed6 <fourfiles+0x1f2>
    unlink(fname);
    4eaa:	8562                	mv	a0,s8
    4eac:	00001097          	auipc	ra,0x1
    4eb0:	e04080e7          	jalr	-508(ra) # 5cb0 <unlink>
  for(i = 0; i < NCHILD; i++){
    4eb4:	0ba1                	addi	s7,s7,8
    4eb6:	2b05                	addiw	s6,s6,1
    4eb8:	03bb0d63          	beq	s6,s11,4ef2 <fourfiles+0x20e>
    fname = names[i];
    4ebc:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4ec0:	4581                	li	a1,0
    4ec2:	8562                	mv	a0,s8
    4ec4:	00001097          	auipc	ra,0x1
    4ec8:	ddc080e7          	jalr	-548(ra) # 5ca0 <open>
    4ecc:	89aa                	mv	s3,a0
    total = 0;
    4ece:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4ed0:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4ed4:	bf69                	j	4e6e <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4ed6:	85ca                	mv	a1,s2
    4ed8:	00003517          	auipc	a0,0x3
    4edc:	14050513          	addi	a0,a0,320 # 8018 <malloc+0x1f90>
    4ee0:	00001097          	auipc	ra,0x1
    4ee4:	0f0080e7          	jalr	240(ra) # 5fd0 <printf>
      exit(1);
    4ee8:	4505                	li	a0,1
    4eea:	00001097          	auipc	ra,0x1
    4eee:	d76080e7          	jalr	-650(ra) # 5c60 <exit>
}
    4ef2:	60ea                	ld	ra,152(sp)
    4ef4:	644a                	ld	s0,144(sp)
    4ef6:	64aa                	ld	s1,136(sp)
    4ef8:	690a                	ld	s2,128(sp)
    4efa:	79e6                	ld	s3,120(sp)
    4efc:	7a46                	ld	s4,112(sp)
    4efe:	7aa6                	ld	s5,104(sp)
    4f00:	7b06                	ld	s6,96(sp)
    4f02:	6be6                	ld	s7,88(sp)
    4f04:	6c46                	ld	s8,80(sp)
    4f06:	6ca6                	ld	s9,72(sp)
    4f08:	6d06                	ld	s10,64(sp)
    4f0a:	7de2                	ld	s11,56(sp)
    4f0c:	610d                	addi	sp,sp,160
    4f0e:	8082                	ret

0000000000004f10 <concreate>:
{
    4f10:	7135                	addi	sp,sp,-160
    4f12:	ed06                	sd	ra,152(sp)
    4f14:	e922                	sd	s0,144(sp)
    4f16:	e526                	sd	s1,136(sp)
    4f18:	e14a                	sd	s2,128(sp)
    4f1a:	fcce                	sd	s3,120(sp)
    4f1c:	f8d2                	sd	s4,112(sp)
    4f1e:	f4d6                	sd	s5,104(sp)
    4f20:	f0da                	sd	s6,96(sp)
    4f22:	ecde                	sd	s7,88(sp)
    4f24:	1100                	addi	s0,sp,160
    4f26:	89aa                	mv	s3,a0
  file[0] = 'C';
    4f28:	04300793          	li	a5,67
    4f2c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4f30:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4f34:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4f36:	4b0d                	li	s6,3
    4f38:	4a85                	li	s5,1
      link("C0", file);
    4f3a:	00003b97          	auipc	s7,0x3
    4f3e:	0f6b8b93          	addi	s7,s7,246 # 8030 <malloc+0x1fa8>
  for(i = 0; i < N; i++){
    4f42:	02800a13          	li	s4,40
    4f46:	acc9                	j	5218 <concreate+0x308>
      link("C0", file);
    4f48:	fa840593          	addi	a1,s0,-88
    4f4c:	855e                	mv	a0,s7
    4f4e:	00001097          	auipc	ra,0x1
    4f52:	d72080e7          	jalr	-654(ra) # 5cc0 <link>
    if(pid == 0) {
    4f56:	a465                	j	51fe <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4f58:	4795                	li	a5,5
    4f5a:	02f9693b          	remw	s2,s2,a5
    4f5e:	4785                	li	a5,1
    4f60:	02f90b63          	beq	s2,a5,4f96 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4f64:	20200593          	li	a1,514
    4f68:	fa840513          	addi	a0,s0,-88
    4f6c:	00001097          	auipc	ra,0x1
    4f70:	d34080e7          	jalr	-716(ra) # 5ca0 <open>
      if(fd < 0){
    4f74:	26055c63          	bgez	a0,51ec <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4f78:	fa840593          	addi	a1,s0,-88
    4f7c:	00003517          	auipc	a0,0x3
    4f80:	0bc50513          	addi	a0,a0,188 # 8038 <malloc+0x1fb0>
    4f84:	00001097          	auipc	ra,0x1
    4f88:	04c080e7          	jalr	76(ra) # 5fd0 <printf>
        exit(1);
    4f8c:	4505                	li	a0,1
    4f8e:	00001097          	auipc	ra,0x1
    4f92:	cd2080e7          	jalr	-814(ra) # 5c60 <exit>
      link("C0", file);
    4f96:	fa840593          	addi	a1,s0,-88
    4f9a:	00003517          	auipc	a0,0x3
    4f9e:	09650513          	addi	a0,a0,150 # 8030 <malloc+0x1fa8>
    4fa2:	00001097          	auipc	ra,0x1
    4fa6:	d1e080e7          	jalr	-738(ra) # 5cc0 <link>
      exit(0);
    4faa:	4501                	li	a0,0
    4fac:	00001097          	auipc	ra,0x1
    4fb0:	cb4080e7          	jalr	-844(ra) # 5c60 <exit>
        exit(1);
    4fb4:	4505                	li	a0,1
    4fb6:	00001097          	auipc	ra,0x1
    4fba:	caa080e7          	jalr	-854(ra) # 5c60 <exit>
  memset(fa, 0, sizeof(fa));
    4fbe:	02800613          	li	a2,40
    4fc2:	4581                	li	a1,0
    4fc4:	f8040513          	addi	a0,s0,-128
    4fc8:	00001097          	auipc	ra,0x1
    4fcc:	a9e080e7          	jalr	-1378(ra) # 5a66 <memset>
  fd = open(".", 0);
    4fd0:	4581                	li	a1,0
    4fd2:	00002517          	auipc	a0,0x2
    4fd6:	8de50513          	addi	a0,a0,-1826 # 68b0 <malloc+0x828>
    4fda:	00001097          	auipc	ra,0x1
    4fde:	cc6080e7          	jalr	-826(ra) # 5ca0 <open>
    4fe2:	892a                	mv	s2,a0
  n = 0;
    4fe4:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4fe6:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4fea:	02700b13          	li	s6,39
      fa[i] = 1;
    4fee:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4ff0:	4641                	li	a2,16
    4ff2:	f7040593          	addi	a1,s0,-144
    4ff6:	854a                	mv	a0,s2
    4ff8:	00001097          	auipc	ra,0x1
    4ffc:	c80080e7          	jalr	-896(ra) # 5c78 <read>
    5000:	08a05263          	blez	a0,5084 <concreate+0x174>
    if(de.inum == 0)
    5004:	f7045783          	lhu	a5,-144(s0)
    5008:	d7e5                	beqz	a5,4ff0 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    500a:	f7244783          	lbu	a5,-142(s0)
    500e:	ff4791e3          	bne	a5,s4,4ff0 <concreate+0xe0>
    5012:	f7444783          	lbu	a5,-140(s0)
    5016:	ffe9                	bnez	a5,4ff0 <concreate+0xe0>
      i = de.name[1] - '0';
    5018:	f7344783          	lbu	a5,-141(s0)
    501c:	fd07879b          	addiw	a5,a5,-48
    5020:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    5024:	02eb6063          	bltu	s6,a4,5044 <concreate+0x134>
      if(fa[i]){
    5028:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xbc>
    502c:	97a2                	add	a5,a5,s0
    502e:	fd07c783          	lbu	a5,-48(a5)
    5032:	eb8d                	bnez	a5,5064 <concreate+0x154>
      fa[i] = 1;
    5034:	fb070793          	addi	a5,a4,-80
    5038:	00878733          	add	a4,a5,s0
    503c:	fd770823          	sb	s7,-48(a4)
      n++;
    5040:	2a85                	addiw	s5,s5,1
    5042:	b77d                	j	4ff0 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    5044:	f7240613          	addi	a2,s0,-142
    5048:	85ce                	mv	a1,s3
    504a:	00003517          	auipc	a0,0x3
    504e:	00e50513          	addi	a0,a0,14 # 8058 <malloc+0x1fd0>
    5052:	00001097          	auipc	ra,0x1
    5056:	f7e080e7          	jalr	-130(ra) # 5fd0 <printf>
        exit(1);
    505a:	4505                	li	a0,1
    505c:	00001097          	auipc	ra,0x1
    5060:	c04080e7          	jalr	-1020(ra) # 5c60 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    5064:	f7240613          	addi	a2,s0,-142
    5068:	85ce                	mv	a1,s3
    506a:	00003517          	auipc	a0,0x3
    506e:	00e50513          	addi	a0,a0,14 # 8078 <malloc+0x1ff0>
    5072:	00001097          	auipc	ra,0x1
    5076:	f5e080e7          	jalr	-162(ra) # 5fd0 <printf>
        exit(1);
    507a:	4505                	li	a0,1
    507c:	00001097          	auipc	ra,0x1
    5080:	be4080e7          	jalr	-1052(ra) # 5c60 <exit>
  close(fd);
    5084:	854a                	mv	a0,s2
    5086:	00001097          	auipc	ra,0x1
    508a:	c02080e7          	jalr	-1022(ra) # 5c88 <close>
  if(n != N){
    508e:	02800793          	li	a5,40
    5092:	00fa9763          	bne	s5,a5,50a0 <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    5096:	4a8d                	li	s5,3
    5098:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    509a:	02800a13          	li	s4,40
    509e:	a8c9                	j	5170 <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    50a0:	85ce                	mv	a1,s3
    50a2:	00003517          	auipc	a0,0x3
    50a6:	ffe50513          	addi	a0,a0,-2 # 80a0 <malloc+0x2018>
    50aa:	00001097          	auipc	ra,0x1
    50ae:	f26080e7          	jalr	-218(ra) # 5fd0 <printf>
    exit(1);
    50b2:	4505                	li	a0,1
    50b4:	00001097          	auipc	ra,0x1
    50b8:	bac080e7          	jalr	-1108(ra) # 5c60 <exit>
      printf("%s: fork failed\n", s);
    50bc:	85ce                	mv	a1,s3
    50be:	00002517          	auipc	a0,0x2
    50c2:	99250513          	addi	a0,a0,-1646 # 6a50 <malloc+0x9c8>
    50c6:	00001097          	auipc	ra,0x1
    50ca:	f0a080e7          	jalr	-246(ra) # 5fd0 <printf>
      exit(1);
    50ce:	4505                	li	a0,1
    50d0:	00001097          	auipc	ra,0x1
    50d4:	b90080e7          	jalr	-1136(ra) # 5c60 <exit>
      close(open(file, 0));
    50d8:	4581                	li	a1,0
    50da:	fa840513          	addi	a0,s0,-88
    50de:	00001097          	auipc	ra,0x1
    50e2:	bc2080e7          	jalr	-1086(ra) # 5ca0 <open>
    50e6:	00001097          	auipc	ra,0x1
    50ea:	ba2080e7          	jalr	-1118(ra) # 5c88 <close>
      close(open(file, 0));
    50ee:	4581                	li	a1,0
    50f0:	fa840513          	addi	a0,s0,-88
    50f4:	00001097          	auipc	ra,0x1
    50f8:	bac080e7          	jalr	-1108(ra) # 5ca0 <open>
    50fc:	00001097          	auipc	ra,0x1
    5100:	b8c080e7          	jalr	-1140(ra) # 5c88 <close>
      close(open(file, 0));
    5104:	4581                	li	a1,0
    5106:	fa840513          	addi	a0,s0,-88
    510a:	00001097          	auipc	ra,0x1
    510e:	b96080e7          	jalr	-1130(ra) # 5ca0 <open>
    5112:	00001097          	auipc	ra,0x1
    5116:	b76080e7          	jalr	-1162(ra) # 5c88 <close>
      close(open(file, 0));
    511a:	4581                	li	a1,0
    511c:	fa840513          	addi	a0,s0,-88
    5120:	00001097          	auipc	ra,0x1
    5124:	b80080e7          	jalr	-1152(ra) # 5ca0 <open>
    5128:	00001097          	auipc	ra,0x1
    512c:	b60080e7          	jalr	-1184(ra) # 5c88 <close>
      close(open(file, 0));
    5130:	4581                	li	a1,0
    5132:	fa840513          	addi	a0,s0,-88
    5136:	00001097          	auipc	ra,0x1
    513a:	b6a080e7          	jalr	-1174(ra) # 5ca0 <open>
    513e:	00001097          	auipc	ra,0x1
    5142:	b4a080e7          	jalr	-1206(ra) # 5c88 <close>
      close(open(file, 0));
    5146:	4581                	li	a1,0
    5148:	fa840513          	addi	a0,s0,-88
    514c:	00001097          	auipc	ra,0x1
    5150:	b54080e7          	jalr	-1196(ra) # 5ca0 <open>
    5154:	00001097          	auipc	ra,0x1
    5158:	b34080e7          	jalr	-1228(ra) # 5c88 <close>
    if(pid == 0)
    515c:	08090363          	beqz	s2,51e2 <concreate+0x2d2>
      wait(0);
    5160:	4501                	li	a0,0
    5162:	00001097          	auipc	ra,0x1
    5166:	b06080e7          	jalr	-1274(ra) # 5c68 <wait>
  for(i = 0; i < N; i++){
    516a:	2485                	addiw	s1,s1,1
    516c:	0f448563          	beq	s1,s4,5256 <concreate+0x346>
    file[1] = '0' + i;
    5170:	0304879b          	addiw	a5,s1,48
    5174:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    5178:	00001097          	auipc	ra,0x1
    517c:	ae0080e7          	jalr	-1312(ra) # 5c58 <fork>
    5180:	892a                	mv	s2,a0
    if(pid < 0){
    5182:	f2054de3          	bltz	a0,50bc <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    5186:	0354e73b          	remw	a4,s1,s5
    518a:	00a767b3          	or	a5,a4,a0
    518e:	2781                	sext.w	a5,a5
    5190:	d7a1                	beqz	a5,50d8 <concreate+0x1c8>
    5192:	01671363          	bne	a4,s6,5198 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    5196:	f129                	bnez	a0,50d8 <concreate+0x1c8>
      unlink(file);
    5198:	fa840513          	addi	a0,s0,-88
    519c:	00001097          	auipc	ra,0x1
    51a0:	b14080e7          	jalr	-1260(ra) # 5cb0 <unlink>
      unlink(file);
    51a4:	fa840513          	addi	a0,s0,-88
    51a8:	00001097          	auipc	ra,0x1
    51ac:	b08080e7          	jalr	-1272(ra) # 5cb0 <unlink>
      unlink(file);
    51b0:	fa840513          	addi	a0,s0,-88
    51b4:	00001097          	auipc	ra,0x1
    51b8:	afc080e7          	jalr	-1284(ra) # 5cb0 <unlink>
      unlink(file);
    51bc:	fa840513          	addi	a0,s0,-88
    51c0:	00001097          	auipc	ra,0x1
    51c4:	af0080e7          	jalr	-1296(ra) # 5cb0 <unlink>
      unlink(file);
    51c8:	fa840513          	addi	a0,s0,-88
    51cc:	00001097          	auipc	ra,0x1
    51d0:	ae4080e7          	jalr	-1308(ra) # 5cb0 <unlink>
      unlink(file);
    51d4:	fa840513          	addi	a0,s0,-88
    51d8:	00001097          	auipc	ra,0x1
    51dc:	ad8080e7          	jalr	-1320(ra) # 5cb0 <unlink>
    51e0:	bfb5                	j	515c <concreate+0x24c>
      exit(0);
    51e2:	4501                	li	a0,0
    51e4:	00001097          	auipc	ra,0x1
    51e8:	a7c080e7          	jalr	-1412(ra) # 5c60 <exit>
      close(fd);
    51ec:	00001097          	auipc	ra,0x1
    51f0:	a9c080e7          	jalr	-1380(ra) # 5c88 <close>
    if(pid == 0) {
    51f4:	bb5d                	j	4faa <concreate+0x9a>
      close(fd);
    51f6:	00001097          	auipc	ra,0x1
    51fa:	a92080e7          	jalr	-1390(ra) # 5c88 <close>
      wait(&xstatus);
    51fe:	f6c40513          	addi	a0,s0,-148
    5202:	00001097          	auipc	ra,0x1
    5206:	a66080e7          	jalr	-1434(ra) # 5c68 <wait>
      if(xstatus != 0)
    520a:	f6c42483          	lw	s1,-148(s0)
    520e:	da0493e3          	bnez	s1,4fb4 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5212:	2905                	addiw	s2,s2,1
    5214:	db4905e3          	beq	s2,s4,4fbe <concreate+0xae>
    file[1] = '0' + i;
    5218:	0309079b          	addiw	a5,s2,48
    521c:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5220:	fa840513          	addi	a0,s0,-88
    5224:	00001097          	auipc	ra,0x1
    5228:	a8c080e7          	jalr	-1396(ra) # 5cb0 <unlink>
    pid = fork();
    522c:	00001097          	auipc	ra,0x1
    5230:	a2c080e7          	jalr	-1492(ra) # 5c58 <fork>
    if(pid && (i % 3) == 1){
    5234:	d20502e3          	beqz	a0,4f58 <concreate+0x48>
    5238:	036967bb          	remw	a5,s2,s6
    523c:	d15786e3          	beq	a5,s5,4f48 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5240:	20200593          	li	a1,514
    5244:	fa840513          	addi	a0,s0,-88
    5248:	00001097          	auipc	ra,0x1
    524c:	a58080e7          	jalr	-1448(ra) # 5ca0 <open>
      if(fd < 0){
    5250:	fa0553e3          	bgez	a0,51f6 <concreate+0x2e6>
    5254:	b315                	j	4f78 <concreate+0x68>
}
    5256:	60ea                	ld	ra,152(sp)
    5258:	644a                	ld	s0,144(sp)
    525a:	64aa                	ld	s1,136(sp)
    525c:	690a                	ld	s2,128(sp)
    525e:	79e6                	ld	s3,120(sp)
    5260:	7a46                	ld	s4,112(sp)
    5262:	7aa6                	ld	s5,104(sp)
    5264:	7b06                	ld	s6,96(sp)
    5266:	6be6                	ld	s7,88(sp)
    5268:	610d                	addi	sp,sp,160
    526a:	8082                	ret

000000000000526c <bigfile>:
{
    526c:	7139                	addi	sp,sp,-64
    526e:	fc06                	sd	ra,56(sp)
    5270:	f822                	sd	s0,48(sp)
    5272:	f426                	sd	s1,40(sp)
    5274:	f04a                	sd	s2,32(sp)
    5276:	ec4e                	sd	s3,24(sp)
    5278:	e852                	sd	s4,16(sp)
    527a:	e456                	sd	s5,8(sp)
    527c:	0080                	addi	s0,sp,64
    527e:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    5280:	00003517          	auipc	a0,0x3
    5284:	e5850513          	addi	a0,a0,-424 # 80d8 <malloc+0x2050>
    5288:	00001097          	auipc	ra,0x1
    528c:	a28080e7          	jalr	-1496(ra) # 5cb0 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    5290:	20200593          	li	a1,514
    5294:	00003517          	auipc	a0,0x3
    5298:	e4450513          	addi	a0,a0,-444 # 80d8 <malloc+0x2050>
    529c:	00001097          	auipc	ra,0x1
    52a0:	a04080e7          	jalr	-1532(ra) # 5ca0 <open>
    52a4:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    52a6:	4481                	li	s1,0
    memset(buf, i, SZ);
    52a8:	00008917          	auipc	s2,0x8
    52ac:	9d090913          	addi	s2,s2,-1584 # cc78 <buf>
  for(i = 0; i < N; i++){
    52b0:	4a51                	li	s4,20
  if(fd < 0){
    52b2:	0a054063          	bltz	a0,5352 <bigfile+0xe6>
    memset(buf, i, SZ);
    52b6:	25800613          	li	a2,600
    52ba:	85a6                	mv	a1,s1
    52bc:	854a                	mv	a0,s2
    52be:	00000097          	auipc	ra,0x0
    52c2:	7a8080e7          	jalr	1960(ra) # 5a66 <memset>
    if(write(fd, buf, SZ) != SZ){
    52c6:	25800613          	li	a2,600
    52ca:	85ca                	mv	a1,s2
    52cc:	854e                	mv	a0,s3
    52ce:	00001097          	auipc	ra,0x1
    52d2:	9b2080e7          	jalr	-1614(ra) # 5c80 <write>
    52d6:	25800793          	li	a5,600
    52da:	08f51a63          	bne	a0,a5,536e <bigfile+0x102>
  for(i = 0; i < N; i++){
    52de:	2485                	addiw	s1,s1,1
    52e0:	fd449be3          	bne	s1,s4,52b6 <bigfile+0x4a>
  close(fd);
    52e4:	854e                	mv	a0,s3
    52e6:	00001097          	auipc	ra,0x1
    52ea:	9a2080e7          	jalr	-1630(ra) # 5c88 <close>
  fd = open("bigfile.dat", 0);
    52ee:	4581                	li	a1,0
    52f0:	00003517          	auipc	a0,0x3
    52f4:	de850513          	addi	a0,a0,-536 # 80d8 <malloc+0x2050>
    52f8:	00001097          	auipc	ra,0x1
    52fc:	9a8080e7          	jalr	-1624(ra) # 5ca0 <open>
    5300:	8a2a                	mv	s4,a0
  total = 0;
    5302:	4981                	li	s3,0
  for(i = 0; ; i++){
    5304:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5306:	00008917          	auipc	s2,0x8
    530a:	97290913          	addi	s2,s2,-1678 # cc78 <buf>
  if(fd < 0){
    530e:	06054e63          	bltz	a0,538a <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5312:	12c00613          	li	a2,300
    5316:	85ca                	mv	a1,s2
    5318:	8552                	mv	a0,s4
    531a:	00001097          	auipc	ra,0x1
    531e:	95e080e7          	jalr	-1698(ra) # 5c78 <read>
    if(cc < 0){
    5322:	08054263          	bltz	a0,53a6 <bigfile+0x13a>
    if(cc == 0)
    5326:	c971                	beqz	a0,53fa <bigfile+0x18e>
    if(cc != SZ/2){
    5328:	12c00793          	li	a5,300
    532c:	08f51b63          	bne	a0,a5,53c2 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5330:	01f4d79b          	srliw	a5,s1,0x1f
    5334:	9fa5                	addw	a5,a5,s1
    5336:	4017d79b          	sraiw	a5,a5,0x1
    533a:	00094703          	lbu	a4,0(s2)
    533e:	0af71063          	bne	a4,a5,53de <bigfile+0x172>
    5342:	12b94703          	lbu	a4,299(s2)
    5346:	08f71c63          	bne	a4,a5,53de <bigfile+0x172>
    total += cc;
    534a:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    534e:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5350:	b7c9                	j	5312 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5352:	85d6                	mv	a1,s5
    5354:	00003517          	auipc	a0,0x3
    5358:	d9450513          	addi	a0,a0,-620 # 80e8 <malloc+0x2060>
    535c:	00001097          	auipc	ra,0x1
    5360:	c74080e7          	jalr	-908(ra) # 5fd0 <printf>
    exit(1);
    5364:	4505                	li	a0,1
    5366:	00001097          	auipc	ra,0x1
    536a:	8fa080e7          	jalr	-1798(ra) # 5c60 <exit>
      printf("%s: write bigfile failed\n", s);
    536e:	85d6                	mv	a1,s5
    5370:	00003517          	auipc	a0,0x3
    5374:	d9850513          	addi	a0,a0,-616 # 8108 <malloc+0x2080>
    5378:	00001097          	auipc	ra,0x1
    537c:	c58080e7          	jalr	-936(ra) # 5fd0 <printf>
      exit(1);
    5380:	4505                	li	a0,1
    5382:	00001097          	auipc	ra,0x1
    5386:	8de080e7          	jalr	-1826(ra) # 5c60 <exit>
    printf("%s: cannot open bigfile\n", s);
    538a:	85d6                	mv	a1,s5
    538c:	00003517          	auipc	a0,0x3
    5390:	d9c50513          	addi	a0,a0,-612 # 8128 <malloc+0x20a0>
    5394:	00001097          	auipc	ra,0x1
    5398:	c3c080e7          	jalr	-964(ra) # 5fd0 <printf>
    exit(1);
    539c:	4505                	li	a0,1
    539e:	00001097          	auipc	ra,0x1
    53a2:	8c2080e7          	jalr	-1854(ra) # 5c60 <exit>
      printf("%s: read bigfile failed\n", s);
    53a6:	85d6                	mv	a1,s5
    53a8:	00003517          	auipc	a0,0x3
    53ac:	da050513          	addi	a0,a0,-608 # 8148 <malloc+0x20c0>
    53b0:	00001097          	auipc	ra,0x1
    53b4:	c20080e7          	jalr	-992(ra) # 5fd0 <printf>
      exit(1);
    53b8:	4505                	li	a0,1
    53ba:	00001097          	auipc	ra,0x1
    53be:	8a6080e7          	jalr	-1882(ra) # 5c60 <exit>
      printf("%s: short read bigfile\n", s);
    53c2:	85d6                	mv	a1,s5
    53c4:	00003517          	auipc	a0,0x3
    53c8:	da450513          	addi	a0,a0,-604 # 8168 <malloc+0x20e0>
    53cc:	00001097          	auipc	ra,0x1
    53d0:	c04080e7          	jalr	-1020(ra) # 5fd0 <printf>
      exit(1);
    53d4:	4505                	li	a0,1
    53d6:	00001097          	auipc	ra,0x1
    53da:	88a080e7          	jalr	-1910(ra) # 5c60 <exit>
      printf("%s: read bigfile wrong data\n", s);
    53de:	85d6                	mv	a1,s5
    53e0:	00003517          	auipc	a0,0x3
    53e4:	da050513          	addi	a0,a0,-608 # 8180 <malloc+0x20f8>
    53e8:	00001097          	auipc	ra,0x1
    53ec:	be8080e7          	jalr	-1048(ra) # 5fd0 <printf>
      exit(1);
    53f0:	4505                	li	a0,1
    53f2:	00001097          	auipc	ra,0x1
    53f6:	86e080e7          	jalr	-1938(ra) # 5c60 <exit>
  close(fd);
    53fa:	8552                	mv	a0,s4
    53fc:	00001097          	auipc	ra,0x1
    5400:	88c080e7          	jalr	-1908(ra) # 5c88 <close>
  if(total != N*SZ){
    5404:	678d                	lui	a5,0x3
    5406:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrkbugs+0xee>
    540a:	02f99363          	bne	s3,a5,5430 <bigfile+0x1c4>
  unlink("bigfile.dat");
    540e:	00003517          	auipc	a0,0x3
    5412:	cca50513          	addi	a0,a0,-822 # 80d8 <malloc+0x2050>
    5416:	00001097          	auipc	ra,0x1
    541a:	89a080e7          	jalr	-1894(ra) # 5cb0 <unlink>
}
    541e:	70e2                	ld	ra,56(sp)
    5420:	7442                	ld	s0,48(sp)
    5422:	74a2                	ld	s1,40(sp)
    5424:	7902                	ld	s2,32(sp)
    5426:	69e2                	ld	s3,24(sp)
    5428:	6a42                	ld	s4,16(sp)
    542a:	6aa2                	ld	s5,8(sp)
    542c:	6121                	addi	sp,sp,64
    542e:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5430:	85d6                	mv	a1,s5
    5432:	00003517          	auipc	a0,0x3
    5436:	d6e50513          	addi	a0,a0,-658 # 81a0 <malloc+0x2118>
    543a:	00001097          	auipc	ra,0x1
    543e:	b96080e7          	jalr	-1130(ra) # 5fd0 <printf>
    exit(1);
    5442:	4505                	li	a0,1
    5444:	00001097          	auipc	ra,0x1
    5448:	81c080e7          	jalr	-2020(ra) # 5c60 <exit>

000000000000544c <fsfull>:
{
    544c:	7135                	addi	sp,sp,-160
    544e:	ed06                	sd	ra,152(sp)
    5450:	e922                	sd	s0,144(sp)
    5452:	e526                	sd	s1,136(sp)
    5454:	e14a                	sd	s2,128(sp)
    5456:	fcce                	sd	s3,120(sp)
    5458:	f8d2                	sd	s4,112(sp)
    545a:	f4d6                	sd	s5,104(sp)
    545c:	f0da                	sd	s6,96(sp)
    545e:	ecde                	sd	s7,88(sp)
    5460:	e8e2                	sd	s8,80(sp)
    5462:	e4e6                	sd	s9,72(sp)
    5464:	e0ea                	sd	s10,64(sp)
    5466:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    5468:	00003517          	auipc	a0,0x3
    546c:	d5850513          	addi	a0,a0,-680 # 81c0 <malloc+0x2138>
    5470:	00001097          	auipc	ra,0x1
    5474:	b60080e7          	jalr	-1184(ra) # 5fd0 <printf>
  for(nfiles = 0; ; nfiles++){
    5478:	4481                	li	s1,0
    name[0] = 'f';
    547a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    547e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5482:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5486:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5488:	00003c97          	auipc	s9,0x3
    548c:	d48c8c93          	addi	s9,s9,-696 # 81d0 <malloc+0x2148>
    name[0] = 'f';
    5490:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5494:	0384c7bb          	divw	a5,s1,s8
    5498:	0307879b          	addiw	a5,a5,48
    549c:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    54a0:	0384e7bb          	remw	a5,s1,s8
    54a4:	0377c7bb          	divw	a5,a5,s7
    54a8:	0307879b          	addiw	a5,a5,48
    54ac:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    54b0:	0374e7bb          	remw	a5,s1,s7
    54b4:	0367c7bb          	divw	a5,a5,s6
    54b8:	0307879b          	addiw	a5,a5,48
    54bc:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    54c0:	0364e7bb          	remw	a5,s1,s6
    54c4:	0307879b          	addiw	a5,a5,48
    54c8:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    54cc:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    54d0:	f6040593          	addi	a1,s0,-160
    54d4:	8566                	mv	a0,s9
    54d6:	00001097          	auipc	ra,0x1
    54da:	afa080e7          	jalr	-1286(ra) # 5fd0 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    54de:	20200593          	li	a1,514
    54e2:	f6040513          	addi	a0,s0,-160
    54e6:	00000097          	auipc	ra,0x0
    54ea:	7ba080e7          	jalr	1978(ra) # 5ca0 <open>
    54ee:	892a                	mv	s2,a0
    if(fd < 0){
    54f0:	0a055563          	bgez	a0,559a <fsfull+0x14e>
      printf("open %s failed\n", name);
    54f4:	f6040593          	addi	a1,s0,-160
    54f8:	00003517          	auipc	a0,0x3
    54fc:	ce850513          	addi	a0,a0,-792 # 81e0 <malloc+0x2158>
    5500:	00001097          	auipc	ra,0x1
    5504:	ad0080e7          	jalr	-1328(ra) # 5fd0 <printf>
  while(nfiles >= 0){
    5508:	0604c363          	bltz	s1,556e <fsfull+0x122>
    name[0] = 'f';
    550c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5510:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5514:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5518:	4929                	li	s2,10
  while(nfiles >= 0){
    551a:	5afd                	li	s5,-1
    name[0] = 'f';
    551c:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5520:	0344c7bb          	divw	a5,s1,s4
    5524:	0307879b          	addiw	a5,a5,48
    5528:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    552c:	0344e7bb          	remw	a5,s1,s4
    5530:	0337c7bb          	divw	a5,a5,s3
    5534:	0307879b          	addiw	a5,a5,48
    5538:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    553c:	0334e7bb          	remw	a5,s1,s3
    5540:	0327c7bb          	divw	a5,a5,s2
    5544:	0307879b          	addiw	a5,a5,48
    5548:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    554c:	0324e7bb          	remw	a5,s1,s2
    5550:	0307879b          	addiw	a5,a5,48
    5554:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5558:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    555c:	f6040513          	addi	a0,s0,-160
    5560:	00000097          	auipc	ra,0x0
    5564:	750080e7          	jalr	1872(ra) # 5cb0 <unlink>
    nfiles--;
    5568:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    556a:	fb5499e3          	bne	s1,s5,551c <fsfull+0xd0>
  printf("fsfull test finished\n");
    556e:	00003517          	auipc	a0,0x3
    5572:	c9250513          	addi	a0,a0,-878 # 8200 <malloc+0x2178>
    5576:	00001097          	auipc	ra,0x1
    557a:	a5a080e7          	jalr	-1446(ra) # 5fd0 <printf>
}
    557e:	60ea                	ld	ra,152(sp)
    5580:	644a                	ld	s0,144(sp)
    5582:	64aa                	ld	s1,136(sp)
    5584:	690a                	ld	s2,128(sp)
    5586:	79e6                	ld	s3,120(sp)
    5588:	7a46                	ld	s4,112(sp)
    558a:	7aa6                	ld	s5,104(sp)
    558c:	7b06                	ld	s6,96(sp)
    558e:	6be6                	ld	s7,88(sp)
    5590:	6c46                	ld	s8,80(sp)
    5592:	6ca6                	ld	s9,72(sp)
    5594:	6d06                	ld	s10,64(sp)
    5596:	610d                	addi	sp,sp,160
    5598:	8082                	ret
    int total = 0;
    559a:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    559c:	00007a97          	auipc	s5,0x7
    55a0:	6dca8a93          	addi	s5,s5,1756 # cc78 <buf>
      if(cc < BSIZE)
    55a4:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    55a8:	40000613          	li	a2,1024
    55ac:	85d6                	mv	a1,s5
    55ae:	854a                	mv	a0,s2
    55b0:	00000097          	auipc	ra,0x0
    55b4:	6d0080e7          	jalr	1744(ra) # 5c80 <write>
      if(cc < BSIZE)
    55b8:	00aa5563          	bge	s4,a0,55c2 <fsfull+0x176>
      total += cc;
    55bc:	00a989bb          	addw	s3,s3,a0
    while(1){
    55c0:	b7e5                	j	55a8 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    55c2:	85ce                	mv	a1,s3
    55c4:	00003517          	auipc	a0,0x3
    55c8:	c2c50513          	addi	a0,a0,-980 # 81f0 <malloc+0x2168>
    55cc:	00001097          	auipc	ra,0x1
    55d0:	a04080e7          	jalr	-1532(ra) # 5fd0 <printf>
    close(fd);
    55d4:	854a                	mv	a0,s2
    55d6:	00000097          	auipc	ra,0x0
    55da:	6b2080e7          	jalr	1714(ra) # 5c88 <close>
    if(total == 0)
    55de:	f20985e3          	beqz	s3,5508 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    55e2:	2485                	addiw	s1,s1,1
    55e4:	b575                	j	5490 <fsfull+0x44>

00000000000055e6 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    55e6:	7179                	addi	sp,sp,-48
    55e8:	f406                	sd	ra,40(sp)
    55ea:	f022                	sd	s0,32(sp)
    55ec:	ec26                	sd	s1,24(sp)
    55ee:	e84a                	sd	s2,16(sp)
    55f0:	1800                	addi	s0,sp,48
    55f2:	84aa                	mv	s1,a0
    55f4:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    55f6:	00003517          	auipc	a0,0x3
    55fa:	c2250513          	addi	a0,a0,-990 # 8218 <malloc+0x2190>
    55fe:	00001097          	auipc	ra,0x1
    5602:	9d2080e7          	jalr	-1582(ra) # 5fd0 <printf>
  if((pid = fork()) < 0) {
    5606:	00000097          	auipc	ra,0x0
    560a:	652080e7          	jalr	1618(ra) # 5c58 <fork>
    560e:	02054e63          	bltz	a0,564a <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5612:	c929                	beqz	a0,5664 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5614:	fdc40513          	addi	a0,s0,-36
    5618:	00000097          	auipc	ra,0x0
    561c:	650080e7          	jalr	1616(ra) # 5c68 <wait>
    if(xstatus != 0) 
    5620:	fdc42783          	lw	a5,-36(s0)
    5624:	c7b9                	beqz	a5,5672 <run+0x8c>
      printf("FAILED\n");
    5626:	00003517          	auipc	a0,0x3
    562a:	c1a50513          	addi	a0,a0,-998 # 8240 <malloc+0x21b8>
    562e:	00001097          	auipc	ra,0x1
    5632:	9a2080e7          	jalr	-1630(ra) # 5fd0 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5636:	fdc42503          	lw	a0,-36(s0)
  }
}
    563a:	00153513          	seqz	a0,a0
    563e:	70a2                	ld	ra,40(sp)
    5640:	7402                	ld	s0,32(sp)
    5642:	64e2                	ld	s1,24(sp)
    5644:	6942                	ld	s2,16(sp)
    5646:	6145                	addi	sp,sp,48
    5648:	8082                	ret
    printf("runtest: fork error\n");
    564a:	00003517          	auipc	a0,0x3
    564e:	bde50513          	addi	a0,a0,-1058 # 8228 <malloc+0x21a0>
    5652:	00001097          	auipc	ra,0x1
    5656:	97e080e7          	jalr	-1666(ra) # 5fd0 <printf>
    exit(1);
    565a:	4505                	li	a0,1
    565c:	00000097          	auipc	ra,0x0
    5660:	604080e7          	jalr	1540(ra) # 5c60 <exit>
    f(s);
    5664:	854a                	mv	a0,s2
    5666:	9482                	jalr	s1
    exit(0);
    5668:	4501                	li	a0,0
    566a:	00000097          	auipc	ra,0x0
    566e:	5f6080e7          	jalr	1526(ra) # 5c60 <exit>
      printf("OK\n");
    5672:	00003517          	auipc	a0,0x3
    5676:	bd650513          	addi	a0,a0,-1066 # 8248 <malloc+0x21c0>
    567a:	00001097          	auipc	ra,0x1
    567e:	956080e7          	jalr	-1706(ra) # 5fd0 <printf>
    5682:	bf55                	j	5636 <run+0x50>

0000000000005684 <runtests>:

int
runtests(struct test *tests, char *justone) {
    5684:	1101                	addi	sp,sp,-32
    5686:	ec06                	sd	ra,24(sp)
    5688:	e822                	sd	s0,16(sp)
    568a:	e426                	sd	s1,8(sp)
    568c:	e04a                	sd	s2,0(sp)
    568e:	1000                	addi	s0,sp,32
    5690:	84aa                	mv	s1,a0
    5692:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    5694:	6508                	ld	a0,8(a0)
    5696:	ed09                	bnez	a0,56b0 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    5698:	4501                	li	a0,0
    569a:	a82d                	j	56d4 <runtests+0x50>
      if(!run(t->f, t->s)){
    569c:	648c                	ld	a1,8(s1)
    569e:	6088                	ld	a0,0(s1)
    56a0:	00000097          	auipc	ra,0x0
    56a4:	f46080e7          	jalr	-186(ra) # 55e6 <run>
    56a8:	cd09                	beqz	a0,56c2 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    56aa:	04c1                	addi	s1,s1,16
    56ac:	6488                	ld	a0,8(s1)
    56ae:	c11d                	beqz	a0,56d4 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    56b0:	fe0906e3          	beqz	s2,569c <runtests+0x18>
    56b4:	85ca                	mv	a1,s2
    56b6:	00000097          	auipc	ra,0x0
    56ba:	35a080e7          	jalr	858(ra) # 5a10 <strcmp>
    56be:	f575                	bnez	a0,56aa <runtests+0x26>
    56c0:	bff1                	j	569c <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    56c2:	00003517          	auipc	a0,0x3
    56c6:	b8e50513          	addi	a0,a0,-1138 # 8250 <malloc+0x21c8>
    56ca:	00001097          	auipc	ra,0x1
    56ce:	906080e7          	jalr	-1786(ra) # 5fd0 <printf>
        return 1;
    56d2:	4505                	li	a0,1
}
    56d4:	60e2                	ld	ra,24(sp)
    56d6:	6442                	ld	s0,16(sp)
    56d8:	64a2                	ld	s1,8(sp)
    56da:	6902                	ld	s2,0(sp)
    56dc:	6105                	addi	sp,sp,32
    56de:	8082                	ret

00000000000056e0 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    56e0:	7139                	addi	sp,sp,-64
    56e2:	fc06                	sd	ra,56(sp)
    56e4:	f822                	sd	s0,48(sp)
    56e6:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    56e8:	fc840513          	addi	a0,s0,-56
    56ec:	00000097          	auipc	ra,0x0
    56f0:	584080e7          	jalr	1412(ra) # 5c70 <pipe>
    56f4:	06054a63          	bltz	a0,5768 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    56f8:	00000097          	auipc	ra,0x0
    56fc:	560080e7          	jalr	1376(ra) # 5c58 <fork>

  if(pid < 0){
    5700:	08054463          	bltz	a0,5788 <countfree+0xa8>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5704:	e55d                	bnez	a0,57b2 <countfree+0xd2>
    5706:	f426                	sd	s1,40(sp)
    5708:	f04a                	sd	s2,32(sp)
    570a:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    570c:	fc842503          	lw	a0,-56(s0)
    5710:	00000097          	auipc	ra,0x0
    5714:	578080e7          	jalr	1400(ra) # 5c88 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5718:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    571a:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    571c:	00001997          	auipc	s3,0x1
    5720:	b1c98993          	addi	s3,s3,-1252 # 6238 <malloc+0x1b0>
      uint64 a = (uint64) sbrk(4096);
    5724:	6505                	lui	a0,0x1
    5726:	00000097          	auipc	ra,0x0
    572a:	5c2080e7          	jalr	1474(ra) # 5ce8 <sbrk>
      if(a == 0xffffffffffffffff){
    572e:	07250d63          	beq	a0,s2,57a8 <countfree+0xc8>
      *(char *)(a + 4096 - 1) = 1;
    5732:	6785                	lui	a5,0x1
    5734:	97aa                	add	a5,a5,a0
    5736:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x10b>
      if(write(fds[1], "x", 1) != 1){
    573a:	8626                	mv	a2,s1
    573c:	85ce                	mv	a1,s3
    573e:	fcc42503          	lw	a0,-52(s0)
    5742:	00000097          	auipc	ra,0x0
    5746:	53e080e7          	jalr	1342(ra) # 5c80 <write>
    574a:	fc950de3          	beq	a0,s1,5724 <countfree+0x44>
        printf("write() failed in countfree()\n");
    574e:	00003517          	auipc	a0,0x3
    5752:	b5a50513          	addi	a0,a0,-1190 # 82a8 <malloc+0x2220>
    5756:	00001097          	auipc	ra,0x1
    575a:	87a080e7          	jalr	-1926(ra) # 5fd0 <printf>
        exit(1);
    575e:	4505                	li	a0,1
    5760:	00000097          	auipc	ra,0x0
    5764:	500080e7          	jalr	1280(ra) # 5c60 <exit>
    5768:	f426                	sd	s1,40(sp)
    576a:	f04a                	sd	s2,32(sp)
    576c:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    576e:	00003517          	auipc	a0,0x3
    5772:	afa50513          	addi	a0,a0,-1286 # 8268 <malloc+0x21e0>
    5776:	00001097          	auipc	ra,0x1
    577a:	85a080e7          	jalr	-1958(ra) # 5fd0 <printf>
    exit(1);
    577e:	4505                	li	a0,1
    5780:	00000097          	auipc	ra,0x0
    5784:	4e0080e7          	jalr	1248(ra) # 5c60 <exit>
    5788:	f426                	sd	s1,40(sp)
    578a:	f04a                	sd	s2,32(sp)
    578c:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    578e:	00003517          	auipc	a0,0x3
    5792:	afa50513          	addi	a0,a0,-1286 # 8288 <malloc+0x2200>
    5796:	00001097          	auipc	ra,0x1
    579a:	83a080e7          	jalr	-1990(ra) # 5fd0 <printf>
    exit(1);
    579e:	4505                	li	a0,1
    57a0:	00000097          	auipc	ra,0x0
    57a4:	4c0080e7          	jalr	1216(ra) # 5c60 <exit>
      }
    }

    exit(0);
    57a8:	4501                	li	a0,0
    57aa:	00000097          	auipc	ra,0x0
    57ae:	4b6080e7          	jalr	1206(ra) # 5c60 <exit>
    57b2:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    57b4:	fcc42503          	lw	a0,-52(s0)
    57b8:	00000097          	auipc	ra,0x0
    57bc:	4d0080e7          	jalr	1232(ra) # 5c88 <close>

  int n = 0;
    57c0:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    57c2:	4605                	li	a2,1
    57c4:	fc740593          	addi	a1,s0,-57
    57c8:	fc842503          	lw	a0,-56(s0)
    57cc:	00000097          	auipc	ra,0x0
    57d0:	4ac080e7          	jalr	1196(ra) # 5c78 <read>
    if(cc < 0){
    57d4:	00054563          	bltz	a0,57de <countfree+0xfe>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    57d8:	c115                	beqz	a0,57fc <countfree+0x11c>
      break;
    n += 1;
    57da:	2485                	addiw	s1,s1,1
  while(1){
    57dc:	b7dd                	j	57c2 <countfree+0xe2>
    57de:	f04a                	sd	s2,32(sp)
    57e0:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    57e2:	00003517          	auipc	a0,0x3
    57e6:	ae650513          	addi	a0,a0,-1306 # 82c8 <malloc+0x2240>
    57ea:	00000097          	auipc	ra,0x0
    57ee:	7e6080e7          	jalr	2022(ra) # 5fd0 <printf>
      exit(1);
    57f2:	4505                	li	a0,1
    57f4:	00000097          	auipc	ra,0x0
    57f8:	46c080e7          	jalr	1132(ra) # 5c60 <exit>
  }

  close(fds[0]);
    57fc:	fc842503          	lw	a0,-56(s0)
    5800:	00000097          	auipc	ra,0x0
    5804:	488080e7          	jalr	1160(ra) # 5c88 <close>
  wait((int*)0);
    5808:	4501                	li	a0,0
    580a:	00000097          	auipc	ra,0x0
    580e:	45e080e7          	jalr	1118(ra) # 5c68 <wait>
  
  return n;
}
    5812:	8526                	mv	a0,s1
    5814:	74a2                	ld	s1,40(sp)
    5816:	70e2                	ld	ra,56(sp)
    5818:	7442                	ld	s0,48(sp)
    581a:	6121                	addi	sp,sp,64
    581c:	8082                	ret

000000000000581e <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    581e:	711d                	addi	sp,sp,-96
    5820:	ec86                	sd	ra,88(sp)
    5822:	e8a2                	sd	s0,80(sp)
    5824:	e4a6                	sd	s1,72(sp)
    5826:	e0ca                	sd	s2,64(sp)
    5828:	fc4e                	sd	s3,56(sp)
    582a:	f852                	sd	s4,48(sp)
    582c:	f456                	sd	s5,40(sp)
    582e:	f05a                	sd	s6,32(sp)
    5830:	ec5e                	sd	s7,24(sp)
    5832:	e862                	sd	s8,16(sp)
    5834:	e466                	sd	s9,8(sp)
    5836:	e06a                	sd	s10,0(sp)
    5838:	1080                	addi	s0,sp,96
    583a:	8aaa                	mv	s5,a0
    583c:	89ae                	mv	s3,a1
    583e:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    5840:	00003b97          	auipc	s7,0x3
    5844:	aa8b8b93          	addi	s7,s7,-1368 # 82e8 <malloc+0x2260>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5848:	00003b17          	auipc	s6,0x3
    584c:	7c8b0b13          	addi	s6,s6,1992 # 9010 <quicktests>
      if(continuous != 2) {
    5850:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    5852:	00004c17          	auipc	s8,0x4
    5856:	b8ec0c13          	addi	s8,s8,-1138 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    585a:	00003d17          	auipc	s10,0x3
    585e:	aa6d0d13          	addi	s10,s10,-1370 # 8300 <malloc+0x2278>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5862:	00003c97          	auipc	s9,0x3
    5866:	abec8c93          	addi	s9,s9,-1346 # 8320 <malloc+0x2298>
    586a:	a839                	j	5888 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    586c:	856a                	mv	a0,s10
    586e:	00000097          	auipc	ra,0x0
    5872:	762080e7          	jalr	1890(ra) # 5fd0 <printf>
    5876:	a081                	j	58b6 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    5878:	00000097          	auipc	ra,0x0
    587c:	e68080e7          	jalr	-408(ra) # 56e0 <countfree>
    5880:	04954663          	blt	a0,s1,58cc <drivetests+0xae>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    5884:	06098163          	beqz	s3,58e6 <drivetests+0xc8>
    printf("usertests starting\n");
    5888:	855e                	mv	a0,s7
    588a:	00000097          	auipc	ra,0x0
    588e:	746080e7          	jalr	1862(ra) # 5fd0 <printf>
    int free0 = countfree();
    5892:	00000097          	auipc	ra,0x0
    5896:	e4e080e7          	jalr	-434(ra) # 56e0 <countfree>
    589a:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    589c:	85ca                	mv	a1,s2
    589e:	855a                	mv	a0,s6
    58a0:	00000097          	auipc	ra,0x0
    58a4:	de4080e7          	jalr	-540(ra) # 5684 <runtests>
    58a8:	c119                	beqz	a0,58ae <drivetests+0x90>
      if(continuous != 2) {
    58aa:	03499c63          	bne	s3,s4,58e2 <drivetests+0xc4>
    if(!quick) {
    58ae:	fc0a95e3          	bnez	s5,5878 <drivetests+0x5a>
      if (justone == 0)
    58b2:	fa090de3          	beqz	s2,586c <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    58b6:	85ca                	mv	a1,s2
    58b8:	8562                	mv	a0,s8
    58ba:	00000097          	auipc	ra,0x0
    58be:	dca080e7          	jalr	-566(ra) # 5684 <runtests>
    58c2:	d95d                	beqz	a0,5878 <drivetests+0x5a>
        if(continuous != 2) {
    58c4:	fb498ae3          	beq	s3,s4,5878 <drivetests+0x5a>
          return 1;
    58c8:	4505                	li	a0,1
    58ca:	a839                	j	58e8 <drivetests+0xca>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    58cc:	8626                	mv	a2,s1
    58ce:	85aa                	mv	a1,a0
    58d0:	8566                	mv	a0,s9
    58d2:	00000097          	auipc	ra,0x0
    58d6:	6fe080e7          	jalr	1790(ra) # 5fd0 <printf>
      if(continuous != 2) {
    58da:	fb4987e3          	beq	s3,s4,5888 <drivetests+0x6a>
        return 1;
    58de:	4505                	li	a0,1
    58e0:	a021                	j	58e8 <drivetests+0xca>
        return 1;
    58e2:	4505                	li	a0,1
    58e4:	a011                	j	58e8 <drivetests+0xca>
  return 0;
    58e6:	854e                	mv	a0,s3
}
    58e8:	60e6                	ld	ra,88(sp)
    58ea:	6446                	ld	s0,80(sp)
    58ec:	64a6                	ld	s1,72(sp)
    58ee:	6906                	ld	s2,64(sp)
    58f0:	79e2                	ld	s3,56(sp)
    58f2:	7a42                	ld	s4,48(sp)
    58f4:	7aa2                	ld	s5,40(sp)
    58f6:	7b02                	ld	s6,32(sp)
    58f8:	6be2                	ld	s7,24(sp)
    58fa:	6c42                	ld	s8,16(sp)
    58fc:	6ca2                	ld	s9,8(sp)
    58fe:	6d02                	ld	s10,0(sp)
    5900:	6125                	addi	sp,sp,96
    5902:	8082                	ret

0000000000005904 <main>:

int
main(int argc, char *argv[])
{
    5904:	1101                	addi	sp,sp,-32
    5906:	ec06                	sd	ra,24(sp)
    5908:	e822                	sd	s0,16(sp)
    590a:	e426                	sd	s1,8(sp)
    590c:	e04a                	sd	s2,0(sp)
    590e:	1000                	addi	s0,sp,32
    5910:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5912:	4789                	li	a5,2
    5914:	02f50263          	beq	a0,a5,5938 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5918:	4785                	li	a5,1
    591a:	08a7c063          	blt	a5,a0,599a <main+0x96>
  char *justone = 0;
    591e:	4601                	li	a2,0
  int quick = 0;
    5920:	4501                	li	a0,0
  int continuous = 0;
    5922:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5924:	00000097          	auipc	ra,0x0
    5928:	efa080e7          	jalr	-262(ra) # 581e <drivetests>
    592c:	c951                	beqz	a0,59c0 <main+0xbc>
    exit(1);
    592e:	4505                	li	a0,1
    5930:	00000097          	auipc	ra,0x0
    5934:	330080e7          	jalr	816(ra) # 5c60 <exit>
    5938:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    593a:	00003597          	auipc	a1,0x3
    593e:	a1658593          	addi	a1,a1,-1514 # 8350 <malloc+0x22c8>
    5942:	00893503          	ld	a0,8(s2)
    5946:	00000097          	auipc	ra,0x0
    594a:	0ca080e7          	jalr	202(ra) # 5a10 <strcmp>
    594e:	85aa                	mv	a1,a0
    5950:	e501                	bnez	a0,5958 <main+0x54>
  char *justone = 0;
    5952:	4601                	li	a2,0
    quick = 1;
    5954:	4505                	li	a0,1
    5956:	b7f9                	j	5924 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5958:	00003597          	auipc	a1,0x3
    595c:	a0058593          	addi	a1,a1,-1536 # 8358 <malloc+0x22d0>
    5960:	00893503          	ld	a0,8(s2)
    5964:	00000097          	auipc	ra,0x0
    5968:	0ac080e7          	jalr	172(ra) # 5a10 <strcmp>
    596c:	c521                	beqz	a0,59b4 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    596e:	00003597          	auipc	a1,0x3
    5972:	a3a58593          	addi	a1,a1,-1478 # 83a8 <malloc+0x2320>
    5976:	00893503          	ld	a0,8(s2)
    597a:	00000097          	auipc	ra,0x0
    597e:	096080e7          	jalr	150(ra) # 5a10 <strcmp>
    5982:	cd05                	beqz	a0,59ba <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    5984:	00893603          	ld	a2,8(s2)
    5988:	00064703          	lbu	a4,0(a2) # 3000 <sbrk8000+0x24>
    598c:	02d00793          	li	a5,45
    5990:	00f70563          	beq	a4,a5,599a <main+0x96>
  int quick = 0;
    5994:	4501                	li	a0,0
  int continuous = 0;
    5996:	4581                	li	a1,0
    5998:	b771                	j	5924 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    599a:	00003517          	auipc	a0,0x3
    599e:	9c650513          	addi	a0,a0,-1594 # 8360 <malloc+0x22d8>
    59a2:	00000097          	auipc	ra,0x0
    59a6:	62e080e7          	jalr	1582(ra) # 5fd0 <printf>
    exit(1);
    59aa:	4505                	li	a0,1
    59ac:	00000097          	auipc	ra,0x0
    59b0:	2b4080e7          	jalr	692(ra) # 5c60 <exit>
  char *justone = 0;
    59b4:	4601                	li	a2,0
    continuous = 1;
    59b6:	4585                	li	a1,1
    59b8:	b7b5                	j	5924 <main+0x20>
    continuous = 2;
    59ba:	85a6                	mv	a1,s1
  char *justone = 0;
    59bc:	4601                	li	a2,0
    59be:	b79d                	j	5924 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    59c0:	00003517          	auipc	a0,0x3
    59c4:	9d050513          	addi	a0,a0,-1584 # 8390 <malloc+0x2308>
    59c8:	00000097          	auipc	ra,0x0
    59cc:	608080e7          	jalr	1544(ra) # 5fd0 <printf>
  exit(0);
    59d0:	4501                	li	a0,0
    59d2:	00000097          	auipc	ra,0x0
    59d6:	28e080e7          	jalr	654(ra) # 5c60 <exit>

00000000000059da <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    59da:	1141                	addi	sp,sp,-16
    59dc:	e406                	sd	ra,8(sp)
    59de:	e022                	sd	s0,0(sp)
    59e0:	0800                	addi	s0,sp,16
  extern int main();
  main();
    59e2:	00000097          	auipc	ra,0x0
    59e6:	f22080e7          	jalr	-222(ra) # 5904 <main>
  exit(0);
    59ea:	4501                	li	a0,0
    59ec:	00000097          	auipc	ra,0x0
    59f0:	274080e7          	jalr	628(ra) # 5c60 <exit>

00000000000059f4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    59f4:	1141                	addi	sp,sp,-16
    59f6:	e422                	sd	s0,8(sp)
    59f8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    59fa:	87aa                	mv	a5,a0
    59fc:	0585                	addi	a1,a1,1
    59fe:	0785                	addi	a5,a5,1
    5a00:	fff5c703          	lbu	a4,-1(a1)
    5a04:	fee78fa3          	sb	a4,-1(a5)
    5a08:	fb75                	bnez	a4,59fc <strcpy+0x8>
    ;
  return os;
}
    5a0a:	6422                	ld	s0,8(sp)
    5a0c:	0141                	addi	sp,sp,16
    5a0e:	8082                	ret

0000000000005a10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5a10:	1141                	addi	sp,sp,-16
    5a12:	e422                	sd	s0,8(sp)
    5a14:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5a16:	00054783          	lbu	a5,0(a0)
    5a1a:	cb91                	beqz	a5,5a2e <strcmp+0x1e>
    5a1c:	0005c703          	lbu	a4,0(a1)
    5a20:	00f71763          	bne	a4,a5,5a2e <strcmp+0x1e>
    p++, q++;
    5a24:	0505                	addi	a0,a0,1
    5a26:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5a28:	00054783          	lbu	a5,0(a0)
    5a2c:	fbe5                	bnez	a5,5a1c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5a2e:	0005c503          	lbu	a0,0(a1)
}
    5a32:	40a7853b          	subw	a0,a5,a0
    5a36:	6422                	ld	s0,8(sp)
    5a38:	0141                	addi	sp,sp,16
    5a3a:	8082                	ret

0000000000005a3c <strlen>:

uint
strlen(const char *s)
{
    5a3c:	1141                	addi	sp,sp,-16
    5a3e:	e422                	sd	s0,8(sp)
    5a40:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5a42:	00054783          	lbu	a5,0(a0)
    5a46:	cf91                	beqz	a5,5a62 <strlen+0x26>
    5a48:	0505                	addi	a0,a0,1
    5a4a:	87aa                	mv	a5,a0
    5a4c:	86be                	mv	a3,a5
    5a4e:	0785                	addi	a5,a5,1
    5a50:	fff7c703          	lbu	a4,-1(a5)
    5a54:	ff65                	bnez	a4,5a4c <strlen+0x10>
    5a56:	40a6853b          	subw	a0,a3,a0
    5a5a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    5a5c:	6422                	ld	s0,8(sp)
    5a5e:	0141                	addi	sp,sp,16
    5a60:	8082                	ret
  for(n = 0; s[n]; n++)
    5a62:	4501                	li	a0,0
    5a64:	bfe5                	j	5a5c <strlen+0x20>

0000000000005a66 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5a66:	1141                	addi	sp,sp,-16
    5a68:	e422                	sd	s0,8(sp)
    5a6a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5a6c:	ca19                	beqz	a2,5a82 <memset+0x1c>
    5a6e:	87aa                	mv	a5,a0
    5a70:	1602                	slli	a2,a2,0x20
    5a72:	9201                	srli	a2,a2,0x20
    5a74:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5a78:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5a7c:	0785                	addi	a5,a5,1
    5a7e:	fee79de3          	bne	a5,a4,5a78 <memset+0x12>
  }
  return dst;
}
    5a82:	6422                	ld	s0,8(sp)
    5a84:	0141                	addi	sp,sp,16
    5a86:	8082                	ret

0000000000005a88 <strchr>:

char*
strchr(const char *s, char c)
{
    5a88:	1141                	addi	sp,sp,-16
    5a8a:	e422                	sd	s0,8(sp)
    5a8c:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5a8e:	00054783          	lbu	a5,0(a0)
    5a92:	cb99                	beqz	a5,5aa8 <strchr+0x20>
    if(*s == c)
    5a94:	00f58763          	beq	a1,a5,5aa2 <strchr+0x1a>
  for(; *s; s++)
    5a98:	0505                	addi	a0,a0,1
    5a9a:	00054783          	lbu	a5,0(a0)
    5a9e:	fbfd                	bnez	a5,5a94 <strchr+0xc>
      return (char*)s;
  return 0;
    5aa0:	4501                	li	a0,0
}
    5aa2:	6422                	ld	s0,8(sp)
    5aa4:	0141                	addi	sp,sp,16
    5aa6:	8082                	ret
  return 0;
    5aa8:	4501                	li	a0,0
    5aaa:	bfe5                	j	5aa2 <strchr+0x1a>

0000000000005aac <gets>:

char*
gets(char *buf, int max)
{
    5aac:	711d                	addi	sp,sp,-96
    5aae:	ec86                	sd	ra,88(sp)
    5ab0:	e8a2                	sd	s0,80(sp)
    5ab2:	e4a6                	sd	s1,72(sp)
    5ab4:	e0ca                	sd	s2,64(sp)
    5ab6:	fc4e                	sd	s3,56(sp)
    5ab8:	f852                	sd	s4,48(sp)
    5aba:	f456                	sd	s5,40(sp)
    5abc:	f05a                	sd	s6,32(sp)
    5abe:	ec5e                	sd	s7,24(sp)
    5ac0:	1080                	addi	s0,sp,96
    5ac2:	8baa                	mv	s7,a0
    5ac4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5ac6:	892a                	mv	s2,a0
    5ac8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5aca:	4aa9                	li	s5,10
    5acc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5ace:	89a6                	mv	s3,s1
    5ad0:	2485                	addiw	s1,s1,1
    5ad2:	0344d863          	bge	s1,s4,5b02 <gets+0x56>
    cc = read(0, &c, 1);
    5ad6:	4605                	li	a2,1
    5ad8:	faf40593          	addi	a1,s0,-81
    5adc:	4501                	li	a0,0
    5ade:	00000097          	auipc	ra,0x0
    5ae2:	19a080e7          	jalr	410(ra) # 5c78 <read>
    if(cc < 1)
    5ae6:	00a05e63          	blez	a0,5b02 <gets+0x56>
    buf[i++] = c;
    5aea:	faf44783          	lbu	a5,-81(s0)
    5aee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5af2:	01578763          	beq	a5,s5,5b00 <gets+0x54>
    5af6:	0905                	addi	s2,s2,1
    5af8:	fd679be3          	bne	a5,s6,5ace <gets+0x22>
    buf[i++] = c;
    5afc:	89a6                	mv	s3,s1
    5afe:	a011                	j	5b02 <gets+0x56>
    5b00:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5b02:	99de                	add	s3,s3,s7
    5b04:	00098023          	sb	zero,0(s3)
  return buf;
}
    5b08:	855e                	mv	a0,s7
    5b0a:	60e6                	ld	ra,88(sp)
    5b0c:	6446                	ld	s0,80(sp)
    5b0e:	64a6                	ld	s1,72(sp)
    5b10:	6906                	ld	s2,64(sp)
    5b12:	79e2                	ld	s3,56(sp)
    5b14:	7a42                	ld	s4,48(sp)
    5b16:	7aa2                	ld	s5,40(sp)
    5b18:	7b02                	ld	s6,32(sp)
    5b1a:	6be2                	ld	s7,24(sp)
    5b1c:	6125                	addi	sp,sp,96
    5b1e:	8082                	ret

0000000000005b20 <stat>:

int
stat(const char *n, struct stat *st)
{
    5b20:	1101                	addi	sp,sp,-32
    5b22:	ec06                	sd	ra,24(sp)
    5b24:	e822                	sd	s0,16(sp)
    5b26:	e04a                	sd	s2,0(sp)
    5b28:	1000                	addi	s0,sp,32
    5b2a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5b2c:	4581                	li	a1,0
    5b2e:	00000097          	auipc	ra,0x0
    5b32:	172080e7          	jalr	370(ra) # 5ca0 <open>
  if(fd < 0)
    5b36:	02054663          	bltz	a0,5b62 <stat+0x42>
    5b3a:	e426                	sd	s1,8(sp)
    5b3c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5b3e:	85ca                	mv	a1,s2
    5b40:	00000097          	auipc	ra,0x0
    5b44:	178080e7          	jalr	376(ra) # 5cb8 <fstat>
    5b48:	892a                	mv	s2,a0
  close(fd);
    5b4a:	8526                	mv	a0,s1
    5b4c:	00000097          	auipc	ra,0x0
    5b50:	13c080e7          	jalr	316(ra) # 5c88 <close>
  return r;
    5b54:	64a2                	ld	s1,8(sp)
}
    5b56:	854a                	mv	a0,s2
    5b58:	60e2                	ld	ra,24(sp)
    5b5a:	6442                	ld	s0,16(sp)
    5b5c:	6902                	ld	s2,0(sp)
    5b5e:	6105                	addi	sp,sp,32
    5b60:	8082                	ret
    return -1;
    5b62:	597d                	li	s2,-1
    5b64:	bfcd                	j	5b56 <stat+0x36>

0000000000005b66 <atoi>:

int
atoi(const char *s)
{
    5b66:	1141                	addi	sp,sp,-16
    5b68:	e422                	sd	s0,8(sp)
    5b6a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5b6c:	00054683          	lbu	a3,0(a0)
    5b70:	fd06879b          	addiw	a5,a3,-48
    5b74:	0ff7f793          	zext.b	a5,a5
    5b78:	4625                	li	a2,9
    5b7a:	02f66863          	bltu	a2,a5,5baa <atoi+0x44>
    5b7e:	872a                	mv	a4,a0
  n = 0;
    5b80:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5b82:	0705                	addi	a4,a4,1
    5b84:	0025179b          	slliw	a5,a0,0x2
    5b88:	9fa9                	addw	a5,a5,a0
    5b8a:	0017979b          	slliw	a5,a5,0x1
    5b8e:	9fb5                	addw	a5,a5,a3
    5b90:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5b94:	00074683          	lbu	a3,0(a4)
    5b98:	fd06879b          	addiw	a5,a3,-48
    5b9c:	0ff7f793          	zext.b	a5,a5
    5ba0:	fef671e3          	bgeu	a2,a5,5b82 <atoi+0x1c>
  return n;
}
    5ba4:	6422                	ld	s0,8(sp)
    5ba6:	0141                	addi	sp,sp,16
    5ba8:	8082                	ret
  n = 0;
    5baa:	4501                	li	a0,0
    5bac:	bfe5                	j	5ba4 <atoi+0x3e>

0000000000005bae <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5bae:	1141                	addi	sp,sp,-16
    5bb0:	e422                	sd	s0,8(sp)
    5bb2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5bb4:	02b57463          	bgeu	a0,a1,5bdc <memmove+0x2e>
    while(n-- > 0)
    5bb8:	00c05f63          	blez	a2,5bd6 <memmove+0x28>
    5bbc:	1602                	slli	a2,a2,0x20
    5bbe:	9201                	srli	a2,a2,0x20
    5bc0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5bc4:	872a                	mv	a4,a0
      *dst++ = *src++;
    5bc6:	0585                	addi	a1,a1,1
    5bc8:	0705                	addi	a4,a4,1
    5bca:	fff5c683          	lbu	a3,-1(a1)
    5bce:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5bd2:	fef71ae3          	bne	a4,a5,5bc6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5bd6:	6422                	ld	s0,8(sp)
    5bd8:	0141                	addi	sp,sp,16
    5bda:	8082                	ret
    dst += n;
    5bdc:	00c50733          	add	a4,a0,a2
    src += n;
    5be0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5be2:	fec05ae3          	blez	a2,5bd6 <memmove+0x28>
    5be6:	fff6079b          	addiw	a5,a2,-1
    5bea:	1782                	slli	a5,a5,0x20
    5bec:	9381                	srli	a5,a5,0x20
    5bee:	fff7c793          	not	a5,a5
    5bf2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5bf4:	15fd                	addi	a1,a1,-1
    5bf6:	177d                	addi	a4,a4,-1
    5bf8:	0005c683          	lbu	a3,0(a1)
    5bfc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5c00:	fee79ae3          	bne	a5,a4,5bf4 <memmove+0x46>
    5c04:	bfc9                	j	5bd6 <memmove+0x28>

0000000000005c06 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5c06:	1141                	addi	sp,sp,-16
    5c08:	e422                	sd	s0,8(sp)
    5c0a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5c0c:	ca05                	beqz	a2,5c3c <memcmp+0x36>
    5c0e:	fff6069b          	addiw	a3,a2,-1
    5c12:	1682                	slli	a3,a3,0x20
    5c14:	9281                	srli	a3,a3,0x20
    5c16:	0685                	addi	a3,a3,1
    5c18:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5c1a:	00054783          	lbu	a5,0(a0)
    5c1e:	0005c703          	lbu	a4,0(a1)
    5c22:	00e79863          	bne	a5,a4,5c32 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5c26:	0505                	addi	a0,a0,1
    p2++;
    5c28:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5c2a:	fed518e3          	bne	a0,a3,5c1a <memcmp+0x14>
  }
  return 0;
    5c2e:	4501                	li	a0,0
    5c30:	a019                	j	5c36 <memcmp+0x30>
      return *p1 - *p2;
    5c32:	40e7853b          	subw	a0,a5,a4
}
    5c36:	6422                	ld	s0,8(sp)
    5c38:	0141                	addi	sp,sp,16
    5c3a:	8082                	ret
  return 0;
    5c3c:	4501                	li	a0,0
    5c3e:	bfe5                	j	5c36 <memcmp+0x30>

0000000000005c40 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5c40:	1141                	addi	sp,sp,-16
    5c42:	e406                	sd	ra,8(sp)
    5c44:	e022                	sd	s0,0(sp)
    5c46:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5c48:	00000097          	auipc	ra,0x0
    5c4c:	f66080e7          	jalr	-154(ra) # 5bae <memmove>
}
    5c50:	60a2                	ld	ra,8(sp)
    5c52:	6402                	ld	s0,0(sp)
    5c54:	0141                	addi	sp,sp,16
    5c56:	8082                	ret

0000000000005c58 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5c58:	4885                	li	a7,1
 ecall
    5c5a:	00000073          	ecall
 ret
    5c5e:	8082                	ret

0000000000005c60 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5c60:	4889                	li	a7,2
 ecall
    5c62:	00000073          	ecall
 ret
    5c66:	8082                	ret

0000000000005c68 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5c68:	488d                	li	a7,3
 ecall
    5c6a:	00000073          	ecall
 ret
    5c6e:	8082                	ret

0000000000005c70 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5c70:	4891                	li	a7,4
 ecall
    5c72:	00000073          	ecall
 ret
    5c76:	8082                	ret

0000000000005c78 <read>:
.global read
read:
 li a7, SYS_read
    5c78:	4895                	li	a7,5
 ecall
    5c7a:	00000073          	ecall
 ret
    5c7e:	8082                	ret

0000000000005c80 <write>:
.global write
write:
 li a7, SYS_write
    5c80:	48c1                	li	a7,16
 ecall
    5c82:	00000073          	ecall
 ret
    5c86:	8082                	ret

0000000000005c88 <close>:
.global close
close:
 li a7, SYS_close
    5c88:	48d5                	li	a7,21
 ecall
    5c8a:	00000073          	ecall
 ret
    5c8e:	8082                	ret

0000000000005c90 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c90:	4899                	li	a7,6
 ecall
    5c92:	00000073          	ecall
 ret
    5c96:	8082                	ret

0000000000005c98 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c98:	489d                	li	a7,7
 ecall
    5c9a:	00000073          	ecall
 ret
    5c9e:	8082                	ret

0000000000005ca0 <open>:
.global open
open:
 li a7, SYS_open
    5ca0:	48bd                	li	a7,15
 ecall
    5ca2:	00000073          	ecall
 ret
    5ca6:	8082                	ret

0000000000005ca8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5ca8:	48c5                	li	a7,17
 ecall
    5caa:	00000073          	ecall
 ret
    5cae:	8082                	ret

0000000000005cb0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5cb0:	48c9                	li	a7,18
 ecall
    5cb2:	00000073          	ecall
 ret
    5cb6:	8082                	ret

0000000000005cb8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5cb8:	48a1                	li	a7,8
 ecall
    5cba:	00000073          	ecall
 ret
    5cbe:	8082                	ret

0000000000005cc0 <link>:
.global link
link:
 li a7, SYS_link
    5cc0:	48cd                	li	a7,19
 ecall
    5cc2:	00000073          	ecall
 ret
    5cc6:	8082                	ret

0000000000005cc8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5cc8:	48d1                	li	a7,20
 ecall
    5cca:	00000073          	ecall
 ret
    5cce:	8082                	ret

0000000000005cd0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5cd0:	48a5                	li	a7,9
 ecall
    5cd2:	00000073          	ecall
 ret
    5cd6:	8082                	ret

0000000000005cd8 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5cd8:	48a9                	li	a7,10
 ecall
    5cda:	00000073          	ecall
 ret
    5cde:	8082                	ret

0000000000005ce0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5ce0:	48ad                	li	a7,11
 ecall
    5ce2:	00000073          	ecall
 ret
    5ce6:	8082                	ret

0000000000005ce8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5ce8:	48b1                	li	a7,12
 ecall
    5cea:	00000073          	ecall
 ret
    5cee:	8082                	ret

0000000000005cf0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5cf0:	48b5                	li	a7,13
 ecall
    5cf2:	00000073          	ecall
 ret
    5cf6:	8082                	ret

0000000000005cf8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5cf8:	48b9                	li	a7,14
 ecall
    5cfa:	00000073          	ecall
 ret
    5cfe:	8082                	ret

0000000000005d00 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5d00:	48d9                	li	a7,22
 ecall
    5d02:	00000073          	ecall
 ret
    5d06:	8082                	ret

0000000000005d08 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5d08:	1101                	addi	sp,sp,-32
    5d0a:	ec06                	sd	ra,24(sp)
    5d0c:	e822                	sd	s0,16(sp)
    5d0e:	1000                	addi	s0,sp,32
    5d10:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5d14:	4605                	li	a2,1
    5d16:	fef40593          	addi	a1,s0,-17
    5d1a:	00000097          	auipc	ra,0x0
    5d1e:	f66080e7          	jalr	-154(ra) # 5c80 <write>
}
    5d22:	60e2                	ld	ra,24(sp)
    5d24:	6442                	ld	s0,16(sp)
    5d26:	6105                	addi	sp,sp,32
    5d28:	8082                	ret

0000000000005d2a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5d2a:	7139                	addi	sp,sp,-64
    5d2c:	fc06                	sd	ra,56(sp)
    5d2e:	f822                	sd	s0,48(sp)
    5d30:	f426                	sd	s1,40(sp)
    5d32:	0080                	addi	s0,sp,64
    5d34:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5d36:	c299                	beqz	a3,5d3c <printint+0x12>
    5d38:	0805cb63          	bltz	a1,5dce <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5d3c:	2581                	sext.w	a1,a1
  neg = 0;
    5d3e:	4881                	li	a7,0
    5d40:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5d44:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5d46:	2601                	sext.w	a2,a2
    5d48:	00003517          	auipc	a0,0x3
    5d4c:	a2850513          	addi	a0,a0,-1496 # 8770 <digits>
    5d50:	883a                	mv	a6,a4
    5d52:	2705                	addiw	a4,a4,1
    5d54:	02c5f7bb          	remuw	a5,a1,a2
    5d58:	1782                	slli	a5,a5,0x20
    5d5a:	9381                	srli	a5,a5,0x20
    5d5c:	97aa                	add	a5,a5,a0
    5d5e:	0007c783          	lbu	a5,0(a5)
    5d62:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5d66:	0005879b          	sext.w	a5,a1
    5d6a:	02c5d5bb          	divuw	a1,a1,a2
    5d6e:	0685                	addi	a3,a3,1
    5d70:	fec7f0e3          	bgeu	a5,a2,5d50 <printint+0x26>
  if(neg)
    5d74:	00088c63          	beqz	a7,5d8c <printint+0x62>
    buf[i++] = '-';
    5d78:	fd070793          	addi	a5,a4,-48
    5d7c:	00878733          	add	a4,a5,s0
    5d80:	02d00793          	li	a5,45
    5d84:	fef70823          	sb	a5,-16(a4)
    5d88:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5d8c:	02e05c63          	blez	a4,5dc4 <printint+0x9a>
    5d90:	f04a                	sd	s2,32(sp)
    5d92:	ec4e                	sd	s3,24(sp)
    5d94:	fc040793          	addi	a5,s0,-64
    5d98:	00e78933          	add	s2,a5,a4
    5d9c:	fff78993          	addi	s3,a5,-1
    5da0:	99ba                	add	s3,s3,a4
    5da2:	377d                	addiw	a4,a4,-1
    5da4:	1702                	slli	a4,a4,0x20
    5da6:	9301                	srli	a4,a4,0x20
    5da8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5dac:	fff94583          	lbu	a1,-1(s2)
    5db0:	8526                	mv	a0,s1
    5db2:	00000097          	auipc	ra,0x0
    5db6:	f56080e7          	jalr	-170(ra) # 5d08 <putc>
  while(--i >= 0)
    5dba:	197d                	addi	s2,s2,-1
    5dbc:	ff3918e3          	bne	s2,s3,5dac <printint+0x82>
    5dc0:	7902                	ld	s2,32(sp)
    5dc2:	69e2                	ld	s3,24(sp)
}
    5dc4:	70e2                	ld	ra,56(sp)
    5dc6:	7442                	ld	s0,48(sp)
    5dc8:	74a2                	ld	s1,40(sp)
    5dca:	6121                	addi	sp,sp,64
    5dcc:	8082                	ret
    x = -xx;
    5dce:	40b005bb          	negw	a1,a1
    neg = 1;
    5dd2:	4885                	li	a7,1
    x = -xx;
    5dd4:	b7b5                	j	5d40 <printint+0x16>

0000000000005dd6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5dd6:	715d                	addi	sp,sp,-80
    5dd8:	e486                	sd	ra,72(sp)
    5dda:	e0a2                	sd	s0,64(sp)
    5ddc:	f84a                	sd	s2,48(sp)
    5dde:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5de0:	0005c903          	lbu	s2,0(a1)
    5de4:	1a090a63          	beqz	s2,5f98 <vprintf+0x1c2>
    5de8:	fc26                	sd	s1,56(sp)
    5dea:	f44e                	sd	s3,40(sp)
    5dec:	f052                	sd	s4,32(sp)
    5dee:	ec56                	sd	s5,24(sp)
    5df0:	e85a                	sd	s6,16(sp)
    5df2:	e45e                	sd	s7,8(sp)
    5df4:	8aaa                	mv	s5,a0
    5df6:	8bb2                	mv	s7,a2
    5df8:	00158493          	addi	s1,a1,1
  state = 0;
    5dfc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5dfe:	02500a13          	li	s4,37
    5e02:	4b55                	li	s6,21
    5e04:	a839                	j	5e22 <vprintf+0x4c>
        putc(fd, c);
    5e06:	85ca                	mv	a1,s2
    5e08:	8556                	mv	a0,s5
    5e0a:	00000097          	auipc	ra,0x0
    5e0e:	efe080e7          	jalr	-258(ra) # 5d08 <putc>
    5e12:	a019                	j	5e18 <vprintf+0x42>
    } else if(state == '%'){
    5e14:	01498d63          	beq	s3,s4,5e2e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    5e18:	0485                	addi	s1,s1,1
    5e1a:	fff4c903          	lbu	s2,-1(s1)
    5e1e:	16090763          	beqz	s2,5f8c <vprintf+0x1b6>
    if(state == 0){
    5e22:	fe0999e3          	bnez	s3,5e14 <vprintf+0x3e>
      if(c == '%'){
    5e26:	ff4910e3          	bne	s2,s4,5e06 <vprintf+0x30>
        state = '%';
    5e2a:	89d2                	mv	s3,s4
    5e2c:	b7f5                	j	5e18 <vprintf+0x42>
      if(c == 'd'){
    5e2e:	13490463          	beq	s2,s4,5f56 <vprintf+0x180>
    5e32:	f9d9079b          	addiw	a5,s2,-99
    5e36:	0ff7f793          	zext.b	a5,a5
    5e3a:	12fb6763          	bltu	s6,a5,5f68 <vprintf+0x192>
    5e3e:	f9d9079b          	addiw	a5,s2,-99
    5e42:	0ff7f713          	zext.b	a4,a5
    5e46:	12eb6163          	bltu	s6,a4,5f68 <vprintf+0x192>
    5e4a:	00271793          	slli	a5,a4,0x2
    5e4e:	00003717          	auipc	a4,0x3
    5e52:	8ca70713          	addi	a4,a4,-1846 # 8718 <malloc+0x2690>
    5e56:	97ba                	add	a5,a5,a4
    5e58:	439c                	lw	a5,0(a5)
    5e5a:	97ba                	add	a5,a5,a4
    5e5c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5e5e:	008b8913          	addi	s2,s7,8
    5e62:	4685                	li	a3,1
    5e64:	4629                	li	a2,10
    5e66:	000ba583          	lw	a1,0(s7)
    5e6a:	8556                	mv	a0,s5
    5e6c:	00000097          	auipc	ra,0x0
    5e70:	ebe080e7          	jalr	-322(ra) # 5d2a <printint>
    5e74:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5e76:	4981                	li	s3,0
    5e78:	b745                	j	5e18 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e7a:	008b8913          	addi	s2,s7,8
    5e7e:	4681                	li	a3,0
    5e80:	4629                	li	a2,10
    5e82:	000ba583          	lw	a1,0(s7)
    5e86:	8556                	mv	a0,s5
    5e88:	00000097          	auipc	ra,0x0
    5e8c:	ea2080e7          	jalr	-350(ra) # 5d2a <printint>
    5e90:	8bca                	mv	s7,s2
      state = 0;
    5e92:	4981                	li	s3,0
    5e94:	b751                	j	5e18 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    5e96:	008b8913          	addi	s2,s7,8
    5e9a:	4681                	li	a3,0
    5e9c:	4641                	li	a2,16
    5e9e:	000ba583          	lw	a1,0(s7)
    5ea2:	8556                	mv	a0,s5
    5ea4:	00000097          	auipc	ra,0x0
    5ea8:	e86080e7          	jalr	-378(ra) # 5d2a <printint>
    5eac:	8bca                	mv	s7,s2
      state = 0;
    5eae:	4981                	li	s3,0
    5eb0:	b7a5                	j	5e18 <vprintf+0x42>
    5eb2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5eb4:	008b8c13          	addi	s8,s7,8
    5eb8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5ebc:	03000593          	li	a1,48
    5ec0:	8556                	mv	a0,s5
    5ec2:	00000097          	auipc	ra,0x0
    5ec6:	e46080e7          	jalr	-442(ra) # 5d08 <putc>
  putc(fd, 'x');
    5eca:	07800593          	li	a1,120
    5ece:	8556                	mv	a0,s5
    5ed0:	00000097          	auipc	ra,0x0
    5ed4:	e38080e7          	jalr	-456(ra) # 5d08 <putc>
    5ed8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5eda:	00003b97          	auipc	s7,0x3
    5ede:	896b8b93          	addi	s7,s7,-1898 # 8770 <digits>
    5ee2:	03c9d793          	srli	a5,s3,0x3c
    5ee6:	97de                	add	a5,a5,s7
    5ee8:	0007c583          	lbu	a1,0(a5)
    5eec:	8556                	mv	a0,s5
    5eee:	00000097          	auipc	ra,0x0
    5ef2:	e1a080e7          	jalr	-486(ra) # 5d08 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5ef6:	0992                	slli	s3,s3,0x4
    5ef8:	397d                	addiw	s2,s2,-1
    5efa:	fe0914e3          	bnez	s2,5ee2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5efe:	8be2                	mv	s7,s8
      state = 0;
    5f00:	4981                	li	s3,0
    5f02:	6c02                	ld	s8,0(sp)
    5f04:	bf11                	j	5e18 <vprintf+0x42>
        s = va_arg(ap, char*);
    5f06:	008b8993          	addi	s3,s7,8
    5f0a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5f0e:	02090163          	beqz	s2,5f30 <vprintf+0x15a>
        while(*s != 0){
    5f12:	00094583          	lbu	a1,0(s2)
    5f16:	c9a5                	beqz	a1,5f86 <vprintf+0x1b0>
          putc(fd, *s);
    5f18:	8556                	mv	a0,s5
    5f1a:	00000097          	auipc	ra,0x0
    5f1e:	dee080e7          	jalr	-530(ra) # 5d08 <putc>
          s++;
    5f22:	0905                	addi	s2,s2,1
        while(*s != 0){
    5f24:	00094583          	lbu	a1,0(s2)
    5f28:	f9e5                	bnez	a1,5f18 <vprintf+0x142>
        s = va_arg(ap, char*);
    5f2a:	8bce                	mv	s7,s3
      state = 0;
    5f2c:	4981                	li	s3,0
    5f2e:	b5ed                	j	5e18 <vprintf+0x42>
          s = "(null)";
    5f30:	00002917          	auipc	s2,0x2
    5f34:	7c090913          	addi	s2,s2,1984 # 86f0 <malloc+0x2668>
        while(*s != 0){
    5f38:	02800593          	li	a1,40
    5f3c:	bff1                	j	5f18 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    5f3e:	008b8913          	addi	s2,s7,8
    5f42:	000bc583          	lbu	a1,0(s7)
    5f46:	8556                	mv	a0,s5
    5f48:	00000097          	auipc	ra,0x0
    5f4c:	dc0080e7          	jalr	-576(ra) # 5d08 <putc>
    5f50:	8bca                	mv	s7,s2
      state = 0;
    5f52:	4981                	li	s3,0
    5f54:	b5d1                	j	5e18 <vprintf+0x42>
        putc(fd, c);
    5f56:	02500593          	li	a1,37
    5f5a:	8556                	mv	a0,s5
    5f5c:	00000097          	auipc	ra,0x0
    5f60:	dac080e7          	jalr	-596(ra) # 5d08 <putc>
      state = 0;
    5f64:	4981                	li	s3,0
    5f66:	bd4d                	j	5e18 <vprintf+0x42>
        putc(fd, '%');
    5f68:	02500593          	li	a1,37
    5f6c:	8556                	mv	a0,s5
    5f6e:	00000097          	auipc	ra,0x0
    5f72:	d9a080e7          	jalr	-614(ra) # 5d08 <putc>
        putc(fd, c);
    5f76:	85ca                	mv	a1,s2
    5f78:	8556                	mv	a0,s5
    5f7a:	00000097          	auipc	ra,0x0
    5f7e:	d8e080e7          	jalr	-626(ra) # 5d08 <putc>
      state = 0;
    5f82:	4981                	li	s3,0
    5f84:	bd51                	j	5e18 <vprintf+0x42>
        s = va_arg(ap, char*);
    5f86:	8bce                	mv	s7,s3
      state = 0;
    5f88:	4981                	li	s3,0
    5f8a:	b579                	j	5e18 <vprintf+0x42>
    5f8c:	74e2                	ld	s1,56(sp)
    5f8e:	79a2                	ld	s3,40(sp)
    5f90:	7a02                	ld	s4,32(sp)
    5f92:	6ae2                	ld	s5,24(sp)
    5f94:	6b42                	ld	s6,16(sp)
    5f96:	6ba2                	ld	s7,8(sp)
    }
  }
}
    5f98:	60a6                	ld	ra,72(sp)
    5f9a:	6406                	ld	s0,64(sp)
    5f9c:	7942                	ld	s2,48(sp)
    5f9e:	6161                	addi	sp,sp,80
    5fa0:	8082                	ret

0000000000005fa2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5fa2:	715d                	addi	sp,sp,-80
    5fa4:	ec06                	sd	ra,24(sp)
    5fa6:	e822                	sd	s0,16(sp)
    5fa8:	1000                	addi	s0,sp,32
    5faa:	e010                	sd	a2,0(s0)
    5fac:	e414                	sd	a3,8(s0)
    5fae:	e818                	sd	a4,16(s0)
    5fb0:	ec1c                	sd	a5,24(s0)
    5fb2:	03043023          	sd	a6,32(s0)
    5fb6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5fba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5fbe:	8622                	mv	a2,s0
    5fc0:	00000097          	auipc	ra,0x0
    5fc4:	e16080e7          	jalr	-490(ra) # 5dd6 <vprintf>
}
    5fc8:	60e2                	ld	ra,24(sp)
    5fca:	6442                	ld	s0,16(sp)
    5fcc:	6161                	addi	sp,sp,80
    5fce:	8082                	ret

0000000000005fd0 <printf>:

void
printf(const char *fmt, ...)
{
    5fd0:	711d                	addi	sp,sp,-96
    5fd2:	ec06                	sd	ra,24(sp)
    5fd4:	e822                	sd	s0,16(sp)
    5fd6:	1000                	addi	s0,sp,32
    5fd8:	e40c                	sd	a1,8(s0)
    5fda:	e810                	sd	a2,16(s0)
    5fdc:	ec14                	sd	a3,24(s0)
    5fde:	f018                	sd	a4,32(s0)
    5fe0:	f41c                	sd	a5,40(s0)
    5fe2:	03043823          	sd	a6,48(s0)
    5fe6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5fea:	00840613          	addi	a2,s0,8
    5fee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5ff2:	85aa                	mv	a1,a0
    5ff4:	4505                	li	a0,1
    5ff6:	00000097          	auipc	ra,0x0
    5ffa:	de0080e7          	jalr	-544(ra) # 5dd6 <vprintf>
}
    5ffe:	60e2                	ld	ra,24(sp)
    6000:	6442                	ld	s0,16(sp)
    6002:	6125                	addi	sp,sp,96
    6004:	8082                	ret

0000000000006006 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    6006:	1141                	addi	sp,sp,-16
    6008:	e422                	sd	s0,8(sp)
    600a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    600c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6010:	00003797          	auipc	a5,0x3
    6014:	4407b783          	ld	a5,1088(a5) # 9450 <freep>
    6018:	a02d                	j	6042 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    601a:	4618                	lw	a4,8(a2)
    601c:	9f2d                	addw	a4,a4,a1
    601e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    6022:	6398                	ld	a4,0(a5)
    6024:	6310                	ld	a2,0(a4)
    6026:	a83d                	j	6064 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    6028:	ff852703          	lw	a4,-8(a0)
    602c:	9f31                	addw	a4,a4,a2
    602e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    6030:	ff053683          	ld	a3,-16(a0)
    6034:	a091                	j	6078 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6036:	6398                	ld	a4,0(a5)
    6038:	00e7e463          	bltu	a5,a4,6040 <free+0x3a>
    603c:	00e6ea63          	bltu	a3,a4,6050 <free+0x4a>
{
    6040:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6042:	fed7fae3          	bgeu	a5,a3,6036 <free+0x30>
    6046:	6398                	ld	a4,0(a5)
    6048:	00e6e463          	bltu	a3,a4,6050 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    604c:	fee7eae3          	bltu	a5,a4,6040 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    6050:	ff852583          	lw	a1,-8(a0)
    6054:	6390                	ld	a2,0(a5)
    6056:	02059813          	slli	a6,a1,0x20
    605a:	01c85713          	srli	a4,a6,0x1c
    605e:	9736                	add	a4,a4,a3
    6060:	fae60de3          	beq	a2,a4,601a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    6064:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6068:	4790                	lw	a2,8(a5)
    606a:	02061593          	slli	a1,a2,0x20
    606e:	01c5d713          	srli	a4,a1,0x1c
    6072:	973e                	add	a4,a4,a5
    6074:	fae68ae3          	beq	a3,a4,6028 <free+0x22>
    p->s.ptr = bp->s.ptr;
    6078:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    607a:	00003717          	auipc	a4,0x3
    607e:	3cf73b23          	sd	a5,982(a4) # 9450 <freep>
}
    6082:	6422                	ld	s0,8(sp)
    6084:	0141                	addi	sp,sp,16
    6086:	8082                	ret

0000000000006088 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6088:	7139                	addi	sp,sp,-64
    608a:	fc06                	sd	ra,56(sp)
    608c:	f822                	sd	s0,48(sp)
    608e:	f426                	sd	s1,40(sp)
    6090:	ec4e                	sd	s3,24(sp)
    6092:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6094:	02051493          	slli	s1,a0,0x20
    6098:	9081                	srli	s1,s1,0x20
    609a:	04bd                	addi	s1,s1,15
    609c:	8091                	srli	s1,s1,0x4
    609e:	0014899b          	addiw	s3,s1,1
    60a2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    60a4:	00003517          	auipc	a0,0x3
    60a8:	3ac53503          	ld	a0,940(a0) # 9450 <freep>
    60ac:	c915                	beqz	a0,60e0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60b0:	4798                	lw	a4,8(a5)
    60b2:	08977e63          	bgeu	a4,s1,614e <malloc+0xc6>
    60b6:	f04a                	sd	s2,32(sp)
    60b8:	e852                	sd	s4,16(sp)
    60ba:	e456                	sd	s5,8(sp)
    60bc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    60be:	8a4e                	mv	s4,s3
    60c0:	0009871b          	sext.w	a4,s3
    60c4:	6685                	lui	a3,0x1
    60c6:	00d77363          	bgeu	a4,a3,60cc <malloc+0x44>
    60ca:	6a05                	lui	s4,0x1
    60cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    60d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    60d4:	00003917          	auipc	s2,0x3
    60d8:	37c90913          	addi	s2,s2,892 # 9450 <freep>
  if(p == (char*)-1)
    60dc:	5afd                	li	s5,-1
    60de:	a091                	j	6122 <malloc+0x9a>
    60e0:	f04a                	sd	s2,32(sp)
    60e2:	e852                	sd	s4,16(sp)
    60e4:	e456                	sd	s5,8(sp)
    60e6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    60e8:	0000a797          	auipc	a5,0xa
    60ec:	b9078793          	addi	a5,a5,-1136 # fc78 <base>
    60f0:	00003717          	auipc	a4,0x3
    60f4:	36f73023          	sd	a5,864(a4) # 9450 <freep>
    60f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    60fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    60fe:	b7c1                	j	60be <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    6100:	6398                	ld	a4,0(a5)
    6102:	e118                	sd	a4,0(a0)
    6104:	a08d                	j	6166 <malloc+0xde>
  hp->s.size = nu;
    6106:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    610a:	0541                	addi	a0,a0,16
    610c:	00000097          	auipc	ra,0x0
    6110:	efa080e7          	jalr	-262(ra) # 6006 <free>
  return freep;
    6114:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6118:	c13d                	beqz	a0,617e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    611a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    611c:	4798                	lw	a4,8(a5)
    611e:	02977463          	bgeu	a4,s1,6146 <malloc+0xbe>
    if(p == freep)
    6122:	00093703          	ld	a4,0(s2)
    6126:	853e                	mv	a0,a5
    6128:	fef719e3          	bne	a4,a5,611a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    612c:	8552                	mv	a0,s4
    612e:	00000097          	auipc	ra,0x0
    6132:	bba080e7          	jalr	-1094(ra) # 5ce8 <sbrk>
  if(p == (char*)-1)
    6136:	fd5518e3          	bne	a0,s5,6106 <malloc+0x7e>
        return 0;
    613a:	4501                	li	a0,0
    613c:	7902                	ld	s2,32(sp)
    613e:	6a42                	ld	s4,16(sp)
    6140:	6aa2                	ld	s5,8(sp)
    6142:	6b02                	ld	s6,0(sp)
    6144:	a03d                	j	6172 <malloc+0xea>
    6146:	7902                	ld	s2,32(sp)
    6148:	6a42                	ld	s4,16(sp)
    614a:	6aa2                	ld	s5,8(sp)
    614c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    614e:	fae489e3          	beq	s1,a4,6100 <malloc+0x78>
        p->s.size -= nunits;
    6152:	4137073b          	subw	a4,a4,s3
    6156:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6158:	02071693          	slli	a3,a4,0x20
    615c:	01c6d713          	srli	a4,a3,0x1c
    6160:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6162:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6166:	00003717          	auipc	a4,0x3
    616a:	2ea73523          	sd	a0,746(a4) # 9450 <freep>
      return (void*)(p + 1);
    616e:	01078513          	addi	a0,a5,16
  }
}
    6172:	70e2                	ld	ra,56(sp)
    6174:	7442                	ld	s0,48(sp)
    6176:	74a2                	ld	s1,40(sp)
    6178:	69e2                	ld	s3,24(sp)
    617a:	6121                	addi	sp,sp,64
    617c:	8082                	ret
    617e:	7902                	ld	s2,32(sp)
    6180:	6a42                	ld	s4,16(sp)
    6182:	6aa2                	ld	s5,8(sp)
    6184:	6b02                	ld	s6,0(sp)
    6186:	b7f5                	j	6172 <malloc+0xea>
