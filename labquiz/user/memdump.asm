
user/_memdump:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <hexval>:
    }
  }
}

int hexval(char c)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  if (c >= '0' && c <= '9')
   6:	fd05079b          	addiw	a5,a0,-48
   a:	0ff7f793          	zext.b	a5,a5
   e:	4725                	li	a4,9
  10:	02f77563          	bgeu	a4,a5,3a <hexval+0x3a>
    return c - '0';
  if (c >= 'a' && c <= 'f')
  14:	f9f5079b          	addiw	a5,a0,-97
  18:	0ff7f793          	zext.b	a5,a5
  1c:	4715                	li	a4,5
  1e:	02f77163          	bgeu	a4,a5,40 <hexval+0x40>
    return c - 'a' + 10;
  if (c >= 'A' && c <= 'F')
  22:	fbf5079b          	addiw	a5,a0,-65
  26:	0ff7f793          	zext.b	a5,a5
  2a:	4715                	li	a4,5
  2c:	00f76d63          	bltu	a4,a5,46 <hexval+0x46>
    return c - 'A' + 10;
  30:	fc95051b          	addiw	a0,a0,-55
  return -1; // invalid character
  34:	6422                	ld	s0,8(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret
    return c - '0';
  3a:	fd05051b          	addiw	a0,a0,-48
  3e:	bfdd                	j	34 <hexval+0x34>
    return c - 'a' + 10;
  40:	fa95051b          	addiw	a0,a0,-87
  44:	bfc5                	j	34 <hexval+0x34>
  return -1; // invalid character
  46:	557d                	li	a0,-1
  48:	b7f5                	j	34 <hexval+0x34>

000000000000004a <memdump>:
{
  4a:	711d                	addi	sp,sp,-96
  4c:	ec86                	sd	ra,88(sp)
  4e:	e8a2                	sd	s0,80(sp)
  50:	e0ca                	sd	s2,64(sp)
  52:	1080                	addi	s0,sp,96
  54:	892e                	mv	s2,a1
  for (int i = 0; fmt[i] != '\0'; i++)
  56:	00054583          	lbu	a1,0(a0)
  5a:	14058f63          	beqz	a1,1b8 <memdump+0x16e>
  5e:	e4a6                	sd	s1,72(sp)
  60:	fc4e                	sd	s3,56(sp)
  62:	f852                	sd	s4,48(sp)
  64:	f456                	sd	s5,40(sp)
  66:	f05a                	sd	s6,32(sp)
  68:	ec5e                	sd	s7,24(sp)
  6a:	00150a13          	addi	s4,a0,1
    switch (fmt[i])
  6e:	02000b13          	li	s6,32
  72:	00001a97          	auipc	s5,0x1
  76:	c7ea8a93          	addi	s5,s5,-898 # cf0 <malloc+0x224>
  7a:	a839                	j	98 <memdump+0x4e>
      printf("%d\n", *((int *)data)); // since data is char*, we need to cast it to int* to dereference as int
  7c:	00092583          	lw	a1,0(s2)
  80:	00001517          	auipc	a0,0x1
  84:	b5050513          	addi	a0,a0,-1200 # bd0 <malloc+0x104>
  88:	191000ef          	jal	a18 <printf>
      data += sizeof(int);            // adds 4 bytes into data buffer, since data is a char*, when we do data + sizeof(int), it moves forward by 4 in the array
  8c:	0911                	addi	s2,s2,4
  for (int i = 0; fmt[i] != '\0'; i++)
  8e:	0a05                	addi	s4,s4,1
  90:	fffa4583          	lbu	a1,-1(s4)
  94:	12058763          	beqz	a1,1c2 <memdump+0x178>
    switch (fmt[i])
  98:	fad5879b          	addiw	a5,a1,-83
  9c:	0ff7f713          	zext.b	a4,a5
  a0:	10eb6063          	bltu	s6,a4,1a0 <memdump+0x156>
  a4:	00271793          	slli	a5,a4,0x2
  a8:	97d6                	add	a5,a5,s5
  aa:	439c                	lw	a5,0(a5)
  ac:	97d6                	add	a5,a5,s5
  ae:	8782                	jr	a5
  b0:	00790493          	addi	s1,s2,7
  b4:	8bca                	mv	s7,s2
        printf("%x", *((unsigned char *)data + j)); // + j ensures that it loops through 8 bytes of data (hex)
  b6:	00001997          	auipc	s3,0x1
  ba:	b2298993          	addi	s3,s3,-1246 # bd8 <malloc+0x10c>
  be:	0004c583          	lbu	a1,0(s1)
  c2:	854e                	mv	a0,s3
  c4:	155000ef          	jal	a18 <printf>
      for (int j = sizeof(void *) - 1; j >= 0; j--) // loop backwards to print in big-endian format
  c8:	87a6                	mv	a5,s1
  ca:	14fd                	addi	s1,s1,-1
  cc:	ff7799e3          	bne	a5,s7,be <memdump+0x74>
      printf("\n");
  d0:	00001517          	auipc	a0,0x1
  d4:	b1050513          	addi	a0,a0,-1264 # be0 <malloc+0x114>
  d8:	141000ef          	jal	a18 <printf>
      data += sizeof(void *); // void* is 8 bytes, and p requires us to move data pointer by 8 bytes
  dc:	0921                	addi	s2,s2,8
      break;
  de:	bf45                	j	8e <memdump+0x44>
      printf("%d\n", *((short *)data));
  e0:	00091583          	lh	a1,0(s2)
  e4:	00001517          	auipc	a0,0x1
  e8:	aec50513          	addi	a0,a0,-1300 # bd0 <malloc+0x104>
  ec:	12d000ef          	jal	a18 <printf>
      data += sizeof(short);
  f0:	0909                	addi	s2,s2,2
      break;
  f2:	bf71                	j	8e <memdump+0x44>
      printf("%c\n", *((char *)data));
  f4:	00094583          	lbu	a1,0(s2)
  f8:	00001517          	auipc	a0,0x1
  fc:	af050513          	addi	a0,a0,-1296 # be8 <malloc+0x11c>
 100:	119000ef          	jal	a18 <printf>
      data += sizeof(char);
 104:	0905                	addi	s2,s2,1
      break;
 106:	b761                	j	8e <memdump+0x44>
      printf("%s\n", *((char **)data));
 108:	00093583          	ld	a1,0(s2)
 10c:	00001517          	auipc	a0,0x1
 110:	ae450513          	addi	a0,a0,-1308 # bf0 <malloc+0x124>
 114:	105000ef          	jal	a18 <printf>
      data += sizeof(char *);
 118:	0921                	addi	s2,s2,8
      break;
 11a:	bf95                	j	8e <memdump+0x44>
      printf("%s\n", data);
 11c:	85ca                	mv	a1,s2
 11e:	00001517          	auipc	a0,0x1
 122:	ad250513          	addi	a0,a0,-1326 # bf0 <malloc+0x124>
 126:	0f3000ef          	jal	a18 <printf>
      while (*data != '\0') // this is essentially the same as when we did data +=sizeof(***), since the "data" variable needs to be moved
 12a:	00094783          	lbu	a5,0(s2)
 12e:	c789                	beqz	a5,138 <memdump+0xee>
        data++;
 130:	0905                	addi	s2,s2,1
      while (*data != '\0') // this is essentially the same as when we did data +=sizeof(***), since the "data" variable needs to be moved
 132:	00094783          	lbu	a5,0(s2)
 136:	ffed                	bnez	a5,130 <memdump+0xe6>
      data++; // move past the null terminator
 138:	0905                	addi	s2,s2,1
      break;
 13a:	bf91                	j	8e <memdump+0x44>
 13c:	e862                	sd	s8,16(sp)
 13e:	e466                	sd	s9,8(sp)
 140:	89ca                	mv	s3,s2
 142:	01090b93          	addi	s7,s2,16
        if (v >= 32 && v <= 126)
 146:	05e00c13          	li	s8,94
          printf("%c", v);
 14a:	00001c97          	auipc	s9,0x1
 14e:	aaec8c93          	addi	s9,s9,-1362 # bf8 <malloc+0x12c>
 152:	a021                	j	15a <memdump+0x110>
      for (int j = 0; j < 16; j += 2)
 154:	0989                	addi	s3,s3,2
 156:	03798b63          	beq	s3,s7,18c <memdump+0x142>
        int hi = hexval(data[j]);
 15a:	0009c503          	lbu	a0,0(s3)
 15e:	ea3ff0ef          	jal	0 <hexval>
 162:	84aa                	mv	s1,a0
        if (hi < 0 || lo < 0)
 164:	fe0548e3          	bltz	a0,154 <memdump+0x10a>
        int lo = hexval(data[j + 1]);
 168:	0019c503          	lbu	a0,1(s3)
 16c:	e95ff0ef          	jal	0 <hexval>
        if (hi < 0 || lo < 0)
 170:	fe0542e3          	bltz	a0,154 <memdump+0x10a>
        int v = (hi * 16) + lo;
 174:	0044949b          	slliw	s1,s1,0x4
 178:	9d25                	addw	a0,a0,s1
 17a:	0005059b          	sext.w	a1,a0
        if (v >= 32 && v <= 126)
 17e:	3501                	addiw	a0,a0,-32
 180:	fcac6ae3          	bltu	s8,a0,154 <memdump+0x10a>
          printf("%c", v);
 184:	8566                	mv	a0,s9
 186:	093000ef          	jal	a18 <printf>
 18a:	b7e9                	j	154 <memdump+0x10a>
      printf("\n");
 18c:	00001517          	auipc	a0,0x1
 190:	a5450513          	addi	a0,a0,-1452 # be0 <malloc+0x114>
 194:	085000ef          	jal	a18 <printf>
      data += 16;
 198:	0941                	addi	s2,s2,16
      break;
 19a:	6c42                	ld	s8,16(sp)
 19c:	6ca2                	ld	s9,8(sp)
 19e:	bdc5                	j	8e <memdump+0x44>
      printf("memdump: unknown format character '%c'\n", fmt[i]);
 1a0:	00001517          	auipc	a0,0x1
 1a4:	a6050513          	addi	a0,a0,-1440 # c00 <malloc+0x134>
 1a8:	071000ef          	jal	a18 <printf>
      return;
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	79e2                	ld	s3,56(sp)
 1b0:	7a42                	ld	s4,48(sp)
 1b2:	7aa2                	ld	s5,40(sp)
 1b4:	7b02                	ld	s6,32(sp)
 1b6:	6be2                	ld	s7,24(sp)
}
 1b8:	60e6                	ld	ra,88(sp)
 1ba:	6446                	ld	s0,80(sp)
 1bc:	6906                	ld	s2,64(sp)
 1be:	6125                	addi	sp,sp,96
 1c0:	8082                	ret
 1c2:	64a6                	ld	s1,72(sp)
 1c4:	79e2                	ld	s3,56(sp)
 1c6:	7a42                	ld	s4,48(sp)
 1c8:	7aa2                	ld	s5,40(sp)
 1ca:	7b02                	ld	s6,32(sp)
 1cc:	6be2                	ld	s7,24(sp)
 1ce:	b7ed                	j	1b8 <memdump+0x16e>

00000000000001d0 <main>:
{
 1d0:	dc010113          	addi	sp,sp,-576
 1d4:	22113c23          	sd	ra,568(sp)
 1d8:	22813823          	sd	s0,560(sp)
 1dc:	22913423          	sd	s1,552(sp)
 1e0:	23213023          	sd	s2,544(sp)
 1e4:	21313c23          	sd	s3,536(sp)
 1e8:	21413823          	sd	s4,528(sp)
 1ec:	0480                	addi	s0,sp,576
  if (argc == 1)
 1ee:	4785                	li	a5,1
 1f0:	00f50f63          	beq	a0,a5,20e <main+0x3e>
 1f4:	892e                	mv	s2,a1
  else if (argc == 2)
 1f6:	4789                	li	a5,2
 1f8:	0ef50f63          	beq	a0,a5,2f6 <main+0x126>
    printf("Usage: memdump [format]\n");
 1fc:	00001517          	auipc	a0,0x1
 200:	acc50513          	addi	a0,a0,-1332 # cc8 <malloc+0x1fc>
 204:	015000ef          	jal	a18 <printf>
    exit(1);
 208:	4505                	li	a0,1
 20a:	3d2000ef          	jal	5dc <exit>
    printf("Example 1:\n");
 20e:	00001517          	auipc	a0,0x1
 212:	a1a50513          	addi	a0,a0,-1510 # c28 <malloc+0x15c>
 216:	003000ef          	jal	a18 <printf>
    int a[2] = {61810, 2025};
 21a:	67bd                	lui	a5,0xf
 21c:	17278793          	addi	a5,a5,370 # f172 <base+0xd162>
 220:	dcf42023          	sw	a5,-576(s0)
 224:	7e900793          	li	a5,2025
 228:	dcf42223          	sw	a5,-572(s0)
    memdump("ii", (char *)a);
 22c:	dc040593          	addi	a1,s0,-576
 230:	00001517          	auipc	a0,0x1
 234:	a0850513          	addi	a0,a0,-1528 # c38 <malloc+0x16c>
 238:	e13ff0ef          	jal	4a <memdump>
    printf("Example 2:\n");
 23c:	00001517          	auipc	a0,0x1
 240:	a0450513          	addi	a0,a0,-1532 # c40 <malloc+0x174>
 244:	7d4000ef          	jal	a18 <printf>
    memdump("S", "a string");
 248:	00001597          	auipc	a1,0x1
 24c:	a0858593          	addi	a1,a1,-1528 # c50 <malloc+0x184>
 250:	00001517          	auipc	a0,0x1
 254:	a1050513          	addi	a0,a0,-1520 # c60 <malloc+0x194>
 258:	df3ff0ef          	jal	4a <memdump>
    printf("Example 3:\n");
 25c:	00001517          	auipc	a0,0x1
 260:	a0c50513          	addi	a0,a0,-1524 # c68 <malloc+0x19c>
 264:	7b4000ef          	jal	a18 <printf>
    char *s = "another";
 268:	00001797          	auipc	a5,0x1
 26c:	a1078793          	addi	a5,a5,-1520 # c78 <malloc+0x1ac>
 270:	dcf43423          	sd	a5,-568(s0)
    memdump("s", (char *)&s);
 274:	dc840593          	addi	a1,s0,-568
 278:	00001517          	auipc	a0,0x1
 27c:	a0850513          	addi	a0,a0,-1528 # c80 <malloc+0x1b4>
 280:	dcbff0ef          	jal	4a <memdump>
    example.ptr = "hello";
 284:	00001797          	auipc	a5,0x1
 288:	a0478793          	addi	a5,a5,-1532 # c88 <malloc+0x1bc>
 28c:	dcf43823          	sd	a5,-560(s0)
    example.num1 = 1819438967;
 290:	6c7277b7          	lui	a5,0x6c727
 294:	f7778793          	addi	a5,a5,-137 # 6c726f77 <base+0x6c724f67>
 298:	dcf42c23          	sw	a5,-552(s0)
    example.num2 = 100;
 29c:	06400793          	li	a5,100
 2a0:	dcf41e23          	sh	a5,-548(s0)
    example.byte = 'z';
 2a4:	07a00793          	li	a5,122
 2a8:	dcf40f23          	sb	a5,-546(s0)
    strcpy(example.bytes, "xyzzy");
 2ac:	00001597          	auipc	a1,0x1
 2b0:	9e458593          	addi	a1,a1,-1564 # c90 <malloc+0x1c4>
 2b4:	ddf40513          	addi	a0,s0,-545
 2b8:	0a0000ef          	jal	358 <strcpy>
    printf("Example 4:\n");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	9dc50513          	addi	a0,a0,-1572 # c98 <malloc+0x1cc>
 2c4:	754000ef          	jal	a18 <printf>
    memdump("pihcS", (char *)&example);
 2c8:	dd040593          	addi	a1,s0,-560
 2cc:	00001517          	auipc	a0,0x1
 2d0:	9dc50513          	addi	a0,a0,-1572 # ca8 <malloc+0x1dc>
 2d4:	d77ff0ef          	jal	4a <memdump>
    printf("Example 5:\n");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	9d850513          	addi	a0,a0,-1576 # cb0 <malloc+0x1e4>
 2e0:	738000ef          	jal	a18 <printf>
    memdump("sccccc", (char *)&example);
 2e4:	dd040593          	addi	a1,s0,-560
 2e8:	00001517          	auipc	a0,0x1
 2ec:	9d850513          	addi	a0,a0,-1576 # cc0 <malloc+0x1f4>
 2f0:	d5bff0ef          	jal	4a <memdump>
 2f4:	a0b1                	j	340 <main+0x170>
    memset(data, '\0', sizeof(data));
 2f6:	20000613          	li	a2,512
 2fa:	4581                	li	a1,0
 2fc:	dd040513          	addi	a0,s0,-560
 300:	0ca000ef          	jal	3ca <memset>
    int n = 0;
 304:	4481                	li	s1,0
    while (n < sizeof(data))
 306:	4601                	li	a2,0
      int nn = read(0, data + n, sizeof(data) - n);
 308:	20000993          	li	s3,512
    while (n < sizeof(data))
 30c:	1ff00a13          	li	s4,511
      int nn = read(0, data + n, sizeof(data) - n);
 310:	40c9863b          	subw	a2,s3,a2
 314:	dd040793          	addi	a5,s0,-560
 318:	009785b3          	add	a1,a5,s1
 31c:	4501                	li	a0,0
 31e:	2d6000ef          	jal	5f4 <read>
      if (nn <= 0)
 322:	00a05963          	blez	a0,334 <main+0x164>
      n += nn;
 326:	0095063b          	addw	a2,a0,s1
 32a:	0006049b          	sext.w	s1,a2
    while (n < sizeof(data))
 32e:	8626                	mv	a2,s1
 330:	fe9a70e3          	bgeu	s4,s1,310 <main+0x140>
    memdump(argv[1], data);
 334:	dd040593          	addi	a1,s0,-560
 338:	00893503          	ld	a0,8(s2)
 33c:	d0fff0ef          	jal	4a <memdump>
  exit(0);
 340:	4501                	li	a0,0
 342:	29a000ef          	jal	5dc <exit>

0000000000000346 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 34e:	e83ff0ef          	jal	1d0 <main>
  exit(0);
 352:	4501                	li	a0,0
 354:	288000ef          	jal	5dc <exit>

0000000000000358 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 35e:	87aa                	mv	a5,a0
 360:	0585                	addi	a1,a1,1
 362:	0785                	addi	a5,a5,1
 364:	fff5c703          	lbu	a4,-1(a1)
 368:	fee78fa3          	sb	a4,-1(a5)
 36c:	fb75                	bnez	a4,360 <strcpy+0x8>
    ;
  return os;
}
 36e:	6422                	ld	s0,8(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 37a:	00054783          	lbu	a5,0(a0)
 37e:	cb91                	beqz	a5,392 <strcmp+0x1e>
 380:	0005c703          	lbu	a4,0(a1)
 384:	00f71763          	bne	a4,a5,392 <strcmp+0x1e>
    p++, q++;
 388:	0505                	addi	a0,a0,1
 38a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 38c:	00054783          	lbu	a5,0(a0)
 390:	fbe5                	bnez	a5,380 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 392:	0005c503          	lbu	a0,0(a1)
}
 396:	40a7853b          	subw	a0,a5,a0
 39a:	6422                	ld	s0,8(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <strlen>:

uint
strlen(const char *s)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e422                	sd	s0,8(sp)
 3a4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3a6:	00054783          	lbu	a5,0(a0)
 3aa:	cf91                	beqz	a5,3c6 <strlen+0x26>
 3ac:	0505                	addi	a0,a0,1
 3ae:	87aa                	mv	a5,a0
 3b0:	86be                	mv	a3,a5
 3b2:	0785                	addi	a5,a5,1
 3b4:	fff7c703          	lbu	a4,-1(a5)
 3b8:	ff65                	bnez	a4,3b0 <strlen+0x10>
 3ba:	40a6853b          	subw	a0,a3,a0
 3be:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
  for(n = 0; s[n]; n++)
 3c6:	4501                	li	a0,0
 3c8:	bfe5                	j	3c0 <strlen+0x20>

00000000000003ca <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e422                	sd	s0,8(sp)
 3ce:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3d0:	ca19                	beqz	a2,3e6 <memset+0x1c>
 3d2:	87aa                	mv	a5,a0
 3d4:	1602                	slli	a2,a2,0x20
 3d6:	9201                	srli	a2,a2,0x20
 3d8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3dc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3e0:	0785                	addi	a5,a5,1
 3e2:	fee79de3          	bne	a5,a4,3dc <memset+0x12>
  }
  return dst;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret

00000000000003ec <strchr>:

char*
strchr(const char *s, char c)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e422                	sd	s0,8(sp)
 3f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3f2:	00054783          	lbu	a5,0(a0)
 3f6:	cb99                	beqz	a5,40c <strchr+0x20>
    if(*s == c)
 3f8:	00f58763          	beq	a1,a5,406 <strchr+0x1a>
  for(; *s; s++)
 3fc:	0505                	addi	a0,a0,1
 3fe:	00054783          	lbu	a5,0(a0)
 402:	fbfd                	bnez	a5,3f8 <strchr+0xc>
      return (char*)s;
  return 0;
 404:	4501                	li	a0,0
}
 406:	6422                	ld	s0,8(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret
  return 0;
 40c:	4501                	li	a0,0
 40e:	bfe5                	j	406 <strchr+0x1a>

0000000000000410 <gets>:

char*
gets(char *buf, int max)
{
 410:	711d                	addi	sp,sp,-96
 412:	ec86                	sd	ra,88(sp)
 414:	e8a2                	sd	s0,80(sp)
 416:	e4a6                	sd	s1,72(sp)
 418:	e0ca                	sd	s2,64(sp)
 41a:	fc4e                	sd	s3,56(sp)
 41c:	f852                	sd	s4,48(sp)
 41e:	f456                	sd	s5,40(sp)
 420:	f05a                	sd	s6,32(sp)
 422:	ec5e                	sd	s7,24(sp)
 424:	1080                	addi	s0,sp,96
 426:	8baa                	mv	s7,a0
 428:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 42a:	892a                	mv	s2,a0
 42c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 42e:	4aa9                	li	s5,10
 430:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 432:	89a6                	mv	s3,s1
 434:	2485                	addiw	s1,s1,1
 436:	0344d663          	bge	s1,s4,462 <gets+0x52>
    cc = read(0, &c, 1);
 43a:	4605                	li	a2,1
 43c:	faf40593          	addi	a1,s0,-81
 440:	4501                	li	a0,0
 442:	1b2000ef          	jal	5f4 <read>
    if(cc < 1)
 446:	00a05e63          	blez	a0,462 <gets+0x52>
    buf[i++] = c;
 44a:	faf44783          	lbu	a5,-81(s0)
 44e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 452:	01578763          	beq	a5,s5,460 <gets+0x50>
 456:	0905                	addi	s2,s2,1
 458:	fd679de3          	bne	a5,s6,432 <gets+0x22>
    buf[i++] = c;
 45c:	89a6                	mv	s3,s1
 45e:	a011                	j	462 <gets+0x52>
 460:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 462:	99de                	add	s3,s3,s7
 464:	00098023          	sb	zero,0(s3)
  return buf;
}
 468:	855e                	mv	a0,s7
 46a:	60e6                	ld	ra,88(sp)
 46c:	6446                	ld	s0,80(sp)
 46e:	64a6                	ld	s1,72(sp)
 470:	6906                	ld	s2,64(sp)
 472:	79e2                	ld	s3,56(sp)
 474:	7a42                	ld	s4,48(sp)
 476:	7aa2                	ld	s5,40(sp)
 478:	7b02                	ld	s6,32(sp)
 47a:	6be2                	ld	s7,24(sp)
 47c:	6125                	addi	sp,sp,96
 47e:	8082                	ret

0000000000000480 <stat>:

int
stat(const char *n, struct stat *st)
{
 480:	1101                	addi	sp,sp,-32
 482:	ec06                	sd	ra,24(sp)
 484:	e822                	sd	s0,16(sp)
 486:	e04a                	sd	s2,0(sp)
 488:	1000                	addi	s0,sp,32
 48a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 48c:	4581                	li	a1,0
 48e:	18e000ef          	jal	61c <open>
  if(fd < 0)
 492:	02054263          	bltz	a0,4b6 <stat+0x36>
 496:	e426                	sd	s1,8(sp)
 498:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 49a:	85ca                	mv	a1,s2
 49c:	198000ef          	jal	634 <fstat>
 4a0:	892a                	mv	s2,a0
  close(fd);
 4a2:	8526                	mv	a0,s1
 4a4:	160000ef          	jal	604 <close>
  return r;
 4a8:	64a2                	ld	s1,8(sp)
}
 4aa:	854a                	mv	a0,s2
 4ac:	60e2                	ld	ra,24(sp)
 4ae:	6442                	ld	s0,16(sp)
 4b0:	6902                	ld	s2,0(sp)
 4b2:	6105                	addi	sp,sp,32
 4b4:	8082                	ret
    return -1;
 4b6:	597d                	li	s2,-1
 4b8:	bfcd                	j	4aa <stat+0x2a>

00000000000004ba <atoi>:

int
atoi(const char *s)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e422                	sd	s0,8(sp)
 4be:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4c0:	00054683          	lbu	a3,0(a0)
 4c4:	fd06879b          	addiw	a5,a3,-48
 4c8:	0ff7f793          	zext.b	a5,a5
 4cc:	4625                	li	a2,9
 4ce:	02f66863          	bltu	a2,a5,4fe <atoi+0x44>
 4d2:	872a                	mv	a4,a0
  n = 0;
 4d4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4d6:	0705                	addi	a4,a4,1
 4d8:	0025179b          	slliw	a5,a0,0x2
 4dc:	9fa9                	addw	a5,a5,a0
 4de:	0017979b          	slliw	a5,a5,0x1
 4e2:	9fb5                	addw	a5,a5,a3
 4e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4e8:	00074683          	lbu	a3,0(a4)
 4ec:	fd06879b          	addiw	a5,a3,-48
 4f0:	0ff7f793          	zext.b	a5,a5
 4f4:	fef671e3          	bgeu	a2,a5,4d6 <atoi+0x1c>
  return n;
}
 4f8:	6422                	ld	s0,8(sp)
 4fa:	0141                	addi	sp,sp,16
 4fc:	8082                	ret
  n = 0;
 4fe:	4501                	li	a0,0
 500:	bfe5                	j	4f8 <atoi+0x3e>

