
user/_handshake:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  int p2c[2];
  int c2p[2];

  // fill the missing code
  // char buf[??]={0};
  char buf[5] = {0};
   8:	fc042c23          	sw	zero,-40(s0)
   c:	fc040e23          	sb	zero,-36(s0)

  if (argc < 2)
  10:	4785                	li	a5,1
  12:	04a7d563          	bge	a5,a0,5c <main+0x5c>
  16:	6598                	ld	a4,8(a1)
  18:	fd840793          	addi	a5,s0,-40
  1c:	fdc40613          	addi	a2,s0,-36
  }

  for (int i = 0; i < 4; i++)
  {
    // fill the missing code
    buf[i] = argv[1][i];
  20:	00074683          	lbu	a3,0(a4)
  24:	00d78023          	sb	a3,0(a5)
  for (int i = 0; i < 4; i++)
  28:	0705                	addi	a4,a4,1
  2a:	0785                	addi	a5,a5,1
  2c:	fec79ae3          	bne	a5,a2,20 <main+0x20>
  }

  if (pipe(p2c) < 0 || pipe(c2p) < 0)
  30:	fe840513          	addi	a0,s0,-24
  34:	41e000ef          	jal	452 <pipe>
  38:	00054863          	bltz	a0,48 <main+0x48>
  3c:	fe040513          	addi	a0,s0,-32
  40:	412000ef          	jal	452 <pipe>
  44:	02055663          	bgez	a0,70 <main+0x70>
  {
    fprintf(2, "handshake: pipe failed\n");
  48:	00001597          	auipc	a1,0x1
  4c:	a1058593          	addi	a1,a1,-1520 # a58 <malloc+0x12e>
  50:	4509                	li	a0,2
  52:	7fa000ef          	jal	84c <fprintf>
    exit(1);
  56:	4505                	li	a0,1
  58:	3ea000ef          	jal	442 <exit>
    fprintf(2, "Usage: handshake <4-char-string>\n");
  5c:	00001597          	auipc	a1,0x1
  60:	9d458593          	addi	a1,a1,-1580 # a30 <malloc+0x106>
  64:	4509                	li	a0,2
  66:	7e6000ef          	jal	84c <fprintf>
    exit(1);
  6a:	4505                	li	a0,1
  6c:	3d6000ef          	jal	442 <exit>
  }

  int pid = fork();
  70:	3ca000ef          	jal	43a <fork>
  if (pid < 0)
  74:	02054f63          	bltz	a0,b2 <main+0xb2>
  {
    fprintf(2, "handshake: fork failed\n");
    exit(1);
  }

  if (pid == 0)
  78:	e14d                	bnez	a0,11a <main+0x11a>
  {
    // CHILD PROCESS
    close(p2c[1]); // child reads
  7a:	fec42503          	lw	a0,-20(s0)
  7e:	3ec000ef          	jal	46a <close>
    close(c2p[0]); // child writes
  82:	fe042503          	lw	a0,-32(s0)
  86:	3e4000ef          	jal	46a <close>

    // fill the missing codes
    if (read(p2c[0], buf, 4 * sizeof(char)) != 4)
  8a:	4611                	li	a2,4
  8c:	fd840593          	addi	a1,s0,-40
  90:	fe842503          	lw	a0,-24(s0)
  94:	3c6000ef          	jal	45a <read>
  98:	4791                	li	a5,4
  9a:	02f50663          	beq	a0,a5,c6 <main+0xc6>
    {
      fprintf(2, "handshake: child read failed\n");
  9e:	00001597          	auipc	a1,0x1
  a2:	9ea58593          	addi	a1,a1,-1558 # a88 <malloc+0x15e>
  a6:	4509                	li	a0,2
  a8:	7a4000ef          	jal	84c <fprintf>
      exit(1);
  ac:	4505                	li	a0,1
  ae:	394000ef          	jal	442 <exit>
    fprintf(2, "handshake: fork failed\n");
  b2:	00001597          	auipc	a1,0x1
  b6:	9be58593          	addi	a1,a1,-1602 # a70 <malloc+0x146>
  ba:	4509                	li	a0,2
  bc:	790000ef          	jal	84c <fprintf>
    exit(1);
  c0:	4505                	li	a0,1
  c2:	380000ef          	jal	442 <exit>
    }

    // fill the missing code
    printf("%d: child received %s from parent\n", getpid(), buf);
  c6:	3fc000ef          	jal	4c2 <getpid>
  ca:	85aa                	mv	a1,a0
  cc:	fd840613          	addi	a2,s0,-40
  d0:	00001517          	auipc	a0,0x1
  d4:	9d850513          	addi	a0,a0,-1576 # aa8 <malloc+0x17e>
  d8:	79e000ef          	jal	876 <printf>
    // fill the missing code
    if (write(c2p[1], buf, 4 * sizeof(char)) != 4)
  dc:	4611                	li	a2,4
  de:	fd840593          	addi	a1,s0,-40
  e2:	fe442503          	lw	a0,-28(s0)
  e6:	37c000ef          	jal	462 <write>
  ea:	4791                	li	a5,4
  ec:	00f50c63          	beq	a0,a5,104 <main+0x104>
    {
      fprintf(2, "handshake: child write failed\n");
  f0:	00001597          	auipc	a1,0x1
  f4:	9e058593          	addi	a1,a1,-1568 # ad0 <malloc+0x1a6>
  f8:	4509                	li	a0,2
  fa:	752000ef          	jal	84c <fprintf>
      exit(1);
  fe:	4505                	li	a0,1
 100:	342000ef          	jal	442 <exit>
    }

    close(p2c[0]);
 104:	fe842503          	lw	a0,-24(s0)
 108:	362000ef          	jal	46a <close>
    close(c2p[1]);
 10c:	fe442503          	lw	a0,-28(s0)
 110:	35a000ef          	jal	46a <close>
    exit(0);
 114:	4501                	li	a0,0
 116:	32c000ef          	jal	442 <exit>
  }

  // PARENT PROCESS
  close(p2c[0]); // paprent writes
 11a:	fe842503          	lw	a0,-24(s0)
 11e:	34c000ef          	jal	46a <close>
  close(c2p[1]); // parent reads
 122:	fe442503          	lw	a0,-28(s0)
 126:	344000ef          	jal	46a <close>

  // fill the missing code
  if (write(p2c[1], buf, 4 * sizeof(char)) != 4)
 12a:	4611                	li	a2,4
 12c:	fd840593          	addi	a1,s0,-40
 130:	fec42503          	lw	a0,-20(s0)
 134:	32e000ef          	jal	462 <write>
 138:	4791                	li	a5,4
 13a:	00f50c63          	beq	a0,a5,152 <main+0x152>
  {
    fprintf(2, "handshake: parent write failed\n");
 13e:	00001597          	auipc	a1,0x1
 142:	9b258593          	addi	a1,a1,-1614 # af0 <malloc+0x1c6>
 146:	4509                	li	a0,2
 148:	704000ef          	jal	84c <fprintf>
    exit(1);
 14c:	4505                	li	a0,1
 14e:	2f4000ef          	jal	442 <exit>
  }

  // fill the missing code
  if (read(c2p[0], buf, 4 * sizeof(char)) != 4)
 152:	4611                	li	a2,4
 154:	fd840593          	addi	a1,s0,-40
 158:	fe042503          	lw	a0,-32(s0)
 15c:	2fe000ef          	jal	45a <read>
 160:	4791                	li	a5,4
 162:	00f50c63          	beq	a0,a5,17a <main+0x17a>
  {
    fprintf(2, "handshake: parent read failed\n");
 166:	00001597          	auipc	a1,0x1
 16a:	9aa58593          	addi	a1,a1,-1622 # b10 <malloc+0x1e6>
 16e:	4509                	li	a0,2
 170:	6dc000ef          	jal	84c <fprintf>
    exit(1);
 174:	4505                	li	a0,1
 176:	2cc000ef          	jal	442 <exit>
  }

  // fill the missing code
  printf("%d: parent received %s from child\n", getpid(), buf);
 17a:	348000ef          	jal	4c2 <getpid>
 17e:	85aa                	mv	a1,a0
 180:	fd840613          	addi	a2,s0,-40
 184:	00001517          	auipc	a0,0x1
 188:	9ac50513          	addi	a0,a0,-1620 # b30 <malloc+0x206>
 18c:	6ea000ef          	jal	876 <printf>
  close(p2c[1]);
 190:	fec42503          	lw	a0,-20(s0)
 194:	2d6000ef          	jal	46a <close>
  close(c2p[0]);
 198:	fe042503          	lw	a0,-32(s0)
 19c:	2ce000ef          	jal	46a <close>
  wait(0);
 1a0:	4501                	li	a0,0
 1a2:	2a8000ef          	jal	44a <wait>
  exit(0);
 1a6:	4501                	li	a0,0
 1a8:	29a000ef          	jal	442 <exit>

