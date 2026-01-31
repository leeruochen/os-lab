
user/_sniffer:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
// memset() is omitted in kernel/vm.c and kernel/kalloc.c, this creates a bug
// that can be exploited to leak data from kernel memory.
// a function that uses sbrk() to allocate memory may receive the leaked data

int main(int argc, char *argv[])
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	e45e                	sd	s7,8(sp)
  14:	0880                	addi	s0,sp,80
  int size = 8 * 4096;
  char *helper = "This may help.";

  char *memory = sbrk(size);
  16:	6521                	lui	a0,0x8
  18:	2ee000ef          	jal	306 <sbrk>
  if (memory == (char *)-1) // if sbrk fails, it will allocate (char *)-1
  1c:	57fd                	li	a5,-1
  1e:	00f50c63          	beq	a0,a5,36 <main+0x36>
  22:	8baa                	mv	s7,a0
  24:	89aa                	mv	s3,a0
  {
    exit(1);
  }
  for (int i = 0; i < size - 16; i++)
  26:	4a81                	li	s5,0
  {
    int found = 1;
    for (int j = 0; j < strlen(helper); j++)
  28:	00001a17          	auipc	s4,0x1
  2c:	908a0a13          	addi	s4,s4,-1784 # 930 <malloc+0x106>
  for (int i = 0; i < size - 16; i++)
  30:	6b21                	lui	s6,0x8
  32:	1b41                	addi	s6,s6,-16 # 7ff0 <base+0x6fe0>
  34:	a025                	j	5c <main+0x5c>
    exit(1);
  36:	4505                	li	a0,1
  38:	302000ef          	jal	33a <exit>
      }
    }

    if (found) // if inner loop didnt set found to 0, we found it
    {
      printf("%s\n", &memory[i + 16]);
  3c:	010a859b          	addiw	a1,s5,16
  40:	95de                	add	a1,a1,s7
  42:	00001517          	auipc	a0,0x1
  46:	8fe50513          	addi	a0,a0,-1794 # 940 <malloc+0x116>
  4a:	72c000ef          	jal	776 <printf>
      exit(0);
  4e:	4501                	li	a0,0
  50:	2ea000ef          	jal	33a <exit>
  for (int i = 0; i < size - 16; i++)
  54:	2a85                	addiw	s5,s5,1
  56:	0985                	addi	s3,s3,1
  58:	036a8a63          	beq	s5,s6,8c <main+0x8c>
  5c:	00001917          	auipc	s2,0x1
  60:	8d490913          	addi	s2,s2,-1836 # 930 <malloc+0x106>
{
  64:	4481                	li	s1,0
    for (int j = 0; j < strlen(helper); j++)
  66:	8552                	mv	a0,s4
  68:	096000ef          	jal	fe <strlen>
  6c:	2501                	sext.w	a0,a0
  6e:	0004879b          	sext.w	a5,s1
  72:	fca7f5e3          	bgeu	a5,a0,3c <main+0x3c>
      if (memory[i + j] != helper[j]) // if first byte mismatches, break
  76:	009987b3          	add	a5,s3,s1
  7a:	0007c703          	lbu	a4,0(a5)
  7e:	00094783          	lbu	a5,0(s2)
  82:	0485                	addi	s1,s1,1
  84:	0905                	addi	s2,s2,1
  86:	fef700e3          	beq	a4,a5,66 <main+0x66>
  8a:	b7e9                	j	54 <main+0x54>
    }
  }
  8c:	4501                	li	a0,0
  8e:	60a6                	ld	ra,72(sp)
  90:	6406                	ld	s0,64(sp)
  92:	74e2                	ld	s1,56(sp)
  94:	7942                	ld	s2,48(sp)
  96:	79a2                	ld	s3,40(sp)
  98:	7a02                	ld	s4,32(sp)
  9a:	6ae2                	ld	s5,24(sp)
  9c:	6b42                	ld	s6,16(sp)
  9e:	6ba2                	ld	s7,8(sp)
  a0:	6161                	addi	sp,sp,80
  a2:	8082                	ret

00000000000000a4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e406                	sd	ra,8(sp)
  a8:	e022                	sd	s0,0(sp)
  aa:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ac:	f55ff0ef          	jal	0 <main>
  exit(0);
  b0:	4501                	li	a0,0
  b2:	288000ef          	jal	33a <exit>

00000000000000b6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  bc:	87aa                	mv	a5,a0
  be:	0585                	addi	a1,a1,1
  c0:	0785                	addi	a5,a5,1
  c2:	fff5c703          	lbu	a4,-1(a1)
  c6:	fee78fa3          	sb	a4,-1(a5)
  ca:	fb75                	bnez	a4,be <strcpy+0x8>
    ;
  return os;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cb91                	beqz	a5,f0 <strcmp+0x1e>
  de:	0005c703          	lbu	a4,0(a1)
  e2:	00f71763          	bne	a4,a5,f0 <strcmp+0x1e>
    p++, q++;
  e6:	0505                	addi	a0,a0,1
  e8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbe5                	bnez	a5,de <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  f0:	0005c503          	lbu	a0,0(a1)
}
  f4:	40a7853b          	subw	a0,a5,a0
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret

00000000000000fe <strlen>:

uint
strlen(const char *s)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 104:	00054783          	lbu	a5,0(a0)
 108:	cf91                	beqz	a5,124 <strlen+0x26>
 10a:	0505                	addi	a0,a0,1
 10c:	87aa                	mv	a5,a0
 10e:	86be                	mv	a3,a5
 110:	0785                	addi	a5,a5,1
 112:	fff7c703          	lbu	a4,-1(a5)
 116:	ff65                	bnez	a4,10e <strlen+0x10>
 118:	40a6853b          	subw	a0,a3,a0
 11c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  for(n = 0; s[n]; n++)
 124:	4501                	li	a0,0
 126:	bfe5                	j	11e <strlen+0x20>

0000000000000128 <memset>:

void*
memset(void *dst, int c, uint n)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 12e:	ca19                	beqz	a2,144 <memset+0x1c>
 130:	87aa                	mv	a5,a0
 132:	1602                	slli	a2,a2,0x20
 134:	9201                	srli	a2,a2,0x20
 136:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 13a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 13e:	0785                	addi	a5,a5,1
 140:	fee79de3          	bne	a5,a4,13a <memset+0x12>
  }
  return dst;
}
 144:	6422                	ld	s0,8(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret

000000000000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e422                	sd	s0,8(sp)
 14e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cb99                	beqz	a5,16a <strchr+0x20>
    if(*s == c)
 156:	00f58763          	beq	a1,a5,164 <strchr+0x1a>
  for(; *s; s++)
 15a:	0505                	addi	a0,a0,1
 15c:	00054783          	lbu	a5,0(a0)
 160:	fbfd                	bnez	a5,156 <strchr+0xc>
      return (char*)s;
  return 0;
 162:	4501                	li	a0,0
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret
  return 0;
 16a:	4501                	li	a0,0
 16c:	bfe5                	j	164 <strchr+0x1a>

000000000000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	711d                	addi	sp,sp,-96
 170:	ec86                	sd	ra,88(sp)
 172:	e8a2                	sd	s0,80(sp)
 174:	e4a6                	sd	s1,72(sp)
 176:	e0ca                	sd	s2,64(sp)
 178:	fc4e                	sd	s3,56(sp)
 17a:	f852                	sd	s4,48(sp)
 17c:	f456                	sd	s5,40(sp)
 17e:	f05a                	sd	s6,32(sp)
 180:	ec5e                	sd	s7,24(sp)
 182:	1080                	addi	s0,sp,96
 184:	8baa                	mv	s7,a0
 186:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 188:	892a                	mv	s2,a0
 18a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 18c:	4aa9                	li	s5,10
 18e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 190:	89a6                	mv	s3,s1
 192:	2485                	addiw	s1,s1,1
 194:	0344d663          	bge	s1,s4,1c0 <gets+0x52>
    cc = read(0, &c, 1);
 198:	4605                	li	a2,1
 19a:	faf40593          	addi	a1,s0,-81
 19e:	4501                	li	a0,0
 1a0:	1b2000ef          	jal	352 <read>
    if(cc < 1)
 1a4:	00a05e63          	blez	a0,1c0 <gets+0x52>
    buf[i++] = c;
 1a8:	faf44783          	lbu	a5,-81(s0)
 1ac:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1b0:	01578763          	beq	a5,s5,1be <gets+0x50>
 1b4:	0905                	addi	s2,s2,1
 1b6:	fd679de3          	bne	a5,s6,190 <gets+0x22>
    buf[i++] = c;
 1ba:	89a6                	mv	s3,s1
 1bc:	a011                	j	1c0 <gets+0x52>
 1be:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1c0:	99de                	add	s3,s3,s7
 1c2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c6:	855e                	mv	a0,s7
 1c8:	60e6                	ld	ra,88(sp)
 1ca:	6446                	ld	s0,80(sp)
 1cc:	64a6                	ld	s1,72(sp)
 1ce:	6906                	ld	s2,64(sp)
 1d0:	79e2                	ld	s3,56(sp)
 1d2:	7a42                	ld	s4,48(sp)
 1d4:	7aa2                	ld	s5,40(sp)
 1d6:	7b02                	ld	s6,32(sp)
 1d8:	6be2                	ld	s7,24(sp)
 1da:	6125                	addi	sp,sp,96
 1dc:	8082                	ret

00000000000001de <stat>:

int
stat(const char *n, struct stat *st)
{
 1de:	1101                	addi	sp,sp,-32
 1e0:	ec06                	sd	ra,24(sp)
 1e2:	e822                	sd	s0,16(sp)
 1e4:	e04a                	sd	s2,0(sp)
 1e6:	1000                	addi	s0,sp,32
 1e8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ea:	4581                	li	a1,0
 1ec:	18e000ef          	jal	37a <open>
  if(fd < 0)
 1f0:	02054263          	bltz	a0,214 <stat+0x36>
 1f4:	e426                	sd	s1,8(sp)
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	198000ef          	jal	392 <fstat>
 1fe:	892a                	mv	s2,a0
  close(fd);
 200:	8526                	mv	a0,s1
 202:	160000ef          	jal	362 <close>
  return r;
 206:	64a2                	ld	s1,8(sp)
}
 208:	854a                	mv	a0,s2
 20a:	60e2                	ld	ra,24(sp)
 20c:	6442                	ld	s0,16(sp)
 20e:	6902                	ld	s2,0(sp)
 210:	6105                	addi	sp,sp,32
 212:	8082                	ret
    return -1;
 214:	597d                	li	s2,-1
 216:	bfcd                	j	208 <stat+0x2a>

0000000000000218 <atoi>:

int
atoi(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21e:	00054683          	lbu	a3,0(a0)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	4625                	li	a2,9
 22c:	02f66863          	bltu	a2,a5,25c <atoi+0x44>
 230:	872a                	mv	a4,a0
  n = 0;
 232:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 234:	0705                	addi	a4,a4,1
 236:	0025179b          	slliw	a5,a0,0x2
 23a:	9fa9                	addw	a5,a5,a0
 23c:	0017979b          	slliw	a5,a5,0x1
 240:	9fb5                	addw	a5,a5,a3
 242:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 246:	00074683          	lbu	a3,0(a4)
 24a:	fd06879b          	addiw	a5,a3,-48
 24e:	0ff7f793          	zext.b	a5,a5
 252:	fef671e3          	bgeu	a2,a5,234 <atoi+0x1c>
  return n;
}
 256:	6422                	ld	s0,8(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
  n = 0;
 25c:	4501                	li	a0,0
 25e:	bfe5                	j	256 <atoi+0x3e>

0000000000000260 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e422                	sd	s0,8(sp)
 264:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 266:	02b57463          	bgeu	a0,a1,28e <memmove+0x2e>
    while(n-- > 0)
 26a:	00c05f63          	blez	a2,288 <memmove+0x28>
 26e:	1602                	slli	a2,a2,0x20
 270:	9201                	srli	a2,a2,0x20
 272:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 276:	872a                	mv	a4,a0
      *dst++ = *src++;
 278:	0585                	addi	a1,a1,1
 27a:	0705                	addi	a4,a4,1
 27c:	fff5c683          	lbu	a3,-1(a1)
 280:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 284:	fef71ae3          	bne	a4,a5,278 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
    dst += n;
 28e:	00c50733          	add	a4,a0,a2
    src += n;
 292:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 294:	fec05ae3          	blez	a2,288 <memmove+0x28>
 298:	fff6079b          	addiw	a5,a2,-1
 29c:	1782                	slli	a5,a5,0x20
 29e:	9381                	srli	a5,a5,0x20
 2a0:	fff7c793          	not	a5,a5
 2a4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a6:	15fd                	addi	a1,a1,-1
 2a8:	177d                	addi	a4,a4,-1
 2aa:	0005c683          	lbu	a3,0(a1)
 2ae:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b2:	fee79ae3          	bne	a5,a4,2a6 <memmove+0x46>
 2b6:	bfc9                	j	288 <memmove+0x28>

00000000000002b8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2be:	ca05                	beqz	a2,2ee <memcmp+0x36>
 2c0:	fff6069b          	addiw	a3,a2,-1
 2c4:	1682                	slli	a3,a3,0x20
 2c6:	9281                	srli	a3,a3,0x20
 2c8:	0685                	addi	a3,a3,1
 2ca:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	0005c703          	lbu	a4,0(a1)
 2d4:	00e79863          	bne	a5,a4,2e4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2d8:	0505                	addi	a0,a0,1
    p2++;
 2da:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2dc:	fed518e3          	bne	a0,a3,2cc <memcmp+0x14>
  }
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	a019                	j	2e8 <memcmp+0x30>
      return *p1 - *p2;
 2e4:	40e7853b          	subw	a0,a5,a4
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
  return 0;
 2ee:	4501                	li	a0,0
 2f0:	bfe5                	j	2e8 <memcmp+0x30>

00000000000002f2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2fa:	f67ff0ef          	jal	260 <memmove>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <sbrk>:

char *
sbrk(int n) {
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 30e:	4585                	li	a1,1
 310:	0b2000ef          	jal	3c2 <sys_sbrk>
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <sbrklazy>:

char *
sbrklazy(int n) {
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 324:	4589                	li	a1,2
 326:	09c000ef          	jal	3c2 <sys_sbrk>
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret

0000000000000332 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 332:	4885                	li	a7,1
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <exit>:
.global exit
exit:
 li a7, SYS_exit
 33a:	4889                	li	a7,2
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <wait>:
.global wait
wait:
 li a7, SYS_wait
 342:	488d                	li	a7,3
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 34a:	4891                	li	a7,4
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <read>:
.global read
read:
 li a7, SYS_read
 352:	4895                	li	a7,5
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <write>:
.global write
write:
 li a7, SYS_write
 35a:	48c1                	li	a7,16
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <close>:
.global close
close:
 li a7, SYS_close
 362:	48d5                	li	a7,21
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <kill>:
.global kill
kill:
 li a7, SYS_kill
 36a:	4899                	li	a7,6
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <exec>:
.global exec
exec:
 li a7, SYS_exec
 372:	489d                	li	a7,7
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <open>:
.global open
open:
 li a7, SYS_open
 37a:	48bd                	li	a7,15
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 382:	48c5                	li	a7,17
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 38a:	48c9                	li	a7,18
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 392:	48a1                	li	a7,8
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <link>:
.global link
link:
 li a7, SYS_link
 39a:	48cd                	li	a7,19
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a2:	48d1                	li	a7,20
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3aa:	48a5                	li	a7,9
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b2:	48a9                	li	a7,10
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ba:	48ad                	li	a7,11
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3c2:	48b1                	li	a7,12
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ca:	48b5                	li	a7,13
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d2:	48b9                	li	a7,14
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <monitor>:
.global monitor
monitor:
 li a7, SYS_monitor
 3da:	48d9                	li	a7,22
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e2:	1101                	addi	sp,sp,-32
 3e4:	ec06                	sd	ra,24(sp)
 3e6:	e822                	sd	s0,16(sp)
 3e8:	1000                	addi	s0,sp,32
 3ea:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ee:	4605                	li	a2,1
 3f0:	fef40593          	addi	a1,s0,-17
 3f4:	f67ff0ef          	jal	35a <write>
}
 3f8:	60e2                	ld	ra,24(sp)
 3fa:	6442                	ld	s0,16(sp)
 3fc:	6105                	addi	sp,sp,32
 3fe:	8082                	ret

0000000000000400 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 400:	715d                	addi	sp,sp,-80
 402:	e486                	sd	ra,72(sp)
 404:	e0a2                	sd	s0,64(sp)
 406:	fc26                	sd	s1,56(sp)
 408:	0880                	addi	s0,sp,80
 40a:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40c:	c299                	beqz	a3,412 <printint+0x12>
 40e:	0805c963          	bltz	a1,4a0 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 412:	2581                	sext.w	a1,a1
  neg = 0;
 414:	4881                	li	a7,0
 416:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 41a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 41c:	2601                	sext.w	a2,a2
 41e:	00000517          	auipc	a0,0x0
 422:	53250513          	addi	a0,a0,1330 # 950 <digits>
 426:	883a                	mv	a6,a4
 428:	2705                	addiw	a4,a4,1
 42a:	02c5f7bb          	remuw	a5,a1,a2
 42e:	1782                	slli	a5,a5,0x20
 430:	9381                	srli	a5,a5,0x20
 432:	97aa                	add	a5,a5,a0
 434:	0007c783          	lbu	a5,0(a5)
 438:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 43c:	0005879b          	sext.w	a5,a1
 440:	02c5d5bb          	divuw	a1,a1,a2
 444:	0685                	addi	a3,a3,1
 446:	fec7f0e3          	bgeu	a5,a2,426 <printint+0x26>
  if(neg)
 44a:	00088c63          	beqz	a7,462 <printint+0x62>
    buf[i++] = '-';
 44e:	fd070793          	addi	a5,a4,-48
 452:	00878733          	add	a4,a5,s0
 456:	02d00793          	li	a5,45
 45a:	fef70423          	sb	a5,-24(a4)
 45e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 462:	02e05a63          	blez	a4,496 <printint+0x96>
 466:	f84a                	sd	s2,48(sp)
 468:	f44e                	sd	s3,40(sp)
 46a:	fb840793          	addi	a5,s0,-72
 46e:	00e78933          	add	s2,a5,a4
 472:	fff78993          	addi	s3,a5,-1
 476:	99ba                	add	s3,s3,a4
 478:	377d                	addiw	a4,a4,-1
 47a:	1702                	slli	a4,a4,0x20
 47c:	9301                	srli	a4,a4,0x20
 47e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 482:	fff94583          	lbu	a1,-1(s2)
 486:	8526                	mv	a0,s1
 488:	f5bff0ef          	jal	3e2 <putc>
  while(--i >= 0)
 48c:	197d                	addi	s2,s2,-1
 48e:	ff391ae3          	bne	s2,s3,482 <printint+0x82>
 492:	7942                	ld	s2,48(sp)
 494:	79a2                	ld	s3,40(sp)
}
 496:	60a6                	ld	ra,72(sp)
 498:	6406                	ld	s0,64(sp)
 49a:	74e2                	ld	s1,56(sp)
 49c:	6161                	addi	sp,sp,80
 49e:	8082                	ret
    x = -xx;
 4a0:	40b005bb          	negw	a1,a1
    neg = 1;
 4a4:	4885                	li	a7,1
    x = -xx;
 4a6:	bf85                	j	416 <printint+0x16>

00000000000004a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a8:	711d                	addi	sp,sp,-96
 4aa:	ec86                	sd	ra,88(sp)
 4ac:	e8a2                	sd	s0,80(sp)
 4ae:	e0ca                	sd	s2,64(sp)
 4b0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b2:	0005c903          	lbu	s2,0(a1)
 4b6:	28090663          	beqz	s2,742 <vprintf+0x29a>
 4ba:	e4a6                	sd	s1,72(sp)
 4bc:	fc4e                	sd	s3,56(sp)
 4be:	f852                	sd	s4,48(sp)
 4c0:	f456                	sd	s5,40(sp)
 4c2:	f05a                	sd	s6,32(sp)
 4c4:	ec5e                	sd	s7,24(sp)
 4c6:	e862                	sd	s8,16(sp)
 4c8:	e466                	sd	s9,8(sp)
 4ca:	8b2a                	mv	s6,a0
 4cc:	8a2e                	mv	s4,a1
 4ce:	8bb2                	mv	s7,a2
  state = 0;
 4d0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4d2:	4481                	li	s1,0
 4d4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4d6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4da:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4de:	06c00c93          	li	s9,108
 4e2:	a005                	j	502 <vprintf+0x5a>
        putc(fd, c0);
 4e4:	85ca                	mv	a1,s2
 4e6:	855a                	mv	a0,s6
 4e8:	efbff0ef          	jal	3e2 <putc>
 4ec:	a019                	j	4f2 <vprintf+0x4a>
    } else if(state == '%'){
 4ee:	03598263          	beq	s3,s5,512 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4f2:	2485                	addiw	s1,s1,1
 4f4:	8726                	mv	a4,s1
 4f6:	009a07b3          	add	a5,s4,s1
 4fa:	0007c903          	lbu	s2,0(a5)
 4fe:	22090a63          	beqz	s2,732 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 502:	0009079b          	sext.w	a5,s2
    if(state == 0){
 506:	fe0994e3          	bnez	s3,4ee <vprintf+0x46>
      if(c0 == '%'){
 50a:	fd579de3          	bne	a5,s5,4e4 <vprintf+0x3c>
        state = '%';
 50e:	89be                	mv	s3,a5
 510:	b7cd                	j	4f2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 512:	00ea06b3          	add	a3,s4,a4
 516:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 51a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 51c:	c681                	beqz	a3,524 <vprintf+0x7c>
 51e:	9752                	add	a4,a4,s4
 520:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 524:	05878363          	beq	a5,s8,56a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 528:	05978d63          	beq	a5,s9,582 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 52c:	07500713          	li	a4,117
 530:	0ee78763          	beq	a5,a4,61e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 534:	07800713          	li	a4,120
 538:	12e78963          	beq	a5,a4,66a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 53c:	07000713          	li	a4,112
 540:	14e78e63          	beq	a5,a4,69c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 544:	06300713          	li	a4,99
 548:	18e78e63          	beq	a5,a4,6e4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 54c:	07300713          	li	a4,115
 550:	1ae78463          	beq	a5,a4,6f8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 554:	02500713          	li	a4,37
 558:	04e79563          	bne	a5,a4,5a2 <vprintf+0xfa>
        putc(fd, '%');
 55c:	02500593          	li	a1,37
 560:	855a                	mv	a0,s6
 562:	e81ff0ef          	jal	3e2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 566:	4981                	li	s3,0
 568:	b769                	j	4f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 56a:	008b8913          	addi	s2,s7,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000ba583          	lw	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e89ff0ef          	jal	400 <printint>
 57c:	8bca                	mv	s7,s2
      state = 0;
 57e:	4981                	li	s3,0
 580:	bf8d                	j	4f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 582:	06400793          	li	a5,100
 586:	02f68963          	beq	a3,a5,5b8 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 58a:	06c00793          	li	a5,108
 58e:	04f68263          	beq	a3,a5,5d2 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 592:	07500793          	li	a5,117
 596:	0af68063          	beq	a3,a5,636 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 59a:	07800793          	li	a5,120
 59e:	0ef68263          	beq	a3,a5,682 <vprintf+0x1da>
        putc(fd, '%');
 5a2:	02500593          	li	a1,37
 5a6:	855a                	mv	a0,s6
 5a8:	e3bff0ef          	jal	3e2 <putc>
        putc(fd, c0);
 5ac:	85ca                	mv	a1,s2
 5ae:	855a                	mv	a0,s6
 5b0:	e33ff0ef          	jal	3e2 <putc>
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bf35                	j	4f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4685                	li	a3,1
 5be:	4629                	li	a2,10
 5c0:	000bb583          	ld	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	e3bff0ef          	jal	400 <printint>
        i += 1;
 5ca:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
        i += 1;
 5d0:	b70d                	j	4f2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d2:	06400793          	li	a5,100
 5d6:	02f60763          	beq	a2,a5,604 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5da:	07500793          	li	a5,117
 5de:	06f60963          	beq	a2,a5,650 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5e2:	07800793          	li	a5,120
 5e6:	faf61ee3          	bne	a2,a5,5a2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ea:	008b8913          	addi	s2,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4641                	li	a2,16
 5f2:	000bb583          	ld	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	e09ff0ef          	jal	400 <printint>
        i += 2;
 5fc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
        i += 2;
 602:	bdc5                	j	4f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	008b8913          	addi	s2,s7,8
 608:	4685                	li	a3,1
 60a:	4629                	li	a2,10
 60c:	000bb583          	ld	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	defff0ef          	jal	400 <printint>
        i += 2;
 616:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
        i += 2;
 61c:	bdd9                	j	4f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 61e:	008b8913          	addi	s2,s7,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000be583          	lwu	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	dd5ff0ef          	jal	400 <printint>
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	bd7d                	j	4f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	008b8913          	addi	s2,s7,8
 63a:	4681                	li	a3,0
 63c:	4629                	li	a2,10
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	dbdff0ef          	jal	400 <printint>
        i += 1;
 648:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 1;
 64e:	b555                	j	4f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	008b8913          	addi	s2,s7,8
 654:	4681                	li	a3,0
 656:	4629                	li	a2,10
 658:	000bb583          	ld	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	da3ff0ef          	jal	400 <printint>
        i += 2;
 662:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
        i += 2;
 668:	b569                	j	4f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4681                	li	a3,0
 670:	4641                	li	a2,16
 672:	000be583          	lwu	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	d89ff0ef          	jal	400 <printint>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	bd8d                	j	4f2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	008b8913          	addi	s2,s7,8
 686:	4681                	li	a3,0
 688:	4641                	li	a2,16
 68a:	000bb583          	ld	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	d71ff0ef          	jal	400 <printint>
        i += 1;
 694:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 1;
 69a:	bda1                	j	4f2 <vprintf+0x4a>
 69c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 69e:	008b8d13          	addi	s10,s7,8
 6a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a6:	03000593          	li	a1,48
 6aa:	855a                	mv	a0,s6
 6ac:	d37ff0ef          	jal	3e2 <putc>
  putc(fd, 'x');
 6b0:	07800593          	li	a1,120
 6b4:	855a                	mv	a0,s6
 6b6:	d2dff0ef          	jal	3e2 <putc>
 6ba:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6bc:	00000b97          	auipc	s7,0x0
 6c0:	294b8b93          	addi	s7,s7,660 # 950 <digits>
 6c4:	03c9d793          	srli	a5,s3,0x3c
 6c8:	97de                	add	a5,a5,s7
 6ca:	0007c583          	lbu	a1,0(a5)
 6ce:	855a                	mv	a0,s6
 6d0:	d13ff0ef          	jal	3e2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d4:	0992                	slli	s3,s3,0x4
 6d6:	397d                	addiw	s2,s2,-1
 6d8:	fe0916e3          	bnez	s2,6c4 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6dc:	8bea                	mv	s7,s10
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	6d02                	ld	s10,0(sp)
 6e2:	bd01                	j	4f2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	000bc583          	lbu	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	cf5ff0ef          	jal	3e2 <putc>
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bbf5                	j	4f2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6f8:	008b8993          	addi	s3,s7,8
 6fc:	000bb903          	ld	s2,0(s7)
 700:	00090f63          	beqz	s2,71e <vprintf+0x276>
        for(; *s; s++)
 704:	00094583          	lbu	a1,0(s2)
 708:	c195                	beqz	a1,72c <vprintf+0x284>
          putc(fd, *s);
 70a:	855a                	mv	a0,s6
 70c:	cd7ff0ef          	jal	3e2 <putc>
        for(; *s; s++)
 710:	0905                	addi	s2,s2,1
 712:	00094583          	lbu	a1,0(s2)
 716:	f9f5                	bnez	a1,70a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 718:	8bce                	mv	s7,s3
      state = 0;
 71a:	4981                	li	s3,0
 71c:	bbd9                	j	4f2 <vprintf+0x4a>
          s = "(null)";
 71e:	00000917          	auipc	s2,0x0
 722:	22a90913          	addi	s2,s2,554 # 948 <malloc+0x11e>
        for(; *s; s++)
 726:	02800593          	li	a1,40
 72a:	b7c5                	j	70a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 72c:	8bce                	mv	s7,s3
      state = 0;
 72e:	4981                	li	s3,0
 730:	b3c9                	j	4f2 <vprintf+0x4a>
 732:	64a6                	ld	s1,72(sp)
 734:	79e2                	ld	s3,56(sp)
 736:	7a42                	ld	s4,48(sp)
 738:	7aa2                	ld	s5,40(sp)
 73a:	7b02                	ld	s6,32(sp)
 73c:	6be2                	ld	s7,24(sp)
 73e:	6c42                	ld	s8,16(sp)
 740:	6ca2                	ld	s9,8(sp)
    }
  }
}
 742:	60e6                	ld	ra,88(sp)
 744:	6446                	ld	s0,80(sp)
 746:	6906                	ld	s2,64(sp)
 748:	6125                	addi	sp,sp,96
 74a:	8082                	ret