0000000000000502 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 502:	1141                	addi	sp,sp,-16
 504:	e422                	sd	s0,8(sp)
 506:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 508:	02b57463          	bgeu	a0,a1,530 <memmove+0x2e>
    while(n-- > 0)
 50c:	00c05f63          	blez	a2,52a <memmove+0x28>
 510:	1602                	slli	a2,a2,0x20
 512:	9201                	srli	a2,a2,0x20
 514:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 518:	872a                	mv	a4,a0
      *dst++ = *src++;
 51a:	0585                	addi	a1,a1,1
 51c:	0705                	addi	a4,a4,1
 51e:	fff5c683          	lbu	a3,-1(a1)
 522:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 526:	fef71ae3          	bne	a4,a5,51a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 52a:	6422                	ld	s0,8(sp)
 52c:	0141                	addi	sp,sp,16
 52e:	8082                	ret
    dst += n;
 530:	00c50733          	add	a4,a0,a2
    src += n;
 534:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 536:	fec05ae3          	blez	a2,52a <memmove+0x28>
 53a:	fff6079b          	addiw	a5,a2,-1
 53e:	1782                	slli	a5,a5,0x20
 540:	9381                	srli	a5,a5,0x20
 542:	fff7c793          	not	a5,a5
 546:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 548:	15fd                	addi	a1,a1,-1
 54a:	177d                	addi	a4,a4,-1
 54c:	0005c683          	lbu	a3,0(a1)
 550:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 554:	fee79ae3          	bne	a5,a4,548 <memmove+0x46>
 558:	bfc9                	j	52a <memmove+0x28>

