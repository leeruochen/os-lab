
user/_swap32_sys:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <htoi>:
#include "kernel/types.h"
#include "user/user.h"

long htoi(char *s) // method to convert hex string to integer, very important to remember
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    long val = 0;

    if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
   6:	00054703          	lbu	a4,0(a0)
   a:	03000793          	li	a5,48
   e:	00f70b63          	beq	a4,a5,24 <htoi+0x24>
    {
        s += 2;
    }

    for (int i = 0; s[i] != '\0'; i++)
  12:	00054783          	lbu	a5,0(a0)
  16:	c7a5                	beqz	a5,7e <htoi+0x7e>
  18:	00150693          	addi	a3,a0,1
    long val = 0;
  1c:	4501                	li	a0,0
    {
        char c = s[i];
        int digit;

        if (c >= '0' && c <= '9') // if character is a digit
  1e:	4625                	li	a2,9
        {
            digit = c - '0'; 
        }
        else if (c >= 'a' && c <= 'f') // if character is a-f
  20:	4595                	li	a1,5
  22:	a825                	j	5a <htoi+0x5a>
    if (s[0] == '0' && (s[1] == 'x' || s[1] == 'X'))
  24:	00154783          	lbu	a5,1(a0)
  28:	0df7f793          	andi	a5,a5,223
  2c:	05800713          	li	a4,88
  30:	00e78563          	beq	a5,a4,3a <htoi+0x3a>
    for (int i = 0; s[i] != '\0'; i++)
  34:	00054783          	lbu	a5,0(a0)
  38:	b7c5                	j	18 <htoi+0x18>
        s += 2;
  3a:	0509                	addi	a0,a0,2
  3c:	bfd9                	j	12 <htoi+0x12>
        else if (c >= 'a' && c <= 'f') // if character is a-f
  3e:	f9f7871b          	addiw	a4,a5,-97
  42:	0ff77713          	zext.b	a4,a4
  46:	02e5e363          	bltu	a1,a4,6c <htoi+0x6c>
        {
            digit = c - 'a' + 10;
  4a:	fa97879b          	addiw	a5,a5,-87
        else
        {
            return -1; // Invalid character
        }

        val = val * 16 + digit;
  4e:	0512                	slli	a0,a0,0x4
  50:	953e                	add	a0,a0,a5
    for (int i = 0; s[i] != '\0'; i++)
  52:	0685                	addi	a3,a3,1
  54:	fff6c783          	lbu	a5,-1(a3)
  58:	c795                	beqz	a5,84 <htoi+0x84>
        if (c >= '0' && c <= '9') // if character is a digit
  5a:	fd07871b          	addiw	a4,a5,-48
  5e:	0ff77713          	zext.b	a4,a4
  62:	fce66ee3          	bltu	a2,a4,3e <htoi+0x3e>
            digit = c - '0'; 
  66:	fd07879b          	addiw	a5,a5,-48
  6a:	b7d5                	j	4e <htoi+0x4e>
        else if (c >= 'A' && c <= 'F') // if character is A-F
  6c:	fbf7871b          	addiw	a4,a5,-65
  70:	0ff77713          	zext.b	a4,a4
  74:	00e5e763          	bltu	a1,a4,82 <htoi+0x82>
            digit = c - 'A' + 10;
  78:	fc97879b          	addiw	a5,a5,-55
  7c:	bfc9                	j	4e <htoi+0x4e>
    }
    return val;
  7e:	4501                	li	a0,0
  80:	a011                	j	84 <htoi+0x84>
            return -1; // Invalid character
  82:	557d                	li	a0,-1
}
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret

000000000000008a <main>:

int main(int argc, char *argv[])
{
  8a:	1101                	addi	sp,sp,-32
  8c:	ec06                	sd	ra,24(sp)
  8e:	e822                	sd	s0,16(sp)
  90:	1000                	addi	s0,sp,32
    if (argc != 2)
  92:	4789                	li	a5,2
  94:	04f51363          	bne	a0,a5,da <main+0x50>
  98:	e426                	sd	s1,8(sp)
    {
        printf("Usage: swap32_sys <32-bit hex>\n");
        exit(1);
    }

    long input = htoi(argv[1]);
  9a:	6584                	ld	s1,8(a1)
  9c:	8526                	mv	a0,s1
  9e:	f63ff0ef          	jal	0 <htoi>

    if (input == -1)
  a2:	57fd                	li	a5,-1
  a4:	04f50663          	beq	a0,a5,f0 <main+0x66>
  a8:	e04a                	sd	s2,0(sp)
        printf("Input:  %s\n", argv[1]);
        printf("Invalid argument\n");
        exit(1);
    }

    uint x = (uint)input;
  aa:	0005049b          	sext.w	s1,a0

    uint swapped = endianswap(x); // Call the system call
  ae:	8526                	mv	a0,s1
  b0:	398000ef          	jal	448 <endianswap>
  b4:	892a                	mv	s2,a0

    printf("Input:  0x%x\n", x);
  b6:	85a6                	mv	a1,s1
  b8:	00001517          	auipc	a0,0x1
  bc:	92050513          	addi	a0,a0,-1760 # 9d8 <malloc+0x140>
  c0:	724000ef          	jal	7e4 <printf>
    printf("Output: 0x%x\n", swapped);
  c4:	0009059b          	sext.w	a1,s2
  c8:	00001517          	auipc	a0,0x1
  cc:	92050513          	addi	a0,a0,-1760 # 9e8 <malloc+0x150>
  d0:	714000ef          	jal	7e4 <printf>

    exit(0);
  d4:	4501                	li	a0,0
  d6:	2d2000ef          	jal	3a8 <exit>
  da:	e426                	sd	s1,8(sp)
  dc:	e04a                	sd	s2,0(sp)
        printf("Usage: swap32_sys <32-bit hex>\n");
  de:	00001517          	auipc	a0,0x1
  e2:	8b250513          	addi	a0,a0,-1870 # 990 <malloc+0xf8>
  e6:	6fe000ef          	jal	7e4 <printf>
        exit(1);
  ea:	4505                	li	a0,1
  ec:	2bc000ef          	jal	3a8 <exit>
  f0:	e04a                	sd	s2,0(sp)
        printf("Input:  %s\n", argv[1]);
  f2:	85a6                	mv	a1,s1
  f4:	00001517          	auipc	a0,0x1
  f8:	8bc50513          	addi	a0,a0,-1860 # 9b0 <malloc+0x118>
  fc:	6e8000ef          	jal	7e4 <printf>
        printf("Invalid argument\n");
 100:	00001517          	auipc	a0,0x1
 104:	8c050513          	addi	a0,a0,-1856 # 9c0 <malloc+0x128>
 108:	6dc000ef          	jal	7e4 <printf>
        exit(1);
 10c:	4505                	li	a0,1
 10e:	29a000ef          	jal	3a8 <exit>

0000000000000112 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  extern int main();
  main();
 11a:	f71ff0ef          	jal	8a <main>
  exit(0);
 11e:	4501                	li	a0,0
 120:	288000ef          	jal	3a8 <exit>

0000000000000124 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 124:	1141                	addi	sp,sp,-16
 126:	e422                	sd	s0,8(sp)
 128:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12a:	87aa                	mv	a5,a0
 12c:	0585                	addi	a1,a1,1
 12e:	0785                	addi	a5,a5,1
 130:	fff5c703          	lbu	a4,-1(a1)
 134:	fee78fa3          	sb	a4,-1(a5)
 138:	fb75                	bnez	a4,12c <strcpy+0x8>
    ;
  return os;
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cb91                	beqz	a5,15e <strcmp+0x1e>
 14c:	0005c703          	lbu	a4,0(a1)
 150:	00f71763          	bne	a4,a5,15e <strcmp+0x1e>
    p++, q++;
 154:	0505                	addi	a0,a0,1
 156:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 158:	00054783          	lbu	a5,0(a0)
 15c:	fbe5                	bnez	a5,14c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 15e:	0005c503          	lbu	a0,0(a1)
}
 162:	40a7853b          	subw	a0,a5,a0
 166:	6422                	ld	s0,8(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret

000000000000016c <strlen>:

uint
strlen(const char *s)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 172:	00054783          	lbu	a5,0(a0)
 176:	cf91                	beqz	a5,192 <strlen+0x26>
 178:	0505                	addi	a0,a0,1
 17a:	87aa                	mv	a5,a0
 17c:	86be                	mv	a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	ff65                	bnez	a4,17c <strlen+0x10>
 186:	40a6853b          	subw	a0,a3,a0
 18a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret
  for(n = 0; s[n]; n++)
 192:	4501                	li	a0,0
 194:	bfe5                	j	18c <strlen+0x20>

0000000000000196 <memset>:

void*
memset(void *dst, int c, uint n)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19c:	ca19                	beqz	a2,1b2 <memset+0x1c>
 19e:	87aa                	mv	a5,a0
 1a0:	1602                	slli	a2,a2,0x20
 1a2:	9201                	srli	a2,a2,0x20
 1a4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ac:	0785                	addi	a5,a5,1
 1ae:	fee79de3          	bne	a5,a4,1a8 <memset+0x12>
  }
  return dst;
}
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <strchr>:

char*
strchr(const char *s, char c)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cb99                	beqz	a5,1d8 <strchr+0x20>
    if(*s == c)
 1c4:	00f58763          	beq	a1,a5,1d2 <strchr+0x1a>
  for(; *s; s++)
 1c8:	0505                	addi	a0,a0,1
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbfd                	bnez	a5,1c4 <strchr+0xc>
      return (char*)s;
  return 0;
 1d0:	4501                	li	a0,0
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  return 0;
 1d8:	4501                	li	a0,0
 1da:	bfe5                	j	1d2 <strchr+0x1a>

00000000000001dc <gets>:

char*
gets(char *buf, int max)
{
 1dc:	711d                	addi	sp,sp,-96
 1de:	ec86                	sd	ra,88(sp)
 1e0:	e8a2                	sd	s0,80(sp)
 1e2:	e4a6                	sd	s1,72(sp)
 1e4:	e0ca                	sd	s2,64(sp)
 1e6:	fc4e                	sd	s3,56(sp)
 1e8:	f852                	sd	s4,48(sp)
 1ea:	f456                	sd	s5,40(sp)
 1ec:	f05a                	sd	s6,32(sp)
 1ee:	ec5e                	sd	s7,24(sp)
 1f0:	1080                	addi	s0,sp,96
 1f2:	8baa                	mv	s7,a0
 1f4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	892a                	mv	s2,a0
 1f8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fa:	4aa9                	li	s5,10
 1fc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1fe:	89a6                	mv	s3,s1
 200:	2485                	addiw	s1,s1,1
 202:	0344d663          	bge	s1,s4,22e <gets+0x52>
    cc = read(0, &c, 1);
 206:	4605                	li	a2,1
 208:	faf40593          	addi	a1,s0,-81
 20c:	4501                	li	a0,0
 20e:	1b2000ef          	jal	3c0 <read>
    if(cc < 1)
 212:	00a05e63          	blez	a0,22e <gets+0x52>
    buf[i++] = c;
 216:	faf44783          	lbu	a5,-81(s0)
 21a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21e:	01578763          	beq	a5,s5,22c <gets+0x50>
 222:	0905                	addi	s2,s2,1
 224:	fd679de3          	bne	a5,s6,1fe <gets+0x22>
    buf[i++] = c;
 228:	89a6                	mv	s3,s1
 22a:	a011                	j	22e <gets+0x52>
 22c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22e:	99de                	add	s3,s3,s7
 230:	00098023          	sb	zero,0(s3)
  return buf;
}
 234:	855e                	mv	a0,s7
 236:	60e6                	ld	ra,88(sp)
 238:	6446                	ld	s0,80(sp)
 23a:	64a6                	ld	s1,72(sp)
 23c:	6906                	ld	s2,64(sp)
 23e:	79e2                	ld	s3,56(sp)
 240:	7a42                	ld	s4,48(sp)
 242:	7aa2                	ld	s5,40(sp)
 244:	7b02                	ld	s6,32(sp)
 246:	6be2                	ld	s7,24(sp)
 248:	6125                	addi	sp,sp,96
 24a:	8082                	ret

000000000000024c <stat>:

int
stat(const char *n, struct stat *st)
{
 24c:	1101                	addi	sp,sp,-32
 24e:	ec06                	sd	ra,24(sp)
 250:	e822                	sd	s0,16(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	18e000ef          	jal	3e8 <open>
  if(fd < 0)
 25e:	02054263          	bltz	a0,282 <stat+0x36>
 262:	e426                	sd	s1,8(sp)
 264:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 266:	85ca                	mv	a1,s2
 268:	198000ef          	jal	400 <fstat>
 26c:	892a                	mv	s2,a0
  close(fd);
 26e:	8526                	mv	a0,s1
 270:	160000ef          	jal	3d0 <close>
  return r;
 274:	64a2                	ld	s1,8(sp)
}
 276:	854a                	mv	a0,s2
 278:	60e2                	ld	ra,24(sp)
 27a:	6442                	ld	s0,16(sp)
 27c:	6902                	ld	s2,0(sp)
 27e:	6105                	addi	sp,sp,32
 280:	8082                	ret
    return -1;
 282:	597d                	li	s2,-1
 284:	bfcd                	j	276 <stat+0x2a>

0000000000000286 <atoi>:

int
atoi(const char *s)
{
 286:	1141                	addi	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28c:	00054683          	lbu	a3,0(a0)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	4625                	li	a2,9
 29a:	02f66863          	bltu	a2,a5,2ca <atoi+0x44>
 29e:	872a                	mv	a4,a0
  n = 0;
 2a0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a2:	0705                	addi	a4,a4,1
 2a4:	0025179b          	slliw	a5,a0,0x2
 2a8:	9fa9                	addw	a5,a5,a0
 2aa:	0017979b          	slliw	a5,a5,0x1
 2ae:	9fb5                	addw	a5,a5,a3
 2b0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b4:	00074683          	lbu	a3,0(a4)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	fef671e3          	bgeu	a2,a5,2a2 <atoi+0x1c>
  return n;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <atoi+0x3e>

00000000000002ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d4:	02b57463          	bgeu	a0,a1,2fc <memmove+0x2e>
    while(n-- > 0)
 2d8:	00c05f63          	blez	a2,2f6 <memmove+0x28>
 2dc:	1602                	slli	a2,a2,0x20
 2de:	9201                	srli	a2,a2,0x20
 2e0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e6:	0585                	addi	a1,a1,1
 2e8:	0705                	addi	a4,a4,1
 2ea:	fff5c683          	lbu	a3,-1(a1)
 2ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f2:	fef71ae3          	bne	a4,a5,2e6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
    dst += n;
 2fc:	00c50733          	add	a4,a0,a2
    src += n;
 300:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 302:	fec05ae3          	blez	a2,2f6 <memmove+0x28>
 306:	fff6079b          	addiw	a5,a2,-1
 30a:	1782                	slli	a5,a5,0x20
 30c:	9381                	srli	a5,a5,0x20
 30e:	fff7c793          	not	a5,a5
 312:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 314:	15fd                	addi	a1,a1,-1
 316:	177d                	addi	a4,a4,-1
 318:	0005c683          	lbu	a3,0(a1)
 31c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 320:	fee79ae3          	bne	a5,a4,314 <memmove+0x46>
 324:	bfc9                	j	2f6 <memmove+0x28>

0000000000000326 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32c:	ca05                	beqz	a2,35c <memcmp+0x36>
 32e:	fff6069b          	addiw	a3,a2,-1
 332:	1682                	slli	a3,a3,0x20
 334:	9281                	srli	a3,a3,0x20
 336:	0685                	addi	a3,a3,1
 338:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 33a:	00054783          	lbu	a5,0(a0)
 33e:	0005c703          	lbu	a4,0(a1)
 342:	00e79863          	bne	a5,a4,352 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 346:	0505                	addi	a0,a0,1
    p2++;
 348:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34a:	fed518e3          	bne	a0,a3,33a <memcmp+0x14>
  }
  return 0;
 34e:	4501                	li	a0,0
 350:	a019                	j	356 <memcmp+0x30>
      return *p1 - *p2;
 352:	40e7853b          	subw	a0,a5,a4
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret
  return 0;
 35c:	4501                	li	a0,0
 35e:	bfe5                	j	356 <memcmp+0x30>

0000000000000360 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 360:	1141                	addi	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 368:	f67ff0ef          	jal	2ce <memmove>
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <sbrk>:

char *
sbrk(int n) {
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 37c:	4585                	li	a1,1
 37e:	0b2000ef          	jal	430 <sys_sbrk>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <sbrklazy>:

char *
sbrklazy(int n) {
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 392:	4589                	li	a1,2
 394:	09c000ef          	jal	430 <sys_sbrk>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a0:	4885                	li	a7,1
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a8:	4889                	li	a7,2
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b0:	488d                	li	a7,3
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b8:	4891                	li	a7,4
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <read>:
.global read
read:
 li a7, SYS_read
 3c0:	4895                	li	a7,5
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <write>:
.global write
write:
 li a7, SYS_write
 3c8:	48c1                	li	a7,16
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <close>:
.global close
close:
 li a7, SYS_close
 3d0:	48d5                	li	a7,21
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d8:	4899                	li	a7,6
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e0:	489d                	li	a7,7
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <open>:
.global open
open:
 li a7, SYS_open
 3e8:	48bd                	li	a7,15
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f0:	48c5                	li	a7,17
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f8:	48c9                	li	a7,18
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 400:	48a1                	li	a7,8
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <link>:
.global link
link:
 li a7, SYS_link
 408:	48cd                	li	a7,19
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 410:	48d1                	li	a7,20
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 418:	48a5                	li	a7,9
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <dup>:
.global dup
dup:
 li a7, SYS_dup
 420:	48a9                	li	a7,10
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 428:	48ad                	li	a7,11
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 430:	48b1                	li	a7,12
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <pause>:
.global pause
pause:
 li a7, SYS_pause
 438:	48b5                	li	a7,13
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 440:	48b9                	li	a7,14
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <endianswap>:
.global endianswap
endianswap:
 li a7, SYS_endianswap
 448:	48d9                	li	a7,22
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 450:	1101                	addi	sp,sp,-32
 452:	ec06                	sd	ra,24(sp)
 454:	e822                	sd	s0,16(sp)
 456:	1000                	addi	s0,sp,32
 458:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45c:	4605                	li	a2,1
 45e:	fef40593          	addi	a1,s0,-17
 462:	f67ff0ef          	jal	3c8 <write>
}
 466:	60e2                	ld	ra,24(sp)
 468:	6442                	ld	s0,16(sp)
 46a:	6105                	addi	sp,sp,32
 46c:	8082                	ret

000000000000046e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 46e:	715d                	addi	sp,sp,-80
 470:	e486                	sd	ra,72(sp)
 472:	e0a2                	sd	s0,64(sp)
 474:	fc26                	sd	s1,56(sp)
 476:	0880                	addi	s0,sp,80
 478:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47a:	c299                	beqz	a3,480 <printint+0x12>
 47c:	0805c963          	bltz	a1,50e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 480:	2581                	sext.w	a1,a1
  neg = 0;
 482:	4881                	li	a7,0
 484:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 488:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 48a:	2601                	sext.w	a2,a2
 48c:	00000517          	auipc	a0,0x0
 490:	57450513          	addi	a0,a0,1396 # a00 <digits>
 494:	883a                	mv	a6,a4
 496:	2705                	addiw	a4,a4,1
 498:	02c5f7bb          	remuw	a5,a1,a2
 49c:	1782                	slli	a5,a5,0x20
 49e:	9381                	srli	a5,a5,0x20
 4a0:	97aa                	add	a5,a5,a0
 4a2:	0007c783          	lbu	a5,0(a5)
 4a6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4aa:	0005879b          	sext.w	a5,a1
 4ae:	02c5d5bb          	divuw	a1,a1,a2
 4b2:	0685                	addi	a3,a3,1
 4b4:	fec7f0e3          	bgeu	a5,a2,494 <printint+0x26>
  if(neg)
 4b8:	00088c63          	beqz	a7,4d0 <printint+0x62>
    buf[i++] = '-';
 4bc:	fd070793          	addi	a5,a4,-48
 4c0:	00878733          	add	a4,a5,s0
 4c4:	02d00793          	li	a5,45
 4c8:	fef70423          	sb	a5,-24(a4)
 4cc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4d0:	02e05a63          	blez	a4,504 <printint+0x96>
 4d4:	f84a                	sd	s2,48(sp)
 4d6:	f44e                	sd	s3,40(sp)
 4d8:	fb840793          	addi	a5,s0,-72
 4dc:	00e78933          	add	s2,a5,a4
 4e0:	fff78993          	addi	s3,a5,-1
 4e4:	99ba                	add	s3,s3,a4
 4e6:	377d                	addiw	a4,a4,-1
 4e8:	1702                	slli	a4,a4,0x20
 4ea:	9301                	srli	a4,a4,0x20
 4ec:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f0:	fff94583          	lbu	a1,-1(s2)
 4f4:	8526                	mv	a0,s1
 4f6:	f5bff0ef          	jal	450 <putc>
  while(--i >= 0)
 4fa:	197d                	addi	s2,s2,-1
 4fc:	ff391ae3          	bne	s2,s3,4f0 <printint+0x82>
 500:	7942                	ld	s2,48(sp)
 502:	79a2                	ld	s3,40(sp)
}
 504:	60a6                	ld	ra,72(sp)
 506:	6406                	ld	s0,64(sp)
 508:	74e2                	ld	s1,56(sp)
 50a:	6161                	addi	sp,sp,80
 50c:	8082                	ret
    x = -xx;
 50e:	40b005bb          	negw	a1,a1
    neg = 1;
 512:	4885                	li	a7,1
    x = -xx;
 514:	bf85                	j	484 <printint+0x16>

0000000000000516 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 516:	711d                	addi	sp,sp,-96
 518:	ec86                	sd	ra,88(sp)
 51a:	e8a2                	sd	s0,80(sp)
 51c:	e0ca                	sd	s2,64(sp)
 51e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 520:	0005c903          	lbu	s2,0(a1)
 524:	28090663          	beqz	s2,7b0 <vprintf+0x29a>
 528:	e4a6                	sd	s1,72(sp)
 52a:	fc4e                	sd	s3,56(sp)
 52c:	f852                	sd	s4,48(sp)
 52e:	f456                	sd	s5,40(sp)
 530:	f05a                	sd	s6,32(sp)
 532:	ec5e                	sd	s7,24(sp)
 534:	e862                	sd	s8,16(sp)
 536:	e466                	sd	s9,8(sp)
 538:	8b2a                	mv	s6,a0
 53a:	8a2e                	mv	s4,a1
 53c:	8bb2                	mv	s7,a2
  state = 0;
 53e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 540:	4481                	li	s1,0
 542:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 544:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 548:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 54c:	06c00c93          	li	s9,108
 550:	a005                	j	570 <vprintf+0x5a>
        putc(fd, c0);
 552:	85ca                	mv	a1,s2
 554:	855a                	mv	a0,s6
 556:	efbff0ef          	jal	450 <putc>
 55a:	a019                	j	560 <vprintf+0x4a>
    } else if(state == '%'){
 55c:	03598263          	beq	s3,s5,580 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 560:	2485                	addiw	s1,s1,1
 562:	8726                	mv	a4,s1
 564:	009a07b3          	add	a5,s4,s1
 568:	0007c903          	lbu	s2,0(a5)
 56c:	22090a63          	beqz	s2,7a0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 570:	0009079b          	sext.w	a5,s2
    if(state == 0){
 574:	fe0994e3          	bnez	s3,55c <vprintf+0x46>
      if(c0 == '%'){
 578:	fd579de3          	bne	a5,s5,552 <vprintf+0x3c>
        state = '%';
 57c:	89be                	mv	s3,a5
 57e:	b7cd                	j	560 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 580:	00ea06b3          	add	a3,s4,a4
 584:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 588:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 58a:	c681                	beqz	a3,592 <vprintf+0x7c>
 58c:	9752                	add	a4,a4,s4
 58e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 592:	05878363          	beq	a5,s8,5d8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 596:	05978d63          	beq	a5,s9,5f0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 59a:	07500713          	li	a4,117
 59e:	0ee78763          	beq	a5,a4,68c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5a2:	07800713          	li	a4,120
 5a6:	12e78963          	beq	a5,a4,6d8 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5aa:	07000713          	li	a4,112
 5ae:	14e78e63          	beq	a5,a4,70a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5b2:	06300713          	li	a4,99
 5b6:	18e78e63          	beq	a5,a4,752 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5ba:	07300713          	li	a4,115
 5be:	1ae78463          	beq	a5,a4,766 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5c2:	02500713          	li	a4,37
 5c6:	04e79563          	bne	a5,a4,610 <vprintf+0xfa>
        putc(fd, '%');
 5ca:	02500593          	li	a1,37
 5ce:	855a                	mv	a0,s6
 5d0:	e81ff0ef          	jal	450 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b769                	j	560 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4685                	li	a3,1
 5de:	4629                	li	a2,10
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	e89ff0ef          	jal	46e <printint>
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	bf8d                	j	560 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5f0:	06400793          	li	a5,100
 5f4:	02f68963          	beq	a3,a5,626 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5f8:	06c00793          	li	a5,108
 5fc:	04f68263          	beq	a3,a5,640 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 600:	07500793          	li	a5,117
 604:	0af68063          	beq	a3,a5,6a4 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 608:	07800793          	li	a5,120
 60c:	0ef68263          	beq	a3,a5,6f0 <vprintf+0x1da>
        putc(fd, '%');
 610:	02500593          	li	a1,37
 614:	855a                	mv	a0,s6
 616:	e3bff0ef          	jal	450 <putc>
        putc(fd, c0);
 61a:	85ca                	mv	a1,s2
 61c:	855a                	mv	a0,s6
 61e:	e33ff0ef          	jal	450 <putc>
      state = 0;
 622:	4981                	li	s3,0
 624:	bf35                	j	560 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 626:	008b8913          	addi	s2,s7,8
 62a:	4685                	li	a3,1
 62c:	4629                	li	a2,10
 62e:	000bb583          	ld	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	e3bff0ef          	jal	46e <printint>
        i += 1;
 638:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	8bca                	mv	s7,s2
      state = 0;
 63c:	4981                	li	s3,0
        i += 1;
 63e:	b70d                	j	560 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 640:	06400793          	li	a5,100
 644:	02f60763          	beq	a2,a5,672 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 648:	07500793          	li	a5,117
 64c:	06f60963          	beq	a2,a5,6be <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 650:	07800793          	li	a5,120
 654:	faf61ee3          	bne	a2,a5,610 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 658:	008b8913          	addi	s2,s7,8
 65c:	4681                	li	a3,0
 65e:	4641                	li	a2,16
 660:	000bb583          	ld	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	e09ff0ef          	jal	46e <printint>
        i += 2;
 66a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
        i += 2;
 670:	bdc5                	j	560 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 672:	008b8913          	addi	s2,s7,8
 676:	4685                	li	a3,1
 678:	4629                	li	a2,10
 67a:	000bb583          	ld	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	defff0ef          	jal	46e <printint>
        i += 2;
 684:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
        i += 2;
 68a:	bdd9                	j	560 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 68c:	008b8913          	addi	s2,s7,8
 690:	4681                	li	a3,0
 692:	4629                	li	a2,10
 694:	000be583          	lwu	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	dd5ff0ef          	jal	46e <printint>
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bd7d                	j	560 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4629                	li	a2,10
 6ac:	000bb583          	ld	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	dbdff0ef          	jal	46e <printint>
        i += 1;
 6b6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	8bca                	mv	s7,s2
      state = 0;
 6ba:	4981                	li	s3,0
        i += 1;
 6bc:	b555                	j	560 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	008b8913          	addi	s2,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4629                	li	a2,10
 6c6:	000bb583          	ld	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	da3ff0ef          	jal	46e <printint>
        i += 2;
 6d0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
        i += 2;
 6d6:	b569                	j	560 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4641                	li	a2,16
 6e0:	000be583          	lwu	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	d89ff0ef          	jal	46e <printint>
 6ea:	8bca                	mv	s7,s2
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bd8d                	j	560 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f0:	008b8913          	addi	s2,s7,8
 6f4:	4681                	li	a3,0
 6f6:	4641                	li	a2,16
 6f8:	000bb583          	ld	a1,0(s7)
 6fc:	855a                	mv	a0,s6
 6fe:	d71ff0ef          	jal	46e <printint>
        i += 1;
 702:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
        i += 1;
 708:	bda1                	j	560 <vprintf+0x4a>
 70a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 70c:	008b8d13          	addi	s10,s7,8
 710:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 714:	03000593          	li	a1,48
 718:	855a                	mv	a0,s6
 71a:	d37ff0ef          	jal	450 <putc>
  putc(fd, 'x');
 71e:	07800593          	li	a1,120
 722:	855a                	mv	a0,s6
 724:	d2dff0ef          	jal	450 <putc>
 728:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72a:	00000b97          	auipc	s7,0x0
 72e:	2d6b8b93          	addi	s7,s7,726 # a00 <digits>
 732:	03c9d793          	srli	a5,s3,0x3c
 736:	97de                	add	a5,a5,s7
 738:	0007c583          	lbu	a1,0(a5)
 73c:	855a                	mv	a0,s6
 73e:	d13ff0ef          	jal	450 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 742:	0992                	slli	s3,s3,0x4
 744:	397d                	addiw	s2,s2,-1
 746:	fe0916e3          	bnez	s2,732 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 74a:	8bea                	mv	s7,s10
      state = 0;
 74c:	4981                	li	s3,0
 74e:	6d02                	ld	s10,0(sp)
 750:	bd01                	j	560 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 752:	008b8913          	addi	s2,s7,8
 756:	000bc583          	lbu	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	cf5ff0ef          	jal	450 <putc>
 760:	8bca                	mv	s7,s2
      state = 0;
 762:	4981                	li	s3,0
 764:	bbf5                	j	560 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 766:	008b8993          	addi	s3,s7,8
 76a:	000bb903          	ld	s2,0(s7)
 76e:	00090f63          	beqz	s2,78c <vprintf+0x276>
        for(; *s; s++)
 772:	00094583          	lbu	a1,0(s2)
 776:	c195                	beqz	a1,79a <vprintf+0x284>
          putc(fd, *s);
 778:	855a                	mv	a0,s6
 77a:	cd7ff0ef          	jal	450 <putc>
        for(; *s; s++)
 77e:	0905                	addi	s2,s2,1
 780:	00094583          	lbu	a1,0(s2)
 784:	f9f5                	bnez	a1,778 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 786:	8bce                	mv	s7,s3
      state = 0;
 788:	4981                	li	s3,0
 78a:	bbd9                	j	560 <vprintf+0x4a>
          s = "(null)";
 78c:	00000917          	auipc	s2,0x0
 790:	26c90913          	addi	s2,s2,620 # 9f8 <malloc+0x160>
        for(; *s; s++)
 794:	02800593          	li	a1,40
 798:	b7c5                	j	778 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 79a:	8bce                	mv	s7,s3
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b3c9                	j	560 <vprintf+0x4a>
 7a0:	64a6                	ld	s1,72(sp)
 7a2:	79e2                	ld	s3,56(sp)
 7a4:	7a42                	ld	s4,48(sp)
 7a6:	7aa2                	ld	s5,40(sp)
 7a8:	7b02                	ld	s6,32(sp)
 7aa:	6be2                	ld	s7,24(sp)
 7ac:	6c42                	ld	s8,16(sp)
 7ae:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7b0:	60e6                	ld	ra,88(sp)
 7b2:	6446                	ld	s0,80(sp)
 7b4:	6906                	ld	s2,64(sp)
 7b6:	6125                	addi	sp,sp,96
 7b8:	8082                	ret

00000000000007ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ba:	715d                	addi	sp,sp,-80
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	addi	s0,sp,32
 7c2:	e010                	sd	a2,0(s0)
 7c4:	e414                	sd	a3,8(s0)
 7c6:	e818                	sd	a4,16(s0)
 7c8:	ec1c                	sd	a5,24(s0)
 7ca:	03043023          	sd	a6,32(s0)
 7ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d6:	8622                	mv	a2,s0
 7d8:	d3fff0ef          	jal	516 <vprintf>
}
 7dc:	60e2                	ld	ra,24(sp)
 7de:	6442                	ld	s0,16(sp)
 7e0:	6161                	addi	sp,sp,80
 7e2:	8082                	ret

00000000000007e4 <printf>:

void
printf(const char *fmt, ...)
{
 7e4:	711d                	addi	sp,sp,-96
 7e6:	ec06                	sd	ra,24(sp)
 7e8:	e822                	sd	s0,16(sp)
 7ea:	1000                	addi	s0,sp,32
 7ec:	e40c                	sd	a1,8(s0)
 7ee:	e810                	sd	a2,16(s0)
 7f0:	ec14                	sd	a3,24(s0)
 7f2:	f018                	sd	a4,32(s0)
 7f4:	f41c                	sd	a5,40(s0)
 7f6:	03043823          	sd	a6,48(s0)
 7fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fe:	00840613          	addi	a2,s0,8
 802:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 806:	85aa                	mv	a1,a0
 808:	4505                	li	a0,1
 80a:	d0dff0ef          	jal	516 <vprintf>
}
 80e:	60e2                	ld	ra,24(sp)
 810:	6442                	ld	s0,16(sp)
 812:	6125                	addi	sp,sp,96
 814:	8082                	ret

0000000000000816 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 816:	1141                	addi	sp,sp,-16
 818:	e422                	sd	s0,8(sp)
 81a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	00000797          	auipc	a5,0x0
 824:	7e07b783          	ld	a5,2016(a5) # 1000 <freep>
 828:	a02d                	j	852 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 82a:	4618                	lw	a4,8(a2)
 82c:	9f2d                	addw	a4,a4,a1
 82e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 832:	6398                	ld	a4,0(a5)
 834:	6310                	ld	a2,0(a4)
 836:	a83d                	j	874 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 838:	ff852703          	lw	a4,-8(a0)
 83c:	9f31                	addw	a4,a4,a2
 83e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 840:	ff053683          	ld	a3,-16(a0)
 844:	a091                	j	888 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 846:	6398                	ld	a4,0(a5)
 848:	00e7e463          	bltu	a5,a4,850 <free+0x3a>
 84c:	00e6ea63          	bltu	a3,a4,860 <free+0x4a>
{
 850:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 852:	fed7fae3          	bgeu	a5,a3,846 <free+0x30>
 856:	6398                	ld	a4,0(a5)
 858:	00e6e463          	bltu	a3,a4,860 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85c:	fee7eae3          	bltu	a5,a4,850 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 860:	ff852583          	lw	a1,-8(a0)
 864:	6390                	ld	a2,0(a5)
 866:	02059813          	slli	a6,a1,0x20
 86a:	01c85713          	srli	a4,a6,0x1c
 86e:	9736                	add	a4,a4,a3
 870:	fae60de3          	beq	a2,a4,82a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 874:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 878:	4790                	lw	a2,8(a5)
 87a:	02061593          	slli	a1,a2,0x20
 87e:	01c5d713          	srli	a4,a1,0x1c
 882:	973e                	add	a4,a4,a5
 884:	fae68ae3          	beq	a3,a4,838 <free+0x22>
    p->s.ptr = bp->s.ptr;
 888:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88a:	00000717          	auipc	a4,0x0
 88e:	76f73b23          	sd	a5,1910(a4) # 1000 <freep>
}
 892:	6422                	ld	s0,8(sp)
 894:	0141                	addi	sp,sp,16
 896:	8082                	ret

0000000000000898 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 898:	7139                	addi	sp,sp,-64
 89a:	fc06                	sd	ra,56(sp)
 89c:	f822                	sd	s0,48(sp)
 89e:	f426                	sd	s1,40(sp)
 8a0:	ec4e                	sd	s3,24(sp)
 8a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a4:	02051493          	slli	s1,a0,0x20
 8a8:	9081                	srli	s1,s1,0x20
 8aa:	04bd                	addi	s1,s1,15
 8ac:	8091                	srli	s1,s1,0x4
 8ae:	0014899b          	addiw	s3,s1,1
 8b2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8b4:	00000517          	auipc	a0,0x0
 8b8:	74c53503          	ld	a0,1868(a0) # 1000 <freep>
 8bc:	c915                	beqz	a0,8f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c0:	4798                	lw	a4,8(a5)
 8c2:	08977a63          	bgeu	a4,s1,956 <malloc+0xbe>
 8c6:	f04a                	sd	s2,32(sp)
 8c8:	e852                	sd	s4,16(sp)
 8ca:	e456                	sd	s5,8(sp)
 8cc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8ce:	8a4e                	mv	s4,s3
 8d0:	0009871b          	sext.w	a4,s3
 8d4:	6685                	lui	a3,0x1
 8d6:	00d77363          	bgeu	a4,a3,8dc <malloc+0x44>
 8da:	6a05                	lui	s4,0x1
 8dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e4:	00000917          	auipc	s2,0x0
 8e8:	71c90913          	addi	s2,s2,1820 # 1000 <freep>
  if(p == SBRK_ERROR)
 8ec:	5afd                	li	s5,-1
 8ee:	a081                	j	92e <malloc+0x96>
 8f0:	f04a                	sd	s2,32(sp)
 8f2:	e852                	sd	s4,16(sp)
 8f4:	e456                	sd	s5,8(sp)
 8f6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f8:	00000797          	auipc	a5,0x0
 8fc:	71878793          	addi	a5,a5,1816 # 1010 <base>
 900:	00000717          	auipc	a4,0x0
 904:	70f73023          	sd	a5,1792(a4) # 1000 <freep>
 908:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 90e:	b7c1                	j	8ce <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 910:	6398                	ld	a4,0(a5)
 912:	e118                	sd	a4,0(a0)
 914:	a8a9                	j	96e <malloc+0xd6>
  hp->s.size = nu;
 916:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91a:	0541                	addi	a0,a0,16
 91c:	efbff0ef          	jal	816 <free>
  return freep;
 920:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 924:	c12d                	beqz	a0,986 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 926:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 928:	4798                	lw	a4,8(a5)
 92a:	02977263          	bgeu	a4,s1,94e <malloc+0xb6>
    if(p == freep)
 92e:	00093703          	ld	a4,0(s2)
 932:	853e                	mv	a0,a5
 934:	fef719e3          	bne	a4,a5,926 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 938:	8552                	mv	a0,s4
 93a:	a3bff0ef          	jal	374 <sbrk>
  if(p == SBRK_ERROR)
 93e:	fd551ce3          	bne	a0,s5,916 <malloc+0x7e>
        return 0;
 942:	4501                	li	a0,0
 944:	7902                	ld	s2,32(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
 94c:	a03d                	j	97a <malloc+0xe2>
 94e:	7902                	ld	s2,32(sp)
 950:	6a42                	ld	s4,16(sp)
 952:	6aa2                	ld	s5,8(sp)
 954:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 956:	fae48de3          	beq	s1,a4,910 <malloc+0x78>
        p->s.size -= nunits;
 95a:	4137073b          	subw	a4,a4,s3
 95e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 960:	02071693          	slli	a3,a4,0x20
 964:	01c6d713          	srli	a4,a3,0x1c
 968:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 96a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96e:	00000717          	auipc	a4,0x0
 972:	68a73923          	sd	a0,1682(a4) # 1000 <freep>
      return (void*)(p + 1);
 976:	01078513          	addi	a0,a5,16
  }
}
 97a:	70e2                	ld	ra,56(sp)
 97c:	7442                	ld	s0,48(sp)
 97e:	74a2                	ld	s1,40(sp)
 980:	69e2                	ld	s3,24(sp)
 982:	6121                	addi	sp,sp,64
 984:	8082                	ret
 986:	7902                	ld	s2,32(sp)
 988:	6a42                	ld	s4,16(sp)
 98a:	6aa2                	ld	s5,8(sp)
 98c:	6b02                	ld	s6,0(sp)
 98e:	b7f5                	j	97a <malloc+0xe2>
