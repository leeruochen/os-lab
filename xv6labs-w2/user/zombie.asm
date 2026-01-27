
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2a4000ef          	jal	2ac <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2a2000ef          	jal	2b4 <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	32c000ef          	jal	344 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	288000ef          	jal	2b4 <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	86be                	mv	a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	ff65                	bnez	a4,88 <strlen+0x10>
  92:	40a6853b          	subw	a0,a3,a0
  96:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	1b2000ef          	jal	2cc <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	addi	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
    buf[i++] = c;
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	18e000ef          	jal	2f4 <open>
  if(fd < 0)
 16a:	02054263          	bltz	a0,18e <stat+0x36>
 16e:	e426                	sd	s1,8(sp)
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	198000ef          	jal	30c <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	160000ef          	jal	2dc <close>
  return r;
 180:	64a2                	ld	s1,8(sp)
}
 182:	854a                	mv	a0,s2
 184:	60e2                	ld	ra,24(sp)
 186:	6442                	ld	s0,16(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	addi	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfcd                	j	182 <stat+0x2a>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054683          	lbu	a3,0(a0)
 19c:	fd06879b          	addiw	a5,a3,-48
 1a0:	0ff7f793          	zext.b	a5,a5
 1a4:	4625                	li	a2,9
 1a6:	02f66863          	bltu	a2,a5,1d6 <atoi+0x44>
 1aa:	872a                	mv	a4,a0
  n = 0;
 1ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ae:	0705                	addi	a4,a4,1
 1b0:	0025179b          	slliw	a5,a0,0x2
 1b4:	9fa9                	addw	a5,a5,a0
 1b6:	0017979b          	slliw	a5,a5,0x1
 1ba:	9fb5                	addw	a5,a5,a3
 1bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c0:	00074683          	lbu	a3,0(a4)
 1c4:	fd06879b          	addiw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	fef671e3          	bgeu	a2,a5,1ae <atoi+0x1c>
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  n = 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <atoi+0x3e>

00000000000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e0:	02b57463          	bgeu	a0,a1,208 <memmove+0x2e>
    while(n-- > 0)
 1e4:	00c05f63          	blez	a2,202 <memmove+0x28>
 1e8:	1602                	slli	a2,a2,0x20
 1ea:	9201                	srli	a2,a2,0x20
 1ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f2:	0585                	addi	a1,a1,1
 1f4:	0705                	addi	a4,a4,1
 1f6:	fff5c683          	lbu	a3,-1(a1)
 1fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fe:	fef71ae3          	bne	a4,a5,1f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
    dst += n;
 208:	00c50733          	add	a4,a0,a2
    src += n;
 20c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20e:	fec05ae3          	blez	a2,202 <memmove+0x28>
 212:	fff6079b          	addiw	a5,a2,-1
 216:	1782                	slli	a5,a5,0x20
 218:	9381                	srli	a5,a5,0x20
 21a:	fff7c793          	not	a5,a5
 21e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 220:	15fd                	addi	a1,a1,-1
 222:	177d                	addi	a4,a4,-1
 224:	0005c683          	lbu	a3,0(a1)
 228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x46>
 230:	bfc9                	j	202 <memmove+0x28>

0000000000000232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 238:	ca05                	beqz	a2,268 <memcmp+0x36>
 23a:	fff6069b          	addiw	a3,a2,-1
 23e:	1682                	slli	a3,a3,0x20
 240:	9281                	srli	a3,a3,0x20
 242:	0685                	addi	a3,a3,1
 244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 246:	00054783          	lbu	a5,0(a0)
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00e79863          	bne	a5,a4,25e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 252:	0505                	addi	a0,a0,1
    p2++;
 254:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 256:	fed518e3          	bne	a0,a3,246 <memcmp+0x14>
  }
  return 0;
 25a:	4501                	li	a0,0
 25c:	a019                	j	262 <memcmp+0x30>
      return *p1 - *p2;
 25e:	40e7853b          	subw	a0,a5,a4
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <memcmp+0x30>

000000000000026c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 274:	f67ff0ef          	jal	1da <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <sbrk>:

