
user/_sixfive:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <is_valid_sixfive>:
#include "user/user.h"
#include "kernel/fcntl.h"

// Helper: Returns 1 if s contains ONLY '5' or '6'. Returns 0 otherwise.
int is_valid_sixfive(char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    if (strlen(s) == 0) return 0; // Empty string is not a valid number
   c:	1fa000ef          	jal	206 <strlen>
  10:	2501                	sext.w	a0,a0
  12:	c11d                	beqz	a0,38 <is_valid_sixfive+0x38>

    for (int i = 0; s[i] != 0; i++)
  14:	0004c783          	lbu	a5,0(s1)
  18:	c795                	beqz	a5,44 <is_valid_sixfive+0x44>
  1a:	00148513          	addi	a0,s1,1
    {
        if (s[i] != '5' && s[i] != '6')
  1e:	4705                	li	a4,1
  20:	fcb7879b          	addiw	a5,a5,-53
  24:	0ff7f793          	zext.b	a5,a5
  28:	02f76063          	bltu	a4,a5,48 <is_valid_sixfive+0x48>
    for (int i = 0; s[i] != 0; i++)
  2c:	0505                	addi	a0,a0,1
  2e:	fff54783          	lbu	a5,-1(a0)
  32:	f7fd                	bnez	a5,20 <is_valid_sixfive+0x20>
        {
            return 0; // Found a bad digit (like '7' or 'a')
        }
    }
    return 1; // All checks passed
  34:	4505                	li	a0,1
  36:	a011                	j	3a <is_valid_sixfive+0x3a>
    if (strlen(s) == 0) return 0; // Empty string is not a valid number
  38:	4501                	li	a0,0
}
  3a:	60e2                	ld	ra,24(sp)
  3c:	6442                	ld	s0,16(sp)
  3e:	64a2                	ld	s1,8(sp)
  40:	6105                	addi	sp,sp,32
  42:	8082                	ret
    return 1; // All checks passed
  44:	4505                	li	a0,1
  46:	bfd5                	j	3a <is_valid_sixfive+0x3a>
            return 0; // Found a bad digit (like '7' or 'a')
  48:	4501                	li	a0,0
  4a:	bfc5                	j	3a <is_valid_sixfive+0x3a>

000000000000004c <is_delim>:

// Helper: Checks if a character is a separator
int is_delim(char c)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
    // You can add more delimiters here if needed
    return (c == ' ' || c == '\n' || c == '\t' || c == '\r' || c == ',' || c == '.');
  52:	355d                	addiw	a0,a0,-9
  54:	0ff57513          	zext.b	a0,a0
  58:	02500793          	li	a5,37
  5c:	00a7ec63          	bltu	a5,a0,74 <is_delim+0x28>
  60:	050017b7          	lui	a5,0x5001
  64:	07ae                	slli	a5,a5,0xb
  66:	07cd                	addi	a5,a5,19 # 5001013 <base+0x5000003>
  68:	00a7d533          	srl	a0,a5,a0
  6c:	8905                	andi	a0,a0,1
}
  6e:	6422                	ld	s0,8(sp)
  70:	0141                	addi	sp,sp,16
  72:	8082                	ret
    return (c == ' ' || c == '\n' || c == '\t' || c == '\r' || c == ',' || c == '.');
  74:	4501                	li	a0,0
  76:	bfe5                	j	6e <is_delim+0x22>

0000000000000078 <process>:

void process(int fd)
{
  78:	7131                	addi	sp,sp,-192
  7a:	fd06                	sd	ra,184(sp)
  7c:	f922                	sd	s0,176(sp)
  7e:	f526                	sd	s1,168(sp)
  80:	f14a                	sd	s2,160(sp)
  82:	ed4e                	sd	s3,152(sp)
  84:	e952                	sd	s4,144(sp)
  86:	0180                	addi	s0,sp,192
  88:	89aa                	mv	s3,a0
    char buf[128];
    int i = 0;
  8a:	4481                	li	s1,0
            }
        }
        else
        {
            // NOT A DELIMITER: Add to buffer
            if (i < 127) // Protect against Buffer Overflow
  8c:	07e00a13          	li	s4,126
    while (read(fd, &c, 1) == 1)
  90:	a809                	j	a2 <process+0x2a>
            if (i < 127) // Protect against Buffer Overflow
  92:	009a4863          	blt	s4,s1,a2 <process+0x2a>
            {
                buf[i++] = c;
  96:	fd048793          	addi	a5,s1,-48
  9a:	97a2                	add	a5,a5,s0
  9c:	f9278023          	sb	s2,-128(a5)
  a0:	2485                	addiw	s1,s1,1
    while (read(fd, &c, 1) == 1)
  a2:	4605                	li	a2,1
  a4:	f4f40593          	addi	a1,s0,-177
  a8:	854e                	mv	a0,s3
  aa:	3b0000ef          	jal	45a <read>
  ae:	4785                	li	a5,1
  b0:	04f51063          	bne	a0,a5,f0 <process+0x78>
        if (is_delim(c))
  b4:	f4f44903          	lbu	s2,-177(s0)
  b8:	854a                	mv	a0,s2
  ba:	f93ff0ef          	jal	4c <is_delim>
  be:	d971                	beqz	a0,92 <process+0x1a>
            if (i > 0) 
  c0:	fe9051e3          	blez	s1,a2 <process+0x2a>
                buf[i] = 0; // Null-terminate string
  c4:	fd048793          	addi	a5,s1,-48
  c8:	008784b3          	add	s1,a5,s0
  cc:	f8048023          	sb	zero,-128(s1)
                if (is_valid_sixfive(buf))
  d0:	f5040513          	addi	a0,s0,-176
  d4:	f2dff0ef          	jal	0 <is_valid_sixfive>
  d8:	84aa                	mv	s1,a0
  da:	d561                	beqz	a0,a2 <process+0x2a>
                    printf("%s\n", buf);
  dc:	f5040593          	addi	a1,s0,-176
  e0:	00001517          	auipc	a0,0x1
  e4:	95050513          	addi	a0,a0,-1712 # a30 <malloc+0xfe>
  e8:	796000ef          	jal	87e <printf>
                i = 0; // Reset buffer for the next word
  ec:	4481                	li	s1,0
  ee:	bf55                	j	a2 <process+0x2a>
            // or you could ignore the rest of the word.
        }
    }

    // CHECK LAST WORD: Logic to handle file ending without a newline
    if (i > 0)
  f0:	00904a63          	bgtz	s1,104 <process+0x8c>
        if (is_valid_sixfive(buf))
        {
            printf("%s\n", buf);
        }
    }
}
  f4:	70ea                	ld	ra,184(sp)
  f6:	744a                	ld	s0,176(sp)
  f8:	74aa                	ld	s1,168(sp)
  fa:	790a                	ld	s2,160(sp)
  fc:	69ea                	ld	s3,152(sp)
  fe:	6a4a                	ld	s4,144(sp)
 100:	6129                	addi	sp,sp,192
 102:	8082                	ret
        buf[i] = 0;
 104:	fd048793          	addi	a5,s1,-48
 108:	008784b3          	add	s1,a5,s0
 10c:	f8048023          	sb	zero,-128(s1)
        if (is_valid_sixfive(buf))
 110:	f5040513          	addi	a0,s0,-176
 114:	eedff0ef          	jal	0 <is_valid_sixfive>
 118:	dd71                	beqz	a0,f4 <process+0x7c>
            printf("%s\n", buf);
 11a:	f5040593          	addi	a1,s0,-176
 11e:	00001517          	auipc	a0,0x1
 122:	91250513          	addi	a0,a0,-1774 # a30 <malloc+0xfe>
 126:	758000ef          	jal	87e <printf>
}
 12a:	b7e9                	j	f4 <process+0x7c>

000000000000012c <main>:

int main(int argc, char *argv[])
{
 12c:	7179                	addi	sp,sp,-48
 12e:	f406                	sd	ra,40(sp)
 130:	f022                	sd	s0,32(sp)
 132:	1800                	addi	s0,sp,48
    if (argc < 2)
 134:	4785                	li	a5,1
 136:	02a7d563          	bge	a5,a0,160 <main+0x34>
 13a:	ec26                	sd	s1,24(sp)
 13c:	e84a                	sd	s2,16(sp)
 13e:	e44e                	sd	s3,8(sp)
 140:	e052                	sd	s4,0(sp)
 142:	00858913          	addi	s2,a1,8
 146:	ffe5099b          	addiw	s3,a0,-2
 14a:	02099793          	slli	a5,s3,0x20
 14e:	01d7d993          	srli	s3,a5,0x1d
 152:	05c1                	addi	a1,a1,16
 154:	99ae                	add	s3,s3,a1
    for (int k = 1; k < argc; k++)
    {
        int fd = open(argv[k], O_RDONLY);
        if (fd < 0)
        {
            printf("sixfive: cannot open %s\n", argv[k]);
 156:	00001a17          	auipc	s4,0x1
 15a:	902a0a13          	addi	s4,s4,-1790 # a58 <malloc+0x126>
 15e:	a035                	j	18a <main+0x5e>
 160:	ec26                	sd	s1,24(sp)
 162:	e84a                	sd	s2,16(sp)
 164:	e44e                	sd	s3,8(sp)
 166:	e052                	sd	s4,0(sp)
        printf("Usage: sixfive <filename>\n");
 168:	00001517          	auipc	a0,0x1
 16c:	8d050513          	addi	a0,a0,-1840 # a38 <malloc+0x106>
 170:	70e000ef          	jal	87e <printf>
        exit(1);
 174:	4505                	li	a0,1
 176:	2cc000ef          	jal	442 <exit>
            printf("sixfive: cannot open %s\n", argv[k]);
 17a:	00093583          	ld	a1,0(s2)
 17e:	8552                	mv	a0,s4
 180:	6fe000ef          	jal	87e <printf>
    for (int k = 1; k < argc; k++)
 184:	0921                	addi	s2,s2,8
 186:	03390063          	beq	s2,s3,1a6 <main+0x7a>
        int fd = open(argv[k], O_RDONLY);
 18a:	4581                	li	a1,0
 18c:	00093503          	ld	a0,0(s2)
 190:	2f2000ef          	jal	482 <open>
 194:	84aa                	mv	s1,a0
        if (fd < 0)
 196:	fe0542e3          	bltz	a0,17a <main+0x4e>
            continue;
        }
        process(fd);
 19a:	edfff0ef          	jal	78 <process>
        close(fd);
 19e:	8526                	mv	a0,s1
 1a0:	2ca000ef          	jal	46a <close>
 1a4:	b7c5                	j	184 <main+0x58>
    }
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
 1b4:	f79ff0ef          	jal	12c <main>
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

00000000000004e2 <endianswap>:
.global endianswap
endianswap:
 li a7, SYS_endianswap
 4e2:	48d9                	li	a7,22
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ea:	1101                	addi	sp,sp,-32
 4ec:	ec06                	sd	ra,24(sp)
 4ee:	e822                	sd	s0,16(sp)
 4f0:	1000                	addi	s0,sp,32
 4f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f6:	4605                	li	a2,1
 4f8:	fef40593          	addi	a1,s0,-17
 4fc:	f67ff0ef          	jal	462 <write>
}
 500:	60e2                	ld	ra,24(sp)
 502:	6442                	ld	s0,16(sp)
 504:	6105                	addi	sp,sp,32
 506:	8082                	ret

