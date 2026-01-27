
user/_sixfive:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <isdigit>:
// {
//     return (c >= '0' && c <= '9') || (c >= 'A' && c <= 'F') || (c >= 'a' && c <= 'f'); // if c is between 0-9, A-F, or a-f, it's a hex character, return true
// }

int isdigit(char c)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
    return c >= '0' && c <= '9'; // if c is between '0' and '9', it's a digit, return true
   6:	fd05051b          	addiw	a0,a0,-48
   a:	0ff57513          	zext.b	a0,a0
}
   e:	00a53513          	sltiu	a0,a0,10
  12:	6422                	ld	s0,8(sp)
  14:	0141                	addi	sp,sp,16
  16:	8082                	ret

0000000000000018 <main>:

int main(int argc, char *argv[])
{
  18:	7115                	addi	sp,sp,-224
  1a:	ed86                	sd	ra,216(sp)
  1c:	e9a2                	sd	s0,208(sp)
  1e:	1180                	addi	s0,sp,224
    if (argc < 2)
  20:	4785                	li	a5,1
  22:	04a7d263          	bge	a5,a0,66 <main+0x4e>
  26:	e5a6                	sd	s1,200(sp)
  28:	e1ca                	sd	s2,192(sp)
  2a:	fd4e                	sd	s3,184(sp)
  2c:	f952                	sd	s4,176(sp)
  2e:	f556                	sd	s5,168(sp)
  30:	f15a                	sd	s6,160(sp)
  32:	ed5e                	sd	s7,152(sp)
  34:	e962                	sd	s8,144(sp)
  36:	e566                	sd	s9,136(sp)
  38:	e16a                	sd	s10,128(sp)
  3a:	fcee                	sd	s11,120(sp)
  3c:	00858b13          	addi	s6,a1,8
  40:	ffe50c9b          	addiw	s9,a0,-2
  44:	020c9793          	slli	a5,s9,0x20
  48:	01d7dc93          	srli	s9,a5,0x1d
  4c:	05c1                	addi	a1,a1,16
  4e:	9cae                	add	s9,s9,a1
        sum = 0;
        flag = 1; // indicates if we are ready to read a new number

        while (read(fd, &c, 1) != 0) // read one character at a time until end of file
        {
            if (isdigit(c) && flag) // if current char is digit and we are ready to read a new number
  50:	4aa5                	li	s5,9
                {
                    buffer[i] = '\0';
                    sum += atoi(buffer);
                    i = 0;
                }
                if ((sum % 6 == 0 || sum % 5 == 0) && sum != 0) // if sum is multiple of 5 or 6 and not zero
  52:	4c19                	li	s8,6
                {
                    printf("%d\n", sum);
  54:	00001d17          	auipc	s10,0x1
  58:	9fcd0d13          	addi	s10,s10,-1540 # a50 <malloc+0x138>
                }
                sum = 0;  // reset sum for next number
                flag = 0; // set flag to 0, this makes sure we don't read a new number until we see a digit or delimiter
            }
            if ((strchr(delims, c)) || isdigit(c)) // if current char is a delimiter or digit
  5c:	00001a17          	auipc	s4,0x1
  60:	9fca0a13          	addi	s4,s4,-1540 # a58 <malloc+0x140>
  64:	a0c9                	j	126 <main+0x10e>
  66:	e5a6                	sd	s1,200(sp)
  68:	e1ca                	sd	s2,192(sp)
  6a:	fd4e                	sd	s3,184(sp)
  6c:	f952                	sd	s4,176(sp)
  6e:	f556                	sd	s5,168(sp)
  70:	f15a                	sd	s6,160(sp)
  72:	ed5e                	sd	s7,152(sp)
  74:	e962                	sd	s8,144(sp)
  76:	e566                	sd	s9,136(sp)
  78:	e16a                	sd	s10,128(sp)
  7a:	fcee                	sd	s11,120(sp)
        printf("Usage: sixfive <txt file>\n");
  7c:	00001517          	auipc	a0,0x1
  80:	99450513          	addi	a0,a0,-1644 # a10 <malloc+0xf8>
  84:	7e0000ef          	jal	864 <printf>
        exit(1);
  88:	4505                	li	a0,1
  8a:	396000ef          	jal	420 <exit>
                if (i > 0) // if we have read some digits into buffer, that means the number has ended and the current char is a new line or delimiter
  8e:	04904163          	bgtz	s1,d0 <main+0xb8>
            if ((strchr(delims, c)) || isdigit(c)) // if current char is a delimiter or digit
  92:	f8f44583          	lbu	a1,-113(s0)
  96:	8552                	mv	a0,s4
  98:	198000ef          	jal	230 <strchr>
            {
                flag = 1;
  9c:	4905                	li	s2,1
            if ((strchr(delims, c)) || isdigit(c)) // if current char is a delimiter or digit
  9e:	c13d                	beqz	a0,104 <main+0xec>
        while (read(fd, &c, 1) != 0) // read one character at a time until end of file
  a0:	4605                	li	a2,1
  a2:	f8f40593          	addi	a1,s0,-113
  a6:	854e                	mv	a0,s3
  a8:	390000ef          	jal	438 <read>
  ac:	c52d                	beqz	a0,116 <main+0xfe>
            if (isdigit(c) && flag) // if current char is digit and we are ready to read a new number
  ae:	f8f44703          	lbu	a4,-113(s0)
    return c >= '0' && c <= '9'; // if c is between '0' and '9', it's a digit, return true
  b2:	fd07079b          	addiw	a5,a4,-48
            if (isdigit(c) && flag) // if current char is digit and we are ready to read a new number
  b6:	0ff7f793          	zext.b	a5,a5
  ba:	fcfaeae3          	bltu	s5,a5,8e <main+0x76>
  be:	fc0908e3          	beqz	s2,8e <main+0x76>
                buffer[i] = c;
  c2:	f9048793          	addi	a5,s1,-112
  c6:	97a2                	add	a5,a5,s0
  c8:	f8e78c23          	sb	a4,-104(a5)
                i++;
  cc:	2485                	addiw	s1,s1,1
                flag = 0; // set flag to 0 to indicate we are in the middle of reading a number
  ce:	b7d1                	j	92 <main+0x7a>
                    buffer[i] = '\0';
  d0:	f9048793          	addi	a5,s1,-112
  d4:	008784b3          	add	s1,a5,s0
  d8:	f8048c23          	sb	zero,-104(s1)
                    sum += atoi(buffer);
  dc:	f2840513          	addi	a0,s0,-216
  e0:	21e000ef          	jal	2fe <atoi>
  e4:	84aa                	mv	s1,a0
                if ((sum % 6 == 0 || sum % 5 == 0) && sum != 0) // if sum is multiple of 5 or 6 and not zero
  e6:	038567bb          	remw	a5,a0,s8
  ea:	c781                	beqz	a5,f2 <main+0xda>
  ec:	037567bb          	remw	a5,a0,s7
  f0:	eb81                	bnez	a5,100 <main+0xe8>
  f2:	d0c5                	beqz	s1,92 <main+0x7a>
                    printf("%d\n", sum);
  f4:	85a6                	mv	a1,s1
  f6:	856a                	mv	a0,s10
  f8:	76c000ef          	jal	864 <printf>
  fc:	84ee                	mv	s1,s11
  fe:	bf51                	j	92 <main+0x7a>
 100:	84ee                	mv	s1,s11
 102:	bf41                	j	92 <main+0x7a>
    return c >= '0' && c <= '9'; // if c is between '0' and '9', it's a digit, return true
 104:	f8f44903          	lbu	s2,-113(s0)
 108:	fd09091b          	addiw	s2,s2,-48
            if ((strchr(delims, c)) || isdigit(c)) // if current char is a delimiter or digit
 10c:	0ff97913          	zext.b	s2,s2
 110:	00a93913          	sltiu	s2,s2,10
 114:	b771                	j	a0 <main+0x88>
            }
        }

        if (i > 0) // if there are remaining digits in buffer after EOF
 116:	02904d63          	bgtz	s1,150 <main+0x138>
            {
                printf("%d\n", sum);
            }
        }

        close(fd);
 11a:	854e                	mv	a0,s3
 11c:	32c000ef          	jal	448 <close>
    for (int k = 1; k < argc; k++) // loop through all provided files
 120:	0b21                	addi	s6,s6,8
 122:	079b0163          	beq	s6,s9,184 <main+0x16c>
        int fd = open(argv[k], O_RDONLY); // open given file in read-only mode
 126:	4581                	li	a1,0
 128:	000b3503          	ld	a0,0(s6)
 12c:	334000ef          	jal	460 <open>
 130:	89aa                	mv	s3,a0
        flag = 1; // indicates if we are ready to read a new number
 132:	4905                	li	s2,1
        i = 0;
 134:	4481                	li	s1,0
                    printf("%d\n", sum);
 136:	4d81                	li	s11,0
                if ((sum % 6 == 0 || sum % 5 == 0) && sum != 0) // if sum is multiple of 5 or 6 and not zero
 138:	4b95                	li	s7,5
        if (fd < 0)                       // if fd is negative, file open failed
 13a:	f60553e3          	bgez	a0,a0 <main+0x88>
            printf("Error: Could not open file %s\n", argv[k]);
 13e:	000b3583          	ld	a1,0(s6)
 142:	00001517          	auipc	a0,0x1
 146:	8ee50513          	addi	a0,a0,-1810 # a30 <malloc+0x118>
 14a:	71a000ef          	jal	864 <printf>
            continue;
 14e:	bfc9                	j	120 <main+0x108>
            buffer[i] = '\0';
 150:	f9048793          	addi	a5,s1,-112
 154:	008784b3          	add	s1,a5,s0
 158:	f8048c23          	sb	zero,-104(s1)
            sum += atoi(buffer);
 15c:	f2840513          	addi	a0,s0,-216
 160:	19e000ef          	jal	2fe <atoi>
            if ((sum % 6 == 0 || sum % 5 == 0) && sum != 0)
 164:	038567bb          	remw	a5,a0,s8
 168:	c789                	beqz	a5,172 <main+0x15a>
 16a:	4795                	li	a5,5
 16c:	02f567bb          	remw	a5,a0,a5
 170:	f7cd                	bnez	a5,11a <main+0x102>
 172:	d545                	beqz	a0,11a <main+0x102>
                printf("%d\n", sum);
 174:	85aa                	mv	a1,a0
 176:	00001517          	auipc	a0,0x1
 17a:	8da50513          	addi	a0,a0,-1830 # a50 <malloc+0x138>
 17e:	6e6000ef          	jal	864 <printf>
 182:	bf61                	j	11a <main+0x102>
    }
    exit(0);
 184:	4501                	li	a0,0
 186:	29a000ef          	jal	420 <exit>

