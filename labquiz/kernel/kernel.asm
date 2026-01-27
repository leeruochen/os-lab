
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
    80000004:	18813103          	ld	sp,392(sp) # 8000a188 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000016:	669040ef          	jal	80004e7e <start>

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
    80000034:	4a878793          	addi	a5,a5,1192 # 800234d8 <end>
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
    80000050:	18490913          	addi	s2,s2,388 # 8000a1d0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	065050ef          	jal	800058ba <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	0ed050ef          	jal	80005952 <release>
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
    8000007e:	580050ef          	jal	800055fe <panic>

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
    800000de:	0f650513          	addi	a0,a0,246 # 8000a1d0 <kmem>
    800000e2:	758050ef          	jal	8000583a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	3ee50513          	addi	a0,a0,1006 # 800234d8 <end>
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
    8000010c:	0c848493          	addi	s1,s1,200 # 8000a1d0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	7a8050ef          	jal	800058ba <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	0b450513          	addi	a0,a0,180 # 8000a1d0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	02d050ef          	jal	80005952 <release>

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
    80000144:	09050513          	addi	a0,a0,144 # 8000a1d0 <kmem>
    80000148:	00b050ef          	jal	80005952 <release>
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
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdbb29>
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
    800002f8:	eac70713          	addi	a4,a4,-340 # 8000a1a0 <started>
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
    80000316:	002050ef          	jal	80005318 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	576010ef          	jal	80001894 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	576040ef          	jal	80004898 <plicinithart>
  }

  scheduler();        
    80000326:	6b5000ef          	jal	800011da <scheduler>
    consoleinit();
    8000032a:	719040ef          	jal	80005242 <consoleinit>
    printfinit();
    8000032e:	30c050ef          	jal	8000563a <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	7df040ef          	jal	80005318 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	7d3040ef          	jal	80005318 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	7c7040ef          	jal	80005318 <printf>
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
    8000036e:	510040ef          	jal	8000487e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	526040ef          	jal	80004898 <plicinithart>
    binit();         // buffer cache
    80000376:	3f3010ef          	jal	80001f68 <binit>
    iinit();         // inode table
    8000037a:	178020ef          	jal	800024f2 <iinit>
    fileinit();      // file table
    8000037e:	06a030ef          	jal	800033e8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	606040ef          	jal	80004988 <virtio_disk_init>
    userinit();      // first user process
    80000386:	4bb000ef          	jal	80001040 <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	e0f72823          	sw	a5,-496(a4) # 8000a1a0 <started>
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
    800003a8:	e047b783          	ld	a5,-508(a5) # 8000a1a8 <kernel_pagetable>
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
    800003f0:	20e050ef          	jal	800055fe <panic>
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
    80000416:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdbb1f>
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
    80000506:	0f8050ef          	jal	800055fe <panic>
    panic("mappages: size not aligned");
    8000050a:	00007517          	auipc	a0,0x7
    8000050e:	b6e50513          	addi	a0,a0,-1170 # 80007078 <etext+0x78>
    80000512:	0ec050ef          	jal	800055fe <panic>
    panic("mappages: size");
    80000516:	00007517          	auipc	a0,0x7
    8000051a:	b8250513          	addi	a0,a0,-1150 # 80007098 <etext+0x98>
    8000051e:	0e0050ef          	jal	800055fe <panic>
      panic("mappages: remap");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b8650513          	addi	a0,a0,-1146 # 800070a8 <etext+0xa8>
    8000052a:	0d4050ef          	jal	800055fe <panic>
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
    8000056e:	090050ef          	jal	800055fe <panic>

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
    80000634:	b6a7bc23          	sd	a0,-1160(a5) # 8000a1a8 <kernel_pagetable>
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
    800006a8:	757040ef          	jal	800055fe <panic>
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
    80000820:	5df040ef          	jal	800055fe <panic>
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
    80000930:	4cf040ef          	jal	800055fe <panic>

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
    80000c1a:	a0a48493          	addi	s1,s1,-1526 # 8000a620 <proc>
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
    80000c46:	3dea8a93          	addi	s5,s5,990 # 80010020 <tickslock>
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
    80000c94:	16b040ef          	jal	800055fe <panic>

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
    80000cb8:	53c50513          	addi	a0,a0,1340 # 8000a1f0 <pid_lock>
    80000cbc:	37f040ef          	jal	8000583a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc0:	00006597          	auipc	a1,0x6
    80000cc4:	44858593          	addi	a1,a1,1096 # 80007108 <etext+0x108>
    80000cc8:	00009517          	auipc	a0,0x9
    80000ccc:	54050513          	addi	a0,a0,1344 # 8000a208 <wait_lock>
    80000cd0:	36b040ef          	jal	8000583a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd4:	0000a497          	auipc	s1,0xa
    80000cd8:	94c48493          	addi	s1,s1,-1716 # 8000a620 <proc>
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
    80000d0c:	318a0a13          	addi	s4,s4,792 # 80010020 <tickslock>
      initlock(&p->lock, "proc");
    80000d10:	85da                	mv	a1,s6
    80000d12:	8526                	mv	a0,s1
    80000d14:	327040ef          	jal	8000583a <initlock>
      p->state = UNUSED;
    80000d18:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d1c:	415487b3          	sub	a5,s1,s5
    80000d20:	878d                	srai	a5,a5,0x3
    80000d22:	032787b3          	mul	a5,a5,s2
    80000d26:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffdbb29>
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
    80000d6e:	4b650513          	addi	a0,a0,1206 # 8000a220 <cpus>
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
    80000d84:	2f7040ef          	jal	8000587a <push_off>
    80000d88:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d8a:	2781                	sext.w	a5,a5
    80000d8c:	079e                	slli	a5,a5,0x7
    80000d8e:	00009717          	auipc	a4,0x9
    80000d92:	46270713          	addi	a4,a4,1122 # 8000a1f0 <pid_lock>
    80000d96:	97ba                	add	a5,a5,a4
    80000d98:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d9a:	365040ef          	jal	800058fe <pop_off>
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
    80000dba:	399040ef          	jal	80005952 <release>

  if (first) {
    80000dbe:	00009797          	auipc	a5,0x9
    80000dc2:	3b27a783          	lw	a5,946(a5) # 8000a170 <first.1>
    80000dc6:	cf8d                	beqz	a5,80000e00 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dc8:	4505                	li	a0,1
    80000dca:	3e5010ef          	jal	800029ae <fsinit>

    first = 0;
    80000dce:	00009797          	auipc	a5,0x9
    80000dd2:	3a07a123          	sw	zero,930(a5) # 8000a170 <first.1>
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
    80000dee:	4c1020ef          	jal	80003aae <kexec>
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
    80000e3e:	7c0040ef          	jal	800055fe <panic>

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
    80000e52:	3a290913          	addi	s2,s2,930 # 8000a1f0 <pid_lock>
    80000e56:	854a                	mv	a0,s2
    80000e58:	263040ef          	jal	800058ba <acquire>
  pid = nextpid;
    80000e5c:	00009797          	auipc	a5,0x9
    80000e60:	31878793          	addi	a5,a5,792 # 8000a174 <nextpid>
    80000e64:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e66:	0014871b          	addiw	a4,s1,1
    80000e6a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e6c:	854a                	mv	a0,s2
    80000e6e:	2e5040ef          	jal	80005952 <release>
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
    80000faa:	67a48493          	addi	s1,s1,1658 # 8000a620 <proc>
    80000fae:	0000f917          	auipc	s2,0xf
    80000fb2:	07290913          	addi	s2,s2,114 # 80010020 <tickslock>
    acquire(&p->lock);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	103040ef          	jal	800058ba <acquire>
    if(p->state == UNUSED) {
    80000fbc:	4c9c                	lw	a5,24(s1)
    80000fbe:	cb91                	beqz	a5,80000fd2 <allocproc+0x38>
      release(&p->lock);
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	191040ef          	jal	80005952 <release>
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
    80001028:	12b040ef          	jal	80005952 <release>
    return 0;
    8000102c:	84ca                	mv	s1,s2
    8000102e:	b7d5                	j	80001012 <allocproc+0x78>
    freeproc(p);
    80001030:	8526                	mv	a0,s1
    80001032:	f19ff0ef          	jal	80000f4a <freeproc>
    release(&p->lock);
    80001036:	8526                	mv	a0,s1
    80001038:	11b040ef          	jal	80005952 <release>
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
    80001054:	16a7b023          	sd	a0,352(a5) # 8000a1b0 <initproc>
  p->cwd = namei("/");
    80001058:	00006517          	auipc	a0,0x6
    8000105c:	0d850513          	addi	a0,a0,216 # 80007130 <etext+0x130>
    80001060:	671010ef          	jal	80002ed0 <namei>
    80001064:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001068:	478d                	li	a5,3
    8000106a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000106c:	8526                	mv	a0,s1
    8000106e:	0e5040ef          	jal	80005952 <release>
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
    80001154:	7fe040ef          	jal	80005952 <release>
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
    8000116a:	300020ef          	jal	8000346a <filedup>
    8000116e:	00a93023          	sd	a0,0(s2)
    80001172:	b7f5                	j	8000115e <kfork+0x92>
  np->cwd = idup(p->cwd);
    80001174:	150ab503          	ld	a0,336(s5)
    80001178:	50c010ef          	jal	80002684 <idup>
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
    80001194:	7be040ef          	jal	80005952 <release>
  acquire(&wait_lock);
    80001198:	00009497          	auipc	s1,0x9
    8000119c:	07048493          	addi	s1,s1,112 # 8000a208 <wait_lock>
    800011a0:	8526                	mv	a0,s1
    800011a2:	718040ef          	jal	800058ba <acquire>
  np->parent = p;
    800011a6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800011aa:	8526                	mv	a0,s1
    800011ac:	7a6040ef          	jal	80005952 <release>
  acquire(&np->lock);
    800011b0:	8552                	mv	a0,s4
    800011b2:	708040ef          	jal	800058ba <acquire>
  np->state = RUNNABLE;
    800011b6:	478d                	li	a5,3
    800011b8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800011bc:	8552                	mv	a0,s4
    800011be:	794040ef          	jal	80005952 <release>
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
    800011fe:	ff670713          	addi	a4,a4,-10 # 8000a1f0 <pid_lock>
    80001202:	975a                	add	a4,a4,s6
    80001204:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001208:	00009717          	auipc	a4,0x9
    8000120c:	02070713          	addi	a4,a4,32 # 8000a228 <cpus+0x8>
    80001210:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001212:	4c11                	li	s8,4
        c->proc = p;
    80001214:	079e                	slli	a5,a5,0x7
    80001216:	00009a17          	auipc	s4,0x9
    8000121a:	fdaa0a13          	addi	s4,s4,-38 # 8000a1f0 <pid_lock>
    8000121e:	9a3e                	add	s4,s4,a5
        found = 1;
    80001220:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001222:	0000f997          	auipc	s3,0xf
    80001226:	dfe98993          	addi	s3,s3,-514 # 80010020 <tickslock>
    8000122a:	a83d                	j	80001268 <scheduler+0x8e>
      release(&p->lock);
    8000122c:	8526                	mv	a0,s1
    8000122e:	724040ef          	jal	80005952 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001232:	16848493          	addi	s1,s1,360
    80001236:	03348563          	beq	s1,s3,80001260 <scheduler+0x86>
      acquire(&p->lock);
    8000123a:	8526                	mv	a0,s1
    8000123c:	67e040ef          	jal	800058ba <acquire>
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
    80001284:	3a048493          	addi	s1,s1,928 # 8000a620 <proc>
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
    800012a0:	5b0040ef          	jal	80005850 <holding>
    800012a4:	c92d                	beqz	a0,80001316 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012a6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012a8:	2781                	sext.w	a5,a5
    800012aa:	079e                	slli	a5,a5,0x7
    800012ac:	00009717          	auipc	a4,0x9
    800012b0:	f4470713          	addi	a4,a4,-188 # 8000a1f0 <pid_lock>
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
    800012d6:	f1e90913          	addi	s2,s2,-226 # 8000a1f0 <pid_lock>
    800012da:	2781                	sext.w	a5,a5
    800012dc:	079e                	slli	a5,a5,0x7
    800012de:	97ca                	add	a5,a5,s2
    800012e0:	0ac7a983          	lw	s3,172(a5)
    800012e4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012e6:	2781                	sext.w	a5,a5
    800012e8:	079e                	slli	a5,a5,0x7
    800012ea:	00009597          	auipc	a1,0x9
    800012ee:	f3e58593          	addi	a1,a1,-194 # 8000a228 <cpus+0x8>
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
    8000131e:	2e0040ef          	jal	800055fe <panic>
    panic("sched locks");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	e2650513          	addi	a0,a0,-474 # 80007148 <etext+0x148>
    8000132a:	2d4040ef          	jal	800055fe <panic>
    panic("sched RUNNING");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	e2a50513          	addi	a0,a0,-470 # 80007158 <etext+0x158>
    80001336:	2c8040ef          	jal	800055fe <panic>
    panic("sched interruptible");
    8000133a:	00006517          	auipc	a0,0x6
    8000133e:	e2e50513          	addi	a0,a0,-466 # 80007168 <etext+0x168>
    80001342:	2bc040ef          	jal	800055fe <panic>

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
    80001356:	564040ef          	jal	800058ba <acquire>
  p->state = RUNNABLE;
    8000135a:	478d                	li	a5,3
    8000135c:	cc9c                	sw	a5,24(s1)
  sched();
    8000135e:	f2fff0ef          	jal	8000128c <sched>
  release(&p->lock);
    80001362:	8526                	mv	a0,s1
    80001364:	5ee040ef          	jal	80005952 <release>
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
    8000138a:	530040ef          	jal	800058ba <acquire>
  release(lk);
    8000138e:	854a                	mv	a0,s2
    80001390:	5c2040ef          	jal	80005952 <release>

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
    800013a6:	5ac040ef          	jal	80005952 <release>
  acquire(lk);
    800013aa:	854a                	mv	a0,s2
    800013ac:	50e040ef          	jal	800058ba <acquire>
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
    800013d6:	24e48493          	addi	s1,s1,590 # 8000a620 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013da:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013dc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013de:	0000f917          	auipc	s2,0xf
    800013e2:	c4290913          	addi	s2,s2,-958 # 80010020 <tickslock>
    800013e6:	a801                	j	800013f6 <wakeup+0x38>
      }
      release(&p->lock);
    800013e8:	8526                	mv	a0,s1
    800013ea:	568040ef          	jal	80005952 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ee:	16848493          	addi	s1,s1,360
    800013f2:	03248263          	beq	s1,s2,80001416 <wakeup+0x58>
    if(p != myproc()){
    800013f6:	985ff0ef          	jal	80000d7a <myproc>
    800013fa:	fea48ae3          	beq	s1,a0,800013ee <wakeup+0x30>
      acquire(&p->lock);
    800013fe:	8526                	mv	a0,s1
    80001400:	4ba040ef          	jal	800058ba <acquire>
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
    8000143e:	1e648493          	addi	s1,s1,486 # 8000a620 <proc>
      pp->parent = initproc;
    80001442:	00009a17          	auipc	s4,0x9
    80001446:	d6ea0a13          	addi	s4,s4,-658 # 8000a1b0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000144a:	0000f997          	auipc	s3,0xf
    8000144e:	bd698993          	addi	s3,s3,-1066 # 80010020 <tickslock>
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
    8000149a:	d1a7b783          	ld	a5,-742(a5) # 8000a1b0 <initproc>
    8000149e:	0d050493          	addi	s1,a0,208
    800014a2:	15050913          	addi	s2,a0,336
    800014a6:	00a79f63          	bne	a5,a0,800014c4 <kexit+0x46>
    panic("init exiting");
    800014aa:	00006517          	auipc	a0,0x6
    800014ae:	cd650513          	addi	a0,a0,-810 # 80007180 <etext+0x180>
    800014b2:	14c040ef          	jal	800055fe <panic>
      fileclose(f);
    800014b6:	7fb010ef          	jal	800034b0 <fileclose>
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
    800014ca:	3db010ef          	jal	800030a4 <begin_op>
  iput(p->cwd);
    800014ce:	1509b503          	ld	a0,336(s3)
    800014d2:	36a010ef          	jal	8000283c <iput>
  end_op();
    800014d6:	439010ef          	jal	8000310e <end_op>
  p->cwd = 0;
    800014da:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014de:	00009497          	auipc	s1,0x9
    800014e2:	d2a48493          	addi	s1,s1,-726 # 8000a208 <wait_lock>
    800014e6:	8526                	mv	a0,s1
    800014e8:	3d2040ef          	jal	800058ba <acquire>
  reparent(p);
    800014ec:	854e                	mv	a0,s3
    800014ee:	f3bff0ef          	jal	80001428 <reparent>
  wakeup(p->parent);
    800014f2:	0389b503          	ld	a0,56(s3)
    800014f6:	ec9ff0ef          	jal	800013be <wakeup>
  acquire(&p->lock);
    800014fa:	854e                	mv	a0,s3
    800014fc:	3be040ef          	jal	800058ba <acquire>
  p->xstate = status;
    80001500:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001504:	4795                	li	a5,5
    80001506:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	446040ef          	jal	80005952 <release>
  sched();
    80001510:	d7dff0ef          	jal	8000128c <sched>
  panic("zombie exit");
    80001514:	00006517          	auipc	a0,0x6
    80001518:	c7c50513          	addi	a0,a0,-900 # 80007190 <etext+0x190>
    8000151c:	0e2040ef          	jal	800055fe <panic>

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
    80001534:	0f048493          	addi	s1,s1,240 # 8000a620 <proc>
    80001538:	0000f997          	auipc	s3,0xf
    8000153c:	ae898993          	addi	s3,s3,-1304 # 80010020 <tickslock>
    acquire(&p->lock);
    80001540:	8526                	mv	a0,s1
    80001542:	378040ef          	jal	800058ba <acquire>
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
    8000154e:	404040ef          	jal	80005952 <release>
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
    8000156c:	3e6040ef          	jal	80005952 <release>
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
    80001592:	328040ef          	jal	800058ba <acquire>
  p->killed = 1;
    80001596:	4785                	li	a5,1
    80001598:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	3b6040ef          	jal	80005952 <release>
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
    800015b8:	302040ef          	jal	800058ba <acquire>
  k = p->killed;
    800015bc:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015c0:	8526                	mv	a0,s1
    800015c2:	390040ef          	jal	80005952 <release>
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
    800015f8:	c1450513          	addi	a0,a0,-1004 # 8000a208 <wait_lock>
    800015fc:	2be040ef          	jal	800058ba <acquire>
    havekids = 0;
    80001600:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001602:	4a15                	li	s4,5
        havekids = 1;
    80001604:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001606:	0000f997          	auipc	s3,0xf
    8000160a:	a1a98993          	addi	s3,s3,-1510 # 80010020 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000160e:	00009c17          	auipc	s8,0x9
    80001612:	bfac0c13          	addi	s8,s8,-1030 # 8000a208 <wait_lock>
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
    8000163c:	316040ef          	jal	80005952 <release>
          release(&wait_lock);
    80001640:	00009517          	auipc	a0,0x9
    80001644:	bc850513          	addi	a0,a0,-1080 # 8000a208 <wait_lock>
    80001648:	30a040ef          	jal	80005952 <release>
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
    80001668:	2ea040ef          	jal	80005952 <release>
            release(&wait_lock);
    8000166c:	00009517          	auipc	a0,0x9
    80001670:	b9c50513          	addi	a0,a0,-1124 # 8000a208 <wait_lock>
    80001674:	2de040ef          	jal	80005952 <release>
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
    8000168c:	22e040ef          	jal	800058ba <acquire>
        if(pp->state == ZOMBIE){
    80001690:	4c9c                	lw	a5,24(s1)
    80001692:	f94783e3          	beq	a5,s4,80001618 <kwait+0x44>
        release(&pp->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	2ba040ef          	jal	80005952 <release>
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
    800016b8:	f6c48493          	addi	s1,s1,-148 # 8000a620 <proc>
    800016bc:	b7e1                	j	80001684 <kwait+0xb0>
      release(&wait_lock);
    800016be:	00009517          	auipc	a0,0x9
    800016c2:	b4a50513          	addi	a0,a0,-1206 # 8000a208 <wait_lock>
    800016c6:	28c040ef          	jal	80005952 <release>
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
    80001780:	399030ef          	jal	80005318 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001784:	00009497          	auipc	s1,0x9
    80001788:	ff448493          	addi	s1,s1,-12 # 8000a778 <proc+0x158>
    8000178c:	0000f917          	auipc	s2,0xf
    80001790:	9ec90913          	addi	s2,s2,-1556 # 80010178 <bcache+0x140>
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
    800017b2:	f62b8b93          	addi	s7,s7,-158 # 80007710 <states.0>
    800017b6:	a829                	j	800017d0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017b8:	ed86a583          	lw	a1,-296(a3)
    800017bc:	8556                	mv	a0,s5
    800017be:	35b030ef          	jal	80005318 <printf>
    printf("\n");
    800017c2:	8552                	mv	a0,s4
    800017c4:	355030ef          	jal	80005318 <printf>
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
    80001884:	7a050513          	addi	a0,a0,1952 # 80010020 <tickslock>
    80001888:	7b3030ef          	jal	8000583a <initlock>
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
    8000189e:	f8678793          	addi	a5,a5,-122 # 80004820 <kernelvec>
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
    80001954:	6d048493          	addi	s1,s1,1744 # 80010020 <tickslock>
    80001958:	8526                	mv	a0,s1
    8000195a:	761030ef          	jal	800058ba <acquire>
    ticks++;
    8000195e:	00009517          	auipc	a0,0x9
    80001962:	85a50513          	addi	a0,a0,-1958 # 8000a1b8 <ticks>
    80001966:	411c                	lw	a5,0(a0)
    80001968:	2785                	addiw	a5,a5,1
    8000196a:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000196c:	a53ff0ef          	jal	800013be <wakeup>
    release(&tickslock);
    80001970:	8526                	mv	a0,s1
    80001972:	7e1030ef          	jal	80005952 <release>
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
    800019a6:	727020ef          	jal	800048cc <plic_claim>
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
    800019c0:	60f030ef          	jal	800057ce <uartintr>
    if(irq)
    800019c4:	a819                	j	800019da <devintr+0x60>
      virtio_disk_intr();
    800019c6:	3cc030ef          	jal	80004d92 <virtio_disk_intr>
    if(irq)
    800019ca:	a801                	j	800019da <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019cc:	85a6                	mv	a1,s1
    800019ce:	00006517          	auipc	a0,0x6
    800019d2:	82250513          	addi	a0,a0,-2014 # 800071f0 <etext+0x1f0>
    800019d6:	143030ef          	jal	80005318 <printf>
      plic_complete(irq);
    800019da:	8526                	mv	a0,s1
    800019dc:	711020ef          	jal	800048ec <plic_complete>
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
    80001a08:	e1c78793          	addi	a5,a5,-484 # 80004820 <kernelvec>
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
    80001a52:	0c7030ef          	jal	80005318 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a56:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a5a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a5e:	00006517          	auipc	a0,0x6
    80001a62:	80250513          	addi	a0,a0,-2046 # 80007260 <etext+0x260>
    80001a66:	0b3030ef          	jal	80005318 <printf>
    setkilled(p);
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	b1bff0ef          	jal	80001586 <setkilled>
    80001a70:	a035                	j	80001a9c <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a72:	00005517          	auipc	a0,0x5
    80001a76:	79e50513          	addi	a0,a0,1950 # 80007210 <etext+0x210>
    80001a7a:	385030ef          	jal	800055fe <panic>
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
    80001b4e:	2b1030ef          	jal	800055fe <panic>
    panic("kerneltrap: interrupts enabled");
    80001b52:	00005517          	auipc	a0,0x5
    80001b56:	75e50513          	addi	a0,a0,1886 # 800072b0 <etext+0x2b0>
    80001b5a:	2a5030ef          	jal	800055fe <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b5e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b62:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b66:	85ce                	mv	a1,s3
    80001b68:	00005517          	auipc	a0,0x5
    80001b6c:	76850513          	addi	a0,a0,1896 # 800072d0 <etext+0x2d0>
    80001b70:	7a8030ef          	jal	80005318 <printf>
    panic("kerneltrap");
    80001b74:	00005517          	auipc	a0,0x5
    80001b78:	78450513          	addi	a0,a0,1924 # 800072f8 <etext+0x2f8>
    80001b7c:	283030ef          	jal	800055fe <panic>
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
    80001ba8:	b9c70713          	addi	a4,a4,-1124 # 80007740 <states.0+0x30>
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
    80001be8:	217030ef          	jal	800055fe <panic>

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
    [SYS_endianswap] sys_endianswap,
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
    80001cfe:	4755                	li	a4,21
    80001d00:	00f76f63          	bltu	a4,a5,80001d1e <syscall+0x40>
    80001d04:	00369713          	slli	a4,a3,0x3
    80001d08:	00006797          	auipc	a5,0x6
    80001d0c:	a5078793          	addi	a5,a5,-1456 # 80007758 <syscalls>
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
    80001d2c:	5ec030ef          	jal	80005318 <printf>
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
    80001e3e:	1e650513          	addi	a0,a0,486 # 80010020 <tickslock>
    80001e42:	279030ef          	jal	800058ba <acquire>
  ticks0 = ticks;
    80001e46:	00008917          	auipc	s2,0x8
    80001e4a:	37292903          	lw	s2,882(s2) # 8000a1b8 <ticks>
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
    80001e5c:	1c898993          	addi	s3,s3,456 # 80010020 <tickslock>
    80001e60:	00008497          	auipc	s1,0x8
    80001e64:	35848493          	addi	s1,s1,856 # 8000a1b8 <ticks>
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
    80001e90:	19450513          	addi	a0,a0,404 # 80010020 <tickslock>
    80001e94:	2bf030ef          	jal	80005952 <release>
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
    80001eae:	17650513          	addi	a0,a0,374 # 80010020 <tickslock>
    80001eb2:	2a1030ef          	jal	80005952 <release>
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
    80001eee:	13650513          	addi	a0,a0,310 # 80010020 <tickslock>
    80001ef2:	1c9030ef          	jal	800058ba <acquire>
  xticks = ticks;
    80001ef6:	00008497          	auipc	s1,0x8
    80001efa:	2c24a483          	lw	s1,706(s1) # 8000a1b8 <ticks>
  release(&tickslock);
    80001efe:	0000e517          	auipc	a0,0xe
    80001f02:	12250513          	addi	a0,a0,290 # 80010020 <tickslock>
    80001f06:	24d030ef          	jal	80005952 <release>
  return xticks;
}
    80001f0a:	02049513          	slli	a0,s1,0x20
    80001f0e:	9101                	srli	a0,a0,0x20
    80001f10:	60e2                	ld	ra,24(sp)
    80001f12:	6442                	ld	s0,16(sp)
    80001f14:	64a2                	ld	s1,8(sp)
    80001f16:	6105                	addi	sp,sp,32
    80001f18:	8082                	ret

0000000080001f1a <sys_endianswap>:

uint64
sys_endianswap(void)
{
    80001f1a:	1101                	addi	sp,sp,-32
    80001f1c:	ec06                	sd	ra,24(sp)
    80001f1e:	e822                	sd	s0,16(sp)
    80001f20:	1000                	addi	s0,sp,32
  int n;
  uint result;

  argint(0, &n); // since only one argument is passed in, it will be in register a0. if more arguments are passed, they will be in a1, a2, etc.
    80001f22:	fec40593          	addi	a1,s0,-20
    80001f26:	4501                	li	a0,0
    80001f28:	d4fff0ef          	jal	80001c76 <argint>
                 // first parameter of argint represents the registers, so 0 will be a0

  uint x = (uint)n;
    80001f2c:	fec42783          	lw	a5,-20(s0)

  // when we do 0xFF, we get the last 8 bits of x
  // we use | to combine the bits together, it is an OR operation, so if 0x78000000 | 0x00670000 = 0x78670000, it does this for all 4 bytes
  result = ((x & 0xFF) << 24) | // we first do x & 0xFF to get the last 8 bits, then we shift it left by 24 bits to put it in the first 8 bits position
           ((x >> 8) & 0xFF) << 16 | // we first shift x right by 8 bits to get rid of the last 8 bits, then we do & 0xFF to get the next 8 bits, then we shift it left by 16 bits to put it in the second 8 bits position
    80001f30:	0087d51b          	srliw	a0,a5,0x8
    80001f34:	0105151b          	slliw	a0,a0,0x10
    80001f38:	00ff0737          	lui	a4,0xff0
    80001f3c:	8d79                	and	a0,a0,a4
  result = ((x & 0xFF) << 24) | // we first do x & 0xFF to get the last 8 bits, then we shift it left by 24 bits to put it in the first 8 bits position
    80001f3e:	0187971b          	slliw	a4,a5,0x18
           ((x >> 16) & 0xFF) << 8 | // we first shift x right by 16 bits to get rid of the last 16 bits, then we do & 0xFF to get the next 8 bits, then we shift it left by 8 bits to put it in the third 8 bits position
           ((x >> 24) & 0xFF); // we first shift x right by 24 bits to get rid of the last 24 bits, then we do & 0xFF to get the first 8 bits, which is now in the last 8 bits position
    80001f42:	0187d69b          	srliw	a3,a5,0x18
  result = ((x & 0xFF) << 24) | // we first do x & 0xFF to get the last 8 bits, then we shift it left by 24 bits to put it in the first 8 bits position
    80001f46:	8f55                	or	a4,a4,a3
    80001f48:	8d59                	or	a0,a0,a4
           ((x >> 16) & 0xFF) << 8 | // we first shift x right by 16 bits to get rid of the last 16 bits, then we do & 0xFF to get the next 8 bits, then we shift it left by 8 bits to put it in the third 8 bits position
    80001f4a:	0107d79b          	srliw	a5,a5,0x10
    80001f4e:	0087979b          	slliw	a5,a5,0x8
    80001f52:	6741                	lui	a4,0x10
    80001f54:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80001f58:	8ff9                	and	a5,a5,a4
  result = ((x & 0xFF) << 24) | // we first do x & 0xFF to get the last 8 bits, then we shift it left by 24 bits to put it in the first 8 bits position
    80001f5a:	8d5d                	or	a0,a0,a5

  return result;
    80001f5c:	1502                	slli	a0,a0,0x20
    80001f5e:	9101                	srli	a0,a0,0x20
    80001f60:	60e2                	ld	ra,24(sp)
    80001f62:	6442                	ld	s0,16(sp)
    80001f64:	6105                	addi	sp,sp,32
    80001f66:	8082                	ret

0000000080001f68 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f68:	7179                	addi	sp,sp,-48
    80001f6a:	f406                	sd	ra,40(sp)
    80001f6c:	f022                	sd	s0,32(sp)
    80001f6e:	ec26                	sd	s1,24(sp)
    80001f70:	e84a                	sd	s2,16(sp)
    80001f72:	e44e                	sd	s3,8(sp)
    80001f74:	e052                	sd	s4,0(sp)
    80001f76:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f78:	00005597          	auipc	a1,0x5
    80001f7c:	3b858593          	addi	a1,a1,952 # 80007330 <etext+0x330>
    80001f80:	0000e517          	auipc	a0,0xe
    80001f84:	0b850513          	addi	a0,a0,184 # 80010038 <bcache>
    80001f88:	0b3030ef          	jal	8000583a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f8c:	00016797          	auipc	a5,0x16
    80001f90:	0ac78793          	addi	a5,a5,172 # 80018038 <bcache+0x8000>
    80001f94:	00016717          	auipc	a4,0x16
    80001f98:	30c70713          	addi	a4,a4,780 # 800182a0 <bcache+0x8268>
    80001f9c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fa0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fa4:	0000e497          	auipc	s1,0xe
    80001fa8:	0ac48493          	addi	s1,s1,172 # 80010050 <bcache+0x18>
    b->next = bcache.head.next;
    80001fac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001fae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001fb0:	00005a17          	auipc	s4,0x5
    80001fb4:	388a0a13          	addi	s4,s4,904 # 80007338 <etext+0x338>
    b->next = bcache.head.next;
    80001fb8:	2b893783          	ld	a5,696(s2)
    80001fbc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001fbe:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001fc2:	85d2                	mv	a1,s4
    80001fc4:	01048513          	addi	a0,s1,16
    80001fc8:	322010ef          	jal	800032ea <initsleeplock>
    bcache.head.next->prev = b;
    80001fcc:	2b893783          	ld	a5,696(s2)
    80001fd0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001fd2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fd6:	45848493          	addi	s1,s1,1112
    80001fda:	fd349fe3          	bne	s1,s3,80001fb8 <binit+0x50>
  }
}
    80001fde:	70a2                	ld	ra,40(sp)
    80001fe0:	7402                	ld	s0,32(sp)
    80001fe2:	64e2                	ld	s1,24(sp)
    80001fe4:	6942                	ld	s2,16(sp)
    80001fe6:	69a2                	ld	s3,8(sp)
    80001fe8:	6a02                	ld	s4,0(sp)
    80001fea:	6145                	addi	sp,sp,48
    80001fec:	8082                	ret

0000000080001fee <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001fee:	7179                	addi	sp,sp,-48
    80001ff0:	f406                	sd	ra,40(sp)
    80001ff2:	f022                	sd	s0,32(sp)
    80001ff4:	ec26                	sd	s1,24(sp)
    80001ff6:	e84a                	sd	s2,16(sp)
    80001ff8:	e44e                	sd	s3,8(sp)
    80001ffa:	1800                	addi	s0,sp,48
    80001ffc:	892a                	mv	s2,a0
    80001ffe:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002000:	0000e517          	auipc	a0,0xe
    80002004:	03850513          	addi	a0,a0,56 # 80010038 <bcache>
    80002008:	0b3030ef          	jal	800058ba <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000200c:	00016497          	auipc	s1,0x16
    80002010:	2e44b483          	ld	s1,740(s1) # 800182f0 <bcache+0x82b8>
    80002014:	00016797          	auipc	a5,0x16
    80002018:	28c78793          	addi	a5,a5,652 # 800182a0 <bcache+0x8268>
    8000201c:	02f48b63          	beq	s1,a5,80002052 <bread+0x64>
    80002020:	873e                	mv	a4,a5
    80002022:	a021                	j	8000202a <bread+0x3c>
    80002024:	68a4                	ld	s1,80(s1)
    80002026:	02e48663          	beq	s1,a4,80002052 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000202a:	449c                	lw	a5,8(s1)
    8000202c:	ff279ce3          	bne	a5,s2,80002024 <bread+0x36>
    80002030:	44dc                	lw	a5,12(s1)
    80002032:	ff3799e3          	bne	a5,s3,80002024 <bread+0x36>
      b->refcnt++;
    80002036:	40bc                	lw	a5,64(s1)
    80002038:	2785                	addiw	a5,a5,1
    8000203a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000203c:	0000e517          	auipc	a0,0xe
    80002040:	ffc50513          	addi	a0,a0,-4 # 80010038 <bcache>
    80002044:	10f030ef          	jal	80005952 <release>
      acquiresleep(&b->lock);
    80002048:	01048513          	addi	a0,s1,16
    8000204c:	2d4010ef          	jal	80003320 <acquiresleep>
      return b;
    80002050:	a889                	j	800020a2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002052:	00016497          	auipc	s1,0x16
    80002056:	2964b483          	ld	s1,662(s1) # 800182e8 <bcache+0x82b0>
    8000205a:	00016797          	auipc	a5,0x16
    8000205e:	24678793          	addi	a5,a5,582 # 800182a0 <bcache+0x8268>
    80002062:	00f48863          	beq	s1,a5,80002072 <bread+0x84>
    80002066:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002068:	40bc                	lw	a5,64(s1)
    8000206a:	cb91                	beqz	a5,8000207e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000206c:	64a4                	ld	s1,72(s1)
    8000206e:	fee49de3          	bne	s1,a4,80002068 <bread+0x7a>
  panic("bget: no buffers");
    80002072:	00005517          	auipc	a0,0x5
    80002076:	2ce50513          	addi	a0,a0,718 # 80007340 <etext+0x340>
    8000207a:	584030ef          	jal	800055fe <panic>
      b->dev = dev;
    8000207e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002082:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002086:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000208a:	4785                	li	a5,1
    8000208c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000208e:	0000e517          	auipc	a0,0xe
    80002092:	faa50513          	addi	a0,a0,-86 # 80010038 <bcache>
    80002096:	0bd030ef          	jal	80005952 <release>
      acquiresleep(&b->lock);
    8000209a:	01048513          	addi	a0,s1,16
    8000209e:	282010ef          	jal	80003320 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020a2:	409c                	lw	a5,0(s1)
    800020a4:	cb89                	beqz	a5,800020b6 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020a6:	8526                	mv	a0,s1
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6942                	ld	s2,16(sp)
    800020b0:	69a2                	ld	s3,8(sp)
    800020b2:	6145                	addi	sp,sp,48
    800020b4:	8082                	ret
    virtio_disk_rw(b, 0);
    800020b6:	4581                	li	a1,0
    800020b8:	8526                	mv	a0,s1
    800020ba:	2c7020ef          	jal	80004b80 <virtio_disk_rw>
    b->valid = 1;
    800020be:	4785                	li	a5,1
    800020c0:	c09c                	sw	a5,0(s1)
  return b;
    800020c2:	b7d5                	j	800020a6 <bread+0xb8>

00000000800020c4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020c4:	1101                	addi	sp,sp,-32
    800020c6:	ec06                	sd	ra,24(sp)
    800020c8:	e822                	sd	s0,16(sp)
    800020ca:	e426                	sd	s1,8(sp)
    800020cc:	1000                	addi	s0,sp,32
    800020ce:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020d0:	0541                	addi	a0,a0,16
    800020d2:	2cc010ef          	jal	8000339e <holdingsleep>
    800020d6:	c911                	beqz	a0,800020ea <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020d8:	4585                	li	a1,1
    800020da:	8526                	mv	a0,s1
    800020dc:	2a5020ef          	jal	80004b80 <virtio_disk_rw>
}
    800020e0:	60e2                	ld	ra,24(sp)
    800020e2:	6442                	ld	s0,16(sp)
    800020e4:	64a2                	ld	s1,8(sp)
    800020e6:	6105                	addi	sp,sp,32
    800020e8:	8082                	ret
    panic("bwrite");
    800020ea:	00005517          	auipc	a0,0x5
    800020ee:	26e50513          	addi	a0,a0,622 # 80007358 <etext+0x358>
    800020f2:	50c030ef          	jal	800055fe <panic>

00000000800020f6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	e04a                	sd	s2,0(sp)
    80002100:	1000                	addi	s0,sp,32
    80002102:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002104:	01050913          	addi	s2,a0,16
    80002108:	854a                	mv	a0,s2
    8000210a:	294010ef          	jal	8000339e <holdingsleep>
    8000210e:	c135                	beqz	a0,80002172 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002110:	854a                	mv	a0,s2
    80002112:	254010ef          	jal	80003366 <releasesleep>

  acquire(&bcache.lock);
    80002116:	0000e517          	auipc	a0,0xe
    8000211a:	f2250513          	addi	a0,a0,-222 # 80010038 <bcache>
    8000211e:	79c030ef          	jal	800058ba <acquire>
  b->refcnt--;
    80002122:	40bc                	lw	a5,64(s1)
    80002124:	37fd                	addiw	a5,a5,-1
    80002126:	0007871b          	sext.w	a4,a5
    8000212a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000212c:	e71d                	bnez	a4,8000215a <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000212e:	68b8                	ld	a4,80(s1)
    80002130:	64bc                	ld	a5,72(s1)
    80002132:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002134:	68b8                	ld	a4,80(s1)
    80002136:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002138:	00016797          	auipc	a5,0x16
    8000213c:	f0078793          	addi	a5,a5,-256 # 80018038 <bcache+0x8000>
    80002140:	2b87b703          	ld	a4,696(a5)
    80002144:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002146:	00016717          	auipc	a4,0x16
    8000214a:	15a70713          	addi	a4,a4,346 # 800182a0 <bcache+0x8268>
    8000214e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002150:	2b87b703          	ld	a4,696(a5)
    80002154:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002156:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000215a:	0000e517          	auipc	a0,0xe
    8000215e:	ede50513          	addi	a0,a0,-290 # 80010038 <bcache>
    80002162:	7f0030ef          	jal	80005952 <release>
}
    80002166:	60e2                	ld	ra,24(sp)
    80002168:	6442                	ld	s0,16(sp)
    8000216a:	64a2                	ld	s1,8(sp)
    8000216c:	6902                	ld	s2,0(sp)
    8000216e:	6105                	addi	sp,sp,32
    80002170:	8082                	ret
    panic("brelse");
    80002172:	00005517          	auipc	a0,0x5
    80002176:	1ee50513          	addi	a0,a0,494 # 80007360 <etext+0x360>
    8000217a:	484030ef          	jal	800055fe <panic>

000000008000217e <bpin>:

void
bpin(struct buf *b) {
    8000217e:	1101                	addi	sp,sp,-32
    80002180:	ec06                	sd	ra,24(sp)
    80002182:	e822                	sd	s0,16(sp)
    80002184:	e426                	sd	s1,8(sp)
    80002186:	1000                	addi	s0,sp,32
    80002188:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000218a:	0000e517          	auipc	a0,0xe
    8000218e:	eae50513          	addi	a0,a0,-338 # 80010038 <bcache>
    80002192:	728030ef          	jal	800058ba <acquire>
  b->refcnt++;
    80002196:	40bc                	lw	a5,64(s1)
    80002198:	2785                	addiw	a5,a5,1
    8000219a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000219c:	0000e517          	auipc	a0,0xe
    800021a0:	e9c50513          	addi	a0,a0,-356 # 80010038 <bcache>
    800021a4:	7ae030ef          	jal	80005952 <release>
}
    800021a8:	60e2                	ld	ra,24(sp)
    800021aa:	6442                	ld	s0,16(sp)
    800021ac:	64a2                	ld	s1,8(sp)
    800021ae:	6105                	addi	sp,sp,32
    800021b0:	8082                	ret

00000000800021b2 <bunpin>:

void
bunpin(struct buf *b) {
    800021b2:	1101                	addi	sp,sp,-32
    800021b4:	ec06                	sd	ra,24(sp)
    800021b6:	e822                	sd	s0,16(sp)
    800021b8:	e426                	sd	s1,8(sp)
    800021ba:	1000                	addi	s0,sp,32
    800021bc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021be:	0000e517          	auipc	a0,0xe
    800021c2:	e7a50513          	addi	a0,a0,-390 # 80010038 <bcache>
    800021c6:	6f4030ef          	jal	800058ba <acquire>
  b->refcnt--;
    800021ca:	40bc                	lw	a5,64(s1)
    800021cc:	37fd                	addiw	a5,a5,-1
    800021ce:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021d0:	0000e517          	auipc	a0,0xe
    800021d4:	e6850513          	addi	a0,a0,-408 # 80010038 <bcache>
    800021d8:	77a030ef          	jal	80005952 <release>
}
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	64a2                	ld	s1,8(sp)
    800021e2:	6105                	addi	sp,sp,32
    800021e4:	8082                	ret

00000000800021e6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800021e6:	1101                	addi	sp,sp,-32
    800021e8:	ec06                	sd	ra,24(sp)
    800021ea:	e822                	sd	s0,16(sp)
    800021ec:	e426                	sd	s1,8(sp)
    800021ee:	e04a                	sd	s2,0(sp)
    800021f0:	1000                	addi	s0,sp,32
    800021f2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021f4:	00d5d59b          	srliw	a1,a1,0xd
    800021f8:	00016797          	auipc	a5,0x16
    800021fc:	51c7a783          	lw	a5,1308(a5) # 80018714 <sb+0x1c>
    80002200:	9dbd                	addw	a1,a1,a5
    80002202:	dedff0ef          	jal	80001fee <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002206:	0074f713          	andi	a4,s1,7
    8000220a:	4785                	li	a5,1
    8000220c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002210:	14ce                	slli	s1,s1,0x33
    80002212:	90d9                	srli	s1,s1,0x36
    80002214:	00950733          	add	a4,a0,s1
    80002218:	05874703          	lbu	a4,88(a4)
    8000221c:	00e7f6b3          	and	a3,a5,a4
    80002220:	c29d                	beqz	a3,80002246 <bfree+0x60>
    80002222:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002224:	94aa                	add	s1,s1,a0
    80002226:	fff7c793          	not	a5,a5
    8000222a:	8f7d                	and	a4,a4,a5
    8000222c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002230:	7f9000ef          	jal	80003228 <log_write>
  brelse(bp);
    80002234:	854a                	mv	a0,s2
    80002236:	ec1ff0ef          	jal	800020f6 <brelse>
}
    8000223a:	60e2                	ld	ra,24(sp)
    8000223c:	6442                	ld	s0,16(sp)
    8000223e:	64a2                	ld	s1,8(sp)
    80002240:	6902                	ld	s2,0(sp)
    80002242:	6105                	addi	sp,sp,32
    80002244:	8082                	ret
    panic("freeing free block");
    80002246:	00005517          	auipc	a0,0x5
    8000224a:	12250513          	addi	a0,a0,290 # 80007368 <etext+0x368>
    8000224e:	3b0030ef          	jal	800055fe <panic>

0000000080002252 <balloc>:
{
    80002252:	711d                	addi	sp,sp,-96
    80002254:	ec86                	sd	ra,88(sp)
    80002256:	e8a2                	sd	s0,80(sp)
    80002258:	e4a6                	sd	s1,72(sp)
    8000225a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000225c:	00016797          	auipc	a5,0x16
    80002260:	4a07a783          	lw	a5,1184(a5) # 800186fc <sb+0x4>
    80002264:	0e078f63          	beqz	a5,80002362 <balloc+0x110>
    80002268:	e0ca                	sd	s2,64(sp)
    8000226a:	fc4e                	sd	s3,56(sp)
    8000226c:	f852                	sd	s4,48(sp)
    8000226e:	f456                	sd	s5,40(sp)
    80002270:	f05a                	sd	s6,32(sp)
    80002272:	ec5e                	sd	s7,24(sp)
    80002274:	e862                	sd	s8,16(sp)
    80002276:	e466                	sd	s9,8(sp)
    80002278:	8baa                	mv	s7,a0
    8000227a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000227c:	00016b17          	auipc	s6,0x16
    80002280:	47cb0b13          	addi	s6,s6,1148 # 800186f8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002284:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002286:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002288:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000228a:	6c89                	lui	s9,0x2
    8000228c:	a0b5                	j	800022f8 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000228e:	97ca                	add	a5,a5,s2
    80002290:	8e55                	or	a2,a2,a3
    80002292:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002296:	854a                	mv	a0,s2
    80002298:	791000ef          	jal	80003228 <log_write>
        brelse(bp);
    8000229c:	854a                	mv	a0,s2
    8000229e:	e59ff0ef          	jal	800020f6 <brelse>
  bp = bread(dev, bno);
    800022a2:	85a6                	mv	a1,s1
    800022a4:	855e                	mv	a0,s7
    800022a6:	d49ff0ef          	jal	80001fee <bread>
    800022aa:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022ac:	40000613          	li	a2,1024
    800022b0:	4581                	li	a1,0
    800022b2:	05850513          	addi	a0,a0,88
    800022b6:	e99fd0ef          	jal	8000014e <memset>
  log_write(bp);
    800022ba:	854a                	mv	a0,s2
    800022bc:	76d000ef          	jal	80003228 <log_write>
  brelse(bp);
    800022c0:	854a                	mv	a0,s2
    800022c2:	e35ff0ef          	jal	800020f6 <brelse>
}
    800022c6:	6906                	ld	s2,64(sp)
    800022c8:	79e2                	ld	s3,56(sp)
    800022ca:	7a42                	ld	s4,48(sp)
    800022cc:	7aa2                	ld	s5,40(sp)
    800022ce:	7b02                	ld	s6,32(sp)
    800022d0:	6be2                	ld	s7,24(sp)
    800022d2:	6c42                	ld	s8,16(sp)
    800022d4:	6ca2                	ld	s9,8(sp)
}
    800022d6:	8526                	mv	a0,s1
    800022d8:	60e6                	ld	ra,88(sp)
    800022da:	6446                	ld	s0,80(sp)
    800022dc:	64a6                	ld	s1,72(sp)
    800022de:	6125                	addi	sp,sp,96
    800022e0:	8082                	ret
    brelse(bp);
    800022e2:	854a                	mv	a0,s2
    800022e4:	e13ff0ef          	jal	800020f6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800022e8:	015c87bb          	addw	a5,s9,s5
    800022ec:	00078a9b          	sext.w	s5,a5
    800022f0:	004b2703          	lw	a4,4(s6)
    800022f4:	04eaff63          	bgeu	s5,a4,80002352 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800022f8:	41fad79b          	sraiw	a5,s5,0x1f
    800022fc:	0137d79b          	srliw	a5,a5,0x13
    80002300:	015787bb          	addw	a5,a5,s5
    80002304:	40d7d79b          	sraiw	a5,a5,0xd
    80002308:	01cb2583          	lw	a1,28(s6)
    8000230c:	9dbd                	addw	a1,a1,a5
    8000230e:	855e                	mv	a0,s7
    80002310:	cdfff0ef          	jal	80001fee <bread>
    80002314:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002316:	004b2503          	lw	a0,4(s6)
    8000231a:	000a849b          	sext.w	s1,s5
    8000231e:	8762                	mv	a4,s8
    80002320:	fca4f1e3          	bgeu	s1,a0,800022e2 <balloc+0x90>
      m = 1 << (bi % 8);
    80002324:	00777693          	andi	a3,a4,7
    80002328:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000232c:	41f7579b          	sraiw	a5,a4,0x1f
    80002330:	01d7d79b          	srliw	a5,a5,0x1d
    80002334:	9fb9                	addw	a5,a5,a4
    80002336:	4037d79b          	sraiw	a5,a5,0x3
    8000233a:	00f90633          	add	a2,s2,a5
    8000233e:	05864603          	lbu	a2,88(a2)
    80002342:	00c6f5b3          	and	a1,a3,a2
    80002346:	d5a1                	beqz	a1,8000228e <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002348:	2705                	addiw	a4,a4,1
    8000234a:	2485                	addiw	s1,s1,1
    8000234c:	fd471ae3          	bne	a4,s4,80002320 <balloc+0xce>
    80002350:	bf49                	j	800022e2 <balloc+0x90>
    80002352:	6906                	ld	s2,64(sp)
    80002354:	79e2                	ld	s3,56(sp)
    80002356:	7a42                	ld	s4,48(sp)
    80002358:	7aa2                	ld	s5,40(sp)
    8000235a:	7b02                	ld	s6,32(sp)
    8000235c:	6be2                	ld	s7,24(sp)
    8000235e:	6c42                	ld	s8,16(sp)
    80002360:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002362:	00005517          	auipc	a0,0x5
    80002366:	01e50513          	addi	a0,a0,30 # 80007380 <etext+0x380>
    8000236a:	7af020ef          	jal	80005318 <printf>
  return 0;
    8000236e:	4481                	li	s1,0
    80002370:	b79d                	j	800022d6 <balloc+0x84>

0000000080002372 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002372:	7179                	addi	sp,sp,-48
    80002374:	f406                	sd	ra,40(sp)
    80002376:	f022                	sd	s0,32(sp)
    80002378:	ec26                	sd	s1,24(sp)
    8000237a:	e84a                	sd	s2,16(sp)
    8000237c:	e44e                	sd	s3,8(sp)
    8000237e:	1800                	addi	s0,sp,48
    80002380:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002382:	47ad                	li	a5,11
    80002384:	02b7e663          	bltu	a5,a1,800023b0 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80002388:	02059793          	slli	a5,a1,0x20
    8000238c:	01e7d593          	srli	a1,a5,0x1e
    80002390:	00b504b3          	add	s1,a0,a1
    80002394:	0504a903          	lw	s2,80(s1)
    80002398:	06091a63          	bnez	s2,8000240c <bmap+0x9a>
      addr = balloc(ip->dev);
    8000239c:	4108                	lw	a0,0(a0)
    8000239e:	eb5ff0ef          	jal	80002252 <balloc>
    800023a2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023a6:	06090363          	beqz	s2,8000240c <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800023aa:	0524a823          	sw	s2,80(s1)
    800023ae:	a8b9                	j	8000240c <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023b0:	ff45849b          	addiw	s1,a1,-12
    800023b4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023b8:	0ff00793          	li	a5,255
    800023bc:	06e7ee63          	bltu	a5,a4,80002438 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023c0:	08052903          	lw	s2,128(a0)
    800023c4:	00091d63          	bnez	s2,800023de <bmap+0x6c>
      addr = balloc(ip->dev);
    800023c8:	4108                	lw	a0,0(a0)
    800023ca:	e89ff0ef          	jal	80002252 <balloc>
    800023ce:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023d2:	02090d63          	beqz	s2,8000240c <bmap+0x9a>
    800023d6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023d8:	0929a023          	sw	s2,128(s3)
    800023dc:	a011                	j	800023e0 <bmap+0x6e>
    800023de:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023e0:	85ca                	mv	a1,s2
    800023e2:	0009a503          	lw	a0,0(s3)
    800023e6:	c09ff0ef          	jal	80001fee <bread>
    800023ea:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023ec:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023f0:	02049713          	slli	a4,s1,0x20
    800023f4:	01e75593          	srli	a1,a4,0x1e
    800023f8:	00b784b3          	add	s1,a5,a1
    800023fc:	0004a903          	lw	s2,0(s1)
    80002400:	00090e63          	beqz	s2,8000241c <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002404:	8552                	mv	a0,s4
    80002406:	cf1ff0ef          	jal	800020f6 <brelse>
    return addr;
    8000240a:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000240c:	854a                	mv	a0,s2
    8000240e:	70a2                	ld	ra,40(sp)
    80002410:	7402                	ld	s0,32(sp)
    80002412:	64e2                	ld	s1,24(sp)
    80002414:	6942                	ld	s2,16(sp)
    80002416:	69a2                	ld	s3,8(sp)
    80002418:	6145                	addi	sp,sp,48
    8000241a:	8082                	ret
      addr = balloc(ip->dev);
    8000241c:	0009a503          	lw	a0,0(s3)
    80002420:	e33ff0ef          	jal	80002252 <balloc>
    80002424:	0005091b          	sext.w	s2,a0
      if(addr){
    80002428:	fc090ee3          	beqz	s2,80002404 <bmap+0x92>
        a[bn] = addr;
    8000242c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002430:	8552                	mv	a0,s4
    80002432:	5f7000ef          	jal	80003228 <log_write>
    80002436:	b7f9                	j	80002404 <bmap+0x92>
    80002438:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000243a:	00005517          	auipc	a0,0x5
    8000243e:	f5e50513          	addi	a0,a0,-162 # 80007398 <etext+0x398>
    80002442:	1bc030ef          	jal	800055fe <panic>

0000000080002446 <iget>:
{
    80002446:	7179                	addi	sp,sp,-48
    80002448:	f406                	sd	ra,40(sp)
    8000244a:	f022                	sd	s0,32(sp)
    8000244c:	ec26                	sd	s1,24(sp)
    8000244e:	e84a                	sd	s2,16(sp)
    80002450:	e44e                	sd	s3,8(sp)
    80002452:	e052                	sd	s4,0(sp)
    80002454:	1800                	addi	s0,sp,48
    80002456:	89aa                	mv	s3,a0
    80002458:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000245a:	00016517          	auipc	a0,0x16
    8000245e:	2be50513          	addi	a0,a0,702 # 80018718 <itable>
    80002462:	458030ef          	jal	800058ba <acquire>
  empty = 0;
    80002466:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002468:	00016497          	auipc	s1,0x16
    8000246c:	2c848493          	addi	s1,s1,712 # 80018730 <itable+0x18>
    80002470:	00018697          	auipc	a3,0x18
    80002474:	d5068693          	addi	a3,a3,-688 # 8001a1c0 <log>
    80002478:	a039                	j	80002486 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000247a:	02090963          	beqz	s2,800024ac <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000247e:	08848493          	addi	s1,s1,136
    80002482:	02d48863          	beq	s1,a3,800024b2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002486:	449c                	lw	a5,8(s1)
    80002488:	fef059e3          	blez	a5,8000247a <iget+0x34>
    8000248c:	4098                	lw	a4,0(s1)
    8000248e:	ff3716e3          	bne	a4,s3,8000247a <iget+0x34>
    80002492:	40d8                	lw	a4,4(s1)
    80002494:	ff4713e3          	bne	a4,s4,8000247a <iget+0x34>
      ip->ref++;
    80002498:	2785                	addiw	a5,a5,1
    8000249a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000249c:	00016517          	auipc	a0,0x16
    800024a0:	27c50513          	addi	a0,a0,636 # 80018718 <itable>
    800024a4:	4ae030ef          	jal	80005952 <release>
      return ip;
    800024a8:	8926                	mv	s2,s1
    800024aa:	a02d                	j	800024d4 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024ac:	fbe9                	bnez	a5,8000247e <iget+0x38>
      empty = ip;
    800024ae:	8926                	mv	s2,s1
    800024b0:	b7f9                	j	8000247e <iget+0x38>
  if(empty == 0)
    800024b2:	02090a63          	beqz	s2,800024e6 <iget+0xa0>
  ip->dev = dev;
    800024b6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024ba:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024be:	4785                	li	a5,1
    800024c0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024c4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024c8:	00016517          	auipc	a0,0x16
    800024cc:	25050513          	addi	a0,a0,592 # 80018718 <itable>
    800024d0:	482030ef          	jal	80005952 <release>
}
    800024d4:	854a                	mv	a0,s2
    800024d6:	70a2                	ld	ra,40(sp)
    800024d8:	7402                	ld	s0,32(sp)
    800024da:	64e2                	ld	s1,24(sp)
    800024dc:	6942                	ld	s2,16(sp)
    800024de:	69a2                	ld	s3,8(sp)
    800024e0:	6a02                	ld	s4,0(sp)
    800024e2:	6145                	addi	sp,sp,48
    800024e4:	8082                	ret
    panic("iget: no inodes");
    800024e6:	00005517          	auipc	a0,0x5
    800024ea:	eca50513          	addi	a0,a0,-310 # 800073b0 <etext+0x3b0>
    800024ee:	110030ef          	jal	800055fe <panic>

00000000800024f2 <iinit>:
{
    800024f2:	7179                	addi	sp,sp,-48
    800024f4:	f406                	sd	ra,40(sp)
    800024f6:	f022                	sd	s0,32(sp)
    800024f8:	ec26                	sd	s1,24(sp)
    800024fa:	e84a                	sd	s2,16(sp)
    800024fc:	e44e                	sd	s3,8(sp)
    800024fe:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002500:	00005597          	auipc	a1,0x5
    80002504:	ec058593          	addi	a1,a1,-320 # 800073c0 <etext+0x3c0>
    80002508:	00016517          	auipc	a0,0x16
    8000250c:	21050513          	addi	a0,a0,528 # 80018718 <itable>
    80002510:	32a030ef          	jal	8000583a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002514:	00016497          	auipc	s1,0x16
    80002518:	22c48493          	addi	s1,s1,556 # 80018740 <itable+0x28>
    8000251c:	00018997          	auipc	s3,0x18
    80002520:	cb498993          	addi	s3,s3,-844 # 8001a1d0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002524:	00005917          	auipc	s2,0x5
    80002528:	ea490913          	addi	s2,s2,-348 # 800073c8 <etext+0x3c8>
    8000252c:	85ca                	mv	a1,s2
    8000252e:	8526                	mv	a0,s1
    80002530:	5bb000ef          	jal	800032ea <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002534:	08848493          	addi	s1,s1,136
    80002538:	ff349ae3          	bne	s1,s3,8000252c <iinit+0x3a>
}
    8000253c:	70a2                	ld	ra,40(sp)
    8000253e:	7402                	ld	s0,32(sp)
    80002540:	64e2                	ld	s1,24(sp)
    80002542:	6942                	ld	s2,16(sp)
    80002544:	69a2                	ld	s3,8(sp)
    80002546:	6145                	addi	sp,sp,48
    80002548:	8082                	ret

000000008000254a <ialloc>:
{
    8000254a:	7139                	addi	sp,sp,-64
    8000254c:	fc06                	sd	ra,56(sp)
    8000254e:	f822                	sd	s0,48(sp)
    80002550:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002552:	00016717          	auipc	a4,0x16
    80002556:	1b272703          	lw	a4,434(a4) # 80018704 <sb+0xc>
    8000255a:	4785                	li	a5,1
    8000255c:	06e7f063          	bgeu	a5,a4,800025bc <ialloc+0x72>
    80002560:	f426                	sd	s1,40(sp)
    80002562:	f04a                	sd	s2,32(sp)
    80002564:	ec4e                	sd	s3,24(sp)
    80002566:	e852                	sd	s4,16(sp)
    80002568:	e456                	sd	s5,8(sp)
    8000256a:	e05a                	sd	s6,0(sp)
    8000256c:	8aaa                	mv	s5,a0
    8000256e:	8b2e                	mv	s6,a1
    80002570:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002572:	00016a17          	auipc	s4,0x16
    80002576:	186a0a13          	addi	s4,s4,390 # 800186f8 <sb>
    8000257a:	00495593          	srli	a1,s2,0x4
    8000257e:	018a2783          	lw	a5,24(s4)
    80002582:	9dbd                	addw	a1,a1,a5
    80002584:	8556                	mv	a0,s5
    80002586:	a69ff0ef          	jal	80001fee <bread>
    8000258a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000258c:	05850993          	addi	s3,a0,88
    80002590:	00f97793          	andi	a5,s2,15
    80002594:	079a                	slli	a5,a5,0x6
    80002596:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002598:	00099783          	lh	a5,0(s3)
    8000259c:	cb9d                	beqz	a5,800025d2 <ialloc+0x88>
    brelse(bp);
    8000259e:	b59ff0ef          	jal	800020f6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025a2:	0905                	addi	s2,s2,1
    800025a4:	00ca2703          	lw	a4,12(s4)
    800025a8:	0009079b          	sext.w	a5,s2
    800025ac:	fce7e7e3          	bltu	a5,a4,8000257a <ialloc+0x30>
    800025b0:	74a2                	ld	s1,40(sp)
    800025b2:	7902                	ld	s2,32(sp)
    800025b4:	69e2                	ld	s3,24(sp)
    800025b6:	6a42                	ld	s4,16(sp)
    800025b8:	6aa2                	ld	s5,8(sp)
    800025ba:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800025bc:	00005517          	auipc	a0,0x5
    800025c0:	e1450513          	addi	a0,a0,-492 # 800073d0 <etext+0x3d0>
    800025c4:	555020ef          	jal	80005318 <printf>
  return 0;
    800025c8:	4501                	li	a0,0
}
    800025ca:	70e2                	ld	ra,56(sp)
    800025cc:	7442                	ld	s0,48(sp)
    800025ce:	6121                	addi	sp,sp,64
    800025d0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800025d2:	04000613          	li	a2,64
    800025d6:	4581                	li	a1,0
    800025d8:	854e                	mv	a0,s3
    800025da:	b75fd0ef          	jal	8000014e <memset>
      dip->type = type;
    800025de:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800025e2:	8526                	mv	a0,s1
    800025e4:	445000ef          	jal	80003228 <log_write>
      brelse(bp);
    800025e8:	8526                	mv	a0,s1
    800025ea:	b0dff0ef          	jal	800020f6 <brelse>
      return iget(dev, inum);
    800025ee:	0009059b          	sext.w	a1,s2
    800025f2:	8556                	mv	a0,s5
    800025f4:	e53ff0ef          	jal	80002446 <iget>
    800025f8:	74a2                	ld	s1,40(sp)
    800025fa:	7902                	ld	s2,32(sp)
    800025fc:	69e2                	ld	s3,24(sp)
    800025fe:	6a42                	ld	s4,16(sp)
    80002600:	6aa2                	ld	s5,8(sp)
    80002602:	6b02                	ld	s6,0(sp)
    80002604:	b7d9                	j	800025ca <ialloc+0x80>

0000000080002606 <iupdate>:
{
    80002606:	1101                	addi	sp,sp,-32
    80002608:	ec06                	sd	ra,24(sp)
    8000260a:	e822                	sd	s0,16(sp)
    8000260c:	e426                	sd	s1,8(sp)
    8000260e:	e04a                	sd	s2,0(sp)
    80002610:	1000                	addi	s0,sp,32
    80002612:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002614:	415c                	lw	a5,4(a0)
    80002616:	0047d79b          	srliw	a5,a5,0x4
    8000261a:	00016597          	auipc	a1,0x16
    8000261e:	0f65a583          	lw	a1,246(a1) # 80018710 <sb+0x18>
    80002622:	9dbd                	addw	a1,a1,a5
    80002624:	4108                	lw	a0,0(a0)
    80002626:	9c9ff0ef          	jal	80001fee <bread>
    8000262a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000262c:	05850793          	addi	a5,a0,88
    80002630:	40d8                	lw	a4,4(s1)
    80002632:	8b3d                	andi	a4,a4,15
    80002634:	071a                	slli	a4,a4,0x6
    80002636:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002638:	04449703          	lh	a4,68(s1)
    8000263c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002640:	04649703          	lh	a4,70(s1)
    80002644:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002648:	04849703          	lh	a4,72(s1)
    8000264c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002650:	04a49703          	lh	a4,74(s1)
    80002654:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002658:	44f8                	lw	a4,76(s1)
    8000265a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000265c:	03400613          	li	a2,52
    80002660:	05048593          	addi	a1,s1,80
    80002664:	00c78513          	addi	a0,a5,12
    80002668:	b43fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    8000266c:	854a                	mv	a0,s2
    8000266e:	3bb000ef          	jal	80003228 <log_write>
  brelse(bp);
    80002672:	854a                	mv	a0,s2
    80002674:	a83ff0ef          	jal	800020f6 <brelse>
}
    80002678:	60e2                	ld	ra,24(sp)
    8000267a:	6442                	ld	s0,16(sp)
    8000267c:	64a2                	ld	s1,8(sp)
    8000267e:	6902                	ld	s2,0(sp)
    80002680:	6105                	addi	sp,sp,32
    80002682:	8082                	ret

0000000080002684 <idup>:
{
    80002684:	1101                	addi	sp,sp,-32
    80002686:	ec06                	sd	ra,24(sp)
    80002688:	e822                	sd	s0,16(sp)
    8000268a:	e426                	sd	s1,8(sp)
    8000268c:	1000                	addi	s0,sp,32
    8000268e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002690:	00016517          	auipc	a0,0x16
    80002694:	08850513          	addi	a0,a0,136 # 80018718 <itable>
    80002698:	222030ef          	jal	800058ba <acquire>
  ip->ref++;
    8000269c:	449c                	lw	a5,8(s1)
    8000269e:	2785                	addiw	a5,a5,1
    800026a0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026a2:	00016517          	auipc	a0,0x16
    800026a6:	07650513          	addi	a0,a0,118 # 80018718 <itable>
    800026aa:	2a8030ef          	jal	80005952 <release>
}
    800026ae:	8526                	mv	a0,s1
    800026b0:	60e2                	ld	ra,24(sp)
    800026b2:	6442                	ld	s0,16(sp)
    800026b4:	64a2                	ld	s1,8(sp)
    800026b6:	6105                	addi	sp,sp,32
    800026b8:	8082                	ret

00000000800026ba <ilock>:
{
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026c4:	cd19                	beqz	a0,800026e2 <ilock+0x28>
    800026c6:	84aa                	mv	s1,a0
    800026c8:	451c                	lw	a5,8(a0)
    800026ca:	00f05c63          	blez	a5,800026e2 <ilock+0x28>
  acquiresleep(&ip->lock);
    800026ce:	0541                	addi	a0,a0,16
    800026d0:	451000ef          	jal	80003320 <acquiresleep>
  if(ip->valid == 0){
    800026d4:	40bc                	lw	a5,64(s1)
    800026d6:	cf89                	beqz	a5,800026f0 <ilock+0x36>
}
    800026d8:	60e2                	ld	ra,24(sp)
    800026da:	6442                	ld	s0,16(sp)
    800026dc:	64a2                	ld	s1,8(sp)
    800026de:	6105                	addi	sp,sp,32
    800026e0:	8082                	ret
    800026e2:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800026e4:	00005517          	auipc	a0,0x5
    800026e8:	d0450513          	addi	a0,a0,-764 # 800073e8 <etext+0x3e8>
    800026ec:	713020ef          	jal	800055fe <panic>
    800026f0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026f2:	40dc                	lw	a5,4(s1)
    800026f4:	0047d79b          	srliw	a5,a5,0x4
    800026f8:	00016597          	auipc	a1,0x16
    800026fc:	0185a583          	lw	a1,24(a1) # 80018710 <sb+0x18>
    80002700:	9dbd                	addw	a1,a1,a5
    80002702:	4088                	lw	a0,0(s1)
    80002704:	8ebff0ef          	jal	80001fee <bread>
    80002708:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000270a:	05850593          	addi	a1,a0,88
    8000270e:	40dc                	lw	a5,4(s1)
    80002710:	8bbd                	andi	a5,a5,15
    80002712:	079a                	slli	a5,a5,0x6
    80002714:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002716:	00059783          	lh	a5,0(a1)
    8000271a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000271e:	00259783          	lh	a5,2(a1)
    80002722:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002726:	00459783          	lh	a5,4(a1)
    8000272a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000272e:	00659783          	lh	a5,6(a1)
    80002732:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002736:	459c                	lw	a5,8(a1)
    80002738:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000273a:	03400613          	li	a2,52
    8000273e:	05b1                	addi	a1,a1,12
    80002740:	05048513          	addi	a0,s1,80
    80002744:	a67fd0ef          	jal	800001aa <memmove>
    brelse(bp);
    80002748:	854a                	mv	a0,s2
    8000274a:	9adff0ef          	jal	800020f6 <brelse>
    ip->valid = 1;
    8000274e:	4785                	li	a5,1
    80002750:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002752:	04449783          	lh	a5,68(s1)
    80002756:	c399                	beqz	a5,8000275c <ilock+0xa2>
    80002758:	6902                	ld	s2,0(sp)
    8000275a:	bfbd                	j	800026d8 <ilock+0x1e>
      panic("ilock: no type");
    8000275c:	00005517          	auipc	a0,0x5
    80002760:	c9450513          	addi	a0,a0,-876 # 800073f0 <etext+0x3f0>
    80002764:	69b020ef          	jal	800055fe <panic>

0000000080002768 <iunlock>:
{
    80002768:	1101                	addi	sp,sp,-32
    8000276a:	ec06                	sd	ra,24(sp)
    8000276c:	e822                	sd	s0,16(sp)
    8000276e:	e426                	sd	s1,8(sp)
    80002770:	e04a                	sd	s2,0(sp)
    80002772:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002774:	c505                	beqz	a0,8000279c <iunlock+0x34>
    80002776:	84aa                	mv	s1,a0
    80002778:	01050913          	addi	s2,a0,16
    8000277c:	854a                	mv	a0,s2
    8000277e:	421000ef          	jal	8000339e <holdingsleep>
    80002782:	cd09                	beqz	a0,8000279c <iunlock+0x34>
    80002784:	449c                	lw	a5,8(s1)
    80002786:	00f05b63          	blez	a5,8000279c <iunlock+0x34>
  releasesleep(&ip->lock);
    8000278a:	854a                	mv	a0,s2
    8000278c:	3db000ef          	jal	80003366 <releasesleep>
}
    80002790:	60e2                	ld	ra,24(sp)
    80002792:	6442                	ld	s0,16(sp)
    80002794:	64a2                	ld	s1,8(sp)
    80002796:	6902                	ld	s2,0(sp)
    80002798:	6105                	addi	sp,sp,32
    8000279a:	8082                	ret
    panic("iunlock");
    8000279c:	00005517          	auipc	a0,0x5
    800027a0:	c6450513          	addi	a0,a0,-924 # 80007400 <etext+0x400>
    800027a4:	65b020ef          	jal	800055fe <panic>

00000000800027a8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027a8:	7179                	addi	sp,sp,-48
    800027aa:	f406                	sd	ra,40(sp)
    800027ac:	f022                	sd	s0,32(sp)
    800027ae:	ec26                	sd	s1,24(sp)
    800027b0:	e84a                	sd	s2,16(sp)
    800027b2:	e44e                	sd	s3,8(sp)
    800027b4:	1800                	addi	s0,sp,48
    800027b6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800027b8:	05050493          	addi	s1,a0,80
    800027bc:	08050913          	addi	s2,a0,128
    800027c0:	a021                	j	800027c8 <itrunc+0x20>
    800027c2:	0491                	addi	s1,s1,4
    800027c4:	01248b63          	beq	s1,s2,800027da <itrunc+0x32>
    if(ip->addrs[i]){
    800027c8:	408c                	lw	a1,0(s1)
    800027ca:	dde5                	beqz	a1,800027c2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800027cc:	0009a503          	lw	a0,0(s3)
    800027d0:	a17ff0ef          	jal	800021e6 <bfree>
      ip->addrs[i] = 0;
    800027d4:	0004a023          	sw	zero,0(s1)
    800027d8:	b7ed                	j	800027c2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800027da:	0809a583          	lw	a1,128(s3)
    800027de:	ed89                	bnez	a1,800027f8 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800027e0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800027e4:	854e                	mv	a0,s3
    800027e6:	e21ff0ef          	jal	80002606 <iupdate>
}
    800027ea:	70a2                	ld	ra,40(sp)
    800027ec:	7402                	ld	s0,32(sp)
    800027ee:	64e2                	ld	s1,24(sp)
    800027f0:	6942                	ld	s2,16(sp)
    800027f2:	69a2                	ld	s3,8(sp)
    800027f4:	6145                	addi	sp,sp,48
    800027f6:	8082                	ret
    800027f8:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800027fa:	0009a503          	lw	a0,0(s3)
    800027fe:	ff0ff0ef          	jal	80001fee <bread>
    80002802:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002804:	05850493          	addi	s1,a0,88
    80002808:	45850913          	addi	s2,a0,1112
    8000280c:	a021                	j	80002814 <itrunc+0x6c>
    8000280e:	0491                	addi	s1,s1,4
    80002810:	01248963          	beq	s1,s2,80002822 <itrunc+0x7a>
      if(a[j])
    80002814:	408c                	lw	a1,0(s1)
    80002816:	dde5                	beqz	a1,8000280e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002818:	0009a503          	lw	a0,0(s3)
    8000281c:	9cbff0ef          	jal	800021e6 <bfree>
    80002820:	b7fd                	j	8000280e <itrunc+0x66>
    brelse(bp);
    80002822:	8552                	mv	a0,s4
    80002824:	8d3ff0ef          	jal	800020f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002828:	0809a583          	lw	a1,128(s3)
    8000282c:	0009a503          	lw	a0,0(s3)
    80002830:	9b7ff0ef          	jal	800021e6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002834:	0809a023          	sw	zero,128(s3)
    80002838:	6a02                	ld	s4,0(sp)
    8000283a:	b75d                	j	800027e0 <itrunc+0x38>

000000008000283c <iput>:
{
    8000283c:	1101                	addi	sp,sp,-32
    8000283e:	ec06                	sd	ra,24(sp)
    80002840:	e822                	sd	s0,16(sp)
    80002842:	e426                	sd	s1,8(sp)
    80002844:	1000                	addi	s0,sp,32
    80002846:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002848:	00016517          	auipc	a0,0x16
    8000284c:	ed050513          	addi	a0,a0,-304 # 80018718 <itable>
    80002850:	06a030ef          	jal	800058ba <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002854:	4498                	lw	a4,8(s1)
    80002856:	4785                	li	a5,1
    80002858:	02f70063          	beq	a4,a5,80002878 <iput+0x3c>
  ip->ref--;
    8000285c:	449c                	lw	a5,8(s1)
    8000285e:	37fd                	addiw	a5,a5,-1
    80002860:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002862:	00016517          	auipc	a0,0x16
    80002866:	eb650513          	addi	a0,a0,-330 # 80018718 <itable>
    8000286a:	0e8030ef          	jal	80005952 <release>
}
    8000286e:	60e2                	ld	ra,24(sp)
    80002870:	6442                	ld	s0,16(sp)
    80002872:	64a2                	ld	s1,8(sp)
    80002874:	6105                	addi	sp,sp,32
    80002876:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002878:	40bc                	lw	a5,64(s1)
    8000287a:	d3ed                	beqz	a5,8000285c <iput+0x20>
    8000287c:	04a49783          	lh	a5,74(s1)
    80002880:	fff1                	bnez	a5,8000285c <iput+0x20>
    80002882:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002884:	01048913          	addi	s2,s1,16
    80002888:	854a                	mv	a0,s2
    8000288a:	297000ef          	jal	80003320 <acquiresleep>
    release(&itable.lock);
    8000288e:	00016517          	auipc	a0,0x16
    80002892:	e8a50513          	addi	a0,a0,-374 # 80018718 <itable>
    80002896:	0bc030ef          	jal	80005952 <release>
    itrunc(ip);
    8000289a:	8526                	mv	a0,s1
    8000289c:	f0dff0ef          	jal	800027a8 <itrunc>
    ip->type = 0;
    800028a0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028a4:	8526                	mv	a0,s1
    800028a6:	d61ff0ef          	jal	80002606 <iupdate>
    ip->valid = 0;
    800028aa:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028ae:	854a                	mv	a0,s2
    800028b0:	2b7000ef          	jal	80003366 <releasesleep>
    acquire(&itable.lock);
    800028b4:	00016517          	auipc	a0,0x16
    800028b8:	e6450513          	addi	a0,a0,-412 # 80018718 <itable>
    800028bc:	7ff020ef          	jal	800058ba <acquire>
    800028c0:	6902                	ld	s2,0(sp)
    800028c2:	bf69                	j	8000285c <iput+0x20>

00000000800028c4 <iunlockput>:
{
    800028c4:	1101                	addi	sp,sp,-32
    800028c6:	ec06                	sd	ra,24(sp)
    800028c8:	e822                	sd	s0,16(sp)
    800028ca:	e426                	sd	s1,8(sp)
    800028cc:	1000                	addi	s0,sp,32
    800028ce:	84aa                	mv	s1,a0
  iunlock(ip);
    800028d0:	e99ff0ef          	jal	80002768 <iunlock>
  iput(ip);
    800028d4:	8526                	mv	a0,s1
    800028d6:	f67ff0ef          	jal	8000283c <iput>
}
    800028da:	60e2                	ld	ra,24(sp)
    800028dc:	6442                	ld	s0,16(sp)
    800028de:	64a2                	ld	s1,8(sp)
    800028e0:	6105                	addi	sp,sp,32
    800028e2:	8082                	ret

00000000800028e4 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800028e4:	00016717          	auipc	a4,0x16
    800028e8:	e2072703          	lw	a4,-480(a4) # 80018704 <sb+0xc>
    800028ec:	4785                	li	a5,1
    800028ee:	0ae7ff63          	bgeu	a5,a4,800029ac <ireclaim+0xc8>
{
    800028f2:	7139                	addi	sp,sp,-64
    800028f4:	fc06                	sd	ra,56(sp)
    800028f6:	f822                	sd	s0,48(sp)
    800028f8:	f426                	sd	s1,40(sp)
    800028fa:	f04a                	sd	s2,32(sp)
    800028fc:	ec4e                	sd	s3,24(sp)
    800028fe:	e852                	sd	s4,16(sp)
    80002900:	e456                	sd	s5,8(sp)
    80002902:	e05a                	sd	s6,0(sp)
    80002904:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002906:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002908:	00050a1b          	sext.w	s4,a0
    8000290c:	00016a97          	auipc	s5,0x16
    80002910:	deca8a93          	addi	s5,s5,-532 # 800186f8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002914:	00005b17          	auipc	s6,0x5
    80002918:	af4b0b13          	addi	s6,s6,-1292 # 80007408 <etext+0x408>
    8000291c:	a099                	j	80002962 <ireclaim+0x7e>
    8000291e:	85ce                	mv	a1,s3
    80002920:	855a                	mv	a0,s6
    80002922:	1f7020ef          	jal	80005318 <printf>
      ip = iget(dev, inum);
    80002926:	85ce                	mv	a1,s3
    80002928:	8552                	mv	a0,s4
    8000292a:	b1dff0ef          	jal	80002446 <iget>
    8000292e:	89aa                	mv	s3,a0
    brelse(bp);
    80002930:	854a                	mv	a0,s2
    80002932:	fc4ff0ef          	jal	800020f6 <brelse>
    if (ip) {
    80002936:	00098f63          	beqz	s3,80002954 <ireclaim+0x70>
      begin_op();
    8000293a:	76a000ef          	jal	800030a4 <begin_op>
      ilock(ip);
    8000293e:	854e                	mv	a0,s3
    80002940:	d7bff0ef          	jal	800026ba <ilock>
      iunlock(ip);
    80002944:	854e                	mv	a0,s3
    80002946:	e23ff0ef          	jal	80002768 <iunlock>
      iput(ip);
    8000294a:	854e                	mv	a0,s3
    8000294c:	ef1ff0ef          	jal	8000283c <iput>
      end_op();
    80002950:	7be000ef          	jal	8000310e <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002954:	0485                	addi	s1,s1,1
    80002956:	00caa703          	lw	a4,12(s5)
    8000295a:	0004879b          	sext.w	a5,s1
    8000295e:	02e7fd63          	bgeu	a5,a4,80002998 <ireclaim+0xb4>
    80002962:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002966:	0044d593          	srli	a1,s1,0x4
    8000296a:	018aa783          	lw	a5,24(s5)
    8000296e:	9dbd                	addw	a1,a1,a5
    80002970:	8552                	mv	a0,s4
    80002972:	e7cff0ef          	jal	80001fee <bread>
    80002976:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002978:	05850793          	addi	a5,a0,88
    8000297c:	00f9f713          	andi	a4,s3,15
    80002980:	071a                	slli	a4,a4,0x6
    80002982:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002984:	00079703          	lh	a4,0(a5)
    80002988:	c701                	beqz	a4,80002990 <ireclaim+0xac>
    8000298a:	00679783          	lh	a5,6(a5)
    8000298e:	dbc1                	beqz	a5,8000291e <ireclaim+0x3a>
    brelse(bp);
    80002990:	854a                	mv	a0,s2
    80002992:	f64ff0ef          	jal	800020f6 <brelse>
    if (ip) {
    80002996:	bf7d                	j	80002954 <ireclaim+0x70>
}
    80002998:	70e2                	ld	ra,56(sp)
    8000299a:	7442                	ld	s0,48(sp)
    8000299c:	74a2                	ld	s1,40(sp)
    8000299e:	7902                	ld	s2,32(sp)
    800029a0:	69e2                	ld	s3,24(sp)
    800029a2:	6a42                	ld	s4,16(sp)
    800029a4:	6aa2                	ld	s5,8(sp)
    800029a6:	6b02                	ld	s6,0(sp)
    800029a8:	6121                	addi	sp,sp,64
    800029aa:	8082                	ret
    800029ac:	8082                	ret

00000000800029ae <fsinit>:
fsinit(int dev) {
    800029ae:	7179                	addi	sp,sp,-48
    800029b0:	f406                	sd	ra,40(sp)
    800029b2:	f022                	sd	s0,32(sp)
    800029b4:	ec26                	sd	s1,24(sp)
    800029b6:	e84a                	sd	s2,16(sp)
    800029b8:	e44e                	sd	s3,8(sp)
    800029ba:	1800                	addi	s0,sp,48
    800029bc:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800029be:	4585                	li	a1,1
    800029c0:	e2eff0ef          	jal	80001fee <bread>
    800029c4:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029c6:	00016997          	auipc	s3,0x16
    800029ca:	d3298993          	addi	s3,s3,-718 # 800186f8 <sb>
    800029ce:	02000613          	li	a2,32
    800029d2:	05850593          	addi	a1,a0,88
    800029d6:	854e                	mv	a0,s3
    800029d8:	fd2fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    800029dc:	854a                	mv	a0,s2
    800029de:	f18ff0ef          	jal	800020f6 <brelse>
  if(sb.magic != FSMAGIC)
    800029e2:	0009a703          	lw	a4,0(s3)
    800029e6:	102037b7          	lui	a5,0x10203
    800029ea:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029ee:	02f71363          	bne	a4,a5,80002a14 <fsinit+0x66>
  initlog(dev, &sb);
    800029f2:	00016597          	auipc	a1,0x16
    800029f6:	d0658593          	addi	a1,a1,-762 # 800186f8 <sb>
    800029fa:	8526                	mv	a0,s1
    800029fc:	62a000ef          	jal	80003026 <initlog>
  ireclaim(dev);
    80002a00:	8526                	mv	a0,s1
    80002a02:	ee3ff0ef          	jal	800028e4 <ireclaim>
}
    80002a06:	70a2                	ld	ra,40(sp)
    80002a08:	7402                	ld	s0,32(sp)
    80002a0a:	64e2                	ld	s1,24(sp)
    80002a0c:	6942                	ld	s2,16(sp)
    80002a0e:	69a2                	ld	s3,8(sp)
    80002a10:	6145                	addi	sp,sp,48
    80002a12:	8082                	ret
    panic("invalid file system");
    80002a14:	00005517          	auipc	a0,0x5
    80002a18:	a1450513          	addi	a0,a0,-1516 # 80007428 <etext+0x428>
    80002a1c:	3e3020ef          	jal	800055fe <panic>

0000000080002a20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a20:	1141                	addi	sp,sp,-16
    80002a22:	e422                	sd	s0,8(sp)
    80002a24:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a26:	411c                	lw	a5,0(a0)
    80002a28:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a2a:	415c                	lw	a5,4(a0)
    80002a2c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a2e:	04451783          	lh	a5,68(a0)
    80002a32:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a36:	04a51783          	lh	a5,74(a0)
    80002a3a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a3e:	04c56783          	lwu	a5,76(a0)
    80002a42:	e99c                	sd	a5,16(a1)
}
    80002a44:	6422                	ld	s0,8(sp)
    80002a46:	0141                	addi	sp,sp,16
    80002a48:	8082                	ret

0000000080002a4a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a4a:	457c                	lw	a5,76(a0)
    80002a4c:	0ed7eb63          	bltu	a5,a3,80002b42 <readi+0xf8>
{
    80002a50:	7159                	addi	sp,sp,-112
    80002a52:	f486                	sd	ra,104(sp)
    80002a54:	f0a2                	sd	s0,96(sp)
    80002a56:	eca6                	sd	s1,88(sp)
    80002a58:	e0d2                	sd	s4,64(sp)
    80002a5a:	fc56                	sd	s5,56(sp)
    80002a5c:	f85a                	sd	s6,48(sp)
    80002a5e:	f45e                	sd	s7,40(sp)
    80002a60:	1880                	addi	s0,sp,112
    80002a62:	8b2a                	mv	s6,a0
    80002a64:	8bae                	mv	s7,a1
    80002a66:	8a32                	mv	s4,a2
    80002a68:	84b6                	mv	s1,a3
    80002a6a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a6c:	9f35                	addw	a4,a4,a3
    return 0;
    80002a6e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a70:	0cd76063          	bltu	a4,a3,80002b30 <readi+0xe6>
    80002a74:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a76:	00e7f463          	bgeu	a5,a4,80002a7e <readi+0x34>
    n = ip->size - off;
    80002a7a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a7e:	080a8f63          	beqz	s5,80002b1c <readi+0xd2>
    80002a82:	e8ca                	sd	s2,80(sp)
    80002a84:	f062                	sd	s8,32(sp)
    80002a86:	ec66                	sd	s9,24(sp)
    80002a88:	e86a                	sd	s10,16(sp)
    80002a8a:	e46e                	sd	s11,8(sp)
    80002a8c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a8e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a92:	5c7d                	li	s8,-1
    80002a94:	a80d                	j	80002ac6 <readi+0x7c>
    80002a96:	020d1d93          	slli	s11,s10,0x20
    80002a9a:	020ddd93          	srli	s11,s11,0x20
    80002a9e:	05890613          	addi	a2,s2,88
    80002aa2:	86ee                	mv	a3,s11
    80002aa4:	963a                	add	a2,a2,a4
    80002aa6:	85d2                	mv	a1,s4
    80002aa8:	855e                	mv	a0,s7
    80002aaa:	c25fe0ef          	jal	800016ce <either_copyout>
    80002aae:	05850763          	beq	a0,s8,80002afc <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ab2:	854a                	mv	a0,s2
    80002ab4:	e42ff0ef          	jal	800020f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ab8:	013d09bb          	addw	s3,s10,s3
    80002abc:	009d04bb          	addw	s1,s10,s1
    80002ac0:	9a6e                	add	s4,s4,s11
    80002ac2:	0559f763          	bgeu	s3,s5,80002b10 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002ac6:	00a4d59b          	srliw	a1,s1,0xa
    80002aca:	855a                	mv	a0,s6
    80002acc:	8a7ff0ef          	jal	80002372 <bmap>
    80002ad0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002ad4:	c5b1                	beqz	a1,80002b20 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002ad6:	000b2503          	lw	a0,0(s6)
    80002ada:	d14ff0ef          	jal	80001fee <bread>
    80002ade:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ae0:	3ff4f713          	andi	a4,s1,1023
    80002ae4:	40ec87bb          	subw	a5,s9,a4
    80002ae8:	413a86bb          	subw	a3,s5,s3
    80002aec:	8d3e                	mv	s10,a5
    80002aee:	2781                	sext.w	a5,a5
    80002af0:	0006861b          	sext.w	a2,a3
    80002af4:	faf671e3          	bgeu	a2,a5,80002a96 <readi+0x4c>
    80002af8:	8d36                	mv	s10,a3
    80002afa:	bf71                	j	80002a96 <readi+0x4c>
      brelse(bp);
    80002afc:	854a                	mv	a0,s2
    80002afe:	df8ff0ef          	jal	800020f6 <brelse>
      tot = -1;
    80002b02:	59fd                	li	s3,-1
      break;
    80002b04:	6946                	ld	s2,80(sp)
    80002b06:	7c02                	ld	s8,32(sp)
    80002b08:	6ce2                	ld	s9,24(sp)
    80002b0a:	6d42                	ld	s10,16(sp)
    80002b0c:	6da2                	ld	s11,8(sp)
    80002b0e:	a831                	j	80002b2a <readi+0xe0>
    80002b10:	6946                	ld	s2,80(sp)
    80002b12:	7c02                	ld	s8,32(sp)
    80002b14:	6ce2                	ld	s9,24(sp)
    80002b16:	6d42                	ld	s10,16(sp)
    80002b18:	6da2                	ld	s11,8(sp)
    80002b1a:	a801                	j	80002b2a <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b1c:	89d6                	mv	s3,s5
    80002b1e:	a031                	j	80002b2a <readi+0xe0>
    80002b20:	6946                	ld	s2,80(sp)
    80002b22:	7c02                	ld	s8,32(sp)
    80002b24:	6ce2                	ld	s9,24(sp)
    80002b26:	6d42                	ld	s10,16(sp)
    80002b28:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b2a:	0009851b          	sext.w	a0,s3
    80002b2e:	69a6                	ld	s3,72(sp)
}
    80002b30:	70a6                	ld	ra,104(sp)
    80002b32:	7406                	ld	s0,96(sp)
    80002b34:	64e6                	ld	s1,88(sp)
    80002b36:	6a06                	ld	s4,64(sp)
    80002b38:	7ae2                	ld	s5,56(sp)
    80002b3a:	7b42                	ld	s6,48(sp)
    80002b3c:	7ba2                	ld	s7,40(sp)
    80002b3e:	6165                	addi	sp,sp,112
    80002b40:	8082                	ret
    return 0;
    80002b42:	4501                	li	a0,0
}
    80002b44:	8082                	ret

0000000080002b46 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b46:	457c                	lw	a5,76(a0)
    80002b48:	10d7e063          	bltu	a5,a3,80002c48 <writei+0x102>
{
    80002b4c:	7159                	addi	sp,sp,-112
    80002b4e:	f486                	sd	ra,104(sp)
    80002b50:	f0a2                	sd	s0,96(sp)
    80002b52:	e8ca                	sd	s2,80(sp)
    80002b54:	e0d2                	sd	s4,64(sp)
    80002b56:	fc56                	sd	s5,56(sp)
    80002b58:	f85a                	sd	s6,48(sp)
    80002b5a:	f45e                	sd	s7,40(sp)
    80002b5c:	1880                	addi	s0,sp,112
    80002b5e:	8aaa                	mv	s5,a0
    80002b60:	8bae                	mv	s7,a1
    80002b62:	8a32                	mv	s4,a2
    80002b64:	8936                	mv	s2,a3
    80002b66:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b68:	00e687bb          	addw	a5,a3,a4
    80002b6c:	0ed7e063          	bltu	a5,a3,80002c4c <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b70:	00043737          	lui	a4,0x43
    80002b74:	0cf76e63          	bltu	a4,a5,80002c50 <writei+0x10a>
    80002b78:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b7a:	0a0b0f63          	beqz	s6,80002c38 <writei+0xf2>
    80002b7e:	eca6                	sd	s1,88(sp)
    80002b80:	f062                	sd	s8,32(sp)
    80002b82:	ec66                	sd	s9,24(sp)
    80002b84:	e86a                	sd	s10,16(sp)
    80002b86:	e46e                	sd	s11,8(sp)
    80002b88:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b8a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b8e:	5c7d                	li	s8,-1
    80002b90:	a825                	j	80002bc8 <writei+0x82>
    80002b92:	020d1d93          	slli	s11,s10,0x20
    80002b96:	020ddd93          	srli	s11,s11,0x20
    80002b9a:	05848513          	addi	a0,s1,88
    80002b9e:	86ee                	mv	a3,s11
    80002ba0:	8652                	mv	a2,s4
    80002ba2:	85de                	mv	a1,s7
    80002ba4:	953a                	add	a0,a0,a4
    80002ba6:	b73fe0ef          	jal	80001718 <either_copyin>
    80002baa:	05850a63          	beq	a0,s8,80002bfe <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bae:	8526                	mv	a0,s1
    80002bb0:	678000ef          	jal	80003228 <log_write>
    brelse(bp);
    80002bb4:	8526                	mv	a0,s1
    80002bb6:	d40ff0ef          	jal	800020f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bba:	013d09bb          	addw	s3,s10,s3
    80002bbe:	012d093b          	addw	s2,s10,s2
    80002bc2:	9a6e                	add	s4,s4,s11
    80002bc4:	0569f063          	bgeu	s3,s6,80002c04 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002bc8:	00a9559b          	srliw	a1,s2,0xa
    80002bcc:	8556                	mv	a0,s5
    80002bce:	fa4ff0ef          	jal	80002372 <bmap>
    80002bd2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002bd6:	c59d                	beqz	a1,80002c04 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002bd8:	000aa503          	lw	a0,0(s5)
    80002bdc:	c12ff0ef          	jal	80001fee <bread>
    80002be0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002be2:	3ff97713          	andi	a4,s2,1023
    80002be6:	40ec87bb          	subw	a5,s9,a4
    80002bea:	413b06bb          	subw	a3,s6,s3
    80002bee:	8d3e                	mv	s10,a5
    80002bf0:	2781                	sext.w	a5,a5
    80002bf2:	0006861b          	sext.w	a2,a3
    80002bf6:	f8f67ee3          	bgeu	a2,a5,80002b92 <writei+0x4c>
    80002bfa:	8d36                	mv	s10,a3
    80002bfc:	bf59                	j	80002b92 <writei+0x4c>
      brelse(bp);
    80002bfe:	8526                	mv	a0,s1
    80002c00:	cf6ff0ef          	jal	800020f6 <brelse>
  }

  if(off > ip->size)
    80002c04:	04caa783          	lw	a5,76(s5)
    80002c08:	0327fa63          	bgeu	a5,s2,80002c3c <writei+0xf6>
    ip->size = off;
    80002c0c:	052aa623          	sw	s2,76(s5)
    80002c10:	64e6                	ld	s1,88(sp)
    80002c12:	7c02                	ld	s8,32(sp)
    80002c14:	6ce2                	ld	s9,24(sp)
    80002c16:	6d42                	ld	s10,16(sp)
    80002c18:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c1a:	8556                	mv	a0,s5
    80002c1c:	9ebff0ef          	jal	80002606 <iupdate>

  return tot;
    80002c20:	0009851b          	sext.w	a0,s3
    80002c24:	69a6                	ld	s3,72(sp)
}
    80002c26:	70a6                	ld	ra,104(sp)
    80002c28:	7406                	ld	s0,96(sp)
    80002c2a:	6946                	ld	s2,80(sp)
    80002c2c:	6a06                	ld	s4,64(sp)
    80002c2e:	7ae2                	ld	s5,56(sp)
    80002c30:	7b42                	ld	s6,48(sp)
    80002c32:	7ba2                	ld	s7,40(sp)
    80002c34:	6165                	addi	sp,sp,112
    80002c36:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c38:	89da                	mv	s3,s6
    80002c3a:	b7c5                	j	80002c1a <writei+0xd4>
    80002c3c:	64e6                	ld	s1,88(sp)
    80002c3e:	7c02                	ld	s8,32(sp)
    80002c40:	6ce2                	ld	s9,24(sp)
    80002c42:	6d42                	ld	s10,16(sp)
    80002c44:	6da2                	ld	s11,8(sp)
    80002c46:	bfd1                	j	80002c1a <writei+0xd4>
    return -1;
    80002c48:	557d                	li	a0,-1
}
    80002c4a:	8082                	ret
    return -1;
    80002c4c:	557d                	li	a0,-1
    80002c4e:	bfe1                	j	80002c26 <writei+0xe0>
    return -1;
    80002c50:	557d                	li	a0,-1
    80002c52:	bfd1                	j	80002c26 <writei+0xe0>

0000000080002c54 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c54:	1141                	addi	sp,sp,-16
    80002c56:	e406                	sd	ra,8(sp)
    80002c58:	e022                	sd	s0,0(sp)
    80002c5a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c5c:	4639                	li	a2,14
    80002c5e:	dbcfd0ef          	jal	8000021a <strncmp>
}
    80002c62:	60a2                	ld	ra,8(sp)
    80002c64:	6402                	ld	s0,0(sp)
    80002c66:	0141                	addi	sp,sp,16
    80002c68:	8082                	ret

0000000080002c6a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c6a:	7139                	addi	sp,sp,-64
    80002c6c:	fc06                	sd	ra,56(sp)
    80002c6e:	f822                	sd	s0,48(sp)
    80002c70:	f426                	sd	s1,40(sp)
    80002c72:	f04a                	sd	s2,32(sp)
    80002c74:	ec4e                	sd	s3,24(sp)
    80002c76:	e852                	sd	s4,16(sp)
    80002c78:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c7a:	04451703          	lh	a4,68(a0)
    80002c7e:	4785                	li	a5,1
    80002c80:	00f71a63          	bne	a4,a5,80002c94 <dirlookup+0x2a>
    80002c84:	892a                	mv	s2,a0
    80002c86:	89ae                	mv	s3,a1
    80002c88:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c8a:	457c                	lw	a5,76(a0)
    80002c8c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c8e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c90:	e39d                	bnez	a5,80002cb6 <dirlookup+0x4c>
    80002c92:	a095                	j	80002cf6 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c94:	00004517          	auipc	a0,0x4
    80002c98:	7ac50513          	addi	a0,a0,1964 # 80007440 <etext+0x440>
    80002c9c:	163020ef          	jal	800055fe <panic>
      panic("dirlookup read");
    80002ca0:	00004517          	auipc	a0,0x4
    80002ca4:	7b850513          	addi	a0,a0,1976 # 80007458 <etext+0x458>
    80002ca8:	157020ef          	jal	800055fe <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cac:	24c1                	addiw	s1,s1,16
    80002cae:	04c92783          	lw	a5,76(s2)
    80002cb2:	04f4f163          	bgeu	s1,a5,80002cf4 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cb6:	4741                	li	a4,16
    80002cb8:	86a6                	mv	a3,s1
    80002cba:	fc040613          	addi	a2,s0,-64
    80002cbe:	4581                	li	a1,0
    80002cc0:	854a                	mv	a0,s2
    80002cc2:	d89ff0ef          	jal	80002a4a <readi>
    80002cc6:	47c1                	li	a5,16
    80002cc8:	fcf51ce3          	bne	a0,a5,80002ca0 <dirlookup+0x36>
    if(de.inum == 0)
    80002ccc:	fc045783          	lhu	a5,-64(s0)
    80002cd0:	dff1                	beqz	a5,80002cac <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002cd2:	fc240593          	addi	a1,s0,-62
    80002cd6:	854e                	mv	a0,s3
    80002cd8:	f7dff0ef          	jal	80002c54 <namecmp>
    80002cdc:	f961                	bnez	a0,80002cac <dirlookup+0x42>
      if(poff)
    80002cde:	000a0463          	beqz	s4,80002ce6 <dirlookup+0x7c>
        *poff = off;
    80002ce2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002ce6:	fc045583          	lhu	a1,-64(s0)
    80002cea:	00092503          	lw	a0,0(s2)
    80002cee:	f58ff0ef          	jal	80002446 <iget>
    80002cf2:	a011                	j	80002cf6 <dirlookup+0x8c>
  return 0;
    80002cf4:	4501                	li	a0,0
}
    80002cf6:	70e2                	ld	ra,56(sp)
    80002cf8:	7442                	ld	s0,48(sp)
    80002cfa:	74a2                	ld	s1,40(sp)
    80002cfc:	7902                	ld	s2,32(sp)
    80002cfe:	69e2                	ld	s3,24(sp)
    80002d00:	6a42                	ld	s4,16(sp)
    80002d02:	6121                	addi	sp,sp,64
    80002d04:	8082                	ret

0000000080002d06 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d06:	711d                	addi	sp,sp,-96
    80002d08:	ec86                	sd	ra,88(sp)
    80002d0a:	e8a2                	sd	s0,80(sp)
    80002d0c:	e4a6                	sd	s1,72(sp)
    80002d0e:	e0ca                	sd	s2,64(sp)
    80002d10:	fc4e                	sd	s3,56(sp)
    80002d12:	f852                	sd	s4,48(sp)
    80002d14:	f456                	sd	s5,40(sp)
    80002d16:	f05a                	sd	s6,32(sp)
    80002d18:	ec5e                	sd	s7,24(sp)
    80002d1a:	e862                	sd	s8,16(sp)
    80002d1c:	e466                	sd	s9,8(sp)
    80002d1e:	1080                	addi	s0,sp,96
    80002d20:	84aa                	mv	s1,a0
    80002d22:	8b2e                	mv	s6,a1
    80002d24:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d26:	00054703          	lbu	a4,0(a0)
    80002d2a:	02f00793          	li	a5,47
    80002d2e:	00f70e63          	beq	a4,a5,80002d4a <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d32:	848fe0ef          	jal	80000d7a <myproc>
    80002d36:	15053503          	ld	a0,336(a0)
    80002d3a:	94bff0ef          	jal	80002684 <idup>
    80002d3e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d40:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d44:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d46:	4b85                	li	s7,1
    80002d48:	a871                	j	80002de4 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002d4a:	4585                	li	a1,1
    80002d4c:	4505                	li	a0,1
    80002d4e:	ef8ff0ef          	jal	80002446 <iget>
    80002d52:	8a2a                	mv	s4,a0
    80002d54:	b7f5                	j	80002d40 <namex+0x3a>
      iunlockput(ip);
    80002d56:	8552                	mv	a0,s4
    80002d58:	b6dff0ef          	jal	800028c4 <iunlockput>
      return 0;
    80002d5c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d5e:	8552                	mv	a0,s4
    80002d60:	60e6                	ld	ra,88(sp)
    80002d62:	6446                	ld	s0,80(sp)
    80002d64:	64a6                	ld	s1,72(sp)
    80002d66:	6906                	ld	s2,64(sp)
    80002d68:	79e2                	ld	s3,56(sp)
    80002d6a:	7a42                	ld	s4,48(sp)
    80002d6c:	7aa2                	ld	s5,40(sp)
    80002d6e:	7b02                	ld	s6,32(sp)
    80002d70:	6be2                	ld	s7,24(sp)
    80002d72:	6c42                	ld	s8,16(sp)
    80002d74:	6ca2                	ld	s9,8(sp)
    80002d76:	6125                	addi	sp,sp,96
    80002d78:	8082                	ret
      iunlock(ip);
    80002d7a:	8552                	mv	a0,s4
    80002d7c:	9edff0ef          	jal	80002768 <iunlock>
      return ip;
    80002d80:	bff9                	j	80002d5e <namex+0x58>
      iunlockput(ip);
    80002d82:	8552                	mv	a0,s4
    80002d84:	b41ff0ef          	jal	800028c4 <iunlockput>
      return 0;
    80002d88:	8a4e                	mv	s4,s3
    80002d8a:	bfd1                	j	80002d5e <namex+0x58>
  len = path - s;
    80002d8c:	40998633          	sub	a2,s3,s1
    80002d90:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d94:	099c5063          	bge	s8,s9,80002e14 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d98:	4639                	li	a2,14
    80002d9a:	85a6                	mv	a1,s1
    80002d9c:	8556                	mv	a0,s5
    80002d9e:	c0cfd0ef          	jal	800001aa <memmove>
    80002da2:	84ce                	mv	s1,s3
  while(*path == '/')
    80002da4:	0004c783          	lbu	a5,0(s1)
    80002da8:	01279763          	bne	a5,s2,80002db6 <namex+0xb0>
    path++;
    80002dac:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dae:	0004c783          	lbu	a5,0(s1)
    80002db2:	ff278de3          	beq	a5,s2,80002dac <namex+0xa6>
    ilock(ip);
    80002db6:	8552                	mv	a0,s4
    80002db8:	903ff0ef          	jal	800026ba <ilock>
    if(ip->type != T_DIR){
    80002dbc:	044a1783          	lh	a5,68(s4)
    80002dc0:	f9779be3          	bne	a5,s7,80002d56 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002dc4:	000b0563          	beqz	s6,80002dce <namex+0xc8>
    80002dc8:	0004c783          	lbu	a5,0(s1)
    80002dcc:	d7dd                	beqz	a5,80002d7a <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002dce:	4601                	li	a2,0
    80002dd0:	85d6                	mv	a1,s5
    80002dd2:	8552                	mv	a0,s4
    80002dd4:	e97ff0ef          	jal	80002c6a <dirlookup>
    80002dd8:	89aa                	mv	s3,a0
    80002dda:	d545                	beqz	a0,80002d82 <namex+0x7c>
    iunlockput(ip);
    80002ddc:	8552                	mv	a0,s4
    80002dde:	ae7ff0ef          	jal	800028c4 <iunlockput>
    ip = next;
    80002de2:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002de4:	0004c783          	lbu	a5,0(s1)
    80002de8:	01279763          	bne	a5,s2,80002df6 <namex+0xf0>
    path++;
    80002dec:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dee:	0004c783          	lbu	a5,0(s1)
    80002df2:	ff278de3          	beq	a5,s2,80002dec <namex+0xe6>
  if(*path == 0)
    80002df6:	cb8d                	beqz	a5,80002e28 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002df8:	0004c783          	lbu	a5,0(s1)
    80002dfc:	89a6                	mv	s3,s1
  len = path - s;
    80002dfe:	4c81                	li	s9,0
    80002e00:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002e02:	01278963          	beq	a5,s2,80002e14 <namex+0x10e>
    80002e06:	d3d9                	beqz	a5,80002d8c <namex+0x86>
    path++;
    80002e08:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002e0a:	0009c783          	lbu	a5,0(s3)
    80002e0e:	ff279ce3          	bne	a5,s2,80002e06 <namex+0x100>
    80002e12:	bfad                	j	80002d8c <namex+0x86>
    memmove(name, s, len);
    80002e14:	2601                	sext.w	a2,a2
    80002e16:	85a6                	mv	a1,s1
    80002e18:	8556                	mv	a0,s5
    80002e1a:	b90fd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002e1e:	9cd6                	add	s9,s9,s5
    80002e20:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002e24:	84ce                	mv	s1,s3
    80002e26:	bfbd                	j	80002da4 <namex+0x9e>
  if(nameiparent){
    80002e28:	f20b0be3          	beqz	s6,80002d5e <namex+0x58>
    iput(ip);
    80002e2c:	8552                	mv	a0,s4
    80002e2e:	a0fff0ef          	jal	8000283c <iput>
    return 0;
    80002e32:	4a01                	li	s4,0
    80002e34:	b72d                	j	80002d5e <namex+0x58>

0000000080002e36 <dirlink>:
{
    80002e36:	7139                	addi	sp,sp,-64
    80002e38:	fc06                	sd	ra,56(sp)
    80002e3a:	f822                	sd	s0,48(sp)
    80002e3c:	f04a                	sd	s2,32(sp)
    80002e3e:	ec4e                	sd	s3,24(sp)
    80002e40:	e852                	sd	s4,16(sp)
    80002e42:	0080                	addi	s0,sp,64
    80002e44:	892a                	mv	s2,a0
    80002e46:	8a2e                	mv	s4,a1
    80002e48:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e4a:	4601                	li	a2,0
    80002e4c:	e1fff0ef          	jal	80002c6a <dirlookup>
    80002e50:	e535                	bnez	a0,80002ebc <dirlink+0x86>
    80002e52:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e54:	04c92483          	lw	s1,76(s2)
    80002e58:	c48d                	beqz	s1,80002e82 <dirlink+0x4c>
    80002e5a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e5c:	4741                	li	a4,16
    80002e5e:	86a6                	mv	a3,s1
    80002e60:	fc040613          	addi	a2,s0,-64
    80002e64:	4581                	li	a1,0
    80002e66:	854a                	mv	a0,s2
    80002e68:	be3ff0ef          	jal	80002a4a <readi>
    80002e6c:	47c1                	li	a5,16
    80002e6e:	04f51b63          	bne	a0,a5,80002ec4 <dirlink+0x8e>
    if(de.inum == 0)
    80002e72:	fc045783          	lhu	a5,-64(s0)
    80002e76:	c791                	beqz	a5,80002e82 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e78:	24c1                	addiw	s1,s1,16
    80002e7a:	04c92783          	lw	a5,76(s2)
    80002e7e:	fcf4efe3          	bltu	s1,a5,80002e5c <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e82:	4639                	li	a2,14
    80002e84:	85d2                	mv	a1,s4
    80002e86:	fc240513          	addi	a0,s0,-62
    80002e8a:	bc6fd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002e8e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e92:	4741                	li	a4,16
    80002e94:	86a6                	mv	a3,s1
    80002e96:	fc040613          	addi	a2,s0,-64
    80002e9a:	4581                	li	a1,0
    80002e9c:	854a                	mv	a0,s2
    80002e9e:	ca9ff0ef          	jal	80002b46 <writei>
    80002ea2:	1541                	addi	a0,a0,-16
    80002ea4:	00a03533          	snez	a0,a0
    80002ea8:	40a00533          	neg	a0,a0
    80002eac:	74a2                	ld	s1,40(sp)
}
    80002eae:	70e2                	ld	ra,56(sp)
    80002eb0:	7442                	ld	s0,48(sp)
    80002eb2:	7902                	ld	s2,32(sp)
    80002eb4:	69e2                	ld	s3,24(sp)
    80002eb6:	6a42                	ld	s4,16(sp)
    80002eb8:	6121                	addi	sp,sp,64
    80002eba:	8082                	ret
    iput(ip);
    80002ebc:	981ff0ef          	jal	8000283c <iput>
    return -1;
    80002ec0:	557d                	li	a0,-1
    80002ec2:	b7f5                	j	80002eae <dirlink+0x78>
      panic("dirlink read");
    80002ec4:	00004517          	auipc	a0,0x4
    80002ec8:	5a450513          	addi	a0,a0,1444 # 80007468 <etext+0x468>
    80002ecc:	732020ef          	jal	800055fe <panic>

0000000080002ed0 <namei>:

struct inode*
namei(char *path)
{
    80002ed0:	1101                	addi	sp,sp,-32
    80002ed2:	ec06                	sd	ra,24(sp)
    80002ed4:	e822                	sd	s0,16(sp)
    80002ed6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002ed8:	fe040613          	addi	a2,s0,-32
    80002edc:	4581                	li	a1,0
    80002ede:	e29ff0ef          	jal	80002d06 <namex>
}
    80002ee2:	60e2                	ld	ra,24(sp)
    80002ee4:	6442                	ld	s0,16(sp)
    80002ee6:	6105                	addi	sp,sp,32
    80002ee8:	8082                	ret

0000000080002eea <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002eea:	1141                	addi	sp,sp,-16
    80002eec:	e406                	sd	ra,8(sp)
    80002eee:	e022                	sd	s0,0(sp)
    80002ef0:	0800                	addi	s0,sp,16
    80002ef2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002ef4:	4585                	li	a1,1
    80002ef6:	e11ff0ef          	jal	80002d06 <namex>
}
    80002efa:	60a2                	ld	ra,8(sp)
    80002efc:	6402                	ld	s0,0(sp)
    80002efe:	0141                	addi	sp,sp,16
    80002f00:	8082                	ret

0000000080002f02 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f02:	1101                	addi	sp,sp,-32
    80002f04:	ec06                	sd	ra,24(sp)
    80002f06:	e822                	sd	s0,16(sp)
    80002f08:	e426                	sd	s1,8(sp)
    80002f0a:	e04a                	sd	s2,0(sp)
    80002f0c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f0e:	00017917          	auipc	s2,0x17
    80002f12:	2b290913          	addi	s2,s2,690 # 8001a1c0 <log>
    80002f16:	01892583          	lw	a1,24(s2)
    80002f1a:	02492503          	lw	a0,36(s2)
    80002f1e:	8d0ff0ef          	jal	80001fee <bread>
    80002f22:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f24:	02892603          	lw	a2,40(s2)
    80002f28:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f2a:	00c05f63          	blez	a2,80002f48 <write_head+0x46>
    80002f2e:	00017717          	auipc	a4,0x17
    80002f32:	2be70713          	addi	a4,a4,702 # 8001a1ec <log+0x2c>
    80002f36:	87aa                	mv	a5,a0
    80002f38:	060a                	slli	a2,a2,0x2
    80002f3a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f3c:	4314                	lw	a3,0(a4)
    80002f3e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f40:	0711                	addi	a4,a4,4
    80002f42:	0791                	addi	a5,a5,4
    80002f44:	fec79ce3          	bne	a5,a2,80002f3c <write_head+0x3a>
  }
  bwrite(buf);
    80002f48:	8526                	mv	a0,s1
    80002f4a:	97aff0ef          	jal	800020c4 <bwrite>
  brelse(buf);
    80002f4e:	8526                	mv	a0,s1
    80002f50:	9a6ff0ef          	jal	800020f6 <brelse>
}
    80002f54:	60e2                	ld	ra,24(sp)
    80002f56:	6442                	ld	s0,16(sp)
    80002f58:	64a2                	ld	s1,8(sp)
    80002f5a:	6902                	ld	s2,0(sp)
    80002f5c:	6105                	addi	sp,sp,32
    80002f5e:	8082                	ret

0000000080002f60 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f60:	00017797          	auipc	a5,0x17
    80002f64:	2887a783          	lw	a5,648(a5) # 8001a1e8 <log+0x28>
    80002f68:	0af05e63          	blez	a5,80003024 <install_trans+0xc4>
{
    80002f6c:	715d                	addi	sp,sp,-80
    80002f6e:	e486                	sd	ra,72(sp)
    80002f70:	e0a2                	sd	s0,64(sp)
    80002f72:	fc26                	sd	s1,56(sp)
    80002f74:	f84a                	sd	s2,48(sp)
    80002f76:	f44e                	sd	s3,40(sp)
    80002f78:	f052                	sd	s4,32(sp)
    80002f7a:	ec56                	sd	s5,24(sp)
    80002f7c:	e85a                	sd	s6,16(sp)
    80002f7e:	e45e                	sd	s7,8(sp)
    80002f80:	0880                	addi	s0,sp,80
    80002f82:	8b2a                	mv	s6,a0
    80002f84:	00017a97          	auipc	s5,0x17
    80002f88:	268a8a93          	addi	s5,s5,616 # 8001a1ec <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f8c:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002f8e:	00004b97          	auipc	s7,0x4
    80002f92:	4eab8b93          	addi	s7,s7,1258 # 80007478 <etext+0x478>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f96:	00017a17          	auipc	s4,0x17
    80002f9a:	22aa0a13          	addi	s4,s4,554 # 8001a1c0 <log>
    80002f9e:	a025                	j	80002fc6 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002fa0:	000aa603          	lw	a2,0(s5)
    80002fa4:	85ce                	mv	a1,s3
    80002fa6:	855e                	mv	a0,s7
    80002fa8:	370020ef          	jal	80005318 <printf>
    80002fac:	a839                	j	80002fca <install_trans+0x6a>
    brelse(lbuf);
    80002fae:	854a                	mv	a0,s2
    80002fb0:	946ff0ef          	jal	800020f6 <brelse>
    brelse(dbuf);
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	940ff0ef          	jal	800020f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fba:	2985                	addiw	s3,s3,1
    80002fbc:	0a91                	addi	s5,s5,4
    80002fbe:	028a2783          	lw	a5,40(s4)
    80002fc2:	04f9d663          	bge	s3,a5,8000300e <install_trans+0xae>
    if(recovering) {
    80002fc6:	fc0b1de3          	bnez	s6,80002fa0 <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fca:	018a2583          	lw	a1,24(s4)
    80002fce:	013585bb          	addw	a1,a1,s3
    80002fd2:	2585                	addiw	a1,a1,1
    80002fd4:	024a2503          	lw	a0,36(s4)
    80002fd8:	816ff0ef          	jal	80001fee <bread>
    80002fdc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002fde:	000aa583          	lw	a1,0(s5)
    80002fe2:	024a2503          	lw	a0,36(s4)
    80002fe6:	808ff0ef          	jal	80001fee <bread>
    80002fea:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fec:	40000613          	li	a2,1024
    80002ff0:	05890593          	addi	a1,s2,88
    80002ff4:	05850513          	addi	a0,a0,88
    80002ff8:	9b2fd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002ffc:	8526                	mv	a0,s1
    80002ffe:	8c6ff0ef          	jal	800020c4 <bwrite>
    if(recovering == 0)
    80003002:	fa0b16e3          	bnez	s6,80002fae <install_trans+0x4e>
      bunpin(dbuf);
    80003006:	8526                	mv	a0,s1
    80003008:	9aaff0ef          	jal	800021b2 <bunpin>
    8000300c:	b74d                	j	80002fae <install_trans+0x4e>
}
    8000300e:	60a6                	ld	ra,72(sp)
    80003010:	6406                	ld	s0,64(sp)
    80003012:	74e2                	ld	s1,56(sp)
    80003014:	7942                	ld	s2,48(sp)
    80003016:	79a2                	ld	s3,40(sp)
    80003018:	7a02                	ld	s4,32(sp)
    8000301a:	6ae2                	ld	s5,24(sp)
    8000301c:	6b42                	ld	s6,16(sp)
    8000301e:	6ba2                	ld	s7,8(sp)
    80003020:	6161                	addi	sp,sp,80
    80003022:	8082                	ret
    80003024:	8082                	ret

0000000080003026 <initlog>:
{
    80003026:	7179                	addi	sp,sp,-48
    80003028:	f406                	sd	ra,40(sp)
    8000302a:	f022                	sd	s0,32(sp)
    8000302c:	ec26                	sd	s1,24(sp)
    8000302e:	e84a                	sd	s2,16(sp)
    80003030:	e44e                	sd	s3,8(sp)
    80003032:	1800                	addi	s0,sp,48
    80003034:	892a                	mv	s2,a0
    80003036:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003038:	00017497          	auipc	s1,0x17
    8000303c:	18848493          	addi	s1,s1,392 # 8001a1c0 <log>
    80003040:	00004597          	auipc	a1,0x4
    80003044:	45858593          	addi	a1,a1,1112 # 80007498 <etext+0x498>
    80003048:	8526                	mv	a0,s1
    8000304a:	7f0020ef          	jal	8000583a <initlock>
  log.start = sb->logstart;
    8000304e:	0149a583          	lw	a1,20(s3)
    80003052:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003054:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003058:	854a                	mv	a0,s2
    8000305a:	f95fe0ef          	jal	80001fee <bread>
  log.lh.n = lh->n;
    8000305e:	4d30                	lw	a2,88(a0)
    80003060:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003062:	00c05f63          	blez	a2,80003080 <initlog+0x5a>
    80003066:	87aa                	mv	a5,a0
    80003068:	00017717          	auipc	a4,0x17
    8000306c:	18470713          	addi	a4,a4,388 # 8001a1ec <log+0x2c>
    80003070:	060a                	slli	a2,a2,0x2
    80003072:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003074:	4ff4                	lw	a3,92(a5)
    80003076:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003078:	0791                	addi	a5,a5,4
    8000307a:	0711                	addi	a4,a4,4
    8000307c:	fec79ce3          	bne	a5,a2,80003074 <initlog+0x4e>
  brelse(buf);
    80003080:	876ff0ef          	jal	800020f6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003084:	4505                	li	a0,1
    80003086:	edbff0ef          	jal	80002f60 <install_trans>
  log.lh.n = 0;
    8000308a:	00017797          	auipc	a5,0x17
    8000308e:	1407af23          	sw	zero,350(a5) # 8001a1e8 <log+0x28>
  write_head(); // clear the log
    80003092:	e71ff0ef          	jal	80002f02 <write_head>
}
    80003096:	70a2                	ld	ra,40(sp)
    80003098:	7402                	ld	s0,32(sp)
    8000309a:	64e2                	ld	s1,24(sp)
    8000309c:	6942                	ld	s2,16(sp)
    8000309e:	69a2                	ld	s3,8(sp)
    800030a0:	6145                	addi	sp,sp,48
    800030a2:	8082                	ret

00000000800030a4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030a4:	1101                	addi	sp,sp,-32
    800030a6:	ec06                	sd	ra,24(sp)
    800030a8:	e822                	sd	s0,16(sp)
    800030aa:	e426                	sd	s1,8(sp)
    800030ac:	e04a                	sd	s2,0(sp)
    800030ae:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800030b0:	00017517          	auipc	a0,0x17
    800030b4:	11050513          	addi	a0,a0,272 # 8001a1c0 <log>
    800030b8:	003020ef          	jal	800058ba <acquire>
  while(1){
    if(log.committing){
    800030bc:	00017497          	auipc	s1,0x17
    800030c0:	10448493          	addi	s1,s1,260 # 8001a1c0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030c4:	4979                	li	s2,30
    800030c6:	a029                	j	800030d0 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030c8:	85a6                	mv	a1,s1
    800030ca:	8526                	mv	a0,s1
    800030cc:	aa6fe0ef          	jal	80001372 <sleep>
    if(log.committing){
    800030d0:	509c                	lw	a5,32(s1)
    800030d2:	fbfd                	bnez	a5,800030c8 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030d4:	4cd8                	lw	a4,28(s1)
    800030d6:	2705                	addiw	a4,a4,1
    800030d8:	0027179b          	slliw	a5,a4,0x2
    800030dc:	9fb9                	addw	a5,a5,a4
    800030de:	0017979b          	slliw	a5,a5,0x1
    800030e2:	5494                	lw	a3,40(s1)
    800030e4:	9fb5                	addw	a5,a5,a3
    800030e6:	00f95763          	bge	s2,a5,800030f4 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800030ea:	85a6                	mv	a1,s1
    800030ec:	8526                	mv	a0,s1
    800030ee:	a84fe0ef          	jal	80001372 <sleep>
    800030f2:	bff9                	j	800030d0 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800030f4:	00017517          	auipc	a0,0x17
    800030f8:	0cc50513          	addi	a0,a0,204 # 8001a1c0 <log>
    800030fc:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    800030fe:	055020ef          	jal	80005952 <release>
      break;
    }
  }
}
    80003102:	60e2                	ld	ra,24(sp)
    80003104:	6442                	ld	s0,16(sp)
    80003106:	64a2                	ld	s1,8(sp)
    80003108:	6902                	ld	s2,0(sp)
    8000310a:	6105                	addi	sp,sp,32
    8000310c:	8082                	ret

000000008000310e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000310e:	7139                	addi	sp,sp,-64
    80003110:	fc06                	sd	ra,56(sp)
    80003112:	f822                	sd	s0,48(sp)
    80003114:	f426                	sd	s1,40(sp)
    80003116:	f04a                	sd	s2,32(sp)
    80003118:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000311a:	00017497          	auipc	s1,0x17
    8000311e:	0a648493          	addi	s1,s1,166 # 8001a1c0 <log>
    80003122:	8526                	mv	a0,s1
    80003124:	796020ef          	jal	800058ba <acquire>
  log.outstanding -= 1;
    80003128:	4cdc                	lw	a5,28(s1)
    8000312a:	37fd                	addiw	a5,a5,-1
    8000312c:	0007891b          	sext.w	s2,a5
    80003130:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003132:	509c                	lw	a5,32(s1)
    80003134:	ef9d                	bnez	a5,80003172 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003136:	04091763          	bnez	s2,80003184 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000313a:	00017497          	auipc	s1,0x17
    8000313e:	08648493          	addi	s1,s1,134 # 8001a1c0 <log>
    80003142:	4785                	li	a5,1
    80003144:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003146:	8526                	mv	a0,s1
    80003148:	00b020ef          	jal	80005952 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000314c:	549c                	lw	a5,40(s1)
    8000314e:	04f04b63          	bgtz	a5,800031a4 <end_op+0x96>
    acquire(&log.lock);
    80003152:	00017497          	auipc	s1,0x17
    80003156:	06e48493          	addi	s1,s1,110 # 8001a1c0 <log>
    8000315a:	8526                	mv	a0,s1
    8000315c:	75e020ef          	jal	800058ba <acquire>
    log.committing = 0;
    80003160:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003164:	8526                	mv	a0,s1
    80003166:	a58fe0ef          	jal	800013be <wakeup>
    release(&log.lock);
    8000316a:	8526                	mv	a0,s1
    8000316c:	7e6020ef          	jal	80005952 <release>
}
    80003170:	a025                	j	80003198 <end_op+0x8a>
    80003172:	ec4e                	sd	s3,24(sp)
    80003174:	e852                	sd	s4,16(sp)
    80003176:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003178:	00004517          	auipc	a0,0x4
    8000317c:	32850513          	addi	a0,a0,808 # 800074a0 <etext+0x4a0>
    80003180:	47e020ef          	jal	800055fe <panic>
    wakeup(&log);
    80003184:	00017497          	auipc	s1,0x17
    80003188:	03c48493          	addi	s1,s1,60 # 8001a1c0 <log>
    8000318c:	8526                	mv	a0,s1
    8000318e:	a30fe0ef          	jal	800013be <wakeup>
  release(&log.lock);
    80003192:	8526                	mv	a0,s1
    80003194:	7be020ef          	jal	80005952 <release>
}
    80003198:	70e2                	ld	ra,56(sp)
    8000319a:	7442                	ld	s0,48(sp)
    8000319c:	74a2                	ld	s1,40(sp)
    8000319e:	7902                	ld	s2,32(sp)
    800031a0:	6121                	addi	sp,sp,64
    800031a2:	8082                	ret
    800031a4:	ec4e                	sd	s3,24(sp)
    800031a6:	e852                	sd	s4,16(sp)
    800031a8:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800031aa:	00017a97          	auipc	s5,0x17
    800031ae:	042a8a93          	addi	s5,s5,66 # 8001a1ec <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031b2:	00017a17          	auipc	s4,0x17
    800031b6:	00ea0a13          	addi	s4,s4,14 # 8001a1c0 <log>
    800031ba:	018a2583          	lw	a1,24(s4)
    800031be:	012585bb          	addw	a1,a1,s2
    800031c2:	2585                	addiw	a1,a1,1
    800031c4:	024a2503          	lw	a0,36(s4)
    800031c8:	e27fe0ef          	jal	80001fee <bread>
    800031cc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031ce:	000aa583          	lw	a1,0(s5)
    800031d2:	024a2503          	lw	a0,36(s4)
    800031d6:	e19fe0ef          	jal	80001fee <bread>
    800031da:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031dc:	40000613          	li	a2,1024
    800031e0:	05850593          	addi	a1,a0,88
    800031e4:	05848513          	addi	a0,s1,88
    800031e8:	fc3fc0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    800031ec:	8526                	mv	a0,s1
    800031ee:	ed7fe0ef          	jal	800020c4 <bwrite>
    brelse(from);
    800031f2:	854e                	mv	a0,s3
    800031f4:	f03fe0ef          	jal	800020f6 <brelse>
    brelse(to);
    800031f8:	8526                	mv	a0,s1
    800031fa:	efdfe0ef          	jal	800020f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031fe:	2905                	addiw	s2,s2,1
    80003200:	0a91                	addi	s5,s5,4
    80003202:	028a2783          	lw	a5,40(s4)
    80003206:	faf94ae3          	blt	s2,a5,800031ba <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000320a:	cf9ff0ef          	jal	80002f02 <write_head>
    install_trans(0); // Now install writes to home locations
    8000320e:	4501                	li	a0,0
    80003210:	d51ff0ef          	jal	80002f60 <install_trans>
    log.lh.n = 0;
    80003214:	00017797          	auipc	a5,0x17
    80003218:	fc07aa23          	sw	zero,-44(a5) # 8001a1e8 <log+0x28>
    write_head();    // Erase the transaction from the log
    8000321c:	ce7ff0ef          	jal	80002f02 <write_head>
    80003220:	69e2                	ld	s3,24(sp)
    80003222:	6a42                	ld	s4,16(sp)
    80003224:	6aa2                	ld	s5,8(sp)
    80003226:	b735                	j	80003152 <end_op+0x44>

0000000080003228 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003228:	1101                	addi	sp,sp,-32
    8000322a:	ec06                	sd	ra,24(sp)
    8000322c:	e822                	sd	s0,16(sp)
    8000322e:	e426                	sd	s1,8(sp)
    80003230:	e04a                	sd	s2,0(sp)
    80003232:	1000                	addi	s0,sp,32
    80003234:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003236:	00017917          	auipc	s2,0x17
    8000323a:	f8a90913          	addi	s2,s2,-118 # 8001a1c0 <log>
    8000323e:	854a                	mv	a0,s2
    80003240:	67a020ef          	jal	800058ba <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003244:	02892603          	lw	a2,40(s2)
    80003248:	47f5                	li	a5,29
    8000324a:	04c7cc63          	blt	a5,a2,800032a2 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000324e:	00017797          	auipc	a5,0x17
    80003252:	f8e7a783          	lw	a5,-114(a5) # 8001a1dc <log+0x1c>
    80003256:	04f05c63          	blez	a5,800032ae <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000325a:	4781                	li	a5,0
    8000325c:	04c05f63          	blez	a2,800032ba <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003260:	44cc                	lw	a1,12(s1)
    80003262:	00017717          	auipc	a4,0x17
    80003266:	f8a70713          	addi	a4,a4,-118 # 8001a1ec <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    8000326a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000326c:	4314                	lw	a3,0(a4)
    8000326e:	04b68663          	beq	a3,a1,800032ba <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003272:	2785                	addiw	a5,a5,1
    80003274:	0711                	addi	a4,a4,4
    80003276:	fef61be3          	bne	a2,a5,8000326c <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000327a:	0621                	addi	a2,a2,8
    8000327c:	060a                	slli	a2,a2,0x2
    8000327e:	00017797          	auipc	a5,0x17
    80003282:	f4278793          	addi	a5,a5,-190 # 8001a1c0 <log>
    80003286:	97b2                	add	a5,a5,a2
    80003288:	44d8                	lw	a4,12(s1)
    8000328a:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000328c:	8526                	mv	a0,s1
    8000328e:	ef1fe0ef          	jal	8000217e <bpin>
    log.lh.n++;
    80003292:	00017717          	auipc	a4,0x17
    80003296:	f2e70713          	addi	a4,a4,-210 # 8001a1c0 <log>
    8000329a:	571c                	lw	a5,40(a4)
    8000329c:	2785                	addiw	a5,a5,1
    8000329e:	d71c                	sw	a5,40(a4)
    800032a0:	a80d                	j	800032d2 <log_write+0xaa>
    panic("too big a transaction");
    800032a2:	00004517          	auipc	a0,0x4
    800032a6:	20e50513          	addi	a0,a0,526 # 800074b0 <etext+0x4b0>
    800032aa:	354020ef          	jal	800055fe <panic>
    panic("log_write outside of trans");
    800032ae:	00004517          	auipc	a0,0x4
    800032b2:	21a50513          	addi	a0,a0,538 # 800074c8 <etext+0x4c8>
    800032b6:	348020ef          	jal	800055fe <panic>
  log.lh.block[i] = b->blockno;
    800032ba:	00878693          	addi	a3,a5,8
    800032be:	068a                	slli	a3,a3,0x2
    800032c0:	00017717          	auipc	a4,0x17
    800032c4:	f0070713          	addi	a4,a4,-256 # 8001a1c0 <log>
    800032c8:	9736                	add	a4,a4,a3
    800032ca:	44d4                	lw	a3,12(s1)
    800032cc:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032ce:	faf60fe3          	beq	a2,a5,8000328c <log_write+0x64>
  }
  release(&log.lock);
    800032d2:	00017517          	auipc	a0,0x17
    800032d6:	eee50513          	addi	a0,a0,-274 # 8001a1c0 <log>
    800032da:	678020ef          	jal	80005952 <release>
}
    800032de:	60e2                	ld	ra,24(sp)
    800032e0:	6442                	ld	s0,16(sp)
    800032e2:	64a2                	ld	s1,8(sp)
    800032e4:	6902                	ld	s2,0(sp)
    800032e6:	6105                	addi	sp,sp,32
    800032e8:	8082                	ret

00000000800032ea <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800032ea:	1101                	addi	sp,sp,-32
    800032ec:	ec06                	sd	ra,24(sp)
    800032ee:	e822                	sd	s0,16(sp)
    800032f0:	e426                	sd	s1,8(sp)
    800032f2:	e04a                	sd	s2,0(sp)
    800032f4:	1000                	addi	s0,sp,32
    800032f6:	84aa                	mv	s1,a0
    800032f8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800032fa:	00004597          	auipc	a1,0x4
    800032fe:	1ee58593          	addi	a1,a1,494 # 800074e8 <etext+0x4e8>
    80003302:	0521                	addi	a0,a0,8
    80003304:	536020ef          	jal	8000583a <initlock>
  lk->name = name;
    80003308:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000330c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003310:	0204a423          	sw	zero,40(s1)
}
    80003314:	60e2                	ld	ra,24(sp)
    80003316:	6442                	ld	s0,16(sp)
    80003318:	64a2                	ld	s1,8(sp)
    8000331a:	6902                	ld	s2,0(sp)
    8000331c:	6105                	addi	sp,sp,32
    8000331e:	8082                	ret

0000000080003320 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003320:	1101                	addi	sp,sp,-32
    80003322:	ec06                	sd	ra,24(sp)
    80003324:	e822                	sd	s0,16(sp)
    80003326:	e426                	sd	s1,8(sp)
    80003328:	e04a                	sd	s2,0(sp)
    8000332a:	1000                	addi	s0,sp,32
    8000332c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000332e:	00850913          	addi	s2,a0,8
    80003332:	854a                	mv	a0,s2
    80003334:	586020ef          	jal	800058ba <acquire>
  while (lk->locked) {
    80003338:	409c                	lw	a5,0(s1)
    8000333a:	c799                	beqz	a5,80003348 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000333c:	85ca                	mv	a1,s2
    8000333e:	8526                	mv	a0,s1
    80003340:	832fe0ef          	jal	80001372 <sleep>
  while (lk->locked) {
    80003344:	409c                	lw	a5,0(s1)
    80003346:	fbfd                	bnez	a5,8000333c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003348:	4785                	li	a5,1
    8000334a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000334c:	a2ffd0ef          	jal	80000d7a <myproc>
    80003350:	591c                	lw	a5,48(a0)
    80003352:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003354:	854a                	mv	a0,s2
    80003356:	5fc020ef          	jal	80005952 <release>
}
    8000335a:	60e2                	ld	ra,24(sp)
    8000335c:	6442                	ld	s0,16(sp)
    8000335e:	64a2                	ld	s1,8(sp)
    80003360:	6902                	ld	s2,0(sp)
    80003362:	6105                	addi	sp,sp,32
    80003364:	8082                	ret

0000000080003366 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003366:	1101                	addi	sp,sp,-32
    80003368:	ec06                	sd	ra,24(sp)
    8000336a:	e822                	sd	s0,16(sp)
    8000336c:	e426                	sd	s1,8(sp)
    8000336e:	e04a                	sd	s2,0(sp)
    80003370:	1000                	addi	s0,sp,32
    80003372:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003374:	00850913          	addi	s2,a0,8
    80003378:	854a                	mv	a0,s2
    8000337a:	540020ef          	jal	800058ba <acquire>
  lk->locked = 0;
    8000337e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003382:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003386:	8526                	mv	a0,s1
    80003388:	836fe0ef          	jal	800013be <wakeup>
  release(&lk->lk);
    8000338c:	854a                	mv	a0,s2
    8000338e:	5c4020ef          	jal	80005952 <release>
}
    80003392:	60e2                	ld	ra,24(sp)
    80003394:	6442                	ld	s0,16(sp)
    80003396:	64a2                	ld	s1,8(sp)
    80003398:	6902                	ld	s2,0(sp)
    8000339a:	6105                	addi	sp,sp,32
    8000339c:	8082                	ret

000000008000339e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000339e:	7179                	addi	sp,sp,-48
    800033a0:	f406                	sd	ra,40(sp)
    800033a2:	f022                	sd	s0,32(sp)
    800033a4:	ec26                	sd	s1,24(sp)
    800033a6:	e84a                	sd	s2,16(sp)
    800033a8:	1800                	addi	s0,sp,48
    800033aa:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033ac:	00850913          	addi	s2,a0,8
    800033b0:	854a                	mv	a0,s2
    800033b2:	508020ef          	jal	800058ba <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033b6:	409c                	lw	a5,0(s1)
    800033b8:	ef81                	bnez	a5,800033d0 <holdingsleep+0x32>
    800033ba:	4481                	li	s1,0
  release(&lk->lk);
    800033bc:	854a                	mv	a0,s2
    800033be:	594020ef          	jal	80005952 <release>
  return r;
}
    800033c2:	8526                	mv	a0,s1
    800033c4:	70a2                	ld	ra,40(sp)
    800033c6:	7402                	ld	s0,32(sp)
    800033c8:	64e2                	ld	s1,24(sp)
    800033ca:	6942                	ld	s2,16(sp)
    800033cc:	6145                	addi	sp,sp,48
    800033ce:	8082                	ret
    800033d0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800033d2:	0284a983          	lw	s3,40(s1)
    800033d6:	9a5fd0ef          	jal	80000d7a <myproc>
    800033da:	5904                	lw	s1,48(a0)
    800033dc:	413484b3          	sub	s1,s1,s3
    800033e0:	0014b493          	seqz	s1,s1
    800033e4:	69a2                	ld	s3,8(sp)
    800033e6:	bfd9                	j	800033bc <holdingsleep+0x1e>

00000000800033e8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800033e8:	1141                	addi	sp,sp,-16
    800033ea:	e406                	sd	ra,8(sp)
    800033ec:	e022                	sd	s0,0(sp)
    800033ee:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800033f0:	00004597          	auipc	a1,0x4
    800033f4:	10858593          	addi	a1,a1,264 # 800074f8 <etext+0x4f8>
    800033f8:	00017517          	auipc	a0,0x17
    800033fc:	f1050513          	addi	a0,a0,-240 # 8001a308 <ftable>
    80003400:	43a020ef          	jal	8000583a <initlock>
}
    80003404:	60a2                	ld	ra,8(sp)
    80003406:	6402                	ld	s0,0(sp)
    80003408:	0141                	addi	sp,sp,16
    8000340a:	8082                	ret

000000008000340c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000340c:	1101                	addi	sp,sp,-32
    8000340e:	ec06                	sd	ra,24(sp)
    80003410:	e822                	sd	s0,16(sp)
    80003412:	e426                	sd	s1,8(sp)
    80003414:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003416:	00017517          	auipc	a0,0x17
    8000341a:	ef250513          	addi	a0,a0,-270 # 8001a308 <ftable>
    8000341e:	49c020ef          	jal	800058ba <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003422:	00017497          	auipc	s1,0x17
    80003426:	efe48493          	addi	s1,s1,-258 # 8001a320 <ftable+0x18>
    8000342a:	00018717          	auipc	a4,0x18
    8000342e:	e9670713          	addi	a4,a4,-362 # 8001b2c0 <disk>
    if(f->ref == 0){
    80003432:	40dc                	lw	a5,4(s1)
    80003434:	cf89                	beqz	a5,8000344e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003436:	02848493          	addi	s1,s1,40
    8000343a:	fee49ce3          	bne	s1,a4,80003432 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000343e:	00017517          	auipc	a0,0x17
    80003442:	eca50513          	addi	a0,a0,-310 # 8001a308 <ftable>
    80003446:	50c020ef          	jal	80005952 <release>
  return 0;
    8000344a:	4481                	li	s1,0
    8000344c:	a809                	j	8000345e <filealloc+0x52>
      f->ref = 1;
    8000344e:	4785                	li	a5,1
    80003450:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003452:	00017517          	auipc	a0,0x17
    80003456:	eb650513          	addi	a0,a0,-330 # 8001a308 <ftable>
    8000345a:	4f8020ef          	jal	80005952 <release>
}
    8000345e:	8526                	mv	a0,s1
    80003460:	60e2                	ld	ra,24(sp)
    80003462:	6442                	ld	s0,16(sp)
    80003464:	64a2                	ld	s1,8(sp)
    80003466:	6105                	addi	sp,sp,32
    80003468:	8082                	ret

000000008000346a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000346a:	1101                	addi	sp,sp,-32
    8000346c:	ec06                	sd	ra,24(sp)
    8000346e:	e822                	sd	s0,16(sp)
    80003470:	e426                	sd	s1,8(sp)
    80003472:	1000                	addi	s0,sp,32
    80003474:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003476:	00017517          	auipc	a0,0x17
    8000347a:	e9250513          	addi	a0,a0,-366 # 8001a308 <ftable>
    8000347e:	43c020ef          	jal	800058ba <acquire>
  if(f->ref < 1)
    80003482:	40dc                	lw	a5,4(s1)
    80003484:	02f05063          	blez	a5,800034a4 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003488:	2785                	addiw	a5,a5,1
    8000348a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000348c:	00017517          	auipc	a0,0x17
    80003490:	e7c50513          	addi	a0,a0,-388 # 8001a308 <ftable>
    80003494:	4be020ef          	jal	80005952 <release>
  return f;
}
    80003498:	8526                	mv	a0,s1
    8000349a:	60e2                	ld	ra,24(sp)
    8000349c:	6442                	ld	s0,16(sp)
    8000349e:	64a2                	ld	s1,8(sp)
    800034a0:	6105                	addi	sp,sp,32
    800034a2:	8082                	ret
    panic("filedup");
    800034a4:	00004517          	auipc	a0,0x4
    800034a8:	05c50513          	addi	a0,a0,92 # 80007500 <etext+0x500>
    800034ac:	152020ef          	jal	800055fe <panic>

00000000800034b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034b0:	7139                	addi	sp,sp,-64
    800034b2:	fc06                	sd	ra,56(sp)
    800034b4:	f822                	sd	s0,48(sp)
    800034b6:	f426                	sd	s1,40(sp)
    800034b8:	0080                	addi	s0,sp,64
    800034ba:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800034bc:	00017517          	auipc	a0,0x17
    800034c0:	e4c50513          	addi	a0,a0,-436 # 8001a308 <ftable>
    800034c4:	3f6020ef          	jal	800058ba <acquire>
  if(f->ref < 1)
    800034c8:	40dc                	lw	a5,4(s1)
    800034ca:	04f05a63          	blez	a5,8000351e <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800034ce:	37fd                	addiw	a5,a5,-1
    800034d0:	0007871b          	sext.w	a4,a5
    800034d4:	c0dc                	sw	a5,4(s1)
    800034d6:	04e04e63          	bgtz	a4,80003532 <fileclose+0x82>
    800034da:	f04a                	sd	s2,32(sp)
    800034dc:	ec4e                	sd	s3,24(sp)
    800034de:	e852                	sd	s4,16(sp)
    800034e0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800034e2:	0004a903          	lw	s2,0(s1)
    800034e6:	0094ca83          	lbu	s5,9(s1)
    800034ea:	0104ba03          	ld	s4,16(s1)
    800034ee:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800034f2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800034f6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800034fa:	00017517          	auipc	a0,0x17
    800034fe:	e0e50513          	addi	a0,a0,-498 # 8001a308 <ftable>
    80003502:	450020ef          	jal	80005952 <release>

  if(ff.type == FD_PIPE){
    80003506:	4785                	li	a5,1
    80003508:	04f90063          	beq	s2,a5,80003548 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000350c:	3979                	addiw	s2,s2,-2
    8000350e:	4785                	li	a5,1
    80003510:	0527f563          	bgeu	a5,s2,8000355a <fileclose+0xaa>
    80003514:	7902                	ld	s2,32(sp)
    80003516:	69e2                	ld	s3,24(sp)
    80003518:	6a42                	ld	s4,16(sp)
    8000351a:	6aa2                	ld	s5,8(sp)
    8000351c:	a00d                	j	8000353e <fileclose+0x8e>
    8000351e:	f04a                	sd	s2,32(sp)
    80003520:	ec4e                	sd	s3,24(sp)
    80003522:	e852                	sd	s4,16(sp)
    80003524:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003526:	00004517          	auipc	a0,0x4
    8000352a:	fe250513          	addi	a0,a0,-30 # 80007508 <etext+0x508>
    8000352e:	0d0020ef          	jal	800055fe <panic>
    release(&ftable.lock);
    80003532:	00017517          	auipc	a0,0x17
    80003536:	dd650513          	addi	a0,a0,-554 # 8001a308 <ftable>
    8000353a:	418020ef          	jal	80005952 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000353e:	70e2                	ld	ra,56(sp)
    80003540:	7442                	ld	s0,48(sp)
    80003542:	74a2                	ld	s1,40(sp)
    80003544:	6121                	addi	sp,sp,64
    80003546:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003548:	85d6                	mv	a1,s5
    8000354a:	8552                	mv	a0,s4
    8000354c:	336000ef          	jal	80003882 <pipeclose>
    80003550:	7902                	ld	s2,32(sp)
    80003552:	69e2                	ld	s3,24(sp)
    80003554:	6a42                	ld	s4,16(sp)
    80003556:	6aa2                	ld	s5,8(sp)
    80003558:	b7dd                	j	8000353e <fileclose+0x8e>
    begin_op();
    8000355a:	b4bff0ef          	jal	800030a4 <begin_op>
    iput(ff.ip);
    8000355e:	854e                	mv	a0,s3
    80003560:	adcff0ef          	jal	8000283c <iput>
    end_op();
    80003564:	babff0ef          	jal	8000310e <end_op>
    80003568:	7902                	ld	s2,32(sp)
    8000356a:	69e2                	ld	s3,24(sp)
    8000356c:	6a42                	ld	s4,16(sp)
    8000356e:	6aa2                	ld	s5,8(sp)
    80003570:	b7f9                	j	8000353e <fileclose+0x8e>

0000000080003572 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003572:	715d                	addi	sp,sp,-80
    80003574:	e486                	sd	ra,72(sp)
    80003576:	e0a2                	sd	s0,64(sp)
    80003578:	fc26                	sd	s1,56(sp)
    8000357a:	f44e                	sd	s3,40(sp)
    8000357c:	0880                	addi	s0,sp,80
    8000357e:	84aa                	mv	s1,a0
    80003580:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003582:	ff8fd0ef          	jal	80000d7a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003586:	409c                	lw	a5,0(s1)
    80003588:	37f9                	addiw	a5,a5,-2
    8000358a:	4705                	li	a4,1
    8000358c:	04f76063          	bltu	a4,a5,800035cc <filestat+0x5a>
    80003590:	f84a                	sd	s2,48(sp)
    80003592:	892a                	mv	s2,a0
    ilock(f->ip);
    80003594:	6c88                	ld	a0,24(s1)
    80003596:	924ff0ef          	jal	800026ba <ilock>
    stati(f->ip, &st);
    8000359a:	fb840593          	addi	a1,s0,-72
    8000359e:	6c88                	ld	a0,24(s1)
    800035a0:	c80ff0ef          	jal	80002a20 <stati>
    iunlock(f->ip);
    800035a4:	6c88                	ld	a0,24(s1)
    800035a6:	9c2ff0ef          	jal	80002768 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035aa:	46e1                	li	a3,24
    800035ac:	fb840613          	addi	a2,s0,-72
    800035b0:	85ce                	mv	a1,s3
    800035b2:	05093503          	ld	a0,80(s2)
    800035b6:	cd8fd0ef          	jal	80000a8e <copyout>
    800035ba:	41f5551b          	sraiw	a0,a0,0x1f
    800035be:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800035c0:	60a6                	ld	ra,72(sp)
    800035c2:	6406                	ld	s0,64(sp)
    800035c4:	74e2                	ld	s1,56(sp)
    800035c6:	79a2                	ld	s3,40(sp)
    800035c8:	6161                	addi	sp,sp,80
    800035ca:	8082                	ret
  return -1;
    800035cc:	557d                	li	a0,-1
    800035ce:	bfcd                	j	800035c0 <filestat+0x4e>

00000000800035d0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035d0:	7179                	addi	sp,sp,-48
    800035d2:	f406                	sd	ra,40(sp)
    800035d4:	f022                	sd	s0,32(sp)
    800035d6:	e84a                	sd	s2,16(sp)
    800035d8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035da:	00854783          	lbu	a5,8(a0)
    800035de:	cfd1                	beqz	a5,8000367a <fileread+0xaa>
    800035e0:	ec26                	sd	s1,24(sp)
    800035e2:	e44e                	sd	s3,8(sp)
    800035e4:	84aa                	mv	s1,a0
    800035e6:	89ae                	mv	s3,a1
    800035e8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800035ea:	411c                	lw	a5,0(a0)
    800035ec:	4705                	li	a4,1
    800035ee:	04e78363          	beq	a5,a4,80003634 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035f2:	470d                	li	a4,3
    800035f4:	04e78763          	beq	a5,a4,80003642 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800035f8:	4709                	li	a4,2
    800035fa:	06e79a63          	bne	a5,a4,8000366e <fileread+0x9e>
    ilock(f->ip);
    800035fe:	6d08                	ld	a0,24(a0)
    80003600:	8baff0ef          	jal	800026ba <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003604:	874a                	mv	a4,s2
    80003606:	5094                	lw	a3,32(s1)
    80003608:	864e                	mv	a2,s3
    8000360a:	4585                	li	a1,1
    8000360c:	6c88                	ld	a0,24(s1)
    8000360e:	c3cff0ef          	jal	80002a4a <readi>
    80003612:	892a                	mv	s2,a0
    80003614:	00a05563          	blez	a0,8000361e <fileread+0x4e>
      f->off += r;
    80003618:	509c                	lw	a5,32(s1)
    8000361a:	9fa9                	addw	a5,a5,a0
    8000361c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000361e:	6c88                	ld	a0,24(s1)
    80003620:	948ff0ef          	jal	80002768 <iunlock>
    80003624:	64e2                	ld	s1,24(sp)
    80003626:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003628:	854a                	mv	a0,s2
    8000362a:	70a2                	ld	ra,40(sp)
    8000362c:	7402                	ld	s0,32(sp)
    8000362e:	6942                	ld	s2,16(sp)
    80003630:	6145                	addi	sp,sp,48
    80003632:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003634:	6908                	ld	a0,16(a0)
    80003636:	388000ef          	jal	800039be <piperead>
    8000363a:	892a                	mv	s2,a0
    8000363c:	64e2                	ld	s1,24(sp)
    8000363e:	69a2                	ld	s3,8(sp)
    80003640:	b7e5                	j	80003628 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003642:	02451783          	lh	a5,36(a0)
    80003646:	03079693          	slli	a3,a5,0x30
    8000364a:	92c1                	srli	a3,a3,0x30
    8000364c:	4725                	li	a4,9
    8000364e:	02d76863          	bltu	a4,a3,8000367e <fileread+0xae>
    80003652:	0792                	slli	a5,a5,0x4
    80003654:	00017717          	auipc	a4,0x17
    80003658:	c1470713          	addi	a4,a4,-1004 # 8001a268 <devsw>
    8000365c:	97ba                	add	a5,a5,a4
    8000365e:	639c                	ld	a5,0(a5)
    80003660:	c39d                	beqz	a5,80003686 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003662:	4505                	li	a0,1
    80003664:	9782                	jalr	a5
    80003666:	892a                	mv	s2,a0
    80003668:	64e2                	ld	s1,24(sp)
    8000366a:	69a2                	ld	s3,8(sp)
    8000366c:	bf75                	j	80003628 <fileread+0x58>
    panic("fileread");
    8000366e:	00004517          	auipc	a0,0x4
    80003672:	eaa50513          	addi	a0,a0,-342 # 80007518 <etext+0x518>
    80003676:	789010ef          	jal	800055fe <panic>
    return -1;
    8000367a:	597d                	li	s2,-1
    8000367c:	b775                	j	80003628 <fileread+0x58>
      return -1;
    8000367e:	597d                	li	s2,-1
    80003680:	64e2                	ld	s1,24(sp)
    80003682:	69a2                	ld	s3,8(sp)
    80003684:	b755                	j	80003628 <fileread+0x58>
    80003686:	597d                	li	s2,-1
    80003688:	64e2                	ld	s1,24(sp)
    8000368a:	69a2                	ld	s3,8(sp)
    8000368c:	bf71                	j	80003628 <fileread+0x58>

000000008000368e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000368e:	00954783          	lbu	a5,9(a0)
    80003692:	10078b63          	beqz	a5,800037a8 <filewrite+0x11a>
{
    80003696:	715d                	addi	sp,sp,-80
    80003698:	e486                	sd	ra,72(sp)
    8000369a:	e0a2                	sd	s0,64(sp)
    8000369c:	f84a                	sd	s2,48(sp)
    8000369e:	f052                	sd	s4,32(sp)
    800036a0:	e85a                	sd	s6,16(sp)
    800036a2:	0880                	addi	s0,sp,80
    800036a4:	892a                	mv	s2,a0
    800036a6:	8b2e                	mv	s6,a1
    800036a8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800036aa:	411c                	lw	a5,0(a0)
    800036ac:	4705                	li	a4,1
    800036ae:	02e78763          	beq	a5,a4,800036dc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036b2:	470d                	li	a4,3
    800036b4:	02e78863          	beq	a5,a4,800036e4 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036b8:	4709                	li	a4,2
    800036ba:	0ce79c63          	bne	a5,a4,80003792 <filewrite+0x104>
    800036be:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800036c0:	0ac05863          	blez	a2,80003770 <filewrite+0xe2>
    800036c4:	fc26                	sd	s1,56(sp)
    800036c6:	ec56                	sd	s5,24(sp)
    800036c8:	e45e                	sd	s7,8(sp)
    800036ca:	e062                	sd	s8,0(sp)
    int i = 0;
    800036cc:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800036ce:	6b85                	lui	s7,0x1
    800036d0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036d4:	6c05                	lui	s8,0x1
    800036d6:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800036da:	a8b5                	j	80003756 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800036dc:	6908                	ld	a0,16(a0)
    800036de:	1fc000ef          	jal	800038da <pipewrite>
    800036e2:	a04d                	j	80003784 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800036e4:	02451783          	lh	a5,36(a0)
    800036e8:	03079693          	slli	a3,a5,0x30
    800036ec:	92c1                	srli	a3,a3,0x30
    800036ee:	4725                	li	a4,9
    800036f0:	0ad76e63          	bltu	a4,a3,800037ac <filewrite+0x11e>
    800036f4:	0792                	slli	a5,a5,0x4
    800036f6:	00017717          	auipc	a4,0x17
    800036fa:	b7270713          	addi	a4,a4,-1166 # 8001a268 <devsw>
    800036fe:	97ba                	add	a5,a5,a4
    80003700:	679c                	ld	a5,8(a5)
    80003702:	c7dd                	beqz	a5,800037b0 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003704:	4505                	li	a0,1
    80003706:	9782                	jalr	a5
    80003708:	a8b5                	j	80003784 <filewrite+0xf6>
      if(n1 > max)
    8000370a:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000370e:	997ff0ef          	jal	800030a4 <begin_op>
      ilock(f->ip);
    80003712:	01893503          	ld	a0,24(s2)
    80003716:	fa5fe0ef          	jal	800026ba <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000371a:	8756                	mv	a4,s5
    8000371c:	02092683          	lw	a3,32(s2)
    80003720:	01698633          	add	a2,s3,s6
    80003724:	4585                	li	a1,1
    80003726:	01893503          	ld	a0,24(s2)
    8000372a:	c1cff0ef          	jal	80002b46 <writei>
    8000372e:	84aa                	mv	s1,a0
    80003730:	00a05763          	blez	a0,8000373e <filewrite+0xb0>
        f->off += r;
    80003734:	02092783          	lw	a5,32(s2)
    80003738:	9fa9                	addw	a5,a5,a0
    8000373a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000373e:	01893503          	ld	a0,24(s2)
    80003742:	826ff0ef          	jal	80002768 <iunlock>
      end_op();
    80003746:	9c9ff0ef          	jal	8000310e <end_op>

      if(r != n1){
    8000374a:	029a9563          	bne	s5,s1,80003774 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000374e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003752:	0149da63          	bge	s3,s4,80003766 <filewrite+0xd8>
      int n1 = n - i;
    80003756:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000375a:	0004879b          	sext.w	a5,s1
    8000375e:	fafbd6e3          	bge	s7,a5,8000370a <filewrite+0x7c>
    80003762:	84e2                	mv	s1,s8
    80003764:	b75d                	j	8000370a <filewrite+0x7c>
    80003766:	74e2                	ld	s1,56(sp)
    80003768:	6ae2                	ld	s5,24(sp)
    8000376a:	6ba2                	ld	s7,8(sp)
    8000376c:	6c02                	ld	s8,0(sp)
    8000376e:	a039                	j	8000377c <filewrite+0xee>
    int i = 0;
    80003770:	4981                	li	s3,0
    80003772:	a029                	j	8000377c <filewrite+0xee>
    80003774:	74e2                	ld	s1,56(sp)
    80003776:	6ae2                	ld	s5,24(sp)
    80003778:	6ba2                	ld	s7,8(sp)
    8000377a:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000377c:	033a1c63          	bne	s4,s3,800037b4 <filewrite+0x126>
    80003780:	8552                	mv	a0,s4
    80003782:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003784:	60a6                	ld	ra,72(sp)
    80003786:	6406                	ld	s0,64(sp)
    80003788:	7942                	ld	s2,48(sp)
    8000378a:	7a02                	ld	s4,32(sp)
    8000378c:	6b42                	ld	s6,16(sp)
    8000378e:	6161                	addi	sp,sp,80
    80003790:	8082                	ret
    80003792:	fc26                	sd	s1,56(sp)
    80003794:	f44e                	sd	s3,40(sp)
    80003796:	ec56                	sd	s5,24(sp)
    80003798:	e45e                	sd	s7,8(sp)
    8000379a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000379c:	00004517          	auipc	a0,0x4
    800037a0:	d8c50513          	addi	a0,a0,-628 # 80007528 <etext+0x528>
    800037a4:	65b010ef          	jal	800055fe <panic>
    return -1;
    800037a8:	557d                	li	a0,-1
}
    800037aa:	8082                	ret
      return -1;
    800037ac:	557d                	li	a0,-1
    800037ae:	bfd9                	j	80003784 <filewrite+0xf6>
    800037b0:	557d                	li	a0,-1
    800037b2:	bfc9                	j	80003784 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800037b4:	557d                	li	a0,-1
    800037b6:	79a2                	ld	s3,40(sp)
    800037b8:	b7f1                	j	80003784 <filewrite+0xf6>

00000000800037ba <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800037ba:	7179                	addi	sp,sp,-48
    800037bc:	f406                	sd	ra,40(sp)
    800037be:	f022                	sd	s0,32(sp)
    800037c0:	ec26                	sd	s1,24(sp)
    800037c2:	e052                	sd	s4,0(sp)
    800037c4:	1800                	addi	s0,sp,48
    800037c6:	84aa                	mv	s1,a0
    800037c8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037ca:	0005b023          	sd	zero,0(a1)
    800037ce:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037d2:	c3bff0ef          	jal	8000340c <filealloc>
    800037d6:	e088                	sd	a0,0(s1)
    800037d8:	c549                	beqz	a0,80003862 <pipealloc+0xa8>
    800037da:	c33ff0ef          	jal	8000340c <filealloc>
    800037de:	00aa3023          	sd	a0,0(s4)
    800037e2:	cd25                	beqz	a0,8000385a <pipealloc+0xa0>
    800037e4:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800037e6:	919fc0ef          	jal	800000fe <kalloc>
    800037ea:	892a                	mv	s2,a0
    800037ec:	c12d                	beqz	a0,8000384e <pipealloc+0x94>
    800037ee:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800037f0:	4985                	li	s3,1
    800037f2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037f6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037fa:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037fe:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003802:	00004597          	auipc	a1,0x4
    80003806:	d3658593          	addi	a1,a1,-714 # 80007538 <etext+0x538>
    8000380a:	030020ef          	jal	8000583a <initlock>
  (*f0)->type = FD_PIPE;
    8000380e:	609c                	ld	a5,0(s1)
    80003810:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003814:	609c                	ld	a5,0(s1)
    80003816:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000381a:	609c                	ld	a5,0(s1)
    8000381c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003820:	609c                	ld	a5,0(s1)
    80003822:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003826:	000a3783          	ld	a5,0(s4)
    8000382a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000382e:	000a3783          	ld	a5,0(s4)
    80003832:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003836:	000a3783          	ld	a5,0(s4)
    8000383a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000383e:	000a3783          	ld	a5,0(s4)
    80003842:	0127b823          	sd	s2,16(a5)
  return 0;
    80003846:	4501                	li	a0,0
    80003848:	6942                	ld	s2,16(sp)
    8000384a:	69a2                	ld	s3,8(sp)
    8000384c:	a01d                	j	80003872 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000384e:	6088                	ld	a0,0(s1)
    80003850:	c119                	beqz	a0,80003856 <pipealloc+0x9c>
    80003852:	6942                	ld	s2,16(sp)
    80003854:	a029                	j	8000385e <pipealloc+0xa4>
    80003856:	6942                	ld	s2,16(sp)
    80003858:	a029                	j	80003862 <pipealloc+0xa8>
    8000385a:	6088                	ld	a0,0(s1)
    8000385c:	c10d                	beqz	a0,8000387e <pipealloc+0xc4>
    fileclose(*f0);
    8000385e:	c53ff0ef          	jal	800034b0 <fileclose>
  if(*f1)
    80003862:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003866:	557d                	li	a0,-1
  if(*f1)
    80003868:	c789                	beqz	a5,80003872 <pipealloc+0xb8>
    fileclose(*f1);
    8000386a:	853e                	mv	a0,a5
    8000386c:	c45ff0ef          	jal	800034b0 <fileclose>
  return -1;
    80003870:	557d                	li	a0,-1
}
    80003872:	70a2                	ld	ra,40(sp)
    80003874:	7402                	ld	s0,32(sp)
    80003876:	64e2                	ld	s1,24(sp)
    80003878:	6a02                	ld	s4,0(sp)
    8000387a:	6145                	addi	sp,sp,48
    8000387c:	8082                	ret
  return -1;
    8000387e:	557d                	li	a0,-1
    80003880:	bfcd                	j	80003872 <pipealloc+0xb8>

0000000080003882 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003882:	1101                	addi	sp,sp,-32
    80003884:	ec06                	sd	ra,24(sp)
    80003886:	e822                	sd	s0,16(sp)
    80003888:	e426                	sd	s1,8(sp)
    8000388a:	e04a                	sd	s2,0(sp)
    8000388c:	1000                	addi	s0,sp,32
    8000388e:	84aa                	mv	s1,a0
    80003890:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003892:	028020ef          	jal	800058ba <acquire>
  if(writable){
    80003896:	02090763          	beqz	s2,800038c4 <pipeclose+0x42>
    pi->writeopen = 0;
    8000389a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000389e:	21848513          	addi	a0,s1,536
    800038a2:	b1dfd0ef          	jal	800013be <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800038a6:	2204b783          	ld	a5,544(s1)
    800038aa:	e785                	bnez	a5,800038d2 <pipeclose+0x50>
    release(&pi->lock);
    800038ac:	8526                	mv	a0,s1
    800038ae:	0a4020ef          	jal	80005952 <release>
    kfree((char*)pi);
    800038b2:	8526                	mv	a0,s1
    800038b4:	f68fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800038b8:	60e2                	ld	ra,24(sp)
    800038ba:	6442                	ld	s0,16(sp)
    800038bc:	64a2                	ld	s1,8(sp)
    800038be:	6902                	ld	s2,0(sp)
    800038c0:	6105                	addi	sp,sp,32
    800038c2:	8082                	ret
    pi->readopen = 0;
    800038c4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038c8:	21c48513          	addi	a0,s1,540
    800038cc:	af3fd0ef          	jal	800013be <wakeup>
    800038d0:	bfd9                	j	800038a6 <pipeclose+0x24>
    release(&pi->lock);
    800038d2:	8526                	mv	a0,s1
    800038d4:	07e020ef          	jal	80005952 <release>
}
    800038d8:	b7c5                	j	800038b8 <pipeclose+0x36>

00000000800038da <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038da:	711d                	addi	sp,sp,-96
    800038dc:	ec86                	sd	ra,88(sp)
    800038de:	e8a2                	sd	s0,80(sp)
    800038e0:	e4a6                	sd	s1,72(sp)
    800038e2:	e0ca                	sd	s2,64(sp)
    800038e4:	fc4e                	sd	s3,56(sp)
    800038e6:	f852                	sd	s4,48(sp)
    800038e8:	f456                	sd	s5,40(sp)
    800038ea:	1080                	addi	s0,sp,96
    800038ec:	84aa                	mv	s1,a0
    800038ee:	8aae                	mv	s5,a1
    800038f0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038f2:	c88fd0ef          	jal	80000d7a <myproc>
    800038f6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038f8:	8526                	mv	a0,s1
    800038fa:	7c1010ef          	jal	800058ba <acquire>
  while(i < n){
    800038fe:	0b405a63          	blez	s4,800039b2 <pipewrite+0xd8>
    80003902:	f05a                	sd	s6,32(sp)
    80003904:	ec5e                	sd	s7,24(sp)
    80003906:	e862                	sd	s8,16(sp)
  int i = 0;
    80003908:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000390a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000390c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003910:	21c48b93          	addi	s7,s1,540
    80003914:	a81d                	j	8000394a <pipewrite+0x70>
      release(&pi->lock);
    80003916:	8526                	mv	a0,s1
    80003918:	03a020ef          	jal	80005952 <release>
      return -1;
    8000391c:	597d                	li	s2,-1
    8000391e:	7b02                	ld	s6,32(sp)
    80003920:	6be2                	ld	s7,24(sp)
    80003922:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003924:	854a                	mv	a0,s2
    80003926:	60e6                	ld	ra,88(sp)
    80003928:	6446                	ld	s0,80(sp)
    8000392a:	64a6                	ld	s1,72(sp)
    8000392c:	6906                	ld	s2,64(sp)
    8000392e:	79e2                	ld	s3,56(sp)
    80003930:	7a42                	ld	s4,48(sp)
    80003932:	7aa2                	ld	s5,40(sp)
    80003934:	6125                	addi	sp,sp,96
    80003936:	8082                	ret
      wakeup(&pi->nread);
    80003938:	8562                	mv	a0,s8
    8000393a:	a85fd0ef          	jal	800013be <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000393e:	85a6                	mv	a1,s1
    80003940:	855e                	mv	a0,s7
    80003942:	a31fd0ef          	jal	80001372 <sleep>
  while(i < n){
    80003946:	05495b63          	bge	s2,s4,8000399c <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000394a:	2204a783          	lw	a5,544(s1)
    8000394e:	d7e1                	beqz	a5,80003916 <pipewrite+0x3c>
    80003950:	854e                	mv	a0,s3
    80003952:	c59fd0ef          	jal	800015aa <killed>
    80003956:	f161                	bnez	a0,80003916 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003958:	2184a783          	lw	a5,536(s1)
    8000395c:	21c4a703          	lw	a4,540(s1)
    80003960:	2007879b          	addiw	a5,a5,512
    80003964:	fcf70ae3          	beq	a4,a5,80003938 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003968:	4685                	li	a3,1
    8000396a:	01590633          	add	a2,s2,s5
    8000396e:	faf40593          	addi	a1,s0,-81
    80003972:	0509b503          	ld	a0,80(s3)
    80003976:	9fcfd0ef          	jal	80000b72 <copyin>
    8000397a:	03650e63          	beq	a0,s6,800039b6 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000397e:	21c4a783          	lw	a5,540(s1)
    80003982:	0017871b          	addiw	a4,a5,1
    80003986:	20e4ae23          	sw	a4,540(s1)
    8000398a:	1ff7f793          	andi	a5,a5,511
    8000398e:	97a6                	add	a5,a5,s1
    80003990:	faf44703          	lbu	a4,-81(s0)
    80003994:	00e78c23          	sb	a4,24(a5)
      i++;
    80003998:	2905                	addiw	s2,s2,1
    8000399a:	b775                	j	80003946 <pipewrite+0x6c>
    8000399c:	7b02                	ld	s6,32(sp)
    8000399e:	6be2                	ld	s7,24(sp)
    800039a0:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800039a2:	21848513          	addi	a0,s1,536
    800039a6:	a19fd0ef          	jal	800013be <wakeup>
  release(&pi->lock);
    800039aa:	8526                	mv	a0,s1
    800039ac:	7a7010ef          	jal	80005952 <release>
  return i;
    800039b0:	bf95                	j	80003924 <pipewrite+0x4a>
  int i = 0;
    800039b2:	4901                	li	s2,0
    800039b4:	b7fd                	j	800039a2 <pipewrite+0xc8>
    800039b6:	7b02                	ld	s6,32(sp)
    800039b8:	6be2                	ld	s7,24(sp)
    800039ba:	6c42                	ld	s8,16(sp)
    800039bc:	b7dd                	j	800039a2 <pipewrite+0xc8>

00000000800039be <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800039be:	715d                	addi	sp,sp,-80
    800039c0:	e486                	sd	ra,72(sp)
    800039c2:	e0a2                	sd	s0,64(sp)
    800039c4:	fc26                	sd	s1,56(sp)
    800039c6:	f84a                	sd	s2,48(sp)
    800039c8:	f44e                	sd	s3,40(sp)
    800039ca:	f052                	sd	s4,32(sp)
    800039cc:	ec56                	sd	s5,24(sp)
    800039ce:	0880                	addi	s0,sp,80
    800039d0:	84aa                	mv	s1,a0
    800039d2:	892e                	mv	s2,a1
    800039d4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039d6:	ba4fd0ef          	jal	80000d7a <myproc>
    800039da:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039dc:	8526                	mv	a0,s1
    800039de:	6dd010ef          	jal	800058ba <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039e2:	2184a703          	lw	a4,536(s1)
    800039e6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039ea:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039ee:	02f71563          	bne	a4,a5,80003a18 <piperead+0x5a>
    800039f2:	2244a783          	lw	a5,548(s1)
    800039f6:	cb85                	beqz	a5,80003a26 <piperead+0x68>
    if(killed(pr)){
    800039f8:	8552                	mv	a0,s4
    800039fa:	bb1fd0ef          	jal	800015aa <killed>
    800039fe:	ed19                	bnez	a0,80003a1c <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a00:	85a6                	mv	a1,s1
    80003a02:	854e                	mv	a0,s3
    80003a04:	96ffd0ef          	jal	80001372 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a08:	2184a703          	lw	a4,536(s1)
    80003a0c:	21c4a783          	lw	a5,540(s1)
    80003a10:	fef701e3          	beq	a4,a5,800039f2 <piperead+0x34>
    80003a14:	e85a                	sd	s6,16(sp)
    80003a16:	a809                	j	80003a28 <piperead+0x6a>
    80003a18:	e85a                	sd	s6,16(sp)
    80003a1a:	a039                	j	80003a28 <piperead+0x6a>
      release(&pi->lock);
    80003a1c:	8526                	mv	a0,s1
    80003a1e:	735010ef          	jal	80005952 <release>
      return -1;
    80003a22:	59fd                	li	s3,-1
    80003a24:	a8b1                	j	80003a80 <piperead+0xc2>
    80003a26:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a28:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a2a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a2c:	05505263          	blez	s5,80003a70 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a30:	2184a783          	lw	a5,536(s1)
    80003a34:	21c4a703          	lw	a4,540(s1)
    80003a38:	02f70c63          	beq	a4,a5,80003a70 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a3c:	0017871b          	addiw	a4,a5,1
    80003a40:	20e4ac23          	sw	a4,536(s1)
    80003a44:	1ff7f793          	andi	a5,a5,511
    80003a48:	97a6                	add	a5,a5,s1
    80003a4a:	0187c783          	lbu	a5,24(a5)
    80003a4e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a52:	4685                	li	a3,1
    80003a54:	fbf40613          	addi	a2,s0,-65
    80003a58:	85ca                	mv	a1,s2
    80003a5a:	050a3503          	ld	a0,80(s4)
    80003a5e:	830fd0ef          	jal	80000a8e <copyout>
    80003a62:	01650763          	beq	a0,s6,80003a70 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a66:	2985                	addiw	s3,s3,1
    80003a68:	0905                	addi	s2,s2,1
    80003a6a:	fd3a93e3          	bne	s5,s3,80003a30 <piperead+0x72>
    80003a6e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a70:	21c48513          	addi	a0,s1,540
    80003a74:	94bfd0ef          	jal	800013be <wakeup>
  release(&pi->lock);
    80003a78:	8526                	mv	a0,s1
    80003a7a:	6d9010ef          	jal	80005952 <release>
    80003a7e:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a80:	854e                	mv	a0,s3
    80003a82:	60a6                	ld	ra,72(sp)
    80003a84:	6406                	ld	s0,64(sp)
    80003a86:	74e2                	ld	s1,56(sp)
    80003a88:	7942                	ld	s2,48(sp)
    80003a8a:	79a2                	ld	s3,40(sp)
    80003a8c:	7a02                	ld	s4,32(sp)
    80003a8e:	6ae2                	ld	s5,24(sp)
    80003a90:	6161                	addi	sp,sp,80
    80003a92:	8082                	ret

0000000080003a94 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003a94:	1141                	addi	sp,sp,-16
    80003a96:	e422                	sd	s0,8(sp)
    80003a98:	0800                	addi	s0,sp,16
    80003a9a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a9c:	8905                	andi	a0,a0,1
    80003a9e:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003aa0:	8b89                	andi	a5,a5,2
    80003aa2:	c399                	beqz	a5,80003aa8 <flags2perm+0x14>
      perm |= PTE_W;
    80003aa4:	00456513          	ori	a0,a0,4
    return perm;
}
    80003aa8:	6422                	ld	s0,8(sp)
    80003aaa:	0141                	addi	sp,sp,16
    80003aac:	8082                	ret

0000000080003aae <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003aae:	df010113          	addi	sp,sp,-528
    80003ab2:	20113423          	sd	ra,520(sp)
    80003ab6:	20813023          	sd	s0,512(sp)
    80003aba:	ffa6                	sd	s1,504(sp)
    80003abc:	fbca                	sd	s2,496(sp)
    80003abe:	0c00                	addi	s0,sp,528
    80003ac0:	892a                	mv	s2,a0
    80003ac2:	dea43c23          	sd	a0,-520(s0)
    80003ac6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003aca:	ab0fd0ef          	jal	80000d7a <myproc>
    80003ace:	84aa                	mv	s1,a0

  begin_op();
    80003ad0:	dd4ff0ef          	jal	800030a4 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003ad4:	854a                	mv	a0,s2
    80003ad6:	bfaff0ef          	jal	80002ed0 <namei>
    80003ada:	c931                	beqz	a0,80003b2e <kexec+0x80>
    80003adc:	f3d2                	sd	s4,480(sp)
    80003ade:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003ae0:	bdbfe0ef          	jal	800026ba <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003ae4:	04000713          	li	a4,64
    80003ae8:	4681                	li	a3,0
    80003aea:	e5040613          	addi	a2,s0,-432
    80003aee:	4581                	li	a1,0
    80003af0:	8552                	mv	a0,s4
    80003af2:	f59fe0ef          	jal	80002a4a <readi>
    80003af6:	04000793          	li	a5,64
    80003afa:	00f51a63          	bne	a0,a5,80003b0e <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003afe:	e5042703          	lw	a4,-432(s0)
    80003b02:	464c47b7          	lui	a5,0x464c4
    80003b06:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b0a:	02f70663          	beq	a4,a5,80003b36 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b0e:	8552                	mv	a0,s4
    80003b10:	db5fe0ef          	jal	800028c4 <iunlockput>
    end_op();
    80003b14:	dfaff0ef          	jal	8000310e <end_op>
  }
  return -1;
    80003b18:	557d                	li	a0,-1
    80003b1a:	7a1e                	ld	s4,480(sp)
}
    80003b1c:	20813083          	ld	ra,520(sp)
    80003b20:	20013403          	ld	s0,512(sp)
    80003b24:	74fe                	ld	s1,504(sp)
    80003b26:	795e                	ld	s2,496(sp)
    80003b28:	21010113          	addi	sp,sp,528
    80003b2c:	8082                	ret
    end_op();
    80003b2e:	de0ff0ef          	jal	8000310e <end_op>
    return -1;
    80003b32:	557d                	li	a0,-1
    80003b34:	b7e5                	j	80003b1c <kexec+0x6e>
    80003b36:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b38:	8526                	mv	a0,s1
    80003b3a:	b46fd0ef          	jal	80000e80 <proc_pagetable>
    80003b3e:	8b2a                	mv	s6,a0
    80003b40:	2c050b63          	beqz	a0,80003e16 <kexec+0x368>
    80003b44:	f7ce                	sd	s3,488(sp)
    80003b46:	efd6                	sd	s5,472(sp)
    80003b48:	e7de                	sd	s7,456(sp)
    80003b4a:	e3e2                	sd	s8,448(sp)
    80003b4c:	ff66                	sd	s9,440(sp)
    80003b4e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b50:	e7042d03          	lw	s10,-400(s0)
    80003b54:	e8845783          	lhu	a5,-376(s0)
    80003b58:	12078963          	beqz	a5,80003c8a <kexec+0x1dc>
    80003b5c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b5e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b60:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b62:	6c85                	lui	s9,0x1
    80003b64:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b68:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b6c:	6a85                	lui	s5,0x1
    80003b6e:	a085                	j	80003bce <kexec+0x120>
      panic("loadseg: address should exist");
    80003b70:	00004517          	auipc	a0,0x4
    80003b74:	9d050513          	addi	a0,a0,-1584 # 80007540 <etext+0x540>
    80003b78:	287010ef          	jal	800055fe <panic>
    if(sz - i < PGSIZE)
    80003b7c:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b7e:	8726                	mv	a4,s1
    80003b80:	012c06bb          	addw	a3,s8,s2
    80003b84:	4581                	li	a1,0
    80003b86:	8552                	mv	a0,s4
    80003b88:	ec3fe0ef          	jal	80002a4a <readi>
    80003b8c:	2501                	sext.w	a0,a0
    80003b8e:	24a49a63          	bne	s1,a0,80003de2 <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003b92:	012a893b          	addw	s2,s5,s2
    80003b96:	03397363          	bgeu	s2,s3,80003bbc <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b9a:	02091593          	slli	a1,s2,0x20
    80003b9e:	9181                	srli	a1,a1,0x20
    80003ba0:	95de                	add	a1,a1,s7
    80003ba2:	855a                	mv	a0,s6
    80003ba4:	8b9fc0ef          	jal	8000045c <walkaddr>
    80003ba8:	862a                	mv	a2,a0
    if(pa == 0)
    80003baa:	d179                	beqz	a0,80003b70 <kexec+0xc2>
    if(sz - i < PGSIZE)
    80003bac:	412984bb          	subw	s1,s3,s2
    80003bb0:	0004879b          	sext.w	a5,s1
    80003bb4:	fcfcf4e3          	bgeu	s9,a5,80003b7c <kexec+0xce>
    80003bb8:	84d6                	mv	s1,s5
    80003bba:	b7c9                	j	80003b7c <kexec+0xce>
    sz = sz1;
    80003bbc:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bc0:	2d85                	addiw	s11,s11,1
    80003bc2:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003bc6:	e8845783          	lhu	a5,-376(s0)
    80003bca:	08fdd063          	bge	s11,a5,80003c4a <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bce:	2d01                	sext.w	s10,s10
    80003bd0:	03800713          	li	a4,56
    80003bd4:	86ea                	mv	a3,s10
    80003bd6:	e1840613          	addi	a2,s0,-488
    80003bda:	4581                	li	a1,0
    80003bdc:	8552                	mv	a0,s4
    80003bde:	e6dfe0ef          	jal	80002a4a <readi>
    80003be2:	03800793          	li	a5,56
    80003be6:	1cf51663          	bne	a0,a5,80003db2 <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003bea:	e1842783          	lw	a5,-488(s0)
    80003bee:	4705                	li	a4,1
    80003bf0:	fce798e3          	bne	a5,a4,80003bc0 <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80003bf4:	e4043483          	ld	s1,-448(s0)
    80003bf8:	e3843783          	ld	a5,-456(s0)
    80003bfc:	1af4ef63          	bltu	s1,a5,80003dba <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c00:	e2843783          	ld	a5,-472(s0)
    80003c04:	94be                	add	s1,s1,a5
    80003c06:	1af4ee63          	bltu	s1,a5,80003dc2 <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003c0a:	df043703          	ld	a4,-528(s0)
    80003c0e:	8ff9                	and	a5,a5,a4
    80003c10:	1a079d63          	bnez	a5,80003dca <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c14:	e1c42503          	lw	a0,-484(s0)
    80003c18:	e7dff0ef          	jal	80003a94 <flags2perm>
    80003c1c:	86aa                	mv	a3,a0
    80003c1e:	8626                	mv	a2,s1
    80003c20:	85ca                	mv	a1,s2
    80003c22:	855a                	mv	a0,s6
    80003c24:	b11fc0ef          	jal	80000734 <uvmalloc>
    80003c28:	e0a43423          	sd	a0,-504(s0)
    80003c2c:	1a050363          	beqz	a0,80003dd2 <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c30:	e2843b83          	ld	s7,-472(s0)
    80003c34:	e2042c03          	lw	s8,-480(s0)
    80003c38:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c3c:	00098463          	beqz	s3,80003c44 <kexec+0x196>
    80003c40:	4901                	li	s2,0
    80003c42:	bfa1                	j	80003b9a <kexec+0xec>
    sz = sz1;
    80003c44:	e0843903          	ld	s2,-504(s0)
    80003c48:	bfa5                	j	80003bc0 <kexec+0x112>
    80003c4a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003c4c:	8552                	mv	a0,s4
    80003c4e:	c77fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    80003c52:	cbcff0ef          	jal	8000310e <end_op>
  p = myproc();
    80003c56:	924fd0ef          	jal	80000d7a <myproc>
    80003c5a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c5c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c60:	6985                	lui	s3,0x1
    80003c62:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c64:	99ca                	add	s3,s3,s2
    80003c66:	77fd                	lui	a5,0xfffff
    80003c68:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c6c:	4691                	li	a3,4
    80003c6e:	660d                	lui	a2,0x3
    80003c70:	964e                	add	a2,a2,s3
    80003c72:	85ce                	mv	a1,s3
    80003c74:	855a                	mv	a0,s6
    80003c76:	abffc0ef          	jal	80000734 <uvmalloc>
    80003c7a:	892a                	mv	s2,a0
    80003c7c:	e0a43423          	sd	a0,-504(s0)
    80003c80:	e519                	bnez	a0,80003c8e <kexec+0x1e0>
  if(pagetable)
    80003c82:	e1343423          	sd	s3,-504(s0)
    80003c86:	4a01                	li	s4,0
    80003c88:	aab1                	j	80003de4 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c8a:	4901                	li	s2,0
    80003c8c:	b7c1                	j	80003c4c <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c8e:	75f5                	lui	a1,0xffffd
    80003c90:	95aa                	add	a1,a1,a0
    80003c92:	855a                	mv	a0,s6
    80003c94:	c77fc0ef          	jal	8000090a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c98:	7bf9                	lui	s7,0xffffe
    80003c9a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c9c:	e0043783          	ld	a5,-512(s0)
    80003ca0:	6388                	ld	a0,0(a5)
    80003ca2:	cd39                	beqz	a0,80003d00 <kexec+0x252>
    80003ca4:	e9040993          	addi	s3,s0,-368
    80003ca8:	f9040c13          	addi	s8,s0,-112
    80003cac:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003cae:	e10fc0ef          	jal	800002be <strlen>
    80003cb2:	0015079b          	addiw	a5,a0,1
    80003cb6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003cba:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003cbe:	11796e63          	bltu	s2,s7,80003dda <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003cc2:	e0043d03          	ld	s10,-512(s0)
    80003cc6:	000d3a03          	ld	s4,0(s10)
    80003cca:	8552                	mv	a0,s4
    80003ccc:	df2fc0ef          	jal	800002be <strlen>
    80003cd0:	0015069b          	addiw	a3,a0,1
    80003cd4:	8652                	mv	a2,s4
    80003cd6:	85ca                	mv	a1,s2
    80003cd8:	855a                	mv	a0,s6
    80003cda:	db5fc0ef          	jal	80000a8e <copyout>
    80003cde:	10054063          	bltz	a0,80003dde <kexec+0x330>
    ustack[argc] = sp;
    80003ce2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003ce6:	0485                	addi	s1,s1,1
    80003ce8:	008d0793          	addi	a5,s10,8
    80003cec:	e0f43023          	sd	a5,-512(s0)
    80003cf0:	008d3503          	ld	a0,8(s10)
    80003cf4:	c909                	beqz	a0,80003d06 <kexec+0x258>
    if(argc >= MAXARG)
    80003cf6:	09a1                	addi	s3,s3,8
    80003cf8:	fb899be3          	bne	s3,s8,80003cae <kexec+0x200>
  ip = 0;
    80003cfc:	4a01                	li	s4,0
    80003cfe:	a0dd                	j	80003de4 <kexec+0x336>
  sp = sz;
    80003d00:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003d04:	4481                	li	s1,0
  ustack[argc] = 0;
    80003d06:	00349793          	slli	a5,s1,0x3
    80003d0a:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdbab8>
    80003d0e:	97a2                	add	a5,a5,s0
    80003d10:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003d14:	00148693          	addi	a3,s1,1
    80003d18:	068e                	slli	a3,a3,0x3
    80003d1a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003d1e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d22:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003d26:	f5796ee3          	bltu	s2,s7,80003c82 <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d2a:	e9040613          	addi	a2,s0,-368
    80003d2e:	85ca                	mv	a1,s2
    80003d30:	855a                	mv	a0,s6
    80003d32:	d5dfc0ef          	jal	80000a8e <copyout>
    80003d36:	0e054263          	bltz	a0,80003e1a <kexec+0x36c>
  p->trapframe->a1 = sp;
    80003d3a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d3e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d42:	df843783          	ld	a5,-520(s0)
    80003d46:	0007c703          	lbu	a4,0(a5)
    80003d4a:	cf11                	beqz	a4,80003d66 <kexec+0x2b8>
    80003d4c:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d4e:	02f00693          	li	a3,47
    80003d52:	a039                	j	80003d60 <kexec+0x2b2>
      last = s+1;
    80003d54:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d58:	0785                	addi	a5,a5,1
    80003d5a:	fff7c703          	lbu	a4,-1(a5)
    80003d5e:	c701                	beqz	a4,80003d66 <kexec+0x2b8>
    if(*s == '/')
    80003d60:	fed71ce3          	bne	a4,a3,80003d58 <kexec+0x2aa>
    80003d64:	bfc5                	j	80003d54 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d66:	4641                	li	a2,16
    80003d68:	df843583          	ld	a1,-520(s0)
    80003d6c:	158a8513          	addi	a0,s5,344
    80003d70:	d1cfc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003d74:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d78:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d7c:	e0843783          	ld	a5,-504(s0)
    80003d80:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d84:	058ab783          	ld	a5,88(s5)
    80003d88:	e6843703          	ld	a4,-408(s0)
    80003d8c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d8e:	058ab783          	ld	a5,88(s5)
    80003d92:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d96:	85e6                	mv	a1,s9
    80003d98:	96cfd0ef          	jal	80000f04 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d9c:	0004851b          	sext.w	a0,s1
    80003da0:	79be                	ld	s3,488(sp)
    80003da2:	7a1e                	ld	s4,480(sp)
    80003da4:	6afe                	ld	s5,472(sp)
    80003da6:	6b5e                	ld	s6,464(sp)
    80003da8:	6bbe                	ld	s7,456(sp)
    80003daa:	6c1e                	ld	s8,448(sp)
    80003dac:	7cfa                	ld	s9,440(sp)
    80003dae:	7d5a                	ld	s10,432(sp)
    80003db0:	b3b5                	j	80003b1c <kexec+0x6e>
    80003db2:	e1243423          	sd	s2,-504(s0)
    80003db6:	7dba                	ld	s11,424(sp)
    80003db8:	a035                	j	80003de4 <kexec+0x336>
    80003dba:	e1243423          	sd	s2,-504(s0)
    80003dbe:	7dba                	ld	s11,424(sp)
    80003dc0:	a015                	j	80003de4 <kexec+0x336>
    80003dc2:	e1243423          	sd	s2,-504(s0)
    80003dc6:	7dba                	ld	s11,424(sp)
    80003dc8:	a831                	j	80003de4 <kexec+0x336>
    80003dca:	e1243423          	sd	s2,-504(s0)
    80003dce:	7dba                	ld	s11,424(sp)
    80003dd0:	a811                	j	80003de4 <kexec+0x336>
    80003dd2:	e1243423          	sd	s2,-504(s0)
    80003dd6:	7dba                	ld	s11,424(sp)
    80003dd8:	a031                	j	80003de4 <kexec+0x336>
  ip = 0;
    80003dda:	4a01                	li	s4,0
    80003ddc:	a021                	j	80003de4 <kexec+0x336>
    80003dde:	4a01                	li	s4,0
  if(pagetable)
    80003de0:	a011                	j	80003de4 <kexec+0x336>
    80003de2:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003de4:	e0843583          	ld	a1,-504(s0)
    80003de8:	855a                	mv	a0,s6
    80003dea:	91afd0ef          	jal	80000f04 <proc_freepagetable>
  return -1;
    80003dee:	557d                	li	a0,-1
  if(ip){
    80003df0:	000a1b63          	bnez	s4,80003e06 <kexec+0x358>
    80003df4:	79be                	ld	s3,488(sp)
    80003df6:	7a1e                	ld	s4,480(sp)
    80003df8:	6afe                	ld	s5,472(sp)
    80003dfa:	6b5e                	ld	s6,464(sp)
    80003dfc:	6bbe                	ld	s7,456(sp)
    80003dfe:	6c1e                	ld	s8,448(sp)
    80003e00:	7cfa                	ld	s9,440(sp)
    80003e02:	7d5a                	ld	s10,432(sp)
    80003e04:	bb21                	j	80003b1c <kexec+0x6e>
    80003e06:	79be                	ld	s3,488(sp)
    80003e08:	6afe                	ld	s5,472(sp)
    80003e0a:	6b5e                	ld	s6,464(sp)
    80003e0c:	6bbe                	ld	s7,456(sp)
    80003e0e:	6c1e                	ld	s8,448(sp)
    80003e10:	7cfa                	ld	s9,440(sp)
    80003e12:	7d5a                	ld	s10,432(sp)
    80003e14:	b9ed                	j	80003b0e <kexec+0x60>
    80003e16:	6b5e                	ld	s6,464(sp)
    80003e18:	b9dd                	j	80003b0e <kexec+0x60>
  sz = sz1;
    80003e1a:	e0843983          	ld	s3,-504(s0)
    80003e1e:	b595                	j	80003c82 <kexec+0x1d4>

0000000080003e20 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e20:	7179                	addi	sp,sp,-48
    80003e22:	f406                	sd	ra,40(sp)
    80003e24:	f022                	sd	s0,32(sp)
    80003e26:	ec26                	sd	s1,24(sp)
    80003e28:	e84a                	sd	s2,16(sp)
    80003e2a:	1800                	addi	s0,sp,48
    80003e2c:	892e                	mv	s2,a1
    80003e2e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e30:	fdc40593          	addi	a1,s0,-36
    80003e34:	e43fd0ef          	jal	80001c76 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e38:	fdc42703          	lw	a4,-36(s0)
    80003e3c:	47bd                	li	a5,15
    80003e3e:	02e7e963          	bltu	a5,a4,80003e70 <argfd+0x50>
    80003e42:	f39fc0ef          	jal	80000d7a <myproc>
    80003e46:	fdc42703          	lw	a4,-36(s0)
    80003e4a:	01a70793          	addi	a5,a4,26
    80003e4e:	078e                	slli	a5,a5,0x3
    80003e50:	953e                	add	a0,a0,a5
    80003e52:	611c                	ld	a5,0(a0)
    80003e54:	c385                	beqz	a5,80003e74 <argfd+0x54>
    return -1;
  if(pfd)
    80003e56:	00090463          	beqz	s2,80003e5e <argfd+0x3e>
    *pfd = fd;
    80003e5a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e5e:	4501                	li	a0,0
  if(pf)
    80003e60:	c091                	beqz	s1,80003e64 <argfd+0x44>
    *pf = f;
    80003e62:	e09c                	sd	a5,0(s1)
}
    80003e64:	70a2                	ld	ra,40(sp)
    80003e66:	7402                	ld	s0,32(sp)
    80003e68:	64e2                	ld	s1,24(sp)
    80003e6a:	6942                	ld	s2,16(sp)
    80003e6c:	6145                	addi	sp,sp,48
    80003e6e:	8082                	ret
    return -1;
    80003e70:	557d                	li	a0,-1
    80003e72:	bfcd                	j	80003e64 <argfd+0x44>
    80003e74:	557d                	li	a0,-1
    80003e76:	b7fd                	j	80003e64 <argfd+0x44>

0000000080003e78 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e78:	1101                	addi	sp,sp,-32
    80003e7a:	ec06                	sd	ra,24(sp)
    80003e7c:	e822                	sd	s0,16(sp)
    80003e7e:	e426                	sd	s1,8(sp)
    80003e80:	1000                	addi	s0,sp,32
    80003e82:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e84:	ef7fc0ef          	jal	80000d7a <myproc>
    80003e88:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e8a:	0d050793          	addi	a5,a0,208
    80003e8e:	4501                	li	a0,0
    80003e90:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e92:	6398                	ld	a4,0(a5)
    80003e94:	cb19                	beqz	a4,80003eaa <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e96:	2505                	addiw	a0,a0,1
    80003e98:	07a1                	addi	a5,a5,8
    80003e9a:	fed51ce3          	bne	a0,a3,80003e92 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e9e:	557d                	li	a0,-1
}
    80003ea0:	60e2                	ld	ra,24(sp)
    80003ea2:	6442                	ld	s0,16(sp)
    80003ea4:	64a2                	ld	s1,8(sp)
    80003ea6:	6105                	addi	sp,sp,32
    80003ea8:	8082                	ret
      p->ofile[fd] = f;
    80003eaa:	01a50793          	addi	a5,a0,26
    80003eae:	078e                	slli	a5,a5,0x3
    80003eb0:	963e                	add	a2,a2,a5
    80003eb2:	e204                	sd	s1,0(a2)
      return fd;
    80003eb4:	b7f5                	j	80003ea0 <fdalloc+0x28>

0000000080003eb6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003eb6:	715d                	addi	sp,sp,-80
    80003eb8:	e486                	sd	ra,72(sp)
    80003eba:	e0a2                	sd	s0,64(sp)
    80003ebc:	fc26                	sd	s1,56(sp)
    80003ebe:	f84a                	sd	s2,48(sp)
    80003ec0:	f44e                	sd	s3,40(sp)
    80003ec2:	ec56                	sd	s5,24(sp)
    80003ec4:	e85a                	sd	s6,16(sp)
    80003ec6:	0880                	addi	s0,sp,80
    80003ec8:	8b2e                	mv	s6,a1
    80003eca:	89b2                	mv	s3,a2
    80003ecc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003ece:	fb040593          	addi	a1,s0,-80
    80003ed2:	818ff0ef          	jal	80002eea <nameiparent>
    80003ed6:	84aa                	mv	s1,a0
    80003ed8:	10050a63          	beqz	a0,80003fec <create+0x136>
    return 0;

  ilock(dp);
    80003edc:	fdefe0ef          	jal	800026ba <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ee0:	4601                	li	a2,0
    80003ee2:	fb040593          	addi	a1,s0,-80
    80003ee6:	8526                	mv	a0,s1
    80003ee8:	d83fe0ef          	jal	80002c6a <dirlookup>
    80003eec:	8aaa                	mv	s5,a0
    80003eee:	c129                	beqz	a0,80003f30 <create+0x7a>
    iunlockput(dp);
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	9d3fe0ef          	jal	800028c4 <iunlockput>
    ilock(ip);
    80003ef6:	8556                	mv	a0,s5
    80003ef8:	fc2fe0ef          	jal	800026ba <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003efc:	4789                	li	a5,2
    80003efe:	02fb1463          	bne	s6,a5,80003f26 <create+0x70>
    80003f02:	044ad783          	lhu	a5,68(s5)
    80003f06:	37f9                	addiw	a5,a5,-2
    80003f08:	17c2                	slli	a5,a5,0x30
    80003f0a:	93c1                	srli	a5,a5,0x30
    80003f0c:	4705                	li	a4,1
    80003f0e:	00f76c63          	bltu	a4,a5,80003f26 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f12:	8556                	mv	a0,s5
    80003f14:	60a6                	ld	ra,72(sp)
    80003f16:	6406                	ld	s0,64(sp)
    80003f18:	74e2                	ld	s1,56(sp)
    80003f1a:	7942                	ld	s2,48(sp)
    80003f1c:	79a2                	ld	s3,40(sp)
    80003f1e:	6ae2                	ld	s5,24(sp)
    80003f20:	6b42                	ld	s6,16(sp)
    80003f22:	6161                	addi	sp,sp,80
    80003f24:	8082                	ret
    iunlockput(ip);
    80003f26:	8556                	mv	a0,s5
    80003f28:	99dfe0ef          	jal	800028c4 <iunlockput>
    return 0;
    80003f2c:	4a81                	li	s5,0
    80003f2e:	b7d5                	j	80003f12 <create+0x5c>
    80003f30:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f32:	85da                	mv	a1,s6
    80003f34:	4088                	lw	a0,0(s1)
    80003f36:	e14fe0ef          	jal	8000254a <ialloc>
    80003f3a:	8a2a                	mv	s4,a0
    80003f3c:	cd15                	beqz	a0,80003f78 <create+0xc2>
  ilock(ip);
    80003f3e:	f7cfe0ef          	jal	800026ba <ilock>
  ip->major = major;
    80003f42:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f46:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f4a:	4905                	li	s2,1
    80003f4c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f50:	8552                	mv	a0,s4
    80003f52:	eb4fe0ef          	jal	80002606 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f56:	032b0763          	beq	s6,s2,80003f84 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f5a:	004a2603          	lw	a2,4(s4)
    80003f5e:	fb040593          	addi	a1,s0,-80
    80003f62:	8526                	mv	a0,s1
    80003f64:	ed3fe0ef          	jal	80002e36 <dirlink>
    80003f68:	06054563          	bltz	a0,80003fd2 <create+0x11c>
  iunlockput(dp);
    80003f6c:	8526                	mv	a0,s1
    80003f6e:	957fe0ef          	jal	800028c4 <iunlockput>
  return ip;
    80003f72:	8ad2                	mv	s5,s4
    80003f74:	7a02                	ld	s4,32(sp)
    80003f76:	bf71                	j	80003f12 <create+0x5c>
    iunlockput(dp);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	94bfe0ef          	jal	800028c4 <iunlockput>
    return 0;
    80003f7e:	8ad2                	mv	s5,s4
    80003f80:	7a02                	ld	s4,32(sp)
    80003f82:	bf41                	j	80003f12 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f84:	004a2603          	lw	a2,4(s4)
    80003f88:	00003597          	auipc	a1,0x3
    80003f8c:	5d858593          	addi	a1,a1,1496 # 80007560 <etext+0x560>
    80003f90:	8552                	mv	a0,s4
    80003f92:	ea5fe0ef          	jal	80002e36 <dirlink>
    80003f96:	02054e63          	bltz	a0,80003fd2 <create+0x11c>
    80003f9a:	40d0                	lw	a2,4(s1)
    80003f9c:	00003597          	auipc	a1,0x3
    80003fa0:	5cc58593          	addi	a1,a1,1484 # 80007568 <etext+0x568>
    80003fa4:	8552                	mv	a0,s4
    80003fa6:	e91fe0ef          	jal	80002e36 <dirlink>
    80003faa:	02054463          	bltz	a0,80003fd2 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fae:	004a2603          	lw	a2,4(s4)
    80003fb2:	fb040593          	addi	a1,s0,-80
    80003fb6:	8526                	mv	a0,s1
    80003fb8:	e7ffe0ef          	jal	80002e36 <dirlink>
    80003fbc:	00054b63          	bltz	a0,80003fd2 <create+0x11c>
    dp->nlink++;  // for ".."
    80003fc0:	04a4d783          	lhu	a5,74(s1)
    80003fc4:	2785                	addiw	a5,a5,1
    80003fc6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fca:	8526                	mv	a0,s1
    80003fcc:	e3afe0ef          	jal	80002606 <iupdate>
    80003fd0:	bf71                	j	80003f6c <create+0xb6>
  ip->nlink = 0;
    80003fd2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003fd6:	8552                	mv	a0,s4
    80003fd8:	e2efe0ef          	jal	80002606 <iupdate>
  iunlockput(ip);
    80003fdc:	8552                	mv	a0,s4
    80003fde:	8e7fe0ef          	jal	800028c4 <iunlockput>
  iunlockput(dp);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	8e1fe0ef          	jal	800028c4 <iunlockput>
  return 0;
    80003fe8:	7a02                	ld	s4,32(sp)
    80003fea:	b725                	j	80003f12 <create+0x5c>
    return 0;
    80003fec:	8aaa                	mv	s5,a0
    80003fee:	b715                	j	80003f12 <create+0x5c>

0000000080003ff0 <sys_dup>:
{
    80003ff0:	7179                	addi	sp,sp,-48
    80003ff2:	f406                	sd	ra,40(sp)
    80003ff4:	f022                	sd	s0,32(sp)
    80003ff6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003ff8:	fd840613          	addi	a2,s0,-40
    80003ffc:	4581                	li	a1,0
    80003ffe:	4501                	li	a0,0
    80004000:	e21ff0ef          	jal	80003e20 <argfd>
    return -1;
    80004004:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004006:	02054363          	bltz	a0,8000402c <sys_dup+0x3c>
    8000400a:	ec26                	sd	s1,24(sp)
    8000400c:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000400e:	fd843903          	ld	s2,-40(s0)
    80004012:	854a                	mv	a0,s2
    80004014:	e65ff0ef          	jal	80003e78 <fdalloc>
    80004018:	84aa                	mv	s1,a0
    return -1;
    8000401a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000401c:	00054d63          	bltz	a0,80004036 <sys_dup+0x46>
  filedup(f);
    80004020:	854a                	mv	a0,s2
    80004022:	c48ff0ef          	jal	8000346a <filedup>
  return fd;
    80004026:	87a6                	mv	a5,s1
    80004028:	64e2                	ld	s1,24(sp)
    8000402a:	6942                	ld	s2,16(sp)
}
    8000402c:	853e                	mv	a0,a5
    8000402e:	70a2                	ld	ra,40(sp)
    80004030:	7402                	ld	s0,32(sp)
    80004032:	6145                	addi	sp,sp,48
    80004034:	8082                	ret
    80004036:	64e2                	ld	s1,24(sp)
    80004038:	6942                	ld	s2,16(sp)
    8000403a:	bfcd                	j	8000402c <sys_dup+0x3c>

000000008000403c <sys_read>:
{
    8000403c:	7179                	addi	sp,sp,-48
    8000403e:	f406                	sd	ra,40(sp)
    80004040:	f022                	sd	s0,32(sp)
    80004042:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004044:	fd840593          	addi	a1,s0,-40
    80004048:	4505                	li	a0,1
    8000404a:	c49fd0ef          	jal	80001c92 <argaddr>
  argint(2, &n);
    8000404e:	fe440593          	addi	a1,s0,-28
    80004052:	4509                	li	a0,2
    80004054:	c23fd0ef          	jal	80001c76 <argint>
  if(argfd(0, 0, &f) < 0)
    80004058:	fe840613          	addi	a2,s0,-24
    8000405c:	4581                	li	a1,0
    8000405e:	4501                	li	a0,0
    80004060:	dc1ff0ef          	jal	80003e20 <argfd>
    80004064:	87aa                	mv	a5,a0
    return -1;
    80004066:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004068:	0007ca63          	bltz	a5,8000407c <sys_read+0x40>
  return fileread(f, p, n);
    8000406c:	fe442603          	lw	a2,-28(s0)
    80004070:	fd843583          	ld	a1,-40(s0)
    80004074:	fe843503          	ld	a0,-24(s0)
    80004078:	d58ff0ef          	jal	800035d0 <fileread>
}
    8000407c:	70a2                	ld	ra,40(sp)
    8000407e:	7402                	ld	s0,32(sp)
    80004080:	6145                	addi	sp,sp,48
    80004082:	8082                	ret

0000000080004084 <sys_write>:
{
    80004084:	7179                	addi	sp,sp,-48
    80004086:	f406                	sd	ra,40(sp)
    80004088:	f022                	sd	s0,32(sp)
    8000408a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000408c:	fd840593          	addi	a1,s0,-40
    80004090:	4505                	li	a0,1
    80004092:	c01fd0ef          	jal	80001c92 <argaddr>
  argint(2, &n);
    80004096:	fe440593          	addi	a1,s0,-28
    8000409a:	4509                	li	a0,2
    8000409c:	bdbfd0ef          	jal	80001c76 <argint>
  if(argfd(0, 0, &f) < 0)
    800040a0:	fe840613          	addi	a2,s0,-24
    800040a4:	4581                	li	a1,0
    800040a6:	4501                	li	a0,0
    800040a8:	d79ff0ef          	jal	80003e20 <argfd>
    800040ac:	87aa                	mv	a5,a0
    return -1;
    800040ae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040b0:	0007ca63          	bltz	a5,800040c4 <sys_write+0x40>
  return filewrite(f, p, n);
    800040b4:	fe442603          	lw	a2,-28(s0)
    800040b8:	fd843583          	ld	a1,-40(s0)
    800040bc:	fe843503          	ld	a0,-24(s0)
    800040c0:	dceff0ef          	jal	8000368e <filewrite>
}
    800040c4:	70a2                	ld	ra,40(sp)
    800040c6:	7402                	ld	s0,32(sp)
    800040c8:	6145                	addi	sp,sp,48
    800040ca:	8082                	ret

00000000800040cc <sys_close>:
{
    800040cc:	1101                	addi	sp,sp,-32
    800040ce:	ec06                	sd	ra,24(sp)
    800040d0:	e822                	sd	s0,16(sp)
    800040d2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800040d4:	fe040613          	addi	a2,s0,-32
    800040d8:	fec40593          	addi	a1,s0,-20
    800040dc:	4501                	li	a0,0
    800040de:	d43ff0ef          	jal	80003e20 <argfd>
    return -1;
    800040e2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800040e4:	02054063          	bltz	a0,80004104 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800040e8:	c93fc0ef          	jal	80000d7a <myproc>
    800040ec:	fec42783          	lw	a5,-20(s0)
    800040f0:	07e9                	addi	a5,a5,26
    800040f2:	078e                	slli	a5,a5,0x3
    800040f4:	953e                	add	a0,a0,a5
    800040f6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800040fa:	fe043503          	ld	a0,-32(s0)
    800040fe:	bb2ff0ef          	jal	800034b0 <fileclose>
  return 0;
    80004102:	4781                	li	a5,0
}
    80004104:	853e                	mv	a0,a5
    80004106:	60e2                	ld	ra,24(sp)
    80004108:	6442                	ld	s0,16(sp)
    8000410a:	6105                	addi	sp,sp,32
    8000410c:	8082                	ret

000000008000410e <sys_fstat>:
{
    8000410e:	1101                	addi	sp,sp,-32
    80004110:	ec06                	sd	ra,24(sp)
    80004112:	e822                	sd	s0,16(sp)
    80004114:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004116:	fe040593          	addi	a1,s0,-32
    8000411a:	4505                	li	a0,1
    8000411c:	b77fd0ef          	jal	80001c92 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004120:	fe840613          	addi	a2,s0,-24
    80004124:	4581                	li	a1,0
    80004126:	4501                	li	a0,0
    80004128:	cf9ff0ef          	jal	80003e20 <argfd>
    8000412c:	87aa                	mv	a5,a0
    return -1;
    8000412e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004130:	0007c863          	bltz	a5,80004140 <sys_fstat+0x32>
  return filestat(f, st);
    80004134:	fe043583          	ld	a1,-32(s0)
    80004138:	fe843503          	ld	a0,-24(s0)
    8000413c:	c36ff0ef          	jal	80003572 <filestat>
}
    80004140:	60e2                	ld	ra,24(sp)
    80004142:	6442                	ld	s0,16(sp)
    80004144:	6105                	addi	sp,sp,32
    80004146:	8082                	ret

0000000080004148 <sys_link>:
{
    80004148:	7169                	addi	sp,sp,-304
    8000414a:	f606                	sd	ra,296(sp)
    8000414c:	f222                	sd	s0,288(sp)
    8000414e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004150:	08000613          	li	a2,128
    80004154:	ed040593          	addi	a1,s0,-304
    80004158:	4501                	li	a0,0
    8000415a:	b55fd0ef          	jal	80001cae <argstr>
    return -1;
    8000415e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004160:	0c054e63          	bltz	a0,8000423c <sys_link+0xf4>
    80004164:	08000613          	li	a2,128
    80004168:	f5040593          	addi	a1,s0,-176
    8000416c:	4505                	li	a0,1
    8000416e:	b41fd0ef          	jal	80001cae <argstr>
    return -1;
    80004172:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004174:	0c054463          	bltz	a0,8000423c <sys_link+0xf4>
    80004178:	ee26                	sd	s1,280(sp)
  begin_op();
    8000417a:	f2bfe0ef          	jal	800030a4 <begin_op>
  if((ip = namei(old)) == 0){
    8000417e:	ed040513          	addi	a0,s0,-304
    80004182:	d4ffe0ef          	jal	80002ed0 <namei>
    80004186:	84aa                	mv	s1,a0
    80004188:	c53d                	beqz	a0,800041f6 <sys_link+0xae>
  ilock(ip);
    8000418a:	d30fe0ef          	jal	800026ba <ilock>
  if(ip->type == T_DIR){
    8000418e:	04449703          	lh	a4,68(s1)
    80004192:	4785                	li	a5,1
    80004194:	06f70663          	beq	a4,a5,80004200 <sys_link+0xb8>
    80004198:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000419a:	04a4d783          	lhu	a5,74(s1)
    8000419e:	2785                	addiw	a5,a5,1
    800041a0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041a4:	8526                	mv	a0,s1
    800041a6:	c60fe0ef          	jal	80002606 <iupdate>
  iunlock(ip);
    800041aa:	8526                	mv	a0,s1
    800041ac:	dbcfe0ef          	jal	80002768 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800041b0:	fd040593          	addi	a1,s0,-48
    800041b4:	f5040513          	addi	a0,s0,-176
    800041b8:	d33fe0ef          	jal	80002eea <nameiparent>
    800041bc:	892a                	mv	s2,a0
    800041be:	cd21                	beqz	a0,80004216 <sys_link+0xce>
  ilock(dp);
    800041c0:	cfafe0ef          	jal	800026ba <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041c4:	00092703          	lw	a4,0(s2)
    800041c8:	409c                	lw	a5,0(s1)
    800041ca:	04f71363          	bne	a4,a5,80004210 <sys_link+0xc8>
    800041ce:	40d0                	lw	a2,4(s1)
    800041d0:	fd040593          	addi	a1,s0,-48
    800041d4:	854a                	mv	a0,s2
    800041d6:	c61fe0ef          	jal	80002e36 <dirlink>
    800041da:	02054b63          	bltz	a0,80004210 <sys_link+0xc8>
  iunlockput(dp);
    800041de:	854a                	mv	a0,s2
    800041e0:	ee4fe0ef          	jal	800028c4 <iunlockput>
  iput(ip);
    800041e4:	8526                	mv	a0,s1
    800041e6:	e56fe0ef          	jal	8000283c <iput>
  end_op();
    800041ea:	f25fe0ef          	jal	8000310e <end_op>
  return 0;
    800041ee:	4781                	li	a5,0
    800041f0:	64f2                	ld	s1,280(sp)
    800041f2:	6952                	ld	s2,272(sp)
    800041f4:	a0a1                	j	8000423c <sys_link+0xf4>
    end_op();
    800041f6:	f19fe0ef          	jal	8000310e <end_op>
    return -1;
    800041fa:	57fd                	li	a5,-1
    800041fc:	64f2                	ld	s1,280(sp)
    800041fe:	a83d                	j	8000423c <sys_link+0xf4>
    iunlockput(ip);
    80004200:	8526                	mv	a0,s1
    80004202:	ec2fe0ef          	jal	800028c4 <iunlockput>
    end_op();
    80004206:	f09fe0ef          	jal	8000310e <end_op>
    return -1;
    8000420a:	57fd                	li	a5,-1
    8000420c:	64f2                	ld	s1,280(sp)
    8000420e:	a03d                	j	8000423c <sys_link+0xf4>
    iunlockput(dp);
    80004210:	854a                	mv	a0,s2
    80004212:	eb2fe0ef          	jal	800028c4 <iunlockput>
  ilock(ip);
    80004216:	8526                	mv	a0,s1
    80004218:	ca2fe0ef          	jal	800026ba <ilock>
  ip->nlink--;
    8000421c:	04a4d783          	lhu	a5,74(s1)
    80004220:	37fd                	addiw	a5,a5,-1
    80004222:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004226:	8526                	mv	a0,s1
    80004228:	bdefe0ef          	jal	80002606 <iupdate>
  iunlockput(ip);
    8000422c:	8526                	mv	a0,s1
    8000422e:	e96fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    80004232:	eddfe0ef          	jal	8000310e <end_op>
  return -1;
    80004236:	57fd                	li	a5,-1
    80004238:	64f2                	ld	s1,280(sp)
    8000423a:	6952                	ld	s2,272(sp)
}
    8000423c:	853e                	mv	a0,a5
    8000423e:	70b2                	ld	ra,296(sp)
    80004240:	7412                	ld	s0,288(sp)
    80004242:	6155                	addi	sp,sp,304
    80004244:	8082                	ret

0000000080004246 <sys_unlink>:
{
    80004246:	7151                	addi	sp,sp,-240
    80004248:	f586                	sd	ra,232(sp)
    8000424a:	f1a2                	sd	s0,224(sp)
    8000424c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000424e:	08000613          	li	a2,128
    80004252:	f3040593          	addi	a1,s0,-208
    80004256:	4501                	li	a0,0
    80004258:	a57fd0ef          	jal	80001cae <argstr>
    8000425c:	16054063          	bltz	a0,800043bc <sys_unlink+0x176>
    80004260:	eda6                	sd	s1,216(sp)
  begin_op();
    80004262:	e43fe0ef          	jal	800030a4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004266:	fb040593          	addi	a1,s0,-80
    8000426a:	f3040513          	addi	a0,s0,-208
    8000426e:	c7dfe0ef          	jal	80002eea <nameiparent>
    80004272:	84aa                	mv	s1,a0
    80004274:	c945                	beqz	a0,80004324 <sys_unlink+0xde>
  ilock(dp);
    80004276:	c44fe0ef          	jal	800026ba <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000427a:	00003597          	auipc	a1,0x3
    8000427e:	2e658593          	addi	a1,a1,742 # 80007560 <etext+0x560>
    80004282:	fb040513          	addi	a0,s0,-80
    80004286:	9cffe0ef          	jal	80002c54 <namecmp>
    8000428a:	10050e63          	beqz	a0,800043a6 <sys_unlink+0x160>
    8000428e:	00003597          	auipc	a1,0x3
    80004292:	2da58593          	addi	a1,a1,730 # 80007568 <etext+0x568>
    80004296:	fb040513          	addi	a0,s0,-80
    8000429a:	9bbfe0ef          	jal	80002c54 <namecmp>
    8000429e:	10050463          	beqz	a0,800043a6 <sys_unlink+0x160>
    800042a2:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800042a4:	f2c40613          	addi	a2,s0,-212
    800042a8:	fb040593          	addi	a1,s0,-80
    800042ac:	8526                	mv	a0,s1
    800042ae:	9bdfe0ef          	jal	80002c6a <dirlookup>
    800042b2:	892a                	mv	s2,a0
    800042b4:	0e050863          	beqz	a0,800043a4 <sys_unlink+0x15e>
  ilock(ip);
    800042b8:	c02fe0ef          	jal	800026ba <ilock>
  if(ip->nlink < 1)
    800042bc:	04a91783          	lh	a5,74(s2)
    800042c0:	06f05763          	blez	a5,8000432e <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042c4:	04491703          	lh	a4,68(s2)
    800042c8:	4785                	li	a5,1
    800042ca:	06f70963          	beq	a4,a5,8000433c <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800042ce:	4641                	li	a2,16
    800042d0:	4581                	li	a1,0
    800042d2:	fc040513          	addi	a0,s0,-64
    800042d6:	e79fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042da:	4741                	li	a4,16
    800042dc:	f2c42683          	lw	a3,-212(s0)
    800042e0:	fc040613          	addi	a2,s0,-64
    800042e4:	4581                	li	a1,0
    800042e6:	8526                	mv	a0,s1
    800042e8:	85ffe0ef          	jal	80002b46 <writei>
    800042ec:	47c1                	li	a5,16
    800042ee:	08f51b63          	bne	a0,a5,80004384 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800042f2:	04491703          	lh	a4,68(s2)
    800042f6:	4785                	li	a5,1
    800042f8:	08f70d63          	beq	a4,a5,80004392 <sys_unlink+0x14c>
  iunlockput(dp);
    800042fc:	8526                	mv	a0,s1
    800042fe:	dc6fe0ef          	jal	800028c4 <iunlockput>
  ip->nlink--;
    80004302:	04a95783          	lhu	a5,74(s2)
    80004306:	37fd                	addiw	a5,a5,-1
    80004308:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000430c:	854a                	mv	a0,s2
    8000430e:	af8fe0ef          	jal	80002606 <iupdate>
  iunlockput(ip);
    80004312:	854a                	mv	a0,s2
    80004314:	db0fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    80004318:	df7fe0ef          	jal	8000310e <end_op>
  return 0;
    8000431c:	4501                	li	a0,0
    8000431e:	64ee                	ld	s1,216(sp)
    80004320:	694e                	ld	s2,208(sp)
    80004322:	a849                	j	800043b4 <sys_unlink+0x16e>
    end_op();
    80004324:	debfe0ef          	jal	8000310e <end_op>
    return -1;
    80004328:	557d                	li	a0,-1
    8000432a:	64ee                	ld	s1,216(sp)
    8000432c:	a061                	j	800043b4 <sys_unlink+0x16e>
    8000432e:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004330:	00003517          	auipc	a0,0x3
    80004334:	24050513          	addi	a0,a0,576 # 80007570 <etext+0x570>
    80004338:	2c6010ef          	jal	800055fe <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000433c:	04c92703          	lw	a4,76(s2)
    80004340:	02000793          	li	a5,32
    80004344:	f8e7f5e3          	bgeu	a5,a4,800042ce <sys_unlink+0x88>
    80004348:	e5ce                	sd	s3,200(sp)
    8000434a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000434e:	4741                	li	a4,16
    80004350:	86ce                	mv	a3,s3
    80004352:	f1840613          	addi	a2,s0,-232
    80004356:	4581                	li	a1,0
    80004358:	854a                	mv	a0,s2
    8000435a:	ef0fe0ef          	jal	80002a4a <readi>
    8000435e:	47c1                	li	a5,16
    80004360:	00f51c63          	bne	a0,a5,80004378 <sys_unlink+0x132>
    if(de.inum != 0)
    80004364:	f1845783          	lhu	a5,-232(s0)
    80004368:	efa1                	bnez	a5,800043c0 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000436a:	29c1                	addiw	s3,s3,16
    8000436c:	04c92783          	lw	a5,76(s2)
    80004370:	fcf9efe3          	bltu	s3,a5,8000434e <sys_unlink+0x108>
    80004374:	69ae                	ld	s3,200(sp)
    80004376:	bfa1                	j	800042ce <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004378:	00003517          	auipc	a0,0x3
    8000437c:	21050513          	addi	a0,a0,528 # 80007588 <etext+0x588>
    80004380:	27e010ef          	jal	800055fe <panic>
    80004384:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004386:	00003517          	auipc	a0,0x3
    8000438a:	21a50513          	addi	a0,a0,538 # 800075a0 <etext+0x5a0>
    8000438e:	270010ef          	jal	800055fe <panic>
    dp->nlink--;
    80004392:	04a4d783          	lhu	a5,74(s1)
    80004396:	37fd                	addiw	a5,a5,-1
    80004398:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000439c:	8526                	mv	a0,s1
    8000439e:	a68fe0ef          	jal	80002606 <iupdate>
    800043a2:	bfa9                	j	800042fc <sys_unlink+0xb6>
    800043a4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800043a6:	8526                	mv	a0,s1
    800043a8:	d1cfe0ef          	jal	800028c4 <iunlockput>
  end_op();
    800043ac:	d63fe0ef          	jal	8000310e <end_op>
  return -1;
    800043b0:	557d                	li	a0,-1
    800043b2:	64ee                	ld	s1,216(sp)
}
    800043b4:	70ae                	ld	ra,232(sp)
    800043b6:	740e                	ld	s0,224(sp)
    800043b8:	616d                	addi	sp,sp,240
    800043ba:	8082                	ret
    return -1;
    800043bc:	557d                	li	a0,-1
    800043be:	bfdd                	j	800043b4 <sys_unlink+0x16e>
    iunlockput(ip);
    800043c0:	854a                	mv	a0,s2
    800043c2:	d02fe0ef          	jal	800028c4 <iunlockput>
    goto bad;
    800043c6:	694e                	ld	s2,208(sp)
    800043c8:	69ae                	ld	s3,200(sp)
    800043ca:	bff1                	j	800043a6 <sys_unlink+0x160>

00000000800043cc <sys_open>:

uint64
sys_open(void)
{
    800043cc:	7131                	addi	sp,sp,-192
    800043ce:	fd06                	sd	ra,184(sp)
    800043d0:	f922                	sd	s0,176(sp)
    800043d2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043d4:	f4c40593          	addi	a1,s0,-180
    800043d8:	4505                	li	a0,1
    800043da:	89dfd0ef          	jal	80001c76 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043de:	08000613          	li	a2,128
    800043e2:	f5040593          	addi	a1,s0,-176
    800043e6:	4501                	li	a0,0
    800043e8:	8c7fd0ef          	jal	80001cae <argstr>
    800043ec:	87aa                	mv	a5,a0
    return -1;
    800043ee:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043f0:	0a07c263          	bltz	a5,80004494 <sys_open+0xc8>
    800043f4:	f526                	sd	s1,168(sp)

  begin_op();
    800043f6:	caffe0ef          	jal	800030a4 <begin_op>

  if(omode & O_CREATE){
    800043fa:	f4c42783          	lw	a5,-180(s0)
    800043fe:	2007f793          	andi	a5,a5,512
    80004402:	c3d5                	beqz	a5,800044a6 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004404:	4681                	li	a3,0
    80004406:	4601                	li	a2,0
    80004408:	4589                	li	a1,2
    8000440a:	f5040513          	addi	a0,s0,-176
    8000440e:	aa9ff0ef          	jal	80003eb6 <create>
    80004412:	84aa                	mv	s1,a0
    if(ip == 0){
    80004414:	c541                	beqz	a0,8000449c <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004416:	04449703          	lh	a4,68(s1)
    8000441a:	478d                	li	a5,3
    8000441c:	00f71763          	bne	a4,a5,8000442a <sys_open+0x5e>
    80004420:	0464d703          	lhu	a4,70(s1)
    80004424:	47a5                	li	a5,9
    80004426:	0ae7ed63          	bltu	a5,a4,800044e0 <sys_open+0x114>
    8000442a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000442c:	fe1fe0ef          	jal	8000340c <filealloc>
    80004430:	892a                	mv	s2,a0
    80004432:	c179                	beqz	a0,800044f8 <sys_open+0x12c>
    80004434:	ed4e                	sd	s3,152(sp)
    80004436:	a43ff0ef          	jal	80003e78 <fdalloc>
    8000443a:	89aa                	mv	s3,a0
    8000443c:	0a054a63          	bltz	a0,800044f0 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004440:	04449703          	lh	a4,68(s1)
    80004444:	478d                	li	a5,3
    80004446:	0cf70263          	beq	a4,a5,8000450a <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000444a:	4789                	li	a5,2
    8000444c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004450:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004454:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004458:	f4c42783          	lw	a5,-180(s0)
    8000445c:	0017c713          	xori	a4,a5,1
    80004460:	8b05                	andi	a4,a4,1
    80004462:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004466:	0037f713          	andi	a4,a5,3
    8000446a:	00e03733          	snez	a4,a4
    8000446e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004472:	4007f793          	andi	a5,a5,1024
    80004476:	c791                	beqz	a5,80004482 <sys_open+0xb6>
    80004478:	04449703          	lh	a4,68(s1)
    8000447c:	4789                	li	a5,2
    8000447e:	08f70d63          	beq	a4,a5,80004518 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004482:	8526                	mv	a0,s1
    80004484:	ae4fe0ef          	jal	80002768 <iunlock>
  end_op();
    80004488:	c87fe0ef          	jal	8000310e <end_op>

  return fd;
    8000448c:	854e                	mv	a0,s3
    8000448e:	74aa                	ld	s1,168(sp)
    80004490:	790a                	ld	s2,160(sp)
    80004492:	69ea                	ld	s3,152(sp)
}
    80004494:	70ea                	ld	ra,184(sp)
    80004496:	744a                	ld	s0,176(sp)
    80004498:	6129                	addi	sp,sp,192
    8000449a:	8082                	ret
      end_op();
    8000449c:	c73fe0ef          	jal	8000310e <end_op>
      return -1;
    800044a0:	557d                	li	a0,-1
    800044a2:	74aa                	ld	s1,168(sp)
    800044a4:	bfc5                	j	80004494 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800044a6:	f5040513          	addi	a0,s0,-176
    800044aa:	a27fe0ef          	jal	80002ed0 <namei>
    800044ae:	84aa                	mv	s1,a0
    800044b0:	c11d                	beqz	a0,800044d6 <sys_open+0x10a>
    ilock(ip);
    800044b2:	a08fe0ef          	jal	800026ba <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800044b6:	04449703          	lh	a4,68(s1)
    800044ba:	4785                	li	a5,1
    800044bc:	f4f71de3          	bne	a4,a5,80004416 <sys_open+0x4a>
    800044c0:	f4c42783          	lw	a5,-180(s0)
    800044c4:	d3bd                	beqz	a5,8000442a <sys_open+0x5e>
      iunlockput(ip);
    800044c6:	8526                	mv	a0,s1
    800044c8:	bfcfe0ef          	jal	800028c4 <iunlockput>
      end_op();
    800044cc:	c43fe0ef          	jal	8000310e <end_op>
      return -1;
    800044d0:	557d                	li	a0,-1
    800044d2:	74aa                	ld	s1,168(sp)
    800044d4:	b7c1                	j	80004494 <sys_open+0xc8>
      end_op();
    800044d6:	c39fe0ef          	jal	8000310e <end_op>
      return -1;
    800044da:	557d                	li	a0,-1
    800044dc:	74aa                	ld	s1,168(sp)
    800044de:	bf5d                	j	80004494 <sys_open+0xc8>
    iunlockput(ip);
    800044e0:	8526                	mv	a0,s1
    800044e2:	be2fe0ef          	jal	800028c4 <iunlockput>
    end_op();
    800044e6:	c29fe0ef          	jal	8000310e <end_op>
    return -1;
    800044ea:	557d                	li	a0,-1
    800044ec:	74aa                	ld	s1,168(sp)
    800044ee:	b75d                	j	80004494 <sys_open+0xc8>
      fileclose(f);
    800044f0:	854a                	mv	a0,s2
    800044f2:	fbffe0ef          	jal	800034b0 <fileclose>
    800044f6:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044f8:	8526                	mv	a0,s1
    800044fa:	bcafe0ef          	jal	800028c4 <iunlockput>
    end_op();
    800044fe:	c11fe0ef          	jal	8000310e <end_op>
    return -1;
    80004502:	557d                	li	a0,-1
    80004504:	74aa                	ld	s1,168(sp)
    80004506:	790a                	ld	s2,160(sp)
    80004508:	b771                	j	80004494 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000450a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000450e:	04649783          	lh	a5,70(s1)
    80004512:	02f91223          	sh	a5,36(s2)
    80004516:	bf3d                	j	80004454 <sys_open+0x88>
    itrunc(ip);
    80004518:	8526                	mv	a0,s1
    8000451a:	a8efe0ef          	jal	800027a8 <itrunc>
    8000451e:	b795                	j	80004482 <sys_open+0xb6>

0000000080004520 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004520:	7175                	addi	sp,sp,-144
    80004522:	e506                	sd	ra,136(sp)
    80004524:	e122                	sd	s0,128(sp)
    80004526:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004528:	b7dfe0ef          	jal	800030a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000452c:	08000613          	li	a2,128
    80004530:	f7040593          	addi	a1,s0,-144
    80004534:	4501                	li	a0,0
    80004536:	f78fd0ef          	jal	80001cae <argstr>
    8000453a:	02054363          	bltz	a0,80004560 <sys_mkdir+0x40>
    8000453e:	4681                	li	a3,0
    80004540:	4601                	li	a2,0
    80004542:	4585                	li	a1,1
    80004544:	f7040513          	addi	a0,s0,-144
    80004548:	96fff0ef          	jal	80003eb6 <create>
    8000454c:	c911                	beqz	a0,80004560 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000454e:	b76fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    80004552:	bbdfe0ef          	jal	8000310e <end_op>
  return 0;
    80004556:	4501                	li	a0,0
}
    80004558:	60aa                	ld	ra,136(sp)
    8000455a:	640a                	ld	s0,128(sp)
    8000455c:	6149                	addi	sp,sp,144
    8000455e:	8082                	ret
    end_op();
    80004560:	baffe0ef          	jal	8000310e <end_op>
    return -1;
    80004564:	557d                	li	a0,-1
    80004566:	bfcd                	j	80004558 <sys_mkdir+0x38>

0000000080004568 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004568:	7135                	addi	sp,sp,-160
    8000456a:	ed06                	sd	ra,152(sp)
    8000456c:	e922                	sd	s0,144(sp)
    8000456e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004570:	b35fe0ef          	jal	800030a4 <begin_op>
  argint(1, &major);
    80004574:	f6c40593          	addi	a1,s0,-148
    80004578:	4505                	li	a0,1
    8000457a:	efcfd0ef          	jal	80001c76 <argint>
  argint(2, &minor);
    8000457e:	f6840593          	addi	a1,s0,-152
    80004582:	4509                	li	a0,2
    80004584:	ef2fd0ef          	jal	80001c76 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004588:	08000613          	li	a2,128
    8000458c:	f7040593          	addi	a1,s0,-144
    80004590:	4501                	li	a0,0
    80004592:	f1cfd0ef          	jal	80001cae <argstr>
    80004596:	02054563          	bltz	a0,800045c0 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000459a:	f6841683          	lh	a3,-152(s0)
    8000459e:	f6c41603          	lh	a2,-148(s0)
    800045a2:	458d                	li	a1,3
    800045a4:	f7040513          	addi	a0,s0,-144
    800045a8:	90fff0ef          	jal	80003eb6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045ac:	c911                	beqz	a0,800045c0 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045ae:	b16fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    800045b2:	b5dfe0ef          	jal	8000310e <end_op>
  return 0;
    800045b6:	4501                	li	a0,0
}
    800045b8:	60ea                	ld	ra,152(sp)
    800045ba:	644a                	ld	s0,144(sp)
    800045bc:	610d                	addi	sp,sp,160
    800045be:	8082                	ret
    end_op();
    800045c0:	b4ffe0ef          	jal	8000310e <end_op>
    return -1;
    800045c4:	557d                	li	a0,-1
    800045c6:	bfcd                	j	800045b8 <sys_mknod+0x50>

00000000800045c8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045c8:	7135                	addi	sp,sp,-160
    800045ca:	ed06                	sd	ra,152(sp)
    800045cc:	e922                	sd	s0,144(sp)
    800045ce:	e14a                	sd	s2,128(sp)
    800045d0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045d2:	fa8fc0ef          	jal	80000d7a <myproc>
    800045d6:	892a                	mv	s2,a0
  
  begin_op();
    800045d8:	acdfe0ef          	jal	800030a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045dc:	08000613          	li	a2,128
    800045e0:	f6040593          	addi	a1,s0,-160
    800045e4:	4501                	li	a0,0
    800045e6:	ec8fd0ef          	jal	80001cae <argstr>
    800045ea:	04054363          	bltz	a0,80004630 <sys_chdir+0x68>
    800045ee:	e526                	sd	s1,136(sp)
    800045f0:	f6040513          	addi	a0,s0,-160
    800045f4:	8ddfe0ef          	jal	80002ed0 <namei>
    800045f8:	84aa                	mv	s1,a0
    800045fa:	c915                	beqz	a0,8000462e <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800045fc:	8befe0ef          	jal	800026ba <ilock>
  if(ip->type != T_DIR){
    80004600:	04449703          	lh	a4,68(s1)
    80004604:	4785                	li	a5,1
    80004606:	02f71963          	bne	a4,a5,80004638 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000460a:	8526                	mv	a0,s1
    8000460c:	95cfe0ef          	jal	80002768 <iunlock>
  iput(p->cwd);
    80004610:	15093503          	ld	a0,336(s2)
    80004614:	a28fe0ef          	jal	8000283c <iput>
  end_op();
    80004618:	af7fe0ef          	jal	8000310e <end_op>
  p->cwd = ip;
    8000461c:	14993823          	sd	s1,336(s2)
  return 0;
    80004620:	4501                	li	a0,0
    80004622:	64aa                	ld	s1,136(sp)
}
    80004624:	60ea                	ld	ra,152(sp)
    80004626:	644a                	ld	s0,144(sp)
    80004628:	690a                	ld	s2,128(sp)
    8000462a:	610d                	addi	sp,sp,160
    8000462c:	8082                	ret
    8000462e:	64aa                	ld	s1,136(sp)
    end_op();
    80004630:	adffe0ef          	jal	8000310e <end_op>
    return -1;
    80004634:	557d                	li	a0,-1
    80004636:	b7fd                	j	80004624 <sys_chdir+0x5c>
    iunlockput(ip);
    80004638:	8526                	mv	a0,s1
    8000463a:	a8afe0ef          	jal	800028c4 <iunlockput>
    end_op();
    8000463e:	ad1fe0ef          	jal	8000310e <end_op>
    return -1;
    80004642:	557d                	li	a0,-1
    80004644:	64aa                	ld	s1,136(sp)
    80004646:	bff9                	j	80004624 <sys_chdir+0x5c>

0000000080004648 <sys_exec>:

uint64
sys_exec(void)
{
    80004648:	7121                	addi	sp,sp,-448
    8000464a:	ff06                	sd	ra,440(sp)
    8000464c:	fb22                	sd	s0,432(sp)
    8000464e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004650:	e4840593          	addi	a1,s0,-440
    80004654:	4505                	li	a0,1
    80004656:	e3cfd0ef          	jal	80001c92 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000465a:	08000613          	li	a2,128
    8000465e:	f5040593          	addi	a1,s0,-176
    80004662:	4501                	li	a0,0
    80004664:	e4afd0ef          	jal	80001cae <argstr>
    80004668:	87aa                	mv	a5,a0
    return -1;
    8000466a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000466c:	0c07c463          	bltz	a5,80004734 <sys_exec+0xec>
    80004670:	f726                	sd	s1,424(sp)
    80004672:	f34a                	sd	s2,416(sp)
    80004674:	ef4e                	sd	s3,408(sp)
    80004676:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004678:	10000613          	li	a2,256
    8000467c:	4581                	li	a1,0
    8000467e:	e5040513          	addi	a0,s0,-432
    80004682:	acdfb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004686:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000468a:	89a6                	mv	s3,s1
    8000468c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000468e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004692:	00391513          	slli	a0,s2,0x3
    80004696:	e4040593          	addi	a1,s0,-448
    8000469a:	e4843783          	ld	a5,-440(s0)
    8000469e:	953e                	add	a0,a0,a5
    800046a0:	d4cfd0ef          	jal	80001bec <fetchaddr>
    800046a4:	02054663          	bltz	a0,800046d0 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800046a8:	e4043783          	ld	a5,-448(s0)
    800046ac:	c3a9                	beqz	a5,800046ee <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800046ae:	a51fb0ef          	jal	800000fe <kalloc>
    800046b2:	85aa                	mv	a1,a0
    800046b4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800046b8:	cd01                	beqz	a0,800046d0 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046ba:	6605                	lui	a2,0x1
    800046bc:	e4043503          	ld	a0,-448(s0)
    800046c0:	d76fd0ef          	jal	80001c36 <fetchstr>
    800046c4:	00054663          	bltz	a0,800046d0 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800046c8:	0905                	addi	s2,s2,1
    800046ca:	09a1                	addi	s3,s3,8
    800046cc:	fd4913e3          	bne	s2,s4,80004692 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046d0:	f5040913          	addi	s2,s0,-176
    800046d4:	6088                	ld	a0,0(s1)
    800046d6:	c931                	beqz	a0,8000472a <sys_exec+0xe2>
    kfree(argv[i]);
    800046d8:	945fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046dc:	04a1                	addi	s1,s1,8
    800046de:	ff249be3          	bne	s1,s2,800046d4 <sys_exec+0x8c>
  return -1;
    800046e2:	557d                	li	a0,-1
    800046e4:	74ba                	ld	s1,424(sp)
    800046e6:	791a                	ld	s2,416(sp)
    800046e8:	69fa                	ld	s3,408(sp)
    800046ea:	6a5a                	ld	s4,400(sp)
    800046ec:	a0a1                	j	80004734 <sys_exec+0xec>
      argv[i] = 0;
    800046ee:	0009079b          	sext.w	a5,s2
    800046f2:	078e                	slli	a5,a5,0x3
    800046f4:	fd078793          	addi	a5,a5,-48
    800046f8:	97a2                	add	a5,a5,s0
    800046fa:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    800046fe:	e5040593          	addi	a1,s0,-432
    80004702:	f5040513          	addi	a0,s0,-176
    80004706:	ba8ff0ef          	jal	80003aae <kexec>
    8000470a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000470c:	f5040993          	addi	s3,s0,-176
    80004710:	6088                	ld	a0,0(s1)
    80004712:	c511                	beqz	a0,8000471e <sys_exec+0xd6>
    kfree(argv[i]);
    80004714:	909fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004718:	04a1                	addi	s1,s1,8
    8000471a:	ff349be3          	bne	s1,s3,80004710 <sys_exec+0xc8>
  return ret;
    8000471e:	854a                	mv	a0,s2
    80004720:	74ba                	ld	s1,424(sp)
    80004722:	791a                	ld	s2,416(sp)
    80004724:	69fa                	ld	s3,408(sp)
    80004726:	6a5a                	ld	s4,400(sp)
    80004728:	a031                	j	80004734 <sys_exec+0xec>
  return -1;
    8000472a:	557d                	li	a0,-1
    8000472c:	74ba                	ld	s1,424(sp)
    8000472e:	791a                	ld	s2,416(sp)
    80004730:	69fa                	ld	s3,408(sp)
    80004732:	6a5a                	ld	s4,400(sp)
}
    80004734:	70fa                	ld	ra,440(sp)
    80004736:	745a                	ld	s0,432(sp)
    80004738:	6139                	addi	sp,sp,448
    8000473a:	8082                	ret

000000008000473c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000473c:	7139                	addi	sp,sp,-64
    8000473e:	fc06                	sd	ra,56(sp)
    80004740:	f822                	sd	s0,48(sp)
    80004742:	f426                	sd	s1,40(sp)
    80004744:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004746:	e34fc0ef          	jal	80000d7a <myproc>
    8000474a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000474c:	fd840593          	addi	a1,s0,-40
    80004750:	4501                	li	a0,0
    80004752:	d40fd0ef          	jal	80001c92 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004756:	fc840593          	addi	a1,s0,-56
    8000475a:	fd040513          	addi	a0,s0,-48
    8000475e:	85cff0ef          	jal	800037ba <pipealloc>
    return -1;
    80004762:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004764:	0a054463          	bltz	a0,8000480c <sys_pipe+0xd0>
  fd0 = -1;
    80004768:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000476c:	fd043503          	ld	a0,-48(s0)
    80004770:	f08ff0ef          	jal	80003e78 <fdalloc>
    80004774:	fca42223          	sw	a0,-60(s0)
    80004778:	08054163          	bltz	a0,800047fa <sys_pipe+0xbe>
    8000477c:	fc843503          	ld	a0,-56(s0)
    80004780:	ef8ff0ef          	jal	80003e78 <fdalloc>
    80004784:	fca42023          	sw	a0,-64(s0)
    80004788:	06054063          	bltz	a0,800047e8 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000478c:	4691                	li	a3,4
    8000478e:	fc440613          	addi	a2,s0,-60
    80004792:	fd843583          	ld	a1,-40(s0)
    80004796:	68a8                	ld	a0,80(s1)
    80004798:	af6fc0ef          	jal	80000a8e <copyout>
    8000479c:	00054e63          	bltz	a0,800047b8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800047a0:	4691                	li	a3,4
    800047a2:	fc040613          	addi	a2,s0,-64
    800047a6:	fd843583          	ld	a1,-40(s0)
    800047aa:	0591                	addi	a1,a1,4
    800047ac:	68a8                	ld	a0,80(s1)
    800047ae:	ae0fc0ef          	jal	80000a8e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047b2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047b4:	04055c63          	bgez	a0,8000480c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800047b8:	fc442783          	lw	a5,-60(s0)
    800047bc:	07e9                	addi	a5,a5,26
    800047be:	078e                	slli	a5,a5,0x3
    800047c0:	97a6                	add	a5,a5,s1
    800047c2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047c6:	fc042783          	lw	a5,-64(s0)
    800047ca:	07e9                	addi	a5,a5,26
    800047cc:	078e                	slli	a5,a5,0x3
    800047ce:	94be                	add	s1,s1,a5
    800047d0:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800047d4:	fd043503          	ld	a0,-48(s0)
    800047d8:	cd9fe0ef          	jal	800034b0 <fileclose>
    fileclose(wf);
    800047dc:	fc843503          	ld	a0,-56(s0)
    800047e0:	cd1fe0ef          	jal	800034b0 <fileclose>
    return -1;
    800047e4:	57fd                	li	a5,-1
    800047e6:	a01d                	j	8000480c <sys_pipe+0xd0>
    if(fd0 >= 0)
    800047e8:	fc442783          	lw	a5,-60(s0)
    800047ec:	0007c763          	bltz	a5,800047fa <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800047f0:	07e9                	addi	a5,a5,26
    800047f2:	078e                	slli	a5,a5,0x3
    800047f4:	97a6                	add	a5,a5,s1
    800047f6:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047fa:	fd043503          	ld	a0,-48(s0)
    800047fe:	cb3fe0ef          	jal	800034b0 <fileclose>
    fileclose(wf);
    80004802:	fc843503          	ld	a0,-56(s0)
    80004806:	cabfe0ef          	jal	800034b0 <fileclose>
    return -1;
    8000480a:	57fd                	li	a5,-1
}
    8000480c:	853e                	mv	a0,a5
    8000480e:	70e2                	ld	ra,56(sp)
    80004810:	7442                	ld	s0,48(sp)
    80004812:	74a2                	ld	s1,40(sp)
    80004814:	6121                	addi	sp,sp,64
    80004816:	8082                	ret
	...

0000000080004820 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004820:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004822:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004824:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004826:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004828:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000482a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000482c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000482e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004830:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004832:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004834:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004836:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004838:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000483a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000483c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000483e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004840:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004842:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004844:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004846:	ab6fd0ef          	jal	80001afc <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000484a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000484c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000484e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004850:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004852:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004854:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004856:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004858:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000485a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000485c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000485e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004860:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004862:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004864:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004866:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004868:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000486a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000486c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000486e:	10200073          	sret
	...

000000008000487e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000487e:	1141                	addi	sp,sp,-16
    80004880:	e422                	sd	s0,8(sp)
    80004882:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004884:	0c0007b7          	lui	a5,0xc000
    80004888:	4705                	li	a4,1
    8000488a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000488c:	0c0007b7          	lui	a5,0xc000
    80004890:	c3d8                	sw	a4,4(a5)
}
    80004892:	6422                	ld	s0,8(sp)
    80004894:	0141                	addi	sp,sp,16
    80004896:	8082                	ret

0000000080004898 <plicinithart>:

void
plicinithart(void)
{
    80004898:	1141                	addi	sp,sp,-16
    8000489a:	e406                	sd	ra,8(sp)
    8000489c:	e022                	sd	s0,0(sp)
    8000489e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048a0:	caefc0ef          	jal	80000d4e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800048a4:	0085171b          	slliw	a4,a0,0x8
    800048a8:	0c0027b7          	lui	a5,0xc002
    800048ac:	97ba                	add	a5,a5,a4
    800048ae:	40200713          	li	a4,1026
    800048b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800048b6:	00d5151b          	slliw	a0,a0,0xd
    800048ba:	0c2017b7          	lui	a5,0xc201
    800048be:	97aa                	add	a5,a5,a0
    800048c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800048c4:	60a2                	ld	ra,8(sp)
    800048c6:	6402                	ld	s0,0(sp)
    800048c8:	0141                	addi	sp,sp,16
    800048ca:	8082                	ret

00000000800048cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800048cc:	1141                	addi	sp,sp,-16
    800048ce:	e406                	sd	ra,8(sp)
    800048d0:	e022                	sd	s0,0(sp)
    800048d2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048d4:	c7afc0ef          	jal	80000d4e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800048d8:	00d5151b          	slliw	a0,a0,0xd
    800048dc:	0c2017b7          	lui	a5,0xc201
    800048e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800048e2:	43c8                	lw	a0,4(a5)
    800048e4:	60a2                	ld	ra,8(sp)
    800048e6:	6402                	ld	s0,0(sp)
    800048e8:	0141                	addi	sp,sp,16
    800048ea:	8082                	ret

00000000800048ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800048ec:	1101                	addi	sp,sp,-32
    800048ee:	ec06                	sd	ra,24(sp)
    800048f0:	e822                	sd	s0,16(sp)
    800048f2:	e426                	sd	s1,8(sp)
    800048f4:	1000                	addi	s0,sp,32
    800048f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800048f8:	c56fc0ef          	jal	80000d4e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800048fc:	00d5151b          	slliw	a0,a0,0xd
    80004900:	0c2017b7          	lui	a5,0xc201
    80004904:	97aa                	add	a5,a5,a0
    80004906:	c3c4                	sw	s1,4(a5)
}
    80004908:	60e2                	ld	ra,24(sp)
    8000490a:	6442                	ld	s0,16(sp)
    8000490c:	64a2                	ld	s1,8(sp)
    8000490e:	6105                	addi	sp,sp,32
    80004910:	8082                	ret

0000000080004912 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004912:	1141                	addi	sp,sp,-16
    80004914:	e406                	sd	ra,8(sp)
    80004916:	e022                	sd	s0,0(sp)
    80004918:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000491a:	479d                	li	a5,7
    8000491c:	04a7ca63          	blt	a5,a0,80004970 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004920:	00017797          	auipc	a5,0x17
    80004924:	9a078793          	addi	a5,a5,-1632 # 8001b2c0 <disk>
    80004928:	97aa                	add	a5,a5,a0
    8000492a:	0187c783          	lbu	a5,24(a5)
    8000492e:	e7b9                	bnez	a5,8000497c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004930:	00451693          	slli	a3,a0,0x4
    80004934:	00017797          	auipc	a5,0x17
    80004938:	98c78793          	addi	a5,a5,-1652 # 8001b2c0 <disk>
    8000493c:	6398                	ld	a4,0(a5)
    8000493e:	9736                	add	a4,a4,a3
    80004940:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004944:	6398                	ld	a4,0(a5)
    80004946:	9736                	add	a4,a4,a3
    80004948:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000494c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004950:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004954:	97aa                	add	a5,a5,a0
    80004956:	4705                	li	a4,1
    80004958:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000495c:	00017517          	auipc	a0,0x17
    80004960:	97c50513          	addi	a0,a0,-1668 # 8001b2d8 <disk+0x18>
    80004964:	a5bfc0ef          	jal	800013be <wakeup>
}
    80004968:	60a2                	ld	ra,8(sp)
    8000496a:	6402                	ld	s0,0(sp)
    8000496c:	0141                	addi	sp,sp,16
    8000496e:	8082                	ret
    panic("free_desc 1");
    80004970:	00003517          	auipc	a0,0x3
    80004974:	c4050513          	addi	a0,a0,-960 # 800075b0 <etext+0x5b0>
    80004978:	487000ef          	jal	800055fe <panic>
    panic("free_desc 2");
    8000497c:	00003517          	auipc	a0,0x3
    80004980:	c4450513          	addi	a0,a0,-956 # 800075c0 <etext+0x5c0>
    80004984:	47b000ef          	jal	800055fe <panic>

0000000080004988 <virtio_disk_init>:
{
    80004988:	1101                	addi	sp,sp,-32
    8000498a:	ec06                	sd	ra,24(sp)
    8000498c:	e822                	sd	s0,16(sp)
    8000498e:	e426                	sd	s1,8(sp)
    80004990:	e04a                	sd	s2,0(sp)
    80004992:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004994:	00003597          	auipc	a1,0x3
    80004998:	c3c58593          	addi	a1,a1,-964 # 800075d0 <etext+0x5d0>
    8000499c:	00017517          	auipc	a0,0x17
    800049a0:	a4c50513          	addi	a0,a0,-1460 # 8001b3e8 <disk+0x128>
    800049a4:	697000ef          	jal	8000583a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049a8:	100017b7          	lui	a5,0x10001
    800049ac:	4398                	lw	a4,0(a5)
    800049ae:	2701                	sext.w	a4,a4
    800049b0:	747277b7          	lui	a5,0x74727
    800049b4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800049b8:	18f71063          	bne	a4,a5,80004b38 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049bc:	100017b7          	lui	a5,0x10001
    800049c0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800049c2:	439c                	lw	a5,0(a5)
    800049c4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049c6:	4709                	li	a4,2
    800049c8:	16e79863          	bne	a5,a4,80004b38 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049cc:	100017b7          	lui	a5,0x10001
    800049d0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800049d2:	439c                	lw	a5,0(a5)
    800049d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049d6:	16e79163          	bne	a5,a4,80004b38 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800049da:	100017b7          	lui	a5,0x10001
    800049de:	47d8                	lw	a4,12(a5)
    800049e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049e2:	554d47b7          	lui	a5,0x554d4
    800049e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800049ea:	14f71763          	bne	a4,a5,80004b38 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049ee:	100017b7          	lui	a5,0x10001
    800049f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049f6:	4705                	li	a4,1
    800049f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049fa:	470d                	li	a4,3
    800049fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800049fe:	10001737          	lui	a4,0x10001
    80004a02:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a04:	c7ffe737          	lui	a4,0xc7ffe
    80004a08:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb287>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a0c:	8ef9                	and	a3,a3,a4
    80004a0e:	10001737          	lui	a4,0x10001
    80004a12:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a14:	472d                	li	a4,11
    80004a16:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a18:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a1c:	439c                	lw	a5,0(a5)
    80004a1e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a22:	8ba1                	andi	a5,a5,8
    80004a24:	12078063          	beqz	a5,80004b44 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a28:	100017b7          	lui	a5,0x10001
    80004a2c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a30:	100017b7          	lui	a5,0x10001
    80004a34:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004a38:	439c                	lw	a5,0(a5)
    80004a3a:	2781                	sext.w	a5,a5
    80004a3c:	10079a63          	bnez	a5,80004b50 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004a40:	100017b7          	lui	a5,0x10001
    80004a44:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004a48:	439c                	lw	a5,0(a5)
    80004a4a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004a4c:	10078863          	beqz	a5,80004b5c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a50:	471d                	li	a4,7
    80004a52:	10f77b63          	bgeu	a4,a5,80004b68 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a56:	ea8fb0ef          	jal	800000fe <kalloc>
    80004a5a:	00017497          	auipc	s1,0x17
    80004a5e:	86648493          	addi	s1,s1,-1946 # 8001b2c0 <disk>
    80004a62:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a64:	e9afb0ef          	jal	800000fe <kalloc>
    80004a68:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a6a:	e94fb0ef          	jal	800000fe <kalloc>
    80004a6e:	87aa                	mv	a5,a0
    80004a70:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004a72:	6088                	ld	a0,0(s1)
    80004a74:	10050063          	beqz	a0,80004b74 <virtio_disk_init+0x1ec>
    80004a78:	00017717          	auipc	a4,0x17
    80004a7c:	85073703          	ld	a4,-1968(a4) # 8001b2c8 <disk+0x8>
    80004a80:	0e070a63          	beqz	a4,80004b74 <virtio_disk_init+0x1ec>
    80004a84:	0e078863          	beqz	a5,80004b74 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004a88:	6605                	lui	a2,0x1
    80004a8a:	4581                	li	a1,0
    80004a8c:	ec2fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a90:	00017497          	auipc	s1,0x17
    80004a94:	83048493          	addi	s1,s1,-2000 # 8001b2c0 <disk>
    80004a98:	6605                	lui	a2,0x1
    80004a9a:	4581                	li	a1,0
    80004a9c:	6488                	ld	a0,8(s1)
    80004a9e:	eb0fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004aa2:	6605                	lui	a2,0x1
    80004aa4:	4581                	li	a1,0
    80004aa6:	6888                	ld	a0,16(s1)
    80004aa8:	ea6fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004aac:	100017b7          	lui	a5,0x10001
    80004ab0:	4721                	li	a4,8
    80004ab2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004ab4:	4098                	lw	a4,0(s1)
    80004ab6:	100017b7          	lui	a5,0x10001
    80004aba:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004abe:	40d8                	lw	a4,4(s1)
    80004ac0:	100017b7          	lui	a5,0x10001
    80004ac4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004ac8:	649c                	ld	a5,8(s1)
    80004aca:	0007869b          	sext.w	a3,a5
    80004ace:	10001737          	lui	a4,0x10001
    80004ad2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004ad6:	9781                	srai	a5,a5,0x20
    80004ad8:	10001737          	lui	a4,0x10001
    80004adc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004ae0:	689c                	ld	a5,16(s1)
    80004ae2:	0007869b          	sext.w	a3,a5
    80004ae6:	10001737          	lui	a4,0x10001
    80004aea:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004aee:	9781                	srai	a5,a5,0x20
    80004af0:	10001737          	lui	a4,0x10001
    80004af4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004af8:	10001737          	lui	a4,0x10001
    80004afc:	4785                	li	a5,1
    80004afe:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b00:	00f48c23          	sb	a5,24(s1)
    80004b04:	00f48ca3          	sb	a5,25(s1)
    80004b08:	00f48d23          	sb	a5,26(s1)
    80004b0c:	00f48da3          	sb	a5,27(s1)
    80004b10:	00f48e23          	sb	a5,28(s1)
    80004b14:	00f48ea3          	sb	a5,29(s1)
    80004b18:	00f48f23          	sb	a5,30(s1)
    80004b1c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b20:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b24:	100017b7          	lui	a5,0x10001
    80004b28:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004b2c:	60e2                	ld	ra,24(sp)
    80004b2e:	6442                	ld	s0,16(sp)
    80004b30:	64a2                	ld	s1,8(sp)
    80004b32:	6902                	ld	s2,0(sp)
    80004b34:	6105                	addi	sp,sp,32
    80004b36:	8082                	ret
    panic("could not find virtio disk");
    80004b38:	00003517          	auipc	a0,0x3
    80004b3c:	aa850513          	addi	a0,a0,-1368 # 800075e0 <etext+0x5e0>
    80004b40:	2bf000ef          	jal	800055fe <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b44:	00003517          	auipc	a0,0x3
    80004b48:	abc50513          	addi	a0,a0,-1348 # 80007600 <etext+0x600>
    80004b4c:	2b3000ef          	jal	800055fe <panic>
    panic("virtio disk should not be ready");
    80004b50:	00003517          	auipc	a0,0x3
    80004b54:	ad050513          	addi	a0,a0,-1328 # 80007620 <etext+0x620>
    80004b58:	2a7000ef          	jal	800055fe <panic>
    panic("virtio disk has no queue 0");
    80004b5c:	00003517          	auipc	a0,0x3
    80004b60:	ae450513          	addi	a0,a0,-1308 # 80007640 <etext+0x640>
    80004b64:	29b000ef          	jal	800055fe <panic>
    panic("virtio disk max queue too short");
    80004b68:	00003517          	auipc	a0,0x3
    80004b6c:	af850513          	addi	a0,a0,-1288 # 80007660 <etext+0x660>
    80004b70:	28f000ef          	jal	800055fe <panic>
    panic("virtio disk kalloc");
    80004b74:	00003517          	auipc	a0,0x3
    80004b78:	b0c50513          	addi	a0,a0,-1268 # 80007680 <etext+0x680>
    80004b7c:	283000ef          	jal	800055fe <panic>

0000000080004b80 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004b80:	7159                	addi	sp,sp,-112
    80004b82:	f486                	sd	ra,104(sp)
    80004b84:	f0a2                	sd	s0,96(sp)
    80004b86:	eca6                	sd	s1,88(sp)
    80004b88:	e8ca                	sd	s2,80(sp)
    80004b8a:	e4ce                	sd	s3,72(sp)
    80004b8c:	e0d2                	sd	s4,64(sp)
    80004b8e:	fc56                	sd	s5,56(sp)
    80004b90:	f85a                	sd	s6,48(sp)
    80004b92:	f45e                	sd	s7,40(sp)
    80004b94:	f062                	sd	s8,32(sp)
    80004b96:	ec66                	sd	s9,24(sp)
    80004b98:	1880                	addi	s0,sp,112
    80004b9a:	8a2a                	mv	s4,a0
    80004b9c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004b9e:	00c52c83          	lw	s9,12(a0)
    80004ba2:	001c9c9b          	slliw	s9,s9,0x1
    80004ba6:	1c82                	slli	s9,s9,0x20
    80004ba8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004bac:	00017517          	auipc	a0,0x17
    80004bb0:	83c50513          	addi	a0,a0,-1988 # 8001b3e8 <disk+0x128>
    80004bb4:	507000ef          	jal	800058ba <acquire>
  for(int i = 0; i < 3; i++){
    80004bb8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004bba:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004bbc:	00016b17          	auipc	s6,0x16
    80004bc0:	704b0b13          	addi	s6,s6,1796 # 8001b2c0 <disk>
  for(int i = 0; i < 3; i++){
    80004bc4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004bc6:	00017c17          	auipc	s8,0x17
    80004bca:	822c0c13          	addi	s8,s8,-2014 # 8001b3e8 <disk+0x128>
    80004bce:	a8b9                	j	80004c2c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004bd0:	00fb0733          	add	a4,s6,a5
    80004bd4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004bd8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004bda:	0207c563          	bltz	a5,80004c04 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004bde:	2905                	addiw	s2,s2,1
    80004be0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004be2:	05590963          	beq	s2,s5,80004c34 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004be6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004be8:	00016717          	auipc	a4,0x16
    80004bec:	6d870713          	addi	a4,a4,1752 # 8001b2c0 <disk>
    80004bf0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004bf2:	01874683          	lbu	a3,24(a4)
    80004bf6:	fee9                	bnez	a3,80004bd0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004bf8:	2785                	addiw	a5,a5,1
    80004bfa:	0705                	addi	a4,a4,1
    80004bfc:	fe979be3          	bne	a5,s1,80004bf2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004c00:	57fd                	li	a5,-1
    80004c02:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004c04:	01205d63          	blez	s2,80004c1e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c08:	f9042503          	lw	a0,-112(s0)
    80004c0c:	d07ff0ef          	jal	80004912 <free_desc>
      for(int j = 0; j < i; j++)
    80004c10:	4785                	li	a5,1
    80004c12:	0127d663          	bge	a5,s2,80004c1e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c16:	f9442503          	lw	a0,-108(s0)
    80004c1a:	cf9ff0ef          	jal	80004912 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c1e:	85e2                	mv	a1,s8
    80004c20:	00016517          	auipc	a0,0x16
    80004c24:	6b850513          	addi	a0,a0,1720 # 8001b2d8 <disk+0x18>
    80004c28:	f4afc0ef          	jal	80001372 <sleep>
  for(int i = 0; i < 3; i++){
    80004c2c:	f9040613          	addi	a2,s0,-112
    80004c30:	894e                	mv	s2,s3
    80004c32:	bf55                	j	80004be6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c34:	f9042503          	lw	a0,-112(s0)
    80004c38:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c3c:	00016797          	auipc	a5,0x16
    80004c40:	68478793          	addi	a5,a5,1668 # 8001b2c0 <disk>
    80004c44:	00a50713          	addi	a4,a0,10
    80004c48:	0712                	slli	a4,a4,0x4
    80004c4a:	973e                	add	a4,a4,a5
    80004c4c:	01703633          	snez	a2,s7
    80004c50:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c52:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c56:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c5a:	6398                	ld	a4,0(a5)
    80004c5c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c5e:	0a868613          	addi	a2,a3,168
    80004c62:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c64:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c66:	6390                	ld	a2,0(a5)
    80004c68:	00d605b3          	add	a1,a2,a3
    80004c6c:	4741                	li	a4,16
    80004c6e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004c70:	4805                	li	a6,1
    80004c72:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004c76:	f9442703          	lw	a4,-108(s0)
    80004c7a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004c7e:	0712                	slli	a4,a4,0x4
    80004c80:	963a                	add	a2,a2,a4
    80004c82:	058a0593          	addi	a1,s4,88
    80004c86:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004c88:	0007b883          	ld	a7,0(a5)
    80004c8c:	9746                	add	a4,a4,a7
    80004c8e:	40000613          	li	a2,1024
    80004c92:	c710                	sw	a2,8(a4)
  if(write)
    80004c94:	001bb613          	seqz	a2,s7
    80004c98:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004c9c:	00166613          	ori	a2,a2,1
    80004ca0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ca4:	f9842583          	lw	a1,-104(s0)
    80004ca8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004cac:	00250613          	addi	a2,a0,2
    80004cb0:	0612                	slli	a2,a2,0x4
    80004cb2:	963e                	add	a2,a2,a5
    80004cb4:	577d                	li	a4,-1
    80004cb6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004cba:	0592                	slli	a1,a1,0x4
    80004cbc:	98ae                	add	a7,a7,a1
    80004cbe:	03068713          	addi	a4,a3,48
    80004cc2:	973e                	add	a4,a4,a5
    80004cc4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004cc8:	6398                	ld	a4,0(a5)
    80004cca:	972e                	add	a4,a4,a1
    80004ccc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004cd0:	4689                	li	a3,2
    80004cd2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004cd6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004cda:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004cde:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004ce2:	6794                	ld	a3,8(a5)
    80004ce4:	0026d703          	lhu	a4,2(a3)
    80004ce8:	8b1d                	andi	a4,a4,7
    80004cea:	0706                	slli	a4,a4,0x1
    80004cec:	96ba                	add	a3,a3,a4
    80004cee:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004cf2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004cf6:	6798                	ld	a4,8(a5)
    80004cf8:	00275783          	lhu	a5,2(a4)
    80004cfc:	2785                	addiw	a5,a5,1
    80004cfe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d02:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d06:	100017b7          	lui	a5,0x10001
    80004d0a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d0e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004d12:	00016917          	auipc	s2,0x16
    80004d16:	6d690913          	addi	s2,s2,1750 # 8001b3e8 <disk+0x128>
  while(b->disk == 1) {
    80004d1a:	4485                	li	s1,1
    80004d1c:	01079a63          	bne	a5,a6,80004d30 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d20:	85ca                	mv	a1,s2
    80004d22:	8552                	mv	a0,s4
    80004d24:	e4efc0ef          	jal	80001372 <sleep>
  while(b->disk == 1) {
    80004d28:	004a2783          	lw	a5,4(s4)
    80004d2c:	fe978ae3          	beq	a5,s1,80004d20 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d30:	f9042903          	lw	s2,-112(s0)
    80004d34:	00290713          	addi	a4,s2,2
    80004d38:	0712                	slli	a4,a4,0x4
    80004d3a:	00016797          	auipc	a5,0x16
    80004d3e:	58678793          	addi	a5,a5,1414 # 8001b2c0 <disk>
    80004d42:	97ba                	add	a5,a5,a4
    80004d44:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d48:	00016997          	auipc	s3,0x16
    80004d4c:	57898993          	addi	s3,s3,1400 # 8001b2c0 <disk>
    80004d50:	00491713          	slli	a4,s2,0x4
    80004d54:	0009b783          	ld	a5,0(s3)
    80004d58:	97ba                	add	a5,a5,a4
    80004d5a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d5e:	854a                	mv	a0,s2
    80004d60:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d64:	bafff0ef          	jal	80004912 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d68:	8885                	andi	s1,s1,1
    80004d6a:	f0fd                	bnez	s1,80004d50 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d6c:	00016517          	auipc	a0,0x16
    80004d70:	67c50513          	addi	a0,a0,1660 # 8001b3e8 <disk+0x128>
    80004d74:	3df000ef          	jal	80005952 <release>
}
    80004d78:	70a6                	ld	ra,104(sp)
    80004d7a:	7406                	ld	s0,96(sp)
    80004d7c:	64e6                	ld	s1,88(sp)
    80004d7e:	6946                	ld	s2,80(sp)
    80004d80:	69a6                	ld	s3,72(sp)
    80004d82:	6a06                	ld	s4,64(sp)
    80004d84:	7ae2                	ld	s5,56(sp)
    80004d86:	7b42                	ld	s6,48(sp)
    80004d88:	7ba2                	ld	s7,40(sp)
    80004d8a:	7c02                	ld	s8,32(sp)
    80004d8c:	6ce2                	ld	s9,24(sp)
    80004d8e:	6165                	addi	sp,sp,112
    80004d90:	8082                	ret

0000000080004d92 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004d92:	1101                	addi	sp,sp,-32
    80004d94:	ec06                	sd	ra,24(sp)
    80004d96:	e822                	sd	s0,16(sp)
    80004d98:	e426                	sd	s1,8(sp)
    80004d9a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004d9c:	00016497          	auipc	s1,0x16
    80004da0:	52448493          	addi	s1,s1,1316 # 8001b2c0 <disk>
    80004da4:	00016517          	auipc	a0,0x16
    80004da8:	64450513          	addi	a0,a0,1604 # 8001b3e8 <disk+0x128>
    80004dac:	30f000ef          	jal	800058ba <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004db0:	100017b7          	lui	a5,0x10001
    80004db4:	53b8                	lw	a4,96(a5)
    80004db6:	8b0d                	andi	a4,a4,3
    80004db8:	100017b7          	lui	a5,0x10001
    80004dbc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004dbe:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004dc2:	689c                	ld	a5,16(s1)
    80004dc4:	0204d703          	lhu	a4,32(s1)
    80004dc8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004dcc:	04f70663          	beq	a4,a5,80004e18 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004dd0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004dd4:	6898                	ld	a4,16(s1)
    80004dd6:	0204d783          	lhu	a5,32(s1)
    80004dda:	8b9d                	andi	a5,a5,7
    80004ddc:	078e                	slli	a5,a5,0x3
    80004dde:	97ba                	add	a5,a5,a4
    80004de0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004de2:	00278713          	addi	a4,a5,2
    80004de6:	0712                	slli	a4,a4,0x4
    80004de8:	9726                	add	a4,a4,s1
    80004dea:	01074703          	lbu	a4,16(a4)
    80004dee:	e321                	bnez	a4,80004e2e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004df0:	0789                	addi	a5,a5,2
    80004df2:	0792                	slli	a5,a5,0x4
    80004df4:	97a6                	add	a5,a5,s1
    80004df6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004df8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004dfc:	dc2fc0ef          	jal	800013be <wakeup>

    disk.used_idx += 1;
    80004e00:	0204d783          	lhu	a5,32(s1)
    80004e04:	2785                	addiw	a5,a5,1
    80004e06:	17c2                	slli	a5,a5,0x30
    80004e08:	93c1                	srli	a5,a5,0x30
    80004e0a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e0e:	6898                	ld	a4,16(s1)
    80004e10:	00275703          	lhu	a4,2(a4)
    80004e14:	faf71ee3          	bne	a4,a5,80004dd0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e18:	00016517          	auipc	a0,0x16
    80004e1c:	5d050513          	addi	a0,a0,1488 # 8001b3e8 <disk+0x128>
    80004e20:	333000ef          	jal	80005952 <release>
}
    80004e24:	60e2                	ld	ra,24(sp)
    80004e26:	6442                	ld	s0,16(sp)
    80004e28:	64a2                	ld	s1,8(sp)
    80004e2a:	6105                	addi	sp,sp,32
    80004e2c:	8082                	ret
      panic("virtio_disk_intr status");
    80004e2e:	00003517          	auipc	a0,0x3
    80004e32:	86a50513          	addi	a0,a0,-1942 # 80007698 <etext+0x698>
    80004e36:	7c8000ef          	jal	800055fe <panic>

0000000080004e3a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e3a:	1141                	addi	sp,sp,-16
    80004e3c:	e422                	sd	s0,8(sp)
    80004e3e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e40:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e44:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e48:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e4c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e50:	577d                	li	a4,-1
    80004e52:	177e                	slli	a4,a4,0x3f
    80004e54:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e56:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e5a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e5e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e62:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e66:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e6a:	000f4737          	lui	a4,0xf4
    80004e6e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e72:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e74:	14d79073          	csrw	stimecmp,a5
}
    80004e78:	6422                	ld	s0,8(sp)
    80004e7a:	0141                	addi	sp,sp,16
    80004e7c:	8082                	ret

0000000080004e7e <start>:
{
    80004e7e:	1141                	addi	sp,sp,-16
    80004e80:	e406                	sd	ra,8(sp)
    80004e82:	e022                	sd	s0,0(sp)
    80004e84:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004e86:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004e8a:	7779                	lui	a4,0xffffe
    80004e8c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb327>
    80004e90:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e92:	6705                	lui	a4,0x1
    80004e94:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e98:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e9a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e9e:	ffffb797          	auipc	a5,0xffffb
    80004ea2:	44a78793          	addi	a5,a5,1098 # 800002e8 <main>
    80004ea6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004eaa:	4781                	li	a5,0
    80004eac:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004eb0:	67c1                	lui	a5,0x10
    80004eb2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004eb4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004eb8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004ebc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004ec0:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004ec4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004ec8:	57fd                	li	a5,-1
    80004eca:	83a9                	srli	a5,a5,0xa
    80004ecc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004ed0:	47bd                	li	a5,15
    80004ed2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004ed6:	f65ff0ef          	jal	80004e3a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004eda:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004ede:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004ee0:	823e                	mv	tp,a5
  asm volatile("mret");
    80004ee2:	30200073          	mret
}
    80004ee6:	60a2                	ld	ra,8(sp)
    80004ee8:	6402                	ld	s0,0(sp)
    80004eea:	0141                	addi	sp,sp,16
    80004eec:	8082                	ret

0000000080004eee <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004eee:	7119                	addi	sp,sp,-128
    80004ef0:	fc86                	sd	ra,120(sp)
    80004ef2:	f8a2                	sd	s0,112(sp)
    80004ef4:	f4a6                	sd	s1,104(sp)
    80004ef6:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80004ef8:	06c05a63          	blez	a2,80004f6c <consolewrite+0x7e>
    80004efc:	f0ca                	sd	s2,96(sp)
    80004efe:	ecce                	sd	s3,88(sp)
    80004f00:	e8d2                	sd	s4,80(sp)
    80004f02:	e4d6                	sd	s5,72(sp)
    80004f04:	e0da                	sd	s6,64(sp)
    80004f06:	fc5e                	sd	s7,56(sp)
    80004f08:	f862                	sd	s8,48(sp)
    80004f0a:	f466                	sd	s9,40(sp)
    80004f0c:	8aaa                	mv	s5,a0
    80004f0e:	8b2e                	mv	s6,a1
    80004f10:	8a32                	mv	s4,a2
  int i = 0;
    80004f12:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80004f14:	02000c13          	li	s8,32
    80004f18:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004f1c:	5bfd                	li	s7,-1
    80004f1e:	a035                	j	80004f4a <consolewrite+0x5c>
    if(nn > n - i)
    80004f20:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004f24:	86ce                	mv	a3,s3
    80004f26:	01648633          	add	a2,s1,s6
    80004f2a:	85d6                	mv	a1,s5
    80004f2c:	f8040513          	addi	a0,s0,-128
    80004f30:	fe8fc0ef          	jal	80001718 <either_copyin>
    80004f34:	03750e63          	beq	a0,s7,80004f70 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    80004f38:	85ce                	mv	a1,s3
    80004f3a:	f8040513          	addi	a0,s0,-128
    80004f3e:	778000ef          	jal	800056b6 <uartwrite>
    i += nn;
    80004f42:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80004f46:	0144da63          	bge	s1,s4,80004f5a <consolewrite+0x6c>
    if(nn > n - i)
    80004f4a:	409a093b          	subw	s2,s4,s1
    80004f4e:	0009079b          	sext.w	a5,s2
    80004f52:	fcfc57e3          	bge	s8,a5,80004f20 <consolewrite+0x32>
    80004f56:	8966                	mv	s2,s9
    80004f58:	b7e1                	j	80004f20 <consolewrite+0x32>
    80004f5a:	7906                	ld	s2,96(sp)
    80004f5c:	69e6                	ld	s3,88(sp)
    80004f5e:	6a46                	ld	s4,80(sp)
    80004f60:	6aa6                	ld	s5,72(sp)
    80004f62:	6b06                	ld	s6,64(sp)
    80004f64:	7be2                	ld	s7,56(sp)
    80004f66:	7c42                	ld	s8,48(sp)
    80004f68:	7ca2                	ld	s9,40(sp)
    80004f6a:	a819                	j	80004f80 <consolewrite+0x92>
  int i = 0;
    80004f6c:	4481                	li	s1,0
    80004f6e:	a809                	j	80004f80 <consolewrite+0x92>
    80004f70:	7906                	ld	s2,96(sp)
    80004f72:	69e6                	ld	s3,88(sp)
    80004f74:	6a46                	ld	s4,80(sp)
    80004f76:	6aa6                	ld	s5,72(sp)
    80004f78:	6b06                	ld	s6,64(sp)
    80004f7a:	7be2                	ld	s7,56(sp)
    80004f7c:	7c42                	ld	s8,48(sp)
    80004f7e:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80004f80:	8526                	mv	a0,s1
    80004f82:	70e6                	ld	ra,120(sp)
    80004f84:	7446                	ld	s0,112(sp)
    80004f86:	74a6                	ld	s1,104(sp)
    80004f88:	6109                	addi	sp,sp,128
    80004f8a:	8082                	ret

0000000080004f8c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f8c:	711d                	addi	sp,sp,-96
    80004f8e:	ec86                	sd	ra,88(sp)
    80004f90:	e8a2                	sd	s0,80(sp)
    80004f92:	e4a6                	sd	s1,72(sp)
    80004f94:	e0ca                	sd	s2,64(sp)
    80004f96:	fc4e                	sd	s3,56(sp)
    80004f98:	f852                	sd	s4,48(sp)
    80004f9a:	f456                	sd	s5,40(sp)
    80004f9c:	f05a                	sd	s6,32(sp)
    80004f9e:	1080                	addi	s0,sp,96
    80004fa0:	8aaa                	mv	s5,a0
    80004fa2:	8a2e                	mv	s4,a1
    80004fa4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004fa6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004faa:	0001e517          	auipc	a0,0x1e
    80004fae:	45650513          	addi	a0,a0,1110 # 80023400 <cons>
    80004fb2:	109000ef          	jal	800058ba <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004fb6:	0001e497          	auipc	s1,0x1e
    80004fba:	44a48493          	addi	s1,s1,1098 # 80023400 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004fbe:	0001e917          	auipc	s2,0x1e
    80004fc2:	4da90913          	addi	s2,s2,1242 # 80023498 <cons+0x98>
  while(n > 0){
    80004fc6:	0b305d63          	blez	s3,80005080 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004fca:	0984a783          	lw	a5,152(s1)
    80004fce:	09c4a703          	lw	a4,156(s1)
    80004fd2:	0af71263          	bne	a4,a5,80005076 <consoleread+0xea>
      if(killed(myproc())){
    80004fd6:	da5fb0ef          	jal	80000d7a <myproc>
    80004fda:	dd0fc0ef          	jal	800015aa <killed>
    80004fde:	e12d                	bnez	a0,80005040 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004fe0:	85a6                	mv	a1,s1
    80004fe2:	854a                	mv	a0,s2
    80004fe4:	b8efc0ef          	jal	80001372 <sleep>
    while(cons.r == cons.w){
    80004fe8:	0984a783          	lw	a5,152(s1)
    80004fec:	09c4a703          	lw	a4,156(s1)
    80004ff0:	fef703e3          	beq	a4,a5,80004fd6 <consoleread+0x4a>
    80004ff4:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004ff6:	0001e717          	auipc	a4,0x1e
    80004ffa:	40a70713          	addi	a4,a4,1034 # 80023400 <cons>
    80004ffe:	0017869b          	addiw	a3,a5,1
    80005002:	08d72c23          	sw	a3,152(a4)
    80005006:	07f7f693          	andi	a3,a5,127
    8000500a:	9736                	add	a4,a4,a3
    8000500c:	01874703          	lbu	a4,24(a4)
    80005010:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005014:	4691                	li	a3,4
    80005016:	04db8663          	beq	s7,a3,80005062 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000501a:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000501e:	4685                	li	a3,1
    80005020:	faf40613          	addi	a2,s0,-81
    80005024:	85d2                	mv	a1,s4
    80005026:	8556                	mv	a0,s5
    80005028:	ea6fc0ef          	jal	800016ce <either_copyout>
    8000502c:	57fd                	li	a5,-1
    8000502e:	04f50863          	beq	a0,a5,8000507e <consoleread+0xf2>
      break;

    dst++;
    80005032:	0a05                	addi	s4,s4,1
    --n;
    80005034:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005036:	47a9                	li	a5,10
    80005038:	04fb8d63          	beq	s7,a5,80005092 <consoleread+0x106>
    8000503c:	6be2                	ld	s7,24(sp)
    8000503e:	b761                	j	80004fc6 <consoleread+0x3a>
        release(&cons.lock);
    80005040:	0001e517          	auipc	a0,0x1e
    80005044:	3c050513          	addi	a0,a0,960 # 80023400 <cons>
    80005048:	10b000ef          	jal	80005952 <release>
        return -1;
    8000504c:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000504e:	60e6                	ld	ra,88(sp)
    80005050:	6446                	ld	s0,80(sp)
    80005052:	64a6                	ld	s1,72(sp)
    80005054:	6906                	ld	s2,64(sp)
    80005056:	79e2                	ld	s3,56(sp)
    80005058:	7a42                	ld	s4,48(sp)
    8000505a:	7aa2                	ld	s5,40(sp)
    8000505c:	7b02                	ld	s6,32(sp)
    8000505e:	6125                	addi	sp,sp,96
    80005060:	8082                	ret
      if(n < target){
    80005062:	0009871b          	sext.w	a4,s3
    80005066:	01677a63          	bgeu	a4,s6,8000507a <consoleread+0xee>
        cons.r--;
    8000506a:	0001e717          	auipc	a4,0x1e
    8000506e:	42f72723          	sw	a5,1070(a4) # 80023498 <cons+0x98>
    80005072:	6be2                	ld	s7,24(sp)
    80005074:	a031                	j	80005080 <consoleread+0xf4>
    80005076:	ec5e                	sd	s7,24(sp)
    80005078:	bfbd                	j	80004ff6 <consoleread+0x6a>
    8000507a:	6be2                	ld	s7,24(sp)
    8000507c:	a011                	j	80005080 <consoleread+0xf4>
    8000507e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005080:	0001e517          	auipc	a0,0x1e
    80005084:	38050513          	addi	a0,a0,896 # 80023400 <cons>
    80005088:	0cb000ef          	jal	80005952 <release>
  return target - n;
    8000508c:	413b053b          	subw	a0,s6,s3
    80005090:	bf7d                	j	8000504e <consoleread+0xc2>
    80005092:	6be2                	ld	s7,24(sp)
    80005094:	b7f5                	j	80005080 <consoleread+0xf4>

0000000080005096 <consputc>:
{
    80005096:	1141                	addi	sp,sp,-16
    80005098:	e406                	sd	ra,8(sp)
    8000509a:	e022                	sd	s0,0(sp)
    8000509c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000509e:	10000793          	li	a5,256
    800050a2:	00f50863          	beq	a0,a5,800050b2 <consputc+0x1c>
    uartputc_sync(c);
    800050a6:	6a4000ef          	jal	8000574a <uartputc_sync>
}
    800050aa:	60a2                	ld	ra,8(sp)
    800050ac:	6402                	ld	s0,0(sp)
    800050ae:	0141                	addi	sp,sp,16
    800050b0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800050b2:	4521                	li	a0,8
    800050b4:	696000ef          	jal	8000574a <uartputc_sync>
    800050b8:	02000513          	li	a0,32
    800050bc:	68e000ef          	jal	8000574a <uartputc_sync>
    800050c0:	4521                	li	a0,8
    800050c2:	688000ef          	jal	8000574a <uartputc_sync>
    800050c6:	b7d5                	j	800050aa <consputc+0x14>

00000000800050c8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050c8:	1101                	addi	sp,sp,-32
    800050ca:	ec06                	sd	ra,24(sp)
    800050cc:	e822                	sd	s0,16(sp)
    800050ce:	e426                	sd	s1,8(sp)
    800050d0:	1000                	addi	s0,sp,32
    800050d2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800050d4:	0001e517          	auipc	a0,0x1e
    800050d8:	32c50513          	addi	a0,a0,812 # 80023400 <cons>
    800050dc:	7de000ef          	jal	800058ba <acquire>

  switch(c){
    800050e0:	47d5                	li	a5,21
    800050e2:	08f48f63          	beq	s1,a5,80005180 <consoleintr+0xb8>
    800050e6:	0297c563          	blt	a5,s1,80005110 <consoleintr+0x48>
    800050ea:	47a1                	li	a5,8
    800050ec:	0ef48463          	beq	s1,a5,800051d4 <consoleintr+0x10c>
    800050f0:	47c1                	li	a5,16
    800050f2:	10f49563          	bne	s1,a5,800051fc <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800050f6:	e6cfc0ef          	jal	80001762 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800050fa:	0001e517          	auipc	a0,0x1e
    800050fe:	30650513          	addi	a0,a0,774 # 80023400 <cons>
    80005102:	051000ef          	jal	80005952 <release>
}
    80005106:	60e2                	ld	ra,24(sp)
    80005108:	6442                	ld	s0,16(sp)
    8000510a:	64a2                	ld	s1,8(sp)
    8000510c:	6105                	addi	sp,sp,32
    8000510e:	8082                	ret
  switch(c){
    80005110:	07f00793          	li	a5,127
    80005114:	0cf48063          	beq	s1,a5,800051d4 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005118:	0001e717          	auipc	a4,0x1e
    8000511c:	2e870713          	addi	a4,a4,744 # 80023400 <cons>
    80005120:	0a072783          	lw	a5,160(a4)
    80005124:	09872703          	lw	a4,152(a4)
    80005128:	9f99                	subw	a5,a5,a4
    8000512a:	07f00713          	li	a4,127
    8000512e:	fcf766e3          	bltu	a4,a5,800050fa <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005132:	47b5                	li	a5,13
    80005134:	0cf48763          	beq	s1,a5,80005202 <consoleintr+0x13a>
      consputc(c);
    80005138:	8526                	mv	a0,s1
    8000513a:	f5dff0ef          	jal	80005096 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000513e:	0001e797          	auipc	a5,0x1e
    80005142:	2c278793          	addi	a5,a5,706 # 80023400 <cons>
    80005146:	0a07a683          	lw	a3,160(a5)
    8000514a:	0016871b          	addiw	a4,a3,1
    8000514e:	0007061b          	sext.w	a2,a4
    80005152:	0ae7a023          	sw	a4,160(a5)
    80005156:	07f6f693          	andi	a3,a3,127
    8000515a:	97b6                	add	a5,a5,a3
    8000515c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005160:	47a9                	li	a5,10
    80005162:	0cf48563          	beq	s1,a5,8000522c <consoleintr+0x164>
    80005166:	4791                	li	a5,4
    80005168:	0cf48263          	beq	s1,a5,8000522c <consoleintr+0x164>
    8000516c:	0001e797          	auipc	a5,0x1e
    80005170:	32c7a783          	lw	a5,812(a5) # 80023498 <cons+0x98>
    80005174:	9f1d                	subw	a4,a4,a5
    80005176:	08000793          	li	a5,128
    8000517a:	f8f710e3          	bne	a4,a5,800050fa <consoleintr+0x32>
    8000517e:	a07d                	j	8000522c <consoleintr+0x164>
    80005180:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005182:	0001e717          	auipc	a4,0x1e
    80005186:	27e70713          	addi	a4,a4,638 # 80023400 <cons>
    8000518a:	0a072783          	lw	a5,160(a4)
    8000518e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005192:	0001e497          	auipc	s1,0x1e
    80005196:	26e48493          	addi	s1,s1,622 # 80023400 <cons>
    while(cons.e != cons.w &&
    8000519a:	4929                	li	s2,10
    8000519c:	02f70863          	beq	a4,a5,800051cc <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051a0:	37fd                	addiw	a5,a5,-1
    800051a2:	07f7f713          	andi	a4,a5,127
    800051a6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800051a8:	01874703          	lbu	a4,24(a4)
    800051ac:	03270263          	beq	a4,s2,800051d0 <consoleintr+0x108>
      cons.e--;
    800051b0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800051b4:	10000513          	li	a0,256
    800051b8:	edfff0ef          	jal	80005096 <consputc>
    while(cons.e != cons.w &&
    800051bc:	0a04a783          	lw	a5,160(s1)
    800051c0:	09c4a703          	lw	a4,156(s1)
    800051c4:	fcf71ee3          	bne	a4,a5,800051a0 <consoleintr+0xd8>
    800051c8:	6902                	ld	s2,0(sp)
    800051ca:	bf05                	j	800050fa <consoleintr+0x32>
    800051cc:	6902                	ld	s2,0(sp)
    800051ce:	b735                	j	800050fa <consoleintr+0x32>
    800051d0:	6902                	ld	s2,0(sp)
    800051d2:	b725                	j	800050fa <consoleintr+0x32>
    if(cons.e != cons.w){
    800051d4:	0001e717          	auipc	a4,0x1e
    800051d8:	22c70713          	addi	a4,a4,556 # 80023400 <cons>
    800051dc:	0a072783          	lw	a5,160(a4)
    800051e0:	09c72703          	lw	a4,156(a4)
    800051e4:	f0f70be3          	beq	a4,a5,800050fa <consoleintr+0x32>
      cons.e--;
    800051e8:	37fd                	addiw	a5,a5,-1
    800051ea:	0001e717          	auipc	a4,0x1e
    800051ee:	2af72b23          	sw	a5,694(a4) # 800234a0 <cons+0xa0>
      consputc(BACKSPACE);
    800051f2:	10000513          	li	a0,256
    800051f6:	ea1ff0ef          	jal	80005096 <consputc>
    800051fa:	b701                	j	800050fa <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051fc:	ee048fe3          	beqz	s1,800050fa <consoleintr+0x32>
    80005200:	bf21                	j	80005118 <consoleintr+0x50>
      consputc(c);
    80005202:	4529                	li	a0,10
    80005204:	e93ff0ef          	jal	80005096 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005208:	0001e797          	auipc	a5,0x1e
    8000520c:	1f878793          	addi	a5,a5,504 # 80023400 <cons>
    80005210:	0a07a703          	lw	a4,160(a5)
    80005214:	0017069b          	addiw	a3,a4,1
    80005218:	0006861b          	sext.w	a2,a3
    8000521c:	0ad7a023          	sw	a3,160(a5)
    80005220:	07f77713          	andi	a4,a4,127
    80005224:	97ba                	add	a5,a5,a4
    80005226:	4729                	li	a4,10
    80005228:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000522c:	0001e797          	auipc	a5,0x1e
    80005230:	26c7a823          	sw	a2,624(a5) # 8002349c <cons+0x9c>
        wakeup(&cons.r);
    80005234:	0001e517          	auipc	a0,0x1e
    80005238:	26450513          	addi	a0,a0,612 # 80023498 <cons+0x98>
    8000523c:	982fc0ef          	jal	800013be <wakeup>
    80005240:	bd6d                	j	800050fa <consoleintr+0x32>

0000000080005242 <consoleinit>:

void
consoleinit(void)
{
    80005242:	1141                	addi	sp,sp,-16
    80005244:	e406                	sd	ra,8(sp)
    80005246:	e022                	sd	s0,0(sp)
    80005248:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000524a:	00002597          	auipc	a1,0x2
    8000524e:	46658593          	addi	a1,a1,1126 # 800076b0 <etext+0x6b0>
    80005252:	0001e517          	auipc	a0,0x1e
    80005256:	1ae50513          	addi	a0,a0,430 # 80023400 <cons>
    8000525a:	5e0000ef          	jal	8000583a <initlock>

  uartinit();
    8000525e:	400000ef          	jal	8000565e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005262:	00015797          	auipc	a5,0x15
    80005266:	00678793          	addi	a5,a5,6 # 8001a268 <devsw>
    8000526a:	00000717          	auipc	a4,0x0
    8000526e:	d2270713          	addi	a4,a4,-734 # 80004f8c <consoleread>
    80005272:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005274:	00000717          	auipc	a4,0x0
    80005278:	c7a70713          	addi	a4,a4,-902 # 80004eee <consolewrite>
    8000527c:	ef98                	sd	a4,24(a5)
}
    8000527e:	60a2                	ld	ra,8(sp)
    80005280:	6402                	ld	s0,0(sp)
    80005282:	0141                	addi	sp,sp,16
    80005284:	8082                	ret

0000000080005286 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005286:	7139                	addi	sp,sp,-64
    80005288:	fc06                	sd	ra,56(sp)
    8000528a:	f822                	sd	s0,48(sp)
    8000528c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000528e:	c219                	beqz	a2,80005294 <printint+0xe>
    80005290:	08054063          	bltz	a0,80005310 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005294:	4881                	li	a7,0
    80005296:	fc840693          	addi	a3,s0,-56

  i = 0;
    8000529a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000529c:	00002617          	auipc	a2,0x2
    800052a0:	57460613          	addi	a2,a2,1396 # 80007810 <digits>
    800052a4:	883e                	mv	a6,a5
    800052a6:	2785                	addiw	a5,a5,1
    800052a8:	02b57733          	remu	a4,a0,a1
    800052ac:	9732                	add	a4,a4,a2
    800052ae:	00074703          	lbu	a4,0(a4)
    800052b2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800052b6:	872a                	mv	a4,a0
    800052b8:	02b55533          	divu	a0,a0,a1
    800052bc:	0685                	addi	a3,a3,1
    800052be:	feb773e3          	bgeu	a4,a1,800052a4 <printint+0x1e>

  if(sign)
    800052c2:	00088a63          	beqz	a7,800052d6 <printint+0x50>
    buf[i++] = '-';
    800052c6:	1781                	addi	a5,a5,-32
    800052c8:	97a2                	add	a5,a5,s0
    800052ca:	02d00713          	li	a4,45
    800052ce:	fee78423          	sb	a4,-24(a5)
    800052d2:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800052d6:	02f05963          	blez	a5,80005308 <printint+0x82>
    800052da:	f426                	sd	s1,40(sp)
    800052dc:	f04a                	sd	s2,32(sp)
    800052de:	fc840713          	addi	a4,s0,-56
    800052e2:	00f704b3          	add	s1,a4,a5
    800052e6:	fff70913          	addi	s2,a4,-1
    800052ea:	993e                	add	s2,s2,a5
    800052ec:	37fd                	addiw	a5,a5,-1
    800052ee:	1782                	slli	a5,a5,0x20
    800052f0:	9381                	srli	a5,a5,0x20
    800052f2:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800052f6:	fff4c503          	lbu	a0,-1(s1)
    800052fa:	d9dff0ef          	jal	80005096 <consputc>
  while(--i >= 0)
    800052fe:	14fd                	addi	s1,s1,-1
    80005300:	ff249be3          	bne	s1,s2,800052f6 <printint+0x70>
    80005304:	74a2                	ld	s1,40(sp)
    80005306:	7902                	ld	s2,32(sp)
}
    80005308:	70e2                	ld	ra,56(sp)
    8000530a:	7442                	ld	s0,48(sp)
    8000530c:	6121                	addi	sp,sp,64
    8000530e:	8082                	ret
    x = -xx;
    80005310:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005314:	4885                	li	a7,1
    x = -xx;
    80005316:	b741                	j	80005296 <printint+0x10>

0000000080005318 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005318:	7131                	addi	sp,sp,-192
    8000531a:	fc86                	sd	ra,120(sp)
    8000531c:	f8a2                	sd	s0,112(sp)
    8000531e:	e8d2                	sd	s4,80(sp)
    80005320:	0100                	addi	s0,sp,128
    80005322:	8a2a                	mv	s4,a0
    80005324:	e40c                	sd	a1,8(s0)
    80005326:	e810                	sd	a2,16(s0)
    80005328:	ec14                	sd	a3,24(s0)
    8000532a:	f018                	sd	a4,32(s0)
    8000532c:	f41c                	sd	a5,40(s0)
    8000532e:	03043823          	sd	a6,48(s0)
    80005332:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80005336:	00005797          	auipc	a5,0x5
    8000533a:	e8a7a783          	lw	a5,-374(a5) # 8000a1c0 <panicking>
    8000533e:	c3a1                	beqz	a5,8000537e <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005340:	00840793          	addi	a5,s0,8
    80005344:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005348:	000a4503          	lbu	a0,0(s4)
    8000534c:	28050763          	beqz	a0,800055da <printf+0x2c2>
    80005350:	f4a6                	sd	s1,104(sp)
    80005352:	f0ca                	sd	s2,96(sp)
    80005354:	ecce                	sd	s3,88(sp)
    80005356:	e4d6                	sd	s5,72(sp)
    80005358:	e0da                	sd	s6,64(sp)
    8000535a:	f862                	sd	s8,48(sp)
    8000535c:	f466                	sd	s9,40(sp)
    8000535e:	f06a                	sd	s10,32(sp)
    80005360:	ec6e                	sd	s11,24(sp)
    80005362:	4981                	li	s3,0
    if(cx != '%'){
    80005364:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005368:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000536c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005370:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005374:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005378:	07000d93          	li	s11,112
    8000537c:	a01d                	j	800053a2 <printf+0x8a>
    acquire(&pr.lock);
    8000537e:	0001e517          	auipc	a0,0x1e
    80005382:	12a50513          	addi	a0,a0,298 # 800234a8 <pr>
    80005386:	534000ef          	jal	800058ba <acquire>
    8000538a:	bf5d                	j	80005340 <printf+0x28>
      consputc(cx);
    8000538c:	d0bff0ef          	jal	80005096 <consputc>
      continue;
    80005390:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005392:	0014899b          	addiw	s3,s1,1
    80005396:	013a07b3          	add	a5,s4,s3
    8000539a:	0007c503          	lbu	a0,0(a5)
    8000539e:	20050b63          	beqz	a0,800055b4 <printf+0x29c>
    if(cx != '%'){
    800053a2:	ff5515e3          	bne	a0,s5,8000538c <printf+0x74>
    i++;
    800053a6:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800053aa:	009a07b3          	add	a5,s4,s1
    800053ae:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800053b2:	20090b63          	beqz	s2,800055c8 <printf+0x2b0>
    800053b6:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800053ba:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800053bc:	c789                	beqz	a5,800053c6 <printf+0xae>
    800053be:	009a0733          	add	a4,s4,s1
    800053c2:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800053c6:	03690963          	beq	s2,s6,800053f8 <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800053ca:	05890363          	beq	s2,s8,80005410 <printf+0xf8>
    } else if(c0 == 'u'){
    800053ce:	0d990663          	beq	s2,s9,8000549a <printf+0x182>
    } else if(c0 == 'x'){
    800053d2:	11a90d63          	beq	s2,s10,800054ec <printf+0x1d4>
    } else if(c0 == 'p'){
    800053d6:	15b90663          	beq	s2,s11,80005522 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800053da:	06300793          	li	a5,99
    800053de:	18f90563          	beq	s2,a5,80005568 <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    800053e2:	07300793          	li	a5,115
    800053e6:	18f90b63          	beq	s2,a5,8000557c <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800053ea:	03591b63          	bne	s2,s5,80005420 <printf+0x108>
      consputc('%');
    800053ee:	02500513          	li	a0,37
    800053f2:	ca5ff0ef          	jal	80005096 <consputc>
    800053f6:	bf71                	j	80005392 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800053f8:	f8843783          	ld	a5,-120(s0)
    800053fc:	00878713          	addi	a4,a5,8
    80005400:	f8e43423          	sd	a4,-120(s0)
    80005404:	4605                	li	a2,1
    80005406:	45a9                	li	a1,10
    80005408:	4388                	lw	a0,0(a5)
    8000540a:	e7dff0ef          	jal	80005286 <printint>
    8000540e:	b751                	j	80005392 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    80005410:	01678f63          	beq	a5,s6,8000542e <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005414:	03878b63          	beq	a5,s8,8000544a <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    80005418:	09978e63          	beq	a5,s9,800054b4 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    8000541c:	0fa78563          	beq	a5,s10,80005506 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005420:	8556                	mv	a0,s5
    80005422:	c75ff0ef          	jal	80005096 <consputc>
      consputc(c0);
    80005426:	854a                	mv	a0,s2
    80005428:	c6fff0ef          	jal	80005096 <consputc>
    8000542c:	b79d                	j	80005392 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000542e:	f8843783          	ld	a5,-120(s0)
    80005432:	00878713          	addi	a4,a5,8
    80005436:	f8e43423          	sd	a4,-120(s0)
    8000543a:	4605                	li	a2,1
    8000543c:	45a9                	li	a1,10
    8000543e:	6388                	ld	a0,0(a5)
    80005440:	e47ff0ef          	jal	80005286 <printint>
      i += 1;
    80005444:	0029849b          	addiw	s1,s3,2
    80005448:	b7a9                	j	80005392 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000544a:	06400793          	li	a5,100
    8000544e:	02f68863          	beq	a3,a5,8000547e <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005452:	07500793          	li	a5,117
    80005456:	06f68d63          	beq	a3,a5,800054d0 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000545a:	07800793          	li	a5,120
    8000545e:	fcf691e3          	bne	a3,a5,80005420 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80005462:	f8843783          	ld	a5,-120(s0)
    80005466:	00878713          	addi	a4,a5,8
    8000546a:	f8e43423          	sd	a4,-120(s0)
    8000546e:	4601                	li	a2,0
    80005470:	45c1                	li	a1,16
    80005472:	6388                	ld	a0,0(a5)
    80005474:	e13ff0ef          	jal	80005286 <printint>
      i += 2;
    80005478:	0039849b          	addiw	s1,s3,3
    8000547c:	bf19                	j	80005392 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000547e:	f8843783          	ld	a5,-120(s0)
    80005482:	00878713          	addi	a4,a5,8
    80005486:	f8e43423          	sd	a4,-120(s0)
    8000548a:	4605                	li	a2,1
    8000548c:	45a9                	li	a1,10
    8000548e:	6388                	ld	a0,0(a5)
    80005490:	df7ff0ef          	jal	80005286 <printint>
      i += 2;
    80005494:	0039849b          	addiw	s1,s3,3
    80005498:	bded                	j	80005392 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    8000549a:	f8843783          	ld	a5,-120(s0)
    8000549e:	00878713          	addi	a4,a5,8
    800054a2:	f8e43423          	sd	a4,-120(s0)
    800054a6:	4601                	li	a2,0
    800054a8:	45a9                	li	a1,10
    800054aa:	0007e503          	lwu	a0,0(a5)
    800054ae:	dd9ff0ef          	jal	80005286 <printint>
    800054b2:	b5c5                	j	80005392 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800054b4:	f8843783          	ld	a5,-120(s0)
    800054b8:	00878713          	addi	a4,a5,8
    800054bc:	f8e43423          	sd	a4,-120(s0)
    800054c0:	4601                	li	a2,0
    800054c2:	45a9                	li	a1,10
    800054c4:	6388                	ld	a0,0(a5)
    800054c6:	dc1ff0ef          	jal	80005286 <printint>
      i += 1;
    800054ca:	0029849b          	addiw	s1,s3,2
    800054ce:	b5d1                	j	80005392 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800054d0:	f8843783          	ld	a5,-120(s0)
    800054d4:	00878713          	addi	a4,a5,8
    800054d8:	f8e43423          	sd	a4,-120(s0)
    800054dc:	4601                	li	a2,0
    800054de:	45a9                	li	a1,10
    800054e0:	6388                	ld	a0,0(a5)
    800054e2:	da5ff0ef          	jal	80005286 <printint>
      i += 2;
    800054e6:	0039849b          	addiw	s1,s3,3
    800054ea:	b565                	j	80005392 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800054ec:	f8843783          	ld	a5,-120(s0)
    800054f0:	00878713          	addi	a4,a5,8
    800054f4:	f8e43423          	sd	a4,-120(s0)
    800054f8:	4601                	li	a2,0
    800054fa:	45c1                	li	a1,16
    800054fc:	0007e503          	lwu	a0,0(a5)
    80005500:	d87ff0ef          	jal	80005286 <printint>
    80005504:	b579                	j	80005392 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    80005506:	f8843783          	ld	a5,-120(s0)
    8000550a:	00878713          	addi	a4,a5,8
    8000550e:	f8e43423          	sd	a4,-120(s0)
    80005512:	4601                	li	a2,0
    80005514:	45c1                	li	a1,16
    80005516:	6388                	ld	a0,0(a5)
    80005518:	d6fff0ef          	jal	80005286 <printint>
      i += 1;
    8000551c:	0029849b          	addiw	s1,s3,2
    80005520:	bd8d                	j	80005392 <printf+0x7a>
    80005522:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80005524:	f8843783          	ld	a5,-120(s0)
    80005528:	00878713          	addi	a4,a5,8
    8000552c:	f8e43423          	sd	a4,-120(s0)
    80005530:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005534:	03000513          	li	a0,48
    80005538:	b5fff0ef          	jal	80005096 <consputc>
  consputc('x');
    8000553c:	07800513          	li	a0,120
    80005540:	b57ff0ef          	jal	80005096 <consputc>
    80005544:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005546:	00002b97          	auipc	s7,0x2
    8000554a:	2cab8b93          	addi	s7,s7,714 # 80007810 <digits>
    8000554e:	03c9d793          	srli	a5,s3,0x3c
    80005552:	97de                	add	a5,a5,s7
    80005554:	0007c503          	lbu	a0,0(a5)
    80005558:	b3fff0ef          	jal	80005096 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000555c:	0992                	slli	s3,s3,0x4
    8000555e:	397d                	addiw	s2,s2,-1
    80005560:	fe0917e3          	bnez	s2,8000554e <printf+0x236>
    80005564:	7be2                	ld	s7,56(sp)
    80005566:	b535                	j	80005392 <printf+0x7a>
      consputc(va_arg(ap, uint));
    80005568:	f8843783          	ld	a5,-120(s0)
    8000556c:	00878713          	addi	a4,a5,8
    80005570:	f8e43423          	sd	a4,-120(s0)
    80005574:	4388                	lw	a0,0(a5)
    80005576:	b21ff0ef          	jal	80005096 <consputc>
    8000557a:	bd21                	j	80005392 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    8000557c:	f8843783          	ld	a5,-120(s0)
    80005580:	00878713          	addi	a4,a5,8
    80005584:	f8e43423          	sd	a4,-120(s0)
    80005588:	0007b903          	ld	s2,0(a5)
    8000558c:	00090d63          	beqz	s2,800055a6 <printf+0x28e>
      for(; *s; s++)
    80005590:	00094503          	lbu	a0,0(s2)
    80005594:	de050fe3          	beqz	a0,80005392 <printf+0x7a>
        consputc(*s);
    80005598:	affff0ef          	jal	80005096 <consputc>
      for(; *s; s++)
    8000559c:	0905                	addi	s2,s2,1
    8000559e:	00094503          	lbu	a0,0(s2)
    800055a2:	f97d                	bnez	a0,80005598 <printf+0x280>
    800055a4:	b3fd                	j	80005392 <printf+0x7a>
        s = "(null)";
    800055a6:	00002917          	auipc	s2,0x2
    800055aa:	11290913          	addi	s2,s2,274 # 800076b8 <etext+0x6b8>
      for(; *s; s++)
    800055ae:	02800513          	li	a0,40
    800055b2:	b7dd                	j	80005598 <printf+0x280>
    800055b4:	74a6                	ld	s1,104(sp)
    800055b6:	7906                	ld	s2,96(sp)
    800055b8:	69e6                	ld	s3,88(sp)
    800055ba:	6aa6                	ld	s5,72(sp)
    800055bc:	6b06                	ld	s6,64(sp)
    800055be:	7c42                	ld	s8,48(sp)
    800055c0:	7ca2                	ld	s9,40(sp)
    800055c2:	7d02                	ld	s10,32(sp)
    800055c4:	6de2                	ld	s11,24(sp)
    800055c6:	a811                	j	800055da <printf+0x2c2>
    800055c8:	74a6                	ld	s1,104(sp)
    800055ca:	7906                	ld	s2,96(sp)
    800055cc:	69e6                	ld	s3,88(sp)
    800055ce:	6aa6                	ld	s5,72(sp)
    800055d0:	6b06                	ld	s6,64(sp)
    800055d2:	7c42                	ld	s8,48(sp)
    800055d4:	7ca2                	ld	s9,40(sp)
    800055d6:	7d02                	ld	s10,32(sp)
    800055d8:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800055da:	00005797          	auipc	a5,0x5
    800055de:	be67a783          	lw	a5,-1050(a5) # 8000a1c0 <panicking>
    800055e2:	c799                	beqz	a5,800055f0 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    800055e4:	4501                	li	a0,0
    800055e6:	70e6                	ld	ra,120(sp)
    800055e8:	7446                	ld	s0,112(sp)
    800055ea:	6a46                	ld	s4,80(sp)
    800055ec:	6129                	addi	sp,sp,192
    800055ee:	8082                	ret
    release(&pr.lock);
    800055f0:	0001e517          	auipc	a0,0x1e
    800055f4:	eb850513          	addi	a0,a0,-328 # 800234a8 <pr>
    800055f8:	35a000ef          	jal	80005952 <release>
  return 0;
    800055fc:	b7e5                	j	800055e4 <printf+0x2cc>

00000000800055fe <panic>:

void
panic(char *s)
{
    800055fe:	1101                	addi	sp,sp,-32
    80005600:	ec06                	sd	ra,24(sp)
    80005602:	e822                	sd	s0,16(sp)
    80005604:	e426                	sd	s1,8(sp)
    80005606:	e04a                	sd	s2,0(sp)
    80005608:	1000                	addi	s0,sp,32
    8000560a:	84aa                	mv	s1,a0
  panicking = 1;
    8000560c:	4905                	li	s2,1
    8000560e:	00005797          	auipc	a5,0x5
    80005612:	bb27a923          	sw	s2,-1102(a5) # 8000a1c0 <panicking>
  printf("panic: ");
    80005616:	00002517          	auipc	a0,0x2
    8000561a:	0aa50513          	addi	a0,a0,170 # 800076c0 <etext+0x6c0>
    8000561e:	cfbff0ef          	jal	80005318 <printf>
  printf("%s\n", s);
    80005622:	85a6                	mv	a1,s1
    80005624:	00002517          	auipc	a0,0x2
    80005628:	0a450513          	addi	a0,a0,164 # 800076c8 <etext+0x6c8>
    8000562c:	cedff0ef          	jal	80005318 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005630:	00005797          	auipc	a5,0x5
    80005634:	b927a623          	sw	s2,-1140(a5) # 8000a1bc <panicked>
  for(;;)
    80005638:	a001                	j	80005638 <panic+0x3a>

000000008000563a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000563a:	1141                	addi	sp,sp,-16
    8000563c:	e406                	sd	ra,8(sp)
    8000563e:	e022                	sd	s0,0(sp)
    80005640:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005642:	00002597          	auipc	a1,0x2
    80005646:	08e58593          	addi	a1,a1,142 # 800076d0 <etext+0x6d0>
    8000564a:	0001e517          	auipc	a0,0x1e
    8000564e:	e5e50513          	addi	a0,a0,-418 # 800234a8 <pr>
    80005652:	1e8000ef          	jal	8000583a <initlock>
}
    80005656:	60a2                	ld	ra,8(sp)
    80005658:	6402                	ld	s0,0(sp)
    8000565a:	0141                	addi	sp,sp,16
    8000565c:	8082                	ret

000000008000565e <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    8000565e:	1141                	addi	sp,sp,-16
    80005660:	e406                	sd	ra,8(sp)
    80005662:	e022                	sd	s0,0(sp)
    80005664:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005666:	100007b7          	lui	a5,0x10000
    8000566a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000566e:	10000737          	lui	a4,0x10000
    80005672:	f8000693          	li	a3,-128
    80005676:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000567a:	468d                	li	a3,3
    8000567c:	10000637          	lui	a2,0x10000
    80005680:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005684:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005688:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000568c:	10000737          	lui	a4,0x10000
    80005690:	461d                	li	a2,7
    80005692:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005696:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    8000569a:	00002597          	auipc	a1,0x2
    8000569e:	03e58593          	addi	a1,a1,62 # 800076d8 <etext+0x6d8>
    800056a2:	0001e517          	auipc	a0,0x1e
    800056a6:	e1e50513          	addi	a0,a0,-482 # 800234c0 <tx_lock>
    800056aa:	190000ef          	jal	8000583a <initlock>
}
    800056ae:	60a2                	ld	ra,8(sp)
    800056b0:	6402                	ld	s0,0(sp)
    800056b2:	0141                	addi	sp,sp,16
    800056b4:	8082                	ret

00000000800056b6 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800056b6:	715d                	addi	sp,sp,-80
    800056b8:	e486                	sd	ra,72(sp)
    800056ba:	e0a2                	sd	s0,64(sp)
    800056bc:	fc26                	sd	s1,56(sp)
    800056be:	ec56                	sd	s5,24(sp)
    800056c0:	0880                	addi	s0,sp,80
    800056c2:	8aaa                	mv	s5,a0
    800056c4:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800056c6:	0001e517          	auipc	a0,0x1e
    800056ca:	dfa50513          	addi	a0,a0,-518 # 800234c0 <tx_lock>
    800056ce:	1ec000ef          	jal	800058ba <acquire>

  int i = 0;
  while(i < n){ 
    800056d2:	06905063          	blez	s1,80005732 <uartwrite+0x7c>
    800056d6:	f84a                	sd	s2,48(sp)
    800056d8:	f44e                	sd	s3,40(sp)
    800056da:	f052                	sd	s4,32(sp)
    800056dc:	e85a                	sd	s6,16(sp)
    800056de:	e45e                	sd	s7,8(sp)
    800056e0:	8a56                	mv	s4,s5
    800056e2:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    800056e4:	00005497          	auipc	s1,0x5
    800056e8:	ae448493          	addi	s1,s1,-1308 # 8000a1c8 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800056ec:	0001e997          	auipc	s3,0x1e
    800056f0:	dd498993          	addi	s3,s3,-556 # 800234c0 <tx_lock>
    800056f4:	00005917          	auipc	s2,0x5
    800056f8:	ad090913          	addi	s2,s2,-1328 # 8000a1c4 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    800056fc:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005700:	4b05                	li	s6,1
    80005702:	a005                	j	80005722 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005704:	85ce                	mv	a1,s3
    80005706:	854a                	mv	a0,s2
    80005708:	c6bfb0ef          	jal	80001372 <sleep>
    while(tx_busy != 0){
    8000570c:	409c                	lw	a5,0(s1)
    8000570e:	fbfd                	bnez	a5,80005704 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005710:	000a4783          	lbu	a5,0(s4)
    80005714:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005718:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    8000571c:	0a05                	addi	s4,s4,1
    8000571e:	015a0563          	beq	s4,s5,80005728 <uartwrite+0x72>
    while(tx_busy != 0){
    80005722:	409c                	lw	a5,0(s1)
    80005724:	f3e5                	bnez	a5,80005704 <uartwrite+0x4e>
    80005726:	b7ed                	j	80005710 <uartwrite+0x5a>
    80005728:	7942                	ld	s2,48(sp)
    8000572a:	79a2                	ld	s3,40(sp)
    8000572c:	7a02                	ld	s4,32(sp)
    8000572e:	6b42                	ld	s6,16(sp)
    80005730:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005732:	0001e517          	auipc	a0,0x1e
    80005736:	d8e50513          	addi	a0,a0,-626 # 800234c0 <tx_lock>
    8000573a:	218000ef          	jal	80005952 <release>
}
    8000573e:	60a6                	ld	ra,72(sp)
    80005740:	6406                	ld	s0,64(sp)
    80005742:	74e2                	ld	s1,56(sp)
    80005744:	6ae2                	ld	s5,24(sp)
    80005746:	6161                	addi	sp,sp,80
    80005748:	8082                	ret

000000008000574a <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000574a:	1101                	addi	sp,sp,-32
    8000574c:	ec06                	sd	ra,24(sp)
    8000574e:	e822                	sd	s0,16(sp)
    80005750:	e426                	sd	s1,8(sp)
    80005752:	1000                	addi	s0,sp,32
    80005754:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005756:	00005797          	auipc	a5,0x5
    8000575a:	a6a7a783          	lw	a5,-1430(a5) # 8000a1c0 <panicking>
    8000575e:	cf95                	beqz	a5,8000579a <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005760:	00005797          	auipc	a5,0x5
    80005764:	a5c7a783          	lw	a5,-1444(a5) # 8000a1bc <panicked>
    80005768:	ef85                	bnez	a5,800057a0 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000576a:	10000737          	lui	a4,0x10000
    8000576e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005770:	00074783          	lbu	a5,0(a4)
    80005774:	0207f793          	andi	a5,a5,32
    80005778:	dfe5                	beqz	a5,80005770 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000577a:	0ff4f513          	zext.b	a0,s1
    8000577e:	100007b7          	lui	a5,0x10000
    80005782:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005786:	00005797          	auipc	a5,0x5
    8000578a:	a3a7a783          	lw	a5,-1478(a5) # 8000a1c0 <panicking>
    8000578e:	cb91                	beqz	a5,800057a2 <uartputc_sync+0x58>
    pop_off();
}
    80005790:	60e2                	ld	ra,24(sp)
    80005792:	6442                	ld	s0,16(sp)
    80005794:	64a2                	ld	s1,8(sp)
    80005796:	6105                	addi	sp,sp,32
    80005798:	8082                	ret
    push_off();
    8000579a:	0e0000ef          	jal	8000587a <push_off>
    8000579e:	b7c9                	j	80005760 <uartputc_sync+0x16>
    for(;;)
    800057a0:	a001                	j	800057a0 <uartputc_sync+0x56>
    pop_off();
    800057a2:	15c000ef          	jal	800058fe <pop_off>
}
    800057a6:	b7ed                	j	80005790 <uartputc_sync+0x46>

00000000800057a8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800057a8:	1141                	addi	sp,sp,-16
    800057aa:	e422                	sd	s0,8(sp)
    800057ac:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800057ae:	100007b7          	lui	a5,0x10000
    800057b2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800057b4:	0007c783          	lbu	a5,0(a5)
    800057b8:	8b85                	andi	a5,a5,1
    800057ba:	cb81                	beqz	a5,800057ca <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800057bc:	100007b7          	lui	a5,0x10000
    800057c0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800057c4:	6422                	ld	s0,8(sp)
    800057c6:	0141                	addi	sp,sp,16
    800057c8:	8082                	ret
    return -1;
    800057ca:	557d                	li	a0,-1
    800057cc:	bfe5                	j	800057c4 <uartgetc+0x1c>

00000000800057ce <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800057ce:	1101                	addi	sp,sp,-32
    800057d0:	ec06                	sd	ra,24(sp)
    800057d2:	e822                	sd	s0,16(sp)
    800057d4:	e426                	sd	s1,8(sp)
    800057d6:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800057d8:	100007b7          	lui	a5,0x10000
    800057dc:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800057de:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    800057e2:	0001e517          	auipc	a0,0x1e
    800057e6:	cde50513          	addi	a0,a0,-802 # 800234c0 <tx_lock>
    800057ea:	0d0000ef          	jal	800058ba <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    800057ee:	100007b7          	lui	a5,0x10000
    800057f2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800057f4:	0007c783          	lbu	a5,0(a5)
    800057f8:	0207f793          	andi	a5,a5,32
    800057fc:	eb89                	bnez	a5,8000580e <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800057fe:	0001e517          	auipc	a0,0x1e
    80005802:	cc250513          	addi	a0,a0,-830 # 800234c0 <tx_lock>
    80005806:	14c000ef          	jal	80005952 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000580a:	54fd                	li	s1,-1
    8000580c:	a831                	j	80005828 <uartintr+0x5a>
    tx_busy = 0;
    8000580e:	00005797          	auipc	a5,0x5
    80005812:	9a07ad23          	sw	zero,-1606(a5) # 8000a1c8 <tx_busy>
    wakeup(&tx_chan);
    80005816:	00005517          	auipc	a0,0x5
    8000581a:	9ae50513          	addi	a0,a0,-1618 # 8000a1c4 <tx_chan>
    8000581e:	ba1fb0ef          	jal	800013be <wakeup>
    80005822:	bff1                	j	800057fe <uartintr+0x30>
      break;
    consoleintr(c);
    80005824:	8a5ff0ef          	jal	800050c8 <consoleintr>
    int c = uartgetc();
    80005828:	f81ff0ef          	jal	800057a8 <uartgetc>
    if(c == -1)
    8000582c:	fe951ce3          	bne	a0,s1,80005824 <uartintr+0x56>
  }
}
    80005830:	60e2                	ld	ra,24(sp)
    80005832:	6442                	ld	s0,16(sp)
    80005834:	64a2                	ld	s1,8(sp)
    80005836:	6105                	addi	sp,sp,32
    80005838:	8082                	ret

000000008000583a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000583a:	1141                	addi	sp,sp,-16
    8000583c:	e422                	sd	s0,8(sp)
    8000583e:	0800                	addi	s0,sp,16
  lk->name = name;
    80005840:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005842:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005846:	00053823          	sd	zero,16(a0)
}
    8000584a:	6422                	ld	s0,8(sp)
    8000584c:	0141                	addi	sp,sp,16
    8000584e:	8082                	ret

0000000080005850 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005850:	411c                	lw	a5,0(a0)
    80005852:	e399                	bnez	a5,80005858 <holding+0x8>
    80005854:	4501                	li	a0,0
  return r;
}
    80005856:	8082                	ret
{
    80005858:	1101                	addi	sp,sp,-32
    8000585a:	ec06                	sd	ra,24(sp)
    8000585c:	e822                	sd	s0,16(sp)
    8000585e:	e426                	sd	s1,8(sp)
    80005860:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005862:	6904                	ld	s1,16(a0)
    80005864:	cfafb0ef          	jal	80000d5e <mycpu>
    80005868:	40a48533          	sub	a0,s1,a0
    8000586c:	00153513          	seqz	a0,a0
}
    80005870:	60e2                	ld	ra,24(sp)
    80005872:	6442                	ld	s0,16(sp)
    80005874:	64a2                	ld	s1,8(sp)
    80005876:	6105                	addi	sp,sp,32
    80005878:	8082                	ret

000000008000587a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000587a:	1101                	addi	sp,sp,-32
    8000587c:	ec06                	sd	ra,24(sp)
    8000587e:	e822                	sd	s0,16(sp)
    80005880:	e426                	sd	s1,8(sp)
    80005882:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005884:	100024f3          	csrr	s1,sstatus
    80005888:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000588c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000588e:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005892:	cccfb0ef          	jal	80000d5e <mycpu>
    80005896:	5d3c                	lw	a5,120(a0)
    80005898:	cb99                	beqz	a5,800058ae <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000589a:	cc4fb0ef          	jal	80000d5e <mycpu>
    8000589e:	5d3c                	lw	a5,120(a0)
    800058a0:	2785                	addiw	a5,a5,1
    800058a2:	dd3c                	sw	a5,120(a0)
}
    800058a4:	60e2                	ld	ra,24(sp)
    800058a6:	6442                	ld	s0,16(sp)
    800058a8:	64a2                	ld	s1,8(sp)
    800058aa:	6105                	addi	sp,sp,32
    800058ac:	8082                	ret
    mycpu()->intena = old;
    800058ae:	cb0fb0ef          	jal	80000d5e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800058b2:	8085                	srli	s1,s1,0x1
    800058b4:	8885                	andi	s1,s1,1
    800058b6:	dd64                	sw	s1,124(a0)
    800058b8:	b7cd                	j	8000589a <push_off+0x20>

00000000800058ba <acquire>:
{
    800058ba:	1101                	addi	sp,sp,-32
    800058bc:	ec06                	sd	ra,24(sp)
    800058be:	e822                	sd	s0,16(sp)
    800058c0:	e426                	sd	s1,8(sp)
    800058c2:	1000                	addi	s0,sp,32
    800058c4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800058c6:	fb5ff0ef          	jal	8000587a <push_off>
  if(holding(lk))
    800058ca:	8526                	mv	a0,s1
    800058cc:	f85ff0ef          	jal	80005850 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058d0:	4705                	li	a4,1
  if(holding(lk))
    800058d2:	e105                	bnez	a0,800058f2 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058d4:	87ba                	mv	a5,a4
    800058d6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800058da:	2781                	sext.w	a5,a5
    800058dc:	ffe5                	bnez	a5,800058d4 <acquire+0x1a>
  __sync_synchronize();
    800058de:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800058e2:	c7cfb0ef          	jal	80000d5e <mycpu>
    800058e6:	e888                	sd	a0,16(s1)
}
    800058e8:	60e2                	ld	ra,24(sp)
    800058ea:	6442                	ld	s0,16(sp)
    800058ec:	64a2                	ld	s1,8(sp)
    800058ee:	6105                	addi	sp,sp,32
    800058f0:	8082                	ret
    panic("acquire");
    800058f2:	00002517          	auipc	a0,0x2
    800058f6:	dee50513          	addi	a0,a0,-530 # 800076e0 <etext+0x6e0>
    800058fa:	d05ff0ef          	jal	800055fe <panic>

00000000800058fe <pop_off>:

void
pop_off(void)
{
    800058fe:	1141                	addi	sp,sp,-16
    80005900:	e406                	sd	ra,8(sp)
    80005902:	e022                	sd	s0,0(sp)
    80005904:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005906:	c58fb0ef          	jal	80000d5e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000590a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000590e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005910:	e78d                	bnez	a5,8000593a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005912:	5d3c                	lw	a5,120(a0)
    80005914:	02f05963          	blez	a5,80005946 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005918:	37fd                	addiw	a5,a5,-1
    8000591a:	0007871b          	sext.w	a4,a5
    8000591e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005920:	eb09                	bnez	a4,80005932 <pop_off+0x34>
    80005922:	5d7c                	lw	a5,124(a0)
    80005924:	c799                	beqz	a5,80005932 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005926:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000592a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000592e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005932:	60a2                	ld	ra,8(sp)
    80005934:	6402                	ld	s0,0(sp)
    80005936:	0141                	addi	sp,sp,16
    80005938:	8082                	ret
    panic("pop_off - interruptible");
    8000593a:	00002517          	auipc	a0,0x2
    8000593e:	dae50513          	addi	a0,a0,-594 # 800076e8 <etext+0x6e8>
    80005942:	cbdff0ef          	jal	800055fe <panic>
    panic("pop_off");
    80005946:	00002517          	auipc	a0,0x2
    8000594a:	dba50513          	addi	a0,a0,-582 # 80007700 <etext+0x700>
    8000594e:	cb1ff0ef          	jal	800055fe <panic>

0000000080005952 <release>:
{
    80005952:	1101                	addi	sp,sp,-32
    80005954:	ec06                	sd	ra,24(sp)
    80005956:	e822                	sd	s0,16(sp)
    80005958:	e426                	sd	s1,8(sp)
    8000595a:	1000                	addi	s0,sp,32
    8000595c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000595e:	ef3ff0ef          	jal	80005850 <holding>
    80005962:	c105                	beqz	a0,80005982 <release+0x30>
  lk->cpu = 0;
    80005964:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005968:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000596c:	0310000f          	fence	rw,w
    80005970:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005974:	f8bff0ef          	jal	800058fe <pop_off>
}
    80005978:	60e2                	ld	ra,24(sp)
    8000597a:	6442                	ld	s0,16(sp)
    8000597c:	64a2                	ld	s1,8(sp)
    8000597e:	6105                	addi	sp,sp,32
    80005980:	8082                	ret
    panic("release");
    80005982:	00002517          	auipc	a0,0x2
    80005986:	d8650513          	addi	a0,a0,-634 # 80007708 <etext+0x708>
    8000598a:	c75ff0ef          	jal	800055fe <panic>
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