char *
sbrk(int n) {
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 288:	4585                	li	a1,1
 28a:	0b2000ef          	jal	33c <sys_sbrk>
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <sbrklazy>:

char *
sbrklazy(int n) {
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 29e:	4589                	li	a1,2
 2a0:	09c000ef          	jal	33c <sys_sbrk>
}
 2a4:	60a2                	ld	ra,8(sp)
 2a6:	6402                	ld	s0,0(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret

00000000000002ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ac:	4885                	li	a7,1
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b4:	4889                	li	a7,2
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2bc:	488d                	li	a7,3
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c4:	4891                	li	a7,4
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <read>:
.global read
read:
 li a7, SYS_read
 2cc:	4895                	li	a7,5
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <write>:
.global write
write:
 li a7, SYS_write
 2d4:	48c1                	li	a7,16
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <close>:
.global close
close:
 li a7, SYS_close
 2dc:	48d5                	li	a7,21
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e4:	4899                	li	a7,6
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ec:	489d                	li	a7,7
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <open>:
.global open
open:
 li a7, SYS_open
 2f4:	48bd                	li	a7,15
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2fc:	48c5                	li	a7,17
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 304:	48c9                	li	a7,18
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 30c:	48a1                	li	a7,8
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <link>:
.global link
link:
 li a7, SYS_link
 314:	48cd                	li	a7,19
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 31c:	48d1                	li	a7,20
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 324:	48a5                	li	a7,9
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <dup>:
.global dup
dup:
 li a7, SYS_dup
 32c:	48a9                	li	a7,10
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 334:	48ad                	li	a7,11
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 33c:	48b1                	li	a7,12
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <pause>:
.global pause
pause:
 li a7, SYS_pause
 344:	48b5                	li	a7,13
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 34c:	48b9                	li	a7,14
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <hello>:
.global hello
hello:
 li a7, SYS_hello
 354:	48dd                	li	a7,23
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
 35c:	48d9                	li	a7,22
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 364:	1101                	addi	sp,sp,-32
 366:	ec06                	sd	ra,24(sp)
 368:	e822                	sd	s0,16(sp)
 36a:	1000                	addi	s0,sp,32
 36c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 370:	4605                	li	a2,1
 372:	fef40593          	addi	a1,s0,-17
 376:	f5fff0ef          	jal	2d4 <write>
}
 37a:	60e2                	ld	ra,24(sp)
 37c:	6442                	ld	s0,16(sp)
 37e:	6105                	addi	sp,sp,32
 380:	8082                	ret

0000000000000382 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 382:	715d                	addi	sp,sp,-80
 384:	e486                	sd	ra,72(sp)
 386:	e0a2                	sd	s0,64(sp)
 388:	fc26                	sd	s1,56(sp)
 38a:	0880                	addi	s0,sp,80
 38c:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38e:	c299                	beqz	a3,394 <printint+0x12>
 390:	0805c963          	bltz	a1,422 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 394:	2581                	sext.w	a1,a1
  neg = 0;
 396:	4881                	li	a7,0
 398:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 39c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 39e:	2601                	sext.w	a2,a2
 3a0:	00000517          	auipc	a0,0x0
 3a4:	51850513          	addi	a0,a0,1304 # 8b8 <digits>
 3a8:	883a                	mv	a6,a4
 3aa:	2705                	addiw	a4,a4,1
 3ac:	02c5f7bb          	remuw	a5,a1,a2
 3b0:	1782                	slli	a5,a5,0x20
 3b2:	9381                	srli	a5,a5,0x20
 3b4:	97aa                	add	a5,a5,a0
 3b6:	0007c783          	lbu	a5,0(a5)
 3ba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3be:	0005879b          	sext.w	a5,a1
 3c2:	02c5d5bb          	divuw	a1,a1,a2
 3c6:	0685                	addi	a3,a3,1
 3c8:	fec7f0e3          	bgeu	a5,a2,3a8 <printint+0x26>
  if(neg)
 3cc:	00088c63          	beqz	a7,3e4 <printint+0x62>
    buf[i++] = '-';
 3d0:	fd070793          	addi	a5,a4,-48
 3d4:	00878733          	add	a4,a5,s0
 3d8:	02d00793          	li	a5,45
 3dc:	fef70423          	sb	a5,-24(a4)
 3e0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e4:	02e05a63          	blez	a4,418 <printint+0x96>
 3e8:	f84a                	sd	s2,48(sp)
 3ea:	f44e                	sd	s3,40(sp)
 3ec:	fb840793          	addi	a5,s0,-72
 3f0:	00e78933          	add	s2,a5,a4
 3f4:	fff78993          	addi	s3,a5,-1
 3f8:	99ba                	add	s3,s3,a4
 3fa:	377d                	addiw	a4,a4,-1
 3fc:	1702                	slli	a4,a4,0x20
 3fe:	9301                	srli	a4,a4,0x20
 400:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 404:	fff94583          	lbu	a1,-1(s2)
 408:	8526                	mv	a0,s1
 40a:	f5bff0ef          	jal	364 <putc>
  while(--i >= 0)
 40e:	197d                	addi	s2,s2,-1
 410:	ff391ae3          	bne	s2,s3,404 <printint+0x82>
 414:	7942                	ld	s2,48(sp)
 416:	79a2                	ld	s3,40(sp)
}
 418:	60a6                	ld	ra,72(sp)
 41a:	6406                	ld	s0,64(sp)
 41c:	74e2                	ld	s1,56(sp)
 41e:	6161                	addi	sp,sp,80
 420:	8082                	ret
    x = -xx;
 422:	40b005bb          	negw	a1,a1
    neg = 1;
 426:	4885                	li	a7,1
    x = -xx;
 428:	bf85                	j	398 <printint+0x16>