000000000000018a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
  extern int main();
  main();
 192:	e87ff0ef          	jal	18 <main>
  exit(0);
 196:	4501                	li	a0,0
 198:	288000ef          	jal	420 <exit>

000000000000019c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a2:	87aa                	mv	a5,a0
 1a4:	0585                	addi	a1,a1,1
 1a6:	0785                	addi	a5,a5,1
 1a8:	fff5c703          	lbu	a4,-1(a1)
 1ac:	fee78fa3          	sb	a4,-1(a5)
 1b0:	fb75                	bnez	a4,1a4 <strcpy+0x8>
    ;
  return os;
}
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cb91                	beqz	a5,1d6 <strcmp+0x1e>
 1c4:	0005c703          	lbu	a4,0(a1)
 1c8:	00f71763          	bne	a4,a5,1d6 <strcmp+0x1e>
    p++, q++;
 1cc:	0505                	addi	a0,a0,1
 1ce:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d0:	00054783          	lbu	a5,0(a0)
 1d4:	fbe5                	bnez	a5,1c4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d6:	0005c503          	lbu	a0,0(a1)
}
 1da:	40a7853b          	subw	a0,a5,a0
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret

00000000000001e4 <strlen>:

uint
strlen(const char *s)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ea:	00054783          	lbu	a5,0(a0)
 1ee:	cf91                	beqz	a5,20a <strlen+0x26>
 1f0:	0505                	addi	a0,a0,1
 1f2:	87aa                	mv	a5,a0
 1f4:	86be                	mv	a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	ff65                	bnez	a4,1f4 <strlen+0x10>
 1fe:	40a6853b          	subw	a0,a3,a0
 202:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
  for(n = 0; s[n]; n++)
 20a:	4501                	li	a0,0
 20c:	bfe5                	j	204 <strlen+0x20>