000000000000074c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 74c:	715d                	addi	sp,sp,-80
 74e:	ec06                	sd	ra,24(sp)
 750:	e822                	sd	s0,16(sp)
 752:	1000                	addi	s0,sp,32
 754:	e010                	sd	a2,0(s0)
 756:	e414                	sd	a3,8(s0)
 758:	e818                	sd	a4,16(s0)
 75a:	ec1c                	sd	a5,24(s0)
 75c:	03043023          	sd	a6,32(s0)
 760:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 764:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 768:	8622                	mv	a2,s0
 76a:	d3fff0ef          	jal	4a8 <vprintf>
}
 76e:	60e2                	ld	ra,24(sp)
 770:	6442                	ld	s0,16(sp)
 772:	6161                	addi	sp,sp,80
 774:	8082                	ret

0000000000000776 <printf>:

void
printf(const char *fmt, ...)
{
 776:	711d                	addi	sp,sp,-96
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e40c                	sd	a1,8(s0)
 780:	e810                	sd	a2,16(s0)
 782:	ec14                	sd	a3,24(s0)
 784:	f018                	sd	a4,32(s0)
 786:	f41c                	sd	a5,40(s0)
 788:	03043823          	sd	a6,48(s0)
 78c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	00840613          	addi	a2,s0,8
 794:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 798:	85aa                	mv	a1,a0
 79a:	4505                	li	a0,1
 79c:	d0dff0ef          	jal	4a8 <vprintf>
}
 7a0:	60e2                	ld	ra,24(sp)
 7a2:	6442                	ld	s0,16(sp)
 7a4:	6125                	addi	sp,sp,96
 7a6:	8082                	ret