0000000000000508 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 508:	715d                	addi	sp,sp,-80
 50a:	e486                	sd	ra,72(sp)
 50c:	e0a2                	sd	s0,64(sp)
 50e:	fc26                	sd	s1,56(sp)
 510:	0880                	addi	s0,sp,80
 512:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 514:	c299                	beqz	a3,51a <printint+0x12>
 516:	0805c963          	bltz	a1,5a8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 51a:	2581                	sext.w	a1,a1
  neg = 0;
 51c:	4881                	li	a7,0
 51e:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 522:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 524:	2601                	sext.w	a2,a2
 526:	00000517          	auipc	a0,0x0
 52a:	55a50513          	addi	a0,a0,1370 # a80 <digits>
 52e:	883a                	mv	a6,a4
 530:	2705                	addiw	a4,a4,1
 532:	02c5f7bb          	remuw	a5,a1,a2
 536:	1782                	slli	a5,a5,0x20
 538:	9381                	srli	a5,a5,0x20
 53a:	97aa                	add	a5,a5,a0
 53c:	0007c783          	lbu	a5,0(a5)
 540:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 544:	0005879b          	sext.w	a5,a1
 548:	02c5d5bb          	divuw	a1,a1,a2
 54c:	0685                	addi	a3,a3,1
 54e:	fec7f0e3          	bgeu	a5,a2,52e <printint+0x26>
  if(neg)
 552:	00088c63          	beqz	a7,56a <printint+0x62>
    buf[i++] = '-';
 556:	fd070793          	addi	a5,a4,-48
 55a:	00878733          	add	a4,a5,s0
 55e:	02d00793          	li	a5,45
 562:	fef70423          	sb	a5,-24(a4)
 566:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 56a:	02e05a63          	blez	a4,59e <printint+0x96>
 56e:	f84a                	sd	s2,48(sp)
 570:	f44e                	sd	s3,40(sp)
 572:	fb840793          	addi	a5,s0,-72
 576:	00e78933          	add	s2,a5,a4
 57a:	fff78993          	addi	s3,a5,-1
 57e:	99ba                	add	s3,s3,a4
 580:	377d                	addiw	a4,a4,-1
 582:	1702                	slli	a4,a4,0x20
 584:	9301                	srli	a4,a4,0x20
 586:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 58a:	fff94583          	lbu	a1,-1(s2)
 58e:	8526                	mv	a0,s1
 590:	f5bff0ef          	jal	4ea <putc>
  while(--i >= 0)
 594:	197d                	addi	s2,s2,-1
 596:	ff391ae3          	bne	s2,s3,58a <printint+0x82>
 59a:	7942                	ld	s2,48(sp)
 59c:	79a2                	ld	s3,40(sp)
}
 59e:	60a6                	ld	ra,72(sp)
 5a0:	6406                	ld	s0,64(sp)
 5a2:	74e2                	ld	s1,56(sp)
 5a4:	6161                	addi	sp,sp,80
 5a6:	8082                	ret
    x = -xx;
 5a8:	40b005bb          	negw	a1,a1
    neg = 1;
 5ac:	4885                	li	a7,1
    x = -xx;
 5ae:	bf85                	j	51e <printint+0x16>

