
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
       e:	00007797          	auipc	a5,0x7
      12:	6ea78793          	addi	a5,a5,1770 # 76f8 <malloc+0x258a>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	481040ef          	jal	4cc6 <open>
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	20a50513          	addi	a0,a0,522 # 5270 <malloc+0x102>
      6e:	04c050ef          	jal	50ba <printf>
      72:	4505                	li	a0,1
      74:	413040ef          	jal	4c86 <exit>

0000000000000078 <bsstest>:
      78:	0000a797          	auipc	a5,0xa
      7c:	52078793          	addi	a5,a5,1312 # a598 <uninit>
      80:	0000d697          	auipc	a3,0xd
      84:	c2868693          	addi	a3,a3,-984 # cca8 <buf>
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	1f050513          	addi	a0,a0,496 # 5290 <malloc+0x122>
      a8:	012050ef          	jal	50ba <printf>
      ac:	4505                	li	a0,1
      ae:	3d9040ef          	jal	4c86 <exit>

00000000000000b2 <opentest>:
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	1e850513          	addi	a0,a0,488 # 52a8 <malloc+0x13a>
      c8:	3ff040ef          	jal	4cc6 <open>
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
      d0:	3df040ef          	jal	4cae <close>
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	1f250513          	addi	a0,a0,498 # 52c8 <malloc+0x15a>
      de:	3e9040ef          	jal	4cc6 <open>
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	1be50513          	addi	a0,a0,446 # 52b0 <malloc+0x142>
      fa:	7c1040ef          	jal	50ba <printf>
      fe:	4505                	li	a0,1
     100:	387040ef          	jal	4c86 <exit>
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	1d250513          	addi	a0,a0,466 # 52d8 <malloc+0x16a>
     10e:	7ad040ef          	jal	50ba <printf>
     112:	4505                	li	a0,1
     114:	373040ef          	jal	4c86 <exit>

0000000000000118 <truncate2>:
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
     128:	00005517          	auipc	a0,0x5
     12c:	1d850513          	addi	a0,a0,472 # 5300 <malloc+0x192>
     130:	3a7040ef          	jal	4cd6 <unlink>
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	1c850513          	addi	a0,a0,456 # 5300 <malloc+0x192>
     140:	387040ef          	jal	4cc6 <open>
     144:	84aa                	mv	s1,a0
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	1c858593          	addi	a1,a1,456 # 5310 <malloc+0x1a2>
     150:	357040ef          	jal	4ca6 <write>
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	1a850513          	addi	a0,a0,424 # 5300 <malloc+0x192>
     160:	367040ef          	jal	4cc6 <open>
     164:	892a                	mv	s2,a0
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	1b058593          	addi	a1,a1,432 # 5318 <malloc+0x1aa>
     170:	8526                	mv	a0,s1
     172:	335040ef          	jal	4ca6 <write>
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
     17c:	00005517          	auipc	a0,0x5
     180:	18450513          	addi	a0,a0,388 # 5300 <malloc+0x192>
     184:	353040ef          	jal	4cd6 <unlink>
     188:	8526                	mv	a0,s1
     18a:	325040ef          	jal	4cae <close>
     18e:	854a                	mv	a0,s2
     190:	31f040ef          	jal	4cae <close>
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	17a50513          	addi	a0,a0,378 # 5320 <malloc+0x1b2>
     1ae:	70d040ef          	jal	50ba <printf>
     1b2:	4505                	li	a0,1
     1b4:	2d3040ef          	jal	4c86 <exit>

00000000000001b8 <createtest>:
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
     1d4:	06400913          	li	s2,100
     1d8:	fc940ca3          	sb	s1,-39(s0)
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	2e3040ef          	jal	4cc6 <open>
     1e8:	2c7040ef          	jal	4cae <close>
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
     206:	06400913          	li	s2,100
     20a:	fc940ca3          	sb	s1,-39(s0)
     20e:	fd840513          	addi	a0,s0,-40
     212:	2c5040ef          	jal	4cd6 <unlink>
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
     244:	00005517          	auipc	a0,0x5
     248:	10450513          	addi	a0,a0,260 # 5348 <malloc+0x1da>
     24c:	28b040ef          	jal	4cd6 <unlink>
     250:	1f300493          	li	s1,499
     254:	00005a97          	auipc	s5,0x5
     258:	0f4a8a93          	addi	s5,s5,244 # 5348 <malloc+0x1da>
     25c:	0000da17          	auipc	s4,0xd
     260:	a4ca0a13          	addi	s4,s4,-1460 # cca8 <buf>
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <rmdot+0x19>
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	257040ef          	jal	4cc6 <open>
     274:	892a                	mv	s2,a0
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	229040ef          	jal	4ca6 <write>
     282:	89aa                	mv	s3,a0
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	219040ef          	jal	4ca6 <write>
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
     296:	854a                	mv	a0,s2
     298:	217040ef          	jal	4cae <close>
     29c:	8556                	mv	a0,s5
     29e:	239040ef          	jal	4cd6 <unlink>
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	09650513          	addi	a0,a0,150 # 5358 <malloc+0x1ea>
     2ca:	5f1040ef          	jal	50ba <printf>
     2ce:	4505                	li	a0,1
     2d0:	1b7040ef          	jal	4c86 <exit>
     2d4:	89a6                	mv	s3,s1
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	09c50513          	addi	a0,a0,156 # 5378 <malloc+0x20a>
     2e4:	5d7040ef          	jal	50ba <printf>
     2e8:	4505                	li	a0,1
     2ea:	19d040ef          	jal	4c86 <exit>

00000000000002ee <badwrite>:
     2ee:	7179                	addi	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	addi	s0,sp,48
     2fe:	00005517          	auipc	a0,0x5
     302:	09250513          	addi	a0,a0,146 # 5390 <malloc+0x222>
     306:	1d1040ef          	jal	4cd6 <unlink>
     30a:	25800913          	li	s2,600
     30e:	00005997          	auipc	s3,0x5
     312:	08298993          	addi	s3,s3,130 # 5390 <malloc+0x222>
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srli	s4,s4,0x18
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	1a5040ef          	jal	4cc6 <open>
     326:	84aa                	mv	s1,a0
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	177040ef          	jal	4ca6 <write>
     334:	8526                	mv	a0,s1
     336:	179040ef          	jal	4cae <close>
     33a:	854e                	mv	a0,s3
     33c:	19b040ef          	jal	4cd6 <unlink>
     340:	397d                	addiw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	04650513          	addi	a0,a0,70 # 5390 <malloc+0x222>
     352:	175040ef          	jal	4cc6 <open>
     356:	84aa                	mv	s1,a0
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	fba58593          	addi	a1,a1,-70 # 5318 <malloc+0x1aa>
     366:	141040ef          	jal	4ca6 <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
     370:	00005517          	auipc	a0,0x5
     374:	04050513          	addi	a0,a0,64 # 53b0 <malloc+0x242>
     378:	543040ef          	jal	50ba <printf>
     37c:	4505                	li	a0,1
     37e:	109040ef          	jal	4c86 <exit>
     382:	00005517          	auipc	a0,0x5
     386:	01650513          	addi	a0,a0,22 # 5398 <malloc+0x22a>
     38a:	531040ef          	jal	50ba <printf>
     38e:	4505                	li	a0,1
     390:	0f7040ef          	jal	4c86 <exit>
     394:	00005517          	auipc	a0,0x5
     398:	00450513          	addi	a0,a0,4 # 5398 <malloc+0x22a>
     39c:	51f040ef          	jal	50ba <printf>
     3a0:	4505                	li	a0,1
     3a2:	0e5040ef          	jal	4c86 <exit>
     3a6:	8526                	mv	a0,s1
     3a8:	107040ef          	jal	4cae <close>
     3ac:	00005517          	auipc	a0,0x5
     3b0:	fe450513          	addi	a0,a0,-28 # 5390 <malloc+0x222>
     3b4:	123040ef          	jal	4cd6 <unlink>
     3b8:	4501                	li	a0,0
     3ba:	0cd040ef          	jal	4c86 <exit>

00000000000003be <outofinodes>:
     3be:	715d                	addi	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	addi	s0,sp,80
     3cc:	4481                	li	s1,0
     3ce:	07a00913          	li	s2,122
     3d2:	40000993          	li	s3,1024
     3d6:	fb240823          	sb	s2,-80(s0)
     3da:	fb2408a3          	sb	s2,-79(s0)
     3de:	41f4d71b          	sraiw	a4,s1,0x1f
     3e2:	01b7571b          	srliw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraiw	a3,a5,0x5
     3ee:	0306869b          	addiw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
     3f6:	8bfd                	andi	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addiw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
     402:	fa040a23          	sb	zero,-76(s0)
     406:	fb040513          	addi	a0,s0,-80
     40a:	0cd040ef          	jal	4cd6 <unlink>
     40e:	60200593          	li	a1,1538
     412:	fb040513          	addi	a0,s0,-80
     416:	0b1040ef          	jal	4cc6 <open>
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
     41e:	091040ef          	jal	4cae <close>
     422:	2485                	addiw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
     42a:	07a00913          	li	s2,122
     42e:	40000993          	li	s3,1024
     432:	fb240823          	sb	s2,-80(s0)
     436:	fb2408a3          	sb	s2,-79(s0)
     43a:	41f4d71b          	sraiw	a4,s1,0x1f
     43e:	01b7571b          	srliw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraiw	a3,a5,0x5
     44a:	0306869b          	addiw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
     452:	8bfd                	andi	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addiw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
     45e:	fa040a23          	sb	zero,-76(s0)
     462:	fb040513          	addi	a0,s0,-80
     466:	071040ef          	jal	4cd6 <unlink>
     46a:	2485                	addiw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	addi	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
     47e:	7159                	addi	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	addi	s0,sp,112
     490:	00007797          	auipc	a5,0x7
     494:	26878793          	addi	a5,a5,616 # 76f8 <malloc+0x258a>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
     4b6:	f9840913          	addi	s2,s0,-104
     4ba:	fc040a93          	addi	s5,s0,-64
     4be:	00005a17          	auipc	s4,0x5
     4c2:	f02a0a13          	addi	s4,s4,-254 # 53c0 <malloc+0x252>
     4c6:	00093983          	ld	s3,0(s2)
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	7f6040ef          	jal	4cc6 <open>
     4d4:	84aa                	mv	s1,a0
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	7c8040ef          	jal	4ca6 <write>
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
     4e6:	8526                	mv	a0,s1
     4e8:	7c6040ef          	jal	4cae <close>
     4ec:	8552                	mv	a0,s4
     4ee:	7e8040ef          	jal	4cd6 <unlink>
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	7ae040ef          	jal	4ca6 <write>
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
     500:	f9040513          	addi	a0,s0,-112
     504:	792040ef          	jal	4c96 <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	792040ef          	jal	4ca6 <write>
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
     51c:	f9042503          	lw	a0,-112(s0)
     520:	78e040ef          	jal	4cae <close>
     524:	f9442503          	lw	a0,-108(s0)
     528:	786040ef          	jal	4cae <close>
     52c:	0921                	addi	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	addi	sp,sp,112
     542:	8082                	ret
     544:	00005517          	auipc	a0,0x5
     548:	e8450513          	addi	a0,a0,-380 # 53c8 <malloc+0x25a>
     54c:	36f040ef          	jal	50ba <printf>
     550:	4505                	li	a0,1
     552:	734040ef          	jal	4c86 <exit>
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	e8650513          	addi	a0,a0,-378 # 53e0 <malloc+0x272>
     562:	359040ef          	jal	50ba <printf>
     566:	4505                	li	a0,1
     568:	71e040ef          	jal	4c86 <exit>
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	ea050513          	addi	a0,a0,-352 # 5410 <malloc+0x2a2>
     578:	343040ef          	jal	50ba <printf>
     57c:	4505                	li	a0,1
     57e:	708040ef          	jal	4c86 <exit>
     582:	00005517          	auipc	a0,0x5
     586:	ebe50513          	addi	a0,a0,-322 # 5440 <malloc+0x2d2>
     58a:	331040ef          	jal	50ba <printf>
     58e:	4505                	li	a0,1
     590:	6f6040ef          	jal	4c86 <exit>
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	eb850513          	addi	a0,a0,-328 # 5450 <malloc+0x2e2>
     5a0:	31b040ef          	jal	50ba <printf>
     5a4:	4505                	li	a0,1
     5a6:	6e0040ef          	jal	4c86 <exit>

00000000000005aa <copyout>:
     5aa:	7119                	addi	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	addi	s0,sp,128
     5be:	00007797          	auipc	a5,0x7
     5c2:	13a78793          	addi	a5,a5,314 # 76f8 <malloc+0x258a>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
     5ea:	f9040913          	addi	s2,s0,-112
     5ee:	fc040b13          	addi	s6,s0,-64
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	e8ea0a13          	addi	s4,s4,-370 # 5480 <malloc+0x312>
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	d1ea8a93          	addi	s5,s5,-738 # 5318 <malloc+0x1aa>
     602:	00093983          	ld	s3,0(s2)
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	6bc040ef          	jal	4cc6 <open>
     60e:	84aa                	mv	s1,a0
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	686040ef          	jal	4c9e <read>
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
     620:	8526                	mv	a0,s1
     622:	68c040ef          	jal	4cae <close>
     626:	f8840513          	addi	a0,s0,-120
     62a:	66c040ef          	jal	4c96 <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	66c040ef          	jal	4ca6 <write>
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	652040ef          	jal	4c9e <read>
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
     654:	f8842503          	lw	a0,-120(s0)
     658:	656040ef          	jal	4cae <close>
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	64e040ef          	jal	4cae <close>
     664:	0921                	addi	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	addi	sp,sp,128
     67c:	8082                	ret
     67e:	00005517          	auipc	a0,0x5
     682:	e0a50513          	addi	a0,a0,-502 # 5488 <malloc+0x31a>
     686:	235040ef          	jal	50ba <printf>
     68a:	4505                	li	a0,1
     68c:	5fa040ef          	jal	4c86 <exit>
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	e0c50513          	addi	a0,a0,-500 # 54a0 <malloc+0x332>
     69c:	21f040ef          	jal	50ba <printf>
     6a0:	4505                	li	a0,1
     6a2:	5e4040ef          	jal	4c86 <exit>
     6a6:	00005517          	auipc	a0,0x5
     6aa:	d9a50513          	addi	a0,a0,-614 # 5440 <malloc+0x2d2>
     6ae:	20d040ef          	jal	50ba <printf>
     6b2:	4505                	li	a0,1
     6b4:	5d2040ef          	jal	4c86 <exit>
     6b8:	00005517          	auipc	a0,0x5
     6bc:	e1850513          	addi	a0,a0,-488 # 54d0 <malloc+0x362>
     6c0:	1fb040ef          	jal	50ba <printf>
     6c4:	4505                	li	a0,1
     6c6:	5c0040ef          	jal	4c86 <exit>
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	e1a50513          	addi	a0,a0,-486 # 54e8 <malloc+0x37a>
     6d6:	1e5040ef          	jal	50ba <printf>
     6da:	4505                	li	a0,1
     6dc:	5aa040ef          	jal	4c86 <exit>

00000000000006e0 <truncate1>:
     6e0:	711d                	addi	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	addi	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
     6f4:	00005517          	auipc	a0,0x5
     6f8:	c0c50513          	addi	a0,a0,-1012 # 5300 <malloc+0x192>
     6fc:	5da040ef          	jal	4cd6 <unlink>
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	bfc50513          	addi	a0,a0,-1028 # 5300 <malloc+0x192>
     70c:	5ba040ef          	jal	4cc6 <open>
     710:	84aa                	mv	s1,a0
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	bfc58593          	addi	a1,a1,-1028 # 5310 <malloc+0x1a2>
     71c:	58a040ef          	jal	4ca6 <write>
     720:	8526                	mv	a0,s1
     722:	58c040ef          	jal	4cae <close>
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	bd850513          	addi	a0,a0,-1064 # 5300 <malloc+0x192>
     730:	596040ef          	jal	4cc6 <open>
     734:	84aa                	mv	s1,a0
     736:	02000613          	li	a2,32
     73a:	fa040593          	addi	a1,s0,-96
     73e:	560040ef          	jal	4c9e <read>
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	bb450513          	addi	a0,a0,-1100 # 5300 <malloc+0x192>
     754:	572040ef          	jal	4cc6 <open>
     758:	89aa                	mv	s3,a0
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	ba450513          	addi	a0,a0,-1116 # 5300 <malloc+0x192>
     764:	562040ef          	jal	4cc6 <open>
     768:	892a                	mv	s2,a0
     76a:	02000613          	li	a2,32
     76e:	fa040593          	addi	a1,s0,-96
     772:	52c040ef          	jal	4c9e <read>
     776:	8a2a                	mv	s4,a0
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
     77a:	02000613          	li	a2,32
     77e:	fa040593          	addi	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	51a040ef          	jal	4c9e <read>
     788:	8a2a                	mv	s4,a0
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	dea58593          	addi	a1,a1,-534 # 5578 <malloc+0x40a>
     796:	854e                	mv	a0,s3
     798:	50e040ef          	jal	4ca6 <write>
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	addi	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	4f8040ef          	jal	4c9e <read>
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	addi	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	4e4040ef          	jal	4c9e <read>
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
     7c4:	00005517          	auipc	a0,0x5
     7c8:	b3c50513          	addi	a0,a0,-1220 # 5300 <malloc+0x192>
     7cc:	50a040ef          	jal	4cd6 <unlink>
     7d0:	854e                	mv	a0,s3
     7d2:	4dc040ef          	jal	4cae <close>
     7d6:	8526                	mv	a0,s1
     7d8:	4d6040ef          	jal	4cae <close>
     7dc:	854a                	mv	a0,s2
     7de:	4d0040ef          	jal	4cae <close>
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	addi	sp,sp,96
     7f2:	8082                	ret
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	d2050513          	addi	a0,a0,-736 # 5518 <malloc+0x3aa>
     800:	0bb040ef          	jal	50ba <printf>
     804:	4505                	li	a0,1
     806:	480040ef          	jal	4c86 <exit>
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	d2c50513          	addi	a0,a0,-724 # 5538 <malloc+0x3ca>
     814:	0a7040ef          	jal	50ba <printf>
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	d2c50513          	addi	a0,a0,-724 # 5548 <malloc+0x3da>
     824:	097040ef          	jal	50ba <printf>
     828:	4505                	li	a0,1
     82a:	45c040ef          	jal	4c86 <exit>
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	d3850513          	addi	a0,a0,-712 # 5568 <malloc+0x3fa>
     838:	083040ef          	jal	50ba <printf>
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	d0850513          	addi	a0,a0,-760 # 5548 <malloc+0x3da>
     848:	073040ef          	jal	50ba <printf>
     84c:	4505                	li	a0,1
     84e:	438040ef          	jal	4c86 <exit>
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	d2a50513          	addi	a0,a0,-726 # 5580 <malloc+0x412>
     85e:	05d040ef          	jal	50ba <printf>
     862:	4505                	li	a0,1
     864:	422040ef          	jal	4c86 <exit>
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	d3450513          	addi	a0,a0,-716 # 55a0 <malloc+0x432>
     874:	047040ef          	jal	50ba <printf>
     878:	4505                	li	a0,1
     87a:	40c040ef          	jal	4c86 <exit>

000000000000087e <writetest>:
     87e:	7139                	addi	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	addi	s0,sp,64
     892:	8b2a                	mv	s6,a0
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	d2850513          	addi	a0,a0,-728 # 55c0 <malloc+0x452>
     8a0:	426040ef          	jal	4cc6 <open>
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
     8ac:	00005997          	auipc	s3,0x5
     8b0:	d3c98993          	addi	s3,s3,-708 # 55e8 <malloc+0x47a>
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	d6ca8a93          	addi	s5,s5,-660 # 5620 <malloc+0x4b2>
     8bc:	06400a13          	li	s4,100
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	3e0040ef          	jal	4ca6 <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	3d0040ef          	jal	4ca6 <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
     8e0:	2485                	addiw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
     8e6:	854a                	mv	a0,s2
     8e8:	3c6040ef          	jal	4cae <close>
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	cd250513          	addi	a0,a0,-814 # 55c0 <malloc+0x452>
     8f6:	3d0040ef          	jal	4cc6 <open>
     8fa:	84aa                	mv	s1,a0
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
     900:	7d000613          	li	a2,2000
     904:	0000c597          	auipc	a1,0xc
     908:	3a458593          	addi	a1,a1,932 # cca8 <buf>
     90c:	392040ef          	jal	4c9e <read>
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
     918:	8526                	mv	a0,s1
     91a:	394040ef          	jal	4cae <close>
     91e:	00005517          	auipc	a0,0x5
     922:	ca250513          	addi	a0,a0,-862 # 55c0 <malloc+0x452>
     926:	3b0040ef          	jal	4cd6 <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	addi	sp,sp,64
     940:	8082                	ret
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	c8450513          	addi	a0,a0,-892 # 55c8 <malloc+0x45a>
     94c:	76e040ef          	jal	50ba <printf>
     950:	4505                	li	a0,1
     952:	334040ef          	jal	4c86 <exit>
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	c9e50513          	addi	a0,a0,-866 # 55f8 <malloc+0x48a>
     962:	758040ef          	jal	50ba <printf>
     966:	4505                	li	a0,1
     968:	31e040ef          	jal	4c86 <exit>
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	cc050513          	addi	a0,a0,-832 # 5630 <malloc+0x4c2>
     978:	742040ef          	jal	50ba <printf>
     97c:	4505                	li	a0,1
     97e:	308040ef          	jal	4c86 <exit>
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	cd450513          	addi	a0,a0,-812 # 5658 <malloc+0x4ea>
     98c:	72e040ef          	jal	50ba <printf>
     990:	4505                	li	a0,1
     992:	2f4040ef          	jal	4c86 <exit>
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	ce050513          	addi	a0,a0,-800 # 5678 <malloc+0x50a>
     9a0:	71a040ef          	jal	50ba <printf>
     9a4:	4505                	li	a0,1
     9a6:	2e0040ef          	jal	4c86 <exit>
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	ce450513          	addi	a0,a0,-796 # 5690 <malloc+0x522>
     9b4:	706040ef          	jal	50ba <printf>
     9b8:	4505                	li	a0,1
     9ba:	2cc040ef          	jal	4c86 <exit>

00000000000009be <writebig>:
     9be:	7139                	addi	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	addi	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	cda50513          	addi	a0,a0,-806 # 56b0 <malloc+0x542>
     9de:	2e8040ef          	jal	4cc6 <open>
     9e2:	89aa                	mv	s3,a0
     9e4:	4481                	li	s1,0
     9e6:	0000c917          	auipc	s2,0xc
     9ea:	2c290913          	addi	s2,s2,706 # cca8 <buf>
     9ee:	10c00a13          	li	s4,268
     9f2:	06054463          	bltz	a0,a5a <writebig+0x9c>
     9f6:	00992023          	sw	s1,0(s2)
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	2a4040ef          	jal	4ca6 <write>
     a06:	40000793          	li	a5,1024
     a0a:	06f51263          	bne	a0,a5,a6e <writebig+0xb0>
     a0e:	2485                	addiw	s1,s1,1
     a10:	ff4493e3          	bne	s1,s4,9f6 <writebig+0x38>
     a14:	854e                	mv	a0,s3
     a16:	298040ef          	jal	4cae <close>
     a1a:	4581                	li	a1,0
     a1c:	00005517          	auipc	a0,0x5
     a20:	c9450513          	addi	a0,a0,-876 # 56b0 <malloc+0x542>
     a24:	2a2040ef          	jal	4cc6 <open>
     a28:	89aa                	mv	s3,a0
     a2a:	4481                	li	s1,0
     a2c:	0000c917          	auipc	s2,0xc
     a30:	27c90913          	addi	s2,s2,636 # cca8 <buf>
     a34:	04054863          	bltz	a0,a84 <writebig+0xc6>
     a38:	40000613          	li	a2,1024
     a3c:	85ca                	mv	a1,s2
     a3e:	854e                	mv	a0,s3
     a40:	25e040ef          	jal	4c9e <read>
     a44:	c931                	beqz	a0,a98 <writebig+0xda>
     a46:	40000793          	li	a5,1024
     a4a:	08f51a63          	bne	a0,a5,ade <writebig+0x120>
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0a969163          	bne	a3,s1,af4 <writebig+0x136>
     a56:	2485                	addiw	s1,s1,1
     a58:	b7c5                	j	a38 <writebig+0x7a>
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	c5c50513          	addi	a0,a0,-932 # 56b8 <malloc+0x54a>
     a64:	656040ef          	jal	50ba <printf>
     a68:	4505                	li	a0,1
     a6a:	21c040ef          	jal	4c86 <exit>
     a6e:	8626                	mv	a2,s1
     a70:	85d6                	mv	a1,s5
     a72:	00005517          	auipc	a0,0x5
     a76:	c6650513          	addi	a0,a0,-922 # 56d8 <malloc+0x56a>
     a7a:	640040ef          	jal	50ba <printf>
     a7e:	4505                	li	a0,1
     a80:	206040ef          	jal	4c86 <exit>
     a84:	85d6                	mv	a1,s5
     a86:	00005517          	auipc	a0,0x5
     a8a:	c7a50513          	addi	a0,a0,-902 # 5700 <malloc+0x592>
     a8e:	62c040ef          	jal	50ba <printf>
     a92:	4505                	li	a0,1
     a94:	1f2040ef          	jal	4c86 <exit>
     a98:	10c00793          	li	a5,268
     a9c:	02f49663          	bne	s1,a5,ac8 <writebig+0x10a>
     aa0:	854e                	mv	a0,s3
     aa2:	20c040ef          	jal	4cae <close>
     aa6:	00005517          	auipc	a0,0x5
     aaa:	c0a50513          	addi	a0,a0,-1014 # 56b0 <malloc+0x542>
     aae:	228040ef          	jal	4cd6 <unlink>
     ab2:	04054c63          	bltz	a0,b0a <writebig+0x14c>
     ab6:	70e2                	ld	ra,56(sp)
     ab8:	7442                	ld	s0,48(sp)
     aba:	74a2                	ld	s1,40(sp)
     abc:	7902                	ld	s2,32(sp)
     abe:	69e2                	ld	s3,24(sp)
     ac0:	6a42                	ld	s4,16(sp)
     ac2:	6aa2                	ld	s5,8(sp)
     ac4:	6121                	addi	sp,sp,64
     ac6:	8082                	ret
     ac8:	8626                	mv	a2,s1
     aca:	85d6                	mv	a1,s5
     acc:	00005517          	auipc	a0,0x5
     ad0:	c5450513          	addi	a0,a0,-940 # 5720 <malloc+0x5b2>
     ad4:	5e6040ef          	jal	50ba <printf>
     ad8:	4505                	li	a0,1
     ada:	1ac040ef          	jal	4c86 <exit>
     ade:	862a                	mv	a2,a0
     ae0:	85d6                	mv	a1,s5
     ae2:	00005517          	auipc	a0,0x5
     ae6:	c6650513          	addi	a0,a0,-922 # 5748 <malloc+0x5da>
     aea:	5d0040ef          	jal	50ba <printf>
     aee:	4505                	li	a0,1
     af0:	196040ef          	jal	4c86 <exit>
     af4:	8626                	mv	a2,s1
     af6:	85d6                	mv	a1,s5
     af8:	00005517          	auipc	a0,0x5
     afc:	c6850513          	addi	a0,a0,-920 # 5760 <malloc+0x5f2>
     b00:	5ba040ef          	jal	50ba <printf>
     b04:	4505                	li	a0,1
     b06:	180040ef          	jal	4c86 <exit>
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	c7c50513          	addi	a0,a0,-900 # 5788 <malloc+0x61a>
     b14:	5a6040ef          	jal	50ba <printf>
     b18:	4505                	li	a0,1
     b1a:	16c040ef          	jal	4c86 <exit>

0000000000000b1e <unlinkread>:
     b1e:	7179                	addi	sp,sp,-48
     b20:	f406                	sd	ra,40(sp)
     b22:	f022                	sd	s0,32(sp)
     b24:	ec26                	sd	s1,24(sp)
     b26:	e84a                	sd	s2,16(sp)
     b28:	e44e                	sd	s3,8(sp)
     b2a:	1800                	addi	s0,sp,48
     b2c:	89aa                	mv	s3,a0
     b2e:	20200593          	li	a1,514
     b32:	00005517          	auipc	a0,0x5
     b36:	c6e50513          	addi	a0,a0,-914 # 57a0 <malloc+0x632>
     b3a:	18c040ef          	jal	4cc6 <open>
     b3e:	0a054f63          	bltz	a0,bfc <unlinkread+0xde>
     b42:	84aa                	mv	s1,a0
     b44:	4615                	li	a2,5
     b46:	00005597          	auipc	a1,0x5
     b4a:	c8a58593          	addi	a1,a1,-886 # 57d0 <malloc+0x662>
     b4e:	158040ef          	jal	4ca6 <write>
     b52:	8526                	mv	a0,s1
     b54:	15a040ef          	jal	4cae <close>
     b58:	4589                	li	a1,2
     b5a:	00005517          	auipc	a0,0x5
     b5e:	c4650513          	addi	a0,a0,-954 # 57a0 <malloc+0x632>
     b62:	164040ef          	jal	4cc6 <open>
     b66:	84aa                	mv	s1,a0
     b68:	0a054463          	bltz	a0,c10 <unlinkread+0xf2>
     b6c:	00005517          	auipc	a0,0x5
     b70:	c3450513          	addi	a0,a0,-972 # 57a0 <malloc+0x632>
     b74:	162040ef          	jal	4cd6 <unlink>
     b78:	e555                	bnez	a0,c24 <unlinkread+0x106>
     b7a:	20200593          	li	a1,514
     b7e:	00005517          	auipc	a0,0x5
     b82:	c2250513          	addi	a0,a0,-990 # 57a0 <malloc+0x632>
     b86:	140040ef          	jal	4cc6 <open>
     b8a:	892a                	mv	s2,a0
     b8c:	460d                	li	a2,3
     b8e:	00005597          	auipc	a1,0x5
     b92:	c8a58593          	addi	a1,a1,-886 # 5818 <malloc+0x6aa>
     b96:	110040ef          	jal	4ca6 <write>
     b9a:	854a                	mv	a0,s2
     b9c:	112040ef          	jal	4cae <close>
     ba0:	660d                	lui	a2,0x3
     ba2:	0000c597          	auipc	a1,0xc
     ba6:	10658593          	addi	a1,a1,262 # cca8 <buf>
     baa:	8526                	mv	a0,s1
     bac:	0f2040ef          	jal	4c9e <read>
     bb0:	4795                	li	a5,5
     bb2:	08f51363          	bne	a0,a5,c38 <unlinkread+0x11a>
     bb6:	0000c717          	auipc	a4,0xc
     bba:	0f274703          	lbu	a4,242(a4) # cca8 <buf>
     bbe:	06800793          	li	a5,104
     bc2:	08f71563          	bne	a4,a5,c4c <unlinkread+0x12e>
     bc6:	4629                	li	a2,10
     bc8:	0000c597          	auipc	a1,0xc
     bcc:	0e058593          	addi	a1,a1,224 # cca8 <buf>
     bd0:	8526                	mv	a0,s1
     bd2:	0d4040ef          	jal	4ca6 <write>
     bd6:	47a9                	li	a5,10
     bd8:	08f51463          	bne	a0,a5,c60 <unlinkread+0x142>
     bdc:	8526                	mv	a0,s1
     bde:	0d0040ef          	jal	4cae <close>
     be2:	00005517          	auipc	a0,0x5
     be6:	bbe50513          	addi	a0,a0,-1090 # 57a0 <malloc+0x632>
     bea:	0ec040ef          	jal	4cd6 <unlink>
     bee:	70a2                	ld	ra,40(sp)
     bf0:	7402                	ld	s0,32(sp)
     bf2:	64e2                	ld	s1,24(sp)
     bf4:	6942                	ld	s2,16(sp)
     bf6:	69a2                	ld	s3,8(sp)
     bf8:	6145                	addi	sp,sp,48
     bfa:	8082                	ret
     bfc:	85ce                	mv	a1,s3
     bfe:	00005517          	auipc	a0,0x5
     c02:	bb250513          	addi	a0,a0,-1102 # 57b0 <malloc+0x642>
     c06:	4b4040ef          	jal	50ba <printf>
     c0a:	4505                	li	a0,1
     c0c:	07a040ef          	jal	4c86 <exit>
     c10:	85ce                	mv	a1,s3
     c12:	00005517          	auipc	a0,0x5
     c16:	bc650513          	addi	a0,a0,-1082 # 57d8 <malloc+0x66a>
     c1a:	4a0040ef          	jal	50ba <printf>
     c1e:	4505                	li	a0,1
     c20:	066040ef          	jal	4c86 <exit>
     c24:	85ce                	mv	a1,s3
     c26:	00005517          	auipc	a0,0x5
     c2a:	bd250513          	addi	a0,a0,-1070 # 57f8 <malloc+0x68a>
     c2e:	48c040ef          	jal	50ba <printf>
     c32:	4505                	li	a0,1
     c34:	052040ef          	jal	4c86 <exit>
     c38:	85ce                	mv	a1,s3
     c3a:	00005517          	auipc	a0,0x5
     c3e:	be650513          	addi	a0,a0,-1050 # 5820 <malloc+0x6b2>
     c42:	478040ef          	jal	50ba <printf>
     c46:	4505                	li	a0,1
     c48:	03e040ef          	jal	4c86 <exit>
     c4c:	85ce                	mv	a1,s3
     c4e:	00005517          	auipc	a0,0x5
     c52:	bf250513          	addi	a0,a0,-1038 # 5840 <malloc+0x6d2>
     c56:	464040ef          	jal	50ba <printf>
     c5a:	4505                	li	a0,1
     c5c:	02a040ef          	jal	4c86 <exit>
     c60:	85ce                	mv	a1,s3
     c62:	00005517          	auipc	a0,0x5
     c66:	bfe50513          	addi	a0,a0,-1026 # 5860 <malloc+0x6f2>
     c6a:	450040ef          	jal	50ba <printf>
     c6e:	4505                	li	a0,1
     c70:	016040ef          	jal	4c86 <exit>

0000000000000c74 <linktest>:
     c74:	1101                	addi	sp,sp,-32
     c76:	ec06                	sd	ra,24(sp)
     c78:	e822                	sd	s0,16(sp)
     c7a:	e426                	sd	s1,8(sp)
     c7c:	e04a                	sd	s2,0(sp)
     c7e:	1000                	addi	s0,sp,32
     c80:	892a                	mv	s2,a0
     c82:	00005517          	auipc	a0,0x5
     c86:	bfe50513          	addi	a0,a0,-1026 # 5880 <malloc+0x712>
     c8a:	04c040ef          	jal	4cd6 <unlink>
     c8e:	00005517          	auipc	a0,0x5
     c92:	bfa50513          	addi	a0,a0,-1030 # 5888 <malloc+0x71a>
     c96:	040040ef          	jal	4cd6 <unlink>
     c9a:	20200593          	li	a1,514
     c9e:	00005517          	auipc	a0,0x5
     ca2:	be250513          	addi	a0,a0,-1054 # 5880 <malloc+0x712>
     ca6:	020040ef          	jal	4cc6 <open>
     caa:	0c054f63          	bltz	a0,d88 <linktest+0x114>
     cae:	84aa                	mv	s1,a0
     cb0:	4615                	li	a2,5
     cb2:	00005597          	auipc	a1,0x5
     cb6:	b1e58593          	addi	a1,a1,-1250 # 57d0 <malloc+0x662>
     cba:	7ed030ef          	jal	4ca6 <write>
     cbe:	4795                	li	a5,5
     cc0:	0cf51e63          	bne	a0,a5,d9c <linktest+0x128>
     cc4:	8526                	mv	a0,s1
     cc6:	7e9030ef          	jal	4cae <close>
     cca:	00005597          	auipc	a1,0x5
     cce:	bbe58593          	addi	a1,a1,-1090 # 5888 <malloc+0x71a>
     cd2:	00005517          	auipc	a0,0x5
     cd6:	bae50513          	addi	a0,a0,-1106 # 5880 <malloc+0x712>
     cda:	00c040ef          	jal	4ce6 <link>
     cde:	0c054963          	bltz	a0,db0 <linktest+0x13c>
     ce2:	00005517          	auipc	a0,0x5
     ce6:	b9e50513          	addi	a0,a0,-1122 # 5880 <malloc+0x712>
     cea:	7ed030ef          	jal	4cd6 <unlink>
     cee:	4581                	li	a1,0
     cf0:	00005517          	auipc	a0,0x5
     cf4:	b9050513          	addi	a0,a0,-1136 # 5880 <malloc+0x712>
     cf8:	7cf030ef          	jal	4cc6 <open>
     cfc:	0c055463          	bgez	a0,dc4 <linktest+0x150>
     d00:	4581                	li	a1,0
     d02:	00005517          	auipc	a0,0x5
     d06:	b8650513          	addi	a0,a0,-1146 # 5888 <malloc+0x71a>
     d0a:	7bd030ef          	jal	4cc6 <open>
     d0e:	84aa                	mv	s1,a0
     d10:	0c054463          	bltz	a0,dd8 <linktest+0x164>
     d14:	660d                	lui	a2,0x3
     d16:	0000c597          	auipc	a1,0xc
     d1a:	f9258593          	addi	a1,a1,-110 # cca8 <buf>
     d1e:	781030ef          	jal	4c9e <read>
     d22:	4795                	li	a5,5
     d24:	0cf51463          	bne	a0,a5,dec <linktest+0x178>
     d28:	8526                	mv	a0,s1
     d2a:	785030ef          	jal	4cae <close>
     d2e:	00005597          	auipc	a1,0x5
     d32:	b5a58593          	addi	a1,a1,-1190 # 5888 <malloc+0x71a>
     d36:	852e                	mv	a0,a1
     d38:	7af030ef          	jal	4ce6 <link>
     d3c:	0c055263          	bgez	a0,e00 <linktest+0x18c>
     d40:	00005517          	auipc	a0,0x5
     d44:	b4850513          	addi	a0,a0,-1208 # 5888 <malloc+0x71a>
     d48:	78f030ef          	jal	4cd6 <unlink>
     d4c:	00005597          	auipc	a1,0x5
     d50:	b3458593          	addi	a1,a1,-1228 # 5880 <malloc+0x712>
     d54:	00005517          	auipc	a0,0x5
     d58:	b3450513          	addi	a0,a0,-1228 # 5888 <malloc+0x71a>
     d5c:	78b030ef          	jal	4ce6 <link>
     d60:	0a055a63          	bgez	a0,e14 <linktest+0x1a0>
     d64:	00005597          	auipc	a1,0x5
     d68:	b1c58593          	addi	a1,a1,-1252 # 5880 <malloc+0x712>
     d6c:	00005517          	auipc	a0,0x5
     d70:	c2450513          	addi	a0,a0,-988 # 5990 <malloc+0x822>
     d74:	773030ef          	jal	4ce6 <link>
     d78:	0a055863          	bgez	a0,e28 <linktest+0x1b4>
     d7c:	60e2                	ld	ra,24(sp)
     d7e:	6442                	ld	s0,16(sp)
     d80:	64a2                	ld	s1,8(sp)
     d82:	6902                	ld	s2,0(sp)
     d84:	6105                	addi	sp,sp,32
     d86:	8082                	ret
     d88:	85ca                	mv	a1,s2
     d8a:	00005517          	auipc	a0,0x5
     d8e:	b0650513          	addi	a0,a0,-1274 # 5890 <malloc+0x722>
     d92:	328040ef          	jal	50ba <printf>
     d96:	4505                	li	a0,1
     d98:	6ef030ef          	jal	4c86 <exit>
     d9c:	85ca                	mv	a1,s2
     d9e:	00005517          	auipc	a0,0x5
     da2:	b0a50513          	addi	a0,a0,-1270 # 58a8 <malloc+0x73a>
     da6:	314040ef          	jal	50ba <printf>
     daa:	4505                	li	a0,1
     dac:	6db030ef          	jal	4c86 <exit>
     db0:	85ca                	mv	a1,s2
     db2:	00005517          	auipc	a0,0x5
     db6:	b0e50513          	addi	a0,a0,-1266 # 58c0 <malloc+0x752>
     dba:	300040ef          	jal	50ba <printf>
     dbe:	4505                	li	a0,1
     dc0:	6c7030ef          	jal	4c86 <exit>
     dc4:	85ca                	mv	a1,s2
     dc6:	00005517          	auipc	a0,0x5
     dca:	b1a50513          	addi	a0,a0,-1254 # 58e0 <malloc+0x772>
     dce:	2ec040ef          	jal	50ba <printf>
     dd2:	4505                	li	a0,1
     dd4:	6b3030ef          	jal	4c86 <exit>
     dd8:	85ca                	mv	a1,s2
     dda:	00005517          	auipc	a0,0x5
     dde:	b3650513          	addi	a0,a0,-1226 # 5910 <malloc+0x7a2>
     de2:	2d8040ef          	jal	50ba <printf>
     de6:	4505                	li	a0,1
     de8:	69f030ef          	jal	4c86 <exit>
     dec:	85ca                	mv	a1,s2
     dee:	00005517          	auipc	a0,0x5
     df2:	b3a50513          	addi	a0,a0,-1222 # 5928 <malloc+0x7ba>
     df6:	2c4040ef          	jal	50ba <printf>
     dfa:	4505                	li	a0,1
     dfc:	68b030ef          	jal	4c86 <exit>
     e00:	85ca                	mv	a1,s2
     e02:	00005517          	auipc	a0,0x5
     e06:	b3e50513          	addi	a0,a0,-1218 # 5940 <malloc+0x7d2>
     e0a:	2b0040ef          	jal	50ba <printf>
     e0e:	4505                	li	a0,1
     e10:	677030ef          	jal	4c86 <exit>
     e14:	85ca                	mv	a1,s2
     e16:	00005517          	auipc	a0,0x5
     e1a:	b5250513          	addi	a0,a0,-1198 # 5968 <malloc+0x7fa>
     e1e:	29c040ef          	jal	50ba <printf>
     e22:	4505                	li	a0,1
     e24:	663030ef          	jal	4c86 <exit>
     e28:	85ca                	mv	a1,s2
     e2a:	00005517          	auipc	a0,0x5
     e2e:	b6e50513          	addi	a0,a0,-1170 # 5998 <malloc+0x82a>
     e32:	288040ef          	jal	50ba <printf>
     e36:	4505                	li	a0,1
     e38:	64f030ef          	jal	4c86 <exit>

0000000000000e3c <validatetest>:
     e3c:	7139                	addi	sp,sp,-64
     e3e:	fc06                	sd	ra,56(sp)
     e40:	f822                	sd	s0,48(sp)
     e42:	f426                	sd	s1,40(sp)
     e44:	f04a                	sd	s2,32(sp)
     e46:	ec4e                	sd	s3,24(sp)
     e48:	e852                	sd	s4,16(sp)
     e4a:	e456                	sd	s5,8(sp)
     e4c:	e05a                	sd	s6,0(sp)
     e4e:	0080                	addi	s0,sp,64
     e50:	8b2a                	mv	s6,a0
     e52:	4481                	li	s1,0
     e54:	00005997          	auipc	s3,0x5
     e58:	b6498993          	addi	s3,s3,-1180 # 59b8 <malloc+0x84a>
     e5c:	597d                	li	s2,-1
     e5e:	6a85                	lui	s5,0x1
     e60:	00114a37          	lui	s4,0x114
     e64:	85a6                	mv	a1,s1
     e66:	854e                	mv	a0,s3
     e68:	67f030ef          	jal	4ce6 <link>
     e6c:	01251f63          	bne	a0,s2,e8a <validatetest+0x4e>
     e70:	94d6                	add	s1,s1,s5
     e72:	ff4499e3          	bne	s1,s4,e64 <validatetest+0x28>
     e76:	70e2                	ld	ra,56(sp)
     e78:	7442                	ld	s0,48(sp)
     e7a:	74a2                	ld	s1,40(sp)
     e7c:	7902                	ld	s2,32(sp)
     e7e:	69e2                	ld	s3,24(sp)
     e80:	6a42                	ld	s4,16(sp)
     e82:	6aa2                	ld	s5,8(sp)
     e84:	6b02                	ld	s6,0(sp)
     e86:	6121                	addi	sp,sp,64
     e88:	8082                	ret
     e8a:	85da                	mv	a1,s6
     e8c:	00005517          	auipc	a0,0x5
     e90:	b3c50513          	addi	a0,a0,-1220 # 59c8 <malloc+0x85a>
     e94:	226040ef          	jal	50ba <printf>
     e98:	4505                	li	a0,1
     e9a:	5ed030ef          	jal	4c86 <exit>

0000000000000e9e <bigdir>:
     e9e:	715d                	addi	sp,sp,-80
     ea0:	e486                	sd	ra,72(sp)
     ea2:	e0a2                	sd	s0,64(sp)
     ea4:	fc26                	sd	s1,56(sp)
     ea6:	f84a                	sd	s2,48(sp)
     ea8:	f44e                	sd	s3,40(sp)
     eaa:	f052                	sd	s4,32(sp)
     eac:	ec56                	sd	s5,24(sp)
     eae:	e85a                	sd	s6,16(sp)
     eb0:	0880                	addi	s0,sp,80
     eb2:	89aa                	mv	s3,a0
     eb4:	00005517          	auipc	a0,0x5
     eb8:	b3450513          	addi	a0,a0,-1228 # 59e8 <malloc+0x87a>
     ebc:	61b030ef          	jal	4cd6 <unlink>
     ec0:	20000593          	li	a1,512
     ec4:	00005517          	auipc	a0,0x5
     ec8:	b2450513          	addi	a0,a0,-1244 # 59e8 <malloc+0x87a>
     ecc:	5fb030ef          	jal	4cc6 <open>
     ed0:	0c054163          	bltz	a0,f92 <bigdir+0xf4>
     ed4:	5db030ef          	jal	4cae <close>
     ed8:	4901                	li	s2,0
     eda:	07800a93          	li	s5,120
     ede:	00005a17          	auipc	s4,0x5
     ee2:	b0aa0a13          	addi	s4,s4,-1270 # 59e8 <malloc+0x87a>
     ee6:	1f400b13          	li	s6,500
     eea:	fb540823          	sb	s5,-80(s0)
     eee:	41f9571b          	sraiw	a4,s2,0x1f
     ef2:	01a7571b          	srliw	a4,a4,0x1a
     ef6:	012707bb          	addw	a5,a4,s2
     efa:	4067d69b          	sraiw	a3,a5,0x6
     efe:	0306869b          	addiw	a3,a3,48
     f02:	fad408a3          	sb	a3,-79(s0)
     f06:	03f7f793          	andi	a5,a5,63
     f0a:	9f99                	subw	a5,a5,a4
     f0c:	0307879b          	addiw	a5,a5,48
     f10:	faf40923          	sb	a5,-78(s0)
     f14:	fa0409a3          	sb	zero,-77(s0)
     f18:	fb040593          	addi	a1,s0,-80
     f1c:	8552                	mv	a0,s4
     f1e:	5c9030ef          	jal	4ce6 <link>
     f22:	84aa                	mv	s1,a0
     f24:	e149                	bnez	a0,fa6 <bigdir+0x108>
     f26:	2905                	addiw	s2,s2,1
     f28:	fd6911e3          	bne	s2,s6,eea <bigdir+0x4c>
     f2c:	00005517          	auipc	a0,0x5
     f30:	abc50513          	addi	a0,a0,-1348 # 59e8 <malloc+0x87a>
     f34:	5a3030ef          	jal	4cd6 <unlink>
     f38:	07800913          	li	s2,120
     f3c:	1f400a13          	li	s4,500
     f40:	fb240823          	sb	s2,-80(s0)
     f44:	41f4d71b          	sraiw	a4,s1,0x1f
     f48:	01a7571b          	srliw	a4,a4,0x1a
     f4c:	009707bb          	addw	a5,a4,s1
     f50:	4067d69b          	sraiw	a3,a5,0x6
     f54:	0306869b          	addiw	a3,a3,48
     f58:	fad408a3          	sb	a3,-79(s0)
     f5c:	03f7f793          	andi	a5,a5,63
     f60:	9f99                	subw	a5,a5,a4
     f62:	0307879b          	addiw	a5,a5,48
     f66:	faf40923          	sb	a5,-78(s0)
     f6a:	fa0409a3          	sb	zero,-77(s0)
     f6e:	fb040513          	addi	a0,s0,-80
     f72:	565030ef          	jal	4cd6 <unlink>
     f76:	e529                	bnez	a0,fc0 <bigdir+0x122>
     f78:	2485                	addiw	s1,s1,1
     f7a:	fd4493e3          	bne	s1,s4,f40 <bigdir+0xa2>
     f7e:	60a6                	ld	ra,72(sp)
     f80:	6406                	ld	s0,64(sp)
     f82:	74e2                	ld	s1,56(sp)
     f84:	7942                	ld	s2,48(sp)
     f86:	79a2                	ld	s3,40(sp)
     f88:	7a02                	ld	s4,32(sp)
     f8a:	6ae2                	ld	s5,24(sp)
     f8c:	6b42                	ld	s6,16(sp)
     f8e:	6161                	addi	sp,sp,80
     f90:	8082                	ret
     f92:	85ce                	mv	a1,s3
     f94:	00005517          	auipc	a0,0x5
     f98:	a5c50513          	addi	a0,a0,-1444 # 59f0 <malloc+0x882>
     f9c:	11e040ef          	jal	50ba <printf>
     fa0:	4505                	li	a0,1
     fa2:	4e5030ef          	jal	4c86 <exit>
     fa6:	fb040693          	addi	a3,s0,-80
     faa:	864a                	mv	a2,s2
     fac:	85ce                	mv	a1,s3
     fae:	00005517          	auipc	a0,0x5
     fb2:	a6250513          	addi	a0,a0,-1438 # 5a10 <malloc+0x8a2>
     fb6:	104040ef          	jal	50ba <printf>
     fba:	4505                	li	a0,1
     fbc:	4cb030ef          	jal	4c86 <exit>
     fc0:	85ce                	mv	a1,s3
     fc2:	00005517          	auipc	a0,0x5
     fc6:	a7650513          	addi	a0,a0,-1418 # 5a38 <malloc+0x8ca>
     fca:	0f0040ef          	jal	50ba <printf>
     fce:	4505                	li	a0,1
     fd0:	4b7030ef          	jal	4c86 <exit>

0000000000000fd4 <pgbug>:
     fd4:	7179                	addi	sp,sp,-48
     fd6:	f406                	sd	ra,40(sp)
     fd8:	f022                	sd	s0,32(sp)
     fda:	ec26                	sd	s1,24(sp)
     fdc:	1800                	addi	s0,sp,48
     fde:	fc043c23          	sd	zero,-40(s0)
     fe2:	00008497          	auipc	s1,0x8
     fe6:	01e48493          	addi	s1,s1,30 # 9000 <big>
     fea:	fd840593          	addi	a1,s0,-40
     fee:	6088                	ld	a0,0(s1)
     ff0:	4cf030ef          	jal	4cbe <exec>
     ff4:	6088                	ld	a0,0(s1)
     ff6:	4a1030ef          	jal	4c96 <pipe>
     ffa:	4501                	li	a0,0
     ffc:	48b030ef          	jal	4c86 <exit>

0000000000001000 <badarg>:
    1000:	7139                	addi	sp,sp,-64
    1002:	fc06                	sd	ra,56(sp)
    1004:	f822                	sd	s0,48(sp)
    1006:	f426                	sd	s1,40(sp)
    1008:	f04a                	sd	s2,32(sp)
    100a:	ec4e                	sd	s3,24(sp)
    100c:	0080                	addi	s0,sp,64
    100e:	64b1                	lui	s1,0xc
    1010:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1db8>
    1014:	597d                	li	s2,-1
    1016:	02095913          	srli	s2,s2,0x20
    101a:	00004997          	auipc	s3,0x4
    101e:	28e98993          	addi	s3,s3,654 # 52a8 <malloc+0x13a>
    1022:	fd243023          	sd	s2,-64(s0)
    1026:	fc043423          	sd	zero,-56(s0)
    102a:	fc040593          	addi	a1,s0,-64
    102e:	854e                	mv	a0,s3
    1030:	48f030ef          	jal	4cbe <exec>
    1034:	34fd                	addiw	s1,s1,-1
    1036:	f4f5                	bnez	s1,1022 <badarg+0x22>
    1038:	4501                	li	a0,0
    103a:	44d030ef          	jal	4c86 <exit>

000000000000103e <copyinstr2>:
    103e:	7155                	addi	sp,sp,-208
    1040:	e586                	sd	ra,200(sp)
    1042:	e1a2                	sd	s0,192(sp)
    1044:	0980                	addi	s0,sp,208
    1046:	f6840793          	addi	a5,s0,-152
    104a:	fe840693          	addi	a3,s0,-24
    104e:	07800713          	li	a4,120
    1052:	00e78023          	sb	a4,0(a5)
    1056:	0785                	addi	a5,a5,1
    1058:	fed79de3          	bne	a5,a3,1052 <copyinstr2+0x14>
    105c:	fe040423          	sb	zero,-24(s0)
    1060:	f6840513          	addi	a0,s0,-152
    1064:	473030ef          	jal	4cd6 <unlink>
    1068:	57fd                	li	a5,-1
    106a:	0cf51263          	bne	a0,a5,112e <copyinstr2+0xf0>
    106e:	20100593          	li	a1,513
    1072:	f6840513          	addi	a0,s0,-152
    1076:	451030ef          	jal	4cc6 <open>
    107a:	57fd                	li	a5,-1
    107c:	0cf51563          	bne	a0,a5,1146 <copyinstr2+0x108>
    1080:	f6840593          	addi	a1,s0,-152
    1084:	852e                	mv	a0,a1
    1086:	461030ef          	jal	4ce6 <link>
    108a:	57fd                	li	a5,-1
    108c:	0cf51963          	bne	a0,a5,115e <copyinstr2+0x120>
    1090:	00006797          	auipc	a5,0x6
    1094:	af878793          	addi	a5,a5,-1288 # 6b88 <malloc+0x1a1a>
    1098:	f4f43c23          	sd	a5,-168(s0)
    109c:	f6043023          	sd	zero,-160(s0)
    10a0:	f5840593          	addi	a1,s0,-168
    10a4:	f6840513          	addi	a0,s0,-152
    10a8:	417030ef          	jal	4cbe <exec>
    10ac:	57fd                	li	a5,-1
    10ae:	0cf51563          	bne	a0,a5,1178 <copyinstr2+0x13a>
    10b2:	3cd030ef          	jal	4c7e <fork>
    10b6:	0c054d63          	bltz	a0,1190 <copyinstr2+0x152>
    10ba:	0e051863          	bnez	a0,11aa <copyinstr2+0x16c>
    10be:	00008797          	auipc	a5,0x8
    10c2:	4d278793          	addi	a5,a5,1234 # 9590 <big.0>
    10c6:	00009697          	auipc	a3,0x9
    10ca:	4ca68693          	addi	a3,a3,1226 # a590 <big.0+0x1000>
    10ce:	07800713          	li	a4,120
    10d2:	00e78023          	sb	a4,0(a5)
    10d6:	0785                	addi	a5,a5,1
    10d8:	fed79de3          	bne	a5,a3,10d2 <copyinstr2+0x94>
    10dc:	00009797          	auipc	a5,0x9
    10e0:	4a078a23          	sb	zero,1204(a5) # a590 <big.0+0x1000>
    10e4:	00006797          	auipc	a5,0x6
    10e8:	61478793          	addi	a5,a5,1556 # 76f8 <malloc+0x258a>
    10ec:	6fb0                	ld	a2,88(a5)
    10ee:	73b4                	ld	a3,96(a5)
    10f0:	77b8                	ld	a4,104(a5)
    10f2:	7bbc                	ld	a5,112(a5)
    10f4:	f2c43823          	sd	a2,-208(s0)
    10f8:	f2d43c23          	sd	a3,-200(s0)
    10fc:	f4e43023          	sd	a4,-192(s0)
    1100:	f4f43423          	sd	a5,-184(s0)
    1104:	f3040593          	addi	a1,s0,-208
    1108:	00004517          	auipc	a0,0x4
    110c:	1a050513          	addi	a0,a0,416 # 52a8 <malloc+0x13a>
    1110:	3af030ef          	jal	4cbe <exec>
    1114:	57fd                	li	a5,-1
    1116:	08f50663          	beq	a0,a5,11a2 <copyinstr2+0x164>
    111a:	55fd                	li	a1,-1
    111c:	00005517          	auipc	a0,0x5
    1120:	9c450513          	addi	a0,a0,-1596 # 5ae0 <malloc+0x972>
    1124:	797030ef          	jal	50ba <printf>
    1128:	4505                	li	a0,1
    112a:	35d030ef          	jal	4c86 <exit>
    112e:	862a                	mv	a2,a0
    1130:	f6840593          	addi	a1,s0,-152
    1134:	00005517          	auipc	a0,0x5
    1138:	92450513          	addi	a0,a0,-1756 # 5a58 <malloc+0x8ea>
    113c:	77f030ef          	jal	50ba <printf>
    1140:	4505                	li	a0,1
    1142:	345030ef          	jal	4c86 <exit>
    1146:	862a                	mv	a2,a0
    1148:	f6840593          	addi	a1,s0,-152
    114c:	00005517          	auipc	a0,0x5
    1150:	92c50513          	addi	a0,a0,-1748 # 5a78 <malloc+0x90a>
    1154:	767030ef          	jal	50ba <printf>
    1158:	4505                	li	a0,1
    115a:	32d030ef          	jal	4c86 <exit>
    115e:	86aa                	mv	a3,a0
    1160:	f6840613          	addi	a2,s0,-152
    1164:	85b2                	mv	a1,a2
    1166:	00005517          	auipc	a0,0x5
    116a:	93250513          	addi	a0,a0,-1742 # 5a98 <malloc+0x92a>
    116e:	74d030ef          	jal	50ba <printf>
    1172:	4505                	li	a0,1
    1174:	313030ef          	jal	4c86 <exit>
    1178:	567d                	li	a2,-1
    117a:	f6840593          	addi	a1,s0,-152
    117e:	00005517          	auipc	a0,0x5
    1182:	94250513          	addi	a0,a0,-1726 # 5ac0 <malloc+0x952>
    1186:	735030ef          	jal	50ba <printf>
    118a:	4505                	li	a0,1
    118c:	2fb030ef          	jal	4c86 <exit>
    1190:	00006517          	auipc	a0,0x6
    1194:	f5050513          	addi	a0,a0,-176 # 70e0 <malloc+0x1f72>
    1198:	723030ef          	jal	50ba <printf>
    119c:	4505                	li	a0,1
    119e:	2e9030ef          	jal	4c86 <exit>
    11a2:	2eb00513          	li	a0,747
    11a6:	2e1030ef          	jal	4c86 <exit>
    11aa:	f4042a23          	sw	zero,-172(s0)
    11ae:	f5440513          	addi	a0,s0,-172
    11b2:	2dd030ef          	jal	4c8e <wait>
    11b6:	f5442703          	lw	a4,-172(s0)
    11ba:	2eb00793          	li	a5,747
    11be:	00f71663          	bne	a4,a5,11ca <copyinstr2+0x18c>
    11c2:	60ae                	ld	ra,200(sp)
    11c4:	640e                	ld	s0,192(sp)
    11c6:	6169                	addi	sp,sp,208
    11c8:	8082                	ret
    11ca:	00005517          	auipc	a0,0x5
    11ce:	93e50513          	addi	a0,a0,-1730 # 5b08 <malloc+0x99a>
    11d2:	6e9030ef          	jal	50ba <printf>
    11d6:	4505                	li	a0,1
    11d8:	2af030ef          	jal	4c86 <exit>

00000000000011dc <truncate3>:
    11dc:	7159                	addi	sp,sp,-112
    11de:	f486                	sd	ra,104(sp)
    11e0:	f0a2                	sd	s0,96(sp)
    11e2:	e8ca                	sd	s2,80(sp)
    11e4:	1880                	addi	s0,sp,112
    11e6:	892a                	mv	s2,a0
    11e8:	60100593          	li	a1,1537
    11ec:	00004517          	auipc	a0,0x4
    11f0:	11450513          	addi	a0,a0,276 # 5300 <malloc+0x192>
    11f4:	2d3030ef          	jal	4cc6 <open>
    11f8:	2b7030ef          	jal	4cae <close>
    11fc:	283030ef          	jal	4c7e <fork>
    1200:	06054663          	bltz	a0,126c <truncate3+0x90>
    1204:	e55d                	bnez	a0,12b2 <truncate3+0xd6>
    1206:	eca6                	sd	s1,88(sp)
    1208:	e4ce                	sd	s3,72(sp)
    120a:	e0d2                	sd	s4,64(sp)
    120c:	fc56                	sd	s5,56(sp)
    120e:	06400993          	li	s3,100
    1212:	00004a17          	auipc	s4,0x4
    1216:	0eea0a13          	addi	s4,s4,238 # 5300 <malloc+0x192>
    121a:	00005a97          	auipc	s5,0x5
    121e:	94ea8a93          	addi	s5,s5,-1714 # 5b68 <malloc+0x9fa>
    1222:	4585                	li	a1,1
    1224:	8552                	mv	a0,s4
    1226:	2a1030ef          	jal	4cc6 <open>
    122a:	84aa                	mv	s1,a0
    122c:	04054e63          	bltz	a0,1288 <truncate3+0xac>
    1230:	4629                	li	a2,10
    1232:	85d6                	mv	a1,s5
    1234:	273030ef          	jal	4ca6 <write>
    1238:	47a9                	li	a5,10
    123a:	06f51163          	bne	a0,a5,129c <truncate3+0xc0>
    123e:	8526                	mv	a0,s1
    1240:	26f030ef          	jal	4cae <close>
    1244:	4581                	li	a1,0
    1246:	8552                	mv	a0,s4
    1248:	27f030ef          	jal	4cc6 <open>
    124c:	84aa                	mv	s1,a0
    124e:	02000613          	li	a2,32
    1252:	f9840593          	addi	a1,s0,-104
    1256:	249030ef          	jal	4c9e <read>
    125a:	8526                	mv	a0,s1
    125c:	253030ef          	jal	4cae <close>
    1260:	39fd                	addiw	s3,s3,-1
    1262:	fc0990e3          	bnez	s3,1222 <truncate3+0x46>
    1266:	4501                	li	a0,0
    1268:	21f030ef          	jal	4c86 <exit>
    126c:	eca6                	sd	s1,88(sp)
    126e:	e4ce                	sd	s3,72(sp)
    1270:	e0d2                	sd	s4,64(sp)
    1272:	fc56                	sd	s5,56(sp)
    1274:	85ca                	mv	a1,s2
    1276:	00005517          	auipc	a0,0x5
    127a:	8c250513          	addi	a0,a0,-1854 # 5b38 <malloc+0x9ca>
    127e:	63d030ef          	jal	50ba <printf>
    1282:	4505                	li	a0,1
    1284:	203030ef          	jal	4c86 <exit>
    1288:	85ca                	mv	a1,s2
    128a:	00005517          	auipc	a0,0x5
    128e:	8c650513          	addi	a0,a0,-1850 # 5b50 <malloc+0x9e2>
    1292:	629030ef          	jal	50ba <printf>
    1296:	4505                	li	a0,1
    1298:	1ef030ef          	jal	4c86 <exit>
    129c:	862a                	mv	a2,a0
    129e:	85ca                	mv	a1,s2
    12a0:	00005517          	auipc	a0,0x5
    12a4:	8d850513          	addi	a0,a0,-1832 # 5b78 <malloc+0xa0a>
    12a8:	613030ef          	jal	50ba <printf>
    12ac:	4505                	li	a0,1
    12ae:	1d9030ef          	jal	4c86 <exit>
    12b2:	eca6                	sd	s1,88(sp)
    12b4:	e4ce                	sd	s3,72(sp)
    12b6:	e0d2                	sd	s4,64(sp)
    12b8:	fc56                	sd	s5,56(sp)
    12ba:	09600993          	li	s3,150
    12be:	00004a17          	auipc	s4,0x4
    12c2:	042a0a13          	addi	s4,s4,66 # 5300 <malloc+0x192>
    12c6:	00005a97          	auipc	s5,0x5
    12ca:	8d2a8a93          	addi	s5,s5,-1838 # 5b98 <malloc+0xa2a>
    12ce:	60100593          	li	a1,1537
    12d2:	8552                	mv	a0,s4
    12d4:	1f3030ef          	jal	4cc6 <open>
    12d8:	84aa                	mv	s1,a0
    12da:	02054d63          	bltz	a0,1314 <truncate3+0x138>
    12de:	460d                	li	a2,3
    12e0:	85d6                	mv	a1,s5
    12e2:	1c5030ef          	jal	4ca6 <write>
    12e6:	478d                	li	a5,3
    12e8:	04f51063          	bne	a0,a5,1328 <truncate3+0x14c>
    12ec:	8526                	mv	a0,s1
    12ee:	1c1030ef          	jal	4cae <close>
    12f2:	39fd                	addiw	s3,s3,-1
    12f4:	fc099de3          	bnez	s3,12ce <truncate3+0xf2>
    12f8:	fbc40513          	addi	a0,s0,-68
    12fc:	193030ef          	jal	4c8e <wait>
    1300:	00004517          	auipc	a0,0x4
    1304:	00050513          	mv	a0,a0
    1308:	1cf030ef          	jal	4cd6 <unlink>
    130c:	fbc42503          	lw	a0,-68(s0)
    1310:	177030ef          	jal	4c86 <exit>
    1314:	85ca                	mv	a1,s2
    1316:	00005517          	auipc	a0,0x5
    131a:	83a50513          	addi	a0,a0,-1990 # 5b50 <malloc+0x9e2>
    131e:	59d030ef          	jal	50ba <printf>
    1322:	4505                	li	a0,1
    1324:	163030ef          	jal	4c86 <exit>
    1328:	862a                	mv	a2,a0
    132a:	85ca                	mv	a1,s2
    132c:	00005517          	auipc	a0,0x5
    1330:	87450513          	addi	a0,a0,-1932 # 5ba0 <malloc+0xa32>
    1334:	587030ef          	jal	50ba <printf>
    1338:	4505                	li	a0,1
    133a:	14d030ef          	jal	4c86 <exit>

000000000000133e <exectest>:
    133e:	715d                	addi	sp,sp,-80
    1340:	e486                	sd	ra,72(sp)
    1342:	e0a2                	sd	s0,64(sp)
    1344:	f84a                	sd	s2,48(sp)
    1346:	0880                	addi	s0,sp,80
    1348:	892a                	mv	s2,a0
    134a:	00004797          	auipc	a5,0x4
    134e:	f5e78793          	addi	a5,a5,-162 # 52a8 <malloc+0x13a>
    1352:	fcf43023          	sd	a5,-64(s0)
    1356:	00005797          	auipc	a5,0x5
    135a:	86a78793          	addi	a5,a5,-1942 # 5bc0 <malloc+0xa52>
    135e:	fcf43423          	sd	a5,-56(s0)
    1362:	fc043823          	sd	zero,-48(s0)
    1366:	00005517          	auipc	a0,0x5
    136a:	86250513          	addi	a0,a0,-1950 # 5bc8 <malloc+0xa5a>
    136e:	169030ef          	jal	4cd6 <unlink>
    1372:	10d030ef          	jal	4c7e <fork>
    1376:	02054f63          	bltz	a0,13b4 <exectest+0x76>
    137a:	fc26                	sd	s1,56(sp)
    137c:	84aa                	mv	s1,a0
    137e:	e935                	bnez	a0,13f2 <exectest+0xb4>
    1380:	4505                	li	a0,1
    1382:	12d030ef          	jal	4cae <close>
    1386:	20100593          	li	a1,513
    138a:	00005517          	auipc	a0,0x5
    138e:	83e50513          	addi	a0,a0,-1986 # 5bc8 <malloc+0xa5a>
    1392:	135030ef          	jal	4cc6 <open>
    1396:	02054a63          	bltz	a0,13ca <exectest+0x8c>
    139a:	4785                	li	a5,1
    139c:	04f50163          	beq	a0,a5,13de <exectest+0xa0>
    13a0:	85ca                	mv	a1,s2
    13a2:	00005517          	auipc	a0,0x5
    13a6:	84650513          	addi	a0,a0,-1978 # 5be8 <malloc+0xa7a>
    13aa:	511030ef          	jal	50ba <printf>
    13ae:	4505                	li	a0,1
    13b0:	0d7030ef          	jal	4c86 <exit>
    13b4:	fc26                	sd	s1,56(sp)
    13b6:	85ca                	mv	a1,s2
    13b8:	00004517          	auipc	a0,0x4
    13bc:	78050513          	addi	a0,a0,1920 # 5b38 <malloc+0x9ca>
    13c0:	4fb030ef          	jal	50ba <printf>
    13c4:	4505                	li	a0,1
    13c6:	0c1030ef          	jal	4c86 <exit>
    13ca:	85ca                	mv	a1,s2
    13cc:	00005517          	auipc	a0,0x5
    13d0:	80450513          	addi	a0,a0,-2044 # 5bd0 <malloc+0xa62>
    13d4:	4e7030ef          	jal	50ba <printf>
    13d8:	4505                	li	a0,1
    13da:	0ad030ef          	jal	4c86 <exit>
    13de:	fc040593          	addi	a1,s0,-64
    13e2:	00004517          	auipc	a0,0x4
    13e6:	ec650513          	addi	a0,a0,-314 # 52a8 <malloc+0x13a>
    13ea:	0d5030ef          	jal	4cbe <exec>
    13ee:	00054d63          	bltz	a0,1408 <exectest+0xca>
    13f2:	fdc40513          	addi	a0,s0,-36
    13f6:	099030ef          	jal	4c8e <wait>
    13fa:	02951163          	bne	a0,s1,141c <exectest+0xde>
    13fe:	fdc42503          	lw	a0,-36(s0)
    1402:	c50d                	beqz	a0,142c <exectest+0xee>
    1404:	083030ef          	jal	4c86 <exit>
    1408:	85ca                	mv	a1,s2
    140a:	00004517          	auipc	a0,0x4
    140e:	7ee50513          	addi	a0,a0,2030 # 5bf8 <malloc+0xa8a>
    1412:	4a9030ef          	jal	50ba <printf>
    1416:	4505                	li	a0,1
    1418:	06f030ef          	jal	4c86 <exit>
    141c:	85ca                	mv	a1,s2
    141e:	00004517          	auipc	a0,0x4
    1422:	7f250513          	addi	a0,a0,2034 # 5c10 <malloc+0xaa2>
    1426:	495030ef          	jal	50ba <printf>
    142a:	bfd1                	j	13fe <exectest+0xc0>
    142c:	4581                	li	a1,0
    142e:	00004517          	auipc	a0,0x4
    1432:	79a50513          	addi	a0,a0,1946 # 5bc8 <malloc+0xa5a>
    1436:	091030ef          	jal	4cc6 <open>
    143a:	02054463          	bltz	a0,1462 <exectest+0x124>
    143e:	4609                	li	a2,2
    1440:	fb840593          	addi	a1,s0,-72
    1444:	05b030ef          	jal	4c9e <read>
    1448:	4789                	li	a5,2
    144a:	02f50663          	beq	a0,a5,1476 <exectest+0x138>
    144e:	85ca                	mv	a1,s2
    1450:	00004517          	auipc	a0,0x4
    1454:	22850513          	addi	a0,a0,552 # 5678 <malloc+0x50a>
    1458:	463030ef          	jal	50ba <printf>
    145c:	4505                	li	a0,1
    145e:	029030ef          	jal	4c86 <exit>
    1462:	85ca                	mv	a1,s2
    1464:	00004517          	auipc	a0,0x4
    1468:	6ec50513          	addi	a0,a0,1772 # 5b50 <malloc+0x9e2>
    146c:	44f030ef          	jal	50ba <printf>
    1470:	4505                	li	a0,1
    1472:	015030ef          	jal	4c86 <exit>
    1476:	00004517          	auipc	a0,0x4
    147a:	75250513          	addi	a0,a0,1874 # 5bc8 <malloc+0xa5a>
    147e:	059030ef          	jal	4cd6 <unlink>
    1482:	fb844703          	lbu	a4,-72(s0)
    1486:	04f00793          	li	a5,79
    148a:	00f71863          	bne	a4,a5,149a <exectest+0x15c>
    148e:	fb944703          	lbu	a4,-71(s0)
    1492:	04b00793          	li	a5,75
    1496:	00f70c63          	beq	a4,a5,14ae <exectest+0x170>
    149a:	85ca                	mv	a1,s2
    149c:	00004517          	auipc	a0,0x4
    14a0:	78c50513          	addi	a0,a0,1932 # 5c28 <malloc+0xaba>
    14a4:	417030ef          	jal	50ba <printf>
    14a8:	4505                	li	a0,1
    14aa:	7dc030ef          	jal	4c86 <exit>
    14ae:	4501                	li	a0,0
    14b0:	7d6030ef          	jal	4c86 <exit>

00000000000014b4 <pipe1>:
    14b4:	711d                	addi	sp,sp,-96
    14b6:	ec86                	sd	ra,88(sp)
    14b8:	e8a2                	sd	s0,80(sp)
    14ba:	fc4e                	sd	s3,56(sp)
    14bc:	1080                	addi	s0,sp,96
    14be:	89aa                	mv	s3,a0
    14c0:	fa840513          	addi	a0,s0,-88
    14c4:	7d2030ef          	jal	4c96 <pipe>
    14c8:	e92d                	bnez	a0,153a <pipe1+0x86>
    14ca:	e4a6                	sd	s1,72(sp)
    14cc:	f852                	sd	s4,48(sp)
    14ce:	84aa                	mv	s1,a0
    14d0:	7ae030ef          	jal	4c7e <fork>
    14d4:	8a2a                	mv	s4,a0
    14d6:	c151                	beqz	a0,155a <pipe1+0xa6>
    14d8:	14a05e63          	blez	a0,1634 <pipe1+0x180>
    14dc:	e0ca                	sd	s2,64(sp)
    14de:	f456                	sd	s5,40(sp)
    14e0:	fac42503          	lw	a0,-84(s0)
    14e4:	7ca030ef          	jal	4cae <close>
    14e8:	8a26                	mv	s4,s1
    14ea:	4905                	li	s2,1
    14ec:	0000ba97          	auipc	s5,0xb
    14f0:	7bca8a93          	addi	s5,s5,1980 # cca8 <buf>
    14f4:	864a                	mv	a2,s2
    14f6:	85d6                	mv	a1,s5
    14f8:	fa842503          	lw	a0,-88(s0)
    14fc:	7a2030ef          	jal	4c9e <read>
    1500:	0ea05a63          	blez	a0,15f4 <pipe1+0x140>
    1504:	0000b717          	auipc	a4,0xb
    1508:	7a470713          	addi	a4,a4,1956 # cca8 <buf>
    150c:	00a4863b          	addw	a2,s1,a0
    1510:	00074683          	lbu	a3,0(a4)
    1514:	0ff4f793          	zext.b	a5,s1
    1518:	2485                	addiw	s1,s1,1
    151a:	0af69d63          	bne	a3,a5,15d4 <pipe1+0x120>
    151e:	0705                	addi	a4,a4,1
    1520:	fec498e3          	bne	s1,a2,1510 <pipe1+0x5c>
    1524:	00aa0a3b          	addw	s4,s4,a0
    1528:	0019179b          	slliw	a5,s2,0x1
    152c:	0007891b          	sext.w	s2,a5
    1530:	670d                	lui	a4,0x3
    1532:	fd2771e3          	bgeu	a4,s2,14f4 <pipe1+0x40>
    1536:	690d                	lui	s2,0x3
    1538:	bf75                	j	14f4 <pipe1+0x40>
    153a:	e4a6                	sd	s1,72(sp)
    153c:	e0ca                	sd	s2,64(sp)
    153e:	f852                	sd	s4,48(sp)
    1540:	f456                	sd	s5,40(sp)
    1542:	f05a                	sd	s6,32(sp)
    1544:	ec5e                	sd	s7,24(sp)
    1546:	85ce                	mv	a1,s3
    1548:	00004517          	auipc	a0,0x4
    154c:	6f850513          	addi	a0,a0,1784 # 5c40 <malloc+0xad2>
    1550:	36b030ef          	jal	50ba <printf>
    1554:	4505                	li	a0,1
    1556:	730030ef          	jal	4c86 <exit>
    155a:	e0ca                	sd	s2,64(sp)
    155c:	f456                	sd	s5,40(sp)
    155e:	f05a                	sd	s6,32(sp)
    1560:	ec5e                	sd	s7,24(sp)
    1562:	fa842503          	lw	a0,-88(s0)
    1566:	748030ef          	jal	4cae <close>
    156a:	0000bb17          	auipc	s6,0xb
    156e:	73eb0b13          	addi	s6,s6,1854 # cca8 <buf>
    1572:	416004bb          	negw	s1,s6
    1576:	0ff4f493          	zext.b	s1,s1
    157a:	409b0913          	addi	s2,s6,1033
    157e:	8bda                	mv	s7,s6
    1580:	6a85                	lui	s5,0x1
    1582:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xef>
    1586:	87da                	mv	a5,s6
    1588:	0097873b          	addw	a4,a5,s1
    158c:	00e78023          	sb	a4,0(a5)
    1590:	0785                	addi	a5,a5,1
    1592:	ff279be3          	bne	a5,s2,1588 <pipe1+0xd4>
    1596:	409a0a1b          	addiw	s4,s4,1033
    159a:	40900613          	li	a2,1033
    159e:	85de                	mv	a1,s7
    15a0:	fac42503          	lw	a0,-84(s0)
    15a4:	702030ef          	jal	4ca6 <write>
    15a8:	40900793          	li	a5,1033
    15ac:	00f51a63          	bne	a0,a5,15c0 <pipe1+0x10c>
    15b0:	24a5                	addiw	s1,s1,9
    15b2:	0ff4f493          	zext.b	s1,s1
    15b6:	fd5a18e3          	bne	s4,s5,1586 <pipe1+0xd2>
    15ba:	4501                	li	a0,0
    15bc:	6ca030ef          	jal	4c86 <exit>
    15c0:	85ce                	mv	a1,s3
    15c2:	00004517          	auipc	a0,0x4
    15c6:	69650513          	addi	a0,a0,1686 # 5c58 <malloc+0xaea>
    15ca:	2f1030ef          	jal	50ba <printf>
    15ce:	4505                	li	a0,1
    15d0:	6b6030ef          	jal	4c86 <exit>
    15d4:	85ce                	mv	a1,s3
    15d6:	00004517          	auipc	a0,0x4
    15da:	69a50513          	addi	a0,a0,1690 # 5c70 <malloc+0xb02>
    15de:	2dd030ef          	jal	50ba <printf>
    15e2:	64a6                	ld	s1,72(sp)
    15e4:	6906                	ld	s2,64(sp)
    15e6:	7a42                	ld	s4,48(sp)
    15e8:	7aa2                	ld	s5,40(sp)
    15ea:	60e6                	ld	ra,88(sp)
    15ec:	6446                	ld	s0,80(sp)
    15ee:	79e2                	ld	s3,56(sp)
    15f0:	6125                	addi	sp,sp,96
    15f2:	8082                	ret
    15f4:	6785                	lui	a5,0x1
    15f6:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xef>
    15fa:	00fa0f63          	beq	s4,a5,1618 <pipe1+0x164>
    15fe:	f05a                	sd	s6,32(sp)
    1600:	ec5e                	sd	s7,24(sp)
    1602:	8652                	mv	a2,s4
    1604:	85ce                	mv	a1,s3
    1606:	00004517          	auipc	a0,0x4
    160a:	68250513          	addi	a0,a0,1666 # 5c88 <malloc+0xb1a>
    160e:	2ad030ef          	jal	50ba <printf>
    1612:	4505                	li	a0,1
    1614:	672030ef          	jal	4c86 <exit>
    1618:	f05a                	sd	s6,32(sp)
    161a:	ec5e                	sd	s7,24(sp)
    161c:	fa842503          	lw	a0,-88(s0)
    1620:	68e030ef          	jal	4cae <close>
    1624:	fa440513          	addi	a0,s0,-92
    1628:	666030ef          	jal	4c8e <wait>
    162c:	fa442503          	lw	a0,-92(s0)
    1630:	656030ef          	jal	4c86 <exit>
    1634:	e0ca                	sd	s2,64(sp)
    1636:	f456                	sd	s5,40(sp)
    1638:	f05a                	sd	s6,32(sp)
    163a:	ec5e                	sd	s7,24(sp)
    163c:	85ce                	mv	a1,s3
    163e:	00004517          	auipc	a0,0x4
    1642:	66a50513          	addi	a0,a0,1642 # 5ca8 <malloc+0xb3a>
    1646:	275030ef          	jal	50ba <printf>
    164a:	4505                	li	a0,1
    164c:	63a030ef          	jal	4c86 <exit>

0000000000001650 <exitwait>:
    1650:	7139                	addi	sp,sp,-64
    1652:	fc06                	sd	ra,56(sp)
    1654:	f822                	sd	s0,48(sp)
    1656:	f426                	sd	s1,40(sp)
    1658:	f04a                	sd	s2,32(sp)
    165a:	ec4e                	sd	s3,24(sp)
    165c:	e852                	sd	s4,16(sp)
    165e:	0080                	addi	s0,sp,64
    1660:	8a2a                	mv	s4,a0
    1662:	4901                	li	s2,0
    1664:	06400993          	li	s3,100
    1668:	616030ef          	jal	4c7e <fork>
    166c:	84aa                	mv	s1,a0
    166e:	02054863          	bltz	a0,169e <exitwait+0x4e>
    1672:	c525                	beqz	a0,16da <exitwait+0x8a>
    1674:	fcc40513          	addi	a0,s0,-52
    1678:	616030ef          	jal	4c8e <wait>
    167c:	02951b63          	bne	a0,s1,16b2 <exitwait+0x62>
    1680:	fcc42783          	lw	a5,-52(s0)
    1684:	05279163          	bne	a5,s2,16c6 <exitwait+0x76>
    1688:	2905                	addiw	s2,s2,1 # 3001 <subdir+0x43f>
    168a:	fd391fe3          	bne	s2,s3,1668 <exitwait+0x18>
    168e:	70e2                	ld	ra,56(sp)
    1690:	7442                	ld	s0,48(sp)
    1692:	74a2                	ld	s1,40(sp)
    1694:	7902                	ld	s2,32(sp)
    1696:	69e2                	ld	s3,24(sp)
    1698:	6a42                	ld	s4,16(sp)
    169a:	6121                	addi	sp,sp,64
    169c:	8082                	ret
    169e:	85d2                	mv	a1,s4
    16a0:	00004517          	auipc	a0,0x4
    16a4:	49850513          	addi	a0,a0,1176 # 5b38 <malloc+0x9ca>
    16a8:	213030ef          	jal	50ba <printf>
    16ac:	4505                	li	a0,1
    16ae:	5d8030ef          	jal	4c86 <exit>
    16b2:	85d2                	mv	a1,s4
    16b4:	00004517          	auipc	a0,0x4
    16b8:	60c50513          	addi	a0,a0,1548 # 5cc0 <malloc+0xb52>
    16bc:	1ff030ef          	jal	50ba <printf>
    16c0:	4505                	li	a0,1
    16c2:	5c4030ef          	jal	4c86 <exit>
    16c6:	85d2                	mv	a1,s4
    16c8:	00004517          	auipc	a0,0x4
    16cc:	61050513          	addi	a0,a0,1552 # 5cd8 <malloc+0xb6a>
    16d0:	1eb030ef          	jal	50ba <printf>
    16d4:	4505                	li	a0,1
    16d6:	5b0030ef          	jal	4c86 <exit>
    16da:	854a                	mv	a0,s2
    16dc:	5aa030ef          	jal	4c86 <exit>

00000000000016e0 <twochildren>:
    16e0:	1101                	addi	sp,sp,-32
    16e2:	ec06                	sd	ra,24(sp)
    16e4:	e822                	sd	s0,16(sp)
    16e6:	e426                	sd	s1,8(sp)
    16e8:	e04a                	sd	s2,0(sp)
    16ea:	1000                	addi	s0,sp,32
    16ec:	892a                	mv	s2,a0
    16ee:	3e800493          	li	s1,1000
    16f2:	58c030ef          	jal	4c7e <fork>
    16f6:	02054663          	bltz	a0,1722 <twochildren+0x42>
    16fa:	cd15                	beqz	a0,1736 <twochildren+0x56>
    16fc:	582030ef          	jal	4c7e <fork>
    1700:	02054d63          	bltz	a0,173a <twochildren+0x5a>
    1704:	c529                	beqz	a0,174e <twochildren+0x6e>
    1706:	4501                	li	a0,0
    1708:	586030ef          	jal	4c8e <wait>
    170c:	4501                	li	a0,0
    170e:	580030ef          	jal	4c8e <wait>
    1712:	34fd                	addiw	s1,s1,-1
    1714:	fcf9                	bnez	s1,16f2 <twochildren+0x12>
    1716:	60e2                	ld	ra,24(sp)
    1718:	6442                	ld	s0,16(sp)
    171a:	64a2                	ld	s1,8(sp)
    171c:	6902                	ld	s2,0(sp)
    171e:	6105                	addi	sp,sp,32
    1720:	8082                	ret
    1722:	85ca                	mv	a1,s2
    1724:	00004517          	auipc	a0,0x4
    1728:	41450513          	addi	a0,a0,1044 # 5b38 <malloc+0x9ca>
    172c:	18f030ef          	jal	50ba <printf>
    1730:	4505                	li	a0,1
    1732:	554030ef          	jal	4c86 <exit>
    1736:	550030ef          	jal	4c86 <exit>
    173a:	85ca                	mv	a1,s2
    173c:	00004517          	auipc	a0,0x4
    1740:	3fc50513          	addi	a0,a0,1020 # 5b38 <malloc+0x9ca>
    1744:	177030ef          	jal	50ba <printf>
    1748:	4505                	li	a0,1
    174a:	53c030ef          	jal	4c86 <exit>
    174e:	538030ef          	jal	4c86 <exit>

0000000000001752 <forkfork>:
    1752:	7179                	addi	sp,sp,-48
    1754:	f406                	sd	ra,40(sp)
    1756:	f022                	sd	s0,32(sp)
    1758:	ec26                	sd	s1,24(sp)
    175a:	1800                	addi	s0,sp,48
    175c:	84aa                	mv	s1,a0
    175e:	520030ef          	jal	4c7e <fork>
    1762:	02054b63          	bltz	a0,1798 <forkfork+0x46>
    1766:	c139                	beqz	a0,17ac <forkfork+0x5a>
    1768:	516030ef          	jal	4c7e <fork>
    176c:	02054663          	bltz	a0,1798 <forkfork+0x46>
    1770:	cd15                	beqz	a0,17ac <forkfork+0x5a>
    1772:	fdc40513          	addi	a0,s0,-36
    1776:	518030ef          	jal	4c8e <wait>
    177a:	fdc42783          	lw	a5,-36(s0)
    177e:	ebb9                	bnez	a5,17d4 <forkfork+0x82>
    1780:	fdc40513          	addi	a0,s0,-36
    1784:	50a030ef          	jal	4c8e <wait>
    1788:	fdc42783          	lw	a5,-36(s0)
    178c:	e7a1                	bnez	a5,17d4 <forkfork+0x82>
    178e:	70a2                	ld	ra,40(sp)
    1790:	7402                	ld	s0,32(sp)
    1792:	64e2                	ld	s1,24(sp)
    1794:	6145                	addi	sp,sp,48
    1796:	8082                	ret
    1798:	85a6                	mv	a1,s1
    179a:	00004517          	auipc	a0,0x4
    179e:	55e50513          	addi	a0,a0,1374 # 5cf8 <malloc+0xb8a>
    17a2:	119030ef          	jal	50ba <printf>
    17a6:	4505                	li	a0,1
    17a8:	4de030ef          	jal	4c86 <exit>
    17ac:	0c800493          	li	s1,200
    17b0:	4ce030ef          	jal	4c7e <fork>
    17b4:	00054b63          	bltz	a0,17ca <forkfork+0x78>
    17b8:	cd01                	beqz	a0,17d0 <forkfork+0x7e>
    17ba:	4501                	li	a0,0
    17bc:	4d2030ef          	jal	4c8e <wait>
    17c0:	34fd                	addiw	s1,s1,-1
    17c2:	f4fd                	bnez	s1,17b0 <forkfork+0x5e>
    17c4:	4501                	li	a0,0
    17c6:	4c0030ef          	jal	4c86 <exit>
    17ca:	4505                	li	a0,1
    17cc:	4ba030ef          	jal	4c86 <exit>
    17d0:	4b6030ef          	jal	4c86 <exit>
    17d4:	85a6                	mv	a1,s1
    17d6:	00004517          	auipc	a0,0x4
    17da:	53250513          	addi	a0,a0,1330 # 5d08 <malloc+0xb9a>
    17de:	0dd030ef          	jal	50ba <printf>
    17e2:	4505                	li	a0,1
    17e4:	4a2030ef          	jal	4c86 <exit>

00000000000017e8 <reparent2>:
    17e8:	1101                	addi	sp,sp,-32
    17ea:	ec06                	sd	ra,24(sp)
    17ec:	e822                	sd	s0,16(sp)
    17ee:	e426                	sd	s1,8(sp)
    17f0:	1000                	addi	s0,sp,32
    17f2:	32000493          	li	s1,800
    17f6:	488030ef          	jal	4c7e <fork>
    17fa:	00054b63          	bltz	a0,1810 <reparent2+0x28>
    17fe:	c115                	beqz	a0,1822 <reparent2+0x3a>
    1800:	4501                	li	a0,0
    1802:	48c030ef          	jal	4c8e <wait>
    1806:	34fd                	addiw	s1,s1,-1
    1808:	f4fd                	bnez	s1,17f6 <reparent2+0xe>
    180a:	4501                	li	a0,0
    180c:	47a030ef          	jal	4c86 <exit>
    1810:	00006517          	auipc	a0,0x6
    1814:	8d050513          	addi	a0,a0,-1840 # 70e0 <malloc+0x1f72>
    1818:	0a3030ef          	jal	50ba <printf>
    181c:	4505                	li	a0,1
    181e:	468030ef          	jal	4c86 <exit>
    1822:	45c030ef          	jal	4c7e <fork>
    1826:	458030ef          	jal	4c7e <fork>
    182a:	4501                	li	a0,0
    182c:	45a030ef          	jal	4c86 <exit>

0000000000001830 <createdelete>:
    1830:	7175                	addi	sp,sp,-144
    1832:	e506                	sd	ra,136(sp)
    1834:	e122                	sd	s0,128(sp)
    1836:	fca6                	sd	s1,120(sp)
    1838:	f8ca                	sd	s2,112(sp)
    183a:	f4ce                	sd	s3,104(sp)
    183c:	f0d2                	sd	s4,96(sp)
    183e:	ecd6                	sd	s5,88(sp)
    1840:	e8da                	sd	s6,80(sp)
    1842:	e4de                	sd	s7,72(sp)
    1844:	e0e2                	sd	s8,64(sp)
    1846:	fc66                	sd	s9,56(sp)
    1848:	0900                	addi	s0,sp,144
    184a:	8caa                	mv	s9,a0
    184c:	4901                	li	s2,0
    184e:	4991                	li	s3,4
    1850:	42e030ef          	jal	4c7e <fork>
    1854:	84aa                	mv	s1,a0
    1856:	02054d63          	bltz	a0,1890 <createdelete+0x60>
    185a:	c529                	beqz	a0,18a4 <createdelete+0x74>
    185c:	2905                	addiw	s2,s2,1
    185e:	ff3919e3          	bne	s2,s3,1850 <createdelete+0x20>
    1862:	4491                	li	s1,4
    1864:	f7c40513          	addi	a0,s0,-132
    1868:	426030ef          	jal	4c8e <wait>
    186c:	f7c42903          	lw	s2,-132(s0)
    1870:	0a091e63          	bnez	s2,192c <createdelete+0xfc>
    1874:	34fd                	addiw	s1,s1,-1
    1876:	f4fd                	bnez	s1,1864 <createdelete+0x34>
    1878:	f8040123          	sb	zero,-126(s0)
    187c:	03000993          	li	s3,48
    1880:	5a7d                	li	s4,-1
    1882:	07000c13          	li	s8,112
    1886:	4b25                	li	s6,9
    1888:	4ba1                	li	s7,8
    188a:	07400a93          	li	s5,116
    188e:	aa39                	j	19ac <createdelete+0x17c>
    1890:	85e6                	mv	a1,s9
    1892:	00004517          	auipc	a0,0x4
    1896:	2a650513          	addi	a0,a0,678 # 5b38 <malloc+0x9ca>
    189a:	021030ef          	jal	50ba <printf>
    189e:	4505                	li	a0,1
    18a0:	3e6030ef          	jal	4c86 <exit>
    18a4:	0709091b          	addiw	s2,s2,112
    18a8:	f9240023          	sb	s2,-128(s0)
    18ac:	f8040123          	sb	zero,-126(s0)
    18b0:	4951                	li	s2,20
    18b2:	a831                	j	18ce <createdelete+0x9e>
    18b4:	85e6                	mv	a1,s9
    18b6:	00004517          	auipc	a0,0x4
    18ba:	31a50513          	addi	a0,a0,794 # 5bd0 <malloc+0xa62>
    18be:	7fc030ef          	jal	50ba <printf>
    18c2:	4505                	li	a0,1
    18c4:	3c2030ef          	jal	4c86 <exit>
    18c8:	2485                	addiw	s1,s1,1
    18ca:	05248e63          	beq	s1,s2,1926 <createdelete+0xf6>
    18ce:	0304879b          	addiw	a5,s1,48
    18d2:	f8f400a3          	sb	a5,-127(s0)
    18d6:	20200593          	li	a1,514
    18da:	f8040513          	addi	a0,s0,-128
    18de:	3e8030ef          	jal	4cc6 <open>
    18e2:	fc0549e3          	bltz	a0,18b4 <createdelete+0x84>
    18e6:	3c8030ef          	jal	4cae <close>
    18ea:	10905063          	blez	s1,19ea <createdelete+0x1ba>
    18ee:	0014f793          	andi	a5,s1,1
    18f2:	fbf9                	bnez	a5,18c8 <createdelete+0x98>
    18f4:	01f4d79b          	srliw	a5,s1,0x1f
    18f8:	9fa5                	addw	a5,a5,s1
    18fa:	4017d79b          	sraiw	a5,a5,0x1
    18fe:	0307879b          	addiw	a5,a5,48
    1902:	f8f400a3          	sb	a5,-127(s0)
    1906:	f8040513          	addi	a0,s0,-128
    190a:	3cc030ef          	jal	4cd6 <unlink>
    190e:	fa055de3          	bgez	a0,18c8 <createdelete+0x98>
    1912:	85e6                	mv	a1,s9
    1914:	00004517          	auipc	a0,0x4
    1918:	41450513          	addi	a0,a0,1044 # 5d28 <malloc+0xbba>
    191c:	79e030ef          	jal	50ba <printf>
    1920:	4505                	li	a0,1
    1922:	364030ef          	jal	4c86 <exit>
    1926:	4501                	li	a0,0
    1928:	35e030ef          	jal	4c86 <exit>
    192c:	4505                	li	a0,1
    192e:	358030ef          	jal	4c86 <exit>
    1932:	f8040613          	addi	a2,s0,-128
    1936:	85e6                	mv	a1,s9
    1938:	00004517          	auipc	a0,0x4
    193c:	40850513          	addi	a0,a0,1032 # 5d40 <malloc+0xbd2>
    1940:	77a030ef          	jal	50ba <printf>
    1944:	4505                	li	a0,1
    1946:	340030ef          	jal	4c86 <exit>
    194a:	034bfb63          	bgeu	s7,s4,1980 <createdelete+0x150>
    194e:	02055663          	bgez	a0,197a <createdelete+0x14a>
    1952:	2485                	addiw	s1,s1,1
    1954:	0ff4f493          	zext.b	s1,s1
    1958:	05548263          	beq	s1,s5,199c <createdelete+0x16c>
    195c:	f8940023          	sb	s1,-128(s0)
    1960:	f93400a3          	sb	s3,-127(s0)
    1964:	4581                	li	a1,0
    1966:	f8040513          	addi	a0,s0,-128
    196a:	35c030ef          	jal	4cc6 <open>
    196e:	00090463          	beqz	s2,1976 <createdelete+0x146>
    1972:	fd2b5ce3          	bge	s6,s2,194a <createdelete+0x11a>
    1976:	fa054ee3          	bltz	a0,1932 <createdelete+0x102>
    197a:	334030ef          	jal	4cae <close>
    197e:	bfd1                	j	1952 <createdelete+0x122>
    1980:	fc0549e3          	bltz	a0,1952 <createdelete+0x122>
    1984:	f8040613          	addi	a2,s0,-128
    1988:	85e6                	mv	a1,s9
    198a:	00004517          	auipc	a0,0x4
    198e:	3de50513          	addi	a0,a0,990 # 5d68 <malloc+0xbfa>
    1992:	728030ef          	jal	50ba <printf>
    1996:	4505                	li	a0,1
    1998:	2ee030ef          	jal	4c86 <exit>
    199c:	2905                	addiw	s2,s2,1
    199e:	2a05                	addiw	s4,s4,1
    19a0:	2985                	addiw	s3,s3,1
    19a2:	0ff9f993          	zext.b	s3,s3
    19a6:	47d1                	li	a5,20
    19a8:	02f90863          	beq	s2,a5,19d8 <createdelete+0x1a8>
    19ac:	84e2                	mv	s1,s8
    19ae:	b77d                	j	195c <createdelete+0x12c>
    19b0:	2905                	addiw	s2,s2,1
    19b2:	0ff97913          	zext.b	s2,s2
    19b6:	03490c63          	beq	s2,s4,19ee <createdelete+0x1be>
    19ba:	84d6                	mv	s1,s5
    19bc:	f8940023          	sb	s1,-128(s0)
    19c0:	f92400a3          	sb	s2,-127(s0)
    19c4:	f8040513          	addi	a0,s0,-128
    19c8:	30e030ef          	jal	4cd6 <unlink>
    19cc:	2485                	addiw	s1,s1,1
    19ce:	0ff4f493          	zext.b	s1,s1
    19d2:	ff3495e3          	bne	s1,s3,19bc <createdelete+0x18c>
    19d6:	bfe9                	j	19b0 <createdelete+0x180>
    19d8:	03000913          	li	s2,48
    19dc:	07000a93          	li	s5,112
    19e0:	07400993          	li	s3,116
    19e4:	04400a13          	li	s4,68
    19e8:	bfc9                	j	19ba <createdelete+0x18a>
    19ea:	2485                	addiw	s1,s1,1
    19ec:	b5cd                	j	18ce <createdelete+0x9e>
    19ee:	60aa                	ld	ra,136(sp)
    19f0:	640a                	ld	s0,128(sp)
    19f2:	74e6                	ld	s1,120(sp)
    19f4:	7946                	ld	s2,112(sp)
    19f6:	79a6                	ld	s3,104(sp)
    19f8:	7a06                	ld	s4,96(sp)
    19fa:	6ae6                	ld	s5,88(sp)
    19fc:	6b46                	ld	s6,80(sp)
    19fe:	6ba6                	ld	s7,72(sp)
    1a00:	6c06                	ld	s8,64(sp)
    1a02:	7ce2                	ld	s9,56(sp)
    1a04:	6149                	addi	sp,sp,144
    1a06:	8082                	ret

0000000000001a08 <linkunlink>:
    1a08:	711d                	addi	sp,sp,-96
    1a0a:	ec86                	sd	ra,88(sp)
    1a0c:	e8a2                	sd	s0,80(sp)
    1a0e:	e4a6                	sd	s1,72(sp)
    1a10:	e0ca                	sd	s2,64(sp)
    1a12:	fc4e                	sd	s3,56(sp)
    1a14:	f852                	sd	s4,48(sp)
    1a16:	f456                	sd	s5,40(sp)
    1a18:	f05a                	sd	s6,32(sp)
    1a1a:	ec5e                	sd	s7,24(sp)
    1a1c:	e862                	sd	s8,16(sp)
    1a1e:	e466                	sd	s9,8(sp)
    1a20:	1080                	addi	s0,sp,96
    1a22:	84aa                	mv	s1,a0
    1a24:	00004517          	auipc	a0,0x4
    1a28:	8f450513          	addi	a0,a0,-1804 # 5318 <malloc+0x1aa>
    1a2c:	2aa030ef          	jal	4cd6 <unlink>
    1a30:	24e030ef          	jal	4c7e <fork>
    1a34:	02054b63          	bltz	a0,1a6a <linkunlink+0x62>
    1a38:	8caa                	mv	s9,a0
    1a3a:	06100913          	li	s2,97
    1a3e:	c111                	beqz	a0,1a42 <linkunlink+0x3a>
    1a40:	4905                	li	s2,1
    1a42:	06400493          	li	s1,100
    1a46:	41c65a37          	lui	s4,0x41c65
    1a4a:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c551c5>
    1a4e:	698d                	lui	s3,0x3
    1a50:	0399899b          	addiw	s3,s3,57 # 3039 <subdir+0x477>
    1a54:	4a8d                	li	s5,3
    1a56:	4b85                	li	s7,1
    1a58:	00004b17          	auipc	s6,0x4
    1a5c:	8c0b0b13          	addi	s6,s6,-1856 # 5318 <malloc+0x1aa>
    1a60:	00004c17          	auipc	s8,0x4
    1a64:	330c0c13          	addi	s8,s8,816 # 5d90 <malloc+0xc22>
    1a68:	a025                	j	1a90 <linkunlink+0x88>
    1a6a:	85a6                	mv	a1,s1
    1a6c:	00004517          	auipc	a0,0x4
    1a70:	0cc50513          	addi	a0,a0,204 # 5b38 <malloc+0x9ca>
    1a74:	646030ef          	jal	50ba <printf>
    1a78:	4505                	li	a0,1
    1a7a:	20c030ef          	jal	4c86 <exit>
    1a7e:	20200593          	li	a1,514
    1a82:	855a                	mv	a0,s6
    1a84:	242030ef          	jal	4cc6 <open>
    1a88:	226030ef          	jal	4cae <close>
    1a8c:	34fd                	addiw	s1,s1,-1
    1a8e:	c495                	beqz	s1,1aba <linkunlink+0xb2>
    1a90:	034907bb          	mulw	a5,s2,s4
    1a94:	013787bb          	addw	a5,a5,s3
    1a98:	0007891b          	sext.w	s2,a5
    1a9c:	0357f7bb          	remuw	a5,a5,s5
    1aa0:	2781                	sext.w	a5,a5
    1aa2:	dff1                	beqz	a5,1a7e <linkunlink+0x76>
    1aa4:	01778663          	beq	a5,s7,1ab0 <linkunlink+0xa8>
    1aa8:	855a                	mv	a0,s6
    1aaa:	22c030ef          	jal	4cd6 <unlink>
    1aae:	bff9                	j	1a8c <linkunlink+0x84>
    1ab0:	85da                	mv	a1,s6
    1ab2:	8562                	mv	a0,s8
    1ab4:	232030ef          	jal	4ce6 <link>
    1ab8:	bfd1                	j	1a8c <linkunlink+0x84>
    1aba:	020c8263          	beqz	s9,1ade <linkunlink+0xd6>
    1abe:	4501                	li	a0,0
    1ac0:	1ce030ef          	jal	4c8e <wait>
    1ac4:	60e6                	ld	ra,88(sp)
    1ac6:	6446                	ld	s0,80(sp)
    1ac8:	64a6                	ld	s1,72(sp)
    1aca:	6906                	ld	s2,64(sp)
    1acc:	79e2                	ld	s3,56(sp)
    1ace:	7a42                	ld	s4,48(sp)
    1ad0:	7aa2                	ld	s5,40(sp)
    1ad2:	7b02                	ld	s6,32(sp)
    1ad4:	6be2                	ld	s7,24(sp)
    1ad6:	6c42                	ld	s8,16(sp)
    1ad8:	6ca2                	ld	s9,8(sp)
    1ada:	6125                	addi	sp,sp,96
    1adc:	8082                	ret
    1ade:	4501                	li	a0,0
    1ae0:	1a6030ef          	jal	4c86 <exit>

0000000000001ae4 <forktest>:
    1ae4:	7179                	addi	sp,sp,-48
    1ae6:	f406                	sd	ra,40(sp)
    1ae8:	f022                	sd	s0,32(sp)
    1aea:	ec26                	sd	s1,24(sp)
    1aec:	e84a                	sd	s2,16(sp)
    1aee:	e44e                	sd	s3,8(sp)
    1af0:	1800                	addi	s0,sp,48
    1af2:	89aa                	mv	s3,a0
    1af4:	4481                	li	s1,0
    1af6:	3e800913          	li	s2,1000
    1afa:	184030ef          	jal	4c7e <fork>
    1afe:	06054063          	bltz	a0,1b5e <forktest+0x7a>
    1b02:	cd11                	beqz	a0,1b1e <forktest+0x3a>
    1b04:	2485                	addiw	s1,s1,1
    1b06:	ff249ae3          	bne	s1,s2,1afa <forktest+0x16>
    1b0a:	85ce                	mv	a1,s3
    1b0c:	00004517          	auipc	a0,0x4
    1b10:	2d450513          	addi	a0,a0,724 # 5de0 <malloc+0xc72>
    1b14:	5a6030ef          	jal	50ba <printf>
    1b18:	4505                	li	a0,1
    1b1a:	16c030ef          	jal	4c86 <exit>
    1b1e:	168030ef          	jal	4c86 <exit>
    1b22:	85ce                	mv	a1,s3
    1b24:	00004517          	auipc	a0,0x4
    1b28:	27450513          	addi	a0,a0,628 # 5d98 <malloc+0xc2a>
    1b2c:	58e030ef          	jal	50ba <printf>
    1b30:	4505                	li	a0,1
    1b32:	154030ef          	jal	4c86 <exit>
    1b36:	85ce                	mv	a1,s3
    1b38:	00004517          	auipc	a0,0x4
    1b3c:	27850513          	addi	a0,a0,632 # 5db0 <malloc+0xc42>
    1b40:	57a030ef          	jal	50ba <printf>
    1b44:	4505                	li	a0,1
    1b46:	140030ef          	jal	4c86 <exit>
    1b4a:	85ce                	mv	a1,s3
    1b4c:	00004517          	auipc	a0,0x4
    1b50:	27c50513          	addi	a0,a0,636 # 5dc8 <malloc+0xc5a>
    1b54:	566030ef          	jal	50ba <printf>
    1b58:	4505                	li	a0,1
    1b5a:	12c030ef          	jal	4c86 <exit>
    1b5e:	d0f1                	beqz	s1,1b22 <forktest+0x3e>
    1b60:	00905963          	blez	s1,1b72 <forktest+0x8e>
    1b64:	4501                	li	a0,0
    1b66:	128030ef          	jal	4c8e <wait>
    1b6a:	fc0546e3          	bltz	a0,1b36 <forktest+0x52>
    1b6e:	34fd                	addiw	s1,s1,-1
    1b70:	f8f5                	bnez	s1,1b64 <forktest+0x80>
    1b72:	4501                	li	a0,0
    1b74:	11a030ef          	jal	4c8e <wait>
    1b78:	57fd                	li	a5,-1
    1b7a:	fcf518e3          	bne	a0,a5,1b4a <forktest+0x66>
    1b7e:	70a2                	ld	ra,40(sp)
    1b80:	7402                	ld	s0,32(sp)
    1b82:	64e2                	ld	s1,24(sp)
    1b84:	6942                	ld	s2,16(sp)
    1b86:	69a2                	ld	s3,8(sp)
    1b88:	6145                	addi	sp,sp,48
    1b8a:	8082                	ret

0000000000001b8c <kernmem>:
    1b8c:	715d                	addi	sp,sp,-80
    1b8e:	e486                	sd	ra,72(sp)
    1b90:	e0a2                	sd	s0,64(sp)
    1b92:	fc26                	sd	s1,56(sp)
    1b94:	f84a                	sd	s2,48(sp)
    1b96:	f44e                	sd	s3,40(sp)
    1b98:	f052                	sd	s4,32(sp)
    1b9a:	ec56                	sd	s5,24(sp)
    1b9c:	0880                	addi	s0,sp,80
    1b9e:	8aaa                	mv	s5,a0
    1ba0:	4485                	li	s1,1
    1ba2:	04fe                	slli	s1,s1,0x1f
    1ba4:	5a7d                	li	s4,-1
    1ba6:	69b1                	lui	s3,0xc
    1ba8:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1db8>
    1bac:	1003d937          	lui	s2,0x1003d
    1bb0:	090e                	slli	s2,s2,0x3
    1bb2:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d7d8>
    1bb6:	0c8030ef          	jal	4c7e <fork>
    1bba:	02054763          	bltz	a0,1be8 <kernmem+0x5c>
    1bbe:	cd1d                	beqz	a0,1bfc <kernmem+0x70>
    1bc0:	fbc40513          	addi	a0,s0,-68
    1bc4:	0ca030ef          	jal	4c8e <wait>
    1bc8:	fbc42783          	lw	a5,-68(s0)
    1bcc:	05479563          	bne	a5,s4,1c16 <kernmem+0x8a>
    1bd0:	94ce                	add	s1,s1,s3
    1bd2:	ff2492e3          	bne	s1,s2,1bb6 <kernmem+0x2a>
    1bd6:	60a6                	ld	ra,72(sp)
    1bd8:	6406                	ld	s0,64(sp)
    1bda:	74e2                	ld	s1,56(sp)
    1bdc:	7942                	ld	s2,48(sp)
    1bde:	79a2                	ld	s3,40(sp)
    1be0:	7a02                	ld	s4,32(sp)
    1be2:	6ae2                	ld	s5,24(sp)
    1be4:	6161                	addi	sp,sp,80
    1be6:	8082                	ret
    1be8:	85d6                	mv	a1,s5
    1bea:	00004517          	auipc	a0,0x4
    1bee:	f4e50513          	addi	a0,a0,-178 # 5b38 <malloc+0x9ca>
    1bf2:	4c8030ef          	jal	50ba <printf>
    1bf6:	4505                	li	a0,1
    1bf8:	08e030ef          	jal	4c86 <exit>
    1bfc:	0004c683          	lbu	a3,0(s1)
    1c00:	8626                	mv	a2,s1
    1c02:	85d6                	mv	a1,s5
    1c04:	00004517          	auipc	a0,0x4
    1c08:	20450513          	addi	a0,a0,516 # 5e08 <malloc+0xc9a>
    1c0c:	4ae030ef          	jal	50ba <printf>
    1c10:	4505                	li	a0,1
    1c12:	074030ef          	jal	4c86 <exit>
    1c16:	4505                	li	a0,1
    1c18:	06e030ef          	jal	4c86 <exit>

0000000000001c1c <MAXVAplus>:
    1c1c:	7179                	addi	sp,sp,-48
    1c1e:	f406                	sd	ra,40(sp)
    1c20:	f022                	sd	s0,32(sp)
    1c22:	1800                	addi	s0,sp,48
    1c24:	4785                	li	a5,1
    1c26:	179a                	slli	a5,a5,0x26
    1c28:	fcf43c23          	sd	a5,-40(s0)
    1c2c:	fd843783          	ld	a5,-40(s0)
    1c30:	cf85                	beqz	a5,1c68 <MAXVAplus+0x4c>
    1c32:	ec26                	sd	s1,24(sp)
    1c34:	e84a                	sd	s2,16(sp)
    1c36:	892a                	mv	s2,a0
    1c38:	54fd                	li	s1,-1
    1c3a:	044030ef          	jal	4c7e <fork>
    1c3e:	02054963          	bltz	a0,1c70 <MAXVAplus+0x54>
    1c42:	c129                	beqz	a0,1c84 <MAXVAplus+0x68>
    1c44:	fd440513          	addi	a0,s0,-44
    1c48:	046030ef          	jal	4c8e <wait>
    1c4c:	fd442783          	lw	a5,-44(s0)
    1c50:	04979c63          	bne	a5,s1,1ca8 <MAXVAplus+0x8c>
    1c54:	fd843783          	ld	a5,-40(s0)
    1c58:	0786                	slli	a5,a5,0x1
    1c5a:	fcf43c23          	sd	a5,-40(s0)
    1c5e:	fd843783          	ld	a5,-40(s0)
    1c62:	ffe1                	bnez	a5,1c3a <MAXVAplus+0x1e>
    1c64:	64e2                	ld	s1,24(sp)
    1c66:	6942                	ld	s2,16(sp)
    1c68:	70a2                	ld	ra,40(sp)
    1c6a:	7402                	ld	s0,32(sp)
    1c6c:	6145                	addi	sp,sp,48
    1c6e:	8082                	ret
    1c70:	85ca                	mv	a1,s2
    1c72:	00004517          	auipc	a0,0x4
    1c76:	ec650513          	addi	a0,a0,-314 # 5b38 <malloc+0x9ca>
    1c7a:	440030ef          	jal	50ba <printf>
    1c7e:	4505                	li	a0,1
    1c80:	006030ef          	jal	4c86 <exit>
    1c84:	fd843783          	ld	a5,-40(s0)
    1c88:	06300713          	li	a4,99
    1c8c:	00e78023          	sb	a4,0(a5)
    1c90:	fd843603          	ld	a2,-40(s0)
    1c94:	85ca                	mv	a1,s2
    1c96:	00004517          	auipc	a0,0x4
    1c9a:	19250513          	addi	a0,a0,402 # 5e28 <malloc+0xcba>
    1c9e:	41c030ef          	jal	50ba <printf>
    1ca2:	4505                	li	a0,1
    1ca4:	7e3020ef          	jal	4c86 <exit>
    1ca8:	4505                	li	a0,1
    1caa:	7dd020ef          	jal	4c86 <exit>

0000000000001cae <stacktest>:
    1cae:	7179                	addi	sp,sp,-48
    1cb0:	f406                	sd	ra,40(sp)
    1cb2:	f022                	sd	s0,32(sp)
    1cb4:	ec26                	sd	s1,24(sp)
    1cb6:	1800                	addi	s0,sp,48
    1cb8:	84aa                	mv	s1,a0
    1cba:	7c5020ef          	jal	4c7e <fork>
    1cbe:	cd11                	beqz	a0,1cda <stacktest+0x2c>
    1cc0:	02054c63          	bltz	a0,1cf8 <stacktest+0x4a>
    1cc4:	fdc40513          	addi	a0,s0,-36
    1cc8:	7c7020ef          	jal	4c8e <wait>
    1ccc:	fdc42503          	lw	a0,-36(s0)
    1cd0:	57fd                	li	a5,-1
    1cd2:	02f50d63          	beq	a0,a5,1d0c <stacktest+0x5e>
    1cd6:	7b1020ef          	jal	4c86 <exit>
    1cda:	870a                	mv	a4,sp
    1cdc:	77fd                	lui	a5,0xfffff
    1cde:	97ba                	add	a5,a5,a4
    1ce0:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef358>
    1ce4:	85a6                	mv	a1,s1
    1ce6:	00004517          	auipc	a0,0x4
    1cea:	15a50513          	addi	a0,a0,346 # 5e40 <malloc+0xcd2>
    1cee:	3cc030ef          	jal	50ba <printf>
    1cf2:	4505                	li	a0,1
    1cf4:	793020ef          	jal	4c86 <exit>
    1cf8:	85a6                	mv	a1,s1
    1cfa:	00004517          	auipc	a0,0x4
    1cfe:	e3e50513          	addi	a0,a0,-450 # 5b38 <malloc+0x9ca>
    1d02:	3b8030ef          	jal	50ba <printf>
    1d06:	4505                	li	a0,1
    1d08:	77f020ef          	jal	4c86 <exit>
    1d0c:	4501                	li	a0,0
    1d0e:	779020ef          	jal	4c86 <exit>

0000000000001d12 <nowrite>:
    1d12:	7159                	addi	sp,sp,-112
    1d14:	f486                	sd	ra,104(sp)
    1d16:	f0a2                	sd	s0,96(sp)
    1d18:	eca6                	sd	s1,88(sp)
    1d1a:	e8ca                	sd	s2,80(sp)
    1d1c:	e4ce                	sd	s3,72(sp)
    1d1e:	1880                	addi	s0,sp,112
    1d20:	89aa                	mv	s3,a0
    1d22:	00006797          	auipc	a5,0x6
    1d26:	9d678793          	addi	a5,a5,-1578 # 76f8 <malloc+0x258a>
    1d2a:	7788                	ld	a0,40(a5)
    1d2c:	7b8c                	ld	a1,48(a5)
    1d2e:	7f90                	ld	a2,56(a5)
    1d30:	63b4                	ld	a3,64(a5)
    1d32:	67b8                	ld	a4,72(a5)
    1d34:	6bbc                	ld	a5,80(a5)
    1d36:	f8a43c23          	sd	a0,-104(s0)
    1d3a:	fab43023          	sd	a1,-96(s0)
    1d3e:	fac43423          	sd	a2,-88(s0)
    1d42:	fad43823          	sd	a3,-80(s0)
    1d46:	fae43c23          	sd	a4,-72(s0)
    1d4a:	fcf43023          	sd	a5,-64(s0)
    1d4e:	4481                	li	s1,0
    1d50:	4919                	li	s2,6
    1d52:	72d020ef          	jal	4c7e <fork>
    1d56:	c105                	beqz	a0,1d76 <nowrite+0x64>
    1d58:	04054263          	bltz	a0,1d9c <nowrite+0x8a>
    1d5c:	fcc40513          	addi	a0,s0,-52
    1d60:	72f020ef          	jal	4c8e <wait>
    1d64:	fcc42783          	lw	a5,-52(s0)
    1d68:	c7a1                	beqz	a5,1db0 <nowrite+0x9e>
    1d6a:	2485                	addiw	s1,s1,1
    1d6c:	ff2493e3          	bne	s1,s2,1d52 <nowrite+0x40>
    1d70:	4501                	li	a0,0
    1d72:	715020ef          	jal	4c86 <exit>
    1d76:	048e                	slli	s1,s1,0x3
    1d78:	fd048793          	addi	a5,s1,-48
    1d7c:	008784b3          	add	s1,a5,s0
    1d80:	fc84b603          	ld	a2,-56(s1)
    1d84:	47a9                	li	a5,10
    1d86:	c21c                	sw	a5,0(a2)
    1d88:	85ce                	mv	a1,s3
    1d8a:	00004517          	auipc	a0,0x4
    1d8e:	0de50513          	addi	a0,a0,222 # 5e68 <malloc+0xcfa>
    1d92:	328030ef          	jal	50ba <printf>
    1d96:	4501                	li	a0,0
    1d98:	6ef020ef          	jal	4c86 <exit>
    1d9c:	85ce                	mv	a1,s3
    1d9e:	00004517          	auipc	a0,0x4
    1da2:	d9a50513          	addi	a0,a0,-614 # 5b38 <malloc+0x9ca>
    1da6:	314030ef          	jal	50ba <printf>
    1daa:	4505                	li	a0,1
    1dac:	6db020ef          	jal	4c86 <exit>
    1db0:	4505                	li	a0,1
    1db2:	6d5020ef          	jal	4c86 <exit>

0000000000001db6 <manywrites>:
    1db6:	711d                	addi	sp,sp,-96
    1db8:	ec86                	sd	ra,88(sp)
    1dba:	e8a2                	sd	s0,80(sp)
    1dbc:	e4a6                	sd	s1,72(sp)
    1dbe:	e0ca                	sd	s2,64(sp)
    1dc0:	fc4e                	sd	s3,56(sp)
    1dc2:	f456                	sd	s5,40(sp)
    1dc4:	1080                	addi	s0,sp,96
    1dc6:	8aaa                	mv	s5,a0
    1dc8:	4981                	li	s3,0
    1dca:	4911                	li	s2,4
    1dcc:	6b3020ef          	jal	4c7e <fork>
    1dd0:	84aa                	mv	s1,a0
    1dd2:	02054963          	bltz	a0,1e04 <manywrites+0x4e>
    1dd6:	c139                	beqz	a0,1e1c <manywrites+0x66>
    1dd8:	2985                	addiw	s3,s3,1
    1dda:	ff2999e3          	bne	s3,s2,1dcc <manywrites+0x16>
    1dde:	f852                	sd	s4,48(sp)
    1de0:	f05a                	sd	s6,32(sp)
    1de2:	ec5e                	sd	s7,24(sp)
    1de4:	4491                	li	s1,4
    1de6:	fa042423          	sw	zero,-88(s0)
    1dea:	fa840513          	addi	a0,s0,-88
    1dee:	6a1020ef          	jal	4c8e <wait>
    1df2:	fa842503          	lw	a0,-88(s0)
    1df6:	0c051863          	bnez	a0,1ec6 <manywrites+0x110>
    1dfa:	34fd                	addiw	s1,s1,-1
    1dfc:	f4ed                	bnez	s1,1de6 <manywrites+0x30>
    1dfe:	4501                	li	a0,0
    1e00:	687020ef          	jal	4c86 <exit>
    1e04:	f852                	sd	s4,48(sp)
    1e06:	f05a                	sd	s6,32(sp)
    1e08:	ec5e                	sd	s7,24(sp)
    1e0a:	00005517          	auipc	a0,0x5
    1e0e:	2d650513          	addi	a0,a0,726 # 70e0 <malloc+0x1f72>
    1e12:	2a8030ef          	jal	50ba <printf>
    1e16:	4505                	li	a0,1
    1e18:	66f020ef          	jal	4c86 <exit>
    1e1c:	f852                	sd	s4,48(sp)
    1e1e:	f05a                	sd	s6,32(sp)
    1e20:	ec5e                	sd	s7,24(sp)
    1e22:	06200793          	li	a5,98
    1e26:	faf40423          	sb	a5,-88(s0)
    1e2a:	0619879b          	addiw	a5,s3,97
    1e2e:	faf404a3          	sb	a5,-87(s0)
    1e32:	fa040523          	sb	zero,-86(s0)
    1e36:	fa840513          	addi	a0,s0,-88
    1e3a:	69d020ef          	jal	4cd6 <unlink>
    1e3e:	4bf9                	li	s7,30
    1e40:	0000bb17          	auipc	s6,0xb
    1e44:	e68b0b13          	addi	s6,s6,-408 # cca8 <buf>
    1e48:	8a26                	mv	s4,s1
    1e4a:	0209c863          	bltz	s3,1e7a <manywrites+0xc4>
    1e4e:	20200593          	li	a1,514
    1e52:	fa840513          	addi	a0,s0,-88
    1e56:	671020ef          	jal	4cc6 <open>
    1e5a:	892a                	mv	s2,a0
    1e5c:	02054d63          	bltz	a0,1e96 <manywrites+0xe0>
    1e60:	660d                	lui	a2,0x3
    1e62:	85da                	mv	a1,s6
    1e64:	643020ef          	jal	4ca6 <write>
    1e68:	678d                	lui	a5,0x3
    1e6a:	04f51263          	bne	a0,a5,1eae <manywrites+0xf8>
    1e6e:	854a                	mv	a0,s2
    1e70:	63f020ef          	jal	4cae <close>
    1e74:	2a05                	addiw	s4,s4,1
    1e76:	fd49dce3          	bge	s3,s4,1e4e <manywrites+0x98>
    1e7a:	fa840513          	addi	a0,s0,-88
    1e7e:	659020ef          	jal	4cd6 <unlink>
    1e82:	3bfd                	addiw	s7,s7,-1
    1e84:	fc0b92e3          	bnez	s7,1e48 <manywrites+0x92>
    1e88:	fa840513          	addi	a0,s0,-88
    1e8c:	64b020ef          	jal	4cd6 <unlink>
    1e90:	4501                	li	a0,0
    1e92:	5f5020ef          	jal	4c86 <exit>
    1e96:	fa840613          	addi	a2,s0,-88
    1e9a:	85d6                	mv	a1,s5
    1e9c:	00004517          	auipc	a0,0x4
    1ea0:	fec50513          	addi	a0,a0,-20 # 5e88 <malloc+0xd1a>
    1ea4:	216030ef          	jal	50ba <printf>
    1ea8:	4505                	li	a0,1
    1eaa:	5dd020ef          	jal	4c86 <exit>
    1eae:	86aa                	mv	a3,a0
    1eb0:	660d                	lui	a2,0x3
    1eb2:	85d6                	mv	a1,s5
    1eb4:	00003517          	auipc	a0,0x3
    1eb8:	4c450513          	addi	a0,a0,1220 # 5378 <malloc+0x20a>
    1ebc:	1fe030ef          	jal	50ba <printf>
    1ec0:	4505                	li	a0,1
    1ec2:	5c5020ef          	jal	4c86 <exit>
    1ec6:	5c1020ef          	jal	4c86 <exit>

0000000000001eca <copyinstr3>:
    1eca:	7179                	addi	sp,sp,-48
    1ecc:	f406                	sd	ra,40(sp)
    1ece:	f022                	sd	s0,32(sp)
    1ed0:	ec26                	sd	s1,24(sp)
    1ed2:	1800                	addi	s0,sp,48
    1ed4:	6509                	lui	a0,0x2
    1ed6:	57d020ef          	jal	4c52 <sbrk>
    1eda:	4501                	li	a0,0
    1edc:	577020ef          	jal	4c52 <sbrk>
    1ee0:	03451793          	slli	a5,a0,0x34
    1ee4:	e7bd                	bnez	a5,1f52 <copyinstr3+0x88>
    1ee6:	4501                	li	a0,0
    1ee8:	56b020ef          	jal	4c52 <sbrk>
    1eec:	03451793          	slli	a5,a0,0x34
    1ef0:	ebad                	bnez	a5,1f62 <copyinstr3+0x98>
    1ef2:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x31>
    1ef6:	07800793          	li	a5,120
    1efa:	fef50fa3          	sb	a5,-1(a0)
    1efe:	8526                	mv	a0,s1
    1f00:	5d7020ef          	jal	4cd6 <unlink>
    1f04:	57fd                	li	a5,-1
    1f06:	06f51763          	bne	a0,a5,1f74 <copyinstr3+0xaa>
    1f0a:	20100593          	li	a1,513
    1f0e:	8526                	mv	a0,s1
    1f10:	5b7020ef          	jal	4cc6 <open>
    1f14:	57fd                	li	a5,-1
    1f16:	06f51a63          	bne	a0,a5,1f8a <copyinstr3+0xc0>
    1f1a:	85a6                	mv	a1,s1
    1f1c:	8526                	mv	a0,s1
    1f1e:	5c9020ef          	jal	4ce6 <link>
    1f22:	57fd                	li	a5,-1
    1f24:	06f51e63          	bne	a0,a5,1fa0 <copyinstr3+0xd6>
    1f28:	00005797          	auipc	a5,0x5
    1f2c:	c6078793          	addi	a5,a5,-928 # 6b88 <malloc+0x1a1a>
    1f30:	fcf43823          	sd	a5,-48(s0)
    1f34:	fc043c23          	sd	zero,-40(s0)
    1f38:	fd040593          	addi	a1,s0,-48
    1f3c:	8526                	mv	a0,s1
    1f3e:	581020ef          	jal	4cbe <exec>
    1f42:	57fd                	li	a5,-1
    1f44:	06f51a63          	bne	a0,a5,1fb8 <copyinstr3+0xee>
    1f48:	70a2                	ld	ra,40(sp)
    1f4a:	7402                	ld	s0,32(sp)
    1f4c:	64e2                	ld	s1,24(sp)
    1f4e:	6145                	addi	sp,sp,48
    1f50:	8082                	ret
    1f52:	0347d513          	srli	a0,a5,0x34
    1f56:	6785                	lui	a5,0x1
    1f58:	40a7853b          	subw	a0,a5,a0
    1f5c:	4f7020ef          	jal	4c52 <sbrk>
    1f60:	b759                	j	1ee6 <copyinstr3+0x1c>
    1f62:	00004517          	auipc	a0,0x4
    1f66:	f3e50513          	addi	a0,a0,-194 # 5ea0 <malloc+0xd32>
    1f6a:	150030ef          	jal	50ba <printf>
    1f6e:	4505                	li	a0,1
    1f70:	517020ef          	jal	4c86 <exit>
    1f74:	862a                	mv	a2,a0
    1f76:	85a6                	mv	a1,s1
    1f78:	00004517          	auipc	a0,0x4
    1f7c:	ae050513          	addi	a0,a0,-1312 # 5a58 <malloc+0x8ea>
    1f80:	13a030ef          	jal	50ba <printf>
    1f84:	4505                	li	a0,1
    1f86:	501020ef          	jal	4c86 <exit>
    1f8a:	862a                	mv	a2,a0
    1f8c:	85a6                	mv	a1,s1
    1f8e:	00004517          	auipc	a0,0x4
    1f92:	aea50513          	addi	a0,a0,-1302 # 5a78 <malloc+0x90a>
    1f96:	124030ef          	jal	50ba <printf>
    1f9a:	4505                	li	a0,1
    1f9c:	4eb020ef          	jal	4c86 <exit>
    1fa0:	86aa                	mv	a3,a0
    1fa2:	8626                	mv	a2,s1
    1fa4:	85a6                	mv	a1,s1
    1fa6:	00004517          	auipc	a0,0x4
    1faa:	af250513          	addi	a0,a0,-1294 # 5a98 <malloc+0x92a>
    1fae:	10c030ef          	jal	50ba <printf>
    1fb2:	4505                	li	a0,1
    1fb4:	4d3020ef          	jal	4c86 <exit>
    1fb8:	567d                	li	a2,-1
    1fba:	85a6                	mv	a1,s1
    1fbc:	00004517          	auipc	a0,0x4
    1fc0:	b0450513          	addi	a0,a0,-1276 # 5ac0 <malloc+0x952>
    1fc4:	0f6030ef          	jal	50ba <printf>
    1fc8:	4505                	li	a0,1
    1fca:	4bd020ef          	jal	4c86 <exit>

0000000000001fce <rwsbrk>:
    1fce:	1101                	addi	sp,sp,-32
    1fd0:	ec06                	sd	ra,24(sp)
    1fd2:	e822                	sd	s0,16(sp)
    1fd4:	1000                	addi	s0,sp,32
    1fd6:	6509                	lui	a0,0x2
    1fd8:	47b020ef          	jal	4c52 <sbrk>
    1fdc:	57fd                	li	a5,-1
    1fde:	04f50a63          	beq	a0,a5,2032 <rwsbrk+0x64>
    1fe2:	e426                	sd	s1,8(sp)
    1fe4:	84aa                	mv	s1,a0
    1fe6:	7579                	lui	a0,0xffffe
    1fe8:	46b020ef          	jal	4c52 <sbrk>
    1fec:	57fd                	li	a5,-1
    1fee:	04f50d63          	beq	a0,a5,2048 <rwsbrk+0x7a>
    1ff2:	e04a                	sd	s2,0(sp)
    1ff4:	20100593          	li	a1,513
    1ff8:	00004517          	auipc	a0,0x4
    1ffc:	ee850513          	addi	a0,a0,-280 # 5ee0 <malloc+0xd72>
    2000:	4c7020ef          	jal	4cc6 <open>
    2004:	892a                	mv	s2,a0
    2006:	04054b63          	bltz	a0,205c <rwsbrk+0x8e>
    200a:	6785                	lui	a5,0x1
    200c:	94be                	add	s1,s1,a5
    200e:	40000613          	li	a2,1024
    2012:	85a6                	mv	a1,s1
    2014:	493020ef          	jal	4ca6 <write>
    2018:	862a                	mv	a2,a0
    201a:	04054a63          	bltz	a0,206e <rwsbrk+0xa0>
    201e:	85a6                	mv	a1,s1
    2020:	00004517          	auipc	a0,0x4
    2024:	ee050513          	addi	a0,a0,-288 # 5f00 <malloc+0xd92>
    2028:	092030ef          	jal	50ba <printf>
    202c:	4505                	li	a0,1
    202e:	459020ef          	jal	4c86 <exit>
    2032:	e426                	sd	s1,8(sp)
    2034:	e04a                	sd	s2,0(sp)
    2036:	00004517          	auipc	a0,0x4
    203a:	e7250513          	addi	a0,a0,-398 # 5ea8 <malloc+0xd3a>
    203e:	07c030ef          	jal	50ba <printf>
    2042:	4505                	li	a0,1
    2044:	443020ef          	jal	4c86 <exit>
    2048:	e04a                	sd	s2,0(sp)
    204a:	00004517          	auipc	a0,0x4
    204e:	e7650513          	addi	a0,a0,-394 # 5ec0 <malloc+0xd52>
    2052:	068030ef          	jal	50ba <printf>
    2056:	4505                	li	a0,1
    2058:	42f020ef          	jal	4c86 <exit>
    205c:	00004517          	auipc	a0,0x4
    2060:	e8c50513          	addi	a0,a0,-372 # 5ee8 <malloc+0xd7a>
    2064:	056030ef          	jal	50ba <printf>
    2068:	4505                	li	a0,1
    206a:	41d020ef          	jal	4c86 <exit>
    206e:	854a                	mv	a0,s2
    2070:	43f020ef          	jal	4cae <close>
    2074:	00004517          	auipc	a0,0x4
    2078:	e6c50513          	addi	a0,a0,-404 # 5ee0 <malloc+0xd72>
    207c:	45b020ef          	jal	4cd6 <unlink>
    2080:	4581                	li	a1,0
    2082:	00003517          	auipc	a0,0x3
    2086:	3fe50513          	addi	a0,a0,1022 # 5480 <malloc+0x312>
    208a:	43d020ef          	jal	4cc6 <open>
    208e:	892a                	mv	s2,a0
    2090:	02054363          	bltz	a0,20b6 <rwsbrk+0xe8>
    2094:	4629                	li	a2,10
    2096:	85a6                	mv	a1,s1
    2098:	407020ef          	jal	4c9e <read>
    209c:	862a                	mv	a2,a0
    209e:	02054563          	bltz	a0,20c8 <rwsbrk+0xfa>
    20a2:	85a6                	mv	a1,s1
    20a4:	00004517          	auipc	a0,0x4
    20a8:	e8c50513          	addi	a0,a0,-372 # 5f30 <malloc+0xdc2>
    20ac:	00e030ef          	jal	50ba <printf>
    20b0:	4505                	li	a0,1
    20b2:	3d5020ef          	jal	4c86 <exit>
    20b6:	00003517          	auipc	a0,0x3
    20ba:	3d250513          	addi	a0,a0,978 # 5488 <malloc+0x31a>
    20be:	7fd020ef          	jal	50ba <printf>
    20c2:	4505                	li	a0,1
    20c4:	3c3020ef          	jal	4c86 <exit>
    20c8:	854a                	mv	a0,s2
    20ca:	3e5020ef          	jal	4cae <close>
    20ce:	4501                	li	a0,0
    20d0:	3b7020ef          	jal	4c86 <exit>

00000000000020d4 <sbrkbasic>:
    20d4:	7139                	addi	sp,sp,-64
    20d6:	fc06                	sd	ra,56(sp)
    20d8:	f822                	sd	s0,48(sp)
    20da:	ec4e                	sd	s3,24(sp)
    20dc:	0080                	addi	s0,sp,64
    20de:	89aa                	mv	s3,a0
    20e0:	39f020ef          	jal	4c7e <fork>
    20e4:	02054b63          	bltz	a0,211a <sbrkbasic+0x46>
    20e8:	e939                	bnez	a0,213e <sbrkbasic+0x6a>
    20ea:	40000537          	lui	a0,0x40000
    20ee:	365020ef          	jal	4c52 <sbrk>
    20f2:	57fd                	li	a5,-1
    20f4:	02f50f63          	beq	a0,a5,2132 <sbrkbasic+0x5e>
    20f8:	f426                	sd	s1,40(sp)
    20fa:	f04a                	sd	s2,32(sp)
    20fc:	e852                	sd	s4,16(sp)
    20fe:	400007b7          	lui	a5,0x40000
    2102:	97aa                	add	a5,a5,a0
    2104:	06300693          	li	a3,99
    2108:	6705                	lui	a4,0x1
    210a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0358>
    210e:	953a                	add	a0,a0,a4
    2110:	fef51de3          	bne	a0,a5,210a <sbrkbasic+0x36>
    2114:	4505                	li	a0,1
    2116:	371020ef          	jal	4c86 <exit>
    211a:	f426                	sd	s1,40(sp)
    211c:	f04a                	sd	s2,32(sp)
    211e:	e852                	sd	s4,16(sp)
    2120:	00004517          	auipc	a0,0x4
    2124:	e3850513          	addi	a0,a0,-456 # 5f58 <malloc+0xdea>
    2128:	793020ef          	jal	50ba <printf>
    212c:	4505                	li	a0,1
    212e:	359020ef          	jal	4c86 <exit>
    2132:	f426                	sd	s1,40(sp)
    2134:	f04a                	sd	s2,32(sp)
    2136:	e852                	sd	s4,16(sp)
    2138:	4501                	li	a0,0
    213a:	34d020ef          	jal	4c86 <exit>
    213e:	fcc40513          	addi	a0,s0,-52
    2142:	34d020ef          	jal	4c8e <wait>
    2146:	fcc42703          	lw	a4,-52(s0)
    214a:	4785                	li	a5,1
    214c:	00f70e63          	beq	a4,a5,2168 <sbrkbasic+0x94>
    2150:	f426                	sd	s1,40(sp)
    2152:	f04a                	sd	s2,32(sp)
    2154:	e852                	sd	s4,16(sp)
    2156:	4501                	li	a0,0
    2158:	2fb020ef          	jal	4c52 <sbrk>
    215c:	84aa                	mv	s1,a0
    215e:	4901                	li	s2,0
    2160:	6a05                	lui	s4,0x1
    2162:	388a0a13          	addi	s4,s4,904 # 1388 <exectest+0x4a>
    2166:	a839                	j	2184 <sbrkbasic+0xb0>
    2168:	f426                	sd	s1,40(sp)
    216a:	f04a                	sd	s2,32(sp)
    216c:	e852                	sd	s4,16(sp)
    216e:	85ce                	mv	a1,s3
    2170:	00004517          	auipc	a0,0x4
    2174:	e0850513          	addi	a0,a0,-504 # 5f78 <malloc+0xe0a>
    2178:	743020ef          	jal	50ba <printf>
    217c:	4505                	li	a0,1
    217e:	309020ef          	jal	4c86 <exit>
    2182:	84be                	mv	s1,a5
    2184:	4505                	li	a0,1
    2186:	2cd020ef          	jal	4c52 <sbrk>
    218a:	04951263          	bne	a0,s1,21ce <sbrkbasic+0xfa>
    218e:	4785                	li	a5,1
    2190:	00f48023          	sb	a5,0(s1)
    2194:	00148793          	addi	a5,s1,1
    2198:	2905                	addiw	s2,s2,1
    219a:	ff4914e3          	bne	s2,s4,2182 <sbrkbasic+0xae>
    219e:	2e1020ef          	jal	4c7e <fork>
    21a2:	892a                	mv	s2,a0
    21a4:	04054263          	bltz	a0,21e8 <sbrkbasic+0x114>
    21a8:	4505                	li	a0,1
    21aa:	2a9020ef          	jal	4c52 <sbrk>
    21ae:	4505                	li	a0,1
    21b0:	2a3020ef          	jal	4c52 <sbrk>
    21b4:	0489                	addi	s1,s1,2
    21b6:	04a48363          	beq	s1,a0,21fc <sbrkbasic+0x128>
    21ba:	85ce                	mv	a1,s3
    21bc:	00004517          	auipc	a0,0x4
    21c0:	e1c50513          	addi	a0,a0,-484 # 5fd8 <malloc+0xe6a>
    21c4:	6f7020ef          	jal	50ba <printf>
    21c8:	4505                	li	a0,1
    21ca:	2bd020ef          	jal	4c86 <exit>
    21ce:	872a                	mv	a4,a0
    21d0:	86a6                	mv	a3,s1
    21d2:	864a                	mv	a2,s2
    21d4:	85ce                	mv	a1,s3
    21d6:	00004517          	auipc	a0,0x4
    21da:	dc250513          	addi	a0,a0,-574 # 5f98 <malloc+0xe2a>
    21de:	6dd020ef          	jal	50ba <printf>
    21e2:	4505                	li	a0,1
    21e4:	2a3020ef          	jal	4c86 <exit>
    21e8:	85ce                	mv	a1,s3
    21ea:	00004517          	auipc	a0,0x4
    21ee:	dce50513          	addi	a0,a0,-562 # 5fb8 <malloc+0xe4a>
    21f2:	6c9020ef          	jal	50ba <printf>
    21f6:	4505                	li	a0,1
    21f8:	28f020ef          	jal	4c86 <exit>
    21fc:	00091563          	bnez	s2,2206 <sbrkbasic+0x132>
    2200:	4501                	li	a0,0
    2202:	285020ef          	jal	4c86 <exit>
    2206:	fcc40513          	addi	a0,s0,-52
    220a:	285020ef          	jal	4c8e <wait>
    220e:	fcc42503          	lw	a0,-52(s0)
    2212:	275020ef          	jal	4c86 <exit>

0000000000002216 <sbrkmuch>:
    2216:	7179                	addi	sp,sp,-48
    2218:	f406                	sd	ra,40(sp)
    221a:	f022                	sd	s0,32(sp)
    221c:	ec26                	sd	s1,24(sp)
    221e:	e84a                	sd	s2,16(sp)
    2220:	e44e                	sd	s3,8(sp)
    2222:	e052                	sd	s4,0(sp)
    2224:	1800                	addi	s0,sp,48
    2226:	89aa                	mv	s3,a0
    2228:	4501                	li	a0,0
    222a:	229020ef          	jal	4c52 <sbrk>
    222e:	892a                	mv	s2,a0
    2230:	4501                	li	a0,0
    2232:	221020ef          	jal	4c52 <sbrk>
    2236:	84aa                	mv	s1,a0
    2238:	06400537          	lui	a0,0x6400
    223c:	9d05                	subw	a0,a0,s1
    223e:	215020ef          	jal	4c52 <sbrk>
    2242:	08a49763          	bne	s1,a0,22d0 <sbrkmuch+0xba>
    2246:	064007b7          	lui	a5,0x6400
    224a:	06300713          	li	a4,99
    224e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0357>
    2252:	4501                	li	a0,0
    2254:	1ff020ef          	jal	4c52 <sbrk>
    2258:	84aa                	mv	s1,a0
    225a:	757d                	lui	a0,0xfffff
    225c:	1f7020ef          	jal	4c52 <sbrk>
    2260:	57fd                	li	a5,-1
    2262:	08f50163          	beq	a0,a5,22e4 <sbrkmuch+0xce>
    2266:	4501                	li	a0,0
    2268:	1eb020ef          	jal	4c52 <sbrk>
    226c:	77fd                	lui	a5,0xfffff
    226e:	97a6                	add	a5,a5,s1
    2270:	08f51463          	bne	a0,a5,22f8 <sbrkmuch+0xe2>
    2274:	4501                	li	a0,0
    2276:	1dd020ef          	jal	4c52 <sbrk>
    227a:	84aa                	mv	s1,a0
    227c:	6505                	lui	a0,0x1
    227e:	1d5020ef          	jal	4c52 <sbrk>
    2282:	8a2a                	mv	s4,a0
    2284:	08a49663          	bne	s1,a0,2310 <sbrkmuch+0xfa>
    2288:	4501                	li	a0,0
    228a:	1c9020ef          	jal	4c52 <sbrk>
    228e:	6785                	lui	a5,0x1
    2290:	97a6                	add	a5,a5,s1
    2292:	06f51f63          	bne	a0,a5,2310 <sbrkmuch+0xfa>
    2296:	064007b7          	lui	a5,0x6400
    229a:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0357>
    229e:	06300793          	li	a5,99
    22a2:	08f70363          	beq	a4,a5,2328 <sbrkmuch+0x112>
    22a6:	4501                	li	a0,0
    22a8:	1ab020ef          	jal	4c52 <sbrk>
    22ac:	84aa                	mv	s1,a0
    22ae:	4501                	li	a0,0
    22b0:	1a3020ef          	jal	4c52 <sbrk>
    22b4:	40a9053b          	subw	a0,s2,a0
    22b8:	19b020ef          	jal	4c52 <sbrk>
    22bc:	08a49063          	bne	s1,a0,233c <sbrkmuch+0x126>
    22c0:	70a2                	ld	ra,40(sp)
    22c2:	7402                	ld	s0,32(sp)
    22c4:	64e2                	ld	s1,24(sp)
    22c6:	6942                	ld	s2,16(sp)
    22c8:	69a2                	ld	s3,8(sp)
    22ca:	6a02                	ld	s4,0(sp)
    22cc:	6145                	addi	sp,sp,48
    22ce:	8082                	ret
    22d0:	85ce                	mv	a1,s3
    22d2:	00004517          	auipc	a0,0x4
    22d6:	d2650513          	addi	a0,a0,-730 # 5ff8 <malloc+0xe8a>
    22da:	5e1020ef          	jal	50ba <printf>
    22de:	4505                	li	a0,1
    22e0:	1a7020ef          	jal	4c86 <exit>
    22e4:	85ce                	mv	a1,s3
    22e6:	00004517          	auipc	a0,0x4
    22ea:	d5a50513          	addi	a0,a0,-678 # 6040 <malloc+0xed2>
    22ee:	5cd020ef          	jal	50ba <printf>
    22f2:	4505                	li	a0,1
    22f4:	193020ef          	jal	4c86 <exit>
    22f8:	86aa                	mv	a3,a0
    22fa:	8626                	mv	a2,s1
    22fc:	85ce                	mv	a1,s3
    22fe:	00004517          	auipc	a0,0x4
    2302:	d6250513          	addi	a0,a0,-670 # 6060 <malloc+0xef2>
    2306:	5b5020ef          	jal	50ba <printf>
    230a:	4505                	li	a0,1
    230c:	17b020ef          	jal	4c86 <exit>
    2310:	86d2                	mv	a3,s4
    2312:	8626                	mv	a2,s1
    2314:	85ce                	mv	a1,s3
    2316:	00004517          	auipc	a0,0x4
    231a:	d8a50513          	addi	a0,a0,-630 # 60a0 <malloc+0xf32>
    231e:	59d020ef          	jal	50ba <printf>
    2322:	4505                	li	a0,1
    2324:	163020ef          	jal	4c86 <exit>
    2328:	85ce                	mv	a1,s3
    232a:	00004517          	auipc	a0,0x4
    232e:	da650513          	addi	a0,a0,-602 # 60d0 <malloc+0xf62>
    2332:	589020ef          	jal	50ba <printf>
    2336:	4505                	li	a0,1
    2338:	14f020ef          	jal	4c86 <exit>
    233c:	86aa                	mv	a3,a0
    233e:	8626                	mv	a2,s1
    2340:	85ce                	mv	a1,s3
    2342:	00004517          	auipc	a0,0x4
    2346:	dc650513          	addi	a0,a0,-570 # 6108 <malloc+0xf9a>
    234a:	571020ef          	jal	50ba <printf>
    234e:	4505                	li	a0,1
    2350:	137020ef          	jal	4c86 <exit>

0000000000002354 <sbrkarg>:
    2354:	7179                	addi	sp,sp,-48
    2356:	f406                	sd	ra,40(sp)
    2358:	f022                	sd	s0,32(sp)
    235a:	ec26                	sd	s1,24(sp)
    235c:	e84a                	sd	s2,16(sp)
    235e:	e44e                	sd	s3,8(sp)
    2360:	1800                	addi	s0,sp,48
    2362:	89aa                	mv	s3,a0
    2364:	6505                	lui	a0,0x1
    2366:	0ed020ef          	jal	4c52 <sbrk>
    236a:	892a                	mv	s2,a0
    236c:	20100593          	li	a1,513
    2370:	00004517          	auipc	a0,0x4
    2374:	dc050513          	addi	a0,a0,-576 # 6130 <malloc+0xfc2>
    2378:	14f020ef          	jal	4cc6 <open>
    237c:	84aa                	mv	s1,a0
    237e:	00004517          	auipc	a0,0x4
    2382:	db250513          	addi	a0,a0,-590 # 6130 <malloc+0xfc2>
    2386:	151020ef          	jal	4cd6 <unlink>
    238a:	0204c963          	bltz	s1,23bc <sbrkarg+0x68>
    238e:	6605                	lui	a2,0x1
    2390:	85ca                	mv	a1,s2
    2392:	8526                	mv	a0,s1
    2394:	113020ef          	jal	4ca6 <write>
    2398:	02054c63          	bltz	a0,23d0 <sbrkarg+0x7c>
    239c:	8526                	mv	a0,s1
    239e:	111020ef          	jal	4cae <close>
    23a2:	6505                	lui	a0,0x1
    23a4:	0af020ef          	jal	4c52 <sbrk>
    23a8:	0ef020ef          	jal	4c96 <pipe>
    23ac:	ed05                	bnez	a0,23e4 <sbrkarg+0x90>
    23ae:	70a2                	ld	ra,40(sp)
    23b0:	7402                	ld	s0,32(sp)
    23b2:	64e2                	ld	s1,24(sp)
    23b4:	6942                	ld	s2,16(sp)
    23b6:	69a2                	ld	s3,8(sp)
    23b8:	6145                	addi	sp,sp,48
    23ba:	8082                	ret
    23bc:	85ce                	mv	a1,s3
    23be:	00004517          	auipc	a0,0x4
    23c2:	d7a50513          	addi	a0,a0,-646 # 6138 <malloc+0xfca>
    23c6:	4f5020ef          	jal	50ba <printf>
    23ca:	4505                	li	a0,1
    23cc:	0bb020ef          	jal	4c86 <exit>
    23d0:	85ce                	mv	a1,s3
    23d2:	00004517          	auipc	a0,0x4
    23d6:	d7e50513          	addi	a0,a0,-642 # 6150 <malloc+0xfe2>
    23da:	4e1020ef          	jal	50ba <printf>
    23de:	4505                	li	a0,1
    23e0:	0a7020ef          	jal	4c86 <exit>
    23e4:	85ce                	mv	a1,s3
    23e6:	00004517          	auipc	a0,0x4
    23ea:	85a50513          	addi	a0,a0,-1958 # 5c40 <malloc+0xad2>
    23ee:	4cd020ef          	jal	50ba <printf>
    23f2:	4505                	li	a0,1
    23f4:	093020ef          	jal	4c86 <exit>

00000000000023f8 <argptest>:
    23f8:	1101                	addi	sp,sp,-32
    23fa:	ec06                	sd	ra,24(sp)
    23fc:	e822                	sd	s0,16(sp)
    23fe:	e426                	sd	s1,8(sp)
    2400:	e04a                	sd	s2,0(sp)
    2402:	1000                	addi	s0,sp,32
    2404:	892a                	mv	s2,a0
    2406:	4581                	li	a1,0
    2408:	00004517          	auipc	a0,0x4
    240c:	d6050513          	addi	a0,a0,-672 # 6168 <malloc+0xffa>
    2410:	0b7020ef          	jal	4cc6 <open>
    2414:	02054563          	bltz	a0,243e <argptest+0x46>
    2418:	84aa                	mv	s1,a0
    241a:	4501                	li	a0,0
    241c:	037020ef          	jal	4c52 <sbrk>
    2420:	567d                	li	a2,-1
    2422:	fff50593          	addi	a1,a0,-1
    2426:	8526                	mv	a0,s1
    2428:	077020ef          	jal	4c9e <read>
    242c:	8526                	mv	a0,s1
    242e:	081020ef          	jal	4cae <close>
    2432:	60e2                	ld	ra,24(sp)
    2434:	6442                	ld	s0,16(sp)
    2436:	64a2                	ld	s1,8(sp)
    2438:	6902                	ld	s2,0(sp)
    243a:	6105                	addi	sp,sp,32
    243c:	8082                	ret
    243e:	85ca                	mv	a1,s2
    2440:	00003517          	auipc	a0,0x3
    2444:	71050513          	addi	a0,a0,1808 # 5b50 <malloc+0x9e2>
    2448:	473020ef          	jal	50ba <printf>
    244c:	4505                	li	a0,1
    244e:	039020ef          	jal	4c86 <exit>

0000000000002452 <sbrkbugs>:
    2452:	1141                	addi	sp,sp,-16
    2454:	e406                	sd	ra,8(sp)
    2456:	e022                	sd	s0,0(sp)
    2458:	0800                	addi	s0,sp,16
    245a:	025020ef          	jal	4c7e <fork>
    245e:	00054c63          	bltz	a0,2476 <sbrkbugs+0x24>
    2462:	e11d                	bnez	a0,2488 <sbrkbugs+0x36>
    2464:	7ee020ef          	jal	4c52 <sbrk>
    2468:	40a0053b          	negw	a0,a0
    246c:	7e6020ef          	jal	4c52 <sbrk>
    2470:	4501                	li	a0,0
    2472:	015020ef          	jal	4c86 <exit>
    2476:	00005517          	auipc	a0,0x5
    247a:	c6a50513          	addi	a0,a0,-918 # 70e0 <malloc+0x1f72>
    247e:	43d020ef          	jal	50ba <printf>
    2482:	4505                	li	a0,1
    2484:	003020ef          	jal	4c86 <exit>
    2488:	4501                	li	a0,0
    248a:	005020ef          	jal	4c8e <wait>
    248e:	7f0020ef          	jal	4c7e <fork>
    2492:	00054f63          	bltz	a0,24b0 <sbrkbugs+0x5e>
    2496:	e515                	bnez	a0,24c2 <sbrkbugs+0x70>
    2498:	7ba020ef          	jal	4c52 <sbrk>
    249c:	6785                	lui	a5,0x1
    249e:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x138>
    24a2:	40a7853b          	subw	a0,a5,a0
    24a6:	7ac020ef          	jal	4c52 <sbrk>
    24aa:	4501                	li	a0,0
    24ac:	7da020ef          	jal	4c86 <exit>
    24b0:	00005517          	auipc	a0,0x5
    24b4:	c3050513          	addi	a0,a0,-976 # 70e0 <malloc+0x1f72>
    24b8:	403020ef          	jal	50ba <printf>
    24bc:	4505                	li	a0,1
    24be:	7c8020ef          	jal	4c86 <exit>
    24c2:	4501                	li	a0,0
    24c4:	7ca020ef          	jal	4c8e <wait>
    24c8:	7b6020ef          	jal	4c7e <fork>
    24cc:	02054263          	bltz	a0,24f0 <sbrkbugs+0x9e>
    24d0:	e90d                	bnez	a0,2502 <sbrkbugs+0xb0>
    24d2:	780020ef          	jal	4c52 <sbrk>
    24d6:	67ad                	lui	a5,0xb
    24d8:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x268>
    24dc:	40a7853b          	subw	a0,a5,a0
    24e0:	772020ef          	jal	4c52 <sbrk>
    24e4:	5559                	li	a0,-10
    24e6:	76c020ef          	jal	4c52 <sbrk>
    24ea:	4501                	li	a0,0
    24ec:	79a020ef          	jal	4c86 <exit>
    24f0:	00005517          	auipc	a0,0x5
    24f4:	bf050513          	addi	a0,a0,-1040 # 70e0 <malloc+0x1f72>
    24f8:	3c3020ef          	jal	50ba <printf>
    24fc:	4505                	li	a0,1
    24fe:	788020ef          	jal	4c86 <exit>
    2502:	4501                	li	a0,0
    2504:	78a020ef          	jal	4c8e <wait>
    2508:	4501                	li	a0,0
    250a:	77c020ef          	jal	4c86 <exit>

000000000000250e <sbrklast>:
    250e:	7179                	addi	sp,sp,-48
    2510:	f406                	sd	ra,40(sp)
    2512:	f022                	sd	s0,32(sp)
    2514:	ec26                	sd	s1,24(sp)
    2516:	e84a                	sd	s2,16(sp)
    2518:	e44e                	sd	s3,8(sp)
    251a:	e052                	sd	s4,0(sp)
    251c:	1800                	addi	s0,sp,48
    251e:	4501                	li	a0,0
    2520:	732020ef          	jal	4c52 <sbrk>
    2524:	03451793          	slli	a5,a0,0x34
    2528:	ebad                	bnez	a5,259a <sbrklast+0x8c>
    252a:	6505                	lui	a0,0x1
    252c:	726020ef          	jal	4c52 <sbrk>
    2530:	4529                	li	a0,10
    2532:	720020ef          	jal	4c52 <sbrk>
    2536:	5531                	li	a0,-20
    2538:	71a020ef          	jal	4c52 <sbrk>
    253c:	4501                	li	a0,0
    253e:	714020ef          	jal	4c52 <sbrk>
    2542:	84aa                	mv	s1,a0
    2544:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x122>
    2548:	07800a13          	li	s4,120
    254c:	fd450023          	sb	s4,-64(a0)
    2550:	fc0500a3          	sb	zero,-63(a0)
    2554:	20200593          	li	a1,514
    2558:	854a                	mv	a0,s2
    255a:	76c020ef          	jal	4cc6 <open>
    255e:	89aa                	mv	s3,a0
    2560:	4605                	li	a2,1
    2562:	85ca                	mv	a1,s2
    2564:	742020ef          	jal	4ca6 <write>
    2568:	854e                	mv	a0,s3
    256a:	744020ef          	jal	4cae <close>
    256e:	4589                	li	a1,2
    2570:	854a                	mv	a0,s2
    2572:	754020ef          	jal	4cc6 <open>
    2576:	fc048023          	sb	zero,-64(s1)
    257a:	4605                	li	a2,1
    257c:	85ca                	mv	a1,s2
    257e:	720020ef          	jal	4c9e <read>
    2582:	fc04c783          	lbu	a5,-64(s1)
    2586:	03479263          	bne	a5,s4,25aa <sbrklast+0x9c>
    258a:	70a2                	ld	ra,40(sp)
    258c:	7402                	ld	s0,32(sp)
    258e:	64e2                	ld	s1,24(sp)
    2590:	6942                	ld	s2,16(sp)
    2592:	69a2                	ld	s3,8(sp)
    2594:	6a02                	ld	s4,0(sp)
    2596:	6145                	addi	sp,sp,48
    2598:	8082                	ret
    259a:	0347d513          	srli	a0,a5,0x34
    259e:	6785                	lui	a5,0x1
    25a0:	40a7853b          	subw	a0,a5,a0
    25a4:	6ae020ef          	jal	4c52 <sbrk>
    25a8:	b749                	j	252a <sbrklast+0x1c>
    25aa:	4505                	li	a0,1
    25ac:	6da020ef          	jal	4c86 <exit>

00000000000025b0 <sbrk8000>:
    25b0:	1141                	addi	sp,sp,-16
    25b2:	e406                	sd	ra,8(sp)
    25b4:	e022                	sd	s0,0(sp)
    25b6:	0800                	addi	s0,sp,16
    25b8:	80000537          	lui	a0,0x80000
    25bc:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff035c>
    25be:	694020ef          	jal	4c52 <sbrk>
    25c2:	4501                	li	a0,0
    25c4:	68e020ef          	jal	4c52 <sbrk>
    25c8:	fff54783          	lbu	a5,-1(a0)
    25cc:	2785                	addiw	a5,a5,1 # 1001 <badarg+0x1>
    25ce:	0ff7f793          	zext.b	a5,a5
    25d2:	fef50fa3          	sb	a5,-1(a0)
    25d6:	60a2                	ld	ra,8(sp)
    25d8:	6402                	ld	s0,0(sp)
    25da:	0141                	addi	sp,sp,16
    25dc:	8082                	ret

00000000000025de <execout>:
    25de:	715d                	addi	sp,sp,-80
    25e0:	e486                	sd	ra,72(sp)
    25e2:	e0a2                	sd	s0,64(sp)
    25e4:	fc26                	sd	s1,56(sp)
    25e6:	f84a                	sd	s2,48(sp)
    25e8:	f44e                	sd	s3,40(sp)
    25ea:	f052                	sd	s4,32(sp)
    25ec:	0880                	addi	s0,sp,80
    25ee:	4901                	li	s2,0
    25f0:	49bd                	li	s3,15
    25f2:	68c020ef          	jal	4c7e <fork>
    25f6:	84aa                	mv	s1,a0
    25f8:	00054c63          	bltz	a0,2610 <execout+0x32>
    25fc:	c11d                	beqz	a0,2622 <execout+0x44>
    25fe:	4501                	li	a0,0
    2600:	68e020ef          	jal	4c8e <wait>
    2604:	2905                	addiw	s2,s2,1
    2606:	ff3916e3          	bne	s2,s3,25f2 <execout+0x14>
    260a:	4501                	li	a0,0
    260c:	67a020ef          	jal	4c86 <exit>
    2610:	00005517          	auipc	a0,0x5
    2614:	ad050513          	addi	a0,a0,-1328 # 70e0 <malloc+0x1f72>
    2618:	2a3020ef          	jal	50ba <printf>
    261c:	4505                	li	a0,1
    261e:	668020ef          	jal	4c86 <exit>
    2622:	59fd                	li	s3,-1
    2624:	4a05                	li	s4,1
    2626:	6505                	lui	a0,0x1
    2628:	62a020ef          	jal	4c52 <sbrk>
    262c:	01350763          	beq	a0,s3,263a <execout+0x5c>
    2630:	6785                	lui	a5,0x1
    2632:	953e                	add	a0,a0,a5
    2634:	ff450fa3          	sb	s4,-1(a0) # fff <pgbug+0x2b>
    2638:	b7fd                	j	2626 <execout+0x48>
    263a:	01205863          	blez	s2,264a <execout+0x6c>
    263e:	757d                	lui	a0,0xfffff
    2640:	612020ef          	jal	4c52 <sbrk>
    2644:	2485                	addiw	s1,s1,1
    2646:	ff249ce3          	bne	s1,s2,263e <execout+0x60>
    264a:	4505                	li	a0,1
    264c:	662020ef          	jal	4cae <close>
    2650:	00003517          	auipc	a0,0x3
    2654:	c5850513          	addi	a0,a0,-936 # 52a8 <malloc+0x13a>
    2658:	faa43c23          	sd	a0,-72(s0)
    265c:	00003797          	auipc	a5,0x3
    2660:	cbc78793          	addi	a5,a5,-836 # 5318 <malloc+0x1aa>
    2664:	fcf43023          	sd	a5,-64(s0)
    2668:	fc043423          	sd	zero,-56(s0)
    266c:	fb840593          	addi	a1,s0,-72
    2670:	64e020ef          	jal	4cbe <exec>
    2674:	4501                	li	a0,0
    2676:	610020ef          	jal	4c86 <exit>

000000000000267a <fourteen>:
    267a:	1101                	addi	sp,sp,-32
    267c:	ec06                	sd	ra,24(sp)
    267e:	e822                	sd	s0,16(sp)
    2680:	e426                	sd	s1,8(sp)
    2682:	1000                	addi	s0,sp,32
    2684:	84aa                	mv	s1,a0
    2686:	00004517          	auipc	a0,0x4
    268a:	cba50513          	addi	a0,a0,-838 # 6340 <malloc+0x11d2>
    268e:	660020ef          	jal	4cee <mkdir>
    2692:	e555                	bnez	a0,273e <fourteen+0xc4>
    2694:	00004517          	auipc	a0,0x4
    2698:	b0450513          	addi	a0,a0,-1276 # 6198 <malloc+0x102a>
    269c:	652020ef          	jal	4cee <mkdir>
    26a0:	e94d                	bnez	a0,2752 <fourteen+0xd8>
    26a2:	20000593          	li	a1,512
    26a6:	00004517          	auipc	a0,0x4
    26aa:	b4a50513          	addi	a0,a0,-1206 # 61f0 <malloc+0x1082>
    26ae:	618020ef          	jal	4cc6 <open>
    26b2:	0a054a63          	bltz	a0,2766 <fourteen+0xec>
    26b6:	5f8020ef          	jal	4cae <close>
    26ba:	4581                	li	a1,0
    26bc:	00004517          	auipc	a0,0x4
    26c0:	bac50513          	addi	a0,a0,-1108 # 6268 <malloc+0x10fa>
    26c4:	602020ef          	jal	4cc6 <open>
    26c8:	0a054963          	bltz	a0,277a <fourteen+0x100>
    26cc:	5e2020ef          	jal	4cae <close>
    26d0:	00004517          	auipc	a0,0x4
    26d4:	c0850513          	addi	a0,a0,-1016 # 62d8 <malloc+0x116a>
    26d8:	616020ef          	jal	4cee <mkdir>
    26dc:	c94d                	beqz	a0,278e <fourteen+0x114>
    26de:	00004517          	auipc	a0,0x4
    26e2:	c5250513          	addi	a0,a0,-942 # 6330 <malloc+0x11c2>
    26e6:	608020ef          	jal	4cee <mkdir>
    26ea:	cd45                	beqz	a0,27a2 <fourteen+0x128>
    26ec:	00004517          	auipc	a0,0x4
    26f0:	c4450513          	addi	a0,a0,-956 # 6330 <malloc+0x11c2>
    26f4:	5e2020ef          	jal	4cd6 <unlink>
    26f8:	00004517          	auipc	a0,0x4
    26fc:	be050513          	addi	a0,a0,-1056 # 62d8 <malloc+0x116a>
    2700:	5d6020ef          	jal	4cd6 <unlink>
    2704:	00004517          	auipc	a0,0x4
    2708:	b6450513          	addi	a0,a0,-1180 # 6268 <malloc+0x10fa>
    270c:	5ca020ef          	jal	4cd6 <unlink>
    2710:	00004517          	auipc	a0,0x4
    2714:	ae050513          	addi	a0,a0,-1312 # 61f0 <malloc+0x1082>
    2718:	5be020ef          	jal	4cd6 <unlink>
    271c:	00004517          	auipc	a0,0x4
    2720:	a7c50513          	addi	a0,a0,-1412 # 6198 <malloc+0x102a>
    2724:	5b2020ef          	jal	4cd6 <unlink>
    2728:	00004517          	auipc	a0,0x4
    272c:	c1850513          	addi	a0,a0,-1000 # 6340 <malloc+0x11d2>
    2730:	5a6020ef          	jal	4cd6 <unlink>
    2734:	60e2                	ld	ra,24(sp)
    2736:	6442                	ld	s0,16(sp)
    2738:	64a2                	ld	s1,8(sp)
    273a:	6105                	addi	sp,sp,32
    273c:	8082                	ret
    273e:	85a6                	mv	a1,s1
    2740:	00004517          	auipc	a0,0x4
    2744:	a3050513          	addi	a0,a0,-1488 # 6170 <malloc+0x1002>
    2748:	173020ef          	jal	50ba <printf>
    274c:	4505                	li	a0,1
    274e:	538020ef          	jal	4c86 <exit>
    2752:	85a6                	mv	a1,s1
    2754:	00004517          	auipc	a0,0x4
    2758:	a6450513          	addi	a0,a0,-1436 # 61b8 <malloc+0x104a>
    275c:	15f020ef          	jal	50ba <printf>
    2760:	4505                	li	a0,1
    2762:	524020ef          	jal	4c86 <exit>
    2766:	85a6                	mv	a1,s1
    2768:	00004517          	auipc	a0,0x4
    276c:	ab850513          	addi	a0,a0,-1352 # 6220 <malloc+0x10b2>
    2770:	14b020ef          	jal	50ba <printf>
    2774:	4505                	li	a0,1
    2776:	510020ef          	jal	4c86 <exit>
    277a:	85a6                	mv	a1,s1
    277c:	00004517          	auipc	a0,0x4
    2780:	b1c50513          	addi	a0,a0,-1252 # 6298 <malloc+0x112a>
    2784:	137020ef          	jal	50ba <printf>
    2788:	4505                	li	a0,1
    278a:	4fc020ef          	jal	4c86 <exit>
    278e:	85a6                	mv	a1,s1
    2790:	00004517          	auipc	a0,0x4
    2794:	b6850513          	addi	a0,a0,-1176 # 62f8 <malloc+0x118a>
    2798:	123020ef          	jal	50ba <printf>
    279c:	4505                	li	a0,1
    279e:	4e8020ef          	jal	4c86 <exit>
    27a2:	85a6                	mv	a1,s1
    27a4:	00004517          	auipc	a0,0x4
    27a8:	bac50513          	addi	a0,a0,-1108 # 6350 <malloc+0x11e2>
    27ac:	10f020ef          	jal	50ba <printf>
    27b0:	4505                	li	a0,1
    27b2:	4d4020ef          	jal	4c86 <exit>

00000000000027b6 <diskfull>:
    27b6:	b8010113          	addi	sp,sp,-1152
    27ba:	46113c23          	sd	ra,1144(sp)
    27be:	46813823          	sd	s0,1136(sp)
    27c2:	46913423          	sd	s1,1128(sp)
    27c6:	47213023          	sd	s2,1120(sp)
    27ca:	45313c23          	sd	s3,1112(sp)
    27ce:	45413823          	sd	s4,1104(sp)
    27d2:	45513423          	sd	s5,1096(sp)
    27d6:	45613023          	sd	s6,1088(sp)
    27da:	43713c23          	sd	s7,1080(sp)
    27de:	43813823          	sd	s8,1072(sp)
    27e2:	43913423          	sd	s9,1064(sp)
    27e6:	48010413          	addi	s0,sp,1152
    27ea:	8caa                	mv	s9,a0
    27ec:	00004517          	auipc	a0,0x4
    27f0:	b9c50513          	addi	a0,a0,-1124 # 6388 <malloc+0x121a>
    27f4:	4e2020ef          	jal	4cd6 <unlink>
    27f8:	03000993          	li	s3,48
    27fc:	06200b13          	li	s6,98
    2800:	06900a93          	li	s5,105
    2804:	06700a13          	li	s4,103
    2808:	10c00b93          	li	s7,268
    280c:	07f00c13          	li	s8,127
    2810:	aab9                	j	296e <diskfull+0x1b8>
    2812:	b8040613          	addi	a2,s0,-1152
    2816:	85e6                	mv	a1,s9
    2818:	00004517          	auipc	a0,0x4
    281c:	b8050513          	addi	a0,a0,-1152 # 6398 <malloc+0x122a>
    2820:	09b020ef          	jal	50ba <printf>
    2824:	a039                	j	2832 <diskfull+0x7c>
    2826:	854a                	mv	a0,s2
    2828:	486020ef          	jal	4cae <close>
    282c:	854a                	mv	a0,s2
    282e:	480020ef          	jal	4cae <close>
    2832:	4481                	li	s1,0
    2834:	07a00913          	li	s2,122
    2838:	08000993          	li	s3,128
    283c:	bb240023          	sb	s2,-1120(s0)
    2840:	bb2400a3          	sb	s2,-1119(s0)
    2844:	41f4d71b          	sraiw	a4,s1,0x1f
    2848:	01b7571b          	srliw	a4,a4,0x1b
    284c:	009707bb          	addw	a5,a4,s1
    2850:	4057d69b          	sraiw	a3,a5,0x5
    2854:	0306869b          	addiw	a3,a3,48
    2858:	bad40123          	sb	a3,-1118(s0)
    285c:	8bfd                	andi	a5,a5,31
    285e:	9f99                	subw	a5,a5,a4
    2860:	0307879b          	addiw	a5,a5,48
    2864:	baf401a3          	sb	a5,-1117(s0)
    2868:	ba040223          	sb	zero,-1116(s0)
    286c:	ba040513          	addi	a0,s0,-1120
    2870:	466020ef          	jal	4cd6 <unlink>
    2874:	60200593          	li	a1,1538
    2878:	ba040513          	addi	a0,s0,-1120
    287c:	44a020ef          	jal	4cc6 <open>
    2880:	00054763          	bltz	a0,288e <diskfull+0xd8>
    2884:	42a020ef          	jal	4cae <close>
    2888:	2485                	addiw	s1,s1,1
    288a:	fb3499e3          	bne	s1,s3,283c <diskfull+0x86>
    288e:	00004517          	auipc	a0,0x4
    2892:	afa50513          	addi	a0,a0,-1286 # 6388 <malloc+0x121a>
    2896:	458020ef          	jal	4cee <mkdir>
    289a:	12050063          	beqz	a0,29ba <diskfull+0x204>
    289e:	00004517          	auipc	a0,0x4
    28a2:	aea50513          	addi	a0,a0,-1302 # 6388 <malloc+0x121a>
    28a6:	430020ef          	jal	4cd6 <unlink>
    28aa:	4481                	li	s1,0
    28ac:	07a00913          	li	s2,122
    28b0:	08000993          	li	s3,128
    28b4:	bb240023          	sb	s2,-1120(s0)
    28b8:	bb2400a3          	sb	s2,-1119(s0)
    28bc:	41f4d71b          	sraiw	a4,s1,0x1f
    28c0:	01b7571b          	srliw	a4,a4,0x1b
    28c4:	009707bb          	addw	a5,a4,s1
    28c8:	4057d69b          	sraiw	a3,a5,0x5
    28cc:	0306869b          	addiw	a3,a3,48
    28d0:	bad40123          	sb	a3,-1118(s0)
    28d4:	8bfd                	andi	a5,a5,31
    28d6:	9f99                	subw	a5,a5,a4
    28d8:	0307879b          	addiw	a5,a5,48
    28dc:	baf401a3          	sb	a5,-1117(s0)
    28e0:	ba040223          	sb	zero,-1116(s0)
    28e4:	ba040513          	addi	a0,s0,-1120
    28e8:	3ee020ef          	jal	4cd6 <unlink>
    28ec:	2485                	addiw	s1,s1,1
    28ee:	fd3493e3          	bne	s1,s3,28b4 <diskfull+0xfe>
    28f2:	03000493          	li	s1,48
    28f6:	06200a93          	li	s5,98
    28fa:	06900a13          	li	s4,105
    28fe:	06700993          	li	s3,103
    2902:	07f00913          	li	s2,127
    2906:	bb540023          	sb	s5,-1120(s0)
    290a:	bb4400a3          	sb	s4,-1119(s0)
    290e:	bb340123          	sb	s3,-1118(s0)
    2912:	ba9401a3          	sb	s1,-1117(s0)
    2916:	ba040223          	sb	zero,-1116(s0)
    291a:	ba040513          	addi	a0,s0,-1120
    291e:	3b8020ef          	jal	4cd6 <unlink>
    2922:	2485                	addiw	s1,s1,1
    2924:	0ff4f493          	zext.b	s1,s1
    2928:	fd249fe3          	bne	s1,s2,2906 <diskfull+0x150>
    292c:	47813083          	ld	ra,1144(sp)
    2930:	47013403          	ld	s0,1136(sp)
    2934:	46813483          	ld	s1,1128(sp)
    2938:	46013903          	ld	s2,1120(sp)
    293c:	45813983          	ld	s3,1112(sp)
    2940:	45013a03          	ld	s4,1104(sp)
    2944:	44813a83          	ld	s5,1096(sp)
    2948:	44013b03          	ld	s6,1088(sp)
    294c:	43813b83          	ld	s7,1080(sp)
    2950:	43013c03          	ld	s8,1072(sp)
    2954:	42813c83          	ld	s9,1064(sp)
    2958:	48010113          	addi	sp,sp,1152
    295c:	8082                	ret
    295e:	854a                	mv	a0,s2
    2960:	34e020ef          	jal	4cae <close>
    2964:	2985                	addiw	s3,s3,1
    2966:	0ff9f993          	zext.b	s3,s3
    296a:	ed8984e3          	beq	s3,s8,2832 <diskfull+0x7c>
    296e:	b9640023          	sb	s6,-1152(s0)
    2972:	b95400a3          	sb	s5,-1151(s0)
    2976:	b9440123          	sb	s4,-1150(s0)
    297a:	b93401a3          	sb	s3,-1149(s0)
    297e:	b8040223          	sb	zero,-1148(s0)
    2982:	b8040513          	addi	a0,s0,-1152
    2986:	350020ef          	jal	4cd6 <unlink>
    298a:	60200593          	li	a1,1538
    298e:	b8040513          	addi	a0,s0,-1152
    2992:	334020ef          	jal	4cc6 <open>
    2996:	892a                	mv	s2,a0
    2998:	e6054de3          	bltz	a0,2812 <diskfull+0x5c>
    299c:	84de                	mv	s1,s7
    299e:	40000613          	li	a2,1024
    29a2:	ba040593          	addi	a1,s0,-1120
    29a6:	854a                	mv	a0,s2
    29a8:	2fe020ef          	jal	4ca6 <write>
    29ac:	40000793          	li	a5,1024
    29b0:	e6f51be3          	bne	a0,a5,2826 <diskfull+0x70>
    29b4:	34fd                	addiw	s1,s1,-1
    29b6:	f4e5                	bnez	s1,299e <diskfull+0x1e8>
    29b8:	b75d                	j	295e <diskfull+0x1a8>
    29ba:	85e6                	mv	a1,s9
    29bc:	00004517          	auipc	a0,0x4
    29c0:	9fc50513          	addi	a0,a0,-1540 # 63b8 <malloc+0x124a>
    29c4:	6f6020ef          	jal	50ba <printf>
    29c8:	bdd9                	j	289e <diskfull+0xe8>

00000000000029ca <iputtest>:
    29ca:	1101                	addi	sp,sp,-32
    29cc:	ec06                	sd	ra,24(sp)
    29ce:	e822                	sd	s0,16(sp)
    29d0:	e426                	sd	s1,8(sp)
    29d2:	1000                	addi	s0,sp,32
    29d4:	84aa                	mv	s1,a0
    29d6:	00004517          	auipc	a0,0x4
    29da:	a1250513          	addi	a0,a0,-1518 # 63e8 <malloc+0x127a>
    29de:	310020ef          	jal	4cee <mkdir>
    29e2:	02054f63          	bltz	a0,2a20 <iputtest+0x56>
    29e6:	00004517          	auipc	a0,0x4
    29ea:	a0250513          	addi	a0,a0,-1534 # 63e8 <malloc+0x127a>
    29ee:	308020ef          	jal	4cf6 <chdir>
    29f2:	04054163          	bltz	a0,2a34 <iputtest+0x6a>
    29f6:	00004517          	auipc	a0,0x4
    29fa:	a3250513          	addi	a0,a0,-1486 # 6428 <malloc+0x12ba>
    29fe:	2d8020ef          	jal	4cd6 <unlink>
    2a02:	04054363          	bltz	a0,2a48 <iputtest+0x7e>
    2a06:	00004517          	auipc	a0,0x4
    2a0a:	a5250513          	addi	a0,a0,-1454 # 6458 <malloc+0x12ea>
    2a0e:	2e8020ef          	jal	4cf6 <chdir>
    2a12:	04054563          	bltz	a0,2a5c <iputtest+0x92>
    2a16:	60e2                	ld	ra,24(sp)
    2a18:	6442                	ld	s0,16(sp)
    2a1a:	64a2                	ld	s1,8(sp)
    2a1c:	6105                	addi	sp,sp,32
    2a1e:	8082                	ret
    2a20:	85a6                	mv	a1,s1
    2a22:	00004517          	auipc	a0,0x4
    2a26:	9ce50513          	addi	a0,a0,-1586 # 63f0 <malloc+0x1282>
    2a2a:	690020ef          	jal	50ba <printf>
    2a2e:	4505                	li	a0,1
    2a30:	256020ef          	jal	4c86 <exit>
    2a34:	85a6                	mv	a1,s1
    2a36:	00004517          	auipc	a0,0x4
    2a3a:	9d250513          	addi	a0,a0,-1582 # 6408 <malloc+0x129a>
    2a3e:	67c020ef          	jal	50ba <printf>
    2a42:	4505                	li	a0,1
    2a44:	242020ef          	jal	4c86 <exit>
    2a48:	85a6                	mv	a1,s1
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	9ee50513          	addi	a0,a0,-1554 # 6438 <malloc+0x12ca>
    2a52:	668020ef          	jal	50ba <printf>
    2a56:	4505                	li	a0,1
    2a58:	22e020ef          	jal	4c86 <exit>
    2a5c:	85a6                	mv	a1,s1
    2a5e:	00004517          	auipc	a0,0x4
    2a62:	a0250513          	addi	a0,a0,-1534 # 6460 <malloc+0x12f2>
    2a66:	654020ef          	jal	50ba <printf>
    2a6a:	4505                	li	a0,1
    2a6c:	21a020ef          	jal	4c86 <exit>

0000000000002a70 <exitiputtest>:
    2a70:	7179                	addi	sp,sp,-48
    2a72:	f406                	sd	ra,40(sp)
    2a74:	f022                	sd	s0,32(sp)
    2a76:	ec26                	sd	s1,24(sp)
    2a78:	1800                	addi	s0,sp,48
    2a7a:	84aa                	mv	s1,a0
    2a7c:	202020ef          	jal	4c7e <fork>
    2a80:	02054e63          	bltz	a0,2abc <exitiputtest+0x4c>
    2a84:	e541                	bnez	a0,2b0c <exitiputtest+0x9c>
    2a86:	00004517          	auipc	a0,0x4
    2a8a:	96250513          	addi	a0,a0,-1694 # 63e8 <malloc+0x127a>
    2a8e:	260020ef          	jal	4cee <mkdir>
    2a92:	02054f63          	bltz	a0,2ad0 <exitiputtest+0x60>
    2a96:	00004517          	auipc	a0,0x4
    2a9a:	95250513          	addi	a0,a0,-1710 # 63e8 <malloc+0x127a>
    2a9e:	258020ef          	jal	4cf6 <chdir>
    2aa2:	04054163          	bltz	a0,2ae4 <exitiputtest+0x74>
    2aa6:	00004517          	auipc	a0,0x4
    2aaa:	98250513          	addi	a0,a0,-1662 # 6428 <malloc+0x12ba>
    2aae:	228020ef          	jal	4cd6 <unlink>
    2ab2:	04054363          	bltz	a0,2af8 <exitiputtest+0x88>
    2ab6:	4501                	li	a0,0
    2ab8:	1ce020ef          	jal	4c86 <exit>
    2abc:	85a6                	mv	a1,s1
    2abe:	00003517          	auipc	a0,0x3
    2ac2:	07a50513          	addi	a0,a0,122 # 5b38 <malloc+0x9ca>
    2ac6:	5f4020ef          	jal	50ba <printf>
    2aca:	4505                	li	a0,1
    2acc:	1ba020ef          	jal	4c86 <exit>
    2ad0:	85a6                	mv	a1,s1
    2ad2:	00004517          	auipc	a0,0x4
    2ad6:	91e50513          	addi	a0,a0,-1762 # 63f0 <malloc+0x1282>
    2ada:	5e0020ef          	jal	50ba <printf>
    2ade:	4505                	li	a0,1
    2ae0:	1a6020ef          	jal	4c86 <exit>
    2ae4:	85a6                	mv	a1,s1
    2ae6:	00004517          	auipc	a0,0x4
    2aea:	99250513          	addi	a0,a0,-1646 # 6478 <malloc+0x130a>
    2aee:	5cc020ef          	jal	50ba <printf>
    2af2:	4505                	li	a0,1
    2af4:	192020ef          	jal	4c86 <exit>
    2af8:	85a6                	mv	a1,s1
    2afa:	00004517          	auipc	a0,0x4
    2afe:	93e50513          	addi	a0,a0,-1730 # 6438 <malloc+0x12ca>
    2b02:	5b8020ef          	jal	50ba <printf>
    2b06:	4505                	li	a0,1
    2b08:	17e020ef          	jal	4c86 <exit>
    2b0c:	fdc40513          	addi	a0,s0,-36
    2b10:	17e020ef          	jal	4c8e <wait>
    2b14:	fdc42503          	lw	a0,-36(s0)
    2b18:	16e020ef          	jal	4c86 <exit>

0000000000002b1c <dirtest>:
    2b1c:	1101                	addi	sp,sp,-32
    2b1e:	ec06                	sd	ra,24(sp)
    2b20:	e822                	sd	s0,16(sp)
    2b22:	e426                	sd	s1,8(sp)
    2b24:	1000                	addi	s0,sp,32
    2b26:	84aa                	mv	s1,a0
    2b28:	00004517          	auipc	a0,0x4
    2b2c:	96850513          	addi	a0,a0,-1688 # 6490 <malloc+0x1322>
    2b30:	1be020ef          	jal	4cee <mkdir>
    2b34:	02054f63          	bltz	a0,2b72 <dirtest+0x56>
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	95850513          	addi	a0,a0,-1704 # 6490 <malloc+0x1322>
    2b40:	1b6020ef          	jal	4cf6 <chdir>
    2b44:	04054163          	bltz	a0,2b86 <dirtest+0x6a>
    2b48:	00004517          	auipc	a0,0x4
    2b4c:	96850513          	addi	a0,a0,-1688 # 64b0 <malloc+0x1342>
    2b50:	1a6020ef          	jal	4cf6 <chdir>
    2b54:	04054363          	bltz	a0,2b9a <dirtest+0x7e>
    2b58:	00004517          	auipc	a0,0x4
    2b5c:	93850513          	addi	a0,a0,-1736 # 6490 <malloc+0x1322>
    2b60:	176020ef          	jal	4cd6 <unlink>
    2b64:	04054563          	bltz	a0,2bae <dirtest+0x92>
    2b68:	60e2                	ld	ra,24(sp)
    2b6a:	6442                	ld	s0,16(sp)
    2b6c:	64a2                	ld	s1,8(sp)
    2b6e:	6105                	addi	sp,sp,32
    2b70:	8082                	ret
    2b72:	85a6                	mv	a1,s1
    2b74:	00004517          	auipc	a0,0x4
    2b78:	87c50513          	addi	a0,a0,-1924 # 63f0 <malloc+0x1282>
    2b7c:	53e020ef          	jal	50ba <printf>
    2b80:	4505                	li	a0,1
    2b82:	104020ef          	jal	4c86 <exit>
    2b86:	85a6                	mv	a1,s1
    2b88:	00004517          	auipc	a0,0x4
    2b8c:	91050513          	addi	a0,a0,-1776 # 6498 <malloc+0x132a>
    2b90:	52a020ef          	jal	50ba <printf>
    2b94:	4505                	li	a0,1
    2b96:	0f0020ef          	jal	4c86 <exit>
    2b9a:	85a6                	mv	a1,s1
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	91c50513          	addi	a0,a0,-1764 # 64b8 <malloc+0x134a>
    2ba4:	516020ef          	jal	50ba <printf>
    2ba8:	4505                	li	a0,1
    2baa:	0dc020ef          	jal	4c86 <exit>
    2bae:	85a6                	mv	a1,s1
    2bb0:	00004517          	auipc	a0,0x4
    2bb4:	92050513          	addi	a0,a0,-1760 # 64d0 <malloc+0x1362>
    2bb8:	502020ef          	jal	50ba <printf>
    2bbc:	4505                	li	a0,1
    2bbe:	0c8020ef          	jal	4c86 <exit>

0000000000002bc2 <subdir>:
    2bc2:	1101                	addi	sp,sp,-32
    2bc4:	ec06                	sd	ra,24(sp)
    2bc6:	e822                	sd	s0,16(sp)
    2bc8:	e426                	sd	s1,8(sp)
    2bca:	e04a                	sd	s2,0(sp)
    2bcc:	1000                	addi	s0,sp,32
    2bce:	892a                	mv	s2,a0
    2bd0:	00004517          	auipc	a0,0x4
    2bd4:	a4850513          	addi	a0,a0,-1464 # 6618 <malloc+0x14aa>
    2bd8:	0fe020ef          	jal	4cd6 <unlink>
    2bdc:	00004517          	auipc	a0,0x4
    2be0:	90c50513          	addi	a0,a0,-1780 # 64e8 <malloc+0x137a>
    2be4:	10a020ef          	jal	4cee <mkdir>
    2be8:	2e051263          	bnez	a0,2ecc <subdir+0x30a>
    2bec:	20200593          	li	a1,514
    2bf0:	00004517          	auipc	a0,0x4
    2bf4:	91850513          	addi	a0,a0,-1768 # 6508 <malloc+0x139a>
    2bf8:	0ce020ef          	jal	4cc6 <open>
    2bfc:	84aa                	mv	s1,a0
    2bfe:	2e054163          	bltz	a0,2ee0 <subdir+0x31e>
    2c02:	4609                	li	a2,2
    2c04:	00004597          	auipc	a1,0x4
    2c08:	a1458593          	addi	a1,a1,-1516 # 6618 <malloc+0x14aa>
    2c0c:	09a020ef          	jal	4ca6 <write>
    2c10:	8526                	mv	a0,s1
    2c12:	09c020ef          	jal	4cae <close>
    2c16:	00004517          	auipc	a0,0x4
    2c1a:	8d250513          	addi	a0,a0,-1838 # 64e8 <malloc+0x137a>
    2c1e:	0b8020ef          	jal	4cd6 <unlink>
    2c22:	2c055963          	bgez	a0,2ef4 <subdir+0x332>
    2c26:	00004517          	auipc	a0,0x4
    2c2a:	93a50513          	addi	a0,a0,-1734 # 6560 <malloc+0x13f2>
    2c2e:	0c0020ef          	jal	4cee <mkdir>
    2c32:	2c051b63          	bnez	a0,2f08 <subdir+0x346>
    2c36:	20200593          	li	a1,514
    2c3a:	00004517          	auipc	a0,0x4
    2c3e:	94e50513          	addi	a0,a0,-1714 # 6588 <malloc+0x141a>
    2c42:	084020ef          	jal	4cc6 <open>
    2c46:	84aa                	mv	s1,a0
    2c48:	2c054a63          	bltz	a0,2f1c <subdir+0x35a>
    2c4c:	4609                	li	a2,2
    2c4e:	00004597          	auipc	a1,0x4
    2c52:	96a58593          	addi	a1,a1,-1686 # 65b8 <malloc+0x144a>
    2c56:	050020ef          	jal	4ca6 <write>
    2c5a:	8526                	mv	a0,s1
    2c5c:	052020ef          	jal	4cae <close>
    2c60:	4581                	li	a1,0
    2c62:	00004517          	auipc	a0,0x4
    2c66:	95e50513          	addi	a0,a0,-1698 # 65c0 <malloc+0x1452>
    2c6a:	05c020ef          	jal	4cc6 <open>
    2c6e:	84aa                	mv	s1,a0
    2c70:	2c054063          	bltz	a0,2f30 <subdir+0x36e>
    2c74:	660d                	lui	a2,0x3
    2c76:	0000a597          	auipc	a1,0xa
    2c7a:	03258593          	addi	a1,a1,50 # cca8 <buf>
    2c7e:	020020ef          	jal	4c9e <read>
    2c82:	4789                	li	a5,2
    2c84:	2cf51063          	bne	a0,a5,2f44 <subdir+0x382>
    2c88:	0000a717          	auipc	a4,0xa
    2c8c:	02074703          	lbu	a4,32(a4) # cca8 <buf>
    2c90:	06600793          	li	a5,102
    2c94:	2af71863          	bne	a4,a5,2f44 <subdir+0x382>
    2c98:	8526                	mv	a0,s1
    2c9a:	014020ef          	jal	4cae <close>
    2c9e:	00004597          	auipc	a1,0x4
    2ca2:	97258593          	addi	a1,a1,-1678 # 6610 <malloc+0x14a2>
    2ca6:	00004517          	auipc	a0,0x4
    2caa:	8e250513          	addi	a0,a0,-1822 # 6588 <malloc+0x141a>
    2cae:	038020ef          	jal	4ce6 <link>
    2cb2:	2a051363          	bnez	a0,2f58 <subdir+0x396>
    2cb6:	00004517          	auipc	a0,0x4
    2cba:	8d250513          	addi	a0,a0,-1838 # 6588 <malloc+0x141a>
    2cbe:	018020ef          	jal	4cd6 <unlink>
    2cc2:	2a051563          	bnez	a0,2f6c <subdir+0x3aa>
    2cc6:	4581                	li	a1,0
    2cc8:	00004517          	auipc	a0,0x4
    2ccc:	8c050513          	addi	a0,a0,-1856 # 6588 <malloc+0x141a>
    2cd0:	7f7010ef          	jal	4cc6 <open>
    2cd4:	2a055663          	bgez	a0,2f80 <subdir+0x3be>
    2cd8:	00004517          	auipc	a0,0x4
    2cdc:	81050513          	addi	a0,a0,-2032 # 64e8 <malloc+0x137a>
    2ce0:	016020ef          	jal	4cf6 <chdir>
    2ce4:	2a051863          	bnez	a0,2f94 <subdir+0x3d2>
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	9c050513          	addi	a0,a0,-1600 # 66a8 <malloc+0x153a>
    2cf0:	006020ef          	jal	4cf6 <chdir>
    2cf4:	2a051a63          	bnez	a0,2fa8 <subdir+0x3e6>
    2cf8:	00004517          	auipc	a0,0x4
    2cfc:	9e050513          	addi	a0,a0,-1568 # 66d8 <malloc+0x156a>
    2d00:	7f7010ef          	jal	4cf6 <chdir>
    2d04:	2a051c63          	bnez	a0,2fbc <subdir+0x3fa>
    2d08:	00004517          	auipc	a0,0x4
    2d0c:	a0850513          	addi	a0,a0,-1528 # 6710 <malloc+0x15a2>
    2d10:	7e7010ef          	jal	4cf6 <chdir>
    2d14:	2a051e63          	bnez	a0,2fd0 <subdir+0x40e>
    2d18:	4581                	li	a1,0
    2d1a:	00004517          	auipc	a0,0x4
    2d1e:	8f650513          	addi	a0,a0,-1802 # 6610 <malloc+0x14a2>
    2d22:	7a5010ef          	jal	4cc6 <open>
    2d26:	84aa                	mv	s1,a0
    2d28:	2a054e63          	bltz	a0,2fe4 <subdir+0x422>
    2d2c:	660d                	lui	a2,0x3
    2d2e:	0000a597          	auipc	a1,0xa
    2d32:	f7a58593          	addi	a1,a1,-134 # cca8 <buf>
    2d36:	769010ef          	jal	4c9e <read>
    2d3a:	4789                	li	a5,2
    2d3c:	2af51e63          	bne	a0,a5,2ff8 <subdir+0x436>
    2d40:	8526                	mv	a0,s1
    2d42:	76d010ef          	jal	4cae <close>
    2d46:	4581                	li	a1,0
    2d48:	00004517          	auipc	a0,0x4
    2d4c:	84050513          	addi	a0,a0,-1984 # 6588 <malloc+0x141a>
    2d50:	777010ef          	jal	4cc6 <open>
    2d54:	2a055c63          	bgez	a0,300c <subdir+0x44a>
    2d58:	20200593          	li	a1,514
    2d5c:	00004517          	auipc	a0,0x4
    2d60:	a4450513          	addi	a0,a0,-1468 # 67a0 <malloc+0x1632>
    2d64:	763010ef          	jal	4cc6 <open>
    2d68:	2a055c63          	bgez	a0,3020 <subdir+0x45e>
    2d6c:	20200593          	li	a1,514
    2d70:	00004517          	auipc	a0,0x4
    2d74:	a6050513          	addi	a0,a0,-1440 # 67d0 <malloc+0x1662>
    2d78:	74f010ef          	jal	4cc6 <open>
    2d7c:	2a055c63          	bgez	a0,3034 <subdir+0x472>
    2d80:	20000593          	li	a1,512
    2d84:	00003517          	auipc	a0,0x3
    2d88:	76450513          	addi	a0,a0,1892 # 64e8 <malloc+0x137a>
    2d8c:	73b010ef          	jal	4cc6 <open>
    2d90:	2a055c63          	bgez	a0,3048 <subdir+0x486>
    2d94:	4589                	li	a1,2
    2d96:	00003517          	auipc	a0,0x3
    2d9a:	75250513          	addi	a0,a0,1874 # 64e8 <malloc+0x137a>
    2d9e:	729010ef          	jal	4cc6 <open>
    2da2:	2a055d63          	bgez	a0,305c <subdir+0x49a>
    2da6:	4585                	li	a1,1
    2da8:	00003517          	auipc	a0,0x3
    2dac:	74050513          	addi	a0,a0,1856 # 64e8 <malloc+0x137a>
    2db0:	717010ef          	jal	4cc6 <open>
    2db4:	2a055e63          	bgez	a0,3070 <subdir+0x4ae>
    2db8:	00004597          	auipc	a1,0x4
    2dbc:	aa858593          	addi	a1,a1,-1368 # 6860 <malloc+0x16f2>
    2dc0:	00004517          	auipc	a0,0x4
    2dc4:	9e050513          	addi	a0,a0,-1568 # 67a0 <malloc+0x1632>
    2dc8:	71f010ef          	jal	4ce6 <link>
    2dcc:	2a050c63          	beqz	a0,3084 <subdir+0x4c2>
    2dd0:	00004597          	auipc	a1,0x4
    2dd4:	a9058593          	addi	a1,a1,-1392 # 6860 <malloc+0x16f2>
    2dd8:	00004517          	auipc	a0,0x4
    2ddc:	9f850513          	addi	a0,a0,-1544 # 67d0 <malloc+0x1662>
    2de0:	707010ef          	jal	4ce6 <link>
    2de4:	2a050a63          	beqz	a0,3098 <subdir+0x4d6>
    2de8:	00004597          	auipc	a1,0x4
    2dec:	82858593          	addi	a1,a1,-2008 # 6610 <malloc+0x14a2>
    2df0:	00003517          	auipc	a0,0x3
    2df4:	71850513          	addi	a0,a0,1816 # 6508 <malloc+0x139a>
    2df8:	6ef010ef          	jal	4ce6 <link>
    2dfc:	2a050863          	beqz	a0,30ac <subdir+0x4ea>
    2e00:	00004517          	auipc	a0,0x4
    2e04:	9a050513          	addi	a0,a0,-1632 # 67a0 <malloc+0x1632>
    2e08:	6e7010ef          	jal	4cee <mkdir>
    2e0c:	2a050a63          	beqz	a0,30c0 <subdir+0x4fe>
    2e10:	00004517          	auipc	a0,0x4
    2e14:	9c050513          	addi	a0,a0,-1600 # 67d0 <malloc+0x1662>
    2e18:	6d7010ef          	jal	4cee <mkdir>
    2e1c:	2a050c63          	beqz	a0,30d4 <subdir+0x512>
    2e20:	00003517          	auipc	a0,0x3
    2e24:	7f050513          	addi	a0,a0,2032 # 6610 <malloc+0x14a2>
    2e28:	6c7010ef          	jal	4cee <mkdir>
    2e2c:	2a050e63          	beqz	a0,30e8 <subdir+0x526>
    2e30:	00004517          	auipc	a0,0x4
    2e34:	9a050513          	addi	a0,a0,-1632 # 67d0 <malloc+0x1662>
    2e38:	69f010ef          	jal	4cd6 <unlink>
    2e3c:	2c050063          	beqz	a0,30fc <subdir+0x53a>
    2e40:	00004517          	auipc	a0,0x4
    2e44:	96050513          	addi	a0,a0,-1696 # 67a0 <malloc+0x1632>
    2e48:	68f010ef          	jal	4cd6 <unlink>
    2e4c:	2c050263          	beqz	a0,3110 <subdir+0x54e>
    2e50:	00003517          	auipc	a0,0x3
    2e54:	6b850513          	addi	a0,a0,1720 # 6508 <malloc+0x139a>
    2e58:	69f010ef          	jal	4cf6 <chdir>
    2e5c:	2c050463          	beqz	a0,3124 <subdir+0x562>
    2e60:	00004517          	auipc	a0,0x4
    2e64:	b5050513          	addi	a0,a0,-1200 # 69b0 <malloc+0x1842>
    2e68:	68f010ef          	jal	4cf6 <chdir>
    2e6c:	2c050663          	beqz	a0,3138 <subdir+0x576>
    2e70:	00003517          	auipc	a0,0x3
    2e74:	7a050513          	addi	a0,a0,1952 # 6610 <malloc+0x14a2>
    2e78:	65f010ef          	jal	4cd6 <unlink>
    2e7c:	2c051863          	bnez	a0,314c <subdir+0x58a>
    2e80:	00003517          	auipc	a0,0x3
    2e84:	68850513          	addi	a0,a0,1672 # 6508 <malloc+0x139a>
    2e88:	64f010ef          	jal	4cd6 <unlink>
    2e8c:	2c051a63          	bnez	a0,3160 <subdir+0x59e>
    2e90:	00003517          	auipc	a0,0x3
    2e94:	65850513          	addi	a0,a0,1624 # 64e8 <malloc+0x137a>
    2e98:	63f010ef          	jal	4cd6 <unlink>
    2e9c:	2c050c63          	beqz	a0,3174 <subdir+0x5b2>
    2ea0:	00004517          	auipc	a0,0x4
    2ea4:	b8050513          	addi	a0,a0,-1152 # 6a20 <malloc+0x18b2>
    2ea8:	62f010ef          	jal	4cd6 <unlink>
    2eac:	2c054e63          	bltz	a0,3188 <subdir+0x5c6>
    2eb0:	00003517          	auipc	a0,0x3
    2eb4:	63850513          	addi	a0,a0,1592 # 64e8 <malloc+0x137a>
    2eb8:	61f010ef          	jal	4cd6 <unlink>
    2ebc:	2e054063          	bltz	a0,319c <subdir+0x5da>
    2ec0:	60e2                	ld	ra,24(sp)
    2ec2:	6442                	ld	s0,16(sp)
    2ec4:	64a2                	ld	s1,8(sp)
    2ec6:	6902                	ld	s2,0(sp)
    2ec8:	6105                	addi	sp,sp,32
    2eca:	8082                	ret
    2ecc:	85ca                	mv	a1,s2
    2ece:	00003517          	auipc	a0,0x3
    2ed2:	62250513          	addi	a0,a0,1570 # 64f0 <malloc+0x1382>
    2ed6:	1e4020ef          	jal	50ba <printf>
    2eda:	4505                	li	a0,1
    2edc:	5ab010ef          	jal	4c86 <exit>
    2ee0:	85ca                	mv	a1,s2
    2ee2:	00003517          	auipc	a0,0x3
    2ee6:	62e50513          	addi	a0,a0,1582 # 6510 <malloc+0x13a2>
    2eea:	1d0020ef          	jal	50ba <printf>
    2eee:	4505                	li	a0,1
    2ef0:	597010ef          	jal	4c86 <exit>
    2ef4:	85ca                	mv	a1,s2
    2ef6:	00003517          	auipc	a0,0x3
    2efa:	63a50513          	addi	a0,a0,1594 # 6530 <malloc+0x13c2>
    2efe:	1bc020ef          	jal	50ba <printf>
    2f02:	4505                	li	a0,1
    2f04:	583010ef          	jal	4c86 <exit>
    2f08:	85ca                	mv	a1,s2
    2f0a:	00003517          	auipc	a0,0x3
    2f0e:	65e50513          	addi	a0,a0,1630 # 6568 <malloc+0x13fa>
    2f12:	1a8020ef          	jal	50ba <printf>
    2f16:	4505                	li	a0,1
    2f18:	56f010ef          	jal	4c86 <exit>
    2f1c:	85ca                	mv	a1,s2
    2f1e:	00003517          	auipc	a0,0x3
    2f22:	67a50513          	addi	a0,a0,1658 # 6598 <malloc+0x142a>
    2f26:	194020ef          	jal	50ba <printf>
    2f2a:	4505                	li	a0,1
    2f2c:	55b010ef          	jal	4c86 <exit>
    2f30:	85ca                	mv	a1,s2
    2f32:	00003517          	auipc	a0,0x3
    2f36:	69e50513          	addi	a0,a0,1694 # 65d0 <malloc+0x1462>
    2f3a:	180020ef          	jal	50ba <printf>
    2f3e:	4505                	li	a0,1
    2f40:	547010ef          	jal	4c86 <exit>
    2f44:	85ca                	mv	a1,s2
    2f46:	00003517          	auipc	a0,0x3
    2f4a:	6aa50513          	addi	a0,a0,1706 # 65f0 <malloc+0x1482>
    2f4e:	16c020ef          	jal	50ba <printf>
    2f52:	4505                	li	a0,1
    2f54:	533010ef          	jal	4c86 <exit>
    2f58:	85ca                	mv	a1,s2
    2f5a:	00003517          	auipc	a0,0x3
    2f5e:	6c650513          	addi	a0,a0,1734 # 6620 <malloc+0x14b2>
    2f62:	158020ef          	jal	50ba <printf>
    2f66:	4505                	li	a0,1
    2f68:	51f010ef          	jal	4c86 <exit>
    2f6c:	85ca                	mv	a1,s2
    2f6e:	00003517          	auipc	a0,0x3
    2f72:	6da50513          	addi	a0,a0,1754 # 6648 <malloc+0x14da>
    2f76:	144020ef          	jal	50ba <printf>
    2f7a:	4505                	li	a0,1
    2f7c:	50b010ef          	jal	4c86 <exit>
    2f80:	85ca                	mv	a1,s2
    2f82:	00003517          	auipc	a0,0x3
    2f86:	6e650513          	addi	a0,a0,1766 # 6668 <malloc+0x14fa>
    2f8a:	130020ef          	jal	50ba <printf>
    2f8e:	4505                	li	a0,1
    2f90:	4f7010ef          	jal	4c86 <exit>
    2f94:	85ca                	mv	a1,s2
    2f96:	00003517          	auipc	a0,0x3
    2f9a:	6fa50513          	addi	a0,a0,1786 # 6690 <malloc+0x1522>
    2f9e:	11c020ef          	jal	50ba <printf>
    2fa2:	4505                	li	a0,1
    2fa4:	4e3010ef          	jal	4c86 <exit>
    2fa8:	85ca                	mv	a1,s2
    2faa:	00003517          	auipc	a0,0x3
    2fae:	70e50513          	addi	a0,a0,1806 # 66b8 <malloc+0x154a>
    2fb2:	108020ef          	jal	50ba <printf>
    2fb6:	4505                	li	a0,1
    2fb8:	4cf010ef          	jal	4c86 <exit>
    2fbc:	85ca                	mv	a1,s2
    2fbe:	00003517          	auipc	a0,0x3
    2fc2:	72a50513          	addi	a0,a0,1834 # 66e8 <malloc+0x157a>
    2fc6:	0f4020ef          	jal	50ba <printf>
    2fca:	4505                	li	a0,1
    2fcc:	4bb010ef          	jal	4c86 <exit>
    2fd0:	85ca                	mv	a1,s2
    2fd2:	00003517          	auipc	a0,0x3
    2fd6:	74650513          	addi	a0,a0,1862 # 6718 <malloc+0x15aa>
    2fda:	0e0020ef          	jal	50ba <printf>
    2fde:	4505                	li	a0,1
    2fe0:	4a7010ef          	jal	4c86 <exit>
    2fe4:	85ca                	mv	a1,s2
    2fe6:	00003517          	auipc	a0,0x3
    2fea:	74a50513          	addi	a0,a0,1866 # 6730 <malloc+0x15c2>
    2fee:	0cc020ef          	jal	50ba <printf>
    2ff2:	4505                	li	a0,1
    2ff4:	493010ef          	jal	4c86 <exit>
    2ff8:	85ca                	mv	a1,s2
    2ffa:	00003517          	auipc	a0,0x3
    2ffe:	75650513          	addi	a0,a0,1878 # 6750 <malloc+0x15e2>
    3002:	0b8020ef          	jal	50ba <printf>
    3006:	4505                	li	a0,1
    3008:	47f010ef          	jal	4c86 <exit>
    300c:	85ca                	mv	a1,s2
    300e:	00003517          	auipc	a0,0x3
    3012:	76250513          	addi	a0,a0,1890 # 6770 <malloc+0x1602>
    3016:	0a4020ef          	jal	50ba <printf>
    301a:	4505                	li	a0,1
    301c:	46b010ef          	jal	4c86 <exit>
    3020:	85ca                	mv	a1,s2
    3022:	00003517          	auipc	a0,0x3
    3026:	78e50513          	addi	a0,a0,1934 # 67b0 <malloc+0x1642>
    302a:	090020ef          	jal	50ba <printf>
    302e:	4505                	li	a0,1
    3030:	457010ef          	jal	4c86 <exit>
    3034:	85ca                	mv	a1,s2
    3036:	00003517          	auipc	a0,0x3
    303a:	7aa50513          	addi	a0,a0,1962 # 67e0 <malloc+0x1672>
    303e:	07c020ef          	jal	50ba <printf>
    3042:	4505                	li	a0,1
    3044:	443010ef          	jal	4c86 <exit>
    3048:	85ca                	mv	a1,s2
    304a:	00003517          	auipc	a0,0x3
    304e:	7b650513          	addi	a0,a0,1974 # 6800 <malloc+0x1692>
    3052:	068020ef          	jal	50ba <printf>
    3056:	4505                	li	a0,1
    3058:	42f010ef          	jal	4c86 <exit>
    305c:	85ca                	mv	a1,s2
    305e:	00003517          	auipc	a0,0x3
    3062:	7c250513          	addi	a0,a0,1986 # 6820 <malloc+0x16b2>
    3066:	054020ef          	jal	50ba <printf>
    306a:	4505                	li	a0,1
    306c:	41b010ef          	jal	4c86 <exit>
    3070:	85ca                	mv	a1,s2
    3072:	00003517          	auipc	a0,0x3
    3076:	7ce50513          	addi	a0,a0,1998 # 6840 <malloc+0x16d2>
    307a:	040020ef          	jal	50ba <printf>
    307e:	4505                	li	a0,1
    3080:	407010ef          	jal	4c86 <exit>
    3084:	85ca                	mv	a1,s2
    3086:	00003517          	auipc	a0,0x3
    308a:	7ea50513          	addi	a0,a0,2026 # 6870 <malloc+0x1702>
    308e:	02c020ef          	jal	50ba <printf>
    3092:	4505                	li	a0,1
    3094:	3f3010ef          	jal	4c86 <exit>
    3098:	85ca                	mv	a1,s2
    309a:	00003517          	auipc	a0,0x3
    309e:	7fe50513          	addi	a0,a0,2046 # 6898 <malloc+0x172a>
    30a2:	018020ef          	jal	50ba <printf>
    30a6:	4505                	li	a0,1
    30a8:	3df010ef          	jal	4c86 <exit>
    30ac:	85ca                	mv	a1,s2
    30ae:	00004517          	auipc	a0,0x4
    30b2:	81250513          	addi	a0,a0,-2030 # 68c0 <malloc+0x1752>
    30b6:	004020ef          	jal	50ba <printf>
    30ba:	4505                	li	a0,1
    30bc:	3cb010ef          	jal	4c86 <exit>
    30c0:	85ca                	mv	a1,s2
    30c2:	00004517          	auipc	a0,0x4
    30c6:	82650513          	addi	a0,a0,-2010 # 68e8 <malloc+0x177a>
    30ca:	7f1010ef          	jal	50ba <printf>
    30ce:	4505                	li	a0,1
    30d0:	3b7010ef          	jal	4c86 <exit>
    30d4:	85ca                	mv	a1,s2
    30d6:	00004517          	auipc	a0,0x4
    30da:	83250513          	addi	a0,a0,-1998 # 6908 <malloc+0x179a>
    30de:	7dd010ef          	jal	50ba <printf>
    30e2:	4505                	li	a0,1
    30e4:	3a3010ef          	jal	4c86 <exit>
    30e8:	85ca                	mv	a1,s2
    30ea:	00004517          	auipc	a0,0x4
    30ee:	83e50513          	addi	a0,a0,-1986 # 6928 <malloc+0x17ba>
    30f2:	7c9010ef          	jal	50ba <printf>
    30f6:	4505                	li	a0,1
    30f8:	38f010ef          	jal	4c86 <exit>
    30fc:	85ca                	mv	a1,s2
    30fe:	00004517          	auipc	a0,0x4
    3102:	85250513          	addi	a0,a0,-1966 # 6950 <malloc+0x17e2>
    3106:	7b5010ef          	jal	50ba <printf>
    310a:	4505                	li	a0,1
    310c:	37b010ef          	jal	4c86 <exit>
    3110:	85ca                	mv	a1,s2
    3112:	00004517          	auipc	a0,0x4
    3116:	85e50513          	addi	a0,a0,-1954 # 6970 <malloc+0x1802>
    311a:	7a1010ef          	jal	50ba <printf>
    311e:	4505                	li	a0,1
    3120:	367010ef          	jal	4c86 <exit>
    3124:	85ca                	mv	a1,s2
    3126:	00004517          	auipc	a0,0x4
    312a:	86a50513          	addi	a0,a0,-1942 # 6990 <malloc+0x1822>
    312e:	78d010ef          	jal	50ba <printf>
    3132:	4505                	li	a0,1
    3134:	353010ef          	jal	4c86 <exit>
    3138:	85ca                	mv	a1,s2
    313a:	00004517          	auipc	a0,0x4
    313e:	87e50513          	addi	a0,a0,-1922 # 69b8 <malloc+0x184a>
    3142:	779010ef          	jal	50ba <printf>
    3146:	4505                	li	a0,1
    3148:	33f010ef          	jal	4c86 <exit>
    314c:	85ca                	mv	a1,s2
    314e:	00003517          	auipc	a0,0x3
    3152:	4fa50513          	addi	a0,a0,1274 # 6648 <malloc+0x14da>
    3156:	765010ef          	jal	50ba <printf>
    315a:	4505                	li	a0,1
    315c:	32b010ef          	jal	4c86 <exit>
    3160:	85ca                	mv	a1,s2
    3162:	00004517          	auipc	a0,0x4
    3166:	87650513          	addi	a0,a0,-1930 # 69d8 <malloc+0x186a>
    316a:	751010ef          	jal	50ba <printf>
    316e:	4505                	li	a0,1
    3170:	317010ef          	jal	4c86 <exit>
    3174:	85ca                	mv	a1,s2
    3176:	00004517          	auipc	a0,0x4
    317a:	88250513          	addi	a0,a0,-1918 # 69f8 <malloc+0x188a>
    317e:	73d010ef          	jal	50ba <printf>
    3182:	4505                	li	a0,1
    3184:	303010ef          	jal	4c86 <exit>
    3188:	85ca                	mv	a1,s2
    318a:	00004517          	auipc	a0,0x4
    318e:	89e50513          	addi	a0,a0,-1890 # 6a28 <malloc+0x18ba>
    3192:	729010ef          	jal	50ba <printf>
    3196:	4505                	li	a0,1
    3198:	2ef010ef          	jal	4c86 <exit>
    319c:	85ca                	mv	a1,s2
    319e:	00004517          	auipc	a0,0x4
    31a2:	8aa50513          	addi	a0,a0,-1878 # 6a48 <malloc+0x18da>
    31a6:	715010ef          	jal	50ba <printf>
    31aa:	4505                	li	a0,1
    31ac:	2db010ef          	jal	4c86 <exit>

00000000000031b0 <rmdot>:
    31b0:	1101                	addi	sp,sp,-32
    31b2:	ec06                	sd	ra,24(sp)
    31b4:	e822                	sd	s0,16(sp)
    31b6:	e426                	sd	s1,8(sp)
    31b8:	1000                	addi	s0,sp,32
    31ba:	84aa                	mv	s1,a0
    31bc:	00004517          	auipc	a0,0x4
    31c0:	8a450513          	addi	a0,a0,-1884 # 6a60 <malloc+0x18f2>
    31c4:	32b010ef          	jal	4cee <mkdir>
    31c8:	e53d                	bnez	a0,3236 <rmdot+0x86>
    31ca:	00004517          	auipc	a0,0x4
    31ce:	89650513          	addi	a0,a0,-1898 # 6a60 <malloc+0x18f2>
    31d2:	325010ef          	jal	4cf6 <chdir>
    31d6:	e935                	bnez	a0,324a <rmdot+0x9a>
    31d8:	00002517          	auipc	a0,0x2
    31dc:	7b850513          	addi	a0,a0,1976 # 5990 <malloc+0x822>
    31e0:	2f7010ef          	jal	4cd6 <unlink>
    31e4:	cd2d                	beqz	a0,325e <rmdot+0xae>
    31e6:	00003517          	auipc	a0,0x3
    31ea:	2ca50513          	addi	a0,a0,714 # 64b0 <malloc+0x1342>
    31ee:	2e9010ef          	jal	4cd6 <unlink>
    31f2:	c141                	beqz	a0,3272 <rmdot+0xc2>
    31f4:	00003517          	auipc	a0,0x3
    31f8:	26450513          	addi	a0,a0,612 # 6458 <malloc+0x12ea>
    31fc:	2fb010ef          	jal	4cf6 <chdir>
    3200:	e159                	bnez	a0,3286 <rmdot+0xd6>
    3202:	00004517          	auipc	a0,0x4
    3206:	8c650513          	addi	a0,a0,-1850 # 6ac8 <malloc+0x195a>
    320a:	2cd010ef          	jal	4cd6 <unlink>
    320e:	c551                	beqz	a0,329a <rmdot+0xea>
    3210:	00004517          	auipc	a0,0x4
    3214:	8e050513          	addi	a0,a0,-1824 # 6af0 <malloc+0x1982>
    3218:	2bf010ef          	jal	4cd6 <unlink>
    321c:	c949                	beqz	a0,32ae <rmdot+0xfe>
    321e:	00004517          	auipc	a0,0x4
    3222:	84250513          	addi	a0,a0,-1982 # 6a60 <malloc+0x18f2>
    3226:	2b1010ef          	jal	4cd6 <unlink>
    322a:	ed41                	bnez	a0,32c2 <rmdot+0x112>
    322c:	60e2                	ld	ra,24(sp)
    322e:	6442                	ld	s0,16(sp)
    3230:	64a2                	ld	s1,8(sp)
    3232:	6105                	addi	sp,sp,32
    3234:	8082                	ret
    3236:	85a6                	mv	a1,s1
    3238:	00004517          	auipc	a0,0x4
    323c:	83050513          	addi	a0,a0,-2000 # 6a68 <malloc+0x18fa>
    3240:	67b010ef          	jal	50ba <printf>
    3244:	4505                	li	a0,1
    3246:	241010ef          	jal	4c86 <exit>
    324a:	85a6                	mv	a1,s1
    324c:	00004517          	auipc	a0,0x4
    3250:	83450513          	addi	a0,a0,-1996 # 6a80 <malloc+0x1912>
    3254:	667010ef          	jal	50ba <printf>
    3258:	4505                	li	a0,1
    325a:	22d010ef          	jal	4c86 <exit>
    325e:	85a6                	mv	a1,s1
    3260:	00004517          	auipc	a0,0x4
    3264:	83850513          	addi	a0,a0,-1992 # 6a98 <malloc+0x192a>
    3268:	653010ef          	jal	50ba <printf>
    326c:	4505                	li	a0,1
    326e:	219010ef          	jal	4c86 <exit>
    3272:	85a6                	mv	a1,s1
    3274:	00004517          	auipc	a0,0x4
    3278:	83c50513          	addi	a0,a0,-1988 # 6ab0 <malloc+0x1942>
    327c:	63f010ef          	jal	50ba <printf>
    3280:	4505                	li	a0,1
    3282:	205010ef          	jal	4c86 <exit>
    3286:	85a6                	mv	a1,s1
    3288:	00003517          	auipc	a0,0x3
    328c:	1d850513          	addi	a0,a0,472 # 6460 <malloc+0x12f2>
    3290:	62b010ef          	jal	50ba <printf>
    3294:	4505                	li	a0,1
    3296:	1f1010ef          	jal	4c86 <exit>
    329a:	85a6                	mv	a1,s1
    329c:	00004517          	auipc	a0,0x4
    32a0:	83450513          	addi	a0,a0,-1996 # 6ad0 <malloc+0x1962>
    32a4:	617010ef          	jal	50ba <printf>
    32a8:	4505                	li	a0,1
    32aa:	1dd010ef          	jal	4c86 <exit>
    32ae:	85a6                	mv	a1,s1
    32b0:	00004517          	auipc	a0,0x4
    32b4:	84850513          	addi	a0,a0,-1976 # 6af8 <malloc+0x198a>
    32b8:	603010ef          	jal	50ba <printf>
    32bc:	4505                	li	a0,1
    32be:	1c9010ef          	jal	4c86 <exit>
    32c2:	85a6                	mv	a1,s1
    32c4:	00004517          	auipc	a0,0x4
    32c8:	85450513          	addi	a0,a0,-1964 # 6b18 <malloc+0x19aa>
    32cc:	5ef010ef          	jal	50ba <printf>
    32d0:	4505                	li	a0,1
    32d2:	1b5010ef          	jal	4c86 <exit>

00000000000032d6 <dirfile>:
    32d6:	1101                	addi	sp,sp,-32
    32d8:	ec06                	sd	ra,24(sp)
    32da:	e822                	sd	s0,16(sp)
    32dc:	e426                	sd	s1,8(sp)
    32de:	e04a                	sd	s2,0(sp)
    32e0:	1000                	addi	s0,sp,32
    32e2:	892a                	mv	s2,a0
    32e4:	20000593          	li	a1,512
    32e8:	00004517          	auipc	a0,0x4
    32ec:	85050513          	addi	a0,a0,-1968 # 6b38 <malloc+0x19ca>
    32f0:	1d7010ef          	jal	4cc6 <open>
    32f4:	0c054563          	bltz	a0,33be <dirfile+0xe8>
    32f8:	1b7010ef          	jal	4cae <close>
    32fc:	00004517          	auipc	a0,0x4
    3300:	83c50513          	addi	a0,a0,-1988 # 6b38 <malloc+0x19ca>
    3304:	1f3010ef          	jal	4cf6 <chdir>
    3308:	c569                	beqz	a0,33d2 <dirfile+0xfc>
    330a:	4581                	li	a1,0
    330c:	00004517          	auipc	a0,0x4
    3310:	87450513          	addi	a0,a0,-1932 # 6b80 <malloc+0x1a12>
    3314:	1b3010ef          	jal	4cc6 <open>
    3318:	0c055763          	bgez	a0,33e6 <dirfile+0x110>
    331c:	20000593          	li	a1,512
    3320:	00004517          	auipc	a0,0x4
    3324:	86050513          	addi	a0,a0,-1952 # 6b80 <malloc+0x1a12>
    3328:	19f010ef          	jal	4cc6 <open>
    332c:	0c055763          	bgez	a0,33fa <dirfile+0x124>
    3330:	00004517          	auipc	a0,0x4
    3334:	85050513          	addi	a0,a0,-1968 # 6b80 <malloc+0x1a12>
    3338:	1b7010ef          	jal	4cee <mkdir>
    333c:	0c050963          	beqz	a0,340e <dirfile+0x138>
    3340:	00004517          	auipc	a0,0x4
    3344:	84050513          	addi	a0,a0,-1984 # 6b80 <malloc+0x1a12>
    3348:	18f010ef          	jal	4cd6 <unlink>
    334c:	0c050b63          	beqz	a0,3422 <dirfile+0x14c>
    3350:	00004597          	auipc	a1,0x4
    3354:	83058593          	addi	a1,a1,-2000 # 6b80 <malloc+0x1a12>
    3358:	00002517          	auipc	a0,0x2
    335c:	12850513          	addi	a0,a0,296 # 5480 <malloc+0x312>
    3360:	187010ef          	jal	4ce6 <link>
    3364:	0c050963          	beqz	a0,3436 <dirfile+0x160>
    3368:	00003517          	auipc	a0,0x3
    336c:	7d050513          	addi	a0,a0,2000 # 6b38 <malloc+0x19ca>
    3370:	167010ef          	jal	4cd6 <unlink>
    3374:	0c051b63          	bnez	a0,344a <dirfile+0x174>
    3378:	4589                	li	a1,2
    337a:	00002517          	auipc	a0,0x2
    337e:	61650513          	addi	a0,a0,1558 # 5990 <malloc+0x822>
    3382:	145010ef          	jal	4cc6 <open>
    3386:	0c055c63          	bgez	a0,345e <dirfile+0x188>
    338a:	4581                	li	a1,0
    338c:	00002517          	auipc	a0,0x2
    3390:	60450513          	addi	a0,a0,1540 # 5990 <malloc+0x822>
    3394:	133010ef          	jal	4cc6 <open>
    3398:	84aa                	mv	s1,a0
    339a:	4605                	li	a2,1
    339c:	00002597          	auipc	a1,0x2
    33a0:	f7c58593          	addi	a1,a1,-132 # 5318 <malloc+0x1aa>
    33a4:	103010ef          	jal	4ca6 <write>
    33a8:	0ca04563          	bgtz	a0,3472 <dirfile+0x19c>
    33ac:	8526                	mv	a0,s1
    33ae:	101010ef          	jal	4cae <close>
    33b2:	60e2                	ld	ra,24(sp)
    33b4:	6442                	ld	s0,16(sp)
    33b6:	64a2                	ld	s1,8(sp)
    33b8:	6902                	ld	s2,0(sp)
    33ba:	6105                	addi	sp,sp,32
    33bc:	8082                	ret
    33be:	85ca                	mv	a1,s2
    33c0:	00003517          	auipc	a0,0x3
    33c4:	78050513          	addi	a0,a0,1920 # 6b40 <malloc+0x19d2>
    33c8:	4f3010ef          	jal	50ba <printf>
    33cc:	4505                	li	a0,1
    33ce:	0b9010ef          	jal	4c86 <exit>
    33d2:	85ca                	mv	a1,s2
    33d4:	00003517          	auipc	a0,0x3
    33d8:	78c50513          	addi	a0,a0,1932 # 6b60 <malloc+0x19f2>
    33dc:	4df010ef          	jal	50ba <printf>
    33e0:	4505                	li	a0,1
    33e2:	0a5010ef          	jal	4c86 <exit>
    33e6:	85ca                	mv	a1,s2
    33e8:	00003517          	auipc	a0,0x3
    33ec:	7a850513          	addi	a0,a0,1960 # 6b90 <malloc+0x1a22>
    33f0:	4cb010ef          	jal	50ba <printf>
    33f4:	4505                	li	a0,1
    33f6:	091010ef          	jal	4c86 <exit>
    33fa:	85ca                	mv	a1,s2
    33fc:	00003517          	auipc	a0,0x3
    3400:	79450513          	addi	a0,a0,1940 # 6b90 <malloc+0x1a22>
    3404:	4b7010ef          	jal	50ba <printf>
    3408:	4505                	li	a0,1
    340a:	07d010ef          	jal	4c86 <exit>
    340e:	85ca                	mv	a1,s2
    3410:	00003517          	auipc	a0,0x3
    3414:	7a850513          	addi	a0,a0,1960 # 6bb8 <malloc+0x1a4a>
    3418:	4a3010ef          	jal	50ba <printf>
    341c:	4505                	li	a0,1
    341e:	069010ef          	jal	4c86 <exit>
    3422:	85ca                	mv	a1,s2
    3424:	00003517          	auipc	a0,0x3
    3428:	7bc50513          	addi	a0,a0,1980 # 6be0 <malloc+0x1a72>
    342c:	48f010ef          	jal	50ba <printf>
    3430:	4505                	li	a0,1
    3432:	055010ef          	jal	4c86 <exit>
    3436:	85ca                	mv	a1,s2
    3438:	00003517          	auipc	a0,0x3
    343c:	7d050513          	addi	a0,a0,2000 # 6c08 <malloc+0x1a9a>
    3440:	47b010ef          	jal	50ba <printf>
    3444:	4505                	li	a0,1
    3446:	041010ef          	jal	4c86 <exit>
    344a:	85ca                	mv	a1,s2
    344c:	00003517          	auipc	a0,0x3
    3450:	7e450513          	addi	a0,a0,2020 # 6c30 <malloc+0x1ac2>
    3454:	467010ef          	jal	50ba <printf>
    3458:	4505                	li	a0,1
    345a:	02d010ef          	jal	4c86 <exit>
    345e:	85ca                	mv	a1,s2
    3460:	00003517          	auipc	a0,0x3
    3464:	7f050513          	addi	a0,a0,2032 # 6c50 <malloc+0x1ae2>
    3468:	453010ef          	jal	50ba <printf>
    346c:	4505                	li	a0,1
    346e:	019010ef          	jal	4c86 <exit>
    3472:	85ca                	mv	a1,s2
    3474:	00004517          	auipc	a0,0x4
    3478:	80450513          	addi	a0,a0,-2044 # 6c78 <malloc+0x1b0a>
    347c:	43f010ef          	jal	50ba <printf>
    3480:	4505                	li	a0,1
    3482:	005010ef          	jal	4c86 <exit>

0000000000003486 <iref>:
    3486:	7139                	addi	sp,sp,-64
    3488:	fc06                	sd	ra,56(sp)
    348a:	f822                	sd	s0,48(sp)
    348c:	f426                	sd	s1,40(sp)
    348e:	f04a                	sd	s2,32(sp)
    3490:	ec4e                	sd	s3,24(sp)
    3492:	e852                	sd	s4,16(sp)
    3494:	e456                	sd	s5,8(sp)
    3496:	e05a                	sd	s6,0(sp)
    3498:	0080                	addi	s0,sp,64
    349a:	8b2a                	mv	s6,a0
    349c:	03300913          	li	s2,51
    34a0:	00003a17          	auipc	s4,0x3
    34a4:	7f0a0a13          	addi	s4,s4,2032 # 6c90 <malloc+0x1b22>
    34a8:	00003497          	auipc	s1,0x3
    34ac:	2f048493          	addi	s1,s1,752 # 6798 <malloc+0x162a>
    34b0:	00002a97          	auipc	s5,0x2
    34b4:	fd0a8a93          	addi	s5,s5,-48 # 5480 <malloc+0x312>
    34b8:	00003997          	auipc	s3,0x3
    34bc:	6d098993          	addi	s3,s3,1744 # 6b88 <malloc+0x1a1a>
    34c0:	a835                	j	34fc <iref+0x76>
    34c2:	85da                	mv	a1,s6
    34c4:	00003517          	auipc	a0,0x3
    34c8:	7d450513          	addi	a0,a0,2004 # 6c98 <malloc+0x1b2a>
    34cc:	3ef010ef          	jal	50ba <printf>
    34d0:	4505                	li	a0,1
    34d2:	7b4010ef          	jal	4c86 <exit>
    34d6:	85da                	mv	a1,s6
    34d8:	00003517          	auipc	a0,0x3
    34dc:	7d850513          	addi	a0,a0,2008 # 6cb0 <malloc+0x1b42>
    34e0:	3db010ef          	jal	50ba <printf>
    34e4:	4505                	li	a0,1
    34e6:	7a0010ef          	jal	4c86 <exit>
    34ea:	7c4010ef          	jal	4cae <close>
    34ee:	a82d                	j	3528 <iref+0xa2>
    34f0:	854e                	mv	a0,s3
    34f2:	7e4010ef          	jal	4cd6 <unlink>
    34f6:	397d                	addiw	s2,s2,-1
    34f8:	04090263          	beqz	s2,353c <iref+0xb6>
    34fc:	8552                	mv	a0,s4
    34fe:	7f0010ef          	jal	4cee <mkdir>
    3502:	f161                	bnez	a0,34c2 <iref+0x3c>
    3504:	8552                	mv	a0,s4
    3506:	7f0010ef          	jal	4cf6 <chdir>
    350a:	f571                	bnez	a0,34d6 <iref+0x50>
    350c:	8526                	mv	a0,s1
    350e:	7e0010ef          	jal	4cee <mkdir>
    3512:	85a6                	mv	a1,s1
    3514:	8556                	mv	a0,s5
    3516:	7d0010ef          	jal	4ce6 <link>
    351a:	20000593          	li	a1,512
    351e:	8526                	mv	a0,s1
    3520:	7a6010ef          	jal	4cc6 <open>
    3524:	fc0553e3          	bgez	a0,34ea <iref+0x64>
    3528:	20000593          	li	a1,512
    352c:	854e                	mv	a0,s3
    352e:	798010ef          	jal	4cc6 <open>
    3532:	fa054fe3          	bltz	a0,34f0 <iref+0x6a>
    3536:	778010ef          	jal	4cae <close>
    353a:	bf5d                	j	34f0 <iref+0x6a>
    353c:	03300493          	li	s1,51
    3540:	00003997          	auipc	s3,0x3
    3544:	f7098993          	addi	s3,s3,-144 # 64b0 <malloc+0x1342>
    3548:	00003917          	auipc	s2,0x3
    354c:	74890913          	addi	s2,s2,1864 # 6c90 <malloc+0x1b22>
    3550:	854e                	mv	a0,s3
    3552:	7a4010ef          	jal	4cf6 <chdir>
    3556:	854a                	mv	a0,s2
    3558:	77e010ef          	jal	4cd6 <unlink>
    355c:	34fd                	addiw	s1,s1,-1
    355e:	f8ed                	bnez	s1,3550 <iref+0xca>
    3560:	00003517          	auipc	a0,0x3
    3564:	ef850513          	addi	a0,a0,-264 # 6458 <malloc+0x12ea>
    3568:	78e010ef          	jal	4cf6 <chdir>
    356c:	70e2                	ld	ra,56(sp)
    356e:	7442                	ld	s0,48(sp)
    3570:	74a2                	ld	s1,40(sp)
    3572:	7902                	ld	s2,32(sp)
    3574:	69e2                	ld	s3,24(sp)
    3576:	6a42                	ld	s4,16(sp)
    3578:	6aa2                	ld	s5,8(sp)
    357a:	6b02                	ld	s6,0(sp)
    357c:	6121                	addi	sp,sp,64
    357e:	8082                	ret

0000000000003580 <openiputtest>:
    3580:	7179                	addi	sp,sp,-48
    3582:	f406                	sd	ra,40(sp)
    3584:	f022                	sd	s0,32(sp)
    3586:	ec26                	sd	s1,24(sp)
    3588:	1800                	addi	s0,sp,48
    358a:	84aa                	mv	s1,a0
    358c:	00003517          	auipc	a0,0x3
    3590:	73c50513          	addi	a0,a0,1852 # 6cc8 <malloc+0x1b5a>
    3594:	75a010ef          	jal	4cee <mkdir>
    3598:	02054a63          	bltz	a0,35cc <openiputtest+0x4c>
    359c:	6e2010ef          	jal	4c7e <fork>
    35a0:	04054063          	bltz	a0,35e0 <openiputtest+0x60>
    35a4:	e939                	bnez	a0,35fa <openiputtest+0x7a>
    35a6:	4589                	li	a1,2
    35a8:	00003517          	auipc	a0,0x3
    35ac:	72050513          	addi	a0,a0,1824 # 6cc8 <malloc+0x1b5a>
    35b0:	716010ef          	jal	4cc6 <open>
    35b4:	04054063          	bltz	a0,35f4 <openiputtest+0x74>
    35b8:	85a6                	mv	a1,s1
    35ba:	00003517          	auipc	a0,0x3
    35be:	72e50513          	addi	a0,a0,1838 # 6ce8 <malloc+0x1b7a>
    35c2:	2f9010ef          	jal	50ba <printf>
    35c6:	4505                	li	a0,1
    35c8:	6be010ef          	jal	4c86 <exit>
    35cc:	85a6                	mv	a1,s1
    35ce:	00003517          	auipc	a0,0x3
    35d2:	70250513          	addi	a0,a0,1794 # 6cd0 <malloc+0x1b62>
    35d6:	2e5010ef          	jal	50ba <printf>
    35da:	4505                	li	a0,1
    35dc:	6aa010ef          	jal	4c86 <exit>
    35e0:	85a6                	mv	a1,s1
    35e2:	00002517          	auipc	a0,0x2
    35e6:	55650513          	addi	a0,a0,1366 # 5b38 <malloc+0x9ca>
    35ea:	2d1010ef          	jal	50ba <printf>
    35ee:	4505                	li	a0,1
    35f0:	696010ef          	jal	4c86 <exit>
    35f4:	4501                	li	a0,0
    35f6:	690010ef          	jal	4c86 <exit>
    35fa:	4505                	li	a0,1
    35fc:	71a010ef          	jal	4d16 <pause>
    3600:	00003517          	auipc	a0,0x3
    3604:	6c850513          	addi	a0,a0,1736 # 6cc8 <malloc+0x1b5a>
    3608:	6ce010ef          	jal	4cd6 <unlink>
    360c:	c919                	beqz	a0,3622 <openiputtest+0xa2>
    360e:	85a6                	mv	a1,s1
    3610:	00002517          	auipc	a0,0x2
    3614:	71850513          	addi	a0,a0,1816 # 5d28 <malloc+0xbba>
    3618:	2a3010ef          	jal	50ba <printf>
    361c:	4505                	li	a0,1
    361e:	668010ef          	jal	4c86 <exit>
    3622:	fdc40513          	addi	a0,s0,-36
    3626:	668010ef          	jal	4c8e <wait>
    362a:	fdc42503          	lw	a0,-36(s0)
    362e:	658010ef          	jal	4c86 <exit>

0000000000003632 <forkforkfork>:
    3632:	1101                	addi	sp,sp,-32
    3634:	ec06                	sd	ra,24(sp)
    3636:	e822                	sd	s0,16(sp)
    3638:	e426                	sd	s1,8(sp)
    363a:	1000                	addi	s0,sp,32
    363c:	84aa                	mv	s1,a0
    363e:	00003517          	auipc	a0,0x3
    3642:	6d250513          	addi	a0,a0,1746 # 6d10 <malloc+0x1ba2>
    3646:	690010ef          	jal	4cd6 <unlink>
    364a:	634010ef          	jal	4c7e <fork>
    364e:	02054b63          	bltz	a0,3684 <forkforkfork+0x52>
    3652:	c139                	beqz	a0,3698 <forkforkfork+0x66>
    3654:	4551                	li	a0,20
    3656:	6c0010ef          	jal	4d16 <pause>
    365a:	20200593          	li	a1,514
    365e:	00003517          	auipc	a0,0x3
    3662:	6b250513          	addi	a0,a0,1714 # 6d10 <malloc+0x1ba2>
    3666:	660010ef          	jal	4cc6 <open>
    366a:	644010ef          	jal	4cae <close>
    366e:	4501                	li	a0,0
    3670:	61e010ef          	jal	4c8e <wait>
    3674:	4529                	li	a0,10
    3676:	6a0010ef          	jal	4d16 <pause>
    367a:	60e2                	ld	ra,24(sp)
    367c:	6442                	ld	s0,16(sp)
    367e:	64a2                	ld	s1,8(sp)
    3680:	6105                	addi	sp,sp,32
    3682:	8082                	ret
    3684:	85a6                	mv	a1,s1
    3686:	00002517          	auipc	a0,0x2
    368a:	67250513          	addi	a0,a0,1650 # 5cf8 <malloc+0xb8a>
    368e:	22d010ef          	jal	50ba <printf>
    3692:	4505                	li	a0,1
    3694:	5f2010ef          	jal	4c86 <exit>
    3698:	00003497          	auipc	s1,0x3
    369c:	67848493          	addi	s1,s1,1656 # 6d10 <malloc+0x1ba2>
    36a0:	4581                	li	a1,0
    36a2:	8526                	mv	a0,s1
    36a4:	622010ef          	jal	4cc6 <open>
    36a8:	02055163          	bgez	a0,36ca <forkforkfork+0x98>
    36ac:	5d2010ef          	jal	4c7e <fork>
    36b0:	fe0558e3          	bgez	a0,36a0 <forkforkfork+0x6e>
    36b4:	20200593          	li	a1,514
    36b8:	00003517          	auipc	a0,0x3
    36bc:	65850513          	addi	a0,a0,1624 # 6d10 <malloc+0x1ba2>
    36c0:	606010ef          	jal	4cc6 <open>
    36c4:	5ea010ef          	jal	4cae <close>
    36c8:	bfe1                	j	36a0 <forkforkfork+0x6e>
    36ca:	4501                	li	a0,0
    36cc:	5ba010ef          	jal	4c86 <exit>

00000000000036d0 <killstatus>:
    36d0:	7139                	addi	sp,sp,-64
    36d2:	fc06                	sd	ra,56(sp)
    36d4:	f822                	sd	s0,48(sp)
    36d6:	f426                	sd	s1,40(sp)
    36d8:	f04a                	sd	s2,32(sp)
    36da:	ec4e                	sd	s3,24(sp)
    36dc:	e852                	sd	s4,16(sp)
    36de:	0080                	addi	s0,sp,64
    36e0:	8a2a                	mv	s4,a0
    36e2:	06400913          	li	s2,100
    36e6:	59fd                	li	s3,-1
    36e8:	596010ef          	jal	4c7e <fork>
    36ec:	84aa                	mv	s1,a0
    36ee:	02054763          	bltz	a0,371c <killstatus+0x4c>
    36f2:	cd1d                	beqz	a0,3730 <killstatus+0x60>
    36f4:	4505                	li	a0,1
    36f6:	620010ef          	jal	4d16 <pause>
    36fa:	8526                	mv	a0,s1
    36fc:	5ba010ef          	jal	4cb6 <kill>
    3700:	fcc40513          	addi	a0,s0,-52
    3704:	58a010ef          	jal	4c8e <wait>
    3708:	fcc42783          	lw	a5,-52(s0)
    370c:	03379563          	bne	a5,s3,3736 <killstatus+0x66>
    3710:	397d                	addiw	s2,s2,-1
    3712:	fc091be3          	bnez	s2,36e8 <killstatus+0x18>
    3716:	4501                	li	a0,0
    3718:	56e010ef          	jal	4c86 <exit>
    371c:	85d2                	mv	a1,s4
    371e:	00002517          	auipc	a0,0x2
    3722:	41a50513          	addi	a0,a0,1050 # 5b38 <malloc+0x9ca>
    3726:	195010ef          	jal	50ba <printf>
    372a:	4505                	li	a0,1
    372c:	55a010ef          	jal	4c86 <exit>
    3730:	5d6010ef          	jal	4d06 <getpid>
    3734:	bff5                	j	3730 <killstatus+0x60>
    3736:	85d2                	mv	a1,s4
    3738:	00003517          	auipc	a0,0x3
    373c:	5e850513          	addi	a0,a0,1512 # 6d20 <malloc+0x1bb2>
    3740:	17b010ef          	jal	50ba <printf>
    3744:	4505                	li	a0,1
    3746:	540010ef          	jal	4c86 <exit>

000000000000374a <preempt>:
    374a:	7139                	addi	sp,sp,-64
    374c:	fc06                	sd	ra,56(sp)
    374e:	f822                	sd	s0,48(sp)
    3750:	f426                	sd	s1,40(sp)
    3752:	f04a                	sd	s2,32(sp)
    3754:	ec4e                	sd	s3,24(sp)
    3756:	e852                	sd	s4,16(sp)
    3758:	0080                	addi	s0,sp,64
    375a:	892a                	mv	s2,a0
    375c:	522010ef          	jal	4c7e <fork>
    3760:	00054563          	bltz	a0,376a <preempt+0x20>
    3764:	84aa                	mv	s1,a0
    3766:	ed01                	bnez	a0,377e <preempt+0x34>
    3768:	a001                	j	3768 <preempt+0x1e>
    376a:	85ca                	mv	a1,s2
    376c:	00002517          	auipc	a0,0x2
    3770:	58c50513          	addi	a0,a0,1420 # 5cf8 <malloc+0xb8a>
    3774:	147010ef          	jal	50ba <printf>
    3778:	4505                	li	a0,1
    377a:	50c010ef          	jal	4c86 <exit>
    377e:	500010ef          	jal	4c7e <fork>
    3782:	89aa                	mv	s3,a0
    3784:	00054463          	bltz	a0,378c <preempt+0x42>
    3788:	ed01                	bnez	a0,37a0 <preempt+0x56>
    378a:	a001                	j	378a <preempt+0x40>
    378c:	85ca                	mv	a1,s2
    378e:	00002517          	auipc	a0,0x2
    3792:	3aa50513          	addi	a0,a0,938 # 5b38 <malloc+0x9ca>
    3796:	125010ef          	jal	50ba <printf>
    379a:	4505                	li	a0,1
    379c:	4ea010ef          	jal	4c86 <exit>
    37a0:	fc840513          	addi	a0,s0,-56
    37a4:	4f2010ef          	jal	4c96 <pipe>
    37a8:	4d6010ef          	jal	4c7e <fork>
    37ac:	8a2a                	mv	s4,a0
    37ae:	02054863          	bltz	a0,37de <preempt+0x94>
    37b2:	e921                	bnez	a0,3802 <preempt+0xb8>
    37b4:	fc842503          	lw	a0,-56(s0)
    37b8:	4f6010ef          	jal	4cae <close>
    37bc:	4605                	li	a2,1
    37be:	00002597          	auipc	a1,0x2
    37c2:	b5a58593          	addi	a1,a1,-1190 # 5318 <malloc+0x1aa>
    37c6:	fcc42503          	lw	a0,-52(s0)
    37ca:	4dc010ef          	jal	4ca6 <write>
    37ce:	4785                	li	a5,1
    37d0:	02f51163          	bne	a0,a5,37f2 <preempt+0xa8>
    37d4:	fcc42503          	lw	a0,-52(s0)
    37d8:	4d6010ef          	jal	4cae <close>
    37dc:	a001                	j	37dc <preempt+0x92>
    37de:	85ca                	mv	a1,s2
    37e0:	00002517          	auipc	a0,0x2
    37e4:	35850513          	addi	a0,a0,856 # 5b38 <malloc+0x9ca>
    37e8:	0d3010ef          	jal	50ba <printf>
    37ec:	4505                	li	a0,1
    37ee:	498010ef          	jal	4c86 <exit>
    37f2:	85ca                	mv	a1,s2
    37f4:	00003517          	auipc	a0,0x3
    37f8:	54c50513          	addi	a0,a0,1356 # 6d40 <malloc+0x1bd2>
    37fc:	0bf010ef          	jal	50ba <printf>
    3800:	bfd1                	j	37d4 <preempt+0x8a>
    3802:	fcc42503          	lw	a0,-52(s0)
    3806:	4a8010ef          	jal	4cae <close>
    380a:	660d                	lui	a2,0x3
    380c:	00009597          	auipc	a1,0x9
    3810:	49c58593          	addi	a1,a1,1180 # cca8 <buf>
    3814:	fc842503          	lw	a0,-56(s0)
    3818:	486010ef          	jal	4c9e <read>
    381c:	4785                	li	a5,1
    381e:	02f50163          	beq	a0,a5,3840 <preempt+0xf6>
    3822:	85ca                	mv	a1,s2
    3824:	00003517          	auipc	a0,0x3
    3828:	53450513          	addi	a0,a0,1332 # 6d58 <malloc+0x1bea>
    382c:	08f010ef          	jal	50ba <printf>
    3830:	70e2                	ld	ra,56(sp)
    3832:	7442                	ld	s0,48(sp)
    3834:	74a2                	ld	s1,40(sp)
    3836:	7902                	ld	s2,32(sp)
    3838:	69e2                	ld	s3,24(sp)
    383a:	6a42                	ld	s4,16(sp)
    383c:	6121                	addi	sp,sp,64
    383e:	8082                	ret
    3840:	fc842503          	lw	a0,-56(s0)
    3844:	46a010ef          	jal	4cae <close>
    3848:	00003517          	auipc	a0,0x3
    384c:	52850513          	addi	a0,a0,1320 # 6d70 <malloc+0x1c02>
    3850:	06b010ef          	jal	50ba <printf>
    3854:	8526                	mv	a0,s1
    3856:	460010ef          	jal	4cb6 <kill>
    385a:	854e                	mv	a0,s3
    385c:	45a010ef          	jal	4cb6 <kill>
    3860:	8552                	mv	a0,s4
    3862:	454010ef          	jal	4cb6 <kill>
    3866:	00003517          	auipc	a0,0x3
    386a:	51a50513          	addi	a0,a0,1306 # 6d80 <malloc+0x1c12>
    386e:	04d010ef          	jal	50ba <printf>
    3872:	4501                	li	a0,0
    3874:	41a010ef          	jal	4c8e <wait>
    3878:	4501                	li	a0,0
    387a:	414010ef          	jal	4c8e <wait>
    387e:	4501                	li	a0,0
    3880:	40e010ef          	jal	4c8e <wait>
    3884:	b775                	j	3830 <preempt+0xe6>

0000000000003886 <reparent>:
    3886:	7179                	addi	sp,sp,-48
    3888:	f406                	sd	ra,40(sp)
    388a:	f022                	sd	s0,32(sp)
    388c:	ec26                	sd	s1,24(sp)
    388e:	e84a                	sd	s2,16(sp)
    3890:	e44e                	sd	s3,8(sp)
    3892:	e052                	sd	s4,0(sp)
    3894:	1800                	addi	s0,sp,48
    3896:	89aa                	mv	s3,a0
    3898:	46e010ef          	jal	4d06 <getpid>
    389c:	8a2a                	mv	s4,a0
    389e:	0c800913          	li	s2,200
    38a2:	3dc010ef          	jal	4c7e <fork>
    38a6:	84aa                	mv	s1,a0
    38a8:	00054e63          	bltz	a0,38c4 <reparent+0x3e>
    38ac:	c121                	beqz	a0,38ec <reparent+0x66>
    38ae:	4501                	li	a0,0
    38b0:	3de010ef          	jal	4c8e <wait>
    38b4:	02951263          	bne	a0,s1,38d8 <reparent+0x52>
    38b8:	397d                	addiw	s2,s2,-1
    38ba:	fe0914e3          	bnez	s2,38a2 <reparent+0x1c>
    38be:	4501                	li	a0,0
    38c0:	3c6010ef          	jal	4c86 <exit>
    38c4:	85ce                	mv	a1,s3
    38c6:	00002517          	auipc	a0,0x2
    38ca:	27250513          	addi	a0,a0,626 # 5b38 <malloc+0x9ca>
    38ce:	7ec010ef          	jal	50ba <printf>
    38d2:	4505                	li	a0,1
    38d4:	3b2010ef          	jal	4c86 <exit>
    38d8:	85ce                	mv	a1,s3
    38da:	00002517          	auipc	a0,0x2
    38de:	3e650513          	addi	a0,a0,998 # 5cc0 <malloc+0xb52>
    38e2:	7d8010ef          	jal	50ba <printf>
    38e6:	4505                	li	a0,1
    38e8:	39e010ef          	jal	4c86 <exit>
    38ec:	392010ef          	jal	4c7e <fork>
    38f0:	00054563          	bltz	a0,38fa <reparent+0x74>
    38f4:	4501                	li	a0,0
    38f6:	390010ef          	jal	4c86 <exit>
    38fa:	8552                	mv	a0,s4
    38fc:	3ba010ef          	jal	4cb6 <kill>
    3900:	4505                	li	a0,1
    3902:	384010ef          	jal	4c86 <exit>

0000000000003906 <sbrkfail>:
    3906:	7175                	addi	sp,sp,-144
    3908:	e506                	sd	ra,136(sp)
    390a:	e122                	sd	s0,128(sp)
    390c:	fca6                	sd	s1,120(sp)
    390e:	f8ca                	sd	s2,112(sp)
    3910:	f4ce                	sd	s3,104(sp)
    3912:	f0d2                	sd	s4,96(sp)
    3914:	ecd6                	sd	s5,88(sp)
    3916:	e8da                	sd	s6,80(sp)
    3918:	e4de                	sd	s7,72(sp)
    391a:	0900                	addi	s0,sp,144
    391c:	8b2a                	mv	s6,a0
    391e:	fa040513          	addi	a0,s0,-96
    3922:	374010ef          	jal	4c96 <pipe>
    3926:	e919                	bnez	a0,393c <sbrkfail+0x36>
    3928:	8aaa                	mv	s5,a0
    392a:	f7040493          	addi	s1,s0,-144
    392e:	f9840993          	addi	s3,s0,-104
    3932:	8926                	mv	s2,s1
    3934:	5a7d                	li	s4,-1
    3936:	03000b93          	li	s7,48
    393a:	a08d                	j	399c <sbrkfail+0x96>
    393c:	85da                	mv	a1,s6
    393e:	00002517          	auipc	a0,0x2
    3942:	30250513          	addi	a0,a0,770 # 5c40 <malloc+0xad2>
    3946:	774010ef          	jal	50ba <printf>
    394a:	4505                	li	a0,1
    394c:	33a010ef          	jal	4c86 <exit>
    3950:	302010ef          	jal	4c52 <sbrk>
    3954:	064007b7          	lui	a5,0x6400
    3958:	40a7853b          	subw	a0,a5,a0
    395c:	2f6010ef          	jal	4c52 <sbrk>
    3960:	57fd                	li	a5,-1
    3962:	02f50063          	beq	a0,a5,3982 <sbrkfail+0x7c>
    3966:	4605                	li	a2,1
    3968:	00004597          	auipc	a1,0x4
    396c:	ab858593          	addi	a1,a1,-1352 # 7420 <malloc+0x22b2>
    3970:	fa442503          	lw	a0,-92(s0)
    3974:	332010ef          	jal	4ca6 <write>
    3978:	3e800513          	li	a0,1000
    397c:	39a010ef          	jal	4d16 <pause>
    3980:	bfe5                	j	3978 <sbrkfail+0x72>
    3982:	4605                	li	a2,1
    3984:	00003597          	auipc	a1,0x3
    3988:	40c58593          	addi	a1,a1,1036 # 6d90 <malloc+0x1c22>
    398c:	fa442503          	lw	a0,-92(s0)
    3990:	316010ef          	jal	4ca6 <write>
    3994:	b7d5                	j	3978 <sbrkfail+0x72>
    3996:	0911                	addi	s2,s2,4
    3998:	03390663          	beq	s2,s3,39c4 <sbrkfail+0xbe>
    399c:	2e2010ef          	jal	4c7e <fork>
    39a0:	00a92023          	sw	a0,0(s2)
    39a4:	d555                	beqz	a0,3950 <sbrkfail+0x4a>
    39a6:	ff4508e3          	beq	a0,s4,3996 <sbrkfail+0x90>
    39aa:	4605                	li	a2,1
    39ac:	f9f40593          	addi	a1,s0,-97
    39b0:	fa042503          	lw	a0,-96(s0)
    39b4:	2ea010ef          	jal	4c9e <read>
    39b8:	f9f44783          	lbu	a5,-97(s0)
    39bc:	fd779de3          	bne	a5,s7,3996 <sbrkfail+0x90>
    39c0:	4a85                	li	s5,1
    39c2:	bfd1                	j	3996 <sbrkfail+0x90>
    39c4:	000a8863          	beqz	s5,39d4 <sbrkfail+0xce>
    39c8:	6505                	lui	a0,0x1
    39ca:	288010ef          	jal	4c52 <sbrk>
    39ce:	8a2a                	mv	s4,a0
    39d0:	597d                	li	s2,-1
    39d2:	a821                	j	39ea <sbrkfail+0xe4>
    39d4:	85da                	mv	a1,s6
    39d6:	00003517          	auipc	a0,0x3
    39da:	3c250513          	addi	a0,a0,962 # 6d98 <malloc+0x1c2a>
    39de:	6dc010ef          	jal	50ba <printf>
    39e2:	b7dd                	j	39c8 <sbrkfail+0xc2>
    39e4:	0491                	addi	s1,s1,4
    39e6:	01348b63          	beq	s1,s3,39fc <sbrkfail+0xf6>
    39ea:	4088                	lw	a0,0(s1)
    39ec:	ff250ce3          	beq	a0,s2,39e4 <sbrkfail+0xde>
    39f0:	2c6010ef          	jal	4cb6 <kill>
    39f4:	4501                	li	a0,0
    39f6:	298010ef          	jal	4c8e <wait>
    39fa:	b7ed                	j	39e4 <sbrkfail+0xde>
    39fc:	57fd                	li	a5,-1
    39fe:	02fa0a63          	beq	s4,a5,3a32 <sbrkfail+0x12c>
    3a02:	27c010ef          	jal	4c7e <fork>
    3a06:	04054063          	bltz	a0,3a46 <sbrkfail+0x140>
    3a0a:	e939                	bnez	a0,3a60 <sbrkfail+0x15a>
    3a0c:	3e800537          	lui	a0,0x3e800
    3a10:	242010ef          	jal	4c52 <sbrk>
    3a14:	57fd                	li	a5,-1
    3a16:	04f50263          	beq	a0,a5,3a5a <sbrkfail+0x154>
    3a1a:	3e800637          	lui	a2,0x3e800
    3a1e:	85da                	mv	a1,s6
    3a20:	00003517          	auipc	a0,0x3
    3a24:	3c850513          	addi	a0,a0,968 # 6de8 <malloc+0x1c7a>
    3a28:	692010ef          	jal	50ba <printf>
    3a2c:	4505                	li	a0,1
    3a2e:	258010ef          	jal	4c86 <exit>
    3a32:	85da                	mv	a1,s6
    3a34:	00003517          	auipc	a0,0x3
    3a38:	39450513          	addi	a0,a0,916 # 6dc8 <malloc+0x1c5a>
    3a3c:	67e010ef          	jal	50ba <printf>
    3a40:	4505                	li	a0,1
    3a42:	244010ef          	jal	4c86 <exit>
    3a46:	85da                	mv	a1,s6
    3a48:	00002517          	auipc	a0,0x2
    3a4c:	0f050513          	addi	a0,a0,240 # 5b38 <malloc+0x9ca>
    3a50:	66a010ef          	jal	50ba <printf>
    3a54:	4505                	li	a0,1
    3a56:	230010ef          	jal	4c86 <exit>
    3a5a:	4501                	li	a0,0
    3a5c:	22a010ef          	jal	4c86 <exit>
    3a60:	fac40513          	addi	a0,s0,-84
    3a64:	22a010ef          	jal	4c8e <wait>
    3a68:	fac42783          	lw	a5,-84(s0)
    3a6c:	ef81                	bnez	a5,3a84 <sbrkfail+0x17e>
    3a6e:	60aa                	ld	ra,136(sp)
    3a70:	640a                	ld	s0,128(sp)
    3a72:	74e6                	ld	s1,120(sp)
    3a74:	7946                	ld	s2,112(sp)
    3a76:	79a6                	ld	s3,104(sp)
    3a78:	7a06                	ld	s4,96(sp)
    3a7a:	6ae6                	ld	s5,88(sp)
    3a7c:	6b46                	ld	s6,80(sp)
    3a7e:	6ba6                	ld	s7,72(sp)
    3a80:	6149                	addi	sp,sp,144
    3a82:	8082                	ret
    3a84:	4505                	li	a0,1
    3a86:	200010ef          	jal	4c86 <exit>

0000000000003a8a <mem>:
    3a8a:	7139                	addi	sp,sp,-64
    3a8c:	fc06                	sd	ra,56(sp)
    3a8e:	f822                	sd	s0,48(sp)
    3a90:	f426                	sd	s1,40(sp)
    3a92:	f04a                	sd	s2,32(sp)
    3a94:	ec4e                	sd	s3,24(sp)
    3a96:	0080                	addi	s0,sp,64
    3a98:	89aa                	mv	s3,a0
    3a9a:	1e4010ef          	jal	4c7e <fork>
    3a9e:	4481                	li	s1,0
    3aa0:	6909                	lui	s2,0x2
    3aa2:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0x97>
    3aa6:	cd11                	beqz	a0,3ac2 <mem+0x38>
    3aa8:	fcc40513          	addi	a0,s0,-52
    3aac:	1e2010ef          	jal	4c8e <wait>
    3ab0:	fcc42503          	lw	a0,-52(s0)
    3ab4:	57fd                	li	a5,-1
    3ab6:	04f50363          	beq	a0,a5,3afc <mem+0x72>
    3aba:	1cc010ef          	jal	4c86 <exit>
    3abe:	e104                	sd	s1,0(a0)
    3ac0:	84aa                	mv	s1,a0
    3ac2:	854a                	mv	a0,s2
    3ac4:	6aa010ef          	jal	516e <malloc>
    3ac8:	f97d                	bnez	a0,3abe <mem+0x34>
    3aca:	c491                	beqz	s1,3ad6 <mem+0x4c>
    3acc:	8526                	mv	a0,s1
    3ace:	6084                	ld	s1,0(s1)
    3ad0:	61c010ef          	jal	50ec <free>
    3ad4:	fce5                	bnez	s1,3acc <mem+0x42>
    3ad6:	6515                	lui	a0,0x5
    3ad8:	696010ef          	jal	516e <malloc>
    3adc:	c511                	beqz	a0,3ae8 <mem+0x5e>
    3ade:	60e010ef          	jal	50ec <free>
    3ae2:	4501                	li	a0,0
    3ae4:	1a2010ef          	jal	4c86 <exit>
    3ae8:	85ce                	mv	a1,s3
    3aea:	00003517          	auipc	a0,0x3
    3aee:	32e50513          	addi	a0,a0,814 # 6e18 <malloc+0x1caa>
    3af2:	5c8010ef          	jal	50ba <printf>
    3af6:	4505                	li	a0,1
    3af8:	18e010ef          	jal	4c86 <exit>
    3afc:	4501                	li	a0,0
    3afe:	188010ef          	jal	4c86 <exit>

0000000000003b02 <sharedfd>:
    3b02:	7159                	addi	sp,sp,-112
    3b04:	f486                	sd	ra,104(sp)
    3b06:	f0a2                	sd	s0,96(sp)
    3b08:	e0d2                	sd	s4,64(sp)
    3b0a:	1880                	addi	s0,sp,112
    3b0c:	8a2a                	mv	s4,a0
    3b0e:	00003517          	auipc	a0,0x3
    3b12:	32a50513          	addi	a0,a0,810 # 6e38 <malloc+0x1cca>
    3b16:	1c0010ef          	jal	4cd6 <unlink>
    3b1a:	20200593          	li	a1,514
    3b1e:	00003517          	auipc	a0,0x3
    3b22:	31a50513          	addi	a0,a0,794 # 6e38 <malloc+0x1cca>
    3b26:	1a0010ef          	jal	4cc6 <open>
    3b2a:	04054863          	bltz	a0,3b7a <sharedfd+0x78>
    3b2e:	eca6                	sd	s1,88(sp)
    3b30:	e8ca                	sd	s2,80(sp)
    3b32:	e4ce                	sd	s3,72(sp)
    3b34:	fc56                	sd	s5,56(sp)
    3b36:	f85a                	sd	s6,48(sp)
    3b38:	f45e                	sd	s7,40(sp)
    3b3a:	892a                	mv	s2,a0
    3b3c:	142010ef          	jal	4c7e <fork>
    3b40:	89aa                	mv	s3,a0
    3b42:	07000593          	li	a1,112
    3b46:	e119                	bnez	a0,3b4c <sharedfd+0x4a>
    3b48:	06300593          	li	a1,99
    3b4c:	4629                	li	a2,10
    3b4e:	fa040513          	addi	a0,s0,-96
    3b52:	723000ef          	jal	4a74 <memset>
    3b56:	3e800493          	li	s1,1000
    3b5a:	4629                	li	a2,10
    3b5c:	fa040593          	addi	a1,s0,-96
    3b60:	854a                	mv	a0,s2
    3b62:	144010ef          	jal	4ca6 <write>
    3b66:	47a9                	li	a5,10
    3b68:	02f51963          	bne	a0,a5,3b9a <sharedfd+0x98>
    3b6c:	34fd                	addiw	s1,s1,-1
    3b6e:	f4f5                	bnez	s1,3b5a <sharedfd+0x58>
    3b70:	02099f63          	bnez	s3,3bae <sharedfd+0xac>
    3b74:	4501                	li	a0,0
    3b76:	110010ef          	jal	4c86 <exit>
    3b7a:	eca6                	sd	s1,88(sp)
    3b7c:	e8ca                	sd	s2,80(sp)
    3b7e:	e4ce                	sd	s3,72(sp)
    3b80:	fc56                	sd	s5,56(sp)
    3b82:	f85a                	sd	s6,48(sp)
    3b84:	f45e                	sd	s7,40(sp)
    3b86:	85d2                	mv	a1,s4
    3b88:	00003517          	auipc	a0,0x3
    3b8c:	2c050513          	addi	a0,a0,704 # 6e48 <malloc+0x1cda>
    3b90:	52a010ef          	jal	50ba <printf>
    3b94:	4505                	li	a0,1
    3b96:	0f0010ef          	jal	4c86 <exit>
    3b9a:	85d2                	mv	a1,s4
    3b9c:	00003517          	auipc	a0,0x3
    3ba0:	2d450513          	addi	a0,a0,724 # 6e70 <malloc+0x1d02>
    3ba4:	516010ef          	jal	50ba <printf>
    3ba8:	4505                	li	a0,1
    3baa:	0dc010ef          	jal	4c86 <exit>
    3bae:	f9c40513          	addi	a0,s0,-100
    3bb2:	0dc010ef          	jal	4c8e <wait>
    3bb6:	f9c42983          	lw	s3,-100(s0)
    3bba:	00098563          	beqz	s3,3bc4 <sharedfd+0xc2>
    3bbe:	854e                	mv	a0,s3
    3bc0:	0c6010ef          	jal	4c86 <exit>
    3bc4:	854a                	mv	a0,s2
    3bc6:	0e8010ef          	jal	4cae <close>
    3bca:	4581                	li	a1,0
    3bcc:	00003517          	auipc	a0,0x3
    3bd0:	26c50513          	addi	a0,a0,620 # 6e38 <malloc+0x1cca>
    3bd4:	0f2010ef          	jal	4cc6 <open>
    3bd8:	8baa                	mv	s7,a0
    3bda:	8ace                	mv	s5,s3
    3bdc:	02054363          	bltz	a0,3c02 <sharedfd+0x100>
    3be0:	faa40913          	addi	s2,s0,-86
    3be4:	06300493          	li	s1,99
    3be8:	07000b13          	li	s6,112
    3bec:	4629                	li	a2,10
    3bee:	fa040593          	addi	a1,s0,-96
    3bf2:	855e                	mv	a0,s7
    3bf4:	0aa010ef          	jal	4c9e <read>
    3bf8:	02a05b63          	blez	a0,3c2e <sharedfd+0x12c>
    3bfc:	fa040793          	addi	a5,s0,-96
    3c00:	a839                	j	3c1e <sharedfd+0x11c>
    3c02:	85d2                	mv	a1,s4
    3c04:	00003517          	auipc	a0,0x3
    3c08:	28c50513          	addi	a0,a0,652 # 6e90 <malloc+0x1d22>
    3c0c:	4ae010ef          	jal	50ba <printf>
    3c10:	4505                	li	a0,1
    3c12:	074010ef          	jal	4c86 <exit>
    3c16:	2985                	addiw	s3,s3,1
    3c18:	0785                	addi	a5,a5,1 # 6400001 <base+0x63f0359>
    3c1a:	fd2789e3          	beq	a5,s2,3bec <sharedfd+0xea>
    3c1e:	0007c703          	lbu	a4,0(a5)
    3c22:	fe970ae3          	beq	a4,s1,3c16 <sharedfd+0x114>
    3c26:	ff6719e3          	bne	a4,s6,3c18 <sharedfd+0x116>
    3c2a:	2a85                	addiw	s5,s5,1
    3c2c:	b7f5                	j	3c18 <sharedfd+0x116>
    3c2e:	855e                	mv	a0,s7
    3c30:	07e010ef          	jal	4cae <close>
    3c34:	00003517          	auipc	a0,0x3
    3c38:	20450513          	addi	a0,a0,516 # 6e38 <malloc+0x1cca>
    3c3c:	09a010ef          	jal	4cd6 <unlink>
    3c40:	6789                	lui	a5,0x2
    3c42:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x96>
    3c46:	00f99763          	bne	s3,a5,3c54 <sharedfd+0x152>
    3c4a:	6789                	lui	a5,0x2
    3c4c:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x96>
    3c50:	00fa8c63          	beq	s5,a5,3c68 <sharedfd+0x166>
    3c54:	85d2                	mv	a1,s4
    3c56:	00003517          	auipc	a0,0x3
    3c5a:	26250513          	addi	a0,a0,610 # 6eb8 <malloc+0x1d4a>
    3c5e:	45c010ef          	jal	50ba <printf>
    3c62:	4505                	li	a0,1
    3c64:	022010ef          	jal	4c86 <exit>
    3c68:	4501                	li	a0,0
    3c6a:	01c010ef          	jal	4c86 <exit>

0000000000003c6e <fourfiles>:
    3c6e:	7135                	addi	sp,sp,-160
    3c70:	ed06                	sd	ra,152(sp)
    3c72:	e922                	sd	s0,144(sp)
    3c74:	e526                	sd	s1,136(sp)
    3c76:	e14a                	sd	s2,128(sp)
    3c78:	fcce                	sd	s3,120(sp)
    3c7a:	f8d2                	sd	s4,112(sp)
    3c7c:	f4d6                	sd	s5,104(sp)
    3c7e:	f0da                	sd	s6,96(sp)
    3c80:	ecde                	sd	s7,88(sp)
    3c82:	e8e2                	sd	s8,80(sp)
    3c84:	e4e6                	sd	s9,72(sp)
    3c86:	e0ea                	sd	s10,64(sp)
    3c88:	fc6e                	sd	s11,56(sp)
    3c8a:	1100                	addi	s0,sp,160
    3c8c:	8caa                	mv	s9,a0
    3c8e:	00003797          	auipc	a5,0x3
    3c92:	24278793          	addi	a5,a5,578 # 6ed0 <malloc+0x1d62>
    3c96:	f6f43823          	sd	a5,-144(s0)
    3c9a:	00003797          	auipc	a5,0x3
    3c9e:	23e78793          	addi	a5,a5,574 # 6ed8 <malloc+0x1d6a>
    3ca2:	f6f43c23          	sd	a5,-136(s0)
    3ca6:	00003797          	auipc	a5,0x3
    3caa:	23a78793          	addi	a5,a5,570 # 6ee0 <malloc+0x1d72>
    3cae:	f8f43023          	sd	a5,-128(s0)
    3cb2:	00003797          	auipc	a5,0x3
    3cb6:	23678793          	addi	a5,a5,566 # 6ee8 <malloc+0x1d7a>
    3cba:	f8f43423          	sd	a5,-120(s0)
    3cbe:	f7040b93          	addi	s7,s0,-144
    3cc2:	895e                	mv	s2,s7
    3cc4:	4481                	li	s1,0
    3cc6:	4a11                	li	s4,4
    3cc8:	00093983          	ld	s3,0(s2)
    3ccc:	854e                	mv	a0,s3
    3cce:	008010ef          	jal	4cd6 <unlink>
    3cd2:	7ad000ef          	jal	4c7e <fork>
    3cd6:	02054e63          	bltz	a0,3d12 <fourfiles+0xa4>
    3cda:	c531                	beqz	a0,3d26 <fourfiles+0xb8>
    3cdc:	2485                	addiw	s1,s1,1
    3cde:	0921                	addi	s2,s2,8
    3ce0:	ff4494e3          	bne	s1,s4,3cc8 <fourfiles+0x5a>
    3ce4:	4491                	li	s1,4
    3ce6:	f6c40513          	addi	a0,s0,-148
    3cea:	7a5000ef          	jal	4c8e <wait>
    3cee:	f6c42a83          	lw	s5,-148(s0)
    3cf2:	0a0a9463          	bnez	s5,3d9a <fourfiles+0x12c>
    3cf6:	34fd                	addiw	s1,s1,-1
    3cf8:	f4fd                	bnez	s1,3ce6 <fourfiles+0x78>
    3cfa:	03000b13          	li	s6,48
    3cfe:	00009a17          	auipc	s4,0x9
    3d02:	faaa0a13          	addi	s4,s4,-86 # cca8 <buf>
    3d06:	6d05                	lui	s10,0x1
    3d08:	770d0d13          	addi	s10,s10,1904 # 1770 <forkfork+0x1e>
    3d0c:	03400d93          	li	s11,52
    3d10:	a0ed                	j	3dfa <fourfiles+0x18c>
    3d12:	85e6                	mv	a1,s9
    3d14:	00002517          	auipc	a0,0x2
    3d18:	e2450513          	addi	a0,a0,-476 # 5b38 <malloc+0x9ca>
    3d1c:	39e010ef          	jal	50ba <printf>
    3d20:	4505                	li	a0,1
    3d22:	765000ef          	jal	4c86 <exit>
    3d26:	20200593          	li	a1,514
    3d2a:	854e                	mv	a0,s3
    3d2c:	79b000ef          	jal	4cc6 <open>
    3d30:	892a                	mv	s2,a0
    3d32:	04054163          	bltz	a0,3d74 <fourfiles+0x106>
    3d36:	1f400613          	li	a2,500
    3d3a:	0304859b          	addiw	a1,s1,48
    3d3e:	00009517          	auipc	a0,0x9
    3d42:	f6a50513          	addi	a0,a0,-150 # cca8 <buf>
    3d46:	52f000ef          	jal	4a74 <memset>
    3d4a:	44b1                	li	s1,12
    3d4c:	00009997          	auipc	s3,0x9
    3d50:	f5c98993          	addi	s3,s3,-164 # cca8 <buf>
    3d54:	1f400613          	li	a2,500
    3d58:	85ce                	mv	a1,s3
    3d5a:	854a                	mv	a0,s2
    3d5c:	74b000ef          	jal	4ca6 <write>
    3d60:	85aa                	mv	a1,a0
    3d62:	1f400793          	li	a5,500
    3d66:	02f51163          	bne	a0,a5,3d88 <fourfiles+0x11a>
    3d6a:	34fd                	addiw	s1,s1,-1
    3d6c:	f4e5                	bnez	s1,3d54 <fourfiles+0xe6>
    3d6e:	4501                	li	a0,0
    3d70:	717000ef          	jal	4c86 <exit>
    3d74:	85e6                	mv	a1,s9
    3d76:	00002517          	auipc	a0,0x2
    3d7a:	e5a50513          	addi	a0,a0,-422 # 5bd0 <malloc+0xa62>
    3d7e:	33c010ef          	jal	50ba <printf>
    3d82:	4505                	li	a0,1
    3d84:	703000ef          	jal	4c86 <exit>
    3d88:	00003517          	auipc	a0,0x3
    3d8c:	16850513          	addi	a0,a0,360 # 6ef0 <malloc+0x1d82>
    3d90:	32a010ef          	jal	50ba <printf>
    3d94:	4505                	li	a0,1
    3d96:	6f1000ef          	jal	4c86 <exit>
    3d9a:	8556                	mv	a0,s5
    3d9c:	6eb000ef          	jal	4c86 <exit>
    3da0:	85e6                	mv	a1,s9
    3da2:	00003517          	auipc	a0,0x3
    3da6:	16650513          	addi	a0,a0,358 # 6f08 <malloc+0x1d9a>
    3daa:	310010ef          	jal	50ba <printf>
    3dae:	4505                	li	a0,1
    3db0:	6d7000ef          	jal	4c86 <exit>
    3db4:	00a9093b          	addw	s2,s2,a0
    3db8:	660d                	lui	a2,0x3
    3dba:	85d2                	mv	a1,s4
    3dbc:	854e                	mv	a0,s3
    3dbe:	6e1000ef          	jal	4c9e <read>
    3dc2:	02a05063          	blez	a0,3de2 <fourfiles+0x174>
    3dc6:	00009797          	auipc	a5,0x9
    3dca:	ee278793          	addi	a5,a5,-286 # cca8 <buf>
    3dce:	00f506b3          	add	a3,a0,a5
    3dd2:	0007c703          	lbu	a4,0(a5)
    3dd6:	fc9715e3          	bne	a4,s1,3da0 <fourfiles+0x132>
    3dda:	0785                	addi	a5,a5,1
    3ddc:	fed79be3          	bne	a5,a3,3dd2 <fourfiles+0x164>
    3de0:	bfd1                	j	3db4 <fourfiles+0x146>
    3de2:	854e                	mv	a0,s3
    3de4:	6cb000ef          	jal	4cae <close>
    3de8:	03a91463          	bne	s2,s10,3e10 <fourfiles+0x1a2>
    3dec:	8562                	mv	a0,s8
    3dee:	6e9000ef          	jal	4cd6 <unlink>
    3df2:	0ba1                	addi	s7,s7,8
    3df4:	2b05                	addiw	s6,s6,1
    3df6:	03bb0763          	beq	s6,s11,3e24 <fourfiles+0x1b6>
    3dfa:	000bbc03          	ld	s8,0(s7)
    3dfe:	4581                	li	a1,0
    3e00:	8562                	mv	a0,s8
    3e02:	6c5000ef          	jal	4cc6 <open>
    3e06:	89aa                	mv	s3,a0
    3e08:	8956                	mv	s2,s5
    3e0a:	000b049b          	sext.w	s1,s6
    3e0e:	b76d                	j	3db8 <fourfiles+0x14a>
    3e10:	85ca                	mv	a1,s2
    3e12:	00003517          	auipc	a0,0x3
    3e16:	10650513          	addi	a0,a0,262 # 6f18 <malloc+0x1daa>
    3e1a:	2a0010ef          	jal	50ba <printf>
    3e1e:	4505                	li	a0,1
    3e20:	667000ef          	jal	4c86 <exit>
    3e24:	60ea                	ld	ra,152(sp)
    3e26:	644a                	ld	s0,144(sp)
    3e28:	64aa                	ld	s1,136(sp)
    3e2a:	690a                	ld	s2,128(sp)
    3e2c:	79e6                	ld	s3,120(sp)
    3e2e:	7a46                	ld	s4,112(sp)
    3e30:	7aa6                	ld	s5,104(sp)
    3e32:	7b06                	ld	s6,96(sp)
    3e34:	6be6                	ld	s7,88(sp)
    3e36:	6c46                	ld	s8,80(sp)
    3e38:	6ca6                	ld	s9,72(sp)
    3e3a:	6d06                	ld	s10,64(sp)
    3e3c:	7de2                	ld	s11,56(sp)
    3e3e:	610d                	addi	sp,sp,160
    3e40:	8082                	ret

0000000000003e42 <concreate>:
    3e42:	7135                	addi	sp,sp,-160
    3e44:	ed06                	sd	ra,152(sp)
    3e46:	e922                	sd	s0,144(sp)
    3e48:	e526                	sd	s1,136(sp)
    3e4a:	e14a                	sd	s2,128(sp)
    3e4c:	fcce                	sd	s3,120(sp)
    3e4e:	f8d2                	sd	s4,112(sp)
    3e50:	f4d6                	sd	s5,104(sp)
    3e52:	f0da                	sd	s6,96(sp)
    3e54:	ecde                	sd	s7,88(sp)
    3e56:	1100                	addi	s0,sp,160
    3e58:	89aa                	mv	s3,a0
    3e5a:	04300793          	li	a5,67
    3e5e:	faf40423          	sb	a5,-88(s0)
    3e62:	fa040523          	sb	zero,-86(s0)
    3e66:	4901                	li	s2,0
    3e68:	4b0d                	li	s6,3
    3e6a:	4a85                	li	s5,1
    3e6c:	00003b97          	auipc	s7,0x3
    3e70:	0c4b8b93          	addi	s7,s7,196 # 6f30 <malloc+0x1dc2>
    3e74:	02800a13          	li	s4,40
    3e78:	a41d                	j	409e <concreate+0x25c>
    3e7a:	fa840593          	addi	a1,s0,-88
    3e7e:	855e                	mv	a0,s7
    3e80:	667000ef          	jal	4ce6 <link>
    3e84:	a411                	j	4088 <concreate+0x246>
    3e86:	4795                	li	a5,5
    3e88:	02f9693b          	remw	s2,s2,a5
    3e8c:	4785                	li	a5,1
    3e8e:	02f90563          	beq	s2,a5,3eb8 <concreate+0x76>
    3e92:	20200593          	li	a1,514
    3e96:	fa840513          	addi	a0,s0,-88
    3e9a:	62d000ef          	jal	4cc6 <open>
    3e9e:	1e055063          	bgez	a0,407e <concreate+0x23c>
    3ea2:	fa840593          	addi	a1,s0,-88
    3ea6:	00003517          	auipc	a0,0x3
    3eaa:	09250513          	addi	a0,a0,146 # 6f38 <malloc+0x1dca>
    3eae:	20c010ef          	jal	50ba <printf>
    3eb2:	4505                	li	a0,1
    3eb4:	5d3000ef          	jal	4c86 <exit>
    3eb8:	fa840593          	addi	a1,s0,-88
    3ebc:	00003517          	auipc	a0,0x3
    3ec0:	07450513          	addi	a0,a0,116 # 6f30 <malloc+0x1dc2>
    3ec4:	623000ef          	jal	4ce6 <link>
    3ec8:	4501                	li	a0,0
    3eca:	5bd000ef          	jal	4c86 <exit>
    3ece:	4505                	li	a0,1
    3ed0:	5b7000ef          	jal	4c86 <exit>
    3ed4:	02800613          	li	a2,40
    3ed8:	4581                	li	a1,0
    3eda:	f8040513          	addi	a0,s0,-128
    3ede:	397000ef          	jal	4a74 <memset>
    3ee2:	4581                	li	a1,0
    3ee4:	00002517          	auipc	a0,0x2
    3ee8:	aac50513          	addi	a0,a0,-1364 # 5990 <malloc+0x822>
    3eec:	5db000ef          	jal	4cc6 <open>
    3ef0:	892a                	mv	s2,a0
    3ef2:	8aa6                	mv	s5,s1
    3ef4:	04300a13          	li	s4,67
    3ef8:	02700b13          	li	s6,39
    3efc:	4b85                	li	s7,1
    3efe:	4641                	li	a2,16
    3f00:	f7040593          	addi	a1,s0,-144
    3f04:	854a                	mv	a0,s2
    3f06:	599000ef          	jal	4c9e <read>
    3f0a:	06a05a63          	blez	a0,3f7e <concreate+0x13c>
    3f0e:	f7045783          	lhu	a5,-144(s0)
    3f12:	d7f5                	beqz	a5,3efe <concreate+0xbc>
    3f14:	f7244783          	lbu	a5,-142(s0)
    3f18:	ff4793e3          	bne	a5,s4,3efe <concreate+0xbc>
    3f1c:	f7444783          	lbu	a5,-140(s0)
    3f20:	fff9                	bnez	a5,3efe <concreate+0xbc>
    3f22:	f7344783          	lbu	a5,-141(s0)
    3f26:	fd07879b          	addiw	a5,a5,-48
    3f2a:	0007871b          	sext.w	a4,a5
    3f2e:	02eb6063          	bltu	s6,a4,3f4e <concreate+0x10c>
    3f32:	fb070793          	addi	a5,a4,-80
    3f36:	97a2                	add	a5,a5,s0
    3f38:	fd07c783          	lbu	a5,-48(a5)
    3f3c:	e78d                	bnez	a5,3f66 <concreate+0x124>
    3f3e:	fb070793          	addi	a5,a4,-80
    3f42:	00878733          	add	a4,a5,s0
    3f46:	fd770823          	sb	s7,-48(a4)
    3f4a:	2a85                	addiw	s5,s5,1
    3f4c:	bf4d                	j	3efe <concreate+0xbc>
    3f4e:	f7240613          	addi	a2,s0,-142
    3f52:	85ce                	mv	a1,s3
    3f54:	00003517          	auipc	a0,0x3
    3f58:	00450513          	addi	a0,a0,4 # 6f58 <malloc+0x1dea>
    3f5c:	15e010ef          	jal	50ba <printf>
    3f60:	4505                	li	a0,1
    3f62:	525000ef          	jal	4c86 <exit>
    3f66:	f7240613          	addi	a2,s0,-142
    3f6a:	85ce                	mv	a1,s3
    3f6c:	00003517          	auipc	a0,0x3
    3f70:	00c50513          	addi	a0,a0,12 # 6f78 <malloc+0x1e0a>
    3f74:	146010ef          	jal	50ba <printf>
    3f78:	4505                	li	a0,1
    3f7a:	50d000ef          	jal	4c86 <exit>
    3f7e:	854a                	mv	a0,s2
    3f80:	52f000ef          	jal	4cae <close>
    3f84:	02800793          	li	a5,40
    3f88:	00fa9763          	bne	s5,a5,3f96 <concreate+0x154>
    3f8c:	4a8d                	li	s5,3
    3f8e:	4b05                	li	s6,1
    3f90:	02800a13          	li	s4,40
    3f94:	a079                	j	4022 <concreate+0x1e0>
    3f96:	85ce                	mv	a1,s3
    3f98:	00003517          	auipc	a0,0x3
    3f9c:	00850513          	addi	a0,a0,8 # 6fa0 <malloc+0x1e32>
    3fa0:	11a010ef          	jal	50ba <printf>
    3fa4:	4505                	li	a0,1
    3fa6:	4e1000ef          	jal	4c86 <exit>
    3faa:	85ce                	mv	a1,s3
    3fac:	00002517          	auipc	a0,0x2
    3fb0:	b8c50513          	addi	a0,a0,-1140 # 5b38 <malloc+0x9ca>
    3fb4:	106010ef          	jal	50ba <printf>
    3fb8:	4505                	li	a0,1
    3fba:	4cd000ef          	jal	4c86 <exit>
    3fbe:	4581                	li	a1,0
    3fc0:	fa840513          	addi	a0,s0,-88
    3fc4:	503000ef          	jal	4cc6 <open>
    3fc8:	4e7000ef          	jal	4cae <close>
    3fcc:	4581                	li	a1,0
    3fce:	fa840513          	addi	a0,s0,-88
    3fd2:	4f5000ef          	jal	4cc6 <open>
    3fd6:	4d9000ef          	jal	4cae <close>
    3fda:	4581                	li	a1,0
    3fdc:	fa840513          	addi	a0,s0,-88
    3fe0:	4e7000ef          	jal	4cc6 <open>
    3fe4:	4cb000ef          	jal	4cae <close>
    3fe8:	4581                	li	a1,0
    3fea:	fa840513          	addi	a0,s0,-88
    3fee:	4d9000ef          	jal	4cc6 <open>
    3ff2:	4bd000ef          	jal	4cae <close>
    3ff6:	4581                	li	a1,0
    3ff8:	fa840513          	addi	a0,s0,-88
    3ffc:	4cb000ef          	jal	4cc6 <open>
    4000:	4af000ef          	jal	4cae <close>
    4004:	4581                	li	a1,0
    4006:	fa840513          	addi	a0,s0,-88
    400a:	4bd000ef          	jal	4cc6 <open>
    400e:	4a1000ef          	jal	4cae <close>
    4012:	06090363          	beqz	s2,4078 <concreate+0x236>
    4016:	4501                	li	a0,0
    4018:	477000ef          	jal	4c8e <wait>
    401c:	2485                	addiw	s1,s1,1
    401e:	0b448963          	beq	s1,s4,40d0 <concreate+0x28e>
    4022:	0304879b          	addiw	a5,s1,48
    4026:	faf404a3          	sb	a5,-87(s0)
    402a:	455000ef          	jal	4c7e <fork>
    402e:	892a                	mv	s2,a0
    4030:	f6054de3          	bltz	a0,3faa <concreate+0x168>
    4034:	0354e73b          	remw	a4,s1,s5
    4038:	00a767b3          	or	a5,a4,a0
    403c:	2781                	sext.w	a5,a5
    403e:	d3c1                	beqz	a5,3fbe <concreate+0x17c>
    4040:	01671363          	bne	a4,s6,4046 <concreate+0x204>
    4044:	fd2d                	bnez	a0,3fbe <concreate+0x17c>
    4046:	fa840513          	addi	a0,s0,-88
    404a:	48d000ef          	jal	4cd6 <unlink>
    404e:	fa840513          	addi	a0,s0,-88
    4052:	485000ef          	jal	4cd6 <unlink>
    4056:	fa840513          	addi	a0,s0,-88
    405a:	47d000ef          	jal	4cd6 <unlink>
    405e:	fa840513          	addi	a0,s0,-88
    4062:	475000ef          	jal	4cd6 <unlink>
    4066:	fa840513          	addi	a0,s0,-88
    406a:	46d000ef          	jal	4cd6 <unlink>
    406e:	fa840513          	addi	a0,s0,-88
    4072:	465000ef          	jal	4cd6 <unlink>
    4076:	bf71                	j	4012 <concreate+0x1d0>
    4078:	4501                	li	a0,0
    407a:	40d000ef          	jal	4c86 <exit>
    407e:	431000ef          	jal	4cae <close>
    4082:	b599                	j	3ec8 <concreate+0x86>
    4084:	42b000ef          	jal	4cae <close>
    4088:	f6c40513          	addi	a0,s0,-148
    408c:	403000ef          	jal	4c8e <wait>
    4090:	f6c42483          	lw	s1,-148(s0)
    4094:	e2049de3          	bnez	s1,3ece <concreate+0x8c>
    4098:	2905                	addiw	s2,s2,1
    409a:	e3490de3          	beq	s2,s4,3ed4 <concreate+0x92>
    409e:	0309079b          	addiw	a5,s2,48
    40a2:	faf404a3          	sb	a5,-87(s0)
    40a6:	fa840513          	addi	a0,s0,-88
    40aa:	42d000ef          	jal	4cd6 <unlink>
    40ae:	3d1000ef          	jal	4c7e <fork>
    40b2:	dc050ae3          	beqz	a0,3e86 <concreate+0x44>
    40b6:	036967bb          	remw	a5,s2,s6
    40ba:	dd5780e3          	beq	a5,s5,3e7a <concreate+0x38>
    40be:	20200593          	li	a1,514
    40c2:	fa840513          	addi	a0,s0,-88
    40c6:	401000ef          	jal	4cc6 <open>
    40ca:	fa055de3          	bgez	a0,4084 <concreate+0x242>
    40ce:	bbd1                	j	3ea2 <concreate+0x60>
    40d0:	60ea                	ld	ra,152(sp)
    40d2:	644a                	ld	s0,144(sp)
    40d4:	64aa                	ld	s1,136(sp)
    40d6:	690a                	ld	s2,128(sp)
    40d8:	79e6                	ld	s3,120(sp)
    40da:	7a46                	ld	s4,112(sp)
    40dc:	7aa6                	ld	s5,104(sp)
    40de:	7b06                	ld	s6,96(sp)
    40e0:	6be6                	ld	s7,88(sp)
    40e2:	610d                	addi	sp,sp,160
    40e4:	8082                	ret

00000000000040e6 <bigfile>:
    40e6:	7139                	addi	sp,sp,-64
    40e8:	fc06                	sd	ra,56(sp)
    40ea:	f822                	sd	s0,48(sp)
    40ec:	f426                	sd	s1,40(sp)
    40ee:	f04a                	sd	s2,32(sp)
    40f0:	ec4e                	sd	s3,24(sp)
    40f2:	e852                	sd	s4,16(sp)
    40f4:	e456                	sd	s5,8(sp)
    40f6:	0080                	addi	s0,sp,64
    40f8:	8aaa                	mv	s5,a0
    40fa:	00003517          	auipc	a0,0x3
    40fe:	ede50513          	addi	a0,a0,-290 # 6fd8 <malloc+0x1e6a>
    4102:	3d5000ef          	jal	4cd6 <unlink>
    4106:	20200593          	li	a1,514
    410a:	00003517          	auipc	a0,0x3
    410e:	ece50513          	addi	a0,a0,-306 # 6fd8 <malloc+0x1e6a>
    4112:	3b5000ef          	jal	4cc6 <open>
    4116:	89aa                	mv	s3,a0
    4118:	4481                	li	s1,0
    411a:	00009917          	auipc	s2,0x9
    411e:	b8e90913          	addi	s2,s2,-1138 # cca8 <buf>
    4122:	4a51                	li	s4,20
    4124:	08054663          	bltz	a0,41b0 <bigfile+0xca>
    4128:	25800613          	li	a2,600
    412c:	85a6                	mv	a1,s1
    412e:	854a                	mv	a0,s2
    4130:	145000ef          	jal	4a74 <memset>
    4134:	25800613          	li	a2,600
    4138:	85ca                	mv	a1,s2
    413a:	854e                	mv	a0,s3
    413c:	36b000ef          	jal	4ca6 <write>
    4140:	25800793          	li	a5,600
    4144:	08f51063          	bne	a0,a5,41c4 <bigfile+0xde>
    4148:	2485                	addiw	s1,s1,1
    414a:	fd449fe3          	bne	s1,s4,4128 <bigfile+0x42>
    414e:	854e                	mv	a0,s3
    4150:	35f000ef          	jal	4cae <close>
    4154:	4581                	li	a1,0
    4156:	00003517          	auipc	a0,0x3
    415a:	e8250513          	addi	a0,a0,-382 # 6fd8 <malloc+0x1e6a>
    415e:	369000ef          	jal	4cc6 <open>
    4162:	8a2a                	mv	s4,a0
    4164:	4981                	li	s3,0
    4166:	4481                	li	s1,0
    4168:	00009917          	auipc	s2,0x9
    416c:	b4090913          	addi	s2,s2,-1216 # cca8 <buf>
    4170:	06054463          	bltz	a0,41d8 <bigfile+0xf2>
    4174:	12c00613          	li	a2,300
    4178:	85ca                	mv	a1,s2
    417a:	8552                	mv	a0,s4
    417c:	323000ef          	jal	4c9e <read>
    4180:	06054663          	bltz	a0,41ec <bigfile+0x106>
    4184:	c155                	beqz	a0,4228 <bigfile+0x142>
    4186:	12c00793          	li	a5,300
    418a:	06f51b63          	bne	a0,a5,4200 <bigfile+0x11a>
    418e:	01f4d79b          	srliw	a5,s1,0x1f
    4192:	9fa5                	addw	a5,a5,s1
    4194:	4017d79b          	sraiw	a5,a5,0x1
    4198:	00094703          	lbu	a4,0(s2)
    419c:	06f71c63          	bne	a4,a5,4214 <bigfile+0x12e>
    41a0:	12b94703          	lbu	a4,299(s2)
    41a4:	06f71863          	bne	a4,a5,4214 <bigfile+0x12e>
    41a8:	12c9899b          	addiw	s3,s3,300
    41ac:	2485                	addiw	s1,s1,1
    41ae:	b7d9                	j	4174 <bigfile+0x8e>
    41b0:	85d6                	mv	a1,s5
    41b2:	00003517          	auipc	a0,0x3
    41b6:	e3650513          	addi	a0,a0,-458 # 6fe8 <malloc+0x1e7a>
    41ba:	701000ef          	jal	50ba <printf>
    41be:	4505                	li	a0,1
    41c0:	2c7000ef          	jal	4c86 <exit>
    41c4:	85d6                	mv	a1,s5
    41c6:	00003517          	auipc	a0,0x3
    41ca:	e4250513          	addi	a0,a0,-446 # 7008 <malloc+0x1e9a>
    41ce:	6ed000ef          	jal	50ba <printf>
    41d2:	4505                	li	a0,1
    41d4:	2b3000ef          	jal	4c86 <exit>
    41d8:	85d6                	mv	a1,s5
    41da:	00003517          	auipc	a0,0x3
    41de:	e4e50513          	addi	a0,a0,-434 # 7028 <malloc+0x1eba>
    41e2:	6d9000ef          	jal	50ba <printf>
    41e6:	4505                	li	a0,1
    41e8:	29f000ef          	jal	4c86 <exit>
    41ec:	85d6                	mv	a1,s5
    41ee:	00003517          	auipc	a0,0x3
    41f2:	e5a50513          	addi	a0,a0,-422 # 7048 <malloc+0x1eda>
    41f6:	6c5000ef          	jal	50ba <printf>
    41fa:	4505                	li	a0,1
    41fc:	28b000ef          	jal	4c86 <exit>
    4200:	85d6                	mv	a1,s5
    4202:	00003517          	auipc	a0,0x3
    4206:	e6650513          	addi	a0,a0,-410 # 7068 <malloc+0x1efa>
    420a:	6b1000ef          	jal	50ba <printf>
    420e:	4505                	li	a0,1
    4210:	277000ef          	jal	4c86 <exit>
    4214:	85d6                	mv	a1,s5
    4216:	00003517          	auipc	a0,0x3
    421a:	e6a50513          	addi	a0,a0,-406 # 7080 <malloc+0x1f12>
    421e:	69d000ef          	jal	50ba <printf>
    4222:	4505                	li	a0,1
    4224:	263000ef          	jal	4c86 <exit>
    4228:	8552                	mv	a0,s4
    422a:	285000ef          	jal	4cae <close>
    422e:	678d                	lui	a5,0x3
    4230:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x31e>
    4234:	02f99163          	bne	s3,a5,4256 <bigfile+0x170>
    4238:	00003517          	auipc	a0,0x3
    423c:	da050513          	addi	a0,a0,-608 # 6fd8 <malloc+0x1e6a>
    4240:	297000ef          	jal	4cd6 <unlink>
    4244:	70e2                	ld	ra,56(sp)
    4246:	7442                	ld	s0,48(sp)
    4248:	74a2                	ld	s1,40(sp)
    424a:	7902                	ld	s2,32(sp)
    424c:	69e2                	ld	s3,24(sp)
    424e:	6a42                	ld	s4,16(sp)
    4250:	6aa2                	ld	s5,8(sp)
    4252:	6121                	addi	sp,sp,64
    4254:	8082                	ret
    4256:	85d6                	mv	a1,s5
    4258:	00003517          	auipc	a0,0x3
    425c:	e4850513          	addi	a0,a0,-440 # 70a0 <malloc+0x1f32>
    4260:	65b000ef          	jal	50ba <printf>
    4264:	4505                	li	a0,1
    4266:	221000ef          	jal	4c86 <exit>

000000000000426a <bigargtest>:
    426a:	7121                	addi	sp,sp,-448
    426c:	ff06                	sd	ra,440(sp)
    426e:	fb22                	sd	s0,432(sp)
    4270:	f726                	sd	s1,424(sp)
    4272:	0380                	addi	s0,sp,448
    4274:	84aa                	mv	s1,a0
    4276:	00003517          	auipc	a0,0x3
    427a:	e4a50513          	addi	a0,a0,-438 # 70c0 <malloc+0x1f52>
    427e:	259000ef          	jal	4cd6 <unlink>
    4282:	1fd000ef          	jal	4c7e <fork>
    4286:	c915                	beqz	a0,42ba <bigargtest+0x50>
    4288:	08054a63          	bltz	a0,431c <bigargtest+0xb2>
    428c:	fdc40513          	addi	a0,s0,-36
    4290:	1ff000ef          	jal	4c8e <wait>
    4294:	fdc42503          	lw	a0,-36(s0)
    4298:	ed41                	bnez	a0,4330 <bigargtest+0xc6>
    429a:	4581                	li	a1,0
    429c:	00003517          	auipc	a0,0x3
    42a0:	e2450513          	addi	a0,a0,-476 # 70c0 <malloc+0x1f52>
    42a4:	223000ef          	jal	4cc6 <open>
    42a8:	08054663          	bltz	a0,4334 <bigargtest+0xca>
    42ac:	203000ef          	jal	4cae <close>
    42b0:	70fa                	ld	ra,440(sp)
    42b2:	745a                	ld	s0,432(sp)
    42b4:	74ba                	ld	s1,424(sp)
    42b6:	6139                	addi	sp,sp,448
    42b8:	8082                	ret
    42ba:	19000613          	li	a2,400
    42be:	02000593          	li	a1,32
    42c2:	e4840513          	addi	a0,s0,-440
    42c6:	7ae000ef          	jal	4a74 <memset>
    42ca:	fc040ba3          	sb	zero,-41(s0)
    42ce:	00005797          	auipc	a5,0x5
    42d2:	1c278793          	addi	a5,a5,450 # 9490 <args.1>
    42d6:	00005697          	auipc	a3,0x5
    42da:	2b268693          	addi	a3,a3,690 # 9588 <args.1+0xf8>
    42de:	e4840713          	addi	a4,s0,-440
    42e2:	e398                	sd	a4,0(a5)
    42e4:	07a1                	addi	a5,a5,8
    42e6:	fed79ee3          	bne	a5,a3,42e2 <bigargtest+0x78>
    42ea:	00005597          	auipc	a1,0x5
    42ee:	1a658593          	addi	a1,a1,422 # 9490 <args.1>
    42f2:	0e05bc23          	sd	zero,248(a1)
    42f6:	00001517          	auipc	a0,0x1
    42fa:	fb250513          	addi	a0,a0,-78 # 52a8 <malloc+0x13a>
    42fe:	1c1000ef          	jal	4cbe <exec>
    4302:	20000593          	li	a1,512
    4306:	00003517          	auipc	a0,0x3
    430a:	dba50513          	addi	a0,a0,-582 # 70c0 <malloc+0x1f52>
    430e:	1b9000ef          	jal	4cc6 <open>
    4312:	19d000ef          	jal	4cae <close>
    4316:	4501                	li	a0,0
    4318:	16f000ef          	jal	4c86 <exit>
    431c:	85a6                	mv	a1,s1
    431e:	00003517          	auipc	a0,0x3
    4322:	db250513          	addi	a0,a0,-590 # 70d0 <malloc+0x1f62>
    4326:	595000ef          	jal	50ba <printf>
    432a:	4505                	li	a0,1
    432c:	15b000ef          	jal	4c86 <exit>
    4330:	157000ef          	jal	4c86 <exit>
    4334:	85a6                	mv	a1,s1
    4336:	00003517          	auipc	a0,0x3
    433a:	dba50513          	addi	a0,a0,-582 # 70f0 <malloc+0x1f82>
    433e:	57d000ef          	jal	50ba <printf>
    4342:	4505                	li	a0,1
    4344:	143000ef          	jal	4c86 <exit>

0000000000004348 <lazy_alloc>:
    4348:	1141                	addi	sp,sp,-16
    434a:	e406                	sd	ra,8(sp)
    434c:	e022                	sd	s0,0(sp)
    434e:	0800                	addi	s0,sp,16
    4350:	40000537          	lui	a0,0x40000
    4354:	115000ef          	jal	4c68 <sbrklazy>
    4358:	57fd                	li	a5,-1
    435a:	02f50a63          	beq	a0,a5,438e <lazy_alloc+0x46>
    435e:	6605                	lui	a2,0x1
    4360:	962a                	add	a2,a2,a0
    4362:	400017b7          	lui	a5,0x40001
    4366:	00f50733          	add	a4,a0,a5
    436a:	87b2                	mv	a5,a2
    436c:	000406b7          	lui	a3,0x40
    4370:	e39c                	sd	a5,0(a5)
    4372:	97b6                	add	a5,a5,a3
    4374:	fee79ee3          	bne	a5,a4,4370 <lazy_alloc+0x28>
    4378:	000406b7          	lui	a3,0x40
    437c:	621c                	ld	a5,0(a2)
    437e:	02c79163          	bne	a5,a2,43a0 <lazy_alloc+0x58>
    4382:	9636                	add	a2,a2,a3
    4384:	fee61ce3          	bne	a2,a4,437c <lazy_alloc+0x34>
    4388:	4501                	li	a0,0
    438a:	0fd000ef          	jal	4c86 <exit>
    438e:	00003517          	auipc	a0,0x3
    4392:	d8250513          	addi	a0,a0,-638 # 7110 <malloc+0x1fa2>
    4396:	525000ef          	jal	50ba <printf>
    439a:	4505                	li	a0,1
    439c:	0eb000ef          	jal	4c86 <exit>
    43a0:	00003517          	auipc	a0,0x3
    43a4:	d8850513          	addi	a0,a0,-632 # 7128 <malloc+0x1fba>
    43a8:	513000ef          	jal	50ba <printf>
    43ac:	4505                	li	a0,1
    43ae:	0d9000ef          	jal	4c86 <exit>

00000000000043b2 <lazy_unmap>:
    43b2:	7139                	addi	sp,sp,-64
    43b4:	fc06                	sd	ra,56(sp)
    43b6:	f822                	sd	s0,48(sp)
    43b8:	0080                	addi	s0,sp,64
    43ba:	40000537          	lui	a0,0x40000
    43be:	0ab000ef          	jal	4c68 <sbrklazy>
    43c2:	57fd                	li	a5,-1
    43c4:	04f50663          	beq	a0,a5,4410 <lazy_unmap+0x5e>
    43c8:	f426                	sd	s1,40(sp)
    43ca:	f04a                	sd	s2,32(sp)
    43cc:	ec4e                	sd	s3,24(sp)
    43ce:	6905                	lui	s2,0x1
    43d0:	992a                	add	s2,s2,a0
    43d2:	400017b7          	lui	a5,0x40001
    43d6:	00f504b3          	add	s1,a0,a5
    43da:	87ca                	mv	a5,s2
    43dc:	01000737          	lui	a4,0x1000
    43e0:	e39c                	sd	a5,0(a5)
    43e2:	97ba                	add	a5,a5,a4
    43e4:	fe979ee3          	bne	a5,s1,43e0 <lazy_unmap+0x2e>
    43e8:	010009b7          	lui	s3,0x1000
    43ec:	093000ef          	jal	4c7e <fork>
    43f0:	02054c63          	bltz	a0,4428 <lazy_unmap+0x76>
    43f4:	c139                	beqz	a0,443a <lazy_unmap+0x88>
    43f6:	fcc40513          	addi	a0,s0,-52
    43fa:	095000ef          	jal	4c8e <wait>
    43fe:	fcc42783          	lw	a5,-52(s0)
    4402:	c7a9                	beqz	a5,444c <lazy_unmap+0x9a>
    4404:	994e                	add	s2,s2,s3
    4406:	fe9913e3          	bne	s2,s1,43ec <lazy_unmap+0x3a>
    440a:	4501                	li	a0,0
    440c:	07b000ef          	jal	4c86 <exit>
    4410:	f426                	sd	s1,40(sp)
    4412:	f04a                	sd	s2,32(sp)
    4414:	ec4e                	sd	s3,24(sp)
    4416:	00003517          	auipc	a0,0x3
    441a:	cfa50513          	addi	a0,a0,-774 # 7110 <malloc+0x1fa2>
    441e:	49d000ef          	jal	50ba <printf>
    4422:	4505                	li	a0,1
    4424:	063000ef          	jal	4c86 <exit>
    4428:	00003517          	auipc	a0,0x3
    442c:	d2850513          	addi	a0,a0,-728 # 7150 <malloc+0x1fe2>
    4430:	48b000ef          	jal	50ba <printf>
    4434:	4505                	li	a0,1
    4436:	051000ef          	jal	4c86 <exit>
    443a:	c0000537          	lui	a0,0xc0000
    443e:	02b000ef          	jal	4c68 <sbrklazy>
    4442:	01293023          	sd	s2,0(s2) # 1000 <badarg>
    4446:	4501                	li	a0,0
    4448:	03f000ef          	jal	4c86 <exit>
    444c:	00003517          	auipc	a0,0x3
    4450:	d1450513          	addi	a0,a0,-748 # 7160 <malloc+0x1ff2>
    4454:	467000ef          	jal	50ba <printf>
    4458:	4505                	li	a0,1
    445a:	02d000ef          	jal	4c86 <exit>

000000000000445e <lazy_copy>:
    445e:	7159                	addi	sp,sp,-112
    4460:	f486                	sd	ra,104(sp)
    4462:	f0a2                	sd	s0,96(sp)
    4464:	eca6                	sd	s1,88(sp)
    4466:	e8ca                	sd	s2,80(sp)
    4468:	e4ce                	sd	s3,72(sp)
    446a:	e0d2                	sd	s4,64(sp)
    446c:	fc56                	sd	s5,56(sp)
    446e:	f85a                	sd	s6,48(sp)
    4470:	1880                	addi	s0,sp,112
    4472:	4501                	li	a0,0
    4474:	7de000ef          	jal	4c52 <sbrk>
    4478:	84aa                	mv	s1,a0
    447a:	6511                	lui	a0,0x4
    447c:	7ec000ef          	jal	4c68 <sbrklazy>
    4480:	4581                	li	a1,0
    4482:	6509                	lui	a0,0x2
    4484:	9526                	add	a0,a0,s1
    4486:	041000ef          	jal	4cc6 <open>
    448a:	4501                	li	a0,0
    448c:	7c6000ef          	jal	4c52 <sbrk>
    4490:	84aa                	mv	s1,a0
    4492:	fff54513          	not	a0,a0
    4496:	2501                	sext.w	a0,a0
    4498:	7ba000ef          	jal	4c52 <sbrk>
    449c:	00a48c63          	beq	s1,a0,44b4 <lazy_copy+0x56>
    44a0:	85aa                	mv	a1,a0
    44a2:	00003517          	auipc	a0,0x3
    44a6:	cd650513          	addi	a0,a0,-810 # 7178 <malloc+0x200a>
    44aa:	411000ef          	jal	50ba <printf>
    44ae:	4505                	li	a0,1
    44b0:	7d6000ef          	jal	4c86 <exit>
    44b4:	00003797          	auipc	a5,0x3
    44b8:	24478793          	addi	a5,a5,580 # 76f8 <malloc+0x258a>
    44bc:	7fa8                	ld	a0,120(a5)
    44be:	63cc                	ld	a1,128(a5)
    44c0:	67d0                	ld	a2,136(a5)
    44c2:	6bd4                	ld	a3,144(a5)
    44c4:	6fd8                	ld	a4,152(a5)
    44c6:	73dc                	ld	a5,160(a5)
    44c8:	f8a43823          	sd	a0,-112(s0)
    44cc:	f8b43c23          	sd	a1,-104(s0)
    44d0:	fac43023          	sd	a2,-96(s0)
    44d4:	fad43423          	sd	a3,-88(s0)
    44d8:	fae43823          	sd	a4,-80(s0)
    44dc:	faf43c23          	sd	a5,-72(s0)
    44e0:	f9040913          	addi	s2,s0,-112
    44e4:	fc040b13          	addi	s6,s0,-64
    44e8:	00001a17          	auipc	s4,0x1
    44ec:	f98a0a13          	addi	s4,s4,-104 # 5480 <malloc+0x312>
    44f0:	00001a97          	auipc	s5,0x1
    44f4:	ea0a8a93          	addi	s5,s5,-352 # 5390 <malloc+0x222>
    44f8:	4581                	li	a1,0
    44fa:	8552                	mv	a0,s4
    44fc:	7ca000ef          	jal	4cc6 <open>
    4500:	84aa                	mv	s1,a0
    4502:	04054663          	bltz	a0,454e <lazy_copy+0xf0>
    4506:	00093983          	ld	s3,0(s2)
    450a:	20000613          	li	a2,512
    450e:	85ce                	mv	a1,s3
    4510:	78e000ef          	jal	4c9e <read>
    4514:	04055663          	bgez	a0,4560 <lazy_copy+0x102>
    4518:	8526                	mv	a0,s1
    451a:	794000ef          	jal	4cae <close>
    451e:	60200593          	li	a1,1538
    4522:	8556                	mv	a0,s5
    4524:	7a2000ef          	jal	4cc6 <open>
    4528:	84aa                	mv	s1,a0
    452a:	04054463          	bltz	a0,4572 <lazy_copy+0x114>
    452e:	20000613          	li	a2,512
    4532:	85ce                	mv	a1,s3
    4534:	772000ef          	jal	4ca6 <write>
    4538:	04055663          	bgez	a0,4584 <lazy_copy+0x126>
    453c:	8526                	mv	a0,s1
    453e:	770000ef          	jal	4cae <close>
    4542:	0921                	addi	s2,s2,8
    4544:	fb691ae3          	bne	s2,s6,44f8 <lazy_copy+0x9a>
    4548:	4501                	li	a0,0
    454a:	73c000ef          	jal	4c86 <exit>
    454e:	00003517          	auipc	a0,0x3
    4552:	c5a50513          	addi	a0,a0,-934 # 71a8 <malloc+0x203a>
    4556:	365000ef          	jal	50ba <printf>
    455a:	4505                	li	a0,1
    455c:	72a000ef          	jal	4c86 <exit>
    4560:	00003517          	auipc	a0,0x3
    4564:	c6050513          	addi	a0,a0,-928 # 71c0 <malloc+0x2052>
    4568:	353000ef          	jal	50ba <printf>
    456c:	4505                	li	a0,1
    456e:	718000ef          	jal	4c86 <exit>
    4572:	00003517          	auipc	a0,0x3
    4576:	c5e50513          	addi	a0,a0,-930 # 71d0 <malloc+0x2062>
    457a:	341000ef          	jal	50ba <printf>
    457e:	4505                	li	a0,1
    4580:	706000ef          	jal	4c86 <exit>
    4584:	00003517          	auipc	a0,0x3
    4588:	c6450513          	addi	a0,a0,-924 # 71e8 <malloc+0x207a>
    458c:	32f000ef          	jal	50ba <printf>
    4590:	4505                	li	a0,1
    4592:	6f4000ef          	jal	4c86 <exit>

0000000000004596 <fsfull>:
    4596:	7135                	addi	sp,sp,-160
    4598:	ed06                	sd	ra,152(sp)
    459a:	e922                	sd	s0,144(sp)
    459c:	e526                	sd	s1,136(sp)
    459e:	e14a                	sd	s2,128(sp)
    45a0:	fcce                	sd	s3,120(sp)
    45a2:	f8d2                	sd	s4,112(sp)
    45a4:	f4d6                	sd	s5,104(sp)
    45a6:	f0da                	sd	s6,96(sp)
    45a8:	ecde                	sd	s7,88(sp)
    45aa:	e8e2                	sd	s8,80(sp)
    45ac:	e4e6                	sd	s9,72(sp)
    45ae:	e0ea                	sd	s10,64(sp)
    45b0:	1100                	addi	s0,sp,160
    45b2:	00003517          	auipc	a0,0x3
    45b6:	c4e50513          	addi	a0,a0,-946 # 7200 <malloc+0x2092>
    45ba:	301000ef          	jal	50ba <printf>
    45be:	4481                	li	s1,0
    45c0:	06600d13          	li	s10,102
    45c4:	3e800c13          	li	s8,1000
    45c8:	06400b93          	li	s7,100
    45cc:	4b29                	li	s6,10
    45ce:	00003c97          	auipc	s9,0x3
    45d2:	c42c8c93          	addi	s9,s9,-958 # 7210 <malloc+0x20a2>
    45d6:	f7a40023          	sb	s10,-160(s0)
    45da:	0384c7bb          	divw	a5,s1,s8
    45de:	0307879b          	addiw	a5,a5,48
    45e2:	f6f400a3          	sb	a5,-159(s0)
    45e6:	0384e7bb          	remw	a5,s1,s8
    45ea:	0377c7bb          	divw	a5,a5,s7
    45ee:	0307879b          	addiw	a5,a5,48
    45f2:	f6f40123          	sb	a5,-158(s0)
    45f6:	0374e7bb          	remw	a5,s1,s7
    45fa:	0367c7bb          	divw	a5,a5,s6
    45fe:	0307879b          	addiw	a5,a5,48
    4602:	f6f401a3          	sb	a5,-157(s0)
    4606:	0364e7bb          	remw	a5,s1,s6
    460a:	0307879b          	addiw	a5,a5,48
    460e:	f6f40223          	sb	a5,-156(s0)
    4612:	f60402a3          	sb	zero,-155(s0)
    4616:	f6040593          	addi	a1,s0,-160
    461a:	8566                	mv	a0,s9
    461c:	29f000ef          	jal	50ba <printf>
    4620:	20200593          	li	a1,514
    4624:	f6040513          	addi	a0,s0,-160
    4628:	69e000ef          	jal	4cc6 <open>
    462c:	892a                	mv	s2,a0
    462e:	08055f63          	bgez	a0,46cc <fsfull+0x136>
    4632:	f6040593          	addi	a1,s0,-160
    4636:	00003517          	auipc	a0,0x3
    463a:	bea50513          	addi	a0,a0,-1046 # 7220 <malloc+0x20b2>
    463e:	27d000ef          	jal	50ba <printf>
    4642:	0604c163          	bltz	s1,46a4 <fsfull+0x10e>
    4646:	06600b13          	li	s6,102
    464a:	3e800a13          	li	s4,1000
    464e:	06400993          	li	s3,100
    4652:	4929                	li	s2,10
    4654:	5afd                	li	s5,-1
    4656:	f7640023          	sb	s6,-160(s0)
    465a:	0344c7bb          	divw	a5,s1,s4
    465e:	0307879b          	addiw	a5,a5,48
    4662:	f6f400a3          	sb	a5,-159(s0)
    4666:	0344e7bb          	remw	a5,s1,s4
    466a:	0337c7bb          	divw	a5,a5,s3
    466e:	0307879b          	addiw	a5,a5,48
    4672:	f6f40123          	sb	a5,-158(s0)
    4676:	0334e7bb          	remw	a5,s1,s3
    467a:	0327c7bb          	divw	a5,a5,s2
    467e:	0307879b          	addiw	a5,a5,48
    4682:	f6f401a3          	sb	a5,-157(s0)
    4686:	0324e7bb          	remw	a5,s1,s2
    468a:	0307879b          	addiw	a5,a5,48
    468e:	f6f40223          	sb	a5,-156(s0)
    4692:	f60402a3          	sb	zero,-155(s0)
    4696:	f6040513          	addi	a0,s0,-160
    469a:	63c000ef          	jal	4cd6 <unlink>
    469e:	34fd                	addiw	s1,s1,-1
    46a0:	fb549be3          	bne	s1,s5,4656 <fsfull+0xc0>
    46a4:	00003517          	auipc	a0,0x3
    46a8:	b9c50513          	addi	a0,a0,-1124 # 7240 <malloc+0x20d2>
    46ac:	20f000ef          	jal	50ba <printf>
    46b0:	60ea                	ld	ra,152(sp)
    46b2:	644a                	ld	s0,144(sp)
    46b4:	64aa                	ld	s1,136(sp)
    46b6:	690a                	ld	s2,128(sp)
    46b8:	79e6                	ld	s3,120(sp)
    46ba:	7a46                	ld	s4,112(sp)
    46bc:	7aa6                	ld	s5,104(sp)
    46be:	7b06                	ld	s6,96(sp)
    46c0:	6be6                	ld	s7,88(sp)
    46c2:	6c46                	ld	s8,80(sp)
    46c4:	6ca6                	ld	s9,72(sp)
    46c6:	6d06                	ld	s10,64(sp)
    46c8:	610d                	addi	sp,sp,160
    46ca:	8082                	ret
    46cc:	4981                	li	s3,0
    46ce:	00008a97          	auipc	s5,0x8
    46d2:	5daa8a93          	addi	s5,s5,1498 # cca8 <buf>
    46d6:	3ff00a13          	li	s4,1023
    46da:	40000613          	li	a2,1024
    46de:	85d6                	mv	a1,s5
    46e0:	854a                	mv	a0,s2
    46e2:	5c4000ef          	jal	4ca6 <write>
    46e6:	00aa5563          	bge	s4,a0,46f0 <fsfull+0x15a>
    46ea:	00a989bb          	addw	s3,s3,a0
    46ee:	b7f5                	j	46da <fsfull+0x144>
    46f0:	85ce                	mv	a1,s3
    46f2:	00003517          	auipc	a0,0x3
    46f6:	b3e50513          	addi	a0,a0,-1218 # 7230 <malloc+0x20c2>
    46fa:	1c1000ef          	jal	50ba <printf>
    46fe:	854a                	mv	a0,s2
    4700:	5ae000ef          	jal	4cae <close>
    4704:	f2098fe3          	beqz	s3,4642 <fsfull+0xac>
    4708:	2485                	addiw	s1,s1,1
    470a:	b5f1                	j	45d6 <fsfull+0x40>

000000000000470c <run>:
    470c:	7179                	addi	sp,sp,-48
    470e:	f406                	sd	ra,40(sp)
    4710:	f022                	sd	s0,32(sp)
    4712:	ec26                	sd	s1,24(sp)
    4714:	e84a                	sd	s2,16(sp)
    4716:	1800                	addi	s0,sp,48
    4718:	84aa                	mv	s1,a0
    471a:	892e                	mv	s2,a1
    471c:	00003517          	auipc	a0,0x3
    4720:	b3c50513          	addi	a0,a0,-1220 # 7258 <malloc+0x20ea>
    4724:	197000ef          	jal	50ba <printf>
    4728:	556000ef          	jal	4c7e <fork>
    472c:	02054a63          	bltz	a0,4760 <run+0x54>
    4730:	c129                	beqz	a0,4772 <run+0x66>
    4732:	fdc40513          	addi	a0,s0,-36
    4736:	558000ef          	jal	4c8e <wait>
    473a:	fdc42783          	lw	a5,-36(s0)
    473e:	cf9d                	beqz	a5,477c <run+0x70>
    4740:	00003517          	auipc	a0,0x3
    4744:	b4050513          	addi	a0,a0,-1216 # 7280 <malloc+0x2112>
    4748:	173000ef          	jal	50ba <printf>
    474c:	fdc42503          	lw	a0,-36(s0)
    4750:	00153513          	seqz	a0,a0
    4754:	70a2                	ld	ra,40(sp)
    4756:	7402                	ld	s0,32(sp)
    4758:	64e2                	ld	s1,24(sp)
    475a:	6942                	ld	s2,16(sp)
    475c:	6145                	addi	sp,sp,48
    475e:	8082                	ret
    4760:	00003517          	auipc	a0,0x3
    4764:	b0850513          	addi	a0,a0,-1272 # 7268 <malloc+0x20fa>
    4768:	153000ef          	jal	50ba <printf>
    476c:	4505                	li	a0,1
    476e:	518000ef          	jal	4c86 <exit>
    4772:	854a                	mv	a0,s2
    4774:	9482                	jalr	s1
    4776:	4501                	li	a0,0
    4778:	50e000ef          	jal	4c86 <exit>
    477c:	00003517          	auipc	a0,0x3
    4780:	b0c50513          	addi	a0,a0,-1268 # 7288 <malloc+0x211a>
    4784:	137000ef          	jal	50ba <printf>
    4788:	b7d1                	j	474c <run+0x40>

000000000000478a <runtests>:
    478a:	7139                	addi	sp,sp,-64
    478c:	fc06                	sd	ra,56(sp)
    478e:	f822                	sd	s0,48(sp)
    4790:	f426                	sd	s1,40(sp)
    4792:	ec4e                	sd	s3,24(sp)
    4794:	0080                	addi	s0,sp,64
    4796:	84aa                	mv	s1,a0
    4798:	6508                	ld	a0,8(a0)
    479a:	cd39                	beqz	a0,47f8 <runtests+0x6e>
    479c:	f04a                	sd	s2,32(sp)
    479e:	e852                	sd	s4,16(sp)
    47a0:	e456                	sd	s5,8(sp)
    47a2:	892e                	mv	s2,a1
    47a4:	8a32                	mv	s4,a2
    47a6:	4981                	li	s3,0
    47a8:	4a89                	li	s5,2
    47aa:	a021                	j	47b2 <runtests+0x28>
    47ac:	04c1                	addi	s1,s1,16
    47ae:	6488                	ld	a0,8(s1)
    47b0:	c915                	beqz	a0,47e4 <runtests+0x5a>
    47b2:	00090663          	beqz	s2,47be <runtests+0x34>
    47b6:	85ca                	mv	a1,s2
    47b8:	266000ef          	jal	4a1e <strcmp>
    47bc:	f965                	bnez	a0,47ac <runtests+0x22>
    47be:	2985                	addiw	s3,s3,1 # 1000001 <base+0xff0359>
    47c0:	648c                	ld	a1,8(s1)
    47c2:	6088                	ld	a0,0(s1)
    47c4:	f49ff0ef          	jal	470c <run>
    47c8:	f175                	bnez	a0,47ac <runtests+0x22>
    47ca:	ff5a01e3          	beq	s4,s5,47ac <runtests+0x22>
    47ce:	00003517          	auipc	a0,0x3
    47d2:	ac250513          	addi	a0,a0,-1342 # 7290 <malloc+0x2122>
    47d6:	0e5000ef          	jal	50ba <printf>
    47da:	59fd                	li	s3,-1
    47dc:	7902                	ld	s2,32(sp)
    47de:	6a42                	ld	s4,16(sp)
    47e0:	6aa2                	ld	s5,8(sp)
    47e2:	a021                	j	47ea <runtests+0x60>
    47e4:	7902                	ld	s2,32(sp)
    47e6:	6a42                	ld	s4,16(sp)
    47e8:	6aa2                	ld	s5,8(sp)
    47ea:	854e                	mv	a0,s3
    47ec:	70e2                	ld	ra,56(sp)
    47ee:	7442                	ld	s0,48(sp)
    47f0:	74a2                	ld	s1,40(sp)
    47f2:	69e2                	ld	s3,24(sp)
    47f4:	6121                	addi	sp,sp,64
    47f6:	8082                	ret
    47f8:	4981                	li	s3,0
    47fa:	bfc5                	j	47ea <runtests+0x60>

00000000000047fc <countfree>:
    47fc:	7179                	addi	sp,sp,-48
    47fe:	f406                	sd	ra,40(sp)
    4800:	f022                	sd	s0,32(sp)
    4802:	ec26                	sd	s1,24(sp)
    4804:	e84a                	sd	s2,16(sp)
    4806:	e44e                	sd	s3,8(sp)
    4808:	1800                	addi	s0,sp,48
    480a:	4501                	li	a0,0
    480c:	446000ef          	jal	4c52 <sbrk>
    4810:	89aa                	mv	s3,a0
    4812:	4481                	li	s1,0
    4814:	597d                	li	s2,-1
    4816:	a011                	j	481a <countfree+0x1e>
    4818:	2485                	addiw	s1,s1,1
    481a:	6505                	lui	a0,0x1
    481c:	436000ef          	jal	4c52 <sbrk>
    4820:	ff251ce3          	bne	a0,s2,4818 <countfree+0x1c>
    4824:	4501                	li	a0,0
    4826:	42c000ef          	jal	4c52 <sbrk>
    482a:	40a9853b          	subw	a0,s3,a0
    482e:	424000ef          	jal	4c52 <sbrk>
    4832:	8526                	mv	a0,s1
    4834:	70a2                	ld	ra,40(sp)
    4836:	7402                	ld	s0,32(sp)
    4838:	64e2                	ld	s1,24(sp)
    483a:	6942                	ld	s2,16(sp)
    483c:	69a2                	ld	s3,8(sp)
    483e:	6145                	addi	sp,sp,48
    4840:	8082                	ret

0000000000004842 <drivetests>:
    4842:	7159                	addi	sp,sp,-112
    4844:	f486                	sd	ra,104(sp)
    4846:	f0a2                	sd	s0,96(sp)
    4848:	eca6                	sd	s1,88(sp)
    484a:	e8ca                	sd	s2,80(sp)
    484c:	e4ce                	sd	s3,72(sp)
    484e:	e0d2                	sd	s4,64(sp)
    4850:	fc56                	sd	s5,56(sp)
    4852:	f85a                	sd	s6,48(sp)
    4854:	f45e                	sd	s7,40(sp)
    4856:	f062                	sd	s8,32(sp)
    4858:	ec66                	sd	s9,24(sp)
    485a:	e86a                	sd	s10,16(sp)
    485c:	e46e                	sd	s11,8(sp)
    485e:	1880                	addi	s0,sp,112
    4860:	8aaa                	mv	s5,a0
    4862:	89ae                	mv	s3,a1
    4864:	8a32                	mv	s4,a2
    4866:	00003c17          	auipc	s8,0x3
    486a:	a42c0c13          	addi	s8,s8,-1470 # 72a8 <malloc+0x213a>
    486e:	00004b97          	auipc	s7,0x4
    4872:	7a2b8b93          	addi	s7,s7,1954 # 9010 <quicktests>
    4876:	4b09                	li	s6,2
    4878:	00005c97          	auipc	s9,0x5
    487c:	b98c8c93          	addi	s9,s9,-1128 # 9410 <slowtests>
    4880:	00003d97          	auipc	s11,0x3
    4884:	a40d8d93          	addi	s11,s11,-1472 # 72c0 <malloc+0x2152>
    4888:	00003d17          	auipc	s10,0x3
    488c:	a58d0d13          	addi	s10,s10,-1448 # 72e0 <malloc+0x2172>
    4890:	a025                	j	48b8 <drivetests+0x76>
    4892:	09699063          	bne	s3,s6,4912 <drivetests+0xd0>
    4896:	4481                	li	s1,0
    4898:	a835                	j	48d4 <drivetests+0x92>
    489a:	856e                	mv	a0,s11
    489c:	01f000ef          	jal	50ba <printf>
    48a0:	a835                	j	48dc <drivetests+0x9a>
    48a2:	07699a63          	bne	s3,s6,4916 <drivetests+0xd4>
    48a6:	f57ff0ef          	jal	47fc <countfree>
    48aa:	05254263          	blt	a0,s2,48ee <drivetests+0xac>
    48ae:	000a0363          	beqz	s4,48b4 <drivetests+0x72>
    48b2:	c8a1                	beqz	s1,4902 <drivetests+0xc0>
    48b4:	06098563          	beqz	s3,491e <drivetests+0xdc>
    48b8:	8562                	mv	a0,s8
    48ba:	001000ef          	jal	50ba <printf>
    48be:	f3fff0ef          	jal	47fc <countfree>
    48c2:	892a                	mv	s2,a0
    48c4:	864e                	mv	a2,s3
    48c6:	85d2                	mv	a1,s4
    48c8:	855e                	mv	a0,s7
    48ca:	ec1ff0ef          	jal	478a <runtests>
    48ce:	84aa                	mv	s1,a0
    48d0:	fc0541e3          	bltz	a0,4892 <drivetests+0x50>
    48d4:	fc0a99e3          	bnez	s5,48a6 <drivetests+0x64>
    48d8:	fc0a01e3          	beqz	s4,489a <drivetests+0x58>
    48dc:	864e                	mv	a2,s3
    48de:	85d2                	mv	a1,s4
    48e0:	8566                	mv	a0,s9
    48e2:	ea9ff0ef          	jal	478a <runtests>
    48e6:	fa054ee3          	bltz	a0,48a2 <drivetests+0x60>
    48ea:	9ca9                	addw	s1,s1,a0
    48ec:	bf6d                	j	48a6 <drivetests+0x64>
    48ee:	864a                	mv	a2,s2
    48f0:	85aa                	mv	a1,a0
    48f2:	856a                	mv	a0,s10
    48f4:	7c6000ef          	jal	50ba <printf>
    48f8:	03699163          	bne	s3,s6,491a <drivetests+0xd8>
    48fc:	fa0a1be3          	bnez	s4,48b2 <drivetests+0x70>
    4900:	bf65                	j	48b8 <drivetests+0x76>
    4902:	00003517          	auipc	a0,0x3
    4906:	a0e50513          	addi	a0,a0,-1522 # 7310 <malloc+0x21a2>
    490a:	7b0000ef          	jal	50ba <printf>
    490e:	4505                	li	a0,1
    4910:	a801                	j	4920 <drivetests+0xde>
    4912:	4505                	li	a0,1
    4914:	a031                	j	4920 <drivetests+0xde>
    4916:	4505                	li	a0,1
    4918:	a021                	j	4920 <drivetests+0xde>
    491a:	4505                	li	a0,1
    491c:	a011                	j	4920 <drivetests+0xde>
    491e:	854e                	mv	a0,s3
    4920:	70a6                	ld	ra,104(sp)
    4922:	7406                	ld	s0,96(sp)
    4924:	64e6                	ld	s1,88(sp)
    4926:	6946                	ld	s2,80(sp)
    4928:	69a6                	ld	s3,72(sp)
    492a:	6a06                	ld	s4,64(sp)
    492c:	7ae2                	ld	s5,56(sp)
    492e:	7b42                	ld	s6,48(sp)
    4930:	7ba2                	ld	s7,40(sp)
    4932:	7c02                	ld	s8,32(sp)
    4934:	6ce2                	ld	s9,24(sp)
    4936:	6d42                	ld	s10,16(sp)
    4938:	6da2                	ld	s11,8(sp)
    493a:	6165                	addi	sp,sp,112
    493c:	8082                	ret

000000000000493e <main>:
    493e:	1101                	addi	sp,sp,-32
    4940:	ec06                	sd	ra,24(sp)
    4942:	e822                	sd	s0,16(sp)
    4944:	e426                	sd	s1,8(sp)
    4946:	e04a                	sd	s2,0(sp)
    4948:	1000                	addi	s0,sp,32
    494a:	84aa                	mv	s1,a0
    494c:	4789                	li	a5,2
    494e:	00f50e63          	beq	a0,a5,496a <main+0x2c>
    4952:	4785                	li	a5,1
    4954:	06a7c663          	blt	a5,a0,49c0 <main+0x82>
    4958:	4601                	li	a2,0
    495a:	4501                	li	a0,0
    495c:	4581                	li	a1,0
    495e:	ee5ff0ef          	jal	4842 <drivetests>
    4962:	cd35                	beqz	a0,49de <main+0xa0>
    4964:	4505                	li	a0,1
    4966:	320000ef          	jal	4c86 <exit>
    496a:	892e                	mv	s2,a1
    496c:	00003597          	auipc	a1,0x3
    4970:	9bc58593          	addi	a1,a1,-1604 # 7328 <malloc+0x21ba>
    4974:	00893503          	ld	a0,8(s2)
    4978:	0a6000ef          	jal	4a1e <strcmp>
    497c:	85aa                	mv	a1,a0
    497e:	e501                	bnez	a0,4986 <main+0x48>
    4980:	4601                	li	a2,0
    4982:	4505                	li	a0,1
    4984:	bfe9                	j	495e <main+0x20>
    4986:	00003597          	auipc	a1,0x3
    498a:	9aa58593          	addi	a1,a1,-1622 # 7330 <malloc+0x21c2>
    498e:	00893503          	ld	a0,8(s2)
    4992:	08c000ef          	jal	4a1e <strcmp>
    4996:	cd15                	beqz	a0,49d2 <main+0x94>
    4998:	00003597          	auipc	a1,0x3
    499c:	9e858593          	addi	a1,a1,-1560 # 7380 <malloc+0x2212>
    49a0:	00893503          	ld	a0,8(s2)
    49a4:	07a000ef          	jal	4a1e <strcmp>
    49a8:	c905                	beqz	a0,49d8 <main+0x9a>
    49aa:	00893603          	ld	a2,8(s2)
    49ae:	00064703          	lbu	a4,0(a2) # 1000 <badarg>
    49b2:	02d00793          	li	a5,45
    49b6:	00f70563          	beq	a4,a5,49c0 <main+0x82>
    49ba:	4501                	li	a0,0
    49bc:	4581                	li	a1,0
    49be:	b745                	j	495e <main+0x20>
    49c0:	00003517          	auipc	a0,0x3
    49c4:	97850513          	addi	a0,a0,-1672 # 7338 <malloc+0x21ca>
    49c8:	6f2000ef          	jal	50ba <printf>
    49cc:	4505                	li	a0,1
    49ce:	2b8000ef          	jal	4c86 <exit>
    49d2:	4601                	li	a2,0
    49d4:	4585                	li	a1,1
    49d6:	b761                	j	495e <main+0x20>
    49d8:	85a6                	mv	a1,s1
    49da:	4601                	li	a2,0
    49dc:	b749                	j	495e <main+0x20>
    49de:	00003517          	auipc	a0,0x3
    49e2:	98a50513          	addi	a0,a0,-1654 # 7368 <malloc+0x21fa>
    49e6:	6d4000ef          	jal	50ba <printf>
    49ea:	4501                	li	a0,0
    49ec:	29a000ef          	jal	4c86 <exit>

00000000000049f0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    49f0:	1141                	addi	sp,sp,-16
    49f2:	e406                	sd	ra,8(sp)
    49f4:	e022                	sd	s0,0(sp)
    49f6:	0800                	addi	s0,sp,16
  extern int main();
  main();
    49f8:	f47ff0ef          	jal	493e <main>
  exit(0);
    49fc:	4501                	li	a0,0
    49fe:	288000ef          	jal	4c86 <exit>

0000000000004a02 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4a02:	1141                	addi	sp,sp,-16
    4a04:	e422                	sd	s0,8(sp)
    4a06:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4a08:	87aa                	mv	a5,a0
    4a0a:	0585                	addi	a1,a1,1
    4a0c:	0785                	addi	a5,a5,1
    4a0e:	fff5c703          	lbu	a4,-1(a1)
    4a12:	fee78fa3          	sb	a4,-1(a5)
    4a16:	fb75                	bnez	a4,4a0a <strcpy+0x8>
    ;
  return os;
}
    4a18:	6422                	ld	s0,8(sp)
    4a1a:	0141                	addi	sp,sp,16
    4a1c:	8082                	ret

0000000000004a1e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4a1e:	1141                	addi	sp,sp,-16
    4a20:	e422                	sd	s0,8(sp)
    4a22:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4a24:	00054783          	lbu	a5,0(a0)
    4a28:	cb91                	beqz	a5,4a3c <strcmp+0x1e>
    4a2a:	0005c703          	lbu	a4,0(a1)
    4a2e:	00f71763          	bne	a4,a5,4a3c <strcmp+0x1e>
    p++, q++;
    4a32:	0505                	addi	a0,a0,1
    4a34:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4a36:	00054783          	lbu	a5,0(a0)
    4a3a:	fbe5                	bnez	a5,4a2a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4a3c:	0005c503          	lbu	a0,0(a1)
}
    4a40:	40a7853b          	subw	a0,a5,a0
    4a44:	6422                	ld	s0,8(sp)
    4a46:	0141                	addi	sp,sp,16
    4a48:	8082                	ret

0000000000004a4a <strlen>:

uint
strlen(const char *s)
{
    4a4a:	1141                	addi	sp,sp,-16
    4a4c:	e422                	sd	s0,8(sp)
    4a4e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4a50:	00054783          	lbu	a5,0(a0)
    4a54:	cf91                	beqz	a5,4a70 <strlen+0x26>
    4a56:	0505                	addi	a0,a0,1
    4a58:	87aa                	mv	a5,a0
    4a5a:	86be                	mv	a3,a5
    4a5c:	0785                	addi	a5,a5,1
    4a5e:	fff7c703          	lbu	a4,-1(a5)
    4a62:	ff65                	bnez	a4,4a5a <strlen+0x10>
    4a64:	40a6853b          	subw	a0,a3,a0
    4a68:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    4a6a:	6422                	ld	s0,8(sp)
    4a6c:	0141                	addi	sp,sp,16
    4a6e:	8082                	ret
  for(n = 0; s[n]; n++)
    4a70:	4501                	li	a0,0
    4a72:	bfe5                	j	4a6a <strlen+0x20>

0000000000004a74 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4a74:	1141                	addi	sp,sp,-16
    4a76:	e422                	sd	s0,8(sp)
    4a78:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4a7a:	ca19                	beqz	a2,4a90 <memset+0x1c>
    4a7c:	87aa                	mv	a5,a0
    4a7e:	1602                	slli	a2,a2,0x20
    4a80:	9201                	srli	a2,a2,0x20
    4a82:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4a86:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4a8a:	0785                	addi	a5,a5,1
    4a8c:	fee79de3          	bne	a5,a4,4a86 <memset+0x12>
  }
  return dst;
}
    4a90:	6422                	ld	s0,8(sp)
    4a92:	0141                	addi	sp,sp,16
    4a94:	8082                	ret

0000000000004a96 <strchr>:

char*
strchr(const char *s, char c)
{
    4a96:	1141                	addi	sp,sp,-16
    4a98:	e422                	sd	s0,8(sp)
    4a9a:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4a9c:	00054783          	lbu	a5,0(a0)
    4aa0:	cb99                	beqz	a5,4ab6 <strchr+0x20>
    if(*s == c)
    4aa2:	00f58763          	beq	a1,a5,4ab0 <strchr+0x1a>
  for(; *s; s++)
    4aa6:	0505                	addi	a0,a0,1
    4aa8:	00054783          	lbu	a5,0(a0)
    4aac:	fbfd                	bnez	a5,4aa2 <strchr+0xc>
      return (char*)s;
  return 0;
    4aae:	4501                	li	a0,0
}
    4ab0:	6422                	ld	s0,8(sp)
    4ab2:	0141                	addi	sp,sp,16
    4ab4:	8082                	ret
  return 0;
    4ab6:	4501                	li	a0,0
    4ab8:	bfe5                	j	4ab0 <strchr+0x1a>

0000000000004aba <gets>:

char*
gets(char *buf, int max)
{
    4aba:	711d                	addi	sp,sp,-96
    4abc:	ec86                	sd	ra,88(sp)
    4abe:	e8a2                	sd	s0,80(sp)
    4ac0:	e4a6                	sd	s1,72(sp)
    4ac2:	e0ca                	sd	s2,64(sp)
    4ac4:	fc4e                	sd	s3,56(sp)
    4ac6:	f852                	sd	s4,48(sp)
    4ac8:	f456                	sd	s5,40(sp)
    4aca:	f05a                	sd	s6,32(sp)
    4acc:	ec5e                	sd	s7,24(sp)
    4ace:	1080                	addi	s0,sp,96
    4ad0:	8baa                	mv	s7,a0
    4ad2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4ad4:	892a                	mv	s2,a0
    4ad6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    4ad8:	4aa9                	li	s5,10
    4ada:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4adc:	89a6                	mv	s3,s1
    4ade:	2485                	addiw	s1,s1,1
    4ae0:	0344d663          	bge	s1,s4,4b0c <gets+0x52>
    cc = read(0, &c, 1);
    4ae4:	4605                	li	a2,1
    4ae6:	faf40593          	addi	a1,s0,-81
    4aea:	4501                	li	a0,0
    4aec:	1b2000ef          	jal	4c9e <read>
    if(cc < 1)
    4af0:	00a05e63          	blez	a0,4b0c <gets+0x52>
    buf[i++] = c;
    4af4:	faf44783          	lbu	a5,-81(s0)
    4af8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4afc:	01578763          	beq	a5,s5,4b0a <gets+0x50>
    4b00:	0905                	addi	s2,s2,1
    4b02:	fd679de3          	bne	a5,s6,4adc <gets+0x22>
    buf[i++] = c;
    4b06:	89a6                	mv	s3,s1
    4b08:	a011                	j	4b0c <gets+0x52>
    4b0a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4b0c:	99de                	add	s3,s3,s7
    4b0e:	00098023          	sb	zero,0(s3)
  return buf;
}
    4b12:	855e                	mv	a0,s7
    4b14:	60e6                	ld	ra,88(sp)
    4b16:	6446                	ld	s0,80(sp)
    4b18:	64a6                	ld	s1,72(sp)
    4b1a:	6906                	ld	s2,64(sp)
    4b1c:	79e2                	ld	s3,56(sp)
    4b1e:	7a42                	ld	s4,48(sp)
    4b20:	7aa2                	ld	s5,40(sp)
    4b22:	7b02                	ld	s6,32(sp)
    4b24:	6be2                	ld	s7,24(sp)
    4b26:	6125                	addi	sp,sp,96
    4b28:	8082                	ret

0000000000004b2a <stat>:

int
stat(const char *n, struct stat *st)
{
    4b2a:	1101                	addi	sp,sp,-32
    4b2c:	ec06                	sd	ra,24(sp)
    4b2e:	e822                	sd	s0,16(sp)
    4b30:	e04a                	sd	s2,0(sp)
    4b32:	1000                	addi	s0,sp,32
    4b34:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4b36:	4581                	li	a1,0
    4b38:	18e000ef          	jal	4cc6 <open>
  if(fd < 0)
    4b3c:	02054263          	bltz	a0,4b60 <stat+0x36>
    4b40:	e426                	sd	s1,8(sp)
    4b42:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4b44:	85ca                	mv	a1,s2
    4b46:	198000ef          	jal	4cde <fstat>
    4b4a:	892a                	mv	s2,a0
  close(fd);
    4b4c:	8526                	mv	a0,s1
    4b4e:	160000ef          	jal	4cae <close>
  return r;
    4b52:	64a2                	ld	s1,8(sp)
}
    4b54:	854a                	mv	a0,s2
    4b56:	60e2                	ld	ra,24(sp)
    4b58:	6442                	ld	s0,16(sp)
    4b5a:	6902                	ld	s2,0(sp)
    4b5c:	6105                	addi	sp,sp,32
    4b5e:	8082                	ret
    return -1;
    4b60:	597d                	li	s2,-1
    4b62:	bfcd                	j	4b54 <stat+0x2a>

0000000000004b64 <atoi>:

int
atoi(const char *s)
{
    4b64:	1141                	addi	sp,sp,-16
    4b66:	e422                	sd	s0,8(sp)
    4b68:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4b6a:	00054683          	lbu	a3,0(a0)
    4b6e:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x30328>
    4b72:	0ff7f793          	zext.b	a5,a5
    4b76:	4625                	li	a2,9
    4b78:	02f66863          	bltu	a2,a5,4ba8 <atoi+0x44>
    4b7c:	872a                	mv	a4,a0
  n = 0;
    4b7e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4b80:	0705                	addi	a4,a4,1 # 1000001 <base+0xff0359>
    4b82:	0025179b          	slliw	a5,a0,0x2
    4b86:	9fa9                	addw	a5,a5,a0
    4b88:	0017979b          	slliw	a5,a5,0x1
    4b8c:	9fb5                	addw	a5,a5,a3
    4b8e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4b92:	00074683          	lbu	a3,0(a4)
    4b96:	fd06879b          	addiw	a5,a3,-48
    4b9a:	0ff7f793          	zext.b	a5,a5
    4b9e:	fef671e3          	bgeu	a2,a5,4b80 <atoi+0x1c>
  return n;
}
    4ba2:	6422                	ld	s0,8(sp)
    4ba4:	0141                	addi	sp,sp,16
    4ba6:	8082                	ret
  n = 0;
    4ba8:	4501                	li	a0,0
    4baa:	bfe5                	j	4ba2 <atoi+0x3e>

0000000000004bac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4bac:	1141                	addi	sp,sp,-16
    4bae:	e422                	sd	s0,8(sp)
    4bb0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4bb2:	02b57463          	bgeu	a0,a1,4bda <memmove+0x2e>
    while(n-- > 0)
    4bb6:	00c05f63          	blez	a2,4bd4 <memmove+0x28>
    4bba:	1602                	slli	a2,a2,0x20
    4bbc:	9201                	srli	a2,a2,0x20
    4bbe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4bc2:	872a                	mv	a4,a0
      *dst++ = *src++;
    4bc4:	0585                	addi	a1,a1,1
    4bc6:	0705                	addi	a4,a4,1
    4bc8:	fff5c683          	lbu	a3,-1(a1)
    4bcc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4bd0:	fef71ae3          	bne	a4,a5,4bc4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4bd4:	6422                	ld	s0,8(sp)
    4bd6:	0141                	addi	sp,sp,16
    4bd8:	8082                	ret
    dst += n;
    4bda:	00c50733          	add	a4,a0,a2
    src += n;
    4bde:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4be0:	fec05ae3          	blez	a2,4bd4 <memmove+0x28>
    4be4:	fff6079b          	addiw	a5,a2,-1
    4be8:	1782                	slli	a5,a5,0x20
    4bea:	9381                	srli	a5,a5,0x20
    4bec:	fff7c793          	not	a5,a5
    4bf0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4bf2:	15fd                	addi	a1,a1,-1
    4bf4:	177d                	addi	a4,a4,-1
    4bf6:	0005c683          	lbu	a3,0(a1)
    4bfa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4bfe:	fee79ae3          	bne	a5,a4,4bf2 <memmove+0x46>
    4c02:	bfc9                	j	4bd4 <memmove+0x28>

0000000000004c04 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4c04:	1141                	addi	sp,sp,-16
    4c06:	e422                	sd	s0,8(sp)
    4c08:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4c0a:	ca05                	beqz	a2,4c3a <memcmp+0x36>
    4c0c:	fff6069b          	addiw	a3,a2,-1
    4c10:	1682                	slli	a3,a3,0x20
    4c12:	9281                	srli	a3,a3,0x20
    4c14:	0685                	addi	a3,a3,1
    4c16:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4c18:	00054783          	lbu	a5,0(a0)
    4c1c:	0005c703          	lbu	a4,0(a1)
    4c20:	00e79863          	bne	a5,a4,4c30 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4c24:	0505                	addi	a0,a0,1
    p2++;
    4c26:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4c28:	fed518e3          	bne	a0,a3,4c18 <memcmp+0x14>
  }
  return 0;
    4c2c:	4501                	li	a0,0
    4c2e:	a019                	j	4c34 <memcmp+0x30>
      return *p1 - *p2;
    4c30:	40e7853b          	subw	a0,a5,a4
}
    4c34:	6422                	ld	s0,8(sp)
    4c36:	0141                	addi	sp,sp,16
    4c38:	8082                	ret
  return 0;
    4c3a:	4501                	li	a0,0
    4c3c:	bfe5                	j	4c34 <memcmp+0x30>

0000000000004c3e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4c3e:	1141                	addi	sp,sp,-16
    4c40:	e406                	sd	ra,8(sp)
    4c42:	e022                	sd	s0,0(sp)
    4c44:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4c46:	f67ff0ef          	jal	4bac <memmove>
}
    4c4a:	60a2                	ld	ra,8(sp)
    4c4c:	6402                	ld	s0,0(sp)
    4c4e:	0141                	addi	sp,sp,16
    4c50:	8082                	ret

0000000000004c52 <sbrk>:

char *
sbrk(int n) {
    4c52:	1141                	addi	sp,sp,-16
    4c54:	e406                	sd	ra,8(sp)
    4c56:	e022                	sd	s0,0(sp)
    4c58:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4c5a:	4585                	li	a1,1
    4c5c:	0b2000ef          	jal	4d0e <sys_sbrk>
}
    4c60:	60a2                	ld	ra,8(sp)
    4c62:	6402                	ld	s0,0(sp)
    4c64:	0141                	addi	sp,sp,16
    4c66:	8082                	ret

0000000000004c68 <sbrklazy>:

char *
sbrklazy(int n) {
    4c68:	1141                	addi	sp,sp,-16
    4c6a:	e406                	sd	ra,8(sp)
    4c6c:	e022                	sd	s0,0(sp)
    4c6e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4c70:	4589                	li	a1,2
    4c72:	09c000ef          	jal	4d0e <sys_sbrk>
}
    4c76:	60a2                	ld	ra,8(sp)
    4c78:	6402                	ld	s0,0(sp)
    4c7a:	0141                	addi	sp,sp,16
    4c7c:	8082                	ret

0000000000004c7e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4c7e:	4885                	li	a7,1
 ecall
    4c80:	00000073          	ecall
 ret
    4c84:	8082                	ret

0000000000004c86 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4c86:	4889                	li	a7,2
 ecall
    4c88:	00000073          	ecall
 ret
    4c8c:	8082                	ret

0000000000004c8e <wait>:
.global wait
wait:
 li a7, SYS_wait
    4c8e:	488d                	li	a7,3
 ecall
    4c90:	00000073          	ecall
 ret
    4c94:	8082                	ret

0000000000004c96 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4c96:	4891                	li	a7,4
 ecall
    4c98:	00000073          	ecall
 ret
    4c9c:	8082                	ret

0000000000004c9e <read>:
.global read
read:
 li a7, SYS_read
    4c9e:	4895                	li	a7,5
 ecall
    4ca0:	00000073          	ecall
 ret
    4ca4:	8082                	ret

0000000000004ca6 <write>:
.global write
write:
 li a7, SYS_write
    4ca6:	48c1                	li	a7,16
 ecall
    4ca8:	00000073          	ecall
 ret
    4cac:	8082                	ret

0000000000004cae <close>:
.global close
close:
 li a7, SYS_close
    4cae:	48d5                	li	a7,21
 ecall
    4cb0:	00000073          	ecall
 ret
    4cb4:	8082                	ret

0000000000004cb6 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4cb6:	4899                	li	a7,6
 ecall
    4cb8:	00000073          	ecall
 ret
    4cbc:	8082                	ret

0000000000004cbe <exec>:
.global exec
exec:
 li a7, SYS_exec
    4cbe:	489d                	li	a7,7
 ecall
    4cc0:	00000073          	ecall
 ret
    4cc4:	8082                	ret

0000000000004cc6 <open>:
.global open
open:
 li a7, SYS_open
    4cc6:	48bd                	li	a7,15
 ecall
    4cc8:	00000073          	ecall
 ret
    4ccc:	8082                	ret

0000000000004cce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4cce:	48c5                	li	a7,17
 ecall
    4cd0:	00000073          	ecall
 ret
    4cd4:	8082                	ret

0000000000004cd6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4cd6:	48c9                	li	a7,18
 ecall
    4cd8:	00000073          	ecall
 ret
    4cdc:	8082                	ret

0000000000004cde <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4cde:	48a1                	li	a7,8
 ecall
    4ce0:	00000073          	ecall
 ret
    4ce4:	8082                	ret

0000000000004ce6 <link>:
.global link
link:
 li a7, SYS_link
    4ce6:	48cd                	li	a7,19
 ecall
    4ce8:	00000073          	ecall
 ret
    4cec:	8082                	ret

0000000000004cee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4cee:	48d1                	li	a7,20
 ecall
    4cf0:	00000073          	ecall
 ret
    4cf4:	8082                	ret

0000000000004cf6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4cf6:	48a5                	li	a7,9
 ecall
    4cf8:	00000073          	ecall
 ret
    4cfc:	8082                	ret

0000000000004cfe <dup>:
.global dup
dup:
 li a7, SYS_dup
    4cfe:	48a9                	li	a7,10
 ecall
    4d00:	00000073          	ecall
 ret
    4d04:	8082                	ret

0000000000004d06 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4d06:	48ad                	li	a7,11
 ecall
    4d08:	00000073          	ecall
 ret
    4d0c:	8082                	ret

0000000000004d0e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    4d0e:	48b1                	li	a7,12
 ecall
    4d10:	00000073          	ecall
 ret
    4d14:	8082                	ret

0000000000004d16 <pause>:
.global pause
pause:
 li a7, SYS_pause
    4d16:	48b5                	li	a7,13
 ecall
    4d18:	00000073          	ecall
 ret
    4d1c:	8082                	ret

0000000000004d1e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4d1e:	48b9                	li	a7,14
 ecall
    4d20:	00000073          	ecall
 ret
    4d24:	8082                	ret

0000000000004d26 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4d26:	1101                	addi	sp,sp,-32
    4d28:	ec06                	sd	ra,24(sp)
    4d2a:	e822                	sd	s0,16(sp)
    4d2c:	1000                	addi	s0,sp,32
    4d2e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4d32:	4605                	li	a2,1
    4d34:	fef40593          	addi	a1,s0,-17
    4d38:	f6fff0ef          	jal	4ca6 <write>
}
    4d3c:	60e2                	ld	ra,24(sp)
    4d3e:	6442                	ld	s0,16(sp)
    4d40:	6105                	addi	sp,sp,32
    4d42:	8082                	ret

0000000000004d44 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    4d44:	715d                	addi	sp,sp,-80
    4d46:	e486                	sd	ra,72(sp)
    4d48:	e0a2                	sd	s0,64(sp)
    4d4a:	fc26                	sd	s1,56(sp)
    4d4c:	0880                	addi	s0,sp,80
    4d4e:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4d50:	c299                	beqz	a3,4d56 <printint+0x12>
    4d52:	0805c963          	bltz	a1,4de4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4d56:	2581                	sext.w	a1,a1
  neg = 0;
    4d58:	4881                	li	a7,0
    4d5a:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
    4d5e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4d60:	2601                	sext.w	a2,a2
    4d62:	00003517          	auipc	a0,0x3
    4d66:	a3e50513          	addi	a0,a0,-1474 # 77a0 <digits>
    4d6a:	883a                	mv	a6,a4
    4d6c:	2705                	addiw	a4,a4,1
    4d6e:	02c5f7bb          	remuw	a5,a1,a2
    4d72:	1782                	slli	a5,a5,0x20
    4d74:	9381                	srli	a5,a5,0x20
    4d76:	97aa                	add	a5,a5,a0
    4d78:	0007c783          	lbu	a5,0(a5)
    4d7c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4d80:	0005879b          	sext.w	a5,a1
    4d84:	02c5d5bb          	divuw	a1,a1,a2
    4d88:	0685                	addi	a3,a3,1
    4d8a:	fec7f0e3          	bgeu	a5,a2,4d6a <printint+0x26>
  if(neg)
    4d8e:	00088c63          	beqz	a7,4da6 <printint+0x62>
    buf[i++] = '-';
    4d92:	fd070793          	addi	a5,a4,-48
    4d96:	00878733          	add	a4,a5,s0
    4d9a:	02d00793          	li	a5,45
    4d9e:	fef70423          	sb	a5,-24(a4)
    4da2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4da6:	02e05a63          	blez	a4,4dda <printint+0x96>
    4daa:	f84a                	sd	s2,48(sp)
    4dac:	f44e                	sd	s3,40(sp)
    4dae:	fb840793          	addi	a5,s0,-72
    4db2:	00e78933          	add	s2,a5,a4
    4db6:	fff78993          	addi	s3,a5,-1
    4dba:	99ba                	add	s3,s3,a4
    4dbc:	377d                	addiw	a4,a4,-1
    4dbe:	1702                	slli	a4,a4,0x20
    4dc0:	9301                	srli	a4,a4,0x20
    4dc2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4dc6:	fff94583          	lbu	a1,-1(s2)
    4dca:	8526                	mv	a0,s1
    4dcc:	f5bff0ef          	jal	4d26 <putc>
  while(--i >= 0)
    4dd0:	197d                	addi	s2,s2,-1
    4dd2:	ff391ae3          	bne	s2,s3,4dc6 <printint+0x82>
    4dd6:	7942                	ld	s2,48(sp)
    4dd8:	79a2                	ld	s3,40(sp)
}
    4dda:	60a6                	ld	ra,72(sp)
    4ddc:	6406                	ld	s0,64(sp)
    4dde:	74e2                	ld	s1,56(sp)
    4de0:	6161                	addi	sp,sp,80
    4de2:	8082                	ret
    x = -xx;
    4de4:	40b005bb          	negw	a1,a1
    neg = 1;
    4de8:	4885                	li	a7,1
    x = -xx;
    4dea:	bf85                	j	4d5a <printint+0x16>

0000000000004dec <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4dec:	711d                	addi	sp,sp,-96
    4dee:	ec86                	sd	ra,88(sp)
    4df0:	e8a2                	sd	s0,80(sp)
    4df2:	e0ca                	sd	s2,64(sp)
    4df4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4df6:	0005c903          	lbu	s2,0(a1)
    4dfa:	28090663          	beqz	s2,5086 <vprintf+0x29a>
    4dfe:	e4a6                	sd	s1,72(sp)
    4e00:	fc4e                	sd	s3,56(sp)
    4e02:	f852                	sd	s4,48(sp)
    4e04:	f456                	sd	s5,40(sp)
    4e06:	f05a                	sd	s6,32(sp)
    4e08:	ec5e                	sd	s7,24(sp)
    4e0a:	e862                	sd	s8,16(sp)
    4e0c:	e466                	sd	s9,8(sp)
    4e0e:	8b2a                	mv	s6,a0
    4e10:	8a2e                	mv	s4,a1
    4e12:	8bb2                	mv	s7,a2
  state = 0;
    4e14:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4e16:	4481                	li	s1,0
    4e18:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4e1a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4e1e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4e22:	06c00c93          	li	s9,108
    4e26:	a005                	j	4e46 <vprintf+0x5a>
        putc(fd, c0);
    4e28:	85ca                	mv	a1,s2
    4e2a:	855a                	mv	a0,s6
    4e2c:	efbff0ef          	jal	4d26 <putc>
    4e30:	a019                	j	4e36 <vprintf+0x4a>
    } else if(state == '%'){
    4e32:	03598263          	beq	s3,s5,4e56 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    4e36:	2485                	addiw	s1,s1,1
    4e38:	8726                	mv	a4,s1
    4e3a:	009a07b3          	add	a5,s4,s1
    4e3e:	0007c903          	lbu	s2,0(a5)
    4e42:	22090a63          	beqz	s2,5076 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
    4e46:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4e4a:	fe0994e3          	bnez	s3,4e32 <vprintf+0x46>
      if(c0 == '%'){
    4e4e:	fd579de3          	bne	a5,s5,4e28 <vprintf+0x3c>
        state = '%';
    4e52:	89be                	mv	s3,a5
    4e54:	b7cd                	j	4e36 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4e56:	00ea06b3          	add	a3,s4,a4
    4e5a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4e5e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4e60:	c681                	beqz	a3,4e68 <vprintf+0x7c>
    4e62:	9752                	add	a4,a4,s4
    4e64:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4e68:	05878363          	beq	a5,s8,4eae <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    4e6c:	05978d63          	beq	a5,s9,4ec6 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4e70:	07500713          	li	a4,117
    4e74:	0ee78763          	beq	a5,a4,4f62 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4e78:	07800713          	li	a4,120
    4e7c:	12e78963          	beq	a5,a4,4fae <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4e80:	07000713          	li	a4,112
    4e84:	14e78e63          	beq	a5,a4,4fe0 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
    4e88:	06300713          	li	a4,99
    4e8c:	18e78e63          	beq	a5,a4,5028 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
    4e90:	07300713          	li	a4,115
    4e94:	1ae78463          	beq	a5,a4,503c <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4e98:	02500713          	li	a4,37
    4e9c:	04e79563          	bne	a5,a4,4ee6 <vprintf+0xfa>
        putc(fd, '%');
    4ea0:	02500593          	li	a1,37
    4ea4:	855a                	mv	a0,s6
    4ea6:	e81ff0ef          	jal	4d26 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    4eaa:	4981                	li	s3,0
    4eac:	b769                	j	4e36 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4eae:	008b8913          	addi	s2,s7,8
    4eb2:	4685                	li	a3,1
    4eb4:	4629                	li	a2,10
    4eb6:	000ba583          	lw	a1,0(s7)
    4eba:	855a                	mv	a0,s6
    4ebc:	e89ff0ef          	jal	4d44 <printint>
    4ec0:	8bca                	mv	s7,s2
      state = 0;
    4ec2:	4981                	li	s3,0
    4ec4:	bf8d                	j	4e36 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    4ec6:	06400793          	li	a5,100
    4eca:	02f68963          	beq	a3,a5,4efc <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4ece:	06c00793          	li	a5,108
    4ed2:	04f68263          	beq	a3,a5,4f16 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
    4ed6:	07500793          	li	a5,117
    4eda:	0af68063          	beq	a3,a5,4f7a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
    4ede:	07800793          	li	a5,120
    4ee2:	0ef68263          	beq	a3,a5,4fc6 <vprintf+0x1da>
        putc(fd, '%');
    4ee6:	02500593          	li	a1,37
    4eea:	855a                	mv	a0,s6
    4eec:	e3bff0ef          	jal	4d26 <putc>
        putc(fd, c0);
    4ef0:	85ca                	mv	a1,s2
    4ef2:	855a                	mv	a0,s6
    4ef4:	e33ff0ef          	jal	4d26 <putc>
      state = 0;
    4ef8:	4981                	li	s3,0
    4efa:	bf35                	j	4e36 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4efc:	008b8913          	addi	s2,s7,8
    4f00:	4685                	li	a3,1
    4f02:	4629                	li	a2,10
    4f04:	000bb583          	ld	a1,0(s7)
    4f08:	855a                	mv	a0,s6
    4f0a:	e3bff0ef          	jal	4d44 <printint>
        i += 1;
    4f0e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f10:	8bca                	mv	s7,s2
      state = 0;
    4f12:	4981                	li	s3,0
        i += 1;
    4f14:	b70d                	j	4e36 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4f16:	06400793          	li	a5,100
    4f1a:	02f60763          	beq	a2,a5,4f48 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4f1e:	07500793          	li	a5,117
    4f22:	06f60963          	beq	a2,a5,4f94 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4f26:	07800793          	li	a5,120
    4f2a:	faf61ee3          	bne	a2,a5,4ee6 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4f2e:	008b8913          	addi	s2,s7,8
    4f32:	4681                	li	a3,0
    4f34:	4641                	li	a2,16
    4f36:	000bb583          	ld	a1,0(s7)
    4f3a:	855a                	mv	a0,s6
    4f3c:	e09ff0ef          	jal	4d44 <printint>
        i += 2;
    4f40:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4f42:	8bca                	mv	s7,s2
      state = 0;
    4f44:	4981                	li	s3,0
        i += 2;
    4f46:	bdc5                	j	4e36 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f48:	008b8913          	addi	s2,s7,8
    4f4c:	4685                	li	a3,1
    4f4e:	4629                	li	a2,10
    4f50:	000bb583          	ld	a1,0(s7)
    4f54:	855a                	mv	a0,s6
    4f56:	defff0ef          	jal	4d44 <printint>
        i += 2;
    4f5a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f5c:	8bca                	mv	s7,s2
      state = 0;
    4f5e:	4981                	li	s3,0
        i += 2;
    4f60:	bdd9                	j	4e36 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    4f62:	008b8913          	addi	s2,s7,8
    4f66:	4681                	li	a3,0
    4f68:	4629                	li	a2,10
    4f6a:	000be583          	lwu	a1,0(s7)
    4f6e:	855a                	mv	a0,s6
    4f70:	dd5ff0ef          	jal	4d44 <printint>
    4f74:	8bca                	mv	s7,s2
      state = 0;
    4f76:	4981                	li	s3,0
    4f78:	bd7d                	j	4e36 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4f7a:	008b8913          	addi	s2,s7,8
    4f7e:	4681                	li	a3,0
    4f80:	4629                	li	a2,10
    4f82:	000bb583          	ld	a1,0(s7)
    4f86:	855a                	mv	a0,s6
    4f88:	dbdff0ef          	jal	4d44 <printint>
        i += 1;
    4f8c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4f8e:	8bca                	mv	s7,s2
      state = 0;
    4f90:	4981                	li	s3,0
        i += 1;
    4f92:	b555                	j	4e36 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4f94:	008b8913          	addi	s2,s7,8
    4f98:	4681                	li	a3,0
    4f9a:	4629                	li	a2,10
    4f9c:	000bb583          	ld	a1,0(s7)
    4fa0:	855a                	mv	a0,s6
    4fa2:	da3ff0ef          	jal	4d44 <printint>
        i += 2;
    4fa6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4fa8:	8bca                	mv	s7,s2
      state = 0;
    4faa:	4981                	li	s3,0
        i += 2;
    4fac:	b569                	j	4e36 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    4fae:	008b8913          	addi	s2,s7,8
    4fb2:	4681                	li	a3,0
    4fb4:	4641                	li	a2,16
    4fb6:	000be583          	lwu	a1,0(s7)
    4fba:	855a                	mv	a0,s6
    4fbc:	d89ff0ef          	jal	4d44 <printint>
    4fc0:	8bca                	mv	s7,s2
      state = 0;
    4fc2:	4981                	li	s3,0
    4fc4:	bd8d                	j	4e36 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4fc6:	008b8913          	addi	s2,s7,8
    4fca:	4681                	li	a3,0
    4fcc:	4641                	li	a2,16
    4fce:	000bb583          	ld	a1,0(s7)
    4fd2:	855a                	mv	a0,s6
    4fd4:	d71ff0ef          	jal	4d44 <printint>
        i += 1;
    4fd8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4fda:	8bca                	mv	s7,s2
      state = 0;
    4fdc:	4981                	li	s3,0
        i += 1;
    4fde:	bda1                	j	4e36 <vprintf+0x4a>
    4fe0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    4fe2:	008b8d13          	addi	s10,s7,8
    4fe6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4fea:	03000593          	li	a1,48
    4fee:	855a                	mv	a0,s6
    4ff0:	d37ff0ef          	jal	4d26 <putc>
  putc(fd, 'x');
    4ff4:	07800593          	li	a1,120
    4ff8:	855a                	mv	a0,s6
    4ffa:	d2dff0ef          	jal	4d26 <putc>
    4ffe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5000:	00002b97          	auipc	s7,0x2
    5004:	7a0b8b93          	addi	s7,s7,1952 # 77a0 <digits>
    5008:	03c9d793          	srli	a5,s3,0x3c
    500c:	97de                	add	a5,a5,s7
    500e:	0007c583          	lbu	a1,0(a5)
    5012:	855a                	mv	a0,s6
    5014:	d13ff0ef          	jal	4d26 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5018:	0992                	slli	s3,s3,0x4
    501a:	397d                	addiw	s2,s2,-1
    501c:	fe0916e3          	bnez	s2,5008 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    5020:	8bea                	mv	s7,s10
      state = 0;
    5022:	4981                	li	s3,0
    5024:	6d02                	ld	s10,0(sp)
    5026:	bd01                	j	4e36 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    5028:	008b8913          	addi	s2,s7,8
    502c:	000bc583          	lbu	a1,0(s7)
    5030:	855a                	mv	a0,s6
    5032:	cf5ff0ef          	jal	4d26 <putc>
    5036:	8bca                	mv	s7,s2
      state = 0;
    5038:	4981                	li	s3,0
    503a:	bbf5                	j	4e36 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    503c:	008b8993          	addi	s3,s7,8
    5040:	000bb903          	ld	s2,0(s7)
    5044:	00090f63          	beqz	s2,5062 <vprintf+0x276>
        for(; *s; s++)
    5048:	00094583          	lbu	a1,0(s2)
    504c:	c195                	beqz	a1,5070 <vprintf+0x284>
          putc(fd, *s);
    504e:	855a                	mv	a0,s6
    5050:	cd7ff0ef          	jal	4d26 <putc>
        for(; *s; s++)
    5054:	0905                	addi	s2,s2,1
    5056:	00094583          	lbu	a1,0(s2)
    505a:	f9f5                	bnez	a1,504e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    505c:	8bce                	mv	s7,s3
      state = 0;
    505e:	4981                	li	s3,0
    5060:	bbd9                	j	4e36 <vprintf+0x4a>
          s = "(null)";
    5062:	00002917          	auipc	s2,0x2
    5066:	68e90913          	addi	s2,s2,1678 # 76f0 <malloc+0x2582>
        for(; *s; s++)
    506a:	02800593          	li	a1,40
    506e:	b7c5                	j	504e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    5070:	8bce                	mv	s7,s3
      state = 0;
    5072:	4981                	li	s3,0
    5074:	b3c9                	j	4e36 <vprintf+0x4a>
    5076:	64a6                	ld	s1,72(sp)
    5078:	79e2                	ld	s3,56(sp)
    507a:	7a42                	ld	s4,48(sp)
    507c:	7aa2                	ld	s5,40(sp)
    507e:	7b02                	ld	s6,32(sp)
    5080:	6be2                	ld	s7,24(sp)
    5082:	6c42                	ld	s8,16(sp)
    5084:	6ca2                	ld	s9,8(sp)
    }
  }
}
    5086:	60e6                	ld	ra,88(sp)
    5088:	6446                	ld	s0,80(sp)
    508a:	6906                	ld	s2,64(sp)
    508c:	6125                	addi	sp,sp,96
    508e:	8082                	ret

0000000000005090 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5090:	715d                	addi	sp,sp,-80
    5092:	ec06                	sd	ra,24(sp)
    5094:	e822                	sd	s0,16(sp)
    5096:	1000                	addi	s0,sp,32
    5098:	e010                	sd	a2,0(s0)
    509a:	e414                	sd	a3,8(s0)
    509c:	e818                	sd	a4,16(s0)
    509e:	ec1c                	sd	a5,24(s0)
    50a0:	03043023          	sd	a6,32(s0)
    50a4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    50a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    50ac:	8622                	mv	a2,s0
    50ae:	d3fff0ef          	jal	4dec <vprintf>
}
    50b2:	60e2                	ld	ra,24(sp)
    50b4:	6442                	ld	s0,16(sp)
    50b6:	6161                	addi	sp,sp,80
    50b8:	8082                	ret

00000000000050ba <printf>:

void
printf(const char *fmt, ...)
{
    50ba:	711d                	addi	sp,sp,-96
    50bc:	ec06                	sd	ra,24(sp)
    50be:	e822                	sd	s0,16(sp)
    50c0:	1000                	addi	s0,sp,32
    50c2:	e40c                	sd	a1,8(s0)
    50c4:	e810                	sd	a2,16(s0)
    50c6:	ec14                	sd	a3,24(s0)
    50c8:	f018                	sd	a4,32(s0)
    50ca:	f41c                	sd	a5,40(s0)
    50cc:	03043823          	sd	a6,48(s0)
    50d0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    50d4:	00840613          	addi	a2,s0,8
    50d8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    50dc:	85aa                	mv	a1,a0
    50de:	4505                	li	a0,1
    50e0:	d0dff0ef          	jal	4dec <vprintf>
}
    50e4:	60e2                	ld	ra,24(sp)
    50e6:	6442                	ld	s0,16(sp)
    50e8:	6125                	addi	sp,sp,96
    50ea:	8082                	ret

00000000000050ec <free>:
    50ec:	1141                	addi	sp,sp,-16
    50ee:	e422                	sd	s0,8(sp)
    50f0:	0800                	addi	s0,sp,16
    50f2:	ff050693          	addi	a3,a0,-16
    50f6:	00004797          	auipc	a5,0x4
    50fa:	38a7b783          	ld	a5,906(a5) # 9480 <freep>
    50fe:	a02d                	j	5128 <free+0x3c>
    5100:	4618                	lw	a4,8(a2)
    5102:	9f2d                	addw	a4,a4,a1
    5104:	fee52c23          	sw	a4,-8(a0)
    5108:	6398                	ld	a4,0(a5)
    510a:	6310                	ld	a2,0(a4)
    510c:	a83d                	j	514a <free+0x5e>
    510e:	ff852703          	lw	a4,-8(a0)
    5112:	9f31                	addw	a4,a4,a2
    5114:	c798                	sw	a4,8(a5)
    5116:	ff053683          	ld	a3,-16(a0)
    511a:	a091                	j	515e <free+0x72>
    511c:	6398                	ld	a4,0(a5)
    511e:	00e7e463          	bltu	a5,a4,5126 <free+0x3a>
    5122:	00e6ea63          	bltu	a3,a4,5136 <free+0x4a>
    5126:	87ba                	mv	a5,a4
    5128:	fed7fae3          	bgeu	a5,a3,511c <free+0x30>
    512c:	6398                	ld	a4,0(a5)
    512e:	00e6e463          	bltu	a3,a4,5136 <free+0x4a>
    5132:	fee7eae3          	bltu	a5,a4,5126 <free+0x3a>
    5136:	ff852583          	lw	a1,-8(a0)
    513a:	6390                	ld	a2,0(a5)
    513c:	02059813          	slli	a6,a1,0x20
    5140:	01c85713          	srli	a4,a6,0x1c
    5144:	9736                	add	a4,a4,a3
    5146:	fae60de3          	beq	a2,a4,5100 <free+0x14>
    514a:	fec53823          	sd	a2,-16(a0)
    514e:	4790                	lw	a2,8(a5)
    5150:	02061593          	slli	a1,a2,0x20
    5154:	01c5d713          	srli	a4,a1,0x1c
    5158:	973e                	add	a4,a4,a5
    515a:	fae68ae3          	beq	a3,a4,510e <free+0x22>
    515e:	e394                	sd	a3,0(a5)
    5160:	00004717          	auipc	a4,0x4
    5164:	32f73023          	sd	a5,800(a4) # 9480 <freep>
    5168:	6422                	ld	s0,8(sp)
    516a:	0141                	addi	sp,sp,16
    516c:	8082                	ret

000000000000516e <malloc>:
    516e:	7139                	addi	sp,sp,-64
    5170:	fc06                	sd	ra,56(sp)
    5172:	f822                	sd	s0,48(sp)
    5174:	f426                	sd	s1,40(sp)
    5176:	ec4e                	sd	s3,24(sp)
    5178:	0080                	addi	s0,sp,64
    517a:	02051493          	slli	s1,a0,0x20
    517e:	9081                	srli	s1,s1,0x20
    5180:	04bd                	addi	s1,s1,15
    5182:	8091                	srli	s1,s1,0x4
    5184:	0014899b          	addiw	s3,s1,1
    5188:	0485                	addi	s1,s1,1
    518a:	00004517          	auipc	a0,0x4
    518e:	2f653503          	ld	a0,758(a0) # 9480 <freep>
    5192:	c915                	beqz	a0,51c6 <malloc+0x58>
    5194:	611c                	ld	a5,0(a0)
    5196:	4798                	lw	a4,8(a5)
    5198:	08977a63          	bgeu	a4,s1,522c <malloc+0xbe>
    519c:	f04a                	sd	s2,32(sp)
    519e:	e852                	sd	s4,16(sp)
    51a0:	e456                	sd	s5,8(sp)
    51a2:	e05a                	sd	s6,0(sp)
    51a4:	8a4e                	mv	s4,s3
    51a6:	0009871b          	sext.w	a4,s3
    51aa:	6685                	lui	a3,0x1
    51ac:	00d77363          	bgeu	a4,a3,51b2 <malloc+0x44>
    51b0:	6a05                	lui	s4,0x1
    51b2:	000a0b1b          	sext.w	s6,s4
    51b6:	004a1a1b          	slliw	s4,s4,0x4
    51ba:	00004917          	auipc	s2,0x4
    51be:	2c690913          	addi	s2,s2,710 # 9480 <freep>
    51c2:	5afd                	li	s5,-1
    51c4:	a081                	j	5204 <malloc+0x96>
    51c6:	f04a                	sd	s2,32(sp)
    51c8:	e852                	sd	s4,16(sp)
    51ca:	e456                	sd	s5,8(sp)
    51cc:	e05a                	sd	s6,0(sp)
    51ce:	0000b797          	auipc	a5,0xb
    51d2:	ada78793          	addi	a5,a5,-1318 # fca8 <base>
    51d6:	00004717          	auipc	a4,0x4
    51da:	2af73523          	sd	a5,682(a4) # 9480 <freep>
    51de:	e39c                	sd	a5,0(a5)
    51e0:	0007a423          	sw	zero,8(a5)
    51e4:	b7c1                	j	51a4 <malloc+0x36>
    51e6:	6398                	ld	a4,0(a5)
    51e8:	e118                	sd	a4,0(a0)
    51ea:	a8a9                	j	5244 <malloc+0xd6>
    51ec:	01652423          	sw	s6,8(a0)
    51f0:	0541                	addi	a0,a0,16
    51f2:	efbff0ef          	jal	50ec <free>
    51f6:	00093503          	ld	a0,0(s2)
    51fa:	c12d                	beqz	a0,525c <malloc+0xee>
    51fc:	611c                	ld	a5,0(a0)
    51fe:	4798                	lw	a4,8(a5)
    5200:	02977263          	bgeu	a4,s1,5224 <malloc+0xb6>
    5204:	00093703          	ld	a4,0(s2)
    5208:	853e                	mv	a0,a5
    520a:	fef719e3          	bne	a4,a5,51fc <malloc+0x8e>
    520e:	8552                	mv	a0,s4
    5210:	a43ff0ef          	jal	4c52 <sbrk>
    5214:	fd551ce3          	bne	a0,s5,51ec <malloc+0x7e>
    5218:	4501                	li	a0,0
    521a:	7902                	ld	s2,32(sp)
    521c:	6a42                	ld	s4,16(sp)
    521e:	6aa2                	ld	s5,8(sp)
    5220:	6b02                	ld	s6,0(sp)
    5222:	a03d                	j	5250 <malloc+0xe2>
    5224:	7902                	ld	s2,32(sp)
    5226:	6a42                	ld	s4,16(sp)
    5228:	6aa2                	ld	s5,8(sp)
    522a:	6b02                	ld	s6,0(sp)
    522c:	fae48de3          	beq	s1,a4,51e6 <malloc+0x78>
    5230:	4137073b          	subw	a4,a4,s3
    5234:	c798                	sw	a4,8(a5)
    5236:	02071693          	slli	a3,a4,0x20
    523a:	01c6d713          	srli	a4,a3,0x1c
    523e:	97ba                	add	a5,a5,a4
    5240:	0137a423          	sw	s3,8(a5)
    5244:	00004717          	auipc	a4,0x4
    5248:	22a73e23          	sd	a0,572(a4) # 9480 <freep>
    524c:	01078513          	addi	a0,a5,16
    5250:	70e2                	ld	ra,56(sp)
    5252:	7442                	ld	s0,48(sp)
    5254:	74a2                	ld	s1,40(sp)
    5256:	69e2                	ld	s3,24(sp)
    5258:	6121                	addi	sp,sp,64
    525a:	8082                	ret
    525c:	7902                	ld	s2,32(sp)
    525e:	6a42                	ld	s4,16(sp)
    5260:	6aa2                	ld	s5,8(sp)
    5262:	6b02                	ld	s6,0(sp)
    5264:	b7f5                	j	5250 <malloc+0xe2>