000000000000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e422                	sd	s0,8(sp)
 212:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 214:	ca19                	beqz	a2,22a <memset+0x1c>
 216:	87aa                	mv	a5,a0
 218:	1602                	slli	a2,a2,0x20
 21a:	9201                	srli	a2,a2,0x20
 21c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 220:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 224:	0785                	addi	a5,a5,1
 226:	fee79de3          	bne	a5,a4,220 <memset+0x12>
  }
  return dst;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret

0000000000000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  for(; *s; s++)
 236:	00054783          	lbu	a5,0(a0)
 23a:	cb99                	beqz	a5,250 <strchr+0x20>
    if(*s == c)
 23c:	00f58763          	beq	a1,a5,24a <strchr+0x1a>
  for(; *s; s++)
 240:	0505                	addi	a0,a0,1
 242:	00054783          	lbu	a5,0(a0)
 246:	fbfd                	bnez	a5,23c <strchr+0xc>
      return (char*)s;
  return 0;
 248:	4501                	li	a0,0
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
  return 0;
 250:	4501                	li	a0,0
 252:	bfe5                	j	24a <strchr+0x1a>

0000000000000254 <gets>:

char*
gets(char *buf, int max)
{
 254:	711d                	addi	sp,sp,-96
 256:	ec86                	sd	ra,88(sp)
 258:	e8a2                	sd	s0,80(sp)
 25a:	e4a6                	sd	s1,72(sp)
 25c:	e0ca                	sd	s2,64(sp)
 25e:	fc4e                	sd	s3,56(sp)
 260:	f852                	sd	s4,48(sp)
 262:	f456                	sd	s5,40(sp)
 264:	f05a                	sd	s6,32(sp)
 266:	ec5e                	sd	s7,24(sp)
 268:	1080                	addi	s0,sp,96
 26a:	8baa                	mv	s7,a0
 26c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26e:	892a                	mv	s2,a0
 270:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 272:	4aa9                	li	s5,10
 274:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 276:	89a6                	mv	s3,s1
 278:	2485                	addiw	s1,s1,1
 27a:	0344d663          	bge	s1,s4,2a6 <gets+0x52>
    cc = read(0, &c, 1);
 27e:	4605                	li	a2,1
 280:	faf40593          	addi	a1,s0,-81
 284:	4501                	li	a0,0
 286:	1b2000ef          	jal	438 <read>
    if(cc < 1)
 28a:	00a05e63          	blez	a0,2a6 <gets+0x52>
    buf[i++] = c;
 28e:	faf44783          	lbu	a5,-81(s0)
 292:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 296:	01578763          	beq	a5,s5,2a4 <gets+0x50>
 29a:	0905                	addi	s2,s2,1
 29c:	fd679de3          	bne	a5,s6,276 <gets+0x22>
    buf[i++] = c;
 2a0:	89a6                	mv	s3,s1
 2a2:	a011                	j	2a6 <gets+0x52>
 2a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a6:	99de                	add	s3,s3,s7
 2a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ac:	855e                	mv	a0,s7
 2ae:	60e6                	ld	ra,88(sp)
 2b0:	6446                	ld	s0,80(sp)
 2b2:	64a6                	ld	s1,72(sp)
 2b4:	6906                	ld	s2,64(sp)
 2b6:	79e2                	ld	s3,56(sp)
 2b8:	7a42                	ld	s4,48(sp)
 2ba:	7aa2                	ld	s5,40(sp)
 2bc:	7b02                	ld	s6,32(sp)
 2be:	6be2                	ld	s7,24(sp)
 2c0:	6125                	addi	sp,sp,96
 2c2:	8082                	ret

00000000000002c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c4:	1101                	addi	sp,sp,-32
 2c6:	ec06                	sd	ra,24(sp)
 2c8:	e822                	sd	s0,16(sp)
 2ca:	e04a                	sd	s2,0(sp)
 2cc:	1000                	addi	s0,sp,32
 2ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	4581                	li	a1,0
 2d2:	18e000ef          	jal	460 <open>
  if(fd < 0)
 2d6:	02054263          	bltz	a0,2fa <stat+0x36>
 2da:	e426                	sd	s1,8(sp)
 2dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2de:	85ca                	mv	a1,s2
 2e0:	198000ef          	jal	478 <fstat>
 2e4:	892a                	mv	s2,a0
  close(fd);
 2e6:	8526                	mv	a0,s1
 2e8:	160000ef          	jal	448 <close>
  return r;
 2ec:	64a2                	ld	s1,8(sp)
}
 2ee:	854a                	mv	a0,s2
 2f0:	60e2                	ld	ra,24(sp)
 2f2:	6442                	ld	s0,16(sp)
 2f4:	6902                	ld	s2,0(sp)
 2f6:	6105                	addi	sp,sp,32
 2f8:	8082                	ret
    return -1;
 2fa:	597d                	li	s2,-1
 2fc:	bfcd                	j	2ee <stat+0x2a>