00000000000001ac <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1b4:	e4dff0ef          	jal	0 <main>
  exit(0);
 1b8:	4501                	li	a0,0
 1ba:	288000ef          	jal	442 <exit>

00000000000001be <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e422                	sd	s0,8(sp)
 1c2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c4:	87aa                	mv	a5,a0
 1c6:	0585                	addi	a1,a1,1
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff5c703          	lbu	a4,-1(a1)
 1ce:	fee78fa3          	sb	a4,-1(a5)
 1d2:	fb75                	bnez	a4,1c6 <strcpy+0x8>
    ;
  return os;
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret

00000000000001da <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	cb91                	beqz	a5,1f8 <strcmp+0x1e>
 1e6:	0005c703          	lbu	a4,0(a1)
 1ea:	00f71763          	bne	a4,a5,1f8 <strcmp+0x1e>
    p++, q++;
 1ee:	0505                	addi	a0,a0,1
 1f0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	fbe5                	bnez	a5,1e6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1f8:	0005c503          	lbu	a0,0(a1)
}
 1fc:	40a7853b          	subw	a0,a5,a0
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret

0000000000000206 <strlen>:

uint
strlen(const char *s)
{
 206:	1141                	addi	sp,sp,-16
 208:	e422                	sd	s0,8(sp)
 20a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 20c:	00054783          	lbu	a5,0(a0)
 210:	cf91                	beqz	a5,22c <strlen+0x26>
 212:	0505                	addi	a0,a0,1
 214:	87aa                	mv	a5,a0
 216:	86be                	mv	a3,a5
 218:	0785                	addi	a5,a5,1
 21a:	fff7c703          	lbu	a4,-1(a5)
 21e:	ff65                	bnez	a4,216 <strlen+0x10>
 220:	40a6853b          	subw	a0,a3,a0
 224:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  for(n = 0; s[n]; n++)
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <strlen+0x20>

0000000000000230 <memset>:

void*
memset(void *dst, int c, uint n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 236:	ca19                	beqz	a2,24c <memset+0x1c>
 238:	87aa                	mv	a5,a0
 23a:	1602                	slli	a2,a2,0x20
 23c:	9201                	srli	a2,a2,0x20
 23e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 242:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 246:	0785                	addi	a5,a5,1
 248:	fee79de3          	bne	a5,a4,242 <memset+0x12>
  }
  return dst;
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret

0000000000000252 <strchr>:

char*
strchr(const char *s, char c)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  for(; *s; s++)
 258:	00054783          	lbu	a5,0(a0)
 25c:	cb99                	beqz	a5,272 <strchr+0x20>
    if(*s == c)
 25e:	00f58763          	beq	a1,a5,26c <strchr+0x1a>
  for(; *s; s++)
 262:	0505                	addi	a0,a0,1
 264:	00054783          	lbu	a5,0(a0)
 268:	fbfd                	bnez	a5,25e <strchr+0xc>
      return (char*)s;
  return 0;
 26a:	4501                	li	a0,0
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <strchr+0x1a>

0000000000000276 <gets>:

char*
gets(char *buf, int max)
{
 276:	711d                	addi	sp,sp,-96
 278:	ec86                	sd	ra,88(sp)
 27a:	e8a2                	sd	s0,80(sp)
 27c:	e4a6                	sd	s1,72(sp)
 27e:	e0ca                	sd	s2,64(sp)
 280:	fc4e                	sd	s3,56(sp)
 282:	f852                	sd	s4,48(sp)
 284:	f456                	sd	s5,40(sp)
 286:	f05a                	sd	s6,32(sp)
 288:	ec5e                	sd	s7,24(sp)
 28a:	1080                	addi	s0,sp,96
 28c:	8baa                	mv	s7,a0
 28e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 290:	892a                	mv	s2,a0
 292:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 294:	4aa9                	li	s5,10
 296:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 298:	89a6                	mv	s3,s1
 29a:	2485                	addiw	s1,s1,1
 29c:	0344d663          	bge	s1,s4,2c8 <gets+0x52>
    cc = read(0, &c, 1);
 2a0:	4605                	li	a2,1
 2a2:	faf40593          	addi	a1,s0,-81
 2a6:	4501                	li	a0,0
 2a8:	1b2000ef          	jal	45a <read>
    if(cc < 1)
 2ac:	00a05e63          	blez	a0,2c8 <gets+0x52>
    buf[i++] = c;
 2b0:	faf44783          	lbu	a5,-81(s0)
 2b4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b8:	01578763          	beq	a5,s5,2c6 <gets+0x50>
 2bc:	0905                	addi	s2,s2,1
 2be:	fd679de3          	bne	a5,s6,298 <gets+0x22>
    buf[i++] = c;
 2c2:	89a6                	mv	s3,s1
 2c4:	a011                	j	2c8 <gets+0x52>
 2c6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2c8:	99de                	add	s3,s3,s7
 2ca:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ce:	855e                	mv	a0,s7
 2d0:	60e6                	ld	ra,88(sp)
 2d2:	6446                	ld	s0,80(sp)
 2d4:	64a6                	ld	s1,72(sp)
 2d6:	6906                	ld	s2,64(sp)
 2d8:	79e2                	ld	s3,56(sp)
 2da:	7a42                	ld	s4,48(sp)
 2dc:	7aa2                	ld	s5,40(sp)
 2de:	7b02                	ld	s6,32(sp)
 2e0:	6be2                	ld	s7,24(sp)
 2e2:	6125                	addi	sp,sp,96
 2e4:	8082                	ret

00000000000002e6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e6:	1101                	addi	sp,sp,-32
 2e8:	ec06                	sd	ra,24(sp)
 2ea:	e822                	sd	s0,16(sp)
 2ec:	e04a                	sd	s2,0(sp)
 2ee:	1000                	addi	s0,sp,32
 2f0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f2:	4581                	li	a1,0
 2f4:	18e000ef          	jal	482 <open>
  if(fd < 0)
 2f8:	02054263          	bltz	a0,31c <stat+0x36>
 2fc:	e426                	sd	s1,8(sp)
 2fe:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 300:	85ca                	mv	a1,s2
 302:	198000ef          	jal	49a <fstat>
 306:	892a                	mv	s2,a0
  close(fd);
 308:	8526                	mv	a0,s1
 30a:	160000ef          	jal	46a <close>
  return r;
 30e:	64a2                	ld	s1,8(sp)
}
 310:	854a                	mv	a0,s2
 312:	60e2                	ld	ra,24(sp)
 314:	6442                	ld	s0,16(sp)
 316:	6902                	ld	s2,0(sp)
 318:	6105                	addi	sp,sp,32
 31a:	8082                	ret
    return -1;
 31c:	597d                	li	s2,-1
 31e:	bfcd                	j	310 <stat+0x2a>

0000000000000320 <atoi>:

int
atoi(const char *s)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 326:	00054683          	lbu	a3,0(a0)
 32a:	fd06879b          	addiw	a5,a3,-48
 32e:	0ff7f793          	zext.b	a5,a5
 332:	4625                	li	a2,9
 334:	02f66863          	bltu	a2,a5,364 <atoi+0x44>
 338:	872a                	mv	a4,a0
  n = 0;
 33a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 33c:	0705                	addi	a4,a4,1
 33e:	0025179b          	slliw	a5,a0,0x2
 342:	9fa9                	addw	a5,a5,a0
 344:	0017979b          	slliw	a5,a5,0x1
 348:	9fb5                	addw	a5,a5,a3
 34a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34e:	00074683          	lbu	a3,0(a4)
 352:	fd06879b          	addiw	a5,a3,-48
 356:	0ff7f793          	zext.b	a5,a5
 35a:	fef671e3          	bgeu	a2,a5,33c <atoi+0x1c>
  return n;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  n = 0;
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <atoi+0x3e>

0000000000000368 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36e:	02b57463          	bgeu	a0,a1,396 <memmove+0x2e>
    while(n-- > 0)
 372:	00c05f63          	blez	a2,390 <memmove+0x28>
 376:	1602                	slli	a2,a2,0x20
 378:	9201                	srli	a2,a2,0x20
 37a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 37e:	872a                	mv	a4,a0
      *dst++ = *src++;
 380:	0585                	addi	a1,a1,1
 382:	0705                	addi	a4,a4,1
 384:	fff5c683          	lbu	a3,-1(a1)
 388:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 38c:	fef71ae3          	bne	a4,a5,380 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 390:	6422                	ld	s0,8(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret
    dst += n;
 396:	00c50733          	add	a4,a0,a2
    src += n;
 39a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 39c:	fec05ae3          	blez	a2,390 <memmove+0x28>
 3a0:	fff6079b          	addiw	a5,a2,-1
 3a4:	1782                	slli	a5,a5,0x20
 3a6:	9381                	srli	a5,a5,0x20
 3a8:	fff7c793          	not	a5,a5
 3ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ae:	15fd                	addi	a1,a1,-1
 3b0:	177d                	addi	a4,a4,-1
 3b2:	0005c683          	lbu	a3,0(a1)
 3b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ba:	fee79ae3          	bne	a5,a4,3ae <memmove+0x46>
 3be:	bfc9                	j	390 <memmove+0x28>

00000000000003c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c6:	ca05                	beqz	a2,3f6 <memcmp+0x36>
 3c8:	fff6069b          	addiw	a3,a2,-1
 3cc:	1682                	slli	a3,a3,0x20
 3ce:	9281                	srli	a3,a3,0x20
 3d0:	0685                	addi	a3,a3,1
 3d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d4:	00054783          	lbu	a5,0(a0)
 3d8:	0005c703          	lbu	a4,0(a1)
 3dc:	00e79863          	bne	a5,a4,3ec <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3e0:	0505                	addi	a0,a0,1
    p2++;
 3e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e4:	fed518e3          	bne	a0,a3,3d4 <memcmp+0x14>
  }
  return 0;
 3e8:	4501                	li	a0,0
 3ea:	a019                	j	3f0 <memcmp+0x30>
      return *p1 - *p2;
 3ec:	40e7853b          	subw	a0,a5,a4
}
 3f0:	6422                	ld	s0,8(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret
  return 0;
 3f6:	4501                	li	a0,0
 3f8:	bfe5                	j	3f0 <memcmp+0x30>

00000000000003fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3fa:	1141                	addi	sp,sp,-16
 3fc:	e406                	sd	ra,8(sp)
 3fe:	e022                	sd	s0,0(sp)
 400:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 402:	f67ff0ef          	jal	368 <memmove>
}
 406:	60a2                	ld	ra,8(sp)
 408:	6402                	ld	s0,0(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <sbrk>:

char *
sbrk(int n) {
 40e:	1141                	addi	sp,sp,-16
 410:	e406                	sd	ra,8(sp)
 412:	e022                	sd	s0,0(sp)
 414:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 416:	4585                	li	a1,1
 418:	0b2000ef          	jal	4ca <sys_sbrk>
}
 41c:	60a2                	ld	ra,8(sp)
 41e:	6402                	ld	s0,0(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret

0000000000000424 <sbrklazy>:

char *
sbrklazy(int n) {
 424:	1141                	addi	sp,sp,-16
 426:	e406                	sd	ra,8(sp)
 428:	e022                	sd	s0,0(sp)
 42a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 42c:	4589                	li	a1,2
 42e:	09c000ef          	jal	4ca <sys_sbrk>
}
 432:	60a2                	ld	ra,8(sp)
 434:	6402                	ld	s0,0(sp)
 436:	0141                	addi	sp,sp,16
 438:	8082                	ret

000000000000043a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43a:	4885                	li	a7,1
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <exit>:
.global exit
exit:
 li a7, SYS_exit
 442:	4889                	li	a7,2
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <wait>:
.global wait
wait:
 li a7, SYS_wait
 44a:	488d                	li	a7,3
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 452:	4891                	li	a7,4
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <read>:
.global read
read:
 li a7, SYS_read
 45a:	4895                	li	a7,5
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <write>:
.global write
write:
 li a7, SYS_write
 462:	48c1                	li	a7,16
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <close>:
.global close
close:
 li a7, SYS_close
 46a:	48d5                	li	a7,21
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <kill>:
.global kill
kill:
 li a7, SYS_kill
 472:	4899                	li	a7,6
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <exec>:
.global exec
exec:
 li a7, SYS_exec
 47a:	489d                	li	a7,7
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <open>:
.global open
open:
 li a7, SYS_open
 482:	48bd                	li	a7,15
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48a:	48c5                	li	a7,17
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 492:	48c9                	li	a7,18
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 49a:	48a1                	li	a7,8
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <link>:
.global link
link:
 li a7, SYS_link
 4a2:	48cd                	li	a7,19
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4aa:	48d1                	li	a7,20
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b2:	48a5                	li	a7,9
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ba:	48a9                	li	a7,10
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c2:	48ad                	li	a7,11
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4ca:	48b1                	li	a7,12
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4d2:	48b5                	li	a7,13
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4da:	48b9                	li	a7,14
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e2:	1101                	addi	sp,sp,-32
 4e4:	ec06                	sd	ra,24(sp)
 4e6:	e822                	sd	s0,16(sp)
 4e8:	1000                	addi	s0,sp,32
 4ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ee:	4605                	li	a2,1
 4f0:	fef40593          	addi	a1,s0,-17
 4f4:	f6fff0ef          	jal	462 <write>
}
 4f8:	60e2                	ld	ra,24(sp)
 4fa:	6442                	ld	s0,16(sp)
 4fc:	6105                	addi	sp,sp,32
 4fe:	8082                	ret

0000000000000500 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 500:	715d                	addi	sp,sp,-80
 502:	e486                	sd	ra,72(sp)
 504:	e0a2                	sd	s0,64(sp)
 506:	fc26                	sd	s1,56(sp)
 508:	0880                	addi	s0,sp,80
 50a:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 50c:	c299                	beqz	a3,512 <printint+0x12>
 50e:	0805c963          	bltz	a1,5a0 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 512:	2581                	sext.w	a1,a1
  neg = 0;
 514:	4881                	li	a7,0
 516:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 51a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 51c:	2601                	sext.w	a2,a2
 51e:	00000517          	auipc	a0,0x0
 522:	64250513          	addi	a0,a0,1602 # b60 <digits>
 526:	883a                	mv	a6,a4
 528:	2705                	addiw	a4,a4,1
 52a:	02c5f7bb          	remuw	a5,a1,a2
 52e:	1782                	slli	a5,a5,0x20
 530:	9381                	srli	a5,a5,0x20
 532:	97aa                	add	a5,a5,a0
 534:	0007c783          	lbu	a5,0(a5)
 538:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 53c:	0005879b          	sext.w	a5,a1
 540:	02c5d5bb          	divuw	a1,a1,a2
 544:	0685                	addi	a3,a3,1
 546:	fec7f0e3          	bgeu	a5,a2,526 <printint+0x26>
  if(neg)
 54a:	00088c63          	beqz	a7,562 <printint+0x62>
    buf[i++] = '-';
 54e:	fd070793          	addi	a5,a4,-48
 552:	00878733          	add	a4,a5,s0
 556:	02d00793          	li	a5,45
 55a:	fef70423          	sb	a5,-24(a4)
 55e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 562:	02e05a63          	blez	a4,596 <printint+0x96>
 566:	f84a                	sd	s2,48(sp)
 568:	f44e                	sd	s3,40(sp)
 56a:	fb840793          	addi	a5,s0,-72
 56e:	00e78933          	add	s2,a5,a4
 572:	fff78993          	addi	s3,a5,-1
 576:	99ba                	add	s3,s3,a4
 578:	377d                	addiw	a4,a4,-1
 57a:	1702                	slli	a4,a4,0x20
 57c:	9301                	srli	a4,a4,0x20
 57e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 582:	fff94583          	lbu	a1,-1(s2)
 586:	8526                	mv	a0,s1
 588:	f5bff0ef          	jal	4e2 <putc>
  while(--i >= 0)
 58c:	197d                	addi	s2,s2,-1
 58e:	ff391ae3          	bne	s2,s3,582 <printint+0x82>
 592:	7942                	ld	s2,48(sp)
 594:	79a2                	ld	s3,40(sp)
}
 596:	60a6                	ld	ra,72(sp)
 598:	6406                	ld	s0,64(sp)
 59a:	74e2                	ld	s1,56(sp)
 59c:	6161                	addi	sp,sp,80
 59e:	8082                	ret
    x = -xx;
 5a0:	40b005bb          	negw	a1,a1
    neg = 1;
 5a4:	4885                	li	a7,1
    x = -xx;
 5a6:	bf85                	j	516 <printint+0x16>