000000000000042a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42a:	711d                	addi	sp,sp,-96
 42c:	ec86                	sd	ra,88(sp)
 42e:	e8a2                	sd	s0,80(sp)
 430:	e0ca                	sd	s2,64(sp)
 432:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 434:	0005c903          	lbu	s2,0(a1)
 438:	28090663          	beqz	s2,6c4 <vprintf+0x29a>
 43c:	e4a6                	sd	s1,72(sp)
 43e:	fc4e                	sd	s3,56(sp)
 440:	f852                	sd	s4,48(sp)
 442:	f456                	sd	s5,40(sp)
 444:	f05a                	sd	s6,32(sp)
 446:	ec5e                	sd	s7,24(sp)
 448:	e862                	sd	s8,16(sp)
 44a:	e466                	sd	s9,8(sp)
 44c:	8b2a                	mv	s6,a0
 44e:	8a2e                	mv	s4,a1
 450:	8bb2                	mv	s7,a2
  state = 0;
 452:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 454:	4481                	li	s1,0
 456:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 458:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 45c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 460:	06c00c93          	li	s9,108
 464:	a005                	j	484 <vprintf+0x5a>
        putc(fd, c0);
 466:	85ca                	mv	a1,s2
 468:	855a                	mv	a0,s6
 46a:	efbff0ef          	jal	364 <putc>
 46e:	a019                	j	474 <vprintf+0x4a>
    } else if(state == '%'){
 470:	03598263          	beq	s3,s5,494 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 474:	2485                	addiw	s1,s1,1
 476:	8726                	mv	a4,s1
 478:	009a07b3          	add	a5,s4,s1
 47c:	0007c903          	lbu	s2,0(a5)
 480:	22090a63          	beqz	s2,6b4 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 484:	0009079b          	sext.w	a5,s2
    if(state == 0){
 488:	fe0994e3          	bnez	s3,470 <vprintf+0x46>
      if(c0 == '%'){
 48c:	fd579de3          	bne	a5,s5,466 <vprintf+0x3c>
        state = '%';
 490:	89be                	mv	s3,a5
 492:	b7cd                	j	474 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 494:	00ea06b3          	add	a3,s4,a4
 498:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 49c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 49e:	c681                	beqz	a3,4a6 <vprintf+0x7c>
 4a0:	9752                	add	a4,a4,s4
 4a2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4a6:	05878363          	beq	a5,s8,4ec <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4aa:	05978d63          	beq	a5,s9,504 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ae:	07500713          	li	a4,117
 4b2:	0ee78763          	beq	a5,a4,5a0 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4b6:	07800713          	li	a4,120
 4ba:	12e78963          	beq	a5,a4,5ec <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4be:	07000713          	li	a4,112
 4c2:	14e78e63          	beq	a5,a4,61e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4c6:	06300713          	li	a4,99
 4ca:	18e78e63          	beq	a5,a4,666 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4ce:	07300713          	li	a4,115
 4d2:	1ae78463          	beq	a5,a4,67a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4d6:	02500713          	li	a4,37
 4da:	04e79563          	bne	a5,a4,524 <vprintf+0xfa>
        putc(fd, '%');
 4de:	02500593          	li	a1,37
 4e2:	855a                	mv	a0,s6
 4e4:	e81ff0ef          	jal	364 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4e8:	4981                	li	s3,0
 4ea:	b769                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4ec:	008b8913          	addi	s2,s7,8
 4f0:	4685                	li	a3,1
 4f2:	4629                	li	a2,10
 4f4:	000ba583          	lw	a1,0(s7)
 4f8:	855a                	mv	a0,s6
 4fa:	e89ff0ef          	jal	382 <printint>
 4fe:	8bca                	mv	s7,s2
      state = 0;
 500:	4981                	li	s3,0
 502:	bf8d                	j	474 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 504:	06400793          	li	a5,100
 508:	02f68963          	beq	a3,a5,53a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 50c:	06c00793          	li	a5,108
 510:	04f68263          	beq	a3,a5,554 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 514:	07500793          	li	a5,117
 518:	0af68063          	beq	a3,a5,5b8 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 51c:	07800793          	li	a5,120
 520:	0ef68263          	beq	a3,a5,604 <vprintf+0x1da>
        putc(fd, '%');
 524:	02500593          	li	a1,37
 528:	855a                	mv	a0,s6
 52a:	e3bff0ef          	jal	364 <putc>
        putc(fd, c0);
 52e:	85ca                	mv	a1,s2
 530:	855a                	mv	a0,s6
 532:	e33ff0ef          	jal	364 <putc>
      state = 0;
 536:	4981                	li	s3,0
 538:	bf35                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53a:	008b8913          	addi	s2,s7,8
 53e:	4685                	li	a3,1
 540:	4629                	li	a2,10
 542:	000bb583          	ld	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	e3bff0ef          	jal	382 <printint>
        i += 1;
 54c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 54e:	8bca                	mv	s7,s2
      state = 0;
 550:	4981                	li	s3,0
        i += 1;
 552:	b70d                	j	474 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 554:	06400793          	li	a5,100
 558:	02f60763          	beq	a2,a5,586 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 55c:	07500793          	li	a5,117
 560:	06f60963          	beq	a2,a5,5d2 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 564:	07800793          	li	a5,120
 568:	faf61ee3          	bne	a2,a5,524 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 56c:	008b8913          	addi	s2,s7,8
 570:	4681                	li	a3,0
 572:	4641                	li	a2,16
 574:	000bb583          	ld	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	e09ff0ef          	jal	382 <printint>
        i += 2;
 57e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 580:	8bca                	mv	s7,s2
      state = 0;
 582:	4981                	li	s3,0
        i += 2;
 584:	bdc5                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	008b8913          	addi	s2,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000bb583          	ld	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	defff0ef          	jal	382 <printint>
        i += 2;
 598:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
        i += 2;
 59e:	bdd9                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4629                	li	a2,10
 5a8:	000be583          	lwu	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	dd5ff0ef          	jal	382 <printint>
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bd7d                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4629                	li	a2,10
 5c0:	000bb583          	ld	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	dbdff0ef          	jal	382 <printint>
        i += 1;
 5ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
        i += 1;
 5d0:	b555                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4629                	li	a2,10
 5da:	000bb583          	ld	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	da3ff0ef          	jal	382 <printint>
        i += 2;
 5e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
        i += 2;
 5ea:	b569                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4641                	li	a2,16
 5f4:	000be583          	lwu	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	d89ff0ef          	jal	382 <printint>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	bd8d                	j	474 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 604:	008b8913          	addi	s2,s7,8
 608:	4681                	li	a3,0
 60a:	4641                	li	a2,16
 60c:	000bb583          	ld	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	d71ff0ef          	jal	382 <printint>
        i += 1;
 616:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
        i += 1;
 61c:	bda1                	j	474 <vprintf+0x4a>
 61e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 620:	008b8d13          	addi	s10,s7,8
 624:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 628:	03000593          	li	a1,48
 62c:	855a                	mv	a0,s6
 62e:	d37ff0ef          	jal	364 <putc>
  putc(fd, 'x');
 632:	07800593          	li	a1,120
 636:	855a                	mv	a0,s6
 638:	d2dff0ef          	jal	364 <putc>
 63c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63e:	00000b97          	auipc	s7,0x0
 642:	27ab8b93          	addi	s7,s7,634 # 8b8 <digits>
 646:	03c9d793          	srli	a5,s3,0x3c
 64a:	97de                	add	a5,a5,s7
 64c:	0007c583          	lbu	a1,0(a5)
 650:	855a                	mv	a0,s6
 652:	d13ff0ef          	jal	364 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 656:	0992                	slli	s3,s3,0x4
 658:	397d                	addiw	s2,s2,-1
 65a:	fe0916e3          	bnez	s2,646 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 65e:	8bea                	mv	s7,s10
      state = 0;
 660:	4981                	li	s3,0
 662:	6d02                	ld	s10,0(sp)
 664:	bd01                	j	474 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 666:	008b8913          	addi	s2,s7,8
 66a:	000bc583          	lbu	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	cf5ff0ef          	jal	364 <putc>
 674:	8bca                	mv	s7,s2
      state = 0;
 676:	4981                	li	s3,0
 678:	bbf5                	j	474 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 67a:	008b8993          	addi	s3,s7,8
 67e:	000bb903          	ld	s2,0(s7)
 682:	00090f63          	beqz	s2,6a0 <vprintf+0x276>
        for(; *s; s++)
 686:	00094583          	lbu	a1,0(s2)
 68a:	c195                	beqz	a1,6ae <vprintf+0x284>
          putc(fd, *s);
 68c:	855a                	mv	a0,s6
 68e:	cd7ff0ef          	jal	364 <putc>
        for(; *s; s++)
 692:	0905                	addi	s2,s2,1
 694:	00094583          	lbu	a1,0(s2)
 698:	f9f5                	bnez	a1,68c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 69a:	8bce                	mv	s7,s3
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bbd9                	j	474 <vprintf+0x4a>
          s = "(null)";
 6a0:	00000917          	auipc	s2,0x0
 6a4:	21090913          	addi	s2,s2,528 # 8b0 <malloc+0x104>
        for(; *s; s++)
 6a8:	02800593          	li	a1,40
 6ac:	b7c5                	j	68c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6ae:	8bce                	mv	s7,s3
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b3c9                	j	474 <vprintf+0x4a>
 6b4:	64a6                	ld	s1,72(sp)
 6b6:	79e2                	ld	s3,56(sp)
 6b8:	7a42                	ld	s4,48(sp)
 6ba:	7aa2                	ld	s5,40(sp)
 6bc:	7b02                	ld	s6,32(sp)
 6be:	6be2                	ld	s7,24(sp)
 6c0:	6c42                	ld	s8,16(sp)
 6c2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6c4:	60e6                	ld	ra,88(sp)
 6c6:	6446                	ld	s0,80(sp)
 6c8:	6906                	ld	s2,64(sp)
 6ca:	6125                	addi	sp,sp,96
 6cc:	8082                	ret

00000000000006ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ce:	715d                	addi	sp,sp,-80
 6d0:	ec06                	sd	ra,24(sp)
 6d2:	e822                	sd	s0,16(sp)
 6d4:	1000                	addi	s0,sp,32
 6d6:	e010                	sd	a2,0(s0)
 6d8:	e414                	sd	a3,8(s0)
 6da:	e818                	sd	a4,16(s0)
 6dc:	ec1c                	sd	a5,24(s0)
 6de:	03043023          	sd	a6,32(s0)
 6e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ea:	8622                	mv	a2,s0
 6ec:	d3fff0ef          	jal	42a <vprintf>
}
 6f0:	60e2                	ld	ra,24(sp)
 6f2:	6442                	ld	s0,16(sp)
 6f4:	6161                	addi	sp,sp,80
 6f6:	8082                	ret

00000000000006f8 <printf>:

void
printf(const char *fmt, ...)
{
 6f8:	711d                	addi	sp,sp,-96
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e40c                	sd	a1,8(s0)
 702:	e810                	sd	a2,16(s0)
 704:	ec14                	sd	a3,24(s0)
 706:	f018                	sd	a4,32(s0)
 708:	f41c                	sd	a5,40(s0)
 70a:	03043823          	sd	a6,48(s0)
 70e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 712:	00840613          	addi	a2,s0,8
 716:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 71a:	85aa                	mv	a1,a0
 71c:	4505                	li	a0,1
 71e:	d0dff0ef          	jal	42a <vprintf>
}
 722:	60e2                	ld	ra,24(sp)
 724:	6442                	ld	s0,16(sp)
 726:	6125                	addi	sp,sp,96
 728:	8082                	ret

000000000000072a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72a:	1141                	addi	sp,sp,-16
 72c:	e422                	sd	s0,8(sp)
 72e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 730:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 734:	00001797          	auipc	a5,0x1
 738:	8cc7b783          	ld	a5,-1844(a5) # 1000 <freep>
 73c:	a02d                	j	766 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73e:	4618                	lw	a4,8(a2)
 740:	9f2d                	addw	a4,a4,a1
 742:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 746:	6398                	ld	a4,0(a5)
 748:	6310                	ld	a2,0(a4)
 74a:	a83d                	j	788 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 74c:	ff852703          	lw	a4,-8(a0)
 750:	9f31                	addw	a4,a4,a2
 752:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 754:	ff053683          	ld	a3,-16(a0)
 758:	a091                	j	79c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75a:	6398                	ld	a4,0(a5)
 75c:	00e7e463          	bltu	a5,a4,764 <free+0x3a>
 760:	00e6ea63          	bltu	a3,a4,774 <free+0x4a>
{
 764:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 766:	fed7fae3          	bgeu	a5,a3,75a <free+0x30>
 76a:	6398                	ld	a4,0(a5)
 76c:	00e6e463          	bltu	a3,a4,774 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	fee7eae3          	bltu	a5,a4,764 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 774:	ff852583          	lw	a1,-8(a0)
 778:	6390                	ld	a2,0(a5)
 77a:	02059813          	slli	a6,a1,0x20
 77e:	01c85713          	srli	a4,a6,0x1c
 782:	9736                	add	a4,a4,a3
 784:	fae60de3          	beq	a2,a4,73e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 788:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 78c:	4790                	lw	a2,8(a5)
 78e:	02061593          	slli	a1,a2,0x20
 792:	01c5d713          	srli	a4,a1,0x1c
 796:	973e                	add	a4,a4,a5
 798:	fae68ae3          	beq	a3,a4,74c <free+0x22>
    p->s.ptr = bp->s.ptr;
 79c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79e:	00001717          	auipc	a4,0x1
 7a2:	86f73123          	sd	a5,-1950(a4) # 1000 <freep>
}
 7a6:	6422                	ld	s0,8(sp)
 7a8:	0141                	addi	sp,sp,16
 7aa:	8082                	ret

00000000000007ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ac:	7139                	addi	sp,sp,-64
 7ae:	fc06                	sd	ra,56(sp)
 7b0:	f822                	sd	s0,48(sp)
 7b2:	f426                	sd	s1,40(sp)
 7b4:	ec4e                	sd	s3,24(sp)
 7b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b8:	02051493          	slli	s1,a0,0x20
 7bc:	9081                	srli	s1,s1,0x20
 7be:	04bd                	addi	s1,s1,15
 7c0:	8091                	srli	s1,s1,0x4
 7c2:	0014899b          	addiw	s3,s1,1
 7c6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c8:	00001517          	auipc	a0,0x1
 7cc:	83853503          	ld	a0,-1992(a0) # 1000 <freep>
 7d0:	c915                	beqz	a0,804 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d4:	4798                	lw	a4,8(a5)
 7d6:	08977a63          	bgeu	a4,s1,86a <malloc+0xbe>
 7da:	f04a                	sd	s2,32(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e2:	8a4e                	mv	s4,s3
 7e4:	0009871b          	sext.w	a4,s3
 7e8:	6685                	lui	a3,0x1
 7ea:	00d77363          	bgeu	a4,a3,7f0 <malloc+0x44>
 7ee:	6a05                	lui	s4,0x1
 7f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f8:	00001917          	auipc	s2,0x1
 7fc:	80890913          	addi	s2,s2,-2040 # 1000 <freep>
  if(p == SBRK_ERROR)
 800:	5afd                	li	s5,-1
 802:	a081                	j	842 <malloc+0x96>
 804:	f04a                	sd	s2,32(sp)
 806:	e852                	sd	s4,16(sp)
 808:	e456                	sd	s5,8(sp)
 80a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 80c:	00001797          	auipc	a5,0x1
 810:	80478793          	addi	a5,a5,-2044 # 1010 <base>
 814:	00000717          	auipc	a4,0x0
 818:	7ef73623          	sd	a5,2028(a4) # 1000 <freep>
 81c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 822:	b7c1                	j	7e2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 824:	6398                	ld	a4,0(a5)
 826:	e118                	sd	a4,0(a0)
 828:	a8a9                	j	882 <malloc+0xd6>
  hp->s.size = nu;
 82a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82e:	0541                	addi	a0,a0,16
 830:	efbff0ef          	jal	72a <free>
  return freep;
 834:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 838:	c12d                	beqz	a0,89a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83c:	4798                	lw	a4,8(a5)
 83e:	02977263          	bgeu	a4,s1,862 <malloc+0xb6>
    if(p == freep)
 842:	00093703          	ld	a4,0(s2)
 846:	853e                	mv	a0,a5
 848:	fef719e3          	bne	a4,a5,83a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 84c:	8552                	mv	a0,s4
 84e:	a33ff0ef          	jal	280 <sbrk>
  if(p == SBRK_ERROR)
 852:	fd551ce3          	bne	a0,s5,82a <malloc+0x7e>
        return 0;
 856:	4501                	li	a0,0
 858:	7902                	ld	s2,32(sp)
 85a:	6a42                	ld	s4,16(sp)
 85c:	6aa2                	ld	s5,8(sp)
 85e:	6b02                	ld	s6,0(sp)
 860:	a03d                	j	88e <malloc+0xe2>
 862:	7902                	ld	s2,32(sp)
 864:	6a42                	ld	s4,16(sp)
 866:	6aa2                	ld	s5,8(sp)
 868:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 86a:	fae48de3          	beq	s1,a4,824 <malloc+0x78>
        p->s.size -= nunits;
 86e:	4137073b          	subw	a4,a4,s3
 872:	c798                	sw	a4,8(a5)
        p += p->s.size;
 874:	02071693          	slli	a3,a4,0x20
 878:	01c6d713          	srli	a4,a3,0x1c
 87c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 882:	00000717          	auipc	a4,0x0
 886:	76a73f23          	sd	a0,1918(a4) # 1000 <freep>
      return (void*)(p + 1);
 88a:	01078513          	addi	a0,a5,16
  }
}
 88e:	70e2                	ld	ra,56(sp)
 890:	7442                	ld	s0,48(sp)
 892:	74a2                	ld	s1,40(sp)
 894:	69e2                	ld	s3,24(sp)
 896:	6121                	addi	sp,sp,64
 898:	8082                	ret
 89a:	7902                	ld	s2,32(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
 8a2:	b7f5                	j	88e <malloc+0xe2>
