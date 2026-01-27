
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc, char *argv[])
{
   0:	c9010113          	addi	sp,sp,-880
   4:	36113423          	sd	ra,872(sp)
   8:	36813023          	sd	s0,864(sp)
   c:	34913c23          	sd	s1,856(sp)
  10:	35213823          	sd	s2,848(sp)
  14:	35313423          	sd	s3,840(sp)
  18:	35413023          	sd	s4,832(sp)
  1c:	33513c23          	sd	s5,824(sp)
  20:	33613823          	sd	s6,816(sp)
  24:	33713423          	sd	s7,808(sp)
  28:	33813023          	sd	s8,800(sp)
  2c:	31913c23          	sd	s9,792(sp)
  30:	31a13823          	sd	s10,784(sp)
  34:	1e80                	addi	s0,sp,880
    char *second_argv[MAXARG];
    int second_argc = 0;
    int start_arg_idx = 1;
    int max_args = MAXARG - 1;

    if (argc > 1 && strcmp(argv[1], "-n") == 0) // eg. (echo 1 ; echo 2) | xargs -n 1 echo
  36:	4785                	li	a5,1
    int max_args = MAXARG - 1;
  38:	4b7d                	li	s6,31
    int second_argc = 0;
  3a:	4a81                	li	s5,0
    if (argc > 1 && strcmp(argv[1], "-n") == 0) // eg. (echo 1 ; echo 2) | xargs -n 1 echo
  3c:	06a7d063          	bge	a5,a0,9c <main+0x9c>
  40:	892a                	mv	s2,a0
  42:	84ae                	mv	s1,a1
  44:	00001597          	auipc	a1,0x1
  48:	9fc58593          	addi	a1,a1,-1540 # a40 <malloc+0x106>
  4c:	6488                	ld	a0,8(s1)
  4e:	18c000ef          	jal	1da <strcmp>
  52:	8aaa                	mv	s5,a0
  54:	e125                	bnez	a0,b4 <main+0xb4>
    {
        if (argc > 2)
  56:	4789                	li	a5,2
  58:	0127c563          	blt	a5,s2,62 <main+0x62>
  5c:	4b7d                	li	s6,31
  5e:	4685                	li	a3,1
  60:	a809                	j	72 <main+0x72>
        {
            max_args = atoi(argv[2]);
  62:	6888                	ld	a0,16(s1)
  64:	2bc000ef          	jal	320 <atoi>
  68:	8b2a                	mv	s6,a0
            start_arg_idx = 3; // skip "-n" and its number argument
        }
    }

    for (int i = start_arg_idx; i < argc; i++)
  6a:	478d                	li	a5,3
  6c:	0327d863          	bge	a5,s2,9c <main+0x9c>
  70:	468d                	li	a3,3
  72:	00369793          	slli	a5,a3,0x3
  76:	00f48733          	add	a4,s1,a5
  7a:	ca040793          	addi	a5,s0,-864
  7e:	40d9093b          	subw	s2,s2,a3
  82:	02091693          	slli	a3,s2,0x20
  86:	01d6d613          	srli	a2,a3,0x1d
  8a:	963e                	add	a2,a2,a5
    {
        second_argv[second_argc++] = argv[i]; // stores the arguments after pipe except argv[0] which is "xargs"
  8c:	6314                	ld	a3,0(a4)
  8e:	e394                	sd	a3,0(a5)
    for (int i = start_arg_idx; i < argc; i++)
  90:	0721                	addi	a4,a4,8
  92:	07a1                	addi	a5,a5,8
  94:	fec79ce3          	bne	a5,a2,8c <main+0x8c>
  98:	00090a9b          	sext.w	s5,s2
            }
        }
        else // there is still chars left in the output of piped result
        {
            if (i < 512) // prevent buffer overflow
                buf[i++] = c;
  9c:	84d6                	mv	s1,s5
    int i = 0;
  9e:	4901                	li	s2,0
    char *current_arg = buf;     // point to the beginning of buf to store piped input arguments
  a0:	da040993          	addi	s3,s0,-608
        if (c == ' ' || c == '\n') // if stdin becomes \n or space,
  a4:	02000a13          	li	s4,32
                second_argc = base_argc; // reset argument count for next command
  a8:	8d56                	mv	s10,s5
            if (args_read >= max_args || second_argc == MAXARG - 1) // this usually does not run unless user specifies max args with -n or 31 args actually reaches
  aa:	4cfd                	li	s9,31
        if (c == ' ' || c == '\n') // if stdin becomes \n or space,
  ac:	4ba9                	li	s7,10
            if (i < 512) // prevent buffer overflow
  ae:	1ff00c13          	li	s8,511
  b2:	a095                	j	116 <main+0x116>
  b4:	4b7d                	li	s6,31
  b6:	4685                	li	a3,1
  b8:	bf6d                	j	72 <main+0x72>
            buf[i++] = 0;                             // buf now contains the results of the first argument before | we complete the String by appending null
  ba:	fa090793          	addi	a5,s2,-96
  be:	97a2                	add	a5,a5,s0
  c0:	e0078023          	sb	zero,-512(a5)
            second_argv[second_argc++] = current_arg; // add the piped input as last argument
  c4:	0014879b          	addiw	a5,s1,1
  c8:	0007871b          	sext.w	a4,a5
  cc:	048e                	slli	s1,s1,0x3
  ce:	fa048693          	addi	a3,s1,-96
  d2:	008684b3          	add	s1,a3,s0
  d6:	d134b023          	sd	s3,-768(s1)
            if (args_read >= max_args || second_argc == MAXARG - 1) // this usually does not run unless user specifies max args with -n or 31 args actually reaches
  da:	415787bb          	subw	a5,a5,s5
  de:	0167db63          	bge	a5,s6,f4 <main+0xf4>
  e2:	01970963          	beq	a4,s9,f4 <main+0xf4>
            buf[i++] = 0;                             // buf now contains the results of the first argument before | we complete the String by appending null
  e6:	2905                	addiw	s2,s2,1
            current_arg = &buf[i];                    // point to next arg position
  e8:	da040793          	addi	a5,s0,-608
  ec:	012789b3          	add	s3,a5,s2
            second_argv[second_argc++] = current_arg; // add the piped input as last argument
  f0:	84ba                	mv	s1,a4
  f2:	a015                	j	116 <main+0x116>
                second_argv[second_argc] = 0; // null-terminate the argv array
  f4:	070e                	slli	a4,a4,0x3
  f6:	fa070793          	addi	a5,a4,-96
  fa:	00878733          	add	a4,a5,s0
  fe:	d0073023          	sd	zero,-768(a4)
                if (fork() == 0) // fork is executed and this if block runs in child process
 102:	338000ef          	jal	43a <fork>
 106:	cd1d                	beqz	a0,144 <main+0x144>
                wait(0); // when child process ends at exit(1);, parent continues
 108:	4501                	li	a0,0
 10a:	340000ef          	jal	44a <wait>
                second_argc = base_argc; // reset argument count for next command
 10e:	84ea                	mv	s1,s10
                i = 0;                   // reset buffer index for next line
 110:	4901                	li	s2,0
                current_arg = buf;       // point to beginning of buf to store next piped input arguments
 112:	da040993          	addi	s3,s0,-608
    while (read(0, &c, 1) > 0) // read piped input from stdin (stdin = 0) into char c, one char at a time
 116:	4605                	li	a2,1
 118:	c9f40593          	addi	a1,s0,-865
 11c:	4501                	li	a0,0
 11e:	33c000ef          	jal	45a <read>
 122:	04a05263          	blez	a0,166 <main+0x166>
        if (c == ' ' || c == '\n') // if stdin becomes \n or space,
 126:	c9f44783          	lbu	a5,-865(s0)
 12a:	f94788e3          	beq	a5,s4,ba <main+0xba>
 12e:	f97786e3          	beq	a5,s7,ba <main+0xba>
            if (i < 512) // prevent buffer overflow
 132:	ff2c42e3          	blt	s8,s2,116 <main+0x116>
                buf[i++] = c;
 136:	fa090713          	addi	a4,s2,-96
 13a:	9722                	add	a4,a4,s0
 13c:	e0f70023          	sb	a5,-512(a4)
 140:	2905                	addiw	s2,s2,1
 142:	bfd1                	j	116 <main+0x116>
                    exec(second_argv[0], second_argv); // in exec(), the first parameter is the command to run, the second parameter is the arguments for that command
 144:	ca040593          	addi	a1,s0,-864
 148:	ca043503          	ld	a0,-864(s0)
 14c:	32e000ef          	jal	47a <exec>
                    printf("xargs: exec %s failed\n", second_argv[0]);
 150:	ca043583          	ld	a1,-864(s0)
 154:	00001517          	auipc	a0,0x1
 158:	8f450513          	addi	a0,a0,-1804 # a48 <malloc+0x10e>
 15c:	72a000ef          	jal	886 <printf>
                    exit(1);
 160:	4505                	li	a0,1
 162:	2e0000ef          	jal	442 <exit>
        }
    }

    if (second_argc > base_argc) // the command after xargs will usually be ran here unless user specifies max args or the args actually reaches 31
 166:	049ad063          	bge	s5,s1,1a6 <main+0x1a6>
    {
        second_argv[second_argc] = 0; // null-terminate the argv array
 16a:	048e                	slli	s1,s1,0x3
 16c:	fa048793          	addi	a5,s1,-96
 170:	008784b3          	add	s1,a5,s0
 174:	d004b023          	sd	zero,-768(s1)

        if (fork() == 0) // fork is executed and this if block runs in child process
 178:	2c2000ef          	jal	43a <fork>
 17c:	e115                	bnez	a0,1a0 <main+0x1a0>
        {
            exec(second_argv[0], second_argv); // in exec(), the first parameter is the command to run, the second parameter is the arguments for that command
 17e:	ca040593          	addi	a1,s0,-864
 182:	ca043503          	ld	a0,-864(s0)
 186:	2f4000ef          	jal	47a <exec>
                                               // eg. exec("echo", {"echo", "bye", "piped_input", 0}) will run "echo bye piped_input"
                                               // after its done, child process ends and parent process continues from wait(0);
            printf("xargs: exec %s failed\n", second_argv[0]);
 18a:	ca043583          	ld	a1,-864(s0)
 18e:	00001517          	auipc	a0,0x1
 192:	8ba50513          	addi	a0,a0,-1862 # a48 <malloc+0x10e>
 196:	6f0000ef          	jal	886 <printf>
            exit(1);
 19a:	4505                	li	a0,1
 19c:	2a6000ef          	jal	442 <exit>
        }
        wait(0); // when child process ends at exit(1);, parent continues
 1a0:	4501                	li	a0,0
 1a2:	2a8000ef          	jal	44a <wait>
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

00000000000004e2 <hello>:
.global hello
hello:
 li a7, SYS_hello
 4e2:	48dd                	li	a7,23
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
 4ea:	48d9                	li	a7,22
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f2:	1101                	addi	sp,sp,-32
 4f4:	ec06                	sd	ra,24(sp)
 4f6:	e822                	sd	s0,16(sp)
 4f8:	1000                	addi	s0,sp,32
 4fa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fe:	4605                	li	a2,1
 500:	fef40593          	addi	a1,s0,-17
 504:	f5fff0ef          	jal	462 <write>
}
 508:	60e2                	ld	ra,24(sp)
 50a:	6442                	ld	s0,16(sp)
 50c:	6105                	addi	sp,sp,32
 50e:	8082                	ret