00000000000005b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b0:	711d                	addi	sp,sp,-96
 5b2:	ec86                	sd	ra,88(sp)
 5b4:	e8a2                	sd	s0,80(sp)
 5b6:	e0ca                	sd	s2,64(sp)
 5b8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ba:	0005c903          	lbu	s2,0(a1)
 5be:	28090663          	beqz	s2,84a <vprintf+0x29a>
 5c2:	e4a6                	sd	s1,72(sp)
 5c4:	fc4e                	sd	s3,56(sp)
 5c6:	f852                	sd	s4,48(sp)
 5c8:	f456                	sd	s5,40(sp)
 5ca:	f05a                	sd	s6,32(sp)
 5cc:	ec5e                	sd	s7,24(sp)
 5ce:	e862                	sd	s8,16(sp)
 5d0:	e466                	sd	s9,8(sp)
 5d2:	8b2a                	mv	s6,a0
 5d4:	8a2e                	mv	s4,a1
 5d6:	8bb2                	mv	s7,a2
  state = 0;
 5d8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5da:	4481                	li	s1,0
 5dc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5de:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5e6:	06c00c93          	li	s9,108
 5ea:	a005                	j	60a <vprintf+0x5a>
        putc(fd, c0);
 5ec:	85ca                	mv	a1,s2
 5ee:	855a                	mv	a0,s6
 5f0:	efbff0ef          	jal	4ea <putc>
 5f4:	a019                	j	5fa <vprintf+0x4a>
    } else if(state == '%'){
 5f6:	03598263          	beq	s3,s5,61a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5fa:	2485                	addiw	s1,s1,1
 5fc:	8726                	mv	a4,s1
 5fe:	009a07b3          	add	a5,s4,s1
 602:	0007c903          	lbu	s2,0(a5)
 606:	22090a63          	beqz	s2,83a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 60a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 60e:	fe0994e3          	bnez	s3,5f6 <vprintf+0x46>
      if(c0 == '%'){
 612:	fd579de3          	bne	a5,s5,5ec <vprintf+0x3c>
        state = '%';
 616:	89be                	mv	s3,a5
 618:	b7cd                	j	5fa <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 61a:	00ea06b3          	add	a3,s4,a4
 61e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 622:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 624:	c681                	beqz	a3,62c <vprintf+0x7c>
 626:	9752                	add	a4,a4,s4
 628:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 62c:	05878363          	beq	a5,s8,672 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 630:	05978d63          	beq	a5,s9,68a <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 634:	07500713          	li	a4,117
 638:	0ee78763          	beq	a5,a4,726 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 63c:	07800713          	li	a4,120
 640:	12e78963          	beq	a5,a4,772 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 644:	07000713          	li	a4,112
 648:	14e78e63          	beq	a5,a4,7a4 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 64c:	06300713          	li	a4,99
 650:	18e78e63          	beq	a5,a4,7ec <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 654:	07300713          	li	a4,115
 658:	1ae78463          	beq	a5,a4,800 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 65c:	02500713          	li	a4,37
 660:	04e79563          	bne	a5,a4,6aa <vprintf+0xfa>
        putc(fd, '%');
 664:	02500593          	li	a1,37
 668:	855a                	mv	a0,s6
 66a:	e81ff0ef          	jal	4ea <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 66e:	4981                	li	s3,0
 670:	b769                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 672:	008b8913          	addi	s2,s7,8
 676:	4685                	li	a3,1
 678:	4629                	li	a2,10
 67a:	000ba583          	lw	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	e89ff0ef          	jal	508 <printint>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	bf8d                	j	5fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 68a:	06400793          	li	a5,100
 68e:	02f68963          	beq	a3,a5,6c0 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 692:	06c00793          	li	a5,108
 696:	04f68263          	beq	a3,a5,6da <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 69a:	07500793          	li	a5,117
 69e:	0af68063          	beq	a3,a5,73e <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6a2:	07800793          	li	a5,120
 6a6:	0ef68263          	beq	a3,a5,78a <vprintf+0x1da>
        putc(fd, '%');
 6aa:	02500593          	li	a1,37
 6ae:	855a                	mv	a0,s6
 6b0:	e3bff0ef          	jal	4ea <putc>
        putc(fd, c0);
 6b4:	85ca                	mv	a1,s2
 6b6:	855a                	mv	a0,s6
 6b8:	e33ff0ef          	jal	4ea <putc>
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bf35                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4685                	li	a3,1
 6c6:	4629                	li	a2,10
 6c8:	000bb583          	ld	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	e3bff0ef          	jal	508 <printint>
        i += 1;
 6d2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
        i += 1;
 6d8:	b70d                	j	5fa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6da:	06400793          	li	a5,100
 6de:	02f60763          	beq	a2,a5,70c <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6e2:	07500793          	li	a5,117
 6e6:	06f60963          	beq	a2,a5,758 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6ea:	07800793          	li	a5,120
 6ee:	faf61ee3          	bne	a2,a5,6aa <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000bb583          	ld	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	e09ff0ef          	jal	508 <printint>
        i += 2;
 704:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 2;
 70a:	bdc5                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 70c:	008b8913          	addi	s2,s7,8
 710:	4685                	li	a3,1
 712:	4629                	li	a2,10
 714:	000bb583          	ld	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	defff0ef          	jal	508 <printint>
        i += 2;
 71e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 720:	8bca                	mv	s7,s2
      state = 0;
 722:	4981                	li	s3,0
        i += 2;
 724:	bdd9                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 726:	008b8913          	addi	s2,s7,8
 72a:	4681                	li	a3,0
 72c:	4629                	li	a2,10
 72e:	000be583          	lwu	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	dd5ff0ef          	jal	508 <printint>
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bd7d                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4629                	li	a2,10
 746:	000bb583          	ld	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	dbdff0ef          	jal	508 <printint>
        i += 1;
 750:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
        i += 1;
 756:	b555                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 758:	008b8913          	addi	s2,s7,8
 75c:	4681                	li	a3,0
 75e:	4629                	li	a2,10
 760:	000bb583          	ld	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	da3ff0ef          	jal	508 <printint>
        i += 2;
 76a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
        i += 2;
 770:	b569                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 772:	008b8913          	addi	s2,s7,8
 776:	4681                	li	a3,0
 778:	4641                	li	a2,16
 77a:	000be583          	lwu	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	d89ff0ef          	jal	508 <printint>
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
 788:	bd8d                	j	5fa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 78a:	008b8913          	addi	s2,s7,8
 78e:	4681                	li	a3,0
 790:	4641                	li	a2,16
 792:	000bb583          	ld	a1,0(s7)
 796:	855a                	mv	a0,s6
 798:	d71ff0ef          	jal	508 <printint>
        i += 1;
 79c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
        i += 1;
 7a2:	bda1                	j	5fa <vprintf+0x4a>
 7a4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7a6:	008b8d13          	addi	s10,s7,8
 7aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ae:	03000593          	li	a1,48
 7b2:	855a                	mv	a0,s6
 7b4:	d37ff0ef          	jal	4ea <putc>
  putc(fd, 'x');
 7b8:	07800593          	li	a1,120
 7bc:	855a                	mv	a0,s6
 7be:	d2dff0ef          	jal	4ea <putc>
 7c2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c4:	00000b97          	auipc	s7,0x0
 7c8:	2bcb8b93          	addi	s7,s7,700 # a80 <digits>
 7cc:	03c9d793          	srli	a5,s3,0x3c
 7d0:	97de                	add	a5,a5,s7
 7d2:	0007c583          	lbu	a1,0(a5)
 7d6:	855a                	mv	a0,s6
 7d8:	d13ff0ef          	jal	4ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7dc:	0992                	slli	s3,s3,0x4
 7de:	397d                	addiw	s2,s2,-1
 7e0:	fe0916e3          	bnez	s2,7cc <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7e4:	8bea                	mv	s7,s10
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	6d02                	ld	s10,0(sp)
 7ea:	bd01                	j	5fa <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7ec:	008b8913          	addi	s2,s7,8
 7f0:	000bc583          	lbu	a1,0(s7)
 7f4:	855a                	mv	a0,s6
 7f6:	cf5ff0ef          	jal	4ea <putc>
 7fa:	8bca                	mv	s7,s2
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	bbf5                	j	5fa <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 800:	008b8993          	addi	s3,s7,8
 804:	000bb903          	ld	s2,0(s7)
 808:	00090f63          	beqz	s2,826 <vprintf+0x276>
        for(; *s; s++)
 80c:	00094583          	lbu	a1,0(s2)
 810:	c195                	beqz	a1,834 <vprintf+0x284>
          putc(fd, *s);
 812:	855a                	mv	a0,s6
 814:	cd7ff0ef          	jal	4ea <putc>
        for(; *s; s++)
 818:	0905                	addi	s2,s2,1
 81a:	00094583          	lbu	a1,0(s2)
 81e:	f9f5                	bnez	a1,812 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 820:	8bce                	mv	s7,s3
      state = 0;
 822:	4981                	li	s3,0
 824:	bbd9                	j	5fa <vprintf+0x4a>
          s = "(null)";
 826:	00000917          	auipc	s2,0x0
 82a:	25290913          	addi	s2,s2,594 # a78 <malloc+0x146>
        for(; *s; s++)
 82e:	02800593          	li	a1,40
 832:	b7c5                	j	812 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 834:	8bce                	mv	s7,s3
      state = 0;
 836:	4981                	li	s3,0
 838:	b3c9                	j	5fa <vprintf+0x4a>
 83a:	64a6                	ld	s1,72(sp)
 83c:	79e2                	ld	s3,56(sp)
 83e:	7a42                	ld	s4,48(sp)
 840:	7aa2                	ld	s5,40(sp)
 842:	7b02                	ld	s6,32(sp)
 844:	6be2                	ld	s7,24(sp)
 846:	6c42                	ld	s8,16(sp)
 848:	6ca2                	ld	s9,8(sp)
    }
  }
}
 84a:	60e6                	ld	ra,88(sp)
 84c:	6446                	ld	s0,80(sp)
 84e:	6906                	ld	s2,64(sp)
 850:	6125                	addi	sp,sp,96
 852:	8082                	ret