00000000000005a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a8:	711d                	addi	sp,sp,-96
 5aa:	ec86                	sd	ra,88(sp)
 5ac:	e8a2                	sd	s0,80(sp)
 5ae:	e0ca                	sd	s2,64(sp)
 5b0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5b2:	0005c903          	lbu	s2,0(a1)
 5b6:	28090663          	beqz	s2,842 <vprintf+0x29a>
 5ba:	e4a6                	sd	s1,72(sp)
 5bc:	fc4e                	sd	s3,56(sp)
 5be:	f852                	sd	s4,48(sp)
 5c0:	f456                	sd	s5,40(sp)
 5c2:	f05a                	sd	s6,32(sp)
 5c4:	ec5e                	sd	s7,24(sp)
 5c6:	e862                	sd	s8,16(sp)
 5c8:	e466                	sd	s9,8(sp)
 5ca:	8b2a                	mv	s6,a0
 5cc:	8a2e                	mv	s4,a1
 5ce:	8bb2                	mv	s7,a2
  state = 0;
 5d0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5d2:	4481                	li	s1,0
 5d4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5d6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5da:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5de:	06c00c93          	li	s9,108
 5e2:	a005                	j	602 <vprintf+0x5a>
        putc(fd, c0);
 5e4:	85ca                	mv	a1,s2
 5e6:	855a                	mv	a0,s6
 5e8:	efbff0ef          	jal	4e2 <putc>
 5ec:	a019                	j	5f2 <vprintf+0x4a>
    } else if(state == '%'){
 5ee:	03598263          	beq	s3,s5,612 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5f2:	2485                	addiw	s1,s1,1
 5f4:	8726                	mv	a4,s1
 5f6:	009a07b3          	add	a5,s4,s1
 5fa:	0007c903          	lbu	s2,0(a5)
 5fe:	22090a63          	beqz	s2,832 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 602:	0009079b          	sext.w	a5,s2
    if(state == 0){
 606:	fe0994e3          	bnez	s3,5ee <vprintf+0x46>
      if(c0 == '%'){
 60a:	fd579de3          	bne	a5,s5,5e4 <vprintf+0x3c>
        state = '%';
 60e:	89be                	mv	s3,a5
 610:	b7cd                	j	5f2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 612:	00ea06b3          	add	a3,s4,a4
 616:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 61a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 61c:	c681                	beqz	a3,624 <vprintf+0x7c>
 61e:	9752                	add	a4,a4,s4
 620:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 624:	05878363          	beq	a5,s8,66a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 628:	05978d63          	beq	a5,s9,682 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 62c:	07500713          	li	a4,117
 630:	0ee78763          	beq	a5,a4,71e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 634:	07800713          	li	a4,120
 638:	12e78963          	beq	a5,a4,76a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 63c:	07000713          	li	a4,112
 640:	14e78e63          	beq	a5,a4,79c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 644:	06300713          	li	a4,99
 648:	18e78e63          	beq	a5,a4,7e4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 64c:	07300713          	li	a4,115
 650:	1ae78463          	beq	a5,a4,7f8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 654:	02500713          	li	a4,37
 658:	04e79563          	bne	a5,a4,6a2 <vprintf+0xfa>
        putc(fd, '%');
 65c:	02500593          	li	a1,37
 660:	855a                	mv	a0,s6
 662:	e81ff0ef          	jal	4e2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 666:	4981                	li	s3,0
 668:	b769                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4685                	li	a3,1
 670:	4629                	li	a2,10
 672:	000ba583          	lw	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	e89ff0ef          	jal	500 <printint>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	bf8d                	j	5f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 682:	06400793          	li	a5,100
 686:	02f68963          	beq	a3,a5,6b8 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 68a:	06c00793          	li	a5,108
 68e:	04f68263          	beq	a3,a5,6d2 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 692:	07500793          	li	a5,117
 696:	0af68063          	beq	a3,a5,736 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 69a:	07800793          	li	a5,120
 69e:	0ef68263          	beq	a3,a5,782 <vprintf+0x1da>
        putc(fd, '%');
 6a2:	02500593          	li	a1,37
 6a6:	855a                	mv	a0,s6
 6a8:	e3bff0ef          	jal	4e2 <putc>
        putc(fd, c0);
 6ac:	85ca                	mv	a1,s2
 6ae:	855a                	mv	a0,s6
 6b0:	e33ff0ef          	jal	4e2 <putc>
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	bf35                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4685                	li	a3,1
 6be:	4629                	li	a2,10
 6c0:	000bb583          	ld	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	e3bff0ef          	jal	500 <printint>
        i += 1;
 6ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 1;
 6d0:	b70d                	j	5f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d2:	06400793          	li	a5,100
 6d6:	02f60763          	beq	a2,a5,704 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6da:	07500793          	li	a5,117
 6de:	06f60963          	beq	a2,a5,750 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e2:	07800793          	li	a5,120
 6e6:	faf61ee3          	bne	a2,a5,6a2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000bb583          	ld	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	e09ff0ef          	jal	500 <printint>
        i += 2;
 6fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
        i += 2;
 702:	bdc5                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 704:	008b8913          	addi	s2,s7,8
 708:	4685                	li	a3,1
 70a:	4629                	li	a2,10
 70c:	000bb583          	ld	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	defff0ef          	jal	500 <printint>
        i += 2;
 716:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 718:	8bca                	mv	s7,s2
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	bdd9                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 71e:	008b8913          	addi	s2,s7,8
 722:	4681                	li	a3,0
 724:	4629                	li	a2,10
 726:	000be583          	lwu	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	dd5ff0ef          	jal	500 <printint>
 730:	8bca                	mv	s7,s2
      state = 0;
 732:	4981                	li	s3,0
 734:	bd7d                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 736:	008b8913          	addi	s2,s7,8
 73a:	4681                	li	a3,0
 73c:	4629                	li	a2,10
 73e:	000bb583          	ld	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	dbdff0ef          	jal	500 <printint>
        i += 1;
 748:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
        i += 1;
 74e:	b555                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	008b8913          	addi	s2,s7,8
 754:	4681                	li	a3,0
 756:	4629                	li	a2,10
 758:	000bb583          	ld	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	da3ff0ef          	jal	500 <printint>
        i += 2;
 762:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
        i += 2;
 768:	b569                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 76a:	008b8913          	addi	s2,s7,8
 76e:	4681                	li	a3,0
 770:	4641                	li	a2,16
 772:	000be583          	lwu	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	d89ff0ef          	jal	500 <printint>
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
 780:	bd8d                	j	5f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4641                	li	a2,16
 78a:	000bb583          	ld	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	d71ff0ef          	jal	500 <printint>
        i += 1;
 794:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
        i += 1;
 79a:	bda1                	j	5f2 <vprintf+0x4a>
 79c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 79e:	008b8d13          	addi	s10,s7,8
 7a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7a6:	03000593          	li	a1,48
 7aa:	855a                	mv	a0,s6
 7ac:	d37ff0ef          	jal	4e2 <putc>
  putc(fd, 'x');
 7b0:	07800593          	li	a1,120
 7b4:	855a                	mv	a0,s6
 7b6:	d2dff0ef          	jal	4e2 <putc>
 7ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7bc:	00000b97          	auipc	s7,0x0
 7c0:	3a4b8b93          	addi	s7,s7,932 # b60 <digits>
 7c4:	03c9d793          	srli	a5,s3,0x3c
 7c8:	97de                	add	a5,a5,s7
 7ca:	0007c583          	lbu	a1,0(a5)
 7ce:	855a                	mv	a0,s6
 7d0:	d13ff0ef          	jal	4e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d4:	0992                	slli	s3,s3,0x4
 7d6:	397d                	addiw	s2,s2,-1
 7d8:	fe0916e3          	bnez	s2,7c4 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7dc:	8bea                	mv	s7,s10
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	6d02                	ld	s10,0(sp)
 7e2:	bd01                	j	5f2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7e4:	008b8913          	addi	s2,s7,8
 7e8:	000bc583          	lbu	a1,0(s7)
 7ec:	855a                	mv	a0,s6
 7ee:	cf5ff0ef          	jal	4e2 <putc>
 7f2:	8bca                	mv	s7,s2
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	bbf5                	j	5f2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7f8:	008b8993          	addi	s3,s7,8
 7fc:	000bb903          	ld	s2,0(s7)
 800:	00090f63          	beqz	s2,81e <vprintf+0x276>
        for(; *s; s++)
 804:	00094583          	lbu	a1,0(s2)
 808:	c195                	beqz	a1,82c <vprintf+0x284>
          putc(fd, *s);
 80a:	855a                	mv	a0,s6
 80c:	cd7ff0ef          	jal	4e2 <putc>
        for(; *s; s++)
 810:	0905                	addi	s2,s2,1
 812:	00094583          	lbu	a1,0(s2)
 816:	f9f5                	bnez	a1,80a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 818:	8bce                	mv	s7,s3
      state = 0;
 81a:	4981                	li	s3,0
 81c:	bbd9                	j	5f2 <vprintf+0x4a>
          s = "(null)";
 81e:	00000917          	auipc	s2,0x0
 822:	33a90913          	addi	s2,s2,826 # b58 <malloc+0x22e>
        for(; *s; s++)
 826:	02800593          	li	a1,40
 82a:	b7c5                	j	80a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 82c:	8bce                	mv	s7,s3
      state = 0;
 82e:	4981                	li	s3,0
 830:	b3c9                	j	5f2 <vprintf+0x4a>
 832:	64a6                	ld	s1,72(sp)
 834:	79e2                	ld	s3,56(sp)
 836:	7a42                	ld	s4,48(sp)
 838:	7aa2                	ld	s5,40(sp)
 83a:	7b02                	ld	s6,32(sp)
 83c:	6be2                	ld	s7,24(sp)
 83e:	6c42                	ld	s8,16(sp)
 840:	6ca2                	ld	s9,8(sp)
    }
  }
}
 842:	60e6                	ld	ra,88(sp)
 844:	6446                	ld	s0,80(sp)
 846:	6906                	ld	s2,64(sp)
 848:	6125                	addi	sp,sp,96
 84a:	8082                	ret