0000000000000510 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 510:	715d                	addi	sp,sp,-80
 512:	e486                	sd	ra,72(sp)
 514:	e0a2                	sd	s0,64(sp)
 516:	fc26                	sd	s1,56(sp)
 518:	0880                	addi	s0,sp,80
 51a:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51c:	c299                	beqz	a3,522 <printint+0x12>
 51e:	0805c963          	bltz	a1,5b0 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 522:	2581                	sext.w	a1,a1
  neg = 0;
 524:	4881                	li	a7,0
 526:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 52a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 52c:	2601                	sext.w	a2,a2
 52e:	00000517          	auipc	a0,0x0
 532:	53a50513          	addi	a0,a0,1338 # a68 <digits>
 536:	883a                	mv	a6,a4
 538:	2705                	addiw	a4,a4,1
 53a:	02c5f7bb          	remuw	a5,a1,a2
 53e:	1782                	slli	a5,a5,0x20
 540:	9381                	srli	a5,a5,0x20
 542:	97aa                	add	a5,a5,a0
 544:	0007c783          	lbu	a5,0(a5)
 548:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 54c:	0005879b          	sext.w	a5,a1
 550:	02c5d5bb          	divuw	a1,a1,a2
 554:	0685                	addi	a3,a3,1
 556:	fec7f0e3          	bgeu	a5,a2,536 <printint+0x26>
  if(neg)
 55a:	00088c63          	beqz	a7,572 <printint+0x62>
    buf[i++] = '-';
 55e:	fd070793          	addi	a5,a4,-48
 562:	00878733          	add	a4,a5,s0
 566:	02d00793          	li	a5,45
 56a:	fef70423          	sb	a5,-24(a4)
 56e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 572:	02e05a63          	blez	a4,5a6 <printint+0x96>
 576:	f84a                	sd	s2,48(sp)
 578:	f44e                	sd	s3,40(sp)
 57a:	fb840793          	addi	a5,s0,-72
 57e:	00e78933          	add	s2,a5,a4
 582:	fff78993          	addi	s3,a5,-1
 586:	99ba                	add	s3,s3,a4
 588:	377d                	addiw	a4,a4,-1
 58a:	1702                	slli	a4,a4,0x20
 58c:	9301                	srli	a4,a4,0x20
 58e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 592:	fff94583          	lbu	a1,-1(s2)
 596:	8526                	mv	a0,s1
 598:	f5bff0ef          	jal	4f2 <putc>
  while(--i >= 0)
 59c:	197d                	addi	s2,s2,-1
 59e:	ff391ae3          	bne	s2,s3,592 <printint+0x82>
 5a2:	7942                	ld	s2,48(sp)
 5a4:	79a2                	ld	s3,40(sp)
}
 5a6:	60a6                	ld	ra,72(sp)
 5a8:	6406                	ld	s0,64(sp)
 5aa:	74e2                	ld	s1,56(sp)
 5ac:	6161                	addi	sp,sp,80
 5ae:	8082                	ret
    x = -xx;
 5b0:	40b005bb          	negw	a1,a1
    neg = 1;
 5b4:	4885                	li	a7,1
    x = -xx;
 5b6:	bf85                	j	526 <printint+0x16>

