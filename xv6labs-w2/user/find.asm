
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <nameWithoutDir>:
#include "kernel/fs.h"    // file system structures
#include "kernel/fcntl.h" // file control options, O_RDONLY
#include "kernel/param.h" // system parameters, MAXARG (32)

char *nameWithoutDir(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    char *p;

    for (p = path + strlen(path); p >= path && *p != '/'; p--)
   c:	218000ef          	jal	224 <strlen>
  10:	1502                	slli	a0,a0,0x20
  12:	9101                	srli	a0,a0,0x20
  14:	9526                	add	a0,a0,s1
  16:	02f00713          	li	a4,47
  1a:	00956963          	bltu	a0,s1,2c <nameWithoutDir+0x2c>
  1e:	00054783          	lbu	a5,0(a0)
  22:	00e78563          	beq	a5,a4,2c <nameWithoutDir+0x2c>
  26:	157d                	addi	a0,a0,-1
  28:	fe957be3          	bgeu	a0,s1,1e <nameWithoutDir+0x1e>
        ;

    p++;
    return p;
}
  2c:	0505                	addi	a0,a0,1
  2e:	60e2                	ld	ra,24(sp)
  30:	6442                	ld	s0,16(sp)
  32:	64a2                	ld	s1,8(sp)
  34:	6105                	addi	sp,sp,32
  36:	8082                	ret

0000000000000038 <find>:

void find(char *path, char *target)
{
  38:	d9010113          	addi	sp,sp,-624
  3c:	26113423          	sd	ra,616(sp)
  40:	26813023          	sd	s0,608(sp)
  44:	25213823          	sd	s2,592(sp)
  48:	25313423          	sd	s3,584(sp)
  4c:	1c80                	addi	s0,sp,624
  4e:	892a                	mv	s2,a0
  50:	89ae                	mv	s3,a1
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(path, 0)) < 0)
  52:	4581                	li	a1,0
  54:	44c000ef          	jal	4a0 <open>
  58:	02054d63          	bltz	a0,92 <find+0x5a>
  5c:	24913c23          	sd	s1,600(sp)
  60:	84aa                	mv	s1,a0
    {
        printf("find: cannot open %s\n", path);
        return;
    }

    if (fstat(fd, &st) < 0)
  62:	d9840593          	addi	a1,s0,-616
  66:	452000ef          	jal	4b8 <fstat>
  6a:	04054663          	bltz	a0,b6 <find+0x7e>
        printf("find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    switch (st.type)
  6e:	da041783          	lh	a5,-608(s0)
  72:	4705                	li	a4,1
  74:	06e78863          	beq	a5,a4,e4 <find+0xac>
  78:	4709                	li	a4,2
  7a:	10e79263          	bne	a5,a4,17e <find+0x146>
    {
    case T_FILE: // if path is a file
        if (strcmp(nameWithoutDir(path), target) == 0)
  7e:	854a                	mv	a0,s2
  80:	f81ff0ef          	jal	0 <nameWithoutDir>
  84:	85ce                	mv	a1,s3
  86:	172000ef          	jal	1f8 <strcmp>
  8a:	c139                	beqz	a0,d0 <find+0x98>
  8c:	25813483          	ld	s1,600(sp)
  90:	a801                	j	a0 <find+0x68>
        printf("find: cannot open %s\n", path);
  92:	85ca                	mv	a1,s2
  94:	00001517          	auipc	a0,0x1
  98:	9bc50513          	addi	a0,a0,-1604 # a50 <malloc+0xf8>
  9c:	009000ef          	jal	8a4 <printf>
        }
        break;
    default:
        break;
    }
}
  a0:	26813083          	ld	ra,616(sp)
  a4:	26013403          	ld	s0,608(sp)
  a8:	25013903          	ld	s2,592(sp)
  ac:	24813983          	ld	s3,584(sp)
  b0:	27010113          	addi	sp,sp,624
  b4:	8082                	ret
        printf("find: cannot stat %s\n", path);
  b6:	85ca                	mv	a1,s2
  b8:	00001517          	auipc	a0,0x1
  bc:	9b850513          	addi	a0,a0,-1608 # a70 <malloc+0x118>
  c0:	7e4000ef          	jal	8a4 <printf>
        close(fd);
  c4:	8526                	mv	a0,s1
  c6:	3c2000ef          	jal	488 <close>
        return;
  ca:	25813483          	ld	s1,600(sp)
  ce:	bfc9                	j	a0 <find+0x68>
            printf("%s\n", path);
  d0:	85ca                	mv	a1,s2
  d2:	00001517          	auipc	a0,0x1
  d6:	9b650513          	addi	a0,a0,-1610 # a88 <malloc+0x130>
  da:	7ca000ef          	jal	8a4 <printf>
  de:	25813483          	ld	s1,600(sp)
  e2:	bf7d                	j	a0 <find+0x68>
  e4:	25413023          	sd	s4,576(sp)
  e8:	23513c23          	sd	s5,568(sp)
        strcpy(buf, path);
  ec:	85ca                	mv	a1,s2
  ee:	dc040513          	addi	a0,s0,-576
  f2:	0ea000ef          	jal	1dc <strcpy>
        p = buf + strlen(buf);
  f6:	dc040513          	addi	a0,s0,-576
  fa:	12a000ef          	jal	224 <strlen>
  fe:	1502                	slli	a0,a0,0x20
 100:	9101                	srli	a0,a0,0x20
 102:	dc040793          	addi	a5,s0,-576
 106:	00a78933          	add	s2,a5,a0
        *p++ = '/'; // Add the slash: "path/"
 10a:	00190a93          	addi	s5,s2,1
 10e:	02f00793          	li	a5,47
 112:	00f90023          	sb	a5,0(s2)
            if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 116:	00001a17          	auipc	s4,0x1
 11a:	97aa0a13          	addi	s4,s4,-1670 # a90 <malloc+0x138>
        while (read(fd, &de, sizeof(de)) == sizeof(de))
 11e:	4641                	li	a2,16
 120:	db040593          	addi	a1,s0,-592
 124:	8526                	mv	a0,s1
 126:	352000ef          	jal	478 <read>
 12a:	47c1                	li	a5,16
 12c:	04f51263          	bne	a0,a5,170 <find+0x138>
            if (de.inum == 0)
 130:	db045783          	lhu	a5,-592(s0)
 134:	d7ed                	beqz	a5,11e <find+0xe6>
            if (strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
 136:	85d2                	mv	a1,s4
 138:	db240513          	addi	a0,s0,-590
 13c:	0bc000ef          	jal	1f8 <strcmp>
 140:	dd79                	beqz	a0,11e <find+0xe6>
 142:	00001597          	auipc	a1,0x1
 146:	95658593          	addi	a1,a1,-1706 # a98 <malloc+0x140>
 14a:	db240513          	addi	a0,s0,-590
 14e:	0aa000ef          	jal	1f8 <strcmp>
 152:	d571                	beqz	a0,11e <find+0xe6>
            memmove(p, de.name, DIRSIZ);
 154:	4639                	li	a2,14
 156:	db240593          	addi	a1,s0,-590
 15a:	8556                	mv	a0,s5
 15c:	22a000ef          	jal	386 <memmove>
            p[DIRSIZ] = 0; // Null terminate manually just in case
 160:	000907a3          	sb	zero,15(s2)
            find(buf, target);
 164:	85ce                	mv	a1,s3
 166:	dc040513          	addi	a0,s0,-576
 16a:	ecfff0ef          	jal	38 <find>
 16e:	bf45                	j	11e <find+0xe6>
 170:	25813483          	ld	s1,600(sp)
 174:	24013a03          	ld	s4,576(sp)
 178:	23813a83          	ld	s5,568(sp)
 17c:	b715                	j	a0 <find+0x68>
 17e:	25813483          	ld	s1,600(sp)
 182:	bf39                	j	a0 <find+0x68>

0000000000000184 <main>:

int main(int argc, char *argv[])
{
 184:	1141                	addi	sp,sp,-16
 186:	e406                	sd	ra,8(sp)
 188:	e022                	sd	s0,0(sp)
 18a:	0800                	addi	s0,sp,16
    if (argc > 3)
 18c:	470d                	li	a4,3
 18e:	02a74063          	blt	a4,a0,1ae <main+0x2a>
 192:	87ae                	mv	a5,a1
    {
        printf("Usage: sixfive <dir name> <file name>\n");
        exit(1);
    }
    else if (argc == 3)
 194:	470d                	li	a4,3
 196:	02e50563          	beq	a0,a4,1c0 <main+0x3c>
    {
        find(argv[1], argv[2]);
    }
    else
    {
        find(".", argv[1]);
 19a:	658c                	ld	a1,8(a1)
 19c:	00001517          	auipc	a0,0x1
 1a0:	8f450513          	addi	a0,a0,-1804 # a90 <malloc+0x138>
 1a4:	e95ff0ef          	jal	38 <find>
    }
    exit(0);
 1a8:	4501                	li	a0,0
 1aa:	2b6000ef          	jal	460 <exit>
        printf("Usage: sixfive <dir name> <file name>\n");
 1ae:	00001517          	auipc	a0,0x1
 1b2:	8f250513          	addi	a0,a0,-1806 # aa0 <malloc+0x148>
 1b6:	6ee000ef          	jal	8a4 <printf>
        exit(1);
 1ba:	4505                	li	a0,1
 1bc:	2a4000ef          	jal	460 <exit>
        find(argv[1], argv[2]);
 1c0:	698c                	ld	a1,16(a1)
 1c2:	6788                	ld	a0,8(a5)
 1c4:	e75ff0ef          	jal	38 <find>
 1c8:	b7c5                	j	1a8 <main+0x24>

00000000000001ca <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e406                	sd	ra,8(sp)
 1ce:	e022                	sd	s0,0(sp)
 1d0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1d2:	fb3ff0ef          	jal	184 <main>
  exit(0);
 1d6:	4501                	li	a0,0
 1d8:	288000ef          	jal	460 <exit>

00000000000001dc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1dc:	1141                	addi	sp,sp,-16
 1de:	e422                	sd	s0,8(sp)
 1e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e2:	87aa                	mv	a5,a0
 1e4:	0585                	addi	a1,a1,1
 1e6:	0785                	addi	a5,a5,1
 1e8:	fff5c703          	lbu	a4,-1(a1)
 1ec:	fee78fa3          	sb	a4,-1(a5)
 1f0:	fb75                	bnez	a4,1e4 <strcpy+0x8>
    ;
  return os;
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret

00000000000001f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1fe:	00054783          	lbu	a5,0(a0)
 202:	cb91                	beqz	a5,216 <strcmp+0x1e>
 204:	0005c703          	lbu	a4,0(a1)
 208:	00f71763          	bne	a4,a5,216 <strcmp+0x1e>
    p++, q++;
 20c:	0505                	addi	a0,a0,1
 20e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 210:	00054783          	lbu	a5,0(a0)
 214:	fbe5                	bnez	a5,204 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 216:	0005c503          	lbu	a0,0(a1)
}
 21a:	40a7853b          	subw	a0,a5,a0
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret

0000000000000224 <strlen>:

uint
strlen(const char *s)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 22a:	00054783          	lbu	a5,0(a0)
 22e:	cf91                	beqz	a5,24a <strlen+0x26>
 230:	0505                	addi	a0,a0,1
 232:	87aa                	mv	a5,a0
 234:	86be                	mv	a3,a5
 236:	0785                	addi	a5,a5,1
 238:	fff7c703          	lbu	a4,-1(a5)
 23c:	ff65                	bnez	a4,234 <strlen+0x10>
 23e:	40a6853b          	subw	a0,a3,a0
 242:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
  for(n = 0; s[n]; n++)
 24a:	4501                	li	a0,0
 24c:	bfe5                	j	244 <strlen+0x20>

000000000000024e <memset>:

void*
memset(void *dst, int c, uint n)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 254:	ca19                	beqz	a2,26a <memset+0x1c>
 256:	87aa                	mv	a5,a0
 258:	1602                	slli	a2,a2,0x20
 25a:	9201                	srli	a2,a2,0x20
 25c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 260:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 264:	0785                	addi	a5,a5,1
 266:	fee79de3          	bne	a5,a4,260 <memset+0x12>
  }
  return dst;
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret

0000000000000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	1141                	addi	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	addi	s0,sp,16
  for(; *s; s++)
 276:	00054783          	lbu	a5,0(a0)
 27a:	cb99                	beqz	a5,290 <strchr+0x20>
    if(*s == c)
 27c:	00f58763          	beq	a1,a5,28a <strchr+0x1a>
  for(; *s; s++)
 280:	0505                	addi	a0,a0,1
 282:	00054783          	lbu	a5,0(a0)
 286:	fbfd                	bnez	a5,27c <strchr+0xc>
      return (char*)s;
  return 0;
 288:	4501                	li	a0,0
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  return 0;
 290:	4501                	li	a0,0
 292:	bfe5                	j	28a <strchr+0x1a>

0000000000000294 <gets>:

char*
gets(char *buf, int max)
{
 294:	711d                	addi	sp,sp,-96
 296:	ec86                	sd	ra,88(sp)
 298:	e8a2                	sd	s0,80(sp)
 29a:	e4a6                	sd	s1,72(sp)
 29c:	e0ca                	sd	s2,64(sp)
 29e:	fc4e                	sd	s3,56(sp)
 2a0:	f852                	sd	s4,48(sp)
 2a2:	f456                	sd	s5,40(sp)
 2a4:	f05a                	sd	s6,32(sp)
 2a6:	ec5e                	sd	s7,24(sp)
 2a8:	1080                	addi	s0,sp,96
 2aa:	8baa                	mv	s7,a0
 2ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ae:	892a                	mv	s2,a0
 2b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2b2:	4aa9                	li	s5,10
 2b4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2b6:	89a6                	mv	s3,s1
 2b8:	2485                	addiw	s1,s1,1
 2ba:	0344d663          	bge	s1,s4,2e6 <gets+0x52>
    cc = read(0, &c, 1);
 2be:	4605                	li	a2,1
 2c0:	faf40593          	addi	a1,s0,-81
 2c4:	4501                	li	a0,0
 2c6:	1b2000ef          	jal	478 <read>
    if(cc < 1)
 2ca:	00a05e63          	blez	a0,2e6 <gets+0x52>
    buf[i++] = c;
 2ce:	faf44783          	lbu	a5,-81(s0)
 2d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2d6:	01578763          	beq	a5,s5,2e4 <gets+0x50>
 2da:	0905                	addi	s2,s2,1
 2dc:	fd679de3          	bne	a5,s6,2b6 <gets+0x22>
    buf[i++] = c;
 2e0:	89a6                	mv	s3,s1
 2e2:	a011                	j	2e6 <gets+0x52>
 2e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2e6:	99de                	add	s3,s3,s7
 2e8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ec:	855e                	mv	a0,s7
 2ee:	60e6                	ld	ra,88(sp)
 2f0:	6446                	ld	s0,80(sp)
 2f2:	64a6                	ld	s1,72(sp)
 2f4:	6906                	ld	s2,64(sp)
 2f6:	79e2                	ld	s3,56(sp)
 2f8:	7a42                	ld	s4,48(sp)
 2fa:	7aa2                	ld	s5,40(sp)
 2fc:	7b02                	ld	s6,32(sp)
 2fe:	6be2                	ld	s7,24(sp)
 300:	6125                	addi	sp,sp,96
 302:	8082                	ret

0000000000000304 <stat>:

int
stat(const char *n, struct stat *st)
{
 304:	1101                	addi	sp,sp,-32
 306:	ec06                	sd	ra,24(sp)
 308:	e822                	sd	s0,16(sp)
 30a:	e04a                	sd	s2,0(sp)
 30c:	1000                	addi	s0,sp,32
 30e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 310:	4581                	li	a1,0
 312:	18e000ef          	jal	4a0 <open>
  if(fd < 0)
 316:	02054263          	bltz	a0,33a <stat+0x36>
 31a:	e426                	sd	s1,8(sp)
 31c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 31e:	85ca                	mv	a1,s2
 320:	198000ef          	jal	4b8 <fstat>
 324:	892a                	mv	s2,a0
  close(fd);
 326:	8526                	mv	a0,s1
 328:	160000ef          	jal	488 <close>
  return r;
 32c:	64a2                	ld	s1,8(sp)
}
 32e:	854a                	mv	a0,s2
 330:	60e2                	ld	ra,24(sp)
 332:	6442                	ld	s0,16(sp)
 334:	6902                	ld	s2,0(sp)
 336:	6105                	addi	sp,sp,32
 338:	8082                	ret
    return -1;
 33a:	597d                	li	s2,-1
 33c:	bfcd                	j	32e <stat+0x2a>

000000000000033e <atoi>:

int
atoi(const char *s)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 344:	00054683          	lbu	a3,0(a0)
 348:	fd06879b          	addiw	a5,a3,-48
 34c:	0ff7f793          	zext.b	a5,a5
 350:	4625                	li	a2,9
 352:	02f66863          	bltu	a2,a5,382 <atoi+0x44>
 356:	872a                	mv	a4,a0
  n = 0;
 358:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 35a:	0705                	addi	a4,a4,1
 35c:	0025179b          	slliw	a5,a0,0x2
 360:	9fa9                	addw	a5,a5,a0
 362:	0017979b          	slliw	a5,a5,0x1
 366:	9fb5                	addw	a5,a5,a3
 368:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 36c:	00074683          	lbu	a3,0(a4)
 370:	fd06879b          	addiw	a5,a3,-48
 374:	0ff7f793          	zext.b	a5,a5
 378:	fef671e3          	bgeu	a2,a5,35a <atoi+0x1c>
  return n;
}
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret
  n = 0;
 382:	4501                	li	a0,0
 384:	bfe5                	j	37c <atoi+0x3e>