0000000000000854 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 854:	715d                	addi	sp,sp,-80
 856:	ec06                	sd	ra,24(sp)
 858:	e822                	sd	s0,16(sp)
 85a:	1000                	addi	s0,sp,32
 85c:	e010                	sd	a2,0(s0)
 85e:	e414                	sd	a3,8(s0)
 860:	e818                	sd	a4,16(s0)
 862:	ec1c                	sd	a5,24(s0)
 864:	03043023          	sd	a6,32(s0)
 868:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 86c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 870:	8622                	mv	a2,s0
 872:	d3fff0ef          	jal	5b0 <vprintf>
}
 876:	60e2                	ld	ra,24(sp)
 878:	6442                	ld	s0,16(sp)
 87a:	6161                	addi	sp,sp,80
 87c:	8082                	ret

000000000000087e <printf>:

void
printf(const char *fmt, ...)
{
 87e:	711d                	addi	sp,sp,-96
 880:	ec06                	sd	ra,24(sp)
 882:	e822                	sd	s0,16(sp)
 884:	1000                	addi	s0,sp,32
 886:	e40c                	sd	a1,8(s0)
 888:	e810                	sd	a2,16(s0)
 88a:	ec14                	sd	a3,24(s0)
 88c:	f018                	sd	a4,32(s0)
 88e:	f41c                	sd	a5,40(s0)
 890:	03043823          	sd	a6,48(s0)
 894:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 898:	00840613          	addi	a2,s0,8
 89c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a0:	85aa                	mv	a1,a0
 8a2:	4505                	li	a0,1
 8a4:	d0dff0ef          	jal	5b0 <vprintf>
}
 8a8:	60e2                	ld	ra,24(sp)
 8aa:	6442                	ld	s0,16(sp)
 8ac:	6125                	addi	sp,sp,96
 8ae:	8082                	ret