000000000000055a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 55a:	1141                	addi	sp,sp,-16
 55c:	e422                	sd	s0,8(sp)
 55e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 560:	ca05                	beqz	a2,590 <memcmp+0x36>
 562:	fff6069b          	addiw	a3,a2,-1
 566:	1682                	slli	a3,a3,0x20
 568:	9281                	srli	a3,a3,0x20
 56a:	0685                	addi	a3,a3,1
 56c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 56e:	00054783          	lbu	a5,0(a0)
 572:	0005c703          	lbu	a4,0(a1)
 576:	00e79863          	bne	a5,a4,586 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 57a:	0505                	addi	a0,a0,1
    p2++;
 57c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 57e:	fed518e3          	bne	a0,a3,56e <memcmp+0x14>
  }
  return 0;
 582:	4501                	li	a0,0
 584:	a019                	j	58a <memcmp+0x30>
      return *p1 - *p2;
 586:	40e7853b          	subw	a0,a5,a4
}
 58a:	6422                	ld	s0,8(sp)
 58c:	0141                	addi	sp,sp,16
 58e:	8082                	ret
  return 0;
 590:	4501                	li	a0,0
 592:	bfe5                	j	58a <memcmp+0x30>

0000000000000594 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 594:	1141                	addi	sp,sp,-16
 596:	e406                	sd	ra,8(sp)
 598:	e022                	sd	s0,0(sp)
 59a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 59c:	f67ff0ef          	jal	502 <memmove>
}
 5a0:	60a2                	ld	ra,8(sp)
 5a2:	6402                	ld	s0,0(sp)
 5a4:	0141                	addi	sp,sp,16
 5a6:	8082                	ret

