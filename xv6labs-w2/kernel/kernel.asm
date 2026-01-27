
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
    80000004:	1c813103          	ld	sp,456(sp) # 8000a1c8 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000034:	4e878793          	addi	a5,a5,1256 # 80023518 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	1c490913          	addi	s2,s2,452 # 8000a210 <kmem>
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
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
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
    800000de:	13650513          	addi	a0,a0,310 # 8000a210 <kmem>
    800000e2:	738050ef          	jal	8000581a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	42e50513          	addi	a0,a0,1070 # 80023518 <end>
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
    8000010c:	10848493          	addi	s1,s1,264 # 8000a210 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	788050ef          	jal	8000589a <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	0f450513          	addi	a0,a0,244 # 8000a210 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	00d050ef          	jal	80005932 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
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
    80000144:	0d050513          	addi	a0,a0,208 # 8000a210 <kmem>
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
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdbae9>
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
    800002f0:	25f000ef          	jal	80000d4e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	0000a717          	auipc	a4,0xa
    800002f8:	eec70713          	addi	a4,a4,-276 # 8000a1e0 <started>
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
    80000308:	247000ef          	jal	80000d4e <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	7e3040ef          	jal	800052f8 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	576010ef          	jal	80001894 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	556040ef          	jal	80004878 <plicinithart>
  }

  scheduler();        
    80000326:	6b5000ef          	jal	800011da <scheduler>
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
    80000362:	137000ef          	jal	80000c98 <procinit>
    trapinit();      // trap vectors
    80000366:	50a010ef          	jal	80001870 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	52a010ef          	jal	80001894 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	4f0040ef          	jal	8000485e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	506040ef          	jal	80004878 <plicinithart>
    binit();         // buffer cache
    80000376:	3cf010ef          	jal	80001f44 <binit>
    iinit();         // inode table
    8000037a:	154020ef          	jal	800024ce <iinit>
    fileinit();      // file table
    8000037e:	046030ef          	jal	800033c4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	5e6040ef          	jal	80004968 <virtio_disk_init>
    userinit();      // first user process
    80000386:	4bb000ef          	jal	80001040 <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	e4f72823          	sw	a5,-432(a4) # 8000a1e0 <started>
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
    800003a8:	e447b783          	ld	a5,-444(a5) # 8000a1e8 <kernel_pagetable>
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
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
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
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdbadf>
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
    80000612:	5ee000ef          	jal	80000c00 <proc_mapstacks>
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
    80000634:	baa7bc23          	sd	a0,-1096(a5) # 8000a1e8 <kernel_pagetable>
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
    80000666:	7139                	addi	sp,sp,-64
    80000668:	fc06                	sd	ra,56(sp)
    8000066a:	f822                	sd	s0,48(sp)
    8000066c:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000066e:	03459793          	slli	a5,a1,0x34
    80000672:	e38d                	bnez	a5,80000694 <uvmunmap+0x2e>
    80000674:	f04a                	sd	s2,32(sp)
    80000676:	ec4e                	sd	s3,24(sp)
    80000678:	e852                	sd	s4,16(sp)
    8000067a:	e456                	sd	s5,8(sp)
    8000067c:	e05a                	sd	s6,0(sp)
    8000067e:	8a2a                	mv	s4,a0
    80000680:	892e                	mv	s2,a1
    80000682:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000684:	0632                	slli	a2,a2,0xc
    80000686:	00b609b3          	add	s3,a2,a1
    8000068a:	6b05                	lui	s6,0x1
    8000068c:	0535f963          	bgeu	a1,s3,800006de <uvmunmap+0x78>
    80000690:	f426                	sd	s1,40(sp)
    80000692:	a015                	j	800006b6 <uvmunmap+0x50>
    80000694:	f426                	sd	s1,40(sp)
    80000696:	f04a                	sd	s2,32(sp)
    80000698:	ec4e                	sd	s3,24(sp)
    8000069a:	e852                	sd	s4,16(sp)
    8000069c:	e456                	sd	s5,8(sp)
    8000069e:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	737040ef          	jal	800055de <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006ac:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006b0:	995a                	add	s2,s2,s6
    800006b2:	03397563          	bgeu	s2,s3,800006dc <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006b6:	4601                	li	a2,0
    800006b8:	85ca                	mv	a1,s2
    800006ba:	8552                	mv	a0,s4
    800006bc:	d07ff0ef          	jal	800003c2 <walk>
    800006c0:	84aa                	mv	s1,a0
    800006c2:	d57d                	beqz	a0,800006b0 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006c4:	611c                	ld	a5,0(a0)
    800006c6:	0017f713          	andi	a4,a5,1
    800006ca:	d37d                	beqz	a4,800006b0 <uvmunmap+0x4a>
    if(do_free){
    800006cc:	fe0a80e3          	beqz	s5,800006ac <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    800006d0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800006d2:	00c79513          	slli	a0,a5,0xc
    800006d6:	947ff0ef          	jal	8000001c <kfree>
    800006da:	bfc9                	j	800006ac <uvmunmap+0x46>
    800006dc:	74a2                	ld	s1,40(sp)
    800006de:	7902                	ld	s2,32(sp)
    800006e0:	69e2                	ld	s3,24(sp)
    800006e2:	6a42                	ld	s4,16(sp)
    800006e4:	6aa2                	ld	s5,8(sp)
    800006e6:	6b02                	ld	s6,0(sp)
  }
}
    800006e8:	70e2                	ld	ra,56(sp)
    800006ea:	7442                	ld	s0,48(sp)
    800006ec:	6121                	addi	sp,sp,64
    800006ee:	8082                	ret

00000000800006f0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800006f0:	1101                	addi	sp,sp,-32
    800006f2:	ec06                	sd	ra,24(sp)
    800006f4:	e822                	sd	s0,16(sp)
    800006f6:	e426                	sd	s1,8(sp)
    800006f8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800006fa:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800006fc:	00b67d63          	bgeu	a2,a1,80000716 <uvmdealloc+0x26>
    80000700:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000702:	6785                	lui	a5,0x1
    80000704:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000706:	00f60733          	add	a4,a2,a5
    8000070a:	76fd                	lui	a3,0xfffff
    8000070c:	8f75                	and	a4,a4,a3
    8000070e:	97ae                	add	a5,a5,a1
    80000710:	8ff5                	and	a5,a5,a3
    80000712:	00f76863          	bltu	a4,a5,80000722 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000716:	8526                	mv	a0,s1
    80000718:	60e2                	ld	ra,24(sp)
    8000071a:	6442                	ld	s0,16(sp)
    8000071c:	64a2                	ld	s1,8(sp)
    8000071e:	6105                	addi	sp,sp,32
    80000720:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000722:	8f99                	sub	a5,a5,a4
    80000724:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000726:	4685                	li	a3,1
    80000728:	0007861b          	sext.w	a2,a5
    8000072c:	85ba                	mv	a1,a4
    8000072e:	f39ff0ef          	jal	80000666 <uvmunmap>
    80000732:	b7d5                	j	80000716 <uvmdealloc+0x26>

0000000080000734 <uvmalloc>:
  if(newsz < oldsz)
    80000734:	08b66f63          	bltu	a2,a1,800007d2 <uvmalloc+0x9e>
{
    80000738:	7139                	addi	sp,sp,-64
    8000073a:	fc06                	sd	ra,56(sp)
    8000073c:	f822                	sd	s0,48(sp)
    8000073e:	ec4e                	sd	s3,24(sp)
    80000740:	e852                	sd	s4,16(sp)
    80000742:	e456                	sd	s5,8(sp)
    80000744:	0080                	addi	s0,sp,64
    80000746:	8aaa                	mv	s5,a0
    80000748:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000074a:	6785                	lui	a5,0x1
    8000074c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000074e:	95be                	add	a1,a1,a5
    80000750:	77fd                	lui	a5,0xfffff
    80000752:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000756:	08c9f063          	bgeu	s3,a2,800007d6 <uvmalloc+0xa2>
    8000075a:	f426                	sd	s1,40(sp)
    8000075c:	f04a                	sd	s2,32(sp)
    8000075e:	e05a                	sd	s6,0(sp)
    80000760:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000762:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000766:	999ff0ef          	jal	800000fe <kalloc>
    8000076a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000076c:	c515                	beqz	a0,80000798 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000076e:	6605                	lui	a2,0x1
    80000770:	4581                	li	a1,0
    80000772:	9ddff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000776:	875a                	mv	a4,s6
    80000778:	86a6                	mv	a3,s1
    8000077a:	6605                	lui	a2,0x1
    8000077c:	85ca                	mv	a1,s2
    8000077e:	8556                	mv	a0,s5
    80000780:	d1bff0ef          	jal	8000049a <mappages>
    80000784:	e915                	bnez	a0,800007b8 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000786:	6785                	lui	a5,0x1
    80000788:	993e                	add	s2,s2,a5
    8000078a:	fd496ee3          	bltu	s2,s4,80000766 <uvmalloc+0x32>
  return newsz;
    8000078e:	8552                	mv	a0,s4
    80000790:	74a2                	ld	s1,40(sp)
    80000792:	7902                	ld	s2,32(sp)
    80000794:	6b02                	ld	s6,0(sp)
    80000796:	a811                	j	800007aa <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000798:	864e                	mv	a2,s3
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8556                	mv	a0,s5
    8000079e:	f53ff0ef          	jal	800006f0 <uvmdealloc>
      return 0;
    800007a2:	4501                	li	a0,0
    800007a4:	74a2                	ld	s1,40(sp)
    800007a6:	7902                	ld	s2,32(sp)
    800007a8:	6b02                	ld	s6,0(sp)
}
    800007aa:	70e2                	ld	ra,56(sp)
    800007ac:	7442                	ld	s0,48(sp)
    800007ae:	69e2                	ld	s3,24(sp)
    800007b0:	6a42                	ld	s4,16(sp)
    800007b2:	6aa2                	ld	s5,8(sp)
    800007b4:	6121                	addi	sp,sp,64
    800007b6:	8082                	ret
      kfree(mem);
    800007b8:	8526                	mv	a0,s1
    800007ba:	863ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007be:	864e                	mv	a2,s3
    800007c0:	85ca                	mv	a1,s2
    800007c2:	8556                	mv	a0,s5
    800007c4:	f2dff0ef          	jal	800006f0 <uvmdealloc>
      return 0;
    800007c8:	4501                	li	a0,0
    800007ca:	74a2                	ld	s1,40(sp)
    800007cc:	7902                	ld	s2,32(sp)
    800007ce:	6b02                	ld	s6,0(sp)
    800007d0:	bfe9                	j	800007aa <uvmalloc+0x76>
    return oldsz;
    800007d2:	852e                	mv	a0,a1
}
    800007d4:	8082                	ret
  return newsz;
    800007d6:	8532                	mv	a0,a2
    800007d8:	bfc9                	j	800007aa <uvmalloc+0x76>

00000000800007da <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800007da:	7179                	addi	sp,sp,-48
    800007dc:	f406                	sd	ra,40(sp)
    800007de:	f022                	sd	s0,32(sp)
    800007e0:	ec26                	sd	s1,24(sp)
    800007e2:	e84a                	sd	s2,16(sp)
    800007e4:	e44e                	sd	s3,8(sp)
    800007e6:	e052                	sd	s4,0(sp)
    800007e8:	1800                	addi	s0,sp,48
    800007ea:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800007ec:	84aa                	mv	s1,a0
    800007ee:	6905                	lui	s2,0x1
    800007f0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800007f2:	4985                	li	s3,1
    800007f4:	a819                	j	8000080a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800007f6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800007f8:	00c79513          	slli	a0,a5,0xc
    800007fc:	fdfff0ef          	jal	800007da <freewalk>
      pagetable[i] = 0;
    80000800:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000804:	04a1                	addi	s1,s1,8
    80000806:	01248f63          	beq	s1,s2,80000824 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000080a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000080c:	00f7f713          	andi	a4,a5,15
    80000810:	ff3703e3          	beq	a4,s3,800007f6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000814:	8b85                	andi	a5,a5,1
    80000816:	d7fd                	beqz	a5,80000804 <freewalk+0x2a>
      panic("freewalk: leaf");
    80000818:	00007517          	auipc	a0,0x7
    8000081c:	8c050513          	addi	a0,a0,-1856 # 800070d8 <etext+0xd8>
    80000820:	5bf040ef          	jal	800055de <panic>
    }
  }
  kfree((void*)pagetable);
    80000824:	8552                	mv	a0,s4
    80000826:	ff6ff0ef          	jal	8000001c <kfree>
}
    8000082a:	70a2                	ld	ra,40(sp)
    8000082c:	7402                	ld	s0,32(sp)
    8000082e:	64e2                	ld	s1,24(sp)
    80000830:	6942                	ld	s2,16(sp)
    80000832:	69a2                	ld	s3,8(sp)
    80000834:	6a02                	ld	s4,0(sp)
    80000836:	6145                	addi	sp,sp,48
    80000838:	8082                	ret

000000008000083a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000083a:	1101                	addi	sp,sp,-32
    8000083c:	ec06                	sd	ra,24(sp)
    8000083e:	e822                	sd	s0,16(sp)
    80000840:	e426                	sd	s1,8(sp)
    80000842:	1000                	addi	s0,sp,32
    80000844:	84aa                	mv	s1,a0
  if(sz > 0)
    80000846:	e989                	bnez	a1,80000858 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000848:	8526                	mv	a0,s1
    8000084a:	f91ff0ef          	jal	800007da <freewalk>
}
    8000084e:	60e2                	ld	ra,24(sp)
    80000850:	6442                	ld	s0,16(sp)
    80000852:	64a2                	ld	s1,8(sp)
    80000854:	6105                	addi	sp,sp,32
    80000856:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000858:	6785                	lui	a5,0x1
    8000085a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000085c:	95be                	add	a1,a1,a5
    8000085e:	4685                	li	a3,1
    80000860:	00c5d613          	srli	a2,a1,0xc
    80000864:	4581                	li	a1,0
    80000866:	e01ff0ef          	jal	80000666 <uvmunmap>
    8000086a:	bff9                	j	80000848 <uvmfree+0xe>

000000008000086c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000086c:	ce49                	beqz	a2,80000906 <uvmcopy+0x9a>
{
    8000086e:	715d                	addi	sp,sp,-80
    80000870:	e486                	sd	ra,72(sp)
    80000872:	e0a2                	sd	s0,64(sp)
    80000874:	fc26                	sd	s1,56(sp)
    80000876:	f84a                	sd	s2,48(sp)
    80000878:	f44e                	sd	s3,40(sp)
    8000087a:	f052                	sd	s4,32(sp)
    8000087c:	ec56                	sd	s5,24(sp)
    8000087e:	e85a                	sd	s6,16(sp)
    80000880:	e45e                	sd	s7,8(sp)
    80000882:	0880                	addi	s0,sp,80
    80000884:	8aaa                	mv	s5,a0
    80000886:	8b2e                	mv	s6,a1
    80000888:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000088a:	4481                	li	s1,0
    8000088c:	a029                	j	80000896 <uvmcopy+0x2a>
    8000088e:	6785                	lui	a5,0x1
    80000890:	94be                	add	s1,s1,a5
    80000892:	0544fe63          	bgeu	s1,s4,800008ee <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    80000896:	4601                	li	a2,0
    80000898:	85a6                	mv	a1,s1
    8000089a:	8556                	mv	a0,s5
    8000089c:	b27ff0ef          	jal	800003c2 <walk>
    800008a0:	d57d                	beqz	a0,8000088e <uvmcopy+0x22>
      continue;   // page table entry hasn't been allocated
    if((*pte & PTE_V) == 0)
    800008a2:	6118                	ld	a4,0(a0)
    800008a4:	00177793          	andi	a5,a4,1
    800008a8:	d3fd                	beqz	a5,8000088e <uvmcopy+0x22>
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    800008aa:	00a75593          	srli	a1,a4,0xa
    800008ae:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800008b2:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    800008b6:	849ff0ef          	jal	800000fe <kalloc>
    800008ba:	89aa                	mv	s3,a0
    800008bc:	c105                	beqz	a0,800008dc <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008be:	6605                	lui	a2,0x1
    800008c0:	85de                	mv	a1,s7
    800008c2:	8e9ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008c6:	874a                	mv	a4,s2
    800008c8:	86ce                	mv	a3,s3
    800008ca:	6605                	lui	a2,0x1
    800008cc:	85a6                	mv	a1,s1
    800008ce:	855a                	mv	a0,s6
    800008d0:	bcbff0ef          	jal	8000049a <mappages>
    800008d4:	dd4d                	beqz	a0,8000088e <uvmcopy+0x22>
      kfree(mem);
    800008d6:	854e                	mv	a0,s3
    800008d8:	f44ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800008dc:	4685                	li	a3,1
    800008de:	00c4d613          	srli	a2,s1,0xc
    800008e2:	4581                	li	a1,0
    800008e4:	855a                	mv	a0,s6
    800008e6:	d81ff0ef          	jal	80000666 <uvmunmap>
  return -1;
    800008ea:	557d                	li	a0,-1
    800008ec:	a011                	j	800008f0 <uvmcopy+0x84>
  return 0;
    800008ee:	4501                	li	a0,0
}
    800008f0:	60a6                	ld	ra,72(sp)
    800008f2:	6406                	ld	s0,64(sp)
    800008f4:	74e2                	ld	s1,56(sp)
    800008f6:	7942                	ld	s2,48(sp)
    800008f8:	79a2                	ld	s3,40(sp)
    800008fa:	7a02                	ld	s4,32(sp)
    800008fc:	6ae2                	ld	s5,24(sp)
    800008fe:	6b42                	ld	s6,16(sp)
    80000900:	6ba2                	ld	s7,8(sp)
    80000902:	6161                	addi	sp,sp,80
    80000904:	8082                	ret
  return 0;
    80000906:	4501                	li	a0,0
}
    80000908:	8082                	ret

000000008000090a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000090a:	1141                	addi	sp,sp,-16
    8000090c:	e406                	sd	ra,8(sp)
    8000090e:	e022                	sd	s0,0(sp)
    80000910:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000912:	4601                	li	a2,0
    80000914:	aafff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000918:	c901                	beqz	a0,80000928 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000091a:	611c                	ld	a5,0(a0)
    8000091c:	9bbd                	andi	a5,a5,-17
    8000091e:	e11c                	sd	a5,0(a0)
}
    80000920:	60a2                	ld	ra,8(sp)
    80000922:	6402                	ld	s0,0(sp)
    80000924:	0141                	addi	sp,sp,16
    80000926:	8082                	ret
    panic("uvmclear");
    80000928:	00006517          	auipc	a0,0x6
    8000092c:	7c050513          	addi	a0,a0,1984 # 800070e8 <etext+0xe8>
    80000930:	4af040ef          	jal	800055de <panic>

0000000080000934 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000934:	c6dd                	beqz	a3,800009e2 <copyinstr+0xae>
{
    80000936:	715d                	addi	sp,sp,-80
    80000938:	e486                	sd	ra,72(sp)
    8000093a:	e0a2                	sd	s0,64(sp)
    8000093c:	fc26                	sd	s1,56(sp)
    8000093e:	f84a                	sd	s2,48(sp)
    80000940:	f44e                	sd	s3,40(sp)
    80000942:	f052                	sd	s4,32(sp)
    80000944:	ec56                	sd	s5,24(sp)
    80000946:	e85a                	sd	s6,16(sp)
    80000948:	e45e                	sd	s7,8(sp)
    8000094a:	0880                	addi	s0,sp,80
    8000094c:	8a2a                	mv	s4,a0
    8000094e:	8b2e                	mv	s6,a1
    80000950:	8bb2                	mv	s7,a2
    80000952:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000954:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000956:	6985                	lui	s3,0x1
    80000958:	a825                	j	80000990 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000095a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000095e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000960:	37fd                	addiw	a5,a5,-1
    80000962:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000966:	60a6                	ld	ra,72(sp)
    80000968:	6406                	ld	s0,64(sp)
    8000096a:	74e2                	ld	s1,56(sp)
    8000096c:	7942                	ld	s2,48(sp)
    8000096e:	79a2                	ld	s3,40(sp)
    80000970:	7a02                	ld	s4,32(sp)
    80000972:	6ae2                	ld	s5,24(sp)
    80000974:	6b42                	ld	s6,16(sp)
    80000976:	6ba2                	ld	s7,8(sp)
    80000978:	6161                	addi	sp,sp,80
    8000097a:	8082                	ret
    8000097c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000980:	9742                	add	a4,a4,a6
      --max;
    80000982:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000986:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    8000098a:	04e58463          	beq	a1,a4,800009d2 <copyinstr+0x9e>
{
    8000098e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000990:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000994:	85a6                	mv	a1,s1
    80000996:	8552                	mv	a0,s4
    80000998:	ac5ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0)
    8000099c:	cd0d                	beqz	a0,800009d6 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000099e:	417486b3          	sub	a3,s1,s7
    800009a2:	96ce                	add	a3,a3,s3
    if(n > max)
    800009a4:	00d97363          	bgeu	s2,a3,800009aa <copyinstr+0x76>
    800009a8:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800009aa:	955e                	add	a0,a0,s7
    800009ac:	8d05                	sub	a0,a0,s1
    while(n > 0){
    800009ae:	c695                	beqz	a3,800009da <copyinstr+0xa6>
    800009b0:	87da                	mv	a5,s6
    800009b2:	885a                	mv	a6,s6
      if(*p == '\0'){
    800009b4:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800009b8:	96da                	add	a3,a3,s6
    800009ba:	85be                	mv	a1,a5
      if(*p == '\0'){
    800009bc:	00f60733          	add	a4,a2,a5
    800009c0:	00074703          	lbu	a4,0(a4)
    800009c4:	db59                	beqz	a4,8000095a <copyinstr+0x26>
        *dst = *p;
    800009c6:	00e78023          	sb	a4,0(a5)
      dst++;
    800009ca:	0785                	addi	a5,a5,1
    while(n > 0){
    800009cc:	fed797e3          	bne	a5,a3,800009ba <copyinstr+0x86>
    800009d0:	b775                	j	8000097c <copyinstr+0x48>
    800009d2:	4781                	li	a5,0
    800009d4:	b771                	j	80000960 <copyinstr+0x2c>
      return -1;
    800009d6:	557d                	li	a0,-1
    800009d8:	b779                	j	80000966 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800009da:	6b85                	lui	s7,0x1
    800009dc:	9ba6                	add	s7,s7,s1
    800009de:	87da                	mv	a5,s6
    800009e0:	b77d                	j	8000098e <copyinstr+0x5a>
  int got_null = 0;
    800009e2:	4781                	li	a5,0
  if(got_null){
    800009e4:	37fd                	addiw	a5,a5,-1
    800009e6:	0007851b          	sext.w	a0,a5
}
    800009ea:	8082                	ret

00000000800009ec <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800009ec:	1141                	addi	sp,sp,-16
    800009ee:	e406                	sd	ra,8(sp)
    800009f0:	e022                	sd	s0,0(sp)
    800009f2:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800009f4:	4601                	li	a2,0
    800009f6:	9cdff0ef          	jal	800003c2 <walk>
  if (pte == 0) {
    800009fa:	c519                	beqz	a0,80000a08 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    800009fc:	6108                	ld	a0,0(a0)
    800009fe:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a00:	60a2                	ld	ra,8(sp)
    80000a02:	6402                	ld	s0,0(sp)
    80000a04:	0141                	addi	sp,sp,16
    80000a06:	8082                	ret
    return 0;
    80000a08:	4501                	li	a0,0
    80000a0a:	bfdd                	j	80000a00 <ismapped+0x14>

0000000080000a0c <vmfault>:
{
    80000a0c:	7179                	addi	sp,sp,-48
    80000a0e:	f406                	sd	ra,40(sp)
    80000a10:	f022                	sd	s0,32(sp)
    80000a12:	ec26                	sd	s1,24(sp)
    80000a14:	e44e                	sd	s3,8(sp)
    80000a16:	1800                	addi	s0,sp,48
    80000a18:	89aa                	mv	s3,a0
    80000a1a:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80000a1c:	35e000ef          	jal	80000d7a <myproc>
  if (va >= p->sz)
    80000a20:	653c                	ld	a5,72(a0)
    80000a22:	00f4ea63          	bltu	s1,a5,80000a36 <vmfault+0x2a>
    return 0;
    80000a26:	4981                	li	s3,0
}
    80000a28:	854e                	mv	a0,s3
    80000a2a:	70a2                	ld	ra,40(sp)
    80000a2c:	7402                	ld	s0,32(sp)
    80000a2e:	64e2                	ld	s1,24(sp)
    80000a30:	69a2                	ld	s3,8(sp)
    80000a32:	6145                	addi	sp,sp,48
    80000a34:	8082                	ret
    80000a36:	e84a                	sd	s2,16(sp)
    80000a38:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80000a3a:	77fd                	lui	a5,0xfffff
    80000a3c:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    80000a3e:	85a6                	mv	a1,s1
    80000a40:	854e                	mv	a0,s3
    80000a42:	fabff0ef          	jal	800009ec <ismapped>
    return 0;
    80000a46:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a48:	c119                	beqz	a0,80000a4e <vmfault+0x42>
    80000a4a:	6942                	ld	s2,16(sp)
    80000a4c:	bff1                	j	80000a28 <vmfault+0x1c>
    80000a4e:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    80000a50:	eaeff0ef          	jal	800000fe <kalloc>
    80000a54:	8a2a                	mv	s4,a0
  if(mem == 0)
    80000a56:	c90d                	beqz	a0,80000a88 <vmfault+0x7c>
  mem = (uint64) kalloc();
    80000a58:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a5a:	6605                	lui	a2,0x1
    80000a5c:	4581                	li	a1,0
    80000a5e:	ef0ff0ef          	jal	8000014e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a62:	4759                	li	a4,22
    80000a64:	86d2                	mv	a3,s4
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85a6                	mv	a1,s1
    80000a6a:	05093503          	ld	a0,80(s2)
    80000a6e:	a2dff0ef          	jal	8000049a <mappages>
    80000a72:	e501                	bnez	a0,80000a7a <vmfault+0x6e>
    80000a74:	6942                	ld	s2,16(sp)
    80000a76:	6a02                	ld	s4,0(sp)
    80000a78:	bf45                	j	80000a28 <vmfault+0x1c>
    kfree((void *)mem);
    80000a7a:	8552                	mv	a0,s4
    80000a7c:	da0ff0ef          	jal	8000001c <kfree>
    return 0;
    80000a80:	4981                	li	s3,0
    80000a82:	6942                	ld	s2,16(sp)
    80000a84:	6a02                	ld	s4,0(sp)
    80000a86:	b74d                	j	80000a28 <vmfault+0x1c>
    80000a88:	6942                	ld	s2,16(sp)
    80000a8a:	6a02                	ld	s4,0(sp)
    80000a8c:	bf71                	j	80000a28 <vmfault+0x1c>

0000000080000a8e <copyout>:
  while(len > 0){
    80000a8e:	c2cd                	beqz	a3,80000b30 <copyout+0xa2>
{
    80000a90:	711d                	addi	sp,sp,-96
    80000a92:	ec86                	sd	ra,88(sp)
    80000a94:	e8a2                	sd	s0,80(sp)
    80000a96:	e4a6                	sd	s1,72(sp)
    80000a98:	f852                	sd	s4,48(sp)
    80000a9a:	f05a                	sd	s6,32(sp)
    80000a9c:	ec5e                	sd	s7,24(sp)
    80000a9e:	e862                	sd	s8,16(sp)
    80000aa0:	1080                	addi	s0,sp,96
    80000aa2:	8c2a                	mv	s8,a0
    80000aa4:	8b2e                	mv	s6,a1
    80000aa6:	8bb2                	mv	s7,a2
    80000aa8:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000aaa:	74fd                	lui	s1,0xfffff
    80000aac:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000aae:	57fd                	li	a5,-1
    80000ab0:	83e9                	srli	a5,a5,0x1a
    80000ab2:	0897e163          	bltu	a5,s1,80000b34 <copyout+0xa6>
    80000ab6:	e0ca                	sd	s2,64(sp)
    80000ab8:	fc4e                	sd	s3,56(sp)
    80000aba:	f456                	sd	s5,40(sp)
    80000abc:	e466                	sd	s9,8(sp)
    80000abe:	e06a                	sd	s10,0(sp)
    80000ac0:	6d05                	lui	s10,0x1
    80000ac2:	8cbe                	mv	s9,a5
    80000ac4:	a015                	j	80000ae8 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ac6:	409b0533          	sub	a0,s6,s1
    80000aca:	0009861b          	sext.w	a2,s3
    80000ace:	85de                	mv	a1,s7
    80000ad0:	954a                	add	a0,a0,s2
    80000ad2:	ed8ff0ef          	jal	800001aa <memmove>
    len -= n;
    80000ad6:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000ada:	9bce                	add	s7,s7,s3
  while(len > 0){
    80000adc:	040a0363          	beqz	s4,80000b22 <copyout+0x94>
    if(va0 >= MAXVA)
    80000ae0:	055cec63          	bltu	s9,s5,80000b38 <copyout+0xaa>
    80000ae4:	84d6                	mv	s1,s5
    80000ae6:	8b56                	mv	s6,s5
    pa0 = walkaddr(pagetable, va0);
    80000ae8:	85a6                	mv	a1,s1
    80000aea:	8562                	mv	a0,s8
    80000aec:	971ff0ef          	jal	8000045c <walkaddr>
    80000af0:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80000af2:	e901                	bnez	a0,80000b02 <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000af4:	4601                	li	a2,0
    80000af6:	85a6                	mv	a1,s1
    80000af8:	8562                	mv	a0,s8
    80000afa:	f13ff0ef          	jal	80000a0c <vmfault>
    80000afe:	892a                	mv	s2,a0
    80000b00:	c139                	beqz	a0,80000b46 <copyout+0xb8>
    pte = walk(pagetable, va0, 0);
    80000b02:	4601                	li	a2,0
    80000b04:	85a6                	mv	a1,s1
    80000b06:	8562                	mv	a0,s8
    80000b08:	8bbff0ef          	jal	800003c2 <walk>
    if((*pte & PTE_W) == 0)
    80000b0c:	611c                	ld	a5,0(a0)
    80000b0e:	8b91                	andi	a5,a5,4
    80000b10:	c3b1                	beqz	a5,80000b54 <copyout+0xc6>
    n = PGSIZE - (dstva - va0);
    80000b12:	01a48ab3          	add	s5,s1,s10
    80000b16:	416a89b3          	sub	s3,s5,s6
    if(n > len)
    80000b1a:	fb3a76e3          	bgeu	s4,s3,80000ac6 <copyout+0x38>
    80000b1e:	89d2                	mv	s3,s4
    80000b20:	b75d                	j	80000ac6 <copyout+0x38>
  return 0;
    80000b22:	4501                	li	a0,0
    80000b24:	6906                	ld	s2,64(sp)
    80000b26:	79e2                	ld	s3,56(sp)
    80000b28:	7aa2                	ld	s5,40(sp)
    80000b2a:	6ca2                	ld	s9,8(sp)
    80000b2c:	6d02                	ld	s10,0(sp)
    80000b2e:	a80d                	j	80000b60 <copyout+0xd2>
    80000b30:	4501                	li	a0,0
}
    80000b32:	8082                	ret
      return -1;
    80000b34:	557d                	li	a0,-1
    80000b36:	a02d                	j	80000b60 <copyout+0xd2>
    80000b38:	557d                	li	a0,-1
    80000b3a:	6906                	ld	s2,64(sp)
    80000b3c:	79e2                	ld	s3,56(sp)
    80000b3e:	7aa2                	ld	s5,40(sp)
    80000b40:	6ca2                	ld	s9,8(sp)
    80000b42:	6d02                	ld	s10,0(sp)
    80000b44:	a831                	j	80000b60 <copyout+0xd2>
        return -1;
    80000b46:	557d                	li	a0,-1
    80000b48:	6906                	ld	s2,64(sp)
    80000b4a:	79e2                	ld	s3,56(sp)
    80000b4c:	7aa2                	ld	s5,40(sp)
    80000b4e:	6ca2                	ld	s9,8(sp)
    80000b50:	6d02                	ld	s10,0(sp)
    80000b52:	a039                	j	80000b60 <copyout+0xd2>
      return -1;
    80000b54:	557d                	li	a0,-1
    80000b56:	6906                	ld	s2,64(sp)
    80000b58:	79e2                	ld	s3,56(sp)
    80000b5a:	7aa2                	ld	s5,40(sp)
    80000b5c:	6ca2                	ld	s9,8(sp)
    80000b5e:	6d02                	ld	s10,0(sp)
}
    80000b60:	60e6                	ld	ra,88(sp)
    80000b62:	6446                	ld	s0,80(sp)
    80000b64:	64a6                	ld	s1,72(sp)
    80000b66:	7a42                	ld	s4,48(sp)
    80000b68:	7b02                	ld	s6,32(sp)
    80000b6a:	6be2                	ld	s7,24(sp)
    80000b6c:	6c42                	ld	s8,16(sp)
    80000b6e:	6125                	addi	sp,sp,96
    80000b70:	8082                	ret

0000000080000b72 <copyin>:
  while(len > 0){
    80000b72:	c6c9                	beqz	a3,80000bfc <copyin+0x8a>
{
    80000b74:	715d                	addi	sp,sp,-80
    80000b76:	e486                	sd	ra,72(sp)
    80000b78:	e0a2                	sd	s0,64(sp)
    80000b7a:	fc26                	sd	s1,56(sp)
    80000b7c:	f84a                	sd	s2,48(sp)
    80000b7e:	f44e                	sd	s3,40(sp)
    80000b80:	f052                	sd	s4,32(sp)
    80000b82:	ec56                	sd	s5,24(sp)
    80000b84:	e85a                	sd	s6,16(sp)
    80000b86:	e45e                	sd	s7,8(sp)
    80000b88:	e062                	sd	s8,0(sp)
    80000b8a:	0880                	addi	s0,sp,80
    80000b8c:	8baa                	mv	s7,a0
    80000b8e:	8aae                	mv	s5,a1
    80000b90:	8932                	mv	s2,a2
    80000b92:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000b94:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000b96:	6b05                	lui	s6,0x1
    80000b98:	a035                	j	80000bc4 <copyin+0x52>
    80000b9a:	412984b3          	sub	s1,s3,s2
    80000b9e:	94da                	add	s1,s1,s6
    if(n > len)
    80000ba0:	009a7363          	bgeu	s4,s1,80000ba6 <copyin+0x34>
    80000ba4:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba6:	413905b3          	sub	a1,s2,s3
    80000baa:	0004861b          	sext.w	a2,s1
    80000bae:	95aa                	add	a1,a1,a0
    80000bb0:	8556                	mv	a0,s5
    80000bb2:	df8ff0ef          	jal	800001aa <memmove>
    len -= n;
    80000bb6:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000bba:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000bbc:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000bc0:	020a0163          	beqz	s4,80000be2 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000bc8:	85ce                	mv	a1,s3
    80000bca:	855e                	mv	a0,s7
    80000bcc:	891ff0ef          	jal	8000045c <walkaddr>
    if(pa0 == 0) {
    80000bd0:	f569                	bnez	a0,80000b9a <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000bd2:	4601                	li	a2,0
    80000bd4:	85ce                	mv	a1,s3
    80000bd6:	855e                	mv	a0,s7
    80000bd8:	e35ff0ef          	jal	80000a0c <vmfault>
    80000bdc:	fd5d                	bnez	a0,80000b9a <copyin+0x28>
        return -1;
    80000bde:	557d                	li	a0,-1
    80000be0:	a011                	j	80000be4 <copyin+0x72>
  return 0;
    80000be2:	4501                	li	a0,0
}
    80000be4:	60a6                	ld	ra,72(sp)
    80000be6:	6406                	ld	s0,64(sp)
    80000be8:	74e2                	ld	s1,56(sp)
    80000bea:	7942                	ld	s2,48(sp)
    80000bec:	79a2                	ld	s3,40(sp)
    80000bee:	7a02                	ld	s4,32(sp)
    80000bf0:	6ae2                	ld	s5,24(sp)
    80000bf2:	6b42                	ld	s6,16(sp)
    80000bf4:	6ba2                	ld	s7,8(sp)
    80000bf6:	6c02                	ld	s8,0(sp)
    80000bf8:	6161                	addi	sp,sp,80
    80000bfa:	8082                	ret
  return 0;
    80000bfc:	4501                	li	a0,0
}
    80000bfe:	8082                	ret

0000000080000c00 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c00:	7139                	addi	sp,sp,-64
    80000c02:	fc06                	sd	ra,56(sp)
    80000c04:	f822                	sd	s0,48(sp)
    80000c06:	f426                	sd	s1,40(sp)
    80000c08:	f04a                	sd	s2,32(sp)
    80000c0a:	ec4e                	sd	s3,24(sp)
    80000c0c:	e852                	sd	s4,16(sp)
    80000c0e:	e456                	sd	s5,8(sp)
    80000c10:	e05a                	sd	s6,0(sp)
    80000c12:	0080                	addi	s0,sp,64
    80000c14:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c16:	0000a497          	auipc	s1,0xa
    80000c1a:	a4a48493          	addi	s1,s1,-1462 # 8000a660 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c1e:	8b26                	mv	s6,s1
    80000c20:	04fa5937          	lui	s2,0x4fa5
    80000c24:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c28:	0932                	slli	s2,s2,0xc
    80000c2a:	fa590913          	addi	s2,s2,-91
    80000c2e:	0932                	slli	s2,s2,0xc
    80000c30:	fa590913          	addi	s2,s2,-91
    80000c34:	0932                	slli	s2,s2,0xc
    80000c36:	fa590913          	addi	s2,s2,-91
    80000c3a:	040009b7          	lui	s3,0x4000
    80000c3e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c40:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c42:	0000fa97          	auipc	s5,0xf
    80000c46:	41ea8a93          	addi	s5,s5,1054 # 80010060 <tickslock>
    char *pa = kalloc();
    80000c4a:	cb4ff0ef          	jal	800000fe <kalloc>
    80000c4e:	862a                	mv	a2,a0
    if(pa == 0)
    80000c50:	cd15                	beqz	a0,80000c8c <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c52:	416485b3          	sub	a1,s1,s6
    80000c56:	858d                	srai	a1,a1,0x3
    80000c58:	032585b3          	mul	a1,a1,s2
    80000c5c:	2585                	addiw	a1,a1,1
    80000c5e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c62:	4719                	li	a4,6
    80000c64:	6685                	lui	a3,0x1
    80000c66:	40b985b3          	sub	a1,s3,a1
    80000c6a:	8552                	mv	a0,s4
    80000c6c:	8dfff0ef          	jal	8000054a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c70:	16848493          	addi	s1,s1,360
    80000c74:	fd549be3          	bne	s1,s5,80000c4a <proc_mapstacks+0x4a>
  }
}
    80000c78:	70e2                	ld	ra,56(sp)
    80000c7a:	7442                	ld	s0,48(sp)
    80000c7c:	74a2                	ld	s1,40(sp)
    80000c7e:	7902                	ld	s2,32(sp)
    80000c80:	69e2                	ld	s3,24(sp)
    80000c82:	6a42                	ld	s4,16(sp)
    80000c84:	6aa2                	ld	s5,8(sp)
    80000c86:	6b02                	ld	s6,0(sp)
    80000c88:	6121                	addi	sp,sp,64
    80000c8a:	8082                	ret
      panic("kalloc");
    80000c8c:	00006517          	auipc	a0,0x6
    80000c90:	46c50513          	addi	a0,a0,1132 # 800070f8 <etext+0xf8>
    80000c94:	14b040ef          	jal	800055de <panic>

0000000080000c98 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c98:	7139                	addi	sp,sp,-64
    80000c9a:	fc06                	sd	ra,56(sp)
    80000c9c:	f822                	sd	s0,48(sp)
    80000c9e:	f426                	sd	s1,40(sp)
    80000ca0:	f04a                	sd	s2,32(sp)
    80000ca2:	ec4e                	sd	s3,24(sp)
    80000ca4:	e852                	sd	s4,16(sp)
    80000ca6:	e456                	sd	s5,8(sp)
    80000ca8:	e05a                	sd	s6,0(sp)
    80000caa:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cac:	00006597          	auipc	a1,0x6
    80000cb0:	45458593          	addi	a1,a1,1108 # 80007100 <etext+0x100>
    80000cb4:	00009517          	auipc	a0,0x9
    80000cb8:	57c50513          	addi	a0,a0,1404 # 8000a230 <pid_lock>
    80000cbc:	35f040ef          	jal	8000581a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc0:	00006597          	auipc	a1,0x6
    80000cc4:	44858593          	addi	a1,a1,1096 # 80007108 <etext+0x108>
    80000cc8:	00009517          	auipc	a0,0x9
    80000ccc:	58050513          	addi	a0,a0,1408 # 8000a248 <wait_lock>
    80000cd0:	34b040ef          	jal	8000581a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd4:	0000a497          	auipc	s1,0xa
    80000cd8:	98c48493          	addi	s1,s1,-1652 # 8000a660 <proc>
      initlock(&p->lock, "proc");
    80000cdc:	00006b17          	auipc	s6,0x6
    80000ce0:	43cb0b13          	addi	s6,s6,1084 # 80007118 <etext+0x118>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ce4:	8aa6                	mv	s5,s1
    80000ce6:	04fa5937          	lui	s2,0x4fa5
    80000cea:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000cee:	0932                	slli	s2,s2,0xc
    80000cf0:	fa590913          	addi	s2,s2,-91
    80000cf4:	0932                	slli	s2,s2,0xc
    80000cf6:	fa590913          	addi	s2,s2,-91
    80000cfa:	0932                	slli	s2,s2,0xc
    80000cfc:	fa590913          	addi	s2,s2,-91
    80000d00:	040009b7          	lui	s3,0x4000
    80000d04:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d06:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d08:	0000fa17          	auipc	s4,0xf
    80000d0c:	358a0a13          	addi	s4,s4,856 # 80010060 <tickslock>
      initlock(&p->lock, "proc");
    80000d10:	85da                	mv	a1,s6
    80000d12:	8526                	mv	a0,s1
    80000d14:	307040ef          	jal	8000581a <initlock>
      p->state = UNUSED;
    80000d18:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d1c:	415487b3          	sub	a5,s1,s5
    80000d20:	878d                	srai	a5,a5,0x3
    80000d22:	032787b3          	mul	a5,a5,s2
    80000d26:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffdbae9>
    80000d28:	00d7979b          	slliw	a5,a5,0xd
    80000d2c:	40f987b3          	sub	a5,s3,a5
    80000d30:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	16848493          	addi	s1,s1,360
    80000d36:	fd449de3          	bne	s1,s4,80000d10 <procinit+0x78>
  }
}
    80000d3a:	70e2                	ld	ra,56(sp)
    80000d3c:	7442                	ld	s0,48(sp)
    80000d3e:	74a2                	ld	s1,40(sp)
    80000d40:	7902                	ld	s2,32(sp)
    80000d42:	69e2                	ld	s3,24(sp)
    80000d44:	6a42                	ld	s4,16(sp)
    80000d46:	6aa2                	ld	s5,8(sp)
    80000d48:	6b02                	ld	s6,0(sp)
    80000d4a:	6121                	addi	sp,sp,64
    80000d4c:	8082                	ret

0000000080000d4e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d4e:	1141                	addi	sp,sp,-16
    80000d50:	e422                	sd	s0,8(sp)
    80000d52:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d54:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d56:	2501                	sext.w	a0,a0
    80000d58:	6422                	ld	s0,8(sp)
    80000d5a:	0141                	addi	sp,sp,16
    80000d5c:	8082                	ret

0000000080000d5e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d5e:	1141                	addi	sp,sp,-16
    80000d60:	e422                	sd	s0,8(sp)
    80000d62:	0800                	addi	s0,sp,16
    80000d64:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d66:	2781                	sext.w	a5,a5
    80000d68:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d6a:	00009517          	auipc	a0,0x9
    80000d6e:	4f650513          	addi	a0,a0,1270 # 8000a260 <cpus>
    80000d72:	953e                	add	a0,a0,a5
    80000d74:	6422                	ld	s0,8(sp)
    80000d76:	0141                	addi	sp,sp,16
    80000d78:	8082                	ret

0000000080000d7a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d7a:	1101                	addi	sp,sp,-32
    80000d7c:	ec06                	sd	ra,24(sp)
    80000d7e:	e822                	sd	s0,16(sp)
    80000d80:	e426                	sd	s1,8(sp)
    80000d82:	1000                	addi	s0,sp,32
  push_off();
    80000d84:	2d7040ef          	jal	8000585a <push_off>
    80000d88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d8a:	2781                	sext.w	a5,a5
    80000d8c:	079e                	slli	a5,a5,0x7
    80000d8e:	00009717          	auipc	a4,0x9
    80000d92:	4a270713          	addi	a4,a4,1186 # 8000a230 <pid_lock>
    80000d96:	97ba                	add	a5,a5,a4
    80000d98:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d9a:	345040ef          	jal	800058de <pop_off>
  return p;
}
    80000d9e:	8526                	mv	a0,s1
    80000da0:	60e2                	ld	ra,24(sp)
    80000da2:	6442                	ld	s0,16(sp)
    80000da4:	64a2                	ld	s1,8(sp)
    80000da6:	6105                	addi	sp,sp,32
    80000da8:	8082                	ret

0000000080000daa <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000daa:	7179                	addi	sp,sp,-48
    80000dac:	f406                	sd	ra,40(sp)
    80000dae:	f022                	sd	s0,32(sp)
    80000db0:	ec26                	sd	s1,24(sp)
    80000db2:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000db4:	fc7ff0ef          	jal	80000d7a <myproc>
    80000db8:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000dba:	379040ef          	jal	80005932 <release>

  if (first) {
    80000dbe:	00009797          	auipc	a5,0x9
    80000dc2:	3f27a783          	lw	a5,1010(a5) # 8000a1b0 <first.1>
    80000dc6:	cf8d                	beqz	a5,80000e00 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dc8:	4505                	li	a0,1
    80000dca:	3c1010ef          	jal	8000298a <fsinit>

    first = 0;
    80000dce:	00009797          	auipc	a5,0x9
    80000dd2:	3e07a123          	sw	zero,994(a5) # 8000a1b0 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000dd6:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000dda:	00006517          	auipc	a0,0x6
    80000dde:	34650513          	addi	a0,a0,838 # 80007120 <etext+0x120>
    80000de2:	fca43823          	sd	a0,-48(s0)
    80000de6:	fc043c23          	sd	zero,-40(s0)
    80000dea:	fd040593          	addi	a1,s0,-48
    80000dee:	49d020ef          	jal	80003a8a <kexec>
    80000df2:	6cbc                	ld	a5,88(s1)
    80000df4:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000df6:	6cbc                	ld	a5,88(s1)
    80000df8:	7bb8                	ld	a4,112(a5)
    80000dfa:	57fd                	li	a5,-1
    80000dfc:	02f70d63          	beq	a4,a5,80000e36 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e00:	2ad000ef          	jal	800018ac <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e04:	68a8                	ld	a0,80(s1)
    80000e06:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e08:	04000737          	lui	a4,0x4000
    80000e0c:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e0e:	0732                	slli	a4,a4,0xc
    80000e10:	00005797          	auipc	a5,0x5
    80000e14:	28c78793          	addi	a5,a5,652 # 8000609c <userret>
    80000e18:	00005697          	auipc	a3,0x5
    80000e1c:	1e868693          	addi	a3,a3,488 # 80006000 <_trampoline>
    80000e20:	8f95                	sub	a5,a5,a3
    80000e22:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e24:	577d                	li	a4,-1
    80000e26:	177e                	slli	a4,a4,0x3f
    80000e28:	8d59                	or	a0,a0,a4
    80000e2a:	9782                	jalr	a5
}
    80000e2c:	70a2                	ld	ra,40(sp)
    80000e2e:	7402                	ld	s0,32(sp)
    80000e30:	64e2                	ld	s1,24(sp)
    80000e32:	6145                	addi	sp,sp,48
    80000e34:	8082                	ret
      panic("exec");
    80000e36:	00006517          	auipc	a0,0x6
    80000e3a:	2f250513          	addi	a0,a0,754 # 80007128 <etext+0x128>
    80000e3e:	7a0040ef          	jal	800055de <panic>

0000000080000e42 <allocpid>:
{
    80000e42:	1101                	addi	sp,sp,-32
    80000e44:	ec06                	sd	ra,24(sp)
    80000e46:	e822                	sd	s0,16(sp)
    80000e48:	e426                	sd	s1,8(sp)
    80000e4a:	e04a                	sd	s2,0(sp)
    80000e4c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e4e:	00009917          	auipc	s2,0x9
    80000e52:	3e290913          	addi	s2,s2,994 # 8000a230 <pid_lock>
    80000e56:	854a                	mv	a0,s2
    80000e58:	243040ef          	jal	8000589a <acquire>
  pid = nextpid;
    80000e5c:	00009797          	auipc	a5,0x9
    80000e60:	35878793          	addi	a5,a5,856 # 8000a1b4 <nextpid>
    80000e64:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e66:	0014871b          	addiw	a4,s1,1
    80000e6a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e6c:	854a                	mv	a0,s2
    80000e6e:	2c5040ef          	jal	80005932 <release>
}
    80000e72:	8526                	mv	a0,s1
    80000e74:	60e2                	ld	ra,24(sp)
    80000e76:	6442                	ld	s0,16(sp)
    80000e78:	64a2                	ld	s1,8(sp)
    80000e7a:	6902                	ld	s2,0(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <proc_pagetable>:
{
    80000e80:	1101                	addi	sp,sp,-32
    80000e82:	ec06                	sd	ra,24(sp)
    80000e84:	e822                	sd	s0,16(sp)
    80000e86:	e426                	sd	s1,8(sp)
    80000e88:	e04a                	sd	s2,0(sp)
    80000e8a:	1000                	addi	s0,sp,32
    80000e8c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e8e:	fb2ff0ef          	jal	80000640 <uvmcreate>
    80000e92:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e94:	cd05                	beqz	a0,80000ecc <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e96:	4729                	li	a4,10
    80000e98:	00005697          	auipc	a3,0x5
    80000e9c:	16868693          	addi	a3,a3,360 # 80006000 <_trampoline>
    80000ea0:	6605                	lui	a2,0x1
    80000ea2:	040005b7          	lui	a1,0x4000
    80000ea6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea8:	05b2                	slli	a1,a1,0xc
    80000eaa:	df0ff0ef          	jal	8000049a <mappages>
    80000eae:	02054663          	bltz	a0,80000eda <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000eb2:	4719                	li	a4,6
    80000eb4:	05893683          	ld	a3,88(s2)
    80000eb8:	6605                	lui	a2,0x1
    80000eba:	020005b7          	lui	a1,0x2000
    80000ebe:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ec0:	05b6                	slli	a1,a1,0xd
    80000ec2:	8526                	mv	a0,s1
    80000ec4:	dd6ff0ef          	jal	8000049a <mappages>
    80000ec8:	00054f63          	bltz	a0,80000ee6 <proc_pagetable+0x66>
}
    80000ecc:	8526                	mv	a0,s1
    80000ece:	60e2                	ld	ra,24(sp)
    80000ed0:	6442                	ld	s0,16(sp)
    80000ed2:	64a2                	ld	s1,8(sp)
    80000ed4:	6902                	ld	s2,0(sp)
    80000ed6:	6105                	addi	sp,sp,32
    80000ed8:	8082                	ret
    uvmfree(pagetable, 0);
    80000eda:	4581                	li	a1,0
    80000edc:	8526                	mv	a0,s1
    80000ede:	95dff0ef          	jal	8000083a <uvmfree>
    return 0;
    80000ee2:	4481                	li	s1,0
    80000ee4:	b7e5                	j	80000ecc <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ee6:	4681                	li	a3,0
    80000ee8:	4605                	li	a2,1
    80000eea:	040005b7          	lui	a1,0x4000
    80000eee:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ef0:	05b2                	slli	a1,a1,0xc
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	f72ff0ef          	jal	80000666 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ef8:	4581                	li	a1,0
    80000efa:	8526                	mv	a0,s1
    80000efc:	93fff0ef          	jal	8000083a <uvmfree>
    return 0;
    80000f00:	4481                	li	s1,0
    80000f02:	b7e9                	j	80000ecc <proc_pagetable+0x4c>

0000000080000f04 <proc_freepagetable>:
{
    80000f04:	1101                	addi	sp,sp,-32
    80000f06:	ec06                	sd	ra,24(sp)
    80000f08:	e822                	sd	s0,16(sp)
    80000f0a:	e426                	sd	s1,8(sp)
    80000f0c:	e04a                	sd	s2,0(sp)
    80000f0e:	1000                	addi	s0,sp,32
    80000f10:	84aa                	mv	s1,a0
    80000f12:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f14:	4681                	li	a3,0
    80000f16:	4605                	li	a2,1
    80000f18:	040005b7          	lui	a1,0x4000
    80000f1c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f1e:	05b2                	slli	a1,a1,0xc
    80000f20:	f46ff0ef          	jal	80000666 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f24:	4681                	li	a3,0
    80000f26:	4605                	li	a2,1
    80000f28:	020005b7          	lui	a1,0x2000
    80000f2c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f2e:	05b6                	slli	a1,a1,0xd
    80000f30:	8526                	mv	a0,s1
    80000f32:	f34ff0ef          	jal	80000666 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f36:	85ca                	mv	a1,s2
    80000f38:	8526                	mv	a0,s1
    80000f3a:	901ff0ef          	jal	8000083a <uvmfree>
}
    80000f3e:	60e2                	ld	ra,24(sp)
    80000f40:	6442                	ld	s0,16(sp)
    80000f42:	64a2                	ld	s1,8(sp)
    80000f44:	6902                	ld	s2,0(sp)
    80000f46:	6105                	addi	sp,sp,32
    80000f48:	8082                	ret

0000000080000f4a <freeproc>:
{
    80000f4a:	1101                	addi	sp,sp,-32
    80000f4c:	ec06                	sd	ra,24(sp)
    80000f4e:	e822                	sd	s0,16(sp)
    80000f50:	e426                	sd	s1,8(sp)
    80000f52:	1000                	addi	s0,sp,32
    80000f54:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f56:	6d28                	ld	a0,88(a0)
    80000f58:	c119                	beqz	a0,80000f5e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f5a:	8c2ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f5e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f62:	68a8                	ld	a0,80(s1)
    80000f64:	c501                	beqz	a0,80000f6c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f66:	64ac                	ld	a1,72(s1)
    80000f68:	f9dff0ef          	jal	80000f04 <proc_freepagetable>
  p->pagetable = 0;
    80000f6c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f70:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f74:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f78:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f7c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f80:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f84:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f88:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f8c:	0004ac23          	sw	zero,24(s1)
}
    80000f90:	60e2                	ld	ra,24(sp)
    80000f92:	6442                	ld	s0,16(sp)
    80000f94:	64a2                	ld	s1,8(sp)
    80000f96:	6105                	addi	sp,sp,32
    80000f98:	8082                	ret

0000000080000f9a <allocproc>:
{
    80000f9a:	1101                	addi	sp,sp,-32
    80000f9c:	ec06                	sd	ra,24(sp)
    80000f9e:	e822                	sd	s0,16(sp)
    80000fa0:	e426                	sd	s1,8(sp)
    80000fa2:	e04a                	sd	s2,0(sp)
    80000fa4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fa6:	00009497          	auipc	s1,0x9
    80000faa:	6ba48493          	addi	s1,s1,1722 # 8000a660 <proc>
    80000fae:	0000f917          	auipc	s2,0xf
    80000fb2:	0b290913          	addi	s2,s2,178 # 80010060 <tickslock>
    acquire(&p->lock);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	0e3040ef          	jal	8000589a <acquire>
    if(p->state == UNUSED) {
    80000fbc:	4c9c                	lw	a5,24(s1)
    80000fbe:	cb91                	beqz	a5,80000fd2 <allocproc+0x38>
      release(&p->lock);
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	171040ef          	jal	80005932 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc6:	16848493          	addi	s1,s1,360
    80000fca:	ff2496e3          	bne	s1,s2,80000fb6 <allocproc+0x1c>
  return 0;
    80000fce:	4481                	li	s1,0
    80000fd0:	a089                	j	80001012 <allocproc+0x78>
  p->pid = allocpid();
    80000fd2:	e71ff0ef          	jal	80000e42 <allocpid>
    80000fd6:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fd8:	4785                	li	a5,1
    80000fda:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fdc:	922ff0ef          	jal	800000fe <kalloc>
    80000fe0:	892a                	mv	s2,a0
    80000fe2:	eca8                	sd	a0,88(s1)
    80000fe4:	cd15                	beqz	a0,80001020 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	e99ff0ef          	jal	80000e80 <proc_pagetable>
    80000fec:	892a                	mv	s2,a0
    80000fee:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000ff0:	c121                	beqz	a0,80001030 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000ff2:	07000613          	li	a2,112
    80000ff6:	4581                	li	a1,0
    80000ff8:	06048513          	addi	a0,s1,96
    80000ffc:	952ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80001000:	00000797          	auipc	a5,0x0
    80001004:	daa78793          	addi	a5,a5,-598 # 80000daa <forkret>
    80001008:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000100a:	60bc                	ld	a5,64(s1)
    8000100c:	6705                	lui	a4,0x1
    8000100e:	97ba                	add	a5,a5,a4
    80001010:	f4bc                	sd	a5,104(s1)
}
    80001012:	8526                	mv	a0,s1
    80001014:	60e2                	ld	ra,24(sp)
    80001016:	6442                	ld	s0,16(sp)
    80001018:	64a2                	ld	s1,8(sp)
    8000101a:	6902                	ld	s2,0(sp)
    8000101c:	6105                	addi	sp,sp,32
    8000101e:	8082                	ret
    freeproc(p);
    80001020:	8526                	mv	a0,s1
    80001022:	f29ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    80001026:	8526                	mv	a0,s1
    80001028:	10b040ef          	jal	80005932 <release>
    return 0;
    8000102c:	84ca                	mv	s1,s2
    8000102e:	b7d5                	j	80001012 <allocproc+0x78>
    freeproc(p);
    80001030:	8526                	mv	a0,s1
    80001032:	f19ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    80001036:	8526                	mv	a0,s1
    80001038:	0fb040ef          	jal	80005932 <release>
    return 0;
    8000103c:	84ca                	mv	s1,s2
    8000103e:	bfd1                	j	80001012 <allocproc+0x78>

0000000080001040 <userinit>:
{
    80001040:	1101                	addi	sp,sp,-32
    80001042:	ec06                	sd	ra,24(sp)
    80001044:	e822                	sd	s0,16(sp)
    80001046:	e426                	sd	s1,8(sp)
    80001048:	1000                	addi	s0,sp,32
  p = allocproc();
    8000104a:	f51ff0ef          	jal	80000f9a <allocproc>
    8000104e:	84aa                	mv	s1,a0
  initproc = p;
    80001050:	00009797          	auipc	a5,0x9
    80001054:	1aa7b023          	sd	a0,416(a5) # 8000a1f0 <initproc>
  p->cwd = namei("/");
    80001058:	00006517          	auipc	a0,0x6
    8000105c:	0d850513          	addi	a0,a0,216 # 80007130 <etext+0x130>
    80001060:	64d010ef          	jal	80002eac <namei>
    80001064:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001068:	478d                	li	a5,3
    8000106a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000106c:	8526                	mv	a0,s1
    8000106e:	0c5040ef          	jal	80005932 <release>
}
    80001072:	60e2                	ld	ra,24(sp)
    80001074:	6442                	ld	s0,16(sp)
    80001076:	64a2                	ld	s1,8(sp)
    80001078:	6105                	addi	sp,sp,32
    8000107a:	8082                	ret

000000008000107c <growproc>:
{
    8000107c:	1101                	addi	sp,sp,-32
    8000107e:	ec06                	sd	ra,24(sp)
    80001080:	e822                	sd	s0,16(sp)
    80001082:	e426                	sd	s1,8(sp)
    80001084:	e04a                	sd	s2,0(sp)
    80001086:	1000                	addi	s0,sp,32
    80001088:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000108a:	cf1ff0ef          	jal	80000d7a <myproc>
    8000108e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001090:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001092:	01204c63          	bgtz	s2,800010aa <growproc+0x2e>
  } else if(n < 0){
    80001096:	02094463          	bltz	s2,800010be <growproc+0x42>
  p->sz = sz;
    8000109a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000109c:	4501                	li	a0,0
}
    8000109e:	60e2                	ld	ra,24(sp)
    800010a0:	6442                	ld	s0,16(sp)
    800010a2:	64a2                	ld	s1,8(sp)
    800010a4:	6902                	ld	s2,0(sp)
    800010a6:	6105                	addi	sp,sp,32
    800010a8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010aa:	4691                	li	a3,4
    800010ac:	00b90633          	add	a2,s2,a1
    800010b0:	6928                	ld	a0,80(a0)
    800010b2:	e82ff0ef          	jal	80000734 <uvmalloc>
    800010b6:	85aa                	mv	a1,a0
    800010b8:	f16d                	bnez	a0,8000109a <growproc+0x1e>
      return -1;
    800010ba:	557d                	li	a0,-1
    800010bc:	b7cd                	j	8000109e <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010be:	00b90633          	add	a2,s2,a1
    800010c2:	6928                	ld	a0,80(a0)
    800010c4:	e2cff0ef          	jal	800006f0 <uvmdealloc>
    800010c8:	85aa                	mv	a1,a0
    800010ca:	bfc1                	j	8000109a <growproc+0x1e>

00000000800010cc <kfork>:
{
    800010cc:	7139                	addi	sp,sp,-64
    800010ce:	fc06                	sd	ra,56(sp)
    800010d0:	f822                	sd	s0,48(sp)
    800010d2:	f04a                	sd	s2,32(sp)
    800010d4:	e456                	sd	s5,8(sp)
    800010d6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010d8:	ca3ff0ef          	jal	80000d7a <myproc>
    800010dc:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010de:	ebdff0ef          	jal	80000f9a <allocproc>
    800010e2:	0e050a63          	beqz	a0,800011d6 <kfork+0x10a>
    800010e6:	e852                	sd	s4,16(sp)
    800010e8:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010ea:	048ab603          	ld	a2,72(s5)
    800010ee:	692c                	ld	a1,80(a0)
    800010f0:	050ab503          	ld	a0,80(s5)
    800010f4:	f78ff0ef          	jal	8000086c <uvmcopy>
    800010f8:	04054a63          	bltz	a0,8000114c <kfork+0x80>
    800010fc:	f426                	sd	s1,40(sp)
    800010fe:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001100:	048ab783          	ld	a5,72(s5)
    80001104:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001108:	058ab683          	ld	a3,88(s5)
    8000110c:	87b6                	mv	a5,a3
    8000110e:	058a3703          	ld	a4,88(s4)
    80001112:	12068693          	addi	a3,a3,288
    80001116:	0007b803          	ld	a6,0(a5)
    8000111a:	6788                	ld	a0,8(a5)
    8000111c:	6b8c                	ld	a1,16(a5)
    8000111e:	6f90                	ld	a2,24(a5)
    80001120:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001124:	e708                	sd	a0,8(a4)
    80001126:	eb0c                	sd	a1,16(a4)
    80001128:	ef10                	sd	a2,24(a4)
    8000112a:	02078793          	addi	a5,a5,32
    8000112e:	02070713          	addi	a4,a4,32
    80001132:	fed792e3          	bne	a5,a3,80001116 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001136:	058a3783          	ld	a5,88(s4)
    8000113a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000113e:	0d0a8493          	addi	s1,s5,208
    80001142:	0d0a0913          	addi	s2,s4,208
    80001146:	150a8993          	addi	s3,s5,336
    8000114a:	a831                	j	80001166 <kfork+0x9a>
    freeproc(np);
    8000114c:	8552                	mv	a0,s4
    8000114e:	dfdff0ef          	jal	80000f4a <freeproc>
    release(&np->lock);
    80001152:	8552                	mv	a0,s4
    80001154:	7de040ef          	jal	80005932 <release>
    return -1;
    80001158:	597d                	li	s2,-1
    8000115a:	6a42                	ld	s4,16(sp)
    8000115c:	a0b5                	j	800011c8 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000115e:	04a1                	addi	s1,s1,8
    80001160:	0921                	addi	s2,s2,8
    80001162:	01348963          	beq	s1,s3,80001174 <kfork+0xa8>
    if(p->ofile[i])
    80001166:	6088                	ld	a0,0(s1)
    80001168:	d97d                	beqz	a0,8000115e <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000116a:	2dc020ef          	jal	80003446 <filedup>
    8000116e:	00a93023          	sd	a0,0(s2)
    80001172:	b7f5                	j	8000115e <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001174:	150ab503          	ld	a0,336(s5)
    80001178:	4e8010ef          	jal	80002660 <idup>
    8000117c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001180:	4641                	li	a2,16
    80001182:	158a8593          	addi	a1,s5,344
    80001186:	158a0513          	addi	a0,s4,344
    8000118a:	902ff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    8000118e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001192:	8552                	mv	a0,s4
    80001194:	79e040ef          	jal	80005932 <release>
  acquire(&wait_lock);
    80001198:	00009497          	auipc	s1,0x9
    8000119c:	0b048493          	addi	s1,s1,176 # 8000a248 <wait_lock>
    800011a0:	8526                	mv	a0,s1
    800011a2:	6f8040ef          	jal	8000589a <acquire>
  np->parent = p;
    800011a6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800011aa:	8526                	mv	a0,s1
    800011ac:	786040ef          	jal	80005932 <release>
  acquire(&np->lock);
    800011b0:	8552                	mv	a0,s4
    800011b2:	6e8040ef          	jal	8000589a <acquire>
  np->state = RUNNABLE;
    800011b6:	478d                	li	a5,3
    800011b8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800011bc:	8552                	mv	a0,s4
    800011be:	774040ef          	jal	80005932 <release>
  return pid;
    800011c2:	74a2                	ld	s1,40(sp)
    800011c4:	69e2                	ld	s3,24(sp)
    800011c6:	6a42                	ld	s4,16(sp)
}
    800011c8:	854a                	mv	a0,s2
    800011ca:	70e2                	ld	ra,56(sp)
    800011cc:	7442                	ld	s0,48(sp)
    800011ce:	7902                	ld	s2,32(sp)
    800011d0:	6aa2                	ld	s5,8(sp)
    800011d2:	6121                	addi	sp,sp,64
    800011d4:	8082                	ret
    return -1;
    800011d6:	597d                	li	s2,-1
    800011d8:	bfc5                	j	800011c8 <kfork+0xfc>

00000000800011da <scheduler>:
{
    800011da:	715d                	addi	sp,sp,-80
    800011dc:	e486                	sd	ra,72(sp)
    800011de:	e0a2                	sd	s0,64(sp)
    800011e0:	fc26                	sd	s1,56(sp)
    800011e2:	f84a                	sd	s2,48(sp)
    800011e4:	f44e                	sd	s3,40(sp)
    800011e6:	f052                	sd	s4,32(sp)
    800011e8:	ec56                	sd	s5,24(sp)
    800011ea:	e85a                	sd	s6,16(sp)
    800011ec:	e45e                	sd	s7,8(sp)
    800011ee:	e062                	sd	s8,0(sp)
    800011f0:	0880                	addi	s0,sp,80
    800011f2:	8792                	mv	a5,tp
  int id = r_tp();
    800011f4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011f6:	00779b13          	slli	s6,a5,0x7
    800011fa:	00009717          	auipc	a4,0x9
    800011fe:	03670713          	addi	a4,a4,54 # 8000a230 <pid_lock>
    80001202:	975a                	add	a4,a4,s6
    80001204:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001208:	00009717          	auipc	a4,0x9
    8000120c:	06070713          	addi	a4,a4,96 # 8000a268 <cpus+0x8>
    80001210:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001212:	4c11                	li	s8,4
        c->proc = p;
    80001214:	079e                	slli	a5,a5,0x7
    80001216:	00009a17          	auipc	s4,0x9
    8000121a:	01aa0a13          	addi	s4,s4,26 # 8000a230 <pid_lock>
    8000121e:	9a3e                	add	s4,s4,a5
        found = 1;
    80001220:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001222:	0000f997          	auipc	s3,0xf
    80001226:	e3e98993          	addi	s3,s3,-450 # 80010060 <tickslock>
    8000122a:	a83d                	j	80001268 <scheduler+0x8e>
      release(&p->lock);
    8000122c:	8526                	mv	a0,s1
    8000122e:	704040ef          	jal	80005932 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001232:	16848493          	addi	s1,s1,360
    80001236:	03348563          	beq	s1,s3,80001260 <scheduler+0x86>
      acquire(&p->lock);
    8000123a:	8526                	mv	a0,s1
    8000123c:	65e040ef          	jal	8000589a <acquire>
      if(p->state == RUNNABLE) {
    80001240:	4c9c                	lw	a5,24(s1)
    80001242:	ff2795e3          	bne	a5,s2,8000122c <scheduler+0x52>
        p->state = RUNNING;
    80001246:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000124a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000124e:	06048593          	addi	a1,s1,96
    80001252:	855a                	mv	a0,s6
    80001254:	5b2000ef          	jal	80001806 <swtch>
        c->proc = 0;
    80001258:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000125c:	8ade                	mv	s5,s7
    8000125e:	b7f9                	j	8000122c <scheduler+0x52>
    if(found == 0) {
    80001260:	000a9463          	bnez	s5,80001268 <scheduler+0x8e>
      asm volatile("wfi");
    80001264:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001268:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000126c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001270:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001274:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001278:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000127a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000127e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001280:	00009497          	auipc	s1,0x9
    80001284:	3e048493          	addi	s1,s1,992 # 8000a660 <proc>
      if(p->state == RUNNABLE) {
    80001288:	490d                	li	s2,3
    8000128a:	bf45                	j	8000123a <scheduler+0x60>

000000008000128c <sched>:
{
    8000128c:	7179                	addi	sp,sp,-48
    8000128e:	f406                	sd	ra,40(sp)
    80001290:	f022                	sd	s0,32(sp)
    80001292:	ec26                	sd	s1,24(sp)
    80001294:	e84a                	sd	s2,16(sp)
    80001296:	e44e                	sd	s3,8(sp)
    80001298:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000129a:	ae1ff0ef          	jal	80000d7a <myproc>
    8000129e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012a0:	590040ef          	jal	80005830 <holding>
    800012a4:	c92d                	beqz	a0,80001316 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012a6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012a8:	2781                	sext.w	a5,a5
    800012aa:	079e                	slli	a5,a5,0x7
    800012ac:	00009717          	auipc	a4,0x9
    800012b0:	f8470713          	addi	a4,a4,-124 # 8000a230 <pid_lock>
    800012b4:	97ba                	add	a5,a5,a4
    800012b6:	0a87a703          	lw	a4,168(a5)
    800012ba:	4785                	li	a5,1
    800012bc:	06f71363          	bne	a4,a5,80001322 <sched+0x96>
  if(p->state == RUNNING)
    800012c0:	4c98                	lw	a4,24(s1)
    800012c2:	4791                	li	a5,4
    800012c4:	06f70563          	beq	a4,a5,8000132e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012c8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012cc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012ce:	e7b5                	bnez	a5,8000133a <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012d0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012d2:	00009917          	auipc	s2,0x9
    800012d6:	f5e90913          	addi	s2,s2,-162 # 8000a230 <pid_lock>
    800012da:	2781                	sext.w	a5,a5
    800012dc:	079e                	slli	a5,a5,0x7
    800012de:	97ca                	add	a5,a5,s2
    800012e0:	0ac7a983          	lw	s3,172(a5)
    800012e4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012e6:	2781                	sext.w	a5,a5
    800012e8:	079e                	slli	a5,a5,0x7
    800012ea:	00009597          	auipc	a1,0x9
    800012ee:	f7e58593          	addi	a1,a1,-130 # 8000a268 <cpus+0x8>
    800012f2:	95be                	add	a1,a1,a5
    800012f4:	06048513          	addi	a0,s1,96
    800012f8:	50e000ef          	jal	80001806 <swtch>
    800012fc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012fe:	2781                	sext.w	a5,a5
    80001300:	079e                	slli	a5,a5,0x7
    80001302:	993e                	add	s2,s2,a5
    80001304:	0b392623          	sw	s3,172(s2)
}
    80001308:	70a2                	ld	ra,40(sp)
    8000130a:	7402                	ld	s0,32(sp)
    8000130c:	64e2                	ld	s1,24(sp)
    8000130e:	6942                	ld	s2,16(sp)
    80001310:	69a2                	ld	s3,8(sp)
    80001312:	6145                	addi	sp,sp,48
    80001314:	8082                	ret
    panic("sched p->lock");
    80001316:	00006517          	auipc	a0,0x6
    8000131a:	e2250513          	addi	a0,a0,-478 # 80007138 <etext+0x138>
    8000131e:	2c0040ef          	jal	800055de <panic>
    panic("sched locks");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	e2650513          	addi	a0,a0,-474 # 80007148 <etext+0x148>
    8000132a:	2b4040ef          	jal	800055de <panic>
    panic("sched RUNNING");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	e2a50513          	addi	a0,a0,-470 # 80007158 <etext+0x158>
    80001336:	2a8040ef          	jal	800055de <panic>
    panic("sched interruptible");
    8000133a:	00006517          	auipc	a0,0x6
    8000133e:	e2e50513          	addi	a0,a0,-466 # 80007168 <etext+0x168>
    80001342:	29c040ef          	jal	800055de <panic>

0000000080001346 <yield>:
{
    80001346:	1101                	addi	sp,sp,-32
    80001348:	ec06                	sd	ra,24(sp)
    8000134a:	e822                	sd	s0,16(sp)
    8000134c:	e426                	sd	s1,8(sp)
    8000134e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001350:	a2bff0ef          	jal	80000d7a <myproc>
    80001354:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001356:	544040ef          	jal	8000589a <acquire>
  p->state = RUNNABLE;
    8000135a:	478d                	li	a5,3
    8000135c:	cc9c                	sw	a5,24(s1)
  sched();
    8000135e:	f2fff0ef          	jal	8000128c <sched>
  release(&p->lock);
    80001362:	8526                	mv	a0,s1
    80001364:	5ce040ef          	jal	80005932 <release>
}
    80001368:	60e2                	ld	ra,24(sp)
    8000136a:	6442                	ld	s0,16(sp)
    8000136c:	64a2                	ld	s1,8(sp)
    8000136e:	6105                	addi	sp,sp,32
    80001370:	8082                	ret

0000000080001372 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001372:	7179                	addi	sp,sp,-48
    80001374:	f406                	sd	ra,40(sp)
    80001376:	f022                	sd	s0,32(sp)
    80001378:	ec26                	sd	s1,24(sp)
    8000137a:	e84a                	sd	s2,16(sp)
    8000137c:	e44e                	sd	s3,8(sp)
    8000137e:	1800                	addi	s0,sp,48
    80001380:	89aa                	mv	s3,a0
    80001382:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001384:	9f7ff0ef          	jal	80000d7a <myproc>
    80001388:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000138a:	510040ef          	jal	8000589a <acquire>
  release(lk);
    8000138e:	854a                	mv	a0,s2
    80001390:	5a2040ef          	jal	80005932 <release>

  // Go to sleep.
  p->chan = chan;
    80001394:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001398:	4789                	li	a5,2
    8000139a:	cc9c                	sw	a5,24(s1)

  sched();
    8000139c:	ef1ff0ef          	jal	8000128c <sched>

  // Tidy up.
  p->chan = 0;
    800013a0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	58c040ef          	jal	80005932 <release>
  acquire(lk);
    800013aa:	854a                	mv	a0,s2
    800013ac:	4ee040ef          	jal	8000589a <acquire>
}
    800013b0:	70a2                	ld	ra,40(sp)
    800013b2:	7402                	ld	s0,32(sp)
    800013b4:	64e2                	ld	s1,24(sp)
    800013b6:	6942                	ld	s2,16(sp)
    800013b8:	69a2                	ld	s3,8(sp)
    800013ba:	6145                	addi	sp,sp,48
    800013bc:	8082                	ret

00000000800013be <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013be:	7139                	addi	sp,sp,-64
    800013c0:	fc06                	sd	ra,56(sp)
    800013c2:	f822                	sd	s0,48(sp)
    800013c4:	f426                	sd	s1,40(sp)
    800013c6:	f04a                	sd	s2,32(sp)
    800013c8:	ec4e                	sd	s3,24(sp)
    800013ca:	e852                	sd	s4,16(sp)
    800013cc:	e456                	sd	s5,8(sp)
    800013ce:	0080                	addi	s0,sp,64
    800013d0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013d2:	00009497          	auipc	s1,0x9
    800013d6:	28e48493          	addi	s1,s1,654 # 8000a660 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013da:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013dc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013de:	0000f917          	auipc	s2,0xf
    800013e2:	c8290913          	addi	s2,s2,-894 # 80010060 <tickslock>
    800013e6:	a801                	j	800013f6 <wakeup+0x38>
      }
      release(&p->lock);
    800013e8:	8526                	mv	a0,s1
    800013ea:	548040ef          	jal	80005932 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ee:	16848493          	addi	s1,s1,360
    800013f2:	03248263          	beq	s1,s2,80001416 <wakeup+0x58>
    if(p != myproc()){
    800013f6:	985ff0ef          	jal	80000d7a <myproc>
    800013fa:	fea48ae3          	beq	s1,a0,800013ee <wakeup+0x30>
      acquire(&p->lock);
    800013fe:	8526                	mv	a0,s1
    80001400:	49a040ef          	jal	8000589a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001404:	4c9c                	lw	a5,24(s1)
    80001406:	ff3791e3          	bne	a5,s3,800013e8 <wakeup+0x2a>
    8000140a:	709c                	ld	a5,32(s1)
    8000140c:	fd479ee3          	bne	a5,s4,800013e8 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001410:	0154ac23          	sw	s5,24(s1)
    80001414:	bfd1                	j	800013e8 <wakeup+0x2a>
    }
  }
}
    80001416:	70e2                	ld	ra,56(sp)
    80001418:	7442                	ld	s0,48(sp)
    8000141a:	74a2                	ld	s1,40(sp)
    8000141c:	7902                	ld	s2,32(sp)
    8000141e:	69e2                	ld	s3,24(sp)
    80001420:	6a42                	ld	s4,16(sp)
    80001422:	6aa2                	ld	s5,8(sp)
    80001424:	6121                	addi	sp,sp,64
    80001426:	8082                	ret

0000000080001428 <reparent>:
{
    80001428:	7179                	addi	sp,sp,-48
    8000142a:	f406                	sd	ra,40(sp)
    8000142c:	f022                	sd	s0,32(sp)
    8000142e:	ec26                	sd	s1,24(sp)
    80001430:	e84a                	sd	s2,16(sp)
    80001432:	e44e                	sd	s3,8(sp)
    80001434:	e052                	sd	s4,0(sp)
    80001436:	1800                	addi	s0,sp,48
    80001438:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000143a:	00009497          	auipc	s1,0x9
    8000143e:	22648493          	addi	s1,s1,550 # 8000a660 <proc>
      pp->parent = initproc;
    80001442:	00009a17          	auipc	s4,0x9
    80001446:	daea0a13          	addi	s4,s4,-594 # 8000a1f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000144a:	0000f997          	auipc	s3,0xf
    8000144e:	c1698993          	addi	s3,s3,-1002 # 80010060 <tickslock>
    80001452:	a029                	j	8000145c <reparent+0x34>
    80001454:	16848493          	addi	s1,s1,360
    80001458:	01348b63          	beq	s1,s3,8000146e <reparent+0x46>
    if(pp->parent == p){
    8000145c:	7c9c                	ld	a5,56(s1)
    8000145e:	ff279be3          	bne	a5,s2,80001454 <reparent+0x2c>
      pp->parent = initproc;
    80001462:	000a3503          	ld	a0,0(s4)
    80001466:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001468:	f57ff0ef          	jal	800013be <wakeup>
    8000146c:	b7e5                	j	80001454 <reparent+0x2c>
}
    8000146e:	70a2                	ld	ra,40(sp)
    80001470:	7402                	ld	s0,32(sp)
    80001472:	64e2                	ld	s1,24(sp)
    80001474:	6942                	ld	s2,16(sp)
    80001476:	69a2                	ld	s3,8(sp)
    80001478:	6a02                	ld	s4,0(sp)
    8000147a:	6145                	addi	sp,sp,48
    8000147c:	8082                	ret

000000008000147e <kexit>:
{
    8000147e:	7179                	addi	sp,sp,-48
    80001480:	f406                	sd	ra,40(sp)
    80001482:	f022                	sd	s0,32(sp)
    80001484:	ec26                	sd	s1,24(sp)
    80001486:	e84a                	sd	s2,16(sp)
    80001488:	e44e                	sd	s3,8(sp)
    8000148a:	e052                	sd	s4,0(sp)
    8000148c:	1800                	addi	s0,sp,48
    8000148e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001490:	8ebff0ef          	jal	80000d7a <myproc>
    80001494:	89aa                	mv	s3,a0
  if(p == initproc)
    80001496:	00009797          	auipc	a5,0x9
    8000149a:	d5a7b783          	ld	a5,-678(a5) # 8000a1f0 <initproc>
    8000149e:	0d050493          	addi	s1,a0,208
    800014a2:	15050913          	addi	s2,a0,336
    800014a6:	00a79f63          	bne	a5,a0,800014c4 <kexit+0x46>
    panic("init exiting");
    800014aa:	00006517          	auipc	a0,0x6
    800014ae:	cd650513          	addi	a0,a0,-810 # 80007180 <etext+0x180>
    800014b2:	12c040ef          	jal	800055de <panic>
      fileclose(f);
    800014b6:	7d7010ef          	jal	8000348c <fileclose>
      p->ofile[fd] = 0;
    800014ba:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014be:	04a1                	addi	s1,s1,8
    800014c0:	01248563          	beq	s1,s2,800014ca <kexit+0x4c>
    if(p->ofile[fd]){
    800014c4:	6088                	ld	a0,0(s1)
    800014c6:	f965                	bnez	a0,800014b6 <kexit+0x38>
    800014c8:	bfdd                	j	800014be <kexit+0x40>
  begin_op();
    800014ca:	3b7010ef          	jal	80003080 <begin_op>
  iput(p->cwd);
    800014ce:	1509b503          	ld	a0,336(s3)
    800014d2:	346010ef          	jal	80002818 <iput>
  end_op();
    800014d6:	415010ef          	jal	800030ea <end_op>
  p->cwd = 0;
    800014da:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014de:	00009497          	auipc	s1,0x9
    800014e2:	d6a48493          	addi	s1,s1,-662 # 8000a248 <wait_lock>
    800014e6:	8526                	mv	a0,s1
    800014e8:	3b2040ef          	jal	8000589a <acquire>
  reparent(p);
    800014ec:	854e                	mv	a0,s3
    800014ee:	f3bff0ef          	jal	80001428 <reparent>
  wakeup(p->parent);
    800014f2:	0389b503          	ld	a0,56(s3)
    800014f6:	ec9ff0ef          	jal	800013be <wakeup>
  acquire(&p->lock);
    800014fa:	854e                	mv	a0,s3
    800014fc:	39e040ef          	jal	8000589a <acquire>
  p->xstate = status;
    80001500:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001504:	4795                	li	a5,5
    80001506:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	426040ef          	jal	80005932 <release>
  sched();
    80001510:	d7dff0ef          	jal	8000128c <sched>
  panic("zombie exit");
    80001514:	00006517          	auipc	a0,0x6
    80001518:	c7c50513          	addi	a0,a0,-900 # 80007190 <etext+0x190>
    8000151c:	0c2040ef          	jal	800055de <panic>

0000000080001520 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001520:	7179                	addi	sp,sp,-48
    80001522:	f406                	sd	ra,40(sp)
    80001524:	f022                	sd	s0,32(sp)
    80001526:	ec26                	sd	s1,24(sp)
    80001528:	e84a                	sd	s2,16(sp)
    8000152a:	e44e                	sd	s3,8(sp)
    8000152c:	1800                	addi	s0,sp,48
    8000152e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001530:	00009497          	auipc	s1,0x9
    80001534:	13048493          	addi	s1,s1,304 # 8000a660 <proc>
    80001538:	0000f997          	auipc	s3,0xf
    8000153c:	b2898993          	addi	s3,s3,-1240 # 80010060 <tickslock>
    acquire(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	358040ef          	jal	8000589a <acquire>
    if(p->pid == pid){
    80001546:	589c                	lw	a5,48(s1)
    80001548:	01278b63          	beq	a5,s2,8000155e <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	3e4040ef          	jal	80005932 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001552:	16848493          	addi	s1,s1,360
    80001556:	ff3495e3          	bne	s1,s3,80001540 <kkill+0x20>
  }
  return -1;
    8000155a:	557d                	li	a0,-1
    8000155c:	a819                	j	80001572 <kkill+0x52>
      p->killed = 1;
    8000155e:	4785                	li	a5,1
    80001560:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001562:	4c98                	lw	a4,24(s1)
    80001564:	4789                	li	a5,2
    80001566:	00f70d63          	beq	a4,a5,80001580 <kkill+0x60>
      release(&p->lock);
    8000156a:	8526                	mv	a0,s1
    8000156c:	3c6040ef          	jal	80005932 <release>
      return 0;
    80001570:	4501                	li	a0,0
}
    80001572:	70a2                	ld	ra,40(sp)
    80001574:	7402                	ld	s0,32(sp)
    80001576:	64e2                	ld	s1,24(sp)
    80001578:	6942                	ld	s2,16(sp)
    8000157a:	69a2                	ld	s3,8(sp)
    8000157c:	6145                	addi	sp,sp,48
    8000157e:	8082                	ret
        p->state = RUNNABLE;
    80001580:	478d                	li	a5,3
    80001582:	cc9c                	sw	a5,24(s1)
    80001584:	b7dd                	j	8000156a <kkill+0x4a>

0000000080001586 <setkilled>:

void
setkilled(struct proc *p)
{
    80001586:	1101                	addi	sp,sp,-32
    80001588:	ec06                	sd	ra,24(sp)
    8000158a:	e822                	sd	s0,16(sp)
    8000158c:	e426                	sd	s1,8(sp)
    8000158e:	1000                	addi	s0,sp,32
    80001590:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001592:	308040ef          	jal	8000589a <acquire>
  p->killed = 1;
    80001596:	4785                	li	a5,1
    80001598:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	396040ef          	jal	80005932 <release>
}
    800015a0:	60e2                	ld	ra,24(sp)
    800015a2:	6442                	ld	s0,16(sp)
    800015a4:	64a2                	ld	s1,8(sp)
    800015a6:	6105                	addi	sp,sp,32
    800015a8:	8082                	ret

00000000800015aa <killed>:

int
killed(struct proc *p)
{
    800015aa:	1101                	addi	sp,sp,-32
    800015ac:	ec06                	sd	ra,24(sp)
    800015ae:	e822                	sd	s0,16(sp)
    800015b0:	e426                	sd	s1,8(sp)
    800015b2:	e04a                	sd	s2,0(sp)
    800015b4:	1000                	addi	s0,sp,32
    800015b6:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015b8:	2e2040ef          	jal	8000589a <acquire>
  k = p->killed;
    800015bc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015c0:	8526                	mv	a0,s1
    800015c2:	370040ef          	jal	80005932 <release>
  return k;
}
    800015c6:	854a                	mv	a0,s2
    800015c8:	60e2                	ld	ra,24(sp)
    800015ca:	6442                	ld	s0,16(sp)
    800015cc:	64a2                	ld	s1,8(sp)
    800015ce:	6902                	ld	s2,0(sp)
    800015d0:	6105                	addi	sp,sp,32
    800015d2:	8082                	ret

00000000800015d4 <kwait>:
{
    800015d4:	715d                	addi	sp,sp,-80
    800015d6:	e486                	sd	ra,72(sp)
    800015d8:	e0a2                	sd	s0,64(sp)
    800015da:	fc26                	sd	s1,56(sp)
    800015dc:	f84a                	sd	s2,48(sp)
    800015de:	f44e                	sd	s3,40(sp)
    800015e0:	f052                	sd	s4,32(sp)
    800015e2:	ec56                	sd	s5,24(sp)
    800015e4:	e85a                	sd	s6,16(sp)
    800015e6:	e45e                	sd	s7,8(sp)
    800015e8:	e062                	sd	s8,0(sp)
    800015ea:	0880                	addi	s0,sp,80
    800015ec:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015ee:	f8cff0ef          	jal	80000d7a <myproc>
    800015f2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015f4:	00009517          	auipc	a0,0x9
    800015f8:	c5450513          	addi	a0,a0,-940 # 8000a248 <wait_lock>
    800015fc:	29e040ef          	jal	8000589a <acquire>
    havekids = 0;
    80001600:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001602:	4a15                	li	s4,5
        havekids = 1;
    80001604:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001606:	0000f997          	auipc	s3,0xf
    8000160a:	a5a98993          	addi	s3,s3,-1446 # 80010060 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000160e:	00009c17          	auipc	s8,0x9
    80001612:	c3ac0c13          	addi	s8,s8,-966 # 8000a248 <wait_lock>
    80001616:	a871                	j	800016b2 <kwait+0xde>
          pid = pp->pid;
    80001618:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000161c:	000b0c63          	beqz	s6,80001634 <kwait+0x60>
    80001620:	4691                	li	a3,4
    80001622:	02c48613          	addi	a2,s1,44
    80001626:	85da                	mv	a1,s6
    80001628:	05093503          	ld	a0,80(s2)
    8000162c:	c62ff0ef          	jal	80000a8e <copyout>
    80001630:	02054b63          	bltz	a0,80001666 <kwait+0x92>
          freeproc(pp);
    80001634:	8526                	mv	a0,s1
    80001636:	915ff0ef          	jal	80000f4a <freeproc>
          release(&pp->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	2f6040ef          	jal	80005932 <release>
          release(&wait_lock);
    80001640:	00009517          	auipc	a0,0x9
    80001644:	c0850513          	addi	a0,a0,-1016 # 8000a248 <wait_lock>
    80001648:	2ea040ef          	jal	80005932 <release>
}
    8000164c:	854e                	mv	a0,s3
    8000164e:	60a6                	ld	ra,72(sp)
    80001650:	6406                	ld	s0,64(sp)
    80001652:	74e2                	ld	s1,56(sp)
    80001654:	7942                	ld	s2,48(sp)
    80001656:	79a2                	ld	s3,40(sp)
    80001658:	7a02                	ld	s4,32(sp)
    8000165a:	6ae2                	ld	s5,24(sp)
    8000165c:	6b42                	ld	s6,16(sp)
    8000165e:	6ba2                	ld	s7,8(sp)
    80001660:	6c02                	ld	s8,0(sp)
    80001662:	6161                	addi	sp,sp,80
    80001664:	8082                	ret
            release(&pp->lock);
    80001666:	8526                	mv	a0,s1
    80001668:	2ca040ef          	jal	80005932 <release>
            release(&wait_lock);
    8000166c:	00009517          	auipc	a0,0x9
    80001670:	bdc50513          	addi	a0,a0,-1060 # 8000a248 <wait_lock>
    80001674:	2be040ef          	jal	80005932 <release>
            return -1;
    80001678:	59fd                	li	s3,-1
    8000167a:	bfc9                	j	8000164c <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000167c:	16848493          	addi	s1,s1,360
    80001680:	03348063          	beq	s1,s3,800016a0 <kwait+0xcc>
      if(pp->parent == p){
    80001684:	7c9c                	ld	a5,56(s1)
    80001686:	ff279be3          	bne	a5,s2,8000167c <kwait+0xa8>
        acquire(&pp->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	20e040ef          	jal	8000589a <acquire>
        if(pp->state == ZOMBIE){
    80001690:	4c9c                	lw	a5,24(s1)
    80001692:	f94783e3          	beq	a5,s4,80001618 <kwait+0x44>
        release(&pp->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	29a040ef          	jal	80005932 <release>
        havekids = 1;
    8000169c:	8756                	mv	a4,s5
    8000169e:	bff9                	j	8000167c <kwait+0xa8>
    if(!havekids || killed(p)){
    800016a0:	cf19                	beqz	a4,800016be <kwait+0xea>
    800016a2:	854a                	mv	a0,s2
    800016a4:	f07ff0ef          	jal	800015aa <killed>
    800016a8:	e919                	bnez	a0,800016be <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016aa:	85e2                	mv	a1,s8
    800016ac:	854a                	mv	a0,s2
    800016ae:	cc5ff0ef          	jal	80001372 <sleep>
    havekids = 0;
    800016b2:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016b4:	00009497          	auipc	s1,0x9
    800016b8:	fac48493          	addi	s1,s1,-84 # 8000a660 <proc>
    800016bc:	b7e1                	j	80001684 <kwait+0xb0>
      release(&wait_lock);
    800016be:	00009517          	auipc	a0,0x9
    800016c2:	b8a50513          	addi	a0,a0,-1142 # 8000a248 <wait_lock>
    800016c6:	26c040ef          	jal	80005932 <release>
      return -1;
    800016ca:	59fd                	li	s3,-1
    800016cc:	b741                	j	8000164c <kwait+0x78>

00000000800016ce <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016ce:	7179                	addi	sp,sp,-48
    800016d0:	f406                	sd	ra,40(sp)
    800016d2:	f022                	sd	s0,32(sp)
    800016d4:	ec26                	sd	s1,24(sp)
    800016d6:	e84a                	sd	s2,16(sp)
    800016d8:	e44e                	sd	s3,8(sp)
    800016da:	e052                	sd	s4,0(sp)
    800016dc:	1800                	addi	s0,sp,48
    800016de:	84aa                	mv	s1,a0
    800016e0:	892e                	mv	s2,a1
    800016e2:	89b2                	mv	s3,a2
    800016e4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016e6:	e94ff0ef          	jal	80000d7a <myproc>
  if(user_dst){
    800016ea:	cc99                	beqz	s1,80001708 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016ec:	86d2                	mv	a3,s4
    800016ee:	864e                	mv	a2,s3
    800016f0:	85ca                	mv	a1,s2
    800016f2:	6928                	ld	a0,80(a0)
    800016f4:	b9aff0ef          	jal	80000a8e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016f8:	70a2                	ld	ra,40(sp)
    800016fa:	7402                	ld	s0,32(sp)
    800016fc:	64e2                	ld	s1,24(sp)
    800016fe:	6942                	ld	s2,16(sp)
    80001700:	69a2                	ld	s3,8(sp)
    80001702:	6a02                	ld	s4,0(sp)
    80001704:	6145                	addi	sp,sp,48
    80001706:	8082                	ret
    memmove((char *)dst, src, len);
    80001708:	000a061b          	sext.w	a2,s4
    8000170c:	85ce                	mv	a1,s3
    8000170e:	854a                	mv	a0,s2
    80001710:	a9bfe0ef          	jal	800001aa <memmove>
    return 0;
    80001714:	8526                	mv	a0,s1
    80001716:	b7cd                	j	800016f8 <either_copyout+0x2a>

0000000080001718 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001718:	7179                	addi	sp,sp,-48
    8000171a:	f406                	sd	ra,40(sp)
    8000171c:	f022                	sd	s0,32(sp)
    8000171e:	ec26                	sd	s1,24(sp)
    80001720:	e84a                	sd	s2,16(sp)
    80001722:	e44e                	sd	s3,8(sp)
    80001724:	e052                	sd	s4,0(sp)
    80001726:	1800                	addi	s0,sp,48
    80001728:	892a                	mv	s2,a0
    8000172a:	84ae                	mv	s1,a1
    8000172c:	89b2                	mv	s3,a2
    8000172e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001730:	e4aff0ef          	jal	80000d7a <myproc>
  if(user_src){
    80001734:	cc99                	beqz	s1,80001752 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001736:	86d2                	mv	a3,s4
    80001738:	864e                	mv	a2,s3
    8000173a:	85ca                	mv	a1,s2
    8000173c:	6928                	ld	a0,80(a0)
    8000173e:	c34ff0ef          	jal	80000b72 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001742:	70a2                	ld	ra,40(sp)
    80001744:	7402                	ld	s0,32(sp)
    80001746:	64e2                	ld	s1,24(sp)
    80001748:	6942                	ld	s2,16(sp)
    8000174a:	69a2                	ld	s3,8(sp)
    8000174c:	6a02                	ld	s4,0(sp)
    8000174e:	6145                	addi	sp,sp,48
    80001750:	8082                	ret
    memmove(dst, (char*)src, len);
    80001752:	000a061b          	sext.w	a2,s4
    80001756:	85ce                	mv	a1,s3
    80001758:	854a                	mv	a0,s2
    8000175a:	a51fe0ef          	jal	800001aa <memmove>
    return 0;
    8000175e:	8526                	mv	a0,s1
    80001760:	b7cd                	j	80001742 <either_copyin+0x2a>

0000000080001762 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001762:	715d                	addi	sp,sp,-80
    80001764:	e486                	sd	ra,72(sp)
    80001766:	e0a2                	sd	s0,64(sp)
    80001768:	fc26                	sd	s1,56(sp)
    8000176a:	f84a                	sd	s2,48(sp)
    8000176c:	f44e                	sd	s3,40(sp)
    8000176e:	f052                	sd	s4,32(sp)
    80001770:	ec56                	sd	s5,24(sp)
    80001772:	e85a                	sd	s6,16(sp)
    80001774:	e45e                	sd	s7,8(sp)
    80001776:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001778:	00006517          	auipc	a0,0x6
    8000177c:	8a050513          	addi	a0,a0,-1888 # 80007018 <etext+0x18>
    80001780:	379030ef          	jal	800052f8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001784:	00009497          	auipc	s1,0x9
    80001788:	03448493          	addi	s1,s1,52 # 8000a7b8 <proc+0x158>
    8000178c:	0000f917          	auipc	s2,0xf
    80001790:	a2c90913          	addi	s2,s2,-1492 # 800101b8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001794:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001796:	00006997          	auipc	s3,0x6
    8000179a:	a0a98993          	addi	s3,s3,-1526 # 800071a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    8000179e:	00006a97          	auipc	s5,0x6
    800017a2:	a0aa8a93          	addi	s5,s5,-1526 # 800071a8 <etext+0x1a8>
    printf("\n");
    800017a6:	00006a17          	auipc	s4,0x6
    800017aa:	872a0a13          	addi	s4,s4,-1934 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ae:	00006b97          	auipc	s7,0x6
    800017b2:	f92b8b93          	addi	s7,s7,-110 # 80007740 <states.0>
    800017b6:	a829                	j	800017d0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017b8:	ed86a583          	lw	a1,-296(a3)
    800017bc:	8556                	mv	a0,s5
    800017be:	33b030ef          	jal	800052f8 <printf>
    printf("\n");
    800017c2:	8552                	mv	a0,s4
    800017c4:	335030ef          	jal	800052f8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017c8:	16848493          	addi	s1,s1,360
    800017cc:	03248263          	beq	s1,s2,800017f0 <procdump+0x8e>
    if(p->state == UNUSED)
    800017d0:	86a6                	mv	a3,s1
    800017d2:	ec04a783          	lw	a5,-320(s1)
    800017d6:	dbed                	beqz	a5,800017c8 <procdump+0x66>
      state = "???";
    800017d8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017da:	fcfb6fe3          	bltu	s6,a5,800017b8 <procdump+0x56>
    800017de:	02079713          	slli	a4,a5,0x20
    800017e2:	01d75793          	srli	a5,a4,0x1d
    800017e6:	97de                	add	a5,a5,s7
    800017e8:	6390                	ld	a2,0(a5)
    800017ea:	f679                	bnez	a2,800017b8 <procdump+0x56>
      state = "???";
    800017ec:	864e                	mv	a2,s3
    800017ee:	b7e9                	j	800017b8 <procdump+0x56>
  }
}
    800017f0:	60a6                	ld	ra,72(sp)
    800017f2:	6406                	ld	s0,64(sp)
    800017f4:	74e2                	ld	s1,56(sp)
    800017f6:	7942                	ld	s2,48(sp)
    800017f8:	79a2                	ld	s3,40(sp)
    800017fa:	7a02                	ld	s4,32(sp)
    800017fc:	6ae2                	ld	s5,24(sp)
    800017fe:	6b42                	ld	s6,16(sp)
    80001800:	6ba2                	ld	s7,8(sp)
    80001802:	6161                	addi	sp,sp,80
    80001804:	8082                	ret

0000000080001806 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001806:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000180a:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000180e:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001810:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001812:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001816:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8000181a:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000181e:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001822:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001826:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000182a:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000182e:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001832:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001836:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000183a:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000183e:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001842:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001844:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001846:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000184a:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000184e:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001852:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001856:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000185a:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000185e:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001862:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001866:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000186a:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000186e:	8082                	ret

0000000080001870 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001870:	1141                	addi	sp,sp,-16
    80001872:	e406                	sd	ra,8(sp)
    80001874:	e022                	sd	s0,0(sp)
    80001876:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001878:	00006597          	auipc	a1,0x6
    8000187c:	97058593          	addi	a1,a1,-1680 # 800071e8 <etext+0x1e8>
    80001880:	0000e517          	auipc	a0,0xe
    80001884:	7e050513          	addi	a0,a0,2016 # 80010060 <tickslock>
    80001888:	793030ef          	jal	8000581a <initlock>
}
    8000188c:	60a2                	ld	ra,8(sp)
    8000188e:	6402                	ld	s0,0(sp)
    80001890:	0141                	addi	sp,sp,16
    80001892:	8082                	ret

0000000080001894 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001894:	1141                	addi	sp,sp,-16
    80001896:	e422                	sd	s0,8(sp)
    80001898:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000189a:	00003797          	auipc	a5,0x3
    8000189e:	f6678793          	addi	a5,a5,-154 # 80004800 <kernelvec>
    800018a2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018a6:	6422                	ld	s0,8(sp)
    800018a8:	0141                	addi	sp,sp,16
    800018aa:	8082                	ret

00000000800018ac <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018ac:	1141                	addi	sp,sp,-16
    800018ae:	e406                	sd	ra,8(sp)
    800018b0:	e022                	sd	s0,0(sp)
    800018b2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018b4:	cc6ff0ef          	jal	80000d7a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018bc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018be:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018c2:	04000737          	lui	a4,0x4000
    800018c6:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018c8:	0732                	slli	a4,a4,0xc
    800018ca:	00004797          	auipc	a5,0x4
    800018ce:	73678793          	addi	a5,a5,1846 # 80006000 <_trampoline>
    800018d2:	00004697          	auipc	a3,0x4
    800018d6:	72e68693          	addi	a3,a3,1838 # 80006000 <_trampoline>
    800018da:	8f95                	sub	a5,a5,a3
    800018dc:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018de:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018e2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018e4:	18002773          	csrr	a4,satp
    800018e8:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018ea:	6d38                	ld	a4,88(a0)
    800018ec:	613c                	ld	a5,64(a0)
    800018ee:	6685                	lui	a3,0x1
    800018f0:	97b6                	add	a5,a5,a3
    800018f2:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018f4:	6d3c                	ld	a5,88(a0)
    800018f6:	00000717          	auipc	a4,0x0
    800018fa:	0f870713          	addi	a4,a4,248 # 800019ee <usertrap>
    800018fe:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001900:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001902:	8712                	mv	a4,tp
    80001904:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001906:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000190a:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000190e:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001912:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001916:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001918:	6f9c                	ld	a5,24(a5)
    8000191a:	14179073          	csrw	sepc,a5
}
    8000191e:	60a2                	ld	ra,8(sp)
    80001920:	6402                	ld	s0,0(sp)
    80001922:	0141                	addi	sp,sp,16
    80001924:	8082                	ret

0000000080001926 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001926:	1101                	addi	sp,sp,-32
    80001928:	ec06                	sd	ra,24(sp)
    8000192a:	e822                	sd	s0,16(sp)
    8000192c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000192e:	c20ff0ef          	jal	80000d4e <cpuid>
    80001932:	cd11                	beqz	a0,8000194e <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001934:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001938:	000f4737          	lui	a4,0xf4
    8000193c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001940:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001942:	14d79073          	csrw	stimecmp,a5
}
    80001946:	60e2                	ld	ra,24(sp)
    80001948:	6442                	ld	s0,16(sp)
    8000194a:	6105                	addi	sp,sp,32
    8000194c:	8082                	ret
    8000194e:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001950:	0000e497          	auipc	s1,0xe
    80001954:	71048493          	addi	s1,s1,1808 # 80010060 <tickslock>
    80001958:	8526                	mv	a0,s1
    8000195a:	741030ef          	jal	8000589a <acquire>
    ticks++;
    8000195e:	00009517          	auipc	a0,0x9
    80001962:	89a50513          	addi	a0,a0,-1894 # 8000a1f8 <ticks>
    80001966:	411c                	lw	a5,0(a0)
    80001968:	2785                	addiw	a5,a5,1
    8000196a:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000196c:	a53ff0ef          	jal	800013be <wakeup>
    release(&tickslock);
    80001970:	8526                	mv	a0,s1
    80001972:	7c1030ef          	jal	80005932 <release>
    80001976:	64a2                	ld	s1,8(sp)
    80001978:	bf75                	j	80001934 <clockintr+0xe>

000000008000197a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000197a:	1101                	addi	sp,sp,-32
    8000197c:	ec06                	sd	ra,24(sp)
    8000197e:	e822                	sd	s0,16(sp)
    80001980:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001982:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001986:	57fd                	li	a5,-1
    80001988:	17fe                	slli	a5,a5,0x3f
    8000198a:	07a5                	addi	a5,a5,9
    8000198c:	00f70c63          	beq	a4,a5,800019a4 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001990:	57fd                	li	a5,-1
    80001992:	17fe                	slli	a5,a5,0x3f
    80001994:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001996:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001998:	04f70763          	beq	a4,a5,800019e6 <devintr+0x6c>
  }
}
    8000199c:	60e2                	ld	ra,24(sp)
    8000199e:	6442                	ld	s0,16(sp)
    800019a0:	6105                	addi	sp,sp,32
    800019a2:	8082                	ret
    800019a4:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019a6:	707020ef          	jal	800048ac <plic_claim>
    800019aa:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019ac:	47a9                	li	a5,10
    800019ae:	00f50963          	beq	a0,a5,800019c0 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019b2:	4785                	li	a5,1
    800019b4:	00f50963          	beq	a0,a5,800019c6 <devintr+0x4c>
    return 1;
    800019b8:	4505                	li	a0,1
    } else if(irq){
    800019ba:	e889                	bnez	s1,800019cc <devintr+0x52>
    800019bc:	64a2                	ld	s1,8(sp)
    800019be:	bff9                	j	8000199c <devintr+0x22>
      uartintr();
    800019c0:	5ef030ef          	jal	800057ae <uartintr>
    if(irq)
    800019c4:	a819                	j	800019da <devintr+0x60>
      virtio_disk_intr();
    800019c6:	3ac030ef          	jal	80004d72 <virtio_disk_intr>
    if(irq)
    800019ca:	a801                	j	800019da <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019cc:	85a6                	mv	a1,s1
    800019ce:	00006517          	auipc	a0,0x6
    800019d2:	82250513          	addi	a0,a0,-2014 # 800071f0 <etext+0x1f0>
    800019d6:	123030ef          	jal	800052f8 <printf>
      plic_complete(irq);
    800019da:	8526                	mv	a0,s1
    800019dc:	6f1020ef          	jal	800048cc <plic_complete>
    return 1;
    800019e0:	4505                	li	a0,1
    800019e2:	64a2                	ld	s1,8(sp)
    800019e4:	bf65                	j	8000199c <devintr+0x22>
    clockintr();
    800019e6:	f41ff0ef          	jal	80001926 <clockintr>
    return 2;
    800019ea:	4509                	li	a0,2
    800019ec:	bf45                	j	8000199c <devintr+0x22>

00000000800019ee <usertrap>:
{
    800019ee:	1101                	addi	sp,sp,-32
    800019f0:	ec06                	sd	ra,24(sp)
    800019f2:	e822                	sd	s0,16(sp)
    800019f4:	e426                	sd	s1,8(sp)
    800019f6:	e04a                	sd	s2,0(sp)
    800019f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019fa:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019fe:	1007f793          	andi	a5,a5,256
    80001a02:	eba5                	bnez	a5,80001a72 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a04:	00003797          	auipc	a5,0x3
    80001a08:	dfc78793          	addi	a5,a5,-516 # 80004800 <kernelvec>
    80001a0c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a10:	b6aff0ef          	jal	80000d7a <myproc>
    80001a14:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a16:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a18:	14102773          	csrr	a4,sepc
    80001a1c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a1e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a22:	47a1                	li	a5,8
    80001a24:	04f70d63          	beq	a4,a5,80001a7e <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a28:	f53ff0ef          	jal	8000197a <devintr>
    80001a2c:	892a                	mv	s2,a0
    80001a2e:	e945                	bnez	a0,80001ade <usertrap+0xf0>
    80001a30:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a34:	47bd                	li	a5,15
    80001a36:	08f70863          	beq	a4,a5,80001ac6 <usertrap+0xd8>
    80001a3a:	14202773          	csrr	a4,scause
    80001a3e:	47b5                	li	a5,13
    80001a40:	08f70363          	beq	a4,a5,80001ac6 <usertrap+0xd8>
    80001a44:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a48:	5890                	lw	a2,48(s1)
    80001a4a:	00005517          	auipc	a0,0x5
    80001a4e:	7e650513          	addi	a0,a0,2022 # 80007230 <etext+0x230>
    80001a52:	0a7030ef          	jal	800052f8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a56:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a5a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a5e:	00006517          	auipc	a0,0x6
    80001a62:	80250513          	addi	a0,a0,-2046 # 80007260 <etext+0x260>
    80001a66:	093030ef          	jal	800052f8 <printf>
    setkilled(p);
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	b1bff0ef          	jal	80001586 <setkilled>
    80001a70:	a035                	j	80001a9c <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a72:	00005517          	auipc	a0,0x5
    80001a76:	79e50513          	addi	a0,a0,1950 # 80007210 <etext+0x210>
    80001a7a:	365030ef          	jal	800055de <panic>
    if(killed(p))
    80001a7e:	b2dff0ef          	jal	800015aa <killed>
    80001a82:	ed15                	bnez	a0,80001abe <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001a84:	6cb8                	ld	a4,88(s1)
    80001a86:	6f1c                	ld	a5,24(a4)
    80001a88:	0791                	addi	a5,a5,4
    80001a8a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a90:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a94:	10079073          	csrw	sstatus,a5
    syscall();
    80001a98:	246000ef          	jal	80001cde <syscall>
  if(killed(p))
    80001a9c:	8526                	mv	a0,s1
    80001a9e:	b0dff0ef          	jal	800015aa <killed>
    80001aa2:	e139                	bnez	a0,80001ae8 <usertrap+0xfa>
  prepare_return();
    80001aa4:	e09ff0ef          	jal	800018ac <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001aa8:	68a8                	ld	a0,80(s1)
    80001aaa:	8131                	srli	a0,a0,0xc
    80001aac:	57fd                	li	a5,-1
    80001aae:	17fe                	slli	a5,a5,0x3f
    80001ab0:	8d5d                	or	a0,a0,a5
}
    80001ab2:	60e2                	ld	ra,24(sp)
    80001ab4:	6442                	ld	s0,16(sp)
    80001ab6:	64a2                	ld	s1,8(sp)
    80001ab8:	6902                	ld	s2,0(sp)
    80001aba:	6105                	addi	sp,sp,32
    80001abc:	8082                	ret
      kexit(-1);
    80001abe:	557d                	li	a0,-1
    80001ac0:	9bfff0ef          	jal	8000147e <kexit>
    80001ac4:	b7c1                	j	80001a84 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ac6:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aca:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001ace:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001ad0:	00163613          	seqz	a2,a2
    80001ad4:	68a8                	ld	a0,80(s1)
    80001ad6:	f37fe0ef          	jal	80000a0c <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001ada:	f169                	bnez	a0,80001a9c <usertrap+0xae>
    80001adc:	b7a5                	j	80001a44 <usertrap+0x56>
  if(killed(p))
    80001ade:	8526                	mv	a0,s1
    80001ae0:	acbff0ef          	jal	800015aa <killed>
    80001ae4:	c511                	beqz	a0,80001af0 <usertrap+0x102>
    80001ae6:	a011                	j	80001aea <usertrap+0xfc>
    80001ae8:	4901                	li	s2,0
    kexit(-1);
    80001aea:	557d                	li	a0,-1
    80001aec:	993ff0ef          	jal	8000147e <kexit>
  if(which_dev == 2)
    80001af0:	4789                	li	a5,2
    80001af2:	faf919e3          	bne	s2,a5,80001aa4 <usertrap+0xb6>
    yield();
    80001af6:	851ff0ef          	jal	80001346 <yield>
    80001afa:	b76d                	j	80001aa4 <usertrap+0xb6>

0000000080001afc <kerneltrap>:
{
    80001afc:	7179                	addi	sp,sp,-48
    80001afe:	f406                	sd	ra,40(sp)
    80001b00:	f022                	sd	s0,32(sp)
    80001b02:	ec26                	sd	s1,24(sp)
    80001b04:	e84a                	sd	s2,16(sp)
    80001b06:	e44e                	sd	s3,8(sp)
    80001b08:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b0a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b12:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b16:	1004f793          	andi	a5,s1,256
    80001b1a:	c795                	beqz	a5,80001b46 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b20:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b22:	eb85                	bnez	a5,80001b52 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b24:	e57ff0ef          	jal	8000197a <devintr>
    80001b28:	c91d                	beqz	a0,80001b5e <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b2a:	4789                	li	a5,2
    80001b2c:	04f50a63          	beq	a0,a5,80001b80 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b30:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b34:	10049073          	csrw	sstatus,s1
}
    80001b38:	70a2                	ld	ra,40(sp)
    80001b3a:	7402                	ld	s0,32(sp)
    80001b3c:	64e2                	ld	s1,24(sp)
    80001b3e:	6942                	ld	s2,16(sp)
    80001b40:	69a2                	ld	s3,8(sp)
    80001b42:	6145                	addi	sp,sp,48
    80001b44:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b46:	00005517          	auipc	a0,0x5
    80001b4a:	74250513          	addi	a0,a0,1858 # 80007288 <etext+0x288>
    80001b4e:	291030ef          	jal	800055de <panic>
    panic("kerneltrap: interrupts enabled");
    80001b52:	00005517          	auipc	a0,0x5
    80001b56:	75e50513          	addi	a0,a0,1886 # 800072b0 <etext+0x2b0>
    80001b5a:	285030ef          	jal	800055de <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b5e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b62:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b66:	85ce                	mv	a1,s3
    80001b68:	00005517          	auipc	a0,0x5
    80001b6c:	76850513          	addi	a0,a0,1896 # 800072d0 <etext+0x2d0>
    80001b70:	788030ef          	jal	800052f8 <printf>
    panic("kerneltrap");
    80001b74:	00005517          	auipc	a0,0x5
    80001b78:	78450513          	addi	a0,a0,1924 # 800072f8 <etext+0x2f8>
    80001b7c:	263030ef          	jal	800055de <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b80:	9faff0ef          	jal	80000d7a <myproc>
    80001b84:	d555                	beqz	a0,80001b30 <kerneltrap+0x34>
    yield();
    80001b86:	fc0ff0ef          	jal	80001346 <yield>
    80001b8a:	b75d                	j	80001b30 <kerneltrap+0x34>

0000000080001b8c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b8c:	1101                	addi	sp,sp,-32
    80001b8e:	ec06                	sd	ra,24(sp)
    80001b90:	e822                	sd	s0,16(sp)
    80001b92:	e426                	sd	s1,8(sp)
    80001b94:	1000                	addi	s0,sp,32
    80001b96:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b98:	9e2ff0ef          	jal	80000d7a <myproc>
  switch (n)
    80001b9c:	4795                	li	a5,5
    80001b9e:	0497e163          	bltu	a5,s1,80001be0 <argraw+0x54>
    80001ba2:	048a                	slli	s1,s1,0x2
    80001ba4:	00006717          	auipc	a4,0x6
    80001ba8:	bcc70713          	addi	a4,a4,-1076 # 80007770 <states.0+0x30>
    80001bac:	94ba                	add	s1,s1,a4
    80001bae:	409c                	lw	a5,0(s1)
    80001bb0:	97ba                	add	a5,a5,a4
    80001bb2:	8782                	jr	a5
  {
  case 0:
    return p->trapframe->a0;
    80001bb4:	6d3c                	ld	a5,88(a0)
    80001bb6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bb8:	60e2                	ld	ra,24(sp)
    80001bba:	6442                	ld	s0,16(sp)
    80001bbc:	64a2                	ld	s1,8(sp)
    80001bbe:	6105                	addi	sp,sp,32
    80001bc0:	8082                	ret
    return p->trapframe->a1;
    80001bc2:	6d3c                	ld	a5,88(a0)
    80001bc4:	7fa8                	ld	a0,120(a5)
    80001bc6:	bfcd                	j	80001bb8 <argraw+0x2c>
    return p->trapframe->a2;
    80001bc8:	6d3c                	ld	a5,88(a0)
    80001bca:	63c8                	ld	a0,128(a5)
    80001bcc:	b7f5                	j	80001bb8 <argraw+0x2c>
    return p->trapframe->a3;
    80001bce:	6d3c                	ld	a5,88(a0)
    80001bd0:	67c8                	ld	a0,136(a5)
    80001bd2:	b7dd                	j	80001bb8 <argraw+0x2c>
    return p->trapframe->a4;
    80001bd4:	6d3c                	ld	a5,88(a0)
    80001bd6:	6bc8                	ld	a0,144(a5)
    80001bd8:	b7c5                	j	80001bb8 <argraw+0x2c>
    return p->trapframe->a5;
    80001bda:	6d3c                	ld	a5,88(a0)
    80001bdc:	6fc8                	ld	a0,152(a5)
    80001bde:	bfe9                	j	80001bb8 <argraw+0x2c>
  panic("argraw");
    80001be0:	00005517          	auipc	a0,0x5
    80001be4:	72850513          	addi	a0,a0,1832 # 80007308 <etext+0x308>
    80001be8:	1f7030ef          	jal	800055de <panic>

0000000080001bec <fetchaddr>:
{
    80001bec:	1101                	addi	sp,sp,-32
    80001bee:	ec06                	sd	ra,24(sp)
    80001bf0:	e822                	sd	s0,16(sp)
    80001bf2:	e426                	sd	s1,8(sp)
    80001bf4:	e04a                	sd	s2,0(sp)
    80001bf6:	1000                	addi	s0,sp,32
    80001bf8:	84aa                	mv	s1,a0
    80001bfa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001bfc:	97eff0ef          	jal	80000d7a <myproc>
  if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c00:	653c                	ld	a5,72(a0)
    80001c02:	02f4f663          	bgeu	s1,a5,80001c2e <fetchaddr+0x42>
    80001c06:	00848713          	addi	a4,s1,8
    80001c0a:	02e7e463          	bltu	a5,a4,80001c32 <fetchaddr+0x46>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c0e:	46a1                	li	a3,8
    80001c10:	8626                	mv	a2,s1
    80001c12:	85ca                	mv	a1,s2
    80001c14:	6928                	ld	a0,80(a0)
    80001c16:	f5dfe0ef          	jal	80000b72 <copyin>
    80001c1a:	00a03533          	snez	a0,a0
    80001c1e:	40a00533          	neg	a0,a0
}
    80001c22:	60e2                	ld	ra,24(sp)
    80001c24:	6442                	ld	s0,16(sp)
    80001c26:	64a2                	ld	s1,8(sp)
    80001c28:	6902                	ld	s2,0(sp)
    80001c2a:	6105                	addi	sp,sp,32
    80001c2c:	8082                	ret
    return -1;
    80001c2e:	557d                	li	a0,-1
    80001c30:	bfcd                	j	80001c22 <fetchaddr+0x36>
    80001c32:	557d                	li	a0,-1
    80001c34:	b7fd                	j	80001c22 <fetchaddr+0x36>

0000000080001c36 <fetchstr>:
{
    80001c36:	7179                	addi	sp,sp,-48
    80001c38:	f406                	sd	ra,40(sp)
    80001c3a:	f022                	sd	s0,32(sp)
    80001c3c:	ec26                	sd	s1,24(sp)
    80001c3e:	e84a                	sd	s2,16(sp)
    80001c40:	e44e                	sd	s3,8(sp)
    80001c42:	1800                	addi	s0,sp,48
    80001c44:	892a                	mv	s2,a0
    80001c46:	84ae                	mv	s1,a1
    80001c48:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c4a:	930ff0ef          	jal	80000d7a <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c4e:	86ce                	mv	a3,s3
    80001c50:	864a                	mv	a2,s2
    80001c52:	85a6                	mv	a1,s1
    80001c54:	6928                	ld	a0,80(a0)
    80001c56:	cdffe0ef          	jal	80000934 <copyinstr>
    80001c5a:	00054c63          	bltz	a0,80001c72 <fetchstr+0x3c>
  return strlen(buf);
    80001c5e:	8526                	mv	a0,s1
    80001c60:	e5efe0ef          	jal	800002be <strlen>
}
    80001c64:	70a2                	ld	ra,40(sp)
    80001c66:	7402                	ld	s0,32(sp)
    80001c68:	64e2                	ld	s1,24(sp)
    80001c6a:	6942                	ld	s2,16(sp)
    80001c6c:	69a2                	ld	s3,8(sp)
    80001c6e:	6145                	addi	sp,sp,48
    80001c70:	8082                	ret
    return -1;
    80001c72:	557d                	li	a0,-1
    80001c74:	bfc5                	j	80001c64 <fetchstr+0x2e>

0000000080001c76 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80001c76:	1101                	addi	sp,sp,-32
    80001c78:	ec06                	sd	ra,24(sp)
    80001c7a:	e822                	sd	s0,16(sp)
    80001c7c:	e426                	sd	s1,8(sp)
    80001c7e:	1000                	addi	s0,sp,32
    80001c80:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c82:	f0bff0ef          	jal	80001b8c <argraw>
    80001c86:	c088                	sw	a0,0(s1)
}
    80001c88:	60e2                	ld	ra,24(sp)
    80001c8a:	6442                	ld	s0,16(sp)
    80001c8c:	64a2                	ld	s1,8(sp)
    80001c8e:	6105                	addi	sp,sp,32
    80001c90:	8082                	ret

0000000080001c92 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80001c92:	1101                	addi	sp,sp,-32
    80001c94:	ec06                	sd	ra,24(sp)
    80001c96:	e822                	sd	s0,16(sp)
    80001c98:	e426                	sd	s1,8(sp)
    80001c9a:	1000                	addi	s0,sp,32
    80001c9c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c9e:	eefff0ef          	jal	80001b8c <argraw>
    80001ca2:	e088                	sd	a0,0(s1)
}
    80001ca4:	60e2                	ld	ra,24(sp)
    80001ca6:	6442                	ld	s0,16(sp)
    80001ca8:	64a2                	ld	s1,8(sp)
    80001caa:	6105                	addi	sp,sp,32
    80001cac:	8082                	ret

0000000080001cae <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80001cae:	7179                	addi	sp,sp,-48
    80001cb0:	f406                	sd	ra,40(sp)
    80001cb2:	f022                	sd	s0,32(sp)
    80001cb4:	ec26                	sd	s1,24(sp)
    80001cb6:	e84a                	sd	s2,16(sp)
    80001cb8:	1800                	addi	s0,sp,48
    80001cba:	84ae                	mv	s1,a1
    80001cbc:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cbe:	fd840593          	addi	a1,s0,-40
    80001cc2:	fd1ff0ef          	jal	80001c92 <argaddr>
  return fetchstr(addr, buf, max);
    80001cc6:	864a                	mv	a2,s2
    80001cc8:	85a6                	mv	a1,s1
    80001cca:	fd843503          	ld	a0,-40(s0)
    80001cce:	f69ff0ef          	jal	80001c36 <fetchstr>
}
    80001cd2:	70a2                	ld	ra,40(sp)
    80001cd4:	7402                	ld	s0,32(sp)
    80001cd6:	64e2                	ld	s1,24(sp)
    80001cd8:	6942                	ld	s2,16(sp)
    80001cda:	6145                	addi	sp,sp,48
    80001cdc:	8082                	ret

0000000080001cde <syscall>:
    [SYS_close] sys_close,
    [SYS_hello] sys_hello,
};

void syscall(void)
{
    80001cde:	1101                	addi	sp,sp,-32
    80001ce0:	ec06                	sd	ra,24(sp)
    80001ce2:	e822                	sd	s0,16(sp)
    80001ce4:	e426                	sd	s1,8(sp)
    80001ce6:	e04a                	sd	s2,0(sp)
    80001ce8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001cea:	890ff0ef          	jal	80000d7a <myproc>
    80001cee:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001cf0:	05853903          	ld	s2,88(a0)
    80001cf4:	0a893783          	ld	a5,168(s2)
    80001cf8:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80001cfc:	37fd                	addiw	a5,a5,-1
    80001cfe:	4759                	li	a4,22
    80001d00:	00f76f63          	bltu	a4,a5,80001d1e <syscall+0x40>
    80001d04:	00369713          	slli	a4,a3,0x3
    80001d08:	00006797          	auipc	a5,0x6
    80001d0c:	a8078793          	addi	a5,a5,-1408 # 80007788 <syscalls>
    80001d10:	97ba                	add	a5,a5,a4
    80001d12:	639c                	ld	a5,0(a5)
    80001d14:	c789                	beqz	a5,80001d1e <syscall+0x40>
  {
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d16:	9782                	jalr	a5
    80001d18:	06a93823          	sd	a0,112(s2)
    80001d1c:	a829                	j	80001d36 <syscall+0x58>
  }
  else
  {
    printf("%d %s: unknown sys call %d\n",
    80001d1e:	15848613          	addi	a2,s1,344
    80001d22:	588c                	lw	a1,48(s1)
    80001d24:	00005517          	auipc	a0,0x5
    80001d28:	5ec50513          	addi	a0,a0,1516 # 80007310 <etext+0x310>
    80001d2c:	5cc030ef          	jal	800052f8 <printf>
           p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d30:	6cbc                	ld	a5,88(s1)
    80001d32:	577d                	li	a4,-1
    80001d34:	fbb8                	sd	a4,112(a5)
  }
}
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	6902                	ld	s2,0(sp)
    80001d3e:	6105                	addi	sp,sp,32
    80001d40:	8082                	ret

0000000080001d42 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001d42:	1101                	addi	sp,sp,-32
    80001d44:	ec06                	sd	ra,24(sp)
    80001d46:	e822                	sd	s0,16(sp)
    80001d48:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d4a:	fec40593          	addi	a1,s0,-20
    80001d4e:	4501                	li	a0,0
    80001d50:	f27ff0ef          	jal	80001c76 <argint>
  kexit(n);
    80001d54:	fec42503          	lw	a0,-20(s0)
    80001d58:	f26ff0ef          	jal	8000147e <kexit>
  return 0; // not reached
}
    80001d5c:	4501                	li	a0,0
    80001d5e:	60e2                	ld	ra,24(sp)
    80001d60:	6442                	ld	s0,16(sp)
    80001d62:	6105                	addi	sp,sp,32
    80001d64:	8082                	ret

0000000080001d66 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d66:	1141                	addi	sp,sp,-16
    80001d68:	e406                	sd	ra,8(sp)
    80001d6a:	e022                	sd	s0,0(sp)
    80001d6c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d6e:	80cff0ef          	jal	80000d7a <myproc>
}
    80001d72:	5908                	lw	a0,48(a0)
    80001d74:	60a2                	ld	ra,8(sp)
    80001d76:	6402                	ld	s0,0(sp)
    80001d78:	0141                	addi	sp,sp,16
    80001d7a:	8082                	ret

0000000080001d7c <sys_fork>:

uint64
sys_fork(void)
{
    80001d7c:	1141                	addi	sp,sp,-16
    80001d7e:	e406                	sd	ra,8(sp)
    80001d80:	e022                	sd	s0,0(sp)
    80001d82:	0800                	addi	s0,sp,16
  return kfork();
    80001d84:	b48ff0ef          	jal	800010cc <kfork>
}
    80001d88:	60a2                	ld	ra,8(sp)
    80001d8a:	6402                	ld	s0,0(sp)
    80001d8c:	0141                	addi	sp,sp,16
    80001d8e:	8082                	ret

0000000080001d90 <sys_wait>:

uint64
sys_wait(void)
{
    80001d90:	1101                	addi	sp,sp,-32
    80001d92:	ec06                	sd	ra,24(sp)
    80001d94:	e822                	sd	s0,16(sp)
    80001d96:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d98:	fe840593          	addi	a1,s0,-24
    80001d9c:	4501                	li	a0,0
    80001d9e:	ef5ff0ef          	jal	80001c92 <argaddr>
  return kwait(p);
    80001da2:	fe843503          	ld	a0,-24(s0)
    80001da6:	82fff0ef          	jal	800015d4 <kwait>
}
    80001daa:	60e2                	ld	ra,24(sp)
    80001dac:	6442                	ld	s0,16(sp)
    80001dae:	6105                	addi	sp,sp,32
    80001db0:	8082                	ret

0000000080001db2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001db2:	7179                	addi	sp,sp,-48
    80001db4:	f406                	sd	ra,40(sp)
    80001db6:	f022                	sd	s0,32(sp)
    80001db8:	ec26                	sd	s1,24(sp)
    80001dba:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001dbc:	fd840593          	addi	a1,s0,-40
    80001dc0:	4501                	li	a0,0
    80001dc2:	eb5ff0ef          	jal	80001c76 <argint>
  argint(1, &t);
    80001dc6:	fdc40593          	addi	a1,s0,-36
    80001dca:	4505                	li	a0,1
    80001dcc:	eabff0ef          	jal	80001c76 <argint>
  addr = myproc()->sz;
    80001dd0:	fabfe0ef          	jal	80000d7a <myproc>
    80001dd4:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0)
    80001dd6:	fdc42703          	lw	a4,-36(s0)
    80001dda:	4785                	li	a5,1
    80001ddc:	02f70163          	beq	a4,a5,80001dfe <sys_sbrk+0x4c>
    80001de0:	fd842783          	lw	a5,-40(s0)
    80001de4:	0007cd63          	bltz	a5,80001dfe <sys_sbrk+0x4c>
  else
  {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    80001de8:	97a6                	add	a5,a5,s1
    80001dea:	0297e863          	bltu	a5,s1,80001e1a <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001dee:	f8dfe0ef          	jal	80000d7a <myproc>
    80001df2:	fd842703          	lw	a4,-40(s0)
    80001df6:	653c                	ld	a5,72(a0)
    80001df8:	97ba                	add	a5,a5,a4
    80001dfa:	e53c                	sd	a5,72(a0)
    80001dfc:	a039                	j	80001e0a <sys_sbrk+0x58>
    if (growproc(n) < 0)
    80001dfe:	fd842503          	lw	a0,-40(s0)
    80001e02:	a7aff0ef          	jal	8000107c <growproc>
    80001e06:	00054863          	bltz	a0,80001e16 <sys_sbrk+0x64>
  }
  return addr;
}
    80001e0a:	8526                	mv	a0,s1
    80001e0c:	70a2                	ld	ra,40(sp)
    80001e0e:	7402                	ld	s0,32(sp)
    80001e10:	64e2                	ld	s1,24(sp)
    80001e12:	6145                	addi	sp,sp,48
    80001e14:	8082                	ret
      return -1;
    80001e16:	54fd                	li	s1,-1
    80001e18:	bfcd                	j	80001e0a <sys_sbrk+0x58>
      return -1;
    80001e1a:	54fd                	li	s1,-1
    80001e1c:	b7fd                	j	80001e0a <sys_sbrk+0x58>

0000000080001e1e <sys_pause>:

uint64
sys_pause(void)
{
    80001e1e:	7139                	addi	sp,sp,-64
    80001e20:	fc06                	sd	ra,56(sp)
    80001e22:	f822                	sd	s0,48(sp)
    80001e24:	f04a                	sd	s2,32(sp)
    80001e26:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e28:	fcc40593          	addi	a1,s0,-52
    80001e2c:	4501                	li	a0,0
    80001e2e:	e49ff0ef          	jal	80001c76 <argint>
  if (n < 0)
    80001e32:	fcc42783          	lw	a5,-52(s0)
    80001e36:	0607c763          	bltz	a5,80001ea4 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001e3a:	0000e517          	auipc	a0,0xe
    80001e3e:	22650513          	addi	a0,a0,550 # 80010060 <tickslock>
    80001e42:	259030ef          	jal	8000589a <acquire>
  ticks0 = ticks;
    80001e46:	00008917          	auipc	s2,0x8
    80001e4a:	3b292903          	lw	s2,946(s2) # 8000a1f8 <ticks>
  while (ticks - ticks0 < n)
    80001e4e:	fcc42783          	lw	a5,-52(s0)
    80001e52:	cf8d                	beqz	a5,80001e8c <sys_pause+0x6e>
    80001e54:	f426                	sd	s1,40(sp)
    80001e56:	ec4e                	sd	s3,24(sp)
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e58:	0000e997          	auipc	s3,0xe
    80001e5c:	20898993          	addi	s3,s3,520 # 80010060 <tickslock>
    80001e60:	00008497          	auipc	s1,0x8
    80001e64:	39848493          	addi	s1,s1,920 # 8000a1f8 <ticks>
    if (killed(myproc()))
    80001e68:	f13fe0ef          	jal	80000d7a <myproc>
    80001e6c:	f3eff0ef          	jal	800015aa <killed>
    80001e70:	ed0d                	bnez	a0,80001eaa <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001e72:	85ce                	mv	a1,s3
    80001e74:	8526                	mv	a0,s1
    80001e76:	cfcff0ef          	jal	80001372 <sleep>
  while (ticks - ticks0 < n)
    80001e7a:	409c                	lw	a5,0(s1)
    80001e7c:	412787bb          	subw	a5,a5,s2
    80001e80:	fcc42703          	lw	a4,-52(s0)
    80001e84:	fee7e2e3          	bltu	a5,a4,80001e68 <sys_pause+0x4a>
    80001e88:	74a2                	ld	s1,40(sp)
    80001e8a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001e8c:	0000e517          	auipc	a0,0xe
    80001e90:	1d450513          	addi	a0,a0,468 # 80010060 <tickslock>
    80001e94:	29f030ef          	jal	80005932 <release>
  return 0;
    80001e98:	4501                	li	a0,0
}
    80001e9a:	70e2                	ld	ra,56(sp)
    80001e9c:	7442                	ld	s0,48(sp)
    80001e9e:	7902                	ld	s2,32(sp)
    80001ea0:	6121                	addi	sp,sp,64
    80001ea2:	8082                	ret
    n = 0;
    80001ea4:	fc042623          	sw	zero,-52(s0)
    80001ea8:	bf49                	j	80001e3a <sys_pause+0x1c>
      release(&tickslock);
    80001eaa:	0000e517          	auipc	a0,0xe
    80001eae:	1b650513          	addi	a0,a0,438 # 80010060 <tickslock>
    80001eb2:	281030ef          	jal	80005932 <release>
      return -1;
    80001eb6:	557d                	li	a0,-1
    80001eb8:	74a2                	ld	s1,40(sp)
    80001eba:	69e2                	ld	s3,24(sp)
    80001ebc:	bff9                	j	80001e9a <sys_pause+0x7c>

0000000080001ebe <sys_kill>:

uint64
sys_kill(void)
{
    80001ebe:	1101                	addi	sp,sp,-32
    80001ec0:	ec06                	sd	ra,24(sp)
    80001ec2:	e822                	sd	s0,16(sp)
    80001ec4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ec6:	fec40593          	addi	a1,s0,-20
    80001eca:	4501                	li	a0,0
    80001ecc:	dabff0ef          	jal	80001c76 <argint>
  return kkill(pid);
    80001ed0:	fec42503          	lw	a0,-20(s0)
    80001ed4:	e4cff0ef          	jal	80001520 <kkill>
}
    80001ed8:	60e2                	ld	ra,24(sp)
    80001eda:	6442                	ld	s0,16(sp)
    80001edc:	6105                	addi	sp,sp,32
    80001ede:	8082                	ret

0000000080001ee0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001ee0:	1101                	addi	sp,sp,-32
    80001ee2:	ec06                	sd	ra,24(sp)
    80001ee4:	e822                	sd	s0,16(sp)
    80001ee6:	e426                	sd	s1,8(sp)
    80001ee8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001eea:	0000e517          	auipc	a0,0xe
    80001eee:	17650513          	addi	a0,a0,374 # 80010060 <tickslock>
    80001ef2:	1a9030ef          	jal	8000589a <acquire>
  xticks = ticks;
    80001ef6:	00008497          	auipc	s1,0x8
    80001efa:	3024a483          	lw	s1,770(s1) # 8000a1f8 <ticks>
  release(&tickslock);
    80001efe:	0000e517          	auipc	a0,0xe
    80001f02:	16250513          	addi	a0,a0,354 # 80010060 <tickslock>
    80001f06:	22d030ef          	jal	80005932 <release>
  return xticks;
}
    80001f0a:	02049513          	slli	a0,s1,0x20
    80001f0e:	9101                	srli	a0,a0,0x20
    80001f10:	60e2                	ld	ra,24(sp)
    80001f12:	6442                	ld	s0,16(sp)
    80001f14:	64a2                	ld	s1,8(sp)
    80001f16:	6105                	addi	sp,sp,32
    80001f18:	8082                	ret

0000000080001f1a <sys_hello>:

uint64
sys_hello(void)
{
    80001f1a:	1141                	addi	sp,sp,-16
    80001f1c:	e406                	sd	ra,8(sp)
    80001f1e:	e022                	sd	s0,0(sp)
    80001f20:	0800                	addi	s0,sp,16
  printf("Hello from kernel syscall!\n");
    80001f22:	00005517          	auipc	a0,0x5
    80001f26:	40e50513          	addi	a0,a0,1038 # 80007330 <etext+0x330>
    80001f2a:	3ce030ef          	jal	800052f8 <printf>
  printf("I am ICT1012!\n");
    80001f2e:	00005517          	auipc	a0,0x5
    80001f32:	42250513          	addi	a0,a0,1058 # 80007350 <etext+0x350>
    80001f36:	3c2030ef          	jal	800052f8 <printf>
  return 0;
    80001f3a:	4501                	li	a0,0
    80001f3c:	60a2                	ld	ra,8(sp)
    80001f3e:	6402                	ld	s0,0(sp)
    80001f40:	0141                	addi	sp,sp,16
    80001f42:	8082                	ret

0000000080001f44 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f44:	7179                	addi	sp,sp,-48
    80001f46:	f406                	sd	ra,40(sp)
    80001f48:	f022                	sd	s0,32(sp)
    80001f4a:	ec26                	sd	s1,24(sp)
    80001f4c:	e84a                	sd	s2,16(sp)
    80001f4e:	e44e                	sd	s3,8(sp)
    80001f50:	e052                	sd	s4,0(sp)
    80001f52:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f54:	00005597          	auipc	a1,0x5
    80001f58:	40c58593          	addi	a1,a1,1036 # 80007360 <etext+0x360>
    80001f5c:	0000e517          	auipc	a0,0xe
    80001f60:	11c50513          	addi	a0,a0,284 # 80010078 <bcache>
    80001f64:	0b7030ef          	jal	8000581a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f68:	00016797          	auipc	a5,0x16
    80001f6c:	11078793          	addi	a5,a5,272 # 80018078 <bcache+0x8000>
    80001f70:	00016717          	auipc	a4,0x16
    80001f74:	37070713          	addi	a4,a4,880 # 800182e0 <bcache+0x8268>
    80001f78:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f7c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f80:	0000e497          	auipc	s1,0xe
    80001f84:	11048493          	addi	s1,s1,272 # 80010090 <bcache+0x18>
    b->next = bcache.head.next;
    80001f88:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f8a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f8c:	00005a17          	auipc	s4,0x5
    80001f90:	3dca0a13          	addi	s4,s4,988 # 80007368 <etext+0x368>
    b->next = bcache.head.next;
    80001f94:	2b893783          	ld	a5,696(s2)
    80001f98:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001f9a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001f9e:	85d2                	mv	a1,s4
    80001fa0:	01048513          	addi	a0,s1,16
    80001fa4:	322010ef          	jal	800032c6 <initsleeplock>
    bcache.head.next->prev = b;
    80001fa8:	2b893783          	ld	a5,696(s2)
    80001fac:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001fae:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fb2:	45848493          	addi	s1,s1,1112
    80001fb6:	fd349fe3          	bne	s1,s3,80001f94 <binit+0x50>
  }
}
    80001fba:	70a2                	ld	ra,40(sp)
    80001fbc:	7402                	ld	s0,32(sp)
    80001fbe:	64e2                	ld	s1,24(sp)
    80001fc0:	6942                	ld	s2,16(sp)
    80001fc2:	69a2                	ld	s3,8(sp)
    80001fc4:	6a02                	ld	s4,0(sp)
    80001fc6:	6145                	addi	sp,sp,48
    80001fc8:	8082                	ret

0000000080001fca <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001fca:	7179                	addi	sp,sp,-48
    80001fcc:	f406                	sd	ra,40(sp)
    80001fce:	f022                	sd	s0,32(sp)
    80001fd0:	ec26                	sd	s1,24(sp)
    80001fd2:	e84a                	sd	s2,16(sp)
    80001fd4:	e44e                	sd	s3,8(sp)
    80001fd6:	1800                	addi	s0,sp,48
    80001fd8:	892a                	mv	s2,a0
    80001fda:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001fdc:	0000e517          	auipc	a0,0xe
    80001fe0:	09c50513          	addi	a0,a0,156 # 80010078 <bcache>
    80001fe4:	0b7030ef          	jal	8000589a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001fe8:	00016497          	auipc	s1,0x16
    80001fec:	3484b483          	ld	s1,840(s1) # 80018330 <bcache+0x82b8>
    80001ff0:	00016797          	auipc	a5,0x16
    80001ff4:	2f078793          	addi	a5,a5,752 # 800182e0 <bcache+0x8268>
    80001ff8:	02f48b63          	beq	s1,a5,8000202e <bread+0x64>
    80001ffc:	873e                	mv	a4,a5
    80001ffe:	a021                	j	80002006 <bread+0x3c>
    80002000:	68a4                	ld	s1,80(s1)
    80002002:	02e48663          	beq	s1,a4,8000202e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002006:	449c                	lw	a5,8(s1)
    80002008:	ff279ce3          	bne	a5,s2,80002000 <bread+0x36>
    8000200c:	44dc                	lw	a5,12(s1)
    8000200e:	ff3799e3          	bne	a5,s3,80002000 <bread+0x36>
      b->refcnt++;
    80002012:	40bc                	lw	a5,64(s1)
    80002014:	2785                	addiw	a5,a5,1
    80002016:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002018:	0000e517          	auipc	a0,0xe
    8000201c:	06050513          	addi	a0,a0,96 # 80010078 <bcache>
    80002020:	113030ef          	jal	80005932 <release>
      acquiresleep(&b->lock);
    80002024:	01048513          	addi	a0,s1,16
    80002028:	2d4010ef          	jal	800032fc <acquiresleep>
      return b;
    8000202c:	a889                	j	8000207e <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000202e:	00016497          	auipc	s1,0x16
    80002032:	2fa4b483          	ld	s1,762(s1) # 80018328 <bcache+0x82b0>
    80002036:	00016797          	auipc	a5,0x16
    8000203a:	2aa78793          	addi	a5,a5,682 # 800182e0 <bcache+0x8268>
    8000203e:	00f48863          	beq	s1,a5,8000204e <bread+0x84>
    80002042:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002044:	40bc                	lw	a5,64(s1)
    80002046:	cb91                	beqz	a5,8000205a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002048:	64a4                	ld	s1,72(s1)
    8000204a:	fee49de3          	bne	s1,a4,80002044 <bread+0x7a>
  panic("bget: no buffers");
    8000204e:	00005517          	auipc	a0,0x5
    80002052:	32250513          	addi	a0,a0,802 # 80007370 <etext+0x370>
    80002056:	588030ef          	jal	800055de <panic>
      b->dev = dev;
    8000205a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000205e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002062:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002066:	4785                	li	a5,1
    80002068:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000206a:	0000e517          	auipc	a0,0xe
    8000206e:	00e50513          	addi	a0,a0,14 # 80010078 <bcache>
    80002072:	0c1030ef          	jal	80005932 <release>
      acquiresleep(&b->lock);
    80002076:	01048513          	addi	a0,s1,16
    8000207a:	282010ef          	jal	800032fc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000207e:	409c                	lw	a5,0(s1)
    80002080:	cb89                	beqz	a5,80002092 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002082:	8526                	mv	a0,s1
    80002084:	70a2                	ld	ra,40(sp)
    80002086:	7402                	ld	s0,32(sp)
    80002088:	64e2                	ld	s1,24(sp)
    8000208a:	6942                	ld	s2,16(sp)
    8000208c:	69a2                	ld	s3,8(sp)
    8000208e:	6145                	addi	sp,sp,48
    80002090:	8082                	ret
    virtio_disk_rw(b, 0);
    80002092:	4581                	li	a1,0
    80002094:	8526                	mv	a0,s1
    80002096:	2cb020ef          	jal	80004b60 <virtio_disk_rw>
    b->valid = 1;
    8000209a:	4785                	li	a5,1
    8000209c:	c09c                	sw	a5,0(s1)
  return b;
    8000209e:	b7d5                	j	80002082 <bread+0xb8>

00000000800020a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020a0:	1101                	addi	sp,sp,-32
    800020a2:	ec06                	sd	ra,24(sp)
    800020a4:	e822                	sd	s0,16(sp)
    800020a6:	e426                	sd	s1,8(sp)
    800020a8:	1000                	addi	s0,sp,32
    800020aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020ac:	0541                	addi	a0,a0,16
    800020ae:	2cc010ef          	jal	8000337a <holdingsleep>
    800020b2:	c911                	beqz	a0,800020c6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020b4:	4585                	li	a1,1
    800020b6:	8526                	mv	a0,s1
    800020b8:	2a9020ef          	jal	80004b60 <virtio_disk_rw>
}
    800020bc:	60e2                	ld	ra,24(sp)
    800020be:	6442                	ld	s0,16(sp)
    800020c0:	64a2                	ld	s1,8(sp)
    800020c2:	6105                	addi	sp,sp,32
    800020c4:	8082                	ret
    panic("bwrite");
    800020c6:	00005517          	auipc	a0,0x5
    800020ca:	2c250513          	addi	a0,a0,706 # 80007388 <etext+0x388>
    800020ce:	510030ef          	jal	800055de <panic>

00000000800020d2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020d2:	1101                	addi	sp,sp,-32
    800020d4:	ec06                	sd	ra,24(sp)
    800020d6:	e822                	sd	s0,16(sp)
    800020d8:	e426                	sd	s1,8(sp)
    800020da:	e04a                	sd	s2,0(sp)
    800020dc:	1000                	addi	s0,sp,32
    800020de:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020e0:	01050913          	addi	s2,a0,16
    800020e4:	854a                	mv	a0,s2
    800020e6:	294010ef          	jal	8000337a <holdingsleep>
    800020ea:	c135                	beqz	a0,8000214e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800020ec:	854a                	mv	a0,s2
    800020ee:	254010ef          	jal	80003342 <releasesleep>

  acquire(&bcache.lock);
    800020f2:	0000e517          	auipc	a0,0xe
    800020f6:	f8650513          	addi	a0,a0,-122 # 80010078 <bcache>
    800020fa:	7a0030ef          	jal	8000589a <acquire>
  b->refcnt--;
    800020fe:	40bc                	lw	a5,64(s1)
    80002100:	37fd                	addiw	a5,a5,-1
    80002102:	0007871b          	sext.w	a4,a5
    80002106:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002108:	e71d                	bnez	a4,80002136 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000210a:	68b8                	ld	a4,80(s1)
    8000210c:	64bc                	ld	a5,72(s1)
    8000210e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002110:	68b8                	ld	a4,80(s1)
    80002112:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002114:	00016797          	auipc	a5,0x16
    80002118:	f6478793          	addi	a5,a5,-156 # 80018078 <bcache+0x8000>
    8000211c:	2b87b703          	ld	a4,696(a5)
    80002120:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002122:	00016717          	auipc	a4,0x16
    80002126:	1be70713          	addi	a4,a4,446 # 800182e0 <bcache+0x8268>
    8000212a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000212c:	2b87b703          	ld	a4,696(a5)
    80002130:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002132:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002136:	0000e517          	auipc	a0,0xe
    8000213a:	f4250513          	addi	a0,a0,-190 # 80010078 <bcache>
    8000213e:	7f4030ef          	jal	80005932 <release>
}
    80002142:	60e2                	ld	ra,24(sp)
    80002144:	6442                	ld	s0,16(sp)
    80002146:	64a2                	ld	s1,8(sp)
    80002148:	6902                	ld	s2,0(sp)
    8000214a:	6105                	addi	sp,sp,32
    8000214c:	8082                	ret
    panic("brelse");
    8000214e:	00005517          	auipc	a0,0x5
    80002152:	24250513          	addi	a0,a0,578 # 80007390 <etext+0x390>
    80002156:	488030ef          	jal	800055de <panic>

000000008000215a <bpin>:

void
bpin(struct buf *b) {
    8000215a:	1101                	addi	sp,sp,-32
    8000215c:	ec06                	sd	ra,24(sp)
    8000215e:	e822                	sd	s0,16(sp)
    80002160:	e426                	sd	s1,8(sp)
    80002162:	1000                	addi	s0,sp,32
    80002164:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002166:	0000e517          	auipc	a0,0xe
    8000216a:	f1250513          	addi	a0,a0,-238 # 80010078 <bcache>
    8000216e:	72c030ef          	jal	8000589a <acquire>
  b->refcnt++;
    80002172:	40bc                	lw	a5,64(s1)
    80002174:	2785                	addiw	a5,a5,1
    80002176:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002178:	0000e517          	auipc	a0,0xe
    8000217c:	f0050513          	addi	a0,a0,-256 # 80010078 <bcache>
    80002180:	7b2030ef          	jal	80005932 <release>
}
    80002184:	60e2                	ld	ra,24(sp)
    80002186:	6442                	ld	s0,16(sp)
    80002188:	64a2                	ld	s1,8(sp)
    8000218a:	6105                	addi	sp,sp,32
    8000218c:	8082                	ret

000000008000218e <bunpin>:

void
bunpin(struct buf *b) {
    8000218e:	1101                	addi	sp,sp,-32
    80002190:	ec06                	sd	ra,24(sp)
    80002192:	e822                	sd	s0,16(sp)
    80002194:	e426                	sd	s1,8(sp)
    80002196:	1000                	addi	s0,sp,32
    80002198:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000219a:	0000e517          	auipc	a0,0xe
    8000219e:	ede50513          	addi	a0,a0,-290 # 80010078 <bcache>
    800021a2:	6f8030ef          	jal	8000589a <acquire>
  b->refcnt--;
    800021a6:	40bc                	lw	a5,64(s1)
    800021a8:	37fd                	addiw	a5,a5,-1
    800021aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021ac:	0000e517          	auipc	a0,0xe
    800021b0:	ecc50513          	addi	a0,a0,-308 # 80010078 <bcache>
    800021b4:	77e030ef          	jal	80005932 <release>
}
    800021b8:	60e2                	ld	ra,24(sp)
    800021ba:	6442                	ld	s0,16(sp)
    800021bc:	64a2                	ld	s1,8(sp)
    800021be:	6105                	addi	sp,sp,32
    800021c0:	8082                	ret

00000000800021c2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800021c2:	1101                	addi	sp,sp,-32
    800021c4:	ec06                	sd	ra,24(sp)
    800021c6:	e822                	sd	s0,16(sp)
    800021c8:	e426                	sd	s1,8(sp)
    800021ca:	e04a                	sd	s2,0(sp)
    800021cc:	1000                	addi	s0,sp,32
    800021ce:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021d0:	00d5d59b          	srliw	a1,a1,0xd
    800021d4:	00016797          	auipc	a5,0x16
    800021d8:	5807a783          	lw	a5,1408(a5) # 80018754 <sb+0x1c>
    800021dc:	9dbd                	addw	a1,a1,a5
    800021de:	dedff0ef          	jal	80001fca <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800021e2:	0074f713          	andi	a4,s1,7
    800021e6:	4785                	li	a5,1
    800021e8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800021ec:	14ce                	slli	s1,s1,0x33
    800021ee:	90d9                	srli	s1,s1,0x36
    800021f0:	00950733          	add	a4,a0,s1
    800021f4:	05874703          	lbu	a4,88(a4)
    800021f8:	00e7f6b3          	and	a3,a5,a4
    800021fc:	c29d                	beqz	a3,80002222 <bfree+0x60>
    800021fe:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002200:	94aa                	add	s1,s1,a0
    80002202:	fff7c793          	not	a5,a5
    80002206:	8f7d                	and	a4,a4,a5
    80002208:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000220c:	7f9000ef          	jal	80003204 <log_write>
  brelse(bp);
    80002210:	854a                	mv	a0,s2
    80002212:	ec1ff0ef          	jal	800020d2 <brelse>
}
    80002216:	60e2                	ld	ra,24(sp)
    80002218:	6442                	ld	s0,16(sp)
    8000221a:	64a2                	ld	s1,8(sp)
    8000221c:	6902                	ld	s2,0(sp)
    8000221e:	6105                	addi	sp,sp,32
    80002220:	8082                	ret
    panic("freeing free block");
    80002222:	00005517          	auipc	a0,0x5
    80002226:	17650513          	addi	a0,a0,374 # 80007398 <etext+0x398>
    8000222a:	3b4030ef          	jal	800055de <panic>

000000008000222e <balloc>:
{
    8000222e:	711d                	addi	sp,sp,-96
    80002230:	ec86                	sd	ra,88(sp)
    80002232:	e8a2                	sd	s0,80(sp)
    80002234:	e4a6                	sd	s1,72(sp)
    80002236:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002238:	00016797          	auipc	a5,0x16
    8000223c:	5047a783          	lw	a5,1284(a5) # 8001873c <sb+0x4>
    80002240:	0e078f63          	beqz	a5,8000233e <balloc+0x110>
    80002244:	e0ca                	sd	s2,64(sp)
    80002246:	fc4e                	sd	s3,56(sp)
    80002248:	f852                	sd	s4,48(sp)
    8000224a:	f456                	sd	s5,40(sp)
    8000224c:	f05a                	sd	s6,32(sp)
    8000224e:	ec5e                	sd	s7,24(sp)
    80002250:	e862                	sd	s8,16(sp)
    80002252:	e466                	sd	s9,8(sp)
    80002254:	8baa                	mv	s7,a0
    80002256:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002258:	00016b17          	auipc	s6,0x16
    8000225c:	4e0b0b13          	addi	s6,s6,1248 # 80018738 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002260:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002262:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002264:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002266:	6c89                	lui	s9,0x2
    80002268:	a0b5                	j	800022d4 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000226a:	97ca                	add	a5,a5,s2
    8000226c:	8e55                	or	a2,a2,a3
    8000226e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002272:	854a                	mv	a0,s2
    80002274:	791000ef          	jal	80003204 <log_write>
        brelse(bp);
    80002278:	854a                	mv	a0,s2
    8000227a:	e59ff0ef          	jal	800020d2 <brelse>
  bp = bread(dev, bno);
    8000227e:	85a6                	mv	a1,s1
    80002280:	855e                	mv	a0,s7
    80002282:	d49ff0ef          	jal	80001fca <bread>
    80002286:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002288:	40000613          	li	a2,1024
    8000228c:	4581                	li	a1,0
    8000228e:	05850513          	addi	a0,a0,88
    80002292:	ebdfd0ef          	jal	8000014e <memset>
  log_write(bp);
    80002296:	854a                	mv	a0,s2
    80002298:	76d000ef          	jal	80003204 <log_write>
  brelse(bp);
    8000229c:	854a                	mv	a0,s2
    8000229e:	e35ff0ef          	jal	800020d2 <brelse>
}
    800022a2:	6906                	ld	s2,64(sp)
    800022a4:	79e2                	ld	s3,56(sp)
    800022a6:	7a42                	ld	s4,48(sp)
    800022a8:	7aa2                	ld	s5,40(sp)
    800022aa:	7b02                	ld	s6,32(sp)
    800022ac:	6be2                	ld	s7,24(sp)
    800022ae:	6c42                	ld	s8,16(sp)
    800022b0:	6ca2                	ld	s9,8(sp)
}
    800022b2:	8526                	mv	a0,s1
    800022b4:	60e6                	ld	ra,88(sp)
    800022b6:	6446                	ld	s0,80(sp)
    800022b8:	64a6                	ld	s1,72(sp)
    800022ba:	6125                	addi	sp,sp,96
    800022bc:	8082                	ret
    brelse(bp);
    800022be:	854a                	mv	a0,s2
    800022c0:	e13ff0ef          	jal	800020d2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800022c4:	015c87bb          	addw	a5,s9,s5
    800022c8:	00078a9b          	sext.w	s5,a5
    800022cc:	004b2703          	lw	a4,4(s6)
    800022d0:	04eaff63          	bgeu	s5,a4,8000232e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800022d4:	41fad79b          	sraiw	a5,s5,0x1f
    800022d8:	0137d79b          	srliw	a5,a5,0x13
    800022dc:	015787bb          	addw	a5,a5,s5
    800022e0:	40d7d79b          	sraiw	a5,a5,0xd
    800022e4:	01cb2583          	lw	a1,28(s6)
    800022e8:	9dbd                	addw	a1,a1,a5
    800022ea:	855e                	mv	a0,s7
    800022ec:	cdfff0ef          	jal	80001fca <bread>
    800022f0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022f2:	004b2503          	lw	a0,4(s6)
    800022f6:	000a849b          	sext.w	s1,s5
    800022fa:	8762                	mv	a4,s8
    800022fc:	fca4f1e3          	bgeu	s1,a0,800022be <balloc+0x90>
      m = 1 << (bi % 8);
    80002300:	00777693          	andi	a3,a4,7
    80002304:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002308:	41f7579b          	sraiw	a5,a4,0x1f
    8000230c:	01d7d79b          	srliw	a5,a5,0x1d
    80002310:	9fb9                	addw	a5,a5,a4
    80002312:	4037d79b          	sraiw	a5,a5,0x3
    80002316:	00f90633          	add	a2,s2,a5
    8000231a:	05864603          	lbu	a2,88(a2)
    8000231e:	00c6f5b3          	and	a1,a3,a2
    80002322:	d5a1                	beqz	a1,8000226a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002324:	2705                	addiw	a4,a4,1
    80002326:	2485                	addiw	s1,s1,1
    80002328:	fd471ae3          	bne	a4,s4,800022fc <balloc+0xce>
    8000232c:	bf49                	j	800022be <balloc+0x90>
    8000232e:	6906                	ld	s2,64(sp)
    80002330:	79e2                	ld	s3,56(sp)
    80002332:	7a42                	ld	s4,48(sp)
    80002334:	7aa2                	ld	s5,40(sp)
    80002336:	7b02                	ld	s6,32(sp)
    80002338:	6be2                	ld	s7,24(sp)
    8000233a:	6c42                	ld	s8,16(sp)
    8000233c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000233e:	00005517          	auipc	a0,0x5
    80002342:	07250513          	addi	a0,a0,114 # 800073b0 <etext+0x3b0>
    80002346:	7b3020ef          	jal	800052f8 <printf>
  return 0;
    8000234a:	4481                	li	s1,0
    8000234c:	b79d                	j	800022b2 <balloc+0x84>

000000008000234e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000234e:	7179                	addi	sp,sp,-48
    80002350:	f406                	sd	ra,40(sp)
    80002352:	f022                	sd	s0,32(sp)
    80002354:	ec26                	sd	s1,24(sp)
    80002356:	e84a                	sd	s2,16(sp)
    80002358:	e44e                	sd	s3,8(sp)
    8000235a:	1800                	addi	s0,sp,48
    8000235c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000235e:	47ad                	li	a5,11
    80002360:	02b7e663          	bltu	a5,a1,8000238c <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002364:	02059793          	slli	a5,a1,0x20
    80002368:	01e7d593          	srli	a1,a5,0x1e
    8000236c:	00b504b3          	add	s1,a0,a1
    80002370:	0504a903          	lw	s2,80(s1)
    80002374:	06091a63          	bnez	s2,800023e8 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002378:	4108                	lw	a0,0(a0)
    8000237a:	eb5ff0ef          	jal	8000222e <balloc>
    8000237e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002382:	06090363          	beqz	s2,800023e8 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80002386:	0524a823          	sw	s2,80(s1)
    8000238a:	a8b9                	j	800023e8 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000238c:	ff45849b          	addiw	s1,a1,-12
    80002390:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002394:	0ff00793          	li	a5,255
    80002398:	06e7ee63          	bltu	a5,a4,80002414 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000239c:	08052903          	lw	s2,128(a0)
    800023a0:	00091d63          	bnez	s2,800023ba <bmap+0x6c>
      addr = balloc(ip->dev);
    800023a4:	4108                	lw	a0,0(a0)
    800023a6:	e89ff0ef          	jal	8000222e <balloc>
    800023aa:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023ae:	02090d63          	beqz	s2,800023e8 <bmap+0x9a>
    800023b2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023b4:	0929a023          	sw	s2,128(s3)
    800023b8:	a011                	j	800023bc <bmap+0x6e>
    800023ba:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023bc:	85ca                	mv	a1,s2
    800023be:	0009a503          	lw	a0,0(s3)
    800023c2:	c09ff0ef          	jal	80001fca <bread>
    800023c6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023c8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023cc:	02049713          	slli	a4,s1,0x20
    800023d0:	01e75593          	srli	a1,a4,0x1e
    800023d4:	00b784b3          	add	s1,a5,a1
    800023d8:	0004a903          	lw	s2,0(s1)
    800023dc:	00090e63          	beqz	s2,800023f8 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800023e0:	8552                	mv	a0,s4
    800023e2:	cf1ff0ef          	jal	800020d2 <brelse>
    return addr;
    800023e6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800023e8:	854a                	mv	a0,s2
    800023ea:	70a2                	ld	ra,40(sp)
    800023ec:	7402                	ld	s0,32(sp)
    800023ee:	64e2                	ld	s1,24(sp)
    800023f0:	6942                	ld	s2,16(sp)
    800023f2:	69a2                	ld	s3,8(sp)
    800023f4:	6145                	addi	sp,sp,48
    800023f6:	8082                	ret
      addr = balloc(ip->dev);
    800023f8:	0009a503          	lw	a0,0(s3)
    800023fc:	e33ff0ef          	jal	8000222e <balloc>
    80002400:	0005091b          	sext.w	s2,a0
      if(addr){
    80002404:	fc090ee3          	beqz	s2,800023e0 <bmap+0x92>
        a[bn] = addr;
    80002408:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000240c:	8552                	mv	a0,s4
    8000240e:	5f7000ef          	jal	80003204 <log_write>
    80002412:	b7f9                	j	800023e0 <bmap+0x92>
    80002414:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002416:	00005517          	auipc	a0,0x5
    8000241a:	fb250513          	addi	a0,a0,-78 # 800073c8 <etext+0x3c8>
    8000241e:	1c0030ef          	jal	800055de <panic>

0000000080002422 <iget>:
{
    80002422:	7179                	addi	sp,sp,-48
    80002424:	f406                	sd	ra,40(sp)
    80002426:	f022                	sd	s0,32(sp)
    80002428:	ec26                	sd	s1,24(sp)
    8000242a:	e84a                	sd	s2,16(sp)
    8000242c:	e44e                	sd	s3,8(sp)
    8000242e:	e052                	sd	s4,0(sp)
    80002430:	1800                	addi	s0,sp,48
    80002432:	89aa                	mv	s3,a0
    80002434:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002436:	00016517          	auipc	a0,0x16
    8000243a:	32250513          	addi	a0,a0,802 # 80018758 <itable>
    8000243e:	45c030ef          	jal	8000589a <acquire>
  empty = 0;
    80002442:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002444:	00016497          	auipc	s1,0x16
    80002448:	32c48493          	addi	s1,s1,812 # 80018770 <itable+0x18>
    8000244c:	00018697          	auipc	a3,0x18
    80002450:	db468693          	addi	a3,a3,-588 # 8001a200 <log>
    80002454:	a039                	j	80002462 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002456:	02090963          	beqz	s2,80002488 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000245a:	08848493          	addi	s1,s1,136
    8000245e:	02d48863          	beq	s1,a3,8000248e <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002462:	449c                	lw	a5,8(s1)
    80002464:	fef059e3          	blez	a5,80002456 <iget+0x34>
    80002468:	4098                	lw	a4,0(s1)
    8000246a:	ff3716e3          	bne	a4,s3,80002456 <iget+0x34>
    8000246e:	40d8                	lw	a4,4(s1)
    80002470:	ff4713e3          	bne	a4,s4,80002456 <iget+0x34>
      ip->ref++;
    80002474:	2785                	addiw	a5,a5,1
    80002476:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002478:	00016517          	auipc	a0,0x16
    8000247c:	2e050513          	addi	a0,a0,736 # 80018758 <itable>
    80002480:	4b2030ef          	jal	80005932 <release>
      return ip;
    80002484:	8926                	mv	s2,s1
    80002486:	a02d                	j	800024b0 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002488:	fbe9                	bnez	a5,8000245a <iget+0x38>
      empty = ip;
    8000248a:	8926                	mv	s2,s1
    8000248c:	b7f9                	j	8000245a <iget+0x38>
  if(empty == 0)
    8000248e:	02090a63          	beqz	s2,800024c2 <iget+0xa0>
  ip->dev = dev;
    80002492:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002496:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000249a:	4785                	li	a5,1
    8000249c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024a0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024a4:	00016517          	auipc	a0,0x16
    800024a8:	2b450513          	addi	a0,a0,692 # 80018758 <itable>
    800024ac:	486030ef          	jal	80005932 <release>
}
    800024b0:	854a                	mv	a0,s2
    800024b2:	70a2                	ld	ra,40(sp)
    800024b4:	7402                	ld	s0,32(sp)
    800024b6:	64e2                	ld	s1,24(sp)
    800024b8:	6942                	ld	s2,16(sp)
    800024ba:	69a2                	ld	s3,8(sp)
    800024bc:	6a02                	ld	s4,0(sp)
    800024be:	6145                	addi	sp,sp,48
    800024c0:	8082                	ret
    panic("iget: no inodes");
    800024c2:	00005517          	auipc	a0,0x5
    800024c6:	f1e50513          	addi	a0,a0,-226 # 800073e0 <etext+0x3e0>
    800024ca:	114030ef          	jal	800055de <panic>

00000000800024ce <iinit>:
{
    800024ce:	7179                	addi	sp,sp,-48
    800024d0:	f406                	sd	ra,40(sp)
    800024d2:	f022                	sd	s0,32(sp)
    800024d4:	ec26                	sd	s1,24(sp)
    800024d6:	e84a                	sd	s2,16(sp)
    800024d8:	e44e                	sd	s3,8(sp)
    800024da:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800024dc:	00005597          	auipc	a1,0x5
    800024e0:	f1458593          	addi	a1,a1,-236 # 800073f0 <etext+0x3f0>
    800024e4:	00016517          	auipc	a0,0x16
    800024e8:	27450513          	addi	a0,a0,628 # 80018758 <itable>
    800024ec:	32e030ef          	jal	8000581a <initlock>
  for(i = 0; i < NINODE; i++) {
    800024f0:	00016497          	auipc	s1,0x16
    800024f4:	29048493          	addi	s1,s1,656 # 80018780 <itable+0x28>
    800024f8:	00018997          	auipc	s3,0x18
    800024fc:	d1898993          	addi	s3,s3,-744 # 8001a210 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002500:	00005917          	auipc	s2,0x5
    80002504:	ef890913          	addi	s2,s2,-264 # 800073f8 <etext+0x3f8>
    80002508:	85ca                	mv	a1,s2
    8000250a:	8526                	mv	a0,s1
    8000250c:	5bb000ef          	jal	800032c6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002510:	08848493          	addi	s1,s1,136
    80002514:	ff349ae3          	bne	s1,s3,80002508 <iinit+0x3a>
}
    80002518:	70a2                	ld	ra,40(sp)
    8000251a:	7402                	ld	s0,32(sp)
    8000251c:	64e2                	ld	s1,24(sp)
    8000251e:	6942                	ld	s2,16(sp)
    80002520:	69a2                	ld	s3,8(sp)
    80002522:	6145                	addi	sp,sp,48
    80002524:	8082                	ret

0000000080002526 <ialloc>:
{
    80002526:	7139                	addi	sp,sp,-64
    80002528:	fc06                	sd	ra,56(sp)
    8000252a:	f822                	sd	s0,48(sp)
    8000252c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000252e:	00016717          	auipc	a4,0x16
    80002532:	21672703          	lw	a4,534(a4) # 80018744 <sb+0xc>
    80002536:	4785                	li	a5,1
    80002538:	06e7f063          	bgeu	a5,a4,80002598 <ialloc+0x72>
    8000253c:	f426                	sd	s1,40(sp)
    8000253e:	f04a                	sd	s2,32(sp)
    80002540:	ec4e                	sd	s3,24(sp)
    80002542:	e852                	sd	s4,16(sp)
    80002544:	e456                	sd	s5,8(sp)
    80002546:	e05a                	sd	s6,0(sp)
    80002548:	8aaa                	mv	s5,a0
    8000254a:	8b2e                	mv	s6,a1
    8000254c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000254e:	00016a17          	auipc	s4,0x16
    80002552:	1eaa0a13          	addi	s4,s4,490 # 80018738 <sb>
    80002556:	00495593          	srli	a1,s2,0x4
    8000255a:	018a2783          	lw	a5,24(s4)
    8000255e:	9dbd                	addw	a1,a1,a5
    80002560:	8556                	mv	a0,s5
    80002562:	a69ff0ef          	jal	80001fca <bread>
    80002566:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002568:	05850993          	addi	s3,a0,88
    8000256c:	00f97793          	andi	a5,s2,15
    80002570:	079a                	slli	a5,a5,0x6
    80002572:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002574:	00099783          	lh	a5,0(s3)
    80002578:	cb9d                	beqz	a5,800025ae <ialloc+0x88>
    brelse(bp);
    8000257a:	b59ff0ef          	jal	800020d2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000257e:	0905                	addi	s2,s2,1
    80002580:	00ca2703          	lw	a4,12(s4)
    80002584:	0009079b          	sext.w	a5,s2
    80002588:	fce7e7e3          	bltu	a5,a4,80002556 <ialloc+0x30>
    8000258c:	74a2                	ld	s1,40(sp)
    8000258e:	7902                	ld	s2,32(sp)
    80002590:	69e2                	ld	s3,24(sp)
    80002592:	6a42                	ld	s4,16(sp)
    80002594:	6aa2                	ld	s5,8(sp)
    80002596:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002598:	00005517          	auipc	a0,0x5
    8000259c:	e6850513          	addi	a0,a0,-408 # 80007400 <etext+0x400>
    800025a0:	559020ef          	jal	800052f8 <printf>
  return 0;
    800025a4:	4501                	li	a0,0
}
    800025a6:	70e2                	ld	ra,56(sp)
    800025a8:	7442                	ld	s0,48(sp)
    800025aa:	6121                	addi	sp,sp,64
    800025ac:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800025ae:	04000613          	li	a2,64
    800025b2:	4581                	li	a1,0
    800025b4:	854e                	mv	a0,s3
    800025b6:	b99fd0ef          	jal	8000014e <memset>
      dip->type = type;
    800025ba:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800025be:	8526                	mv	a0,s1
    800025c0:	445000ef          	jal	80003204 <log_write>
      brelse(bp);
    800025c4:	8526                	mv	a0,s1
    800025c6:	b0dff0ef          	jal	800020d2 <brelse>
      return iget(dev, inum);
    800025ca:	0009059b          	sext.w	a1,s2
    800025ce:	8556                	mv	a0,s5
    800025d0:	e53ff0ef          	jal	80002422 <iget>
    800025d4:	74a2                	ld	s1,40(sp)
    800025d6:	7902                	ld	s2,32(sp)
    800025d8:	69e2                	ld	s3,24(sp)
    800025da:	6a42                	ld	s4,16(sp)
    800025dc:	6aa2                	ld	s5,8(sp)
    800025de:	6b02                	ld	s6,0(sp)
    800025e0:	b7d9                	j	800025a6 <ialloc+0x80>

00000000800025e2 <iupdate>:
{
    800025e2:	1101                	addi	sp,sp,-32
    800025e4:	ec06                	sd	ra,24(sp)
    800025e6:	e822                	sd	s0,16(sp)
    800025e8:	e426                	sd	s1,8(sp)
    800025ea:	e04a                	sd	s2,0(sp)
    800025ec:	1000                	addi	s0,sp,32
    800025ee:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800025f0:	415c                	lw	a5,4(a0)
    800025f2:	0047d79b          	srliw	a5,a5,0x4
    800025f6:	00016597          	auipc	a1,0x16
    800025fa:	15a5a583          	lw	a1,346(a1) # 80018750 <sb+0x18>
    800025fe:	9dbd                	addw	a1,a1,a5
    80002600:	4108                	lw	a0,0(a0)
    80002602:	9c9ff0ef          	jal	80001fca <bread>
    80002606:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002608:	05850793          	addi	a5,a0,88
    8000260c:	40d8                	lw	a4,4(s1)
    8000260e:	8b3d                	andi	a4,a4,15
    80002610:	071a                	slli	a4,a4,0x6
    80002612:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002614:	04449703          	lh	a4,68(s1)
    80002618:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000261c:	04649703          	lh	a4,70(s1)
    80002620:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002624:	04849703          	lh	a4,72(s1)
    80002628:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000262c:	04a49703          	lh	a4,74(s1)
    80002630:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002634:	44f8                	lw	a4,76(s1)
    80002636:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002638:	03400613          	li	a2,52
    8000263c:	05048593          	addi	a1,s1,80
    80002640:	00c78513          	addi	a0,a5,12
    80002644:	b67fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    80002648:	854a                	mv	a0,s2
    8000264a:	3bb000ef          	jal	80003204 <log_write>
  brelse(bp);
    8000264e:	854a                	mv	a0,s2
    80002650:	a83ff0ef          	jal	800020d2 <brelse>
}
    80002654:	60e2                	ld	ra,24(sp)
    80002656:	6442                	ld	s0,16(sp)
    80002658:	64a2                	ld	s1,8(sp)
    8000265a:	6902                	ld	s2,0(sp)
    8000265c:	6105                	addi	sp,sp,32
    8000265e:	8082                	ret

0000000080002660 <idup>:
{
    80002660:	1101                	addi	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	e426                	sd	s1,8(sp)
    80002668:	1000                	addi	s0,sp,32
    8000266a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000266c:	00016517          	auipc	a0,0x16
    80002670:	0ec50513          	addi	a0,a0,236 # 80018758 <itable>
    80002674:	226030ef          	jal	8000589a <acquire>
  ip->ref++;
    80002678:	449c                	lw	a5,8(s1)
    8000267a:	2785                	addiw	a5,a5,1
    8000267c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000267e:	00016517          	auipc	a0,0x16
    80002682:	0da50513          	addi	a0,a0,218 # 80018758 <itable>
    80002686:	2ac030ef          	jal	80005932 <release>
}
    8000268a:	8526                	mv	a0,s1
    8000268c:	60e2                	ld	ra,24(sp)
    8000268e:	6442                	ld	s0,16(sp)
    80002690:	64a2                	ld	s1,8(sp)
    80002692:	6105                	addi	sp,sp,32
    80002694:	8082                	ret

0000000080002696 <ilock>:
{
    80002696:	1101                	addi	sp,sp,-32
    80002698:	ec06                	sd	ra,24(sp)
    8000269a:	e822                	sd	s0,16(sp)
    8000269c:	e426                	sd	s1,8(sp)
    8000269e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026a0:	cd19                	beqz	a0,800026be <ilock+0x28>
    800026a2:	84aa                	mv	s1,a0
    800026a4:	451c                	lw	a5,8(a0)
    800026a6:	00f05c63          	blez	a5,800026be <ilock+0x28>
  acquiresleep(&ip->lock);
    800026aa:	0541                	addi	a0,a0,16
    800026ac:	451000ef          	jal	800032fc <acquiresleep>
  if(ip->valid == 0){
    800026b0:	40bc                	lw	a5,64(s1)
    800026b2:	cf89                	beqz	a5,800026cc <ilock+0x36>
}
    800026b4:	60e2                	ld	ra,24(sp)
    800026b6:	6442                	ld	s0,16(sp)
    800026b8:	64a2                	ld	s1,8(sp)
    800026ba:	6105                	addi	sp,sp,32
    800026bc:	8082                	ret
    800026be:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800026c0:	00005517          	auipc	a0,0x5
    800026c4:	d5850513          	addi	a0,a0,-680 # 80007418 <etext+0x418>
    800026c8:	717020ef          	jal	800055de <panic>
    800026cc:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026ce:	40dc                	lw	a5,4(s1)
    800026d0:	0047d79b          	srliw	a5,a5,0x4
    800026d4:	00016597          	auipc	a1,0x16
    800026d8:	07c5a583          	lw	a1,124(a1) # 80018750 <sb+0x18>
    800026dc:	9dbd                	addw	a1,a1,a5
    800026de:	4088                	lw	a0,0(s1)
    800026e0:	8ebff0ef          	jal	80001fca <bread>
    800026e4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026e6:	05850593          	addi	a1,a0,88
    800026ea:	40dc                	lw	a5,4(s1)
    800026ec:	8bbd                	andi	a5,a5,15
    800026ee:	079a                	slli	a5,a5,0x6
    800026f0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800026f2:	00059783          	lh	a5,0(a1)
    800026f6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800026fa:	00259783          	lh	a5,2(a1)
    800026fe:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002702:	00459783          	lh	a5,4(a1)
    80002706:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000270a:	00659783          	lh	a5,6(a1)
    8000270e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002712:	459c                	lw	a5,8(a1)
    80002714:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002716:	03400613          	li	a2,52
    8000271a:	05b1                	addi	a1,a1,12
    8000271c:	05048513          	addi	a0,s1,80
    80002720:	a8bfd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002724:	854a                	mv	a0,s2
    80002726:	9adff0ef          	jal	800020d2 <brelse>
    ip->valid = 1;
    8000272a:	4785                	li	a5,1
    8000272c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000272e:	04449783          	lh	a5,68(s1)
    80002732:	c399                	beqz	a5,80002738 <ilock+0xa2>
    80002734:	6902                	ld	s2,0(sp)
    80002736:	bfbd                	j	800026b4 <ilock+0x1e>
      panic("ilock: no type");
    80002738:	00005517          	auipc	a0,0x5
    8000273c:	ce850513          	addi	a0,a0,-792 # 80007420 <etext+0x420>
    80002740:	69f020ef          	jal	800055de <panic>

0000000080002744 <iunlock>:
{
    80002744:	1101                	addi	sp,sp,-32
    80002746:	ec06                	sd	ra,24(sp)
    80002748:	e822                	sd	s0,16(sp)
    8000274a:	e426                	sd	s1,8(sp)
    8000274c:	e04a                	sd	s2,0(sp)
    8000274e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002750:	c505                	beqz	a0,80002778 <iunlock+0x34>
    80002752:	84aa                	mv	s1,a0
    80002754:	01050913          	addi	s2,a0,16
    80002758:	854a                	mv	a0,s2
    8000275a:	421000ef          	jal	8000337a <holdingsleep>
    8000275e:	cd09                	beqz	a0,80002778 <iunlock+0x34>
    80002760:	449c                	lw	a5,8(s1)
    80002762:	00f05b63          	blez	a5,80002778 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002766:	854a                	mv	a0,s2
    80002768:	3db000ef          	jal	80003342 <releasesleep>
}
    8000276c:	60e2                	ld	ra,24(sp)
    8000276e:	6442                	ld	s0,16(sp)
    80002770:	64a2                	ld	s1,8(sp)
    80002772:	6902                	ld	s2,0(sp)
    80002774:	6105                	addi	sp,sp,32
    80002776:	8082                	ret
    panic("iunlock");
    80002778:	00005517          	auipc	a0,0x5
    8000277c:	cb850513          	addi	a0,a0,-840 # 80007430 <etext+0x430>
    80002780:	65f020ef          	jal	800055de <panic>

0000000080002784 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002784:	7179                	addi	sp,sp,-48
    80002786:	f406                	sd	ra,40(sp)
    80002788:	f022                	sd	s0,32(sp)
    8000278a:	ec26                	sd	s1,24(sp)
    8000278c:	e84a                	sd	s2,16(sp)
    8000278e:	e44e                	sd	s3,8(sp)
    80002790:	1800                	addi	s0,sp,48
    80002792:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002794:	05050493          	addi	s1,a0,80
    80002798:	08050913          	addi	s2,a0,128
    8000279c:	a021                	j	800027a4 <itrunc+0x20>
    8000279e:	0491                	addi	s1,s1,4
    800027a0:	01248b63          	beq	s1,s2,800027b6 <itrunc+0x32>
    if(ip->addrs[i]){
    800027a4:	408c                	lw	a1,0(s1)
    800027a6:	dde5                	beqz	a1,8000279e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800027a8:	0009a503          	lw	a0,0(s3)
    800027ac:	a17ff0ef          	jal	800021c2 <bfree>
      ip->addrs[i] = 0;
    800027b0:	0004a023          	sw	zero,0(s1)
    800027b4:	b7ed                	j	8000279e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800027b6:	0809a583          	lw	a1,128(s3)
    800027ba:	ed89                	bnez	a1,800027d4 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800027bc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800027c0:	854e                	mv	a0,s3
    800027c2:	e21ff0ef          	jal	800025e2 <iupdate>
}
    800027c6:	70a2                	ld	ra,40(sp)
    800027c8:	7402                	ld	s0,32(sp)
    800027ca:	64e2                	ld	s1,24(sp)
    800027cc:	6942                	ld	s2,16(sp)
    800027ce:	69a2                	ld	s3,8(sp)
    800027d0:	6145                	addi	sp,sp,48
    800027d2:	8082                	ret
    800027d4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800027d6:	0009a503          	lw	a0,0(s3)
    800027da:	ff0ff0ef          	jal	80001fca <bread>
    800027de:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800027e0:	05850493          	addi	s1,a0,88
    800027e4:	45850913          	addi	s2,a0,1112
    800027e8:	a021                	j	800027f0 <itrunc+0x6c>
    800027ea:	0491                	addi	s1,s1,4
    800027ec:	01248963          	beq	s1,s2,800027fe <itrunc+0x7a>
      if(a[j])
    800027f0:	408c                	lw	a1,0(s1)
    800027f2:	dde5                	beqz	a1,800027ea <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800027f4:	0009a503          	lw	a0,0(s3)
    800027f8:	9cbff0ef          	jal	800021c2 <bfree>
    800027fc:	b7fd                	j	800027ea <itrunc+0x66>
    brelse(bp);
    800027fe:	8552                	mv	a0,s4
    80002800:	8d3ff0ef          	jal	800020d2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002804:	0809a583          	lw	a1,128(s3)
    80002808:	0009a503          	lw	a0,0(s3)
    8000280c:	9b7ff0ef          	jal	800021c2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002810:	0809a023          	sw	zero,128(s3)
    80002814:	6a02                	ld	s4,0(sp)
    80002816:	b75d                	j	800027bc <itrunc+0x38>

0000000080002818 <iput>:
{
    80002818:	1101                	addi	sp,sp,-32
    8000281a:	ec06                	sd	ra,24(sp)
    8000281c:	e822                	sd	s0,16(sp)
    8000281e:	e426                	sd	s1,8(sp)
    80002820:	1000                	addi	s0,sp,32
    80002822:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002824:	00016517          	auipc	a0,0x16
    80002828:	f3450513          	addi	a0,a0,-204 # 80018758 <itable>
    8000282c:	06e030ef          	jal	8000589a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002830:	4498                	lw	a4,8(s1)
    80002832:	4785                	li	a5,1
    80002834:	02f70063          	beq	a4,a5,80002854 <iput+0x3c>
  ip->ref--;
    80002838:	449c                	lw	a5,8(s1)
    8000283a:	37fd                	addiw	a5,a5,-1
    8000283c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000283e:	00016517          	auipc	a0,0x16
    80002842:	f1a50513          	addi	a0,a0,-230 # 80018758 <itable>
    80002846:	0ec030ef          	jal	80005932 <release>
}
    8000284a:	60e2                	ld	ra,24(sp)
    8000284c:	6442                	ld	s0,16(sp)
    8000284e:	64a2                	ld	s1,8(sp)
    80002850:	6105                	addi	sp,sp,32
    80002852:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002854:	40bc                	lw	a5,64(s1)
    80002856:	d3ed                	beqz	a5,80002838 <iput+0x20>
    80002858:	04a49783          	lh	a5,74(s1)
    8000285c:	fff1                	bnez	a5,80002838 <iput+0x20>
    8000285e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002860:	01048913          	addi	s2,s1,16
    80002864:	854a                	mv	a0,s2
    80002866:	297000ef          	jal	800032fc <acquiresleep>
    release(&itable.lock);
    8000286a:	00016517          	auipc	a0,0x16
    8000286e:	eee50513          	addi	a0,a0,-274 # 80018758 <itable>
    80002872:	0c0030ef          	jal	80005932 <release>
    itrunc(ip);
    80002876:	8526                	mv	a0,s1
    80002878:	f0dff0ef          	jal	80002784 <itrunc>
    ip->type = 0;
    8000287c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002880:	8526                	mv	a0,s1
    80002882:	d61ff0ef          	jal	800025e2 <iupdate>
    ip->valid = 0;
    80002886:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000288a:	854a                	mv	a0,s2
    8000288c:	2b7000ef          	jal	80003342 <releasesleep>
    acquire(&itable.lock);
    80002890:	00016517          	auipc	a0,0x16
    80002894:	ec850513          	addi	a0,a0,-312 # 80018758 <itable>
    80002898:	002030ef          	jal	8000589a <acquire>
    8000289c:	6902                	ld	s2,0(sp)
    8000289e:	bf69                	j	80002838 <iput+0x20>

00000000800028a0 <iunlockput>:
{
    800028a0:	1101                	addi	sp,sp,-32
    800028a2:	ec06                	sd	ra,24(sp)
    800028a4:	e822                	sd	s0,16(sp)
    800028a6:	e426                	sd	s1,8(sp)
    800028a8:	1000                	addi	s0,sp,32
    800028aa:	84aa                	mv	s1,a0
  iunlock(ip);
    800028ac:	e99ff0ef          	jal	80002744 <iunlock>
  iput(ip);
    800028b0:	8526                	mv	a0,s1
    800028b2:	f67ff0ef          	jal	80002818 <iput>
}
    800028b6:	60e2                	ld	ra,24(sp)
    800028b8:	6442                	ld	s0,16(sp)
    800028ba:	64a2                	ld	s1,8(sp)
    800028bc:	6105                	addi	sp,sp,32
    800028be:	8082                	ret

00000000800028c0 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800028c0:	00016717          	auipc	a4,0x16
    800028c4:	e8472703          	lw	a4,-380(a4) # 80018744 <sb+0xc>
    800028c8:	4785                	li	a5,1
    800028ca:	0ae7ff63          	bgeu	a5,a4,80002988 <ireclaim+0xc8>
{
    800028ce:	7139                	addi	sp,sp,-64
    800028d0:	fc06                	sd	ra,56(sp)
    800028d2:	f822                	sd	s0,48(sp)
    800028d4:	f426                	sd	s1,40(sp)
    800028d6:	f04a                	sd	s2,32(sp)
    800028d8:	ec4e                	sd	s3,24(sp)
    800028da:	e852                	sd	s4,16(sp)
    800028dc:	e456                	sd	s5,8(sp)
    800028de:	e05a                	sd	s6,0(sp)
    800028e0:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800028e2:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800028e4:	00050a1b          	sext.w	s4,a0
    800028e8:	00016a97          	auipc	s5,0x16
    800028ec:	e50a8a93          	addi	s5,s5,-432 # 80018738 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800028f0:	00005b17          	auipc	s6,0x5
    800028f4:	b48b0b13          	addi	s6,s6,-1208 # 80007438 <etext+0x438>
    800028f8:	a099                	j	8000293e <ireclaim+0x7e>
    800028fa:	85ce                	mv	a1,s3
    800028fc:	855a                	mv	a0,s6
    800028fe:	1fb020ef          	jal	800052f8 <printf>
      ip = iget(dev, inum);
    80002902:	85ce                	mv	a1,s3
    80002904:	8552                	mv	a0,s4
    80002906:	b1dff0ef          	jal	80002422 <iget>
    8000290a:	89aa                	mv	s3,a0
    brelse(bp);
    8000290c:	854a                	mv	a0,s2
    8000290e:	fc4ff0ef          	jal	800020d2 <brelse>
    if (ip) {
    80002912:	00098f63          	beqz	s3,80002930 <ireclaim+0x70>
      begin_op();
    80002916:	76a000ef          	jal	80003080 <begin_op>
      ilock(ip);
    8000291a:	854e                	mv	a0,s3
    8000291c:	d7bff0ef          	jal	80002696 <ilock>
      iunlock(ip);
    80002920:	854e                	mv	a0,s3
    80002922:	e23ff0ef          	jal	80002744 <iunlock>
      iput(ip);
    80002926:	854e                	mv	a0,s3
    80002928:	ef1ff0ef          	jal	80002818 <iput>
      end_op();
    8000292c:	7be000ef          	jal	800030ea <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002930:	0485                	addi	s1,s1,1
    80002932:	00caa703          	lw	a4,12(s5)
    80002936:	0004879b          	sext.w	a5,s1
    8000293a:	02e7fd63          	bgeu	a5,a4,80002974 <ireclaim+0xb4>
    8000293e:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002942:	0044d593          	srli	a1,s1,0x4
    80002946:	018aa783          	lw	a5,24(s5)
    8000294a:	9dbd                	addw	a1,a1,a5
    8000294c:	8552                	mv	a0,s4
    8000294e:	e7cff0ef          	jal	80001fca <bread>
    80002952:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002954:	05850793          	addi	a5,a0,88
    80002958:	00f9f713          	andi	a4,s3,15
    8000295c:	071a                	slli	a4,a4,0x6
    8000295e:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002960:	00079703          	lh	a4,0(a5)
    80002964:	c701                	beqz	a4,8000296c <ireclaim+0xac>
    80002966:	00679783          	lh	a5,6(a5)
    8000296a:	dbc1                	beqz	a5,800028fa <ireclaim+0x3a>
    brelse(bp);
    8000296c:	854a                	mv	a0,s2
    8000296e:	f64ff0ef          	jal	800020d2 <brelse>
    if (ip) {
    80002972:	bf7d                	j	80002930 <ireclaim+0x70>
}
    80002974:	70e2                	ld	ra,56(sp)
    80002976:	7442                	ld	s0,48(sp)
    80002978:	74a2                	ld	s1,40(sp)
    8000297a:	7902                	ld	s2,32(sp)
    8000297c:	69e2                	ld	s3,24(sp)
    8000297e:	6a42                	ld	s4,16(sp)
    80002980:	6aa2                	ld	s5,8(sp)
    80002982:	6b02                	ld	s6,0(sp)
    80002984:	6121                	addi	sp,sp,64
    80002986:	8082                	ret
    80002988:	8082                	ret

000000008000298a <fsinit>:
fsinit(int dev) {
    8000298a:	7179                	addi	sp,sp,-48
    8000298c:	f406                	sd	ra,40(sp)
    8000298e:	f022                	sd	s0,32(sp)
    80002990:	ec26                	sd	s1,24(sp)
    80002992:	e84a                	sd	s2,16(sp)
    80002994:	e44e                	sd	s3,8(sp)
    80002996:	1800                	addi	s0,sp,48
    80002998:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    8000299a:	4585                	li	a1,1
    8000299c:	e2eff0ef          	jal	80001fca <bread>
    800029a0:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029a2:	00016997          	auipc	s3,0x16
    800029a6:	d9698993          	addi	s3,s3,-618 # 80018738 <sb>
    800029aa:	02000613          	li	a2,32
    800029ae:	05850593          	addi	a1,a0,88
    800029b2:	854e                	mv	a0,s3
    800029b4:	ff6fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    800029b8:	854a                	mv	a0,s2
    800029ba:	f18ff0ef          	jal	800020d2 <brelse>
  if(sb.magic != FSMAGIC)
    800029be:	0009a703          	lw	a4,0(s3)
    800029c2:	102037b7          	lui	a5,0x10203
    800029c6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029ca:	02f71363          	bne	a4,a5,800029f0 <fsinit+0x66>
  initlog(dev, &sb);
    800029ce:	00016597          	auipc	a1,0x16
    800029d2:	d6a58593          	addi	a1,a1,-662 # 80018738 <sb>
    800029d6:	8526                	mv	a0,s1
    800029d8:	62a000ef          	jal	80003002 <initlog>
  ireclaim(dev);
    800029dc:	8526                	mv	a0,s1
    800029de:	ee3ff0ef          	jal	800028c0 <ireclaim>
}
    800029e2:	70a2                	ld	ra,40(sp)
    800029e4:	7402                	ld	s0,32(sp)
    800029e6:	64e2                	ld	s1,24(sp)
    800029e8:	6942                	ld	s2,16(sp)
    800029ea:	69a2                	ld	s3,8(sp)
    800029ec:	6145                	addi	sp,sp,48
    800029ee:	8082                	ret
    panic("invalid file system");
    800029f0:	00005517          	auipc	a0,0x5
    800029f4:	a6850513          	addi	a0,a0,-1432 # 80007458 <etext+0x458>
    800029f8:	3e7020ef          	jal	800055de <panic>

00000000800029fc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800029fc:	1141                	addi	sp,sp,-16
    800029fe:	e422                	sd	s0,8(sp)
    80002a00:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a02:	411c                	lw	a5,0(a0)
    80002a04:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a06:	415c                	lw	a5,4(a0)
    80002a08:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a0a:	04451783          	lh	a5,68(a0)
    80002a0e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a12:	04a51783          	lh	a5,74(a0)
    80002a16:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a1a:	04c56783          	lwu	a5,76(a0)
    80002a1e:	e99c                	sd	a5,16(a1)
}
    80002a20:	6422                	ld	s0,8(sp)
    80002a22:	0141                	addi	sp,sp,16
    80002a24:	8082                	ret

0000000080002a26 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a26:	457c                	lw	a5,76(a0)
    80002a28:	0ed7eb63          	bltu	a5,a3,80002b1e <readi+0xf8>
{
    80002a2c:	7159                	addi	sp,sp,-112
    80002a2e:	f486                	sd	ra,104(sp)
    80002a30:	f0a2                	sd	s0,96(sp)
    80002a32:	eca6                	sd	s1,88(sp)
    80002a34:	e0d2                	sd	s4,64(sp)
    80002a36:	fc56                	sd	s5,56(sp)
    80002a38:	f85a                	sd	s6,48(sp)
    80002a3a:	f45e                	sd	s7,40(sp)
    80002a3c:	1880                	addi	s0,sp,112
    80002a3e:	8b2a                	mv	s6,a0
    80002a40:	8bae                	mv	s7,a1
    80002a42:	8a32                	mv	s4,a2
    80002a44:	84b6                	mv	s1,a3
    80002a46:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a48:	9f35                	addw	a4,a4,a3
    return 0;
    80002a4a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a4c:	0cd76063          	bltu	a4,a3,80002b0c <readi+0xe6>
    80002a50:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a52:	00e7f463          	bgeu	a5,a4,80002a5a <readi+0x34>
    n = ip->size - off;
    80002a56:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a5a:	080a8f63          	beqz	s5,80002af8 <readi+0xd2>
    80002a5e:	e8ca                	sd	s2,80(sp)
    80002a60:	f062                	sd	s8,32(sp)
    80002a62:	ec66                	sd	s9,24(sp)
    80002a64:	e86a                	sd	s10,16(sp)
    80002a66:	e46e                	sd	s11,8(sp)
    80002a68:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a6a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a6e:	5c7d                	li	s8,-1
    80002a70:	a80d                	j	80002aa2 <readi+0x7c>
    80002a72:	020d1d93          	slli	s11,s10,0x20
    80002a76:	020ddd93          	srli	s11,s11,0x20
    80002a7a:	05890613          	addi	a2,s2,88
    80002a7e:	86ee                	mv	a3,s11
    80002a80:	963a                	add	a2,a2,a4
    80002a82:	85d2                	mv	a1,s4
    80002a84:	855e                	mv	a0,s7
    80002a86:	c49fe0ef          	jal	800016ce <either_copyout>
    80002a8a:	05850763          	beq	a0,s8,80002ad8 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a8e:	854a                	mv	a0,s2
    80002a90:	e42ff0ef          	jal	800020d2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a94:	013d09bb          	addw	s3,s10,s3
    80002a98:	009d04bb          	addw	s1,s10,s1
    80002a9c:	9a6e                	add	s4,s4,s11
    80002a9e:	0559f763          	bgeu	s3,s5,80002aec <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002aa2:	00a4d59b          	srliw	a1,s1,0xa
    80002aa6:	855a                	mv	a0,s6
    80002aa8:	8a7ff0ef          	jal	8000234e <bmap>
    80002aac:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ab0:	c5b1                	beqz	a1,80002afc <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002ab2:	000b2503          	lw	a0,0(s6)
    80002ab6:	d14ff0ef          	jal	80001fca <bread>
    80002aba:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002abc:	3ff4f713          	andi	a4,s1,1023
    80002ac0:	40ec87bb          	subw	a5,s9,a4
    80002ac4:	413a86bb          	subw	a3,s5,s3
    80002ac8:	8d3e                	mv	s10,a5
    80002aca:	2781                	sext.w	a5,a5
    80002acc:	0006861b          	sext.w	a2,a3
    80002ad0:	faf671e3          	bgeu	a2,a5,80002a72 <readi+0x4c>
    80002ad4:	8d36                	mv	s10,a3
    80002ad6:	bf71                	j	80002a72 <readi+0x4c>
      brelse(bp);
    80002ad8:	854a                	mv	a0,s2
    80002ada:	df8ff0ef          	jal	800020d2 <brelse>
      tot = -1;
    80002ade:	59fd                	li	s3,-1
      break;
    80002ae0:	6946                	ld	s2,80(sp)
    80002ae2:	7c02                	ld	s8,32(sp)
    80002ae4:	6ce2                	ld	s9,24(sp)
    80002ae6:	6d42                	ld	s10,16(sp)
    80002ae8:	6da2                	ld	s11,8(sp)
    80002aea:	a831                	j	80002b06 <readi+0xe0>
    80002aec:	6946                	ld	s2,80(sp)
    80002aee:	7c02                	ld	s8,32(sp)
    80002af0:	6ce2                	ld	s9,24(sp)
    80002af2:	6d42                	ld	s10,16(sp)
    80002af4:	6da2                	ld	s11,8(sp)
    80002af6:	a801                	j	80002b06 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002af8:	89d6                	mv	s3,s5
    80002afa:	a031                	j	80002b06 <readi+0xe0>
    80002afc:	6946                	ld	s2,80(sp)
    80002afe:	7c02                	ld	s8,32(sp)
    80002b00:	6ce2                	ld	s9,24(sp)
    80002b02:	6d42                	ld	s10,16(sp)
    80002b04:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b06:	0009851b          	sext.w	a0,s3
    80002b0a:	69a6                	ld	s3,72(sp)
}
    80002b0c:	70a6                	ld	ra,104(sp)
    80002b0e:	7406                	ld	s0,96(sp)
    80002b10:	64e6                	ld	s1,88(sp)
    80002b12:	6a06                	ld	s4,64(sp)
    80002b14:	7ae2                	ld	s5,56(sp)
    80002b16:	7b42                	ld	s6,48(sp)
    80002b18:	7ba2                	ld	s7,40(sp)
    80002b1a:	6165                	addi	sp,sp,112
    80002b1c:	8082                	ret
    return 0;
    80002b1e:	4501                	li	a0,0
}
    80002b20:	8082                	ret

0000000080002b22 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b22:	457c                	lw	a5,76(a0)
    80002b24:	10d7e063          	bltu	a5,a3,80002c24 <writei+0x102>
{
    80002b28:	7159                	addi	sp,sp,-112
    80002b2a:	f486                	sd	ra,104(sp)
    80002b2c:	f0a2                	sd	s0,96(sp)
    80002b2e:	e8ca                	sd	s2,80(sp)
    80002b30:	e0d2                	sd	s4,64(sp)
    80002b32:	fc56                	sd	s5,56(sp)
    80002b34:	f85a                	sd	s6,48(sp)
    80002b36:	f45e                	sd	s7,40(sp)
    80002b38:	1880                	addi	s0,sp,112
    80002b3a:	8aaa                	mv	s5,a0
    80002b3c:	8bae                	mv	s7,a1
    80002b3e:	8a32                	mv	s4,a2
    80002b40:	8936                	mv	s2,a3
    80002b42:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b44:	00e687bb          	addw	a5,a3,a4
    80002b48:	0ed7e063          	bltu	a5,a3,80002c28 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b4c:	00043737          	lui	a4,0x43
    80002b50:	0cf76e63          	bltu	a4,a5,80002c2c <writei+0x10a>
    80002b54:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b56:	0a0b0f63          	beqz	s6,80002c14 <writei+0xf2>
    80002b5a:	eca6                	sd	s1,88(sp)
    80002b5c:	f062                	sd	s8,32(sp)
    80002b5e:	ec66                	sd	s9,24(sp)
    80002b60:	e86a                	sd	s10,16(sp)
    80002b62:	e46e                	sd	s11,8(sp)
    80002b64:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b66:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b6a:	5c7d                	li	s8,-1
    80002b6c:	a825                	j	80002ba4 <writei+0x82>
    80002b6e:	020d1d93          	slli	s11,s10,0x20
    80002b72:	020ddd93          	srli	s11,s11,0x20
    80002b76:	05848513          	addi	a0,s1,88
    80002b7a:	86ee                	mv	a3,s11
    80002b7c:	8652                	mv	a2,s4
    80002b7e:	85de                	mv	a1,s7
    80002b80:	953a                	add	a0,a0,a4
    80002b82:	b97fe0ef          	jal	80001718 <either_copyin>
    80002b86:	05850a63          	beq	a0,s8,80002bda <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b8a:	8526                	mv	a0,s1
    80002b8c:	678000ef          	jal	80003204 <log_write>
    brelse(bp);
    80002b90:	8526                	mv	a0,s1
    80002b92:	d40ff0ef          	jal	800020d2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b96:	013d09bb          	addw	s3,s10,s3
    80002b9a:	012d093b          	addw	s2,s10,s2
    80002b9e:	9a6e                	add	s4,s4,s11
    80002ba0:	0569f063          	bgeu	s3,s6,80002be0 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002ba4:	00a9559b          	srliw	a1,s2,0xa
    80002ba8:	8556                	mv	a0,s5
    80002baa:	fa4ff0ef          	jal	8000234e <bmap>
    80002bae:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002bb2:	c59d                	beqz	a1,80002be0 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002bb4:	000aa503          	lw	a0,0(s5)
    80002bb8:	c12ff0ef          	jal	80001fca <bread>
    80002bbc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bbe:	3ff97713          	andi	a4,s2,1023
    80002bc2:	40ec87bb          	subw	a5,s9,a4
    80002bc6:	413b06bb          	subw	a3,s6,s3
    80002bca:	8d3e                	mv	s10,a5
    80002bcc:	2781                	sext.w	a5,a5
    80002bce:	0006861b          	sext.w	a2,a3
    80002bd2:	f8f67ee3          	bgeu	a2,a5,80002b6e <writei+0x4c>
    80002bd6:	8d36                	mv	s10,a3
    80002bd8:	bf59                	j	80002b6e <writei+0x4c>
      brelse(bp);
    80002bda:	8526                	mv	a0,s1
    80002bdc:	cf6ff0ef          	jal	800020d2 <brelse>
  }

  if(off > ip->size)
    80002be0:	04caa783          	lw	a5,76(s5)
    80002be4:	0327fa63          	bgeu	a5,s2,80002c18 <writei+0xf6>
    ip->size = off;
    80002be8:	052aa623          	sw	s2,76(s5)
    80002bec:	64e6                	ld	s1,88(sp)
    80002bee:	7c02                	ld	s8,32(sp)
    80002bf0:	6ce2                	ld	s9,24(sp)
    80002bf2:	6d42                	ld	s10,16(sp)
    80002bf4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002bf6:	8556                	mv	a0,s5
    80002bf8:	9ebff0ef          	jal	800025e2 <iupdate>

  return tot;
    80002bfc:	0009851b          	sext.w	a0,s3
    80002c00:	69a6                	ld	s3,72(sp)
}
    80002c02:	70a6                	ld	ra,104(sp)
    80002c04:	7406                	ld	s0,96(sp)
    80002c06:	6946                	ld	s2,80(sp)
    80002c08:	6a06                	ld	s4,64(sp)
    80002c0a:	7ae2                	ld	s5,56(sp)
    80002c0c:	7b42                	ld	s6,48(sp)
    80002c0e:	7ba2                	ld	s7,40(sp)
    80002c10:	6165                	addi	sp,sp,112
    80002c12:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c14:	89da                	mv	s3,s6
    80002c16:	b7c5                	j	80002bf6 <writei+0xd4>
    80002c18:	64e6                	ld	s1,88(sp)
    80002c1a:	7c02                	ld	s8,32(sp)
    80002c1c:	6ce2                	ld	s9,24(sp)
    80002c1e:	6d42                	ld	s10,16(sp)
    80002c20:	6da2                	ld	s11,8(sp)
    80002c22:	bfd1                	j	80002bf6 <writei+0xd4>
    return -1;
    80002c24:	557d                	li	a0,-1
}
    80002c26:	8082                	ret
    return -1;
    80002c28:	557d                	li	a0,-1
    80002c2a:	bfe1                	j	80002c02 <writei+0xe0>
    return -1;
    80002c2c:	557d                	li	a0,-1
    80002c2e:	bfd1                	j	80002c02 <writei+0xe0>

0000000080002c30 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c30:	1141                	addi	sp,sp,-16
    80002c32:	e406                	sd	ra,8(sp)
    80002c34:	e022                	sd	s0,0(sp)
    80002c36:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c38:	4639                	li	a2,14
    80002c3a:	de0fd0ef          	jal	8000021a <strncmp>
}
    80002c3e:	60a2                	ld	ra,8(sp)
    80002c40:	6402                	ld	s0,0(sp)
    80002c42:	0141                	addi	sp,sp,16
    80002c44:	8082                	ret

0000000080002c46 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c46:	7139                	addi	sp,sp,-64
    80002c48:	fc06                	sd	ra,56(sp)
    80002c4a:	f822                	sd	s0,48(sp)
    80002c4c:	f426                	sd	s1,40(sp)
    80002c4e:	f04a                	sd	s2,32(sp)
    80002c50:	ec4e                	sd	s3,24(sp)
    80002c52:	e852                	sd	s4,16(sp)
    80002c54:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c56:	04451703          	lh	a4,68(a0)
    80002c5a:	4785                	li	a5,1
    80002c5c:	00f71a63          	bne	a4,a5,80002c70 <dirlookup+0x2a>
    80002c60:	892a                	mv	s2,a0
    80002c62:	89ae                	mv	s3,a1
    80002c64:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c66:	457c                	lw	a5,76(a0)
    80002c68:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c6a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c6c:	e39d                	bnez	a5,80002c92 <dirlookup+0x4c>
    80002c6e:	a095                	j	80002cd2 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c70:	00005517          	auipc	a0,0x5
    80002c74:	80050513          	addi	a0,a0,-2048 # 80007470 <etext+0x470>
    80002c78:	167020ef          	jal	800055de <panic>
      panic("dirlookup read");
    80002c7c:	00005517          	auipc	a0,0x5
    80002c80:	80c50513          	addi	a0,a0,-2036 # 80007488 <etext+0x488>
    80002c84:	15b020ef          	jal	800055de <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c88:	24c1                	addiw	s1,s1,16
    80002c8a:	04c92783          	lw	a5,76(s2)
    80002c8e:	04f4f163          	bgeu	s1,a5,80002cd0 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c92:	4741                	li	a4,16
    80002c94:	86a6                	mv	a3,s1
    80002c96:	fc040613          	addi	a2,s0,-64
    80002c9a:	4581                	li	a1,0
    80002c9c:	854a                	mv	a0,s2
    80002c9e:	d89ff0ef          	jal	80002a26 <readi>
    80002ca2:	47c1                	li	a5,16
    80002ca4:	fcf51ce3          	bne	a0,a5,80002c7c <dirlookup+0x36>
    if(de.inum == 0)
    80002ca8:	fc045783          	lhu	a5,-64(s0)
    80002cac:	dff1                	beqz	a5,80002c88 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002cae:	fc240593          	addi	a1,s0,-62
    80002cb2:	854e                	mv	a0,s3
    80002cb4:	f7dff0ef          	jal	80002c30 <namecmp>
    80002cb8:	f961                	bnez	a0,80002c88 <dirlookup+0x42>
      if(poff)
    80002cba:	000a0463          	beqz	s4,80002cc2 <dirlookup+0x7c>
        *poff = off;
    80002cbe:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002cc2:	fc045583          	lhu	a1,-64(s0)
    80002cc6:	00092503          	lw	a0,0(s2)
    80002cca:	f58ff0ef          	jal	80002422 <iget>
    80002cce:	a011                	j	80002cd2 <dirlookup+0x8c>
  return 0;
    80002cd0:	4501                	li	a0,0
}
    80002cd2:	70e2                	ld	ra,56(sp)
    80002cd4:	7442                	ld	s0,48(sp)
    80002cd6:	74a2                	ld	s1,40(sp)
    80002cd8:	7902                	ld	s2,32(sp)
    80002cda:	69e2                	ld	s3,24(sp)
    80002cdc:	6a42                	ld	s4,16(sp)
    80002cde:	6121                	addi	sp,sp,64
    80002ce0:	8082                	ret

0000000080002ce2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002ce2:	711d                	addi	sp,sp,-96
    80002ce4:	ec86                	sd	ra,88(sp)
    80002ce6:	e8a2                	sd	s0,80(sp)
    80002ce8:	e4a6                	sd	s1,72(sp)
    80002cea:	e0ca                	sd	s2,64(sp)
    80002cec:	fc4e                	sd	s3,56(sp)
    80002cee:	f852                	sd	s4,48(sp)
    80002cf0:	f456                	sd	s5,40(sp)
    80002cf2:	f05a                	sd	s6,32(sp)
    80002cf4:	ec5e                	sd	s7,24(sp)
    80002cf6:	e862                	sd	s8,16(sp)
    80002cf8:	e466                	sd	s9,8(sp)
    80002cfa:	1080                	addi	s0,sp,96
    80002cfc:	84aa                	mv	s1,a0
    80002cfe:	8b2e                	mv	s6,a1
    80002d00:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d02:	00054703          	lbu	a4,0(a0)
    80002d06:	02f00793          	li	a5,47
    80002d0a:	00f70e63          	beq	a4,a5,80002d26 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d0e:	86cfe0ef          	jal	80000d7a <myproc>
    80002d12:	15053503          	ld	a0,336(a0)
    80002d16:	94bff0ef          	jal	80002660 <idup>
    80002d1a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d1c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d20:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d22:	4b85                	li	s7,1
    80002d24:	a871                	j	80002dc0 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002d26:	4585                	li	a1,1
    80002d28:	4505                	li	a0,1
    80002d2a:	ef8ff0ef          	jal	80002422 <iget>
    80002d2e:	8a2a                	mv	s4,a0
    80002d30:	b7f5                	j	80002d1c <namex+0x3a>
      iunlockput(ip);
    80002d32:	8552                	mv	a0,s4
    80002d34:	b6dff0ef          	jal	800028a0 <iunlockput>
      return 0;
    80002d38:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d3a:	8552                	mv	a0,s4
    80002d3c:	60e6                	ld	ra,88(sp)
    80002d3e:	6446                	ld	s0,80(sp)
    80002d40:	64a6                	ld	s1,72(sp)
    80002d42:	6906                	ld	s2,64(sp)
    80002d44:	79e2                	ld	s3,56(sp)
    80002d46:	7a42                	ld	s4,48(sp)
    80002d48:	7aa2                	ld	s5,40(sp)
    80002d4a:	7b02                	ld	s6,32(sp)
    80002d4c:	6be2                	ld	s7,24(sp)
    80002d4e:	6c42                	ld	s8,16(sp)
    80002d50:	6ca2                	ld	s9,8(sp)
    80002d52:	6125                	addi	sp,sp,96
    80002d54:	8082                	ret
      iunlock(ip);
    80002d56:	8552                	mv	a0,s4
    80002d58:	9edff0ef          	jal	80002744 <iunlock>
      return ip;
    80002d5c:	bff9                	j	80002d3a <namex+0x58>
      iunlockput(ip);
    80002d5e:	8552                	mv	a0,s4
    80002d60:	b41ff0ef          	jal	800028a0 <iunlockput>
      return 0;
    80002d64:	8a4e                	mv	s4,s3
    80002d66:	bfd1                	j	80002d3a <namex+0x58>
  len = path - s;
    80002d68:	40998633          	sub	a2,s3,s1
    80002d6c:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d70:	099c5063          	bge	s8,s9,80002df0 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d74:	4639                	li	a2,14
    80002d76:	85a6                	mv	a1,s1
    80002d78:	8556                	mv	a0,s5
    80002d7a:	c30fd0ef          	jal	800001aa <memmove>
    80002d7e:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d80:	0004c783          	lbu	a5,0(s1)
    80002d84:	01279763          	bne	a5,s2,80002d92 <namex+0xb0>
    path++;
    80002d88:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d8a:	0004c783          	lbu	a5,0(s1)
    80002d8e:	ff278de3          	beq	a5,s2,80002d88 <namex+0xa6>
    ilock(ip);
    80002d92:	8552                	mv	a0,s4
    80002d94:	903ff0ef          	jal	80002696 <ilock>
    if(ip->type != T_DIR){
    80002d98:	044a1783          	lh	a5,68(s4)
    80002d9c:	f9779be3          	bne	a5,s7,80002d32 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002da0:	000b0563          	beqz	s6,80002daa <namex+0xc8>
    80002da4:	0004c783          	lbu	a5,0(s1)
    80002da8:	d7dd                	beqz	a5,80002d56 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002daa:	4601                	li	a2,0
    80002dac:	85d6                	mv	a1,s5
    80002dae:	8552                	mv	a0,s4
    80002db0:	e97ff0ef          	jal	80002c46 <dirlookup>
    80002db4:	89aa                	mv	s3,a0
    80002db6:	d545                	beqz	a0,80002d5e <namex+0x7c>
    iunlockput(ip);
    80002db8:	8552                	mv	a0,s4
    80002dba:	ae7ff0ef          	jal	800028a0 <iunlockput>
    ip = next;
    80002dbe:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002dc0:	0004c783          	lbu	a5,0(s1)
    80002dc4:	01279763          	bne	a5,s2,80002dd2 <namex+0xf0>
    path++;
    80002dc8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dca:	0004c783          	lbu	a5,0(s1)
    80002dce:	ff278de3          	beq	a5,s2,80002dc8 <namex+0xe6>
  if(*path == 0)
    80002dd2:	cb8d                	beqz	a5,80002e04 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002dd4:	0004c783          	lbu	a5,0(s1)
    80002dd8:	89a6                	mv	s3,s1
  len = path - s;
    80002dda:	4c81                	li	s9,0
    80002ddc:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002dde:	01278963          	beq	a5,s2,80002df0 <namex+0x10e>
    80002de2:	d3d9                	beqz	a5,80002d68 <namex+0x86>
    path++;
    80002de4:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002de6:	0009c783          	lbu	a5,0(s3)
    80002dea:	ff279ce3          	bne	a5,s2,80002de2 <namex+0x100>
    80002dee:	bfad                	j	80002d68 <namex+0x86>
    memmove(name, s, len);
    80002df0:	2601                	sext.w	a2,a2
    80002df2:	85a6                	mv	a1,s1
    80002df4:	8556                	mv	a0,s5
    80002df6:	bb4fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002dfa:	9cd6                	add	s9,s9,s5
    80002dfc:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002e00:	84ce                	mv	s1,s3
    80002e02:	bfbd                	j	80002d80 <namex+0x9e>
  if(nameiparent){
    80002e04:	f20b0be3          	beqz	s6,80002d3a <namex+0x58>
    iput(ip);
    80002e08:	8552                	mv	a0,s4
    80002e0a:	a0fff0ef          	jal	80002818 <iput>
    return 0;
    80002e0e:	4a01                	li	s4,0
    80002e10:	b72d                	j	80002d3a <namex+0x58>

0000000080002e12 <dirlink>:
{
    80002e12:	7139                	addi	sp,sp,-64
    80002e14:	fc06                	sd	ra,56(sp)
    80002e16:	f822                	sd	s0,48(sp)
    80002e18:	f04a                	sd	s2,32(sp)
    80002e1a:	ec4e                	sd	s3,24(sp)
    80002e1c:	e852                	sd	s4,16(sp)
    80002e1e:	0080                	addi	s0,sp,64
    80002e20:	892a                	mv	s2,a0
    80002e22:	8a2e                	mv	s4,a1
    80002e24:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e26:	4601                	li	a2,0
    80002e28:	e1fff0ef          	jal	80002c46 <dirlookup>
    80002e2c:	e535                	bnez	a0,80002e98 <dirlink+0x86>
    80002e2e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e30:	04c92483          	lw	s1,76(s2)
    80002e34:	c48d                	beqz	s1,80002e5e <dirlink+0x4c>
    80002e36:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e38:	4741                	li	a4,16
    80002e3a:	86a6                	mv	a3,s1
    80002e3c:	fc040613          	addi	a2,s0,-64
    80002e40:	4581                	li	a1,0
    80002e42:	854a                	mv	a0,s2
    80002e44:	be3ff0ef          	jal	80002a26 <readi>
    80002e48:	47c1                	li	a5,16
    80002e4a:	04f51b63          	bne	a0,a5,80002ea0 <dirlink+0x8e>
    if(de.inum == 0)
    80002e4e:	fc045783          	lhu	a5,-64(s0)
    80002e52:	c791                	beqz	a5,80002e5e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e54:	24c1                	addiw	s1,s1,16
    80002e56:	04c92783          	lw	a5,76(s2)
    80002e5a:	fcf4efe3          	bltu	s1,a5,80002e38 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e5e:	4639                	li	a2,14
    80002e60:	85d2                	mv	a1,s4
    80002e62:	fc240513          	addi	a0,s0,-62
    80002e66:	beafd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002e6a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e6e:	4741                	li	a4,16
    80002e70:	86a6                	mv	a3,s1
    80002e72:	fc040613          	addi	a2,s0,-64
    80002e76:	4581                	li	a1,0
    80002e78:	854a                	mv	a0,s2
    80002e7a:	ca9ff0ef          	jal	80002b22 <writei>
    80002e7e:	1541                	addi	a0,a0,-16
    80002e80:	00a03533          	snez	a0,a0
    80002e84:	40a00533          	neg	a0,a0
    80002e88:	74a2                	ld	s1,40(sp)
}
    80002e8a:	70e2                	ld	ra,56(sp)
    80002e8c:	7442                	ld	s0,48(sp)
    80002e8e:	7902                	ld	s2,32(sp)
    80002e90:	69e2                	ld	s3,24(sp)
    80002e92:	6a42                	ld	s4,16(sp)
    80002e94:	6121                	addi	sp,sp,64
    80002e96:	8082                	ret
    iput(ip);
    80002e98:	981ff0ef          	jal	80002818 <iput>
    return -1;
    80002e9c:	557d                	li	a0,-1
    80002e9e:	b7f5                	j	80002e8a <dirlink+0x78>
      panic("dirlink read");
    80002ea0:	00004517          	auipc	a0,0x4
    80002ea4:	5f850513          	addi	a0,a0,1528 # 80007498 <etext+0x498>
    80002ea8:	736020ef          	jal	800055de <panic>

0000000080002eac <namei>:

struct inode*
namei(char *path)
{
    80002eac:	1101                	addi	sp,sp,-32
    80002eae:	ec06                	sd	ra,24(sp)
    80002eb0:	e822                	sd	s0,16(sp)
    80002eb2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002eb4:	fe040613          	addi	a2,s0,-32
    80002eb8:	4581                	li	a1,0
    80002eba:	e29ff0ef          	jal	80002ce2 <namex>
}
    80002ebe:	60e2                	ld	ra,24(sp)
    80002ec0:	6442                	ld	s0,16(sp)
    80002ec2:	6105                	addi	sp,sp,32
    80002ec4:	8082                	ret

0000000080002ec6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002ec6:	1141                	addi	sp,sp,-16
    80002ec8:	e406                	sd	ra,8(sp)
    80002eca:	e022                	sd	s0,0(sp)
    80002ecc:	0800                	addi	s0,sp,16
    80002ece:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002ed0:	4585                	li	a1,1
    80002ed2:	e11ff0ef          	jal	80002ce2 <namex>
}
    80002ed6:	60a2                	ld	ra,8(sp)
    80002ed8:	6402                	ld	s0,0(sp)
    80002eda:	0141                	addi	sp,sp,16
    80002edc:	8082                	ret

0000000080002ede <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002ede:	1101                	addi	sp,sp,-32
    80002ee0:	ec06                	sd	ra,24(sp)
    80002ee2:	e822                	sd	s0,16(sp)
    80002ee4:	e426                	sd	s1,8(sp)
    80002ee6:	e04a                	sd	s2,0(sp)
    80002ee8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002eea:	00017917          	auipc	s2,0x17
    80002eee:	31690913          	addi	s2,s2,790 # 8001a200 <log>
    80002ef2:	01892583          	lw	a1,24(s2)
    80002ef6:	02492503          	lw	a0,36(s2)
    80002efa:	8d0ff0ef          	jal	80001fca <bread>
    80002efe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f00:	02892603          	lw	a2,40(s2)
    80002f04:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f06:	00c05f63          	blez	a2,80002f24 <write_head+0x46>
    80002f0a:	00017717          	auipc	a4,0x17
    80002f0e:	32270713          	addi	a4,a4,802 # 8001a22c <log+0x2c>
    80002f12:	87aa                	mv	a5,a0
    80002f14:	060a                	slli	a2,a2,0x2
    80002f16:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f18:	4314                	lw	a3,0(a4)
    80002f1a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f1c:	0711                	addi	a4,a4,4
    80002f1e:	0791                	addi	a5,a5,4
    80002f20:	fec79ce3          	bne	a5,a2,80002f18 <write_head+0x3a>
  }
  bwrite(buf);
    80002f24:	8526                	mv	a0,s1
    80002f26:	97aff0ef          	jal	800020a0 <bwrite>
  brelse(buf);
    80002f2a:	8526                	mv	a0,s1
    80002f2c:	9a6ff0ef          	jal	800020d2 <brelse>
}
    80002f30:	60e2                	ld	ra,24(sp)
    80002f32:	6442                	ld	s0,16(sp)
    80002f34:	64a2                	ld	s1,8(sp)
    80002f36:	6902                	ld	s2,0(sp)
    80002f38:	6105                	addi	sp,sp,32
    80002f3a:	8082                	ret

0000000080002f3c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f3c:	00017797          	auipc	a5,0x17
    80002f40:	2ec7a783          	lw	a5,748(a5) # 8001a228 <log+0x28>
    80002f44:	0af05e63          	blez	a5,80003000 <install_trans+0xc4>
{
    80002f48:	715d                	addi	sp,sp,-80
    80002f4a:	e486                	sd	ra,72(sp)
    80002f4c:	e0a2                	sd	s0,64(sp)
    80002f4e:	fc26                	sd	s1,56(sp)
    80002f50:	f84a                	sd	s2,48(sp)
    80002f52:	f44e                	sd	s3,40(sp)
    80002f54:	f052                	sd	s4,32(sp)
    80002f56:	ec56                	sd	s5,24(sp)
    80002f58:	e85a                	sd	s6,16(sp)
    80002f5a:	e45e                	sd	s7,8(sp)
    80002f5c:	0880                	addi	s0,sp,80
    80002f5e:	8b2a                	mv	s6,a0
    80002f60:	00017a97          	auipc	s5,0x17
    80002f64:	2cca8a93          	addi	s5,s5,716 # 8001a22c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f68:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002f6a:	00004b97          	auipc	s7,0x4
    80002f6e:	53eb8b93          	addi	s7,s7,1342 # 800074a8 <etext+0x4a8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f72:	00017a17          	auipc	s4,0x17
    80002f76:	28ea0a13          	addi	s4,s4,654 # 8001a200 <log>
    80002f7a:	a025                	j	80002fa2 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002f7c:	000aa603          	lw	a2,0(s5)
    80002f80:	85ce                	mv	a1,s3
    80002f82:	855e                	mv	a0,s7
    80002f84:	374020ef          	jal	800052f8 <printf>
    80002f88:	a839                	j	80002fa6 <install_trans+0x6a>
    brelse(lbuf);
    80002f8a:	854a                	mv	a0,s2
    80002f8c:	946ff0ef          	jal	800020d2 <brelse>
    brelse(dbuf);
    80002f90:	8526                	mv	a0,s1
    80002f92:	940ff0ef          	jal	800020d2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f96:	2985                	addiw	s3,s3,1
    80002f98:	0a91                	addi	s5,s5,4
    80002f9a:	028a2783          	lw	a5,40(s4)
    80002f9e:	04f9d663          	bge	s3,a5,80002fea <install_trans+0xae>
    if(recovering) {
    80002fa2:	fc0b1de3          	bnez	s6,80002f7c <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fa6:	018a2583          	lw	a1,24(s4)
    80002faa:	013585bb          	addw	a1,a1,s3
    80002fae:	2585                	addiw	a1,a1,1
    80002fb0:	024a2503          	lw	a0,36(s4)
    80002fb4:	816ff0ef          	jal	80001fca <bread>
    80002fb8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002fba:	000aa583          	lw	a1,0(s5)
    80002fbe:	024a2503          	lw	a0,36(s4)
    80002fc2:	808ff0ef          	jal	80001fca <bread>
    80002fc6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fc8:	40000613          	li	a2,1024
    80002fcc:	05890593          	addi	a1,s2,88
    80002fd0:	05850513          	addi	a0,a0,88
    80002fd4:	9d6fd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002fd8:	8526                	mv	a0,s1
    80002fda:	8c6ff0ef          	jal	800020a0 <bwrite>
    if(recovering == 0)
    80002fde:	fa0b16e3          	bnez	s6,80002f8a <install_trans+0x4e>
      bunpin(dbuf);
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	9aaff0ef          	jal	8000218e <bunpin>
    80002fe8:	b74d                	j	80002f8a <install_trans+0x4e>
}
    80002fea:	60a6                	ld	ra,72(sp)
    80002fec:	6406                	ld	s0,64(sp)
    80002fee:	74e2                	ld	s1,56(sp)
    80002ff0:	7942                	ld	s2,48(sp)
    80002ff2:	79a2                	ld	s3,40(sp)
    80002ff4:	7a02                	ld	s4,32(sp)
    80002ff6:	6ae2                	ld	s5,24(sp)
    80002ff8:	6b42                	ld	s6,16(sp)
    80002ffa:	6ba2                	ld	s7,8(sp)
    80002ffc:	6161                	addi	sp,sp,80
    80002ffe:	8082                	ret
    80003000:	8082                	ret

0000000080003002 <initlog>:
{
    80003002:	7179                	addi	sp,sp,-48
    80003004:	f406                	sd	ra,40(sp)
    80003006:	f022                	sd	s0,32(sp)
    80003008:	ec26                	sd	s1,24(sp)
    8000300a:	e84a                	sd	s2,16(sp)
    8000300c:	e44e                	sd	s3,8(sp)
    8000300e:	1800                	addi	s0,sp,48
    80003010:	892a                	mv	s2,a0
    80003012:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003014:	00017497          	auipc	s1,0x17
    80003018:	1ec48493          	addi	s1,s1,492 # 8001a200 <log>
    8000301c:	00004597          	auipc	a1,0x4
    80003020:	4ac58593          	addi	a1,a1,1196 # 800074c8 <etext+0x4c8>
    80003024:	8526                	mv	a0,s1
    80003026:	7f4020ef          	jal	8000581a <initlock>
  log.start = sb->logstart;
    8000302a:	0149a583          	lw	a1,20(s3)
    8000302e:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003030:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003034:	854a                	mv	a0,s2
    80003036:	f95fe0ef          	jal	80001fca <bread>
  log.lh.n = lh->n;
    8000303a:	4d30                	lw	a2,88(a0)
    8000303c:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000303e:	00c05f63          	blez	a2,8000305c <initlog+0x5a>
    80003042:	87aa                	mv	a5,a0
    80003044:	00017717          	auipc	a4,0x17
    80003048:	1e870713          	addi	a4,a4,488 # 8001a22c <log+0x2c>
    8000304c:	060a                	slli	a2,a2,0x2
    8000304e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003050:	4ff4                	lw	a3,92(a5)
    80003052:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003054:	0791                	addi	a5,a5,4
    80003056:	0711                	addi	a4,a4,4
    80003058:	fec79ce3          	bne	a5,a2,80003050 <initlog+0x4e>
  brelse(buf);
    8000305c:	876ff0ef          	jal	800020d2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003060:	4505                	li	a0,1
    80003062:	edbff0ef          	jal	80002f3c <install_trans>
  log.lh.n = 0;
    80003066:	00017797          	auipc	a5,0x17
    8000306a:	1c07a123          	sw	zero,450(a5) # 8001a228 <log+0x28>
  write_head(); // clear the log
    8000306e:	e71ff0ef          	jal	80002ede <write_head>
}
    80003072:	70a2                	ld	ra,40(sp)
    80003074:	7402                	ld	s0,32(sp)
    80003076:	64e2                	ld	s1,24(sp)
    80003078:	6942                	ld	s2,16(sp)
    8000307a:	69a2                	ld	s3,8(sp)
    8000307c:	6145                	addi	sp,sp,48
    8000307e:	8082                	ret

0000000080003080 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003080:	1101                	addi	sp,sp,-32
    80003082:	ec06                	sd	ra,24(sp)
    80003084:	e822                	sd	s0,16(sp)
    80003086:	e426                	sd	s1,8(sp)
    80003088:	e04a                	sd	s2,0(sp)
    8000308a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000308c:	00017517          	auipc	a0,0x17
    80003090:	17450513          	addi	a0,a0,372 # 8001a200 <log>
    80003094:	007020ef          	jal	8000589a <acquire>
  while(1){
    if(log.committing){
    80003098:	00017497          	auipc	s1,0x17
    8000309c:	16848493          	addi	s1,s1,360 # 8001a200 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030a0:	4979                	li	s2,30
    800030a2:	a029                	j	800030ac <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030a4:	85a6                	mv	a1,s1
    800030a6:	8526                	mv	a0,s1
    800030a8:	acafe0ef          	jal	80001372 <sleep>
    if(log.committing){
    800030ac:	509c                	lw	a5,32(s1)
    800030ae:	fbfd                	bnez	a5,800030a4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030b0:	4cd8                	lw	a4,28(s1)
    800030b2:	2705                	addiw	a4,a4,1
    800030b4:	0027179b          	slliw	a5,a4,0x2
    800030b8:	9fb9                	addw	a5,a5,a4
    800030ba:	0017979b          	slliw	a5,a5,0x1
    800030be:	5494                	lw	a3,40(s1)
    800030c0:	9fb5                	addw	a5,a5,a3
    800030c2:	00f95763          	bge	s2,a5,800030d0 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800030c6:	85a6                	mv	a1,s1
    800030c8:	8526                	mv	a0,s1
    800030ca:	aa8fe0ef          	jal	80001372 <sleep>
    800030ce:	bff9                	j	800030ac <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800030d0:	00017517          	auipc	a0,0x17
    800030d4:	13050513          	addi	a0,a0,304 # 8001a200 <log>
    800030d8:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    800030da:	059020ef          	jal	80005932 <release>
      break;
    }
  }
}
    800030de:	60e2                	ld	ra,24(sp)
    800030e0:	6442                	ld	s0,16(sp)
    800030e2:	64a2                	ld	s1,8(sp)
    800030e4:	6902                	ld	s2,0(sp)
    800030e6:	6105                	addi	sp,sp,32
    800030e8:	8082                	ret

00000000800030ea <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800030ea:	7139                	addi	sp,sp,-64
    800030ec:	fc06                	sd	ra,56(sp)
    800030ee:	f822                	sd	s0,48(sp)
    800030f0:	f426                	sd	s1,40(sp)
    800030f2:	f04a                	sd	s2,32(sp)
    800030f4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800030f6:	00017497          	auipc	s1,0x17
    800030fa:	10a48493          	addi	s1,s1,266 # 8001a200 <log>
    800030fe:	8526                	mv	a0,s1
    80003100:	79a020ef          	jal	8000589a <acquire>
  log.outstanding -= 1;
    80003104:	4cdc                	lw	a5,28(s1)
    80003106:	37fd                	addiw	a5,a5,-1
    80003108:	0007891b          	sext.w	s2,a5
    8000310c:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    8000310e:	509c                	lw	a5,32(s1)
    80003110:	ef9d                	bnez	a5,8000314e <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003112:	04091763          	bnez	s2,80003160 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003116:	00017497          	auipc	s1,0x17
    8000311a:	0ea48493          	addi	s1,s1,234 # 8001a200 <log>
    8000311e:	4785                	li	a5,1
    80003120:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003122:	8526                	mv	a0,s1
    80003124:	00f020ef          	jal	80005932 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003128:	549c                	lw	a5,40(s1)
    8000312a:	04f04b63          	bgtz	a5,80003180 <end_op+0x96>
    acquire(&log.lock);
    8000312e:	00017497          	auipc	s1,0x17
    80003132:	0d248493          	addi	s1,s1,210 # 8001a200 <log>
    80003136:	8526                	mv	a0,s1
    80003138:	762020ef          	jal	8000589a <acquire>
    log.committing = 0;
    8000313c:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003140:	8526                	mv	a0,s1
    80003142:	a7cfe0ef          	jal	800013be <wakeup>
    release(&log.lock);
    80003146:	8526                	mv	a0,s1
    80003148:	7ea020ef          	jal	80005932 <release>
}
    8000314c:	a025                	j	80003174 <end_op+0x8a>
    8000314e:	ec4e                	sd	s3,24(sp)
    80003150:	e852                	sd	s4,16(sp)
    80003152:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003154:	00004517          	auipc	a0,0x4
    80003158:	37c50513          	addi	a0,a0,892 # 800074d0 <etext+0x4d0>
    8000315c:	482020ef          	jal	800055de <panic>
    wakeup(&log);
    80003160:	00017497          	auipc	s1,0x17
    80003164:	0a048493          	addi	s1,s1,160 # 8001a200 <log>
    80003168:	8526                	mv	a0,s1
    8000316a:	a54fe0ef          	jal	800013be <wakeup>
  release(&log.lock);
    8000316e:	8526                	mv	a0,s1
    80003170:	7c2020ef          	jal	80005932 <release>
}
    80003174:	70e2                	ld	ra,56(sp)
    80003176:	7442                	ld	s0,48(sp)
    80003178:	74a2                	ld	s1,40(sp)
    8000317a:	7902                	ld	s2,32(sp)
    8000317c:	6121                	addi	sp,sp,64
    8000317e:	8082                	ret
    80003180:	ec4e                	sd	s3,24(sp)
    80003182:	e852                	sd	s4,16(sp)
    80003184:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003186:	00017a97          	auipc	s5,0x17
    8000318a:	0a6a8a93          	addi	s5,s5,166 # 8001a22c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000318e:	00017a17          	auipc	s4,0x17
    80003192:	072a0a13          	addi	s4,s4,114 # 8001a200 <log>
    80003196:	018a2583          	lw	a1,24(s4)
    8000319a:	012585bb          	addw	a1,a1,s2
    8000319e:	2585                	addiw	a1,a1,1
    800031a0:	024a2503          	lw	a0,36(s4)
    800031a4:	e27fe0ef          	jal	80001fca <bread>
    800031a8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031aa:	000aa583          	lw	a1,0(s5)
    800031ae:	024a2503          	lw	a0,36(s4)
    800031b2:	e19fe0ef          	jal	80001fca <bread>
    800031b6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031b8:	40000613          	li	a2,1024
    800031bc:	05850593          	addi	a1,a0,88
    800031c0:	05848513          	addi	a0,s1,88
    800031c4:	fe7fc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    800031c8:	8526                	mv	a0,s1
    800031ca:	ed7fe0ef          	jal	800020a0 <bwrite>
    brelse(from);
    800031ce:	854e                	mv	a0,s3
    800031d0:	f03fe0ef          	jal	800020d2 <brelse>
    brelse(to);
    800031d4:	8526                	mv	a0,s1
    800031d6:	efdfe0ef          	jal	800020d2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031da:	2905                	addiw	s2,s2,1
    800031dc:	0a91                	addi	s5,s5,4
    800031de:	028a2783          	lw	a5,40(s4)
    800031e2:	faf94ae3          	blt	s2,a5,80003196 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800031e6:	cf9ff0ef          	jal	80002ede <write_head>
    install_trans(0); // Now install writes to home locations
    800031ea:	4501                	li	a0,0
    800031ec:	d51ff0ef          	jal	80002f3c <install_trans>
    log.lh.n = 0;
    800031f0:	00017797          	auipc	a5,0x17
    800031f4:	0207ac23          	sw	zero,56(a5) # 8001a228 <log+0x28>
    write_head();    // Erase the transaction from the log
    800031f8:	ce7ff0ef          	jal	80002ede <write_head>
    800031fc:	69e2                	ld	s3,24(sp)
    800031fe:	6a42                	ld	s4,16(sp)
    80003200:	6aa2                	ld	s5,8(sp)
    80003202:	b735                	j	8000312e <end_op+0x44>

0000000080003204 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003204:	1101                	addi	sp,sp,-32
    80003206:	ec06                	sd	ra,24(sp)
    80003208:	e822                	sd	s0,16(sp)
    8000320a:	e426                	sd	s1,8(sp)
    8000320c:	e04a                	sd	s2,0(sp)
    8000320e:	1000                	addi	s0,sp,32
    80003210:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003212:	00017917          	auipc	s2,0x17
    80003216:	fee90913          	addi	s2,s2,-18 # 8001a200 <log>
    8000321a:	854a                	mv	a0,s2
    8000321c:	67e020ef          	jal	8000589a <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003220:	02892603          	lw	a2,40(s2)
    80003224:	47f5                	li	a5,29
    80003226:	04c7cc63          	blt	a5,a2,8000327e <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000322a:	00017797          	auipc	a5,0x17
    8000322e:	ff27a783          	lw	a5,-14(a5) # 8001a21c <log+0x1c>
    80003232:	04f05c63          	blez	a5,8000328a <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003236:	4781                	li	a5,0
    80003238:	04c05f63          	blez	a2,80003296 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000323c:	44cc                	lw	a1,12(s1)
    8000323e:	00017717          	auipc	a4,0x17
    80003242:	fee70713          	addi	a4,a4,-18 # 8001a22c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003246:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003248:	4314                	lw	a3,0(a4)
    8000324a:	04b68663          	beq	a3,a1,80003296 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    8000324e:	2785                	addiw	a5,a5,1
    80003250:	0711                	addi	a4,a4,4
    80003252:	fef61be3          	bne	a2,a5,80003248 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003256:	0621                	addi	a2,a2,8
    80003258:	060a                	slli	a2,a2,0x2
    8000325a:	00017797          	auipc	a5,0x17
    8000325e:	fa678793          	addi	a5,a5,-90 # 8001a200 <log>
    80003262:	97b2                	add	a5,a5,a2
    80003264:	44d8                	lw	a4,12(s1)
    80003266:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003268:	8526                	mv	a0,s1
    8000326a:	ef1fe0ef          	jal	8000215a <bpin>
    log.lh.n++;
    8000326e:	00017717          	auipc	a4,0x17
    80003272:	f9270713          	addi	a4,a4,-110 # 8001a200 <log>
    80003276:	571c                	lw	a5,40(a4)
    80003278:	2785                	addiw	a5,a5,1
    8000327a:	d71c                	sw	a5,40(a4)
    8000327c:	a80d                	j	800032ae <log_write+0xaa>
    panic("too big a transaction");
    8000327e:	00004517          	auipc	a0,0x4
    80003282:	26250513          	addi	a0,a0,610 # 800074e0 <etext+0x4e0>
    80003286:	358020ef          	jal	800055de <panic>
    panic("log_write outside of trans");
    8000328a:	00004517          	auipc	a0,0x4
    8000328e:	26e50513          	addi	a0,a0,622 # 800074f8 <etext+0x4f8>
    80003292:	34c020ef          	jal	800055de <panic>
  log.lh.block[i] = b->blockno;
    80003296:	00878693          	addi	a3,a5,8
    8000329a:	068a                	slli	a3,a3,0x2
    8000329c:	00017717          	auipc	a4,0x17
    800032a0:	f6470713          	addi	a4,a4,-156 # 8001a200 <log>
    800032a4:	9736                	add	a4,a4,a3
    800032a6:	44d4                	lw	a3,12(s1)
    800032a8:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032aa:	faf60fe3          	beq	a2,a5,80003268 <log_write+0x64>
  }
  release(&log.lock);
    800032ae:	00017517          	auipc	a0,0x17
    800032b2:	f5250513          	addi	a0,a0,-174 # 8001a200 <log>
    800032b6:	67c020ef          	jal	80005932 <release>
}
    800032ba:	60e2                	ld	ra,24(sp)
    800032bc:	6442                	ld	s0,16(sp)
    800032be:	64a2                	ld	s1,8(sp)
    800032c0:	6902                	ld	s2,0(sp)
    800032c2:	6105                	addi	sp,sp,32
    800032c4:	8082                	ret

00000000800032c6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800032c6:	1101                	addi	sp,sp,-32
    800032c8:	ec06                	sd	ra,24(sp)
    800032ca:	e822                	sd	s0,16(sp)
    800032cc:	e426                	sd	s1,8(sp)
    800032ce:	e04a                	sd	s2,0(sp)
    800032d0:	1000                	addi	s0,sp,32
    800032d2:	84aa                	mv	s1,a0
    800032d4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800032d6:	00004597          	auipc	a1,0x4
    800032da:	24258593          	addi	a1,a1,578 # 80007518 <etext+0x518>
    800032de:	0521                	addi	a0,a0,8
    800032e0:	53a020ef          	jal	8000581a <initlock>
  lk->name = name;
    800032e4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800032e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032ec:	0204a423          	sw	zero,40(s1)
}
    800032f0:	60e2                	ld	ra,24(sp)
    800032f2:	6442                	ld	s0,16(sp)
    800032f4:	64a2                	ld	s1,8(sp)
    800032f6:	6902                	ld	s2,0(sp)
    800032f8:	6105                	addi	sp,sp,32
    800032fa:	8082                	ret

00000000800032fc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800032fc:	1101                	addi	sp,sp,-32
    800032fe:	ec06                	sd	ra,24(sp)
    80003300:	e822                	sd	s0,16(sp)
    80003302:	e426                	sd	s1,8(sp)
    80003304:	e04a                	sd	s2,0(sp)
    80003306:	1000                	addi	s0,sp,32
    80003308:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000330a:	00850913          	addi	s2,a0,8
    8000330e:	854a                	mv	a0,s2
    80003310:	58a020ef          	jal	8000589a <acquire>
  while (lk->locked) {
    80003314:	409c                	lw	a5,0(s1)
    80003316:	c799                	beqz	a5,80003324 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003318:	85ca                	mv	a1,s2
    8000331a:	8526                	mv	a0,s1
    8000331c:	856fe0ef          	jal	80001372 <sleep>
  while (lk->locked) {
    80003320:	409c                	lw	a5,0(s1)
    80003322:	fbfd                	bnez	a5,80003318 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003324:	4785                	li	a5,1
    80003326:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003328:	a53fd0ef          	jal	80000d7a <myproc>
    8000332c:	591c                	lw	a5,48(a0)
    8000332e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003330:	854a                	mv	a0,s2
    80003332:	600020ef          	jal	80005932 <release>
}
    80003336:	60e2                	ld	ra,24(sp)
    80003338:	6442                	ld	s0,16(sp)
    8000333a:	64a2                	ld	s1,8(sp)
    8000333c:	6902                	ld	s2,0(sp)
    8000333e:	6105                	addi	sp,sp,32
    80003340:	8082                	ret

0000000080003342 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003342:	1101                	addi	sp,sp,-32
    80003344:	ec06                	sd	ra,24(sp)
    80003346:	e822                	sd	s0,16(sp)
    80003348:	e426                	sd	s1,8(sp)
    8000334a:	e04a                	sd	s2,0(sp)
    8000334c:	1000                	addi	s0,sp,32
    8000334e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003350:	00850913          	addi	s2,a0,8
    80003354:	854a                	mv	a0,s2
    80003356:	544020ef          	jal	8000589a <acquire>
  lk->locked = 0;
    8000335a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000335e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003362:	8526                	mv	a0,s1
    80003364:	85afe0ef          	jal	800013be <wakeup>
  release(&lk->lk);
    80003368:	854a                	mv	a0,s2
    8000336a:	5c8020ef          	jal	80005932 <release>
}
    8000336e:	60e2                	ld	ra,24(sp)
    80003370:	6442                	ld	s0,16(sp)
    80003372:	64a2                	ld	s1,8(sp)
    80003374:	6902                	ld	s2,0(sp)
    80003376:	6105                	addi	sp,sp,32
    80003378:	8082                	ret

000000008000337a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000337a:	7179                	addi	sp,sp,-48
    8000337c:	f406                	sd	ra,40(sp)
    8000337e:	f022                	sd	s0,32(sp)
    80003380:	ec26                	sd	s1,24(sp)
    80003382:	e84a                	sd	s2,16(sp)
    80003384:	1800                	addi	s0,sp,48
    80003386:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003388:	00850913          	addi	s2,a0,8
    8000338c:	854a                	mv	a0,s2
    8000338e:	50c020ef          	jal	8000589a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003392:	409c                	lw	a5,0(s1)
    80003394:	ef81                	bnez	a5,800033ac <holdingsleep+0x32>
    80003396:	4481                	li	s1,0
  release(&lk->lk);
    80003398:	854a                	mv	a0,s2
    8000339a:	598020ef          	jal	80005932 <release>
  return r;
}
    8000339e:	8526                	mv	a0,s1
    800033a0:	70a2                	ld	ra,40(sp)
    800033a2:	7402                	ld	s0,32(sp)
    800033a4:	64e2                	ld	s1,24(sp)
    800033a6:	6942                	ld	s2,16(sp)
    800033a8:	6145                	addi	sp,sp,48
    800033aa:	8082                	ret
    800033ac:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800033ae:	0284a983          	lw	s3,40(s1)
    800033b2:	9c9fd0ef          	jal	80000d7a <myproc>
    800033b6:	5904                	lw	s1,48(a0)
    800033b8:	413484b3          	sub	s1,s1,s3
    800033bc:	0014b493          	seqz	s1,s1
    800033c0:	69a2                	ld	s3,8(sp)
    800033c2:	bfd9                	j	80003398 <holdingsleep+0x1e>

00000000800033c4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800033c4:	1141                	addi	sp,sp,-16
    800033c6:	e406                	sd	ra,8(sp)
    800033c8:	e022                	sd	s0,0(sp)
    800033ca:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800033cc:	00004597          	auipc	a1,0x4
    800033d0:	15c58593          	addi	a1,a1,348 # 80007528 <etext+0x528>
    800033d4:	00017517          	auipc	a0,0x17
    800033d8:	f7450513          	addi	a0,a0,-140 # 8001a348 <ftable>
    800033dc:	43e020ef          	jal	8000581a <initlock>
}
    800033e0:	60a2                	ld	ra,8(sp)
    800033e2:	6402                	ld	s0,0(sp)
    800033e4:	0141                	addi	sp,sp,16
    800033e6:	8082                	ret

00000000800033e8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800033f2:	00017517          	auipc	a0,0x17
    800033f6:	f5650513          	addi	a0,a0,-170 # 8001a348 <ftable>
    800033fa:	4a0020ef          	jal	8000589a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033fe:	00017497          	auipc	s1,0x17
    80003402:	f6248493          	addi	s1,s1,-158 # 8001a360 <ftable+0x18>
    80003406:	00018717          	auipc	a4,0x18
    8000340a:	efa70713          	addi	a4,a4,-262 # 8001b300 <disk>
    if(f->ref == 0){
    8000340e:	40dc                	lw	a5,4(s1)
    80003410:	cf89                	beqz	a5,8000342a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003412:	02848493          	addi	s1,s1,40
    80003416:	fee49ce3          	bne	s1,a4,8000340e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000341a:	00017517          	auipc	a0,0x17
    8000341e:	f2e50513          	addi	a0,a0,-210 # 8001a348 <ftable>
    80003422:	510020ef          	jal	80005932 <release>
  return 0;
    80003426:	4481                	li	s1,0
    80003428:	a809                	j	8000343a <filealloc+0x52>
      f->ref = 1;
    8000342a:	4785                	li	a5,1
    8000342c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000342e:	00017517          	auipc	a0,0x17
    80003432:	f1a50513          	addi	a0,a0,-230 # 8001a348 <ftable>
    80003436:	4fc020ef          	jal	80005932 <release>
}
    8000343a:	8526                	mv	a0,s1
    8000343c:	60e2                	ld	ra,24(sp)
    8000343e:	6442                	ld	s0,16(sp)
    80003440:	64a2                	ld	s1,8(sp)
    80003442:	6105                	addi	sp,sp,32
    80003444:	8082                	ret

0000000080003446 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003446:	1101                	addi	sp,sp,-32
    80003448:	ec06                	sd	ra,24(sp)
    8000344a:	e822                	sd	s0,16(sp)
    8000344c:	e426                	sd	s1,8(sp)
    8000344e:	1000                	addi	s0,sp,32
    80003450:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003452:	00017517          	auipc	a0,0x17
    80003456:	ef650513          	addi	a0,a0,-266 # 8001a348 <ftable>
    8000345a:	440020ef          	jal	8000589a <acquire>
  if(f->ref < 1)
    8000345e:	40dc                	lw	a5,4(s1)
    80003460:	02f05063          	blez	a5,80003480 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003464:	2785                	addiw	a5,a5,1
    80003466:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003468:	00017517          	auipc	a0,0x17
    8000346c:	ee050513          	addi	a0,a0,-288 # 8001a348 <ftable>
    80003470:	4c2020ef          	jal	80005932 <release>
  return f;
}
    80003474:	8526                	mv	a0,s1
    80003476:	60e2                	ld	ra,24(sp)
    80003478:	6442                	ld	s0,16(sp)
    8000347a:	64a2                	ld	s1,8(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret
    panic("filedup");
    80003480:	00004517          	auipc	a0,0x4
    80003484:	0b050513          	addi	a0,a0,176 # 80007530 <etext+0x530>
    80003488:	156020ef          	jal	800055de <panic>

000000008000348c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000348c:	7139                	addi	sp,sp,-64
    8000348e:	fc06                	sd	ra,56(sp)
    80003490:	f822                	sd	s0,48(sp)
    80003492:	f426                	sd	s1,40(sp)
    80003494:	0080                	addi	s0,sp,64
    80003496:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003498:	00017517          	auipc	a0,0x17
    8000349c:	eb050513          	addi	a0,a0,-336 # 8001a348 <ftable>
    800034a0:	3fa020ef          	jal	8000589a <acquire>
  if(f->ref < 1)
    800034a4:	40dc                	lw	a5,4(s1)
    800034a6:	04f05a63          	blez	a5,800034fa <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800034aa:	37fd                	addiw	a5,a5,-1
    800034ac:	0007871b          	sext.w	a4,a5
    800034b0:	c0dc                	sw	a5,4(s1)
    800034b2:	04e04e63          	bgtz	a4,8000350e <fileclose+0x82>
    800034b6:	f04a                	sd	s2,32(sp)
    800034b8:	ec4e                	sd	s3,24(sp)
    800034ba:	e852                	sd	s4,16(sp)
    800034bc:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800034be:	0004a903          	lw	s2,0(s1)
    800034c2:	0094ca83          	lbu	s5,9(s1)
    800034c6:	0104ba03          	ld	s4,16(s1)
    800034ca:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800034ce:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800034d2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800034d6:	00017517          	auipc	a0,0x17
    800034da:	e7250513          	addi	a0,a0,-398 # 8001a348 <ftable>
    800034de:	454020ef          	jal	80005932 <release>

  if(ff.type == FD_PIPE){
    800034e2:	4785                	li	a5,1
    800034e4:	04f90063          	beq	s2,a5,80003524 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800034e8:	3979                	addiw	s2,s2,-2
    800034ea:	4785                	li	a5,1
    800034ec:	0527f563          	bgeu	a5,s2,80003536 <fileclose+0xaa>
    800034f0:	7902                	ld	s2,32(sp)
    800034f2:	69e2                	ld	s3,24(sp)
    800034f4:	6a42                	ld	s4,16(sp)
    800034f6:	6aa2                	ld	s5,8(sp)
    800034f8:	a00d                	j	8000351a <fileclose+0x8e>
    800034fa:	f04a                	sd	s2,32(sp)
    800034fc:	ec4e                	sd	s3,24(sp)
    800034fe:	e852                	sd	s4,16(sp)
    80003500:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003502:	00004517          	auipc	a0,0x4
    80003506:	03650513          	addi	a0,a0,54 # 80007538 <etext+0x538>
    8000350a:	0d4020ef          	jal	800055de <panic>
    release(&ftable.lock);
    8000350e:	00017517          	auipc	a0,0x17
    80003512:	e3a50513          	addi	a0,a0,-454 # 8001a348 <ftable>
    80003516:	41c020ef          	jal	80005932 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000351a:	70e2                	ld	ra,56(sp)
    8000351c:	7442                	ld	s0,48(sp)
    8000351e:	74a2                	ld	s1,40(sp)
    80003520:	6121                	addi	sp,sp,64
    80003522:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003524:	85d6                	mv	a1,s5
    80003526:	8552                	mv	a0,s4
    80003528:	336000ef          	jal	8000385e <pipeclose>
    8000352c:	7902                	ld	s2,32(sp)
    8000352e:	69e2                	ld	s3,24(sp)
    80003530:	6a42                	ld	s4,16(sp)
    80003532:	6aa2                	ld	s5,8(sp)
    80003534:	b7dd                	j	8000351a <fileclose+0x8e>
    begin_op();
    80003536:	b4bff0ef          	jal	80003080 <begin_op>
    iput(ff.ip);
    8000353a:	854e                	mv	a0,s3
    8000353c:	adcff0ef          	jal	80002818 <iput>
    end_op();
    80003540:	babff0ef          	jal	800030ea <end_op>
    80003544:	7902                	ld	s2,32(sp)
    80003546:	69e2                	ld	s3,24(sp)
    80003548:	6a42                	ld	s4,16(sp)
    8000354a:	6aa2                	ld	s5,8(sp)
    8000354c:	b7f9                	j	8000351a <fileclose+0x8e>

000000008000354e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000354e:	715d                	addi	sp,sp,-80
    80003550:	e486                	sd	ra,72(sp)
    80003552:	e0a2                	sd	s0,64(sp)
    80003554:	fc26                	sd	s1,56(sp)
    80003556:	f44e                	sd	s3,40(sp)
    80003558:	0880                	addi	s0,sp,80
    8000355a:	84aa                	mv	s1,a0
    8000355c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000355e:	81dfd0ef          	jal	80000d7a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003562:	409c                	lw	a5,0(s1)
    80003564:	37f9                	addiw	a5,a5,-2
    80003566:	4705                	li	a4,1
    80003568:	04f76063          	bltu	a4,a5,800035a8 <filestat+0x5a>
    8000356c:	f84a                	sd	s2,48(sp)
    8000356e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003570:	6c88                	ld	a0,24(s1)
    80003572:	924ff0ef          	jal	80002696 <ilock>
    stati(f->ip, &st);
    80003576:	fb840593          	addi	a1,s0,-72
    8000357a:	6c88                	ld	a0,24(s1)
    8000357c:	c80ff0ef          	jal	800029fc <stati>
    iunlock(f->ip);
    80003580:	6c88                	ld	a0,24(s1)
    80003582:	9c2ff0ef          	jal	80002744 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003586:	46e1                	li	a3,24
    80003588:	fb840613          	addi	a2,s0,-72
    8000358c:	85ce                	mv	a1,s3
    8000358e:	05093503          	ld	a0,80(s2)
    80003592:	cfcfd0ef          	jal	80000a8e <copyout>
    80003596:	41f5551b          	sraiw	a0,a0,0x1f
    8000359a:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000359c:	60a6                	ld	ra,72(sp)
    8000359e:	6406                	ld	s0,64(sp)
    800035a0:	74e2                	ld	s1,56(sp)
    800035a2:	79a2                	ld	s3,40(sp)
    800035a4:	6161                	addi	sp,sp,80
    800035a6:	8082                	ret
  return -1;
    800035a8:	557d                	li	a0,-1
    800035aa:	bfcd                	j	8000359c <filestat+0x4e>

00000000800035ac <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035ac:	7179                	addi	sp,sp,-48
    800035ae:	f406                	sd	ra,40(sp)
    800035b0:	f022                	sd	s0,32(sp)
    800035b2:	e84a                	sd	s2,16(sp)
    800035b4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035b6:	00854783          	lbu	a5,8(a0)
    800035ba:	cfd1                	beqz	a5,80003656 <fileread+0xaa>
    800035bc:	ec26                	sd	s1,24(sp)
    800035be:	e44e                	sd	s3,8(sp)
    800035c0:	84aa                	mv	s1,a0
    800035c2:	89ae                	mv	s3,a1
    800035c4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800035c6:	411c                	lw	a5,0(a0)
    800035c8:	4705                	li	a4,1
    800035ca:	04e78363          	beq	a5,a4,80003610 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035ce:	470d                	li	a4,3
    800035d0:	04e78763          	beq	a5,a4,8000361e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800035d4:	4709                	li	a4,2
    800035d6:	06e79a63          	bne	a5,a4,8000364a <fileread+0x9e>
    ilock(f->ip);
    800035da:	6d08                	ld	a0,24(a0)
    800035dc:	8baff0ef          	jal	80002696 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800035e0:	874a                	mv	a4,s2
    800035e2:	5094                	lw	a3,32(s1)
    800035e4:	864e                	mv	a2,s3
    800035e6:	4585                	li	a1,1
    800035e8:	6c88                	ld	a0,24(s1)
    800035ea:	c3cff0ef          	jal	80002a26 <readi>
    800035ee:	892a                	mv	s2,a0
    800035f0:	00a05563          	blez	a0,800035fa <fileread+0x4e>
      f->off += r;
    800035f4:	509c                	lw	a5,32(s1)
    800035f6:	9fa9                	addw	a5,a5,a0
    800035f8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800035fa:	6c88                	ld	a0,24(s1)
    800035fc:	948ff0ef          	jal	80002744 <iunlock>
    80003600:	64e2                	ld	s1,24(sp)
    80003602:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003604:	854a                	mv	a0,s2
    80003606:	70a2                	ld	ra,40(sp)
    80003608:	7402                	ld	s0,32(sp)
    8000360a:	6942                	ld	s2,16(sp)
    8000360c:	6145                	addi	sp,sp,48
    8000360e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003610:	6908                	ld	a0,16(a0)
    80003612:	388000ef          	jal	8000399a <piperead>
    80003616:	892a                	mv	s2,a0
    80003618:	64e2                	ld	s1,24(sp)
    8000361a:	69a2                	ld	s3,8(sp)
    8000361c:	b7e5                	j	80003604 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000361e:	02451783          	lh	a5,36(a0)
    80003622:	03079693          	slli	a3,a5,0x30
    80003626:	92c1                	srli	a3,a3,0x30
    80003628:	4725                	li	a4,9
    8000362a:	02d76863          	bltu	a4,a3,8000365a <fileread+0xae>
    8000362e:	0792                	slli	a5,a5,0x4
    80003630:	00017717          	auipc	a4,0x17
    80003634:	c7870713          	addi	a4,a4,-904 # 8001a2a8 <devsw>
    80003638:	97ba                	add	a5,a5,a4
    8000363a:	639c                	ld	a5,0(a5)
    8000363c:	c39d                	beqz	a5,80003662 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000363e:	4505                	li	a0,1
    80003640:	9782                	jalr	a5
    80003642:	892a                	mv	s2,a0
    80003644:	64e2                	ld	s1,24(sp)
    80003646:	69a2                	ld	s3,8(sp)
    80003648:	bf75                	j	80003604 <fileread+0x58>
    panic("fileread");
    8000364a:	00004517          	auipc	a0,0x4
    8000364e:	efe50513          	addi	a0,a0,-258 # 80007548 <etext+0x548>
    80003652:	78d010ef          	jal	800055de <panic>
    return -1;
    80003656:	597d                	li	s2,-1
    80003658:	b775                	j	80003604 <fileread+0x58>
      return -1;
    8000365a:	597d                	li	s2,-1
    8000365c:	64e2                	ld	s1,24(sp)
    8000365e:	69a2                	ld	s3,8(sp)
    80003660:	b755                	j	80003604 <fileread+0x58>
    80003662:	597d                	li	s2,-1
    80003664:	64e2                	ld	s1,24(sp)
    80003666:	69a2                	ld	s3,8(sp)
    80003668:	bf71                	j	80003604 <fileread+0x58>

000000008000366a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000366a:	00954783          	lbu	a5,9(a0)
    8000366e:	10078b63          	beqz	a5,80003784 <filewrite+0x11a>
{
    80003672:	715d                	addi	sp,sp,-80
    80003674:	e486                	sd	ra,72(sp)
    80003676:	e0a2                	sd	s0,64(sp)
    80003678:	f84a                	sd	s2,48(sp)
    8000367a:	f052                	sd	s4,32(sp)
    8000367c:	e85a                	sd	s6,16(sp)
    8000367e:	0880                	addi	s0,sp,80
    80003680:	892a                	mv	s2,a0
    80003682:	8b2e                	mv	s6,a1
    80003684:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003686:	411c                	lw	a5,0(a0)
    80003688:	4705                	li	a4,1
    8000368a:	02e78763          	beq	a5,a4,800036b8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000368e:	470d                	li	a4,3
    80003690:	02e78863          	beq	a5,a4,800036c0 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003694:	4709                	li	a4,2
    80003696:	0ce79c63          	bne	a5,a4,8000376e <filewrite+0x104>
    8000369a:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000369c:	0ac05863          	blez	a2,8000374c <filewrite+0xe2>
    800036a0:	fc26                	sd	s1,56(sp)
    800036a2:	ec56                	sd	s5,24(sp)
    800036a4:	e45e                	sd	s7,8(sp)
    800036a6:	e062                	sd	s8,0(sp)
    int i = 0;
    800036a8:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800036aa:	6b85                	lui	s7,0x1
    800036ac:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036b0:	6c05                	lui	s8,0x1
    800036b2:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800036b6:	a8b5                	j	80003732 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800036b8:	6908                	ld	a0,16(a0)
    800036ba:	1fc000ef          	jal	800038b6 <pipewrite>
    800036be:	a04d                	j	80003760 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800036c0:	02451783          	lh	a5,36(a0)
    800036c4:	03079693          	slli	a3,a5,0x30
    800036c8:	92c1                	srli	a3,a3,0x30
    800036ca:	4725                	li	a4,9
    800036cc:	0ad76e63          	bltu	a4,a3,80003788 <filewrite+0x11e>
    800036d0:	0792                	slli	a5,a5,0x4
    800036d2:	00017717          	auipc	a4,0x17
    800036d6:	bd670713          	addi	a4,a4,-1066 # 8001a2a8 <devsw>
    800036da:	97ba                	add	a5,a5,a4
    800036dc:	679c                	ld	a5,8(a5)
    800036de:	c7dd                	beqz	a5,8000378c <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800036e0:	4505                	li	a0,1
    800036e2:	9782                	jalr	a5
    800036e4:	a8b5                	j	80003760 <filewrite+0xf6>
      if(n1 > max)
    800036e6:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800036ea:	997ff0ef          	jal	80003080 <begin_op>
      ilock(f->ip);
    800036ee:	01893503          	ld	a0,24(s2)
    800036f2:	fa5fe0ef          	jal	80002696 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036f6:	8756                	mv	a4,s5
    800036f8:	02092683          	lw	a3,32(s2)
    800036fc:	01698633          	add	a2,s3,s6
    80003700:	4585                	li	a1,1
    80003702:	01893503          	ld	a0,24(s2)
    80003706:	c1cff0ef          	jal	80002b22 <writei>
    8000370a:	84aa                	mv	s1,a0
    8000370c:	00a05763          	blez	a0,8000371a <filewrite+0xb0>
        f->off += r;
    80003710:	02092783          	lw	a5,32(s2)
    80003714:	9fa9                	addw	a5,a5,a0
    80003716:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000371a:	01893503          	ld	a0,24(s2)
    8000371e:	826ff0ef          	jal	80002744 <iunlock>
      end_op();
    80003722:	9c9ff0ef          	jal	800030ea <end_op>

      if(r != n1){
    80003726:	029a9563          	bne	s5,s1,80003750 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000372a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000372e:	0149da63          	bge	s3,s4,80003742 <filewrite+0xd8>
      int n1 = n - i;
    80003732:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003736:	0004879b          	sext.w	a5,s1
    8000373a:	fafbd6e3          	bge	s7,a5,800036e6 <filewrite+0x7c>
    8000373e:	84e2                	mv	s1,s8
    80003740:	b75d                	j	800036e6 <filewrite+0x7c>
    80003742:	74e2                	ld	s1,56(sp)
    80003744:	6ae2                	ld	s5,24(sp)
    80003746:	6ba2                	ld	s7,8(sp)
    80003748:	6c02                	ld	s8,0(sp)
    8000374a:	a039                	j	80003758 <filewrite+0xee>
    int i = 0;
    8000374c:	4981                	li	s3,0
    8000374e:	a029                	j	80003758 <filewrite+0xee>
    80003750:	74e2                	ld	s1,56(sp)
    80003752:	6ae2                	ld	s5,24(sp)
    80003754:	6ba2                	ld	s7,8(sp)
    80003756:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003758:	033a1c63          	bne	s4,s3,80003790 <filewrite+0x126>
    8000375c:	8552                	mv	a0,s4
    8000375e:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003760:	60a6                	ld	ra,72(sp)
    80003762:	6406                	ld	s0,64(sp)
    80003764:	7942                	ld	s2,48(sp)
    80003766:	7a02                	ld	s4,32(sp)
    80003768:	6b42                	ld	s6,16(sp)
    8000376a:	6161                	addi	sp,sp,80
    8000376c:	8082                	ret
    8000376e:	fc26                	sd	s1,56(sp)
    80003770:	f44e                	sd	s3,40(sp)
    80003772:	ec56                	sd	s5,24(sp)
    80003774:	e45e                	sd	s7,8(sp)
    80003776:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003778:	00004517          	auipc	a0,0x4
    8000377c:	de050513          	addi	a0,a0,-544 # 80007558 <etext+0x558>
    80003780:	65f010ef          	jal	800055de <panic>
    return -1;
    80003784:	557d                	li	a0,-1
}
    80003786:	8082                	ret
      return -1;
    80003788:	557d                	li	a0,-1
    8000378a:	bfd9                	j	80003760 <filewrite+0xf6>
    8000378c:	557d                	li	a0,-1
    8000378e:	bfc9                	j	80003760 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003790:	557d                	li	a0,-1
    80003792:	79a2                	ld	s3,40(sp)
    80003794:	b7f1                	j	80003760 <filewrite+0xf6>

0000000080003796 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003796:	7179                	addi	sp,sp,-48
    80003798:	f406                	sd	ra,40(sp)
    8000379a:	f022                	sd	s0,32(sp)
    8000379c:	ec26                	sd	s1,24(sp)
    8000379e:	e052                	sd	s4,0(sp)
    800037a0:	1800                	addi	s0,sp,48
    800037a2:	84aa                	mv	s1,a0
    800037a4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037a6:	0005b023          	sd	zero,0(a1)
    800037aa:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037ae:	c3bff0ef          	jal	800033e8 <filealloc>
    800037b2:	e088                	sd	a0,0(s1)
    800037b4:	c549                	beqz	a0,8000383e <pipealloc+0xa8>
    800037b6:	c33ff0ef          	jal	800033e8 <filealloc>
    800037ba:	00aa3023          	sd	a0,0(s4)
    800037be:	cd25                	beqz	a0,80003836 <pipealloc+0xa0>
    800037c0:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800037c2:	93dfc0ef          	jal	800000fe <kalloc>
    800037c6:	892a                	mv	s2,a0
    800037c8:	c12d                	beqz	a0,8000382a <pipealloc+0x94>
    800037ca:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800037cc:	4985                	li	s3,1
    800037ce:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037d2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037d6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037da:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037de:	00004597          	auipc	a1,0x4
    800037e2:	d8a58593          	addi	a1,a1,-630 # 80007568 <etext+0x568>
    800037e6:	034020ef          	jal	8000581a <initlock>
  (*f0)->type = FD_PIPE;
    800037ea:	609c                	ld	a5,0(s1)
    800037ec:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800037f0:	609c                	ld	a5,0(s1)
    800037f2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800037f6:	609c                	ld	a5,0(s1)
    800037f8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800037fc:	609c                	ld	a5,0(s1)
    800037fe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003802:	000a3783          	ld	a5,0(s4)
    80003806:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000380a:	000a3783          	ld	a5,0(s4)
    8000380e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003812:	000a3783          	ld	a5,0(s4)
    80003816:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000381a:	000a3783          	ld	a5,0(s4)
    8000381e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003822:	4501                	li	a0,0
    80003824:	6942                	ld	s2,16(sp)
    80003826:	69a2                	ld	s3,8(sp)
    80003828:	a01d                	j	8000384e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000382a:	6088                	ld	a0,0(s1)
    8000382c:	c119                	beqz	a0,80003832 <pipealloc+0x9c>
    8000382e:	6942                	ld	s2,16(sp)
    80003830:	a029                	j	8000383a <pipealloc+0xa4>
    80003832:	6942                	ld	s2,16(sp)
    80003834:	a029                	j	8000383e <pipealloc+0xa8>
    80003836:	6088                	ld	a0,0(s1)
    80003838:	c10d                	beqz	a0,8000385a <pipealloc+0xc4>
    fileclose(*f0);
    8000383a:	c53ff0ef          	jal	8000348c <fileclose>
  if(*f1)
    8000383e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003842:	557d                	li	a0,-1
  if(*f1)
    80003844:	c789                	beqz	a5,8000384e <pipealloc+0xb8>
    fileclose(*f1);
    80003846:	853e                	mv	a0,a5
    80003848:	c45ff0ef          	jal	8000348c <fileclose>
  return -1;
    8000384c:	557d                	li	a0,-1
}
    8000384e:	70a2                	ld	ra,40(sp)
    80003850:	7402                	ld	s0,32(sp)
    80003852:	64e2                	ld	s1,24(sp)
    80003854:	6a02                	ld	s4,0(sp)
    80003856:	6145                	addi	sp,sp,48
    80003858:	8082                	ret
  return -1;
    8000385a:	557d                	li	a0,-1
    8000385c:	bfcd                	j	8000384e <pipealloc+0xb8>

000000008000385e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000385e:	1101                	addi	sp,sp,-32
    80003860:	ec06                	sd	ra,24(sp)
    80003862:	e822                	sd	s0,16(sp)
    80003864:	e426                	sd	s1,8(sp)
    80003866:	e04a                	sd	s2,0(sp)
    80003868:	1000                	addi	s0,sp,32
    8000386a:	84aa                	mv	s1,a0
    8000386c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000386e:	02c020ef          	jal	8000589a <acquire>
  if(writable){
    80003872:	02090763          	beqz	s2,800038a0 <pipeclose+0x42>
    pi->writeopen = 0;
    80003876:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000387a:	21848513          	addi	a0,s1,536
    8000387e:	b41fd0ef          	jal	800013be <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003882:	2204b783          	ld	a5,544(s1)
    80003886:	e785                	bnez	a5,800038ae <pipeclose+0x50>
    release(&pi->lock);
    80003888:	8526                	mv	a0,s1
    8000388a:	0a8020ef          	jal	80005932 <release>
    kfree((char*)pi);
    8000388e:	8526                	mv	a0,s1
    80003890:	f8cfc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003894:	60e2                	ld	ra,24(sp)
    80003896:	6442                	ld	s0,16(sp)
    80003898:	64a2                	ld	s1,8(sp)
    8000389a:	6902                	ld	s2,0(sp)
    8000389c:	6105                	addi	sp,sp,32
    8000389e:	8082                	ret
    pi->readopen = 0;
    800038a0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038a4:	21c48513          	addi	a0,s1,540
    800038a8:	b17fd0ef          	jal	800013be <wakeup>
    800038ac:	bfd9                	j	80003882 <pipeclose+0x24>
    release(&pi->lock);
    800038ae:	8526                	mv	a0,s1
    800038b0:	082020ef          	jal	80005932 <release>
}
    800038b4:	b7c5                	j	80003894 <pipeclose+0x36>

00000000800038b6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038b6:	711d                	addi	sp,sp,-96
    800038b8:	ec86                	sd	ra,88(sp)
    800038ba:	e8a2                	sd	s0,80(sp)
    800038bc:	e4a6                	sd	s1,72(sp)
    800038be:	e0ca                	sd	s2,64(sp)
    800038c0:	fc4e                	sd	s3,56(sp)
    800038c2:	f852                	sd	s4,48(sp)
    800038c4:	f456                	sd	s5,40(sp)
    800038c6:	1080                	addi	s0,sp,96
    800038c8:	84aa                	mv	s1,a0
    800038ca:	8aae                	mv	s5,a1
    800038cc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038ce:	cacfd0ef          	jal	80000d7a <myproc>
    800038d2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038d4:	8526                	mv	a0,s1
    800038d6:	7c5010ef          	jal	8000589a <acquire>
  while(i < n){
    800038da:	0b405a63          	blez	s4,8000398e <pipewrite+0xd8>
    800038de:	f05a                	sd	s6,32(sp)
    800038e0:	ec5e                	sd	s7,24(sp)
    800038e2:	e862                	sd	s8,16(sp)
  int i = 0;
    800038e4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038e6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800038e8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800038ec:	21c48b93          	addi	s7,s1,540
    800038f0:	a81d                	j	80003926 <pipewrite+0x70>
      release(&pi->lock);
    800038f2:	8526                	mv	a0,s1
    800038f4:	03e020ef          	jal	80005932 <release>
      return -1;
    800038f8:	597d                	li	s2,-1
    800038fa:	7b02                	ld	s6,32(sp)
    800038fc:	6be2                	ld	s7,24(sp)
    800038fe:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003900:	854a                	mv	a0,s2
    80003902:	60e6                	ld	ra,88(sp)
    80003904:	6446                	ld	s0,80(sp)
    80003906:	64a6                	ld	s1,72(sp)
    80003908:	6906                	ld	s2,64(sp)
    8000390a:	79e2                	ld	s3,56(sp)
    8000390c:	7a42                	ld	s4,48(sp)
    8000390e:	7aa2                	ld	s5,40(sp)
    80003910:	6125                	addi	sp,sp,96
    80003912:	8082                	ret
      wakeup(&pi->nread);
    80003914:	8562                	mv	a0,s8
    80003916:	aa9fd0ef          	jal	800013be <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000391a:	85a6                	mv	a1,s1
    8000391c:	855e                	mv	a0,s7
    8000391e:	a55fd0ef          	jal	80001372 <sleep>
  while(i < n){
    80003922:	05495b63          	bge	s2,s4,80003978 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003926:	2204a783          	lw	a5,544(s1)
    8000392a:	d7e1                	beqz	a5,800038f2 <pipewrite+0x3c>
    8000392c:	854e                	mv	a0,s3
    8000392e:	c7dfd0ef          	jal	800015aa <killed>
    80003932:	f161                	bnez	a0,800038f2 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003934:	2184a783          	lw	a5,536(s1)
    80003938:	21c4a703          	lw	a4,540(s1)
    8000393c:	2007879b          	addiw	a5,a5,512
    80003940:	fcf70ae3          	beq	a4,a5,80003914 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003944:	4685                	li	a3,1
    80003946:	01590633          	add	a2,s2,s5
    8000394a:	faf40593          	addi	a1,s0,-81
    8000394e:	0509b503          	ld	a0,80(s3)
    80003952:	a20fd0ef          	jal	80000b72 <copyin>
    80003956:	03650e63          	beq	a0,s6,80003992 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000395a:	21c4a783          	lw	a5,540(s1)
    8000395e:	0017871b          	addiw	a4,a5,1
    80003962:	20e4ae23          	sw	a4,540(s1)
    80003966:	1ff7f793          	andi	a5,a5,511
    8000396a:	97a6                	add	a5,a5,s1
    8000396c:	faf44703          	lbu	a4,-81(s0)
    80003970:	00e78c23          	sb	a4,24(a5)
      i++;
    80003974:	2905                	addiw	s2,s2,1
    80003976:	b775                	j	80003922 <pipewrite+0x6c>
    80003978:	7b02                	ld	s6,32(sp)
    8000397a:	6be2                	ld	s7,24(sp)
    8000397c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000397e:	21848513          	addi	a0,s1,536
    80003982:	a3dfd0ef          	jal	800013be <wakeup>
  release(&pi->lock);
    80003986:	8526                	mv	a0,s1
    80003988:	7ab010ef          	jal	80005932 <release>
  return i;
    8000398c:	bf95                	j	80003900 <pipewrite+0x4a>
  int i = 0;
    8000398e:	4901                	li	s2,0
    80003990:	b7fd                	j	8000397e <pipewrite+0xc8>
    80003992:	7b02                	ld	s6,32(sp)
    80003994:	6be2                	ld	s7,24(sp)
    80003996:	6c42                	ld	s8,16(sp)
    80003998:	b7dd                	j	8000397e <pipewrite+0xc8>

000000008000399a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000399a:	715d                	addi	sp,sp,-80
    8000399c:	e486                	sd	ra,72(sp)
    8000399e:	e0a2                	sd	s0,64(sp)
    800039a0:	fc26                	sd	s1,56(sp)
    800039a2:	f84a                	sd	s2,48(sp)
    800039a4:	f44e                	sd	s3,40(sp)
    800039a6:	f052                	sd	s4,32(sp)
    800039a8:	ec56                	sd	s5,24(sp)
    800039aa:	0880                	addi	s0,sp,80
    800039ac:	84aa                	mv	s1,a0
    800039ae:	892e                	mv	s2,a1
    800039b0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039b2:	bc8fd0ef          	jal	80000d7a <myproc>
    800039b6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039b8:	8526                	mv	a0,s1
    800039ba:	6e1010ef          	jal	8000589a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039be:	2184a703          	lw	a4,536(s1)
    800039c2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039c6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039ca:	02f71563          	bne	a4,a5,800039f4 <piperead+0x5a>
    800039ce:	2244a783          	lw	a5,548(s1)
    800039d2:	cb85                	beqz	a5,80003a02 <piperead+0x68>
    if(killed(pr)){
    800039d4:	8552                	mv	a0,s4
    800039d6:	bd5fd0ef          	jal	800015aa <killed>
    800039da:	ed19                	bnez	a0,800039f8 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039dc:	85a6                	mv	a1,s1
    800039de:	854e                	mv	a0,s3
    800039e0:	993fd0ef          	jal	80001372 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039e4:	2184a703          	lw	a4,536(s1)
    800039e8:	21c4a783          	lw	a5,540(s1)
    800039ec:	fef701e3          	beq	a4,a5,800039ce <piperead+0x34>
    800039f0:	e85a                	sd	s6,16(sp)
    800039f2:	a809                	j	80003a04 <piperead+0x6a>
    800039f4:	e85a                	sd	s6,16(sp)
    800039f6:	a039                	j	80003a04 <piperead+0x6a>
      release(&pi->lock);
    800039f8:	8526                	mv	a0,s1
    800039fa:	739010ef          	jal	80005932 <release>
      return -1;
    800039fe:	59fd                	li	s3,-1
    80003a00:	a8b1                	j	80003a5c <piperead+0xc2>
    80003a02:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a04:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a06:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a08:	05505263          	blez	s5,80003a4c <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a0c:	2184a783          	lw	a5,536(s1)
    80003a10:	21c4a703          	lw	a4,540(s1)
    80003a14:	02f70c63          	beq	a4,a5,80003a4c <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a18:	0017871b          	addiw	a4,a5,1
    80003a1c:	20e4ac23          	sw	a4,536(s1)
    80003a20:	1ff7f793          	andi	a5,a5,511
    80003a24:	97a6                	add	a5,a5,s1
    80003a26:	0187c783          	lbu	a5,24(a5)
    80003a2a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a2e:	4685                	li	a3,1
    80003a30:	fbf40613          	addi	a2,s0,-65
    80003a34:	85ca                	mv	a1,s2
    80003a36:	050a3503          	ld	a0,80(s4)
    80003a3a:	854fd0ef          	jal	80000a8e <copyout>
    80003a3e:	01650763          	beq	a0,s6,80003a4c <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a42:	2985                	addiw	s3,s3,1
    80003a44:	0905                	addi	s2,s2,1
    80003a46:	fd3a93e3          	bne	s5,s3,80003a0c <piperead+0x72>
    80003a4a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a4c:	21c48513          	addi	a0,s1,540
    80003a50:	96ffd0ef          	jal	800013be <wakeup>
  release(&pi->lock);
    80003a54:	8526                	mv	a0,s1
    80003a56:	6dd010ef          	jal	80005932 <release>
    80003a5a:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a5c:	854e                	mv	a0,s3
    80003a5e:	60a6                	ld	ra,72(sp)
    80003a60:	6406                	ld	s0,64(sp)
    80003a62:	74e2                	ld	s1,56(sp)
    80003a64:	7942                	ld	s2,48(sp)
    80003a66:	79a2                	ld	s3,40(sp)
    80003a68:	7a02                	ld	s4,32(sp)
    80003a6a:	6ae2                	ld	s5,24(sp)
    80003a6c:	6161                	addi	sp,sp,80
    80003a6e:	8082                	ret

0000000080003a70 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003a70:	1141                	addi	sp,sp,-16
    80003a72:	e422                	sd	s0,8(sp)
    80003a74:	0800                	addi	s0,sp,16
    80003a76:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a78:	8905                	andi	a0,a0,1
    80003a7a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003a7c:	8b89                	andi	a5,a5,2
    80003a7e:	c399                	beqz	a5,80003a84 <flags2perm+0x14>
      perm |= PTE_W;
    80003a80:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a84:	6422                	ld	s0,8(sp)
    80003a86:	0141                	addi	sp,sp,16
    80003a88:	8082                	ret

0000000080003a8a <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003a8a:	df010113          	addi	sp,sp,-528
    80003a8e:	20113423          	sd	ra,520(sp)
    80003a92:	20813023          	sd	s0,512(sp)
    80003a96:	ffa6                	sd	s1,504(sp)
    80003a98:	fbca                	sd	s2,496(sp)
    80003a9a:	0c00                	addi	s0,sp,528
    80003a9c:	892a                	mv	s2,a0
    80003a9e:	dea43c23          	sd	a0,-520(s0)
    80003aa2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003aa6:	ad4fd0ef          	jal	80000d7a <myproc>
    80003aaa:	84aa                	mv	s1,a0

  begin_op();
    80003aac:	dd4ff0ef          	jal	80003080 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	bfaff0ef          	jal	80002eac <namei>
    80003ab6:	c931                	beqz	a0,80003b0a <kexec+0x80>
    80003ab8:	f3d2                	sd	s4,480(sp)
    80003aba:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003abc:	bdbfe0ef          	jal	80002696 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003ac0:	04000713          	li	a4,64
    80003ac4:	4681                	li	a3,0
    80003ac6:	e5040613          	addi	a2,s0,-432
    80003aca:	4581                	li	a1,0
    80003acc:	8552                	mv	a0,s4
    80003ace:	f59fe0ef          	jal	80002a26 <readi>
    80003ad2:	04000793          	li	a5,64
    80003ad6:	00f51a63          	bne	a0,a5,80003aea <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003ada:	e5042703          	lw	a4,-432(s0)
    80003ade:	464c47b7          	lui	a5,0x464c4
    80003ae2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003ae6:	02f70663          	beq	a4,a5,80003b12 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003aea:	8552                	mv	a0,s4
    80003aec:	db5fe0ef          	jal	800028a0 <iunlockput>
    end_op();
    80003af0:	dfaff0ef          	jal	800030ea <end_op>
  }
  return -1;
    80003af4:	557d                	li	a0,-1
    80003af6:	7a1e                	ld	s4,480(sp)
}
    80003af8:	20813083          	ld	ra,520(sp)
    80003afc:	20013403          	ld	s0,512(sp)
    80003b00:	74fe                	ld	s1,504(sp)
    80003b02:	795e                	ld	s2,496(sp)
    80003b04:	21010113          	addi	sp,sp,528
    80003b08:	8082                	ret
    end_op();
    80003b0a:	de0ff0ef          	jal	800030ea <end_op>
    return -1;
    80003b0e:	557d                	li	a0,-1
    80003b10:	b7e5                	j	80003af8 <kexec+0x6e>
    80003b12:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b14:	8526                	mv	a0,s1
    80003b16:	b6afd0ef          	jal	80000e80 <proc_pagetable>
    80003b1a:	8b2a                	mv	s6,a0
    80003b1c:	2c050b63          	beqz	a0,80003df2 <kexec+0x368>
    80003b20:	f7ce                	sd	s3,488(sp)
    80003b22:	efd6                	sd	s5,472(sp)
    80003b24:	e7de                	sd	s7,456(sp)
    80003b26:	e3e2                	sd	s8,448(sp)
    80003b28:	ff66                	sd	s9,440(sp)
    80003b2a:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b2c:	e7042d03          	lw	s10,-400(s0)
    80003b30:	e8845783          	lhu	a5,-376(s0)
    80003b34:	12078963          	beqz	a5,80003c66 <kexec+0x1dc>
    80003b38:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b3a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b3c:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b3e:	6c85                	lui	s9,0x1
    80003b40:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b44:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b48:	6a85                	lui	s5,0x1
    80003b4a:	a085                	j	80003baa <kexec+0x120>
      panic("loadseg: address should exist");
    80003b4c:	00004517          	auipc	a0,0x4
    80003b50:	a2450513          	addi	a0,a0,-1500 # 80007570 <etext+0x570>
    80003b54:	28b010ef          	jal	800055de <panic>
    if(sz - i < PGSIZE)
    80003b58:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b5a:	8726                	mv	a4,s1
    80003b5c:	012c06bb          	addw	a3,s8,s2
    80003b60:	4581                	li	a1,0
    80003b62:	8552                	mv	a0,s4
    80003b64:	ec3fe0ef          	jal	80002a26 <readi>
    80003b68:	2501                	sext.w	a0,a0
    80003b6a:	24a49a63          	bne	s1,a0,80003dbe <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003b6e:	012a893b          	addw	s2,s5,s2
    80003b72:	03397363          	bgeu	s2,s3,80003b98 <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b76:	02091593          	slli	a1,s2,0x20
    80003b7a:	9181                	srli	a1,a1,0x20
    80003b7c:	95de                	add	a1,a1,s7
    80003b7e:	855a                	mv	a0,s6
    80003b80:	8ddfc0ef          	jal	8000045c <walkaddr>
    80003b84:	862a                	mv	a2,a0
    if(pa == 0)
    80003b86:	d179                	beqz	a0,80003b4c <kexec+0xc2>
    if(sz - i < PGSIZE)
    80003b88:	412984bb          	subw	s1,s3,s2
    80003b8c:	0004879b          	sext.w	a5,s1
    80003b90:	fcfcf4e3          	bgeu	s9,a5,80003b58 <kexec+0xce>
    80003b94:	84d6                	mv	s1,s5
    80003b96:	b7c9                	j	80003b58 <kexec+0xce>
    sz = sz1;
    80003b98:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b9c:	2d85                	addiw	s11,s11,1
    80003b9e:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003ba2:	e8845783          	lhu	a5,-376(s0)
    80003ba6:	08fdd063          	bge	s11,a5,80003c26 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003baa:	2d01                	sext.w	s10,s10
    80003bac:	03800713          	li	a4,56
    80003bb0:	86ea                	mv	a3,s10
    80003bb2:	e1840613          	addi	a2,s0,-488
    80003bb6:	4581                	li	a1,0
    80003bb8:	8552                	mv	a0,s4
    80003bba:	e6dfe0ef          	jal	80002a26 <readi>
    80003bbe:	03800793          	li	a5,56
    80003bc2:	1cf51663          	bne	a0,a5,80003d8e <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003bc6:	e1842783          	lw	a5,-488(s0)
    80003bca:	4705                	li	a4,1
    80003bcc:	fce798e3          	bne	a5,a4,80003b9c <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80003bd0:	e4043483          	ld	s1,-448(s0)
    80003bd4:	e3843783          	ld	a5,-456(s0)
    80003bd8:	1af4ef63          	bltu	s1,a5,80003d96 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003bdc:	e2843783          	ld	a5,-472(s0)
    80003be0:	94be                	add	s1,s1,a5
    80003be2:	1af4ee63          	bltu	s1,a5,80003d9e <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003be6:	df043703          	ld	a4,-528(s0)
    80003bea:	8ff9                	and	a5,a5,a4
    80003bec:	1a079d63          	bnez	a5,80003da6 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003bf0:	e1c42503          	lw	a0,-484(s0)
    80003bf4:	e7dff0ef          	jal	80003a70 <flags2perm>
    80003bf8:	86aa                	mv	a3,a0
    80003bfa:	8626                	mv	a2,s1
    80003bfc:	85ca                	mv	a1,s2
    80003bfe:	855a                	mv	a0,s6
    80003c00:	b35fc0ef          	jal	80000734 <uvmalloc>
    80003c04:	e0a43423          	sd	a0,-504(s0)
    80003c08:	1a050363          	beqz	a0,80003dae <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c0c:	e2843b83          	ld	s7,-472(s0)
    80003c10:	e2042c03          	lw	s8,-480(s0)
    80003c14:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c18:	00098463          	beqz	s3,80003c20 <kexec+0x196>
    80003c1c:	4901                	li	s2,0
    80003c1e:	bfa1                	j	80003b76 <kexec+0xec>
    sz = sz1;
    80003c20:	e0843903          	ld	s2,-504(s0)
    80003c24:	bfa5                	j	80003b9c <kexec+0x112>
    80003c26:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003c28:	8552                	mv	a0,s4
    80003c2a:	c77fe0ef          	jal	800028a0 <iunlockput>
  end_op();
    80003c2e:	cbcff0ef          	jal	800030ea <end_op>
  p = myproc();
    80003c32:	948fd0ef          	jal	80000d7a <myproc>
    80003c36:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c38:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c3c:	6985                	lui	s3,0x1
    80003c3e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c40:	99ca                	add	s3,s3,s2
    80003c42:	77fd                	lui	a5,0xfffff
    80003c44:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c48:	4691                	li	a3,4
    80003c4a:	660d                	lui	a2,0x3
    80003c4c:	964e                	add	a2,a2,s3
    80003c4e:	85ce                	mv	a1,s3
    80003c50:	855a                	mv	a0,s6
    80003c52:	ae3fc0ef          	jal	80000734 <uvmalloc>
    80003c56:	892a                	mv	s2,a0
    80003c58:	e0a43423          	sd	a0,-504(s0)
    80003c5c:	e519                	bnez	a0,80003c6a <kexec+0x1e0>
  if(pagetable)
    80003c5e:	e1343423          	sd	s3,-504(s0)
    80003c62:	4a01                	li	s4,0
    80003c64:	aab1                	j	80003dc0 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c66:	4901                	li	s2,0
    80003c68:	b7c1                	j	80003c28 <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c6a:	75f5                	lui	a1,0xffffd
    80003c6c:	95aa                	add	a1,a1,a0
    80003c6e:	855a                	mv	a0,s6
    80003c70:	c9bfc0ef          	jal	8000090a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c74:	7bf9                	lui	s7,0xffffe
    80003c76:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c78:	e0043783          	ld	a5,-512(s0)
    80003c7c:	6388                	ld	a0,0(a5)
    80003c7e:	cd39                	beqz	a0,80003cdc <kexec+0x252>
    80003c80:	e9040993          	addi	s3,s0,-368
    80003c84:	f9040c13          	addi	s8,s0,-112
    80003c88:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c8a:	e34fc0ef          	jal	800002be <strlen>
    80003c8e:	0015079b          	addiw	a5,a0,1
    80003c92:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c96:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c9a:	11796e63          	bltu	s2,s7,80003db6 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c9e:	e0043d03          	ld	s10,-512(s0)
    80003ca2:	000d3a03          	ld	s4,0(s10)
    80003ca6:	8552                	mv	a0,s4
    80003ca8:	e16fc0ef          	jal	800002be <strlen>
    80003cac:	0015069b          	addiw	a3,a0,1
    80003cb0:	8652                	mv	a2,s4
    80003cb2:	85ca                	mv	a1,s2
    80003cb4:	855a                	mv	a0,s6
    80003cb6:	dd9fc0ef          	jal	80000a8e <copyout>
    80003cba:	10054063          	bltz	a0,80003dba <kexec+0x330>
    ustack[argc] = sp;
    80003cbe:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003cc2:	0485                	addi	s1,s1,1
    80003cc4:	008d0793          	addi	a5,s10,8
    80003cc8:	e0f43023          	sd	a5,-512(s0)
    80003ccc:	008d3503          	ld	a0,8(s10)
    80003cd0:	c909                	beqz	a0,80003ce2 <kexec+0x258>
    if(argc >= MAXARG)
    80003cd2:	09a1                	addi	s3,s3,8
    80003cd4:	fb899be3          	bne	s3,s8,80003c8a <kexec+0x200>
  ip = 0;
    80003cd8:	4a01                	li	s4,0
    80003cda:	a0dd                	j	80003dc0 <kexec+0x336>
  sp = sz;
    80003cdc:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003ce0:	4481                	li	s1,0
  ustack[argc] = 0;
    80003ce2:	00349793          	slli	a5,s1,0x3
    80003ce6:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdba78>
    80003cea:	97a2                	add	a5,a5,s0
    80003cec:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003cf0:	00148693          	addi	a3,s1,1
    80003cf4:	068e                	slli	a3,a3,0x3
    80003cf6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003cfa:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003cfe:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003d02:	f5796ee3          	bltu	s2,s7,80003c5e <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d06:	e9040613          	addi	a2,s0,-368
    80003d0a:	85ca                	mv	a1,s2
    80003d0c:	855a                	mv	a0,s6
    80003d0e:	d81fc0ef          	jal	80000a8e <copyout>
    80003d12:	0e054263          	bltz	a0,80003df6 <kexec+0x36c>
  p->trapframe->a1 = sp;
    80003d16:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d1a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d1e:	df843783          	ld	a5,-520(s0)
    80003d22:	0007c703          	lbu	a4,0(a5)
    80003d26:	cf11                	beqz	a4,80003d42 <kexec+0x2b8>
    80003d28:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d2a:	02f00693          	li	a3,47
    80003d2e:	a039                	j	80003d3c <kexec+0x2b2>
      last = s+1;
    80003d30:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d34:	0785                	addi	a5,a5,1
    80003d36:	fff7c703          	lbu	a4,-1(a5)
    80003d3a:	c701                	beqz	a4,80003d42 <kexec+0x2b8>
    if(*s == '/')
    80003d3c:	fed71ce3          	bne	a4,a3,80003d34 <kexec+0x2aa>
    80003d40:	bfc5                	j	80003d30 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d42:	4641                	li	a2,16
    80003d44:	df843583          	ld	a1,-520(s0)
    80003d48:	158a8513          	addi	a0,s5,344
    80003d4c:	d40fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003d50:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d54:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d58:	e0843783          	ld	a5,-504(s0)
    80003d5c:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d60:	058ab783          	ld	a5,88(s5)
    80003d64:	e6843703          	ld	a4,-408(s0)
    80003d68:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d6a:	058ab783          	ld	a5,88(s5)
    80003d6e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d72:	85e6                	mv	a1,s9
    80003d74:	990fd0ef          	jal	80000f04 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d78:	0004851b          	sext.w	a0,s1
    80003d7c:	79be                	ld	s3,488(sp)
    80003d7e:	7a1e                	ld	s4,480(sp)
    80003d80:	6afe                	ld	s5,472(sp)
    80003d82:	6b5e                	ld	s6,464(sp)
    80003d84:	6bbe                	ld	s7,456(sp)
    80003d86:	6c1e                	ld	s8,448(sp)
    80003d88:	7cfa                	ld	s9,440(sp)
    80003d8a:	7d5a                	ld	s10,432(sp)
    80003d8c:	b3b5                	j	80003af8 <kexec+0x6e>
    80003d8e:	e1243423          	sd	s2,-504(s0)
    80003d92:	7dba                	ld	s11,424(sp)
    80003d94:	a035                	j	80003dc0 <kexec+0x336>
    80003d96:	e1243423          	sd	s2,-504(s0)
    80003d9a:	7dba                	ld	s11,424(sp)
    80003d9c:	a015                	j	80003dc0 <kexec+0x336>
    80003d9e:	e1243423          	sd	s2,-504(s0)
    80003da2:	7dba                	ld	s11,424(sp)
    80003da4:	a831                	j	80003dc0 <kexec+0x336>
    80003da6:	e1243423          	sd	s2,-504(s0)
    80003daa:	7dba                	ld	s11,424(sp)
    80003dac:	a811                	j	80003dc0 <kexec+0x336>
    80003dae:	e1243423          	sd	s2,-504(s0)
    80003db2:	7dba                	ld	s11,424(sp)
    80003db4:	a031                	j	80003dc0 <kexec+0x336>
  ip = 0;
    80003db6:	4a01                	li	s4,0
    80003db8:	a021                	j	80003dc0 <kexec+0x336>
    80003dba:	4a01                	li	s4,0
  if(pagetable)
    80003dbc:	a011                	j	80003dc0 <kexec+0x336>
    80003dbe:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003dc0:	e0843583          	ld	a1,-504(s0)
    80003dc4:	855a                	mv	a0,s6
    80003dc6:	93efd0ef          	jal	80000f04 <proc_freepagetable>
  return -1;
    80003dca:	557d                	li	a0,-1
  if(ip){
    80003dcc:	000a1b63          	bnez	s4,80003de2 <kexec+0x358>
    80003dd0:	79be                	ld	s3,488(sp)
    80003dd2:	7a1e                	ld	s4,480(sp)
    80003dd4:	6afe                	ld	s5,472(sp)
    80003dd6:	6b5e                	ld	s6,464(sp)
    80003dd8:	6bbe                	ld	s7,456(sp)
    80003dda:	6c1e                	ld	s8,448(sp)
    80003ddc:	7cfa                	ld	s9,440(sp)
    80003dde:	7d5a                	ld	s10,432(sp)
    80003de0:	bb21                	j	80003af8 <kexec+0x6e>
    80003de2:	79be                	ld	s3,488(sp)
    80003de4:	6afe                	ld	s5,472(sp)
    80003de6:	6b5e                	ld	s6,464(sp)
    80003de8:	6bbe                	ld	s7,456(sp)
    80003dea:	6c1e                	ld	s8,448(sp)
    80003dec:	7cfa                	ld	s9,440(sp)
    80003dee:	7d5a                	ld	s10,432(sp)
    80003df0:	b9ed                	j	80003aea <kexec+0x60>
    80003df2:	6b5e                	ld	s6,464(sp)
    80003df4:	b9dd                	j	80003aea <kexec+0x60>
  sz = sz1;
    80003df6:	e0843983          	ld	s3,-504(s0)
    80003dfa:	b595                	j	80003c5e <kexec+0x1d4>

0000000080003dfc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003dfc:	7179                	addi	sp,sp,-48
    80003dfe:	f406                	sd	ra,40(sp)
    80003e00:	f022                	sd	s0,32(sp)
    80003e02:	ec26                	sd	s1,24(sp)
    80003e04:	e84a                	sd	s2,16(sp)
    80003e06:	1800                	addi	s0,sp,48
    80003e08:	892e                	mv	s2,a1
    80003e0a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e0c:	fdc40593          	addi	a1,s0,-36
    80003e10:	e67fd0ef          	jal	80001c76 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e14:	fdc42703          	lw	a4,-36(s0)
    80003e18:	47bd                	li	a5,15
    80003e1a:	02e7e963          	bltu	a5,a4,80003e4c <argfd+0x50>
    80003e1e:	f5dfc0ef          	jal	80000d7a <myproc>
    80003e22:	fdc42703          	lw	a4,-36(s0)
    80003e26:	01a70793          	addi	a5,a4,26
    80003e2a:	078e                	slli	a5,a5,0x3
    80003e2c:	953e                	add	a0,a0,a5
    80003e2e:	611c                	ld	a5,0(a0)
    80003e30:	c385                	beqz	a5,80003e50 <argfd+0x54>
    return -1;
  if(pfd)
    80003e32:	00090463          	beqz	s2,80003e3a <argfd+0x3e>
    *pfd = fd;
    80003e36:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e3a:	4501                	li	a0,0
  if(pf)
    80003e3c:	c091                	beqz	s1,80003e40 <argfd+0x44>
    *pf = f;
    80003e3e:	e09c                	sd	a5,0(s1)
}
    80003e40:	70a2                	ld	ra,40(sp)
    80003e42:	7402                	ld	s0,32(sp)
    80003e44:	64e2                	ld	s1,24(sp)
    80003e46:	6942                	ld	s2,16(sp)
    80003e48:	6145                	addi	sp,sp,48
    80003e4a:	8082                	ret
    return -1;
    80003e4c:	557d                	li	a0,-1
    80003e4e:	bfcd                	j	80003e40 <argfd+0x44>
    80003e50:	557d                	li	a0,-1
    80003e52:	b7fd                	j	80003e40 <argfd+0x44>

0000000080003e54 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e54:	1101                	addi	sp,sp,-32
    80003e56:	ec06                	sd	ra,24(sp)
    80003e58:	e822                	sd	s0,16(sp)
    80003e5a:	e426                	sd	s1,8(sp)
    80003e5c:	1000                	addi	s0,sp,32
    80003e5e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e60:	f1bfc0ef          	jal	80000d7a <myproc>
    80003e64:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e66:	0d050793          	addi	a5,a0,208
    80003e6a:	4501                	li	a0,0
    80003e6c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e6e:	6398                	ld	a4,0(a5)
    80003e70:	cb19                	beqz	a4,80003e86 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e72:	2505                	addiw	a0,a0,1
    80003e74:	07a1                	addi	a5,a5,8
    80003e76:	fed51ce3          	bne	a0,a3,80003e6e <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e7a:	557d                	li	a0,-1
}
    80003e7c:	60e2                	ld	ra,24(sp)
    80003e7e:	6442                	ld	s0,16(sp)
    80003e80:	64a2                	ld	s1,8(sp)
    80003e82:	6105                	addi	sp,sp,32
    80003e84:	8082                	ret
      p->ofile[fd] = f;
    80003e86:	01a50793          	addi	a5,a0,26
    80003e8a:	078e                	slli	a5,a5,0x3
    80003e8c:	963e                	add	a2,a2,a5
    80003e8e:	e204                	sd	s1,0(a2)
      return fd;
    80003e90:	b7f5                	j	80003e7c <fdalloc+0x28>

0000000080003e92 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e92:	715d                	addi	sp,sp,-80
    80003e94:	e486                	sd	ra,72(sp)
    80003e96:	e0a2                	sd	s0,64(sp)
    80003e98:	fc26                	sd	s1,56(sp)
    80003e9a:	f84a                	sd	s2,48(sp)
    80003e9c:	f44e                	sd	s3,40(sp)
    80003e9e:	ec56                	sd	s5,24(sp)
    80003ea0:	e85a                	sd	s6,16(sp)
    80003ea2:	0880                	addi	s0,sp,80
    80003ea4:	8b2e                	mv	s6,a1
    80003ea6:	89b2                	mv	s3,a2
    80003ea8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003eaa:	fb040593          	addi	a1,s0,-80
    80003eae:	818ff0ef          	jal	80002ec6 <nameiparent>
    80003eb2:	84aa                	mv	s1,a0
    80003eb4:	10050a63          	beqz	a0,80003fc8 <create+0x136>
    return 0;

  ilock(dp);
    80003eb8:	fdefe0ef          	jal	80002696 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ebc:	4601                	li	a2,0
    80003ebe:	fb040593          	addi	a1,s0,-80
    80003ec2:	8526                	mv	a0,s1
    80003ec4:	d83fe0ef          	jal	80002c46 <dirlookup>
    80003ec8:	8aaa                	mv	s5,a0
    80003eca:	c129                	beqz	a0,80003f0c <create+0x7a>
    iunlockput(dp);
    80003ecc:	8526                	mv	a0,s1
    80003ece:	9d3fe0ef          	jal	800028a0 <iunlockput>
    ilock(ip);
    80003ed2:	8556                	mv	a0,s5
    80003ed4:	fc2fe0ef          	jal	80002696 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003ed8:	4789                	li	a5,2
    80003eda:	02fb1463          	bne	s6,a5,80003f02 <create+0x70>
    80003ede:	044ad783          	lhu	a5,68(s5)
    80003ee2:	37f9                	addiw	a5,a5,-2
    80003ee4:	17c2                	slli	a5,a5,0x30
    80003ee6:	93c1                	srli	a5,a5,0x30
    80003ee8:	4705                	li	a4,1
    80003eea:	00f76c63          	bltu	a4,a5,80003f02 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003eee:	8556                	mv	a0,s5
    80003ef0:	60a6                	ld	ra,72(sp)
    80003ef2:	6406                	ld	s0,64(sp)
    80003ef4:	74e2                	ld	s1,56(sp)
    80003ef6:	7942                	ld	s2,48(sp)
    80003ef8:	79a2                	ld	s3,40(sp)
    80003efa:	6ae2                	ld	s5,24(sp)
    80003efc:	6b42                	ld	s6,16(sp)
    80003efe:	6161                	addi	sp,sp,80
    80003f00:	8082                	ret
    iunlockput(ip);
    80003f02:	8556                	mv	a0,s5
    80003f04:	99dfe0ef          	jal	800028a0 <iunlockput>
    return 0;
    80003f08:	4a81                	li	s5,0
    80003f0a:	b7d5                	j	80003eee <create+0x5c>
    80003f0c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f0e:	85da                	mv	a1,s6
    80003f10:	4088                	lw	a0,0(s1)
    80003f12:	e14fe0ef          	jal	80002526 <ialloc>
    80003f16:	8a2a                	mv	s4,a0
    80003f18:	cd15                	beqz	a0,80003f54 <create+0xc2>
  ilock(ip);
    80003f1a:	f7cfe0ef          	jal	80002696 <ilock>
  ip->major = major;
    80003f1e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f22:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f26:	4905                	li	s2,1
    80003f28:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f2c:	8552                	mv	a0,s4
    80003f2e:	eb4fe0ef          	jal	800025e2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f32:	032b0763          	beq	s6,s2,80003f60 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f36:	004a2603          	lw	a2,4(s4)
    80003f3a:	fb040593          	addi	a1,s0,-80
    80003f3e:	8526                	mv	a0,s1
    80003f40:	ed3fe0ef          	jal	80002e12 <dirlink>
    80003f44:	06054563          	bltz	a0,80003fae <create+0x11c>
  iunlockput(dp);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	957fe0ef          	jal	800028a0 <iunlockput>
  return ip;
    80003f4e:	8ad2                	mv	s5,s4
    80003f50:	7a02                	ld	s4,32(sp)
    80003f52:	bf71                	j	80003eee <create+0x5c>
    iunlockput(dp);
    80003f54:	8526                	mv	a0,s1
    80003f56:	94bfe0ef          	jal	800028a0 <iunlockput>
    return 0;
    80003f5a:	8ad2                	mv	s5,s4
    80003f5c:	7a02                	ld	s4,32(sp)
    80003f5e:	bf41                	j	80003eee <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f60:	004a2603          	lw	a2,4(s4)
    80003f64:	00003597          	auipc	a1,0x3
    80003f68:	62c58593          	addi	a1,a1,1580 # 80007590 <etext+0x590>
    80003f6c:	8552                	mv	a0,s4
    80003f6e:	ea5fe0ef          	jal	80002e12 <dirlink>
    80003f72:	02054e63          	bltz	a0,80003fae <create+0x11c>
    80003f76:	40d0                	lw	a2,4(s1)
    80003f78:	00003597          	auipc	a1,0x3
    80003f7c:	62058593          	addi	a1,a1,1568 # 80007598 <etext+0x598>
    80003f80:	8552                	mv	a0,s4
    80003f82:	e91fe0ef          	jal	80002e12 <dirlink>
    80003f86:	02054463          	bltz	a0,80003fae <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f8a:	004a2603          	lw	a2,4(s4)
    80003f8e:	fb040593          	addi	a1,s0,-80
    80003f92:	8526                	mv	a0,s1
    80003f94:	e7ffe0ef          	jal	80002e12 <dirlink>
    80003f98:	00054b63          	bltz	a0,80003fae <create+0x11c>
    dp->nlink++;  // for ".."
    80003f9c:	04a4d783          	lhu	a5,74(s1)
    80003fa0:	2785                	addiw	a5,a5,1
    80003fa2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	e3afe0ef          	jal	800025e2 <iupdate>
    80003fac:	bf71                	j	80003f48 <create+0xb6>
  ip->nlink = 0;
    80003fae:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003fb2:	8552                	mv	a0,s4
    80003fb4:	e2efe0ef          	jal	800025e2 <iupdate>
  iunlockput(ip);
    80003fb8:	8552                	mv	a0,s4
    80003fba:	8e7fe0ef          	jal	800028a0 <iunlockput>
  iunlockput(dp);
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	8e1fe0ef          	jal	800028a0 <iunlockput>
  return 0;
    80003fc4:	7a02                	ld	s4,32(sp)
    80003fc6:	b725                	j	80003eee <create+0x5c>
    return 0;
    80003fc8:	8aaa                	mv	s5,a0
    80003fca:	b715                	j	80003eee <create+0x5c>

0000000080003fcc <sys_dup>:
{
    80003fcc:	7179                	addi	sp,sp,-48
    80003fce:	f406                	sd	ra,40(sp)
    80003fd0:	f022                	sd	s0,32(sp)
    80003fd2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003fd4:	fd840613          	addi	a2,s0,-40
    80003fd8:	4581                	li	a1,0
    80003fda:	4501                	li	a0,0
    80003fdc:	e21ff0ef          	jal	80003dfc <argfd>
    return -1;
    80003fe0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003fe2:	02054363          	bltz	a0,80004008 <sys_dup+0x3c>
    80003fe6:	ec26                	sd	s1,24(sp)
    80003fe8:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003fea:	fd843903          	ld	s2,-40(s0)
    80003fee:	854a                	mv	a0,s2
    80003ff0:	e65ff0ef          	jal	80003e54 <fdalloc>
    80003ff4:	84aa                	mv	s1,a0
    return -1;
    80003ff6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003ff8:	00054d63          	bltz	a0,80004012 <sys_dup+0x46>
  filedup(f);
    80003ffc:	854a                	mv	a0,s2
    80003ffe:	c48ff0ef          	jal	80003446 <filedup>
  return fd;
    80004002:	87a6                	mv	a5,s1
    80004004:	64e2                	ld	s1,24(sp)
    80004006:	6942                	ld	s2,16(sp)
}
    80004008:	853e                	mv	a0,a5
    8000400a:	70a2                	ld	ra,40(sp)
    8000400c:	7402                	ld	s0,32(sp)
    8000400e:	6145                	addi	sp,sp,48
    80004010:	8082                	ret
    80004012:	64e2                	ld	s1,24(sp)
    80004014:	6942                	ld	s2,16(sp)
    80004016:	bfcd                	j	80004008 <sys_dup+0x3c>

0000000080004018 <sys_read>:
{
    80004018:	7179                	addi	sp,sp,-48
    8000401a:	f406                	sd	ra,40(sp)
    8000401c:	f022                	sd	s0,32(sp)
    8000401e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004020:	fd840593          	addi	a1,s0,-40
    80004024:	4505                	li	a0,1
    80004026:	c6dfd0ef          	jal	80001c92 <argaddr>
  argint(2, &n);
    8000402a:	fe440593          	addi	a1,s0,-28
    8000402e:	4509                	li	a0,2
    80004030:	c47fd0ef          	jal	80001c76 <argint>
  if(argfd(0, 0, &f) < 0)
    80004034:	fe840613          	addi	a2,s0,-24
    80004038:	4581                	li	a1,0
    8000403a:	4501                	li	a0,0
    8000403c:	dc1ff0ef          	jal	80003dfc <argfd>
    80004040:	87aa                	mv	a5,a0
    return -1;
    80004042:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004044:	0007ca63          	bltz	a5,80004058 <sys_read+0x40>
  return fileread(f, p, n);
    80004048:	fe442603          	lw	a2,-28(s0)
    8000404c:	fd843583          	ld	a1,-40(s0)
    80004050:	fe843503          	ld	a0,-24(s0)
    80004054:	d58ff0ef          	jal	800035ac <fileread>
}
    80004058:	70a2                	ld	ra,40(sp)
    8000405a:	7402                	ld	s0,32(sp)
    8000405c:	6145                	addi	sp,sp,48
    8000405e:	8082                	ret

0000000080004060 <sys_write>:
{
    80004060:	7179                	addi	sp,sp,-48
    80004062:	f406                	sd	ra,40(sp)
    80004064:	f022                	sd	s0,32(sp)
    80004066:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004068:	fd840593          	addi	a1,s0,-40
    8000406c:	4505                	li	a0,1
    8000406e:	c25fd0ef          	jal	80001c92 <argaddr>
  argint(2, &n);
    80004072:	fe440593          	addi	a1,s0,-28
    80004076:	4509                	li	a0,2
    80004078:	bfffd0ef          	jal	80001c76 <argint>
  if(argfd(0, 0, &f) < 0)
    8000407c:	fe840613          	addi	a2,s0,-24
    80004080:	4581                	li	a1,0
    80004082:	4501                	li	a0,0
    80004084:	d79ff0ef          	jal	80003dfc <argfd>
    80004088:	87aa                	mv	a5,a0
    return -1;
    8000408a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000408c:	0007ca63          	bltz	a5,800040a0 <sys_write+0x40>
  return filewrite(f, p, n);
    80004090:	fe442603          	lw	a2,-28(s0)
    80004094:	fd843583          	ld	a1,-40(s0)
    80004098:	fe843503          	ld	a0,-24(s0)
    8000409c:	dceff0ef          	jal	8000366a <filewrite>
}
    800040a0:	70a2                	ld	ra,40(sp)
    800040a2:	7402                	ld	s0,32(sp)
    800040a4:	6145                	addi	sp,sp,48
    800040a6:	8082                	ret

00000000800040a8 <sys_close>:
{
    800040a8:	1101                	addi	sp,sp,-32
    800040aa:	ec06                	sd	ra,24(sp)
    800040ac:	e822                	sd	s0,16(sp)
    800040ae:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800040b0:	fe040613          	addi	a2,s0,-32
    800040b4:	fec40593          	addi	a1,s0,-20
    800040b8:	4501                	li	a0,0
    800040ba:	d43ff0ef          	jal	80003dfc <argfd>
    return -1;
    800040be:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800040c0:	02054063          	bltz	a0,800040e0 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800040c4:	cb7fc0ef          	jal	80000d7a <myproc>
    800040c8:	fec42783          	lw	a5,-20(s0)
    800040cc:	07e9                	addi	a5,a5,26
    800040ce:	078e                	slli	a5,a5,0x3
    800040d0:	953e                	add	a0,a0,a5
    800040d2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800040d6:	fe043503          	ld	a0,-32(s0)
    800040da:	bb2ff0ef          	jal	8000348c <fileclose>
  return 0;
    800040de:	4781                	li	a5,0
}
    800040e0:	853e                	mv	a0,a5
    800040e2:	60e2                	ld	ra,24(sp)
    800040e4:	6442                	ld	s0,16(sp)
    800040e6:	6105                	addi	sp,sp,32
    800040e8:	8082                	ret

00000000800040ea <sys_fstat>:
{
    800040ea:	1101                	addi	sp,sp,-32
    800040ec:	ec06                	sd	ra,24(sp)
    800040ee:	e822                	sd	s0,16(sp)
    800040f0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800040f2:	fe040593          	addi	a1,s0,-32
    800040f6:	4505                	li	a0,1
    800040f8:	b9bfd0ef          	jal	80001c92 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800040fc:	fe840613          	addi	a2,s0,-24
    80004100:	4581                	li	a1,0
    80004102:	4501                	li	a0,0
    80004104:	cf9ff0ef          	jal	80003dfc <argfd>
    80004108:	87aa                	mv	a5,a0
    return -1;
    8000410a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000410c:	0007c863          	bltz	a5,8000411c <sys_fstat+0x32>
  return filestat(f, st);
    80004110:	fe043583          	ld	a1,-32(s0)
    80004114:	fe843503          	ld	a0,-24(s0)
    80004118:	c36ff0ef          	jal	8000354e <filestat>
}
    8000411c:	60e2                	ld	ra,24(sp)
    8000411e:	6442                	ld	s0,16(sp)
    80004120:	6105                	addi	sp,sp,32
    80004122:	8082                	ret

0000000080004124 <sys_link>:
{
    80004124:	7169                	addi	sp,sp,-304
    80004126:	f606                	sd	ra,296(sp)
    80004128:	f222                	sd	s0,288(sp)
    8000412a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000412c:	08000613          	li	a2,128
    80004130:	ed040593          	addi	a1,s0,-304
    80004134:	4501                	li	a0,0
    80004136:	b79fd0ef          	jal	80001cae <argstr>
    return -1;
    8000413a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000413c:	0c054e63          	bltz	a0,80004218 <sys_link+0xf4>
    80004140:	08000613          	li	a2,128
    80004144:	f5040593          	addi	a1,s0,-176
    80004148:	4505                	li	a0,1
    8000414a:	b65fd0ef          	jal	80001cae <argstr>
    return -1;
    8000414e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004150:	0c054463          	bltz	a0,80004218 <sys_link+0xf4>
    80004154:	ee26                	sd	s1,280(sp)
  begin_op();
    80004156:	f2bfe0ef          	jal	80003080 <begin_op>
  if((ip = namei(old)) == 0){
    8000415a:	ed040513          	addi	a0,s0,-304
    8000415e:	d4ffe0ef          	jal	80002eac <namei>
    80004162:	84aa                	mv	s1,a0
    80004164:	c53d                	beqz	a0,800041d2 <sys_link+0xae>
  ilock(ip);
    80004166:	d30fe0ef          	jal	80002696 <ilock>
  if(ip->type == T_DIR){
    8000416a:	04449703          	lh	a4,68(s1)
    8000416e:	4785                	li	a5,1
    80004170:	06f70663          	beq	a4,a5,800041dc <sys_link+0xb8>
    80004174:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004176:	04a4d783          	lhu	a5,74(s1)
    8000417a:	2785                	addiw	a5,a5,1
    8000417c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004180:	8526                	mv	a0,s1
    80004182:	c60fe0ef          	jal	800025e2 <iupdate>
  iunlock(ip);
    80004186:	8526                	mv	a0,s1
    80004188:	dbcfe0ef          	jal	80002744 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000418c:	fd040593          	addi	a1,s0,-48
    80004190:	f5040513          	addi	a0,s0,-176
    80004194:	d33fe0ef          	jal	80002ec6 <nameiparent>
    80004198:	892a                	mv	s2,a0
    8000419a:	cd21                	beqz	a0,800041f2 <sys_link+0xce>
  ilock(dp);
    8000419c:	cfafe0ef          	jal	80002696 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041a0:	00092703          	lw	a4,0(s2)
    800041a4:	409c                	lw	a5,0(s1)
    800041a6:	04f71363          	bne	a4,a5,800041ec <sys_link+0xc8>
    800041aa:	40d0                	lw	a2,4(s1)
    800041ac:	fd040593          	addi	a1,s0,-48
    800041b0:	854a                	mv	a0,s2
    800041b2:	c61fe0ef          	jal	80002e12 <dirlink>
    800041b6:	02054b63          	bltz	a0,800041ec <sys_link+0xc8>
  iunlockput(dp);
    800041ba:	854a                	mv	a0,s2
    800041bc:	ee4fe0ef          	jal	800028a0 <iunlockput>
  iput(ip);
    800041c0:	8526                	mv	a0,s1
    800041c2:	e56fe0ef          	jal	80002818 <iput>
  end_op();
    800041c6:	f25fe0ef          	jal	800030ea <end_op>
  return 0;
    800041ca:	4781                	li	a5,0
    800041cc:	64f2                	ld	s1,280(sp)
    800041ce:	6952                	ld	s2,272(sp)
    800041d0:	a0a1                	j	80004218 <sys_link+0xf4>
    end_op();
    800041d2:	f19fe0ef          	jal	800030ea <end_op>
    return -1;
    800041d6:	57fd                	li	a5,-1
    800041d8:	64f2                	ld	s1,280(sp)
    800041da:	a83d                	j	80004218 <sys_link+0xf4>
    iunlockput(ip);
    800041dc:	8526                	mv	a0,s1
    800041de:	ec2fe0ef          	jal	800028a0 <iunlockput>
    end_op();
    800041e2:	f09fe0ef          	jal	800030ea <end_op>
    return -1;
    800041e6:	57fd                	li	a5,-1
    800041e8:	64f2                	ld	s1,280(sp)
    800041ea:	a03d                	j	80004218 <sys_link+0xf4>
    iunlockput(dp);
    800041ec:	854a                	mv	a0,s2
    800041ee:	eb2fe0ef          	jal	800028a0 <iunlockput>
  ilock(ip);
    800041f2:	8526                	mv	a0,s1
    800041f4:	ca2fe0ef          	jal	80002696 <ilock>
  ip->nlink--;
    800041f8:	04a4d783          	lhu	a5,74(s1)
    800041fc:	37fd                	addiw	a5,a5,-1
    800041fe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004202:	8526                	mv	a0,s1
    80004204:	bdefe0ef          	jal	800025e2 <iupdate>
  iunlockput(ip);
    80004208:	8526                	mv	a0,s1
    8000420a:	e96fe0ef          	jal	800028a0 <iunlockput>
  end_op();
    8000420e:	eddfe0ef          	jal	800030ea <end_op>
  return -1;
    80004212:	57fd                	li	a5,-1
    80004214:	64f2                	ld	s1,280(sp)
    80004216:	6952                	ld	s2,272(sp)
}
    80004218:	853e                	mv	a0,a5
    8000421a:	70b2                	ld	ra,296(sp)
    8000421c:	7412                	ld	s0,288(sp)
    8000421e:	6155                	addi	sp,sp,304
    80004220:	8082                	ret

0000000080004222 <sys_unlink>:
{
    80004222:	7151                	addi	sp,sp,-240
    80004224:	f586                	sd	ra,232(sp)
    80004226:	f1a2                	sd	s0,224(sp)
    80004228:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000422a:	08000613          	li	a2,128
    8000422e:	f3040593          	addi	a1,s0,-208
    80004232:	4501                	li	a0,0
    80004234:	a7bfd0ef          	jal	80001cae <argstr>
    80004238:	16054063          	bltz	a0,80004398 <sys_unlink+0x176>
    8000423c:	eda6                	sd	s1,216(sp)
  begin_op();
    8000423e:	e43fe0ef          	jal	80003080 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004242:	fb040593          	addi	a1,s0,-80
    80004246:	f3040513          	addi	a0,s0,-208
    8000424a:	c7dfe0ef          	jal	80002ec6 <nameiparent>
    8000424e:	84aa                	mv	s1,a0
    80004250:	c945                	beqz	a0,80004300 <sys_unlink+0xde>
  ilock(dp);
    80004252:	c44fe0ef          	jal	80002696 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004256:	00003597          	auipc	a1,0x3
    8000425a:	33a58593          	addi	a1,a1,826 # 80007590 <etext+0x590>
    8000425e:	fb040513          	addi	a0,s0,-80
    80004262:	9cffe0ef          	jal	80002c30 <namecmp>
    80004266:	10050e63          	beqz	a0,80004382 <sys_unlink+0x160>
    8000426a:	00003597          	auipc	a1,0x3
    8000426e:	32e58593          	addi	a1,a1,814 # 80007598 <etext+0x598>
    80004272:	fb040513          	addi	a0,s0,-80
    80004276:	9bbfe0ef          	jal	80002c30 <namecmp>
    8000427a:	10050463          	beqz	a0,80004382 <sys_unlink+0x160>
    8000427e:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004280:	f2c40613          	addi	a2,s0,-212
    80004284:	fb040593          	addi	a1,s0,-80
    80004288:	8526                	mv	a0,s1
    8000428a:	9bdfe0ef          	jal	80002c46 <dirlookup>
    8000428e:	892a                	mv	s2,a0
    80004290:	0e050863          	beqz	a0,80004380 <sys_unlink+0x15e>
  ilock(ip);
    80004294:	c02fe0ef          	jal	80002696 <ilock>
  if(ip->nlink < 1)
    80004298:	04a91783          	lh	a5,74(s2)
    8000429c:	06f05763          	blez	a5,8000430a <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042a0:	04491703          	lh	a4,68(s2)
    800042a4:	4785                	li	a5,1
    800042a6:	06f70963          	beq	a4,a5,80004318 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800042aa:	4641                	li	a2,16
    800042ac:	4581                	li	a1,0
    800042ae:	fc040513          	addi	a0,s0,-64
    800042b2:	e9dfb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042b6:	4741                	li	a4,16
    800042b8:	f2c42683          	lw	a3,-212(s0)
    800042bc:	fc040613          	addi	a2,s0,-64
    800042c0:	4581                	li	a1,0
    800042c2:	8526                	mv	a0,s1
    800042c4:	85ffe0ef          	jal	80002b22 <writei>
    800042c8:	47c1                	li	a5,16
    800042ca:	08f51b63          	bne	a0,a5,80004360 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800042ce:	04491703          	lh	a4,68(s2)
    800042d2:	4785                	li	a5,1
    800042d4:	08f70d63          	beq	a4,a5,8000436e <sys_unlink+0x14c>
  iunlockput(dp);
    800042d8:	8526                	mv	a0,s1
    800042da:	dc6fe0ef          	jal	800028a0 <iunlockput>
  ip->nlink--;
    800042de:	04a95783          	lhu	a5,74(s2)
    800042e2:	37fd                	addiw	a5,a5,-1
    800042e4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800042e8:	854a                	mv	a0,s2
    800042ea:	af8fe0ef          	jal	800025e2 <iupdate>
  iunlockput(ip);
    800042ee:	854a                	mv	a0,s2
    800042f0:	db0fe0ef          	jal	800028a0 <iunlockput>
  end_op();
    800042f4:	df7fe0ef          	jal	800030ea <end_op>
  return 0;
    800042f8:	4501                	li	a0,0
    800042fa:	64ee                	ld	s1,216(sp)
    800042fc:	694e                	ld	s2,208(sp)
    800042fe:	a849                	j	80004390 <sys_unlink+0x16e>
    end_op();
    80004300:	debfe0ef          	jal	800030ea <end_op>
    return -1;
    80004304:	557d                	li	a0,-1
    80004306:	64ee                	ld	s1,216(sp)
    80004308:	a061                	j	80004390 <sys_unlink+0x16e>
    8000430a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000430c:	00003517          	auipc	a0,0x3
    80004310:	29450513          	addi	a0,a0,660 # 800075a0 <etext+0x5a0>
    80004314:	2ca010ef          	jal	800055de <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004318:	04c92703          	lw	a4,76(s2)
    8000431c:	02000793          	li	a5,32
    80004320:	f8e7f5e3          	bgeu	a5,a4,800042aa <sys_unlink+0x88>
    80004324:	e5ce                	sd	s3,200(sp)
    80004326:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000432a:	4741                	li	a4,16
    8000432c:	86ce                	mv	a3,s3
    8000432e:	f1840613          	addi	a2,s0,-232
    80004332:	4581                	li	a1,0
    80004334:	854a                	mv	a0,s2
    80004336:	ef0fe0ef          	jal	80002a26 <readi>
    8000433a:	47c1                	li	a5,16
    8000433c:	00f51c63          	bne	a0,a5,80004354 <sys_unlink+0x132>
    if(de.inum != 0)
    80004340:	f1845783          	lhu	a5,-232(s0)
    80004344:	efa1                	bnez	a5,8000439c <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004346:	29c1                	addiw	s3,s3,16
    80004348:	04c92783          	lw	a5,76(s2)
    8000434c:	fcf9efe3          	bltu	s3,a5,8000432a <sys_unlink+0x108>
    80004350:	69ae                	ld	s3,200(sp)
    80004352:	bfa1                	j	800042aa <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004354:	00003517          	auipc	a0,0x3
    80004358:	26450513          	addi	a0,a0,612 # 800075b8 <etext+0x5b8>
    8000435c:	282010ef          	jal	800055de <panic>
    80004360:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004362:	00003517          	auipc	a0,0x3
    80004366:	26e50513          	addi	a0,a0,622 # 800075d0 <etext+0x5d0>
    8000436a:	274010ef          	jal	800055de <panic>
    dp->nlink--;
    8000436e:	04a4d783          	lhu	a5,74(s1)
    80004372:	37fd                	addiw	a5,a5,-1
    80004374:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004378:	8526                	mv	a0,s1
    8000437a:	a68fe0ef          	jal	800025e2 <iupdate>
    8000437e:	bfa9                	j	800042d8 <sys_unlink+0xb6>
    80004380:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004382:	8526                	mv	a0,s1
    80004384:	d1cfe0ef          	jal	800028a0 <iunlockput>
  end_op();
    80004388:	d63fe0ef          	jal	800030ea <end_op>
  return -1;
    8000438c:	557d                	li	a0,-1
    8000438e:	64ee                	ld	s1,216(sp)
}
    80004390:	70ae                	ld	ra,232(sp)
    80004392:	740e                	ld	s0,224(sp)
    80004394:	616d                	addi	sp,sp,240
    80004396:	8082                	ret
    return -1;
    80004398:	557d                	li	a0,-1
    8000439a:	bfdd                	j	80004390 <sys_unlink+0x16e>
    iunlockput(ip);
    8000439c:	854a                	mv	a0,s2
    8000439e:	d02fe0ef          	jal	800028a0 <iunlockput>
    goto bad;
    800043a2:	694e                	ld	s2,208(sp)
    800043a4:	69ae                	ld	s3,200(sp)
    800043a6:	bff1                	j	80004382 <sys_unlink+0x160>

00000000800043a8 <sys_open>:

uint64
sys_open(void)
{
    800043a8:	7131                	addi	sp,sp,-192
    800043aa:	fd06                	sd	ra,184(sp)
    800043ac:	f922                	sd	s0,176(sp)
    800043ae:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043b0:	f4c40593          	addi	a1,s0,-180
    800043b4:	4505                	li	a0,1
    800043b6:	8c1fd0ef          	jal	80001c76 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043ba:	08000613          	li	a2,128
    800043be:	f5040593          	addi	a1,s0,-176
    800043c2:	4501                	li	a0,0
    800043c4:	8ebfd0ef          	jal	80001cae <argstr>
    800043c8:	87aa                	mv	a5,a0
    return -1;
    800043ca:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043cc:	0a07c263          	bltz	a5,80004470 <sys_open+0xc8>
    800043d0:	f526                	sd	s1,168(sp)

  begin_op();
    800043d2:	caffe0ef          	jal	80003080 <begin_op>

  if(omode & O_CREATE){
    800043d6:	f4c42783          	lw	a5,-180(s0)
    800043da:	2007f793          	andi	a5,a5,512
    800043de:	c3d5                	beqz	a5,80004482 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800043e0:	4681                	li	a3,0
    800043e2:	4601                	li	a2,0
    800043e4:	4589                	li	a1,2
    800043e6:	f5040513          	addi	a0,s0,-176
    800043ea:	aa9ff0ef          	jal	80003e92 <create>
    800043ee:	84aa                	mv	s1,a0
    if(ip == 0){
    800043f0:	c541                	beqz	a0,80004478 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800043f2:	04449703          	lh	a4,68(s1)
    800043f6:	478d                	li	a5,3
    800043f8:	00f71763          	bne	a4,a5,80004406 <sys_open+0x5e>
    800043fc:	0464d703          	lhu	a4,70(s1)
    80004400:	47a5                	li	a5,9
    80004402:	0ae7ed63          	bltu	a5,a4,800044bc <sys_open+0x114>
    80004406:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004408:	fe1fe0ef          	jal	800033e8 <filealloc>
    8000440c:	892a                	mv	s2,a0
    8000440e:	c179                	beqz	a0,800044d4 <sys_open+0x12c>
    80004410:	ed4e                	sd	s3,152(sp)
    80004412:	a43ff0ef          	jal	80003e54 <fdalloc>
    80004416:	89aa                	mv	s3,a0
    80004418:	0a054a63          	bltz	a0,800044cc <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000441c:	04449703          	lh	a4,68(s1)
    80004420:	478d                	li	a5,3
    80004422:	0cf70263          	beq	a4,a5,800044e6 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004426:	4789                	li	a5,2
    80004428:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000442c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004430:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004434:	f4c42783          	lw	a5,-180(s0)
    80004438:	0017c713          	xori	a4,a5,1
    8000443c:	8b05                	andi	a4,a4,1
    8000443e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004442:	0037f713          	andi	a4,a5,3
    80004446:	00e03733          	snez	a4,a4
    8000444a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000444e:	4007f793          	andi	a5,a5,1024
    80004452:	c791                	beqz	a5,8000445e <sys_open+0xb6>
    80004454:	04449703          	lh	a4,68(s1)
    80004458:	4789                	li	a5,2
    8000445a:	08f70d63          	beq	a4,a5,800044f4 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000445e:	8526                	mv	a0,s1
    80004460:	ae4fe0ef          	jal	80002744 <iunlock>
  end_op();
    80004464:	c87fe0ef          	jal	800030ea <end_op>

  return fd;
    80004468:	854e                	mv	a0,s3
    8000446a:	74aa                	ld	s1,168(sp)
    8000446c:	790a                	ld	s2,160(sp)
    8000446e:	69ea                	ld	s3,152(sp)
}
    80004470:	70ea                	ld	ra,184(sp)
    80004472:	744a                	ld	s0,176(sp)
    80004474:	6129                	addi	sp,sp,192
    80004476:	8082                	ret
      end_op();
    80004478:	c73fe0ef          	jal	800030ea <end_op>
      return -1;
    8000447c:	557d                	li	a0,-1
    8000447e:	74aa                	ld	s1,168(sp)
    80004480:	bfc5                	j	80004470 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004482:	f5040513          	addi	a0,s0,-176
    80004486:	a27fe0ef          	jal	80002eac <namei>
    8000448a:	84aa                	mv	s1,a0
    8000448c:	c11d                	beqz	a0,800044b2 <sys_open+0x10a>
    ilock(ip);
    8000448e:	a08fe0ef          	jal	80002696 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004492:	04449703          	lh	a4,68(s1)
    80004496:	4785                	li	a5,1
    80004498:	f4f71de3          	bne	a4,a5,800043f2 <sys_open+0x4a>
    8000449c:	f4c42783          	lw	a5,-180(s0)
    800044a0:	d3bd                	beqz	a5,80004406 <sys_open+0x5e>
      iunlockput(ip);
    800044a2:	8526                	mv	a0,s1
    800044a4:	bfcfe0ef          	jal	800028a0 <iunlockput>
      end_op();
    800044a8:	c43fe0ef          	jal	800030ea <end_op>
      return -1;
    800044ac:	557d                	li	a0,-1
    800044ae:	74aa                	ld	s1,168(sp)
    800044b0:	b7c1                	j	80004470 <sys_open+0xc8>
      end_op();
    800044b2:	c39fe0ef          	jal	800030ea <end_op>
      return -1;
    800044b6:	557d                	li	a0,-1
    800044b8:	74aa                	ld	s1,168(sp)
    800044ba:	bf5d                	j	80004470 <sys_open+0xc8>
    iunlockput(ip);
    800044bc:	8526                	mv	a0,s1
    800044be:	be2fe0ef          	jal	800028a0 <iunlockput>
    end_op();
    800044c2:	c29fe0ef          	jal	800030ea <end_op>
    return -1;
    800044c6:	557d                	li	a0,-1
    800044c8:	74aa                	ld	s1,168(sp)
    800044ca:	b75d                	j	80004470 <sys_open+0xc8>
      fileclose(f);
    800044cc:	854a                	mv	a0,s2
    800044ce:	fbffe0ef          	jal	8000348c <fileclose>
    800044d2:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044d4:	8526                	mv	a0,s1
    800044d6:	bcafe0ef          	jal	800028a0 <iunlockput>
    end_op();
    800044da:	c11fe0ef          	jal	800030ea <end_op>
    return -1;
    800044de:	557d                	li	a0,-1
    800044e0:	74aa                	ld	s1,168(sp)
    800044e2:	790a                	ld	s2,160(sp)
    800044e4:	b771                	j	80004470 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800044e6:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800044ea:	04649783          	lh	a5,70(s1)
    800044ee:	02f91223          	sh	a5,36(s2)
    800044f2:	bf3d                	j	80004430 <sys_open+0x88>
    itrunc(ip);
    800044f4:	8526                	mv	a0,s1
    800044f6:	a8efe0ef          	jal	80002784 <itrunc>
    800044fa:	b795                	j	8000445e <sys_open+0xb6>

00000000800044fc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800044fc:	7175                	addi	sp,sp,-144
    800044fe:	e506                	sd	ra,136(sp)
    80004500:	e122                	sd	s0,128(sp)
    80004502:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004504:	b7dfe0ef          	jal	80003080 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004508:	08000613          	li	a2,128
    8000450c:	f7040593          	addi	a1,s0,-144
    80004510:	4501                	li	a0,0
    80004512:	f9cfd0ef          	jal	80001cae <argstr>
    80004516:	02054363          	bltz	a0,8000453c <sys_mkdir+0x40>
    8000451a:	4681                	li	a3,0
    8000451c:	4601                	li	a2,0
    8000451e:	4585                	li	a1,1
    80004520:	f7040513          	addi	a0,s0,-144
    80004524:	96fff0ef          	jal	80003e92 <create>
    80004528:	c911                	beqz	a0,8000453c <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000452a:	b76fe0ef          	jal	800028a0 <iunlockput>
  end_op();
    8000452e:	bbdfe0ef          	jal	800030ea <end_op>
  return 0;
    80004532:	4501                	li	a0,0
}
    80004534:	60aa                	ld	ra,136(sp)
    80004536:	640a                	ld	s0,128(sp)
    80004538:	6149                	addi	sp,sp,144
    8000453a:	8082                	ret
    end_op();
    8000453c:	baffe0ef          	jal	800030ea <end_op>
    return -1;
    80004540:	557d                	li	a0,-1
    80004542:	bfcd                	j	80004534 <sys_mkdir+0x38>

0000000080004544 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004544:	7135                	addi	sp,sp,-160
    80004546:	ed06                	sd	ra,152(sp)
    80004548:	e922                	sd	s0,144(sp)
    8000454a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000454c:	b35fe0ef          	jal	80003080 <begin_op>
  argint(1, &major);
    80004550:	f6c40593          	addi	a1,s0,-148
    80004554:	4505                	li	a0,1
    80004556:	f20fd0ef          	jal	80001c76 <argint>
  argint(2, &minor);
    8000455a:	f6840593          	addi	a1,s0,-152
    8000455e:	4509                	li	a0,2
    80004560:	f16fd0ef          	jal	80001c76 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004564:	08000613          	li	a2,128
    80004568:	f7040593          	addi	a1,s0,-144
    8000456c:	4501                	li	a0,0
    8000456e:	f40fd0ef          	jal	80001cae <argstr>
    80004572:	02054563          	bltz	a0,8000459c <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004576:	f6841683          	lh	a3,-152(s0)
    8000457a:	f6c41603          	lh	a2,-148(s0)
    8000457e:	458d                	li	a1,3
    80004580:	f7040513          	addi	a0,s0,-144
    80004584:	90fff0ef          	jal	80003e92 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004588:	c911                	beqz	a0,8000459c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000458a:	b16fe0ef          	jal	800028a0 <iunlockput>
  end_op();
    8000458e:	b5dfe0ef          	jal	800030ea <end_op>
  return 0;
    80004592:	4501                	li	a0,0
}
    80004594:	60ea                	ld	ra,152(sp)
    80004596:	644a                	ld	s0,144(sp)
    80004598:	610d                	addi	sp,sp,160
    8000459a:	8082                	ret
    end_op();
    8000459c:	b4ffe0ef          	jal	800030ea <end_op>
    return -1;
    800045a0:	557d                	li	a0,-1
    800045a2:	bfcd                	j	80004594 <sys_mknod+0x50>

00000000800045a4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045a4:	7135                	addi	sp,sp,-160
    800045a6:	ed06                	sd	ra,152(sp)
    800045a8:	e922                	sd	s0,144(sp)
    800045aa:	e14a                	sd	s2,128(sp)
    800045ac:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045ae:	fccfc0ef          	jal	80000d7a <myproc>
    800045b2:	892a                	mv	s2,a0
  
  begin_op();
    800045b4:	acdfe0ef          	jal	80003080 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045b8:	08000613          	li	a2,128
    800045bc:	f6040593          	addi	a1,s0,-160
    800045c0:	4501                	li	a0,0
    800045c2:	eecfd0ef          	jal	80001cae <argstr>
    800045c6:	04054363          	bltz	a0,8000460c <sys_chdir+0x68>
    800045ca:	e526                	sd	s1,136(sp)
    800045cc:	f6040513          	addi	a0,s0,-160
    800045d0:	8ddfe0ef          	jal	80002eac <namei>
    800045d4:	84aa                	mv	s1,a0
    800045d6:	c915                	beqz	a0,8000460a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800045d8:	8befe0ef          	jal	80002696 <ilock>
  if(ip->type != T_DIR){
    800045dc:	04449703          	lh	a4,68(s1)
    800045e0:	4785                	li	a5,1
    800045e2:	02f71963          	bne	a4,a5,80004614 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800045e6:	8526                	mv	a0,s1
    800045e8:	95cfe0ef          	jal	80002744 <iunlock>
  iput(p->cwd);
    800045ec:	15093503          	ld	a0,336(s2)
    800045f0:	a28fe0ef          	jal	80002818 <iput>
  end_op();
    800045f4:	af7fe0ef          	jal	800030ea <end_op>
  p->cwd = ip;
    800045f8:	14993823          	sd	s1,336(s2)
  return 0;
    800045fc:	4501                	li	a0,0
    800045fe:	64aa                	ld	s1,136(sp)
}
    80004600:	60ea                	ld	ra,152(sp)
    80004602:	644a                	ld	s0,144(sp)
    80004604:	690a                	ld	s2,128(sp)
    80004606:	610d                	addi	sp,sp,160
    80004608:	8082                	ret
    8000460a:	64aa                	ld	s1,136(sp)
    end_op();
    8000460c:	adffe0ef          	jal	800030ea <end_op>
    return -1;
    80004610:	557d                	li	a0,-1
    80004612:	b7fd                	j	80004600 <sys_chdir+0x5c>
    iunlockput(ip);
    80004614:	8526                	mv	a0,s1
    80004616:	a8afe0ef          	jal	800028a0 <iunlockput>
    end_op();
    8000461a:	ad1fe0ef          	jal	800030ea <end_op>
    return -1;
    8000461e:	557d                	li	a0,-1
    80004620:	64aa                	ld	s1,136(sp)
    80004622:	bff9                	j	80004600 <sys_chdir+0x5c>

0000000080004624 <sys_exec>:

uint64
sys_exec(void)
{
    80004624:	7121                	addi	sp,sp,-448
    80004626:	ff06                	sd	ra,440(sp)
    80004628:	fb22                	sd	s0,432(sp)
    8000462a:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000462c:	e4840593          	addi	a1,s0,-440
    80004630:	4505                	li	a0,1
    80004632:	e60fd0ef          	jal	80001c92 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004636:	08000613          	li	a2,128
    8000463a:	f5040593          	addi	a1,s0,-176
    8000463e:	4501                	li	a0,0
    80004640:	e6efd0ef          	jal	80001cae <argstr>
    80004644:	87aa                	mv	a5,a0
    return -1;
    80004646:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004648:	0c07c463          	bltz	a5,80004710 <sys_exec+0xec>
    8000464c:	f726                	sd	s1,424(sp)
    8000464e:	f34a                	sd	s2,416(sp)
    80004650:	ef4e                	sd	s3,408(sp)
    80004652:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004654:	10000613          	li	a2,256
    80004658:	4581                	li	a1,0
    8000465a:	e5040513          	addi	a0,s0,-432
    8000465e:	af1fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004662:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004666:	89a6                	mv	s3,s1
    80004668:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000466a:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000466e:	00391513          	slli	a0,s2,0x3
    80004672:	e4040593          	addi	a1,s0,-448
    80004676:	e4843783          	ld	a5,-440(s0)
    8000467a:	953e                	add	a0,a0,a5
    8000467c:	d70fd0ef          	jal	80001bec <fetchaddr>
    80004680:	02054663          	bltz	a0,800046ac <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004684:	e4043783          	ld	a5,-448(s0)
    80004688:	c3a9                	beqz	a5,800046ca <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000468a:	a75fb0ef          	jal	800000fe <kalloc>
    8000468e:	85aa                	mv	a1,a0
    80004690:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004694:	cd01                	beqz	a0,800046ac <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004696:	6605                	lui	a2,0x1
    80004698:	e4043503          	ld	a0,-448(s0)
    8000469c:	d9afd0ef          	jal	80001c36 <fetchstr>
    800046a0:	00054663          	bltz	a0,800046ac <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800046a4:	0905                	addi	s2,s2,1
    800046a6:	09a1                	addi	s3,s3,8
    800046a8:	fd4913e3          	bne	s2,s4,8000466e <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ac:	f5040913          	addi	s2,s0,-176
    800046b0:	6088                	ld	a0,0(s1)
    800046b2:	c931                	beqz	a0,80004706 <sys_exec+0xe2>
    kfree(argv[i]);
    800046b4:	969fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046b8:	04a1                	addi	s1,s1,8
    800046ba:	ff249be3          	bne	s1,s2,800046b0 <sys_exec+0x8c>
  return -1;
    800046be:	557d                	li	a0,-1
    800046c0:	74ba                	ld	s1,424(sp)
    800046c2:	791a                	ld	s2,416(sp)
    800046c4:	69fa                	ld	s3,408(sp)
    800046c6:	6a5a                	ld	s4,400(sp)
    800046c8:	a0a1                	j	80004710 <sys_exec+0xec>
      argv[i] = 0;
    800046ca:	0009079b          	sext.w	a5,s2
    800046ce:	078e                	slli	a5,a5,0x3
    800046d0:	fd078793          	addi	a5,a5,-48
    800046d4:	97a2                	add	a5,a5,s0
    800046d6:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    800046da:	e5040593          	addi	a1,s0,-432
    800046de:	f5040513          	addi	a0,s0,-176
    800046e2:	ba8ff0ef          	jal	80003a8a <kexec>
    800046e6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046e8:	f5040993          	addi	s3,s0,-176
    800046ec:	6088                	ld	a0,0(s1)
    800046ee:	c511                	beqz	a0,800046fa <sys_exec+0xd6>
    kfree(argv[i]);
    800046f0:	92dfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046f4:	04a1                	addi	s1,s1,8
    800046f6:	ff349be3          	bne	s1,s3,800046ec <sys_exec+0xc8>
  return ret;
    800046fa:	854a                	mv	a0,s2
    800046fc:	74ba                	ld	s1,424(sp)
    800046fe:	791a                	ld	s2,416(sp)
    80004700:	69fa                	ld	s3,408(sp)
    80004702:	6a5a                	ld	s4,400(sp)
    80004704:	a031                	j	80004710 <sys_exec+0xec>
  return -1;
    80004706:	557d                	li	a0,-1
    80004708:	74ba                	ld	s1,424(sp)
    8000470a:	791a                	ld	s2,416(sp)
    8000470c:	69fa                	ld	s3,408(sp)
    8000470e:	6a5a                	ld	s4,400(sp)
}
    80004710:	70fa                	ld	ra,440(sp)
    80004712:	745a                	ld	s0,432(sp)
    80004714:	6139                	addi	sp,sp,448
    80004716:	8082                	ret

0000000080004718 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004718:	7139                	addi	sp,sp,-64
    8000471a:	fc06                	sd	ra,56(sp)
    8000471c:	f822                	sd	s0,48(sp)
    8000471e:	f426                	sd	s1,40(sp)
    80004720:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004722:	e58fc0ef          	jal	80000d7a <myproc>
    80004726:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004728:	fd840593          	addi	a1,s0,-40
    8000472c:	4501                	li	a0,0
    8000472e:	d64fd0ef          	jal	80001c92 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004732:	fc840593          	addi	a1,s0,-56
    80004736:	fd040513          	addi	a0,s0,-48
    8000473a:	85cff0ef          	jal	80003796 <pipealloc>
    return -1;
    8000473e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004740:	0a054463          	bltz	a0,800047e8 <sys_pipe+0xd0>
  fd0 = -1;
    80004744:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004748:	fd043503          	ld	a0,-48(s0)
    8000474c:	f08ff0ef          	jal	80003e54 <fdalloc>
    80004750:	fca42223          	sw	a0,-60(s0)
    80004754:	08054163          	bltz	a0,800047d6 <sys_pipe+0xbe>
    80004758:	fc843503          	ld	a0,-56(s0)
    8000475c:	ef8ff0ef          	jal	80003e54 <fdalloc>
    80004760:	fca42023          	sw	a0,-64(s0)
    80004764:	06054063          	bltz	a0,800047c4 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004768:	4691                	li	a3,4
    8000476a:	fc440613          	addi	a2,s0,-60
    8000476e:	fd843583          	ld	a1,-40(s0)
    80004772:	68a8                	ld	a0,80(s1)
    80004774:	b1afc0ef          	jal	80000a8e <copyout>
    80004778:	00054e63          	bltz	a0,80004794 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000477c:	4691                	li	a3,4
    8000477e:	fc040613          	addi	a2,s0,-64
    80004782:	fd843583          	ld	a1,-40(s0)
    80004786:	0591                	addi	a1,a1,4
    80004788:	68a8                	ld	a0,80(s1)
    8000478a:	b04fc0ef          	jal	80000a8e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000478e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004790:	04055c63          	bgez	a0,800047e8 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004794:	fc442783          	lw	a5,-60(s0)
    80004798:	07e9                	addi	a5,a5,26
    8000479a:	078e                	slli	a5,a5,0x3
    8000479c:	97a6                	add	a5,a5,s1
    8000479e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047a2:	fc042783          	lw	a5,-64(s0)
    800047a6:	07e9                	addi	a5,a5,26
    800047a8:	078e                	slli	a5,a5,0x3
    800047aa:	94be                	add	s1,s1,a5
    800047ac:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800047b0:	fd043503          	ld	a0,-48(s0)
    800047b4:	cd9fe0ef          	jal	8000348c <fileclose>
    fileclose(wf);
    800047b8:	fc843503          	ld	a0,-56(s0)
    800047bc:	cd1fe0ef          	jal	8000348c <fileclose>
    return -1;
    800047c0:	57fd                	li	a5,-1
    800047c2:	a01d                	j	800047e8 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800047c4:	fc442783          	lw	a5,-60(s0)
    800047c8:	0007c763          	bltz	a5,800047d6 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800047cc:	07e9                	addi	a5,a5,26
    800047ce:	078e                	slli	a5,a5,0x3
    800047d0:	97a6                	add	a5,a5,s1
    800047d2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047d6:	fd043503          	ld	a0,-48(s0)
    800047da:	cb3fe0ef          	jal	8000348c <fileclose>
    fileclose(wf);
    800047de:	fc843503          	ld	a0,-56(s0)
    800047e2:	cabfe0ef          	jal	8000348c <fileclose>
    return -1;
    800047e6:	57fd                	li	a5,-1
}
    800047e8:	853e                	mv	a0,a5
    800047ea:	70e2                	ld	ra,56(sp)
    800047ec:	7442                	ld	s0,48(sp)
    800047ee:	74a2                	ld	s1,40(sp)
    800047f0:	6121                	addi	sp,sp,64
    800047f2:	8082                	ret
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
    80004826:	ad6fd0ef          	jal	80001afc <kerneltrap>

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
    80004880:	ccefc0ef          	jal	80000d4e <cpuid>
  
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
    800048b4:	c9afc0ef          	jal	80000d4e <cpuid>
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
    800048d8:	c76fc0ef          	jal	80000d4e <cpuid>
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
    80004904:	a0078793          	addi	a5,a5,-1536 # 8001b300 <disk>
    80004908:	97aa                	add	a5,a5,a0
    8000490a:	0187c783          	lbu	a5,24(a5)
    8000490e:	e7b9                	bnez	a5,8000495c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004910:	00451693          	slli	a3,a0,0x4
    80004914:	00017797          	auipc	a5,0x17
    80004918:	9ec78793          	addi	a5,a5,-1556 # 8001b300 <disk>
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
    80004940:	9dc50513          	addi	a0,a0,-1572 # 8001b318 <disk+0x18>
    80004944:	a7bfc0ef          	jal	800013be <wakeup>
}
    80004948:	60a2                	ld	ra,8(sp)
    8000494a:	6402                	ld	s0,0(sp)
    8000494c:	0141                	addi	sp,sp,16
    8000494e:	8082                	ret
    panic("free_desc 1");
    80004950:	00003517          	auipc	a0,0x3
    80004954:	c9050513          	addi	a0,a0,-880 # 800075e0 <etext+0x5e0>
    80004958:	487000ef          	jal	800055de <panic>
    panic("free_desc 2");
    8000495c:	00003517          	auipc	a0,0x3
    80004960:	c9450513          	addi	a0,a0,-876 # 800075f0 <etext+0x5f0>
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
    80004978:	c8c58593          	addi	a1,a1,-884 # 80007600 <etext+0x600>
    8000497c:	00017517          	auipc	a0,0x17
    80004980:	aac50513          	addi	a0,a0,-1364 # 8001b428 <disk+0x128>
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
    800049e8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb247>
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
    80004a3e:	8c648493          	addi	s1,s1,-1850 # 8001b300 <disk>
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
    80004a5c:	8b073703          	ld	a4,-1872(a4) # 8001b308 <disk+0x8>
    80004a60:	0e070a63          	beqz	a4,80004b54 <virtio_disk_init+0x1ec>
    80004a64:	0e078863          	beqz	a5,80004b54 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004a68:	6605                	lui	a2,0x1
    80004a6a:	4581                	li	a1,0
    80004a6c:	ee2fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a70:	00017497          	auipc	s1,0x17
    80004a74:	89048493          	addi	s1,s1,-1904 # 8001b300 <disk>
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
    80004b1c:	af850513          	addi	a0,a0,-1288 # 80007610 <etext+0x610>
    80004b20:	2bf000ef          	jal	800055de <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b24:	00003517          	auipc	a0,0x3
    80004b28:	b0c50513          	addi	a0,a0,-1268 # 80007630 <etext+0x630>
    80004b2c:	2b3000ef          	jal	800055de <panic>
    panic("virtio disk should not be ready");
    80004b30:	00003517          	auipc	a0,0x3
    80004b34:	b2050513          	addi	a0,a0,-1248 # 80007650 <etext+0x650>
    80004b38:	2a7000ef          	jal	800055de <panic>
    panic("virtio disk has no queue 0");
    80004b3c:	00003517          	auipc	a0,0x3
    80004b40:	b3450513          	addi	a0,a0,-1228 # 80007670 <etext+0x670>
    80004b44:	29b000ef          	jal	800055de <panic>
    panic("virtio disk max queue too short");
    80004b48:	00003517          	auipc	a0,0x3
    80004b4c:	b4850513          	addi	a0,a0,-1208 # 80007690 <etext+0x690>
    80004b50:	28f000ef          	jal	800055de <panic>
    panic("virtio disk kalloc");
    80004b54:	00003517          	auipc	a0,0x3
    80004b58:	b5c50513          	addi	a0,a0,-1188 # 800076b0 <etext+0x6b0>
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
    80004b90:	89c50513          	addi	a0,a0,-1892 # 8001b428 <disk+0x128>
    80004b94:	507000ef          	jal	8000589a <acquire>
  for(int i = 0; i < 3; i++){
    80004b98:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004b9a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004b9c:	00016b17          	auipc	s6,0x16
    80004ba0:	764b0b13          	addi	s6,s6,1892 # 8001b300 <disk>
  for(int i = 0; i < 3; i++){
    80004ba4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004ba6:	00017c17          	auipc	s8,0x17
    80004baa:	882c0c13          	addi	s8,s8,-1918 # 8001b428 <disk+0x128>
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
    80004bcc:	73870713          	addi	a4,a4,1848 # 8001b300 <disk>
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
    80004c04:	71850513          	addi	a0,a0,1816 # 8001b318 <disk+0x18>
    80004c08:	f6afc0ef          	jal	80001372 <sleep>
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
    80004c20:	6e478793          	addi	a5,a5,1764 # 8001b300 <disk>
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
    80004cf6:	73690913          	addi	s2,s2,1846 # 8001b428 <disk+0x128>
  while(b->disk == 1) {
    80004cfa:	4485                	li	s1,1
    80004cfc:	01079a63          	bne	a5,a6,80004d10 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d00:	85ca                	mv	a1,s2
    80004d02:	8552                	mv	a0,s4
    80004d04:	e6efc0ef          	jal	80001372 <sleep>
  while(b->disk == 1) {
    80004d08:	004a2783          	lw	a5,4(s4)
    80004d0c:	fe978ae3          	beq	a5,s1,80004d00 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d10:	f9042903          	lw	s2,-112(s0)
    80004d14:	00290713          	addi	a4,s2,2
    80004d18:	0712                	slli	a4,a4,0x4
    80004d1a:	00016797          	auipc	a5,0x16
    80004d1e:	5e678793          	addi	a5,a5,1510 # 8001b300 <disk>
    80004d22:	97ba                	add	a5,a5,a4
    80004d24:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d28:	00016997          	auipc	s3,0x16
    80004d2c:	5d898993          	addi	s3,s3,1496 # 8001b300 <disk>
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
    80004d50:	6dc50513          	addi	a0,a0,1756 # 8001b428 <disk+0x128>
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
    80004d80:	58448493          	addi	s1,s1,1412 # 8001b300 <disk>
    80004d84:	00016517          	auipc	a0,0x16
    80004d88:	6a450513          	addi	a0,a0,1700 # 8001b428 <disk+0x128>
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
    80004ddc:	de2fc0ef          	jal	800013be <wakeup>

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
    80004dfc:	63050513          	addi	a0,a0,1584 # 8001b428 <disk+0x128>
    80004e00:	333000ef          	jal	80005932 <release>
}
    80004e04:	60e2                	ld	ra,24(sp)
    80004e06:	6442                	ld	s0,16(sp)
    80004e08:	64a2                	ld	s1,8(sp)
    80004e0a:	6105                	addi	sp,sp,32
    80004e0c:	8082                	ret
      panic("virtio_disk_intr status");
    80004e0e:	00003517          	auipc	a0,0x3
    80004e12:	8ba50513          	addi	a0,a0,-1862 # 800076c8 <etext+0x6c8>
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
    80004e6c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb2e7>
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
    80004f10:	809fc0ef          	jal	80001718 <either_copyin>
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
    80004f8e:	4b650513          	addi	a0,a0,1206 # 80023440 <cons>
    80004f92:	109000ef          	jal	8000589a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004f96:	0001e497          	auipc	s1,0x1e
    80004f9a:	4aa48493          	addi	s1,s1,1194 # 80023440 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004f9e:	0001e917          	auipc	s2,0x1e
    80004fa2:	53a90913          	addi	s2,s2,1338 # 800234d8 <cons+0x98>
  while(n > 0){
    80004fa6:	0b305d63          	blez	s3,80005060 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004faa:	0984a783          	lw	a5,152(s1)
    80004fae:	09c4a703          	lw	a4,156(s1)
    80004fb2:	0af71263          	bne	a4,a5,80005056 <consoleread+0xea>
      if(killed(myproc())){
    80004fb6:	dc5fb0ef          	jal	80000d7a <myproc>
    80004fba:	df0fc0ef          	jal	800015aa <killed>
    80004fbe:	e12d                	bnez	a0,80005020 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004fc0:	85a6                	mv	a1,s1
    80004fc2:	854a                	mv	a0,s2
    80004fc4:	baefc0ef          	jal	80001372 <sleep>
    while(cons.r == cons.w){
    80004fc8:	0984a783          	lw	a5,152(s1)
    80004fcc:	09c4a703          	lw	a4,156(s1)
    80004fd0:	fef703e3          	beq	a4,a5,80004fb6 <consoleread+0x4a>
    80004fd4:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004fd6:	0001e717          	auipc	a4,0x1e
    80004fda:	46a70713          	addi	a4,a4,1130 # 80023440 <cons>
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
    80005008:	ec6fc0ef          	jal	800016ce <either_copyout>
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
    80005024:	42050513          	addi	a0,a0,1056 # 80023440 <cons>
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
    8000504e:	48f72723          	sw	a5,1166(a4) # 800234d8 <cons+0x98>
    80005052:	6be2                	ld	s7,24(sp)
    80005054:	a031                	j	80005060 <consoleread+0xf4>
    80005056:	ec5e                	sd	s7,24(sp)
    80005058:	bfbd                	j	80004fd6 <consoleread+0x6a>
    8000505a:	6be2                	ld	s7,24(sp)
    8000505c:	a011                	j	80005060 <consoleread+0xf4>
    8000505e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005060:	0001e517          	auipc	a0,0x1e
    80005064:	3e050513          	addi	a0,a0,992 # 80023440 <cons>
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
    800050b8:	38c50513          	addi	a0,a0,908 # 80023440 <cons>
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
    800050d6:	e8cfc0ef          	jal	80001762 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800050da:	0001e517          	auipc	a0,0x1e
    800050de:	36650513          	addi	a0,a0,870 # 80023440 <cons>
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
    800050fc:	34870713          	addi	a4,a4,840 # 80023440 <cons>
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
    80005122:	32278793          	addi	a5,a5,802 # 80023440 <cons>
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
    80005150:	38c7a783          	lw	a5,908(a5) # 800234d8 <cons+0x98>
    80005154:	9f1d                	subw	a4,a4,a5
    80005156:	08000793          	li	a5,128
    8000515a:	f8f710e3          	bne	a4,a5,800050da <consoleintr+0x32>
    8000515e:	a07d                	j	8000520c <consoleintr+0x164>
    80005160:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005162:	0001e717          	auipc	a4,0x1e
    80005166:	2de70713          	addi	a4,a4,734 # 80023440 <cons>
    8000516a:	0a072783          	lw	a5,160(a4)
    8000516e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005172:	0001e497          	auipc	s1,0x1e
    80005176:	2ce48493          	addi	s1,s1,718 # 80023440 <cons>
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
    800051b8:	28c70713          	addi	a4,a4,652 # 80023440 <cons>
    800051bc:	0a072783          	lw	a5,160(a4)
    800051c0:	09c72703          	lw	a4,156(a4)
    800051c4:	f0f70be3          	beq	a4,a5,800050da <consoleintr+0x32>
      cons.e--;
    800051c8:	37fd                	addiw	a5,a5,-1
    800051ca:	0001e717          	auipc	a4,0x1e
    800051ce:	30f72b23          	sw	a5,790(a4) # 800234e0 <cons+0xa0>
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
    800051ec:	25878793          	addi	a5,a5,600 # 80023440 <cons>
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
    80005210:	2cc7a823          	sw	a2,720(a5) # 800234dc <cons+0x9c>
        wakeup(&cons.r);
    80005214:	0001e517          	auipc	a0,0x1e
    80005218:	2c450513          	addi	a0,a0,708 # 800234d8 <cons+0x98>
    8000521c:	9a2fc0ef          	jal	800013be <wakeup>
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
    8000522e:	4b658593          	addi	a1,a1,1206 # 800076e0 <etext+0x6e0>
    80005232:	0001e517          	auipc	a0,0x1e
    80005236:	20e50513          	addi	a0,a0,526 # 80023440 <cons>
    8000523a:	5e0000ef          	jal	8000581a <initlock>

  uartinit();
    8000523e:	400000ef          	jal	8000563e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005242:	00015797          	auipc	a5,0x15
    80005246:	06678793          	addi	a5,a5,102 # 8001a2a8 <devsw>
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
    80005280:	5cc60613          	addi	a2,a2,1484 # 80007848 <digits>
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
    8000531a:	eea7a783          	lw	a5,-278(a5) # 8000a200 <panicking>
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
    80005362:	18a50513          	addi	a0,a0,394 # 800234e8 <pr>
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
    8000552a:	322b8b93          	addi	s7,s7,802 # 80007848 <digits>
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
    8000558a:	16290913          	addi	s2,s2,354 # 800076e8 <etext+0x6e8>
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
    800055be:	c467a783          	lw	a5,-954(a5) # 8000a200 <panicking>
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
    800055d4:	f1850513          	addi	a0,a0,-232 # 800234e8 <pr>
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
    800055f2:	c127a923          	sw	s2,-1006(a5) # 8000a200 <panicking>
  printf("panic: ");
    800055f6:	00002517          	auipc	a0,0x2
    800055fa:	0fa50513          	addi	a0,a0,250 # 800076f0 <etext+0x6f0>
    800055fe:	cfbff0ef          	jal	800052f8 <printf>
  printf("%s\n", s);
    80005602:	85a6                	mv	a1,s1
    80005604:	00002517          	auipc	a0,0x2
    80005608:	0f450513          	addi	a0,a0,244 # 800076f8 <etext+0x6f8>
    8000560c:	cedff0ef          	jal	800052f8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005610:	00005797          	auipc	a5,0x5
    80005614:	bf27a623          	sw	s2,-1044(a5) # 8000a1fc <panicked>
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
    80005626:	0de58593          	addi	a1,a1,222 # 80007700 <etext+0x700>
    8000562a:	0001e517          	auipc	a0,0x1e
    8000562e:	ebe50513          	addi	a0,a0,-322 # 800234e8 <pr>
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
    8000567e:	08e58593          	addi	a1,a1,142 # 80007708 <etext+0x708>
    80005682:	0001e517          	auipc	a0,0x1e
    80005686:	e7e50513          	addi	a0,a0,-386 # 80023500 <tx_lock>
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
    800056aa:	e5a50513          	addi	a0,a0,-422 # 80023500 <tx_lock>
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
    800056c8:	b4448493          	addi	s1,s1,-1212 # 8000a208 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800056cc:	0001e997          	auipc	s3,0x1e
    800056d0:	e3498993          	addi	s3,s3,-460 # 80023500 <tx_lock>
    800056d4:	00005917          	auipc	s2,0x5
    800056d8:	b3090913          	addi	s2,s2,-1232 # 8000a204 <tx_chan>
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
    800056e8:	c8bfb0ef          	jal	80001372 <sleep>
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
    80005716:	dee50513          	addi	a0,a0,-530 # 80023500 <tx_lock>
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
    8000573a:	aca7a783          	lw	a5,-1334(a5) # 8000a200 <panicking>
    8000573e:	cf95                	beqz	a5,8000577a <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005740:	00005797          	auipc	a5,0x5
    80005744:	abc7a783          	lw	a5,-1348(a5) # 8000a1fc <panicked>
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
    8000576a:	a9a7a783          	lw	a5,-1382(a5) # 8000a200 <panicking>
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
    800057c6:	d3e50513          	addi	a0,a0,-706 # 80023500 <tx_lock>
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
    800057e2:	d2250513          	addi	a0,a0,-734 # 80023500 <tx_lock>
    800057e6:	14c000ef          	jal	80005932 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800057ea:	54fd                	li	s1,-1
    800057ec:	a831                	j	80005808 <uartintr+0x5a>
    tx_busy = 0;
    800057ee:	00005797          	auipc	a5,0x5
    800057f2:	a007ad23          	sw	zero,-1510(a5) # 8000a208 <tx_busy>
    wakeup(&tx_chan);
    800057f6:	00005517          	auipc	a0,0x5
    800057fa:	a0e50513          	addi	a0,a0,-1522 # 8000a204 <tx_chan>
    800057fe:	bc1fb0ef          	jal	800013be <wakeup>
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
    80005844:	d1afb0ef          	jal	80000d5e <mycpu>
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
    80005872:	cecfb0ef          	jal	80000d5e <mycpu>
    80005876:	5d3c                	lw	a5,120(a0)
    80005878:	cb99                	beqz	a5,8000588e <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000587a:	ce4fb0ef          	jal	80000d5e <mycpu>
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
    8000588e:	cd0fb0ef          	jal	80000d5e <mycpu>
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
    800058c2:	c9cfb0ef          	jal	80000d5e <mycpu>
    800058c6:	e888                	sd	a0,16(s1)
}
    800058c8:	60e2                	ld	ra,24(sp)
    800058ca:	6442                	ld	s0,16(sp)
    800058cc:	64a2                	ld	s1,8(sp)
    800058ce:	6105                	addi	sp,sp,32
    800058d0:	8082                	ret
    panic("acquire");
    800058d2:	00002517          	auipc	a0,0x2
    800058d6:	e3e50513          	addi	a0,a0,-450 # 80007710 <etext+0x710>
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
    800058e6:	c78fb0ef          	jal	80000d5e <mycpu>
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
    8000591e:	dfe50513          	addi	a0,a0,-514 # 80007718 <etext+0x718>
    80005922:	cbdff0ef          	jal	800055de <panic>
    panic("pop_off");
    80005926:	00002517          	auipc	a0,0x2
    8000592a:	e0a50513          	addi	a0,a0,-502 # 80007730 <etext+0x730>
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
    80005966:	dd650513          	addi	a0,a0,-554 # 80007738 <etext+0x738>
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