00000000000008b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b0:	1141                	addi	sp,sp,-16
 8b2:	e422                	sd	s0,8(sp)
 8b4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	00000797          	auipc	a5,0x0
 8be:	7467b783          	ld	a5,1862(a5) # 1000 <freep>
 8c2:	a02d                	j	8ec <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c4:	4618                	lw	a4,8(a2)
 8c6:	9f2d                	addw	a4,a4,a1
 8c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	6310                	ld	a2,0(a4)
 8d0:	a83d                	j	90e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8d2:	ff852703          	lw	a4,-8(a0)
 8d6:	9f31                	addw	a4,a4,a2
 8d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8da:	ff053683          	ld	a3,-16(a0)
 8de:	a091                	j	922 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	6398                	ld	a4,0(a5)
 8e2:	00e7e463          	bltu	a5,a4,8ea <free+0x3a>
 8e6:	00e6ea63          	bltu	a3,a4,8fa <free+0x4a>
{
 8ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ec:	fed7fae3          	bgeu	a5,a3,8e0 <free+0x30>
 8f0:	6398                	ld	a4,0(a5)
 8f2:	00e6e463          	bltu	a3,a4,8fa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f6:	fee7eae3          	bltu	a5,a4,8ea <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8fa:	ff852583          	lw	a1,-8(a0)
 8fe:	6390                	ld	a2,0(a5)
 900:	02059813          	slli	a6,a1,0x20
 904:	01c85713          	srli	a4,a6,0x1c
 908:	9736                	add	a4,a4,a3
 90a:	fae60de3          	beq	a2,a4,8c4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 90e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 912:	4790                	lw	a2,8(a5)
 914:	02061593          	slli	a1,a2,0x20
 918:	01c5d713          	srli	a4,a1,0x1c
 91c:	973e                	add	a4,a4,a5
 91e:	fae68ae3          	beq	a3,a4,8d2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 922:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 924:	00000717          	auipc	a4,0x0
 928:	6cf73e23          	sd	a5,1756(a4) # 1000 <freep>
}
 92c:	6422                	ld	s0,8(sp)
 92e:	0141                	addi	sp,sp,16
 930:	8082                	ret