00000000000007a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a8:	1141                	addi	sp,sp,-16
 7aa:	e422                	sd	s0,8(sp)
 7ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b2:	00001797          	auipc	a5,0x1
 7b6:	84e7b783          	ld	a5,-1970(a5) # 1000 <freep>
 7ba:	a02d                	j	7e4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7bc:	4618                	lw	a4,8(a2)
 7be:	9f2d                	addw	a4,a4,a1
 7c0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c4:	6398                	ld	a4,0(a5)
 7c6:	6310                	ld	a2,0(a4)
 7c8:	a83d                	j	806 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ca:	ff852703          	lw	a4,-8(a0)
 7ce:	9f31                	addw	a4,a4,a2
 7d0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d2:	ff053683          	ld	a3,-16(a0)
 7d6:	a091                	j	81a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d8:	6398                	ld	a4,0(a5)
 7da:	00e7e463          	bltu	a5,a4,7e2 <free+0x3a>
 7de:	00e6ea63          	bltu	a3,a4,7f2 <free+0x4a>
{
 7e2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	fed7fae3          	bgeu	a5,a3,7d8 <free+0x30>
 7e8:	6398                	ld	a4,0(a5)
 7ea:	00e6e463          	bltu	a3,a4,7f2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ee:	fee7eae3          	bltu	a5,a4,7e2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7f2:	ff852583          	lw	a1,-8(a0)
 7f6:	6390                	ld	a2,0(a5)
 7f8:	02059813          	slli	a6,a1,0x20
 7fc:	01c85713          	srli	a4,a6,0x1c
 800:	9736                	add	a4,a4,a3
 802:	fae60de3          	beq	a2,a4,7bc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 80a:	4790                	lw	a2,8(a5)
 80c:	02061593          	slli	a1,a2,0x20
 810:	01c5d713          	srli	a4,a1,0x1c
 814:	973e                	add	a4,a4,a5
 816:	fae68ae3          	beq	a3,a4,7ca <free+0x22>
    p->s.ptr = bp->s.ptr;
 81a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 81c:	00000717          	auipc	a4,0x0
 820:	7ef73223          	sd	a5,2020(a4) # 1000 <freep>
}
 824:	6422                	ld	s0,8(sp)
 826:	0141                	addi	sp,sp,16
 828:	8082                	ret

