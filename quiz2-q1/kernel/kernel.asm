
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	19813103          	ld	sp,408(sp) # 8000a198 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	649040ef          	jal	80004e5e <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00023797          	auipc	a5,0x23
    80000034:	4b878793          	addi	a5,a5,1208 # 800234e8 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");


#ifndef LAB_SYSCALL
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	19490913          	addi	s2,s2,404 # 8000a1e0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	045050ef          	jal	8000589a <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	0cd050ef          	jal	80005932 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	560050ef          	jal	800055de <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	10650513          	addi	a0,a0,262 # 8000a1e0 <kmem>
    800000e2:	738050ef          	jal	8000581a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	3fe50513          	addi	a0,a0,1022 # 800234e8 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	0d848493          	addi	s1,s1,216 # 8000a1e0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	788050ef          	jal	8000589a <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r) {
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	0c450513          	addi	a0,a0,196 # 8000a1e0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  }
  release(&kmem.lock);
    80000126:	00d050ef          	jal	80005932 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
#endif
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	0a050513          	addi	a0,a0,160 # 8000a1e0 <kmem>
    80000148:	7ea050ef          	jal	80005932 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdbb19>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	28b000ef          	jal	80000d7a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	0000a717          	auipc	a4,0xa
    800002f8:	ebc70713          	addi	a4,a4,-324 # 8000a1b0 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000308:	273000ef          	jal	80000d7a <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	7e3040ef          	jal	800052f8 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	5a2010ef          	jal	800018c0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	556040ef          	jal	80004878 <plicinithart>
  }

  scheduler();        
    80000326:	6e1000ef          	jal	80001206 <scheduler>
    consoleinit();
    8000032a:	6f9040ef          	jal	80005222 <consoleinit>
    printfinit();
    8000032e:	2ec050ef          	jal	8000561a <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	7bf040ef          	jal	800052f8 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	7b3040ef          	jal	800052f8 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	7a7040ef          	jal	800052f8 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2ca000ef          	jal	80000624 <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	163000ef          	jal	80000cc4 <procinit>
    trapinit();      // trap vectors
    80000366:	536010ef          	jal	8000189c <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	556010ef          	jal	800018c0 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	4f0040ef          	jal	8000485e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	506040ef          	jal	80004878 <plicinithart>
    binit();         // buffer cache
    80000376:	3d1010ef          	jal	80001f46 <binit>
    iinit();         // inode table
    8000037a:	156020ef          	jal	800024d0 <iinit>
    fileinit();      // file table
    8000037e:	048030ef          	jal	800033c6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	5e6040ef          	jal	80004968 <virtio_disk_init>
    userinit();      // first user process
    80000386:	4e7000ef          	jal	8000106c <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	e2f72023          	sw	a5,-480(a4) # 8000a1b0 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	0000a797          	auipc	a5,0xa
    800003a8:	e147b783          	ld	a5,-492(a5) # 8000a1b8 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	84aa                	mv	s1,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fc63          	bgeu	a5,a1,8000041c <walk+0x5a>
    panic("walk");
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	1ee050ef          	jal	800055de <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8263          	beqz	s5,80000458 <walk+0x96>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	84aa                	mv	s1,a0
    800003fe:	c139                	beqz	a0,80000444 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c4d793          	srli	a5,s1,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdbb0f>
    80000418:	036a0063          	beq	s4,s6,80000438 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041c:	0149d933          	srl	s2,s3,s4
    80000420:	1ff97913          	andi	s2,s2,511
    80000424:	090e                	slli	s2,s2,0x3
    80000426:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000428:	00093483          	ld	s1,0(s2)
    8000042c:	0014f793          	andi	a5,s1,1
    80000430:	d3f1                	beqz	a5,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000432:	80a9                	srli	s1,s1,0xa
    80000434:	04b2                	slli	s1,s1,0xc
    80000436:	b7c5                	j	80000416 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
        return 0;
    80000458:	4501                	li	a0,0
    8000045a:	b7ed                	j	80000444 <walk+0x82>

000000008000045c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000045c:	57fd                	li	a5,-1
    8000045e:	83e9                	srli	a5,a5,0x1a
    80000460:	00b7f463          	bgeu	a5,a1,80000468 <walkaddr+0xc>
    return 0;
    80000464:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000466:	8082                	ret
{
    80000468:	1141                	addi	sp,sp,-16
    8000046a:	e406                	sd	ra,8(sp)
    8000046c:	e022                	sd	s0,0(sp)
    8000046e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000470:	4601                	li	a2,0
    80000472:	f51ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000476:	c105                	beqz	a0,80000496 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000478:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000047a:	0117f693          	andi	a3,a5,17
    8000047e:	4745                	li	a4,17
    return 0;
    80000480:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000482:	00e68663          	beq	a3,a4,8000048e <walkaddr+0x32>
}
    80000486:	60a2                	ld	ra,8(sp)
    80000488:	6402                	ld	s0,0(sp)
    8000048a:	0141                	addi	sp,sp,16
    8000048c:	8082                	ret
  pa = PTE2PA(*pte);
    8000048e:	83a9                	srli	a5,a5,0xa
    80000490:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000494:	bfcd                	j	80000486 <walkaddr+0x2a>
    return 0;
    80000496:	4501                	li	a0,0
    80000498:	b7fd                	j	80000486 <walkaddr+0x2a>

000000008000049a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000049a:	715d                	addi	sp,sp,-80
    8000049c:	e486                	sd	ra,72(sp)
    8000049e:	e0a2                	sd	s0,64(sp)
    800004a0:	fc26                	sd	s1,56(sp)
    800004a2:	f84a                	sd	s2,48(sp)
    800004a4:	f44e                	sd	s3,40(sp)
    800004a6:	f052                	sd	s4,32(sp)
    800004a8:	ec56                	sd	s5,24(sp)
    800004aa:	e85a                	sd	s6,16(sp)
    800004ac:	e45e                	sd	s7,8(sp)
    800004ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004b0:	03459793          	slli	a5,a1,0x34
    800004b4:	e7a9                	bnez	a5,800004fe <mappages+0x64>
    800004b6:	8aaa                	mv	s5,a0
    800004b8:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004ba:	03461793          	slli	a5,a2,0x34
    800004be:	e7b1                	bnez	a5,8000050a <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004c0:	ca39                	beqz	a2,80000516 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004c2:	77fd                	lui	a5,0xfffff
    800004c4:	963e                	add	a2,a2,a5
    800004c6:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ca:	892e                	mv	s2,a1
    800004cc:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004d0:	6b85                	lui	s7,0x1
    800004d2:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004d6:	4605                	li	a2,1
    800004d8:	85ca                	mv	a1,s2
    800004da:	8556                	mv	a0,s5
    800004dc:	ee7ff0ef          	jal	800003c2 <walk>
    800004e0:	c539                	beqz	a0,8000052e <mappages+0x94>
    if(*pte & PTE_V)
    800004e2:	611c                	ld	a5,0(a0)
    800004e4:	8b85                	andi	a5,a5,1
    800004e6:	ef95                	bnez	a5,80000522 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004e8:	80b1                	srli	s1,s1,0xc
    800004ea:	04aa                	slli	s1,s1,0xa
    800004ec:	0164e4b3          	or	s1,s1,s6
    800004f0:	0014e493          	ori	s1,s1,1
    800004f4:	e104                	sd	s1,0(a0)
    if(a == last)
    800004f6:	05390863          	beq	s2,s3,80000546 <mappages+0xac>
    a += PGSIZE;
    800004fa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	bfd9                	j	800004d2 <mappages+0x38>
    panic("mappages: va not aligned");
    800004fe:	00007517          	auipc	a0,0x7
    80000502:	b5a50513          	addi	a0,a0,-1190 # 80007058 <etext+0x58>
    80000506:	0d8050ef          	jal	800055de <panic>
    panic("mappages: size not aligned");
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	0cc050ef          	jal	800055de <panic>
    panic("mappages: size");
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	0c0050ef          	jal	800055de <panic>
      panic("mappages: remap");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	0b4050ef          	jal	800055de <panic>
      return -1;
    8000052e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000530:	60a6                	ld	ra,72(sp)
    80000532:	6406                	ld	s0,64(sp)
    80000534:	74e2                	ld	s1,56(sp)
    80000536:	7942                	ld	s2,48(sp)
    80000538:	79a2                	ld	s3,40(sp)
    8000053a:	7a02                	ld	s4,32(sp)
    8000053c:	6ae2                	ld	s5,24(sp)
    8000053e:	6b42                	ld	s6,16(sp)
    80000540:	6ba2                	ld	s7,8(sp)
    80000542:	6161                	addi	sp,sp,80
    80000544:	8082                	ret
  return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7e5                	j	80000530 <mappages+0x96>

000000008000054a <kvmmap>:
{
    8000054a:	1141                	addi	sp,sp,-16
    8000054c:	e406                	sd	ra,8(sp)
    8000054e:	e022                	sd	s0,0(sp)
    80000550:	0800                	addi	s0,sp,16
    80000552:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000554:	86b2                	mv	a3,a2
    80000556:	863e                	mv	a2,a5
    80000558:	f43ff0ef          	jal	8000049a <mappages>
    8000055c:	e509                	bnez	a0,80000566 <kvmmap+0x1c>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
    panic("kvmmap");
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b5250513          	addi	a0,a0,-1198 # 800070b8 <etext+0xb8>
    8000056e:	070050ef          	jal	800055de <panic>

0000000080000572 <kvmmake>:
{
    80000572:	1101                	addi	sp,sp,-32
    80000574:	ec06                	sd	ra,24(sp)
    80000576:	e822                	sd	s0,16(sp)
    80000578:	e426                	sd	s1,8(sp)
    8000057a:	e04a                	sd	s2,0(sp)
    8000057c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000057e:	b81ff0ef          	jal	800000fe <kalloc>
    80000582:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000584:	6605                	lui	a2,0x1
    80000586:	4581                	li	a1,0
    80000588:	bc7ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000058c:	4719                	li	a4,6
    8000058e:	6685                	lui	a3,0x1
    80000590:	10000637          	lui	a2,0x10000
    80000594:	100005b7          	lui	a1,0x10000
    80000598:	8526                	mv	a0,s1
    8000059a:	fb1ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000059e:	4719                	li	a4,6
    800005a0:	6685                	lui	a3,0x1
    800005a2:	10001637          	lui	a2,0x10001
    800005a6:	100015b7          	lui	a1,0x10001
    800005aa:	8526                	mv	a0,s1
    800005ac:	f9fff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005b0:	4719                	li	a4,6
    800005b2:	040006b7          	lui	a3,0x4000
    800005b6:	0c000637          	lui	a2,0xc000
    800005ba:	0c0005b7          	lui	a1,0xc000
    800005be:	8526                	mv	a0,s1
    800005c0:	f8bff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005c4:	00007917          	auipc	s2,0x7
    800005c8:	a3c90913          	addi	s2,s2,-1476 # 80007000 <etext>
    800005cc:	4729                	li	a4,10
    800005ce:	80007697          	auipc	a3,0x80007
    800005d2:	a3268693          	addi	a3,a3,-1486 # 7000 <_entry-0x7fff9000>
    800005d6:	4605                	li	a2,1
    800005d8:	067e                	slli	a2,a2,0x1f
    800005da:	85b2                	mv	a1,a2
    800005dc:	8526                	mv	a0,s1
    800005de:	f6dff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e2:	46c5                	li	a3,17
    800005e4:	06ee                	slli	a3,a3,0x1b
    800005e6:	4719                	li	a4,6
    800005e8:	412686b3          	sub	a3,a3,s2
    800005ec:	864a                	mv	a2,s2
    800005ee:	85ca                	mv	a1,s2
    800005f0:	8526                	mv	a0,s1
    800005f2:	f59ff0ef          	jal	8000054a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005f6:	4729                	li	a4,10
    800005f8:	6685                	lui	a3,0x1
    800005fa:	00006617          	auipc	a2,0x6
    800005fe:	a0660613          	addi	a2,a2,-1530 # 80006000 <_trampoline>
    80000602:	040005b7          	lui	a1,0x4000
    80000606:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000608:	05b2                	slli	a1,a1,0xc
    8000060a:	8526                	mv	a0,s1
    8000060c:	f3fff0ef          	jal	8000054a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000610:	8526                	mv	a0,s1
    80000612:	61a000ef          	jal	80000c2c <proc_mapstacks>
}
    80000616:	8526                	mv	a0,s1
    80000618:	60e2                	ld	ra,24(sp)
    8000061a:	6442                	ld	s0,16(sp)
    8000061c:	64a2                	ld	s1,8(sp)
    8000061e:	6902                	ld	s2,0(sp)
    80000620:	6105                	addi	sp,sp,32
    80000622:	8082                	ret

0000000080000624 <kvminit>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000062c:	f47ff0ef          	jal	80000572 <kvmmake>
    80000630:	0000a797          	auipc	a5,0xa
    80000634:	b8a7b423          	sd	a0,-1144(a5) # 8000a1b8 <kernel_pagetable>
}
    80000638:	60a2                	ld	ra,8(sp)
    8000063a:	6402                	ld	s0,0(sp)
    8000063c:	0141                	addi	sp,sp,16
    8000063e:	8082                	ret

0000000080000640 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000640:	1101                	addi	sp,sp,-32
    80000642:	ec06                	sd	ra,24(sp)
    80000644:	e822                	sd	s0,16(sp)
    80000646:	e426                	sd	s1,8(sp)
    80000648:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000064a:	ab5ff0ef          	jal	800000fe <kalloc>
    8000064e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000650:	c509                	beqz	a0,8000065a <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000652:	6605                	lui	a2,0x1
    80000654:	4581                	li	a1,0
    80000656:	af9ff0ef          	jal	8000014e <memset>
  return pagetable;
}
    8000065a:	8526                	mv	a0,s1
    8000065c:	60e2                	ld	ra,24(sp)
    8000065e:	6442                	ld	s0,16(sp)
    80000660:	64a2                	ld	s1,8(sp)
    80000662:	6105                	addi	sp,sp,32
    80000664:	8082                	ret

0000000080000666 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000666:	715d                	addi	sp,sp,-80
    80000668:	e486                	sd	ra,72(sp)
    8000066a:	e0a2                	sd	s0,64(sp)
    8000066c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;

  if((va % PGSIZE) != 0)
    8000066e:	03459793          	slli	a5,a1,0x34
    80000672:	e39d                	bnez	a5,80000698 <uvmunmap+0x32>
    80000674:	f84a                	sd	s2,48(sp)
    80000676:	f44e                	sd	s3,40(sp)
    80000678:	f052                	sd	s4,32(sp)
    8000067a:	ec56                	sd	s5,24(sp)
    8000067c:	e85a                	sd	s6,16(sp)
    8000067e:	e45e                	sd	s7,8(sp)
    80000680:	8a2a                	mv	s4,a0
    80000682:	892e                	mv	s2,a1
    80000684:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000686:	0632                	slli	a2,a2,0xc
    80000688:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
      continue;
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
      continue;
    sz = PGSIZE;
    if(PTE_FLAGS(*pte) == PTE_V)
    8000068c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000068e:	6a85                	lui	s5,0x1
    80000690:	0735f463          	bgeu	a1,s3,800006f8 <uvmunmap+0x92>
    80000694:	fc26                	sd	s1,56(sp)
    80000696:	a80d                	j	800006c8 <uvmunmap+0x62>
    80000698:	fc26                	sd	s1,56(sp)
    8000069a:	f84a                	sd	s2,48(sp)
    8000069c:	f44e                	sd	s3,40(sp)
    8000069e:	f052                	sd	s4,32(sp)
    800006a0:	ec56                	sd	s5,24(sp)
    800006a2:	e85a                	sd	s6,16(sp)
    800006a4:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006a6:	00007517          	auipc	a0,0x7
    800006aa:	a1a50513          	addi	a0,a0,-1510 # 800070c0 <etext+0xc0>
    800006ae:	731040ef          	jal	800055de <panic>
      panic("uvmunmap: not a leaf");
    800006b2:	00007517          	auipc	a0,0x7
    800006b6:	a2650513          	addi	a0,a0,-1498 # 800070d8 <etext+0xd8>
    800006ba:	725040ef          	jal	800055de <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006be:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006c2:	9956                	add	s2,s2,s5
    800006c4:	03397963          	bgeu	s2,s3,800006f6 <uvmunmap+0x90>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006c8:	4601                	li	a2,0
    800006ca:	85ca                	mv	a1,s2
    800006cc:	8552                	mv	a0,s4
    800006ce:	cf5ff0ef          	jal	800003c2 <walk>
    800006d2:	84aa                	mv	s1,a0
    800006d4:	d57d                	beqz	a0,800006c2 <uvmunmap+0x5c>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006d6:	611c                	ld	a5,0(a0)
    800006d8:	0017f713          	andi	a4,a5,1
    800006dc:	d37d                	beqz	a4,800006c2 <uvmunmap+0x5c>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006de:	3ff7f713          	andi	a4,a5,1023
    800006e2:	fd7708e3          	beq	a4,s7,800006b2 <uvmunmap+0x4c>
    if(do_free){
    800006e6:	fc0b0ce3          	beqz	s6,800006be <uvmunmap+0x58>
      uint64 pa = PTE2PA(*pte);
    800006ea:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800006ec:	00c79513          	slli	a0,a5,0xc
    800006f0:	92dff0ef          	jal	8000001c <kfree>
    800006f4:	b7e9                	j	800006be <uvmunmap+0x58>
    800006f6:	74e2                	ld	s1,56(sp)
    800006f8:	7942                	ld	s2,48(sp)
    800006fa:	79a2                	ld	s3,40(sp)
    800006fc:	7a02                	ld	s4,32(sp)
    800006fe:	6ae2                	ld	s5,24(sp)
    80000700:	6b42                	ld	s6,16(sp)
    80000702:	6ba2                	ld	s7,8(sp)
  }
}
    80000704:	60a6                	ld	ra,72(sp)
    80000706:	6406                	ld	s0,64(sp)
    80000708:	6161                	addi	sp,sp,80
    8000070a:	8082                	ret

000000008000070c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000070c:	1101                	addi	sp,sp,-32
    8000070e:	ec06                	sd	ra,24(sp)
    80000710:	e822                	sd	s0,16(sp)
    80000712:	e426                	sd	s1,8(sp)
    80000714:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000716:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000718:	00b67d63          	bgeu	a2,a1,80000732 <uvmdealloc+0x26>
    8000071c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000071e:	6785                	lui	a5,0x1
    80000720:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000722:	00f60733          	add	a4,a2,a5
    80000726:	76fd                	lui	a3,0xfffff
    80000728:	8f75                	and	a4,a4,a3
    8000072a:	97ae                	add	a5,a5,a1
    8000072c:	8ff5                	and	a5,a5,a3
    8000072e:	00f76863          	bltu	a4,a5,8000073e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000732:	8526                	mv	a0,s1
    80000734:	60e2                	ld	ra,24(sp)
    80000736:	6442                	ld	s0,16(sp)
    80000738:	64a2                	ld	s1,8(sp)
    8000073a:	6105                	addi	sp,sp,32
    8000073c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000073e:	8f99                	sub	a5,a5,a4
    80000740:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000742:	4685                	li	a3,1
    80000744:	0007861b          	sext.w	a2,a5
    80000748:	85ba                	mv	a1,a4
    8000074a:	f1dff0ef          	jal	80000666 <uvmunmap>
    8000074e:	b7d5                	j	80000732 <uvmdealloc+0x26>

0000000080000750 <uvmalloc>:
  if(newsz < oldsz)
    80000750:	08b66f63          	bltu	a2,a1,800007ee <uvmalloc+0x9e>
{
    80000754:	7139                	addi	sp,sp,-64
    80000756:	fc06                	sd	ra,56(sp)
    80000758:	f822                	sd	s0,48(sp)
    8000075a:	ec4e                	sd	s3,24(sp)
    8000075c:	e852                	sd	s4,16(sp)
    8000075e:	e456                	sd	s5,8(sp)
    80000760:	0080                	addi	s0,sp,64
    80000762:	8aaa                	mv	s5,a0
    80000764:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000766:	6785                	lui	a5,0x1
    80000768:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000076a:	95be                	add	a1,a1,a5
    8000076c:	77fd                	lui	a5,0xfffff
    8000076e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    80000772:	08c9f063          	bgeu	s3,a2,800007f2 <uvmalloc+0xa2>
    80000776:	f426                	sd	s1,40(sp)
    80000778:	f04a                	sd	s2,32(sp)
    8000077a:	e05a                	sd	s6,0(sp)
    8000077c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000077e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000782:	97dff0ef          	jal	800000fe <kalloc>
    80000786:	84aa                	mv	s1,a0
    if(mem == 0){
    80000788:	c515                	beqz	a0,800007b4 <uvmalloc+0x64>
    memset(mem, 0, sz);
    8000078a:	6605                	lui	a2,0x1
    8000078c:	4581                	li	a1,0
    8000078e:	9c1ff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000792:	875a                	mv	a4,s6
    80000794:	86a6                	mv	a3,s1
    80000796:	6605                	lui	a2,0x1
    80000798:	85ca                	mv	a1,s2
    8000079a:	8556                	mv	a0,s5
    8000079c:	cffff0ef          	jal	8000049a <mappages>
    800007a0:	e915                	bnez	a0,800007d4 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += sz){
    800007a2:	6785                	lui	a5,0x1
    800007a4:	993e                	add	s2,s2,a5
    800007a6:	fd496ee3          	bltu	s2,s4,80000782 <uvmalloc+0x32>
  return newsz;
    800007aa:	8552                	mv	a0,s4
    800007ac:	74a2                	ld	s1,40(sp)
    800007ae:	7902                	ld	s2,32(sp)
    800007b0:	6b02                	ld	s6,0(sp)
    800007b2:	a811                	j	800007c6 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800007b4:	864e                	mv	a2,s3
    800007b6:	85ca                	mv	a1,s2
    800007b8:	8556                	mv	a0,s5
    800007ba:	f53ff0ef          	jal	8000070c <uvmdealloc>
      return 0;
    800007be:	4501                	li	a0,0
    800007c0:	74a2                	ld	s1,40(sp)
    800007c2:	7902                	ld	s2,32(sp)
    800007c4:	6b02                	ld	s6,0(sp)
}
    800007c6:	70e2                	ld	ra,56(sp)
    800007c8:	7442                	ld	s0,48(sp)
    800007ca:	69e2                	ld	s3,24(sp)
    800007cc:	6a42                	ld	s4,16(sp)
    800007ce:	6aa2                	ld	s5,8(sp)
    800007d0:	6121                	addi	sp,sp,64
    800007d2:	8082                	ret
      kfree(mem);
    800007d4:	8526                	mv	a0,s1
    800007d6:	847ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007da:	864e                	mv	a2,s3
    800007dc:	85ca                	mv	a1,s2
    800007de:	8556                	mv	a0,s5
    800007e0:	f2dff0ef          	jal	8000070c <uvmdealloc>
      return 0;
    800007e4:	4501                	li	a0,0
    800007e6:	74a2                	ld	s1,40(sp)
    800007e8:	7902                	ld	s2,32(sp)
    800007ea:	6b02                	ld	s6,0(sp)
    800007ec:	bfe9                	j	800007c6 <uvmalloc+0x76>
    return oldsz;
    800007ee:	852e                	mv	a0,a1
}
    800007f0:	8082                	ret
  return newsz;
    800007f2:	8532                	mv	a0,a2
    800007f4:	bfc9                	j	800007c6 <uvmalloc+0x76>

00000000800007f6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800007f6:	7179                	addi	sp,sp,-48
    800007f8:	f406                	sd	ra,40(sp)
    800007fa:	f022                	sd	s0,32(sp)
    800007fc:	ec26                	sd	s1,24(sp)
    800007fe:	e84a                	sd	s2,16(sp)
    80000800:	e44e                	sd	s3,8(sp)
    80000802:	e052                	sd	s4,0(sp)
    80000804:	1800                	addi	s0,sp,48
    80000806:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000808:	84aa                	mv	s1,a0
    8000080a:	6905                	lui	s2,0x1
    8000080c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000080e:	4985                	li	s3,1
    80000810:	a819                	j	80000826 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000812:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000814:	00c79513          	slli	a0,a5,0xc
    80000818:	fdfff0ef          	jal	800007f6 <freewalk>
      pagetable[i] = 0;
    8000081c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000820:	04a1                	addi	s1,s1,8
    80000822:	01248f63          	beq	s1,s2,80000840 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000826:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000828:	00f7f713          	andi	a4,a5,15
    8000082c:	ff3703e3          	beq	a4,s3,80000812 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000830:	8b85                	andi	a5,a5,1
    80000832:	d7fd                	beqz	a5,80000820 <freewalk+0x2a>
      // backtrace();
      panic("freewalk: leaf");
    80000834:	00007517          	auipc	a0,0x7
    80000838:	8bc50513          	addi	a0,a0,-1860 # 800070f0 <etext+0xf0>
    8000083c:	5a3040ef          	jal	800055de <panic>
    }
  }
  kfree((void*)pagetable);
    80000840:	8552                	mv	a0,s4
    80000842:	fdaff0ef          	jal	8000001c <kfree>
}
    80000846:	70a2                	ld	ra,40(sp)
    80000848:	7402                	ld	s0,32(sp)
    8000084a:	64e2                	ld	s1,24(sp)
    8000084c:	6942                	ld	s2,16(sp)
    8000084e:	69a2                	ld	s3,8(sp)
    80000850:	6a02                	ld	s4,0(sp)
    80000852:	6145                	addi	sp,sp,48
    80000854:	8082                	ret

0000000080000856 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000856:	1101                	addi	sp,sp,-32
    80000858:	ec06                	sd	ra,24(sp)
    8000085a:	e822                	sd	s0,16(sp)
    8000085c:	e426                	sd	s1,8(sp)
    8000085e:	1000                	addi	s0,sp,32
    80000860:	84aa                	mv	s1,a0
  if(sz > 0)
    80000862:	e989                	bnez	a1,80000874 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000864:	8526                	mv	a0,s1
    80000866:	f91ff0ef          	jal	800007f6 <freewalk>
}
    8000086a:	60e2                	ld	ra,24(sp)
    8000086c:	6442                	ld	s0,16(sp)
    8000086e:	64a2                	ld	s1,8(sp)
    80000870:	6105                	addi	sp,sp,32
    80000872:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000874:	6785                	lui	a5,0x1
    80000876:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000878:	95be                	add	a1,a1,a5
    8000087a:	4685                	li	a3,1
    8000087c:	00c5d613          	srli	a2,a1,0xc
    80000880:	4581                	li	a1,0
    80000882:	de5ff0ef          	jal	80000666 <uvmunmap>
    80000886:	bff9                	j	80000864 <uvmfree+0xe>

0000000080000888 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc = PGSIZE;

  for(i = 0; i < sz; i += szinc){
    80000888:	ce49                	beqz	a2,80000922 <uvmcopy+0x9a>
{
    8000088a:	715d                	addi	sp,sp,-80
    8000088c:	e486                	sd	ra,72(sp)
    8000088e:	e0a2                	sd	s0,64(sp)
    80000890:	fc26                	sd	s1,56(sp)
    80000892:	f84a                	sd	s2,48(sp)
    80000894:	f44e                	sd	s3,40(sp)
    80000896:	f052                	sd	s4,32(sp)
    80000898:	ec56                	sd	s5,24(sp)
    8000089a:	e85a                	sd	s6,16(sp)
    8000089c:	e45e                	sd	s7,8(sp)
    8000089e:	0880                	addi	s0,sp,80
    800008a0:	8aaa                	mv	s5,a0
    800008a2:	8b2e                	mv	s6,a1
    800008a4:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    800008a6:	4481                	li	s1,0
    800008a8:	a029                	j	800008b2 <uvmcopy+0x2a>
    800008aa:	6785                	lui	a5,0x1
    800008ac:	94be                	add	s1,s1,a5
    800008ae:	0544fe63          	bgeu	s1,s4,8000090a <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    800008b2:	4601                	li	a2,0
    800008b4:	85a6                	mv	a1,s1
    800008b6:	8556                	mv	a0,s5
    800008b8:	b0bff0ef          	jal	800003c2 <walk>
    800008bc:	d57d                	beqz	a0,800008aa <uvmcopy+0x22>
      continue;
    if((*pte & PTE_V) == 0) {
    800008be:	6118                	ld	a4,0(a0)
    800008c0:	00177793          	andi	a5,a4,1
    800008c4:	d3fd                	beqz	a5,800008aa <uvmcopy+0x22>
      continue;
    }
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    800008c6:	00a75593          	srli	a1,a4,0xa
    800008ca:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800008ce:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    800008d2:	82dff0ef          	jal	800000fe <kalloc>
    800008d6:	89aa                	mv	s3,a0
    800008d8:	c105                	beqz	a0,800008f8 <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008da:	6605                	lui	a2,0x1
    800008dc:	85de                	mv	a1,s7
    800008de:	8cdff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008e2:	874a                	mv	a4,s2
    800008e4:	86ce                	mv	a3,s3
    800008e6:	6605                	lui	a2,0x1
    800008e8:	85a6                	mv	a1,s1
    800008ea:	855a                	mv	a0,s6
    800008ec:	bafff0ef          	jal	8000049a <mappages>
    800008f0:	dd4d                	beqz	a0,800008aa <uvmcopy+0x22>
      kfree(mem);
    800008f2:	854e                	mv	a0,s3
    800008f4:	f28ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800008f8:	4685                	li	a3,1
    800008fa:	00c4d613          	srli	a2,s1,0xc
    800008fe:	4581                	li	a1,0
    80000900:	855a                	mv	a0,s6
    80000902:	d65ff0ef          	jal	80000666 <uvmunmap>
  return -1;
    80000906:	557d                	li	a0,-1
    80000908:	a011                	j	8000090c <uvmcopy+0x84>
  return 0;
    8000090a:	4501                	li	a0,0
}
    8000090c:	60a6                	ld	ra,72(sp)
    8000090e:	6406                	ld	s0,64(sp)
    80000910:	74e2                	ld	s1,56(sp)
    80000912:	7942                	ld	s2,48(sp)
    80000914:	79a2                	ld	s3,40(sp)
    80000916:	7a02                	ld	s4,32(sp)
    80000918:	6ae2                	ld	s5,24(sp)
    8000091a:	6b42                	ld	s6,16(sp)
    8000091c:	6ba2                	ld	s7,8(sp)
    8000091e:	6161                	addi	sp,sp,80
    80000920:	8082                	ret
  return 0;
    80000922:	4501                	li	a0,0
}
    80000924:	8082                	ret

0000000080000926 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000926:	1141                	addi	sp,sp,-16
    80000928:	e406                	sd	ra,8(sp)
    8000092a:	e022                	sd	s0,0(sp)
    8000092c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000092e:	4601                	li	a2,0
    80000930:	a93ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000934:	c901                	beqz	a0,80000944 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000936:	611c                	ld	a5,0(a0)
    80000938:	9bbd                	andi	a5,a5,-17
    8000093a:	e11c                	sd	a5,0(a0)
}
    8000093c:	60a2                	ld	ra,8(sp)
    8000093e:	6402                	ld	s0,0(sp)
    80000940:	0141                	addi	sp,sp,16
    80000942:	8082                	ret
    panic("uvmclear");
    80000944:	00006517          	auipc	a0,0x6
    80000948:	7bc50513          	addi	a0,a0,1980 # 80007100 <etext+0x100>
    8000094c:	493040ef          	jal	800055de <panic>

0000000080000950 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000950:	c6dd                	beqz	a3,800009fe <copyinstr+0xae>
{
    80000952:	715d                	addi	sp,sp,-80
    80000954:	e486                	sd	ra,72(sp)
    80000956:	e0a2                	sd	s0,64(sp)
    80000958:	fc26                	sd	s1,56(sp)
    8000095a:	f84a                	sd	s2,48(sp)
    8000095c:	f44e                	sd	s3,40(sp)
    8000095e:	f052                	sd	s4,32(sp)
    80000960:	ec56                	sd	s5,24(sp)
    80000962:	e85a                	sd	s6,16(sp)
    80000964:	e45e                	sd	s7,8(sp)
    80000966:	0880                	addi	s0,sp,80
    80000968:	8a2a                	mv	s4,a0
    8000096a:	8b2e                	mv	s6,a1
    8000096c:	8bb2                	mv	s7,a2
    8000096e:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000970:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000972:	6985                	lui	s3,0x1
    80000974:	a825                	j	800009ac <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000976:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000097a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000097c:	37fd                	addiw	a5,a5,-1
    8000097e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000982:	60a6                	ld	ra,72(sp)
    80000984:	6406                	ld	s0,64(sp)
    80000986:	74e2                	ld	s1,56(sp)
    80000988:	7942                	ld	s2,48(sp)
    8000098a:	79a2                	ld	s3,40(sp)
    8000098c:	7a02                	ld	s4,32(sp)
    8000098e:	6ae2                	ld	s5,24(sp)
    80000990:	6b42                	ld	s6,16(sp)
    80000992:	6ba2                	ld	s7,8(sp)
    80000994:	6161                	addi	sp,sp,80
    80000996:	8082                	ret
    80000998:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    8000099c:	9742                	add	a4,a4,a6
      --max;
    8000099e:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    800009a2:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    800009a6:	04e58463          	beq	a1,a4,800009ee <copyinstr+0x9e>
{
    800009aa:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    800009ac:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800009b0:	85a6                	mv	a1,s1
    800009b2:	8552                	mv	a0,s4
    800009b4:	aa9ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    800009b8:	cd0d                	beqz	a0,800009f2 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800009ba:	417486b3          	sub	a3,s1,s7
    800009be:	96ce                	add	a3,a3,s3
    if(n > max)
    800009c0:	00d97363          	bgeu	s2,a3,800009c6 <copyinstr+0x76>
    800009c4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800009c6:	955e                	add	a0,a0,s7
    800009c8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    800009ca:	c695                	beqz	a3,800009f6 <copyinstr+0xa6>
    800009cc:	87da                	mv	a5,s6
    800009ce:	885a                	mv	a6,s6
      if(*p == '\0'){
    800009d0:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800009d4:	96da                	add	a3,a3,s6
    800009d6:	85be                	mv	a1,a5
      if(*p == '\0'){
    800009d8:	00f60733          	add	a4,a2,a5
    800009dc:	00074703          	lbu	a4,0(a4)
    800009e0:	db59                	beqz	a4,80000976 <copyinstr+0x26>
        *dst = *p;
    800009e2:	00e78023          	sb	a4,0(a5)
      dst++;
    800009e6:	0785                	addi	a5,a5,1
    while(n > 0){
    800009e8:	fed797e3          	bne	a5,a3,800009d6 <copyinstr+0x86>
    800009ec:	b775                	j	80000998 <copyinstr+0x48>
    800009ee:	4781                	li	a5,0
    800009f0:	b771                	j	8000097c <copyinstr+0x2c>
      return -1;
    800009f2:	557d                	li	a0,-1
    800009f4:	b779                	j	80000982 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800009f6:	6b85                	lui	s7,0x1
    800009f8:	9ba6                	add	s7,s7,s1
    800009fa:	87da                	mv	a5,s6
    800009fc:	b77d                	j	800009aa <copyinstr+0x5a>
  int got_null = 0;
    800009fe:	4781                	li	a5,0
  if(got_null){
    80000a00:	37fd                	addiw	a5,a5,-1
    80000a02:	0007851b          	sext.w	a0,a5
}
    80000a06:	8082                	ret

0000000080000a08 <ismapped>:
  }
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va) {
    80000a08:	1141                	addi	sp,sp,-16
    80000a0a:	e406                	sd	ra,8(sp)
    80000a0c:	e022                	sd	s0,0(sp)
    80000a0e:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000a10:	4601                	li	a2,0
    80000a12:	9b1ff0ef          	jal	800003c2 <walk>
  if (pte == 0) {
    80000a16:	c519                	beqz	a0,80000a24 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    80000a18:	6108                	ld	a0,0(a0)
    80000a1a:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a1c:	60a2                	ld	ra,8(sp)
    80000a1e:	6402                	ld	s0,0(sp)
    80000a20:	0141                	addi	sp,sp,16
    80000a22:	8082                	ret
    return 0;
    80000a24:	4501                	li	a0,0
    80000a26:	bfdd                	j	80000a1c <ismapped+0x14>

0000000080000a28 <vmfault>:
{
    80000a28:	7179                	addi	sp,sp,-48
    80000a2a:	f406                	sd	ra,40(sp)
    80000a2c:	f022                	sd	s0,32(sp)
    80000a2e:	ec26                	sd	s1,24(sp)
    80000a30:	e44e                	sd	s3,8(sp)
    80000a32:	1800                	addi	s0,sp,48
    80000a34:	89aa                	mv	s3,a0
    80000a36:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80000a38:	36e000ef          	jal	80000da6 <myproc>
  if (va >= p->sz)
    80000a3c:	653c                	ld	a5,72(a0)
    80000a3e:	00f4ea63          	bltu	s1,a5,80000a52 <vmfault+0x2a>
    return 0;
    80000a42:	4981                	li	s3,0
}
    80000a44:	854e                	mv	a0,s3
    80000a46:	70a2                	ld	ra,40(sp)
    80000a48:	7402                	ld	s0,32(sp)
    80000a4a:	64e2                	ld	s1,24(sp)
    80000a4c:	69a2                	ld	s3,8(sp)
    80000a4e:	6145                	addi	sp,sp,48
    80000a50:	8082                	ret
    80000a52:	e84a                	sd	s2,16(sp)
    80000a54:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80000a56:	77fd                	lui	a5,0xfffff
    80000a58:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    80000a5a:	85a6                	mv	a1,s1
    80000a5c:	854e                	mv	a0,s3
    80000a5e:	fabff0ef          	jal	80000a08 <ismapped>
    return 0;
    80000a62:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a64:	c119                	beqz	a0,80000a6a <vmfault+0x42>
    80000a66:	6942                	ld	s2,16(sp)
    80000a68:	bff1                	j	80000a44 <vmfault+0x1c>
    80000a6a:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    80000a6c:	e92ff0ef          	jal	800000fe <kalloc>
    80000a70:	8a2a                	mv	s4,a0
  if(mem == 0)
    80000a72:	c90d                	beqz	a0,80000aa4 <vmfault+0x7c>
  mem = (uint64) kalloc();
    80000a74:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a76:	6605                	lui	a2,0x1
    80000a78:	4581                	li	a1,0
    80000a7a:	ed4ff0ef          	jal	8000014e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a7e:	4759                	li	a4,22
    80000a80:	86d2                	mv	a3,s4
    80000a82:	6605                	lui	a2,0x1
    80000a84:	85a6                	mv	a1,s1
    80000a86:	05093503          	ld	a0,80(s2)
    80000a8a:	a11ff0ef          	jal	8000049a <mappages>
    80000a8e:	e501                	bnez	a0,80000a96 <vmfault+0x6e>
    80000a90:	6942                	ld	s2,16(sp)
    80000a92:	6a02                	ld	s4,0(sp)
    80000a94:	bf45                	j	80000a44 <vmfault+0x1c>
    kfree((void *)mem);
    80000a96:	8552                	mv	a0,s4
    80000a98:	d84ff0ef          	jal	8000001c <kfree>
    return 0;
    80000a9c:	4981                	li	s3,0
    80000a9e:	6942                	ld	s2,16(sp)
    80000aa0:	6a02                	ld	s4,0(sp)
    80000aa2:	b74d                	j	80000a44 <vmfault+0x1c>
    80000aa4:	6942                	ld	s2,16(sp)
    80000aa6:	6a02                	ld	s4,0(sp)
    80000aa8:	bf71                	j	80000a44 <vmfault+0x1c>

0000000080000aaa <copyout>:
  while(len > 0){
    80000aaa:	c2d5                	beqz	a3,80000b4e <copyout+0xa4>
{
    80000aac:	711d                	addi	sp,sp,-96
    80000aae:	ec86                	sd	ra,88(sp)
    80000ab0:	e8a2                	sd	s0,80(sp)
    80000ab2:	e4a6                	sd	s1,72(sp)
    80000ab4:	f852                	sd	s4,48(sp)
    80000ab6:	f456                	sd	s5,40(sp)
    80000ab8:	f05a                	sd	s6,32(sp)
    80000aba:	ec5e                	sd	s7,24(sp)
    80000abc:	1080                	addi	s0,sp,96
    80000abe:	8baa                	mv	s7,a0
    80000ac0:	8aae                	mv	s5,a1
    80000ac2:	8b32                	mv	s6,a2
    80000ac4:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000ac6:	74fd                	lui	s1,0xfffff
    80000ac8:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000aca:	57fd                	li	a5,-1
    80000acc:	83e9                	srli	a5,a5,0x1a
    80000ace:	0897e263          	bltu	a5,s1,80000b52 <copyout+0xa8>
    80000ad2:	e0ca                	sd	s2,64(sp)
    80000ad4:	fc4e                	sd	s3,56(sp)
    80000ad6:	e862                	sd	s8,16(sp)
    80000ad8:	e466                	sd	s9,8(sp)
    80000ada:	e06a                	sd	s10,0(sp)
    80000adc:	6c85                	lui	s9,0x1
    80000ade:	8c3e                	mv	s8,a5
    80000ae0:	a015                	j	80000b04 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ae2:	409a8533          	sub	a0,s5,s1
    80000ae6:	0009861b          	sext.w	a2,s3
    80000aea:	85da                	mv	a1,s6
    80000aec:	954a                	add	a0,a0,s2
    80000aee:	ebcff0ef          	jal	800001aa <memmove>
    len -= n;
    80000af2:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000af6:	9b4e                	add	s6,s6,s3
  while(len > 0){
    80000af8:	040a0463          	beqz	s4,80000b40 <copyout+0x96>
    if (va0 >= MAXVA)
    80000afc:	05ac6d63          	bltu	s8,s10,80000b56 <copyout+0xac>
    80000b00:	84ea                	mv	s1,s10
    80000b02:	8aea                	mv	s5,s10
    pa0 = walkaddr(pagetable, va0);
    80000b04:	85a6                	mv	a1,s1
    80000b06:	855e                	mv	a0,s7
    80000b08:	955ff0ef          	jal	8000045c <walkaddr>
    80000b0c:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80000b0e:	e901                	bnez	a0,80000b1e <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000b10:	4601                	li	a2,0
    80000b12:	85a6                	mv	a1,s1
    80000b14:	855e                	mv	a0,s7
    80000b16:	f13ff0ef          	jal	80000a28 <vmfault>
    80000b1a:	892a                	mv	s2,a0
    80000b1c:	c521                	beqz	a0,80000b64 <copyout+0xba>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000b1e:	4601                	li	a2,0
    80000b20:	85a6                	mv	a1,s1
    80000b22:	855e                	mv	a0,s7
    80000b24:	89fff0ef          	jal	800003c2 <walk>
    80000b28:	c529                	beqz	a0,80000b72 <copyout+0xc8>
    if((*pte & PTE_W) == 0)
    80000b2a:	611c                	ld	a5,0(a0)
    80000b2c:	8b91                	andi	a5,a5,4
    80000b2e:	c3ad                	beqz	a5,80000b90 <copyout+0xe6>
    n = PGSIZE - (dstva - va0);
    80000b30:	01948d33          	add	s10,s1,s9
    80000b34:	415d09b3          	sub	s3,s10,s5
    if(n > len)
    80000b38:	fb3a75e3          	bgeu	s4,s3,80000ae2 <copyout+0x38>
    80000b3c:	89d2                	mv	s3,s4
    80000b3e:	b755                	j	80000ae2 <copyout+0x38>
  return 0;
    80000b40:	4501                	li	a0,0
    80000b42:	6906                	ld	s2,64(sp)
    80000b44:	79e2                	ld	s3,56(sp)
    80000b46:	6c42                	ld	s8,16(sp)
    80000b48:	6ca2                	ld	s9,8(sp)
    80000b4a:	6d02                	ld	s10,0(sp)
    80000b4c:	a80d                	j	80000b7e <copyout+0xd4>
    80000b4e:	4501                	li	a0,0
}
    80000b50:	8082                	ret
      return -1;
    80000b52:	557d                	li	a0,-1
    80000b54:	a02d                	j	80000b7e <copyout+0xd4>
    80000b56:	557d                	li	a0,-1
    80000b58:	6906                	ld	s2,64(sp)
    80000b5a:	79e2                	ld	s3,56(sp)
    80000b5c:	6c42                	ld	s8,16(sp)
    80000b5e:	6ca2                	ld	s9,8(sp)
    80000b60:	6d02                	ld	s10,0(sp)
    80000b62:	a831                	j	80000b7e <copyout+0xd4>
        return -1;
    80000b64:	557d                	li	a0,-1
    80000b66:	6906                	ld	s2,64(sp)
    80000b68:	79e2                	ld	s3,56(sp)
    80000b6a:	6c42                	ld	s8,16(sp)
    80000b6c:	6ca2                	ld	s9,8(sp)
    80000b6e:	6d02                	ld	s10,0(sp)
    80000b70:	a039                	j	80000b7e <copyout+0xd4>
      return -1;
    80000b72:	557d                	li	a0,-1
    80000b74:	6906                	ld	s2,64(sp)
    80000b76:	79e2                	ld	s3,56(sp)
    80000b78:	6c42                	ld	s8,16(sp)
    80000b7a:	6ca2                	ld	s9,8(sp)
    80000b7c:	6d02                	ld	s10,0(sp)
}
    80000b7e:	60e6                	ld	ra,88(sp)
    80000b80:	6446                	ld	s0,80(sp)
    80000b82:	64a6                	ld	s1,72(sp)
    80000b84:	7a42                	ld	s4,48(sp)
    80000b86:	7aa2                	ld	s5,40(sp)
    80000b88:	7b02                	ld	s6,32(sp)
    80000b8a:	6be2                	ld	s7,24(sp)
    80000b8c:	6125                	addi	sp,sp,96
    80000b8e:	8082                	ret
      return -1;
    80000b90:	557d                	li	a0,-1
    80000b92:	6906                	ld	s2,64(sp)
    80000b94:	79e2                	ld	s3,56(sp)
    80000b96:	6c42                	ld	s8,16(sp)
    80000b98:	6ca2                	ld	s9,8(sp)
    80000b9a:	6d02                	ld	s10,0(sp)
    80000b9c:	b7cd                	j	80000b7e <copyout+0xd4>

0000000080000b9e <copyin>:
  while(len > 0){
    80000b9e:	c6c9                	beqz	a3,80000c28 <copyin+0x8a>
{
    80000ba0:	715d                	addi	sp,sp,-80
    80000ba2:	e486                	sd	ra,72(sp)
    80000ba4:	e0a2                	sd	s0,64(sp)
    80000ba6:	fc26                	sd	s1,56(sp)
    80000ba8:	f84a                	sd	s2,48(sp)
    80000baa:	f44e                	sd	s3,40(sp)
    80000bac:	f052                	sd	s4,32(sp)
    80000bae:	ec56                	sd	s5,24(sp)
    80000bb0:	e85a                	sd	s6,16(sp)
    80000bb2:	e45e                	sd	s7,8(sp)
    80000bb4:	e062                	sd	s8,0(sp)
    80000bb6:	0880                	addi	s0,sp,80
    80000bb8:	8baa                	mv	s7,a0
    80000bba:	8aae                	mv	s5,a1
    80000bbc:	8932                	mv	s2,a2
    80000bbe:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc0:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000bc2:	6b05                	lui	s6,0x1
    80000bc4:	a035                	j	80000bf0 <copyin+0x52>
    80000bc6:	412984b3          	sub	s1,s3,s2
    80000bca:	94da                	add	s1,s1,s6
    if(n > len)
    80000bcc:	009a7363          	bgeu	s4,s1,80000bd2 <copyin+0x34>
    80000bd0:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bd2:	413905b3          	sub	a1,s2,s3
    80000bd6:	0004861b          	sext.w	a2,s1
    80000bda:	95aa                	add	a1,a1,a0
    80000bdc:	8556                	mv	a0,s5
    80000bde:	dccff0ef          	jal	800001aa <memmove>
    len -= n;
    80000be2:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000be6:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000be8:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000bec:	020a0163          	beqz	s4,80000c0e <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000bf0:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000bf4:	85ce                	mv	a1,s3
    80000bf6:	855e                	mv	a0,s7
    80000bf8:	865ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0) {
    80000bfc:	f569                	bnez	a0,80000bc6 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000bfe:	4601                	li	a2,0
    80000c00:	85ce                	mv	a1,s3
    80000c02:	855e                	mv	a0,s7
    80000c04:	e25ff0ef          	jal	80000a28 <vmfault>
    80000c08:	fd5d                	bnez	a0,80000bc6 <copyin+0x28>
        return -1;
    80000c0a:	557d                	li	a0,-1
    80000c0c:	a011                	j	80000c10 <copyin+0x72>
  return 0;
    80000c0e:	4501                	li	a0,0
}
    80000c10:	60a6                	ld	ra,72(sp)
    80000c12:	6406                	ld	s0,64(sp)
    80000c14:	74e2                	ld	s1,56(sp)
    80000c16:	7942                	ld	s2,48(sp)
    80000c18:	79a2                	ld	s3,40(sp)
    80000c1a:	7a02                	ld	s4,32(sp)
    80000c1c:	6ae2                	ld	s5,24(sp)
    80000c1e:	6b42                	ld	s6,16(sp)
    80000c20:	6ba2                	ld	s7,8(sp)
    80000c22:	6c02                	ld	s8,0(sp)
    80000c24:	6161                	addi	sp,sp,80
    80000c26:	8082                	ret
  return 0;
    80000c28:	4501                	li	a0,0
}
    80000c2a:	8082                	ret

0000000080000c2c <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c2c:	7139                	addi	sp,sp,-64
    80000c2e:	fc06                	sd	ra,56(sp)
    80000c30:	f822                	sd	s0,48(sp)
    80000c32:	f426                	sd	s1,40(sp)
    80000c34:	f04a                	sd	s2,32(sp)
    80000c36:	ec4e                	sd	s3,24(sp)
    80000c38:	e852                	sd	s4,16(sp)
    80000c3a:	e456                	sd	s5,8(sp)
    80000c3c:	e05a                	sd	s6,0(sp)
    80000c3e:	0080                	addi	s0,sp,64
    80000c40:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c42:	0000a497          	auipc	s1,0xa
    80000c46:	9ee48493          	addi	s1,s1,-1554 # 8000a630 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c4a:	8b26                	mv	s6,s1
    80000c4c:	04fa5937          	lui	s2,0x4fa5
    80000c50:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c54:	0932                	slli	s2,s2,0xc
    80000c56:	fa590913          	addi	s2,s2,-91
    80000c5a:	0932                	slli	s2,s2,0xc
    80000c5c:	fa590913          	addi	s2,s2,-91
    80000c60:	0932                	slli	s2,s2,0xc
    80000c62:	fa590913          	addi	s2,s2,-91
    80000c66:	040009b7          	lui	s3,0x4000
    80000c6a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c6c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c6e:	0000fa97          	auipc	s5,0xf
    80000c72:	3c2a8a93          	addi	s5,s5,962 # 80010030 <tickslock>
    char *pa = kalloc();
    80000c76:	c88ff0ef          	jal	800000fe <kalloc>
    80000c7a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c7c:	cd15                	beqz	a0,80000cb8 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c7e:	416485b3          	sub	a1,s1,s6
    80000c82:	858d                	srai	a1,a1,0x3
    80000c84:	032585b3          	mul	a1,a1,s2
    80000c88:	2585                	addiw	a1,a1,1
    80000c8a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c8e:	4719                	li	a4,6
    80000c90:	6685                	lui	a3,0x1
    80000c92:	40b985b3          	sub	a1,s3,a1
    80000c96:	8552                	mv	a0,s4
    80000c98:	8b3ff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c9c:	16848493          	addi	s1,s1,360
    80000ca0:	fd549be3          	bne	s1,s5,80000c76 <proc_mapstacks+0x4a>
  }
}
    80000ca4:	70e2                	ld	ra,56(sp)
    80000ca6:	7442                	ld	s0,48(sp)
    80000ca8:	74a2                	ld	s1,40(sp)
    80000caa:	7902                	ld	s2,32(sp)
    80000cac:	69e2                	ld	s3,24(sp)
    80000cae:	6a42                	ld	s4,16(sp)
    80000cb0:	6aa2                	ld	s5,8(sp)
    80000cb2:	6b02                	ld	s6,0(sp)
    80000cb4:	6121                	addi	sp,sp,64
    80000cb6:	8082                	ret
      panic("kalloc");
    80000cb8:	00006517          	auipc	a0,0x6
    80000cbc:	45850513          	addi	a0,a0,1112 # 80007110 <etext+0x110>
    80000cc0:	11f040ef          	jal	800055de <panic>

0000000080000cc4 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cc4:	7139                	addi	sp,sp,-64
    80000cc6:	fc06                	sd	ra,56(sp)
    80000cc8:	f822                	sd	s0,48(sp)
    80000cca:	f426                	sd	s1,40(sp)
    80000ccc:	f04a                	sd	s2,32(sp)
    80000cce:	ec4e                	sd	s3,24(sp)
    80000cd0:	e852                	sd	s4,16(sp)
    80000cd2:	e456                	sd	s5,8(sp)
    80000cd4:	e05a                	sd	s6,0(sp)
    80000cd6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cd8:	00006597          	auipc	a1,0x6
    80000cdc:	44058593          	addi	a1,a1,1088 # 80007118 <etext+0x118>
    80000ce0:	00009517          	auipc	a0,0x9
    80000ce4:	52050513          	addi	a0,a0,1312 # 8000a200 <pid_lock>
    80000ce8:	333040ef          	jal	8000581a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cec:	00006597          	auipc	a1,0x6
    80000cf0:	43458593          	addi	a1,a1,1076 # 80007120 <etext+0x120>
    80000cf4:	00009517          	auipc	a0,0x9
    80000cf8:	52450513          	addi	a0,a0,1316 # 8000a218 <wait_lock>
    80000cfc:	31f040ef          	jal	8000581a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d00:	0000a497          	auipc	s1,0xa
    80000d04:	93048493          	addi	s1,s1,-1744 # 8000a630 <proc>
      initlock(&p->lock, "proc");
    80000d08:	00006b17          	auipc	s6,0x6
    80000d0c:	428b0b13          	addi	s6,s6,1064 # 80007130 <etext+0x130>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d10:	8aa6                	mv	s5,s1
    80000d12:	04fa5937          	lui	s2,0x4fa5
    80000d16:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d1a:	0932                	slli	s2,s2,0xc
    80000d1c:	fa590913          	addi	s2,s2,-91
    80000d20:	0932                	slli	s2,s2,0xc
    80000d22:	fa590913          	addi	s2,s2,-91
    80000d26:	0932                	slli	s2,s2,0xc
    80000d28:	fa590913          	addi	s2,s2,-91
    80000d2c:	040009b7          	lui	s3,0x4000
    80000d30:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d32:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d34:	0000fa17          	auipc	s4,0xf
    80000d38:	2fca0a13          	addi	s4,s4,764 # 80010030 <tickslock>
      initlock(&p->lock, "proc");
    80000d3c:	85da                	mv	a1,s6
    80000d3e:	8526                	mv	a0,s1
    80000d40:	2db040ef          	jal	8000581a <initlock>
      p->state = UNUSED;
    80000d44:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d48:	415487b3          	sub	a5,s1,s5
    80000d4c:	878d                	srai	a5,a5,0x3
    80000d4e:	032787b3          	mul	a5,a5,s2
    80000d52:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffdbb19>
    80000d54:	00d7979b          	slliw	a5,a5,0xd
    80000d58:	40f987b3          	sub	a5,s3,a5
    80000d5c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d5e:	16848493          	addi	s1,s1,360
    80000d62:	fd449de3          	bne	s1,s4,80000d3c <procinit+0x78>
  }
}
    80000d66:	70e2                	ld	ra,56(sp)
    80000d68:	7442                	ld	s0,48(sp)
    80000d6a:	74a2                	ld	s1,40(sp)
    80000d6c:	7902                	ld	s2,32(sp)
    80000d6e:	69e2                	ld	s3,24(sp)
    80000d70:	6a42                	ld	s4,16(sp)
    80000d72:	6aa2                	ld	s5,8(sp)
    80000d74:	6b02                	ld	s6,0(sp)
    80000d76:	6121                	addi	sp,sp,64
    80000d78:	8082                	ret

0000000080000d7a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d7a:	1141                	addi	sp,sp,-16
    80000d7c:	e422                	sd	s0,8(sp)
    80000d7e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d80:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d82:	2501                	sext.w	a0,a0
    80000d84:	6422                	ld	s0,8(sp)
    80000d86:	0141                	addi	sp,sp,16
    80000d88:	8082                	ret

0000000080000d8a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e422                	sd	s0,8(sp)
    80000d8e:	0800                	addi	s0,sp,16
    80000d90:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d92:	2781                	sext.w	a5,a5
    80000d94:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d96:	00009517          	auipc	a0,0x9
    80000d9a:	49a50513          	addi	a0,a0,1178 # 8000a230 <cpus>
    80000d9e:	953e                	add	a0,a0,a5
    80000da0:	6422                	ld	s0,8(sp)
    80000da2:	0141                	addi	sp,sp,16
    80000da4:	8082                	ret

0000000080000da6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000da6:	1101                	addi	sp,sp,-32
    80000da8:	ec06                	sd	ra,24(sp)
    80000daa:	e822                	sd	s0,16(sp)
    80000dac:	e426                	sd	s1,8(sp)
    80000dae:	1000                	addi	s0,sp,32
  push_off();
    80000db0:	2ab040ef          	jal	8000585a <push_off>
    80000db4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000db6:	2781                	sext.w	a5,a5
    80000db8:	079e                	slli	a5,a5,0x7
    80000dba:	00009717          	auipc	a4,0x9
    80000dbe:	44670713          	addi	a4,a4,1094 # 8000a200 <pid_lock>
    80000dc2:	97ba                	add	a5,a5,a4
    80000dc4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000dc6:	319040ef          	jal	800058de <pop_off>
  return p;
}
    80000dca:	8526                	mv	a0,s1
    80000dcc:	60e2                	ld	ra,24(sp)
    80000dce:	6442                	ld	s0,16(sp)
    80000dd0:	64a2                	ld	s1,8(sp)
    80000dd2:	6105                	addi	sp,sp,32
    80000dd4:	8082                	ret

0000000080000dd6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dd6:	7179                	addi	sp,sp,-48
    80000dd8:	f406                	sd	ra,40(sp)
    80000dda:	f022                	sd	s0,32(sp)
    80000ddc:	ec26                	sd	s1,24(sp)
    80000dde:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000de0:	fc7ff0ef          	jal	80000da6 <myproc>
    80000de4:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000de6:	34d040ef          	jal	80005932 <release>

  if (first) {
    80000dea:	00009797          	auipc	a5,0x9
    80000dee:	3967a783          	lw	a5,918(a5) # 8000a180 <first.1>
    80000df2:	cf8d                	beqz	a5,80000e2c <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000df4:	4505                	li	a0,1
    80000df6:	397010ef          	jal	8000298c <fsinit>

    first = 0;
    80000dfa:	00009797          	auipc	a5,0x9
    80000dfe:	3807a323          	sw	zero,902(a5) # 8000a180 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000e02:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000e06:	00006517          	auipc	a0,0x6
    80000e0a:	33250513          	addi	a0,a0,818 # 80007138 <etext+0x138>
    80000e0e:	fca43823          	sd	a0,-48(s0)
    80000e12:	fc043c23          	sd	zero,-40(s0)
    80000e16:	fd040593          	addi	a1,s0,-48
    80000e1a:	473020ef          	jal	80003a8c <kexec>
    80000e1e:	6cbc                	ld	a5,88(s1)
    80000e20:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000e22:	6cbc                	ld	a5,88(s1)
    80000e24:	7bb8                	ld	a4,112(a5)
    80000e26:	57fd                	li	a5,-1
    80000e28:	02f70d63          	beq	a4,a5,80000e62 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e2c:	2ad000ef          	jal	800018d8 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e30:	68a8                	ld	a0,80(s1)
    80000e32:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e34:	04000737          	lui	a4,0x4000
    80000e38:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e3a:	0732                	slli	a4,a4,0xc
    80000e3c:	00005797          	auipc	a5,0x5
    80000e40:	26078793          	addi	a5,a5,608 # 8000609c <userret>
    80000e44:	00005697          	auipc	a3,0x5
    80000e48:	1bc68693          	addi	a3,a3,444 # 80006000 <_trampoline>
    80000e4c:	8f95                	sub	a5,a5,a3
    80000e4e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e50:	577d                	li	a4,-1
    80000e52:	177e                	slli	a4,a4,0x3f
    80000e54:	8d59                	or	a0,a0,a4
    80000e56:	9782                	jalr	a5
}
    80000e58:	70a2                	ld	ra,40(sp)
    80000e5a:	7402                	ld	s0,32(sp)
    80000e5c:	64e2                	ld	s1,24(sp)
    80000e5e:	6145                	addi	sp,sp,48
    80000e60:	8082                	ret
      panic("exec");
    80000e62:	00006517          	auipc	a0,0x6
    80000e66:	2de50513          	addi	a0,a0,734 # 80007140 <etext+0x140>
    80000e6a:	774040ef          	jal	800055de <panic>

0000000080000e6e <allocpid>:
{
    80000e6e:	1101                	addi	sp,sp,-32
    80000e70:	ec06                	sd	ra,24(sp)
    80000e72:	e822                	sd	s0,16(sp)
    80000e74:	e426                	sd	s1,8(sp)
    80000e76:	e04a                	sd	s2,0(sp)
    80000e78:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e7a:	00009917          	auipc	s2,0x9
    80000e7e:	38690913          	addi	s2,s2,902 # 8000a200 <pid_lock>
    80000e82:	854a                	mv	a0,s2
    80000e84:	217040ef          	jal	8000589a <acquire>
  pid = nextpid;
    80000e88:	00009797          	auipc	a5,0x9
    80000e8c:	2fc78793          	addi	a5,a5,764 # 8000a184 <nextpid>
    80000e90:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e92:	0014871b          	addiw	a4,s1,1
    80000e96:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e98:	854a                	mv	a0,s2
    80000e9a:	299040ef          	jal	80005932 <release>
}
    80000e9e:	8526                	mv	a0,s1
    80000ea0:	60e2                	ld	ra,24(sp)
    80000ea2:	6442                	ld	s0,16(sp)
    80000ea4:	64a2                	ld	s1,8(sp)
    80000ea6:	6902                	ld	s2,0(sp)
    80000ea8:	6105                	addi	sp,sp,32
    80000eaa:	8082                	ret

0000000080000eac <proc_pagetable>:
{
    80000eac:	1101                	addi	sp,sp,-32
    80000eae:	ec06                	sd	ra,24(sp)
    80000eb0:	e822                	sd	s0,16(sp)
    80000eb2:	e426                	sd	s1,8(sp)
    80000eb4:	e04a                	sd	s2,0(sp)
    80000eb6:	1000                	addi	s0,sp,32
    80000eb8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000eba:	f86ff0ef          	jal	80000640 <uvmcreate>
    80000ebe:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000ec0:	cd05                	beqz	a0,80000ef8 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000ec2:	4729                	li	a4,10
    80000ec4:	00005697          	auipc	a3,0x5
    80000ec8:	13c68693          	addi	a3,a3,316 # 80006000 <_trampoline>
    80000ecc:	6605                	lui	a2,0x1
    80000ece:	040005b7          	lui	a1,0x4000
    80000ed2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ed4:	05b2                	slli	a1,a1,0xc
    80000ed6:	dc4ff0ef          	jal	8000049a <mappages>
    80000eda:	02054663          	bltz	a0,80000f06 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000ede:	4719                	li	a4,6
    80000ee0:	05893683          	ld	a3,88(s2)
    80000ee4:	6605                	lui	a2,0x1
    80000ee6:	020005b7          	lui	a1,0x2000
    80000eea:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eec:	05b6                	slli	a1,a1,0xd
    80000eee:	8526                	mv	a0,s1
    80000ef0:	daaff0ef          	jal	8000049a <mappages>
    80000ef4:	00054f63          	bltz	a0,80000f12 <proc_pagetable+0x66>
}
    80000ef8:	8526                	mv	a0,s1
    80000efa:	60e2                	ld	ra,24(sp)
    80000efc:	6442                	ld	s0,16(sp)
    80000efe:	64a2                	ld	s1,8(sp)
    80000f00:	6902                	ld	s2,0(sp)
    80000f02:	6105                	addi	sp,sp,32
    80000f04:	8082                	ret
    uvmfree(pagetable, 0);
    80000f06:	4581                	li	a1,0
    80000f08:	8526                	mv	a0,s1
    80000f0a:	94dff0ef          	jal	80000856 <uvmfree>
    return 0;
    80000f0e:	4481                	li	s1,0
    80000f10:	b7e5                	j	80000ef8 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f12:	4681                	li	a3,0
    80000f14:	4605                	li	a2,1
    80000f16:	040005b7          	lui	a1,0x4000
    80000f1a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f1c:	05b2                	slli	a1,a1,0xc
    80000f1e:	8526                	mv	a0,s1
    80000f20:	f46ff0ef          	jal	80000666 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f24:	4581                	li	a1,0
    80000f26:	8526                	mv	a0,s1
    80000f28:	92fff0ef          	jal	80000856 <uvmfree>
    return 0;
    80000f2c:	4481                	li	s1,0
    80000f2e:	b7e9                	j	80000ef8 <proc_pagetable+0x4c>

0000000080000f30 <proc_freepagetable>:
{
    80000f30:	1101                	addi	sp,sp,-32
    80000f32:	ec06                	sd	ra,24(sp)
    80000f34:	e822                	sd	s0,16(sp)
    80000f36:	e426                	sd	s1,8(sp)
    80000f38:	e04a                	sd	s2,0(sp)
    80000f3a:	1000                	addi	s0,sp,32
    80000f3c:	84aa                	mv	s1,a0
    80000f3e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f40:	4681                	li	a3,0
    80000f42:	4605                	li	a2,1
    80000f44:	040005b7          	lui	a1,0x4000
    80000f48:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f4a:	05b2                	slli	a1,a1,0xc
    80000f4c:	f1aff0ef          	jal	80000666 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f50:	4681                	li	a3,0
    80000f52:	4605                	li	a2,1
    80000f54:	020005b7          	lui	a1,0x2000
    80000f58:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f5a:	05b6                	slli	a1,a1,0xd
    80000f5c:	8526                	mv	a0,s1
    80000f5e:	f08ff0ef          	jal	80000666 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f62:	85ca                	mv	a1,s2
    80000f64:	8526                	mv	a0,s1
    80000f66:	8f1ff0ef          	jal	80000856 <uvmfree>
}
    80000f6a:	60e2                	ld	ra,24(sp)
    80000f6c:	6442                	ld	s0,16(sp)
    80000f6e:	64a2                	ld	s1,8(sp)
    80000f70:	6902                	ld	s2,0(sp)
    80000f72:	6105                	addi	sp,sp,32
    80000f74:	8082                	ret

0000000080000f76 <freeproc>:
{
    80000f76:	1101                	addi	sp,sp,-32
    80000f78:	ec06                	sd	ra,24(sp)
    80000f7a:	e822                	sd	s0,16(sp)
    80000f7c:	e426                	sd	s1,8(sp)
    80000f7e:	1000                	addi	s0,sp,32
    80000f80:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f82:	6d28                	ld	a0,88(a0)
    80000f84:	c119                	beqz	a0,80000f8a <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f86:	896ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f8a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f8e:	68a8                	ld	a0,80(s1)
    80000f90:	c501                	beqz	a0,80000f98 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f92:	64ac                	ld	a1,72(s1)
    80000f94:	f9dff0ef          	jal	80000f30 <proc_freepagetable>
  p->pagetable = 0;
    80000f98:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f9c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000fa0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000fa4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000fa8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000fac:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000fb0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000fb4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000fb8:	0004ac23          	sw	zero,24(s1)
}
    80000fbc:	60e2                	ld	ra,24(sp)
    80000fbe:	6442                	ld	s0,16(sp)
    80000fc0:	64a2                	ld	s1,8(sp)
    80000fc2:	6105                	addi	sp,sp,32
    80000fc4:	8082                	ret

0000000080000fc6 <allocproc>:
{
    80000fc6:	1101                	addi	sp,sp,-32
    80000fc8:	ec06                	sd	ra,24(sp)
    80000fca:	e822                	sd	s0,16(sp)
    80000fcc:	e426                	sd	s1,8(sp)
    80000fce:	e04a                	sd	s2,0(sp)
    80000fd0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fd2:	00009497          	auipc	s1,0x9
    80000fd6:	65e48493          	addi	s1,s1,1630 # 8000a630 <proc>
    80000fda:	0000f917          	auipc	s2,0xf
    80000fde:	05690913          	addi	s2,s2,86 # 80010030 <tickslock>
    acquire(&p->lock);
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	0b7040ef          	jal	8000589a <acquire>
    if(p->state == UNUSED) {
    80000fe8:	4c9c                	lw	a5,24(s1)
    80000fea:	cb91                	beqz	a5,80000ffe <allocproc+0x38>
      release(&p->lock);
    80000fec:	8526                	mv	a0,s1
    80000fee:	145040ef          	jal	80005932 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff2:	16848493          	addi	s1,s1,360
    80000ff6:	ff2496e3          	bne	s1,s2,80000fe2 <allocproc+0x1c>
  return 0;
    80000ffa:	4481                	li	s1,0
    80000ffc:	a089                	j	8000103e <allocproc+0x78>
  p->pid = allocpid();
    80000ffe:	e71ff0ef          	jal	80000e6e <allocpid>
    80001002:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001004:	4785                	li	a5,1
    80001006:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001008:	8f6ff0ef          	jal	800000fe <kalloc>
    8000100c:	892a                	mv	s2,a0
    8000100e:	eca8                	sd	a0,88(s1)
    80001010:	cd15                	beqz	a0,8000104c <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001012:	8526                	mv	a0,s1
    80001014:	e99ff0ef          	jal	80000eac <proc_pagetable>
    80001018:	892a                	mv	s2,a0
    8000101a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000101c:	c121                	beqz	a0,8000105c <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    8000101e:	07000613          	li	a2,112
    80001022:	4581                	li	a1,0
    80001024:	06048513          	addi	a0,s1,96
    80001028:	926ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    8000102c:	00000797          	auipc	a5,0x0
    80001030:	daa78793          	addi	a5,a5,-598 # 80000dd6 <forkret>
    80001034:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001036:	60bc                	ld	a5,64(s1)
    80001038:	6705                	lui	a4,0x1
    8000103a:	97ba                	add	a5,a5,a4
    8000103c:	f4bc                	sd	a5,104(s1)
}
    8000103e:	8526                	mv	a0,s1
    80001040:	60e2                	ld	ra,24(sp)
    80001042:	6442                	ld	s0,16(sp)
    80001044:	64a2                	ld	s1,8(sp)
    80001046:	6902                	ld	s2,0(sp)
    80001048:	6105                	addi	sp,sp,32
    8000104a:	8082                	ret
    freeproc(p);
    8000104c:	8526                	mv	a0,s1
    8000104e:	f29ff0ef          	jal	80000f76 <freeproc>
    release(&p->lock);
    80001052:	8526                	mv	a0,s1
    80001054:	0df040ef          	jal	80005932 <release>
    return 0;
    80001058:	84ca                	mv	s1,s2
    8000105a:	b7d5                	j	8000103e <allocproc+0x78>
    freeproc(p);
    8000105c:	8526                	mv	a0,s1
    8000105e:	f19ff0ef          	jal	80000f76 <freeproc>
    release(&p->lock);
    80001062:	8526                	mv	a0,s1
    80001064:	0cf040ef          	jal	80005932 <release>
    return 0;
    80001068:	84ca                	mv	s1,s2
    8000106a:	bfd1                	j	8000103e <allocproc+0x78>

000000008000106c <userinit>:
{
    8000106c:	1101                	addi	sp,sp,-32
    8000106e:	ec06                	sd	ra,24(sp)
    80001070:	e822                	sd	s0,16(sp)
    80001072:	e426                	sd	s1,8(sp)
    80001074:	1000                	addi	s0,sp,32
  p = allocproc();
    80001076:	f51ff0ef          	jal	80000fc6 <allocproc>
    8000107a:	84aa                	mv	s1,a0
  initproc = p;
    8000107c:	00009797          	auipc	a5,0x9
    80001080:	14a7b223          	sd	a0,324(a5) # 8000a1c0 <initproc>
  p->cwd = namei("/");
    80001084:	00006517          	auipc	a0,0x6
    80001088:	0c450513          	addi	a0,a0,196 # 80007148 <etext+0x148>
    8000108c:	623010ef          	jal	80002eae <namei>
    80001090:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001094:	478d                	li	a5,3
    80001096:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001098:	8526                	mv	a0,s1
    8000109a:	099040ef          	jal	80005932 <release>
}
    8000109e:	60e2                	ld	ra,24(sp)
    800010a0:	6442                	ld	s0,16(sp)
    800010a2:	64a2                	ld	s1,8(sp)
    800010a4:	6105                	addi	sp,sp,32
    800010a6:	8082                	ret

00000000800010a8 <growproc>:
{
    800010a8:	1101                	addi	sp,sp,-32
    800010aa:	ec06                	sd	ra,24(sp)
    800010ac:	e822                	sd	s0,16(sp)
    800010ae:	e426                	sd	s1,8(sp)
    800010b0:	e04a                	sd	s2,0(sp)
    800010b2:	1000                	addi	s0,sp,32
    800010b4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800010b6:	cf1ff0ef          	jal	80000da6 <myproc>
    800010ba:	84aa                	mv	s1,a0
  sz = p->sz;
    800010bc:	652c                	ld	a1,72(a0)
  if(n > 0){
    800010be:	01204c63          	bgtz	s2,800010d6 <growproc+0x2e>
  } else if(n < 0){
    800010c2:	02094463          	bltz	s2,800010ea <growproc+0x42>
  p->sz = sz;
    800010c6:	e4ac                	sd	a1,72(s1)
  return 0;
    800010c8:	4501                	li	a0,0
}
    800010ca:	60e2                	ld	ra,24(sp)
    800010cc:	6442                	ld	s0,16(sp)
    800010ce:	64a2                	ld	s1,8(sp)
    800010d0:	6902                	ld	s2,0(sp)
    800010d2:	6105                	addi	sp,sp,32
    800010d4:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010d6:	4691                	li	a3,4
    800010d8:	00b90633          	add	a2,s2,a1
    800010dc:	6928                	ld	a0,80(a0)
    800010de:	e72ff0ef          	jal	80000750 <uvmalloc>
    800010e2:	85aa                	mv	a1,a0
    800010e4:	f16d                	bnez	a0,800010c6 <growproc+0x1e>
      return -1;
    800010e6:	557d                	li	a0,-1
    800010e8:	b7cd                	j	800010ca <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010ea:	00b90633          	add	a2,s2,a1
    800010ee:	6928                	ld	a0,80(a0)
    800010f0:	e1cff0ef          	jal	8000070c <uvmdealloc>
    800010f4:	85aa                	mv	a1,a0
    800010f6:	bfc1                	j	800010c6 <growproc+0x1e>

00000000800010f8 <kfork>:
{
    800010f8:	7139                	addi	sp,sp,-64
    800010fa:	fc06                	sd	ra,56(sp)
    800010fc:	f822                	sd	s0,48(sp)
    800010fe:	f04a                	sd	s2,32(sp)
    80001100:	e456                	sd	s5,8(sp)
    80001102:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001104:	ca3ff0ef          	jal	80000da6 <myproc>
    80001108:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000110a:	ebdff0ef          	jal	80000fc6 <allocproc>
    8000110e:	0e050a63          	beqz	a0,80001202 <kfork+0x10a>
    80001112:	e852                	sd	s4,16(sp)
    80001114:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001116:	048ab603          	ld	a2,72(s5)
    8000111a:	692c                	ld	a1,80(a0)
    8000111c:	050ab503          	ld	a0,80(s5)
    80001120:	f68ff0ef          	jal	80000888 <uvmcopy>
    80001124:	04054a63          	bltz	a0,80001178 <kfork+0x80>
    80001128:	f426                	sd	s1,40(sp)
    8000112a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000112c:	048ab783          	ld	a5,72(s5)
    80001130:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001134:	058ab683          	ld	a3,88(s5)
    80001138:	87b6                	mv	a5,a3
    8000113a:	058a3703          	ld	a4,88(s4)
    8000113e:	12068693          	addi	a3,a3,288
    80001142:	0007b803          	ld	a6,0(a5)
    80001146:	6788                	ld	a0,8(a5)
    80001148:	6b8c                	ld	a1,16(a5)
    8000114a:	6f90                	ld	a2,24(a5)
    8000114c:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001150:	e708                	sd	a0,8(a4)
    80001152:	eb0c                	sd	a1,16(a4)
    80001154:	ef10                	sd	a2,24(a4)
    80001156:	02078793          	addi	a5,a5,32
    8000115a:	02070713          	addi	a4,a4,32
    8000115e:	fed792e3          	bne	a5,a3,80001142 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001162:	058a3783          	ld	a5,88(s4)
    80001166:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000116a:	0d0a8493          	addi	s1,s5,208
    8000116e:	0d0a0913          	addi	s2,s4,208
    80001172:	150a8993          	addi	s3,s5,336
    80001176:	a831                	j	80001192 <kfork+0x9a>
    freeproc(np);
    80001178:	8552                	mv	a0,s4
    8000117a:	dfdff0ef          	jal	80000f76 <freeproc>
    release(&np->lock);
    8000117e:	8552                	mv	a0,s4
    80001180:	7b2040ef          	jal	80005932 <release>
    return -1;
    80001184:	597d                	li	s2,-1
    80001186:	6a42                	ld	s4,16(sp)
    80001188:	a0b5                	j	800011f4 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000118a:	04a1                	addi	s1,s1,8
    8000118c:	0921                	addi	s2,s2,8
    8000118e:	01348963          	beq	s1,s3,800011a0 <kfork+0xa8>
    if(p->ofile[i])
    80001192:	6088                	ld	a0,0(s1)
    80001194:	d97d                	beqz	a0,8000118a <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001196:	2b2020ef          	jal	80003448 <filedup>
    8000119a:	00a93023          	sd	a0,0(s2)
    8000119e:	b7f5                	j	8000118a <kfork+0x92>
  np->cwd = idup(p->cwd);
    800011a0:	150ab503          	ld	a0,336(s5)
    800011a4:	4be010ef          	jal	80002662 <idup>
    800011a8:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800011ac:	4641                	li	a2,16
    800011ae:	158a8593          	addi	a1,s5,344
    800011b2:	158a0513          	addi	a0,s4,344
    800011b6:	8d6ff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    800011ba:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800011be:	8552                	mv	a0,s4
    800011c0:	772040ef          	jal	80005932 <release>
  acquire(&wait_lock);
    800011c4:	00009497          	auipc	s1,0x9
    800011c8:	05448493          	addi	s1,s1,84 # 8000a218 <wait_lock>
    800011cc:	8526                	mv	a0,s1
    800011ce:	6cc040ef          	jal	8000589a <acquire>
  np->parent = p;
    800011d2:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800011d6:	8526                	mv	a0,s1
    800011d8:	75a040ef          	jal	80005932 <release>
  acquire(&np->lock);
    800011dc:	8552                	mv	a0,s4
    800011de:	6bc040ef          	jal	8000589a <acquire>
  np->state = RUNNABLE;
    800011e2:	478d                	li	a5,3
    800011e4:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800011e8:	8552                	mv	a0,s4
    800011ea:	748040ef          	jal	80005932 <release>
  return pid;
    800011ee:	74a2                	ld	s1,40(sp)
    800011f0:	69e2                	ld	s3,24(sp)
    800011f2:	6a42                	ld	s4,16(sp)
}
    800011f4:	854a                	mv	a0,s2
    800011f6:	70e2                	ld	ra,56(sp)
    800011f8:	7442                	ld	s0,48(sp)
    800011fa:	7902                	ld	s2,32(sp)
    800011fc:	6aa2                	ld	s5,8(sp)
    800011fe:	6121                	addi	sp,sp,64
    80001200:	8082                	ret
    return -1;
    80001202:	597d                	li	s2,-1
    80001204:	bfc5                	j	800011f4 <kfork+0xfc>

0000000080001206 <scheduler>:
{
    80001206:	715d                	addi	sp,sp,-80
    80001208:	e486                	sd	ra,72(sp)
    8000120a:	e0a2                	sd	s0,64(sp)
    8000120c:	fc26                	sd	s1,56(sp)
    8000120e:	f84a                	sd	s2,48(sp)
    80001210:	f44e                	sd	s3,40(sp)
    80001212:	f052                	sd	s4,32(sp)
    80001214:	ec56                	sd	s5,24(sp)
    80001216:	e85a                	sd	s6,16(sp)
    80001218:	e45e                	sd	s7,8(sp)
    8000121a:	e062                	sd	s8,0(sp)
    8000121c:	0880                	addi	s0,sp,80
    8000121e:	8792                	mv	a5,tp
  int id = r_tp();
    80001220:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001222:	00779b13          	slli	s6,a5,0x7
    80001226:	00009717          	auipc	a4,0x9
    8000122a:	fda70713          	addi	a4,a4,-38 # 8000a200 <pid_lock>
    8000122e:	975a                	add	a4,a4,s6
    80001230:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001234:	00009717          	auipc	a4,0x9
    80001238:	00470713          	addi	a4,a4,4 # 8000a238 <cpus+0x8>
    8000123c:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000123e:	4c11                	li	s8,4
        c->proc = p;
    80001240:	079e                	slli	a5,a5,0x7
    80001242:	00009a17          	auipc	s4,0x9
    80001246:	fbea0a13          	addi	s4,s4,-66 # 8000a200 <pid_lock>
    8000124a:	9a3e                	add	s4,s4,a5
        found = 1;
    8000124c:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    8000124e:	0000f997          	auipc	s3,0xf
    80001252:	de298993          	addi	s3,s3,-542 # 80010030 <tickslock>
    80001256:	a83d                	j	80001294 <scheduler+0x8e>
      release(&p->lock);
    80001258:	8526                	mv	a0,s1
    8000125a:	6d8040ef          	jal	80005932 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000125e:	16848493          	addi	s1,s1,360
    80001262:	03348563          	beq	s1,s3,8000128c <scheduler+0x86>
      acquire(&p->lock);
    80001266:	8526                	mv	a0,s1
    80001268:	632040ef          	jal	8000589a <acquire>
      if(p->state == RUNNABLE) {
    8000126c:	4c9c                	lw	a5,24(s1)
    8000126e:	ff2795e3          	bne	a5,s2,80001258 <scheduler+0x52>
        p->state = RUNNING;
    80001272:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001276:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000127a:	06048593          	addi	a1,s1,96
    8000127e:	855a                	mv	a0,s6
    80001280:	5b2000ef          	jal	80001832 <swtch>
        c->proc = 0;
    80001284:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001288:	8ade                	mv	s5,s7
    8000128a:	b7f9                	j	80001258 <scheduler+0x52>
    if(found == 0) {
    8000128c:	000a9463          	bnez	s5,80001294 <scheduler+0x8e>
      asm volatile("wfi");
    80001290:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001294:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001298:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000129c:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800012a4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012a6:	10079073          	csrw	sstatus,a5
    int found = 0;
    800012aa:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800012ac:	00009497          	auipc	s1,0x9
    800012b0:	38448493          	addi	s1,s1,900 # 8000a630 <proc>
      if(p->state == RUNNABLE) {
    800012b4:	490d                	li	s2,3
    800012b6:	bf45                	j	80001266 <scheduler+0x60>

00000000800012b8 <sched>:
{
    800012b8:	7179                	addi	sp,sp,-48
    800012ba:	f406                	sd	ra,40(sp)
    800012bc:	f022                	sd	s0,32(sp)
    800012be:	ec26                	sd	s1,24(sp)
    800012c0:	e84a                	sd	s2,16(sp)
    800012c2:	e44e                	sd	s3,8(sp)
    800012c4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012c6:	ae1ff0ef          	jal	80000da6 <myproc>
    800012ca:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012cc:	564040ef          	jal	80005830 <holding>
    800012d0:	c92d                	beqz	a0,80001342 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012d2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012d4:	2781                	sext.w	a5,a5
    800012d6:	079e                	slli	a5,a5,0x7
    800012d8:	00009717          	auipc	a4,0x9
    800012dc:	f2870713          	addi	a4,a4,-216 # 8000a200 <pid_lock>
    800012e0:	97ba                	add	a5,a5,a4
    800012e2:	0a87a703          	lw	a4,168(a5)
    800012e6:	4785                	li	a5,1
    800012e8:	06f71363          	bne	a4,a5,8000134e <sched+0x96>
  if(p->state == RUNNING)
    800012ec:	4c98                	lw	a4,24(s1)
    800012ee:	4791                	li	a5,4
    800012f0:	06f70563          	beq	a4,a5,8000135a <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012f4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012f8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012fa:	e7b5                	bnez	a5,80001366 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012fc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012fe:	00009917          	auipc	s2,0x9
    80001302:	f0290913          	addi	s2,s2,-254 # 8000a200 <pid_lock>
    80001306:	2781                	sext.w	a5,a5
    80001308:	079e                	slli	a5,a5,0x7
    8000130a:	97ca                	add	a5,a5,s2
    8000130c:	0ac7a983          	lw	s3,172(a5)
    80001310:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001312:	2781                	sext.w	a5,a5
    80001314:	079e                	slli	a5,a5,0x7
    80001316:	00009597          	auipc	a1,0x9
    8000131a:	f2258593          	addi	a1,a1,-222 # 8000a238 <cpus+0x8>
    8000131e:	95be                	add	a1,a1,a5
    80001320:	06048513          	addi	a0,s1,96
    80001324:	50e000ef          	jal	80001832 <swtch>
    80001328:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000132a:	2781                	sext.w	a5,a5
    8000132c:	079e                	slli	a5,a5,0x7
    8000132e:	993e                	add	s2,s2,a5
    80001330:	0b392623          	sw	s3,172(s2)
}
    80001334:	70a2                	ld	ra,40(sp)
    80001336:	7402                	ld	s0,32(sp)
    80001338:	64e2                	ld	s1,24(sp)
    8000133a:	6942                	ld	s2,16(sp)
    8000133c:	69a2                	ld	s3,8(sp)
    8000133e:	6145                	addi	sp,sp,48
    80001340:	8082                	ret
    panic("sched p->lock");
    80001342:	00006517          	auipc	a0,0x6
    80001346:	e0e50513          	addi	a0,a0,-498 # 80007150 <etext+0x150>
    8000134a:	294040ef          	jal	800055de <panic>
    panic("sched locks");
    8000134e:	00006517          	auipc	a0,0x6
    80001352:	e1250513          	addi	a0,a0,-494 # 80007160 <etext+0x160>
    80001356:	288040ef          	jal	800055de <panic>
    panic("sched RUNNING");
    8000135a:	00006517          	auipc	a0,0x6
    8000135e:	e1650513          	addi	a0,a0,-490 # 80007170 <etext+0x170>
    80001362:	27c040ef          	jal	800055de <panic>
    panic("sched interruptible");
    80001366:	00006517          	auipc	a0,0x6
    8000136a:	e1a50513          	addi	a0,a0,-486 # 80007180 <etext+0x180>
    8000136e:	270040ef          	jal	800055de <panic>

0000000080001372 <yield>:
{
    80001372:	1101                	addi	sp,sp,-32
    80001374:	ec06                	sd	ra,24(sp)
    80001376:	e822                	sd	s0,16(sp)
    80001378:	e426                	sd	s1,8(sp)
    8000137a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000137c:	a2bff0ef          	jal	80000da6 <myproc>
    80001380:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001382:	518040ef          	jal	8000589a <acquire>
  p->state = RUNNABLE;
    80001386:	478d                	li	a5,3
    80001388:	cc9c                	sw	a5,24(s1)
  sched();
    8000138a:	f2fff0ef          	jal	800012b8 <sched>
  release(&p->lock);
    8000138e:	8526                	mv	a0,s1
    80001390:	5a2040ef          	jal	80005932 <release>
}
    80001394:	60e2                	ld	ra,24(sp)
    80001396:	6442                	ld	s0,16(sp)
    80001398:	64a2                	ld	s1,8(sp)
    8000139a:	6105                	addi	sp,sp,32
    8000139c:	8082                	ret

000000008000139e <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000139e:	7179                	addi	sp,sp,-48
    800013a0:	f406                	sd	ra,40(sp)
    800013a2:	f022                	sd	s0,32(sp)
    800013a4:	ec26                	sd	s1,24(sp)
    800013a6:	e84a                	sd	s2,16(sp)
    800013a8:	e44e                	sd	s3,8(sp)
    800013aa:	1800                	addi	s0,sp,48
    800013ac:	89aa                	mv	s3,a0
    800013ae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013b0:	9f7ff0ef          	jal	80000da6 <myproc>
    800013b4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013b6:	4e4040ef          	jal	8000589a <acquire>
  release(lk);
    800013ba:	854a                	mv	a0,s2
    800013bc:	576040ef          	jal	80005932 <release>

  // Go to sleep.
  p->chan = chan;
    800013c0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013c4:	4789                	li	a5,2
    800013c6:	cc9c                	sw	a5,24(s1)

  sched();
    800013c8:	ef1ff0ef          	jal	800012b8 <sched>

  // Tidy up.
  p->chan = 0;
    800013cc:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013d0:	8526                	mv	a0,s1
    800013d2:	560040ef          	jal	80005932 <release>
  acquire(lk);
    800013d6:	854a                	mv	a0,s2
    800013d8:	4c2040ef          	jal	8000589a <acquire>
}
    800013dc:	70a2                	ld	ra,40(sp)
    800013de:	7402                	ld	s0,32(sp)
    800013e0:	64e2                	ld	s1,24(sp)
    800013e2:	6942                	ld	s2,16(sp)
    800013e4:	69a2                	ld	s3,8(sp)
    800013e6:	6145                	addi	sp,sp,48
    800013e8:	8082                	ret

00000000800013ea <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013ea:	7139                	addi	sp,sp,-64
    800013ec:	fc06                	sd	ra,56(sp)
    800013ee:	f822                	sd	s0,48(sp)
    800013f0:	f426                	sd	s1,40(sp)
    800013f2:	f04a                	sd	s2,32(sp)
    800013f4:	ec4e                	sd	s3,24(sp)
    800013f6:	e852                	sd	s4,16(sp)
    800013f8:	e456                	sd	s5,8(sp)
    800013fa:	0080                	addi	s0,sp,64
    800013fc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013fe:	00009497          	auipc	s1,0x9
    80001402:	23248493          	addi	s1,s1,562 # 8000a630 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001406:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001408:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000140a:	0000f917          	auipc	s2,0xf
    8000140e:	c2690913          	addi	s2,s2,-986 # 80010030 <tickslock>
    80001412:	a801                	j	80001422 <wakeup+0x38>
      }
      release(&p->lock);
    80001414:	8526                	mv	a0,s1
    80001416:	51c040ef          	jal	80005932 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000141a:	16848493          	addi	s1,s1,360
    8000141e:	03248263          	beq	s1,s2,80001442 <wakeup+0x58>
    if(p != myproc()){
    80001422:	985ff0ef          	jal	80000da6 <myproc>
    80001426:	fea48ae3          	beq	s1,a0,8000141a <wakeup+0x30>
      acquire(&p->lock);
    8000142a:	8526                	mv	a0,s1
    8000142c:	46e040ef          	jal	8000589a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001430:	4c9c                	lw	a5,24(s1)
    80001432:	ff3791e3          	bne	a5,s3,80001414 <wakeup+0x2a>
    80001436:	709c                	ld	a5,32(s1)
    80001438:	fd479ee3          	bne	a5,s4,80001414 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000143c:	0154ac23          	sw	s5,24(s1)
    80001440:	bfd1                	j	80001414 <wakeup+0x2a>
    }
  }
}
    80001442:	70e2                	ld	ra,56(sp)
    80001444:	7442                	ld	s0,48(sp)
    80001446:	74a2                	ld	s1,40(sp)
    80001448:	7902                	ld	s2,32(sp)
    8000144a:	69e2                	ld	s3,24(sp)
    8000144c:	6a42                	ld	s4,16(sp)
    8000144e:	6aa2                	ld	s5,8(sp)
    80001450:	6121                	addi	sp,sp,64
    80001452:	8082                	ret

0000000080001454 <reparent>:
{
    80001454:	7179                	addi	sp,sp,-48
    80001456:	f406                	sd	ra,40(sp)
    80001458:	f022                	sd	s0,32(sp)
    8000145a:	ec26                	sd	s1,24(sp)
    8000145c:	e84a                	sd	s2,16(sp)
    8000145e:	e44e                	sd	s3,8(sp)
    80001460:	e052                	sd	s4,0(sp)
    80001462:	1800                	addi	s0,sp,48
    80001464:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001466:	00009497          	auipc	s1,0x9
    8000146a:	1ca48493          	addi	s1,s1,458 # 8000a630 <proc>
      pp->parent = initproc;
    8000146e:	00009a17          	auipc	s4,0x9
    80001472:	d52a0a13          	addi	s4,s4,-686 # 8000a1c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001476:	0000f997          	auipc	s3,0xf
    8000147a:	bba98993          	addi	s3,s3,-1094 # 80010030 <tickslock>
    8000147e:	a029                	j	80001488 <reparent+0x34>
    80001480:	16848493          	addi	s1,s1,360
    80001484:	01348b63          	beq	s1,s3,8000149a <reparent+0x46>
    if(pp->parent == p){
    80001488:	7c9c                	ld	a5,56(s1)
    8000148a:	ff279be3          	bne	a5,s2,80001480 <reparent+0x2c>
      pp->parent = initproc;
    8000148e:	000a3503          	ld	a0,0(s4)
    80001492:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001494:	f57ff0ef          	jal	800013ea <wakeup>
    80001498:	b7e5                	j	80001480 <reparent+0x2c>
}
    8000149a:	70a2                	ld	ra,40(sp)
    8000149c:	7402                	ld	s0,32(sp)
    8000149e:	64e2                	ld	s1,24(sp)
    800014a0:	6942                	ld	s2,16(sp)
    800014a2:	69a2                	ld	s3,8(sp)
    800014a4:	6a02                	ld	s4,0(sp)
    800014a6:	6145                	addi	sp,sp,48
    800014a8:	8082                	ret

00000000800014aa <kexit>:
{
    800014aa:	7179                	addi	sp,sp,-48
    800014ac:	f406                	sd	ra,40(sp)
    800014ae:	f022                	sd	s0,32(sp)
    800014b0:	ec26                	sd	s1,24(sp)
    800014b2:	e84a                	sd	s2,16(sp)
    800014b4:	e44e                	sd	s3,8(sp)
    800014b6:	e052                	sd	s4,0(sp)
    800014b8:	1800                	addi	s0,sp,48
    800014ba:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014bc:	8ebff0ef          	jal	80000da6 <myproc>
    800014c0:	89aa                	mv	s3,a0
  if(p == initproc)
    800014c2:	00009797          	auipc	a5,0x9
    800014c6:	cfe7b783          	ld	a5,-770(a5) # 8000a1c0 <initproc>
    800014ca:	0d050493          	addi	s1,a0,208
    800014ce:	15050913          	addi	s2,a0,336
    800014d2:	00a79f63          	bne	a5,a0,800014f0 <kexit+0x46>
    panic("init exiting");
    800014d6:	00006517          	auipc	a0,0x6
    800014da:	cc250513          	addi	a0,a0,-830 # 80007198 <etext+0x198>
    800014de:	100040ef          	jal	800055de <panic>
      fileclose(f);
    800014e2:	7ad010ef          	jal	8000348e <fileclose>
      p->ofile[fd] = 0;
    800014e6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014ea:	04a1                	addi	s1,s1,8
    800014ec:	01248563          	beq	s1,s2,800014f6 <kexit+0x4c>
    if(p->ofile[fd]){
    800014f0:	6088                	ld	a0,0(s1)
    800014f2:	f965                	bnez	a0,800014e2 <kexit+0x38>
    800014f4:	bfdd                	j	800014ea <kexit+0x40>
  begin_op();
    800014f6:	38d010ef          	jal	80003082 <begin_op>
  iput(p->cwd);
    800014fa:	1509b503          	ld	a0,336(s3)
    800014fe:	31c010ef          	jal	8000281a <iput>
  end_op();
    80001502:	3eb010ef          	jal	800030ec <end_op>
  p->cwd = 0;
    80001506:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000150a:	00009497          	auipc	s1,0x9
    8000150e:	d0e48493          	addi	s1,s1,-754 # 8000a218 <wait_lock>
    80001512:	8526                	mv	a0,s1
    80001514:	386040ef          	jal	8000589a <acquire>
  reparent(p);
    80001518:	854e                	mv	a0,s3
    8000151a:	f3bff0ef          	jal	80001454 <reparent>
  wakeup(p->parent);
    8000151e:	0389b503          	ld	a0,56(s3)
    80001522:	ec9ff0ef          	jal	800013ea <wakeup>
  acquire(&p->lock);
    80001526:	854e                	mv	a0,s3
    80001528:	372040ef          	jal	8000589a <acquire>
  p->xstate = status;
    8000152c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001530:	4795                	li	a5,5
    80001532:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001536:	8526                	mv	a0,s1
    80001538:	3fa040ef          	jal	80005932 <release>
  sched();
    8000153c:	d7dff0ef          	jal	800012b8 <sched>
  panic("zombie exit");
    80001540:	00006517          	auipc	a0,0x6
    80001544:	c6850513          	addi	a0,a0,-920 # 800071a8 <etext+0x1a8>
    80001548:	096040ef          	jal	800055de <panic>

000000008000154c <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000154c:	7179                	addi	sp,sp,-48
    8000154e:	f406                	sd	ra,40(sp)
    80001550:	f022                	sd	s0,32(sp)
    80001552:	ec26                	sd	s1,24(sp)
    80001554:	e84a                	sd	s2,16(sp)
    80001556:	e44e                	sd	s3,8(sp)
    80001558:	1800                	addi	s0,sp,48
    8000155a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000155c:	00009497          	auipc	s1,0x9
    80001560:	0d448493          	addi	s1,s1,212 # 8000a630 <proc>
    80001564:	0000f997          	auipc	s3,0xf
    80001568:	acc98993          	addi	s3,s3,-1332 # 80010030 <tickslock>
    acquire(&p->lock);
    8000156c:	8526                	mv	a0,s1
    8000156e:	32c040ef          	jal	8000589a <acquire>
    if(p->pid == pid){
    80001572:	589c                	lw	a5,48(s1)
    80001574:	01278b63          	beq	a5,s2,8000158a <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001578:	8526                	mv	a0,s1
    8000157a:	3b8040ef          	jal	80005932 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000157e:	16848493          	addi	s1,s1,360
    80001582:	ff3495e3          	bne	s1,s3,8000156c <kkill+0x20>
  }
  return -1;
    80001586:	557d                	li	a0,-1
    80001588:	a819                	j	8000159e <kkill+0x52>
      p->killed = 1;
    8000158a:	4785                	li	a5,1
    8000158c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000158e:	4c98                	lw	a4,24(s1)
    80001590:	4789                	li	a5,2
    80001592:	00f70d63          	beq	a4,a5,800015ac <kkill+0x60>
      release(&p->lock);
    80001596:	8526                	mv	a0,s1
    80001598:	39a040ef          	jal	80005932 <release>
      return 0;
    8000159c:	4501                	li	a0,0
}
    8000159e:	70a2                	ld	ra,40(sp)
    800015a0:	7402                	ld	s0,32(sp)
    800015a2:	64e2                	ld	s1,24(sp)
    800015a4:	6942                	ld	s2,16(sp)
    800015a6:	69a2                	ld	s3,8(sp)
    800015a8:	6145                	addi	sp,sp,48
    800015aa:	8082                	ret
        p->state = RUNNABLE;
    800015ac:	478d                	li	a5,3
    800015ae:	cc9c                	sw	a5,24(s1)
    800015b0:	b7dd                	j	80001596 <kkill+0x4a>

00000000800015b2 <setkilled>:

void
setkilled(struct proc *p)
{
    800015b2:	1101                	addi	sp,sp,-32
    800015b4:	ec06                	sd	ra,24(sp)
    800015b6:	e822                	sd	s0,16(sp)
    800015b8:	e426                	sd	s1,8(sp)
    800015ba:	1000                	addi	s0,sp,32
    800015bc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015be:	2dc040ef          	jal	8000589a <acquire>
  p->killed = 1;
    800015c2:	4785                	li	a5,1
    800015c4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015c6:	8526                	mv	a0,s1
    800015c8:	36a040ef          	jal	80005932 <release>
}
    800015cc:	60e2                	ld	ra,24(sp)
    800015ce:	6442                	ld	s0,16(sp)
    800015d0:	64a2                	ld	s1,8(sp)
    800015d2:	6105                	addi	sp,sp,32
    800015d4:	8082                	ret

00000000800015d6 <killed>:

int
killed(struct proc *p)
{
    800015d6:	1101                	addi	sp,sp,-32
    800015d8:	ec06                	sd	ra,24(sp)
    800015da:	e822                	sd	s0,16(sp)
    800015dc:	e426                	sd	s1,8(sp)
    800015de:	e04a                	sd	s2,0(sp)
    800015e0:	1000                	addi	s0,sp,32
    800015e2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015e4:	2b6040ef          	jal	8000589a <acquire>
  k = p->killed;
    800015e8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015ec:	8526                	mv	a0,s1
    800015ee:	344040ef          	jal	80005932 <release>
  return k;
}
    800015f2:	854a                	mv	a0,s2
    800015f4:	60e2                	ld	ra,24(sp)
    800015f6:	6442                	ld	s0,16(sp)
    800015f8:	64a2                	ld	s1,8(sp)
    800015fa:	6902                	ld	s2,0(sp)
    800015fc:	6105                	addi	sp,sp,32
    800015fe:	8082                	ret

0000000080001600 <kwait>:
{
    80001600:	715d                	addi	sp,sp,-80
    80001602:	e486                	sd	ra,72(sp)
    80001604:	e0a2                	sd	s0,64(sp)
    80001606:	fc26                	sd	s1,56(sp)
    80001608:	f84a                	sd	s2,48(sp)
    8000160a:	f44e                	sd	s3,40(sp)
    8000160c:	f052                	sd	s4,32(sp)
    8000160e:	ec56                	sd	s5,24(sp)
    80001610:	e85a                	sd	s6,16(sp)
    80001612:	e45e                	sd	s7,8(sp)
    80001614:	e062                	sd	s8,0(sp)
    80001616:	0880                	addi	s0,sp,80
    80001618:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000161a:	f8cff0ef          	jal	80000da6 <myproc>
    8000161e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001620:	00009517          	auipc	a0,0x9
    80001624:	bf850513          	addi	a0,a0,-1032 # 8000a218 <wait_lock>
    80001628:	272040ef          	jal	8000589a <acquire>
    havekids = 0;
    8000162c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000162e:	4a15                	li	s4,5
        havekids = 1;
    80001630:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001632:	0000f997          	auipc	s3,0xf
    80001636:	9fe98993          	addi	s3,s3,-1538 # 80010030 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000163a:	00009c17          	auipc	s8,0x9
    8000163e:	bdec0c13          	addi	s8,s8,-1058 # 8000a218 <wait_lock>
    80001642:	a871                	j	800016de <kwait+0xde>
          pid = pp->pid;
    80001644:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001648:	000b0c63          	beqz	s6,80001660 <kwait+0x60>
    8000164c:	4691                	li	a3,4
    8000164e:	02c48613          	addi	a2,s1,44
    80001652:	85da                	mv	a1,s6
    80001654:	05093503          	ld	a0,80(s2)
    80001658:	c52ff0ef          	jal	80000aaa <copyout>
    8000165c:	02054b63          	bltz	a0,80001692 <kwait+0x92>
          freeproc(pp);
    80001660:	8526                	mv	a0,s1
    80001662:	915ff0ef          	jal	80000f76 <freeproc>
          release(&pp->lock);
    80001666:	8526                	mv	a0,s1
    80001668:	2ca040ef          	jal	80005932 <release>
          release(&wait_lock);
    8000166c:	00009517          	auipc	a0,0x9
    80001670:	bac50513          	addi	a0,a0,-1108 # 8000a218 <wait_lock>
    80001674:	2be040ef          	jal	80005932 <release>
}
    80001678:	854e                	mv	a0,s3
    8000167a:	60a6                	ld	ra,72(sp)
    8000167c:	6406                	ld	s0,64(sp)
    8000167e:	74e2                	ld	s1,56(sp)
    80001680:	7942                	ld	s2,48(sp)
    80001682:	79a2                	ld	s3,40(sp)
    80001684:	7a02                	ld	s4,32(sp)
    80001686:	6ae2                	ld	s5,24(sp)
    80001688:	6b42                	ld	s6,16(sp)
    8000168a:	6ba2                	ld	s7,8(sp)
    8000168c:	6c02                	ld	s8,0(sp)
    8000168e:	6161                	addi	sp,sp,80
    80001690:	8082                	ret
            release(&pp->lock);
    80001692:	8526                	mv	a0,s1
    80001694:	29e040ef          	jal	80005932 <release>
            release(&wait_lock);
    80001698:	00009517          	auipc	a0,0x9
    8000169c:	b8050513          	addi	a0,a0,-1152 # 8000a218 <wait_lock>
    800016a0:	292040ef          	jal	80005932 <release>
            return -1;
    800016a4:	59fd                	li	s3,-1
    800016a6:	bfc9                	j	80001678 <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016a8:	16848493          	addi	s1,s1,360
    800016ac:	03348063          	beq	s1,s3,800016cc <kwait+0xcc>
      if(pp->parent == p){
    800016b0:	7c9c                	ld	a5,56(s1)
    800016b2:	ff279be3          	bne	a5,s2,800016a8 <kwait+0xa8>
        acquire(&pp->lock);
    800016b6:	8526                	mv	a0,s1
    800016b8:	1e2040ef          	jal	8000589a <acquire>
        if(pp->state == ZOMBIE){
    800016bc:	4c9c                	lw	a5,24(s1)
    800016be:	f94783e3          	beq	a5,s4,80001644 <kwait+0x44>
        release(&pp->lock);
    800016c2:	8526                	mv	a0,s1
    800016c4:	26e040ef          	jal	80005932 <release>
        havekids = 1;
    800016c8:	8756                	mv	a4,s5
    800016ca:	bff9                	j	800016a8 <kwait+0xa8>
    if(!havekids || killed(p)){
    800016cc:	cf19                	beqz	a4,800016ea <kwait+0xea>
    800016ce:	854a                	mv	a0,s2
    800016d0:	f07ff0ef          	jal	800015d6 <killed>
    800016d4:	e919                	bnez	a0,800016ea <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d6:	85e2                	mv	a1,s8
    800016d8:	854a                	mv	a0,s2
    800016da:	cc5ff0ef          	jal	8000139e <sleep>
    havekids = 0;
    800016de:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016e0:	00009497          	auipc	s1,0x9
    800016e4:	f5048493          	addi	s1,s1,-176 # 8000a630 <proc>
    800016e8:	b7e1                	j	800016b0 <kwait+0xb0>
      release(&wait_lock);
    800016ea:	00009517          	auipc	a0,0x9
    800016ee:	b2e50513          	addi	a0,a0,-1234 # 8000a218 <wait_lock>
    800016f2:	240040ef          	jal	80005932 <release>
      return -1;
    800016f6:	59fd                	li	s3,-1
    800016f8:	b741                	j	80001678 <kwait+0x78>

00000000800016fa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016fa:	7179                	addi	sp,sp,-48
    800016fc:	f406                	sd	ra,40(sp)
    800016fe:	f022                	sd	s0,32(sp)
    80001700:	ec26                	sd	s1,24(sp)
    80001702:	e84a                	sd	s2,16(sp)
    80001704:	e44e                	sd	s3,8(sp)
    80001706:	e052                	sd	s4,0(sp)
    80001708:	1800                	addi	s0,sp,48
    8000170a:	84aa                	mv	s1,a0
    8000170c:	892e                	mv	s2,a1
    8000170e:	89b2                	mv	s3,a2
    80001710:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001712:	e94ff0ef          	jal	80000da6 <myproc>
  if(user_dst){
    80001716:	cc99                	beqz	s1,80001734 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001718:	86d2                	mv	a3,s4
    8000171a:	864e                	mv	a2,s3
    8000171c:	85ca                	mv	a1,s2
    8000171e:	6928                	ld	a0,80(a0)
    80001720:	b8aff0ef          	jal	80000aaa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001724:	70a2                	ld	ra,40(sp)
    80001726:	7402                	ld	s0,32(sp)
    80001728:	64e2                	ld	s1,24(sp)
    8000172a:	6942                	ld	s2,16(sp)
    8000172c:	69a2                	ld	s3,8(sp)
    8000172e:	6a02                	ld	s4,0(sp)
    80001730:	6145                	addi	sp,sp,48
    80001732:	8082                	ret
    memmove((char *)dst, src, len);
    80001734:	000a061b          	sext.w	a2,s4
    80001738:	85ce                	mv	a1,s3
    8000173a:	854a                	mv	a0,s2
    8000173c:	a6ffe0ef          	jal	800001aa <memmove>
    return 0;
    80001740:	8526                	mv	a0,s1
    80001742:	b7cd                	j	80001724 <either_copyout+0x2a>

0000000080001744 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001744:	7179                	addi	sp,sp,-48
    80001746:	f406                	sd	ra,40(sp)
    80001748:	f022                	sd	s0,32(sp)
    8000174a:	ec26                	sd	s1,24(sp)
    8000174c:	e84a                	sd	s2,16(sp)
    8000174e:	e44e                	sd	s3,8(sp)
    80001750:	e052                	sd	s4,0(sp)
    80001752:	1800                	addi	s0,sp,48
    80001754:	892a                	mv	s2,a0
    80001756:	84ae                	mv	s1,a1
    80001758:	89b2                	mv	s3,a2
    8000175a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000175c:	e4aff0ef          	jal	80000da6 <myproc>
  if(user_src){
    80001760:	cc99                	beqz	s1,8000177e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001762:	86d2                	mv	a3,s4
    80001764:	864e                	mv	a2,s3
    80001766:	85ca                	mv	a1,s2
    80001768:	6928                	ld	a0,80(a0)
    8000176a:	c34ff0ef          	jal	80000b9e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000176e:	70a2                	ld	ra,40(sp)
    80001770:	7402                	ld	s0,32(sp)
    80001772:	64e2                	ld	s1,24(sp)
    80001774:	6942                	ld	s2,16(sp)
    80001776:	69a2                	ld	s3,8(sp)
    80001778:	6a02                	ld	s4,0(sp)
    8000177a:	6145                	addi	sp,sp,48
    8000177c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000177e:	000a061b          	sext.w	a2,s4
    80001782:	85ce                	mv	a1,s3
    80001784:	854a                	mv	a0,s2
    80001786:	a25fe0ef          	jal	800001aa <memmove>
    return 0;
    8000178a:	8526                	mv	a0,s1
    8000178c:	b7cd                	j	8000176e <either_copyin+0x2a>

000000008000178e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000178e:	715d                	addi	sp,sp,-80
    80001790:	e486                	sd	ra,72(sp)
    80001792:	e0a2                	sd	s0,64(sp)
    80001794:	fc26                	sd	s1,56(sp)
    80001796:	f84a                	sd	s2,48(sp)
    80001798:	f44e                	sd	s3,40(sp)
    8000179a:	f052                	sd	s4,32(sp)
    8000179c:	ec56                	sd	s5,24(sp)
    8000179e:	e85a                	sd	s6,16(sp)
    800017a0:	e45e                	sd	s7,8(sp)
    800017a2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800017a4:	00006517          	auipc	a0,0x6
    800017a8:	87450513          	addi	a0,a0,-1932 # 80007018 <etext+0x18>
    800017ac:	34d030ef          	jal	800052f8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017b0:	00009497          	auipc	s1,0x9
    800017b4:	fd848493          	addi	s1,s1,-40 # 8000a788 <proc+0x158>
    800017b8:	0000f917          	auipc	s2,0xf
    800017bc:	9d090913          	addi	s2,s2,-1584 # 80010188 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017c0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017c2:	00006997          	auipc	s3,0x6
    800017c6:	9f698993          	addi	s3,s3,-1546 # 800071b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    800017ca:	00006a97          	auipc	s5,0x6
    800017ce:	9f6a8a93          	addi	s5,s5,-1546 # 800071c0 <etext+0x1c0>
    printf("\n");
    800017d2:	00006a17          	auipc	s4,0x6
    800017d6:	846a0a13          	addi	s4,s4,-1978 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017da:	00006b97          	auipc	s7,0x6
    800017de:	f4eb8b93          	addi	s7,s7,-178 # 80007728 <states.0>
    800017e2:	a829                	j	800017fc <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017e4:	ed86a583          	lw	a1,-296(a3)
    800017e8:	8556                	mv	a0,s5
    800017ea:	30f030ef          	jal	800052f8 <printf>
    printf("\n");
    800017ee:	8552                	mv	a0,s4
    800017f0:	309030ef          	jal	800052f8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017f4:	16848493          	addi	s1,s1,360
    800017f8:	03248263          	beq	s1,s2,8000181c <procdump+0x8e>
    if(p->state == UNUSED)
    800017fc:	86a6                	mv	a3,s1
    800017fe:	ec04a783          	lw	a5,-320(s1)
    80001802:	dbed                	beqz	a5,800017f4 <procdump+0x66>
      state = "???";
    80001804:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001806:	fcfb6fe3          	bltu	s6,a5,800017e4 <procdump+0x56>
    8000180a:	02079713          	slli	a4,a5,0x20
    8000180e:	01d75793          	srli	a5,a4,0x1d
    80001812:	97de                	add	a5,a5,s7
    80001814:	6390                	ld	a2,0(a5)
    80001816:	f679                	bnez	a2,800017e4 <procdump+0x56>
      state = "???";
    80001818:	864e                	mv	a2,s3
    8000181a:	b7e9                	j	800017e4 <procdump+0x56>
  }
}
    8000181c:	60a6                	ld	ra,72(sp)
    8000181e:	6406                	ld	s0,64(sp)
    80001820:	74e2                	ld	s1,56(sp)
    80001822:	7942                	ld	s2,48(sp)
    80001824:	79a2                	ld	s3,40(sp)
    80001826:	7a02                	ld	s4,32(sp)
    80001828:	6ae2                	ld	s5,24(sp)
    8000182a:	6b42                	ld	s6,16(sp)
    8000182c:	6ba2                	ld	s7,8(sp)
    8000182e:	6161                	addi	sp,sp,80
    80001830:	8082                	ret

0000000080001832 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001832:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001836:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000183a:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000183c:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000183e:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001842:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001846:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000184a:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8000184e:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001852:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001856:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000185a:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8000185e:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001862:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001866:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000186a:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8000186e:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001870:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001872:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001876:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000187a:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000187e:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001882:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001886:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000188a:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000188e:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001892:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001896:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000189a:	8082                	ret

000000008000189c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000189c:	1141                	addi	sp,sp,-16
    8000189e:	e406                	sd	ra,8(sp)
    800018a0:	e022                	sd	s0,0(sp)
    800018a2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018a4:	00006597          	auipc	a1,0x6
    800018a8:	95c58593          	addi	a1,a1,-1700 # 80007200 <etext+0x200>
    800018ac:	0000e517          	auipc	a0,0xe
    800018b0:	78450513          	addi	a0,a0,1924 # 80010030 <tickslock>
    800018b4:	767030ef          	jal	8000581a <initlock>
}
    800018b8:	60a2                	ld	ra,8(sp)
    800018ba:	6402                	ld	s0,0(sp)
    800018bc:	0141                	addi	sp,sp,16
    800018be:	8082                	ret

00000000800018c0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018c0:	1141                	addi	sp,sp,-16
    800018c2:	e422                	sd	s0,8(sp)
    800018c4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018c6:	00003797          	auipc	a5,0x3
    800018ca:	f3a78793          	addi	a5,a5,-198 # 80004800 <kernelvec>
    800018ce:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018d2:	6422                	ld	s0,8(sp)
    800018d4:	0141                	addi	sp,sp,16
    800018d6:	8082                	ret

00000000800018d8 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018d8:	1141                	addi	sp,sp,-16
    800018da:	e406                	sd	ra,8(sp)
    800018dc:	e022                	sd	s0,0(sp)
    800018de:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018e0:	cc6ff0ef          	jal	80000da6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018e8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018ea:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018ee:	04000737          	lui	a4,0x4000
    800018f2:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018f4:	0732                	slli	a4,a4,0xc
    800018f6:	00004797          	auipc	a5,0x4
    800018fa:	70a78793          	addi	a5,a5,1802 # 80006000 <_trampoline>
    800018fe:	00004697          	auipc	a3,0x4
    80001902:	70268693          	addi	a3,a3,1794 # 80006000 <_trampoline>
    80001906:	8f95                	sub	a5,a5,a3
    80001908:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000190a:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000190e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001910:	18002773          	csrr	a4,satp
    80001914:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001916:	6d38                	ld	a4,88(a0)
    80001918:	613c                	ld	a5,64(a0)
    8000191a:	6685                	lui	a3,0x1
    8000191c:	97b6                	add	a5,a5,a3
    8000191e:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001920:	6d3c                	ld	a5,88(a0)
    80001922:	00000717          	auipc	a4,0x0
    80001926:	0f870713          	addi	a4,a4,248 # 80001a1a <usertrap>
    8000192a:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000192c:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000192e:	8712                	mv	a4,tp
    80001930:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001932:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001936:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000193a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000193e:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001942:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001944:	6f9c                	ld	a5,24(a5)
    80001946:	14179073          	csrw	sepc,a5
}
    8000194a:	60a2                	ld	ra,8(sp)
    8000194c:	6402                	ld	s0,0(sp)
    8000194e:	0141                	addi	sp,sp,16
    80001950:	8082                	ret

0000000080001952 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001952:	1101                	addi	sp,sp,-32
    80001954:	ec06                	sd	ra,24(sp)
    80001956:	e822                	sd	s0,16(sp)
    80001958:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000195a:	c20ff0ef          	jal	80000d7a <cpuid>
    8000195e:	cd11                	beqz	a0,8000197a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001960:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001964:	000f4737          	lui	a4,0xf4
    80001968:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000196c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000196e:	14d79073          	csrw	stimecmp,a5
}
    80001972:	60e2                	ld	ra,24(sp)
    80001974:	6442                	ld	s0,16(sp)
    80001976:	6105                	addi	sp,sp,32
    80001978:	8082                	ret
    8000197a:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000197c:	0000e497          	auipc	s1,0xe
    80001980:	6b448493          	addi	s1,s1,1716 # 80010030 <tickslock>
    80001984:	8526                	mv	a0,s1
    80001986:	715030ef          	jal	8000589a <acquire>
    ticks++;
    8000198a:	00009517          	auipc	a0,0x9
    8000198e:	83e50513          	addi	a0,a0,-1986 # 8000a1c8 <ticks>
    80001992:	411c                	lw	a5,0(a0)
    80001994:	2785                	addiw	a5,a5,1
    80001996:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001998:	a53ff0ef          	jal	800013ea <wakeup>
    release(&tickslock);
    8000199c:	8526                	mv	a0,s1
    8000199e:	795030ef          	jal	80005932 <release>
    800019a2:	64a2                	ld	s1,8(sp)
    800019a4:	bf75                	j	80001960 <clockintr+0xe>

00000000800019a6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019a6:	1101                	addi	sp,sp,-32
    800019a8:	ec06                	sd	ra,24(sp)
    800019aa:	e822                	sd	s0,16(sp)
    800019ac:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019ae:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019b2:	57fd                	li	a5,-1
    800019b4:	17fe                	slli	a5,a5,0x3f
    800019b6:	07a5                	addi	a5,a5,9
    800019b8:	00f70c63          	beq	a4,a5,800019d0 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019bc:	57fd                	li	a5,-1
    800019be:	17fe                	slli	a5,a5,0x3f
    800019c0:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019c2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019c4:	04f70763          	beq	a4,a5,80001a12 <devintr+0x6c>
  }
}
    800019c8:	60e2                	ld	ra,24(sp)
    800019ca:	6442                	ld	s0,16(sp)
    800019cc:	6105                	addi	sp,sp,32
    800019ce:	8082                	ret
    800019d0:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019d2:	6db020ef          	jal	800048ac <plic_claim>
    800019d6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019d8:	47a9                	li	a5,10
    800019da:	00f50963          	beq	a0,a5,800019ec <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019de:	4785                	li	a5,1
    800019e0:	00f50963          	beq	a0,a5,800019f2 <devintr+0x4c>
    return 1;
    800019e4:	4505                	li	a0,1
    } else if(irq){
    800019e6:	e889                	bnez	s1,800019f8 <devintr+0x52>
    800019e8:	64a2                	ld	s1,8(sp)
    800019ea:	bff9                	j	800019c8 <devintr+0x22>
      uartintr();
    800019ec:	5c3030ef          	jal	800057ae <uartintr>
    if(irq)
    800019f0:	a819                	j	80001a06 <devintr+0x60>
      virtio_disk_intr();
    800019f2:	380030ef          	jal	80004d72 <virtio_disk_intr>
    if(irq)
    800019f6:	a801                	j	80001a06 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019f8:	85a6                	mv	a1,s1
    800019fa:	00006517          	auipc	a0,0x6
    800019fe:	80e50513          	addi	a0,a0,-2034 # 80007208 <etext+0x208>
    80001a02:	0f7030ef          	jal	800052f8 <printf>
      plic_complete(irq);
    80001a06:	8526                	mv	a0,s1
    80001a08:	6c5020ef          	jal	800048cc <plic_complete>
    return 1;
    80001a0c:	4505                	li	a0,1
    80001a0e:	64a2                	ld	s1,8(sp)
    80001a10:	bf65                	j	800019c8 <devintr+0x22>
    clockintr();
    80001a12:	f41ff0ef          	jal	80001952 <clockintr>
    return 2;
    80001a16:	4509                	li	a0,2
    80001a18:	bf45                	j	800019c8 <devintr+0x22>

0000000080001a1a <usertrap>:
{
    80001a1a:	1101                	addi	sp,sp,-32
    80001a1c:	ec06                	sd	ra,24(sp)
    80001a1e:	e822                	sd	s0,16(sp)
    80001a20:	e426                	sd	s1,8(sp)
    80001a22:	e04a                	sd	s2,0(sp)
    80001a24:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a26:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a2a:	1007f793          	andi	a5,a5,256
    80001a2e:	eba5                	bnez	a5,80001a9e <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a30:	00003797          	auipc	a5,0x3
    80001a34:	dd078793          	addi	a5,a5,-560 # 80004800 <kernelvec>
    80001a38:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a3c:	b6aff0ef          	jal	80000da6 <myproc>
    80001a40:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a42:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a44:	14102773          	csrr	a4,sepc
    80001a48:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a4a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a4e:	47a1                	li	a5,8
    80001a50:	04f70d63          	beq	a4,a5,80001aaa <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a54:	f53ff0ef          	jal	800019a6 <devintr>
    80001a58:	892a                	mv	s2,a0
    80001a5a:	e945                	bnez	a0,80001b0a <usertrap+0xf0>
    80001a5c:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a60:	47bd                	li	a5,15
    80001a62:	08f70863          	beq	a4,a5,80001af2 <usertrap+0xd8>
    80001a66:	14202773          	csrr	a4,scause
    80001a6a:	47b5                	li	a5,13
    80001a6c:	08f70363          	beq	a4,a5,80001af2 <usertrap+0xd8>
    80001a70:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a74:	5890                	lw	a2,48(s1)
    80001a76:	00005517          	auipc	a0,0x5
    80001a7a:	7d250513          	addi	a0,a0,2002 # 80007248 <etext+0x248>
    80001a7e:	07b030ef          	jal	800052f8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a82:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a86:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a8a:	00005517          	auipc	a0,0x5
    80001a8e:	7ee50513          	addi	a0,a0,2030 # 80007278 <etext+0x278>
    80001a92:	067030ef          	jal	800052f8 <printf>
    setkilled(p);
    80001a96:	8526                	mv	a0,s1
    80001a98:	b1bff0ef          	jal	800015b2 <setkilled>
    80001a9c:	a035                	j	80001ac8 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a9e:	00005517          	auipc	a0,0x5
    80001aa2:	78a50513          	addi	a0,a0,1930 # 80007228 <etext+0x228>
    80001aa6:	339030ef          	jal	800055de <panic>
    if(killed(p))
    80001aaa:	b2dff0ef          	jal	800015d6 <killed>
    80001aae:	ed15                	bnez	a0,80001aea <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001ab0:	6cb8                	ld	a4,88(s1)
    80001ab2:	6f1c                	ld	a5,24(a4)
    80001ab4:	0791                	addi	a5,a5,4
    80001ab6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001abc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac0:	10079073          	csrw	sstatus,a5
    syscall();
    80001ac4:	246000ef          	jal	80001d0a <syscall>
  if(killed(p))
    80001ac8:	8526                	mv	a0,s1
    80001aca:	b0dff0ef          	jal	800015d6 <killed>
    80001ace:	e139                	bnez	a0,80001b14 <usertrap+0xfa>
  prepare_return();
    80001ad0:	e09ff0ef          	jal	800018d8 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ad4:	68a8                	ld	a0,80(s1)
    80001ad6:	8131                	srli	a0,a0,0xc
    80001ad8:	57fd                	li	a5,-1
    80001ada:	17fe                	slli	a5,a5,0x3f
    80001adc:	8d5d                	or	a0,a0,a5
}
    80001ade:	60e2                	ld	ra,24(sp)
    80001ae0:	6442                	ld	s0,16(sp)
    80001ae2:	64a2                	ld	s1,8(sp)
    80001ae4:	6902                	ld	s2,0(sp)
    80001ae6:	6105                	addi	sp,sp,32
    80001ae8:	8082                	ret
      kexit(-1);
    80001aea:	557d                	li	a0,-1
    80001aec:	9bfff0ef          	jal	800014aa <kexit>
    80001af0:	b7c1                	j	80001ab0 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af2:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001af6:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001afa:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001afc:	00163613          	seqz	a2,a2
    80001b00:	68a8                	ld	a0,80(s1)
    80001b02:	f27fe0ef          	jal	80000a28 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b06:	f169                	bnez	a0,80001ac8 <usertrap+0xae>
    80001b08:	b7a5                	j	80001a70 <usertrap+0x56>
  if(killed(p))
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	acbff0ef          	jal	800015d6 <killed>
    80001b10:	c511                	beqz	a0,80001b1c <usertrap+0x102>
    80001b12:	a011                	j	80001b16 <usertrap+0xfc>
    80001b14:	4901                	li	s2,0
    kexit(-1);
    80001b16:	557d                	li	a0,-1
    80001b18:	993ff0ef          	jal	800014aa <kexit>
  if(which_dev == 2)
    80001b1c:	4789                	li	a5,2
    80001b1e:	faf919e3          	bne	s2,a5,80001ad0 <usertrap+0xb6>
    yield();
    80001b22:	851ff0ef          	jal	80001372 <yield>
    80001b26:	b76d                	j	80001ad0 <usertrap+0xb6>

0000000080001b28 <kerneltrap>:
{
    80001b28:	7179                	addi	sp,sp,-48
    80001b2a:	f406                	sd	ra,40(sp)
    80001b2c:	f022                	sd	s0,32(sp)
    80001b2e:	ec26                	sd	s1,24(sp)
    80001b30:	e84a                	sd	s2,16(sp)
    80001b32:	e44e                	sd	s3,8(sp)
    80001b34:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b36:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b3a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b3e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b42:	1004f793          	andi	a5,s1,256
    80001b46:	c795                	beqz	a5,80001b72 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b48:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b4c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b4e:	eb85                	bnez	a5,80001b7e <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b50:	e57ff0ef          	jal	800019a6 <devintr>
    80001b54:	c91d                	beqz	a0,80001b8a <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b56:	4789                	li	a5,2
    80001b58:	04f50a63          	beq	a0,a5,80001bac <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b5c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b60:	10049073          	csrw	sstatus,s1
}
    80001b64:	70a2                	ld	ra,40(sp)
    80001b66:	7402                	ld	s0,32(sp)
    80001b68:	64e2                	ld	s1,24(sp)
    80001b6a:	6942                	ld	s2,16(sp)
    80001b6c:	69a2                	ld	s3,8(sp)
    80001b6e:	6145                	addi	sp,sp,48
    80001b70:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b72:	00005517          	auipc	a0,0x5
    80001b76:	72e50513          	addi	a0,a0,1838 # 800072a0 <etext+0x2a0>
    80001b7a:	265030ef          	jal	800055de <panic>
    panic("kerneltrap: interrupts enabled");
    80001b7e:	00005517          	auipc	a0,0x5
    80001b82:	74a50513          	addi	a0,a0,1866 # 800072c8 <etext+0x2c8>
    80001b86:	259030ef          	jal	800055de <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b8a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b8e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b92:	85ce                	mv	a1,s3
    80001b94:	00005517          	auipc	a0,0x5
    80001b98:	75450513          	addi	a0,a0,1876 # 800072e8 <etext+0x2e8>
    80001b9c:	75c030ef          	jal	800052f8 <printf>
    panic("kerneltrap");
    80001ba0:	00005517          	auipc	a0,0x5
    80001ba4:	77050513          	addi	a0,a0,1904 # 80007310 <etext+0x310>
    80001ba8:	237030ef          	jal	800055de <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bac:	9faff0ef          	jal	80000da6 <myproc>
    80001bb0:	d555                	beqz	a0,80001b5c <kerneltrap+0x34>
    yield();
    80001bb2:	fc0ff0ef          	jal	80001372 <yield>
    80001bb6:	b75d                	j	80001b5c <kerneltrap+0x34>

0000000080001bb8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bb8:	1101                	addi	sp,sp,-32
    80001bba:	ec06                	sd	ra,24(sp)
    80001bbc:	e822                	sd	s0,16(sp)
    80001bbe:	e426                	sd	s1,8(sp)
    80001bc0:	1000                	addi	s0,sp,32
    80001bc2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bc4:	9e2ff0ef          	jal	80000da6 <myproc>
  switch (n) {
    80001bc8:	4795                	li	a5,5
    80001bca:	0497e163          	bltu	a5,s1,80001c0c <argraw+0x54>
    80001bce:	048a                	slli	s1,s1,0x2
    80001bd0:	00006717          	auipc	a4,0x6
    80001bd4:	b8870713          	addi	a4,a4,-1144 # 80007758 <states.0+0x30>
    80001bd8:	94ba                	add	s1,s1,a4
    80001bda:	409c                	lw	a5,0(s1)
    80001bdc:	97ba                	add	a5,a5,a4
    80001bde:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001be0:	6d3c                	ld	a5,88(a0)
    80001be2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001be4:	60e2                	ld	ra,24(sp)
    80001be6:	6442                	ld	s0,16(sp)
    80001be8:	64a2                	ld	s1,8(sp)
    80001bea:	6105                	addi	sp,sp,32
    80001bec:	8082                	ret
    return p->trapframe->a1;
    80001bee:	6d3c                	ld	a5,88(a0)
    80001bf0:	7fa8                	ld	a0,120(a5)
    80001bf2:	bfcd                	j	80001be4 <argraw+0x2c>
    return p->trapframe->a2;
    80001bf4:	6d3c                	ld	a5,88(a0)
    80001bf6:	63c8                	ld	a0,128(a5)
    80001bf8:	b7f5                	j	80001be4 <argraw+0x2c>
    return p->trapframe->a3;
    80001bfa:	6d3c                	ld	a5,88(a0)
    80001bfc:	67c8                	ld	a0,136(a5)
    80001bfe:	b7dd                	j	80001be4 <argraw+0x2c>
    return p->trapframe->a4;
    80001c00:	6d3c                	ld	a5,88(a0)
    80001c02:	6bc8                	ld	a0,144(a5)
    80001c04:	b7c5                	j	80001be4 <argraw+0x2c>
    return p->trapframe->a5;
    80001c06:	6d3c                	ld	a5,88(a0)
    80001c08:	6fc8                	ld	a0,152(a5)
    80001c0a:	bfe9                	j	80001be4 <argraw+0x2c>
  panic("argraw");
    80001c0c:	00005517          	auipc	a0,0x5
    80001c10:	71450513          	addi	a0,a0,1812 # 80007320 <etext+0x320>
    80001c14:	1cb030ef          	jal	800055de <panic>

0000000080001c18 <fetchaddr>:
{
    80001c18:	1101                	addi	sp,sp,-32
    80001c1a:	ec06                	sd	ra,24(sp)
    80001c1c:	e822                	sd	s0,16(sp)
    80001c1e:	e426                	sd	s1,8(sp)
    80001c20:	e04a                	sd	s2,0(sp)
    80001c22:	1000                	addi	s0,sp,32
    80001c24:	84aa                	mv	s1,a0
    80001c26:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c28:	97eff0ef          	jal	80000da6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c2c:	653c                	ld	a5,72(a0)
    80001c2e:	02f4f663          	bgeu	s1,a5,80001c5a <fetchaddr+0x42>
    80001c32:	00848713          	addi	a4,s1,8
    80001c36:	02e7e463          	bltu	a5,a4,80001c5e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c3a:	46a1                	li	a3,8
    80001c3c:	8626                	mv	a2,s1
    80001c3e:	85ca                	mv	a1,s2
    80001c40:	6928                	ld	a0,80(a0)
    80001c42:	f5dfe0ef          	jal	80000b9e <copyin>
    80001c46:	00a03533          	snez	a0,a0
    80001c4a:	40a00533          	neg	a0,a0
}
    80001c4e:	60e2                	ld	ra,24(sp)
    80001c50:	6442                	ld	s0,16(sp)
    80001c52:	64a2                	ld	s1,8(sp)
    80001c54:	6902                	ld	s2,0(sp)
    80001c56:	6105                	addi	sp,sp,32
    80001c58:	8082                	ret
    return -1;
    80001c5a:	557d                	li	a0,-1
    80001c5c:	bfcd                	j	80001c4e <fetchaddr+0x36>
    80001c5e:	557d                	li	a0,-1
    80001c60:	b7fd                	j	80001c4e <fetchaddr+0x36>

0000000080001c62 <fetchstr>:
{
    80001c62:	7179                	addi	sp,sp,-48
    80001c64:	f406                	sd	ra,40(sp)
    80001c66:	f022                	sd	s0,32(sp)
    80001c68:	ec26                	sd	s1,24(sp)
    80001c6a:	e84a                	sd	s2,16(sp)
    80001c6c:	e44e                	sd	s3,8(sp)
    80001c6e:	1800                	addi	s0,sp,48
    80001c70:	892a                	mv	s2,a0
    80001c72:	84ae                	mv	s1,a1
    80001c74:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c76:	930ff0ef          	jal	80000da6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c7a:	86ce                	mv	a3,s3
    80001c7c:	864a                	mv	a2,s2
    80001c7e:	85a6                	mv	a1,s1
    80001c80:	6928                	ld	a0,80(a0)
    80001c82:	ccffe0ef          	jal	80000950 <copyinstr>
    80001c86:	00054c63          	bltz	a0,80001c9e <fetchstr+0x3c>
  return strlen(buf);
    80001c8a:	8526                	mv	a0,s1
    80001c8c:	e32fe0ef          	jal	800002be <strlen>
}
    80001c90:	70a2                	ld	ra,40(sp)
    80001c92:	7402                	ld	s0,32(sp)
    80001c94:	64e2                	ld	s1,24(sp)
    80001c96:	6942                	ld	s2,16(sp)
    80001c98:	69a2                	ld	s3,8(sp)
    80001c9a:	6145                	addi	sp,sp,48
    80001c9c:	8082                	ret
    return -1;
    80001c9e:	557d                	li	a0,-1
    80001ca0:	bfc5                	j	80001c90 <fetchstr+0x2e>

0000000080001ca2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ca2:	1101                	addi	sp,sp,-32
    80001ca4:	ec06                	sd	ra,24(sp)
    80001ca6:	e822                	sd	s0,16(sp)
    80001ca8:	e426                	sd	s1,8(sp)
    80001caa:	1000                	addi	s0,sp,32
    80001cac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cae:	f0bff0ef          	jal	80001bb8 <argraw>
    80001cb2:	c088                	sw	a0,0(s1)
}
    80001cb4:	60e2                	ld	ra,24(sp)
    80001cb6:	6442                	ld	s0,16(sp)
    80001cb8:	64a2                	ld	s1,8(sp)
    80001cba:	6105                	addi	sp,sp,32
    80001cbc:	8082                	ret

0000000080001cbe <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cbe:	1101                	addi	sp,sp,-32
    80001cc0:	ec06                	sd	ra,24(sp)
    80001cc2:	e822                	sd	s0,16(sp)
    80001cc4:	e426                	sd	s1,8(sp)
    80001cc6:	1000                	addi	s0,sp,32
    80001cc8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cca:	eefff0ef          	jal	80001bb8 <argraw>
    80001cce:	e088                	sd	a0,0(s1)
}
    80001cd0:	60e2                	ld	ra,24(sp)
    80001cd2:	6442                	ld	s0,16(sp)
    80001cd4:	64a2                	ld	s1,8(sp)
    80001cd6:	6105                	addi	sp,sp,32
    80001cd8:	8082                	ret

0000000080001cda <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cda:	7179                	addi	sp,sp,-48
    80001cdc:	f406                	sd	ra,40(sp)
    80001cde:	f022                	sd	s0,32(sp)
    80001ce0:	ec26                	sd	s1,24(sp)
    80001ce2:	e84a                	sd	s2,16(sp)
    80001ce4:	1800                	addi	s0,sp,48
    80001ce6:	84ae                	mv	s1,a1
    80001ce8:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cea:	fd840593          	addi	a1,s0,-40
    80001cee:	fd1ff0ef          	jal	80001cbe <argaddr>
  return fetchstr(addr, buf, max);
    80001cf2:	864a                	mv	a2,s2
    80001cf4:	85a6                	mv	a1,s1
    80001cf6:	fd843503          	ld	a0,-40(s0)
    80001cfa:	f69ff0ef          	jal	80001c62 <fetchstr>
}
    80001cfe:	70a2                	ld	ra,40(sp)
    80001d00:	7402                	ld	s0,32(sp)
    80001d02:	64e2                	ld	s1,24(sp)
    80001d04:	6942                	ld	s2,16(sp)
    80001d06:	6145                	addi	sp,sp,48
    80001d08:	8082                	ret

0000000080001d0a <syscall>:
[SYS_close]   sys_close,   
};

void
syscall(void)
{
    80001d0a:	1101                	addi	sp,sp,-32
    80001d0c:	ec06                	sd	ra,24(sp)
    80001d0e:	e822                	sd	s0,16(sp)
    80001d10:	e426                	sd	s1,8(sp)
    80001d12:	e04a                	sd	s2,0(sp)
    80001d14:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d16:	890ff0ef          	jal	80000da6 <myproc>
    80001d1a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d1c:	05853903          	ld	s2,88(a0)
    80001d20:	0a893783          	ld	a5,168(s2)
    80001d24:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d28:	37fd                	addiw	a5,a5,-1
    80001d2a:	4751                	li	a4,20
    80001d2c:	00f76f63          	bltu	a4,a5,80001d4a <syscall+0x40>
    80001d30:	00369713          	slli	a4,a3,0x3
    80001d34:	00006797          	auipc	a5,0x6
    80001d38:	a3c78793          	addi	a5,a5,-1476 # 80007770 <syscalls>
    80001d3c:	97ba                	add	a5,a5,a4
    80001d3e:	639c                	ld	a5,0(a5)
    80001d40:	c789                	beqz	a5,80001d4a <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d42:	9782                	jalr	a5
    80001d44:	06a93823          	sd	a0,112(s2)
    80001d48:	a829                	j	80001d62 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d4a:	15848613          	addi	a2,s1,344
    80001d4e:	588c                	lw	a1,48(s1)
    80001d50:	00005517          	auipc	a0,0x5
    80001d54:	5d850513          	addi	a0,a0,1496 # 80007328 <etext+0x328>
    80001d58:	5a0030ef          	jal	800052f8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d5c:	6cbc                	ld	a5,88(s1)
    80001d5e:	577d                	li	a4,-1
    80001d60:	fbb8                	sd	a4,112(a5)
  }
    80001d62:	60e2                	ld	ra,24(sp)
    80001d64:	6442                	ld	s0,16(sp)
    80001d66:	64a2                	ld	s1,8(sp)
    80001d68:	6902                	ld	s2,0(sp)
    80001d6a:	6105                	addi	sp,sp,32
    80001d6c:	8082                	ret

0000000080001d6e <sys_exit>:
#include "fcntl.h"       // flags
#include "syscall.h"     // SYS_interpose

uint64
sys_exit(void)
{
    80001d6e:	1101                	addi	sp,sp,-32
    80001d70:	ec06                	sd	ra,24(sp)
    80001d72:	e822                	sd	s0,16(sp)
    80001d74:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d76:	fec40593          	addi	a1,s0,-20
    80001d7a:	4501                	li	a0,0
    80001d7c:	f27ff0ef          	jal	80001ca2 <argint>
  kexit(n);
    80001d80:	fec42503          	lw	a0,-20(s0)
    80001d84:	f26ff0ef          	jal	800014aa <kexit>
  return 0;  // not reached
}
    80001d88:	4501                	li	a0,0
    80001d8a:	60e2                	ld	ra,24(sp)
    80001d8c:	6442                	ld	s0,16(sp)
    80001d8e:	6105                	addi	sp,sp,32
    80001d90:	8082                	ret

0000000080001d92 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d92:	1141                	addi	sp,sp,-16
    80001d94:	e406                	sd	ra,8(sp)
    80001d96:	e022                	sd	s0,0(sp)
    80001d98:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d9a:	80cff0ef          	jal	80000da6 <myproc>
}
    80001d9e:	5908                	lw	a0,48(a0)
    80001da0:	60a2                	ld	ra,8(sp)
    80001da2:	6402                	ld	s0,0(sp)
    80001da4:	0141                	addi	sp,sp,16
    80001da6:	8082                	ret

0000000080001da8 <sys_fork>:

uint64
sys_fork(void)
{
    80001da8:	1141                	addi	sp,sp,-16
    80001daa:	e406                	sd	ra,8(sp)
    80001dac:	e022                	sd	s0,0(sp)
    80001dae:	0800                	addi	s0,sp,16
  return kfork();
    80001db0:	b48ff0ef          	jal	800010f8 <kfork>
}
    80001db4:	60a2                	ld	ra,8(sp)
    80001db6:	6402                	ld	s0,0(sp)
    80001db8:	0141                	addi	sp,sp,16
    80001dba:	8082                	ret

0000000080001dbc <sys_wait>:

uint64
sys_wait(void)
{
    80001dbc:	1101                	addi	sp,sp,-32
    80001dbe:	ec06                	sd	ra,24(sp)
    80001dc0:	e822                	sd	s0,16(sp)
    80001dc2:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001dc4:	fe840593          	addi	a1,s0,-24
    80001dc8:	4501                	li	a0,0
    80001dca:	ef5ff0ef          	jal	80001cbe <argaddr>
  return kwait(p);
    80001dce:	fe843503          	ld	a0,-24(s0)
    80001dd2:	82fff0ef          	jal	80001600 <kwait>
}
    80001dd6:	60e2                	ld	ra,24(sp)
    80001dd8:	6442                	ld	s0,16(sp)
    80001dda:	6105                	addi	sp,sp,32
    80001ddc:	8082                	ret

0000000080001dde <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001dde:	7179                	addi	sp,sp,-48
    80001de0:	f406                	sd	ra,40(sp)
    80001de2:	f022                	sd	s0,32(sp)
    80001de4:	ec26                	sd	s1,24(sp)
    80001de6:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001de8:	fd840593          	addi	a1,s0,-40
    80001dec:	4501                	li	a0,0
    80001dee:	eb5ff0ef          	jal	80001ca2 <argint>
  argint(1, &t);
    80001df2:	fdc40593          	addi	a1,s0,-36
    80001df6:	4505                	li	a0,1
    80001df8:	eabff0ef          	jal	80001ca2 <argint>
  addr = myproc()->sz;
    80001dfc:	fabfe0ef          	jal	80000da6 <myproc>
    80001e00:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001e02:	fdc42703          	lw	a4,-36(s0)
    80001e06:	4785                	li	a5,1
    80001e08:	02f70163          	beq	a4,a5,80001e2a <sys_sbrk+0x4c>
    80001e0c:	fd842783          	lw	a5,-40(s0)
    80001e10:	0007cd63          	bltz	a5,80001e2a <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001e14:	97a6                	add	a5,a5,s1
    80001e16:	0297e863          	bltu	a5,s1,80001e46 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001e1a:	f8dfe0ef          	jal	80000da6 <myproc>
    80001e1e:	fd842703          	lw	a4,-40(s0)
    80001e22:	653c                	ld	a5,72(a0)
    80001e24:	97ba                	add	a5,a5,a4
    80001e26:	e53c                	sd	a5,72(a0)
    80001e28:	a039                	j	80001e36 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001e2a:	fd842503          	lw	a0,-40(s0)
    80001e2e:	a7aff0ef          	jal	800010a8 <growproc>
    80001e32:	00054863          	bltz	a0,80001e42 <sys_sbrk+0x64>
  }
  return addr;
}
    80001e36:	8526                	mv	a0,s1
    80001e38:	70a2                	ld	ra,40(sp)
    80001e3a:	7402                	ld	s0,32(sp)
    80001e3c:	64e2                	ld	s1,24(sp)
    80001e3e:	6145                	addi	sp,sp,48
    80001e40:	8082                	ret
      return -1;
    80001e42:	54fd                	li	s1,-1
    80001e44:	bfcd                	j	80001e36 <sys_sbrk+0x58>
      return -1;
    80001e46:	54fd                	li	s1,-1
    80001e48:	b7fd                	j	80001e36 <sys_sbrk+0x58>

0000000080001e4a <sys_pause>:

uint64
sys_pause(void)
{
    80001e4a:	7139                	addi	sp,sp,-64
    80001e4c:	fc06                	sd	ra,56(sp)
    80001e4e:	f822                	sd	s0,48(sp)
    80001e50:	f04a                	sd	s2,32(sp)
    80001e52:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e54:	fcc40593          	addi	a1,s0,-52
    80001e58:	4501                	li	a0,0
    80001e5a:	e49ff0ef          	jal	80001ca2 <argint>
  if(n < 0)
    80001e5e:	fcc42783          	lw	a5,-52(s0)
    80001e62:	0607c763          	bltz	a5,80001ed0 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001e66:	0000e517          	auipc	a0,0xe
    80001e6a:	1ca50513          	addi	a0,a0,458 # 80010030 <tickslock>
    80001e6e:	22d030ef          	jal	8000589a <acquire>
  ticks0 = ticks;
    80001e72:	00008917          	auipc	s2,0x8
    80001e76:	35692903          	lw	s2,854(s2) # 8000a1c8 <ticks>
  while(ticks - ticks0 < n){
    80001e7a:	fcc42783          	lw	a5,-52(s0)
    80001e7e:	cf8d                	beqz	a5,80001eb8 <sys_pause+0x6e>
    80001e80:	f426                	sd	s1,40(sp)
    80001e82:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e84:	0000e997          	auipc	s3,0xe
    80001e88:	1ac98993          	addi	s3,s3,428 # 80010030 <tickslock>
    80001e8c:	00008497          	auipc	s1,0x8
    80001e90:	33c48493          	addi	s1,s1,828 # 8000a1c8 <ticks>
    if(killed(myproc())){
    80001e94:	f13fe0ef          	jal	80000da6 <myproc>
    80001e98:	f3eff0ef          	jal	800015d6 <killed>
    80001e9c:	ed0d                	bnez	a0,80001ed6 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001e9e:	85ce                	mv	a1,s3
    80001ea0:	8526                	mv	a0,s1
    80001ea2:	cfcff0ef          	jal	8000139e <sleep>
  while(ticks - ticks0 < n){
    80001ea6:	409c                	lw	a5,0(s1)
    80001ea8:	412787bb          	subw	a5,a5,s2
    80001eac:	fcc42703          	lw	a4,-52(s0)
    80001eb0:	fee7e2e3          	bltu	a5,a4,80001e94 <sys_pause+0x4a>
    80001eb4:	74a2                	ld	s1,40(sp)
    80001eb6:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001eb8:	0000e517          	auipc	a0,0xe
    80001ebc:	17850513          	addi	a0,a0,376 # 80010030 <tickslock>
    80001ec0:	273030ef          	jal	80005932 <release>
  return 0;
    80001ec4:	4501                	li	a0,0
}
    80001ec6:	70e2                	ld	ra,56(sp)
    80001ec8:	7442                	ld	s0,48(sp)
    80001eca:	7902                	ld	s2,32(sp)
    80001ecc:	6121                	addi	sp,sp,64
    80001ece:	8082                	ret
    n = 0;
    80001ed0:	fc042623          	sw	zero,-52(s0)
    80001ed4:	bf49                	j	80001e66 <sys_pause+0x1c>
      release(&tickslock);
    80001ed6:	0000e517          	auipc	a0,0xe
    80001eda:	15a50513          	addi	a0,a0,346 # 80010030 <tickslock>
    80001ede:	255030ef          	jal	80005932 <release>
      return -1;
    80001ee2:	557d                	li	a0,-1
    80001ee4:	74a2                	ld	s1,40(sp)
    80001ee6:	69e2                	ld	s3,24(sp)
    80001ee8:	bff9                	j	80001ec6 <sys_pause+0x7c>

0000000080001eea <sys_kill>:

uint64
sys_kill(void)
{
    80001eea:	1101                	addi	sp,sp,-32
    80001eec:	ec06                	sd	ra,24(sp)
    80001eee:	e822                	sd	s0,16(sp)
    80001ef0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ef2:	fec40593          	addi	a1,s0,-20
    80001ef6:	4501                	li	a0,0
    80001ef8:	dabff0ef          	jal	80001ca2 <argint>
  return kkill(pid);
    80001efc:	fec42503          	lw	a0,-20(s0)
    80001f00:	e4cff0ef          	jal	8000154c <kkill>
}
    80001f04:	60e2                	ld	ra,24(sp)
    80001f06:	6442                	ld	s0,16(sp)
    80001f08:	6105                	addi	sp,sp,32
    80001f0a:	8082                	ret

0000000080001f0c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f0c:	1101                	addi	sp,sp,-32
    80001f0e:	ec06                	sd	ra,24(sp)
    80001f10:	e822                	sd	s0,16(sp)
    80001f12:	e426                	sd	s1,8(sp)
    80001f14:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f16:	0000e517          	auipc	a0,0xe
    80001f1a:	11a50513          	addi	a0,a0,282 # 80010030 <tickslock>
    80001f1e:	17d030ef          	jal	8000589a <acquire>
  xticks = ticks;
    80001f22:	00008497          	auipc	s1,0x8
    80001f26:	2a64a483          	lw	s1,678(s1) # 8000a1c8 <ticks>
  release(&tickslock);
    80001f2a:	0000e517          	auipc	a0,0xe
    80001f2e:	10650513          	addi	a0,a0,262 # 80010030 <tickslock>
    80001f32:	201030ef          	jal	80005932 <release>
  return xticks;
}
    80001f36:	02049513          	slli	a0,s1,0x20
    80001f3a:	9101                	srli	a0,a0,0x20
    80001f3c:	60e2                	ld	ra,24(sp)
    80001f3e:	6442                	ld	s0,16(sp)
    80001f40:	64a2                	ld	s1,8(sp)
    80001f42:	6105                	addi	sp,sp,32
    80001f44:	8082                	ret

0000000080001f46 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f46:	7179                	addi	sp,sp,-48
    80001f48:	f406                	sd	ra,40(sp)
    80001f4a:	f022                	sd	s0,32(sp)
    80001f4c:	ec26                	sd	s1,24(sp)
    80001f4e:	e84a                	sd	s2,16(sp)
    80001f50:	e44e                	sd	s3,8(sp)
    80001f52:	e052                	sd	s4,0(sp)
    80001f54:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f56:	00005597          	auipc	a1,0x5
    80001f5a:	3f258593          	addi	a1,a1,1010 # 80007348 <etext+0x348>
    80001f5e:	0000e517          	auipc	a0,0xe
    80001f62:	0ea50513          	addi	a0,a0,234 # 80010048 <bcache>
    80001f66:	0b5030ef          	jal	8000581a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f6a:	00016797          	auipc	a5,0x16
    80001f6e:	0de78793          	addi	a5,a5,222 # 80018048 <bcache+0x8000>
    80001f72:	00016717          	auipc	a4,0x16
    80001f76:	33e70713          	addi	a4,a4,830 # 800182b0 <bcache+0x8268>
    80001f7a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f7e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f82:	0000e497          	auipc	s1,0xe
    80001f86:	0de48493          	addi	s1,s1,222 # 80010060 <bcache+0x18>
    b->next = bcache.head.next;
    80001f8a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f8c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f8e:	00005a17          	auipc	s4,0x5
    80001f92:	3c2a0a13          	addi	s4,s4,962 # 80007350 <etext+0x350>
    b->next = bcache.head.next;
    80001f96:	2b893783          	ld	a5,696(s2)
    80001f9a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001f9c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001fa0:	85d2                	mv	a1,s4
    80001fa2:	01048513          	addi	a0,s1,16
    80001fa6:	322010ef          	jal	800032c8 <initsleeplock>
    bcache.head.next->prev = b;
    80001faa:	2b893783          	ld	a5,696(s2)
    80001fae:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001fb0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fb4:	45848493          	addi	s1,s1,1112
    80001fb8:	fd349fe3          	bne	s1,s3,80001f96 <binit+0x50>
  }
}
    80001fbc:	70a2                	ld	ra,40(sp)
    80001fbe:	7402                	ld	s0,32(sp)
    80001fc0:	64e2                	ld	s1,24(sp)
    80001fc2:	6942                	ld	s2,16(sp)
    80001fc4:	69a2                	ld	s3,8(sp)
    80001fc6:	6a02                	ld	s4,0(sp)
    80001fc8:	6145                	addi	sp,sp,48
    80001fca:	8082                	ret

0000000080001fcc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001fcc:	7179                	addi	sp,sp,-48
    80001fce:	f406                	sd	ra,40(sp)
    80001fd0:	f022                	sd	s0,32(sp)
    80001fd2:	ec26                	sd	s1,24(sp)
    80001fd4:	e84a                	sd	s2,16(sp)
    80001fd6:	e44e                	sd	s3,8(sp)
    80001fd8:	1800                	addi	s0,sp,48
    80001fda:	892a                	mv	s2,a0
    80001fdc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001fde:	0000e517          	auipc	a0,0xe
    80001fe2:	06a50513          	addi	a0,a0,106 # 80010048 <bcache>
    80001fe6:	0b5030ef          	jal	8000589a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001fea:	00016497          	auipc	s1,0x16
    80001fee:	3164b483          	ld	s1,790(s1) # 80018300 <bcache+0x82b8>
    80001ff2:	00016797          	auipc	a5,0x16
    80001ff6:	2be78793          	addi	a5,a5,702 # 800182b0 <bcache+0x8268>
    80001ffa:	02f48b63          	beq	s1,a5,80002030 <bread+0x64>
    80001ffe:	873e                	mv	a4,a5
    80002000:	a021                	j	80002008 <bread+0x3c>
    80002002:	68a4                	ld	s1,80(s1)
    80002004:	02e48663          	beq	s1,a4,80002030 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002008:	449c                	lw	a5,8(s1)
    8000200a:	ff279ce3          	bne	a5,s2,80002002 <bread+0x36>
    8000200e:	44dc                	lw	a5,12(s1)
    80002010:	ff3799e3          	bne	a5,s3,80002002 <bread+0x36>
      b->refcnt++;
    80002014:	40bc                	lw	a5,64(s1)
    80002016:	2785                	addiw	a5,a5,1
    80002018:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000201a:	0000e517          	auipc	a0,0xe
    8000201e:	02e50513          	addi	a0,a0,46 # 80010048 <bcache>
    80002022:	111030ef          	jal	80005932 <release>
      acquiresleep(&b->lock);
    80002026:	01048513          	addi	a0,s1,16
    8000202a:	2d4010ef          	jal	800032fe <acquiresleep>
      return b;
    8000202e:	a889                	j	80002080 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002030:	00016497          	auipc	s1,0x16
    80002034:	2c84b483          	ld	s1,712(s1) # 800182f8 <bcache+0x82b0>
    80002038:	00016797          	auipc	a5,0x16
    8000203c:	27878793          	addi	a5,a5,632 # 800182b0 <bcache+0x8268>
    80002040:	00f48863          	beq	s1,a5,80002050 <bread+0x84>
    80002044:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002046:	40bc                	lw	a5,64(s1)
    80002048:	cb91                	beqz	a5,8000205c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000204a:	64a4                	ld	s1,72(s1)
    8000204c:	fee49de3          	bne	s1,a4,80002046 <bread+0x7a>
  panic("bget: no buffers");
    80002050:	00005517          	auipc	a0,0x5
    80002054:	30850513          	addi	a0,a0,776 # 80007358 <etext+0x358>
    80002058:	586030ef          	jal	800055de <panic>
      b->dev = dev;
    8000205c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002060:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002064:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002068:	4785                	li	a5,1
    8000206a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000206c:	0000e517          	auipc	a0,0xe
    80002070:	fdc50513          	addi	a0,a0,-36 # 80010048 <bcache>
    80002074:	0bf030ef          	jal	80005932 <release>
      acquiresleep(&b->lock);
    80002078:	01048513          	addi	a0,s1,16
    8000207c:	282010ef          	jal	800032fe <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002080:	409c                	lw	a5,0(s1)
    80002082:	cb89                	beqz	a5,80002094 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002084:	8526                	mv	a0,s1
    80002086:	70a2                	ld	ra,40(sp)
    80002088:	7402                	ld	s0,32(sp)
    8000208a:	64e2                	ld	s1,24(sp)
    8000208c:	6942                	ld	s2,16(sp)
    8000208e:	69a2                	ld	s3,8(sp)
    80002090:	6145                	addi	sp,sp,48
    80002092:	8082                	ret
    virtio_disk_rw(b, 0);
    80002094:	4581                	li	a1,0
    80002096:	8526                	mv	a0,s1
    80002098:	2c9020ef          	jal	80004b60 <virtio_disk_rw>
    b->valid = 1;
    8000209c:	4785                	li	a5,1
    8000209e:	c09c                	sw	a5,0(s1)
  return b;
    800020a0:	b7d5                	j	80002084 <bread+0xb8>

00000000800020a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	1000                	addi	s0,sp,32
    800020ac:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020ae:	0541                	addi	a0,a0,16
    800020b0:	2cc010ef          	jal	8000337c <holdingsleep>
    800020b4:	c911                	beqz	a0,800020c8 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020b6:	4585                	li	a1,1
    800020b8:	8526                	mv	a0,s1
    800020ba:	2a7020ef          	jal	80004b60 <virtio_disk_rw>
}
    800020be:	60e2                	ld	ra,24(sp)
    800020c0:	6442                	ld	s0,16(sp)
    800020c2:	64a2                	ld	s1,8(sp)
    800020c4:	6105                	addi	sp,sp,32
    800020c6:	8082                	ret
    panic("bwrite");
    800020c8:	00005517          	auipc	a0,0x5
    800020cc:	2a850513          	addi	a0,a0,680 # 80007370 <etext+0x370>
    800020d0:	50e030ef          	jal	800055de <panic>

00000000800020d4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	e426                	sd	s1,8(sp)
    800020dc:	e04a                	sd	s2,0(sp)
    800020de:	1000                	addi	s0,sp,32
    800020e0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020e2:	01050913          	addi	s2,a0,16
    800020e6:	854a                	mv	a0,s2
    800020e8:	294010ef          	jal	8000337c <holdingsleep>
    800020ec:	c135                	beqz	a0,80002150 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800020ee:	854a                	mv	a0,s2
    800020f0:	254010ef          	jal	80003344 <releasesleep>

  acquire(&bcache.lock);
    800020f4:	0000e517          	auipc	a0,0xe
    800020f8:	f5450513          	addi	a0,a0,-172 # 80010048 <bcache>
    800020fc:	79e030ef          	jal	8000589a <acquire>
  b->refcnt--;
    80002100:	40bc                	lw	a5,64(s1)
    80002102:	37fd                	addiw	a5,a5,-1
    80002104:	0007871b          	sext.w	a4,a5
    80002108:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000210a:	e71d                	bnez	a4,80002138 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000210c:	68b8                	ld	a4,80(s1)
    8000210e:	64bc                	ld	a5,72(s1)
    80002110:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002112:	68b8                	ld	a4,80(s1)
    80002114:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002116:	00016797          	auipc	a5,0x16
    8000211a:	f3278793          	addi	a5,a5,-206 # 80018048 <bcache+0x8000>
    8000211e:	2b87b703          	ld	a4,696(a5)
    80002122:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002124:	00016717          	auipc	a4,0x16
    80002128:	18c70713          	addi	a4,a4,396 # 800182b0 <bcache+0x8268>
    8000212c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000212e:	2b87b703          	ld	a4,696(a5)
    80002132:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002134:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002138:	0000e517          	auipc	a0,0xe
    8000213c:	f1050513          	addi	a0,a0,-240 # 80010048 <bcache>
    80002140:	7f2030ef          	jal	80005932 <release>
}
    80002144:	60e2                	ld	ra,24(sp)
    80002146:	6442                	ld	s0,16(sp)
    80002148:	64a2                	ld	s1,8(sp)
    8000214a:	6902                	ld	s2,0(sp)
    8000214c:	6105                	addi	sp,sp,32
    8000214e:	8082                	ret
    panic("brelse");
    80002150:	00005517          	auipc	a0,0x5
    80002154:	22850513          	addi	a0,a0,552 # 80007378 <etext+0x378>
    80002158:	486030ef          	jal	800055de <panic>

000000008000215c <bpin>:

void
bpin(struct buf *b) {
    8000215c:	1101                	addi	sp,sp,-32
    8000215e:	ec06                	sd	ra,24(sp)
    80002160:	e822                	sd	s0,16(sp)
    80002162:	e426                	sd	s1,8(sp)
    80002164:	1000                	addi	s0,sp,32
    80002166:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002168:	0000e517          	auipc	a0,0xe
    8000216c:	ee050513          	addi	a0,a0,-288 # 80010048 <bcache>
    80002170:	72a030ef          	jal	8000589a <acquire>
  b->refcnt++;
    80002174:	40bc                	lw	a5,64(s1)
    80002176:	2785                	addiw	a5,a5,1
    80002178:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000217a:	0000e517          	auipc	a0,0xe
    8000217e:	ece50513          	addi	a0,a0,-306 # 80010048 <bcache>
    80002182:	7b0030ef          	jal	80005932 <release>
}
    80002186:	60e2                	ld	ra,24(sp)
    80002188:	6442                	ld	s0,16(sp)
    8000218a:	64a2                	ld	s1,8(sp)
    8000218c:	6105                	addi	sp,sp,32
    8000218e:	8082                	ret

0000000080002190 <bunpin>:

void
bunpin(struct buf *b) {
    80002190:	1101                	addi	sp,sp,-32
    80002192:	ec06                	sd	ra,24(sp)
    80002194:	e822                	sd	s0,16(sp)
    80002196:	e426                	sd	s1,8(sp)
    80002198:	1000                	addi	s0,sp,32
    8000219a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000219c:	0000e517          	auipc	a0,0xe
    800021a0:	eac50513          	addi	a0,a0,-340 # 80010048 <bcache>
    800021a4:	6f6030ef          	jal	8000589a <acquire>
  b->refcnt--;
    800021a8:	40bc                	lw	a5,64(s1)
    800021aa:	37fd                	addiw	a5,a5,-1
    800021ac:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021ae:	0000e517          	auipc	a0,0xe
    800021b2:	e9a50513          	addi	a0,a0,-358 # 80010048 <bcache>
    800021b6:	77c030ef          	jal	80005932 <release>
}
    800021ba:	60e2                	ld	ra,24(sp)
    800021bc:	6442                	ld	s0,16(sp)
    800021be:	64a2                	ld	s1,8(sp)
    800021c0:	6105                	addi	sp,sp,32
    800021c2:	8082                	ret

00000000800021c4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800021c4:	1101                	addi	sp,sp,-32
    800021c6:	ec06                	sd	ra,24(sp)
    800021c8:	e822                	sd	s0,16(sp)
    800021ca:	e426                	sd	s1,8(sp)
    800021cc:	e04a                	sd	s2,0(sp)
    800021ce:	1000                	addi	s0,sp,32
    800021d0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021d2:	00d5d59b          	srliw	a1,a1,0xd
    800021d6:	00016797          	auipc	a5,0x16
    800021da:	54e7a783          	lw	a5,1358(a5) # 80018724 <sb+0x1c>
    800021de:	9dbd                	addw	a1,a1,a5
    800021e0:	dedff0ef          	jal	80001fcc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800021e4:	0074f713          	andi	a4,s1,7
    800021e8:	4785                	li	a5,1
    800021ea:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800021ee:	14ce                	slli	s1,s1,0x33
    800021f0:	90d9                	srli	s1,s1,0x36
    800021f2:	00950733          	add	a4,a0,s1
    800021f6:	05874703          	lbu	a4,88(a4)
    800021fa:	00e7f6b3          	and	a3,a5,a4
    800021fe:	c29d                	beqz	a3,80002224 <bfree+0x60>
    80002200:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002202:	94aa                	add	s1,s1,a0
    80002204:	fff7c793          	not	a5,a5
    80002208:	8f7d                	and	a4,a4,a5
    8000220a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000220e:	7f9000ef          	jal	80003206 <log_write>
  brelse(bp);
    80002212:	854a                	mv	a0,s2
    80002214:	ec1ff0ef          	jal	800020d4 <brelse>
}
    80002218:	60e2                	ld	ra,24(sp)
    8000221a:	6442                	ld	s0,16(sp)
    8000221c:	64a2                	ld	s1,8(sp)
    8000221e:	6902                	ld	s2,0(sp)
    80002220:	6105                	addi	sp,sp,32
    80002222:	8082                	ret
    panic("freeing free block");
    80002224:	00005517          	auipc	a0,0x5
    80002228:	15c50513          	addi	a0,a0,348 # 80007380 <etext+0x380>
    8000222c:	3b2030ef          	jal	800055de <panic>

0000000080002230 <balloc>:
{
    80002230:	711d                	addi	sp,sp,-96
    80002232:	ec86                	sd	ra,88(sp)
    80002234:	e8a2                	sd	s0,80(sp)
    80002236:	e4a6                	sd	s1,72(sp)
    80002238:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000223a:	00016797          	auipc	a5,0x16
    8000223e:	4d27a783          	lw	a5,1234(a5) # 8001870c <sb+0x4>
    80002242:	0e078f63          	beqz	a5,80002340 <balloc+0x110>
    80002246:	e0ca                	sd	s2,64(sp)
    80002248:	fc4e                	sd	s3,56(sp)
    8000224a:	f852                	sd	s4,48(sp)
    8000224c:	f456                	sd	s5,40(sp)
    8000224e:	f05a                	sd	s6,32(sp)
    80002250:	ec5e                	sd	s7,24(sp)
    80002252:	e862                	sd	s8,16(sp)
    80002254:	e466                	sd	s9,8(sp)
    80002256:	8baa                	mv	s7,a0
    80002258:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000225a:	00016b17          	auipc	s6,0x16
    8000225e:	4aeb0b13          	addi	s6,s6,1198 # 80018708 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002262:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002264:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002266:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002268:	6c89                	lui	s9,0x2
    8000226a:	a0b5                	j	800022d6 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000226c:	97ca                	add	a5,a5,s2
    8000226e:	8e55                	or	a2,a2,a3
    80002270:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002274:	854a                	mv	a0,s2
    80002276:	791000ef          	jal	80003206 <log_write>
        brelse(bp);
    8000227a:	854a                	mv	a0,s2
    8000227c:	e59ff0ef          	jal	800020d4 <brelse>
  bp = bread(dev, bno);
    80002280:	85a6                	mv	a1,s1
    80002282:	855e                	mv	a0,s7
    80002284:	d49ff0ef          	jal	80001fcc <bread>
    80002288:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000228a:	40000613          	li	a2,1024
    8000228e:	4581                	li	a1,0
    80002290:	05850513          	addi	a0,a0,88
    80002294:	ebbfd0ef          	jal	8000014e <memset>
  log_write(bp);
    80002298:	854a                	mv	a0,s2
    8000229a:	76d000ef          	jal	80003206 <log_write>
  brelse(bp);
    8000229e:	854a                	mv	a0,s2
    800022a0:	e35ff0ef          	jal	800020d4 <brelse>
}
    800022a4:	6906                	ld	s2,64(sp)
    800022a6:	79e2                	ld	s3,56(sp)
    800022a8:	7a42                	ld	s4,48(sp)
    800022aa:	7aa2                	ld	s5,40(sp)
    800022ac:	7b02                	ld	s6,32(sp)
    800022ae:	6be2                	ld	s7,24(sp)
    800022b0:	6c42                	ld	s8,16(sp)
    800022b2:	6ca2                	ld	s9,8(sp)
}
    800022b4:	8526                	mv	a0,s1
    800022b6:	60e6                	ld	ra,88(sp)
    800022b8:	6446                	ld	s0,80(sp)
    800022ba:	64a6                	ld	s1,72(sp)
    800022bc:	6125                	addi	sp,sp,96
    800022be:	8082                	ret
    brelse(bp);
    800022c0:	854a                	mv	a0,s2
    800022c2:	e13ff0ef          	jal	800020d4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800022c6:	015c87bb          	addw	a5,s9,s5
    800022ca:	00078a9b          	sext.w	s5,a5
    800022ce:	004b2703          	lw	a4,4(s6)
    800022d2:	04eaff63          	bgeu	s5,a4,80002330 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800022d6:	41fad79b          	sraiw	a5,s5,0x1f
    800022da:	0137d79b          	srliw	a5,a5,0x13
    800022de:	015787bb          	addw	a5,a5,s5
    800022e2:	40d7d79b          	sraiw	a5,a5,0xd
    800022e6:	01cb2583          	lw	a1,28(s6)
    800022ea:	9dbd                	addw	a1,a1,a5
    800022ec:	855e                	mv	a0,s7
    800022ee:	cdfff0ef          	jal	80001fcc <bread>
    800022f2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022f4:	004b2503          	lw	a0,4(s6)
    800022f8:	000a849b          	sext.w	s1,s5
    800022fc:	8762                	mv	a4,s8
    800022fe:	fca4f1e3          	bgeu	s1,a0,800022c0 <balloc+0x90>
      m = 1 << (bi % 8);
    80002302:	00777693          	andi	a3,a4,7
    80002306:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000230a:	41f7579b          	sraiw	a5,a4,0x1f
    8000230e:	01d7d79b          	srliw	a5,a5,0x1d
    80002312:	9fb9                	addw	a5,a5,a4
    80002314:	4037d79b          	sraiw	a5,a5,0x3
    80002318:	00f90633          	add	a2,s2,a5
    8000231c:	05864603          	lbu	a2,88(a2)
    80002320:	00c6f5b3          	and	a1,a3,a2
    80002324:	d5a1                	beqz	a1,8000226c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002326:	2705                	addiw	a4,a4,1
    80002328:	2485                	addiw	s1,s1,1
    8000232a:	fd471ae3          	bne	a4,s4,800022fe <balloc+0xce>
    8000232e:	bf49                	j	800022c0 <balloc+0x90>
    80002330:	6906                	ld	s2,64(sp)
    80002332:	79e2                	ld	s3,56(sp)
    80002334:	7a42                	ld	s4,48(sp)
    80002336:	7aa2                	ld	s5,40(sp)
    80002338:	7b02                	ld	s6,32(sp)
    8000233a:	6be2                	ld	s7,24(sp)
    8000233c:	6c42                	ld	s8,16(sp)
    8000233e:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002340:	00005517          	auipc	a0,0x5
    80002344:	05850513          	addi	a0,a0,88 # 80007398 <etext+0x398>
    80002348:	7b1020ef          	jal	800052f8 <printf>
  return 0;
    8000234c:	4481                	li	s1,0
    8000234e:	b79d                	j	800022b4 <balloc+0x84>

0000000080002350 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002350:	7179                	addi	sp,sp,-48
    80002352:	f406                	sd	ra,40(sp)
    80002354:	f022                	sd	s0,32(sp)
    80002356:	ec26                	sd	s1,24(sp)
    80002358:	e84a                	sd	s2,16(sp)
    8000235a:	e44e                	sd	s3,8(sp)
    8000235c:	1800                	addi	s0,sp,48
    8000235e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002360:	47ad                	li	a5,11
    80002362:	02b7e663          	bltu	a5,a1,8000238e <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002366:	02059793          	slli	a5,a1,0x20
    8000236a:	01e7d593          	srli	a1,a5,0x1e
    8000236e:	00b504b3          	add	s1,a0,a1
    80002372:	0504a903          	lw	s2,80(s1)
    80002376:	06091a63          	bnez	s2,800023ea <bmap+0x9a>
      addr = balloc(ip->dev);
    8000237a:	4108                	lw	a0,0(a0)
    8000237c:	eb5ff0ef          	jal	80002230 <balloc>
    80002380:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002384:	06090363          	beqz	s2,800023ea <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002388:	0524a823          	sw	s2,80(s1)
    8000238c:	a8b9                	j	800023ea <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000238e:	ff45849b          	addiw	s1,a1,-12
    80002392:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002396:	0ff00793          	li	a5,255
    8000239a:	06e7ee63          	bltu	a5,a4,80002416 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000239e:	08052903          	lw	s2,128(a0)
    800023a2:	00091d63          	bnez	s2,800023bc <bmap+0x6c>
      addr = balloc(ip->dev);
    800023a6:	4108                	lw	a0,0(a0)
    800023a8:	e89ff0ef          	jal	80002230 <balloc>
    800023ac:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023b0:	02090d63          	beqz	s2,800023ea <bmap+0x9a>
    800023b4:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023b6:	0929a023          	sw	s2,128(s3)
    800023ba:	a011                	j	800023be <bmap+0x6e>
    800023bc:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023be:	85ca                	mv	a1,s2
    800023c0:	0009a503          	lw	a0,0(s3)
    800023c4:	c09ff0ef          	jal	80001fcc <bread>
    800023c8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023ca:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023ce:	02049713          	slli	a4,s1,0x20
    800023d2:	01e75593          	srli	a1,a4,0x1e
    800023d6:	00b784b3          	add	s1,a5,a1
    800023da:	0004a903          	lw	s2,0(s1)
    800023de:	00090e63          	beqz	s2,800023fa <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800023e2:	8552                	mv	a0,s4
    800023e4:	cf1ff0ef          	jal	800020d4 <brelse>
    return addr;
    800023e8:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800023ea:	854a                	mv	a0,s2
    800023ec:	70a2                	ld	ra,40(sp)
    800023ee:	7402                	ld	s0,32(sp)
    800023f0:	64e2                	ld	s1,24(sp)
    800023f2:	6942                	ld	s2,16(sp)
    800023f4:	69a2                	ld	s3,8(sp)
    800023f6:	6145                	addi	sp,sp,48
    800023f8:	8082                	ret
      addr = balloc(ip->dev);
    800023fa:	0009a503          	lw	a0,0(s3)
    800023fe:	e33ff0ef          	jal	80002230 <balloc>
    80002402:	0005091b          	sext.w	s2,a0
      if(addr){
    80002406:	fc090ee3          	beqz	s2,800023e2 <bmap+0x92>
        a[bn] = addr;
    8000240a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000240e:	8552                	mv	a0,s4
    80002410:	5f7000ef          	jal	80003206 <log_write>
    80002414:	b7f9                	j	800023e2 <bmap+0x92>
    80002416:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002418:	00005517          	auipc	a0,0x5
    8000241c:	f9850513          	addi	a0,a0,-104 # 800073b0 <etext+0x3b0>
    80002420:	1be030ef          	jal	800055de <panic>

0000000080002424 <iget>:
{
    80002424:	7179                	addi	sp,sp,-48
    80002426:	f406                	sd	ra,40(sp)
    80002428:	f022                	sd	s0,32(sp)
    8000242a:	ec26                	sd	s1,24(sp)
    8000242c:	e84a                	sd	s2,16(sp)
    8000242e:	e44e                	sd	s3,8(sp)
    80002430:	e052                	sd	s4,0(sp)
    80002432:	1800                	addi	s0,sp,48
    80002434:	89aa                	mv	s3,a0
    80002436:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002438:	00016517          	auipc	a0,0x16
    8000243c:	2f050513          	addi	a0,a0,752 # 80018728 <itable>
    80002440:	45a030ef          	jal	8000589a <acquire>
  empty = 0;
    80002444:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002446:	00016497          	auipc	s1,0x16
    8000244a:	2fa48493          	addi	s1,s1,762 # 80018740 <itable+0x18>
    8000244e:	00018697          	auipc	a3,0x18
    80002452:	d8268693          	addi	a3,a3,-638 # 8001a1d0 <log>
    80002456:	a039                	j	80002464 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002458:	02090963          	beqz	s2,8000248a <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000245c:	08848493          	addi	s1,s1,136
    80002460:	02d48863          	beq	s1,a3,80002490 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002464:	449c                	lw	a5,8(s1)
    80002466:	fef059e3          	blez	a5,80002458 <iget+0x34>
    8000246a:	4098                	lw	a4,0(s1)
    8000246c:	ff3716e3          	bne	a4,s3,80002458 <iget+0x34>
    80002470:	40d8                	lw	a4,4(s1)
    80002472:	ff4713e3          	bne	a4,s4,80002458 <iget+0x34>
      ip->ref++;
    80002476:	2785                	addiw	a5,a5,1
    80002478:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000247a:	00016517          	auipc	a0,0x16
    8000247e:	2ae50513          	addi	a0,a0,686 # 80018728 <itable>
    80002482:	4b0030ef          	jal	80005932 <release>
      return ip;
    80002486:	8926                	mv	s2,s1
    80002488:	a02d                	j	800024b2 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000248a:	fbe9                	bnez	a5,8000245c <iget+0x38>
      empty = ip;
    8000248c:	8926                	mv	s2,s1
    8000248e:	b7f9                	j	8000245c <iget+0x38>
  if(empty == 0)
    80002490:	02090a63          	beqz	s2,800024c4 <iget+0xa0>
  ip->dev = dev;
    80002494:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002498:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000249c:	4785                	li	a5,1
    8000249e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024a2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024a6:	00016517          	auipc	a0,0x16
    800024aa:	28250513          	addi	a0,a0,642 # 80018728 <itable>
    800024ae:	484030ef          	jal	80005932 <release>
}
    800024b2:	854a                	mv	a0,s2
    800024b4:	70a2                	ld	ra,40(sp)
    800024b6:	7402                	ld	s0,32(sp)
    800024b8:	64e2                	ld	s1,24(sp)
    800024ba:	6942                	ld	s2,16(sp)
    800024bc:	69a2                	ld	s3,8(sp)
    800024be:	6a02                	ld	s4,0(sp)
    800024c0:	6145                	addi	sp,sp,48
    800024c2:	8082                	ret
    panic("iget: no inodes");
    800024c4:	00005517          	auipc	a0,0x5
    800024c8:	f0450513          	addi	a0,a0,-252 # 800073c8 <etext+0x3c8>
    800024cc:	112030ef          	jal	800055de <panic>

00000000800024d0 <iinit>:
{
    800024d0:	7179                	addi	sp,sp,-48
    800024d2:	f406                	sd	ra,40(sp)
    800024d4:	f022                	sd	s0,32(sp)
    800024d6:	ec26                	sd	s1,24(sp)
    800024d8:	e84a                	sd	s2,16(sp)
    800024da:	e44e                	sd	s3,8(sp)
    800024dc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800024de:	00005597          	auipc	a1,0x5
    800024e2:	efa58593          	addi	a1,a1,-262 # 800073d8 <etext+0x3d8>
    800024e6:	00016517          	auipc	a0,0x16
    800024ea:	24250513          	addi	a0,a0,578 # 80018728 <itable>
    800024ee:	32c030ef          	jal	8000581a <initlock>
  for(i = 0; i < NINODE; i++) {
    800024f2:	00016497          	auipc	s1,0x16
    800024f6:	25e48493          	addi	s1,s1,606 # 80018750 <itable+0x28>
    800024fa:	00018997          	auipc	s3,0x18
    800024fe:	ce698993          	addi	s3,s3,-794 # 8001a1e0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002502:	00005917          	auipc	s2,0x5
    80002506:	ede90913          	addi	s2,s2,-290 # 800073e0 <etext+0x3e0>
    8000250a:	85ca                	mv	a1,s2
    8000250c:	8526                	mv	a0,s1
    8000250e:	5bb000ef          	jal	800032c8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002512:	08848493          	addi	s1,s1,136
    80002516:	ff349ae3          	bne	s1,s3,8000250a <iinit+0x3a>
}
    8000251a:	70a2                	ld	ra,40(sp)
    8000251c:	7402                	ld	s0,32(sp)
    8000251e:	64e2                	ld	s1,24(sp)
    80002520:	6942                	ld	s2,16(sp)
    80002522:	69a2                	ld	s3,8(sp)
    80002524:	6145                	addi	sp,sp,48
    80002526:	8082                	ret

0000000080002528 <ialloc>:
{
    80002528:	7139                	addi	sp,sp,-64
    8000252a:	fc06                	sd	ra,56(sp)
    8000252c:	f822                	sd	s0,48(sp)
    8000252e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002530:	00016717          	auipc	a4,0x16
    80002534:	1e472703          	lw	a4,484(a4) # 80018714 <sb+0xc>
    80002538:	4785                	li	a5,1
    8000253a:	06e7f063          	bgeu	a5,a4,8000259a <ialloc+0x72>
    8000253e:	f426                	sd	s1,40(sp)
    80002540:	f04a                	sd	s2,32(sp)
    80002542:	ec4e                	sd	s3,24(sp)
    80002544:	e852                	sd	s4,16(sp)
    80002546:	e456                	sd	s5,8(sp)
    80002548:	e05a                	sd	s6,0(sp)
    8000254a:	8aaa                	mv	s5,a0
    8000254c:	8b2e                	mv	s6,a1
    8000254e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002550:	00016a17          	auipc	s4,0x16
    80002554:	1b8a0a13          	addi	s4,s4,440 # 80018708 <sb>
    80002558:	00495593          	srli	a1,s2,0x4
    8000255c:	018a2783          	lw	a5,24(s4)
    80002560:	9dbd                	addw	a1,a1,a5
    80002562:	8556                	mv	a0,s5
    80002564:	a69ff0ef          	jal	80001fcc <bread>
    80002568:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000256a:	05850993          	addi	s3,a0,88
    8000256e:	00f97793          	andi	a5,s2,15
    80002572:	079a                	slli	a5,a5,0x6
    80002574:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002576:	00099783          	lh	a5,0(s3)
    8000257a:	cb9d                	beqz	a5,800025b0 <ialloc+0x88>
    brelse(bp);
    8000257c:	b59ff0ef          	jal	800020d4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002580:	0905                	addi	s2,s2,1
    80002582:	00ca2703          	lw	a4,12(s4)
    80002586:	0009079b          	sext.w	a5,s2
    8000258a:	fce7e7e3          	bltu	a5,a4,80002558 <ialloc+0x30>
    8000258e:	74a2                	ld	s1,40(sp)
    80002590:	7902                	ld	s2,32(sp)
    80002592:	69e2                	ld	s3,24(sp)
    80002594:	6a42                	ld	s4,16(sp)
    80002596:	6aa2                	ld	s5,8(sp)
    80002598:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000259a:	00005517          	auipc	a0,0x5
    8000259e:	e4e50513          	addi	a0,a0,-434 # 800073e8 <etext+0x3e8>
    800025a2:	557020ef          	jal	800052f8 <printf>
  return 0;
    800025a6:	4501                	li	a0,0
}
    800025a8:	70e2                	ld	ra,56(sp)
    800025aa:	7442                	ld	s0,48(sp)
    800025ac:	6121                	addi	sp,sp,64
    800025ae:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800025b0:	04000613          	li	a2,64
    800025b4:	4581                	li	a1,0
    800025b6:	854e                	mv	a0,s3
    800025b8:	b97fd0ef          	jal	8000014e <memset>
      dip->type = type;
    800025bc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800025c0:	8526                	mv	a0,s1
    800025c2:	445000ef          	jal	80003206 <log_write>
      brelse(bp);
    800025c6:	8526                	mv	a0,s1
    800025c8:	b0dff0ef          	jal	800020d4 <brelse>
      return iget(dev, inum);
    800025cc:	0009059b          	sext.w	a1,s2
    800025d0:	8556                	mv	a0,s5
    800025d2:	e53ff0ef          	jal	80002424 <iget>
    800025d6:	74a2                	ld	s1,40(sp)
    800025d8:	7902                	ld	s2,32(sp)
    800025da:	69e2                	ld	s3,24(sp)
    800025dc:	6a42                	ld	s4,16(sp)
    800025de:	6aa2                	ld	s5,8(sp)
    800025e0:	6b02                	ld	s6,0(sp)
    800025e2:	b7d9                	j	800025a8 <ialloc+0x80>

00000000800025e4 <iupdate>:
{
    800025e4:	1101                	addi	sp,sp,-32
    800025e6:	ec06                	sd	ra,24(sp)
    800025e8:	e822                	sd	s0,16(sp)
    800025ea:	e426                	sd	s1,8(sp)
    800025ec:	e04a                	sd	s2,0(sp)
    800025ee:	1000                	addi	s0,sp,32
    800025f0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800025f2:	415c                	lw	a5,4(a0)
    800025f4:	0047d79b          	srliw	a5,a5,0x4
    800025f8:	00016597          	auipc	a1,0x16
    800025fc:	1285a583          	lw	a1,296(a1) # 80018720 <sb+0x18>
    80002600:	9dbd                	addw	a1,a1,a5
    80002602:	4108                	lw	a0,0(a0)
    80002604:	9c9ff0ef          	jal	80001fcc <bread>
    80002608:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000260a:	05850793          	addi	a5,a0,88
    8000260e:	40d8                	lw	a4,4(s1)
    80002610:	8b3d                	andi	a4,a4,15
    80002612:	071a                	slli	a4,a4,0x6
    80002614:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002616:	04449703          	lh	a4,68(s1)
    8000261a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000261e:	04649703          	lh	a4,70(s1)
    80002622:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002626:	04849703          	lh	a4,72(s1)
    8000262a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000262e:	04a49703          	lh	a4,74(s1)
    80002632:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002636:	44f8                	lw	a4,76(s1)
    80002638:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000263a:	03400613          	li	a2,52
    8000263e:	05048593          	addi	a1,s1,80
    80002642:	00c78513          	addi	a0,a5,12
    80002646:	b65fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    8000264a:	854a                	mv	a0,s2
    8000264c:	3bb000ef          	jal	80003206 <log_write>
  brelse(bp);
    80002650:	854a                	mv	a0,s2
    80002652:	a83ff0ef          	jal	800020d4 <brelse>
}
    80002656:	60e2                	ld	ra,24(sp)
    80002658:	6442                	ld	s0,16(sp)
    8000265a:	64a2                	ld	s1,8(sp)
    8000265c:	6902                	ld	s2,0(sp)
    8000265e:	6105                	addi	sp,sp,32
    80002660:	8082                	ret

0000000080002662 <idup>:
{
    80002662:	1101                	addi	sp,sp,-32
    80002664:	ec06                	sd	ra,24(sp)
    80002666:	e822                	sd	s0,16(sp)
    80002668:	e426                	sd	s1,8(sp)
    8000266a:	1000                	addi	s0,sp,32
    8000266c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000266e:	00016517          	auipc	a0,0x16
    80002672:	0ba50513          	addi	a0,a0,186 # 80018728 <itable>
    80002676:	224030ef          	jal	8000589a <acquire>
  ip->ref++;
    8000267a:	449c                	lw	a5,8(s1)
    8000267c:	2785                	addiw	a5,a5,1
    8000267e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002680:	00016517          	auipc	a0,0x16
    80002684:	0a850513          	addi	a0,a0,168 # 80018728 <itable>
    80002688:	2aa030ef          	jal	80005932 <release>
}
    8000268c:	8526                	mv	a0,s1
    8000268e:	60e2                	ld	ra,24(sp)
    80002690:	6442                	ld	s0,16(sp)
    80002692:	64a2                	ld	s1,8(sp)
    80002694:	6105                	addi	sp,sp,32
    80002696:	8082                	ret

0000000080002698 <ilock>:
{
    80002698:	1101                	addi	sp,sp,-32
    8000269a:	ec06                	sd	ra,24(sp)
    8000269c:	e822                	sd	s0,16(sp)
    8000269e:	e426                	sd	s1,8(sp)
    800026a0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026a2:	cd19                	beqz	a0,800026c0 <ilock+0x28>
    800026a4:	84aa                	mv	s1,a0
    800026a6:	451c                	lw	a5,8(a0)
    800026a8:	00f05c63          	blez	a5,800026c0 <ilock+0x28>
  acquiresleep(&ip->lock);
    800026ac:	0541                	addi	a0,a0,16
    800026ae:	451000ef          	jal	800032fe <acquiresleep>
  if(ip->valid == 0){
    800026b2:	40bc                	lw	a5,64(s1)
    800026b4:	cf89                	beqz	a5,800026ce <ilock+0x36>
}
    800026b6:	60e2                	ld	ra,24(sp)
    800026b8:	6442                	ld	s0,16(sp)
    800026ba:	64a2                	ld	s1,8(sp)
    800026bc:	6105                	addi	sp,sp,32
    800026be:	8082                	ret
    800026c0:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800026c2:	00005517          	auipc	a0,0x5
    800026c6:	d3e50513          	addi	a0,a0,-706 # 80007400 <etext+0x400>
    800026ca:	715020ef          	jal	800055de <panic>
    800026ce:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026d0:	40dc                	lw	a5,4(s1)
    800026d2:	0047d79b          	srliw	a5,a5,0x4
    800026d6:	00016597          	auipc	a1,0x16
    800026da:	04a5a583          	lw	a1,74(a1) # 80018720 <sb+0x18>
    800026de:	9dbd                	addw	a1,a1,a5
    800026e0:	4088                	lw	a0,0(s1)
    800026e2:	8ebff0ef          	jal	80001fcc <bread>
    800026e6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026e8:	05850593          	addi	a1,a0,88
    800026ec:	40dc                	lw	a5,4(s1)
    800026ee:	8bbd                	andi	a5,a5,15
    800026f0:	079a                	slli	a5,a5,0x6
    800026f2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800026f4:	00059783          	lh	a5,0(a1)
    800026f8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800026fc:	00259783          	lh	a5,2(a1)
    80002700:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002704:	00459783          	lh	a5,4(a1)
    80002708:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000270c:	00659783          	lh	a5,6(a1)
    80002710:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002714:	459c                	lw	a5,8(a1)
    80002716:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002718:	03400613          	li	a2,52
    8000271c:	05b1                	addi	a1,a1,12
    8000271e:	05048513          	addi	a0,s1,80
    80002722:	a89fd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002726:	854a                	mv	a0,s2
    80002728:	9adff0ef          	jal	800020d4 <brelse>
    ip->valid = 1;
    8000272c:	4785                	li	a5,1
    8000272e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002730:	04449783          	lh	a5,68(s1)
    80002734:	c399                	beqz	a5,8000273a <ilock+0xa2>
    80002736:	6902                	ld	s2,0(sp)
    80002738:	bfbd                	j	800026b6 <ilock+0x1e>
      panic("ilock: no type");
    8000273a:	00005517          	auipc	a0,0x5
    8000273e:	cce50513          	addi	a0,a0,-818 # 80007408 <etext+0x408>
    80002742:	69d020ef          	jal	800055de <panic>

0000000080002746 <iunlock>:
{
    80002746:	1101                	addi	sp,sp,-32
    80002748:	ec06                	sd	ra,24(sp)
    8000274a:	e822                	sd	s0,16(sp)
    8000274c:	e426                	sd	s1,8(sp)
    8000274e:	e04a                	sd	s2,0(sp)
    80002750:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002752:	c505                	beqz	a0,8000277a <iunlock+0x34>
    80002754:	84aa                	mv	s1,a0
    80002756:	01050913          	addi	s2,a0,16
    8000275a:	854a                	mv	a0,s2
    8000275c:	421000ef          	jal	8000337c <holdingsleep>
    80002760:	cd09                	beqz	a0,8000277a <iunlock+0x34>
    80002762:	449c                	lw	a5,8(s1)
    80002764:	00f05b63          	blez	a5,8000277a <iunlock+0x34>
  releasesleep(&ip->lock);
    80002768:	854a                	mv	a0,s2
    8000276a:	3db000ef          	jal	80003344 <releasesleep>
}
    8000276e:	60e2                	ld	ra,24(sp)
    80002770:	6442                	ld	s0,16(sp)
    80002772:	64a2                	ld	s1,8(sp)
    80002774:	6902                	ld	s2,0(sp)
    80002776:	6105                	addi	sp,sp,32
    80002778:	8082                	ret
    panic("iunlock");
    8000277a:	00005517          	auipc	a0,0x5
    8000277e:	c9e50513          	addi	a0,a0,-866 # 80007418 <etext+0x418>
    80002782:	65d020ef          	jal	800055de <panic>

0000000080002786 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002786:	7179                	addi	sp,sp,-48
    80002788:	f406                	sd	ra,40(sp)
    8000278a:	f022                	sd	s0,32(sp)
    8000278c:	ec26                	sd	s1,24(sp)
    8000278e:	e84a                	sd	s2,16(sp)
    80002790:	e44e                	sd	s3,8(sp)
    80002792:	1800                	addi	s0,sp,48
    80002794:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002796:	05050493          	addi	s1,a0,80
    8000279a:	08050913          	addi	s2,a0,128
    8000279e:	a021                	j	800027a6 <itrunc+0x20>
    800027a0:	0491                	addi	s1,s1,4
    800027a2:	01248b63          	beq	s1,s2,800027b8 <itrunc+0x32>
    if(ip->addrs[i]){
    800027a6:	408c                	lw	a1,0(s1)
    800027a8:	dde5                	beqz	a1,800027a0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800027aa:	0009a503          	lw	a0,0(s3)
    800027ae:	a17ff0ef          	jal	800021c4 <bfree>
      ip->addrs[i] = 0;
    800027b2:	0004a023          	sw	zero,0(s1)
    800027b6:	b7ed                	j	800027a0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800027b8:	0809a583          	lw	a1,128(s3)
    800027bc:	ed89                	bnez	a1,800027d6 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800027be:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800027c2:	854e                	mv	a0,s3
    800027c4:	e21ff0ef          	jal	800025e4 <iupdate>
}
    800027c8:	70a2                	ld	ra,40(sp)
    800027ca:	7402                	ld	s0,32(sp)
    800027cc:	64e2                	ld	s1,24(sp)
    800027ce:	6942                	ld	s2,16(sp)
    800027d0:	69a2                	ld	s3,8(sp)
    800027d2:	6145                	addi	sp,sp,48
    800027d4:	8082                	ret
    800027d6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800027d8:	0009a503          	lw	a0,0(s3)
    800027dc:	ff0ff0ef          	jal	80001fcc <bread>
    800027e0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800027e2:	05850493          	addi	s1,a0,88
    800027e6:	45850913          	addi	s2,a0,1112
    800027ea:	a021                	j	800027f2 <itrunc+0x6c>
    800027ec:	0491                	addi	s1,s1,4
    800027ee:	01248963          	beq	s1,s2,80002800 <itrunc+0x7a>
      if(a[j])
    800027f2:	408c                	lw	a1,0(s1)
    800027f4:	dde5                	beqz	a1,800027ec <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800027f6:	0009a503          	lw	a0,0(s3)
    800027fa:	9cbff0ef          	jal	800021c4 <bfree>
    800027fe:	b7fd                	j	800027ec <itrunc+0x66>
    brelse(bp);
    80002800:	8552                	mv	a0,s4
    80002802:	8d3ff0ef          	jal	800020d4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002806:	0809a583          	lw	a1,128(s3)
    8000280a:	0009a503          	lw	a0,0(s3)
    8000280e:	9b7ff0ef          	jal	800021c4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002812:	0809a023          	sw	zero,128(s3)
    80002816:	6a02                	ld	s4,0(sp)
    80002818:	b75d                	j	800027be <itrunc+0x38>

000000008000281a <iput>:
{
    8000281a:	1101                	addi	sp,sp,-32
    8000281c:	ec06                	sd	ra,24(sp)
    8000281e:	e822                	sd	s0,16(sp)
    80002820:	e426                	sd	s1,8(sp)
    80002822:	1000                	addi	s0,sp,32
    80002824:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002826:	00016517          	auipc	a0,0x16
    8000282a:	f0250513          	addi	a0,a0,-254 # 80018728 <itable>
    8000282e:	06c030ef          	jal	8000589a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002832:	4498                	lw	a4,8(s1)
    80002834:	4785                	li	a5,1
    80002836:	02f70063          	beq	a4,a5,80002856 <iput+0x3c>
  ip->ref--;
    8000283a:	449c                	lw	a5,8(s1)
    8000283c:	37fd                	addiw	a5,a5,-1
    8000283e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002840:	00016517          	auipc	a0,0x16
    80002844:	ee850513          	addi	a0,a0,-280 # 80018728 <itable>
    80002848:	0ea030ef          	jal	80005932 <release>
}
    8000284c:	60e2                	ld	ra,24(sp)
    8000284e:	6442                	ld	s0,16(sp)
    80002850:	64a2                	ld	s1,8(sp)
    80002852:	6105                	addi	sp,sp,32
    80002854:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002856:	40bc                	lw	a5,64(s1)
    80002858:	d3ed                	beqz	a5,8000283a <iput+0x20>
    8000285a:	04a49783          	lh	a5,74(s1)
    8000285e:	fff1                	bnez	a5,8000283a <iput+0x20>
    80002860:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002862:	01048913          	addi	s2,s1,16
    80002866:	854a                	mv	a0,s2
    80002868:	297000ef          	jal	800032fe <acquiresleep>
    release(&itable.lock);
    8000286c:	00016517          	auipc	a0,0x16
    80002870:	ebc50513          	addi	a0,a0,-324 # 80018728 <itable>
    80002874:	0be030ef          	jal	80005932 <release>
    itrunc(ip);
    80002878:	8526                	mv	a0,s1
    8000287a:	f0dff0ef          	jal	80002786 <itrunc>
    ip->type = 0;
    8000287e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002882:	8526                	mv	a0,s1
    80002884:	d61ff0ef          	jal	800025e4 <iupdate>
    ip->valid = 0;
    80002888:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000288c:	854a                	mv	a0,s2
    8000288e:	2b7000ef          	jal	80003344 <releasesleep>
    acquire(&itable.lock);
    80002892:	00016517          	auipc	a0,0x16
    80002896:	e9650513          	addi	a0,a0,-362 # 80018728 <itable>
    8000289a:	000030ef          	jal	8000589a <acquire>
    8000289e:	6902                	ld	s2,0(sp)
    800028a0:	bf69                	j	8000283a <iput+0x20>

00000000800028a2 <iunlockput>:
{
    800028a2:	1101                	addi	sp,sp,-32
    800028a4:	ec06                	sd	ra,24(sp)
    800028a6:	e822                	sd	s0,16(sp)
    800028a8:	e426                	sd	s1,8(sp)
    800028aa:	1000                	addi	s0,sp,32
    800028ac:	84aa                	mv	s1,a0
  iunlock(ip);
    800028ae:	e99ff0ef          	jal	80002746 <iunlock>
  iput(ip);
    800028b2:	8526                	mv	a0,s1
    800028b4:	f67ff0ef          	jal	8000281a <iput>
}
    800028b8:	60e2                	ld	ra,24(sp)
    800028ba:	6442                	ld	s0,16(sp)
    800028bc:	64a2                	ld	s1,8(sp)
    800028be:	6105                	addi	sp,sp,32
    800028c0:	8082                	ret

00000000800028c2 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800028c2:	00016717          	auipc	a4,0x16
    800028c6:	e5272703          	lw	a4,-430(a4) # 80018714 <sb+0xc>
    800028ca:	4785                	li	a5,1
    800028cc:	0ae7ff63          	bgeu	a5,a4,8000298a <ireclaim+0xc8>
{
    800028d0:	7139                	addi	sp,sp,-64
    800028d2:	fc06                	sd	ra,56(sp)
    800028d4:	f822                	sd	s0,48(sp)
    800028d6:	f426                	sd	s1,40(sp)
    800028d8:	f04a                	sd	s2,32(sp)
    800028da:	ec4e                	sd	s3,24(sp)
    800028dc:	e852                	sd	s4,16(sp)
    800028de:	e456                	sd	s5,8(sp)
    800028e0:	e05a                	sd	s6,0(sp)
    800028e2:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800028e4:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800028e6:	00050a1b          	sext.w	s4,a0
    800028ea:	00016a97          	auipc	s5,0x16
    800028ee:	e1ea8a93          	addi	s5,s5,-482 # 80018708 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800028f2:	00005b17          	auipc	s6,0x5
    800028f6:	b2eb0b13          	addi	s6,s6,-1234 # 80007420 <etext+0x420>
    800028fa:	a099                	j	80002940 <ireclaim+0x7e>
    800028fc:	85ce                	mv	a1,s3
    800028fe:	855a                	mv	a0,s6
    80002900:	1f9020ef          	jal	800052f8 <printf>
      ip = iget(dev, inum);
    80002904:	85ce                	mv	a1,s3
    80002906:	8552                	mv	a0,s4
    80002908:	b1dff0ef          	jal	80002424 <iget>
    8000290c:	89aa                	mv	s3,a0
    brelse(bp);
    8000290e:	854a                	mv	a0,s2
    80002910:	fc4ff0ef          	jal	800020d4 <brelse>
    if (ip) {
    80002914:	00098f63          	beqz	s3,80002932 <ireclaim+0x70>
      begin_op();
    80002918:	76a000ef          	jal	80003082 <begin_op>
      ilock(ip);
    8000291c:	854e                	mv	a0,s3
    8000291e:	d7bff0ef          	jal	80002698 <ilock>
      iunlock(ip);
    80002922:	854e                	mv	a0,s3
    80002924:	e23ff0ef          	jal	80002746 <iunlock>
      iput(ip);
    80002928:	854e                	mv	a0,s3
    8000292a:	ef1ff0ef          	jal	8000281a <iput>
      end_op();
    8000292e:	7be000ef          	jal	800030ec <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002932:	0485                	addi	s1,s1,1
    80002934:	00caa703          	lw	a4,12(s5)
    80002938:	0004879b          	sext.w	a5,s1
    8000293c:	02e7fd63          	bgeu	a5,a4,80002976 <ireclaim+0xb4>
    80002940:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002944:	0044d593          	srli	a1,s1,0x4
    80002948:	018aa783          	lw	a5,24(s5)
    8000294c:	9dbd                	addw	a1,a1,a5
    8000294e:	8552                	mv	a0,s4
    80002950:	e7cff0ef          	jal	80001fcc <bread>
    80002954:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002956:	05850793          	addi	a5,a0,88
    8000295a:	00f9f713          	andi	a4,s3,15
    8000295e:	071a                	slli	a4,a4,0x6
    80002960:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002962:	00079703          	lh	a4,0(a5)
    80002966:	c701                	beqz	a4,8000296e <ireclaim+0xac>
    80002968:	00679783          	lh	a5,6(a5)
    8000296c:	dbc1                	beqz	a5,800028fc <ireclaim+0x3a>
    brelse(bp);
    8000296e:	854a                	mv	a0,s2
    80002970:	f64ff0ef          	jal	800020d4 <brelse>
    if (ip) {
    80002974:	bf7d                	j	80002932 <ireclaim+0x70>
}
    80002976:	70e2                	ld	ra,56(sp)
    80002978:	7442                	ld	s0,48(sp)
    8000297a:	74a2                	ld	s1,40(sp)
    8000297c:	7902                	ld	s2,32(sp)
    8000297e:	69e2                	ld	s3,24(sp)
    80002980:	6a42                	ld	s4,16(sp)
    80002982:	6aa2                	ld	s5,8(sp)
    80002984:	6b02                	ld	s6,0(sp)
    80002986:	6121                	addi	sp,sp,64
    80002988:	8082                	ret
    8000298a:	8082                	ret

000000008000298c <fsinit>:
fsinit(int dev) {
    8000298c:	7179                	addi	sp,sp,-48
    8000298e:	f406                	sd	ra,40(sp)
    80002990:	f022                	sd	s0,32(sp)
    80002992:	ec26                	sd	s1,24(sp)
    80002994:	e84a                	sd	s2,16(sp)
    80002996:	e44e                	sd	s3,8(sp)
    80002998:	1800                	addi	s0,sp,48
    8000299a:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    8000299c:	4585                	li	a1,1
    8000299e:	e2eff0ef          	jal	80001fcc <bread>
    800029a2:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029a4:	00016997          	auipc	s3,0x16
    800029a8:	d6498993          	addi	s3,s3,-668 # 80018708 <sb>
    800029ac:	02000613          	li	a2,32
    800029b0:	05850593          	addi	a1,a0,88
    800029b4:	854e                	mv	a0,s3
    800029b6:	ff4fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    800029ba:	854a                	mv	a0,s2
    800029bc:	f18ff0ef          	jal	800020d4 <brelse>
  if(sb.magic != FSMAGIC)
    800029c0:	0009a703          	lw	a4,0(s3)
    800029c4:	102037b7          	lui	a5,0x10203
    800029c8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029cc:	02f71363          	bne	a4,a5,800029f2 <fsinit+0x66>
  initlog(dev, &sb);
    800029d0:	00016597          	auipc	a1,0x16
    800029d4:	d3858593          	addi	a1,a1,-712 # 80018708 <sb>
    800029d8:	8526                	mv	a0,s1
    800029da:	62a000ef          	jal	80003004 <initlog>
  ireclaim(dev);
    800029de:	8526                	mv	a0,s1
    800029e0:	ee3ff0ef          	jal	800028c2 <ireclaim>
}
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6145                	addi	sp,sp,48
    800029f0:	8082                	ret
    panic("invalid file system");
    800029f2:	00005517          	auipc	a0,0x5
    800029f6:	a4e50513          	addi	a0,a0,-1458 # 80007440 <etext+0x440>
    800029fa:	3e5020ef          	jal	800055de <panic>

00000000800029fe <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800029fe:	1141                	addi	sp,sp,-16
    80002a00:	e422                	sd	s0,8(sp)
    80002a02:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a04:	411c                	lw	a5,0(a0)
    80002a06:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a08:	415c                	lw	a5,4(a0)
    80002a0a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a0c:	04451783          	lh	a5,68(a0)
    80002a10:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a14:	04a51783          	lh	a5,74(a0)
    80002a18:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a1c:	04c56783          	lwu	a5,76(a0)
    80002a20:	e99c                	sd	a5,16(a1)
}
    80002a22:	6422                	ld	s0,8(sp)
    80002a24:	0141                	addi	sp,sp,16
    80002a26:	8082                	ret

0000000080002a28 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a28:	457c                	lw	a5,76(a0)
    80002a2a:	0ed7eb63          	bltu	a5,a3,80002b20 <readi+0xf8>
{
    80002a2e:	7159                	addi	sp,sp,-112
    80002a30:	f486                	sd	ra,104(sp)
    80002a32:	f0a2                	sd	s0,96(sp)
    80002a34:	eca6                	sd	s1,88(sp)
    80002a36:	e0d2                	sd	s4,64(sp)
    80002a38:	fc56                	sd	s5,56(sp)
    80002a3a:	f85a                	sd	s6,48(sp)
    80002a3c:	f45e                	sd	s7,40(sp)
    80002a3e:	1880                	addi	s0,sp,112
    80002a40:	8b2a                	mv	s6,a0
    80002a42:	8bae                	mv	s7,a1
    80002a44:	8a32                	mv	s4,a2
    80002a46:	84b6                	mv	s1,a3
    80002a48:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a4a:	9f35                	addw	a4,a4,a3
    return 0;
    80002a4c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a4e:	0cd76063          	bltu	a4,a3,80002b0e <readi+0xe6>
    80002a52:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a54:	00e7f463          	bgeu	a5,a4,80002a5c <readi+0x34>
    n = ip->size - off;
    80002a58:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a5c:	080a8f63          	beqz	s5,80002afa <readi+0xd2>
    80002a60:	e8ca                	sd	s2,80(sp)
    80002a62:	f062                	sd	s8,32(sp)
    80002a64:	ec66                	sd	s9,24(sp)
    80002a66:	e86a                	sd	s10,16(sp)
    80002a68:	e46e                	sd	s11,8(sp)
    80002a6a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a6c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a70:	5c7d                	li	s8,-1
    80002a72:	a80d                	j	80002aa4 <readi+0x7c>
    80002a74:	020d1d93          	slli	s11,s10,0x20
    80002a78:	020ddd93          	srli	s11,s11,0x20
    80002a7c:	05890613          	addi	a2,s2,88
    80002a80:	86ee                	mv	a3,s11
    80002a82:	963a                	add	a2,a2,a4
    80002a84:	85d2                	mv	a1,s4
    80002a86:	855e                	mv	a0,s7
    80002a88:	c73fe0ef          	jal	800016fa <either_copyout>
    80002a8c:	05850763          	beq	a0,s8,80002ada <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a90:	854a                	mv	a0,s2
    80002a92:	e42ff0ef          	jal	800020d4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a96:	013d09bb          	addw	s3,s10,s3
    80002a9a:	009d04bb          	addw	s1,s10,s1
    80002a9e:	9a6e                	add	s4,s4,s11
    80002aa0:	0559f763          	bgeu	s3,s5,80002aee <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002aa4:	00a4d59b          	srliw	a1,s1,0xa
    80002aa8:	855a                	mv	a0,s6
    80002aaa:	8a7ff0ef          	jal	80002350 <bmap>
    80002aae:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ab2:	c5b1                	beqz	a1,80002afe <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002ab4:	000b2503          	lw	a0,0(s6)
    80002ab8:	d14ff0ef          	jal	80001fcc <bread>
    80002abc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002abe:	3ff4f713          	andi	a4,s1,1023
    80002ac2:	40ec87bb          	subw	a5,s9,a4
    80002ac6:	413a86bb          	subw	a3,s5,s3
    80002aca:	8d3e                	mv	s10,a5
    80002acc:	2781                	sext.w	a5,a5
    80002ace:	0006861b          	sext.w	a2,a3
    80002ad2:	faf671e3          	bgeu	a2,a5,80002a74 <readi+0x4c>
    80002ad6:	8d36                	mv	s10,a3
    80002ad8:	bf71                	j	80002a74 <readi+0x4c>
      brelse(bp);
    80002ada:	854a                	mv	a0,s2
    80002adc:	df8ff0ef          	jal	800020d4 <brelse>
      tot = -1;
    80002ae0:	59fd                	li	s3,-1
      break;
    80002ae2:	6946                	ld	s2,80(sp)
    80002ae4:	7c02                	ld	s8,32(sp)
    80002ae6:	6ce2                	ld	s9,24(sp)
    80002ae8:	6d42                	ld	s10,16(sp)
    80002aea:	6da2                	ld	s11,8(sp)
    80002aec:	a831                	j	80002b08 <readi+0xe0>
    80002aee:	6946                	ld	s2,80(sp)
    80002af0:	7c02                	ld	s8,32(sp)
    80002af2:	6ce2                	ld	s9,24(sp)
    80002af4:	6d42                	ld	s10,16(sp)
    80002af6:	6da2                	ld	s11,8(sp)
    80002af8:	a801                	j	80002b08 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002afa:	89d6                	mv	s3,s5
    80002afc:	a031                	j	80002b08 <readi+0xe0>
    80002afe:	6946                	ld	s2,80(sp)
    80002b00:	7c02                	ld	s8,32(sp)
    80002b02:	6ce2                	ld	s9,24(sp)
    80002b04:	6d42                	ld	s10,16(sp)
    80002b06:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b08:	0009851b          	sext.w	a0,s3
    80002b0c:	69a6                	ld	s3,72(sp)
}
    80002b0e:	70a6                	ld	ra,104(sp)
    80002b10:	7406                	ld	s0,96(sp)
    80002b12:	64e6                	ld	s1,88(sp)
    80002b14:	6a06                	ld	s4,64(sp)
    80002b16:	7ae2                	ld	s5,56(sp)
    80002b18:	7b42                	ld	s6,48(sp)
    80002b1a:	7ba2                	ld	s7,40(sp)
    80002b1c:	6165                	addi	sp,sp,112
    80002b1e:	8082                	ret
    return 0;
    80002b20:	4501                	li	a0,0
}
    80002b22:	8082                	ret

0000000080002b24 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b24:	457c                	lw	a5,76(a0)
    80002b26:	10d7e063          	bltu	a5,a3,80002c26 <writei+0x102>
{
    80002b2a:	7159                	addi	sp,sp,-112
    80002b2c:	f486                	sd	ra,104(sp)
    80002b2e:	f0a2                	sd	s0,96(sp)
    80002b30:	e8ca                	sd	s2,80(sp)
    80002b32:	e0d2                	sd	s4,64(sp)
    80002b34:	fc56                	sd	s5,56(sp)
    80002b36:	f85a                	sd	s6,48(sp)
    80002b38:	f45e                	sd	s7,40(sp)
    80002b3a:	1880                	addi	s0,sp,112
    80002b3c:	8aaa                	mv	s5,a0
    80002b3e:	8bae                	mv	s7,a1
    80002b40:	8a32                	mv	s4,a2
    80002b42:	8936                	mv	s2,a3
    80002b44:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b46:	00e687bb          	addw	a5,a3,a4
    80002b4a:	0ed7e063          	bltu	a5,a3,80002c2a <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b4e:	00043737          	lui	a4,0x43
    80002b52:	0cf76e63          	bltu	a4,a5,80002c2e <writei+0x10a>
    80002b56:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b58:	0a0b0f63          	beqz	s6,80002c16 <writei+0xf2>
    80002b5c:	eca6                	sd	s1,88(sp)
    80002b5e:	f062                	sd	s8,32(sp)
    80002b60:	ec66                	sd	s9,24(sp)
    80002b62:	e86a                	sd	s10,16(sp)
    80002b64:	e46e                	sd	s11,8(sp)
    80002b66:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b68:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b6c:	5c7d                	li	s8,-1
    80002b6e:	a825                	j	80002ba6 <writei+0x82>
    80002b70:	020d1d93          	slli	s11,s10,0x20
    80002b74:	020ddd93          	srli	s11,s11,0x20
    80002b78:	05848513          	addi	a0,s1,88
    80002b7c:	86ee                	mv	a3,s11
    80002b7e:	8652                	mv	a2,s4
    80002b80:	85de                	mv	a1,s7
    80002b82:	953a                	add	a0,a0,a4
    80002b84:	bc1fe0ef          	jal	80001744 <either_copyin>
    80002b88:	05850a63          	beq	a0,s8,80002bdc <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b8c:	8526                	mv	a0,s1
    80002b8e:	678000ef          	jal	80003206 <log_write>
    brelse(bp);
    80002b92:	8526                	mv	a0,s1
    80002b94:	d40ff0ef          	jal	800020d4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b98:	013d09bb          	addw	s3,s10,s3
    80002b9c:	012d093b          	addw	s2,s10,s2
    80002ba0:	9a6e                	add	s4,s4,s11
    80002ba2:	0569f063          	bgeu	s3,s6,80002be2 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002ba6:	00a9559b          	srliw	a1,s2,0xa
    80002baa:	8556                	mv	a0,s5
    80002bac:	fa4ff0ef          	jal	80002350 <bmap>
    80002bb0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002bb4:	c59d                	beqz	a1,80002be2 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002bb6:	000aa503          	lw	a0,0(s5)
    80002bba:	c12ff0ef          	jal	80001fcc <bread>
    80002bbe:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bc0:	3ff97713          	andi	a4,s2,1023
    80002bc4:	40ec87bb          	subw	a5,s9,a4
    80002bc8:	413b06bb          	subw	a3,s6,s3
    80002bcc:	8d3e                	mv	s10,a5
    80002bce:	2781                	sext.w	a5,a5
    80002bd0:	0006861b          	sext.w	a2,a3
    80002bd4:	f8f67ee3          	bgeu	a2,a5,80002b70 <writei+0x4c>
    80002bd8:	8d36                	mv	s10,a3
    80002bda:	bf59                	j	80002b70 <writei+0x4c>
      brelse(bp);
    80002bdc:	8526                	mv	a0,s1
    80002bde:	cf6ff0ef          	jal	800020d4 <brelse>
  }

  if(off > ip->size)
    80002be2:	04caa783          	lw	a5,76(s5)
    80002be6:	0327fa63          	bgeu	a5,s2,80002c1a <writei+0xf6>
    ip->size = off;
    80002bea:	052aa623          	sw	s2,76(s5)
    80002bee:	64e6                	ld	s1,88(sp)
    80002bf0:	7c02                	ld	s8,32(sp)
    80002bf2:	6ce2                	ld	s9,24(sp)
    80002bf4:	6d42                	ld	s10,16(sp)
    80002bf6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002bf8:	8556                	mv	a0,s5
    80002bfa:	9ebff0ef          	jal	800025e4 <iupdate>

  return tot;
    80002bfe:	0009851b          	sext.w	a0,s3
    80002c02:	69a6                	ld	s3,72(sp)
}
    80002c04:	70a6                	ld	ra,104(sp)
    80002c06:	7406                	ld	s0,96(sp)
    80002c08:	6946                	ld	s2,80(sp)
    80002c0a:	6a06                	ld	s4,64(sp)
    80002c0c:	7ae2                	ld	s5,56(sp)
    80002c0e:	7b42                	ld	s6,48(sp)
    80002c10:	7ba2                	ld	s7,40(sp)
    80002c12:	6165                	addi	sp,sp,112
    80002c14:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c16:	89da                	mv	s3,s6
    80002c18:	b7c5                	j	80002bf8 <writei+0xd4>
    80002c1a:	64e6                	ld	s1,88(sp)
    80002c1c:	7c02                	ld	s8,32(sp)
    80002c1e:	6ce2                	ld	s9,24(sp)
    80002c20:	6d42                	ld	s10,16(sp)
    80002c22:	6da2                	ld	s11,8(sp)
    80002c24:	bfd1                	j	80002bf8 <writei+0xd4>
    return -1;
    80002c26:	557d                	li	a0,-1
}
    80002c28:	8082                	ret
    return -1;
    80002c2a:	557d                	li	a0,-1
    80002c2c:	bfe1                	j	80002c04 <writei+0xe0>
    return -1;
    80002c2e:	557d                	li	a0,-1
    80002c30:	bfd1                	j	80002c04 <writei+0xe0>

0000000080002c32 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c32:	1141                	addi	sp,sp,-16
    80002c34:	e406                	sd	ra,8(sp)
    80002c36:	e022                	sd	s0,0(sp)
    80002c38:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c3a:	4639                	li	a2,14
    80002c3c:	ddefd0ef          	jal	8000021a <strncmp>
}
    80002c40:	60a2                	ld	ra,8(sp)
    80002c42:	6402                	ld	s0,0(sp)
    80002c44:	0141                	addi	sp,sp,16
    80002c46:	8082                	ret

0000000080002c48 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c48:	7139                	addi	sp,sp,-64
    80002c4a:	fc06                	sd	ra,56(sp)
    80002c4c:	f822                	sd	s0,48(sp)
    80002c4e:	f426                	sd	s1,40(sp)
    80002c50:	f04a                	sd	s2,32(sp)
    80002c52:	ec4e                	sd	s3,24(sp)
    80002c54:	e852                	sd	s4,16(sp)
    80002c56:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c58:	04451703          	lh	a4,68(a0)
    80002c5c:	4785                	li	a5,1
    80002c5e:	00f71a63          	bne	a4,a5,80002c72 <dirlookup+0x2a>
    80002c62:	892a                	mv	s2,a0
    80002c64:	89ae                	mv	s3,a1
    80002c66:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c68:	457c                	lw	a5,76(a0)
    80002c6a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c6c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c6e:	e39d                	bnez	a5,80002c94 <dirlookup+0x4c>
    80002c70:	a095                	j	80002cd4 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c72:	00004517          	auipc	a0,0x4
    80002c76:	7e650513          	addi	a0,a0,2022 # 80007458 <etext+0x458>
    80002c7a:	165020ef          	jal	800055de <panic>
      panic("dirlookup read");
    80002c7e:	00004517          	auipc	a0,0x4
    80002c82:	7f250513          	addi	a0,a0,2034 # 80007470 <etext+0x470>
    80002c86:	159020ef          	jal	800055de <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c8a:	24c1                	addiw	s1,s1,16
    80002c8c:	04c92783          	lw	a5,76(s2)
    80002c90:	04f4f163          	bgeu	s1,a5,80002cd2 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c94:	4741                	li	a4,16
    80002c96:	86a6                	mv	a3,s1
    80002c98:	fc040613          	addi	a2,s0,-64
    80002c9c:	4581                	li	a1,0
    80002c9e:	854a                	mv	a0,s2
    80002ca0:	d89ff0ef          	jal	80002a28 <readi>
    80002ca4:	47c1                	li	a5,16
    80002ca6:	fcf51ce3          	bne	a0,a5,80002c7e <dirlookup+0x36>
    if(de.inum == 0)
    80002caa:	fc045783          	lhu	a5,-64(s0)
    80002cae:	dff1                	beqz	a5,80002c8a <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002cb0:	fc240593          	addi	a1,s0,-62
    80002cb4:	854e                	mv	a0,s3
    80002cb6:	f7dff0ef          	jal	80002c32 <namecmp>
    80002cba:	f961                	bnez	a0,80002c8a <dirlookup+0x42>
      if(poff)
    80002cbc:	000a0463          	beqz	s4,80002cc4 <dirlookup+0x7c>
        *poff = off;
    80002cc0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002cc4:	fc045583          	lhu	a1,-64(s0)
    80002cc8:	00092503          	lw	a0,0(s2)
    80002ccc:	f58ff0ef          	jal	80002424 <iget>
    80002cd0:	a011                	j	80002cd4 <dirlookup+0x8c>
  return 0;
    80002cd2:	4501                	li	a0,0
}
    80002cd4:	70e2                	ld	ra,56(sp)
    80002cd6:	7442                	ld	s0,48(sp)
    80002cd8:	74a2                	ld	s1,40(sp)
    80002cda:	7902                	ld	s2,32(sp)
    80002cdc:	69e2                	ld	s3,24(sp)
    80002cde:	6a42                	ld	s4,16(sp)
    80002ce0:	6121                	addi	sp,sp,64
    80002ce2:	8082                	ret

0000000080002ce4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002ce4:	711d                	addi	sp,sp,-96
    80002ce6:	ec86                	sd	ra,88(sp)
    80002ce8:	e8a2                	sd	s0,80(sp)
    80002cea:	e4a6                	sd	s1,72(sp)
    80002cec:	e0ca                	sd	s2,64(sp)
    80002cee:	fc4e                	sd	s3,56(sp)
    80002cf0:	f852                	sd	s4,48(sp)
    80002cf2:	f456                	sd	s5,40(sp)
    80002cf4:	f05a                	sd	s6,32(sp)
    80002cf6:	ec5e                	sd	s7,24(sp)
    80002cf8:	e862                	sd	s8,16(sp)
    80002cfa:	e466                	sd	s9,8(sp)
    80002cfc:	1080                	addi	s0,sp,96
    80002cfe:	84aa                	mv	s1,a0
    80002d00:	8b2e                	mv	s6,a1
    80002d02:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d04:	00054703          	lbu	a4,0(a0)
    80002d08:	02f00793          	li	a5,47
    80002d0c:	00f70e63          	beq	a4,a5,80002d28 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d10:	896fe0ef          	jal	80000da6 <myproc>
    80002d14:	15053503          	ld	a0,336(a0)
    80002d18:	94bff0ef          	jal	80002662 <idup>
    80002d1c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d1e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d22:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d24:	4b85                	li	s7,1
    80002d26:	a871                	j	80002dc2 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002d28:	4585                	li	a1,1
    80002d2a:	4505                	li	a0,1
    80002d2c:	ef8ff0ef          	jal	80002424 <iget>
    80002d30:	8a2a                	mv	s4,a0
    80002d32:	b7f5                	j	80002d1e <namex+0x3a>
      iunlockput(ip);
    80002d34:	8552                	mv	a0,s4
    80002d36:	b6dff0ef          	jal	800028a2 <iunlockput>
      return 0;
    80002d3a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d3c:	8552                	mv	a0,s4
    80002d3e:	60e6                	ld	ra,88(sp)
    80002d40:	6446                	ld	s0,80(sp)
    80002d42:	64a6                	ld	s1,72(sp)
    80002d44:	6906                	ld	s2,64(sp)
    80002d46:	79e2                	ld	s3,56(sp)
    80002d48:	7a42                	ld	s4,48(sp)
    80002d4a:	7aa2                	ld	s5,40(sp)
    80002d4c:	7b02                	ld	s6,32(sp)
    80002d4e:	6be2                	ld	s7,24(sp)
    80002d50:	6c42                	ld	s8,16(sp)
    80002d52:	6ca2                	ld	s9,8(sp)
    80002d54:	6125                	addi	sp,sp,96
    80002d56:	8082                	ret
      iunlock(ip);
    80002d58:	8552                	mv	a0,s4
    80002d5a:	9edff0ef          	jal	80002746 <iunlock>
      return ip;
    80002d5e:	bff9                	j	80002d3c <namex+0x58>
      iunlockput(ip);
    80002d60:	8552                	mv	a0,s4
    80002d62:	b41ff0ef          	jal	800028a2 <iunlockput>
      return 0;
    80002d66:	8a4e                	mv	s4,s3
    80002d68:	bfd1                	j	80002d3c <namex+0x58>
  len = path - s;
    80002d6a:	40998633          	sub	a2,s3,s1
    80002d6e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d72:	099c5063          	bge	s8,s9,80002df2 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d76:	4639                	li	a2,14
    80002d78:	85a6                	mv	a1,s1
    80002d7a:	8556                	mv	a0,s5
    80002d7c:	c2efd0ef          	jal	800001aa <memmove>
    80002d80:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d82:	0004c783          	lbu	a5,0(s1)
    80002d86:	01279763          	bne	a5,s2,80002d94 <namex+0xb0>
    path++;
    80002d8a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d8c:	0004c783          	lbu	a5,0(s1)
    80002d90:	ff278de3          	beq	a5,s2,80002d8a <namex+0xa6>
    ilock(ip);
    80002d94:	8552                	mv	a0,s4
    80002d96:	903ff0ef          	jal	80002698 <ilock>
    if(ip->type != T_DIR){
    80002d9a:	044a1783          	lh	a5,68(s4)
    80002d9e:	f9779be3          	bne	a5,s7,80002d34 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002da2:	000b0563          	beqz	s6,80002dac <namex+0xc8>
    80002da6:	0004c783          	lbu	a5,0(s1)
    80002daa:	d7dd                	beqz	a5,80002d58 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002dac:	4601                	li	a2,0
    80002dae:	85d6                	mv	a1,s5
    80002db0:	8552                	mv	a0,s4
    80002db2:	e97ff0ef          	jal	80002c48 <dirlookup>
    80002db6:	89aa                	mv	s3,a0
    80002db8:	d545                	beqz	a0,80002d60 <namex+0x7c>
    iunlockput(ip);
    80002dba:	8552                	mv	a0,s4
    80002dbc:	ae7ff0ef          	jal	800028a2 <iunlockput>
    ip = next;
    80002dc0:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002dc2:	0004c783          	lbu	a5,0(s1)
    80002dc6:	01279763          	bne	a5,s2,80002dd4 <namex+0xf0>
    path++;
    80002dca:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dcc:	0004c783          	lbu	a5,0(s1)
    80002dd0:	ff278de3          	beq	a5,s2,80002dca <namex+0xe6>
  if(*path == 0)
    80002dd4:	cb8d                	beqz	a5,80002e06 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002dd6:	0004c783          	lbu	a5,0(s1)
    80002dda:	89a6                	mv	s3,s1
  len = path - s;
    80002ddc:	4c81                	li	s9,0
    80002dde:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002de0:	01278963          	beq	a5,s2,80002df2 <namex+0x10e>
    80002de4:	d3d9                	beqz	a5,80002d6a <namex+0x86>
    path++;
    80002de6:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002de8:	0009c783          	lbu	a5,0(s3)
    80002dec:	ff279ce3          	bne	a5,s2,80002de4 <namex+0x100>
    80002df0:	bfad                	j	80002d6a <namex+0x86>
    memmove(name, s, len);
    80002df2:	2601                	sext.w	a2,a2
    80002df4:	85a6                	mv	a1,s1
    80002df6:	8556                	mv	a0,s5
    80002df8:	bb2fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002dfc:	9cd6                	add	s9,s9,s5
    80002dfe:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002e02:	84ce                	mv	s1,s3
    80002e04:	bfbd                	j	80002d82 <namex+0x9e>
  if(nameiparent){
    80002e06:	f20b0be3          	beqz	s6,80002d3c <namex+0x58>
    iput(ip);
    80002e0a:	8552                	mv	a0,s4
    80002e0c:	a0fff0ef          	jal	8000281a <iput>
    return 0;
    80002e10:	4a01                	li	s4,0
    80002e12:	b72d                	j	80002d3c <namex+0x58>

0000000080002e14 <dirlink>:
{
    80002e14:	7139                	addi	sp,sp,-64
    80002e16:	fc06                	sd	ra,56(sp)
    80002e18:	f822                	sd	s0,48(sp)
    80002e1a:	f04a                	sd	s2,32(sp)
    80002e1c:	ec4e                	sd	s3,24(sp)
    80002e1e:	e852                	sd	s4,16(sp)
    80002e20:	0080                	addi	s0,sp,64
    80002e22:	892a                	mv	s2,a0
    80002e24:	8a2e                	mv	s4,a1
    80002e26:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e28:	4601                	li	a2,0
    80002e2a:	e1fff0ef          	jal	80002c48 <dirlookup>
    80002e2e:	e535                	bnez	a0,80002e9a <dirlink+0x86>
    80002e30:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e32:	04c92483          	lw	s1,76(s2)
    80002e36:	c48d                	beqz	s1,80002e60 <dirlink+0x4c>
    80002e38:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e3a:	4741                	li	a4,16
    80002e3c:	86a6                	mv	a3,s1
    80002e3e:	fc040613          	addi	a2,s0,-64
    80002e42:	4581                	li	a1,0
    80002e44:	854a                	mv	a0,s2
    80002e46:	be3ff0ef          	jal	80002a28 <readi>
    80002e4a:	47c1                	li	a5,16
    80002e4c:	04f51b63          	bne	a0,a5,80002ea2 <dirlink+0x8e>
    if(de.inum == 0)
    80002e50:	fc045783          	lhu	a5,-64(s0)
    80002e54:	c791                	beqz	a5,80002e60 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e56:	24c1                	addiw	s1,s1,16
    80002e58:	04c92783          	lw	a5,76(s2)
    80002e5c:	fcf4efe3          	bltu	s1,a5,80002e3a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e60:	4639                	li	a2,14
    80002e62:	85d2                	mv	a1,s4
    80002e64:	fc240513          	addi	a0,s0,-62
    80002e68:	be8fd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002e6c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e70:	4741                	li	a4,16
    80002e72:	86a6                	mv	a3,s1
    80002e74:	fc040613          	addi	a2,s0,-64
    80002e78:	4581                	li	a1,0
    80002e7a:	854a                	mv	a0,s2
    80002e7c:	ca9ff0ef          	jal	80002b24 <writei>
    80002e80:	1541                	addi	a0,a0,-16
    80002e82:	00a03533          	snez	a0,a0
    80002e86:	40a00533          	neg	a0,a0
    80002e8a:	74a2                	ld	s1,40(sp)
}
    80002e8c:	70e2                	ld	ra,56(sp)
    80002e8e:	7442                	ld	s0,48(sp)
    80002e90:	7902                	ld	s2,32(sp)
    80002e92:	69e2                	ld	s3,24(sp)
    80002e94:	6a42                	ld	s4,16(sp)
    80002e96:	6121                	addi	sp,sp,64
    80002e98:	8082                	ret
    iput(ip);
    80002e9a:	981ff0ef          	jal	8000281a <iput>
    return -1;
    80002e9e:	557d                	li	a0,-1
    80002ea0:	b7f5                	j	80002e8c <dirlink+0x78>
      panic("dirlink read");
    80002ea2:	00004517          	auipc	a0,0x4
    80002ea6:	5de50513          	addi	a0,a0,1502 # 80007480 <etext+0x480>
    80002eaa:	734020ef          	jal	800055de <panic>

0000000080002eae <namei>:

struct inode*
namei(char *path)
{
    80002eae:	1101                	addi	sp,sp,-32
    80002eb0:	ec06                	sd	ra,24(sp)
    80002eb2:	e822                	sd	s0,16(sp)
    80002eb4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002eb6:	fe040613          	addi	a2,s0,-32
    80002eba:	4581                	li	a1,0
    80002ebc:	e29ff0ef          	jal	80002ce4 <namex>
}
    80002ec0:	60e2                	ld	ra,24(sp)
    80002ec2:	6442                	ld	s0,16(sp)
    80002ec4:	6105                	addi	sp,sp,32
    80002ec6:	8082                	ret

0000000080002ec8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002ec8:	1141                	addi	sp,sp,-16
    80002eca:	e406                	sd	ra,8(sp)
    80002ecc:	e022                	sd	s0,0(sp)
    80002ece:	0800                	addi	s0,sp,16
    80002ed0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002ed2:	4585                	li	a1,1
    80002ed4:	e11ff0ef          	jal	80002ce4 <namex>
}
    80002ed8:	60a2                	ld	ra,8(sp)
    80002eda:	6402                	ld	s0,0(sp)
    80002edc:	0141                	addi	sp,sp,16
    80002ede:	8082                	ret

0000000080002ee0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002ee0:	1101                	addi	sp,sp,-32
    80002ee2:	ec06                	sd	ra,24(sp)
    80002ee4:	e822                	sd	s0,16(sp)
    80002ee6:	e426                	sd	s1,8(sp)
    80002ee8:	e04a                	sd	s2,0(sp)
    80002eea:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002eec:	00017917          	auipc	s2,0x17
    80002ef0:	2e490913          	addi	s2,s2,740 # 8001a1d0 <log>
    80002ef4:	01892583          	lw	a1,24(s2)
    80002ef8:	02492503          	lw	a0,36(s2)
    80002efc:	8d0ff0ef          	jal	80001fcc <bread>
    80002f00:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f02:	02892603          	lw	a2,40(s2)
    80002f06:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f08:	00c05f63          	blez	a2,80002f26 <write_head+0x46>
    80002f0c:	00017717          	auipc	a4,0x17
    80002f10:	2f070713          	addi	a4,a4,752 # 8001a1fc <log+0x2c>
    80002f14:	87aa                	mv	a5,a0
    80002f16:	060a                	slli	a2,a2,0x2
    80002f18:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f1a:	4314                	lw	a3,0(a4)
    80002f1c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f1e:	0711                	addi	a4,a4,4
    80002f20:	0791                	addi	a5,a5,4
    80002f22:	fec79ce3          	bne	a5,a2,80002f1a <write_head+0x3a>
  }
  bwrite(buf);
    80002f26:	8526                	mv	a0,s1
    80002f28:	97aff0ef          	jal	800020a2 <bwrite>
  brelse(buf);
    80002f2c:	8526                	mv	a0,s1
    80002f2e:	9a6ff0ef          	jal	800020d4 <brelse>
}
    80002f32:	60e2                	ld	ra,24(sp)
    80002f34:	6442                	ld	s0,16(sp)
    80002f36:	64a2                	ld	s1,8(sp)
    80002f38:	6902                	ld	s2,0(sp)
    80002f3a:	6105                	addi	sp,sp,32
    80002f3c:	8082                	ret

0000000080002f3e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f3e:	00017797          	auipc	a5,0x17
    80002f42:	2ba7a783          	lw	a5,698(a5) # 8001a1f8 <log+0x28>
    80002f46:	0af05e63          	blez	a5,80003002 <install_trans+0xc4>
{
    80002f4a:	715d                	addi	sp,sp,-80
    80002f4c:	e486                	sd	ra,72(sp)
    80002f4e:	e0a2                	sd	s0,64(sp)
    80002f50:	fc26                	sd	s1,56(sp)
    80002f52:	f84a                	sd	s2,48(sp)
    80002f54:	f44e                	sd	s3,40(sp)
    80002f56:	f052                	sd	s4,32(sp)
    80002f58:	ec56                	sd	s5,24(sp)
    80002f5a:	e85a                	sd	s6,16(sp)
    80002f5c:	e45e                	sd	s7,8(sp)
    80002f5e:	0880                	addi	s0,sp,80
    80002f60:	8b2a                	mv	s6,a0
    80002f62:	00017a97          	auipc	s5,0x17
    80002f66:	29aa8a93          	addi	s5,s5,666 # 8001a1fc <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f6a:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002f6c:	00004b97          	auipc	s7,0x4
    80002f70:	524b8b93          	addi	s7,s7,1316 # 80007490 <etext+0x490>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f74:	00017a17          	auipc	s4,0x17
    80002f78:	25ca0a13          	addi	s4,s4,604 # 8001a1d0 <log>
    80002f7c:	a025                	j	80002fa4 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002f7e:	000aa603          	lw	a2,0(s5)
    80002f82:	85ce                	mv	a1,s3
    80002f84:	855e                	mv	a0,s7
    80002f86:	372020ef          	jal	800052f8 <printf>
    80002f8a:	a839                	j	80002fa8 <install_trans+0x6a>
    brelse(lbuf);
    80002f8c:	854a                	mv	a0,s2
    80002f8e:	946ff0ef          	jal	800020d4 <brelse>
    brelse(dbuf);
    80002f92:	8526                	mv	a0,s1
    80002f94:	940ff0ef          	jal	800020d4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f98:	2985                	addiw	s3,s3,1
    80002f9a:	0a91                	addi	s5,s5,4
    80002f9c:	028a2783          	lw	a5,40(s4)
    80002fa0:	04f9d663          	bge	s3,a5,80002fec <install_trans+0xae>
    if(recovering) {
    80002fa4:	fc0b1de3          	bnez	s6,80002f7e <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fa8:	018a2583          	lw	a1,24(s4)
    80002fac:	013585bb          	addw	a1,a1,s3
    80002fb0:	2585                	addiw	a1,a1,1
    80002fb2:	024a2503          	lw	a0,36(s4)
    80002fb6:	816ff0ef          	jal	80001fcc <bread>
    80002fba:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002fbc:	000aa583          	lw	a1,0(s5)
    80002fc0:	024a2503          	lw	a0,36(s4)
    80002fc4:	808ff0ef          	jal	80001fcc <bread>
    80002fc8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fca:	40000613          	li	a2,1024
    80002fce:	05890593          	addi	a1,s2,88
    80002fd2:	05850513          	addi	a0,a0,88
    80002fd6:	9d4fd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002fda:	8526                	mv	a0,s1
    80002fdc:	8c6ff0ef          	jal	800020a2 <bwrite>
    if(recovering == 0)
    80002fe0:	fa0b16e3          	bnez	s6,80002f8c <install_trans+0x4e>
      bunpin(dbuf);
    80002fe4:	8526                	mv	a0,s1
    80002fe6:	9aaff0ef          	jal	80002190 <bunpin>
    80002fea:	b74d                	j	80002f8c <install_trans+0x4e>
}
    80002fec:	60a6                	ld	ra,72(sp)
    80002fee:	6406                	ld	s0,64(sp)
    80002ff0:	74e2                	ld	s1,56(sp)
    80002ff2:	7942                	ld	s2,48(sp)
    80002ff4:	79a2                	ld	s3,40(sp)
    80002ff6:	7a02                	ld	s4,32(sp)
    80002ff8:	6ae2                	ld	s5,24(sp)
    80002ffa:	6b42                	ld	s6,16(sp)
    80002ffc:	6ba2                	ld	s7,8(sp)
    80002ffe:	6161                	addi	sp,sp,80
    80003000:	8082                	ret
    80003002:	8082                	ret

0000000080003004 <initlog>:
{
    80003004:	7179                	addi	sp,sp,-48
    80003006:	f406                	sd	ra,40(sp)
    80003008:	f022                	sd	s0,32(sp)
    8000300a:	ec26                	sd	s1,24(sp)
    8000300c:	e84a                	sd	s2,16(sp)
    8000300e:	e44e                	sd	s3,8(sp)
    80003010:	1800                	addi	s0,sp,48
    80003012:	892a                	mv	s2,a0
    80003014:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003016:	00017497          	auipc	s1,0x17
    8000301a:	1ba48493          	addi	s1,s1,442 # 8001a1d0 <log>
    8000301e:	00004597          	auipc	a1,0x4
    80003022:	49258593          	addi	a1,a1,1170 # 800074b0 <etext+0x4b0>
    80003026:	8526                	mv	a0,s1
    80003028:	7f2020ef          	jal	8000581a <initlock>
  log.start = sb->logstart;
    8000302c:	0149a583          	lw	a1,20(s3)
    80003030:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003032:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003036:	854a                	mv	a0,s2
    80003038:	f95fe0ef          	jal	80001fcc <bread>
  log.lh.n = lh->n;
    8000303c:	4d30                	lw	a2,88(a0)
    8000303e:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003040:	00c05f63          	blez	a2,8000305e <initlog+0x5a>
    80003044:	87aa                	mv	a5,a0
    80003046:	00017717          	auipc	a4,0x17
    8000304a:	1b670713          	addi	a4,a4,438 # 8001a1fc <log+0x2c>
    8000304e:	060a                	slli	a2,a2,0x2
    80003050:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003052:	4ff4                	lw	a3,92(a5)
    80003054:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003056:	0791                	addi	a5,a5,4
    80003058:	0711                	addi	a4,a4,4
    8000305a:	fec79ce3          	bne	a5,a2,80003052 <initlog+0x4e>
  brelse(buf);
    8000305e:	876ff0ef          	jal	800020d4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003062:	4505                	li	a0,1
    80003064:	edbff0ef          	jal	80002f3e <install_trans>
  log.lh.n = 0;
    80003068:	00017797          	auipc	a5,0x17
    8000306c:	1807a823          	sw	zero,400(a5) # 8001a1f8 <log+0x28>
  write_head(); // clear the log
    80003070:	e71ff0ef          	jal	80002ee0 <write_head>
}
    80003074:	70a2                	ld	ra,40(sp)
    80003076:	7402                	ld	s0,32(sp)
    80003078:	64e2                	ld	s1,24(sp)
    8000307a:	6942                	ld	s2,16(sp)
    8000307c:	69a2                	ld	s3,8(sp)
    8000307e:	6145                	addi	sp,sp,48
    80003080:	8082                	ret

0000000080003082 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003082:	1101                	addi	sp,sp,-32
    80003084:	ec06                	sd	ra,24(sp)
    80003086:	e822                	sd	s0,16(sp)
    80003088:	e426                	sd	s1,8(sp)
    8000308a:	e04a                	sd	s2,0(sp)
    8000308c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000308e:	00017517          	auipc	a0,0x17
    80003092:	14250513          	addi	a0,a0,322 # 8001a1d0 <log>
    80003096:	005020ef          	jal	8000589a <acquire>
  while(1){
    if(log.committing){
    8000309a:	00017497          	auipc	s1,0x17
    8000309e:	13648493          	addi	s1,s1,310 # 8001a1d0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030a2:	4979                	li	s2,30
    800030a4:	a029                	j	800030ae <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030a6:	85a6                	mv	a1,s1
    800030a8:	8526                	mv	a0,s1
    800030aa:	af4fe0ef          	jal	8000139e <sleep>
    if(log.committing){
    800030ae:	509c                	lw	a5,32(s1)
    800030b0:	fbfd                	bnez	a5,800030a6 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030b2:	4cd8                	lw	a4,28(s1)
    800030b4:	2705                	addiw	a4,a4,1
    800030b6:	0027179b          	slliw	a5,a4,0x2
    800030ba:	9fb9                	addw	a5,a5,a4
    800030bc:	0017979b          	slliw	a5,a5,0x1
    800030c0:	5494                	lw	a3,40(s1)
    800030c2:	9fb5                	addw	a5,a5,a3
    800030c4:	00f95763          	bge	s2,a5,800030d2 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800030c8:	85a6                	mv	a1,s1
    800030ca:	8526                	mv	a0,s1
    800030cc:	ad2fe0ef          	jal	8000139e <sleep>
    800030d0:	bff9                	j	800030ae <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800030d2:	00017517          	auipc	a0,0x17
    800030d6:	0fe50513          	addi	a0,a0,254 # 8001a1d0 <log>
    800030da:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    800030dc:	057020ef          	jal	80005932 <release>
      break;
    }
  }
}
    800030e0:	60e2                	ld	ra,24(sp)
    800030e2:	6442                	ld	s0,16(sp)
    800030e4:	64a2                	ld	s1,8(sp)
    800030e6:	6902                	ld	s2,0(sp)
    800030e8:	6105                	addi	sp,sp,32
    800030ea:	8082                	ret

00000000800030ec <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800030ec:	7139                	addi	sp,sp,-64
    800030ee:	fc06                	sd	ra,56(sp)
    800030f0:	f822                	sd	s0,48(sp)
    800030f2:	f426                	sd	s1,40(sp)
    800030f4:	f04a                	sd	s2,32(sp)
    800030f6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800030f8:	00017497          	auipc	s1,0x17
    800030fc:	0d848493          	addi	s1,s1,216 # 8001a1d0 <log>
    80003100:	8526                	mv	a0,s1
    80003102:	798020ef          	jal	8000589a <acquire>
  log.outstanding -= 1;
    80003106:	4cdc                	lw	a5,28(s1)
    80003108:	37fd                	addiw	a5,a5,-1
    8000310a:	0007891b          	sext.w	s2,a5
    8000310e:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003110:	509c                	lw	a5,32(s1)
    80003112:	ef9d                	bnez	a5,80003150 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003114:	04091763          	bnez	s2,80003162 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003118:	00017497          	auipc	s1,0x17
    8000311c:	0b848493          	addi	s1,s1,184 # 8001a1d0 <log>
    80003120:	4785                	li	a5,1
    80003122:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003124:	8526                	mv	a0,s1
    80003126:	00d020ef          	jal	80005932 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000312a:	549c                	lw	a5,40(s1)
    8000312c:	04f04b63          	bgtz	a5,80003182 <end_op+0x96>
    acquire(&log.lock);
    80003130:	00017497          	auipc	s1,0x17
    80003134:	0a048493          	addi	s1,s1,160 # 8001a1d0 <log>
    80003138:	8526                	mv	a0,s1
    8000313a:	760020ef          	jal	8000589a <acquire>
    log.committing = 0;
    8000313e:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003142:	8526                	mv	a0,s1
    80003144:	aa6fe0ef          	jal	800013ea <wakeup>
    release(&log.lock);
    80003148:	8526                	mv	a0,s1
    8000314a:	7e8020ef          	jal	80005932 <release>
}
    8000314e:	a025                	j	80003176 <end_op+0x8a>
    80003150:	ec4e                	sd	s3,24(sp)
    80003152:	e852                	sd	s4,16(sp)
    80003154:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003156:	00004517          	auipc	a0,0x4
    8000315a:	36250513          	addi	a0,a0,866 # 800074b8 <etext+0x4b8>
    8000315e:	480020ef          	jal	800055de <panic>
    wakeup(&log);
    80003162:	00017497          	auipc	s1,0x17
    80003166:	06e48493          	addi	s1,s1,110 # 8001a1d0 <log>
    8000316a:	8526                	mv	a0,s1
    8000316c:	a7efe0ef          	jal	800013ea <wakeup>
  release(&log.lock);
    80003170:	8526                	mv	a0,s1
    80003172:	7c0020ef          	jal	80005932 <release>
}
    80003176:	70e2                	ld	ra,56(sp)
    80003178:	7442                	ld	s0,48(sp)
    8000317a:	74a2                	ld	s1,40(sp)
    8000317c:	7902                	ld	s2,32(sp)
    8000317e:	6121                	addi	sp,sp,64
    80003180:	8082                	ret
    80003182:	ec4e                	sd	s3,24(sp)
    80003184:	e852                	sd	s4,16(sp)
    80003186:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003188:	00017a97          	auipc	s5,0x17
    8000318c:	074a8a93          	addi	s5,s5,116 # 8001a1fc <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003190:	00017a17          	auipc	s4,0x17
    80003194:	040a0a13          	addi	s4,s4,64 # 8001a1d0 <log>
    80003198:	018a2583          	lw	a1,24(s4)
    8000319c:	012585bb          	addw	a1,a1,s2
    800031a0:	2585                	addiw	a1,a1,1
    800031a2:	024a2503          	lw	a0,36(s4)
    800031a6:	e27fe0ef          	jal	80001fcc <bread>
    800031aa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031ac:	000aa583          	lw	a1,0(s5)
    800031b0:	024a2503          	lw	a0,36(s4)
    800031b4:	e19fe0ef          	jal	80001fcc <bread>
    800031b8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031ba:	40000613          	li	a2,1024
    800031be:	05850593          	addi	a1,a0,88
    800031c2:	05848513          	addi	a0,s1,88
    800031c6:	fe5fc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    800031ca:	8526                	mv	a0,s1
    800031cc:	ed7fe0ef          	jal	800020a2 <bwrite>
    brelse(from);
    800031d0:	854e                	mv	a0,s3
    800031d2:	f03fe0ef          	jal	800020d4 <brelse>
    brelse(to);
    800031d6:	8526                	mv	a0,s1
    800031d8:	efdfe0ef          	jal	800020d4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031dc:	2905                	addiw	s2,s2,1
    800031de:	0a91                	addi	s5,s5,4
    800031e0:	028a2783          	lw	a5,40(s4)
    800031e4:	faf94ae3          	blt	s2,a5,80003198 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800031e8:	cf9ff0ef          	jal	80002ee0 <write_head>
    install_trans(0); // Now install writes to home locations
    800031ec:	4501                	li	a0,0
    800031ee:	d51ff0ef          	jal	80002f3e <install_trans>
    log.lh.n = 0;
    800031f2:	00017797          	auipc	a5,0x17
    800031f6:	0007a323          	sw	zero,6(a5) # 8001a1f8 <log+0x28>
    write_head();    // Erase the transaction from the log
    800031fa:	ce7ff0ef          	jal	80002ee0 <write_head>
    800031fe:	69e2                	ld	s3,24(sp)
    80003200:	6a42                	ld	s4,16(sp)
    80003202:	6aa2                	ld	s5,8(sp)
    80003204:	b735                	j	80003130 <end_op+0x44>

0000000080003206 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003206:	1101                	addi	sp,sp,-32
    80003208:	ec06                	sd	ra,24(sp)
    8000320a:	e822                	sd	s0,16(sp)
    8000320c:	e426                	sd	s1,8(sp)
    8000320e:	e04a                	sd	s2,0(sp)
    80003210:	1000                	addi	s0,sp,32
    80003212:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003214:	00017917          	auipc	s2,0x17
    80003218:	fbc90913          	addi	s2,s2,-68 # 8001a1d0 <log>
    8000321c:	854a                	mv	a0,s2
    8000321e:	67c020ef          	jal	8000589a <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003222:	02892603          	lw	a2,40(s2)
    80003226:	47f5                	li	a5,29
    80003228:	04c7cc63          	blt	a5,a2,80003280 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000322c:	00017797          	auipc	a5,0x17
    80003230:	fc07a783          	lw	a5,-64(a5) # 8001a1ec <log+0x1c>
    80003234:	04f05c63          	blez	a5,8000328c <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003238:	4781                	li	a5,0
    8000323a:	04c05f63          	blez	a2,80003298 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000323e:	44cc                	lw	a1,12(s1)
    80003240:	00017717          	auipc	a4,0x17
    80003244:	fbc70713          	addi	a4,a4,-68 # 8001a1fc <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003248:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000324a:	4314                	lw	a3,0(a4)
    8000324c:	04b68663          	beq	a3,a1,80003298 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003250:	2785                	addiw	a5,a5,1
    80003252:	0711                	addi	a4,a4,4
    80003254:	fef61be3          	bne	a2,a5,8000324a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003258:	0621                	addi	a2,a2,8
    8000325a:	060a                	slli	a2,a2,0x2
    8000325c:	00017797          	auipc	a5,0x17
    80003260:	f7478793          	addi	a5,a5,-140 # 8001a1d0 <log>
    80003264:	97b2                	add	a5,a5,a2
    80003266:	44d8                	lw	a4,12(s1)
    80003268:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000326a:	8526                	mv	a0,s1
    8000326c:	ef1fe0ef          	jal	8000215c <bpin>
    log.lh.n++;
    80003270:	00017717          	auipc	a4,0x17
    80003274:	f6070713          	addi	a4,a4,-160 # 8001a1d0 <log>
    80003278:	571c                	lw	a5,40(a4)
    8000327a:	2785                	addiw	a5,a5,1
    8000327c:	d71c                	sw	a5,40(a4)
    8000327e:	a80d                	j	800032b0 <log_write+0xaa>
    panic("too big a transaction");
    80003280:	00004517          	auipc	a0,0x4
    80003284:	24850513          	addi	a0,a0,584 # 800074c8 <etext+0x4c8>
    80003288:	356020ef          	jal	800055de <panic>
    panic("log_write outside of trans");
    8000328c:	00004517          	auipc	a0,0x4
    80003290:	25450513          	addi	a0,a0,596 # 800074e0 <etext+0x4e0>
    80003294:	34a020ef          	jal	800055de <panic>
  log.lh.block[i] = b->blockno;
    80003298:	00878693          	addi	a3,a5,8
    8000329c:	068a                	slli	a3,a3,0x2
    8000329e:	00017717          	auipc	a4,0x17
    800032a2:	f3270713          	addi	a4,a4,-206 # 8001a1d0 <log>
    800032a6:	9736                	add	a4,a4,a3
    800032a8:	44d4                	lw	a3,12(s1)
    800032aa:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032ac:	faf60fe3          	beq	a2,a5,8000326a <log_write+0x64>
  }
  release(&log.lock);
    800032b0:	00017517          	auipc	a0,0x17
    800032b4:	f2050513          	addi	a0,a0,-224 # 8001a1d0 <log>
    800032b8:	67a020ef          	jal	80005932 <release>
}
    800032bc:	60e2                	ld	ra,24(sp)
    800032be:	6442                	ld	s0,16(sp)
    800032c0:	64a2                	ld	s1,8(sp)
    800032c2:	6902                	ld	s2,0(sp)
    800032c4:	6105                	addi	sp,sp,32
    800032c6:	8082                	ret

00000000800032c8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800032c8:	1101                	addi	sp,sp,-32
    800032ca:	ec06                	sd	ra,24(sp)
    800032cc:	e822                	sd	s0,16(sp)
    800032ce:	e426                	sd	s1,8(sp)
    800032d0:	e04a                	sd	s2,0(sp)
    800032d2:	1000                	addi	s0,sp,32
    800032d4:	84aa                	mv	s1,a0
    800032d6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800032d8:	00004597          	auipc	a1,0x4
    800032dc:	22858593          	addi	a1,a1,552 # 80007500 <etext+0x500>
    800032e0:	0521                	addi	a0,a0,8
    800032e2:	538020ef          	jal	8000581a <initlock>
  lk->name = name;
    800032e6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800032ea:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032ee:	0204a423          	sw	zero,40(s1)
}
    800032f2:	60e2                	ld	ra,24(sp)
    800032f4:	6442                	ld	s0,16(sp)
    800032f6:	64a2                	ld	s1,8(sp)
    800032f8:	6902                	ld	s2,0(sp)
    800032fa:	6105                	addi	sp,sp,32
    800032fc:	8082                	ret

00000000800032fe <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800032fe:	1101                	addi	sp,sp,-32
    80003300:	ec06                	sd	ra,24(sp)
    80003302:	e822                	sd	s0,16(sp)
    80003304:	e426                	sd	s1,8(sp)
    80003306:	e04a                	sd	s2,0(sp)
    80003308:	1000                	addi	s0,sp,32
    8000330a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000330c:	00850913          	addi	s2,a0,8
    80003310:	854a                	mv	a0,s2
    80003312:	588020ef          	jal	8000589a <acquire>
  while (lk->locked) {
    80003316:	409c                	lw	a5,0(s1)
    80003318:	c799                	beqz	a5,80003326 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000331a:	85ca                	mv	a1,s2
    8000331c:	8526                	mv	a0,s1
    8000331e:	880fe0ef          	jal	8000139e <sleep>
  while (lk->locked) {
    80003322:	409c                	lw	a5,0(s1)
    80003324:	fbfd                	bnez	a5,8000331a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003326:	4785                	li	a5,1
    80003328:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000332a:	a7dfd0ef          	jal	80000da6 <myproc>
    8000332e:	591c                	lw	a5,48(a0)
    80003330:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003332:	854a                	mv	a0,s2
    80003334:	5fe020ef          	jal	80005932 <release>
}
    80003338:	60e2                	ld	ra,24(sp)
    8000333a:	6442                	ld	s0,16(sp)
    8000333c:	64a2                	ld	s1,8(sp)
    8000333e:	6902                	ld	s2,0(sp)
    80003340:	6105                	addi	sp,sp,32
    80003342:	8082                	ret

0000000080003344 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003344:	1101                	addi	sp,sp,-32
    80003346:	ec06                	sd	ra,24(sp)
    80003348:	e822                	sd	s0,16(sp)
    8000334a:	e426                	sd	s1,8(sp)
    8000334c:	e04a                	sd	s2,0(sp)
    8000334e:	1000                	addi	s0,sp,32
    80003350:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003352:	00850913          	addi	s2,a0,8
    80003356:	854a                	mv	a0,s2
    80003358:	542020ef          	jal	8000589a <acquire>
  lk->locked = 0;
    8000335c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003360:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003364:	8526                	mv	a0,s1
    80003366:	884fe0ef          	jal	800013ea <wakeup>
  release(&lk->lk);
    8000336a:	854a                	mv	a0,s2
    8000336c:	5c6020ef          	jal	80005932 <release>
}
    80003370:	60e2                	ld	ra,24(sp)
    80003372:	6442                	ld	s0,16(sp)
    80003374:	64a2                	ld	s1,8(sp)
    80003376:	6902                	ld	s2,0(sp)
    80003378:	6105                	addi	sp,sp,32
    8000337a:	8082                	ret

000000008000337c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000337c:	7179                	addi	sp,sp,-48
    8000337e:	f406                	sd	ra,40(sp)
    80003380:	f022                	sd	s0,32(sp)
    80003382:	ec26                	sd	s1,24(sp)
    80003384:	e84a                	sd	s2,16(sp)
    80003386:	1800                	addi	s0,sp,48
    80003388:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000338a:	00850913          	addi	s2,a0,8
    8000338e:	854a                	mv	a0,s2
    80003390:	50a020ef          	jal	8000589a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003394:	409c                	lw	a5,0(s1)
    80003396:	ef81                	bnez	a5,800033ae <holdingsleep+0x32>
    80003398:	4481                	li	s1,0
  release(&lk->lk);
    8000339a:	854a                	mv	a0,s2
    8000339c:	596020ef          	jal	80005932 <release>
  return r;
}
    800033a0:	8526                	mv	a0,s1
    800033a2:	70a2                	ld	ra,40(sp)
    800033a4:	7402                	ld	s0,32(sp)
    800033a6:	64e2                	ld	s1,24(sp)
    800033a8:	6942                	ld	s2,16(sp)
    800033aa:	6145                	addi	sp,sp,48
    800033ac:	8082                	ret
    800033ae:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800033b0:	0284a983          	lw	s3,40(s1)
    800033b4:	9f3fd0ef          	jal	80000da6 <myproc>
    800033b8:	5904                	lw	s1,48(a0)
    800033ba:	413484b3          	sub	s1,s1,s3
    800033be:	0014b493          	seqz	s1,s1
    800033c2:	69a2                	ld	s3,8(sp)
    800033c4:	bfd9                	j	8000339a <holdingsleep+0x1e>

00000000800033c6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800033c6:	1141                	addi	sp,sp,-16
    800033c8:	e406                	sd	ra,8(sp)
    800033ca:	e022                	sd	s0,0(sp)
    800033cc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800033ce:	00004597          	auipc	a1,0x4
    800033d2:	14258593          	addi	a1,a1,322 # 80007510 <etext+0x510>
    800033d6:	00017517          	auipc	a0,0x17
    800033da:	f4250513          	addi	a0,a0,-190 # 8001a318 <ftable>
    800033de:	43c020ef          	jal	8000581a <initlock>
}
    800033e2:	60a2                	ld	ra,8(sp)
    800033e4:	6402                	ld	s0,0(sp)
    800033e6:	0141                	addi	sp,sp,16
    800033e8:	8082                	ret

00000000800033ea <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800033ea:	1101                	addi	sp,sp,-32
    800033ec:	ec06                	sd	ra,24(sp)
    800033ee:	e822                	sd	s0,16(sp)
    800033f0:	e426                	sd	s1,8(sp)
    800033f2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800033f4:	00017517          	auipc	a0,0x17
    800033f8:	f2450513          	addi	a0,a0,-220 # 8001a318 <ftable>
    800033fc:	49e020ef          	jal	8000589a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003400:	00017497          	auipc	s1,0x17
    80003404:	f3048493          	addi	s1,s1,-208 # 8001a330 <ftable+0x18>
    80003408:	00018717          	auipc	a4,0x18
    8000340c:	ec870713          	addi	a4,a4,-312 # 8001b2d0 <disk>
    if(f->ref == 0){
    80003410:	40dc                	lw	a5,4(s1)
    80003412:	cf89                	beqz	a5,8000342c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003414:	02848493          	addi	s1,s1,40
    80003418:	fee49ce3          	bne	s1,a4,80003410 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000341c:	00017517          	auipc	a0,0x17
    80003420:	efc50513          	addi	a0,a0,-260 # 8001a318 <ftable>
    80003424:	50e020ef          	jal	80005932 <release>
  return 0;
    80003428:	4481                	li	s1,0
    8000342a:	a809                	j	8000343c <filealloc+0x52>
      f->ref = 1;
    8000342c:	4785                	li	a5,1
    8000342e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003430:	00017517          	auipc	a0,0x17
    80003434:	ee850513          	addi	a0,a0,-280 # 8001a318 <ftable>
    80003438:	4fa020ef          	jal	80005932 <release>
}
    8000343c:	8526                	mv	a0,s1
    8000343e:	60e2                	ld	ra,24(sp)
    80003440:	6442                	ld	s0,16(sp)
    80003442:	64a2                	ld	s1,8(sp)
    80003444:	6105                	addi	sp,sp,32
    80003446:	8082                	ret

0000000080003448 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003448:	1101                	addi	sp,sp,-32
    8000344a:	ec06                	sd	ra,24(sp)
    8000344c:	e822                	sd	s0,16(sp)
    8000344e:	e426                	sd	s1,8(sp)
    80003450:	1000                	addi	s0,sp,32
    80003452:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003454:	00017517          	auipc	a0,0x17
    80003458:	ec450513          	addi	a0,a0,-316 # 8001a318 <ftable>
    8000345c:	43e020ef          	jal	8000589a <acquire>
  if(f->ref < 1)
    80003460:	40dc                	lw	a5,4(s1)
    80003462:	02f05063          	blez	a5,80003482 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003466:	2785                	addiw	a5,a5,1
    80003468:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000346a:	00017517          	auipc	a0,0x17
    8000346e:	eae50513          	addi	a0,a0,-338 # 8001a318 <ftable>
    80003472:	4c0020ef          	jal	80005932 <release>
  return f;
}
    80003476:	8526                	mv	a0,s1
    80003478:	60e2                	ld	ra,24(sp)
    8000347a:	6442                	ld	s0,16(sp)
    8000347c:	64a2                	ld	s1,8(sp)
    8000347e:	6105                	addi	sp,sp,32
    80003480:	8082                	ret
    panic("filedup");
    80003482:	00004517          	auipc	a0,0x4
    80003486:	09650513          	addi	a0,a0,150 # 80007518 <etext+0x518>
    8000348a:	154020ef          	jal	800055de <panic>

000000008000348e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000348e:	7139                	addi	sp,sp,-64
    80003490:	fc06                	sd	ra,56(sp)
    80003492:	f822                	sd	s0,48(sp)
    80003494:	f426                	sd	s1,40(sp)
    80003496:	0080                	addi	s0,sp,64
    80003498:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000349a:	00017517          	auipc	a0,0x17
    8000349e:	e7e50513          	addi	a0,a0,-386 # 8001a318 <ftable>
    800034a2:	3f8020ef          	jal	8000589a <acquire>
  if(f->ref < 1)
    800034a6:	40dc                	lw	a5,4(s1)
    800034a8:	04f05a63          	blez	a5,800034fc <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800034ac:	37fd                	addiw	a5,a5,-1
    800034ae:	0007871b          	sext.w	a4,a5
    800034b2:	c0dc                	sw	a5,4(s1)
    800034b4:	04e04e63          	bgtz	a4,80003510 <fileclose+0x82>
    800034b8:	f04a                	sd	s2,32(sp)
    800034ba:	ec4e                	sd	s3,24(sp)
    800034bc:	e852                	sd	s4,16(sp)
    800034be:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800034c0:	0004a903          	lw	s2,0(s1)
    800034c4:	0094ca83          	lbu	s5,9(s1)
    800034c8:	0104ba03          	ld	s4,16(s1)
    800034cc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800034d0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800034d4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800034d8:	00017517          	auipc	a0,0x17
    800034dc:	e4050513          	addi	a0,a0,-448 # 8001a318 <ftable>
    800034e0:	452020ef          	jal	80005932 <release>

  if(ff.type == FD_PIPE){
    800034e4:	4785                	li	a5,1
    800034e6:	04f90063          	beq	s2,a5,80003526 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800034ea:	3979                	addiw	s2,s2,-2
    800034ec:	4785                	li	a5,1
    800034ee:	0527f563          	bgeu	a5,s2,80003538 <fileclose+0xaa>
    800034f2:	7902                	ld	s2,32(sp)
    800034f4:	69e2                	ld	s3,24(sp)
    800034f6:	6a42                	ld	s4,16(sp)
    800034f8:	6aa2                	ld	s5,8(sp)
    800034fa:	a00d                	j	8000351c <fileclose+0x8e>
    800034fc:	f04a                	sd	s2,32(sp)
    800034fe:	ec4e                	sd	s3,24(sp)
    80003500:	e852                	sd	s4,16(sp)
    80003502:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003504:	00004517          	auipc	a0,0x4
    80003508:	01c50513          	addi	a0,a0,28 # 80007520 <etext+0x520>
    8000350c:	0d2020ef          	jal	800055de <panic>
    release(&ftable.lock);
    80003510:	00017517          	auipc	a0,0x17
    80003514:	e0850513          	addi	a0,a0,-504 # 8001a318 <ftable>
    80003518:	41a020ef          	jal	80005932 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000351c:	70e2                	ld	ra,56(sp)
    8000351e:	7442                	ld	s0,48(sp)
    80003520:	74a2                	ld	s1,40(sp)
    80003522:	6121                	addi	sp,sp,64
    80003524:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003526:	85d6                	mv	a1,s5
    80003528:	8552                	mv	a0,s4
    8000352a:	336000ef          	jal	80003860 <pipeclose>
    8000352e:	7902                	ld	s2,32(sp)
    80003530:	69e2                	ld	s3,24(sp)
    80003532:	6a42                	ld	s4,16(sp)
    80003534:	6aa2                	ld	s5,8(sp)
    80003536:	b7dd                	j	8000351c <fileclose+0x8e>
    begin_op();
    80003538:	b4bff0ef          	jal	80003082 <begin_op>
    iput(ff.ip);
    8000353c:	854e                	mv	a0,s3
    8000353e:	adcff0ef          	jal	8000281a <iput>
    end_op();
    80003542:	babff0ef          	jal	800030ec <end_op>
    80003546:	7902                	ld	s2,32(sp)
    80003548:	69e2                	ld	s3,24(sp)
    8000354a:	6a42                	ld	s4,16(sp)
    8000354c:	6aa2                	ld	s5,8(sp)
    8000354e:	b7f9                	j	8000351c <fileclose+0x8e>

0000000080003550 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003550:	715d                	addi	sp,sp,-80
    80003552:	e486                	sd	ra,72(sp)
    80003554:	e0a2                	sd	s0,64(sp)
    80003556:	fc26                	sd	s1,56(sp)
    80003558:	f44e                	sd	s3,40(sp)
    8000355a:	0880                	addi	s0,sp,80
    8000355c:	84aa                	mv	s1,a0
    8000355e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003560:	847fd0ef          	jal	80000da6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003564:	409c                	lw	a5,0(s1)
    80003566:	37f9                	addiw	a5,a5,-2
    80003568:	4705                	li	a4,1
    8000356a:	04f76063          	bltu	a4,a5,800035aa <filestat+0x5a>
    8000356e:	f84a                	sd	s2,48(sp)
    80003570:	892a                	mv	s2,a0
    ilock(f->ip);
    80003572:	6c88                	ld	a0,24(s1)
    80003574:	924ff0ef          	jal	80002698 <ilock>
    stati(f->ip, &st);
    80003578:	fb840593          	addi	a1,s0,-72
    8000357c:	6c88                	ld	a0,24(s1)
    8000357e:	c80ff0ef          	jal	800029fe <stati>
    iunlock(f->ip);
    80003582:	6c88                	ld	a0,24(s1)
    80003584:	9c2ff0ef          	jal	80002746 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003588:	46e1                	li	a3,24
    8000358a:	fb840613          	addi	a2,s0,-72
    8000358e:	85ce                	mv	a1,s3
    80003590:	05093503          	ld	a0,80(s2)
    80003594:	d16fd0ef          	jal	80000aaa <copyout>
    80003598:	41f5551b          	sraiw	a0,a0,0x1f
    8000359c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000359e:	60a6                	ld	ra,72(sp)
    800035a0:	6406                	ld	s0,64(sp)
    800035a2:	74e2                	ld	s1,56(sp)
    800035a4:	79a2                	ld	s3,40(sp)
    800035a6:	6161                	addi	sp,sp,80
    800035a8:	8082                	ret
  return -1;
    800035aa:	557d                	li	a0,-1
    800035ac:	bfcd                	j	8000359e <filestat+0x4e>

00000000800035ae <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035ae:	7179                	addi	sp,sp,-48
    800035b0:	f406                	sd	ra,40(sp)
    800035b2:	f022                	sd	s0,32(sp)
    800035b4:	e84a                	sd	s2,16(sp)
    800035b6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035b8:	00854783          	lbu	a5,8(a0)
    800035bc:	cfd1                	beqz	a5,80003658 <fileread+0xaa>
    800035be:	ec26                	sd	s1,24(sp)
    800035c0:	e44e                	sd	s3,8(sp)
    800035c2:	84aa                	mv	s1,a0
    800035c4:	89ae                	mv	s3,a1
    800035c6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800035c8:	411c                	lw	a5,0(a0)
    800035ca:	4705                	li	a4,1
    800035cc:	04e78363          	beq	a5,a4,80003612 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035d0:	470d                	li	a4,3
    800035d2:	04e78763          	beq	a5,a4,80003620 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800035d6:	4709                	li	a4,2
    800035d8:	06e79a63          	bne	a5,a4,8000364c <fileread+0x9e>
    ilock(f->ip);
    800035dc:	6d08                	ld	a0,24(a0)
    800035de:	8baff0ef          	jal	80002698 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800035e2:	874a                	mv	a4,s2
    800035e4:	5094                	lw	a3,32(s1)
    800035e6:	864e                	mv	a2,s3
    800035e8:	4585                	li	a1,1
    800035ea:	6c88                	ld	a0,24(s1)
    800035ec:	c3cff0ef          	jal	80002a28 <readi>
    800035f0:	892a                	mv	s2,a0
    800035f2:	00a05563          	blez	a0,800035fc <fileread+0x4e>
      f->off += r;
    800035f6:	509c                	lw	a5,32(s1)
    800035f8:	9fa9                	addw	a5,a5,a0
    800035fa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800035fc:	6c88                	ld	a0,24(s1)
    800035fe:	948ff0ef          	jal	80002746 <iunlock>
    80003602:	64e2                	ld	s1,24(sp)
    80003604:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003606:	854a                	mv	a0,s2
    80003608:	70a2                	ld	ra,40(sp)
    8000360a:	7402                	ld	s0,32(sp)
    8000360c:	6942                	ld	s2,16(sp)
    8000360e:	6145                	addi	sp,sp,48
    80003610:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003612:	6908                	ld	a0,16(a0)
    80003614:	388000ef          	jal	8000399c <piperead>
    80003618:	892a                	mv	s2,a0
    8000361a:	64e2                	ld	s1,24(sp)
    8000361c:	69a2                	ld	s3,8(sp)
    8000361e:	b7e5                	j	80003606 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003620:	02451783          	lh	a5,36(a0)
    80003624:	03079693          	slli	a3,a5,0x30
    80003628:	92c1                	srli	a3,a3,0x30
    8000362a:	4725                	li	a4,9
    8000362c:	02d76863          	bltu	a4,a3,8000365c <fileread+0xae>
    80003630:	0792                	slli	a5,a5,0x4
    80003632:	00017717          	auipc	a4,0x17
    80003636:	c4670713          	addi	a4,a4,-954 # 8001a278 <devsw>
    8000363a:	97ba                	add	a5,a5,a4
    8000363c:	639c                	ld	a5,0(a5)
    8000363e:	c39d                	beqz	a5,80003664 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003640:	4505                	li	a0,1
    80003642:	9782                	jalr	a5
    80003644:	892a                	mv	s2,a0
    80003646:	64e2                	ld	s1,24(sp)
    80003648:	69a2                	ld	s3,8(sp)
    8000364a:	bf75                	j	80003606 <fileread+0x58>
    panic("fileread");
    8000364c:	00004517          	auipc	a0,0x4
    80003650:	ee450513          	addi	a0,a0,-284 # 80007530 <etext+0x530>
    80003654:	78b010ef          	jal	800055de <panic>
    return -1;
    80003658:	597d                	li	s2,-1
    8000365a:	b775                	j	80003606 <fileread+0x58>
      return -1;
    8000365c:	597d                	li	s2,-1
    8000365e:	64e2                	ld	s1,24(sp)
    80003660:	69a2                	ld	s3,8(sp)
    80003662:	b755                	j	80003606 <fileread+0x58>
    80003664:	597d                	li	s2,-1
    80003666:	64e2                	ld	s1,24(sp)
    80003668:	69a2                	ld	s3,8(sp)
    8000366a:	bf71                	j	80003606 <fileread+0x58>

000000008000366c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000366c:	00954783          	lbu	a5,9(a0)
    80003670:	10078b63          	beqz	a5,80003786 <filewrite+0x11a>
{
    80003674:	715d                	addi	sp,sp,-80
    80003676:	e486                	sd	ra,72(sp)
    80003678:	e0a2                	sd	s0,64(sp)
    8000367a:	f84a                	sd	s2,48(sp)
    8000367c:	f052                	sd	s4,32(sp)
    8000367e:	e85a                	sd	s6,16(sp)
    80003680:	0880                	addi	s0,sp,80
    80003682:	892a                	mv	s2,a0
    80003684:	8b2e                	mv	s6,a1
    80003686:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003688:	411c                	lw	a5,0(a0)
    8000368a:	4705                	li	a4,1
    8000368c:	02e78763          	beq	a5,a4,800036ba <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003690:	470d                	li	a4,3
    80003692:	02e78863          	beq	a5,a4,800036c2 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003696:	4709                	li	a4,2
    80003698:	0ce79c63          	bne	a5,a4,80003770 <filewrite+0x104>
    8000369c:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000369e:	0ac05863          	blez	a2,8000374e <filewrite+0xe2>
    800036a2:	fc26                	sd	s1,56(sp)
    800036a4:	ec56                	sd	s5,24(sp)
    800036a6:	e45e                	sd	s7,8(sp)
    800036a8:	e062                	sd	s8,0(sp)
    int i = 0;
    800036aa:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800036ac:	6b85                	lui	s7,0x1
    800036ae:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036b2:	6c05                	lui	s8,0x1
    800036b4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800036b8:	a8b5                	j	80003734 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800036ba:	6908                	ld	a0,16(a0)
    800036bc:	1fc000ef          	jal	800038b8 <pipewrite>
    800036c0:	a04d                	j	80003762 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800036c2:	02451783          	lh	a5,36(a0)
    800036c6:	03079693          	slli	a3,a5,0x30
    800036ca:	92c1                	srli	a3,a3,0x30
    800036cc:	4725                	li	a4,9
    800036ce:	0ad76e63          	bltu	a4,a3,8000378a <filewrite+0x11e>
    800036d2:	0792                	slli	a5,a5,0x4
    800036d4:	00017717          	auipc	a4,0x17
    800036d8:	ba470713          	addi	a4,a4,-1116 # 8001a278 <devsw>
    800036dc:	97ba                	add	a5,a5,a4
    800036de:	679c                	ld	a5,8(a5)
    800036e0:	c7dd                	beqz	a5,8000378e <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800036e2:	4505                	li	a0,1
    800036e4:	9782                	jalr	a5
    800036e6:	a8b5                	j	80003762 <filewrite+0xf6>
      if(n1 > max)
    800036e8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800036ec:	997ff0ef          	jal	80003082 <begin_op>
      ilock(f->ip);
    800036f0:	01893503          	ld	a0,24(s2)
    800036f4:	fa5fe0ef          	jal	80002698 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036f8:	8756                	mv	a4,s5
    800036fa:	02092683          	lw	a3,32(s2)
    800036fe:	01698633          	add	a2,s3,s6
    80003702:	4585                	li	a1,1
    80003704:	01893503          	ld	a0,24(s2)
    80003708:	c1cff0ef          	jal	80002b24 <writei>
    8000370c:	84aa                	mv	s1,a0
    8000370e:	00a05763          	blez	a0,8000371c <filewrite+0xb0>
        f->off += r;
    80003712:	02092783          	lw	a5,32(s2)
    80003716:	9fa9                	addw	a5,a5,a0
    80003718:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000371c:	01893503          	ld	a0,24(s2)
    80003720:	826ff0ef          	jal	80002746 <iunlock>
      end_op();
    80003724:	9c9ff0ef          	jal	800030ec <end_op>

      if(r != n1){
    80003728:	029a9563          	bne	s5,s1,80003752 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000372c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003730:	0149da63          	bge	s3,s4,80003744 <filewrite+0xd8>
      int n1 = n - i;
    80003734:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003738:	0004879b          	sext.w	a5,s1
    8000373c:	fafbd6e3          	bge	s7,a5,800036e8 <filewrite+0x7c>
    80003740:	84e2                	mv	s1,s8
    80003742:	b75d                	j	800036e8 <filewrite+0x7c>
    80003744:	74e2                	ld	s1,56(sp)
    80003746:	6ae2                	ld	s5,24(sp)
    80003748:	6ba2                	ld	s7,8(sp)
    8000374a:	6c02                	ld	s8,0(sp)
    8000374c:	a039                	j	8000375a <filewrite+0xee>
    int i = 0;
    8000374e:	4981                	li	s3,0
    80003750:	a029                	j	8000375a <filewrite+0xee>
    80003752:	74e2                	ld	s1,56(sp)
    80003754:	6ae2                	ld	s5,24(sp)
    80003756:	6ba2                	ld	s7,8(sp)
    80003758:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000375a:	033a1c63          	bne	s4,s3,80003792 <filewrite+0x126>
    8000375e:	8552                	mv	a0,s4
    80003760:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003762:	60a6                	ld	ra,72(sp)
    80003764:	6406                	ld	s0,64(sp)
    80003766:	7942                	ld	s2,48(sp)
    80003768:	7a02                	ld	s4,32(sp)
    8000376a:	6b42                	ld	s6,16(sp)
    8000376c:	6161                	addi	sp,sp,80
    8000376e:	8082                	ret
    80003770:	fc26                	sd	s1,56(sp)
    80003772:	f44e                	sd	s3,40(sp)
    80003774:	ec56                	sd	s5,24(sp)
    80003776:	e45e                	sd	s7,8(sp)
    80003778:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000377a:	00004517          	auipc	a0,0x4
    8000377e:	dc650513          	addi	a0,a0,-570 # 80007540 <etext+0x540>
    80003782:	65d010ef          	jal	800055de <panic>
    return -1;
    80003786:	557d                	li	a0,-1
}
    80003788:	8082                	ret
      return -1;
    8000378a:	557d                	li	a0,-1
    8000378c:	bfd9                	j	80003762 <filewrite+0xf6>
    8000378e:	557d                	li	a0,-1
    80003790:	bfc9                	j	80003762 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003792:	557d                	li	a0,-1
    80003794:	79a2                	ld	s3,40(sp)
    80003796:	b7f1                	j	80003762 <filewrite+0xf6>

0000000080003798 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003798:	7179                	addi	sp,sp,-48
    8000379a:	f406                	sd	ra,40(sp)
    8000379c:	f022                	sd	s0,32(sp)
    8000379e:	ec26                	sd	s1,24(sp)
    800037a0:	e052                	sd	s4,0(sp)
    800037a2:	1800                	addi	s0,sp,48
    800037a4:	84aa                	mv	s1,a0
    800037a6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037a8:	0005b023          	sd	zero,0(a1)
    800037ac:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037b0:	c3bff0ef          	jal	800033ea <filealloc>
    800037b4:	e088                	sd	a0,0(s1)
    800037b6:	c549                	beqz	a0,80003840 <pipealloc+0xa8>
    800037b8:	c33ff0ef          	jal	800033ea <filealloc>
    800037bc:	00aa3023          	sd	a0,0(s4)
    800037c0:	cd25                	beqz	a0,80003838 <pipealloc+0xa0>
    800037c2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800037c4:	93bfc0ef          	jal	800000fe <kalloc>
    800037c8:	892a                	mv	s2,a0
    800037ca:	c12d                	beqz	a0,8000382c <pipealloc+0x94>
    800037cc:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800037ce:	4985                	li	s3,1
    800037d0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037d4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037d8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037dc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037e0:	00004597          	auipc	a1,0x4
    800037e4:	d7058593          	addi	a1,a1,-656 # 80007550 <etext+0x550>
    800037e8:	032020ef          	jal	8000581a <initlock>
  (*f0)->type = FD_PIPE;
    800037ec:	609c                	ld	a5,0(s1)
    800037ee:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800037f2:	609c                	ld	a5,0(s1)
    800037f4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800037f8:	609c                	ld	a5,0(s1)
    800037fa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800037fe:	609c                	ld	a5,0(s1)
    80003800:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003804:	000a3783          	ld	a5,0(s4)
    80003808:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000380c:	000a3783          	ld	a5,0(s4)
    80003810:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003814:	000a3783          	ld	a5,0(s4)
    80003818:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000381c:	000a3783          	ld	a5,0(s4)
    80003820:	0127b823          	sd	s2,16(a5)
  return 0;
    80003824:	4501                	li	a0,0
    80003826:	6942                	ld	s2,16(sp)
    80003828:	69a2                	ld	s3,8(sp)
    8000382a:	a01d                	j	80003850 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000382c:	6088                	ld	a0,0(s1)
    8000382e:	c119                	beqz	a0,80003834 <pipealloc+0x9c>
    80003830:	6942                	ld	s2,16(sp)
    80003832:	a029                	j	8000383c <pipealloc+0xa4>
    80003834:	6942                	ld	s2,16(sp)
    80003836:	a029                	j	80003840 <pipealloc+0xa8>
    80003838:	6088                	ld	a0,0(s1)
    8000383a:	c10d                	beqz	a0,8000385c <pipealloc+0xc4>
    fileclose(*f0);
    8000383c:	c53ff0ef          	jal	8000348e <fileclose>
  if(*f1)
    80003840:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003844:	557d                	li	a0,-1
  if(*f1)
    80003846:	c789                	beqz	a5,80003850 <pipealloc+0xb8>
    fileclose(*f1);
    80003848:	853e                	mv	a0,a5
    8000384a:	c45ff0ef          	jal	8000348e <fileclose>
  return -1;
    8000384e:	557d                	li	a0,-1
}
    80003850:	70a2                	ld	ra,40(sp)
    80003852:	7402                	ld	s0,32(sp)
    80003854:	64e2                	ld	s1,24(sp)
    80003856:	6a02                	ld	s4,0(sp)
    80003858:	6145                	addi	sp,sp,48
    8000385a:	8082                	ret
  return -1;
    8000385c:	557d                	li	a0,-1
    8000385e:	bfcd                	j	80003850 <pipealloc+0xb8>

0000000080003860 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003860:	1101                	addi	sp,sp,-32
    80003862:	ec06                	sd	ra,24(sp)
    80003864:	e822                	sd	s0,16(sp)
    80003866:	e426                	sd	s1,8(sp)
    80003868:	e04a                	sd	s2,0(sp)
    8000386a:	1000                	addi	s0,sp,32
    8000386c:	84aa                	mv	s1,a0
    8000386e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003870:	02a020ef          	jal	8000589a <acquire>
  if(writable){
    80003874:	02090763          	beqz	s2,800038a2 <pipeclose+0x42>
    pi->writeopen = 0;
    80003878:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000387c:	21848513          	addi	a0,s1,536
    80003880:	b6bfd0ef          	jal	800013ea <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003884:	2204b783          	ld	a5,544(s1)
    80003888:	e785                	bnez	a5,800038b0 <pipeclose+0x50>
    release(&pi->lock);
    8000388a:	8526                	mv	a0,s1
    8000388c:	0a6020ef          	jal	80005932 <release>
    kfree((char*)pi);
    80003890:	8526                	mv	a0,s1
    80003892:	f8afc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003896:	60e2                	ld	ra,24(sp)
    80003898:	6442                	ld	s0,16(sp)
    8000389a:	64a2                	ld	s1,8(sp)
    8000389c:	6902                	ld	s2,0(sp)
    8000389e:	6105                	addi	sp,sp,32
    800038a0:	8082                	ret
    pi->readopen = 0;
    800038a2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038a6:	21c48513          	addi	a0,s1,540
    800038aa:	b41fd0ef          	jal	800013ea <wakeup>
    800038ae:	bfd9                	j	80003884 <pipeclose+0x24>
    release(&pi->lock);
    800038b0:	8526                	mv	a0,s1
    800038b2:	080020ef          	jal	80005932 <release>
}
    800038b6:	b7c5                	j	80003896 <pipeclose+0x36>

00000000800038b8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038b8:	711d                	addi	sp,sp,-96
    800038ba:	ec86                	sd	ra,88(sp)
    800038bc:	e8a2                	sd	s0,80(sp)
    800038be:	e4a6                	sd	s1,72(sp)
    800038c0:	e0ca                	sd	s2,64(sp)
    800038c2:	fc4e                	sd	s3,56(sp)
    800038c4:	f852                	sd	s4,48(sp)
    800038c6:	f456                	sd	s5,40(sp)
    800038c8:	1080                	addi	s0,sp,96
    800038ca:	84aa                	mv	s1,a0
    800038cc:	8aae                	mv	s5,a1
    800038ce:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038d0:	cd6fd0ef          	jal	80000da6 <myproc>
    800038d4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038d6:	8526                	mv	a0,s1
    800038d8:	7c3010ef          	jal	8000589a <acquire>
  while(i < n){
    800038dc:	0b405a63          	blez	s4,80003990 <pipewrite+0xd8>
    800038e0:	f05a                	sd	s6,32(sp)
    800038e2:	ec5e                	sd	s7,24(sp)
    800038e4:	e862                	sd	s8,16(sp)
  int i = 0;
    800038e6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038e8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800038ea:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800038ee:	21c48b93          	addi	s7,s1,540
    800038f2:	a81d                	j	80003928 <pipewrite+0x70>
      release(&pi->lock);
    800038f4:	8526                	mv	a0,s1
    800038f6:	03c020ef          	jal	80005932 <release>
      return -1;
    800038fa:	597d                	li	s2,-1
    800038fc:	7b02                	ld	s6,32(sp)
    800038fe:	6be2                	ld	s7,24(sp)
    80003900:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003902:	854a                	mv	a0,s2
    80003904:	60e6                	ld	ra,88(sp)
    80003906:	6446                	ld	s0,80(sp)
    80003908:	64a6                	ld	s1,72(sp)
    8000390a:	6906                	ld	s2,64(sp)
    8000390c:	79e2                	ld	s3,56(sp)
    8000390e:	7a42                	ld	s4,48(sp)
    80003910:	7aa2                	ld	s5,40(sp)
    80003912:	6125                	addi	sp,sp,96
    80003914:	8082                	ret
      wakeup(&pi->nread);
    80003916:	8562                	mv	a0,s8
    80003918:	ad3fd0ef          	jal	800013ea <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000391c:	85a6                	mv	a1,s1
    8000391e:	855e                	mv	a0,s7
    80003920:	a7ffd0ef          	jal	8000139e <sleep>
  while(i < n){
    80003924:	05495b63          	bge	s2,s4,8000397a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003928:	2204a783          	lw	a5,544(s1)
    8000392c:	d7e1                	beqz	a5,800038f4 <pipewrite+0x3c>
    8000392e:	854e                	mv	a0,s3
    80003930:	ca7fd0ef          	jal	800015d6 <killed>
    80003934:	f161                	bnez	a0,800038f4 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003936:	2184a783          	lw	a5,536(s1)
    8000393a:	21c4a703          	lw	a4,540(s1)
    8000393e:	2007879b          	addiw	a5,a5,512
    80003942:	fcf70ae3          	beq	a4,a5,80003916 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003946:	4685                	li	a3,1
    80003948:	01590633          	add	a2,s2,s5
    8000394c:	faf40593          	addi	a1,s0,-81
    80003950:	0509b503          	ld	a0,80(s3)
    80003954:	a4afd0ef          	jal	80000b9e <copyin>
    80003958:	03650e63          	beq	a0,s6,80003994 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000395c:	21c4a783          	lw	a5,540(s1)
    80003960:	0017871b          	addiw	a4,a5,1
    80003964:	20e4ae23          	sw	a4,540(s1)
    80003968:	1ff7f793          	andi	a5,a5,511
    8000396c:	97a6                	add	a5,a5,s1
    8000396e:	faf44703          	lbu	a4,-81(s0)
    80003972:	00e78c23          	sb	a4,24(a5)
      i++;
    80003976:	2905                	addiw	s2,s2,1
    80003978:	b775                	j	80003924 <pipewrite+0x6c>
    8000397a:	7b02                	ld	s6,32(sp)
    8000397c:	6be2                	ld	s7,24(sp)
    8000397e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003980:	21848513          	addi	a0,s1,536
    80003984:	a67fd0ef          	jal	800013ea <wakeup>
  release(&pi->lock);
    80003988:	8526                	mv	a0,s1
    8000398a:	7a9010ef          	jal	80005932 <release>
  return i;
    8000398e:	bf95                	j	80003902 <pipewrite+0x4a>
  int i = 0;
    80003990:	4901                	li	s2,0
    80003992:	b7fd                	j	80003980 <pipewrite+0xc8>
    80003994:	7b02                	ld	s6,32(sp)
    80003996:	6be2                	ld	s7,24(sp)
    80003998:	6c42                	ld	s8,16(sp)
    8000399a:	b7dd                	j	80003980 <pipewrite+0xc8>

000000008000399c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000399c:	715d                	addi	sp,sp,-80
    8000399e:	e486                	sd	ra,72(sp)
    800039a0:	e0a2                	sd	s0,64(sp)
    800039a2:	fc26                	sd	s1,56(sp)
    800039a4:	f84a                	sd	s2,48(sp)
    800039a6:	f44e                	sd	s3,40(sp)
    800039a8:	f052                	sd	s4,32(sp)
    800039aa:	ec56                	sd	s5,24(sp)
    800039ac:	0880                	addi	s0,sp,80
    800039ae:	84aa                	mv	s1,a0
    800039b0:	892e                	mv	s2,a1
    800039b2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039b4:	bf2fd0ef          	jal	80000da6 <myproc>
    800039b8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039ba:	8526                	mv	a0,s1
    800039bc:	6df010ef          	jal	8000589a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039c0:	2184a703          	lw	a4,536(s1)
    800039c4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039c8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039cc:	02f71563          	bne	a4,a5,800039f6 <piperead+0x5a>
    800039d0:	2244a783          	lw	a5,548(s1)
    800039d4:	cb85                	beqz	a5,80003a04 <piperead+0x68>
    if(killed(pr)){
    800039d6:	8552                	mv	a0,s4
    800039d8:	bfffd0ef          	jal	800015d6 <killed>
    800039dc:	ed19                	bnez	a0,800039fa <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039de:	85a6                	mv	a1,s1
    800039e0:	854e                	mv	a0,s3
    800039e2:	9bdfd0ef          	jal	8000139e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039e6:	2184a703          	lw	a4,536(s1)
    800039ea:	21c4a783          	lw	a5,540(s1)
    800039ee:	fef701e3          	beq	a4,a5,800039d0 <piperead+0x34>
    800039f2:	e85a                	sd	s6,16(sp)
    800039f4:	a809                	j	80003a06 <piperead+0x6a>
    800039f6:	e85a                	sd	s6,16(sp)
    800039f8:	a039                	j	80003a06 <piperead+0x6a>
      release(&pi->lock);
    800039fa:	8526                	mv	a0,s1
    800039fc:	737010ef          	jal	80005932 <release>
      return -1;
    80003a00:	59fd                	li	s3,-1
    80003a02:	a8b1                	j	80003a5e <piperead+0xc2>
    80003a04:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a06:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a08:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a0a:	05505263          	blez	s5,80003a4e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a0e:	2184a783          	lw	a5,536(s1)
    80003a12:	21c4a703          	lw	a4,540(s1)
    80003a16:	02f70c63          	beq	a4,a5,80003a4e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a1a:	0017871b          	addiw	a4,a5,1
    80003a1e:	20e4ac23          	sw	a4,536(s1)
    80003a22:	1ff7f793          	andi	a5,a5,511
    80003a26:	97a6                	add	a5,a5,s1
    80003a28:	0187c783          	lbu	a5,24(a5)
    80003a2c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a30:	4685                	li	a3,1
    80003a32:	fbf40613          	addi	a2,s0,-65
    80003a36:	85ca                	mv	a1,s2
    80003a38:	050a3503          	ld	a0,80(s4)
    80003a3c:	86efd0ef          	jal	80000aaa <copyout>
    80003a40:	01650763          	beq	a0,s6,80003a4e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a44:	2985                	addiw	s3,s3,1
    80003a46:	0905                	addi	s2,s2,1
    80003a48:	fd3a93e3          	bne	s5,s3,80003a0e <piperead+0x72>
    80003a4c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a4e:	21c48513          	addi	a0,s1,540
    80003a52:	999fd0ef          	jal	800013ea <wakeup>
  release(&pi->lock);
    80003a56:	8526                	mv	a0,s1
    80003a58:	6db010ef          	jal	80005932 <release>
    80003a5c:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a5e:	854e                	mv	a0,s3
    80003a60:	60a6                	ld	ra,72(sp)
    80003a62:	6406                	ld	s0,64(sp)
    80003a64:	74e2                	ld	s1,56(sp)
    80003a66:	7942                	ld	s2,48(sp)
    80003a68:	79a2                	ld	s3,40(sp)
    80003a6a:	7a02                	ld	s4,32(sp)
    80003a6c:	6ae2                	ld	s5,24(sp)
    80003a6e:	6161                	addi	sp,sp,80
    80003a70:	8082                	ret

0000000080003a72 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003a72:	1141                	addi	sp,sp,-16
    80003a74:	e422                	sd	s0,8(sp)
    80003a76:	0800                	addi	s0,sp,16
    80003a78:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a7a:	8905                	andi	a0,a0,1
    80003a7c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003a7e:	8b89                	andi	a5,a5,2
    80003a80:	c399                	beqz	a5,80003a86 <flags2perm+0x14>
      perm |= PTE_W;
    80003a82:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a86:	6422                	ld	s0,8(sp)
    80003a88:	0141                	addi	sp,sp,16
    80003a8a:	8082                	ret

0000000080003a8c <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003a8c:	df010113          	addi	sp,sp,-528
    80003a90:	20113423          	sd	ra,520(sp)
    80003a94:	20813023          	sd	s0,512(sp)
    80003a98:	ffa6                	sd	s1,504(sp)
    80003a9a:	fbca                	sd	s2,496(sp)
    80003a9c:	0c00                	addi	s0,sp,528
    80003a9e:	892a                	mv	s2,a0
    80003aa0:	dea43c23          	sd	a0,-520(s0)
    80003aa4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003aa8:	afefd0ef          	jal	80000da6 <myproc>
    80003aac:	84aa                	mv	s1,a0

  begin_op();
    80003aae:	dd4ff0ef          	jal	80003082 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003ab2:	854a                	mv	a0,s2
    80003ab4:	bfaff0ef          	jal	80002eae <namei>
    80003ab8:	c931                	beqz	a0,80003b0c <kexec+0x80>
    80003aba:	f3d2                	sd	s4,480(sp)
    80003abc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003abe:	bdbfe0ef          	jal	80002698 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003ac2:	04000713          	li	a4,64
    80003ac6:	4681                	li	a3,0
    80003ac8:	e5040613          	addi	a2,s0,-432
    80003acc:	4581                	li	a1,0
    80003ace:	8552                	mv	a0,s4
    80003ad0:	f59fe0ef          	jal	80002a28 <readi>
    80003ad4:	04000793          	li	a5,64
    80003ad8:	00f51a63          	bne	a0,a5,80003aec <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003adc:	e5042703          	lw	a4,-432(s0)
    80003ae0:	464c47b7          	lui	a5,0x464c4
    80003ae4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003ae8:	02f70663          	beq	a4,a5,80003b14 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003aec:	8552                	mv	a0,s4
    80003aee:	db5fe0ef          	jal	800028a2 <iunlockput>
    end_op();
    80003af2:	dfaff0ef          	jal	800030ec <end_op>
  }
  return -1;
    80003af6:	557d                	li	a0,-1
    80003af8:	7a1e                	ld	s4,480(sp)
}
    80003afa:	20813083          	ld	ra,520(sp)
    80003afe:	20013403          	ld	s0,512(sp)
    80003b02:	74fe                	ld	s1,504(sp)
    80003b04:	795e                	ld	s2,496(sp)
    80003b06:	21010113          	addi	sp,sp,528
    80003b0a:	8082                	ret
    end_op();
    80003b0c:	de0ff0ef          	jal	800030ec <end_op>
    return -1;
    80003b10:	557d                	li	a0,-1
    80003b12:	b7e5                	j	80003afa <kexec+0x6e>
    80003b14:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b16:	8526                	mv	a0,s1
    80003b18:	b94fd0ef          	jal	80000eac <proc_pagetable>
    80003b1c:	8b2a                	mv	s6,a0
    80003b1e:	2c050b63          	beqz	a0,80003df4 <kexec+0x368>
    80003b22:	f7ce                	sd	s3,488(sp)
    80003b24:	efd6                	sd	s5,472(sp)
    80003b26:	e7de                	sd	s7,456(sp)
    80003b28:	e3e2                	sd	s8,448(sp)
    80003b2a:	ff66                	sd	s9,440(sp)
    80003b2c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b2e:	e7042d03          	lw	s10,-400(s0)
    80003b32:	e8845783          	lhu	a5,-376(s0)
    80003b36:	12078963          	beqz	a5,80003c68 <kexec+0x1dc>
    80003b3a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b3c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b3e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b40:	6c85                	lui	s9,0x1
    80003b42:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b46:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b4a:	6a85                	lui	s5,0x1
    80003b4c:	a085                	j	80003bac <kexec+0x120>
      panic("loadseg: address should exist");
    80003b4e:	00004517          	auipc	a0,0x4
    80003b52:	a0a50513          	addi	a0,a0,-1526 # 80007558 <etext+0x558>
    80003b56:	289010ef          	jal	800055de <panic>
    if(sz - i < PGSIZE)
    80003b5a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b5c:	8726                	mv	a4,s1
    80003b5e:	012c06bb          	addw	a3,s8,s2
    80003b62:	4581                	li	a1,0
    80003b64:	8552                	mv	a0,s4
    80003b66:	ec3fe0ef          	jal	80002a28 <readi>
    80003b6a:	2501                	sext.w	a0,a0
    80003b6c:	24a49a63          	bne	s1,a0,80003dc0 <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003b70:	012a893b          	addw	s2,s5,s2
    80003b74:	03397363          	bgeu	s2,s3,80003b9a <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b78:	02091593          	slli	a1,s2,0x20
    80003b7c:	9181                	srli	a1,a1,0x20
    80003b7e:	95de                	add	a1,a1,s7
    80003b80:	855a                	mv	a0,s6
    80003b82:	8dbfc0ef          	jal	8000045c <walkaddr>
    80003b86:	862a                	mv	a2,a0
    if(pa == 0)
    80003b88:	d179                	beqz	a0,80003b4e <kexec+0xc2>
    if(sz - i < PGSIZE)
    80003b8a:	412984bb          	subw	s1,s3,s2
    80003b8e:	0004879b          	sext.w	a5,s1
    80003b92:	fcfcf4e3          	bgeu	s9,a5,80003b5a <kexec+0xce>
    80003b96:	84d6                	mv	s1,s5
    80003b98:	b7c9                	j	80003b5a <kexec+0xce>
    sz = sz1;
    80003b9a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b9e:	2d85                	addiw	s11,s11,1
    80003ba0:	038d0d1b          	addiw	s10,s10,56
    80003ba4:	e8845783          	lhu	a5,-376(s0)
    80003ba8:	08fdd063          	bge	s11,a5,80003c28 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bac:	2d01                	sext.w	s10,s10
    80003bae:	03800713          	li	a4,56
    80003bb2:	86ea                	mv	a3,s10
    80003bb4:	e1840613          	addi	a2,s0,-488
    80003bb8:	4581                	li	a1,0
    80003bba:	8552                	mv	a0,s4
    80003bbc:	e6dfe0ef          	jal	80002a28 <readi>
    80003bc0:	03800793          	li	a5,56
    80003bc4:	1cf51663          	bne	a0,a5,80003d90 <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003bc8:	e1842783          	lw	a5,-488(s0)
    80003bcc:	4705                	li	a4,1
    80003bce:	fce798e3          	bne	a5,a4,80003b9e <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80003bd2:	e4043483          	ld	s1,-448(s0)
    80003bd6:	e3843783          	ld	a5,-456(s0)
    80003bda:	1af4ef63          	bltu	s1,a5,80003d98 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003bde:	e2843783          	ld	a5,-472(s0)
    80003be2:	94be                	add	s1,s1,a5
    80003be4:	1af4ee63          	bltu	s1,a5,80003da0 <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003be8:	df043703          	ld	a4,-528(s0)
    80003bec:	8ff9                	and	a5,a5,a4
    80003bee:	1a079d63          	bnez	a5,80003da8 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003bf2:	e1c42503          	lw	a0,-484(s0)
    80003bf6:	e7dff0ef          	jal	80003a72 <flags2perm>
    80003bfa:	86aa                	mv	a3,a0
    80003bfc:	8626                	mv	a2,s1
    80003bfe:	85ca                	mv	a1,s2
    80003c00:	855a                	mv	a0,s6
    80003c02:	b4ffc0ef          	jal	80000750 <uvmalloc>
    80003c06:	e0a43423          	sd	a0,-504(s0)
    80003c0a:	1a050363          	beqz	a0,80003db0 <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c0e:	e2843b83          	ld	s7,-472(s0)
    80003c12:	e2042c03          	lw	s8,-480(s0)
    80003c16:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c1a:	00098463          	beqz	s3,80003c22 <kexec+0x196>
    80003c1e:	4901                	li	s2,0
    80003c20:	bfa1                	j	80003b78 <kexec+0xec>
    sz = sz1;
    80003c22:	e0843903          	ld	s2,-504(s0)
    80003c26:	bfa5                	j	80003b9e <kexec+0x112>
    80003c28:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003c2a:	8552                	mv	a0,s4
    80003c2c:	c77fe0ef          	jal	800028a2 <iunlockput>
  end_op();
    80003c30:	cbcff0ef          	jal	800030ec <end_op>
  p = myproc();
    80003c34:	972fd0ef          	jal	80000da6 <myproc>
    80003c38:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c3a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c3e:	6985                	lui	s3,0x1
    80003c40:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c42:	99ca                	add	s3,s3,s2
    80003c44:	77fd                	lui	a5,0xfffff
    80003c46:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c4a:	4691                	li	a3,4
    80003c4c:	6609                	lui	a2,0x2
    80003c4e:	964e                	add	a2,a2,s3
    80003c50:	85ce                	mv	a1,s3
    80003c52:	855a                	mv	a0,s6
    80003c54:	afdfc0ef          	jal	80000750 <uvmalloc>
    80003c58:	892a                	mv	s2,a0
    80003c5a:	e0a43423          	sd	a0,-504(s0)
    80003c5e:	e519                	bnez	a0,80003c6c <kexec+0x1e0>
  if(pagetable)
    80003c60:	e1343423          	sd	s3,-504(s0)
    80003c64:	4a01                	li	s4,0
    80003c66:	aab1                	j	80003dc2 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c68:	4901                	li	s2,0
    80003c6a:	b7c1                	j	80003c2a <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c6c:	75f9                	lui	a1,0xffffe
    80003c6e:	95aa                	add	a1,a1,a0
    80003c70:	855a                	mv	a0,s6
    80003c72:	cb5fc0ef          	jal	80000926 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c76:	7bfd                	lui	s7,0xfffff
    80003c78:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c7a:	e0043783          	ld	a5,-512(s0)
    80003c7e:	6388                	ld	a0,0(a5)
    80003c80:	cd39                	beqz	a0,80003cde <kexec+0x252>
    80003c82:	e9040993          	addi	s3,s0,-368
    80003c86:	f9040c13          	addi	s8,s0,-112
    80003c8a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c8c:	e32fc0ef          	jal	800002be <strlen>
    80003c90:	0015079b          	addiw	a5,a0,1
    80003c94:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c98:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c9c:	11796e63          	bltu	s2,s7,80003db8 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003ca0:	e0043d03          	ld	s10,-512(s0)
    80003ca4:	000d3a03          	ld	s4,0(s10)
    80003ca8:	8552                	mv	a0,s4
    80003caa:	e14fc0ef          	jal	800002be <strlen>
    80003cae:	0015069b          	addiw	a3,a0,1
    80003cb2:	8652                	mv	a2,s4
    80003cb4:	85ca                	mv	a1,s2
    80003cb6:	855a                	mv	a0,s6
    80003cb8:	df3fc0ef          	jal	80000aaa <copyout>
    80003cbc:	10054063          	bltz	a0,80003dbc <kexec+0x330>
    ustack[argc] = sp;
    80003cc0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003cc4:	0485                	addi	s1,s1,1
    80003cc6:	008d0793          	addi	a5,s10,8
    80003cca:	e0f43023          	sd	a5,-512(s0)
    80003cce:	008d3503          	ld	a0,8(s10)
    80003cd2:	c909                	beqz	a0,80003ce4 <kexec+0x258>
    if(argc >= MAXARG)
    80003cd4:	09a1                	addi	s3,s3,8
    80003cd6:	fb899be3          	bne	s3,s8,80003c8c <kexec+0x200>
  ip = 0;
    80003cda:	4a01                	li	s4,0
    80003cdc:	a0dd                	j	80003dc2 <kexec+0x336>
  sp = sz;
    80003cde:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003ce2:	4481                	li	s1,0
  ustack[argc] = 0;
    80003ce4:	00349793          	slli	a5,s1,0x3
    80003ce8:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdbaa8>
    80003cec:	97a2                	add	a5,a5,s0
    80003cee:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003cf2:	00148693          	addi	a3,s1,1
    80003cf6:	068e                	slli	a3,a3,0x3
    80003cf8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003cfc:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d00:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003d04:	f5796ee3          	bltu	s2,s7,80003c60 <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d08:	e9040613          	addi	a2,s0,-368
    80003d0c:	85ca                	mv	a1,s2
    80003d0e:	855a                	mv	a0,s6
    80003d10:	d9bfc0ef          	jal	80000aaa <copyout>
    80003d14:	0e054263          	bltz	a0,80003df8 <kexec+0x36c>
  p->trapframe->a1 = sp;
    80003d18:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d1c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d20:	df843783          	ld	a5,-520(s0)
    80003d24:	0007c703          	lbu	a4,0(a5)
    80003d28:	cf11                	beqz	a4,80003d44 <kexec+0x2b8>
    80003d2a:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d2c:	02f00693          	li	a3,47
    80003d30:	a039                	j	80003d3e <kexec+0x2b2>
      last = s+1;
    80003d32:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d36:	0785                	addi	a5,a5,1
    80003d38:	fff7c703          	lbu	a4,-1(a5)
    80003d3c:	c701                	beqz	a4,80003d44 <kexec+0x2b8>
    if(*s == '/')
    80003d3e:	fed71ce3          	bne	a4,a3,80003d36 <kexec+0x2aa>
    80003d42:	bfc5                	j	80003d32 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d44:	4641                	li	a2,16
    80003d46:	df843583          	ld	a1,-520(s0)
    80003d4a:	158a8513          	addi	a0,s5,344
    80003d4e:	d3efc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003d52:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d56:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d5a:	e0843783          	ld	a5,-504(s0)
    80003d5e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d62:	058ab783          	ld	a5,88(s5)
    80003d66:	e6843703          	ld	a4,-408(s0)
    80003d6a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d6c:	058ab783          	ld	a5,88(s5)
    80003d70:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d74:	85e6                	mv	a1,s9
    80003d76:	9bafd0ef          	jal	80000f30 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d7a:	0004851b          	sext.w	a0,s1
    80003d7e:	79be                	ld	s3,488(sp)
    80003d80:	7a1e                	ld	s4,480(sp)
    80003d82:	6afe                	ld	s5,472(sp)
    80003d84:	6b5e                	ld	s6,464(sp)
    80003d86:	6bbe                	ld	s7,456(sp)
    80003d88:	6c1e                	ld	s8,448(sp)
    80003d8a:	7cfa                	ld	s9,440(sp)
    80003d8c:	7d5a                	ld	s10,432(sp)
    80003d8e:	b3b5                	j	80003afa <kexec+0x6e>
    80003d90:	e1243423          	sd	s2,-504(s0)
    80003d94:	7dba                	ld	s11,424(sp)
    80003d96:	a035                	j	80003dc2 <kexec+0x336>
    80003d98:	e1243423          	sd	s2,-504(s0)
    80003d9c:	7dba                	ld	s11,424(sp)
    80003d9e:	a015                	j	80003dc2 <kexec+0x336>
    80003da0:	e1243423          	sd	s2,-504(s0)
    80003da4:	7dba                	ld	s11,424(sp)
    80003da6:	a831                	j	80003dc2 <kexec+0x336>
    80003da8:	e1243423          	sd	s2,-504(s0)
    80003dac:	7dba                	ld	s11,424(sp)
    80003dae:	a811                	j	80003dc2 <kexec+0x336>
    80003db0:	e1243423          	sd	s2,-504(s0)
    80003db4:	7dba                	ld	s11,424(sp)
    80003db6:	a031                	j	80003dc2 <kexec+0x336>
  ip = 0;
    80003db8:	4a01                	li	s4,0
    80003dba:	a021                	j	80003dc2 <kexec+0x336>
    80003dbc:	4a01                	li	s4,0
  if(pagetable)
    80003dbe:	a011                	j	80003dc2 <kexec+0x336>
    80003dc0:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003dc2:	e0843583          	ld	a1,-504(s0)
    80003dc6:	855a                	mv	a0,s6
    80003dc8:	968fd0ef          	jal	80000f30 <proc_freepagetable>
  return -1;
    80003dcc:	557d                	li	a0,-1
  if(ip){
    80003dce:	000a1b63          	bnez	s4,80003de4 <kexec+0x358>
    80003dd2:	79be                	ld	s3,488(sp)
    80003dd4:	7a1e                	ld	s4,480(sp)
    80003dd6:	6afe                	ld	s5,472(sp)
    80003dd8:	6b5e                	ld	s6,464(sp)
    80003dda:	6bbe                	ld	s7,456(sp)
    80003ddc:	6c1e                	ld	s8,448(sp)
    80003dde:	7cfa                	ld	s9,440(sp)
    80003de0:	7d5a                	ld	s10,432(sp)
    80003de2:	bb21                	j	80003afa <kexec+0x6e>
    80003de4:	79be                	ld	s3,488(sp)
    80003de6:	6afe                	ld	s5,472(sp)
    80003de8:	6b5e                	ld	s6,464(sp)
    80003dea:	6bbe                	ld	s7,456(sp)
    80003dec:	6c1e                	ld	s8,448(sp)
    80003dee:	7cfa                	ld	s9,440(sp)
    80003df0:	7d5a                	ld	s10,432(sp)
    80003df2:	b9ed                	j	80003aec <kexec+0x60>
    80003df4:	6b5e                	ld	s6,464(sp)
    80003df6:	b9dd                	j	80003aec <kexec+0x60>
  sz = sz1;
    80003df8:	e0843983          	ld	s3,-504(s0)
    80003dfc:	b595                	j	80003c60 <kexec+0x1d4>

0000000080003dfe <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003dfe:	7179                	addi	sp,sp,-48
    80003e00:	f406                	sd	ra,40(sp)
    80003e02:	f022                	sd	s0,32(sp)
    80003e04:	ec26                	sd	s1,24(sp)
    80003e06:	e84a                	sd	s2,16(sp)
    80003e08:	1800                	addi	s0,sp,48
    80003e0a:	892e                	mv	s2,a1
    80003e0c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e0e:	fdc40593          	addi	a1,s0,-36
    80003e12:	e91fd0ef          	jal	80001ca2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e16:	fdc42703          	lw	a4,-36(s0)
    80003e1a:	47bd                	li	a5,15
    80003e1c:	02e7e963          	bltu	a5,a4,80003e4e <argfd+0x50>
    80003e20:	f87fc0ef          	jal	80000da6 <myproc>
    80003e24:	fdc42703          	lw	a4,-36(s0)
    80003e28:	01a70793          	addi	a5,a4,26
    80003e2c:	078e                	slli	a5,a5,0x3
    80003e2e:	953e                	add	a0,a0,a5
    80003e30:	611c                	ld	a5,0(a0)
    80003e32:	c385                	beqz	a5,80003e52 <argfd+0x54>
    return -1;
  if(pfd)
    80003e34:	00090463          	beqz	s2,80003e3c <argfd+0x3e>
    *pfd = fd;
    80003e38:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e3c:	4501                	li	a0,0
  if(pf)
    80003e3e:	c091                	beqz	s1,80003e42 <argfd+0x44>
    *pf = f;
    80003e40:	e09c                	sd	a5,0(s1)
}
    80003e42:	70a2                	ld	ra,40(sp)
    80003e44:	7402                	ld	s0,32(sp)
    80003e46:	64e2                	ld	s1,24(sp)
    80003e48:	6942                	ld	s2,16(sp)
    80003e4a:	6145                	addi	sp,sp,48
    80003e4c:	8082                	ret
    return -1;
    80003e4e:	557d                	li	a0,-1
    80003e50:	bfcd                	j	80003e42 <argfd+0x44>
    80003e52:	557d                	li	a0,-1
    80003e54:	b7fd                	j	80003e42 <argfd+0x44>

0000000080003e56 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e56:	1101                	addi	sp,sp,-32
    80003e58:	ec06                	sd	ra,24(sp)
    80003e5a:	e822                	sd	s0,16(sp)
    80003e5c:	e426                	sd	s1,8(sp)
    80003e5e:	1000                	addi	s0,sp,32
    80003e60:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e62:	f45fc0ef          	jal	80000da6 <myproc>
    80003e66:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e68:	0d050793          	addi	a5,a0,208
    80003e6c:	4501                	li	a0,0
    80003e6e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e70:	6398                	ld	a4,0(a5)
    80003e72:	cb19                	beqz	a4,80003e88 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e74:	2505                	addiw	a0,a0,1
    80003e76:	07a1                	addi	a5,a5,8
    80003e78:	fed51ce3          	bne	a0,a3,80003e70 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e7c:	557d                	li	a0,-1
}
    80003e7e:	60e2                	ld	ra,24(sp)
    80003e80:	6442                	ld	s0,16(sp)
    80003e82:	64a2                	ld	s1,8(sp)
    80003e84:	6105                	addi	sp,sp,32
    80003e86:	8082                	ret
      p->ofile[fd] = f;
    80003e88:	01a50793          	addi	a5,a0,26
    80003e8c:	078e                	slli	a5,a5,0x3
    80003e8e:	963e                	add	a2,a2,a5
    80003e90:	e204                	sd	s1,0(a2)
      return fd;
    80003e92:	b7f5                	j	80003e7e <fdalloc+0x28>

0000000080003e94 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e94:	715d                	addi	sp,sp,-80
    80003e96:	e486                	sd	ra,72(sp)
    80003e98:	e0a2                	sd	s0,64(sp)
    80003e9a:	fc26                	sd	s1,56(sp)
    80003e9c:	f84a                	sd	s2,48(sp)
    80003e9e:	f44e                	sd	s3,40(sp)
    80003ea0:	ec56                	sd	s5,24(sp)
    80003ea2:	e85a                	sd	s6,16(sp)
    80003ea4:	0880                	addi	s0,sp,80
    80003ea6:	8b2e                	mv	s6,a1
    80003ea8:	89b2                	mv	s3,a2
    80003eaa:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003eac:	fb040593          	addi	a1,s0,-80
    80003eb0:	818ff0ef          	jal	80002ec8 <nameiparent>
    80003eb4:	84aa                	mv	s1,a0
    80003eb6:	10050a63          	beqz	a0,80003fca <create+0x136>
    return 0;

  ilock(dp);
    80003eba:	fdefe0ef          	jal	80002698 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ebe:	4601                	li	a2,0
    80003ec0:	fb040593          	addi	a1,s0,-80
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	d83fe0ef          	jal	80002c48 <dirlookup>
    80003eca:	8aaa                	mv	s5,a0
    80003ecc:	c129                	beqz	a0,80003f0e <create+0x7a>
    iunlockput(dp);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	9d3fe0ef          	jal	800028a2 <iunlockput>
    ilock(ip);
    80003ed4:	8556                	mv	a0,s5
    80003ed6:	fc2fe0ef          	jal	80002698 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003eda:	4789                	li	a5,2
    80003edc:	02fb1463          	bne	s6,a5,80003f04 <create+0x70>
    80003ee0:	044ad783          	lhu	a5,68(s5)
    80003ee4:	37f9                	addiw	a5,a5,-2
    80003ee6:	17c2                	slli	a5,a5,0x30
    80003ee8:	93c1                	srli	a5,a5,0x30
    80003eea:	4705                	li	a4,1
    80003eec:	00f76c63          	bltu	a4,a5,80003f04 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003ef0:	8556                	mv	a0,s5
    80003ef2:	60a6                	ld	ra,72(sp)
    80003ef4:	6406                	ld	s0,64(sp)
    80003ef6:	74e2                	ld	s1,56(sp)
    80003ef8:	7942                	ld	s2,48(sp)
    80003efa:	79a2                	ld	s3,40(sp)
    80003efc:	6ae2                	ld	s5,24(sp)
    80003efe:	6b42                	ld	s6,16(sp)
    80003f00:	6161                	addi	sp,sp,80
    80003f02:	8082                	ret
    iunlockput(ip);
    80003f04:	8556                	mv	a0,s5
    80003f06:	99dfe0ef          	jal	800028a2 <iunlockput>
    return 0;
    80003f0a:	4a81                	li	s5,0
    80003f0c:	b7d5                	j	80003ef0 <create+0x5c>
    80003f0e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f10:	85da                	mv	a1,s6
    80003f12:	4088                	lw	a0,0(s1)
    80003f14:	e14fe0ef          	jal	80002528 <ialloc>
    80003f18:	8a2a                	mv	s4,a0
    80003f1a:	cd15                	beqz	a0,80003f56 <create+0xc2>
  ilock(ip);
    80003f1c:	f7cfe0ef          	jal	80002698 <ilock>
  ip->major = major;
    80003f20:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f24:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f28:	4905                	li	s2,1
    80003f2a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f2e:	8552                	mv	a0,s4
    80003f30:	eb4fe0ef          	jal	800025e4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f34:	032b0763          	beq	s6,s2,80003f62 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f38:	004a2603          	lw	a2,4(s4)
    80003f3c:	fb040593          	addi	a1,s0,-80
    80003f40:	8526                	mv	a0,s1
    80003f42:	ed3fe0ef          	jal	80002e14 <dirlink>
    80003f46:	06054563          	bltz	a0,80003fb0 <create+0x11c>
  iunlockput(dp);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	957fe0ef          	jal	800028a2 <iunlockput>
  return ip;
    80003f50:	8ad2                	mv	s5,s4
    80003f52:	7a02                	ld	s4,32(sp)
    80003f54:	bf71                	j	80003ef0 <create+0x5c>
    iunlockput(dp);
    80003f56:	8526                	mv	a0,s1
    80003f58:	94bfe0ef          	jal	800028a2 <iunlockput>
    return 0;
    80003f5c:	8ad2                	mv	s5,s4
    80003f5e:	7a02                	ld	s4,32(sp)
    80003f60:	bf41                	j	80003ef0 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f62:	004a2603          	lw	a2,4(s4)
    80003f66:	00003597          	auipc	a1,0x3
    80003f6a:	61258593          	addi	a1,a1,1554 # 80007578 <etext+0x578>
    80003f6e:	8552                	mv	a0,s4
    80003f70:	ea5fe0ef          	jal	80002e14 <dirlink>
    80003f74:	02054e63          	bltz	a0,80003fb0 <create+0x11c>
    80003f78:	40d0                	lw	a2,4(s1)
    80003f7a:	00003597          	auipc	a1,0x3
    80003f7e:	60658593          	addi	a1,a1,1542 # 80007580 <etext+0x580>
    80003f82:	8552                	mv	a0,s4
    80003f84:	e91fe0ef          	jal	80002e14 <dirlink>
    80003f88:	02054463          	bltz	a0,80003fb0 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f8c:	004a2603          	lw	a2,4(s4)
    80003f90:	fb040593          	addi	a1,s0,-80
    80003f94:	8526                	mv	a0,s1
    80003f96:	e7ffe0ef          	jal	80002e14 <dirlink>
    80003f9a:	00054b63          	bltz	a0,80003fb0 <create+0x11c>
    dp->nlink++;  // for ".."
    80003f9e:	04a4d783          	lhu	a5,74(s1)
    80003fa2:	2785                	addiw	a5,a5,1
    80003fa4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fa8:	8526                	mv	a0,s1
    80003faa:	e3afe0ef          	jal	800025e4 <iupdate>
    80003fae:	bf71                	j	80003f4a <create+0xb6>
  ip->nlink = 0;
    80003fb0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003fb4:	8552                	mv	a0,s4
    80003fb6:	e2efe0ef          	jal	800025e4 <iupdate>
  iunlockput(ip);
    80003fba:	8552                	mv	a0,s4
    80003fbc:	8e7fe0ef          	jal	800028a2 <iunlockput>
  iunlockput(dp);
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	8e1fe0ef          	jal	800028a2 <iunlockput>
  return 0;
    80003fc6:	7a02                	ld	s4,32(sp)
    80003fc8:	b725                	j	80003ef0 <create+0x5c>
    return 0;
    80003fca:	8aaa                	mv	s5,a0
    80003fcc:	b715                	j	80003ef0 <create+0x5c>

0000000080003fce <sys_dup>:
{
    80003fce:	7179                	addi	sp,sp,-48
    80003fd0:	f406                	sd	ra,40(sp)
    80003fd2:	f022                	sd	s0,32(sp)
    80003fd4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003fd6:	fd840613          	addi	a2,s0,-40
    80003fda:	4581                	li	a1,0
    80003fdc:	4501                	li	a0,0
    80003fde:	e21ff0ef          	jal	80003dfe <argfd>
    return -1;
    80003fe2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003fe4:	02054363          	bltz	a0,8000400a <sys_dup+0x3c>
    80003fe8:	ec26                	sd	s1,24(sp)
    80003fea:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003fec:	fd843903          	ld	s2,-40(s0)
    80003ff0:	854a                	mv	a0,s2
    80003ff2:	e65ff0ef          	jal	80003e56 <fdalloc>
    80003ff6:	84aa                	mv	s1,a0
    return -1;
    80003ff8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003ffa:	00054d63          	bltz	a0,80004014 <sys_dup+0x46>
  filedup(f);
    80003ffe:	854a                	mv	a0,s2
    80004000:	c48ff0ef          	jal	80003448 <filedup>
  return fd;
    80004004:	87a6                	mv	a5,s1
    80004006:	64e2                	ld	s1,24(sp)
    80004008:	6942                	ld	s2,16(sp)
}
    8000400a:	853e                	mv	a0,a5
    8000400c:	70a2                	ld	ra,40(sp)
    8000400e:	7402                	ld	s0,32(sp)
    80004010:	6145                	addi	sp,sp,48
    80004012:	8082                	ret
    80004014:	64e2                	ld	s1,24(sp)
    80004016:	6942                	ld	s2,16(sp)
    80004018:	bfcd                	j	8000400a <sys_dup+0x3c>

000000008000401a <sys_read>:
{
    8000401a:	7179                	addi	sp,sp,-48
    8000401c:	f406                	sd	ra,40(sp)
    8000401e:	f022                	sd	s0,32(sp)
    80004020:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004022:	fd840593          	addi	a1,s0,-40
    80004026:	4505                	li	a0,1
    80004028:	c97fd0ef          	jal	80001cbe <argaddr>
  argint(2, &n);
    8000402c:	fe440593          	addi	a1,s0,-28
    80004030:	4509                	li	a0,2
    80004032:	c71fd0ef          	jal	80001ca2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004036:	fe840613          	addi	a2,s0,-24
    8000403a:	4581                	li	a1,0
    8000403c:	4501                	li	a0,0
    8000403e:	dc1ff0ef          	jal	80003dfe <argfd>
    80004042:	87aa                	mv	a5,a0
    return -1;
    80004044:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004046:	0007ca63          	bltz	a5,8000405a <sys_read+0x40>
  return fileread(f, p, n);
    8000404a:	fe442603          	lw	a2,-28(s0)
    8000404e:	fd843583          	ld	a1,-40(s0)
    80004052:	fe843503          	ld	a0,-24(s0)
    80004056:	d58ff0ef          	jal	800035ae <fileread>
}
    8000405a:	70a2                	ld	ra,40(sp)
    8000405c:	7402                	ld	s0,32(sp)
    8000405e:	6145                	addi	sp,sp,48
    80004060:	8082                	ret

0000000080004062 <sys_write>:
{
    80004062:	7179                	addi	sp,sp,-48
    80004064:	f406                	sd	ra,40(sp)
    80004066:	f022                	sd	s0,32(sp)
    80004068:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000406a:	fd840593          	addi	a1,s0,-40
    8000406e:	4505                	li	a0,1
    80004070:	c4ffd0ef          	jal	80001cbe <argaddr>
  argint(2, &n);
    80004074:	fe440593          	addi	a1,s0,-28
    80004078:	4509                	li	a0,2
    8000407a:	c29fd0ef          	jal	80001ca2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000407e:	fe840613          	addi	a2,s0,-24
    80004082:	4581                	li	a1,0
    80004084:	4501                	li	a0,0
    80004086:	d79ff0ef          	jal	80003dfe <argfd>
    8000408a:	87aa                	mv	a5,a0
    return -1;
    8000408c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000408e:	0007ca63          	bltz	a5,800040a2 <sys_write+0x40>
  return filewrite(f, p, n);
    80004092:	fe442603          	lw	a2,-28(s0)
    80004096:	fd843583          	ld	a1,-40(s0)
    8000409a:	fe843503          	ld	a0,-24(s0)
    8000409e:	dceff0ef          	jal	8000366c <filewrite>
}
    800040a2:	70a2                	ld	ra,40(sp)
    800040a4:	7402                	ld	s0,32(sp)
    800040a6:	6145                	addi	sp,sp,48
    800040a8:	8082                	ret

00000000800040aa <sys_close>:
{
    800040aa:	1101                	addi	sp,sp,-32
    800040ac:	ec06                	sd	ra,24(sp)
    800040ae:	e822                	sd	s0,16(sp)
    800040b0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800040b2:	fe040613          	addi	a2,s0,-32
    800040b6:	fec40593          	addi	a1,s0,-20
    800040ba:	4501                	li	a0,0
    800040bc:	d43ff0ef          	jal	80003dfe <argfd>
    return -1;
    800040c0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800040c2:	02054063          	bltz	a0,800040e2 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800040c6:	ce1fc0ef          	jal	80000da6 <myproc>
    800040ca:	fec42783          	lw	a5,-20(s0)
    800040ce:	07e9                	addi	a5,a5,26
    800040d0:	078e                	slli	a5,a5,0x3
    800040d2:	953e                	add	a0,a0,a5
    800040d4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800040d8:	fe043503          	ld	a0,-32(s0)
    800040dc:	bb2ff0ef          	jal	8000348e <fileclose>
  return 0;
    800040e0:	4781                	li	a5,0
}
    800040e2:	853e                	mv	a0,a5
    800040e4:	60e2                	ld	ra,24(sp)
    800040e6:	6442                	ld	s0,16(sp)
    800040e8:	6105                	addi	sp,sp,32
    800040ea:	8082                	ret

00000000800040ec <sys_fstat>:
{
    800040ec:	1101                	addi	sp,sp,-32
    800040ee:	ec06                	sd	ra,24(sp)
    800040f0:	e822                	sd	s0,16(sp)
    800040f2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800040f4:	fe040593          	addi	a1,s0,-32
    800040f8:	4505                	li	a0,1
    800040fa:	bc5fd0ef          	jal	80001cbe <argaddr>
  if(argfd(0, 0, &f) < 0)
    800040fe:	fe840613          	addi	a2,s0,-24
    80004102:	4581                	li	a1,0
    80004104:	4501                	li	a0,0
    80004106:	cf9ff0ef          	jal	80003dfe <argfd>
    8000410a:	87aa                	mv	a5,a0
    return -1;
    8000410c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000410e:	0007c863          	bltz	a5,8000411e <sys_fstat+0x32>
  return filestat(f, st);
    80004112:	fe043583          	ld	a1,-32(s0)
    80004116:	fe843503          	ld	a0,-24(s0)
    8000411a:	c36ff0ef          	jal	80003550 <filestat>
}
    8000411e:	60e2                	ld	ra,24(sp)
    80004120:	6442                	ld	s0,16(sp)
    80004122:	6105                	addi	sp,sp,32
    80004124:	8082                	ret

0000000080004126 <sys_link>:
{
    80004126:	7169                	addi	sp,sp,-304
    80004128:	f606                	sd	ra,296(sp)
    8000412a:	f222                	sd	s0,288(sp)
    8000412c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000412e:	08000613          	li	a2,128
    80004132:	ed040593          	addi	a1,s0,-304
    80004136:	4501                	li	a0,0
    80004138:	ba3fd0ef          	jal	80001cda <argstr>
    return -1;
    8000413c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000413e:	0c054e63          	bltz	a0,8000421a <sys_link+0xf4>
    80004142:	08000613          	li	a2,128
    80004146:	f5040593          	addi	a1,s0,-176
    8000414a:	4505                	li	a0,1
    8000414c:	b8ffd0ef          	jal	80001cda <argstr>
    return -1;
    80004150:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004152:	0c054463          	bltz	a0,8000421a <sys_link+0xf4>
    80004156:	ee26                	sd	s1,280(sp)
  begin_op();
    80004158:	f2bfe0ef          	jal	80003082 <begin_op>
  if((ip = namei(old)) == 0){
    8000415c:	ed040513          	addi	a0,s0,-304
    80004160:	d4ffe0ef          	jal	80002eae <namei>
    80004164:	84aa                	mv	s1,a0
    80004166:	c53d                	beqz	a0,800041d4 <sys_link+0xae>
  ilock(ip);
    80004168:	d30fe0ef          	jal	80002698 <ilock>
  if(ip->type == T_DIR){
    8000416c:	04449703          	lh	a4,68(s1)
    80004170:	4785                	li	a5,1
    80004172:	06f70663          	beq	a4,a5,800041de <sys_link+0xb8>
    80004176:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004178:	04a4d783          	lhu	a5,74(s1)
    8000417c:	2785                	addiw	a5,a5,1
    8000417e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004182:	8526                	mv	a0,s1
    80004184:	c60fe0ef          	jal	800025e4 <iupdate>
  iunlock(ip);
    80004188:	8526                	mv	a0,s1
    8000418a:	dbcfe0ef          	jal	80002746 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000418e:	fd040593          	addi	a1,s0,-48
    80004192:	f5040513          	addi	a0,s0,-176
    80004196:	d33fe0ef          	jal	80002ec8 <nameiparent>
    8000419a:	892a                	mv	s2,a0
    8000419c:	cd21                	beqz	a0,800041f4 <sys_link+0xce>
  ilock(dp);
    8000419e:	cfafe0ef          	jal	80002698 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041a2:	00092703          	lw	a4,0(s2)
    800041a6:	409c                	lw	a5,0(s1)
    800041a8:	04f71363          	bne	a4,a5,800041ee <sys_link+0xc8>
    800041ac:	40d0                	lw	a2,4(s1)
    800041ae:	fd040593          	addi	a1,s0,-48
    800041b2:	854a                	mv	a0,s2
    800041b4:	c61fe0ef          	jal	80002e14 <dirlink>
    800041b8:	02054b63          	bltz	a0,800041ee <sys_link+0xc8>
  iunlockput(dp);
    800041bc:	854a                	mv	a0,s2
    800041be:	ee4fe0ef          	jal	800028a2 <iunlockput>
  iput(ip);
    800041c2:	8526                	mv	a0,s1
    800041c4:	e56fe0ef          	jal	8000281a <iput>
  end_op();
    800041c8:	f25fe0ef          	jal	800030ec <end_op>
  return 0;
    800041cc:	4781                	li	a5,0
    800041ce:	64f2                	ld	s1,280(sp)
    800041d0:	6952                	ld	s2,272(sp)
    800041d2:	a0a1                	j	8000421a <sys_link+0xf4>
    end_op();
    800041d4:	f19fe0ef          	jal	800030ec <end_op>
    return -1;
    800041d8:	57fd                	li	a5,-1
    800041da:	64f2                	ld	s1,280(sp)
    800041dc:	a83d                	j	8000421a <sys_link+0xf4>
    iunlockput(ip);
    800041de:	8526                	mv	a0,s1
    800041e0:	ec2fe0ef          	jal	800028a2 <iunlockput>
    end_op();
    800041e4:	f09fe0ef          	jal	800030ec <end_op>
    return -1;
    800041e8:	57fd                	li	a5,-1
    800041ea:	64f2                	ld	s1,280(sp)
    800041ec:	a03d                	j	8000421a <sys_link+0xf4>
    iunlockput(dp);
    800041ee:	854a                	mv	a0,s2
    800041f0:	eb2fe0ef          	jal	800028a2 <iunlockput>
  ilock(ip);
    800041f4:	8526                	mv	a0,s1
    800041f6:	ca2fe0ef          	jal	80002698 <ilock>
  ip->nlink--;
    800041fa:	04a4d783          	lhu	a5,74(s1)
    800041fe:	37fd                	addiw	a5,a5,-1
    80004200:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004204:	8526                	mv	a0,s1
    80004206:	bdefe0ef          	jal	800025e4 <iupdate>
  iunlockput(ip);
    8000420a:	8526                	mv	a0,s1
    8000420c:	e96fe0ef          	jal	800028a2 <iunlockput>
  end_op();
    80004210:	eddfe0ef          	jal	800030ec <end_op>
  return -1;
    80004214:	57fd                	li	a5,-1
    80004216:	64f2                	ld	s1,280(sp)
    80004218:	6952                	ld	s2,272(sp)
}
    8000421a:	853e                	mv	a0,a5
    8000421c:	70b2                	ld	ra,296(sp)
    8000421e:	7412                	ld	s0,288(sp)
    80004220:	6155                	addi	sp,sp,304
    80004222:	8082                	ret

0000000080004224 <sys_unlink>:
{
    80004224:	7151                	addi	sp,sp,-240
    80004226:	f586                	sd	ra,232(sp)
    80004228:	f1a2                	sd	s0,224(sp)
    8000422a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000422c:	08000613          	li	a2,128
    80004230:	f3040593          	addi	a1,s0,-208
    80004234:	4501                	li	a0,0
    80004236:	aa5fd0ef          	jal	80001cda <argstr>
    8000423a:	16054063          	bltz	a0,8000439a <sys_unlink+0x176>
    8000423e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004240:	e43fe0ef          	jal	80003082 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004244:	fb040593          	addi	a1,s0,-80
    80004248:	f3040513          	addi	a0,s0,-208
    8000424c:	c7dfe0ef          	jal	80002ec8 <nameiparent>
    80004250:	84aa                	mv	s1,a0
    80004252:	c945                	beqz	a0,80004302 <sys_unlink+0xde>
  ilock(dp);
    80004254:	c44fe0ef          	jal	80002698 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004258:	00003597          	auipc	a1,0x3
    8000425c:	32058593          	addi	a1,a1,800 # 80007578 <etext+0x578>
    80004260:	fb040513          	addi	a0,s0,-80
    80004264:	9cffe0ef          	jal	80002c32 <namecmp>
    80004268:	10050e63          	beqz	a0,80004384 <sys_unlink+0x160>
    8000426c:	00003597          	auipc	a1,0x3
    80004270:	31458593          	addi	a1,a1,788 # 80007580 <etext+0x580>
    80004274:	fb040513          	addi	a0,s0,-80
    80004278:	9bbfe0ef          	jal	80002c32 <namecmp>
    8000427c:	10050463          	beqz	a0,80004384 <sys_unlink+0x160>
    80004280:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004282:	f2c40613          	addi	a2,s0,-212
    80004286:	fb040593          	addi	a1,s0,-80
    8000428a:	8526                	mv	a0,s1
    8000428c:	9bdfe0ef          	jal	80002c48 <dirlookup>
    80004290:	892a                	mv	s2,a0
    80004292:	0e050863          	beqz	a0,80004382 <sys_unlink+0x15e>
  ilock(ip);
    80004296:	c02fe0ef          	jal	80002698 <ilock>
  if(ip->nlink < 1)
    8000429a:	04a91783          	lh	a5,74(s2)
    8000429e:	06f05763          	blez	a5,8000430c <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042a2:	04491703          	lh	a4,68(s2)
    800042a6:	4785                	li	a5,1
    800042a8:	06f70963          	beq	a4,a5,8000431a <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800042ac:	4641                	li	a2,16
    800042ae:	4581                	li	a1,0
    800042b0:	fc040513          	addi	a0,s0,-64
    800042b4:	e9bfb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042b8:	4741                	li	a4,16
    800042ba:	f2c42683          	lw	a3,-212(s0)
    800042be:	fc040613          	addi	a2,s0,-64
    800042c2:	4581                	li	a1,0
    800042c4:	8526                	mv	a0,s1
    800042c6:	85ffe0ef          	jal	80002b24 <writei>
    800042ca:	47c1                	li	a5,16
    800042cc:	08f51b63          	bne	a0,a5,80004362 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800042d0:	04491703          	lh	a4,68(s2)
    800042d4:	4785                	li	a5,1
    800042d6:	08f70d63          	beq	a4,a5,80004370 <sys_unlink+0x14c>
  iunlockput(dp);
    800042da:	8526                	mv	a0,s1
    800042dc:	dc6fe0ef          	jal	800028a2 <iunlockput>
  ip->nlink--;
    800042e0:	04a95783          	lhu	a5,74(s2)
    800042e4:	37fd                	addiw	a5,a5,-1
    800042e6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800042ea:	854a                	mv	a0,s2
    800042ec:	af8fe0ef          	jal	800025e4 <iupdate>
  iunlockput(ip);
    800042f0:	854a                	mv	a0,s2
    800042f2:	db0fe0ef          	jal	800028a2 <iunlockput>
  end_op();
    800042f6:	df7fe0ef          	jal	800030ec <end_op>
  return 0;
    800042fa:	4501                	li	a0,0
    800042fc:	64ee                	ld	s1,216(sp)
    800042fe:	694e                	ld	s2,208(sp)
    80004300:	a849                	j	80004392 <sys_unlink+0x16e>
    end_op();
    80004302:	debfe0ef          	jal	800030ec <end_op>
    return -1;
    80004306:	557d                	li	a0,-1
    80004308:	64ee                	ld	s1,216(sp)
    8000430a:	a061                	j	80004392 <sys_unlink+0x16e>
    8000430c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000430e:	00003517          	auipc	a0,0x3
    80004312:	27a50513          	addi	a0,a0,634 # 80007588 <etext+0x588>
    80004316:	2c8010ef          	jal	800055de <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000431a:	04c92703          	lw	a4,76(s2)
    8000431e:	02000793          	li	a5,32
    80004322:	f8e7f5e3          	bgeu	a5,a4,800042ac <sys_unlink+0x88>
    80004326:	e5ce                	sd	s3,200(sp)
    80004328:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000432c:	4741                	li	a4,16
    8000432e:	86ce                	mv	a3,s3
    80004330:	f1840613          	addi	a2,s0,-232
    80004334:	4581                	li	a1,0
    80004336:	854a                	mv	a0,s2
    80004338:	ef0fe0ef          	jal	80002a28 <readi>
    8000433c:	47c1                	li	a5,16
    8000433e:	00f51c63          	bne	a0,a5,80004356 <sys_unlink+0x132>
    if(de.inum != 0)
    80004342:	f1845783          	lhu	a5,-232(s0)
    80004346:	efa1                	bnez	a5,8000439e <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004348:	29c1                	addiw	s3,s3,16
    8000434a:	04c92783          	lw	a5,76(s2)
    8000434e:	fcf9efe3          	bltu	s3,a5,8000432c <sys_unlink+0x108>
    80004352:	69ae                	ld	s3,200(sp)
    80004354:	bfa1                	j	800042ac <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004356:	00003517          	auipc	a0,0x3
    8000435a:	24a50513          	addi	a0,a0,586 # 800075a0 <etext+0x5a0>
    8000435e:	280010ef          	jal	800055de <panic>
    80004362:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004364:	00003517          	auipc	a0,0x3
    80004368:	25450513          	addi	a0,a0,596 # 800075b8 <etext+0x5b8>
    8000436c:	272010ef          	jal	800055de <panic>
    dp->nlink--;
    80004370:	04a4d783          	lhu	a5,74(s1)
    80004374:	37fd                	addiw	a5,a5,-1
    80004376:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000437a:	8526                	mv	a0,s1
    8000437c:	a68fe0ef          	jal	800025e4 <iupdate>
    80004380:	bfa9                	j	800042da <sys_unlink+0xb6>
    80004382:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004384:	8526                	mv	a0,s1
    80004386:	d1cfe0ef          	jal	800028a2 <iunlockput>
  end_op();
    8000438a:	d63fe0ef          	jal	800030ec <end_op>
  return -1;
    8000438e:	557d                	li	a0,-1
    80004390:	64ee                	ld	s1,216(sp)
}
    80004392:	70ae                	ld	ra,232(sp)
    80004394:	740e                	ld	s0,224(sp)
    80004396:	616d                	addi	sp,sp,240
    80004398:	8082                	ret
    return -1;
    8000439a:	557d                	li	a0,-1
    8000439c:	bfdd                	j	80004392 <sys_unlink+0x16e>
    iunlockput(ip);
    8000439e:	854a                	mv	a0,s2
    800043a0:	d02fe0ef          	jal	800028a2 <iunlockput>
    goto bad;
    800043a4:	694e                	ld	s2,208(sp)
    800043a6:	69ae                	ld	s3,200(sp)
    800043a8:	bff1                	j	80004384 <sys_unlink+0x160>

00000000800043aa <sys_open>:

uint64
sys_open(void)
{
    800043aa:	7131                	addi	sp,sp,-192
    800043ac:	fd06                	sd	ra,184(sp)
    800043ae:	f922                	sd	s0,176(sp)
    800043b0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043b2:	f4c40593          	addi	a1,s0,-180
    800043b6:	4505                	li	a0,1
    800043b8:	8ebfd0ef          	jal	80001ca2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043bc:	08000613          	li	a2,128
    800043c0:	f5040593          	addi	a1,s0,-176
    800043c4:	4501                	li	a0,0
    800043c6:	915fd0ef          	jal	80001cda <argstr>
    800043ca:	87aa                	mv	a5,a0
    return -1;
    800043cc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043ce:	0a07c263          	bltz	a5,80004472 <sys_open+0xc8>
    800043d2:	f526                	sd	s1,168(sp)

  begin_op();
    800043d4:	caffe0ef          	jal	80003082 <begin_op>

  if(omode & O_CREATE){
    800043d8:	f4c42783          	lw	a5,-180(s0)
    800043dc:	2007f793          	andi	a5,a5,512
    800043e0:	c3d5                	beqz	a5,80004484 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800043e2:	4681                	li	a3,0
    800043e4:	4601                	li	a2,0
    800043e6:	4589                	li	a1,2
    800043e8:	f5040513          	addi	a0,s0,-176
    800043ec:	aa9ff0ef          	jal	80003e94 <create>
    800043f0:	84aa                	mv	s1,a0
    if(ip == 0){
    800043f2:	c541                	beqz	a0,8000447a <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800043f4:	04449703          	lh	a4,68(s1)
    800043f8:	478d                	li	a5,3
    800043fa:	00f71763          	bne	a4,a5,80004408 <sys_open+0x5e>
    800043fe:	0464d703          	lhu	a4,70(s1)
    80004402:	47a5                	li	a5,9
    80004404:	0ae7ed63          	bltu	a5,a4,800044be <sys_open+0x114>
    80004408:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000440a:	fe1fe0ef          	jal	800033ea <filealloc>
    8000440e:	892a                	mv	s2,a0
    80004410:	c179                	beqz	a0,800044d6 <sys_open+0x12c>
    80004412:	ed4e                	sd	s3,152(sp)
    80004414:	a43ff0ef          	jal	80003e56 <fdalloc>
    80004418:	89aa                	mv	s3,a0
    8000441a:	0a054a63          	bltz	a0,800044ce <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000441e:	04449703          	lh	a4,68(s1)
    80004422:	478d                	li	a5,3
    80004424:	0cf70263          	beq	a4,a5,800044e8 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004428:	4789                	li	a5,2
    8000442a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000442e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004432:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004436:	f4c42783          	lw	a5,-180(s0)
    8000443a:	0017c713          	xori	a4,a5,1
    8000443e:	8b05                	andi	a4,a4,1
    80004440:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004444:	0037f713          	andi	a4,a5,3
    80004448:	00e03733          	snez	a4,a4
    8000444c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004450:	4007f793          	andi	a5,a5,1024
    80004454:	c791                	beqz	a5,80004460 <sys_open+0xb6>
    80004456:	04449703          	lh	a4,68(s1)
    8000445a:	4789                	li	a5,2
    8000445c:	08f70d63          	beq	a4,a5,800044f6 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004460:	8526                	mv	a0,s1
    80004462:	ae4fe0ef          	jal	80002746 <iunlock>
  end_op();
    80004466:	c87fe0ef          	jal	800030ec <end_op>

  return fd;
    8000446a:	854e                	mv	a0,s3
    8000446c:	74aa                	ld	s1,168(sp)
    8000446e:	790a                	ld	s2,160(sp)
    80004470:	69ea                	ld	s3,152(sp)
}
    80004472:	70ea                	ld	ra,184(sp)
    80004474:	744a                	ld	s0,176(sp)
    80004476:	6129                	addi	sp,sp,192
    80004478:	8082                	ret
      end_op();
    8000447a:	c73fe0ef          	jal	800030ec <end_op>
      return -1;
    8000447e:	557d                	li	a0,-1
    80004480:	74aa                	ld	s1,168(sp)
    80004482:	bfc5                	j	80004472 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004484:	f5040513          	addi	a0,s0,-176
    80004488:	a27fe0ef          	jal	80002eae <namei>
    8000448c:	84aa                	mv	s1,a0
    8000448e:	c11d                	beqz	a0,800044b4 <sys_open+0x10a>
    ilock(ip);
    80004490:	a08fe0ef          	jal	80002698 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004494:	04449703          	lh	a4,68(s1)
    80004498:	4785                	li	a5,1
    8000449a:	f4f71de3          	bne	a4,a5,800043f4 <sys_open+0x4a>
    8000449e:	f4c42783          	lw	a5,-180(s0)
    800044a2:	d3bd                	beqz	a5,80004408 <sys_open+0x5e>
      iunlockput(ip);
    800044a4:	8526                	mv	a0,s1
    800044a6:	bfcfe0ef          	jal	800028a2 <iunlockput>
      end_op();
    800044aa:	c43fe0ef          	jal	800030ec <end_op>
      return -1;
    800044ae:	557d                	li	a0,-1
    800044b0:	74aa                	ld	s1,168(sp)
    800044b2:	b7c1                	j	80004472 <sys_open+0xc8>
      end_op();
    800044b4:	c39fe0ef          	jal	800030ec <end_op>
      return -1;
    800044b8:	557d                	li	a0,-1
    800044ba:	74aa                	ld	s1,168(sp)
    800044bc:	bf5d                	j	80004472 <sys_open+0xc8>
    iunlockput(ip);
    800044be:	8526                	mv	a0,s1
    800044c0:	be2fe0ef          	jal	800028a2 <iunlockput>
    end_op();
    800044c4:	c29fe0ef          	jal	800030ec <end_op>
    return -1;
    800044c8:	557d                	li	a0,-1
    800044ca:	74aa                	ld	s1,168(sp)
    800044cc:	b75d                	j	80004472 <sys_open+0xc8>
      fileclose(f);
    800044ce:	854a                	mv	a0,s2
    800044d0:	fbffe0ef          	jal	8000348e <fileclose>
    800044d4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044d6:	8526                	mv	a0,s1
    800044d8:	bcafe0ef          	jal	800028a2 <iunlockput>
    end_op();
    800044dc:	c11fe0ef          	jal	800030ec <end_op>
    return -1;
    800044e0:	557d                	li	a0,-1
    800044e2:	74aa                	ld	s1,168(sp)
    800044e4:	790a                	ld	s2,160(sp)
    800044e6:	b771                	j	80004472 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800044e8:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800044ec:	04649783          	lh	a5,70(s1)
    800044f0:	02f91223          	sh	a5,36(s2)
    800044f4:	bf3d                	j	80004432 <sys_open+0x88>
    itrunc(ip);
    800044f6:	8526                	mv	a0,s1
    800044f8:	a8efe0ef          	jal	80002786 <itrunc>
    800044fc:	b795                	j	80004460 <sys_open+0xb6>

00000000800044fe <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800044fe:	7175                	addi	sp,sp,-144
    80004500:	e506                	sd	ra,136(sp)
    80004502:	e122                	sd	s0,128(sp)
    80004504:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004506:	b7dfe0ef          	jal	80003082 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000450a:	08000613          	li	a2,128
    8000450e:	f7040593          	addi	a1,s0,-144
    80004512:	4501                	li	a0,0
    80004514:	fc6fd0ef          	jal	80001cda <argstr>
    80004518:	02054363          	bltz	a0,8000453e <sys_mkdir+0x40>
    8000451c:	4681                	li	a3,0
    8000451e:	4601                	li	a2,0
    80004520:	4585                	li	a1,1
    80004522:	f7040513          	addi	a0,s0,-144
    80004526:	96fff0ef          	jal	80003e94 <create>
    8000452a:	c911                	beqz	a0,8000453e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000452c:	b76fe0ef          	jal	800028a2 <iunlockput>
  end_op();
    80004530:	bbdfe0ef          	jal	800030ec <end_op>
  return 0;
    80004534:	4501                	li	a0,0
}
    80004536:	60aa                	ld	ra,136(sp)
    80004538:	640a                	ld	s0,128(sp)
    8000453a:	6149                	addi	sp,sp,144
    8000453c:	8082                	ret
    end_op();
    8000453e:	baffe0ef          	jal	800030ec <end_op>
    return -1;
    80004542:	557d                	li	a0,-1
    80004544:	bfcd                	j	80004536 <sys_mkdir+0x38>

0000000080004546 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004546:	7135                	addi	sp,sp,-160
    80004548:	ed06                	sd	ra,152(sp)
    8000454a:	e922                	sd	s0,144(sp)
    8000454c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000454e:	b35fe0ef          	jal	80003082 <begin_op>
  argint(1, &major);
    80004552:	f6c40593          	addi	a1,s0,-148
    80004556:	4505                	li	a0,1
    80004558:	f4afd0ef          	jal	80001ca2 <argint>
  argint(2, &minor);
    8000455c:	f6840593          	addi	a1,s0,-152
    80004560:	4509                	li	a0,2
    80004562:	f40fd0ef          	jal	80001ca2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004566:	08000613          	li	a2,128
    8000456a:	f7040593          	addi	a1,s0,-144
    8000456e:	4501                	li	a0,0
    80004570:	f6afd0ef          	jal	80001cda <argstr>
    80004574:	02054563          	bltz	a0,8000459e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004578:	f6841683          	lh	a3,-152(s0)
    8000457c:	f6c41603          	lh	a2,-148(s0)
    80004580:	458d                	li	a1,3
    80004582:	f7040513          	addi	a0,s0,-144
    80004586:	90fff0ef          	jal	80003e94 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000458a:	c911                	beqz	a0,8000459e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000458c:	b16fe0ef          	jal	800028a2 <iunlockput>
  end_op();
    80004590:	b5dfe0ef          	jal	800030ec <end_op>
  return 0;
    80004594:	4501                	li	a0,0
}
    80004596:	60ea                	ld	ra,152(sp)
    80004598:	644a                	ld	s0,144(sp)
    8000459a:	610d                	addi	sp,sp,160
    8000459c:	8082                	ret
    end_op();
    8000459e:	b4ffe0ef          	jal	800030ec <end_op>
    return -1;
    800045a2:	557d                	li	a0,-1
    800045a4:	bfcd                	j	80004596 <sys_mknod+0x50>

00000000800045a6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045a6:	7135                	addi	sp,sp,-160
    800045a8:	ed06                	sd	ra,152(sp)
    800045aa:	e922                	sd	s0,144(sp)
    800045ac:	e14a                	sd	s2,128(sp)
    800045ae:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045b0:	ff6fc0ef          	jal	80000da6 <myproc>
    800045b4:	892a                	mv	s2,a0
  
  begin_op();
    800045b6:	acdfe0ef          	jal	80003082 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045ba:	08000613          	li	a2,128
    800045be:	f6040593          	addi	a1,s0,-160
    800045c2:	4501                	li	a0,0
    800045c4:	f16fd0ef          	jal	80001cda <argstr>
    800045c8:	04054363          	bltz	a0,8000460e <sys_chdir+0x68>
    800045cc:	e526                	sd	s1,136(sp)
    800045ce:	f6040513          	addi	a0,s0,-160
    800045d2:	8ddfe0ef          	jal	80002eae <namei>
    800045d6:	84aa                	mv	s1,a0
    800045d8:	c915                	beqz	a0,8000460c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800045da:	8befe0ef          	jal	80002698 <ilock>
  if(ip->type != T_DIR){
    800045de:	04449703          	lh	a4,68(s1)
    800045e2:	4785                	li	a5,1
    800045e4:	02f71963          	bne	a4,a5,80004616 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800045e8:	8526                	mv	a0,s1
    800045ea:	95cfe0ef          	jal	80002746 <iunlock>
  iput(p->cwd);
    800045ee:	15093503          	ld	a0,336(s2)
    800045f2:	a28fe0ef          	jal	8000281a <iput>
  end_op();
    800045f6:	af7fe0ef          	jal	800030ec <end_op>
  p->cwd = ip;
    800045fa:	14993823          	sd	s1,336(s2)
  return 0;
    800045fe:	4501                	li	a0,0
    80004600:	64aa                	ld	s1,136(sp)
}
    80004602:	60ea                	ld	ra,152(sp)
    80004604:	644a                	ld	s0,144(sp)
    80004606:	690a                	ld	s2,128(sp)
    80004608:	610d                	addi	sp,sp,160
    8000460a:	8082                	ret
    8000460c:	64aa                	ld	s1,136(sp)
    end_op();
    8000460e:	adffe0ef          	jal	800030ec <end_op>
    return -1;
    80004612:	557d                	li	a0,-1
    80004614:	b7fd                	j	80004602 <sys_chdir+0x5c>
    iunlockput(ip);
    80004616:	8526                	mv	a0,s1
    80004618:	a8afe0ef          	jal	800028a2 <iunlockput>
    end_op();
    8000461c:	ad1fe0ef          	jal	800030ec <end_op>
    return -1;
    80004620:	557d                	li	a0,-1
    80004622:	64aa                	ld	s1,136(sp)
    80004624:	bff9                	j	80004602 <sys_chdir+0x5c>

0000000080004626 <sys_exec>:

uint64
sys_exec(void)
{
    80004626:	7121                	addi	sp,sp,-448
    80004628:	ff06                	sd	ra,440(sp)
    8000462a:	fb22                	sd	s0,432(sp)
    8000462c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000462e:	e4840593          	addi	a1,s0,-440
    80004632:	4505                	li	a0,1
    80004634:	e8afd0ef          	jal	80001cbe <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004638:	08000613          	li	a2,128
    8000463c:	f5040593          	addi	a1,s0,-176
    80004640:	4501                	li	a0,0
    80004642:	e98fd0ef          	jal	80001cda <argstr>
    80004646:	87aa                	mv	a5,a0
    return -1;
    80004648:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000464a:	0c07c463          	bltz	a5,80004712 <sys_exec+0xec>
    8000464e:	f726                	sd	s1,424(sp)
    80004650:	f34a                	sd	s2,416(sp)
    80004652:	ef4e                	sd	s3,408(sp)
    80004654:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004656:	10000613          	li	a2,256
    8000465a:	4581                	li	a1,0
    8000465c:	e5040513          	addi	a0,s0,-432
    80004660:	aeffb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004664:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004668:	89a6                	mv	s3,s1
    8000466a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000466c:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004670:	00391513          	slli	a0,s2,0x3
    80004674:	e4040593          	addi	a1,s0,-448
    80004678:	e4843783          	ld	a5,-440(s0)
    8000467c:	953e                	add	a0,a0,a5
    8000467e:	d9afd0ef          	jal	80001c18 <fetchaddr>
    80004682:	02054663          	bltz	a0,800046ae <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004686:	e4043783          	ld	a5,-448(s0)
    8000468a:	c3a9                	beqz	a5,800046cc <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000468c:	a73fb0ef          	jal	800000fe <kalloc>
    80004690:	85aa                	mv	a1,a0
    80004692:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004696:	cd01                	beqz	a0,800046ae <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004698:	6605                	lui	a2,0x1
    8000469a:	e4043503          	ld	a0,-448(s0)
    8000469e:	dc4fd0ef          	jal	80001c62 <fetchstr>
    800046a2:	00054663          	bltz	a0,800046ae <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800046a6:	0905                	addi	s2,s2,1
    800046a8:	09a1                	addi	s3,s3,8
    800046aa:	fd4913e3          	bne	s2,s4,80004670 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ae:	f5040913          	addi	s2,s0,-176
    800046b2:	6088                	ld	a0,0(s1)
    800046b4:	c931                	beqz	a0,80004708 <sys_exec+0xe2>
    kfree(argv[i]);
    800046b6:	967fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ba:	04a1                	addi	s1,s1,8
    800046bc:	ff249be3          	bne	s1,s2,800046b2 <sys_exec+0x8c>
  return -1;
    800046c0:	557d                	li	a0,-1
    800046c2:	74ba                	ld	s1,424(sp)
    800046c4:	791a                	ld	s2,416(sp)
    800046c6:	69fa                	ld	s3,408(sp)
    800046c8:	6a5a                	ld	s4,400(sp)
    800046ca:	a0a1                	j	80004712 <sys_exec+0xec>
      argv[i] = 0;
    800046cc:	0009079b          	sext.w	a5,s2
    800046d0:	078e                	slli	a5,a5,0x3
    800046d2:	fd078793          	addi	a5,a5,-48
    800046d6:	97a2                	add	a5,a5,s0
    800046d8:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    800046dc:	e5040593          	addi	a1,s0,-432
    800046e0:	f5040513          	addi	a0,s0,-176
    800046e4:	ba8ff0ef          	jal	80003a8c <kexec>
    800046e8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ea:	f5040993          	addi	s3,s0,-176
    800046ee:	6088                	ld	a0,0(s1)
    800046f0:	c511                	beqz	a0,800046fc <sys_exec+0xd6>
    kfree(argv[i]);
    800046f2:	92bfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046f6:	04a1                	addi	s1,s1,8
    800046f8:	ff349be3          	bne	s1,s3,800046ee <sys_exec+0xc8>
  return ret;
    800046fc:	854a                	mv	a0,s2
    800046fe:	74ba                	ld	s1,424(sp)
    80004700:	791a                	ld	s2,416(sp)
    80004702:	69fa                	ld	s3,408(sp)
    80004704:	6a5a                	ld	s4,400(sp)
    80004706:	a031                	j	80004712 <sys_exec+0xec>
  return -1;
    80004708:	557d                	li	a0,-1
    8000470a:	74ba                	ld	s1,424(sp)
    8000470c:	791a                	ld	s2,416(sp)
    8000470e:	69fa                	ld	s3,408(sp)
    80004710:	6a5a                	ld	s4,400(sp)
}
    80004712:	70fa                	ld	ra,440(sp)
    80004714:	745a                	ld	s0,432(sp)
    80004716:	6139                	addi	sp,sp,448
    80004718:	8082                	ret

000000008000471a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000471a:	7139                	addi	sp,sp,-64
    8000471c:	fc06                	sd	ra,56(sp)
    8000471e:	f822                	sd	s0,48(sp)
    80004720:	f426                	sd	s1,40(sp)
    80004722:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004724:	e82fc0ef          	jal	80000da6 <myproc>
    80004728:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000472a:	fd840593          	addi	a1,s0,-40
    8000472e:	4501                	li	a0,0
    80004730:	d8efd0ef          	jal	80001cbe <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004734:	fc840593          	addi	a1,s0,-56
    80004738:	fd040513          	addi	a0,s0,-48
    8000473c:	85cff0ef          	jal	80003798 <pipealloc>
    return -1;
    80004740:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004742:	0a054463          	bltz	a0,800047ea <sys_pipe+0xd0>
  fd0 = -1;
    80004746:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000474a:	fd043503          	ld	a0,-48(s0)
    8000474e:	f08ff0ef          	jal	80003e56 <fdalloc>
    80004752:	fca42223          	sw	a0,-60(s0)
    80004756:	08054163          	bltz	a0,800047d8 <sys_pipe+0xbe>
    8000475a:	fc843503          	ld	a0,-56(s0)
    8000475e:	ef8ff0ef          	jal	80003e56 <fdalloc>
    80004762:	fca42023          	sw	a0,-64(s0)
    80004766:	06054063          	bltz	a0,800047c6 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000476a:	4691                	li	a3,4
    8000476c:	fc440613          	addi	a2,s0,-60
    80004770:	fd843583          	ld	a1,-40(s0)
    80004774:	68a8                	ld	a0,80(s1)
    80004776:	b34fc0ef          	jal	80000aaa <copyout>
    8000477a:	00054e63          	bltz	a0,80004796 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000477e:	4691                	li	a3,4
    80004780:	fc040613          	addi	a2,s0,-64
    80004784:	fd843583          	ld	a1,-40(s0)
    80004788:	0591                	addi	a1,a1,4
    8000478a:	68a8                	ld	a0,80(s1)
    8000478c:	b1efc0ef          	jal	80000aaa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004790:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004792:	04055c63          	bgez	a0,800047ea <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004796:	fc442783          	lw	a5,-60(s0)
    8000479a:	07e9                	addi	a5,a5,26
    8000479c:	078e                	slli	a5,a5,0x3
    8000479e:	97a6                	add	a5,a5,s1
    800047a0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047a4:	fc042783          	lw	a5,-64(s0)
    800047a8:	07e9                	addi	a5,a5,26
    800047aa:	078e                	slli	a5,a5,0x3
    800047ac:	94be                	add	s1,s1,a5
    800047ae:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800047b2:	fd043503          	ld	a0,-48(s0)
    800047b6:	cd9fe0ef          	jal	8000348e <fileclose>
    fileclose(wf);
    800047ba:	fc843503          	ld	a0,-56(s0)
    800047be:	cd1fe0ef          	jal	8000348e <fileclose>
    return -1;
    800047c2:	57fd                	li	a5,-1
    800047c4:	a01d                	j	800047ea <sys_pipe+0xd0>
    if(fd0 >= 0)
    800047c6:	fc442783          	lw	a5,-60(s0)
    800047ca:	0007c763          	bltz	a5,800047d8 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800047ce:	07e9                	addi	a5,a5,26
    800047d0:	078e                	slli	a5,a5,0x3
    800047d2:	97a6                	add	a5,a5,s1
    800047d4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047d8:	fd043503          	ld	a0,-48(s0)
    800047dc:	cb3fe0ef          	jal	8000348e <fileclose>
    fileclose(wf);
    800047e0:	fc843503          	ld	a0,-56(s0)
    800047e4:	cabfe0ef          	jal	8000348e <fileclose>
    return -1;
    800047e8:	57fd                	li	a5,-1
}
    800047ea:	853e                	mv	a0,a5
    800047ec:	70e2                	ld	ra,56(sp)
    800047ee:	7442                	ld	s0,48(sp)
    800047f0:	74a2                	ld	s1,40(sp)
    800047f2:	6121                	addi	sp,sp,64
    800047f4:	8082                	ret
	...

0000000080004800 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004800:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004802:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004804:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004806:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004808:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000480a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000480c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000480e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004810:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004812:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004814:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004816:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004818:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000481a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000481c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000481e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004820:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004822:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004824:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004826:	b02fd0ef          	jal	80001b28 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000482a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000482c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000482e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004830:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004832:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004834:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004836:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004838:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000483a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000483c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000483e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004840:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004842:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004844:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004846:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004848:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000484a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000484c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000484e:	10200073          	sret
	...

000000008000485e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000485e:	1141                	addi	sp,sp,-16
    80004860:	e422                	sd	s0,8(sp)
    80004862:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004864:	0c0007b7          	lui	a5,0xc000
    80004868:	4705                	li	a4,1
    8000486a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000486c:	0c0007b7          	lui	a5,0xc000
    80004870:	c3d8                	sw	a4,4(a5)
}
    80004872:	6422                	ld	s0,8(sp)
    80004874:	0141                	addi	sp,sp,16
    80004876:	8082                	ret

0000000080004878 <plicinithart>:

void
plicinithart(void)
{
    80004878:	1141                	addi	sp,sp,-16
    8000487a:	e406                	sd	ra,8(sp)
    8000487c:	e022                	sd	s0,0(sp)
    8000487e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004880:	cfafc0ef          	jal	80000d7a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004884:	0085171b          	slliw	a4,a0,0x8
    80004888:	0c0027b7          	lui	a5,0xc002
    8000488c:	97ba                	add	a5,a5,a4
    8000488e:	40200713          	li	a4,1026
    80004892:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004896:	00d5151b          	slliw	a0,a0,0xd
    8000489a:	0c2017b7          	lui	a5,0xc201
    8000489e:	97aa                	add	a5,a5,a0
    800048a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800048a4:	60a2                	ld	ra,8(sp)
    800048a6:	6402                	ld	s0,0(sp)
    800048a8:	0141                	addi	sp,sp,16
    800048aa:	8082                	ret

00000000800048ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800048ac:	1141                	addi	sp,sp,-16
    800048ae:	e406                	sd	ra,8(sp)
    800048b0:	e022                	sd	s0,0(sp)
    800048b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048b4:	cc6fc0ef          	jal	80000d7a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800048b8:	00d5151b          	slliw	a0,a0,0xd
    800048bc:	0c2017b7          	lui	a5,0xc201
    800048c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800048c2:	43c8                	lw	a0,4(a5)
    800048c4:	60a2                	ld	ra,8(sp)
    800048c6:	6402                	ld	s0,0(sp)
    800048c8:	0141                	addi	sp,sp,16
    800048ca:	8082                	ret

00000000800048cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800048cc:	1101                	addi	sp,sp,-32
    800048ce:	ec06                	sd	ra,24(sp)
    800048d0:	e822                	sd	s0,16(sp)
    800048d2:	e426                	sd	s1,8(sp)
    800048d4:	1000                	addi	s0,sp,32
    800048d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800048d8:	ca2fc0ef          	jal	80000d7a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800048dc:	00d5151b          	slliw	a0,a0,0xd
    800048e0:	0c2017b7          	lui	a5,0xc201
    800048e4:	97aa                	add	a5,a5,a0
    800048e6:	c3c4                	sw	s1,4(a5)
}
    800048e8:	60e2                	ld	ra,24(sp)
    800048ea:	6442                	ld	s0,16(sp)
    800048ec:	64a2                	ld	s1,8(sp)
    800048ee:	6105                	addi	sp,sp,32
    800048f0:	8082                	ret

00000000800048f2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800048f2:	1141                	addi	sp,sp,-16
    800048f4:	e406                	sd	ra,8(sp)
    800048f6:	e022                	sd	s0,0(sp)
    800048f8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800048fa:	479d                	li	a5,7
    800048fc:	04a7ca63          	blt	a5,a0,80004950 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004900:	00017797          	auipc	a5,0x17
    80004904:	9d078793          	addi	a5,a5,-1584 # 8001b2d0 <disk>
    80004908:	97aa                	add	a5,a5,a0
    8000490a:	0187c783          	lbu	a5,24(a5)
    8000490e:	e7b9                	bnez	a5,8000495c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004910:	00451693          	slli	a3,a0,0x4
    80004914:	00017797          	auipc	a5,0x17
    80004918:	9bc78793          	addi	a5,a5,-1604 # 8001b2d0 <disk>
    8000491c:	6398                	ld	a4,0(a5)
    8000491e:	9736                	add	a4,a4,a3
    80004920:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004924:	6398                	ld	a4,0(a5)
    80004926:	9736                	add	a4,a4,a3
    80004928:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000492c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004930:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004934:	97aa                	add	a5,a5,a0
    80004936:	4705                	li	a4,1
    80004938:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000493c:	00017517          	auipc	a0,0x17
    80004940:	9ac50513          	addi	a0,a0,-1620 # 8001b2e8 <disk+0x18>
    80004944:	aa7fc0ef          	jal	800013ea <wakeup>
}
    80004948:	60a2                	ld	ra,8(sp)
    8000494a:	6402                	ld	s0,0(sp)
    8000494c:	0141                	addi	sp,sp,16
    8000494e:	8082                	ret
    panic("free_desc 1");
    80004950:	00003517          	auipc	a0,0x3
    80004954:	c7850513          	addi	a0,a0,-904 # 800075c8 <etext+0x5c8>
    80004958:	487000ef          	jal	800055de <panic>
    panic("free_desc 2");
    8000495c:	00003517          	auipc	a0,0x3
    80004960:	c7c50513          	addi	a0,a0,-900 # 800075d8 <etext+0x5d8>
    80004964:	47b000ef          	jal	800055de <panic>

0000000080004968 <virtio_disk_init>:
{
    80004968:	1101                	addi	sp,sp,-32
    8000496a:	ec06                	sd	ra,24(sp)
    8000496c:	e822                	sd	s0,16(sp)
    8000496e:	e426                	sd	s1,8(sp)
    80004970:	e04a                	sd	s2,0(sp)
    80004972:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004974:	00003597          	auipc	a1,0x3
    80004978:	c7458593          	addi	a1,a1,-908 # 800075e8 <etext+0x5e8>
    8000497c:	00017517          	auipc	a0,0x17
    80004980:	a7c50513          	addi	a0,a0,-1412 # 8001b3f8 <disk+0x128>
    80004984:	697000ef          	jal	8000581a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004988:	100017b7          	lui	a5,0x10001
    8000498c:	4398                	lw	a4,0(a5)
    8000498e:	2701                	sext.w	a4,a4
    80004990:	747277b7          	lui	a5,0x74727
    80004994:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004998:	18f71063          	bne	a4,a5,80004b18 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000499c:	100017b7          	lui	a5,0x10001
    800049a0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800049a2:	439c                	lw	a5,0(a5)
    800049a4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049a6:	4709                	li	a4,2
    800049a8:	16e79863          	bne	a5,a4,80004b18 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049ac:	100017b7          	lui	a5,0x10001
    800049b0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800049b2:	439c                	lw	a5,0(a5)
    800049b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049b6:	16e79163          	bne	a5,a4,80004b18 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800049ba:	100017b7          	lui	a5,0x10001
    800049be:	47d8                	lw	a4,12(a5)
    800049c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049c2:	554d47b7          	lui	a5,0x554d4
    800049c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800049ca:	14f71763          	bne	a4,a5,80004b18 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049ce:	100017b7          	lui	a5,0x10001
    800049d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049d6:	4705                	li	a4,1
    800049d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049da:	470d                	li	a4,3
    800049dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800049de:	10001737          	lui	a4,0x10001
    800049e2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800049e4:	c7ffe737          	lui	a4,0xc7ffe
    800049e8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb277>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800049ec:	8ef9                	and	a3,a3,a4
    800049ee:	10001737          	lui	a4,0x10001
    800049f2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049f4:	472d                	li	a4,11
    800049f6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049f8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800049fc:	439c                	lw	a5,0(a5)
    800049fe:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a02:	8ba1                	andi	a5,a5,8
    80004a04:	12078063          	beqz	a5,80004b24 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a08:	100017b7          	lui	a5,0x10001
    80004a0c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a10:	100017b7          	lui	a5,0x10001
    80004a14:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004a18:	439c                	lw	a5,0(a5)
    80004a1a:	2781                	sext.w	a5,a5
    80004a1c:	10079a63          	bnez	a5,80004b30 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004a20:	100017b7          	lui	a5,0x10001
    80004a24:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004a28:	439c                	lw	a5,0(a5)
    80004a2a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004a2c:	10078863          	beqz	a5,80004b3c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a30:	471d                	li	a4,7
    80004a32:	10f77b63          	bgeu	a4,a5,80004b48 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a36:	ec8fb0ef          	jal	800000fe <kalloc>
    80004a3a:	00017497          	auipc	s1,0x17
    80004a3e:	89648493          	addi	s1,s1,-1898 # 8001b2d0 <disk>
    80004a42:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a44:	ebafb0ef          	jal	800000fe <kalloc>
    80004a48:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a4a:	eb4fb0ef          	jal	800000fe <kalloc>
    80004a4e:	87aa                	mv	a5,a0
    80004a50:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004a52:	6088                	ld	a0,0(s1)
    80004a54:	10050063          	beqz	a0,80004b54 <virtio_disk_init+0x1ec>
    80004a58:	00017717          	auipc	a4,0x17
    80004a5c:	88073703          	ld	a4,-1920(a4) # 8001b2d8 <disk+0x8>
    80004a60:	0e070a63          	beqz	a4,80004b54 <virtio_disk_init+0x1ec>
    80004a64:	0e078863          	beqz	a5,80004b54 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004a68:	6605                	lui	a2,0x1
    80004a6a:	4581                	li	a1,0
    80004a6c:	ee2fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a70:	00017497          	auipc	s1,0x17
    80004a74:	86048493          	addi	s1,s1,-1952 # 8001b2d0 <disk>
    80004a78:	6605                	lui	a2,0x1
    80004a7a:	4581                	li	a1,0
    80004a7c:	6488                	ld	a0,8(s1)
    80004a7e:	ed0fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004a82:	6605                	lui	a2,0x1
    80004a84:	4581                	li	a1,0
    80004a86:	6888                	ld	a0,16(s1)
    80004a88:	ec6fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a8c:	100017b7          	lui	a5,0x10001
    80004a90:	4721                	li	a4,8
    80004a92:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004a94:	4098                	lw	a4,0(s1)
    80004a96:	100017b7          	lui	a5,0x10001
    80004a9a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004a9e:	40d8                	lw	a4,4(s1)
    80004aa0:	100017b7          	lui	a5,0x10001
    80004aa4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004aa8:	649c                	ld	a5,8(s1)
    80004aaa:	0007869b          	sext.w	a3,a5
    80004aae:	10001737          	lui	a4,0x10001
    80004ab2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004ab6:	9781                	srai	a5,a5,0x20
    80004ab8:	10001737          	lui	a4,0x10001
    80004abc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004ac0:	689c                	ld	a5,16(s1)
    80004ac2:	0007869b          	sext.w	a3,a5
    80004ac6:	10001737          	lui	a4,0x10001
    80004aca:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004ace:	9781                	srai	a5,a5,0x20
    80004ad0:	10001737          	lui	a4,0x10001
    80004ad4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004ad8:	10001737          	lui	a4,0x10001
    80004adc:	4785                	li	a5,1
    80004ade:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004ae0:	00f48c23          	sb	a5,24(s1)
    80004ae4:	00f48ca3          	sb	a5,25(s1)
    80004ae8:	00f48d23          	sb	a5,26(s1)
    80004aec:	00f48da3          	sb	a5,27(s1)
    80004af0:	00f48e23          	sb	a5,28(s1)
    80004af4:	00f48ea3          	sb	a5,29(s1)
    80004af8:	00f48f23          	sb	a5,30(s1)
    80004afc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b00:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b04:	100017b7          	lui	a5,0x10001
    80004b08:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004b0c:	60e2                	ld	ra,24(sp)
    80004b0e:	6442                	ld	s0,16(sp)
    80004b10:	64a2                	ld	s1,8(sp)
    80004b12:	6902                	ld	s2,0(sp)
    80004b14:	6105                	addi	sp,sp,32
    80004b16:	8082                	ret
    panic("could not find virtio disk");
    80004b18:	00003517          	auipc	a0,0x3
    80004b1c:	ae050513          	addi	a0,a0,-1312 # 800075f8 <etext+0x5f8>
    80004b20:	2bf000ef          	jal	800055de <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b24:	00003517          	auipc	a0,0x3
    80004b28:	af450513          	addi	a0,a0,-1292 # 80007618 <etext+0x618>
    80004b2c:	2b3000ef          	jal	800055de <panic>
    panic("virtio disk should not be ready");
    80004b30:	00003517          	auipc	a0,0x3
    80004b34:	b0850513          	addi	a0,a0,-1272 # 80007638 <etext+0x638>
    80004b38:	2a7000ef          	jal	800055de <panic>
    panic("virtio disk has no queue 0");
    80004b3c:	00003517          	auipc	a0,0x3
    80004b40:	b1c50513          	addi	a0,a0,-1252 # 80007658 <etext+0x658>
    80004b44:	29b000ef          	jal	800055de <panic>
    panic("virtio disk max queue too short");
    80004b48:	00003517          	auipc	a0,0x3
    80004b4c:	b3050513          	addi	a0,a0,-1232 # 80007678 <etext+0x678>
    80004b50:	28f000ef          	jal	800055de <panic>
    panic("virtio disk kalloc");
    80004b54:	00003517          	auipc	a0,0x3
    80004b58:	b4450513          	addi	a0,a0,-1212 # 80007698 <etext+0x698>
    80004b5c:	283000ef          	jal	800055de <panic>

0000000080004b60 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004b60:	7159                	addi	sp,sp,-112
    80004b62:	f486                	sd	ra,104(sp)
    80004b64:	f0a2                	sd	s0,96(sp)
    80004b66:	eca6                	sd	s1,88(sp)
    80004b68:	e8ca                	sd	s2,80(sp)
    80004b6a:	e4ce                	sd	s3,72(sp)
    80004b6c:	e0d2                	sd	s4,64(sp)
    80004b6e:	fc56                	sd	s5,56(sp)
    80004b70:	f85a                	sd	s6,48(sp)
    80004b72:	f45e                	sd	s7,40(sp)
    80004b74:	f062                	sd	s8,32(sp)
    80004b76:	ec66                	sd	s9,24(sp)
    80004b78:	1880                	addi	s0,sp,112
    80004b7a:	8a2a                	mv	s4,a0
    80004b7c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004b7e:	00c52c83          	lw	s9,12(a0)
    80004b82:	001c9c9b          	slliw	s9,s9,0x1
    80004b86:	1c82                	slli	s9,s9,0x20
    80004b88:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004b8c:	00017517          	auipc	a0,0x17
    80004b90:	86c50513          	addi	a0,a0,-1940 # 8001b3f8 <disk+0x128>
    80004b94:	507000ef          	jal	8000589a <acquire>
  for(int i = 0; i < 3; i++){
    80004b98:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004b9a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004b9c:	00016b17          	auipc	s6,0x16
    80004ba0:	734b0b13          	addi	s6,s6,1844 # 8001b2d0 <disk>
  for(int i = 0; i < 3; i++){
    80004ba4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004ba6:	00017c17          	auipc	s8,0x17
    80004baa:	852c0c13          	addi	s8,s8,-1966 # 8001b3f8 <disk+0x128>
    80004bae:	a8b9                	j	80004c0c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004bb0:	00fb0733          	add	a4,s6,a5
    80004bb4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004bb8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004bba:	0207c563          	bltz	a5,80004be4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004bbe:	2905                	addiw	s2,s2,1
    80004bc0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004bc2:	05590963          	beq	s2,s5,80004c14 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004bc6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004bc8:	00016717          	auipc	a4,0x16
    80004bcc:	70870713          	addi	a4,a4,1800 # 8001b2d0 <disk>
    80004bd0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004bd2:	01874683          	lbu	a3,24(a4)
    80004bd6:	fee9                	bnez	a3,80004bb0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004bd8:	2785                	addiw	a5,a5,1
    80004bda:	0705                	addi	a4,a4,1
    80004bdc:	fe979be3          	bne	a5,s1,80004bd2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004be0:	57fd                	li	a5,-1
    80004be2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004be4:	01205d63          	blez	s2,80004bfe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004be8:	f9042503          	lw	a0,-112(s0)
    80004bec:	d07ff0ef          	jal	800048f2 <free_desc>
      for(int j = 0; j < i; j++)
    80004bf0:	4785                	li	a5,1
    80004bf2:	0127d663          	bge	a5,s2,80004bfe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004bf6:	f9442503          	lw	a0,-108(s0)
    80004bfa:	cf9ff0ef          	jal	800048f2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004bfe:	85e2                	mv	a1,s8
    80004c00:	00016517          	auipc	a0,0x16
    80004c04:	6e850513          	addi	a0,a0,1768 # 8001b2e8 <disk+0x18>
    80004c08:	f96fc0ef          	jal	8000139e <sleep>
  for(int i = 0; i < 3; i++){
    80004c0c:	f9040613          	addi	a2,s0,-112
    80004c10:	894e                	mv	s2,s3
    80004c12:	bf55                	j	80004bc6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c14:	f9042503          	lw	a0,-112(s0)
    80004c18:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c1c:	00016797          	auipc	a5,0x16
    80004c20:	6b478793          	addi	a5,a5,1716 # 8001b2d0 <disk>
    80004c24:	00a50713          	addi	a4,a0,10
    80004c28:	0712                	slli	a4,a4,0x4
    80004c2a:	973e                	add	a4,a4,a5
    80004c2c:	01703633          	snez	a2,s7
    80004c30:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c32:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c36:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c3a:	6398                	ld	a4,0(a5)
    80004c3c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c3e:	0a868613          	addi	a2,a3,168
    80004c42:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c44:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c46:	6390                	ld	a2,0(a5)
    80004c48:	00d605b3          	add	a1,a2,a3
    80004c4c:	4741                	li	a4,16
    80004c4e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004c50:	4805                	li	a6,1
    80004c52:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004c56:	f9442703          	lw	a4,-108(s0)
    80004c5a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004c5e:	0712                	slli	a4,a4,0x4
    80004c60:	963a                	add	a2,a2,a4
    80004c62:	058a0593          	addi	a1,s4,88
    80004c66:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004c68:	0007b883          	ld	a7,0(a5)
    80004c6c:	9746                	add	a4,a4,a7
    80004c6e:	40000613          	li	a2,1024
    80004c72:	c710                	sw	a2,8(a4)
  if(write)
    80004c74:	001bb613          	seqz	a2,s7
    80004c78:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004c7c:	00166613          	ori	a2,a2,1
    80004c80:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004c84:	f9842583          	lw	a1,-104(s0)
    80004c88:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004c8c:	00250613          	addi	a2,a0,2
    80004c90:	0612                	slli	a2,a2,0x4
    80004c92:	963e                	add	a2,a2,a5
    80004c94:	577d                	li	a4,-1
    80004c96:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004c9a:	0592                	slli	a1,a1,0x4
    80004c9c:	98ae                	add	a7,a7,a1
    80004c9e:	03068713          	addi	a4,a3,48
    80004ca2:	973e                	add	a4,a4,a5
    80004ca4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004ca8:	6398                	ld	a4,0(a5)
    80004caa:	972e                	add	a4,a4,a1
    80004cac:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004cb0:	4689                	li	a3,2
    80004cb2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004cb6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004cba:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004cbe:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004cc2:	6794                	ld	a3,8(a5)
    80004cc4:	0026d703          	lhu	a4,2(a3)
    80004cc8:	8b1d                	andi	a4,a4,7
    80004cca:	0706                	slli	a4,a4,0x1
    80004ccc:	96ba                	add	a3,a3,a4
    80004cce:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004cd2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004cd6:	6798                	ld	a4,8(a5)
    80004cd8:	00275783          	lhu	a5,2(a4)
    80004cdc:	2785                	addiw	a5,a5,1
    80004cde:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004ce2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004ce6:	100017b7          	lui	a5,0x10001
    80004cea:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004cee:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004cf2:	00016917          	auipc	s2,0x16
    80004cf6:	70690913          	addi	s2,s2,1798 # 8001b3f8 <disk+0x128>
  while(b->disk == 1) {
    80004cfa:	4485                	li	s1,1
    80004cfc:	01079a63          	bne	a5,a6,80004d10 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d00:	85ca                	mv	a1,s2
    80004d02:	8552                	mv	a0,s4
    80004d04:	e9afc0ef          	jal	8000139e <sleep>
  while(b->disk == 1) {
    80004d08:	004a2783          	lw	a5,4(s4)
    80004d0c:	fe978ae3          	beq	a5,s1,80004d00 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d10:	f9042903          	lw	s2,-112(s0)
    80004d14:	00290713          	addi	a4,s2,2
    80004d18:	0712                	slli	a4,a4,0x4
    80004d1a:	00016797          	auipc	a5,0x16
    80004d1e:	5b678793          	addi	a5,a5,1462 # 8001b2d0 <disk>
    80004d22:	97ba                	add	a5,a5,a4
    80004d24:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d28:	00016997          	auipc	s3,0x16
    80004d2c:	5a898993          	addi	s3,s3,1448 # 8001b2d0 <disk>
    80004d30:	00491713          	slli	a4,s2,0x4
    80004d34:	0009b783          	ld	a5,0(s3)
    80004d38:	97ba                	add	a5,a5,a4
    80004d3a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d3e:	854a                	mv	a0,s2
    80004d40:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d44:	bafff0ef          	jal	800048f2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d48:	8885                	andi	s1,s1,1
    80004d4a:	f0fd                	bnez	s1,80004d30 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d4c:	00016517          	auipc	a0,0x16
    80004d50:	6ac50513          	addi	a0,a0,1708 # 8001b3f8 <disk+0x128>
    80004d54:	3df000ef          	jal	80005932 <release>
}
    80004d58:	70a6                	ld	ra,104(sp)
    80004d5a:	7406                	ld	s0,96(sp)
    80004d5c:	64e6                	ld	s1,88(sp)
    80004d5e:	6946                	ld	s2,80(sp)
    80004d60:	69a6                	ld	s3,72(sp)
    80004d62:	6a06                	ld	s4,64(sp)
    80004d64:	7ae2                	ld	s5,56(sp)
    80004d66:	7b42                	ld	s6,48(sp)
    80004d68:	7ba2                	ld	s7,40(sp)
    80004d6a:	7c02                	ld	s8,32(sp)
    80004d6c:	6ce2                	ld	s9,24(sp)
    80004d6e:	6165                	addi	sp,sp,112
    80004d70:	8082                	ret

0000000080004d72 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004d72:	1101                	addi	sp,sp,-32
    80004d74:	ec06                	sd	ra,24(sp)
    80004d76:	e822                	sd	s0,16(sp)
    80004d78:	e426                	sd	s1,8(sp)
    80004d7a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004d7c:	00016497          	auipc	s1,0x16
    80004d80:	55448493          	addi	s1,s1,1364 # 8001b2d0 <disk>
    80004d84:	00016517          	auipc	a0,0x16
    80004d88:	67450513          	addi	a0,a0,1652 # 8001b3f8 <disk+0x128>
    80004d8c:	30f000ef          	jal	8000589a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004d90:	100017b7          	lui	a5,0x10001
    80004d94:	53b8                	lw	a4,96(a5)
    80004d96:	8b0d                	andi	a4,a4,3
    80004d98:	100017b7          	lui	a5,0x10001
    80004d9c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004d9e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004da2:	689c                	ld	a5,16(s1)
    80004da4:	0204d703          	lhu	a4,32(s1)
    80004da8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004dac:	04f70663          	beq	a4,a5,80004df8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004db0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004db4:	6898                	ld	a4,16(s1)
    80004db6:	0204d783          	lhu	a5,32(s1)
    80004dba:	8b9d                	andi	a5,a5,7
    80004dbc:	078e                	slli	a5,a5,0x3
    80004dbe:	97ba                	add	a5,a5,a4
    80004dc0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004dc2:	00278713          	addi	a4,a5,2
    80004dc6:	0712                	slli	a4,a4,0x4
    80004dc8:	9726                	add	a4,a4,s1
    80004dca:	01074703          	lbu	a4,16(a4)
    80004dce:	e321                	bnez	a4,80004e0e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004dd0:	0789                	addi	a5,a5,2
    80004dd2:	0792                	slli	a5,a5,0x4
    80004dd4:	97a6                	add	a5,a5,s1
    80004dd6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004dd8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004ddc:	e0efc0ef          	jal	800013ea <wakeup>

    disk.used_idx += 1;
    80004de0:	0204d783          	lhu	a5,32(s1)
    80004de4:	2785                	addiw	a5,a5,1
    80004de6:	17c2                	slli	a5,a5,0x30
    80004de8:	93c1                	srli	a5,a5,0x30
    80004dea:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004dee:	6898                	ld	a4,16(s1)
    80004df0:	00275703          	lhu	a4,2(a4)
    80004df4:	faf71ee3          	bne	a4,a5,80004db0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004df8:	00016517          	auipc	a0,0x16
    80004dfc:	60050513          	addi	a0,a0,1536 # 8001b3f8 <disk+0x128>
    80004e00:	333000ef          	jal	80005932 <release>
}
    80004e04:	60e2                	ld	ra,24(sp)
    80004e06:	6442                	ld	s0,16(sp)
    80004e08:	64a2                	ld	s1,8(sp)
    80004e0a:	6105                	addi	sp,sp,32
    80004e0c:	8082                	ret
      panic("virtio_disk_intr status");
    80004e0e:	00003517          	auipc	a0,0x3
    80004e12:	8a250513          	addi	a0,a0,-1886 # 800076b0 <etext+0x6b0>
    80004e16:	7c8000ef          	jal	800055de <panic>

0000000080004e1a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e1a:	1141                	addi	sp,sp,-16
    80004e1c:	e422                	sd	s0,8(sp)
    80004e1e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e20:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e24:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e28:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e2c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e30:	577d                	li	a4,-1
    80004e32:	177e                	slli	a4,a4,0x3f
    80004e34:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e36:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e3a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e3e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e42:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e46:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e4a:	000f4737          	lui	a4,0xf4
    80004e4e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e52:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e54:	14d79073          	csrw	stimecmp,a5
}
    80004e58:	6422                	ld	s0,8(sp)
    80004e5a:	0141                	addi	sp,sp,16
    80004e5c:	8082                	ret

0000000080004e5e <start>:
{
    80004e5e:	1141                	addi	sp,sp,-16
    80004e60:	e406                	sd	ra,8(sp)
    80004e62:	e022                	sd	s0,0(sp)
    80004e64:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004e66:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004e6a:	7779                	lui	a4,0xffffe
    80004e6c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb317>
    80004e70:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e72:	6705                	lui	a4,0x1
    80004e74:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e78:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e7a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e7e:	ffffb797          	auipc	a5,0xffffb
    80004e82:	46a78793          	addi	a5,a5,1130 # 800002e8 <main>
    80004e86:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e8a:	4781                	li	a5,0
    80004e8c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004e90:	67c1                	lui	a5,0x10
    80004e92:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004e94:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004e98:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004e9c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004ea0:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004ea4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004ea8:	57fd                	li	a5,-1
    80004eaa:	83a9                	srli	a5,a5,0xa
    80004eac:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004eb0:	47bd                	li	a5,15
    80004eb2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004eb6:	f65ff0ef          	jal	80004e1a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004eba:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004ebe:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004ec0:	823e                	mv	tp,a5
  asm volatile("mret");
    80004ec2:	30200073          	mret
}
    80004ec6:	60a2                	ld	ra,8(sp)
    80004ec8:	6402                	ld	s0,0(sp)
    80004eca:	0141                	addi	sp,sp,16
    80004ecc:	8082                	ret

0000000080004ece <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004ece:	7119                	addi	sp,sp,-128
    80004ed0:	fc86                	sd	ra,120(sp)
    80004ed2:	f8a2                	sd	s0,112(sp)
    80004ed4:	f4a6                	sd	s1,104(sp)
    80004ed6:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80004ed8:	06c05a63          	blez	a2,80004f4c <consolewrite+0x7e>
    80004edc:	f0ca                	sd	s2,96(sp)
    80004ede:	ecce                	sd	s3,88(sp)
    80004ee0:	e8d2                	sd	s4,80(sp)
    80004ee2:	e4d6                	sd	s5,72(sp)
    80004ee4:	e0da                	sd	s6,64(sp)
    80004ee6:	fc5e                	sd	s7,56(sp)
    80004ee8:	f862                	sd	s8,48(sp)
    80004eea:	f466                	sd	s9,40(sp)
    80004eec:	8aaa                	mv	s5,a0
    80004eee:	8b2e                	mv	s6,a1
    80004ef0:	8a32                	mv	s4,a2
  int i = 0;
    80004ef2:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80004ef4:	02000c13          	li	s8,32
    80004ef8:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004efc:	5bfd                	li	s7,-1
    80004efe:	a035                	j	80004f2a <consolewrite+0x5c>
    if(nn > n - i)
    80004f00:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004f04:	86ce                	mv	a3,s3
    80004f06:	01648633          	add	a2,s1,s6
    80004f0a:	85d6                	mv	a1,s5
    80004f0c:	f8040513          	addi	a0,s0,-128
    80004f10:	835fc0ef          	jal	80001744 <either_copyin>
    80004f14:	03750e63          	beq	a0,s7,80004f50 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    80004f18:	85ce                	mv	a1,s3
    80004f1a:	f8040513          	addi	a0,s0,-128
    80004f1e:	778000ef          	jal	80005696 <uartwrite>
    i += nn;
    80004f22:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80004f26:	0144da63          	bge	s1,s4,80004f3a <consolewrite+0x6c>
    if(nn > n - i)
    80004f2a:	409a093b          	subw	s2,s4,s1
    80004f2e:	0009079b          	sext.w	a5,s2
    80004f32:	fcfc57e3          	bge	s8,a5,80004f00 <consolewrite+0x32>
    80004f36:	8966                	mv	s2,s9
    80004f38:	b7e1                	j	80004f00 <consolewrite+0x32>
    80004f3a:	7906                	ld	s2,96(sp)
    80004f3c:	69e6                	ld	s3,88(sp)
    80004f3e:	6a46                	ld	s4,80(sp)
    80004f40:	6aa6                	ld	s5,72(sp)
    80004f42:	6b06                	ld	s6,64(sp)
    80004f44:	7be2                	ld	s7,56(sp)
    80004f46:	7c42                	ld	s8,48(sp)
    80004f48:	7ca2                	ld	s9,40(sp)
    80004f4a:	a819                	j	80004f60 <consolewrite+0x92>
  int i = 0;
    80004f4c:	4481                	li	s1,0
    80004f4e:	a809                	j	80004f60 <consolewrite+0x92>
    80004f50:	7906                	ld	s2,96(sp)
    80004f52:	69e6                	ld	s3,88(sp)
    80004f54:	6a46                	ld	s4,80(sp)
    80004f56:	6aa6                	ld	s5,72(sp)
    80004f58:	6b06                	ld	s6,64(sp)
    80004f5a:	7be2                	ld	s7,56(sp)
    80004f5c:	7c42                	ld	s8,48(sp)
    80004f5e:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80004f60:	8526                	mv	a0,s1
    80004f62:	70e6                	ld	ra,120(sp)
    80004f64:	7446                	ld	s0,112(sp)
    80004f66:	74a6                	ld	s1,104(sp)
    80004f68:	6109                	addi	sp,sp,128
    80004f6a:	8082                	ret

0000000080004f6c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f6c:	711d                	addi	sp,sp,-96
    80004f6e:	ec86                	sd	ra,88(sp)
    80004f70:	e8a2                	sd	s0,80(sp)
    80004f72:	e4a6                	sd	s1,72(sp)
    80004f74:	e0ca                	sd	s2,64(sp)
    80004f76:	fc4e                	sd	s3,56(sp)
    80004f78:	f852                	sd	s4,48(sp)
    80004f7a:	f456                	sd	s5,40(sp)
    80004f7c:	f05a                	sd	s6,32(sp)
    80004f7e:	1080                	addi	s0,sp,96
    80004f80:	8aaa                	mv	s5,a0
    80004f82:	8a2e                	mv	s4,a1
    80004f84:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004f86:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004f8a:	0001e517          	auipc	a0,0x1e
    80004f8e:	48650513          	addi	a0,a0,1158 # 80023410 <cons>
    80004f92:	109000ef          	jal	8000589a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004f96:	0001e497          	auipc	s1,0x1e
    80004f9a:	47a48493          	addi	s1,s1,1146 # 80023410 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004f9e:	0001e917          	auipc	s2,0x1e
    80004fa2:	50a90913          	addi	s2,s2,1290 # 800234a8 <cons+0x98>
  while(n > 0){
    80004fa6:	0b305d63          	blez	s3,80005060 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004faa:	0984a783          	lw	a5,152(s1)
    80004fae:	09c4a703          	lw	a4,156(s1)
    80004fb2:	0af71263          	bne	a4,a5,80005056 <consoleread+0xea>
      if(killed(myproc())){
    80004fb6:	df1fb0ef          	jal	80000da6 <myproc>
    80004fba:	e1cfc0ef          	jal	800015d6 <killed>
    80004fbe:	e12d                	bnez	a0,80005020 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004fc0:	85a6                	mv	a1,s1
    80004fc2:	854a                	mv	a0,s2
    80004fc4:	bdafc0ef          	jal	8000139e <sleep>
    while(cons.r == cons.w){
    80004fc8:	0984a783          	lw	a5,152(s1)
    80004fcc:	09c4a703          	lw	a4,156(s1)
    80004fd0:	fef703e3          	beq	a4,a5,80004fb6 <consoleread+0x4a>
    80004fd4:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004fd6:	0001e717          	auipc	a4,0x1e
    80004fda:	43a70713          	addi	a4,a4,1082 # 80023410 <cons>
    80004fde:	0017869b          	addiw	a3,a5,1
    80004fe2:	08d72c23          	sw	a3,152(a4)
    80004fe6:	07f7f693          	andi	a3,a5,127
    80004fea:	9736                	add	a4,a4,a3
    80004fec:	01874703          	lbu	a4,24(a4)
    80004ff0:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004ff4:	4691                	li	a3,4
    80004ff6:	04db8663          	beq	s7,a3,80005042 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004ffa:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004ffe:	4685                	li	a3,1
    80005000:	faf40613          	addi	a2,s0,-81
    80005004:	85d2                	mv	a1,s4
    80005006:	8556                	mv	a0,s5
    80005008:	ef2fc0ef          	jal	800016fa <either_copyout>
    8000500c:	57fd                	li	a5,-1
    8000500e:	04f50863          	beq	a0,a5,8000505e <consoleread+0xf2>
      break;

    dst++;
    80005012:	0a05                	addi	s4,s4,1
    --n;
    80005014:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005016:	47a9                	li	a5,10
    80005018:	04fb8d63          	beq	s7,a5,80005072 <consoleread+0x106>
    8000501c:	6be2                	ld	s7,24(sp)
    8000501e:	b761                	j	80004fa6 <consoleread+0x3a>
        release(&cons.lock);
    80005020:	0001e517          	auipc	a0,0x1e
    80005024:	3f050513          	addi	a0,a0,1008 # 80023410 <cons>
    80005028:	10b000ef          	jal	80005932 <release>
        return -1;
    8000502c:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000502e:	60e6                	ld	ra,88(sp)
    80005030:	6446                	ld	s0,80(sp)
    80005032:	64a6                	ld	s1,72(sp)
    80005034:	6906                	ld	s2,64(sp)
    80005036:	79e2                	ld	s3,56(sp)
    80005038:	7a42                	ld	s4,48(sp)
    8000503a:	7aa2                	ld	s5,40(sp)
    8000503c:	7b02                	ld	s6,32(sp)
    8000503e:	6125                	addi	sp,sp,96
    80005040:	8082                	ret
      if(n < target){
    80005042:	0009871b          	sext.w	a4,s3
    80005046:	01677a63          	bgeu	a4,s6,8000505a <consoleread+0xee>
        cons.r--;
    8000504a:	0001e717          	auipc	a4,0x1e
    8000504e:	44f72f23          	sw	a5,1118(a4) # 800234a8 <cons+0x98>
    80005052:	6be2                	ld	s7,24(sp)
    80005054:	a031                	j	80005060 <consoleread+0xf4>
    80005056:	ec5e                	sd	s7,24(sp)
    80005058:	bfbd                	j	80004fd6 <consoleread+0x6a>
    8000505a:	6be2                	ld	s7,24(sp)
    8000505c:	a011                	j	80005060 <consoleread+0xf4>
    8000505e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005060:	0001e517          	auipc	a0,0x1e
    80005064:	3b050513          	addi	a0,a0,944 # 80023410 <cons>
    80005068:	0cb000ef          	jal	80005932 <release>
  return target - n;
    8000506c:	413b053b          	subw	a0,s6,s3
    80005070:	bf7d                	j	8000502e <consoleread+0xc2>
    80005072:	6be2                	ld	s7,24(sp)
    80005074:	b7f5                	j	80005060 <consoleread+0xf4>

0000000080005076 <consputc>:
{
    80005076:	1141                	addi	sp,sp,-16
    80005078:	e406                	sd	ra,8(sp)
    8000507a:	e022                	sd	s0,0(sp)
    8000507c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000507e:	10000793          	li	a5,256
    80005082:	00f50863          	beq	a0,a5,80005092 <consputc+0x1c>
    uartputc_sync(c);
    80005086:	6a4000ef          	jal	8000572a <uartputc_sync>
}
    8000508a:	60a2                	ld	ra,8(sp)
    8000508c:	6402                	ld	s0,0(sp)
    8000508e:	0141                	addi	sp,sp,16
    80005090:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005092:	4521                	li	a0,8
    80005094:	696000ef          	jal	8000572a <uartputc_sync>
    80005098:	02000513          	li	a0,32
    8000509c:	68e000ef          	jal	8000572a <uartputc_sync>
    800050a0:	4521                	li	a0,8
    800050a2:	688000ef          	jal	8000572a <uartputc_sync>
    800050a6:	b7d5                	j	8000508a <consputc+0x14>

00000000800050a8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050a8:	1101                	addi	sp,sp,-32
    800050aa:	ec06                	sd	ra,24(sp)
    800050ac:	e822                	sd	s0,16(sp)
    800050ae:	e426                	sd	s1,8(sp)
    800050b0:	1000                	addi	s0,sp,32
    800050b2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800050b4:	0001e517          	auipc	a0,0x1e
    800050b8:	35c50513          	addi	a0,a0,860 # 80023410 <cons>
    800050bc:	7de000ef          	jal	8000589a <acquire>

  switch(c){
    800050c0:	47d5                	li	a5,21
    800050c2:	08f48f63          	beq	s1,a5,80005160 <consoleintr+0xb8>
    800050c6:	0297c563          	blt	a5,s1,800050f0 <consoleintr+0x48>
    800050ca:	47a1                	li	a5,8
    800050cc:	0ef48463          	beq	s1,a5,800051b4 <consoleintr+0x10c>
    800050d0:	47c1                	li	a5,16
    800050d2:	10f49563          	bne	s1,a5,800051dc <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800050d6:	eb8fc0ef          	jal	8000178e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800050da:	0001e517          	auipc	a0,0x1e
    800050de:	33650513          	addi	a0,a0,822 # 80023410 <cons>
    800050e2:	051000ef          	jal	80005932 <release>
}
    800050e6:	60e2                	ld	ra,24(sp)
    800050e8:	6442                	ld	s0,16(sp)
    800050ea:	64a2                	ld	s1,8(sp)
    800050ec:	6105                	addi	sp,sp,32
    800050ee:	8082                	ret
  switch(c){
    800050f0:	07f00793          	li	a5,127
    800050f4:	0cf48063          	beq	s1,a5,800051b4 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800050f8:	0001e717          	auipc	a4,0x1e
    800050fc:	31870713          	addi	a4,a4,792 # 80023410 <cons>
    80005100:	0a072783          	lw	a5,160(a4)
    80005104:	09872703          	lw	a4,152(a4)
    80005108:	9f99                	subw	a5,a5,a4
    8000510a:	07f00713          	li	a4,127
    8000510e:	fcf766e3          	bltu	a4,a5,800050da <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005112:	47b5                	li	a5,13
    80005114:	0cf48763          	beq	s1,a5,800051e2 <consoleintr+0x13a>
      consputc(c);
    80005118:	8526                	mv	a0,s1
    8000511a:	f5dff0ef          	jal	80005076 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000511e:	0001e797          	auipc	a5,0x1e
    80005122:	2f278793          	addi	a5,a5,754 # 80023410 <cons>
    80005126:	0a07a683          	lw	a3,160(a5)
    8000512a:	0016871b          	addiw	a4,a3,1
    8000512e:	0007061b          	sext.w	a2,a4
    80005132:	0ae7a023          	sw	a4,160(a5)
    80005136:	07f6f693          	andi	a3,a3,127
    8000513a:	97b6                	add	a5,a5,a3
    8000513c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005140:	47a9                	li	a5,10
    80005142:	0cf48563          	beq	s1,a5,8000520c <consoleintr+0x164>
    80005146:	4791                	li	a5,4
    80005148:	0cf48263          	beq	s1,a5,8000520c <consoleintr+0x164>
    8000514c:	0001e797          	auipc	a5,0x1e
    80005150:	35c7a783          	lw	a5,860(a5) # 800234a8 <cons+0x98>
    80005154:	9f1d                	subw	a4,a4,a5
    80005156:	08000793          	li	a5,128
    8000515a:	f8f710e3          	bne	a4,a5,800050da <consoleintr+0x32>
    8000515e:	a07d                	j	8000520c <consoleintr+0x164>
    80005160:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005162:	0001e717          	auipc	a4,0x1e
    80005166:	2ae70713          	addi	a4,a4,686 # 80023410 <cons>
    8000516a:	0a072783          	lw	a5,160(a4)
    8000516e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005172:	0001e497          	auipc	s1,0x1e
    80005176:	29e48493          	addi	s1,s1,670 # 80023410 <cons>
    while(cons.e != cons.w &&
    8000517a:	4929                	li	s2,10
    8000517c:	02f70863          	beq	a4,a5,800051ac <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005180:	37fd                	addiw	a5,a5,-1
    80005182:	07f7f713          	andi	a4,a5,127
    80005186:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005188:	01874703          	lbu	a4,24(a4)
    8000518c:	03270263          	beq	a4,s2,800051b0 <consoleintr+0x108>
      cons.e--;
    80005190:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005194:	10000513          	li	a0,256
    80005198:	edfff0ef          	jal	80005076 <consputc>
    while(cons.e != cons.w &&
    8000519c:	0a04a783          	lw	a5,160(s1)
    800051a0:	09c4a703          	lw	a4,156(s1)
    800051a4:	fcf71ee3          	bne	a4,a5,80005180 <consoleintr+0xd8>
    800051a8:	6902                	ld	s2,0(sp)
    800051aa:	bf05                	j	800050da <consoleintr+0x32>
    800051ac:	6902                	ld	s2,0(sp)
    800051ae:	b735                	j	800050da <consoleintr+0x32>
    800051b0:	6902                	ld	s2,0(sp)
    800051b2:	b725                	j	800050da <consoleintr+0x32>
    if(cons.e != cons.w){
    800051b4:	0001e717          	auipc	a4,0x1e
    800051b8:	25c70713          	addi	a4,a4,604 # 80023410 <cons>
    800051bc:	0a072783          	lw	a5,160(a4)
    800051c0:	09c72703          	lw	a4,156(a4)
    800051c4:	f0f70be3          	beq	a4,a5,800050da <consoleintr+0x32>
      cons.e--;
    800051c8:	37fd                	addiw	a5,a5,-1
    800051ca:	0001e717          	auipc	a4,0x1e
    800051ce:	2ef72323          	sw	a5,742(a4) # 800234b0 <cons+0xa0>
      consputc(BACKSPACE);
    800051d2:	10000513          	li	a0,256
    800051d6:	ea1ff0ef          	jal	80005076 <consputc>
    800051da:	b701                	j	800050da <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051dc:	ee048fe3          	beqz	s1,800050da <consoleintr+0x32>
    800051e0:	bf21                	j	800050f8 <consoleintr+0x50>
      consputc(c);
    800051e2:	4529                	li	a0,10
    800051e4:	e93ff0ef          	jal	80005076 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800051e8:	0001e797          	auipc	a5,0x1e
    800051ec:	22878793          	addi	a5,a5,552 # 80023410 <cons>
    800051f0:	0a07a703          	lw	a4,160(a5)
    800051f4:	0017069b          	addiw	a3,a4,1
    800051f8:	0006861b          	sext.w	a2,a3
    800051fc:	0ad7a023          	sw	a3,160(a5)
    80005200:	07f77713          	andi	a4,a4,127
    80005204:	97ba                	add	a5,a5,a4
    80005206:	4729                	li	a4,10
    80005208:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000520c:	0001e797          	auipc	a5,0x1e
    80005210:	2ac7a023          	sw	a2,672(a5) # 800234ac <cons+0x9c>
        wakeup(&cons.r);
    80005214:	0001e517          	auipc	a0,0x1e
    80005218:	29450513          	addi	a0,a0,660 # 800234a8 <cons+0x98>
    8000521c:	9cefc0ef          	jal	800013ea <wakeup>
    80005220:	bd6d                	j	800050da <consoleintr+0x32>

0000000080005222 <consoleinit>:

void
consoleinit(void)
{
    80005222:	1141                	addi	sp,sp,-16
    80005224:	e406                	sd	ra,8(sp)
    80005226:	e022                	sd	s0,0(sp)
    80005228:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000522a:	00002597          	auipc	a1,0x2
    8000522e:	49e58593          	addi	a1,a1,1182 # 800076c8 <etext+0x6c8>
    80005232:	0001e517          	auipc	a0,0x1e
    80005236:	1de50513          	addi	a0,a0,478 # 80023410 <cons>
    8000523a:	5e0000ef          	jal	8000581a <initlock>

  uartinit();
    8000523e:	400000ef          	jal	8000563e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005242:	00015797          	auipc	a5,0x15
    80005246:	03678793          	addi	a5,a5,54 # 8001a278 <devsw>
    8000524a:	00000717          	auipc	a4,0x0
    8000524e:	d2270713          	addi	a4,a4,-734 # 80004f6c <consoleread>
    80005252:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005254:	00000717          	auipc	a4,0x0
    80005258:	c7a70713          	addi	a4,a4,-902 # 80004ece <consolewrite>
    8000525c:	ef98                	sd	a4,24(a5)
}
    8000525e:	60a2                	ld	ra,8(sp)
    80005260:	6402                	ld	s0,0(sp)
    80005262:	0141                	addi	sp,sp,16
    80005264:	8082                	ret

0000000080005266 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005266:	7139                	addi	sp,sp,-64
    80005268:	fc06                	sd	ra,56(sp)
    8000526a:	f822                	sd	s0,48(sp)
    8000526c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000526e:	c219                	beqz	a2,80005274 <printint+0xe>
    80005270:	08054063          	bltz	a0,800052f0 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005274:	4881                	li	a7,0
    80005276:	fc840693          	addi	a3,s0,-56

  i = 0;
    8000527a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000527c:	00002617          	auipc	a2,0x2
    80005280:	5a460613          	addi	a2,a2,1444 # 80007820 <digits>
    80005284:	883e                	mv	a6,a5
    80005286:	2785                	addiw	a5,a5,1
    80005288:	02b57733          	remu	a4,a0,a1
    8000528c:	9732                	add	a4,a4,a2
    8000528e:	00074703          	lbu	a4,0(a4)
    80005292:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005296:	872a                	mv	a4,a0
    80005298:	02b55533          	divu	a0,a0,a1
    8000529c:	0685                	addi	a3,a3,1
    8000529e:	feb773e3          	bgeu	a4,a1,80005284 <printint+0x1e>

  if(sign)
    800052a2:	00088a63          	beqz	a7,800052b6 <printint+0x50>
    buf[i++] = '-';
    800052a6:	1781                	addi	a5,a5,-32
    800052a8:	97a2                	add	a5,a5,s0
    800052aa:	02d00713          	li	a4,45
    800052ae:	fee78423          	sb	a4,-24(a5)
    800052b2:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800052b6:	02f05963          	blez	a5,800052e8 <printint+0x82>
    800052ba:	f426                	sd	s1,40(sp)
    800052bc:	f04a                	sd	s2,32(sp)
    800052be:	fc840713          	addi	a4,s0,-56
    800052c2:	00f704b3          	add	s1,a4,a5
    800052c6:	fff70913          	addi	s2,a4,-1
    800052ca:	993e                	add	s2,s2,a5
    800052cc:	37fd                	addiw	a5,a5,-1
    800052ce:	1782                	slli	a5,a5,0x20
    800052d0:	9381                	srli	a5,a5,0x20
    800052d2:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800052d6:	fff4c503          	lbu	a0,-1(s1)
    800052da:	d9dff0ef          	jal	80005076 <consputc>
  while(--i >= 0)
    800052de:	14fd                	addi	s1,s1,-1
    800052e0:	ff249be3          	bne	s1,s2,800052d6 <printint+0x70>
    800052e4:	74a2                	ld	s1,40(sp)
    800052e6:	7902                	ld	s2,32(sp)
}
    800052e8:	70e2                	ld	ra,56(sp)
    800052ea:	7442                	ld	s0,48(sp)
    800052ec:	6121                	addi	sp,sp,64
    800052ee:	8082                	ret
    x = -xx;
    800052f0:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800052f4:	4885                	li	a7,1
    x = -xx;
    800052f6:	b741                	j	80005276 <printint+0x10>

00000000800052f8 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800052f8:	7131                	addi	sp,sp,-192
    800052fa:	fc86                	sd	ra,120(sp)
    800052fc:	f8a2                	sd	s0,112(sp)
    800052fe:	e8d2                	sd	s4,80(sp)
    80005300:	0100                	addi	s0,sp,128
    80005302:	8a2a                	mv	s4,a0
    80005304:	e40c                	sd	a1,8(s0)
    80005306:	e810                	sd	a2,16(s0)
    80005308:	ec14                	sd	a3,24(s0)
    8000530a:	f018                	sd	a4,32(s0)
    8000530c:	f41c                	sd	a5,40(s0)
    8000530e:	03043823          	sd	a6,48(s0)
    80005312:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80005316:	00005797          	auipc	a5,0x5
    8000531a:	eba7a783          	lw	a5,-326(a5) # 8000a1d0 <panicking>
    8000531e:	c3a1                	beqz	a5,8000535e <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005320:	00840793          	addi	a5,s0,8
    80005324:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005328:	000a4503          	lbu	a0,0(s4)
    8000532c:	28050763          	beqz	a0,800055ba <printf+0x2c2>
    80005330:	f4a6                	sd	s1,104(sp)
    80005332:	f0ca                	sd	s2,96(sp)
    80005334:	ecce                	sd	s3,88(sp)
    80005336:	e4d6                	sd	s5,72(sp)
    80005338:	e0da                	sd	s6,64(sp)
    8000533a:	f862                	sd	s8,48(sp)
    8000533c:	f466                	sd	s9,40(sp)
    8000533e:	f06a                	sd	s10,32(sp)
    80005340:	ec6e                	sd	s11,24(sp)
    80005342:	4981                	li	s3,0
    if(cx != '%'){
    80005344:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005348:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000534c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005350:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005354:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005358:	07000d93          	li	s11,112
    8000535c:	a01d                	j	80005382 <printf+0x8a>
    acquire(&pr.lock);
    8000535e:	0001e517          	auipc	a0,0x1e
    80005362:	15a50513          	addi	a0,a0,346 # 800234b8 <pr>
    80005366:	534000ef          	jal	8000589a <acquire>
    8000536a:	bf5d                	j	80005320 <printf+0x28>
      consputc(cx);
    8000536c:	d0bff0ef          	jal	80005076 <consputc>
      continue;
    80005370:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005372:	0014899b          	addiw	s3,s1,1
    80005376:	013a07b3          	add	a5,s4,s3
    8000537a:	0007c503          	lbu	a0,0(a5)
    8000537e:	20050b63          	beqz	a0,80005594 <printf+0x29c>
    if(cx != '%'){
    80005382:	ff5515e3          	bne	a0,s5,8000536c <printf+0x74>
    i++;
    80005386:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000538a:	009a07b3          	add	a5,s4,s1
    8000538e:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005392:	20090b63          	beqz	s2,800055a8 <printf+0x2b0>
    80005396:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000539a:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000539c:	c789                	beqz	a5,800053a6 <printf+0xae>
    8000539e:	009a0733          	add	a4,s4,s1
    800053a2:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800053a6:	03690963          	beq	s2,s6,800053d8 <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800053aa:	05890363          	beq	s2,s8,800053f0 <printf+0xf8>
    } else if(c0 == 'u'){
    800053ae:	0d990663          	beq	s2,s9,8000547a <printf+0x182>
    } else if(c0 == 'x'){
    800053b2:	11a90d63          	beq	s2,s10,800054cc <printf+0x1d4>
    } else if(c0 == 'p'){
    800053b6:	15b90663          	beq	s2,s11,80005502 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800053ba:	06300793          	li	a5,99
    800053be:	18f90563          	beq	s2,a5,80005548 <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    800053c2:	07300793          	li	a5,115
    800053c6:	18f90b63          	beq	s2,a5,8000555c <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800053ca:	03591b63          	bne	s2,s5,80005400 <printf+0x108>
      consputc('%');
    800053ce:	02500513          	li	a0,37
    800053d2:	ca5ff0ef          	jal	80005076 <consputc>
    800053d6:	bf71                	j	80005372 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800053d8:	f8843783          	ld	a5,-120(s0)
    800053dc:	00878713          	addi	a4,a5,8
    800053e0:	f8e43423          	sd	a4,-120(s0)
    800053e4:	4605                	li	a2,1
    800053e6:	45a9                	li	a1,10
    800053e8:	4388                	lw	a0,0(a5)
    800053ea:	e7dff0ef          	jal	80005266 <printint>
    800053ee:	b751                	j	80005372 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    800053f0:	01678f63          	beq	a5,s6,8000540e <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800053f4:	03878b63          	beq	a5,s8,8000542a <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    800053f8:	09978e63          	beq	a5,s9,80005494 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    800053fc:	0fa78563          	beq	a5,s10,800054e6 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005400:	8556                	mv	a0,s5
    80005402:	c75ff0ef          	jal	80005076 <consputc>
      consputc(c0);
    80005406:	854a                	mv	a0,s2
    80005408:	c6fff0ef          	jal	80005076 <consputc>
    8000540c:	b79d                	j	80005372 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000540e:	f8843783          	ld	a5,-120(s0)
    80005412:	00878713          	addi	a4,a5,8
    80005416:	f8e43423          	sd	a4,-120(s0)
    8000541a:	4605                	li	a2,1
    8000541c:	45a9                	li	a1,10
    8000541e:	6388                	ld	a0,0(a5)
    80005420:	e47ff0ef          	jal	80005266 <printint>
      i += 1;
    80005424:	0029849b          	addiw	s1,s3,2
    80005428:	b7a9                	j	80005372 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000542a:	06400793          	li	a5,100
    8000542e:	02f68863          	beq	a3,a5,8000545e <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005432:	07500793          	li	a5,117
    80005436:	06f68d63          	beq	a3,a5,800054b0 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000543a:	07800793          	li	a5,120
    8000543e:	fcf691e3          	bne	a3,a5,80005400 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80005442:	f8843783          	ld	a5,-120(s0)
    80005446:	00878713          	addi	a4,a5,8
    8000544a:	f8e43423          	sd	a4,-120(s0)
    8000544e:	4601                	li	a2,0
    80005450:	45c1                	li	a1,16
    80005452:	6388                	ld	a0,0(a5)
    80005454:	e13ff0ef          	jal	80005266 <printint>
      i += 2;
    80005458:	0039849b          	addiw	s1,s3,3
    8000545c:	bf19                	j	80005372 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000545e:	f8843783          	ld	a5,-120(s0)
    80005462:	00878713          	addi	a4,a5,8
    80005466:	f8e43423          	sd	a4,-120(s0)
    8000546a:	4605                	li	a2,1
    8000546c:	45a9                	li	a1,10
    8000546e:	6388                	ld	a0,0(a5)
    80005470:	df7ff0ef          	jal	80005266 <printint>
      i += 2;
    80005474:	0039849b          	addiw	s1,s3,3
    80005478:	bded                	j	80005372 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    8000547a:	f8843783          	ld	a5,-120(s0)
    8000547e:	00878713          	addi	a4,a5,8
    80005482:	f8e43423          	sd	a4,-120(s0)
    80005486:	4601                	li	a2,0
    80005488:	45a9                	li	a1,10
    8000548a:	0007e503          	lwu	a0,0(a5)
    8000548e:	dd9ff0ef          	jal	80005266 <printint>
    80005492:	b5c5                	j	80005372 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80005494:	f8843783          	ld	a5,-120(s0)
    80005498:	00878713          	addi	a4,a5,8
    8000549c:	f8e43423          	sd	a4,-120(s0)
    800054a0:	4601                	li	a2,0
    800054a2:	45a9                	li	a1,10
    800054a4:	6388                	ld	a0,0(a5)
    800054a6:	dc1ff0ef          	jal	80005266 <printint>
      i += 1;
    800054aa:	0029849b          	addiw	s1,s3,2
    800054ae:	b5d1                	j	80005372 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800054b0:	f8843783          	ld	a5,-120(s0)
    800054b4:	00878713          	addi	a4,a5,8
    800054b8:	f8e43423          	sd	a4,-120(s0)
    800054bc:	4601                	li	a2,0
    800054be:	45a9                	li	a1,10
    800054c0:	6388                	ld	a0,0(a5)
    800054c2:	da5ff0ef          	jal	80005266 <printint>
      i += 2;
    800054c6:	0039849b          	addiw	s1,s3,3
    800054ca:	b565                	j	80005372 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800054cc:	f8843783          	ld	a5,-120(s0)
    800054d0:	00878713          	addi	a4,a5,8
    800054d4:	f8e43423          	sd	a4,-120(s0)
    800054d8:	4601                	li	a2,0
    800054da:	45c1                	li	a1,16
    800054dc:	0007e503          	lwu	a0,0(a5)
    800054e0:	d87ff0ef          	jal	80005266 <printint>
    800054e4:	b579                	j	80005372 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800054e6:	f8843783          	ld	a5,-120(s0)
    800054ea:	00878713          	addi	a4,a5,8
    800054ee:	f8e43423          	sd	a4,-120(s0)
    800054f2:	4601                	li	a2,0
    800054f4:	45c1                	li	a1,16
    800054f6:	6388                	ld	a0,0(a5)
    800054f8:	d6fff0ef          	jal	80005266 <printint>
      i += 1;
    800054fc:	0029849b          	addiw	s1,s3,2
    80005500:	bd8d                	j	80005372 <printf+0x7a>
    80005502:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80005504:	f8843783          	ld	a5,-120(s0)
    80005508:	00878713          	addi	a4,a5,8
    8000550c:	f8e43423          	sd	a4,-120(s0)
    80005510:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005514:	03000513          	li	a0,48
    80005518:	b5fff0ef          	jal	80005076 <consputc>
  consputc('x');
    8000551c:	07800513          	li	a0,120
    80005520:	b57ff0ef          	jal	80005076 <consputc>
    80005524:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005526:	00002b97          	auipc	s7,0x2
    8000552a:	2fab8b93          	addi	s7,s7,762 # 80007820 <digits>
    8000552e:	03c9d793          	srli	a5,s3,0x3c
    80005532:	97de                	add	a5,a5,s7
    80005534:	0007c503          	lbu	a0,0(a5)
    80005538:	b3fff0ef          	jal	80005076 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000553c:	0992                	slli	s3,s3,0x4
    8000553e:	397d                	addiw	s2,s2,-1
    80005540:	fe0917e3          	bnez	s2,8000552e <printf+0x236>
    80005544:	7be2                	ld	s7,56(sp)
    80005546:	b535                	j	80005372 <printf+0x7a>
      consputc(va_arg(ap, uint));
    80005548:	f8843783          	ld	a5,-120(s0)
    8000554c:	00878713          	addi	a4,a5,8
    80005550:	f8e43423          	sd	a4,-120(s0)
    80005554:	4388                	lw	a0,0(a5)
    80005556:	b21ff0ef          	jal	80005076 <consputc>
    8000555a:	bd21                	j	80005372 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    8000555c:	f8843783          	ld	a5,-120(s0)
    80005560:	00878713          	addi	a4,a5,8
    80005564:	f8e43423          	sd	a4,-120(s0)
    80005568:	0007b903          	ld	s2,0(a5)
    8000556c:	00090d63          	beqz	s2,80005586 <printf+0x28e>
      for(; *s; s++)
    80005570:	00094503          	lbu	a0,0(s2)
    80005574:	de050fe3          	beqz	a0,80005372 <printf+0x7a>
        consputc(*s);
    80005578:	affff0ef          	jal	80005076 <consputc>
      for(; *s; s++)
    8000557c:	0905                	addi	s2,s2,1
    8000557e:	00094503          	lbu	a0,0(s2)
    80005582:	f97d                	bnez	a0,80005578 <printf+0x280>
    80005584:	b3fd                	j	80005372 <printf+0x7a>
        s = "(null)";
    80005586:	00002917          	auipc	s2,0x2
    8000558a:	14a90913          	addi	s2,s2,330 # 800076d0 <etext+0x6d0>
      for(; *s; s++)
    8000558e:	02800513          	li	a0,40
    80005592:	b7dd                	j	80005578 <printf+0x280>
    80005594:	74a6                	ld	s1,104(sp)
    80005596:	7906                	ld	s2,96(sp)
    80005598:	69e6                	ld	s3,88(sp)
    8000559a:	6aa6                	ld	s5,72(sp)
    8000559c:	6b06                	ld	s6,64(sp)
    8000559e:	7c42                	ld	s8,48(sp)
    800055a0:	7ca2                	ld	s9,40(sp)
    800055a2:	7d02                	ld	s10,32(sp)
    800055a4:	6de2                	ld	s11,24(sp)
    800055a6:	a811                	j	800055ba <printf+0x2c2>
    800055a8:	74a6                	ld	s1,104(sp)
    800055aa:	7906                	ld	s2,96(sp)
    800055ac:	69e6                	ld	s3,88(sp)
    800055ae:	6aa6                	ld	s5,72(sp)
    800055b0:	6b06                	ld	s6,64(sp)
    800055b2:	7c42                	ld	s8,48(sp)
    800055b4:	7ca2                	ld	s9,40(sp)
    800055b6:	7d02                	ld	s10,32(sp)
    800055b8:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800055ba:	00005797          	auipc	a5,0x5
    800055be:	c167a783          	lw	a5,-1002(a5) # 8000a1d0 <panicking>
    800055c2:	c799                	beqz	a5,800055d0 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    800055c4:	4501                	li	a0,0
    800055c6:	70e6                	ld	ra,120(sp)
    800055c8:	7446                	ld	s0,112(sp)
    800055ca:	6a46                	ld	s4,80(sp)
    800055cc:	6129                	addi	sp,sp,192
    800055ce:	8082                	ret
    release(&pr.lock);
    800055d0:	0001e517          	auipc	a0,0x1e
    800055d4:	ee850513          	addi	a0,a0,-280 # 800234b8 <pr>
    800055d8:	35a000ef          	jal	80005932 <release>
  return 0;
    800055dc:	b7e5                	j	800055c4 <printf+0x2cc>

00000000800055de <panic>:

void
panic(char *s)
{
    800055de:	1101                	addi	sp,sp,-32
    800055e0:	ec06                	sd	ra,24(sp)
    800055e2:	e822                	sd	s0,16(sp)
    800055e4:	e426                	sd	s1,8(sp)
    800055e6:	e04a                	sd	s2,0(sp)
    800055e8:	1000                	addi	s0,sp,32
    800055ea:	84aa                	mv	s1,a0
  panicking = 1;
    800055ec:	4905                	li	s2,1
    800055ee:	00005797          	auipc	a5,0x5
    800055f2:	bf27a123          	sw	s2,-1054(a5) # 8000a1d0 <panicking>
  printf("panic: ");
    800055f6:	00002517          	auipc	a0,0x2
    800055fa:	0e250513          	addi	a0,a0,226 # 800076d8 <etext+0x6d8>
    800055fe:	cfbff0ef          	jal	800052f8 <printf>
  printf("%s\n", s);
    80005602:	85a6                	mv	a1,s1
    80005604:	00002517          	auipc	a0,0x2
    80005608:	0dc50513          	addi	a0,a0,220 # 800076e0 <etext+0x6e0>
    8000560c:	cedff0ef          	jal	800052f8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005610:	00005797          	auipc	a5,0x5
    80005614:	bb27ae23          	sw	s2,-1092(a5) # 8000a1cc <panicked>
  for(;;)
    80005618:	a001                	j	80005618 <panic+0x3a>

000000008000561a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000561a:	1141                	addi	sp,sp,-16
    8000561c:	e406                	sd	ra,8(sp)
    8000561e:	e022                	sd	s0,0(sp)
    80005620:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005622:	00002597          	auipc	a1,0x2
    80005626:	0c658593          	addi	a1,a1,198 # 800076e8 <etext+0x6e8>
    8000562a:	0001e517          	auipc	a0,0x1e
    8000562e:	e8e50513          	addi	a0,a0,-370 # 800234b8 <pr>
    80005632:	1e8000ef          	jal	8000581a <initlock>
}
    80005636:	60a2                	ld	ra,8(sp)
    80005638:	6402                	ld	s0,0(sp)
    8000563a:	0141                	addi	sp,sp,16
    8000563c:	8082                	ret

000000008000563e <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    8000563e:	1141                	addi	sp,sp,-16
    80005640:	e406                	sd	ra,8(sp)
    80005642:	e022                	sd	s0,0(sp)
    80005644:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005646:	100007b7          	lui	a5,0x10000
    8000564a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000564e:	10000737          	lui	a4,0x10000
    80005652:	f8000693          	li	a3,-128
    80005656:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000565a:	468d                	li	a3,3
    8000565c:	10000637          	lui	a2,0x10000
    80005660:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005664:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005668:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000566c:	10000737          	lui	a4,0x10000
    80005670:	461d                	li	a2,7
    80005672:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005676:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    8000567a:	00002597          	auipc	a1,0x2
    8000567e:	07658593          	addi	a1,a1,118 # 800076f0 <etext+0x6f0>
    80005682:	0001e517          	auipc	a0,0x1e
    80005686:	e4e50513          	addi	a0,a0,-434 # 800234d0 <tx_lock>
    8000568a:	190000ef          	jal	8000581a <initlock>
}
    8000568e:	60a2                	ld	ra,8(sp)
    80005690:	6402                	ld	s0,0(sp)
    80005692:	0141                	addi	sp,sp,16
    80005694:	8082                	ret

0000000080005696 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005696:	715d                	addi	sp,sp,-80
    80005698:	e486                	sd	ra,72(sp)
    8000569a:	e0a2                	sd	s0,64(sp)
    8000569c:	fc26                	sd	s1,56(sp)
    8000569e:	ec56                	sd	s5,24(sp)
    800056a0:	0880                	addi	s0,sp,80
    800056a2:	8aaa                	mv	s5,a0
    800056a4:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800056a6:	0001e517          	auipc	a0,0x1e
    800056aa:	e2a50513          	addi	a0,a0,-470 # 800234d0 <tx_lock>
    800056ae:	1ec000ef          	jal	8000589a <acquire>

  int i = 0;
  while(i < n){ 
    800056b2:	06905063          	blez	s1,80005712 <uartwrite+0x7c>
    800056b6:	f84a                	sd	s2,48(sp)
    800056b8:	f44e                	sd	s3,40(sp)
    800056ba:	f052                	sd	s4,32(sp)
    800056bc:	e85a                	sd	s6,16(sp)
    800056be:	e45e                	sd	s7,8(sp)
    800056c0:	8a56                	mv	s4,s5
    800056c2:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    800056c4:	00005497          	auipc	s1,0x5
    800056c8:	b1448493          	addi	s1,s1,-1260 # 8000a1d8 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800056cc:	0001e997          	auipc	s3,0x1e
    800056d0:	e0498993          	addi	s3,s3,-508 # 800234d0 <tx_lock>
    800056d4:	00005917          	auipc	s2,0x5
    800056d8:	b0090913          	addi	s2,s2,-1280 # 8000a1d4 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    800056dc:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    800056e0:	4b05                	li	s6,1
    800056e2:	a005                	j	80005702 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    800056e4:	85ce                	mv	a1,s3
    800056e6:	854a                	mv	a0,s2
    800056e8:	cb7fb0ef          	jal	8000139e <sleep>
    while(tx_busy != 0){
    800056ec:	409c                	lw	a5,0(s1)
    800056ee:	fbfd                	bnez	a5,800056e4 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800056f0:	000a4783          	lbu	a5,0(s4)
    800056f4:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800056f8:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800056fc:	0a05                	addi	s4,s4,1
    800056fe:	015a0563          	beq	s4,s5,80005708 <uartwrite+0x72>
    while(tx_busy != 0){
    80005702:	409c                	lw	a5,0(s1)
    80005704:	f3e5                	bnez	a5,800056e4 <uartwrite+0x4e>
    80005706:	b7ed                	j	800056f0 <uartwrite+0x5a>
    80005708:	7942                	ld	s2,48(sp)
    8000570a:	79a2                	ld	s3,40(sp)
    8000570c:	7a02                	ld	s4,32(sp)
    8000570e:	6b42                	ld	s6,16(sp)
    80005710:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005712:	0001e517          	auipc	a0,0x1e
    80005716:	dbe50513          	addi	a0,a0,-578 # 800234d0 <tx_lock>
    8000571a:	218000ef          	jal	80005932 <release>
}
    8000571e:	60a6                	ld	ra,72(sp)
    80005720:	6406                	ld	s0,64(sp)
    80005722:	74e2                	ld	s1,56(sp)
    80005724:	6ae2                	ld	s5,24(sp)
    80005726:	6161                	addi	sp,sp,80
    80005728:	8082                	ret

000000008000572a <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000572a:	1101                	addi	sp,sp,-32
    8000572c:	ec06                	sd	ra,24(sp)
    8000572e:	e822                	sd	s0,16(sp)
    80005730:	e426                	sd	s1,8(sp)
    80005732:	1000                	addi	s0,sp,32
    80005734:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005736:	00005797          	auipc	a5,0x5
    8000573a:	a9a7a783          	lw	a5,-1382(a5) # 8000a1d0 <panicking>
    8000573e:	cf95                	beqz	a5,8000577a <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005740:	00005797          	auipc	a5,0x5
    80005744:	a8c7a783          	lw	a5,-1396(a5) # 8000a1cc <panicked>
    80005748:	ef85                	bnez	a5,80005780 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000574a:	10000737          	lui	a4,0x10000
    8000574e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005750:	00074783          	lbu	a5,0(a4)
    80005754:	0207f793          	andi	a5,a5,32
    80005758:	dfe5                	beqz	a5,80005750 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000575a:	0ff4f513          	zext.b	a0,s1
    8000575e:	100007b7          	lui	a5,0x10000
    80005762:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005766:	00005797          	auipc	a5,0x5
    8000576a:	a6a7a783          	lw	a5,-1430(a5) # 8000a1d0 <panicking>
    8000576e:	cb91                	beqz	a5,80005782 <uartputc_sync+0x58>
    pop_off();
}
    80005770:	60e2                	ld	ra,24(sp)
    80005772:	6442                	ld	s0,16(sp)
    80005774:	64a2                	ld	s1,8(sp)
    80005776:	6105                	addi	sp,sp,32
    80005778:	8082                	ret
    push_off();
    8000577a:	0e0000ef          	jal	8000585a <push_off>
    8000577e:	b7c9                	j	80005740 <uartputc_sync+0x16>
    for(;;)
    80005780:	a001                	j	80005780 <uartputc_sync+0x56>
    pop_off();
    80005782:	15c000ef          	jal	800058de <pop_off>
}
    80005786:	b7ed                	j	80005770 <uartputc_sync+0x46>

0000000080005788 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005788:	1141                	addi	sp,sp,-16
    8000578a:	e422                	sd	s0,8(sp)
    8000578c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    8000578e:	100007b7          	lui	a5,0x10000
    80005792:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005794:	0007c783          	lbu	a5,0(a5)
    80005798:	8b85                	andi	a5,a5,1
    8000579a:	cb81                	beqz	a5,800057aa <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000579c:	100007b7          	lui	a5,0x10000
    800057a0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800057a4:	6422                	ld	s0,8(sp)
    800057a6:	0141                	addi	sp,sp,16
    800057a8:	8082                	ret
    return -1;
    800057aa:	557d                	li	a0,-1
    800057ac:	bfe5                	j	800057a4 <uartgetc+0x1c>

00000000800057ae <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800057ae:	1101                	addi	sp,sp,-32
    800057b0:	ec06                	sd	ra,24(sp)
    800057b2:	e822                	sd	s0,16(sp)
    800057b4:	e426                	sd	s1,8(sp)
    800057b6:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800057b8:	100007b7          	lui	a5,0x10000
    800057bc:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800057be:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    800057c2:	0001e517          	auipc	a0,0x1e
    800057c6:	d0e50513          	addi	a0,a0,-754 # 800234d0 <tx_lock>
    800057ca:	0d0000ef          	jal	8000589a <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    800057ce:	100007b7          	lui	a5,0x10000
    800057d2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800057d4:	0007c783          	lbu	a5,0(a5)
    800057d8:	0207f793          	andi	a5,a5,32
    800057dc:	eb89                	bnez	a5,800057ee <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800057de:	0001e517          	auipc	a0,0x1e
    800057e2:	cf250513          	addi	a0,a0,-782 # 800234d0 <tx_lock>
    800057e6:	14c000ef          	jal	80005932 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800057ea:	54fd                	li	s1,-1
    800057ec:	a831                	j	80005808 <uartintr+0x5a>
    tx_busy = 0;
    800057ee:	00005797          	auipc	a5,0x5
    800057f2:	9e07a523          	sw	zero,-1558(a5) # 8000a1d8 <tx_busy>
    wakeup(&tx_chan);
    800057f6:	00005517          	auipc	a0,0x5
    800057fa:	9de50513          	addi	a0,a0,-1570 # 8000a1d4 <tx_chan>
    800057fe:	bedfb0ef          	jal	800013ea <wakeup>
    80005802:	bff1                	j	800057de <uartintr+0x30>
      break;
    consoleintr(c);
    80005804:	8a5ff0ef          	jal	800050a8 <consoleintr>
    int c = uartgetc();
    80005808:	f81ff0ef          	jal	80005788 <uartgetc>
    if(c == -1)
    8000580c:	fe951ce3          	bne	a0,s1,80005804 <uartintr+0x56>
  }
}
    80005810:	60e2                	ld	ra,24(sp)
    80005812:	6442                	ld	s0,16(sp)
    80005814:	64a2                	ld	s1,8(sp)
    80005816:	6105                	addi	sp,sp,32
    80005818:	8082                	ret

000000008000581a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000581a:	1141                	addi	sp,sp,-16
    8000581c:	e422                	sd	s0,8(sp)
    8000581e:	0800                	addi	s0,sp,16
  lk->name = name;
    80005820:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005822:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005826:	00053823          	sd	zero,16(a0)
}
    8000582a:	6422                	ld	s0,8(sp)
    8000582c:	0141                	addi	sp,sp,16
    8000582e:	8082                	ret

0000000080005830 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005830:	411c                	lw	a5,0(a0)
    80005832:	e399                	bnez	a5,80005838 <holding+0x8>
    80005834:	4501                	li	a0,0
  return r;
}
    80005836:	8082                	ret
{
    80005838:	1101                	addi	sp,sp,-32
    8000583a:	ec06                	sd	ra,24(sp)
    8000583c:	e822                	sd	s0,16(sp)
    8000583e:	e426                	sd	s1,8(sp)
    80005840:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005842:	6904                	ld	s1,16(a0)
    80005844:	d46fb0ef          	jal	80000d8a <mycpu>
    80005848:	40a48533          	sub	a0,s1,a0
    8000584c:	00153513          	seqz	a0,a0
}
    80005850:	60e2                	ld	ra,24(sp)
    80005852:	6442                	ld	s0,16(sp)
    80005854:	64a2                	ld	s1,8(sp)
    80005856:	6105                	addi	sp,sp,32
    80005858:	8082                	ret

000000008000585a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000585a:	1101                	addi	sp,sp,-32
    8000585c:	ec06                	sd	ra,24(sp)
    8000585e:	e822                	sd	s0,16(sp)
    80005860:	e426                	sd	s1,8(sp)
    80005862:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005864:	100024f3          	csrr	s1,sstatus
    80005868:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000586c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000586e:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005872:	d18fb0ef          	jal	80000d8a <mycpu>
    80005876:	5d3c                	lw	a5,120(a0)
    80005878:	cb99                	beqz	a5,8000588e <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000587a:	d10fb0ef          	jal	80000d8a <mycpu>
    8000587e:	5d3c                	lw	a5,120(a0)
    80005880:	2785                	addiw	a5,a5,1
    80005882:	dd3c                	sw	a5,120(a0)
}
    80005884:	60e2                	ld	ra,24(sp)
    80005886:	6442                	ld	s0,16(sp)
    80005888:	64a2                	ld	s1,8(sp)
    8000588a:	6105                	addi	sp,sp,32
    8000588c:	8082                	ret
    mycpu()->intena = old;
    8000588e:	cfcfb0ef          	jal	80000d8a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005892:	8085                	srli	s1,s1,0x1
    80005894:	8885                	andi	s1,s1,1
    80005896:	dd64                	sw	s1,124(a0)
    80005898:	b7cd                	j	8000587a <push_off+0x20>

000000008000589a <acquire>:
{
    8000589a:	1101                	addi	sp,sp,-32
    8000589c:	ec06                	sd	ra,24(sp)
    8000589e:	e822                	sd	s0,16(sp)
    800058a0:	e426                	sd	s1,8(sp)
    800058a2:	1000                	addi	s0,sp,32
    800058a4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800058a6:	fb5ff0ef          	jal	8000585a <push_off>
  if(holding(lk))
    800058aa:	8526                	mv	a0,s1
    800058ac:	f85ff0ef          	jal	80005830 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058b0:	4705                	li	a4,1
  if(holding(lk))
    800058b2:	e105                	bnez	a0,800058d2 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058b4:	87ba                	mv	a5,a4
    800058b6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800058ba:	2781                	sext.w	a5,a5
    800058bc:	ffe5                	bnez	a5,800058b4 <acquire+0x1a>
  __sync_synchronize();
    800058be:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800058c2:	cc8fb0ef          	jal	80000d8a <mycpu>
    800058c6:	e888                	sd	a0,16(s1)
}
    800058c8:	60e2                	ld	ra,24(sp)
    800058ca:	6442                	ld	s0,16(sp)
    800058cc:	64a2                	ld	s1,8(sp)
    800058ce:	6105                	addi	sp,sp,32
    800058d0:	8082                	ret
    panic("acquire");
    800058d2:	00002517          	auipc	a0,0x2
    800058d6:	e2650513          	addi	a0,a0,-474 # 800076f8 <etext+0x6f8>
    800058da:	d05ff0ef          	jal	800055de <panic>

00000000800058de <pop_off>:

void
pop_off(void)
{
    800058de:	1141                	addi	sp,sp,-16
    800058e0:	e406                	sd	ra,8(sp)
    800058e2:	e022                	sd	s0,0(sp)
    800058e4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800058e6:	ca4fb0ef          	jal	80000d8a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058ea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800058ee:	8b89                	andi	a5,a5,2
  if(intr_get())
    800058f0:	e78d                	bnez	a5,8000591a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800058f2:	5d3c                	lw	a5,120(a0)
    800058f4:	02f05963          	blez	a5,80005926 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    800058f8:	37fd                	addiw	a5,a5,-1
    800058fa:	0007871b          	sext.w	a4,a5
    800058fe:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005900:	eb09                	bnez	a4,80005912 <pop_off+0x34>
    80005902:	5d7c                	lw	a5,124(a0)
    80005904:	c799                	beqz	a5,80005912 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005906:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000590a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000590e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005912:	60a2                	ld	ra,8(sp)
    80005914:	6402                	ld	s0,0(sp)
    80005916:	0141                	addi	sp,sp,16
    80005918:	8082                	ret
    panic("pop_off - interruptible");
    8000591a:	00002517          	auipc	a0,0x2
    8000591e:	de650513          	addi	a0,a0,-538 # 80007700 <etext+0x700>
    80005922:	cbdff0ef          	jal	800055de <panic>
    panic("pop_off");
    80005926:	00002517          	auipc	a0,0x2
    8000592a:	df250513          	addi	a0,a0,-526 # 80007718 <etext+0x718>
    8000592e:	cb1ff0ef          	jal	800055de <panic>

0000000080005932 <release>:
{
    80005932:	1101                	addi	sp,sp,-32
    80005934:	ec06                	sd	ra,24(sp)
    80005936:	e822                	sd	s0,16(sp)
    80005938:	e426                	sd	s1,8(sp)
    8000593a:	1000                	addi	s0,sp,32
    8000593c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000593e:	ef3ff0ef          	jal	80005830 <holding>
    80005942:	c105                	beqz	a0,80005962 <release+0x30>
  lk->cpu = 0;
    80005944:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005948:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000594c:	0310000f          	fence	rw,w
    80005950:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005954:	f8bff0ef          	jal	800058de <pop_off>
}
    80005958:	60e2                	ld	ra,24(sp)
    8000595a:	6442                	ld	s0,16(sp)
    8000595c:	64a2                	ld	s1,8(sp)
    8000595e:	6105                	addi	sp,sp,32
    80005960:	8082                	ret
    panic("release");
    80005962:	00002517          	auipc	a0,0x2
    80005966:	dbe50513          	addi	a0,a0,-578 # 80007720 <etext+0x720>
    8000596a:	c75ff0ef          	jal	800055de <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