00000000000005b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b8:	711d                	addi	sp,sp,-96
 5ba:	ec86                	sd	ra,88(sp)
 5bc:	e8a2                	sd	s0,80(sp)
 5be:	e0ca                	sd	s2,64(sp)
 5c0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c2:	0005c903          	lbu	s2,0(a1)
 5c6:	28090663          	beqz	s2,852 <vprintf+0x29a>
 5ca:	e4a6                	sd	s1,72(sp)
 5cc:	fc4e                	sd	s3,56(sp)
 5ce:	f852                	sd	s4,48(sp)
 5d0:	f456                	sd	s5,40(sp)
 5d2:	f05a                	sd	s6,32(sp)
 5d4:	ec5e                	sd	s7,24(sp)
 5d6:	e862                	sd	s8,16(sp)
 5d8:	e466                	sd	s9,8(sp)
 5da:	8b2a                	mv	s6,a0
 5dc:	8a2e                	mv	s4,a1
 5de:	8bb2                	mv	s7,a2
  state = 0;
 5e0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5e2:	4481                	li	s1,0
 5e4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5e6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5ea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ee:	06c00c93          	li	s9,108
 5f2:	a005                	j	612 <vprintf+0x5a>
        putc(fd, c0);
 5f4:	85ca                	mv	a1,s2
 5f6:	855a                	mv	a0,s6
 5f8:	efbff0ef          	jal	4f2 <putc>
 5fc:	a019                	j	602 <vprintf+0x4a>
    } else if(state == '%'){
 5fe:	03598263          	beq	s3,s5,622 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 602:	2485                	addiw	s1,s1,1
 604:	8726                	mv	a4,s1
 606:	009a07b3          	add	a5,s4,s1
 60a:	0007c903          	lbu	s2,0(a5)
 60e:	22090a63          	beqz	s2,842 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 612:	0009079b          	sext.w	a5,s2
    if(state == 0){
 616:	fe0994e3          	bnez	s3,5fe <vprintf+0x46>
      if(c0 == '%'){
 61a:	fd579de3          	bne	a5,s5,5f4 <vprintf+0x3c>
        state = '%';
 61e:	89be                	mv	s3,a5
 620:	b7cd                	j	602 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 622:	00ea06b3          	add	a3,s4,a4
 626:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 62a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 62c:	c681                	beqz	a3,634 <vprintf+0x7c>
 62e:	9752                	add	a4,a4,s4
 630:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 634:	05878363          	beq	a5,s8,67a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 638:	05978d63          	beq	a5,s9,692 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 63c:	07500713          	li	a4,117
 640:	0ee78763          	beq	a5,a4,72e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 644:	07800713          	li	a4,120
 648:	12e78963          	beq	a5,a4,77a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 64c:	07000713          	li	a4,112
 650:	14e78e63          	beq	a5,a4,7ac <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 654:	06300713          	li	a4,99
 658:	18e78e63          	beq	a5,a4,7f4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 65c:	07300713          	li	a4,115
 660:	1ae78463          	beq	a5,a4,808 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 664:	02500713          	li	a4,37
 668:	04e79563          	bne	a5,a4,6b2 <vprintf+0xfa>
        putc(fd, '%');
 66c:	02500593          	li	a1,37
 670:	855a                	mv	a0,s6
 672:	e81ff0ef          	jal	4f2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 676:	4981                	li	s3,0
 678:	b769                	j	602 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 67a:	008b8913          	addi	s2,s7,8
 67e:	4685                	li	a3,1
 680:	4629                	li	a2,10
 682:	000ba583          	lw	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	e89ff0ef          	jal	510 <printint>
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	bf8d                	j	602 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 692:	06400793          	li	a5,100
 696:	02f68963          	beq	a3,a5,6c8 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 69a:	06c00793          	li	a5,108
 69e:	04f68263          	beq	a3,a5,6e2 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 6a2:	07500793          	li	a5,117
 6a6:	0af68063          	beq	a3,a5,746 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 6aa:	07800793          	li	a5,120
 6ae:	0ef68263          	beq	a3,a5,792 <vprintf+0x1da>
        putc(fd, '%');
 6b2:	02500593          	li	a1,37
 6b6:	855a                	mv	a0,s6
 6b8:	e3bff0ef          	jal	4f2 <putc>
        putc(fd, c0);
 6bc:	85ca                	mv	a1,s2
 6be:	855a                	mv	a0,s6
 6c0:	e33ff0ef          	jal	4f2 <putc>
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bf35                	j	602 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c8:	008b8913          	addi	s2,s7,8
 6cc:	4685                	li	a3,1
 6ce:	4629                	li	a2,10
 6d0:	000bb583          	ld	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	e3bff0ef          	jal	510 <printint>
        i += 1;
 6da:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
        i += 1;
 6e0:	b70d                	j	602 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e2:	06400793          	li	a5,100
 6e6:	02f60763          	beq	a2,a5,714 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ea:	07500793          	li	a5,117
 6ee:	06f60963          	beq	a2,a5,760 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f2:	07800793          	li	a5,120
 6f6:	faf61ee3          	bne	a2,a5,6b2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fa:	008b8913          	addi	s2,s7,8
 6fe:	4681                	li	a3,0
 700:	4641                	li	a2,16
 702:	000bb583          	ld	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	e09ff0ef          	jal	510 <printint>
        i += 2;
 70c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 70e:	8bca                	mv	s7,s2
      state = 0;
 710:	4981                	li	s3,0
        i += 2;
 712:	bdc5                	j	602 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 714:	008b8913          	addi	s2,s7,8
 718:	4685                	li	a3,1
 71a:	4629                	li	a2,10
 71c:	000bb583          	ld	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	defff0ef          	jal	510 <printint>
        i += 2;
 726:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
        i += 2;
 72c:	bdd9                	j	602 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 72e:	008b8913          	addi	s2,s7,8
 732:	4681                	li	a3,0
 734:	4629                	li	a2,10
 736:	000be583          	lwu	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	dd5ff0ef          	jal	510 <printint>
 740:	8bca                	mv	s7,s2
      state = 0;
 742:	4981                	li	s3,0
 744:	bd7d                	j	602 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 746:	008b8913          	addi	s2,s7,8
 74a:	4681                	li	a3,0
 74c:	4629                	li	a2,10
 74e:	000bb583          	ld	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	dbdff0ef          	jal	510 <printint>
        i += 1;
 758:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
        i += 1;
 75e:	b555                	j	602 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 760:	008b8913          	addi	s2,s7,8
 764:	4681                	li	a3,0
 766:	4629                	li	a2,10
 768:	000bb583          	ld	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	da3ff0ef          	jal	510 <printint>
        i += 2;
 772:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 774:	8bca                	mv	s7,s2
      state = 0;
 776:	4981                	li	s3,0
        i += 2;
 778:	b569                	j	602 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 77a:	008b8913          	addi	s2,s7,8
 77e:	4681                	li	a3,0
 780:	4641                	li	a2,16
 782:	000be583          	lwu	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	d89ff0ef          	jal	510 <printint>
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
 790:	bd8d                	j	602 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 792:	008b8913          	addi	s2,s7,8
 796:	4681                	li	a3,0
 798:	4641                	li	a2,16
 79a:	000bb583          	ld	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	d71ff0ef          	jal	510 <printint>
        i += 1;
 7a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
        i += 1;
 7aa:	bda1                	j	602 <vprintf+0x4a>
 7ac:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7ae:	008b8d13          	addi	s10,s7,8
 7b2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7b6:	03000593          	li	a1,48
 7ba:	855a                	mv	a0,s6
 7bc:	d37ff0ef          	jal	4f2 <putc>
  putc(fd, 'x');
 7c0:	07800593          	li	a1,120
 7c4:	855a                	mv	a0,s6
 7c6:	d2dff0ef          	jal	4f2 <putc>
 7ca:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7cc:	00000b97          	auipc	s7,0x0
 7d0:	29cb8b93          	addi	s7,s7,668 # a68 <digits>
 7d4:	03c9d793          	srli	a5,s3,0x3c
 7d8:	97de                	add	a5,a5,s7
 7da:	0007c583          	lbu	a1,0(a5)
 7de:	855a                	mv	a0,s6
 7e0:	d13ff0ef          	jal	4f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7e4:	0992                	slli	s3,s3,0x4
 7e6:	397d                	addiw	s2,s2,-1
 7e8:	fe0916e3          	bnez	s2,7d4 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7ec:	8bea                	mv	s7,s10
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	6d02                	ld	s10,0(sp)
 7f2:	bd01                	j	602 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7f4:	008b8913          	addi	s2,s7,8
 7f8:	000bc583          	lbu	a1,0(s7)
 7fc:	855a                	mv	a0,s6
 7fe:	cf5ff0ef          	jal	4f2 <putc>
 802:	8bca                	mv	s7,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	bbf5                	j	602 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 808:	008b8993          	addi	s3,s7,8
 80c:	000bb903          	ld	s2,0(s7)
 810:	00090f63          	beqz	s2,82e <vprintf+0x276>
        for(; *s; s++)
 814:	00094583          	lbu	a1,0(s2)
 818:	c195                	beqz	a1,83c <vprintf+0x284>
          putc(fd, *s);
 81a:	855a                	mv	a0,s6
 81c:	cd7ff0ef          	jal	4f2 <putc>
        for(; *s; s++)
 820:	0905                	addi	s2,s2,1
 822:	00094583          	lbu	a1,0(s2)
 826:	f9f5                	bnez	a1,81a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 828:	8bce                	mv	s7,s3
      state = 0;
 82a:	4981                	li	s3,0
 82c:	bbd9                	j	602 <vprintf+0x4a>
          s = "(null)";
 82e:	00000917          	auipc	s2,0x0
 832:	23290913          	addi	s2,s2,562 # a60 <malloc+0x126>
        for(; *s; s++)
 836:	02800593          	li	a1,40
 83a:	b7c5                	j	81a <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 83c:	8bce                	mv	s7,s3
      state = 0;
 83e:	4981                	li	s3,0
 840:	b3c9                	j	602 <vprintf+0x4a>
 842:	64a6                	ld	s1,72(sp)
 844:	79e2                	ld	s3,56(sp)
 846:	7a42                	ld	s4,48(sp)
 848:	7aa2                	ld	s5,40(sp)
 84a:	7b02                	ld	s6,32(sp)
 84c:	6be2                	ld	s7,24(sp)
 84e:	6c42                	ld	s8,16(sp)
 850:	6ca2                	ld	s9,8(sp)
    }
  }
}
 852:	60e6                	ld	ra,88(sp)
 854:	6446                	ld	s0,80(sp)
 856:	6906                	ld	s2,64(sp)
 858:	6125                	addi	sp,sp,96
 85a:	8082                	ret