00000000000002fe <atoi>:

int
atoi(const char *s)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 304:	00054683          	lbu	a3,0(a0)
 308:	fd06879b          	addiw	a5,a3,-48
 30c:	0ff7f793          	zext.b	a5,a5
 310:	4625                	li	a2,9
 312:	02f66863          	bltu	a2,a5,342 <atoi+0x44>
 316:	872a                	mv	a4,a0
  n = 0;
 318:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 31a:	0705                	addi	a4,a4,1
 31c:	0025179b          	slliw	a5,a0,0x2
 320:	9fa9                	addw	a5,a5,a0
 322:	0017979b          	slliw	a5,a5,0x1
 326:	9fb5                	addw	a5,a5,a3
 328:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 32c:	00074683          	lbu	a3,0(a4)
 330:	fd06879b          	addiw	a5,a3,-48
 334:	0ff7f793          	zext.b	a5,a5
 338:	fef671e3          	bgeu	a2,a5,31a <atoi+0x1c>
  return n;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  n = 0;
 342:	4501                	li	a0,0
 344:	bfe5                	j	33c <atoi+0x3e>

0000000000000346 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e422                	sd	s0,8(sp)
 34a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34c:	02b57463          	bgeu	a0,a1,374 <memmove+0x2e>
    while(n-- > 0)
 350:	00c05f63          	blez	a2,36e <memmove+0x28>
 354:	1602                	slli	a2,a2,0x20
 356:	9201                	srli	a2,a2,0x20
 358:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35c:	872a                	mv	a4,a0
      *dst++ = *src++;
 35e:	0585                	addi	a1,a1,1
 360:	0705                	addi	a4,a4,1
 362:	fff5c683          	lbu	a3,-1(a1)
 366:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 36a:	fef71ae3          	bne	a4,a5,35e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret
    dst += n;
 374:	00c50733          	add	a4,a0,a2
    src += n;
 378:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37a:	fec05ae3          	blez	a2,36e <memmove+0x28>
 37e:	fff6079b          	addiw	a5,a2,-1
 382:	1782                	slli	a5,a5,0x20
 384:	9381                	srli	a5,a5,0x20
 386:	fff7c793          	not	a5,a5
 38a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38c:	15fd                	addi	a1,a1,-1
 38e:	177d                	addi	a4,a4,-1
 390:	0005c683          	lbu	a3,0(a1)
 394:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 398:	fee79ae3          	bne	a5,a4,38c <memmove+0x46>
 39c:	bfc9                	j	36e <memmove+0x28>

000000000000039e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e422                	sd	s0,8(sp)
 3a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a4:	ca05                	beqz	a2,3d4 <memcmp+0x36>
 3a6:	fff6069b          	addiw	a3,a2,-1
 3aa:	1682                	slli	a3,a3,0x20
 3ac:	9281                	srli	a3,a3,0x20
 3ae:	0685                	addi	a3,a3,1
 3b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	0005c703          	lbu	a4,0(a1)
 3ba:	00e79863          	bne	a5,a4,3ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3be:	0505                	addi	a0,a0,1
    p2++;
 3c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c2:	fed518e3          	bne	a0,a3,3b2 <memcmp+0x14>
  }
  return 0;
 3c6:	4501                	li	a0,0
 3c8:	a019                	j	3ce <memcmp+0x30>
      return *p1 - *p2;
 3ca:	40e7853b          	subw	a0,a5,a4
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret
  return 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <memcmp+0x30>

