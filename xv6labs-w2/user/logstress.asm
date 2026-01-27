
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ=2000 };
  
  for (int i = 1; i < argc; i++){
   0:	4785                	li	a5,1
   2:	0ea7df63          	bge	a5,a0,100 <main+0x100>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	0080                	addi	s0,sp,64
  14:	892a                	mv	s2,a0
  16:	89ae                	mv	s3,a1
  for (int i = 1; i < argc; i++){
  18:	4485                	li	s1,1
  1a:	a011                	j	1e <main+0x1e>
  1c:	84be                	mv	s1,a5
    int pid1 = fork();
  1e:	374000ef          	jal	392 <fork>
    if(pid1 < 0){
  22:	00054963          	bltz	a0,34 <main+0x34>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if(pid1 == 0) {
  26:	c11d                	beqz	a0,4c <main+0x4c>
  for (int i = 1; i < argc; i++){
  28:	0014879b          	addiw	a5,s1,1
  2c:	fef918e3          	bne	s2,a5,1c <main+0x1c>
      }
      exit(0);
    }
  }
  int xstatus;
  for(int i = 1; i < argc; i++){
  30:	4905                	li	s2,1
  32:	a04d                	j	d4 <main+0xd4>
  34:	e852                	sd	s4,16(sp)
      printf("%s: fork failed\n", argv[0]);
  36:	0009b583          	ld	a1,0(s3)
  3a:	00001517          	auipc	a0,0x1
  3e:	95650513          	addi	a0,a0,-1706 # 990 <malloc+0xfe>
  42:	79c000ef          	jal	7de <printf>
      exit(1);
  46:	4505                	li	a0,1
  48:	352000ef          	jal	39a <exit>
  4c:	e852                	sd	s4,16(sp)
      fd = open(argv[i], O_CREATE | O_RDWR);
  4e:	00349a13          	slli	s4,s1,0x3
  52:	9a4e                	add	s4,s4,s3
  54:	20200593          	li	a1,514
  58:	000a3503          	ld	a0,0(s4)
  5c:	37e000ef          	jal	3da <open>
  60:	892a                	mv	s2,a0
      if(fd < 0){
  62:	04054163          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0'+i, SZ);
  66:	7d000613          	li	a2,2000
  6a:	0304859b          	addiw	a1,s1,48
  6e:	00001517          	auipc	a0,0x1
  72:	fa250513          	addi	a0,a0,-94 # 1010 <buf>
  76:	112000ef          	jal	188 <memset>
  7a:	0fa00493          	li	s1,250
        if((n = write(fd, buf, SZ)) != SZ){
  7e:	00001997          	auipc	s3,0x1
  82:	f9298993          	addi	s3,s3,-110 # 1010 <buf>
  86:	7d000613          	li	a2,2000
  8a:	85ce                	mv	a1,s3
  8c:	854a                	mv	a0,s2
  8e:	32c000ef          	jal	3ba <write>
  92:	7d000793          	li	a5,2000
  96:	02f51463          	bne	a0,a5,be <main+0xbe>
      for(i = 0; i < N; i++){
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f4ed                	bnez	s1,86 <main+0x86>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	2fa000ef          	jal	39a <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	000a3603          	ld	a2,0(s4)
  a8:	0009b583          	ld	a1,0(s3)
  ac:	00001517          	auipc	a0,0x1
  b0:	8fc50513          	addi	a0,a0,-1796 # 9a8 <malloc+0x116>
  b4:	72a000ef          	jal	7de <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	2e0000ef          	jal	39a <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	90050513          	addi	a0,a0,-1792 # 9c0 <malloc+0x12e>
  c8:	716000ef          	jal	7de <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	2cc000ef          	jal	39a <exit>
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	fcc40513          	addi	a0,s0,-52
  d8:	2ca000ef          	jal	3a2 <wait>
    if(xstatus != 0)
  dc:	fcc42503          	lw	a0,-52(s0)
  e0:	ed09                	bnez	a0,fa <main+0xfa>
  for(int i = 1; i < argc; i++){
  e2:	0019079b          	addiw	a5,s2,1
  e6:	ff2496e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  ea:	4501                	li	a0,0
  ec:	70e2                	ld	ra,56(sp)
  ee:	7442                	ld	s0,48(sp)
  f0:	74a2                	ld	s1,40(sp)
  f2:	7902                	ld	s2,32(sp)
  f4:	69e2                	ld	s3,24(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
  fa:	e852                	sd	s4,16(sp)
      exit(xstatus);
  fc:	29e000ef          	jal	39a <exit>
}
 100:	4501                	li	a0,0
 102:	8082                	ret

0000000000000104 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 10c:	ef5ff0ef          	jal	0 <main>
  exit(0);
 110:	4501                	li	a0,0
 112:	288000ef          	jal	39a <exit>

0000000000000116 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 116:	1141                	addi	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11c:	87aa                	mv	a5,a0
 11e:	0585                	addi	a1,a1,1
 120:	0785                	addi	a5,a5,1
 122:	fff5c703          	lbu	a4,-1(a1)
 126:	fee78fa3          	sb	a4,-1(a5)
 12a:	fb75                	bnez	a4,11e <strcpy+0x8>
    ;
  return os;
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cb91                	beqz	a5,150 <strcmp+0x1e>
 13e:	0005c703          	lbu	a4,0(a1)
 142:	00f71763          	bne	a4,a5,150 <strcmp+0x1e>
    p++, q++;
 146:	0505                	addi	a0,a0,1
 148:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14a:	00054783          	lbu	a5,0(a0)
 14e:	fbe5                	bnez	a5,13e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 150:	0005c503          	lbu	a0,0(a1)
}
 154:	40a7853b          	subw	a0,a5,a0
 158:	6422                	ld	s0,8(sp)
 15a:	0141                	addi	sp,sp,16
 15c:	8082                	ret

000000000000015e <strlen>:

uint
strlen(const char *s)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e422                	sd	s0,8(sp)
 162:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 164:	00054783          	lbu	a5,0(a0)
 168:	cf91                	beqz	a5,184 <strlen+0x26>
 16a:	0505                	addi	a0,a0,1
 16c:	87aa                	mv	a5,a0
 16e:	86be                	mv	a3,a5
 170:	0785                	addi	a5,a5,1
 172:	fff7c703          	lbu	a4,-1(a5)
 176:	ff65                	bnez	a4,16e <strlen+0x10>
 178:	40a6853b          	subw	a0,a3,a0
 17c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret
  for(n = 0; s[n]; n++)
 184:	4501                	li	a0,0
 186:	bfe5                	j	17e <strlen+0x20>

0000000000000188 <memset>:

void*
memset(void *dst, int c, uint n)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18e:	ca19                	beqz	a2,1a4 <memset+0x1c>
 190:	87aa                	mv	a5,a0
 192:	1602                	slli	a2,a2,0x20
 194:	9201                	srli	a2,a2,0x20
 196:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 19a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19e:	0785                	addi	a5,a5,1
 1a0:	fee79de3          	bne	a5,a4,19a <memset+0x12>
  }
  return dst;
}
 1a4:	6422                	ld	s0,8(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strchr>:

char*
strchr(const char *s, char c)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	cb99                	beqz	a5,1ca <strchr+0x20>
    if(*s == c)
 1b6:	00f58763          	beq	a1,a5,1c4 <strchr+0x1a>
  for(; *s; s++)
 1ba:	0505                	addi	a0,a0,1
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbfd                	bnez	a5,1b6 <strchr+0xc>
      return (char*)s;
  return 0;
 1c2:	4501                	li	a0,0
}
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret
  return 0;
 1ca:	4501                	li	a0,0
 1cc:	bfe5                	j	1c4 <strchr+0x1a>

00000000000001ce <gets>:

char*
gets(char *buf, int max)
{
 1ce:	711d                	addi	sp,sp,-96
 1d0:	ec86                	sd	ra,88(sp)
 1d2:	e8a2                	sd	s0,80(sp)
 1d4:	e4a6                	sd	s1,72(sp)
 1d6:	e0ca                	sd	s2,64(sp)
 1d8:	fc4e                	sd	s3,56(sp)
 1da:	f852                	sd	s4,48(sp)
 1dc:	f456                	sd	s5,40(sp)
 1de:	f05a                	sd	s6,32(sp)
 1e0:	ec5e                	sd	s7,24(sp)
 1e2:	1080                	addi	s0,sp,96
 1e4:	8baa                	mv	s7,a0
 1e6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e8:	892a                	mv	s2,a0
 1ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ec:	4aa9                	li	s5,10
 1ee:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f0:	89a6                	mv	s3,s1
 1f2:	2485                	addiw	s1,s1,1
 1f4:	0344d663          	bge	s1,s4,220 <gets+0x52>
    cc = read(0, &c, 1);
 1f8:	4605                	li	a2,1
 1fa:	faf40593          	addi	a1,s0,-81
 1fe:	4501                	li	a0,0
 200:	1b2000ef          	jal	3b2 <read>
    if(cc < 1)
 204:	00a05e63          	blez	a0,220 <gets+0x52>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 210:	01578763          	beq	a5,s5,21e <gets+0x50>
 214:	0905                	addi	s2,s2,1
 216:	fd679de3          	bne	a5,s6,1f0 <gets+0x22>
    buf[i++] = c;
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x52>
 21e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	addi	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:

int
stat(const char *n, struct stat *st)
{
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	addi	s0,sp,32
 248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24a:	4581                	li	a1,0
 24c:	18e000ef          	jal	3da <open>
  if(fd < 0)
 250:	02054263          	bltz	a0,274 <stat+0x36>
 254:	e426                	sd	s1,8(sp)
 256:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 258:	85ca                	mv	a1,s2
 25a:	198000ef          	jal	3f2 <fstat>
 25e:	892a                	mv	s2,a0
  close(fd);
 260:	8526                	mv	a0,s1
 262:	160000ef          	jal	3c2 <close>
  return r;
 266:	64a2                	ld	s1,8(sp)
}
 268:	854a                	mv	a0,s2
 26a:	60e2                	ld	ra,24(sp)
 26c:	6442                	ld	s0,16(sp)
 26e:	6902                	ld	s2,0(sp)
 270:	6105                	addi	sp,sp,32
 272:	8082                	ret
    return -1;
 274:	597d                	li	s2,-1
 276:	bfcd                	j	268 <stat+0x2a>

0000000000000278 <atoi>:

int
atoi(const char *s)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27e:	00054683          	lbu	a3,0(a0)
 282:	fd06879b          	addiw	a5,a3,-48
 286:	0ff7f793          	zext.b	a5,a5
 28a:	4625                	li	a2,9
 28c:	02f66863          	bltu	a2,a5,2bc <atoi+0x44>
 290:	872a                	mv	a4,a0
  n = 0;
 292:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 294:	0705                	addi	a4,a4,1
 296:	0025179b          	slliw	a5,a0,0x2
 29a:	9fa9                	addw	a5,a5,a0
 29c:	0017979b          	slliw	a5,a5,0x1
 2a0:	9fb5                	addw	a5,a5,a3
 2a2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a6:	00074683          	lbu	a3,0(a4)
 2aa:	fd06879b          	addiw	a5,a3,-48
 2ae:	0ff7f793          	zext.b	a5,a5
 2b2:	fef671e3          	bgeu	a2,a5,294 <atoi+0x1c>
  return n;
}
 2b6:	6422                	ld	s0,8(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  n = 0;
 2bc:	4501                	li	a0,0
 2be:	bfe5                	j	2b6 <atoi+0x3e>

00000000000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c6:	02b57463          	bgeu	a0,a1,2ee <memmove+0x2e>
    while(n-- > 0)
 2ca:	00c05f63          	blez	a2,2e8 <memmove+0x28>
 2ce:	1602                	slli	a2,a2,0x20
 2d0:	9201                	srli	a2,a2,0x20
 2d2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d8:	0585                	addi	a1,a1,1
 2da:	0705                	addi	a4,a4,1
 2dc:	fff5c683          	lbu	a3,-1(a1)
 2e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e4:	fef71ae3          	bne	a4,a5,2d8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
    dst += n;
 2ee:	00c50733          	add	a4,a0,a2
    src += n;
 2f2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f4:	fec05ae3          	blez	a2,2e8 <memmove+0x28>
 2f8:	fff6079b          	addiw	a5,a2,-1
 2fc:	1782                	slli	a5,a5,0x20
 2fe:	9381                	srli	a5,a5,0x20
 300:	fff7c793          	not	a5,a5
 304:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 306:	15fd                	addi	a1,a1,-1
 308:	177d                	addi	a4,a4,-1
 30a:	0005c683          	lbu	a3,0(a1)
 30e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 312:	fee79ae3          	bne	a5,a4,306 <memmove+0x46>
 316:	bfc9                	j	2e8 <memmove+0x28>

0000000000000318 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31e:	ca05                	beqz	a2,34e <memcmp+0x36>
 320:	fff6069b          	addiw	a3,a2,-1
 324:	1682                	slli	a3,a3,0x20
 326:	9281                	srli	a3,a3,0x20
 328:	0685                	addi	a3,a3,1
 32a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 32c:	00054783          	lbu	a5,0(a0)
 330:	0005c703          	lbu	a4,0(a1)
 334:	00e79863          	bne	a5,a4,344 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 338:	0505                	addi	a0,a0,1
    p2++;
 33a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33c:	fed518e3          	bne	a0,a3,32c <memcmp+0x14>
  }
  return 0;
 340:	4501                	li	a0,0
 342:	a019                	j	348 <memcmp+0x30>
      return *p1 - *p2;
 344:	40e7853b          	subw	a0,a5,a4
}
 348:	6422                	ld	s0,8(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret
  return 0;
 34e:	4501                	li	a0,0
 350:	bfe5                	j	348 <memcmp+0x30>

0000000000000352 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e406                	sd	ra,8(sp)
 356:	e022                	sd	s0,0(sp)
 358:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35a:	f67ff0ef          	jal	2c0 <memmove>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <sbrk>:

char *
sbrk(int n) {
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 36e:	4585                	li	a1,1
 370:	0b2000ef          	jal	422 <sys_sbrk>
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <sbrklazy>:

char *
sbrklazy(int n) {
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 384:	4589                	li	a1,2
 386:	09c000ef          	jal	422 <sys_sbrk>
}
 38a:	60a2                	ld	ra,8(sp)
 38c:	6402                	ld	s0,0(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret

0000000000000392 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 392:	4885                	li	a7,1
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <exit>:
.global exit
exit:
 li a7, SYS_exit
 39a:	4889                	li	a7,2
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a2:	488d                	li	a7,3
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3aa:	4891                	li	a7,4
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <read>:
.global read
read:
 li a7, SYS_read
 3b2:	4895                	li	a7,5
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <write>:
.global write
write:
 li a7, SYS_write
 3ba:	48c1                	li	a7,16
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <close>:
.global close
close:
 li a7, SYS_close
 3c2:	48d5                	li	a7,21
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ca:	4899                	li	a7,6
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d2:	489d                	li	a7,7
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <open>:
.global open
open:
 li a7, SYS_open
 3da:	48bd                	li	a7,15
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e2:	48c5                	li	a7,17
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ea:	48c9                	li	a7,18
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f2:	48a1                	li	a7,8
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <link>:
.global link
link:
 li a7, SYS_link
 3fa:	48cd                	li	a7,19
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 402:	48d1                	li	a7,20
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40a:	48a5                	li	a7,9
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <dup>:
.global dup
dup:
 li a7, SYS_dup
 412:	48a9                	li	a7,10
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41a:	48ad                	li	a7,11
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 422:	48b1                	li	a7,12
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <pause>:
.global pause
pause:
 li a7, SYS_pause
 42a:	48b5                	li	a7,13
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 432:	48b9                	li	a7,14
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <hello>:
.global hello
hello:
 li a7, SYS_hello
 43a:	48dd                	li	a7,23
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
 442:	48d9                	li	a7,22
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44a:	1101                	addi	sp,sp,-32
 44c:	ec06                	sd	ra,24(sp)
 44e:	e822                	sd	s0,16(sp)
 450:	1000                	addi	s0,sp,32
 452:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 456:	4605                	li	a2,1
 458:	fef40593          	addi	a1,s0,-17
 45c:	f5fff0ef          	jal	3ba <write>
}
 460:	60e2                	ld	ra,24(sp)
 462:	6442                	ld	s0,16(sp)
 464:	6105                	addi	sp,sp,32
 466:	8082                	ret

0000000000000468 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 468:	715d                	addi	sp,sp,-80
 46a:	e486                	sd	ra,72(sp)
 46c:	e0a2                	sd	s0,64(sp)
 46e:	fc26                	sd	s1,56(sp)
 470:	0880                	addi	s0,sp,80
 472:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 474:	c299                	beqz	a3,47a <printint+0x12>
 476:	0805c963          	bltz	a1,508 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47a:	2581                	sext.w	a1,a1
  neg = 0;
 47c:	4881                	li	a7,0
 47e:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 482:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 484:	2601                	sext.w	a2,a2
 486:	00000517          	auipc	a0,0x0
 48a:	55a50513          	addi	a0,a0,1370 # 9e0 <digits>
 48e:	883a                	mv	a6,a4
 490:	2705                	addiw	a4,a4,1
 492:	02c5f7bb          	remuw	a5,a1,a2
 496:	1782                	slli	a5,a5,0x20
 498:	9381                	srli	a5,a5,0x20
 49a:	97aa                	add	a5,a5,a0
 49c:	0007c783          	lbu	a5,0(a5)
 4a0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a4:	0005879b          	sext.w	a5,a1
 4a8:	02c5d5bb          	divuw	a1,a1,a2
 4ac:	0685                	addi	a3,a3,1
 4ae:	fec7f0e3          	bgeu	a5,a2,48e <printint+0x26>
  if(neg)
 4b2:	00088c63          	beqz	a7,4ca <printint+0x62>
    buf[i++] = '-';
 4b6:	fd070793          	addi	a5,a4,-48
 4ba:	00878733          	add	a4,a5,s0
 4be:	02d00793          	li	a5,45
 4c2:	fef70423          	sb	a5,-24(a4)
 4c6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ca:	02e05a63          	blez	a4,4fe <printint+0x96>
 4ce:	f84a                	sd	s2,48(sp)
 4d0:	f44e                	sd	s3,40(sp)
 4d2:	fb840793          	addi	a5,s0,-72
 4d6:	00e78933          	add	s2,a5,a4
 4da:	fff78993          	addi	s3,a5,-1
 4de:	99ba                	add	s3,s3,a4
 4e0:	377d                	addiw	a4,a4,-1
 4e2:	1702                	slli	a4,a4,0x20
 4e4:	9301                	srli	a4,a4,0x20
 4e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ea:	fff94583          	lbu	a1,-1(s2)
 4ee:	8526                	mv	a0,s1
 4f0:	f5bff0ef          	jal	44a <putc>
  while(--i >= 0)
 4f4:	197d                	addi	s2,s2,-1
 4f6:	ff391ae3          	bne	s2,s3,4ea <printint+0x82>
 4fa:	7942                	ld	s2,48(sp)
 4fc:	79a2                	ld	s3,40(sp)
}
 4fe:	60a6                	ld	ra,72(sp)
 500:	6406                	ld	s0,64(sp)
 502:	74e2                	ld	s1,56(sp)
 504:	6161                	addi	sp,sp,80
 506:	8082                	ret
    x = -xx;
 508:	40b005bb          	negw	a1,a1
    neg = 1;
 50c:	4885                	li	a7,1
    x = -xx;
 50e:	bf85                	j	47e <printint+0x16>

0000000000000510 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 510:	711d                	addi	sp,sp,-96
 512:	ec86                	sd	ra,88(sp)
 514:	e8a2                	sd	s0,80(sp)
 516:	e0ca                	sd	s2,64(sp)
 518:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 51a:	0005c903          	lbu	s2,0(a1)
 51e:	28090663          	beqz	s2,7aa <vprintf+0x29a>
 522:	e4a6                	sd	s1,72(sp)
 524:	fc4e                	sd	s3,56(sp)
 526:	f852                	sd	s4,48(sp)
 528:	f456                	sd	s5,40(sp)
 52a:	f05a                	sd	s6,32(sp)
 52c:	ec5e                	sd	s7,24(sp)
 52e:	e862                	sd	s8,16(sp)
 530:	e466                	sd	s9,8(sp)
 532:	8b2a                	mv	s6,a0
 534:	8a2e                	mv	s4,a1
 536:	8bb2                	mv	s7,a2
  state = 0;
 538:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 53a:	4481                	li	s1,0
 53c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 53e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 542:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 546:	06c00c93          	li	s9,108
 54a:	a005                	j	56a <vprintf+0x5a>
        putc(fd, c0);
 54c:	85ca                	mv	a1,s2
 54e:	855a                	mv	a0,s6
 550:	efbff0ef          	jal	44a <putc>
 554:	a019                	j	55a <vprintf+0x4a>
    } else if(state == '%'){
 556:	03598263          	beq	s3,s5,57a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 55a:	2485                	addiw	s1,s1,1
 55c:	8726                	mv	a4,s1
 55e:	009a07b3          	add	a5,s4,s1
 562:	0007c903          	lbu	s2,0(a5)
 566:	22090a63          	beqz	s2,79a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 56a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 56e:	fe0994e3          	bnez	s3,556 <vprintf+0x46>
      if(c0 == '%'){
 572:	fd579de3          	bne	a5,s5,54c <vprintf+0x3c>
        state = '%';
 576:	89be                	mv	s3,a5
 578:	b7cd                	j	55a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 57a:	00ea06b3          	add	a3,s4,a4
 57e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 582:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 584:	c681                	beqz	a3,58c <vprintf+0x7c>
 586:	9752                	add	a4,a4,s4
 588:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 58c:	05878363          	beq	a5,s8,5d2 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 590:	05978d63          	beq	a5,s9,5ea <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 594:	07500713          	li	a4,117
 598:	0ee78763          	beq	a5,a4,686 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 59c:	07800713          	li	a4,120
 5a0:	12e78963          	beq	a5,a4,6d2 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5a4:	07000713          	li	a4,112
 5a8:	14e78e63          	beq	a5,a4,704 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5ac:	06300713          	li	a4,99
 5b0:	18e78e63          	beq	a5,a4,74c <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5b4:	07300713          	li	a4,115
 5b8:	1ae78463          	beq	a5,a4,760 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5bc:	02500713          	li	a4,37
 5c0:	04e79563          	bne	a5,a4,60a <vprintf+0xfa>
        putc(fd, '%');
 5c4:	02500593          	li	a1,37
 5c8:	855a                	mv	a0,s6
 5ca:	e81ff0ef          	jal	44a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b769                	j	55a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	e89ff0ef          	jal	468 <printint>
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	bf8d                	j	55a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5ea:	06400793          	li	a5,100
 5ee:	02f68963          	beq	a3,a5,620 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f2:	06c00793          	li	a5,108
 5f6:	04f68263          	beq	a3,a5,63a <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5fa:	07500793          	li	a5,117
 5fe:	0af68063          	beq	a3,a5,69e <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 602:	07800793          	li	a5,120
 606:	0ef68263          	beq	a3,a5,6ea <vprintf+0x1da>
        putc(fd, '%');
 60a:	02500593          	li	a1,37
 60e:	855a                	mv	a0,s6
 610:	e3bff0ef          	jal	44a <putc>
        putc(fd, c0);
 614:	85ca                	mv	a1,s2
 616:	855a                	mv	a0,s6
 618:	e33ff0ef          	jal	44a <putc>
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bf35                	j	55a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	008b8913          	addi	s2,s7,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000bb583          	ld	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	e3bff0ef          	jal	468 <printint>
        i += 1;
 632:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
        i += 1;
 638:	b70d                	j	55a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63a:	06400793          	li	a5,100
 63e:	02f60763          	beq	a2,a5,66c <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 642:	07500793          	li	a5,117
 646:	06f60963          	beq	a2,a5,6b8 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 64a:	07800793          	li	a5,120
 64e:	faf61ee3          	bne	a2,a5,60a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	008b8913          	addi	s2,s7,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000bb583          	ld	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	e09ff0ef          	jal	468 <printint>
        i += 2;
 664:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
        i += 2;
 66a:	bdc5                	j	55a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	008b8913          	addi	s2,s7,8
 670:	4685                	li	a3,1
 672:	4629                	li	a2,10
 674:	000bb583          	ld	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	defff0ef          	jal	468 <printint>
        i += 2;
 67e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
        i += 2;
 684:	bdd9                	j	55a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 686:	008b8913          	addi	s2,s7,8
 68a:	4681                	li	a3,0
 68c:	4629                	li	a2,10
 68e:	000be583          	lwu	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	dd5ff0ef          	jal	468 <printint>
 698:	8bca                	mv	s7,s2
      state = 0;
 69a:	4981                	li	s3,0
 69c:	bd7d                	j	55a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	008b8913          	addi	s2,s7,8
 6a2:	4681                	li	a3,0
 6a4:	4629                	li	a2,10
 6a6:	000bb583          	ld	a1,0(s7)
 6aa:	855a                	mv	a0,s6
 6ac:	dbdff0ef          	jal	468 <printint>
        i += 1;
 6b0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
        i += 1;
 6b6:	b555                	j	55a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	008b8913          	addi	s2,s7,8
 6bc:	4681                	li	a3,0
 6be:	4629                	li	a2,10
 6c0:	000bb583          	ld	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	da3ff0ef          	jal	468 <printint>
        i += 2;
 6ca:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
        i += 2;
 6d0:	b569                	j	55a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6d2:	008b8913          	addi	s2,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4641                	li	a2,16
 6da:	000be583          	lwu	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	d89ff0ef          	jal	468 <printint>
 6e4:	8bca                	mv	s7,s2
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bd8d                	j	55a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000bb583          	ld	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	d71ff0ef          	jal	468 <printint>
        i += 1;
 6fc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
        i += 1;
 702:	bda1                	j	55a <vprintf+0x4a>
 704:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 706:	008b8d13          	addi	s10,s7,8
 70a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 70e:	03000593          	li	a1,48
 712:	855a                	mv	a0,s6
 714:	d37ff0ef          	jal	44a <putc>
  putc(fd, 'x');
 718:	07800593          	li	a1,120
 71c:	855a                	mv	a0,s6
 71e:	d2dff0ef          	jal	44a <putc>
 722:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 724:	00000b97          	auipc	s7,0x0
 728:	2bcb8b93          	addi	s7,s7,700 # 9e0 <digits>
 72c:	03c9d793          	srli	a5,s3,0x3c
 730:	97de                	add	a5,a5,s7
 732:	0007c583          	lbu	a1,0(a5)
 736:	855a                	mv	a0,s6
 738:	d13ff0ef          	jal	44a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73c:	0992                	slli	s3,s3,0x4
 73e:	397d                	addiw	s2,s2,-1
 740:	fe0916e3          	bnez	s2,72c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 744:	8bea                	mv	s7,s10
      state = 0;
 746:	4981                	li	s3,0
 748:	6d02                	ld	s10,0(sp)
 74a:	bd01                	j	55a <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 74c:	008b8913          	addi	s2,s7,8
 750:	000bc583          	lbu	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	cf5ff0ef          	jal	44a <putc>
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bbf5                	j	55a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 760:	008b8993          	addi	s3,s7,8
 764:	000bb903          	ld	s2,0(s7)
 768:	00090f63          	beqz	s2,786 <vprintf+0x276>
        for(; *s; s++)
 76c:	00094583          	lbu	a1,0(s2)
 770:	c195                	beqz	a1,794 <vprintf+0x284>
          putc(fd, *s);
 772:	855a                	mv	a0,s6
 774:	cd7ff0ef          	jal	44a <putc>
        for(; *s; s++)
 778:	0905                	addi	s2,s2,1
 77a:	00094583          	lbu	a1,0(s2)
 77e:	f9f5                	bnez	a1,772 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 780:	8bce                	mv	s7,s3
      state = 0;
 782:	4981                	li	s3,0
 784:	bbd9                	j	55a <vprintf+0x4a>
          s = "(null)";
 786:	00000917          	auipc	s2,0x0
 78a:	25290913          	addi	s2,s2,594 # 9d8 <malloc+0x146>
        for(; *s; s++)
 78e:	02800593          	li	a1,40
 792:	b7c5                	j	772 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 794:	8bce                	mv	s7,s3
      state = 0;
 796:	4981                	li	s3,0
 798:	b3c9                	j	55a <vprintf+0x4a>
 79a:	64a6                	ld	s1,72(sp)
 79c:	79e2                	ld	s3,56(sp)
 79e:	7a42                	ld	s4,48(sp)
 7a0:	7aa2                	ld	s5,40(sp)
 7a2:	7b02                	ld	s6,32(sp)
 7a4:	6be2                	ld	s7,24(sp)
 7a6:	6c42                	ld	s8,16(sp)
 7a8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7aa:	60e6                	ld	ra,88(sp)
 7ac:	6446                	ld	s0,80(sp)
 7ae:	6906                	ld	s2,64(sp)
 7b0:	6125                	addi	sp,sp,96
 7b2:	8082                	ret

00000000000007b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b4:	715d                	addi	sp,sp,-80
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	addi	s0,sp,32
 7bc:	e010                	sd	a2,0(s0)
 7be:	e414                	sd	a3,8(s0)
 7c0:	e818                	sd	a4,16(s0)
 7c2:	ec1c                	sd	a5,24(s0)
 7c4:	03043023          	sd	a6,32(s0)
 7c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d0:	8622                	mv	a2,s0
 7d2:	d3fff0ef          	jal	510 <vprintf>
}
 7d6:	60e2                	ld	ra,24(sp)
 7d8:	6442                	ld	s0,16(sp)
 7da:	6161                	addi	sp,sp,80
 7dc:	8082                	ret

00000000000007de <printf>:

void
printf(const char *fmt, ...)
{
 7de:	711d                	addi	sp,sp,-96
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	1000                	addi	s0,sp,32
 7e6:	e40c                	sd	a1,8(s0)
 7e8:	e810                	sd	a2,16(s0)
 7ea:	ec14                	sd	a3,24(s0)
 7ec:	f018                	sd	a4,32(s0)
 7ee:	f41c                	sd	a5,40(s0)
 7f0:	03043823          	sd	a6,48(s0)
 7f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f8:	00840613          	addi	a2,s0,8
 7fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 800:	85aa                	mv	a1,a0
 802:	4505                	li	a0,1
 804:	d0dff0ef          	jal	510 <vprintf>
}
 808:	60e2                	ld	ra,24(sp)
 80a:	6442                	ld	s0,16(sp)
 80c:	6125                	addi	sp,sp,96
 80e:	8082                	ret

0000000000000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	1141                	addi	sp,sp,-16
 812:	e422                	sd	s0,8(sp)
 814:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 816:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	00000797          	auipc	a5,0x0
 81e:	7e67b783          	ld	a5,2022(a5) # 1000 <freep>
 822:	a02d                	j	84c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 824:	4618                	lw	a4,8(a2)
 826:	9f2d                	addw	a4,a4,a1
 828:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82c:	6398                	ld	a4,0(a5)
 82e:	6310                	ld	a2,0(a4)
 830:	a83d                	j	86e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 832:	ff852703          	lw	a4,-8(a0)
 836:	9f31                	addw	a4,a4,a2
 838:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83a:	ff053683          	ld	a3,-16(a0)
 83e:	a091                	j	882 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	6398                	ld	a4,0(a5)
 842:	00e7e463          	bltu	a5,a4,84a <free+0x3a>
 846:	00e6ea63          	bltu	a3,a4,85a <free+0x4a>
{
 84a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84c:	fed7fae3          	bgeu	a5,a3,840 <free+0x30>
 850:	6398                	ld	a4,0(a5)
 852:	00e6e463          	bltu	a3,a4,85a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	fee7eae3          	bltu	a5,a4,84a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 85a:	ff852583          	lw	a1,-8(a0)
 85e:	6390                	ld	a2,0(a5)
 860:	02059813          	slli	a6,a1,0x20
 864:	01c85713          	srli	a4,a6,0x1c
 868:	9736                	add	a4,a4,a3
 86a:	fae60de3          	beq	a2,a4,824 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 872:	4790                	lw	a2,8(a5)
 874:	02061593          	slli	a1,a2,0x20
 878:	01c5d713          	srli	a4,a1,0x1c
 87c:	973e                	add	a4,a4,a5
 87e:	fae68ae3          	beq	a3,a4,832 <free+0x22>
    p->s.ptr = bp->s.ptr;
 882:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 884:	00000717          	auipc	a4,0x0
 888:	76f73e23          	sd	a5,1916(a4) # 1000 <freep>
}
 88c:	6422                	ld	s0,8(sp)
 88e:	0141                	addi	sp,sp,16
 890:	8082                	ret

0000000000000892 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 892:	7139                	addi	sp,sp,-64
 894:	fc06                	sd	ra,56(sp)
 896:	f822                	sd	s0,48(sp)
 898:	f426                	sd	s1,40(sp)
 89a:	ec4e                	sd	s3,24(sp)
 89c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89e:	02051493          	slli	s1,a0,0x20
 8a2:	9081                	srli	s1,s1,0x20
 8a4:	04bd                	addi	s1,s1,15
 8a6:	8091                	srli	s1,s1,0x4
 8a8:	0014899b          	addiw	s3,s1,1
 8ac:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ae:	00000517          	auipc	a0,0x0
 8b2:	75253503          	ld	a0,1874(a0) # 1000 <freep>
 8b6:	c915                	beqz	a0,8ea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ba:	4798                	lw	a4,8(a5)
 8bc:	08977a63          	bgeu	a4,s1,950 <malloc+0xbe>
 8c0:	f04a                	sd	s2,32(sp)
 8c2:	e852                	sd	s4,16(sp)
 8c4:	e456                	sd	s5,8(sp)
 8c6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8c8:	8a4e                	mv	s4,s3
 8ca:	0009871b          	sext.w	a4,s3
 8ce:	6685                	lui	a3,0x1
 8d0:	00d77363          	bgeu	a4,a3,8d6 <malloc+0x44>
 8d4:	6a05                	lui	s4,0x1
 8d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8de:	00000917          	auipc	s2,0x0
 8e2:	72290913          	addi	s2,s2,1826 # 1000 <freep>
  if(p == SBRK_ERROR)
 8e6:	5afd                	li	s5,-1
 8e8:	a081                	j	928 <malloc+0x96>
 8ea:	f04a                	sd	s2,32(sp)
 8ec:	e852                	sd	s4,16(sp)
 8ee:	e456                	sd	s5,8(sp)
 8f0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f2:	00001797          	auipc	a5,0x1
 8f6:	91678793          	addi	a5,a5,-1770 # 1208 <base>
 8fa:	00000717          	auipc	a4,0x0
 8fe:	70f73323          	sd	a5,1798(a4) # 1000 <freep>
 902:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 904:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 908:	b7c1                	j	8c8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 90a:	6398                	ld	a4,0(a5)
 90c:	e118                	sd	a4,0(a0)
 90e:	a8a9                	j	968 <malloc+0xd6>
  hp->s.size = nu;
 910:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 914:	0541                	addi	a0,a0,16
 916:	efbff0ef          	jal	810 <free>
  return freep;
 91a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 91e:	c12d                	beqz	a0,980 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 922:	4798                	lw	a4,8(a5)
 924:	02977263          	bgeu	a4,s1,948 <malloc+0xb6>
    if(p == freep)
 928:	00093703          	ld	a4,0(s2)
 92c:	853e                	mv	a0,a5
 92e:	fef719e3          	bne	a4,a5,920 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 932:	8552                	mv	a0,s4
 934:	a33ff0ef          	jal	366 <sbrk>
  if(p == SBRK_ERROR)
 938:	fd551ce3          	bne	a0,s5,910 <malloc+0x7e>
        return 0;
 93c:	4501                	li	a0,0
 93e:	7902                	ld	s2,32(sp)
 940:	6a42                	ld	s4,16(sp)
 942:	6aa2                	ld	s5,8(sp)
 944:	6b02                	ld	s6,0(sp)
 946:	a03d                	j	974 <malloc+0xe2>
 948:	7902                	ld	s2,32(sp)
 94a:	6a42                	ld	s4,16(sp)
 94c:	6aa2                	ld	s5,8(sp)
 94e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 950:	fae48de3          	beq	s1,a4,90a <malloc+0x78>
        p->s.size -= nunits;
 954:	4137073b          	subw	a4,a4,s3
 958:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95a:	02071693          	slli	a3,a4,0x20
 95e:	01c6d713          	srli	a4,a3,0x1c
 962:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 964:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 968:	00000717          	auipc	a4,0x0
 96c:	68a73c23          	sd	a0,1688(a4) # 1000 <freep>
      return (void*)(p + 1);
 970:	01078513          	addi	a0,a5,16
  }
}
 974:	70e2                	ld	ra,56(sp)
 976:	7442                	ld	s0,48(sp)
 978:	74a2                	ld	s1,40(sp)
 97a:	69e2                	ld	s3,24(sp)
 97c:	6121                	addi	sp,sp,64
 97e:	8082                	ret
 980:	7902                	ld	s2,32(sp)
 982:	6a42                	ld	s4,16(sp)
 984:	6aa2                	ld	s5,8(sp)
 986:	6b02                	ld	s6,0(sp)
 988:	b7f5                	j	974 <malloc+0xe2>