000000000000084c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84c:	715d                	addi	sp,sp,-80
 84e:	ec06                	sd	ra,24(sp)
 850:	e822                	sd	s0,16(sp)
 852:	1000                	addi	s0,sp,32
 854:	e010                	sd	a2,0(s0)
 856:	e414                	sd	a3,8(s0)
 858:	e818                	sd	a4,16(s0)
 85a:	ec1c                	sd	a5,24(s0)
 85c:	03043023          	sd	a6,32(s0)
 860:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 864:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 868:	8622                	mv	a2,s0
 86a:	d3fff0ef          	jal	5a8 <vprintf>
}
 86e:	60e2                	ld	ra,24(sp)
 870:	6442                	ld	s0,16(sp)
 872:	6161                	addi	sp,sp,80
 874:	8082                	ret

0000000000000876 <printf>:

void
printf(const char *fmt, ...)
{
 876:	711d                	addi	sp,sp,-96
 878:	ec06                	sd	ra,24(sp)
 87a:	e822                	sd	s0,16(sp)
 87c:	1000                	addi	s0,sp,32
 87e:	e40c                	sd	a1,8(s0)
 880:	e810                	sd	a2,16(s0)
 882:	ec14                	sd	a3,24(s0)
 884:	f018                	sd	a4,32(s0)
 886:	f41c                	sd	a5,40(s0)
 888:	03043823          	sd	a6,48(s0)
 88c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 890:	00840613          	addi	a2,s0,8
 894:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 898:	85aa                	mv	a1,a0
 89a:	4505                	li	a0,1
 89c:	d0dff0ef          	jal	5a8 <vprintf>
}
 8a0:	60e2                	ld	ra,24(sp)
 8a2:	6442                	ld	s0,16(sp)
 8a4:	6125                	addi	sp,sp,96
 8a6:	8082                	ret

