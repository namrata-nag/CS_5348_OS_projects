
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 2e 10 80       	mov    $0x80102eb0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 80 6c 10 	movl   $0x80106c80,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 b0 40 00 00       	call   80104110 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 87 6c 10 	movl   $0x80106c87,0x4(%esp)
8010009b:	80 
8010009c:	e8 5f 3f 00 00       	call   80104000 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 15 41 00 00       	call   80104200 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 8a 41 00 00       	call   801042f0 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 cf 3e 00 00       	call   80104040 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 62 20 00 00       	call   801021e0 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 8e 6c 10 80 	movl   $0x80106c8e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 2b 3f 00 00       	call   801040e0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 17 20 00 00       	jmp    801021e0 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 9f 6c 10 80 	movl   $0x80106c9f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 ea 3e 00 00       	call   801040e0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 9e 3e 00 00       	call   801040a0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 f2 3f 00 00       	call   80104200 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 9b 40 00 00       	jmp    801042f0 <release>
    panic("brelse");
80100255:	c7 04 24 a6 6c 10 80 	movl   $0x80106ca6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 c9 15 00 00       	call   80101850 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 6d 3f 00 00       	call   80104200 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 b3 34 00 00       	call   80103760 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 f8 39 00 00       	call   80103cc0 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 da 3f 00 00       	call   801042f0 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 52 14 00 00       	call   80101770 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 bc 3f 00 00       	call   801042f0 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 34 14 00 00       	call   80101770 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 a5 24 00 00       	call   80102820 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 ad 6c 10 80 	movl   $0x80106cad,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 f7 75 10 80 	movl   $0x801075f7,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 7c 3d 00 00       	call   80104130 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 c1 6c 10 80 	movl   $0x80106cc1,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 e2 53 00 00       	call   801057f0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 32 53 00 00       	call   801057f0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 26 53 00 00       	call   801057f0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 1a 53 00 00       	call   801057f0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 df 3e 00 00       	call   801043e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 22 3e 00 00       	call   80104340 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 c5 6c 10 80 	movl   $0x80106cc5,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 f0 6c 10 80 	movzbl -0x7fef9310(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 49 12 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 ed 3b 00 00       	call   80104200 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 b5 3c 00 00       	call   801042f0 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 2a 11 00 00       	call   80101770 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 f8 3b 00 00       	call   801042f0 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 d8 6c 10 80       	mov    $0x80106cd8,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 64 3a 00 00       	call   80104200 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 df 6c 10 80 	movl   $0x80106cdf,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 36 3a 00 00       	call   80104200 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 c4 3a 00 00       	call   801042f0 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 99 35 00 00       	call   80103e50 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 04 36 00 00       	jmp    80103f30 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 e8 6c 10 	movl   $0x80106ce8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 a6 37 00 00       	call   80104110 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 d4 19 00 00       	call   80102370 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 af 2d 00 00       	call   80103760 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 14 22 00 00       	call   80102bd0 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 f9 15 00 00       	call   80101fc0 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 97 0d 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 25 10 00 00       	call   80101a20 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 c8 0f 00 00       	call   801019d0 <iunlockput>
    end_op();
80100a08:	e8 33 22 00 00       	call   80102c40 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 af 5f 00 00       	call   801069e0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 8d 0f 00 00       	call   80101a20 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 79 5d 00 00       	call   80106850 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 78 5c 00 00       	call   80106790 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 32 5e 00 00       	call   80106960 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 95 0e 00 00       	call   801019d0 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 fb 20 00 00       	call   80102c40 <end_op>
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 df 5c 00 00       	call   80106850 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 d7 5d 00 00       	call   80106960 <freevm>
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b93:	e8 a8 20 00 00       	call   80102c40 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 01 6d 10 80 	movl   $0x80106d01,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 c3 5e 00 00       	call   80106a90 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 5a 39 00 00       	call   80104560 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 49 39 00 00       	call   80104560 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 ba 5f 00 00       	call   80106bf0 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 47 5f 00 00       	call   80106bf0 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 2a 38 00 00       	call   80104520 <safestrcpy>
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 dc 58 00 00       	call   80106600 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 34 5c 00 00       	call   80106960 <freevm>
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 0d 6d 10 	movl   $0x80106d0d,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 a6 33 00 00       	call   80104110 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 78 34 00 00       	call   80104200 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 3b 35 00 00       	call   801042f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 24 35 00 00       	call   801042f0 <release>
}
80100dcc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 0a 34 00 00       	call   80104200 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 e1 34 00 00       	call   801042f0 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
    panic("filedup");
80100e17:	c7 04 24 14 6d 10 80 	movl   $0x80106d14,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 b8 33 00 00       	call   80104200 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e6b:	e9 80 34 00 00       	jmp    801042f0 <release>
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e8f:	e8 5c 34 00 00       	call   801042f0 <release>
  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 68 24 00 00       	call   80103320 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ec0:	e8 0b 1d 00 00       	call   80102bd0 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 c0 09 00 00       	call   80101890 <iput>
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
    end_op();
80100ed7:	e9 64 1d 00 00       	jmp    80102c40 <end_op>
    panic("fileclose");
80100edc:	c7 04 24 1c 6d 10 80 	movl   $0x80106d1c,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 66 08 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 d4 0a 00 00       	call   801019f0 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 29 09 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 01 08 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 97 0a 00 00       	call   80101a20 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 b3 08 00 00       	call   80101850 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fb5:	e9 e6 24 00 00       	jmp    801034a0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
  panic("fileread");
80100fc7:	c7 04 24 26 6d 10 80 	movl   $0x80106d26,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 17 08 00 00       	call   80101850 <iunlock>
      end_op();
80101039:	e8 02 1c 00 00       	call   80102c40 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101063:	e8 68 1b 00 00       	call   80102bd0 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 fd 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 8e 0a 00 00       	call   80101b20 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 ac 07 00 00       	call   80101850 <iunlock>
      end_op();
801010a4:	e8 97 1b 00 00       	call   80102c40 <end_op>
      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 cf 22 00 00       	jmp    801033b0 <pipewrite>
        panic("short filewrite");
801010e1:	c7 04 24 2f 6d 10 80 	movl   $0x80106d2f,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010ed:	c7 04 24 35 6d 10 80 	movl   $0x80106d35,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 2c             	sub    $0x2c,%esp
80101109:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010110c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101111:	85 c0                	test   %eax,%eax
80101113:	0f 84 8c 00 00 00    	je     801011a5 <balloc+0xa5>
80101119:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101120:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101123:	89 f0                	mov    %esi,%eax
80101125:	c1 f8 0c             	sar    $0xc,%eax
80101128:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010112e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101135:	89 04 24             	mov    %eax,(%esp)
80101138:	e8 93 ef ff ff       	call   801000d0 <bread>
8010113d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101140:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101148:	31 c0                	xor    %eax,%eax
8010114a:	eb 33                	jmp    8010117f <balloc+0x7f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101150:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101153:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101155:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	bf 01 00 00 00       	mov    $0x1,%edi
80101162:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101164:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101169:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116b:	0f b6 fb             	movzbl %bl,%edi
8010116e:	85 cf                	test   %ecx,%edi
80101170:	74 46                	je     801011b8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101172:	83 c0 01             	add    $0x1,%eax
80101175:	83 c6 01             	add    $0x1,%esi
80101178:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117d:	74 05                	je     80101184 <balloc+0x84>
8010117f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101182:	72 cc                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 51 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010118f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010119f:	0f 82 7b ff ff ff    	jb     80101120 <balloc+0x20>
  }
  panic("balloc: out of blocks");
801011a5:	c7 04 24 3f 6d 10 80 	movl   $0x80106d3f,(%esp)
801011ac:	e8 af f1 ff ff       	call   80100360 <panic>
801011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	09 d9                	or     %ebx,%ecx
801011ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011bd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011c1:	89 1c 24             	mov    %ebx,(%esp)
801011c4:	e8 a7 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
801011c9:	89 1c 24             	mov    %ebx,(%esp)
801011cc:	e8 0f f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011d8:	89 04 24             	mov    %eax,(%esp)
801011db:	e8 f0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011e7:	00 
801011e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ef:	00 
  bp = bread(dev, bno);
801011f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 43 31 00 00       	call   80104340 <memset>
  log_write(bp);
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 6b 1b 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101205:	89 1c 24             	mov    %ebx,(%esp)
80101208:	e8 d3 ef ff ff       	call   801001e0 <brelse>
}
8010120d:	83 c4 2c             	add    $0x2c,%esp
80101210:	89 f0                	mov    %esi,%eax
80101212:	5b                   	pop    %ebx
80101213:	5e                   	pop    %esi
80101214:	5f                   	pop    %edi
80101215:	5d                   	pop    %ebp
80101216:	c3                   	ret    
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	89 c7                	mov    %eax,%edi
80101226:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101227:	31 f6                	xor    %esi,%esi
{
80101229:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010122f:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
80101232:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
80101239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010123c:	e8 bf 2f 00 00       	call   80104200 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 14                	jmp    8010125a <iget+0x3a>
80101246:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101248:	85 f6                	test   %esi,%esi
8010124a:	74 3c                	je     80101288 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101252:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101258:	74 46                	je     801012a0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010125d:	85 c9                	test   %ecx,%ecx
8010125f:	7e e7                	jle    80101248 <iget+0x28>
80101261:	39 3b                	cmp    %edi,(%ebx)
80101263:	75 e3                	jne    80101248 <iget+0x28>
80101265:	39 53 04             	cmp    %edx,0x4(%ebx)
80101268:	75 de                	jne    80101248 <iget+0x28>
      ip->ref++;
8010126a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010126d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010126f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101276:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101279:	e8 72 30 00 00       	call   801042f0 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127e:	83 c4 1c             	add    $0x1c,%esp
80101281:	89 f0                	mov    %esi,%eax
80101283:	5b                   	pop    %ebx
80101284:	5e                   	pop    %esi
80101285:	5f                   	pop    %edi
80101286:	5d                   	pop    %ebp
80101287:	c3                   	ret    
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101299:	75 bf                	jne    8010125a <iget+0x3a>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 29                	je     801012cd <iget+0xad>
  ip->dev = dev;
801012a4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012a9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012be:	e8 2d 30 00 00       	call   801042f0 <release>
}
801012c3:	83 c4 1c             	add    $0x1c,%esp
801012c6:	89 f0                	mov    %esi,%eax
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
801012cc:	c3                   	ret    
    panic("iget: no inodes");
801012cd:	c7 04 24 55 6d 10 80 	movl   $0x80106d55,(%esp)
801012d4:	e8 87 f0 ff ff       	call   80100360 <panic>
801012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c3                	mov    %eax,%ebx
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a, index, bcount;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0a             	cmp    $0xa,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	0f 84 e2 00 00 00    	je     801013e0 <bmap+0x100>
	brelse(bp);
	return addr;
   }
	
  panic("bmap: out of range");
}
801012fe:	83 c4 1c             	add    $0x1c,%esp
80101301:	5b                   	pop    %ebx
80101302:	5e                   	pop    %esi
80101303:	5f                   	pop    %edi
80101304:	5d                   	pop    %ebp
80101305:	c3                   	ret    
80101306:	66 90                	xchg   %ax,%ax
  bn -= NDIRECT;
80101308:	8d 72 f5             	lea    -0xb(%edx),%esi
  if(bn < NINDIRECT){
8010130b:	83 fe 7f             	cmp    $0x7f,%esi
8010130e:	0f 86 7c 00 00 00    	jbe    80101390 <bmap+0xb0>
  bn = bn - NINDIRECT; // remove NINDIRECT count from block number
80101314:	8d b2 75 ff ff ff    	lea    -0x8b(%edx),%esi
    if(bn < NDINDIRECT){
8010131a:	81 fe ff 3f 00 00    	cmp    $0x3fff,%esi
80101320:	0f 87 1c 01 00 00    	ja     80101442 <bmap+0x162>
	if((addr = ip->addrs[NDIRECT+1]) == 0){
80101326:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010132c:	85 c0                	test   %eax,%eax
8010132e:	0f 84 fc 00 00 00    	je     80101430 <bmap+0x150>
	bp = bread(ip->dev, addr);
80101334:	89 44 24 04          	mov    %eax,0x4(%esp)
80101338:	8b 03                	mov    (%ebx),%eax
8010133a:	89 04 24             	mov    %eax,(%esp)
8010133d:	e8 8e ed ff ff       	call   801000d0 <bread>
80101342:	89 c2                	mov    %eax,%edx
	index = bn/bcount;
80101344:	89 f0                	mov    %esi,%eax
80101346:	c1 e8 07             	shr    $0x7,%eax
	if((addr = a[index]) == 0){
80101349:	8d 4c 82 5c          	lea    0x5c(%edx,%eax,4),%ecx
8010134d:	8b 39                	mov    (%ecx),%edi
8010134f:	85 ff                	test   %edi,%edi
80101351:	0f 84 b1 00 00 00    	je     80101408 <bmap+0x128>
        brelse(bp);
80101357:	89 14 24             	mov    %edx,(%esp)
	if((addr = a[bn % bcount]) == 0){
8010135a:	83 e6 7f             	and    $0x7f,%esi
        brelse(bp);
8010135d:	e8 7e ee ff ff       	call   801001e0 <brelse>
	bp = bread(ip->dev, addr);
80101362:	8b 03                	mov    (%ebx),%eax
80101364:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101368:	89 04 24             	mov    %eax,(%esp)
8010136b:	e8 60 ed ff ff       	call   801000d0 <bread>
	if((addr = a[bn % bcount]) == 0){
80101370:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
	bp = bread(ip->dev, addr);
80101374:	89 c7                	mov    %eax,%edi
	if((addr = a[bn % bcount]) == 0){
80101376:	8b 32                	mov    (%edx),%esi
80101378:	85 f6                	test   %esi,%esi
8010137a:	74 38                	je     801013b4 <bmap+0xd4>
	brelse(bp);
8010137c:	89 3c 24             	mov    %edi,(%esp)
8010137f:	e8 5c ee ff ff       	call   801001e0 <brelse>
	return addr;
80101384:	89 f0                	mov    %esi,%eax
}
80101386:	83 c4 1c             	add    $0x1c,%esp
80101389:	5b                   	pop    %ebx
8010138a:	5e                   	pop    %esi
8010138b:	5f                   	pop    %edi
8010138c:	5d                   	pop    %ebp
8010138d:	c3                   	ret    
8010138e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[NDIRECT]) == 0)
80101390:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80101396:	85 c0                	test   %eax,%eax
80101398:	74 5e                	je     801013f8 <bmap+0x118>
    bp = bread(ip->dev, addr);
8010139a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010139e:	8b 03                	mov    (%ebx),%eax
801013a0:	89 04 24             	mov    %eax,(%esp)
801013a3:	e8 28 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013a8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
801013ac:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013ae:	8b 32                	mov    (%edx),%esi
801013b0:	85 f6                	test   %esi,%esi
801013b2:	75 c8                	jne    8010137c <bmap+0x9c>
	  a[bn % bcount] = addr = balloc(ip->dev);
801013b4:	8b 03                	mov    (%ebx),%eax
801013b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013b9:	e8 42 fd ff ff       	call   80101100 <balloc>
801013be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013c1:	89 02                	mov    %eax,(%edx)
801013c3:	89 c6                	mov    %eax,%esi
	  bwrite(bp);
801013c5:	89 3c 24             	mov    %edi,(%esp)
801013c8:	e8 d3 ed ff ff       	call   801001a0 <bwrite>
	brelse(bp);
801013cd:	89 3c 24             	mov    %edi,(%esp)
801013d0:	e8 0b ee ff ff       	call   801001e0 <brelse>
	return addr;
801013d5:	89 f0                	mov    %esi,%eax
801013d7:	eb ad                	jmp    80101386 <bmap+0xa6>
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013e0:	8b 03                	mov    (%ebx),%eax
801013e2:	e8 19 fd ff ff       	call   80101100 <balloc>
801013e7:	89 46 5c             	mov    %eax,0x5c(%esi)
}
801013ea:	83 c4 1c             	add    $0x1c,%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013f8:	8b 03                	mov    (%ebx),%eax
801013fa:	e8 01 fd ff ff       	call   80101100 <balloc>
801013ff:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
80101405:	eb 93                	jmp    8010139a <bmap+0xba>
80101407:	90                   	nop
	  a[index]= addr = balloc(ip->dev);
80101408:	8b 03                	mov    (%ebx),%eax
8010140a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010140d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101410:	e8 eb fc ff ff       	call   80101100 <balloc>
	  bwrite(bp);
80101415:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	  a[index]= addr = balloc(ip->dev);
80101418:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010141b:	89 01                	mov    %eax,(%ecx)
8010141d:	89 c7                	mov    %eax,%edi
	  bwrite(bp);
8010141f:	89 14 24             	mov    %edx,(%esp)
80101422:	e8 79 ed ff ff       	call   801001a0 <bwrite>
80101427:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010142a:	e9 28 ff ff ff       	jmp    80101357 <bmap+0x77>
8010142f:	90                   	nop
	  ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
80101430:	8b 03                	mov    (%ebx),%eax
80101432:	e8 c9 fc ff ff       	call   80101100 <balloc>
80101437:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
8010143d:	e9 f2 fe ff ff       	jmp    80101334 <bmap+0x54>
  panic("bmap: out of range");
80101442:	c7 04 24 65 6d 10 80 	movl   $0x80106d65,(%esp)
80101449:	e8 12 ef ff ff       	call   80100360 <panic>
8010144e:	66 90                	xchg   %ax,%ax

80101450 <readsb>:
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	56                   	push   %esi
80101454:	53                   	push   %ebx
80101455:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101458:	8b 45 08             	mov    0x8(%ebp),%eax
8010145b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101462:	00 
{
80101463:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101466:	89 04 24             	mov    %eax,(%esp)
80101469:	e8 62 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010146e:	89 34 24             	mov    %esi,(%esp)
80101471:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101478:	00 
  bp = bread(dev, 1);
80101479:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010147b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010147e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101482:	e8 59 2f 00 00       	call   801043e0 <memmove>
  brelse(bp);
80101487:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010148a:	83 c4 10             	add    $0x10,%esp
8010148d:	5b                   	pop    %ebx
8010148e:	5e                   	pop    %esi
8010148f:	5d                   	pop    %ebp
  brelse(bp);
80101490:	e9 4b ed ff ff       	jmp    801001e0 <brelse>
80101495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014a0 <bfree>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	57                   	push   %edi
801014a4:	89 d7                	mov    %edx,%edi
801014a6:	56                   	push   %esi
801014a7:	53                   	push   %ebx
801014a8:	89 c3                	mov    %eax,%ebx
801014aa:	83 ec 1c             	sub    $0x1c,%esp
  readsb(dev, &sb);
801014ad:	89 04 24             	mov    %eax,(%esp)
801014b0:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014b7:	80 
801014b8:	e8 93 ff ff ff       	call   80101450 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014bd:	89 fa                	mov    %edi,%edx
801014bf:	c1 ea 0c             	shr    $0xc,%edx
801014c2:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801014c8:	89 1c 24             	mov    %ebx,(%esp)
  m = 1 << (bi % 8);
801014cb:	bb 01 00 00 00       	mov    $0x1,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801014d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801014d4:	e8 f7 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014d9:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
801014db:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
801014e1:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
801014e3:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014e6:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
801014e9:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801014eb:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
801014ed:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
801014f2:	0f b6 c8             	movzbl %al,%ecx
801014f5:	85 d9                	test   %ebx,%ecx
801014f7:	74 20                	je     80101519 <bfree+0x79>
  bp->data[bi/8] &= ~m;
801014f9:	f7 d3                	not    %ebx
801014fb:	21 c3                	and    %eax,%ebx
801014fd:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101501:	89 34 24             	mov    %esi,(%esp)
80101504:	e8 67 18 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101509:	89 34 24             	mov    %esi,(%esp)
8010150c:	e8 cf ec ff ff       	call   801001e0 <brelse>
}
80101511:	83 c4 1c             	add    $0x1c,%esp
80101514:	5b                   	pop    %ebx
80101515:	5e                   	pop    %esi
80101516:	5f                   	pop    %edi
80101517:	5d                   	pop    %ebp
80101518:	c3                   	ret    
    panic("freeing free block");
80101519:	c7 04 24 78 6d 10 80 	movl   $0x80106d78,(%esp)
80101520:	e8 3b ee ff ff       	call   80100360 <panic>
80101525:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <iinit>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	53                   	push   %ebx
80101534:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101539:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010153c:	c7 44 24 04 8b 6d 10 	movl   $0x80106d8b,0x4(%esp)
80101543:	80 
80101544:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010154b:	e8 c0 2b 00 00       	call   80104110 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
80101550:	89 1c 24             	mov    %ebx,(%esp)
80101553:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101559:	c7 44 24 04 92 6d 10 	movl   $0x80106d92,0x4(%esp)
80101560:	80 
80101561:	e8 9a 2a 00 00       	call   80104000 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101566:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010156c:	75 e2                	jne    80101550 <iinit+0x20>
  readsb(dev, &sb);
8010156e:	8b 45 08             	mov    0x8(%ebp),%eax
80101571:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101578:	80 
80101579:	89 04 24             	mov    %eax,(%esp)
8010157c:	e8 cf fe ff ff       	call   80101450 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101581:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101586:	c7 04 24 f8 6d 10 80 	movl   $0x80106df8,(%esp)
8010158d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101591:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101596:	89 44 24 18          	mov    %eax,0x18(%esp)
8010159a:	a1 d0 09 11 80       	mov    0x801109d0,%eax
8010159f:	89 44 24 14          	mov    %eax,0x14(%esp)
801015a3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801015a8:	89 44 24 10          	mov    %eax,0x10(%esp)
801015ac:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801015b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801015b5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801015ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801015be:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801015c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015c7:	e8 84 f0 ff ff       	call   80100650 <cprintf>
}
801015cc:	83 c4 24             	add    $0x24,%esp
801015cf:	5b                   	pop    %ebx
801015d0:	5d                   	pop    %ebp
801015d1:	c3                   	ret    
801015d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801015e0 <ialloc>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	57                   	push   %edi
801015e4:	56                   	push   %esi
801015e5:	53                   	push   %ebx
801015e6:	83 ec 2c             	sub    $0x2c,%esp
801015e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015ec:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015f3:	8b 7d 08             	mov    0x8(%ebp),%edi
801015f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015f9:	0f 86 a2 00 00 00    	jbe    801016a1 <ialloc+0xc1>
801015ff:	be 01 00 00 00       	mov    $0x1,%esi
80101604:	bb 01 00 00 00       	mov    $0x1,%ebx
80101609:	eb 1a                	jmp    80101625 <ialloc+0x45>
8010160b:	90                   	nop
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101610:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101616:	e8 c5 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161b:	89 de                	mov    %ebx,%esi
8010161d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101623:	73 7c                	jae    801016a1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101625:	89 f0                	mov    %esi,%eax
80101627:	c1 e8 03             	shr    $0x3,%eax
8010162a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101630:	89 3c 24             	mov    %edi,(%esp)
80101633:	89 44 24 04          	mov    %eax,0x4(%esp)
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
8010163c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010163e:	89 f0                	mov    %esi,%eax
80101640:	83 e0 07             	and    $0x7,%eax
80101643:	c1 e0 06             	shl    $0x6,%eax
80101646:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010164e:	75 c0                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101650:	89 0c 24             	mov    %ecx,(%esp)
80101653:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010165a:	00 
8010165b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101662:	00 
80101663:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	e8 d2 2c 00 00       	call   80104340 <memset>
      dip->type = type;
8010166e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
80101672:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
80101675:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
80101678:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
8010167b:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167e:	89 14 24             	mov    %edx,(%esp)
80101681:	e8 ea 16 00 00       	call   80102d70 <log_write>
      brelse(bp);
80101686:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101689:	89 14 24             	mov    %edx,(%esp)
8010168c:	e8 4f eb ff ff       	call   801001e0 <brelse>
}
80101691:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
80101694:	89 f2                	mov    %esi,%edx
}
80101696:	5b                   	pop    %ebx
      return iget(dev, inum);
80101697:	89 f8                	mov    %edi,%eax
}
80101699:	5e                   	pop    %esi
8010169a:	5f                   	pop    %edi
8010169b:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169c:	e9 7f fb ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801016a1:	c7 04 24 98 6d 10 80 	movl   $0x80106d98,(%esp)
801016a8:	e8 b3 ec ff ff       	call   80100360 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016be:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c1:	c1 e8 03             	shr    $0x3,%eax
801016c4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801016ce:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 f7 e9 ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d9:	8b 53 a8             	mov    -0x58(%ebx),%edx
801016dc:	83 e2 07             	and    $0x7,%edx
801016df:	c1 e2 06             	shl    $0x6,%edx
801016e2:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e6:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
801016e8:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ec:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
801016ef:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
801016f3:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
801016f7:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
801016fb:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
801016ff:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101703:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101707:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010170b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010170e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101715:	89 14 24             	mov    %edx,(%esp)
80101718:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010171f:	00 
80101720:	e8 bb 2c 00 00       	call   801043e0 <memmove>
  log_write(bp);
80101725:	89 34 24             	mov    %esi,(%esp)
80101728:	e8 43 16 00 00       	call   80102d70 <log_write>
  brelse(bp);
8010172d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101730:	83 c4 10             	add    $0x10,%esp
80101733:	5b                   	pop    %ebx
80101734:	5e                   	pop    %esi
80101735:	5d                   	pop    %ebp
  brelse(bp);
80101736:	e9 a5 ea ff ff       	jmp    801001e0 <brelse>
8010173b:	90                   	nop
8010173c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101740 <idup>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	53                   	push   %ebx
80101744:	83 ec 14             	sub    $0x14,%esp
80101747:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101751:	e8 aa 2a 00 00       	call   80104200 <acquire>
  ip->ref++;
80101756:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101761:	e8 8a 2b 00 00       	call   801042f0 <release>
}
80101766:	83 c4 14             	add    $0x14,%esp
80101769:	89 d8                	mov    %ebx,%eax
8010176b:	5b                   	pop    %ebx
8010176c:	5d                   	pop    %ebp
8010176d:	c3                   	ret    
8010176e:	66 90                	xchg   %ax,%ax

80101770 <ilock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	83 ec 10             	sub    $0x10,%esp
80101778:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177b:	85 db                	test   %ebx,%ebx
8010177d:	0f 84 b3 00 00 00    	je     80101836 <ilock+0xc6>
80101783:	8b 53 08             	mov    0x8(%ebx),%edx
80101786:	85 d2                	test   %edx,%edx
80101788:	0f 8e a8 00 00 00    	jle    80101836 <ilock+0xc6>
  acquiresleep(&ip->lock);
8010178e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101791:	89 04 24             	mov    %eax,(%esp)
80101794:	e8 a7 28 00 00       	call   80104040 <acquiresleep>
  if(ip->valid == 0){
80101799:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179c:	85 c0                	test   %eax,%eax
8010179e:	74 08                	je     801017a8 <ilock+0x38>
}
801017a0:	83 c4 10             	add    $0x10,%esp
801017a3:	5b                   	pop    %ebx
801017a4:	5e                   	pop    %esi
801017a5:	5d                   	pop    %ebp
801017a6:	c3                   	ret    
801017a7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a8:	8b 43 04             	mov    0x4(%ebx),%eax
801017ab:	c1 e8 03             	shr    $0x3,%eax
801017ae:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801017b8:	8b 03                	mov    (%ebx),%eax
801017ba:	89 04 24             	mov    %eax,(%esp)
801017bd:	e8 0e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017c2:	8b 53 04             	mov    0x4(%ebx),%edx
801017c5:	83 e2 07             	and    $0x7,%edx
801017c8:	c1 e2 06             	shl    $0x6,%edx
801017cb:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017cf:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
801017d1:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d4:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
801017d7:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
801017db:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
801017df:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
801017e3:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
801017e7:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
801017eb:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
801017ef:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
801017f3:	8b 42 fc             	mov    -0x4(%edx),%eax
801017f6:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f9:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017fc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101800:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101807:	00 
80101808:	89 04 24             	mov    %eax,(%esp)
8010180b:	e8 d0 2b 00 00       	call   801043e0 <memmove>
    brelse(bp);
80101810:	89 34 24             	mov    %esi,(%esp)
80101813:	e8 c8 e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 76 ff ff ff    	jne    801017a0 <ilock+0x30>
      panic("ilock: no type");
8010182a:	c7 04 24 b0 6d 10 80 	movl   $0x80106db0,(%esp)
80101831:	e8 2a eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101836:	c7 04 24 aa 6d 10 80 	movl   $0x80106daa,(%esp)
8010183d:	e8 1e eb ff ff       	call   80100360 <panic>
80101842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101850 <iunlock>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	56                   	push   %esi
80101854:	53                   	push   %ebx
80101855:	83 ec 10             	sub    $0x10,%esp
80101858:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185b:	85 db                	test   %ebx,%ebx
8010185d:	74 24                	je     80101883 <iunlock+0x33>
8010185f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101862:	89 34 24             	mov    %esi,(%esp)
80101865:	e8 76 28 00 00       	call   801040e0 <holdingsleep>
8010186a:	85 c0                	test   %eax,%eax
8010186c:	74 15                	je     80101883 <iunlock+0x33>
8010186e:	8b 43 08             	mov    0x8(%ebx),%eax
80101871:	85 c0                	test   %eax,%eax
80101873:	7e 0e                	jle    80101883 <iunlock+0x33>
  releasesleep(&ip->lock);
80101875:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	5b                   	pop    %ebx
8010187c:	5e                   	pop    %esi
8010187d:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010187e:	e9 1d 28 00 00       	jmp    801040a0 <releasesleep>
    panic("iunlock");
80101883:	c7 04 24 bf 6d 10 80 	movl   $0x80106dbf,(%esp)
8010188a:	e8 d1 ea ff ff       	call   80100360 <panic>
8010188f:	90                   	nop

80101890 <iput>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	57                   	push   %edi
80101894:	56                   	push   %esi
80101895:	53                   	push   %ebx
80101896:	83 ec 1c             	sub    $0x1c,%esp
80101899:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010189c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010189f:	89 3c 24             	mov    %edi,(%esp)
801018a2:	e8 99 27 00 00       	call   80104040 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a7:	8b 56 4c             	mov    0x4c(%esi),%edx
801018aa:	85 d2                	test   %edx,%edx
801018ac:	74 07                	je     801018b5 <iput+0x25>
801018ae:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801018b3:	74 2b                	je     801018e0 <iput+0x50>
  releasesleep(&ip->lock);
801018b5:	89 3c 24             	mov    %edi,(%esp)
801018b8:	e8 e3 27 00 00       	call   801040a0 <releasesleep>
  acquire(&icache.lock);
801018bd:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018c4:	e8 37 29 00 00       	call   80104200 <acquire>
  ip->ref--;
801018c9:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801018cd:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018d4:	83 c4 1c             	add    $0x1c,%esp
801018d7:	5b                   	pop    %ebx
801018d8:	5e                   	pop    %esi
801018d9:	5f                   	pop    %edi
801018da:	5d                   	pop    %ebp
  release(&icache.lock);
801018db:	e9 10 2a 00 00       	jmp    801042f0 <release>
    acquire(&icache.lock);
801018e0:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018e7:	e8 14 29 00 00       	call   80104200 <acquire>
    int r = ip->ref;
801018ec:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801018ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018f6:	e8 f5 29 00 00       	call   801042f0 <release>
    if(r == 1){
801018fb:	83 fb 01             	cmp    $0x1,%ebx
801018fe:	75 b5                	jne    801018b5 <iput+0x25>
80101900:	8d 4e 2c             	lea    0x2c(%esi),%ecx
80101903:	89 f3                	mov    %esi,%ebx
80101905:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101908:	89 cf                	mov    %ecx,%edi
8010190a:	eb 0b                	jmp    80101917 <iput+0x87>
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101910:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101913:	39 fb                	cmp    %edi,%ebx
80101915:	74 19                	je     80101930 <iput+0xa0>
    if(ip->addrs[i]){
80101917:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010191a:	85 d2                	test   %edx,%edx
8010191c:	74 f2                	je     80101910 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010191e:	8b 06                	mov    (%esi),%eax
80101920:	e8 7b fb ff ff       	call   801014a0 <bfree>
      ip->addrs[i] = 0;
80101925:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010192c:	eb e2                	jmp    80101910 <iput+0x80>
8010192e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101930:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80101936:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101939:	85 c0                	test   %eax,%eax
8010193b:	75 2b                	jne    80101968 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010193d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101944:	89 34 24             	mov    %esi,(%esp)
80101947:	e8 64 fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
8010194c:	31 c0                	xor    %eax,%eax
8010194e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101952:	89 34 24             	mov    %esi,(%esp)
80101955:	e8 56 fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
8010195a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101961:	e9 4f ff ff ff       	jmp    801018b5 <iput+0x25>
80101966:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101968:	89 44 24 04          	mov    %eax,0x4(%esp)
8010196c:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
8010196e:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101970:	89 04 24             	mov    %eax,(%esp)
80101973:	e8 58 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101978:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
8010197b:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010197e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101981:	89 cf                	mov    %ecx,%edi
80101983:	31 c0                	xor    %eax,%eax
80101985:	eb 0e                	jmp    80101995 <iput+0x105>
80101987:	90                   	nop
80101988:	83 c3 01             	add    $0x1,%ebx
8010198b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101991:	89 d8                	mov    %ebx,%eax
80101993:	74 10                	je     801019a5 <iput+0x115>
      if(a[j])
80101995:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101998:	85 d2                	test   %edx,%edx
8010199a:	74 ec                	je     80101988 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010199c:	8b 06                	mov    (%esi),%eax
8010199e:	e8 fd fa ff ff       	call   801014a0 <bfree>
801019a3:	eb e3                	jmp    80101988 <iput+0xf8>
    brelse(bp);
801019a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019ab:	89 04 24             	mov    %eax,(%esp)
801019ae:	e8 2d e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019b3:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
801019b9:	8b 06                	mov    (%esi),%eax
801019bb:	e8 e0 fa ff ff       	call   801014a0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019c0:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
801019c7:	00 00 00 
801019ca:	e9 6e ff ff ff       	jmp    8010193d <iput+0xad>
801019cf:	90                   	nop

801019d0 <iunlockput>:
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	53                   	push   %ebx
801019d4:	83 ec 14             	sub    $0x14,%esp
801019d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019da:	89 1c 24             	mov    %ebx,(%esp)
801019dd:	e8 6e fe ff ff       	call   80101850 <iunlock>
  iput(ip);
801019e2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801019e5:	83 c4 14             	add    $0x14,%esp
801019e8:	5b                   	pop    %ebx
801019e9:	5d                   	pop    %ebp
  iput(ip);
801019ea:	e9 a1 fe ff ff       	jmp    80101890 <iput>
801019ef:	90                   	nop

801019f0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	8b 55 08             	mov    0x8(%ebp),%edx
801019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019f9:	8b 0a                	mov    (%edx),%ecx
801019fb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019fe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a13:	8b 52 58             	mov    0x58(%edx),%edx
80101a16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a19:	5d                   	pop    %ebp
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	83 ec 2c             	sub    $0x2c,%esp
80101a29:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a2c:	8b 7d 08             	mov    0x8(%ebp),%edi
80101a2f:	8b 75 10             	mov    0x10(%ebp),%esi
80101a32:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a35:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a38:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
80101a3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a40:	0f 84 aa 00 00 00    	je     80101af0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a46:	8b 47 58             	mov    0x58(%edi),%eax
80101a49:	39 f0                	cmp    %esi,%eax
80101a4b:	0f 82 c7 00 00 00    	jb     80101b18 <readi+0xf8>
80101a51:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a54:	89 da                	mov    %ebx,%edx
80101a56:	01 f2                	add    %esi,%edx
80101a58:	0f 82 ba 00 00 00    	jb     80101b18 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a5e:	89 c1                	mov    %eax,%ecx
80101a60:	29 f1                	sub    %esi,%ecx
80101a62:	39 d0                	cmp    %edx,%eax
80101a64:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a67:	31 c0                	xor    %eax,%eax
80101a69:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
80101a6b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a6e:	74 70                	je     80101ae0 <readi+0xc0>
80101a70:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101a73:	89 c7                	mov    %eax,%edi
80101a75:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a78:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a7b:	89 f2                	mov    %esi,%edx
80101a7d:	c1 ea 09             	shr    $0x9,%edx
80101a80:	89 d8                	mov    %ebx,%eax
80101a82:	e8 59 f8 ff ff       	call   801012e0 <bmap>
80101a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a8b:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a8d:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a92:	89 04 24             	mov    %eax,(%esp)
80101a95:	e8 36 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a9d:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a9f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa1:	89 f0                	mov    %esi,%eax
80101aa3:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aa8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101aaa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101aae:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ab4:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101aba:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abe:	01 df                	add    %ebx,%edi
80101ac0:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ac2:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ac5:	89 04 24             	mov    %eax,(%esp)
80101ac8:	e8 13 29 00 00       	call   801043e0 <memmove>
    brelse(bp);
80101acd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ad0:	89 14 24             	mov    %edx,(%esp)
80101ad3:	e8 08 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ad8:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101adb:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ade:	77 98                	ja     80101a78 <readi+0x58>
  }
  return n;
80101ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ae3:	83 c4 2c             	add    $0x2c,%esp
80101ae6:	5b                   	pop    %ebx
80101ae7:	5e                   	pop    %esi
80101ae8:	5f                   	pop    %edi
80101ae9:	5d                   	pop    %ebp
80101aea:	c3                   	ret    
80101aeb:	90                   	nop
80101aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101af0:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101af4:	66 83 f8 09          	cmp    $0x9,%ax
80101af8:	77 1e                	ja     80101b18 <readi+0xf8>
80101afa:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b01:	85 c0                	test   %eax,%eax
80101b03:	74 13                	je     80101b18 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101b05:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b08:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101b0b:	83 c4 2c             	add    $0x2c,%esp
80101b0e:	5b                   	pop    %ebx
80101b0f:	5e                   	pop    %esi
80101b10:	5f                   	pop    %edi
80101b11:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b12:	ff e0                	jmp    *%eax
80101b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b1d:	eb c4                	jmp    80101ae3 <readi+0xc3>
80101b1f:	90                   	nop

80101b20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 2c             	sub    $0x2c,%esp
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b3a:	8b 75 10             	mov    0x10(%ebp),%esi
80101b3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b40:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b43:	0f 84 b7 00 00 00    	je     80101c00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b4f:	0f 82 e3 00 00 00    	jb     80101c38 <writei+0x118>
80101b55:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b58:	89 c8                	mov    %ecx,%eax
80101b5a:	01 f0                	add    %esi,%eax
80101b5c:	0f 82 d6 00 00 00    	jb     80101c38 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b62:	3d 00 16 81 00       	cmp    $0x811600,%eax
80101b67:	0f 87 cb 00 00 00    	ja     80101c38 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b6d:	85 c9                	test   %ecx,%ecx
80101b6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b76:	74 77                	je     80101bef <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b78:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b7b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7d:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b82:	c1 ea 09             	shr    $0x9,%edx
80101b85:	89 f8                	mov    %edi,%eax
80101b87:	e8 54 f7 ff ff       	call   801012e0 <bmap>
80101b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b90:	8b 07                	mov    (%edi),%eax
80101b92:	89 04 24             	mov    %eax,(%esp)
80101b95:	e8 36 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b9a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b9d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ba0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba5:	89 f0                	mov    %esi,%eax
80101ba7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bac:	29 c3                	sub    %eax,%ebx
80101bae:	39 cb                	cmp    %ecx,%ebx
80101bb0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bb3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb7:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bb9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bbd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101bc1:	89 04 24             	mov    %eax,(%esp)
80101bc4:	e8 17 28 00 00       	call   801043e0 <memmove>
    log_write(bp);
80101bc9:	89 3c 24             	mov    %edi,(%esp)
80101bcc:	e8 9f 11 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101bd1:	89 3c 24             	mov    %edi,(%esp)
80101bd4:	e8 07 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bdf:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101be2:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101be5:	77 91                	ja     80101b78 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101be7:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bea:	39 70 58             	cmp    %esi,0x58(%eax)
80101bed:	72 39                	jb     80101c28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bf2:	83 c4 2c             	add    $0x2c,%esp
80101bf5:	5b                   	pop    %ebx
80101bf6:	5e                   	pop    %esi
80101bf7:	5f                   	pop    %edi
80101bf8:	5d                   	pop    %ebp
80101bf9:	c3                   	ret    
80101bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c04:	66 83 f8 09          	cmp    $0x9,%ax
80101c08:	77 2e                	ja     80101c38 <writei+0x118>
80101c0a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c11:	85 c0                	test   %eax,%eax
80101c13:	74 23                	je     80101c38 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101c15:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101c18:	83 c4 2c             	add    $0x2c,%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c1f:	ff e0                	jmp    *%eax
80101c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c28:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c2e:	89 04 24             	mov    %eax,(%esp)
80101c31:	e8 7a fa ff ff       	call   801016b0 <iupdate>
80101c36:	eb b7                	jmp    80101bef <writei+0xcf>
}
80101c38:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101c3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101c40:	5b                   	pop    %ebx
80101c41:	5e                   	pop    %esi
80101c42:	5f                   	pop    %edi
80101c43:	5d                   	pop    %ebp
80101c44:	c3                   	ret    
80101c45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101c56:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c59:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c60:	00 
80101c61:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c65:	8b 45 08             	mov    0x8(%ebp),%eax
80101c68:	89 04 24             	mov    %eax,(%esp)
80101c6b:	e8 f0 27 00 00       	call   80104460 <strncmp>
}
80101c70:	c9                   	leave  
80101c71:	c3                   	ret    
80101c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c80 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	83 ec 2c             	sub    $0x2c,%esp
80101c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c8c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c91:	0f 85 97 00 00 00    	jne    80101d2e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c97:	8b 53 58             	mov    0x58(%ebx),%edx
80101c9a:	31 ff                	xor    %edi,%edi
80101c9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c9f:	85 d2                	test   %edx,%edx
80101ca1:	75 0d                	jne    80101cb0 <dirlookup+0x30>
80101ca3:	eb 73                	jmp    80101d18 <dirlookup+0x98>
80101ca5:	8d 76 00             	lea    0x0(%esi),%esi
80101ca8:	83 c7 10             	add    $0x10,%edi
80101cab:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101cae:	76 68                	jbe    80101d18 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cb0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101cb7:	00 
80101cb8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101cbc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101cc0:	89 1c 24             	mov    %ebx,(%esp)
80101cc3:	e8 58 fd ff ff       	call   80101a20 <readi>
80101cc8:	83 f8 10             	cmp    $0x10,%eax
80101ccb:	75 55                	jne    80101d22 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101ccd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cd2:	74 d4                	je     80101ca8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101cd4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cde:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ce5:	00 
80101ce6:	89 04 24             	mov    %eax,(%esp)
80101ce9:	e8 72 27 00 00       	call   80104460 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101cee:	85 c0                	test   %eax,%eax
80101cf0:	75 b6                	jne    80101ca8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101cf2:	8b 45 10             	mov    0x10(%ebp),%eax
80101cf5:	85 c0                	test   %eax,%eax
80101cf7:	74 05                	je     80101cfe <dirlookup+0x7e>
        *poff = off;
80101cf9:	8b 45 10             	mov    0x10(%ebp),%eax
80101cfc:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cfe:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d02:	8b 03                	mov    (%ebx),%eax
80101d04:	e8 17 f5 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101d09:	83 c4 2c             	add    $0x2c,%esp
80101d0c:	5b                   	pop    %ebx
80101d0d:	5e                   	pop    %esi
80101d0e:	5f                   	pop    %edi
80101d0f:	5d                   	pop    %ebp
80101d10:	c3                   	ret    
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d18:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101d1b:	31 c0                	xor    %eax,%eax
}
80101d1d:	5b                   	pop    %ebx
80101d1e:	5e                   	pop    %esi
80101d1f:	5f                   	pop    %edi
80101d20:	5d                   	pop    %ebp
80101d21:	c3                   	ret    
      panic("dirlookup read");
80101d22:	c7 04 24 d9 6d 10 80 	movl   $0x80106dd9,(%esp)
80101d29:	e8 32 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101d2e:	c7 04 24 c7 6d 10 80 	movl   $0x80106dc7,(%esp)
80101d35:	e8 26 e6 ff ff       	call   80100360 <panic>
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	89 cf                	mov    %ecx,%edi
80101d46:	56                   	push   %esi
80101d47:	53                   	push   %ebx
80101d48:	89 c3                	mov    %eax,%ebx
80101d4a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d4d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d50:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d53:	0f 84 51 01 00 00    	je     80101eaa <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d59:	e8 02 1a 00 00       	call   80103760 <myproc>
80101d5e:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d61:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d68:	e8 93 24 00 00       	call   80104200 <acquire>
  ip->ref++;
80101d6d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d71:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d78:	e8 73 25 00 00       	call   801042f0 <release>
80101d7d:	eb 04                	jmp    80101d83 <namex+0x43>
80101d7f:	90                   	nop
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d83:	0f b6 03             	movzbl (%ebx),%eax
80101d86:	3c 2f                	cmp    $0x2f,%al
80101d88:	74 f6                	je     80101d80 <namex+0x40>
  if(*path == 0)
80101d8a:	84 c0                	test   %al,%al
80101d8c:	0f 84 ed 00 00 00    	je     80101e7f <namex+0x13f>
  while(*path != '/' && *path != 0)
80101d92:	0f b6 03             	movzbl (%ebx),%eax
80101d95:	89 da                	mov    %ebx,%edx
80101d97:	84 c0                	test   %al,%al
80101d99:	0f 84 b1 00 00 00    	je     80101e50 <namex+0x110>
80101d9f:	3c 2f                	cmp    $0x2f,%al
80101da1:	75 0f                	jne    80101db2 <namex+0x72>
80101da3:	e9 a8 00 00 00       	jmp    80101e50 <namex+0x110>
80101da8:	3c 2f                	cmp    $0x2f,%al
80101daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101db0:	74 0a                	je     80101dbc <namex+0x7c>
    path++;
80101db2:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101db5:	0f b6 02             	movzbl (%edx),%eax
80101db8:	84 c0                	test   %al,%al
80101dba:	75 ec                	jne    80101da8 <namex+0x68>
80101dbc:	89 d1                	mov    %edx,%ecx
80101dbe:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101dc0:	83 f9 0d             	cmp    $0xd,%ecx
80101dc3:	0f 8e 8f 00 00 00    	jle    80101e58 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101dc9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dcd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101dd4:	00 
80101dd5:	89 3c 24             	mov    %edi,(%esp)
80101dd8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ddb:	e8 00 26 00 00       	call   801043e0 <memmove>
    path++;
80101de0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101de3:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101de5:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101de8:	75 0e                	jne    80101df8 <namex+0xb8>
80101dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101df0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101df3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101df6:	74 f8                	je     80101df0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101df8:	89 34 24             	mov    %esi,(%esp)
80101dfb:	e8 70 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e00:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e05:	0f 85 85 00 00 00    	jne    80101e90 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e0e:	85 d2                	test   %edx,%edx
80101e10:	74 09                	je     80101e1b <namex+0xdb>
80101e12:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e15:	0f 84 a5 00 00 00    	je     80101ec0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e22:	00 
80101e23:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101e27:	89 34 24             	mov    %esi,(%esp)
80101e2a:	e8 51 fe ff ff       	call   80101c80 <dirlookup>
80101e2f:	85 c0                	test   %eax,%eax
80101e31:	74 5d                	je     80101e90 <namex+0x150>
  iunlock(ip);
80101e33:	89 34 24             	mov    %esi,(%esp)
80101e36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e39:	e8 12 fa ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e3e:	89 34 24             	mov    %esi,(%esp)
80101e41:	e8 4a fa ff ff       	call   80101890 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e49:	89 c6                	mov    %eax,%esi
80101e4b:	e9 33 ff ff ff       	jmp    80101d83 <namex+0x43>
  while(*path != '/' && *path != 0)
80101e50:	31 c9                	xor    %ecx,%ecx
80101e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101e58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101e5c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101e60:	89 3c 24             	mov    %edi,(%esp)
80101e63:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e66:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e69:	e8 72 25 00 00       	call   801043e0 <memmove>
    name[len] = 0;
80101e6e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e74:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e78:	89 d3                	mov    %edx,%ebx
80101e7a:	e9 66 ff ff ff       	jmp    80101de5 <namex+0xa5>
  }
  if(nameiparent){
80101e7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e82:	85 c0                	test   %eax,%eax
80101e84:	75 4c                	jne    80101ed2 <namex+0x192>
80101e86:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e88:	83 c4 2c             	add    $0x2c,%esp
80101e8b:	5b                   	pop    %ebx
80101e8c:	5e                   	pop    %esi
80101e8d:	5f                   	pop    %edi
80101e8e:	5d                   	pop    %ebp
80101e8f:	c3                   	ret    
  iunlock(ip);
80101e90:	89 34 24             	mov    %esi,(%esp)
80101e93:	e8 b8 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e98:	89 34 24             	mov    %esi,(%esp)
80101e9b:	e8 f0 f9 ff ff       	call   80101890 <iput>
}
80101ea0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101ea3:	31 c0                	xor    %eax,%eax
}
80101ea5:	5b                   	pop    %ebx
80101ea6:	5e                   	pop    %esi
80101ea7:	5f                   	pop    %edi
80101ea8:	5d                   	pop    %ebp
80101ea9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101eaa:	ba 01 00 00 00       	mov    $0x1,%edx
80101eaf:	b8 01 00 00 00       	mov    $0x1,%eax
80101eb4:	e8 67 f3 ff ff       	call   80101220 <iget>
80101eb9:	89 c6                	mov    %eax,%esi
80101ebb:	e9 c3 fe ff ff       	jmp    80101d83 <namex+0x43>
      iunlock(ip);
80101ec0:	89 34 24             	mov    %esi,(%esp)
80101ec3:	e8 88 f9 ff ff       	call   80101850 <iunlock>
}
80101ec8:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101ecb:	89 f0                	mov    %esi,%eax
}
80101ecd:	5b                   	pop    %ebx
80101ece:	5e                   	pop    %esi
80101ecf:	5f                   	pop    %edi
80101ed0:	5d                   	pop    %ebp
80101ed1:	c3                   	ret    
    iput(ip);
80101ed2:	89 34 24             	mov    %esi,(%esp)
80101ed5:	e8 b6 f9 ff ff       	call   80101890 <iput>
    return 0;
80101eda:	31 c0                	xor    %eax,%eax
80101edc:	eb aa                	jmp    80101e88 <namex+0x148>
80101ede:	66 90                	xchg   %ax,%ax

80101ee0 <dirlink>:
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	56                   	push   %esi
80101ee5:	53                   	push   %ebx
80101ee6:	83 ec 2c             	sub    $0x2c,%esp
80101ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101eec:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101ef6:	00 
80101ef7:	89 1c 24             	mov    %ebx,(%esp)
80101efa:	89 44 24 04          	mov    %eax,0x4(%esp)
80101efe:	e8 7d fd ff ff       	call   80101c80 <dirlookup>
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 8b 00 00 00    	jne    80101f96 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f0b:	8b 43 58             	mov    0x58(%ebx),%eax
80101f0e:	31 ff                	xor    %edi,%edi
80101f10:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f13:	85 c0                	test   %eax,%eax
80101f15:	75 13                	jne    80101f2a <dirlink+0x4a>
80101f17:	eb 35                	jmp    80101f4e <dirlink+0x6e>
80101f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f20:	8d 57 10             	lea    0x10(%edi),%edx
80101f23:	39 53 58             	cmp    %edx,0x58(%ebx)
80101f26:	89 d7                	mov    %edx,%edi
80101f28:	76 24                	jbe    80101f4e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f2a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f31:	00 
80101f32:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101f36:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f3a:	89 1c 24             	mov    %ebx,(%esp)
80101f3d:	e8 de fa ff ff       	call   80101a20 <readi>
80101f42:	83 f8 10             	cmp    $0x10,%eax
80101f45:	75 5e                	jne    80101fa5 <dirlink+0xc5>
    if(de.inum == 0)
80101f47:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f4c:	75 d2                	jne    80101f20 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f51:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101f58:	00 
80101f59:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f5d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f60:	89 04 24             	mov    %eax,(%esp)
80101f63:	e8 68 25 00 00       	call   801044d0 <strncpy>
  de.inum = inum;
80101f68:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f6b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101f72:	00 
80101f73:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101f77:	89 74 24 04          	mov    %esi,0x4(%esp)
80101f7b:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101f7e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f82:	e8 99 fb ff ff       	call   80101b20 <writei>
80101f87:	83 f8 10             	cmp    $0x10,%eax
80101f8a:	75 25                	jne    80101fb1 <dirlink+0xd1>
  return 0;
80101f8c:	31 c0                	xor    %eax,%eax
}
80101f8e:	83 c4 2c             	add    $0x2c,%esp
80101f91:	5b                   	pop    %ebx
80101f92:	5e                   	pop    %esi
80101f93:	5f                   	pop    %edi
80101f94:	5d                   	pop    %ebp
80101f95:	c3                   	ret    
    iput(ip);
80101f96:	89 04 24             	mov    %eax,(%esp)
80101f99:	e8 f2 f8 ff ff       	call   80101890 <iput>
    return -1;
80101f9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fa3:	eb e9                	jmp    80101f8e <dirlink+0xae>
      panic("dirlink read");
80101fa5:	c7 04 24 e8 6d 10 80 	movl   $0x80106de8,(%esp)
80101fac:	e8 af e3 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101fb1:	c7 04 24 de 73 10 80 	movl   $0x801073de,(%esp)
80101fb8:	e8 a3 e3 ff ff       	call   80100360 <panic>
80101fbd:	8d 76 00             	lea    0x0(%esi),%esi

80101fc0 <namei>:

struct inode*
namei(char *path)
{
80101fc0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fc1:	31 d2                	xor    %edx,%edx
{
80101fc3:	89 e5                	mov    %esp,%ebp
80101fc5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fce:	e8 6d fd ff ff       	call   80101d40 <namex>
}
80101fd3:	c9                   	leave  
80101fd4:	c3                   	ret    
80101fd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fe0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fe1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fe6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fe8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101feb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fee:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fef:	e9 4c fd ff ff       	jmp    80101d40 <namex>
80101ff4:	66 90                	xchg   %ax,%ax
80101ff6:	66 90                	xchg   %ax,%ax
80101ff8:	66 90                	xchg   %ax,%ax
80101ffa:	66 90                	xchg   %ax,%ax
80101ffc:	66 90                	xchg   %ax,%ax
80101ffe:	66 90                	xchg   %ax,%ax

80102000 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	56                   	push   %esi
80102004:	89 c6                	mov    %eax,%esi
80102006:	53                   	push   %ebx
80102007:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
8010200a:	85 c0                	test   %eax,%eax
8010200c:	0f 84 99 00 00 00    	je     801020ab <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102012:	8b 48 08             	mov    0x8(%eax),%ecx
80102015:	81 f9 1f 4e 00 00    	cmp    $0x4e1f,%ecx
8010201b:	0f 87 7e 00 00 00    	ja     8010209f <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102021:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102026:	66 90                	xchg   %ax,%ax
80102028:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	31 db                	xor    %ebx,%ebx
80102032:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102037:	89 d8                	mov    %ebx,%eax
80102039:	ee                   	out    %al,(%dx)
8010203a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010203f:	b8 01 00 00 00       	mov    $0x1,%eax
80102044:	ee                   	out    %al,(%dx)
80102045:	0f b6 c1             	movzbl %cl,%eax
80102048:	b2 f3                	mov    $0xf3,%dl
8010204a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010204b:	89 c8                	mov    %ecx,%eax
8010204d:	b2 f4                	mov    $0xf4,%dl
8010204f:	c1 f8 08             	sar    $0x8,%eax
80102052:	ee                   	out    %al,(%dx)
80102053:	b2 f5                	mov    $0xf5,%dl
80102055:	89 d8                	mov    %ebx,%eax
80102057:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102058:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010205c:	b2 f6                	mov    $0xf6,%dl
8010205e:	83 e0 01             	and    $0x1,%eax
80102061:	c1 e0 04             	shl    $0x4,%eax
80102064:	83 c8 e0             	or     $0xffffffe0,%eax
80102067:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102068:	f6 06 04             	testb  $0x4,(%esi)
8010206b:	75 13                	jne    80102080 <idestart+0x80>
8010206d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102072:	b8 20 00 00 00       	mov    $0x20,%eax
80102077:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102078:	83 c4 10             	add    $0x10,%esp
8010207b:	5b                   	pop    %ebx
8010207c:	5e                   	pop    %esi
8010207d:	5d                   	pop    %ebp
8010207e:	c3                   	ret    
8010207f:	90                   	nop
80102080:	b2 f7                	mov    $0xf7,%dl
80102082:	b8 30 00 00 00       	mov    $0x30,%eax
80102087:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102088:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010208d:	83 c6 5c             	add    $0x5c,%esi
80102090:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102095:	fc                   	cld    
80102096:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102098:	83 c4 10             	add    $0x10,%esp
8010209b:	5b                   	pop    %ebx
8010209c:	5e                   	pop    %esi
8010209d:	5d                   	pop    %ebp
8010209e:	c3                   	ret    
    panic("incorrect blockno");
8010209f:	c7 04 24 54 6e 10 80 	movl   $0x80106e54,(%esp)
801020a6:	e8 b5 e2 ff ff       	call   80100360 <panic>
    panic("idestart");
801020ab:	c7 04 24 4b 6e 10 80 	movl   $0x80106e4b,(%esp)
801020b2:	e8 a9 e2 ff ff       	call   80100360 <panic>
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020c0 <ideinit>:
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
801020c6:	c7 44 24 04 66 6e 10 	movl   $0x80106e66,0x4(%esp)
801020cd:	80 
801020ce:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020d5:	e8 36 20 00 00       	call   80104110 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020da:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020df:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801020e6:	83 e8 01             	sub    $0x1,%eax
801020e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801020ed:	e8 7e 02 00 00       	call   80102370 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020f7:	90                   	nop
801020f8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f9:	83 e0 c0             	and    $0xffffffc0,%eax
801020fc:	3c 40                	cmp    $0x40,%al
801020fe:	75 f8                	jne    801020f8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102100:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102105:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010210a:	ee                   	out    %al,(%dx)
8010210b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102110:	b2 f7                	mov    $0xf7,%dl
80102112:	eb 09                	jmp    8010211d <ideinit+0x5d>
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102118:	83 e9 01             	sub    $0x1,%ecx
8010211b:	74 0f                	je     8010212c <ideinit+0x6c>
8010211d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010211e:	84 c0                	test   %al,%al
80102120:	74 f6                	je     80102118 <ideinit+0x58>
      havedisk1 = 1;
80102122:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102129:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010212c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102131:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102136:	ee                   	out    %al,(%dx)
}
80102137:	c9                   	leave  
80102138:	c3                   	ret    
80102139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102140 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102149:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102150:	e8 ab 20 00 00       	call   80104200 <acquire>

  if((b = idequeue) == 0){
80102155:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010215b:	85 db                	test   %ebx,%ebx
8010215d:	74 30                	je     8010218f <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010215f:	8b 43 58             	mov    0x58(%ebx),%eax
80102162:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102167:	8b 33                	mov    (%ebx),%esi
80102169:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010216f:	74 37                	je     801021a8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102171:	83 e6 fb             	and    $0xfffffffb,%esi
80102174:	83 ce 02             	or     $0x2,%esi
80102177:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102179:	89 1c 24             	mov    %ebx,(%esp)
8010217c:	e8 cf 1c 00 00       	call   80103e50 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102181:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102186:	85 c0                	test   %eax,%eax
80102188:	74 05                	je     8010218f <ideintr+0x4f>
    idestart(idequeue);
8010218a:	e8 71 fe ff ff       	call   80102000 <idestart>
    release(&idelock);
8010218f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102196:	e8 55 21 00 00       	call   801042f0 <release>

  release(&idelock);
}
8010219b:	83 c4 1c             	add    $0x1c,%esp
8010219e:	5b                   	pop    %ebx
8010219f:	5e                   	pop    %esi
801021a0:	5f                   	pop    %edi
801021a1:	5d                   	pop    %ebp
801021a2:	c3                   	ret    
801021a3:	90                   	nop
801021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ad:	8d 76 00             	lea    0x0(%esi),%esi
801021b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021b1:	89 c1                	mov    %eax,%ecx
801021b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801021b6:	80 f9 40             	cmp    $0x40,%cl
801021b9:	75 f5                	jne    801021b0 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021bb:	a8 21                	test   $0x21,%al
801021bd:	75 b2                	jne    80102171 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
801021bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021cc:	fc                   	cld    
801021cd:	f3 6d                	rep insl (%dx),%es:(%edi)
801021cf:	8b 33                	mov    (%ebx),%esi
801021d1:	eb 9e                	jmp    80102171 <ideintr+0x31>
801021d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	53                   	push   %ebx
801021e4:	83 ec 14             	sub    $0x14,%esp
801021e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801021ed:	89 04 24             	mov    %eax,(%esp)
801021f0:	e8 eb 1e 00 00       	call   801040e0 <holdingsleep>
801021f5:	85 c0                	test   %eax,%eax
801021f7:	0f 84 9e 00 00 00    	je     8010229b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021fd:	8b 03                	mov    (%ebx),%eax
801021ff:	83 e0 06             	and    $0x6,%eax
80102202:	83 f8 02             	cmp    $0x2,%eax
80102205:	0f 84 a8 00 00 00    	je     801022b3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010220b:	8b 53 04             	mov    0x4(%ebx),%edx
8010220e:	85 d2                	test   %edx,%edx
80102210:	74 0d                	je     8010221f <iderw+0x3f>
80102212:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102217:	85 c0                	test   %eax,%eax
80102219:	0f 84 88 00 00 00    	je     801022a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010221f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102226:	e8 d5 1f 00 00       	call   80104200 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010222b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102230:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102237:	85 c0                	test   %eax,%eax
80102239:	75 07                	jne    80102242 <iderw+0x62>
8010223b:	eb 4e                	jmp    8010228b <iderw+0xab>
8010223d:	8d 76 00             	lea    0x0(%esi),%esi
80102240:	89 d0                	mov    %edx,%eax
80102242:	8b 50 58             	mov    0x58(%eax),%edx
80102245:	85 d2                	test   %edx,%edx
80102247:	75 f7                	jne    80102240 <iderw+0x60>
80102249:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010224c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010224e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102254:	74 3c                	je     80102292 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102256:	8b 03                	mov    (%ebx),%eax
80102258:	83 e0 06             	and    $0x6,%eax
8010225b:	83 f8 02             	cmp    $0x2,%eax
8010225e:	74 1a                	je     8010227a <iderw+0x9a>
    sleep(b, &idelock);
80102260:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102267:	80 
80102268:	89 1c 24             	mov    %ebx,(%esp)
8010226b:	e8 50 1a 00 00       	call   80103cc0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102270:	8b 13                	mov    (%ebx),%edx
80102272:	83 e2 06             	and    $0x6,%edx
80102275:	83 fa 02             	cmp    $0x2,%edx
80102278:	75 e6                	jne    80102260 <iderw+0x80>
  }


  release(&idelock);
8010227a:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102281:	83 c4 14             	add    $0x14,%esp
80102284:	5b                   	pop    %ebx
80102285:	5d                   	pop    %ebp
  release(&idelock);
80102286:	e9 65 20 00 00       	jmp    801042f0 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010228b:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
80102290:	eb ba                	jmp    8010224c <iderw+0x6c>
    idestart(b);
80102292:	89 d8                	mov    %ebx,%eax
80102294:	e8 67 fd ff ff       	call   80102000 <idestart>
80102299:	eb bb                	jmp    80102256 <iderw+0x76>
    panic("iderw: buf not locked");
8010229b:	c7 04 24 6a 6e 10 80 	movl   $0x80106e6a,(%esp)
801022a2:	e8 b9 e0 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801022a7:	c7 04 24 95 6e 10 80 	movl   $0x80106e95,(%esp)
801022ae:	e8 ad e0 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
801022b3:	c7 04 24 80 6e 10 80 	movl   $0x80106e80,(%esp)
801022ba:	e8 a1 e0 ff ff       	call   80100360 <panic>
801022bf:	90                   	nop

801022c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	56                   	push   %esi
801022c4:	53                   	push   %ebx
801022c5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022c8:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801022cf:	00 c0 fe 
  ioapic->reg = reg;
801022d2:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022d9:	00 00 00 
  return ioapic->data;
801022dc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022e2:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
801022e5:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801022eb:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022f1:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022f8:	c1 e8 10             	shr    $0x10,%eax
801022fb:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801022fe:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102301:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102304:	39 c2                	cmp    %eax,%edx
80102306:	74 12                	je     8010231a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102308:	c7 04 24 b4 6e 10 80 	movl   $0x80106eb4,(%esp)
8010230f:	e8 3c e3 ff ff       	call   80100650 <cprintf>
80102314:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010231a:	ba 10 00 00 00       	mov    $0x10,%edx
8010231f:	31 c0                	xor    %eax,%eax
80102321:	eb 07                	jmp    8010232a <ioapicinit+0x6a>
80102323:	90                   	nop
80102324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102328:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010232a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010232c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102332:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102335:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010233b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010233e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102341:	8d 4a 01             	lea    0x1(%edx),%ecx
80102344:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102347:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102349:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010234f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
80102351:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102358:	7d ce                	jge    80102328 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010235a:	83 c4 10             	add    $0x10,%esp
8010235d:	5b                   	pop    %ebx
8010235e:	5e                   	pop    %esi
8010235f:	5d                   	pop    %ebp
80102360:	c3                   	ret    
80102361:	eb 0d                	jmp    80102370 <ioapicenable>
80102363:	90                   	nop
80102364:	90                   	nop
80102365:	90                   	nop
80102366:	90                   	nop
80102367:	90                   	nop
80102368:	90                   	nop
80102369:	90                   	nop
8010236a:	90                   	nop
8010236b:	90                   	nop
8010236c:	90                   	nop
8010236d:	90                   	nop
8010236e:	90                   	nop
8010236f:	90                   	nop

80102370 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	8b 55 08             	mov    0x8(%ebp),%edx
80102376:	53                   	push   %ebx
80102377:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010237a:	8d 5a 20             	lea    0x20(%edx),%ebx
8010237d:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
80102381:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102387:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
8010238a:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010238c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102392:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
80102395:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
80102398:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010239a:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023a0:	89 42 10             	mov    %eax,0x10(%edx)
}
801023a3:	5b                   	pop    %ebx
801023a4:	5d                   	pop    %ebp
801023a5:	c3                   	ret    
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	66 90                	xchg   %ax,%ax
801023aa:	66 90                	xchg   %ax,%ax
801023ac:	66 90                	xchg   %ax,%ax
801023ae:	66 90                	xchg   %ax,%ax

801023b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	53                   	push   %ebx
801023b4:	83 ec 14             	sub    $0x14,%esp
801023b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023c0:	75 7c                	jne    8010243e <kfree+0x8e>
801023c2:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
801023c8:	72 74                	jb     8010243e <kfree+0x8e>
801023ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023d5:	77 67                	ja     8010243e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023d7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801023de:	00 
801023df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801023e6:	00 
801023e7:	89 1c 24             	mov    %ebx,(%esp)
801023ea:	e8 51 1f 00 00       	call   80104340 <memset>

  if(kmem.use_lock)
801023ef:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801023f5:	85 d2                	test   %edx,%edx
801023f7:	75 37                	jne    80102430 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023f9:	a1 78 26 11 80       	mov    0x80112678,%eax
801023fe:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102400:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102405:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010240b:	85 c0                	test   %eax,%eax
8010240d:	75 09                	jne    80102418 <kfree+0x68>
    release(&kmem.lock);
}
8010240f:	83 c4 14             	add    $0x14,%esp
80102412:	5b                   	pop    %ebx
80102413:	5d                   	pop    %ebp
80102414:	c3                   	ret    
80102415:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102418:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010241f:	83 c4 14             	add    $0x14,%esp
80102422:	5b                   	pop    %ebx
80102423:	5d                   	pop    %ebp
    release(&kmem.lock);
80102424:	e9 c7 1e 00 00       	jmp    801042f0 <release>
80102429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102430:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102437:	e8 c4 1d 00 00       	call   80104200 <acquire>
8010243c:	eb bb                	jmp    801023f9 <kfree+0x49>
    panic("kfree");
8010243e:	c7 04 24 e6 6e 10 80 	movl   $0x80106ee6,(%esp)
80102445:	e8 16 df ff ff       	call   80100360 <panic>
8010244a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102450 <freerange>:
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102458:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010245b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010245e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102464:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 08                	jae    8010247c <freerange+0x2c>
80102474:	eb 18                	jmp    8010248e <freerange+0x3e>
80102476:	66 90                	xchg   %ax,%ax
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 2c ff ff ff       	call   801023b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 f0                	cmp    %esi,%eax
8010248c:	76 ea                	jbe    80102478 <freerange+0x28>
}
8010248e:	83 c4 10             	add    $0x10,%esp
80102491:	5b                   	pop    %ebx
80102492:	5e                   	pop    %esi
80102493:	5d                   	pop    %ebp
80102494:	c3                   	ret    
80102495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit1>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
801024a5:	83 ec 10             	sub    $0x10,%esp
801024a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024ab:	c7 44 24 04 ec 6e 10 	movl   $0x80106eec,0x4(%esp)
801024b2:	80 
801024b3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024ba:	e8 51 1c 00 00       	call   80104110 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
801024c2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801024c9:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801024cc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024d2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d8:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024de:	39 de                	cmp    %ebx,%esi
801024e0:	73 0a                	jae    801024ec <kinit1+0x4c>
801024e2:	eb 1a                	jmp    801024fe <kinit1+0x5e>
801024e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e8:	89 da                	mov    %ebx,%edx
801024ea:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024ec:	89 14 24             	mov    %edx,(%esp)
801024ef:	e8 bc fe ff ff       	call   801023b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024fa:	39 c6                	cmp    %eax,%esi
801024fc:	73 ea                	jae    801024e8 <kinit1+0x48>
}
801024fe:	83 c4 10             	add    $0x10,%esp
80102501:	5b                   	pop    %ebx
80102502:	5e                   	pop    %esi
80102503:	5d                   	pop    %ebp
80102504:	c3                   	ret    
80102505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <kinit2>:
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	56                   	push   %esi
80102514:	53                   	push   %ebx
80102515:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010251e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102524:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102530:	39 de                	cmp    %ebx,%esi
80102532:	73 08                	jae    8010253c <kinit2+0x2c>
80102534:	eb 18                	jmp    8010254e <kinit2+0x3e>
80102536:	66 90                	xchg   %ax,%ax
80102538:	89 da                	mov    %ebx,%edx
8010253a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010253c:	89 14 24             	mov    %edx,(%esp)
8010253f:	e8 6c fe ff ff       	call   801023b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102544:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010254a:	39 c6                	cmp    %eax,%esi
8010254c:	73 ea                	jae    80102538 <kinit2+0x28>
  kmem.use_lock = 1;
8010254e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102555:	00 00 00 
}
80102558:	83 c4 10             	add    $0x10,%esp
8010255b:	5b                   	pop    %ebx
8010255c:	5e                   	pop    %esi
8010255d:	5d                   	pop    %ebp
8010255e:	c3                   	ret    
8010255f:	90                   	nop

80102560 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102567:	a1 74 26 11 80       	mov    0x80112674,%eax
8010256c:	85 c0                	test   %eax,%eax
8010256e:	75 30                	jne    801025a0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102570:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102576:	85 db                	test   %ebx,%ebx
80102578:	74 08                	je     80102582 <kalloc+0x22>
    kmem.freelist = r->next;
8010257a:	8b 13                	mov    (%ebx),%edx
8010257c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102582:	85 c0                	test   %eax,%eax
80102584:	74 0c                	je     80102592 <kalloc+0x32>
    release(&kmem.lock);
80102586:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010258d:	e8 5e 1d 00 00       	call   801042f0 <release>
  return (char*)r;
}
80102592:	83 c4 14             	add    $0x14,%esp
80102595:	89 d8                	mov    %ebx,%eax
80102597:	5b                   	pop    %ebx
80102598:	5d                   	pop    %ebp
80102599:	c3                   	ret    
8010259a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801025a0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801025a7:	e8 54 1c 00 00       	call   80104200 <acquire>
801025ac:	a1 74 26 11 80       	mov    0x80112674,%eax
801025b1:	eb bd                	jmp    80102570 <kalloc+0x10>
801025b3:	66 90                	xchg   %ax,%ax
801025b5:	66 90                	xchg   %ax,%ax
801025b7:	66 90                	xchg   %ax,%ax
801025b9:	66 90                	xchg   %ax,%ax
801025bb:	66 90                	xchg   %ax,%ax
801025bd:	66 90                	xchg   %ax,%ax
801025bf:	90                   	nop

801025c0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025c0:	ba 64 00 00 00       	mov    $0x64,%edx
801025c5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801025c6:	a8 01                	test   $0x1,%al
801025c8:	0f 84 ba 00 00 00    	je     80102688 <kbdgetc+0xc8>
801025ce:	b2 60                	mov    $0x60,%dl
801025d0:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025d1:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
801025d4:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
801025da:	0f 84 88 00 00 00    	je     80102668 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025e0:	84 c0                	test   %al,%al
801025e2:	79 2c                	jns    80102610 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801025e4:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
801025ea:	f6 c2 40             	test   $0x40,%dl
801025ed:	75 05                	jne    801025f4 <kbdgetc+0x34>
801025ef:	89 c1                	mov    %eax,%ecx
801025f1:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801025f4:	0f b6 81 20 70 10 80 	movzbl -0x7fef8fe0(%ecx),%eax
801025fb:	83 c8 40             	or     $0x40,%eax
801025fe:	0f b6 c0             	movzbl %al,%eax
80102601:	f7 d0                	not    %eax
80102603:	21 d0                	and    %edx,%eax
80102605:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010260a:	31 c0                	xor    %eax,%eax
8010260c:	c3                   	ret    
8010260d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	53                   	push   %ebx
80102614:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010261a:	f6 c3 40             	test   $0x40,%bl
8010261d:	74 09                	je     80102628 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010261f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102622:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102625:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102628:	0f b6 91 20 70 10 80 	movzbl -0x7fef8fe0(%ecx),%edx
  shift ^= togglecode[data];
8010262f:	0f b6 81 20 6f 10 80 	movzbl -0x7fef90e0(%ecx),%eax
  shift |= shiftcode[data];
80102636:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102638:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010263a:	89 d0                	mov    %edx,%eax
8010263c:	83 e0 03             	and    $0x3,%eax
8010263f:	8b 04 85 00 6f 10 80 	mov    -0x7fef9100(,%eax,4),%eax
  shift ^= togglecode[data];
80102646:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010264c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010264f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102653:	74 0b                	je     80102660 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102655:	8d 50 9f             	lea    -0x61(%eax),%edx
80102658:	83 fa 19             	cmp    $0x19,%edx
8010265b:	77 1b                	ja     80102678 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010265d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102660:	5b                   	pop    %ebx
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    
80102663:	90                   	nop
80102664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102668:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010266f:	31 c0                	xor    %eax,%eax
80102671:	c3                   	ret    
80102672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102678:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010267b:	8d 50 20             	lea    0x20(%eax),%edx
8010267e:	83 f9 19             	cmp    $0x19,%ecx
80102681:	0f 46 c2             	cmovbe %edx,%eax
  return c;
80102684:	eb da                	jmp    80102660 <kbdgetc+0xa0>
80102686:	66 90                	xchg   %ax,%ax
    return -1;
80102688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010268d:	c3                   	ret    
8010268e:	66 90                	xchg   %ax,%ax

80102690 <kbdintr>:

void
kbdintr(void)
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102696:	c7 04 24 c0 25 10 80 	movl   $0x801025c0,(%esp)
8010269d:	e8 0e e1 ff ff       	call   801007b0 <consoleintr>
}
801026a2:	c9                   	leave  
801026a3:	c3                   	ret    
801026a4:	66 90                	xchg   %ax,%ax
801026a6:	66 90                	xchg   %ax,%ax
801026a8:	66 90                	xchg   %ax,%ax
801026aa:	66 90                	xchg   %ax,%ax
801026ac:	66 90                	xchg   %ax,%ax
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801026b0:	55                   	push   %ebp
801026b1:	89 c1                	mov    %eax,%ecx
801026b3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026b5:	ba 70 00 00 00       	mov    $0x70,%edx
801026ba:	53                   	push   %ebx
801026bb:	31 c0                	xor    %eax,%eax
801026bd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026be:	bb 71 00 00 00       	mov    $0x71,%ebx
801026c3:	89 da                	mov    %ebx,%edx
801026c5:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
801026c6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026c9:	b2 70                	mov    $0x70,%dl
801026cb:	89 01                	mov    %eax,(%ecx)
801026cd:	b8 02 00 00 00       	mov    $0x2,%eax
801026d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026d3:	89 da                	mov    %ebx,%edx
801026d5:	ec                   	in     (%dx),%al
801026d6:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026d9:	b2 70                	mov    $0x70,%dl
801026db:	89 41 04             	mov    %eax,0x4(%ecx)
801026de:	b8 04 00 00 00       	mov    $0x4,%eax
801026e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e4:	89 da                	mov    %ebx,%edx
801026e6:	ec                   	in     (%dx),%al
801026e7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026ea:	b2 70                	mov    $0x70,%dl
801026ec:	89 41 08             	mov    %eax,0x8(%ecx)
801026ef:	b8 07 00 00 00       	mov    $0x7,%eax
801026f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f5:	89 da                	mov    %ebx,%edx
801026f7:	ec                   	in     (%dx),%al
801026f8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026fb:	b2 70                	mov    $0x70,%dl
801026fd:	89 41 0c             	mov    %eax,0xc(%ecx)
80102700:	b8 08 00 00 00       	mov    $0x8,%eax
80102705:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102706:	89 da                	mov    %ebx,%edx
80102708:	ec                   	in     (%dx),%al
80102709:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010270c:	b2 70                	mov    $0x70,%dl
8010270e:	89 41 10             	mov    %eax,0x10(%ecx)
80102711:	b8 09 00 00 00       	mov    $0x9,%eax
80102716:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102717:	89 da                	mov    %ebx,%edx
80102719:	ec                   	in     (%dx),%al
8010271a:	0f b6 d8             	movzbl %al,%ebx
8010271d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102720:	5b                   	pop    %ebx
80102721:	5d                   	pop    %ebp
80102722:	c3                   	ret    
80102723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicinit>:
  if(!lapic)
80102730:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102735:	55                   	push   %ebp
80102736:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102738:	85 c0                	test   %eax,%eax
8010273a:	0f 84 c0 00 00 00    	je     80102800 <lapicinit+0xd0>
  lapic[index] = value;
80102740:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102747:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102754:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102757:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010275a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102761:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102764:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102767:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010276e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102771:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102774:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010277b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010277e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102781:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102788:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010278b:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010278e:	8b 50 30             	mov    0x30(%eax),%edx
80102791:	c1 ea 10             	shr    $0x10,%edx
80102794:	80 fa 03             	cmp    $0x3,%dl
80102797:	77 6f                	ja     80102808 <lapicinit+0xd8>
  lapic[index] = value;
80102799:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027c7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027e1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027e4:	8b 50 20             	mov    0x20(%eax),%edx
801027e7:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
801027e8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027ee:	80 e6 10             	and    $0x10,%dh
801027f1:	75 f5                	jne    801027e8 <lapicinit+0xb8>
  lapic[index] = value;
801027f3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fd:	8b 40 20             	mov    0x20(%eax),%eax
}
80102800:	5d                   	pop    %ebp
80102801:	c3                   	ret    
80102802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102808:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010280f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102812:	8b 50 20             	mov    0x20(%eax),%edx
80102815:	eb 82                	jmp    80102799 <lapicinit+0x69>
80102817:	89 f6                	mov    %esi,%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <lapicid>:
  if (!lapic)
80102820:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102825:	55                   	push   %ebp
80102826:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102828:	85 c0                	test   %eax,%eax
8010282a:	74 0c                	je     80102838 <lapicid+0x18>
  return lapic[ID] >> 24;
8010282c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010282f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102830:	c1 e8 18             	shr    $0x18,%eax
}
80102833:	c3                   	ret    
80102834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102838:	31 c0                	xor    %eax,%eax
}
8010283a:	5d                   	pop    %ebp
8010283b:	c3                   	ret    
8010283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102840 <lapiceoi>:
  if(lapic)
80102840:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102845:	55                   	push   %ebp
80102846:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102848:	85 c0                	test   %eax,%eax
8010284a:	74 0d                	je     80102859 <lapiceoi+0x19>
  lapic[index] = value;
8010284c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102853:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102856:	8b 40 20             	mov    0x20(%eax),%eax
}
80102859:	5d                   	pop    %ebp
8010285a:	c3                   	ret    
8010285b:	90                   	nop
8010285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102860 <microdelay>:
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
}
80102863:	5d                   	pop    %ebp
80102864:	c3                   	ret    
80102865:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102870 <lapicstartap>:
{
80102870:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102871:	ba 70 00 00 00       	mov    $0x70,%edx
80102876:	89 e5                	mov    %esp,%ebp
80102878:	b8 0f 00 00 00       	mov    $0xf,%eax
8010287d:	53                   	push   %ebx
8010287e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102881:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102884:	ee                   	out    %al,(%dx)
80102885:	b8 0a 00 00 00       	mov    $0xa,%eax
8010288a:	b2 71                	mov    $0x71,%dl
8010288c:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
8010288d:	31 c0                	xor    %eax,%eax
8010288f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102895:	89 d8                	mov    %ebx,%eax
80102897:	c1 e8 04             	shr    $0x4,%eax
8010289a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801028a5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801028a8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801028ab:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028bb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028c8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ce:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028d4:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801028d7:	89 da                	mov    %ebx,%edx
801028d9:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
801028dc:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028e2:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028e5:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028eb:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
801028ee:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 40 20             	mov    0x20(%eax),%eax
}
801028f7:	5b                   	pop    %ebx
801028f8:	5d                   	pop    %ebp
801028f9:	c3                   	ret    
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102900 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102900:	55                   	push   %ebp
80102901:	ba 70 00 00 00       	mov    $0x70,%edx
80102906:	89 e5                	mov    %esp,%ebp
80102908:	b8 0b 00 00 00       	mov    $0xb,%eax
8010290d:	57                   	push   %edi
8010290e:	56                   	push   %esi
8010290f:	53                   	push   %ebx
80102910:	83 ec 4c             	sub    $0x4c,%esp
80102913:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102914:	b2 71                	mov    $0x71,%dl
80102916:	ec                   	in     (%dx),%al
80102917:	88 45 b7             	mov    %al,-0x49(%ebp)
8010291a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010291d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102921:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102928:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010292d:	89 d8                	mov    %ebx,%eax
8010292f:	e8 7c fd ff ff       	call   801026b0 <fill_rtcdate>
80102934:	b8 0a 00 00 00       	mov    $0xa,%eax
80102939:	89 f2                	mov    %esi,%edx
8010293b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293c:	ba 71 00 00 00       	mov    $0x71,%edx
80102941:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102942:	84 c0                	test   %al,%al
80102944:	78 e7                	js     8010292d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102946:	89 f8                	mov    %edi,%eax
80102948:	e8 63 fd ff ff       	call   801026b0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010294d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102954:	00 
80102955:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102959:	89 1c 24             	mov    %ebx,(%esp)
8010295c:	e8 2f 1a 00 00       	call   80104390 <memcmp>
80102961:	85 c0                	test   %eax,%eax
80102963:	75 c3                	jne    80102928 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102965:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102969:	75 78                	jne    801029e3 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010296b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010296e:	89 c2                	mov    %eax,%edx
80102970:	83 e0 0f             	and    $0xf,%eax
80102973:	c1 ea 04             	shr    $0x4,%edx
80102976:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102979:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010297f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102982:	89 c2                	mov    %eax,%edx
80102984:	83 e0 0f             	and    $0xf,%eax
80102987:	c1 ea 04             	shr    $0x4,%edx
8010298a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102990:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102993:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102996:	89 c2                	mov    %eax,%edx
80102998:	83 e0 0f             	and    $0xf,%eax
8010299b:	c1 ea 04             	shr    $0x4,%edx
8010299e:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029aa:	89 c2                	mov    %eax,%edx
801029ac:	83 e0 0f             	and    $0xf,%eax
801029af:	c1 ea 04             	shr    $0x4,%edx
801029b2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029be:	89 c2                	mov    %eax,%edx
801029c0:	83 e0 0f             	and    $0xf,%eax
801029c3:	c1 ea 04             	shr    $0x4,%edx
801029c6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029d2:	89 c2                	mov    %eax,%edx
801029d4:	83 e0 0f             	and    $0xf,%eax
801029d7:	c1 ea 04             	shr    $0x4,%edx
801029da:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029dd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029e0:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801029e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029e9:	89 01                	mov    %eax,(%ecx)
801029eb:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029ee:	89 41 04             	mov    %eax,0x4(%ecx)
801029f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029f4:	89 41 08             	mov    %eax,0x8(%ecx)
801029f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029fa:	89 41 0c             	mov    %eax,0xc(%ecx)
801029fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a00:	89 41 10             	mov    %eax,0x10(%ecx)
80102a03:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a06:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102a09:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102a10:	83 c4 4c             	add    $0x4c,%esp
80102a13:	5b                   	pop    %ebx
80102a14:	5e                   	pop    %esi
80102a15:	5f                   	pop    %edi
80102a16:	5d                   	pop    %ebp
80102a17:	c3                   	ret    
80102a18:	66 90                	xchg   %ax,%ax
80102a1a:	66 90                	xchg   %ax,%ax
80102a1c:	66 90                	xchg   %ax,%ax
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	57                   	push   %edi
80102a24:	56                   	push   %esi
80102a25:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a26:	31 db                	xor    %ebx,%ebx
{
80102a28:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102a2b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102a30:	85 c0                	test   %eax,%eax
80102a32:	7e 78                	jle    80102aac <install_trans+0x8c>
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a38:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a3d:	01 d8                	add    %ebx,%eax
80102a3f:	83 c0 01             	add    $0x1,%eax
80102a42:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a46:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a4b:	89 04 24             	mov    %eax,(%esp)
80102a4e:	e8 7d d6 ff ff       	call   801000d0 <bread>
80102a53:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a55:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102a5c:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a63:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a68:	89 04 24             	mov    %eax,(%esp)
80102a6b:	e8 60 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a70:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a77:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a78:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a7a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a81:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a84:	89 04 24             	mov    %eax,(%esp)
80102a87:	e8 54 19 00 00       	call   801043e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a8c:	89 34 24             	mov    %esi,(%esp)
80102a8f:	e8 0c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a94:	89 3c 24             	mov    %edi,(%esp)
80102a97:	e8 44 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a9c:	89 34 24             	mov    %esi,(%esp)
80102a9f:	e8 3c d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102aa4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102aaa:	7f 8c                	jg     80102a38 <install_trans+0x18>
  }
}
80102aac:	83 c4 1c             	add    $0x1c,%esp
80102aaf:	5b                   	pop    %ebx
80102ab0:	5e                   	pop    %esi
80102ab1:	5f                   	pop    %edi
80102ab2:	5d                   	pop    %ebp
80102ab3:	c3                   	ret    
80102ab4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102aba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102ac0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	57                   	push   %edi
80102ac4:	56                   	push   %esi
80102ac5:	53                   	push   %ebx
80102ac6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac9:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ace:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ad2:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102ad7:	89 04 24             	mov    %eax,(%esp)
80102ada:	e8 f1 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102adf:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ae5:	31 d2                	xor    %edx,%edx
80102ae7:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102ae9:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102aeb:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102aee:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102af1:	7e 17                	jle    80102b0a <write_head+0x4a>
80102af3:	90                   	nop
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102af8:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102aff:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102b03:	83 c2 01             	add    $0x1,%edx
80102b06:	39 da                	cmp    %ebx,%edx
80102b08:	75 ee                	jne    80102af8 <write_head+0x38>
  }
  bwrite(buf);
80102b0a:	89 3c 24             	mov    %edi,(%esp)
80102b0d:	e8 8e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b12:	89 3c 24             	mov    %edi,(%esp)
80102b15:	e8 c6 d6 ff ff       	call   801001e0 <brelse>
}
80102b1a:	83 c4 1c             	add    $0x1c,%esp
80102b1d:	5b                   	pop    %ebx
80102b1e:	5e                   	pop    %esi
80102b1f:	5f                   	pop    %edi
80102b20:	5d                   	pop    %ebp
80102b21:	c3                   	ret    
80102b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b30 <initlog>:
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	56                   	push   %esi
80102b34:	53                   	push   %ebx
80102b35:	83 ec 30             	sub    $0x30,%esp
80102b38:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b3b:	c7 44 24 04 20 71 10 	movl   $0x80107120,0x4(%esp)
80102b42:	80 
80102b43:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b4a:	e8 c1 15 00 00       	call   80104110 <initlock>
  readsb(dev, &sb);
80102b4f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b52:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b56:	89 1c 24             	mov    %ebx,(%esp)
80102b59:	e8 f2 e8 ff ff       	call   80101450 <readsb>
  log.start = sb.logstart;
80102b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102b64:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102b67:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102b71:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b77:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b7c:	e8 4f d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102b81:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102b83:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b86:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b89:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b8b:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b91:	7e 17                	jle    80102baa <initlog+0x7a>
80102b93:	90                   	nop
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b98:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b9c:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ba3:	83 c2 01             	add    $0x1,%edx
80102ba6:	39 da                	cmp    %ebx,%edx
80102ba8:	75 ee                	jne    80102b98 <initlog+0x68>
  brelse(buf);
80102baa:	89 04 24             	mov    %eax,(%esp)
80102bad:	e8 2e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bb2:	e8 69 fe ff ff       	call   80102a20 <install_trans>
  log.lh.n = 0;
80102bb7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102bbe:	00 00 00 
  write_head(); // clear the log
80102bc1:	e8 fa fe ff ff       	call   80102ac0 <write_head>
}
80102bc6:	83 c4 30             	add    $0x30,%esp
80102bc9:	5b                   	pop    %ebx
80102bca:	5e                   	pop    %esi
80102bcb:	5d                   	pop    %ebp
80102bcc:	c3                   	ret    
80102bcd:	8d 76 00             	lea    0x0(%esi),%esi

80102bd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102bd6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bdd:	e8 1e 16 00 00       	call   80104200 <acquire>
80102be2:	eb 18                	jmp    80102bfc <begin_op+0x2c>
80102be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102bef:	80 
80102bf0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bf7:	e8 c4 10 00 00       	call   80103cc0 <sleep>
    if(log.committing){
80102bfc:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c01:	85 c0                	test   %eax,%eax
80102c03:	75 e3                	jne    80102be8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c05:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c0a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c10:	83 c0 01             	add    $0x1,%eax
80102c13:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c16:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c19:	83 fa 1e             	cmp    $0x1e,%edx
80102c1c:	7f ca                	jg     80102be8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c1e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102c25:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c2a:	e8 c1 16 00 00       	call   801042f0 <release>
      break;
    }
  }
}
80102c2f:	c9                   	leave  
80102c30:	c3                   	ret    
80102c31:	eb 0d                	jmp    80102c40 <end_op>
80102c33:	90                   	nop
80102c34:	90                   	nop
80102c35:	90                   	nop
80102c36:	90                   	nop
80102c37:	90                   	nop
80102c38:	90                   	nop
80102c39:	90                   	nop
80102c3a:	90                   	nop
80102c3b:	90                   	nop
80102c3c:	90                   	nop
80102c3d:	90                   	nop
80102c3e:	90                   	nop
80102c3f:	90                   	nop

80102c40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	57                   	push   %edi
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c49:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c50:	e8 ab 15 00 00       	call   80104200 <acquire>
  log.outstanding -= 1;
80102c55:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c5a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102c60:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c63:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102c65:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102c6a:	0f 85 f3 00 00 00    	jne    80102d63 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c70:	85 c0                	test   %eax,%eax
80102c72:	0f 85 cb 00 00 00    	jne    80102d43 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c78:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c7f:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102c81:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c88:	00 00 00 
  release(&log.lock);
80102c8b:	e8 60 16 00 00       	call   801042f0 <release>
  if (log.lh.n > 0) {
80102c90:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c95:	85 c0                	test   %eax,%eax
80102c97:	0f 8e 90 00 00 00    	jle    80102d2d <end_op+0xed>
80102c9d:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ca0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ca5:	01 d8                	add    %ebx,%eax
80102ca7:	83 c0 01             	add    $0x1,%eax
80102caa:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cae:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102cb3:	89 04 24             	mov    %eax,(%esp)
80102cb6:	e8 15 d4 ff ff       	call   801000d0 <bread>
80102cbb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbd:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102cc4:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ccb:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102cd0:	89 04 24             	mov    %eax,(%esp)
80102cd3:	e8 f8 d3 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102cd8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102cdf:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ce0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ce2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ce9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cec:	89 04 24             	mov    %eax,(%esp)
80102cef:	e8 ec 16 00 00       	call   801043e0 <memmove>
    bwrite(to);  // write the log
80102cf4:	89 34 24             	mov    %esi,(%esp)
80102cf7:	e8 a4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cfc:	89 3c 24             	mov    %edi,(%esp)
80102cff:	e8 dc d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d04:	89 34 24             	mov    %esi,(%esp)
80102d07:	e8 d4 d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d0c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d12:	7c 8c                	jl     80102ca0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d14:	e8 a7 fd ff ff       	call   80102ac0 <write_head>
    install_trans(); // Now install writes to home locations
80102d19:	e8 02 fd ff ff       	call   80102a20 <install_trans>
    log.lh.n = 0;
80102d1e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d25:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d28:	e8 93 fd ff ff       	call   80102ac0 <write_head>
    acquire(&log.lock);
80102d2d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d34:	e8 c7 14 00 00       	call   80104200 <acquire>
    log.committing = 0;
80102d39:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d40:	00 00 00 
    wakeup(&log);
80102d43:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d4a:	e8 01 11 00 00       	call   80103e50 <wakeup>
    release(&log.lock);
80102d4f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d56:	e8 95 15 00 00       	call   801042f0 <release>
}
80102d5b:	83 c4 1c             	add    $0x1c,%esp
80102d5e:	5b                   	pop    %ebx
80102d5f:	5e                   	pop    %esi
80102d60:	5f                   	pop    %edi
80102d61:	5d                   	pop    %ebp
80102d62:	c3                   	ret    
    panic("log.committing");
80102d63:	c7 04 24 24 71 10 80 	movl   $0x80107124,(%esp)
80102d6a:	e8 f1 d5 ff ff       	call   80100360 <panic>
80102d6f:	90                   	nop

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102d7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d7f:	83 f8 1d             	cmp    $0x1d,%eax
80102d82:	0f 8f 98 00 00 00    	jg     80102e20 <log_write+0xb0>
80102d88:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102d8e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d91:	39 d0                	cmp    %edx,%eax
80102d93:	0f 8d 87 00 00 00    	jge    80102e20 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 86 00 00 00    	jle    80102e2c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dad:	e8 4e 14 00 00       	call   80104200 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102db8:	83 fa 00             	cmp    $0x0,%edx
80102dbb:	7e 54                	jle    80102e11 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dbd:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102dc0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc2:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102dc8:	75 0f                	jne    80102dd9 <log_write+0x69>
80102dca:	eb 3c                	jmp    80102e08 <log_write+0x98>
80102dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dd0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 d0                	cmp    %edx,%eax
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c2 01             	add    $0x1,%edx
80102dea:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102df0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df3:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102dfa:	83 c4 14             	add    $0x14,%esp
80102dfd:	5b                   	pop    %ebx
80102dfe:	5d                   	pop    %ebp
  release(&log.lock);
80102dff:	e9 ec 14 00 00       	jmp    801042f0 <release>
80102e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102e08:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102e0f:	eb df                	jmp    80102df0 <log_write+0x80>
80102e11:	8b 43 08             	mov    0x8(%ebx),%eax
80102e14:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e19:	75 d5                	jne    80102df0 <log_write+0x80>
80102e1b:	eb ca                	jmp    80102de7 <log_write+0x77>
80102e1d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102e20:	c7 04 24 33 71 10 80 	movl   $0x80107133,(%esp)
80102e27:	e8 34 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102e2c:	c7 04 24 49 71 10 80 	movl   $0x80107149,(%esp)
80102e33:	e8 28 d5 ff ff       	call   80100360 <panic>
80102e38:	66 90                	xchg   %ax,%ax
80102e3a:	66 90                	xchg   %ax,%ax
80102e3c:	66 90                	xchg   %ax,%ax
80102e3e:	66 90                	xchg   %ax,%ax

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e47:	e8 f4 08 00 00       	call   80103740 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 ed 08 00 00       	call   80103740 <cpuid>
80102e53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102e57:	c7 04 24 64 71 10 80 	movl   $0x80107164,(%esp)
80102e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e62:	e8 e9 d7 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e67:	e8 b4 26 00 00       	call   80105520 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e6c:	e8 4f 08 00 00       	call   801036c0 <mycpu>
80102e71:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e73:	b8 01 00 00 00       	mov    $0x1,%eax
80102e78:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e7f:	e8 9c 0b 00 00       	call   80103a20 <scheduler>
80102e84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e90 <mpenter>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e96:	e8 45 37 00 00       	call   801065e0 <switchkvm>
  seginit();
80102e9b:	e8 80 36 00 00       	call   80106520 <seginit>
  lapicinit();
80102ea0:	e8 8b f8 ff ff       	call   80102730 <lapicinit>
  mpmain();
80102ea5:	e8 96 ff ff ff       	call   80102e40 <mpmain>
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <main>:
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102eb4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102eb9:	83 e4 f0             	and    $0xfffffff0,%esp
80102ebc:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ebf:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102ec6:	80 
80102ec7:	c7 04 24 a8 54 11 80 	movl   $0x801154a8,(%esp)
80102ece:	e8 cd f5 ff ff       	call   801024a0 <kinit1>
  kvmalloc();      // kernel page table
80102ed3:	e8 98 3b 00 00       	call   80106a70 <kvmalloc>
  mpinit();        // detect other processors
80102ed8:	e8 73 01 00 00       	call   80103050 <mpinit>
80102edd:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102ee0:	e8 4b f8 ff ff       	call   80102730 <lapicinit>
  seginit();       // segment descriptors
80102ee5:	e8 36 36 00 00       	call   80106520 <seginit>
  picinit();       // disable pic
80102eea:	e8 21 03 00 00       	call   80103210 <picinit>
80102eef:	90                   	nop
  ioapicinit();    // another interrupt controller
80102ef0:	e8 cb f3 ff ff       	call   801022c0 <ioapicinit>
  consoleinit();   // console hardware
80102ef5:	e8 56 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102efa:	e8 41 29 00 00       	call   80105840 <uartinit>
80102eff:	90                   	nop
  pinit();         // process table
80102f00:	e8 9b 07 00 00       	call   801036a0 <pinit>
  tvinit();        // trap vectors
80102f05:	e8 76 25 00 00       	call   80105480 <tvinit>
  binit();         // buffer cache
80102f0a:	e8 31 d1 ff ff       	call   80100040 <binit>
80102f0f:	90                   	nop
  fileinit();      // file table
80102f10:	e8 3b de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102f15:	e8 a6 f1 ff ff       	call   801020c0 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f1a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102f21:	00 
80102f22:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102f29:	80 
80102f2a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102f31:	e8 aa 14 00 00       	call   801043e0 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102f36:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f3d:	00 00 00 
80102f40:	05 80 27 11 80       	add    $0x80112780,%eax
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	76 6a                	jbe    80102fb3 <main+0x103>
80102f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102f50:	e8 6b 07 00 00       	call   801036c0 <mycpu>
80102f55:	39 d8                	cmp    %ebx,%eax
80102f57:	74 41                	je     80102f9a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f59:	e8 02 f6 ff ff       	call   80102560 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f5e:	c7 05 f8 6f 00 80 90 	movl   $0x80102e90,0x80006ff8
80102f65:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f68:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f6f:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f72:	05 00 10 00 00       	add    $0x1000,%eax
80102f77:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f7c:	0f b6 03             	movzbl (%ebx),%eax
80102f7f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f86:	00 
80102f87:	89 04 24             	mov    %eax,(%esp)
80102f8a:	e8 e1 f8 ff ff       	call   80102870 <lapicstartap>
80102f8f:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f90:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	74 f6                	je     80102f90 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f9a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fa1:	00 00 00 
80102fa4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102faa:	05 80 27 11 80       	add    $0x80112780,%eax
80102faf:	39 c3                	cmp    %eax,%ebx
80102fb1:	72 9d                	jb     80102f50 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fb3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102fba:	8e 
80102fbb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102fc2:	e8 49 f5 ff ff       	call   80102510 <kinit2>
  userinit();      // first user process
80102fc7:	e8 c4 07 00 00       	call   80103790 <userinit>
  mpmain();        // finish this processor's setup
80102fcc:	e8 6f fe ff ff       	call   80102e40 <mpmain>
80102fd1:	66 90                	xchg   %ax,%ax
80102fd3:	66 90                	xchg   %ax,%ax
80102fd5:	66 90                	xchg   %ax,%ax
80102fd7:	66 90                	xchg   %ax,%ax
80102fd9:	66 90                	xchg   %ax,%ax
80102fdb:	66 90                	xchg   %ax,%ax
80102fdd:	66 90                	xchg   %ax,%ax
80102fdf:	90                   	nop

80102fe0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fe4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fea:	53                   	push   %ebx
  e = addr+len;
80102feb:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fee:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102ff1:	39 de                	cmp    %ebx,%esi
80102ff3:	73 3c                	jae    80103031 <mpsearch1+0x51>
80102ff5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fff:	00 
80103000:	c7 44 24 04 78 71 10 	movl   $0x80107178,0x4(%esp)
80103007:	80 
80103008:	89 34 24             	mov    %esi,(%esp)
8010300b:	e8 80 13 00 00       	call   80104390 <memcmp>
80103010:	85 c0                	test   %eax,%eax
80103012:	75 16                	jne    8010302a <mpsearch1+0x4a>
80103014:	31 c9                	xor    %ecx,%ecx
80103016:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80103018:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
8010301c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010301f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80103021:	83 fa 10             	cmp    $0x10,%edx
80103024:	75 f2                	jne    80103018 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103026:	84 c9                	test   %cl,%cl
80103028:	74 10                	je     8010303a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
8010302a:	83 c6 10             	add    $0x10,%esi
8010302d:	39 f3                	cmp    %esi,%ebx
8010302f:	77 c7                	ja     80102ff8 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80103031:	83 c4 10             	add    $0x10,%esp
  return 0;
80103034:	31 c0                	xor    %eax,%eax
}
80103036:	5b                   	pop    %ebx
80103037:	5e                   	pop    %esi
80103038:	5d                   	pop    %ebp
80103039:	c3                   	ret    
8010303a:	83 c4 10             	add    $0x10,%esp
8010303d:	89 f0                	mov    %esi,%eax
8010303f:	5b                   	pop    %ebx
80103040:	5e                   	pop    %esi
80103041:	5d                   	pop    %ebp
80103042:	c3                   	ret    
80103043:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103050 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103059:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103060:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103067:	c1 e0 08             	shl    $0x8,%eax
8010306a:	09 d0                	or     %edx,%eax
8010306c:	c1 e0 04             	shl    $0x4,%eax
8010306f:	85 c0                	test   %eax,%eax
80103071:	75 1b                	jne    8010308e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103073:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010307a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103081:	c1 e0 08             	shl    $0x8,%eax
80103084:	09 d0                	or     %edx,%eax
80103086:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103089:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010308e:	ba 00 04 00 00       	mov    $0x400,%edx
80103093:	e8 48 ff ff ff       	call   80102fe0 <mpsearch1>
80103098:	85 c0                	test   %eax,%eax
8010309a:	89 c7                	mov    %eax,%edi
8010309c:	0f 84 22 01 00 00    	je     801031c4 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030a2:	8b 77 04             	mov    0x4(%edi),%esi
801030a5:	85 f6                	test   %esi,%esi
801030a7:	0f 84 30 01 00 00    	je     801031dd <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030ad:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801030b3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801030ba:	00 
801030bb:	c7 44 24 04 7d 71 10 	movl   $0x8010717d,0x4(%esp)
801030c2:	80 
801030c3:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801030c9:	e8 c2 12 00 00       	call   80104390 <memcmp>
801030ce:	85 c0                	test   %eax,%eax
801030d0:	0f 85 07 01 00 00    	jne    801031dd <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
801030d6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801030dd:	3c 04                	cmp    $0x4,%al
801030df:	0f 85 0b 01 00 00    	jne    801031f0 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
801030e5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
801030ec:	85 c0                	test   %eax,%eax
801030ee:	74 21                	je     80103111 <mpinit+0xc1>
  sum = 0;
801030f0:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
801030f2:	31 d2                	xor    %edx,%edx
801030f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030f8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
801030ff:	80 
  for(i=0; i<len; i++)
80103100:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103103:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103105:	39 d0                	cmp    %edx,%eax
80103107:	7f ef                	jg     801030f8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103109:	84 c9                	test   %cl,%cl
8010310b:	0f 85 cc 00 00 00    	jne    801031dd <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103114:	85 c0                	test   %eax,%eax
80103116:	0f 84 c1 00 00 00    	je     801031dd <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010311c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103122:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103127:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103133:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103139:	03 55 e4             	add    -0x1c(%ebp),%edx
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103140:	39 c2                	cmp    %eax,%edx
80103142:	76 1b                	jbe    8010315f <mpinit+0x10f>
80103144:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103147:	80 f9 04             	cmp    $0x4,%cl
8010314a:	77 74                	ja     801031c0 <mpinit+0x170>
8010314c:	ff 24 8d bc 71 10 80 	jmp    *-0x7fef8e44(,%ecx,4)
80103153:	90                   	nop
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103158:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315b:	39 c2                	cmp    %eax,%edx
8010315d:	77 e5                	ja     80103144 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010315f:	85 db                	test   %ebx,%ebx
80103161:	0f 84 93 00 00 00    	je     801031fa <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103167:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010316b:	74 12                	je     8010317f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	b8 70 00 00 00       	mov    $0x70,%eax
80103177:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103178:	b2 23                	mov    $0x23,%dl
8010317a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010317b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010317e:	ee                   	out    %al,(%dx)
  }
}
8010317f:	83 c4 1c             	add    $0x1c,%esp
80103182:	5b                   	pop    %ebx
80103183:	5e                   	pop    %esi
80103184:	5f                   	pop    %edi
80103185:	5d                   	pop    %ebp
80103186:	c3                   	ret    
80103187:	90                   	nop
      if(ncpu < NCPU) {
80103188:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010318e:	83 fe 07             	cmp    $0x7,%esi
80103191:	7f 17                	jg     801031aa <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103193:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103197:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010319d:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
801031aa:	83 c0 14             	add    $0x14,%eax
      continue;
801031ad:	eb 91                	jmp    80103140 <mpinit+0xf0>
801031af:	90                   	nop
      ioapicid = ioapic->apicno;
801031b0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801031b4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031b7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
801031bd:	eb 81                	jmp    80103140 <mpinit+0xf0>
801031bf:	90                   	nop
      ismp = 0;
801031c0:	31 db                	xor    %ebx,%ebx
801031c2:	eb 83                	jmp    80103147 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
801031c4:	ba 00 00 01 00       	mov    $0x10000,%edx
801031c9:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ce:	e8 0d fe ff ff       	call   80102fe0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031d3:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031d5:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031d7:	0f 85 c5 fe ff ff    	jne    801030a2 <mpinit+0x52>
    panic("Expect to run on an SMP");
801031dd:	c7 04 24 82 71 10 80 	movl   $0x80107182,(%esp)
801031e4:	e8 77 d1 ff ff       	call   80100360 <panic>
801031e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
801031f0:	3c 01                	cmp    $0x1,%al
801031f2:	0f 84 ed fe ff ff    	je     801030e5 <mpinit+0x95>
801031f8:	eb e3                	jmp    801031dd <mpinit+0x18d>
    panic("Didn't find a suitable machine");
801031fa:	c7 04 24 9c 71 10 80 	movl   $0x8010719c,(%esp)
80103201:	e8 5a d1 ff ff       	call   80100360 <panic>
80103206:	66 90                	xchg   %ax,%ax
80103208:	66 90                	xchg   %ax,%ax
8010320a:	66 90                	xchg   %ax,%ax
8010320c:	66 90                	xchg   %ax,%ax
8010320e:	66 90                	xchg   %ax,%ax

80103210 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103210:	55                   	push   %ebp
80103211:	ba 21 00 00 00       	mov    $0x21,%edx
80103216:	89 e5                	mov    %esp,%ebp
80103218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010321d:	ee                   	out    %al,(%dx)
8010321e:	b2 a1                	mov    $0xa1,%dl
80103220:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103221:	5d                   	pop    %ebp
80103222:	c3                   	ret    
80103223:	66 90                	xchg   %ax,%ax
80103225:	66 90                	xchg   %ax,%ax
80103227:	66 90                	xchg   %ax,%ax
80103229:	66 90                	xchg   %ax,%ax
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	57                   	push   %edi
80103234:	56                   	push   %esi
80103235:	53                   	push   %ebx
80103236:	83 ec 1c             	sub    $0x1c,%esp
80103239:	8b 75 08             	mov    0x8(%ebp),%esi
8010323c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010323f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103245:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010324b:	e8 20 db ff ff       	call   80100d70 <filealloc>
80103250:	85 c0                	test   %eax,%eax
80103252:	89 06                	mov    %eax,(%esi)
80103254:	0f 84 a4 00 00 00    	je     801032fe <pipealloc+0xce>
8010325a:	e8 11 db ff ff       	call   80100d70 <filealloc>
8010325f:	85 c0                	test   %eax,%eax
80103261:	89 03                	mov    %eax,(%ebx)
80103263:	0f 84 87 00 00 00    	je     801032f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103269:	e8 f2 f2 ff ff       	call   80102560 <kalloc>
8010326e:	85 c0                	test   %eax,%eax
80103270:	89 c7                	mov    %eax,%edi
80103272:	74 7c                	je     801032f0 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103274:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010327b:	00 00 00 
  p->writeopen = 1;
8010327e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103285:	00 00 00 
  p->nwrite = 0;
80103288:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010328f:	00 00 00 
  p->nread = 0;
80103292:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103299:	00 00 00 
  initlock(&p->lock, "pipe");
8010329c:	89 04 24             	mov    %eax,(%esp)
8010329f:	c7 44 24 04 d0 71 10 	movl   $0x801071d0,0x4(%esp)
801032a6:	80 
801032a7:	e8 64 0e 00 00       	call   80104110 <initlock>
  (*f0)->type = FD_PIPE;
801032ac:	8b 06                	mov    (%esi),%eax
801032ae:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801032b4:	8b 06                	mov    (%esi),%eax
801032b6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801032ba:	8b 06                	mov    (%esi),%eax
801032bc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801032c0:	8b 06                	mov    (%esi),%eax
801032c2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801032c5:	8b 03                	mov    (%ebx),%eax
801032c7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801032cd:	8b 03                	mov    (%ebx),%eax
801032cf:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801032d3:	8b 03                	mov    (%ebx),%eax
801032d5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801032d9:	8b 03                	mov    (%ebx),%eax
  return 0;
801032db:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
801032dd:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032e0:	83 c4 1c             	add    $0x1c,%esp
801032e3:	89 d8                	mov    %ebx,%eax
801032e5:	5b                   	pop    %ebx
801032e6:	5e                   	pop    %esi
801032e7:	5f                   	pop    %edi
801032e8:	5d                   	pop    %ebp
801032e9:	c3                   	ret    
801032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
801032f0:	8b 06                	mov    (%esi),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 08                	je     801032fe <pipealloc+0xce>
    fileclose(*f0);
801032f6:	89 04 24             	mov    %eax,(%esp)
801032f9:	e8 32 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
801032fe:	8b 03                	mov    (%ebx),%eax
  return -1;
80103300:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103305:	85 c0                	test   %eax,%eax
80103307:	74 d7                	je     801032e0 <pipealloc+0xb0>
    fileclose(*f1);
80103309:	89 04 24             	mov    %eax,(%esp)
8010330c:	e8 1f db ff ff       	call   80100e30 <fileclose>
}
80103311:	83 c4 1c             	add    $0x1c,%esp
80103314:	89 d8                	mov    %ebx,%eax
80103316:	5b                   	pop    %ebx
80103317:	5e                   	pop    %esi
80103318:	5f                   	pop    %edi
80103319:	5d                   	pop    %ebp
8010331a:	c3                   	ret    
8010331b:	90                   	nop
8010331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103320 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	56                   	push   %esi
80103324:	53                   	push   %ebx
80103325:	83 ec 10             	sub    $0x10,%esp
80103328:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010332b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010332e:	89 1c 24             	mov    %ebx,(%esp)
80103331:	e8 ca 0e 00 00       	call   80104200 <acquire>
  if(writable){
80103336:	85 f6                	test   %esi,%esi
80103338:	74 3e                	je     80103378 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010333a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103340:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103347:	00 00 00 
    wakeup(&p->nread);
8010334a:	89 04 24             	mov    %eax,(%esp)
8010334d:	e8 fe 0a 00 00       	call   80103e50 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103352:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103358:	85 d2                	test   %edx,%edx
8010335a:	75 0a                	jne    80103366 <pipeclose+0x46>
8010335c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103362:	85 c0                	test   %eax,%eax
80103364:	74 32                	je     80103398 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103366:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103369:	83 c4 10             	add    $0x10,%esp
8010336c:	5b                   	pop    %ebx
8010336d:	5e                   	pop    %esi
8010336e:	5d                   	pop    %ebp
    release(&p->lock);
8010336f:	e9 7c 0f 00 00       	jmp    801042f0 <release>
80103374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103378:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
8010337e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103385:	00 00 00 
    wakeup(&p->nwrite);
80103388:	89 04 24             	mov    %eax,(%esp)
8010338b:	e8 c0 0a 00 00       	call   80103e50 <wakeup>
80103390:	eb c0                	jmp    80103352 <pipeclose+0x32>
80103392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
80103398:	89 1c 24             	mov    %ebx,(%esp)
8010339b:	e8 50 0f 00 00       	call   801042f0 <release>
    kfree((char*)p);
801033a0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033a3:	83 c4 10             	add    $0x10,%esp
801033a6:	5b                   	pop    %ebx
801033a7:	5e                   	pop    %esi
801033a8:	5d                   	pop    %ebp
    kfree((char*)p);
801033a9:	e9 02 f0 ff ff       	jmp    801023b0 <kfree>
801033ae:	66 90                	xchg   %ax,%ax

801033b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	57                   	push   %edi
801033b4:	56                   	push   %esi
801033b5:	53                   	push   %ebx
801033b6:	83 ec 1c             	sub    $0x1c,%esp
801033b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801033bc:	89 1c 24             	mov    %ebx,(%esp)
801033bf:	e8 3c 0e 00 00       	call   80104200 <acquire>
  for(i = 0; i < n; i++){
801033c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801033c7:	85 c9                	test   %ecx,%ecx
801033c9:	0f 8e b2 00 00 00    	jle    80103481 <pipewrite+0xd1>
801033cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033d2:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801033d8:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033de:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033e4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033e7:	03 4d 10             	add    0x10(%ebp),%ecx
801033ea:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ed:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033f3:	81 c1 00 02 00 00    	add    $0x200,%ecx
801033f9:	39 c8                	cmp    %ecx,%eax
801033fb:	74 38                	je     80103435 <pipewrite+0x85>
801033fd:	eb 55                	jmp    80103454 <pipewrite+0xa4>
801033ff:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103400:	e8 5b 03 00 00       	call   80103760 <myproc>
80103405:	8b 40 24             	mov    0x24(%eax),%eax
80103408:	85 c0                	test   %eax,%eax
8010340a:	75 33                	jne    8010343f <pipewrite+0x8f>
      wakeup(&p->nread);
8010340c:	89 3c 24             	mov    %edi,(%esp)
8010340f:	e8 3c 0a 00 00       	call   80103e50 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103414:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103418:	89 34 24             	mov    %esi,(%esp)
8010341b:	e8 a0 08 00 00       	call   80103cc0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103420:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103426:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010342c:	05 00 02 00 00       	add    $0x200,%eax
80103431:	39 c2                	cmp    %eax,%edx
80103433:	75 23                	jne    80103458 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103435:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010343b:	85 d2                	test   %edx,%edx
8010343d:	75 c1                	jne    80103400 <pipewrite+0x50>
        release(&p->lock);
8010343f:	89 1c 24             	mov    %ebx,(%esp)
80103442:	e8 a9 0e 00 00       	call   801042f0 <release>
        return -1;
80103447:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010344c:	83 c4 1c             	add    $0x1c,%esp
8010344f:	5b                   	pop    %ebx
80103450:	5e                   	pop    %esi
80103451:	5f                   	pop    %edi
80103452:	5d                   	pop    %ebp
80103453:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103454:	89 c2                	mov    %eax,%edx
80103456:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103458:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010345b:	8d 42 01             	lea    0x1(%edx),%eax
8010345e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103464:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010346a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010346e:	0f b6 09             	movzbl (%ecx),%ecx
80103471:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103475:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103478:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
8010347b:	0f 85 6c ff ff ff    	jne    801033ed <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103481:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103487:	89 04 24             	mov    %eax,(%esp)
8010348a:	e8 c1 09 00 00       	call   80103e50 <wakeup>
  release(&p->lock);
8010348f:	89 1c 24             	mov    %ebx,(%esp)
80103492:	e8 59 0e 00 00       	call   801042f0 <release>
  return n;
80103497:	8b 45 10             	mov    0x10(%ebp),%eax
8010349a:	eb b0                	jmp    8010344c <pipewrite+0x9c>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 1c             	sub    $0x1c,%esp
801034a9:	8b 75 08             	mov    0x8(%ebp),%esi
801034ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801034af:	89 34 24             	mov    %esi,(%esp)
801034b2:	e8 49 0d 00 00       	call   80104200 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034b7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034bd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034c3:	75 5b                	jne    80103520 <piperead+0x80>
801034c5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801034cb:	85 db                	test   %ebx,%ebx
801034cd:	74 51                	je     80103520 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034cf:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801034d5:	eb 25                	jmp    801034fc <piperead+0x5c>
801034d7:	90                   	nop
801034d8:	89 74 24 04          	mov    %esi,0x4(%esp)
801034dc:	89 1c 24             	mov    %ebx,(%esp)
801034df:	e8 dc 07 00 00       	call   80103cc0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034e4:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034ea:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034f0:	75 2e                	jne    80103520 <piperead+0x80>
801034f2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801034f8:	85 d2                	test   %edx,%edx
801034fa:	74 24                	je     80103520 <piperead+0x80>
    if(myproc()->killed){
801034fc:	e8 5f 02 00 00       	call   80103760 <myproc>
80103501:	8b 48 24             	mov    0x24(%eax),%ecx
80103504:	85 c9                	test   %ecx,%ecx
80103506:	74 d0                	je     801034d8 <piperead+0x38>
      release(&p->lock);
80103508:	89 34 24             	mov    %esi,(%esp)
8010350b:	e8 e0 0d 00 00       	call   801042f0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103510:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103518:	5b                   	pop    %ebx
80103519:	5e                   	pop    %esi
8010351a:	5f                   	pop    %edi
8010351b:	5d                   	pop    %ebp
8010351c:	c3                   	ret    
8010351d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103520:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103523:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103525:	85 d2                	test   %edx,%edx
80103527:	7f 2b                	jg     80103554 <piperead+0xb4>
80103529:	eb 31                	jmp    8010355c <piperead+0xbc>
8010352b:	90                   	nop
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103530:	8d 48 01             	lea    0x1(%eax),%ecx
80103533:	25 ff 01 00 00       	and    $0x1ff,%eax
80103538:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010353e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103543:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103546:	83 c3 01             	add    $0x1,%ebx
80103549:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010354c:	74 0e                	je     8010355c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010354e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103554:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010355a:	75 d4                	jne    80103530 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010355c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103562:	89 04 24             	mov    %eax,(%esp)
80103565:	e8 e6 08 00 00       	call   80103e50 <wakeup>
  release(&p->lock);
8010356a:	89 34 24             	mov    %esi,(%esp)
8010356d:	e8 7e 0d 00 00       	call   801042f0 <release>
}
80103572:	83 c4 1c             	add    $0x1c,%esp
  return i;
80103575:	89 d8                	mov    %ebx,%eax
}
80103577:	5b                   	pop    %ebx
80103578:	5e                   	pop    %esi
80103579:	5f                   	pop    %edi
8010357a:	5d                   	pop    %ebp
8010357b:	c3                   	ret    
8010357c:	66 90                	xchg   %ax,%ax
8010357e:	66 90                	xchg   %ax,%ax

80103580 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103584:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103589:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010358c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103593:	e8 68 0c 00 00       	call   80104200 <acquire>
80103598:	eb 11                	jmp    801035ab <allocproc+0x2b>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035a0:	83 c3 7c             	add    $0x7c,%ebx
801035a3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801035a9:	74 7d                	je     80103628 <allocproc+0xa8>
    if(p->state == UNUSED)
801035ab:	8b 43 0c             	mov    0xc(%ebx),%eax
801035ae:	85 c0                	test   %eax,%eax
801035b0:	75 ee                	jne    801035a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035b2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801035b7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
801035be:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801035c5:	8d 50 01             	lea    0x1(%eax),%edx
801035c8:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801035ce:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801035d1:	e8 1a 0d 00 00       	call   801042f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801035d6:	e8 85 ef ff ff       	call   80102560 <kalloc>
801035db:	85 c0                	test   %eax,%eax
801035dd:	89 43 08             	mov    %eax,0x8(%ebx)
801035e0:	74 5a                	je     8010363c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035e2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801035e8:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801035ed:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801035f0:	c7 40 14 75 54 10 80 	movl   $0x80105475,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801035f7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801035fe:	00 
801035ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103606:	00 
80103607:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010360a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010360d:	e8 2e 0d 00 00       	call   80104340 <memset>
  p->context->eip = (uint)forkret;
80103612:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103615:	c7 40 10 50 36 10 80 	movl   $0x80103650,0x10(%eax)

  return p;
8010361c:	89 d8                	mov    %ebx,%eax
}
8010361e:	83 c4 14             	add    $0x14,%esp
80103621:	5b                   	pop    %ebx
80103622:	5d                   	pop    %ebp
80103623:	c3                   	ret    
80103624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103628:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010362f:	e8 bc 0c 00 00       	call   801042f0 <release>
}
80103634:	83 c4 14             	add    $0x14,%esp
  return 0;
80103637:	31 c0                	xor    %eax,%eax
}
80103639:	5b                   	pop    %ebx
8010363a:	5d                   	pop    %ebp
8010363b:	c3                   	ret    
    p->state = UNUSED;
8010363c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103643:	eb d9                	jmp    8010361e <allocproc+0x9e>
80103645:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103650 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103656:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010365d:	e8 8e 0c 00 00       	call   801042f0 <release>

  if (first) {
80103662:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103667:	85 c0                	test   %eax,%eax
80103669:	75 05                	jne    80103670 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010366b:	c9                   	leave  
8010366c:	c3                   	ret    
8010366d:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
80103670:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
80103677:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010367e:	00 00 00 
    iinit(ROOTDEV);
80103681:	e8 aa de ff ff       	call   80101530 <iinit>
    initlog(ROOTDEV);
80103686:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010368d:	e8 9e f4 ff ff       	call   80102b30 <initlog>
}
80103692:	c9                   	leave  
80103693:	c3                   	ret    
80103694:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010369a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036a0 <pinit>:
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801036a6:	c7 44 24 04 d5 71 10 	movl   $0x801071d5,0x4(%esp)
801036ad:	80 
801036ae:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801036b5:	e8 56 0a 00 00       	call   80104110 <initlock>
}
801036ba:	c9                   	leave  
801036bb:	c3                   	ret    
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036c0 <mycpu>:
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx
801036c5:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036c8:	9c                   	pushf  
801036c9:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801036ca:	f6 c4 02             	test   $0x2,%ah
801036cd:	75 57                	jne    80103726 <mycpu+0x66>
  apicid = lapicid();
801036cf:	e8 4c f1 ff ff       	call   80102820 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801036d4:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801036da:	85 f6                	test   %esi,%esi
801036dc:	7e 3c                	jle    8010371a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036de:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801036e5:	39 c2                	cmp    %eax,%edx
801036e7:	74 2d                	je     80103716 <mycpu+0x56>
801036e9:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
801036ee:	31 d2                	xor    %edx,%edx
801036f0:	83 c2 01             	add    $0x1,%edx
801036f3:	39 f2                	cmp    %esi,%edx
801036f5:	74 23                	je     8010371a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036f7:	0f b6 19             	movzbl (%ecx),%ebx
801036fa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103700:	39 c3                	cmp    %eax,%ebx
80103702:	75 ec                	jne    801036f0 <mycpu+0x30>
      return &cpus[i];
80103704:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010370a:	83 c4 10             	add    $0x10,%esp
8010370d:	5b                   	pop    %ebx
8010370e:	5e                   	pop    %esi
8010370f:	5d                   	pop    %ebp
      return &cpus[i];
80103710:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103715:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103716:	31 d2                	xor    %edx,%edx
80103718:	eb ea                	jmp    80103704 <mycpu+0x44>
  panic("unknown apicid\n");
8010371a:	c7 04 24 dc 71 10 80 	movl   $0x801071dc,(%esp)
80103721:	e8 3a cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103726:	c7 04 24 b8 72 10 80 	movl   $0x801072b8,(%esp)
8010372d:	e8 2e cc ff ff       	call   80100360 <panic>
80103732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <cpuid>:
cpuid() {
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103746:	e8 75 ff ff ff       	call   801036c0 <mycpu>
}
8010374b:	c9                   	leave  
  return mycpu()-cpus;
8010374c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103751:	c1 f8 04             	sar    $0x4,%eax
80103754:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010375a:	c3                   	ret    
8010375b:	90                   	nop
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103760 <myproc>:
myproc(void) {
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	53                   	push   %ebx
80103764:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103767:	e8 54 0a 00 00       	call   801041c0 <pushcli>
  c = mycpu();
8010376c:	e8 4f ff ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103771:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103777:	e8 04 0b 00 00       	call   80104280 <popcli>
}
8010377c:	83 c4 04             	add    $0x4,%esp
8010377f:	89 d8                	mov    %ebx,%eax
80103781:	5b                   	pop    %ebx
80103782:	5d                   	pop    %ebp
80103783:	c3                   	ret    
80103784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010378a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103790 <userinit>:
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103797:	e8 e4 fd ff ff       	call   80103580 <allocproc>
8010379c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010379e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801037a3:	e8 38 32 00 00       	call   801069e0 <setupkvm>
801037a8:	85 c0                	test   %eax,%eax
801037aa:	89 43 04             	mov    %eax,0x4(%ebx)
801037ad:	0f 84 d4 00 00 00    	je     80103887 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037b3:	89 04 24             	mov    %eax,(%esp)
801037b6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801037bd:	00 
801037be:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801037c5:	80 
801037c6:	e8 45 2f 00 00       	call   80106710 <inituvm>
  p->sz = PGSIZE;
801037cb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037d1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801037d8:	00 
801037d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801037e0:	00 
801037e1:	8b 43 18             	mov    0x18(%ebx),%eax
801037e4:	89 04 24             	mov    %eax,(%esp)
801037e7:	e8 54 0b 00 00       	call   80104340 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037ec:	8b 43 18             	mov    0x18(%ebx),%eax
801037ef:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037f4:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037f9:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037fd:	8b 43 18             	mov    0x18(%ebx),%eax
80103800:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103804:	8b 43 18             	mov    0x18(%ebx),%eax
80103807:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010380b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010380f:	8b 43 18             	mov    0x18(%ebx),%eax
80103812:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103816:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010381a:	8b 43 18             	mov    0x18(%ebx),%eax
8010381d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103824:	8b 43 18             	mov    0x18(%ebx),%eax
80103827:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010382e:	8b 43 18             	mov    0x18(%ebx),%eax
80103831:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103838:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010383b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103842:	00 
80103843:	c7 44 24 04 05 72 10 	movl   $0x80107205,0x4(%esp)
8010384a:	80 
8010384b:	89 04 24             	mov    %eax,(%esp)
8010384e:	e8 cd 0c 00 00       	call   80104520 <safestrcpy>
  p->cwd = namei("/");
80103853:	c7 04 24 0e 72 10 80 	movl   $0x8010720e,(%esp)
8010385a:	e8 61 e7 ff ff       	call   80101fc0 <namei>
8010385f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103862:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103869:	e8 92 09 00 00       	call   80104200 <acquire>
  p->state = RUNNABLE;
8010386e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103875:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010387c:	e8 6f 0a 00 00       	call   801042f0 <release>
}
80103881:	83 c4 14             	add    $0x14,%esp
80103884:	5b                   	pop    %ebx
80103885:	5d                   	pop    %ebp
80103886:	c3                   	ret    
    panic("userinit: out of memory?");
80103887:	c7 04 24 ec 71 10 80 	movl   $0x801071ec,(%esp)
8010388e:	e8 cd ca ff ff       	call   80100360 <panic>
80103893:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038a0 <growproc>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	56                   	push   %esi
801038a4:	53                   	push   %ebx
801038a5:	83 ec 10             	sub    $0x10,%esp
801038a8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801038ab:	e8 b0 fe ff ff       	call   80103760 <myproc>
  if(n > 0){
801038b0:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
801038b3:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801038b5:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801038b7:	7e 2f                	jle    801038e8 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038b9:	01 c6                	add    %eax,%esi
801038bb:	89 74 24 08          	mov    %esi,0x8(%esp)
801038bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801038c3:	8b 43 04             	mov    0x4(%ebx),%eax
801038c6:	89 04 24             	mov    %eax,(%esp)
801038c9:	e8 82 2f 00 00       	call   80106850 <allocuvm>
801038ce:	85 c0                	test   %eax,%eax
801038d0:	74 36                	je     80103908 <growproc+0x68>
  curproc->sz = sz;
801038d2:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038d4:	89 1c 24             	mov    %ebx,(%esp)
801038d7:	e8 24 2d 00 00       	call   80106600 <switchuvm>
  return 0;
801038dc:	31 c0                	xor    %eax,%eax
}
801038de:	83 c4 10             	add    $0x10,%esp
801038e1:	5b                   	pop    %ebx
801038e2:	5e                   	pop    %esi
801038e3:	5d                   	pop    %ebp
801038e4:	c3                   	ret    
801038e5:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
801038e8:	74 e8                	je     801038d2 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038ea:	01 c6                	add    %eax,%esi
801038ec:	89 74 24 08          	mov    %esi,0x8(%esp)
801038f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801038f4:	8b 43 04             	mov    0x4(%ebx),%eax
801038f7:	89 04 24             	mov    %eax,(%esp)
801038fa:	e8 41 30 00 00       	call   80106940 <deallocuvm>
801038ff:	85 c0                	test   %eax,%eax
80103901:	75 cf                	jne    801038d2 <growproc+0x32>
80103903:	90                   	nop
80103904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010390d:	eb cf                	jmp    801038de <growproc+0x3e>
8010390f:	90                   	nop

80103910 <fork>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	57                   	push   %edi
80103914:	56                   	push   %esi
80103915:	53                   	push   %ebx
80103916:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103919:	e8 42 fe ff ff       	call   80103760 <myproc>
8010391e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103920:	e8 5b fc ff ff       	call   80103580 <allocproc>
80103925:	85 c0                	test   %eax,%eax
80103927:	89 c7                	mov    %eax,%edi
80103929:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010392c:	0f 84 bc 00 00 00    	je     801039ee <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103932:	8b 03                	mov    (%ebx),%eax
80103934:	89 44 24 04          	mov    %eax,0x4(%esp)
80103938:	8b 43 04             	mov    0x4(%ebx),%eax
8010393b:	89 04 24             	mov    %eax,(%esp)
8010393e:	e8 7d 31 00 00       	call   80106ac0 <copyuvm>
80103943:	85 c0                	test   %eax,%eax
80103945:	89 47 04             	mov    %eax,0x4(%edi)
80103948:	0f 84 a7 00 00 00    	je     801039f5 <fork+0xe5>
  np->sz = curproc->sz;
8010394e:	8b 03                	mov    (%ebx),%eax
80103950:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103953:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103955:	8b 79 18             	mov    0x18(%ecx),%edi
80103958:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
8010395a:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010395d:	8b 73 18             	mov    0x18(%ebx),%esi
80103960:	b9 13 00 00 00       	mov    $0x13,%ecx
80103965:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103967:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103969:	8b 40 18             	mov    0x18(%eax),%eax
8010396c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103973:	90                   	nop
80103974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103978:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010397c:	85 c0                	test   %eax,%eax
8010397e:	74 0f                	je     8010398f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103980:	89 04 24             	mov    %eax,(%esp)
80103983:	e8 58 d4 ff ff       	call   80100de0 <filedup>
80103988:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010398b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010398f:	83 c6 01             	add    $0x1,%esi
80103992:	83 fe 10             	cmp    $0x10,%esi
80103995:	75 e1                	jne    80103978 <fork+0x68>
  np->cwd = idup(curproc->cwd);
80103997:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010399a:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010399d:	89 04 24             	mov    %eax,(%esp)
801039a0:	e8 9b dd ff ff       	call   80101740 <idup>
801039a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039a8:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039ab:	8d 47 6c             	lea    0x6c(%edi),%eax
801039ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801039b2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039b9:	00 
801039ba:	89 04 24             	mov    %eax,(%esp)
801039bd:	e8 5e 0b 00 00       	call   80104520 <safestrcpy>
  pid = np->pid;
801039c2:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801039c5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039cc:	e8 2f 08 00 00       	call   80104200 <acquire>
  np->state = RUNNABLE;
801039d1:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801039d8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039df:	e8 0c 09 00 00       	call   801042f0 <release>
  return pid;
801039e4:	89 d8                	mov    %ebx,%eax
}
801039e6:	83 c4 1c             	add    $0x1c,%esp
801039e9:	5b                   	pop    %ebx
801039ea:	5e                   	pop    %esi
801039eb:	5f                   	pop    %edi
801039ec:	5d                   	pop    %ebp
801039ed:	c3                   	ret    
    return -1;
801039ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039f3:	eb f1                	jmp    801039e6 <fork+0xd6>
    kfree(np->kstack);
801039f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039f8:	8b 47 08             	mov    0x8(%edi),%eax
801039fb:	89 04 24             	mov    %eax,(%esp)
801039fe:	e8 ad e9 ff ff       	call   801023b0 <kfree>
    return -1;
80103a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103a08:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a0f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a16:	eb ce                	jmp    801039e6 <fork+0xd6>
80103a18:	90                   	nop
80103a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a20 <scheduler>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	57                   	push   %edi
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103a29:	e8 92 fc ff ff       	call   801036c0 <mycpu>
80103a2e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a30:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a37:	00 00 00 
80103a3a:	8d 78 04             	lea    0x4(%eax),%edi
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103a40:	fb                   	sti    
    acquire(&ptable.lock);
80103a41:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a48:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103a4d:	e8 ae 07 00 00       	call   80104200 <acquire>
80103a52:	eb 0f                	jmp    80103a63 <scheduler+0x43>
80103a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a58:	83 c3 7c             	add    $0x7c,%ebx
80103a5b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103a61:	74 45                	je     80103aa8 <scheduler+0x88>
      if(p->state != RUNNABLE)
80103a63:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a67:	75 ef                	jne    80103a58 <scheduler+0x38>
      c->proc = p;
80103a69:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a6f:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a72:	83 c3 7c             	add    $0x7c,%ebx
      switchuvm(p);
80103a75:	e8 86 2b 00 00       	call   80106600 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103a7a:	8b 43 a0             	mov    -0x60(%ebx),%eax
      p->state = RUNNING;
80103a7d:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&(c->scheduler), p->context);
80103a84:	89 3c 24             	mov    %edi,(%esp)
80103a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a8b:	e8 eb 0a 00 00       	call   8010457b <swtch>
      switchkvm();
80103a90:	e8 4b 2b 00 00       	call   801065e0 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a95:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
      c->proc = 0;
80103a9b:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103aa2:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aa5:	75 bc                	jne    80103a63 <scheduler+0x43>
80103aa7:	90                   	nop
    release(&ptable.lock);
80103aa8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103aaf:	e8 3c 08 00 00       	call   801042f0 <release>
  }
80103ab4:	eb 8a                	jmp    80103a40 <scheduler+0x20>
80103ab6:	8d 76 00             	lea    0x0(%esi),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <sched>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103ac8:	e8 93 fc ff ff       	call   80103760 <myproc>
  if(!holding(&ptable.lock))
80103acd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103ad4:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103ad6:	e8 b5 06 00 00       	call   80104190 <holding>
80103adb:	85 c0                	test   %eax,%eax
80103add:	74 4f                	je     80103b2e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103adf:	e8 dc fb ff ff       	call   801036c0 <mycpu>
80103ae4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103aeb:	75 65                	jne    80103b52 <sched+0x92>
  if(p->state == RUNNING)
80103aed:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103af1:	74 53                	je     80103b46 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103af3:	9c                   	pushf  
80103af4:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103af5:	f6 c4 02             	test   $0x2,%ah
80103af8:	75 40                	jne    80103b3a <sched+0x7a>
  intena = mycpu()->intena;
80103afa:	e8 c1 fb ff ff       	call   801036c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103aff:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103b02:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b08:	e8 b3 fb ff ff       	call   801036c0 <mycpu>
80103b0d:	8b 40 04             	mov    0x4(%eax),%eax
80103b10:	89 1c 24             	mov    %ebx,(%esp)
80103b13:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b17:	e8 5f 0a 00 00       	call   8010457b <swtch>
  mycpu()->intena = intena;
80103b1c:	e8 9f fb ff ff       	call   801036c0 <mycpu>
80103b21:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b27:	83 c4 10             	add    $0x10,%esp
80103b2a:	5b                   	pop    %ebx
80103b2b:	5e                   	pop    %esi
80103b2c:	5d                   	pop    %ebp
80103b2d:	c3                   	ret    
    panic("sched ptable.lock");
80103b2e:	c7 04 24 10 72 10 80 	movl   $0x80107210,(%esp)
80103b35:	e8 26 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103b3a:	c7 04 24 3c 72 10 80 	movl   $0x8010723c,(%esp)
80103b41:	e8 1a c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103b46:	c7 04 24 2e 72 10 80 	movl   $0x8010722e,(%esp)
80103b4d:	e8 0e c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103b52:	c7 04 24 22 72 10 80 	movl   $0x80107222,(%esp)
80103b59:	e8 02 c8 ff ff       	call   80100360 <panic>
80103b5e:	66 90                	xchg   %ax,%ax

80103b60 <exit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
  if(curproc == initproc)
80103b64:	31 f6                	xor    %esi,%esi
{
80103b66:	53                   	push   %ebx
80103b67:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b6a:	e8 f1 fb ff ff       	call   80103760 <myproc>
  if(curproc == initproc)
80103b6f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103b75:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103b77:	0f 84 ea 00 00 00    	je     80103c67 <exit+0x107>
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103b80:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	74 10                	je     80103b98 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b88:	89 04 24             	mov    %eax,(%esp)
80103b8b:	e8 a0 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103b90:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b97:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103b98:	83 c6 01             	add    $0x1,%esi
80103b9b:	83 fe 10             	cmp    $0x10,%esi
80103b9e:	75 e0                	jne    80103b80 <exit+0x20>
  begin_op();
80103ba0:	e8 2b f0 ff ff       	call   80102bd0 <begin_op>
  iput(curproc->cwd);
80103ba5:	8b 43 68             	mov    0x68(%ebx),%eax
80103ba8:	89 04 24             	mov    %eax,(%esp)
80103bab:	e8 e0 dc ff ff       	call   80101890 <iput>
  end_op();
80103bb0:	e8 8b f0 ff ff       	call   80102c40 <end_op>
  curproc->cwd = 0;
80103bb5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103bbc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bc3:	e8 38 06 00 00       	call   80104200 <acquire>
  wakeup1(curproc->parent);
80103bc8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bcb:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103bd0:	eb 11                	jmp    80103be3 <exit+0x83>
80103bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bd8:	83 c2 7c             	add    $0x7c,%edx
80103bdb:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103be1:	74 1d                	je     80103c00 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103be3:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103be7:	75 ef                	jne    80103bd8 <exit+0x78>
80103be9:	3b 42 20             	cmp    0x20(%edx),%eax
80103bec:	75 ea                	jne    80103bd8 <exit+0x78>
      p->state = RUNNABLE;
80103bee:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bf5:	83 c2 7c             	add    $0x7c,%edx
80103bf8:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103bfe:	75 e3                	jne    80103be3 <exit+0x83>
      p->parent = initproc;
80103c00:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103c05:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103c0a:	eb 0f                	jmp    80103c1b <exit+0xbb>
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c10:	83 c1 7c             	add    $0x7c,%ecx
80103c13:	81 f9 54 4c 11 80    	cmp    $0x80114c54,%ecx
80103c19:	74 34                	je     80103c4f <exit+0xef>
    if(p->parent == curproc){
80103c1b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103c1e:	75 f0                	jne    80103c10 <exit+0xb0>
      if(p->state == ZOMBIE)
80103c20:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103c24:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103c27:	75 e7                	jne    80103c10 <exit+0xb0>
80103c29:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c2e:	eb 0b                	jmp    80103c3b <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c30:	83 c2 7c             	add    $0x7c,%edx
80103c33:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103c39:	74 d5                	je     80103c10 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103c3b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c3f:	75 ef                	jne    80103c30 <exit+0xd0>
80103c41:	3b 42 20             	cmp    0x20(%edx),%eax
80103c44:	75 ea                	jne    80103c30 <exit+0xd0>
      p->state = RUNNABLE;
80103c46:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c4d:	eb e1                	jmp    80103c30 <exit+0xd0>
  curproc->state = ZOMBIE;
80103c4f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103c56:	e8 65 fe ff ff       	call   80103ac0 <sched>
  panic("zombie exit");
80103c5b:	c7 04 24 5d 72 10 80 	movl   $0x8010725d,(%esp)
80103c62:	e8 f9 c6 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103c67:	c7 04 24 50 72 10 80 	movl   $0x80107250,(%esp)
80103c6e:	e8 ed c6 ff ff       	call   80100360 <panic>
80103c73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c80 <yield>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c86:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c8d:	e8 6e 05 00 00       	call   80104200 <acquire>
  myproc()->state = RUNNABLE;
80103c92:	e8 c9 fa ff ff       	call   80103760 <myproc>
80103c97:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c9e:	e8 1d fe ff ff       	call   80103ac0 <sched>
  release(&ptable.lock);
80103ca3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103caa:	e8 41 06 00 00       	call   801042f0 <release>
}
80103caf:	c9                   	leave  
80103cb0:	c3                   	ret    
80103cb1:	eb 0d                	jmp    80103cc0 <sleep>
80103cb3:	90                   	nop
80103cb4:	90                   	nop
80103cb5:	90                   	nop
80103cb6:	90                   	nop
80103cb7:	90                   	nop
80103cb8:	90                   	nop
80103cb9:	90                   	nop
80103cba:	90                   	nop
80103cbb:	90                   	nop
80103cbc:	90                   	nop
80103cbd:	90                   	nop
80103cbe:	90                   	nop
80103cbf:	90                   	nop

80103cc0 <sleep>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	57                   	push   %edi
80103cc4:	56                   	push   %esi
80103cc5:	53                   	push   %ebx
80103cc6:	83 ec 1c             	sub    $0x1c,%esp
80103cc9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ccc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103ccf:	e8 8c fa ff ff       	call   80103760 <myproc>
  if(p == 0)
80103cd4:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103cd6:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103cd8:	0f 84 7c 00 00 00    	je     80103d5a <sleep+0x9a>
  if(lk == 0)
80103cde:	85 f6                	test   %esi,%esi
80103ce0:	74 6c                	je     80103d4e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ce2:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103ce8:	74 46                	je     80103d30 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103cea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cf1:	e8 0a 05 00 00       	call   80104200 <acquire>
    release(lk);
80103cf6:	89 34 24             	mov    %esi,(%esp)
80103cf9:	e8 f2 05 00 00       	call   801042f0 <release>
  p->chan = chan;
80103cfe:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d01:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103d08:	e8 b3 fd ff ff       	call   80103ac0 <sched>
  p->chan = 0;
80103d0d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103d14:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d1b:	e8 d0 05 00 00       	call   801042f0 <release>
    acquire(lk);
80103d20:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103d23:	83 c4 1c             	add    $0x1c,%esp
80103d26:	5b                   	pop    %ebx
80103d27:	5e                   	pop    %esi
80103d28:	5f                   	pop    %edi
80103d29:	5d                   	pop    %ebp
    acquire(lk);
80103d2a:	e9 d1 04 00 00       	jmp    80104200 <acquire>
80103d2f:	90                   	nop
  p->chan = chan;
80103d30:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103d33:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103d3a:	e8 81 fd ff ff       	call   80103ac0 <sched>
  p->chan = 0;
80103d3f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103d46:	83 c4 1c             	add    $0x1c,%esp
80103d49:	5b                   	pop    %ebx
80103d4a:	5e                   	pop    %esi
80103d4b:	5f                   	pop    %edi
80103d4c:	5d                   	pop    %ebp
80103d4d:	c3                   	ret    
    panic("sleep without lk");
80103d4e:	c7 04 24 6f 72 10 80 	movl   $0x8010726f,(%esp)
80103d55:	e8 06 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103d5a:	c7 04 24 69 72 10 80 	movl   $0x80107269,(%esp)
80103d61:	e8 fa c5 ff ff       	call   80100360 <panic>
80103d66:	8d 76 00             	lea    0x0(%esi),%esi
80103d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d70 <wait>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
80103d75:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103d78:	e8 e3 f9 ff ff       	call   80103760 <myproc>
  acquire(&ptable.lock);
80103d7d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103d84:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103d86:	e8 75 04 00 00       	call   80104200 <acquire>
    havekids = 0;
80103d8b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d8d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103d92:	eb 0f                	jmp    80103da3 <wait+0x33>
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d98:	83 c3 7c             	add    $0x7c,%ebx
80103d9b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103da1:	74 1d                	je     80103dc0 <wait+0x50>
      if(p->parent != curproc)
80103da3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103da6:	75 f0                	jne    80103d98 <wait+0x28>
      if(p->state == ZOMBIE){
80103da8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103dac:	74 2f                	je     80103ddd <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dae:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103db1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db6:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103dbc:	75 e5                	jne    80103da3 <wait+0x33>
80103dbe:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103dc0:	85 c0                	test   %eax,%eax
80103dc2:	74 6e                	je     80103e32 <wait+0xc2>
80103dc4:	8b 46 24             	mov    0x24(%esi),%eax
80103dc7:	85 c0                	test   %eax,%eax
80103dc9:	75 67                	jne    80103e32 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103dcb:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103dd2:	80 
80103dd3:	89 34 24             	mov    %esi,(%esp)
80103dd6:	e8 e5 fe ff ff       	call   80103cc0 <sleep>
  }
80103ddb:	eb ae                	jmp    80103d8b <wait+0x1b>
        kfree(p->kstack);
80103ddd:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103de0:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103de3:	89 04 24             	mov    %eax,(%esp)
80103de6:	e8 c5 e5 ff ff       	call   801023b0 <kfree>
        freevm(p->pgdir);
80103deb:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103dee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103df5:	89 04 24             	mov    %eax,(%esp)
80103df8:	e8 63 2b 00 00       	call   80106960 <freevm>
        release(&ptable.lock);
80103dfd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103e04:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e0b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e12:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e16:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e1d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e24:	e8 c7 04 00 00       	call   801042f0 <release>
}
80103e29:	83 c4 10             	add    $0x10,%esp
        return pid;
80103e2c:	89 f0                	mov    %esi,%eax
}
80103e2e:	5b                   	pop    %ebx
80103e2f:	5e                   	pop    %esi
80103e30:	5d                   	pop    %ebp
80103e31:	c3                   	ret    
      release(&ptable.lock);
80103e32:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e39:	e8 b2 04 00 00       	call   801042f0 <release>
}
80103e3e:	83 c4 10             	add    $0x10,%esp
      return -1;
80103e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e46:	5b                   	pop    %ebx
80103e47:	5e                   	pop    %esi
80103e48:	5d                   	pop    %ebp
80103e49:	c3                   	ret    
80103e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e50 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
80103e54:	83 ec 14             	sub    $0x14,%esp
80103e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e5a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e61:	e8 9a 03 00 00       	call   80104200 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e66:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e6b:	eb 0d                	jmp    80103e7a <wakeup+0x2a>
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
80103e70:	83 c0 7c             	add    $0x7c,%eax
80103e73:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e78:	74 1e                	je     80103e98 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103e7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e7e:	75 f0                	jne    80103e70 <wakeup+0x20>
80103e80:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e83:	75 eb                	jne    80103e70 <wakeup+0x20>
      p->state = RUNNABLE;
80103e85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e8c:	83 c0 7c             	add    $0x7c,%eax
80103e8f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e94:	75 e4                	jne    80103e7a <wakeup+0x2a>
80103e96:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103e98:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103e9f:	83 c4 14             	add    $0x14,%esp
80103ea2:	5b                   	pop    %ebx
80103ea3:	5d                   	pop    %ebp
  release(&ptable.lock);
80103ea4:	e9 47 04 00 00       	jmp    801042f0 <release>
80103ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103eb0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 14             	sub    $0x14,%esp
80103eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103eba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ec1:	e8 3a 03 00 00       	call   80104200 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ecb:	eb 0d                	jmp    80103eda <kill+0x2a>
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi
80103ed0:	83 c0 7c             	add    $0x7c,%eax
80103ed3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103ed8:	74 36                	je     80103f10 <kill+0x60>
    if(p->pid == pid){
80103eda:	39 58 10             	cmp    %ebx,0x10(%eax)
80103edd:	75 f1                	jne    80103ed0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103edf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103ee3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103eea:	74 14                	je     80103f00 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103eec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ef3:	e8 f8 03 00 00       	call   801042f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103ef8:	83 c4 14             	add    $0x14,%esp
      return 0;
80103efb:	31 c0                	xor    %eax,%eax
}
80103efd:	5b                   	pop    %ebx
80103efe:	5d                   	pop    %ebp
80103eff:	c3                   	ret    
        p->state = RUNNABLE;
80103f00:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f07:	eb e3                	jmp    80103eec <kill+0x3c>
80103f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103f10:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f17:	e8 d4 03 00 00       	call   801042f0 <release>
}
80103f1c:	83 c4 14             	add    $0x14,%esp
  return -1;
80103f1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f24:	5b                   	pop    %ebx
80103f25:	5d                   	pop    %ebp
80103f26:	c3                   	ret    
80103f27:	89 f6                	mov    %esi,%esi
80103f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f30 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	57                   	push   %edi
80103f34:	56                   	push   %esi
80103f35:	53                   	push   %ebx
80103f36:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103f3b:	83 ec 4c             	sub    $0x4c,%esp
80103f3e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103f41:	eb 20                	jmp    80103f63 <procdump+0x33>
80103f43:	90                   	nop
80103f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f48:	c7 04 24 f7 75 10 80 	movl   $0x801075f7,(%esp)
80103f4f:	e8 fc c6 ff ff       	call   80100650 <cprintf>
80103f54:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f57:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80103f5d:	0f 84 8d 00 00 00    	je     80103ff0 <procdump+0xc0>
    if(p->state == UNUSED)
80103f63:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f66:	85 c0                	test   %eax,%eax
80103f68:	74 ea                	je     80103f54 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f6a:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103f6d:	ba 80 72 10 80       	mov    $0x80107280,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f72:	77 11                	ja     80103f85 <procdump+0x55>
80103f74:	8b 14 85 e0 72 10 80 	mov    -0x7fef8d20(,%eax,4),%edx
      state = "???";
80103f7b:	b8 80 72 10 80       	mov    $0x80107280,%eax
80103f80:	85 d2                	test   %edx,%edx
80103f82:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f85:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f88:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f8c:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f90:	c7 04 24 84 72 10 80 	movl   $0x80107284,(%esp)
80103f97:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f9b:	e8 b0 c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103fa0:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103fa4:	75 a2                	jne    80103f48 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103fa6:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fad:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103fb0:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103fb3:	8b 40 0c             	mov    0xc(%eax),%eax
80103fb6:	83 c0 08             	add    $0x8,%eax
80103fb9:	89 04 24             	mov    %eax,(%esp)
80103fbc:	e8 6f 01 00 00       	call   80104130 <getcallerpcs>
80103fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103fc8:	8b 17                	mov    (%edi),%edx
80103fca:	85 d2                	test   %edx,%edx
80103fcc:	0f 84 76 ff ff ff    	je     80103f48 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103fd2:	89 54 24 04          	mov    %edx,0x4(%esp)
80103fd6:	83 c7 04             	add    $0x4,%edi
80103fd9:	c7 04 24 c1 6c 10 80 	movl   $0x80106cc1,(%esp)
80103fe0:	e8 6b c6 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103fe5:	39 f7                	cmp    %esi,%edi
80103fe7:	75 df                	jne    80103fc8 <procdump+0x98>
80103fe9:	e9 5a ff ff ff       	jmp    80103f48 <procdump+0x18>
80103fee:	66 90                	xchg   %ax,%ax
  }
}
80103ff0:	83 c4 4c             	add    $0x4c,%esp
80103ff3:	5b                   	pop    %ebx
80103ff4:	5e                   	pop    %esi
80103ff5:	5f                   	pop    %edi
80103ff6:	5d                   	pop    %ebp
80103ff7:	c3                   	ret    
80103ff8:	66 90                	xchg   %ax,%ax
80103ffa:	66 90                	xchg   %ax,%ax
80103ffc:	66 90                	xchg   %ax,%ax
80103ffe:	66 90                	xchg   %ax,%ax

80104000 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 14             	sub    $0x14,%esp
80104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010400a:	c7 44 24 04 f8 72 10 	movl   $0x801072f8,0x4(%esp)
80104011:	80 
80104012:	8d 43 04             	lea    0x4(%ebx),%eax
80104015:	89 04 24             	mov    %eax,(%esp)
80104018:	e8 f3 00 00 00       	call   80104110 <initlock>
  lk->name = name;
8010401d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104020:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104026:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010402d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104030:	83 c4 14             	add    $0x14,%esp
80104033:	5b                   	pop    %ebx
80104034:	5d                   	pop    %ebp
80104035:	c3                   	ret    
80104036:	8d 76 00             	lea    0x0(%esi),%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104040 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
80104045:	83 ec 10             	sub    $0x10,%esp
80104048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010404b:	8d 73 04             	lea    0x4(%ebx),%esi
8010404e:	89 34 24             	mov    %esi,(%esp)
80104051:	e8 aa 01 00 00       	call   80104200 <acquire>
  while (lk->locked) {
80104056:	8b 13                	mov    (%ebx),%edx
80104058:	85 d2                	test   %edx,%edx
8010405a:	74 16                	je     80104072 <acquiresleep+0x32>
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104060:	89 74 24 04          	mov    %esi,0x4(%esp)
80104064:	89 1c 24             	mov    %ebx,(%esp)
80104067:	e8 54 fc ff ff       	call   80103cc0 <sleep>
  while (lk->locked) {
8010406c:	8b 03                	mov    (%ebx),%eax
8010406e:	85 c0                	test   %eax,%eax
80104070:	75 ee                	jne    80104060 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104072:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104078:	e8 e3 f6 ff ff       	call   80103760 <myproc>
8010407d:	8b 40 10             	mov    0x10(%eax),%eax
80104080:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104083:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104086:	83 c4 10             	add    $0x10,%esp
80104089:	5b                   	pop    %ebx
8010408a:	5e                   	pop    %esi
8010408b:	5d                   	pop    %ebp
  release(&lk->lk);
8010408c:	e9 5f 02 00 00       	jmp    801042f0 <release>
80104091:	eb 0d                	jmp    801040a0 <releasesleep>
80104093:	90                   	nop
80104094:	90                   	nop
80104095:	90                   	nop
80104096:	90                   	nop
80104097:	90                   	nop
80104098:	90                   	nop
80104099:	90                   	nop
8010409a:	90                   	nop
8010409b:	90                   	nop
8010409c:	90                   	nop
8010409d:	90                   	nop
8010409e:	90                   	nop
8010409f:	90                   	nop

801040a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	56                   	push   %esi
801040a4:	53                   	push   %ebx
801040a5:	83 ec 10             	sub    $0x10,%esp
801040a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040ab:	8d 73 04             	lea    0x4(%ebx),%esi
801040ae:	89 34 24             	mov    %esi,(%esp)
801040b1:	e8 4a 01 00 00       	call   80104200 <acquire>
  lk->locked = 0;
801040b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040bc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801040c3:	89 1c 24             	mov    %ebx,(%esp)
801040c6:	e8 85 fd ff ff       	call   80103e50 <wakeup>
  release(&lk->lk);
801040cb:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040ce:	83 c4 10             	add    $0x10,%esp
801040d1:	5b                   	pop    %ebx
801040d2:	5e                   	pop    %esi
801040d3:	5d                   	pop    %ebp
  release(&lk->lk);
801040d4:	e9 17 02 00 00       	jmp    801042f0 <release>
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	56                   	push   %esi
801040e4:	53                   	push   %ebx
801040e5:	83 ec 10             	sub    $0x10,%esp
801040e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801040eb:	8d 73 04             	lea    0x4(%ebx),%esi
801040ee:	89 34 24             	mov    %esi,(%esp)
801040f1:	e8 0a 01 00 00       	call   80104200 <acquire>
  r = lk->locked;
801040f6:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
801040f8:	89 34 24             	mov    %esi,(%esp)
801040fb:	e8 f0 01 00 00       	call   801042f0 <release>
  return r;
}
80104100:	83 c4 10             	add    $0x10,%esp
80104103:	89 d8                	mov    %ebx,%eax
80104105:	5b                   	pop    %ebx
80104106:	5e                   	pop    %esi
80104107:	5d                   	pop    %ebp
80104108:	c3                   	ret    
80104109:	66 90                	xchg   %ax,%ax
8010410b:	66 90                	xchg   %ax,%ax
8010410d:	66 90                	xchg   %ax,%ax
8010410f:	90                   	nop

80104110 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104116:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010411f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104122:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104129:	5d                   	pop    %ebp
8010412a:	c3                   	ret    
8010412b:	90                   	nop
8010412c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104130 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104133:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104136:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104139:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010413a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010413d:	31 c0                	xor    %eax,%eax
8010413f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104140:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104146:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010414c:	77 1a                	ja     80104168 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010414e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104151:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104154:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104157:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104159:	83 f8 0a             	cmp    $0xa,%eax
8010415c:	75 e2                	jne    80104140 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010415e:	5b                   	pop    %ebx
8010415f:	5d                   	pop    %ebp
80104160:	c3                   	ret    
80104161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104168:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010416f:	83 c0 01             	add    $0x1,%eax
80104172:	83 f8 0a             	cmp    $0xa,%eax
80104175:	74 e7                	je     8010415e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104177:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010417e:	83 c0 01             	add    $0x1,%eax
80104181:	83 f8 0a             	cmp    $0xa,%eax
80104184:	75 e2                	jne    80104168 <getcallerpcs+0x38>
80104186:	eb d6                	jmp    8010415e <getcallerpcs+0x2e>
80104188:	90                   	nop
80104189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104190 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104190:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
80104191:	31 c0                	xor    %eax,%eax
{
80104193:	89 e5                	mov    %esp,%ebp
80104195:	53                   	push   %ebx
80104196:	83 ec 04             	sub    $0x4,%esp
80104199:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010419c:	8b 0a                	mov    (%edx),%ecx
8010419e:	85 c9                	test   %ecx,%ecx
801041a0:	74 10                	je     801041b2 <holding+0x22>
801041a2:	8b 5a 08             	mov    0x8(%edx),%ebx
801041a5:	e8 16 f5 ff ff       	call   801036c0 <mycpu>
801041aa:	39 c3                	cmp    %eax,%ebx
801041ac:	0f 94 c0             	sete   %al
801041af:	0f b6 c0             	movzbl %al,%eax
}
801041b2:	83 c4 04             	add    $0x4,%esp
801041b5:	5b                   	pop    %ebx
801041b6:	5d                   	pop    %ebp
801041b7:	c3                   	ret    
801041b8:	90                   	nop
801041b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 04             	sub    $0x4,%esp
801041c7:	9c                   	pushf  
801041c8:	5b                   	pop    %ebx
  asm volatile("cli");
801041c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801041ca:	e8 f1 f4 ff ff       	call   801036c0 <mycpu>
801041cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801041d5:	85 c0                	test   %eax,%eax
801041d7:	75 11                	jne    801041ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801041d9:	e8 e2 f4 ff ff       	call   801036c0 <mycpu>
801041de:	81 e3 00 02 00 00    	and    $0x200,%ebx
801041e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801041ea:	e8 d1 f4 ff ff       	call   801036c0 <mycpu>
801041ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801041f6:	83 c4 04             	add    $0x4,%esp
801041f9:	5b                   	pop    %ebx
801041fa:	5d                   	pop    %ebp
801041fb:	c3                   	ret    
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104200 <acquire>:
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104207:	e8 b4 ff ff ff       	call   801041c0 <pushcli>
  if(holding(lk))
8010420c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010420f:	8b 02                	mov    (%edx),%eax
80104211:	85 c0                	test   %eax,%eax
80104213:	75 43                	jne    80104258 <acquire+0x58>
  asm volatile("lock; xchgl %0, %1" :
80104215:	b9 01 00 00 00       	mov    $0x1,%ecx
8010421a:	eb 07                	jmp    80104223 <acquire+0x23>
8010421c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104220:	8b 55 08             	mov    0x8(%ebp),%edx
80104223:	89 c8                	mov    %ecx,%eax
80104225:	f0 87 02             	lock xchg %eax,(%edx)
  while(xchg(&lk->locked, 1) != 0)
80104228:	85 c0                	test   %eax,%eax
8010422a:	75 f4                	jne    80104220 <acquire+0x20>
  __sync_synchronize();
8010422c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010422f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104232:	e8 89 f4 ff ff       	call   801036c0 <mycpu>
80104237:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010423a:	8b 45 08             	mov    0x8(%ebp),%eax
8010423d:	83 c0 0c             	add    $0xc,%eax
80104240:	89 44 24 04          	mov    %eax,0x4(%esp)
80104244:	8d 45 08             	lea    0x8(%ebp),%eax
80104247:	89 04 24             	mov    %eax,(%esp)
8010424a:	e8 e1 fe ff ff       	call   80104130 <getcallerpcs>
}
8010424f:	83 c4 14             	add    $0x14,%esp
80104252:	5b                   	pop    %ebx
80104253:	5d                   	pop    %ebp
80104254:	c3                   	ret    
80104255:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104258:	8b 5a 08             	mov    0x8(%edx),%ebx
8010425b:	e8 60 f4 ff ff       	call   801036c0 <mycpu>
  if(holding(lk))
80104260:	39 c3                	cmp    %eax,%ebx
80104262:	74 05                	je     80104269 <acquire+0x69>
80104264:	8b 55 08             	mov    0x8(%ebp),%edx
80104267:	eb ac                	jmp    80104215 <acquire+0x15>
    panic("acquire");
80104269:	c7 04 24 03 73 10 80 	movl   $0x80107303,(%esp)
80104270:	e8 eb c0 ff ff       	call   80100360 <panic>
80104275:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104280 <popcli>:

void
popcli(void)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104286:	9c                   	pushf  
80104287:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104288:	f6 c4 02             	test   $0x2,%ah
8010428b:	75 49                	jne    801042d6 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010428d:	e8 2e f4 ff ff       	call   801036c0 <mycpu>
80104292:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104298:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010429b:	85 d2                	test   %edx,%edx
8010429d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801042a3:	78 25                	js     801042ca <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042a5:	e8 16 f4 ff ff       	call   801036c0 <mycpu>
801042aa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801042b0:	85 d2                	test   %edx,%edx
801042b2:	74 04                	je     801042b8 <popcli+0x38>
    sti();
}
801042b4:	c9                   	leave  
801042b5:	c3                   	ret    
801042b6:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042b8:	e8 03 f4 ff ff       	call   801036c0 <mycpu>
801042bd:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801042c3:	85 c0                	test   %eax,%eax
801042c5:	74 ed                	je     801042b4 <popcli+0x34>
  asm volatile("sti");
801042c7:	fb                   	sti    
}
801042c8:	c9                   	leave  
801042c9:	c3                   	ret    
    panic("popcli");
801042ca:	c7 04 24 22 73 10 80 	movl   $0x80107322,(%esp)
801042d1:	e8 8a c0 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
801042d6:	c7 04 24 0b 73 10 80 	movl   $0x8010730b,(%esp)
801042dd:	e8 7e c0 ff ff       	call   80100360 <panic>
801042e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042f0 <release>:
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
801042f5:	83 ec 10             	sub    $0x10,%esp
801042f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801042fb:	8b 03                	mov    (%ebx),%eax
801042fd:	85 c0                	test   %eax,%eax
801042ff:	75 0f                	jne    80104310 <release+0x20>
    panic("release");
80104301:	c7 04 24 29 73 10 80 	movl   $0x80107329,(%esp)
80104308:	e8 53 c0 ff ff       	call   80100360 <panic>
8010430d:	8d 76 00             	lea    0x0(%esi),%esi
  return lock->locked && lock->cpu == mycpu();
80104310:	8b 73 08             	mov    0x8(%ebx),%esi
80104313:	e8 a8 f3 ff ff       	call   801036c0 <mycpu>
  if(!holding(lk))
80104318:	39 c6                	cmp    %eax,%esi
8010431a:	75 e5                	jne    80104301 <release+0x11>
  lk->pcs[0] = 0;
8010431c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104323:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010432a:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010432d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104333:	83 c4 10             	add    $0x10,%esp
80104336:	5b                   	pop    %ebx
80104337:	5e                   	pop    %esi
80104338:	5d                   	pop    %ebp
  popcli();
80104339:	e9 42 ff ff ff       	jmp    80104280 <popcli>
8010433e:	66 90                	xchg   %ax,%ax

80104340 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	8b 55 08             	mov    0x8(%ebp),%edx
80104346:	57                   	push   %edi
80104347:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010434a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010434b:	f6 c2 03             	test   $0x3,%dl
8010434e:	75 05                	jne    80104355 <memset+0x15>
80104350:	f6 c1 03             	test   $0x3,%cl
80104353:	74 13                	je     80104368 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104355:	89 d7                	mov    %edx,%edi
80104357:	8b 45 0c             	mov    0xc(%ebp),%eax
8010435a:	fc                   	cld    
8010435b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010435d:	5b                   	pop    %ebx
8010435e:	89 d0                	mov    %edx,%eax
80104360:	5f                   	pop    %edi
80104361:	5d                   	pop    %ebp
80104362:	c3                   	ret    
80104363:	90                   	nop
80104364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104368:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010436c:	c1 e9 02             	shr    $0x2,%ecx
8010436f:	89 f8                	mov    %edi,%eax
80104371:	89 fb                	mov    %edi,%ebx
80104373:	c1 e0 18             	shl    $0x18,%eax
80104376:	c1 e3 10             	shl    $0x10,%ebx
80104379:	09 d8                	or     %ebx,%eax
8010437b:	09 f8                	or     %edi,%eax
8010437d:	c1 e7 08             	shl    $0x8,%edi
80104380:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104382:	89 d7                	mov    %edx,%edi
80104384:	fc                   	cld    
80104385:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104387:	5b                   	pop    %ebx
80104388:	89 d0                	mov    %edx,%eax
8010438a:	5f                   	pop    %edi
8010438b:	5d                   	pop    %ebp
8010438c:	c3                   	ret    
8010438d:	8d 76 00             	lea    0x0(%esi),%esi

80104390 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	8b 45 10             	mov    0x10(%ebp),%eax
80104396:	57                   	push   %edi
80104397:	56                   	push   %esi
80104398:	8b 75 0c             	mov    0xc(%ebp),%esi
8010439b:	53                   	push   %ebx
8010439c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010439f:	85 c0                	test   %eax,%eax
801043a1:	8d 78 ff             	lea    -0x1(%eax),%edi
801043a4:	74 26                	je     801043cc <memcmp+0x3c>
    if(*s1 != *s2)
801043a6:	0f b6 03             	movzbl (%ebx),%eax
801043a9:	31 d2                	xor    %edx,%edx
801043ab:	0f b6 0e             	movzbl (%esi),%ecx
801043ae:	38 c8                	cmp    %cl,%al
801043b0:	74 16                	je     801043c8 <memcmp+0x38>
801043b2:	eb 24                	jmp    801043d8 <memcmp+0x48>
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801043bd:	83 c2 01             	add    $0x1,%edx
801043c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043c4:	38 c8                	cmp    %cl,%al
801043c6:	75 10                	jne    801043d8 <memcmp+0x48>
  while(n-- > 0){
801043c8:	39 fa                	cmp    %edi,%edx
801043ca:	75 ec                	jne    801043b8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801043cc:	5b                   	pop    %ebx
  return 0;
801043cd:	31 c0                	xor    %eax,%eax
}
801043cf:	5e                   	pop    %esi
801043d0:	5f                   	pop    %edi
801043d1:	5d                   	pop    %ebp
801043d2:	c3                   	ret    
801043d3:	90                   	nop
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d8:	5b                   	pop    %ebx
      return *s1 - *s2;
801043d9:	29 c8                	sub    %ecx,%eax
}
801043db:	5e                   	pop    %esi
801043dc:	5f                   	pop    %edi
801043dd:	5d                   	pop    %ebp
801043de:	c3                   	ret    
801043df:	90                   	nop

801043e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	8b 45 08             	mov    0x8(%ebp),%eax
801043e7:	56                   	push   %esi
801043e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043eb:	53                   	push   %ebx
801043ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801043ef:	39 c6                	cmp    %eax,%esi
801043f1:	73 35                	jae    80104428 <memmove+0x48>
801043f3:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801043f6:	39 c8                	cmp    %ecx,%eax
801043f8:	73 2e                	jae    80104428 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
801043fa:	85 db                	test   %ebx,%ebx
    d += n;
801043fc:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
801043ff:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104402:	74 1b                	je     8010441f <memmove+0x3f>
80104404:	f7 db                	neg    %ebx
80104406:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104409:	01 fb                	add    %edi,%ebx
8010440b:	90                   	nop
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104410:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104414:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104417:	83 ea 01             	sub    $0x1,%edx
8010441a:	83 fa ff             	cmp    $0xffffffff,%edx
8010441d:	75 f1                	jne    80104410 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010441f:	5b                   	pop    %ebx
80104420:	5e                   	pop    %esi
80104421:	5f                   	pop    %edi
80104422:	5d                   	pop    %ebp
80104423:	c3                   	ret    
80104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104428:	31 d2                	xor    %edx,%edx
8010442a:	85 db                	test   %ebx,%ebx
8010442c:	74 f1                	je     8010441f <memmove+0x3f>
8010442e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104430:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104434:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104437:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010443a:	39 da                	cmp    %ebx,%edx
8010443c:	75 f2                	jne    80104430 <memmove+0x50>
}
8010443e:	5b                   	pop    %ebx
8010443f:	5e                   	pop    %esi
80104440:	5f                   	pop    %edi
80104441:	5d                   	pop    %ebp
80104442:	c3                   	ret    
80104443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104450 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104453:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104454:	eb 8a                	jmp    801043e0 <memmove>
80104456:	8d 76 00             	lea    0x0(%esi),%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104460 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	8b 75 10             	mov    0x10(%ebp),%esi
80104467:	53                   	push   %ebx
80104468:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010446b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010446e:	85 f6                	test   %esi,%esi
80104470:	74 30                	je     801044a2 <strncmp+0x42>
80104472:	0f b6 01             	movzbl (%ecx),%eax
80104475:	84 c0                	test   %al,%al
80104477:	74 2f                	je     801044a8 <strncmp+0x48>
80104479:	0f b6 13             	movzbl (%ebx),%edx
8010447c:	38 d0                	cmp    %dl,%al
8010447e:	75 46                	jne    801044c6 <strncmp+0x66>
80104480:	8d 51 01             	lea    0x1(%ecx),%edx
80104483:	01 ce                	add    %ecx,%esi
80104485:	eb 14                	jmp    8010449b <strncmp+0x3b>
80104487:	90                   	nop
80104488:	0f b6 02             	movzbl (%edx),%eax
8010448b:	84 c0                	test   %al,%al
8010448d:	74 31                	je     801044c0 <strncmp+0x60>
8010448f:	0f b6 19             	movzbl (%ecx),%ebx
80104492:	83 c2 01             	add    $0x1,%edx
80104495:	38 d8                	cmp    %bl,%al
80104497:	75 17                	jne    801044b0 <strncmp+0x50>
    n--, p++, q++;
80104499:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
8010449b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010449d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
801044a0:	75 e6                	jne    80104488 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801044a2:	5b                   	pop    %ebx
    return 0;
801044a3:	31 c0                	xor    %eax,%eax
}
801044a5:	5e                   	pop    %esi
801044a6:	5d                   	pop    %ebp
801044a7:	c3                   	ret    
801044a8:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
801044ab:	31 c0                	xor    %eax,%eax
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
801044b0:	0f b6 d3             	movzbl %bl,%edx
801044b3:	29 d0                	sub    %edx,%eax
}
801044b5:	5b                   	pop    %ebx
801044b6:	5e                   	pop    %esi
801044b7:	5d                   	pop    %ebp
801044b8:	c3                   	ret    
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044c0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801044c4:	eb ea                	jmp    801044b0 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
801044c6:	89 d3                	mov    %edx,%ebx
801044c8:	eb e6                	jmp    801044b0 <strncmp+0x50>
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	8b 45 08             	mov    0x8(%ebp),%eax
801044d6:	56                   	push   %esi
801044d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044da:	53                   	push   %ebx
801044db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801044de:	89 c2                	mov    %eax,%edx
801044e0:	eb 19                	jmp    801044fb <strncpy+0x2b>
801044e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044e8:	83 c3 01             	add    $0x1,%ebx
801044eb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801044ef:	83 c2 01             	add    $0x1,%edx
801044f2:	84 c9                	test   %cl,%cl
801044f4:	88 4a ff             	mov    %cl,-0x1(%edx)
801044f7:	74 09                	je     80104502 <strncpy+0x32>
801044f9:	89 f1                	mov    %esi,%ecx
801044fb:	85 c9                	test   %ecx,%ecx
801044fd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104500:	7f e6                	jg     801044e8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104502:	31 c9                	xor    %ecx,%ecx
80104504:	85 f6                	test   %esi,%esi
80104506:	7e 0f                	jle    80104517 <strncpy+0x47>
    *s++ = 0;
80104508:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010450c:	89 f3                	mov    %esi,%ebx
8010450e:	83 c1 01             	add    $0x1,%ecx
80104511:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104513:	85 db                	test   %ebx,%ebx
80104515:	7f f1                	jg     80104508 <strncpy+0x38>
  return os;
}
80104517:	5b                   	pop    %ebx
80104518:	5e                   	pop    %esi
80104519:	5d                   	pop    %ebp
8010451a:	c3                   	ret    
8010451b:	90                   	nop
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104520 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104526:	56                   	push   %esi
80104527:	8b 45 08             	mov    0x8(%ebp),%eax
8010452a:	53                   	push   %ebx
8010452b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010452e:	85 c9                	test   %ecx,%ecx
80104530:	7e 26                	jle    80104558 <safestrcpy+0x38>
80104532:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104536:	89 c1                	mov    %eax,%ecx
80104538:	eb 17                	jmp    80104551 <safestrcpy+0x31>
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104540:	83 c2 01             	add    $0x1,%edx
80104543:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104547:	83 c1 01             	add    $0x1,%ecx
8010454a:	84 db                	test   %bl,%bl
8010454c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010454f:	74 04                	je     80104555 <safestrcpy+0x35>
80104551:	39 f2                	cmp    %esi,%edx
80104553:	75 eb                	jne    80104540 <safestrcpy+0x20>
    ;
  *s = 0;
80104555:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104558:	5b                   	pop    %ebx
80104559:	5e                   	pop    %esi
8010455a:	5d                   	pop    %ebp
8010455b:	c3                   	ret    
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104560 <strlen>:

int
strlen(const char *s)
{
80104560:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104561:	31 c0                	xor    %eax,%eax
{
80104563:	89 e5                	mov    %esp,%ebp
80104565:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104568:	80 3a 00             	cmpb   $0x0,(%edx)
8010456b:	74 0c                	je     80104579 <strlen+0x19>
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
80104570:	83 c0 01             	add    $0x1,%eax
80104573:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104577:	75 f7                	jne    80104570 <strlen+0x10>
    ;
  return n;
}
80104579:	5d                   	pop    %ebp
8010457a:	c3                   	ret    

8010457b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010457b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010457f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104583:	55                   	push   %ebp
  pushl %ebx
80104584:	53                   	push   %ebx
  pushl %esi
80104585:	56                   	push   %esi
  pushl %edi
80104586:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104587:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104589:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010458b:	5f                   	pop    %edi
  popl %esi
8010458c:	5e                   	pop    %esi
  popl %ebx
8010458d:	5b                   	pop    %ebx
  popl %ebp
8010458e:	5d                   	pop    %ebp
  ret
8010458f:	c3                   	ret    

80104590 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 04             	sub    $0x4,%esp
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010459a:	e8 c1 f1 ff ff       	call   80103760 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010459f:	8b 00                	mov    (%eax),%eax
801045a1:	39 d8                	cmp    %ebx,%eax
801045a3:	76 1b                	jbe    801045c0 <fetchint+0x30>
801045a5:	8d 53 04             	lea    0x4(%ebx),%edx
801045a8:	39 d0                	cmp    %edx,%eax
801045aa:	72 14                	jb     801045c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801045ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801045af:	8b 13                	mov    (%ebx),%edx
801045b1:	89 10                	mov    %edx,(%eax)
  return 0;
801045b3:	31 c0                	xor    %eax,%eax
}
801045b5:	83 c4 04             	add    $0x4,%esp
801045b8:	5b                   	pop    %ebx
801045b9:	5d                   	pop    %ebp
801045ba:	c3                   	ret    
801045bb:	90                   	nop
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801045c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c5:	eb ee                	jmp    801045b5 <fetchint+0x25>
801045c7:	89 f6                	mov    %esi,%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801045da:	e8 81 f1 ff ff       	call   80103760 <myproc>

  if(addr >= curproc->sz)
801045df:	39 18                	cmp    %ebx,(%eax)
801045e1:	76 26                	jbe    80104609 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
801045e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801045e6:	89 da                	mov    %ebx,%edx
801045e8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801045ea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801045ec:	39 c3                	cmp    %eax,%ebx
801045ee:	73 19                	jae    80104609 <fetchstr+0x39>
    if(*s == 0)
801045f0:	80 3b 00             	cmpb   $0x0,(%ebx)
801045f3:	75 0d                	jne    80104602 <fetchstr+0x32>
801045f5:	eb 21                	jmp    80104618 <fetchstr+0x48>
801045f7:	90                   	nop
801045f8:	80 3a 00             	cmpb   $0x0,(%edx)
801045fb:	90                   	nop
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104600:	74 16                	je     80104618 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104602:	83 c2 01             	add    $0x1,%edx
80104605:	39 d0                	cmp    %edx,%eax
80104607:	77 ef                	ja     801045f8 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
80104609:	83 c4 04             	add    $0x4,%esp
    return -1;
8010460c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104611:	5b                   	pop    %ebx
80104612:	5d                   	pop    %ebp
80104613:	c3                   	ret    
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104618:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010461b:	89 d0                	mov    %edx,%eax
8010461d:	29 d8                	sub    %ebx,%eax
}
8010461f:	5b                   	pop    %ebx
80104620:	5d                   	pop    %ebp
80104621:	c3                   	ret    
80104622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	8b 75 0c             	mov    0xc(%ebp),%esi
80104637:	53                   	push   %ebx
80104638:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010463b:	e8 20 f1 ff ff       	call   80103760 <myproc>
80104640:	89 75 0c             	mov    %esi,0xc(%ebp)
80104643:	8b 40 18             	mov    0x18(%eax),%eax
80104646:	8b 40 44             	mov    0x44(%eax),%eax
80104649:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010464d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104650:	5b                   	pop    %ebx
80104651:	5e                   	pop    %esi
80104652:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104653:	e9 38 ff ff ff       	jmp    80104590 <fetchint>
80104658:	90                   	nop
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104660 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	83 ec 20             	sub    $0x20,%esp
80104668:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010466b:	e8 f0 f0 ff ff       	call   80103760 <myproc>
80104670:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104672:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104675:	89 44 24 04          	mov    %eax,0x4(%esp)
80104679:	8b 45 08             	mov    0x8(%ebp),%eax
8010467c:	89 04 24             	mov    %eax,(%esp)
8010467f:	e8 ac ff ff ff       	call   80104630 <argint>
80104684:	85 c0                	test   %eax,%eax
80104686:	78 28                	js     801046b0 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104688:	85 db                	test   %ebx,%ebx
8010468a:	78 24                	js     801046b0 <argptr+0x50>
8010468c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010468f:	8b 06                	mov    (%esi),%eax
80104691:	39 c2                	cmp    %eax,%edx
80104693:	73 1b                	jae    801046b0 <argptr+0x50>
80104695:	01 d3                	add    %edx,%ebx
80104697:	39 d8                	cmp    %ebx,%eax
80104699:	72 15                	jb     801046b0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010469b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010469e:	89 10                	mov    %edx,(%eax)
  return 0;
}
801046a0:	83 c4 20             	add    $0x20,%esp
  return 0;
801046a3:	31 c0                	xor    %eax,%eax
}
801046a5:	5b                   	pop    %ebx
801046a6:	5e                   	pop    %esi
801046a7:	5d                   	pop    %ebp
801046a8:	c3                   	ret    
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b0:	83 c4 20             	add    $0x20,%esp
    return -1;
801046b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046b8:	5b                   	pop    %ebx
801046b9:	5e                   	pop    %esi
801046ba:	5d                   	pop    %ebp
801046bb:	c3                   	ret    
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801046c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801046cd:	8b 45 08             	mov    0x8(%ebp),%eax
801046d0:	89 04 24             	mov    %eax,(%esp)
801046d3:	e8 58 ff ff ff       	call   80104630 <argint>
801046d8:	85 c0                	test   %eax,%eax
801046da:	78 14                	js     801046f0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801046dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801046df:	89 44 24 04          	mov    %eax,0x4(%esp)
801046e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e6:	89 04 24             	mov    %eax,(%esp)
801046e9:	e8 e2 fe ff ff       	call   801045d0 <fetchstr>
}
801046ee:	c9                   	leave  
801046ef:	c3                   	ret    
    return -1;
801046f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046f5:	c9                   	leave  
801046f6:	c3                   	ret    
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104708:	e8 53 f0 ff ff       	call   80103760 <myproc>

  num = curproc->tf->eax;
8010470d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104710:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104712:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104715:	8d 50 ff             	lea    -0x1(%eax),%edx
80104718:	83 fa 14             	cmp    $0x14,%edx
8010471b:	77 1b                	ja     80104738 <syscall+0x38>
8010471d:	8b 14 85 60 73 10 80 	mov    -0x7fef8ca0(,%eax,4),%edx
80104724:	85 d2                	test   %edx,%edx
80104726:	74 10                	je     80104738 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104728:	ff d2                	call   *%edx
8010472a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010472d:	83 c4 10             	add    $0x10,%esp
80104730:	5b                   	pop    %ebx
80104731:	5e                   	pop    %esi
80104732:	5d                   	pop    %ebp
80104733:	c3                   	ret    
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104738:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010473c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010473f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104743:	8b 43 10             	mov    0x10(%ebx),%eax
80104746:	c7 04 24 31 73 10 80 	movl   $0x80107331,(%esp)
8010474d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104751:	e8 fa be ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104756:	8b 43 18             	mov    0x18(%ebx),%eax
80104759:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104760:	83 c4 10             	add    $0x10,%esp
80104763:	5b                   	pop    %ebx
80104764:	5e                   	pop    %esi
80104765:	5d                   	pop    %ebp
80104766:	c3                   	ret    
80104767:	66 90                	xchg   %ax,%ax
80104769:	66 90                	xchg   %ax,%ax
8010476b:	66 90                	xchg   %ax,%ax
8010476d:	66 90                	xchg   %ax,%ax
8010476f:	90                   	nop

80104770 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	89 c3                	mov    %eax,%ebx
80104776:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104779:	e8 e2 ef ff ff       	call   80103760 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010477e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104780:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104784:	85 c9                	test   %ecx,%ecx
80104786:	74 18                	je     801047a0 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104788:	83 c2 01             	add    $0x1,%edx
8010478b:	83 fa 10             	cmp    $0x10,%edx
8010478e:	75 f0                	jne    80104780 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104790:	83 c4 04             	add    $0x4,%esp
  return -1;
80104793:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104798:	5b                   	pop    %ebx
80104799:	5d                   	pop    %ebp
8010479a:	c3                   	ret    
8010479b:	90                   	nop
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801047a0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
801047a4:	83 c4 04             	add    $0x4,%esp
      return fd;
801047a7:	89 d0                	mov    %edx,%eax
}
801047a9:	5b                   	pop    %ebx
801047aa:	5d                   	pop    %ebp
801047ab:	c3                   	ret    
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	57                   	push   %edi
801047b4:	56                   	push   %esi
801047b5:	53                   	push   %ebx
801047b6:	83 ec 4c             	sub    $0x4c,%esp
801047b9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801047bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047bf:	8d 5d da             	lea    -0x26(%ebp),%ebx
801047c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047c6:	89 04 24             	mov    %eax,(%esp)
{
801047c9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801047cc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801047cf:	e8 0c d8 ff ff       	call   80101fe0 <nameiparent>
801047d4:	85 c0                	test   %eax,%eax
801047d6:	89 c7                	mov    %eax,%edi
801047d8:	0f 84 da 00 00 00    	je     801048b8 <create+0x108>
    return 0;
  ilock(dp);
801047de:	89 04 24             	mov    %eax,(%esp)
801047e1:	e8 8a cf ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801047e6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801047e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801047ed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047f1:	89 3c 24             	mov    %edi,(%esp)
801047f4:	e8 87 d4 ff ff       	call   80101c80 <dirlookup>
801047f9:	85 c0                	test   %eax,%eax
801047fb:	89 c6                	mov    %eax,%esi
801047fd:	74 41                	je     80104840 <create+0x90>
    iunlockput(dp);
801047ff:	89 3c 24             	mov    %edi,(%esp)
80104802:	e8 c9 d1 ff ff       	call   801019d0 <iunlockput>
    ilock(ip);
80104807:	89 34 24             	mov    %esi,(%esp)
8010480a:	e8 61 cf ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010480f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104814:	75 12                	jne    80104828 <create+0x78>
80104816:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010481b:	89 f0                	mov    %esi,%eax
8010481d:	75 09                	jne    80104828 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010481f:	83 c4 4c             	add    $0x4c,%esp
80104822:	5b                   	pop    %ebx
80104823:	5e                   	pop    %esi
80104824:	5f                   	pop    %edi
80104825:	5d                   	pop    %ebp
80104826:	c3                   	ret    
80104827:	90                   	nop
    iunlockput(ip);
80104828:	89 34 24             	mov    %esi,(%esp)
8010482b:	e8 a0 d1 ff ff       	call   801019d0 <iunlockput>
}
80104830:	83 c4 4c             	add    $0x4c,%esp
    return 0;
80104833:	31 c0                	xor    %eax,%eax
}
80104835:	5b                   	pop    %ebx
80104836:	5e                   	pop    %esi
80104837:	5f                   	pop    %edi
80104838:	5d                   	pop    %ebp
80104839:	c3                   	ret    
8010483a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104840:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104844:	89 44 24 04          	mov    %eax,0x4(%esp)
80104848:	8b 07                	mov    (%edi),%eax
8010484a:	89 04 24             	mov    %eax,(%esp)
8010484d:	e8 8e cd ff ff       	call   801015e0 <ialloc>
80104852:	85 c0                	test   %eax,%eax
80104854:	89 c6                	mov    %eax,%esi
80104856:	0f 84 bf 00 00 00    	je     8010491b <create+0x16b>
  ilock(ip);
8010485c:	89 04 24             	mov    %eax,(%esp)
8010485f:	e8 0c cf ff ff       	call   80101770 <ilock>
  ip->major = major;
80104864:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104868:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010486c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104870:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104874:	b8 01 00 00 00       	mov    $0x1,%eax
80104879:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010487d:	89 34 24             	mov    %esi,(%esp)
80104880:	e8 2b ce ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104885:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010488a:	74 34                	je     801048c0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
8010488c:	8b 46 04             	mov    0x4(%esi),%eax
8010488f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104893:	89 3c 24             	mov    %edi,(%esp)
80104896:	89 44 24 08          	mov    %eax,0x8(%esp)
8010489a:	e8 41 d6 ff ff       	call   80101ee0 <dirlink>
8010489f:	85 c0                	test   %eax,%eax
801048a1:	78 6c                	js     8010490f <create+0x15f>
  iunlockput(dp);
801048a3:	89 3c 24             	mov    %edi,(%esp)
801048a6:	e8 25 d1 ff ff       	call   801019d0 <iunlockput>
}
801048ab:	83 c4 4c             	add    $0x4c,%esp
  return ip;
801048ae:	89 f0                	mov    %esi,%eax
}
801048b0:	5b                   	pop    %ebx
801048b1:	5e                   	pop    %esi
801048b2:	5f                   	pop    %edi
801048b3:	5d                   	pop    %ebp
801048b4:	c3                   	ret    
801048b5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801048b8:	31 c0                	xor    %eax,%eax
801048ba:	e9 60 ff ff ff       	jmp    8010481f <create+0x6f>
801048bf:	90                   	nop
    dp->nlink++;  // for ".."
801048c0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801048c5:	89 3c 24             	mov    %edi,(%esp)
801048c8:	e8 e3 cd ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801048cd:	8b 46 04             	mov    0x4(%esi),%eax
801048d0:	c7 44 24 04 d4 73 10 	movl   $0x801073d4,0x4(%esp)
801048d7:	80 
801048d8:	89 34 24             	mov    %esi,(%esp)
801048db:	89 44 24 08          	mov    %eax,0x8(%esp)
801048df:	e8 fc d5 ff ff       	call   80101ee0 <dirlink>
801048e4:	85 c0                	test   %eax,%eax
801048e6:	78 1b                	js     80104903 <create+0x153>
801048e8:	8b 47 04             	mov    0x4(%edi),%eax
801048eb:	c7 44 24 04 d3 73 10 	movl   $0x801073d3,0x4(%esp)
801048f2:	80 
801048f3:	89 34 24             	mov    %esi,(%esp)
801048f6:	89 44 24 08          	mov    %eax,0x8(%esp)
801048fa:	e8 e1 d5 ff ff       	call   80101ee0 <dirlink>
801048ff:	85 c0                	test   %eax,%eax
80104901:	79 89                	jns    8010488c <create+0xdc>
      panic("create dots");
80104903:	c7 04 24 c7 73 10 80 	movl   $0x801073c7,(%esp)
8010490a:	e8 51 ba ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010490f:	c7 04 24 d6 73 10 80 	movl   $0x801073d6,(%esp)
80104916:	e8 45 ba ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010491b:	c7 04 24 b8 73 10 80 	movl   $0x801073b8,(%esp)
80104922:	e8 39 ba ff ff       	call   80100360 <panic>
80104927:	89 f6                	mov    %esi,%esi
80104929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104930 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	89 c6                	mov    %eax,%esi
80104936:	53                   	push   %ebx
80104937:	89 d3                	mov    %edx,%ebx
80104939:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
8010493c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010493f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104943:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010494a:	e8 e1 fc ff ff       	call   80104630 <argint>
8010494f:	85 c0                	test   %eax,%eax
80104951:	78 2d                	js     80104980 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104953:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104957:	77 27                	ja     80104980 <argfd.constprop.0+0x50>
80104959:	e8 02 ee ff ff       	call   80103760 <myproc>
8010495e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104961:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104965:	85 c0                	test   %eax,%eax
80104967:	74 17                	je     80104980 <argfd.constprop.0+0x50>
  if(pfd)
80104969:	85 f6                	test   %esi,%esi
8010496b:	74 02                	je     8010496f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010496d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010496f:	85 db                	test   %ebx,%ebx
80104971:	74 1d                	je     80104990 <argfd.constprop.0+0x60>
    *pf = f;
80104973:	89 03                	mov    %eax,(%ebx)
  return 0;
80104975:	31 c0                	xor    %eax,%eax
}
80104977:	83 c4 20             	add    $0x20,%esp
8010497a:	5b                   	pop    %ebx
8010497b:	5e                   	pop    %esi
8010497c:	5d                   	pop    %ebp
8010497d:	c3                   	ret    
8010497e:	66 90                	xchg   %ax,%ax
80104980:	83 c4 20             	add    $0x20,%esp
    return -1;
80104983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104988:	5b                   	pop    %ebx
80104989:	5e                   	pop    %esi
8010498a:	5d                   	pop    %ebp
8010498b:	c3                   	ret    
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104990:	31 c0                	xor    %eax,%eax
80104992:	eb e3                	jmp    80104977 <argfd.constprop.0+0x47>
80104994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010499a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049a0 <sys_dup>:
{
801049a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801049a1:	31 c0                	xor    %eax,%eax
{
801049a3:	89 e5                	mov    %esp,%ebp
801049a5:	53                   	push   %ebx
801049a6:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
801049a9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801049ac:	e8 7f ff ff ff       	call   80104930 <argfd.constprop.0>
801049b1:	85 c0                	test   %eax,%eax
801049b3:	78 23                	js     801049d8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801049b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b8:	e8 b3 fd ff ff       	call   80104770 <fdalloc>
801049bd:	85 c0                	test   %eax,%eax
801049bf:	89 c3                	mov    %eax,%ebx
801049c1:	78 15                	js     801049d8 <sys_dup+0x38>
  filedup(f);
801049c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c6:	89 04 24             	mov    %eax,(%esp)
801049c9:	e8 12 c4 ff ff       	call   80100de0 <filedup>
  return fd;
801049ce:	89 d8                	mov    %ebx,%eax
}
801049d0:	83 c4 24             	add    $0x24,%esp
801049d3:	5b                   	pop    %ebx
801049d4:	5d                   	pop    %ebp
801049d5:	c3                   	ret    
801049d6:	66 90                	xchg   %ax,%ax
    return -1;
801049d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049dd:	eb f1                	jmp    801049d0 <sys_dup+0x30>
801049df:	90                   	nop

801049e0 <sys_read>:
{
801049e0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049e1:	31 c0                	xor    %eax,%eax
{
801049e3:	89 e5                	mov    %esp,%ebp
801049e5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801049e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801049eb:	e8 40 ff ff ff       	call   80104930 <argfd.constprop.0>
801049f0:	85 c0                	test   %eax,%eax
801049f2:	78 54                	js     80104a48 <sys_read+0x68>
801049f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049fb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a02:	e8 29 fc ff ff       	call   80104630 <argint>
80104a07:	85 c0                	test   %eax,%eax
80104a09:	78 3d                	js     80104a48 <sys_read+0x68>
80104a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a15:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a20:	e8 3b fc ff ff       	call   80104660 <argptr>
80104a25:	85 c0                	test   %eax,%eax
80104a27:	78 1f                	js     80104a48 <sys_read+0x68>
  return fileread(f, p, n);
80104a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a33:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a3a:	89 04 24             	mov    %eax,(%esp)
80104a3d:	e8 fe c4 ff ff       	call   80100f40 <fileread>
}
80104a42:	c9                   	leave  
80104a43:	c3                   	ret    
80104a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a4d:	c9                   	leave  
80104a4e:	c3                   	ret    
80104a4f:	90                   	nop

80104a50 <sys_write>:
{
80104a50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a51:	31 c0                	xor    %eax,%eax
{
80104a53:	89 e5                	mov    %esp,%ebp
80104a55:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a5b:	e8 d0 fe ff ff       	call   80104930 <argfd.constprop.0>
80104a60:	85 c0                	test   %eax,%eax
80104a62:	78 54                	js     80104ab8 <sys_write+0x68>
80104a64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a67:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a6b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a72:	e8 b9 fb ff ff       	call   80104630 <argint>
80104a77:	85 c0                	test   %eax,%eax
80104a79:	78 3d                	js     80104ab8 <sys_write+0x68>
80104a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a85:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a90:	e8 cb fb ff ff       	call   80104660 <argptr>
80104a95:	85 c0                	test   %eax,%eax
80104a97:	78 1f                	js     80104ab8 <sys_write+0x68>
  return filewrite(f, p, n);
80104a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aaa:	89 04 24             	mov    %eax,(%esp)
80104aad:	e8 2e c5 ff ff       	call   80100fe0 <filewrite>
}
80104ab2:	c9                   	leave  
80104ab3:	c3                   	ret    
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104abd:	c9                   	leave  
80104abe:	c3                   	ret    
80104abf:	90                   	nop

80104ac0 <sys_close>:
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104ac6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ac9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104acc:	e8 5f fe ff ff       	call   80104930 <argfd.constprop.0>
80104ad1:	85 c0                	test   %eax,%eax
80104ad3:	78 23                	js     80104af8 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104ad5:	e8 86 ec ff ff       	call   80103760 <myproc>
80104ada:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104add:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ae4:	00 
  fileclose(f);
80104ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae8:	89 04 24             	mov    %eax,(%esp)
80104aeb:	e8 40 c3 ff ff       	call   80100e30 <fileclose>
  return 0;
80104af0:	31 c0                	xor    %eax,%eax
}
80104af2:	c9                   	leave  
80104af3:	c3                   	ret    
80104af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104afd:	c9                   	leave  
80104afe:	c3                   	ret    
80104aff:	90                   	nop

80104b00 <sys_fstat>:
{
80104b00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b01:	31 c0                	xor    %eax,%eax
{
80104b03:	89 e5                	mov    %esp,%ebp
80104b05:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b08:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b0b:	e8 20 fe ff ff       	call   80104930 <argfd.constprop.0>
80104b10:	85 c0                	test   %eax,%eax
80104b12:	78 34                	js     80104b48 <sys_fstat+0x48>
80104b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b17:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104b1e:	00 
80104b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b2a:	e8 31 fb ff ff       	call   80104660 <argptr>
80104b2f:	85 c0                	test   %eax,%eax
80104b31:	78 15                	js     80104b48 <sys_fstat+0x48>
  return filestat(f, st);
80104b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b36:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b3d:	89 04 24             	mov    %eax,(%esp)
80104b40:	e8 ab c3 ff ff       	call   80100ef0 <filestat>
}
80104b45:	c9                   	leave  
80104b46:	c3                   	ret    
80104b47:	90                   	nop
    return -1;
80104b48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b4d:	c9                   	leave  
80104b4e:	c3                   	ret    
80104b4f:	90                   	nop

80104b50 <sys_link>:
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	56                   	push   %esi
80104b55:	53                   	push   %ebx
80104b56:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104b59:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b67:	e8 54 fb ff ff       	call   801046c0 <argstr>
80104b6c:	85 c0                	test   %eax,%eax
80104b6e:	0f 88 e6 00 00 00    	js     80104c5a <sys_link+0x10a>
80104b74:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104b77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b82:	e8 39 fb ff ff       	call   801046c0 <argstr>
80104b87:	85 c0                	test   %eax,%eax
80104b89:	0f 88 cb 00 00 00    	js     80104c5a <sys_link+0x10a>
  begin_op();
80104b8f:	e8 3c e0 ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
80104b94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b97:	89 04 24             	mov    %eax,(%esp)
80104b9a:	e8 21 d4 ff ff       	call   80101fc0 <namei>
80104b9f:	85 c0                	test   %eax,%eax
80104ba1:	89 c3                	mov    %eax,%ebx
80104ba3:	0f 84 ac 00 00 00    	je     80104c55 <sys_link+0x105>
  ilock(ip);
80104ba9:	89 04 24             	mov    %eax,(%esp)
80104bac:	e8 bf cb ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
80104bb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104bb6:	0f 84 91 00 00 00    	je     80104c4d <sys_link+0xfd>
  ip->nlink++;
80104bbc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104bc1:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104bc4:	89 1c 24             	mov    %ebx,(%esp)
80104bc7:	e8 e4 ca ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80104bcc:	89 1c 24             	mov    %ebx,(%esp)
80104bcf:	e8 7c cc ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104bd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104bd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104bdb:	89 04 24             	mov    %eax,(%esp)
80104bde:	e8 fd d3 ff ff       	call   80101fe0 <nameiparent>
80104be3:	85 c0                	test   %eax,%eax
80104be5:	89 c6                	mov    %eax,%esi
80104be7:	74 4f                	je     80104c38 <sys_link+0xe8>
  ilock(dp);
80104be9:	89 04 24             	mov    %eax,(%esp)
80104bec:	e8 7f cb ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104bf1:	8b 03                	mov    (%ebx),%eax
80104bf3:	39 06                	cmp    %eax,(%esi)
80104bf5:	75 39                	jne    80104c30 <sys_link+0xe0>
80104bf7:	8b 43 04             	mov    0x4(%ebx),%eax
80104bfa:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104bfe:	89 34 24             	mov    %esi,(%esp)
80104c01:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c05:	e8 d6 d2 ff ff       	call   80101ee0 <dirlink>
80104c0a:	85 c0                	test   %eax,%eax
80104c0c:	78 22                	js     80104c30 <sys_link+0xe0>
  iunlockput(dp);
80104c0e:	89 34 24             	mov    %esi,(%esp)
80104c11:	e8 ba cd ff ff       	call   801019d0 <iunlockput>
  iput(ip);
80104c16:	89 1c 24             	mov    %ebx,(%esp)
80104c19:	e8 72 cc ff ff       	call   80101890 <iput>
  end_op();
80104c1e:	e8 1d e0 ff ff       	call   80102c40 <end_op>
}
80104c23:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104c26:	31 c0                	xor    %eax,%eax
}
80104c28:	5b                   	pop    %ebx
80104c29:	5e                   	pop    %esi
80104c2a:	5f                   	pop    %edi
80104c2b:	5d                   	pop    %ebp
80104c2c:	c3                   	ret    
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104c30:	89 34 24             	mov    %esi,(%esp)
80104c33:	e8 98 cd ff ff       	call   801019d0 <iunlockput>
  ilock(ip);
80104c38:	89 1c 24             	mov    %ebx,(%esp)
80104c3b:	e8 30 cb ff ff       	call   80101770 <ilock>
  ip->nlink--;
80104c40:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c45:	89 1c 24             	mov    %ebx,(%esp)
80104c48:	e8 63 ca ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80104c4d:	89 1c 24             	mov    %ebx,(%esp)
80104c50:	e8 7b cd ff ff       	call   801019d0 <iunlockput>
  end_op();
80104c55:	e8 e6 df ff ff       	call   80102c40 <end_op>
}
80104c5a:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104c5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c62:	5b                   	pop    %ebx
80104c63:	5e                   	pop    %esi
80104c64:	5f                   	pop    %edi
80104c65:	5d                   	pop    %ebp
80104c66:	c3                   	ret    
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <sys_unlink>:
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	53                   	push   %ebx
80104c76:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104c79:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c87:	e8 34 fa ff ff       	call   801046c0 <argstr>
80104c8c:	85 c0                	test   %eax,%eax
80104c8e:	0f 88 76 01 00 00    	js     80104e0a <sys_unlink+0x19a>
  begin_op();
80104c94:	e8 37 df ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104c99:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104c9c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104c9f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104ca3:	89 04 24             	mov    %eax,(%esp)
80104ca6:	e8 35 d3 ff ff       	call   80101fe0 <nameiparent>
80104cab:	85 c0                	test   %eax,%eax
80104cad:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104cb0:	0f 84 4f 01 00 00    	je     80104e05 <sys_unlink+0x195>
  ilock(dp);
80104cb6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104cb9:	89 34 24             	mov    %esi,(%esp)
80104cbc:	e8 af ca ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104cc1:	c7 44 24 04 d4 73 10 	movl   $0x801073d4,0x4(%esp)
80104cc8:	80 
80104cc9:	89 1c 24             	mov    %ebx,(%esp)
80104ccc:	e8 7f cf ff ff       	call   80101c50 <namecmp>
80104cd1:	85 c0                	test   %eax,%eax
80104cd3:	0f 84 21 01 00 00    	je     80104dfa <sys_unlink+0x18a>
80104cd9:	c7 44 24 04 d3 73 10 	movl   $0x801073d3,0x4(%esp)
80104ce0:	80 
80104ce1:	89 1c 24             	mov    %ebx,(%esp)
80104ce4:	e8 67 cf ff ff       	call   80101c50 <namecmp>
80104ce9:	85 c0                	test   %eax,%eax
80104ceb:	0f 84 09 01 00 00    	je     80104dfa <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104cf1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104cf4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104cf8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cfc:	89 34 24             	mov    %esi,(%esp)
80104cff:	e8 7c cf ff ff       	call   80101c80 <dirlookup>
80104d04:	85 c0                	test   %eax,%eax
80104d06:	89 c3                	mov    %eax,%ebx
80104d08:	0f 84 ec 00 00 00    	je     80104dfa <sys_unlink+0x18a>
  ilock(ip);
80104d0e:	89 04 24             	mov    %eax,(%esp)
80104d11:	e8 5a ca ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
80104d16:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d1b:	0f 8e 24 01 00 00    	jle    80104e45 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104d21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d26:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104d29:	74 7d                	je     80104da8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104d2b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104d32:	00 
80104d33:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104d3a:	00 
80104d3b:	89 34 24             	mov    %esi,(%esp)
80104d3e:	e8 fd f5 ff ff       	call   80104340 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d43:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104d46:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d4d:	00 
80104d4e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d52:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d56:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d59:	89 04 24             	mov    %eax,(%esp)
80104d5c:	e8 bf cd ff ff       	call   80101b20 <writei>
80104d61:	83 f8 10             	cmp    $0x10,%eax
80104d64:	0f 85 cf 00 00 00    	jne    80104e39 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104d6a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d6f:	0f 84 a3 00 00 00    	je     80104e18 <sys_unlink+0x1a8>
  iunlockput(dp);
80104d75:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d78:	89 04 24             	mov    %eax,(%esp)
80104d7b:	e8 50 cc ff ff       	call   801019d0 <iunlockput>
  ip->nlink--;
80104d80:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d85:	89 1c 24             	mov    %ebx,(%esp)
80104d88:	e8 23 c9 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80104d8d:	89 1c 24             	mov    %ebx,(%esp)
80104d90:	e8 3b cc ff ff       	call   801019d0 <iunlockput>
  end_op();
80104d95:	e8 a6 de ff ff       	call   80102c40 <end_op>
}
80104d9a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104d9d:	31 c0                	xor    %eax,%eax
}
80104d9f:	5b                   	pop    %ebx
80104da0:	5e                   	pop    %esi
80104da1:	5f                   	pop    %edi
80104da2:	5d                   	pop    %ebp
80104da3:	c3                   	ret    
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104da8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104dac:	0f 86 79 ff ff ff    	jbe    80104d2b <sys_unlink+0xbb>
80104db2:	bf 20 00 00 00       	mov    $0x20,%edi
80104db7:	eb 15                	jmp    80104dce <sys_unlink+0x15e>
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc0:	8d 57 10             	lea    0x10(%edi),%edx
80104dc3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104dc6:	0f 83 5f ff ff ff    	jae    80104d2b <sys_unlink+0xbb>
80104dcc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104dce:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104dd5:	00 
80104dd6:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104dda:	89 74 24 04          	mov    %esi,0x4(%esp)
80104dde:	89 1c 24             	mov    %ebx,(%esp)
80104de1:	e8 3a cc ff ff       	call   80101a20 <readi>
80104de6:	83 f8 10             	cmp    $0x10,%eax
80104de9:	75 42                	jne    80104e2d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104deb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104df0:	74 ce                	je     80104dc0 <sys_unlink+0x150>
    iunlockput(ip);
80104df2:	89 1c 24             	mov    %ebx,(%esp)
80104df5:	e8 d6 cb ff ff       	call   801019d0 <iunlockput>
  iunlockput(dp);
80104dfa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dfd:	89 04 24             	mov    %eax,(%esp)
80104e00:	e8 cb cb ff ff       	call   801019d0 <iunlockput>
  end_op();
80104e05:	e8 36 de ff ff       	call   80102c40 <end_op>
}
80104e0a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e12:	5b                   	pop    %ebx
80104e13:	5e                   	pop    %esi
80104e14:	5f                   	pop    %edi
80104e15:	5d                   	pop    %ebp
80104e16:	c3                   	ret    
80104e17:	90                   	nop
    dp->nlink--;
80104e18:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e1b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104e20:	89 04 24             	mov    %eax,(%esp)
80104e23:	e8 88 c8 ff ff       	call   801016b0 <iupdate>
80104e28:	e9 48 ff ff ff       	jmp    80104d75 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104e2d:	c7 04 24 f8 73 10 80 	movl   $0x801073f8,(%esp)
80104e34:	e8 27 b5 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104e39:	c7 04 24 0a 74 10 80 	movl   $0x8010740a,(%esp)
80104e40:	e8 1b b5 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104e45:	c7 04 24 e6 73 10 80 	movl   $0x801073e6,(%esp)
80104e4c:	e8 0f b5 ff ff       	call   80100360 <panic>
80104e51:	eb 0d                	jmp    80104e60 <sys_open>
80104e53:	90                   	nop
80104e54:	90                   	nop
80104e55:	90                   	nop
80104e56:	90                   	nop
80104e57:	90                   	nop
80104e58:	90                   	nop
80104e59:	90                   	nop
80104e5a:	90                   	nop
80104e5b:	90                   	nop
80104e5c:	90                   	nop
80104e5d:	90                   	nop
80104e5e:	90                   	nop
80104e5f:	90                   	nop

80104e60 <sys_open>:

int
sys_open(void)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	56                   	push   %esi
80104e65:	53                   	push   %ebx
80104e66:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e69:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e77:	e8 44 f8 ff ff       	call   801046c0 <argstr>
80104e7c:	85 c0                	test   %eax,%eax
80104e7e:	0f 88 d1 00 00 00    	js     80104f55 <sys_open+0xf5>
80104e84:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e92:	e8 99 f7 ff ff       	call   80104630 <argint>
80104e97:	85 c0                	test   %eax,%eax
80104e99:	0f 88 b6 00 00 00    	js     80104f55 <sys_open+0xf5>
    return -1;

  begin_op();
80104e9f:	e8 2c dd ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
80104ea4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104ea8:	0f 85 82 00 00 00    	jne    80104f30 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104eae:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104eb1:	89 04 24             	mov    %eax,(%esp)
80104eb4:	e8 07 d1 ff ff       	call   80101fc0 <namei>
80104eb9:	85 c0                	test   %eax,%eax
80104ebb:	89 c6                	mov    %eax,%esi
80104ebd:	0f 84 8d 00 00 00    	je     80104f50 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104ec3:	89 04 24             	mov    %eax,(%esp)
80104ec6:	e8 a5 c8 ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ecb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104ed0:	0f 84 92 00 00 00    	je     80104f68 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104ed6:	e8 95 be ff ff       	call   80100d70 <filealloc>
80104edb:	85 c0                	test   %eax,%eax
80104edd:	89 c3                	mov    %eax,%ebx
80104edf:	0f 84 93 00 00 00    	je     80104f78 <sys_open+0x118>
80104ee5:	e8 86 f8 ff ff       	call   80104770 <fdalloc>
80104eea:	85 c0                	test   %eax,%eax
80104eec:	89 c7                	mov    %eax,%edi
80104eee:	0f 88 94 00 00 00    	js     80104f88 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104ef4:	89 34 24             	mov    %esi,(%esp)
80104ef7:	e8 54 c9 ff ff       	call   80101850 <iunlock>
  end_op();
80104efc:	e8 3f dd ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
80104f01:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104f0a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104f0d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104f14:	89 c2                	mov    %eax,%edx
80104f16:	83 e2 01             	and    $0x1,%edx
80104f19:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f1c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104f1e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104f21:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f23:	0f 95 43 09          	setne  0x9(%ebx)
}
80104f27:	83 c4 2c             	add    $0x2c,%esp
80104f2a:	5b                   	pop    %ebx
80104f2b:	5e                   	pop    %esi
80104f2c:	5f                   	pop    %edi
80104f2d:	5d                   	pop    %ebp
80104f2e:	c3                   	ret    
80104f2f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f33:	31 c9                	xor    %ecx,%ecx
80104f35:	ba 02 00 00 00       	mov    $0x2,%edx
80104f3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f41:	e8 6a f8 ff ff       	call   801047b0 <create>
    if(ip == 0){
80104f46:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104f48:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104f4a:	75 8a                	jne    80104ed6 <sys_open+0x76>
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104f50:	e8 eb dc ff ff       	call   80102c40 <end_op>
}
80104f55:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f5d:	5b                   	pop    %ebx
80104f5e:	5e                   	pop    %esi
80104f5f:	5f                   	pop    %edi
80104f60:	5d                   	pop    %ebp
80104f61:	c3                   	ret    
80104f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104f6b:	85 c0                	test   %eax,%eax
80104f6d:	0f 84 63 ff ff ff    	je     80104ed6 <sys_open+0x76>
80104f73:	90                   	nop
80104f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104f78:	89 34 24             	mov    %esi,(%esp)
80104f7b:	e8 50 ca ff ff       	call   801019d0 <iunlockput>
80104f80:	eb ce                	jmp    80104f50 <sys_open+0xf0>
80104f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104f88:	89 1c 24             	mov    %ebx,(%esp)
80104f8b:	e8 a0 be ff ff       	call   80100e30 <fileclose>
80104f90:	eb e6                	jmp    80104f78 <sys_open+0x118>
80104f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fa0 <sys_mkdir>:

int
sys_mkdir(void)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104fa6:	e8 25 dc ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104fab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fae:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fb9:	e8 02 f7 ff ff       	call   801046c0 <argstr>
80104fbe:	85 c0                	test   %eax,%eax
80104fc0:	78 2e                	js     80104ff0 <sys_mkdir+0x50>
80104fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc5:	31 c9                	xor    %ecx,%ecx
80104fc7:	ba 01 00 00 00       	mov    $0x1,%edx
80104fcc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fd3:	e8 d8 f7 ff ff       	call   801047b0 <create>
80104fd8:	85 c0                	test   %eax,%eax
80104fda:	74 14                	je     80104ff0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fdc:	89 04 24             	mov    %eax,(%esp)
80104fdf:	e8 ec c9 ff ff       	call   801019d0 <iunlockput>
  end_op();
80104fe4:	e8 57 dc ff ff       	call   80102c40 <end_op>
  return 0;
80104fe9:	31 c0                	xor    %eax,%eax
}
80104feb:	c9                   	leave  
80104fec:	c3                   	ret    
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104ff0:	e8 4b dc ff ff       	call   80102c40 <end_op>
    return -1;
80104ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ffa:	c9                   	leave  
80104ffb:	c3                   	ret    
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105000 <sys_mknod>:

int
sys_mknod(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105006:	e8 c5 db ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010500b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010500e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105012:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105019:	e8 a2 f6 ff ff       	call   801046c0 <argstr>
8010501e:	85 c0                	test   %eax,%eax
80105020:	78 5e                	js     80105080 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105022:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105025:	89 44 24 04          	mov    %eax,0x4(%esp)
80105029:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105030:	e8 fb f5 ff ff       	call   80104630 <argint>
  if((argstr(0, &path)) < 0 ||
80105035:	85 c0                	test   %eax,%eax
80105037:	78 47                	js     80105080 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105039:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010503c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105040:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105047:	e8 e4 f5 ff ff       	call   80104630 <argint>
     argint(1, &major) < 0 ||
8010504c:	85 c0                	test   %eax,%eax
8010504e:	78 30                	js     80105080 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105050:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105054:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105059:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010505d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80105060:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105063:	e8 48 f7 ff ff       	call   801047b0 <create>
80105068:	85 c0                	test   %eax,%eax
8010506a:	74 14                	je     80105080 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010506c:	89 04 24             	mov    %eax,(%esp)
8010506f:	e8 5c c9 ff ff       	call   801019d0 <iunlockput>
  end_op();
80105074:	e8 c7 db ff ff       	call   80102c40 <end_op>
  return 0;
80105079:	31 c0                	xor    %eax,%eax
}
8010507b:	c9                   	leave  
8010507c:	c3                   	ret    
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105080:	e8 bb db ff ff       	call   80102c40 <end_op>
    return -1;
80105085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010508a:	c9                   	leave  
8010508b:	c3                   	ret    
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105090 <sys_chdir>:

int
sys_chdir(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
80105095:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105098:	e8 c3 e6 ff ff       	call   80103760 <myproc>
8010509d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010509f:	e8 2c db ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801050a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801050ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050b2:	e8 09 f6 ff ff       	call   801046c0 <argstr>
801050b7:	85 c0                	test   %eax,%eax
801050b9:	78 4a                	js     80105105 <sys_chdir+0x75>
801050bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050be:	89 04 24             	mov    %eax,(%esp)
801050c1:	e8 fa ce ff ff       	call   80101fc0 <namei>
801050c6:	85 c0                	test   %eax,%eax
801050c8:	89 c3                	mov    %eax,%ebx
801050ca:	74 39                	je     80105105 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
801050cc:	89 04 24             	mov    %eax,(%esp)
801050cf:	e8 9c c6 ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
801050d4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801050d9:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
801050dc:	75 22                	jne    80105100 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
801050de:	e8 6d c7 ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
801050e3:	8b 46 68             	mov    0x68(%esi),%eax
801050e6:	89 04 24             	mov    %eax,(%esp)
801050e9:	e8 a2 c7 ff ff       	call   80101890 <iput>
  end_op();
801050ee:	e8 4d db ff ff       	call   80102c40 <end_op>
  curproc->cwd = ip;
  return 0;
801050f3:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
801050f5:	89 5e 68             	mov    %ebx,0x68(%esi)
}
801050f8:	83 c4 20             	add    $0x20,%esp
801050fb:	5b                   	pop    %ebx
801050fc:	5e                   	pop    %esi
801050fd:	5d                   	pop    %ebp
801050fe:	c3                   	ret    
801050ff:	90                   	nop
    iunlockput(ip);
80105100:	e8 cb c8 ff ff       	call   801019d0 <iunlockput>
    end_op();
80105105:	e8 36 db ff ff       	call   80102c40 <end_op>
}
8010510a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010510d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105112:	5b                   	pop    %ebx
80105113:	5e                   	pop    %esi
80105114:	5d                   	pop    %ebp
80105115:	c3                   	ret    
80105116:	8d 76 00             	lea    0x0(%esi),%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <sys_exec>:

int
sys_exec(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
80105125:	53                   	push   %ebx
80105126:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010512c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105132:	89 44 24 04          	mov    %eax,0x4(%esp)
80105136:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010513d:	e8 7e f5 ff ff       	call   801046c0 <argstr>
80105142:	85 c0                	test   %eax,%eax
80105144:	0f 88 84 00 00 00    	js     801051ce <sys_exec+0xae>
8010514a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105150:	89 44 24 04          	mov    %eax,0x4(%esp)
80105154:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010515b:	e8 d0 f4 ff ff       	call   80104630 <argint>
80105160:	85 c0                	test   %eax,%eax
80105162:	78 6a                	js     801051ce <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105164:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010516a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010516c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105173:	00 
80105174:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010517a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105181:	00 
80105182:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105188:	89 04 24             	mov    %eax,(%esp)
8010518b:	e8 b0 f1 ff ff       	call   80104340 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105190:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105196:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010519a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010519d:	89 04 24             	mov    %eax,(%esp)
801051a0:	e8 eb f3 ff ff       	call   80104590 <fetchint>
801051a5:	85 c0                	test   %eax,%eax
801051a7:	78 25                	js     801051ce <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801051a9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801051af:	85 c0                	test   %eax,%eax
801051b1:	74 2d                	je     801051e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801051b3:	89 74 24 04          	mov    %esi,0x4(%esp)
801051b7:	89 04 24             	mov    %eax,(%esp)
801051ba:	e8 11 f4 ff ff       	call   801045d0 <fetchstr>
801051bf:	85 c0                	test   %eax,%eax
801051c1:	78 0b                	js     801051ce <sys_exec+0xae>
  for(i=0;; i++){
801051c3:	83 c3 01             	add    $0x1,%ebx
801051c6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801051c9:	83 fb 20             	cmp    $0x20,%ebx
801051cc:	75 c2                	jne    80105190 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
801051ce:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
801051d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051d9:	5b                   	pop    %ebx
801051da:	5e                   	pop    %esi
801051db:	5f                   	pop    %edi
801051dc:	5d                   	pop    %ebp
801051dd:	c3                   	ret    
801051de:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
801051e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801051e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ea:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
801051f0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801051f7:	00 00 00 00 
  return exec(path, argv);
801051fb:	89 04 24             	mov    %eax,(%esp)
801051fe:	e8 9d b7 ff ff       	call   801009a0 <exec>
}
80105203:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5f                   	pop    %edi
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax

80105210 <sys_pipe>:

int
sys_pipe(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	53                   	push   %ebx
80105214:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105217:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010521a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105221:	00 
80105222:	89 44 24 04          	mov    %eax,0x4(%esp)
80105226:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010522d:	e8 2e f4 ff ff       	call   80104660 <argptr>
80105232:	85 c0                	test   %eax,%eax
80105234:	78 6d                	js     801052a3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105236:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105239:	89 44 24 04          	mov    %eax,0x4(%esp)
8010523d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105240:	89 04 24             	mov    %eax,(%esp)
80105243:	e8 e8 df ff ff       	call   80103230 <pipealloc>
80105248:	85 c0                	test   %eax,%eax
8010524a:	78 57                	js     801052a3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010524c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010524f:	e8 1c f5 ff ff       	call   80104770 <fdalloc>
80105254:	85 c0                	test   %eax,%eax
80105256:	89 c3                	mov    %eax,%ebx
80105258:	78 33                	js     8010528d <sys_pipe+0x7d>
8010525a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010525d:	e8 0e f5 ff ff       	call   80104770 <fdalloc>
80105262:	85 c0                	test   %eax,%eax
80105264:	78 1a                	js     80105280 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105266:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105269:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010526b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010526e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105271:	83 c4 24             	add    $0x24,%esp
  return 0;
80105274:	31 c0                	xor    %eax,%eax
}
80105276:	5b                   	pop    %ebx
80105277:	5d                   	pop    %ebp
80105278:	c3                   	ret    
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105280:	e8 db e4 ff ff       	call   80103760 <myproc>
80105285:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010528c:	00 
    fileclose(rf);
8010528d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105290:	89 04 24             	mov    %eax,(%esp)
80105293:	e8 98 bb ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
80105298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010529b:	89 04 24             	mov    %eax,(%esp)
8010529e:	e8 8d bb ff ff       	call   80100e30 <fileclose>
}
801052a3:	83 c4 24             	add    $0x24,%esp
    return -1;
801052a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ab:	5b                   	pop    %ebx
801052ac:	5d                   	pop    %ebp
801052ad:	c3                   	ret    
801052ae:	66 90                	xchg   %ax,%ax

801052b0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801052b3:	5d                   	pop    %ebp
  return fork();
801052b4:	e9 57 e6 ff ff       	jmp    80103910 <fork>
801052b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_exit>:

int
sys_exit(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801052c6:	e8 95 e8 ff ff       	call   80103b60 <exit>
  return 0;  // not reached
}
801052cb:	31 c0                	xor    %eax,%eax
801052cd:	c9                   	leave  
801052ce:	c3                   	ret    
801052cf:	90                   	nop

801052d0 <sys_wait>:

int
sys_wait(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801052d3:	5d                   	pop    %ebp
  return wait();
801052d4:	e9 97 ea ff ff       	jmp    80103d70 <wait>
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052e0 <sys_kill>:

int
sys_kill(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801052e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052f4:	e8 37 f3 ff ff       	call   80104630 <argint>
801052f9:	85 c0                	test   %eax,%eax
801052fb:	78 13                	js     80105310 <sys_kill+0x30>
    return -1;
  return kill(pid);
801052fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105300:	89 04 24             	mov    %eax,(%esp)
80105303:	e8 a8 eb ff ff       	call   80103eb0 <kill>
}
80105308:	c9                   	leave  
80105309:	c3                   	ret    
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105315:	c9                   	leave  
80105316:	c3                   	ret    
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <sys_getpid>:

int
sys_getpid(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105326:	e8 35 e4 ff ff       	call   80103760 <myproc>
8010532b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010532e:	c9                   	leave  
8010532f:	c3                   	ret    

80105330 <sys_sbrk>:

int
sys_sbrk(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	53                   	push   %ebx
80105334:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105337:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010533e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105345:	e8 e6 f2 ff ff       	call   80104630 <argint>
8010534a:	85 c0                	test   %eax,%eax
8010534c:	78 22                	js     80105370 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010534e:	e8 0d e4 ff ff       	call   80103760 <myproc>
  if(growproc(n) < 0)
80105353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105356:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105358:	89 14 24             	mov    %edx,(%esp)
8010535b:	e8 40 e5 ff ff       	call   801038a0 <growproc>
80105360:	85 c0                	test   %eax,%eax
80105362:	78 0c                	js     80105370 <sys_sbrk+0x40>
    return -1;
  return addr;
80105364:	89 d8                	mov    %ebx,%eax
}
80105366:	83 c4 24             	add    $0x24,%esp
80105369:	5b                   	pop    %ebx
8010536a:	5d                   	pop    %ebp
8010536b:	c3                   	ret    
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105375:	eb ef                	jmp    80105366 <sys_sbrk+0x36>
80105377:	89 f6                	mov    %esi,%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <sys_sleep>:

int
sys_sleep(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	53                   	push   %ebx
80105384:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105387:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010538a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010538e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105395:	e8 96 f2 ff ff       	call   80104630 <argint>
8010539a:	85 c0                	test   %eax,%eax
8010539c:	78 7e                	js     8010541c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010539e:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801053a5:	e8 56 ee ff ff       	call   80104200 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801053aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801053ad:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
801053b3:	85 d2                	test   %edx,%edx
801053b5:	75 29                	jne    801053e0 <sys_sleep+0x60>
801053b7:	eb 4f                	jmp    80105408 <sys_sleep+0x88>
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801053c0:	c7 44 24 04 60 4c 11 	movl   $0x80114c60,0x4(%esp)
801053c7:	80 
801053c8:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
801053cf:	e8 ec e8 ff ff       	call   80103cc0 <sleep>
  while(ticks - ticks0 < n){
801053d4:	a1 a0 54 11 80       	mov    0x801154a0,%eax
801053d9:	29 d8                	sub    %ebx,%eax
801053db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801053de:	73 28                	jae    80105408 <sys_sleep+0x88>
    if(myproc()->killed){
801053e0:	e8 7b e3 ff ff       	call   80103760 <myproc>
801053e5:	8b 40 24             	mov    0x24(%eax),%eax
801053e8:	85 c0                	test   %eax,%eax
801053ea:	74 d4                	je     801053c0 <sys_sleep+0x40>
      release(&tickslock);
801053ec:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
801053f3:	e8 f8 ee ff ff       	call   801042f0 <release>
      return -1;
801053f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801053fd:	83 c4 24             	add    $0x24,%esp
80105400:	5b                   	pop    %ebx
80105401:	5d                   	pop    %ebp
80105402:	c3                   	ret    
80105403:	90                   	nop
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105408:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010540f:	e8 dc ee ff ff       	call   801042f0 <release>
}
80105414:	83 c4 24             	add    $0x24,%esp
  return 0;
80105417:	31 c0                	xor    %eax,%eax
}
80105419:	5b                   	pop    %ebx
8010541a:	5d                   	pop    %ebp
8010541b:	c3                   	ret    
    return -1;
8010541c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105421:	eb da                	jmp    801053fd <sys_sleep+0x7d>
80105423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105430 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	53                   	push   %ebx
80105434:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105437:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010543e:	e8 bd ed ff ff       	call   80104200 <acquire>
  xticks = ticks;
80105443:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105449:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105450:	e8 9b ee ff ff       	call   801042f0 <release>
  return xticks;
}
80105455:	83 c4 14             	add    $0x14,%esp
80105458:	89 d8                	mov    %ebx,%eax
8010545a:	5b                   	pop    %ebx
8010545b:	5d                   	pop    %ebp
8010545c:	c3                   	ret    

8010545d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010545d:	1e                   	push   %ds
  pushl %es
8010545e:	06                   	push   %es
  pushl %fs
8010545f:	0f a0                	push   %fs
  pushl %gs
80105461:	0f a8                	push   %gs
  pushal
80105463:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105464:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105468:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010546a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010546c:	54                   	push   %esp
  call trap
8010546d:	e8 de 00 00 00       	call   80105550 <trap>
  addl $4, %esp
80105472:	83 c4 04             	add    $0x4,%esp

80105475 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105475:	61                   	popa   
  popl %gs
80105476:	0f a9                	pop    %gs
  popl %fs
80105478:	0f a1                	pop    %fs
  popl %es
8010547a:	07                   	pop    %es
  popl %ds
8010547b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010547c:	83 c4 08             	add    $0x8,%esp
  iret
8010547f:	cf                   	iret   

80105480 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105480:	31 c0                	xor    %eax,%eax
80105482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105488:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010548f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105494:	66 89 0c c5 a2 4c 11 	mov    %cx,-0x7feeb35e(,%eax,8)
8010549b:	80 
8010549c:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
801054a3:	00 
801054a4:	c6 04 c5 a5 4c 11 80 	movb   $0x8e,-0x7feeb35b(,%eax,8)
801054ab:	8e 
801054ac:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
801054b3:	80 
801054b4:	c1 ea 10             	shr    $0x10,%edx
801054b7:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
801054be:	80 
  for(i = 0; i < 256; i++)
801054bf:	83 c0 01             	add    $0x1,%eax
801054c2:	3d 00 01 00 00       	cmp    $0x100,%eax
801054c7:	75 bf                	jne    80105488 <tvinit+0x8>
{
801054c9:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054ca:	ba 08 00 00 00       	mov    $0x8,%edx
{
801054cf:	89 e5                	mov    %esp,%ebp
801054d1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054d4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801054d9:	c7 44 24 04 19 74 10 	movl   $0x80107419,0x4(%esp)
801054e0:	80 
801054e1:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054e8:	66 89 15 a2 4e 11 80 	mov    %dx,0x80114ea2
801054ef:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801054f5:	c1 e8 10             	shr    $0x10,%eax
801054f8:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
801054ff:	c6 05 a5 4e 11 80 ef 	movb   $0xef,0x80114ea5
80105506:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
8010550c:	e8 ff eb ff ff       	call   80104110 <initlock>
}
80105511:	c9                   	leave  
80105512:	c3                   	ret    
80105513:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <idtinit>:

void
idtinit(void)
{
80105520:	55                   	push   %ebp
  pd[0] = size-1;
80105521:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105526:	89 e5                	mov    %esp,%ebp
80105528:	83 ec 10             	sub    $0x10,%esp
8010552b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010552f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105534:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105538:	c1 e8 10             	shr    $0x10,%eax
8010553b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010553f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105542:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105545:	c9                   	leave  
80105546:	c3                   	ret    
80105547:	89 f6                	mov    %esi,%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
80105555:	53                   	push   %ebx
80105556:	83 ec 3c             	sub    $0x3c,%esp
80105559:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010555c:	8b 43 30             	mov    0x30(%ebx),%eax
8010555f:	83 f8 40             	cmp    $0x40,%eax
80105562:	0f 84 a0 01 00 00    	je     80105708 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105568:	83 e8 20             	sub    $0x20,%eax
8010556b:	83 f8 1f             	cmp    $0x1f,%eax
8010556e:	77 08                	ja     80105578 <trap+0x28>
80105570:	ff 24 85 c0 74 10 80 	jmp    *-0x7fef8b40(,%eax,4)
80105577:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105578:	e8 e3 e1 ff ff       	call   80103760 <myproc>
8010557d:	85 c0                	test   %eax,%eax
8010557f:	90                   	nop
80105580:	0f 84 fa 01 00 00    	je     80105780 <trap+0x230>
80105586:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010558a:	0f 84 f0 01 00 00    	je     80105780 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105590:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105593:	8b 53 38             	mov    0x38(%ebx),%edx
80105596:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105599:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010559c:	e8 9f e1 ff ff       	call   80103740 <cpuid>
801055a1:	8b 73 30             	mov    0x30(%ebx),%esi
801055a4:	89 c7                	mov    %eax,%edi
801055a6:	8b 43 34             	mov    0x34(%ebx),%eax
801055a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801055ac:	e8 af e1 ff ff       	call   80103760 <myproc>
801055b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801055b4:	e8 a7 e1 ff ff       	call   80103760 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801055bc:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801055c0:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055c3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801055c6:	89 7c 24 14          	mov    %edi,0x14(%esp)
801055ca:	89 54 24 18          	mov    %edx,0x18(%esp)
801055ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
801055d1:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055d4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
801055d8:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055dc:	89 54 24 10          	mov    %edx,0x10(%esp)
801055e0:	8b 40 10             	mov    0x10(%eax),%eax
801055e3:	c7 04 24 7c 74 10 80 	movl   $0x8010747c,(%esp)
801055ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ee:	e8 5d b0 ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801055f3:	e8 68 e1 ff ff       	call   80103760 <myproc>
801055f8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801055ff:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105600:	e8 5b e1 ff ff       	call   80103760 <myproc>
80105605:	85 c0                	test   %eax,%eax
80105607:	74 0c                	je     80105615 <trap+0xc5>
80105609:	e8 52 e1 ff ff       	call   80103760 <myproc>
8010560e:	8b 50 24             	mov    0x24(%eax),%edx
80105611:	85 d2                	test   %edx,%edx
80105613:	75 4b                	jne    80105660 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105615:	e8 46 e1 ff ff       	call   80103760 <myproc>
8010561a:	85 c0                	test   %eax,%eax
8010561c:	74 0d                	je     8010562b <trap+0xdb>
8010561e:	66 90                	xchg   %ax,%ax
80105620:	e8 3b e1 ff ff       	call   80103760 <myproc>
80105625:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105629:	74 4d                	je     80105678 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010562b:	e8 30 e1 ff ff       	call   80103760 <myproc>
80105630:	85 c0                	test   %eax,%eax
80105632:	74 1d                	je     80105651 <trap+0x101>
80105634:	e8 27 e1 ff ff       	call   80103760 <myproc>
80105639:	8b 40 24             	mov    0x24(%eax),%eax
8010563c:	85 c0                	test   %eax,%eax
8010563e:	74 11                	je     80105651 <trap+0x101>
80105640:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105644:	83 e0 03             	and    $0x3,%eax
80105647:	66 83 f8 03          	cmp    $0x3,%ax
8010564b:	0f 84 e8 00 00 00    	je     80105739 <trap+0x1e9>
    exit();
}
80105651:	83 c4 3c             	add    $0x3c,%esp
80105654:	5b                   	pop    %ebx
80105655:	5e                   	pop    %esi
80105656:	5f                   	pop    %edi
80105657:	5d                   	pop    %ebp
80105658:	c3                   	ret    
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105660:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105664:	83 e0 03             	and    $0x3,%eax
80105667:	66 83 f8 03          	cmp    $0x3,%ax
8010566b:	75 a8                	jne    80105615 <trap+0xc5>
    exit();
8010566d:	e8 ee e4 ff ff       	call   80103b60 <exit>
80105672:	eb a1                	jmp    80105615 <trap+0xc5>
80105674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105678:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105680:	75 a9                	jne    8010562b <trap+0xdb>
    yield();
80105682:	e8 f9 e5 ff ff       	call   80103c80 <yield>
80105687:	eb a2                	jmp    8010562b <trap+0xdb>
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105690:	e8 ab e0 ff ff       	call   80103740 <cpuid>
80105695:	85 c0                	test   %eax,%eax
80105697:	0f 84 b3 00 00 00    	je     80105750 <trap+0x200>
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
801056a0:	e8 9b d1 ff ff       	call   80102840 <lapiceoi>
    break;
801056a5:	e9 56 ff ff ff       	jmp    80105600 <trap+0xb0>
801056aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
801056b0:	e8 db cf ff ff       	call   80102690 <kbdintr>
    lapiceoi();
801056b5:	e8 86 d1 ff ff       	call   80102840 <lapiceoi>
    break;
801056ba:	e9 41 ff ff ff       	jmp    80105600 <trap+0xb0>
801056bf:	90                   	nop
    uartintr();
801056c0:	e8 1b 02 00 00       	call   801058e0 <uartintr>
    lapiceoi();
801056c5:	e8 76 d1 ff ff       	call   80102840 <lapiceoi>
    break;
801056ca:	e9 31 ff ff ff       	jmp    80105600 <trap+0xb0>
801056cf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801056d0:	8b 7b 38             	mov    0x38(%ebx),%edi
801056d3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801056d7:	e8 64 e0 ff ff       	call   80103740 <cpuid>
801056dc:	c7 04 24 24 74 10 80 	movl   $0x80107424,(%esp)
801056e3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801056e7:	89 74 24 08          	mov    %esi,0x8(%esp)
801056eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ef:	e8 5c af ff ff       	call   80100650 <cprintf>
    lapiceoi();
801056f4:	e8 47 d1 ff ff       	call   80102840 <lapiceoi>
    break;
801056f9:	e9 02 ff ff ff       	jmp    80105600 <trap+0xb0>
801056fe:	66 90                	xchg   %ax,%ax
    ideintr();
80105700:	e8 3b ca ff ff       	call   80102140 <ideintr>
80105705:	eb 96                	jmp    8010569d <trap+0x14d>
80105707:	90                   	nop
80105708:	90                   	nop
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105710:	e8 4b e0 ff ff       	call   80103760 <myproc>
80105715:	8b 70 24             	mov    0x24(%eax),%esi
80105718:	85 f6                	test   %esi,%esi
8010571a:	75 2c                	jne    80105748 <trap+0x1f8>
    myproc()->tf = tf;
8010571c:	e8 3f e0 ff ff       	call   80103760 <myproc>
80105721:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105724:	e8 d7 ef ff ff       	call   80104700 <syscall>
    if(myproc()->killed)
80105729:	e8 32 e0 ff ff       	call   80103760 <myproc>
8010572e:	8b 48 24             	mov    0x24(%eax),%ecx
80105731:	85 c9                	test   %ecx,%ecx
80105733:	0f 84 18 ff ff ff    	je     80105651 <trap+0x101>
}
80105739:	83 c4 3c             	add    $0x3c,%esp
8010573c:	5b                   	pop    %ebx
8010573d:	5e                   	pop    %esi
8010573e:	5f                   	pop    %edi
8010573f:	5d                   	pop    %ebp
      exit();
80105740:	e9 1b e4 ff ff       	jmp    80103b60 <exit>
80105745:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105748:	e8 13 e4 ff ff       	call   80103b60 <exit>
8010574d:	eb cd                	jmp    8010571c <trap+0x1cc>
8010574f:	90                   	nop
      acquire(&tickslock);
80105750:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105757:	e8 a4 ea ff ff       	call   80104200 <acquire>
      wakeup(&ticks);
8010575c:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105763:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
8010576a:	e8 e1 e6 ff ff       	call   80103e50 <wakeup>
      release(&tickslock);
8010576f:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105776:	e8 75 eb ff ff       	call   801042f0 <release>
8010577b:	e9 1d ff ff ff       	jmp    8010569d <trap+0x14d>
80105780:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105783:	8b 73 38             	mov    0x38(%ebx),%esi
80105786:	e8 b5 df ff ff       	call   80103740 <cpuid>
8010578b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010578f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105793:	89 44 24 08          	mov    %eax,0x8(%esp)
80105797:	8b 43 30             	mov    0x30(%ebx),%eax
8010579a:	c7 04 24 48 74 10 80 	movl   $0x80107448,(%esp)
801057a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a5:	e8 a6 ae ff ff       	call   80100650 <cprintf>
      panic("trap");
801057aa:	c7 04 24 1e 74 10 80 	movl   $0x8010741e,(%esp)
801057b1:	e8 aa ab ff ff       	call   80100360 <panic>
801057b6:	66 90                	xchg   %ax,%ax
801057b8:	66 90                	xchg   %ax,%ax
801057ba:	66 90                	xchg   %ax,%ax
801057bc:	66 90                	xchg   %ax,%ax
801057be:	66 90                	xchg   %ax,%ax

801057c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801057c0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
801057c5:	55                   	push   %ebp
801057c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801057c8:	85 c0                	test   %eax,%eax
801057ca:	74 14                	je     801057e0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801057cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801057d1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801057d2:	a8 01                	test   $0x1,%al
801057d4:	74 0a                	je     801057e0 <uartgetc+0x20>
801057d6:	b2 f8                	mov    $0xf8,%dl
801057d8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801057d9:	0f b6 c0             	movzbl %al,%eax
}
801057dc:	5d                   	pop    %ebp
801057dd:	c3                   	ret    
801057de:	66 90                	xchg   %ax,%ax
    return -1;
801057e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057e5:	5d                   	pop    %ebp
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <uartputc>:
  if(!uart)
801057f0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801057f5:	85 c0                	test   %eax,%eax
801057f7:	74 3f                	je     80105838 <uartputc+0x48>
{
801057f9:	55                   	push   %ebp
801057fa:	89 e5                	mov    %esp,%ebp
801057fc:	56                   	push   %esi
801057fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105802:	53                   	push   %ebx
  if(!uart)
80105803:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105808:	83 ec 10             	sub    $0x10,%esp
8010580b:	eb 14                	jmp    80105821 <uartputc+0x31>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105810:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105817:	e8 44 d0 ff ff       	call   80102860 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010581c:	83 eb 01             	sub    $0x1,%ebx
8010581f:	74 07                	je     80105828 <uartputc+0x38>
80105821:	89 f2                	mov    %esi,%edx
80105823:	ec                   	in     (%dx),%al
80105824:	a8 20                	test   $0x20,%al
80105826:	74 e8                	je     80105810 <uartputc+0x20>
  outb(COM1+0, c);
80105828:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010582c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105831:	ee                   	out    %al,(%dx)
}
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	5b                   	pop    %ebx
80105836:	5e                   	pop    %esi
80105837:	5d                   	pop    %ebp
80105838:	f3 c3                	repz ret 
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105840 <uartinit>:
{
80105840:	55                   	push   %ebp
80105841:	31 c9                	xor    %ecx,%ecx
80105843:	89 e5                	mov    %esp,%ebp
80105845:	89 c8                	mov    %ecx,%eax
80105847:	57                   	push   %edi
80105848:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010584d:	56                   	push   %esi
8010584e:	89 fa                	mov    %edi,%edx
80105850:	53                   	push   %ebx
80105851:	83 ec 1c             	sub    $0x1c,%esp
80105854:	ee                   	out    %al,(%dx)
80105855:	be fb 03 00 00       	mov    $0x3fb,%esi
8010585a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010585f:	89 f2                	mov    %esi,%edx
80105861:	ee                   	out    %al,(%dx)
80105862:	b8 0c 00 00 00       	mov    $0xc,%eax
80105867:	b2 f8                	mov    $0xf8,%dl
80105869:	ee                   	out    %al,(%dx)
8010586a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010586f:	89 c8                	mov    %ecx,%eax
80105871:	89 da                	mov    %ebx,%edx
80105873:	ee                   	out    %al,(%dx)
80105874:	b8 03 00 00 00       	mov    $0x3,%eax
80105879:	89 f2                	mov    %esi,%edx
8010587b:	ee                   	out    %al,(%dx)
8010587c:	b2 fc                	mov    $0xfc,%dl
8010587e:	89 c8                	mov    %ecx,%eax
80105880:	ee                   	out    %al,(%dx)
80105881:	b8 01 00 00 00       	mov    $0x1,%eax
80105886:	89 da                	mov    %ebx,%edx
80105888:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105889:	b2 fd                	mov    $0xfd,%dl
8010588b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010588c:	3c ff                	cmp    $0xff,%al
8010588e:	74 42                	je     801058d2 <uartinit+0x92>
  uart = 1;
80105890:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105897:	00 00 00 
8010589a:	89 fa                	mov    %edi,%edx
8010589c:	ec                   	in     (%dx),%al
8010589d:	b2 f8                	mov    $0xf8,%dl
8010589f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801058a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058a7:	00 
  for(p="xv6...\n"; *p; p++)
801058a8:	bb 40 75 10 80       	mov    $0x80107540,%ebx
  ioapicenable(IRQ_COM1, 0);
801058ad:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801058b4:	e8 b7 ca ff ff       	call   80102370 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801058b9:	b8 78 00 00 00       	mov    $0x78,%eax
801058be:	66 90                	xchg   %ax,%ax
    uartputc(*p);
801058c0:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
801058c3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
801058c6:	e8 25 ff ff ff       	call   801057f0 <uartputc>
  for(p="xv6...\n"; *p; p++)
801058cb:	0f be 03             	movsbl (%ebx),%eax
801058ce:	84 c0                	test   %al,%al
801058d0:	75 ee                	jne    801058c0 <uartinit+0x80>
}
801058d2:	83 c4 1c             	add    $0x1c,%esp
801058d5:	5b                   	pop    %ebx
801058d6:	5e                   	pop    %esi
801058d7:	5f                   	pop    %edi
801058d8:	5d                   	pop    %ebp
801058d9:	c3                   	ret    
801058da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058e0 <uartintr>:

void
uartintr(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801058e6:	c7 04 24 c0 57 10 80 	movl   $0x801057c0,(%esp)
801058ed:	e8 be ae ff ff       	call   801007b0 <consoleintr>
}
801058f2:	c9                   	leave  
801058f3:	c3                   	ret    

801058f4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801058f4:	6a 00                	push   $0x0
  pushl $0
801058f6:	6a 00                	push   $0x0
  jmp alltraps
801058f8:	e9 60 fb ff ff       	jmp    8010545d <alltraps>

801058fd <vector1>:
.globl vector1
vector1:
  pushl $0
801058fd:	6a 00                	push   $0x0
  pushl $1
801058ff:	6a 01                	push   $0x1
  jmp alltraps
80105901:	e9 57 fb ff ff       	jmp    8010545d <alltraps>

80105906 <vector2>:
.globl vector2
vector2:
  pushl $0
80105906:	6a 00                	push   $0x0
  pushl $2
80105908:	6a 02                	push   $0x2
  jmp alltraps
8010590a:	e9 4e fb ff ff       	jmp    8010545d <alltraps>

8010590f <vector3>:
.globl vector3
vector3:
  pushl $0
8010590f:	6a 00                	push   $0x0
  pushl $3
80105911:	6a 03                	push   $0x3
  jmp alltraps
80105913:	e9 45 fb ff ff       	jmp    8010545d <alltraps>

80105918 <vector4>:
.globl vector4
vector4:
  pushl $0
80105918:	6a 00                	push   $0x0
  pushl $4
8010591a:	6a 04                	push   $0x4
  jmp alltraps
8010591c:	e9 3c fb ff ff       	jmp    8010545d <alltraps>

80105921 <vector5>:
.globl vector5
vector5:
  pushl $0
80105921:	6a 00                	push   $0x0
  pushl $5
80105923:	6a 05                	push   $0x5
  jmp alltraps
80105925:	e9 33 fb ff ff       	jmp    8010545d <alltraps>

8010592a <vector6>:
.globl vector6
vector6:
  pushl $0
8010592a:	6a 00                	push   $0x0
  pushl $6
8010592c:	6a 06                	push   $0x6
  jmp alltraps
8010592e:	e9 2a fb ff ff       	jmp    8010545d <alltraps>

80105933 <vector7>:
.globl vector7
vector7:
  pushl $0
80105933:	6a 00                	push   $0x0
  pushl $7
80105935:	6a 07                	push   $0x7
  jmp alltraps
80105937:	e9 21 fb ff ff       	jmp    8010545d <alltraps>

8010593c <vector8>:
.globl vector8
vector8:
  pushl $8
8010593c:	6a 08                	push   $0x8
  jmp alltraps
8010593e:	e9 1a fb ff ff       	jmp    8010545d <alltraps>

80105943 <vector9>:
.globl vector9
vector9:
  pushl $0
80105943:	6a 00                	push   $0x0
  pushl $9
80105945:	6a 09                	push   $0x9
  jmp alltraps
80105947:	e9 11 fb ff ff       	jmp    8010545d <alltraps>

8010594c <vector10>:
.globl vector10
vector10:
  pushl $10
8010594c:	6a 0a                	push   $0xa
  jmp alltraps
8010594e:	e9 0a fb ff ff       	jmp    8010545d <alltraps>

80105953 <vector11>:
.globl vector11
vector11:
  pushl $11
80105953:	6a 0b                	push   $0xb
  jmp alltraps
80105955:	e9 03 fb ff ff       	jmp    8010545d <alltraps>

8010595a <vector12>:
.globl vector12
vector12:
  pushl $12
8010595a:	6a 0c                	push   $0xc
  jmp alltraps
8010595c:	e9 fc fa ff ff       	jmp    8010545d <alltraps>

80105961 <vector13>:
.globl vector13
vector13:
  pushl $13
80105961:	6a 0d                	push   $0xd
  jmp alltraps
80105963:	e9 f5 fa ff ff       	jmp    8010545d <alltraps>

80105968 <vector14>:
.globl vector14
vector14:
  pushl $14
80105968:	6a 0e                	push   $0xe
  jmp alltraps
8010596a:	e9 ee fa ff ff       	jmp    8010545d <alltraps>

8010596f <vector15>:
.globl vector15
vector15:
  pushl $0
8010596f:	6a 00                	push   $0x0
  pushl $15
80105971:	6a 0f                	push   $0xf
  jmp alltraps
80105973:	e9 e5 fa ff ff       	jmp    8010545d <alltraps>

80105978 <vector16>:
.globl vector16
vector16:
  pushl $0
80105978:	6a 00                	push   $0x0
  pushl $16
8010597a:	6a 10                	push   $0x10
  jmp alltraps
8010597c:	e9 dc fa ff ff       	jmp    8010545d <alltraps>

80105981 <vector17>:
.globl vector17
vector17:
  pushl $17
80105981:	6a 11                	push   $0x11
  jmp alltraps
80105983:	e9 d5 fa ff ff       	jmp    8010545d <alltraps>

80105988 <vector18>:
.globl vector18
vector18:
  pushl $0
80105988:	6a 00                	push   $0x0
  pushl $18
8010598a:	6a 12                	push   $0x12
  jmp alltraps
8010598c:	e9 cc fa ff ff       	jmp    8010545d <alltraps>

80105991 <vector19>:
.globl vector19
vector19:
  pushl $0
80105991:	6a 00                	push   $0x0
  pushl $19
80105993:	6a 13                	push   $0x13
  jmp alltraps
80105995:	e9 c3 fa ff ff       	jmp    8010545d <alltraps>

8010599a <vector20>:
.globl vector20
vector20:
  pushl $0
8010599a:	6a 00                	push   $0x0
  pushl $20
8010599c:	6a 14                	push   $0x14
  jmp alltraps
8010599e:	e9 ba fa ff ff       	jmp    8010545d <alltraps>

801059a3 <vector21>:
.globl vector21
vector21:
  pushl $0
801059a3:	6a 00                	push   $0x0
  pushl $21
801059a5:	6a 15                	push   $0x15
  jmp alltraps
801059a7:	e9 b1 fa ff ff       	jmp    8010545d <alltraps>

801059ac <vector22>:
.globl vector22
vector22:
  pushl $0
801059ac:	6a 00                	push   $0x0
  pushl $22
801059ae:	6a 16                	push   $0x16
  jmp alltraps
801059b0:	e9 a8 fa ff ff       	jmp    8010545d <alltraps>

801059b5 <vector23>:
.globl vector23
vector23:
  pushl $0
801059b5:	6a 00                	push   $0x0
  pushl $23
801059b7:	6a 17                	push   $0x17
  jmp alltraps
801059b9:	e9 9f fa ff ff       	jmp    8010545d <alltraps>

801059be <vector24>:
.globl vector24
vector24:
  pushl $0
801059be:	6a 00                	push   $0x0
  pushl $24
801059c0:	6a 18                	push   $0x18
  jmp alltraps
801059c2:	e9 96 fa ff ff       	jmp    8010545d <alltraps>

801059c7 <vector25>:
.globl vector25
vector25:
  pushl $0
801059c7:	6a 00                	push   $0x0
  pushl $25
801059c9:	6a 19                	push   $0x19
  jmp alltraps
801059cb:	e9 8d fa ff ff       	jmp    8010545d <alltraps>

801059d0 <vector26>:
.globl vector26
vector26:
  pushl $0
801059d0:	6a 00                	push   $0x0
  pushl $26
801059d2:	6a 1a                	push   $0x1a
  jmp alltraps
801059d4:	e9 84 fa ff ff       	jmp    8010545d <alltraps>

801059d9 <vector27>:
.globl vector27
vector27:
  pushl $0
801059d9:	6a 00                	push   $0x0
  pushl $27
801059db:	6a 1b                	push   $0x1b
  jmp alltraps
801059dd:	e9 7b fa ff ff       	jmp    8010545d <alltraps>

801059e2 <vector28>:
.globl vector28
vector28:
  pushl $0
801059e2:	6a 00                	push   $0x0
  pushl $28
801059e4:	6a 1c                	push   $0x1c
  jmp alltraps
801059e6:	e9 72 fa ff ff       	jmp    8010545d <alltraps>

801059eb <vector29>:
.globl vector29
vector29:
  pushl $0
801059eb:	6a 00                	push   $0x0
  pushl $29
801059ed:	6a 1d                	push   $0x1d
  jmp alltraps
801059ef:	e9 69 fa ff ff       	jmp    8010545d <alltraps>

801059f4 <vector30>:
.globl vector30
vector30:
  pushl $0
801059f4:	6a 00                	push   $0x0
  pushl $30
801059f6:	6a 1e                	push   $0x1e
  jmp alltraps
801059f8:	e9 60 fa ff ff       	jmp    8010545d <alltraps>

801059fd <vector31>:
.globl vector31
vector31:
  pushl $0
801059fd:	6a 00                	push   $0x0
  pushl $31
801059ff:	6a 1f                	push   $0x1f
  jmp alltraps
80105a01:	e9 57 fa ff ff       	jmp    8010545d <alltraps>

80105a06 <vector32>:
.globl vector32
vector32:
  pushl $0
80105a06:	6a 00                	push   $0x0
  pushl $32
80105a08:	6a 20                	push   $0x20
  jmp alltraps
80105a0a:	e9 4e fa ff ff       	jmp    8010545d <alltraps>

80105a0f <vector33>:
.globl vector33
vector33:
  pushl $0
80105a0f:	6a 00                	push   $0x0
  pushl $33
80105a11:	6a 21                	push   $0x21
  jmp alltraps
80105a13:	e9 45 fa ff ff       	jmp    8010545d <alltraps>

80105a18 <vector34>:
.globl vector34
vector34:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $34
80105a1a:	6a 22                	push   $0x22
  jmp alltraps
80105a1c:	e9 3c fa ff ff       	jmp    8010545d <alltraps>

80105a21 <vector35>:
.globl vector35
vector35:
  pushl $0
80105a21:	6a 00                	push   $0x0
  pushl $35
80105a23:	6a 23                	push   $0x23
  jmp alltraps
80105a25:	e9 33 fa ff ff       	jmp    8010545d <alltraps>

80105a2a <vector36>:
.globl vector36
vector36:
  pushl $0
80105a2a:	6a 00                	push   $0x0
  pushl $36
80105a2c:	6a 24                	push   $0x24
  jmp alltraps
80105a2e:	e9 2a fa ff ff       	jmp    8010545d <alltraps>

80105a33 <vector37>:
.globl vector37
vector37:
  pushl $0
80105a33:	6a 00                	push   $0x0
  pushl $37
80105a35:	6a 25                	push   $0x25
  jmp alltraps
80105a37:	e9 21 fa ff ff       	jmp    8010545d <alltraps>

80105a3c <vector38>:
.globl vector38
vector38:
  pushl $0
80105a3c:	6a 00                	push   $0x0
  pushl $38
80105a3e:	6a 26                	push   $0x26
  jmp alltraps
80105a40:	e9 18 fa ff ff       	jmp    8010545d <alltraps>

80105a45 <vector39>:
.globl vector39
vector39:
  pushl $0
80105a45:	6a 00                	push   $0x0
  pushl $39
80105a47:	6a 27                	push   $0x27
  jmp alltraps
80105a49:	e9 0f fa ff ff       	jmp    8010545d <alltraps>

80105a4e <vector40>:
.globl vector40
vector40:
  pushl $0
80105a4e:	6a 00                	push   $0x0
  pushl $40
80105a50:	6a 28                	push   $0x28
  jmp alltraps
80105a52:	e9 06 fa ff ff       	jmp    8010545d <alltraps>

80105a57 <vector41>:
.globl vector41
vector41:
  pushl $0
80105a57:	6a 00                	push   $0x0
  pushl $41
80105a59:	6a 29                	push   $0x29
  jmp alltraps
80105a5b:	e9 fd f9 ff ff       	jmp    8010545d <alltraps>

80105a60 <vector42>:
.globl vector42
vector42:
  pushl $0
80105a60:	6a 00                	push   $0x0
  pushl $42
80105a62:	6a 2a                	push   $0x2a
  jmp alltraps
80105a64:	e9 f4 f9 ff ff       	jmp    8010545d <alltraps>

80105a69 <vector43>:
.globl vector43
vector43:
  pushl $0
80105a69:	6a 00                	push   $0x0
  pushl $43
80105a6b:	6a 2b                	push   $0x2b
  jmp alltraps
80105a6d:	e9 eb f9 ff ff       	jmp    8010545d <alltraps>

80105a72 <vector44>:
.globl vector44
vector44:
  pushl $0
80105a72:	6a 00                	push   $0x0
  pushl $44
80105a74:	6a 2c                	push   $0x2c
  jmp alltraps
80105a76:	e9 e2 f9 ff ff       	jmp    8010545d <alltraps>

80105a7b <vector45>:
.globl vector45
vector45:
  pushl $0
80105a7b:	6a 00                	push   $0x0
  pushl $45
80105a7d:	6a 2d                	push   $0x2d
  jmp alltraps
80105a7f:	e9 d9 f9 ff ff       	jmp    8010545d <alltraps>

80105a84 <vector46>:
.globl vector46
vector46:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $46
80105a86:	6a 2e                	push   $0x2e
  jmp alltraps
80105a88:	e9 d0 f9 ff ff       	jmp    8010545d <alltraps>

80105a8d <vector47>:
.globl vector47
vector47:
  pushl $0
80105a8d:	6a 00                	push   $0x0
  pushl $47
80105a8f:	6a 2f                	push   $0x2f
  jmp alltraps
80105a91:	e9 c7 f9 ff ff       	jmp    8010545d <alltraps>

80105a96 <vector48>:
.globl vector48
vector48:
  pushl $0
80105a96:	6a 00                	push   $0x0
  pushl $48
80105a98:	6a 30                	push   $0x30
  jmp alltraps
80105a9a:	e9 be f9 ff ff       	jmp    8010545d <alltraps>

80105a9f <vector49>:
.globl vector49
vector49:
  pushl $0
80105a9f:	6a 00                	push   $0x0
  pushl $49
80105aa1:	6a 31                	push   $0x31
  jmp alltraps
80105aa3:	e9 b5 f9 ff ff       	jmp    8010545d <alltraps>

80105aa8 <vector50>:
.globl vector50
vector50:
  pushl $0
80105aa8:	6a 00                	push   $0x0
  pushl $50
80105aaa:	6a 32                	push   $0x32
  jmp alltraps
80105aac:	e9 ac f9 ff ff       	jmp    8010545d <alltraps>

80105ab1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ab1:	6a 00                	push   $0x0
  pushl $51
80105ab3:	6a 33                	push   $0x33
  jmp alltraps
80105ab5:	e9 a3 f9 ff ff       	jmp    8010545d <alltraps>

80105aba <vector52>:
.globl vector52
vector52:
  pushl $0
80105aba:	6a 00                	push   $0x0
  pushl $52
80105abc:	6a 34                	push   $0x34
  jmp alltraps
80105abe:	e9 9a f9 ff ff       	jmp    8010545d <alltraps>

80105ac3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ac3:	6a 00                	push   $0x0
  pushl $53
80105ac5:	6a 35                	push   $0x35
  jmp alltraps
80105ac7:	e9 91 f9 ff ff       	jmp    8010545d <alltraps>

80105acc <vector54>:
.globl vector54
vector54:
  pushl $0
80105acc:	6a 00                	push   $0x0
  pushl $54
80105ace:	6a 36                	push   $0x36
  jmp alltraps
80105ad0:	e9 88 f9 ff ff       	jmp    8010545d <alltraps>

80105ad5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ad5:	6a 00                	push   $0x0
  pushl $55
80105ad7:	6a 37                	push   $0x37
  jmp alltraps
80105ad9:	e9 7f f9 ff ff       	jmp    8010545d <alltraps>

80105ade <vector56>:
.globl vector56
vector56:
  pushl $0
80105ade:	6a 00                	push   $0x0
  pushl $56
80105ae0:	6a 38                	push   $0x38
  jmp alltraps
80105ae2:	e9 76 f9 ff ff       	jmp    8010545d <alltraps>

80105ae7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ae7:	6a 00                	push   $0x0
  pushl $57
80105ae9:	6a 39                	push   $0x39
  jmp alltraps
80105aeb:	e9 6d f9 ff ff       	jmp    8010545d <alltraps>

80105af0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105af0:	6a 00                	push   $0x0
  pushl $58
80105af2:	6a 3a                	push   $0x3a
  jmp alltraps
80105af4:	e9 64 f9 ff ff       	jmp    8010545d <alltraps>

80105af9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105af9:	6a 00                	push   $0x0
  pushl $59
80105afb:	6a 3b                	push   $0x3b
  jmp alltraps
80105afd:	e9 5b f9 ff ff       	jmp    8010545d <alltraps>

80105b02 <vector60>:
.globl vector60
vector60:
  pushl $0
80105b02:	6a 00                	push   $0x0
  pushl $60
80105b04:	6a 3c                	push   $0x3c
  jmp alltraps
80105b06:	e9 52 f9 ff ff       	jmp    8010545d <alltraps>

80105b0b <vector61>:
.globl vector61
vector61:
  pushl $0
80105b0b:	6a 00                	push   $0x0
  pushl $61
80105b0d:	6a 3d                	push   $0x3d
  jmp alltraps
80105b0f:	e9 49 f9 ff ff       	jmp    8010545d <alltraps>

80105b14 <vector62>:
.globl vector62
vector62:
  pushl $0
80105b14:	6a 00                	push   $0x0
  pushl $62
80105b16:	6a 3e                	push   $0x3e
  jmp alltraps
80105b18:	e9 40 f9 ff ff       	jmp    8010545d <alltraps>

80105b1d <vector63>:
.globl vector63
vector63:
  pushl $0
80105b1d:	6a 00                	push   $0x0
  pushl $63
80105b1f:	6a 3f                	push   $0x3f
  jmp alltraps
80105b21:	e9 37 f9 ff ff       	jmp    8010545d <alltraps>

80105b26 <vector64>:
.globl vector64
vector64:
  pushl $0
80105b26:	6a 00                	push   $0x0
  pushl $64
80105b28:	6a 40                	push   $0x40
  jmp alltraps
80105b2a:	e9 2e f9 ff ff       	jmp    8010545d <alltraps>

80105b2f <vector65>:
.globl vector65
vector65:
  pushl $0
80105b2f:	6a 00                	push   $0x0
  pushl $65
80105b31:	6a 41                	push   $0x41
  jmp alltraps
80105b33:	e9 25 f9 ff ff       	jmp    8010545d <alltraps>

80105b38 <vector66>:
.globl vector66
vector66:
  pushl $0
80105b38:	6a 00                	push   $0x0
  pushl $66
80105b3a:	6a 42                	push   $0x42
  jmp alltraps
80105b3c:	e9 1c f9 ff ff       	jmp    8010545d <alltraps>

80105b41 <vector67>:
.globl vector67
vector67:
  pushl $0
80105b41:	6a 00                	push   $0x0
  pushl $67
80105b43:	6a 43                	push   $0x43
  jmp alltraps
80105b45:	e9 13 f9 ff ff       	jmp    8010545d <alltraps>

80105b4a <vector68>:
.globl vector68
vector68:
  pushl $0
80105b4a:	6a 00                	push   $0x0
  pushl $68
80105b4c:	6a 44                	push   $0x44
  jmp alltraps
80105b4e:	e9 0a f9 ff ff       	jmp    8010545d <alltraps>

80105b53 <vector69>:
.globl vector69
vector69:
  pushl $0
80105b53:	6a 00                	push   $0x0
  pushl $69
80105b55:	6a 45                	push   $0x45
  jmp alltraps
80105b57:	e9 01 f9 ff ff       	jmp    8010545d <alltraps>

80105b5c <vector70>:
.globl vector70
vector70:
  pushl $0
80105b5c:	6a 00                	push   $0x0
  pushl $70
80105b5e:	6a 46                	push   $0x46
  jmp alltraps
80105b60:	e9 f8 f8 ff ff       	jmp    8010545d <alltraps>

80105b65 <vector71>:
.globl vector71
vector71:
  pushl $0
80105b65:	6a 00                	push   $0x0
  pushl $71
80105b67:	6a 47                	push   $0x47
  jmp alltraps
80105b69:	e9 ef f8 ff ff       	jmp    8010545d <alltraps>

80105b6e <vector72>:
.globl vector72
vector72:
  pushl $0
80105b6e:	6a 00                	push   $0x0
  pushl $72
80105b70:	6a 48                	push   $0x48
  jmp alltraps
80105b72:	e9 e6 f8 ff ff       	jmp    8010545d <alltraps>

80105b77 <vector73>:
.globl vector73
vector73:
  pushl $0
80105b77:	6a 00                	push   $0x0
  pushl $73
80105b79:	6a 49                	push   $0x49
  jmp alltraps
80105b7b:	e9 dd f8 ff ff       	jmp    8010545d <alltraps>

80105b80 <vector74>:
.globl vector74
vector74:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $74
80105b82:	6a 4a                	push   $0x4a
  jmp alltraps
80105b84:	e9 d4 f8 ff ff       	jmp    8010545d <alltraps>

80105b89 <vector75>:
.globl vector75
vector75:
  pushl $0
80105b89:	6a 00                	push   $0x0
  pushl $75
80105b8b:	6a 4b                	push   $0x4b
  jmp alltraps
80105b8d:	e9 cb f8 ff ff       	jmp    8010545d <alltraps>

80105b92 <vector76>:
.globl vector76
vector76:
  pushl $0
80105b92:	6a 00                	push   $0x0
  pushl $76
80105b94:	6a 4c                	push   $0x4c
  jmp alltraps
80105b96:	e9 c2 f8 ff ff       	jmp    8010545d <alltraps>

80105b9b <vector77>:
.globl vector77
vector77:
  pushl $0
80105b9b:	6a 00                	push   $0x0
  pushl $77
80105b9d:	6a 4d                	push   $0x4d
  jmp alltraps
80105b9f:	e9 b9 f8 ff ff       	jmp    8010545d <alltraps>

80105ba4 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $78
80105ba6:	6a 4e                	push   $0x4e
  jmp alltraps
80105ba8:	e9 b0 f8 ff ff       	jmp    8010545d <alltraps>

80105bad <vector79>:
.globl vector79
vector79:
  pushl $0
80105bad:	6a 00                	push   $0x0
  pushl $79
80105baf:	6a 4f                	push   $0x4f
  jmp alltraps
80105bb1:	e9 a7 f8 ff ff       	jmp    8010545d <alltraps>

80105bb6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105bb6:	6a 00                	push   $0x0
  pushl $80
80105bb8:	6a 50                	push   $0x50
  jmp alltraps
80105bba:	e9 9e f8 ff ff       	jmp    8010545d <alltraps>

80105bbf <vector81>:
.globl vector81
vector81:
  pushl $0
80105bbf:	6a 00                	push   $0x0
  pushl $81
80105bc1:	6a 51                	push   $0x51
  jmp alltraps
80105bc3:	e9 95 f8 ff ff       	jmp    8010545d <alltraps>

80105bc8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105bc8:	6a 00                	push   $0x0
  pushl $82
80105bca:	6a 52                	push   $0x52
  jmp alltraps
80105bcc:	e9 8c f8 ff ff       	jmp    8010545d <alltraps>

80105bd1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105bd1:	6a 00                	push   $0x0
  pushl $83
80105bd3:	6a 53                	push   $0x53
  jmp alltraps
80105bd5:	e9 83 f8 ff ff       	jmp    8010545d <alltraps>

80105bda <vector84>:
.globl vector84
vector84:
  pushl $0
80105bda:	6a 00                	push   $0x0
  pushl $84
80105bdc:	6a 54                	push   $0x54
  jmp alltraps
80105bde:	e9 7a f8 ff ff       	jmp    8010545d <alltraps>

80105be3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105be3:	6a 00                	push   $0x0
  pushl $85
80105be5:	6a 55                	push   $0x55
  jmp alltraps
80105be7:	e9 71 f8 ff ff       	jmp    8010545d <alltraps>

80105bec <vector86>:
.globl vector86
vector86:
  pushl $0
80105bec:	6a 00                	push   $0x0
  pushl $86
80105bee:	6a 56                	push   $0x56
  jmp alltraps
80105bf0:	e9 68 f8 ff ff       	jmp    8010545d <alltraps>

80105bf5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105bf5:	6a 00                	push   $0x0
  pushl $87
80105bf7:	6a 57                	push   $0x57
  jmp alltraps
80105bf9:	e9 5f f8 ff ff       	jmp    8010545d <alltraps>

80105bfe <vector88>:
.globl vector88
vector88:
  pushl $0
80105bfe:	6a 00                	push   $0x0
  pushl $88
80105c00:	6a 58                	push   $0x58
  jmp alltraps
80105c02:	e9 56 f8 ff ff       	jmp    8010545d <alltraps>

80105c07 <vector89>:
.globl vector89
vector89:
  pushl $0
80105c07:	6a 00                	push   $0x0
  pushl $89
80105c09:	6a 59                	push   $0x59
  jmp alltraps
80105c0b:	e9 4d f8 ff ff       	jmp    8010545d <alltraps>

80105c10 <vector90>:
.globl vector90
vector90:
  pushl $0
80105c10:	6a 00                	push   $0x0
  pushl $90
80105c12:	6a 5a                	push   $0x5a
  jmp alltraps
80105c14:	e9 44 f8 ff ff       	jmp    8010545d <alltraps>

80105c19 <vector91>:
.globl vector91
vector91:
  pushl $0
80105c19:	6a 00                	push   $0x0
  pushl $91
80105c1b:	6a 5b                	push   $0x5b
  jmp alltraps
80105c1d:	e9 3b f8 ff ff       	jmp    8010545d <alltraps>

80105c22 <vector92>:
.globl vector92
vector92:
  pushl $0
80105c22:	6a 00                	push   $0x0
  pushl $92
80105c24:	6a 5c                	push   $0x5c
  jmp alltraps
80105c26:	e9 32 f8 ff ff       	jmp    8010545d <alltraps>

80105c2b <vector93>:
.globl vector93
vector93:
  pushl $0
80105c2b:	6a 00                	push   $0x0
  pushl $93
80105c2d:	6a 5d                	push   $0x5d
  jmp alltraps
80105c2f:	e9 29 f8 ff ff       	jmp    8010545d <alltraps>

80105c34 <vector94>:
.globl vector94
vector94:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $94
80105c36:	6a 5e                	push   $0x5e
  jmp alltraps
80105c38:	e9 20 f8 ff ff       	jmp    8010545d <alltraps>

80105c3d <vector95>:
.globl vector95
vector95:
  pushl $0
80105c3d:	6a 00                	push   $0x0
  pushl $95
80105c3f:	6a 5f                	push   $0x5f
  jmp alltraps
80105c41:	e9 17 f8 ff ff       	jmp    8010545d <alltraps>

80105c46 <vector96>:
.globl vector96
vector96:
  pushl $0
80105c46:	6a 00                	push   $0x0
  pushl $96
80105c48:	6a 60                	push   $0x60
  jmp alltraps
80105c4a:	e9 0e f8 ff ff       	jmp    8010545d <alltraps>

80105c4f <vector97>:
.globl vector97
vector97:
  pushl $0
80105c4f:	6a 00                	push   $0x0
  pushl $97
80105c51:	6a 61                	push   $0x61
  jmp alltraps
80105c53:	e9 05 f8 ff ff       	jmp    8010545d <alltraps>

80105c58 <vector98>:
.globl vector98
vector98:
  pushl $0
80105c58:	6a 00                	push   $0x0
  pushl $98
80105c5a:	6a 62                	push   $0x62
  jmp alltraps
80105c5c:	e9 fc f7 ff ff       	jmp    8010545d <alltraps>

80105c61 <vector99>:
.globl vector99
vector99:
  pushl $0
80105c61:	6a 00                	push   $0x0
  pushl $99
80105c63:	6a 63                	push   $0x63
  jmp alltraps
80105c65:	e9 f3 f7 ff ff       	jmp    8010545d <alltraps>

80105c6a <vector100>:
.globl vector100
vector100:
  pushl $0
80105c6a:	6a 00                	push   $0x0
  pushl $100
80105c6c:	6a 64                	push   $0x64
  jmp alltraps
80105c6e:	e9 ea f7 ff ff       	jmp    8010545d <alltraps>

80105c73 <vector101>:
.globl vector101
vector101:
  pushl $0
80105c73:	6a 00                	push   $0x0
  pushl $101
80105c75:	6a 65                	push   $0x65
  jmp alltraps
80105c77:	e9 e1 f7 ff ff       	jmp    8010545d <alltraps>

80105c7c <vector102>:
.globl vector102
vector102:
  pushl $0
80105c7c:	6a 00                	push   $0x0
  pushl $102
80105c7e:	6a 66                	push   $0x66
  jmp alltraps
80105c80:	e9 d8 f7 ff ff       	jmp    8010545d <alltraps>

80105c85 <vector103>:
.globl vector103
vector103:
  pushl $0
80105c85:	6a 00                	push   $0x0
  pushl $103
80105c87:	6a 67                	push   $0x67
  jmp alltraps
80105c89:	e9 cf f7 ff ff       	jmp    8010545d <alltraps>

80105c8e <vector104>:
.globl vector104
vector104:
  pushl $0
80105c8e:	6a 00                	push   $0x0
  pushl $104
80105c90:	6a 68                	push   $0x68
  jmp alltraps
80105c92:	e9 c6 f7 ff ff       	jmp    8010545d <alltraps>

80105c97 <vector105>:
.globl vector105
vector105:
  pushl $0
80105c97:	6a 00                	push   $0x0
  pushl $105
80105c99:	6a 69                	push   $0x69
  jmp alltraps
80105c9b:	e9 bd f7 ff ff       	jmp    8010545d <alltraps>

80105ca0 <vector106>:
.globl vector106
vector106:
  pushl $0
80105ca0:	6a 00                	push   $0x0
  pushl $106
80105ca2:	6a 6a                	push   $0x6a
  jmp alltraps
80105ca4:	e9 b4 f7 ff ff       	jmp    8010545d <alltraps>

80105ca9 <vector107>:
.globl vector107
vector107:
  pushl $0
80105ca9:	6a 00                	push   $0x0
  pushl $107
80105cab:	6a 6b                	push   $0x6b
  jmp alltraps
80105cad:	e9 ab f7 ff ff       	jmp    8010545d <alltraps>

80105cb2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105cb2:	6a 00                	push   $0x0
  pushl $108
80105cb4:	6a 6c                	push   $0x6c
  jmp alltraps
80105cb6:	e9 a2 f7 ff ff       	jmp    8010545d <alltraps>

80105cbb <vector109>:
.globl vector109
vector109:
  pushl $0
80105cbb:	6a 00                	push   $0x0
  pushl $109
80105cbd:	6a 6d                	push   $0x6d
  jmp alltraps
80105cbf:	e9 99 f7 ff ff       	jmp    8010545d <alltraps>

80105cc4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105cc4:	6a 00                	push   $0x0
  pushl $110
80105cc6:	6a 6e                	push   $0x6e
  jmp alltraps
80105cc8:	e9 90 f7 ff ff       	jmp    8010545d <alltraps>

80105ccd <vector111>:
.globl vector111
vector111:
  pushl $0
80105ccd:	6a 00                	push   $0x0
  pushl $111
80105ccf:	6a 6f                	push   $0x6f
  jmp alltraps
80105cd1:	e9 87 f7 ff ff       	jmp    8010545d <alltraps>

80105cd6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105cd6:	6a 00                	push   $0x0
  pushl $112
80105cd8:	6a 70                	push   $0x70
  jmp alltraps
80105cda:	e9 7e f7 ff ff       	jmp    8010545d <alltraps>

80105cdf <vector113>:
.globl vector113
vector113:
  pushl $0
80105cdf:	6a 00                	push   $0x0
  pushl $113
80105ce1:	6a 71                	push   $0x71
  jmp alltraps
80105ce3:	e9 75 f7 ff ff       	jmp    8010545d <alltraps>

80105ce8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ce8:	6a 00                	push   $0x0
  pushl $114
80105cea:	6a 72                	push   $0x72
  jmp alltraps
80105cec:	e9 6c f7 ff ff       	jmp    8010545d <alltraps>

80105cf1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105cf1:	6a 00                	push   $0x0
  pushl $115
80105cf3:	6a 73                	push   $0x73
  jmp alltraps
80105cf5:	e9 63 f7 ff ff       	jmp    8010545d <alltraps>

80105cfa <vector116>:
.globl vector116
vector116:
  pushl $0
80105cfa:	6a 00                	push   $0x0
  pushl $116
80105cfc:	6a 74                	push   $0x74
  jmp alltraps
80105cfe:	e9 5a f7 ff ff       	jmp    8010545d <alltraps>

80105d03 <vector117>:
.globl vector117
vector117:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $117
80105d05:	6a 75                	push   $0x75
  jmp alltraps
80105d07:	e9 51 f7 ff ff       	jmp    8010545d <alltraps>

80105d0c <vector118>:
.globl vector118
vector118:
  pushl $0
80105d0c:	6a 00                	push   $0x0
  pushl $118
80105d0e:	6a 76                	push   $0x76
  jmp alltraps
80105d10:	e9 48 f7 ff ff       	jmp    8010545d <alltraps>

80105d15 <vector119>:
.globl vector119
vector119:
  pushl $0
80105d15:	6a 00                	push   $0x0
  pushl $119
80105d17:	6a 77                	push   $0x77
  jmp alltraps
80105d19:	e9 3f f7 ff ff       	jmp    8010545d <alltraps>

80105d1e <vector120>:
.globl vector120
vector120:
  pushl $0
80105d1e:	6a 00                	push   $0x0
  pushl $120
80105d20:	6a 78                	push   $0x78
  jmp alltraps
80105d22:	e9 36 f7 ff ff       	jmp    8010545d <alltraps>

80105d27 <vector121>:
.globl vector121
vector121:
  pushl $0
80105d27:	6a 00                	push   $0x0
  pushl $121
80105d29:	6a 79                	push   $0x79
  jmp alltraps
80105d2b:	e9 2d f7 ff ff       	jmp    8010545d <alltraps>

80105d30 <vector122>:
.globl vector122
vector122:
  pushl $0
80105d30:	6a 00                	push   $0x0
  pushl $122
80105d32:	6a 7a                	push   $0x7a
  jmp alltraps
80105d34:	e9 24 f7 ff ff       	jmp    8010545d <alltraps>

80105d39 <vector123>:
.globl vector123
vector123:
  pushl $0
80105d39:	6a 00                	push   $0x0
  pushl $123
80105d3b:	6a 7b                	push   $0x7b
  jmp alltraps
80105d3d:	e9 1b f7 ff ff       	jmp    8010545d <alltraps>

80105d42 <vector124>:
.globl vector124
vector124:
  pushl $0
80105d42:	6a 00                	push   $0x0
  pushl $124
80105d44:	6a 7c                	push   $0x7c
  jmp alltraps
80105d46:	e9 12 f7 ff ff       	jmp    8010545d <alltraps>

80105d4b <vector125>:
.globl vector125
vector125:
  pushl $0
80105d4b:	6a 00                	push   $0x0
  pushl $125
80105d4d:	6a 7d                	push   $0x7d
  jmp alltraps
80105d4f:	e9 09 f7 ff ff       	jmp    8010545d <alltraps>

80105d54 <vector126>:
.globl vector126
vector126:
  pushl $0
80105d54:	6a 00                	push   $0x0
  pushl $126
80105d56:	6a 7e                	push   $0x7e
  jmp alltraps
80105d58:	e9 00 f7 ff ff       	jmp    8010545d <alltraps>

80105d5d <vector127>:
.globl vector127
vector127:
  pushl $0
80105d5d:	6a 00                	push   $0x0
  pushl $127
80105d5f:	6a 7f                	push   $0x7f
  jmp alltraps
80105d61:	e9 f7 f6 ff ff       	jmp    8010545d <alltraps>

80105d66 <vector128>:
.globl vector128
vector128:
  pushl $0
80105d66:	6a 00                	push   $0x0
  pushl $128
80105d68:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105d6d:	e9 eb f6 ff ff       	jmp    8010545d <alltraps>

80105d72 <vector129>:
.globl vector129
vector129:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $129
80105d74:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105d79:	e9 df f6 ff ff       	jmp    8010545d <alltraps>

80105d7e <vector130>:
.globl vector130
vector130:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $130
80105d80:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105d85:	e9 d3 f6 ff ff       	jmp    8010545d <alltraps>

80105d8a <vector131>:
.globl vector131
vector131:
  pushl $0
80105d8a:	6a 00                	push   $0x0
  pushl $131
80105d8c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105d91:	e9 c7 f6 ff ff       	jmp    8010545d <alltraps>

80105d96 <vector132>:
.globl vector132
vector132:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $132
80105d98:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105d9d:	e9 bb f6 ff ff       	jmp    8010545d <alltraps>

80105da2 <vector133>:
.globl vector133
vector133:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $133
80105da4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105da9:	e9 af f6 ff ff       	jmp    8010545d <alltraps>

80105dae <vector134>:
.globl vector134
vector134:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $134
80105db0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105db5:	e9 a3 f6 ff ff       	jmp    8010545d <alltraps>

80105dba <vector135>:
.globl vector135
vector135:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $135
80105dbc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105dc1:	e9 97 f6 ff ff       	jmp    8010545d <alltraps>

80105dc6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $136
80105dc8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105dcd:	e9 8b f6 ff ff       	jmp    8010545d <alltraps>

80105dd2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $137
80105dd4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105dd9:	e9 7f f6 ff ff       	jmp    8010545d <alltraps>

80105dde <vector138>:
.globl vector138
vector138:
  pushl $0
80105dde:	6a 00                	push   $0x0
  pushl $138
80105de0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105de5:	e9 73 f6 ff ff       	jmp    8010545d <alltraps>

80105dea <vector139>:
.globl vector139
vector139:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $139
80105dec:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105df1:	e9 67 f6 ff ff       	jmp    8010545d <alltraps>

80105df6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105df6:	6a 00                	push   $0x0
  pushl $140
80105df8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105dfd:	e9 5b f6 ff ff       	jmp    8010545d <alltraps>

80105e02 <vector141>:
.globl vector141
vector141:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $141
80105e04:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105e09:	e9 4f f6 ff ff       	jmp    8010545d <alltraps>

80105e0e <vector142>:
.globl vector142
vector142:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $142
80105e10:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105e15:	e9 43 f6 ff ff       	jmp    8010545d <alltraps>

80105e1a <vector143>:
.globl vector143
vector143:
  pushl $0
80105e1a:	6a 00                	push   $0x0
  pushl $143
80105e1c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105e21:	e9 37 f6 ff ff       	jmp    8010545d <alltraps>

80105e26 <vector144>:
.globl vector144
vector144:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $144
80105e28:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105e2d:	e9 2b f6 ff ff       	jmp    8010545d <alltraps>

80105e32 <vector145>:
.globl vector145
vector145:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $145
80105e34:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105e39:	e9 1f f6 ff ff       	jmp    8010545d <alltraps>

80105e3e <vector146>:
.globl vector146
vector146:
  pushl $0
80105e3e:	6a 00                	push   $0x0
  pushl $146
80105e40:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105e45:	e9 13 f6 ff ff       	jmp    8010545d <alltraps>

80105e4a <vector147>:
.globl vector147
vector147:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $147
80105e4c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105e51:	e9 07 f6 ff ff       	jmp    8010545d <alltraps>

80105e56 <vector148>:
.globl vector148
vector148:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $148
80105e58:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105e5d:	e9 fb f5 ff ff       	jmp    8010545d <alltraps>

80105e62 <vector149>:
.globl vector149
vector149:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $149
80105e64:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105e69:	e9 ef f5 ff ff       	jmp    8010545d <alltraps>

80105e6e <vector150>:
.globl vector150
vector150:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $150
80105e70:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105e75:	e9 e3 f5 ff ff       	jmp    8010545d <alltraps>

80105e7a <vector151>:
.globl vector151
vector151:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $151
80105e7c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105e81:	e9 d7 f5 ff ff       	jmp    8010545d <alltraps>

80105e86 <vector152>:
.globl vector152
vector152:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $152
80105e88:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105e8d:	e9 cb f5 ff ff       	jmp    8010545d <alltraps>

80105e92 <vector153>:
.globl vector153
vector153:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $153
80105e94:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105e99:	e9 bf f5 ff ff       	jmp    8010545d <alltraps>

80105e9e <vector154>:
.globl vector154
vector154:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $154
80105ea0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105ea5:	e9 b3 f5 ff ff       	jmp    8010545d <alltraps>

80105eaa <vector155>:
.globl vector155
vector155:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $155
80105eac:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105eb1:	e9 a7 f5 ff ff       	jmp    8010545d <alltraps>

80105eb6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $156
80105eb8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105ebd:	e9 9b f5 ff ff       	jmp    8010545d <alltraps>

80105ec2 <vector157>:
.globl vector157
vector157:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $157
80105ec4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105ec9:	e9 8f f5 ff ff       	jmp    8010545d <alltraps>

80105ece <vector158>:
.globl vector158
vector158:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $158
80105ed0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105ed5:	e9 83 f5 ff ff       	jmp    8010545d <alltraps>

80105eda <vector159>:
.globl vector159
vector159:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $159
80105edc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ee1:	e9 77 f5 ff ff       	jmp    8010545d <alltraps>

80105ee6 <vector160>:
.globl vector160
vector160:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $160
80105ee8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105eed:	e9 6b f5 ff ff       	jmp    8010545d <alltraps>

80105ef2 <vector161>:
.globl vector161
vector161:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $161
80105ef4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105ef9:	e9 5f f5 ff ff       	jmp    8010545d <alltraps>

80105efe <vector162>:
.globl vector162
vector162:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $162
80105f00:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105f05:	e9 53 f5 ff ff       	jmp    8010545d <alltraps>

80105f0a <vector163>:
.globl vector163
vector163:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $163
80105f0c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105f11:	e9 47 f5 ff ff       	jmp    8010545d <alltraps>

80105f16 <vector164>:
.globl vector164
vector164:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $164
80105f18:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105f1d:	e9 3b f5 ff ff       	jmp    8010545d <alltraps>

80105f22 <vector165>:
.globl vector165
vector165:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $165
80105f24:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105f29:	e9 2f f5 ff ff       	jmp    8010545d <alltraps>

80105f2e <vector166>:
.globl vector166
vector166:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $166
80105f30:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105f35:	e9 23 f5 ff ff       	jmp    8010545d <alltraps>

80105f3a <vector167>:
.globl vector167
vector167:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $167
80105f3c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105f41:	e9 17 f5 ff ff       	jmp    8010545d <alltraps>

80105f46 <vector168>:
.globl vector168
vector168:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $168
80105f48:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105f4d:	e9 0b f5 ff ff       	jmp    8010545d <alltraps>

80105f52 <vector169>:
.globl vector169
vector169:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $169
80105f54:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105f59:	e9 ff f4 ff ff       	jmp    8010545d <alltraps>

80105f5e <vector170>:
.globl vector170
vector170:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $170
80105f60:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105f65:	e9 f3 f4 ff ff       	jmp    8010545d <alltraps>

80105f6a <vector171>:
.globl vector171
vector171:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $171
80105f6c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105f71:	e9 e7 f4 ff ff       	jmp    8010545d <alltraps>

80105f76 <vector172>:
.globl vector172
vector172:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $172
80105f78:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105f7d:	e9 db f4 ff ff       	jmp    8010545d <alltraps>

80105f82 <vector173>:
.globl vector173
vector173:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $173
80105f84:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105f89:	e9 cf f4 ff ff       	jmp    8010545d <alltraps>

80105f8e <vector174>:
.globl vector174
vector174:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $174
80105f90:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105f95:	e9 c3 f4 ff ff       	jmp    8010545d <alltraps>

80105f9a <vector175>:
.globl vector175
vector175:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $175
80105f9c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105fa1:	e9 b7 f4 ff ff       	jmp    8010545d <alltraps>

80105fa6 <vector176>:
.globl vector176
vector176:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $176
80105fa8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105fad:	e9 ab f4 ff ff       	jmp    8010545d <alltraps>

80105fb2 <vector177>:
.globl vector177
vector177:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $177
80105fb4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105fb9:	e9 9f f4 ff ff       	jmp    8010545d <alltraps>

80105fbe <vector178>:
.globl vector178
vector178:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $178
80105fc0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105fc5:	e9 93 f4 ff ff       	jmp    8010545d <alltraps>

80105fca <vector179>:
.globl vector179
vector179:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $179
80105fcc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105fd1:	e9 87 f4 ff ff       	jmp    8010545d <alltraps>

80105fd6 <vector180>:
.globl vector180
vector180:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $180
80105fd8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105fdd:	e9 7b f4 ff ff       	jmp    8010545d <alltraps>

80105fe2 <vector181>:
.globl vector181
vector181:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $181
80105fe4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105fe9:	e9 6f f4 ff ff       	jmp    8010545d <alltraps>

80105fee <vector182>:
.globl vector182
vector182:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $182
80105ff0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105ff5:	e9 63 f4 ff ff       	jmp    8010545d <alltraps>

80105ffa <vector183>:
.globl vector183
vector183:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $183
80105ffc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106001:	e9 57 f4 ff ff       	jmp    8010545d <alltraps>

80106006 <vector184>:
.globl vector184
vector184:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $184
80106008:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010600d:	e9 4b f4 ff ff       	jmp    8010545d <alltraps>

80106012 <vector185>:
.globl vector185
vector185:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $185
80106014:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106019:	e9 3f f4 ff ff       	jmp    8010545d <alltraps>

8010601e <vector186>:
.globl vector186
vector186:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $186
80106020:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106025:	e9 33 f4 ff ff       	jmp    8010545d <alltraps>

8010602a <vector187>:
.globl vector187
vector187:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $187
8010602c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106031:	e9 27 f4 ff ff       	jmp    8010545d <alltraps>

80106036 <vector188>:
.globl vector188
vector188:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $188
80106038:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010603d:	e9 1b f4 ff ff       	jmp    8010545d <alltraps>

80106042 <vector189>:
.globl vector189
vector189:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $189
80106044:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106049:	e9 0f f4 ff ff       	jmp    8010545d <alltraps>

8010604e <vector190>:
.globl vector190
vector190:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $190
80106050:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106055:	e9 03 f4 ff ff       	jmp    8010545d <alltraps>

8010605a <vector191>:
.globl vector191
vector191:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $191
8010605c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106061:	e9 f7 f3 ff ff       	jmp    8010545d <alltraps>

80106066 <vector192>:
.globl vector192
vector192:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $192
80106068:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010606d:	e9 eb f3 ff ff       	jmp    8010545d <alltraps>

80106072 <vector193>:
.globl vector193
vector193:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $193
80106074:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106079:	e9 df f3 ff ff       	jmp    8010545d <alltraps>

8010607e <vector194>:
.globl vector194
vector194:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $194
80106080:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106085:	e9 d3 f3 ff ff       	jmp    8010545d <alltraps>

8010608a <vector195>:
.globl vector195
vector195:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $195
8010608c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106091:	e9 c7 f3 ff ff       	jmp    8010545d <alltraps>

80106096 <vector196>:
.globl vector196
vector196:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $196
80106098:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010609d:	e9 bb f3 ff ff       	jmp    8010545d <alltraps>

801060a2 <vector197>:
.globl vector197
vector197:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $197
801060a4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801060a9:	e9 af f3 ff ff       	jmp    8010545d <alltraps>

801060ae <vector198>:
.globl vector198
vector198:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $198
801060b0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801060b5:	e9 a3 f3 ff ff       	jmp    8010545d <alltraps>

801060ba <vector199>:
.globl vector199
vector199:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $199
801060bc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801060c1:	e9 97 f3 ff ff       	jmp    8010545d <alltraps>

801060c6 <vector200>:
.globl vector200
vector200:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $200
801060c8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801060cd:	e9 8b f3 ff ff       	jmp    8010545d <alltraps>

801060d2 <vector201>:
.globl vector201
vector201:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $201
801060d4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801060d9:	e9 7f f3 ff ff       	jmp    8010545d <alltraps>

801060de <vector202>:
.globl vector202
vector202:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $202
801060e0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801060e5:	e9 73 f3 ff ff       	jmp    8010545d <alltraps>

801060ea <vector203>:
.globl vector203
vector203:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $203
801060ec:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801060f1:	e9 67 f3 ff ff       	jmp    8010545d <alltraps>

801060f6 <vector204>:
.globl vector204
vector204:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $204
801060f8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801060fd:	e9 5b f3 ff ff       	jmp    8010545d <alltraps>

80106102 <vector205>:
.globl vector205
vector205:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $205
80106104:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106109:	e9 4f f3 ff ff       	jmp    8010545d <alltraps>

8010610e <vector206>:
.globl vector206
vector206:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $206
80106110:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106115:	e9 43 f3 ff ff       	jmp    8010545d <alltraps>

8010611a <vector207>:
.globl vector207
vector207:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $207
8010611c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106121:	e9 37 f3 ff ff       	jmp    8010545d <alltraps>

80106126 <vector208>:
.globl vector208
vector208:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $208
80106128:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010612d:	e9 2b f3 ff ff       	jmp    8010545d <alltraps>

80106132 <vector209>:
.globl vector209
vector209:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $209
80106134:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106139:	e9 1f f3 ff ff       	jmp    8010545d <alltraps>

8010613e <vector210>:
.globl vector210
vector210:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $210
80106140:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106145:	e9 13 f3 ff ff       	jmp    8010545d <alltraps>

8010614a <vector211>:
.globl vector211
vector211:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $211
8010614c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106151:	e9 07 f3 ff ff       	jmp    8010545d <alltraps>

80106156 <vector212>:
.globl vector212
vector212:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $212
80106158:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010615d:	e9 fb f2 ff ff       	jmp    8010545d <alltraps>

80106162 <vector213>:
.globl vector213
vector213:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $213
80106164:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106169:	e9 ef f2 ff ff       	jmp    8010545d <alltraps>

8010616e <vector214>:
.globl vector214
vector214:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $214
80106170:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106175:	e9 e3 f2 ff ff       	jmp    8010545d <alltraps>

8010617a <vector215>:
.globl vector215
vector215:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $215
8010617c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106181:	e9 d7 f2 ff ff       	jmp    8010545d <alltraps>

80106186 <vector216>:
.globl vector216
vector216:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $216
80106188:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010618d:	e9 cb f2 ff ff       	jmp    8010545d <alltraps>

80106192 <vector217>:
.globl vector217
vector217:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $217
80106194:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106199:	e9 bf f2 ff ff       	jmp    8010545d <alltraps>

8010619e <vector218>:
.globl vector218
vector218:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $218
801061a0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801061a5:	e9 b3 f2 ff ff       	jmp    8010545d <alltraps>

801061aa <vector219>:
.globl vector219
vector219:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $219
801061ac:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801061b1:	e9 a7 f2 ff ff       	jmp    8010545d <alltraps>

801061b6 <vector220>:
.globl vector220
vector220:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $220
801061b8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801061bd:	e9 9b f2 ff ff       	jmp    8010545d <alltraps>

801061c2 <vector221>:
.globl vector221
vector221:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $221
801061c4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801061c9:	e9 8f f2 ff ff       	jmp    8010545d <alltraps>

801061ce <vector222>:
.globl vector222
vector222:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $222
801061d0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801061d5:	e9 83 f2 ff ff       	jmp    8010545d <alltraps>

801061da <vector223>:
.globl vector223
vector223:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $223
801061dc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801061e1:	e9 77 f2 ff ff       	jmp    8010545d <alltraps>

801061e6 <vector224>:
.globl vector224
vector224:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $224
801061e8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801061ed:	e9 6b f2 ff ff       	jmp    8010545d <alltraps>

801061f2 <vector225>:
.globl vector225
vector225:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $225
801061f4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801061f9:	e9 5f f2 ff ff       	jmp    8010545d <alltraps>

801061fe <vector226>:
.globl vector226
vector226:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $226
80106200:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106205:	e9 53 f2 ff ff       	jmp    8010545d <alltraps>

8010620a <vector227>:
.globl vector227
vector227:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $227
8010620c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106211:	e9 47 f2 ff ff       	jmp    8010545d <alltraps>

80106216 <vector228>:
.globl vector228
vector228:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $228
80106218:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010621d:	e9 3b f2 ff ff       	jmp    8010545d <alltraps>

80106222 <vector229>:
.globl vector229
vector229:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $229
80106224:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106229:	e9 2f f2 ff ff       	jmp    8010545d <alltraps>

8010622e <vector230>:
.globl vector230
vector230:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $230
80106230:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106235:	e9 23 f2 ff ff       	jmp    8010545d <alltraps>

8010623a <vector231>:
.globl vector231
vector231:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $231
8010623c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106241:	e9 17 f2 ff ff       	jmp    8010545d <alltraps>

80106246 <vector232>:
.globl vector232
vector232:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $232
80106248:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010624d:	e9 0b f2 ff ff       	jmp    8010545d <alltraps>

80106252 <vector233>:
.globl vector233
vector233:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $233
80106254:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106259:	e9 ff f1 ff ff       	jmp    8010545d <alltraps>

8010625e <vector234>:
.globl vector234
vector234:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $234
80106260:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106265:	e9 f3 f1 ff ff       	jmp    8010545d <alltraps>

8010626a <vector235>:
.globl vector235
vector235:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $235
8010626c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106271:	e9 e7 f1 ff ff       	jmp    8010545d <alltraps>

80106276 <vector236>:
.globl vector236
vector236:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $236
80106278:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010627d:	e9 db f1 ff ff       	jmp    8010545d <alltraps>

80106282 <vector237>:
.globl vector237
vector237:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $237
80106284:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106289:	e9 cf f1 ff ff       	jmp    8010545d <alltraps>

8010628e <vector238>:
.globl vector238
vector238:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $238
80106290:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106295:	e9 c3 f1 ff ff       	jmp    8010545d <alltraps>

8010629a <vector239>:
.globl vector239
vector239:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $239
8010629c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801062a1:	e9 b7 f1 ff ff       	jmp    8010545d <alltraps>

801062a6 <vector240>:
.globl vector240
vector240:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $240
801062a8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801062ad:	e9 ab f1 ff ff       	jmp    8010545d <alltraps>

801062b2 <vector241>:
.globl vector241
vector241:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $241
801062b4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801062b9:	e9 9f f1 ff ff       	jmp    8010545d <alltraps>

801062be <vector242>:
.globl vector242
vector242:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $242
801062c0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801062c5:	e9 93 f1 ff ff       	jmp    8010545d <alltraps>

801062ca <vector243>:
.globl vector243
vector243:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $243
801062cc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801062d1:	e9 87 f1 ff ff       	jmp    8010545d <alltraps>

801062d6 <vector244>:
.globl vector244
vector244:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $244
801062d8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801062dd:	e9 7b f1 ff ff       	jmp    8010545d <alltraps>

801062e2 <vector245>:
.globl vector245
vector245:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $245
801062e4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801062e9:	e9 6f f1 ff ff       	jmp    8010545d <alltraps>

801062ee <vector246>:
.globl vector246
vector246:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $246
801062f0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801062f5:	e9 63 f1 ff ff       	jmp    8010545d <alltraps>

801062fa <vector247>:
.globl vector247
vector247:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $247
801062fc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106301:	e9 57 f1 ff ff       	jmp    8010545d <alltraps>

80106306 <vector248>:
.globl vector248
vector248:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $248
80106308:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010630d:	e9 4b f1 ff ff       	jmp    8010545d <alltraps>

80106312 <vector249>:
.globl vector249
vector249:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $249
80106314:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106319:	e9 3f f1 ff ff       	jmp    8010545d <alltraps>

8010631e <vector250>:
.globl vector250
vector250:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $250
80106320:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106325:	e9 33 f1 ff ff       	jmp    8010545d <alltraps>

8010632a <vector251>:
.globl vector251
vector251:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $251
8010632c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106331:	e9 27 f1 ff ff       	jmp    8010545d <alltraps>

80106336 <vector252>:
.globl vector252
vector252:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $252
80106338:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010633d:	e9 1b f1 ff ff       	jmp    8010545d <alltraps>

80106342 <vector253>:
.globl vector253
vector253:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $253
80106344:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106349:	e9 0f f1 ff ff       	jmp    8010545d <alltraps>

8010634e <vector254>:
.globl vector254
vector254:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $254
80106350:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106355:	e9 03 f1 ff ff       	jmp    8010545d <alltraps>

8010635a <vector255>:
.globl vector255
vector255:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $255
8010635c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106361:	e9 f7 f0 ff ff       	jmp    8010545d <alltraps>
80106366:	66 90                	xchg   %ax,%ax
80106368:	66 90                	xchg   %ax,%ax
8010636a:	66 90                	xchg   %ax,%ax
8010636c:	66 90                	xchg   %ax,%ax
8010636e:	66 90                	xchg   %ax,%ax

80106370 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
80106373:	57                   	push   %edi
80106374:	56                   	push   %esi
80106375:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106377:	c1 ea 16             	shr    $0x16,%edx
{
8010637a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010637b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010637e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106381:	8b 1f                	mov    (%edi),%ebx
80106383:	f6 c3 01             	test   $0x1,%bl
80106386:	74 28                	je     801063b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106388:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010638e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106394:	c1 ee 0a             	shr    $0xa,%esi
}
80106397:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010639a:	89 f2                	mov    %esi,%edx
8010639c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801063a2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801063a5:	5b                   	pop    %ebx
801063a6:	5e                   	pop    %esi
801063a7:	5f                   	pop    %edi
801063a8:	5d                   	pop    %ebp
801063a9:	c3                   	ret    
801063aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801063b0:	85 c9                	test   %ecx,%ecx
801063b2:	74 34                	je     801063e8 <walkpgdir+0x78>
801063b4:	e8 a7 c1 ff ff       	call   80102560 <kalloc>
801063b9:	85 c0                	test   %eax,%eax
801063bb:	89 c3                	mov    %eax,%ebx
801063bd:	74 29                	je     801063e8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
801063bf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801063c6:	00 
801063c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063ce:	00 
801063cf:	89 04 24             	mov    %eax,(%esp)
801063d2:	e8 69 df ff ff       	call   80104340 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801063d7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801063dd:	83 c8 07             	or     $0x7,%eax
801063e0:	89 07                	mov    %eax,(%edi)
801063e2:	eb b0                	jmp    80106394 <walkpgdir+0x24>
801063e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801063e8:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801063eb:	31 c0                	xor    %eax,%eax
}
801063ed:	5b                   	pop    %ebx
801063ee:	5e                   	pop    %esi
801063ef:	5f                   	pop    %edi
801063f0:	5d                   	pop    %ebp
801063f1:	c3                   	ret    
801063f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106400 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	57                   	push   %edi
80106404:	56                   	push   %esi
80106405:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106406:	89 d3                	mov    %edx,%ebx
{
80106408:	83 ec 1c             	sub    $0x1c,%esp
8010640b:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
8010640e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106414:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106417:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010641b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010641e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106422:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106429:	29 df                	sub    %ebx,%edi
8010642b:	eb 18                	jmp    80106445 <mappages+0x45>
8010642d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
80106430:	f6 00 01             	testb  $0x1,(%eax)
80106433:	75 3d                	jne    80106472 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106435:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106438:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010643b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010643d:	74 29                	je     80106468 <mappages+0x68>
      break;
    a += PGSIZE;
8010643f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106445:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106448:	b9 01 00 00 00       	mov    $0x1,%ecx
8010644d:	89 da                	mov    %ebx,%edx
8010644f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106452:	e8 19 ff ff ff       	call   80106370 <walkpgdir>
80106457:	85 c0                	test   %eax,%eax
80106459:	75 d5                	jne    80106430 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010645b:	83 c4 1c             	add    $0x1c,%esp
      return -1;
8010645e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106463:	5b                   	pop    %ebx
80106464:	5e                   	pop    %esi
80106465:	5f                   	pop    %edi
80106466:	5d                   	pop    %ebp
80106467:	c3                   	ret    
80106468:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010646b:	31 c0                	xor    %eax,%eax
}
8010646d:	5b                   	pop    %ebx
8010646e:	5e                   	pop    %esi
8010646f:	5f                   	pop    %edi
80106470:	5d                   	pop    %ebp
80106471:	c3                   	ret    
      panic("remap");
80106472:	c7 04 24 48 75 10 80 	movl   $0x80107548,(%esp)
80106479:	e8 e2 9e ff ff       	call   80100360 <panic>
8010647e:	66 90                	xchg   %ax,%ax

80106480 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	57                   	push   %edi
80106484:	89 c7                	mov    %eax,%edi
80106486:	56                   	push   %esi
80106487:	89 d6                	mov    %edx,%esi
80106489:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010648a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106490:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106493:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106499:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010649b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010649e:	72 3b                	jb     801064db <deallocuvm.part.0+0x5b>
801064a0:	eb 5e                	jmp    80106500 <deallocuvm.part.0+0x80>
801064a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801064a8:	8b 10                	mov    (%eax),%edx
801064aa:	f6 c2 01             	test   $0x1,%dl
801064ad:	74 22                	je     801064d1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801064af:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801064b5:	74 54                	je     8010650b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801064b7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801064bd:	89 14 24             	mov    %edx,(%esp)
801064c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801064c3:	e8 e8 be ff ff       	call   801023b0 <kfree>
      *pte = 0;
801064c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801064d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064d7:	39 f3                	cmp    %esi,%ebx
801064d9:	73 25                	jae    80106500 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
801064db:	31 c9                	xor    %ecx,%ecx
801064dd:	89 da                	mov    %ebx,%edx
801064df:	89 f8                	mov    %edi,%eax
801064e1:	e8 8a fe ff ff       	call   80106370 <walkpgdir>
    if(!pte)
801064e6:	85 c0                	test   %eax,%eax
801064e8:	75 be                	jne    801064a8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801064ea:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801064f0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801064f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801064fc:	39 f3                	cmp    %esi,%ebx
801064fe:	72 db                	jb     801064db <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106500:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106503:	83 c4 1c             	add    $0x1c,%esp
80106506:	5b                   	pop    %ebx
80106507:	5e                   	pop    %esi
80106508:	5f                   	pop    %edi
80106509:	5d                   	pop    %ebp
8010650a:	c3                   	ret    
        panic("kfree");
8010650b:	c7 04 24 e6 6e 10 80 	movl   $0x80106ee6,(%esp)
80106512:	e8 49 9e ff ff       	call   80100360 <panic>
80106517:	89 f6                	mov    %esi,%esi
80106519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106520 <seginit>:
{
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106526:	e8 15 d2 ff ff       	call   80103740 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010652b:	31 c9                	xor    %ecx,%ecx
8010652d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106532:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106538:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010653d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106541:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106546:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106549:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010654d:	31 c9                	xor    %ecx,%ecx
8010654f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106553:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106558:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010655c:	31 c9                	xor    %ecx,%ecx
8010655e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106562:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106567:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010656b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010656d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106571:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106575:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106579:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010657d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106581:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106585:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106589:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010658d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106591:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106596:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010659a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010659e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801065a2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065a6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801065aa:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065ae:	66 89 48 22          	mov    %cx,0x22(%eax)
801065b2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801065b6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801065ba:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801065be:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801065c2:	c1 e8 10             	shr    $0x10,%eax
801065c5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801065c9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801065cc:	0f 01 10             	lgdtl  (%eax)
}
801065cf:	c9                   	leave  
801065d0:	c3                   	ret    
801065d1:	eb 0d                	jmp    801065e0 <switchkvm>
801065d3:	90                   	nop
801065d4:	90                   	nop
801065d5:	90                   	nop
801065d6:	90                   	nop
801065d7:	90                   	nop
801065d8:	90                   	nop
801065d9:	90                   	nop
801065da:	90                   	nop
801065db:	90                   	nop
801065dc:	90                   	nop
801065dd:	90                   	nop
801065de:	90                   	nop
801065df:	90                   	nop

801065e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065e0:	a1 a4 54 11 80       	mov    0x801154a4,%eax
{
801065e5:	55                   	push   %ebp
801065e6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065e8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801065ed:	0f 22 d8             	mov    %eax,%cr3
}
801065f0:	5d                   	pop    %ebp
801065f1:	c3                   	ret    
801065f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106600 <switchuvm>:
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	56                   	push   %esi
80106605:	53                   	push   %ebx
80106606:	83 ec 1c             	sub    $0x1c,%esp
80106609:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010660c:	85 f6                	test   %esi,%esi
8010660e:	0f 84 cd 00 00 00    	je     801066e1 <switchuvm+0xe1>
  if(p->kstack == 0)
80106614:	8b 46 08             	mov    0x8(%esi),%eax
80106617:	85 c0                	test   %eax,%eax
80106619:	0f 84 da 00 00 00    	je     801066f9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010661f:	8b 7e 04             	mov    0x4(%esi),%edi
80106622:	85 ff                	test   %edi,%edi
80106624:	0f 84 c3 00 00 00    	je     801066ed <switchuvm+0xed>
  pushcli();
8010662a:	e8 91 db ff ff       	call   801041c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010662f:	e8 8c d0 ff ff       	call   801036c0 <mycpu>
80106634:	89 c3                	mov    %eax,%ebx
80106636:	e8 85 d0 ff ff       	call   801036c0 <mycpu>
8010663b:	89 c7                	mov    %eax,%edi
8010663d:	e8 7e d0 ff ff       	call   801036c0 <mycpu>
80106642:	83 c7 08             	add    $0x8,%edi
80106645:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106648:	e8 73 d0 ff ff       	call   801036c0 <mycpu>
8010664d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106650:	ba 67 00 00 00       	mov    $0x67,%edx
80106655:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010665c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106663:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010666a:	83 c1 08             	add    $0x8,%ecx
8010666d:	c1 e9 10             	shr    $0x10,%ecx
80106670:	83 c0 08             	add    $0x8,%eax
80106673:	c1 e8 18             	shr    $0x18,%eax
80106676:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010667c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106683:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106689:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010668e:	e8 2d d0 ff ff       	call   801036c0 <mycpu>
80106693:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010669a:	e8 21 d0 ff ff       	call   801036c0 <mycpu>
8010669f:	b9 10 00 00 00       	mov    $0x10,%ecx
801066a4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801066a8:	e8 13 d0 ff ff       	call   801036c0 <mycpu>
801066ad:	8b 56 08             	mov    0x8(%esi),%edx
801066b0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801066b6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801066b9:	e8 02 d0 ff ff       	call   801036c0 <mycpu>
801066be:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801066c2:	b8 28 00 00 00       	mov    $0x28,%eax
801066c7:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801066ca:	8b 46 04             	mov    0x4(%esi),%eax
801066cd:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801066d2:	0f 22 d8             	mov    %eax,%cr3
}
801066d5:	83 c4 1c             	add    $0x1c,%esp
801066d8:	5b                   	pop    %ebx
801066d9:	5e                   	pop    %esi
801066da:	5f                   	pop    %edi
801066db:	5d                   	pop    %ebp
  popcli();
801066dc:	e9 9f db ff ff       	jmp    80104280 <popcli>
    panic("switchuvm: no process");
801066e1:	c7 04 24 4e 75 10 80 	movl   $0x8010754e,(%esp)
801066e8:	e8 73 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
801066ed:	c7 04 24 79 75 10 80 	movl   $0x80107579,(%esp)
801066f4:	e8 67 9c ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
801066f9:	c7 04 24 64 75 10 80 	movl   $0x80107564,(%esp)
80106700:	e8 5b 9c ff ff       	call   80100360 <panic>
80106705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106710 <inituvm>:
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	57                   	push   %edi
80106714:	56                   	push   %esi
80106715:	53                   	push   %ebx
80106716:	83 ec 1c             	sub    $0x1c,%esp
80106719:	8b 75 10             	mov    0x10(%ebp),%esi
8010671c:	8b 45 08             	mov    0x8(%ebp),%eax
8010671f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106722:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010672b:	77 54                	ja     80106781 <inituvm+0x71>
  mem = kalloc();
8010672d:	e8 2e be ff ff       	call   80102560 <kalloc>
  memset(mem, 0, PGSIZE);
80106732:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106739:	00 
8010673a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106741:	00 
  mem = kalloc();
80106742:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106744:	89 04 24             	mov    %eax,(%esp)
80106747:	e8 f4 db ff ff       	call   80104340 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010674c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106752:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106757:	89 04 24             	mov    %eax,(%esp)
8010675a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010675d:	31 d2                	xor    %edx,%edx
8010675f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106766:	00 
80106767:	e8 94 fc ff ff       	call   80106400 <mappages>
  memmove(mem, init, sz);
8010676c:	89 75 10             	mov    %esi,0x10(%ebp)
8010676f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106772:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106775:	83 c4 1c             	add    $0x1c,%esp
80106778:	5b                   	pop    %ebx
80106779:	5e                   	pop    %esi
8010677a:	5f                   	pop    %edi
8010677b:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010677c:	e9 5f dc ff ff       	jmp    801043e0 <memmove>
    panic("inituvm: more than a page");
80106781:	c7 04 24 8d 75 10 80 	movl   $0x8010758d,(%esp)
80106788:	e8 d3 9b ff ff       	call   80100360 <panic>
8010678d:	8d 76 00             	lea    0x0(%esi),%esi

80106790 <loaduvm>:
{
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	57                   	push   %edi
80106794:	56                   	push   %esi
80106795:	53                   	push   %ebx
80106796:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106799:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801067a0:	0f 85 98 00 00 00    	jne    8010683e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
801067a6:	8b 75 18             	mov    0x18(%ebp),%esi
801067a9:	31 db                	xor    %ebx,%ebx
801067ab:	85 f6                	test   %esi,%esi
801067ad:	75 1a                	jne    801067c9 <loaduvm+0x39>
801067af:	eb 77                	jmp    80106828 <loaduvm+0x98>
801067b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067be:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801067c4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801067c7:	76 5f                	jbe    80106828 <loaduvm+0x98>
801067c9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801067cc:	31 c9                	xor    %ecx,%ecx
801067ce:	8b 45 08             	mov    0x8(%ebp),%eax
801067d1:	01 da                	add    %ebx,%edx
801067d3:	e8 98 fb ff ff       	call   80106370 <walkpgdir>
801067d8:	85 c0                	test   %eax,%eax
801067da:	74 56                	je     80106832 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
801067dc:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
801067de:	bf 00 10 00 00       	mov    $0x1000,%edi
801067e3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
801067e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
801067eb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801067f1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801067f4:	05 00 00 00 80       	add    $0x80000000,%eax
801067f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801067fd:	8b 45 10             	mov    0x10(%ebp),%eax
80106800:	01 d9                	add    %ebx,%ecx
80106802:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106806:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010680a:	89 04 24             	mov    %eax,(%esp)
8010680d:	e8 0e b2 ff ff       	call   80101a20 <readi>
80106812:	39 f8                	cmp    %edi,%eax
80106814:	74 a2                	je     801067b8 <loaduvm+0x28>
}
80106816:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010681e:	5b                   	pop    %ebx
8010681f:	5e                   	pop    %esi
80106820:	5f                   	pop    %edi
80106821:	5d                   	pop    %ebp
80106822:	c3                   	ret    
80106823:	90                   	nop
80106824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106828:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010682b:	31 c0                	xor    %eax,%eax
}
8010682d:	5b                   	pop    %ebx
8010682e:	5e                   	pop    %esi
8010682f:	5f                   	pop    %edi
80106830:	5d                   	pop    %ebp
80106831:	c3                   	ret    
      panic("loaduvm: address should exist");
80106832:	c7 04 24 a7 75 10 80 	movl   $0x801075a7,(%esp)
80106839:	e8 22 9b ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
8010683e:	c7 04 24 48 76 10 80 	movl   $0x80107648,(%esp)
80106845:	e8 16 9b ff ff       	call   80100360 <panic>
8010684a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106850 <allocuvm>:
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	57                   	push   %edi
80106854:	56                   	push   %esi
80106855:	53                   	push   %ebx
80106856:	83 ec 1c             	sub    $0x1c,%esp
80106859:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010685c:	85 ff                	test   %edi,%edi
8010685e:	0f 88 7e 00 00 00    	js     801068e2 <allocuvm+0x92>
  if(newsz < oldsz)
80106864:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106867:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010686a:	72 78                	jb     801068e4 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
8010686c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106872:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106878:	39 df                	cmp    %ebx,%edi
8010687a:	77 4a                	ja     801068c6 <allocuvm+0x76>
8010687c:	eb 72                	jmp    801068f0 <allocuvm+0xa0>
8010687e:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
80106880:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106887:	00 
80106888:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010688f:	00 
80106890:	89 04 24             	mov    %eax,(%esp)
80106893:	e8 a8 da ff ff       	call   80104340 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106898:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010689e:	b9 00 10 00 00       	mov    $0x1000,%ecx
801068a3:	89 04 24             	mov    %eax,(%esp)
801068a6:	8b 45 08             	mov    0x8(%ebp),%eax
801068a9:	89 da                	mov    %ebx,%edx
801068ab:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801068b2:	00 
801068b3:	e8 48 fb ff ff       	call   80106400 <mappages>
801068b8:	85 c0                	test   %eax,%eax
801068ba:	78 44                	js     80106900 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
801068bc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068c2:	39 df                	cmp    %ebx,%edi
801068c4:	76 2a                	jbe    801068f0 <allocuvm+0xa0>
    mem = kalloc();
801068c6:	e8 95 bc ff ff       	call   80102560 <kalloc>
    if(mem == 0){
801068cb:	85 c0                	test   %eax,%eax
    mem = kalloc();
801068cd:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801068cf:	75 af                	jne    80106880 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
801068d1:	c7 04 24 c5 75 10 80 	movl   $0x801075c5,(%esp)
801068d8:	e8 73 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801068dd:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801068e0:	77 48                	ja     8010692a <allocuvm+0xda>
      return 0;
801068e2:	31 c0                	xor    %eax,%eax
}
801068e4:	83 c4 1c             	add    $0x1c,%esp
801068e7:	5b                   	pop    %ebx
801068e8:	5e                   	pop    %esi
801068e9:	5f                   	pop    %edi
801068ea:	5d                   	pop    %ebp
801068eb:	c3                   	ret    
801068ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068f0:	83 c4 1c             	add    $0x1c,%esp
801068f3:	89 f8                	mov    %edi,%eax
801068f5:	5b                   	pop    %ebx
801068f6:	5e                   	pop    %esi
801068f7:	5f                   	pop    %edi
801068f8:	5d                   	pop    %ebp
801068f9:	c3                   	ret    
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106900:	c7 04 24 dd 75 10 80 	movl   $0x801075dd,(%esp)
80106907:	e8 44 9d ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010690c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010690f:	76 0d                	jbe    8010691e <allocuvm+0xce>
80106911:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106914:	89 fa                	mov    %edi,%edx
80106916:	8b 45 08             	mov    0x8(%ebp),%eax
80106919:	e8 62 fb ff ff       	call   80106480 <deallocuvm.part.0>
      kfree(mem);
8010691e:	89 34 24             	mov    %esi,(%esp)
80106921:	e8 8a ba ff ff       	call   801023b0 <kfree>
      return 0;
80106926:	31 c0                	xor    %eax,%eax
80106928:	eb ba                	jmp    801068e4 <allocuvm+0x94>
8010692a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010692d:	89 fa                	mov    %edi,%edx
8010692f:	8b 45 08             	mov    0x8(%ebp),%eax
80106932:	e8 49 fb ff ff       	call   80106480 <deallocuvm.part.0>
      return 0;
80106937:	31 c0                	xor    %eax,%eax
80106939:	eb a9                	jmp    801068e4 <allocuvm+0x94>
8010693b:	90                   	nop
8010693c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106940 <deallocuvm>:
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	8b 55 0c             	mov    0xc(%ebp),%edx
80106946:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106949:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010694c:	39 d1                	cmp    %edx,%ecx
8010694e:	73 08                	jae    80106958 <deallocuvm+0x18>
}
80106950:	5d                   	pop    %ebp
80106951:	e9 2a fb ff ff       	jmp    80106480 <deallocuvm.part.0>
80106956:	66 90                	xchg   %ax,%ax
80106958:	89 d0                	mov    %edx,%eax
8010695a:	5d                   	pop    %ebp
8010695b:	c3                   	ret    
8010695c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106960 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	56                   	push   %esi
80106964:	53                   	push   %ebx
80106965:	83 ec 10             	sub    $0x10,%esp
80106968:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010696b:	85 f6                	test   %esi,%esi
8010696d:	74 59                	je     801069c8 <freevm+0x68>
8010696f:	31 c9                	xor    %ecx,%ecx
80106971:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106976:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106978:	31 db                	xor    %ebx,%ebx
8010697a:	e8 01 fb ff ff       	call   80106480 <deallocuvm.part.0>
8010697f:	eb 12                	jmp    80106993 <freevm+0x33>
80106981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106988:	83 c3 01             	add    $0x1,%ebx
8010698b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106991:	74 27                	je     801069ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106993:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106996:	f6 c2 01             	test   $0x1,%dl
80106999:	74 ed                	je     80106988 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010699b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
801069a1:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801069a4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801069aa:	89 14 24             	mov    %edx,(%esp)
801069ad:	e8 fe b9 ff ff       	call   801023b0 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
801069b2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801069b8:	75 d9                	jne    80106993 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
801069ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801069bd:	83 c4 10             	add    $0x10,%esp
801069c0:	5b                   	pop    %ebx
801069c1:	5e                   	pop    %esi
801069c2:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801069c3:	e9 e8 b9 ff ff       	jmp    801023b0 <kfree>
    panic("freevm: no pgdir");
801069c8:	c7 04 24 f9 75 10 80 	movl   $0x801075f9,(%esp)
801069cf:	e8 8c 99 ff ff       	call   80100360 <panic>
801069d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801069e0 <setupkvm>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	56                   	push   %esi
801069e4:	53                   	push   %ebx
801069e5:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
801069e8:	e8 73 bb ff ff       	call   80102560 <kalloc>
801069ed:	85 c0                	test   %eax,%eax
801069ef:	89 c6                	mov    %eax,%esi
801069f1:	74 6d                	je     80106a60 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
801069f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069fa:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801069fb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106a00:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a07:	00 
80106a08:	89 04 24             	mov    %eax,(%esp)
80106a0b:	e8 30 d9 ff ff       	call   80104340 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106a10:	8b 53 0c             	mov    0xc(%ebx),%edx
80106a13:	8b 43 04             	mov    0x4(%ebx),%eax
80106a16:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106a19:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a1d:	8b 13                	mov    (%ebx),%edx
80106a1f:	89 04 24             	mov    %eax,(%esp)
80106a22:	29 c1                	sub    %eax,%ecx
80106a24:	89 f0                	mov    %esi,%eax
80106a26:	e8 d5 f9 ff ff       	call   80106400 <mappages>
80106a2b:	85 c0                	test   %eax,%eax
80106a2d:	78 19                	js     80106a48 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a2f:	83 c3 10             	add    $0x10,%ebx
80106a32:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106a38:	72 d6                	jb     80106a10 <setupkvm+0x30>
80106a3a:	89 f0                	mov    %esi,%eax
}
80106a3c:	83 c4 10             	add    $0x10,%esp
80106a3f:	5b                   	pop    %ebx
80106a40:	5e                   	pop    %esi
80106a41:	5d                   	pop    %ebp
80106a42:	c3                   	ret    
80106a43:	90                   	nop
80106a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106a48:	89 34 24             	mov    %esi,(%esp)
80106a4b:	e8 10 ff ff ff       	call   80106960 <freevm>
}
80106a50:	83 c4 10             	add    $0x10,%esp
      return 0;
80106a53:	31 c0                	xor    %eax,%eax
}
80106a55:	5b                   	pop    %ebx
80106a56:	5e                   	pop    %esi
80106a57:	5d                   	pop    %ebp
80106a58:	c3                   	ret    
80106a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106a60:	31 c0                	xor    %eax,%eax
80106a62:	eb d8                	jmp    80106a3c <setupkvm+0x5c>
80106a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a70 <kvmalloc>:
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106a76:	e8 65 ff ff ff       	call   801069e0 <setupkvm>
80106a7b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a80:	05 00 00 00 80       	add    $0x80000000,%eax
80106a85:	0f 22 d8             	mov    %eax,%cr3
}
80106a88:	c9                   	leave  
80106a89:	c3                   	ret    
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106a90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106a91:	31 c9                	xor    %ecx,%ecx
{
80106a93:	89 e5                	mov    %esp,%ebp
80106a95:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106a98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a9e:	e8 cd f8 ff ff       	call   80106370 <walkpgdir>
  if(pte == 0)
80106aa3:	85 c0                	test   %eax,%eax
80106aa5:	74 05                	je     80106aac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106aa7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106aaa:	c9                   	leave  
80106aab:	c3                   	ret    
    panic("clearpteu");
80106aac:	c7 04 24 0a 76 10 80 	movl   $0x8010760a,(%esp)
80106ab3:	e8 a8 98 ff ff       	call   80100360 <panic>
80106ab8:	90                   	nop
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
80106ac6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ac9:	e8 12 ff ff ff       	call   801069e0 <setupkvm>
80106ace:	85 c0                	test   %eax,%eax
80106ad0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ad3:	0f 84 b2 00 00 00    	je     80106b8b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106adc:	85 c0                	test   %eax,%eax
80106ade:	0f 84 9c 00 00 00    	je     80106b80 <copyuvm+0xc0>
80106ae4:	31 db                	xor    %ebx,%ebx
80106ae6:	eb 48                	jmp    80106b30 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ae8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106aee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106af5:	00 
80106af6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106afa:	89 04 24             	mov    %eax,(%esp)
80106afd:	e8 de d8 ff ff       	call   801043e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b05:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106b0b:	89 14 24             	mov    %edx,(%esp)
80106b0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b13:	89 da                	mov    %ebx,%edx
80106b15:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b1c:	e8 df f8 ff ff       	call   80106400 <mappages>
80106b21:	85 c0                	test   %eax,%eax
80106b23:	78 41                	js     80106b66 <copyuvm+0xa6>
  for(i = 0; i < sz; i += PGSIZE){
80106b25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b2b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106b2e:	76 50                	jbe    80106b80 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106b30:	8b 45 08             	mov    0x8(%ebp),%eax
80106b33:	31 c9                	xor    %ecx,%ecx
80106b35:	89 da                	mov    %ebx,%edx
80106b37:	e8 34 f8 ff ff       	call   80106370 <walkpgdir>
80106b3c:	85 c0                	test   %eax,%eax
80106b3e:	74 5b                	je     80106b9b <copyuvm+0xdb>
    if(!(*pte & PTE_P))
80106b40:	8b 30                	mov    (%eax),%esi
80106b42:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106b48:	74 45                	je     80106b8f <copyuvm+0xcf>
    pa = PTE_ADDR(*pte);
80106b4a:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106b4c:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106b52:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106b55:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106b5b:	e8 00 ba ff ff       	call   80102560 <kalloc>
80106b60:	85 c0                	test   %eax,%eax
80106b62:	89 c6                	mov    %eax,%esi
80106b64:	75 82                	jne    80106ae8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106b66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b69:	89 04 24             	mov    %eax,(%esp)
80106b6c:	e8 ef fd ff ff       	call   80106960 <freevm>
  return 0;
80106b71:	31 c0                	xor    %eax,%eax
}
80106b73:	83 c4 2c             	add    $0x2c,%esp
80106b76:	5b                   	pop    %ebx
80106b77:	5e                   	pop    %esi
80106b78:	5f                   	pop    %edi
80106b79:	5d                   	pop    %ebp
80106b7a:	c3                   	ret    
80106b7b:	90                   	nop
80106b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b83:	83 c4 2c             	add    $0x2c,%esp
80106b86:	5b                   	pop    %ebx
80106b87:	5e                   	pop    %esi
80106b88:	5f                   	pop    %edi
80106b89:	5d                   	pop    %ebp
80106b8a:	c3                   	ret    
    return 0;
80106b8b:	31 c0                	xor    %eax,%eax
80106b8d:	eb e4                	jmp    80106b73 <copyuvm+0xb3>
      panic("copyuvm: page not present");
80106b8f:	c7 04 24 2e 76 10 80 	movl   $0x8010762e,(%esp)
80106b96:	e8 c5 97 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106b9b:	c7 04 24 14 76 10 80 	movl   $0x80107614,(%esp)
80106ba2:	e8 b9 97 ff ff       	call   80100360 <panic>
80106ba7:	89 f6                	mov    %esi,%esi
80106ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106bb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106bb1:	31 c9                	xor    %ecx,%ecx
{
80106bb3:	89 e5                	mov    %esp,%ebp
80106bb5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80106bbe:	e8 ad f7 ff ff       	call   80106370 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106bc3:	8b 00                	mov    (%eax),%eax
80106bc5:	89 c2                	mov    %eax,%edx
80106bc7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106bca:	83 fa 05             	cmp    $0x5,%edx
80106bcd:	75 11                	jne    80106be0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106bcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bd4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106bd9:	c9                   	leave  
80106bda:	c3                   	ret    
80106bdb:	90                   	nop
80106bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106be0:	31 c0                	xor    %eax,%eax
}
80106be2:	c9                   	leave  
80106be3:	c3                   	ret    
80106be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106bf0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 1c             	sub    $0x1c,%esp
80106bf9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106c02:	85 db                	test   %ebx,%ebx
80106c04:	75 3a                	jne    80106c40 <copyout+0x50>
80106c06:	eb 68                	jmp    80106c70 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106c08:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c0b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106c0d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106c11:	29 ca                	sub    %ecx,%edx
80106c13:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106c19:	39 da                	cmp    %ebx,%edx
80106c1b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106c1e:	29 f1                	sub    %esi,%ecx
80106c20:	01 c8                	add    %ecx,%eax
80106c22:	89 54 24 08          	mov    %edx,0x8(%esp)
80106c26:	89 04 24             	mov    %eax,(%esp)
80106c29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106c2c:	e8 af d7 ff ff       	call   801043e0 <memmove>
    len -= n;
    buf += n;
80106c31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106c34:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106c3a:	01 d7                	add    %edx,%edi
  while(len > 0){
80106c3c:	29 d3                	sub    %edx,%ebx
80106c3e:	74 30                	je     80106c70 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106c40:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106c43:	89 ce                	mov    %ecx,%esi
80106c45:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106c4b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106c4f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106c52:	89 04 24             	mov    %eax,(%esp)
80106c55:	e8 56 ff ff ff       	call   80106bb0 <uva2ka>
    if(pa0 == 0)
80106c5a:	85 c0                	test   %eax,%eax
80106c5c:	75 aa                	jne    80106c08 <copyout+0x18>
  }
  return 0;
}
80106c5e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106c61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c66:	5b                   	pop    %ebx
80106c67:	5e                   	pop    %esi
80106c68:	5f                   	pop    %edi
80106c69:	5d                   	pop    %ebp
80106c6a:	c3                   	ret    
80106c6b:	90                   	nop
80106c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c70:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106c73:	31 c0                	xor    %eax,%eax
}
80106c75:	5b                   	pop    %ebx
80106c76:	5e                   	pop    %esi
80106c77:	5f                   	pop    %edi
80106c78:	5d                   	pop    %ebp
80106c79:	c3                   	ret    