000000000000085c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 85c:	715d                	addi	sp,sp,-80
 85e:	ec06                	sd	ra,24(sp)
 860:	e822                	sd	s0,16(sp)
 862:	1000                	addi	s0,sp,32
 864:	e010                	sd	a2,0(s0)
 866:	e414                	sd	a3,8(s0)
 868:	e818                	sd	a4,16(s0)
 86a:	ec1c                	sd	a5,24(s0)
 86c:	03043023          	sd	a6,32(s0)
 870:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 874:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 878:	8622                	mv	a2,s0
 87a:	d3fff0ef          	jal	5b8 <vprintf>
}
 87e:	60e2                	ld	ra,24(sp)
 880:	6442                	ld	s0,16(sp)
 882:	6161                	addi	sp,sp,80
 884:	8082                	ret

0000000000000886 <printf>:

void
printf(const char *fmt, ...)
{
 886:	711d                	addi	sp,sp,-96
 888:	ec06                	sd	ra,24(sp)
 88a:	e822                	sd	s0,16(sp)
 88c:	1000                	addi	s0,sp,32
 88e:	e40c                	sd	a1,8(s0)
 890:	e810                	sd	a2,16(s0)
 892:	ec14                	sd	a3,24(s0)
 894:	f018                	sd	a4,32(s0)
 896:	f41c                	sd	a5,40(s0)
 898:	03043823          	sd	a6,48(s0)
 89c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a0:	00840613          	addi	a2,s0,8
 8a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a8:	85aa                	mv	a1,a0
 8aa:	4505                	li	a0,1
 8ac:	d0dff0ef          	jal	5b8 <vprintf>
}
 8b0:	60e2                	ld	ra,24(sp)
 8b2:	6442                	ld	s0,16(sp)
 8b4:	6125                	addi	sp,sp,96
 8b6:	8082                	ret