0000000000000386 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 386:	1141                	addi	sp,sp,-16
 388:	e422                	sd	s0,8(sp)
 38a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 38c:	02b57463          	bgeu	a0,a1,3b4 <memmove+0x2e>
    while(n-- > 0)
 390:	00c05f63          	blez	a2,3ae <memmove+0x28>
 394:	1602                	slli	a2,a2,0x20
 396:	9201                	srli	a2,a2,0x20
 398:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 39c:	872a                	mv	a4,a0
      *dst++ = *src++;
 39e:	0585                	addi	a1,a1,1
 3a0:	0705                	addi	a4,a4,1
 3a2:	fff5c683          	lbu	a3,-1(a1)
 3a6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3aa:	fef71ae3          	bne	a4,a5,39e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
    dst += n;
 3b4:	00c50733          	add	a4,a0,a2
    src += n;
 3b8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ba:	fec05ae3          	blez	a2,3ae <memmove+0x28>
 3be:	fff6079b          	addiw	a5,a2,-1
 3c2:	1782                	slli	a5,a5,0x20
 3c4:	9381                	srli	a5,a5,0x20
 3c6:	fff7c793          	not	a5,a5
 3ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3cc:	15fd                	addi	a1,a1,-1
 3ce:	177d                	addi	a4,a4,-1
 3d0:	0005c683          	lbu	a3,0(a1)
 3d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d8:	fee79ae3          	bne	a5,a4,3cc <memmove+0x46>
 3dc:	bfc9                	j	3ae <memmove+0x28>

00000000000003de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e422                	sd	s0,8(sp)
 3e2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e4:	ca05                	beqz	a2,414 <memcmp+0x36>
 3e6:	fff6069b          	addiw	a3,a2,-1
 3ea:	1682                	slli	a3,a3,0x20
 3ec:	9281                	srli	a3,a3,0x20
 3ee:	0685                	addi	a3,a3,1
 3f0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3f2:	00054783          	lbu	a5,0(a0)
 3f6:	0005c703          	lbu	a4,0(a1)
 3fa:	00e79863          	bne	a5,a4,40a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3fe:	0505                	addi	a0,a0,1
    p2++;
 400:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 402:	fed518e3          	bne	a0,a3,3f2 <memcmp+0x14>
  }
  return 0;
 406:	4501                	li	a0,0
 408:	a019                	j	40e <memcmp+0x30>
      return *p1 - *p2;
 40a:	40e7853b          	subw	a0,a5,a4
}
 40e:	6422                	ld	s0,8(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret
  return 0;
 414:	4501                	li	a0,0
 416:	bfe5                	j	40e <memcmp+0x30>

0000000000000418 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e406                	sd	ra,8(sp)
 41c:	e022                	sd	s0,0(sp)
 41e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 420:	f67ff0ef          	jal	386 <memmove>
}
 424:	60a2                	ld	ra,8(sp)
 426:	6402                	ld	s0,0(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret

000000000000042c <sbrk>:

char *
sbrk(int n) {
 42c:	1141                	addi	sp,sp,-16
 42e:	e406                	sd	ra,8(sp)
 430:	e022                	sd	s0,0(sp)
 432:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 434:	4585                	li	a1,1
 436:	0b2000ef          	jal	4e8 <sys_sbrk>
}
 43a:	60a2                	ld	ra,8(sp)
 43c:	6402                	ld	s0,0(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret

0000000000000442 <sbrklazy>:

char *
sbrklazy(int n) {
 442:	1141                	addi	sp,sp,-16
 444:	e406                	sd	ra,8(sp)
 446:	e022                	sd	s0,0(sp)
 448:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 44a:	4589                	li	a1,2
 44c:	09c000ef          	jal	4e8 <sys_sbrk>
}
 450:	60a2                	ld	ra,8(sp)
 452:	6402                	ld	s0,0(sp)
 454:	0141                	addi	sp,sp,16
 456:	8082                	ret

0000000000000458 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 458:	4885                	li	a7,1
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <exit>:
.global exit
exit:
 li a7, SYS_exit
 460:	4889                	li	a7,2
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <wait>:
.global wait
wait:
 li a7, SYS_wait
 468:	488d                	li	a7,3
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 470:	4891                	li	a7,4
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <read>:
.global read
read:
 li a7, SYS_read
 478:	4895                	li	a7,5
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <write>:
.global write
write:
 li a7, SYS_write
 480:	48c1                	li	a7,16
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <close>:
.global close
close:
 li a7, SYS_close
 488:	48d5                	li	a7,21
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <kill>:
.global kill
kill:
 li a7, SYS_kill
 490:	4899                	li	a7,6
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <exec>:
.global exec
exec:
 li a7, SYS_exec
 498:	489d                	li	a7,7
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <open>:
.global open
open:
 li a7, SYS_open
 4a0:	48bd                	li	a7,15
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a8:	48c5                	li	a7,17
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4b0:	48c9                	li	a7,18
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4b8:	48a1                	li	a7,8
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <link>:
.global link
link:
 li a7, SYS_link
 4c0:	48cd                	li	a7,19
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c8:	48d1                	li	a7,20
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d0:	48a5                	li	a7,9
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d8:	48a9                	li	a7,10
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e0:	48ad                	li	a7,11
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4e8:	48b1                	li	a7,12
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4f0:	48b5                	li	a7,13
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4f8:	48b9                	li	a7,14
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <hello>:
.global hello
hello:
 li a7, SYS_hello
 500:	48dd                	li	a7,23
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
 508:	48d9                	li	a7,22
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 510:	1101                	addi	sp,sp,-32
 512:	ec06                	sd	ra,24(sp)
 514:	e822                	sd	s0,16(sp)
 516:	1000                	addi	s0,sp,32
 518:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 51c:	4605                	li	a2,1
 51e:	fef40593          	addi	a1,s0,-17
 522:	f5fff0ef          	jal	480 <write>
}
 526:	60e2                	ld	ra,24(sp)
 528:	6442                	ld	s0,16(sp)
 52a:	6105                	addi	sp,sp,32
 52c:	8082                	ret

000000000000052e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 52e:	715d                	addi	sp,sp,-80
 530:	e486                	sd	ra,72(sp)
 532:	e0a2                	sd	s0,64(sp)
 534:	fc26                	sd	s1,56(sp)
 536:	0880                	addi	s0,sp,80
 538:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53a:	c299                	beqz	a3,540 <printint+0x12>
 53c:	0805c963          	bltz	a1,5ce <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 540:	2581                	sext.w	a1,a1
  neg = 0;
 542:	4881                	li	a7,0
 544:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 548:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 54a:	2601                	sext.w	a2,a2
 54c:	00000517          	auipc	a0,0x0
 550:	58450513          	addi	a0,a0,1412 # ad0 <digits>
 554:	883a                	mv	a6,a4
 556:	2705                	addiw	a4,a4,1
 558:	02c5f7bb          	remuw	a5,a1,a2
 55c:	1782                	slli	a5,a5,0x20
 55e:	9381                	srli	a5,a5,0x20
 560:	97aa                	add	a5,a5,a0
 562:	0007c783          	lbu	a5,0(a5)
 566:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 56a:	0005879b          	sext.w	a5,a1
 56e:	02c5d5bb          	divuw	a1,a1,a2
 572:	0685                	addi	a3,a3,1
 574:	fec7f0e3          	bgeu	a5,a2,554 <printint+0x26>
  if(neg)
 578:	00088c63          	beqz	a7,590 <printint+0x62>
    buf[i++] = '-';
 57c:	fd070793          	addi	a5,a4,-48
 580:	00878733          	add	a4,a5,s0
 584:	02d00793          	li	a5,45
 588:	fef70423          	sb	a5,-24(a4)
 58c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 590:	02e05a63          	blez	a4,5c4 <printint+0x96>
 594:	f84a                	sd	s2,48(sp)
 596:	f44e                	sd	s3,40(sp)
 598:	fb840793          	addi	a5,s0,-72
 59c:	00e78933          	add	s2,a5,a4
 5a0:	fff78993          	addi	s3,a5,-1
 5a4:	99ba                	add	s3,s3,a4
 5a6:	377d                	addiw	a4,a4,-1
 5a8:	1702                	slli	a4,a4,0x20
 5aa:	9301                	srli	a4,a4,0x20
 5ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5b0:	fff94583          	lbu	a1,-1(s2)
 5b4:	8526                	mv	a0,s1
 5b6:	f5bff0ef          	jal	510 <putc>
  while(--i >= 0)
 5ba:	197d                	addi	s2,s2,-1
 5bc:	ff391ae3          	bne	s2,s3,5b0 <printint+0x82>
 5c0:	7942                	ld	s2,48(sp)
 5c2:	79a2                	ld	s3,40(sp)
}
 5c4:	60a6                	ld	ra,72(sp)
 5c6:	6406                	ld	s0,64(sp)
 5c8:	74e2                	ld	s1,56(sp)
 5ca:	6161                	addi	sp,sp,80
 5cc:	8082                	ret
    x = -xx;
 5ce:	40b005bb          	negw	a1,a1
    neg = 1;
 5d2:	4885                	li	a7,1
    x = -xx;
 5d4:	bf85                	j	544 <printint+0x16>

