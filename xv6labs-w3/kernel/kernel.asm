
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
    80000004:	33813103          	ld	sp,824(sp) # 8000a338 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000016:	689040ef          	jal	80004e9e <start>

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
    8000002c:	e3a9                	bnez	a5,8000006e <kfree+0x52>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00024797          	auipc	a5,0x24
    80000034:	85878793          	addi	a5,a5,-1960 # 80023888 <end>
    80000038:	02f56b63          	bltu	a0,a5,8000006e <kfree+0x52>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57763          	bgeu	a0,a5,8000006e <kfree+0x52>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000044:	0000a917          	auipc	s2,0xa
    80000048:	33c90913          	addi	s2,s2,828 # 8000a380 <kmem>
    8000004c:	854a                	mv	a0,s2
    8000004e:	08d050ef          	jal	800058da <acquire>
  r->next = kmem.freelist;
    80000052:	01893783          	ld	a5,24(s2)
    80000056:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000058:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000005c:	854a                	mv	a0,s2
    8000005e:	115050ef          	jal	80005972 <release>
}
    80000062:	60e2                	ld	ra,24(sp)
    80000064:	6442                	ld	s0,16(sp)
    80000066:	64a2                	ld	s1,8(sp)
    80000068:	6902                	ld	s2,0(sp)
    8000006a:	6105                	addi	sp,sp,32
    8000006c:	8082                	ret
    panic("kfree");
    8000006e:	00007517          	auipc	a0,0x7
    80000072:	f9250513          	addi	a0,a0,-110 # 80007000 <etext>
    80000076:	5a8050ef          	jal	8000561e <panic>

000000008000007a <freerange>:
{
    8000007a:	7179                	addi	sp,sp,-48
    8000007c:	f406                	sd	ra,40(sp)
    8000007e:	f022                	sd	s0,32(sp)
    80000080:	ec26                	sd	s1,24(sp)
    80000082:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000084:	6785                	lui	a5,0x1
    80000086:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000008a:	00e504b3          	add	s1,a0,a4
    8000008e:	777d                	lui	a4,0xfffff
    80000090:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000092:	94be                	add	s1,s1,a5
    80000094:	0295e263          	bltu	a1,s1,800000b8 <freerange+0x3e>
    80000098:	e84a                	sd	s2,16(sp)
    8000009a:	e44e                	sd	s3,8(sp)
    8000009c:	e052                	sd	s4,0(sp)
    8000009e:	892e                	mv	s2,a1
    kfree(p);
    800000a0:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a2:	6985                	lui	s3,0x1
    kfree(p);
    800000a4:	01448533          	add	a0,s1,s4
    800000a8:	f75ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000ac:	94ce                	add	s1,s1,s3
    800000ae:	fe997be3          	bgeu	s2,s1,800000a4 <freerange+0x2a>
    800000b2:	6942                	ld	s2,16(sp)
    800000b4:	69a2                	ld	s3,8(sp)
    800000b6:	6a02                	ld	s4,0(sp)
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6145                	addi	sp,sp,48
    800000c0:	8082                	ret

00000000800000c2 <kinit>:
{
    800000c2:	1141                	addi	sp,sp,-16
    800000c4:	e406                	sd	ra,8(sp)
    800000c6:	e022                	sd	s0,0(sp)
    800000c8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000ca:	00007597          	auipc	a1,0x7
    800000ce:	f4658593          	addi	a1,a1,-186 # 80007010 <etext+0x10>
    800000d2:	0000a517          	auipc	a0,0xa
    800000d6:	2ae50513          	addi	a0,a0,686 # 8000a380 <kmem>
    800000da:	780050ef          	jal	8000585a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000de:	45c5                	li	a1,17
    800000e0:	05ee                	slli	a1,a1,0x1b
    800000e2:	00023517          	auipc	a0,0x23
    800000e6:	7a650513          	addi	a0,a0,1958 # 80023888 <end>
    800000ea:	f91ff0ef          	jal	8000007a <freerange>
}
    800000ee:	60a2                	ld	ra,8(sp)
    800000f0:	6402                	ld	s0,0(sp)
    800000f2:	0141                	addi	sp,sp,16
    800000f4:	8082                	ret

00000000800000f6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000100:	0000a497          	auipc	s1,0xa
    80000104:	28048493          	addi	s1,s1,640 # 8000a380 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	7d0050ef          	jal	800058da <acquire>
  r = kmem.freelist;
    8000010e:	6c84                	ld	s1,24(s1)
  if(r) {
    80000110:	c491                	beqz	s1,8000011c <kalloc+0x26>
    kmem.freelist = r->next;
    80000112:	609c                	ld	a5,0(s1)
    80000114:	0000a717          	auipc	a4,0xa
    80000118:	28f73223          	sd	a5,644(a4) # 8000a398 <kmem+0x18>
  }
  release(&kmem.lock);
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	26450513          	addi	a0,a0,612 # 8000a380 <kmem>
    80000124:	04f050ef          	jal	80005972 <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000128:	8526                	mv	a0,s1
    8000012a:	60e2                	ld	ra,24(sp)
    8000012c:	6442                	ld	s0,16(sp)
    8000012e:	64a2                	ld	s1,8(sp)
    80000130:	6105                	addi	sp,sp,32
    80000132:	8082                	ret

0000000080000134 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000134:	1141                	addi	sp,sp,-16
    80000136:	e422                	sd	s0,8(sp)
    80000138:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000013a:	ca19                	beqz	a2,80000150 <memset+0x1c>
    8000013c:	87aa                	mv	a5,a0
    8000013e:	1602                	slli	a2,a2,0x20
    80000140:	9201                	srli	a2,a2,0x20
    80000142:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000146:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000014a:	0785                	addi	a5,a5,1
    8000014c:	fee79de3          	bne	a5,a4,80000146 <memset+0x12>
  }
  return dst;
}
    80000150:	6422                	ld	s0,8(sp)
    80000152:	0141                	addi	sp,sp,16
    80000154:	8082                	ret

0000000080000156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000156:	1141                	addi	sp,sp,-16
    80000158:	e422                	sd	s0,8(sp)
    8000015a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000015c:	ca05                	beqz	a2,8000018c <memcmp+0x36>
    8000015e:	fff6069b          	addiw	a3,a2,-1
    80000162:	1682                	slli	a3,a3,0x20
    80000164:	9281                	srli	a3,a3,0x20
    80000166:	0685                	addi	a3,a3,1
    80000168:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000016a:	00054783          	lbu	a5,0(a0)
    8000016e:	0005c703          	lbu	a4,0(a1)
    80000172:	00e79863          	bne	a5,a4,80000182 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000176:	0505                	addi	a0,a0,1
    80000178:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000017a:	fed518e3          	bne	a0,a3,8000016a <memcmp+0x14>
  }

  return 0;
    8000017e:	4501                	li	a0,0
    80000180:	a019                	j	80000186 <memcmp+0x30>
      return *s1 - *s2;
    80000182:	40e7853b          	subw	a0,a5,a4
}
    80000186:	6422                	ld	s0,8(sp)
    80000188:	0141                	addi	sp,sp,16
    8000018a:	8082                	ret
  return 0;
    8000018c:	4501                	li	a0,0
    8000018e:	bfe5                	j	80000186 <memcmp+0x30>

0000000080000190 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e422                	sd	s0,8(sp)
    80000194:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000196:	c205                	beqz	a2,800001b6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000198:	02a5e263          	bltu	a1,a0,800001bc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000019c:	1602                	slli	a2,a2,0x20
    8000019e:	9201                	srli	a2,a2,0x20
    800001a0:	00c587b3          	add	a5,a1,a2
{
    800001a4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001a6:	0585                	addi	a1,a1,1
    800001a8:	0705                	addi	a4,a4,1
    800001aa:	fff5c683          	lbu	a3,-1(a1)
    800001ae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001b2:	feb79ae3          	bne	a5,a1,800001a6 <memmove+0x16>

  return dst;
}
    800001b6:	6422                	ld	s0,8(sp)
    800001b8:	0141                	addi	sp,sp,16
    800001ba:	8082                	ret
  if(s < d && s + n > d){
    800001bc:	02061693          	slli	a3,a2,0x20
    800001c0:	9281                	srli	a3,a3,0x20
    800001c2:	00d58733          	add	a4,a1,a3
    800001c6:	fce57be3          	bgeu	a0,a4,8000019c <memmove+0xc>
    d += n;
    800001ca:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001cc:	fff6079b          	addiw	a5,a2,-1
    800001d0:	1782                	slli	a5,a5,0x20
    800001d2:	9381                	srli	a5,a5,0x20
    800001d4:	fff7c793          	not	a5,a5
    800001d8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001da:	177d                	addi	a4,a4,-1
    800001dc:	16fd                	addi	a3,a3,-1
    800001de:	00074603          	lbu	a2,0(a4)
    800001e2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800001e6:	fef71ae3          	bne	a4,a5,800001da <memmove+0x4a>
    800001ea:	b7f1                	j	800001b6 <memmove+0x26>

00000000800001ec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800001ec:	1141                	addi	sp,sp,-16
    800001ee:	e406                	sd	ra,8(sp)
    800001f0:	e022                	sd	s0,0(sp)
    800001f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800001f4:	f9dff0ef          	jal	80000190 <memmove>
}
    800001f8:	60a2                	ld	ra,8(sp)
    800001fa:	6402                	ld	s0,0(sp)
    800001fc:	0141                	addi	sp,sp,16
    800001fe:	8082                	ret

0000000080000200 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000200:	1141                	addi	sp,sp,-16
    80000202:	e422                	sd	s0,8(sp)
    80000204:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000206:	ce11                	beqz	a2,80000222 <strncmp+0x22>
    80000208:	00054783          	lbu	a5,0(a0)
    8000020c:	cf89                	beqz	a5,80000226 <strncmp+0x26>
    8000020e:	0005c703          	lbu	a4,0(a1)
    80000212:	00f71a63          	bne	a4,a5,80000226 <strncmp+0x26>
    n--, p++, q++;
    80000216:	367d                	addiw	a2,a2,-1
    80000218:	0505                	addi	a0,a0,1
    8000021a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000021c:	f675                	bnez	a2,80000208 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000021e:	4501                	li	a0,0
    80000220:	a801                	j	80000230 <strncmp+0x30>
    80000222:	4501                	li	a0,0
    80000224:	a031                	j	80000230 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000226:	00054503          	lbu	a0,0(a0)
    8000022a:	0005c783          	lbu	a5,0(a1)
    8000022e:	9d1d                	subw	a0,a0,a5
}
    80000230:	6422                	ld	s0,8(sp)
    80000232:	0141                	addi	sp,sp,16
    80000234:	8082                	ret

0000000080000236 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000236:	1141                	addi	sp,sp,-16
    80000238:	e422                	sd	s0,8(sp)
    8000023a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000023c:	87aa                	mv	a5,a0
    8000023e:	86b2                	mv	a3,a2
    80000240:	367d                	addiw	a2,a2,-1
    80000242:	02d05563          	blez	a3,8000026c <strncpy+0x36>
    80000246:	0785                	addi	a5,a5,1
    80000248:	0005c703          	lbu	a4,0(a1)
    8000024c:	fee78fa3          	sb	a4,-1(a5)
    80000250:	0585                	addi	a1,a1,1
    80000252:	f775                	bnez	a4,8000023e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000254:	873e                	mv	a4,a5
    80000256:	9fb5                	addw	a5,a5,a3
    80000258:	37fd                	addiw	a5,a5,-1
    8000025a:	00c05963          	blez	a2,8000026c <strncpy+0x36>
    *s++ = 0;
    8000025e:	0705                	addi	a4,a4,1
    80000260:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000264:	40e786bb          	subw	a3,a5,a4
    80000268:	fed04be3          	bgtz	a3,8000025e <strncpy+0x28>
  return os;
}
    8000026c:	6422                	ld	s0,8(sp)
    8000026e:	0141                	addi	sp,sp,16
    80000270:	8082                	ret

0000000080000272 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000272:	1141                	addi	sp,sp,-16
    80000274:	e422                	sd	s0,8(sp)
    80000276:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000278:	02c05363          	blez	a2,8000029e <safestrcpy+0x2c>
    8000027c:	fff6069b          	addiw	a3,a2,-1
    80000280:	1682                	slli	a3,a3,0x20
    80000282:	9281                	srli	a3,a3,0x20
    80000284:	96ae                	add	a3,a3,a1
    80000286:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000288:	00d58963          	beq	a1,a3,8000029a <safestrcpy+0x28>
    8000028c:	0585                	addi	a1,a1,1
    8000028e:	0785                	addi	a5,a5,1
    80000290:	fff5c703          	lbu	a4,-1(a1)
    80000294:	fee78fa3          	sb	a4,-1(a5)
    80000298:	fb65                	bnez	a4,80000288 <safestrcpy+0x16>
    ;
  *s = 0;
    8000029a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000029e:	6422                	ld	s0,8(sp)
    800002a0:	0141                	addi	sp,sp,16
    800002a2:	8082                	ret

00000000800002a4 <strlen>:

int
strlen(const char *s)
{
    800002a4:	1141                	addi	sp,sp,-16
    800002a6:	e422                	sd	s0,8(sp)
    800002a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002aa:	00054783          	lbu	a5,0(a0)
    800002ae:	cf91                	beqz	a5,800002ca <strlen+0x26>
    800002b0:	0505                	addi	a0,a0,1
    800002b2:	87aa                	mv	a5,a0
    800002b4:	86be                	mv	a3,a5
    800002b6:	0785                	addi	a5,a5,1
    800002b8:	fff7c703          	lbu	a4,-1(a5)
    800002bc:	ff65                	bnez	a4,800002b4 <strlen+0x10>
    800002be:	40a6853b          	subw	a0,a3,a0
    800002c2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret
  for(n = 0; s[n]; n++)
    800002ca:	4501                	li	a0,0
    800002cc:	bfe5                	j	800002c4 <strlen+0x20>

00000000800002ce <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e406                	sd	ra,8(sp)
    800002d2:	e022                	sd	s0,0(sp)
    800002d4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002d6:	283000ef          	jal	80000d58 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002da:	0000a717          	auipc	a4,0xa
    800002de:	07670713          	addi	a4,a4,118 # 8000a350 <started>
  if(cpuid() == 0){
    800002e2:	c51d                	beqz	a0,80000310 <main+0x42>
    while(started == 0)
    800002e4:	431c                	lw	a5,0(a4)
    800002e6:	2781                	sext.w	a5,a5
    800002e8:	dff5                	beqz	a5,800002e4 <main+0x16>
      ;
    __sync_synchronize();
    800002ea:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800002ee:	26b000ef          	jal	80000d58 <cpuid>
    800002f2:	85aa                	mv	a1,a0
    800002f4:	00007517          	auipc	a0,0x7
    800002f8:	d4450513          	addi	a0,a0,-700 # 80007038 <etext+0x38>
    800002fc:	03c050ef          	jal	80005338 <printf>
    kvminithart();    // turn on paging
    80000300:	080000ef          	jal	80000380 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000304:	5a2010ef          	jal	800018a6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000308:	5b0040ef          	jal	800048b8 <plicinithart>
  }

  scheduler();        
    8000030c:	6e1000ef          	jal	800011ec <scheduler>
    consoleinit();
    80000310:	753040ef          	jal	80005262 <consoleinit>
    printfinit();
    80000314:	346050ef          	jal	8000565a <printfinit>
    printf("\n");
    80000318:	00007517          	auipc	a0,0x7
    8000031c:	d0050513          	addi	a0,a0,-768 # 80007018 <etext+0x18>
    80000320:	018050ef          	jal	80005338 <printf>
    printf("xv6 kernel is booting\n");
    80000324:	00007517          	auipc	a0,0x7
    80000328:	cfc50513          	addi	a0,a0,-772 # 80007020 <etext+0x20>
    8000032c:	00c050ef          	jal	80005338 <printf>
    printf("\n");
    80000330:	00007517          	auipc	a0,0x7
    80000334:	ce850513          	addi	a0,a0,-792 # 80007018 <etext+0x18>
    80000338:	000050ef          	jal	80005338 <printf>
    kinit();         // physical page allocator
    8000033c:	d87ff0ef          	jal	800000c2 <kinit>
    kvminit();       // create kernel page table
    80000340:	2ca000ef          	jal	8000060a <kvminit>
    kvminithart();   // turn on paging
    80000344:	03c000ef          	jal	80000380 <kvminithart>
    procinit();      // process table
    80000348:	15b000ef          	jal	80000ca2 <procinit>
    trapinit();      // trap vectors
    8000034c:	536010ef          	jal	80001882 <trapinit>
    trapinithart();  // install kernel trap vector
    80000350:	556010ef          	jal	800018a6 <trapinithart>
    plicinit();      // set up interrupt controller
    80000354:	54a040ef          	jal	8000489e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000358:	560040ef          	jal	800048b8 <plicinithart>
    binit();         // buffer cache
    8000035c:	42b010ef          	jal	80001f86 <binit>
    iinit();         // inode table
    80000360:	1b0020ef          	jal	80002510 <iinit>
    fileinit();      // file table
    80000364:	0a2030ef          	jal	80003406 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000368:	640040ef          	jal	800049a8 <virtio_disk_init>
    userinit();      // first user process
    8000036c:	4df000ef          	jal	8000104a <userinit>
    __sync_synchronize();
    80000370:	0330000f          	fence	rw,rw
    started = 1;
    80000374:	4785                	li	a5,1
    80000376:	0000a717          	auipc	a4,0xa
    8000037a:	fcf72d23          	sw	a5,-38(a4) # 8000a350 <started>
    8000037e:	b779                	j	8000030c <main+0x3e>

0000000080000380 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000380:	1141                	addi	sp,sp,-16
    80000382:	e422                	sd	s0,8(sp)
    80000384:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000386:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000038a:	0000a797          	auipc	a5,0xa
    8000038e:	fce7b783          	ld	a5,-50(a5) # 8000a358 <kernel_pagetable>
    80000392:	83b1                	srli	a5,a5,0xc
    80000394:	577d                	li	a4,-1
    80000396:	177e                	slli	a4,a4,0x3f
    80000398:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000039a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000039e:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003a2:	6422                	ld	s0,8(sp)
    800003a4:	0141                	addi	sp,sp,16
    800003a6:	8082                	ret

00000000800003a8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003a8:	7139                	addi	sp,sp,-64
    800003aa:	fc06                	sd	ra,56(sp)
    800003ac:	f822                	sd	s0,48(sp)
    800003ae:	f426                	sd	s1,40(sp)
    800003b0:	f04a                	sd	s2,32(sp)
    800003b2:	ec4e                	sd	s3,24(sp)
    800003b4:	e852                	sd	s4,16(sp)
    800003b6:	e456                	sd	s5,8(sp)
    800003b8:	e05a                	sd	s6,0(sp)
    800003ba:	0080                	addi	s0,sp,64
    800003bc:	84aa                	mv	s1,a0
    800003be:	89ae                	mv	s3,a1
    800003c0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003c2:	57fd                	li	a5,-1
    800003c4:	83e9                	srli	a5,a5,0x1a
    800003c6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003c8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003ca:	02b7fc63          	bgeu	a5,a1,80000402 <walk+0x5a>
    panic("walk");
    800003ce:	00007517          	auipc	a0,0x7
    800003d2:	c8250513          	addi	a0,a0,-894 # 80007050 <etext+0x50>
    800003d6:	248050ef          	jal	8000561e <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003da:	060a8263          	beqz	s5,8000043e <walk+0x96>
    800003de:	d19ff0ef          	jal	800000f6 <kalloc>
    800003e2:	84aa                	mv	s1,a0
    800003e4:	c139                	beqz	a0,8000042a <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800003e6:	6605                	lui	a2,0x1
    800003e8:	4581                	li	a1,0
    800003ea:	d4bff0ef          	jal	80000134 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800003ee:	00c4d793          	srli	a5,s1,0xc
    800003f2:	07aa                	slli	a5,a5,0xa
    800003f4:	0017e793          	ori	a5,a5,1
    800003f8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800003fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb76f>
    800003fe:	036a0063          	beq	s4,s6,8000041e <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000402:	0149d933          	srl	s2,s3,s4
    80000406:	1ff97913          	andi	s2,s2,511
    8000040a:	090e                	slli	s2,s2,0x3
    8000040c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000040e:	00093483          	ld	s1,0(s2)
    80000412:	0014f793          	andi	a5,s1,1
    80000416:	d3f1                	beqz	a5,800003da <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000418:	80a9                	srli	s1,s1,0xa
    8000041a:	04b2                	slli	s1,s1,0xc
    8000041c:	b7c5                	j	800003fc <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000041e:	00c9d513          	srli	a0,s3,0xc
    80000422:	1ff57513          	andi	a0,a0,511
    80000426:	050e                	slli	a0,a0,0x3
    80000428:	9526                	add	a0,a0,s1
}
    8000042a:	70e2                	ld	ra,56(sp)
    8000042c:	7442                	ld	s0,48(sp)
    8000042e:	74a2                	ld	s1,40(sp)
    80000430:	7902                	ld	s2,32(sp)
    80000432:	69e2                	ld	s3,24(sp)
    80000434:	6a42                	ld	s4,16(sp)
    80000436:	6aa2                	ld	s5,8(sp)
    80000438:	6b02                	ld	s6,0(sp)
    8000043a:	6121                	addi	sp,sp,64
    8000043c:	8082                	ret
        return 0;
    8000043e:	4501                	li	a0,0
    80000440:	b7ed                	j	8000042a <walk+0x82>

0000000080000442 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000442:	57fd                	li	a5,-1
    80000444:	83e9                	srli	a5,a5,0x1a
    80000446:	00b7f463          	bgeu	a5,a1,8000044e <walkaddr+0xc>
    return 0;
    8000044a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000044c:	8082                	ret
{
    8000044e:	1141                	addi	sp,sp,-16
    80000450:	e406                	sd	ra,8(sp)
    80000452:	e022                	sd	s0,0(sp)
    80000454:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000456:	4601                	li	a2,0
    80000458:	f51ff0ef          	jal	800003a8 <walk>
  if(pte == 0)
    8000045c:	c105                	beqz	a0,8000047c <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000045e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000460:	0117f693          	andi	a3,a5,17
    80000464:	4745                	li	a4,17
    return 0;
    80000466:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000468:	00e68663          	beq	a3,a4,80000474 <walkaddr+0x32>
}
    8000046c:	60a2                	ld	ra,8(sp)
    8000046e:	6402                	ld	s0,0(sp)
    80000470:	0141                	addi	sp,sp,16
    80000472:	8082                	ret
  pa = PTE2PA(*pte);
    80000474:	83a9                	srli	a5,a5,0xa
    80000476:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000047a:	bfcd                	j	8000046c <walkaddr+0x2a>
    return 0;
    8000047c:	4501                	li	a0,0
    8000047e:	b7fd                	j	8000046c <walkaddr+0x2a>

0000000080000480 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000480:	715d                	addi	sp,sp,-80
    80000482:	e486                	sd	ra,72(sp)
    80000484:	e0a2                	sd	s0,64(sp)
    80000486:	fc26                	sd	s1,56(sp)
    80000488:	f84a                	sd	s2,48(sp)
    8000048a:	f44e                	sd	s3,40(sp)
    8000048c:	f052                	sd	s4,32(sp)
    8000048e:	ec56                	sd	s5,24(sp)
    80000490:	e85a                	sd	s6,16(sp)
    80000492:	e45e                	sd	s7,8(sp)
    80000494:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000496:	03459793          	slli	a5,a1,0x34
    8000049a:	e7a9                	bnez	a5,800004e4 <mappages+0x64>
    8000049c:	8aaa                	mv	s5,a0
    8000049e:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004a0:	03461793          	slli	a5,a2,0x34
    800004a4:	e7b1                	bnez	a5,800004f0 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004a6:	ca39                	beqz	a2,800004fc <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004a8:	77fd                	lui	a5,0xfffff
    800004aa:	963e                	add	a2,a2,a5
    800004ac:	00b609b3          	add	s3,a2,a1
  a = va;
    800004b0:	892e                	mv	s2,a1
    800004b2:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004b6:	6b85                	lui	s7,0x1
    800004b8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004bc:	4605                	li	a2,1
    800004be:	85ca                	mv	a1,s2
    800004c0:	8556                	mv	a0,s5
    800004c2:	ee7ff0ef          	jal	800003a8 <walk>
    800004c6:	c539                	beqz	a0,80000514 <mappages+0x94>
    if(*pte & PTE_V)
    800004c8:	611c                	ld	a5,0(a0)
    800004ca:	8b85                	andi	a5,a5,1
    800004cc:	ef95                	bnez	a5,80000508 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004ce:	80b1                	srli	s1,s1,0xc
    800004d0:	04aa                	slli	s1,s1,0xa
    800004d2:	0164e4b3          	or	s1,s1,s6
    800004d6:	0014e493          	ori	s1,s1,1
    800004da:	e104                	sd	s1,0(a0)
    if(a == last)
    800004dc:	05390863          	beq	s2,s3,8000052c <mappages+0xac>
    a += PGSIZE;
    800004e0:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800004e2:	bfd9                	j	800004b8 <mappages+0x38>
    panic("mappages: va not aligned");
    800004e4:	00007517          	auipc	a0,0x7
    800004e8:	b7450513          	addi	a0,a0,-1164 # 80007058 <etext+0x58>
    800004ec:	132050ef          	jal	8000561e <panic>
    panic("mappages: size not aligned");
    800004f0:	00007517          	auipc	a0,0x7
    800004f4:	b8850513          	addi	a0,a0,-1144 # 80007078 <etext+0x78>
    800004f8:	126050ef          	jal	8000561e <panic>
    panic("mappages: size");
    800004fc:	00007517          	auipc	a0,0x7
    80000500:	b9c50513          	addi	a0,a0,-1124 # 80007098 <etext+0x98>
    80000504:	11a050ef          	jal	8000561e <panic>
      panic("mappages: remap");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	ba050513          	addi	a0,a0,-1120 # 800070a8 <etext+0xa8>
    80000510:	10e050ef          	jal	8000561e <panic>
      return -1;
    80000514:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000516:	60a6                	ld	ra,72(sp)
    80000518:	6406                	ld	s0,64(sp)
    8000051a:	74e2                	ld	s1,56(sp)
    8000051c:	7942                	ld	s2,48(sp)
    8000051e:	79a2                	ld	s3,40(sp)
    80000520:	7a02                	ld	s4,32(sp)
    80000522:	6ae2                	ld	s5,24(sp)
    80000524:	6b42                	ld	s6,16(sp)
    80000526:	6ba2                	ld	s7,8(sp)
    80000528:	6161                	addi	sp,sp,80
    8000052a:	8082                	ret
  return 0;
    8000052c:	4501                	li	a0,0
    8000052e:	b7e5                	j	80000516 <mappages+0x96>

0000000080000530 <kvmmap>:
{
    80000530:	1141                	addi	sp,sp,-16
    80000532:	e406                	sd	ra,8(sp)
    80000534:	e022                	sd	s0,0(sp)
    80000536:	0800                	addi	s0,sp,16
    80000538:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000053a:	86b2                	mv	a3,a2
    8000053c:	863e                	mv	a2,a5
    8000053e:	f43ff0ef          	jal	80000480 <mappages>
    80000542:	e509                	bnez	a0,8000054c <kvmmap+0x1c>
}
    80000544:	60a2                	ld	ra,8(sp)
    80000546:	6402                	ld	s0,0(sp)
    80000548:	0141                	addi	sp,sp,16
    8000054a:	8082                	ret
    panic("kvmmap");
    8000054c:	00007517          	auipc	a0,0x7
    80000550:	b6c50513          	addi	a0,a0,-1172 # 800070b8 <etext+0xb8>
    80000554:	0ca050ef          	jal	8000561e <panic>

0000000080000558 <kvmmake>:
{
    80000558:	1101                	addi	sp,sp,-32
    8000055a:	ec06                	sd	ra,24(sp)
    8000055c:	e822                	sd	s0,16(sp)
    8000055e:	e426                	sd	s1,8(sp)
    80000560:	e04a                	sd	s2,0(sp)
    80000562:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000564:	b93ff0ef          	jal	800000f6 <kalloc>
    80000568:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000056a:	6605                	lui	a2,0x1
    8000056c:	4581                	li	a1,0
    8000056e:	bc7ff0ef          	jal	80000134 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000572:	4719                	li	a4,6
    80000574:	6685                	lui	a3,0x1
    80000576:	10000637          	lui	a2,0x10000
    8000057a:	100005b7          	lui	a1,0x10000
    8000057e:	8526                	mv	a0,s1
    80000580:	fb1ff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000584:	4719                	li	a4,6
    80000586:	6685                	lui	a3,0x1
    80000588:	10001637          	lui	a2,0x10001
    8000058c:	100015b7          	lui	a1,0x10001
    80000590:	8526                	mv	a0,s1
    80000592:	f9fff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80000596:	4719                	li	a4,6
    80000598:	040006b7          	lui	a3,0x4000
    8000059c:	0c000637          	lui	a2,0xc000
    800005a0:	0c0005b7          	lui	a1,0xc000
    800005a4:	8526                	mv	a0,s1
    800005a6:	f8bff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005aa:	00007917          	auipc	s2,0x7
    800005ae:	a5690913          	addi	s2,s2,-1450 # 80007000 <etext>
    800005b2:	4729                	li	a4,10
    800005b4:	80007697          	auipc	a3,0x80007
    800005b8:	a4c68693          	addi	a3,a3,-1460 # 7000 <_entry-0x7fff9000>
    800005bc:	4605                	li	a2,1
    800005be:	067e                	slli	a2,a2,0x1f
    800005c0:	85b2                	mv	a1,a2
    800005c2:	8526                	mv	a0,s1
    800005c4:	f6dff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005c8:	46c5                	li	a3,17
    800005ca:	06ee                	slli	a3,a3,0x1b
    800005cc:	4719                	li	a4,6
    800005ce:	412686b3          	sub	a3,a3,s2
    800005d2:	864a                	mv	a2,s2
    800005d4:	85ca                	mv	a1,s2
    800005d6:	8526                	mv	a0,s1
    800005d8:	f59ff0ef          	jal	80000530 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800005dc:	4729                	li	a4,10
    800005de:	6685                	lui	a3,0x1
    800005e0:	00006617          	auipc	a2,0x6
    800005e4:	a2060613          	addi	a2,a2,-1504 # 80006000 <_trampoline>
    800005e8:	040005b7          	lui	a1,0x4000
    800005ec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800005ee:	05b2                	slli	a1,a1,0xc
    800005f0:	8526                	mv	a0,s1
    800005f2:	f3fff0ef          	jal	80000530 <kvmmap>
  proc_mapstacks(kpgtbl);
    800005f6:	8526                	mv	a0,s1
    800005f8:	612000ef          	jal	80000c0a <proc_mapstacks>
}
    800005fc:	8526                	mv	a0,s1
    800005fe:	60e2                	ld	ra,24(sp)
    80000600:	6442                	ld	s0,16(sp)
    80000602:	64a2                	ld	s1,8(sp)
    80000604:	6902                	ld	s2,0(sp)
    80000606:	6105                	addi	sp,sp,32
    80000608:	8082                	ret

000000008000060a <kvminit>:
{
    8000060a:	1141                	addi	sp,sp,-16
    8000060c:	e406                	sd	ra,8(sp)
    8000060e:	e022                	sd	s0,0(sp)
    80000610:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000612:	f47ff0ef          	jal	80000558 <kvmmake>
    80000616:	0000a797          	auipc	a5,0xa
    8000061a:	d4a7b123          	sd	a0,-702(a5) # 8000a358 <kernel_pagetable>
}
    8000061e:	60a2                	ld	ra,8(sp)
    80000620:	6402                	ld	s0,0(sp)
    80000622:	0141                	addi	sp,sp,16
    80000624:	8082                	ret

0000000080000626 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000626:	1101                	addi	sp,sp,-32
    80000628:	ec06                	sd	ra,24(sp)
    8000062a:	e822                	sd	s0,16(sp)
    8000062c:	e426                	sd	s1,8(sp)
    8000062e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000630:	ac7ff0ef          	jal	800000f6 <kalloc>
    80000634:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000636:	c509                	beqz	a0,80000640 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000638:	6605                	lui	a2,0x1
    8000063a:	4581                	li	a1,0
    8000063c:	af9ff0ef          	jal	80000134 <memset>
  return pagetable;
}
    80000640:	8526                	mv	a0,s1
    80000642:	60e2                	ld	ra,24(sp)
    80000644:	6442                	ld	s0,16(sp)
    80000646:	64a2                	ld	s1,8(sp)
    80000648:	6105                	addi	sp,sp,32
    8000064a:	8082                	ret

000000008000064c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000064c:	715d                	addi	sp,sp,-80
    8000064e:	e486                	sd	ra,72(sp)
    80000650:	e0a2                	sd	s0,64(sp)
    80000652:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;

  if((va % PGSIZE) != 0)
    80000654:	03459793          	slli	a5,a1,0x34
    80000658:	e39d                	bnez	a5,8000067e <uvmunmap+0x32>
    8000065a:	f84a                	sd	s2,48(sp)
    8000065c:	f44e                	sd	s3,40(sp)
    8000065e:	f052                	sd	s4,32(sp)
    80000660:	ec56                	sd	s5,24(sp)
    80000662:	e85a                	sd	s6,16(sp)
    80000664:	e45e                	sd	s7,8(sp)
    80000666:	8a2a                	mv	s4,a0
    80000668:	892e                	mv	s2,a1
    8000066a:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000066c:	0632                	slli	a2,a2,0xc
    8000066e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
      continue;
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
      continue;
    sz = PGSIZE;
    if(PTE_FLAGS(*pte) == PTE_V)
    80000672:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000674:	6a85                	lui	s5,0x1
    80000676:	0735f463          	bgeu	a1,s3,800006de <uvmunmap+0x92>
    8000067a:	fc26                	sd	s1,56(sp)
    8000067c:	a80d                	j	800006ae <uvmunmap+0x62>
    8000067e:	fc26                	sd	s1,56(sp)
    80000680:	f84a                	sd	s2,48(sp)
    80000682:	f44e                	sd	s3,40(sp)
    80000684:	f052                	sd	s4,32(sp)
    80000686:	ec56                	sd	s5,24(sp)
    80000688:	e85a                	sd	s6,16(sp)
    8000068a:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000068c:	00007517          	auipc	a0,0x7
    80000690:	a3450513          	addi	a0,a0,-1484 # 800070c0 <etext+0xc0>
    80000694:	78b040ef          	jal	8000561e <panic>
      panic("uvmunmap: not a leaf");
    80000698:	00007517          	auipc	a0,0x7
    8000069c:	a4050513          	addi	a0,a0,-1472 # 800070d8 <etext+0xd8>
    800006a0:	77f040ef          	jal	8000561e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006a8:	9956                	add	s2,s2,s5
    800006aa:	03397963          	bgeu	s2,s3,800006dc <uvmunmap+0x90>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006ae:	4601                	li	a2,0
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8552                	mv	a0,s4
    800006b4:	cf5ff0ef          	jal	800003a8 <walk>
    800006b8:	84aa                	mv	s1,a0
    800006ba:	d57d                	beqz	a0,800006a8 <uvmunmap+0x5c>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006bc:	611c                	ld	a5,0(a0)
    800006be:	0017f713          	andi	a4,a5,1
    800006c2:	d37d                	beqz	a4,800006a8 <uvmunmap+0x5c>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006c4:	3ff7f713          	andi	a4,a5,1023
    800006c8:	fd7708e3          	beq	a4,s7,80000698 <uvmunmap+0x4c>
    if(do_free){
    800006cc:	fc0b0ce3          	beqz	s6,800006a4 <uvmunmap+0x58>
      uint64 pa = PTE2PA(*pte);
    800006d0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800006d2:	00c79513          	slli	a0,a5,0xc
    800006d6:	947ff0ef          	jal	8000001c <kfree>
    800006da:	b7e9                	j	800006a4 <uvmunmap+0x58>
    800006dc:	74e2                	ld	s1,56(sp)
    800006de:	7942                	ld	s2,48(sp)
    800006e0:	79a2                	ld	s3,40(sp)
    800006e2:	7a02                	ld	s4,32(sp)
    800006e4:	6ae2                	ld	s5,24(sp)
    800006e6:	6b42                	ld	s6,16(sp)
    800006e8:	6ba2                	ld	s7,8(sp)
  }
}
    800006ea:	60a6                	ld	ra,72(sp)
    800006ec:	6406                	ld	s0,64(sp)
    800006ee:	6161                	addi	sp,sp,80
    800006f0:	8082                	ret

00000000800006f2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800006f2:	1101                	addi	sp,sp,-32
    800006f4:	ec06                	sd	ra,24(sp)
    800006f6:	e822                	sd	s0,16(sp)
    800006f8:	e426                	sd	s1,8(sp)
    800006fa:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800006fc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800006fe:	00b67d63          	bgeu	a2,a1,80000718 <uvmdealloc+0x26>
    80000702:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000704:	6785                	lui	a5,0x1
    80000706:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000708:	00f60733          	add	a4,a2,a5
    8000070c:	76fd                	lui	a3,0xfffff
    8000070e:	8f75                	and	a4,a4,a3
    80000710:	97ae                	add	a5,a5,a1
    80000712:	8ff5                	and	a5,a5,a3
    80000714:	00f76863          	bltu	a4,a5,80000724 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000718:	8526                	mv	a0,s1
    8000071a:	60e2                	ld	ra,24(sp)
    8000071c:	6442                	ld	s0,16(sp)
    8000071e:	64a2                	ld	s1,8(sp)
    80000720:	6105                	addi	sp,sp,32
    80000722:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000724:	8f99                	sub	a5,a5,a4
    80000726:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000728:	4685                	li	a3,1
    8000072a:	0007861b          	sext.w	a2,a5
    8000072e:	85ba                	mv	a1,a4
    80000730:	f1dff0ef          	jal	8000064c <uvmunmap>
    80000734:	b7d5                	j	80000718 <uvmdealloc+0x26>

0000000080000736 <uvmalloc>:
  if(newsz < oldsz)
    80000736:	08b66b63          	bltu	a2,a1,800007cc <uvmalloc+0x96>
{
    8000073a:	7139                	addi	sp,sp,-64
    8000073c:	fc06                	sd	ra,56(sp)
    8000073e:	f822                	sd	s0,48(sp)
    80000740:	ec4e                	sd	s3,24(sp)
    80000742:	e852                	sd	s4,16(sp)
    80000744:	e456                	sd	s5,8(sp)
    80000746:	0080                	addi	s0,sp,64
    80000748:	8aaa                	mv	s5,a0
    8000074a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000074c:	6785                	lui	a5,0x1
    8000074e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000750:	95be                	add	a1,a1,a5
    80000752:	77fd                	lui	a5,0xfffff
    80000754:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    80000758:	06c9fc63          	bgeu	s3,a2,800007d0 <uvmalloc+0x9a>
    8000075c:	f426                	sd	s1,40(sp)
    8000075e:	f04a                	sd	s2,32(sp)
    80000760:	e05a                	sd	s6,0(sp)
    80000762:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000764:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000768:	98fff0ef          	jal	800000f6 <kalloc>
    8000076c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000076e:	c115                	beqz	a0,80000792 <uvmalloc+0x5c>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000770:	875a                	mv	a4,s6
    80000772:	86aa                	mv	a3,a0
    80000774:	6605                	lui	a2,0x1
    80000776:	85ca                	mv	a1,s2
    80000778:	8556                	mv	a0,s5
    8000077a:	d07ff0ef          	jal	80000480 <mappages>
    8000077e:	e915                	bnez	a0,800007b2 <uvmalloc+0x7c>
  for(a = oldsz; a < newsz; a += sz){
    80000780:	6785                	lui	a5,0x1
    80000782:	993e                	add	s2,s2,a5
    80000784:	ff4962e3          	bltu	s2,s4,80000768 <uvmalloc+0x32>
  return newsz;
    80000788:	8552                	mv	a0,s4
    8000078a:	74a2                	ld	s1,40(sp)
    8000078c:	7902                	ld	s2,32(sp)
    8000078e:	6b02                	ld	s6,0(sp)
    80000790:	a811                	j	800007a4 <uvmalloc+0x6e>
      uvmdealloc(pagetable, a, oldsz);
    80000792:	864e                	mv	a2,s3
    80000794:	85ca                	mv	a1,s2
    80000796:	8556                	mv	a0,s5
    80000798:	f5bff0ef          	jal	800006f2 <uvmdealloc>
      return 0;
    8000079c:	4501                	li	a0,0
    8000079e:	74a2                	ld	s1,40(sp)
    800007a0:	7902                	ld	s2,32(sp)
    800007a2:	6b02                	ld	s6,0(sp)
}
    800007a4:	70e2                	ld	ra,56(sp)
    800007a6:	7442                	ld	s0,48(sp)
    800007a8:	69e2                	ld	s3,24(sp)
    800007aa:	6a42                	ld	s4,16(sp)
    800007ac:	6aa2                	ld	s5,8(sp)
    800007ae:	6121                	addi	sp,sp,64
    800007b0:	8082                	ret
      kfree(mem);
    800007b2:	8526                	mv	a0,s1
    800007b4:	869ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007b8:	864e                	mv	a2,s3
    800007ba:	85ca                	mv	a1,s2
    800007bc:	8556                	mv	a0,s5
    800007be:	f35ff0ef          	jal	800006f2 <uvmdealloc>
      return 0;
    800007c2:	4501                	li	a0,0
    800007c4:	74a2                	ld	s1,40(sp)
    800007c6:	7902                	ld	s2,32(sp)
    800007c8:	6b02                	ld	s6,0(sp)
    800007ca:	bfe9                	j	800007a4 <uvmalloc+0x6e>
    return oldsz;
    800007cc:	852e                	mv	a0,a1
}
    800007ce:	8082                	ret
  return newsz;
    800007d0:	8532                	mv	a0,a2
    800007d2:	bfc9                	j	800007a4 <uvmalloc+0x6e>

00000000800007d4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800007d4:	7179                	addi	sp,sp,-48
    800007d6:	f406                	sd	ra,40(sp)
    800007d8:	f022                	sd	s0,32(sp)
    800007da:	ec26                	sd	s1,24(sp)
    800007dc:	e84a                	sd	s2,16(sp)
    800007de:	e44e                	sd	s3,8(sp)
    800007e0:	e052                	sd	s4,0(sp)
    800007e2:	1800                	addi	s0,sp,48
    800007e4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800007e6:	84aa                	mv	s1,a0
    800007e8:	6905                	lui	s2,0x1
    800007ea:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800007ec:	4985                	li	s3,1
    800007ee:	a819                	j	80000804 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800007f0:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800007f2:	00c79513          	slli	a0,a5,0xc
    800007f6:	fdfff0ef          	jal	800007d4 <freewalk>
      pagetable[i] = 0;
    800007fa:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800007fe:	04a1                	addi	s1,s1,8
    80000800:	01248f63          	beq	s1,s2,8000081e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80000804:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000806:	00f7f713          	andi	a4,a5,15
    8000080a:	ff3703e3          	beq	a4,s3,800007f0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000080e:	8b85                	andi	a5,a5,1
    80000810:	d7fd                	beqz	a5,800007fe <freewalk+0x2a>
      // backtrace();
      panic("freewalk: leaf");
    80000812:	00007517          	auipc	a0,0x7
    80000816:	8de50513          	addi	a0,a0,-1826 # 800070f0 <etext+0xf0>
    8000081a:	605040ef          	jal	8000561e <panic>
    }
  }
  kfree((void*)pagetable);
    8000081e:	8552                	mv	a0,s4
    80000820:	ffcff0ef          	jal	8000001c <kfree>
}
    80000824:	70a2                	ld	ra,40(sp)
    80000826:	7402                	ld	s0,32(sp)
    80000828:	64e2                	ld	s1,24(sp)
    8000082a:	6942                	ld	s2,16(sp)
    8000082c:	69a2                	ld	s3,8(sp)
    8000082e:	6a02                	ld	s4,0(sp)
    80000830:	6145                	addi	sp,sp,48
    80000832:	8082                	ret

0000000080000834 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000834:	1101                	addi	sp,sp,-32
    80000836:	ec06                	sd	ra,24(sp)
    80000838:	e822                	sd	s0,16(sp)
    8000083a:	e426                	sd	s1,8(sp)
    8000083c:	1000                	addi	s0,sp,32
    8000083e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000840:	e989                	bnez	a1,80000852 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000842:	8526                	mv	a0,s1
    80000844:	f91ff0ef          	jal	800007d4 <freewalk>
}
    80000848:	60e2                	ld	ra,24(sp)
    8000084a:	6442                	ld	s0,16(sp)
    8000084c:	64a2                	ld	s1,8(sp)
    8000084e:	6105                	addi	sp,sp,32
    80000850:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000852:	6785                	lui	a5,0x1
    80000854:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000856:	95be                	add	a1,a1,a5
    80000858:	4685                	li	a3,1
    8000085a:	00c5d613          	srli	a2,a1,0xc
    8000085e:	4581                	li	a1,0
    80000860:	dedff0ef          	jal	8000064c <uvmunmap>
    80000864:	bff9                	j	80000842 <uvmfree+0xe>

0000000080000866 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc = PGSIZE;

  for(i = 0; i < sz; i += szinc){
    80000866:	ce49                	beqz	a2,80000900 <uvmcopy+0x9a>
{
    80000868:	715d                	addi	sp,sp,-80
    8000086a:	e486                	sd	ra,72(sp)
    8000086c:	e0a2                	sd	s0,64(sp)
    8000086e:	fc26                	sd	s1,56(sp)
    80000870:	f84a                	sd	s2,48(sp)
    80000872:	f44e                	sd	s3,40(sp)
    80000874:	f052                	sd	s4,32(sp)
    80000876:	ec56                	sd	s5,24(sp)
    80000878:	e85a                	sd	s6,16(sp)
    8000087a:	e45e                	sd	s7,8(sp)
    8000087c:	0880                	addi	s0,sp,80
    8000087e:	8aaa                	mv	s5,a0
    80000880:	8b2e                	mv	s6,a1
    80000882:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    80000884:	4481                	li	s1,0
    80000886:	a029                	j	80000890 <uvmcopy+0x2a>
    80000888:	6785                	lui	a5,0x1
    8000088a:	94be                	add	s1,s1,a5
    8000088c:	0544fe63          	bgeu	s1,s4,800008e8 <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    80000890:	4601                	li	a2,0
    80000892:	85a6                	mv	a1,s1
    80000894:	8556                	mv	a0,s5
    80000896:	b13ff0ef          	jal	800003a8 <walk>
    8000089a:	d57d                	beqz	a0,80000888 <uvmcopy+0x22>
      continue;
    if((*pte & PTE_V) == 0) {
    8000089c:	6118                	ld	a4,0(a0)
    8000089e:	00177793          	andi	a5,a4,1
    800008a2:	d3fd                	beqz	a5,80000888 <uvmcopy+0x22>
      continue;
    }
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    800008a4:	00a75593          	srli	a1,a4,0xa
    800008a8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800008ac:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    800008b0:	847ff0ef          	jal	800000f6 <kalloc>
    800008b4:	89aa                	mv	s3,a0
    800008b6:	c105                	beqz	a0,800008d6 <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008b8:	6605                	lui	a2,0x1
    800008ba:	85de                	mv	a1,s7
    800008bc:	8d5ff0ef          	jal	80000190 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008c0:	874a                	mv	a4,s2
    800008c2:	86ce                	mv	a3,s3
    800008c4:	6605                	lui	a2,0x1
    800008c6:	85a6                	mv	a1,s1
    800008c8:	855a                	mv	a0,s6
    800008ca:	bb7ff0ef          	jal	80000480 <mappages>
    800008ce:	dd4d                	beqz	a0,80000888 <uvmcopy+0x22>
      kfree(mem);
    800008d0:	854e                	mv	a0,s3
    800008d2:	f4aff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800008d6:	4685                	li	a3,1
    800008d8:	00c4d613          	srli	a2,s1,0xc
    800008dc:	4581                	li	a1,0
    800008de:	855a                	mv	a0,s6
    800008e0:	d6dff0ef          	jal	8000064c <uvmunmap>
  return -1;
    800008e4:	557d                	li	a0,-1
    800008e6:	a011                	j	800008ea <uvmcopy+0x84>
  return 0;
    800008e8:	4501                	li	a0,0
}
    800008ea:	60a6                	ld	ra,72(sp)
    800008ec:	6406                	ld	s0,64(sp)
    800008ee:	74e2                	ld	s1,56(sp)
    800008f0:	7942                	ld	s2,48(sp)
    800008f2:	79a2                	ld	s3,40(sp)
    800008f4:	7a02                	ld	s4,32(sp)
    800008f6:	6ae2                	ld	s5,24(sp)
    800008f8:	6b42                	ld	s6,16(sp)
    800008fa:	6ba2                	ld	s7,8(sp)
    800008fc:	6161                	addi	sp,sp,80
    800008fe:	8082                	ret
  return 0;
    80000900:	4501                	li	a0,0
}
    80000902:	8082                	ret

0000000080000904 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000904:	1141                	addi	sp,sp,-16
    80000906:	e406                	sd	ra,8(sp)
    80000908:	e022                	sd	s0,0(sp)
    8000090a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000090c:	4601                	li	a2,0
    8000090e:	a9bff0ef          	jal	800003a8 <walk>
  if(pte == 0)
    80000912:	c901                	beqz	a0,80000922 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000914:	611c                	ld	a5,0(a0)
    80000916:	9bbd                	andi	a5,a5,-17
    80000918:	e11c                	sd	a5,0(a0)
}
    8000091a:	60a2                	ld	ra,8(sp)
    8000091c:	6402                	ld	s0,0(sp)
    8000091e:	0141                	addi	sp,sp,16
    80000920:	8082                	ret
    panic("uvmclear");
    80000922:	00006517          	auipc	a0,0x6
    80000926:	7de50513          	addi	a0,a0,2014 # 80007100 <etext+0x100>
    8000092a:	4f5040ef          	jal	8000561e <panic>

000000008000092e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000092e:	c6dd                	beqz	a3,800009dc <copyinstr+0xae>
{
    80000930:	715d                	addi	sp,sp,-80
    80000932:	e486                	sd	ra,72(sp)
    80000934:	e0a2                	sd	s0,64(sp)
    80000936:	fc26                	sd	s1,56(sp)
    80000938:	f84a                	sd	s2,48(sp)
    8000093a:	f44e                	sd	s3,40(sp)
    8000093c:	f052                	sd	s4,32(sp)
    8000093e:	ec56                	sd	s5,24(sp)
    80000940:	e85a                	sd	s6,16(sp)
    80000942:	e45e                	sd	s7,8(sp)
    80000944:	0880                	addi	s0,sp,80
    80000946:	8a2a                	mv	s4,a0
    80000948:	8b2e                	mv	s6,a1
    8000094a:	8bb2                	mv	s7,a2
    8000094c:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    8000094e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000950:	6985                	lui	s3,0x1
    80000952:	a825                	j	8000098a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000954:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000958:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000095a:	37fd                	addiw	a5,a5,-1
    8000095c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000960:	60a6                	ld	ra,72(sp)
    80000962:	6406                	ld	s0,64(sp)
    80000964:	74e2                	ld	s1,56(sp)
    80000966:	7942                	ld	s2,48(sp)
    80000968:	79a2                	ld	s3,40(sp)
    8000096a:	7a02                	ld	s4,32(sp)
    8000096c:	6ae2                	ld	s5,24(sp)
    8000096e:	6b42                	ld	s6,16(sp)
    80000970:	6ba2                	ld	s7,8(sp)
    80000972:	6161                	addi	sp,sp,80
    80000974:	8082                	ret
    80000976:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    8000097a:	9742                	add	a4,a4,a6
      --max;
    8000097c:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000980:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000984:	04e58463          	beq	a1,a4,800009cc <copyinstr+0x9e>
{
    80000988:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000098a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000098e:	85a6                	mv	a1,s1
    80000990:	8552                	mv	a0,s4
    80000992:	ab1ff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0)
    80000996:	cd0d                	beqz	a0,800009d0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000998:	417486b3          	sub	a3,s1,s7
    8000099c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000099e:	00d97363          	bgeu	s2,a3,800009a4 <copyinstr+0x76>
    800009a2:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800009a4:	955e                	add	a0,a0,s7
    800009a6:	8d05                	sub	a0,a0,s1
    while(n > 0){
    800009a8:	c695                	beqz	a3,800009d4 <copyinstr+0xa6>
    800009aa:	87da                	mv	a5,s6
    800009ac:	885a                	mv	a6,s6
      if(*p == '\0'){
    800009ae:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800009b2:	96da                	add	a3,a3,s6
    800009b4:	85be                	mv	a1,a5
      if(*p == '\0'){
    800009b6:	00f60733          	add	a4,a2,a5
    800009ba:	00074703          	lbu	a4,0(a4)
    800009be:	db59                	beqz	a4,80000954 <copyinstr+0x26>
        *dst = *p;
    800009c0:	00e78023          	sb	a4,0(a5)
      dst++;
    800009c4:	0785                	addi	a5,a5,1
    while(n > 0){
    800009c6:	fed797e3          	bne	a5,a3,800009b4 <copyinstr+0x86>
    800009ca:	b775                	j	80000976 <copyinstr+0x48>
    800009cc:	4781                	li	a5,0
    800009ce:	b771                	j	8000095a <copyinstr+0x2c>
      return -1;
    800009d0:	557d                	li	a0,-1
    800009d2:	b779                	j	80000960 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800009d4:	6b85                	lui	s7,0x1
    800009d6:	9ba6                	add	s7,s7,s1
    800009d8:	87da                	mv	a5,s6
    800009da:	b77d                	j	80000988 <copyinstr+0x5a>
  int got_null = 0;
    800009dc:	4781                	li	a5,0
  if(got_null){
    800009de:	37fd                	addiw	a5,a5,-1
    800009e0:	0007851b          	sext.w	a0,a5
}
    800009e4:	8082                	ret

00000000800009e6 <ismapped>:
  }
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va) {
    800009e6:	1141                	addi	sp,sp,-16
    800009e8:	e406                	sd	ra,8(sp)
    800009ea:	e022                	sd	s0,0(sp)
    800009ec:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800009ee:	4601                	li	a2,0
    800009f0:	9b9ff0ef          	jal	800003a8 <walk>
  if (pte == 0) {
    800009f4:	c519                	beqz	a0,80000a02 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    800009f6:	6108                	ld	a0,0(a0)
    800009f8:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800009fa:	60a2                	ld	ra,8(sp)
    800009fc:	6402                	ld	s0,0(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return 0;
    80000a02:	4501                	li	a0,0
    80000a04:	bfdd                	j	800009fa <ismapped+0x14>

0000000080000a06 <vmfault>:
{
    80000a06:	7179                	addi	sp,sp,-48
    80000a08:	f406                	sd	ra,40(sp)
    80000a0a:	f022                	sd	s0,32(sp)
    80000a0c:	ec26                	sd	s1,24(sp)
    80000a0e:	e44e                	sd	s3,8(sp)
    80000a10:	1800                	addi	s0,sp,48
    80000a12:	89aa                	mv	s3,a0
    80000a14:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80000a16:	36e000ef          	jal	80000d84 <myproc>
  if (va >= p->sz)
    80000a1a:	653c                	ld	a5,72(a0)
    80000a1c:	00f4ea63          	bltu	s1,a5,80000a30 <vmfault+0x2a>
    return 0;
    80000a20:	4981                	li	s3,0
}
    80000a22:	854e                	mv	a0,s3
    80000a24:	70a2                	ld	ra,40(sp)
    80000a26:	7402                	ld	s0,32(sp)
    80000a28:	64e2                	ld	s1,24(sp)
    80000a2a:	69a2                	ld	s3,8(sp)
    80000a2c:	6145                	addi	sp,sp,48
    80000a2e:	8082                	ret
    80000a30:	e84a                	sd	s2,16(sp)
    80000a32:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80000a34:	77fd                	lui	a5,0xfffff
    80000a36:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    80000a38:	85a6                	mv	a1,s1
    80000a3a:	854e                	mv	a0,s3
    80000a3c:	fabff0ef          	jal	800009e6 <ismapped>
    return 0;
    80000a40:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a42:	c119                	beqz	a0,80000a48 <vmfault+0x42>
    80000a44:	6942                	ld	s2,16(sp)
    80000a46:	bff1                	j	80000a22 <vmfault+0x1c>
    80000a48:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    80000a4a:	eacff0ef          	jal	800000f6 <kalloc>
    80000a4e:	8a2a                	mv	s4,a0
  if(mem == 0)
    80000a50:	c90d                	beqz	a0,80000a82 <vmfault+0x7c>
  mem = (uint64) kalloc();
    80000a52:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	4581                	li	a1,0
    80000a58:	edcff0ef          	jal	80000134 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a5c:	4759                	li	a4,22
    80000a5e:	86d2                	mv	a3,s4
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85a6                	mv	a1,s1
    80000a64:	05093503          	ld	a0,80(s2)
    80000a68:	a19ff0ef          	jal	80000480 <mappages>
    80000a6c:	e501                	bnez	a0,80000a74 <vmfault+0x6e>
    80000a6e:	6942                	ld	s2,16(sp)
    80000a70:	6a02                	ld	s4,0(sp)
    80000a72:	bf45                	j	80000a22 <vmfault+0x1c>
    kfree((void *)mem);
    80000a74:	8552                	mv	a0,s4
    80000a76:	da6ff0ef          	jal	8000001c <kfree>
    return 0;
    80000a7a:	4981                	li	s3,0
    80000a7c:	6942                	ld	s2,16(sp)
    80000a7e:	6a02                	ld	s4,0(sp)
    80000a80:	b74d                	j	80000a22 <vmfault+0x1c>
    80000a82:	6942                	ld	s2,16(sp)
    80000a84:	6a02                	ld	s4,0(sp)
    80000a86:	bf71                	j	80000a22 <vmfault+0x1c>

0000000080000a88 <copyout>:
  while(len > 0){
    80000a88:	c2d5                	beqz	a3,80000b2c <copyout+0xa4>
{
    80000a8a:	711d                	addi	sp,sp,-96
    80000a8c:	ec86                	sd	ra,88(sp)
    80000a8e:	e8a2                	sd	s0,80(sp)
    80000a90:	e4a6                	sd	s1,72(sp)
    80000a92:	f852                	sd	s4,48(sp)
    80000a94:	f456                	sd	s5,40(sp)
    80000a96:	f05a                	sd	s6,32(sp)
    80000a98:	ec5e                	sd	s7,24(sp)
    80000a9a:	1080                	addi	s0,sp,96
    80000a9c:	8baa                	mv	s7,a0
    80000a9e:	8aae                	mv	s5,a1
    80000aa0:	8b32                	mv	s6,a2
    80000aa2:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000aa4:	74fd                	lui	s1,0xfffff
    80000aa6:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000aa8:	57fd                	li	a5,-1
    80000aaa:	83e9                	srli	a5,a5,0x1a
    80000aac:	0897e263          	bltu	a5,s1,80000b30 <copyout+0xa8>
    80000ab0:	e0ca                	sd	s2,64(sp)
    80000ab2:	fc4e                	sd	s3,56(sp)
    80000ab4:	e862                	sd	s8,16(sp)
    80000ab6:	e466                	sd	s9,8(sp)
    80000ab8:	e06a                	sd	s10,0(sp)
    80000aba:	6c85                	lui	s9,0x1
    80000abc:	8c3e                	mv	s8,a5
    80000abe:	a015                	j	80000ae2 <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ac0:	409a8533          	sub	a0,s5,s1
    80000ac4:	0009861b          	sext.w	a2,s3
    80000ac8:	85da                	mv	a1,s6
    80000aca:	954a                	add	a0,a0,s2
    80000acc:	ec4ff0ef          	jal	80000190 <memmove>
    len -= n;
    80000ad0:	413a0a33          	sub	s4,s4,s3
    src += n;
    80000ad4:	9b4e                	add	s6,s6,s3
  while(len > 0){
    80000ad6:	040a0463          	beqz	s4,80000b1e <copyout+0x96>
    if (va0 >= MAXVA)
    80000ada:	05ac6d63          	bltu	s8,s10,80000b34 <copyout+0xac>
    80000ade:	84ea                	mv	s1,s10
    80000ae0:	8aea                	mv	s5,s10
    pa0 = walkaddr(pagetable, va0);
    80000ae2:	85a6                	mv	a1,s1
    80000ae4:	855e                	mv	a0,s7
    80000ae6:	95dff0ef          	jal	80000442 <walkaddr>
    80000aea:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80000aec:	e901                	bnez	a0,80000afc <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000aee:	4601                	li	a2,0
    80000af0:	85a6                	mv	a1,s1
    80000af2:	855e                	mv	a0,s7
    80000af4:	f13ff0ef          	jal	80000a06 <vmfault>
    80000af8:	892a                	mv	s2,a0
    80000afa:	c521                	beqz	a0,80000b42 <copyout+0xba>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000afc:	4601                	li	a2,0
    80000afe:	85a6                	mv	a1,s1
    80000b00:	855e                	mv	a0,s7
    80000b02:	8a7ff0ef          	jal	800003a8 <walk>
    80000b06:	c529                	beqz	a0,80000b50 <copyout+0xc8>
    if((*pte & PTE_W) == 0)
    80000b08:	611c                	ld	a5,0(a0)
    80000b0a:	8b91                	andi	a5,a5,4
    80000b0c:	c3ad                	beqz	a5,80000b6e <copyout+0xe6>
    n = PGSIZE - (dstva - va0);
    80000b0e:	01948d33          	add	s10,s1,s9
    80000b12:	415d09b3          	sub	s3,s10,s5
    if(n > len)
    80000b16:	fb3a75e3          	bgeu	s4,s3,80000ac0 <copyout+0x38>
    80000b1a:	89d2                	mv	s3,s4
    80000b1c:	b755                	j	80000ac0 <copyout+0x38>
  return 0;
    80000b1e:	4501                	li	a0,0
    80000b20:	6906                	ld	s2,64(sp)
    80000b22:	79e2                	ld	s3,56(sp)
    80000b24:	6c42                	ld	s8,16(sp)
    80000b26:	6ca2                	ld	s9,8(sp)
    80000b28:	6d02                	ld	s10,0(sp)
    80000b2a:	a80d                	j	80000b5c <copyout+0xd4>
    80000b2c:	4501                	li	a0,0
}
    80000b2e:	8082                	ret
      return -1;
    80000b30:	557d                	li	a0,-1
    80000b32:	a02d                	j	80000b5c <copyout+0xd4>
    80000b34:	557d                	li	a0,-1
    80000b36:	6906                	ld	s2,64(sp)
    80000b38:	79e2                	ld	s3,56(sp)
    80000b3a:	6c42                	ld	s8,16(sp)
    80000b3c:	6ca2                	ld	s9,8(sp)
    80000b3e:	6d02                	ld	s10,0(sp)
    80000b40:	a831                	j	80000b5c <copyout+0xd4>
        return -1;
    80000b42:	557d                	li	a0,-1
    80000b44:	6906                	ld	s2,64(sp)
    80000b46:	79e2                	ld	s3,56(sp)
    80000b48:	6c42                	ld	s8,16(sp)
    80000b4a:	6ca2                	ld	s9,8(sp)
    80000b4c:	6d02                	ld	s10,0(sp)
    80000b4e:	a039                	j	80000b5c <copyout+0xd4>
      return -1;
    80000b50:	557d                	li	a0,-1
    80000b52:	6906                	ld	s2,64(sp)
    80000b54:	79e2                	ld	s3,56(sp)
    80000b56:	6c42                	ld	s8,16(sp)
    80000b58:	6ca2                	ld	s9,8(sp)
    80000b5a:	6d02                	ld	s10,0(sp)
}
    80000b5c:	60e6                	ld	ra,88(sp)
    80000b5e:	6446                	ld	s0,80(sp)
    80000b60:	64a6                	ld	s1,72(sp)
    80000b62:	7a42                	ld	s4,48(sp)
    80000b64:	7aa2                	ld	s5,40(sp)
    80000b66:	7b02                	ld	s6,32(sp)
    80000b68:	6be2                	ld	s7,24(sp)
    80000b6a:	6125                	addi	sp,sp,96
    80000b6c:	8082                	ret
      return -1;
    80000b6e:	557d                	li	a0,-1
    80000b70:	6906                	ld	s2,64(sp)
    80000b72:	79e2                	ld	s3,56(sp)
    80000b74:	6c42                	ld	s8,16(sp)
    80000b76:	6ca2                	ld	s9,8(sp)
    80000b78:	6d02                	ld	s10,0(sp)
    80000b7a:	b7cd                	j	80000b5c <copyout+0xd4>

0000000080000b7c <copyin>:
  while(len > 0){
    80000b7c:	c6c9                	beqz	a3,80000c06 <copyin+0x8a>
{
    80000b7e:	715d                	addi	sp,sp,-80
    80000b80:	e486                	sd	ra,72(sp)
    80000b82:	e0a2                	sd	s0,64(sp)
    80000b84:	fc26                	sd	s1,56(sp)
    80000b86:	f84a                	sd	s2,48(sp)
    80000b88:	f44e                	sd	s3,40(sp)
    80000b8a:	f052                	sd	s4,32(sp)
    80000b8c:	ec56                	sd	s5,24(sp)
    80000b8e:	e85a                	sd	s6,16(sp)
    80000b90:	e45e                	sd	s7,8(sp)
    80000b92:	e062                	sd	s8,0(sp)
    80000b94:	0880                	addi	s0,sp,80
    80000b96:	8baa                	mv	s7,a0
    80000b98:	8aae                	mv	s5,a1
    80000b9a:	8932                	mv	s2,a2
    80000b9c:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000b9e:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000ba0:	6b05                	lui	s6,0x1
    80000ba2:	a035                	j	80000bce <copyin+0x52>
    80000ba4:	412984b3          	sub	s1,s3,s2
    80000ba8:	94da                	add	s1,s1,s6
    if(n > len)
    80000baa:	009a7363          	bgeu	s4,s1,80000bb0 <copyin+0x34>
    80000bae:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb0:	413905b3          	sub	a1,s2,s3
    80000bb4:	0004861b          	sext.w	a2,s1
    80000bb8:	95aa                	add	a1,a1,a0
    80000bba:	8556                	mv	a0,s5
    80000bbc:	dd4ff0ef          	jal	80000190 <memmove>
    len -= n;
    80000bc0:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000bc4:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000bc6:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000bca:	020a0163          	beqz	s4,80000bec <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000bce:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000bd2:	85ce                	mv	a1,s3
    80000bd4:	855e                	mv	a0,s7
    80000bd6:	86dff0ef          	jal	80000442 <walkaddr>
    if(pa0 == 0) {
    80000bda:	f569                	bnez	a0,80000ba4 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000bdc:	4601                	li	a2,0
    80000bde:	85ce                	mv	a1,s3
    80000be0:	855e                	mv	a0,s7
    80000be2:	e25ff0ef          	jal	80000a06 <vmfault>
    80000be6:	fd5d                	bnez	a0,80000ba4 <copyin+0x28>
        return -1;
    80000be8:	557d                	li	a0,-1
    80000bea:	a011                	j	80000bee <copyin+0x72>
  return 0;
    80000bec:	4501                	li	a0,0
}
    80000bee:	60a6                	ld	ra,72(sp)
    80000bf0:	6406                	ld	s0,64(sp)
    80000bf2:	74e2                	ld	s1,56(sp)
    80000bf4:	7942                	ld	s2,48(sp)
    80000bf6:	79a2                	ld	s3,40(sp)
    80000bf8:	7a02                	ld	s4,32(sp)
    80000bfa:	6ae2                	ld	s5,24(sp)
    80000bfc:	6b42                	ld	s6,16(sp)
    80000bfe:	6ba2                	ld	s7,8(sp)
    80000c00:	6c02                	ld	s8,0(sp)
    80000c02:	6161                	addi	sp,sp,80
    80000c04:	8082                	ret
  return 0;
    80000c06:	4501                	li	a0,0
}
    80000c08:	8082                	ret

0000000080000c0a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c0a:	7139                	addi	sp,sp,-64
    80000c0c:	fc06                	sd	ra,56(sp)
    80000c0e:	f822                	sd	s0,48(sp)
    80000c10:	f426                	sd	s1,40(sp)
    80000c12:	f04a                	sd	s2,32(sp)
    80000c14:	ec4e                	sd	s3,24(sp)
    80000c16:	e852                	sd	s4,16(sp)
    80000c18:	e456                	sd	s5,8(sp)
    80000c1a:	e05a                	sd	s6,0(sp)
    80000c1c:	0080                	addi	s0,sp,64
    80000c1e:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c20:	0000a497          	auipc	s1,0xa
    80000c24:	bb048493          	addi	s1,s1,-1104 # 8000a7d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c28:	8b26                	mv	s6,s1
    80000c2a:	ff4df937          	lui	s2,0xff4df
    80000c2e:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb135>
    80000c32:	0936                	slli	s2,s2,0xd
    80000c34:	6f590913          	addi	s2,s2,1781
    80000c38:	0936                	slli	s2,s2,0xd
    80000c3a:	bd390913          	addi	s2,s2,-1069
    80000c3e:	0932                	slli	s2,s2,0xc
    80000c40:	7a790913          	addi	s2,s2,1959
    80000c44:	040009b7          	lui	s3,0x4000
    80000c48:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c4a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4c:	0000fa97          	auipc	s5,0xf
    80000c50:	784a8a93          	addi	s5,s5,1924 # 800103d0 <tickslock>
    char *pa = kalloc();
    80000c54:	ca2ff0ef          	jal	800000f6 <kalloc>
    80000c58:	862a                	mv	a2,a0
    if(pa == 0)
    80000c5a:	cd15                	beqz	a0,80000c96 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c5c:	416485b3          	sub	a1,s1,s6
    80000c60:	8591                	srai	a1,a1,0x4
    80000c62:	032585b3          	mul	a1,a1,s2
    80000c66:	2585                	addiw	a1,a1,1
    80000c68:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c6c:	4719                	li	a4,6
    80000c6e:	6685                	lui	a3,0x1
    80000c70:	40b985b3          	sub	a1,s3,a1
    80000c74:	8552                	mv	a0,s4
    80000c76:	8bbff0ef          	jal	80000530 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c7a:	17048493          	addi	s1,s1,368
    80000c7e:	fd549be3          	bne	s1,s5,80000c54 <proc_mapstacks+0x4a>
  }
}
    80000c82:	70e2                	ld	ra,56(sp)
    80000c84:	7442                	ld	s0,48(sp)
    80000c86:	74a2                	ld	s1,40(sp)
    80000c88:	7902                	ld	s2,32(sp)
    80000c8a:	69e2                	ld	s3,24(sp)
    80000c8c:	6a42                	ld	s4,16(sp)
    80000c8e:	6aa2                	ld	s5,8(sp)
    80000c90:	6b02                	ld	s6,0(sp)
    80000c92:	6121                	addi	sp,sp,64
    80000c94:	8082                	ret
      panic("kalloc");
    80000c96:	00006517          	auipc	a0,0x6
    80000c9a:	47a50513          	addi	a0,a0,1146 # 80007110 <etext+0x110>
    80000c9e:	181040ef          	jal	8000561e <panic>

0000000080000ca2 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000ca2:	7139                	addi	sp,sp,-64
    80000ca4:	fc06                	sd	ra,56(sp)
    80000ca6:	f822                	sd	s0,48(sp)
    80000ca8:	f426                	sd	s1,40(sp)
    80000caa:	f04a                	sd	s2,32(sp)
    80000cac:	ec4e                	sd	s3,24(sp)
    80000cae:	e852                	sd	s4,16(sp)
    80000cb0:	e456                	sd	s5,8(sp)
    80000cb2:	e05a                	sd	s6,0(sp)
    80000cb4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cb6:	00006597          	auipc	a1,0x6
    80000cba:	46258593          	addi	a1,a1,1122 # 80007118 <etext+0x118>
    80000cbe:	00009517          	auipc	a0,0x9
    80000cc2:	6e250513          	addi	a0,a0,1762 # 8000a3a0 <pid_lock>
    80000cc6:	395040ef          	jal	8000585a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cca:	00006597          	auipc	a1,0x6
    80000cce:	45658593          	addi	a1,a1,1110 # 80007120 <etext+0x120>
    80000cd2:	00009517          	auipc	a0,0x9
    80000cd6:	6e650513          	addi	a0,a0,1766 # 8000a3b8 <wait_lock>
    80000cda:	381040ef          	jal	8000585a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cde:	0000a497          	auipc	s1,0xa
    80000ce2:	af248493          	addi	s1,s1,-1294 # 8000a7d0 <proc>
      initlock(&p->lock, "proc");
    80000ce6:	00006b17          	auipc	s6,0x6
    80000cea:	44ab0b13          	addi	s6,s6,1098 # 80007130 <etext+0x130>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cee:	8aa6                	mv	s5,s1
    80000cf0:	ff4df937          	lui	s2,0xff4df
    80000cf4:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb135>
    80000cf8:	0936                	slli	s2,s2,0xd
    80000cfa:	6f590913          	addi	s2,s2,1781
    80000cfe:	0936                	slli	s2,s2,0xd
    80000d00:	bd390913          	addi	s2,s2,-1069
    80000d04:	0932                	slli	s2,s2,0xc
    80000d06:	7a790913          	addi	s2,s2,1959
    80000d0a:	040009b7          	lui	s3,0x4000
    80000d0e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d10:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	0000fa17          	auipc	s4,0xf
    80000d16:	6bea0a13          	addi	s4,s4,1726 # 800103d0 <tickslock>
      initlock(&p->lock, "proc");
    80000d1a:	85da                	mv	a1,s6
    80000d1c:	8526                	mv	a0,s1
    80000d1e:	33d040ef          	jal	8000585a <initlock>
      p->state = UNUSED;
    80000d22:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d26:	415487b3          	sub	a5,s1,s5
    80000d2a:	8791                	srai	a5,a5,0x4
    80000d2c:	032787b3          	mul	a5,a5,s2
    80000d30:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffdb779>
    80000d32:	00d7979b          	slliw	a5,a5,0xd
    80000d36:	40f987b3          	sub	a5,s3,a5
    80000d3a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	17048493          	addi	s1,s1,368
    80000d40:	fd449de3          	bne	s1,s4,80000d1a <procinit+0x78>
  }
}
    80000d44:	70e2                	ld	ra,56(sp)
    80000d46:	7442                	ld	s0,48(sp)
    80000d48:	74a2                	ld	s1,40(sp)
    80000d4a:	7902                	ld	s2,32(sp)
    80000d4c:	69e2                	ld	s3,24(sp)
    80000d4e:	6a42                	ld	s4,16(sp)
    80000d50:	6aa2                	ld	s5,8(sp)
    80000d52:	6b02                	ld	s6,0(sp)
    80000d54:	6121                	addi	sp,sp,64
    80000d56:	8082                	ret

0000000080000d58 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e422                	sd	s0,8(sp)
    80000d5c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d5e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d60:	2501                	sext.w	a0,a0
    80000d62:	6422                	ld	s0,8(sp)
    80000d64:	0141                	addi	sp,sp,16
    80000d66:	8082                	ret

0000000080000d68 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d68:	1141                	addi	sp,sp,-16
    80000d6a:	e422                	sd	s0,8(sp)
    80000d6c:	0800                	addi	s0,sp,16
    80000d6e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d70:	2781                	sext.w	a5,a5
    80000d72:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d74:	00009517          	auipc	a0,0x9
    80000d78:	65c50513          	addi	a0,a0,1628 # 8000a3d0 <cpus>
    80000d7c:	953e                	add	a0,a0,a5
    80000d7e:	6422                	ld	s0,8(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret

0000000080000d84 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d84:	1101                	addi	sp,sp,-32
    80000d86:	ec06                	sd	ra,24(sp)
    80000d88:	e822                	sd	s0,16(sp)
    80000d8a:	e426                	sd	s1,8(sp)
    80000d8c:	1000                	addi	s0,sp,32
  push_off();
    80000d8e:	30d040ef          	jal	8000589a <push_off>
    80000d92:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d94:	2781                	sext.w	a5,a5
    80000d96:	079e                	slli	a5,a5,0x7
    80000d98:	00009717          	auipc	a4,0x9
    80000d9c:	60870713          	addi	a4,a4,1544 # 8000a3a0 <pid_lock>
    80000da0:	97ba                	add	a5,a5,a4
    80000da2:	7b84                	ld	s1,48(a5)
  pop_off();
    80000da4:	37b040ef          	jal	8000591e <pop_off>
  return p;
}
    80000da8:	8526                	mv	a0,s1
    80000daa:	60e2                	ld	ra,24(sp)
    80000dac:	6442                	ld	s0,16(sp)
    80000dae:	64a2                	ld	s1,8(sp)
    80000db0:	6105                	addi	sp,sp,32
    80000db2:	8082                	ret

0000000080000db4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000db4:	7179                	addi	sp,sp,-48
    80000db6:	f406                	sd	ra,40(sp)
    80000db8:	f022                	sd	s0,32(sp)
    80000dba:	ec26                	sd	s1,24(sp)
    80000dbc:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000dbe:	fc7ff0ef          	jal	80000d84 <myproc>
    80000dc2:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000dc4:	3af040ef          	jal	80005972 <release>

  if (first) {
    80000dc8:	00009797          	auipc	a5,0x9
    80000dcc:	5587a783          	lw	a5,1368(a5) # 8000a320 <first.1>
    80000dd0:	cf8d                	beqz	a5,80000e0a <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dd2:	4505                	li	a0,1
    80000dd4:	3f9010ef          	jal	800029cc <fsinit>

    first = 0;
    80000dd8:	00009797          	auipc	a5,0x9
    80000ddc:	5407a423          	sw	zero,1352(a5) # 8000a320 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000de0:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000de4:	00006517          	auipc	a0,0x6
    80000de8:	35450513          	addi	a0,a0,852 # 80007138 <etext+0x138>
    80000dec:	fca43823          	sd	a0,-48(s0)
    80000df0:	fc043c23          	sd	zero,-40(s0)
    80000df4:	fd040593          	addi	a1,s0,-48
    80000df8:	4d5020ef          	jal	80003acc <kexec>
    80000dfc:	6cbc                	ld	a5,88(s1)
    80000dfe:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000e00:	6cbc                	ld	a5,88(s1)
    80000e02:	7bb8                	ld	a4,112(a5)
    80000e04:	57fd                	li	a5,-1
    80000e06:	02f70d63          	beq	a4,a5,80000e40 <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e0a:	2b5000ef          	jal	800018be <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e0e:	68a8                	ld	a0,80(s1)
    80000e10:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e12:	04000737          	lui	a4,0x4000
    80000e16:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e18:	0732                	slli	a4,a4,0xc
    80000e1a:	00005797          	auipc	a5,0x5
    80000e1e:	28278793          	addi	a5,a5,642 # 8000609c <userret>
    80000e22:	00005697          	auipc	a3,0x5
    80000e26:	1de68693          	addi	a3,a3,478 # 80006000 <_trampoline>
    80000e2a:	8f95                	sub	a5,a5,a3
    80000e2c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e2e:	577d                	li	a4,-1
    80000e30:	177e                	slli	a4,a4,0x3f
    80000e32:	8d59                	or	a0,a0,a4
    80000e34:	9782                	jalr	a5
}
    80000e36:	70a2                	ld	ra,40(sp)
    80000e38:	7402                	ld	s0,32(sp)
    80000e3a:	64e2                	ld	s1,24(sp)
    80000e3c:	6145                	addi	sp,sp,48
    80000e3e:	8082                	ret
      panic("exec");
    80000e40:	00006517          	auipc	a0,0x6
    80000e44:	30050513          	addi	a0,a0,768 # 80007140 <etext+0x140>
    80000e48:	7d6040ef          	jal	8000561e <panic>

0000000080000e4c <allocpid>:
{
    80000e4c:	1101                	addi	sp,sp,-32
    80000e4e:	ec06                	sd	ra,24(sp)
    80000e50:	e822                	sd	s0,16(sp)
    80000e52:	e426                	sd	s1,8(sp)
    80000e54:	e04a                	sd	s2,0(sp)
    80000e56:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e58:	00009917          	auipc	s2,0x9
    80000e5c:	54890913          	addi	s2,s2,1352 # 8000a3a0 <pid_lock>
    80000e60:	854a                	mv	a0,s2
    80000e62:	279040ef          	jal	800058da <acquire>
  pid = nextpid;
    80000e66:	00009797          	auipc	a5,0x9
    80000e6a:	4be78793          	addi	a5,a5,1214 # 8000a324 <nextpid>
    80000e6e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e70:	0014871b          	addiw	a4,s1,1
    80000e74:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e76:	854a                	mv	a0,s2
    80000e78:	2fb040ef          	jal	80005972 <release>
}
    80000e7c:	8526                	mv	a0,s1
    80000e7e:	60e2                	ld	ra,24(sp)
    80000e80:	6442                	ld	s0,16(sp)
    80000e82:	64a2                	ld	s1,8(sp)
    80000e84:	6902                	ld	s2,0(sp)
    80000e86:	6105                	addi	sp,sp,32
    80000e88:	8082                	ret

0000000080000e8a <proc_pagetable>:
{
    80000e8a:	1101                	addi	sp,sp,-32
    80000e8c:	ec06                	sd	ra,24(sp)
    80000e8e:	e822                	sd	s0,16(sp)
    80000e90:	e426                	sd	s1,8(sp)
    80000e92:	e04a                	sd	s2,0(sp)
    80000e94:	1000                	addi	s0,sp,32
    80000e96:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e98:	f8eff0ef          	jal	80000626 <uvmcreate>
    80000e9c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e9e:	cd05                	beqz	a0,80000ed6 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000ea0:	4729                	li	a4,10
    80000ea2:	00005697          	auipc	a3,0x5
    80000ea6:	15e68693          	addi	a3,a3,350 # 80006000 <_trampoline>
    80000eaa:	6605                	lui	a2,0x1
    80000eac:	040005b7          	lui	a1,0x4000
    80000eb0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eb2:	05b2                	slli	a1,a1,0xc
    80000eb4:	dccff0ef          	jal	80000480 <mappages>
    80000eb8:	02054663          	bltz	a0,80000ee4 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000ebc:	4719                	li	a4,6
    80000ebe:	05893683          	ld	a3,88(s2)
    80000ec2:	6605                	lui	a2,0x1
    80000ec4:	020005b7          	lui	a1,0x2000
    80000ec8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eca:	05b6                	slli	a1,a1,0xd
    80000ecc:	8526                	mv	a0,s1
    80000ece:	db2ff0ef          	jal	80000480 <mappages>
    80000ed2:	00054f63          	bltz	a0,80000ef0 <proc_pagetable+0x66>
}
    80000ed6:	8526                	mv	a0,s1
    80000ed8:	60e2                	ld	ra,24(sp)
    80000eda:	6442                	ld	s0,16(sp)
    80000edc:	64a2                	ld	s1,8(sp)
    80000ede:	6902                	ld	s2,0(sp)
    80000ee0:	6105                	addi	sp,sp,32
    80000ee2:	8082                	ret
    uvmfree(pagetable, 0);
    80000ee4:	4581                	li	a1,0
    80000ee6:	8526                	mv	a0,s1
    80000ee8:	94dff0ef          	jal	80000834 <uvmfree>
    return 0;
    80000eec:	4481                	li	s1,0
    80000eee:	b7e5                	j	80000ed6 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ef0:	4681                	li	a3,0
    80000ef2:	4605                	li	a2,1
    80000ef4:	040005b7          	lui	a1,0x4000
    80000ef8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000efa:	05b2                	slli	a1,a1,0xc
    80000efc:	8526                	mv	a0,s1
    80000efe:	f4eff0ef          	jal	8000064c <uvmunmap>
    uvmfree(pagetable, 0);
    80000f02:	4581                	li	a1,0
    80000f04:	8526                	mv	a0,s1
    80000f06:	92fff0ef          	jal	80000834 <uvmfree>
    return 0;
    80000f0a:	4481                	li	s1,0
    80000f0c:	b7e9                	j	80000ed6 <proc_pagetable+0x4c>

0000000080000f0e <proc_freepagetable>:
{
    80000f0e:	1101                	addi	sp,sp,-32
    80000f10:	ec06                	sd	ra,24(sp)
    80000f12:	e822                	sd	s0,16(sp)
    80000f14:	e426                	sd	s1,8(sp)
    80000f16:	e04a                	sd	s2,0(sp)
    80000f18:	1000                	addi	s0,sp,32
    80000f1a:	84aa                	mv	s1,a0
    80000f1c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f1e:	4681                	li	a3,0
    80000f20:	4605                	li	a2,1
    80000f22:	040005b7          	lui	a1,0x4000
    80000f26:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f28:	05b2                	slli	a1,a1,0xc
    80000f2a:	f22ff0ef          	jal	8000064c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f2e:	4681                	li	a3,0
    80000f30:	4605                	li	a2,1
    80000f32:	020005b7          	lui	a1,0x2000
    80000f36:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f38:	05b6                	slli	a1,a1,0xd
    80000f3a:	8526                	mv	a0,s1
    80000f3c:	f10ff0ef          	jal	8000064c <uvmunmap>
  uvmfree(pagetable, sz);
    80000f40:	85ca                	mv	a1,s2
    80000f42:	8526                	mv	a0,s1
    80000f44:	8f1ff0ef          	jal	80000834 <uvmfree>
}
    80000f48:	60e2                	ld	ra,24(sp)
    80000f4a:	6442                	ld	s0,16(sp)
    80000f4c:	64a2                	ld	s1,8(sp)
    80000f4e:	6902                	ld	s2,0(sp)
    80000f50:	6105                	addi	sp,sp,32
    80000f52:	8082                	ret

0000000080000f54 <freeproc>:
{
    80000f54:	1101                	addi	sp,sp,-32
    80000f56:	ec06                	sd	ra,24(sp)
    80000f58:	e822                	sd	s0,16(sp)
    80000f5a:	e426                	sd	s1,8(sp)
    80000f5c:	1000                	addi	s0,sp,32
    80000f5e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f60:	6d28                	ld	a0,88(a0)
    80000f62:	c119                	beqz	a0,80000f68 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f64:	8b8ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f68:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f6c:	68a8                	ld	a0,80(s1)
    80000f6e:	c501                	beqz	a0,80000f76 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f70:	64ac                	ld	a1,72(s1)
    80000f72:	f9dff0ef          	jal	80000f0e <proc_freepagetable>
  p->pagetable = 0;
    80000f76:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f7a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f7e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f82:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f86:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f8a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f8e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f92:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f96:	0004ac23          	sw	zero,24(s1)
}
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6105                	addi	sp,sp,32
    80000fa2:	8082                	ret

0000000080000fa4 <allocproc>:
{
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	e04a                	sd	s2,0(sp)
    80000fae:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb0:	0000a497          	auipc	s1,0xa
    80000fb4:	82048493          	addi	s1,s1,-2016 # 8000a7d0 <proc>
    80000fb8:	0000f917          	auipc	s2,0xf
    80000fbc:	41890913          	addi	s2,s2,1048 # 800103d0 <tickslock>
    acquire(&p->lock);
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	119040ef          	jal	800058da <acquire>
    if(p->state == UNUSED) {
    80000fc6:	4c9c                	lw	a5,24(s1)
    80000fc8:	cb91                	beqz	a5,80000fdc <allocproc+0x38>
      release(&p->lock);
    80000fca:	8526                	mv	a0,s1
    80000fcc:	1a7040ef          	jal	80005972 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fd0:	17048493          	addi	s1,s1,368
    80000fd4:	ff2496e3          	bne	s1,s2,80000fc0 <allocproc+0x1c>
  return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	a089                	j	8000101c <allocproc+0x78>
  p->pid = allocpid();
    80000fdc:	e71ff0ef          	jal	80000e4c <allocpid>
    80000fe0:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fe2:	4785                	li	a5,1
    80000fe4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fe6:	910ff0ef          	jal	800000f6 <kalloc>
    80000fea:	892a                	mv	s2,a0
    80000fec:	eca8                	sd	a0,88(s1)
    80000fee:	cd15                	beqz	a0,8000102a <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	e99ff0ef          	jal	80000e8a <proc_pagetable>
    80000ff6:	892a                	mv	s2,a0
    80000ff8:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000ffa:	c121                	beqz	a0,8000103a <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000ffc:	07000613          	li	a2,112
    80001000:	4581                	li	a1,0
    80001002:	06048513          	addi	a0,s1,96
    80001006:	92eff0ef          	jal	80000134 <memset>
  p->context.ra = (uint64)forkret;
    8000100a:	00000797          	auipc	a5,0x0
    8000100e:	daa78793          	addi	a5,a5,-598 # 80000db4 <forkret>
    80001012:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001014:	60bc                	ld	a5,64(s1)
    80001016:	6705                	lui	a4,0x1
    80001018:	97ba                	add	a5,a5,a4
    8000101a:	f4bc                	sd	a5,104(s1)
}
    8000101c:	8526                	mv	a0,s1
    8000101e:	60e2                	ld	ra,24(sp)
    80001020:	6442                	ld	s0,16(sp)
    80001022:	64a2                	ld	s1,8(sp)
    80001024:	6902                	ld	s2,0(sp)
    80001026:	6105                	addi	sp,sp,32
    80001028:	8082                	ret
    freeproc(p);
    8000102a:	8526                	mv	a0,s1
    8000102c:	f29ff0ef          	jal	80000f54 <freeproc>
    release(&p->lock);
    80001030:	8526                	mv	a0,s1
    80001032:	141040ef          	jal	80005972 <release>
    return 0;
    80001036:	84ca                	mv	s1,s2
    80001038:	b7d5                	j	8000101c <allocproc+0x78>
    freeproc(p);
    8000103a:	8526                	mv	a0,s1
    8000103c:	f19ff0ef          	jal	80000f54 <freeproc>
    release(&p->lock);
    80001040:	8526                	mv	a0,s1
    80001042:	131040ef          	jal	80005972 <release>
    return 0;
    80001046:	84ca                	mv	s1,s2
    80001048:	bfd1                	j	8000101c <allocproc+0x78>

000000008000104a <userinit>:
{
    8000104a:	1101                	addi	sp,sp,-32
    8000104c:	ec06                	sd	ra,24(sp)
    8000104e:	e822                	sd	s0,16(sp)
    80001050:	e426                	sd	s1,8(sp)
    80001052:	1000                	addi	s0,sp,32
  p = allocproc();
    80001054:	f51ff0ef          	jal	80000fa4 <allocproc>
    80001058:	84aa                	mv	s1,a0
  initproc = p;
    8000105a:	00009797          	auipc	a5,0x9
    8000105e:	30a7b323          	sd	a0,774(a5) # 8000a360 <initproc>
  p->cwd = namei("/");
    80001062:	00006517          	auipc	a0,0x6
    80001066:	0e650513          	addi	a0,a0,230 # 80007148 <etext+0x148>
    8000106a:	685010ef          	jal	80002eee <namei>
    8000106e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001072:	478d                	li	a5,3
    80001074:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001076:	8526                	mv	a0,s1
    80001078:	0fb040ef          	jal	80005972 <release>
}
    8000107c:	60e2                	ld	ra,24(sp)
    8000107e:	6442                	ld	s0,16(sp)
    80001080:	64a2                	ld	s1,8(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <growproc>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	e04a                	sd	s2,0(sp)
    80001090:	1000                	addi	s0,sp,32
    80001092:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001094:	cf1ff0ef          	jal	80000d84 <myproc>
    80001098:	84aa                	mv	s1,a0
  sz = p->sz;
    8000109a:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000109c:	01204c63          	bgtz	s2,800010b4 <growproc+0x2e>
  } else if(n < 0){
    800010a0:	02094463          	bltz	s2,800010c8 <growproc+0x42>
  p->sz = sz;
    800010a4:	e4ac                	sd	a1,72(s1)
  return 0;
    800010a6:	4501                	li	a0,0
}
    800010a8:	60e2                	ld	ra,24(sp)
    800010aa:	6442                	ld	s0,16(sp)
    800010ac:	64a2                	ld	s1,8(sp)
    800010ae:	6902                	ld	s2,0(sp)
    800010b0:	6105                	addi	sp,sp,32
    800010b2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010b4:	4691                	li	a3,4
    800010b6:	00b90633          	add	a2,s2,a1
    800010ba:	6928                	ld	a0,80(a0)
    800010bc:	e7aff0ef          	jal	80000736 <uvmalloc>
    800010c0:	85aa                	mv	a1,a0
    800010c2:	f16d                	bnez	a0,800010a4 <growproc+0x1e>
      return -1;
    800010c4:	557d                	li	a0,-1
    800010c6:	b7cd                	j	800010a8 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010c8:	00b90633          	add	a2,s2,a1
    800010cc:	6928                	ld	a0,80(a0)
    800010ce:	e24ff0ef          	jal	800006f2 <uvmdealloc>
    800010d2:	85aa                	mv	a1,a0
    800010d4:	bfc1                	j	800010a4 <growproc+0x1e>

00000000800010d6 <kfork>:
{
    800010d6:	7139                	addi	sp,sp,-64
    800010d8:	fc06                	sd	ra,56(sp)
    800010da:	f822                	sd	s0,48(sp)
    800010dc:	f04a                	sd	s2,32(sp)
    800010de:	e456                	sd	s5,8(sp)
    800010e0:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010e2:	ca3ff0ef          	jal	80000d84 <myproc>
    800010e6:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010e8:	ebdff0ef          	jal	80000fa4 <allocproc>
    800010ec:	0e050e63          	beqz	a0,800011e8 <kfork+0x112>
    800010f0:	ec4e                	sd	s3,24(sp)
    800010f2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010f4:	048ab603          	ld	a2,72(s5)
    800010f8:	692c                	ld	a1,80(a0)
    800010fa:	050ab503          	ld	a0,80(s5)
    800010fe:	f68ff0ef          	jal	80000866 <uvmcopy>
    80001102:	04054a63          	bltz	a0,80001156 <kfork+0x80>
    80001106:	f426                	sd	s1,40(sp)
    80001108:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    8000110a:	048ab783          	ld	a5,72(s5)
    8000110e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001112:	058ab683          	ld	a3,88(s5)
    80001116:	87b6                	mv	a5,a3
    80001118:	0589b703          	ld	a4,88(s3)
    8000111c:	12068693          	addi	a3,a3,288
    80001120:	0007b803          	ld	a6,0(a5)
    80001124:	6788                	ld	a0,8(a5)
    80001126:	6b8c                	ld	a1,16(a5)
    80001128:	6f90                	ld	a2,24(a5)
    8000112a:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    8000112e:	e708                	sd	a0,8(a4)
    80001130:	eb0c                	sd	a1,16(a4)
    80001132:	ef10                	sd	a2,24(a4)
    80001134:	02078793          	addi	a5,a5,32
    80001138:	02070713          	addi	a4,a4,32
    8000113c:	fed792e3          	bne	a5,a3,80001120 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001140:	0589b783          	ld	a5,88(s3)
    80001144:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001148:	0d0a8493          	addi	s1,s5,208
    8000114c:	0d098913          	addi	s2,s3,208
    80001150:	150a8a13          	addi	s4,s5,336
    80001154:	a831                	j	80001170 <kfork+0x9a>
    freeproc(np);
    80001156:	854e                	mv	a0,s3
    80001158:	dfdff0ef          	jal	80000f54 <freeproc>
    release(&np->lock);
    8000115c:	854e                	mv	a0,s3
    8000115e:	015040ef          	jal	80005972 <release>
    return -1;
    80001162:	597d                	li	s2,-1
    80001164:	69e2                	ld	s3,24(sp)
    80001166:	a895                	j	800011da <kfork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001168:	04a1                	addi	s1,s1,8
    8000116a:	0921                	addi	s2,s2,8
    8000116c:	01448963          	beq	s1,s4,8000117e <kfork+0xa8>
    if(p->ofile[i])
    80001170:	6088                	ld	a0,0(s1)
    80001172:	d97d                	beqz	a0,80001168 <kfork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001174:	314020ef          	jal	80003488 <filedup>
    80001178:	00a93023          	sd	a0,0(s2)
    8000117c:	b7f5                	j	80001168 <kfork+0x92>
  np->cwd = idup(p->cwd);
    8000117e:	150ab503          	ld	a0,336(s5)
    80001182:	520010ef          	jal	800026a2 <idup>
    80001186:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000118a:	4641                	li	a2,16
    8000118c:	158a8593          	addi	a1,s5,344
    80001190:	15898513          	addi	a0,s3,344
    80001194:	8deff0ef          	jal	80000272 <safestrcpy>
  pid = np->pid;
    80001198:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000119c:	854e                	mv	a0,s3
    8000119e:	7d4040ef          	jal	80005972 <release>
  acquire(&wait_lock);
    800011a2:	00009497          	auipc	s1,0x9
    800011a6:	21648493          	addi	s1,s1,534 # 8000a3b8 <wait_lock>
    800011aa:	8526                	mv	a0,s1
    800011ac:	72e040ef          	jal	800058da <acquire>
  np->parent = p;
    800011b0:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800011b4:	8526                	mv	a0,s1
    800011b6:	7bc040ef          	jal	80005972 <release>
  acquire(&np->lock);
    800011ba:	854e                	mv	a0,s3
    800011bc:	71e040ef          	jal	800058da <acquire>
  np->state = RUNNABLE;
    800011c0:	478d                	li	a5,3
    800011c2:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800011c6:	854e                	mv	a0,s3
    800011c8:	7aa040ef          	jal	80005972 <release>
  np->monitor_mask = p->monitor_mask;
    800011cc:	168aa783          	lw	a5,360(s5)
    800011d0:	16f9a423          	sw	a5,360(s3)
  return pid;
    800011d4:	74a2                	ld	s1,40(sp)
    800011d6:	69e2                	ld	s3,24(sp)
    800011d8:	6a42                	ld	s4,16(sp)
}
    800011da:	854a                	mv	a0,s2
    800011dc:	70e2                	ld	ra,56(sp)
    800011de:	7442                	ld	s0,48(sp)
    800011e0:	7902                	ld	s2,32(sp)
    800011e2:	6aa2                	ld	s5,8(sp)
    800011e4:	6121                	addi	sp,sp,64
    800011e6:	8082                	ret
    return -1;
    800011e8:	597d                	li	s2,-1
    800011ea:	bfc5                	j	800011da <kfork+0x104>

00000000800011ec <scheduler>:
{
    800011ec:	715d                	addi	sp,sp,-80
    800011ee:	e486                	sd	ra,72(sp)
    800011f0:	e0a2                	sd	s0,64(sp)
    800011f2:	fc26                	sd	s1,56(sp)
    800011f4:	f84a                	sd	s2,48(sp)
    800011f6:	f44e                	sd	s3,40(sp)
    800011f8:	f052                	sd	s4,32(sp)
    800011fa:	ec56                	sd	s5,24(sp)
    800011fc:	e85a                	sd	s6,16(sp)
    800011fe:	e45e                	sd	s7,8(sp)
    80001200:	e062                	sd	s8,0(sp)
    80001202:	0880                	addi	s0,sp,80
    80001204:	8792                	mv	a5,tp
  int id = r_tp();
    80001206:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001208:	00779b13          	slli	s6,a5,0x7
    8000120c:	00009717          	auipc	a4,0x9
    80001210:	19470713          	addi	a4,a4,404 # 8000a3a0 <pid_lock>
    80001214:	975a                	add	a4,a4,s6
    80001216:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000121a:	00009717          	auipc	a4,0x9
    8000121e:	1be70713          	addi	a4,a4,446 # 8000a3d8 <cpus+0x8>
    80001222:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001224:	4c11                	li	s8,4
        c->proc = p;
    80001226:	079e                	slli	a5,a5,0x7
    80001228:	00009a17          	auipc	s4,0x9
    8000122c:	178a0a13          	addi	s4,s4,376 # 8000a3a0 <pid_lock>
    80001230:	9a3e                	add	s4,s4,a5
        found = 1;
    80001232:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001234:	0000f997          	auipc	s3,0xf
    80001238:	19c98993          	addi	s3,s3,412 # 800103d0 <tickslock>
    8000123c:	a83d                	j	8000127a <scheduler+0x8e>
      release(&p->lock);
    8000123e:	8526                	mv	a0,s1
    80001240:	732040ef          	jal	80005972 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001244:	17048493          	addi	s1,s1,368
    80001248:	03348563          	beq	s1,s3,80001272 <scheduler+0x86>
      acquire(&p->lock);
    8000124c:	8526                	mv	a0,s1
    8000124e:	68c040ef          	jal	800058da <acquire>
      if(p->state == RUNNABLE) {
    80001252:	4c9c                	lw	a5,24(s1)
    80001254:	ff2795e3          	bne	a5,s2,8000123e <scheduler+0x52>
        p->state = RUNNING;
    80001258:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    8000125c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001260:	06048593          	addi	a1,s1,96
    80001264:	855a                	mv	a0,s6
    80001266:	5b2000ef          	jal	80001818 <swtch>
        c->proc = 0;
    8000126a:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000126e:	8ade                	mv	s5,s7
    80001270:	b7f9                	j	8000123e <scheduler+0x52>
    if(found == 0) {
    80001272:	000a9463          	bnez	s5,8000127a <scheduler+0x8e>
      asm volatile("wfi");
    80001276:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000127a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000127e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001282:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001286:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000128a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000128c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001290:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001292:	00009497          	auipc	s1,0x9
    80001296:	53e48493          	addi	s1,s1,1342 # 8000a7d0 <proc>
      if(p->state == RUNNABLE) {
    8000129a:	490d                	li	s2,3
    8000129c:	bf45                	j	8000124c <scheduler+0x60>

000000008000129e <sched>:
{
    8000129e:	7179                	addi	sp,sp,-48
    800012a0:	f406                	sd	ra,40(sp)
    800012a2:	f022                	sd	s0,32(sp)
    800012a4:	ec26                	sd	s1,24(sp)
    800012a6:	e84a                	sd	s2,16(sp)
    800012a8:	e44e                	sd	s3,8(sp)
    800012aa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012ac:	ad9ff0ef          	jal	80000d84 <myproc>
    800012b0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012b2:	5be040ef          	jal	80005870 <holding>
    800012b6:	c92d                	beqz	a0,80001328 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012b8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012ba:	2781                	sext.w	a5,a5
    800012bc:	079e                	slli	a5,a5,0x7
    800012be:	00009717          	auipc	a4,0x9
    800012c2:	0e270713          	addi	a4,a4,226 # 8000a3a0 <pid_lock>
    800012c6:	97ba                	add	a5,a5,a4
    800012c8:	0a87a703          	lw	a4,168(a5)
    800012cc:	4785                	li	a5,1
    800012ce:	06f71363          	bne	a4,a5,80001334 <sched+0x96>
  if(p->state == RUNNING)
    800012d2:	4c98                	lw	a4,24(s1)
    800012d4:	4791                	li	a5,4
    800012d6:	06f70563          	beq	a4,a5,80001340 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012da:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012de:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012e0:	e7b5                	bnez	a5,8000134c <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012e2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012e4:	00009917          	auipc	s2,0x9
    800012e8:	0bc90913          	addi	s2,s2,188 # 8000a3a0 <pid_lock>
    800012ec:	2781                	sext.w	a5,a5
    800012ee:	079e                	slli	a5,a5,0x7
    800012f0:	97ca                	add	a5,a5,s2
    800012f2:	0ac7a983          	lw	s3,172(a5)
    800012f6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012f8:	2781                	sext.w	a5,a5
    800012fa:	079e                	slli	a5,a5,0x7
    800012fc:	00009597          	auipc	a1,0x9
    80001300:	0dc58593          	addi	a1,a1,220 # 8000a3d8 <cpus+0x8>
    80001304:	95be                	add	a1,a1,a5
    80001306:	06048513          	addi	a0,s1,96
    8000130a:	50e000ef          	jal	80001818 <swtch>
    8000130e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001310:	2781                	sext.w	a5,a5
    80001312:	079e                	slli	a5,a5,0x7
    80001314:	993e                	add	s2,s2,a5
    80001316:	0b392623          	sw	s3,172(s2)
}
    8000131a:	70a2                	ld	ra,40(sp)
    8000131c:	7402                	ld	s0,32(sp)
    8000131e:	64e2                	ld	s1,24(sp)
    80001320:	6942                	ld	s2,16(sp)
    80001322:	69a2                	ld	s3,8(sp)
    80001324:	6145                	addi	sp,sp,48
    80001326:	8082                	ret
    panic("sched p->lock");
    80001328:	00006517          	auipc	a0,0x6
    8000132c:	e2850513          	addi	a0,a0,-472 # 80007150 <etext+0x150>
    80001330:	2ee040ef          	jal	8000561e <panic>
    panic("sched locks");
    80001334:	00006517          	auipc	a0,0x6
    80001338:	e2c50513          	addi	a0,a0,-468 # 80007160 <etext+0x160>
    8000133c:	2e2040ef          	jal	8000561e <panic>
    panic("sched RUNNING");
    80001340:	00006517          	auipc	a0,0x6
    80001344:	e3050513          	addi	a0,a0,-464 # 80007170 <etext+0x170>
    80001348:	2d6040ef          	jal	8000561e <panic>
    panic("sched interruptible");
    8000134c:	00006517          	auipc	a0,0x6
    80001350:	e3450513          	addi	a0,a0,-460 # 80007180 <etext+0x180>
    80001354:	2ca040ef          	jal	8000561e <panic>

0000000080001358 <yield>:
{
    80001358:	1101                	addi	sp,sp,-32
    8000135a:	ec06                	sd	ra,24(sp)
    8000135c:	e822                	sd	s0,16(sp)
    8000135e:	e426                	sd	s1,8(sp)
    80001360:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001362:	a23ff0ef          	jal	80000d84 <myproc>
    80001366:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001368:	572040ef          	jal	800058da <acquire>
  p->state = RUNNABLE;
    8000136c:	478d                	li	a5,3
    8000136e:	cc9c                	sw	a5,24(s1)
  sched();
    80001370:	f2fff0ef          	jal	8000129e <sched>
  release(&p->lock);
    80001374:	8526                	mv	a0,s1
    80001376:	5fc040ef          	jal	80005972 <release>
}
    8000137a:	60e2                	ld	ra,24(sp)
    8000137c:	6442                	ld	s0,16(sp)
    8000137e:	64a2                	ld	s1,8(sp)
    80001380:	6105                	addi	sp,sp,32
    80001382:	8082                	ret

0000000080001384 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001384:	7179                	addi	sp,sp,-48
    80001386:	f406                	sd	ra,40(sp)
    80001388:	f022                	sd	s0,32(sp)
    8000138a:	ec26                	sd	s1,24(sp)
    8000138c:	e84a                	sd	s2,16(sp)
    8000138e:	e44e                	sd	s3,8(sp)
    80001390:	1800                	addi	s0,sp,48
    80001392:	89aa                	mv	s3,a0
    80001394:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001396:	9efff0ef          	jal	80000d84 <myproc>
    8000139a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000139c:	53e040ef          	jal	800058da <acquire>
  release(lk);
    800013a0:	854a                	mv	a0,s2
    800013a2:	5d0040ef          	jal	80005972 <release>

  // Go to sleep.
  p->chan = chan;
    800013a6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013aa:	4789                	li	a5,2
    800013ac:	cc9c                	sw	a5,24(s1)

  sched();
    800013ae:	ef1ff0ef          	jal	8000129e <sched>

  // Tidy up.
  p->chan = 0;
    800013b2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013b6:	8526                	mv	a0,s1
    800013b8:	5ba040ef          	jal	80005972 <release>
  acquire(lk);
    800013bc:	854a                	mv	a0,s2
    800013be:	51c040ef          	jal	800058da <acquire>
}
    800013c2:	70a2                	ld	ra,40(sp)
    800013c4:	7402                	ld	s0,32(sp)
    800013c6:	64e2                	ld	s1,24(sp)
    800013c8:	6942                	ld	s2,16(sp)
    800013ca:	69a2                	ld	s3,8(sp)
    800013cc:	6145                	addi	sp,sp,48
    800013ce:	8082                	ret

00000000800013d0 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013d0:	7139                	addi	sp,sp,-64
    800013d2:	fc06                	sd	ra,56(sp)
    800013d4:	f822                	sd	s0,48(sp)
    800013d6:	f426                	sd	s1,40(sp)
    800013d8:	f04a                	sd	s2,32(sp)
    800013da:	ec4e                	sd	s3,24(sp)
    800013dc:	e852                	sd	s4,16(sp)
    800013de:	e456                	sd	s5,8(sp)
    800013e0:	0080                	addi	s0,sp,64
    800013e2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013e4:	00009497          	auipc	s1,0x9
    800013e8:	3ec48493          	addi	s1,s1,1004 # 8000a7d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013ec:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013ee:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013f0:	0000f917          	auipc	s2,0xf
    800013f4:	fe090913          	addi	s2,s2,-32 # 800103d0 <tickslock>
    800013f8:	a801                	j	80001408 <wakeup+0x38>
      }
      release(&p->lock);
    800013fa:	8526                	mv	a0,s1
    800013fc:	576040ef          	jal	80005972 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001400:	17048493          	addi	s1,s1,368
    80001404:	03248263          	beq	s1,s2,80001428 <wakeup+0x58>
    if(p != myproc()){
    80001408:	97dff0ef          	jal	80000d84 <myproc>
    8000140c:	fea48ae3          	beq	s1,a0,80001400 <wakeup+0x30>
      acquire(&p->lock);
    80001410:	8526                	mv	a0,s1
    80001412:	4c8040ef          	jal	800058da <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001416:	4c9c                	lw	a5,24(s1)
    80001418:	ff3791e3          	bne	a5,s3,800013fa <wakeup+0x2a>
    8000141c:	709c                	ld	a5,32(s1)
    8000141e:	fd479ee3          	bne	a5,s4,800013fa <wakeup+0x2a>
        p->state = RUNNABLE;
    80001422:	0154ac23          	sw	s5,24(s1)
    80001426:	bfd1                	j	800013fa <wakeup+0x2a>
    }
  }
}
    80001428:	70e2                	ld	ra,56(sp)
    8000142a:	7442                	ld	s0,48(sp)
    8000142c:	74a2                	ld	s1,40(sp)
    8000142e:	7902                	ld	s2,32(sp)
    80001430:	69e2                	ld	s3,24(sp)
    80001432:	6a42                	ld	s4,16(sp)
    80001434:	6aa2                	ld	s5,8(sp)
    80001436:	6121                	addi	sp,sp,64
    80001438:	8082                	ret

000000008000143a <reparent>:
{
    8000143a:	7179                	addi	sp,sp,-48
    8000143c:	f406                	sd	ra,40(sp)
    8000143e:	f022                	sd	s0,32(sp)
    80001440:	ec26                	sd	s1,24(sp)
    80001442:	e84a                	sd	s2,16(sp)
    80001444:	e44e                	sd	s3,8(sp)
    80001446:	e052                	sd	s4,0(sp)
    80001448:	1800                	addi	s0,sp,48
    8000144a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000144c:	00009497          	auipc	s1,0x9
    80001450:	38448493          	addi	s1,s1,900 # 8000a7d0 <proc>
      pp->parent = initproc;
    80001454:	00009a17          	auipc	s4,0x9
    80001458:	f0ca0a13          	addi	s4,s4,-244 # 8000a360 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000145c:	0000f997          	auipc	s3,0xf
    80001460:	f7498993          	addi	s3,s3,-140 # 800103d0 <tickslock>
    80001464:	a029                	j	8000146e <reparent+0x34>
    80001466:	17048493          	addi	s1,s1,368
    8000146a:	01348b63          	beq	s1,s3,80001480 <reparent+0x46>
    if(pp->parent == p){
    8000146e:	7c9c                	ld	a5,56(s1)
    80001470:	ff279be3          	bne	a5,s2,80001466 <reparent+0x2c>
      pp->parent = initproc;
    80001474:	000a3503          	ld	a0,0(s4)
    80001478:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000147a:	f57ff0ef          	jal	800013d0 <wakeup>
    8000147e:	b7e5                	j	80001466 <reparent+0x2c>
}
    80001480:	70a2                	ld	ra,40(sp)
    80001482:	7402                	ld	s0,32(sp)
    80001484:	64e2                	ld	s1,24(sp)
    80001486:	6942                	ld	s2,16(sp)
    80001488:	69a2                	ld	s3,8(sp)
    8000148a:	6a02                	ld	s4,0(sp)
    8000148c:	6145                	addi	sp,sp,48
    8000148e:	8082                	ret

0000000080001490 <kexit>:
{
    80001490:	7179                	addi	sp,sp,-48
    80001492:	f406                	sd	ra,40(sp)
    80001494:	f022                	sd	s0,32(sp)
    80001496:	ec26                	sd	s1,24(sp)
    80001498:	e84a                	sd	s2,16(sp)
    8000149a:	e44e                	sd	s3,8(sp)
    8000149c:	e052                	sd	s4,0(sp)
    8000149e:	1800                	addi	s0,sp,48
    800014a0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014a2:	8e3ff0ef          	jal	80000d84 <myproc>
    800014a6:	89aa                	mv	s3,a0
  if(p == initproc)
    800014a8:	00009797          	auipc	a5,0x9
    800014ac:	eb87b783          	ld	a5,-328(a5) # 8000a360 <initproc>
    800014b0:	0d050493          	addi	s1,a0,208
    800014b4:	15050913          	addi	s2,a0,336
    800014b8:	00a79f63          	bne	a5,a0,800014d6 <kexit+0x46>
    panic("init exiting");
    800014bc:	00006517          	auipc	a0,0x6
    800014c0:	cdc50513          	addi	a0,a0,-804 # 80007198 <etext+0x198>
    800014c4:	15a040ef          	jal	8000561e <panic>
      fileclose(f);
    800014c8:	006020ef          	jal	800034ce <fileclose>
      p->ofile[fd] = 0;
    800014cc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014d0:	04a1                	addi	s1,s1,8
    800014d2:	01248563          	beq	s1,s2,800014dc <kexit+0x4c>
    if(p->ofile[fd]){
    800014d6:	6088                	ld	a0,0(s1)
    800014d8:	f965                	bnez	a0,800014c8 <kexit+0x38>
    800014da:	bfdd                	j	800014d0 <kexit+0x40>
  begin_op();
    800014dc:	3e7010ef          	jal	800030c2 <begin_op>
  iput(p->cwd);
    800014e0:	1509b503          	ld	a0,336(s3)
    800014e4:	376010ef          	jal	8000285a <iput>
  end_op();
    800014e8:	445010ef          	jal	8000312c <end_op>
  p->cwd = 0;
    800014ec:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014f0:	00009497          	auipc	s1,0x9
    800014f4:	ec848493          	addi	s1,s1,-312 # 8000a3b8 <wait_lock>
    800014f8:	8526                	mv	a0,s1
    800014fa:	3e0040ef          	jal	800058da <acquire>
  reparent(p);
    800014fe:	854e                	mv	a0,s3
    80001500:	f3bff0ef          	jal	8000143a <reparent>
  wakeup(p->parent);
    80001504:	0389b503          	ld	a0,56(s3)
    80001508:	ec9ff0ef          	jal	800013d0 <wakeup>
  acquire(&p->lock);
    8000150c:	854e                	mv	a0,s3
    8000150e:	3cc040ef          	jal	800058da <acquire>
  p->xstate = status;
    80001512:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001516:	4795                	li	a5,5
    80001518:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000151c:	8526                	mv	a0,s1
    8000151e:	454040ef          	jal	80005972 <release>
  sched();
    80001522:	d7dff0ef          	jal	8000129e <sched>
  panic("zombie exit");
    80001526:	00006517          	auipc	a0,0x6
    8000152a:	c8250513          	addi	a0,a0,-894 # 800071a8 <etext+0x1a8>
    8000152e:	0f0040ef          	jal	8000561e <panic>

0000000080001532 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001532:	7179                	addi	sp,sp,-48
    80001534:	f406                	sd	ra,40(sp)
    80001536:	f022                	sd	s0,32(sp)
    80001538:	ec26                	sd	s1,24(sp)
    8000153a:	e84a                	sd	s2,16(sp)
    8000153c:	e44e                	sd	s3,8(sp)
    8000153e:	1800                	addi	s0,sp,48
    80001540:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001542:	00009497          	auipc	s1,0x9
    80001546:	28e48493          	addi	s1,s1,654 # 8000a7d0 <proc>
    8000154a:	0000f997          	auipc	s3,0xf
    8000154e:	e8698993          	addi	s3,s3,-378 # 800103d0 <tickslock>
    acquire(&p->lock);
    80001552:	8526                	mv	a0,s1
    80001554:	386040ef          	jal	800058da <acquire>
    if(p->pid == pid){
    80001558:	589c                	lw	a5,48(s1)
    8000155a:	01278b63          	beq	a5,s2,80001570 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000155e:	8526                	mv	a0,s1
    80001560:	412040ef          	jal	80005972 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001564:	17048493          	addi	s1,s1,368
    80001568:	ff3495e3          	bne	s1,s3,80001552 <kkill+0x20>
  }
  return -1;
    8000156c:	557d                	li	a0,-1
    8000156e:	a819                	j	80001584 <kkill+0x52>
      p->killed = 1;
    80001570:	4785                	li	a5,1
    80001572:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001574:	4c98                	lw	a4,24(s1)
    80001576:	4789                	li	a5,2
    80001578:	00f70d63          	beq	a4,a5,80001592 <kkill+0x60>
      release(&p->lock);
    8000157c:	8526                	mv	a0,s1
    8000157e:	3f4040ef          	jal	80005972 <release>
      return 0;
    80001582:	4501                	li	a0,0
}
    80001584:	70a2                	ld	ra,40(sp)
    80001586:	7402                	ld	s0,32(sp)
    80001588:	64e2                	ld	s1,24(sp)
    8000158a:	6942                	ld	s2,16(sp)
    8000158c:	69a2                	ld	s3,8(sp)
    8000158e:	6145                	addi	sp,sp,48
    80001590:	8082                	ret
        p->state = RUNNABLE;
    80001592:	478d                	li	a5,3
    80001594:	cc9c                	sw	a5,24(s1)
    80001596:	b7dd                	j	8000157c <kkill+0x4a>

0000000080001598 <setkilled>:

void
setkilled(struct proc *p)
{
    80001598:	1101                	addi	sp,sp,-32
    8000159a:	ec06                	sd	ra,24(sp)
    8000159c:	e822                	sd	s0,16(sp)
    8000159e:	e426                	sd	s1,8(sp)
    800015a0:	1000                	addi	s0,sp,32
    800015a2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015a4:	336040ef          	jal	800058da <acquire>
  p->killed = 1;
    800015a8:	4785                	li	a5,1
    800015aa:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015ac:	8526                	mv	a0,s1
    800015ae:	3c4040ef          	jal	80005972 <release>
}
    800015b2:	60e2                	ld	ra,24(sp)
    800015b4:	6442                	ld	s0,16(sp)
    800015b6:	64a2                	ld	s1,8(sp)
    800015b8:	6105                	addi	sp,sp,32
    800015ba:	8082                	ret

00000000800015bc <killed>:

int
killed(struct proc *p)
{
    800015bc:	1101                	addi	sp,sp,-32
    800015be:	ec06                	sd	ra,24(sp)
    800015c0:	e822                	sd	s0,16(sp)
    800015c2:	e426                	sd	s1,8(sp)
    800015c4:	e04a                	sd	s2,0(sp)
    800015c6:	1000                	addi	s0,sp,32
    800015c8:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015ca:	310040ef          	jal	800058da <acquire>
  k = p->killed;
    800015ce:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015d2:	8526                	mv	a0,s1
    800015d4:	39e040ef          	jal	80005972 <release>
  return k;
}
    800015d8:	854a                	mv	a0,s2
    800015da:	60e2                	ld	ra,24(sp)
    800015dc:	6442                	ld	s0,16(sp)
    800015de:	64a2                	ld	s1,8(sp)
    800015e0:	6902                	ld	s2,0(sp)
    800015e2:	6105                	addi	sp,sp,32
    800015e4:	8082                	ret

00000000800015e6 <kwait>:
{
    800015e6:	715d                	addi	sp,sp,-80
    800015e8:	e486                	sd	ra,72(sp)
    800015ea:	e0a2                	sd	s0,64(sp)
    800015ec:	fc26                	sd	s1,56(sp)
    800015ee:	f84a                	sd	s2,48(sp)
    800015f0:	f44e                	sd	s3,40(sp)
    800015f2:	f052                	sd	s4,32(sp)
    800015f4:	ec56                	sd	s5,24(sp)
    800015f6:	e85a                	sd	s6,16(sp)
    800015f8:	e45e                	sd	s7,8(sp)
    800015fa:	e062                	sd	s8,0(sp)
    800015fc:	0880                	addi	s0,sp,80
    800015fe:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001600:	f84ff0ef          	jal	80000d84 <myproc>
    80001604:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001606:	00009517          	auipc	a0,0x9
    8000160a:	db250513          	addi	a0,a0,-590 # 8000a3b8 <wait_lock>
    8000160e:	2cc040ef          	jal	800058da <acquire>
    havekids = 0;
    80001612:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001614:	4a15                	li	s4,5
        havekids = 1;
    80001616:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001618:	0000f997          	auipc	s3,0xf
    8000161c:	db898993          	addi	s3,s3,-584 # 800103d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001620:	00009c17          	auipc	s8,0x9
    80001624:	d98c0c13          	addi	s8,s8,-616 # 8000a3b8 <wait_lock>
    80001628:	a871                	j	800016c4 <kwait+0xde>
          pid = pp->pid;
    8000162a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000162e:	000b0c63          	beqz	s6,80001646 <kwait+0x60>
    80001632:	4691                	li	a3,4
    80001634:	02c48613          	addi	a2,s1,44
    80001638:	85da                	mv	a1,s6
    8000163a:	05093503          	ld	a0,80(s2)
    8000163e:	c4aff0ef          	jal	80000a88 <copyout>
    80001642:	02054b63          	bltz	a0,80001678 <kwait+0x92>
          freeproc(pp);
    80001646:	8526                	mv	a0,s1
    80001648:	90dff0ef          	jal	80000f54 <freeproc>
          release(&pp->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	324040ef          	jal	80005972 <release>
          release(&wait_lock);
    80001652:	00009517          	auipc	a0,0x9
    80001656:	d6650513          	addi	a0,a0,-666 # 8000a3b8 <wait_lock>
    8000165a:	318040ef          	jal	80005972 <release>
}
    8000165e:	854e                	mv	a0,s3
    80001660:	60a6                	ld	ra,72(sp)
    80001662:	6406                	ld	s0,64(sp)
    80001664:	74e2                	ld	s1,56(sp)
    80001666:	7942                	ld	s2,48(sp)
    80001668:	79a2                	ld	s3,40(sp)
    8000166a:	7a02                	ld	s4,32(sp)
    8000166c:	6ae2                	ld	s5,24(sp)
    8000166e:	6b42                	ld	s6,16(sp)
    80001670:	6ba2                	ld	s7,8(sp)
    80001672:	6c02                	ld	s8,0(sp)
    80001674:	6161                	addi	sp,sp,80
    80001676:	8082                	ret
            release(&pp->lock);
    80001678:	8526                	mv	a0,s1
    8000167a:	2f8040ef          	jal	80005972 <release>
            release(&wait_lock);
    8000167e:	00009517          	auipc	a0,0x9
    80001682:	d3a50513          	addi	a0,a0,-710 # 8000a3b8 <wait_lock>
    80001686:	2ec040ef          	jal	80005972 <release>
            return -1;
    8000168a:	59fd                	li	s3,-1
    8000168c:	bfc9                	j	8000165e <kwait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000168e:	17048493          	addi	s1,s1,368
    80001692:	03348063          	beq	s1,s3,800016b2 <kwait+0xcc>
      if(pp->parent == p){
    80001696:	7c9c                	ld	a5,56(s1)
    80001698:	ff279be3          	bne	a5,s2,8000168e <kwait+0xa8>
        acquire(&pp->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	23c040ef          	jal	800058da <acquire>
        if(pp->state == ZOMBIE){
    800016a2:	4c9c                	lw	a5,24(s1)
    800016a4:	f94783e3          	beq	a5,s4,8000162a <kwait+0x44>
        release(&pp->lock);
    800016a8:	8526                	mv	a0,s1
    800016aa:	2c8040ef          	jal	80005972 <release>
        havekids = 1;
    800016ae:	8756                	mv	a4,s5
    800016b0:	bff9                	j	8000168e <kwait+0xa8>
    if(!havekids || killed(p)){
    800016b2:	cf19                	beqz	a4,800016d0 <kwait+0xea>
    800016b4:	854a                	mv	a0,s2
    800016b6:	f07ff0ef          	jal	800015bc <killed>
    800016ba:	e919                	bnez	a0,800016d0 <kwait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016bc:	85e2                	mv	a1,s8
    800016be:	854a                	mv	a0,s2
    800016c0:	cc5ff0ef          	jal	80001384 <sleep>
    havekids = 0;
    800016c4:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016c6:	00009497          	auipc	s1,0x9
    800016ca:	10a48493          	addi	s1,s1,266 # 8000a7d0 <proc>
    800016ce:	b7e1                	j	80001696 <kwait+0xb0>
      release(&wait_lock);
    800016d0:	00009517          	auipc	a0,0x9
    800016d4:	ce850513          	addi	a0,a0,-792 # 8000a3b8 <wait_lock>
    800016d8:	29a040ef          	jal	80005972 <release>
      return -1;
    800016dc:	59fd                	li	s3,-1
    800016de:	b741                	j	8000165e <kwait+0x78>

00000000800016e0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016e0:	7179                	addi	sp,sp,-48
    800016e2:	f406                	sd	ra,40(sp)
    800016e4:	f022                	sd	s0,32(sp)
    800016e6:	ec26                	sd	s1,24(sp)
    800016e8:	e84a                	sd	s2,16(sp)
    800016ea:	e44e                	sd	s3,8(sp)
    800016ec:	e052                	sd	s4,0(sp)
    800016ee:	1800                	addi	s0,sp,48
    800016f0:	84aa                	mv	s1,a0
    800016f2:	892e                	mv	s2,a1
    800016f4:	89b2                	mv	s3,a2
    800016f6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016f8:	e8cff0ef          	jal	80000d84 <myproc>
  if(user_dst){
    800016fc:	cc99                	beqz	s1,8000171a <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016fe:	86d2                	mv	a3,s4
    80001700:	864e                	mv	a2,s3
    80001702:	85ca                	mv	a1,s2
    80001704:	6928                	ld	a0,80(a0)
    80001706:	b82ff0ef          	jal	80000a88 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000170a:	70a2                	ld	ra,40(sp)
    8000170c:	7402                	ld	s0,32(sp)
    8000170e:	64e2                	ld	s1,24(sp)
    80001710:	6942                	ld	s2,16(sp)
    80001712:	69a2                	ld	s3,8(sp)
    80001714:	6a02                	ld	s4,0(sp)
    80001716:	6145                	addi	sp,sp,48
    80001718:	8082                	ret
    memmove((char *)dst, src, len);
    8000171a:	000a061b          	sext.w	a2,s4
    8000171e:	85ce                	mv	a1,s3
    80001720:	854a                	mv	a0,s2
    80001722:	a6ffe0ef          	jal	80000190 <memmove>
    return 0;
    80001726:	8526                	mv	a0,s1
    80001728:	b7cd                	j	8000170a <either_copyout+0x2a>

000000008000172a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000172a:	7179                	addi	sp,sp,-48
    8000172c:	f406                	sd	ra,40(sp)
    8000172e:	f022                	sd	s0,32(sp)
    80001730:	ec26                	sd	s1,24(sp)
    80001732:	e84a                	sd	s2,16(sp)
    80001734:	e44e                	sd	s3,8(sp)
    80001736:	e052                	sd	s4,0(sp)
    80001738:	1800                	addi	s0,sp,48
    8000173a:	892a                	mv	s2,a0
    8000173c:	84ae                	mv	s1,a1
    8000173e:	89b2                	mv	s3,a2
    80001740:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001742:	e42ff0ef          	jal	80000d84 <myproc>
  if(user_src){
    80001746:	cc99                	beqz	s1,80001764 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001748:	86d2                	mv	a3,s4
    8000174a:	864e                	mv	a2,s3
    8000174c:	85ca                	mv	a1,s2
    8000174e:	6928                	ld	a0,80(a0)
    80001750:	c2cff0ef          	jal	80000b7c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001754:	70a2                	ld	ra,40(sp)
    80001756:	7402                	ld	s0,32(sp)
    80001758:	64e2                	ld	s1,24(sp)
    8000175a:	6942                	ld	s2,16(sp)
    8000175c:	69a2                	ld	s3,8(sp)
    8000175e:	6a02                	ld	s4,0(sp)
    80001760:	6145                	addi	sp,sp,48
    80001762:	8082                	ret
    memmove(dst, (char*)src, len);
    80001764:	000a061b          	sext.w	a2,s4
    80001768:	85ce                	mv	a1,s3
    8000176a:	854a                	mv	a0,s2
    8000176c:	a25fe0ef          	jal	80000190 <memmove>
    return 0;
    80001770:	8526                	mv	a0,s1
    80001772:	b7cd                	j	80001754 <either_copyin+0x2a>

0000000080001774 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001774:	715d                	addi	sp,sp,-80
    80001776:	e486                	sd	ra,72(sp)
    80001778:	e0a2                	sd	s0,64(sp)
    8000177a:	fc26                	sd	s1,56(sp)
    8000177c:	f84a                	sd	s2,48(sp)
    8000177e:	f44e                	sd	s3,40(sp)
    80001780:	f052                	sd	s4,32(sp)
    80001782:	ec56                	sd	s5,24(sp)
    80001784:	e85a                	sd	s6,16(sp)
    80001786:	e45e                	sd	s7,8(sp)
    80001788:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000178a:	00006517          	auipc	a0,0x6
    8000178e:	88e50513          	addi	a0,a0,-1906 # 80007018 <etext+0x18>
    80001792:	3a7030ef          	jal	80005338 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001796:	00009497          	auipc	s1,0x9
    8000179a:	19248493          	addi	s1,s1,402 # 8000a928 <proc+0x158>
    8000179e:	0000f917          	auipc	s2,0xf
    800017a2:	d8a90913          	addi	s2,s2,-630 # 80010528 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017a6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017a8:	00006997          	auipc	s3,0x6
    800017ac:	a1098993          	addi	s3,s3,-1520 # 800071b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    800017b0:	00006a97          	auipc	s5,0x6
    800017b4:	a10a8a93          	addi	s5,s5,-1520 # 800071c0 <etext+0x1c0>
    printf("\n");
    800017b8:	00006a17          	auipc	s4,0x6
    800017bc:	860a0a13          	addi	s4,s4,-1952 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017c0:	00006b97          	auipc	s7,0x6
    800017c4:	018b8b93          	addi	s7,s7,24 # 800077d8 <states.0>
    800017c8:	a829                	j	800017e2 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017ca:	ed86a583          	lw	a1,-296(a3)
    800017ce:	8556                	mv	a0,s5
    800017d0:	369030ef          	jal	80005338 <printf>
    printf("\n");
    800017d4:	8552                	mv	a0,s4
    800017d6:	363030ef          	jal	80005338 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017da:	17048493          	addi	s1,s1,368
    800017de:	03248263          	beq	s1,s2,80001802 <procdump+0x8e>
    if(p->state == UNUSED)
    800017e2:	86a6                	mv	a3,s1
    800017e4:	ec04a783          	lw	a5,-320(s1)
    800017e8:	dbed                	beqz	a5,800017da <procdump+0x66>
      state = "???";
    800017ea:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ec:	fcfb6fe3          	bltu	s6,a5,800017ca <procdump+0x56>
    800017f0:	02079713          	slli	a4,a5,0x20
    800017f4:	01d75793          	srli	a5,a4,0x1d
    800017f8:	97de                	add	a5,a5,s7
    800017fa:	6390                	ld	a2,0(a5)
    800017fc:	f679                	bnez	a2,800017ca <procdump+0x56>
      state = "???";
    800017fe:	864e                	mv	a2,s3
    80001800:	b7e9                	j	800017ca <procdump+0x56>
  }
}
    80001802:	60a6                	ld	ra,72(sp)
    80001804:	6406                	ld	s0,64(sp)
    80001806:	74e2                	ld	s1,56(sp)
    80001808:	7942                	ld	s2,48(sp)
    8000180a:	79a2                	ld	s3,40(sp)
    8000180c:	7a02                	ld	s4,32(sp)
    8000180e:	6ae2                	ld	s5,24(sp)
    80001810:	6b42                	ld	s6,16(sp)
    80001812:	6ba2                	ld	s7,8(sp)
    80001814:	6161                	addi	sp,sp,80
    80001816:	8082                	ret

0000000080001818 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001818:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000181c:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001820:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001822:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001824:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001828:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8000182c:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001830:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001834:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001838:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000183c:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001840:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001844:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001848:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000184c:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001850:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001854:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001856:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001858:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000185c:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001860:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001864:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001868:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000186c:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001870:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001874:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001878:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000187c:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001880:	8082                	ret

0000000080001882 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001882:	1141                	addi	sp,sp,-16
    80001884:	e406                	sd	ra,8(sp)
    80001886:	e022                	sd	s0,0(sp)
    80001888:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000188a:	00006597          	auipc	a1,0x6
    8000188e:	97658593          	addi	a1,a1,-1674 # 80007200 <etext+0x200>
    80001892:	0000f517          	auipc	a0,0xf
    80001896:	b3e50513          	addi	a0,a0,-1218 # 800103d0 <tickslock>
    8000189a:	7c1030ef          	jal	8000585a <initlock>
}
    8000189e:	60a2                	ld	ra,8(sp)
    800018a0:	6402                	ld	s0,0(sp)
    800018a2:	0141                	addi	sp,sp,16
    800018a4:	8082                	ret

00000000800018a6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018a6:	1141                	addi	sp,sp,-16
    800018a8:	e422                	sd	s0,8(sp)
    800018aa:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018ac:	00003797          	auipc	a5,0x3
    800018b0:	f9478793          	addi	a5,a5,-108 # 80004840 <kernelvec>
    800018b4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018b8:	6422                	ld	s0,8(sp)
    800018ba:	0141                	addi	sp,sp,16
    800018bc:	8082                	ret

00000000800018be <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018be:	1141                	addi	sp,sp,-16
    800018c0:	e406                	sd	ra,8(sp)
    800018c2:	e022                	sd	s0,0(sp)
    800018c4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018c6:	cbeff0ef          	jal	80000d84 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018ca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018ce:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018d0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018d4:	04000737          	lui	a4,0x4000
    800018d8:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018da:	0732                	slli	a4,a4,0xc
    800018dc:	00004797          	auipc	a5,0x4
    800018e0:	72478793          	addi	a5,a5,1828 # 80006000 <_trampoline>
    800018e4:	00004697          	auipc	a3,0x4
    800018e8:	71c68693          	addi	a3,a3,1820 # 80006000 <_trampoline>
    800018ec:	8f95                	sub	a5,a5,a3
    800018ee:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018f0:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800018f4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800018f6:	18002773          	csrr	a4,satp
    800018fa:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800018fc:	6d38                	ld	a4,88(a0)
    800018fe:	613c                	ld	a5,64(a0)
    80001900:	6685                	lui	a3,0x1
    80001902:	97b6                	add	a5,a5,a3
    80001904:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001906:	6d3c                	ld	a5,88(a0)
    80001908:	00000717          	auipc	a4,0x0
    8000190c:	0f870713          	addi	a4,a4,248 # 80001a00 <usertrap>
    80001910:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001912:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001914:	8712                	mv	a4,tp
    80001916:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001918:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000191c:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001920:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001924:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001928:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000192a:	6f9c                	ld	a5,24(a5)
    8000192c:	14179073          	csrw	sepc,a5
}
    80001930:	60a2                	ld	ra,8(sp)
    80001932:	6402                	ld	s0,0(sp)
    80001934:	0141                	addi	sp,sp,16
    80001936:	8082                	ret

0000000080001938 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001938:	1101                	addi	sp,sp,-32
    8000193a:	ec06                	sd	ra,24(sp)
    8000193c:	e822                	sd	s0,16(sp)
    8000193e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80001940:	c18ff0ef          	jal	80000d58 <cpuid>
    80001944:	cd11                	beqz	a0,80001960 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001946:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000194a:	000f4737          	lui	a4,0xf4
    8000194e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001952:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001954:	14d79073          	csrw	stimecmp,a5
}
    80001958:	60e2                	ld	ra,24(sp)
    8000195a:	6442                	ld	s0,16(sp)
    8000195c:	6105                	addi	sp,sp,32
    8000195e:	8082                	ret
    80001960:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001962:	0000f497          	auipc	s1,0xf
    80001966:	a6e48493          	addi	s1,s1,-1426 # 800103d0 <tickslock>
    8000196a:	8526                	mv	a0,s1
    8000196c:	76f030ef          	jal	800058da <acquire>
    ticks++;
    80001970:	00009517          	auipc	a0,0x9
    80001974:	9f850513          	addi	a0,a0,-1544 # 8000a368 <ticks>
    80001978:	411c                	lw	a5,0(a0)
    8000197a:	2785                	addiw	a5,a5,1
    8000197c:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000197e:	a53ff0ef          	jal	800013d0 <wakeup>
    release(&tickslock);
    80001982:	8526                	mv	a0,s1
    80001984:	7ef030ef          	jal	80005972 <release>
    80001988:	64a2                	ld	s1,8(sp)
    8000198a:	bf75                	j	80001946 <clockintr+0xe>

000000008000198c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000198c:	1101                	addi	sp,sp,-32
    8000198e:	ec06                	sd	ra,24(sp)
    80001990:	e822                	sd	s0,16(sp)
    80001992:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001994:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001998:	57fd                	li	a5,-1
    8000199a:	17fe                	slli	a5,a5,0x3f
    8000199c:	07a5                	addi	a5,a5,9
    8000199e:	00f70c63          	beq	a4,a5,800019b6 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019a2:	57fd                	li	a5,-1
    800019a4:	17fe                	slli	a5,a5,0x3f
    800019a6:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019a8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019aa:	04f70763          	beq	a4,a5,800019f8 <devintr+0x6c>
  }
}
    800019ae:	60e2                	ld	ra,24(sp)
    800019b0:	6442                	ld	s0,16(sp)
    800019b2:	6105                	addi	sp,sp,32
    800019b4:	8082                	ret
    800019b6:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019b8:	735020ef          	jal	800048ec <plic_claim>
    800019bc:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019be:	47a9                	li	a5,10
    800019c0:	00f50963          	beq	a0,a5,800019d2 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800019c4:	4785                	li	a5,1
    800019c6:	00f50963          	beq	a0,a5,800019d8 <devintr+0x4c>
    return 1;
    800019ca:	4505                	li	a0,1
    } else if(irq){
    800019cc:	e889                	bnez	s1,800019de <devintr+0x52>
    800019ce:	64a2                	ld	s1,8(sp)
    800019d0:	bff9                	j	800019ae <devintr+0x22>
      uartintr();
    800019d2:	61d030ef          	jal	800057ee <uartintr>
    if(irq)
    800019d6:	a819                	j	800019ec <devintr+0x60>
      virtio_disk_intr();
    800019d8:	3da030ef          	jal	80004db2 <virtio_disk_intr>
    if(irq)
    800019dc:	a801                	j	800019ec <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800019de:	85a6                	mv	a1,s1
    800019e0:	00006517          	auipc	a0,0x6
    800019e4:	82850513          	addi	a0,a0,-2008 # 80007208 <etext+0x208>
    800019e8:	151030ef          	jal	80005338 <printf>
      plic_complete(irq);
    800019ec:	8526                	mv	a0,s1
    800019ee:	71f020ef          	jal	8000490c <plic_complete>
    return 1;
    800019f2:	4505                	li	a0,1
    800019f4:	64a2                	ld	s1,8(sp)
    800019f6:	bf65                	j	800019ae <devintr+0x22>
    clockintr();
    800019f8:	f41ff0ef          	jal	80001938 <clockintr>
    return 2;
    800019fc:	4509                	li	a0,2
    800019fe:	bf45                	j	800019ae <devintr+0x22>

0000000080001a00 <usertrap>:
{
    80001a00:	1101                	addi	sp,sp,-32
    80001a02:	ec06                	sd	ra,24(sp)
    80001a04:	e822                	sd	s0,16(sp)
    80001a06:	e426                	sd	s1,8(sp)
    80001a08:	e04a                	sd	s2,0(sp)
    80001a0a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a0c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a10:	1007f793          	andi	a5,a5,256
    80001a14:	eba5                	bnez	a5,80001a84 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a16:	00003797          	auipc	a5,0x3
    80001a1a:	e2a78793          	addi	a5,a5,-470 # 80004840 <kernelvec>
    80001a1e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a22:	b62ff0ef          	jal	80000d84 <myproc>
    80001a26:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a28:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a2a:	14102773          	csrr	a4,sepc
    80001a2e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a30:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a34:	47a1                	li	a5,8
    80001a36:	04f70d63          	beq	a4,a5,80001a90 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a3a:	f53ff0ef          	jal	8000198c <devintr>
    80001a3e:	892a                	mv	s2,a0
    80001a40:	e945                	bnez	a0,80001af0 <usertrap+0xf0>
    80001a42:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a46:	47bd                	li	a5,15
    80001a48:	08f70863          	beq	a4,a5,80001ad8 <usertrap+0xd8>
    80001a4c:	14202773          	csrr	a4,scause
    80001a50:	47b5                	li	a5,13
    80001a52:	08f70363          	beq	a4,a5,80001ad8 <usertrap+0xd8>
    80001a56:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a5a:	5890                	lw	a2,48(s1)
    80001a5c:	00005517          	auipc	a0,0x5
    80001a60:	7ec50513          	addi	a0,a0,2028 # 80007248 <etext+0x248>
    80001a64:	0d5030ef          	jal	80005338 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a68:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a6c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a70:	00006517          	auipc	a0,0x6
    80001a74:	80850513          	addi	a0,a0,-2040 # 80007278 <etext+0x278>
    80001a78:	0c1030ef          	jal	80005338 <printf>
    setkilled(p);
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	b1bff0ef          	jal	80001598 <setkilled>
    80001a82:	a035                	j	80001aae <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a84:	00005517          	auipc	a0,0x5
    80001a88:	7a450513          	addi	a0,a0,1956 # 80007228 <etext+0x228>
    80001a8c:	393030ef          	jal	8000561e <panic>
    if(killed(p))
    80001a90:	b2dff0ef          	jal	800015bc <killed>
    80001a94:	ed15                	bnez	a0,80001ad0 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001a96:	6cb8                	ld	a4,88(s1)
    80001a98:	6f1c                	ld	a5,24(a4)
    80001a9a:	0791                	addi	a5,a5,4
    80001a9c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a9e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001aa2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aa6:	10079073          	csrw	sstatus,a5
    syscall();
    80001aaa:	246000ef          	jal	80001cf0 <syscall>
  if(killed(p))
    80001aae:	8526                	mv	a0,s1
    80001ab0:	b0dff0ef          	jal	800015bc <killed>
    80001ab4:	e139                	bnez	a0,80001afa <usertrap+0xfa>
  prepare_return();
    80001ab6:	e09ff0ef          	jal	800018be <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001aba:	68a8                	ld	a0,80(s1)
    80001abc:	8131                	srli	a0,a0,0xc
    80001abe:	57fd                	li	a5,-1
    80001ac0:	17fe                	slli	a5,a5,0x3f
    80001ac2:	8d5d                	or	a0,a0,a5
}
    80001ac4:	60e2                	ld	ra,24(sp)
    80001ac6:	6442                	ld	s0,16(sp)
    80001ac8:	64a2                	ld	s1,8(sp)
    80001aca:	6902                	ld	s2,0(sp)
    80001acc:	6105                	addi	sp,sp,32
    80001ace:	8082                	ret
      kexit(-1);
    80001ad0:	557d                	li	a0,-1
    80001ad2:	9bfff0ef          	jal	80001490 <kexit>
    80001ad6:	b7c1                	j	80001a96 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ad8:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001adc:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001ae0:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001ae2:	00163613          	seqz	a2,a2
    80001ae6:	68a8                	ld	a0,80(s1)
    80001ae8:	f1ffe0ef          	jal	80000a06 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001aec:	f169                	bnez	a0,80001aae <usertrap+0xae>
    80001aee:	b7a5                	j	80001a56 <usertrap+0x56>
  if(killed(p))
    80001af0:	8526                	mv	a0,s1
    80001af2:	acbff0ef          	jal	800015bc <killed>
    80001af6:	c511                	beqz	a0,80001b02 <usertrap+0x102>
    80001af8:	a011                	j	80001afc <usertrap+0xfc>
    80001afa:	4901                	li	s2,0
    kexit(-1);
    80001afc:	557d                	li	a0,-1
    80001afe:	993ff0ef          	jal	80001490 <kexit>
  if(which_dev == 2)
    80001b02:	4789                	li	a5,2
    80001b04:	faf919e3          	bne	s2,a5,80001ab6 <usertrap+0xb6>
    yield();
    80001b08:	851ff0ef          	jal	80001358 <yield>
    80001b0c:	b76d                	j	80001ab6 <usertrap+0xb6>

0000000080001b0e <kerneltrap>:
{
    80001b0e:	7179                	addi	sp,sp,-48
    80001b10:	f406                	sd	ra,40(sp)
    80001b12:	f022                	sd	s0,32(sp)
    80001b14:	ec26                	sd	s1,24(sp)
    80001b16:	e84a                	sd	s2,16(sp)
    80001b18:	e44e                	sd	s3,8(sp)
    80001b1a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b1c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b20:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b24:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b28:	1004f793          	andi	a5,s1,256
    80001b2c:	c795                	beqz	a5,80001b58 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b2e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b32:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b34:	eb85                	bnez	a5,80001b64 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b36:	e57ff0ef          	jal	8000198c <devintr>
    80001b3a:	c91d                	beqz	a0,80001b70 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b3c:	4789                	li	a5,2
    80001b3e:	04f50a63          	beq	a0,a5,80001b92 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b42:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b46:	10049073          	csrw	sstatus,s1
}
    80001b4a:	70a2                	ld	ra,40(sp)
    80001b4c:	7402                	ld	s0,32(sp)
    80001b4e:	64e2                	ld	s1,24(sp)
    80001b50:	6942                	ld	s2,16(sp)
    80001b52:	69a2                	ld	s3,8(sp)
    80001b54:	6145                	addi	sp,sp,48
    80001b56:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b58:	00005517          	auipc	a0,0x5
    80001b5c:	74850513          	addi	a0,a0,1864 # 800072a0 <etext+0x2a0>
    80001b60:	2bf030ef          	jal	8000561e <panic>
    panic("kerneltrap: interrupts enabled");
    80001b64:	00005517          	auipc	a0,0x5
    80001b68:	76450513          	addi	a0,a0,1892 # 800072c8 <etext+0x2c8>
    80001b6c:	2b3030ef          	jal	8000561e <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b70:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b74:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b78:	85ce                	mv	a1,s3
    80001b7a:	00005517          	auipc	a0,0x5
    80001b7e:	76e50513          	addi	a0,a0,1902 # 800072e8 <etext+0x2e8>
    80001b82:	7b6030ef          	jal	80005338 <printf>
    panic("kerneltrap");
    80001b86:	00005517          	auipc	a0,0x5
    80001b8a:	78a50513          	addi	a0,a0,1930 # 80007310 <etext+0x310>
    80001b8e:	291030ef          	jal	8000561e <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b92:	9f2ff0ef          	jal	80000d84 <myproc>
    80001b96:	d555                	beqz	a0,80001b42 <kerneltrap+0x34>
    yield();
    80001b98:	fc0ff0ef          	jal	80001358 <yield>
    80001b9c:	b75d                	j	80001b42 <kerneltrap+0x34>

0000000080001b9e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
    80001ba8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001baa:	9daff0ef          	jal	80000d84 <myproc>
  switch (n) {
    80001bae:	4795                	li	a5,5
    80001bb0:	0497e163          	bltu	a5,s1,80001bf2 <argraw+0x54>
    80001bb4:	048a                	slli	s1,s1,0x2
    80001bb6:	00006717          	auipc	a4,0x6
    80001bba:	c5270713          	addi	a4,a4,-942 # 80007808 <states.0+0x30>
    80001bbe:	94ba                	add	s1,s1,a4
    80001bc0:	409c                	lw	a5,0(s1)
    80001bc2:	97ba                	add	a5,a5,a4
    80001bc4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bc6:	6d3c                	ld	a5,88(a0)
    80001bc8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bca:	60e2                	ld	ra,24(sp)
    80001bcc:	6442                	ld	s0,16(sp)
    80001bce:	64a2                	ld	s1,8(sp)
    80001bd0:	6105                	addi	sp,sp,32
    80001bd2:	8082                	ret
    return p->trapframe->a1;
    80001bd4:	6d3c                	ld	a5,88(a0)
    80001bd6:	7fa8                	ld	a0,120(a5)
    80001bd8:	bfcd                	j	80001bca <argraw+0x2c>
    return p->trapframe->a2;
    80001bda:	6d3c                	ld	a5,88(a0)
    80001bdc:	63c8                	ld	a0,128(a5)
    80001bde:	b7f5                	j	80001bca <argraw+0x2c>
    return p->trapframe->a3;
    80001be0:	6d3c                	ld	a5,88(a0)
    80001be2:	67c8                	ld	a0,136(a5)
    80001be4:	b7dd                	j	80001bca <argraw+0x2c>
    return p->trapframe->a4;
    80001be6:	6d3c                	ld	a5,88(a0)
    80001be8:	6bc8                	ld	a0,144(a5)
    80001bea:	b7c5                	j	80001bca <argraw+0x2c>
    return p->trapframe->a5;
    80001bec:	6d3c                	ld	a5,88(a0)
    80001bee:	6fc8                	ld	a0,152(a5)
    80001bf0:	bfe9                	j	80001bca <argraw+0x2c>
  panic("argraw");
    80001bf2:	00005517          	auipc	a0,0x5
    80001bf6:	72e50513          	addi	a0,a0,1838 # 80007320 <etext+0x320>
    80001bfa:	225030ef          	jal	8000561e <panic>

0000000080001bfe <fetchaddr>:
{
    80001bfe:	1101                	addi	sp,sp,-32
    80001c00:	ec06                	sd	ra,24(sp)
    80001c02:	e822                	sd	s0,16(sp)
    80001c04:	e426                	sd	s1,8(sp)
    80001c06:	e04a                	sd	s2,0(sp)
    80001c08:	1000                	addi	s0,sp,32
    80001c0a:	84aa                	mv	s1,a0
    80001c0c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c0e:	976ff0ef          	jal	80000d84 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c12:	653c                	ld	a5,72(a0)
    80001c14:	02f4f663          	bgeu	s1,a5,80001c40 <fetchaddr+0x42>
    80001c18:	00848713          	addi	a4,s1,8
    80001c1c:	02e7e463          	bltu	a5,a4,80001c44 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c20:	46a1                	li	a3,8
    80001c22:	8626                	mv	a2,s1
    80001c24:	85ca                	mv	a1,s2
    80001c26:	6928                	ld	a0,80(a0)
    80001c28:	f55fe0ef          	jal	80000b7c <copyin>
    80001c2c:	00a03533          	snez	a0,a0
    80001c30:	40a00533          	neg	a0,a0
}
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6902                	ld	s2,0(sp)
    80001c3c:	6105                	addi	sp,sp,32
    80001c3e:	8082                	ret
    return -1;
    80001c40:	557d                	li	a0,-1
    80001c42:	bfcd                	j	80001c34 <fetchaddr+0x36>
    80001c44:	557d                	li	a0,-1
    80001c46:	b7fd                	j	80001c34 <fetchaddr+0x36>

0000000080001c48 <fetchstr>:
{
    80001c48:	7179                	addi	sp,sp,-48
    80001c4a:	f406                	sd	ra,40(sp)
    80001c4c:	f022                	sd	s0,32(sp)
    80001c4e:	ec26                	sd	s1,24(sp)
    80001c50:	e84a                	sd	s2,16(sp)
    80001c52:	e44e                	sd	s3,8(sp)
    80001c54:	1800                	addi	s0,sp,48
    80001c56:	892a                	mv	s2,a0
    80001c58:	84ae                	mv	s1,a1
    80001c5a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c5c:	928ff0ef          	jal	80000d84 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c60:	86ce                	mv	a3,s3
    80001c62:	864a                	mv	a2,s2
    80001c64:	85a6                	mv	a1,s1
    80001c66:	6928                	ld	a0,80(a0)
    80001c68:	cc7fe0ef          	jal	8000092e <copyinstr>
    80001c6c:	00054c63          	bltz	a0,80001c84 <fetchstr+0x3c>
  return strlen(buf);
    80001c70:	8526                	mv	a0,s1
    80001c72:	e32fe0ef          	jal	800002a4 <strlen>
}
    80001c76:	70a2                	ld	ra,40(sp)
    80001c78:	7402                	ld	s0,32(sp)
    80001c7a:	64e2                	ld	s1,24(sp)
    80001c7c:	6942                	ld	s2,16(sp)
    80001c7e:	69a2                	ld	s3,8(sp)
    80001c80:	6145                	addi	sp,sp,48
    80001c82:	8082                	ret
    return -1;
    80001c84:	557d                	li	a0,-1
    80001c86:	bfc5                	j	80001c76 <fetchstr+0x2e>

0000000080001c88 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c88:	1101                	addi	sp,sp,-32
    80001c8a:	ec06                	sd	ra,24(sp)
    80001c8c:	e822                	sd	s0,16(sp)
    80001c8e:	e426                	sd	s1,8(sp)
    80001c90:	1000                	addi	s0,sp,32
    80001c92:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c94:	f0bff0ef          	jal	80001b9e <argraw>
    80001c98:	c088                	sw	a0,0(s1)
}
    80001c9a:	60e2                	ld	ra,24(sp)
    80001c9c:	6442                	ld	s0,16(sp)
    80001c9e:	64a2                	ld	s1,8(sp)
    80001ca0:	6105                	addi	sp,sp,32
    80001ca2:	8082                	ret

0000000080001ca4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001ca4:	1101                	addi	sp,sp,-32
    80001ca6:	ec06                	sd	ra,24(sp)
    80001ca8:	e822                	sd	s0,16(sp)
    80001caa:	e426                	sd	s1,8(sp)
    80001cac:	1000                	addi	s0,sp,32
    80001cae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cb0:	eefff0ef          	jal	80001b9e <argraw>
    80001cb4:	e088                	sd	a0,0(s1)
}
    80001cb6:	60e2                	ld	ra,24(sp)
    80001cb8:	6442                	ld	s0,16(sp)
    80001cba:	64a2                	ld	s1,8(sp)
    80001cbc:	6105                	addi	sp,sp,32
    80001cbe:	8082                	ret

0000000080001cc0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cc0:	7179                	addi	sp,sp,-48
    80001cc2:	f406                	sd	ra,40(sp)
    80001cc4:	f022                	sd	s0,32(sp)
    80001cc6:	ec26                	sd	s1,24(sp)
    80001cc8:	e84a                	sd	s2,16(sp)
    80001cca:	1800                	addi	s0,sp,48
    80001ccc:	84ae                	mv	s1,a1
    80001cce:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cd0:	fd840593          	addi	a1,s0,-40
    80001cd4:	fd1ff0ef          	jal	80001ca4 <argaddr>
  return fetchstr(addr, buf, max);
    80001cd8:	864a                	mv	a2,s2
    80001cda:	85a6                	mv	a1,s1
    80001cdc:	fd843503          	ld	a0,-40(s0)
    80001ce0:	f69ff0ef          	jal	80001c48 <fetchstr>
}
    80001ce4:	70a2                	ld	ra,40(sp)
    80001ce6:	7402                	ld	s0,32(sp)
    80001ce8:	64e2                	ld	s1,24(sp)
    80001cea:	6942                	ld	s2,16(sp)
    80001cec:	6145                	addi	sp,sp,48
    80001cee:	8082                	ret

0000000080001cf0 <syscall>:
[SYS_monitor] "monitor",
};

void
syscall(void)
{
    80001cf0:	7179                	addi	sp,sp,-48
    80001cf2:	f406                	sd	ra,40(sp)
    80001cf4:	f022                	sd	s0,32(sp)
    80001cf6:	ec26                	sd	s1,24(sp)
    80001cf8:	e84a                	sd	s2,16(sp)
    80001cfa:	e44e                	sd	s3,8(sp)
    80001cfc:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001cfe:	886ff0ef          	jal	80000d84 <myproc>
    80001d02:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d04:	05853903          	ld	s2,88(a0)
    80001d08:	0a893783          	ld	a5,168(s2)
    80001d0c:	0007899b          	sext.w	s3,a5
  // a7 contains the syscall number
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d10:	37fd                	addiw	a5,a5,-1
    80001d12:	4755                	li	a4,21
    80001d14:	04f76563          	bltu	a4,a5,80001d5e <syscall+0x6e>
    80001d18:	00399713          	slli	a4,s3,0x3
    80001d1c:	00006797          	auipc	a5,0x6
    80001d20:	b0478793          	addi	a5,a5,-1276 # 80007820 <syscalls>
    80001d24:	97ba                	add	a5,a5,a4
    80001d26:	639c                	ld	a5,0(a5)
    80001d28:	cb9d                	beqz	a5,80001d5e <syscall+0x6e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d2a:	9782                	jalr	a5
    80001d2c:	06a93823          	sd	a0,112(s2)

    if((p->monitor_mask >> num) & 1)
    80001d30:	1684a783          	lw	a5,360(s1)
    80001d34:	0137d7bb          	srlw	a5,a5,s3
    80001d38:	8b85                	andi	a5,a5,1
    80001d3a:	cf9d                	beqz	a5,80001d78 <syscall+0x88>
    // shifts bit to least significant position and masks out other bits
    // eg. if num=3, monitor_mask=1011 (binary)
    // then (1011 >> 3) = 0001
    // and (0001 & 1) = 1, so the syscall is monitored
    {
      printf("%d: syscall %s -> %ld\n", p->pid, syscall_names[num], p->trapframe->a0);
    80001d3c:	6cb8                	ld	a4,88(s1)
    80001d3e:	098e                	slli	s3,s3,0x3
    80001d40:	00006797          	auipc	a5,0x6
    80001d44:	ae078793          	addi	a5,a5,-1312 # 80007820 <syscalls>
    80001d48:	97ce                	add	a5,a5,s3
    80001d4a:	7b34                	ld	a3,112(a4)
    80001d4c:	7fd0                	ld	a2,184(a5)
    80001d4e:	588c                	lw	a1,48(s1)
    80001d50:	00005517          	auipc	a0,0x5
    80001d54:	5d850513          	addi	a0,a0,1496 # 80007328 <etext+0x328>
    80001d58:	5e0030ef          	jal	80005338 <printf>
    80001d5c:	a831                	j	80001d78 <syscall+0x88>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d5e:	86ce                	mv	a3,s3
    80001d60:	15848613          	addi	a2,s1,344
    80001d64:	588c                	lw	a1,48(s1)
    80001d66:	00005517          	auipc	a0,0x5
    80001d6a:	5da50513          	addi	a0,a0,1498 # 80007340 <etext+0x340>
    80001d6e:	5ca030ef          	jal	80005338 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d72:	6cbc                	ld	a5,88(s1)
    80001d74:	577d                	li	a4,-1
    80001d76:	fbb8                	sd	a4,112(a5)
  }
    80001d78:	70a2                	ld	ra,40(sp)
    80001d7a:	7402                	ld	s0,32(sp)
    80001d7c:	64e2                	ld	s1,24(sp)
    80001d7e:	6942                	ld	s2,16(sp)
    80001d80:	69a2                	ld	s3,8(sp)
    80001d82:	6145                	addi	sp,sp,48
    80001d84:	8082                	ret

0000000080001d86 <sys_exit>:
#include "fcntl.h"       // flags
#include "syscall.h"     // SYS_interpose

uint64
sys_exit(void)
{
    80001d86:	1101                	addi	sp,sp,-32
    80001d88:	ec06                	sd	ra,24(sp)
    80001d8a:	e822                	sd	s0,16(sp)
    80001d8c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d8e:	fec40593          	addi	a1,s0,-20
    80001d92:	4501                	li	a0,0
    80001d94:	ef5ff0ef          	jal	80001c88 <argint>
  kexit(n);
    80001d98:	fec42503          	lw	a0,-20(s0)
    80001d9c:	ef4ff0ef          	jal	80001490 <kexit>
  return 0;  // not reached
}
    80001da0:	4501                	li	a0,0
    80001da2:	60e2                	ld	ra,24(sp)
    80001da4:	6442                	ld	s0,16(sp)
    80001da6:	6105                	addi	sp,sp,32
    80001da8:	8082                	ret

0000000080001daa <sys_getpid>:

uint64
sys_getpid(void)
{
    80001daa:	1141                	addi	sp,sp,-16
    80001dac:	e406                	sd	ra,8(sp)
    80001dae:	e022                	sd	s0,0(sp)
    80001db0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001db2:	fd3fe0ef          	jal	80000d84 <myproc>
}
    80001db6:	5908                	lw	a0,48(a0)
    80001db8:	60a2                	ld	ra,8(sp)
    80001dba:	6402                	ld	s0,0(sp)
    80001dbc:	0141                	addi	sp,sp,16
    80001dbe:	8082                	ret

0000000080001dc0 <sys_fork>:

uint64
sys_fork(void)
{
    80001dc0:	1141                	addi	sp,sp,-16
    80001dc2:	e406                	sd	ra,8(sp)
    80001dc4:	e022                	sd	s0,0(sp)
    80001dc6:	0800                	addi	s0,sp,16
  return kfork();
    80001dc8:	b0eff0ef          	jal	800010d6 <kfork>
}
    80001dcc:	60a2                	ld	ra,8(sp)
    80001dce:	6402                	ld	s0,0(sp)
    80001dd0:	0141                	addi	sp,sp,16
    80001dd2:	8082                	ret

0000000080001dd4 <sys_wait>:

uint64
sys_wait(void)
{
    80001dd4:	1101                	addi	sp,sp,-32
    80001dd6:	ec06                	sd	ra,24(sp)
    80001dd8:	e822                	sd	s0,16(sp)
    80001dda:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001ddc:	fe840593          	addi	a1,s0,-24
    80001de0:	4501                	li	a0,0
    80001de2:	ec3ff0ef          	jal	80001ca4 <argaddr>
  return kwait(p);
    80001de6:	fe843503          	ld	a0,-24(s0)
    80001dea:	ffcff0ef          	jal	800015e6 <kwait>
}
    80001dee:	60e2                	ld	ra,24(sp)
    80001df0:	6442                	ld	s0,16(sp)
    80001df2:	6105                	addi	sp,sp,32
    80001df4:	8082                	ret

0000000080001df6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001df6:	7179                	addi	sp,sp,-48
    80001df8:	f406                	sd	ra,40(sp)
    80001dfa:	f022                	sd	s0,32(sp)
    80001dfc:	ec26                	sd	s1,24(sp)
    80001dfe:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001e00:	fd840593          	addi	a1,s0,-40
    80001e04:	4501                	li	a0,0
    80001e06:	e83ff0ef          	jal	80001c88 <argint>
  argint(1, &t);
    80001e0a:	fdc40593          	addi	a1,s0,-36
    80001e0e:	4505                	li	a0,1
    80001e10:	e79ff0ef          	jal	80001c88 <argint>
  addr = myproc()->sz;
    80001e14:	f71fe0ef          	jal	80000d84 <myproc>
    80001e18:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001e1a:	fdc42703          	lw	a4,-36(s0)
    80001e1e:	4785                	li	a5,1
    80001e20:	02f70163          	beq	a4,a5,80001e42 <sys_sbrk+0x4c>
    80001e24:	fd842783          	lw	a5,-40(s0)
    80001e28:	0007cd63          	bltz	a5,80001e42 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001e2c:	97a6                	add	a5,a5,s1
    80001e2e:	0297e863          	bltu	a5,s1,80001e5e <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001e32:	f53fe0ef          	jal	80000d84 <myproc>
    80001e36:	fd842703          	lw	a4,-40(s0)
    80001e3a:	653c                	ld	a5,72(a0)
    80001e3c:	97ba                	add	a5,a5,a4
    80001e3e:	e53c                	sd	a5,72(a0)
    80001e40:	a039                	j	80001e4e <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001e42:	fd842503          	lw	a0,-40(s0)
    80001e46:	a40ff0ef          	jal	80001086 <growproc>
    80001e4a:	00054863          	bltz	a0,80001e5a <sys_sbrk+0x64>
  }
  return addr;
}
    80001e4e:	8526                	mv	a0,s1
    80001e50:	70a2                	ld	ra,40(sp)
    80001e52:	7402                	ld	s0,32(sp)
    80001e54:	64e2                	ld	s1,24(sp)
    80001e56:	6145                	addi	sp,sp,48
    80001e58:	8082                	ret
      return -1;
    80001e5a:	54fd                	li	s1,-1
    80001e5c:	bfcd                	j	80001e4e <sys_sbrk+0x58>
      return -1;
    80001e5e:	54fd                	li	s1,-1
    80001e60:	b7fd                	j	80001e4e <sys_sbrk+0x58>

0000000080001e62 <sys_pause>:

uint64
sys_pause(void)
{
    80001e62:	7139                	addi	sp,sp,-64
    80001e64:	fc06                	sd	ra,56(sp)
    80001e66:	f822                	sd	s0,48(sp)
    80001e68:	f04a                	sd	s2,32(sp)
    80001e6a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e6c:	fcc40593          	addi	a1,s0,-52
    80001e70:	4501                	li	a0,0
    80001e72:	e17ff0ef          	jal	80001c88 <argint>
  if(n < 0)
    80001e76:	fcc42783          	lw	a5,-52(s0)
    80001e7a:	0607c763          	bltz	a5,80001ee8 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001e7e:	0000e517          	auipc	a0,0xe
    80001e82:	55250513          	addi	a0,a0,1362 # 800103d0 <tickslock>
    80001e86:	255030ef          	jal	800058da <acquire>
  ticks0 = ticks;
    80001e8a:	00008917          	auipc	s2,0x8
    80001e8e:	4de92903          	lw	s2,1246(s2) # 8000a368 <ticks>
  while(ticks - ticks0 < n){
    80001e92:	fcc42783          	lw	a5,-52(s0)
    80001e96:	cf8d                	beqz	a5,80001ed0 <sys_pause+0x6e>
    80001e98:	f426                	sd	s1,40(sp)
    80001e9a:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e9c:	0000e997          	auipc	s3,0xe
    80001ea0:	53498993          	addi	s3,s3,1332 # 800103d0 <tickslock>
    80001ea4:	00008497          	auipc	s1,0x8
    80001ea8:	4c448493          	addi	s1,s1,1220 # 8000a368 <ticks>
    if(killed(myproc())){
    80001eac:	ed9fe0ef          	jal	80000d84 <myproc>
    80001eb0:	f0cff0ef          	jal	800015bc <killed>
    80001eb4:	ed0d                	bnez	a0,80001eee <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001eb6:	85ce                	mv	a1,s3
    80001eb8:	8526                	mv	a0,s1
    80001eba:	ccaff0ef          	jal	80001384 <sleep>
  while(ticks - ticks0 < n){
    80001ebe:	409c                	lw	a5,0(s1)
    80001ec0:	412787bb          	subw	a5,a5,s2
    80001ec4:	fcc42703          	lw	a4,-52(s0)
    80001ec8:	fee7e2e3          	bltu	a5,a4,80001eac <sys_pause+0x4a>
    80001ecc:	74a2                	ld	s1,40(sp)
    80001ece:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ed0:	0000e517          	auipc	a0,0xe
    80001ed4:	50050513          	addi	a0,a0,1280 # 800103d0 <tickslock>
    80001ed8:	29b030ef          	jal	80005972 <release>
  return 0;
    80001edc:	4501                	li	a0,0
}
    80001ede:	70e2                	ld	ra,56(sp)
    80001ee0:	7442                	ld	s0,48(sp)
    80001ee2:	7902                	ld	s2,32(sp)
    80001ee4:	6121                	addi	sp,sp,64
    80001ee6:	8082                	ret
    n = 0;
    80001ee8:	fc042623          	sw	zero,-52(s0)
    80001eec:	bf49                	j	80001e7e <sys_pause+0x1c>
      release(&tickslock);
    80001eee:	0000e517          	auipc	a0,0xe
    80001ef2:	4e250513          	addi	a0,a0,1250 # 800103d0 <tickslock>
    80001ef6:	27d030ef          	jal	80005972 <release>
      return -1;
    80001efa:	557d                	li	a0,-1
    80001efc:	74a2                	ld	s1,40(sp)
    80001efe:	69e2                	ld	s3,24(sp)
    80001f00:	bff9                	j	80001ede <sys_pause+0x7c>

0000000080001f02 <sys_kill>:

uint64
sys_kill(void)
{
    80001f02:	1101                	addi	sp,sp,-32
    80001f04:	ec06                	sd	ra,24(sp)
    80001f06:	e822                	sd	s0,16(sp)
    80001f08:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f0a:	fec40593          	addi	a1,s0,-20
    80001f0e:	4501                	li	a0,0
    80001f10:	d79ff0ef          	jal	80001c88 <argint>
  return kkill(pid);
    80001f14:	fec42503          	lw	a0,-20(s0)
    80001f18:	e1aff0ef          	jal	80001532 <kkill>
}
    80001f1c:	60e2                	ld	ra,24(sp)
    80001f1e:	6442                	ld	s0,16(sp)
    80001f20:	6105                	addi	sp,sp,32
    80001f22:	8082                	ret

0000000080001f24 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f24:	1101                	addi	sp,sp,-32
    80001f26:	ec06                	sd	ra,24(sp)
    80001f28:	e822                	sd	s0,16(sp)
    80001f2a:	e426                	sd	s1,8(sp)
    80001f2c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f2e:	0000e517          	auipc	a0,0xe
    80001f32:	4a250513          	addi	a0,a0,1186 # 800103d0 <tickslock>
    80001f36:	1a5030ef          	jal	800058da <acquire>
  xticks = ticks;
    80001f3a:	00008497          	auipc	s1,0x8
    80001f3e:	42e4a483          	lw	s1,1070(s1) # 8000a368 <ticks>
  release(&tickslock);
    80001f42:	0000e517          	auipc	a0,0xe
    80001f46:	48e50513          	addi	a0,a0,1166 # 800103d0 <tickslock>
    80001f4a:	229030ef          	jal	80005972 <release>
  return xticks;
}
    80001f4e:	02049513          	slli	a0,s1,0x20
    80001f52:	9101                	srli	a0,a0,0x20
    80001f54:	60e2                	ld	ra,24(sp)
    80001f56:	6442                	ld	s0,16(sp)
    80001f58:	64a2                	ld	s1,8(sp)
    80001f5a:	6105                	addi	sp,sp,32
    80001f5c:	8082                	ret

0000000080001f5e <sys_monitor>:

uint64
sys_monitor(void)
{
    80001f5e:	1101                	addi	sp,sp,-32
    80001f60:	ec06                	sd	ra,24(sp)
    80001f62:	e822                	sd	s0,16(sp)
    80001f64:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80001f66:	fec40593          	addi	a1,s0,-20
    80001f6a:	4501                	li	a0,0
    80001f6c:	d1dff0ef          	jal	80001c88 <argint>

  struct proc *p = myproc();
    80001f70:	e15fe0ef          	jal	80000d84 <myproc>
  p->monitor_mask = (uint32)mask;
    80001f74:	fec42783          	lw	a5,-20(s0)
    80001f78:	16f52423          	sw	a5,360(a0)

  return 0;
    80001f7c:	4501                	li	a0,0
    80001f7e:	60e2                	ld	ra,24(sp)
    80001f80:	6442                	ld	s0,16(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret

0000000080001f86 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f86:	7179                	addi	sp,sp,-48
    80001f88:	f406                	sd	ra,40(sp)
    80001f8a:	f022                	sd	s0,32(sp)
    80001f8c:	ec26                	sd	s1,24(sp)
    80001f8e:	e84a                	sd	s2,16(sp)
    80001f90:	e44e                	sd	s3,8(sp)
    80001f92:	e052                	sd	s4,0(sp)
    80001f94:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f96:	00005597          	auipc	a1,0x5
    80001f9a:	46a58593          	addi	a1,a1,1130 # 80007400 <etext+0x400>
    80001f9e:	0000e517          	auipc	a0,0xe
    80001fa2:	44a50513          	addi	a0,a0,1098 # 800103e8 <bcache>
    80001fa6:	0b5030ef          	jal	8000585a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001faa:	00016797          	auipc	a5,0x16
    80001fae:	43e78793          	addi	a5,a5,1086 # 800183e8 <bcache+0x8000>
    80001fb2:	00016717          	auipc	a4,0x16
    80001fb6:	69e70713          	addi	a4,a4,1694 # 80018650 <bcache+0x8268>
    80001fba:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fbe:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fc2:	0000e497          	auipc	s1,0xe
    80001fc6:	43e48493          	addi	s1,s1,1086 # 80010400 <bcache+0x18>
    b->next = bcache.head.next;
    80001fca:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001fcc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001fce:	00005a17          	auipc	s4,0x5
    80001fd2:	43aa0a13          	addi	s4,s4,1082 # 80007408 <etext+0x408>
    b->next = bcache.head.next;
    80001fd6:	2b893783          	ld	a5,696(s2)
    80001fda:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001fdc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001fe0:	85d2                	mv	a1,s4
    80001fe2:	01048513          	addi	a0,s1,16
    80001fe6:	322010ef          	jal	80003308 <initsleeplock>
    bcache.head.next->prev = b;
    80001fea:	2b893783          	ld	a5,696(s2)
    80001fee:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001ff0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ff4:	45848493          	addi	s1,s1,1112
    80001ff8:	fd349fe3          	bne	s1,s3,80001fd6 <binit+0x50>
  }
}
    80001ffc:	70a2                	ld	ra,40(sp)
    80001ffe:	7402                	ld	s0,32(sp)
    80002000:	64e2                	ld	s1,24(sp)
    80002002:	6942                	ld	s2,16(sp)
    80002004:	69a2                	ld	s3,8(sp)
    80002006:	6a02                	ld	s4,0(sp)
    80002008:	6145                	addi	sp,sp,48
    8000200a:	8082                	ret

000000008000200c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000200c:	7179                	addi	sp,sp,-48
    8000200e:	f406                	sd	ra,40(sp)
    80002010:	f022                	sd	s0,32(sp)
    80002012:	ec26                	sd	s1,24(sp)
    80002014:	e84a                	sd	s2,16(sp)
    80002016:	e44e                	sd	s3,8(sp)
    80002018:	1800                	addi	s0,sp,48
    8000201a:	892a                	mv	s2,a0
    8000201c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000201e:	0000e517          	auipc	a0,0xe
    80002022:	3ca50513          	addi	a0,a0,970 # 800103e8 <bcache>
    80002026:	0b5030ef          	jal	800058da <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000202a:	00016497          	auipc	s1,0x16
    8000202e:	6764b483          	ld	s1,1654(s1) # 800186a0 <bcache+0x82b8>
    80002032:	00016797          	auipc	a5,0x16
    80002036:	61e78793          	addi	a5,a5,1566 # 80018650 <bcache+0x8268>
    8000203a:	02f48b63          	beq	s1,a5,80002070 <bread+0x64>
    8000203e:	873e                	mv	a4,a5
    80002040:	a021                	j	80002048 <bread+0x3c>
    80002042:	68a4                	ld	s1,80(s1)
    80002044:	02e48663          	beq	s1,a4,80002070 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002048:	449c                	lw	a5,8(s1)
    8000204a:	ff279ce3          	bne	a5,s2,80002042 <bread+0x36>
    8000204e:	44dc                	lw	a5,12(s1)
    80002050:	ff3799e3          	bne	a5,s3,80002042 <bread+0x36>
      b->refcnt++;
    80002054:	40bc                	lw	a5,64(s1)
    80002056:	2785                	addiw	a5,a5,1
    80002058:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000205a:	0000e517          	auipc	a0,0xe
    8000205e:	38e50513          	addi	a0,a0,910 # 800103e8 <bcache>
    80002062:	111030ef          	jal	80005972 <release>
      acquiresleep(&b->lock);
    80002066:	01048513          	addi	a0,s1,16
    8000206a:	2d4010ef          	jal	8000333e <acquiresleep>
      return b;
    8000206e:	a889                	j	800020c0 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002070:	00016497          	auipc	s1,0x16
    80002074:	6284b483          	ld	s1,1576(s1) # 80018698 <bcache+0x82b0>
    80002078:	00016797          	auipc	a5,0x16
    8000207c:	5d878793          	addi	a5,a5,1496 # 80018650 <bcache+0x8268>
    80002080:	00f48863          	beq	s1,a5,80002090 <bread+0x84>
    80002084:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002086:	40bc                	lw	a5,64(s1)
    80002088:	cb91                	beqz	a5,8000209c <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000208a:	64a4                	ld	s1,72(s1)
    8000208c:	fee49de3          	bne	s1,a4,80002086 <bread+0x7a>
  panic("bget: no buffers");
    80002090:	00005517          	auipc	a0,0x5
    80002094:	38050513          	addi	a0,a0,896 # 80007410 <etext+0x410>
    80002098:	586030ef          	jal	8000561e <panic>
      b->dev = dev;
    8000209c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020a0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020a4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020a8:	4785                	li	a5,1
    800020aa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020ac:	0000e517          	auipc	a0,0xe
    800020b0:	33c50513          	addi	a0,a0,828 # 800103e8 <bcache>
    800020b4:	0bf030ef          	jal	80005972 <release>
      acquiresleep(&b->lock);
    800020b8:	01048513          	addi	a0,s1,16
    800020bc:	282010ef          	jal	8000333e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020c0:	409c                	lw	a5,0(s1)
    800020c2:	cb89                	beqz	a5,800020d4 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020c4:	8526                	mv	a0,s1
    800020c6:	70a2                	ld	ra,40(sp)
    800020c8:	7402                	ld	s0,32(sp)
    800020ca:	64e2                	ld	s1,24(sp)
    800020cc:	6942                	ld	s2,16(sp)
    800020ce:	69a2                	ld	s3,8(sp)
    800020d0:	6145                	addi	sp,sp,48
    800020d2:	8082                	ret
    virtio_disk_rw(b, 0);
    800020d4:	4581                	li	a1,0
    800020d6:	8526                	mv	a0,s1
    800020d8:	2c9020ef          	jal	80004ba0 <virtio_disk_rw>
    b->valid = 1;
    800020dc:	4785                	li	a5,1
    800020de:	c09c                	sw	a5,0(s1)
  return b;
    800020e0:	b7d5                	j	800020c4 <bread+0xb8>

00000000800020e2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020e2:	1101                	addi	sp,sp,-32
    800020e4:	ec06                	sd	ra,24(sp)
    800020e6:	e822                	sd	s0,16(sp)
    800020e8:	e426                	sd	s1,8(sp)
    800020ea:	1000                	addi	s0,sp,32
    800020ec:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020ee:	0541                	addi	a0,a0,16
    800020f0:	2cc010ef          	jal	800033bc <holdingsleep>
    800020f4:	c911                	beqz	a0,80002108 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020f6:	4585                	li	a1,1
    800020f8:	8526                	mv	a0,s1
    800020fa:	2a7020ef          	jal	80004ba0 <virtio_disk_rw>
}
    800020fe:	60e2                	ld	ra,24(sp)
    80002100:	6442                	ld	s0,16(sp)
    80002102:	64a2                	ld	s1,8(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret
    panic("bwrite");
    80002108:	00005517          	auipc	a0,0x5
    8000210c:	32050513          	addi	a0,a0,800 # 80007428 <etext+0x428>
    80002110:	50e030ef          	jal	8000561e <panic>

0000000080002114 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002114:	1101                	addi	sp,sp,-32
    80002116:	ec06                	sd	ra,24(sp)
    80002118:	e822                	sd	s0,16(sp)
    8000211a:	e426                	sd	s1,8(sp)
    8000211c:	e04a                	sd	s2,0(sp)
    8000211e:	1000                	addi	s0,sp,32
    80002120:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002122:	01050913          	addi	s2,a0,16
    80002126:	854a                	mv	a0,s2
    80002128:	294010ef          	jal	800033bc <holdingsleep>
    8000212c:	c135                	beqz	a0,80002190 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000212e:	854a                	mv	a0,s2
    80002130:	254010ef          	jal	80003384 <releasesleep>

  acquire(&bcache.lock);
    80002134:	0000e517          	auipc	a0,0xe
    80002138:	2b450513          	addi	a0,a0,692 # 800103e8 <bcache>
    8000213c:	79e030ef          	jal	800058da <acquire>
  b->refcnt--;
    80002140:	40bc                	lw	a5,64(s1)
    80002142:	37fd                	addiw	a5,a5,-1
    80002144:	0007871b          	sext.w	a4,a5
    80002148:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000214a:	e71d                	bnez	a4,80002178 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000214c:	68b8                	ld	a4,80(s1)
    8000214e:	64bc                	ld	a5,72(s1)
    80002150:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002152:	68b8                	ld	a4,80(s1)
    80002154:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002156:	00016797          	auipc	a5,0x16
    8000215a:	29278793          	addi	a5,a5,658 # 800183e8 <bcache+0x8000>
    8000215e:	2b87b703          	ld	a4,696(a5)
    80002162:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002164:	00016717          	auipc	a4,0x16
    80002168:	4ec70713          	addi	a4,a4,1260 # 80018650 <bcache+0x8268>
    8000216c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000216e:	2b87b703          	ld	a4,696(a5)
    80002172:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002174:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002178:	0000e517          	auipc	a0,0xe
    8000217c:	27050513          	addi	a0,a0,624 # 800103e8 <bcache>
    80002180:	7f2030ef          	jal	80005972 <release>
}
    80002184:	60e2                	ld	ra,24(sp)
    80002186:	6442                	ld	s0,16(sp)
    80002188:	64a2                	ld	s1,8(sp)
    8000218a:	6902                	ld	s2,0(sp)
    8000218c:	6105                	addi	sp,sp,32
    8000218e:	8082                	ret
    panic("brelse");
    80002190:	00005517          	auipc	a0,0x5
    80002194:	2a050513          	addi	a0,a0,672 # 80007430 <etext+0x430>
    80002198:	486030ef          	jal	8000561e <panic>

000000008000219c <bpin>:

void
bpin(struct buf *b) {
    8000219c:	1101                	addi	sp,sp,-32
    8000219e:	ec06                	sd	ra,24(sp)
    800021a0:	e822                	sd	s0,16(sp)
    800021a2:	e426                	sd	s1,8(sp)
    800021a4:	1000                	addi	s0,sp,32
    800021a6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021a8:	0000e517          	auipc	a0,0xe
    800021ac:	24050513          	addi	a0,a0,576 # 800103e8 <bcache>
    800021b0:	72a030ef          	jal	800058da <acquire>
  b->refcnt++;
    800021b4:	40bc                	lw	a5,64(s1)
    800021b6:	2785                	addiw	a5,a5,1
    800021b8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021ba:	0000e517          	auipc	a0,0xe
    800021be:	22e50513          	addi	a0,a0,558 # 800103e8 <bcache>
    800021c2:	7b0030ef          	jal	80005972 <release>
}
    800021c6:	60e2                	ld	ra,24(sp)
    800021c8:	6442                	ld	s0,16(sp)
    800021ca:	64a2                	ld	s1,8(sp)
    800021cc:	6105                	addi	sp,sp,32
    800021ce:	8082                	ret

00000000800021d0 <bunpin>:

void
bunpin(struct buf *b) {
    800021d0:	1101                	addi	sp,sp,-32
    800021d2:	ec06                	sd	ra,24(sp)
    800021d4:	e822                	sd	s0,16(sp)
    800021d6:	e426                	sd	s1,8(sp)
    800021d8:	1000                	addi	s0,sp,32
    800021da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021dc:	0000e517          	auipc	a0,0xe
    800021e0:	20c50513          	addi	a0,a0,524 # 800103e8 <bcache>
    800021e4:	6f6030ef          	jal	800058da <acquire>
  b->refcnt--;
    800021e8:	40bc                	lw	a5,64(s1)
    800021ea:	37fd                	addiw	a5,a5,-1
    800021ec:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021ee:	0000e517          	auipc	a0,0xe
    800021f2:	1fa50513          	addi	a0,a0,506 # 800103e8 <bcache>
    800021f6:	77c030ef          	jal	80005972 <release>
}
    800021fa:	60e2                	ld	ra,24(sp)
    800021fc:	6442                	ld	s0,16(sp)
    800021fe:	64a2                	ld	s1,8(sp)
    80002200:	6105                	addi	sp,sp,32
    80002202:	8082                	ret

0000000080002204 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002204:	1101                	addi	sp,sp,-32
    80002206:	ec06                	sd	ra,24(sp)
    80002208:	e822                	sd	s0,16(sp)
    8000220a:	e426                	sd	s1,8(sp)
    8000220c:	e04a                	sd	s2,0(sp)
    8000220e:	1000                	addi	s0,sp,32
    80002210:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002212:	00d5d59b          	srliw	a1,a1,0xd
    80002216:	00017797          	auipc	a5,0x17
    8000221a:	8ae7a783          	lw	a5,-1874(a5) # 80018ac4 <sb+0x1c>
    8000221e:	9dbd                	addw	a1,a1,a5
    80002220:	dedff0ef          	jal	8000200c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002224:	0074f713          	andi	a4,s1,7
    80002228:	4785                	li	a5,1
    8000222a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000222e:	14ce                	slli	s1,s1,0x33
    80002230:	90d9                	srli	s1,s1,0x36
    80002232:	00950733          	add	a4,a0,s1
    80002236:	05874703          	lbu	a4,88(a4)
    8000223a:	00e7f6b3          	and	a3,a5,a4
    8000223e:	c29d                	beqz	a3,80002264 <bfree+0x60>
    80002240:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002242:	94aa                	add	s1,s1,a0
    80002244:	fff7c793          	not	a5,a5
    80002248:	8f7d                	and	a4,a4,a5
    8000224a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000224e:	7f9000ef          	jal	80003246 <log_write>
  brelse(bp);
    80002252:	854a                	mv	a0,s2
    80002254:	ec1ff0ef          	jal	80002114 <brelse>
}
    80002258:	60e2                	ld	ra,24(sp)
    8000225a:	6442                	ld	s0,16(sp)
    8000225c:	64a2                	ld	s1,8(sp)
    8000225e:	6902                	ld	s2,0(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret
    panic("freeing free block");
    80002264:	00005517          	auipc	a0,0x5
    80002268:	1d450513          	addi	a0,a0,468 # 80007438 <etext+0x438>
    8000226c:	3b2030ef          	jal	8000561e <panic>

0000000080002270 <balloc>:
{
    80002270:	711d                	addi	sp,sp,-96
    80002272:	ec86                	sd	ra,88(sp)
    80002274:	e8a2                	sd	s0,80(sp)
    80002276:	e4a6                	sd	s1,72(sp)
    80002278:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000227a:	00017797          	auipc	a5,0x17
    8000227e:	8327a783          	lw	a5,-1998(a5) # 80018aac <sb+0x4>
    80002282:	0e078f63          	beqz	a5,80002380 <balloc+0x110>
    80002286:	e0ca                	sd	s2,64(sp)
    80002288:	fc4e                	sd	s3,56(sp)
    8000228a:	f852                	sd	s4,48(sp)
    8000228c:	f456                	sd	s5,40(sp)
    8000228e:	f05a                	sd	s6,32(sp)
    80002290:	ec5e                	sd	s7,24(sp)
    80002292:	e862                	sd	s8,16(sp)
    80002294:	e466                	sd	s9,8(sp)
    80002296:	8baa                	mv	s7,a0
    80002298:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000229a:	00017b17          	auipc	s6,0x17
    8000229e:	80eb0b13          	addi	s6,s6,-2034 # 80018aa8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022a2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022a4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022a6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022a8:	6c89                	lui	s9,0x2
    800022aa:	a0b5                	j	80002316 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022ac:	97ca                	add	a5,a5,s2
    800022ae:	8e55                	or	a2,a2,a3
    800022b0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022b4:	854a                	mv	a0,s2
    800022b6:	791000ef          	jal	80003246 <log_write>
        brelse(bp);
    800022ba:	854a                	mv	a0,s2
    800022bc:	e59ff0ef          	jal	80002114 <brelse>
  bp = bread(dev, bno);
    800022c0:	85a6                	mv	a1,s1
    800022c2:	855e                	mv	a0,s7
    800022c4:	d49ff0ef          	jal	8000200c <bread>
    800022c8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022ca:	40000613          	li	a2,1024
    800022ce:	4581                	li	a1,0
    800022d0:	05850513          	addi	a0,a0,88
    800022d4:	e61fd0ef          	jal	80000134 <memset>
  log_write(bp);
    800022d8:	854a                	mv	a0,s2
    800022da:	76d000ef          	jal	80003246 <log_write>
  brelse(bp);
    800022de:	854a                	mv	a0,s2
    800022e0:	e35ff0ef          	jal	80002114 <brelse>
}
    800022e4:	6906                	ld	s2,64(sp)
    800022e6:	79e2                	ld	s3,56(sp)
    800022e8:	7a42                	ld	s4,48(sp)
    800022ea:	7aa2                	ld	s5,40(sp)
    800022ec:	7b02                	ld	s6,32(sp)
    800022ee:	6be2                	ld	s7,24(sp)
    800022f0:	6c42                	ld	s8,16(sp)
    800022f2:	6ca2                	ld	s9,8(sp)
}
    800022f4:	8526                	mv	a0,s1
    800022f6:	60e6                	ld	ra,88(sp)
    800022f8:	6446                	ld	s0,80(sp)
    800022fa:	64a6                	ld	s1,72(sp)
    800022fc:	6125                	addi	sp,sp,96
    800022fe:	8082                	ret
    brelse(bp);
    80002300:	854a                	mv	a0,s2
    80002302:	e13ff0ef          	jal	80002114 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002306:	015c87bb          	addw	a5,s9,s5
    8000230a:	00078a9b          	sext.w	s5,a5
    8000230e:	004b2703          	lw	a4,4(s6)
    80002312:	04eaff63          	bgeu	s5,a4,80002370 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002316:	41fad79b          	sraiw	a5,s5,0x1f
    8000231a:	0137d79b          	srliw	a5,a5,0x13
    8000231e:	015787bb          	addw	a5,a5,s5
    80002322:	40d7d79b          	sraiw	a5,a5,0xd
    80002326:	01cb2583          	lw	a1,28(s6)
    8000232a:	9dbd                	addw	a1,a1,a5
    8000232c:	855e                	mv	a0,s7
    8000232e:	cdfff0ef          	jal	8000200c <bread>
    80002332:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002334:	004b2503          	lw	a0,4(s6)
    80002338:	000a849b          	sext.w	s1,s5
    8000233c:	8762                	mv	a4,s8
    8000233e:	fca4f1e3          	bgeu	s1,a0,80002300 <balloc+0x90>
      m = 1 << (bi % 8);
    80002342:	00777693          	andi	a3,a4,7
    80002346:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000234a:	41f7579b          	sraiw	a5,a4,0x1f
    8000234e:	01d7d79b          	srliw	a5,a5,0x1d
    80002352:	9fb9                	addw	a5,a5,a4
    80002354:	4037d79b          	sraiw	a5,a5,0x3
    80002358:	00f90633          	add	a2,s2,a5
    8000235c:	05864603          	lbu	a2,88(a2)
    80002360:	00c6f5b3          	and	a1,a3,a2
    80002364:	d5a1                	beqz	a1,800022ac <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002366:	2705                	addiw	a4,a4,1
    80002368:	2485                	addiw	s1,s1,1
    8000236a:	fd471ae3          	bne	a4,s4,8000233e <balloc+0xce>
    8000236e:	bf49                	j	80002300 <balloc+0x90>
    80002370:	6906                	ld	s2,64(sp)
    80002372:	79e2                	ld	s3,56(sp)
    80002374:	7a42                	ld	s4,48(sp)
    80002376:	7aa2                	ld	s5,40(sp)
    80002378:	7b02                	ld	s6,32(sp)
    8000237a:	6be2                	ld	s7,24(sp)
    8000237c:	6c42                	ld	s8,16(sp)
    8000237e:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002380:	00005517          	auipc	a0,0x5
    80002384:	0d050513          	addi	a0,a0,208 # 80007450 <etext+0x450>
    80002388:	7b1020ef          	jal	80005338 <printf>
  return 0;
    8000238c:	4481                	li	s1,0
    8000238e:	b79d                	j	800022f4 <balloc+0x84>

0000000080002390 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002390:	7179                	addi	sp,sp,-48
    80002392:	f406                	sd	ra,40(sp)
    80002394:	f022                	sd	s0,32(sp)
    80002396:	ec26                	sd	s1,24(sp)
    80002398:	e84a                	sd	s2,16(sp)
    8000239a:	e44e                	sd	s3,8(sp)
    8000239c:	1800                	addi	s0,sp,48
    8000239e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023a0:	47ad                	li	a5,11
    800023a2:	02b7e663          	bltu	a5,a1,800023ce <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023a6:	02059793          	slli	a5,a1,0x20
    800023aa:	01e7d593          	srli	a1,a5,0x1e
    800023ae:	00b504b3          	add	s1,a0,a1
    800023b2:	0504a903          	lw	s2,80(s1)
    800023b6:	06091a63          	bnez	s2,8000242a <bmap+0x9a>
      addr = balloc(ip->dev);
    800023ba:	4108                	lw	a0,0(a0)
    800023bc:	eb5ff0ef          	jal	80002270 <balloc>
    800023c0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023c4:	06090363          	beqz	s2,8000242a <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800023c8:	0524a823          	sw	s2,80(s1)
    800023cc:	a8b9                	j	8000242a <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023ce:	ff45849b          	addiw	s1,a1,-12
    800023d2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023d6:	0ff00793          	li	a5,255
    800023da:	06e7ee63          	bltu	a5,a4,80002456 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023de:	08052903          	lw	s2,128(a0)
    800023e2:	00091d63          	bnez	s2,800023fc <bmap+0x6c>
      addr = balloc(ip->dev);
    800023e6:	4108                	lw	a0,0(a0)
    800023e8:	e89ff0ef          	jal	80002270 <balloc>
    800023ec:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023f0:	02090d63          	beqz	s2,8000242a <bmap+0x9a>
    800023f4:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023f6:	0929a023          	sw	s2,128(s3)
    800023fa:	a011                	j	800023fe <bmap+0x6e>
    800023fc:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023fe:	85ca                	mv	a1,s2
    80002400:	0009a503          	lw	a0,0(s3)
    80002404:	c09ff0ef          	jal	8000200c <bread>
    80002408:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000240a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000240e:	02049713          	slli	a4,s1,0x20
    80002412:	01e75593          	srli	a1,a4,0x1e
    80002416:	00b784b3          	add	s1,a5,a1
    8000241a:	0004a903          	lw	s2,0(s1)
    8000241e:	00090e63          	beqz	s2,8000243a <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002422:	8552                	mv	a0,s4
    80002424:	cf1ff0ef          	jal	80002114 <brelse>
    return addr;
    80002428:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000242a:	854a                	mv	a0,s2
    8000242c:	70a2                	ld	ra,40(sp)
    8000242e:	7402                	ld	s0,32(sp)
    80002430:	64e2                	ld	s1,24(sp)
    80002432:	6942                	ld	s2,16(sp)
    80002434:	69a2                	ld	s3,8(sp)
    80002436:	6145                	addi	sp,sp,48
    80002438:	8082                	ret
      addr = balloc(ip->dev);
    8000243a:	0009a503          	lw	a0,0(s3)
    8000243e:	e33ff0ef          	jal	80002270 <balloc>
    80002442:	0005091b          	sext.w	s2,a0
      if(addr){
    80002446:	fc090ee3          	beqz	s2,80002422 <bmap+0x92>
        a[bn] = addr;
    8000244a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000244e:	8552                	mv	a0,s4
    80002450:	5f7000ef          	jal	80003246 <log_write>
    80002454:	b7f9                	j	80002422 <bmap+0x92>
    80002456:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002458:	00005517          	auipc	a0,0x5
    8000245c:	01050513          	addi	a0,a0,16 # 80007468 <etext+0x468>
    80002460:	1be030ef          	jal	8000561e <panic>

0000000080002464 <iget>:
{
    80002464:	7179                	addi	sp,sp,-48
    80002466:	f406                	sd	ra,40(sp)
    80002468:	f022                	sd	s0,32(sp)
    8000246a:	ec26                	sd	s1,24(sp)
    8000246c:	e84a                	sd	s2,16(sp)
    8000246e:	e44e                	sd	s3,8(sp)
    80002470:	e052                	sd	s4,0(sp)
    80002472:	1800                	addi	s0,sp,48
    80002474:	89aa                	mv	s3,a0
    80002476:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002478:	00016517          	auipc	a0,0x16
    8000247c:	65050513          	addi	a0,a0,1616 # 80018ac8 <itable>
    80002480:	45a030ef          	jal	800058da <acquire>
  empty = 0;
    80002484:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002486:	00016497          	auipc	s1,0x16
    8000248a:	65a48493          	addi	s1,s1,1626 # 80018ae0 <itable+0x18>
    8000248e:	00018697          	auipc	a3,0x18
    80002492:	0e268693          	addi	a3,a3,226 # 8001a570 <log>
    80002496:	a039                	j	800024a4 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002498:	02090963          	beqz	s2,800024ca <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000249c:	08848493          	addi	s1,s1,136
    800024a0:	02d48863          	beq	s1,a3,800024d0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024a4:	449c                	lw	a5,8(s1)
    800024a6:	fef059e3          	blez	a5,80002498 <iget+0x34>
    800024aa:	4098                	lw	a4,0(s1)
    800024ac:	ff3716e3          	bne	a4,s3,80002498 <iget+0x34>
    800024b0:	40d8                	lw	a4,4(s1)
    800024b2:	ff4713e3          	bne	a4,s4,80002498 <iget+0x34>
      ip->ref++;
    800024b6:	2785                	addiw	a5,a5,1
    800024b8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024ba:	00016517          	auipc	a0,0x16
    800024be:	60e50513          	addi	a0,a0,1550 # 80018ac8 <itable>
    800024c2:	4b0030ef          	jal	80005972 <release>
      return ip;
    800024c6:	8926                	mv	s2,s1
    800024c8:	a02d                	j	800024f2 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024ca:	fbe9                	bnez	a5,8000249c <iget+0x38>
      empty = ip;
    800024cc:	8926                	mv	s2,s1
    800024ce:	b7f9                	j	8000249c <iget+0x38>
  if(empty == 0)
    800024d0:	02090a63          	beqz	s2,80002504 <iget+0xa0>
  ip->dev = dev;
    800024d4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024d8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024dc:	4785                	li	a5,1
    800024de:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024e2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024e6:	00016517          	auipc	a0,0x16
    800024ea:	5e250513          	addi	a0,a0,1506 # 80018ac8 <itable>
    800024ee:	484030ef          	jal	80005972 <release>
}
    800024f2:	854a                	mv	a0,s2
    800024f4:	70a2                	ld	ra,40(sp)
    800024f6:	7402                	ld	s0,32(sp)
    800024f8:	64e2                	ld	s1,24(sp)
    800024fa:	6942                	ld	s2,16(sp)
    800024fc:	69a2                	ld	s3,8(sp)
    800024fe:	6a02                	ld	s4,0(sp)
    80002500:	6145                	addi	sp,sp,48
    80002502:	8082                	ret
    panic("iget: no inodes");
    80002504:	00005517          	auipc	a0,0x5
    80002508:	f7c50513          	addi	a0,a0,-132 # 80007480 <etext+0x480>
    8000250c:	112030ef          	jal	8000561e <panic>

0000000080002510 <iinit>:
{
    80002510:	7179                	addi	sp,sp,-48
    80002512:	f406                	sd	ra,40(sp)
    80002514:	f022                	sd	s0,32(sp)
    80002516:	ec26                	sd	s1,24(sp)
    80002518:	e84a                	sd	s2,16(sp)
    8000251a:	e44e                	sd	s3,8(sp)
    8000251c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000251e:	00005597          	auipc	a1,0x5
    80002522:	f7258593          	addi	a1,a1,-142 # 80007490 <etext+0x490>
    80002526:	00016517          	auipc	a0,0x16
    8000252a:	5a250513          	addi	a0,a0,1442 # 80018ac8 <itable>
    8000252e:	32c030ef          	jal	8000585a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002532:	00016497          	auipc	s1,0x16
    80002536:	5be48493          	addi	s1,s1,1470 # 80018af0 <itable+0x28>
    8000253a:	00018997          	auipc	s3,0x18
    8000253e:	04698993          	addi	s3,s3,70 # 8001a580 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002542:	00005917          	auipc	s2,0x5
    80002546:	f5690913          	addi	s2,s2,-170 # 80007498 <etext+0x498>
    8000254a:	85ca                	mv	a1,s2
    8000254c:	8526                	mv	a0,s1
    8000254e:	5bb000ef          	jal	80003308 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002552:	08848493          	addi	s1,s1,136
    80002556:	ff349ae3          	bne	s1,s3,8000254a <iinit+0x3a>
}
    8000255a:	70a2                	ld	ra,40(sp)
    8000255c:	7402                	ld	s0,32(sp)
    8000255e:	64e2                	ld	s1,24(sp)
    80002560:	6942                	ld	s2,16(sp)
    80002562:	69a2                	ld	s3,8(sp)
    80002564:	6145                	addi	sp,sp,48
    80002566:	8082                	ret

0000000080002568 <ialloc>:
{
    80002568:	7139                	addi	sp,sp,-64
    8000256a:	fc06                	sd	ra,56(sp)
    8000256c:	f822                	sd	s0,48(sp)
    8000256e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002570:	00016717          	auipc	a4,0x16
    80002574:	54472703          	lw	a4,1348(a4) # 80018ab4 <sb+0xc>
    80002578:	4785                	li	a5,1
    8000257a:	06e7f063          	bgeu	a5,a4,800025da <ialloc+0x72>
    8000257e:	f426                	sd	s1,40(sp)
    80002580:	f04a                	sd	s2,32(sp)
    80002582:	ec4e                	sd	s3,24(sp)
    80002584:	e852                	sd	s4,16(sp)
    80002586:	e456                	sd	s5,8(sp)
    80002588:	e05a                	sd	s6,0(sp)
    8000258a:	8aaa                	mv	s5,a0
    8000258c:	8b2e                	mv	s6,a1
    8000258e:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002590:	00016a17          	auipc	s4,0x16
    80002594:	518a0a13          	addi	s4,s4,1304 # 80018aa8 <sb>
    80002598:	00495593          	srli	a1,s2,0x4
    8000259c:	018a2783          	lw	a5,24(s4)
    800025a0:	9dbd                	addw	a1,a1,a5
    800025a2:	8556                	mv	a0,s5
    800025a4:	a69ff0ef          	jal	8000200c <bread>
    800025a8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025aa:	05850993          	addi	s3,a0,88
    800025ae:	00f97793          	andi	a5,s2,15
    800025b2:	079a                	slli	a5,a5,0x6
    800025b4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025b6:	00099783          	lh	a5,0(s3)
    800025ba:	cb9d                	beqz	a5,800025f0 <ialloc+0x88>
    brelse(bp);
    800025bc:	b59ff0ef          	jal	80002114 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025c0:	0905                	addi	s2,s2,1
    800025c2:	00ca2703          	lw	a4,12(s4)
    800025c6:	0009079b          	sext.w	a5,s2
    800025ca:	fce7e7e3          	bltu	a5,a4,80002598 <ialloc+0x30>
    800025ce:	74a2                	ld	s1,40(sp)
    800025d0:	7902                	ld	s2,32(sp)
    800025d2:	69e2                	ld	s3,24(sp)
    800025d4:	6a42                	ld	s4,16(sp)
    800025d6:	6aa2                	ld	s5,8(sp)
    800025d8:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800025da:	00005517          	auipc	a0,0x5
    800025de:	ec650513          	addi	a0,a0,-314 # 800074a0 <etext+0x4a0>
    800025e2:	557020ef          	jal	80005338 <printf>
  return 0;
    800025e6:	4501                	li	a0,0
}
    800025e8:	70e2                	ld	ra,56(sp)
    800025ea:	7442                	ld	s0,48(sp)
    800025ec:	6121                	addi	sp,sp,64
    800025ee:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800025f0:	04000613          	li	a2,64
    800025f4:	4581                	li	a1,0
    800025f6:	854e                	mv	a0,s3
    800025f8:	b3dfd0ef          	jal	80000134 <memset>
      dip->type = type;
    800025fc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002600:	8526                	mv	a0,s1
    80002602:	445000ef          	jal	80003246 <log_write>
      brelse(bp);
    80002606:	8526                	mv	a0,s1
    80002608:	b0dff0ef          	jal	80002114 <brelse>
      return iget(dev, inum);
    8000260c:	0009059b          	sext.w	a1,s2
    80002610:	8556                	mv	a0,s5
    80002612:	e53ff0ef          	jal	80002464 <iget>
    80002616:	74a2                	ld	s1,40(sp)
    80002618:	7902                	ld	s2,32(sp)
    8000261a:	69e2                	ld	s3,24(sp)
    8000261c:	6a42                	ld	s4,16(sp)
    8000261e:	6aa2                	ld	s5,8(sp)
    80002620:	6b02                	ld	s6,0(sp)
    80002622:	b7d9                	j	800025e8 <ialloc+0x80>

0000000080002624 <iupdate>:
{
    80002624:	1101                	addi	sp,sp,-32
    80002626:	ec06                	sd	ra,24(sp)
    80002628:	e822                	sd	s0,16(sp)
    8000262a:	e426                	sd	s1,8(sp)
    8000262c:	e04a                	sd	s2,0(sp)
    8000262e:	1000                	addi	s0,sp,32
    80002630:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002632:	415c                	lw	a5,4(a0)
    80002634:	0047d79b          	srliw	a5,a5,0x4
    80002638:	00016597          	auipc	a1,0x16
    8000263c:	4885a583          	lw	a1,1160(a1) # 80018ac0 <sb+0x18>
    80002640:	9dbd                	addw	a1,a1,a5
    80002642:	4108                	lw	a0,0(a0)
    80002644:	9c9ff0ef          	jal	8000200c <bread>
    80002648:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000264a:	05850793          	addi	a5,a0,88
    8000264e:	40d8                	lw	a4,4(s1)
    80002650:	8b3d                	andi	a4,a4,15
    80002652:	071a                	slli	a4,a4,0x6
    80002654:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002656:	04449703          	lh	a4,68(s1)
    8000265a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000265e:	04649703          	lh	a4,70(s1)
    80002662:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002666:	04849703          	lh	a4,72(s1)
    8000266a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000266e:	04a49703          	lh	a4,74(s1)
    80002672:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002676:	44f8                	lw	a4,76(s1)
    80002678:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000267a:	03400613          	li	a2,52
    8000267e:	05048593          	addi	a1,s1,80
    80002682:	00c78513          	addi	a0,a5,12
    80002686:	b0bfd0ef          	jal	80000190 <memmove>
  log_write(bp);
    8000268a:	854a                	mv	a0,s2
    8000268c:	3bb000ef          	jal	80003246 <log_write>
  brelse(bp);
    80002690:	854a                	mv	a0,s2
    80002692:	a83ff0ef          	jal	80002114 <brelse>
}
    80002696:	60e2                	ld	ra,24(sp)
    80002698:	6442                	ld	s0,16(sp)
    8000269a:	64a2                	ld	s1,8(sp)
    8000269c:	6902                	ld	s2,0(sp)
    8000269e:	6105                	addi	sp,sp,32
    800026a0:	8082                	ret

00000000800026a2 <idup>:
{
    800026a2:	1101                	addi	sp,sp,-32
    800026a4:	ec06                	sd	ra,24(sp)
    800026a6:	e822                	sd	s0,16(sp)
    800026a8:	e426                	sd	s1,8(sp)
    800026aa:	1000                	addi	s0,sp,32
    800026ac:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026ae:	00016517          	auipc	a0,0x16
    800026b2:	41a50513          	addi	a0,a0,1050 # 80018ac8 <itable>
    800026b6:	224030ef          	jal	800058da <acquire>
  ip->ref++;
    800026ba:	449c                	lw	a5,8(s1)
    800026bc:	2785                	addiw	a5,a5,1
    800026be:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026c0:	00016517          	auipc	a0,0x16
    800026c4:	40850513          	addi	a0,a0,1032 # 80018ac8 <itable>
    800026c8:	2aa030ef          	jal	80005972 <release>
}
    800026cc:	8526                	mv	a0,s1
    800026ce:	60e2                	ld	ra,24(sp)
    800026d0:	6442                	ld	s0,16(sp)
    800026d2:	64a2                	ld	s1,8(sp)
    800026d4:	6105                	addi	sp,sp,32
    800026d6:	8082                	ret

00000000800026d8 <ilock>:
{
    800026d8:	1101                	addi	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026e2:	cd19                	beqz	a0,80002700 <ilock+0x28>
    800026e4:	84aa                	mv	s1,a0
    800026e6:	451c                	lw	a5,8(a0)
    800026e8:	00f05c63          	blez	a5,80002700 <ilock+0x28>
  acquiresleep(&ip->lock);
    800026ec:	0541                	addi	a0,a0,16
    800026ee:	451000ef          	jal	8000333e <acquiresleep>
  if(ip->valid == 0){
    800026f2:	40bc                	lw	a5,64(s1)
    800026f4:	cf89                	beqz	a5,8000270e <ilock+0x36>
}
    800026f6:	60e2                	ld	ra,24(sp)
    800026f8:	6442                	ld	s0,16(sp)
    800026fa:	64a2                	ld	s1,8(sp)
    800026fc:	6105                	addi	sp,sp,32
    800026fe:	8082                	ret
    80002700:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002702:	00005517          	auipc	a0,0x5
    80002706:	db650513          	addi	a0,a0,-586 # 800074b8 <etext+0x4b8>
    8000270a:	715020ef          	jal	8000561e <panic>
    8000270e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002710:	40dc                	lw	a5,4(s1)
    80002712:	0047d79b          	srliw	a5,a5,0x4
    80002716:	00016597          	auipc	a1,0x16
    8000271a:	3aa5a583          	lw	a1,938(a1) # 80018ac0 <sb+0x18>
    8000271e:	9dbd                	addw	a1,a1,a5
    80002720:	4088                	lw	a0,0(s1)
    80002722:	8ebff0ef          	jal	8000200c <bread>
    80002726:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002728:	05850593          	addi	a1,a0,88
    8000272c:	40dc                	lw	a5,4(s1)
    8000272e:	8bbd                	andi	a5,a5,15
    80002730:	079a                	slli	a5,a5,0x6
    80002732:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002734:	00059783          	lh	a5,0(a1)
    80002738:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000273c:	00259783          	lh	a5,2(a1)
    80002740:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002744:	00459783          	lh	a5,4(a1)
    80002748:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000274c:	00659783          	lh	a5,6(a1)
    80002750:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002754:	459c                	lw	a5,8(a1)
    80002756:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002758:	03400613          	li	a2,52
    8000275c:	05b1                	addi	a1,a1,12
    8000275e:	05048513          	addi	a0,s1,80
    80002762:	a2ffd0ef          	jal	80000190 <memmove>
    brelse(bp);
    80002766:	854a                	mv	a0,s2
    80002768:	9adff0ef          	jal	80002114 <brelse>
    ip->valid = 1;
    8000276c:	4785                	li	a5,1
    8000276e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002770:	04449783          	lh	a5,68(s1)
    80002774:	c399                	beqz	a5,8000277a <ilock+0xa2>
    80002776:	6902                	ld	s2,0(sp)
    80002778:	bfbd                	j	800026f6 <ilock+0x1e>
      panic("ilock: no type");
    8000277a:	00005517          	auipc	a0,0x5
    8000277e:	d4650513          	addi	a0,a0,-698 # 800074c0 <etext+0x4c0>
    80002782:	69d020ef          	jal	8000561e <panic>

0000000080002786 <iunlock>:
{
    80002786:	1101                	addi	sp,sp,-32
    80002788:	ec06                	sd	ra,24(sp)
    8000278a:	e822                	sd	s0,16(sp)
    8000278c:	e426                	sd	s1,8(sp)
    8000278e:	e04a                	sd	s2,0(sp)
    80002790:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002792:	c505                	beqz	a0,800027ba <iunlock+0x34>
    80002794:	84aa                	mv	s1,a0
    80002796:	01050913          	addi	s2,a0,16
    8000279a:	854a                	mv	a0,s2
    8000279c:	421000ef          	jal	800033bc <holdingsleep>
    800027a0:	cd09                	beqz	a0,800027ba <iunlock+0x34>
    800027a2:	449c                	lw	a5,8(s1)
    800027a4:	00f05b63          	blez	a5,800027ba <iunlock+0x34>
  releasesleep(&ip->lock);
    800027a8:	854a                	mv	a0,s2
    800027aa:	3db000ef          	jal	80003384 <releasesleep>
}
    800027ae:	60e2                	ld	ra,24(sp)
    800027b0:	6442                	ld	s0,16(sp)
    800027b2:	64a2                	ld	s1,8(sp)
    800027b4:	6902                	ld	s2,0(sp)
    800027b6:	6105                	addi	sp,sp,32
    800027b8:	8082                	ret
    panic("iunlock");
    800027ba:	00005517          	auipc	a0,0x5
    800027be:	d1650513          	addi	a0,a0,-746 # 800074d0 <etext+0x4d0>
    800027c2:	65d020ef          	jal	8000561e <panic>

00000000800027c6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027c6:	7179                	addi	sp,sp,-48
    800027c8:	f406                	sd	ra,40(sp)
    800027ca:	f022                	sd	s0,32(sp)
    800027cc:	ec26                	sd	s1,24(sp)
    800027ce:	e84a                	sd	s2,16(sp)
    800027d0:	e44e                	sd	s3,8(sp)
    800027d2:	1800                	addi	s0,sp,48
    800027d4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800027d6:	05050493          	addi	s1,a0,80
    800027da:	08050913          	addi	s2,a0,128
    800027de:	a021                	j	800027e6 <itrunc+0x20>
    800027e0:	0491                	addi	s1,s1,4
    800027e2:	01248b63          	beq	s1,s2,800027f8 <itrunc+0x32>
    if(ip->addrs[i]){
    800027e6:	408c                	lw	a1,0(s1)
    800027e8:	dde5                	beqz	a1,800027e0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800027ea:	0009a503          	lw	a0,0(s3)
    800027ee:	a17ff0ef          	jal	80002204 <bfree>
      ip->addrs[i] = 0;
    800027f2:	0004a023          	sw	zero,0(s1)
    800027f6:	b7ed                	j	800027e0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800027f8:	0809a583          	lw	a1,128(s3)
    800027fc:	ed89                	bnez	a1,80002816 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800027fe:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002802:	854e                	mv	a0,s3
    80002804:	e21ff0ef          	jal	80002624 <iupdate>
}
    80002808:	70a2                	ld	ra,40(sp)
    8000280a:	7402                	ld	s0,32(sp)
    8000280c:	64e2                	ld	s1,24(sp)
    8000280e:	6942                	ld	s2,16(sp)
    80002810:	69a2                	ld	s3,8(sp)
    80002812:	6145                	addi	sp,sp,48
    80002814:	8082                	ret
    80002816:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002818:	0009a503          	lw	a0,0(s3)
    8000281c:	ff0ff0ef          	jal	8000200c <bread>
    80002820:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002822:	05850493          	addi	s1,a0,88
    80002826:	45850913          	addi	s2,a0,1112
    8000282a:	a021                	j	80002832 <itrunc+0x6c>
    8000282c:	0491                	addi	s1,s1,4
    8000282e:	01248963          	beq	s1,s2,80002840 <itrunc+0x7a>
      if(a[j])
    80002832:	408c                	lw	a1,0(s1)
    80002834:	dde5                	beqz	a1,8000282c <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002836:	0009a503          	lw	a0,0(s3)
    8000283a:	9cbff0ef          	jal	80002204 <bfree>
    8000283e:	b7fd                	j	8000282c <itrunc+0x66>
    brelse(bp);
    80002840:	8552                	mv	a0,s4
    80002842:	8d3ff0ef          	jal	80002114 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002846:	0809a583          	lw	a1,128(s3)
    8000284a:	0009a503          	lw	a0,0(s3)
    8000284e:	9b7ff0ef          	jal	80002204 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002852:	0809a023          	sw	zero,128(s3)
    80002856:	6a02                	ld	s4,0(sp)
    80002858:	b75d                	j	800027fe <itrunc+0x38>

000000008000285a <iput>:
{
    8000285a:	1101                	addi	sp,sp,-32
    8000285c:	ec06                	sd	ra,24(sp)
    8000285e:	e822                	sd	s0,16(sp)
    80002860:	e426                	sd	s1,8(sp)
    80002862:	1000                	addi	s0,sp,32
    80002864:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002866:	00016517          	auipc	a0,0x16
    8000286a:	26250513          	addi	a0,a0,610 # 80018ac8 <itable>
    8000286e:	06c030ef          	jal	800058da <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002872:	4498                	lw	a4,8(s1)
    80002874:	4785                	li	a5,1
    80002876:	02f70063          	beq	a4,a5,80002896 <iput+0x3c>
  ip->ref--;
    8000287a:	449c                	lw	a5,8(s1)
    8000287c:	37fd                	addiw	a5,a5,-1
    8000287e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002880:	00016517          	auipc	a0,0x16
    80002884:	24850513          	addi	a0,a0,584 # 80018ac8 <itable>
    80002888:	0ea030ef          	jal	80005972 <release>
}
    8000288c:	60e2                	ld	ra,24(sp)
    8000288e:	6442                	ld	s0,16(sp)
    80002890:	64a2                	ld	s1,8(sp)
    80002892:	6105                	addi	sp,sp,32
    80002894:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002896:	40bc                	lw	a5,64(s1)
    80002898:	d3ed                	beqz	a5,8000287a <iput+0x20>
    8000289a:	04a49783          	lh	a5,74(s1)
    8000289e:	fff1                	bnez	a5,8000287a <iput+0x20>
    800028a0:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800028a2:	01048913          	addi	s2,s1,16
    800028a6:	854a                	mv	a0,s2
    800028a8:	297000ef          	jal	8000333e <acquiresleep>
    release(&itable.lock);
    800028ac:	00016517          	auipc	a0,0x16
    800028b0:	21c50513          	addi	a0,a0,540 # 80018ac8 <itable>
    800028b4:	0be030ef          	jal	80005972 <release>
    itrunc(ip);
    800028b8:	8526                	mv	a0,s1
    800028ba:	f0dff0ef          	jal	800027c6 <itrunc>
    ip->type = 0;
    800028be:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028c2:	8526                	mv	a0,s1
    800028c4:	d61ff0ef          	jal	80002624 <iupdate>
    ip->valid = 0;
    800028c8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028cc:	854a                	mv	a0,s2
    800028ce:	2b7000ef          	jal	80003384 <releasesleep>
    acquire(&itable.lock);
    800028d2:	00016517          	auipc	a0,0x16
    800028d6:	1f650513          	addi	a0,a0,502 # 80018ac8 <itable>
    800028da:	000030ef          	jal	800058da <acquire>
    800028de:	6902                	ld	s2,0(sp)
    800028e0:	bf69                	j	8000287a <iput+0x20>

00000000800028e2 <iunlockput>:
{
    800028e2:	1101                	addi	sp,sp,-32
    800028e4:	ec06                	sd	ra,24(sp)
    800028e6:	e822                	sd	s0,16(sp)
    800028e8:	e426                	sd	s1,8(sp)
    800028ea:	1000                	addi	s0,sp,32
    800028ec:	84aa                	mv	s1,a0
  iunlock(ip);
    800028ee:	e99ff0ef          	jal	80002786 <iunlock>
  iput(ip);
    800028f2:	8526                	mv	a0,s1
    800028f4:	f67ff0ef          	jal	8000285a <iput>
}
    800028f8:	60e2                	ld	ra,24(sp)
    800028fa:	6442                	ld	s0,16(sp)
    800028fc:	64a2                	ld	s1,8(sp)
    800028fe:	6105                	addi	sp,sp,32
    80002900:	8082                	ret

0000000080002902 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002902:	00016717          	auipc	a4,0x16
    80002906:	1b272703          	lw	a4,434(a4) # 80018ab4 <sb+0xc>
    8000290a:	4785                	li	a5,1
    8000290c:	0ae7ff63          	bgeu	a5,a4,800029ca <ireclaim+0xc8>
{
    80002910:	7139                	addi	sp,sp,-64
    80002912:	fc06                	sd	ra,56(sp)
    80002914:	f822                	sd	s0,48(sp)
    80002916:	f426                	sd	s1,40(sp)
    80002918:	f04a                	sd	s2,32(sp)
    8000291a:	ec4e                	sd	s3,24(sp)
    8000291c:	e852                	sd	s4,16(sp)
    8000291e:	e456                	sd	s5,8(sp)
    80002920:	e05a                	sd	s6,0(sp)
    80002922:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002924:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002926:	00050a1b          	sext.w	s4,a0
    8000292a:	00016a97          	auipc	s5,0x16
    8000292e:	17ea8a93          	addi	s5,s5,382 # 80018aa8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002932:	00005b17          	auipc	s6,0x5
    80002936:	ba6b0b13          	addi	s6,s6,-1114 # 800074d8 <etext+0x4d8>
    8000293a:	a099                	j	80002980 <ireclaim+0x7e>
    8000293c:	85ce                	mv	a1,s3
    8000293e:	855a                	mv	a0,s6
    80002940:	1f9020ef          	jal	80005338 <printf>
      ip = iget(dev, inum);
    80002944:	85ce                	mv	a1,s3
    80002946:	8552                	mv	a0,s4
    80002948:	b1dff0ef          	jal	80002464 <iget>
    8000294c:	89aa                	mv	s3,a0
    brelse(bp);
    8000294e:	854a                	mv	a0,s2
    80002950:	fc4ff0ef          	jal	80002114 <brelse>
    if (ip) {
    80002954:	00098f63          	beqz	s3,80002972 <ireclaim+0x70>
      begin_op();
    80002958:	76a000ef          	jal	800030c2 <begin_op>
      ilock(ip);
    8000295c:	854e                	mv	a0,s3
    8000295e:	d7bff0ef          	jal	800026d8 <ilock>
      iunlock(ip);
    80002962:	854e                	mv	a0,s3
    80002964:	e23ff0ef          	jal	80002786 <iunlock>
      iput(ip);
    80002968:	854e                	mv	a0,s3
    8000296a:	ef1ff0ef          	jal	8000285a <iput>
      end_op();
    8000296e:	7be000ef          	jal	8000312c <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002972:	0485                	addi	s1,s1,1
    80002974:	00caa703          	lw	a4,12(s5)
    80002978:	0004879b          	sext.w	a5,s1
    8000297c:	02e7fd63          	bgeu	a5,a4,800029b6 <ireclaim+0xb4>
    80002980:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002984:	0044d593          	srli	a1,s1,0x4
    80002988:	018aa783          	lw	a5,24(s5)
    8000298c:	9dbd                	addw	a1,a1,a5
    8000298e:	8552                	mv	a0,s4
    80002990:	e7cff0ef          	jal	8000200c <bread>
    80002994:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002996:	05850793          	addi	a5,a0,88
    8000299a:	00f9f713          	andi	a4,s3,15
    8000299e:	071a                	slli	a4,a4,0x6
    800029a0:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800029a2:	00079703          	lh	a4,0(a5)
    800029a6:	c701                	beqz	a4,800029ae <ireclaim+0xac>
    800029a8:	00679783          	lh	a5,6(a5)
    800029ac:	dbc1                	beqz	a5,8000293c <ireclaim+0x3a>
    brelse(bp);
    800029ae:	854a                	mv	a0,s2
    800029b0:	f64ff0ef          	jal	80002114 <brelse>
    if (ip) {
    800029b4:	bf7d                	j	80002972 <ireclaim+0x70>
}
    800029b6:	70e2                	ld	ra,56(sp)
    800029b8:	7442                	ld	s0,48(sp)
    800029ba:	74a2                	ld	s1,40(sp)
    800029bc:	7902                	ld	s2,32(sp)
    800029be:	69e2                	ld	s3,24(sp)
    800029c0:	6a42                	ld	s4,16(sp)
    800029c2:	6aa2                	ld	s5,8(sp)
    800029c4:	6b02                	ld	s6,0(sp)
    800029c6:	6121                	addi	sp,sp,64
    800029c8:	8082                	ret
    800029ca:	8082                	ret

00000000800029cc <fsinit>:
fsinit(int dev) {
    800029cc:	7179                	addi	sp,sp,-48
    800029ce:	f406                	sd	ra,40(sp)
    800029d0:	f022                	sd	s0,32(sp)
    800029d2:	ec26                	sd	s1,24(sp)
    800029d4:	e84a                	sd	s2,16(sp)
    800029d6:	e44e                	sd	s3,8(sp)
    800029d8:	1800                	addi	s0,sp,48
    800029da:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800029dc:	4585                	li	a1,1
    800029de:	e2eff0ef          	jal	8000200c <bread>
    800029e2:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029e4:	00016997          	auipc	s3,0x16
    800029e8:	0c498993          	addi	s3,s3,196 # 80018aa8 <sb>
    800029ec:	02000613          	li	a2,32
    800029f0:	05850593          	addi	a1,a0,88
    800029f4:	854e                	mv	a0,s3
    800029f6:	f9afd0ef          	jal	80000190 <memmove>
  brelse(bp);
    800029fa:	854a                	mv	a0,s2
    800029fc:	f18ff0ef          	jal	80002114 <brelse>
  if(sb.magic != FSMAGIC)
    80002a00:	0009a703          	lw	a4,0(s3)
    80002a04:	102037b7          	lui	a5,0x10203
    80002a08:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a0c:	02f71363          	bne	a4,a5,80002a32 <fsinit+0x66>
  initlog(dev, &sb);
    80002a10:	00016597          	auipc	a1,0x16
    80002a14:	09858593          	addi	a1,a1,152 # 80018aa8 <sb>
    80002a18:	8526                	mv	a0,s1
    80002a1a:	62a000ef          	jal	80003044 <initlog>
  ireclaim(dev);
    80002a1e:	8526                	mv	a0,s1
    80002a20:	ee3ff0ef          	jal	80002902 <ireclaim>
}
    80002a24:	70a2                	ld	ra,40(sp)
    80002a26:	7402                	ld	s0,32(sp)
    80002a28:	64e2                	ld	s1,24(sp)
    80002a2a:	6942                	ld	s2,16(sp)
    80002a2c:	69a2                	ld	s3,8(sp)
    80002a2e:	6145                	addi	sp,sp,48
    80002a30:	8082                	ret
    panic("invalid file system");
    80002a32:	00005517          	auipc	a0,0x5
    80002a36:	ac650513          	addi	a0,a0,-1338 # 800074f8 <etext+0x4f8>
    80002a3a:	3e5020ef          	jal	8000561e <panic>

0000000080002a3e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a3e:	1141                	addi	sp,sp,-16
    80002a40:	e422                	sd	s0,8(sp)
    80002a42:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a44:	411c                	lw	a5,0(a0)
    80002a46:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a48:	415c                	lw	a5,4(a0)
    80002a4a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a4c:	04451783          	lh	a5,68(a0)
    80002a50:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a54:	04a51783          	lh	a5,74(a0)
    80002a58:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a5c:	04c56783          	lwu	a5,76(a0)
    80002a60:	e99c                	sd	a5,16(a1)
}
    80002a62:	6422                	ld	s0,8(sp)
    80002a64:	0141                	addi	sp,sp,16
    80002a66:	8082                	ret

0000000080002a68 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a68:	457c                	lw	a5,76(a0)
    80002a6a:	0ed7eb63          	bltu	a5,a3,80002b60 <readi+0xf8>
{
    80002a6e:	7159                	addi	sp,sp,-112
    80002a70:	f486                	sd	ra,104(sp)
    80002a72:	f0a2                	sd	s0,96(sp)
    80002a74:	eca6                	sd	s1,88(sp)
    80002a76:	e0d2                	sd	s4,64(sp)
    80002a78:	fc56                	sd	s5,56(sp)
    80002a7a:	f85a                	sd	s6,48(sp)
    80002a7c:	f45e                	sd	s7,40(sp)
    80002a7e:	1880                	addi	s0,sp,112
    80002a80:	8b2a                	mv	s6,a0
    80002a82:	8bae                	mv	s7,a1
    80002a84:	8a32                	mv	s4,a2
    80002a86:	84b6                	mv	s1,a3
    80002a88:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a8a:	9f35                	addw	a4,a4,a3
    return 0;
    80002a8c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a8e:	0cd76063          	bltu	a4,a3,80002b4e <readi+0xe6>
    80002a92:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a94:	00e7f463          	bgeu	a5,a4,80002a9c <readi+0x34>
    n = ip->size - off;
    80002a98:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a9c:	080a8f63          	beqz	s5,80002b3a <readi+0xd2>
    80002aa0:	e8ca                	sd	s2,80(sp)
    80002aa2:	f062                	sd	s8,32(sp)
    80002aa4:	ec66                	sd	s9,24(sp)
    80002aa6:	e86a                	sd	s10,16(sp)
    80002aa8:	e46e                	sd	s11,8(sp)
    80002aaa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002aac:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ab0:	5c7d                	li	s8,-1
    80002ab2:	a80d                	j	80002ae4 <readi+0x7c>
    80002ab4:	020d1d93          	slli	s11,s10,0x20
    80002ab8:	020ddd93          	srli	s11,s11,0x20
    80002abc:	05890613          	addi	a2,s2,88
    80002ac0:	86ee                	mv	a3,s11
    80002ac2:	963a                	add	a2,a2,a4
    80002ac4:	85d2                	mv	a1,s4
    80002ac6:	855e                	mv	a0,s7
    80002ac8:	c19fe0ef          	jal	800016e0 <either_copyout>
    80002acc:	05850763          	beq	a0,s8,80002b1a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ad0:	854a                	mv	a0,s2
    80002ad2:	e42ff0ef          	jal	80002114 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ad6:	013d09bb          	addw	s3,s10,s3
    80002ada:	009d04bb          	addw	s1,s10,s1
    80002ade:	9a6e                	add	s4,s4,s11
    80002ae0:	0559f763          	bgeu	s3,s5,80002b2e <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002ae4:	00a4d59b          	srliw	a1,s1,0xa
    80002ae8:	855a                	mv	a0,s6
    80002aea:	8a7ff0ef          	jal	80002390 <bmap>
    80002aee:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002af2:	c5b1                	beqz	a1,80002b3e <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002af4:	000b2503          	lw	a0,0(s6)
    80002af8:	d14ff0ef          	jal	8000200c <bread>
    80002afc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002afe:	3ff4f713          	andi	a4,s1,1023
    80002b02:	40ec87bb          	subw	a5,s9,a4
    80002b06:	413a86bb          	subw	a3,s5,s3
    80002b0a:	8d3e                	mv	s10,a5
    80002b0c:	2781                	sext.w	a5,a5
    80002b0e:	0006861b          	sext.w	a2,a3
    80002b12:	faf671e3          	bgeu	a2,a5,80002ab4 <readi+0x4c>
    80002b16:	8d36                	mv	s10,a3
    80002b18:	bf71                	j	80002ab4 <readi+0x4c>
      brelse(bp);
    80002b1a:	854a                	mv	a0,s2
    80002b1c:	df8ff0ef          	jal	80002114 <brelse>
      tot = -1;
    80002b20:	59fd                	li	s3,-1
      break;
    80002b22:	6946                	ld	s2,80(sp)
    80002b24:	7c02                	ld	s8,32(sp)
    80002b26:	6ce2                	ld	s9,24(sp)
    80002b28:	6d42                	ld	s10,16(sp)
    80002b2a:	6da2                	ld	s11,8(sp)
    80002b2c:	a831                	j	80002b48 <readi+0xe0>
    80002b2e:	6946                	ld	s2,80(sp)
    80002b30:	7c02                	ld	s8,32(sp)
    80002b32:	6ce2                	ld	s9,24(sp)
    80002b34:	6d42                	ld	s10,16(sp)
    80002b36:	6da2                	ld	s11,8(sp)
    80002b38:	a801                	j	80002b48 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b3a:	89d6                	mv	s3,s5
    80002b3c:	a031                	j	80002b48 <readi+0xe0>
    80002b3e:	6946                	ld	s2,80(sp)
    80002b40:	7c02                	ld	s8,32(sp)
    80002b42:	6ce2                	ld	s9,24(sp)
    80002b44:	6d42                	ld	s10,16(sp)
    80002b46:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b48:	0009851b          	sext.w	a0,s3
    80002b4c:	69a6                	ld	s3,72(sp)
}
    80002b4e:	70a6                	ld	ra,104(sp)
    80002b50:	7406                	ld	s0,96(sp)
    80002b52:	64e6                	ld	s1,88(sp)
    80002b54:	6a06                	ld	s4,64(sp)
    80002b56:	7ae2                	ld	s5,56(sp)
    80002b58:	7b42                	ld	s6,48(sp)
    80002b5a:	7ba2                	ld	s7,40(sp)
    80002b5c:	6165                	addi	sp,sp,112
    80002b5e:	8082                	ret
    return 0;
    80002b60:	4501                	li	a0,0
}
    80002b62:	8082                	ret

0000000080002b64 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b64:	457c                	lw	a5,76(a0)
    80002b66:	10d7e063          	bltu	a5,a3,80002c66 <writei+0x102>
{
    80002b6a:	7159                	addi	sp,sp,-112
    80002b6c:	f486                	sd	ra,104(sp)
    80002b6e:	f0a2                	sd	s0,96(sp)
    80002b70:	e8ca                	sd	s2,80(sp)
    80002b72:	e0d2                	sd	s4,64(sp)
    80002b74:	fc56                	sd	s5,56(sp)
    80002b76:	f85a                	sd	s6,48(sp)
    80002b78:	f45e                	sd	s7,40(sp)
    80002b7a:	1880                	addi	s0,sp,112
    80002b7c:	8aaa                	mv	s5,a0
    80002b7e:	8bae                	mv	s7,a1
    80002b80:	8a32                	mv	s4,a2
    80002b82:	8936                	mv	s2,a3
    80002b84:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b86:	00e687bb          	addw	a5,a3,a4
    80002b8a:	0ed7e063          	bltu	a5,a3,80002c6a <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b8e:	00043737          	lui	a4,0x43
    80002b92:	0cf76e63          	bltu	a4,a5,80002c6e <writei+0x10a>
    80002b96:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b98:	0a0b0f63          	beqz	s6,80002c56 <writei+0xf2>
    80002b9c:	eca6                	sd	s1,88(sp)
    80002b9e:	f062                	sd	s8,32(sp)
    80002ba0:	ec66                	sd	s9,24(sp)
    80002ba2:	e86a                	sd	s10,16(sp)
    80002ba4:	e46e                	sd	s11,8(sp)
    80002ba6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ba8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002bac:	5c7d                	li	s8,-1
    80002bae:	a825                	j	80002be6 <writei+0x82>
    80002bb0:	020d1d93          	slli	s11,s10,0x20
    80002bb4:	020ddd93          	srli	s11,s11,0x20
    80002bb8:	05848513          	addi	a0,s1,88
    80002bbc:	86ee                	mv	a3,s11
    80002bbe:	8652                	mv	a2,s4
    80002bc0:	85de                	mv	a1,s7
    80002bc2:	953a                	add	a0,a0,a4
    80002bc4:	b67fe0ef          	jal	8000172a <either_copyin>
    80002bc8:	05850a63          	beq	a0,s8,80002c1c <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bcc:	8526                	mv	a0,s1
    80002bce:	678000ef          	jal	80003246 <log_write>
    brelse(bp);
    80002bd2:	8526                	mv	a0,s1
    80002bd4:	d40ff0ef          	jal	80002114 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bd8:	013d09bb          	addw	s3,s10,s3
    80002bdc:	012d093b          	addw	s2,s10,s2
    80002be0:	9a6e                	add	s4,s4,s11
    80002be2:	0569f063          	bgeu	s3,s6,80002c22 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002be6:	00a9559b          	srliw	a1,s2,0xa
    80002bea:	8556                	mv	a0,s5
    80002bec:	fa4ff0ef          	jal	80002390 <bmap>
    80002bf0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002bf4:	c59d                	beqz	a1,80002c22 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002bf6:	000aa503          	lw	a0,0(s5)
    80002bfa:	c12ff0ef          	jal	8000200c <bread>
    80002bfe:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c00:	3ff97713          	andi	a4,s2,1023
    80002c04:	40ec87bb          	subw	a5,s9,a4
    80002c08:	413b06bb          	subw	a3,s6,s3
    80002c0c:	8d3e                	mv	s10,a5
    80002c0e:	2781                	sext.w	a5,a5
    80002c10:	0006861b          	sext.w	a2,a3
    80002c14:	f8f67ee3          	bgeu	a2,a5,80002bb0 <writei+0x4c>
    80002c18:	8d36                	mv	s10,a3
    80002c1a:	bf59                	j	80002bb0 <writei+0x4c>
      brelse(bp);
    80002c1c:	8526                	mv	a0,s1
    80002c1e:	cf6ff0ef          	jal	80002114 <brelse>
  }

  if(off > ip->size)
    80002c22:	04caa783          	lw	a5,76(s5)
    80002c26:	0327fa63          	bgeu	a5,s2,80002c5a <writei+0xf6>
    ip->size = off;
    80002c2a:	052aa623          	sw	s2,76(s5)
    80002c2e:	64e6                	ld	s1,88(sp)
    80002c30:	7c02                	ld	s8,32(sp)
    80002c32:	6ce2                	ld	s9,24(sp)
    80002c34:	6d42                	ld	s10,16(sp)
    80002c36:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c38:	8556                	mv	a0,s5
    80002c3a:	9ebff0ef          	jal	80002624 <iupdate>

  return tot;
    80002c3e:	0009851b          	sext.w	a0,s3
    80002c42:	69a6                	ld	s3,72(sp)
}
    80002c44:	70a6                	ld	ra,104(sp)
    80002c46:	7406                	ld	s0,96(sp)
    80002c48:	6946                	ld	s2,80(sp)
    80002c4a:	6a06                	ld	s4,64(sp)
    80002c4c:	7ae2                	ld	s5,56(sp)
    80002c4e:	7b42                	ld	s6,48(sp)
    80002c50:	7ba2                	ld	s7,40(sp)
    80002c52:	6165                	addi	sp,sp,112
    80002c54:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c56:	89da                	mv	s3,s6
    80002c58:	b7c5                	j	80002c38 <writei+0xd4>
    80002c5a:	64e6                	ld	s1,88(sp)
    80002c5c:	7c02                	ld	s8,32(sp)
    80002c5e:	6ce2                	ld	s9,24(sp)
    80002c60:	6d42                	ld	s10,16(sp)
    80002c62:	6da2                	ld	s11,8(sp)
    80002c64:	bfd1                	j	80002c38 <writei+0xd4>
    return -1;
    80002c66:	557d                	li	a0,-1
}
    80002c68:	8082                	ret
    return -1;
    80002c6a:	557d                	li	a0,-1
    80002c6c:	bfe1                	j	80002c44 <writei+0xe0>
    return -1;
    80002c6e:	557d                	li	a0,-1
    80002c70:	bfd1                	j	80002c44 <writei+0xe0>

0000000080002c72 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c72:	1141                	addi	sp,sp,-16
    80002c74:	e406                	sd	ra,8(sp)
    80002c76:	e022                	sd	s0,0(sp)
    80002c78:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c7a:	4639                	li	a2,14
    80002c7c:	d84fd0ef          	jal	80000200 <strncmp>
}
    80002c80:	60a2                	ld	ra,8(sp)
    80002c82:	6402                	ld	s0,0(sp)
    80002c84:	0141                	addi	sp,sp,16
    80002c86:	8082                	ret

0000000080002c88 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c88:	7139                	addi	sp,sp,-64
    80002c8a:	fc06                	sd	ra,56(sp)
    80002c8c:	f822                	sd	s0,48(sp)
    80002c8e:	f426                	sd	s1,40(sp)
    80002c90:	f04a                	sd	s2,32(sp)
    80002c92:	ec4e                	sd	s3,24(sp)
    80002c94:	e852                	sd	s4,16(sp)
    80002c96:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c98:	04451703          	lh	a4,68(a0)
    80002c9c:	4785                	li	a5,1
    80002c9e:	00f71a63          	bne	a4,a5,80002cb2 <dirlookup+0x2a>
    80002ca2:	892a                	mv	s2,a0
    80002ca4:	89ae                	mv	s3,a1
    80002ca6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ca8:	457c                	lw	a5,76(a0)
    80002caa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002cac:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cae:	e39d                	bnez	a5,80002cd4 <dirlookup+0x4c>
    80002cb0:	a095                	j	80002d14 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002cb2:	00005517          	auipc	a0,0x5
    80002cb6:	85e50513          	addi	a0,a0,-1954 # 80007510 <etext+0x510>
    80002cba:	165020ef          	jal	8000561e <panic>
      panic("dirlookup read");
    80002cbe:	00005517          	auipc	a0,0x5
    80002cc2:	86a50513          	addi	a0,a0,-1942 # 80007528 <etext+0x528>
    80002cc6:	159020ef          	jal	8000561e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cca:	24c1                	addiw	s1,s1,16
    80002ccc:	04c92783          	lw	a5,76(s2)
    80002cd0:	04f4f163          	bgeu	s1,a5,80002d12 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cd4:	4741                	li	a4,16
    80002cd6:	86a6                	mv	a3,s1
    80002cd8:	fc040613          	addi	a2,s0,-64
    80002cdc:	4581                	li	a1,0
    80002cde:	854a                	mv	a0,s2
    80002ce0:	d89ff0ef          	jal	80002a68 <readi>
    80002ce4:	47c1                	li	a5,16
    80002ce6:	fcf51ce3          	bne	a0,a5,80002cbe <dirlookup+0x36>
    if(de.inum == 0)
    80002cea:	fc045783          	lhu	a5,-64(s0)
    80002cee:	dff1                	beqz	a5,80002cca <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002cf0:	fc240593          	addi	a1,s0,-62
    80002cf4:	854e                	mv	a0,s3
    80002cf6:	f7dff0ef          	jal	80002c72 <namecmp>
    80002cfa:	f961                	bnez	a0,80002cca <dirlookup+0x42>
      if(poff)
    80002cfc:	000a0463          	beqz	s4,80002d04 <dirlookup+0x7c>
        *poff = off;
    80002d00:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002d04:	fc045583          	lhu	a1,-64(s0)
    80002d08:	00092503          	lw	a0,0(s2)
    80002d0c:	f58ff0ef          	jal	80002464 <iget>
    80002d10:	a011                	j	80002d14 <dirlookup+0x8c>
  return 0;
    80002d12:	4501                	li	a0,0
}
    80002d14:	70e2                	ld	ra,56(sp)
    80002d16:	7442                	ld	s0,48(sp)
    80002d18:	74a2                	ld	s1,40(sp)
    80002d1a:	7902                	ld	s2,32(sp)
    80002d1c:	69e2                	ld	s3,24(sp)
    80002d1e:	6a42                	ld	s4,16(sp)
    80002d20:	6121                	addi	sp,sp,64
    80002d22:	8082                	ret

0000000080002d24 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d24:	711d                	addi	sp,sp,-96
    80002d26:	ec86                	sd	ra,88(sp)
    80002d28:	e8a2                	sd	s0,80(sp)
    80002d2a:	e4a6                	sd	s1,72(sp)
    80002d2c:	e0ca                	sd	s2,64(sp)
    80002d2e:	fc4e                	sd	s3,56(sp)
    80002d30:	f852                	sd	s4,48(sp)
    80002d32:	f456                	sd	s5,40(sp)
    80002d34:	f05a                	sd	s6,32(sp)
    80002d36:	ec5e                	sd	s7,24(sp)
    80002d38:	e862                	sd	s8,16(sp)
    80002d3a:	e466                	sd	s9,8(sp)
    80002d3c:	1080                	addi	s0,sp,96
    80002d3e:	84aa                	mv	s1,a0
    80002d40:	8b2e                	mv	s6,a1
    80002d42:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d44:	00054703          	lbu	a4,0(a0)
    80002d48:	02f00793          	li	a5,47
    80002d4c:	00f70e63          	beq	a4,a5,80002d68 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d50:	834fe0ef          	jal	80000d84 <myproc>
    80002d54:	15053503          	ld	a0,336(a0)
    80002d58:	94bff0ef          	jal	800026a2 <idup>
    80002d5c:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d5e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002d62:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d64:	4b85                	li	s7,1
    80002d66:	a871                	j	80002e02 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002d68:	4585                	li	a1,1
    80002d6a:	4505                	li	a0,1
    80002d6c:	ef8ff0ef          	jal	80002464 <iget>
    80002d70:	8a2a                	mv	s4,a0
    80002d72:	b7f5                	j	80002d5e <namex+0x3a>
      iunlockput(ip);
    80002d74:	8552                	mv	a0,s4
    80002d76:	b6dff0ef          	jal	800028e2 <iunlockput>
      return 0;
    80002d7a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d7c:	8552                	mv	a0,s4
    80002d7e:	60e6                	ld	ra,88(sp)
    80002d80:	6446                	ld	s0,80(sp)
    80002d82:	64a6                	ld	s1,72(sp)
    80002d84:	6906                	ld	s2,64(sp)
    80002d86:	79e2                	ld	s3,56(sp)
    80002d88:	7a42                	ld	s4,48(sp)
    80002d8a:	7aa2                	ld	s5,40(sp)
    80002d8c:	7b02                	ld	s6,32(sp)
    80002d8e:	6be2                	ld	s7,24(sp)
    80002d90:	6c42                	ld	s8,16(sp)
    80002d92:	6ca2                	ld	s9,8(sp)
    80002d94:	6125                	addi	sp,sp,96
    80002d96:	8082                	ret
      iunlock(ip);
    80002d98:	8552                	mv	a0,s4
    80002d9a:	9edff0ef          	jal	80002786 <iunlock>
      return ip;
    80002d9e:	bff9                	j	80002d7c <namex+0x58>
      iunlockput(ip);
    80002da0:	8552                	mv	a0,s4
    80002da2:	b41ff0ef          	jal	800028e2 <iunlockput>
      return 0;
    80002da6:	8a4e                	mv	s4,s3
    80002da8:	bfd1                	j	80002d7c <namex+0x58>
  len = path - s;
    80002daa:	40998633          	sub	a2,s3,s1
    80002dae:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002db2:	099c5063          	bge	s8,s9,80002e32 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002db6:	4639                	li	a2,14
    80002db8:	85a6                	mv	a1,s1
    80002dba:	8556                	mv	a0,s5
    80002dbc:	bd4fd0ef          	jal	80000190 <memmove>
    80002dc0:	84ce                	mv	s1,s3
  while(*path == '/')
    80002dc2:	0004c783          	lbu	a5,0(s1)
    80002dc6:	01279763          	bne	a5,s2,80002dd4 <namex+0xb0>
    path++;
    80002dca:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dcc:	0004c783          	lbu	a5,0(s1)
    80002dd0:	ff278de3          	beq	a5,s2,80002dca <namex+0xa6>
    ilock(ip);
    80002dd4:	8552                	mv	a0,s4
    80002dd6:	903ff0ef          	jal	800026d8 <ilock>
    if(ip->type != T_DIR){
    80002dda:	044a1783          	lh	a5,68(s4)
    80002dde:	f9779be3          	bne	a5,s7,80002d74 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002de2:	000b0563          	beqz	s6,80002dec <namex+0xc8>
    80002de6:	0004c783          	lbu	a5,0(s1)
    80002dea:	d7dd                	beqz	a5,80002d98 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002dec:	4601                	li	a2,0
    80002dee:	85d6                	mv	a1,s5
    80002df0:	8552                	mv	a0,s4
    80002df2:	e97ff0ef          	jal	80002c88 <dirlookup>
    80002df6:	89aa                	mv	s3,a0
    80002df8:	d545                	beqz	a0,80002da0 <namex+0x7c>
    iunlockput(ip);
    80002dfa:	8552                	mv	a0,s4
    80002dfc:	ae7ff0ef          	jal	800028e2 <iunlockput>
    ip = next;
    80002e00:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002e02:	0004c783          	lbu	a5,0(s1)
    80002e06:	01279763          	bne	a5,s2,80002e14 <namex+0xf0>
    path++;
    80002e0a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e0c:	0004c783          	lbu	a5,0(s1)
    80002e10:	ff278de3          	beq	a5,s2,80002e0a <namex+0xe6>
  if(*path == 0)
    80002e14:	cb8d                	beqz	a5,80002e46 <namex+0x122>
  while(*path != '/' && *path != 0)
    80002e16:	0004c783          	lbu	a5,0(s1)
    80002e1a:	89a6                	mv	s3,s1
  len = path - s;
    80002e1c:	4c81                	li	s9,0
    80002e1e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002e20:	01278963          	beq	a5,s2,80002e32 <namex+0x10e>
    80002e24:	d3d9                	beqz	a5,80002daa <namex+0x86>
    path++;
    80002e26:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002e28:	0009c783          	lbu	a5,0(s3)
    80002e2c:	ff279ce3          	bne	a5,s2,80002e24 <namex+0x100>
    80002e30:	bfad                	j	80002daa <namex+0x86>
    memmove(name, s, len);
    80002e32:	2601                	sext.w	a2,a2
    80002e34:	85a6                	mv	a1,s1
    80002e36:	8556                	mv	a0,s5
    80002e38:	b58fd0ef          	jal	80000190 <memmove>
    name[len] = 0;
    80002e3c:	9cd6                	add	s9,s9,s5
    80002e3e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002e42:	84ce                	mv	s1,s3
    80002e44:	bfbd                	j	80002dc2 <namex+0x9e>
  if(nameiparent){
    80002e46:	f20b0be3          	beqz	s6,80002d7c <namex+0x58>
    iput(ip);
    80002e4a:	8552                	mv	a0,s4
    80002e4c:	a0fff0ef          	jal	8000285a <iput>
    return 0;
    80002e50:	4a01                	li	s4,0
    80002e52:	b72d                	j	80002d7c <namex+0x58>

0000000080002e54 <dirlink>:
{
    80002e54:	7139                	addi	sp,sp,-64
    80002e56:	fc06                	sd	ra,56(sp)
    80002e58:	f822                	sd	s0,48(sp)
    80002e5a:	f04a                	sd	s2,32(sp)
    80002e5c:	ec4e                	sd	s3,24(sp)
    80002e5e:	e852                	sd	s4,16(sp)
    80002e60:	0080                	addi	s0,sp,64
    80002e62:	892a                	mv	s2,a0
    80002e64:	8a2e                	mv	s4,a1
    80002e66:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e68:	4601                	li	a2,0
    80002e6a:	e1fff0ef          	jal	80002c88 <dirlookup>
    80002e6e:	e535                	bnez	a0,80002eda <dirlink+0x86>
    80002e70:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e72:	04c92483          	lw	s1,76(s2)
    80002e76:	c48d                	beqz	s1,80002ea0 <dirlink+0x4c>
    80002e78:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e7a:	4741                	li	a4,16
    80002e7c:	86a6                	mv	a3,s1
    80002e7e:	fc040613          	addi	a2,s0,-64
    80002e82:	4581                	li	a1,0
    80002e84:	854a                	mv	a0,s2
    80002e86:	be3ff0ef          	jal	80002a68 <readi>
    80002e8a:	47c1                	li	a5,16
    80002e8c:	04f51b63          	bne	a0,a5,80002ee2 <dirlink+0x8e>
    if(de.inum == 0)
    80002e90:	fc045783          	lhu	a5,-64(s0)
    80002e94:	c791                	beqz	a5,80002ea0 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e96:	24c1                	addiw	s1,s1,16
    80002e98:	04c92783          	lw	a5,76(s2)
    80002e9c:	fcf4efe3          	bltu	s1,a5,80002e7a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002ea0:	4639                	li	a2,14
    80002ea2:	85d2                	mv	a1,s4
    80002ea4:	fc240513          	addi	a0,s0,-62
    80002ea8:	b8efd0ef          	jal	80000236 <strncpy>
  de.inum = inum;
    80002eac:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eb0:	4741                	li	a4,16
    80002eb2:	86a6                	mv	a3,s1
    80002eb4:	fc040613          	addi	a2,s0,-64
    80002eb8:	4581                	li	a1,0
    80002eba:	854a                	mv	a0,s2
    80002ebc:	ca9ff0ef          	jal	80002b64 <writei>
    80002ec0:	1541                	addi	a0,a0,-16
    80002ec2:	00a03533          	snez	a0,a0
    80002ec6:	40a00533          	neg	a0,a0
    80002eca:	74a2                	ld	s1,40(sp)
}
    80002ecc:	70e2                	ld	ra,56(sp)
    80002ece:	7442                	ld	s0,48(sp)
    80002ed0:	7902                	ld	s2,32(sp)
    80002ed2:	69e2                	ld	s3,24(sp)
    80002ed4:	6a42                	ld	s4,16(sp)
    80002ed6:	6121                	addi	sp,sp,64
    80002ed8:	8082                	ret
    iput(ip);
    80002eda:	981ff0ef          	jal	8000285a <iput>
    return -1;
    80002ede:	557d                	li	a0,-1
    80002ee0:	b7f5                	j	80002ecc <dirlink+0x78>
      panic("dirlink read");
    80002ee2:	00004517          	auipc	a0,0x4
    80002ee6:	65650513          	addi	a0,a0,1622 # 80007538 <etext+0x538>
    80002eea:	734020ef          	jal	8000561e <panic>

0000000080002eee <namei>:

struct inode*
namei(char *path)
{
    80002eee:	1101                	addi	sp,sp,-32
    80002ef0:	ec06                	sd	ra,24(sp)
    80002ef2:	e822                	sd	s0,16(sp)
    80002ef4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002ef6:	fe040613          	addi	a2,s0,-32
    80002efa:	4581                	li	a1,0
    80002efc:	e29ff0ef          	jal	80002d24 <namex>
}
    80002f00:	60e2                	ld	ra,24(sp)
    80002f02:	6442                	ld	s0,16(sp)
    80002f04:	6105                	addi	sp,sp,32
    80002f06:	8082                	ret

0000000080002f08 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002f08:	1141                	addi	sp,sp,-16
    80002f0a:	e406                	sd	ra,8(sp)
    80002f0c:	e022                	sd	s0,0(sp)
    80002f0e:	0800                	addi	s0,sp,16
    80002f10:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f12:	4585                	li	a1,1
    80002f14:	e11ff0ef          	jal	80002d24 <namex>
}
    80002f18:	60a2                	ld	ra,8(sp)
    80002f1a:	6402                	ld	s0,0(sp)
    80002f1c:	0141                	addi	sp,sp,16
    80002f1e:	8082                	ret

0000000080002f20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f20:	1101                	addi	sp,sp,-32
    80002f22:	ec06                	sd	ra,24(sp)
    80002f24:	e822                	sd	s0,16(sp)
    80002f26:	e426                	sd	s1,8(sp)
    80002f28:	e04a                	sd	s2,0(sp)
    80002f2a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f2c:	00017917          	auipc	s2,0x17
    80002f30:	64490913          	addi	s2,s2,1604 # 8001a570 <log>
    80002f34:	01892583          	lw	a1,24(s2)
    80002f38:	02492503          	lw	a0,36(s2)
    80002f3c:	8d0ff0ef          	jal	8000200c <bread>
    80002f40:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f42:	02892603          	lw	a2,40(s2)
    80002f46:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f48:	00c05f63          	blez	a2,80002f66 <write_head+0x46>
    80002f4c:	00017717          	auipc	a4,0x17
    80002f50:	65070713          	addi	a4,a4,1616 # 8001a59c <log+0x2c>
    80002f54:	87aa                	mv	a5,a0
    80002f56:	060a                	slli	a2,a2,0x2
    80002f58:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f5a:	4314                	lw	a3,0(a4)
    80002f5c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f5e:	0711                	addi	a4,a4,4
    80002f60:	0791                	addi	a5,a5,4
    80002f62:	fec79ce3          	bne	a5,a2,80002f5a <write_head+0x3a>
  }
  bwrite(buf);
    80002f66:	8526                	mv	a0,s1
    80002f68:	97aff0ef          	jal	800020e2 <bwrite>
  brelse(buf);
    80002f6c:	8526                	mv	a0,s1
    80002f6e:	9a6ff0ef          	jal	80002114 <brelse>
}
    80002f72:	60e2                	ld	ra,24(sp)
    80002f74:	6442                	ld	s0,16(sp)
    80002f76:	64a2                	ld	s1,8(sp)
    80002f78:	6902                	ld	s2,0(sp)
    80002f7a:	6105                	addi	sp,sp,32
    80002f7c:	8082                	ret

0000000080002f7e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f7e:	00017797          	auipc	a5,0x17
    80002f82:	61a7a783          	lw	a5,1562(a5) # 8001a598 <log+0x28>
    80002f86:	0af05e63          	blez	a5,80003042 <install_trans+0xc4>
{
    80002f8a:	715d                	addi	sp,sp,-80
    80002f8c:	e486                	sd	ra,72(sp)
    80002f8e:	e0a2                	sd	s0,64(sp)
    80002f90:	fc26                	sd	s1,56(sp)
    80002f92:	f84a                	sd	s2,48(sp)
    80002f94:	f44e                	sd	s3,40(sp)
    80002f96:	f052                	sd	s4,32(sp)
    80002f98:	ec56                	sd	s5,24(sp)
    80002f9a:	e85a                	sd	s6,16(sp)
    80002f9c:	e45e                	sd	s7,8(sp)
    80002f9e:	0880                	addi	s0,sp,80
    80002fa0:	8b2a                	mv	s6,a0
    80002fa2:	00017a97          	auipc	s5,0x17
    80002fa6:	5faa8a93          	addi	s5,s5,1530 # 8001a59c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002faa:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002fac:	00004b97          	auipc	s7,0x4
    80002fb0:	59cb8b93          	addi	s7,s7,1436 # 80007548 <etext+0x548>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fb4:	00017a17          	auipc	s4,0x17
    80002fb8:	5bca0a13          	addi	s4,s4,1468 # 8001a570 <log>
    80002fbc:	a025                	j	80002fe4 <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002fbe:	000aa603          	lw	a2,0(s5)
    80002fc2:	85ce                	mv	a1,s3
    80002fc4:	855e                	mv	a0,s7
    80002fc6:	372020ef          	jal	80005338 <printf>
    80002fca:	a839                	j	80002fe8 <install_trans+0x6a>
    brelse(lbuf);
    80002fcc:	854a                	mv	a0,s2
    80002fce:	946ff0ef          	jal	80002114 <brelse>
    brelse(dbuf);
    80002fd2:	8526                	mv	a0,s1
    80002fd4:	940ff0ef          	jal	80002114 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fd8:	2985                	addiw	s3,s3,1
    80002fda:	0a91                	addi	s5,s5,4
    80002fdc:	028a2783          	lw	a5,40(s4)
    80002fe0:	04f9d663          	bge	s3,a5,8000302c <install_trans+0xae>
    if(recovering) {
    80002fe4:	fc0b1de3          	bnez	s6,80002fbe <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fe8:	018a2583          	lw	a1,24(s4)
    80002fec:	013585bb          	addw	a1,a1,s3
    80002ff0:	2585                	addiw	a1,a1,1
    80002ff2:	024a2503          	lw	a0,36(s4)
    80002ff6:	816ff0ef          	jal	8000200c <bread>
    80002ffa:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002ffc:	000aa583          	lw	a1,0(s5)
    80003000:	024a2503          	lw	a0,36(s4)
    80003004:	808ff0ef          	jal	8000200c <bread>
    80003008:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000300a:	40000613          	li	a2,1024
    8000300e:	05890593          	addi	a1,s2,88
    80003012:	05850513          	addi	a0,a0,88
    80003016:	97afd0ef          	jal	80000190 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000301a:	8526                	mv	a0,s1
    8000301c:	8c6ff0ef          	jal	800020e2 <bwrite>
    if(recovering == 0)
    80003020:	fa0b16e3          	bnez	s6,80002fcc <install_trans+0x4e>
      bunpin(dbuf);
    80003024:	8526                	mv	a0,s1
    80003026:	9aaff0ef          	jal	800021d0 <bunpin>
    8000302a:	b74d                	j	80002fcc <install_trans+0x4e>
}
    8000302c:	60a6                	ld	ra,72(sp)
    8000302e:	6406                	ld	s0,64(sp)
    80003030:	74e2                	ld	s1,56(sp)
    80003032:	7942                	ld	s2,48(sp)
    80003034:	79a2                	ld	s3,40(sp)
    80003036:	7a02                	ld	s4,32(sp)
    80003038:	6ae2                	ld	s5,24(sp)
    8000303a:	6b42                	ld	s6,16(sp)
    8000303c:	6ba2                	ld	s7,8(sp)
    8000303e:	6161                	addi	sp,sp,80
    80003040:	8082                	ret
    80003042:	8082                	ret

0000000080003044 <initlog>:
{
    80003044:	7179                	addi	sp,sp,-48
    80003046:	f406                	sd	ra,40(sp)
    80003048:	f022                	sd	s0,32(sp)
    8000304a:	ec26                	sd	s1,24(sp)
    8000304c:	e84a                	sd	s2,16(sp)
    8000304e:	e44e                	sd	s3,8(sp)
    80003050:	1800                	addi	s0,sp,48
    80003052:	892a                	mv	s2,a0
    80003054:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003056:	00017497          	auipc	s1,0x17
    8000305a:	51a48493          	addi	s1,s1,1306 # 8001a570 <log>
    8000305e:	00004597          	auipc	a1,0x4
    80003062:	50a58593          	addi	a1,a1,1290 # 80007568 <etext+0x568>
    80003066:	8526                	mv	a0,s1
    80003068:	7f2020ef          	jal	8000585a <initlock>
  log.start = sb->logstart;
    8000306c:	0149a583          	lw	a1,20(s3)
    80003070:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003072:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003076:	854a                	mv	a0,s2
    80003078:	f95fe0ef          	jal	8000200c <bread>
  log.lh.n = lh->n;
    8000307c:	4d30                	lw	a2,88(a0)
    8000307e:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003080:	00c05f63          	blez	a2,8000309e <initlog+0x5a>
    80003084:	87aa                	mv	a5,a0
    80003086:	00017717          	auipc	a4,0x17
    8000308a:	51670713          	addi	a4,a4,1302 # 8001a59c <log+0x2c>
    8000308e:	060a                	slli	a2,a2,0x2
    80003090:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003092:	4ff4                	lw	a3,92(a5)
    80003094:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003096:	0791                	addi	a5,a5,4
    80003098:	0711                	addi	a4,a4,4
    8000309a:	fec79ce3          	bne	a5,a2,80003092 <initlog+0x4e>
  brelse(buf);
    8000309e:	876ff0ef          	jal	80002114 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800030a2:	4505                	li	a0,1
    800030a4:	edbff0ef          	jal	80002f7e <install_trans>
  log.lh.n = 0;
    800030a8:	00017797          	auipc	a5,0x17
    800030ac:	4e07a823          	sw	zero,1264(a5) # 8001a598 <log+0x28>
  write_head(); // clear the log
    800030b0:	e71ff0ef          	jal	80002f20 <write_head>
}
    800030b4:	70a2                	ld	ra,40(sp)
    800030b6:	7402                	ld	s0,32(sp)
    800030b8:	64e2                	ld	s1,24(sp)
    800030ba:	6942                	ld	s2,16(sp)
    800030bc:	69a2                	ld	s3,8(sp)
    800030be:	6145                	addi	sp,sp,48
    800030c0:	8082                	ret

00000000800030c2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030c2:	1101                	addi	sp,sp,-32
    800030c4:	ec06                	sd	ra,24(sp)
    800030c6:	e822                	sd	s0,16(sp)
    800030c8:	e426                	sd	s1,8(sp)
    800030ca:	e04a                	sd	s2,0(sp)
    800030cc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800030ce:	00017517          	auipc	a0,0x17
    800030d2:	4a250513          	addi	a0,a0,1186 # 8001a570 <log>
    800030d6:	005020ef          	jal	800058da <acquire>
  while(1){
    if(log.committing){
    800030da:	00017497          	auipc	s1,0x17
    800030de:	49648493          	addi	s1,s1,1174 # 8001a570 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030e2:	4979                	li	s2,30
    800030e4:	a029                	j	800030ee <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030e6:	85a6                	mv	a1,s1
    800030e8:	8526                	mv	a0,s1
    800030ea:	a9afe0ef          	jal	80001384 <sleep>
    if(log.committing){
    800030ee:	509c                	lw	a5,32(s1)
    800030f0:	fbfd                	bnez	a5,800030e6 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030f2:	4cd8                	lw	a4,28(s1)
    800030f4:	2705                	addiw	a4,a4,1
    800030f6:	0027179b          	slliw	a5,a4,0x2
    800030fa:	9fb9                	addw	a5,a5,a4
    800030fc:	0017979b          	slliw	a5,a5,0x1
    80003100:	5494                	lw	a3,40(s1)
    80003102:	9fb5                	addw	a5,a5,a3
    80003104:	00f95763          	bge	s2,a5,80003112 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003108:	85a6                	mv	a1,s1
    8000310a:	8526                	mv	a0,s1
    8000310c:	a78fe0ef          	jal	80001384 <sleep>
    80003110:	bff9                	j	800030ee <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003112:	00017517          	auipc	a0,0x17
    80003116:	45e50513          	addi	a0,a0,1118 # 8001a570 <log>
    8000311a:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    8000311c:	057020ef          	jal	80005972 <release>
      break;
    }
  }
}
    80003120:	60e2                	ld	ra,24(sp)
    80003122:	6442                	ld	s0,16(sp)
    80003124:	64a2                	ld	s1,8(sp)
    80003126:	6902                	ld	s2,0(sp)
    80003128:	6105                	addi	sp,sp,32
    8000312a:	8082                	ret

000000008000312c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000312c:	7139                	addi	sp,sp,-64
    8000312e:	fc06                	sd	ra,56(sp)
    80003130:	f822                	sd	s0,48(sp)
    80003132:	f426                	sd	s1,40(sp)
    80003134:	f04a                	sd	s2,32(sp)
    80003136:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003138:	00017497          	auipc	s1,0x17
    8000313c:	43848493          	addi	s1,s1,1080 # 8001a570 <log>
    80003140:	8526                	mv	a0,s1
    80003142:	798020ef          	jal	800058da <acquire>
  log.outstanding -= 1;
    80003146:	4cdc                	lw	a5,28(s1)
    80003148:	37fd                	addiw	a5,a5,-1
    8000314a:	0007891b          	sext.w	s2,a5
    8000314e:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003150:	509c                	lw	a5,32(s1)
    80003152:	ef9d                	bnez	a5,80003190 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003154:	04091763          	bnez	s2,800031a2 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003158:	00017497          	auipc	s1,0x17
    8000315c:	41848493          	addi	s1,s1,1048 # 8001a570 <log>
    80003160:	4785                	li	a5,1
    80003162:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003164:	8526                	mv	a0,s1
    80003166:	00d020ef          	jal	80005972 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000316a:	549c                	lw	a5,40(s1)
    8000316c:	04f04b63          	bgtz	a5,800031c2 <end_op+0x96>
    acquire(&log.lock);
    80003170:	00017497          	auipc	s1,0x17
    80003174:	40048493          	addi	s1,s1,1024 # 8001a570 <log>
    80003178:	8526                	mv	a0,s1
    8000317a:	760020ef          	jal	800058da <acquire>
    log.committing = 0;
    8000317e:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003182:	8526                	mv	a0,s1
    80003184:	a4cfe0ef          	jal	800013d0 <wakeup>
    release(&log.lock);
    80003188:	8526                	mv	a0,s1
    8000318a:	7e8020ef          	jal	80005972 <release>
}
    8000318e:	a025                	j	800031b6 <end_op+0x8a>
    80003190:	ec4e                	sd	s3,24(sp)
    80003192:	e852                	sd	s4,16(sp)
    80003194:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003196:	00004517          	auipc	a0,0x4
    8000319a:	3da50513          	addi	a0,a0,986 # 80007570 <etext+0x570>
    8000319e:	480020ef          	jal	8000561e <panic>
    wakeup(&log);
    800031a2:	00017497          	auipc	s1,0x17
    800031a6:	3ce48493          	addi	s1,s1,974 # 8001a570 <log>
    800031aa:	8526                	mv	a0,s1
    800031ac:	a24fe0ef          	jal	800013d0 <wakeup>
  release(&log.lock);
    800031b0:	8526                	mv	a0,s1
    800031b2:	7c0020ef          	jal	80005972 <release>
}
    800031b6:	70e2                	ld	ra,56(sp)
    800031b8:	7442                	ld	s0,48(sp)
    800031ba:	74a2                	ld	s1,40(sp)
    800031bc:	7902                	ld	s2,32(sp)
    800031be:	6121                	addi	sp,sp,64
    800031c0:	8082                	ret
    800031c2:	ec4e                	sd	s3,24(sp)
    800031c4:	e852                	sd	s4,16(sp)
    800031c6:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800031c8:	00017a97          	auipc	s5,0x17
    800031cc:	3d4a8a93          	addi	s5,s5,980 # 8001a59c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031d0:	00017a17          	auipc	s4,0x17
    800031d4:	3a0a0a13          	addi	s4,s4,928 # 8001a570 <log>
    800031d8:	018a2583          	lw	a1,24(s4)
    800031dc:	012585bb          	addw	a1,a1,s2
    800031e0:	2585                	addiw	a1,a1,1
    800031e2:	024a2503          	lw	a0,36(s4)
    800031e6:	e27fe0ef          	jal	8000200c <bread>
    800031ea:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031ec:	000aa583          	lw	a1,0(s5)
    800031f0:	024a2503          	lw	a0,36(s4)
    800031f4:	e19fe0ef          	jal	8000200c <bread>
    800031f8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031fa:	40000613          	li	a2,1024
    800031fe:	05850593          	addi	a1,a0,88
    80003202:	05848513          	addi	a0,s1,88
    80003206:	f8bfc0ef          	jal	80000190 <memmove>
    bwrite(to);  // write the log
    8000320a:	8526                	mv	a0,s1
    8000320c:	ed7fe0ef          	jal	800020e2 <bwrite>
    brelse(from);
    80003210:	854e                	mv	a0,s3
    80003212:	f03fe0ef          	jal	80002114 <brelse>
    brelse(to);
    80003216:	8526                	mv	a0,s1
    80003218:	efdfe0ef          	jal	80002114 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000321c:	2905                	addiw	s2,s2,1
    8000321e:	0a91                	addi	s5,s5,4
    80003220:	028a2783          	lw	a5,40(s4)
    80003224:	faf94ae3          	blt	s2,a5,800031d8 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003228:	cf9ff0ef          	jal	80002f20 <write_head>
    install_trans(0); // Now install writes to home locations
    8000322c:	4501                	li	a0,0
    8000322e:	d51ff0ef          	jal	80002f7e <install_trans>
    log.lh.n = 0;
    80003232:	00017797          	auipc	a5,0x17
    80003236:	3607a323          	sw	zero,870(a5) # 8001a598 <log+0x28>
    write_head();    // Erase the transaction from the log
    8000323a:	ce7ff0ef          	jal	80002f20 <write_head>
    8000323e:	69e2                	ld	s3,24(sp)
    80003240:	6a42                	ld	s4,16(sp)
    80003242:	6aa2                	ld	s5,8(sp)
    80003244:	b735                	j	80003170 <end_op+0x44>

0000000080003246 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003246:	1101                	addi	sp,sp,-32
    80003248:	ec06                	sd	ra,24(sp)
    8000324a:	e822                	sd	s0,16(sp)
    8000324c:	e426                	sd	s1,8(sp)
    8000324e:	e04a                	sd	s2,0(sp)
    80003250:	1000                	addi	s0,sp,32
    80003252:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003254:	00017917          	auipc	s2,0x17
    80003258:	31c90913          	addi	s2,s2,796 # 8001a570 <log>
    8000325c:	854a                	mv	a0,s2
    8000325e:	67c020ef          	jal	800058da <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003262:	02892603          	lw	a2,40(s2)
    80003266:	47f5                	li	a5,29
    80003268:	04c7cc63          	blt	a5,a2,800032c0 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000326c:	00017797          	auipc	a5,0x17
    80003270:	3207a783          	lw	a5,800(a5) # 8001a58c <log+0x1c>
    80003274:	04f05c63          	blez	a5,800032cc <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003278:	4781                	li	a5,0
    8000327a:	04c05f63          	blez	a2,800032d8 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000327e:	44cc                	lw	a1,12(s1)
    80003280:	00017717          	auipc	a4,0x17
    80003284:	31c70713          	addi	a4,a4,796 # 8001a59c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003288:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000328a:	4314                	lw	a3,0(a4)
    8000328c:	04b68663          	beq	a3,a1,800032d8 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003290:	2785                	addiw	a5,a5,1
    80003292:	0711                	addi	a4,a4,4
    80003294:	fef61be3          	bne	a2,a5,8000328a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003298:	0621                	addi	a2,a2,8
    8000329a:	060a                	slli	a2,a2,0x2
    8000329c:	00017797          	auipc	a5,0x17
    800032a0:	2d478793          	addi	a5,a5,724 # 8001a570 <log>
    800032a4:	97b2                	add	a5,a5,a2
    800032a6:	44d8                	lw	a4,12(s1)
    800032a8:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800032aa:	8526                	mv	a0,s1
    800032ac:	ef1fe0ef          	jal	8000219c <bpin>
    log.lh.n++;
    800032b0:	00017717          	auipc	a4,0x17
    800032b4:	2c070713          	addi	a4,a4,704 # 8001a570 <log>
    800032b8:	571c                	lw	a5,40(a4)
    800032ba:	2785                	addiw	a5,a5,1
    800032bc:	d71c                	sw	a5,40(a4)
    800032be:	a80d                	j	800032f0 <log_write+0xaa>
    panic("too big a transaction");
    800032c0:	00004517          	auipc	a0,0x4
    800032c4:	2c050513          	addi	a0,a0,704 # 80007580 <etext+0x580>
    800032c8:	356020ef          	jal	8000561e <panic>
    panic("log_write outside of trans");
    800032cc:	00004517          	auipc	a0,0x4
    800032d0:	2cc50513          	addi	a0,a0,716 # 80007598 <etext+0x598>
    800032d4:	34a020ef          	jal	8000561e <panic>
  log.lh.block[i] = b->blockno;
    800032d8:	00878693          	addi	a3,a5,8
    800032dc:	068a                	slli	a3,a3,0x2
    800032de:	00017717          	auipc	a4,0x17
    800032e2:	29270713          	addi	a4,a4,658 # 8001a570 <log>
    800032e6:	9736                	add	a4,a4,a3
    800032e8:	44d4                	lw	a3,12(s1)
    800032ea:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032ec:	faf60fe3          	beq	a2,a5,800032aa <log_write+0x64>
  }
  release(&log.lock);
    800032f0:	00017517          	auipc	a0,0x17
    800032f4:	28050513          	addi	a0,a0,640 # 8001a570 <log>
    800032f8:	67a020ef          	jal	80005972 <release>
}
    800032fc:	60e2                	ld	ra,24(sp)
    800032fe:	6442                	ld	s0,16(sp)
    80003300:	64a2                	ld	s1,8(sp)
    80003302:	6902                	ld	s2,0(sp)
    80003304:	6105                	addi	sp,sp,32
    80003306:	8082                	ret

0000000080003308 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003308:	1101                	addi	sp,sp,-32
    8000330a:	ec06                	sd	ra,24(sp)
    8000330c:	e822                	sd	s0,16(sp)
    8000330e:	e426                	sd	s1,8(sp)
    80003310:	e04a                	sd	s2,0(sp)
    80003312:	1000                	addi	s0,sp,32
    80003314:	84aa                	mv	s1,a0
    80003316:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003318:	00004597          	auipc	a1,0x4
    8000331c:	2a058593          	addi	a1,a1,672 # 800075b8 <etext+0x5b8>
    80003320:	0521                	addi	a0,a0,8
    80003322:	538020ef          	jal	8000585a <initlock>
  lk->name = name;
    80003326:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000332a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000332e:	0204a423          	sw	zero,40(s1)
}
    80003332:	60e2                	ld	ra,24(sp)
    80003334:	6442                	ld	s0,16(sp)
    80003336:	64a2                	ld	s1,8(sp)
    80003338:	6902                	ld	s2,0(sp)
    8000333a:	6105                	addi	sp,sp,32
    8000333c:	8082                	ret

000000008000333e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000333e:	1101                	addi	sp,sp,-32
    80003340:	ec06                	sd	ra,24(sp)
    80003342:	e822                	sd	s0,16(sp)
    80003344:	e426                	sd	s1,8(sp)
    80003346:	e04a                	sd	s2,0(sp)
    80003348:	1000                	addi	s0,sp,32
    8000334a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000334c:	00850913          	addi	s2,a0,8
    80003350:	854a                	mv	a0,s2
    80003352:	588020ef          	jal	800058da <acquire>
  while (lk->locked) {
    80003356:	409c                	lw	a5,0(s1)
    80003358:	c799                	beqz	a5,80003366 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000335a:	85ca                	mv	a1,s2
    8000335c:	8526                	mv	a0,s1
    8000335e:	826fe0ef          	jal	80001384 <sleep>
  while (lk->locked) {
    80003362:	409c                	lw	a5,0(s1)
    80003364:	fbfd                	bnez	a5,8000335a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003366:	4785                	li	a5,1
    80003368:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000336a:	a1bfd0ef          	jal	80000d84 <myproc>
    8000336e:	591c                	lw	a5,48(a0)
    80003370:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003372:	854a                	mv	a0,s2
    80003374:	5fe020ef          	jal	80005972 <release>
}
    80003378:	60e2                	ld	ra,24(sp)
    8000337a:	6442                	ld	s0,16(sp)
    8000337c:	64a2                	ld	s1,8(sp)
    8000337e:	6902                	ld	s2,0(sp)
    80003380:	6105                	addi	sp,sp,32
    80003382:	8082                	ret

0000000080003384 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003384:	1101                	addi	sp,sp,-32
    80003386:	ec06                	sd	ra,24(sp)
    80003388:	e822                	sd	s0,16(sp)
    8000338a:	e426                	sd	s1,8(sp)
    8000338c:	e04a                	sd	s2,0(sp)
    8000338e:	1000                	addi	s0,sp,32
    80003390:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003392:	00850913          	addi	s2,a0,8
    80003396:	854a                	mv	a0,s2
    80003398:	542020ef          	jal	800058da <acquire>
  lk->locked = 0;
    8000339c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033a0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800033a4:	8526                	mv	a0,s1
    800033a6:	82afe0ef          	jal	800013d0 <wakeup>
  release(&lk->lk);
    800033aa:	854a                	mv	a0,s2
    800033ac:	5c6020ef          	jal	80005972 <release>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	64a2                	ld	s1,8(sp)
    800033b6:	6902                	ld	s2,0(sp)
    800033b8:	6105                	addi	sp,sp,32
    800033ba:	8082                	ret

00000000800033bc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800033bc:	7179                	addi	sp,sp,-48
    800033be:	f406                	sd	ra,40(sp)
    800033c0:	f022                	sd	s0,32(sp)
    800033c2:	ec26                	sd	s1,24(sp)
    800033c4:	e84a                	sd	s2,16(sp)
    800033c6:	1800                	addi	s0,sp,48
    800033c8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033ca:	00850913          	addi	s2,a0,8
    800033ce:	854a                	mv	a0,s2
    800033d0:	50a020ef          	jal	800058da <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033d4:	409c                	lw	a5,0(s1)
    800033d6:	ef81                	bnez	a5,800033ee <holdingsleep+0x32>
    800033d8:	4481                	li	s1,0
  release(&lk->lk);
    800033da:	854a                	mv	a0,s2
    800033dc:	596020ef          	jal	80005972 <release>
  return r;
}
    800033e0:	8526                	mv	a0,s1
    800033e2:	70a2                	ld	ra,40(sp)
    800033e4:	7402                	ld	s0,32(sp)
    800033e6:	64e2                	ld	s1,24(sp)
    800033e8:	6942                	ld	s2,16(sp)
    800033ea:	6145                	addi	sp,sp,48
    800033ec:	8082                	ret
    800033ee:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800033f0:	0284a983          	lw	s3,40(s1)
    800033f4:	991fd0ef          	jal	80000d84 <myproc>
    800033f8:	5904                	lw	s1,48(a0)
    800033fa:	413484b3          	sub	s1,s1,s3
    800033fe:	0014b493          	seqz	s1,s1
    80003402:	69a2                	ld	s3,8(sp)
    80003404:	bfd9                	j	800033da <holdingsleep+0x1e>

0000000080003406 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003406:	1141                	addi	sp,sp,-16
    80003408:	e406                	sd	ra,8(sp)
    8000340a:	e022                	sd	s0,0(sp)
    8000340c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000340e:	00004597          	auipc	a1,0x4
    80003412:	1ba58593          	addi	a1,a1,442 # 800075c8 <etext+0x5c8>
    80003416:	00017517          	auipc	a0,0x17
    8000341a:	2a250513          	addi	a0,a0,674 # 8001a6b8 <ftable>
    8000341e:	43c020ef          	jal	8000585a <initlock>
}
    80003422:	60a2                	ld	ra,8(sp)
    80003424:	6402                	ld	s0,0(sp)
    80003426:	0141                	addi	sp,sp,16
    80003428:	8082                	ret

000000008000342a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000342a:	1101                	addi	sp,sp,-32
    8000342c:	ec06                	sd	ra,24(sp)
    8000342e:	e822                	sd	s0,16(sp)
    80003430:	e426                	sd	s1,8(sp)
    80003432:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003434:	00017517          	auipc	a0,0x17
    80003438:	28450513          	addi	a0,a0,644 # 8001a6b8 <ftable>
    8000343c:	49e020ef          	jal	800058da <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003440:	00017497          	auipc	s1,0x17
    80003444:	29048493          	addi	s1,s1,656 # 8001a6d0 <ftable+0x18>
    80003448:	00018717          	auipc	a4,0x18
    8000344c:	22870713          	addi	a4,a4,552 # 8001b670 <disk>
    if(f->ref == 0){
    80003450:	40dc                	lw	a5,4(s1)
    80003452:	cf89                	beqz	a5,8000346c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003454:	02848493          	addi	s1,s1,40
    80003458:	fee49ce3          	bne	s1,a4,80003450 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000345c:	00017517          	auipc	a0,0x17
    80003460:	25c50513          	addi	a0,a0,604 # 8001a6b8 <ftable>
    80003464:	50e020ef          	jal	80005972 <release>
  return 0;
    80003468:	4481                	li	s1,0
    8000346a:	a809                	j	8000347c <filealloc+0x52>
      f->ref = 1;
    8000346c:	4785                	li	a5,1
    8000346e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003470:	00017517          	auipc	a0,0x17
    80003474:	24850513          	addi	a0,a0,584 # 8001a6b8 <ftable>
    80003478:	4fa020ef          	jal	80005972 <release>
}
    8000347c:	8526                	mv	a0,s1
    8000347e:	60e2                	ld	ra,24(sp)
    80003480:	6442                	ld	s0,16(sp)
    80003482:	64a2                	ld	s1,8(sp)
    80003484:	6105                	addi	sp,sp,32
    80003486:	8082                	ret

0000000080003488 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003488:	1101                	addi	sp,sp,-32
    8000348a:	ec06                	sd	ra,24(sp)
    8000348c:	e822                	sd	s0,16(sp)
    8000348e:	e426                	sd	s1,8(sp)
    80003490:	1000                	addi	s0,sp,32
    80003492:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003494:	00017517          	auipc	a0,0x17
    80003498:	22450513          	addi	a0,a0,548 # 8001a6b8 <ftable>
    8000349c:	43e020ef          	jal	800058da <acquire>
  if(f->ref < 1)
    800034a0:	40dc                	lw	a5,4(s1)
    800034a2:	02f05063          	blez	a5,800034c2 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800034a6:	2785                	addiw	a5,a5,1
    800034a8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800034aa:	00017517          	auipc	a0,0x17
    800034ae:	20e50513          	addi	a0,a0,526 # 8001a6b8 <ftable>
    800034b2:	4c0020ef          	jal	80005972 <release>
  return f;
}
    800034b6:	8526                	mv	a0,s1
    800034b8:	60e2                	ld	ra,24(sp)
    800034ba:	6442                	ld	s0,16(sp)
    800034bc:	64a2                	ld	s1,8(sp)
    800034be:	6105                	addi	sp,sp,32
    800034c0:	8082                	ret
    panic("filedup");
    800034c2:	00004517          	auipc	a0,0x4
    800034c6:	10e50513          	addi	a0,a0,270 # 800075d0 <etext+0x5d0>
    800034ca:	154020ef          	jal	8000561e <panic>

00000000800034ce <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034ce:	7139                	addi	sp,sp,-64
    800034d0:	fc06                	sd	ra,56(sp)
    800034d2:	f822                	sd	s0,48(sp)
    800034d4:	f426                	sd	s1,40(sp)
    800034d6:	0080                	addi	s0,sp,64
    800034d8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800034da:	00017517          	auipc	a0,0x17
    800034de:	1de50513          	addi	a0,a0,478 # 8001a6b8 <ftable>
    800034e2:	3f8020ef          	jal	800058da <acquire>
  if(f->ref < 1)
    800034e6:	40dc                	lw	a5,4(s1)
    800034e8:	04f05a63          	blez	a5,8000353c <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800034ec:	37fd                	addiw	a5,a5,-1
    800034ee:	0007871b          	sext.w	a4,a5
    800034f2:	c0dc                	sw	a5,4(s1)
    800034f4:	04e04e63          	bgtz	a4,80003550 <fileclose+0x82>
    800034f8:	f04a                	sd	s2,32(sp)
    800034fa:	ec4e                	sd	s3,24(sp)
    800034fc:	e852                	sd	s4,16(sp)
    800034fe:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003500:	0004a903          	lw	s2,0(s1)
    80003504:	0094ca83          	lbu	s5,9(s1)
    80003508:	0104ba03          	ld	s4,16(s1)
    8000350c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003510:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003514:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003518:	00017517          	auipc	a0,0x17
    8000351c:	1a050513          	addi	a0,a0,416 # 8001a6b8 <ftable>
    80003520:	452020ef          	jal	80005972 <release>

  if(ff.type == FD_PIPE){
    80003524:	4785                	li	a5,1
    80003526:	04f90063          	beq	s2,a5,80003566 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000352a:	3979                	addiw	s2,s2,-2
    8000352c:	4785                	li	a5,1
    8000352e:	0527f563          	bgeu	a5,s2,80003578 <fileclose+0xaa>
    80003532:	7902                	ld	s2,32(sp)
    80003534:	69e2                	ld	s3,24(sp)
    80003536:	6a42                	ld	s4,16(sp)
    80003538:	6aa2                	ld	s5,8(sp)
    8000353a:	a00d                	j	8000355c <fileclose+0x8e>
    8000353c:	f04a                	sd	s2,32(sp)
    8000353e:	ec4e                	sd	s3,24(sp)
    80003540:	e852                	sd	s4,16(sp)
    80003542:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003544:	00004517          	auipc	a0,0x4
    80003548:	09450513          	addi	a0,a0,148 # 800075d8 <etext+0x5d8>
    8000354c:	0d2020ef          	jal	8000561e <panic>
    release(&ftable.lock);
    80003550:	00017517          	auipc	a0,0x17
    80003554:	16850513          	addi	a0,a0,360 # 8001a6b8 <ftable>
    80003558:	41a020ef          	jal	80005972 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000355c:	70e2                	ld	ra,56(sp)
    8000355e:	7442                	ld	s0,48(sp)
    80003560:	74a2                	ld	s1,40(sp)
    80003562:	6121                	addi	sp,sp,64
    80003564:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003566:	85d6                	mv	a1,s5
    80003568:	8552                	mv	a0,s4
    8000356a:	336000ef          	jal	800038a0 <pipeclose>
    8000356e:	7902                	ld	s2,32(sp)
    80003570:	69e2                	ld	s3,24(sp)
    80003572:	6a42                	ld	s4,16(sp)
    80003574:	6aa2                	ld	s5,8(sp)
    80003576:	b7dd                	j	8000355c <fileclose+0x8e>
    begin_op();
    80003578:	b4bff0ef          	jal	800030c2 <begin_op>
    iput(ff.ip);
    8000357c:	854e                	mv	a0,s3
    8000357e:	adcff0ef          	jal	8000285a <iput>
    end_op();
    80003582:	babff0ef          	jal	8000312c <end_op>
    80003586:	7902                	ld	s2,32(sp)
    80003588:	69e2                	ld	s3,24(sp)
    8000358a:	6a42                	ld	s4,16(sp)
    8000358c:	6aa2                	ld	s5,8(sp)
    8000358e:	b7f9                	j	8000355c <fileclose+0x8e>

0000000080003590 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003590:	715d                	addi	sp,sp,-80
    80003592:	e486                	sd	ra,72(sp)
    80003594:	e0a2                	sd	s0,64(sp)
    80003596:	fc26                	sd	s1,56(sp)
    80003598:	f44e                	sd	s3,40(sp)
    8000359a:	0880                	addi	s0,sp,80
    8000359c:	84aa                	mv	s1,a0
    8000359e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800035a0:	fe4fd0ef          	jal	80000d84 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800035a4:	409c                	lw	a5,0(s1)
    800035a6:	37f9                	addiw	a5,a5,-2
    800035a8:	4705                	li	a4,1
    800035aa:	04f76063          	bltu	a4,a5,800035ea <filestat+0x5a>
    800035ae:	f84a                	sd	s2,48(sp)
    800035b0:	892a                	mv	s2,a0
    ilock(f->ip);
    800035b2:	6c88                	ld	a0,24(s1)
    800035b4:	924ff0ef          	jal	800026d8 <ilock>
    stati(f->ip, &st);
    800035b8:	fb840593          	addi	a1,s0,-72
    800035bc:	6c88                	ld	a0,24(s1)
    800035be:	c80ff0ef          	jal	80002a3e <stati>
    iunlock(f->ip);
    800035c2:	6c88                	ld	a0,24(s1)
    800035c4:	9c2ff0ef          	jal	80002786 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035c8:	46e1                	li	a3,24
    800035ca:	fb840613          	addi	a2,s0,-72
    800035ce:	85ce                	mv	a1,s3
    800035d0:	05093503          	ld	a0,80(s2)
    800035d4:	cb4fd0ef          	jal	80000a88 <copyout>
    800035d8:	41f5551b          	sraiw	a0,a0,0x1f
    800035dc:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800035de:	60a6                	ld	ra,72(sp)
    800035e0:	6406                	ld	s0,64(sp)
    800035e2:	74e2                	ld	s1,56(sp)
    800035e4:	79a2                	ld	s3,40(sp)
    800035e6:	6161                	addi	sp,sp,80
    800035e8:	8082                	ret
  return -1;
    800035ea:	557d                	li	a0,-1
    800035ec:	bfcd                	j	800035de <filestat+0x4e>

00000000800035ee <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035ee:	7179                	addi	sp,sp,-48
    800035f0:	f406                	sd	ra,40(sp)
    800035f2:	f022                	sd	s0,32(sp)
    800035f4:	e84a                	sd	s2,16(sp)
    800035f6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035f8:	00854783          	lbu	a5,8(a0)
    800035fc:	cfd1                	beqz	a5,80003698 <fileread+0xaa>
    800035fe:	ec26                	sd	s1,24(sp)
    80003600:	e44e                	sd	s3,8(sp)
    80003602:	84aa                	mv	s1,a0
    80003604:	89ae                	mv	s3,a1
    80003606:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003608:	411c                	lw	a5,0(a0)
    8000360a:	4705                	li	a4,1
    8000360c:	04e78363          	beq	a5,a4,80003652 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003610:	470d                	li	a4,3
    80003612:	04e78763          	beq	a5,a4,80003660 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003616:	4709                	li	a4,2
    80003618:	06e79a63          	bne	a5,a4,8000368c <fileread+0x9e>
    ilock(f->ip);
    8000361c:	6d08                	ld	a0,24(a0)
    8000361e:	8baff0ef          	jal	800026d8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003622:	874a                	mv	a4,s2
    80003624:	5094                	lw	a3,32(s1)
    80003626:	864e                	mv	a2,s3
    80003628:	4585                	li	a1,1
    8000362a:	6c88                	ld	a0,24(s1)
    8000362c:	c3cff0ef          	jal	80002a68 <readi>
    80003630:	892a                	mv	s2,a0
    80003632:	00a05563          	blez	a0,8000363c <fileread+0x4e>
      f->off += r;
    80003636:	509c                	lw	a5,32(s1)
    80003638:	9fa9                	addw	a5,a5,a0
    8000363a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000363c:	6c88                	ld	a0,24(s1)
    8000363e:	948ff0ef          	jal	80002786 <iunlock>
    80003642:	64e2                	ld	s1,24(sp)
    80003644:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003646:	854a                	mv	a0,s2
    80003648:	70a2                	ld	ra,40(sp)
    8000364a:	7402                	ld	s0,32(sp)
    8000364c:	6942                	ld	s2,16(sp)
    8000364e:	6145                	addi	sp,sp,48
    80003650:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003652:	6908                	ld	a0,16(a0)
    80003654:	388000ef          	jal	800039dc <piperead>
    80003658:	892a                	mv	s2,a0
    8000365a:	64e2                	ld	s1,24(sp)
    8000365c:	69a2                	ld	s3,8(sp)
    8000365e:	b7e5                	j	80003646 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003660:	02451783          	lh	a5,36(a0)
    80003664:	03079693          	slli	a3,a5,0x30
    80003668:	92c1                	srli	a3,a3,0x30
    8000366a:	4725                	li	a4,9
    8000366c:	02d76863          	bltu	a4,a3,8000369c <fileread+0xae>
    80003670:	0792                	slli	a5,a5,0x4
    80003672:	00017717          	auipc	a4,0x17
    80003676:	fa670713          	addi	a4,a4,-90 # 8001a618 <devsw>
    8000367a:	97ba                	add	a5,a5,a4
    8000367c:	639c                	ld	a5,0(a5)
    8000367e:	c39d                	beqz	a5,800036a4 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80003680:	4505                	li	a0,1
    80003682:	9782                	jalr	a5
    80003684:	892a                	mv	s2,a0
    80003686:	64e2                	ld	s1,24(sp)
    80003688:	69a2                	ld	s3,8(sp)
    8000368a:	bf75                	j	80003646 <fileread+0x58>
    panic("fileread");
    8000368c:	00004517          	auipc	a0,0x4
    80003690:	f5c50513          	addi	a0,a0,-164 # 800075e8 <etext+0x5e8>
    80003694:	78b010ef          	jal	8000561e <panic>
    return -1;
    80003698:	597d                	li	s2,-1
    8000369a:	b775                	j	80003646 <fileread+0x58>
      return -1;
    8000369c:	597d                	li	s2,-1
    8000369e:	64e2                	ld	s1,24(sp)
    800036a0:	69a2                	ld	s3,8(sp)
    800036a2:	b755                	j	80003646 <fileread+0x58>
    800036a4:	597d                	li	s2,-1
    800036a6:	64e2                	ld	s1,24(sp)
    800036a8:	69a2                	ld	s3,8(sp)
    800036aa:	bf71                	j	80003646 <fileread+0x58>

00000000800036ac <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800036ac:	00954783          	lbu	a5,9(a0)
    800036b0:	10078b63          	beqz	a5,800037c6 <filewrite+0x11a>
{
    800036b4:	715d                	addi	sp,sp,-80
    800036b6:	e486                	sd	ra,72(sp)
    800036b8:	e0a2                	sd	s0,64(sp)
    800036ba:	f84a                	sd	s2,48(sp)
    800036bc:	f052                	sd	s4,32(sp)
    800036be:	e85a                	sd	s6,16(sp)
    800036c0:	0880                	addi	s0,sp,80
    800036c2:	892a                	mv	s2,a0
    800036c4:	8b2e                	mv	s6,a1
    800036c6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800036c8:	411c                	lw	a5,0(a0)
    800036ca:	4705                	li	a4,1
    800036cc:	02e78763          	beq	a5,a4,800036fa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036d0:	470d                	li	a4,3
    800036d2:	02e78863          	beq	a5,a4,80003702 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036d6:	4709                	li	a4,2
    800036d8:	0ce79c63          	bne	a5,a4,800037b0 <filewrite+0x104>
    800036dc:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800036de:	0ac05863          	blez	a2,8000378e <filewrite+0xe2>
    800036e2:	fc26                	sd	s1,56(sp)
    800036e4:	ec56                	sd	s5,24(sp)
    800036e6:	e45e                	sd	s7,8(sp)
    800036e8:	e062                	sd	s8,0(sp)
    int i = 0;
    800036ea:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800036ec:	6b85                	lui	s7,0x1
    800036ee:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036f2:	6c05                	lui	s8,0x1
    800036f4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800036f8:	a8b5                	j	80003774 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800036fa:	6908                	ld	a0,16(a0)
    800036fc:	1fc000ef          	jal	800038f8 <pipewrite>
    80003700:	a04d                	j	800037a2 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003702:	02451783          	lh	a5,36(a0)
    80003706:	03079693          	slli	a3,a5,0x30
    8000370a:	92c1                	srli	a3,a3,0x30
    8000370c:	4725                	li	a4,9
    8000370e:	0ad76e63          	bltu	a4,a3,800037ca <filewrite+0x11e>
    80003712:	0792                	slli	a5,a5,0x4
    80003714:	00017717          	auipc	a4,0x17
    80003718:	f0470713          	addi	a4,a4,-252 # 8001a618 <devsw>
    8000371c:	97ba                	add	a5,a5,a4
    8000371e:	679c                	ld	a5,8(a5)
    80003720:	c7dd                	beqz	a5,800037ce <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003722:	4505                	li	a0,1
    80003724:	9782                	jalr	a5
    80003726:	a8b5                	j	800037a2 <filewrite+0xf6>
      if(n1 > max)
    80003728:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000372c:	997ff0ef          	jal	800030c2 <begin_op>
      ilock(f->ip);
    80003730:	01893503          	ld	a0,24(s2)
    80003734:	fa5fe0ef          	jal	800026d8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003738:	8756                	mv	a4,s5
    8000373a:	02092683          	lw	a3,32(s2)
    8000373e:	01698633          	add	a2,s3,s6
    80003742:	4585                	li	a1,1
    80003744:	01893503          	ld	a0,24(s2)
    80003748:	c1cff0ef          	jal	80002b64 <writei>
    8000374c:	84aa                	mv	s1,a0
    8000374e:	00a05763          	blez	a0,8000375c <filewrite+0xb0>
        f->off += r;
    80003752:	02092783          	lw	a5,32(s2)
    80003756:	9fa9                	addw	a5,a5,a0
    80003758:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000375c:	01893503          	ld	a0,24(s2)
    80003760:	826ff0ef          	jal	80002786 <iunlock>
      end_op();
    80003764:	9c9ff0ef          	jal	8000312c <end_op>

      if(r != n1){
    80003768:	029a9563          	bne	s5,s1,80003792 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    8000376c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003770:	0149da63          	bge	s3,s4,80003784 <filewrite+0xd8>
      int n1 = n - i;
    80003774:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003778:	0004879b          	sext.w	a5,s1
    8000377c:	fafbd6e3          	bge	s7,a5,80003728 <filewrite+0x7c>
    80003780:	84e2                	mv	s1,s8
    80003782:	b75d                	j	80003728 <filewrite+0x7c>
    80003784:	74e2                	ld	s1,56(sp)
    80003786:	6ae2                	ld	s5,24(sp)
    80003788:	6ba2                	ld	s7,8(sp)
    8000378a:	6c02                	ld	s8,0(sp)
    8000378c:	a039                	j	8000379a <filewrite+0xee>
    int i = 0;
    8000378e:	4981                	li	s3,0
    80003790:	a029                	j	8000379a <filewrite+0xee>
    80003792:	74e2                	ld	s1,56(sp)
    80003794:	6ae2                	ld	s5,24(sp)
    80003796:	6ba2                	ld	s7,8(sp)
    80003798:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000379a:	033a1c63          	bne	s4,s3,800037d2 <filewrite+0x126>
    8000379e:	8552                	mv	a0,s4
    800037a0:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800037a2:	60a6                	ld	ra,72(sp)
    800037a4:	6406                	ld	s0,64(sp)
    800037a6:	7942                	ld	s2,48(sp)
    800037a8:	7a02                	ld	s4,32(sp)
    800037aa:	6b42                	ld	s6,16(sp)
    800037ac:	6161                	addi	sp,sp,80
    800037ae:	8082                	ret
    800037b0:	fc26                	sd	s1,56(sp)
    800037b2:	f44e                	sd	s3,40(sp)
    800037b4:	ec56                	sd	s5,24(sp)
    800037b6:	e45e                	sd	s7,8(sp)
    800037b8:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800037ba:	00004517          	auipc	a0,0x4
    800037be:	e3e50513          	addi	a0,a0,-450 # 800075f8 <etext+0x5f8>
    800037c2:	65d010ef          	jal	8000561e <panic>
    return -1;
    800037c6:	557d                	li	a0,-1
}
    800037c8:	8082                	ret
      return -1;
    800037ca:	557d                	li	a0,-1
    800037cc:	bfd9                	j	800037a2 <filewrite+0xf6>
    800037ce:	557d                	li	a0,-1
    800037d0:	bfc9                	j	800037a2 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800037d2:	557d                	li	a0,-1
    800037d4:	79a2                	ld	s3,40(sp)
    800037d6:	b7f1                	j	800037a2 <filewrite+0xf6>

00000000800037d8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800037d8:	7179                	addi	sp,sp,-48
    800037da:	f406                	sd	ra,40(sp)
    800037dc:	f022                	sd	s0,32(sp)
    800037de:	ec26                	sd	s1,24(sp)
    800037e0:	e052                	sd	s4,0(sp)
    800037e2:	1800                	addi	s0,sp,48
    800037e4:	84aa                	mv	s1,a0
    800037e6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037e8:	0005b023          	sd	zero,0(a1)
    800037ec:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037f0:	c3bff0ef          	jal	8000342a <filealloc>
    800037f4:	e088                	sd	a0,0(s1)
    800037f6:	c549                	beqz	a0,80003880 <pipealloc+0xa8>
    800037f8:	c33ff0ef          	jal	8000342a <filealloc>
    800037fc:	00aa3023          	sd	a0,0(s4)
    80003800:	cd25                	beqz	a0,80003878 <pipealloc+0xa0>
    80003802:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003804:	8f3fc0ef          	jal	800000f6 <kalloc>
    80003808:	892a                	mv	s2,a0
    8000380a:	c12d                	beqz	a0,8000386c <pipealloc+0x94>
    8000380c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000380e:	4985                	li	s3,1
    80003810:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003814:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003818:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000381c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003820:	00004597          	auipc	a1,0x4
    80003824:	b5858593          	addi	a1,a1,-1192 # 80007378 <etext+0x378>
    80003828:	032020ef          	jal	8000585a <initlock>
  (*f0)->type = FD_PIPE;
    8000382c:	609c                	ld	a5,0(s1)
    8000382e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003832:	609c                	ld	a5,0(s1)
    80003834:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003838:	609c                	ld	a5,0(s1)
    8000383a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000383e:	609c                	ld	a5,0(s1)
    80003840:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003844:	000a3783          	ld	a5,0(s4)
    80003848:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000384c:	000a3783          	ld	a5,0(s4)
    80003850:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003854:	000a3783          	ld	a5,0(s4)
    80003858:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000385c:	000a3783          	ld	a5,0(s4)
    80003860:	0127b823          	sd	s2,16(a5)
  return 0;
    80003864:	4501                	li	a0,0
    80003866:	6942                	ld	s2,16(sp)
    80003868:	69a2                	ld	s3,8(sp)
    8000386a:	a01d                	j	80003890 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000386c:	6088                	ld	a0,0(s1)
    8000386e:	c119                	beqz	a0,80003874 <pipealloc+0x9c>
    80003870:	6942                	ld	s2,16(sp)
    80003872:	a029                	j	8000387c <pipealloc+0xa4>
    80003874:	6942                	ld	s2,16(sp)
    80003876:	a029                	j	80003880 <pipealloc+0xa8>
    80003878:	6088                	ld	a0,0(s1)
    8000387a:	c10d                	beqz	a0,8000389c <pipealloc+0xc4>
    fileclose(*f0);
    8000387c:	c53ff0ef          	jal	800034ce <fileclose>
  if(*f1)
    80003880:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003884:	557d                	li	a0,-1
  if(*f1)
    80003886:	c789                	beqz	a5,80003890 <pipealloc+0xb8>
    fileclose(*f1);
    80003888:	853e                	mv	a0,a5
    8000388a:	c45ff0ef          	jal	800034ce <fileclose>
  return -1;
    8000388e:	557d                	li	a0,-1
}
    80003890:	70a2                	ld	ra,40(sp)
    80003892:	7402                	ld	s0,32(sp)
    80003894:	64e2                	ld	s1,24(sp)
    80003896:	6a02                	ld	s4,0(sp)
    80003898:	6145                	addi	sp,sp,48
    8000389a:	8082                	ret
  return -1;
    8000389c:	557d                	li	a0,-1
    8000389e:	bfcd                	j	80003890 <pipealloc+0xb8>

00000000800038a0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800038a0:	1101                	addi	sp,sp,-32
    800038a2:	ec06                	sd	ra,24(sp)
    800038a4:	e822                	sd	s0,16(sp)
    800038a6:	e426                	sd	s1,8(sp)
    800038a8:	e04a                	sd	s2,0(sp)
    800038aa:	1000                	addi	s0,sp,32
    800038ac:	84aa                	mv	s1,a0
    800038ae:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800038b0:	02a020ef          	jal	800058da <acquire>
  if(writable){
    800038b4:	02090763          	beqz	s2,800038e2 <pipeclose+0x42>
    pi->writeopen = 0;
    800038b8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800038bc:	21848513          	addi	a0,s1,536
    800038c0:	b11fd0ef          	jal	800013d0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800038c4:	2204b783          	ld	a5,544(s1)
    800038c8:	e785                	bnez	a5,800038f0 <pipeclose+0x50>
    release(&pi->lock);
    800038ca:	8526                	mv	a0,s1
    800038cc:	0a6020ef          	jal	80005972 <release>
    kfree((char*)pi);
    800038d0:	8526                	mv	a0,s1
    800038d2:	f4afc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800038d6:	60e2                	ld	ra,24(sp)
    800038d8:	6442                	ld	s0,16(sp)
    800038da:	64a2                	ld	s1,8(sp)
    800038dc:	6902                	ld	s2,0(sp)
    800038de:	6105                	addi	sp,sp,32
    800038e0:	8082                	ret
    pi->readopen = 0;
    800038e2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038e6:	21c48513          	addi	a0,s1,540
    800038ea:	ae7fd0ef          	jal	800013d0 <wakeup>
    800038ee:	bfd9                	j	800038c4 <pipeclose+0x24>
    release(&pi->lock);
    800038f0:	8526                	mv	a0,s1
    800038f2:	080020ef          	jal	80005972 <release>
}
    800038f6:	b7c5                	j	800038d6 <pipeclose+0x36>

00000000800038f8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038f8:	711d                	addi	sp,sp,-96
    800038fa:	ec86                	sd	ra,88(sp)
    800038fc:	e8a2                	sd	s0,80(sp)
    800038fe:	e4a6                	sd	s1,72(sp)
    80003900:	e0ca                	sd	s2,64(sp)
    80003902:	fc4e                	sd	s3,56(sp)
    80003904:	f852                	sd	s4,48(sp)
    80003906:	f456                	sd	s5,40(sp)
    80003908:	1080                	addi	s0,sp,96
    8000390a:	84aa                	mv	s1,a0
    8000390c:	8aae                	mv	s5,a1
    8000390e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003910:	c74fd0ef          	jal	80000d84 <myproc>
    80003914:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003916:	8526                	mv	a0,s1
    80003918:	7c3010ef          	jal	800058da <acquire>
  while(i < n){
    8000391c:	0b405a63          	blez	s4,800039d0 <pipewrite+0xd8>
    80003920:	f05a                	sd	s6,32(sp)
    80003922:	ec5e                	sd	s7,24(sp)
    80003924:	e862                	sd	s8,16(sp)
  int i = 0;
    80003926:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003928:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000392a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000392e:	21c48b93          	addi	s7,s1,540
    80003932:	a81d                	j	80003968 <pipewrite+0x70>
      release(&pi->lock);
    80003934:	8526                	mv	a0,s1
    80003936:	03c020ef          	jal	80005972 <release>
      return -1;
    8000393a:	597d                	li	s2,-1
    8000393c:	7b02                	ld	s6,32(sp)
    8000393e:	6be2                	ld	s7,24(sp)
    80003940:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003942:	854a                	mv	a0,s2
    80003944:	60e6                	ld	ra,88(sp)
    80003946:	6446                	ld	s0,80(sp)
    80003948:	64a6                	ld	s1,72(sp)
    8000394a:	6906                	ld	s2,64(sp)
    8000394c:	79e2                	ld	s3,56(sp)
    8000394e:	7a42                	ld	s4,48(sp)
    80003950:	7aa2                	ld	s5,40(sp)
    80003952:	6125                	addi	sp,sp,96
    80003954:	8082                	ret
      wakeup(&pi->nread);
    80003956:	8562                	mv	a0,s8
    80003958:	a79fd0ef          	jal	800013d0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000395c:	85a6                	mv	a1,s1
    8000395e:	855e                	mv	a0,s7
    80003960:	a25fd0ef          	jal	80001384 <sleep>
  while(i < n){
    80003964:	05495b63          	bge	s2,s4,800039ba <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003968:	2204a783          	lw	a5,544(s1)
    8000396c:	d7e1                	beqz	a5,80003934 <pipewrite+0x3c>
    8000396e:	854e                	mv	a0,s3
    80003970:	c4dfd0ef          	jal	800015bc <killed>
    80003974:	f161                	bnez	a0,80003934 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003976:	2184a783          	lw	a5,536(s1)
    8000397a:	21c4a703          	lw	a4,540(s1)
    8000397e:	2007879b          	addiw	a5,a5,512
    80003982:	fcf70ae3          	beq	a4,a5,80003956 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003986:	4685                	li	a3,1
    80003988:	01590633          	add	a2,s2,s5
    8000398c:	faf40593          	addi	a1,s0,-81
    80003990:	0509b503          	ld	a0,80(s3)
    80003994:	9e8fd0ef          	jal	80000b7c <copyin>
    80003998:	03650e63          	beq	a0,s6,800039d4 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000399c:	21c4a783          	lw	a5,540(s1)
    800039a0:	0017871b          	addiw	a4,a5,1
    800039a4:	20e4ae23          	sw	a4,540(s1)
    800039a8:	1ff7f793          	andi	a5,a5,511
    800039ac:	97a6                	add	a5,a5,s1
    800039ae:	faf44703          	lbu	a4,-81(s0)
    800039b2:	00e78c23          	sb	a4,24(a5)
      i++;
    800039b6:	2905                	addiw	s2,s2,1
    800039b8:	b775                	j	80003964 <pipewrite+0x6c>
    800039ba:	7b02                	ld	s6,32(sp)
    800039bc:	6be2                	ld	s7,24(sp)
    800039be:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800039c0:	21848513          	addi	a0,s1,536
    800039c4:	a0dfd0ef          	jal	800013d0 <wakeup>
  release(&pi->lock);
    800039c8:	8526                	mv	a0,s1
    800039ca:	7a9010ef          	jal	80005972 <release>
  return i;
    800039ce:	bf95                	j	80003942 <pipewrite+0x4a>
  int i = 0;
    800039d0:	4901                	li	s2,0
    800039d2:	b7fd                	j	800039c0 <pipewrite+0xc8>
    800039d4:	7b02                	ld	s6,32(sp)
    800039d6:	6be2                	ld	s7,24(sp)
    800039d8:	6c42                	ld	s8,16(sp)
    800039da:	b7dd                	j	800039c0 <pipewrite+0xc8>

00000000800039dc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800039dc:	715d                	addi	sp,sp,-80
    800039de:	e486                	sd	ra,72(sp)
    800039e0:	e0a2                	sd	s0,64(sp)
    800039e2:	fc26                	sd	s1,56(sp)
    800039e4:	f84a                	sd	s2,48(sp)
    800039e6:	f44e                	sd	s3,40(sp)
    800039e8:	f052                	sd	s4,32(sp)
    800039ea:	ec56                	sd	s5,24(sp)
    800039ec:	0880                	addi	s0,sp,80
    800039ee:	84aa                	mv	s1,a0
    800039f0:	892e                	mv	s2,a1
    800039f2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039f4:	b90fd0ef          	jal	80000d84 <myproc>
    800039f8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039fa:	8526                	mv	a0,s1
    800039fc:	6df010ef          	jal	800058da <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a00:	2184a703          	lw	a4,536(s1)
    80003a04:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a08:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a0c:	02f71563          	bne	a4,a5,80003a36 <piperead+0x5a>
    80003a10:	2244a783          	lw	a5,548(s1)
    80003a14:	cb85                	beqz	a5,80003a44 <piperead+0x68>
    if(killed(pr)){
    80003a16:	8552                	mv	a0,s4
    80003a18:	ba5fd0ef          	jal	800015bc <killed>
    80003a1c:	ed19                	bnez	a0,80003a3a <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a1e:	85a6                	mv	a1,s1
    80003a20:	854e                	mv	a0,s3
    80003a22:	963fd0ef          	jal	80001384 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a26:	2184a703          	lw	a4,536(s1)
    80003a2a:	21c4a783          	lw	a5,540(s1)
    80003a2e:	fef701e3          	beq	a4,a5,80003a10 <piperead+0x34>
    80003a32:	e85a                	sd	s6,16(sp)
    80003a34:	a809                	j	80003a46 <piperead+0x6a>
    80003a36:	e85a                	sd	s6,16(sp)
    80003a38:	a039                	j	80003a46 <piperead+0x6a>
      release(&pi->lock);
    80003a3a:	8526                	mv	a0,s1
    80003a3c:	737010ef          	jal	80005972 <release>
      return -1;
    80003a40:	59fd                	li	s3,-1
    80003a42:	a8b1                	j	80003a9e <piperead+0xc2>
    80003a44:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a46:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a48:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a4a:	05505263          	blez	s5,80003a8e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a4e:	2184a783          	lw	a5,536(s1)
    80003a52:	21c4a703          	lw	a4,540(s1)
    80003a56:	02f70c63          	beq	a4,a5,80003a8e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a5a:	0017871b          	addiw	a4,a5,1
    80003a5e:	20e4ac23          	sw	a4,536(s1)
    80003a62:	1ff7f793          	andi	a5,a5,511
    80003a66:	97a6                	add	a5,a5,s1
    80003a68:	0187c783          	lbu	a5,24(a5)
    80003a6c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a70:	4685                	li	a3,1
    80003a72:	fbf40613          	addi	a2,s0,-65
    80003a76:	85ca                	mv	a1,s2
    80003a78:	050a3503          	ld	a0,80(s4)
    80003a7c:	80cfd0ef          	jal	80000a88 <copyout>
    80003a80:	01650763          	beq	a0,s6,80003a8e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a84:	2985                	addiw	s3,s3,1
    80003a86:	0905                	addi	s2,s2,1
    80003a88:	fd3a93e3          	bne	s5,s3,80003a4e <piperead+0x72>
    80003a8c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a8e:	21c48513          	addi	a0,s1,540
    80003a92:	93ffd0ef          	jal	800013d0 <wakeup>
  release(&pi->lock);
    80003a96:	8526                	mv	a0,s1
    80003a98:	6db010ef          	jal	80005972 <release>
    80003a9c:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a9e:	854e                	mv	a0,s3
    80003aa0:	60a6                	ld	ra,72(sp)
    80003aa2:	6406                	ld	s0,64(sp)
    80003aa4:	74e2                	ld	s1,56(sp)
    80003aa6:	7942                	ld	s2,48(sp)
    80003aa8:	79a2                	ld	s3,40(sp)
    80003aaa:	7a02                	ld	s4,32(sp)
    80003aac:	6ae2                	ld	s5,24(sp)
    80003aae:	6161                	addi	sp,sp,80
    80003ab0:	8082                	ret

0000000080003ab2 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003ab2:	1141                	addi	sp,sp,-16
    80003ab4:	e422                	sd	s0,8(sp)
    80003ab6:	0800                	addi	s0,sp,16
    80003ab8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003aba:	8905                	andi	a0,a0,1
    80003abc:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003abe:	8b89                	andi	a5,a5,2
    80003ac0:	c399                	beqz	a5,80003ac6 <flags2perm+0x14>
      perm |= PTE_W;
    80003ac2:	00456513          	ori	a0,a0,4
    return perm;
}
    80003ac6:	6422                	ld	s0,8(sp)
    80003ac8:	0141                	addi	sp,sp,16
    80003aca:	8082                	ret

0000000080003acc <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003acc:	df010113          	addi	sp,sp,-528
    80003ad0:	20113423          	sd	ra,520(sp)
    80003ad4:	20813023          	sd	s0,512(sp)
    80003ad8:	ffa6                	sd	s1,504(sp)
    80003ada:	fbca                	sd	s2,496(sp)
    80003adc:	0c00                	addi	s0,sp,528
    80003ade:	892a                	mv	s2,a0
    80003ae0:	dea43c23          	sd	a0,-520(s0)
    80003ae4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003ae8:	a9cfd0ef          	jal	80000d84 <myproc>
    80003aec:	84aa                	mv	s1,a0

  begin_op();
    80003aee:	dd4ff0ef          	jal	800030c2 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003af2:	854a                	mv	a0,s2
    80003af4:	bfaff0ef          	jal	80002eee <namei>
    80003af8:	c931                	beqz	a0,80003b4c <kexec+0x80>
    80003afa:	f3d2                	sd	s4,480(sp)
    80003afc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003afe:	bdbfe0ef          	jal	800026d8 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b02:	04000713          	li	a4,64
    80003b06:	4681                	li	a3,0
    80003b08:	e5040613          	addi	a2,s0,-432
    80003b0c:	4581                	li	a1,0
    80003b0e:	8552                	mv	a0,s4
    80003b10:	f59fe0ef          	jal	80002a68 <readi>
    80003b14:	04000793          	li	a5,64
    80003b18:	00f51a63          	bne	a0,a5,80003b2c <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003b1c:	e5042703          	lw	a4,-432(s0)
    80003b20:	464c47b7          	lui	a5,0x464c4
    80003b24:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b28:	02f70663          	beq	a4,a5,80003b54 <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b2c:	8552                	mv	a0,s4
    80003b2e:	db5fe0ef          	jal	800028e2 <iunlockput>
    end_op();
    80003b32:	dfaff0ef          	jal	8000312c <end_op>
  }
  return -1;
    80003b36:	557d                	li	a0,-1
    80003b38:	7a1e                	ld	s4,480(sp)
}
    80003b3a:	20813083          	ld	ra,520(sp)
    80003b3e:	20013403          	ld	s0,512(sp)
    80003b42:	74fe                	ld	s1,504(sp)
    80003b44:	795e                	ld	s2,496(sp)
    80003b46:	21010113          	addi	sp,sp,528
    80003b4a:	8082                	ret
    end_op();
    80003b4c:	de0ff0ef          	jal	8000312c <end_op>
    return -1;
    80003b50:	557d                	li	a0,-1
    80003b52:	b7e5                	j	80003b3a <kexec+0x6e>
    80003b54:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b56:	8526                	mv	a0,s1
    80003b58:	b32fd0ef          	jal	80000e8a <proc_pagetable>
    80003b5c:	8b2a                	mv	s6,a0
    80003b5e:	2c050b63          	beqz	a0,80003e34 <kexec+0x368>
    80003b62:	f7ce                	sd	s3,488(sp)
    80003b64:	efd6                	sd	s5,472(sp)
    80003b66:	e7de                	sd	s7,456(sp)
    80003b68:	e3e2                	sd	s8,448(sp)
    80003b6a:	ff66                	sd	s9,440(sp)
    80003b6c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b6e:	e7042d03          	lw	s10,-400(s0)
    80003b72:	e8845783          	lhu	a5,-376(s0)
    80003b76:	12078963          	beqz	a5,80003ca8 <kexec+0x1dc>
    80003b7a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b7c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b7e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b80:	6c85                	lui	s9,0x1
    80003b82:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b86:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b8a:	6a85                	lui	s5,0x1
    80003b8c:	a085                	j	80003bec <kexec+0x120>
      panic("loadseg: address should exist");
    80003b8e:	00004517          	auipc	a0,0x4
    80003b92:	a7a50513          	addi	a0,a0,-1414 # 80007608 <etext+0x608>
    80003b96:	289010ef          	jal	8000561e <panic>
    if(sz - i < PGSIZE)
    80003b9a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b9c:	8726                	mv	a4,s1
    80003b9e:	012c06bb          	addw	a3,s8,s2
    80003ba2:	4581                	li	a1,0
    80003ba4:	8552                	mv	a0,s4
    80003ba6:	ec3fe0ef          	jal	80002a68 <readi>
    80003baa:	2501                	sext.w	a0,a0
    80003bac:	24a49a63          	bne	s1,a0,80003e00 <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003bb0:	012a893b          	addw	s2,s5,s2
    80003bb4:	03397363          	bgeu	s2,s3,80003bda <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003bb8:	02091593          	slli	a1,s2,0x20
    80003bbc:	9181                	srli	a1,a1,0x20
    80003bbe:	95de                	add	a1,a1,s7
    80003bc0:	855a                	mv	a0,s6
    80003bc2:	881fc0ef          	jal	80000442 <walkaddr>
    80003bc6:	862a                	mv	a2,a0
    if(pa == 0)
    80003bc8:	d179                	beqz	a0,80003b8e <kexec+0xc2>
    if(sz - i < PGSIZE)
    80003bca:	412984bb          	subw	s1,s3,s2
    80003bce:	0004879b          	sext.w	a5,s1
    80003bd2:	fcfcf4e3          	bgeu	s9,a5,80003b9a <kexec+0xce>
    80003bd6:	84d6                	mv	s1,s5
    80003bd8:	b7c9                	j	80003b9a <kexec+0xce>
    sz = sz1;
    80003bda:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bde:	2d85                	addiw	s11,s11,1
    80003be0:	038d0d1b          	addiw	s10,s10,56
    80003be4:	e8845783          	lhu	a5,-376(s0)
    80003be8:	08fdd063          	bge	s11,a5,80003c68 <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bec:	2d01                	sext.w	s10,s10
    80003bee:	03800713          	li	a4,56
    80003bf2:	86ea                	mv	a3,s10
    80003bf4:	e1840613          	addi	a2,s0,-488
    80003bf8:	4581                	li	a1,0
    80003bfa:	8552                	mv	a0,s4
    80003bfc:	e6dfe0ef          	jal	80002a68 <readi>
    80003c00:	03800793          	li	a5,56
    80003c04:	1cf51663          	bne	a0,a5,80003dd0 <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003c08:	e1842783          	lw	a5,-488(s0)
    80003c0c:	4705                	li	a4,1
    80003c0e:	fce798e3          	bne	a5,a4,80003bde <kexec+0x112>
    if(ph.memsz < ph.filesz)
    80003c12:	e4043483          	ld	s1,-448(s0)
    80003c16:	e3843783          	ld	a5,-456(s0)
    80003c1a:	1af4ef63          	bltu	s1,a5,80003dd8 <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c1e:	e2843783          	ld	a5,-472(s0)
    80003c22:	94be                	add	s1,s1,a5
    80003c24:	1af4ee63          	bltu	s1,a5,80003de0 <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003c28:	df043703          	ld	a4,-528(s0)
    80003c2c:	8ff9                	and	a5,a5,a4
    80003c2e:	1a079d63          	bnez	a5,80003de8 <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c32:	e1c42503          	lw	a0,-484(s0)
    80003c36:	e7dff0ef          	jal	80003ab2 <flags2perm>
    80003c3a:	86aa                	mv	a3,a0
    80003c3c:	8626                	mv	a2,s1
    80003c3e:	85ca                	mv	a1,s2
    80003c40:	855a                	mv	a0,s6
    80003c42:	af5fc0ef          	jal	80000736 <uvmalloc>
    80003c46:	e0a43423          	sd	a0,-504(s0)
    80003c4a:	1a050363          	beqz	a0,80003df0 <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c4e:	e2843b83          	ld	s7,-472(s0)
    80003c52:	e2042c03          	lw	s8,-480(s0)
    80003c56:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c5a:	00098463          	beqz	s3,80003c62 <kexec+0x196>
    80003c5e:	4901                	li	s2,0
    80003c60:	bfa1                	j	80003bb8 <kexec+0xec>
    sz = sz1;
    80003c62:	e0843903          	ld	s2,-504(s0)
    80003c66:	bfa5                	j	80003bde <kexec+0x112>
    80003c68:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003c6a:	8552                	mv	a0,s4
    80003c6c:	c77fe0ef          	jal	800028e2 <iunlockput>
  end_op();
    80003c70:	cbcff0ef          	jal	8000312c <end_op>
  p = myproc();
    80003c74:	910fd0ef          	jal	80000d84 <myproc>
    80003c78:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c7a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c7e:	6985                	lui	s3,0x1
    80003c80:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c82:	99ca                	add	s3,s3,s2
    80003c84:	77fd                	lui	a5,0xfffff
    80003c86:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c8a:	4691                	li	a3,4
    80003c8c:	6609                	lui	a2,0x2
    80003c8e:	964e                	add	a2,a2,s3
    80003c90:	85ce                	mv	a1,s3
    80003c92:	855a                	mv	a0,s6
    80003c94:	aa3fc0ef          	jal	80000736 <uvmalloc>
    80003c98:	892a                	mv	s2,a0
    80003c9a:	e0a43423          	sd	a0,-504(s0)
    80003c9e:	e519                	bnez	a0,80003cac <kexec+0x1e0>
  if(pagetable)
    80003ca0:	e1343423          	sd	s3,-504(s0)
    80003ca4:	4a01                	li	s4,0
    80003ca6:	aab1                	j	80003e02 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ca8:	4901                	li	s2,0
    80003caa:	b7c1                	j	80003c6a <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003cac:	75f9                	lui	a1,0xffffe
    80003cae:	95aa                	add	a1,a1,a0
    80003cb0:	855a                	mv	a0,s6
    80003cb2:	c53fc0ef          	jal	80000904 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003cb6:	7bfd                	lui	s7,0xfffff
    80003cb8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003cba:	e0043783          	ld	a5,-512(s0)
    80003cbe:	6388                	ld	a0,0(a5)
    80003cc0:	cd39                	beqz	a0,80003d1e <kexec+0x252>
    80003cc2:	e9040993          	addi	s3,s0,-368
    80003cc6:	f9040c13          	addi	s8,s0,-112
    80003cca:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003ccc:	dd8fc0ef          	jal	800002a4 <strlen>
    80003cd0:	0015079b          	addiw	a5,a0,1
    80003cd4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003cd8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003cdc:	11796e63          	bltu	s2,s7,80003df8 <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003ce0:	e0043d03          	ld	s10,-512(s0)
    80003ce4:	000d3a03          	ld	s4,0(s10)
    80003ce8:	8552                	mv	a0,s4
    80003cea:	dbafc0ef          	jal	800002a4 <strlen>
    80003cee:	0015069b          	addiw	a3,a0,1
    80003cf2:	8652                	mv	a2,s4
    80003cf4:	85ca                	mv	a1,s2
    80003cf6:	855a                	mv	a0,s6
    80003cf8:	d91fc0ef          	jal	80000a88 <copyout>
    80003cfc:	10054063          	bltz	a0,80003dfc <kexec+0x330>
    ustack[argc] = sp;
    80003d00:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003d04:	0485                	addi	s1,s1,1
    80003d06:	008d0793          	addi	a5,s10,8
    80003d0a:	e0f43023          	sd	a5,-512(s0)
    80003d0e:	008d3503          	ld	a0,8(s10)
    80003d12:	c909                	beqz	a0,80003d24 <kexec+0x258>
    if(argc >= MAXARG)
    80003d14:	09a1                	addi	s3,s3,8
    80003d16:	fb899be3          	bne	s3,s8,80003ccc <kexec+0x200>
  ip = 0;
    80003d1a:	4a01                	li	s4,0
    80003d1c:	a0dd                	j	80003e02 <kexec+0x336>
  sp = sz;
    80003d1e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003d22:	4481                	li	s1,0
  ustack[argc] = 0;
    80003d24:	00349793          	slli	a5,s1,0x3
    80003d28:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb708>
    80003d2c:	97a2                	add	a5,a5,s0
    80003d2e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003d32:	00148693          	addi	a3,s1,1
    80003d36:	068e                	slli	a3,a3,0x3
    80003d38:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003d3c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d40:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003d44:	f5796ee3          	bltu	s2,s7,80003ca0 <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d48:	e9040613          	addi	a2,s0,-368
    80003d4c:	85ca                	mv	a1,s2
    80003d4e:	855a                	mv	a0,s6
    80003d50:	d39fc0ef          	jal	80000a88 <copyout>
    80003d54:	0e054263          	bltz	a0,80003e38 <kexec+0x36c>
  p->trapframe->a1 = sp;
    80003d58:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d5c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d60:	df843783          	ld	a5,-520(s0)
    80003d64:	0007c703          	lbu	a4,0(a5)
    80003d68:	cf11                	beqz	a4,80003d84 <kexec+0x2b8>
    80003d6a:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d6c:	02f00693          	li	a3,47
    80003d70:	a039                	j	80003d7e <kexec+0x2b2>
      last = s+1;
    80003d72:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d76:	0785                	addi	a5,a5,1
    80003d78:	fff7c703          	lbu	a4,-1(a5)
    80003d7c:	c701                	beqz	a4,80003d84 <kexec+0x2b8>
    if(*s == '/')
    80003d7e:	fed71ce3          	bne	a4,a3,80003d76 <kexec+0x2aa>
    80003d82:	bfc5                	j	80003d72 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d84:	4641                	li	a2,16
    80003d86:	df843583          	ld	a1,-520(s0)
    80003d8a:	158a8513          	addi	a0,s5,344
    80003d8e:	ce4fc0ef          	jal	80000272 <safestrcpy>
  oldpagetable = p->pagetable;
    80003d92:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d96:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d9a:	e0843783          	ld	a5,-504(s0)
    80003d9e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003da2:	058ab783          	ld	a5,88(s5)
    80003da6:	e6843703          	ld	a4,-408(s0)
    80003daa:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003dac:	058ab783          	ld	a5,88(s5)
    80003db0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003db4:	85e6                	mv	a1,s9
    80003db6:	958fd0ef          	jal	80000f0e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003dba:	0004851b          	sext.w	a0,s1
    80003dbe:	79be                	ld	s3,488(sp)
    80003dc0:	7a1e                	ld	s4,480(sp)
    80003dc2:	6afe                	ld	s5,472(sp)
    80003dc4:	6b5e                	ld	s6,464(sp)
    80003dc6:	6bbe                	ld	s7,456(sp)
    80003dc8:	6c1e                	ld	s8,448(sp)
    80003dca:	7cfa                	ld	s9,440(sp)
    80003dcc:	7d5a                	ld	s10,432(sp)
    80003dce:	b3b5                	j	80003b3a <kexec+0x6e>
    80003dd0:	e1243423          	sd	s2,-504(s0)
    80003dd4:	7dba                	ld	s11,424(sp)
    80003dd6:	a035                	j	80003e02 <kexec+0x336>
    80003dd8:	e1243423          	sd	s2,-504(s0)
    80003ddc:	7dba                	ld	s11,424(sp)
    80003dde:	a015                	j	80003e02 <kexec+0x336>
    80003de0:	e1243423          	sd	s2,-504(s0)
    80003de4:	7dba                	ld	s11,424(sp)
    80003de6:	a831                	j	80003e02 <kexec+0x336>
    80003de8:	e1243423          	sd	s2,-504(s0)
    80003dec:	7dba                	ld	s11,424(sp)
    80003dee:	a811                	j	80003e02 <kexec+0x336>
    80003df0:	e1243423          	sd	s2,-504(s0)
    80003df4:	7dba                	ld	s11,424(sp)
    80003df6:	a031                	j	80003e02 <kexec+0x336>
  ip = 0;
    80003df8:	4a01                	li	s4,0
    80003dfa:	a021                	j	80003e02 <kexec+0x336>
    80003dfc:	4a01                	li	s4,0
  if(pagetable)
    80003dfe:	a011                	j	80003e02 <kexec+0x336>
    80003e00:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003e02:	e0843583          	ld	a1,-504(s0)
    80003e06:	855a                	mv	a0,s6
    80003e08:	906fd0ef          	jal	80000f0e <proc_freepagetable>
  return -1;
    80003e0c:	557d                	li	a0,-1
  if(ip){
    80003e0e:	000a1b63          	bnez	s4,80003e24 <kexec+0x358>
    80003e12:	79be                	ld	s3,488(sp)
    80003e14:	7a1e                	ld	s4,480(sp)
    80003e16:	6afe                	ld	s5,472(sp)
    80003e18:	6b5e                	ld	s6,464(sp)
    80003e1a:	6bbe                	ld	s7,456(sp)
    80003e1c:	6c1e                	ld	s8,448(sp)
    80003e1e:	7cfa                	ld	s9,440(sp)
    80003e20:	7d5a                	ld	s10,432(sp)
    80003e22:	bb21                	j	80003b3a <kexec+0x6e>
    80003e24:	79be                	ld	s3,488(sp)
    80003e26:	6afe                	ld	s5,472(sp)
    80003e28:	6b5e                	ld	s6,464(sp)
    80003e2a:	6bbe                	ld	s7,456(sp)
    80003e2c:	6c1e                	ld	s8,448(sp)
    80003e2e:	7cfa                	ld	s9,440(sp)
    80003e30:	7d5a                	ld	s10,432(sp)
    80003e32:	b9ed                	j	80003b2c <kexec+0x60>
    80003e34:	6b5e                	ld	s6,464(sp)
    80003e36:	b9dd                	j	80003b2c <kexec+0x60>
  sz = sz1;
    80003e38:	e0843983          	ld	s3,-504(s0)
    80003e3c:	b595                	j	80003ca0 <kexec+0x1d4>

0000000080003e3e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e3e:	7179                	addi	sp,sp,-48
    80003e40:	f406                	sd	ra,40(sp)
    80003e42:	f022                	sd	s0,32(sp)
    80003e44:	ec26                	sd	s1,24(sp)
    80003e46:	e84a                	sd	s2,16(sp)
    80003e48:	1800                	addi	s0,sp,48
    80003e4a:	892e                	mv	s2,a1
    80003e4c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e4e:	fdc40593          	addi	a1,s0,-36
    80003e52:	e37fd0ef          	jal	80001c88 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e56:	fdc42703          	lw	a4,-36(s0)
    80003e5a:	47bd                	li	a5,15
    80003e5c:	02e7e963          	bltu	a5,a4,80003e8e <argfd+0x50>
    80003e60:	f25fc0ef          	jal	80000d84 <myproc>
    80003e64:	fdc42703          	lw	a4,-36(s0)
    80003e68:	01a70793          	addi	a5,a4,26
    80003e6c:	078e                	slli	a5,a5,0x3
    80003e6e:	953e                	add	a0,a0,a5
    80003e70:	611c                	ld	a5,0(a0)
    80003e72:	c385                	beqz	a5,80003e92 <argfd+0x54>
    return -1;
  if(pfd)
    80003e74:	00090463          	beqz	s2,80003e7c <argfd+0x3e>
    *pfd = fd;
    80003e78:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e7c:	4501                	li	a0,0
  if(pf)
    80003e7e:	c091                	beqz	s1,80003e82 <argfd+0x44>
    *pf = f;
    80003e80:	e09c                	sd	a5,0(s1)
}
    80003e82:	70a2                	ld	ra,40(sp)
    80003e84:	7402                	ld	s0,32(sp)
    80003e86:	64e2                	ld	s1,24(sp)
    80003e88:	6942                	ld	s2,16(sp)
    80003e8a:	6145                	addi	sp,sp,48
    80003e8c:	8082                	ret
    return -1;
    80003e8e:	557d                	li	a0,-1
    80003e90:	bfcd                	j	80003e82 <argfd+0x44>
    80003e92:	557d                	li	a0,-1
    80003e94:	b7fd                	j	80003e82 <argfd+0x44>

0000000080003e96 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e96:	1101                	addi	sp,sp,-32
    80003e98:	ec06                	sd	ra,24(sp)
    80003e9a:	e822                	sd	s0,16(sp)
    80003e9c:	e426                	sd	s1,8(sp)
    80003e9e:	1000                	addi	s0,sp,32
    80003ea0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003ea2:	ee3fc0ef          	jal	80000d84 <myproc>
    80003ea6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003ea8:	0d050793          	addi	a5,a0,208
    80003eac:	4501                	li	a0,0
    80003eae:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003eb0:	6398                	ld	a4,0(a5)
    80003eb2:	cb19                	beqz	a4,80003ec8 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003eb4:	2505                	addiw	a0,a0,1
    80003eb6:	07a1                	addi	a5,a5,8
    80003eb8:	fed51ce3          	bne	a0,a3,80003eb0 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003ebc:	557d                	li	a0,-1
}
    80003ebe:	60e2                	ld	ra,24(sp)
    80003ec0:	6442                	ld	s0,16(sp)
    80003ec2:	64a2                	ld	s1,8(sp)
    80003ec4:	6105                	addi	sp,sp,32
    80003ec6:	8082                	ret
      p->ofile[fd] = f;
    80003ec8:	01a50793          	addi	a5,a0,26
    80003ecc:	078e                	slli	a5,a5,0x3
    80003ece:	963e                	add	a2,a2,a5
    80003ed0:	e204                	sd	s1,0(a2)
      return fd;
    80003ed2:	b7f5                	j	80003ebe <fdalloc+0x28>

0000000080003ed4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003ed4:	715d                	addi	sp,sp,-80
    80003ed6:	e486                	sd	ra,72(sp)
    80003ed8:	e0a2                	sd	s0,64(sp)
    80003eda:	fc26                	sd	s1,56(sp)
    80003edc:	f84a                	sd	s2,48(sp)
    80003ede:	f44e                	sd	s3,40(sp)
    80003ee0:	ec56                	sd	s5,24(sp)
    80003ee2:	e85a                	sd	s6,16(sp)
    80003ee4:	0880                	addi	s0,sp,80
    80003ee6:	8b2e                	mv	s6,a1
    80003ee8:	89b2                	mv	s3,a2
    80003eea:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003eec:	fb040593          	addi	a1,s0,-80
    80003ef0:	818ff0ef          	jal	80002f08 <nameiparent>
    80003ef4:	84aa                	mv	s1,a0
    80003ef6:	10050a63          	beqz	a0,8000400a <create+0x136>
    return 0;

  ilock(dp);
    80003efa:	fdefe0ef          	jal	800026d8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003efe:	4601                	li	a2,0
    80003f00:	fb040593          	addi	a1,s0,-80
    80003f04:	8526                	mv	a0,s1
    80003f06:	d83fe0ef          	jal	80002c88 <dirlookup>
    80003f0a:	8aaa                	mv	s5,a0
    80003f0c:	c129                	beqz	a0,80003f4e <create+0x7a>
    iunlockput(dp);
    80003f0e:	8526                	mv	a0,s1
    80003f10:	9d3fe0ef          	jal	800028e2 <iunlockput>
    ilock(ip);
    80003f14:	8556                	mv	a0,s5
    80003f16:	fc2fe0ef          	jal	800026d8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003f1a:	4789                	li	a5,2
    80003f1c:	02fb1463          	bne	s6,a5,80003f44 <create+0x70>
    80003f20:	044ad783          	lhu	a5,68(s5)
    80003f24:	37f9                	addiw	a5,a5,-2
    80003f26:	17c2                	slli	a5,a5,0x30
    80003f28:	93c1                	srli	a5,a5,0x30
    80003f2a:	4705                	li	a4,1
    80003f2c:	00f76c63          	bltu	a4,a5,80003f44 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f30:	8556                	mv	a0,s5
    80003f32:	60a6                	ld	ra,72(sp)
    80003f34:	6406                	ld	s0,64(sp)
    80003f36:	74e2                	ld	s1,56(sp)
    80003f38:	7942                	ld	s2,48(sp)
    80003f3a:	79a2                	ld	s3,40(sp)
    80003f3c:	6ae2                	ld	s5,24(sp)
    80003f3e:	6b42                	ld	s6,16(sp)
    80003f40:	6161                	addi	sp,sp,80
    80003f42:	8082                	ret
    iunlockput(ip);
    80003f44:	8556                	mv	a0,s5
    80003f46:	99dfe0ef          	jal	800028e2 <iunlockput>
    return 0;
    80003f4a:	4a81                	li	s5,0
    80003f4c:	b7d5                	j	80003f30 <create+0x5c>
    80003f4e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f50:	85da                	mv	a1,s6
    80003f52:	4088                	lw	a0,0(s1)
    80003f54:	e14fe0ef          	jal	80002568 <ialloc>
    80003f58:	8a2a                	mv	s4,a0
    80003f5a:	cd15                	beqz	a0,80003f96 <create+0xc2>
  ilock(ip);
    80003f5c:	f7cfe0ef          	jal	800026d8 <ilock>
  ip->major = major;
    80003f60:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f64:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f68:	4905                	li	s2,1
    80003f6a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f6e:	8552                	mv	a0,s4
    80003f70:	eb4fe0ef          	jal	80002624 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f74:	032b0763          	beq	s6,s2,80003fa2 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f78:	004a2603          	lw	a2,4(s4)
    80003f7c:	fb040593          	addi	a1,s0,-80
    80003f80:	8526                	mv	a0,s1
    80003f82:	ed3fe0ef          	jal	80002e54 <dirlink>
    80003f86:	06054563          	bltz	a0,80003ff0 <create+0x11c>
  iunlockput(dp);
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	957fe0ef          	jal	800028e2 <iunlockput>
  return ip;
    80003f90:	8ad2                	mv	s5,s4
    80003f92:	7a02                	ld	s4,32(sp)
    80003f94:	bf71                	j	80003f30 <create+0x5c>
    iunlockput(dp);
    80003f96:	8526                	mv	a0,s1
    80003f98:	94bfe0ef          	jal	800028e2 <iunlockput>
    return 0;
    80003f9c:	8ad2                	mv	s5,s4
    80003f9e:	7a02                	ld	s4,32(sp)
    80003fa0:	bf41                	j	80003f30 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003fa2:	004a2603          	lw	a2,4(s4)
    80003fa6:	00003597          	auipc	a1,0x3
    80003faa:	68258593          	addi	a1,a1,1666 # 80007628 <etext+0x628>
    80003fae:	8552                	mv	a0,s4
    80003fb0:	ea5fe0ef          	jal	80002e54 <dirlink>
    80003fb4:	02054e63          	bltz	a0,80003ff0 <create+0x11c>
    80003fb8:	40d0                	lw	a2,4(s1)
    80003fba:	00003597          	auipc	a1,0x3
    80003fbe:	67658593          	addi	a1,a1,1654 # 80007630 <etext+0x630>
    80003fc2:	8552                	mv	a0,s4
    80003fc4:	e91fe0ef          	jal	80002e54 <dirlink>
    80003fc8:	02054463          	bltz	a0,80003ff0 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fcc:	004a2603          	lw	a2,4(s4)
    80003fd0:	fb040593          	addi	a1,s0,-80
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	e7ffe0ef          	jal	80002e54 <dirlink>
    80003fda:	00054b63          	bltz	a0,80003ff0 <create+0x11c>
    dp->nlink++;  // for ".."
    80003fde:	04a4d783          	lhu	a5,74(s1)
    80003fe2:	2785                	addiw	a5,a5,1
    80003fe4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fe8:	8526                	mv	a0,s1
    80003fea:	e3afe0ef          	jal	80002624 <iupdate>
    80003fee:	bf71                	j	80003f8a <create+0xb6>
  ip->nlink = 0;
    80003ff0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003ff4:	8552                	mv	a0,s4
    80003ff6:	e2efe0ef          	jal	80002624 <iupdate>
  iunlockput(ip);
    80003ffa:	8552                	mv	a0,s4
    80003ffc:	8e7fe0ef          	jal	800028e2 <iunlockput>
  iunlockput(dp);
    80004000:	8526                	mv	a0,s1
    80004002:	8e1fe0ef          	jal	800028e2 <iunlockput>
  return 0;
    80004006:	7a02                	ld	s4,32(sp)
    80004008:	b725                	j	80003f30 <create+0x5c>
    return 0;
    8000400a:	8aaa                	mv	s5,a0
    8000400c:	b715                	j	80003f30 <create+0x5c>

000000008000400e <sys_dup>:
{
    8000400e:	7179                	addi	sp,sp,-48
    80004010:	f406                	sd	ra,40(sp)
    80004012:	f022                	sd	s0,32(sp)
    80004014:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004016:	fd840613          	addi	a2,s0,-40
    8000401a:	4581                	li	a1,0
    8000401c:	4501                	li	a0,0
    8000401e:	e21ff0ef          	jal	80003e3e <argfd>
    return -1;
    80004022:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004024:	02054363          	bltz	a0,8000404a <sys_dup+0x3c>
    80004028:	ec26                	sd	s1,24(sp)
    8000402a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000402c:	fd843903          	ld	s2,-40(s0)
    80004030:	854a                	mv	a0,s2
    80004032:	e65ff0ef          	jal	80003e96 <fdalloc>
    80004036:	84aa                	mv	s1,a0
    return -1;
    80004038:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000403a:	00054d63          	bltz	a0,80004054 <sys_dup+0x46>
  filedup(f);
    8000403e:	854a                	mv	a0,s2
    80004040:	c48ff0ef          	jal	80003488 <filedup>
  return fd;
    80004044:	87a6                	mv	a5,s1
    80004046:	64e2                	ld	s1,24(sp)
    80004048:	6942                	ld	s2,16(sp)
}
    8000404a:	853e                	mv	a0,a5
    8000404c:	70a2                	ld	ra,40(sp)
    8000404e:	7402                	ld	s0,32(sp)
    80004050:	6145                	addi	sp,sp,48
    80004052:	8082                	ret
    80004054:	64e2                	ld	s1,24(sp)
    80004056:	6942                	ld	s2,16(sp)
    80004058:	bfcd                	j	8000404a <sys_dup+0x3c>

000000008000405a <sys_read>:
{
    8000405a:	7179                	addi	sp,sp,-48
    8000405c:	f406                	sd	ra,40(sp)
    8000405e:	f022                	sd	s0,32(sp)
    80004060:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004062:	fd840593          	addi	a1,s0,-40
    80004066:	4505                	li	a0,1
    80004068:	c3dfd0ef          	jal	80001ca4 <argaddr>
  argint(2, &n);
    8000406c:	fe440593          	addi	a1,s0,-28
    80004070:	4509                	li	a0,2
    80004072:	c17fd0ef          	jal	80001c88 <argint>
  if(argfd(0, 0, &f) < 0)
    80004076:	fe840613          	addi	a2,s0,-24
    8000407a:	4581                	li	a1,0
    8000407c:	4501                	li	a0,0
    8000407e:	dc1ff0ef          	jal	80003e3e <argfd>
    80004082:	87aa                	mv	a5,a0
    return -1;
    80004084:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004086:	0007ca63          	bltz	a5,8000409a <sys_read+0x40>
  return fileread(f, p, n);
    8000408a:	fe442603          	lw	a2,-28(s0)
    8000408e:	fd843583          	ld	a1,-40(s0)
    80004092:	fe843503          	ld	a0,-24(s0)
    80004096:	d58ff0ef          	jal	800035ee <fileread>
}
    8000409a:	70a2                	ld	ra,40(sp)
    8000409c:	7402                	ld	s0,32(sp)
    8000409e:	6145                	addi	sp,sp,48
    800040a0:	8082                	ret

00000000800040a2 <sys_write>:
{
    800040a2:	7179                	addi	sp,sp,-48
    800040a4:	f406                	sd	ra,40(sp)
    800040a6:	f022                	sd	s0,32(sp)
    800040a8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040aa:	fd840593          	addi	a1,s0,-40
    800040ae:	4505                	li	a0,1
    800040b0:	bf5fd0ef          	jal	80001ca4 <argaddr>
  argint(2, &n);
    800040b4:	fe440593          	addi	a1,s0,-28
    800040b8:	4509                	li	a0,2
    800040ba:	bcffd0ef          	jal	80001c88 <argint>
  if(argfd(0, 0, &f) < 0)
    800040be:	fe840613          	addi	a2,s0,-24
    800040c2:	4581                	li	a1,0
    800040c4:	4501                	li	a0,0
    800040c6:	d79ff0ef          	jal	80003e3e <argfd>
    800040ca:	87aa                	mv	a5,a0
    return -1;
    800040cc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040ce:	0007ca63          	bltz	a5,800040e2 <sys_write+0x40>
  return filewrite(f, p, n);
    800040d2:	fe442603          	lw	a2,-28(s0)
    800040d6:	fd843583          	ld	a1,-40(s0)
    800040da:	fe843503          	ld	a0,-24(s0)
    800040de:	dceff0ef          	jal	800036ac <filewrite>
}
    800040e2:	70a2                	ld	ra,40(sp)
    800040e4:	7402                	ld	s0,32(sp)
    800040e6:	6145                	addi	sp,sp,48
    800040e8:	8082                	ret

00000000800040ea <sys_close>:
{
    800040ea:	1101                	addi	sp,sp,-32
    800040ec:	ec06                	sd	ra,24(sp)
    800040ee:	e822                	sd	s0,16(sp)
    800040f0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800040f2:	fe040613          	addi	a2,s0,-32
    800040f6:	fec40593          	addi	a1,s0,-20
    800040fa:	4501                	li	a0,0
    800040fc:	d43ff0ef          	jal	80003e3e <argfd>
    return -1;
    80004100:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004102:	02054063          	bltz	a0,80004122 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004106:	c7ffc0ef          	jal	80000d84 <myproc>
    8000410a:	fec42783          	lw	a5,-20(s0)
    8000410e:	07e9                	addi	a5,a5,26
    80004110:	078e                	slli	a5,a5,0x3
    80004112:	953e                	add	a0,a0,a5
    80004114:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004118:	fe043503          	ld	a0,-32(s0)
    8000411c:	bb2ff0ef          	jal	800034ce <fileclose>
  return 0;
    80004120:	4781                	li	a5,0
}
    80004122:	853e                	mv	a0,a5
    80004124:	60e2                	ld	ra,24(sp)
    80004126:	6442                	ld	s0,16(sp)
    80004128:	6105                	addi	sp,sp,32
    8000412a:	8082                	ret

000000008000412c <sys_fstat>:
{
    8000412c:	1101                	addi	sp,sp,-32
    8000412e:	ec06                	sd	ra,24(sp)
    80004130:	e822                	sd	s0,16(sp)
    80004132:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004134:	fe040593          	addi	a1,s0,-32
    80004138:	4505                	li	a0,1
    8000413a:	b6bfd0ef          	jal	80001ca4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000413e:	fe840613          	addi	a2,s0,-24
    80004142:	4581                	li	a1,0
    80004144:	4501                	li	a0,0
    80004146:	cf9ff0ef          	jal	80003e3e <argfd>
    8000414a:	87aa                	mv	a5,a0
    return -1;
    8000414c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000414e:	0007c863          	bltz	a5,8000415e <sys_fstat+0x32>
  return filestat(f, st);
    80004152:	fe043583          	ld	a1,-32(s0)
    80004156:	fe843503          	ld	a0,-24(s0)
    8000415a:	c36ff0ef          	jal	80003590 <filestat>
}
    8000415e:	60e2                	ld	ra,24(sp)
    80004160:	6442                	ld	s0,16(sp)
    80004162:	6105                	addi	sp,sp,32
    80004164:	8082                	ret

0000000080004166 <sys_link>:
{
    80004166:	7169                	addi	sp,sp,-304
    80004168:	f606                	sd	ra,296(sp)
    8000416a:	f222                	sd	s0,288(sp)
    8000416c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000416e:	08000613          	li	a2,128
    80004172:	ed040593          	addi	a1,s0,-304
    80004176:	4501                	li	a0,0
    80004178:	b49fd0ef          	jal	80001cc0 <argstr>
    return -1;
    8000417c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000417e:	0c054e63          	bltz	a0,8000425a <sys_link+0xf4>
    80004182:	08000613          	li	a2,128
    80004186:	f5040593          	addi	a1,s0,-176
    8000418a:	4505                	li	a0,1
    8000418c:	b35fd0ef          	jal	80001cc0 <argstr>
    return -1;
    80004190:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004192:	0c054463          	bltz	a0,8000425a <sys_link+0xf4>
    80004196:	ee26                	sd	s1,280(sp)
  begin_op();
    80004198:	f2bfe0ef          	jal	800030c2 <begin_op>
  if((ip = namei(old)) == 0){
    8000419c:	ed040513          	addi	a0,s0,-304
    800041a0:	d4ffe0ef          	jal	80002eee <namei>
    800041a4:	84aa                	mv	s1,a0
    800041a6:	c53d                	beqz	a0,80004214 <sys_link+0xae>
  ilock(ip);
    800041a8:	d30fe0ef          	jal	800026d8 <ilock>
  if(ip->type == T_DIR){
    800041ac:	04449703          	lh	a4,68(s1)
    800041b0:	4785                	li	a5,1
    800041b2:	06f70663          	beq	a4,a5,8000421e <sys_link+0xb8>
    800041b6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800041b8:	04a4d783          	lhu	a5,74(s1)
    800041bc:	2785                	addiw	a5,a5,1
    800041be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041c2:	8526                	mv	a0,s1
    800041c4:	c60fe0ef          	jal	80002624 <iupdate>
  iunlock(ip);
    800041c8:	8526                	mv	a0,s1
    800041ca:	dbcfe0ef          	jal	80002786 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800041ce:	fd040593          	addi	a1,s0,-48
    800041d2:	f5040513          	addi	a0,s0,-176
    800041d6:	d33fe0ef          	jal	80002f08 <nameiparent>
    800041da:	892a                	mv	s2,a0
    800041dc:	cd21                	beqz	a0,80004234 <sys_link+0xce>
  ilock(dp);
    800041de:	cfafe0ef          	jal	800026d8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041e2:	00092703          	lw	a4,0(s2)
    800041e6:	409c                	lw	a5,0(s1)
    800041e8:	04f71363          	bne	a4,a5,8000422e <sys_link+0xc8>
    800041ec:	40d0                	lw	a2,4(s1)
    800041ee:	fd040593          	addi	a1,s0,-48
    800041f2:	854a                	mv	a0,s2
    800041f4:	c61fe0ef          	jal	80002e54 <dirlink>
    800041f8:	02054b63          	bltz	a0,8000422e <sys_link+0xc8>
  iunlockput(dp);
    800041fc:	854a                	mv	a0,s2
    800041fe:	ee4fe0ef          	jal	800028e2 <iunlockput>
  iput(ip);
    80004202:	8526                	mv	a0,s1
    80004204:	e56fe0ef          	jal	8000285a <iput>
  end_op();
    80004208:	f25fe0ef          	jal	8000312c <end_op>
  return 0;
    8000420c:	4781                	li	a5,0
    8000420e:	64f2                	ld	s1,280(sp)
    80004210:	6952                	ld	s2,272(sp)
    80004212:	a0a1                	j	8000425a <sys_link+0xf4>
    end_op();
    80004214:	f19fe0ef          	jal	8000312c <end_op>
    return -1;
    80004218:	57fd                	li	a5,-1
    8000421a:	64f2                	ld	s1,280(sp)
    8000421c:	a83d                	j	8000425a <sys_link+0xf4>
    iunlockput(ip);
    8000421e:	8526                	mv	a0,s1
    80004220:	ec2fe0ef          	jal	800028e2 <iunlockput>
    end_op();
    80004224:	f09fe0ef          	jal	8000312c <end_op>
    return -1;
    80004228:	57fd                	li	a5,-1
    8000422a:	64f2                	ld	s1,280(sp)
    8000422c:	a03d                	j	8000425a <sys_link+0xf4>
    iunlockput(dp);
    8000422e:	854a                	mv	a0,s2
    80004230:	eb2fe0ef          	jal	800028e2 <iunlockput>
  ilock(ip);
    80004234:	8526                	mv	a0,s1
    80004236:	ca2fe0ef          	jal	800026d8 <ilock>
  ip->nlink--;
    8000423a:	04a4d783          	lhu	a5,74(s1)
    8000423e:	37fd                	addiw	a5,a5,-1
    80004240:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004244:	8526                	mv	a0,s1
    80004246:	bdefe0ef          	jal	80002624 <iupdate>
  iunlockput(ip);
    8000424a:	8526                	mv	a0,s1
    8000424c:	e96fe0ef          	jal	800028e2 <iunlockput>
  end_op();
    80004250:	eddfe0ef          	jal	8000312c <end_op>
  return -1;
    80004254:	57fd                	li	a5,-1
    80004256:	64f2                	ld	s1,280(sp)
    80004258:	6952                	ld	s2,272(sp)
}
    8000425a:	853e                	mv	a0,a5
    8000425c:	70b2                	ld	ra,296(sp)
    8000425e:	7412                	ld	s0,288(sp)
    80004260:	6155                	addi	sp,sp,304
    80004262:	8082                	ret

0000000080004264 <sys_unlink>:
{
    80004264:	7151                	addi	sp,sp,-240
    80004266:	f586                	sd	ra,232(sp)
    80004268:	f1a2                	sd	s0,224(sp)
    8000426a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000426c:	08000613          	li	a2,128
    80004270:	f3040593          	addi	a1,s0,-208
    80004274:	4501                	li	a0,0
    80004276:	a4bfd0ef          	jal	80001cc0 <argstr>
    8000427a:	16054063          	bltz	a0,800043da <sys_unlink+0x176>
    8000427e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004280:	e43fe0ef          	jal	800030c2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004284:	fb040593          	addi	a1,s0,-80
    80004288:	f3040513          	addi	a0,s0,-208
    8000428c:	c7dfe0ef          	jal	80002f08 <nameiparent>
    80004290:	84aa                	mv	s1,a0
    80004292:	c945                	beqz	a0,80004342 <sys_unlink+0xde>
  ilock(dp);
    80004294:	c44fe0ef          	jal	800026d8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004298:	00003597          	auipc	a1,0x3
    8000429c:	39058593          	addi	a1,a1,912 # 80007628 <etext+0x628>
    800042a0:	fb040513          	addi	a0,s0,-80
    800042a4:	9cffe0ef          	jal	80002c72 <namecmp>
    800042a8:	10050e63          	beqz	a0,800043c4 <sys_unlink+0x160>
    800042ac:	00003597          	auipc	a1,0x3
    800042b0:	38458593          	addi	a1,a1,900 # 80007630 <etext+0x630>
    800042b4:	fb040513          	addi	a0,s0,-80
    800042b8:	9bbfe0ef          	jal	80002c72 <namecmp>
    800042bc:	10050463          	beqz	a0,800043c4 <sys_unlink+0x160>
    800042c0:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800042c2:	f2c40613          	addi	a2,s0,-212
    800042c6:	fb040593          	addi	a1,s0,-80
    800042ca:	8526                	mv	a0,s1
    800042cc:	9bdfe0ef          	jal	80002c88 <dirlookup>
    800042d0:	892a                	mv	s2,a0
    800042d2:	0e050863          	beqz	a0,800043c2 <sys_unlink+0x15e>
  ilock(ip);
    800042d6:	c02fe0ef          	jal	800026d8 <ilock>
  if(ip->nlink < 1)
    800042da:	04a91783          	lh	a5,74(s2)
    800042de:	06f05763          	blez	a5,8000434c <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042e2:	04491703          	lh	a4,68(s2)
    800042e6:	4785                	li	a5,1
    800042e8:	06f70963          	beq	a4,a5,8000435a <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800042ec:	4641                	li	a2,16
    800042ee:	4581                	li	a1,0
    800042f0:	fc040513          	addi	a0,s0,-64
    800042f4:	e41fb0ef          	jal	80000134 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042f8:	4741                	li	a4,16
    800042fa:	f2c42683          	lw	a3,-212(s0)
    800042fe:	fc040613          	addi	a2,s0,-64
    80004302:	4581                	li	a1,0
    80004304:	8526                	mv	a0,s1
    80004306:	85ffe0ef          	jal	80002b64 <writei>
    8000430a:	47c1                	li	a5,16
    8000430c:	08f51b63          	bne	a0,a5,800043a2 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004310:	04491703          	lh	a4,68(s2)
    80004314:	4785                	li	a5,1
    80004316:	08f70d63          	beq	a4,a5,800043b0 <sys_unlink+0x14c>
  iunlockput(dp);
    8000431a:	8526                	mv	a0,s1
    8000431c:	dc6fe0ef          	jal	800028e2 <iunlockput>
  ip->nlink--;
    80004320:	04a95783          	lhu	a5,74(s2)
    80004324:	37fd                	addiw	a5,a5,-1
    80004326:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000432a:	854a                	mv	a0,s2
    8000432c:	af8fe0ef          	jal	80002624 <iupdate>
  iunlockput(ip);
    80004330:	854a                	mv	a0,s2
    80004332:	db0fe0ef          	jal	800028e2 <iunlockput>
  end_op();
    80004336:	df7fe0ef          	jal	8000312c <end_op>
  return 0;
    8000433a:	4501                	li	a0,0
    8000433c:	64ee                	ld	s1,216(sp)
    8000433e:	694e                	ld	s2,208(sp)
    80004340:	a849                	j	800043d2 <sys_unlink+0x16e>
    end_op();
    80004342:	debfe0ef          	jal	8000312c <end_op>
    return -1;
    80004346:	557d                	li	a0,-1
    80004348:	64ee                	ld	s1,216(sp)
    8000434a:	a061                	j	800043d2 <sys_unlink+0x16e>
    8000434c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000434e:	00003517          	auipc	a0,0x3
    80004352:	2ea50513          	addi	a0,a0,746 # 80007638 <etext+0x638>
    80004356:	2c8010ef          	jal	8000561e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000435a:	04c92703          	lw	a4,76(s2)
    8000435e:	02000793          	li	a5,32
    80004362:	f8e7f5e3          	bgeu	a5,a4,800042ec <sys_unlink+0x88>
    80004366:	e5ce                	sd	s3,200(sp)
    80004368:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000436c:	4741                	li	a4,16
    8000436e:	86ce                	mv	a3,s3
    80004370:	f1840613          	addi	a2,s0,-232
    80004374:	4581                	li	a1,0
    80004376:	854a                	mv	a0,s2
    80004378:	ef0fe0ef          	jal	80002a68 <readi>
    8000437c:	47c1                	li	a5,16
    8000437e:	00f51c63          	bne	a0,a5,80004396 <sys_unlink+0x132>
    if(de.inum != 0)
    80004382:	f1845783          	lhu	a5,-232(s0)
    80004386:	efa1                	bnez	a5,800043de <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004388:	29c1                	addiw	s3,s3,16
    8000438a:	04c92783          	lw	a5,76(s2)
    8000438e:	fcf9efe3          	bltu	s3,a5,8000436c <sys_unlink+0x108>
    80004392:	69ae                	ld	s3,200(sp)
    80004394:	bfa1                	j	800042ec <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004396:	00003517          	auipc	a0,0x3
    8000439a:	2ba50513          	addi	a0,a0,698 # 80007650 <etext+0x650>
    8000439e:	280010ef          	jal	8000561e <panic>
    800043a2:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800043a4:	00003517          	auipc	a0,0x3
    800043a8:	2c450513          	addi	a0,a0,708 # 80007668 <etext+0x668>
    800043ac:	272010ef          	jal	8000561e <panic>
    dp->nlink--;
    800043b0:	04a4d783          	lhu	a5,74(s1)
    800043b4:	37fd                	addiw	a5,a5,-1
    800043b6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800043ba:	8526                	mv	a0,s1
    800043bc:	a68fe0ef          	jal	80002624 <iupdate>
    800043c0:	bfa9                	j	8000431a <sys_unlink+0xb6>
    800043c2:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800043c4:	8526                	mv	a0,s1
    800043c6:	d1cfe0ef          	jal	800028e2 <iunlockput>
  end_op();
    800043ca:	d63fe0ef          	jal	8000312c <end_op>
  return -1;
    800043ce:	557d                	li	a0,-1
    800043d0:	64ee                	ld	s1,216(sp)
}
    800043d2:	70ae                	ld	ra,232(sp)
    800043d4:	740e                	ld	s0,224(sp)
    800043d6:	616d                	addi	sp,sp,240
    800043d8:	8082                	ret
    return -1;
    800043da:	557d                	li	a0,-1
    800043dc:	bfdd                	j	800043d2 <sys_unlink+0x16e>
    iunlockput(ip);
    800043de:	854a                	mv	a0,s2
    800043e0:	d02fe0ef          	jal	800028e2 <iunlockput>
    goto bad;
    800043e4:	694e                	ld	s2,208(sp)
    800043e6:	69ae                	ld	s3,200(sp)
    800043e8:	bff1                	j	800043c4 <sys_unlink+0x160>

00000000800043ea <sys_open>:

uint64
sys_open(void)
{
    800043ea:	7131                	addi	sp,sp,-192
    800043ec:	fd06                	sd	ra,184(sp)
    800043ee:	f922                	sd	s0,176(sp)
    800043f0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043f2:	f4c40593          	addi	a1,s0,-180
    800043f6:	4505                	li	a0,1
    800043f8:	891fd0ef          	jal	80001c88 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043fc:	08000613          	li	a2,128
    80004400:	f5040593          	addi	a1,s0,-176
    80004404:	4501                	li	a0,0
    80004406:	8bbfd0ef          	jal	80001cc0 <argstr>
    8000440a:	87aa                	mv	a5,a0
    return -1;
    8000440c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000440e:	0a07c263          	bltz	a5,800044b2 <sys_open+0xc8>
    80004412:	f526                	sd	s1,168(sp)

  begin_op();
    80004414:	caffe0ef          	jal	800030c2 <begin_op>

  if(omode & O_CREATE){
    80004418:	f4c42783          	lw	a5,-180(s0)
    8000441c:	2007f793          	andi	a5,a5,512
    80004420:	c3d5                	beqz	a5,800044c4 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004422:	4681                	li	a3,0
    80004424:	4601                	li	a2,0
    80004426:	4589                	li	a1,2
    80004428:	f5040513          	addi	a0,s0,-176
    8000442c:	aa9ff0ef          	jal	80003ed4 <create>
    80004430:	84aa                	mv	s1,a0
    if(ip == 0){
    80004432:	c541                	beqz	a0,800044ba <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004434:	04449703          	lh	a4,68(s1)
    80004438:	478d                	li	a5,3
    8000443a:	00f71763          	bne	a4,a5,80004448 <sys_open+0x5e>
    8000443e:	0464d703          	lhu	a4,70(s1)
    80004442:	47a5                	li	a5,9
    80004444:	0ae7ed63          	bltu	a5,a4,800044fe <sys_open+0x114>
    80004448:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000444a:	fe1fe0ef          	jal	8000342a <filealloc>
    8000444e:	892a                	mv	s2,a0
    80004450:	c179                	beqz	a0,80004516 <sys_open+0x12c>
    80004452:	ed4e                	sd	s3,152(sp)
    80004454:	a43ff0ef          	jal	80003e96 <fdalloc>
    80004458:	89aa                	mv	s3,a0
    8000445a:	0a054a63          	bltz	a0,8000450e <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000445e:	04449703          	lh	a4,68(s1)
    80004462:	478d                	li	a5,3
    80004464:	0cf70263          	beq	a4,a5,80004528 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004468:	4789                	li	a5,2
    8000446a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000446e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004472:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004476:	f4c42783          	lw	a5,-180(s0)
    8000447a:	0017c713          	xori	a4,a5,1
    8000447e:	8b05                	andi	a4,a4,1
    80004480:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004484:	0037f713          	andi	a4,a5,3
    80004488:	00e03733          	snez	a4,a4
    8000448c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004490:	4007f793          	andi	a5,a5,1024
    80004494:	c791                	beqz	a5,800044a0 <sys_open+0xb6>
    80004496:	04449703          	lh	a4,68(s1)
    8000449a:	4789                	li	a5,2
    8000449c:	08f70d63          	beq	a4,a5,80004536 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800044a0:	8526                	mv	a0,s1
    800044a2:	ae4fe0ef          	jal	80002786 <iunlock>
  end_op();
    800044a6:	c87fe0ef          	jal	8000312c <end_op>

  return fd;
    800044aa:	854e                	mv	a0,s3
    800044ac:	74aa                	ld	s1,168(sp)
    800044ae:	790a                	ld	s2,160(sp)
    800044b0:	69ea                	ld	s3,152(sp)
}
    800044b2:	70ea                	ld	ra,184(sp)
    800044b4:	744a                	ld	s0,176(sp)
    800044b6:	6129                	addi	sp,sp,192
    800044b8:	8082                	ret
      end_op();
    800044ba:	c73fe0ef          	jal	8000312c <end_op>
      return -1;
    800044be:	557d                	li	a0,-1
    800044c0:	74aa                	ld	s1,168(sp)
    800044c2:	bfc5                	j	800044b2 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800044c4:	f5040513          	addi	a0,s0,-176
    800044c8:	a27fe0ef          	jal	80002eee <namei>
    800044cc:	84aa                	mv	s1,a0
    800044ce:	c11d                	beqz	a0,800044f4 <sys_open+0x10a>
    ilock(ip);
    800044d0:	a08fe0ef          	jal	800026d8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800044d4:	04449703          	lh	a4,68(s1)
    800044d8:	4785                	li	a5,1
    800044da:	f4f71de3          	bne	a4,a5,80004434 <sys_open+0x4a>
    800044de:	f4c42783          	lw	a5,-180(s0)
    800044e2:	d3bd                	beqz	a5,80004448 <sys_open+0x5e>
      iunlockput(ip);
    800044e4:	8526                	mv	a0,s1
    800044e6:	bfcfe0ef          	jal	800028e2 <iunlockput>
      end_op();
    800044ea:	c43fe0ef          	jal	8000312c <end_op>
      return -1;
    800044ee:	557d                	li	a0,-1
    800044f0:	74aa                	ld	s1,168(sp)
    800044f2:	b7c1                	j	800044b2 <sys_open+0xc8>
      end_op();
    800044f4:	c39fe0ef          	jal	8000312c <end_op>
      return -1;
    800044f8:	557d                	li	a0,-1
    800044fa:	74aa                	ld	s1,168(sp)
    800044fc:	bf5d                	j	800044b2 <sys_open+0xc8>
    iunlockput(ip);
    800044fe:	8526                	mv	a0,s1
    80004500:	be2fe0ef          	jal	800028e2 <iunlockput>
    end_op();
    80004504:	c29fe0ef          	jal	8000312c <end_op>
    return -1;
    80004508:	557d                	li	a0,-1
    8000450a:	74aa                	ld	s1,168(sp)
    8000450c:	b75d                	j	800044b2 <sys_open+0xc8>
      fileclose(f);
    8000450e:	854a                	mv	a0,s2
    80004510:	fbffe0ef          	jal	800034ce <fileclose>
    80004514:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004516:	8526                	mv	a0,s1
    80004518:	bcafe0ef          	jal	800028e2 <iunlockput>
    end_op();
    8000451c:	c11fe0ef          	jal	8000312c <end_op>
    return -1;
    80004520:	557d                	li	a0,-1
    80004522:	74aa                	ld	s1,168(sp)
    80004524:	790a                	ld	s2,160(sp)
    80004526:	b771                	j	800044b2 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004528:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000452c:	04649783          	lh	a5,70(s1)
    80004530:	02f91223          	sh	a5,36(s2)
    80004534:	bf3d                	j	80004472 <sys_open+0x88>
    itrunc(ip);
    80004536:	8526                	mv	a0,s1
    80004538:	a8efe0ef          	jal	800027c6 <itrunc>
    8000453c:	b795                	j	800044a0 <sys_open+0xb6>

000000008000453e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000453e:	7175                	addi	sp,sp,-144
    80004540:	e506                	sd	ra,136(sp)
    80004542:	e122                	sd	s0,128(sp)
    80004544:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004546:	b7dfe0ef          	jal	800030c2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000454a:	08000613          	li	a2,128
    8000454e:	f7040593          	addi	a1,s0,-144
    80004552:	4501                	li	a0,0
    80004554:	f6cfd0ef          	jal	80001cc0 <argstr>
    80004558:	02054363          	bltz	a0,8000457e <sys_mkdir+0x40>
    8000455c:	4681                	li	a3,0
    8000455e:	4601                	li	a2,0
    80004560:	4585                	li	a1,1
    80004562:	f7040513          	addi	a0,s0,-144
    80004566:	96fff0ef          	jal	80003ed4 <create>
    8000456a:	c911                	beqz	a0,8000457e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000456c:	b76fe0ef          	jal	800028e2 <iunlockput>
  end_op();
    80004570:	bbdfe0ef          	jal	8000312c <end_op>
  return 0;
    80004574:	4501                	li	a0,0
}
    80004576:	60aa                	ld	ra,136(sp)
    80004578:	640a                	ld	s0,128(sp)
    8000457a:	6149                	addi	sp,sp,144
    8000457c:	8082                	ret
    end_op();
    8000457e:	baffe0ef          	jal	8000312c <end_op>
    return -1;
    80004582:	557d                	li	a0,-1
    80004584:	bfcd                	j	80004576 <sys_mkdir+0x38>

0000000080004586 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004586:	7135                	addi	sp,sp,-160
    80004588:	ed06                	sd	ra,152(sp)
    8000458a:	e922                	sd	s0,144(sp)
    8000458c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000458e:	b35fe0ef          	jal	800030c2 <begin_op>
  argint(1, &major);
    80004592:	f6c40593          	addi	a1,s0,-148
    80004596:	4505                	li	a0,1
    80004598:	ef0fd0ef          	jal	80001c88 <argint>
  argint(2, &minor);
    8000459c:	f6840593          	addi	a1,s0,-152
    800045a0:	4509                	li	a0,2
    800045a2:	ee6fd0ef          	jal	80001c88 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045a6:	08000613          	li	a2,128
    800045aa:	f7040593          	addi	a1,s0,-144
    800045ae:	4501                	li	a0,0
    800045b0:	f10fd0ef          	jal	80001cc0 <argstr>
    800045b4:	02054563          	bltz	a0,800045de <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800045b8:	f6841683          	lh	a3,-152(s0)
    800045bc:	f6c41603          	lh	a2,-148(s0)
    800045c0:	458d                	li	a1,3
    800045c2:	f7040513          	addi	a0,s0,-144
    800045c6:	90fff0ef          	jal	80003ed4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045ca:	c911                	beqz	a0,800045de <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045cc:	b16fe0ef          	jal	800028e2 <iunlockput>
  end_op();
    800045d0:	b5dfe0ef          	jal	8000312c <end_op>
  return 0;
    800045d4:	4501                	li	a0,0
}
    800045d6:	60ea                	ld	ra,152(sp)
    800045d8:	644a                	ld	s0,144(sp)
    800045da:	610d                	addi	sp,sp,160
    800045dc:	8082                	ret
    end_op();
    800045de:	b4ffe0ef          	jal	8000312c <end_op>
    return -1;
    800045e2:	557d                	li	a0,-1
    800045e4:	bfcd                	j	800045d6 <sys_mknod+0x50>

00000000800045e6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045e6:	7135                	addi	sp,sp,-160
    800045e8:	ed06                	sd	ra,152(sp)
    800045ea:	e922                	sd	s0,144(sp)
    800045ec:	e14a                	sd	s2,128(sp)
    800045ee:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045f0:	f94fc0ef          	jal	80000d84 <myproc>
    800045f4:	892a                	mv	s2,a0
  
  begin_op();
    800045f6:	acdfe0ef          	jal	800030c2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045fa:	08000613          	li	a2,128
    800045fe:	f6040593          	addi	a1,s0,-160
    80004602:	4501                	li	a0,0
    80004604:	ebcfd0ef          	jal	80001cc0 <argstr>
    80004608:	04054363          	bltz	a0,8000464e <sys_chdir+0x68>
    8000460c:	e526                	sd	s1,136(sp)
    8000460e:	f6040513          	addi	a0,s0,-160
    80004612:	8ddfe0ef          	jal	80002eee <namei>
    80004616:	84aa                	mv	s1,a0
    80004618:	c915                	beqz	a0,8000464c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000461a:	8befe0ef          	jal	800026d8 <ilock>
  if(ip->type != T_DIR){
    8000461e:	04449703          	lh	a4,68(s1)
    80004622:	4785                	li	a5,1
    80004624:	02f71963          	bne	a4,a5,80004656 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004628:	8526                	mv	a0,s1
    8000462a:	95cfe0ef          	jal	80002786 <iunlock>
  iput(p->cwd);
    8000462e:	15093503          	ld	a0,336(s2)
    80004632:	a28fe0ef          	jal	8000285a <iput>
  end_op();
    80004636:	af7fe0ef          	jal	8000312c <end_op>
  p->cwd = ip;
    8000463a:	14993823          	sd	s1,336(s2)
  return 0;
    8000463e:	4501                	li	a0,0
    80004640:	64aa                	ld	s1,136(sp)
}
    80004642:	60ea                	ld	ra,152(sp)
    80004644:	644a                	ld	s0,144(sp)
    80004646:	690a                	ld	s2,128(sp)
    80004648:	610d                	addi	sp,sp,160
    8000464a:	8082                	ret
    8000464c:	64aa                	ld	s1,136(sp)
    end_op();
    8000464e:	adffe0ef          	jal	8000312c <end_op>
    return -1;
    80004652:	557d                	li	a0,-1
    80004654:	b7fd                	j	80004642 <sys_chdir+0x5c>
    iunlockput(ip);
    80004656:	8526                	mv	a0,s1
    80004658:	a8afe0ef          	jal	800028e2 <iunlockput>
    end_op();
    8000465c:	ad1fe0ef          	jal	8000312c <end_op>
    return -1;
    80004660:	557d                	li	a0,-1
    80004662:	64aa                	ld	s1,136(sp)
    80004664:	bff9                	j	80004642 <sys_chdir+0x5c>

0000000080004666 <sys_exec>:

uint64
sys_exec(void)
{
    80004666:	7121                	addi	sp,sp,-448
    80004668:	ff06                	sd	ra,440(sp)
    8000466a:	fb22                	sd	s0,432(sp)
    8000466c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000466e:	e4840593          	addi	a1,s0,-440
    80004672:	4505                	li	a0,1
    80004674:	e30fd0ef          	jal	80001ca4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004678:	08000613          	li	a2,128
    8000467c:	f5040593          	addi	a1,s0,-176
    80004680:	4501                	li	a0,0
    80004682:	e3efd0ef          	jal	80001cc0 <argstr>
    80004686:	87aa                	mv	a5,a0
    return -1;
    80004688:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000468a:	0c07c463          	bltz	a5,80004752 <sys_exec+0xec>
    8000468e:	f726                	sd	s1,424(sp)
    80004690:	f34a                	sd	s2,416(sp)
    80004692:	ef4e                	sd	s3,408(sp)
    80004694:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004696:	10000613          	li	a2,256
    8000469a:	4581                	li	a1,0
    8000469c:	e5040513          	addi	a0,s0,-432
    800046a0:	a95fb0ef          	jal	80000134 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800046a4:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800046a8:	89a6                	mv	s3,s1
    800046aa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800046ac:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800046b0:	00391513          	slli	a0,s2,0x3
    800046b4:	e4040593          	addi	a1,s0,-448
    800046b8:	e4843783          	ld	a5,-440(s0)
    800046bc:	953e                	add	a0,a0,a5
    800046be:	d40fd0ef          	jal	80001bfe <fetchaddr>
    800046c2:	02054663          	bltz	a0,800046ee <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800046c6:	e4043783          	ld	a5,-448(s0)
    800046ca:	c3a9                	beqz	a5,8000470c <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800046cc:	a2bfb0ef          	jal	800000f6 <kalloc>
    800046d0:	85aa                	mv	a1,a0
    800046d2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800046d6:	cd01                	beqz	a0,800046ee <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046d8:	6605                	lui	a2,0x1
    800046da:	e4043503          	ld	a0,-448(s0)
    800046de:	d6afd0ef          	jal	80001c48 <fetchstr>
    800046e2:	00054663          	bltz	a0,800046ee <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800046e6:	0905                	addi	s2,s2,1
    800046e8:	09a1                	addi	s3,s3,8
    800046ea:	fd4913e3          	bne	s2,s4,800046b0 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ee:	f5040913          	addi	s2,s0,-176
    800046f2:	6088                	ld	a0,0(s1)
    800046f4:	c931                	beqz	a0,80004748 <sys_exec+0xe2>
    kfree(argv[i]);
    800046f6:	927fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046fa:	04a1                	addi	s1,s1,8
    800046fc:	ff249be3          	bne	s1,s2,800046f2 <sys_exec+0x8c>
  return -1;
    80004700:	557d                	li	a0,-1
    80004702:	74ba                	ld	s1,424(sp)
    80004704:	791a                	ld	s2,416(sp)
    80004706:	69fa                	ld	s3,408(sp)
    80004708:	6a5a                	ld	s4,400(sp)
    8000470a:	a0a1                	j	80004752 <sys_exec+0xec>
      argv[i] = 0;
    8000470c:	0009079b          	sext.w	a5,s2
    80004710:	078e                	slli	a5,a5,0x3
    80004712:	fd078793          	addi	a5,a5,-48
    80004716:	97a2                	add	a5,a5,s0
    80004718:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    8000471c:	e5040593          	addi	a1,s0,-432
    80004720:	f5040513          	addi	a0,s0,-176
    80004724:	ba8ff0ef          	jal	80003acc <kexec>
    80004728:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000472a:	f5040993          	addi	s3,s0,-176
    8000472e:	6088                	ld	a0,0(s1)
    80004730:	c511                	beqz	a0,8000473c <sys_exec+0xd6>
    kfree(argv[i]);
    80004732:	8ebfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004736:	04a1                	addi	s1,s1,8
    80004738:	ff349be3          	bne	s1,s3,8000472e <sys_exec+0xc8>
  return ret;
    8000473c:	854a                	mv	a0,s2
    8000473e:	74ba                	ld	s1,424(sp)
    80004740:	791a                	ld	s2,416(sp)
    80004742:	69fa                	ld	s3,408(sp)
    80004744:	6a5a                	ld	s4,400(sp)
    80004746:	a031                	j	80004752 <sys_exec+0xec>
  return -1;
    80004748:	557d                	li	a0,-1
    8000474a:	74ba                	ld	s1,424(sp)
    8000474c:	791a                	ld	s2,416(sp)
    8000474e:	69fa                	ld	s3,408(sp)
    80004750:	6a5a                	ld	s4,400(sp)
}
    80004752:	70fa                	ld	ra,440(sp)
    80004754:	745a                	ld	s0,432(sp)
    80004756:	6139                	addi	sp,sp,448
    80004758:	8082                	ret

000000008000475a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000475a:	7139                	addi	sp,sp,-64
    8000475c:	fc06                	sd	ra,56(sp)
    8000475e:	f822                	sd	s0,48(sp)
    80004760:	f426                	sd	s1,40(sp)
    80004762:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004764:	e20fc0ef          	jal	80000d84 <myproc>
    80004768:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000476a:	fd840593          	addi	a1,s0,-40
    8000476e:	4501                	li	a0,0
    80004770:	d34fd0ef          	jal	80001ca4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004774:	fc840593          	addi	a1,s0,-56
    80004778:	fd040513          	addi	a0,s0,-48
    8000477c:	85cff0ef          	jal	800037d8 <pipealloc>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004782:	0a054463          	bltz	a0,8000482a <sys_pipe+0xd0>
  fd0 = -1;
    80004786:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000478a:	fd043503          	ld	a0,-48(s0)
    8000478e:	f08ff0ef          	jal	80003e96 <fdalloc>
    80004792:	fca42223          	sw	a0,-60(s0)
    80004796:	08054163          	bltz	a0,80004818 <sys_pipe+0xbe>
    8000479a:	fc843503          	ld	a0,-56(s0)
    8000479e:	ef8ff0ef          	jal	80003e96 <fdalloc>
    800047a2:	fca42023          	sw	a0,-64(s0)
    800047a6:	06054063          	bltz	a0,80004806 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047aa:	4691                	li	a3,4
    800047ac:	fc440613          	addi	a2,s0,-60
    800047b0:	fd843583          	ld	a1,-40(s0)
    800047b4:	68a8                	ld	a0,80(s1)
    800047b6:	ad2fc0ef          	jal	80000a88 <copyout>
    800047ba:	00054e63          	bltz	a0,800047d6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800047be:	4691                	li	a3,4
    800047c0:	fc040613          	addi	a2,s0,-64
    800047c4:	fd843583          	ld	a1,-40(s0)
    800047c8:	0591                	addi	a1,a1,4
    800047ca:	68a8                	ld	a0,80(s1)
    800047cc:	abcfc0ef          	jal	80000a88 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047d0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047d2:	04055c63          	bgez	a0,8000482a <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800047d6:	fc442783          	lw	a5,-60(s0)
    800047da:	07e9                	addi	a5,a5,26
    800047dc:	078e                	slli	a5,a5,0x3
    800047de:	97a6                	add	a5,a5,s1
    800047e0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047e4:	fc042783          	lw	a5,-64(s0)
    800047e8:	07e9                	addi	a5,a5,26
    800047ea:	078e                	slli	a5,a5,0x3
    800047ec:	94be                	add	s1,s1,a5
    800047ee:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800047f2:	fd043503          	ld	a0,-48(s0)
    800047f6:	cd9fe0ef          	jal	800034ce <fileclose>
    fileclose(wf);
    800047fa:	fc843503          	ld	a0,-56(s0)
    800047fe:	cd1fe0ef          	jal	800034ce <fileclose>
    return -1;
    80004802:	57fd                	li	a5,-1
    80004804:	a01d                	j	8000482a <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004806:	fc442783          	lw	a5,-60(s0)
    8000480a:	0007c763          	bltz	a5,80004818 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000480e:	07e9                	addi	a5,a5,26
    80004810:	078e                	slli	a5,a5,0x3
    80004812:	97a6                	add	a5,a5,s1
    80004814:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004818:	fd043503          	ld	a0,-48(s0)
    8000481c:	cb3fe0ef          	jal	800034ce <fileclose>
    fileclose(wf);
    80004820:	fc843503          	ld	a0,-56(s0)
    80004824:	cabfe0ef          	jal	800034ce <fileclose>
    return -1;
    80004828:	57fd                	li	a5,-1
}
    8000482a:	853e                	mv	a0,a5
    8000482c:	70e2                	ld	ra,56(sp)
    8000482e:	7442                	ld	s0,48(sp)
    80004830:	74a2                	ld	s1,40(sp)
    80004832:	6121                	addi	sp,sp,64
    80004834:	8082                	ret
	...

0000000080004840 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004840:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004842:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004844:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004846:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004848:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000484a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000484c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000484e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004850:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004852:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004854:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004856:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004858:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000485a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000485c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000485e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004860:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004862:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004864:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004866:	aa8fd0ef          	jal	80001b0e <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000486a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000486c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000486e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004870:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004872:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004874:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004876:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004878:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000487a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000487c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000487e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004880:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004882:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004884:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004886:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004888:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000488a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000488c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000488e:	10200073          	sret
	...

000000008000489e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000489e:	1141                	addi	sp,sp,-16
    800048a0:	e422                	sd	s0,8(sp)
    800048a2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800048a4:	0c0007b7          	lui	a5,0xc000
    800048a8:	4705                	li	a4,1
    800048aa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800048ac:	0c0007b7          	lui	a5,0xc000
    800048b0:	c3d8                	sw	a4,4(a5)
}
    800048b2:	6422                	ld	s0,8(sp)
    800048b4:	0141                	addi	sp,sp,16
    800048b6:	8082                	ret

00000000800048b8 <plicinithart>:

void
plicinithart(void)
{
    800048b8:	1141                	addi	sp,sp,-16
    800048ba:	e406                	sd	ra,8(sp)
    800048bc:	e022                	sd	s0,0(sp)
    800048be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048c0:	c98fc0ef          	jal	80000d58 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800048c4:	0085171b          	slliw	a4,a0,0x8
    800048c8:	0c0027b7          	lui	a5,0xc002
    800048cc:	97ba                	add	a5,a5,a4
    800048ce:	40200713          	li	a4,1026
    800048d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800048d6:	00d5151b          	slliw	a0,a0,0xd
    800048da:	0c2017b7          	lui	a5,0xc201
    800048de:	97aa                	add	a5,a5,a0
    800048e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800048e4:	60a2                	ld	ra,8(sp)
    800048e6:	6402                	ld	s0,0(sp)
    800048e8:	0141                	addi	sp,sp,16
    800048ea:	8082                	ret

00000000800048ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800048ec:	1141                	addi	sp,sp,-16
    800048ee:	e406                	sd	ra,8(sp)
    800048f0:	e022                	sd	s0,0(sp)
    800048f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048f4:	c64fc0ef          	jal	80000d58 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800048f8:	00d5151b          	slliw	a0,a0,0xd
    800048fc:	0c2017b7          	lui	a5,0xc201
    80004900:	97aa                	add	a5,a5,a0
  return irq;
}
    80004902:	43c8                	lw	a0,4(a5)
    80004904:	60a2                	ld	ra,8(sp)
    80004906:	6402                	ld	s0,0(sp)
    80004908:	0141                	addi	sp,sp,16
    8000490a:	8082                	ret

000000008000490c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000490c:	1101                	addi	sp,sp,-32
    8000490e:	ec06                	sd	ra,24(sp)
    80004910:	e822                	sd	s0,16(sp)
    80004912:	e426                	sd	s1,8(sp)
    80004914:	1000                	addi	s0,sp,32
    80004916:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004918:	c40fc0ef          	jal	80000d58 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000491c:	00d5151b          	slliw	a0,a0,0xd
    80004920:	0c2017b7          	lui	a5,0xc201
    80004924:	97aa                	add	a5,a5,a0
    80004926:	c3c4                	sw	s1,4(a5)
}
    80004928:	60e2                	ld	ra,24(sp)
    8000492a:	6442                	ld	s0,16(sp)
    8000492c:	64a2                	ld	s1,8(sp)
    8000492e:	6105                	addi	sp,sp,32
    80004930:	8082                	ret

0000000080004932 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004932:	1141                	addi	sp,sp,-16
    80004934:	e406                	sd	ra,8(sp)
    80004936:	e022                	sd	s0,0(sp)
    80004938:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000493a:	479d                	li	a5,7
    8000493c:	04a7ca63          	blt	a5,a0,80004990 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004940:	00017797          	auipc	a5,0x17
    80004944:	d3078793          	addi	a5,a5,-720 # 8001b670 <disk>
    80004948:	97aa                	add	a5,a5,a0
    8000494a:	0187c783          	lbu	a5,24(a5)
    8000494e:	e7b9                	bnez	a5,8000499c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004950:	00451693          	slli	a3,a0,0x4
    80004954:	00017797          	auipc	a5,0x17
    80004958:	d1c78793          	addi	a5,a5,-740 # 8001b670 <disk>
    8000495c:	6398                	ld	a4,0(a5)
    8000495e:	9736                	add	a4,a4,a3
    80004960:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004964:	6398                	ld	a4,0(a5)
    80004966:	9736                	add	a4,a4,a3
    80004968:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000496c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004970:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004974:	97aa                	add	a5,a5,a0
    80004976:	4705                	li	a4,1
    80004978:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000497c:	00017517          	auipc	a0,0x17
    80004980:	d0c50513          	addi	a0,a0,-756 # 8001b688 <disk+0x18>
    80004984:	a4dfc0ef          	jal	800013d0 <wakeup>
}
    80004988:	60a2                	ld	ra,8(sp)
    8000498a:	6402                	ld	s0,0(sp)
    8000498c:	0141                	addi	sp,sp,16
    8000498e:	8082                	ret
    panic("free_desc 1");
    80004990:	00003517          	auipc	a0,0x3
    80004994:	ce850513          	addi	a0,a0,-792 # 80007678 <etext+0x678>
    80004998:	487000ef          	jal	8000561e <panic>
    panic("free_desc 2");
    8000499c:	00003517          	auipc	a0,0x3
    800049a0:	cec50513          	addi	a0,a0,-788 # 80007688 <etext+0x688>
    800049a4:	47b000ef          	jal	8000561e <panic>

00000000800049a8 <virtio_disk_init>:
{
    800049a8:	1101                	addi	sp,sp,-32
    800049aa:	ec06                	sd	ra,24(sp)
    800049ac:	e822                	sd	s0,16(sp)
    800049ae:	e426                	sd	s1,8(sp)
    800049b0:	e04a                	sd	s2,0(sp)
    800049b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800049b4:	00003597          	auipc	a1,0x3
    800049b8:	ce458593          	addi	a1,a1,-796 # 80007698 <etext+0x698>
    800049bc:	00017517          	auipc	a0,0x17
    800049c0:	ddc50513          	addi	a0,a0,-548 # 8001b798 <disk+0x128>
    800049c4:	697000ef          	jal	8000585a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049c8:	100017b7          	lui	a5,0x10001
    800049cc:	4398                	lw	a4,0(a5)
    800049ce:	2701                	sext.w	a4,a4
    800049d0:	747277b7          	lui	a5,0x74727
    800049d4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800049d8:	18f71063          	bne	a4,a5,80004b58 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049dc:	100017b7          	lui	a5,0x10001
    800049e0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800049e2:	439c                	lw	a5,0(a5)
    800049e4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049e6:	4709                	li	a4,2
    800049e8:	16e79863          	bne	a5,a4,80004b58 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049ec:	100017b7          	lui	a5,0x10001
    800049f0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800049f2:	439c                	lw	a5,0(a5)
    800049f4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049f6:	16e79163          	bne	a5,a4,80004b58 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800049fa:	100017b7          	lui	a5,0x10001
    800049fe:	47d8                	lw	a4,12(a5)
    80004a00:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a02:	554d47b7          	lui	a5,0x554d4
    80004a06:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a0a:	14f71763          	bne	a4,a5,80004b58 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a0e:	100017b7          	lui	a5,0x10001
    80004a12:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a16:	4705                	li	a4,1
    80004a18:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a1a:	470d                	li	a4,3
    80004a1c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a1e:	10001737          	lui	a4,0x10001
    80004a22:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a24:	c7ffe737          	lui	a4,0xc7ffe
    80004a28:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdaed7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a2c:	8ef9                	and	a3,a3,a4
    80004a2e:	10001737          	lui	a4,0x10001
    80004a32:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a34:	472d                	li	a4,11
    80004a36:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a38:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a3c:	439c                	lw	a5,0(a5)
    80004a3e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a42:	8ba1                	andi	a5,a5,8
    80004a44:	12078063          	beqz	a5,80004b64 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a48:	100017b7          	lui	a5,0x10001
    80004a4c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a50:	100017b7          	lui	a5,0x10001
    80004a54:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004a58:	439c                	lw	a5,0(a5)
    80004a5a:	2781                	sext.w	a5,a5
    80004a5c:	10079a63          	bnez	a5,80004b70 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004a60:	100017b7          	lui	a5,0x10001
    80004a64:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004a68:	439c                	lw	a5,0(a5)
    80004a6a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004a6c:	10078863          	beqz	a5,80004b7c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a70:	471d                	li	a4,7
    80004a72:	10f77b63          	bgeu	a4,a5,80004b88 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a76:	e80fb0ef          	jal	800000f6 <kalloc>
    80004a7a:	00017497          	auipc	s1,0x17
    80004a7e:	bf648493          	addi	s1,s1,-1034 # 8001b670 <disk>
    80004a82:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a84:	e72fb0ef          	jal	800000f6 <kalloc>
    80004a88:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a8a:	e6cfb0ef          	jal	800000f6 <kalloc>
    80004a8e:	87aa                	mv	a5,a0
    80004a90:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004a92:	6088                	ld	a0,0(s1)
    80004a94:	10050063          	beqz	a0,80004b94 <virtio_disk_init+0x1ec>
    80004a98:	00017717          	auipc	a4,0x17
    80004a9c:	be073703          	ld	a4,-1056(a4) # 8001b678 <disk+0x8>
    80004aa0:	0e070a63          	beqz	a4,80004b94 <virtio_disk_init+0x1ec>
    80004aa4:	0e078863          	beqz	a5,80004b94 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004aa8:	6605                	lui	a2,0x1
    80004aaa:	4581                	li	a1,0
    80004aac:	e88fb0ef          	jal	80000134 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004ab0:	00017497          	auipc	s1,0x17
    80004ab4:	bc048493          	addi	s1,s1,-1088 # 8001b670 <disk>
    80004ab8:	6605                	lui	a2,0x1
    80004aba:	4581                	li	a1,0
    80004abc:	6488                	ld	a0,8(s1)
    80004abe:	e76fb0ef          	jal	80000134 <memset>
  memset(disk.used, 0, PGSIZE);
    80004ac2:	6605                	lui	a2,0x1
    80004ac4:	4581                	li	a1,0
    80004ac6:	6888                	ld	a0,16(s1)
    80004ac8:	e6cfb0ef          	jal	80000134 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004acc:	100017b7          	lui	a5,0x10001
    80004ad0:	4721                	li	a4,8
    80004ad2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004ad4:	4098                	lw	a4,0(s1)
    80004ad6:	100017b7          	lui	a5,0x10001
    80004ada:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004ade:	40d8                	lw	a4,4(s1)
    80004ae0:	100017b7          	lui	a5,0x10001
    80004ae4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004ae8:	649c                	ld	a5,8(s1)
    80004aea:	0007869b          	sext.w	a3,a5
    80004aee:	10001737          	lui	a4,0x10001
    80004af2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004af6:	9781                	srai	a5,a5,0x20
    80004af8:	10001737          	lui	a4,0x10001
    80004afc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b00:	689c                	ld	a5,16(s1)
    80004b02:	0007869b          	sext.w	a3,a5
    80004b06:	10001737          	lui	a4,0x10001
    80004b0a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b0e:	9781                	srai	a5,a5,0x20
    80004b10:	10001737          	lui	a4,0x10001
    80004b14:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004b18:	10001737          	lui	a4,0x10001
    80004b1c:	4785                	li	a5,1
    80004b1e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b20:	00f48c23          	sb	a5,24(s1)
    80004b24:	00f48ca3          	sb	a5,25(s1)
    80004b28:	00f48d23          	sb	a5,26(s1)
    80004b2c:	00f48da3          	sb	a5,27(s1)
    80004b30:	00f48e23          	sb	a5,28(s1)
    80004b34:	00f48ea3          	sb	a5,29(s1)
    80004b38:	00f48f23          	sb	a5,30(s1)
    80004b3c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b40:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b44:	100017b7          	lui	a5,0x10001
    80004b48:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004b4c:	60e2                	ld	ra,24(sp)
    80004b4e:	6442                	ld	s0,16(sp)
    80004b50:	64a2                	ld	s1,8(sp)
    80004b52:	6902                	ld	s2,0(sp)
    80004b54:	6105                	addi	sp,sp,32
    80004b56:	8082                	ret
    panic("could not find virtio disk");
    80004b58:	00003517          	auipc	a0,0x3
    80004b5c:	b5050513          	addi	a0,a0,-1200 # 800076a8 <etext+0x6a8>
    80004b60:	2bf000ef          	jal	8000561e <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b64:	00003517          	auipc	a0,0x3
    80004b68:	b6450513          	addi	a0,a0,-1180 # 800076c8 <etext+0x6c8>
    80004b6c:	2b3000ef          	jal	8000561e <panic>
    panic("virtio disk should not be ready");
    80004b70:	00003517          	auipc	a0,0x3
    80004b74:	b7850513          	addi	a0,a0,-1160 # 800076e8 <etext+0x6e8>
    80004b78:	2a7000ef          	jal	8000561e <panic>
    panic("virtio disk has no queue 0");
    80004b7c:	00003517          	auipc	a0,0x3
    80004b80:	b8c50513          	addi	a0,a0,-1140 # 80007708 <etext+0x708>
    80004b84:	29b000ef          	jal	8000561e <panic>
    panic("virtio disk max queue too short");
    80004b88:	00003517          	auipc	a0,0x3
    80004b8c:	ba050513          	addi	a0,a0,-1120 # 80007728 <etext+0x728>
    80004b90:	28f000ef          	jal	8000561e <panic>
    panic("virtio disk kalloc");
    80004b94:	00003517          	auipc	a0,0x3
    80004b98:	bb450513          	addi	a0,a0,-1100 # 80007748 <etext+0x748>
    80004b9c:	283000ef          	jal	8000561e <panic>

0000000080004ba0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ba0:	7159                	addi	sp,sp,-112
    80004ba2:	f486                	sd	ra,104(sp)
    80004ba4:	f0a2                	sd	s0,96(sp)
    80004ba6:	eca6                	sd	s1,88(sp)
    80004ba8:	e8ca                	sd	s2,80(sp)
    80004baa:	e4ce                	sd	s3,72(sp)
    80004bac:	e0d2                	sd	s4,64(sp)
    80004bae:	fc56                	sd	s5,56(sp)
    80004bb0:	f85a                	sd	s6,48(sp)
    80004bb2:	f45e                	sd	s7,40(sp)
    80004bb4:	f062                	sd	s8,32(sp)
    80004bb6:	ec66                	sd	s9,24(sp)
    80004bb8:	1880                	addi	s0,sp,112
    80004bba:	8a2a                	mv	s4,a0
    80004bbc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004bbe:	00c52c83          	lw	s9,12(a0)
    80004bc2:	001c9c9b          	slliw	s9,s9,0x1
    80004bc6:	1c82                	slli	s9,s9,0x20
    80004bc8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004bcc:	00017517          	auipc	a0,0x17
    80004bd0:	bcc50513          	addi	a0,a0,-1076 # 8001b798 <disk+0x128>
    80004bd4:	507000ef          	jal	800058da <acquire>
  for(int i = 0; i < 3; i++){
    80004bd8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004bda:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004bdc:	00017b17          	auipc	s6,0x17
    80004be0:	a94b0b13          	addi	s6,s6,-1388 # 8001b670 <disk>
  for(int i = 0; i < 3; i++){
    80004be4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004be6:	00017c17          	auipc	s8,0x17
    80004bea:	bb2c0c13          	addi	s8,s8,-1102 # 8001b798 <disk+0x128>
    80004bee:	a8b9                	j	80004c4c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004bf0:	00fb0733          	add	a4,s6,a5
    80004bf4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004bf8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004bfa:	0207c563          	bltz	a5,80004c24 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004bfe:	2905                	addiw	s2,s2,1
    80004c00:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c02:	05590963          	beq	s2,s5,80004c54 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004c06:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c08:	00017717          	auipc	a4,0x17
    80004c0c:	a6870713          	addi	a4,a4,-1432 # 8001b670 <disk>
    80004c10:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004c12:	01874683          	lbu	a3,24(a4)
    80004c16:	fee9                	bnez	a3,80004bf0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004c18:	2785                	addiw	a5,a5,1
    80004c1a:	0705                	addi	a4,a4,1
    80004c1c:	fe979be3          	bne	a5,s1,80004c12 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004c20:	57fd                	li	a5,-1
    80004c22:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004c24:	01205d63          	blez	s2,80004c3e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c28:	f9042503          	lw	a0,-112(s0)
    80004c2c:	d07ff0ef          	jal	80004932 <free_desc>
      for(int j = 0; j < i; j++)
    80004c30:	4785                	li	a5,1
    80004c32:	0127d663          	bge	a5,s2,80004c3e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c36:	f9442503          	lw	a0,-108(s0)
    80004c3a:	cf9ff0ef          	jal	80004932 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c3e:	85e2                	mv	a1,s8
    80004c40:	00017517          	auipc	a0,0x17
    80004c44:	a4850513          	addi	a0,a0,-1464 # 8001b688 <disk+0x18>
    80004c48:	f3cfc0ef          	jal	80001384 <sleep>
  for(int i = 0; i < 3; i++){
    80004c4c:	f9040613          	addi	a2,s0,-112
    80004c50:	894e                	mv	s2,s3
    80004c52:	bf55                	j	80004c06 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c54:	f9042503          	lw	a0,-112(s0)
    80004c58:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c5c:	00017797          	auipc	a5,0x17
    80004c60:	a1478793          	addi	a5,a5,-1516 # 8001b670 <disk>
    80004c64:	00a50713          	addi	a4,a0,10
    80004c68:	0712                	slli	a4,a4,0x4
    80004c6a:	973e                	add	a4,a4,a5
    80004c6c:	01703633          	snez	a2,s7
    80004c70:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c72:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c76:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c7a:	6398                	ld	a4,0(a5)
    80004c7c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c7e:	0a868613          	addi	a2,a3,168
    80004c82:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c84:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c86:	6390                	ld	a2,0(a5)
    80004c88:	00d605b3          	add	a1,a2,a3
    80004c8c:	4741                	li	a4,16
    80004c8e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004c90:	4805                	li	a6,1
    80004c92:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004c96:	f9442703          	lw	a4,-108(s0)
    80004c9a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004c9e:	0712                	slli	a4,a4,0x4
    80004ca0:	963a                	add	a2,a2,a4
    80004ca2:	058a0593          	addi	a1,s4,88
    80004ca6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004ca8:	0007b883          	ld	a7,0(a5)
    80004cac:	9746                	add	a4,a4,a7
    80004cae:	40000613          	li	a2,1024
    80004cb2:	c710                	sw	a2,8(a4)
  if(write)
    80004cb4:	001bb613          	seqz	a2,s7
    80004cb8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004cbc:	00166613          	ori	a2,a2,1
    80004cc0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004cc4:	f9842583          	lw	a1,-104(s0)
    80004cc8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004ccc:	00250613          	addi	a2,a0,2
    80004cd0:	0612                	slli	a2,a2,0x4
    80004cd2:	963e                	add	a2,a2,a5
    80004cd4:	577d                	li	a4,-1
    80004cd6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004cda:	0592                	slli	a1,a1,0x4
    80004cdc:	98ae                	add	a7,a7,a1
    80004cde:	03068713          	addi	a4,a3,48
    80004ce2:	973e                	add	a4,a4,a5
    80004ce4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004ce8:	6398                	ld	a4,0(a5)
    80004cea:	972e                	add	a4,a4,a1
    80004cec:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004cf0:	4689                	li	a3,2
    80004cf2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004cf6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004cfa:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004cfe:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d02:	6794                	ld	a3,8(a5)
    80004d04:	0026d703          	lhu	a4,2(a3)
    80004d08:	8b1d                	andi	a4,a4,7
    80004d0a:	0706                	slli	a4,a4,0x1
    80004d0c:	96ba                	add	a3,a3,a4
    80004d0e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d12:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d16:	6798                	ld	a4,8(a5)
    80004d18:	00275783          	lhu	a5,2(a4)
    80004d1c:	2785                	addiw	a5,a5,1
    80004d1e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d22:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d26:	100017b7          	lui	a5,0x10001
    80004d2a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d2e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004d32:	00017917          	auipc	s2,0x17
    80004d36:	a6690913          	addi	s2,s2,-1434 # 8001b798 <disk+0x128>
  while(b->disk == 1) {
    80004d3a:	4485                	li	s1,1
    80004d3c:	01079a63          	bne	a5,a6,80004d50 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d40:	85ca                	mv	a1,s2
    80004d42:	8552                	mv	a0,s4
    80004d44:	e40fc0ef          	jal	80001384 <sleep>
  while(b->disk == 1) {
    80004d48:	004a2783          	lw	a5,4(s4)
    80004d4c:	fe978ae3          	beq	a5,s1,80004d40 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d50:	f9042903          	lw	s2,-112(s0)
    80004d54:	00290713          	addi	a4,s2,2
    80004d58:	0712                	slli	a4,a4,0x4
    80004d5a:	00017797          	auipc	a5,0x17
    80004d5e:	91678793          	addi	a5,a5,-1770 # 8001b670 <disk>
    80004d62:	97ba                	add	a5,a5,a4
    80004d64:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d68:	00017997          	auipc	s3,0x17
    80004d6c:	90898993          	addi	s3,s3,-1784 # 8001b670 <disk>
    80004d70:	00491713          	slli	a4,s2,0x4
    80004d74:	0009b783          	ld	a5,0(s3)
    80004d78:	97ba                	add	a5,a5,a4
    80004d7a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d7e:	854a                	mv	a0,s2
    80004d80:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d84:	bafff0ef          	jal	80004932 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d88:	8885                	andi	s1,s1,1
    80004d8a:	f0fd                	bnez	s1,80004d70 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d8c:	00017517          	auipc	a0,0x17
    80004d90:	a0c50513          	addi	a0,a0,-1524 # 8001b798 <disk+0x128>
    80004d94:	3df000ef          	jal	80005972 <release>
}
    80004d98:	70a6                	ld	ra,104(sp)
    80004d9a:	7406                	ld	s0,96(sp)
    80004d9c:	64e6                	ld	s1,88(sp)
    80004d9e:	6946                	ld	s2,80(sp)
    80004da0:	69a6                	ld	s3,72(sp)
    80004da2:	6a06                	ld	s4,64(sp)
    80004da4:	7ae2                	ld	s5,56(sp)
    80004da6:	7b42                	ld	s6,48(sp)
    80004da8:	7ba2                	ld	s7,40(sp)
    80004daa:	7c02                	ld	s8,32(sp)
    80004dac:	6ce2                	ld	s9,24(sp)
    80004dae:	6165                	addi	sp,sp,112
    80004db0:	8082                	ret

0000000080004db2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004db2:	1101                	addi	sp,sp,-32
    80004db4:	ec06                	sd	ra,24(sp)
    80004db6:	e822                	sd	s0,16(sp)
    80004db8:	e426                	sd	s1,8(sp)
    80004dba:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004dbc:	00017497          	auipc	s1,0x17
    80004dc0:	8b448493          	addi	s1,s1,-1868 # 8001b670 <disk>
    80004dc4:	00017517          	auipc	a0,0x17
    80004dc8:	9d450513          	addi	a0,a0,-1580 # 8001b798 <disk+0x128>
    80004dcc:	30f000ef          	jal	800058da <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004dd0:	100017b7          	lui	a5,0x10001
    80004dd4:	53b8                	lw	a4,96(a5)
    80004dd6:	8b0d                	andi	a4,a4,3
    80004dd8:	100017b7          	lui	a5,0x10001
    80004ddc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004dde:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004de2:	689c                	ld	a5,16(s1)
    80004de4:	0204d703          	lhu	a4,32(s1)
    80004de8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004dec:	04f70663          	beq	a4,a5,80004e38 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004df0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004df4:	6898                	ld	a4,16(s1)
    80004df6:	0204d783          	lhu	a5,32(s1)
    80004dfa:	8b9d                	andi	a5,a5,7
    80004dfc:	078e                	slli	a5,a5,0x3
    80004dfe:	97ba                	add	a5,a5,a4
    80004e00:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e02:	00278713          	addi	a4,a5,2
    80004e06:	0712                	slli	a4,a4,0x4
    80004e08:	9726                	add	a4,a4,s1
    80004e0a:	01074703          	lbu	a4,16(a4)
    80004e0e:	e321                	bnez	a4,80004e4e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e10:	0789                	addi	a5,a5,2
    80004e12:	0792                	slli	a5,a5,0x4
    80004e14:	97a6                	add	a5,a5,s1
    80004e16:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e18:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004e1c:	db4fc0ef          	jal	800013d0 <wakeup>

    disk.used_idx += 1;
    80004e20:	0204d783          	lhu	a5,32(s1)
    80004e24:	2785                	addiw	a5,a5,1
    80004e26:	17c2                	slli	a5,a5,0x30
    80004e28:	93c1                	srli	a5,a5,0x30
    80004e2a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e2e:	6898                	ld	a4,16(s1)
    80004e30:	00275703          	lhu	a4,2(a4)
    80004e34:	faf71ee3          	bne	a4,a5,80004df0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e38:	00017517          	auipc	a0,0x17
    80004e3c:	96050513          	addi	a0,a0,-1696 # 8001b798 <disk+0x128>
    80004e40:	333000ef          	jal	80005972 <release>
}
    80004e44:	60e2                	ld	ra,24(sp)
    80004e46:	6442                	ld	s0,16(sp)
    80004e48:	64a2                	ld	s1,8(sp)
    80004e4a:	6105                	addi	sp,sp,32
    80004e4c:	8082                	ret
      panic("virtio_disk_intr status");
    80004e4e:	00003517          	auipc	a0,0x3
    80004e52:	91250513          	addi	a0,a0,-1774 # 80007760 <etext+0x760>
    80004e56:	7c8000ef          	jal	8000561e <panic>

0000000080004e5a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e5a:	1141                	addi	sp,sp,-16
    80004e5c:	e422                	sd	s0,8(sp)
    80004e5e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e60:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e64:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e68:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e6c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e70:	577d                	li	a4,-1
    80004e72:	177e                	slli	a4,a4,0x3f
    80004e74:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e76:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e7a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e7e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e82:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e86:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e8a:	000f4737          	lui	a4,0xf4
    80004e8e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e92:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e94:	14d79073          	csrw	stimecmp,a5
}
    80004e98:	6422                	ld	s0,8(sp)
    80004e9a:	0141                	addi	sp,sp,16
    80004e9c:	8082                	ret

0000000080004e9e <start>:
{
    80004e9e:	1141                	addi	sp,sp,-16
    80004ea0:	e406                	sd	ra,8(sp)
    80004ea2:	e022                	sd	s0,0(sp)
    80004ea4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004ea6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004eaa:	7779                	lui	a4,0xffffe
    80004eac:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdaf77>
    80004eb0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004eb2:	6705                	lui	a4,0x1
    80004eb4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004eb8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004eba:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ebe:	ffffb797          	auipc	a5,0xffffb
    80004ec2:	41078793          	addi	a5,a5,1040 # 800002ce <main>
    80004ec6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004eca:	4781                	li	a5,0
    80004ecc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004ed0:	67c1                	lui	a5,0x10
    80004ed2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004ed4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004ed8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004edc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004ee0:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004ee4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004ee8:	57fd                	li	a5,-1
    80004eea:	83a9                	srli	a5,a5,0xa
    80004eec:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004ef0:	47bd                	li	a5,15
    80004ef2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004ef6:	f65ff0ef          	jal	80004e5a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004efa:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004efe:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004f00:	823e                	mv	tp,a5
  asm volatile("mret");
    80004f02:	30200073          	mret
}
    80004f06:	60a2                	ld	ra,8(sp)
    80004f08:	6402                	ld	s0,0(sp)
    80004f0a:	0141                	addi	sp,sp,16
    80004f0c:	8082                	ret

0000000080004f0e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004f0e:	7119                	addi	sp,sp,-128
    80004f10:	fc86                	sd	ra,120(sp)
    80004f12:	f8a2                	sd	s0,112(sp)
    80004f14:	f4a6                	sd	s1,104(sp)
    80004f16:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80004f18:	06c05a63          	blez	a2,80004f8c <consolewrite+0x7e>
    80004f1c:	f0ca                	sd	s2,96(sp)
    80004f1e:	ecce                	sd	s3,88(sp)
    80004f20:	e8d2                	sd	s4,80(sp)
    80004f22:	e4d6                	sd	s5,72(sp)
    80004f24:	e0da                	sd	s6,64(sp)
    80004f26:	fc5e                	sd	s7,56(sp)
    80004f28:	f862                	sd	s8,48(sp)
    80004f2a:	f466                	sd	s9,40(sp)
    80004f2c:	8aaa                	mv	s5,a0
    80004f2e:	8b2e                	mv	s6,a1
    80004f30:	8a32                	mv	s4,a2
  int i = 0;
    80004f32:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80004f34:	02000c13          	li	s8,32
    80004f38:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004f3c:	5bfd                	li	s7,-1
    80004f3e:	a035                	j	80004f6a <consolewrite+0x5c>
    if(nn > n - i)
    80004f40:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004f44:	86ce                	mv	a3,s3
    80004f46:	01648633          	add	a2,s1,s6
    80004f4a:	85d6                	mv	a1,s5
    80004f4c:	f8040513          	addi	a0,s0,-128
    80004f50:	fdafc0ef          	jal	8000172a <either_copyin>
    80004f54:	03750e63          	beq	a0,s7,80004f90 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    80004f58:	85ce                	mv	a1,s3
    80004f5a:	f8040513          	addi	a0,s0,-128
    80004f5e:	778000ef          	jal	800056d6 <uartwrite>
    i += nn;
    80004f62:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80004f66:	0144da63          	bge	s1,s4,80004f7a <consolewrite+0x6c>
    if(nn > n - i)
    80004f6a:	409a093b          	subw	s2,s4,s1
    80004f6e:	0009079b          	sext.w	a5,s2
    80004f72:	fcfc57e3          	bge	s8,a5,80004f40 <consolewrite+0x32>
    80004f76:	8966                	mv	s2,s9
    80004f78:	b7e1                	j	80004f40 <consolewrite+0x32>
    80004f7a:	7906                	ld	s2,96(sp)
    80004f7c:	69e6                	ld	s3,88(sp)
    80004f7e:	6a46                	ld	s4,80(sp)
    80004f80:	6aa6                	ld	s5,72(sp)
    80004f82:	6b06                	ld	s6,64(sp)
    80004f84:	7be2                	ld	s7,56(sp)
    80004f86:	7c42                	ld	s8,48(sp)
    80004f88:	7ca2                	ld	s9,40(sp)
    80004f8a:	a819                	j	80004fa0 <consolewrite+0x92>
  int i = 0;
    80004f8c:	4481                	li	s1,0
    80004f8e:	a809                	j	80004fa0 <consolewrite+0x92>
    80004f90:	7906                	ld	s2,96(sp)
    80004f92:	69e6                	ld	s3,88(sp)
    80004f94:	6a46                	ld	s4,80(sp)
    80004f96:	6aa6                	ld	s5,72(sp)
    80004f98:	6b06                	ld	s6,64(sp)
    80004f9a:	7be2                	ld	s7,56(sp)
    80004f9c:	7c42                	ld	s8,48(sp)
    80004f9e:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80004fa0:	8526                	mv	a0,s1
    80004fa2:	70e6                	ld	ra,120(sp)
    80004fa4:	7446                	ld	s0,112(sp)
    80004fa6:	74a6                	ld	s1,104(sp)
    80004fa8:	6109                	addi	sp,sp,128
    80004faa:	8082                	ret

0000000080004fac <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004fac:	711d                	addi	sp,sp,-96
    80004fae:	ec86                	sd	ra,88(sp)
    80004fb0:	e8a2                	sd	s0,80(sp)
    80004fb2:	e4a6                	sd	s1,72(sp)
    80004fb4:	e0ca                	sd	s2,64(sp)
    80004fb6:	fc4e                	sd	s3,56(sp)
    80004fb8:	f852                	sd	s4,48(sp)
    80004fba:	f456                	sd	s5,40(sp)
    80004fbc:	f05a                	sd	s6,32(sp)
    80004fbe:	1080                	addi	s0,sp,96
    80004fc0:	8aaa                	mv	s5,a0
    80004fc2:	8a2e                	mv	s4,a1
    80004fc4:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004fc6:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004fca:	0001e517          	auipc	a0,0x1e
    80004fce:	7e650513          	addi	a0,a0,2022 # 800237b0 <cons>
    80004fd2:	109000ef          	jal	800058da <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004fd6:	0001e497          	auipc	s1,0x1e
    80004fda:	7da48493          	addi	s1,s1,2010 # 800237b0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004fde:	0001f917          	auipc	s2,0x1f
    80004fe2:	86a90913          	addi	s2,s2,-1942 # 80023848 <cons+0x98>
  while(n > 0){
    80004fe6:	0b305d63          	blez	s3,800050a0 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004fea:	0984a783          	lw	a5,152(s1)
    80004fee:	09c4a703          	lw	a4,156(s1)
    80004ff2:	0af71263          	bne	a4,a5,80005096 <consoleread+0xea>
      if(killed(myproc())){
    80004ff6:	d8ffb0ef          	jal	80000d84 <myproc>
    80004ffa:	dc2fc0ef          	jal	800015bc <killed>
    80004ffe:	e12d                	bnez	a0,80005060 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80005000:	85a6                	mv	a1,s1
    80005002:	854a                	mv	a0,s2
    80005004:	b80fc0ef          	jal	80001384 <sleep>
    while(cons.r == cons.w){
    80005008:	0984a783          	lw	a5,152(s1)
    8000500c:	09c4a703          	lw	a4,156(s1)
    80005010:	fef703e3          	beq	a4,a5,80004ff6 <consoleread+0x4a>
    80005014:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005016:	0001e717          	auipc	a4,0x1e
    8000501a:	79a70713          	addi	a4,a4,1946 # 800237b0 <cons>
    8000501e:	0017869b          	addiw	a3,a5,1
    80005022:	08d72c23          	sw	a3,152(a4)
    80005026:	07f7f693          	andi	a3,a5,127
    8000502a:	9736                	add	a4,a4,a3
    8000502c:	01874703          	lbu	a4,24(a4)
    80005030:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005034:	4691                	li	a3,4
    80005036:	04db8663          	beq	s7,a3,80005082 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000503a:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000503e:	4685                	li	a3,1
    80005040:	faf40613          	addi	a2,s0,-81
    80005044:	85d2                	mv	a1,s4
    80005046:	8556                	mv	a0,s5
    80005048:	e98fc0ef          	jal	800016e0 <either_copyout>
    8000504c:	57fd                	li	a5,-1
    8000504e:	04f50863          	beq	a0,a5,8000509e <consoleread+0xf2>
      break;

    dst++;
    80005052:	0a05                	addi	s4,s4,1
    --n;
    80005054:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005056:	47a9                	li	a5,10
    80005058:	04fb8d63          	beq	s7,a5,800050b2 <consoleread+0x106>
    8000505c:	6be2                	ld	s7,24(sp)
    8000505e:	b761                	j	80004fe6 <consoleread+0x3a>
        release(&cons.lock);
    80005060:	0001e517          	auipc	a0,0x1e
    80005064:	75050513          	addi	a0,a0,1872 # 800237b0 <cons>
    80005068:	10b000ef          	jal	80005972 <release>
        return -1;
    8000506c:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000506e:	60e6                	ld	ra,88(sp)
    80005070:	6446                	ld	s0,80(sp)
    80005072:	64a6                	ld	s1,72(sp)
    80005074:	6906                	ld	s2,64(sp)
    80005076:	79e2                	ld	s3,56(sp)
    80005078:	7a42                	ld	s4,48(sp)
    8000507a:	7aa2                	ld	s5,40(sp)
    8000507c:	7b02                	ld	s6,32(sp)
    8000507e:	6125                	addi	sp,sp,96
    80005080:	8082                	ret
      if(n < target){
    80005082:	0009871b          	sext.w	a4,s3
    80005086:	01677a63          	bgeu	a4,s6,8000509a <consoleread+0xee>
        cons.r--;
    8000508a:	0001e717          	auipc	a4,0x1e
    8000508e:	7af72f23          	sw	a5,1982(a4) # 80023848 <cons+0x98>
    80005092:	6be2                	ld	s7,24(sp)
    80005094:	a031                	j	800050a0 <consoleread+0xf4>
    80005096:	ec5e                	sd	s7,24(sp)
    80005098:	bfbd                	j	80005016 <consoleread+0x6a>
    8000509a:	6be2                	ld	s7,24(sp)
    8000509c:	a011                	j	800050a0 <consoleread+0xf4>
    8000509e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800050a0:	0001e517          	auipc	a0,0x1e
    800050a4:	71050513          	addi	a0,a0,1808 # 800237b0 <cons>
    800050a8:	0cb000ef          	jal	80005972 <release>
  return target - n;
    800050ac:	413b053b          	subw	a0,s6,s3
    800050b0:	bf7d                	j	8000506e <consoleread+0xc2>
    800050b2:	6be2                	ld	s7,24(sp)
    800050b4:	b7f5                	j	800050a0 <consoleread+0xf4>

00000000800050b6 <consputc>:
{
    800050b6:	1141                	addi	sp,sp,-16
    800050b8:	e406                	sd	ra,8(sp)
    800050ba:	e022                	sd	s0,0(sp)
    800050bc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800050be:	10000793          	li	a5,256
    800050c2:	00f50863          	beq	a0,a5,800050d2 <consputc+0x1c>
    uartputc_sync(c);
    800050c6:	6a4000ef          	jal	8000576a <uartputc_sync>
}
    800050ca:	60a2                	ld	ra,8(sp)
    800050cc:	6402                	ld	s0,0(sp)
    800050ce:	0141                	addi	sp,sp,16
    800050d0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800050d2:	4521                	li	a0,8
    800050d4:	696000ef          	jal	8000576a <uartputc_sync>
    800050d8:	02000513          	li	a0,32
    800050dc:	68e000ef          	jal	8000576a <uartputc_sync>
    800050e0:	4521                	li	a0,8
    800050e2:	688000ef          	jal	8000576a <uartputc_sync>
    800050e6:	b7d5                	j	800050ca <consputc+0x14>

00000000800050e8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050e8:	1101                	addi	sp,sp,-32
    800050ea:	ec06                	sd	ra,24(sp)
    800050ec:	e822                	sd	s0,16(sp)
    800050ee:	e426                	sd	s1,8(sp)
    800050f0:	1000                	addi	s0,sp,32
    800050f2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800050f4:	0001e517          	auipc	a0,0x1e
    800050f8:	6bc50513          	addi	a0,a0,1724 # 800237b0 <cons>
    800050fc:	7de000ef          	jal	800058da <acquire>

  switch(c){
    80005100:	47d5                	li	a5,21
    80005102:	08f48f63          	beq	s1,a5,800051a0 <consoleintr+0xb8>
    80005106:	0297c563          	blt	a5,s1,80005130 <consoleintr+0x48>
    8000510a:	47a1                	li	a5,8
    8000510c:	0ef48463          	beq	s1,a5,800051f4 <consoleintr+0x10c>
    80005110:	47c1                	li	a5,16
    80005112:	10f49563          	bne	s1,a5,8000521c <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    80005116:	e5efc0ef          	jal	80001774 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000511a:	0001e517          	auipc	a0,0x1e
    8000511e:	69650513          	addi	a0,a0,1686 # 800237b0 <cons>
    80005122:	051000ef          	jal	80005972 <release>
}
    80005126:	60e2                	ld	ra,24(sp)
    80005128:	6442                	ld	s0,16(sp)
    8000512a:	64a2                	ld	s1,8(sp)
    8000512c:	6105                	addi	sp,sp,32
    8000512e:	8082                	ret
  switch(c){
    80005130:	07f00793          	li	a5,127
    80005134:	0cf48063          	beq	s1,a5,800051f4 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005138:	0001e717          	auipc	a4,0x1e
    8000513c:	67870713          	addi	a4,a4,1656 # 800237b0 <cons>
    80005140:	0a072783          	lw	a5,160(a4)
    80005144:	09872703          	lw	a4,152(a4)
    80005148:	9f99                	subw	a5,a5,a4
    8000514a:	07f00713          	li	a4,127
    8000514e:	fcf766e3          	bltu	a4,a5,8000511a <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005152:	47b5                	li	a5,13
    80005154:	0cf48763          	beq	s1,a5,80005222 <consoleintr+0x13a>
      consputc(c);
    80005158:	8526                	mv	a0,s1
    8000515a:	f5dff0ef          	jal	800050b6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000515e:	0001e797          	auipc	a5,0x1e
    80005162:	65278793          	addi	a5,a5,1618 # 800237b0 <cons>
    80005166:	0a07a683          	lw	a3,160(a5)
    8000516a:	0016871b          	addiw	a4,a3,1
    8000516e:	0007061b          	sext.w	a2,a4
    80005172:	0ae7a023          	sw	a4,160(a5)
    80005176:	07f6f693          	andi	a3,a3,127
    8000517a:	97b6                	add	a5,a5,a3
    8000517c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005180:	47a9                	li	a5,10
    80005182:	0cf48563          	beq	s1,a5,8000524c <consoleintr+0x164>
    80005186:	4791                	li	a5,4
    80005188:	0cf48263          	beq	s1,a5,8000524c <consoleintr+0x164>
    8000518c:	0001e797          	auipc	a5,0x1e
    80005190:	6bc7a783          	lw	a5,1724(a5) # 80023848 <cons+0x98>
    80005194:	9f1d                	subw	a4,a4,a5
    80005196:	08000793          	li	a5,128
    8000519a:	f8f710e3          	bne	a4,a5,8000511a <consoleintr+0x32>
    8000519e:	a07d                	j	8000524c <consoleintr+0x164>
    800051a0:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800051a2:	0001e717          	auipc	a4,0x1e
    800051a6:	60e70713          	addi	a4,a4,1550 # 800237b0 <cons>
    800051aa:	0a072783          	lw	a5,160(a4)
    800051ae:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051b2:	0001e497          	auipc	s1,0x1e
    800051b6:	5fe48493          	addi	s1,s1,1534 # 800237b0 <cons>
    while(cons.e != cons.w &&
    800051ba:	4929                	li	s2,10
    800051bc:	02f70863          	beq	a4,a5,800051ec <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800051c0:	37fd                	addiw	a5,a5,-1
    800051c2:	07f7f713          	andi	a4,a5,127
    800051c6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800051c8:	01874703          	lbu	a4,24(a4)
    800051cc:	03270263          	beq	a4,s2,800051f0 <consoleintr+0x108>
      cons.e--;
    800051d0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800051d4:	10000513          	li	a0,256
    800051d8:	edfff0ef          	jal	800050b6 <consputc>
    while(cons.e != cons.w &&
    800051dc:	0a04a783          	lw	a5,160(s1)
    800051e0:	09c4a703          	lw	a4,156(s1)
    800051e4:	fcf71ee3          	bne	a4,a5,800051c0 <consoleintr+0xd8>
    800051e8:	6902                	ld	s2,0(sp)
    800051ea:	bf05                	j	8000511a <consoleintr+0x32>
    800051ec:	6902                	ld	s2,0(sp)
    800051ee:	b735                	j	8000511a <consoleintr+0x32>
    800051f0:	6902                	ld	s2,0(sp)
    800051f2:	b725                	j	8000511a <consoleintr+0x32>
    if(cons.e != cons.w){
    800051f4:	0001e717          	auipc	a4,0x1e
    800051f8:	5bc70713          	addi	a4,a4,1468 # 800237b0 <cons>
    800051fc:	0a072783          	lw	a5,160(a4)
    80005200:	09c72703          	lw	a4,156(a4)
    80005204:	f0f70be3          	beq	a4,a5,8000511a <consoleintr+0x32>
      cons.e--;
    80005208:	37fd                	addiw	a5,a5,-1
    8000520a:	0001e717          	auipc	a4,0x1e
    8000520e:	64f72323          	sw	a5,1606(a4) # 80023850 <cons+0xa0>
      consputc(BACKSPACE);
    80005212:	10000513          	li	a0,256
    80005216:	ea1ff0ef          	jal	800050b6 <consputc>
    8000521a:	b701                	j	8000511a <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000521c:	ee048fe3          	beqz	s1,8000511a <consoleintr+0x32>
    80005220:	bf21                	j	80005138 <consoleintr+0x50>
      consputc(c);
    80005222:	4529                	li	a0,10
    80005224:	e93ff0ef          	jal	800050b6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005228:	0001e797          	auipc	a5,0x1e
    8000522c:	58878793          	addi	a5,a5,1416 # 800237b0 <cons>
    80005230:	0a07a703          	lw	a4,160(a5)
    80005234:	0017069b          	addiw	a3,a4,1
    80005238:	0006861b          	sext.w	a2,a3
    8000523c:	0ad7a023          	sw	a3,160(a5)
    80005240:	07f77713          	andi	a4,a4,127
    80005244:	97ba                	add	a5,a5,a4
    80005246:	4729                	li	a4,10
    80005248:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000524c:	0001e797          	auipc	a5,0x1e
    80005250:	60c7a023          	sw	a2,1536(a5) # 8002384c <cons+0x9c>
        wakeup(&cons.r);
    80005254:	0001e517          	auipc	a0,0x1e
    80005258:	5f450513          	addi	a0,a0,1524 # 80023848 <cons+0x98>
    8000525c:	974fc0ef          	jal	800013d0 <wakeup>
    80005260:	bd6d                	j	8000511a <consoleintr+0x32>

0000000080005262 <consoleinit>:

void
consoleinit(void)
{
    80005262:	1141                	addi	sp,sp,-16
    80005264:	e406                	sd	ra,8(sp)
    80005266:	e022                	sd	s0,0(sp)
    80005268:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000526a:	00002597          	auipc	a1,0x2
    8000526e:	50e58593          	addi	a1,a1,1294 # 80007778 <etext+0x778>
    80005272:	0001e517          	auipc	a0,0x1e
    80005276:	53e50513          	addi	a0,a0,1342 # 800237b0 <cons>
    8000527a:	5e0000ef          	jal	8000585a <initlock>

  uartinit();
    8000527e:	400000ef          	jal	8000567e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005282:	00015797          	auipc	a5,0x15
    80005286:	39678793          	addi	a5,a5,918 # 8001a618 <devsw>
    8000528a:	00000717          	auipc	a4,0x0
    8000528e:	d2270713          	addi	a4,a4,-734 # 80004fac <consoleread>
    80005292:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005294:	00000717          	auipc	a4,0x0
    80005298:	c7a70713          	addi	a4,a4,-902 # 80004f0e <consolewrite>
    8000529c:	ef98                	sd	a4,24(a5)
}
    8000529e:	60a2                	ld	ra,8(sp)
    800052a0:	6402                	ld	s0,0(sp)
    800052a2:	0141                	addi	sp,sp,16
    800052a4:	8082                	ret

00000000800052a6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800052a6:	7139                	addi	sp,sp,-64
    800052a8:	fc06                	sd	ra,56(sp)
    800052aa:	f822                	sd	s0,48(sp)
    800052ac:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800052ae:	c219                	beqz	a2,800052b4 <printint+0xe>
    800052b0:	08054063          	bltz	a0,80005330 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800052b4:	4881                	li	a7,0
    800052b6:	fc840693          	addi	a3,s0,-56

  i = 0;
    800052ba:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800052bc:	00002617          	auipc	a2,0x2
    800052c0:	6d460613          	addi	a2,a2,1748 # 80007990 <digits>
    800052c4:	883e                	mv	a6,a5
    800052c6:	2785                	addiw	a5,a5,1
    800052c8:	02b57733          	remu	a4,a0,a1
    800052cc:	9732                	add	a4,a4,a2
    800052ce:	00074703          	lbu	a4,0(a4)
    800052d2:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800052d6:	872a                	mv	a4,a0
    800052d8:	02b55533          	divu	a0,a0,a1
    800052dc:	0685                	addi	a3,a3,1
    800052de:	feb773e3          	bgeu	a4,a1,800052c4 <printint+0x1e>

  if(sign)
    800052e2:	00088a63          	beqz	a7,800052f6 <printint+0x50>
    buf[i++] = '-';
    800052e6:	1781                	addi	a5,a5,-32
    800052e8:	97a2                	add	a5,a5,s0
    800052ea:	02d00713          	li	a4,45
    800052ee:	fee78423          	sb	a4,-24(a5)
    800052f2:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800052f6:	02f05963          	blez	a5,80005328 <printint+0x82>
    800052fa:	f426                	sd	s1,40(sp)
    800052fc:	f04a                	sd	s2,32(sp)
    800052fe:	fc840713          	addi	a4,s0,-56
    80005302:	00f704b3          	add	s1,a4,a5
    80005306:	fff70913          	addi	s2,a4,-1
    8000530a:	993e                	add	s2,s2,a5
    8000530c:	37fd                	addiw	a5,a5,-1
    8000530e:	1782                	slli	a5,a5,0x20
    80005310:	9381                	srli	a5,a5,0x20
    80005312:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80005316:	fff4c503          	lbu	a0,-1(s1)
    8000531a:	d9dff0ef          	jal	800050b6 <consputc>
  while(--i >= 0)
    8000531e:	14fd                	addi	s1,s1,-1
    80005320:	ff249be3          	bne	s1,s2,80005316 <printint+0x70>
    80005324:	74a2                	ld	s1,40(sp)
    80005326:	7902                	ld	s2,32(sp)
}
    80005328:	70e2                	ld	ra,56(sp)
    8000532a:	7442                	ld	s0,48(sp)
    8000532c:	6121                	addi	sp,sp,64
    8000532e:	8082                	ret
    x = -xx;
    80005330:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005334:	4885                	li	a7,1
    x = -xx;
    80005336:	b741                	j	800052b6 <printint+0x10>

0000000080005338 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005338:	7131                	addi	sp,sp,-192
    8000533a:	fc86                	sd	ra,120(sp)
    8000533c:	f8a2                	sd	s0,112(sp)
    8000533e:	e8d2                	sd	s4,80(sp)
    80005340:	0100                	addi	s0,sp,128
    80005342:	8a2a                	mv	s4,a0
    80005344:	e40c                	sd	a1,8(s0)
    80005346:	e810                	sd	a2,16(s0)
    80005348:	ec14                	sd	a3,24(s0)
    8000534a:	f018                	sd	a4,32(s0)
    8000534c:	f41c                	sd	a5,40(s0)
    8000534e:	03043823          	sd	a6,48(s0)
    80005352:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80005356:	00005797          	auipc	a5,0x5
    8000535a:	01a7a783          	lw	a5,26(a5) # 8000a370 <panicking>
    8000535e:	c3a1                	beqz	a5,8000539e <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005360:	00840793          	addi	a5,s0,8
    80005364:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005368:	000a4503          	lbu	a0,0(s4)
    8000536c:	28050763          	beqz	a0,800055fa <printf+0x2c2>
    80005370:	f4a6                	sd	s1,104(sp)
    80005372:	f0ca                	sd	s2,96(sp)
    80005374:	ecce                	sd	s3,88(sp)
    80005376:	e4d6                	sd	s5,72(sp)
    80005378:	e0da                	sd	s6,64(sp)
    8000537a:	f862                	sd	s8,48(sp)
    8000537c:	f466                	sd	s9,40(sp)
    8000537e:	f06a                	sd	s10,32(sp)
    80005380:	ec6e                	sd	s11,24(sp)
    80005382:	4981                	li	s3,0
    if(cx != '%'){
    80005384:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005388:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000538c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005390:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005394:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005398:	07000d93          	li	s11,112
    8000539c:	a01d                	j	800053c2 <printf+0x8a>
    acquire(&pr.lock);
    8000539e:	0001e517          	auipc	a0,0x1e
    800053a2:	4ba50513          	addi	a0,a0,1210 # 80023858 <pr>
    800053a6:	534000ef          	jal	800058da <acquire>
    800053aa:	bf5d                	j	80005360 <printf+0x28>
      consputc(cx);
    800053ac:	d0bff0ef          	jal	800050b6 <consputc>
      continue;
    800053b0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800053b2:	0014899b          	addiw	s3,s1,1
    800053b6:	013a07b3          	add	a5,s4,s3
    800053ba:	0007c503          	lbu	a0,0(a5)
    800053be:	20050b63          	beqz	a0,800055d4 <printf+0x29c>
    if(cx != '%'){
    800053c2:	ff5515e3          	bne	a0,s5,800053ac <printf+0x74>
    i++;
    800053c6:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800053ca:	009a07b3          	add	a5,s4,s1
    800053ce:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800053d2:	20090b63          	beqz	s2,800055e8 <printf+0x2b0>
    800053d6:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800053da:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800053dc:	c789                	beqz	a5,800053e6 <printf+0xae>
    800053de:	009a0733          	add	a4,s4,s1
    800053e2:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800053e6:	03690963          	beq	s2,s6,80005418 <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800053ea:	05890363          	beq	s2,s8,80005430 <printf+0xf8>
    } else if(c0 == 'u'){
    800053ee:	0d990663          	beq	s2,s9,800054ba <printf+0x182>
    } else if(c0 == 'x'){
    800053f2:	11a90d63          	beq	s2,s10,8000550c <printf+0x1d4>
    } else if(c0 == 'p'){
    800053f6:	15b90663          	beq	s2,s11,80005542 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800053fa:	06300793          	li	a5,99
    800053fe:	18f90563          	beq	s2,a5,80005588 <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    80005402:	07300793          	li	a5,115
    80005406:	18f90b63          	beq	s2,a5,8000559c <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000540a:	03591b63          	bne	s2,s5,80005440 <printf+0x108>
      consputc('%');
    8000540e:	02500513          	li	a0,37
    80005412:	ca5ff0ef          	jal	800050b6 <consputc>
    80005416:	bf71                	j	800053b2 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    80005418:	f8843783          	ld	a5,-120(s0)
    8000541c:	00878713          	addi	a4,a5,8
    80005420:	f8e43423          	sd	a4,-120(s0)
    80005424:	4605                	li	a2,1
    80005426:	45a9                	li	a1,10
    80005428:	4388                	lw	a0,0(a5)
    8000542a:	e7dff0ef          	jal	800052a6 <printint>
    8000542e:	b751                	j	800053b2 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    80005430:	01678f63          	beq	a5,s6,8000544e <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005434:	03878b63          	beq	a5,s8,8000546a <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    80005438:	09978e63          	beq	a5,s9,800054d4 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    8000543c:	0fa78563          	beq	a5,s10,80005526 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005440:	8556                	mv	a0,s5
    80005442:	c75ff0ef          	jal	800050b6 <consputc>
      consputc(c0);
    80005446:	854a                	mv	a0,s2
    80005448:	c6fff0ef          	jal	800050b6 <consputc>
    8000544c:	b79d                	j	800053b2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000544e:	f8843783          	ld	a5,-120(s0)
    80005452:	00878713          	addi	a4,a5,8
    80005456:	f8e43423          	sd	a4,-120(s0)
    8000545a:	4605                	li	a2,1
    8000545c:	45a9                	li	a1,10
    8000545e:	6388                	ld	a0,0(a5)
    80005460:	e47ff0ef          	jal	800052a6 <printint>
      i += 1;
    80005464:	0029849b          	addiw	s1,s3,2
    80005468:	b7a9                	j	800053b2 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000546a:	06400793          	li	a5,100
    8000546e:	02f68863          	beq	a3,a5,8000549e <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005472:	07500793          	li	a5,117
    80005476:	06f68d63          	beq	a3,a5,800054f0 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000547a:	07800793          	li	a5,120
    8000547e:	fcf691e3          	bne	a3,a5,80005440 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80005482:	f8843783          	ld	a5,-120(s0)
    80005486:	00878713          	addi	a4,a5,8
    8000548a:	f8e43423          	sd	a4,-120(s0)
    8000548e:	4601                	li	a2,0
    80005490:	45c1                	li	a1,16
    80005492:	6388                	ld	a0,0(a5)
    80005494:	e13ff0ef          	jal	800052a6 <printint>
      i += 2;
    80005498:	0039849b          	addiw	s1,s3,3
    8000549c:	bf19                	j	800053b2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000549e:	f8843783          	ld	a5,-120(s0)
    800054a2:	00878713          	addi	a4,a5,8
    800054a6:	f8e43423          	sd	a4,-120(s0)
    800054aa:	4605                	li	a2,1
    800054ac:	45a9                	li	a1,10
    800054ae:	6388                	ld	a0,0(a5)
    800054b0:	df7ff0ef          	jal	800052a6 <printint>
      i += 2;
    800054b4:	0039849b          	addiw	s1,s3,3
    800054b8:	bded                	j	800053b2 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    800054ba:	f8843783          	ld	a5,-120(s0)
    800054be:	00878713          	addi	a4,a5,8
    800054c2:	f8e43423          	sd	a4,-120(s0)
    800054c6:	4601                	li	a2,0
    800054c8:	45a9                	li	a1,10
    800054ca:	0007e503          	lwu	a0,0(a5)
    800054ce:	dd9ff0ef          	jal	800052a6 <printint>
    800054d2:	b5c5                	j	800053b2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800054d4:	f8843783          	ld	a5,-120(s0)
    800054d8:	00878713          	addi	a4,a5,8
    800054dc:	f8e43423          	sd	a4,-120(s0)
    800054e0:	4601                	li	a2,0
    800054e2:	45a9                	li	a1,10
    800054e4:	6388                	ld	a0,0(a5)
    800054e6:	dc1ff0ef          	jal	800052a6 <printint>
      i += 1;
    800054ea:	0029849b          	addiw	s1,s3,2
    800054ee:	b5d1                	j	800053b2 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800054f0:	f8843783          	ld	a5,-120(s0)
    800054f4:	00878713          	addi	a4,a5,8
    800054f8:	f8e43423          	sd	a4,-120(s0)
    800054fc:	4601                	li	a2,0
    800054fe:	45a9                	li	a1,10
    80005500:	6388                	ld	a0,0(a5)
    80005502:	da5ff0ef          	jal	800052a6 <printint>
      i += 2;
    80005506:	0039849b          	addiw	s1,s3,3
    8000550a:	b565                	j	800053b2 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    8000550c:	f8843783          	ld	a5,-120(s0)
    80005510:	00878713          	addi	a4,a5,8
    80005514:	f8e43423          	sd	a4,-120(s0)
    80005518:	4601                	li	a2,0
    8000551a:	45c1                	li	a1,16
    8000551c:	0007e503          	lwu	a0,0(a5)
    80005520:	d87ff0ef          	jal	800052a6 <printint>
    80005524:	b579                	j	800053b2 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    80005526:	f8843783          	ld	a5,-120(s0)
    8000552a:	00878713          	addi	a4,a5,8
    8000552e:	f8e43423          	sd	a4,-120(s0)
    80005532:	4601                	li	a2,0
    80005534:	45c1                	li	a1,16
    80005536:	6388                	ld	a0,0(a5)
    80005538:	d6fff0ef          	jal	800052a6 <printint>
      i += 1;
    8000553c:	0029849b          	addiw	s1,s3,2
    80005540:	bd8d                	j	800053b2 <printf+0x7a>
    80005542:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80005544:	f8843783          	ld	a5,-120(s0)
    80005548:	00878713          	addi	a4,a5,8
    8000554c:	f8e43423          	sd	a4,-120(s0)
    80005550:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005554:	03000513          	li	a0,48
    80005558:	b5fff0ef          	jal	800050b6 <consputc>
  consputc('x');
    8000555c:	07800513          	li	a0,120
    80005560:	b57ff0ef          	jal	800050b6 <consputc>
    80005564:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005566:	00002b97          	auipc	s7,0x2
    8000556a:	42ab8b93          	addi	s7,s7,1066 # 80007990 <digits>
    8000556e:	03c9d793          	srli	a5,s3,0x3c
    80005572:	97de                	add	a5,a5,s7
    80005574:	0007c503          	lbu	a0,0(a5)
    80005578:	b3fff0ef          	jal	800050b6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000557c:	0992                	slli	s3,s3,0x4
    8000557e:	397d                	addiw	s2,s2,-1
    80005580:	fe0917e3          	bnez	s2,8000556e <printf+0x236>
    80005584:	7be2                	ld	s7,56(sp)
    80005586:	b535                	j	800053b2 <printf+0x7a>
      consputc(va_arg(ap, uint));
    80005588:	f8843783          	ld	a5,-120(s0)
    8000558c:	00878713          	addi	a4,a5,8
    80005590:	f8e43423          	sd	a4,-120(s0)
    80005594:	4388                	lw	a0,0(a5)
    80005596:	b21ff0ef          	jal	800050b6 <consputc>
    8000559a:	bd21                	j	800053b2 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    8000559c:	f8843783          	ld	a5,-120(s0)
    800055a0:	00878713          	addi	a4,a5,8
    800055a4:	f8e43423          	sd	a4,-120(s0)
    800055a8:	0007b903          	ld	s2,0(a5)
    800055ac:	00090d63          	beqz	s2,800055c6 <printf+0x28e>
      for(; *s; s++)
    800055b0:	00094503          	lbu	a0,0(s2)
    800055b4:	de050fe3          	beqz	a0,800053b2 <printf+0x7a>
        consputc(*s);
    800055b8:	affff0ef          	jal	800050b6 <consputc>
      for(; *s; s++)
    800055bc:	0905                	addi	s2,s2,1
    800055be:	00094503          	lbu	a0,0(s2)
    800055c2:	f97d                	bnez	a0,800055b8 <printf+0x280>
    800055c4:	b3fd                	j	800053b2 <printf+0x7a>
        s = "(null)";
    800055c6:	00002917          	auipc	s2,0x2
    800055ca:	1ba90913          	addi	s2,s2,442 # 80007780 <etext+0x780>
      for(; *s; s++)
    800055ce:	02800513          	li	a0,40
    800055d2:	b7dd                	j	800055b8 <printf+0x280>
    800055d4:	74a6                	ld	s1,104(sp)
    800055d6:	7906                	ld	s2,96(sp)
    800055d8:	69e6                	ld	s3,88(sp)
    800055da:	6aa6                	ld	s5,72(sp)
    800055dc:	6b06                	ld	s6,64(sp)
    800055de:	7c42                	ld	s8,48(sp)
    800055e0:	7ca2                	ld	s9,40(sp)
    800055e2:	7d02                	ld	s10,32(sp)
    800055e4:	6de2                	ld	s11,24(sp)
    800055e6:	a811                	j	800055fa <printf+0x2c2>
    800055e8:	74a6                	ld	s1,104(sp)
    800055ea:	7906                	ld	s2,96(sp)
    800055ec:	69e6                	ld	s3,88(sp)
    800055ee:	6aa6                	ld	s5,72(sp)
    800055f0:	6b06                	ld	s6,64(sp)
    800055f2:	7c42                	ld	s8,48(sp)
    800055f4:	7ca2                	ld	s9,40(sp)
    800055f6:	7d02                	ld	s10,32(sp)
    800055f8:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800055fa:	00005797          	auipc	a5,0x5
    800055fe:	d767a783          	lw	a5,-650(a5) # 8000a370 <panicking>
    80005602:	c799                	beqz	a5,80005610 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    80005604:	4501                	li	a0,0
    80005606:	70e6                	ld	ra,120(sp)
    80005608:	7446                	ld	s0,112(sp)
    8000560a:	6a46                	ld	s4,80(sp)
    8000560c:	6129                	addi	sp,sp,192
    8000560e:	8082                	ret
    release(&pr.lock);
    80005610:	0001e517          	auipc	a0,0x1e
    80005614:	24850513          	addi	a0,a0,584 # 80023858 <pr>
    80005618:	35a000ef          	jal	80005972 <release>
  return 0;
    8000561c:	b7e5                	j	80005604 <printf+0x2cc>

000000008000561e <panic>:

void
panic(char *s)
{
    8000561e:	1101                	addi	sp,sp,-32
    80005620:	ec06                	sd	ra,24(sp)
    80005622:	e822                	sd	s0,16(sp)
    80005624:	e426                	sd	s1,8(sp)
    80005626:	e04a                	sd	s2,0(sp)
    80005628:	1000                	addi	s0,sp,32
    8000562a:	84aa                	mv	s1,a0
  panicking = 1;
    8000562c:	4905                	li	s2,1
    8000562e:	00005797          	auipc	a5,0x5
    80005632:	d527a123          	sw	s2,-702(a5) # 8000a370 <panicking>
  printf("panic: ");
    80005636:	00002517          	auipc	a0,0x2
    8000563a:	15250513          	addi	a0,a0,338 # 80007788 <etext+0x788>
    8000563e:	cfbff0ef          	jal	80005338 <printf>
  printf("%s\n", s);
    80005642:	85a6                	mv	a1,s1
    80005644:	00002517          	auipc	a0,0x2
    80005648:	14c50513          	addi	a0,a0,332 # 80007790 <etext+0x790>
    8000564c:	cedff0ef          	jal	80005338 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005650:	00005797          	auipc	a5,0x5
    80005654:	d127ae23          	sw	s2,-740(a5) # 8000a36c <panicked>
  for(;;)
    80005658:	a001                	j	80005658 <panic+0x3a>

000000008000565a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000565a:	1141                	addi	sp,sp,-16
    8000565c:	e406                	sd	ra,8(sp)
    8000565e:	e022                	sd	s0,0(sp)
    80005660:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005662:	00002597          	auipc	a1,0x2
    80005666:	13658593          	addi	a1,a1,310 # 80007798 <etext+0x798>
    8000566a:	0001e517          	auipc	a0,0x1e
    8000566e:	1ee50513          	addi	a0,a0,494 # 80023858 <pr>
    80005672:	1e8000ef          	jal	8000585a <initlock>
}
    80005676:	60a2                	ld	ra,8(sp)
    80005678:	6402                	ld	s0,0(sp)
    8000567a:	0141                	addi	sp,sp,16
    8000567c:	8082                	ret

000000008000567e <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    8000567e:	1141                	addi	sp,sp,-16
    80005680:	e406                	sd	ra,8(sp)
    80005682:	e022                	sd	s0,0(sp)
    80005684:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005686:	100007b7          	lui	a5,0x10000
    8000568a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000568e:	10000737          	lui	a4,0x10000
    80005692:	f8000693          	li	a3,-128
    80005696:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000569a:	468d                	li	a3,3
    8000569c:	10000637          	lui	a2,0x10000
    800056a0:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800056a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800056a8:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800056ac:	10000737          	lui	a4,0x10000
    800056b0:	461d                	li	a2,7
    800056b2:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800056b6:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800056ba:	00002597          	auipc	a1,0x2
    800056be:	0e658593          	addi	a1,a1,230 # 800077a0 <etext+0x7a0>
    800056c2:	0001e517          	auipc	a0,0x1e
    800056c6:	1ae50513          	addi	a0,a0,430 # 80023870 <tx_lock>
    800056ca:	190000ef          	jal	8000585a <initlock>
}
    800056ce:	60a2                	ld	ra,8(sp)
    800056d0:	6402                	ld	s0,0(sp)
    800056d2:	0141                	addi	sp,sp,16
    800056d4:	8082                	ret

00000000800056d6 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800056d6:	715d                	addi	sp,sp,-80
    800056d8:	e486                	sd	ra,72(sp)
    800056da:	e0a2                	sd	s0,64(sp)
    800056dc:	fc26                	sd	s1,56(sp)
    800056de:	ec56                	sd	s5,24(sp)
    800056e0:	0880                	addi	s0,sp,80
    800056e2:	8aaa                	mv	s5,a0
    800056e4:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800056e6:	0001e517          	auipc	a0,0x1e
    800056ea:	18a50513          	addi	a0,a0,394 # 80023870 <tx_lock>
    800056ee:	1ec000ef          	jal	800058da <acquire>

  int i = 0;
  while(i < n){ 
    800056f2:	06905063          	blez	s1,80005752 <uartwrite+0x7c>
    800056f6:	f84a                	sd	s2,48(sp)
    800056f8:	f44e                	sd	s3,40(sp)
    800056fa:	f052                	sd	s4,32(sp)
    800056fc:	e85a                	sd	s6,16(sp)
    800056fe:	e45e                	sd	s7,8(sp)
    80005700:	8a56                	mv	s4,s5
    80005702:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005704:	00005497          	auipc	s1,0x5
    80005708:	c7448493          	addi	s1,s1,-908 # 8000a378 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    8000570c:	0001e997          	auipc	s3,0x1e
    80005710:	16498993          	addi	s3,s3,356 # 80023870 <tx_lock>
    80005714:	00005917          	auipc	s2,0x5
    80005718:	c6090913          	addi	s2,s2,-928 # 8000a374 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    8000571c:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005720:	4b05                	li	s6,1
    80005722:	a005                	j	80005742 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005724:	85ce                	mv	a1,s3
    80005726:	854a                	mv	a0,s2
    80005728:	c5dfb0ef          	jal	80001384 <sleep>
    while(tx_busy != 0){
    8000572c:	409c                	lw	a5,0(s1)
    8000572e:	fbfd                	bnez	a5,80005724 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005730:	000a4783          	lbu	a5,0(s4)
    80005734:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005738:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    8000573c:	0a05                	addi	s4,s4,1
    8000573e:	015a0563          	beq	s4,s5,80005748 <uartwrite+0x72>
    while(tx_busy != 0){
    80005742:	409c                	lw	a5,0(s1)
    80005744:	f3e5                	bnez	a5,80005724 <uartwrite+0x4e>
    80005746:	b7ed                	j	80005730 <uartwrite+0x5a>
    80005748:	7942                	ld	s2,48(sp)
    8000574a:	79a2                	ld	s3,40(sp)
    8000574c:	7a02                	ld	s4,32(sp)
    8000574e:	6b42                	ld	s6,16(sp)
    80005750:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005752:	0001e517          	auipc	a0,0x1e
    80005756:	11e50513          	addi	a0,a0,286 # 80023870 <tx_lock>
    8000575a:	218000ef          	jal	80005972 <release>
}
    8000575e:	60a6                	ld	ra,72(sp)
    80005760:	6406                	ld	s0,64(sp)
    80005762:	74e2                	ld	s1,56(sp)
    80005764:	6ae2                	ld	s5,24(sp)
    80005766:	6161                	addi	sp,sp,80
    80005768:	8082                	ret

000000008000576a <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000576a:	1101                	addi	sp,sp,-32
    8000576c:	ec06                	sd	ra,24(sp)
    8000576e:	e822                	sd	s0,16(sp)
    80005770:	e426                	sd	s1,8(sp)
    80005772:	1000                	addi	s0,sp,32
    80005774:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005776:	00005797          	auipc	a5,0x5
    8000577a:	bfa7a783          	lw	a5,-1030(a5) # 8000a370 <panicking>
    8000577e:	cf95                	beqz	a5,800057ba <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005780:	00005797          	auipc	a5,0x5
    80005784:	bec7a783          	lw	a5,-1044(a5) # 8000a36c <panicked>
    80005788:	ef85                	bnez	a5,800057c0 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000578a:	10000737          	lui	a4,0x10000
    8000578e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005790:	00074783          	lbu	a5,0(a4)
    80005794:	0207f793          	andi	a5,a5,32
    80005798:	dfe5                	beqz	a5,80005790 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000579a:	0ff4f513          	zext.b	a0,s1
    8000579e:	100007b7          	lui	a5,0x10000
    800057a2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800057a6:	00005797          	auipc	a5,0x5
    800057aa:	bca7a783          	lw	a5,-1078(a5) # 8000a370 <panicking>
    800057ae:	cb91                	beqz	a5,800057c2 <uartputc_sync+0x58>
    pop_off();
}
    800057b0:	60e2                	ld	ra,24(sp)
    800057b2:	6442                	ld	s0,16(sp)
    800057b4:	64a2                	ld	s1,8(sp)
    800057b6:	6105                	addi	sp,sp,32
    800057b8:	8082                	ret
    push_off();
    800057ba:	0e0000ef          	jal	8000589a <push_off>
    800057be:	b7c9                	j	80005780 <uartputc_sync+0x16>
    for(;;)
    800057c0:	a001                	j	800057c0 <uartputc_sync+0x56>
    pop_off();
    800057c2:	15c000ef          	jal	8000591e <pop_off>
}
    800057c6:	b7ed                	j	800057b0 <uartputc_sync+0x46>

00000000800057c8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800057c8:	1141                	addi	sp,sp,-16
    800057ca:	e422                	sd	s0,8(sp)
    800057cc:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800057ce:	100007b7          	lui	a5,0x10000
    800057d2:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800057d4:	0007c783          	lbu	a5,0(a5)
    800057d8:	8b85                	andi	a5,a5,1
    800057da:	cb81                	beqz	a5,800057ea <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800057dc:	100007b7          	lui	a5,0x10000
    800057e0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800057e4:	6422                	ld	s0,8(sp)
    800057e6:	0141                	addi	sp,sp,16
    800057e8:	8082                	ret
    return -1;
    800057ea:	557d                	li	a0,-1
    800057ec:	bfe5                	j	800057e4 <uartgetc+0x1c>

00000000800057ee <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800057ee:	1101                	addi	sp,sp,-32
    800057f0:	ec06                	sd	ra,24(sp)
    800057f2:	e822                	sd	s0,16(sp)
    800057f4:	e426                	sd	s1,8(sp)
    800057f6:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800057f8:	100007b7          	lui	a5,0x10000
    800057fc:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800057fe:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    80005802:	0001e517          	auipc	a0,0x1e
    80005806:	06e50513          	addi	a0,a0,110 # 80023870 <tx_lock>
    8000580a:	0d0000ef          	jal	800058da <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    8000580e:	100007b7          	lui	a5,0x10000
    80005812:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80005814:	0007c783          	lbu	a5,0(a5)
    80005818:	0207f793          	andi	a5,a5,32
    8000581c:	eb89                	bnez	a5,8000582e <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    8000581e:	0001e517          	auipc	a0,0x1e
    80005822:	05250513          	addi	a0,a0,82 # 80023870 <tx_lock>
    80005826:	14c000ef          	jal	80005972 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000582a:	54fd                	li	s1,-1
    8000582c:	a831                	j	80005848 <uartintr+0x5a>
    tx_busy = 0;
    8000582e:	00005797          	auipc	a5,0x5
    80005832:	b407a523          	sw	zero,-1206(a5) # 8000a378 <tx_busy>
    wakeup(&tx_chan);
    80005836:	00005517          	auipc	a0,0x5
    8000583a:	b3e50513          	addi	a0,a0,-1218 # 8000a374 <tx_chan>
    8000583e:	b93fb0ef          	jal	800013d0 <wakeup>
    80005842:	bff1                	j	8000581e <uartintr+0x30>
      break;
    consoleintr(c);
    80005844:	8a5ff0ef          	jal	800050e8 <consoleintr>
    int c = uartgetc();
    80005848:	f81ff0ef          	jal	800057c8 <uartgetc>
    if(c == -1)
    8000584c:	fe951ce3          	bne	a0,s1,80005844 <uartintr+0x56>
  }
}
    80005850:	60e2                	ld	ra,24(sp)
    80005852:	6442                	ld	s0,16(sp)
    80005854:	64a2                	ld	s1,8(sp)
    80005856:	6105                	addi	sp,sp,32
    80005858:	8082                	ret

000000008000585a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000585a:	1141                	addi	sp,sp,-16
    8000585c:	e422                	sd	s0,8(sp)
    8000585e:	0800                	addi	s0,sp,16
  lk->name = name;
    80005860:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005862:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005866:	00053823          	sd	zero,16(a0)
}
    8000586a:	6422                	ld	s0,8(sp)
    8000586c:	0141                	addi	sp,sp,16
    8000586e:	8082                	ret

0000000080005870 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005870:	411c                	lw	a5,0(a0)
    80005872:	e399                	bnez	a5,80005878 <holding+0x8>
    80005874:	4501                	li	a0,0
  return r;
}
    80005876:	8082                	ret
{
    80005878:	1101                	addi	sp,sp,-32
    8000587a:	ec06                	sd	ra,24(sp)
    8000587c:	e822                	sd	s0,16(sp)
    8000587e:	e426                	sd	s1,8(sp)
    80005880:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005882:	6904                	ld	s1,16(a0)
    80005884:	ce4fb0ef          	jal	80000d68 <mycpu>
    80005888:	40a48533          	sub	a0,s1,a0
    8000588c:	00153513          	seqz	a0,a0
}
    80005890:	60e2                	ld	ra,24(sp)
    80005892:	6442                	ld	s0,16(sp)
    80005894:	64a2                	ld	s1,8(sp)
    80005896:	6105                	addi	sp,sp,32
    80005898:	8082                	ret

000000008000589a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000589a:	1101                	addi	sp,sp,-32
    8000589c:	ec06                	sd	ra,24(sp)
    8000589e:	e822                	sd	s0,16(sp)
    800058a0:	e426                	sd	s1,8(sp)
    800058a2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058a4:	100024f3          	csrr	s1,sstatus
    800058a8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800058ac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058ae:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    800058b2:	cb6fb0ef          	jal	80000d68 <mycpu>
    800058b6:	5d3c                	lw	a5,120(a0)
    800058b8:	cb99                	beqz	a5,800058ce <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800058ba:	caefb0ef          	jal	80000d68 <mycpu>
    800058be:	5d3c                	lw	a5,120(a0)
    800058c0:	2785                	addiw	a5,a5,1
    800058c2:	dd3c                	sw	a5,120(a0)
}
    800058c4:	60e2                	ld	ra,24(sp)
    800058c6:	6442                	ld	s0,16(sp)
    800058c8:	64a2                	ld	s1,8(sp)
    800058ca:	6105                	addi	sp,sp,32
    800058cc:	8082                	ret
    mycpu()->intena = old;
    800058ce:	c9afb0ef          	jal	80000d68 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800058d2:	8085                	srli	s1,s1,0x1
    800058d4:	8885                	andi	s1,s1,1
    800058d6:	dd64                	sw	s1,124(a0)
    800058d8:	b7cd                	j	800058ba <push_off+0x20>

00000000800058da <acquire>:
{
    800058da:	1101                	addi	sp,sp,-32
    800058dc:	ec06                	sd	ra,24(sp)
    800058de:	e822                	sd	s0,16(sp)
    800058e0:	e426                	sd	s1,8(sp)
    800058e2:	1000                	addi	s0,sp,32
    800058e4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800058e6:	fb5ff0ef          	jal	8000589a <push_off>
  if(holding(lk))
    800058ea:	8526                	mv	a0,s1
    800058ec:	f85ff0ef          	jal	80005870 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058f0:	4705                	li	a4,1
  if(holding(lk))
    800058f2:	e105                	bnez	a0,80005912 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058f4:	87ba                	mv	a5,a4
    800058f6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800058fa:	2781                	sext.w	a5,a5
    800058fc:	ffe5                	bnez	a5,800058f4 <acquire+0x1a>
  __sync_synchronize();
    800058fe:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005902:	c66fb0ef          	jal	80000d68 <mycpu>
    80005906:	e888                	sd	a0,16(s1)
}
    80005908:	60e2                	ld	ra,24(sp)
    8000590a:	6442                	ld	s0,16(sp)
    8000590c:	64a2                	ld	s1,8(sp)
    8000590e:	6105                	addi	sp,sp,32
    80005910:	8082                	ret
    panic("acquire");
    80005912:	00002517          	auipc	a0,0x2
    80005916:	e9650513          	addi	a0,a0,-362 # 800077a8 <etext+0x7a8>
    8000591a:	d05ff0ef          	jal	8000561e <panic>

000000008000591e <pop_off>:

void
pop_off(void)
{
    8000591e:	1141                	addi	sp,sp,-16
    80005920:	e406                	sd	ra,8(sp)
    80005922:	e022                	sd	s0,0(sp)
    80005924:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005926:	c42fb0ef          	jal	80000d68 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000592a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000592e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005930:	e78d                	bnez	a5,8000595a <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005932:	5d3c                	lw	a5,120(a0)
    80005934:	02f05963          	blez	a5,80005966 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80005938:	37fd                	addiw	a5,a5,-1
    8000593a:	0007871b          	sext.w	a4,a5
    8000593e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005940:	eb09                	bnez	a4,80005952 <pop_off+0x34>
    80005942:	5d7c                	lw	a5,124(a0)
    80005944:	c799                	beqz	a5,80005952 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005946:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000594a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000594e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005952:	60a2                	ld	ra,8(sp)
    80005954:	6402                	ld	s0,0(sp)
    80005956:	0141                	addi	sp,sp,16
    80005958:	8082                	ret
    panic("pop_off - interruptible");
    8000595a:	00002517          	auipc	a0,0x2
    8000595e:	e5650513          	addi	a0,a0,-426 # 800077b0 <etext+0x7b0>
    80005962:	cbdff0ef          	jal	8000561e <panic>
    panic("pop_off");
    80005966:	00002517          	auipc	a0,0x2
    8000596a:	e6250513          	addi	a0,a0,-414 # 800077c8 <etext+0x7c8>
    8000596e:	cb1ff0ef          	jal	8000561e <panic>

0000000080005972 <release>:
{
    80005972:	1101                	addi	sp,sp,-32
    80005974:	ec06                	sd	ra,24(sp)
    80005976:	e822                	sd	s0,16(sp)
    80005978:	e426                	sd	s1,8(sp)
    8000597a:	1000                	addi	s0,sp,32
    8000597c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000597e:	ef3ff0ef          	jal	80005870 <holding>
    80005982:	c105                	beqz	a0,800059a2 <release+0x30>
  lk->cpu = 0;
    80005984:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005988:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000598c:	0310000f          	fence	rw,w
    80005990:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005994:	f8bff0ef          	jal	8000591e <pop_off>
}
    80005998:	60e2                	ld	ra,24(sp)
    8000599a:	6442                	ld	s0,16(sp)
    8000599c:	64a2                	ld	s1,8(sp)
    8000599e:	6105                	addi	sp,sp,32
    800059a0:	8082                	ret
    panic("release");
    800059a2:	00002517          	auipc	a0,0x2
    800059a6:	e2e50513          	addi	a0,a0,-466 # 800077d0 <etext+0x7d0>
    800059aa:	c75ff0ef          	jal	8000561e <panic>
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