00000000000008b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b8:	1141                	addi	sp,sp,-16
 8ba:	e422                	sd	s0,8(sp)
 8bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c2:	00000797          	auipc	a5,0x0
 8c6:	73e7b783          	ld	a5,1854(a5) # 1000 <freep>
 8ca:	a02d                	j	8f4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8cc:	4618                	lw	a4,8(a2)
 8ce:	9f2d                	addw	a4,a4,a1
 8d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d4:	6398                	ld	a4,0(a5)
 8d6:	6310                	ld	a2,0(a4)
 8d8:	a83d                	j	916 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8da:	ff852703          	lw	a4,-8(a0)
 8de:	9f31                	addw	a4,a4,a2
 8e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8e2:	ff053683          	ld	a3,-16(a0)
 8e6:	a091                	j	92a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e8:	6398                	ld	a4,0(a5)
 8ea:	00e7e463          	bltu	a5,a4,8f2 <free+0x3a>
 8ee:	00e6ea63          	bltu	a3,a4,902 <free+0x4a>
{
 8f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f4:	fed7fae3          	bgeu	a5,a3,8e8 <free+0x30>
 8f8:	6398                	ld	a4,0(a5)
 8fa:	00e6e463          	bltu	a3,a4,902 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fe:	fee7eae3          	bltu	a5,a4,8f2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 902:	ff852583          	lw	a1,-8(a0)
 906:	6390                	ld	a2,0(a5)
 908:	02059813          	slli	a6,a1,0x20
 90c:	01c85713          	srli	a4,a6,0x1c
 910:	9736                	add	a4,a4,a3
 912:	fae60de3          	beq	a2,a4,8cc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 916:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 91a:	4790                	lw	a2,8(a5)
 91c:	02061593          	slli	a1,a2,0x20
 920:	01c5d713          	srli	a4,a1,0x1c
 924:	973e                	add	a4,a4,a5
 926:	fae68ae3          	beq	a3,a4,8da <free+0x22>
    p->s.ptr = bp->s.ptr;
 92a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 92c:	00000717          	auipc	a4,0x0
 930:	6cf73a23          	sd	a5,1748(a4) # 1000 <freep>
}
 934:	6422                	ld	s0,8(sp)
 936:	0141                	addi	sp,sp,16
 938:	8082                	ret