00000000000005a8 <sbrk>:

char *
sbrk(int n) {
 5a8:	1141                	addi	sp,sp,-16
 5aa:	e406                	sd	ra,8(sp)
 5ac:	e022                	sd	s0,0(sp)
 5ae:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 5b0:	4585                	li	a1,1
 5b2:	0b2000ef          	jal	664 <sys_sbrk>
}
 5b6:	60a2                	ld	ra,8(sp)
 5b8:	6402                	ld	s0,0(sp)
 5ba:	0141                	addi	sp,sp,16
 5bc:	8082                	ret

00000000000005be <sbrklazy>:

char *
sbrklazy(int n) {
 5be:	1141                	addi	sp,sp,-16
 5c0:	e406                	sd	ra,8(sp)
 5c2:	e022                	sd	s0,0(sp)
 5c4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 5c6:	4589                	li	a1,2
 5c8:	09c000ef          	jal	664 <sys_sbrk>
}
 5cc:	60a2                	ld	ra,8(sp)
 5ce:	6402                	ld	s0,0(sp)
 5d0:	0141                	addi	sp,sp,16
 5d2:	8082                	ret

00000000000005d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5d4:	4885                	li	a7,1
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 5dc:	4889                	li	a7,2
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5e4:	488d                	li	a7,3
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5ec:	4891                	li	a7,4
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <read>:
.global read
read:
 li a7, SYS_read
 5f4:	4895                	li	a7,5
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <write>:
.global write
write:
 li a7, SYS_write
 5fc:	48c1                	li	a7,16
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <close>:
.global close
close:
 li a7, SYS_close
 604:	48d5                	li	a7,21
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <kill>:
.global kill
kill:
 li a7, SYS_kill
 60c:	4899                	li	a7,6
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <exec>:
.global exec
exec:
 li a7, SYS_exec
 614:	489d                	li	a7,7
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <open>:
.global open
open:
 li a7, SYS_open
 61c:	48bd                	li	a7,15
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 624:	48c5                	li	a7,17
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 62c:	48c9                	li	a7,18
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 634:	48a1                	li	a7,8
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <link>:
.global link
link:
 li a7, SYS_link
 63c:	48cd                	li	a7,19
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 644:	48d1                	li	a7,20
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 64c:	48a5                	li	a7,9
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <dup>:
.global dup
dup:
 li a7, SYS_dup
 654:	48a9                	li	a7,10
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 65c:	48ad                	li	a7,11
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 664:	48b1                	li	a7,12
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <pause>:
.global pause
pause:
 li a7, SYS_pause
 66c:	48b5                	li	a7,13
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 674:	48b9                	li	a7,14
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <endianswap>:
.global endianswap
endianswap:
 li a7, SYS_endianswap
 67c:	48d9                	li	a7,22
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 684:	1101                	addi	sp,sp,-32
 686:	ec06                	sd	ra,24(sp)
 688:	e822                	sd	s0,16(sp)
 68a:	1000                	addi	s0,sp,32
 68c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 690:	4605                	li	a2,1
 692:	fef40593          	addi	a1,s0,-17
 696:	f67ff0ef          	jal	5fc <write>
}
 69a:	60e2                	ld	ra,24(sp)
 69c:	6442                	ld	s0,16(sp)
 69e:	6105                	addi	sp,sp,32
 6a0:	8082                	ret