00000000000008a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a8:	1141                	addi	sp,sp,-16
 8aa:	e422                	sd	s0,8(sp)
 8ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b2:	00000797          	auipc	a5,0x0
 8b6:	74e7b783          	ld	a5,1870(a5) # 1000 <freep>
 8ba:	a02d                	j	8e4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8bc:	4618                	lw	a4,8(a2)
 8be:	9f2d                	addw	a4,a4,a1
 8c0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c4:	6398                	ld	a4,0(a5)
 8c6:	6310                	ld	a2,0(a4)
 8c8:	a83d                	j	906 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ca:	ff852703          	lw	a4,-8(a0)
 8ce:	9f31                	addw	a4,a4,a2
 8d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d2:	ff053683          	ld	a3,-16(a0)
 8d6:	a091                	j	91a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	6398                	ld	a4,0(a5)
 8da:	00e7e463          	bltu	a5,a4,8e2 <free+0x3a>
 8de:	00e6ea63          	bltu	a3,a4,8f2 <free+0x4a>
{
 8e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e4:	fed7fae3          	bgeu	a5,a3,8d8 <free+0x30>
 8e8:	6398                	ld	a4,0(a5)
 8ea:	00e6e463          	bltu	a3,a4,8f2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ee:	fee7eae3          	bltu	a5,a4,8e2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8f2:	ff852583          	lw	a1,-8(a0)
 8f6:	6390                	ld	a2,0(a5)
 8f8:	02059813          	slli	a6,a1,0x20
 8fc:	01c85713          	srli	a4,a6,0x1c
 900:	9736                	add	a4,a4,a3
 902:	fae60de3          	beq	a2,a4,8bc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 906:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 90a:	4790                	lw	a2,8(a5)
 90c:	02061593          	slli	a1,a2,0x20
 910:	01c5d713          	srli	a4,a1,0x1c
 914:	973e                	add	a4,a4,a5
 916:	fae68ae3          	beq	a3,a4,8ca <free+0x22>
    p->s.ptr = bp->s.ptr;
 91a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 91c:	00000717          	auipc	a4,0x0
 920:	6ef73223          	sd	a5,1764(a4) # 1000 <freep>
}
 924:	6422                	ld	s0,8(sp)
 926:	0141                	addi	sp,sp,16
 928:	8082                	ret