0000000000000932 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 932:	7139                	addi	sp,sp,-64
 934:	fc06                	sd	ra,56(sp)
 936:	f822                	sd	s0,48(sp)
 938:	f426                	sd	s1,40(sp)
 93a:	ec4e                	sd	s3,24(sp)
 93c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 93e:	02051493          	slli	s1,a0,0x20
 942:	9081                	srli	s1,s1,0x20
 944:	04bd                	addi	s1,s1,15
 946:	8091                	srli	s1,s1,0x4
 948:	0014899b          	addiw	s3,s1,1
 94c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 94e:	00000517          	auipc	a0,0x0
 952:	6b253503          	ld	a0,1714(a0) # 1000 <freep>
 956:	c915                	beqz	a0,98a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 958:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95a:	4798                	lw	a4,8(a5)
 95c:	08977a63          	bgeu	a4,s1,9f0 <malloc+0xbe>
 960:	f04a                	sd	s2,32(sp)
 962:	e852                	sd	s4,16(sp)
 964:	e456                	sd	s5,8(sp)
 966:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 968:	8a4e                	mv	s4,s3
 96a:	0009871b          	sext.w	a4,s3
 96e:	6685                	lui	a3,0x1
 970:	00d77363          	bgeu	a4,a3,976 <malloc+0x44>
 974:	6a05                	lui	s4,0x1
 976:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 97a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 97e:	00000917          	auipc	s2,0x0
 982:	68290913          	addi	s2,s2,1666 # 1000 <freep>
  if(p == SBRK_ERROR)
 986:	5afd                	li	s5,-1
 988:	a081                	j	9c8 <malloc+0x96>
 98a:	f04a                	sd	s2,32(sp)
 98c:	e852                	sd	s4,16(sp)
 98e:	e456                	sd	s5,8(sp)
 990:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 992:	00000797          	auipc	a5,0x0
 996:	67e78793          	addi	a5,a5,1662 # 1010 <base>
 99a:	00000717          	auipc	a4,0x0
 99e:	66f73323          	sd	a5,1638(a4) # 1000 <freep>
 9a2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a8:	b7c1                	j	968 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9aa:	6398                	ld	a4,0(a5)
 9ac:	e118                	sd	a4,0(a0)
 9ae:	a8a9                	j	a08 <malloc+0xd6>
  hp->s.size = nu;
 9b0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b4:	0541                	addi	a0,a0,16
 9b6:	efbff0ef          	jal	8b0 <free>
  return freep;
 9ba:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9be:	c12d                	beqz	a0,a20 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c2:	4798                	lw	a4,8(a5)
 9c4:	02977263          	bgeu	a4,s1,9e8 <malloc+0xb6>
    if(p == freep)
 9c8:	00093703          	ld	a4,0(s2)
 9cc:	853e                	mv	a0,a5
 9ce:	fef719e3          	bne	a4,a5,9c0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9d2:	8552                	mv	a0,s4
 9d4:	a3bff0ef          	jal	40e <sbrk>
  if(p == SBRK_ERROR)
 9d8:	fd551ce3          	bne	a0,s5,9b0 <malloc+0x7e>
        return 0;
 9dc:	4501                	li	a0,0
 9de:	7902                	ld	s2,32(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
 9e6:	a03d                	j	a14 <malloc+0xe2>
 9e8:	7902                	ld	s2,32(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9f0:	fae48de3          	beq	s1,a4,9aa <malloc+0x78>
        p->s.size -= nunits;
 9f4:	4137073b          	subw	a4,a4,s3
 9f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9fa:	02071693          	slli	a3,a4,0x20
 9fe:	01c6d713          	srli	a4,a3,0x1c
 a02:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a04:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a08:	00000717          	auipc	a4,0x0
 a0c:	5ea73c23          	sd	a0,1528(a4) # 1000 <freep>
      return (void*)(p + 1);
 a10:	01078513          	addi	a0,a5,16
  }
}
 a14:	70e2                	ld	ra,56(sp)
 a16:	7442                	ld	s0,48(sp)
 a18:	74a2                	ld	s1,40(sp)
 a1a:	69e2                	ld	s3,24(sp)
 a1c:	6121                	addi	sp,sp,64
 a1e:	8082                	ret
 a20:	7902                	ld	s2,32(sp)
 a22:	6a42                	ld	s4,16(sp)
 a24:	6aa2                	ld	s5,8(sp)
 a26:	6b02                	ld	s6,0(sp)
 a28:	b7f5                	j	a14 <malloc+0xe2>