00000000000006a2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 6a2:	715d                	addi	sp,sp,-80
 6a4:	e486                	sd	ra,72(sp)
 6a6:	e0a2                	sd	s0,64(sp)
 6a8:	fc26                	sd	s1,56(sp)
 6aa:	0880                	addi	s0,sp,80
 6ac:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6ae:	c299                	beqz	a3,6b4 <printint+0x12>
 6b0:	0805c963          	bltz	a1,742 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6b4:	2581                	sext.w	a1,a1
  neg = 0;
 6b6:	4881                	li	a7,0
 6b8:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 6bc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6be:	2601                	sext.w	a2,a2
 6c0:	00000517          	auipc	a0,0x0
 6c4:	6b850513          	addi	a0,a0,1720 # d78 <digits>
 6c8:	883a                	mv	a6,a4
 6ca:	2705                	addiw	a4,a4,1
 6cc:	02c5f7bb          	remuw	a5,a1,a2
 6d0:	1782                	slli	a5,a5,0x20
 6d2:	9381                	srli	a5,a5,0x20
 6d4:	97aa                	add	a5,a5,a0
 6d6:	0007c783          	lbu	a5,0(a5)
 6da:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6de:	0005879b          	sext.w	a5,a1
 6e2:	02c5d5bb          	divuw	a1,a1,a2
 6e6:	0685                	addi	a3,a3,1
 6e8:	fec7f0e3          	bgeu	a5,a2,6c8 <printint+0x26>
  if(neg)
 6ec:	00088c63          	beqz	a7,704 <printint+0x62>
    buf[i++] = '-';
 6f0:	fd070793          	addi	a5,a4,-48
 6f4:	00878733          	add	a4,a5,s0
 6f8:	02d00793          	li	a5,45
 6fc:	fef70423          	sb	a5,-24(a4)
 700:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 704:	02e05a63          	blez	a4,738 <printint+0x96>
 708:	f84a                	sd	s2,48(sp)
 70a:	f44e                	sd	s3,40(sp)
 70c:	fb840793          	addi	a5,s0,-72
 710:	00e78933          	add	s2,a5,a4
 714:	fff78993          	addi	s3,a5,-1
 718:	99ba                	add	s3,s3,a4
 71a:	377d                	addiw	a4,a4,-1
 71c:	1702                	slli	a4,a4,0x20
 71e:	9301                	srli	a4,a4,0x20
 720:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 724:	fff94583          	lbu	a1,-1(s2)
 728:	8526                	mv	a0,s1
 72a:	f5bff0ef          	jal	684 <putc>
  while(--i >= 0)
 72e:	197d                	addi	s2,s2,-1
 730:	ff391ae3          	bne	s2,s3,724 <printint+0x82>
 734:	7942                	ld	s2,48(sp)
 736:	79a2                	ld	s3,40(sp)
}
 738:	60a6                	ld	ra,72(sp)
 73a:	6406                	ld	s0,64(sp)
 73c:	74e2                	ld	s1,56(sp)
 73e:	6161                	addi	sp,sp,80
 740:	8082                	ret
    x = -xx;
 742:	40b005bb          	negw	a1,a1
    neg = 1;
 746:	4885                	li	a7,1
    x = -xx;
 748:	bf85                	j	6b8 <printint+0x16>