000000000000092a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 92a:	7139                	addi	sp,sp,-64
 92c:	fc06                	sd	ra,56(sp)
 92e:	f822                	sd	s0,48(sp)
 930:	f426                	sd	s1,40(sp)
 932:	ec4e                	sd	s3,24(sp)
 934:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 936:	02051493          	slli	s1,a0,0x20
 93a:	9081                	srli	s1,s1,0x20
 93c:	04bd                	addi	s1,s1,15
 93e:	8091                	srli	s1,s1,0x4
 940:	0014899b          	addiw	s3,s1,1
 944:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 946:	00000517          	auipc	a0,0x0
 94a:	6ba53503          	ld	a0,1722(a0) # 1000 <freep>
 94e:	c915                	beqz	a0,982 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 950:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 952:	4798                	lw	a4,8(a5)
 954:	08977a63          	bgeu	a4,s1,9e8 <malloc+0xbe>
 958:	f04a                	sd	s2,32(sp)
 95a:	e852                	sd	s4,16(sp)
 95c:	e456                	sd	s5,8(sp)
 95e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 960:	8a4e                	mv	s4,s3
 962:	0009871b          	sext.w	a4,s3
 966:	6685                	lui	a3,0x1
 968:	00d77363          	bgeu	a4,a3,96e <malloc+0x44>
 96c:	6a05                	lui	s4,0x1
 96e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 972:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 976:	00000917          	auipc	s2,0x0
 97a:	68a90913          	addi	s2,s2,1674 # 1000 <freep>
  if(p == SBRK_ERROR)
 97e:	5afd                	li	s5,-1
 980:	a081                	j	9c0 <malloc+0x96>
 982:	f04a                	sd	s2,32(sp)
 984:	e852                	sd	s4,16(sp)
 986:	e456                	sd	s5,8(sp)
 988:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 98a:	00000797          	auipc	a5,0x0
 98e:	68678793          	addi	a5,a5,1670 # 1010 <base>
 992:	00000717          	auipc	a4,0x0
 996:	66f73723          	sd	a5,1646(a4) # 1000 <freep>
 99a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 99c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a0:	b7c1                	j	960 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9a2:	6398                	ld	a4,0(a5)
 9a4:	e118                	sd	a4,0(a0)
 9a6:	a8a9                	j	a00 <malloc+0xd6>
  hp->s.size = nu;
 9a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ac:	0541                	addi	a0,a0,16
 9ae:	efbff0ef          	jal	8a8 <free>
  return freep;
 9b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9b6:	c12d                	beqz	a0,a18 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ba:	4798                	lw	a4,8(a5)
 9bc:	02977263          	bgeu	a4,s1,9e0 <malloc+0xb6>
    if(p == freep)
 9c0:	00093703          	ld	a4,0(s2)
 9c4:	853e                	mv	a0,a5
 9c6:	fef719e3          	bne	a4,a5,9b8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9ca:	8552                	mv	a0,s4
 9cc:	a43ff0ef          	jal	40e <sbrk>
  if(p == SBRK_ERROR)
 9d0:	fd551ce3          	bne	a0,s5,9a8 <malloc+0x7e>
        return 0;
 9d4:	4501                	li	a0,0
 9d6:	7902                	ld	s2,32(sp)
 9d8:	6a42                	ld	s4,16(sp)
 9da:	6aa2                	ld	s5,8(sp)
 9dc:	6b02                	ld	s6,0(sp)
 9de:	a03d                	j	a0c <malloc+0xe2>
 9e0:	7902                	ld	s2,32(sp)
 9e2:	6a42                	ld	s4,16(sp)
 9e4:	6aa2                	ld	s5,8(sp)
 9e6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9e8:	fae48de3          	beq	s1,a4,9a2 <malloc+0x78>
        p->s.size -= nunits;
 9ec:	4137073b          	subw	a4,a4,s3
 9f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9f2:	02071693          	slli	a3,a4,0x20
 9f6:	01c6d713          	srli	a4,a3,0x1c
 9fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a00:	00000717          	auipc	a4,0x0
 a04:	60a73023          	sd	a0,1536(a4) # 1000 <freep>
      return (void*)(p + 1);
 a08:	01078513          	addi	a0,a5,16
  }
}
 a0c:	70e2                	ld	ra,56(sp)
 a0e:	7442                	ld	s0,48(sp)
 a10:	74a2                	ld	s1,40(sp)
 a12:	69e2                	ld	s3,24(sp)
 a14:	6121                	addi	sp,sp,64
 a16:	8082                	ret
 a18:	7902                	ld	s2,32(sp)
 a1a:	6a42                	ld	s4,16(sp)
 a1c:	6aa2                	ld	s5,8(sp)
 a1e:	6b02                	ld	s6,0(sp)
 a20:	b7f5                	j	a0c <malloc+0xe2>
