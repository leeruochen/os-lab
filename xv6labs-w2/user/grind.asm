
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	f99ff0ef          	jal	0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	addi	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7159                	addi	sp,sp,-112
      76:	f486                	sd	ra,104(sp)
      78:	f0a2                	sd	s0,96(sp)
      7a:	eca6                	sd	s1,88(sp)
      7c:	fc56                	sd	s5,56(sp)
      7e:	1880                	addi	s0,sp,112
      80:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      82:	4501                	li	a0,0
      84:	2bd000ef          	jal	b40 <sbrk>
      88:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      8a:	00001517          	auipc	a0,0x1
      8e:	0e650513          	addi	a0,a0,230 # 1170 <malloc+0x104>
      92:	34b000ef          	jal	bdc <mkdir>
  if(chdir("grindir") != 0){
      96:	00001517          	auipc	a0,0x1
      9a:	0da50513          	addi	a0,a0,218 # 1170 <malloc+0x104>
      9e:	347000ef          	jal	be4 <chdir>
      a2:	cd11                	beqz	a0,be <go+0x4a>
      a4:	e8ca                	sd	s2,80(sp)
      a6:	e4ce                	sd	s3,72(sp)
      a8:	e0d2                	sd	s4,64(sp)
      aa:	f85a                	sd	s6,48(sp)
    printf("grind: chdir grindir failed\n");
      ac:	00001517          	auipc	a0,0x1
      b0:	0cc50513          	addi	a0,a0,204 # 1178 <malloc+0x10c>
      b4:	705000ef          	jal	fb8 <printf>
    exit(1);
      b8:	4505                	li	a0,1
      ba:	2bb000ef          	jal	b74 <exit>
      be:	e8ca                	sd	s2,80(sp)
      c0:	e4ce                	sd	s3,72(sp)
      c2:	e0d2                	sd	s4,64(sp)
      c4:	f85a                	sd	s6,48(sp)
  }
  chdir("/");
      c6:	00001517          	auipc	a0,0x1
      ca:	0da50513          	addi	a0,a0,218 # 11a0 <malloc+0x134>
      ce:	317000ef          	jal	be4 <chdir>
      d2:	00001997          	auipc	s3,0x1
      d6:	0de98993          	addi	s3,s3,222 # 11b0 <malloc+0x144>
      da:	c489                	beqz	s1,e4 <go+0x70>
      dc:	00001997          	auipc	s3,0x1
      e0:	0cc98993          	addi	s3,s3,204 # 11a8 <malloc+0x13c>
  uint64 iters = 0;
      e4:	4481                	li	s1,0
  int fd = -1;
      e6:	5a7d                	li	s4,-1
      e8:	00001917          	auipc	s2,0x1
      ec:	39890913          	addi	s2,s2,920 # 1480 <malloc+0x414>
      f0:	a819                	j	106 <go+0x92>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
      f2:	20200593          	li	a1,514
      f6:	00001517          	auipc	a0,0x1
      fa:	0c250513          	addi	a0,a0,194 # 11b8 <malloc+0x14c>
      fe:	2b7000ef          	jal	bb4 <open>
     102:	29b000ef          	jal	b9c <close>
    iters++;
     106:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     108:	1f400793          	li	a5,500
     10c:	02f4f7b3          	remu	a5,s1,a5
     110:	e791                	bnez	a5,11c <go+0xa8>
      write(1, which_child?"B":"A", 1);
     112:	4605                	li	a2,1
     114:	85ce                	mv	a1,s3
     116:	4505                	li	a0,1
     118:	27d000ef          	jal	b94 <write>
    int what = rand() % 23;
     11c:	f3dff0ef          	jal	58 <rand>
     120:	47dd                	li	a5,23
     122:	02f5653b          	remw	a0,a0,a5
     126:	0005071b          	sext.w	a4,a0
     12a:	47d9                	li	a5,22
     12c:	fce7ede3          	bltu	a5,a4,106 <go+0x92>
     130:	02051793          	slli	a5,a0,0x20
     134:	01e7d513          	srli	a0,a5,0x1e
     138:	954a                	add	a0,a0,s2
     13a:	411c                	lw	a5,0(a0)
     13c:	97ca                	add	a5,a5,s2
     13e:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     140:	20200593          	li	a1,514
     144:	00001517          	auipc	a0,0x1
     148:	08450513          	addi	a0,a0,132 # 11c8 <malloc+0x15c>
     14c:	269000ef          	jal	bb4 <open>
     150:	24d000ef          	jal	b9c <close>
     154:	bf4d                	j	106 <go+0x92>
    } else if(what == 3){
      unlink("grindir/../a");
     156:	00001517          	auipc	a0,0x1
     15a:	06250513          	addi	a0,a0,98 # 11b8 <malloc+0x14c>
     15e:	267000ef          	jal	bc4 <unlink>
     162:	b755                	j	106 <go+0x92>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     164:	00001517          	auipc	a0,0x1
     168:	00c50513          	addi	a0,a0,12 # 1170 <malloc+0x104>
     16c:	279000ef          	jal	be4 <chdir>
     170:	ed11                	bnez	a0,18c <go+0x118>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     172:	00001517          	auipc	a0,0x1
     176:	06e50513          	addi	a0,a0,110 # 11e0 <malloc+0x174>
     17a:	24b000ef          	jal	bc4 <unlink>
      chdir("/");
     17e:	00001517          	auipc	a0,0x1
     182:	02250513          	addi	a0,a0,34 # 11a0 <malloc+0x134>
     186:	25f000ef          	jal	be4 <chdir>
     18a:	bfb5                	j	106 <go+0x92>
        printf("grind: chdir grindir failed\n");
     18c:	00001517          	auipc	a0,0x1
     190:	fec50513          	addi	a0,a0,-20 # 1178 <malloc+0x10c>
     194:	625000ef          	jal	fb8 <printf>
        exit(1);
     198:	4505                	li	a0,1
     19a:	1db000ef          	jal	b74 <exit>
    } else if(what == 5){
      close(fd);
     19e:	8552                	mv	a0,s4
     1a0:	1fd000ef          	jal	b9c <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1a4:	20200593          	li	a1,514
     1a8:	00001517          	auipc	a0,0x1
     1ac:	04050513          	addi	a0,a0,64 # 11e8 <malloc+0x17c>
     1b0:	205000ef          	jal	bb4 <open>
     1b4:	8a2a                	mv	s4,a0
     1b6:	bf81                	j	106 <go+0x92>
    } else if(what == 6){
      close(fd);
     1b8:	8552                	mv	a0,s4
     1ba:	1e3000ef          	jal	b9c <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     1be:	20200593          	li	a1,514
     1c2:	00001517          	auipc	a0,0x1
     1c6:	03650513          	addi	a0,a0,54 # 11f8 <malloc+0x18c>
     1ca:	1eb000ef          	jal	bb4 <open>
     1ce:	8a2a                	mv	s4,a0
     1d0:	bf1d                	j	106 <go+0x92>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     1d2:	3e700613          	li	a2,999
     1d6:	00002597          	auipc	a1,0x2
     1da:	e4a58593          	addi	a1,a1,-438 # 2020 <buf.0>
     1de:	8552                	mv	a0,s4
     1e0:	1b5000ef          	jal	b94 <write>
     1e4:	b70d                	j	106 <go+0x92>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     1e6:	3e700613          	li	a2,999
     1ea:	00002597          	auipc	a1,0x2
     1ee:	e3658593          	addi	a1,a1,-458 # 2020 <buf.0>
     1f2:	8552                	mv	a0,s4
     1f4:	199000ef          	jal	b8c <read>
     1f8:	b739                	j	106 <go+0x92>
    } else if(what == 9){
      mkdir("grindir/../a");
     1fa:	00001517          	auipc	a0,0x1
     1fe:	fbe50513          	addi	a0,a0,-66 # 11b8 <malloc+0x14c>
     202:	1db000ef          	jal	bdc <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     206:	20200593          	li	a1,514
     20a:	00001517          	auipc	a0,0x1
     20e:	00650513          	addi	a0,a0,6 # 1210 <malloc+0x1a4>
     212:	1a3000ef          	jal	bb4 <open>
     216:	187000ef          	jal	b9c <close>
      unlink("a/a");
     21a:	00001517          	auipc	a0,0x1
     21e:	00650513          	addi	a0,a0,6 # 1220 <malloc+0x1b4>
     222:	1a3000ef          	jal	bc4 <unlink>
     226:	b5c5                	j	106 <go+0x92>
    } else if(what == 10){
      mkdir("/../b");
     228:	00001517          	auipc	a0,0x1
     22c:	00050513          	mv	a0,a0
     230:	1ad000ef          	jal	bdc <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     234:	20200593          	li	a1,514
     238:	00001517          	auipc	a0,0x1
     23c:	ff850513          	addi	a0,a0,-8 # 1230 <malloc+0x1c4>
     240:	175000ef          	jal	bb4 <open>
     244:	159000ef          	jal	b9c <close>
      unlink("b/b");
     248:	00001517          	auipc	a0,0x1
     24c:	ff850513          	addi	a0,a0,-8 # 1240 <malloc+0x1d4>
     250:	175000ef          	jal	bc4 <unlink>
     254:	bd4d                	j	106 <go+0x92>
    } else if(what == 11){
      unlink("b");
     256:	00001517          	auipc	a0,0x1
     25a:	ff250513          	addi	a0,a0,-14 # 1248 <malloc+0x1dc>
     25e:	167000ef          	jal	bc4 <unlink>
      link("../grindir/./../a", "../b");
     262:	00001597          	auipc	a1,0x1
     266:	f7e58593          	addi	a1,a1,-130 # 11e0 <malloc+0x174>
     26a:	00001517          	auipc	a0,0x1
     26e:	fe650513          	addi	a0,a0,-26 # 1250 <malloc+0x1e4>
     272:	163000ef          	jal	bd4 <link>
     276:	bd41                	j	106 <go+0x92>
    } else if(what == 12){
      unlink("../grindir/../a");
     278:	00001517          	auipc	a0,0x1
     27c:	ff050513          	addi	a0,a0,-16 # 1268 <malloc+0x1fc>
     280:	145000ef          	jal	bc4 <unlink>
      link(".././b", "/grindir/../a");
     284:	00001597          	auipc	a1,0x1
     288:	f6458593          	addi	a1,a1,-156 # 11e8 <malloc+0x17c>
     28c:	00001517          	auipc	a0,0x1
     290:	fec50513          	addi	a0,a0,-20 # 1278 <malloc+0x20c>
     294:	141000ef          	jal	bd4 <link>
     298:	b5bd                	j	106 <go+0x92>
    } else if(what == 13){
      int pid = fork();
     29a:	0d3000ef          	jal	b6c <fork>
      if(pid == 0){
     29e:	c519                	beqz	a0,2ac <go+0x238>
        exit(0);
      } else if(pid < 0){
     2a0:	00054863          	bltz	a0,2b0 <go+0x23c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2a4:	4501                	li	a0,0
     2a6:	0d7000ef          	jal	b7c <wait>
     2aa:	bdb1                	j	106 <go+0x92>
        exit(0);
     2ac:	0c9000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     2b0:	00001517          	auipc	a0,0x1
     2b4:	fd050513          	addi	a0,a0,-48 # 1280 <malloc+0x214>
     2b8:	501000ef          	jal	fb8 <printf>
        exit(1);
     2bc:	4505                	li	a0,1
     2be:	0b7000ef          	jal	b74 <exit>
    } else if(what == 14){
      int pid = fork();
     2c2:	0ab000ef          	jal	b6c <fork>
      if(pid == 0){
     2c6:	c519                	beqz	a0,2d4 <go+0x260>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     2c8:	00054d63          	bltz	a0,2e2 <go+0x26e>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2cc:	4501                	li	a0,0
     2ce:	0af000ef          	jal	b7c <wait>
     2d2:	bd15                	j	106 <go+0x92>
        fork();
     2d4:	099000ef          	jal	b6c <fork>
        fork();
     2d8:	095000ef          	jal	b6c <fork>
        exit(0);
     2dc:	4501                	li	a0,0
     2de:	097000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     2e2:	00001517          	auipc	a0,0x1
     2e6:	f9e50513          	addi	a0,a0,-98 # 1280 <malloc+0x214>
     2ea:	4cf000ef          	jal	fb8 <printf>
        exit(1);
     2ee:	4505                	li	a0,1
     2f0:	085000ef          	jal	b74 <exit>
    } else if(what == 15){
      sbrk(6011);
     2f4:	6505                	lui	a0,0x1
     2f6:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x29b>
     2fa:	047000ef          	jal	b40 <sbrk>
     2fe:	b521                	j	106 <go+0x92>
    } else if(what == 16){
      if(sbrk(0) > break0)
     300:	4501                	li	a0,0
     302:	03f000ef          	jal	b40 <sbrk>
     306:	e0aaf0e3          	bgeu	s5,a0,106 <go+0x92>
        sbrk(-(sbrk(0) - break0));
     30a:	4501                	li	a0,0
     30c:	035000ef          	jal	b40 <sbrk>
     310:	40aa853b          	subw	a0,s5,a0
     314:	02d000ef          	jal	b40 <sbrk>
     318:	b3fd                	j	106 <go+0x92>
    } else if(what == 17){
      int pid = fork();
     31a:	053000ef          	jal	b6c <fork>
     31e:	8b2a                	mv	s6,a0
      if(pid == 0){
     320:	c10d                	beqz	a0,342 <go+0x2ce>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     322:	02054d63          	bltz	a0,35c <go+0x2e8>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     326:	00001517          	auipc	a0,0x1
     32a:	f7a50513          	addi	a0,a0,-134 # 12a0 <malloc+0x234>
     32e:	0b7000ef          	jal	be4 <chdir>
     332:	ed15                	bnez	a0,36e <go+0x2fa>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     334:	855a                	mv	a0,s6
     336:	06f000ef          	jal	ba4 <kill>
      wait(0);
     33a:	4501                	li	a0,0
     33c:	041000ef          	jal	b7c <wait>
     340:	b3d9                	j	106 <go+0x92>
        close(open("a", O_CREATE|O_RDWR));
     342:	20200593          	li	a1,514
     346:	00001517          	auipc	a0,0x1
     34a:	f5250513          	addi	a0,a0,-174 # 1298 <malloc+0x22c>
     34e:	067000ef          	jal	bb4 <open>
     352:	04b000ef          	jal	b9c <close>
        exit(0);
     356:	4501                	li	a0,0
     358:	01d000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     35c:	00001517          	auipc	a0,0x1
     360:	f2450513          	addi	a0,a0,-220 # 1280 <malloc+0x214>
     364:	455000ef          	jal	fb8 <printf>
        exit(1);
     368:	4505                	li	a0,1
     36a:	00b000ef          	jal	b74 <exit>
        printf("grind: chdir failed\n");
     36e:	00001517          	auipc	a0,0x1
     372:	f4250513          	addi	a0,a0,-190 # 12b0 <malloc+0x244>
     376:	443000ef          	jal	fb8 <printf>
        exit(1);
     37a:	4505                	li	a0,1
     37c:	7f8000ef          	jal	b74 <exit>
    } else if(what == 18){
      int pid = fork();
     380:	7ec000ef          	jal	b6c <fork>
      if(pid == 0){
     384:	c519                	beqz	a0,392 <go+0x31e>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     386:	00054d63          	bltz	a0,3a0 <go+0x32c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     38a:	4501                	li	a0,0
     38c:	7f0000ef          	jal	b7c <wait>
     390:	bb9d                	j	106 <go+0x92>
        kill(getpid());
     392:	063000ef          	jal	bf4 <getpid>
     396:	00f000ef          	jal	ba4 <kill>
        exit(0);
     39a:	4501                	li	a0,0
     39c:	7d8000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     3a0:	00001517          	auipc	a0,0x1
     3a4:	ee050513          	addi	a0,a0,-288 # 1280 <malloc+0x214>
     3a8:	411000ef          	jal	fb8 <printf>
        exit(1);
     3ac:	4505                	li	a0,1
     3ae:	7c6000ef          	jal	b74 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     3b2:	fa840513          	addi	a0,s0,-88
     3b6:	7ce000ef          	jal	b84 <pipe>
     3ba:	02054363          	bltz	a0,3e0 <go+0x36c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     3be:	7ae000ef          	jal	b6c <fork>
      if(pid == 0){
     3c2:	c905                	beqz	a0,3f2 <go+0x37e>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     3c4:	08054263          	bltz	a0,448 <go+0x3d4>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     3c8:	fa842503          	lw	a0,-88(s0)
     3cc:	7d0000ef          	jal	b9c <close>
      close(fds[1]);
     3d0:	fac42503          	lw	a0,-84(s0)
     3d4:	7c8000ef          	jal	b9c <close>
      wait(0);
     3d8:	4501                	li	a0,0
     3da:	7a2000ef          	jal	b7c <wait>
     3de:	b325                	j	106 <go+0x92>
        printf("grind: pipe failed\n");
     3e0:	00001517          	auipc	a0,0x1
     3e4:	ee850513          	addi	a0,a0,-280 # 12c8 <malloc+0x25c>
     3e8:	3d1000ef          	jal	fb8 <printf>
        exit(1);
     3ec:	4505                	li	a0,1
     3ee:	786000ef          	jal	b74 <exit>
        fork();
     3f2:	77a000ef          	jal	b6c <fork>
        fork();
     3f6:	776000ef          	jal	b6c <fork>
        if(write(fds[1], "x", 1) != 1)
     3fa:	4605                	li	a2,1
     3fc:	00001597          	auipc	a1,0x1
     400:	ee458593          	addi	a1,a1,-284 # 12e0 <malloc+0x274>
     404:	fac42503          	lw	a0,-84(s0)
     408:	78c000ef          	jal	b94 <write>
     40c:	4785                	li	a5,1
     40e:	00f51f63          	bne	a0,a5,42c <go+0x3b8>
        if(read(fds[0], &c, 1) != 1)
     412:	4605                	li	a2,1
     414:	fa040593          	addi	a1,s0,-96
     418:	fa842503          	lw	a0,-88(s0)
     41c:	770000ef          	jal	b8c <read>
     420:	4785                	li	a5,1
     422:	00f51c63          	bne	a0,a5,43a <go+0x3c6>
        exit(0);
     426:	4501                	li	a0,0
     428:	74c000ef          	jal	b74 <exit>
          printf("grind: pipe write failed\n");
     42c:	00001517          	auipc	a0,0x1
     430:	ebc50513          	addi	a0,a0,-324 # 12e8 <malloc+0x27c>
     434:	385000ef          	jal	fb8 <printf>
     438:	bfe9                	j	412 <go+0x39e>
          printf("grind: pipe read failed\n");
     43a:	00001517          	auipc	a0,0x1
     43e:	ece50513          	addi	a0,a0,-306 # 1308 <malloc+0x29c>
     442:	377000ef          	jal	fb8 <printf>
     446:	b7c5                	j	426 <go+0x3b2>
        printf("grind: fork failed\n");
     448:	00001517          	auipc	a0,0x1
     44c:	e3850513          	addi	a0,a0,-456 # 1280 <malloc+0x214>
     450:	369000ef          	jal	fb8 <printf>
        exit(1);
     454:	4505                	li	a0,1
     456:	71e000ef          	jal	b74 <exit>
    } else if(what == 20){
      int pid = fork();
     45a:	712000ef          	jal	b6c <fork>
      if(pid == 0){
     45e:	c519                	beqz	a0,46c <go+0x3f8>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     460:	04054f63          	bltz	a0,4be <go+0x44a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     464:	4501                	li	a0,0
     466:	716000ef          	jal	b7c <wait>
     46a:	b971                	j	106 <go+0x92>
        unlink("a");
     46c:	00001517          	auipc	a0,0x1
     470:	e2c50513          	addi	a0,a0,-468 # 1298 <malloc+0x22c>
     474:	750000ef          	jal	bc4 <unlink>
        mkdir("a");
     478:	00001517          	auipc	a0,0x1
     47c:	e2050513          	addi	a0,a0,-480 # 1298 <malloc+0x22c>
     480:	75c000ef          	jal	bdc <mkdir>
        chdir("a");
     484:	00001517          	auipc	a0,0x1
     488:	e1450513          	addi	a0,a0,-492 # 1298 <malloc+0x22c>
     48c:	758000ef          	jal	be4 <chdir>
        unlink("../a");
     490:	00001517          	auipc	a0,0x1
     494:	e9850513          	addi	a0,a0,-360 # 1328 <malloc+0x2bc>
     498:	72c000ef          	jal	bc4 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     49c:	20200593          	li	a1,514
     4a0:	00001517          	auipc	a0,0x1
     4a4:	e4050513          	addi	a0,a0,-448 # 12e0 <malloc+0x274>
     4a8:	70c000ef          	jal	bb4 <open>
        unlink("x");
     4ac:	00001517          	auipc	a0,0x1
     4b0:	e3450513          	addi	a0,a0,-460 # 12e0 <malloc+0x274>
     4b4:	710000ef          	jal	bc4 <unlink>
        exit(0);
     4b8:	4501                	li	a0,0
     4ba:	6ba000ef          	jal	b74 <exit>
        printf("grind: fork failed\n");
     4be:	00001517          	auipc	a0,0x1
     4c2:	dc250513          	addi	a0,a0,-574 # 1280 <malloc+0x214>
     4c6:	2f3000ef          	jal	fb8 <printf>
        exit(1);
     4ca:	4505                	li	a0,1
     4cc:	6a8000ef          	jal	b74 <exit>
    } else if(what == 21){
      unlink("c");
     4d0:	00001517          	auipc	a0,0x1
     4d4:	e6050513          	addi	a0,a0,-416 # 1330 <malloc+0x2c4>
     4d8:	6ec000ef          	jal	bc4 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     4dc:	20200593          	li	a1,514
     4e0:	00001517          	auipc	a0,0x1
     4e4:	e5050513          	addi	a0,a0,-432 # 1330 <malloc+0x2c4>
     4e8:	6cc000ef          	jal	bb4 <open>
     4ec:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     4ee:	04054763          	bltz	a0,53c <go+0x4c8>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     4f2:	4605                	li	a2,1
     4f4:	00001597          	auipc	a1,0x1
     4f8:	dec58593          	addi	a1,a1,-532 # 12e0 <malloc+0x274>
     4fc:	698000ef          	jal	b94 <write>
     500:	4785                	li	a5,1
     502:	04f51663          	bne	a0,a5,54e <go+0x4da>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     506:	fa840593          	addi	a1,s0,-88
     50a:	855a                	mv	a0,s6
     50c:	6c0000ef          	jal	bcc <fstat>
     510:	e921                	bnez	a0,560 <go+0x4ec>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     512:	fb843583          	ld	a1,-72(s0)
     516:	4785                	li	a5,1
     518:	04f59d63          	bne	a1,a5,572 <go+0x4fe>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     51c:	fac42583          	lw	a1,-84(s0)
     520:	0c800793          	li	a5,200
     524:	06b7e163          	bltu	a5,a1,586 <go+0x512>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     528:	855a                	mv	a0,s6
     52a:	672000ef          	jal	b9c <close>
      unlink("c");
     52e:	00001517          	auipc	a0,0x1
     532:	e0250513          	addi	a0,a0,-510 # 1330 <malloc+0x2c4>
     536:	68e000ef          	jal	bc4 <unlink>
     53a:	b6f1                	j	106 <go+0x92>
        printf("grind: create c failed\n");
     53c:	00001517          	auipc	a0,0x1
     540:	dfc50513          	addi	a0,a0,-516 # 1338 <malloc+0x2cc>
     544:	275000ef          	jal	fb8 <printf>
        exit(1);
     548:	4505                	li	a0,1
     54a:	62a000ef          	jal	b74 <exit>
        printf("grind: write c failed\n");
     54e:	00001517          	auipc	a0,0x1
     552:	e0250513          	addi	a0,a0,-510 # 1350 <malloc+0x2e4>
     556:	263000ef          	jal	fb8 <printf>
        exit(1);
     55a:	4505                	li	a0,1
     55c:	618000ef          	jal	b74 <exit>
        printf("grind: fstat failed\n");
     560:	00001517          	auipc	a0,0x1
     564:	e0850513          	addi	a0,a0,-504 # 1368 <malloc+0x2fc>
     568:	251000ef          	jal	fb8 <printf>
        exit(1);
     56c:	4505                	li	a0,1
     56e:	606000ef          	jal	b74 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     572:	2581                	sext.w	a1,a1
     574:	00001517          	auipc	a0,0x1
     578:	e0c50513          	addi	a0,a0,-500 # 1380 <malloc+0x314>
     57c:	23d000ef          	jal	fb8 <printf>
        exit(1);
     580:	4505                	li	a0,1
     582:	5f2000ef          	jal	b74 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     586:	00001517          	auipc	a0,0x1
     58a:	e2250513          	addi	a0,a0,-478 # 13a8 <malloc+0x33c>
     58e:	22b000ef          	jal	fb8 <printf>
        exit(1);
     592:	4505                	li	a0,1
     594:	5e0000ef          	jal	b74 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     598:	f9840513          	addi	a0,s0,-104
     59c:	5e8000ef          	jal	b84 <pipe>
     5a0:	0c054263          	bltz	a0,664 <go+0x5f0>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     5a4:	fa040513          	addi	a0,s0,-96
     5a8:	5dc000ef          	jal	b84 <pipe>
     5ac:	0c054663          	bltz	a0,678 <go+0x604>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     5b0:	5bc000ef          	jal	b6c <fork>
      if(pid1 == 0){
     5b4:	0c050c63          	beqz	a0,68c <go+0x618>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     5b8:	14054e63          	bltz	a0,714 <go+0x6a0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     5bc:	5b0000ef          	jal	b6c <fork>
      if(pid2 == 0){
     5c0:	16050463          	beqz	a0,728 <go+0x6b4>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     5c4:	20054263          	bltz	a0,7c8 <go+0x754>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     5c8:	f9842503          	lw	a0,-104(s0)
     5cc:	5d0000ef          	jal	b9c <close>
      close(aa[1]);
     5d0:	f9c42503          	lw	a0,-100(s0)
     5d4:	5c8000ef          	jal	b9c <close>
      close(bb[1]);
     5d8:	fa442503          	lw	a0,-92(s0)
     5dc:	5c0000ef          	jal	b9c <close>
      char buf[4] = { 0, 0, 0, 0 };
     5e0:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     5e4:	4605                	li	a2,1
     5e6:	f9040593          	addi	a1,s0,-112
     5ea:	fa042503          	lw	a0,-96(s0)
     5ee:	59e000ef          	jal	b8c <read>
      read(bb[0], buf+1, 1);
     5f2:	4605                	li	a2,1
     5f4:	f9140593          	addi	a1,s0,-111
     5f8:	fa042503          	lw	a0,-96(s0)
     5fc:	590000ef          	jal	b8c <read>
      read(bb[0], buf+2, 1);
     600:	4605                	li	a2,1
     602:	f9240593          	addi	a1,s0,-110
     606:	fa042503          	lw	a0,-96(s0)
     60a:	582000ef          	jal	b8c <read>
      close(bb[0]);
     60e:	fa042503          	lw	a0,-96(s0)
     612:	58a000ef          	jal	b9c <close>
      int st1, st2;
      wait(&st1);
     616:	f9440513          	addi	a0,s0,-108
     61a:	562000ef          	jal	b7c <wait>
      wait(&st2);
     61e:	fa840513          	addi	a0,s0,-88
     622:	55a000ef          	jal	b7c <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     626:	f9442783          	lw	a5,-108(s0)
     62a:	fa842703          	lw	a4,-88(s0)
     62e:	8fd9                	or	a5,a5,a4
     630:	eb99                	bnez	a5,646 <go+0x5d2>
     632:	00001597          	auipc	a1,0x1
     636:	e1658593          	addi	a1,a1,-490 # 1448 <malloc+0x3dc>
     63a:	f9040513          	addi	a0,s0,-112
     63e:	2ce000ef          	jal	90c <strcmp>
     642:	ac0502e3          	beqz	a0,106 <go+0x92>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     646:	f9040693          	addi	a3,s0,-112
     64a:	fa842603          	lw	a2,-88(s0)
     64e:	f9442583          	lw	a1,-108(s0)
     652:	00001517          	auipc	a0,0x1
     656:	dfe50513          	addi	a0,a0,-514 # 1450 <malloc+0x3e4>
     65a:	15f000ef          	jal	fb8 <printf>
        exit(1);
     65e:	4505                	li	a0,1
     660:	514000ef          	jal	b74 <exit>
        fprintf(2, "grind: pipe failed\n");
     664:	00001597          	auipc	a1,0x1
     668:	c6458593          	addi	a1,a1,-924 # 12c8 <malloc+0x25c>
     66c:	4509                	li	a0,2
     66e:	121000ef          	jal	f8e <fprintf>
        exit(1);
     672:	4505                	li	a0,1
     674:	500000ef          	jal	b74 <exit>
        fprintf(2, "grind: pipe failed\n");
     678:	00001597          	auipc	a1,0x1
     67c:	c5058593          	addi	a1,a1,-944 # 12c8 <malloc+0x25c>
     680:	4509                	li	a0,2
     682:	10d000ef          	jal	f8e <fprintf>
        exit(1);
     686:	4505                	li	a0,1
     688:	4ec000ef          	jal	b74 <exit>
        close(bb[0]);
     68c:	fa042503          	lw	a0,-96(s0)
     690:	50c000ef          	jal	b9c <close>
        close(bb[1]);
     694:	fa442503          	lw	a0,-92(s0)
     698:	504000ef          	jal	b9c <close>
        close(aa[0]);
     69c:	f9842503          	lw	a0,-104(s0)
     6a0:	4fc000ef          	jal	b9c <close>
        close(1);
     6a4:	4505                	li	a0,1
     6a6:	4f6000ef          	jal	b9c <close>
        if(dup(aa[1]) != 1){
     6aa:	f9c42503          	lw	a0,-100(s0)
     6ae:	53e000ef          	jal	bec <dup>
     6b2:	4785                	li	a5,1
     6b4:	00f50c63          	beq	a0,a5,6cc <go+0x658>
          fprintf(2, "grind: dup failed\n");
     6b8:	00001597          	auipc	a1,0x1
     6bc:	d1858593          	addi	a1,a1,-744 # 13d0 <malloc+0x364>
     6c0:	4509                	li	a0,2
     6c2:	0cd000ef          	jal	f8e <fprintf>
          exit(1);
     6c6:	4505                	li	a0,1
     6c8:	4ac000ef          	jal	b74 <exit>
        close(aa[1]);
     6cc:	f9c42503          	lw	a0,-100(s0)
     6d0:	4cc000ef          	jal	b9c <close>
        char *args[3] = { "echo", "hi", 0 };
     6d4:	00001797          	auipc	a5,0x1
     6d8:	d1478793          	addi	a5,a5,-748 # 13e8 <malloc+0x37c>
     6dc:	faf43423          	sd	a5,-88(s0)
     6e0:	00001797          	auipc	a5,0x1
     6e4:	d1078793          	addi	a5,a5,-752 # 13f0 <malloc+0x384>
     6e8:	faf43823          	sd	a5,-80(s0)
     6ec:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     6f0:	fa840593          	addi	a1,s0,-88
     6f4:	00001517          	auipc	a0,0x1
     6f8:	d0450513          	addi	a0,a0,-764 # 13f8 <malloc+0x38c>
     6fc:	4b0000ef          	jal	bac <exec>
        fprintf(2, "grind: echo: not found\n");
     700:	00001597          	auipc	a1,0x1
     704:	d0858593          	addi	a1,a1,-760 # 1408 <malloc+0x39c>
     708:	4509                	li	a0,2
     70a:	085000ef          	jal	f8e <fprintf>
        exit(2);
     70e:	4509                	li	a0,2
     710:	464000ef          	jal	b74 <exit>
        fprintf(2, "grind: fork failed\n");
     714:	00001597          	auipc	a1,0x1
     718:	b6c58593          	addi	a1,a1,-1172 # 1280 <malloc+0x214>
     71c:	4509                	li	a0,2
     71e:	071000ef          	jal	f8e <fprintf>
        exit(3);
     722:	450d                	li	a0,3
     724:	450000ef          	jal	b74 <exit>
        close(aa[1]);
     728:	f9c42503          	lw	a0,-100(s0)
     72c:	470000ef          	jal	b9c <close>
        close(bb[0]);
     730:	fa042503          	lw	a0,-96(s0)
     734:	468000ef          	jal	b9c <close>
        close(0);
     738:	4501                	li	a0,0
     73a:	462000ef          	jal	b9c <close>
        if(dup(aa[0]) != 0){
     73e:	f9842503          	lw	a0,-104(s0)
     742:	4aa000ef          	jal	bec <dup>
     746:	c919                	beqz	a0,75c <go+0x6e8>
          fprintf(2, "grind: dup failed\n");
     748:	00001597          	auipc	a1,0x1
     74c:	c8858593          	addi	a1,a1,-888 # 13d0 <malloc+0x364>
     750:	4509                	li	a0,2
     752:	03d000ef          	jal	f8e <fprintf>
          exit(4);
     756:	4511                	li	a0,4
     758:	41c000ef          	jal	b74 <exit>
        close(aa[0]);
     75c:	f9842503          	lw	a0,-104(s0)
     760:	43c000ef          	jal	b9c <close>
        close(1);
     764:	4505                	li	a0,1
     766:	436000ef          	jal	b9c <close>
        if(dup(bb[1]) != 1){
     76a:	fa442503          	lw	a0,-92(s0)
     76e:	47e000ef          	jal	bec <dup>
     772:	4785                	li	a5,1
     774:	00f50c63          	beq	a0,a5,78c <go+0x718>
          fprintf(2, "grind: dup failed\n");
     778:	00001597          	auipc	a1,0x1
     77c:	c5858593          	addi	a1,a1,-936 # 13d0 <malloc+0x364>
     780:	4509                	li	a0,2
     782:	00d000ef          	jal	f8e <fprintf>
          exit(5);
     786:	4515                	li	a0,5
     788:	3ec000ef          	jal	b74 <exit>
        close(bb[1]);
     78c:	fa442503          	lw	a0,-92(s0)
     790:	40c000ef          	jal	b9c <close>
        char *args[2] = { "cat", 0 };
     794:	00001797          	auipc	a5,0x1
     798:	c8c78793          	addi	a5,a5,-884 # 1420 <malloc+0x3b4>
     79c:	faf43423          	sd	a5,-88(s0)
     7a0:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     7a4:	fa840593          	addi	a1,s0,-88
     7a8:	00001517          	auipc	a0,0x1
     7ac:	c8050513          	addi	a0,a0,-896 # 1428 <malloc+0x3bc>
     7b0:	3fc000ef          	jal	bac <exec>
        fprintf(2, "grind: cat: not found\n");
     7b4:	00001597          	auipc	a1,0x1
     7b8:	c7c58593          	addi	a1,a1,-900 # 1430 <malloc+0x3c4>
     7bc:	4509                	li	a0,2
     7be:	7d0000ef          	jal	f8e <fprintf>
        exit(6);
     7c2:	4519                	li	a0,6
     7c4:	3b0000ef          	jal	b74 <exit>
        fprintf(2, "grind: fork failed\n");
     7c8:	00001597          	auipc	a1,0x1
     7cc:	ab858593          	addi	a1,a1,-1352 # 1280 <malloc+0x214>
     7d0:	4509                	li	a0,2
     7d2:	7bc000ef          	jal	f8e <fprintf>
        exit(7);
     7d6:	451d                	li	a0,7
     7d8:	39c000ef          	jal	b74 <exit>

00000000000007dc <iter>:
  }
}

void
iter()
{
     7dc:	7179                	addi	sp,sp,-48
     7de:	f406                	sd	ra,40(sp)
     7e0:	f022                	sd	s0,32(sp)
     7e2:	1800                	addi	s0,sp,48
  unlink("a");
     7e4:	00001517          	auipc	a0,0x1
     7e8:	ab450513          	addi	a0,a0,-1356 # 1298 <malloc+0x22c>
     7ec:	3d8000ef          	jal	bc4 <unlink>
  unlink("b");
     7f0:	00001517          	auipc	a0,0x1
     7f4:	a5850513          	addi	a0,a0,-1448 # 1248 <malloc+0x1dc>
     7f8:	3cc000ef          	jal	bc4 <unlink>
  
  int pid1 = fork();
     7fc:	370000ef          	jal	b6c <fork>
  if(pid1 < 0){
     800:	02054163          	bltz	a0,822 <iter+0x46>
     804:	ec26                	sd	s1,24(sp)
     806:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     808:	e905                	bnez	a0,838 <iter+0x5c>
     80a:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     80c:	00001717          	auipc	a4,0x1
     810:	7f470713          	addi	a4,a4,2036 # 2000 <rand_next>
     814:	631c                	ld	a5,0(a4)
     816:	01f7c793          	xori	a5,a5,31
     81a:	e31c                	sd	a5,0(a4)
    go(0);
     81c:	4501                	li	a0,0
     81e:	857ff0ef          	jal	74 <go>
     822:	ec26                	sd	s1,24(sp)
     824:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     826:	00001517          	auipc	a0,0x1
     82a:	a5a50513          	addi	a0,a0,-1446 # 1280 <malloc+0x214>
     82e:	78a000ef          	jal	fb8 <printf>
    exit(1);
     832:	4505                	li	a0,1
     834:	340000ef          	jal	b74 <exit>
     838:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     83a:	332000ef          	jal	b6c <fork>
     83e:	892a                	mv	s2,a0
  if(pid2 < 0){
     840:	02054063          	bltz	a0,860 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     844:	e51d                	bnez	a0,872 <iter+0x96>
    rand_next ^= 7177;
     846:	00001697          	auipc	a3,0x1
     84a:	7ba68693          	addi	a3,a3,1978 # 2000 <rand_next>
     84e:	629c                	ld	a5,0(a3)
     850:	6709                	lui	a4,0x2
     852:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x729>
     856:	8fb9                	xor	a5,a5,a4
     858:	e29c                	sd	a5,0(a3)
    go(1);
     85a:	4505                	li	a0,1
     85c:	819ff0ef          	jal	74 <go>
    printf("grind: fork failed\n");
     860:	00001517          	auipc	a0,0x1
     864:	a2050513          	addi	a0,a0,-1504 # 1280 <malloc+0x214>
     868:	750000ef          	jal	fb8 <printf>
    exit(1);
     86c:	4505                	li	a0,1
     86e:	306000ef          	jal	b74 <exit>
    exit(0);
  }

  int st1 = -1;
     872:	57fd                	li	a5,-1
     874:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     878:	fdc40513          	addi	a0,s0,-36
     87c:	300000ef          	jal	b7c <wait>
  if(st1 != 0){
     880:	fdc42783          	lw	a5,-36(s0)
     884:	eb99                	bnez	a5,89a <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     886:	57fd                	li	a5,-1
     888:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     88c:	fd840513          	addi	a0,s0,-40
     890:	2ec000ef          	jal	b7c <wait>

  exit(0);
     894:	4501                	li	a0,0
     896:	2de000ef          	jal	b74 <exit>
    kill(pid1);
     89a:	8526                	mv	a0,s1
     89c:	308000ef          	jal	ba4 <kill>
    kill(pid2);
     8a0:	854a                	mv	a0,s2
     8a2:	302000ef          	jal	ba4 <kill>
     8a6:	b7c5                	j	886 <iter+0xaa>

00000000000008a8 <main>:
}

int
main()
{
     8a8:	1101                	addi	sp,sp,-32
     8aa:	ec06                	sd	ra,24(sp)
     8ac:	e822                	sd	s0,16(sp)
     8ae:	e426                	sd	s1,8(sp)
     8b0:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    pause(20);
    rand_next += 1;
     8b2:	00001497          	auipc	s1,0x1
     8b6:	74e48493          	addi	s1,s1,1870 # 2000 <rand_next>
     8ba:	a809                	j	8cc <main+0x24>
      iter();
     8bc:	f21ff0ef          	jal	7dc <iter>
    pause(20);
     8c0:	4551                	li	a0,20
     8c2:	342000ef          	jal	c04 <pause>
    rand_next += 1;
     8c6:	609c                	ld	a5,0(s1)
     8c8:	0785                	addi	a5,a5,1
     8ca:	e09c                	sd	a5,0(s1)
    int pid = fork();
     8cc:	2a0000ef          	jal	b6c <fork>
    if(pid == 0){
     8d0:	d575                	beqz	a0,8bc <main+0x14>
    if(pid > 0){
     8d2:	fea057e3          	blez	a0,8c0 <main+0x18>
      wait(0);
     8d6:	4501                	li	a0,0
     8d8:	2a4000ef          	jal	b7c <wait>
     8dc:	b7d5                	j	8c0 <main+0x18>

00000000000008de <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     8de:	1141                	addi	sp,sp,-16
     8e0:	e406                	sd	ra,8(sp)
     8e2:	e022                	sd	s0,0(sp)
     8e4:	0800                	addi	s0,sp,16
  extern int main();
  main();
     8e6:	fc3ff0ef          	jal	8a8 <main>
  exit(0);
     8ea:	4501                	li	a0,0
     8ec:	288000ef          	jal	b74 <exit>

00000000000008f0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8f0:	1141                	addi	sp,sp,-16
     8f2:	e422                	sd	s0,8(sp)
     8f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8f6:	87aa                	mv	a5,a0
     8f8:	0585                	addi	a1,a1,1
     8fa:	0785                	addi	a5,a5,1
     8fc:	fff5c703          	lbu	a4,-1(a1)
     900:	fee78fa3          	sb	a4,-1(a5)
     904:	fb75                	bnez	a4,8f8 <strcpy+0x8>
    ;
  return os;
}
     906:	6422                	ld	s0,8(sp)
     908:	0141                	addi	sp,sp,16
     90a:	8082                	ret

000000000000090c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     90c:	1141                	addi	sp,sp,-16
     90e:	e422                	sd	s0,8(sp)
     910:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     912:	00054783          	lbu	a5,0(a0)
     916:	cb91                	beqz	a5,92a <strcmp+0x1e>
     918:	0005c703          	lbu	a4,0(a1)
     91c:	00f71763          	bne	a4,a5,92a <strcmp+0x1e>
    p++, q++;
     920:	0505                	addi	a0,a0,1
     922:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     924:	00054783          	lbu	a5,0(a0)
     928:	fbe5                	bnez	a5,918 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     92a:	0005c503          	lbu	a0,0(a1)
}
     92e:	40a7853b          	subw	a0,a5,a0
     932:	6422                	ld	s0,8(sp)
     934:	0141                	addi	sp,sp,16
     936:	8082                	ret

0000000000000938 <strlen>:

uint
strlen(const char *s)
{
     938:	1141                	addi	sp,sp,-16
     93a:	e422                	sd	s0,8(sp)
     93c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     93e:	00054783          	lbu	a5,0(a0)
     942:	cf91                	beqz	a5,95e <strlen+0x26>
     944:	0505                	addi	a0,a0,1
     946:	87aa                	mv	a5,a0
     948:	86be                	mv	a3,a5
     94a:	0785                	addi	a5,a5,1
     94c:	fff7c703          	lbu	a4,-1(a5)
     950:	ff65                	bnez	a4,948 <strlen+0x10>
     952:	40a6853b          	subw	a0,a3,a0
     956:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     958:	6422                	ld	s0,8(sp)
     95a:	0141                	addi	sp,sp,16
     95c:	8082                	ret
  for(n = 0; s[n]; n++)
     95e:	4501                	li	a0,0
     960:	bfe5                	j	958 <strlen+0x20>

0000000000000962 <memset>:

void*
memset(void *dst, int c, uint n)
{
     962:	1141                	addi	sp,sp,-16
     964:	e422                	sd	s0,8(sp)
     966:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     968:	ca19                	beqz	a2,97e <memset+0x1c>
     96a:	87aa                	mv	a5,a0
     96c:	1602                	slli	a2,a2,0x20
     96e:	9201                	srli	a2,a2,0x20
     970:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     974:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     978:	0785                	addi	a5,a5,1
     97a:	fee79de3          	bne	a5,a4,974 <memset+0x12>
  }
  return dst;
}
     97e:	6422                	ld	s0,8(sp)
     980:	0141                	addi	sp,sp,16
     982:	8082                	ret

0000000000000984 <strchr>:

char*
strchr(const char *s, char c)
{
     984:	1141                	addi	sp,sp,-16
     986:	e422                	sd	s0,8(sp)
     988:	0800                	addi	s0,sp,16
  for(; *s; s++)
     98a:	00054783          	lbu	a5,0(a0)
     98e:	cb99                	beqz	a5,9a4 <strchr+0x20>
    if(*s == c)
     990:	00f58763          	beq	a1,a5,99e <strchr+0x1a>
  for(; *s; s++)
     994:	0505                	addi	a0,a0,1
     996:	00054783          	lbu	a5,0(a0)
     99a:	fbfd                	bnez	a5,990 <strchr+0xc>
      return (char*)s;
  return 0;
     99c:	4501                	li	a0,0
}
     99e:	6422                	ld	s0,8(sp)
     9a0:	0141                	addi	sp,sp,16
     9a2:	8082                	ret
  return 0;
     9a4:	4501                	li	a0,0
     9a6:	bfe5                	j	99e <strchr+0x1a>

00000000000009a8 <gets>:

char*
gets(char *buf, int max)
{
     9a8:	711d                	addi	sp,sp,-96
     9aa:	ec86                	sd	ra,88(sp)
     9ac:	e8a2                	sd	s0,80(sp)
     9ae:	e4a6                	sd	s1,72(sp)
     9b0:	e0ca                	sd	s2,64(sp)
     9b2:	fc4e                	sd	s3,56(sp)
     9b4:	f852                	sd	s4,48(sp)
     9b6:	f456                	sd	s5,40(sp)
     9b8:	f05a                	sd	s6,32(sp)
     9ba:	ec5e                	sd	s7,24(sp)
     9bc:	1080                	addi	s0,sp,96
     9be:	8baa                	mv	s7,a0
     9c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9c2:	892a                	mv	s2,a0
     9c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9c6:	4aa9                	li	s5,10
     9c8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9ca:	89a6                	mv	s3,s1
     9cc:	2485                	addiw	s1,s1,1
     9ce:	0344d663          	bge	s1,s4,9fa <gets+0x52>
    cc = read(0, &c, 1);
     9d2:	4605                	li	a2,1
     9d4:	faf40593          	addi	a1,s0,-81
     9d8:	4501                	li	a0,0
     9da:	1b2000ef          	jal	b8c <read>
    if(cc < 1)
     9de:	00a05e63          	blez	a0,9fa <gets+0x52>
    buf[i++] = c;
     9e2:	faf44783          	lbu	a5,-81(s0)
     9e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9ea:	01578763          	beq	a5,s5,9f8 <gets+0x50>
     9ee:	0905                	addi	s2,s2,1
     9f0:	fd679de3          	bne	a5,s6,9ca <gets+0x22>
    buf[i++] = c;
     9f4:	89a6                	mv	s3,s1
     9f6:	a011                	j	9fa <gets+0x52>
     9f8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     9fa:	99de                	add	s3,s3,s7
     9fc:	00098023          	sb	zero,0(s3)
  return buf;
}
     a00:	855e                	mv	a0,s7
     a02:	60e6                	ld	ra,88(sp)
     a04:	6446                	ld	s0,80(sp)
     a06:	64a6                	ld	s1,72(sp)
     a08:	6906                	ld	s2,64(sp)
     a0a:	79e2                	ld	s3,56(sp)
     a0c:	7a42                	ld	s4,48(sp)
     a0e:	7aa2                	ld	s5,40(sp)
     a10:	7b02                	ld	s6,32(sp)
     a12:	6be2                	ld	s7,24(sp)
     a14:	6125                	addi	sp,sp,96
     a16:	8082                	ret

0000000000000a18 <stat>:

int
stat(const char *n, struct stat *st)
{
     a18:	1101                	addi	sp,sp,-32
     a1a:	ec06                	sd	ra,24(sp)
     a1c:	e822                	sd	s0,16(sp)
     a1e:	e04a                	sd	s2,0(sp)
     a20:	1000                	addi	s0,sp,32
     a22:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a24:	4581                	li	a1,0
     a26:	18e000ef          	jal	bb4 <open>
  if(fd < 0)
     a2a:	02054263          	bltz	a0,a4e <stat+0x36>
     a2e:	e426                	sd	s1,8(sp)
     a30:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a32:	85ca                	mv	a1,s2
     a34:	198000ef          	jal	bcc <fstat>
     a38:	892a                	mv	s2,a0
  close(fd);
     a3a:	8526                	mv	a0,s1
     a3c:	160000ef          	jal	b9c <close>
  return r;
     a40:	64a2                	ld	s1,8(sp)
}
     a42:	854a                	mv	a0,s2
     a44:	60e2                	ld	ra,24(sp)
     a46:	6442                	ld	s0,16(sp)
     a48:	6902                	ld	s2,0(sp)
     a4a:	6105                	addi	sp,sp,32
     a4c:	8082                	ret
    return -1;
     a4e:	597d                	li	s2,-1
     a50:	bfcd                	j	a42 <stat+0x2a>

0000000000000a52 <atoi>:

int
atoi(const char *s)
{
     a52:	1141                	addi	sp,sp,-16
     a54:	e422                	sd	s0,8(sp)
     a56:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a58:	00054683          	lbu	a3,0(a0)
     a5c:	fd06879b          	addiw	a5,a3,-48
     a60:	0ff7f793          	zext.b	a5,a5
     a64:	4625                	li	a2,9
     a66:	02f66863          	bltu	a2,a5,a96 <atoi+0x44>
     a6a:	872a                	mv	a4,a0
  n = 0;
     a6c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a6e:	0705                	addi	a4,a4,1
     a70:	0025179b          	slliw	a5,a0,0x2
     a74:	9fa9                	addw	a5,a5,a0
     a76:	0017979b          	slliw	a5,a5,0x1
     a7a:	9fb5                	addw	a5,a5,a3
     a7c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a80:	00074683          	lbu	a3,0(a4)
     a84:	fd06879b          	addiw	a5,a3,-48
     a88:	0ff7f793          	zext.b	a5,a5
     a8c:	fef671e3          	bgeu	a2,a5,a6e <atoi+0x1c>
  return n;
}
     a90:	6422                	ld	s0,8(sp)
     a92:	0141                	addi	sp,sp,16
     a94:	8082                	ret
  n = 0;
     a96:	4501                	li	a0,0
     a98:	bfe5                	j	a90 <atoi+0x3e>

0000000000000a9a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a9a:	1141                	addi	sp,sp,-16
     a9c:	e422                	sd	s0,8(sp)
     a9e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     aa0:	02b57463          	bgeu	a0,a1,ac8 <memmove+0x2e>
    while(n-- > 0)
     aa4:	00c05f63          	blez	a2,ac2 <memmove+0x28>
     aa8:	1602                	slli	a2,a2,0x20
     aaa:	9201                	srli	a2,a2,0x20
     aac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ab0:	872a                	mv	a4,a0
      *dst++ = *src++;
     ab2:	0585                	addi	a1,a1,1
     ab4:	0705                	addi	a4,a4,1
     ab6:	fff5c683          	lbu	a3,-1(a1)
     aba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     abe:	fef71ae3          	bne	a4,a5,ab2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ac2:	6422                	ld	s0,8(sp)
     ac4:	0141                	addi	sp,sp,16
     ac6:	8082                	ret
    dst += n;
     ac8:	00c50733          	add	a4,a0,a2
    src += n;
     acc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ace:	fec05ae3          	blez	a2,ac2 <memmove+0x28>
     ad2:	fff6079b          	addiw	a5,a2,-1
     ad6:	1782                	slli	a5,a5,0x20
     ad8:	9381                	srli	a5,a5,0x20
     ada:	fff7c793          	not	a5,a5
     ade:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ae0:	15fd                	addi	a1,a1,-1
     ae2:	177d                	addi	a4,a4,-1
     ae4:	0005c683          	lbu	a3,0(a1)
     ae8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     aec:	fee79ae3          	bne	a5,a4,ae0 <memmove+0x46>
     af0:	bfc9                	j	ac2 <memmove+0x28>

0000000000000af2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     af2:	1141                	addi	sp,sp,-16
     af4:	e422                	sd	s0,8(sp)
     af6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     af8:	ca05                	beqz	a2,b28 <memcmp+0x36>
     afa:	fff6069b          	addiw	a3,a2,-1
     afe:	1682                	slli	a3,a3,0x20
     b00:	9281                	srli	a3,a3,0x20
     b02:	0685                	addi	a3,a3,1
     b04:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b06:	00054783          	lbu	a5,0(a0)
     b0a:	0005c703          	lbu	a4,0(a1)
     b0e:	00e79863          	bne	a5,a4,b1e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b12:	0505                	addi	a0,a0,1
    p2++;
     b14:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b16:	fed518e3          	bne	a0,a3,b06 <memcmp+0x14>
  }
  return 0;
     b1a:	4501                	li	a0,0
     b1c:	a019                	j	b22 <memcmp+0x30>
      return *p1 - *p2;
     b1e:	40e7853b          	subw	a0,a5,a4
}
     b22:	6422                	ld	s0,8(sp)
     b24:	0141                	addi	sp,sp,16
     b26:	8082                	ret
  return 0;
     b28:	4501                	li	a0,0
     b2a:	bfe5                	j	b22 <memcmp+0x30>

0000000000000b2c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b2c:	1141                	addi	sp,sp,-16
     b2e:	e406                	sd	ra,8(sp)
     b30:	e022                	sd	s0,0(sp)
     b32:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b34:	f67ff0ef          	jal	a9a <memmove>
}
     b38:	60a2                	ld	ra,8(sp)
     b3a:	6402                	ld	s0,0(sp)
     b3c:	0141                	addi	sp,sp,16
     b3e:	8082                	ret

0000000000000b40 <sbrk>:

char *
sbrk(int n) {
     b40:	1141                	addi	sp,sp,-16
     b42:	e406                	sd	ra,8(sp)
     b44:	e022                	sd	s0,0(sp)
     b46:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     b48:	4585                	li	a1,1
     b4a:	0b2000ef          	jal	bfc <sys_sbrk>
}
     b4e:	60a2                	ld	ra,8(sp)
     b50:	6402                	ld	s0,0(sp)
     b52:	0141                	addi	sp,sp,16
     b54:	8082                	ret

0000000000000b56 <sbrklazy>:

char *
sbrklazy(int n) {
     b56:	1141                	addi	sp,sp,-16
     b58:	e406                	sd	ra,8(sp)
     b5a:	e022                	sd	s0,0(sp)
     b5c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     b5e:	4589                	li	a1,2
     b60:	09c000ef          	jal	bfc <sys_sbrk>
}
     b64:	60a2                	ld	ra,8(sp)
     b66:	6402                	ld	s0,0(sp)
     b68:	0141                	addi	sp,sp,16
     b6a:	8082                	ret

0000000000000b6c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b6c:	4885                	li	a7,1
 ecall
     b6e:	00000073          	ecall
 ret
     b72:	8082                	ret

0000000000000b74 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b74:	4889                	li	a7,2
 ecall
     b76:	00000073          	ecall
 ret
     b7a:	8082                	ret

0000000000000b7c <wait>:
.global wait
wait:
 li a7, SYS_wait
     b7c:	488d                	li	a7,3
 ecall
     b7e:	00000073          	ecall
 ret
     b82:	8082                	ret

0000000000000b84 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b84:	4891                	li	a7,4
 ecall
     b86:	00000073          	ecall
 ret
     b8a:	8082                	ret

0000000000000b8c <read>:
.global read
read:
 li a7, SYS_read
     b8c:	4895                	li	a7,5
 ecall
     b8e:	00000073          	ecall
 ret
     b92:	8082                	ret

0000000000000b94 <write>:
.global write
write:
 li a7, SYS_write
     b94:	48c1                	li	a7,16
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <close>:
.global close
close:
 li a7, SYS_close
     b9c:	48d5                	li	a7,21
 ecall
     b9e:	00000073          	ecall
 ret
     ba2:	8082                	ret

0000000000000ba4 <kill>:
.global kill
kill:
 li a7, SYS_kill
     ba4:	4899                	li	a7,6
 ecall
     ba6:	00000073          	ecall
 ret
     baa:	8082                	ret

0000000000000bac <exec>:
.global exec
exec:
 li a7, SYS_exec
     bac:	489d                	li	a7,7
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <open>:
.global open
open:
 li a7, SYS_open
     bb4:	48bd                	li	a7,15
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bbc:	48c5                	li	a7,17
 ecall
     bbe:	00000073          	ecall
 ret
     bc2:	8082                	ret

0000000000000bc4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bc4:	48c9                	li	a7,18
 ecall
     bc6:	00000073          	ecall
 ret
     bca:	8082                	ret

0000000000000bcc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bcc:	48a1                	li	a7,8
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <link>:
.global link
link:
 li a7, SYS_link
     bd4:	48cd                	li	a7,19
 ecall
     bd6:	00000073          	ecall
 ret
     bda:	8082                	ret

0000000000000bdc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bdc:	48d1                	li	a7,20
 ecall
     bde:	00000073          	ecall
 ret
     be2:	8082                	ret

0000000000000be4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     be4:	48a5                	li	a7,9
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <dup>:
.global dup
dup:
 li a7, SYS_dup
     bec:	48a9                	li	a7,10
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bf4:	48ad                	li	a7,11
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     bfc:	48b1                	li	a7,12
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <pause>:
.global pause
pause:
 li a7, SYS_pause
     c04:	48b5                	li	a7,13
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c0c:	48b9                	li	a7,14
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <hello>:
.global hello
hello:
 li a7, SYS_hello
     c14:	48dd                	li	a7,23
 ecall
     c16:	00000073          	ecall
 ret
     c1a:	8082                	ret

0000000000000c1c <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
     c1c:	48d9                	li	a7,22
 ecall
     c1e:	00000073          	ecall
 ret
     c22:	8082                	ret

0000000000000c24 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c24:	1101                	addi	sp,sp,-32
     c26:	ec06                	sd	ra,24(sp)
     c28:	e822                	sd	s0,16(sp)
     c2a:	1000                	addi	s0,sp,32
     c2c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c30:	4605                	li	a2,1
     c32:	fef40593          	addi	a1,s0,-17
     c36:	f5fff0ef          	jal	b94 <write>
}
     c3a:	60e2                	ld	ra,24(sp)
     c3c:	6442                	ld	s0,16(sp)
     c3e:	6105                	addi	sp,sp,32
     c40:	8082                	ret

0000000000000c42 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     c42:	715d                	addi	sp,sp,-80
     c44:	e486                	sd	ra,72(sp)
     c46:	e0a2                	sd	s0,64(sp)
     c48:	fc26                	sd	s1,56(sp)
     c4a:	0880                	addi	s0,sp,80
     c4c:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c4e:	c299                	beqz	a3,c54 <printint+0x12>
     c50:	0805c963          	bltz	a1,ce2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c54:	2581                	sext.w	a1,a1
  neg = 0;
     c56:	4881                	li	a7,0
     c58:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
     c5c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c5e:	2601                	sext.w	a2,a2
     c60:	00001517          	auipc	a0,0x1
     c64:	88050513          	addi	a0,a0,-1920 # 14e0 <digits>
     c68:	883a                	mv	a6,a4
     c6a:	2705                	addiw	a4,a4,1
     c6c:	02c5f7bb          	remuw	a5,a1,a2
     c70:	1782                	slli	a5,a5,0x20
     c72:	9381                	srli	a5,a5,0x20
     c74:	97aa                	add	a5,a5,a0
     c76:	0007c783          	lbu	a5,0(a5)
     c7a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c7e:	0005879b          	sext.w	a5,a1
     c82:	02c5d5bb          	divuw	a1,a1,a2
     c86:	0685                	addi	a3,a3,1
     c88:	fec7f0e3          	bgeu	a5,a2,c68 <printint+0x26>
  if(neg)
     c8c:	00088c63          	beqz	a7,ca4 <printint+0x62>
    buf[i++] = '-';
     c90:	fd070793          	addi	a5,a4,-48
     c94:	00878733          	add	a4,a5,s0
     c98:	02d00793          	li	a5,45
     c9c:	fef70423          	sb	a5,-24(a4)
     ca0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     ca4:	02e05a63          	blez	a4,cd8 <printint+0x96>
     ca8:	f84a                	sd	s2,48(sp)
     caa:	f44e                	sd	s3,40(sp)
     cac:	fb840793          	addi	a5,s0,-72
     cb0:	00e78933          	add	s2,a5,a4
     cb4:	fff78993          	addi	s3,a5,-1
     cb8:	99ba                	add	s3,s3,a4
     cba:	377d                	addiw	a4,a4,-1
     cbc:	1702                	slli	a4,a4,0x20
     cbe:	9301                	srli	a4,a4,0x20
     cc0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cc4:	fff94583          	lbu	a1,-1(s2)
     cc8:	8526                	mv	a0,s1
     cca:	f5bff0ef          	jal	c24 <putc>
  while(--i >= 0)
     cce:	197d                	addi	s2,s2,-1
     cd0:	ff391ae3          	bne	s2,s3,cc4 <printint+0x82>
     cd4:	7942                	ld	s2,48(sp)
     cd6:	79a2                	ld	s3,40(sp)
}
     cd8:	60a6                	ld	ra,72(sp)
     cda:	6406                	ld	s0,64(sp)
     cdc:	74e2                	ld	s1,56(sp)
     cde:	6161                	addi	sp,sp,80
     ce0:	8082                	ret
    x = -xx;
     ce2:	40b005bb          	negw	a1,a1
    neg = 1;
     ce6:	4885                	li	a7,1
    x = -xx;
     ce8:	bf85                	j	c58 <printint+0x16>

0000000000000cea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cea:	711d                	addi	sp,sp,-96
     cec:	ec86                	sd	ra,88(sp)
     cee:	e8a2                	sd	s0,80(sp)
     cf0:	e0ca                	sd	s2,64(sp)
     cf2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cf4:	0005c903          	lbu	s2,0(a1)
     cf8:	28090663          	beqz	s2,f84 <vprintf+0x29a>
     cfc:	e4a6                	sd	s1,72(sp)
     cfe:	fc4e                	sd	s3,56(sp)
     d00:	f852                	sd	s4,48(sp)
     d02:	f456                	sd	s5,40(sp)
     d04:	f05a                	sd	s6,32(sp)
     d06:	ec5e                	sd	s7,24(sp)
     d08:	e862                	sd	s8,16(sp)
     d0a:	e466                	sd	s9,8(sp)
     d0c:	8b2a                	mv	s6,a0
     d0e:	8a2e                	mv	s4,a1
     d10:	8bb2                	mv	s7,a2
  state = 0;
     d12:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d14:	4481                	li	s1,0
     d16:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d18:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d1c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d20:	06c00c93          	li	s9,108
     d24:	a005                	j	d44 <vprintf+0x5a>
        putc(fd, c0);
     d26:	85ca                	mv	a1,s2
     d28:	855a                	mv	a0,s6
     d2a:	efbff0ef          	jal	c24 <putc>
     d2e:	a019                	j	d34 <vprintf+0x4a>
    } else if(state == '%'){
     d30:	03598263          	beq	s3,s5,d54 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     d34:	2485                	addiw	s1,s1,1
     d36:	8726                	mv	a4,s1
     d38:	009a07b3          	add	a5,s4,s1
     d3c:	0007c903          	lbu	s2,0(a5)
     d40:	22090a63          	beqz	s2,f74 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
     d44:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d48:	fe0994e3          	bnez	s3,d30 <vprintf+0x46>
      if(c0 == '%'){
     d4c:	fd579de3          	bne	a5,s5,d26 <vprintf+0x3c>
        state = '%';
     d50:	89be                	mv	s3,a5
     d52:	b7cd                	j	d34 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     d54:	00ea06b3          	add	a3,s4,a4
     d58:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     d5c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     d5e:	c681                	beqz	a3,d66 <vprintf+0x7c>
     d60:	9752                	add	a4,a4,s4
     d62:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     d66:	05878363          	beq	a5,s8,dac <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     d6a:	05978d63          	beq	a5,s9,dc4 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d6e:	07500713          	li	a4,117
     d72:	0ee78763          	beq	a5,a4,e60 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     d76:	07800713          	li	a4,120
     d7a:	12e78963          	beq	a5,a4,eac <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     d7e:	07000713          	li	a4,112
     d82:	14e78e63          	beq	a5,a4,ede <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     d86:	06300713          	li	a4,99
     d8a:	18e78e63          	beq	a5,a4,f26 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     d8e:	07300713          	li	a4,115
     d92:	1ae78463          	beq	a5,a4,f3a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     d96:	02500713          	li	a4,37
     d9a:	04e79563          	bne	a5,a4,de4 <vprintf+0xfa>
        putc(fd, '%');
     d9e:	02500593          	li	a1,37
     da2:	855a                	mv	a0,s6
     da4:	e81ff0ef          	jal	c24 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     da8:	4981                	li	s3,0
     daa:	b769                	j	d34 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     dac:	008b8913          	addi	s2,s7,8
     db0:	4685                	li	a3,1
     db2:	4629                	li	a2,10
     db4:	000ba583          	lw	a1,0(s7)
     db8:	855a                	mv	a0,s6
     dba:	e89ff0ef          	jal	c42 <printint>
     dbe:	8bca                	mv	s7,s2
      state = 0;
     dc0:	4981                	li	s3,0
     dc2:	bf8d                	j	d34 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     dc4:	06400793          	li	a5,100
     dc8:	02f68963          	beq	a3,a5,dfa <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     dcc:	06c00793          	li	a5,108
     dd0:	04f68263          	beq	a3,a5,e14 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
     dd4:	07500793          	li	a5,117
     dd8:	0af68063          	beq	a3,a5,e78 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
     ddc:	07800793          	li	a5,120
     de0:	0ef68263          	beq	a3,a5,ec4 <vprintf+0x1da>
        putc(fd, '%');
     de4:	02500593          	li	a1,37
     de8:	855a                	mv	a0,s6
     dea:	e3bff0ef          	jal	c24 <putc>
        putc(fd, c0);
     dee:	85ca                	mv	a1,s2
     df0:	855a                	mv	a0,s6
     df2:	e33ff0ef          	jal	c24 <putc>
      state = 0;
     df6:	4981                	li	s3,0
     df8:	bf35                	j	d34 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     dfa:	008b8913          	addi	s2,s7,8
     dfe:	4685                	li	a3,1
     e00:	4629                	li	a2,10
     e02:	000bb583          	ld	a1,0(s7)
     e06:	855a                	mv	a0,s6
     e08:	e3bff0ef          	jal	c42 <printint>
        i += 1;
     e0c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e0e:	8bca                	mv	s7,s2
      state = 0;
     e10:	4981                	li	s3,0
        i += 1;
     e12:	b70d                	j	d34 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e14:	06400793          	li	a5,100
     e18:	02f60763          	beq	a2,a5,e46 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e1c:	07500793          	li	a5,117
     e20:	06f60963          	beq	a2,a5,e92 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e24:	07800793          	li	a5,120
     e28:	faf61ee3          	bne	a2,a5,de4 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e2c:	008b8913          	addi	s2,s7,8
     e30:	4681                	li	a3,0
     e32:	4641                	li	a2,16
     e34:	000bb583          	ld	a1,0(s7)
     e38:	855a                	mv	a0,s6
     e3a:	e09ff0ef          	jal	c42 <printint>
        i += 2;
     e3e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e40:	8bca                	mv	s7,s2
      state = 0;
     e42:	4981                	li	s3,0
        i += 2;
     e44:	bdc5                	j	d34 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e46:	008b8913          	addi	s2,s7,8
     e4a:	4685                	li	a3,1
     e4c:	4629                	li	a2,10
     e4e:	000bb583          	ld	a1,0(s7)
     e52:	855a                	mv	a0,s6
     e54:	defff0ef          	jal	c42 <printint>
        i += 2;
     e58:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e5a:	8bca                	mv	s7,s2
      state = 0;
     e5c:	4981                	li	s3,0
        i += 2;
     e5e:	bdd9                	j	d34 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     e60:	008b8913          	addi	s2,s7,8
     e64:	4681                	li	a3,0
     e66:	4629                	li	a2,10
     e68:	000be583          	lwu	a1,0(s7)
     e6c:	855a                	mv	a0,s6
     e6e:	dd5ff0ef          	jal	c42 <printint>
     e72:	8bca                	mv	s7,s2
      state = 0;
     e74:	4981                	li	s3,0
     e76:	bd7d                	j	d34 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e78:	008b8913          	addi	s2,s7,8
     e7c:	4681                	li	a3,0
     e7e:	4629                	li	a2,10
     e80:	000bb583          	ld	a1,0(s7)
     e84:	855a                	mv	a0,s6
     e86:	dbdff0ef          	jal	c42 <printint>
        i += 1;
     e8a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     e8c:	8bca                	mv	s7,s2
      state = 0;
     e8e:	4981                	li	s3,0
        i += 1;
     e90:	b555                	j	d34 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e92:	008b8913          	addi	s2,s7,8
     e96:	4681                	li	a3,0
     e98:	4629                	li	a2,10
     e9a:	000bb583          	ld	a1,0(s7)
     e9e:	855a                	mv	a0,s6
     ea0:	da3ff0ef          	jal	c42 <printint>
        i += 2;
     ea4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     ea6:	8bca                	mv	s7,s2
      state = 0;
     ea8:	4981                	li	s3,0
        i += 2;
     eaa:	b569                	j	d34 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     eac:	008b8913          	addi	s2,s7,8
     eb0:	4681                	li	a3,0
     eb2:	4641                	li	a2,16
     eb4:	000be583          	lwu	a1,0(s7)
     eb8:	855a                	mv	a0,s6
     eba:	d89ff0ef          	jal	c42 <printint>
     ebe:	8bca                	mv	s7,s2
      state = 0;
     ec0:	4981                	li	s3,0
     ec2:	bd8d                	j	d34 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ec4:	008b8913          	addi	s2,s7,8
     ec8:	4681                	li	a3,0
     eca:	4641                	li	a2,16
     ecc:	000bb583          	ld	a1,0(s7)
     ed0:	855a                	mv	a0,s6
     ed2:	d71ff0ef          	jal	c42 <printint>
        i += 1;
     ed6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     ed8:	8bca                	mv	s7,s2
      state = 0;
     eda:	4981                	li	s3,0
        i += 1;
     edc:	bda1                	j	d34 <vprintf+0x4a>
     ede:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     ee0:	008b8d13          	addi	s10,s7,8
     ee4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     ee8:	03000593          	li	a1,48
     eec:	855a                	mv	a0,s6
     eee:	d37ff0ef          	jal	c24 <putc>
  putc(fd, 'x');
     ef2:	07800593          	li	a1,120
     ef6:	855a                	mv	a0,s6
     ef8:	d2dff0ef          	jal	c24 <putc>
     efc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     efe:	00000b97          	auipc	s7,0x0
     f02:	5e2b8b93          	addi	s7,s7,1506 # 14e0 <digits>
     f06:	03c9d793          	srli	a5,s3,0x3c
     f0a:	97de                	add	a5,a5,s7
     f0c:	0007c583          	lbu	a1,0(a5)
     f10:	855a                	mv	a0,s6
     f12:	d13ff0ef          	jal	c24 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f16:	0992                	slli	s3,s3,0x4
     f18:	397d                	addiw	s2,s2,-1
     f1a:	fe0916e3          	bnez	s2,f06 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
     f1e:	8bea                	mv	s7,s10
      state = 0;
     f20:	4981                	li	s3,0
     f22:	6d02                	ld	s10,0(sp)
     f24:	bd01                	j	d34 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
     f26:	008b8913          	addi	s2,s7,8
     f2a:	000bc583          	lbu	a1,0(s7)
     f2e:	855a                	mv	a0,s6
     f30:	cf5ff0ef          	jal	c24 <putc>
     f34:	8bca                	mv	s7,s2
      state = 0;
     f36:	4981                	li	s3,0
     f38:	bbf5                	j	d34 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
     f3a:	008b8993          	addi	s3,s7,8
     f3e:	000bb903          	ld	s2,0(s7)
     f42:	00090f63          	beqz	s2,f60 <vprintf+0x276>
        for(; *s; s++)
     f46:	00094583          	lbu	a1,0(s2)
     f4a:	c195                	beqz	a1,f6e <vprintf+0x284>
          putc(fd, *s);
     f4c:	855a                	mv	a0,s6
     f4e:	cd7ff0ef          	jal	c24 <putc>
        for(; *s; s++)
     f52:	0905                	addi	s2,s2,1
     f54:	00094583          	lbu	a1,0(s2)
     f58:	f9f5                	bnez	a1,f4c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
     f5a:	8bce                	mv	s7,s3
      state = 0;
     f5c:	4981                	li	s3,0
     f5e:	bbd9                	j	d34 <vprintf+0x4a>
          s = "(null)";
     f60:	00000917          	auipc	s2,0x0
     f64:	51890913          	addi	s2,s2,1304 # 1478 <malloc+0x40c>
        for(; *s; s++)
     f68:	02800593          	li	a1,40
     f6c:	b7c5                	j	f4c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
     f6e:	8bce                	mv	s7,s3
      state = 0;
     f70:	4981                	li	s3,0
     f72:	b3c9                	j	d34 <vprintf+0x4a>
     f74:	64a6                	ld	s1,72(sp)
     f76:	79e2                	ld	s3,56(sp)
     f78:	7a42                	ld	s4,48(sp)
     f7a:	7aa2                	ld	s5,40(sp)
     f7c:	7b02                	ld	s6,32(sp)
     f7e:	6be2                	ld	s7,24(sp)
     f80:	6c42                	ld	s8,16(sp)
     f82:	6ca2                	ld	s9,8(sp)
    }
  }
}
     f84:	60e6                	ld	ra,88(sp)
     f86:	6446                	ld	s0,80(sp)
     f88:	6906                	ld	s2,64(sp)
     f8a:	6125                	addi	sp,sp,96
     f8c:	8082                	ret

0000000000000f8e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f8e:	715d                	addi	sp,sp,-80
     f90:	ec06                	sd	ra,24(sp)
     f92:	e822                	sd	s0,16(sp)
     f94:	1000                	addi	s0,sp,32
     f96:	e010                	sd	a2,0(s0)
     f98:	e414                	sd	a3,8(s0)
     f9a:	e818                	sd	a4,16(s0)
     f9c:	ec1c                	sd	a5,24(s0)
     f9e:	03043023          	sd	a6,32(s0)
     fa2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fa6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     faa:	8622                	mv	a2,s0
     fac:	d3fff0ef          	jal	cea <vprintf>
}
     fb0:	60e2                	ld	ra,24(sp)
     fb2:	6442                	ld	s0,16(sp)
     fb4:	6161                	addi	sp,sp,80
     fb6:	8082                	ret

0000000000000fb8 <printf>:

void
printf(const char *fmt, ...)
{
     fb8:	711d                	addi	sp,sp,-96
     fba:	ec06                	sd	ra,24(sp)
     fbc:	e822                	sd	s0,16(sp)
     fbe:	1000                	addi	s0,sp,32
     fc0:	e40c                	sd	a1,8(s0)
     fc2:	e810                	sd	a2,16(s0)
     fc4:	ec14                	sd	a3,24(s0)
     fc6:	f018                	sd	a4,32(s0)
     fc8:	f41c                	sd	a5,40(s0)
     fca:	03043823          	sd	a6,48(s0)
     fce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     fd2:	00840613          	addi	a2,s0,8
     fd6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     fda:	85aa                	mv	a1,a0
     fdc:	4505                	li	a0,1
     fde:	d0dff0ef          	jal	cea <vprintf>
}
     fe2:	60e2                	ld	ra,24(sp)
     fe4:	6442                	ld	s0,16(sp)
     fe6:	6125                	addi	sp,sp,96
     fe8:	8082                	ret

0000000000000fea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     fea:	1141                	addi	sp,sp,-16
     fec:	e422                	sd	s0,8(sp)
     fee:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     ff0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ff4:	00001797          	auipc	a5,0x1
     ff8:	01c7b783          	ld	a5,28(a5) # 2010 <freep>
     ffc:	a02d                	j	1026 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     ffe:	4618                	lw	a4,8(a2)
    1000:	9f2d                	addw	a4,a4,a1
    1002:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1006:	6398                	ld	a4,0(a5)
    1008:	6310                	ld	a2,0(a4)
    100a:	a83d                	j	1048 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    100c:	ff852703          	lw	a4,-8(a0)
    1010:	9f31                	addw	a4,a4,a2
    1012:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1014:	ff053683          	ld	a3,-16(a0)
    1018:	a091                	j	105c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    101a:	6398                	ld	a4,0(a5)
    101c:	00e7e463          	bltu	a5,a4,1024 <free+0x3a>
    1020:	00e6ea63          	bltu	a3,a4,1034 <free+0x4a>
{
    1024:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1026:	fed7fae3          	bgeu	a5,a3,101a <free+0x30>
    102a:	6398                	ld	a4,0(a5)
    102c:	00e6e463          	bltu	a3,a4,1034 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1030:	fee7eae3          	bltu	a5,a4,1024 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1034:	ff852583          	lw	a1,-8(a0)
    1038:	6390                	ld	a2,0(a5)
    103a:	02059813          	slli	a6,a1,0x20
    103e:	01c85713          	srli	a4,a6,0x1c
    1042:	9736                	add	a4,a4,a3
    1044:	fae60de3          	beq	a2,a4,ffe <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1048:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    104c:	4790                	lw	a2,8(a5)
    104e:	02061593          	slli	a1,a2,0x20
    1052:	01c5d713          	srli	a4,a1,0x1c
    1056:	973e                	add	a4,a4,a5
    1058:	fae68ae3          	beq	a3,a4,100c <free+0x22>
    p->s.ptr = bp->s.ptr;
    105c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    105e:	00001717          	auipc	a4,0x1
    1062:	faf73923          	sd	a5,-78(a4) # 2010 <freep>
}
    1066:	6422                	ld	s0,8(sp)
    1068:	0141                	addi	sp,sp,16
    106a:	8082                	ret

000000000000106c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    106c:	7139                	addi	sp,sp,-64
    106e:	fc06                	sd	ra,56(sp)
    1070:	f822                	sd	s0,48(sp)
    1072:	f426                	sd	s1,40(sp)
    1074:	ec4e                	sd	s3,24(sp)
    1076:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1078:	02051493          	slli	s1,a0,0x20
    107c:	9081                	srli	s1,s1,0x20
    107e:	04bd                	addi	s1,s1,15
    1080:	8091                	srli	s1,s1,0x4
    1082:	0014899b          	addiw	s3,s1,1
    1086:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1088:	00001517          	auipc	a0,0x1
    108c:	f8853503          	ld	a0,-120(a0) # 2010 <freep>
    1090:	c915                	beqz	a0,10c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1092:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1094:	4798                	lw	a4,8(a5)
    1096:	08977a63          	bgeu	a4,s1,112a <malloc+0xbe>
    109a:	f04a                	sd	s2,32(sp)
    109c:	e852                	sd	s4,16(sp)
    109e:	e456                	sd	s5,8(sp)
    10a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    10a2:	8a4e                	mv	s4,s3
    10a4:	0009871b          	sext.w	a4,s3
    10a8:	6685                	lui	a3,0x1
    10aa:	00d77363          	bgeu	a4,a3,10b0 <malloc+0x44>
    10ae:	6a05                	lui	s4,0x1
    10b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10b8:	00001917          	auipc	s2,0x1
    10bc:	f5890913          	addi	s2,s2,-168 # 2010 <freep>
  if(p == SBRK_ERROR)
    10c0:	5afd                	li	s5,-1
    10c2:	a081                	j	1102 <malloc+0x96>
    10c4:	f04a                	sd	s2,32(sp)
    10c6:	e852                	sd	s4,16(sp)
    10c8:	e456                	sd	s5,8(sp)
    10ca:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    10cc:	00001797          	auipc	a5,0x1
    10d0:	33c78793          	addi	a5,a5,828 # 2408 <base>
    10d4:	00001717          	auipc	a4,0x1
    10d8:	f2f73e23          	sd	a5,-196(a4) # 2010 <freep>
    10dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    10de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    10e2:	b7c1                	j	10a2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    10e4:	6398                	ld	a4,0(a5)
    10e6:	e118                	sd	a4,0(a0)
    10e8:	a8a9                	j	1142 <malloc+0xd6>
  hp->s.size = nu;
    10ea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    10ee:	0541                	addi	a0,a0,16
    10f0:	efbff0ef          	jal	fea <free>
  return freep;
    10f4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    10f8:	c12d                	beqz	a0,115a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10fc:	4798                	lw	a4,8(a5)
    10fe:	02977263          	bgeu	a4,s1,1122 <malloc+0xb6>
    if(p == freep)
    1102:	00093703          	ld	a4,0(s2)
    1106:	853e                	mv	a0,a5
    1108:	fef719e3          	bne	a4,a5,10fa <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    110c:	8552                	mv	a0,s4
    110e:	a33ff0ef          	jal	b40 <sbrk>
  if(p == SBRK_ERROR)
    1112:	fd551ce3          	bne	a0,s5,10ea <malloc+0x7e>
        return 0;
    1116:	4501                	li	a0,0
    1118:	7902                	ld	s2,32(sp)
    111a:	6a42                	ld	s4,16(sp)
    111c:	6aa2                	ld	s5,8(sp)
    111e:	6b02                	ld	s6,0(sp)
    1120:	a03d                	j	114e <malloc+0xe2>
    1122:	7902                	ld	s2,32(sp)
    1124:	6a42                	ld	s4,16(sp)
    1126:	6aa2                	ld	s5,8(sp)
    1128:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    112a:	fae48de3          	beq	s1,a4,10e4 <malloc+0x78>
        p->s.size -= nunits;
    112e:	4137073b          	subw	a4,a4,s3
    1132:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1134:	02071693          	slli	a3,a4,0x20
    1138:	01c6d713          	srli	a4,a3,0x1c
    113c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    113e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1142:	00001717          	auipc	a4,0x1
    1146:	eca73723          	sd	a0,-306(a4) # 2010 <freep>
      return (void*)(p + 1);
    114a:	01078513          	addi	a0,a5,16
  }
}
    114e:	70e2                	ld	ra,56(sp)
    1150:	7442                	ld	s0,48(sp)
    1152:	74a2                	ld	s1,40(sp)
    1154:	69e2                	ld	s3,24(sp)
    1156:	6121                	addi	sp,sp,64
    1158:	8082                	ret
    115a:	7902                	ld	s2,32(sp)
    115c:	6a42                	ld	s4,16(sp)
    115e:	6aa2                	ld	s5,8(sp)
    1160:	6b02                	ld	s6,0(sp)
    1162:	b7f5                	j	114e <malloc+0xe2>