000000000000074a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 74a:	711d                	addi	sp,sp,-96
 74c:	ec86                	sd	ra,88(sp)
 74e:	e8a2                	sd	s0,80(sp)
 750:	e0ca                	sd	s2,64(sp)
 752:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 754:	0005c903          	lbu	s2,0(a1)
 758:	28090663          	beqz	s2,9e4 <vprintf+0x29a>
 75c:	e4a6                	sd	s1,72(sp)
 75e:	fc4e                	sd	s3,56(sp)
 760:	f852                	sd	s4,48(sp)
 762:	f456                	sd	s5,40(sp)
 764:	f05a                	sd	s6,32(sp)
 766:	ec5e                	sd	s7,24(sp)
 768:	e862                	sd	s8,16(sp)
 76a:	e466                	sd	s9,8(sp)
 76c:	8b2a                	mv	s6,a0
 76e:	8a2e                	mv	s4,a1
 770:	8bb2                	mv	s7,a2
  state = 0;
 772:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 774:	4481                	li	s1,0
 776:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 778:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 77c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 780:	06c00c93          	li	s9,108
 784:	a005                	j	7a4 <vprintf+0x5a>
        putc(fd, c0);
 786:	85ca                	mv	a1,s2
 788:	855a                	mv	a0,s6
 78a:	efbff0ef          	jal	684 <putc>
 78e:	a019                	j	794 <vprintf+0x4a>
    } else if(state == '%'){
 790:	03598263          	beq	s3,s5,7b4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 794:	2485                	addiw	s1,s1,1
 796:	8726                	mv	a4,s1
 798:	009a07b3          	add	a5,s4,s1
 79c:	0007c903          	lbu	s2,0(a5)
 7a0:	22090a63          	beqz	s2,9d4 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 7a4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7a8:	fe0994e3          	bnez	s3,790 <vprintf+0x46>
      if(c0 == '%'){
 7ac:	fd579de3          	bne	a5,s5,786 <vprintf+0x3c>
        state = '%';
 7b0:	89be                	mv	s3,a5
 7b2:	b7cd                	j	794 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 7b4:	00ea06b3          	add	a3,s4,a4
 7b8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7bc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 7be:	c681                	beqz	a3,7c6 <vprintf+0x7c>
 7c0:	9752                	add	a4,a4,s4
 7c2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7c6:	05878363          	beq	a5,s8,80c <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 7ca:	05978d63          	beq	a5,s9,824 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7ce:	07500713          	li	a4,117
 7d2:	0ee78763          	beq	a5,a4,8c0 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7d6:	07800713          	li	a4,120
 7da:	12e78963          	beq	a5,a4,90c <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7de:	07000713          	li	a4,112
 7e2:	14e78e63          	beq	a5,a4,93e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 7e6:	06300713          	li	a4,99
 7ea:	18e78e63          	beq	a5,a4,986 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 7ee:	07300713          	li	a4,115
 7f2:	1ae78463          	beq	a5,a4,99a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7f6:	02500713          	li	a4,37
 7fa:	04e79563          	bne	a5,a4,844 <vprintf+0xfa>
        putc(fd, '%');
 7fe:	02500593          	li	a1,37
 802:	855a                	mv	a0,s6
 804:	e81ff0ef          	jal	684 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 808:	4981                	li	s3,0
 80a:	b769                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 80c:	008b8913          	addi	s2,s7,8
 810:	4685                	li	a3,1
 812:	4629                	li	a2,10
 814:	000ba583          	lw	a1,0(s7)
 818:	855a                	mv	a0,s6
 81a:	e89ff0ef          	jal	6a2 <printint>
 81e:	8bca                	mv	s7,s2
      state = 0;
 820:	4981                	li	s3,0
 822:	bf8d                	j	794 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 824:	06400793          	li	a5,100
 828:	02f68963          	beq	a3,a5,85a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 82c:	06c00793          	li	a5,108
 830:	04f68263          	beq	a3,a5,874 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 834:	07500793          	li	a5,117
 838:	0af68063          	beq	a3,a5,8d8 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 83c:	07800793          	li	a5,120
 840:	0ef68263          	beq	a3,a5,924 <vprintf+0x1da>
        putc(fd, '%');
 844:	02500593          	li	a1,37
 848:	855a                	mv	a0,s6
 84a:	e3bff0ef          	jal	684 <putc>
        putc(fd, c0);
 84e:	85ca                	mv	a1,s2
 850:	855a                	mv	a0,s6
 852:	e33ff0ef          	jal	684 <putc>
      state = 0;
 856:	4981                	li	s3,0
 858:	bf35                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 85a:	008b8913          	addi	s2,s7,8
 85e:	4685                	li	a3,1
 860:	4629                	li	a2,10
 862:	000bb583          	ld	a1,0(s7)
 866:	855a                	mv	a0,s6
 868:	e3bff0ef          	jal	6a2 <printint>
        i += 1;
 86c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 86e:	8bca                	mv	s7,s2
      state = 0;
 870:	4981                	li	s3,0
        i += 1;
 872:	b70d                	j	794 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 874:	06400793          	li	a5,100
 878:	02f60763          	beq	a2,a5,8a6 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 87c:	07500793          	li	a5,117
 880:	06f60963          	beq	a2,a5,8f2 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 884:	07800793          	li	a5,120
 888:	faf61ee3          	bne	a2,a5,844 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 88c:	008b8913          	addi	s2,s7,8
 890:	4681                	li	a3,0
 892:	4641                	li	a2,16
 894:	000bb583          	ld	a1,0(s7)
 898:	855a                	mv	a0,s6
 89a:	e09ff0ef          	jal	6a2 <printint>
        i += 2;
 89e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8a0:	8bca                	mv	s7,s2
      state = 0;
 8a2:	4981                	li	s3,0
        i += 2;
 8a4:	bdc5                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8a6:	008b8913          	addi	s2,s7,8
 8aa:	4685                	li	a3,1
 8ac:	4629                	li	a2,10
 8ae:	000bb583          	ld	a1,0(s7)
 8b2:	855a                	mv	a0,s6
 8b4:	defff0ef          	jal	6a2 <printint>
        i += 2;
 8b8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8ba:	8bca                	mv	s7,s2
      state = 0;
 8bc:	4981                	li	s3,0
        i += 2;
 8be:	bdd9                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 8c0:	008b8913          	addi	s2,s7,8
 8c4:	4681                	li	a3,0
 8c6:	4629                	li	a2,10
 8c8:	000be583          	lwu	a1,0(s7)
 8cc:	855a                	mv	a0,s6
 8ce:	dd5ff0ef          	jal	6a2 <printint>
 8d2:	8bca                	mv	s7,s2
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	bd7d                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8d8:	008b8913          	addi	s2,s7,8
 8dc:	4681                	li	a3,0
 8de:	4629                	li	a2,10
 8e0:	000bb583          	ld	a1,0(s7)
 8e4:	855a                	mv	a0,s6
 8e6:	dbdff0ef          	jal	6a2 <printint>
        i += 1;
 8ea:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ec:	8bca                	mv	s7,s2
      state = 0;
 8ee:	4981                	li	s3,0
        i += 1;
 8f0:	b555                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f2:	008b8913          	addi	s2,s7,8
 8f6:	4681                	li	a3,0
 8f8:	4629                	li	a2,10
 8fa:	000bb583          	ld	a1,0(s7)
 8fe:	855a                	mv	a0,s6
 900:	da3ff0ef          	jal	6a2 <printint>
        i += 2;
 904:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 906:	8bca                	mv	s7,s2
      state = 0;
 908:	4981                	li	s3,0
        i += 2;
 90a:	b569                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 90c:	008b8913          	addi	s2,s7,8
 910:	4681                	li	a3,0
 912:	4641                	li	a2,16
 914:	000be583          	lwu	a1,0(s7)
 918:	855a                	mv	a0,s6
 91a:	d89ff0ef          	jal	6a2 <printint>
 91e:	8bca                	mv	s7,s2
      state = 0;
 920:	4981                	li	s3,0
 922:	bd8d                	j	794 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 924:	008b8913          	addi	s2,s7,8
 928:	4681                	li	a3,0
 92a:	4641                	li	a2,16
 92c:	000bb583          	ld	a1,0(s7)
 930:	855a                	mv	a0,s6
 932:	d71ff0ef          	jal	6a2 <printint>
        i += 1;
 936:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 938:	8bca                	mv	s7,s2
      state = 0;
 93a:	4981                	li	s3,0
        i += 1;
 93c:	bda1                	j	794 <vprintf+0x4a>
 93e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 940:	008b8d13          	addi	s10,s7,8
 944:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 948:	03000593          	li	a1,48
 94c:	855a                	mv	a0,s6
 94e:	d37ff0ef          	jal	684 <putc>
  putc(fd, 'x');
 952:	07800593          	li	a1,120
 956:	855a                	mv	a0,s6
 958:	d2dff0ef          	jal	684 <putc>
 95c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 95e:	00000b97          	auipc	s7,0x0
 962:	41ab8b93          	addi	s7,s7,1050 # d78 <digits>
 966:	03c9d793          	srli	a5,s3,0x3c
 96a:	97de                	add	a5,a5,s7
 96c:	0007c583          	lbu	a1,0(a5)
 970:	855a                	mv	a0,s6
 972:	d13ff0ef          	jal	684 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 976:	0992                	slli	s3,s3,0x4
 978:	397d                	addiw	s2,s2,-1
 97a:	fe0916e3          	bnez	s2,966 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 97e:	8bea                	mv	s7,s10
      state = 0;
 980:	4981                	li	s3,0
 982:	6d02                	ld	s10,0(sp)
 984:	bd01                	j	794 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 986:	008b8913          	addi	s2,s7,8
 98a:	000bc583          	lbu	a1,0(s7)
 98e:	855a                	mv	a0,s6
 990:	cf5ff0ef          	jal	684 <putc>
 994:	8bca                	mv	s7,s2
      state = 0;
 996:	4981                	li	s3,0
 998:	bbf5                	j	794 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 99a:	008b8993          	addi	s3,s7,8
 99e:	000bb903          	ld	s2,0(s7)
 9a2:	00090f63          	beqz	s2,9c0 <vprintf+0x276>
        for(; *s; s++)
 9a6:	00094583          	lbu	a1,0(s2)
 9aa:	c195                	beqz	a1,9ce <vprintf+0x284>
          putc(fd, *s);
 9ac:	855a                	mv	a0,s6
 9ae:	cd7ff0ef          	jal	684 <putc>
        for(; *s; s++)
 9b2:	0905                	addi	s2,s2,1
 9b4:	00094583          	lbu	a1,0(s2)
 9b8:	f9f5                	bnez	a1,9ac <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 9ba:	8bce                	mv	s7,s3
      state = 0;
 9bc:	4981                	li	s3,0
 9be:	bbd9                	j	794 <vprintf+0x4a>
          s = "(null)";
 9c0:	00000917          	auipc	s2,0x0
 9c4:	32890913          	addi	s2,s2,808 # ce8 <malloc+0x21c>
        for(; *s; s++)
 9c8:	02800593          	li	a1,40
 9cc:	b7c5                	j	9ac <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 9ce:	8bce                	mv	s7,s3
      state = 0;
 9d0:	4981                	li	s3,0
 9d2:	b3c9                	j	794 <vprintf+0x4a>
 9d4:	64a6                	ld	s1,72(sp)
 9d6:	79e2                	ld	s3,56(sp)
 9d8:	7a42                	ld	s4,48(sp)
 9da:	7aa2                	ld	s5,40(sp)
 9dc:	7b02                	ld	s6,32(sp)
 9de:	6be2                	ld	s7,24(sp)
 9e0:	6c42                	ld	s8,16(sp)
 9e2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9e4:	60e6                	ld	ra,88(sp)
 9e6:	6446                	ld	s0,80(sp)
 9e8:	6906                	ld	s2,64(sp)
 9ea:	6125                	addi	sp,sp,96
 9ec:	8082                	ret

00000000000009ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9ee:	715d                	addi	sp,sp,-80
 9f0:	ec06                	sd	ra,24(sp)
 9f2:	e822                	sd	s0,16(sp)
 9f4:	1000                	addi	s0,sp,32
 9f6:	e010                	sd	a2,0(s0)
 9f8:	e414                	sd	a3,8(s0)
 9fa:	e818                	sd	a4,16(s0)
 9fc:	ec1c                	sd	a5,24(s0)
 9fe:	03043023          	sd	a6,32(s0)
 a02:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a06:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a0a:	8622                	mv	a2,s0
 a0c:	d3fff0ef          	jal	74a <vprintf>
}
 a10:	60e2                	ld	ra,24(sp)
 a12:	6442                	ld	s0,16(sp)
 a14:	6161                	addi	sp,sp,80
 a16:	8082                	ret

0000000000000a18 <printf>:

void
printf(const char *fmt, ...)
{
 a18:	711d                	addi	sp,sp,-96
 a1a:	ec06                	sd	ra,24(sp)
 a1c:	e822                	sd	s0,16(sp)
 a1e:	1000                	addi	s0,sp,32
 a20:	e40c                	sd	a1,8(s0)
 a22:	e810                	sd	a2,16(s0)
 a24:	ec14                	sd	a3,24(s0)
 a26:	f018                	sd	a4,32(s0)
 a28:	f41c                	sd	a5,40(s0)
 a2a:	03043823          	sd	a6,48(s0)
 a2e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a32:	00840613          	addi	a2,s0,8
 a36:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a3a:	85aa                	mv	a1,a0
 a3c:	4505                	li	a0,1
 a3e:	d0dff0ef          	jal	74a <vprintf>
}
 a42:	60e2                	ld	ra,24(sp)
 a44:	6442                	ld	s0,16(sp)
 a46:	6125                	addi	sp,sp,96
 a48:	8082                	ret

0000000000000a4a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a4a:	1141                	addi	sp,sp,-16
 a4c:	e422                	sd	s0,8(sp)
 a4e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a50:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a54:	00001797          	auipc	a5,0x1
 a58:	5ac7b783          	ld	a5,1452(a5) # 2000 <freep>
 a5c:	a02d                	j	a86 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a5e:	4618                	lw	a4,8(a2)
 a60:	9f2d                	addw	a4,a4,a1
 a62:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a66:	6398                	ld	a4,0(a5)
 a68:	6310                	ld	a2,0(a4)
 a6a:	a83d                	j	aa8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a6c:	ff852703          	lw	a4,-8(a0)
 a70:	9f31                	addw	a4,a4,a2
 a72:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a74:	ff053683          	ld	a3,-16(a0)
 a78:	a091                	j	abc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a7a:	6398                	ld	a4,0(a5)
 a7c:	00e7e463          	bltu	a5,a4,a84 <free+0x3a>
 a80:	00e6ea63          	bltu	a3,a4,a94 <free+0x4a>
{
 a84:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a86:	fed7fae3          	bgeu	a5,a3,a7a <free+0x30>
 a8a:	6398                	ld	a4,0(a5)
 a8c:	00e6e463          	bltu	a3,a4,a94 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a90:	fee7eae3          	bltu	a5,a4,a84 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a94:	ff852583          	lw	a1,-8(a0)
 a98:	6390                	ld	a2,0(a5)
 a9a:	02059813          	slli	a6,a1,0x20
 a9e:	01c85713          	srli	a4,a6,0x1c
 aa2:	9736                	add	a4,a4,a3
 aa4:	fae60de3          	beq	a2,a4,a5e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 aa8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 aac:	4790                	lw	a2,8(a5)
 aae:	02061593          	slli	a1,a2,0x20
 ab2:	01c5d713          	srli	a4,a1,0x1c
 ab6:	973e                	add	a4,a4,a5
 ab8:	fae68ae3          	beq	a3,a4,a6c <free+0x22>
    p->s.ptr = bp->s.ptr;
 abc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 abe:	00001717          	auipc	a4,0x1
 ac2:	54f73123          	sd	a5,1346(a4) # 2000 <freep>
}
 ac6:	6422                	ld	s0,8(sp)
 ac8:	0141                	addi	sp,sp,16
 aca:	8082                	ret

0000000000000acc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 acc:	7139                	addi	sp,sp,-64
 ace:	fc06                	sd	ra,56(sp)
 ad0:	f822                	sd	s0,48(sp)
 ad2:	f426                	sd	s1,40(sp)
 ad4:	ec4e                	sd	s3,24(sp)
 ad6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ad8:	02051493          	slli	s1,a0,0x20
 adc:	9081                	srli	s1,s1,0x20
 ade:	04bd                	addi	s1,s1,15
 ae0:	8091                	srli	s1,s1,0x4
 ae2:	0014899b          	addiw	s3,s1,1
 ae6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ae8:	00001517          	auipc	a0,0x1
 aec:	51853503          	ld	a0,1304(a0) # 2000 <freep>
 af0:	c915                	beqz	a0,b24 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 af2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 af4:	4798                	lw	a4,8(a5)
 af6:	08977a63          	bgeu	a4,s1,b8a <malloc+0xbe>
 afa:	f04a                	sd	s2,32(sp)
 afc:	e852                	sd	s4,16(sp)
 afe:	e456                	sd	s5,8(sp)
 b00:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b02:	8a4e                	mv	s4,s3
 b04:	0009871b          	sext.w	a4,s3
 b08:	6685                	lui	a3,0x1
 b0a:	00d77363          	bgeu	a4,a3,b10 <malloc+0x44>
 b0e:	6a05                	lui	s4,0x1
 b10:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b14:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b18:	00001917          	auipc	s2,0x1
 b1c:	4e890913          	addi	s2,s2,1256 # 2000 <freep>
  if(p == SBRK_ERROR)
 b20:	5afd                	li	s5,-1
 b22:	a081                	j	b62 <malloc+0x96>
 b24:	f04a                	sd	s2,32(sp)
 b26:	e852                	sd	s4,16(sp)
 b28:	e456                	sd	s5,8(sp)
 b2a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b2c:	00001797          	auipc	a5,0x1
 b30:	4e478793          	addi	a5,a5,1252 # 2010 <base>
 b34:	00001717          	auipc	a4,0x1
 b38:	4cf73623          	sd	a5,1228(a4) # 2000 <freep>
 b3c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b3e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b42:	b7c1                	j	b02 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b44:	6398                	ld	a4,0(a5)
 b46:	e118                	sd	a4,0(a0)
 b48:	a8a9                	j	ba2 <malloc+0xd6>
  hp->s.size = nu;
 b4a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b4e:	0541                	addi	a0,a0,16
 b50:	efbff0ef          	jal	a4a <free>
  return freep;
 b54:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b58:	c12d                	beqz	a0,bba <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b5a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b5c:	4798                	lw	a4,8(a5)
 b5e:	02977263          	bgeu	a4,s1,b82 <malloc+0xb6>
    if(p == freep)
 b62:	00093703          	ld	a4,0(s2)
 b66:	853e                	mv	a0,a5
 b68:	fef719e3          	bne	a4,a5,b5a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b6c:	8552                	mv	a0,s4
 b6e:	a3bff0ef          	jal	5a8 <sbrk>
  if(p == SBRK_ERROR)
 b72:	fd551ce3          	bne	a0,s5,b4a <malloc+0x7e>
        return 0;
 b76:	4501                	li	a0,0
 b78:	7902                	ld	s2,32(sp)
 b7a:	6a42                	ld	s4,16(sp)
 b7c:	6aa2                	ld	s5,8(sp)
 b7e:	6b02                	ld	s6,0(sp)
 b80:	a03d                	j	bae <malloc+0xe2>
 b82:	7902                	ld	s2,32(sp)
 b84:	6a42                	ld	s4,16(sp)
 b86:	6aa2                	ld	s5,8(sp)
 b88:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b8a:	fae48de3          	beq	s1,a4,b44 <malloc+0x78>
        p->s.size -= nunits;
 b8e:	4137073b          	subw	a4,a4,s3
 b92:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b94:	02071693          	slli	a3,a4,0x20
 b98:	01c6d713          	srli	a4,a3,0x1c
 b9c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b9e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ba2:	00001717          	auipc	a4,0x1
 ba6:	44a73f23          	sd	a0,1118(a4) # 2000 <freep>
      return (void*)(p + 1);
 baa:	01078513          	addi	a0,a5,16
  }
}
 bae:	70e2                	ld	ra,56(sp)
 bb0:	7442                	ld	s0,48(sp)
 bb2:	74a2                	ld	s1,40(sp)
 bb4:	69e2                	ld	s3,24(sp)
 bb6:	6121                	addi	sp,sp,64
 bb8:	8082                	ret
 bba:	7902                	ld	s2,32(sp)
 bbc:	6a42                	ld	s4,16(sp)
 bbe:	6aa2                	ld	s5,8(sp)
 bc0:	6b02                	ld	s6,0(sp)
 bc2:	b7f5                	j	bae <malloc+0xe2>