000000000000082a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 82a:	7139                	addi	sp,sp,-64
 82c:	fc06                	sd	ra,56(sp)
 82e:	f822                	sd	s0,48(sp)
 830:	f426                	sd	s1,40(sp)
 832:	ec4e                	sd	s3,24(sp)
 834:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	02051493          	slli	s1,a0,0x20
 83a:	9081                	srli	s1,s1,0x20
 83c:	04bd                	addi	s1,s1,15
 83e:	8091                	srli	s1,s1,0x4
 840:	0014899b          	addiw	s3,s1,1
 844:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 846:	00000517          	auipc	a0,0x0
 84a:	7ba53503          	ld	a0,1978(a0) # 1000 <freep>
 84e:	c915                	beqz	a0,882 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 852:	4798                	lw	a4,8(a5)
 854:	08977a63          	bgeu	a4,s1,8e8 <malloc+0xbe>
 858:	f04a                	sd	s2,32(sp)
 85a:	e852                	sd	s4,16(sp)
 85c:	e456                	sd	s5,8(sp)
 85e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 860:	8a4e                	mv	s4,s3
 862:	0009871b          	sext.w	a4,s3
 866:	6685                	lui	a3,0x1
 868:	00d77363          	bgeu	a4,a3,86e <malloc+0x44>
 86c:	6a05                	lui	s4,0x1
 86e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 872:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 876:	00000917          	auipc	s2,0x0
 87a:	78a90913          	addi	s2,s2,1930 # 1000 <freep>
  if(p == SBRK_ERROR)
 87e:	5afd                	li	s5,-1
 880:	a081                	j	8c0 <malloc+0x96>
 882:	f04a                	sd	s2,32(sp)
 884:	e852                	sd	s4,16(sp)
 886:	e456                	sd	s5,8(sp)
 888:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 88a:	00000797          	auipc	a5,0x0
 88e:	78678793          	addi	a5,a5,1926 # 1010 <base>
 892:	00000717          	auipc	a4,0x0
 896:	76f73723          	sd	a5,1902(a4) # 1000 <freep>
 89a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a0:	b7c1                	j	860 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8a2:	6398                	ld	a4,0(a5)
 8a4:	e118                	sd	a4,0(a0)
 8a6:	a8a9                	j	900 <malloc+0xd6>
  hp->s.size = nu;
 8a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ac:	0541                	addi	a0,a0,16
 8ae:	efbff0ef          	jal	7a8 <free>
  return freep;
 8b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b6:	c12d                	beqz	a0,918 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ba:	4798                	lw	a4,8(a5)
 8bc:	02977263          	bgeu	a4,s1,8e0 <malloc+0xb6>
    if(p == freep)
 8c0:	00093703          	ld	a4,0(s2)
 8c4:	853e                	mv	a0,a5
 8c6:	fef719e3          	bne	a4,a5,8b8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8ca:	8552                	mv	a0,s4
 8cc:	a3bff0ef          	jal	306 <sbrk>
  if(p == SBRK_ERROR)
 8d0:	fd551ce3          	bne	a0,s5,8a8 <malloc+0x7e>
        return 0;
 8d4:	4501                	li	a0,0
 8d6:	7902                	ld	s2,32(sp)
 8d8:	6a42                	ld	s4,16(sp)
 8da:	6aa2                	ld	s5,8(sp)
 8dc:	6b02                	ld	s6,0(sp)
 8de:	a03d                	j	90c <malloc+0xe2>
 8e0:	7902                	ld	s2,32(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8e8:	fae48de3          	beq	s1,a4,8a2 <malloc+0x78>
        p->s.size -= nunits;
 8ec:	4137073b          	subw	a4,a4,s3
 8f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f2:	02071693          	slli	a3,a4,0x20
 8f6:	01c6d713          	srli	a4,a3,0x1c
 8fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 900:	00000717          	auipc	a4,0x0
 904:	70a73023          	sd	a0,1792(a4) # 1000 <freep>
      return (void*)(p + 1);
 908:	01078513          	addi	a0,a5,16
  }
}
 90c:	70e2                	ld	ra,56(sp)
 90e:	7442                	ld	s0,48(sp)
 910:	74a2                	ld	s1,40(sp)
 912:	69e2                	ld	s3,24(sp)
 914:	6121                	addi	sp,sp,64
 916:	8082                	ret
 918:	7902                	ld	s2,32(sp)
 91a:	6a42                	ld	s4,16(sp)
 91c:	6aa2                	ld	s5,8(sp)
 91e:	6b02                	ld	s6,0(sp)
 920:	b7f5                	j	90c <malloc+0xe2>