00000000000005d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d6:	711d                	addi	sp,sp,-96
 5d8:	ec86                	sd	ra,88(sp)
 5da:	e8a2                	sd	s0,80(sp)
 5dc:	e0ca                	sd	s2,64(sp)
 5de:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e0:	0005c903          	lbu	s2,0(a1)
 5e4:	28090663          	beqz	s2,870 <vprintf+0x29a>
 5e8:	e4a6                	sd	s1,72(sp)
 5ea:	fc4e                	sd	s3,56(sp)
 5ec:	f852                	sd	s4,48(sp)
 5ee:	f456                	sd	s5,40(sp)
 5f0:	f05a                	sd	s6,32(sp)
 5f2:	ec5e                	sd	s7,24(sp)
 5f4:	e862                	sd	s8,16(sp)
 5f6:	e466                	sd	s9,8(sp)
 5f8:	8b2a                	mv	s6,a0
 5fa:	8a2e                	mv	s4,a1
 5fc:	8bb2                	mv	s7,a2
  state = 0;
 5fe:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 600:	4481                	li	s1,0
 602:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 604:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 608:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 60c:	06c00c93          	li	s9,108
 610:	a005                	j	630 <vprintf+0x5a>
        putc(fd, c0);
 612:	85ca                	mv	a1,s2
 614:	855a                	mv	a0,s6
 616:	efbff0ef          	jal	510 <putc>
 61a:	a019                	j	620 <vprintf+0x4a>
    } else if(state == '%'){
 61c:	03598263          	beq	s3,s5,640 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 620:	2485                	addiw	s1,s1,1
 622:	8726                	mv	a4,s1
 624:	009a07b3          	add	a5,s4,s1
 628:	0007c903          	lbu	s2,0(a5)
 62c:	22090a63          	beqz	s2,860 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 630:	0009079b          	sext.w	a5,s2
    if(state == 0){
 634:	fe0994e3          	bnez	s3,61c <vprintf+0x46>
      if(c0 == '%'){
 638:	fd579de3          	bne	a5,s5,612 <vprintf+0x3c>
        state = '%';
 63c:	89be                	mv	s3,a5
 63e:	b7cd                	j	620 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 640:	00ea06b3          	add	a3,s4,a4
 644:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 648:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 64a:	c681                	beqz	a3,652 <vprintf+0x7c>
 64c:	9752                	add	a4,a4,s4
 64e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 652:	05878363          	beq	a5,s8,698 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 656:	05978d63          	beq	a5,s9,6b0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 65a:	07500713          	li	a4,117
 65e:	0ee78763          	beq	a5,a4,74c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 662:	07800713          	li	a4,120
 666:	12e78963          	beq	a5,a4,798 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 66a:	07000713          	li	a4,112
 66e:	14e78e63          	beq	a5,a4,7ca <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 672:	06300713          	li	a4,99
 676:	18e78e63          	beq	a5,a4,812 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 67a:	07300713          	li	a4,115
 67e:	1ae78463          	beq	a5,a4,826 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 682:	02500713          	li	a4,37
 686:	04e79563          	bne	a5,a4,6d0 <vprintf+0xfa>
        putc(fd, '%');
 68a:	02500593          	li	a1,37
 68e:	855a                	mv	a0,s6
 690:	e81ff0ef          	jal	510 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 694:	4981                	li	s3,0
 696:	b769                	j	620 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 698:	008b8913          	addi	s2,s7,8
 69c:	4685                	li	a3,1
 69e:	4629                	li	a2,10
 6a0:	000ba583          	lw	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	e89ff0ef          	jal	52e <printint>
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bf8d                	j	620 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6b0:	06400793          	li	a5,100
 6b4:	02f68963          	beq	a3,a5,6e6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b8:	06c00793          	li	a5,108
 6bc:	04f68263          	beq	a3,a5,700 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6c0:	07500793          	li	a5,117
 6c4:	0af68063          	beq	a3,a5,764 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6c8:	07800793          	li	a5,120
 6cc:	0ef68263          	beq	a3,a5,7b0 <vprintf+0x1da>
        putc(fd, '%');
 6d0:	02500593          	li	a1,37
 6d4:	855a                	mv	a0,s6
 6d6:	e3bff0ef          	jal	510 <putc>
        putc(fd, c0);
 6da:	85ca                	mv	a1,s2
 6dc:	855a                	mv	a0,s6
 6de:	e33ff0ef          	jal	510 <putc>
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bf35                	j	620 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e6:	008b8913          	addi	s2,s7,8
 6ea:	4685                	li	a3,1
 6ec:	4629                	li	a2,10
 6ee:	000bb583          	ld	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	e3bff0ef          	jal	52e <printint>
        i += 1;
 6f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
        i += 1;
 6fe:	b70d                	j	620 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 700:	06400793          	li	a5,100
 704:	02f60763          	beq	a2,a5,732 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 708:	07500793          	li	a5,117
 70c:	06f60963          	beq	a2,a5,77e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 710:	07800793          	li	a5,120
 714:	faf61ee3          	bne	a2,a5,6d0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 718:	008b8913          	addi	s2,s7,8
 71c:	4681                	li	a3,0
 71e:	4641                	li	a2,16
 720:	000bb583          	ld	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	e09ff0ef          	jal	52e <printint>
        i += 2;
 72a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
        i += 2;
 730:	bdc5                	j	620 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 732:	008b8913          	addi	s2,s7,8
 736:	4685                	li	a3,1
 738:	4629                	li	a2,10
 73a:	000bb583          	ld	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	defff0ef          	jal	52e <printint>
        i += 2;
 744:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 746:	8bca                	mv	s7,s2
      state = 0;
 748:	4981                	li	s3,0
        i += 2;
 74a:	bdd9                	j	620 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 74c:	008b8913          	addi	s2,s7,8
 750:	4681                	li	a3,0
 752:	4629                	li	a2,10
 754:	000be583          	lwu	a1,0(s7)
 758:	855a                	mv	a0,s6
 75a:	dd5ff0ef          	jal	52e <printint>
 75e:	8bca                	mv	s7,s2
      state = 0;
 760:	4981                	li	s3,0
 762:	bd7d                	j	620 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 764:	008b8913          	addi	s2,s7,8
 768:	4681                	li	a3,0
 76a:	4629                	li	a2,10
 76c:	000bb583          	ld	a1,0(s7)
 770:	855a                	mv	a0,s6
 772:	dbdff0ef          	jal	52e <printint>
        i += 1;
 776:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 778:	8bca                	mv	s7,s2
      state = 0;
 77a:	4981                	li	s3,0
        i += 1;
 77c:	b555                	j	620 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 77e:	008b8913          	addi	s2,s7,8
 782:	4681                	li	a3,0
 784:	4629                	li	a2,10
 786:	000bb583          	ld	a1,0(s7)
 78a:	855a                	mv	a0,s6
 78c:	da3ff0ef          	jal	52e <printint>
        i += 2;
 790:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 792:	8bca                	mv	s7,s2
      state = 0;
 794:	4981                	li	s3,0
        i += 2;
 796:	b569                	j	620 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 798:	008b8913          	addi	s2,s7,8
 79c:	4681                	li	a3,0
 79e:	4641                	li	a2,16
 7a0:	000be583          	lwu	a1,0(s7)
 7a4:	855a                	mv	a0,s6
 7a6:	d89ff0ef          	jal	52e <printint>
 7aa:	8bca                	mv	s7,s2
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bd8d                	j	620 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b0:	008b8913          	addi	s2,s7,8
 7b4:	4681                	li	a3,0
 7b6:	4641                	li	a2,16
 7b8:	000bb583          	ld	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	d71ff0ef          	jal	52e <printint>
        i += 1;
 7c2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c4:	8bca                	mv	s7,s2
      state = 0;
 7c6:	4981                	li	s3,0
        i += 1;
 7c8:	bda1                	j	620 <vprintf+0x4a>
 7ca:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7cc:	008b8d13          	addi	s10,s7,8
 7d0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7d4:	03000593          	li	a1,48
 7d8:	855a                	mv	a0,s6
 7da:	d37ff0ef          	jal	510 <putc>
  putc(fd, 'x');
 7de:	07800593          	li	a1,120
 7e2:	855a                	mv	a0,s6
 7e4:	d2dff0ef          	jal	510 <putc>
 7e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ea:	00000b97          	auipc	s7,0x0
 7ee:	2e6b8b93          	addi	s7,s7,742 # ad0 <digits>
 7f2:	03c9d793          	srli	a5,s3,0x3c
 7f6:	97de                	add	a5,a5,s7
 7f8:	0007c583          	lbu	a1,0(a5)
 7fc:	855a                	mv	a0,s6
 7fe:	d13ff0ef          	jal	510 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 802:	0992                	slli	s3,s3,0x4
 804:	397d                	addiw	s2,s2,-1
 806:	fe0916e3          	bnez	s2,7f2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 80a:	8bea                	mv	s7,s10
      state = 0;
 80c:	4981                	li	s3,0
 80e:	6d02                	ld	s10,0(sp)
 810:	bd01                	j	620 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 812:	008b8913          	addi	s2,s7,8
 816:	000bc583          	lbu	a1,0(s7)
 81a:	855a                	mv	a0,s6
 81c:	cf5ff0ef          	jal	510 <putc>
 820:	8bca                	mv	s7,s2
      state = 0;
 822:	4981                	li	s3,0
 824:	bbf5                	j	620 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 826:	008b8993          	addi	s3,s7,8
 82a:	000bb903          	ld	s2,0(s7)
 82e:	00090f63          	beqz	s2,84c <vprintf+0x276>
        for(; *s; s++)
 832:	00094583          	lbu	a1,0(s2)
 836:	c195                	beqz	a1,85a <vprintf+0x284>
          putc(fd, *s);
 838:	855a                	mv	a0,s6
 83a:	cd7ff0ef          	jal	510 <putc>
        for(; *s; s++)
 83e:	0905                	addi	s2,s2,1
 840:	00094583          	lbu	a1,0(s2)
 844:	f9f5                	bnez	a1,838 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 846:	8bce                	mv	s7,s3
      state = 0;
 848:	4981                	li	s3,0
 84a:	bbd9                	j	620 <vprintf+0x4a>
          s = "(null)";
 84c:	00000917          	auipc	s2,0x0
 850:	27c90913          	addi	s2,s2,636 # ac8 <malloc+0x170>
        for(; *s; s++)
 854:	02800593          	li	a1,40
 858:	b7c5                	j	838 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 85a:	8bce                	mv	s7,s3
      state = 0;
 85c:	4981                	li	s3,0
 85e:	b3c9                	j	620 <vprintf+0x4a>
 860:	64a6                	ld	s1,72(sp)
 862:	79e2                	ld	s3,56(sp)
 864:	7a42                	ld	s4,48(sp)
 866:	7aa2                	ld	s5,40(sp)
 868:	7b02                	ld	s6,32(sp)
 86a:	6be2                	ld	s7,24(sp)
 86c:	6c42                	ld	s8,16(sp)
 86e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 870:	60e6                	ld	ra,88(sp)
 872:	6446                	ld	s0,80(sp)
 874:	6906                	ld	s2,64(sp)
 876:	6125                	addi	sp,sp,96
 878:	8082                	ret

000000000000087a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 87a:	715d                	addi	sp,sp,-80
 87c:	ec06                	sd	ra,24(sp)
 87e:	e822                	sd	s0,16(sp)
 880:	1000                	addi	s0,sp,32
 882:	e010                	sd	a2,0(s0)
 884:	e414                	sd	a3,8(s0)
 886:	e818                	sd	a4,16(s0)
 888:	ec1c                	sd	a5,24(s0)
 88a:	03043023          	sd	a6,32(s0)
 88e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 892:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 896:	8622                	mv	a2,s0
 898:	d3fff0ef          	jal	5d6 <vprintf>
}
 89c:	60e2                	ld	ra,24(sp)
 89e:	6442                	ld	s0,16(sp)
 8a0:	6161                	addi	sp,sp,80
 8a2:	8082                	ret

00000000000008a4 <printf>:

void
printf(const char *fmt, ...)
{
 8a4:	711d                	addi	sp,sp,-96
 8a6:	ec06                	sd	ra,24(sp)
 8a8:	e822                	sd	s0,16(sp)
 8aa:	1000                	addi	s0,sp,32
 8ac:	e40c                	sd	a1,8(s0)
 8ae:	e810                	sd	a2,16(s0)
 8b0:	ec14                	sd	a3,24(s0)
 8b2:	f018                	sd	a4,32(s0)
 8b4:	f41c                	sd	a5,40(s0)
 8b6:	03043823          	sd	a6,48(s0)
 8ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8be:	00840613          	addi	a2,s0,8
 8c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c6:	85aa                	mv	a1,a0
 8c8:	4505                	li	a0,1
 8ca:	d0dff0ef          	jal	5d6 <vprintf>
}
 8ce:	60e2                	ld	ra,24(sp)
 8d0:	6442                	ld	s0,16(sp)
 8d2:	6125                	addi	sp,sp,96
 8d4:	8082                	ret

00000000000008d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d6:	1141                	addi	sp,sp,-16
 8d8:	e422                	sd	s0,8(sp)
 8da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e0:	00000797          	auipc	a5,0x0
 8e4:	7207b783          	ld	a5,1824(a5) # 1000 <freep>
 8e8:	a02d                	j	912 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8ea:	4618                	lw	a4,8(a2)
 8ec:	9f2d                	addw	a4,a4,a1
 8ee:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f2:	6398                	ld	a4,0(a5)
 8f4:	6310                	ld	a2,0(a4)
 8f6:	a83d                	j	934 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8f8:	ff852703          	lw	a4,-8(a0)
 8fc:	9f31                	addw	a4,a4,a2
 8fe:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 900:	ff053683          	ld	a3,-16(a0)
 904:	a091                	j	948 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 906:	6398                	ld	a4,0(a5)
 908:	00e7e463          	bltu	a5,a4,910 <free+0x3a>
 90c:	00e6ea63          	bltu	a3,a4,920 <free+0x4a>
{
 910:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 912:	fed7fae3          	bgeu	a5,a3,906 <free+0x30>
 916:	6398                	ld	a4,0(a5)
 918:	00e6e463          	bltu	a3,a4,920 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 91c:	fee7eae3          	bltu	a5,a4,910 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 920:	ff852583          	lw	a1,-8(a0)
 924:	6390                	ld	a2,0(a5)
 926:	02059813          	slli	a6,a1,0x20
 92a:	01c85713          	srli	a4,a6,0x1c
 92e:	9736                	add	a4,a4,a3
 930:	fae60de3          	beq	a2,a4,8ea <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 934:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 938:	4790                	lw	a2,8(a5)
 93a:	02061593          	slli	a1,a2,0x20
 93e:	01c5d713          	srli	a4,a1,0x1c
 942:	973e                	add	a4,a4,a5
 944:	fae68ae3          	beq	a3,a4,8f8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 948:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 94a:	00000717          	auipc	a4,0x0
 94e:	6af73b23          	sd	a5,1718(a4) # 1000 <freep>
}
 952:	6422                	ld	s0,8(sp)
 954:	0141                	addi	sp,sp,16
 956:	8082                	ret

0000000000000958 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 958:	7139                	addi	sp,sp,-64
 95a:	fc06                	sd	ra,56(sp)
 95c:	f822                	sd	s0,48(sp)
 95e:	f426                	sd	s1,40(sp)
 960:	ec4e                	sd	s3,24(sp)
 962:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 964:	02051493          	slli	s1,a0,0x20
 968:	9081                	srli	s1,s1,0x20
 96a:	04bd                	addi	s1,s1,15
 96c:	8091                	srli	s1,s1,0x4
 96e:	0014899b          	addiw	s3,s1,1
 972:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 974:	00000517          	auipc	a0,0x0
 978:	68c53503          	ld	a0,1676(a0) # 1000 <freep>
 97c:	c915                	beqz	a0,9b0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 980:	4798                	lw	a4,8(a5)
 982:	08977a63          	bgeu	a4,s1,a16 <malloc+0xbe>
 986:	f04a                	sd	s2,32(sp)
 988:	e852                	sd	s4,16(sp)
 98a:	e456                	sd	s5,8(sp)
 98c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 98e:	8a4e                	mv	s4,s3
 990:	0009871b          	sext.w	a4,s3
 994:	6685                	lui	a3,0x1
 996:	00d77363          	bgeu	a4,a3,99c <malloc+0x44>
 99a:	6a05                	lui	s4,0x1
 99c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a4:	00000917          	auipc	s2,0x0
 9a8:	65c90913          	addi	s2,s2,1628 # 1000 <freep>
  if(p == SBRK_ERROR)
 9ac:	5afd                	li	s5,-1
 9ae:	a081                	j	9ee <malloc+0x96>
 9b0:	f04a                	sd	s2,32(sp)
 9b2:	e852                	sd	s4,16(sp)
 9b4:	e456                	sd	s5,8(sp)
 9b6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9b8:	00000797          	auipc	a5,0x0
 9bc:	65878793          	addi	a5,a5,1624 # 1010 <base>
 9c0:	00000717          	auipc	a4,0x0
 9c4:	64f73023          	sd	a5,1600(a4) # 1000 <freep>
 9c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ce:	b7c1                	j	98e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9d0:	6398                	ld	a4,0(a5)
 9d2:	e118                	sd	a4,0(a0)
 9d4:	a8a9                	j	a2e <malloc+0xd6>
  hp->s.size = nu;
 9d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9da:	0541                	addi	a0,a0,16
 9dc:	efbff0ef          	jal	8d6 <free>
  return freep;
 9e0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9e4:	c12d                	beqz	a0,a46 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e8:	4798                	lw	a4,8(a5)
 9ea:	02977263          	bgeu	a4,s1,a0e <malloc+0xb6>
    if(p == freep)
 9ee:	00093703          	ld	a4,0(s2)
 9f2:	853e                	mv	a0,a5
 9f4:	fef719e3          	bne	a4,a5,9e6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9f8:	8552                	mv	a0,s4
 9fa:	a33ff0ef          	jal	42c <sbrk>
  if(p == SBRK_ERROR)
 9fe:	fd551ce3          	bne	a0,s5,9d6 <malloc+0x7e>
        return 0;
 a02:	4501                	li	a0,0
 a04:	7902                	ld	s2,32(sp)
 a06:	6a42                	ld	s4,16(sp)
 a08:	6aa2                	ld	s5,8(sp)
 a0a:	6b02                	ld	s6,0(sp)
 a0c:	a03d                	j	a3a <malloc+0xe2>
 a0e:	7902                	ld	s2,32(sp)
 a10:	6a42                	ld	s4,16(sp)
 a12:	6aa2                	ld	s5,8(sp)
 a14:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a16:	fae48de3          	beq	s1,a4,9d0 <malloc+0x78>
        p->s.size -= nunits;
 a1a:	4137073b          	subw	a4,a4,s3
 a1e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a20:	02071693          	slli	a3,a4,0x20
 a24:	01c6d713          	srli	a4,a3,0x1c
 a28:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a2a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a2e:	00000717          	auipc	a4,0x0
 a32:	5ca73923          	sd	a0,1490(a4) # 1000 <freep>
      return (void*)(p + 1);
 a36:	01078513          	addi	a0,a5,16
  }
}
 a3a:	70e2                	ld	ra,56(sp)
 a3c:	7442                	ld	s0,48(sp)
 a3e:	74a2                	ld	s1,40(sp)
 a40:	69e2                	ld	s3,24(sp)
 a42:	6121                	addi	sp,sp,64
 a44:	8082                	ret
 a46:	7902                	ld	s2,32(sp)
 a48:	6a42                	ld	s4,16(sp)
 a4a:	6aa2                	ld	s5,8(sp)
 a4c:	6b02                	ld	s6,0(sp)
 a4e:	b7f5                	j	a3a <malloc+0xe2>