000000000000093a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 93a:	7139                	addi	sp,sp,-64
 93c:	fc06                	sd	ra,56(sp)
 93e:	f822                	sd	s0,48(sp)
 940:	f426                	sd	s1,40(sp)
 942:	ec4e                	sd	s3,24(sp)
 944:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 946:	02051493          	slli	s1,a0,0x20
 94a:	9081                	srli	s1,s1,0x20
 94c:	04bd                	addi	s1,s1,15
 94e:	8091                	srli	s1,s1,0x4
 950:	0014899b          	addiw	s3,s1,1
 954:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 956:	00000517          	auipc	a0,0x0
 95a:	6aa53503          	ld	a0,1706(a0) # 1000 <freep>
 95e:	c915                	beqz	a0,992 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 960:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 962:	4798                	lw	a4,8(a5)
 964:	08977a63          	bgeu	a4,s1,9f8 <malloc+0xbe>
 968:	f04a                	sd	s2,32(sp)
 96a:	e852                	sd	s4,16(sp)
 96c:	e456                	sd	s5,8(sp)
 96e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 970:	8a4e                	mv	s4,s3
 972:	0009871b          	sext.w	a4,s3
 976:	6685                	lui	a3,0x1
 978:	00d77363          	bgeu	a4,a3,97e <malloc+0x44>
 97c:	6a05                	lui	s4,0x1
 97e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 982:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 986:	00000917          	auipc	s2,0x0
 98a:	67a90913          	addi	s2,s2,1658 # 1000 <freep>
  if(p == SBRK_ERROR)
 98e:	5afd                	li	s5,-1
 990:	a081                	j	9d0 <malloc+0x96>
 992:	f04a                	sd	s2,32(sp)
 994:	e852                	sd	s4,16(sp)
 996:	e456                	sd	s5,8(sp)
 998:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 99a:	00000797          	auipc	a5,0x0
 99e:	67678793          	addi	a5,a5,1654 # 1010 <base>
 9a2:	00000717          	auipc	a4,0x0
 9a6:	64f73f23          	sd	a5,1630(a4) # 1000 <freep>
 9aa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9b0:	b7c1                	j	970 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9b2:	6398                	ld	a4,0(a5)
 9b4:	e118                	sd	a4,0(a0)
 9b6:	a8a9                	j	a10 <malloc+0xd6>
  hp->s.size = nu;
 9b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9bc:	0541                	addi	a0,a0,16
 9be:	efbff0ef          	jal	8b8 <free>
  return freep;
 9c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9c6:	c12d                	beqz	a0,a28 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ca:	4798                	lw	a4,8(a5)
 9cc:	02977263          	bgeu	a4,s1,9f0 <malloc+0xb6>
    if(p == freep)
 9d0:	00093703          	ld	a4,0(s2)
 9d4:	853e                	mv	a0,a5
 9d6:	fef719e3          	bne	a4,a5,9c8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9da:	8552                	mv	a0,s4
 9dc:	a33ff0ef          	jal	40e <sbrk>
  if(p == SBRK_ERROR)
 9e0:	fd551ce3          	bne	a0,s5,9b8 <malloc+0x7e>
        return 0;
 9e4:	4501                	li	a0,0
 9e6:	7902                	ld	s2,32(sp)
 9e8:	6a42                	ld	s4,16(sp)
 9ea:	6aa2                	ld	s5,8(sp)
 9ec:	6b02                	ld	s6,0(sp)
 9ee:	a03d                	j	a1c <malloc+0xe2>
 9f0:	7902                	ld	s2,32(sp)
 9f2:	6a42                	ld	s4,16(sp)
 9f4:	6aa2                	ld	s5,8(sp)
 9f6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9f8:	fae48de3          	beq	s1,a4,9b2 <malloc+0x78>
        p->s.size -= nunits;
 9fc:	4137073b          	subw	a4,a4,s3
 a00:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a02:	02071693          	slli	a3,a4,0x20
 a06:	01c6d713          	srli	a4,a3,0x1c
 a0a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a0c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a10:	00000717          	auipc	a4,0x0
 a14:	5ea73823          	sd	a0,1520(a4) # 1000 <freep>
      return (void*)(p + 1);
 a18:	01078513          	addi	a0,a5,16
  }
}
 a1c:	70e2                	ld	ra,56(sp)
 a1e:	7442                	ld	s0,48(sp)
 a20:	74a2                	ld	s1,40(sp)
 a22:	69e2                	ld	s3,24(sp)
 a24:	6121                	addi	sp,sp,64
 a26:	8082                	ret
 a28:	7902                	ld	s2,32(sp)
 a2a:	6a42                	ld	s4,16(sp)
 a2c:	6aa2                	ld	s5,8(sp)
 a2e:	6b02                	ld	s6,0(sp)
 a30:	b7f5                	j	a1c <malloc+0xe2>