00000000000003d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d8:	1141                	addi	sp,sp,-16
 3da:	e406                	sd	ra,8(sp)
 3dc:	e022                	sd	s0,0(sp)
 3de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e0:	f67ff0ef          	jal	346 <memmove>
}
 3e4:	60a2                	ld	ra,8(sp)
 3e6:	6402                	ld	s0,0(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret

00000000000003ec <sbrk>:

char *
sbrk(int n) {
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e406                	sd	ra,8(sp)
 3f0:	e022                	sd	s0,0(sp)
 3f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3f4:	4585                	li	a1,1
 3f6:	0b2000ef          	jal	4a8 <sys_sbrk>
}
 3fa:	60a2                	ld	ra,8(sp)
 3fc:	6402                	ld	s0,0(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret

0000000000000402 <sbrklazy>:

char *
sbrklazy(int n) {
 402:	1141                	addi	sp,sp,-16
 404:	e406                	sd	ra,8(sp)
 406:	e022                	sd	s0,0(sp)
 408:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 40a:	4589                	li	a1,2
 40c:	09c000ef          	jal	4a8 <sys_sbrk>
}
 410:	60a2                	ld	ra,8(sp)
 412:	6402                	ld	s0,0(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret

0000000000000418 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 418:	4885                	li	a7,1
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <exit>:
.global exit
exit:
 li a7, SYS_exit
 420:	4889                	li	a7,2
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <wait>:
.global wait
wait:
 li a7, SYS_wait
 428:	488d                	li	a7,3
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 430:	4891                	li	a7,4
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <read>:
.global read
read:
 li a7, SYS_read
 438:	4895                	li	a7,5
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <write>:
.global write
write:
 li a7, SYS_write
 440:	48c1                	li	a7,16
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <close>:
.global close
close:
 li a7, SYS_close
 448:	48d5                	li	a7,21
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <kill>:
.global kill
kill:
 li a7, SYS_kill
 450:	4899                	li	a7,6
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <exec>:
.global exec
exec:
 li a7, SYS_exec
 458:	489d                	li	a7,7
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <open>:
.global open
open:
 li a7, SYS_open
 460:	48bd                	li	a7,15
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 468:	48c5                	li	a7,17
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 470:	48c9                	li	a7,18
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 478:	48a1                	li	a7,8
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <link>:
.global link
link:
 li a7, SYS_link
 480:	48cd                	li	a7,19
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 488:	48d1                	li	a7,20
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 490:	48a5                	li	a7,9
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <dup>:
.global dup
dup:
 li a7, SYS_dup
 498:	48a9                	li	a7,10
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a0:	48ad                	li	a7,11
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4a8:	48b1                	li	a7,12
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4b0:	48b5                	li	a7,13
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b8:	48b9                	li	a7,14
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <hello>:
.global hello
hello:
 li a7, SYS_hello
 4c0:	48dd                	li	a7,23
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
 4c8:	48d9                	li	a7,22
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d0:	1101                	addi	sp,sp,-32
 4d2:	ec06                	sd	ra,24(sp)
 4d4:	e822                	sd	s0,16(sp)
 4d6:	1000                	addi	s0,sp,32
 4d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4dc:	4605                	li	a2,1
 4de:	fef40593          	addi	a1,s0,-17
 4e2:	f5fff0ef          	jal	440 <write>
}
 4e6:	60e2                	ld	ra,24(sp)
 4e8:	6442                	ld	s0,16(sp)
 4ea:	6105                	addi	sp,sp,32
 4ec:	8082                	ret

00000000000004ee <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4ee:	715d                	addi	sp,sp,-80
 4f0:	e486                	sd	ra,72(sp)
 4f2:	e0a2                	sd	s0,64(sp)
 4f4:	fc26                	sd	s1,56(sp)
 4f6:	0880                	addi	s0,sp,80
 4f8:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fa:	c299                	beqz	a3,500 <printint+0x12>
 4fc:	0805c963          	bltz	a1,58e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 500:	2581                	sext.w	a1,a1
  neg = 0;
 502:	4881                	li	a7,0
 504:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 508:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 50a:	2601                	sext.w	a2,a2
 50c:	00000517          	auipc	a0,0x0
 510:	55c50513          	addi	a0,a0,1372 # a68 <digits>
 514:	883a                	mv	a6,a4
 516:	2705                	addiw	a4,a4,1
 518:	02c5f7bb          	remuw	a5,a1,a2
 51c:	1782                	slli	a5,a5,0x20
 51e:	9381                	srli	a5,a5,0x20
 520:	97aa                	add	a5,a5,a0
 522:	0007c783          	lbu	a5,0(a5)
 526:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 52a:	0005879b          	sext.w	a5,a1
 52e:	02c5d5bb          	divuw	a1,a1,a2
 532:	0685                	addi	a3,a3,1
 534:	fec7f0e3          	bgeu	a5,a2,514 <printint+0x26>
  if(neg)
 538:	00088c63          	beqz	a7,550 <printint+0x62>
    buf[i++] = '-';
 53c:	fd070793          	addi	a5,a4,-48
 540:	00878733          	add	a4,a5,s0
 544:	02d00793          	li	a5,45
 548:	fef70423          	sb	a5,-24(a4)
 54c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 550:	02e05a63          	blez	a4,584 <printint+0x96>
 554:	f84a                	sd	s2,48(sp)
 556:	f44e                	sd	s3,40(sp)
 558:	fb840793          	addi	a5,s0,-72
 55c:	00e78933          	add	s2,a5,a4
 560:	fff78993          	addi	s3,a5,-1
 564:	99ba                	add	s3,s3,a4
 566:	377d                	addiw	a4,a4,-1
 568:	1702                	slli	a4,a4,0x20
 56a:	9301                	srli	a4,a4,0x20
 56c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 570:	fff94583          	lbu	a1,-1(s2)
 574:	8526                	mv	a0,s1
 576:	f5bff0ef          	jal	4d0 <putc>
  while(--i >= 0)
 57a:	197d                	addi	s2,s2,-1
 57c:	ff391ae3          	bne	s2,s3,570 <printint+0x82>
 580:	7942                	ld	s2,48(sp)
 582:	79a2                	ld	s3,40(sp)
}
 584:	60a6                	ld	ra,72(sp)
 586:	6406                	ld	s0,64(sp)
 588:	74e2                	ld	s1,56(sp)
 58a:	6161                	addi	sp,sp,80
 58c:	8082                	ret
    x = -xx;
 58e:	40b005bb          	negw	a1,a1
    neg = 1;
 592:	4885                	li	a7,1
    x = -xx;
 594:	bf85                	j	504 <printint+0x16>

0000000000000596 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 596:	711d                	addi	sp,sp,-96
 598:	ec86                	sd	ra,88(sp)
 59a:	e8a2                	sd	s0,80(sp)
 59c:	e0ca                	sd	s2,64(sp)
 59e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5a0:	0005c903          	lbu	s2,0(a1)
 5a4:	28090663          	beqz	s2,830 <vprintf+0x29a>
 5a8:	e4a6                	sd	s1,72(sp)
 5aa:	fc4e                	sd	s3,56(sp)
 5ac:	f852                	sd	s4,48(sp)
 5ae:	f456                	sd	s5,40(sp)
 5b0:	f05a                	sd	s6,32(sp)
 5b2:	ec5e                	sd	s7,24(sp)
 5b4:	e862                	sd	s8,16(sp)
 5b6:	e466                	sd	s9,8(sp)
 5b8:	8b2a                	mv	s6,a0
 5ba:	8a2e                	mv	s4,a1
 5bc:	8bb2                	mv	s7,a2
  state = 0;
 5be:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5c0:	4481                	li	s1,0
 5c2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5c4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5c8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5cc:	06c00c93          	li	s9,108
 5d0:	a005                	j	5f0 <vprintf+0x5a>
        putc(fd, c0);
 5d2:	85ca                	mv	a1,s2
 5d4:	855a                	mv	a0,s6
 5d6:	efbff0ef          	jal	4d0 <putc>
 5da:	a019                	j	5e0 <vprintf+0x4a>
    } else if(state == '%'){
 5dc:	03598263          	beq	s3,s5,600 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5e0:	2485                	addiw	s1,s1,1
 5e2:	8726                	mv	a4,s1
 5e4:	009a07b3          	add	a5,s4,s1
 5e8:	0007c903          	lbu	s2,0(a5)
 5ec:	22090a63          	beqz	s2,820 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5f0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5f4:	fe0994e3          	bnez	s3,5dc <vprintf+0x46>
      if(c0 == '%'){
 5f8:	fd579de3          	bne	a5,s5,5d2 <vprintf+0x3c>
        state = '%';
 5fc:	89be                	mv	s3,a5
 5fe:	b7cd                	j	5e0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 600:	00ea06b3          	add	a3,s4,a4
 604:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 608:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 60a:	c681                	beqz	a3,612 <vprintf+0x7c>
 60c:	9752                	add	a4,a4,s4
 60e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 612:	05878363          	beq	a5,s8,658 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 616:	05978d63          	beq	a5,s9,670 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 61a:	07500713          	li	a4,117
 61e:	0ee78763          	beq	a5,a4,70c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 622:	07800713          	li	a4,120
 626:	12e78963          	beq	a5,a4,758 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 62a:	07000713          	li	a4,112
 62e:	14e78e63          	beq	a5,a4,78a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 632:	06300713          	li	a4,99
 636:	18e78e63          	beq	a5,a4,7d2 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 63a:	07300713          	li	a4,115
 63e:	1ae78463          	beq	a5,a4,7e6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 642:	02500713          	li	a4,37
 646:	04e79563          	bne	a5,a4,690 <vprintf+0xfa>
        putc(fd, '%');
 64a:	02500593          	li	a1,37
 64e:	855a                	mv	a0,s6
 650:	e81ff0ef          	jal	4d0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 654:	4981                	li	s3,0
 656:	b769                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 658:	008b8913          	addi	s2,s7,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000ba583          	lw	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	e89ff0ef          	jal	4ee <printint>
 66a:	8bca                	mv	s7,s2
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bf8d                	j	5e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 670:	06400793          	li	a5,100
 674:	02f68963          	beq	a3,a5,6a6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 678:	06c00793          	li	a5,108
 67c:	04f68263          	beq	a3,a5,6c0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 680:	07500793          	li	a5,117
 684:	0af68063          	beq	a3,a5,724 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 688:	07800793          	li	a5,120
 68c:	0ef68263          	beq	a3,a5,770 <vprintf+0x1da>
        putc(fd, '%');
 690:	02500593          	li	a1,37
 694:	855a                	mv	a0,s6
 696:	e3bff0ef          	jal	4d0 <putc>
        putc(fd, c0);
 69a:	85ca                	mv	a1,s2
 69c:	855a                	mv	a0,s6
 69e:	e33ff0ef          	jal	4d0 <putc>
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bf35                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4685                	li	a3,1
 6ac:	4629                	li	a2,10
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	e3bff0ef          	jal	4ee <printint>
        i += 1;
 6b8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
        i += 1;
 6be:	b70d                	j	5e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c0:	06400793          	li	a5,100
 6c4:	02f60763          	beq	a2,a5,6f2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6c8:	07500793          	li	a5,117
 6cc:	06f60963          	beq	a2,a5,73e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6d0:	07800793          	li	a5,120
 6d4:	faf61ee3          	bne	a2,a5,690 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4641                	li	a2,16
 6e0:	000bb583          	ld	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	e09ff0ef          	jal	4ee <printint>
        i += 2;
 6ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 2;
 6f0:	bdc5                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4685                	li	a3,1
 6f8:	4629                	li	a2,10
 6fa:	000bb583          	ld	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	defff0ef          	jal	4ee <printint>
        i += 2;
 704:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 2;
 70a:	bdd9                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 70c:	008b8913          	addi	s2,s7,8
 710:	4681                	li	a3,0
 712:	4629                	li	a2,10
 714:	000be583          	lwu	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	dd5ff0ef          	jal	4ee <printint>
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
 722:	bd7d                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 724:	008b8913          	addi	s2,s7,8
 728:	4681                	li	a3,0
 72a:	4629                	li	a2,10
 72c:	000bb583          	ld	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	dbdff0ef          	jal	4ee <printint>
        i += 1;
 736:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
        i += 1;
 73c:	b555                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73e:	008b8913          	addi	s2,s7,8
 742:	4681                	li	a3,0
 744:	4629                	li	a2,10
 746:	000bb583          	ld	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	da3ff0ef          	jal	4ee <printint>
        i += 2;
 750:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 752:	8bca                	mv	s7,s2
      state = 0;
 754:	4981                	li	s3,0
        i += 2;
 756:	b569                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 758:	008b8913          	addi	s2,s7,8
 75c:	4681                	li	a3,0
 75e:	4641                	li	a2,16
 760:	000be583          	lwu	a1,0(s7)
 764:	855a                	mv	a0,s6
 766:	d89ff0ef          	jal	4ee <printint>
 76a:	8bca                	mv	s7,s2
      state = 0;
 76c:	4981                	li	s3,0
 76e:	bd8d                	j	5e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 770:	008b8913          	addi	s2,s7,8
 774:	4681                	li	a3,0
 776:	4641                	li	a2,16
 778:	000bb583          	ld	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	d71ff0ef          	jal	4ee <printint>
        i += 1;
 782:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 784:	8bca                	mv	s7,s2
      state = 0;
 786:	4981                	li	s3,0
        i += 1;
 788:	bda1                	j	5e0 <vprintf+0x4a>
 78a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 78c:	008b8d13          	addi	s10,s7,8
 790:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 794:	03000593          	li	a1,48
 798:	855a                	mv	a0,s6
 79a:	d37ff0ef          	jal	4d0 <putc>
  putc(fd, 'x');
 79e:	07800593          	li	a1,120
 7a2:	855a                	mv	a0,s6
 7a4:	d2dff0ef          	jal	4d0 <putc>
 7a8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7aa:	00000b97          	auipc	s7,0x0
 7ae:	2beb8b93          	addi	s7,s7,702 # a68 <digits>
 7b2:	03c9d793          	srli	a5,s3,0x3c
 7b6:	97de                	add	a5,a5,s7
 7b8:	0007c583          	lbu	a1,0(a5)
 7bc:	855a                	mv	a0,s6
 7be:	d13ff0ef          	jal	4d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7c2:	0992                	slli	s3,s3,0x4
 7c4:	397d                	addiw	s2,s2,-1
 7c6:	fe0916e3          	bnez	s2,7b2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7ca:	8bea                	mv	s7,s10
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	6d02                	ld	s10,0(sp)
 7d0:	bd01                	j	5e0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7d2:	008b8913          	addi	s2,s7,8
 7d6:	000bc583          	lbu	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	cf5ff0ef          	jal	4d0 <putc>
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bbf5                	j	5e0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7e6:	008b8993          	addi	s3,s7,8
 7ea:	000bb903          	ld	s2,0(s7)
 7ee:	00090f63          	beqz	s2,80c <vprintf+0x276>
        for(; *s; s++)
 7f2:	00094583          	lbu	a1,0(s2)
 7f6:	c195                	beqz	a1,81a <vprintf+0x284>
          putc(fd, *s);
 7f8:	855a                	mv	a0,s6
 7fa:	cd7ff0ef          	jal	4d0 <putc>
        for(; *s; s++)
 7fe:	0905                	addi	s2,s2,1
 800:	00094583          	lbu	a1,0(s2)
 804:	f9f5                	bnez	a1,7f8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 806:	8bce                	mv	s7,s3
      state = 0;
 808:	4981                	li	s3,0
 80a:	bbd9                	j	5e0 <vprintf+0x4a>
          s = "(null)";
 80c:	00000917          	auipc	s2,0x0
 810:	25490913          	addi	s2,s2,596 # a60 <malloc+0x148>
        for(; *s; s++)
 814:	02800593          	li	a1,40
 818:	b7c5                	j	7f8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 81a:	8bce                	mv	s7,s3
      state = 0;
 81c:	4981                	li	s3,0
 81e:	b3c9                	j	5e0 <vprintf+0x4a>
 820:	64a6                	ld	s1,72(sp)
 822:	79e2                	ld	s3,56(sp)
 824:	7a42                	ld	s4,48(sp)
 826:	7aa2                	ld	s5,40(sp)
 828:	7b02                	ld	s6,32(sp)
 82a:	6be2                	ld	s7,24(sp)
 82c:	6c42                	ld	s8,16(sp)
 82e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 830:	60e6                	ld	ra,88(sp)
 832:	6446                	ld	s0,80(sp)
 834:	6906                	ld	s2,64(sp)
 836:	6125                	addi	sp,sp,96
 838:	8082                	ret

000000000000083a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83a:	715d                	addi	sp,sp,-80
 83c:	ec06                	sd	ra,24(sp)
 83e:	e822                	sd	s0,16(sp)
 840:	1000                	addi	s0,sp,32
 842:	e010                	sd	a2,0(s0)
 844:	e414                	sd	a3,8(s0)
 846:	e818                	sd	a4,16(s0)
 848:	ec1c                	sd	a5,24(s0)
 84a:	03043023          	sd	a6,32(s0)
 84e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 852:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 856:	8622                	mv	a2,s0
 858:	d3fff0ef          	jal	596 <vprintf>
}
 85c:	60e2                	ld	ra,24(sp)
 85e:	6442                	ld	s0,16(sp)
 860:	6161                	addi	sp,sp,80
 862:	8082                	ret

0000000000000864 <printf>:

void
printf(const char *fmt, ...)
{
 864:	711d                	addi	sp,sp,-96
 866:	ec06                	sd	ra,24(sp)
 868:	e822                	sd	s0,16(sp)
 86a:	1000                	addi	s0,sp,32
 86c:	e40c                	sd	a1,8(s0)
 86e:	e810                	sd	a2,16(s0)
 870:	ec14                	sd	a3,24(s0)
 872:	f018                	sd	a4,32(s0)
 874:	f41c                	sd	a5,40(s0)
 876:	03043823          	sd	a6,48(s0)
 87a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87e:	00840613          	addi	a2,s0,8
 882:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 886:	85aa                	mv	a1,a0
 888:	4505                	li	a0,1
 88a:	d0dff0ef          	jal	596 <vprintf>
}
 88e:	60e2                	ld	ra,24(sp)
 890:	6442                	ld	s0,16(sp)
 892:	6125                	addi	sp,sp,96
 894:	8082                	ret

0000000000000896 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 896:	1141                	addi	sp,sp,-16
 898:	e422                	sd	s0,8(sp)
 89a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a0:	00000797          	auipc	a5,0x0
 8a4:	7607b783          	ld	a5,1888(a5) # 1000 <freep>
 8a8:	a02d                	j	8d2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8aa:	4618                	lw	a4,8(a2)
 8ac:	9f2d                	addw	a4,a4,a1
 8ae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b2:	6398                	ld	a4,0(a5)
 8b4:	6310                	ld	a2,0(a4)
 8b6:	a83d                	j	8f4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b8:	ff852703          	lw	a4,-8(a0)
 8bc:	9f31                	addw	a4,a4,a2
 8be:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c0:	ff053683          	ld	a3,-16(a0)
 8c4:	a091                	j	908 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c6:	6398                	ld	a4,0(a5)
 8c8:	00e7e463          	bltu	a5,a4,8d0 <free+0x3a>
 8cc:	00e6ea63          	bltu	a3,a4,8e0 <free+0x4a>
{
 8d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d2:	fed7fae3          	bgeu	a5,a3,8c6 <free+0x30>
 8d6:	6398                	ld	a4,0(a5)
 8d8:	00e6e463          	bltu	a3,a4,8e0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8dc:	fee7eae3          	bltu	a5,a4,8d0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8e0:	ff852583          	lw	a1,-8(a0)
 8e4:	6390                	ld	a2,0(a5)
 8e6:	02059813          	slli	a6,a1,0x20
 8ea:	01c85713          	srli	a4,a6,0x1c
 8ee:	9736                	add	a4,a4,a3
 8f0:	fae60de3          	beq	a2,a4,8aa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f8:	4790                	lw	a2,8(a5)
 8fa:	02061593          	slli	a1,a2,0x20
 8fe:	01c5d713          	srli	a4,a1,0x1c
 902:	973e                	add	a4,a4,a5
 904:	fae68ae3          	beq	a3,a4,8b8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 908:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 90a:	00000717          	auipc	a4,0x0
 90e:	6ef73b23          	sd	a5,1782(a4) # 1000 <freep>
}
 912:	6422                	ld	s0,8(sp)
 914:	0141                	addi	sp,sp,16
 916:	8082                	ret

0000000000000918 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 918:	7139                	addi	sp,sp,-64
 91a:	fc06                	sd	ra,56(sp)
 91c:	f822                	sd	s0,48(sp)
 91e:	f426                	sd	s1,40(sp)
 920:	ec4e                	sd	s3,24(sp)
 922:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 924:	02051493          	slli	s1,a0,0x20
 928:	9081                	srli	s1,s1,0x20
 92a:	04bd                	addi	s1,s1,15
 92c:	8091                	srli	s1,s1,0x4
 92e:	0014899b          	addiw	s3,s1,1
 932:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 934:	00000517          	auipc	a0,0x0
 938:	6cc53503          	ld	a0,1740(a0) # 1000 <freep>
 93c:	c915                	beqz	a0,970 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 940:	4798                	lw	a4,8(a5)
 942:	08977a63          	bgeu	a4,s1,9d6 <malloc+0xbe>
 946:	f04a                	sd	s2,32(sp)
 948:	e852                	sd	s4,16(sp)
 94a:	e456                	sd	s5,8(sp)
 94c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 94e:	8a4e                	mv	s4,s3
 950:	0009871b          	sext.w	a4,s3
 954:	6685                	lui	a3,0x1
 956:	00d77363          	bgeu	a4,a3,95c <malloc+0x44>
 95a:	6a05                	lui	s4,0x1
 95c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 960:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 964:	00000917          	auipc	s2,0x0
 968:	69c90913          	addi	s2,s2,1692 # 1000 <freep>
  if(p == SBRK_ERROR)
 96c:	5afd                	li	s5,-1
 96e:	a081                	j	9ae <malloc+0x96>
 970:	f04a                	sd	s2,32(sp)
 972:	e852                	sd	s4,16(sp)
 974:	e456                	sd	s5,8(sp)
 976:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 978:	00000797          	auipc	a5,0x0
 97c:	69878793          	addi	a5,a5,1688 # 1010 <base>
 980:	00000717          	auipc	a4,0x0
 984:	68f73023          	sd	a5,1664(a4) # 1000 <freep>
 988:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98e:	b7c1                	j	94e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 990:	6398                	ld	a4,0(a5)
 992:	e118                	sd	a4,0(a0)
 994:	a8a9                	j	9ee <malloc+0xd6>
  hp->s.size = nu;
 996:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99a:	0541                	addi	a0,a0,16
 99c:	efbff0ef          	jal	896 <free>
  return freep;
 9a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a4:	c12d                	beqz	a0,a06 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a8:	4798                	lw	a4,8(a5)
 9aa:	02977263          	bgeu	a4,s1,9ce <malloc+0xb6>
    if(p == freep)
 9ae:	00093703          	ld	a4,0(s2)
 9b2:	853e                	mv	a0,a5
 9b4:	fef719e3          	bne	a4,a5,9a6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9b8:	8552                	mv	a0,s4
 9ba:	a33ff0ef          	jal	3ec <sbrk>
  if(p == SBRK_ERROR)
 9be:	fd551ce3          	bne	a0,s5,996 <malloc+0x7e>
        return 0;
 9c2:	4501                	li	a0,0
 9c4:	7902                	ld	s2,32(sp)
 9c6:	6a42                	ld	s4,16(sp)
 9c8:	6aa2                	ld	s5,8(sp)
 9ca:	6b02                	ld	s6,0(sp)
 9cc:	a03d                	j	9fa <malloc+0xe2>
 9ce:	7902                	ld	s2,32(sp)
 9d0:	6a42                	ld	s4,16(sp)
 9d2:	6aa2                	ld	s5,8(sp)
 9d4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9d6:	fae48de3          	beq	s1,a4,990 <malloc+0x78>
        p->s.size -= nunits;
 9da:	4137073b          	subw	a4,a4,s3
 9de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e0:	02071693          	slli	a3,a4,0x20
 9e4:	01c6d713          	srli	a4,a3,0x1c
 9e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ee:	00000717          	auipc	a4,0x0
 9f2:	60a73923          	sd	a0,1554(a4) # 1000 <freep>
      return (void*)(p + 1);
 9f6:	01078513          	addi	a0,a5,16
  }
}
 9fa:	70e2                	ld	ra,56(sp)
 9fc:	7442                	ld	s0,48(sp)
 9fe:	74a2                	ld	s1,40(sp)
 a00:	69e2                	ld	s3,24(sp)
 a02:	6121                	addi	sp,sp,64
 a04:	8082                	ret
 a06:	7902                	ld	s2,32(sp)
 a08:	6a42                	ld	s4,16(sp)
 a0a:	6aa2                	ld	s5,8(sp)
 a0c:	6b02                	ld	s6,0(sp)
 a0e:	b7f5                	j	9fa <malloc+0xe2>
