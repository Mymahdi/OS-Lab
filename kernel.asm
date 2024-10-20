
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 38 10 80       	mov    $0x801038c0,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 60 79 10 80       	push   $0x80107960
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 01 4c 00 00       	call   80104c60 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 79 10 80       	push   $0x80107967
80100097:	50                   	push   %eax
80100098:	e8 83 4a 00 00       	call   80104b20 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 f3 4c 00 00       	call   80104de0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 39 4d 00 00       	call   80104ea0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 49 00 00       	call   80104b60 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 6f 29 00 00       	call   80102b00 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 6e 79 10 80       	push   $0x8010796e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 39 4a 00 00       	call   80104c00 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 23 29 00 00       	jmp    80102b00 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 7f 79 10 80       	push   $0x8010797f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 f8 49 00 00       	call   80104c00 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 a8 49 00 00       	call   80104bc0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 bc 4b 00 00       	call   80104de0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 2b 4c 00 00       	jmp    80104ea0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 86 79 10 80       	push   $0x80107986
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
    procdump(); // now call procdump() wo. cons.lock held
  }
}

int consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 16 1e 00 00       	call   801020c0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 2a 4b 00 00       	call   80104de0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while (n > 0)
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while (n > 0)
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while (input.r == input.w)
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 b6 44 00 00       	call   801047a0 <sleep>
    while (input.r == input.w)
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if (myproc()->killed)
801002fa:	e8 e1 3e 00 00       	call   801041e0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 8d 4b 00 00       	call   80104ea0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 c4 1c 00 00       	call   80101fe0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if (c == C('D'))
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if (c == END_OF_LINE)
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 36 4b 00 00       	call   80104ea0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 6d 1c 00 00       	call   80101fe0 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if (n < target)
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 6e 2d 00 00       	call   80103120 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 8d 79 10 80       	push   $0x8010798d
801003bb:	e8 90 05 00 00       	call   80100950 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 87 05 00 00       	call   80100950 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 b7 82 10 80 	movl   $0x801082b7,(%esp)
801003d0:	e8 7b 05 00 00       	call   80100950 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 9f 48 00 00       	call   80104c80 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 a1 79 10 80       	push   $0x801079a1
801003f1:	e8 5a 05 00 00       	call   80100950 <cprintf>
  for (i = 0; i < 10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for (;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
void consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	89 c6                	mov    %eax,%esi
80100417:	53                   	push   %ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if (c == BACKSPACE)
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 5a 01 00 00    	je     80100580 <consputc.part.0+0x170>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 31 61 00 00       	call   80106560 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 da                	mov    %ebx,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT + 1) << 8;
80100447:	0f b6 f8             	movzbl %al,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 da                	mov    %ebx,%edx
8010044c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100451:	c1 e7 08             	shl    $0x8,%edi
80100454:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100455:	89 ca                	mov    %ecx,%edx
80100457:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100458:	0f b6 d8             	movzbl %al,%ebx
8010045b:	09 fb                	or     %edi,%ebx
  if (c == END_OF_LINE)
8010045d:	83 fe 0a             	cmp    $0xa,%esi
80100460:	0f 84 9a 00 00 00    	je     80100500 <consputc.part.0+0xf0>
  else if (c == BACKSPACE)
80100466:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010046c:	74 72                	je     801004e0 <consputc.part.0+0xd0>
  else if (c == CURSORBACK)
8010046e:	81 fe 01 01 00 00    	cmp    $0x101,%esi
80100474:	0f 84 b6 01 00 00    	je     80100630 <consputc.part.0+0x220>
  else if (c == CURSORFORWARD)
8010047a:	81 fe 04 01 00 00    	cmp    $0x104,%esi
80100480:	0f 84 9a 01 00 00    	je     80100620 <consputc.part.0+0x210>
  else if (c == SHIFTRIGHT)
80100486:	81 fe 02 01 00 00    	cmp    $0x102,%esi
8010048c:	0f 84 de 01 00 00    	je     80100670 <consputc.part.0+0x260>
  else if (c == SHIFTLEFT)
80100492:	81 fe 03 01 00 00    	cmp    $0x103,%esi
80100498:	0f 84 12 02 00 00    	je     801006b0 <consputc.part.0+0x2a0>
  else if (c == CURSORRESET)
8010049e:	81 fe 05 01 00 00    	cmp    $0x105,%esi
801004a4:	0f 84 5e 02 00 00    	je     80100708 <consputc.part.0+0x2f8>
  else if (c == CLEAR)
801004aa:	81 fe 06 01 00 00    	cmp    $0x106,%esi
801004b0:	0f 84 8a 01 00 00    	je     80100640 <consputc.part.0+0x230>
  else if (c == ARROW_UP || c == ARROW_DOWN)
801004b6:	8d 86 1e ff ff ff    	lea    -0xe2(%esi),%eax
801004bc:	89 d9                	mov    %ebx,%ecx
801004be:	83 f8 01             	cmp    $0x1,%eax
801004c1:	0f 86 c1 02 00 00    	jbe    80100788 <consputc.part.0+0x378>
    crt[pos++] = (c & 0xff) | 0x0700; // black on white
801004c7:	89 f0                	mov    %esi,%eax
801004c9:	83 c3 01             	add    $0x1,%ebx
801004cc:	0f b6 f0             	movzbl %al,%esi
801004cf:	66 81 ce 00 07       	or     $0x700,%si
801004d4:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
801004db:	80 
801004dc:	89 d9                	mov    %ebx,%ecx
801004de:	eb 37                	jmp    80100517 <consputc.part.0+0x107>
    if (pos > 0)
801004e0:	85 db                	test   %ebx,%ebx
801004e2:	0f 84 18 01 00 00    	je     80100600 <consputc.part.0+0x1f0>
      --pos;
801004e8:	83 eb 01             	sub    $0x1,%ebx
    crt[pos] = ' ' | 0x0700;
801004eb:	be 20 07 00 00       	mov    $0x720,%esi
801004f0:	66 89 b4 1b 00 80 0b 	mov    %si,-0x7ff48000(%ebx,%ebx,1)
801004f7:	80 
801004f8:	89 d9                	mov    %ebx,%ecx
801004fa:	eb 1b                	jmp    80100517 <consputc.part.0+0x107>
801004fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos % 80;
80100500:	89 d8                	mov    %ebx,%eax
80100502:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100507:	f7 e2                	mul    %edx
80100509:	c1 ea 06             	shr    $0x6,%edx
8010050c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010050f:	c1 e0 04             	shl    $0x4,%eax
80100512:	8d 58 50             	lea    0x50(%eax),%ebx
80100515:	89 d9                	mov    %ebx,%ecx
  if (pos < 0 || pos > 25 * 80)
80100517:	81 f9 d0 07 00 00    	cmp    $0x7d0,%ecx
8010051d:	0f 87 05 03 00 00    	ja     80100828 <consputc.part.0+0x418>
  if ((pos / 80) >= 24)
80100523:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100529:	0f 8f 81 00 00 00    	jg     801005b0 <consputc.part.0+0x1a0>
8010052f:	88 5d e7             	mov    %bl,-0x19(%ebp)
80100532:	0f b6 ff             	movzbl %bh,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100535:	be d4 03 00 00       	mov    $0x3d4,%esi
8010053a:	b8 0e 00 00 00       	mov    $0xe,%eax
8010053f:	89 f2                	mov    %esi,%edx
80100541:	ee                   	out    %al,(%dx)
80100542:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100547:	89 f8                	mov    %edi,%eax
80100549:	89 ca                	mov    %ecx,%edx
8010054b:	ee                   	out    %al,(%dx)
8010054c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100551:	89 f2                	mov    %esi,%edx
80100553:	ee                   	out    %al,(%dx)
80100554:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80100558:	89 ca                	mov    %ecx,%edx
8010055a:	ee                   	out    %al,(%dx)
  if (input.e == input.pointer /*|| c ==CONTROLL*/)
8010055b:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
80100560:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100566:	75 0d                	jne    80100575 <consputc.part.0+0x165>
    crt[pos] = ' ' | 0x0700;
80100568:	b8 20 07 00 00       	mov    $0x720,%eax
8010056d:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100574:	80 
}
80100575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100578:	5b                   	pop    %ebx
80100579:	5e                   	pop    %esi
8010057a:	5f                   	pop    %edi
8010057b:	5d                   	pop    %ebp
8010057c:	c3                   	ret    
8010057d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc('\b');
80100580:	83 ec 0c             	sub    $0xc,%esp
80100583:	6a 08                	push   $0x8
80100585:	e8 d6 5f 00 00       	call   80106560 <uartputc>
    uartputc(' ');
8010058a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100591:	e8 ca 5f 00 00       	call   80106560 <uartputc>
    uartputc('\b');
80100596:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010059d:	e8 be 5f 00 00       	call   80106560 <uartputc>
801005a2:	83 c4 10             	add    $0x10,%esp
801005a5:	e9 88 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
801005aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
801005b0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801005b3:	83 eb 50             	sub    $0x50,%ebx
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
801005b6:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
801005bb:	68 60 0e 00 00       	push   $0xe60
801005c0:	68 a0 80 0b 80       	push   $0x800b80a0
801005c5:	68 00 80 0b 80       	push   $0x800b8000
801005ca:	e8 c1 49 00 00       	call   80104f90 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
801005cf:	b8 80 07 00 00       	mov    $0x780,%eax
801005d4:	83 c4 0c             	add    $0xc,%esp
801005d7:	29 d8                	sub    %ebx,%eax
801005d9:	01 c0                	add    %eax,%eax
801005db:	50                   	push   %eax
801005dc:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005e3:	6a 00                	push   $0x0
801005e5:	50                   	push   %eax
801005e6:	e8 05 49 00 00       	call   80104ef0 <memset>
801005eb:	88 5d e7             	mov    %bl,-0x19(%ebp)
801005ee:	83 c4 10             	add    $0x10,%esp
801005f1:	e9 3f ff ff ff       	jmp    80100535 <consputc.part.0+0x125>
801005f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005fd:	8d 76 00             	lea    0x0(%esi),%esi
    crt[pos] = ' ' | 0x0700;
80100600:	bf 20 07 00 00       	mov    $0x720,%edi
80100605:	66 89 3d 00 80 0b 80 	mov    %di,0x800b8000
8010060c:	31 ff                	xor    %edi,%edi
8010060e:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100612:	e9 1e ff ff ff       	jmp    80100535 <consputc.part.0+0x125>
80100617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010061e:	66 90                	xchg   %ax,%ax
    pos++;
80100620:	83 c3 01             	add    $0x1,%ebx
80100623:	89 d9                	mov    %ebx,%ecx
80100625:	e9 ed fe ff ff       	jmp    80100517 <consputc.part.0+0x107>
8010062a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (pos > 0)
80100630:	85 db                	test   %ebx,%ebx
80100632:	74 27                	je     8010065b <consputc.part.0+0x24b>
      --pos;
80100634:	83 eb 01             	sub    $0x1,%ebx
80100637:	89 d9                	mov    %ebx,%ecx
80100639:	e9 d9 fe ff ff       	jmp    80100517 <consputc.part.0+0x107>
8010063e:	66 90                	xchg   %ax,%ax
80100640:	b8 00 80 0b 80       	mov    $0x800b8000,%eax
80100645:	8d 76 00             	lea    0x0(%esi),%esi
      crt[i] = ' ' | 0x0700;
80100648:	bf 20 07 00 00       	mov    $0x720,%edi
8010064d:	83 c0 02             	add    $0x2,%eax
80100650:	66 89 78 fe          	mov    %di,-0x2(%eax)
    for (int i = 0; i <= CRTLEN; i++)
80100654:	3d a2 8f 0b 80       	cmp    $0x800b8fa2,%eax
80100659:	75 ed                	jne    80100648 <consputc.part.0+0x238>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
8010065b:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
8010065f:	31 ff                	xor    %edi,%edi
80100661:	31 db                	xor    %ebx,%ebx
80100663:	e9 cd fe ff ff       	jmp    80100535 <consputc.part.0+0x125>
80100668:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010066f:	90                   	nop
    for (int i = (pos + input.e - input.pointer); i > pos; i--)
80100670:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100675:	89 d9                	mov    %ebx,%ecx
80100677:	01 d8                	add    %ebx,%eax
80100679:	2b 05 ac 0f 11 80    	sub    0x80110fac,%eax
8010067f:	39 c3                	cmp    %eax,%ebx
80100681:	0f 8d 90 fe ff ff    	jge    80100517 <consputc.part.0+0x107>
80100687:	8d 84 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%eax
8010068e:	8d b4 1b fe 7f 0b 80 	lea    -0x7ff48002(%ebx,%ebx,1),%esi
80100695:	8d 76 00             	lea    0x0(%esi),%esi
      crt[i] = crt[i - 1];
80100698:	0f b7 10             	movzwl (%eax),%edx
8010069b:	83 e8 02             	sub    $0x2,%eax
8010069e:	66 89 50 04          	mov    %dx,0x4(%eax)
    for (int i = (pos + input.e - input.pointer); i > pos; i--)
801006a2:	39 c6                	cmp    %eax,%esi
801006a4:	75 f2                	jne    80100698 <consputc.part.0+0x288>
801006a6:	e9 6c fe ff ff       	jmp    80100517 <consputc.part.0+0x107>
801006ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop
    for (int i = pos - 1; i < (pos + input.e - input.pointer); i++)
801006b0:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801006b5:	8d 7b ff             	lea    -0x1(%ebx),%edi
801006b8:	89 f9                	mov    %edi,%ecx
801006ba:	01 d8                	add    %ebx,%eax
801006bc:	2b 05 ac 0f 11 80    	sub    0x80110fac,%eax
801006c2:	39 f8                	cmp    %edi,%eax
801006c4:	76 28                	jbe    801006ee <consputc.part.0+0x2de>
801006c6:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801006cd:	89 fe                	mov    %edi,%esi
801006cf:	90                   	nop
      crt[i] = crt[i + 1];
801006d0:	0f b7 02             	movzwl (%edx),%eax
    for (int i = pos - 1; i < (pos + input.e - input.pointer); i++)
801006d3:	83 c6 01             	add    $0x1,%esi
801006d6:	83 c2 02             	add    $0x2,%edx
      crt[i] = crt[i + 1];
801006d9:	66 89 42 fc          	mov    %ax,-0x4(%edx)
    for (int i = pos - 1; i < (pos + input.e - input.pointer); i++)
801006dd:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801006e2:	01 d8                	add    %ebx,%eax
801006e4:	2b 05 ac 0f 11 80    	sub    0x80110fac,%eax
801006ea:	39 f0                	cmp    %esi,%eax
801006ec:	77 e2                	ja     801006d0 <consputc.part.0+0x2c0>
    crt[pos + input.e - input.pointer] = ' ';
801006ee:	ba 20 00 00 00       	mov    $0x20,%edx
    pos--;
801006f3:	89 fb                	mov    %edi,%ebx
    crt[pos + input.e - input.pointer] = ' ';
801006f5:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
801006fc:	80 
    pos--;
801006fd:	e9 15 fe ff ff       	jmp    80100517 <consputc.part.0+0x107>
80100702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pos += input.e - input.pointer;
80100708:	8b 0d a8 0f 11 80    	mov    0x80110fa8,%ecx
    while (pos % 80 != 2)
8010070e:	ba 67 66 66 66       	mov    $0x66666667,%edx
    pos += input.e - input.pointer;
80100713:	01 d9                	add    %ebx,%ecx
80100715:	2b 0d ac 0f 11 80    	sub    0x80110fac,%ecx
    while (pos % 80 != 2)
8010071b:	89 c8                	mov    %ecx,%eax
8010071d:	89 cf                	mov    %ecx,%edi
    pos += input.e - input.pointer;
8010071f:	89 cb                	mov    %ecx,%ebx
    while (pos % 80 != 2)
80100721:	f7 ea                	imul   %edx
80100723:	89 c8                	mov    %ecx,%eax
80100725:	c1 f8 1f             	sar    $0x1f,%eax
80100728:	c1 fa 05             	sar    $0x5,%edx
8010072b:	29 c2                	sub    %eax,%edx
8010072d:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100730:	c1 e0 04             	shl    $0x4,%eax
80100733:	29 c7                	sub    %eax,%edi
80100735:	83 ff 02             	cmp    $0x2,%edi
80100738:	0f 84 d9 fd ff ff    	je     80100517 <consputc.part.0+0x107>
8010073e:	8d b4 09 fe 7f 0b 80 	lea    -0x7ff48002(%ecx,%ecx,1),%esi
80100745:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010074a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      crt[--pos] = ' ' | 0x0700;
80100750:	83 eb 01             	sub    $0x1,%ebx
80100753:	b8 20 07 00 00       	mov    $0x720,%eax
80100758:	83 ee 02             	sub    $0x2,%esi
8010075b:	66 89 46 02          	mov    %ax,0x2(%esi)
    while (pos % 80 != 2)
8010075f:	89 d8                	mov    %ebx,%eax
80100761:	89 d9                	mov    %ebx,%ecx
80100763:	f7 ef                	imul   %edi
80100765:	89 d8                	mov    %ebx,%eax
80100767:	c1 f8 1f             	sar    $0x1f,%eax
8010076a:	c1 fa 05             	sar    $0x5,%edx
8010076d:	29 c2                	sub    %eax,%edx
8010076f:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100772:	89 da                	mov    %ebx,%edx
80100774:	c1 e0 04             	shl    $0x4,%eax
80100777:	29 c2                	sub    %eax,%edx
80100779:	83 fa 02             	cmp    $0x2,%edx
8010077c:	75 d2                	jne    80100750 <consputc.part.0+0x340>
8010077e:	e9 94 fd ff ff       	jmp    80100517 <consputc.part.0+0x107>
80100783:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100787:	90                   	nop
    for (int i = (pos % 80); i > 2; i--)
80100788:	89 d8                	mov    %ebx,%eax
8010078a:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010078f:	f7 e2                	mul    %edx
80100791:	c1 ea 06             	shr    $0x6,%edx
80100794:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100797:	89 da                	mov    %ebx,%edx
80100799:	c1 e0 04             	shl    $0x4,%eax
8010079c:	29 c2                	sub    %eax,%edx
8010079e:	83 fa 02             	cmp    $0x2,%edx
801007a1:	7e 2c                	jle    801007cf <consputc.part.0+0x3bf>
801007a3:	29 d1                	sub    %edx,%ecx
801007a5:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801007ac:	8d 8c 09 04 80 0b 80 	lea    -0x7ff47ffc(%ecx,%ecx,1),%ecx
801007b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007b7:	90                   	nop
      crt[pos] = ' ' | 0x0700;
801007b8:	be 20 07 00 00       	mov    $0x720,%esi
801007bd:	83 e8 02             	sub    $0x2,%eax
801007c0:	66 89 70 02          	mov    %si,0x2(%eax)
    for (int i = (pos % 80); i > 2; i--)
801007c4:	39 c8                	cmp    %ecx,%eax
801007c6:	75 f0                	jne    801007b8 <consputc.part.0+0x3a8>
801007c8:	8d 4b 02             	lea    0x2(%ebx),%ecx
801007cb:	29 d1                	sub    %edx,%ecx
801007cd:	89 cb                	mov    %ecx,%ebx
    for (int i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
801007cf:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
801007d4:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
801007da:	29 c2                	sub    %eax,%edx
801007dc:	83 e2 7f             	and    $0x7f,%edx
801007df:	0f 84 32 fd ff ff    	je     80100517 <consputc.part.0+0x107>
801007e5:	31 c9                	xor    %ecx,%ecx
801007e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007ee:	66 90                	xchg   %ax,%ax
      crt[pos] = (input.buf[(i + input.w) % INPUT_BUF] & 0xff) | 0x0700;
801007f0:	01 c8                	add    %ecx,%eax
    for (int i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
801007f2:	83 c1 01             	add    $0x1,%ecx
      crt[pos] = (input.buf[(i + input.w) % INPUT_BUF] & 0xff) | 0x0700;
801007f5:	83 e0 7f             	and    $0x7f,%eax
801007f8:	0f b6 80 20 0f 11 80 	movzbl -0x7feef0e0(%eax),%eax
801007ff:	80 cc 07             	or     $0x7,%ah
80100802:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100809:	80 
    for (int i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
8010080a:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
      pos++;
8010080f:	83 c3 01             	add    $0x1,%ebx
    for (int i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
80100812:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
80100818:	29 c2                	sub    %eax,%edx
8010081a:	83 e2 7f             	and    $0x7f,%edx
8010081d:	39 d1                	cmp    %edx,%ecx
8010081f:	72 cf                	jb     801007f0 <consputc.part.0+0x3e0>
80100821:	89 d9                	mov    %ebx,%ecx
80100823:	e9 ef fc ff ff       	jmp    80100517 <consputc.part.0+0x107>
    panic("pos under/overflow");
80100828:	83 ec 0c             	sub    $0xc,%esp
8010082b:	68 a5 79 10 80       	push   $0x801079a5
80100830:	e8 5b fb ff ff       	call   80100390 <panic>
80100835:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100840 <printint>:
{
80100840:	55                   	push   %ebp
80100841:	89 e5                	mov    %esp,%ebp
80100843:	57                   	push   %edi
80100844:	56                   	push   %esi
80100845:	53                   	push   %ebx
80100846:	83 ec 2c             	sub    $0x2c,%esp
80100849:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if (sign && (sign = xx < 0))
8010084c:	85 c9                	test   %ecx,%ecx
8010084e:	74 04                	je     80100854 <printint+0x14>
80100850:	85 c0                	test   %eax,%eax
80100852:	78 6d                	js     801008c1 <printint+0x81>
    x = xx;
80100854:	89 c1                	mov    %eax,%ecx
80100856:	31 f6                	xor    %esi,%esi
  i = 0;
80100858:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010085b:	31 db                	xor    %ebx,%ebx
8010085d:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
80100860:	89 c8                	mov    %ecx,%eax
80100862:	31 d2                	xor    %edx,%edx
80100864:	89 ce                	mov    %ecx,%esi
80100866:	f7 75 d4             	divl   -0x2c(%ebp)
80100869:	0f b6 92 d0 79 10 80 	movzbl -0x7fef8630(%edx),%edx
80100870:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100873:	89 d8                	mov    %ebx,%eax
80100875:	8d 5b 01             	lea    0x1(%ebx),%ebx
  } while ((x /= base) != 0);
80100878:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010087b:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
8010087e:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  } while ((x /= base) != 0);
80100881:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80100884:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80100887:	73 d7                	jae    80100860 <printint+0x20>
80100889:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if (sign)
8010088c:	85 f6                	test   %esi,%esi
8010088e:	74 0c                	je     8010089c <printint+0x5c>
    buf[i++] = '-';
80100890:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100895:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
80100897:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while (--i >= 0)
8010089c:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
801008a0:	0f be c2             	movsbl %dl,%eax
  if (panicked)
801008a3:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008a9:	85 d2                	test   %edx,%edx
801008ab:	74 03                	je     801008b0 <printint+0x70>
  asm volatile("cli");
801008ad:	fa                   	cli    
    for (;;)
801008ae:	eb fe                	jmp    801008ae <printint+0x6e>
801008b0:	e8 5b fb ff ff       	call   80100410 <consputc.part.0>
  while (--i >= 0)
801008b5:	39 fb                	cmp    %edi,%ebx
801008b7:	74 10                	je     801008c9 <printint+0x89>
801008b9:	0f be 03             	movsbl (%ebx),%eax
801008bc:	83 eb 01             	sub    $0x1,%ebx
801008bf:	eb e2                	jmp    801008a3 <printint+0x63>
    x = -xx;
801008c1:	f7 d8                	neg    %eax
801008c3:	89 ce                	mov    %ecx,%esi
801008c5:	89 c1                	mov    %eax,%ecx
801008c7:	eb 8f                	jmp    80100858 <printint+0x18>
}
801008c9:	83 c4 2c             	add    $0x2c,%esp
801008cc:	5b                   	pop    %ebx
801008cd:	5e                   	pop    %esi
801008ce:	5f                   	pop    %edi
801008cf:	5d                   	pop    %ebp
801008d0:	c3                   	ret    
801008d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008df:	90                   	nop

801008e0 <consolewrite>:

int consolewrite(struct inode *ip, char *buf, int n)
{
801008e0:	f3 0f 1e fb          	endbr32 
801008e4:	55                   	push   %ebp
801008e5:	89 e5                	mov    %esp,%ebp
801008e7:	57                   	push   %edi
801008e8:	56                   	push   %esi
801008e9:	53                   	push   %ebx
801008ea:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
801008ed:	ff 75 08             	pushl  0x8(%ebp)
{
801008f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
801008f3:	e8 c8 17 00 00       	call   801020c0 <iunlock>
  acquire(&cons.lock);
801008f8:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801008ff:	e8 dc 44 00 00       	call   80104de0 <acquire>
  for (i = 0; i < n; i++)
80100904:	83 c4 10             	add    $0x10,%esp
80100907:	85 db                	test   %ebx,%ebx
80100909:	7e 24                	jle    8010092f <consolewrite+0x4f>
8010090b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010090e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if (panicked)
80100911:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100917:	85 d2                	test   %edx,%edx
80100919:	74 05                	je     80100920 <consolewrite+0x40>
8010091b:	fa                   	cli    
    for (;;)
8010091c:	eb fe                	jmp    8010091c <consolewrite+0x3c>
8010091e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100920:	0f b6 07             	movzbl (%edi),%eax
80100923:	83 c7 01             	add    $0x1,%edi
80100926:	e8 e5 fa ff ff       	call   80100410 <consputc.part.0>
  for (i = 0; i < n; i++)
8010092b:	39 fe                	cmp    %edi,%esi
8010092d:	75 e2                	jne    80100911 <consolewrite+0x31>
  release(&cons.lock);
8010092f:	83 ec 0c             	sub    $0xc,%esp
80100932:	68 20 b5 10 80       	push   $0x8010b520
80100937:	e8 64 45 00 00       	call   80104ea0 <release>
  ilock(ip);
8010093c:	58                   	pop    %eax
8010093d:	ff 75 08             	pushl  0x8(%ebp)
80100940:	e8 9b 16 00 00       	call   80101fe0 <ilock>

  return n;
}
80100945:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100948:	89 d8                	mov    %ebx,%eax
8010094a:	5b                   	pop    %ebx
8010094b:	5e                   	pop    %esi
8010094c:	5f                   	pop    %edi
8010094d:	5d                   	pop    %ebp
8010094e:	c3                   	ret    
8010094f:	90                   	nop

80100950 <cprintf>:
{
80100950:	f3 0f 1e fb          	endbr32 
80100954:	55                   	push   %ebp
80100955:	89 e5                	mov    %esp,%ebp
80100957:	57                   	push   %edi
80100958:	56                   	push   %esi
80100959:	53                   	push   %ebx
8010095a:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010095d:	a1 54 b5 10 80       	mov    0x8010b554,%eax
80100962:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (locking)
80100965:	85 c0                	test   %eax,%eax
80100967:	0f 85 e8 00 00 00    	jne    80100a55 <cprintf+0x105>
  if (fmt == 0)
8010096d:	8b 45 08             	mov    0x8(%ebp),%eax
80100970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100973:	85 c0                	test   %eax,%eax
80100975:	0f 84 5a 01 00 00    	je     80100ad5 <cprintf+0x185>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
8010097b:	0f b6 00             	movzbl (%eax),%eax
8010097e:	85 c0                	test   %eax,%eax
80100980:	74 36                	je     801009b8 <cprintf+0x68>
  argp = (uint *)(void *)(&fmt + 1);
80100982:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
80100985:	31 f6                	xor    %esi,%esi
    if (c != '%')
80100987:	83 f8 25             	cmp    $0x25,%eax
8010098a:	74 44                	je     801009d0 <cprintf+0x80>
  if (panicked)
8010098c:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100992:	85 c9                	test   %ecx,%ecx
80100994:	74 0f                	je     801009a5 <cprintf+0x55>
80100996:	fa                   	cli    
    for (;;)
80100997:	eb fe                	jmp    80100997 <cprintf+0x47>
80100999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009a0:	b8 25 00 00 00       	mov    $0x25,%eax
801009a5:	e8 66 fa ff ff       	call   80100410 <consputc.part.0>
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
801009aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801009ad:	83 c6 01             	add    $0x1,%esi
801009b0:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
801009b4:	85 c0                	test   %eax,%eax
801009b6:	75 cf                	jne    80100987 <cprintf+0x37>
  if (locking)
801009b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801009bb:	85 c0                	test   %eax,%eax
801009bd:	0f 85 fd 00 00 00    	jne    80100ac0 <cprintf+0x170>
}
801009c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009c6:	5b                   	pop    %ebx
801009c7:	5e                   	pop    %esi
801009c8:	5f                   	pop    %edi
801009c9:	5d                   	pop    %ebp
801009ca:	c3                   	ret    
801009cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009cf:	90                   	nop
    c = fmt[++i] & 0xff;
801009d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801009d3:	83 c6 01             	add    $0x1,%esi
801009d6:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if (c == 0)
801009da:	85 ff                	test   %edi,%edi
801009dc:	74 da                	je     801009b8 <cprintf+0x68>
    switch (c)
801009de:	83 ff 70             	cmp    $0x70,%edi
801009e1:	74 5a                	je     80100a3d <cprintf+0xed>
801009e3:	7f 2a                	jg     80100a0f <cprintf+0xbf>
801009e5:	83 ff 25             	cmp    $0x25,%edi
801009e8:	0f 84 92 00 00 00    	je     80100a80 <cprintf+0x130>
801009ee:	83 ff 64             	cmp    $0x64,%edi
801009f1:	0f 85 a1 00 00 00    	jne    80100a98 <cprintf+0x148>
      printint(*argp++, 10, 1);
801009f7:	8b 03                	mov    (%ebx),%eax
801009f9:	8d 7b 04             	lea    0x4(%ebx),%edi
801009fc:	b9 01 00 00 00       	mov    $0x1,%ecx
80100a01:	ba 0a 00 00 00       	mov    $0xa,%edx
80100a06:	89 fb                	mov    %edi,%ebx
80100a08:	e8 33 fe ff ff       	call   80100840 <printint>
      break;
80100a0d:	eb 9b                	jmp    801009aa <cprintf+0x5a>
    switch (c)
80100a0f:	83 ff 73             	cmp    $0x73,%edi
80100a12:	75 24                	jne    80100a38 <cprintf+0xe8>
      if ((s = (char *)*argp++) == 0)
80100a14:	8d 7b 04             	lea    0x4(%ebx),%edi
80100a17:	8b 1b                	mov    (%ebx),%ebx
80100a19:	85 db                	test   %ebx,%ebx
80100a1b:	75 55                	jne    80100a72 <cprintf+0x122>
        s = "(null)";
80100a1d:	bb b8 79 10 80       	mov    $0x801079b8,%ebx
      for (; *s; s++)
80100a22:	b8 28 00 00 00       	mov    $0x28,%eax
  if (panicked)
80100a27:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100a2d:	85 d2                	test   %edx,%edx
80100a2f:	74 39                	je     80100a6a <cprintf+0x11a>
80100a31:	fa                   	cli    
    for (;;)
80100a32:	eb fe                	jmp    80100a32 <cprintf+0xe2>
80100a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch (c)
80100a38:	83 ff 78             	cmp    $0x78,%edi
80100a3b:	75 5b                	jne    80100a98 <cprintf+0x148>
      printint(*argp++, 16, 0);
80100a3d:	8b 03                	mov    (%ebx),%eax
80100a3f:	8d 7b 04             	lea    0x4(%ebx),%edi
80100a42:	31 c9                	xor    %ecx,%ecx
80100a44:	ba 10 00 00 00       	mov    $0x10,%edx
80100a49:	89 fb                	mov    %edi,%ebx
80100a4b:	e8 f0 fd ff ff       	call   80100840 <printint>
      break;
80100a50:	e9 55 ff ff ff       	jmp    801009aa <cprintf+0x5a>
    acquire(&cons.lock);
80100a55:	83 ec 0c             	sub    $0xc,%esp
80100a58:	68 20 b5 10 80       	push   $0x8010b520
80100a5d:	e8 7e 43 00 00       	call   80104de0 <acquire>
80100a62:	83 c4 10             	add    $0x10,%esp
80100a65:	e9 03 ff ff ff       	jmp    8010096d <cprintf+0x1d>
80100a6a:	e8 a1 f9 ff ff       	call   80100410 <consputc.part.0>
      for (; *s; s++)
80100a6f:	83 c3 01             	add    $0x1,%ebx
80100a72:	0f be 03             	movsbl (%ebx),%eax
80100a75:	84 c0                	test   %al,%al
80100a77:	75 ae                	jne    80100a27 <cprintf+0xd7>
      if ((s = (char *)*argp++) == 0)
80100a79:	89 fb                	mov    %edi,%ebx
80100a7b:	e9 2a ff ff ff       	jmp    801009aa <cprintf+0x5a>
  if (panicked)
80100a80:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
80100a86:	85 ff                	test   %edi,%edi
80100a88:	0f 84 12 ff ff ff    	je     801009a0 <cprintf+0x50>
80100a8e:	fa                   	cli    
    for (;;)
80100a8f:	eb fe                	jmp    80100a8f <cprintf+0x13f>
80100a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (panicked)
80100a98:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100a9e:	85 c9                	test   %ecx,%ecx
80100aa0:	74 06                	je     80100aa8 <cprintf+0x158>
80100aa2:	fa                   	cli    
    for (;;)
80100aa3:	eb fe                	jmp    80100aa3 <cprintf+0x153>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	b8 25 00 00 00       	mov    $0x25,%eax
80100aad:	e8 5e f9 ff ff       	call   80100410 <consputc.part.0>
  if (panicked)
80100ab2:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100ab8:	85 d2                	test   %edx,%edx
80100aba:	74 2c                	je     80100ae8 <cprintf+0x198>
80100abc:	fa                   	cli    
    for (;;)
80100abd:	eb fe                	jmp    80100abd <cprintf+0x16d>
80100abf:	90                   	nop
    release(&cons.lock);
80100ac0:	83 ec 0c             	sub    $0xc,%esp
80100ac3:	68 20 b5 10 80       	push   $0x8010b520
80100ac8:	e8 d3 43 00 00       	call   80104ea0 <release>
80100acd:	83 c4 10             	add    $0x10,%esp
}
80100ad0:	e9 ee fe ff ff       	jmp    801009c3 <cprintf+0x73>
    panic("null fmt");
80100ad5:	83 ec 0c             	sub    $0xc,%esp
80100ad8:	68 bf 79 10 80       	push   $0x801079bf
80100add:	e8 ae f8 ff ff       	call   80100390 <panic>
80100ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ae8:	89 f8                	mov    %edi,%eax
80100aea:	e8 21 f9 ff ff       	call   80100410 <consputc.part.0>
80100aef:	e9 b6 fe ff ff       	jmp    801009aa <cprintf+0x5a>
80100af4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop

80100b00 <shiftRight>:
{
80100b00:	f3 0f 1e fb          	endbr32 
80100b04:	55                   	push   %ebp
  for (int i = input.e; i > input.pointer; i--)
80100b05:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
{
80100b0b:	89 e5                	mov    %esp,%ebp
80100b0d:	56                   	push   %esi
80100b0e:	53                   	push   %ebx
  for (int i = input.e; i > input.pointer; i--)
80100b0f:	8b 1d ac 0f 11 80    	mov    0x80110fac,%ebx
80100b15:	39 da                	cmp    %ebx,%edx
80100b17:	76 3c                	jbe    80100b55 <shiftRight+0x55>
80100b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
80100b20:	89 d0                	mov    %edx,%eax
80100b22:	83 ea 01             	sub    $0x1,%edx
80100b25:	89 d6                	mov    %edx,%esi
80100b27:	c1 fe 1f             	sar    $0x1f,%esi
80100b2a:	c1 ee 19             	shr    $0x19,%esi
80100b2d:	8d 0c 32             	lea    (%edx,%esi,1),%ecx
80100b30:	83 e1 7f             	and    $0x7f,%ecx
80100b33:	29 f1                	sub    %esi,%ecx
80100b35:	89 c6                	mov    %eax,%esi
80100b37:	c1 fe 1f             	sar    $0x1f,%esi
80100b3a:	0f b6 89 20 0f 11 80 	movzbl -0x7feef0e0(%ecx),%ecx
80100b41:	c1 ee 19             	shr    $0x19,%esi
80100b44:	01 f0                	add    %esi,%eax
80100b46:	83 e0 7f             	and    $0x7f,%eax
80100b49:	29 f0                	sub    %esi,%eax
80100b4b:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
  for (int i = input.e; i > input.pointer; i--)
80100b51:	39 d3                	cmp    %edx,%ebx
80100b53:	72 cb                	jb     80100b20 <shiftRight+0x20>
}
80100b55:	5b                   	pop    %ebx
80100b56:	5e                   	pop    %esi
80100b57:	5d                   	pop    %ebp
80100b58:	c3                   	ret    
80100b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100b60 <shiftLeft>:
{
80100b60:	f3 0f 1e fb          	endbr32 
80100b64:	55                   	push   %ebp
  for (int i = input.pointer - 1; i < input.e; i++)
80100b65:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
80100b6a:	8d 50 ff             	lea    -0x1(%eax),%edx
{
80100b6d:	89 e5                	mov    %esp,%ebp
80100b6f:	56                   	push   %esi
80100b70:	53                   	push   %ebx
  for (int i = input.pointer - 1; i < input.e; i++)
80100b71:	8b 1d a8 0f 11 80    	mov    0x80110fa8,%ebx
80100b77:	39 da                	cmp    %ebx,%edx
80100b79:	73 3a                	jae    80100bb5 <shiftLeft+0x55>
80100b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b7f:	90                   	nop
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100b80:	89 d0                	mov    %edx,%eax
80100b82:	83 c2 01             	add    $0x1,%edx
80100b85:	89 d6                	mov    %edx,%esi
80100b87:	c1 fe 1f             	sar    $0x1f,%esi
80100b8a:	c1 ee 19             	shr    $0x19,%esi
80100b8d:	8d 0c 32             	lea    (%edx,%esi,1),%ecx
80100b90:	83 e1 7f             	and    $0x7f,%ecx
80100b93:	29 f1                	sub    %esi,%ecx
80100b95:	89 c6                	mov    %eax,%esi
80100b97:	c1 fe 1f             	sar    $0x1f,%esi
80100b9a:	0f b6 89 20 0f 11 80 	movzbl -0x7feef0e0(%ecx),%ecx
80100ba1:	c1 ee 19             	shr    $0x19,%esi
80100ba4:	01 f0                	add    %esi,%eax
80100ba6:	83 e0 7f             	and    $0x7f,%eax
80100ba9:	29 f0                	sub    %esi,%eax
80100bab:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
  for (int i = input.pointer - 1; i < input.e; i++)
80100bb1:	39 da                	cmp    %ebx,%edx
80100bb3:	75 cb                	jne    80100b80 <shiftLeft+0x20>
}
80100bb5:	5b                   	pop    %ebx
80100bb6:	5e                   	pop    %esi
80100bb7:	5d                   	pop    %ebp
80100bb8:	c3                   	ret    
80100bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100bc0 <recordCommand>:
{
80100bc0:	f3 0f 1e fb          	endbr32 
80100bc4:	55                   	push   %ebp
80100bc5:	89 e5                	mov    %esp,%ebp
80100bc7:	57                   	push   %edi
80100bc8:	56                   	push   %esi
80100bc9:	53                   	push   %ebx
80100bca:	83 ec 04             	sub    $0x4,%esp
80100bcd:	8b 15 a4 0f 11 80    	mov    0x80110fa4,%edx
80100bd3:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
  if (cmd_buffer.s != CMD_BUF_SIZE)
80100bd8:	8b 3d cc 14 11 80    	mov    0x801114cc,%edi
80100bde:	8b 1d c4 14 11 80    	mov    0x801114c4,%ebx
80100be4:	29 d0                	sub    %edx,%eax
80100be6:	83 e0 7f             	and    $0x7f,%eax
80100be9:	83 ff 0a             	cmp    $0xa,%edi
80100bec:	0f 84 86 00 00 00    	je     80100c78 <recordCommand+0xb8>
    for (i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
80100bf2:	85 c0                	test   %eax,%eax
80100bf4:	0f 84 ee 00 00 00    	je     80100ce8 <recordCommand+0x128>
80100bfa:	89 d9                	mov    %ebx,%ecx
80100bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100bff:	81 c2 20 0f 11 80    	add    $0x80110f20,%edx
80100c05:	c1 e1 07             	shl    $0x7,%ecx
80100c08:	8d 34 02             	lea    (%edx,%eax,1),%esi
80100c0b:	81 c1 c0 0f 11 80    	add    $0x80110fc0,%ecx
80100c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cmd_buffer.buf[cmd_buffer.w][i] = input.buf[i + input.w];
80100c18:	0f b6 02             	movzbl (%edx),%eax
80100c1b:	83 c2 01             	add    $0x1,%edx
80100c1e:	83 c1 01             	add    $0x1,%ecx
80100c21:	88 41 ff             	mov    %al,-0x1(%ecx)
    for (i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
80100c24:	39 f2                	cmp    %esi,%edx
80100c26:	75 f0                	jne    80100c18 <recordCommand+0x58>
80100c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
    cmd_buffer.buf[cmd_buffer.w][i] = END_OF_ARRAY;
80100c2b:	89 da                	mov    %ebx,%edx
    cmd_buffer.s++;
80100c2d:	83 c7 01             	add    $0x1,%edi
    cmd_buffer.buf[cmd_buffer.w][i] = END_OF_ARRAY;
80100c30:	c1 e2 07             	shl    $0x7,%edx
    cmd_buffer.s++;
80100c33:	89 3d cc 14 11 80    	mov    %edi,0x801114cc
    cmd_buffer.buf[cmd_buffer.w][i] = END_OF_ARRAY;
80100c39:	c6 84 10 c0 0f 11 80 	movb   $0x0,-0x7feef040(%eax,%edx,1)
80100c40:	00 
  cmd_buffer.w++;
80100c41:	83 c3 01             	add    $0x1,%ebx
  cmd_buffer.w %= 10;
80100c44:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  cmd_buffer.movement = 0;
80100c49:	c7 05 d0 14 11 80 00 	movl   $0x0,0x801114d0
80100c50:	00 00 00 
  cmd_buffer.w %= 10;
80100c53:	89 d8                	mov    %ebx,%eax
80100c55:	f7 e2                	mul    %edx
80100c57:	c1 ea 03             	shr    $0x3,%edx
80100c5a:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100c5d:	01 c0                	add    %eax,%eax
80100c5f:	29 c3                	sub    %eax,%ebx
80100c61:	89 1d c4 14 11 80    	mov    %ebx,0x801114c4
  cmd_buffer.pointer = cmd_buffer.w;
80100c67:	89 1d c8 14 11 80    	mov    %ebx,0x801114c8
}
80100c6d:	83 c4 04             	add    $0x4,%esp
80100c70:	5b                   	pop    %ebx
80100c71:	5e                   	pop    %esi
80100c72:	5f                   	pop    %edi
80100c73:	5d                   	pop    %ebp
80100c74:	c3                   	ret    
80100c75:	8d 76 00             	lea    0x0(%esi),%esi
    for (i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
80100c78:	8b 3d c0 14 11 80    	mov    0x801114c0,%edi
80100c7e:	85 c0                	test   %eax,%eax
80100c80:	74 31                	je     80100cb3 <recordCommand+0xf3>
80100c82:	89 f9                	mov    %edi,%ecx
80100c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100c87:	81 c2 20 0f 11 80    	add    $0x80110f20,%edx
80100c8d:	c1 e1 07             	shl    $0x7,%ecx
80100c90:	8d 34 02             	lea    (%edx,%eax,1),%esi
80100c93:	81 c1 c0 0f 11 80    	add    $0x80110fc0,%ecx
80100c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cmd_buffer.buf[cmd_buffer.r][i] = input.buf[i + input.w];
80100ca0:	0f b6 02             	movzbl (%edx),%eax
80100ca3:	83 c2 01             	add    $0x1,%edx
80100ca6:	83 c1 01             	add    $0x1,%ecx
80100ca9:	88 41 ff             	mov    %al,-0x1(%ecx)
    for (i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
80100cac:	39 f2                	cmp    %esi,%edx
80100cae:	75 f0                	jne    80100ca0 <recordCommand+0xe0>
80100cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    cmd_buffer.buf[cmd_buffer.r][i] = END_OF_ARRAY;
80100cb3:	89 fa                	mov    %edi,%edx
    cmd_buffer.r++;
80100cb5:	83 c7 01             	add    $0x1,%edi
    cmd_buffer.buf[cmd_buffer.r][i] = END_OF_ARRAY;
80100cb8:	c1 e2 07             	shl    $0x7,%edx
80100cbb:	c6 84 10 c0 0f 11 80 	movb   $0x0,-0x7feef040(%eax,%edx,1)
80100cc2:	00 
    cmd_buffer.r %= 10;
80100cc3:	89 f8                	mov    %edi,%eax
80100cc5:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100cca:	f7 e2                	mul    %edx
80100ccc:	c1 ea 03             	shr    $0x3,%edx
80100ccf:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100cd2:	01 c0                	add    %eax,%eax
80100cd4:	29 c7                	sub    %eax,%edi
80100cd6:	89 3d c0 14 11 80    	mov    %edi,0x801114c0
80100cdc:	e9 60 ff ff ff       	jmp    80100c41 <recordCommand+0x81>
80100ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
80100ce8:	31 c0                	xor    %eax,%eax
80100cea:	e9 3c ff ff ff       	jmp    80100c2b <recordCommand+0x6b>
80100cef:	90                   	nop

80100cf0 <loadCommand>:
{
80100cf0:	f3 0f 1e fb          	endbr32 
    if (cmd_buffer.buf[cmd_buffer.pointer][i] == END_OF_ARRAY)
80100cf4:	8b 15 ac 0f 11 80    	mov    0x80110fac,%edx
80100cfa:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
{
80100cff:	55                   	push   %ebp
80100d00:	89 e5                	mov    %esp,%ebp
80100d02:	57                   	push   %edi
    input.pointer++;
80100d03:	89 d7                	mov    %edx,%edi
{
80100d05:	56                   	push   %esi
    input.buf[(input.w + i) % INPUT_BUF] = cmd_buffer.buf[cmd_buffer.pointer][i];
80100d06:	8b 35 a4 0f 11 80    	mov    0x80110fa4,%esi
    input.pointer++;
80100d0c:	29 c7                	sub    %eax,%edi
{
80100d0e:	53                   	push   %ebx
    if (cmd_buffer.buf[cmd_buffer.pointer][i] == END_OF_ARRAY)
80100d0f:	8b 1d c8 14 11 80    	mov    0x801114c8,%ebx
    input.buf[(input.w + i) % INPUT_BUF] = cmd_buffer.buf[cmd_buffer.pointer][i];
80100d15:	29 c6                	sub    %eax,%esi
    if (cmd_buffer.buf[cmd_buffer.pointer][i] == END_OF_ARRAY)
80100d17:	c1 e3 07             	shl    $0x7,%ebx
80100d1a:	0f b6 8b c0 0f 11 80 	movzbl -0x7feef040(%ebx),%ecx
80100d21:	29 c3                	sub    %eax,%ebx
80100d23:	84 c9                	test   %cl,%cl
80100d25:	74 27                	je     80100d4e <loadCommand+0x5e>
80100d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d2e:	66 90                	xchg   %ax,%ax
    input.buf[(input.w + i) % INPUT_BUF] = cmd_buffer.buf[cmd_buffer.pointer][i];
80100d30:	8d 14 06             	lea    (%esi,%eax,1),%edx
    input.e++;
80100d33:	83 c0 01             	add    $0x1,%eax
    input.buf[(input.w + i) % INPUT_BUF] = cmd_buffer.buf[cmd_buffer.pointer][i];
80100d36:	83 e2 7f             	and    $0x7f,%edx
80100d39:	88 8a 20 0f 11 80    	mov    %cl,-0x7feef0e0(%edx)
    if (cmd_buffer.buf[cmd_buffer.pointer][i] == END_OF_ARRAY)
80100d3f:	0f b6 8c 03 c0 0f 11 	movzbl -0x7feef040(%ebx,%eax,1),%ecx
80100d46:	80 
    input.pointer++;
80100d47:	8d 14 07             	lea    (%edi,%eax,1),%edx
    if (cmd_buffer.buf[cmd_buffer.pointer][i] == END_OF_ARRAY)
80100d4a:	84 c9                	test   %cl,%cl
80100d4c:	75 e2                	jne    80100d30 <loadCommand+0x40>
      input.pointer %= INPUT_BUF;
80100d4e:	83 e2 7f             	and    $0x7f,%edx
      input.e %= INPUT_BUF;
80100d51:	83 e0 7f             	and    $0x7f,%eax
}
80100d54:	5b                   	pop    %ebx
80100d55:	5e                   	pop    %esi
      input.pointer %= INPUT_BUF;
80100d56:	89 15 ac 0f 11 80    	mov    %edx,0x80110fac
}
80100d5c:	5f                   	pop    %edi
      input.e %= INPUT_BUF;
80100d5d:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
}
80100d62:	5d                   	pop    %ebp
80100d63:	c3                   	ret    
80100d64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d6f:	90                   	nop

80100d70 <consoleintr>:
{
80100d70:	f3 0f 1e fb          	endbr32 
80100d74:	55                   	push   %ebp
80100d75:	89 e5                	mov    %esp,%ebp
80100d77:	57                   	push   %edi
80100d78:	56                   	push   %esi
80100d79:	53                   	push   %ebx
80100d7a:	83 ec 28             	sub    $0x28,%esp
80100d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100d80:	68 20 b5 10 80       	push   $0x8010b520
{
80100d85:	89 45 dc             	mov    %eax,-0x24(%ebp)
  acquire(&cons.lock);
80100d88:	e8 53 40 00 00       	call   80104de0 <acquire>
  int c, doprocdump = 0;
80100d8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while ((c = getc()) >= 0)
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d9a:	ff d0                	call   *%eax
80100d9c:	89 c3                	mov    %eax,%ebx
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	0f 88 f1 03 00 00    	js     80101197 <consoleintr+0x427>
    switch (c)
80100da6:	83 fb 7f             	cmp    $0x7f,%ebx
80100da9:	0f 84 61 01 00 00    	je     80100f10 <consoleintr+0x1a0>
80100daf:	7e 7f                	jle    80100e30 <consoleintr+0xc0>
80100db1:	81 fb e4 00 00 00    	cmp    $0xe4,%ebx
80100db7:	0f 84 27 01 00 00    	je     80100ee4 <consoleintr+0x174>
80100dbd:	0f 8f 95 00 00 00    	jg     80100e58 <consoleintr+0xe8>
80100dc3:	81 fb e2 00 00 00    	cmp    $0xe2,%ebx
80100dc9:	0f 84 71 01 00 00    	je     80100f40 <consoleintr+0x1d0>
80100dcf:	81 fb e3 00 00 00    	cmp    $0xe3,%ebx
80100dd5:	0f 85 8d 02 00 00    	jne    80101068 <consoleintr+0x2f8>
      if (cmd_buffer.movement != 0)
80100ddb:	a1 d0 14 11 80       	mov    0x801114d0,%eax
80100de0:	85 c0                	test   %eax,%eax
80100de2:	74 b3                	je     80100d97 <consoleintr+0x27>
        input.e = input.w;
80100de4:	8b 15 a4 0f 11 80    	mov    0x80110fa4,%edx
80100dea:	8b 1d 58 b5 10 80    	mov    0x8010b558,%ebx
80100df0:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        input.pointer = input.w;
80100df6:	89 15 ac 0f 11 80    	mov    %edx,0x80110fac
        if (CAN_ARROW_DOWN && cmd_buffer.s > 0)
80100dfc:	8d 50 ff             	lea    -0x1(%eax),%edx
80100dff:	83 f8 01             	cmp    $0x1,%eax
80100e02:	76 0e                	jbe    80100e12 <consoleintr+0xa2>
80100e04:	8b 35 cc 14 11 80    	mov    0x801114cc,%esi
80100e0a:	85 f6                	test   %esi,%esi
80100e0c:	0f 85 54 04 00 00    	jne    80101266 <consoleintr+0x4f6>
            cmd_buffer.movement--;
80100e12:	89 15 d0 14 11 80    	mov    %edx,0x801114d0
            cmd_buffer.pointer = 1;
80100e18:	c7 05 c8 14 11 80 01 	movl   $0x1,0x801114c8
80100e1f:	00 00 00 
  if (panicked)
80100e22:	85 db                	test   %ebx,%ebx
80100e24:	0f 84 41 03 00 00    	je     8010116b <consoleintr+0x3fb>
80100e2a:	fa                   	cli    
    for (;;)
80100e2b:	eb fe                	jmp    80100e2b <consoleintr+0xbb>
80100e2d:	8d 76 00             	lea    0x0(%esi),%esi
    switch (c)
80100e30:	83 fb 10             	cmp    $0x10,%ebx
80100e33:	0f 84 9f 00 00 00    	je     80100ed8 <consoleintr+0x168>
80100e39:	7e 55                	jle    80100e90 <consoleintr+0x120>
80100e3b:	83 fb 15             	cmp    $0x15,%ebx
80100e3e:	0f 85 24 02 00 00    	jne    80101068 <consoleintr+0x2f8>
  if (panicked)
80100e44:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100e4a:	85 d2                	test   %edx,%edx
80100e4c:	0f 84 b5 01 00 00    	je     80101007 <consoleintr+0x297>
80100e52:	fa                   	cli    
    for (;;)
80100e53:	eb fe                	jmp    80100e53 <consoleintr+0xe3>
80100e55:	8d 76 00             	lea    0x0(%esi),%esi
    switch (c)
80100e58:	81 fb e5 00 00 00    	cmp    $0xe5,%ebx
80100e5e:	0f 85 04 02 00 00    	jne    80101068 <consoleintr+0x2f8>
      if (input.pointer != input.e)
80100e64:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
80100e69:	3b 05 a8 0f 11 80    	cmp    0x80110fa8,%eax
80100e6f:	0f 84 22 ff ff ff    	je     80100d97 <consoleintr+0x27>
        input.pointer++;
80100e75:	83 c0 01             	add    $0x1,%eax
80100e78:	a3 ac 0f 11 80       	mov    %eax,0x80110fac
  if (panicked)
80100e7d:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100e82:	85 c0                	test   %eax,%eax
80100e84:	0f 84 9b 01 00 00    	je     80101025 <consoleintr+0x2b5>
80100e8a:	fa                   	cli    
    for (;;)
80100e8b:	eb fe                	jmp    80100e8b <consoleintr+0x11b>
80100e8d:	8d 76 00             	lea    0x0(%esi),%esi
    switch (c)
80100e90:	83 fb 08             	cmp    $0x8,%ebx
80100e93:	74 7b                	je     80100f10 <consoleintr+0x1a0>
80100e95:	83 fb 0c             	cmp    $0xc,%ebx
80100e98:	0f 85 c2 01 00 00    	jne    80101060 <consoleintr+0x2f0>
  if (panicked)
80100e9e:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100ea3:	85 c0                	test   %eax,%eax
80100ea5:	0f 85 89 01 00 00    	jne    80101034 <consoleintr+0x2c4>
80100eab:	b8 06 01 00 00       	mov    $0x106,%eax
80100eb0:	e8 5b f5 ff ff       	call   80100410 <consputc.part.0>
      input.e = input.w;
80100eb5:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
80100eba:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
      input.pointer = input.w;
80100ebf:	a3 ac 0f 11 80       	mov    %eax,0x80110fac
  if (panicked)
80100ec4:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100ec9:	85 c0                	test   %eax,%eax
80100ecb:	0f 84 6f 01 00 00    	je     80101040 <consoleintr+0x2d0>
80100ed1:	fa                   	cli    
    for (;;)
80100ed2:	eb fe                	jmp    80100ed2 <consoleintr+0x162>
80100ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch (c)
80100ed8:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
80100edf:	e9 b3 fe ff ff       	jmp    80100d97 <consoleintr+0x27>
      if (input.pointer != input.w)
80100ee4:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
80100ee9:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100eef:	0f 84 a2 fe ff ff    	je     80100d97 <consoleintr+0x27>
        input.pointer--;
80100ef5:	83 e8 01             	sub    $0x1,%eax
80100ef8:	a3 ac 0f 11 80       	mov    %eax,0x80110fac
  if (panicked)
80100efd:	a1 58 b5 10 80       	mov    0x8010b558,%eax
80100f02:	85 c0                	test   %eax,%eax
80100f04:	0f 84 ee 00 00 00    	je     80100ff8 <consoleintr+0x288>
80100f0a:	fa                   	cli    
    for (;;)
80100f0b:	eb fe                	jmp    80100f0b <consoleintr+0x19b>
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi
      if (input.pointer != input.w)
80100f10:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
80100f15:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100f1b:	0f 84 76 fe ff ff    	je     80100d97 <consoleintr+0x27>
        if (input.e != input.pointer)
80100f21:	8b 0d a8 0f 11 80    	mov    0x80110fa8,%ecx
80100f27:	8b 1d 58 b5 10 80    	mov    0x8010b558,%ebx
80100f2d:	39 c8                	cmp    %ecx,%eax
80100f2f:	75 77                	jne    80100fa8 <consoleintr+0x238>
  if (panicked)
80100f31:	85 db                	test   %ebx,%ebx
80100f33:	0f 84 41 02 00 00    	je     8010117a <consoleintr+0x40a>
80100f39:	fa                   	cli    
    for (;;)
80100f3a:	eb fe                	jmp    80100f3a <consoleintr+0x1ca>
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (CAN_ARROW_UP && cmd_buffer.s > 0)
80100f40:	a1 cc 14 11 80       	mov    0x801114cc,%eax
80100f45:	8b 1d d0 14 11 80    	mov    0x801114d0,%ebx
80100f4b:	85 c0                	test   %eax,%eax
80100f4d:	0f 84 44 fe ff ff    	je     80100d97 <consoleintr+0x27>
80100f53:	39 c3                	cmp    %eax,%ebx
80100f55:	0f 83 3c fe ff ff    	jae    80100d97 <consoleintr+0x27>
        input.e = input.w;
80100f5b:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
        if (cmd_buffer.pointer == 0)
80100f60:	8b 0d c8 14 11 80    	mov    0x801114c8,%ecx
        input.e = input.w;
80100f66:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        input.pointer = input.w;
80100f6b:	a3 ac 0f 11 80       	mov    %eax,0x80110fac
        if (cmd_buffer.pointer == 0)
80100f70:	b8 09 00 00 00       	mov    $0x9,%eax
80100f75:	85 c9                	test   %ecx,%ecx
80100f77:	0f 85 39 02 00 00    	jne    801011b6 <consoleintr+0x446>
        cmd_buffer.movement++;
80100f7d:	83 c3 01             	add    $0x1,%ebx
        cmd_buffer.pointer %= CMD_BUF_SIZE;
80100f80:	a3 c8 14 11 80       	mov    %eax,0x801114c8
        cmd_buffer.movement++;
80100f85:	89 1d d0 14 11 80    	mov    %ebx,0x801114d0
        loadCommand();
80100f8b:	e8 60 fd ff ff       	call   80100cf0 <loadCommand>
  if (panicked)
80100f90:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
80100f96:	85 ff                	test   %edi,%edi
80100f98:	0f 84 4e 02 00 00    	je     801011ec <consoleintr+0x47c>
80100f9e:	fa                   	cli    
    for (;;)
80100f9f:	eb fe                	jmp    80100f9f <consoleintr+0x22f>
80100fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (int i = input.pointer - 1; i < input.e; i++)
80100fa8:	83 e8 01             	sub    $0x1,%eax
80100fab:	89 ce                	mov    %ecx,%esi
80100fad:	39 c1                	cmp    %eax,%ecx
80100faf:	76 35                	jbe    80100fe6 <consoleintr+0x276>
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80100fb1:	89 c2                	mov    %eax,%edx
80100fb3:	83 c0 01             	add    $0x1,%eax
80100fb6:	89 c7                	mov    %eax,%edi
80100fb8:	c1 ff 1f             	sar    $0x1f,%edi
80100fbb:	c1 ef 19             	shr    $0x19,%edi
80100fbe:	8d 0c 38             	lea    (%eax,%edi,1),%ecx
80100fc1:	83 e1 7f             	and    $0x7f,%ecx
80100fc4:	29 f9                	sub    %edi,%ecx
80100fc6:	89 d7                	mov    %edx,%edi
80100fc8:	c1 ff 1f             	sar    $0x1f,%edi
80100fcb:	0f b6 89 20 0f 11 80 	movzbl -0x7feef0e0(%ecx),%ecx
80100fd2:	c1 ef 19             	shr    $0x19,%edi
80100fd5:	01 fa                	add    %edi,%edx
80100fd7:	83 e2 7f             	and    $0x7f,%edx
80100fda:	29 fa                	sub    %edi,%edx
80100fdc:	88 8a 20 0f 11 80    	mov    %cl,-0x7feef0e0(%edx)
  for (int i = input.pointer - 1; i < input.e; i++)
80100fe2:	39 f0                	cmp    %esi,%eax
80100fe4:	75 cb                	jne    80100fb1 <consoleintr+0x241>
  if (panicked)
80100fe6:	85 db                	test   %ebx,%ebx
80100fe8:	0f 84 0d 02 00 00    	je     801011fb <consoleintr+0x48b>
80100fee:	fa                   	cli    
    for (;;)
80100fef:	eb fe                	jmp    80100fef <consoleintr+0x27f>
80100ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ff8:	b8 01 01 00 00       	mov    $0x101,%eax
80100ffd:	e8 0e f4 ff ff       	call   80100410 <consputc.part.0>
80101002:	e9 90 fd ff ff       	jmp    80100d97 <consoleintr+0x27>
80101007:	b8 05 01 00 00       	mov    $0x105,%eax
8010100c:	e8 ff f3 ff ff       	call   80100410 <consputc.part.0>
      input.pointer = input.e = input.w;
80101011:	a1 a4 0f 11 80       	mov    0x80110fa4,%eax
80101016:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
8010101b:	a3 ac 0f 11 80       	mov    %eax,0x80110fac
      break;
80101020:	e9 72 fd ff ff       	jmp    80100d97 <consoleintr+0x27>
80101025:	b8 04 01 00 00       	mov    $0x104,%eax
8010102a:	e8 e1 f3 ff ff       	call   80100410 <consputc.part.0>
8010102f:	e9 63 fd ff ff       	jmp    80100d97 <consoleintr+0x27>
80101034:	fa                   	cli    
    for (;;)
80101035:	eb fe                	jmp    80101035 <consoleintr+0x2c5>
80101037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010103e:	66 90                	xchg   %ax,%ax
80101040:	b8 24 00 00 00       	mov    $0x24,%eax
80101045:	e8 c6 f3 ff ff       	call   80100410 <consputc.part.0>
  if (panicked)
8010104a:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010104f:	85 c0                	test   %eax,%eax
80101051:	0f 84 00 02 00 00    	je     80101257 <consoleintr+0x4e7>
80101057:	fa                   	cli    
    for (;;)
80101058:	eb fe                	jmp    80101058 <consoleintr+0x2e8>
8010105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (c != 0 && input.e - input.r < INPUT_BUF)
80101060:	85 db                	test   %ebx,%ebx
80101062:	0f 84 2f fd ff ff    	je     80100d97 <consoleintr+0x27>
80101068:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010106d:	8b 3d a0 0f 11 80    	mov    0x80110fa0,%edi
80101073:	89 c1                	mov    %eax,%ecx
80101075:	29 f9                	sub    %edi,%ecx
80101077:	83 f9 7f             	cmp    $0x7f,%ecx
8010107a:	0f 87 17 fd ff ff    	ja     80100d97 <consoleintr+0x27>
        c = (c == '\r') ? END_OF_LINE : c;
80101080:	83 fb 0d             	cmp    $0xd,%ebx
80101083:	0f 84 b1 01 00 00    	je     8010123a <consoleintr+0x4ca>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
80101089:	83 fb 0a             	cmp    $0xa,%ebx
8010108c:	0f 94 c1             	sete   %cl
8010108f:	83 fb 04             	cmp    $0x4,%ebx
80101092:	89 ce                	mov    %ecx,%esi
80101094:	0f 94 c1             	sete   %cl
80101097:	89 f2                	mov    %esi,%edx
80101099:	08 ca                	or     %cl,%dl
8010109b:	88 55 e7             	mov    %dl,-0x19(%ebp)
8010109e:	0f 85 9f 01 00 00    	jne    80101243 <consoleintr+0x4d3>
801010a4:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
801010aa:	39 d0                	cmp    %edx,%eax
801010ac:	0f 84 91 01 00 00    	je     80101243 <consoleintr+0x4d3>
        if (input.e != input.pointer)
801010b2:	8b 35 ac 0f 11 80    	mov    0x80110fac,%esi
801010b8:	89 c2                	mov    %eax,%edx
801010ba:	39 c6                	cmp    %eax,%esi
801010bc:	75 72                	jne    80101130 <consoleintr+0x3c0>
        input.e++;
801010be:	83 c2 01             	add    $0x1,%edx
        input.buf[input.pointer++ % INPUT_BUF] = c;
801010c1:	8d 48 01             	lea    0x1(%eax),%ecx
801010c4:	83 e0 7f             	and    $0x7f,%eax
        input.e++;
801010c7:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
  if (panicked)
801010cd:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.buf[input.pointer++ % INPUT_BUF] = c;
801010d3:	89 0d ac 0f 11 80    	mov    %ecx,0x80110fac
801010d9:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if (panicked)
801010df:	85 d2                	test   %edx,%edx
801010e1:	0f 85 ee 00 00 00    	jne    801011d5 <consoleintr+0x465>
801010e7:	89 d8                	mov    %ebx,%eax
801010e9:	e8 22 f3 ff ff       	call   80100410 <consputc.part.0>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
801010ee:	80 7d e7 00          	cmpb   $0x0,-0x19(%ebp)
801010f2:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801010f7:	75 14                	jne    8010110d <consoleintr+0x39d>
801010f9:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801010fe:	83 e8 80             	sub    $0xffffff80,%eax
80101101:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80101107:	0f 85 8a fc ff ff    	jne    80100d97 <consoleintr+0x27>
          wakeup(&input.r);
8010110d:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101110:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80101115:	68 a0 0f 11 80       	push   $0x80110fa0
8010111a:	e8 41 38 00 00       	call   80104960 <wakeup>
8010111f:	83 c4 10             	add    $0x10,%esp
80101122:	e9 70 fc ff ff       	jmp    80100d97 <consoleintr+0x27>
80101127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010112e:	66 90                	xchg   %ax,%ax
  for (int i = input.e; i > input.pointer; i--)
80101130:	0f 83 d4 00 00 00    	jae    8010120a <consoleintr+0x49a>
    input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
80101136:	89 c2                	mov    %eax,%edx
80101138:	83 e8 01             	sub    $0x1,%eax
8010113b:	89 c7                	mov    %eax,%edi
8010113d:	c1 ff 1f             	sar    $0x1f,%edi
80101140:	c1 ef 19             	shr    $0x19,%edi
80101143:	8d 0c 38             	lea    (%eax,%edi,1),%ecx
80101146:	83 e1 7f             	and    $0x7f,%ecx
80101149:	29 f9                	sub    %edi,%ecx
8010114b:	89 d7                	mov    %edx,%edi
8010114d:	c1 ff 1f             	sar    $0x1f,%edi
80101150:	0f b6 89 20 0f 11 80 	movzbl -0x7feef0e0(%ecx),%ecx
80101157:	c1 ef 19             	shr    $0x19,%edi
8010115a:	01 fa                	add    %edi,%edx
8010115c:	83 e2 7f             	and    $0x7f,%edx
8010115f:	29 fa                	sub    %edi,%edx
  for (int i = input.e; i > input.pointer; i--)
80101161:	39 c6                	cmp    %eax,%esi
    input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
80101163:	88 8a 20 0f 11 80    	mov    %cl,-0x7feef0e0(%edx)
  for (int i = input.e; i > input.pointer; i--)
80101169:	eb c5                	jmp    80101130 <consoleintr+0x3c0>
8010116b:	b8 05 01 00 00       	mov    $0x105,%eax
80101170:	e8 9b f2 ff ff       	call   80100410 <consputc.part.0>
80101175:	e9 1d fc ff ff       	jmp    80100d97 <consoleintr+0x27>
8010117a:	b8 00 01 00 00       	mov    $0x100,%eax
8010117f:	e8 8c f2 ff ff       	call   80100410 <consputc.part.0>
        input.e--;
80101184:	83 2d a8 0f 11 80 01 	subl   $0x1,0x80110fa8
        input.pointer--;
8010118b:	83 2d ac 0f 11 80 01 	subl   $0x1,0x80110fac
80101192:	e9 00 fc ff ff       	jmp    80100d97 <consoleintr+0x27>
  release(&cons.lock);
80101197:	83 ec 0c             	sub    $0xc,%esp
8010119a:	68 20 b5 10 80       	push   $0x8010b520
8010119f:	e8 fc 3c 00 00       	call   80104ea0 <release>
  if (doprocdump)
801011a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a7:	83 c4 10             	add    $0x10,%esp
801011aa:	85 c0                	test   %eax,%eax
801011ac:	75 32                	jne    801011e0 <consoleintr+0x470>
}
801011ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b1:	5b                   	pop    %ebx
801011b2:	5e                   	pop    %esi
801011b3:	5f                   	pop    %edi
801011b4:	5d                   	pop    %ebp
801011b5:	c3                   	ret    
          cmd_buffer.pointer--;
801011b6:	83 e9 01             	sub    $0x1,%ecx
801011b9:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801011be:	89 c8                	mov    %ecx,%eax
801011c0:	f7 e2                	mul    %edx
801011c2:	89 d0                	mov    %edx,%eax
801011c4:	c1 e8 03             	shr    $0x3,%eax
801011c7:	8d 04 80             	lea    (%eax,%eax,4),%eax
801011ca:	01 c0                	add    %eax,%eax
801011cc:	29 c1                	sub    %eax,%ecx
801011ce:	89 c8                	mov    %ecx,%eax
801011d0:	e9 a8 fd ff ff       	jmp    80100f7d <consoleintr+0x20d>
801011d5:	fa                   	cli    
    for (;;)
801011d6:	eb fe                	jmp    801011d6 <consoleintr+0x466>
801011d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011df:	90                   	nop
}
801011e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e3:	5b                   	pop    %ebx
801011e4:	5e                   	pop    %esi
801011e5:	5f                   	pop    %edi
801011e6:	5d                   	pop    %ebp
    procdump(); // now call procdump() wo. cons.lock held
801011e7:	e9 64 38 00 00       	jmp    80104a50 <procdump>
801011ec:	b8 e2 00 00 00       	mov    $0xe2,%eax
801011f1:	e8 1a f2 ff ff       	call   80100410 <consputc.part.0>
801011f6:	e9 9c fb ff ff       	jmp    80100d97 <consoleintr+0x27>
801011fb:	b8 03 01 00 00       	mov    $0x103,%eax
80101200:	e8 0b f2 ff ff       	call   80100410 <consputc.part.0>
80101205:	e9 7a ff ff ff       	jmp    80101184 <consoleintr+0x414>
  if (panicked)
8010120a:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80101210:	85 c9                	test   %ecx,%ecx
80101212:	74 0c                	je     80101220 <consoleintr+0x4b0>
80101214:	fa                   	cli    
    for (;;)
80101215:	eb fe                	jmp    80101215 <consoleintr+0x4a5>
80101217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010121e:	66 90                	xchg   %ax,%ax
80101220:	b8 02 01 00 00       	mov    $0x102,%eax
80101225:	e8 e6 f1 ff ff       	call   80100410 <consputc.part.0>
8010122a:	a1 ac 0f 11 80       	mov    0x80110fac,%eax
8010122f:	8b 15 a8 0f 11 80    	mov    0x80110fa8,%edx
80101235:	e9 84 fe ff ff       	jmp    801010be <consoleintr+0x34e>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
8010123a:	c6 45 e7 01          	movb   $0x1,-0x19(%ebp)
        c = (c == '\r') ? END_OF_LINE : c;
8010123e:	bb 0a 00 00 00       	mov    $0xa,%ebx
          input.pointer = input.e;
80101243:	a3 ac 0f 11 80       	mov    %eax,0x80110fac
          recordCommand();
80101248:	e8 73 f9 ff ff       	call   80100bc0 <recordCommand>
8010124d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80101252:	e9 5b fe ff ff       	jmp    801010b2 <consoleintr+0x342>
80101257:	b8 20 00 00 00       	mov    $0x20,%eax
8010125c:	e8 af f1 ff ff       	call   80100410 <consputc.part.0>
80101261:	e9 31 fb ff ff       	jmp    80100d97 <consoleintr+0x27>
          cmd_buffer.pointer++;
80101266:	a1 c8 14 11 80       	mov    0x801114c8,%eax
          cmd_buffer.movement--;
8010126b:	89 15 d0 14 11 80    	mov    %edx,0x801114d0
          cmd_buffer.pointer %= CMD_BUF_SIZE;
80101271:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
          cmd_buffer.pointer++;
80101276:	8d 48 01             	lea    0x1(%eax),%ecx
          cmd_buffer.pointer %= CMD_BUF_SIZE;
80101279:	89 c8                	mov    %ecx,%eax
8010127b:	f7 e2                	mul    %edx
8010127d:	89 d0                	mov    %edx,%eax
8010127f:	c1 e8 03             	shr    $0x3,%eax
80101282:	8d 04 80             	lea    (%eax,%eax,4),%eax
80101285:	01 c0                	add    %eax,%eax
80101287:	29 c1                	sub    %eax,%ecx
80101289:	89 0d c8 14 11 80    	mov    %ecx,0x801114c8
          loadCommand();
8010128f:	e8 5c fa ff ff       	call   80100cf0 <loadCommand>
  if (panicked)
80101294:	85 db                	test   %ebx,%ebx
80101296:	74 08                	je     801012a0 <consoleintr+0x530>
80101298:	fa                   	cli    
    for (;;)
80101299:	eb fe                	jmp    80101299 <consoleintr+0x529>
8010129b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010129f:	90                   	nop
801012a0:	b8 e3 00 00 00       	mov    $0xe3,%eax
801012a5:	e8 66 f1 ff ff       	call   80100410 <consputc.part.0>
801012aa:	e9 e8 fa ff ff       	jmp    80100d97 <consoleintr+0x27>
801012af:	90                   	nop

801012b0 <consoleinit>:

void consoleinit(void)
{
801012b0:	f3 0f 1e fb          	endbr32 
801012b4:	55                   	push   %ebp
801012b5:	89 e5                	mov    %esp,%ebp
801012b7:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801012ba:	68 c8 79 10 80       	push   $0x801079c8
801012bf:	68 20 b5 10 80       	push   $0x8010b520
801012c4:	e8 97 39 00 00       	call   80104c60 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801012c9:	58                   	pop    %eax
801012ca:	5a                   	pop    %edx
801012cb:	6a 00                	push   $0x0
801012cd:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801012cf:	c7 05 8c 1e 11 80 e0 	movl   $0x801008e0,0x80111e8c
801012d6:	08 10 80 
  devsw[CONSOLE].read = consoleread;
801012d9:	c7 05 88 1e 11 80 90 	movl   $0x80100290,0x80111e88
801012e0:	02 10 80 
  cons.locking = 1;
801012e3:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801012ea:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801012ed:	e8 be 19 00 00       	call   80102cb0 <ioapicenable>
801012f2:	83 c4 10             	add    $0x10,%esp
801012f5:	c9                   	leave  
801012f6:	c3                   	ret    
801012f7:	66 90                	xchg   %ax,%ax
801012f9:	66 90                	xchg   %ax,%ax
801012fb:	66 90                	xchg   %ax,%ax
801012fd:	66 90                	xchg   %ax,%ax
801012ff:	90                   	nop

80101300 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101300:	f3 0f 1e fb          	endbr32 
80101304:	55                   	push   %ebp
80101305:	89 e5                	mov    %esp,%ebp
80101307:	57                   	push   %edi
80101308:	56                   	push   %esi
80101309:	53                   	push   %ebx
8010130a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101310:	e8 cb 2e 00 00       	call   801041e0 <myproc>
80101315:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
8010131b:	e8 90 22 00 00       	call   801035b0 <begin_op>

  if((ip = namei(path)) == 0){
80101320:	83 ec 0c             	sub    $0xc,%esp
80101323:	ff 75 08             	pushl  0x8(%ebp)
80101326:	e8 85 15 00 00       	call   801028b0 <namei>
8010132b:	83 c4 10             	add    $0x10,%esp
8010132e:	85 c0                	test   %eax,%eax
80101330:	0f 84 fe 02 00 00    	je     80101634 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101336:	83 ec 0c             	sub    $0xc,%esp
80101339:	89 c3                	mov    %eax,%ebx
8010133b:	50                   	push   %eax
8010133c:	e8 9f 0c 00 00       	call   80101fe0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101341:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101347:	6a 34                	push   $0x34
80101349:	6a 00                	push   $0x0
8010134b:	50                   	push   %eax
8010134c:	53                   	push   %ebx
8010134d:	e8 8e 0f 00 00       	call   801022e0 <readi>
80101352:	83 c4 20             	add    $0x20,%esp
80101355:	83 f8 34             	cmp    $0x34,%eax
80101358:	74 26                	je     80101380 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
8010135a:	83 ec 0c             	sub    $0xc,%esp
8010135d:	53                   	push   %ebx
8010135e:	e8 1d 0f 00 00       	call   80102280 <iunlockput>
    end_op();
80101363:	e8 b8 22 00 00       	call   80103620 <end_op>
80101368:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010136b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101370:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101373:	5b                   	pop    %ebx
80101374:	5e                   	pop    %esi
80101375:	5f                   	pop    %edi
80101376:	5d                   	pop    %ebp
80101377:	c3                   	ret    
80101378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80101380:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101387:	45 4c 46 
8010138a:	75 ce                	jne    8010135a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
8010138c:	e8 3f 63 00 00       	call   801076d0 <setupkvm>
80101391:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101397:	85 c0                	test   %eax,%eax
80101399:	74 bf                	je     8010135a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010139b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801013a2:	00 
801013a3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801013a9:	0f 84 a4 02 00 00    	je     80101653 <exec+0x353>
  sz = 0;
801013af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801013b6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801013b9:	31 ff                	xor    %edi,%edi
801013bb:	e9 86 00 00 00       	jmp    80101446 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
801013c0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801013c7:	75 6c                	jne    80101435 <exec+0x135>
    if(ph.memsz < ph.filesz)
801013c9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801013cf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801013d5:	0f 82 87 00 00 00    	jb     80101462 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801013db:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801013e1:	72 7f                	jb     80101462 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801013e3:	83 ec 04             	sub    $0x4,%esp
801013e6:	50                   	push   %eax
801013e7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801013ed:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801013f3:	e8 f8 60 00 00       	call   801074f0 <allocuvm>
801013f8:	83 c4 10             	add    $0x10,%esp
801013fb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101401:	85 c0                	test   %eax,%eax
80101403:	74 5d                	je     80101462 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101405:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010140b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101410:	75 50                	jne    80101462 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101412:	83 ec 0c             	sub    $0xc,%esp
80101415:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010141b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101421:	53                   	push   %ebx
80101422:	50                   	push   %eax
80101423:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101429:	e8 f2 5f 00 00       	call   80107420 <loaduvm>
8010142e:	83 c4 20             	add    $0x20,%esp
80101431:	85 c0                	test   %eax,%eax
80101433:	78 2d                	js     80101462 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101435:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010143c:	83 c7 01             	add    $0x1,%edi
8010143f:	83 c6 20             	add    $0x20,%esi
80101442:	39 f8                	cmp    %edi,%eax
80101444:	7e 3a                	jle    80101480 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101446:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010144c:	6a 20                	push   $0x20
8010144e:	56                   	push   %esi
8010144f:	50                   	push   %eax
80101450:	53                   	push   %ebx
80101451:	e8 8a 0e 00 00       	call   801022e0 <readi>
80101456:	83 c4 10             	add    $0x10,%esp
80101459:	83 f8 20             	cmp    $0x20,%eax
8010145c:	0f 84 5e ff ff ff    	je     801013c0 <exec+0xc0>
    freevm(pgdir);
80101462:	83 ec 0c             	sub    $0xc,%esp
80101465:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010146b:	e8 e0 61 00 00       	call   80107650 <freevm>
  if(ip){
80101470:	83 c4 10             	add    $0x10,%esp
80101473:	e9 e2 fe ff ff       	jmp    8010135a <exec+0x5a>
80101478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010147f:	90                   	nop
80101480:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101486:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010148c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80101492:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101498:	83 ec 0c             	sub    $0xc,%esp
8010149b:	53                   	push   %ebx
8010149c:	e8 df 0d 00 00       	call   80102280 <iunlockput>
  end_op();
801014a1:	e8 7a 21 00 00       	call   80103620 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801014a6:	83 c4 0c             	add    $0xc,%esp
801014a9:	56                   	push   %esi
801014aa:	57                   	push   %edi
801014ab:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801014b1:	57                   	push   %edi
801014b2:	e8 39 60 00 00       	call   801074f0 <allocuvm>
801014b7:	83 c4 10             	add    $0x10,%esp
801014ba:	89 c6                	mov    %eax,%esi
801014bc:	85 c0                	test   %eax,%eax
801014be:	0f 84 94 00 00 00    	je     80101558 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801014c4:	83 ec 08             	sub    $0x8,%esp
801014c7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
801014cd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801014cf:	50                   	push   %eax
801014d0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801014d1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801014d3:	e8 98 62 00 00       	call   80107770 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801014e4:	8b 00                	mov    (%eax),%eax
801014e6:	85 c0                	test   %eax,%eax
801014e8:	0f 84 8b 00 00 00    	je     80101579 <exec+0x279>
801014ee:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801014f4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801014fa:	eb 23                	jmp    8010151f <exec+0x21f>
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101500:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101503:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010150a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010150d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101513:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101516:	85 c0                	test   %eax,%eax
80101518:	74 59                	je     80101573 <exec+0x273>
    if(argc >= MAXARG)
8010151a:	83 ff 20             	cmp    $0x20,%edi
8010151d:	74 39                	je     80101558 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010151f:	83 ec 0c             	sub    $0xc,%esp
80101522:	50                   	push   %eax
80101523:	e8 c8 3b 00 00       	call   801050f0 <strlen>
80101528:	f7 d0                	not    %eax
8010152a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010152c:	58                   	pop    %eax
8010152d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101530:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101533:	ff 34 b8             	pushl  (%eax,%edi,4)
80101536:	e8 b5 3b 00 00       	call   801050f0 <strlen>
8010153b:	83 c0 01             	add    $0x1,%eax
8010153e:	50                   	push   %eax
8010153f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101542:	ff 34 b8             	pushl  (%eax,%edi,4)
80101545:	53                   	push   %ebx
80101546:	56                   	push   %esi
80101547:	e8 84 63 00 00       	call   801078d0 <copyout>
8010154c:	83 c4 20             	add    $0x20,%esp
8010154f:	85 c0                	test   %eax,%eax
80101551:	79 ad                	jns    80101500 <exec+0x200>
80101553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101557:	90                   	nop
    freevm(pgdir);
80101558:	83 ec 0c             	sub    $0xc,%esp
8010155b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101561:	e8 ea 60 00 00       	call   80107650 <freevm>
80101566:	83 c4 10             	add    $0x10,%esp
  return -1;
80101569:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010156e:	e9 fd fd ff ff       	jmp    80101370 <exec+0x70>
80101573:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101579:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101580:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101582:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101589:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010158d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010158f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101592:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101598:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010159a:	50                   	push   %eax
8010159b:	52                   	push   %edx
8010159c:	53                   	push   %ebx
8010159d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801015a3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801015aa:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801015ad:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801015b3:	e8 18 63 00 00       	call   801078d0 <copyout>
801015b8:	83 c4 10             	add    $0x10,%esp
801015bb:	85 c0                	test   %eax,%eax
801015bd:	78 99                	js     80101558 <exec+0x258>
  for(last=s=path; *s; s++)
801015bf:	8b 45 08             	mov    0x8(%ebp),%eax
801015c2:	8b 55 08             	mov    0x8(%ebp),%edx
801015c5:	0f b6 00             	movzbl (%eax),%eax
801015c8:	84 c0                	test   %al,%al
801015ca:	74 13                	je     801015df <exec+0x2df>
801015cc:	89 d1                	mov    %edx,%ecx
801015ce:	66 90                	xchg   %ax,%ax
    if(*s == '/')
801015d0:	83 c1 01             	add    $0x1,%ecx
801015d3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801015d5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
801015d8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801015db:	84 c0                	test   %al,%al
801015dd:	75 f1                	jne    801015d0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801015df:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801015e5:	83 ec 04             	sub    $0x4,%esp
801015e8:	6a 10                	push   $0x10
801015ea:	89 f8                	mov    %edi,%eax
801015ec:	52                   	push   %edx
801015ed:	83 c0 6c             	add    $0x6c,%eax
801015f0:	50                   	push   %eax
801015f1:	e8 ba 3a 00 00       	call   801050b0 <safestrcpy>
  curproc->pgdir = pgdir;
801015f6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801015fc:	89 f8                	mov    %edi,%eax
801015fe:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101601:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101603:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101606:	89 c1                	mov    %eax,%ecx
80101608:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010160e:	8b 40 18             	mov    0x18(%eax),%eax
80101611:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101614:	8b 41 18             	mov    0x18(%ecx),%eax
80101617:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010161a:	89 0c 24             	mov    %ecx,(%esp)
8010161d:	e8 6e 5c 00 00       	call   80107290 <switchuvm>
  freevm(oldpgdir);
80101622:	89 3c 24             	mov    %edi,(%esp)
80101625:	e8 26 60 00 00       	call   80107650 <freevm>
  return 0;
8010162a:	83 c4 10             	add    $0x10,%esp
8010162d:	31 c0                	xor    %eax,%eax
8010162f:	e9 3c fd ff ff       	jmp    80101370 <exec+0x70>
    end_op();
80101634:	e8 e7 1f 00 00       	call   80103620 <end_op>
    cprintf("exec: fail\n");
80101639:	83 ec 0c             	sub    $0xc,%esp
8010163c:	68 e1 79 10 80       	push   $0x801079e1
80101641:	e8 0a f3 ff ff       	call   80100950 <cprintf>
    return -1;
80101646:	83 c4 10             	add    $0x10,%esp
80101649:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010164e:	e9 1d fd ff ff       	jmp    80101370 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101653:	31 ff                	xor    %edi,%edi
80101655:	be 00 20 00 00       	mov    $0x2000,%esi
8010165a:	e9 39 fe ff ff       	jmp    80101498 <exec+0x198>
8010165f:	90                   	nop

80101660 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101660:	f3 0f 1e fb          	endbr32 
80101664:	55                   	push   %ebp
80101665:	89 e5                	mov    %esp,%ebp
80101667:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010166a:	68 ed 79 10 80       	push   $0x801079ed
8010166f:	68 e0 14 11 80       	push   $0x801114e0
80101674:	e8 e7 35 00 00       	call   80104c60 <initlock>
}
80101679:	83 c4 10             	add    $0x10,%esp
8010167c:	c9                   	leave  
8010167d:	c3                   	ret    
8010167e:	66 90                	xchg   %ax,%ax

80101680 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101680:	f3 0f 1e fb          	endbr32 
80101684:	55                   	push   %ebp
80101685:	89 e5                	mov    %esp,%ebp
80101687:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101688:	bb 14 15 11 80       	mov    $0x80111514,%ebx
{
8010168d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101690:	68 e0 14 11 80       	push   $0x801114e0
80101695:	e8 46 37 00 00       	call   80104de0 <acquire>
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	eb 0c                	jmp    801016ab <filealloc+0x2b>
8010169f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801016a0:	83 c3 18             	add    $0x18,%ebx
801016a3:	81 fb 74 1e 11 80    	cmp    $0x80111e74,%ebx
801016a9:	74 25                	je     801016d0 <filealloc+0x50>
    if(f->ref == 0){
801016ab:	8b 43 04             	mov    0x4(%ebx),%eax
801016ae:	85 c0                	test   %eax,%eax
801016b0:	75 ee                	jne    801016a0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801016b2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801016b5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801016bc:	68 e0 14 11 80       	push   $0x801114e0
801016c1:	e8 da 37 00 00       	call   80104ea0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801016c6:	89 d8                	mov    %ebx,%eax
      return f;
801016c8:	83 c4 10             	add    $0x10,%esp
}
801016cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016ce:	c9                   	leave  
801016cf:	c3                   	ret    
  release(&ftable.lock);
801016d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801016d3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801016d5:	68 e0 14 11 80       	push   $0x801114e0
801016da:	e8 c1 37 00 00       	call   80104ea0 <release>
}
801016df:	89 d8                	mov    %ebx,%eax
  return 0;
801016e1:	83 c4 10             	add    $0x10,%esp
}
801016e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016e7:	c9                   	leave  
801016e8:	c3                   	ret    
801016e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801016f0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801016f0:	f3 0f 1e fb          	endbr32 
801016f4:	55                   	push   %ebp
801016f5:	89 e5                	mov    %esp,%ebp
801016f7:	53                   	push   %ebx
801016f8:	83 ec 10             	sub    $0x10,%esp
801016fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801016fe:	68 e0 14 11 80       	push   $0x801114e0
80101703:	e8 d8 36 00 00       	call   80104de0 <acquire>
  if(f->ref < 1)
80101708:	8b 43 04             	mov    0x4(%ebx),%eax
8010170b:	83 c4 10             	add    $0x10,%esp
8010170e:	85 c0                	test   %eax,%eax
80101710:	7e 1a                	jle    8010172c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101712:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101715:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101718:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010171b:	68 e0 14 11 80       	push   $0x801114e0
80101720:	e8 7b 37 00 00       	call   80104ea0 <release>
  return f;
}
80101725:	89 d8                	mov    %ebx,%eax
80101727:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010172a:	c9                   	leave  
8010172b:	c3                   	ret    
    panic("filedup");
8010172c:	83 ec 0c             	sub    $0xc,%esp
8010172f:	68 f4 79 10 80       	push   $0x801079f4
80101734:	e8 57 ec ff ff       	call   80100390 <panic>
80101739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101740 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	57                   	push   %edi
80101748:	56                   	push   %esi
80101749:	53                   	push   %ebx
8010174a:	83 ec 28             	sub    $0x28,%esp
8010174d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101750:	68 e0 14 11 80       	push   $0x801114e0
80101755:	e8 86 36 00 00       	call   80104de0 <acquire>
  if(f->ref < 1)
8010175a:	8b 53 04             	mov    0x4(%ebx),%edx
8010175d:	83 c4 10             	add    $0x10,%esp
80101760:	85 d2                	test   %edx,%edx
80101762:	0f 8e a1 00 00 00    	jle    80101809 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101768:	83 ea 01             	sub    $0x1,%edx
8010176b:	89 53 04             	mov    %edx,0x4(%ebx)
8010176e:	75 40                	jne    801017b0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101770:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101774:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101777:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101779:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010177f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101782:	88 45 e7             	mov    %al,-0x19(%ebp)
80101785:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101788:	68 e0 14 11 80       	push   $0x801114e0
  ff = *f;
8010178d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101790:	e8 0b 37 00 00       	call   80104ea0 <release>

  if(ff.type == FD_PIPE)
80101795:	83 c4 10             	add    $0x10,%esp
80101798:	83 ff 01             	cmp    $0x1,%edi
8010179b:	74 53                	je     801017f0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010179d:	83 ff 02             	cmp    $0x2,%edi
801017a0:	74 26                	je     801017c8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801017a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017a5:	5b                   	pop    %ebx
801017a6:	5e                   	pop    %esi
801017a7:	5f                   	pop    %edi
801017a8:	5d                   	pop    %ebp
801017a9:	c3                   	ret    
801017aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801017b0:	c7 45 08 e0 14 11 80 	movl   $0x801114e0,0x8(%ebp)
}
801017b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ba:	5b                   	pop    %ebx
801017bb:	5e                   	pop    %esi
801017bc:	5f                   	pop    %edi
801017bd:	5d                   	pop    %ebp
    release(&ftable.lock);
801017be:	e9 dd 36 00 00       	jmp    80104ea0 <release>
801017c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017c7:	90                   	nop
    begin_op();
801017c8:	e8 e3 1d 00 00       	call   801035b0 <begin_op>
    iput(ff.ip);
801017cd:	83 ec 0c             	sub    $0xc,%esp
801017d0:	ff 75 e0             	pushl  -0x20(%ebp)
801017d3:	e8 38 09 00 00       	call   80102110 <iput>
    end_op();
801017d8:	83 c4 10             	add    $0x10,%esp
}
801017db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017de:	5b                   	pop    %ebx
801017df:	5e                   	pop    %esi
801017e0:	5f                   	pop    %edi
801017e1:	5d                   	pop    %ebp
    end_op();
801017e2:	e9 39 1e 00 00       	jmp    80103620 <end_op>
801017e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017ee:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801017f0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801017f4:	83 ec 08             	sub    $0x8,%esp
801017f7:	53                   	push   %ebx
801017f8:	56                   	push   %esi
801017f9:	e8 82 25 00 00       	call   80103d80 <pipeclose>
801017fe:	83 c4 10             	add    $0x10,%esp
}
80101801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101804:	5b                   	pop    %ebx
80101805:	5e                   	pop    %esi
80101806:	5f                   	pop    %edi
80101807:	5d                   	pop    %ebp
80101808:	c3                   	ret    
    panic("fileclose");
80101809:	83 ec 0c             	sub    $0xc,%esp
8010180c:	68 fc 79 10 80       	push   $0x801079fc
80101811:	e8 7a eb ff ff       	call   80100390 <panic>
80101816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010181d:	8d 76 00             	lea    0x0(%esi),%esi

80101820 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101820:	f3 0f 1e fb          	endbr32 
80101824:	55                   	push   %ebp
80101825:	89 e5                	mov    %esp,%ebp
80101827:	53                   	push   %ebx
80101828:	83 ec 04             	sub    $0x4,%esp
8010182b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010182e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101831:	75 2d                	jne    80101860 <filestat+0x40>
    ilock(f->ip);
80101833:	83 ec 0c             	sub    $0xc,%esp
80101836:	ff 73 10             	pushl  0x10(%ebx)
80101839:	e8 a2 07 00 00       	call   80101fe0 <ilock>
    stati(f->ip, st);
8010183e:	58                   	pop    %eax
8010183f:	5a                   	pop    %edx
80101840:	ff 75 0c             	pushl  0xc(%ebp)
80101843:	ff 73 10             	pushl  0x10(%ebx)
80101846:	e8 65 0a 00 00       	call   801022b0 <stati>
    iunlock(f->ip);
8010184b:	59                   	pop    %ecx
8010184c:	ff 73 10             	pushl  0x10(%ebx)
8010184f:	e8 6c 08 00 00       	call   801020c0 <iunlock>
    return 0;
  }
  return -1;
}
80101854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101857:	83 c4 10             	add    $0x10,%esp
8010185a:	31 c0                	xor    %eax,%eax
}
8010185c:	c9                   	leave  
8010185d:	c3                   	ret    
8010185e:	66 90                	xchg   %ax,%ax
80101860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101863:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101868:	c9                   	leave  
80101869:	c3                   	ret    
8010186a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101870 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101870:	f3 0f 1e fb          	endbr32 
80101874:	55                   	push   %ebp
80101875:	89 e5                	mov    %esp,%ebp
80101877:	57                   	push   %edi
80101878:	56                   	push   %esi
80101879:	53                   	push   %ebx
8010187a:	83 ec 0c             	sub    $0xc,%esp
8010187d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101880:	8b 75 0c             	mov    0xc(%ebp),%esi
80101883:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101886:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010188a:	74 64                	je     801018f0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010188c:	8b 03                	mov    (%ebx),%eax
8010188e:	83 f8 01             	cmp    $0x1,%eax
80101891:	74 45                	je     801018d8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101893:	83 f8 02             	cmp    $0x2,%eax
80101896:	75 5f                	jne    801018f7 <fileread+0x87>
    ilock(f->ip);
80101898:	83 ec 0c             	sub    $0xc,%esp
8010189b:	ff 73 10             	pushl  0x10(%ebx)
8010189e:	e8 3d 07 00 00       	call   80101fe0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801018a3:	57                   	push   %edi
801018a4:	ff 73 14             	pushl  0x14(%ebx)
801018a7:	56                   	push   %esi
801018a8:	ff 73 10             	pushl  0x10(%ebx)
801018ab:	e8 30 0a 00 00       	call   801022e0 <readi>
801018b0:	83 c4 20             	add    $0x20,%esp
801018b3:	89 c6                	mov    %eax,%esi
801018b5:	85 c0                	test   %eax,%eax
801018b7:	7e 03                	jle    801018bc <fileread+0x4c>
      f->off += r;
801018b9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801018bc:	83 ec 0c             	sub    $0xc,%esp
801018bf:	ff 73 10             	pushl  0x10(%ebx)
801018c2:	e8 f9 07 00 00       	call   801020c0 <iunlock>
    return r;
801018c7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801018ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018cd:	89 f0                	mov    %esi,%eax
801018cf:	5b                   	pop    %ebx
801018d0:	5e                   	pop    %esi
801018d1:	5f                   	pop    %edi
801018d2:	5d                   	pop    %ebp
801018d3:	c3                   	ret    
801018d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801018d8:	8b 43 0c             	mov    0xc(%ebx),%eax
801018db:	89 45 08             	mov    %eax,0x8(%ebp)
}
801018de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e1:	5b                   	pop    %ebx
801018e2:	5e                   	pop    %esi
801018e3:	5f                   	pop    %edi
801018e4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801018e5:	e9 36 26 00 00       	jmp    80103f20 <piperead>
801018ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801018f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801018f5:	eb d3                	jmp    801018ca <fileread+0x5a>
  panic("fileread");
801018f7:	83 ec 0c             	sub    $0xc,%esp
801018fa:	68 06 7a 10 80       	push   $0x80107a06
801018ff:	e8 8c ea ff ff       	call   80100390 <panic>
80101904:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010190b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010190f:	90                   	nop

80101910 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101910:	f3 0f 1e fb          	endbr32 
80101914:	55                   	push   %ebp
80101915:	89 e5                	mov    %esp,%ebp
80101917:	57                   	push   %edi
80101918:	56                   	push   %esi
80101919:	53                   	push   %ebx
8010191a:	83 ec 1c             	sub    $0x1c,%esp
8010191d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101920:	8b 75 08             	mov    0x8(%ebp),%esi
80101923:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101926:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101929:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010192d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101930:	0f 84 c1 00 00 00    	je     801019f7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101936:	8b 06                	mov    (%esi),%eax
80101938:	83 f8 01             	cmp    $0x1,%eax
8010193b:	0f 84 c3 00 00 00    	je     80101a04 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101941:	83 f8 02             	cmp    $0x2,%eax
80101944:	0f 85 cc 00 00 00    	jne    80101a16 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010194a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010194d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010194f:	85 c0                	test   %eax,%eax
80101951:	7f 34                	jg     80101987 <filewrite+0x77>
80101953:	e9 98 00 00 00       	jmp    801019f0 <filewrite+0xe0>
80101958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010195f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101960:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101963:	83 ec 0c             	sub    $0xc,%esp
80101966:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101969:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010196c:	e8 4f 07 00 00       	call   801020c0 <iunlock>
      end_op();
80101971:	e8 aa 1c 00 00       	call   80103620 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101976:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101979:	83 c4 10             	add    $0x10,%esp
8010197c:	39 c3                	cmp    %eax,%ebx
8010197e:	75 60                	jne    801019e0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101980:	01 df                	add    %ebx,%edi
    while(i < n){
80101982:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101985:	7e 69                	jle    801019f0 <filewrite+0xe0>
      int n1 = n - i;
80101987:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010198a:	b8 00 06 00 00       	mov    $0x600,%eax
8010198f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101991:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101997:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010199a:	e8 11 1c 00 00       	call   801035b0 <begin_op>
      ilock(f->ip);
8010199f:	83 ec 0c             	sub    $0xc,%esp
801019a2:	ff 76 10             	pushl  0x10(%esi)
801019a5:	e8 36 06 00 00       	call   80101fe0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801019aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801019ad:	53                   	push   %ebx
801019ae:	ff 76 14             	pushl  0x14(%esi)
801019b1:	01 f8                	add    %edi,%eax
801019b3:	50                   	push   %eax
801019b4:	ff 76 10             	pushl  0x10(%esi)
801019b7:	e8 24 0a 00 00       	call   801023e0 <writei>
801019bc:	83 c4 20             	add    $0x20,%esp
801019bf:	85 c0                	test   %eax,%eax
801019c1:	7f 9d                	jg     80101960 <filewrite+0x50>
      iunlock(f->ip);
801019c3:	83 ec 0c             	sub    $0xc,%esp
801019c6:	ff 76 10             	pushl  0x10(%esi)
801019c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801019cc:	e8 ef 06 00 00       	call   801020c0 <iunlock>
      end_op();
801019d1:	e8 4a 1c 00 00       	call   80103620 <end_op>
      if(r < 0)
801019d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019d9:	83 c4 10             	add    $0x10,%esp
801019dc:	85 c0                	test   %eax,%eax
801019de:	75 17                	jne    801019f7 <filewrite+0xe7>
        panic("short filewrite");
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	68 0f 7a 10 80       	push   $0x80107a0f
801019e8:	e8 a3 e9 ff ff       	call   80100390 <panic>
801019ed:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801019f0:	89 f8                	mov    %edi,%eax
801019f2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801019f5:	74 05                	je     801019fc <filewrite+0xec>
801019f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801019fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ff:	5b                   	pop    %ebx
80101a00:	5e                   	pop    %esi
80101a01:	5f                   	pop    %edi
80101a02:	5d                   	pop    %ebp
80101a03:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101a04:	8b 46 0c             	mov    0xc(%esi),%eax
80101a07:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101a0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0d:	5b                   	pop    %ebx
80101a0e:	5e                   	pop    %esi
80101a0f:	5f                   	pop    %edi
80101a10:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101a11:	e9 0a 24 00 00       	jmp    80103e20 <pipewrite>
  panic("filewrite");
80101a16:	83 ec 0c             	sub    $0xc,%esp
80101a19:	68 15 7a 10 80       	push   $0x80107a15
80101a1e:	e8 6d e9 ff ff       	call   80100390 <panic>
80101a23:	66 90                	xchg   %ax,%ax
80101a25:	66 90                	xchg   %ax,%ax
80101a27:	66 90                	xchg   %ax,%ax
80101a29:	66 90                	xchg   %ax,%ax
80101a2b:	66 90                	xchg   %ax,%ax
80101a2d:	66 90                	xchg   %ax,%ax
80101a2f:	90                   	nop

80101a30 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101a30:	55                   	push   %ebp
80101a31:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101a33:	89 d0                	mov    %edx,%eax
80101a35:	c1 e8 0c             	shr    $0xc,%eax
80101a38:	03 05 f8 1e 11 80    	add    0x80111ef8,%eax
{
80101a3e:	89 e5                	mov    %esp,%ebp
80101a40:	56                   	push   %esi
80101a41:	53                   	push   %ebx
80101a42:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101a44:	83 ec 08             	sub    $0x8,%esp
80101a47:	50                   	push   %eax
80101a48:	51                   	push   %ecx
80101a49:	e8 82 e6 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101a4e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101a50:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101a53:	ba 01 00 00 00       	mov    $0x1,%edx
80101a58:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101a5b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101a61:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101a64:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101a66:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101a6b:	85 d1                	test   %edx,%ecx
80101a6d:	74 25                	je     80101a94 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101a6f:	f7 d2                	not    %edx
  log_write(bp);
80101a71:	83 ec 0c             	sub    $0xc,%esp
80101a74:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101a76:	21 ca                	and    %ecx,%edx
80101a78:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101a7c:	50                   	push   %eax
80101a7d:	e8 0e 1d 00 00       	call   80103790 <log_write>
  brelse(bp);
80101a82:	89 34 24             	mov    %esi,(%esp)
80101a85:	e8 66 e7 ff ff       	call   801001f0 <brelse>
}
80101a8a:	83 c4 10             	add    $0x10,%esp
80101a8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a90:	5b                   	pop    %ebx
80101a91:	5e                   	pop    %esi
80101a92:	5d                   	pop    %ebp
80101a93:	c3                   	ret    
    panic("freeing free block");
80101a94:	83 ec 0c             	sub    $0xc,%esp
80101a97:	68 1f 7a 10 80       	push   $0x80107a1f
80101a9c:	e8 ef e8 ff ff       	call   80100390 <panic>
80101aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop

80101ab0 <balloc>:
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101ab9:	8b 0d e0 1e 11 80    	mov    0x80111ee0,%ecx
{
80101abf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101ac2:	85 c9                	test   %ecx,%ecx
80101ac4:	0f 84 87 00 00 00    	je     80101b51 <balloc+0xa1>
80101aca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101ad1:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101ad4:	83 ec 08             	sub    $0x8,%esp
80101ad7:	89 f0                	mov    %esi,%eax
80101ad9:	c1 f8 0c             	sar    $0xc,%eax
80101adc:	03 05 f8 1e 11 80    	add    0x80111ef8,%eax
80101ae2:	50                   	push   %eax
80101ae3:	ff 75 d8             	pushl  -0x28(%ebp)
80101ae6:	e8 e5 e5 ff ff       	call   801000d0 <bread>
80101aeb:	83 c4 10             	add    $0x10,%esp
80101aee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101af1:	a1 e0 1e 11 80       	mov    0x80111ee0,%eax
80101af6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101af9:	31 c0                	xor    %eax,%eax
80101afb:	eb 2f                	jmp    80101b2c <balloc+0x7c>
80101afd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101b00:	89 c1                	mov    %eax,%ecx
80101b02:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101b07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101b0a:	83 e1 07             	and    $0x7,%ecx
80101b0d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101b0f:	89 c1                	mov    %eax,%ecx
80101b11:	c1 f9 03             	sar    $0x3,%ecx
80101b14:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101b19:	89 fa                	mov    %edi,%edx
80101b1b:	85 df                	test   %ebx,%edi
80101b1d:	74 41                	je     80101b60 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101b1f:	83 c0 01             	add    $0x1,%eax
80101b22:	83 c6 01             	add    $0x1,%esi
80101b25:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101b2a:	74 05                	je     80101b31 <balloc+0x81>
80101b2c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101b2f:	77 cf                	ja     80101b00 <balloc+0x50>
    brelse(bp);
80101b31:	83 ec 0c             	sub    $0xc,%esp
80101b34:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b37:	e8 b4 e6 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101b3c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101b43:	83 c4 10             	add    $0x10,%esp
80101b46:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b49:	39 05 e0 1e 11 80    	cmp    %eax,0x80111ee0
80101b4f:	77 80                	ja     80101ad1 <balloc+0x21>
  panic("balloc: out of blocks");
80101b51:	83 ec 0c             	sub    $0xc,%esp
80101b54:	68 32 7a 10 80       	push   $0x80107a32
80101b59:	e8 32 e8 ff ff       	call   80100390 <panic>
80101b5e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101b60:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101b63:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101b66:	09 da                	or     %ebx,%edx
80101b68:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101b6c:	57                   	push   %edi
80101b6d:	e8 1e 1c 00 00       	call   80103790 <log_write>
        brelse(bp);
80101b72:	89 3c 24             	mov    %edi,(%esp)
80101b75:	e8 76 e6 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101b7a:	58                   	pop    %eax
80101b7b:	5a                   	pop    %edx
80101b7c:	56                   	push   %esi
80101b7d:	ff 75 d8             	pushl  -0x28(%ebp)
80101b80:	e8 4b e5 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101b85:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101b88:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101b8a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b8d:	68 00 02 00 00       	push   $0x200
80101b92:	6a 00                	push   $0x0
80101b94:	50                   	push   %eax
80101b95:	e8 56 33 00 00       	call   80104ef0 <memset>
  log_write(bp);
80101b9a:	89 1c 24             	mov    %ebx,(%esp)
80101b9d:	e8 ee 1b 00 00       	call   80103790 <log_write>
  brelse(bp);
80101ba2:	89 1c 24             	mov    %ebx,(%esp)
80101ba5:	e8 46 e6 ff ff       	call   801001f0 <brelse>
}
80101baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bad:	89 f0                	mov    %esi,%eax
80101baf:	5b                   	pop    %ebx
80101bb0:	5e                   	pop    %esi
80101bb1:	5f                   	pop    %edi
80101bb2:	5d                   	pop    %ebp
80101bb3:	c3                   	ret    
80101bb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bbf:	90                   	nop

80101bc0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	89 c7                	mov    %eax,%edi
80101bc6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101bc7:	31 f6                	xor    %esi,%esi
{
80101bc9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bca:	bb 34 1f 11 80       	mov    $0x80111f34,%ebx
{
80101bcf:	83 ec 28             	sub    $0x28,%esp
80101bd2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101bd5:	68 00 1f 11 80       	push   $0x80111f00
80101bda:	e8 01 32 00 00       	call   80104de0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	eb 1b                	jmp    80101c02 <iget+0x42>
80101be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bee:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101bf0:	39 3b                	cmp    %edi,(%ebx)
80101bf2:	74 6c                	je     80101c60 <iget+0xa0>
80101bf4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bfa:	81 fb 54 3b 11 80    	cmp    $0x80113b54,%ebx
80101c00:	73 26                	jae    80101c28 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c02:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101c05:	85 c9                	test   %ecx,%ecx
80101c07:	7f e7                	jg     80101bf0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101c09:	85 f6                	test   %esi,%esi
80101c0b:	75 e7                	jne    80101bf4 <iget+0x34>
80101c0d:	89 d8                	mov    %ebx,%eax
80101c0f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101c15:	85 c9                	test   %ecx,%ecx
80101c17:	75 6e                	jne    80101c87 <iget+0xc7>
80101c19:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c1b:	81 fb 54 3b 11 80    	cmp    $0x80113b54,%ebx
80101c21:	72 df                	jb     80101c02 <iget+0x42>
80101c23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c27:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101c28:	85 f6                	test   %esi,%esi
80101c2a:	74 73                	je     80101c9f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101c2c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101c2f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101c31:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101c34:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101c3b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101c42:	68 00 1f 11 80       	push   $0x80111f00
80101c47:	e8 54 32 00 00       	call   80104ea0 <release>

  return ip;
80101c4c:	83 c4 10             	add    $0x10,%esp
}
80101c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c52:	89 f0                	mov    %esi,%eax
80101c54:	5b                   	pop    %ebx
80101c55:	5e                   	pop    %esi
80101c56:	5f                   	pop    %edi
80101c57:	5d                   	pop    %ebp
80101c58:	c3                   	ret    
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c60:	39 53 04             	cmp    %edx,0x4(%ebx)
80101c63:	75 8f                	jne    80101bf4 <iget+0x34>
      release(&icache.lock);
80101c65:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101c68:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101c6b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101c6d:	68 00 1f 11 80       	push   $0x80111f00
      ip->ref++;
80101c72:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101c75:	e8 26 32 00 00       	call   80104ea0 <release>
      return ip;
80101c7a:	83 c4 10             	add    $0x10,%esp
}
80101c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c80:	89 f0                	mov    %esi,%eax
80101c82:	5b                   	pop    %ebx
80101c83:	5e                   	pop    %esi
80101c84:	5f                   	pop    %edi
80101c85:	5d                   	pop    %ebp
80101c86:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c87:	81 fb 54 3b 11 80    	cmp    $0x80113b54,%ebx
80101c8d:	73 10                	jae    80101c9f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c8f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101c92:	85 c9                	test   %ecx,%ecx
80101c94:	0f 8f 56 ff ff ff    	jg     80101bf0 <iget+0x30>
80101c9a:	e9 6e ff ff ff       	jmp    80101c0d <iget+0x4d>
    panic("iget: no inodes");
80101c9f:	83 ec 0c             	sub    $0xc,%esp
80101ca2:	68 48 7a 10 80       	push   $0x80107a48
80101ca7:	e8 e4 e6 ff ff       	call   80100390 <panic>
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	56                   	push   %esi
80101cb5:	89 c6                	mov    %eax,%esi
80101cb7:	53                   	push   %ebx
80101cb8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cbb:	83 fa 0b             	cmp    $0xb,%edx
80101cbe:	0f 86 84 00 00 00    	jbe    80101d48 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101cc4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101cc7:	83 fb 7f             	cmp    $0x7f,%ebx
80101cca:	0f 87 98 00 00 00    	ja     80101d68 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cd0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cd6:	8b 16                	mov    (%esi),%edx
80101cd8:	85 c0                	test   %eax,%eax
80101cda:	74 54                	je     80101d30 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101cdc:	83 ec 08             	sub    $0x8,%esp
80101cdf:	50                   	push   %eax
80101ce0:	52                   	push   %edx
80101ce1:	e8 ea e3 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101ce6:	83 c4 10             	add    $0x10,%esp
80101ce9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
80101ced:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101cef:	8b 1a                	mov    (%edx),%ebx
80101cf1:	85 db                	test   %ebx,%ebx
80101cf3:	74 1b                	je     80101d10 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101cf5:	83 ec 0c             	sub    $0xc,%esp
80101cf8:	57                   	push   %edi
80101cf9:	e8 f2 e4 ff ff       	call   801001f0 <brelse>
    return addr;
80101cfe:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d04:	89 d8                	mov    %ebx,%eax
80101d06:	5b                   	pop    %ebx
80101d07:	5e                   	pop    %esi
80101d08:	5f                   	pop    %edi
80101d09:	5d                   	pop    %ebp
80101d0a:	c3                   	ret    
80101d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d0f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101d10:	8b 06                	mov    (%esi),%eax
80101d12:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d15:	e8 96 fd ff ff       	call   80101ab0 <balloc>
80101d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101d1d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101d20:	89 c3                	mov    %eax,%ebx
80101d22:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d24:	57                   	push   %edi
80101d25:	e8 66 1a 00 00       	call   80103790 <log_write>
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	eb c6                	jmp    80101cf5 <bmap+0x45>
80101d2f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d30:	89 d0                	mov    %edx,%eax
80101d32:	e8 79 fd ff ff       	call   80101ab0 <balloc>
80101d37:	8b 16                	mov    (%esi),%edx
80101d39:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101d3f:	eb 9b                	jmp    80101cdc <bmap+0x2c>
80101d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101d48:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101d4b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101d4e:	85 db                	test   %ebx,%ebx
80101d50:	75 af                	jne    80101d01 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d52:	8b 00                	mov    (%eax),%eax
80101d54:	e8 57 fd ff ff       	call   80101ab0 <balloc>
80101d59:	89 47 5c             	mov    %eax,0x5c(%edi)
80101d5c:	89 c3                	mov    %eax,%ebx
}
80101d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d61:	89 d8                	mov    %ebx,%eax
80101d63:	5b                   	pop    %ebx
80101d64:	5e                   	pop    %esi
80101d65:	5f                   	pop    %edi
80101d66:	5d                   	pop    %ebp
80101d67:	c3                   	ret    
  panic("bmap: out of range");
80101d68:	83 ec 0c             	sub    $0xc,%esp
80101d6b:	68 58 7a 10 80       	push   $0x80107a58
80101d70:	e8 1b e6 ff ff       	call   80100390 <panic>
80101d75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d80 <readsb>:
{
80101d80:	f3 0f 1e fb          	endbr32 
80101d84:	55                   	push   %ebp
80101d85:	89 e5                	mov    %esp,%ebp
80101d87:	56                   	push   %esi
80101d88:	53                   	push   %ebx
80101d89:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101d8c:	83 ec 08             	sub    $0x8,%esp
80101d8f:	6a 01                	push   $0x1
80101d91:	ff 75 08             	pushl  0x8(%ebp)
80101d94:	e8 37 e3 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101d99:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101d9c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101d9e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101da1:	6a 1c                	push   $0x1c
80101da3:	50                   	push   %eax
80101da4:	56                   	push   %esi
80101da5:	e8 e6 31 00 00       	call   80104f90 <memmove>
  brelse(bp);
80101daa:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101dad:	83 c4 10             	add    $0x10,%esp
}
80101db0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101db3:	5b                   	pop    %ebx
80101db4:	5e                   	pop    %esi
80101db5:	5d                   	pop    %ebp
  brelse(bp);
80101db6:	e9 35 e4 ff ff       	jmp    801001f0 <brelse>
80101dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dbf:	90                   	nop

80101dc0 <iinit>:
{
80101dc0:	f3 0f 1e fb          	endbr32 
80101dc4:	55                   	push   %ebp
80101dc5:	89 e5                	mov    %esp,%ebp
80101dc7:	53                   	push   %ebx
80101dc8:	bb 40 1f 11 80       	mov    $0x80111f40,%ebx
80101dcd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101dd0:	68 6b 7a 10 80       	push   $0x80107a6b
80101dd5:	68 00 1f 11 80       	push   $0x80111f00
80101dda:	e8 81 2e 00 00       	call   80104c60 <initlock>
  for(i = 0; i < NINODE; i++) {
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101de8:	83 ec 08             	sub    $0x8,%esp
80101deb:	68 72 7a 10 80       	push   $0x80107a72
80101df0:	53                   	push   %ebx
80101df1:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101df7:	e8 24 2d 00 00       	call   80104b20 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101dfc:	83 c4 10             	add    $0x10,%esp
80101dff:	81 fb 60 3b 11 80    	cmp    $0x80113b60,%ebx
80101e05:	75 e1                	jne    80101de8 <iinit+0x28>
  readsb(dev, &sb);
80101e07:	83 ec 08             	sub    $0x8,%esp
80101e0a:	68 e0 1e 11 80       	push   $0x80111ee0
80101e0f:	ff 75 08             	pushl  0x8(%ebp)
80101e12:	e8 69 ff ff ff       	call   80101d80 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101e17:	ff 35 f8 1e 11 80    	pushl  0x80111ef8
80101e1d:	ff 35 f4 1e 11 80    	pushl  0x80111ef4
80101e23:	ff 35 f0 1e 11 80    	pushl  0x80111ef0
80101e29:	ff 35 ec 1e 11 80    	pushl  0x80111eec
80101e2f:	ff 35 e8 1e 11 80    	pushl  0x80111ee8
80101e35:	ff 35 e4 1e 11 80    	pushl  0x80111ee4
80101e3b:	ff 35 e0 1e 11 80    	pushl  0x80111ee0
80101e41:	68 d8 7a 10 80       	push   $0x80107ad8
80101e46:	e8 05 eb ff ff       	call   80100950 <cprintf>
}
80101e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e4e:	83 c4 30             	add    $0x30,%esp
80101e51:	c9                   	leave  
80101e52:	c3                   	ret    
80101e53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e60 <ialloc>:
{
80101e60:	f3 0f 1e fb          	endbr32 
80101e64:	55                   	push   %ebp
80101e65:	89 e5                	mov    %esp,%ebp
80101e67:	57                   	push   %edi
80101e68:	56                   	push   %esi
80101e69:	53                   	push   %ebx
80101e6a:	83 ec 1c             	sub    $0x1c,%esp
80101e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101e70:	83 3d e8 1e 11 80 01 	cmpl   $0x1,0x80111ee8
{
80101e77:	8b 75 08             	mov    0x8(%ebp),%esi
80101e7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101e7d:	0f 86 8d 00 00 00    	jbe    80101f10 <ialloc+0xb0>
80101e83:	bf 01 00 00 00       	mov    $0x1,%edi
80101e88:	eb 1d                	jmp    80101ea7 <ialloc+0x47>
80101e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101e90:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101e93:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101e96:	53                   	push   %ebx
80101e97:	e8 54 e3 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101e9c:	83 c4 10             	add    $0x10,%esp
80101e9f:	3b 3d e8 1e 11 80    	cmp    0x80111ee8,%edi
80101ea5:	73 69                	jae    80101f10 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101ea7:	89 f8                	mov    %edi,%eax
80101ea9:	83 ec 08             	sub    $0x8,%esp
80101eac:	c1 e8 03             	shr    $0x3,%eax
80101eaf:	03 05 f4 1e 11 80    	add    0x80111ef4,%eax
80101eb5:	50                   	push   %eax
80101eb6:	56                   	push   %esi
80101eb7:	e8 14 e2 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101ebc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101ebf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101ec1:	89 f8                	mov    %edi,%eax
80101ec3:	83 e0 07             	and    $0x7,%eax
80101ec6:	c1 e0 06             	shl    $0x6,%eax
80101ec9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101ecd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101ed1:	75 bd                	jne    80101e90 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101ed3:	83 ec 04             	sub    $0x4,%esp
80101ed6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ed9:	6a 40                	push   $0x40
80101edb:	6a 00                	push   $0x0
80101edd:	51                   	push   %ecx
80101ede:	e8 0d 30 00 00       	call   80104ef0 <memset>
      dip->type = type;
80101ee3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101ee7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eea:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101eed:	89 1c 24             	mov    %ebx,(%esp)
80101ef0:	e8 9b 18 00 00       	call   80103790 <log_write>
      brelse(bp);
80101ef5:	89 1c 24             	mov    %ebx,(%esp)
80101ef8:	e8 f3 e2 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101efd:	83 c4 10             	add    $0x10,%esp
}
80101f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101f03:	89 fa                	mov    %edi,%edx
}
80101f05:	5b                   	pop    %ebx
      return iget(dev, inum);
80101f06:	89 f0                	mov    %esi,%eax
}
80101f08:	5e                   	pop    %esi
80101f09:	5f                   	pop    %edi
80101f0a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101f0b:	e9 b0 fc ff ff       	jmp    80101bc0 <iget>
  panic("ialloc: no inodes");
80101f10:	83 ec 0c             	sub    $0xc,%esp
80101f13:	68 78 7a 10 80       	push   $0x80107a78
80101f18:	e8 73 e4 ff ff       	call   80100390 <panic>
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi

80101f20 <iupdate>:
{
80101f20:	f3 0f 1e fb          	endbr32 
80101f24:	55                   	push   %ebp
80101f25:	89 e5                	mov    %esp,%ebp
80101f27:	56                   	push   %esi
80101f28:	53                   	push   %ebx
80101f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f2c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f2f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f32:	83 ec 08             	sub    $0x8,%esp
80101f35:	c1 e8 03             	shr    $0x3,%eax
80101f38:	03 05 f4 1e 11 80    	add    0x80111ef4,%eax
80101f3e:	50                   	push   %eax
80101f3f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101f42:	e8 89 e1 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101f47:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f4b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f4e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101f50:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101f53:	83 e0 07             	and    $0x7,%eax
80101f56:	c1 e0 06             	shl    $0x6,%eax
80101f59:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101f5d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101f60:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f64:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101f67:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101f6b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101f6f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101f73:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101f77:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101f7b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101f7e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f81:	6a 34                	push   $0x34
80101f83:	53                   	push   %ebx
80101f84:	50                   	push   %eax
80101f85:	e8 06 30 00 00       	call   80104f90 <memmove>
  log_write(bp);
80101f8a:	89 34 24             	mov    %esi,(%esp)
80101f8d:	e8 fe 17 00 00       	call   80103790 <log_write>
  brelse(bp);
80101f92:	89 75 08             	mov    %esi,0x8(%ebp)
80101f95:	83 c4 10             	add    $0x10,%esp
}
80101f98:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5d                   	pop    %ebp
  brelse(bp);
80101f9e:	e9 4d e2 ff ff       	jmp    801001f0 <brelse>
80101fa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fb0 <idup>:
{
80101fb0:	f3 0f 1e fb          	endbr32 
80101fb4:	55                   	push   %ebp
80101fb5:	89 e5                	mov    %esp,%ebp
80101fb7:	53                   	push   %ebx
80101fb8:	83 ec 10             	sub    $0x10,%esp
80101fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101fbe:	68 00 1f 11 80       	push   $0x80111f00
80101fc3:	e8 18 2e 00 00       	call   80104de0 <acquire>
  ip->ref++;
80101fc8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101fcc:	c7 04 24 00 1f 11 80 	movl   $0x80111f00,(%esp)
80101fd3:	e8 c8 2e 00 00       	call   80104ea0 <release>
}
80101fd8:	89 d8                	mov    %ebx,%eax
80101fda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fdd:	c9                   	leave  
80101fde:	c3                   	ret    
80101fdf:	90                   	nop

80101fe0 <ilock>:
{
80101fe0:	f3 0f 1e fb          	endbr32 
80101fe4:	55                   	push   %ebp
80101fe5:	89 e5                	mov    %esp,%ebp
80101fe7:	56                   	push   %esi
80101fe8:	53                   	push   %ebx
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101fec:	85 db                	test   %ebx,%ebx
80101fee:	0f 84 b3 00 00 00    	je     801020a7 <ilock+0xc7>
80101ff4:	8b 53 08             	mov    0x8(%ebx),%edx
80101ff7:	85 d2                	test   %edx,%edx
80101ff9:	0f 8e a8 00 00 00    	jle    801020a7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101fff:	83 ec 0c             	sub    $0xc,%esp
80102002:	8d 43 0c             	lea    0xc(%ebx),%eax
80102005:	50                   	push   %eax
80102006:	e8 55 2b 00 00       	call   80104b60 <acquiresleep>
  if(ip->valid == 0){
8010200b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010200e:	83 c4 10             	add    $0x10,%esp
80102011:	85 c0                	test   %eax,%eax
80102013:	74 0b                	je     80102020 <ilock+0x40>
}
80102015:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102018:	5b                   	pop    %ebx
80102019:	5e                   	pop    %esi
8010201a:	5d                   	pop    %ebp
8010201b:	c3                   	ret    
8010201c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102020:	8b 43 04             	mov    0x4(%ebx),%eax
80102023:	83 ec 08             	sub    $0x8,%esp
80102026:	c1 e8 03             	shr    $0x3,%eax
80102029:	03 05 f4 1e 11 80    	add    0x80111ef4,%eax
8010202f:	50                   	push   %eax
80102030:	ff 33                	pushl  (%ebx)
80102032:	e8 99 e0 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102037:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010203a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010203c:	8b 43 04             	mov    0x4(%ebx),%eax
8010203f:	83 e0 07             	and    $0x7,%eax
80102042:	c1 e0 06             	shl    $0x6,%eax
80102045:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102049:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010204c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010204f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102053:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102057:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010205b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010205f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102063:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102067:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010206b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010206e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102071:	6a 34                	push   $0x34
80102073:	50                   	push   %eax
80102074:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102077:	50                   	push   %eax
80102078:	e8 13 2f 00 00       	call   80104f90 <memmove>
    brelse(bp);
8010207d:	89 34 24             	mov    %esi,(%esp)
80102080:	e8 6b e1 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102085:	83 c4 10             	add    $0x10,%esp
80102088:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010208d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102094:	0f 85 7b ff ff ff    	jne    80102015 <ilock+0x35>
      panic("ilock: no type");
8010209a:	83 ec 0c             	sub    $0xc,%esp
8010209d:	68 90 7a 10 80       	push   $0x80107a90
801020a2:	e8 e9 e2 ff ff       	call   80100390 <panic>
    panic("ilock");
801020a7:	83 ec 0c             	sub    $0xc,%esp
801020aa:	68 8a 7a 10 80       	push   $0x80107a8a
801020af:	e8 dc e2 ff ff       	call   80100390 <panic>
801020b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020bf:	90                   	nop

801020c0 <iunlock>:
{
801020c0:	f3 0f 1e fb          	endbr32 
801020c4:	55                   	push   %ebp
801020c5:	89 e5                	mov    %esp,%ebp
801020c7:	56                   	push   %esi
801020c8:	53                   	push   %ebx
801020c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020cc:	85 db                	test   %ebx,%ebx
801020ce:	74 28                	je     801020f8 <iunlock+0x38>
801020d0:	83 ec 0c             	sub    $0xc,%esp
801020d3:	8d 73 0c             	lea    0xc(%ebx),%esi
801020d6:	56                   	push   %esi
801020d7:	e8 24 2b 00 00       	call   80104c00 <holdingsleep>
801020dc:	83 c4 10             	add    $0x10,%esp
801020df:	85 c0                	test   %eax,%eax
801020e1:	74 15                	je     801020f8 <iunlock+0x38>
801020e3:	8b 43 08             	mov    0x8(%ebx),%eax
801020e6:	85 c0                	test   %eax,%eax
801020e8:	7e 0e                	jle    801020f8 <iunlock+0x38>
  releasesleep(&ip->lock);
801020ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801020ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020f0:	5b                   	pop    %ebx
801020f1:	5e                   	pop    %esi
801020f2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801020f3:	e9 c8 2a 00 00       	jmp    80104bc0 <releasesleep>
    panic("iunlock");
801020f8:	83 ec 0c             	sub    $0xc,%esp
801020fb:	68 9f 7a 10 80       	push   $0x80107a9f
80102100:	e8 8b e2 ff ff       	call   80100390 <panic>
80102105:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102110 <iput>:
{
80102110:	f3 0f 1e fb          	endbr32 
80102114:	55                   	push   %ebp
80102115:	89 e5                	mov    %esp,%ebp
80102117:	57                   	push   %edi
80102118:	56                   	push   %esi
80102119:	53                   	push   %ebx
8010211a:	83 ec 28             	sub    $0x28,%esp
8010211d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102120:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102123:	57                   	push   %edi
80102124:	e8 37 2a 00 00       	call   80104b60 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102129:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010212c:	83 c4 10             	add    $0x10,%esp
8010212f:	85 d2                	test   %edx,%edx
80102131:	74 07                	je     8010213a <iput+0x2a>
80102133:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102138:	74 36                	je     80102170 <iput+0x60>
  releasesleep(&ip->lock);
8010213a:	83 ec 0c             	sub    $0xc,%esp
8010213d:	57                   	push   %edi
8010213e:	e8 7d 2a 00 00       	call   80104bc0 <releasesleep>
  acquire(&icache.lock);
80102143:	c7 04 24 00 1f 11 80 	movl   $0x80111f00,(%esp)
8010214a:	e8 91 2c 00 00       	call   80104de0 <acquire>
  ip->ref--;
8010214f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102153:	83 c4 10             	add    $0x10,%esp
80102156:	c7 45 08 00 1f 11 80 	movl   $0x80111f00,0x8(%ebp)
}
8010215d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102160:	5b                   	pop    %ebx
80102161:	5e                   	pop    %esi
80102162:	5f                   	pop    %edi
80102163:	5d                   	pop    %ebp
  release(&icache.lock);
80102164:	e9 37 2d 00 00       	jmp    80104ea0 <release>
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 00 1f 11 80       	push   $0x80111f00
80102178:	e8 63 2c 00 00       	call   80104de0 <acquire>
    int r = ip->ref;
8010217d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102180:	c7 04 24 00 1f 11 80 	movl   $0x80111f00,(%esp)
80102187:	e8 14 2d 00 00       	call   80104ea0 <release>
    if(r == 1){
8010218c:	83 c4 10             	add    $0x10,%esp
8010218f:	83 fe 01             	cmp    $0x1,%esi
80102192:	75 a6                	jne    8010213a <iput+0x2a>
80102194:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010219a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010219d:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021a0:	89 cf                	mov    %ecx,%edi
801021a2:	eb 0b                	jmp    801021af <iput+0x9f>
801021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801021a8:	83 c6 04             	add    $0x4,%esi
801021ab:	39 fe                	cmp    %edi,%esi
801021ad:	74 19                	je     801021c8 <iput+0xb8>
    if(ip->addrs[i]){
801021af:	8b 16                	mov    (%esi),%edx
801021b1:	85 d2                	test   %edx,%edx
801021b3:	74 f3                	je     801021a8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
801021b5:	8b 03                	mov    (%ebx),%eax
801021b7:	e8 74 f8 ff ff       	call   80101a30 <bfree>
      ip->addrs[i] = 0;
801021bc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801021c2:	eb e4                	jmp    801021a8 <iput+0x98>
801021c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801021c8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801021ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801021d1:	85 c0                	test   %eax,%eax
801021d3:	75 33                	jne    80102208 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801021d5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801021d8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801021df:	53                   	push   %ebx
801021e0:	e8 3b fd ff ff       	call   80101f20 <iupdate>
      ip->type = 0;
801021e5:	31 c0                	xor    %eax,%eax
801021e7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801021eb:	89 1c 24             	mov    %ebx,(%esp)
801021ee:	e8 2d fd ff ff       	call   80101f20 <iupdate>
      ip->valid = 0;
801021f3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801021fa:	83 c4 10             	add    $0x10,%esp
801021fd:	e9 38 ff ff ff       	jmp    8010213a <iput+0x2a>
80102202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102208:	83 ec 08             	sub    $0x8,%esp
8010220b:	50                   	push   %eax
8010220c:	ff 33                	pushl  (%ebx)
8010220e:	e8 bd de ff ff       	call   801000d0 <bread>
80102213:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102216:	83 c4 10             	add    $0x10,%esp
80102219:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010221f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102222:	8d 70 5c             	lea    0x5c(%eax),%esi
80102225:	89 cf                	mov    %ecx,%edi
80102227:	eb 0e                	jmp    80102237 <iput+0x127>
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102230:	83 c6 04             	add    $0x4,%esi
80102233:	39 f7                	cmp    %esi,%edi
80102235:	74 19                	je     80102250 <iput+0x140>
      if(a[j])
80102237:	8b 16                	mov    (%esi),%edx
80102239:	85 d2                	test   %edx,%edx
8010223b:	74 f3                	je     80102230 <iput+0x120>
        bfree(ip->dev, a[j]);
8010223d:	8b 03                	mov    (%ebx),%eax
8010223f:	e8 ec f7 ff ff       	call   80101a30 <bfree>
80102244:	eb ea                	jmp    80102230 <iput+0x120>
80102246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102250:	83 ec 0c             	sub    $0xc,%esp
80102253:	ff 75 e4             	pushl  -0x1c(%ebp)
80102256:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102259:	e8 92 df ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010225e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102264:	8b 03                	mov    (%ebx),%eax
80102266:	e8 c5 f7 ff ff       	call   80101a30 <bfree>
    ip->addrs[NDIRECT] = 0;
8010226b:	83 c4 10             	add    $0x10,%esp
8010226e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102275:	00 00 00 
80102278:	e9 58 ff ff ff       	jmp    801021d5 <iput+0xc5>
8010227d:	8d 76 00             	lea    0x0(%esi),%esi

80102280 <iunlockput>:
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010228e:	53                   	push   %ebx
8010228f:	e8 2c fe ff ff       	call   801020c0 <iunlock>
  iput(ip);
80102294:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102297:	83 c4 10             	add    $0x10,%esp
}
8010229a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010229d:	c9                   	leave  
  iput(ip);
8010229e:	e9 6d fe ff ff       	jmp    80102110 <iput>
801022a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022b0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801022b0:	f3 0f 1e fb          	endbr32 
801022b4:	55                   	push   %ebp
801022b5:	89 e5                	mov    %esp,%ebp
801022b7:	8b 55 08             	mov    0x8(%ebp),%edx
801022ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801022bd:	8b 0a                	mov    (%edx),%ecx
801022bf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801022c2:	8b 4a 04             	mov    0x4(%edx),%ecx
801022c5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801022c8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801022cc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801022cf:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801022d3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801022d7:	8b 52 58             	mov    0x58(%edx),%edx
801022da:	89 50 10             	mov    %edx,0x10(%eax)
}
801022dd:	5d                   	pop    %ebp
801022de:	c3                   	ret    
801022df:	90                   	nop

801022e0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801022e0:	f3 0f 1e fb          	endbr32 
801022e4:	55                   	push   %ebp
801022e5:	89 e5                	mov    %esp,%ebp
801022e7:	57                   	push   %edi
801022e8:	56                   	push   %esi
801022e9:	53                   	push   %ebx
801022ea:	83 ec 1c             	sub    $0x1c,%esp
801022ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
801022f0:	8b 45 08             	mov    0x8(%ebp),%eax
801022f3:	8b 75 10             	mov    0x10(%ebp),%esi
801022f6:	89 7d e0             	mov    %edi,-0x20(%ebp)
801022f9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801022fc:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102301:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102304:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102307:	0f 84 a3 00 00 00    	je     801023b0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
8010230d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102310:	8b 40 58             	mov    0x58(%eax),%eax
80102313:	39 c6                	cmp    %eax,%esi
80102315:	0f 87 b6 00 00 00    	ja     801023d1 <readi+0xf1>
8010231b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010231e:	31 c9                	xor    %ecx,%ecx
80102320:	89 da                	mov    %ebx,%edx
80102322:	01 f2                	add    %esi,%edx
80102324:	0f 92 c1             	setb   %cl
80102327:	89 cf                	mov    %ecx,%edi
80102329:	0f 82 a2 00 00 00    	jb     801023d1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010232f:	89 c1                	mov    %eax,%ecx
80102331:	29 f1                	sub    %esi,%ecx
80102333:	39 d0                	cmp    %edx,%eax
80102335:	0f 43 cb             	cmovae %ebx,%ecx
80102338:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010233b:	85 c9                	test   %ecx,%ecx
8010233d:	74 63                	je     801023a2 <readi+0xc2>
8010233f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102340:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102343:	89 f2                	mov    %esi,%edx
80102345:	c1 ea 09             	shr    $0x9,%edx
80102348:	89 d8                	mov    %ebx,%eax
8010234a:	e8 61 f9 ff ff       	call   80101cb0 <bmap>
8010234f:	83 ec 08             	sub    $0x8,%esp
80102352:	50                   	push   %eax
80102353:	ff 33                	pushl  (%ebx)
80102355:	e8 76 dd ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010235a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010235d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102362:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102365:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102367:	89 f0                	mov    %esi,%eax
80102369:	25 ff 01 00 00       	and    $0x1ff,%eax
8010236e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102370:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102373:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102375:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102379:	39 d9                	cmp    %ebx,%ecx
8010237b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010237e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010237f:	01 df                	add    %ebx,%edi
80102381:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102383:	50                   	push   %eax
80102384:	ff 75 e0             	pushl  -0x20(%ebp)
80102387:	e8 04 2c 00 00       	call   80104f90 <memmove>
    brelse(bp);
8010238c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010238f:	89 14 24             	mov    %edx,(%esp)
80102392:	e8 59 de ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102397:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010239a:	83 c4 10             	add    $0x10,%esp
8010239d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801023a0:	77 9e                	ja     80102340 <readi+0x60>
  }
  return n;
801023a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801023a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023a8:	5b                   	pop    %ebx
801023a9:	5e                   	pop    %esi
801023aa:	5f                   	pop    %edi
801023ab:	5d                   	pop    %ebp
801023ac:	c3                   	ret    
801023ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801023b0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801023b4:	66 83 f8 09          	cmp    $0x9,%ax
801023b8:	77 17                	ja     801023d1 <readi+0xf1>
801023ba:	8b 04 c5 80 1e 11 80 	mov    -0x7feee180(,%eax,8),%eax
801023c1:	85 c0                	test   %eax,%eax
801023c3:	74 0c                	je     801023d1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801023c5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801023c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023cb:	5b                   	pop    %ebx
801023cc:	5e                   	pop    %esi
801023cd:	5f                   	pop    %edi
801023ce:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801023cf:	ff e0                	jmp    *%eax
      return -1;
801023d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023d6:	eb cd                	jmp    801023a5 <readi+0xc5>
801023d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023df:	90                   	nop

801023e0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801023e0:	f3 0f 1e fb          	endbr32 
801023e4:	55                   	push   %ebp
801023e5:	89 e5                	mov    %esp,%ebp
801023e7:	57                   	push   %edi
801023e8:	56                   	push   %esi
801023e9:	53                   	push   %ebx
801023ea:	83 ec 1c             	sub    $0x1c,%esp
801023ed:	8b 45 08             	mov    0x8(%ebp),%eax
801023f0:	8b 75 0c             	mov    0xc(%ebp),%esi
801023f3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801023f6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801023fb:	89 75 dc             	mov    %esi,-0x24(%ebp)
801023fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102401:	8b 75 10             	mov    0x10(%ebp),%esi
80102404:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102407:	0f 84 b3 00 00 00    	je     801024c0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010240d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102410:	39 70 58             	cmp    %esi,0x58(%eax)
80102413:	0f 82 e3 00 00 00    	jb     801024fc <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102419:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010241c:	89 f8                	mov    %edi,%eax
8010241e:	01 f0                	add    %esi,%eax
80102420:	0f 82 d6 00 00 00    	jb     801024fc <writei+0x11c>
80102426:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010242b:	0f 87 cb 00 00 00    	ja     801024fc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102431:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102438:	85 ff                	test   %edi,%edi
8010243a:	74 75                	je     801024b1 <writei+0xd1>
8010243c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102440:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102443:	89 f2                	mov    %esi,%edx
80102445:	c1 ea 09             	shr    $0x9,%edx
80102448:	89 f8                	mov    %edi,%eax
8010244a:	e8 61 f8 ff ff       	call   80101cb0 <bmap>
8010244f:	83 ec 08             	sub    $0x8,%esp
80102452:	50                   	push   %eax
80102453:	ff 37                	pushl  (%edi)
80102455:	e8 76 dc ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010245a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010245f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102462:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102465:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102467:	89 f0                	mov    %esi,%eax
80102469:	83 c4 0c             	add    $0xc,%esp
8010246c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102471:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102473:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102477:	39 d9                	cmp    %ebx,%ecx
80102479:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010247c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010247d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010247f:	ff 75 dc             	pushl  -0x24(%ebp)
80102482:	50                   	push   %eax
80102483:	e8 08 2b 00 00       	call   80104f90 <memmove>
    log_write(bp);
80102488:	89 3c 24             	mov    %edi,(%esp)
8010248b:	e8 00 13 00 00       	call   80103790 <log_write>
    brelse(bp);
80102490:	89 3c 24             	mov    %edi,(%esp)
80102493:	e8 58 dd ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102498:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010249b:	83 c4 10             	add    $0x10,%esp
8010249e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801024a1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801024a4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801024a7:	77 97                	ja     80102440 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801024a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801024ac:	3b 70 58             	cmp    0x58(%eax),%esi
801024af:	77 37                	ja     801024e8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801024b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801024b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024b7:	5b                   	pop    %ebx
801024b8:	5e                   	pop    %esi
801024b9:	5f                   	pop    %edi
801024ba:	5d                   	pop    %ebp
801024bb:	c3                   	ret    
801024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801024c0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801024c4:	66 83 f8 09          	cmp    $0x9,%ax
801024c8:	77 32                	ja     801024fc <writei+0x11c>
801024ca:	8b 04 c5 84 1e 11 80 	mov    -0x7feee17c(,%eax,8),%eax
801024d1:	85 c0                	test   %eax,%eax
801024d3:	74 27                	je     801024fc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801024d5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801024d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024db:	5b                   	pop    %ebx
801024dc:	5e                   	pop    %esi
801024dd:	5f                   	pop    %edi
801024de:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801024df:	ff e0                	jmp    *%eax
801024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801024e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801024eb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801024ee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801024f1:	50                   	push   %eax
801024f2:	e8 29 fa ff ff       	call   80101f20 <iupdate>
801024f7:	83 c4 10             	add    $0x10,%esp
801024fa:	eb b5                	jmp    801024b1 <writei+0xd1>
      return -1;
801024fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102501:	eb b1                	jmp    801024b4 <writei+0xd4>
80102503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102510 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010251a:	6a 0e                	push   $0xe
8010251c:	ff 75 0c             	pushl  0xc(%ebp)
8010251f:	ff 75 08             	pushl  0x8(%ebp)
80102522:	e8 d9 2a 00 00       	call   80105000 <strncmp>
}
80102527:	c9                   	leave  
80102528:	c3                   	ret    
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102530 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102530:	f3 0f 1e fb          	endbr32 
80102534:	55                   	push   %ebp
80102535:	89 e5                	mov    %esp,%ebp
80102537:	57                   	push   %edi
80102538:	56                   	push   %esi
80102539:	53                   	push   %ebx
8010253a:	83 ec 1c             	sub    $0x1c,%esp
8010253d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102540:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102545:	0f 85 89 00 00 00    	jne    801025d4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010254b:	8b 53 58             	mov    0x58(%ebx),%edx
8010254e:	31 ff                	xor    %edi,%edi
80102550:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102553:	85 d2                	test   %edx,%edx
80102555:	74 42                	je     80102599 <dirlookup+0x69>
80102557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102560:	6a 10                	push   $0x10
80102562:	57                   	push   %edi
80102563:	56                   	push   %esi
80102564:	53                   	push   %ebx
80102565:	e8 76 fd ff ff       	call   801022e0 <readi>
8010256a:	83 c4 10             	add    $0x10,%esp
8010256d:	83 f8 10             	cmp    $0x10,%eax
80102570:	75 55                	jne    801025c7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102572:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102577:	74 18                	je     80102591 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102579:	83 ec 04             	sub    $0x4,%esp
8010257c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010257f:	6a 0e                	push   $0xe
80102581:	50                   	push   %eax
80102582:	ff 75 0c             	pushl  0xc(%ebp)
80102585:	e8 76 2a 00 00       	call   80105000 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010258a:	83 c4 10             	add    $0x10,%esp
8010258d:	85 c0                	test   %eax,%eax
8010258f:	74 17                	je     801025a8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102591:	83 c7 10             	add    $0x10,%edi
80102594:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102597:	72 c7                	jb     80102560 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102599:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010259c:	31 c0                	xor    %eax,%eax
}
8010259e:	5b                   	pop    %ebx
8010259f:	5e                   	pop    %esi
801025a0:	5f                   	pop    %edi
801025a1:	5d                   	pop    %ebp
801025a2:	c3                   	ret    
801025a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025a7:	90                   	nop
      if(poff)
801025a8:	8b 45 10             	mov    0x10(%ebp),%eax
801025ab:	85 c0                	test   %eax,%eax
801025ad:	74 05                	je     801025b4 <dirlookup+0x84>
        *poff = off;
801025af:	8b 45 10             	mov    0x10(%ebp),%eax
801025b2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801025b4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801025b8:	8b 03                	mov    (%ebx),%eax
801025ba:	e8 01 f6 ff ff       	call   80101bc0 <iget>
}
801025bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025c2:	5b                   	pop    %ebx
801025c3:	5e                   	pop    %esi
801025c4:	5f                   	pop    %edi
801025c5:	5d                   	pop    %ebp
801025c6:	c3                   	ret    
      panic("dirlookup read");
801025c7:	83 ec 0c             	sub    $0xc,%esp
801025ca:	68 b9 7a 10 80       	push   $0x80107ab9
801025cf:	e8 bc dd ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 a7 7a 10 80       	push   $0x80107aa7
801025dc:	e8 af dd ff ff       	call   80100390 <panic>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ef:	90                   	nop

801025f0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	57                   	push   %edi
801025f4:	56                   	push   %esi
801025f5:	53                   	push   %ebx
801025f6:	89 c3                	mov    %eax,%ebx
801025f8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801025fb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801025fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102601:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102604:	0f 84 86 01 00 00    	je     80102790 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010260a:	e8 d1 1b 00 00       	call   801041e0 <myproc>
  acquire(&icache.lock);
8010260f:	83 ec 0c             	sub    $0xc,%esp
80102612:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102614:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102617:	68 00 1f 11 80       	push   $0x80111f00
8010261c:	e8 bf 27 00 00       	call   80104de0 <acquire>
  ip->ref++;
80102621:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102625:	c7 04 24 00 1f 11 80 	movl   $0x80111f00,(%esp)
8010262c:	e8 6f 28 00 00       	call   80104ea0 <release>
80102631:	83 c4 10             	add    $0x10,%esp
80102634:	eb 0d                	jmp    80102643 <namex+0x53>
80102636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102640:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102643:	0f b6 07             	movzbl (%edi),%eax
80102646:	3c 2f                	cmp    $0x2f,%al
80102648:	74 f6                	je     80102640 <namex+0x50>
  if(*path == 0)
8010264a:	84 c0                	test   %al,%al
8010264c:	0f 84 ee 00 00 00    	je     80102740 <namex+0x150>
  while(*path != '/' && *path != 0)
80102652:	0f b6 07             	movzbl (%edi),%eax
80102655:	84 c0                	test   %al,%al
80102657:	0f 84 fb 00 00 00    	je     80102758 <namex+0x168>
8010265d:	89 fb                	mov    %edi,%ebx
8010265f:	3c 2f                	cmp    $0x2f,%al
80102661:	0f 84 f1 00 00 00    	je     80102758 <namex+0x168>
80102667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266e:	66 90                	xchg   %ax,%ax
80102670:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102674:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102677:	3c 2f                	cmp    $0x2f,%al
80102679:	74 04                	je     8010267f <namex+0x8f>
8010267b:	84 c0                	test   %al,%al
8010267d:	75 f1                	jne    80102670 <namex+0x80>
  len = path - s;
8010267f:	89 d8                	mov    %ebx,%eax
80102681:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102683:	83 f8 0d             	cmp    $0xd,%eax
80102686:	0f 8e 84 00 00 00    	jle    80102710 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010268c:	83 ec 04             	sub    $0x4,%esp
8010268f:	6a 0e                	push   $0xe
80102691:	57                   	push   %edi
    path++;
80102692:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102694:	ff 75 e4             	pushl  -0x1c(%ebp)
80102697:	e8 f4 28 00 00       	call   80104f90 <memmove>
8010269c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010269f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801026a2:	75 0c                	jne    801026b0 <namex+0xc0>
801026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801026a8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801026ab:	80 3f 2f             	cmpb   $0x2f,(%edi)
801026ae:	74 f8                	je     801026a8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	56                   	push   %esi
801026b4:	e8 27 f9 ff ff       	call   80101fe0 <ilock>
    if(ip->type != T_DIR){
801026b9:	83 c4 10             	add    $0x10,%esp
801026bc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801026c1:	0f 85 a1 00 00 00    	jne    80102768 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801026c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801026ca:	85 d2                	test   %edx,%edx
801026cc:	74 09                	je     801026d7 <namex+0xe7>
801026ce:	80 3f 00             	cmpb   $0x0,(%edi)
801026d1:	0f 84 d9 00 00 00    	je     801027b0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801026d7:	83 ec 04             	sub    $0x4,%esp
801026da:	6a 00                	push   $0x0
801026dc:	ff 75 e4             	pushl  -0x1c(%ebp)
801026df:	56                   	push   %esi
801026e0:	e8 4b fe ff ff       	call   80102530 <dirlookup>
801026e5:	83 c4 10             	add    $0x10,%esp
801026e8:	89 c3                	mov    %eax,%ebx
801026ea:	85 c0                	test   %eax,%eax
801026ec:	74 7a                	je     80102768 <namex+0x178>
  iunlock(ip);
801026ee:	83 ec 0c             	sub    $0xc,%esp
801026f1:	56                   	push   %esi
801026f2:	e8 c9 f9 ff ff       	call   801020c0 <iunlock>
  iput(ip);
801026f7:	89 34 24             	mov    %esi,(%esp)
801026fa:	89 de                	mov    %ebx,%esi
801026fc:	e8 0f fa ff ff       	call   80102110 <iput>
80102701:	83 c4 10             	add    $0x10,%esp
80102704:	e9 3a ff ff ff       	jmp    80102643 <namex+0x53>
80102709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102710:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102713:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102716:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102719:	83 ec 04             	sub    $0x4,%esp
8010271c:	50                   	push   %eax
8010271d:	57                   	push   %edi
    name[len] = 0;
8010271e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102720:	ff 75 e4             	pushl  -0x1c(%ebp)
80102723:	e8 68 28 00 00       	call   80104f90 <memmove>
    name[len] = 0;
80102728:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010272b:	83 c4 10             	add    $0x10,%esp
8010272e:	c6 00 00             	movb   $0x0,(%eax)
80102731:	e9 69 ff ff ff       	jmp    8010269f <namex+0xaf>
80102736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102740:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102743:	85 c0                	test   %eax,%eax
80102745:	0f 85 85 00 00 00    	jne    801027d0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010274b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010274e:	89 f0                	mov    %esi,%eax
80102750:	5b                   	pop    %ebx
80102751:	5e                   	pop    %esi
80102752:	5f                   	pop    %edi
80102753:	5d                   	pop    %ebp
80102754:	c3                   	ret    
80102755:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010275b:	89 fb                	mov    %edi,%ebx
8010275d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102760:	31 c0                	xor    %eax,%eax
80102762:	eb b5                	jmp    80102719 <namex+0x129>
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102768:	83 ec 0c             	sub    $0xc,%esp
8010276b:	56                   	push   %esi
8010276c:	e8 4f f9 ff ff       	call   801020c0 <iunlock>
  iput(ip);
80102771:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102774:	31 f6                	xor    %esi,%esi
  iput(ip);
80102776:	e8 95 f9 ff ff       	call   80102110 <iput>
      return 0;
8010277b:	83 c4 10             	add    $0x10,%esp
}
8010277e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102781:	89 f0                	mov    %esi,%eax
80102783:	5b                   	pop    %ebx
80102784:	5e                   	pop    %esi
80102785:	5f                   	pop    %edi
80102786:	5d                   	pop    %ebp
80102787:	c3                   	ret    
80102788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102790:	ba 01 00 00 00       	mov    $0x1,%edx
80102795:	b8 01 00 00 00       	mov    $0x1,%eax
8010279a:	89 df                	mov    %ebx,%edi
8010279c:	e8 1f f4 ff ff       	call   80101bc0 <iget>
801027a1:	89 c6                	mov    %eax,%esi
801027a3:	e9 9b fe ff ff       	jmp    80102643 <namex+0x53>
801027a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027af:	90                   	nop
      iunlock(ip);
801027b0:	83 ec 0c             	sub    $0xc,%esp
801027b3:	56                   	push   %esi
801027b4:	e8 07 f9 ff ff       	call   801020c0 <iunlock>
      return ip;
801027b9:	83 c4 10             	add    $0x10,%esp
}
801027bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027bf:	89 f0                	mov    %esi,%eax
801027c1:	5b                   	pop    %ebx
801027c2:	5e                   	pop    %esi
801027c3:	5f                   	pop    %edi
801027c4:	5d                   	pop    %ebp
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	56                   	push   %esi
    return 0;
801027d4:	31 f6                	xor    %esi,%esi
    iput(ip);
801027d6:	e8 35 f9 ff ff       	call   80102110 <iput>
    return 0;
801027db:	83 c4 10             	add    $0x10,%esp
801027de:	e9 68 ff ff ff       	jmp    8010274b <namex+0x15b>
801027e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027f0 <dirlink>:
{
801027f0:	f3 0f 1e fb          	endbr32 
801027f4:	55                   	push   %ebp
801027f5:	89 e5                	mov    %esp,%ebp
801027f7:	57                   	push   %edi
801027f8:	56                   	push   %esi
801027f9:	53                   	push   %ebx
801027fa:	83 ec 20             	sub    $0x20,%esp
801027fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102800:	6a 00                	push   $0x0
80102802:	ff 75 0c             	pushl  0xc(%ebp)
80102805:	53                   	push   %ebx
80102806:	e8 25 fd ff ff       	call   80102530 <dirlookup>
8010280b:	83 c4 10             	add    $0x10,%esp
8010280e:	85 c0                	test   %eax,%eax
80102810:	75 6b                	jne    8010287d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102812:	8b 7b 58             	mov    0x58(%ebx),%edi
80102815:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102818:	85 ff                	test   %edi,%edi
8010281a:	74 2d                	je     80102849 <dirlink+0x59>
8010281c:	31 ff                	xor    %edi,%edi
8010281e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102821:	eb 0d                	jmp    80102830 <dirlink+0x40>
80102823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102827:	90                   	nop
80102828:	83 c7 10             	add    $0x10,%edi
8010282b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010282e:	73 19                	jae    80102849 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102830:	6a 10                	push   $0x10
80102832:	57                   	push   %edi
80102833:	56                   	push   %esi
80102834:	53                   	push   %ebx
80102835:	e8 a6 fa ff ff       	call   801022e0 <readi>
8010283a:	83 c4 10             	add    $0x10,%esp
8010283d:	83 f8 10             	cmp    $0x10,%eax
80102840:	75 4e                	jne    80102890 <dirlink+0xa0>
    if(de.inum == 0)
80102842:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102847:	75 df                	jne    80102828 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102849:	83 ec 04             	sub    $0x4,%esp
8010284c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010284f:	6a 0e                	push   $0xe
80102851:	ff 75 0c             	pushl  0xc(%ebp)
80102854:	50                   	push   %eax
80102855:	e8 f6 27 00 00       	call   80105050 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010285a:	6a 10                	push   $0x10
  de.inum = inum;
8010285c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010285f:	57                   	push   %edi
80102860:	56                   	push   %esi
80102861:	53                   	push   %ebx
  de.inum = inum;
80102862:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102866:	e8 75 fb ff ff       	call   801023e0 <writei>
8010286b:	83 c4 20             	add    $0x20,%esp
8010286e:	83 f8 10             	cmp    $0x10,%eax
80102871:	75 2a                	jne    8010289d <dirlink+0xad>
  return 0;
80102873:	31 c0                	xor    %eax,%eax
}
80102875:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102878:	5b                   	pop    %ebx
80102879:	5e                   	pop    %esi
8010287a:	5f                   	pop    %edi
8010287b:	5d                   	pop    %ebp
8010287c:	c3                   	ret    
    iput(ip);
8010287d:	83 ec 0c             	sub    $0xc,%esp
80102880:	50                   	push   %eax
80102881:	e8 8a f8 ff ff       	call   80102110 <iput>
    return -1;
80102886:	83 c4 10             	add    $0x10,%esp
80102889:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010288e:	eb e5                	jmp    80102875 <dirlink+0x85>
      panic("dirlink read");
80102890:	83 ec 0c             	sub    $0xc,%esp
80102893:	68 c8 7a 10 80       	push   $0x80107ac8
80102898:	e8 f3 da ff ff       	call   80100390 <panic>
    panic("dirlink");
8010289d:	83 ec 0c             	sub    $0xc,%esp
801028a0:	68 9e 80 10 80       	push   $0x8010809e
801028a5:	e8 e6 da ff ff       	call   80100390 <panic>
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028b0 <namei>:

struct inode*
namei(char *path)
{
801028b0:	f3 0f 1e fb          	endbr32 
801028b4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801028b5:	31 d2                	xor    %edx,%edx
{
801028b7:	89 e5                	mov    %esp,%ebp
801028b9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801028bc:	8b 45 08             	mov    0x8(%ebp),%eax
801028bf:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801028c2:	e8 29 fd ff ff       	call   801025f0 <namex>
}
801028c7:	c9                   	leave  
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801028d0:	f3 0f 1e fb          	endbr32 
801028d4:	55                   	push   %ebp
  return namex(path, 1, name);
801028d5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801028da:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801028dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028df:	8b 45 08             	mov    0x8(%ebp),%eax
}
801028e2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801028e3:	e9 08 fd ff ff       	jmp    801025f0 <namex>
801028e8:	66 90                	xchg   %ax,%ax
801028ea:	66 90                	xchg   %ax,%ax
801028ec:	66 90                	xchg   %ax,%ax
801028ee:	66 90                	xchg   %ax,%ax

801028f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	57                   	push   %edi
801028f4:	56                   	push   %esi
801028f5:	53                   	push   %ebx
801028f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801028f9:	85 c0                	test   %eax,%eax
801028fb:	0f 84 b4 00 00 00    	je     801029b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102901:	8b 70 08             	mov    0x8(%eax),%esi
80102904:	89 c3                	mov    %eax,%ebx
80102906:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010290c:	0f 87 96 00 00 00    	ja     801029a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102912:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291e:	66 90                	xchg   %ax,%ax
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102923:	83 e0 c0             	and    $0xffffffc0,%eax
80102926:	3c 40                	cmp    $0x40,%al
80102928:	75 f6                	jne    80102920 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292a:	31 ff                	xor    %edi,%edi
8010292c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102931:	89 f8                	mov    %edi,%eax
80102933:	ee                   	out    %al,(%dx)
80102934:	b8 01 00 00 00       	mov    $0x1,%eax
80102939:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010293e:	ee                   	out    %al,(%dx)
8010293f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102944:	89 f0                	mov    %esi,%eax
80102946:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102947:	89 f0                	mov    %esi,%eax
80102949:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010294e:	c1 f8 08             	sar    $0x8,%eax
80102951:	ee                   	out    %al,(%dx)
80102952:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102957:	89 f8                	mov    %edi,%eax
80102959:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010295a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010295e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102963:	c1 e0 04             	shl    $0x4,%eax
80102966:	83 e0 10             	and    $0x10,%eax
80102969:	83 c8 e0             	or     $0xffffffe0,%eax
8010296c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010296d:	f6 03 04             	testb  $0x4,(%ebx)
80102970:	75 16                	jne    80102988 <idestart+0x98>
80102972:	b8 20 00 00 00       	mov    $0x20,%eax
80102977:	89 ca                	mov    %ecx,%edx
80102979:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010297a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010297d:	5b                   	pop    %ebx
8010297e:	5e                   	pop    %esi
8010297f:	5f                   	pop    %edi
80102980:	5d                   	pop    %ebp
80102981:	c3                   	ret    
80102982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102988:	b8 30 00 00 00       	mov    $0x30,%eax
8010298d:	89 ca                	mov    %ecx,%edx
8010298f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102990:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102995:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102998:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010299d:	fc                   	cld    
8010299e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801029a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029a3:	5b                   	pop    %ebx
801029a4:	5e                   	pop    %esi
801029a5:	5f                   	pop    %edi
801029a6:	5d                   	pop    %ebp
801029a7:	c3                   	ret    
    panic("incorrect blockno");
801029a8:	83 ec 0c             	sub    $0xc,%esp
801029ab:	68 34 7b 10 80       	push   $0x80107b34
801029b0:	e8 db d9 ff ff       	call   80100390 <panic>
    panic("idestart");
801029b5:	83 ec 0c             	sub    $0xc,%esp
801029b8:	68 2b 7b 10 80       	push   $0x80107b2b
801029bd:	e8 ce d9 ff ff       	call   80100390 <panic>
801029c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029d0 <ideinit>:
{
801029d0:	f3 0f 1e fb          	endbr32 
801029d4:	55                   	push   %ebp
801029d5:	89 e5                	mov    %esp,%ebp
801029d7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801029da:	68 46 7b 10 80       	push   $0x80107b46
801029df:	68 80 b5 10 80       	push   $0x8010b580
801029e4:	e8 77 22 00 00       	call   80104c60 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801029e9:	58                   	pop    %eax
801029ea:	a1 20 42 11 80       	mov    0x80114220,%eax
801029ef:	5a                   	pop    %edx
801029f0:	83 e8 01             	sub    $0x1,%eax
801029f3:	50                   	push   %eax
801029f4:	6a 0e                	push   $0xe
801029f6:	e8 b5 02 00 00       	call   80102cb0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801029fb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a07:	90                   	nop
80102a08:	ec                   	in     (%dx),%al
80102a09:	83 e0 c0             	and    $0xffffffc0,%eax
80102a0c:	3c 40                	cmp    $0x40,%al
80102a0e:	75 f8                	jne    80102a08 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a10:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102a15:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a1a:	ee                   	out    %al,(%dx)
80102a1b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a20:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a25:	eb 0e                	jmp    80102a35 <ideinit+0x65>
80102a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a2e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102a30:	83 e9 01             	sub    $0x1,%ecx
80102a33:	74 0f                	je     80102a44 <ideinit+0x74>
80102a35:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102a36:	84 c0                	test   %al,%al
80102a38:	74 f6                	je     80102a30 <ideinit+0x60>
      havedisk1 = 1;
80102a3a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102a41:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a44:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102a49:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a4e:	ee                   	out    %al,(%dx)
}
80102a4f:	c9                   	leave  
80102a50:	c3                   	ret    
80102a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5f:	90                   	nop

80102a60 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102a60:	f3 0f 1e fb          	endbr32 
80102a64:	55                   	push   %ebp
80102a65:	89 e5                	mov    %esp,%ebp
80102a67:	57                   	push   %edi
80102a68:	56                   	push   %esi
80102a69:	53                   	push   %ebx
80102a6a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102a6d:	68 80 b5 10 80       	push   $0x8010b580
80102a72:	e8 69 23 00 00       	call   80104de0 <acquire>

  if((b = idequeue) == 0){
80102a77:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102a7d:	83 c4 10             	add    $0x10,%esp
80102a80:	85 db                	test   %ebx,%ebx
80102a82:	74 5f                	je     80102ae3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102a84:	8b 43 58             	mov    0x58(%ebx),%eax
80102a87:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a8c:	8b 33                	mov    (%ebx),%esi
80102a8e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102a94:	75 2b                	jne    80102ac1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a96:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop
80102aa0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102aa1:	89 c1                	mov    %eax,%ecx
80102aa3:	83 e1 c0             	and    $0xffffffc0,%ecx
80102aa6:	80 f9 40             	cmp    $0x40,%cl
80102aa9:	75 f5                	jne    80102aa0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102aab:	a8 21                	test   $0x21,%al
80102aad:	75 12                	jne    80102ac1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102aaf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102ab2:	b9 80 00 00 00       	mov    $0x80,%ecx
80102ab7:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102abc:	fc                   	cld    
80102abd:	f3 6d                	rep insl (%dx),%es:(%edi)
80102abf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102ac1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102ac4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102ac7:	83 ce 02             	or     $0x2,%esi
80102aca:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102acc:	53                   	push   %ebx
80102acd:	e8 8e 1e 00 00       	call   80104960 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102ad2:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102ad7:	83 c4 10             	add    $0x10,%esp
80102ada:	85 c0                	test   %eax,%eax
80102adc:	74 05                	je     80102ae3 <ideintr+0x83>
    idestart(idequeue);
80102ade:	e8 0d fe ff ff       	call   801028f0 <idestart>
    release(&idelock);
80102ae3:	83 ec 0c             	sub    $0xc,%esp
80102ae6:	68 80 b5 10 80       	push   $0x8010b580
80102aeb:	e8 b0 23 00 00       	call   80104ea0 <release>

  release(&idelock);
}
80102af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102af3:	5b                   	pop    %ebx
80102af4:	5e                   	pop    %esi
80102af5:	5f                   	pop    %edi
80102af6:	5d                   	pop    %ebp
80102af7:	c3                   	ret    
80102af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aff:	90                   	nop

80102b00 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102b00:	f3 0f 1e fb          	endbr32 
80102b04:	55                   	push   %ebp
80102b05:	89 e5                	mov    %esp,%ebp
80102b07:	53                   	push   %ebx
80102b08:	83 ec 10             	sub    $0x10,%esp
80102b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102b0e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102b11:	50                   	push   %eax
80102b12:	e8 e9 20 00 00       	call   80104c00 <holdingsleep>
80102b17:	83 c4 10             	add    $0x10,%esp
80102b1a:	85 c0                	test   %eax,%eax
80102b1c:	0f 84 cf 00 00 00    	je     80102bf1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102b22:	8b 03                	mov    (%ebx),%eax
80102b24:	83 e0 06             	and    $0x6,%eax
80102b27:	83 f8 02             	cmp    $0x2,%eax
80102b2a:	0f 84 b4 00 00 00    	je     80102be4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102b30:	8b 53 04             	mov    0x4(%ebx),%edx
80102b33:	85 d2                	test   %edx,%edx
80102b35:	74 0d                	je     80102b44 <iderw+0x44>
80102b37:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102b3c:	85 c0                	test   %eax,%eax
80102b3e:	0f 84 93 00 00 00    	je     80102bd7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102b44:	83 ec 0c             	sub    $0xc,%esp
80102b47:	68 80 b5 10 80       	push   $0x8010b580
80102b4c:	e8 8f 22 00 00       	call   80104de0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b51:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102b56:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b5d:	83 c4 10             	add    $0x10,%esp
80102b60:	85 c0                	test   %eax,%eax
80102b62:	74 6c                	je     80102bd0 <iderw+0xd0>
80102b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b68:	89 c2                	mov    %eax,%edx
80102b6a:	8b 40 58             	mov    0x58(%eax),%eax
80102b6d:	85 c0                	test   %eax,%eax
80102b6f:	75 f7                	jne    80102b68 <iderw+0x68>
80102b71:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102b74:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102b76:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102b7c:	74 42                	je     80102bc0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b7e:	8b 03                	mov    (%ebx),%eax
80102b80:	83 e0 06             	and    $0x6,%eax
80102b83:	83 f8 02             	cmp    $0x2,%eax
80102b86:	74 23                	je     80102bab <iderw+0xab>
80102b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b8f:	90                   	nop
    sleep(b, &idelock);
80102b90:	83 ec 08             	sub    $0x8,%esp
80102b93:	68 80 b5 10 80       	push   $0x8010b580
80102b98:	53                   	push   %ebx
80102b99:	e8 02 1c 00 00       	call   801047a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b9e:	8b 03                	mov    (%ebx),%eax
80102ba0:	83 c4 10             	add    $0x10,%esp
80102ba3:	83 e0 06             	and    $0x6,%eax
80102ba6:	83 f8 02             	cmp    $0x2,%eax
80102ba9:	75 e5                	jne    80102b90 <iderw+0x90>
  }


  release(&idelock);
80102bab:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bb5:	c9                   	leave  
  release(&idelock);
80102bb6:	e9 e5 22 00 00       	jmp    80104ea0 <release>
80102bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bbf:	90                   	nop
    idestart(b);
80102bc0:	89 d8                	mov    %ebx,%eax
80102bc2:	e8 29 fd ff ff       	call   801028f0 <idestart>
80102bc7:	eb b5                	jmp    80102b7e <iderw+0x7e>
80102bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102bd0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102bd5:	eb 9d                	jmp    80102b74 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102bd7:	83 ec 0c             	sub    $0xc,%esp
80102bda:	68 75 7b 10 80       	push   $0x80107b75
80102bdf:	e8 ac d7 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102be4:	83 ec 0c             	sub    $0xc,%esp
80102be7:	68 60 7b 10 80       	push   $0x80107b60
80102bec:	e8 9f d7 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102bf1:	83 ec 0c             	sub    $0xc,%esp
80102bf4:	68 4a 7b 10 80       	push   $0x80107b4a
80102bf9:	e8 92 d7 ff ff       	call   80100390 <panic>
80102bfe:	66 90                	xchg   %ax,%ax

80102c00 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102c00:	f3 0f 1e fb          	endbr32 
80102c04:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102c05:	c7 05 54 3b 11 80 00 	movl   $0xfec00000,0x80113b54
80102c0c:	00 c0 fe 
{
80102c0f:	89 e5                	mov    %esp,%ebp
80102c11:	56                   	push   %esi
80102c12:	53                   	push   %ebx
  ioapic->reg = reg;
80102c13:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102c1a:	00 00 00 
  return ioapic->data;
80102c1d:	8b 15 54 3b 11 80    	mov    0x80113b54,%edx
80102c23:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102c26:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102c2c:	8b 0d 54 3b 11 80    	mov    0x80113b54,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102c32:	0f b6 15 80 3c 11 80 	movzbl 0x80113c80,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102c39:	c1 ee 10             	shr    $0x10,%esi
80102c3c:	89 f0                	mov    %esi,%eax
80102c3e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102c41:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102c44:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102c47:	39 c2                	cmp    %eax,%edx
80102c49:	74 16                	je     80102c61 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c4b:	83 ec 0c             	sub    $0xc,%esp
80102c4e:	68 94 7b 10 80       	push   $0x80107b94
80102c53:	e8 f8 dc ff ff       	call   80100950 <cprintf>
80102c58:	8b 0d 54 3b 11 80    	mov    0x80113b54,%ecx
80102c5e:	83 c4 10             	add    $0x10,%esp
80102c61:	83 c6 21             	add    $0x21,%esi
{
80102c64:	ba 10 00 00 00       	mov    $0x10,%edx
80102c69:	b8 20 00 00 00       	mov    $0x20,%eax
80102c6e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102c70:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c72:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102c74:	8b 0d 54 3b 11 80    	mov    0x80113b54,%ecx
80102c7a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c7d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102c83:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102c86:	8d 5a 01             	lea    0x1(%edx),%ebx
80102c89:	83 c2 02             	add    $0x2,%edx
80102c8c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102c8e:	8b 0d 54 3b 11 80    	mov    0x80113b54,%ecx
80102c94:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102c9b:	39 f0                	cmp    %esi,%eax
80102c9d:	75 d1                	jne    80102c70 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102c9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ca2:	5b                   	pop    %ebx
80102ca3:	5e                   	pop    %esi
80102ca4:	5d                   	pop    %ebp
80102ca5:	c3                   	ret    
80102ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cad:	8d 76 00             	lea    0x0(%esi),%esi

80102cb0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102cb0:	f3 0f 1e fb          	endbr32 
80102cb4:	55                   	push   %ebp
  ioapic->reg = reg;
80102cb5:	8b 0d 54 3b 11 80    	mov    0x80113b54,%ecx
{
80102cbb:	89 e5                	mov    %esp,%ebp
80102cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102cc0:	8d 50 20             	lea    0x20(%eax),%edx
80102cc3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102cc7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102cc9:	8b 0d 54 3b 11 80    	mov    0x80113b54,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ccf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102cd2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102cd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102cd8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102cda:	a1 54 3b 11 80       	mov    0x80113b54,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102cdf:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102ce2:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ce5:	5d                   	pop    %ebp
80102ce6:	c3                   	ret    
80102ce7:	66 90                	xchg   %ax,%ax
80102ce9:	66 90                	xchg   %ax,%ax
80102ceb:	66 90                	xchg   %ax,%ax
80102ced:	66 90                	xchg   %ax,%ax
80102cef:	90                   	nop

80102cf0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102cf0:	f3 0f 1e fb          	endbr32 
80102cf4:	55                   	push   %ebp
80102cf5:	89 e5                	mov    %esp,%ebp
80102cf7:	53                   	push   %ebx
80102cf8:	83 ec 04             	sub    $0x4,%esp
80102cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102cfe:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102d04:	75 7a                	jne    80102d80 <kfree+0x90>
80102d06:	81 fb c8 69 11 80    	cmp    $0x801169c8,%ebx
80102d0c:	72 72                	jb     80102d80 <kfree+0x90>
80102d0e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102d14:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d19:	77 65                	ja     80102d80 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d1b:	83 ec 04             	sub    $0x4,%esp
80102d1e:	68 00 10 00 00       	push   $0x1000
80102d23:	6a 01                	push   $0x1
80102d25:	53                   	push   %ebx
80102d26:	e8 c5 21 00 00       	call   80104ef0 <memset>

  if(kmem.use_lock)
80102d2b:	8b 15 94 3b 11 80    	mov    0x80113b94,%edx
80102d31:	83 c4 10             	add    $0x10,%esp
80102d34:	85 d2                	test   %edx,%edx
80102d36:	75 20                	jne    80102d58 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102d38:	a1 98 3b 11 80       	mov    0x80113b98,%eax
80102d3d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102d3f:	a1 94 3b 11 80       	mov    0x80113b94,%eax
  kmem.freelist = r;
80102d44:	89 1d 98 3b 11 80    	mov    %ebx,0x80113b98
  if(kmem.use_lock)
80102d4a:	85 c0                	test   %eax,%eax
80102d4c:	75 22                	jne    80102d70 <kfree+0x80>
    release(&kmem.lock);
}
80102d4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d51:	c9                   	leave  
80102d52:	c3                   	ret    
80102d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d57:	90                   	nop
    acquire(&kmem.lock);
80102d58:	83 ec 0c             	sub    $0xc,%esp
80102d5b:	68 60 3b 11 80       	push   $0x80113b60
80102d60:	e8 7b 20 00 00       	call   80104de0 <acquire>
80102d65:	83 c4 10             	add    $0x10,%esp
80102d68:	eb ce                	jmp    80102d38 <kfree+0x48>
80102d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102d70:	c7 45 08 60 3b 11 80 	movl   $0x80113b60,0x8(%ebp)
}
80102d77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d7a:	c9                   	leave  
    release(&kmem.lock);
80102d7b:	e9 20 21 00 00       	jmp    80104ea0 <release>
    panic("kfree");
80102d80:	83 ec 0c             	sub    $0xc,%esp
80102d83:	68 c6 7b 10 80       	push   $0x80107bc6
80102d88:	e8 03 d6 ff ff       	call   80100390 <panic>
80102d8d:	8d 76 00             	lea    0x0(%esi),%esi

80102d90 <freerange>:
{
80102d90:	f3 0f 1e fb          	endbr32 
80102d94:	55                   	push   %ebp
80102d95:	89 e5                	mov    %esp,%ebp
80102d97:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102d98:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102d9b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102d9e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102d9f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102da5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102db1:	39 de                	cmp    %ebx,%esi
80102db3:	72 1f                	jb     80102dd4 <freerange+0x44>
80102db5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102db8:	83 ec 0c             	sub    $0xc,%esp
80102dbb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dc1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102dc7:	50                   	push   %eax
80102dc8:	e8 23 ff ff ff       	call   80102cf0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dcd:	83 c4 10             	add    $0x10,%esp
80102dd0:	39 f3                	cmp    %esi,%ebx
80102dd2:	76 e4                	jbe    80102db8 <freerange+0x28>
}
80102dd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102dd7:	5b                   	pop    %ebx
80102dd8:	5e                   	pop    %esi
80102dd9:	5d                   	pop    %ebp
80102dda:	c3                   	ret    
80102ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ddf:	90                   	nop

80102de0 <kinit1>:
{
80102de0:	f3 0f 1e fb          	endbr32 
80102de4:	55                   	push   %ebp
80102de5:	89 e5                	mov    %esp,%ebp
80102de7:	56                   	push   %esi
80102de8:	53                   	push   %ebx
80102de9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102dec:	83 ec 08             	sub    $0x8,%esp
80102def:	68 cc 7b 10 80       	push   $0x80107bcc
80102df4:	68 60 3b 11 80       	push   $0x80113b60
80102df9:	e8 62 1e 00 00       	call   80104c60 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e01:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e04:	c7 05 94 3b 11 80 00 	movl   $0x0,0x80113b94
80102e0b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102e0e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e14:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e20:	39 de                	cmp    %ebx,%esi
80102e22:	72 20                	jb     80102e44 <kinit1+0x64>
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102e28:	83 ec 0c             	sub    $0xc,%esp
80102e2b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e37:	50                   	push   %eax
80102e38:	e8 b3 fe ff ff       	call   80102cf0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e3d:	83 c4 10             	add    $0x10,%esp
80102e40:	39 de                	cmp    %ebx,%esi
80102e42:	73 e4                	jae    80102e28 <kinit1+0x48>
}
80102e44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e47:	5b                   	pop    %ebx
80102e48:	5e                   	pop    %esi
80102e49:	5d                   	pop    %ebp
80102e4a:	c3                   	ret    
80102e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e4f:	90                   	nop

80102e50 <kinit2>:
{
80102e50:	f3 0f 1e fb          	endbr32 
80102e54:	55                   	push   %ebp
80102e55:	89 e5                	mov    %esp,%ebp
80102e57:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102e58:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102e5b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102e5e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102e5f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e65:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e6b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e71:	39 de                	cmp    %ebx,%esi
80102e73:	72 1f                	jb     80102e94 <kinit2+0x44>
80102e75:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102e78:	83 ec 0c             	sub    $0xc,%esp
80102e7b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e87:	50                   	push   %eax
80102e88:	e8 63 fe ff ff       	call   80102cf0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e8d:	83 c4 10             	add    $0x10,%esp
80102e90:	39 de                	cmp    %ebx,%esi
80102e92:	73 e4                	jae    80102e78 <kinit2+0x28>
  kmem.use_lock = 1;
80102e94:	c7 05 94 3b 11 80 01 	movl   $0x1,0x80113b94
80102e9b:	00 00 00 
}
80102e9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ea1:	5b                   	pop    %ebx
80102ea2:	5e                   	pop    %esi
80102ea3:	5d                   	pop    %ebp
80102ea4:	c3                   	ret    
80102ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102eb0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102eb0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102eb4:	a1 94 3b 11 80       	mov    0x80113b94,%eax
80102eb9:	85 c0                	test   %eax,%eax
80102ebb:	75 1b                	jne    80102ed8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102ebd:	a1 98 3b 11 80       	mov    0x80113b98,%eax
  if(r)
80102ec2:	85 c0                	test   %eax,%eax
80102ec4:	74 0a                	je     80102ed0 <kalloc+0x20>
    kmem.freelist = r->next;
80102ec6:	8b 10                	mov    (%eax),%edx
80102ec8:	89 15 98 3b 11 80    	mov    %edx,0x80113b98
  if(kmem.use_lock)
80102ece:	c3                   	ret    
80102ecf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102ed0:	c3                   	ret    
80102ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102ed8:	55                   	push   %ebp
80102ed9:	89 e5                	mov    %esp,%ebp
80102edb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102ede:	68 60 3b 11 80       	push   $0x80113b60
80102ee3:	e8 f8 1e 00 00       	call   80104de0 <acquire>
  r = kmem.freelist;
80102ee8:	a1 98 3b 11 80       	mov    0x80113b98,%eax
  if(r)
80102eed:	8b 15 94 3b 11 80    	mov    0x80113b94,%edx
80102ef3:	83 c4 10             	add    $0x10,%esp
80102ef6:	85 c0                	test   %eax,%eax
80102ef8:	74 08                	je     80102f02 <kalloc+0x52>
    kmem.freelist = r->next;
80102efa:	8b 08                	mov    (%eax),%ecx
80102efc:	89 0d 98 3b 11 80    	mov    %ecx,0x80113b98
  if(kmem.use_lock)
80102f02:	85 d2                	test   %edx,%edx
80102f04:	74 16                	je     80102f1c <kalloc+0x6c>
    release(&kmem.lock);
80102f06:	83 ec 0c             	sub    $0xc,%esp
80102f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102f0c:	68 60 3b 11 80       	push   $0x80113b60
80102f11:	e8 8a 1f 00 00       	call   80104ea0 <release>
  return (char*)r;
80102f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	c9                   	leave  
80102f1d:	c3                   	ret    
80102f1e:	66 90                	xchg   %ax,%ax

80102f20 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102f20:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f24:	ba 64 00 00 00       	mov    $0x64,%edx
80102f29:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102f2a:	a8 01                	test   $0x1,%al
80102f2c:	0f 84 be 00 00 00    	je     80102ff0 <kbdgetc+0xd0>
{
80102f32:	55                   	push   %ebp
80102f33:	ba 60 00 00 00       	mov    $0x60,%edx
80102f38:	89 e5                	mov    %esp,%ebp
80102f3a:	53                   	push   %ebx
80102f3b:	ec                   	in     (%dx),%al
  return data;
80102f3c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102f42:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102f45:	3c e0                	cmp    $0xe0,%al
80102f47:	74 57                	je     80102fa0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102f49:	89 d9                	mov    %ebx,%ecx
80102f4b:	83 e1 40             	and    $0x40,%ecx
80102f4e:	84 c0                	test   %al,%al
80102f50:	78 5e                	js     80102fb0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f52:	85 c9                	test   %ecx,%ecx
80102f54:	74 09                	je     80102f5f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f56:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f59:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102f5c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102f5f:	0f b6 8a 00 7d 10 80 	movzbl -0x7fef8300(%edx),%ecx
  shift ^= togglecode[data];
80102f66:	0f b6 82 00 7c 10 80 	movzbl -0x7fef8400(%edx),%eax
  shift |= shiftcode[data];
80102f6d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102f6f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f71:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102f73:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102f79:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102f7c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f7f:	8b 04 85 e0 7b 10 80 	mov    -0x7fef8420(,%eax,4),%eax
80102f86:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102f8a:	74 0b                	je     80102f97 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102f8c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102f8f:	83 fa 19             	cmp    $0x19,%edx
80102f92:	77 44                	ja     80102fd8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102f94:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102f97:	5b                   	pop    %ebx
80102f98:	5d                   	pop    %ebp
80102f99:	c3                   	ret    
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102fa0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102fa3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102fa5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102fab:	5b                   	pop    %ebx
80102fac:	5d                   	pop    %ebp
80102fad:	c3                   	ret    
80102fae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102fb0:	83 e0 7f             	and    $0x7f,%eax
80102fb3:	85 c9                	test   %ecx,%ecx
80102fb5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102fb8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102fba:	0f b6 8a 00 7d 10 80 	movzbl -0x7fef8300(%edx),%ecx
80102fc1:	83 c9 40             	or     $0x40,%ecx
80102fc4:	0f b6 c9             	movzbl %cl,%ecx
80102fc7:	f7 d1                	not    %ecx
80102fc9:	21 d9                	and    %ebx,%ecx
}
80102fcb:	5b                   	pop    %ebx
80102fcc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102fcd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102fd3:	c3                   	ret    
80102fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102fd8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102fdb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102fde:	5b                   	pop    %ebx
80102fdf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102fe0:	83 f9 1a             	cmp    $0x1a,%ecx
80102fe3:	0f 42 c2             	cmovb  %edx,%eax
}
80102fe6:	c3                   	ret    
80102fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fee:	66 90                	xchg   %ax,%ax
    return -1;
80102ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ff5:	c3                   	ret    
80102ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ffd:	8d 76 00             	lea    0x0(%esi),%esi

80103000 <kbdintr>:

void
kbdintr(void)
{
80103000:	f3 0f 1e fb          	endbr32 
80103004:	55                   	push   %ebp
80103005:	89 e5                	mov    %esp,%ebp
80103007:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010300a:	68 20 2f 10 80       	push   $0x80102f20
8010300f:	e8 5c dd ff ff       	call   80100d70 <consoleintr>
}
80103014:	83 c4 10             	add    $0x10,%esp
80103017:	c9                   	leave  
80103018:	c3                   	ret    
80103019:	66 90                	xchg   %ax,%ax
8010301b:	66 90                	xchg   %ax,%ax
8010301d:	66 90                	xchg   %ax,%ax
8010301f:	90                   	nop

80103020 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80103020:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80103024:	a1 9c 3b 11 80       	mov    0x80113b9c,%eax
80103029:	85 c0                	test   %eax,%eax
8010302b:	0f 84 c7 00 00 00    	je     801030f8 <lapicinit+0xd8>
  lapic[index] = value;
80103031:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103038:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010303b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010303e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103045:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103048:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010304b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103052:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103055:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103058:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010305f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103062:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103065:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010306c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010306f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103072:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103079:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010307c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010307f:	8b 50 30             	mov    0x30(%eax),%edx
80103082:	c1 ea 10             	shr    $0x10,%edx
80103085:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010308b:	75 73                	jne    80103100 <lapicinit+0xe0>
  lapic[index] = value;
8010308d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103094:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103097:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010309a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030a1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030a7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030ae:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030b4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801030bb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030c1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801030c8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030ce:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801030d5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801030d8:	8b 50 20             	mov    0x20(%eax),%edx
801030db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030df:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801030e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801030e6:	80 e6 10             	and    $0x10,%dh
801030e9:	75 f5                	jne    801030e0 <lapicinit+0xc0>
  lapic[index] = value;
801030eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801030f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801030f8:	c3                   	ret    
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103100:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103107:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010310a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010310d:	e9 7b ff ff ff       	jmp    8010308d <lapicinit+0x6d>
80103112:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103120 <lapicid>:

int
lapicid(void)
{
80103120:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103124:	a1 9c 3b 11 80       	mov    0x80113b9c,%eax
80103129:	85 c0                	test   %eax,%eax
8010312b:	74 0b                	je     80103138 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010312d:	8b 40 20             	mov    0x20(%eax),%eax
80103130:	c1 e8 18             	shr    $0x18,%eax
80103133:	c3                   	ret    
80103134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103138:	31 c0                	xor    %eax,%eax
}
8010313a:	c3                   	ret    
8010313b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010313f:	90                   	nop

80103140 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103140:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103144:	a1 9c 3b 11 80       	mov    0x80113b9c,%eax
80103149:	85 c0                	test   %eax,%eax
8010314b:	74 0d                	je     8010315a <lapiceoi+0x1a>
  lapic[index] = value;
8010314d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103154:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103157:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010315a:	c3                   	ret    
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop

80103160 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103160:	f3 0f 1e fb          	endbr32 
}
80103164:	c3                   	ret    
80103165:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103170 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103170:	f3 0f 1e fb          	endbr32 
80103174:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103175:	b8 0f 00 00 00       	mov    $0xf,%eax
8010317a:	ba 70 00 00 00       	mov    $0x70,%edx
8010317f:	89 e5                	mov    %esp,%ebp
80103181:	53                   	push   %ebx
80103182:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103185:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103188:	ee                   	out    %al,(%dx)
80103189:	b8 0a 00 00 00       	mov    $0xa,%eax
8010318e:	ba 71 00 00 00       	mov    $0x71,%edx
80103193:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103194:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103196:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103199:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010319f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801031a1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801031a4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801031a6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801031a9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801031ac:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801031b2:	a1 9c 3b 11 80       	mov    0x80113b9c,%eax
801031b7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031bd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031c0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801031c7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031ca:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031cd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801031d4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031d7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031da:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031e0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031e3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031ec:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031f5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801031fb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801031fc:	8b 40 20             	mov    0x20(%eax),%eax
}
801031ff:	5d                   	pop    %ebp
80103200:	c3                   	ret    
80103201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103210:	f3 0f 1e fb          	endbr32 
80103214:	55                   	push   %ebp
80103215:	b8 0b 00 00 00       	mov    $0xb,%eax
8010321a:	ba 70 00 00 00       	mov    $0x70,%edx
8010321f:	89 e5                	mov    %esp,%ebp
80103221:	57                   	push   %edi
80103222:	56                   	push   %esi
80103223:	53                   	push   %ebx
80103224:	83 ec 4c             	sub    $0x4c,%esp
80103227:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103228:	ba 71 00 00 00       	mov    $0x71,%edx
8010322d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010322e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103231:	bb 70 00 00 00       	mov    $0x70,%ebx
80103236:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103240:	31 c0                	xor    %eax,%eax
80103242:	89 da                	mov    %ebx,%edx
80103244:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103245:	b9 71 00 00 00       	mov    $0x71,%ecx
8010324a:	89 ca                	mov    %ecx,%edx
8010324c:	ec                   	in     (%dx),%al
8010324d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103250:	89 da                	mov    %ebx,%edx
80103252:	b8 02 00 00 00       	mov    $0x2,%eax
80103257:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103258:	89 ca                	mov    %ecx,%edx
8010325a:	ec                   	in     (%dx),%al
8010325b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010325e:	89 da                	mov    %ebx,%edx
80103260:	b8 04 00 00 00       	mov    $0x4,%eax
80103265:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103266:	89 ca                	mov    %ecx,%edx
80103268:	ec                   	in     (%dx),%al
80103269:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010326c:	89 da                	mov    %ebx,%edx
8010326e:	b8 07 00 00 00       	mov    $0x7,%eax
80103273:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103274:	89 ca                	mov    %ecx,%edx
80103276:	ec                   	in     (%dx),%al
80103277:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010327a:	89 da                	mov    %ebx,%edx
8010327c:	b8 08 00 00 00       	mov    $0x8,%eax
80103281:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103282:	89 ca                	mov    %ecx,%edx
80103284:	ec                   	in     (%dx),%al
80103285:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103287:	89 da                	mov    %ebx,%edx
80103289:	b8 09 00 00 00       	mov    $0x9,%eax
8010328e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010328f:	89 ca                	mov    %ecx,%edx
80103291:	ec                   	in     (%dx),%al
80103292:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103294:	89 da                	mov    %ebx,%edx
80103296:	b8 0a 00 00 00       	mov    $0xa,%eax
8010329b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010329c:	89 ca                	mov    %ecx,%edx
8010329e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010329f:	84 c0                	test   %al,%al
801032a1:	78 9d                	js     80103240 <cmostime+0x30>
  return inb(CMOS_RETURN);
801032a3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801032a7:	89 fa                	mov    %edi,%edx
801032a9:	0f b6 fa             	movzbl %dl,%edi
801032ac:	89 f2                	mov    %esi,%edx
801032ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
801032b1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801032b5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b8:	89 da                	mov    %ebx,%edx
801032ba:	89 7d c8             	mov    %edi,-0x38(%ebp)
801032bd:	89 45 bc             	mov    %eax,-0x44(%ebp)
801032c0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801032c4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801032c7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801032ca:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801032ce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801032d1:	31 c0                	xor    %eax,%eax
801032d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d4:	89 ca                	mov    %ecx,%edx
801032d6:	ec                   	in     (%dx),%al
801032d7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032da:	89 da                	mov    %ebx,%edx
801032dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
801032df:	b8 02 00 00 00       	mov    $0x2,%eax
801032e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032e5:	89 ca                	mov    %ecx,%edx
801032e7:	ec                   	in     (%dx),%al
801032e8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032eb:	89 da                	mov    %ebx,%edx
801032ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801032f0:	b8 04 00 00 00       	mov    $0x4,%eax
801032f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032f6:	89 ca                	mov    %ecx,%edx
801032f8:	ec                   	in     (%dx),%al
801032f9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fc:	89 da                	mov    %ebx,%edx
801032fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103301:	b8 07 00 00 00       	mov    $0x7,%eax
80103306:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103307:	89 ca                	mov    %ecx,%edx
80103309:	ec                   	in     (%dx),%al
8010330a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010330d:	89 da                	mov    %ebx,%edx
8010330f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103312:	b8 08 00 00 00       	mov    $0x8,%eax
80103317:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103318:	89 ca                	mov    %ecx,%edx
8010331a:	ec                   	in     (%dx),%al
8010331b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331e:	89 da                	mov    %ebx,%edx
80103320:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103323:	b8 09 00 00 00       	mov    $0x9,%eax
80103328:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103329:	89 ca                	mov    %ecx,%edx
8010332b:	ec                   	in     (%dx),%al
8010332c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010332f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103335:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103338:	6a 18                	push   $0x18
8010333a:	50                   	push   %eax
8010333b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010333e:	50                   	push   %eax
8010333f:	e8 fc 1b 00 00       	call   80104f40 <memcmp>
80103344:	83 c4 10             	add    $0x10,%esp
80103347:	85 c0                	test   %eax,%eax
80103349:	0f 85 f1 fe ff ff    	jne    80103240 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010334f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103353:	75 78                	jne    801033cd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103355:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103358:	89 c2                	mov    %eax,%edx
8010335a:	83 e0 0f             	and    $0xf,%eax
8010335d:	c1 ea 04             	shr    $0x4,%edx
80103360:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103363:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103366:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103369:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010336c:	89 c2                	mov    %eax,%edx
8010336e:	83 e0 0f             	and    $0xf,%eax
80103371:	c1 ea 04             	shr    $0x4,%edx
80103374:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103377:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010337a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010337d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103380:	89 c2                	mov    %eax,%edx
80103382:	83 e0 0f             	and    $0xf,%eax
80103385:	c1 ea 04             	shr    $0x4,%edx
80103388:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010338b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010338e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103391:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103394:	89 c2                	mov    %eax,%edx
80103396:	83 e0 0f             	and    $0xf,%eax
80103399:	c1 ea 04             	shr    $0x4,%edx
8010339c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010339f:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801033a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033a8:	89 c2                	mov    %eax,%edx
801033aa:	83 e0 0f             	and    $0xf,%eax
801033ad:	c1 ea 04             	shr    $0x4,%edx
801033b0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033b3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033b6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801033b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033bc:	89 c2                	mov    %eax,%edx
801033be:	83 e0 0f             	and    $0xf,%eax
801033c1:	c1 ea 04             	shr    $0x4,%edx
801033c4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033c7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801033cd:	8b 75 08             	mov    0x8(%ebp),%esi
801033d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033d3:	89 06                	mov    %eax,(%esi)
801033d5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033d8:	89 46 04             	mov    %eax,0x4(%esi)
801033db:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033de:	89 46 08             	mov    %eax,0x8(%esi)
801033e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801033e4:	89 46 0c             	mov    %eax,0xc(%esi)
801033e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033ea:	89 46 10             	mov    %eax,0x10(%esi)
801033ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033f0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801033f3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801033fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033fd:	5b                   	pop    %ebx
801033fe:	5e                   	pop    %esi
801033ff:	5f                   	pop    %edi
80103400:	5d                   	pop    %ebp
80103401:	c3                   	ret    
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103410:	8b 0d e8 3b 11 80    	mov    0x80113be8,%ecx
80103416:	85 c9                	test   %ecx,%ecx
80103418:	0f 8e 8a 00 00 00    	jle    801034a8 <install_trans+0x98>
{
8010341e:	55                   	push   %ebp
8010341f:	89 e5                	mov    %esp,%ebp
80103421:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103422:	31 ff                	xor    %edi,%edi
{
80103424:	56                   	push   %esi
80103425:	53                   	push   %ebx
80103426:	83 ec 0c             	sub    $0xc,%esp
80103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103430:	a1 d4 3b 11 80       	mov    0x80113bd4,%eax
80103435:	83 ec 08             	sub    $0x8,%esp
80103438:	01 f8                	add    %edi,%eax
8010343a:	83 c0 01             	add    $0x1,%eax
8010343d:	50                   	push   %eax
8010343e:	ff 35 e4 3b 11 80    	pushl  0x80113be4
80103444:	e8 87 cc ff ff       	call   801000d0 <bread>
80103449:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010344b:	58                   	pop    %eax
8010344c:	5a                   	pop    %edx
8010344d:	ff 34 bd ec 3b 11 80 	pushl  -0x7feec414(,%edi,4)
80103454:	ff 35 e4 3b 11 80    	pushl  0x80113be4
  for (tail = 0; tail < log.lh.n; tail++) {
8010345a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010345d:	e8 6e cc ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103462:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103465:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103467:	8d 46 5c             	lea    0x5c(%esi),%eax
8010346a:	68 00 02 00 00       	push   $0x200
8010346f:	50                   	push   %eax
80103470:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103473:	50                   	push   %eax
80103474:	e8 17 1b 00 00       	call   80104f90 <memmove>
    bwrite(dbuf);  // write dst to disk
80103479:	89 1c 24             	mov    %ebx,(%esp)
8010347c:	e8 2f cd ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103481:	89 34 24             	mov    %esi,(%esp)
80103484:	e8 67 cd ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103489:	89 1c 24             	mov    %ebx,(%esp)
8010348c:	e8 5f cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103491:	83 c4 10             	add    $0x10,%esp
80103494:	39 3d e8 3b 11 80    	cmp    %edi,0x80113be8
8010349a:	7f 94                	jg     80103430 <install_trans+0x20>
  }
}
8010349c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010349f:	5b                   	pop    %ebx
801034a0:	5e                   	pop    %esi
801034a1:	5f                   	pop    %edi
801034a2:	5d                   	pop    %ebp
801034a3:	c3                   	ret    
801034a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034a8:	c3                   	ret    
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034b0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	53                   	push   %ebx
801034b4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801034b7:	ff 35 d4 3b 11 80    	pushl  0x80113bd4
801034bd:	ff 35 e4 3b 11 80    	pushl  0x80113be4
801034c3:	e8 08 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034c8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801034cb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801034cd:	a1 e8 3b 11 80       	mov    0x80113be8,%eax
801034d2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801034d5:	85 c0                	test   %eax,%eax
801034d7:	7e 19                	jle    801034f2 <write_head+0x42>
801034d9:	31 d2                	xor    %edx,%edx
801034db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034df:	90                   	nop
    hb->block[i] = log.lh.block[i];
801034e0:	8b 0c 95 ec 3b 11 80 	mov    -0x7feec414(,%edx,4),%ecx
801034e7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034eb:	83 c2 01             	add    $0x1,%edx
801034ee:	39 d0                	cmp    %edx,%eax
801034f0:	75 ee                	jne    801034e0 <write_head+0x30>
  }
  bwrite(buf);
801034f2:	83 ec 0c             	sub    $0xc,%esp
801034f5:	53                   	push   %ebx
801034f6:	e8 b5 cc ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801034fb:	89 1c 24             	mov    %ebx,(%esp)
801034fe:	e8 ed cc ff ff       	call   801001f0 <brelse>
}
80103503:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103506:	83 c4 10             	add    $0x10,%esp
80103509:	c9                   	leave  
8010350a:	c3                   	ret    
8010350b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <initlog>:
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	53                   	push   %ebx
80103518:	83 ec 2c             	sub    $0x2c,%esp
8010351b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010351e:	68 00 7e 10 80       	push   $0x80107e00
80103523:	68 a0 3b 11 80       	push   $0x80113ba0
80103528:	e8 33 17 00 00       	call   80104c60 <initlock>
  readsb(dev, &sb);
8010352d:	58                   	pop    %eax
8010352e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103531:	5a                   	pop    %edx
80103532:	50                   	push   %eax
80103533:	53                   	push   %ebx
80103534:	e8 47 e8 ff ff       	call   80101d80 <readsb>
  log.start = sb.logstart;
80103539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010353c:	59                   	pop    %ecx
  log.dev = dev;
8010353d:	89 1d e4 3b 11 80    	mov    %ebx,0x80113be4
  log.size = sb.nlog;
80103543:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103546:	a3 d4 3b 11 80       	mov    %eax,0x80113bd4
  log.size = sb.nlog;
8010354b:	89 15 d8 3b 11 80    	mov    %edx,0x80113bd8
  struct buf *buf = bread(log.dev, log.start);
80103551:	5a                   	pop    %edx
80103552:	50                   	push   %eax
80103553:	53                   	push   %ebx
80103554:	e8 77 cb ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103559:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010355c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010355f:	89 0d e8 3b 11 80    	mov    %ecx,0x80113be8
  for (i = 0; i < log.lh.n; i++) {
80103565:	85 c9                	test   %ecx,%ecx
80103567:	7e 19                	jle    80103582 <initlog+0x72>
80103569:	31 d2                	xor    %edx,%edx
8010356b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010356f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103570:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103574:	89 1c 95 ec 3b 11 80 	mov    %ebx,-0x7feec414(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010357b:	83 c2 01             	add    $0x1,%edx
8010357e:	39 d1                	cmp    %edx,%ecx
80103580:	75 ee                	jne    80103570 <initlog+0x60>
  brelse(buf);
80103582:	83 ec 0c             	sub    $0xc,%esp
80103585:	50                   	push   %eax
80103586:	e8 65 cc ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010358b:	e8 80 fe ff ff       	call   80103410 <install_trans>
  log.lh.n = 0;
80103590:	c7 05 e8 3b 11 80 00 	movl   $0x0,0x80113be8
80103597:	00 00 00 
  write_head(); // clear the log
8010359a:	e8 11 ff ff ff       	call   801034b0 <write_head>
}
8010359f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035a2:	83 c4 10             	add    $0x10,%esp
801035a5:	c9                   	leave  
801035a6:	c3                   	ret    
801035a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801035ba:	68 a0 3b 11 80       	push   $0x80113ba0
801035bf:	e8 1c 18 00 00       	call   80104de0 <acquire>
801035c4:	83 c4 10             	add    $0x10,%esp
801035c7:	eb 1c                	jmp    801035e5 <begin_op+0x35>
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801035d0:	83 ec 08             	sub    $0x8,%esp
801035d3:	68 a0 3b 11 80       	push   $0x80113ba0
801035d8:	68 a0 3b 11 80       	push   $0x80113ba0
801035dd:	e8 be 11 00 00       	call   801047a0 <sleep>
801035e2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801035e5:	a1 e0 3b 11 80       	mov    0x80113be0,%eax
801035ea:	85 c0                	test   %eax,%eax
801035ec:	75 e2                	jne    801035d0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035ee:	a1 dc 3b 11 80       	mov    0x80113bdc,%eax
801035f3:	8b 15 e8 3b 11 80    	mov    0x80113be8,%edx
801035f9:	83 c0 01             	add    $0x1,%eax
801035fc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801035ff:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103602:	83 fa 1e             	cmp    $0x1e,%edx
80103605:	7f c9                	jg     801035d0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103607:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010360a:	a3 dc 3b 11 80       	mov    %eax,0x80113bdc
      release(&log.lock);
8010360f:	68 a0 3b 11 80       	push   $0x80113ba0
80103614:	e8 87 18 00 00       	call   80104ea0 <release>
      break;
    }
  }
}
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	c9                   	leave  
8010361d:	c3                   	ret    
8010361e:	66 90                	xchg   %ax,%ax

80103620 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103620:	f3 0f 1e fb          	endbr32 
80103624:	55                   	push   %ebp
80103625:	89 e5                	mov    %esp,%ebp
80103627:	57                   	push   %edi
80103628:	56                   	push   %esi
80103629:	53                   	push   %ebx
8010362a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010362d:	68 a0 3b 11 80       	push   $0x80113ba0
80103632:	e8 a9 17 00 00       	call   80104de0 <acquire>
  log.outstanding -= 1;
80103637:	a1 dc 3b 11 80       	mov    0x80113bdc,%eax
  if(log.committing)
8010363c:	8b 35 e0 3b 11 80    	mov    0x80113be0,%esi
80103642:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103645:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103648:	89 1d dc 3b 11 80    	mov    %ebx,0x80113bdc
  if(log.committing)
8010364e:	85 f6                	test   %esi,%esi
80103650:	0f 85 1e 01 00 00    	jne    80103774 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103656:	85 db                	test   %ebx,%ebx
80103658:	0f 85 f2 00 00 00    	jne    80103750 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010365e:	c7 05 e0 3b 11 80 01 	movl   $0x1,0x80113be0
80103665:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	68 a0 3b 11 80       	push   $0x80113ba0
80103670:	e8 2b 18 00 00       	call   80104ea0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103675:	8b 0d e8 3b 11 80    	mov    0x80113be8,%ecx
8010367b:	83 c4 10             	add    $0x10,%esp
8010367e:	85 c9                	test   %ecx,%ecx
80103680:	7f 3e                	jg     801036c0 <end_op+0xa0>
    acquire(&log.lock);
80103682:	83 ec 0c             	sub    $0xc,%esp
80103685:	68 a0 3b 11 80       	push   $0x80113ba0
8010368a:	e8 51 17 00 00       	call   80104de0 <acquire>
    wakeup(&log);
8010368f:	c7 04 24 a0 3b 11 80 	movl   $0x80113ba0,(%esp)
    log.committing = 0;
80103696:	c7 05 e0 3b 11 80 00 	movl   $0x0,0x80113be0
8010369d:	00 00 00 
    wakeup(&log);
801036a0:	e8 bb 12 00 00       	call   80104960 <wakeup>
    release(&log.lock);
801036a5:	c7 04 24 a0 3b 11 80 	movl   $0x80113ba0,(%esp)
801036ac:	e8 ef 17 00 00       	call   80104ea0 <release>
801036b1:	83 c4 10             	add    $0x10,%esp
}
801036b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036b7:	5b                   	pop    %ebx
801036b8:	5e                   	pop    %esi
801036b9:	5f                   	pop    %edi
801036ba:	5d                   	pop    %ebp
801036bb:	c3                   	ret    
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036c0:	a1 d4 3b 11 80       	mov    0x80113bd4,%eax
801036c5:	83 ec 08             	sub    $0x8,%esp
801036c8:	01 d8                	add    %ebx,%eax
801036ca:	83 c0 01             	add    $0x1,%eax
801036cd:	50                   	push   %eax
801036ce:	ff 35 e4 3b 11 80    	pushl  0x80113be4
801036d4:	e8 f7 c9 ff ff       	call   801000d0 <bread>
801036d9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036db:	58                   	pop    %eax
801036dc:	5a                   	pop    %edx
801036dd:	ff 34 9d ec 3b 11 80 	pushl  -0x7feec414(,%ebx,4)
801036e4:	ff 35 e4 3b 11 80    	pushl  0x80113be4
  for (tail = 0; tail < log.lh.n; tail++) {
801036ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036ed:	e8 de c9 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801036f2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036f5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801036f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801036fa:	68 00 02 00 00       	push   $0x200
801036ff:	50                   	push   %eax
80103700:	8d 46 5c             	lea    0x5c(%esi),%eax
80103703:	50                   	push   %eax
80103704:	e8 87 18 00 00       	call   80104f90 <memmove>
    bwrite(to);  // write the log
80103709:	89 34 24             	mov    %esi,(%esp)
8010370c:	e8 9f ca ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103711:	89 3c 24             	mov    %edi,(%esp)
80103714:	e8 d7 ca ff ff       	call   801001f0 <brelse>
    brelse(to);
80103719:	89 34 24             	mov    %esi,(%esp)
8010371c:	e8 cf ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103721:	83 c4 10             	add    $0x10,%esp
80103724:	3b 1d e8 3b 11 80    	cmp    0x80113be8,%ebx
8010372a:	7c 94                	jl     801036c0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010372c:	e8 7f fd ff ff       	call   801034b0 <write_head>
    install_trans(); // Now install writes to home locations
80103731:	e8 da fc ff ff       	call   80103410 <install_trans>
    log.lh.n = 0;
80103736:	c7 05 e8 3b 11 80 00 	movl   $0x0,0x80113be8
8010373d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103740:	e8 6b fd ff ff       	call   801034b0 <write_head>
80103745:	e9 38 ff ff ff       	jmp    80103682 <end_op+0x62>
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103750:	83 ec 0c             	sub    $0xc,%esp
80103753:	68 a0 3b 11 80       	push   $0x80113ba0
80103758:	e8 03 12 00 00       	call   80104960 <wakeup>
  release(&log.lock);
8010375d:	c7 04 24 a0 3b 11 80 	movl   $0x80113ba0,(%esp)
80103764:	e8 37 17 00 00       	call   80104ea0 <release>
80103769:	83 c4 10             	add    $0x10,%esp
}
8010376c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010376f:	5b                   	pop    %ebx
80103770:	5e                   	pop    %esi
80103771:	5f                   	pop    %edi
80103772:	5d                   	pop    %ebp
80103773:	c3                   	ret    
    panic("log.committing");
80103774:	83 ec 0c             	sub    $0xc,%esp
80103777:	68 04 7e 10 80       	push   $0x80107e04
8010377c:	e8 0f cc ff ff       	call   80100390 <panic>
80103781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010378f:	90                   	nop

80103790 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103790:	f3 0f 1e fb          	endbr32 
80103794:	55                   	push   %ebp
80103795:	89 e5                	mov    %esp,%ebp
80103797:	53                   	push   %ebx
80103798:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010379b:	8b 15 e8 3b 11 80    	mov    0x80113be8,%edx
{
801037a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037a4:	83 fa 1d             	cmp    $0x1d,%edx
801037a7:	0f 8f 91 00 00 00    	jg     8010383e <log_write+0xae>
801037ad:	a1 d8 3b 11 80       	mov    0x80113bd8,%eax
801037b2:	83 e8 01             	sub    $0x1,%eax
801037b5:	39 c2                	cmp    %eax,%edx
801037b7:	0f 8d 81 00 00 00    	jge    8010383e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801037bd:	a1 dc 3b 11 80       	mov    0x80113bdc,%eax
801037c2:	85 c0                	test   %eax,%eax
801037c4:	0f 8e 81 00 00 00    	jle    8010384b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801037ca:	83 ec 0c             	sub    $0xc,%esp
801037cd:	68 a0 3b 11 80       	push   $0x80113ba0
801037d2:	e8 09 16 00 00       	call   80104de0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801037d7:	8b 15 e8 3b 11 80    	mov    0x80113be8,%edx
801037dd:	83 c4 10             	add    $0x10,%esp
801037e0:	85 d2                	test   %edx,%edx
801037e2:	7e 4e                	jle    80103832 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037e4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801037e7:	31 c0                	xor    %eax,%eax
801037e9:	eb 0c                	jmp    801037f7 <log_write+0x67>
801037eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ef:	90                   	nop
801037f0:	83 c0 01             	add    $0x1,%eax
801037f3:	39 c2                	cmp    %eax,%edx
801037f5:	74 29                	je     80103820 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037f7:	39 0c 85 ec 3b 11 80 	cmp    %ecx,-0x7feec414(,%eax,4)
801037fe:	75 f0                	jne    801037f0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103800:	89 0c 85 ec 3b 11 80 	mov    %ecx,-0x7feec414(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103807:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010380a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010380d:	c7 45 08 a0 3b 11 80 	movl   $0x80113ba0,0x8(%ebp)
}
80103814:	c9                   	leave  
  release(&log.lock);
80103815:	e9 86 16 00 00       	jmp    80104ea0 <release>
8010381a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103820:	89 0c 95 ec 3b 11 80 	mov    %ecx,-0x7feec414(,%edx,4)
    log.lh.n++;
80103827:	83 c2 01             	add    $0x1,%edx
8010382a:	89 15 e8 3b 11 80    	mov    %edx,0x80113be8
80103830:	eb d5                	jmp    80103807 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103832:	8b 43 08             	mov    0x8(%ebx),%eax
80103835:	a3 ec 3b 11 80       	mov    %eax,0x80113bec
  if (i == log.lh.n)
8010383a:	75 cb                	jne    80103807 <log_write+0x77>
8010383c:	eb e9                	jmp    80103827 <log_write+0x97>
    panic("too big a transaction");
8010383e:	83 ec 0c             	sub    $0xc,%esp
80103841:	68 13 7e 10 80       	push   $0x80107e13
80103846:	e8 45 cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010384b:	83 ec 0c             	sub    $0xc,%esp
8010384e:	68 29 7e 10 80       	push   $0x80107e29
80103853:	e8 38 cb ff ff       	call   80100390 <panic>
80103858:	66 90                	xchg   %ax,%ax
8010385a:	66 90                	xchg   %ax,%ax
8010385c:	66 90                	xchg   %ax,%ax
8010385e:	66 90                	xchg   %ax,%ax

80103860 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	53                   	push   %ebx
80103864:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103867:	e8 54 09 00 00       	call   801041c0 <cpuid>
8010386c:	89 c3                	mov    %eax,%ebx
8010386e:	e8 4d 09 00 00       	call   801041c0 <cpuid>
80103873:	83 ec 04             	sub    $0x4,%esp
80103876:	53                   	push   %ebx
80103877:	50                   	push   %eax
80103878:	68 44 7e 10 80       	push   $0x80107e44
8010387d:	e8 ce d0 ff ff       	call   80100950 <cprintf>
  idtinit();       // load idt register
80103882:	e8 19 29 00 00       	call   801061a0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103887:	e8 c4 08 00 00       	call   80104150 <mycpu>
8010388c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010388e:	b8 01 00 00 00       	mov    $0x1,%eax
80103893:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010389a:	e8 11 0c 00 00       	call   801044b0 <scheduler>
8010389f:	90                   	nop

801038a0 <mpenter>:
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	55                   	push   %ebp
801038a5:	89 e5                	mov    %esp,%ebp
801038a7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801038aa:	e8 c1 39 00 00       	call   80107270 <switchkvm>
  seginit();
801038af:	e8 2c 39 00 00       	call   801071e0 <seginit>
  lapicinit();
801038b4:	e8 67 f7 ff ff       	call   80103020 <lapicinit>
  mpmain();
801038b9:	e8 a2 ff ff ff       	call   80103860 <mpmain>
801038be:	66 90                	xchg   %ax,%ax

801038c0 <main>:
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038c8:	83 e4 f0             	and    $0xfffffff0,%esp
801038cb:	ff 71 fc             	pushl  -0x4(%ecx)
801038ce:	55                   	push   %ebp
801038cf:	89 e5                	mov    %esp,%ebp
801038d1:	53                   	push   %ebx
801038d2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038d3:	83 ec 08             	sub    $0x8,%esp
801038d6:	68 00 00 40 80       	push   $0x80400000
801038db:	68 c8 69 11 80       	push   $0x801169c8
801038e0:	e8 fb f4 ff ff       	call   80102de0 <kinit1>
  kvmalloc();      // kernel page table
801038e5:	e8 66 3e 00 00       	call   80107750 <kvmalloc>
  mpinit();        // detect other processors
801038ea:	e8 81 01 00 00       	call   80103a70 <mpinit>
  lapicinit();     // interrupt controller
801038ef:	e8 2c f7 ff ff       	call   80103020 <lapicinit>
  seginit();       // segment descriptors
801038f4:	e8 e7 38 00 00       	call   801071e0 <seginit>
  picinit();       // disable pic
801038f9:	e8 52 03 00 00       	call   80103c50 <picinit>
  ioapicinit();    // another interrupt controller
801038fe:	e8 fd f2 ff ff       	call   80102c00 <ioapicinit>
  consoleinit();   // console hardware
80103903:	e8 a8 d9 ff ff       	call   801012b0 <consoleinit>
  uartinit();      // serial port
80103908:	e8 93 2b 00 00       	call   801064a0 <uartinit>
  pinit();         // process table
8010390d:	e8 1e 08 00 00       	call   80104130 <pinit>
  tvinit();        // trap vectors
80103912:	e8 09 28 00 00       	call   80106120 <tvinit>
  binit();         // buffer cache
80103917:	e8 24 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010391c:	e8 3f dd ff ff       	call   80101660 <fileinit>
  ideinit();       // disk 
80103921:	e8 aa f0 ff ff       	call   801029d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103926:	83 c4 0c             	add    $0xc,%esp
80103929:	68 8a 00 00 00       	push   $0x8a
8010392e:	68 8c b4 10 80       	push   $0x8010b48c
80103933:	68 00 70 00 80       	push   $0x80007000
80103938:	e8 53 16 00 00       	call   80104f90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010393d:	83 c4 10             	add    $0x10,%esp
80103940:	69 05 20 42 11 80 b0 	imul   $0xb0,0x80114220,%eax
80103947:	00 00 00 
8010394a:	05 a0 3c 11 80       	add    $0x80113ca0,%eax
8010394f:	3d a0 3c 11 80       	cmp    $0x80113ca0,%eax
80103954:	76 7a                	jbe    801039d0 <main+0x110>
80103956:	bb a0 3c 11 80       	mov    $0x80113ca0,%ebx
8010395b:	eb 1c                	jmp    80103979 <main+0xb9>
8010395d:	8d 76 00             	lea    0x0(%esi),%esi
80103960:	69 05 20 42 11 80 b0 	imul   $0xb0,0x80114220,%eax
80103967:	00 00 00 
8010396a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103970:	05 a0 3c 11 80       	add    $0x80113ca0,%eax
80103975:	39 c3                	cmp    %eax,%ebx
80103977:	73 57                	jae    801039d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103979:	e8 d2 07 00 00       	call   80104150 <mycpu>
8010397e:	39 c3                	cmp    %eax,%ebx
80103980:	74 de                	je     80103960 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103982:	e8 29 f5 ff ff       	call   80102eb0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103987:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010398a:	c7 05 f8 6f 00 80 a0 	movl   $0x801038a0,0x80006ff8
80103991:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103994:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010399b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010399e:	05 00 10 00 00       	add    $0x1000,%eax
801039a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801039a8:	0f b6 03             	movzbl (%ebx),%eax
801039ab:	68 00 70 00 00       	push   $0x7000
801039b0:	50                   	push   %eax
801039b1:	e8 ba f7 ff ff       	call   80103170 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801039c6:	85 c0                	test   %eax,%eax
801039c8:	74 f6                	je     801039c0 <main+0x100>
801039ca:	eb 94                	jmp    80103960 <main+0xa0>
801039cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039d0:	83 ec 08             	sub    $0x8,%esp
801039d3:	68 00 00 00 8e       	push   $0x8e000000
801039d8:	68 00 00 40 80       	push   $0x80400000
801039dd:	e8 6e f4 ff ff       	call   80102e50 <kinit2>
  userinit();      // first user process
801039e2:	e8 29 08 00 00       	call   80104210 <userinit>
  mpmain();        // finish this processor's setup
801039e7:	e8 74 fe ff ff       	call   80103860 <mpmain>
801039ec:	66 90                	xchg   %ax,%ax
801039ee:	66 90                	xchg   %ax,%ax

801039f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801039f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801039fb:	53                   	push   %ebx
  e = addr+len;
801039fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801039ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103a02:	39 de                	cmp    %ebx,%esi
80103a04:	72 10                	jb     80103a16 <mpsearch1+0x26>
80103a06:	eb 50                	jmp    80103a58 <mpsearch1+0x68>
80103a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop
80103a10:	89 fe                	mov    %edi,%esi
80103a12:	39 fb                	cmp    %edi,%ebx
80103a14:	76 42                	jbe    80103a58 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a16:	83 ec 04             	sub    $0x4,%esp
80103a19:	8d 7e 10             	lea    0x10(%esi),%edi
80103a1c:	6a 04                	push   $0x4
80103a1e:	68 58 7e 10 80       	push   $0x80107e58
80103a23:	56                   	push   %esi
80103a24:	e8 17 15 00 00       	call   80104f40 <memcmp>
80103a29:	83 c4 10             	add    $0x10,%esp
80103a2c:	85 c0                	test   %eax,%eax
80103a2e:	75 e0                	jne    80103a10 <mpsearch1+0x20>
80103a30:	89 f2                	mov    %esi,%edx
80103a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103a38:	0f b6 0a             	movzbl (%edx),%ecx
80103a3b:	83 c2 01             	add    $0x1,%edx
80103a3e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103a40:	39 fa                	cmp    %edi,%edx
80103a42:	75 f4                	jne    80103a38 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a44:	84 c0                	test   %al,%al
80103a46:	75 c8                	jne    80103a10 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a4b:	89 f0                	mov    %esi,%eax
80103a4d:	5b                   	pop    %ebx
80103a4e:	5e                   	pop    %esi
80103a4f:	5f                   	pop    %edi
80103a50:	5d                   	pop    %ebp
80103a51:	c3                   	ret    
80103a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103a5b:	31 f6                	xor    %esi,%esi
}
80103a5d:	5b                   	pop    %ebx
80103a5e:	89 f0                	mov    %esi,%eax
80103a60:	5e                   	pop    %esi
80103a61:	5f                   	pop    %edi
80103a62:	5d                   	pop    %ebp
80103a63:	c3                   	ret    
80103a64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop

80103a70 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	57                   	push   %edi
80103a78:	56                   	push   %esi
80103a79:	53                   	push   %ebx
80103a7a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a7d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103a84:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103a8b:	c1 e0 08             	shl    $0x8,%eax
80103a8e:	09 d0                	or     %edx,%eax
80103a90:	c1 e0 04             	shl    $0x4,%eax
80103a93:	75 1b                	jne    80103ab0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a95:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103a9c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103aa3:	c1 e0 08             	shl    $0x8,%eax
80103aa6:	09 d0                	or     %edx,%eax
80103aa8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103aab:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103ab0:	ba 00 04 00 00       	mov    $0x400,%edx
80103ab5:	e8 36 ff ff ff       	call   801039f0 <mpsearch1>
80103aba:	89 c6                	mov    %eax,%esi
80103abc:	85 c0                	test   %eax,%eax
80103abe:	0f 84 4c 01 00 00    	je     80103c10 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ac4:	8b 5e 04             	mov    0x4(%esi),%ebx
80103ac7:	85 db                	test   %ebx,%ebx
80103ac9:	0f 84 61 01 00 00    	je     80103c30 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103acf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ad2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103ad8:	6a 04                	push   $0x4
80103ada:	68 5d 7e 10 80       	push   $0x80107e5d
80103adf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ae0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ae3:	e8 58 14 00 00       	call   80104f40 <memcmp>
80103ae8:	83 c4 10             	add    $0x10,%esp
80103aeb:	85 c0                	test   %eax,%eax
80103aed:	0f 85 3d 01 00 00    	jne    80103c30 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103af3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103afa:	3c 01                	cmp    $0x1,%al
80103afc:	74 08                	je     80103b06 <mpinit+0x96>
80103afe:	3c 04                	cmp    $0x4,%al
80103b00:	0f 85 2a 01 00 00    	jne    80103c30 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b06:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103b0d:	66 85 d2             	test   %dx,%dx
80103b10:	74 26                	je     80103b38 <mpinit+0xc8>
80103b12:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103b15:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103b17:	31 d2                	xor    %edx,%edx
80103b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103b20:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103b27:	83 c0 01             	add    $0x1,%eax
80103b2a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103b2c:	39 f8                	cmp    %edi,%eax
80103b2e:	75 f0                	jne    80103b20 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b30:	84 d2                	test   %dl,%dl
80103b32:	0f 85 f8 00 00 00    	jne    80103c30 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103b38:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103b3e:	a3 9c 3b 11 80       	mov    %eax,0x80113b9c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b43:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103b49:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103b50:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b55:	03 55 e4             	add    -0x1c(%ebp),%edx
80103b58:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop
80103b60:	39 c2                	cmp    %eax,%edx
80103b62:	76 15                	jbe    80103b79 <mpinit+0x109>
    switch(*p){
80103b64:	0f b6 08             	movzbl (%eax),%ecx
80103b67:	80 f9 02             	cmp    $0x2,%cl
80103b6a:	74 5c                	je     80103bc8 <mpinit+0x158>
80103b6c:	77 42                	ja     80103bb0 <mpinit+0x140>
80103b6e:	84 c9                	test   %cl,%cl
80103b70:	74 6e                	je     80103be0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103b72:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b75:	39 c2                	cmp    %eax,%edx
80103b77:	77 eb                	ja     80103b64 <mpinit+0xf4>
80103b79:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103b7c:	85 db                	test   %ebx,%ebx
80103b7e:	0f 84 b9 00 00 00    	je     80103c3d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103b84:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103b88:	74 15                	je     80103b9f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b8a:	b8 70 00 00 00       	mov    $0x70,%eax
80103b8f:	ba 22 00 00 00       	mov    $0x22,%edx
80103b94:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b95:	ba 23 00 00 00       	mov    $0x23,%edx
80103b9a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b9b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b9e:	ee                   	out    %al,(%dx)
  }
}
80103b9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ba2:	5b                   	pop    %ebx
80103ba3:	5e                   	pop    %esi
80103ba4:	5f                   	pop    %edi
80103ba5:	5d                   	pop    %ebp
80103ba6:	c3                   	ret    
80103ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bae:	66 90                	xchg   %ax,%ax
    switch(*p){
80103bb0:	83 e9 03             	sub    $0x3,%ecx
80103bb3:	80 f9 01             	cmp    $0x1,%cl
80103bb6:	76 ba                	jbe    80103b72 <mpinit+0x102>
80103bb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103bbf:	eb 9f                	jmp    80103b60 <mpinit+0xf0>
80103bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103bc8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103bcc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103bcf:	88 0d 80 3c 11 80    	mov    %cl,0x80113c80
      continue;
80103bd5:	eb 89                	jmp    80103b60 <mpinit+0xf0>
80103bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bde:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103be0:	8b 0d 20 42 11 80    	mov    0x80114220,%ecx
80103be6:	83 f9 07             	cmp    $0x7,%ecx
80103be9:	7f 19                	jg     80103c04 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103beb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103bf1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103bf5:	83 c1 01             	add    $0x1,%ecx
80103bf8:	89 0d 20 42 11 80    	mov    %ecx,0x80114220
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103bfe:	88 9f a0 3c 11 80    	mov    %bl,-0x7feec360(%edi)
      p += sizeof(struct mpproc);
80103c04:	83 c0 14             	add    $0x14,%eax
      continue;
80103c07:	e9 54 ff ff ff       	jmp    80103b60 <mpinit+0xf0>
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103c10:	ba 00 00 01 00       	mov    $0x10000,%edx
80103c15:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103c1a:	e8 d1 fd ff ff       	call   801039f0 <mpsearch1>
80103c1f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c21:	85 c0                	test   %eax,%eax
80103c23:	0f 85 9b fe ff ff    	jne    80103ac4 <mpinit+0x54>
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	68 62 7e 10 80       	push   $0x80107e62
80103c38:	e8 53 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103c3d:	83 ec 0c             	sub    $0xc,%esp
80103c40:	68 7c 7e 10 80       	push   $0x80107e7c
80103c45:	e8 46 c7 ff ff       	call   80100390 <panic>
80103c4a:	66 90                	xchg   %ax,%ax
80103c4c:	66 90                	xchg   %ax,%ax
80103c4e:	66 90                	xchg   %ax,%ax

80103c50 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c59:	ba 21 00 00 00       	mov    $0x21,%edx
80103c5e:	ee                   	out    %al,(%dx)
80103c5f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103c64:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103c65:	c3                   	ret    
80103c66:	66 90                	xchg   %ax,%ax
80103c68:	66 90                	xchg   %ax,%ax
80103c6a:	66 90                	xchg   %ax,%ax
80103c6c:	66 90                	xchg   %ax,%ax
80103c6e:	66 90                	xchg   %ax,%ax

80103c70 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c70:	f3 0f 1e fb          	endbr32 
80103c74:	55                   	push   %ebp
80103c75:	89 e5                	mov    %esp,%ebp
80103c77:	57                   	push   %edi
80103c78:	56                   	push   %esi
80103c79:	53                   	push   %ebx
80103c7a:	83 ec 0c             	sub    $0xc,%esp
80103c7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c80:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103c83:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103c89:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c8f:	e8 ec d9 ff ff       	call   80101680 <filealloc>
80103c94:	89 03                	mov    %eax,(%ebx)
80103c96:	85 c0                	test   %eax,%eax
80103c98:	0f 84 ac 00 00 00    	je     80103d4a <pipealloc+0xda>
80103c9e:	e8 dd d9 ff ff       	call   80101680 <filealloc>
80103ca3:	89 06                	mov    %eax,(%esi)
80103ca5:	85 c0                	test   %eax,%eax
80103ca7:	0f 84 8b 00 00 00    	je     80103d38 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103cad:	e8 fe f1 ff ff       	call   80102eb0 <kalloc>
80103cb2:	89 c7                	mov    %eax,%edi
80103cb4:	85 c0                	test   %eax,%eax
80103cb6:	0f 84 b4 00 00 00    	je     80103d70 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103cbc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103cc3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103cc6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103cc9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103cd0:	00 00 00 
  p->nwrite = 0;
80103cd3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cda:	00 00 00 
  p->nread = 0;
80103cdd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ce4:	00 00 00 
  initlock(&p->lock, "pipe");
80103ce7:	68 9b 7e 10 80       	push   $0x80107e9b
80103cec:	50                   	push   %eax
80103ced:	e8 6e 0f 00 00       	call   80104c60 <initlock>
  (*f0)->type = FD_PIPE;
80103cf2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103cf4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103cf7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cfd:	8b 03                	mov    (%ebx),%eax
80103cff:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d03:	8b 03                	mov    (%ebx),%eax
80103d05:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d09:	8b 03                	mov    (%ebx),%eax
80103d0b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d0e:	8b 06                	mov    (%esi),%eax
80103d10:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d16:	8b 06                	mov    (%esi),%eax
80103d18:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d1c:	8b 06                	mov    (%esi),%eax
80103d1e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d22:	8b 06                	mov    (%esi),%eax
80103d24:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103d2a:	31 c0                	xor    %eax,%eax
}
80103d2c:	5b                   	pop    %ebx
80103d2d:	5e                   	pop    %esi
80103d2e:	5f                   	pop    %edi
80103d2f:	5d                   	pop    %ebp
80103d30:	c3                   	ret    
80103d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103d38:	8b 03                	mov    (%ebx),%eax
80103d3a:	85 c0                	test   %eax,%eax
80103d3c:	74 1e                	je     80103d5c <pipealloc+0xec>
    fileclose(*f0);
80103d3e:	83 ec 0c             	sub    $0xc,%esp
80103d41:	50                   	push   %eax
80103d42:	e8 f9 d9 ff ff       	call   80101740 <fileclose>
80103d47:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103d4a:	8b 06                	mov    (%esi),%eax
80103d4c:	85 c0                	test   %eax,%eax
80103d4e:	74 0c                	je     80103d5c <pipealloc+0xec>
    fileclose(*f1);
80103d50:	83 ec 0c             	sub    $0xc,%esp
80103d53:	50                   	push   %eax
80103d54:	e8 e7 d9 ff ff       	call   80101740 <fileclose>
80103d59:	83 c4 10             	add    $0x10,%esp
}
80103d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103d5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d64:	5b                   	pop    %ebx
80103d65:	5e                   	pop    %esi
80103d66:	5f                   	pop    %edi
80103d67:	5d                   	pop    %ebp
80103d68:	c3                   	ret    
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103d70:	8b 03                	mov    (%ebx),%eax
80103d72:	85 c0                	test   %eax,%eax
80103d74:	75 c8                	jne    80103d3e <pipealloc+0xce>
80103d76:	eb d2                	jmp    80103d4a <pipealloc+0xda>
80103d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7f:	90                   	nop

80103d80 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d80:	f3 0f 1e fb          	endbr32 
80103d84:	55                   	push   %ebp
80103d85:	89 e5                	mov    %esp,%ebp
80103d87:	56                   	push   %esi
80103d88:	53                   	push   %ebx
80103d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103d8f:	83 ec 0c             	sub    $0xc,%esp
80103d92:	53                   	push   %ebx
80103d93:	e8 48 10 00 00       	call   80104de0 <acquire>
  if(writable){
80103d98:	83 c4 10             	add    $0x10,%esp
80103d9b:	85 f6                	test   %esi,%esi
80103d9d:	74 41                	je     80103de0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103d9f:	83 ec 0c             	sub    $0xc,%esp
80103da2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103da8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103daf:	00 00 00 
    wakeup(&p->nread);
80103db2:	50                   	push   %eax
80103db3:	e8 a8 0b 00 00       	call   80104960 <wakeup>
80103db8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dbb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103dc1:	85 d2                	test   %edx,%edx
80103dc3:	75 0a                	jne    80103dcf <pipeclose+0x4f>
80103dc5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103dcb:	85 c0                	test   %eax,%eax
80103dcd:	74 31                	je     80103e00 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103dcf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103dd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dd5:	5b                   	pop    %ebx
80103dd6:	5e                   	pop    %esi
80103dd7:	5d                   	pop    %ebp
    release(&p->lock);
80103dd8:	e9 c3 10 00 00       	jmp    80104ea0 <release>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103de0:	83 ec 0c             	sub    $0xc,%esp
80103de3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103de9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103df0:	00 00 00 
    wakeup(&p->nwrite);
80103df3:	50                   	push   %eax
80103df4:	e8 67 0b 00 00       	call   80104960 <wakeup>
80103df9:	83 c4 10             	add    $0x10,%esp
80103dfc:	eb bd                	jmp    80103dbb <pipeclose+0x3b>
80103dfe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103e00:	83 ec 0c             	sub    $0xc,%esp
80103e03:	53                   	push   %ebx
80103e04:	e8 97 10 00 00       	call   80104ea0 <release>
    kfree((char*)p);
80103e09:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103e0c:	83 c4 10             	add    $0x10,%esp
}
80103e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e12:	5b                   	pop    %ebx
80103e13:	5e                   	pop    %esi
80103e14:	5d                   	pop    %ebp
    kfree((char*)p);
80103e15:	e9 d6 ee ff ff       	jmp    80102cf0 <kfree>
80103e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e20 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e20:	f3 0f 1e fb          	endbr32 
80103e24:	55                   	push   %ebp
80103e25:	89 e5                	mov    %esp,%ebp
80103e27:	57                   	push   %edi
80103e28:	56                   	push   %esi
80103e29:	53                   	push   %ebx
80103e2a:	83 ec 28             	sub    $0x28,%esp
80103e2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103e30:	53                   	push   %ebx
80103e31:	e8 aa 0f 00 00       	call   80104de0 <acquire>
  for(i = 0; i < n; i++){
80103e36:	8b 45 10             	mov    0x10(%ebp),%eax
80103e39:	83 c4 10             	add    $0x10,%esp
80103e3c:	85 c0                	test   %eax,%eax
80103e3e:	0f 8e bc 00 00 00    	jle    80103f00 <pipewrite+0xe0>
80103e44:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e47:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103e4d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103e53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e56:	03 45 10             	add    0x10(%ebp),%eax
80103e59:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e5c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e62:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e68:	89 ca                	mov    %ecx,%edx
80103e6a:	05 00 02 00 00       	add    $0x200,%eax
80103e6f:	39 c1                	cmp    %eax,%ecx
80103e71:	74 3b                	je     80103eae <pipewrite+0x8e>
80103e73:	eb 63                	jmp    80103ed8 <pipewrite+0xb8>
80103e75:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103e78:	e8 63 03 00 00       	call   801041e0 <myproc>
80103e7d:	8b 48 24             	mov    0x24(%eax),%ecx
80103e80:	85 c9                	test   %ecx,%ecx
80103e82:	75 34                	jne    80103eb8 <pipewrite+0x98>
      wakeup(&p->nread);
80103e84:	83 ec 0c             	sub    $0xc,%esp
80103e87:	57                   	push   %edi
80103e88:	e8 d3 0a 00 00       	call   80104960 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e8d:	58                   	pop    %eax
80103e8e:	5a                   	pop    %edx
80103e8f:	53                   	push   %ebx
80103e90:	56                   	push   %esi
80103e91:	e8 0a 09 00 00       	call   801047a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e96:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103e9c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103ea2:	83 c4 10             	add    $0x10,%esp
80103ea5:	05 00 02 00 00       	add    $0x200,%eax
80103eaa:	39 c2                	cmp    %eax,%edx
80103eac:	75 2a                	jne    80103ed8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103eae:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103eb4:	85 c0                	test   %eax,%eax
80103eb6:	75 c0                	jne    80103e78 <pipewrite+0x58>
        release(&p->lock);
80103eb8:	83 ec 0c             	sub    $0xc,%esp
80103ebb:	53                   	push   %ebx
80103ebc:	e8 df 0f 00 00       	call   80104ea0 <release>
        return -1;
80103ec1:	83 c4 10             	add    $0x10,%esp
80103ec4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ecc:	5b                   	pop    %ebx
80103ecd:	5e                   	pop    %esi
80103ece:	5f                   	pop    %edi
80103ecf:	5d                   	pop    %ebp
80103ed0:	c3                   	ret    
80103ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ed8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103edb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103ede:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103ee4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103eea:	0f b6 06             	movzbl (%esi),%eax
80103eed:	83 c6 01             	add    $0x1,%esi
80103ef0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103ef3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103ef7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103efa:	0f 85 5c ff ff ff    	jne    80103e5c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f00:	83 ec 0c             	sub    $0xc,%esp
80103f03:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103f09:	50                   	push   %eax
80103f0a:	e8 51 0a 00 00       	call   80104960 <wakeup>
  release(&p->lock);
80103f0f:	89 1c 24             	mov    %ebx,(%esp)
80103f12:	e8 89 0f 00 00       	call   80104ea0 <release>
  return n;
80103f17:	8b 45 10             	mov    0x10(%ebp),%eax
80103f1a:	83 c4 10             	add    $0x10,%esp
80103f1d:	eb aa                	jmp    80103ec9 <pipewrite+0xa9>
80103f1f:	90                   	nop

80103f20 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f20:	f3 0f 1e fb          	endbr32 
80103f24:	55                   	push   %ebp
80103f25:	89 e5                	mov    %esp,%ebp
80103f27:	57                   	push   %edi
80103f28:	56                   	push   %esi
80103f29:	53                   	push   %ebx
80103f2a:	83 ec 18             	sub    $0x18,%esp
80103f2d:	8b 75 08             	mov    0x8(%ebp),%esi
80103f30:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103f33:	56                   	push   %esi
80103f34:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103f3a:	e8 a1 0e 00 00       	call   80104de0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f3f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103f45:	83 c4 10             	add    $0x10,%esp
80103f48:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103f4e:	74 33                	je     80103f83 <piperead+0x63>
80103f50:	eb 3b                	jmp    80103f8d <piperead+0x6d>
80103f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103f58:	e8 83 02 00 00       	call   801041e0 <myproc>
80103f5d:	8b 48 24             	mov    0x24(%eax),%ecx
80103f60:	85 c9                	test   %ecx,%ecx
80103f62:	0f 85 88 00 00 00    	jne    80103ff0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f68:	83 ec 08             	sub    $0x8,%esp
80103f6b:	56                   	push   %esi
80103f6c:	53                   	push   %ebx
80103f6d:	e8 2e 08 00 00       	call   801047a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f72:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103f78:	83 c4 10             	add    $0x10,%esp
80103f7b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103f81:	75 0a                	jne    80103f8d <piperead+0x6d>
80103f83:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103f89:	85 c0                	test   %eax,%eax
80103f8b:	75 cb                	jne    80103f58 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f8d:	8b 55 10             	mov    0x10(%ebp),%edx
80103f90:	31 db                	xor    %ebx,%ebx
80103f92:	85 d2                	test   %edx,%edx
80103f94:	7f 28                	jg     80103fbe <piperead+0x9e>
80103f96:	eb 34                	jmp    80103fcc <piperead+0xac>
80103f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103fa0:	8d 48 01             	lea    0x1(%eax),%ecx
80103fa3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103fa8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103fae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103fb3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fb6:	83 c3 01             	add    $0x1,%ebx
80103fb9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103fbc:	74 0e                	je     80103fcc <piperead+0xac>
    if(p->nread == p->nwrite)
80103fbe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103fc4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103fca:	75 d4                	jne    80103fa0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fcc:	83 ec 0c             	sub    $0xc,%esp
80103fcf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103fd5:	50                   	push   %eax
80103fd6:	e8 85 09 00 00       	call   80104960 <wakeup>
  release(&p->lock);
80103fdb:	89 34 24             	mov    %esi,(%esp)
80103fde:	e8 bd 0e 00 00       	call   80104ea0 <release>
  return i;
80103fe3:	83 c4 10             	add    $0x10,%esp
}
80103fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe9:	89 d8                	mov    %ebx,%eax
80103feb:	5b                   	pop    %ebx
80103fec:	5e                   	pop    %esi
80103fed:	5f                   	pop    %edi
80103fee:	5d                   	pop    %ebp
80103fef:	c3                   	ret    
      release(&p->lock);
80103ff0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ff3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103ff8:	56                   	push   %esi
80103ff9:	e8 a2 0e 00 00       	call   80104ea0 <release>
      return -1;
80103ffe:	83 c4 10             	add    $0x10,%esp
}
80104001:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104004:	89 d8                	mov    %ebx,%eax
80104006:	5b                   	pop    %ebx
80104007:	5e                   	pop    %esi
80104008:	5f                   	pop    %edi
80104009:	5d                   	pop    %ebp
8010400a:	c3                   	ret    
8010400b:	66 90                	xchg   %ax,%ax
8010400d:	66 90                	xchg   %ax,%ax
8010400f:	90                   	nop

80104010 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104014:	bb 74 42 11 80       	mov    $0x80114274,%ebx
{
80104019:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010401c:	68 40 42 11 80       	push   $0x80114240
80104021:	e8 ba 0d 00 00       	call   80104de0 <acquire>
80104026:	83 c4 10             	add    $0x10,%esp
80104029:	eb 10                	jmp    8010403b <allocproc+0x2b>
8010402b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010402f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104030:	83 c3 7c             	add    $0x7c,%ebx
80104033:	81 fb 74 61 11 80    	cmp    $0x80116174,%ebx
80104039:	74 75                	je     801040b0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010403b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010403e:	85 c0                	test   %eax,%eax
80104040:	75 ee                	jne    80104030 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104042:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104047:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010404a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104051:	89 43 10             	mov    %eax,0x10(%ebx)
80104054:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104057:	68 40 42 11 80       	push   $0x80114240
  p->pid = nextpid++;
8010405c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104062:	e8 39 0e 00 00       	call   80104ea0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104067:	e8 44 ee ff ff       	call   80102eb0 <kalloc>
8010406c:	83 c4 10             	add    $0x10,%esp
8010406f:	89 43 08             	mov    %eax,0x8(%ebx)
80104072:	85 c0                	test   %eax,%eax
80104074:	74 53                	je     801040c9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104076:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010407c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010407f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104084:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104087:	c7 40 14 06 61 10 80 	movl   $0x80106106,0x14(%eax)
  p->context = (struct context*)sp;
8010408e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104091:	6a 14                	push   $0x14
80104093:	6a 00                	push   $0x0
80104095:	50                   	push   %eax
80104096:	e8 55 0e 00 00       	call   80104ef0 <memset>
  p->context->eip = (uint)forkret;
8010409b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010409e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801040a1:	c7 40 10 e0 40 10 80 	movl   $0x801040e0,0x10(%eax)
}
801040a8:	89 d8                	mov    %ebx,%eax
801040aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040ad:	c9                   	leave  
801040ae:	c3                   	ret    
801040af:	90                   	nop
  release(&ptable.lock);
801040b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801040b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801040b5:	68 40 42 11 80       	push   $0x80114240
801040ba:	e8 e1 0d 00 00       	call   80104ea0 <release>
}
801040bf:	89 d8                	mov    %ebx,%eax
  return 0;
801040c1:	83 c4 10             	add    $0x10,%esp
}
801040c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040c7:	c9                   	leave  
801040c8:	c3                   	ret    
    p->state = UNUSED;
801040c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801040d0:	31 db                	xor    %ebx,%ebx
}
801040d2:	89 d8                	mov    %ebx,%eax
801040d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d7:	c9                   	leave  
801040d8:	c3                   	ret    
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801040e0:	f3 0f 1e fb          	endbr32 
801040e4:	55                   	push   %ebp
801040e5:	89 e5                	mov    %esp,%ebp
801040e7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801040ea:	68 40 42 11 80       	push   $0x80114240
801040ef:	e8 ac 0d 00 00       	call   80104ea0 <release>

  if (first) {
801040f4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801040f9:	83 c4 10             	add    $0x10,%esp
801040fc:	85 c0                	test   %eax,%eax
801040fe:	75 08                	jne    80104108 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104100:	c9                   	leave  
80104101:	c3                   	ret    
80104102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104108:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010410f:	00 00 00 
    iinit(ROOTDEV);
80104112:	83 ec 0c             	sub    $0xc,%esp
80104115:	6a 01                	push   $0x1
80104117:	e8 a4 dc ff ff       	call   80101dc0 <iinit>
    initlog(ROOTDEV);
8010411c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104123:	e8 e8 f3 ff ff       	call   80103510 <initlog>
}
80104128:	83 c4 10             	add    $0x10,%esp
8010412b:	c9                   	leave  
8010412c:	c3                   	ret    
8010412d:	8d 76 00             	lea    0x0(%esi),%esi

80104130 <pinit>:
{
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
80104137:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010413a:	68 a0 7e 10 80       	push   $0x80107ea0
8010413f:	68 40 42 11 80       	push   $0x80114240
80104144:	e8 17 0b 00 00       	call   80104c60 <initlock>
}
80104149:	83 c4 10             	add    $0x10,%esp
8010414c:	c9                   	leave  
8010414d:	c3                   	ret    
8010414e:	66 90                	xchg   %ax,%ax

80104150 <mycpu>:
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	56                   	push   %esi
80104158:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104159:	9c                   	pushf  
8010415a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010415b:	f6 c4 02             	test   $0x2,%ah
8010415e:	75 4a                	jne    801041aa <mycpu+0x5a>
  apicid = lapicid();
80104160:	e8 bb ef ff ff       	call   80103120 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104165:	8b 35 20 42 11 80    	mov    0x80114220,%esi
  apicid = lapicid();
8010416b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010416d:	85 f6                	test   %esi,%esi
8010416f:	7e 2c                	jle    8010419d <mycpu+0x4d>
80104171:	31 d2                	xor    %edx,%edx
80104173:	eb 0a                	jmp    8010417f <mycpu+0x2f>
80104175:	8d 76 00             	lea    0x0(%esi),%esi
80104178:	83 c2 01             	add    $0x1,%edx
8010417b:	39 f2                	cmp    %esi,%edx
8010417d:	74 1e                	je     8010419d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010417f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104185:	0f b6 81 a0 3c 11 80 	movzbl -0x7feec360(%ecx),%eax
8010418c:	39 d8                	cmp    %ebx,%eax
8010418e:	75 e8                	jne    80104178 <mycpu+0x28>
}
80104190:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104193:	8d 81 a0 3c 11 80    	lea    -0x7feec360(%ecx),%eax
}
80104199:	5b                   	pop    %ebx
8010419a:	5e                   	pop    %esi
8010419b:	5d                   	pop    %ebp
8010419c:	c3                   	ret    
  panic("unknown apicid\n");
8010419d:	83 ec 0c             	sub    $0xc,%esp
801041a0:	68 a7 7e 10 80       	push   $0x80107ea7
801041a5:	e8 e6 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801041aa:	83 ec 0c             	sub    $0xc,%esp
801041ad:	68 84 7f 10 80       	push   $0x80107f84
801041b2:	e8 d9 c1 ff ff       	call   80100390 <panic>
801041b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041be:	66 90                	xchg   %ax,%ax

801041c0 <cpuid>:
cpuid() {
801041c0:	f3 0f 1e fb          	endbr32 
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801041ca:	e8 81 ff ff ff       	call   80104150 <mycpu>
}
801041cf:	c9                   	leave  
  return mycpu()-cpus;
801041d0:	2d a0 3c 11 80       	sub    $0x80113ca0,%eax
801041d5:	c1 f8 04             	sar    $0x4,%eax
801041d8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801041de:	c3                   	ret    
801041df:	90                   	nop

801041e0 <myproc>:
myproc(void) {
801041e0:	f3 0f 1e fb          	endbr32 
801041e4:	55                   	push   %ebp
801041e5:	89 e5                	mov    %esp,%ebp
801041e7:	53                   	push   %ebx
801041e8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801041eb:	e8 f0 0a 00 00       	call   80104ce0 <pushcli>
  c = mycpu();
801041f0:	e8 5b ff ff ff       	call   80104150 <mycpu>
  p = c->proc;
801041f5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041fb:	e8 30 0b 00 00       	call   80104d30 <popcli>
}
80104200:	83 c4 04             	add    $0x4,%esp
80104203:	89 d8                	mov    %ebx,%eax
80104205:	5b                   	pop    %ebx
80104206:	5d                   	pop    %ebp
80104207:	c3                   	ret    
80104208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420f:	90                   	nop

80104210 <userinit>:
{
80104210:	f3 0f 1e fb          	endbr32 
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	53                   	push   %ebx
80104218:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010421b:	e8 f0 fd ff ff       	call   80104010 <allocproc>
80104220:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104222:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104227:	e8 a4 34 00 00       	call   801076d0 <setupkvm>
8010422c:	89 43 04             	mov    %eax,0x4(%ebx)
8010422f:	85 c0                	test   %eax,%eax
80104231:	0f 84 bd 00 00 00    	je     801042f4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104237:	83 ec 04             	sub    $0x4,%esp
8010423a:	68 2c 00 00 00       	push   $0x2c
8010423f:	68 60 b4 10 80       	push   $0x8010b460
80104244:	50                   	push   %eax
80104245:	e8 56 31 00 00       	call   801073a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010424a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010424d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104253:	6a 4c                	push   $0x4c
80104255:	6a 00                	push   $0x0
80104257:	ff 73 18             	pushl  0x18(%ebx)
8010425a:	e8 91 0c 00 00       	call   80104ef0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010425f:	8b 43 18             	mov    0x18(%ebx),%eax
80104262:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104267:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010426a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010426f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104273:	8b 43 18             	mov    0x18(%ebx),%eax
80104276:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010427a:	8b 43 18             	mov    0x18(%ebx),%eax
8010427d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104281:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104285:	8b 43 18             	mov    0x18(%ebx),%eax
80104288:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010428c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104290:	8b 43 18             	mov    0x18(%ebx),%eax
80104293:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010429a:	8b 43 18             	mov    0x18(%ebx),%eax
8010429d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801042a4:	8b 43 18             	mov    0x18(%ebx),%eax
801042a7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042ae:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042b1:	6a 10                	push   $0x10
801042b3:	68 d0 7e 10 80       	push   $0x80107ed0
801042b8:	50                   	push   %eax
801042b9:	e8 f2 0d 00 00       	call   801050b0 <safestrcpy>
  p->cwd = namei("/");
801042be:	c7 04 24 d9 7e 10 80 	movl   $0x80107ed9,(%esp)
801042c5:	e8 e6 e5 ff ff       	call   801028b0 <namei>
801042ca:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801042cd:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
801042d4:	e8 07 0b 00 00       	call   80104de0 <acquire>
  p->state = RUNNABLE;
801042d9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801042e0:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
801042e7:	e8 b4 0b 00 00       	call   80104ea0 <release>
}
801042ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042ef:	83 c4 10             	add    $0x10,%esp
801042f2:	c9                   	leave  
801042f3:	c3                   	ret    
    panic("userinit: out of memory?");
801042f4:	83 ec 0c             	sub    $0xc,%esp
801042f7:	68 b7 7e 10 80       	push   $0x80107eb7
801042fc:	e8 8f c0 ff ff       	call   80100390 <panic>
80104301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430f:	90                   	nop

80104310 <growproc>:
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	56                   	push   %esi
80104318:	53                   	push   %ebx
80104319:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010431c:	e8 bf 09 00 00       	call   80104ce0 <pushcli>
  c = mycpu();
80104321:	e8 2a fe ff ff       	call   80104150 <mycpu>
  p = c->proc;
80104326:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010432c:	e8 ff 09 00 00       	call   80104d30 <popcli>
  sz = curproc->sz;
80104331:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104333:	85 f6                	test   %esi,%esi
80104335:	7f 19                	jg     80104350 <growproc+0x40>
  } else if(n < 0){
80104337:	75 37                	jne    80104370 <growproc+0x60>
  switchuvm(curproc);
80104339:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010433c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010433e:	53                   	push   %ebx
8010433f:	e8 4c 2f 00 00       	call   80107290 <switchuvm>
  return 0;
80104344:	83 c4 10             	add    $0x10,%esp
80104347:	31 c0                	xor    %eax,%eax
}
80104349:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010434c:	5b                   	pop    %ebx
8010434d:	5e                   	pop    %esi
8010434e:	5d                   	pop    %ebp
8010434f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104350:	83 ec 04             	sub    $0x4,%esp
80104353:	01 c6                	add    %eax,%esi
80104355:	56                   	push   %esi
80104356:	50                   	push   %eax
80104357:	ff 73 04             	pushl  0x4(%ebx)
8010435a:	e8 91 31 00 00       	call   801074f0 <allocuvm>
8010435f:	83 c4 10             	add    $0x10,%esp
80104362:	85 c0                	test   %eax,%eax
80104364:	75 d3                	jne    80104339 <growproc+0x29>
      return -1;
80104366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010436b:	eb dc                	jmp    80104349 <growproc+0x39>
8010436d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104370:	83 ec 04             	sub    $0x4,%esp
80104373:	01 c6                	add    %eax,%esi
80104375:	56                   	push   %esi
80104376:	50                   	push   %eax
80104377:	ff 73 04             	pushl  0x4(%ebx)
8010437a:	e8 a1 32 00 00       	call   80107620 <deallocuvm>
8010437f:	83 c4 10             	add    $0x10,%esp
80104382:	85 c0                	test   %eax,%eax
80104384:	75 b3                	jne    80104339 <growproc+0x29>
80104386:	eb de                	jmp    80104366 <growproc+0x56>
80104388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438f:	90                   	nop

80104390 <fork>:
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	57                   	push   %edi
80104398:	56                   	push   %esi
80104399:	53                   	push   %ebx
8010439a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010439d:	e8 3e 09 00 00       	call   80104ce0 <pushcli>
  c = mycpu();
801043a2:	e8 a9 fd ff ff       	call   80104150 <mycpu>
  p = c->proc;
801043a7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043ad:	e8 7e 09 00 00       	call   80104d30 <popcli>
  if((np = allocproc()) == 0){
801043b2:	e8 59 fc ff ff       	call   80104010 <allocproc>
801043b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043ba:	85 c0                	test   %eax,%eax
801043bc:	0f 84 bb 00 00 00    	je     8010447d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801043c2:	83 ec 08             	sub    $0x8,%esp
801043c5:	ff 33                	pushl  (%ebx)
801043c7:	89 c7                	mov    %eax,%edi
801043c9:	ff 73 04             	pushl  0x4(%ebx)
801043cc:	e8 cf 33 00 00       	call   801077a0 <copyuvm>
801043d1:	83 c4 10             	add    $0x10,%esp
801043d4:	89 47 04             	mov    %eax,0x4(%edi)
801043d7:	85 c0                	test   %eax,%eax
801043d9:	0f 84 a5 00 00 00    	je     80104484 <fork+0xf4>
  np->sz = curproc->sz;
801043df:	8b 03                	mov    (%ebx),%eax
801043e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043e4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801043e6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801043e9:	89 c8                	mov    %ecx,%eax
801043eb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801043ee:	b9 13 00 00 00       	mov    $0x13,%ecx
801043f3:	8b 73 18             	mov    0x18(%ebx),%esi
801043f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801043f8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801043fa:	8b 40 18             	mov    0x18(%eax),%eax
801043fd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104408:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010440c:	85 c0                	test   %eax,%eax
8010440e:	74 13                	je     80104423 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	50                   	push   %eax
80104414:	e8 d7 d2 ff ff       	call   801016f0 <filedup>
80104419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010441c:	83 c4 10             	add    $0x10,%esp
8010441f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104423:	83 c6 01             	add    $0x1,%esi
80104426:	83 fe 10             	cmp    $0x10,%esi
80104429:	75 dd                	jne    80104408 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010442b:	83 ec 0c             	sub    $0xc,%esp
8010442e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104431:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104434:	e8 77 db ff ff       	call   80101fb0 <idup>
80104439:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010443c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010443f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104442:	8d 47 6c             	lea    0x6c(%edi),%eax
80104445:	6a 10                	push   $0x10
80104447:	53                   	push   %ebx
80104448:	50                   	push   %eax
80104449:	e8 62 0c 00 00       	call   801050b0 <safestrcpy>
  pid = np->pid;
8010444e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104451:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
80104458:	e8 83 09 00 00       	call   80104de0 <acquire>
  np->state = RUNNABLE;
8010445d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104464:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
8010446b:	e8 30 0a 00 00       	call   80104ea0 <release>
  return pid;
80104470:	83 c4 10             	add    $0x10,%esp
}
80104473:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104476:	89 d8                	mov    %ebx,%eax
80104478:	5b                   	pop    %ebx
80104479:	5e                   	pop    %esi
8010447a:	5f                   	pop    %edi
8010447b:	5d                   	pop    %ebp
8010447c:	c3                   	ret    
    return -1;
8010447d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104482:	eb ef                	jmp    80104473 <fork+0xe3>
    kfree(np->kstack);
80104484:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104487:	83 ec 0c             	sub    $0xc,%esp
8010448a:	ff 73 08             	pushl  0x8(%ebx)
8010448d:	e8 5e e8 ff ff       	call   80102cf0 <kfree>
    np->kstack = 0;
80104492:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104499:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010449c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801044a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044a8:	eb c9                	jmp    80104473 <fork+0xe3>
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <scheduler>:
{
801044b0:	f3 0f 1e fb          	endbr32 
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	57                   	push   %edi
801044b8:	56                   	push   %esi
801044b9:	53                   	push   %ebx
801044ba:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801044bd:	e8 8e fc ff ff       	call   80104150 <mycpu>
  c->proc = 0;
801044c2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801044c9:	00 00 00 
  struct cpu *c = mycpu();
801044cc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801044ce:	8d 78 04             	lea    0x4(%eax),%edi
801044d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801044d8:	fb                   	sti    
    acquire(&ptable.lock);
801044d9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044dc:	bb 74 42 11 80       	mov    $0x80114274,%ebx
    acquire(&ptable.lock);
801044e1:	68 40 42 11 80       	push   $0x80114240
801044e6:	e8 f5 08 00 00       	call   80104de0 <acquire>
801044eb:	83 c4 10             	add    $0x10,%esp
801044ee:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
801044f0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801044f4:	75 33                	jne    80104529 <scheduler+0x79>
      switchuvm(p);
801044f6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801044f9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801044ff:	53                   	push   %ebx
80104500:	e8 8b 2d 00 00       	call   80107290 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104505:	58                   	pop    %eax
80104506:	5a                   	pop    %edx
80104507:	ff 73 1c             	pushl  0x1c(%ebx)
8010450a:	57                   	push   %edi
      p->state = RUNNING;
8010450b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104512:	e8 fc 0b 00 00       	call   80105113 <swtch>
      switchkvm();
80104517:	e8 54 2d 00 00       	call   80107270 <switchkvm>
      c->proc = 0;
8010451c:	83 c4 10             	add    $0x10,%esp
8010451f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104526:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104529:	83 c3 7c             	add    $0x7c,%ebx
8010452c:	81 fb 74 61 11 80    	cmp    $0x80116174,%ebx
80104532:	75 bc                	jne    801044f0 <scheduler+0x40>
    release(&ptable.lock);
80104534:	83 ec 0c             	sub    $0xc,%esp
80104537:	68 40 42 11 80       	push   $0x80114240
8010453c:	e8 5f 09 00 00       	call   80104ea0 <release>
    sti();
80104541:	83 c4 10             	add    $0x10,%esp
80104544:	eb 92                	jmp    801044d8 <scheduler+0x28>
80104546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454d:	8d 76 00             	lea    0x0(%esi),%esi

80104550 <sched>:
{
80104550:	f3 0f 1e fb          	endbr32 
80104554:	55                   	push   %ebp
80104555:	89 e5                	mov    %esp,%ebp
80104557:	56                   	push   %esi
80104558:	53                   	push   %ebx
  pushcli();
80104559:	e8 82 07 00 00       	call   80104ce0 <pushcli>
  c = mycpu();
8010455e:	e8 ed fb ff ff       	call   80104150 <mycpu>
  p = c->proc;
80104563:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104569:	e8 c2 07 00 00       	call   80104d30 <popcli>
  if(!holding(&ptable.lock))
8010456e:	83 ec 0c             	sub    $0xc,%esp
80104571:	68 40 42 11 80       	push   $0x80114240
80104576:	e8 15 08 00 00       	call   80104d90 <holding>
8010457b:	83 c4 10             	add    $0x10,%esp
8010457e:	85 c0                	test   %eax,%eax
80104580:	74 4f                	je     801045d1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104582:	e8 c9 fb ff ff       	call   80104150 <mycpu>
80104587:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010458e:	75 68                	jne    801045f8 <sched+0xa8>
  if(p->state == RUNNING)
80104590:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104594:	74 55                	je     801045eb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104596:	9c                   	pushf  
80104597:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104598:	f6 c4 02             	test   $0x2,%ah
8010459b:	75 41                	jne    801045de <sched+0x8e>
  intena = mycpu()->intena;
8010459d:	e8 ae fb ff ff       	call   80104150 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801045a2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801045a5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801045ab:	e8 a0 fb ff ff       	call   80104150 <mycpu>
801045b0:	83 ec 08             	sub    $0x8,%esp
801045b3:	ff 70 04             	pushl  0x4(%eax)
801045b6:	53                   	push   %ebx
801045b7:	e8 57 0b 00 00       	call   80105113 <swtch>
  mycpu()->intena = intena;
801045bc:	e8 8f fb ff ff       	call   80104150 <mycpu>
}
801045c1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801045c4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801045ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045cd:	5b                   	pop    %ebx
801045ce:	5e                   	pop    %esi
801045cf:	5d                   	pop    %ebp
801045d0:	c3                   	ret    
    panic("sched ptable.lock");
801045d1:	83 ec 0c             	sub    $0xc,%esp
801045d4:	68 db 7e 10 80       	push   $0x80107edb
801045d9:	e8 b2 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801045de:	83 ec 0c             	sub    $0xc,%esp
801045e1:	68 07 7f 10 80       	push   $0x80107f07
801045e6:	e8 a5 bd ff ff       	call   80100390 <panic>
    panic("sched running");
801045eb:	83 ec 0c             	sub    $0xc,%esp
801045ee:	68 f9 7e 10 80       	push   $0x80107ef9
801045f3:	e8 98 bd ff ff       	call   80100390 <panic>
    panic("sched locks");
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 ed 7e 10 80       	push   $0x80107eed
80104600:	e8 8b bd ff ff       	call   80100390 <panic>
80104605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104610 <exit>:
{
80104610:	f3 0f 1e fb          	endbr32 
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
80104617:	57                   	push   %edi
80104618:	56                   	push   %esi
80104619:	53                   	push   %ebx
8010461a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010461d:	e8 be 06 00 00       	call   80104ce0 <pushcli>
  c = mycpu();
80104622:	e8 29 fb ff ff       	call   80104150 <mycpu>
  p = c->proc;
80104627:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010462d:	e8 fe 06 00 00       	call   80104d30 <popcli>
  if(curproc == initproc)
80104632:	8d 5e 28             	lea    0x28(%esi),%ebx
80104635:	8d 7e 68             	lea    0x68(%esi),%edi
80104638:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010463e:	0f 84 f3 00 00 00    	je     80104737 <exit+0x127>
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104648:	8b 03                	mov    (%ebx),%eax
8010464a:	85 c0                	test   %eax,%eax
8010464c:	74 12                	je     80104660 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010464e:	83 ec 0c             	sub    $0xc,%esp
80104651:	50                   	push   %eax
80104652:	e8 e9 d0 ff ff       	call   80101740 <fileclose>
      curproc->ofile[fd] = 0;
80104657:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010465d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104660:	83 c3 04             	add    $0x4,%ebx
80104663:	39 df                	cmp    %ebx,%edi
80104665:	75 e1                	jne    80104648 <exit+0x38>
  begin_op();
80104667:	e8 44 ef ff ff       	call   801035b0 <begin_op>
  iput(curproc->cwd);
8010466c:	83 ec 0c             	sub    $0xc,%esp
8010466f:	ff 76 68             	pushl  0x68(%esi)
80104672:	e8 99 da ff ff       	call   80102110 <iput>
  end_op();
80104677:	e8 a4 ef ff ff       	call   80103620 <end_op>
  curproc->cwd = 0;
8010467c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104683:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
8010468a:	e8 51 07 00 00       	call   80104de0 <acquire>
  wakeup1(curproc->parent);
8010468f:	8b 56 14             	mov    0x14(%esi),%edx
80104692:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104695:	b8 74 42 11 80       	mov    $0x80114274,%eax
8010469a:	eb 0e                	jmp    801046aa <exit+0x9a>
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046a0:	83 c0 7c             	add    $0x7c,%eax
801046a3:	3d 74 61 11 80       	cmp    $0x80116174,%eax
801046a8:	74 1c                	je     801046c6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
801046aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046ae:	75 f0                	jne    801046a0 <exit+0x90>
801046b0:	3b 50 20             	cmp    0x20(%eax),%edx
801046b3:	75 eb                	jne    801046a0 <exit+0x90>
      p->state = RUNNABLE;
801046b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046bc:	83 c0 7c             	add    $0x7c,%eax
801046bf:	3d 74 61 11 80       	cmp    $0x80116174,%eax
801046c4:	75 e4                	jne    801046aa <exit+0x9a>
      p->parent = initproc;
801046c6:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046cc:	ba 74 42 11 80       	mov    $0x80114274,%edx
801046d1:	eb 10                	jmp    801046e3 <exit+0xd3>
801046d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d7:	90                   	nop
801046d8:	83 c2 7c             	add    $0x7c,%edx
801046db:	81 fa 74 61 11 80    	cmp    $0x80116174,%edx
801046e1:	74 3b                	je     8010471e <exit+0x10e>
    if(p->parent == curproc){
801046e3:	39 72 14             	cmp    %esi,0x14(%edx)
801046e6:	75 f0                	jne    801046d8 <exit+0xc8>
      if(p->state == ZOMBIE)
801046e8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801046ec:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801046ef:	75 e7                	jne    801046d8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046f1:	b8 74 42 11 80       	mov    $0x80114274,%eax
801046f6:	eb 12                	jmp    8010470a <exit+0xfa>
801046f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ff:	90                   	nop
80104700:	83 c0 7c             	add    $0x7c,%eax
80104703:	3d 74 61 11 80       	cmp    $0x80116174,%eax
80104708:	74 ce                	je     801046d8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010470a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010470e:	75 f0                	jne    80104700 <exit+0xf0>
80104710:	3b 48 20             	cmp    0x20(%eax),%ecx
80104713:	75 eb                	jne    80104700 <exit+0xf0>
      p->state = RUNNABLE;
80104715:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010471c:	eb e2                	jmp    80104700 <exit+0xf0>
  curproc->state = ZOMBIE;
8010471e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104725:	e8 26 fe ff ff       	call   80104550 <sched>
  panic("zombie exit");
8010472a:	83 ec 0c             	sub    $0xc,%esp
8010472d:	68 28 7f 10 80       	push   $0x80107f28
80104732:	e8 59 bc ff ff       	call   80100390 <panic>
    panic("init exiting");
80104737:	83 ec 0c             	sub    $0xc,%esp
8010473a:	68 1b 7f 10 80       	push   $0x80107f1b
8010473f:	e8 4c bc ff ff       	call   80100390 <panic>
80104744:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010474f:	90                   	nop

80104750 <yield>:
{
80104750:	f3 0f 1e fb          	endbr32 
80104754:	55                   	push   %ebp
80104755:	89 e5                	mov    %esp,%ebp
80104757:	53                   	push   %ebx
80104758:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010475b:	68 40 42 11 80       	push   $0x80114240
80104760:	e8 7b 06 00 00       	call   80104de0 <acquire>
  pushcli();
80104765:	e8 76 05 00 00       	call   80104ce0 <pushcli>
  c = mycpu();
8010476a:	e8 e1 f9 ff ff       	call   80104150 <mycpu>
  p = c->proc;
8010476f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104775:	e8 b6 05 00 00       	call   80104d30 <popcli>
  myproc()->state = RUNNABLE;
8010477a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104781:	e8 ca fd ff ff       	call   80104550 <sched>
  release(&ptable.lock);
80104786:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
8010478d:	e8 0e 07 00 00       	call   80104ea0 <release>
}
80104792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104795:	83 c4 10             	add    $0x10,%esp
80104798:	c9                   	leave  
80104799:	c3                   	ret    
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <sleep>:
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	57                   	push   %edi
801047a8:	56                   	push   %esi
801047a9:	53                   	push   %ebx
801047aa:	83 ec 0c             	sub    $0xc,%esp
801047ad:	8b 7d 08             	mov    0x8(%ebp),%edi
801047b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801047b3:	e8 28 05 00 00       	call   80104ce0 <pushcli>
  c = mycpu();
801047b8:	e8 93 f9 ff ff       	call   80104150 <mycpu>
  p = c->proc;
801047bd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047c3:	e8 68 05 00 00       	call   80104d30 <popcli>
  if(p == 0)
801047c8:	85 db                	test   %ebx,%ebx
801047ca:	0f 84 83 00 00 00    	je     80104853 <sleep+0xb3>
  if(lk == 0)
801047d0:	85 f6                	test   %esi,%esi
801047d2:	74 72                	je     80104846 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801047d4:	81 fe 40 42 11 80    	cmp    $0x80114240,%esi
801047da:	74 4c                	je     80104828 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801047dc:	83 ec 0c             	sub    $0xc,%esp
801047df:	68 40 42 11 80       	push   $0x80114240
801047e4:	e8 f7 05 00 00       	call   80104de0 <acquire>
    release(lk);
801047e9:	89 34 24             	mov    %esi,(%esp)
801047ec:	e8 af 06 00 00       	call   80104ea0 <release>
  p->chan = chan;
801047f1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047f4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047fb:	e8 50 fd ff ff       	call   80104550 <sched>
  p->chan = 0;
80104800:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104807:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
8010480e:	e8 8d 06 00 00       	call   80104ea0 <release>
    acquire(lk);
80104813:	89 75 08             	mov    %esi,0x8(%ebp)
80104816:	83 c4 10             	add    $0x10,%esp
}
80104819:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010481c:	5b                   	pop    %ebx
8010481d:	5e                   	pop    %esi
8010481e:	5f                   	pop    %edi
8010481f:	5d                   	pop    %ebp
    acquire(lk);
80104820:	e9 bb 05 00 00       	jmp    80104de0 <acquire>
80104825:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104828:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010482b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104832:	e8 19 fd ff ff       	call   80104550 <sched>
  p->chan = 0;
80104837:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010483e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104841:	5b                   	pop    %ebx
80104842:	5e                   	pop    %esi
80104843:	5f                   	pop    %edi
80104844:	5d                   	pop    %ebp
80104845:	c3                   	ret    
    panic("sleep without lk");
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	68 3a 7f 10 80       	push   $0x80107f3a
8010484e:	e8 3d bb ff ff       	call   80100390 <panic>
    panic("sleep");
80104853:	83 ec 0c             	sub    $0xc,%esp
80104856:	68 34 7f 10 80       	push   $0x80107f34
8010485b:	e8 30 bb ff ff       	call   80100390 <panic>

80104860 <wait>:
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	56                   	push   %esi
80104868:	53                   	push   %ebx
  pushcli();
80104869:	e8 72 04 00 00       	call   80104ce0 <pushcli>
  c = mycpu();
8010486e:	e8 dd f8 ff ff       	call   80104150 <mycpu>
  p = c->proc;
80104873:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104879:	e8 b2 04 00 00       	call   80104d30 <popcli>
  acquire(&ptable.lock);
8010487e:	83 ec 0c             	sub    $0xc,%esp
80104881:	68 40 42 11 80       	push   $0x80114240
80104886:	e8 55 05 00 00       	call   80104de0 <acquire>
8010488b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010488e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104890:	bb 74 42 11 80       	mov    $0x80114274,%ebx
80104895:	eb 14                	jmp    801048ab <wait+0x4b>
80104897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489e:	66 90                	xchg   %ax,%ax
801048a0:	83 c3 7c             	add    $0x7c,%ebx
801048a3:	81 fb 74 61 11 80    	cmp    $0x80116174,%ebx
801048a9:	74 1b                	je     801048c6 <wait+0x66>
      if(p->parent != curproc)
801048ab:	39 73 14             	cmp    %esi,0x14(%ebx)
801048ae:	75 f0                	jne    801048a0 <wait+0x40>
      if(p->state == ZOMBIE){
801048b0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801048b4:	74 32                	je     801048e8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048b6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801048b9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048be:	81 fb 74 61 11 80    	cmp    $0x80116174,%ebx
801048c4:	75 e5                	jne    801048ab <wait+0x4b>
    if(!havekids || curproc->killed){
801048c6:	85 c0                	test   %eax,%eax
801048c8:	74 74                	je     8010493e <wait+0xde>
801048ca:	8b 46 24             	mov    0x24(%esi),%eax
801048cd:	85 c0                	test   %eax,%eax
801048cf:	75 6d                	jne    8010493e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801048d1:	83 ec 08             	sub    $0x8,%esp
801048d4:	68 40 42 11 80       	push   $0x80114240
801048d9:	56                   	push   %esi
801048da:	e8 c1 fe ff ff       	call   801047a0 <sleep>
    havekids = 0;
801048df:	83 c4 10             	add    $0x10,%esp
801048e2:	eb aa                	jmp    8010488e <wait+0x2e>
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801048ee:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801048f1:	e8 fa e3 ff ff       	call   80102cf0 <kfree>
        freevm(p->pgdir);
801048f6:	5a                   	pop    %edx
801048f7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801048fa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104901:	e8 4a 2d 00 00       	call   80107650 <freevm>
        release(&ptable.lock);
80104906:	c7 04 24 40 42 11 80 	movl   $0x80114240,(%esp)
        p->pid = 0;
8010490d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104914:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010491b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010491f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104926:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010492d:	e8 6e 05 00 00       	call   80104ea0 <release>
        return pid;
80104932:	83 c4 10             	add    $0x10,%esp
}
80104935:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104938:	89 f0                	mov    %esi,%eax
8010493a:	5b                   	pop    %ebx
8010493b:	5e                   	pop    %esi
8010493c:	5d                   	pop    %ebp
8010493d:	c3                   	ret    
      release(&ptable.lock);
8010493e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104941:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104946:	68 40 42 11 80       	push   $0x80114240
8010494b:	e8 50 05 00 00       	call   80104ea0 <release>
      return -1;
80104950:	83 c4 10             	add    $0x10,%esp
80104953:	eb e0                	jmp    80104935 <wait+0xd5>
80104955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104960 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	53                   	push   %ebx
80104968:	83 ec 10             	sub    $0x10,%esp
8010496b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010496e:	68 40 42 11 80       	push   $0x80114240
80104973:	e8 68 04 00 00       	call   80104de0 <acquire>
80104978:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010497b:	b8 74 42 11 80       	mov    $0x80114274,%eax
80104980:	eb 10                	jmp    80104992 <wakeup+0x32>
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104988:	83 c0 7c             	add    $0x7c,%eax
8010498b:	3d 74 61 11 80       	cmp    $0x80116174,%eax
80104990:	74 1c                	je     801049ae <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104992:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104996:	75 f0                	jne    80104988 <wakeup+0x28>
80104998:	3b 58 20             	cmp    0x20(%eax),%ebx
8010499b:	75 eb                	jne    80104988 <wakeup+0x28>
      p->state = RUNNABLE;
8010499d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049a4:	83 c0 7c             	add    $0x7c,%eax
801049a7:	3d 74 61 11 80       	cmp    $0x80116174,%eax
801049ac:	75 e4                	jne    80104992 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801049ae:	c7 45 08 40 42 11 80 	movl   $0x80114240,0x8(%ebp)
}
801049b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b8:	c9                   	leave  
  release(&ptable.lock);
801049b9:	e9 e2 04 00 00       	jmp    80104ea0 <release>
801049be:	66 90                	xchg   %ax,%ax

801049c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	53                   	push   %ebx
801049c8:	83 ec 10             	sub    $0x10,%esp
801049cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801049ce:	68 40 42 11 80       	push   $0x80114240
801049d3:	e8 08 04 00 00       	call   80104de0 <acquire>
801049d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049db:	b8 74 42 11 80       	mov    $0x80114274,%eax
801049e0:	eb 10                	jmp    801049f2 <kill+0x32>
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049e8:	83 c0 7c             	add    $0x7c,%eax
801049eb:	3d 74 61 11 80       	cmp    $0x80116174,%eax
801049f0:	74 36                	je     80104a28 <kill+0x68>
    if(p->pid == pid){
801049f2:	39 58 10             	cmp    %ebx,0x10(%eax)
801049f5:	75 f1                	jne    801049e8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801049f7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801049fb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104a02:	75 07                	jne    80104a0b <kill+0x4b>
        p->state = RUNNABLE;
80104a04:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a0b:	83 ec 0c             	sub    $0xc,%esp
80104a0e:	68 40 42 11 80       	push   $0x80114240
80104a13:	e8 88 04 00 00       	call   80104ea0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104a1b:	83 c4 10             	add    $0x10,%esp
80104a1e:	31 c0                	xor    %eax,%eax
}
80104a20:	c9                   	leave  
80104a21:	c3                   	ret    
80104a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104a28:	83 ec 0c             	sub    $0xc,%esp
80104a2b:	68 40 42 11 80       	push   $0x80114240
80104a30:	e8 6b 04 00 00       	call   80104ea0 <release>
}
80104a35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104a38:	83 c4 10             	add    $0x10,%esp
80104a3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a40:	c9                   	leave  
80104a41:	c3                   	ret    
80104a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a50 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	57                   	push   %edi
80104a58:	56                   	push   %esi
80104a59:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104a5c:	53                   	push   %ebx
80104a5d:	bb e0 42 11 80       	mov    $0x801142e0,%ebx
80104a62:	83 ec 3c             	sub    $0x3c,%esp
80104a65:	eb 28                	jmp    80104a8f <procdump+0x3f>
80104a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a70:	83 ec 0c             	sub    $0xc,%esp
80104a73:	68 b7 82 10 80       	push   $0x801082b7
80104a78:	e8 d3 be ff ff       	call   80100950 <cprintf>
80104a7d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a80:	83 c3 7c             	add    $0x7c,%ebx
80104a83:	81 fb e0 61 11 80    	cmp    $0x801161e0,%ebx
80104a89:	0f 84 81 00 00 00    	je     80104b10 <procdump+0xc0>
    if(p->state == UNUSED)
80104a8f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104a92:	85 c0                	test   %eax,%eax
80104a94:	74 ea                	je     80104a80 <procdump+0x30>
      state = "???";
80104a96:	ba 4b 7f 10 80       	mov    $0x80107f4b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a9b:	83 f8 05             	cmp    $0x5,%eax
80104a9e:	77 11                	ja     80104ab1 <procdump+0x61>
80104aa0:	8b 14 85 ac 7f 10 80 	mov    -0x7fef8054(,%eax,4),%edx
      state = "???";
80104aa7:	b8 4b 7f 10 80       	mov    $0x80107f4b,%eax
80104aac:	85 d2                	test   %edx,%edx
80104aae:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104ab1:	53                   	push   %ebx
80104ab2:	52                   	push   %edx
80104ab3:	ff 73 a4             	pushl  -0x5c(%ebx)
80104ab6:	68 4f 7f 10 80       	push   $0x80107f4f
80104abb:	e8 90 be ff ff       	call   80100950 <cprintf>
    if(p->state == SLEEPING){
80104ac0:	83 c4 10             	add    $0x10,%esp
80104ac3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104ac7:	75 a7                	jne    80104a70 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ac9:	83 ec 08             	sub    $0x8,%esp
80104acc:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104acf:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104ad2:	50                   	push   %eax
80104ad3:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104ad6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ad9:	83 c0 08             	add    $0x8,%eax
80104adc:	50                   	push   %eax
80104add:	e8 9e 01 00 00       	call   80104c80 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ae2:	83 c4 10             	add    $0x10,%esp
80104ae5:	8d 76 00             	lea    0x0(%esi),%esi
80104ae8:	8b 17                	mov    (%edi),%edx
80104aea:	85 d2                	test   %edx,%edx
80104aec:	74 82                	je     80104a70 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104aee:	83 ec 08             	sub    $0x8,%esp
80104af1:	83 c7 04             	add    $0x4,%edi
80104af4:	52                   	push   %edx
80104af5:	68 a1 79 10 80       	push   $0x801079a1
80104afa:	e8 51 be ff ff       	call   80100950 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104aff:	83 c4 10             	add    $0x10,%esp
80104b02:	39 fe                	cmp    %edi,%esi
80104b04:	75 e2                	jne    80104ae8 <procdump+0x98>
80104b06:	e9 65 ff ff ff       	jmp    80104a70 <procdump+0x20>
80104b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b0f:	90                   	nop
  }
}
80104b10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b13:	5b                   	pop    %ebx
80104b14:	5e                   	pop    %esi
80104b15:	5f                   	pop    %edi
80104b16:	5d                   	pop    %ebp
80104b17:	c3                   	ret    
80104b18:	66 90                	xchg   %ax,%ax
80104b1a:	66 90                	xchg   %ax,%ax
80104b1c:	66 90                	xchg   %ax,%ax
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	53                   	push   %ebx
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b2e:	68 c4 7f 10 80       	push   $0x80107fc4
80104b33:	8d 43 04             	lea    0x4(%ebx),%eax
80104b36:	50                   	push   %eax
80104b37:	e8 24 01 00 00       	call   80104c60 <initlock>
  lk->name = name;
80104b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b3f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b45:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b48:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b4f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b55:	c9                   	leave  
80104b56:	c3                   	ret    
80104b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	56                   	push   %esi
80104b68:	53                   	push   %ebx
80104b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b6c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b6f:	83 ec 0c             	sub    $0xc,%esp
80104b72:	56                   	push   %esi
80104b73:	e8 68 02 00 00       	call   80104de0 <acquire>
  while (lk->locked) {
80104b78:	8b 13                	mov    (%ebx),%edx
80104b7a:	83 c4 10             	add    $0x10,%esp
80104b7d:	85 d2                	test   %edx,%edx
80104b7f:	74 1a                	je     80104b9b <acquiresleep+0x3b>
80104b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104b88:	83 ec 08             	sub    $0x8,%esp
80104b8b:	56                   	push   %esi
80104b8c:	53                   	push   %ebx
80104b8d:	e8 0e fc ff ff       	call   801047a0 <sleep>
  while (lk->locked) {
80104b92:	8b 03                	mov    (%ebx),%eax
80104b94:	83 c4 10             	add    $0x10,%esp
80104b97:	85 c0                	test   %eax,%eax
80104b99:	75 ed                	jne    80104b88 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104b9b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ba1:	e8 3a f6 ff ff       	call   801041e0 <myproc>
80104ba6:	8b 40 10             	mov    0x10(%eax),%eax
80104ba9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104bac:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb2:	5b                   	pop    %ebx
80104bb3:	5e                   	pop    %esi
80104bb4:	5d                   	pop    %ebp
  release(&lk->lk);
80104bb5:	e9 e6 02 00 00       	jmp    80104ea0 <release>
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104bc0:	f3 0f 1e fb          	endbr32 
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	56                   	push   %esi
80104bc8:	53                   	push   %ebx
80104bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bcc:	8d 73 04             	lea    0x4(%ebx),%esi
80104bcf:	83 ec 0c             	sub    $0xc,%esp
80104bd2:	56                   	push   %esi
80104bd3:	e8 08 02 00 00       	call   80104de0 <acquire>
  lk->locked = 0;
80104bd8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104bde:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104be5:	89 1c 24             	mov    %ebx,(%esp)
80104be8:	e8 73 fd ff ff       	call   80104960 <wakeup>
  release(&lk->lk);
80104bed:	89 75 08             	mov    %esi,0x8(%ebp)
80104bf0:	83 c4 10             	add    $0x10,%esp
}
80104bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bf6:	5b                   	pop    %ebx
80104bf7:	5e                   	pop    %esi
80104bf8:	5d                   	pop    %ebp
  release(&lk->lk);
80104bf9:	e9 a2 02 00 00       	jmp    80104ea0 <release>
80104bfe:	66 90                	xchg   %ax,%ax

80104c00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c00:	f3 0f 1e fb          	endbr32 
80104c04:	55                   	push   %ebp
80104c05:	89 e5                	mov    %esp,%ebp
80104c07:	57                   	push   %edi
80104c08:	31 ff                	xor    %edi,%edi
80104c0a:	56                   	push   %esi
80104c0b:	53                   	push   %ebx
80104c0c:	83 ec 18             	sub    $0x18,%esp
80104c0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c12:	8d 73 04             	lea    0x4(%ebx),%esi
80104c15:	56                   	push   %esi
80104c16:	e8 c5 01 00 00       	call   80104de0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c1b:	8b 03                	mov    (%ebx),%eax
80104c1d:	83 c4 10             	add    $0x10,%esp
80104c20:	85 c0                	test   %eax,%eax
80104c22:	75 1c                	jne    80104c40 <holdingsleep+0x40>
  release(&lk->lk);
80104c24:	83 ec 0c             	sub    $0xc,%esp
80104c27:	56                   	push   %esi
80104c28:	e8 73 02 00 00       	call   80104ea0 <release>
  return r;
}
80104c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c30:	89 f8                	mov    %edi,%eax
80104c32:	5b                   	pop    %ebx
80104c33:	5e                   	pop    %esi
80104c34:	5f                   	pop    %edi
80104c35:	5d                   	pop    %ebp
80104c36:	c3                   	ret    
80104c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104c40:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c43:	e8 98 f5 ff ff       	call   801041e0 <myproc>
80104c48:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c4b:	0f 94 c0             	sete   %al
80104c4e:	0f b6 c0             	movzbl %al,%eax
80104c51:	89 c7                	mov    %eax,%edi
80104c53:	eb cf                	jmp    80104c24 <holdingsleep+0x24>
80104c55:	66 90                	xchg   %ax,%ax
80104c57:	66 90                	xchg   %ax,%ax
80104c59:	66 90                	xchg   %ax,%ax
80104c5b:	66 90                	xchg   %ax,%ax
80104c5d:	66 90                	xchg   %ax,%ax
80104c5f:	90                   	nop

80104c60 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c60:	f3 0f 1e fb          	endbr32 
80104c64:	55                   	push   %ebp
80104c65:	89 e5                	mov    %esp,%ebp
80104c67:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c73:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c7d:	5d                   	pop    %ebp
80104c7e:	c3                   	ret    
80104c7f:	90                   	nop

80104c80 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c80:	f3 0f 1e fb          	endbr32 
80104c84:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c85:	31 d2                	xor    %edx,%edx
{
80104c87:	89 e5                	mov    %esp,%ebp
80104c89:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c8a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c90:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c97:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c98:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c9e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ca4:	77 1a                	ja     80104cc0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ca6:	8b 58 04             	mov    0x4(%eax),%ebx
80104ca9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104cac:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104caf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cb1:	83 fa 0a             	cmp    $0xa,%edx
80104cb4:	75 e2                	jne    80104c98 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104cb6:	5b                   	pop    %ebx
80104cb7:	5d                   	pop    %ebp
80104cb8:	c3                   	ret    
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104cc0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104cc3:	8d 51 28             	lea    0x28(%ecx),%edx
80104cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104cd6:	83 c0 04             	add    $0x4,%eax
80104cd9:	39 d0                	cmp    %edx,%eax
80104cdb:	75 f3                	jne    80104cd0 <getcallerpcs+0x50>
}
80104cdd:	5b                   	pop    %ebx
80104cde:	5d                   	pop    %ebp
80104cdf:	c3                   	ret    

80104ce0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	53                   	push   %ebx
80104ce8:	83 ec 04             	sub    $0x4,%esp
80104ceb:	9c                   	pushf  
80104cec:	5b                   	pop    %ebx
  asm volatile("cli");
80104ced:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104cee:	e8 5d f4 ff ff       	call   80104150 <mycpu>
80104cf3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104cf9:	85 c0                	test   %eax,%eax
80104cfb:	74 13                	je     80104d10 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104cfd:	e8 4e f4 ff ff       	call   80104150 <mycpu>
80104d02:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d09:	83 c4 04             	add    $0x4,%esp
80104d0c:	5b                   	pop    %ebx
80104d0d:	5d                   	pop    %ebp
80104d0e:	c3                   	ret    
80104d0f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104d10:	e8 3b f4 ff ff       	call   80104150 <mycpu>
80104d15:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d1b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d21:	eb da                	jmp    80104cfd <pushcli+0x1d>
80104d23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d30 <popcli>:

void
popcli(void)
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d3a:	9c                   	pushf  
80104d3b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d3c:	f6 c4 02             	test   $0x2,%ah
80104d3f:	75 31                	jne    80104d72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d41:	e8 0a f4 ff ff       	call   80104150 <mycpu>
80104d46:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d4d:	78 30                	js     80104d7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d4f:	e8 fc f3 ff ff       	call   80104150 <mycpu>
80104d54:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d5a:	85 d2                	test   %edx,%edx
80104d5c:	74 02                	je     80104d60 <popcli+0x30>
    sti();
}
80104d5e:	c9                   	leave  
80104d5f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d60:	e8 eb f3 ff ff       	call   80104150 <mycpu>
80104d65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d6b:	85 c0                	test   %eax,%eax
80104d6d:	74 ef                	je     80104d5e <popcli+0x2e>
  asm volatile("sti");
80104d6f:	fb                   	sti    
}
80104d70:	c9                   	leave  
80104d71:	c3                   	ret    
    panic("popcli - interruptible");
80104d72:	83 ec 0c             	sub    $0xc,%esp
80104d75:	68 cf 7f 10 80       	push   $0x80107fcf
80104d7a:	e8 11 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d7f:	83 ec 0c             	sub    $0xc,%esp
80104d82:	68 e6 7f 10 80       	push   $0x80107fe6
80104d87:	e8 04 b6 ff ff       	call   80100390 <panic>
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d90 <holding>:
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	56                   	push   %esi
80104d98:	53                   	push   %ebx
80104d99:	8b 75 08             	mov    0x8(%ebp),%esi
80104d9c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d9e:	e8 3d ff ff ff       	call   80104ce0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104da3:	8b 06                	mov    (%esi),%eax
80104da5:	85 c0                	test   %eax,%eax
80104da7:	75 0f                	jne    80104db8 <holding+0x28>
  popcli();
80104da9:	e8 82 ff ff ff       	call   80104d30 <popcli>
}
80104dae:	89 d8                	mov    %ebx,%eax
80104db0:	5b                   	pop    %ebx
80104db1:	5e                   	pop    %esi
80104db2:	5d                   	pop    %ebp
80104db3:	c3                   	ret    
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104db8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104dbb:	e8 90 f3 ff ff       	call   80104150 <mycpu>
80104dc0:	39 c3                	cmp    %eax,%ebx
80104dc2:	0f 94 c3             	sete   %bl
  popcli();
80104dc5:	e8 66 ff ff ff       	call   80104d30 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104dca:	0f b6 db             	movzbl %bl,%ebx
}
80104dcd:	89 d8                	mov    %ebx,%eax
80104dcf:	5b                   	pop    %ebx
80104dd0:	5e                   	pop    %esi
80104dd1:	5d                   	pop    %ebp
80104dd2:	c3                   	ret    
80104dd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104de0 <acquire>:
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	56                   	push   %esi
80104de8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104de9:	e8 f2 fe ff ff       	call   80104ce0 <pushcli>
  if(holding(lk))
80104dee:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104df1:	83 ec 0c             	sub    $0xc,%esp
80104df4:	53                   	push   %ebx
80104df5:	e8 96 ff ff ff       	call   80104d90 <holding>
80104dfa:	83 c4 10             	add    $0x10,%esp
80104dfd:	85 c0                	test   %eax,%eax
80104dff:	0f 85 7f 00 00 00    	jne    80104e84 <acquire+0xa4>
80104e05:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e07:	ba 01 00 00 00       	mov    $0x1,%edx
80104e0c:	eb 05                	jmp    80104e13 <acquire+0x33>
80104e0e:	66 90                	xchg   %ax,%ax
80104e10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e13:	89 d0                	mov    %edx,%eax
80104e15:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e18:	85 c0                	test   %eax,%eax
80104e1a:	75 f4                	jne    80104e10 <acquire+0x30>
  __sync_synchronize();
80104e1c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e24:	e8 27 f3 ff ff       	call   80104150 <mycpu>
80104e29:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e2c:	89 e8                	mov    %ebp,%eax
80104e2e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e30:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104e36:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104e3c:	77 22                	ja     80104e60 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e3e:	8b 50 04             	mov    0x4(%eax),%edx
80104e41:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104e45:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e48:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e4a:	83 fe 0a             	cmp    $0xa,%esi
80104e4d:	75 e1                	jne    80104e30 <acquire+0x50>
}
80104e4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e52:	5b                   	pop    %ebx
80104e53:	5e                   	pop    %esi
80104e54:	5d                   	pop    %ebp
80104e55:	c3                   	ret    
80104e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104e60:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104e64:	83 c3 34             	add    $0x34,%ebx
80104e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e76:	83 c0 04             	add    $0x4,%eax
80104e79:	39 d8                	cmp    %ebx,%eax
80104e7b:	75 f3                	jne    80104e70 <acquire+0x90>
}
80104e7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e80:	5b                   	pop    %ebx
80104e81:	5e                   	pop    %esi
80104e82:	5d                   	pop    %ebp
80104e83:	c3                   	ret    
    panic("acquire");
80104e84:	83 ec 0c             	sub    $0xc,%esp
80104e87:	68 ed 7f 10 80       	push   $0x80107fed
80104e8c:	e8 ff b4 ff ff       	call   80100390 <panic>
80104e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9f:	90                   	nop

80104ea0 <release>:
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	53                   	push   %ebx
80104ea8:	83 ec 10             	sub    $0x10,%esp
80104eab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104eae:	53                   	push   %ebx
80104eaf:	e8 dc fe ff ff       	call   80104d90 <holding>
80104eb4:	83 c4 10             	add    $0x10,%esp
80104eb7:	85 c0                	test   %eax,%eax
80104eb9:	74 22                	je     80104edd <release+0x3d>
  lk->pcs[0] = 0;
80104ebb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ec2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ec9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104ece:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ed7:	c9                   	leave  
  popcli();
80104ed8:	e9 53 fe ff ff       	jmp    80104d30 <popcli>
    panic("release");
80104edd:	83 ec 0c             	sub    $0xc,%esp
80104ee0:	68 f5 7f 10 80       	push   $0x80107ff5
80104ee5:	e8 a6 b4 ff ff       	call   80100390 <panic>
80104eea:	66 90                	xchg   %ax,%ax
80104eec:	66 90                	xchg   %ax,%ax
80104eee:	66 90                	xchg   %ax,%ax

80104ef0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	57                   	push   %edi
80104ef8:	8b 55 08             	mov    0x8(%ebp),%edx
80104efb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104efe:	53                   	push   %ebx
80104eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f02:	89 d7                	mov    %edx,%edi
80104f04:	09 cf                	or     %ecx,%edi
80104f06:	83 e7 03             	and    $0x3,%edi
80104f09:	75 25                	jne    80104f30 <memset+0x40>
    c &= 0xFF;
80104f0b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f0e:	c1 e0 18             	shl    $0x18,%eax
80104f11:	89 fb                	mov    %edi,%ebx
80104f13:	c1 e9 02             	shr    $0x2,%ecx
80104f16:	c1 e3 10             	shl    $0x10,%ebx
80104f19:	09 d8                	or     %ebx,%eax
80104f1b:	09 f8                	or     %edi,%eax
80104f1d:	c1 e7 08             	shl    $0x8,%edi
80104f20:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f22:	89 d7                	mov    %edx,%edi
80104f24:	fc                   	cld    
80104f25:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f27:	5b                   	pop    %ebx
80104f28:	89 d0                	mov    %edx,%eax
80104f2a:	5f                   	pop    %edi
80104f2b:	5d                   	pop    %ebp
80104f2c:	c3                   	ret    
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104f30:	89 d7                	mov    %edx,%edi
80104f32:	fc                   	cld    
80104f33:	f3 aa                	rep stos %al,%es:(%edi)
80104f35:	5b                   	pop    %ebx
80104f36:	89 d0                	mov    %edx,%eax
80104f38:	5f                   	pop    %edi
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    
80104f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop

80104f40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	56                   	push   %esi
80104f48:	8b 75 10             	mov    0x10(%ebp),%esi
80104f4b:	8b 55 08             	mov    0x8(%ebp),%edx
80104f4e:	53                   	push   %ebx
80104f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f52:	85 f6                	test   %esi,%esi
80104f54:	74 2a                	je     80104f80 <memcmp+0x40>
80104f56:	01 c6                	add    %eax,%esi
80104f58:	eb 10                	jmp    80104f6a <memcmp+0x2a>
80104f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f60:	83 c0 01             	add    $0x1,%eax
80104f63:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f66:	39 f0                	cmp    %esi,%eax
80104f68:	74 16                	je     80104f80 <memcmp+0x40>
    if(*s1 != *s2)
80104f6a:	0f b6 0a             	movzbl (%edx),%ecx
80104f6d:	0f b6 18             	movzbl (%eax),%ebx
80104f70:	38 d9                	cmp    %bl,%cl
80104f72:	74 ec                	je     80104f60 <memcmp+0x20>
      return *s1 - *s2;
80104f74:	0f b6 c1             	movzbl %cl,%eax
80104f77:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f79:	5b                   	pop    %ebx
80104f7a:	5e                   	pop    %esi
80104f7b:	5d                   	pop    %ebp
80104f7c:	c3                   	ret    
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi
80104f80:	5b                   	pop    %ebx
  return 0;
80104f81:	31 c0                	xor    %eax,%eax
}
80104f83:	5e                   	pop    %esi
80104f84:	5d                   	pop    %ebp
80104f85:	c3                   	ret    
80104f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
80104f95:	89 e5                	mov    %esp,%ebp
80104f97:	57                   	push   %edi
80104f98:	8b 55 08             	mov    0x8(%ebp),%edx
80104f9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f9e:	56                   	push   %esi
80104f9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fa2:	39 d6                	cmp    %edx,%esi
80104fa4:	73 2a                	jae    80104fd0 <memmove+0x40>
80104fa6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104fa9:	39 fa                	cmp    %edi,%edx
80104fab:	73 23                	jae    80104fd0 <memmove+0x40>
80104fad:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104fb0:	85 c9                	test   %ecx,%ecx
80104fb2:	74 13                	je     80104fc7 <memmove+0x37>
80104fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104fb8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104fbc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104fbf:	83 e8 01             	sub    $0x1,%eax
80104fc2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104fc5:	75 f1                	jne    80104fb8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104fc7:	5e                   	pop    %esi
80104fc8:	89 d0                	mov    %edx,%eax
80104fca:	5f                   	pop    %edi
80104fcb:	5d                   	pop    %ebp
80104fcc:	c3                   	ret    
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104fd0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104fd3:	89 d7                	mov    %edx,%edi
80104fd5:	85 c9                	test   %ecx,%ecx
80104fd7:	74 ee                	je     80104fc7 <memmove+0x37>
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104fe0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104fe1:	39 f0                	cmp    %esi,%eax
80104fe3:	75 fb                	jne    80104fe0 <memmove+0x50>
}
80104fe5:	5e                   	pop    %esi
80104fe6:	89 d0                	mov    %edx,%eax
80104fe8:	5f                   	pop    %edi
80104fe9:	5d                   	pop    %ebp
80104fea:	c3                   	ret    
80104feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fef:	90                   	nop

80104ff0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ff0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104ff4:	eb 9a                	jmp    80104f90 <memmove>
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi

80105000 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	56                   	push   %esi
80105008:	8b 75 10             	mov    0x10(%ebp),%esi
8010500b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010500e:	53                   	push   %ebx
8010500f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105012:	85 f6                	test   %esi,%esi
80105014:	74 32                	je     80105048 <strncmp+0x48>
80105016:	01 c6                	add    %eax,%esi
80105018:	eb 14                	jmp    8010502e <strncmp+0x2e>
8010501a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105020:	38 da                	cmp    %bl,%dl
80105022:	75 14                	jne    80105038 <strncmp+0x38>
    n--, p++, q++;
80105024:	83 c0 01             	add    $0x1,%eax
80105027:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010502a:	39 f0                	cmp    %esi,%eax
8010502c:	74 1a                	je     80105048 <strncmp+0x48>
8010502e:	0f b6 11             	movzbl (%ecx),%edx
80105031:	0f b6 18             	movzbl (%eax),%ebx
80105034:	84 d2                	test   %dl,%dl
80105036:	75 e8                	jne    80105020 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105038:	0f b6 c2             	movzbl %dl,%eax
8010503b:	29 d8                	sub    %ebx,%eax
}
8010503d:	5b                   	pop    %ebx
8010503e:	5e                   	pop    %esi
8010503f:	5d                   	pop    %ebp
80105040:	c3                   	ret    
80105041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105048:	5b                   	pop    %ebx
    return 0;
80105049:	31 c0                	xor    %eax,%eax
}
8010504b:	5e                   	pop    %esi
8010504c:	5d                   	pop    %ebp
8010504d:	c3                   	ret    
8010504e:	66 90                	xchg   %ax,%ax

80105050 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105050:	f3 0f 1e fb          	endbr32 
80105054:	55                   	push   %ebp
80105055:	89 e5                	mov    %esp,%ebp
80105057:	57                   	push   %edi
80105058:	56                   	push   %esi
80105059:	8b 75 08             	mov    0x8(%ebp),%esi
8010505c:	53                   	push   %ebx
8010505d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105060:	89 f2                	mov    %esi,%edx
80105062:	eb 1b                	jmp    8010507f <strncpy+0x2f>
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105068:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010506c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010506f:	83 c2 01             	add    $0x1,%edx
80105072:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105076:	89 f9                	mov    %edi,%ecx
80105078:	88 4a ff             	mov    %cl,-0x1(%edx)
8010507b:	84 c9                	test   %cl,%cl
8010507d:	74 09                	je     80105088 <strncpy+0x38>
8010507f:	89 c3                	mov    %eax,%ebx
80105081:	83 e8 01             	sub    $0x1,%eax
80105084:	85 db                	test   %ebx,%ebx
80105086:	7f e0                	jg     80105068 <strncpy+0x18>
    ;
  while(n-- > 0)
80105088:	89 d1                	mov    %edx,%ecx
8010508a:	85 c0                	test   %eax,%eax
8010508c:	7e 15                	jle    801050a3 <strncpy+0x53>
8010508e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105090:	83 c1 01             	add    $0x1,%ecx
80105093:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105097:	89 c8                	mov    %ecx,%eax
80105099:	f7 d0                	not    %eax
8010509b:	01 d0                	add    %edx,%eax
8010509d:	01 d8                	add    %ebx,%eax
8010509f:	85 c0                	test   %eax,%eax
801050a1:	7f ed                	jg     80105090 <strncpy+0x40>
  return os;
}
801050a3:	5b                   	pop    %ebx
801050a4:	89 f0                	mov    %esi,%eax
801050a6:	5e                   	pop    %esi
801050a7:	5f                   	pop    %edi
801050a8:	5d                   	pop    %ebp
801050a9:	c3                   	ret    
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050b0:	f3 0f 1e fb          	endbr32 
801050b4:	55                   	push   %ebp
801050b5:	89 e5                	mov    %esp,%ebp
801050b7:	56                   	push   %esi
801050b8:	8b 55 10             	mov    0x10(%ebp),%edx
801050bb:	8b 75 08             	mov    0x8(%ebp),%esi
801050be:	53                   	push   %ebx
801050bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801050c2:	85 d2                	test   %edx,%edx
801050c4:	7e 21                	jle    801050e7 <safestrcpy+0x37>
801050c6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801050ca:	89 f2                	mov    %esi,%edx
801050cc:	eb 12                	jmp    801050e0 <safestrcpy+0x30>
801050ce:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801050d0:	0f b6 08             	movzbl (%eax),%ecx
801050d3:	83 c0 01             	add    $0x1,%eax
801050d6:	83 c2 01             	add    $0x1,%edx
801050d9:	88 4a ff             	mov    %cl,-0x1(%edx)
801050dc:	84 c9                	test   %cl,%cl
801050de:	74 04                	je     801050e4 <safestrcpy+0x34>
801050e0:	39 d8                	cmp    %ebx,%eax
801050e2:	75 ec                	jne    801050d0 <safestrcpy+0x20>
    ;
  *s = 0;
801050e4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801050e7:	89 f0                	mov    %esi,%eax
801050e9:	5b                   	pop    %ebx
801050ea:	5e                   	pop    %esi
801050eb:	5d                   	pop    %ebp
801050ec:	c3                   	ret    
801050ed:	8d 76 00             	lea    0x0(%esi),%esi

801050f0 <strlen>:

int
strlen(const char *s)
{
801050f0:	f3 0f 1e fb          	endbr32 
801050f4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801050f5:	31 c0                	xor    %eax,%eax
{
801050f7:	89 e5                	mov    %esp,%ebp
801050f9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801050fc:	80 3a 00             	cmpb   $0x0,(%edx)
801050ff:	74 10                	je     80105111 <strlen+0x21>
80105101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105108:	83 c0 01             	add    $0x1,%eax
8010510b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010510f:	75 f7                	jne    80105108 <strlen+0x18>
    ;
  return n;
}
80105111:	5d                   	pop    %ebp
80105112:	c3                   	ret    

80105113 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105113:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105117:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010511b:	55                   	push   %ebp
  pushl %ebx
8010511c:	53                   	push   %ebx
  pushl %esi
8010511d:	56                   	push   %esi
  pushl %edi
8010511e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010511f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105121:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105123:	5f                   	pop    %edi
  popl %esi
80105124:	5e                   	pop    %esi
  popl %ebx
80105125:	5b                   	pop    %ebx
  popl %ebp
80105126:	5d                   	pop    %ebp
  ret
80105127:	c3                   	ret    
80105128:	66 90                	xchg   %ax,%ax
8010512a:	66 90                	xchg   %ax,%ax
8010512c:	66 90                	xchg   %ax,%ax
8010512e:	66 90                	xchg   %ax,%ax

80105130 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105130:	f3 0f 1e fb          	endbr32 
80105134:	55                   	push   %ebp
80105135:	89 e5                	mov    %esp,%ebp
80105137:	53                   	push   %ebx
80105138:	83 ec 04             	sub    $0x4,%esp
8010513b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010513e:	e8 9d f0 ff ff       	call   801041e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105143:	8b 00                	mov    (%eax),%eax
80105145:	39 d8                	cmp    %ebx,%eax
80105147:	76 17                	jbe    80105160 <fetchint+0x30>
80105149:	8d 53 04             	lea    0x4(%ebx),%edx
8010514c:	39 d0                	cmp    %edx,%eax
8010514e:	72 10                	jb     80105160 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105150:	8b 45 0c             	mov    0xc(%ebp),%eax
80105153:	8b 13                	mov    (%ebx),%edx
80105155:	89 10                	mov    %edx,(%eax)
  return 0;
80105157:	31 c0                	xor    %eax,%eax
}
80105159:	83 c4 04             	add    $0x4,%esp
8010515c:	5b                   	pop    %ebx
8010515d:	5d                   	pop    %ebp
8010515e:	c3                   	ret    
8010515f:	90                   	nop
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	eb f2                	jmp    80105159 <fetchint+0x29>
80105167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516e:	66 90                	xchg   %ax,%ax

80105170 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105170:	f3 0f 1e fb          	endbr32 
80105174:	55                   	push   %ebp
80105175:	89 e5                	mov    %esp,%ebp
80105177:	53                   	push   %ebx
80105178:	83 ec 04             	sub    $0x4,%esp
8010517b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010517e:	e8 5d f0 ff ff       	call   801041e0 <myproc>

  if(addr >= curproc->sz)
80105183:	39 18                	cmp    %ebx,(%eax)
80105185:	76 31                	jbe    801051b8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105187:	8b 55 0c             	mov    0xc(%ebp),%edx
8010518a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010518c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010518e:	39 d3                	cmp    %edx,%ebx
80105190:	73 26                	jae    801051b8 <fetchstr+0x48>
80105192:	89 d8                	mov    %ebx,%eax
80105194:	eb 11                	jmp    801051a7 <fetchstr+0x37>
80105196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
801051a0:	83 c0 01             	add    $0x1,%eax
801051a3:	39 c2                	cmp    %eax,%edx
801051a5:	76 11                	jbe    801051b8 <fetchstr+0x48>
    if(*s == 0)
801051a7:	80 38 00             	cmpb   $0x0,(%eax)
801051aa:	75 f4                	jne    801051a0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801051ac:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801051af:	29 d8                	sub    %ebx,%eax
}
801051b1:	5b                   	pop    %ebx
801051b2:	5d                   	pop    %ebp
801051b3:	c3                   	ret    
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051b8:	83 c4 04             	add    $0x4,%esp
    return -1;
801051bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c0:	5b                   	pop    %ebx
801051c1:	5d                   	pop    %ebp
801051c2:	c3                   	ret    
801051c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801051d0:	f3 0f 1e fb          	endbr32 
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	56                   	push   %esi
801051d8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051d9:	e8 02 f0 ff ff       	call   801041e0 <myproc>
801051de:	8b 55 08             	mov    0x8(%ebp),%edx
801051e1:	8b 40 18             	mov    0x18(%eax),%eax
801051e4:	8b 40 44             	mov    0x44(%eax),%eax
801051e7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051ea:	e8 f1 ef ff ff       	call   801041e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051ef:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051f2:	8b 00                	mov    (%eax),%eax
801051f4:	39 c6                	cmp    %eax,%esi
801051f6:	73 18                	jae    80105210 <argint+0x40>
801051f8:	8d 53 08             	lea    0x8(%ebx),%edx
801051fb:	39 d0                	cmp    %edx,%eax
801051fd:	72 11                	jb     80105210 <argint+0x40>
  *ip = *(int*)(addr);
801051ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105202:	8b 53 04             	mov    0x4(%ebx),%edx
80105205:	89 10                	mov    %edx,(%eax)
  return 0;
80105207:	31 c0                	xor    %eax,%eax
}
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5d                   	pop    %ebp
8010520c:	c3                   	ret    
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105215:	eb f2                	jmp    80105209 <argint+0x39>
80105217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521e:	66 90                	xchg   %ax,%ax

80105220 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
80105225:	89 e5                	mov    %esp,%ebp
80105227:	56                   	push   %esi
80105228:	53                   	push   %ebx
80105229:	83 ec 10             	sub    $0x10,%esp
8010522c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010522f:	e8 ac ef ff ff       	call   801041e0 <myproc>
 
  if(argint(n, &i) < 0)
80105234:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105237:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105239:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010523c:	50                   	push   %eax
8010523d:	ff 75 08             	pushl  0x8(%ebp)
80105240:	e8 8b ff ff ff       	call   801051d0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	85 c0                	test   %eax,%eax
8010524a:	78 24                	js     80105270 <argptr+0x50>
8010524c:	85 db                	test   %ebx,%ebx
8010524e:	78 20                	js     80105270 <argptr+0x50>
80105250:	8b 16                	mov    (%esi),%edx
80105252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105255:	39 c2                	cmp    %eax,%edx
80105257:	76 17                	jbe    80105270 <argptr+0x50>
80105259:	01 c3                	add    %eax,%ebx
8010525b:	39 da                	cmp    %ebx,%edx
8010525d:	72 11                	jb     80105270 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010525f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105262:	89 02                	mov    %eax,(%edx)
  return 0;
80105264:	31 c0                	xor    %eax,%eax
}
80105266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105269:	5b                   	pop    %ebx
8010526a:	5e                   	pop    %esi
8010526b:	5d                   	pop    %ebp
8010526c:	c3                   	ret    
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105275:	eb ef                	jmp    80105266 <argptr+0x46>
80105277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527e:	66 90                	xchg   %ax,%ax

80105280 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010528a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010528d:	50                   	push   %eax
8010528e:	ff 75 08             	pushl  0x8(%ebp)
80105291:	e8 3a ff ff ff       	call   801051d0 <argint>
80105296:	83 c4 10             	add    $0x10,%esp
80105299:	85 c0                	test   %eax,%eax
8010529b:	78 13                	js     801052b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010529d:	83 ec 08             	sub    $0x8,%esp
801052a0:	ff 75 0c             	pushl  0xc(%ebp)
801052a3:	ff 75 f4             	pushl  -0xc(%ebp)
801052a6:	e8 c5 fe ff ff       	call   80105170 <fetchstr>
801052ab:	83 c4 10             	add    $0x10,%esp
}
801052ae:	c9                   	leave  
801052af:	c3                   	ret    
801052b0:	c9                   	leave  
    return -1;
801052b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052b6:	c3                   	ret    
801052b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052be:	66 90                	xchg   %ax,%ax

801052c0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	53                   	push   %ebx
801052c8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801052cb:	e8 10 ef ff ff       	call   801041e0 <myproc>
801052d0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801052d2:	8b 40 18             	mov    0x18(%eax),%eax
801052d5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801052db:	83 fa 14             	cmp    $0x14,%edx
801052de:	77 20                	ja     80105300 <syscall+0x40>
801052e0:	8b 14 85 20 80 10 80 	mov    -0x7fef7fe0(,%eax,4),%edx
801052e7:	85 d2                	test   %edx,%edx
801052e9:	74 15                	je     80105300 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801052eb:	ff d2                	call   *%edx
801052ed:	89 c2                	mov    %eax,%edx
801052ef:	8b 43 18             	mov    0x18(%ebx),%eax
801052f2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801052f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052f8:	c9                   	leave  
801052f9:	c3                   	ret    
801052fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105300:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105301:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105304:	50                   	push   %eax
80105305:	ff 73 10             	pushl  0x10(%ebx)
80105308:	68 fd 7f 10 80       	push   $0x80107ffd
8010530d:	e8 3e b6 ff ff       	call   80100950 <cprintf>
    curproc->tf->eax = -1;
80105312:	8b 43 18             	mov    0x18(%ebx),%eax
80105315:	83 c4 10             	add    $0x10,%esp
80105318:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010531f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105322:	c9                   	leave  
80105323:	c3                   	ret    
80105324:	66 90                	xchg   %ax,%ax
80105326:	66 90                	xchg   %ax,%ax
80105328:	66 90                	xchg   %ax,%ax
8010532a:	66 90                	xchg   %ax,%ax
8010532c:	66 90                	xchg   %ax,%ax
8010532e:	66 90                	xchg   %ax,%ax

80105330 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105335:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105338:	53                   	push   %ebx
80105339:	83 ec 34             	sub    $0x34,%esp
8010533c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010533f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105342:	57                   	push   %edi
80105343:	50                   	push   %eax
{
80105344:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105347:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010534a:	e8 81 d5 ff ff       	call   801028d0 <nameiparent>
8010534f:	83 c4 10             	add    $0x10,%esp
80105352:	85 c0                	test   %eax,%eax
80105354:	0f 84 46 01 00 00    	je     801054a0 <create+0x170>
    return 0;
  ilock(dp);
8010535a:	83 ec 0c             	sub    $0xc,%esp
8010535d:	89 c3                	mov    %eax,%ebx
8010535f:	50                   	push   %eax
80105360:	e8 7b cc ff ff       	call   80101fe0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105365:	83 c4 0c             	add    $0xc,%esp
80105368:	6a 00                	push   $0x0
8010536a:	57                   	push   %edi
8010536b:	53                   	push   %ebx
8010536c:	e8 bf d1 ff ff       	call   80102530 <dirlookup>
80105371:	83 c4 10             	add    $0x10,%esp
80105374:	89 c6                	mov    %eax,%esi
80105376:	85 c0                	test   %eax,%eax
80105378:	74 56                	je     801053d0 <create+0xa0>
    iunlockput(dp);
8010537a:	83 ec 0c             	sub    $0xc,%esp
8010537d:	53                   	push   %ebx
8010537e:	e8 fd ce ff ff       	call   80102280 <iunlockput>
    ilock(ip);
80105383:	89 34 24             	mov    %esi,(%esp)
80105386:	e8 55 cc ff ff       	call   80101fe0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010538b:	83 c4 10             	add    $0x10,%esp
8010538e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105393:	75 1b                	jne    801053b0 <create+0x80>
80105395:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010539a:	75 14                	jne    801053b0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010539c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010539f:	89 f0                	mov    %esi,%eax
801053a1:	5b                   	pop    %ebx
801053a2:	5e                   	pop    %esi
801053a3:	5f                   	pop    %edi
801053a4:	5d                   	pop    %ebp
801053a5:	c3                   	ret    
801053a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	56                   	push   %esi
    return 0;
801053b4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801053b6:	e8 c5 ce ff ff       	call   80102280 <iunlockput>
    return 0;
801053bb:	83 c4 10             	add    $0x10,%esp
}
801053be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c1:	89 f0                	mov    %esi,%eax
801053c3:	5b                   	pop    %ebx
801053c4:	5e                   	pop    %esi
801053c5:	5f                   	pop    %edi
801053c6:	5d                   	pop    %ebp
801053c7:	c3                   	ret    
801053c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801053d0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801053d4:	83 ec 08             	sub    $0x8,%esp
801053d7:	50                   	push   %eax
801053d8:	ff 33                	pushl  (%ebx)
801053da:	e8 81 ca ff ff       	call   80101e60 <ialloc>
801053df:	83 c4 10             	add    $0x10,%esp
801053e2:	89 c6                	mov    %eax,%esi
801053e4:	85 c0                	test   %eax,%eax
801053e6:	0f 84 cd 00 00 00    	je     801054b9 <create+0x189>
  ilock(ip);
801053ec:	83 ec 0c             	sub    $0xc,%esp
801053ef:	50                   	push   %eax
801053f0:	e8 eb cb ff ff       	call   80101fe0 <ilock>
  ip->major = major;
801053f5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801053f9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801053fd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105401:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105405:	b8 01 00 00 00       	mov    $0x1,%eax
8010540a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010540e:	89 34 24             	mov    %esi,(%esp)
80105411:	e8 0a cb ff ff       	call   80101f20 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105416:	83 c4 10             	add    $0x10,%esp
80105419:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010541e:	74 30                	je     80105450 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105420:	83 ec 04             	sub    $0x4,%esp
80105423:	ff 76 04             	pushl  0x4(%esi)
80105426:	57                   	push   %edi
80105427:	53                   	push   %ebx
80105428:	e8 c3 d3 ff ff       	call   801027f0 <dirlink>
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	85 c0                	test   %eax,%eax
80105432:	78 78                	js     801054ac <create+0x17c>
  iunlockput(dp);
80105434:	83 ec 0c             	sub    $0xc,%esp
80105437:	53                   	push   %ebx
80105438:	e8 43 ce ff ff       	call   80102280 <iunlockput>
  return ip;
8010543d:	83 c4 10             	add    $0x10,%esp
}
80105440:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105443:	89 f0                	mov    %esi,%eax
80105445:	5b                   	pop    %ebx
80105446:	5e                   	pop    %esi
80105447:	5f                   	pop    %edi
80105448:	5d                   	pop    %ebp
80105449:	c3                   	ret    
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105450:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105453:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105458:	53                   	push   %ebx
80105459:	e8 c2 ca ff ff       	call   80101f20 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010545e:	83 c4 0c             	add    $0xc,%esp
80105461:	ff 76 04             	pushl  0x4(%esi)
80105464:	68 94 80 10 80       	push   $0x80108094
80105469:	56                   	push   %esi
8010546a:	e8 81 d3 ff ff       	call   801027f0 <dirlink>
8010546f:	83 c4 10             	add    $0x10,%esp
80105472:	85 c0                	test   %eax,%eax
80105474:	78 18                	js     8010548e <create+0x15e>
80105476:	83 ec 04             	sub    $0x4,%esp
80105479:	ff 73 04             	pushl  0x4(%ebx)
8010547c:	68 93 80 10 80       	push   $0x80108093
80105481:	56                   	push   %esi
80105482:	e8 69 d3 ff ff       	call   801027f0 <dirlink>
80105487:	83 c4 10             	add    $0x10,%esp
8010548a:	85 c0                	test   %eax,%eax
8010548c:	79 92                	jns    80105420 <create+0xf0>
      panic("create dots");
8010548e:	83 ec 0c             	sub    $0xc,%esp
80105491:	68 87 80 10 80       	push   $0x80108087
80105496:	e8 f5 ae ff ff       	call   80100390 <panic>
8010549b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010549f:	90                   	nop
}
801054a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801054a3:	31 f6                	xor    %esi,%esi
}
801054a5:	5b                   	pop    %ebx
801054a6:	89 f0                	mov    %esi,%eax
801054a8:	5e                   	pop    %esi
801054a9:	5f                   	pop    %edi
801054aa:	5d                   	pop    %ebp
801054ab:	c3                   	ret    
    panic("create: dirlink");
801054ac:	83 ec 0c             	sub    $0xc,%esp
801054af:	68 96 80 10 80       	push   $0x80108096
801054b4:	e8 d7 ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801054b9:	83 ec 0c             	sub    $0xc,%esp
801054bc:	68 78 80 10 80       	push   $0x80108078
801054c1:	e8 ca ae ff ff       	call   80100390 <panic>
801054c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054cd:	8d 76 00             	lea    0x0(%esi),%esi

801054d0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	56                   	push   %esi
801054d4:	89 d6                	mov    %edx,%esi
801054d6:	53                   	push   %ebx
801054d7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801054d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801054dc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054df:	50                   	push   %eax
801054e0:	6a 00                	push   $0x0
801054e2:	e8 e9 fc ff ff       	call   801051d0 <argint>
801054e7:	83 c4 10             	add    $0x10,%esp
801054ea:	85 c0                	test   %eax,%eax
801054ec:	78 2a                	js     80105518 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054f2:	77 24                	ja     80105518 <argfd.constprop.0+0x48>
801054f4:	e8 e7 ec ff ff       	call   801041e0 <myproc>
801054f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054fc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105500:	85 c0                	test   %eax,%eax
80105502:	74 14                	je     80105518 <argfd.constprop.0+0x48>
  if(pfd)
80105504:	85 db                	test   %ebx,%ebx
80105506:	74 02                	je     8010550a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105508:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010550a:	89 06                	mov    %eax,(%esi)
  return 0;
8010550c:	31 c0                	xor    %eax,%eax
}
8010550e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105511:	5b                   	pop    %ebx
80105512:	5e                   	pop    %esi
80105513:	5d                   	pop    %ebp
80105514:	c3                   	ret    
80105515:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551d:	eb ef                	jmp    8010550e <argfd.constprop.0+0x3e>
8010551f:	90                   	nop

80105520 <sys_dup>:
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105525:	31 c0                	xor    %eax,%eax
{
80105527:	89 e5                	mov    %esp,%ebp
80105529:	56                   	push   %esi
8010552a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010552b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010552e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105531:	e8 9a ff ff ff       	call   801054d0 <argfd.constprop.0>
80105536:	85 c0                	test   %eax,%eax
80105538:	78 1e                	js     80105558 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010553a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010553d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010553f:	e8 9c ec ff ff       	call   801041e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105548:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010554c:	85 d2                	test   %edx,%edx
8010554e:	74 20                	je     80105570 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105550:	83 c3 01             	add    $0x1,%ebx
80105553:	83 fb 10             	cmp    $0x10,%ebx
80105556:	75 f0                	jne    80105548 <sys_dup+0x28>
}
80105558:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010555b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105560:	89 d8                	mov    %ebx,%eax
80105562:	5b                   	pop    %ebx
80105563:	5e                   	pop    %esi
80105564:	5d                   	pop    %ebp
80105565:	c3                   	ret    
80105566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105570:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105574:	83 ec 0c             	sub    $0xc,%esp
80105577:	ff 75 f4             	pushl  -0xc(%ebp)
8010557a:	e8 71 c1 ff ff       	call   801016f0 <filedup>
  return fd;
8010557f:	83 c4 10             	add    $0x10,%esp
}
80105582:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105585:	89 d8                	mov    %ebx,%eax
80105587:	5b                   	pop    %ebx
80105588:	5e                   	pop    %esi
80105589:	5d                   	pop    %ebp
8010558a:	c3                   	ret    
8010558b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010558f:	90                   	nop

80105590 <sys_read>:
{
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105595:	31 c0                	xor    %eax,%eax
{
80105597:	89 e5                	mov    %esp,%ebp
80105599:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010559c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010559f:	e8 2c ff ff ff       	call   801054d0 <argfd.constprop.0>
801055a4:	85 c0                	test   %eax,%eax
801055a6:	78 48                	js     801055f0 <sys_read+0x60>
801055a8:	83 ec 08             	sub    $0x8,%esp
801055ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055ae:	50                   	push   %eax
801055af:	6a 02                	push   $0x2
801055b1:	e8 1a fc ff ff       	call   801051d0 <argint>
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	85 c0                	test   %eax,%eax
801055bb:	78 33                	js     801055f0 <sys_read+0x60>
801055bd:	83 ec 04             	sub    $0x4,%esp
801055c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c3:	ff 75 f0             	pushl  -0x10(%ebp)
801055c6:	50                   	push   %eax
801055c7:	6a 01                	push   $0x1
801055c9:	e8 52 fc ff ff       	call   80105220 <argptr>
801055ce:	83 c4 10             	add    $0x10,%esp
801055d1:	85 c0                	test   %eax,%eax
801055d3:	78 1b                	js     801055f0 <sys_read+0x60>
  return fileread(f, p, n);
801055d5:	83 ec 04             	sub    $0x4,%esp
801055d8:	ff 75 f0             	pushl  -0x10(%ebp)
801055db:	ff 75 f4             	pushl  -0xc(%ebp)
801055de:	ff 75 ec             	pushl  -0x14(%ebp)
801055e1:	e8 8a c2 ff ff       	call   80101870 <fileread>
801055e6:	83 c4 10             	add    $0x10,%esp
}
801055e9:	c9                   	leave  
801055ea:	c3                   	ret    
801055eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop
801055f0:	c9                   	leave  
    return -1;
801055f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f6:	c3                   	ret    
801055f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fe:	66 90                	xchg   %ax,%ax

80105600 <sys_write>:
{
80105600:	f3 0f 1e fb          	endbr32 
80105604:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105605:	31 c0                	xor    %eax,%eax
{
80105607:	89 e5                	mov    %esp,%ebp
80105609:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010560c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010560f:	e8 bc fe ff ff       	call   801054d0 <argfd.constprop.0>
80105614:	85 c0                	test   %eax,%eax
80105616:	78 48                	js     80105660 <sys_write+0x60>
80105618:	83 ec 08             	sub    $0x8,%esp
8010561b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010561e:	50                   	push   %eax
8010561f:	6a 02                	push   $0x2
80105621:	e8 aa fb ff ff       	call   801051d0 <argint>
80105626:	83 c4 10             	add    $0x10,%esp
80105629:	85 c0                	test   %eax,%eax
8010562b:	78 33                	js     80105660 <sys_write+0x60>
8010562d:	83 ec 04             	sub    $0x4,%esp
80105630:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105633:	ff 75 f0             	pushl  -0x10(%ebp)
80105636:	50                   	push   %eax
80105637:	6a 01                	push   $0x1
80105639:	e8 e2 fb ff ff       	call   80105220 <argptr>
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	85 c0                	test   %eax,%eax
80105643:	78 1b                	js     80105660 <sys_write+0x60>
  return filewrite(f, p, n);
80105645:	83 ec 04             	sub    $0x4,%esp
80105648:	ff 75 f0             	pushl  -0x10(%ebp)
8010564b:	ff 75 f4             	pushl  -0xc(%ebp)
8010564e:	ff 75 ec             	pushl  -0x14(%ebp)
80105651:	e8 ba c2 ff ff       	call   80101910 <filewrite>
80105656:	83 c4 10             	add    $0x10,%esp
}
80105659:	c9                   	leave  
8010565a:	c3                   	ret    
8010565b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010565f:	90                   	nop
80105660:	c9                   	leave  
    return -1;
80105661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105666:	c3                   	ret    
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_close>:
{
80105670:	f3 0f 1e fb          	endbr32 
80105674:	55                   	push   %ebp
80105675:	89 e5                	mov    %esp,%ebp
80105677:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010567a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010567d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105680:	e8 4b fe ff ff       	call   801054d0 <argfd.constprop.0>
80105685:	85 c0                	test   %eax,%eax
80105687:	78 27                	js     801056b0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105689:	e8 52 eb ff ff       	call   801041e0 <myproc>
8010568e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105691:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105694:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010569b:	00 
  fileclose(f);
8010569c:	ff 75 f4             	pushl  -0xc(%ebp)
8010569f:	e8 9c c0 ff ff       	call   80101740 <fileclose>
  return 0;
801056a4:	83 c4 10             	add    $0x10,%esp
801056a7:	31 c0                	xor    %eax,%eax
}
801056a9:	c9                   	leave  
801056aa:	c3                   	ret    
801056ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056af:	90                   	nop
801056b0:	c9                   	leave  
    return -1;
801056b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b6:	c3                   	ret    
801056b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056be:	66 90                	xchg   %ax,%ax

801056c0 <sys_fstat>:
{
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056c5:	31 c0                	xor    %eax,%eax
{
801056c7:	89 e5                	mov    %esp,%ebp
801056c9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056cc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801056cf:	e8 fc fd ff ff       	call   801054d0 <argfd.constprop.0>
801056d4:	85 c0                	test   %eax,%eax
801056d6:	78 30                	js     80105708 <sys_fstat+0x48>
801056d8:	83 ec 04             	sub    $0x4,%esp
801056db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056de:	6a 14                	push   $0x14
801056e0:	50                   	push   %eax
801056e1:	6a 01                	push   $0x1
801056e3:	e8 38 fb ff ff       	call   80105220 <argptr>
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	85 c0                	test   %eax,%eax
801056ed:	78 19                	js     80105708 <sys_fstat+0x48>
  return filestat(f, st);
801056ef:	83 ec 08             	sub    $0x8,%esp
801056f2:	ff 75 f4             	pushl  -0xc(%ebp)
801056f5:	ff 75 f0             	pushl  -0x10(%ebp)
801056f8:	e8 23 c1 ff ff       	call   80101820 <filestat>
801056fd:	83 c4 10             	add    $0x10,%esp
}
80105700:	c9                   	leave  
80105701:	c3                   	ret    
80105702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105708:	c9                   	leave  
    return -1;
80105709:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010570e:	c3                   	ret    
8010570f:	90                   	nop

80105710 <sys_link>:
{
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
80105715:	89 e5                	mov    %esp,%ebp
80105717:	57                   	push   %edi
80105718:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105719:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010571c:	53                   	push   %ebx
8010571d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105720:	50                   	push   %eax
80105721:	6a 00                	push   $0x0
80105723:	e8 58 fb ff ff       	call   80105280 <argstr>
80105728:	83 c4 10             	add    $0x10,%esp
8010572b:	85 c0                	test   %eax,%eax
8010572d:	0f 88 ff 00 00 00    	js     80105832 <sys_link+0x122>
80105733:	83 ec 08             	sub    $0x8,%esp
80105736:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105739:	50                   	push   %eax
8010573a:	6a 01                	push   $0x1
8010573c:	e8 3f fb ff ff       	call   80105280 <argstr>
80105741:	83 c4 10             	add    $0x10,%esp
80105744:	85 c0                	test   %eax,%eax
80105746:	0f 88 e6 00 00 00    	js     80105832 <sys_link+0x122>
  begin_op();
8010574c:	e8 5f de ff ff       	call   801035b0 <begin_op>
  if((ip = namei(old)) == 0){
80105751:	83 ec 0c             	sub    $0xc,%esp
80105754:	ff 75 d4             	pushl  -0x2c(%ebp)
80105757:	e8 54 d1 ff ff       	call   801028b0 <namei>
8010575c:	83 c4 10             	add    $0x10,%esp
8010575f:	89 c3                	mov    %eax,%ebx
80105761:	85 c0                	test   %eax,%eax
80105763:	0f 84 e8 00 00 00    	je     80105851 <sys_link+0x141>
  ilock(ip);
80105769:	83 ec 0c             	sub    $0xc,%esp
8010576c:	50                   	push   %eax
8010576d:	e8 6e c8 ff ff       	call   80101fe0 <ilock>
  if(ip->type == T_DIR){
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010577a:	0f 84 b9 00 00 00    	je     80105839 <sys_link+0x129>
  iupdate(ip);
80105780:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105783:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105788:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010578b:	53                   	push   %ebx
8010578c:	e8 8f c7 ff ff       	call   80101f20 <iupdate>
  iunlock(ip);
80105791:	89 1c 24             	mov    %ebx,(%esp)
80105794:	e8 27 c9 ff ff       	call   801020c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105799:	58                   	pop    %eax
8010579a:	5a                   	pop    %edx
8010579b:	57                   	push   %edi
8010579c:	ff 75 d0             	pushl  -0x30(%ebp)
8010579f:	e8 2c d1 ff ff       	call   801028d0 <nameiparent>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	89 c6                	mov    %eax,%esi
801057a9:	85 c0                	test   %eax,%eax
801057ab:	74 5f                	je     8010580c <sys_link+0xfc>
  ilock(dp);
801057ad:	83 ec 0c             	sub    $0xc,%esp
801057b0:	50                   	push   %eax
801057b1:	e8 2a c8 ff ff       	call   80101fe0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057b6:	8b 03                	mov    (%ebx),%eax
801057b8:	83 c4 10             	add    $0x10,%esp
801057bb:	39 06                	cmp    %eax,(%esi)
801057bd:	75 41                	jne    80105800 <sys_link+0xf0>
801057bf:	83 ec 04             	sub    $0x4,%esp
801057c2:	ff 73 04             	pushl  0x4(%ebx)
801057c5:	57                   	push   %edi
801057c6:	56                   	push   %esi
801057c7:	e8 24 d0 ff ff       	call   801027f0 <dirlink>
801057cc:	83 c4 10             	add    $0x10,%esp
801057cf:	85 c0                	test   %eax,%eax
801057d1:	78 2d                	js     80105800 <sys_link+0xf0>
  iunlockput(dp);
801057d3:	83 ec 0c             	sub    $0xc,%esp
801057d6:	56                   	push   %esi
801057d7:	e8 a4 ca ff ff       	call   80102280 <iunlockput>
  iput(ip);
801057dc:	89 1c 24             	mov    %ebx,(%esp)
801057df:	e8 2c c9 ff ff       	call   80102110 <iput>
  end_op();
801057e4:	e8 37 de ff ff       	call   80103620 <end_op>
  return 0;
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	31 c0                	xor    %eax,%eax
}
801057ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f1:	5b                   	pop    %ebx
801057f2:	5e                   	pop    %esi
801057f3:	5f                   	pop    %edi
801057f4:	5d                   	pop    %ebp
801057f5:	c3                   	ret    
801057f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105800:	83 ec 0c             	sub    $0xc,%esp
80105803:	56                   	push   %esi
80105804:	e8 77 ca ff ff       	call   80102280 <iunlockput>
    goto bad;
80105809:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010580c:	83 ec 0c             	sub    $0xc,%esp
8010580f:	53                   	push   %ebx
80105810:	e8 cb c7 ff ff       	call   80101fe0 <ilock>
  ip->nlink--;
80105815:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010581a:	89 1c 24             	mov    %ebx,(%esp)
8010581d:	e8 fe c6 ff ff       	call   80101f20 <iupdate>
  iunlockput(ip);
80105822:	89 1c 24             	mov    %ebx,(%esp)
80105825:	e8 56 ca ff ff       	call   80102280 <iunlockput>
  end_op();
8010582a:	e8 f1 dd ff ff       	call   80103620 <end_op>
  return -1;
8010582f:	83 c4 10             	add    $0x10,%esp
80105832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105837:	eb b5                	jmp    801057ee <sys_link+0xde>
    iunlockput(ip);
80105839:	83 ec 0c             	sub    $0xc,%esp
8010583c:	53                   	push   %ebx
8010583d:	e8 3e ca ff ff       	call   80102280 <iunlockput>
    end_op();
80105842:	e8 d9 dd ff ff       	call   80103620 <end_op>
    return -1;
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584f:	eb 9d                	jmp    801057ee <sys_link+0xde>
    end_op();
80105851:	e8 ca dd ff ff       	call   80103620 <end_op>
    return -1;
80105856:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585b:	eb 91                	jmp    801057ee <sys_link+0xde>
8010585d:	8d 76 00             	lea    0x0(%esi),%esi

80105860 <sys_unlink>:
{
80105860:	f3 0f 1e fb          	endbr32 
80105864:	55                   	push   %ebp
80105865:	89 e5                	mov    %esp,%ebp
80105867:	57                   	push   %edi
80105868:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105869:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010586c:	53                   	push   %ebx
8010586d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105870:	50                   	push   %eax
80105871:	6a 00                	push   $0x0
80105873:	e8 08 fa ff ff       	call   80105280 <argstr>
80105878:	83 c4 10             	add    $0x10,%esp
8010587b:	85 c0                	test   %eax,%eax
8010587d:	0f 88 7d 01 00 00    	js     80105a00 <sys_unlink+0x1a0>
  begin_op();
80105883:	e8 28 dd ff ff       	call   801035b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105888:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010588b:	83 ec 08             	sub    $0x8,%esp
8010588e:	53                   	push   %ebx
8010588f:	ff 75 c0             	pushl  -0x40(%ebp)
80105892:	e8 39 d0 ff ff       	call   801028d0 <nameiparent>
80105897:	83 c4 10             	add    $0x10,%esp
8010589a:	89 c6                	mov    %eax,%esi
8010589c:	85 c0                	test   %eax,%eax
8010589e:	0f 84 66 01 00 00    	je     80105a0a <sys_unlink+0x1aa>
  ilock(dp);
801058a4:	83 ec 0c             	sub    $0xc,%esp
801058a7:	50                   	push   %eax
801058a8:	e8 33 c7 ff ff       	call   80101fe0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058ad:	58                   	pop    %eax
801058ae:	5a                   	pop    %edx
801058af:	68 94 80 10 80       	push   $0x80108094
801058b4:	53                   	push   %ebx
801058b5:	e8 56 cc ff ff       	call   80102510 <namecmp>
801058ba:	83 c4 10             	add    $0x10,%esp
801058bd:	85 c0                	test   %eax,%eax
801058bf:	0f 84 03 01 00 00    	je     801059c8 <sys_unlink+0x168>
801058c5:	83 ec 08             	sub    $0x8,%esp
801058c8:	68 93 80 10 80       	push   $0x80108093
801058cd:	53                   	push   %ebx
801058ce:	e8 3d cc ff ff       	call   80102510 <namecmp>
801058d3:	83 c4 10             	add    $0x10,%esp
801058d6:	85 c0                	test   %eax,%eax
801058d8:	0f 84 ea 00 00 00    	je     801059c8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801058de:	83 ec 04             	sub    $0x4,%esp
801058e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058e4:	50                   	push   %eax
801058e5:	53                   	push   %ebx
801058e6:	56                   	push   %esi
801058e7:	e8 44 cc ff ff       	call   80102530 <dirlookup>
801058ec:	83 c4 10             	add    $0x10,%esp
801058ef:	89 c3                	mov    %eax,%ebx
801058f1:	85 c0                	test   %eax,%eax
801058f3:	0f 84 cf 00 00 00    	je     801059c8 <sys_unlink+0x168>
  ilock(ip);
801058f9:	83 ec 0c             	sub    $0xc,%esp
801058fc:	50                   	push   %eax
801058fd:	e8 de c6 ff ff       	call   80101fe0 <ilock>
  if(ip->nlink < 1)
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010590a:	0f 8e 23 01 00 00    	jle    80105a33 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105910:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105915:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105918:	74 66                	je     80105980 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010591a:	83 ec 04             	sub    $0x4,%esp
8010591d:	6a 10                	push   $0x10
8010591f:	6a 00                	push   $0x0
80105921:	57                   	push   %edi
80105922:	e8 c9 f5 ff ff       	call   80104ef0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105927:	6a 10                	push   $0x10
80105929:	ff 75 c4             	pushl  -0x3c(%ebp)
8010592c:	57                   	push   %edi
8010592d:	56                   	push   %esi
8010592e:	e8 ad ca ff ff       	call   801023e0 <writei>
80105933:	83 c4 20             	add    $0x20,%esp
80105936:	83 f8 10             	cmp    $0x10,%eax
80105939:	0f 85 e7 00 00 00    	jne    80105a26 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010593f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105944:	0f 84 96 00 00 00    	je     801059e0 <sys_unlink+0x180>
  iunlockput(dp);
8010594a:	83 ec 0c             	sub    $0xc,%esp
8010594d:	56                   	push   %esi
8010594e:	e8 2d c9 ff ff       	call   80102280 <iunlockput>
  ip->nlink--;
80105953:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105958:	89 1c 24             	mov    %ebx,(%esp)
8010595b:	e8 c0 c5 ff ff       	call   80101f20 <iupdate>
  iunlockput(ip);
80105960:	89 1c 24             	mov    %ebx,(%esp)
80105963:	e8 18 c9 ff ff       	call   80102280 <iunlockput>
  end_op();
80105968:	e8 b3 dc ff ff       	call   80103620 <end_op>
  return 0;
8010596d:	83 c4 10             	add    $0x10,%esp
80105970:	31 c0                	xor    %eax,%eax
}
80105972:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105975:	5b                   	pop    %ebx
80105976:	5e                   	pop    %esi
80105977:	5f                   	pop    %edi
80105978:	5d                   	pop    %ebp
80105979:	c3                   	ret    
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105980:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105984:	76 94                	jbe    8010591a <sys_unlink+0xba>
80105986:	ba 20 00 00 00       	mov    $0x20,%edx
8010598b:	eb 0b                	jmp    80105998 <sys_unlink+0x138>
8010598d:	8d 76 00             	lea    0x0(%esi),%esi
80105990:	83 c2 10             	add    $0x10,%edx
80105993:	39 53 58             	cmp    %edx,0x58(%ebx)
80105996:	76 82                	jbe    8010591a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105998:	6a 10                	push   $0x10
8010599a:	52                   	push   %edx
8010599b:	57                   	push   %edi
8010599c:	53                   	push   %ebx
8010599d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801059a0:	e8 3b c9 ff ff       	call   801022e0 <readi>
801059a5:	83 c4 10             	add    $0x10,%esp
801059a8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801059ab:	83 f8 10             	cmp    $0x10,%eax
801059ae:	75 69                	jne    80105a19 <sys_unlink+0x1b9>
    if(de.inum != 0)
801059b0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801059b5:	74 d9                	je     80105990 <sys_unlink+0x130>
    iunlockput(ip);
801059b7:	83 ec 0c             	sub    $0xc,%esp
801059ba:	53                   	push   %ebx
801059bb:	e8 c0 c8 ff ff       	call   80102280 <iunlockput>
    goto bad;
801059c0:	83 c4 10             	add    $0x10,%esp
801059c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059c7:	90                   	nop
  iunlockput(dp);
801059c8:	83 ec 0c             	sub    $0xc,%esp
801059cb:	56                   	push   %esi
801059cc:	e8 af c8 ff ff       	call   80102280 <iunlockput>
  end_op();
801059d1:	e8 4a dc ff ff       	call   80103620 <end_op>
  return -1;
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059de:	eb 92                	jmp    80105972 <sys_unlink+0x112>
    iupdate(dp);
801059e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059e3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801059e8:	56                   	push   %esi
801059e9:	e8 32 c5 ff ff       	call   80101f20 <iupdate>
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	e9 54 ff ff ff       	jmp    8010594a <sys_unlink+0xea>
801059f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a05:	e9 68 ff ff ff       	jmp    80105972 <sys_unlink+0x112>
    end_op();
80105a0a:	e8 11 dc ff ff       	call   80103620 <end_op>
    return -1;
80105a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a14:	e9 59 ff ff ff       	jmp    80105972 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105a19:	83 ec 0c             	sub    $0xc,%esp
80105a1c:	68 b8 80 10 80       	push   $0x801080b8
80105a21:	e8 6a a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a26:	83 ec 0c             	sub    $0xc,%esp
80105a29:	68 ca 80 10 80       	push   $0x801080ca
80105a2e:	e8 5d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a33:	83 ec 0c             	sub    $0xc,%esp
80105a36:	68 a6 80 10 80       	push   $0x801080a6
80105a3b:	e8 50 a9 ff ff       	call   80100390 <panic>

80105a40 <sys_open>:

int
sys_open(void)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	57                   	push   %edi
80105a48:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a49:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a4c:	53                   	push   %ebx
80105a4d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a50:	50                   	push   %eax
80105a51:	6a 00                	push   $0x0
80105a53:	e8 28 f8 ff ff       	call   80105280 <argstr>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	0f 88 8a 00 00 00    	js     80105aed <sys_open+0xad>
80105a63:	83 ec 08             	sub    $0x8,%esp
80105a66:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a69:	50                   	push   %eax
80105a6a:	6a 01                	push   $0x1
80105a6c:	e8 5f f7 ff ff       	call   801051d0 <argint>
80105a71:	83 c4 10             	add    $0x10,%esp
80105a74:	85 c0                	test   %eax,%eax
80105a76:	78 75                	js     80105aed <sys_open+0xad>
    return -1;

  begin_op();
80105a78:	e8 33 db ff ff       	call   801035b0 <begin_op>

  if(omode & O_CREATE){
80105a7d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a81:	75 75                	jne    80105af8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a83:	83 ec 0c             	sub    $0xc,%esp
80105a86:	ff 75 e0             	pushl  -0x20(%ebp)
80105a89:	e8 22 ce ff ff       	call   801028b0 <namei>
80105a8e:	83 c4 10             	add    $0x10,%esp
80105a91:	89 c6                	mov    %eax,%esi
80105a93:	85 c0                	test   %eax,%eax
80105a95:	74 7e                	je     80105b15 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a97:	83 ec 0c             	sub    $0xc,%esp
80105a9a:	50                   	push   %eax
80105a9b:	e8 40 c5 ff ff       	call   80101fe0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105aa0:	83 c4 10             	add    $0x10,%esp
80105aa3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105aa8:	0f 84 c2 00 00 00    	je     80105b70 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105aae:	e8 cd bb ff ff       	call   80101680 <filealloc>
80105ab3:	89 c7                	mov    %eax,%edi
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	74 23                	je     80105adc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105ab9:	e8 22 e7 ff ff       	call   801041e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105abe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105ac0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ac4:	85 d2                	test   %edx,%edx
80105ac6:	74 60                	je     80105b28 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105ac8:	83 c3 01             	add    $0x1,%ebx
80105acb:	83 fb 10             	cmp    $0x10,%ebx
80105ace:	75 f0                	jne    80105ac0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	57                   	push   %edi
80105ad4:	e8 67 bc ff ff       	call   80101740 <fileclose>
80105ad9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105adc:	83 ec 0c             	sub    $0xc,%esp
80105adf:	56                   	push   %esi
80105ae0:	e8 9b c7 ff ff       	call   80102280 <iunlockput>
    end_op();
80105ae5:	e8 36 db ff ff       	call   80103620 <end_op>
    return -1;
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105af2:	eb 6d                	jmp    80105b61 <sys_open+0x121>
80105af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105af8:	83 ec 0c             	sub    $0xc,%esp
80105afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105afe:	31 c9                	xor    %ecx,%ecx
80105b00:	ba 02 00 00 00       	mov    $0x2,%edx
80105b05:	6a 00                	push   $0x0
80105b07:	e8 24 f8 ff ff       	call   80105330 <create>
    if(ip == 0){
80105b0c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b0f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b11:	85 c0                	test   %eax,%eax
80105b13:	75 99                	jne    80105aae <sys_open+0x6e>
      end_op();
80105b15:	e8 06 db ff ff       	call   80103620 <end_op>
      return -1;
80105b1a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b1f:	eb 40                	jmp    80105b61 <sys_open+0x121>
80105b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b28:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b2b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b2f:	56                   	push   %esi
80105b30:	e8 8b c5 ff ff       	call   801020c0 <iunlock>
  end_op();
80105b35:	e8 e6 da ff ff       	call   80103620 <end_op>

  f->type = FD_INODE;
80105b3a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b43:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b46:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b49:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b4b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b52:	f7 d0                	not    %eax
80105b54:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b57:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b5a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b5d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b64:	89 d8                	mov    %ebx,%eax
80105b66:	5b                   	pop    %ebx
80105b67:	5e                   	pop    %esi
80105b68:	5f                   	pop    %edi
80105b69:	5d                   	pop    %ebp
80105b6a:	c3                   	ret    
80105b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b70:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b73:	85 c9                	test   %ecx,%ecx
80105b75:	0f 84 33 ff ff ff    	je     80105aae <sys_open+0x6e>
80105b7b:	e9 5c ff ff ff       	jmp    80105adc <sys_open+0x9c>

80105b80 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b80:	f3 0f 1e fb          	endbr32 
80105b84:	55                   	push   %ebp
80105b85:	89 e5                	mov    %esp,%ebp
80105b87:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b8a:	e8 21 da ff ff       	call   801035b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b8f:	83 ec 08             	sub    $0x8,%esp
80105b92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b95:	50                   	push   %eax
80105b96:	6a 00                	push   $0x0
80105b98:	e8 e3 f6 ff ff       	call   80105280 <argstr>
80105b9d:	83 c4 10             	add    $0x10,%esp
80105ba0:	85 c0                	test   %eax,%eax
80105ba2:	78 34                	js     80105bd8 <sys_mkdir+0x58>
80105ba4:	83 ec 0c             	sub    $0xc,%esp
80105ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105baa:	31 c9                	xor    %ecx,%ecx
80105bac:	ba 01 00 00 00       	mov    $0x1,%edx
80105bb1:	6a 00                	push   $0x0
80105bb3:	e8 78 f7 ff ff       	call   80105330 <create>
80105bb8:	83 c4 10             	add    $0x10,%esp
80105bbb:	85 c0                	test   %eax,%eax
80105bbd:	74 19                	je     80105bd8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bbf:	83 ec 0c             	sub    $0xc,%esp
80105bc2:	50                   	push   %eax
80105bc3:	e8 b8 c6 ff ff       	call   80102280 <iunlockput>
  end_op();
80105bc8:	e8 53 da ff ff       	call   80103620 <end_op>
  return 0;
80105bcd:	83 c4 10             	add    $0x10,%esp
80105bd0:	31 c0                	xor    %eax,%eax
}
80105bd2:	c9                   	leave  
80105bd3:	c3                   	ret    
80105bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105bd8:	e8 43 da ff ff       	call   80103620 <end_op>
    return -1;
80105bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be2:	c9                   	leave  
80105be3:	c3                   	ret    
80105be4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop

80105bf0 <sys_mknod>:

int
sys_mknod(void)
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bfa:	e8 b1 d9 ff ff       	call   801035b0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105bff:	83 ec 08             	sub    $0x8,%esp
80105c02:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c05:	50                   	push   %eax
80105c06:	6a 00                	push   $0x0
80105c08:	e8 73 f6 ff ff       	call   80105280 <argstr>
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	85 c0                	test   %eax,%eax
80105c12:	78 64                	js     80105c78 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105c14:	83 ec 08             	sub    $0x8,%esp
80105c17:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c1a:	50                   	push   %eax
80105c1b:	6a 01                	push   $0x1
80105c1d:	e8 ae f5 ff ff       	call   801051d0 <argint>
  if((argstr(0, &path)) < 0 ||
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 4f                	js     80105c78 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105c29:	83 ec 08             	sub    $0x8,%esp
80105c2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c2f:	50                   	push   %eax
80105c30:	6a 02                	push   $0x2
80105c32:	e8 99 f5 ff ff       	call   801051d0 <argint>
     argint(1, &major) < 0 ||
80105c37:	83 c4 10             	add    $0x10,%esp
80105c3a:	85 c0                	test   %eax,%eax
80105c3c:	78 3a                	js     80105c78 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c3e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c42:	83 ec 0c             	sub    $0xc,%esp
80105c45:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c49:	ba 03 00 00 00       	mov    $0x3,%edx
80105c4e:	50                   	push   %eax
80105c4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c52:	e8 d9 f6 ff ff       	call   80105330 <create>
     argint(2, &minor) < 0 ||
80105c57:	83 c4 10             	add    $0x10,%esp
80105c5a:	85 c0                	test   %eax,%eax
80105c5c:	74 1a                	je     80105c78 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c5e:	83 ec 0c             	sub    $0xc,%esp
80105c61:	50                   	push   %eax
80105c62:	e8 19 c6 ff ff       	call   80102280 <iunlockput>
  end_op();
80105c67:	e8 b4 d9 ff ff       	call   80103620 <end_op>
  return 0;
80105c6c:	83 c4 10             	add    $0x10,%esp
80105c6f:	31 c0                	xor    %eax,%eax
}
80105c71:	c9                   	leave  
80105c72:	c3                   	ret    
80105c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c77:	90                   	nop
    end_op();
80105c78:	e8 a3 d9 ff ff       	call   80103620 <end_op>
    return -1;
80105c7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c82:	c9                   	leave  
80105c83:	c3                   	ret    
80105c84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c8f:	90                   	nop

80105c90 <sys_chdir>:

int
sys_chdir(void)
{
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
80105c95:	89 e5                	mov    %esp,%ebp
80105c97:	56                   	push   %esi
80105c98:	53                   	push   %ebx
80105c99:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c9c:	e8 3f e5 ff ff       	call   801041e0 <myproc>
80105ca1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105ca3:	e8 08 d9 ff ff       	call   801035b0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ca8:	83 ec 08             	sub    $0x8,%esp
80105cab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cae:	50                   	push   %eax
80105caf:	6a 00                	push   $0x0
80105cb1:	e8 ca f5 ff ff       	call   80105280 <argstr>
80105cb6:	83 c4 10             	add    $0x10,%esp
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	78 73                	js     80105d30 <sys_chdir+0xa0>
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	ff 75 f4             	pushl  -0xc(%ebp)
80105cc3:	e8 e8 cb ff ff       	call   801028b0 <namei>
80105cc8:	83 c4 10             	add    $0x10,%esp
80105ccb:	89 c3                	mov    %eax,%ebx
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	74 5f                	je     80105d30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105cd1:	83 ec 0c             	sub    $0xc,%esp
80105cd4:	50                   	push   %eax
80105cd5:	e8 06 c3 ff ff       	call   80101fe0 <ilock>
  if(ip->type != T_DIR){
80105cda:	83 c4 10             	add    $0x10,%esp
80105cdd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ce2:	75 2c                	jne    80105d10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ce4:	83 ec 0c             	sub    $0xc,%esp
80105ce7:	53                   	push   %ebx
80105ce8:	e8 d3 c3 ff ff       	call   801020c0 <iunlock>
  iput(curproc->cwd);
80105ced:	58                   	pop    %eax
80105cee:	ff 76 68             	pushl  0x68(%esi)
80105cf1:	e8 1a c4 ff ff       	call   80102110 <iput>
  end_op();
80105cf6:	e8 25 d9 ff ff       	call   80103620 <end_op>
  curproc->cwd = ip;
80105cfb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cfe:	83 c4 10             	add    $0x10,%esp
80105d01:	31 c0                	xor    %eax,%eax
}
80105d03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d06:	5b                   	pop    %ebx
80105d07:	5e                   	pop    %esi
80105d08:	5d                   	pop    %ebp
80105d09:	c3                   	ret    
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	53                   	push   %ebx
80105d14:	e8 67 c5 ff ff       	call   80102280 <iunlockput>
    end_op();
80105d19:	e8 02 d9 ff ff       	call   80103620 <end_op>
    return -1;
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d26:	eb db                	jmp    80105d03 <sys_chdir+0x73>
80105d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2f:	90                   	nop
    end_op();
80105d30:	e8 eb d8 ff ff       	call   80103620 <end_op>
    return -1;
80105d35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3a:	eb c7                	jmp    80105d03 <sys_chdir+0x73>
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_exec>:

int
sys_exec(void)
{
80105d40:	f3 0f 1e fb          	endbr32 
80105d44:	55                   	push   %ebp
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	57                   	push   %edi
80105d48:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d49:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d4f:	53                   	push   %ebx
80105d50:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d56:	50                   	push   %eax
80105d57:	6a 00                	push   $0x0
80105d59:	e8 22 f5 ff ff       	call   80105280 <argstr>
80105d5e:	83 c4 10             	add    $0x10,%esp
80105d61:	85 c0                	test   %eax,%eax
80105d63:	0f 88 8b 00 00 00    	js     80105df4 <sys_exec+0xb4>
80105d69:	83 ec 08             	sub    $0x8,%esp
80105d6c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d72:	50                   	push   %eax
80105d73:	6a 01                	push   $0x1
80105d75:	e8 56 f4 ff ff       	call   801051d0 <argint>
80105d7a:	83 c4 10             	add    $0x10,%esp
80105d7d:	85 c0                	test   %eax,%eax
80105d7f:	78 73                	js     80105df4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d81:	83 ec 04             	sub    $0x4,%esp
80105d84:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105d8a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d8c:	68 80 00 00 00       	push   $0x80
80105d91:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d97:	6a 00                	push   $0x0
80105d99:	50                   	push   %eax
80105d9a:	e8 51 f1 ff ff       	call   80104ef0 <memset>
80105d9f:	83 c4 10             	add    $0x10,%esp
80105da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105da8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105dae:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105db5:	83 ec 08             	sub    $0x8,%esp
80105db8:	57                   	push   %edi
80105db9:	01 f0                	add    %esi,%eax
80105dbb:	50                   	push   %eax
80105dbc:	e8 6f f3 ff ff       	call   80105130 <fetchint>
80105dc1:	83 c4 10             	add    $0x10,%esp
80105dc4:	85 c0                	test   %eax,%eax
80105dc6:	78 2c                	js     80105df4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105dc8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	74 36                	je     80105e08 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105dd2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105dd8:	83 ec 08             	sub    $0x8,%esp
80105ddb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105dde:	52                   	push   %edx
80105ddf:	50                   	push   %eax
80105de0:	e8 8b f3 ff ff       	call   80105170 <fetchstr>
80105de5:	83 c4 10             	add    $0x10,%esp
80105de8:	85 c0                	test   %eax,%eax
80105dea:	78 08                	js     80105df4 <sys_exec+0xb4>
  for(i=0;; i++){
80105dec:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105def:	83 fb 20             	cmp    $0x20,%ebx
80105df2:	75 b4                	jne    80105da8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105df7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dfc:	5b                   	pop    %ebx
80105dfd:	5e                   	pop    %esi
80105dfe:	5f                   	pop    %edi
80105dff:	5d                   	pop    %ebp
80105e00:	c3                   	ret    
80105e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e08:	83 ec 08             	sub    $0x8,%esp
80105e0b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105e11:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e18:	00 00 00 00 
  return exec(path, argv);
80105e1c:	50                   	push   %eax
80105e1d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e23:	e8 d8 b4 ff ff       	call   80101300 <exec>
80105e28:	83 c4 10             	add    $0x10,%esp
}
80105e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e2e:	5b                   	pop    %ebx
80105e2f:	5e                   	pop    %esi
80105e30:	5f                   	pop    %edi
80105e31:	5d                   	pop    %ebp
80105e32:	c3                   	ret    
80105e33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e40 <sys_pipe>:

int
sys_pipe(void)
{
80105e40:	f3 0f 1e fb          	endbr32 
80105e44:	55                   	push   %ebp
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	57                   	push   %edi
80105e48:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e49:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e4c:	53                   	push   %ebx
80105e4d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e50:	6a 08                	push   $0x8
80105e52:	50                   	push   %eax
80105e53:	6a 00                	push   $0x0
80105e55:	e8 c6 f3 ff ff       	call   80105220 <argptr>
80105e5a:	83 c4 10             	add    $0x10,%esp
80105e5d:	85 c0                	test   %eax,%eax
80105e5f:	78 4e                	js     80105eaf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e61:	83 ec 08             	sub    $0x8,%esp
80105e64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e67:	50                   	push   %eax
80105e68:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e6b:	50                   	push   %eax
80105e6c:	e8 ff dd ff ff       	call   80103c70 <pipealloc>
80105e71:	83 c4 10             	add    $0x10,%esp
80105e74:	85 c0                	test   %eax,%eax
80105e76:	78 37                	js     80105eaf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e78:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e7b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e7d:	e8 5e e3 ff ff       	call   801041e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105e88:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e8c:	85 f6                	test   %esi,%esi
80105e8e:	74 30                	je     80105ec0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105e90:	83 c3 01             	add    $0x1,%ebx
80105e93:	83 fb 10             	cmp    $0x10,%ebx
80105e96:	75 f0                	jne    80105e88 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e98:	83 ec 0c             	sub    $0xc,%esp
80105e9b:	ff 75 e0             	pushl  -0x20(%ebp)
80105e9e:	e8 9d b8 ff ff       	call   80101740 <fileclose>
    fileclose(wf);
80105ea3:	58                   	pop    %eax
80105ea4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ea7:	e8 94 b8 ff ff       	call   80101740 <fileclose>
    return -1;
80105eac:	83 c4 10             	add    $0x10,%esp
80105eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb4:	eb 5b                	jmp    80105f11 <sys_pipe+0xd1>
80105eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ebd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105ec0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ec3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ec7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105eca:	e8 11 e3 ff ff       	call   801041e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ecf:	31 d2                	xor    %edx,%edx
80105ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ed8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105edc:	85 c9                	test   %ecx,%ecx
80105ede:	74 20                	je     80105f00 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105ee0:	83 c2 01             	add    $0x1,%edx
80105ee3:	83 fa 10             	cmp    $0x10,%edx
80105ee6:	75 f0                	jne    80105ed8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105ee8:	e8 f3 e2 ff ff       	call   801041e0 <myproc>
80105eed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ef4:	00 
80105ef5:	eb a1                	jmp    80105e98 <sys_pipe+0x58>
80105ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f00:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f04:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f07:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f0c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f0f:	31 c0                	xor    %eax,%eax
}
80105f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f14:	5b                   	pop    %ebx
80105f15:	5e                   	pop    %esi
80105f16:	5f                   	pop    %edi
80105f17:	5d                   	pop    %ebp
80105f18:	c3                   	ret    
80105f19:	66 90                	xchg   %ax,%ax
80105f1b:	66 90                	xchg   %ax,%ax
80105f1d:	66 90                	xchg   %ax,%ax
80105f1f:	90                   	nop

80105f20 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f20:	f3 0f 1e fb          	endbr32 
  return fork();
80105f24:	e9 67 e4 ff ff       	jmp    80104390 <fork>
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f30 <sys_exit>:
}

int
sys_exit(void)
{
80105f30:	f3 0f 1e fb          	endbr32 
80105f34:	55                   	push   %ebp
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f3a:	e8 d1 e6 ff ff       	call   80104610 <exit>
  return 0;  // not reached
}
80105f3f:	31 c0                	xor    %eax,%eax
80105f41:	c9                   	leave  
80105f42:	c3                   	ret    
80105f43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f50 <sys_wait>:

int
sys_wait(void)
{
80105f50:	f3 0f 1e fb          	endbr32 
  return wait();
80105f54:	e9 07 e9 ff ff       	jmp    80104860 <wait>
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_kill>:
}

int
sys_kill(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f6d:	50                   	push   %eax
80105f6e:	6a 00                	push   $0x0
80105f70:	e8 5b f2 ff ff       	call   801051d0 <argint>
80105f75:	83 c4 10             	add    $0x10,%esp
80105f78:	85 c0                	test   %eax,%eax
80105f7a:	78 14                	js     80105f90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f7c:	83 ec 0c             	sub    $0xc,%esp
80105f7f:	ff 75 f4             	pushl  -0xc(%ebp)
80105f82:	e8 39 ea ff ff       	call   801049c0 <kill>
80105f87:	83 c4 10             	add    $0x10,%esp
}
80105f8a:	c9                   	leave  
80105f8b:	c3                   	ret    
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f90:	c9                   	leave  
    return -1;
80105f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f96:	c3                   	ret    
80105f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_getpid>:

int
sys_getpid(void)
{
80105fa0:	f3 0f 1e fb          	endbr32 
80105fa4:	55                   	push   %ebp
80105fa5:	89 e5                	mov    %esp,%ebp
80105fa7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105faa:	e8 31 e2 ff ff       	call   801041e0 <myproc>
80105faf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fb2:	c9                   	leave  
80105fb3:	c3                   	ret    
80105fb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop

80105fc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105fc0:	f3 0f 1e fb          	endbr32 
80105fc4:	55                   	push   %ebp
80105fc5:	89 e5                	mov    %esp,%ebp
80105fc7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105fc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fcb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fce:	50                   	push   %eax
80105fcf:	6a 00                	push   $0x0
80105fd1:	e8 fa f1 ff ff       	call   801051d0 <argint>
80105fd6:	83 c4 10             	add    $0x10,%esp
80105fd9:	85 c0                	test   %eax,%eax
80105fdb:	78 23                	js     80106000 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105fdd:	e8 fe e1 ff ff       	call   801041e0 <myproc>
  if(growproc(n) < 0)
80105fe2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105fe5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105fe7:	ff 75 f4             	pushl  -0xc(%ebp)
80105fea:	e8 21 e3 ff ff       	call   80104310 <growproc>
80105fef:	83 c4 10             	add    $0x10,%esp
80105ff2:	85 c0                	test   %eax,%eax
80105ff4:	78 0a                	js     80106000 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ff6:	89 d8                	mov    %ebx,%eax
80105ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ffb:	c9                   	leave  
80105ffc:	c3                   	ret    
80105ffd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106000:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106005:	eb ef                	jmp    80105ff6 <sys_sbrk+0x36>
80106007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600e:	66 90                	xchg   %ax,%ax

80106010 <sys_sleep>:

int
sys_sleep(void)
{
80106010:	f3 0f 1e fb          	endbr32 
80106014:	55                   	push   %ebp
80106015:	89 e5                	mov    %esp,%ebp
80106017:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106018:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010601b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010601e:	50                   	push   %eax
8010601f:	6a 00                	push   $0x0
80106021:	e8 aa f1 ff ff       	call   801051d0 <argint>
80106026:	83 c4 10             	add    $0x10,%esp
80106029:	85 c0                	test   %eax,%eax
8010602b:	0f 88 86 00 00 00    	js     801060b7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106031:	83 ec 0c             	sub    $0xc,%esp
80106034:	68 80 61 11 80       	push   $0x80116180
80106039:	e8 a2 ed ff ff       	call   80104de0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010603e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106041:	8b 1d c0 69 11 80    	mov    0x801169c0,%ebx
  while(ticks - ticks0 < n){
80106047:	83 c4 10             	add    $0x10,%esp
8010604a:	85 d2                	test   %edx,%edx
8010604c:	75 23                	jne    80106071 <sys_sleep+0x61>
8010604e:	eb 50                	jmp    801060a0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106050:	83 ec 08             	sub    $0x8,%esp
80106053:	68 80 61 11 80       	push   $0x80116180
80106058:	68 c0 69 11 80       	push   $0x801169c0
8010605d:	e8 3e e7 ff ff       	call   801047a0 <sleep>
  while(ticks - ticks0 < n){
80106062:	a1 c0 69 11 80       	mov    0x801169c0,%eax
80106067:	83 c4 10             	add    $0x10,%esp
8010606a:	29 d8                	sub    %ebx,%eax
8010606c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010606f:	73 2f                	jae    801060a0 <sys_sleep+0x90>
    if(myproc()->killed){
80106071:	e8 6a e1 ff ff       	call   801041e0 <myproc>
80106076:	8b 40 24             	mov    0x24(%eax),%eax
80106079:	85 c0                	test   %eax,%eax
8010607b:	74 d3                	je     80106050 <sys_sleep+0x40>
      release(&tickslock);
8010607d:	83 ec 0c             	sub    $0xc,%esp
80106080:	68 80 61 11 80       	push   $0x80116180
80106085:	e8 16 ee ff ff       	call   80104ea0 <release>
  }
  release(&tickslock);
  return 0;
}
8010608a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010608d:	83 c4 10             	add    $0x10,%esp
80106090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106095:	c9                   	leave  
80106096:	c3                   	ret    
80106097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010609e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	68 80 61 11 80       	push   $0x80116180
801060a8:	e8 f3 ed ff ff       	call   80104ea0 <release>
  return 0;
801060ad:	83 c4 10             	add    $0x10,%esp
801060b0:	31 c0                	xor    %eax,%eax
}
801060b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060b5:	c9                   	leave  
801060b6:	c3                   	ret    
    return -1;
801060b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060bc:	eb f4                	jmp    801060b2 <sys_sleep+0xa2>
801060be:	66 90                	xchg   %ax,%ax

801060c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060c0:	f3 0f 1e fb          	endbr32 
801060c4:	55                   	push   %ebp
801060c5:	89 e5                	mov    %esp,%ebp
801060c7:	53                   	push   %ebx
801060c8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060cb:	68 80 61 11 80       	push   $0x80116180
801060d0:	e8 0b ed ff ff       	call   80104de0 <acquire>
  xticks = ticks;
801060d5:	8b 1d c0 69 11 80    	mov    0x801169c0,%ebx
  release(&tickslock);
801060db:	c7 04 24 80 61 11 80 	movl   $0x80116180,(%esp)
801060e2:	e8 b9 ed ff ff       	call   80104ea0 <release>
  return xticks;
}
801060e7:	89 d8                	mov    %ebx,%eax
801060e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060ec:	c9                   	leave  
801060ed:	c3                   	ret    

801060ee <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801060ee:	1e                   	push   %ds
  pushl %es
801060ef:	06                   	push   %es
  pushl %fs
801060f0:	0f a0                	push   %fs
  pushl %gs
801060f2:	0f a8                	push   %gs
  pushal
801060f4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801060f5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801060f9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801060fb:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801060fd:	54                   	push   %esp
  call trap
801060fe:	e8 cd 00 00 00       	call   801061d0 <trap>
  addl $4, %esp
80106103:	83 c4 04             	add    $0x4,%esp

80106106 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106106:	61                   	popa   
  popl %gs
80106107:	0f a9                	pop    %gs
  popl %fs
80106109:	0f a1                	pop    %fs
  popl %es
8010610b:	07                   	pop    %es
  popl %ds
8010610c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010610d:	83 c4 08             	add    $0x8,%esp
  iret
80106110:	cf                   	iret   
80106111:	66 90                	xchg   %ax,%ax
80106113:	66 90                	xchg   %ax,%ax
80106115:	66 90                	xchg   %ax,%ax
80106117:	66 90                	xchg   %ax,%ax
80106119:	66 90                	xchg   %ax,%ax
8010611b:	66 90                	xchg   %ax,%ax
8010611d:	66 90                	xchg   %ax,%ax
8010611f:	90                   	nop

80106120 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106120:	f3 0f 1e fb          	endbr32 
80106124:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106125:	31 c0                	xor    %eax,%eax
{
80106127:	89 e5                	mov    %esp,%ebp
80106129:	83 ec 08             	sub    $0x8,%esp
8010612c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106130:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106137:	c7 04 c5 c2 61 11 80 	movl   $0x8e000008,-0x7fee9e3e(,%eax,8)
8010613e:	08 00 00 8e 
80106142:	66 89 14 c5 c0 61 11 	mov    %dx,-0x7fee9e40(,%eax,8)
80106149:	80 
8010614a:	c1 ea 10             	shr    $0x10,%edx
8010614d:	66 89 14 c5 c6 61 11 	mov    %dx,-0x7fee9e3a(,%eax,8)
80106154:	80 
  for(i = 0; i < 256; i++)
80106155:	83 c0 01             	add    $0x1,%eax
80106158:	3d 00 01 00 00       	cmp    $0x100,%eax
8010615d:	75 d1                	jne    80106130 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010615f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106162:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106167:	c7 05 c2 63 11 80 08 	movl   $0xef000008,0x801163c2
8010616e:	00 00 ef 
  initlock(&tickslock, "time");
80106171:	68 d9 80 10 80       	push   $0x801080d9
80106176:	68 80 61 11 80       	push   $0x80116180
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010617b:	66 a3 c0 63 11 80    	mov    %ax,0x801163c0
80106181:	c1 e8 10             	shr    $0x10,%eax
80106184:	66 a3 c6 63 11 80    	mov    %ax,0x801163c6
  initlock(&tickslock, "time");
8010618a:	e8 d1 ea ff ff       	call   80104c60 <initlock>
}
8010618f:	83 c4 10             	add    $0x10,%esp
80106192:	c9                   	leave  
80106193:	c3                   	ret    
80106194:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010619f:	90                   	nop

801061a0 <idtinit>:

void
idtinit(void)
{
801061a0:	f3 0f 1e fb          	endbr32 
801061a4:	55                   	push   %ebp
  pd[0] = size-1;
801061a5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061aa:	89 e5                	mov    %esp,%ebp
801061ac:	83 ec 10             	sub    $0x10,%esp
801061af:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061b3:	b8 c0 61 11 80       	mov    $0x801161c0,%eax
801061b8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061bc:	c1 e8 10             	shr    $0x10,%eax
801061bf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061c3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061c6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061c9:	c9                   	leave  
801061ca:	c3                   	ret    
801061cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061cf:	90                   	nop

801061d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061d0:	f3 0f 1e fb          	endbr32 
801061d4:	55                   	push   %ebp
801061d5:	89 e5                	mov    %esp,%ebp
801061d7:	57                   	push   %edi
801061d8:	56                   	push   %esi
801061d9:	53                   	push   %ebx
801061da:	83 ec 1c             	sub    $0x1c,%esp
801061dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801061e0:	8b 43 30             	mov    0x30(%ebx),%eax
801061e3:	83 f8 40             	cmp    $0x40,%eax
801061e6:	0f 84 bc 01 00 00    	je     801063a8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801061ec:	83 e8 20             	sub    $0x20,%eax
801061ef:	83 f8 1f             	cmp    $0x1f,%eax
801061f2:	77 08                	ja     801061fc <trap+0x2c>
801061f4:	3e ff 24 85 80 81 10 	notrack jmp *-0x7fef7e80(,%eax,4)
801061fb:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801061fc:	e8 df df ff ff       	call   801041e0 <myproc>
80106201:	8b 7b 38             	mov    0x38(%ebx),%edi
80106204:	85 c0                	test   %eax,%eax
80106206:	0f 84 eb 01 00 00    	je     801063f7 <trap+0x227>
8010620c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106210:	0f 84 e1 01 00 00    	je     801063f7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106216:	0f 20 d1             	mov    %cr2,%ecx
80106219:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010621c:	e8 9f df ff ff       	call   801041c0 <cpuid>
80106221:	8b 73 30             	mov    0x30(%ebx),%esi
80106224:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106227:	8b 43 34             	mov    0x34(%ebx),%eax
8010622a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010622d:	e8 ae df ff ff       	call   801041e0 <myproc>
80106232:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106235:	e8 a6 df ff ff       	call   801041e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010623a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010623d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106240:	51                   	push   %ecx
80106241:	57                   	push   %edi
80106242:	52                   	push   %edx
80106243:	ff 75 e4             	pushl  -0x1c(%ebp)
80106246:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106247:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010624a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010624d:	56                   	push   %esi
8010624e:	ff 70 10             	pushl  0x10(%eax)
80106251:	68 3c 81 10 80       	push   $0x8010813c
80106256:	e8 f5 a6 ff ff       	call   80100950 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010625b:	83 c4 20             	add    $0x20,%esp
8010625e:	e8 7d df ff ff       	call   801041e0 <myproc>
80106263:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010626a:	e8 71 df ff ff       	call   801041e0 <myproc>
8010626f:	85 c0                	test   %eax,%eax
80106271:	74 1d                	je     80106290 <trap+0xc0>
80106273:	e8 68 df ff ff       	call   801041e0 <myproc>
80106278:	8b 50 24             	mov    0x24(%eax),%edx
8010627b:	85 d2                	test   %edx,%edx
8010627d:	74 11                	je     80106290 <trap+0xc0>
8010627f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106283:	83 e0 03             	and    $0x3,%eax
80106286:	66 83 f8 03          	cmp    $0x3,%ax
8010628a:	0f 84 50 01 00 00    	je     801063e0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106290:	e8 4b df ff ff       	call   801041e0 <myproc>
80106295:	85 c0                	test   %eax,%eax
80106297:	74 0f                	je     801062a8 <trap+0xd8>
80106299:	e8 42 df ff ff       	call   801041e0 <myproc>
8010629e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062a2:	0f 84 e8 00 00 00    	je     80106390 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062a8:	e8 33 df ff ff       	call   801041e0 <myproc>
801062ad:	85 c0                	test   %eax,%eax
801062af:	74 1d                	je     801062ce <trap+0xfe>
801062b1:	e8 2a df ff ff       	call   801041e0 <myproc>
801062b6:	8b 40 24             	mov    0x24(%eax),%eax
801062b9:	85 c0                	test   %eax,%eax
801062bb:	74 11                	je     801062ce <trap+0xfe>
801062bd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062c1:	83 e0 03             	and    $0x3,%eax
801062c4:	66 83 f8 03          	cmp    $0x3,%ax
801062c8:	0f 84 03 01 00 00    	je     801063d1 <trap+0x201>
    exit();
}
801062ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062d1:	5b                   	pop    %ebx
801062d2:	5e                   	pop    %esi
801062d3:	5f                   	pop    %edi
801062d4:	5d                   	pop    %ebp
801062d5:	c3                   	ret    
    ideintr();
801062d6:	e8 85 c7 ff ff       	call   80102a60 <ideintr>
    lapiceoi();
801062db:	e8 60 ce ff ff       	call   80103140 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062e0:	e8 fb de ff ff       	call   801041e0 <myproc>
801062e5:	85 c0                	test   %eax,%eax
801062e7:	75 8a                	jne    80106273 <trap+0xa3>
801062e9:	eb a5                	jmp    80106290 <trap+0xc0>
    if(cpuid() == 0){
801062eb:	e8 d0 de ff ff       	call   801041c0 <cpuid>
801062f0:	85 c0                	test   %eax,%eax
801062f2:	75 e7                	jne    801062db <trap+0x10b>
      acquire(&tickslock);
801062f4:	83 ec 0c             	sub    $0xc,%esp
801062f7:	68 80 61 11 80       	push   $0x80116180
801062fc:	e8 df ea ff ff       	call   80104de0 <acquire>
      wakeup(&ticks);
80106301:	c7 04 24 c0 69 11 80 	movl   $0x801169c0,(%esp)
      ticks++;
80106308:	83 05 c0 69 11 80 01 	addl   $0x1,0x801169c0
      wakeup(&ticks);
8010630f:	e8 4c e6 ff ff       	call   80104960 <wakeup>
      release(&tickslock);
80106314:	c7 04 24 80 61 11 80 	movl   $0x80116180,(%esp)
8010631b:	e8 80 eb ff ff       	call   80104ea0 <release>
80106320:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106323:	eb b6                	jmp    801062db <trap+0x10b>
    kbdintr();
80106325:	e8 d6 cc ff ff       	call   80103000 <kbdintr>
    lapiceoi();
8010632a:	e8 11 ce ff ff       	call   80103140 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010632f:	e8 ac de ff ff       	call   801041e0 <myproc>
80106334:	85 c0                	test   %eax,%eax
80106336:	0f 85 37 ff ff ff    	jne    80106273 <trap+0xa3>
8010633c:	e9 4f ff ff ff       	jmp    80106290 <trap+0xc0>
    uartintr();
80106341:	e8 4a 02 00 00       	call   80106590 <uartintr>
    lapiceoi();
80106346:	e8 f5 cd ff ff       	call   80103140 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010634b:	e8 90 de ff ff       	call   801041e0 <myproc>
80106350:	85 c0                	test   %eax,%eax
80106352:	0f 85 1b ff ff ff    	jne    80106273 <trap+0xa3>
80106358:	e9 33 ff ff ff       	jmp    80106290 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010635d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106360:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106364:	e8 57 de ff ff       	call   801041c0 <cpuid>
80106369:	57                   	push   %edi
8010636a:	56                   	push   %esi
8010636b:	50                   	push   %eax
8010636c:	68 e4 80 10 80       	push   $0x801080e4
80106371:	e8 da a5 ff ff       	call   80100950 <cprintf>
    lapiceoi();
80106376:	e8 c5 cd ff ff       	call   80103140 <lapiceoi>
    break;
8010637b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010637e:	e8 5d de ff ff       	call   801041e0 <myproc>
80106383:	85 c0                	test   %eax,%eax
80106385:	0f 85 e8 fe ff ff    	jne    80106273 <trap+0xa3>
8010638b:	e9 00 ff ff ff       	jmp    80106290 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106390:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106394:	0f 85 0e ff ff ff    	jne    801062a8 <trap+0xd8>
    yield();
8010639a:	e8 b1 e3 ff ff       	call   80104750 <yield>
8010639f:	e9 04 ff ff ff       	jmp    801062a8 <trap+0xd8>
801063a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801063a8:	e8 33 de ff ff       	call   801041e0 <myproc>
801063ad:	8b 70 24             	mov    0x24(%eax),%esi
801063b0:	85 f6                	test   %esi,%esi
801063b2:	75 3c                	jne    801063f0 <trap+0x220>
    myproc()->tf = tf;
801063b4:	e8 27 de ff ff       	call   801041e0 <myproc>
801063b9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801063bc:	e8 ff ee ff ff       	call   801052c0 <syscall>
    if(myproc()->killed)
801063c1:	e8 1a de ff ff       	call   801041e0 <myproc>
801063c6:	8b 48 24             	mov    0x24(%eax),%ecx
801063c9:	85 c9                	test   %ecx,%ecx
801063cb:	0f 84 fd fe ff ff    	je     801062ce <trap+0xfe>
}
801063d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063d4:	5b                   	pop    %ebx
801063d5:	5e                   	pop    %esi
801063d6:	5f                   	pop    %edi
801063d7:	5d                   	pop    %ebp
      exit();
801063d8:	e9 33 e2 ff ff       	jmp    80104610 <exit>
801063dd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801063e0:	e8 2b e2 ff ff       	call   80104610 <exit>
801063e5:	e9 a6 fe ff ff       	jmp    80106290 <trap+0xc0>
801063ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801063f0:	e8 1b e2 ff ff       	call   80104610 <exit>
801063f5:	eb bd                	jmp    801063b4 <trap+0x1e4>
801063f7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063fa:	e8 c1 dd ff ff       	call   801041c0 <cpuid>
801063ff:	83 ec 0c             	sub    $0xc,%esp
80106402:	56                   	push   %esi
80106403:	57                   	push   %edi
80106404:	50                   	push   %eax
80106405:	ff 73 30             	pushl  0x30(%ebx)
80106408:	68 08 81 10 80       	push   $0x80108108
8010640d:	e8 3e a5 ff ff       	call   80100950 <cprintf>
      panic("trap");
80106412:	83 c4 14             	add    $0x14,%esp
80106415:	68 de 80 10 80       	push   $0x801080de
8010641a:	e8 71 9f ff ff       	call   80100390 <panic>
8010641f:	90                   	nop

80106420 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106420:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106424:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106429:	85 c0                	test   %eax,%eax
8010642b:	74 1b                	je     80106448 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010642d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106432:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106433:	a8 01                	test   $0x1,%al
80106435:	74 11                	je     80106448 <uartgetc+0x28>
80106437:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010643c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010643d:	0f b6 c0             	movzbl %al,%eax
80106440:	c3                   	ret    
80106441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010644d:	c3                   	ret    
8010644e:	66 90                	xchg   %ax,%ax

80106450 <uartputc.part.0>:
uartputc(int c)
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	57                   	push   %edi
80106454:	89 c7                	mov    %eax,%edi
80106456:	56                   	push   %esi
80106457:	be fd 03 00 00       	mov    $0x3fd,%esi
8010645c:	53                   	push   %ebx
8010645d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106462:	83 ec 0c             	sub    $0xc,%esp
80106465:	eb 1b                	jmp    80106482 <uartputc.part.0+0x32>
80106467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010646e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106470:	83 ec 0c             	sub    $0xc,%esp
80106473:	6a 0a                	push   $0xa
80106475:	e8 e6 cc ff ff       	call   80103160 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010647a:	83 c4 10             	add    $0x10,%esp
8010647d:	83 eb 01             	sub    $0x1,%ebx
80106480:	74 07                	je     80106489 <uartputc.part.0+0x39>
80106482:	89 f2                	mov    %esi,%edx
80106484:	ec                   	in     (%dx),%al
80106485:	a8 20                	test   $0x20,%al
80106487:	74 e7                	je     80106470 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106489:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010648e:	89 f8                	mov    %edi,%eax
80106490:	ee                   	out    %al,(%dx)
}
80106491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106494:	5b                   	pop    %ebx
80106495:	5e                   	pop    %esi
80106496:	5f                   	pop    %edi
80106497:	5d                   	pop    %ebp
80106498:	c3                   	ret    
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064a0 <uartinit>:
{
801064a0:	f3 0f 1e fb          	endbr32 
801064a4:	55                   	push   %ebp
801064a5:	31 c9                	xor    %ecx,%ecx
801064a7:	89 c8                	mov    %ecx,%eax
801064a9:	89 e5                	mov    %esp,%ebp
801064ab:	57                   	push   %edi
801064ac:	56                   	push   %esi
801064ad:	53                   	push   %ebx
801064ae:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801064b3:	89 da                	mov    %ebx,%edx
801064b5:	83 ec 0c             	sub    $0xc,%esp
801064b8:	ee                   	out    %al,(%dx)
801064b9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801064be:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064c3:	89 fa                	mov    %edi,%edx
801064c5:	ee                   	out    %al,(%dx)
801064c6:	b8 0c 00 00 00       	mov    $0xc,%eax
801064cb:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064d0:	ee                   	out    %al,(%dx)
801064d1:	be f9 03 00 00       	mov    $0x3f9,%esi
801064d6:	89 c8                	mov    %ecx,%eax
801064d8:	89 f2                	mov    %esi,%edx
801064da:	ee                   	out    %al,(%dx)
801064db:	b8 03 00 00 00       	mov    $0x3,%eax
801064e0:	89 fa                	mov    %edi,%edx
801064e2:	ee                   	out    %al,(%dx)
801064e3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064e8:	89 c8                	mov    %ecx,%eax
801064ea:	ee                   	out    %al,(%dx)
801064eb:	b8 01 00 00 00       	mov    $0x1,%eax
801064f0:	89 f2                	mov    %esi,%edx
801064f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064f3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064f8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064f9:	3c ff                	cmp    $0xff,%al
801064fb:	74 52                	je     8010654f <uartinit+0xaf>
  uart = 1;
801064fd:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106504:	00 00 00 
80106507:	89 da                	mov    %ebx,%edx
80106509:	ec                   	in     (%dx),%al
8010650a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010650f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106510:	83 ec 08             	sub    $0x8,%esp
80106513:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106518:	bb 00 82 10 80       	mov    $0x80108200,%ebx
  ioapicenable(IRQ_COM1, 0);
8010651d:	6a 00                	push   $0x0
8010651f:	6a 04                	push   $0x4
80106521:	e8 8a c7 ff ff       	call   80102cb0 <ioapicenable>
80106526:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106529:	b8 78 00 00 00       	mov    $0x78,%eax
8010652e:	eb 04                	jmp    80106534 <uartinit+0x94>
80106530:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106534:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010653a:	85 d2                	test   %edx,%edx
8010653c:	74 08                	je     80106546 <uartinit+0xa6>
    uartputc(*p);
8010653e:	0f be c0             	movsbl %al,%eax
80106541:	e8 0a ff ff ff       	call   80106450 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106546:	89 f0                	mov    %esi,%eax
80106548:	83 c3 01             	add    $0x1,%ebx
8010654b:	84 c0                	test   %al,%al
8010654d:	75 e1                	jne    80106530 <uartinit+0x90>
}
8010654f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106552:	5b                   	pop    %ebx
80106553:	5e                   	pop    %esi
80106554:	5f                   	pop    %edi
80106555:	5d                   	pop    %ebp
80106556:	c3                   	ret    
80106557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010655e:	66 90                	xchg   %ax,%ax

80106560 <uartputc>:
{
80106560:	f3 0f 1e fb          	endbr32 
80106564:	55                   	push   %ebp
  if(!uart)
80106565:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010656b:	89 e5                	mov    %esp,%ebp
8010656d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106570:	85 d2                	test   %edx,%edx
80106572:	74 0c                	je     80106580 <uartputc+0x20>
}
80106574:	5d                   	pop    %ebp
80106575:	e9 d6 fe ff ff       	jmp    80106450 <uartputc.part.0>
8010657a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106580:	5d                   	pop    %ebp
80106581:	c3                   	ret    
80106582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106590 <uartintr>:

void
uartintr(void)
{
80106590:	f3 0f 1e fb          	endbr32 
80106594:	55                   	push   %ebp
80106595:	89 e5                	mov    %esp,%ebp
80106597:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010659a:	68 20 64 10 80       	push   $0x80106420
8010659f:	e8 cc a7 ff ff       	call   80100d70 <consoleintr>
}
801065a4:	83 c4 10             	add    $0x10,%esp
801065a7:	c9                   	leave  
801065a8:	c3                   	ret    

801065a9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $0
801065ab:	6a 00                	push   $0x0
  jmp alltraps
801065ad:	e9 3c fb ff ff       	jmp    801060ee <alltraps>

801065b2 <vector1>:
.globl vector1
vector1:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $1
801065b4:	6a 01                	push   $0x1
  jmp alltraps
801065b6:	e9 33 fb ff ff       	jmp    801060ee <alltraps>

801065bb <vector2>:
.globl vector2
vector2:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $2
801065bd:	6a 02                	push   $0x2
  jmp alltraps
801065bf:	e9 2a fb ff ff       	jmp    801060ee <alltraps>

801065c4 <vector3>:
.globl vector3
vector3:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $3
801065c6:	6a 03                	push   $0x3
  jmp alltraps
801065c8:	e9 21 fb ff ff       	jmp    801060ee <alltraps>

801065cd <vector4>:
.globl vector4
vector4:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $4
801065cf:	6a 04                	push   $0x4
  jmp alltraps
801065d1:	e9 18 fb ff ff       	jmp    801060ee <alltraps>

801065d6 <vector5>:
.globl vector5
vector5:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $5
801065d8:	6a 05                	push   $0x5
  jmp alltraps
801065da:	e9 0f fb ff ff       	jmp    801060ee <alltraps>

801065df <vector6>:
.globl vector6
vector6:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $6
801065e1:	6a 06                	push   $0x6
  jmp alltraps
801065e3:	e9 06 fb ff ff       	jmp    801060ee <alltraps>

801065e8 <vector7>:
.globl vector7
vector7:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $7
801065ea:	6a 07                	push   $0x7
  jmp alltraps
801065ec:	e9 fd fa ff ff       	jmp    801060ee <alltraps>

801065f1 <vector8>:
.globl vector8
vector8:
  pushl $8
801065f1:	6a 08                	push   $0x8
  jmp alltraps
801065f3:	e9 f6 fa ff ff       	jmp    801060ee <alltraps>

801065f8 <vector9>:
.globl vector9
vector9:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $9
801065fa:	6a 09                	push   $0x9
  jmp alltraps
801065fc:	e9 ed fa ff ff       	jmp    801060ee <alltraps>

80106601 <vector10>:
.globl vector10
vector10:
  pushl $10
80106601:	6a 0a                	push   $0xa
  jmp alltraps
80106603:	e9 e6 fa ff ff       	jmp    801060ee <alltraps>

80106608 <vector11>:
.globl vector11
vector11:
  pushl $11
80106608:	6a 0b                	push   $0xb
  jmp alltraps
8010660a:	e9 df fa ff ff       	jmp    801060ee <alltraps>

8010660f <vector12>:
.globl vector12
vector12:
  pushl $12
8010660f:	6a 0c                	push   $0xc
  jmp alltraps
80106611:	e9 d8 fa ff ff       	jmp    801060ee <alltraps>

80106616 <vector13>:
.globl vector13
vector13:
  pushl $13
80106616:	6a 0d                	push   $0xd
  jmp alltraps
80106618:	e9 d1 fa ff ff       	jmp    801060ee <alltraps>

8010661d <vector14>:
.globl vector14
vector14:
  pushl $14
8010661d:	6a 0e                	push   $0xe
  jmp alltraps
8010661f:	e9 ca fa ff ff       	jmp    801060ee <alltraps>

80106624 <vector15>:
.globl vector15
vector15:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $15
80106626:	6a 0f                	push   $0xf
  jmp alltraps
80106628:	e9 c1 fa ff ff       	jmp    801060ee <alltraps>

8010662d <vector16>:
.globl vector16
vector16:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $16
8010662f:	6a 10                	push   $0x10
  jmp alltraps
80106631:	e9 b8 fa ff ff       	jmp    801060ee <alltraps>

80106636 <vector17>:
.globl vector17
vector17:
  pushl $17
80106636:	6a 11                	push   $0x11
  jmp alltraps
80106638:	e9 b1 fa ff ff       	jmp    801060ee <alltraps>

8010663d <vector18>:
.globl vector18
vector18:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $18
8010663f:	6a 12                	push   $0x12
  jmp alltraps
80106641:	e9 a8 fa ff ff       	jmp    801060ee <alltraps>

80106646 <vector19>:
.globl vector19
vector19:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $19
80106648:	6a 13                	push   $0x13
  jmp alltraps
8010664a:	e9 9f fa ff ff       	jmp    801060ee <alltraps>

8010664f <vector20>:
.globl vector20
vector20:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $20
80106651:	6a 14                	push   $0x14
  jmp alltraps
80106653:	e9 96 fa ff ff       	jmp    801060ee <alltraps>

80106658 <vector21>:
.globl vector21
vector21:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $21
8010665a:	6a 15                	push   $0x15
  jmp alltraps
8010665c:	e9 8d fa ff ff       	jmp    801060ee <alltraps>

80106661 <vector22>:
.globl vector22
vector22:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $22
80106663:	6a 16                	push   $0x16
  jmp alltraps
80106665:	e9 84 fa ff ff       	jmp    801060ee <alltraps>

8010666a <vector23>:
.globl vector23
vector23:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $23
8010666c:	6a 17                	push   $0x17
  jmp alltraps
8010666e:	e9 7b fa ff ff       	jmp    801060ee <alltraps>

80106673 <vector24>:
.globl vector24
vector24:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $24
80106675:	6a 18                	push   $0x18
  jmp alltraps
80106677:	e9 72 fa ff ff       	jmp    801060ee <alltraps>

8010667c <vector25>:
.globl vector25
vector25:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $25
8010667e:	6a 19                	push   $0x19
  jmp alltraps
80106680:	e9 69 fa ff ff       	jmp    801060ee <alltraps>

80106685 <vector26>:
.globl vector26
vector26:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $26
80106687:	6a 1a                	push   $0x1a
  jmp alltraps
80106689:	e9 60 fa ff ff       	jmp    801060ee <alltraps>

8010668e <vector27>:
.globl vector27
vector27:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $27
80106690:	6a 1b                	push   $0x1b
  jmp alltraps
80106692:	e9 57 fa ff ff       	jmp    801060ee <alltraps>

80106697 <vector28>:
.globl vector28
vector28:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $28
80106699:	6a 1c                	push   $0x1c
  jmp alltraps
8010669b:	e9 4e fa ff ff       	jmp    801060ee <alltraps>

801066a0 <vector29>:
.globl vector29
vector29:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $29
801066a2:	6a 1d                	push   $0x1d
  jmp alltraps
801066a4:	e9 45 fa ff ff       	jmp    801060ee <alltraps>

801066a9 <vector30>:
.globl vector30
vector30:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $30
801066ab:	6a 1e                	push   $0x1e
  jmp alltraps
801066ad:	e9 3c fa ff ff       	jmp    801060ee <alltraps>

801066b2 <vector31>:
.globl vector31
vector31:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $31
801066b4:	6a 1f                	push   $0x1f
  jmp alltraps
801066b6:	e9 33 fa ff ff       	jmp    801060ee <alltraps>

801066bb <vector32>:
.globl vector32
vector32:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $32
801066bd:	6a 20                	push   $0x20
  jmp alltraps
801066bf:	e9 2a fa ff ff       	jmp    801060ee <alltraps>

801066c4 <vector33>:
.globl vector33
vector33:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $33
801066c6:	6a 21                	push   $0x21
  jmp alltraps
801066c8:	e9 21 fa ff ff       	jmp    801060ee <alltraps>

801066cd <vector34>:
.globl vector34
vector34:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $34
801066cf:	6a 22                	push   $0x22
  jmp alltraps
801066d1:	e9 18 fa ff ff       	jmp    801060ee <alltraps>

801066d6 <vector35>:
.globl vector35
vector35:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $35
801066d8:	6a 23                	push   $0x23
  jmp alltraps
801066da:	e9 0f fa ff ff       	jmp    801060ee <alltraps>

801066df <vector36>:
.globl vector36
vector36:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $36
801066e1:	6a 24                	push   $0x24
  jmp alltraps
801066e3:	e9 06 fa ff ff       	jmp    801060ee <alltraps>

801066e8 <vector37>:
.globl vector37
vector37:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $37
801066ea:	6a 25                	push   $0x25
  jmp alltraps
801066ec:	e9 fd f9 ff ff       	jmp    801060ee <alltraps>

801066f1 <vector38>:
.globl vector38
vector38:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $38
801066f3:	6a 26                	push   $0x26
  jmp alltraps
801066f5:	e9 f4 f9 ff ff       	jmp    801060ee <alltraps>

801066fa <vector39>:
.globl vector39
vector39:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $39
801066fc:	6a 27                	push   $0x27
  jmp alltraps
801066fe:	e9 eb f9 ff ff       	jmp    801060ee <alltraps>

80106703 <vector40>:
.globl vector40
vector40:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $40
80106705:	6a 28                	push   $0x28
  jmp alltraps
80106707:	e9 e2 f9 ff ff       	jmp    801060ee <alltraps>

8010670c <vector41>:
.globl vector41
vector41:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $41
8010670e:	6a 29                	push   $0x29
  jmp alltraps
80106710:	e9 d9 f9 ff ff       	jmp    801060ee <alltraps>

80106715 <vector42>:
.globl vector42
vector42:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $42
80106717:	6a 2a                	push   $0x2a
  jmp alltraps
80106719:	e9 d0 f9 ff ff       	jmp    801060ee <alltraps>

8010671e <vector43>:
.globl vector43
vector43:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $43
80106720:	6a 2b                	push   $0x2b
  jmp alltraps
80106722:	e9 c7 f9 ff ff       	jmp    801060ee <alltraps>

80106727 <vector44>:
.globl vector44
vector44:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $44
80106729:	6a 2c                	push   $0x2c
  jmp alltraps
8010672b:	e9 be f9 ff ff       	jmp    801060ee <alltraps>

80106730 <vector45>:
.globl vector45
vector45:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $45
80106732:	6a 2d                	push   $0x2d
  jmp alltraps
80106734:	e9 b5 f9 ff ff       	jmp    801060ee <alltraps>

80106739 <vector46>:
.globl vector46
vector46:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $46
8010673b:	6a 2e                	push   $0x2e
  jmp alltraps
8010673d:	e9 ac f9 ff ff       	jmp    801060ee <alltraps>

80106742 <vector47>:
.globl vector47
vector47:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $47
80106744:	6a 2f                	push   $0x2f
  jmp alltraps
80106746:	e9 a3 f9 ff ff       	jmp    801060ee <alltraps>

8010674b <vector48>:
.globl vector48
vector48:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $48
8010674d:	6a 30                	push   $0x30
  jmp alltraps
8010674f:	e9 9a f9 ff ff       	jmp    801060ee <alltraps>

80106754 <vector49>:
.globl vector49
vector49:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $49
80106756:	6a 31                	push   $0x31
  jmp alltraps
80106758:	e9 91 f9 ff ff       	jmp    801060ee <alltraps>

8010675d <vector50>:
.globl vector50
vector50:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $50
8010675f:	6a 32                	push   $0x32
  jmp alltraps
80106761:	e9 88 f9 ff ff       	jmp    801060ee <alltraps>

80106766 <vector51>:
.globl vector51
vector51:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $51
80106768:	6a 33                	push   $0x33
  jmp alltraps
8010676a:	e9 7f f9 ff ff       	jmp    801060ee <alltraps>

8010676f <vector52>:
.globl vector52
vector52:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $52
80106771:	6a 34                	push   $0x34
  jmp alltraps
80106773:	e9 76 f9 ff ff       	jmp    801060ee <alltraps>

80106778 <vector53>:
.globl vector53
vector53:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $53
8010677a:	6a 35                	push   $0x35
  jmp alltraps
8010677c:	e9 6d f9 ff ff       	jmp    801060ee <alltraps>

80106781 <vector54>:
.globl vector54
vector54:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $54
80106783:	6a 36                	push   $0x36
  jmp alltraps
80106785:	e9 64 f9 ff ff       	jmp    801060ee <alltraps>

8010678a <vector55>:
.globl vector55
vector55:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $55
8010678c:	6a 37                	push   $0x37
  jmp alltraps
8010678e:	e9 5b f9 ff ff       	jmp    801060ee <alltraps>

80106793 <vector56>:
.globl vector56
vector56:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $56
80106795:	6a 38                	push   $0x38
  jmp alltraps
80106797:	e9 52 f9 ff ff       	jmp    801060ee <alltraps>

8010679c <vector57>:
.globl vector57
vector57:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $57
8010679e:	6a 39                	push   $0x39
  jmp alltraps
801067a0:	e9 49 f9 ff ff       	jmp    801060ee <alltraps>

801067a5 <vector58>:
.globl vector58
vector58:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $58
801067a7:	6a 3a                	push   $0x3a
  jmp alltraps
801067a9:	e9 40 f9 ff ff       	jmp    801060ee <alltraps>

801067ae <vector59>:
.globl vector59
vector59:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $59
801067b0:	6a 3b                	push   $0x3b
  jmp alltraps
801067b2:	e9 37 f9 ff ff       	jmp    801060ee <alltraps>

801067b7 <vector60>:
.globl vector60
vector60:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $60
801067b9:	6a 3c                	push   $0x3c
  jmp alltraps
801067bb:	e9 2e f9 ff ff       	jmp    801060ee <alltraps>

801067c0 <vector61>:
.globl vector61
vector61:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $61
801067c2:	6a 3d                	push   $0x3d
  jmp alltraps
801067c4:	e9 25 f9 ff ff       	jmp    801060ee <alltraps>

801067c9 <vector62>:
.globl vector62
vector62:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $62
801067cb:	6a 3e                	push   $0x3e
  jmp alltraps
801067cd:	e9 1c f9 ff ff       	jmp    801060ee <alltraps>

801067d2 <vector63>:
.globl vector63
vector63:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $63
801067d4:	6a 3f                	push   $0x3f
  jmp alltraps
801067d6:	e9 13 f9 ff ff       	jmp    801060ee <alltraps>

801067db <vector64>:
.globl vector64
vector64:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $64
801067dd:	6a 40                	push   $0x40
  jmp alltraps
801067df:	e9 0a f9 ff ff       	jmp    801060ee <alltraps>

801067e4 <vector65>:
.globl vector65
vector65:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $65
801067e6:	6a 41                	push   $0x41
  jmp alltraps
801067e8:	e9 01 f9 ff ff       	jmp    801060ee <alltraps>

801067ed <vector66>:
.globl vector66
vector66:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $66
801067ef:	6a 42                	push   $0x42
  jmp alltraps
801067f1:	e9 f8 f8 ff ff       	jmp    801060ee <alltraps>

801067f6 <vector67>:
.globl vector67
vector67:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $67
801067f8:	6a 43                	push   $0x43
  jmp alltraps
801067fa:	e9 ef f8 ff ff       	jmp    801060ee <alltraps>

801067ff <vector68>:
.globl vector68
vector68:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $68
80106801:	6a 44                	push   $0x44
  jmp alltraps
80106803:	e9 e6 f8 ff ff       	jmp    801060ee <alltraps>

80106808 <vector69>:
.globl vector69
vector69:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $69
8010680a:	6a 45                	push   $0x45
  jmp alltraps
8010680c:	e9 dd f8 ff ff       	jmp    801060ee <alltraps>

80106811 <vector70>:
.globl vector70
vector70:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $70
80106813:	6a 46                	push   $0x46
  jmp alltraps
80106815:	e9 d4 f8 ff ff       	jmp    801060ee <alltraps>

8010681a <vector71>:
.globl vector71
vector71:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $71
8010681c:	6a 47                	push   $0x47
  jmp alltraps
8010681e:	e9 cb f8 ff ff       	jmp    801060ee <alltraps>

80106823 <vector72>:
.globl vector72
vector72:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $72
80106825:	6a 48                	push   $0x48
  jmp alltraps
80106827:	e9 c2 f8 ff ff       	jmp    801060ee <alltraps>

8010682c <vector73>:
.globl vector73
vector73:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $73
8010682e:	6a 49                	push   $0x49
  jmp alltraps
80106830:	e9 b9 f8 ff ff       	jmp    801060ee <alltraps>

80106835 <vector74>:
.globl vector74
vector74:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $74
80106837:	6a 4a                	push   $0x4a
  jmp alltraps
80106839:	e9 b0 f8 ff ff       	jmp    801060ee <alltraps>

8010683e <vector75>:
.globl vector75
vector75:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $75
80106840:	6a 4b                	push   $0x4b
  jmp alltraps
80106842:	e9 a7 f8 ff ff       	jmp    801060ee <alltraps>

80106847 <vector76>:
.globl vector76
vector76:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $76
80106849:	6a 4c                	push   $0x4c
  jmp alltraps
8010684b:	e9 9e f8 ff ff       	jmp    801060ee <alltraps>

80106850 <vector77>:
.globl vector77
vector77:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $77
80106852:	6a 4d                	push   $0x4d
  jmp alltraps
80106854:	e9 95 f8 ff ff       	jmp    801060ee <alltraps>

80106859 <vector78>:
.globl vector78
vector78:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $78
8010685b:	6a 4e                	push   $0x4e
  jmp alltraps
8010685d:	e9 8c f8 ff ff       	jmp    801060ee <alltraps>

80106862 <vector79>:
.globl vector79
vector79:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $79
80106864:	6a 4f                	push   $0x4f
  jmp alltraps
80106866:	e9 83 f8 ff ff       	jmp    801060ee <alltraps>

8010686b <vector80>:
.globl vector80
vector80:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $80
8010686d:	6a 50                	push   $0x50
  jmp alltraps
8010686f:	e9 7a f8 ff ff       	jmp    801060ee <alltraps>

80106874 <vector81>:
.globl vector81
vector81:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $81
80106876:	6a 51                	push   $0x51
  jmp alltraps
80106878:	e9 71 f8 ff ff       	jmp    801060ee <alltraps>

8010687d <vector82>:
.globl vector82
vector82:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $82
8010687f:	6a 52                	push   $0x52
  jmp alltraps
80106881:	e9 68 f8 ff ff       	jmp    801060ee <alltraps>

80106886 <vector83>:
.globl vector83
vector83:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $83
80106888:	6a 53                	push   $0x53
  jmp alltraps
8010688a:	e9 5f f8 ff ff       	jmp    801060ee <alltraps>

8010688f <vector84>:
.globl vector84
vector84:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $84
80106891:	6a 54                	push   $0x54
  jmp alltraps
80106893:	e9 56 f8 ff ff       	jmp    801060ee <alltraps>

80106898 <vector85>:
.globl vector85
vector85:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $85
8010689a:	6a 55                	push   $0x55
  jmp alltraps
8010689c:	e9 4d f8 ff ff       	jmp    801060ee <alltraps>

801068a1 <vector86>:
.globl vector86
vector86:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $86
801068a3:	6a 56                	push   $0x56
  jmp alltraps
801068a5:	e9 44 f8 ff ff       	jmp    801060ee <alltraps>

801068aa <vector87>:
.globl vector87
vector87:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $87
801068ac:	6a 57                	push   $0x57
  jmp alltraps
801068ae:	e9 3b f8 ff ff       	jmp    801060ee <alltraps>

801068b3 <vector88>:
.globl vector88
vector88:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $88
801068b5:	6a 58                	push   $0x58
  jmp alltraps
801068b7:	e9 32 f8 ff ff       	jmp    801060ee <alltraps>

801068bc <vector89>:
.globl vector89
vector89:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $89
801068be:	6a 59                	push   $0x59
  jmp alltraps
801068c0:	e9 29 f8 ff ff       	jmp    801060ee <alltraps>

801068c5 <vector90>:
.globl vector90
vector90:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $90
801068c7:	6a 5a                	push   $0x5a
  jmp alltraps
801068c9:	e9 20 f8 ff ff       	jmp    801060ee <alltraps>

801068ce <vector91>:
.globl vector91
vector91:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $91
801068d0:	6a 5b                	push   $0x5b
  jmp alltraps
801068d2:	e9 17 f8 ff ff       	jmp    801060ee <alltraps>

801068d7 <vector92>:
.globl vector92
vector92:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $92
801068d9:	6a 5c                	push   $0x5c
  jmp alltraps
801068db:	e9 0e f8 ff ff       	jmp    801060ee <alltraps>

801068e0 <vector93>:
.globl vector93
vector93:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $93
801068e2:	6a 5d                	push   $0x5d
  jmp alltraps
801068e4:	e9 05 f8 ff ff       	jmp    801060ee <alltraps>

801068e9 <vector94>:
.globl vector94
vector94:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $94
801068eb:	6a 5e                	push   $0x5e
  jmp alltraps
801068ed:	e9 fc f7 ff ff       	jmp    801060ee <alltraps>

801068f2 <vector95>:
.globl vector95
vector95:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $95
801068f4:	6a 5f                	push   $0x5f
  jmp alltraps
801068f6:	e9 f3 f7 ff ff       	jmp    801060ee <alltraps>

801068fb <vector96>:
.globl vector96
vector96:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $96
801068fd:	6a 60                	push   $0x60
  jmp alltraps
801068ff:	e9 ea f7 ff ff       	jmp    801060ee <alltraps>

80106904 <vector97>:
.globl vector97
vector97:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $97
80106906:	6a 61                	push   $0x61
  jmp alltraps
80106908:	e9 e1 f7 ff ff       	jmp    801060ee <alltraps>

8010690d <vector98>:
.globl vector98
vector98:
  pushl $0
8010690d:	6a 00                	push   $0x0
  pushl $98
8010690f:	6a 62                	push   $0x62
  jmp alltraps
80106911:	e9 d8 f7 ff ff       	jmp    801060ee <alltraps>

80106916 <vector99>:
.globl vector99
vector99:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $99
80106918:	6a 63                	push   $0x63
  jmp alltraps
8010691a:	e9 cf f7 ff ff       	jmp    801060ee <alltraps>

8010691f <vector100>:
.globl vector100
vector100:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $100
80106921:	6a 64                	push   $0x64
  jmp alltraps
80106923:	e9 c6 f7 ff ff       	jmp    801060ee <alltraps>

80106928 <vector101>:
.globl vector101
vector101:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $101
8010692a:	6a 65                	push   $0x65
  jmp alltraps
8010692c:	e9 bd f7 ff ff       	jmp    801060ee <alltraps>

80106931 <vector102>:
.globl vector102
vector102:
  pushl $0
80106931:	6a 00                	push   $0x0
  pushl $102
80106933:	6a 66                	push   $0x66
  jmp alltraps
80106935:	e9 b4 f7 ff ff       	jmp    801060ee <alltraps>

8010693a <vector103>:
.globl vector103
vector103:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $103
8010693c:	6a 67                	push   $0x67
  jmp alltraps
8010693e:	e9 ab f7 ff ff       	jmp    801060ee <alltraps>

80106943 <vector104>:
.globl vector104
vector104:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $104
80106945:	6a 68                	push   $0x68
  jmp alltraps
80106947:	e9 a2 f7 ff ff       	jmp    801060ee <alltraps>

8010694c <vector105>:
.globl vector105
vector105:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $105
8010694e:	6a 69                	push   $0x69
  jmp alltraps
80106950:	e9 99 f7 ff ff       	jmp    801060ee <alltraps>

80106955 <vector106>:
.globl vector106
vector106:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $106
80106957:	6a 6a                	push   $0x6a
  jmp alltraps
80106959:	e9 90 f7 ff ff       	jmp    801060ee <alltraps>

8010695e <vector107>:
.globl vector107
vector107:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $107
80106960:	6a 6b                	push   $0x6b
  jmp alltraps
80106962:	e9 87 f7 ff ff       	jmp    801060ee <alltraps>

80106967 <vector108>:
.globl vector108
vector108:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $108
80106969:	6a 6c                	push   $0x6c
  jmp alltraps
8010696b:	e9 7e f7 ff ff       	jmp    801060ee <alltraps>

80106970 <vector109>:
.globl vector109
vector109:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $109
80106972:	6a 6d                	push   $0x6d
  jmp alltraps
80106974:	e9 75 f7 ff ff       	jmp    801060ee <alltraps>

80106979 <vector110>:
.globl vector110
vector110:
  pushl $0
80106979:	6a 00                	push   $0x0
  pushl $110
8010697b:	6a 6e                	push   $0x6e
  jmp alltraps
8010697d:	e9 6c f7 ff ff       	jmp    801060ee <alltraps>

80106982 <vector111>:
.globl vector111
vector111:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $111
80106984:	6a 6f                	push   $0x6f
  jmp alltraps
80106986:	e9 63 f7 ff ff       	jmp    801060ee <alltraps>

8010698b <vector112>:
.globl vector112
vector112:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $112
8010698d:	6a 70                	push   $0x70
  jmp alltraps
8010698f:	e9 5a f7 ff ff       	jmp    801060ee <alltraps>

80106994 <vector113>:
.globl vector113
vector113:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $113
80106996:	6a 71                	push   $0x71
  jmp alltraps
80106998:	e9 51 f7 ff ff       	jmp    801060ee <alltraps>

8010699d <vector114>:
.globl vector114
vector114:
  pushl $0
8010699d:	6a 00                	push   $0x0
  pushl $114
8010699f:	6a 72                	push   $0x72
  jmp alltraps
801069a1:	e9 48 f7 ff ff       	jmp    801060ee <alltraps>

801069a6 <vector115>:
.globl vector115
vector115:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $115
801069a8:	6a 73                	push   $0x73
  jmp alltraps
801069aa:	e9 3f f7 ff ff       	jmp    801060ee <alltraps>

801069af <vector116>:
.globl vector116
vector116:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $116
801069b1:	6a 74                	push   $0x74
  jmp alltraps
801069b3:	e9 36 f7 ff ff       	jmp    801060ee <alltraps>

801069b8 <vector117>:
.globl vector117
vector117:
  pushl $0
801069b8:	6a 00                	push   $0x0
  pushl $117
801069ba:	6a 75                	push   $0x75
  jmp alltraps
801069bc:	e9 2d f7 ff ff       	jmp    801060ee <alltraps>

801069c1 <vector118>:
.globl vector118
vector118:
  pushl $0
801069c1:	6a 00                	push   $0x0
  pushl $118
801069c3:	6a 76                	push   $0x76
  jmp alltraps
801069c5:	e9 24 f7 ff ff       	jmp    801060ee <alltraps>

801069ca <vector119>:
.globl vector119
vector119:
  pushl $0
801069ca:	6a 00                	push   $0x0
  pushl $119
801069cc:	6a 77                	push   $0x77
  jmp alltraps
801069ce:	e9 1b f7 ff ff       	jmp    801060ee <alltraps>

801069d3 <vector120>:
.globl vector120
vector120:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $120
801069d5:	6a 78                	push   $0x78
  jmp alltraps
801069d7:	e9 12 f7 ff ff       	jmp    801060ee <alltraps>

801069dc <vector121>:
.globl vector121
vector121:
  pushl $0
801069dc:	6a 00                	push   $0x0
  pushl $121
801069de:	6a 79                	push   $0x79
  jmp alltraps
801069e0:	e9 09 f7 ff ff       	jmp    801060ee <alltraps>

801069e5 <vector122>:
.globl vector122
vector122:
  pushl $0
801069e5:	6a 00                	push   $0x0
  pushl $122
801069e7:	6a 7a                	push   $0x7a
  jmp alltraps
801069e9:	e9 00 f7 ff ff       	jmp    801060ee <alltraps>

801069ee <vector123>:
.globl vector123
vector123:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $123
801069f0:	6a 7b                	push   $0x7b
  jmp alltraps
801069f2:	e9 f7 f6 ff ff       	jmp    801060ee <alltraps>

801069f7 <vector124>:
.globl vector124
vector124:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $124
801069f9:	6a 7c                	push   $0x7c
  jmp alltraps
801069fb:	e9 ee f6 ff ff       	jmp    801060ee <alltraps>

80106a00 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a00:	6a 00                	push   $0x0
  pushl $125
80106a02:	6a 7d                	push   $0x7d
  jmp alltraps
80106a04:	e9 e5 f6 ff ff       	jmp    801060ee <alltraps>

80106a09 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $126
80106a0b:	6a 7e                	push   $0x7e
  jmp alltraps
80106a0d:	e9 dc f6 ff ff       	jmp    801060ee <alltraps>

80106a12 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $127
80106a14:	6a 7f                	push   $0x7f
  jmp alltraps
80106a16:	e9 d3 f6 ff ff       	jmp    801060ee <alltraps>

80106a1b <vector128>:
.globl vector128
vector128:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $128
80106a1d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a22:	e9 c7 f6 ff ff       	jmp    801060ee <alltraps>

80106a27 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $129
80106a29:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a2e:	e9 bb f6 ff ff       	jmp    801060ee <alltraps>

80106a33 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $130
80106a35:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a3a:	e9 af f6 ff ff       	jmp    801060ee <alltraps>

80106a3f <vector131>:
.globl vector131
vector131:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $131
80106a41:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a46:	e9 a3 f6 ff ff       	jmp    801060ee <alltraps>

80106a4b <vector132>:
.globl vector132
vector132:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $132
80106a4d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a52:	e9 97 f6 ff ff       	jmp    801060ee <alltraps>

80106a57 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $133
80106a59:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a5e:	e9 8b f6 ff ff       	jmp    801060ee <alltraps>

80106a63 <vector134>:
.globl vector134
vector134:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $134
80106a65:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a6a:	e9 7f f6 ff ff       	jmp    801060ee <alltraps>

80106a6f <vector135>:
.globl vector135
vector135:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $135
80106a71:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a76:	e9 73 f6 ff ff       	jmp    801060ee <alltraps>

80106a7b <vector136>:
.globl vector136
vector136:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $136
80106a7d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a82:	e9 67 f6 ff ff       	jmp    801060ee <alltraps>

80106a87 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $137
80106a89:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a8e:	e9 5b f6 ff ff       	jmp    801060ee <alltraps>

80106a93 <vector138>:
.globl vector138
vector138:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $138
80106a95:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a9a:	e9 4f f6 ff ff       	jmp    801060ee <alltraps>

80106a9f <vector139>:
.globl vector139
vector139:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $139
80106aa1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106aa6:	e9 43 f6 ff ff       	jmp    801060ee <alltraps>

80106aab <vector140>:
.globl vector140
vector140:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $140
80106aad:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ab2:	e9 37 f6 ff ff       	jmp    801060ee <alltraps>

80106ab7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $141
80106ab9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106abe:	e9 2b f6 ff ff       	jmp    801060ee <alltraps>

80106ac3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $142
80106ac5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106aca:	e9 1f f6 ff ff       	jmp    801060ee <alltraps>

80106acf <vector143>:
.globl vector143
vector143:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $143
80106ad1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ad6:	e9 13 f6 ff ff       	jmp    801060ee <alltraps>

80106adb <vector144>:
.globl vector144
vector144:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $144
80106add:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ae2:	e9 07 f6 ff ff       	jmp    801060ee <alltraps>

80106ae7 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $145
80106ae9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106aee:	e9 fb f5 ff ff       	jmp    801060ee <alltraps>

80106af3 <vector146>:
.globl vector146
vector146:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $146
80106af5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106afa:	e9 ef f5 ff ff       	jmp    801060ee <alltraps>

80106aff <vector147>:
.globl vector147
vector147:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $147
80106b01:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b06:	e9 e3 f5 ff ff       	jmp    801060ee <alltraps>

80106b0b <vector148>:
.globl vector148
vector148:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $148
80106b0d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b12:	e9 d7 f5 ff ff       	jmp    801060ee <alltraps>

80106b17 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $149
80106b19:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b1e:	e9 cb f5 ff ff       	jmp    801060ee <alltraps>

80106b23 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $150
80106b25:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b2a:	e9 bf f5 ff ff       	jmp    801060ee <alltraps>

80106b2f <vector151>:
.globl vector151
vector151:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $151
80106b31:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b36:	e9 b3 f5 ff ff       	jmp    801060ee <alltraps>

80106b3b <vector152>:
.globl vector152
vector152:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $152
80106b3d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b42:	e9 a7 f5 ff ff       	jmp    801060ee <alltraps>

80106b47 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $153
80106b49:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b4e:	e9 9b f5 ff ff       	jmp    801060ee <alltraps>

80106b53 <vector154>:
.globl vector154
vector154:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $154
80106b55:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b5a:	e9 8f f5 ff ff       	jmp    801060ee <alltraps>

80106b5f <vector155>:
.globl vector155
vector155:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $155
80106b61:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b66:	e9 83 f5 ff ff       	jmp    801060ee <alltraps>

80106b6b <vector156>:
.globl vector156
vector156:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $156
80106b6d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b72:	e9 77 f5 ff ff       	jmp    801060ee <alltraps>

80106b77 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $157
80106b79:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b7e:	e9 6b f5 ff ff       	jmp    801060ee <alltraps>

80106b83 <vector158>:
.globl vector158
vector158:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $158
80106b85:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b8a:	e9 5f f5 ff ff       	jmp    801060ee <alltraps>

80106b8f <vector159>:
.globl vector159
vector159:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $159
80106b91:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b96:	e9 53 f5 ff ff       	jmp    801060ee <alltraps>

80106b9b <vector160>:
.globl vector160
vector160:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $160
80106b9d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106ba2:	e9 47 f5 ff ff       	jmp    801060ee <alltraps>

80106ba7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $161
80106ba9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bae:	e9 3b f5 ff ff       	jmp    801060ee <alltraps>

80106bb3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $162
80106bb5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bba:	e9 2f f5 ff ff       	jmp    801060ee <alltraps>

80106bbf <vector163>:
.globl vector163
vector163:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $163
80106bc1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106bc6:	e9 23 f5 ff ff       	jmp    801060ee <alltraps>

80106bcb <vector164>:
.globl vector164
vector164:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $164
80106bcd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bd2:	e9 17 f5 ff ff       	jmp    801060ee <alltraps>

80106bd7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $165
80106bd9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106bde:	e9 0b f5 ff ff       	jmp    801060ee <alltraps>

80106be3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $166
80106be5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106bea:	e9 ff f4 ff ff       	jmp    801060ee <alltraps>

80106bef <vector167>:
.globl vector167
vector167:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $167
80106bf1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106bf6:	e9 f3 f4 ff ff       	jmp    801060ee <alltraps>

80106bfb <vector168>:
.globl vector168
vector168:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $168
80106bfd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c02:	e9 e7 f4 ff ff       	jmp    801060ee <alltraps>

80106c07 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $169
80106c09:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c0e:	e9 db f4 ff ff       	jmp    801060ee <alltraps>

80106c13 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $170
80106c15:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c1a:	e9 cf f4 ff ff       	jmp    801060ee <alltraps>

80106c1f <vector171>:
.globl vector171
vector171:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $171
80106c21:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c26:	e9 c3 f4 ff ff       	jmp    801060ee <alltraps>

80106c2b <vector172>:
.globl vector172
vector172:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $172
80106c2d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c32:	e9 b7 f4 ff ff       	jmp    801060ee <alltraps>

80106c37 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $173
80106c39:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c3e:	e9 ab f4 ff ff       	jmp    801060ee <alltraps>

80106c43 <vector174>:
.globl vector174
vector174:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $174
80106c45:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c4a:	e9 9f f4 ff ff       	jmp    801060ee <alltraps>

80106c4f <vector175>:
.globl vector175
vector175:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $175
80106c51:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c56:	e9 93 f4 ff ff       	jmp    801060ee <alltraps>

80106c5b <vector176>:
.globl vector176
vector176:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $176
80106c5d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c62:	e9 87 f4 ff ff       	jmp    801060ee <alltraps>

80106c67 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $177
80106c69:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c6e:	e9 7b f4 ff ff       	jmp    801060ee <alltraps>

80106c73 <vector178>:
.globl vector178
vector178:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $178
80106c75:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c7a:	e9 6f f4 ff ff       	jmp    801060ee <alltraps>

80106c7f <vector179>:
.globl vector179
vector179:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $179
80106c81:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c86:	e9 63 f4 ff ff       	jmp    801060ee <alltraps>

80106c8b <vector180>:
.globl vector180
vector180:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $180
80106c8d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c92:	e9 57 f4 ff ff       	jmp    801060ee <alltraps>

80106c97 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $181
80106c99:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c9e:	e9 4b f4 ff ff       	jmp    801060ee <alltraps>

80106ca3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $182
80106ca5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106caa:	e9 3f f4 ff ff       	jmp    801060ee <alltraps>

80106caf <vector183>:
.globl vector183
vector183:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $183
80106cb1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106cb6:	e9 33 f4 ff ff       	jmp    801060ee <alltraps>

80106cbb <vector184>:
.globl vector184
vector184:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $184
80106cbd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cc2:	e9 27 f4 ff ff       	jmp    801060ee <alltraps>

80106cc7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $185
80106cc9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cce:	e9 1b f4 ff ff       	jmp    801060ee <alltraps>

80106cd3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $186
80106cd5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106cda:	e9 0f f4 ff ff       	jmp    801060ee <alltraps>

80106cdf <vector187>:
.globl vector187
vector187:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $187
80106ce1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ce6:	e9 03 f4 ff ff       	jmp    801060ee <alltraps>

80106ceb <vector188>:
.globl vector188
vector188:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $188
80106ced:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cf2:	e9 f7 f3 ff ff       	jmp    801060ee <alltraps>

80106cf7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $189
80106cf9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cfe:	e9 eb f3 ff ff       	jmp    801060ee <alltraps>

80106d03 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $190
80106d05:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d0a:	e9 df f3 ff ff       	jmp    801060ee <alltraps>

80106d0f <vector191>:
.globl vector191
vector191:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $191
80106d11:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d16:	e9 d3 f3 ff ff       	jmp    801060ee <alltraps>

80106d1b <vector192>:
.globl vector192
vector192:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $192
80106d1d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d22:	e9 c7 f3 ff ff       	jmp    801060ee <alltraps>

80106d27 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $193
80106d29:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d2e:	e9 bb f3 ff ff       	jmp    801060ee <alltraps>

80106d33 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $194
80106d35:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d3a:	e9 af f3 ff ff       	jmp    801060ee <alltraps>

80106d3f <vector195>:
.globl vector195
vector195:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $195
80106d41:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d46:	e9 a3 f3 ff ff       	jmp    801060ee <alltraps>

80106d4b <vector196>:
.globl vector196
vector196:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $196
80106d4d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d52:	e9 97 f3 ff ff       	jmp    801060ee <alltraps>

80106d57 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $197
80106d59:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d5e:	e9 8b f3 ff ff       	jmp    801060ee <alltraps>

80106d63 <vector198>:
.globl vector198
vector198:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $198
80106d65:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d6a:	e9 7f f3 ff ff       	jmp    801060ee <alltraps>

80106d6f <vector199>:
.globl vector199
vector199:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $199
80106d71:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d76:	e9 73 f3 ff ff       	jmp    801060ee <alltraps>

80106d7b <vector200>:
.globl vector200
vector200:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $200
80106d7d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d82:	e9 67 f3 ff ff       	jmp    801060ee <alltraps>

80106d87 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $201
80106d89:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d8e:	e9 5b f3 ff ff       	jmp    801060ee <alltraps>

80106d93 <vector202>:
.globl vector202
vector202:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $202
80106d95:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d9a:	e9 4f f3 ff ff       	jmp    801060ee <alltraps>

80106d9f <vector203>:
.globl vector203
vector203:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $203
80106da1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106da6:	e9 43 f3 ff ff       	jmp    801060ee <alltraps>

80106dab <vector204>:
.globl vector204
vector204:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $204
80106dad:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106db2:	e9 37 f3 ff ff       	jmp    801060ee <alltraps>

80106db7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $205
80106db9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dbe:	e9 2b f3 ff ff       	jmp    801060ee <alltraps>

80106dc3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $206
80106dc5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106dca:	e9 1f f3 ff ff       	jmp    801060ee <alltraps>

80106dcf <vector207>:
.globl vector207
vector207:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $207
80106dd1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106dd6:	e9 13 f3 ff ff       	jmp    801060ee <alltraps>

80106ddb <vector208>:
.globl vector208
vector208:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $208
80106ddd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106de2:	e9 07 f3 ff ff       	jmp    801060ee <alltraps>

80106de7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $209
80106de9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106dee:	e9 fb f2 ff ff       	jmp    801060ee <alltraps>

80106df3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $210
80106df5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106dfa:	e9 ef f2 ff ff       	jmp    801060ee <alltraps>

80106dff <vector211>:
.globl vector211
vector211:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $211
80106e01:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e06:	e9 e3 f2 ff ff       	jmp    801060ee <alltraps>

80106e0b <vector212>:
.globl vector212
vector212:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $212
80106e0d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e12:	e9 d7 f2 ff ff       	jmp    801060ee <alltraps>

80106e17 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $213
80106e19:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e1e:	e9 cb f2 ff ff       	jmp    801060ee <alltraps>

80106e23 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $214
80106e25:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e2a:	e9 bf f2 ff ff       	jmp    801060ee <alltraps>

80106e2f <vector215>:
.globl vector215
vector215:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $215
80106e31:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e36:	e9 b3 f2 ff ff       	jmp    801060ee <alltraps>

80106e3b <vector216>:
.globl vector216
vector216:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $216
80106e3d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e42:	e9 a7 f2 ff ff       	jmp    801060ee <alltraps>

80106e47 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $217
80106e49:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e4e:	e9 9b f2 ff ff       	jmp    801060ee <alltraps>

80106e53 <vector218>:
.globl vector218
vector218:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $218
80106e55:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e5a:	e9 8f f2 ff ff       	jmp    801060ee <alltraps>

80106e5f <vector219>:
.globl vector219
vector219:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $219
80106e61:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e66:	e9 83 f2 ff ff       	jmp    801060ee <alltraps>

80106e6b <vector220>:
.globl vector220
vector220:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $220
80106e6d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e72:	e9 77 f2 ff ff       	jmp    801060ee <alltraps>

80106e77 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $221
80106e79:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e7e:	e9 6b f2 ff ff       	jmp    801060ee <alltraps>

80106e83 <vector222>:
.globl vector222
vector222:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $222
80106e85:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e8a:	e9 5f f2 ff ff       	jmp    801060ee <alltraps>

80106e8f <vector223>:
.globl vector223
vector223:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $223
80106e91:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e96:	e9 53 f2 ff ff       	jmp    801060ee <alltraps>

80106e9b <vector224>:
.globl vector224
vector224:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $224
80106e9d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ea2:	e9 47 f2 ff ff       	jmp    801060ee <alltraps>

80106ea7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $225
80106ea9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106eae:	e9 3b f2 ff ff       	jmp    801060ee <alltraps>

80106eb3 <vector226>:
.globl vector226
vector226:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $226
80106eb5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106eba:	e9 2f f2 ff ff       	jmp    801060ee <alltraps>

80106ebf <vector227>:
.globl vector227
vector227:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $227
80106ec1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ec6:	e9 23 f2 ff ff       	jmp    801060ee <alltraps>

80106ecb <vector228>:
.globl vector228
vector228:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $228
80106ecd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106ed2:	e9 17 f2 ff ff       	jmp    801060ee <alltraps>

80106ed7 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $229
80106ed9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106ede:	e9 0b f2 ff ff       	jmp    801060ee <alltraps>

80106ee3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $230
80106ee5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106eea:	e9 ff f1 ff ff       	jmp    801060ee <alltraps>

80106eef <vector231>:
.globl vector231
vector231:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $231
80106ef1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ef6:	e9 f3 f1 ff ff       	jmp    801060ee <alltraps>

80106efb <vector232>:
.globl vector232
vector232:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $232
80106efd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f02:	e9 e7 f1 ff ff       	jmp    801060ee <alltraps>

80106f07 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $233
80106f09:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f0e:	e9 db f1 ff ff       	jmp    801060ee <alltraps>

80106f13 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $234
80106f15:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f1a:	e9 cf f1 ff ff       	jmp    801060ee <alltraps>

80106f1f <vector235>:
.globl vector235
vector235:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $235
80106f21:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f26:	e9 c3 f1 ff ff       	jmp    801060ee <alltraps>

80106f2b <vector236>:
.globl vector236
vector236:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $236
80106f2d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f32:	e9 b7 f1 ff ff       	jmp    801060ee <alltraps>

80106f37 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $237
80106f39:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f3e:	e9 ab f1 ff ff       	jmp    801060ee <alltraps>

80106f43 <vector238>:
.globl vector238
vector238:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $238
80106f45:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f4a:	e9 9f f1 ff ff       	jmp    801060ee <alltraps>

80106f4f <vector239>:
.globl vector239
vector239:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $239
80106f51:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f56:	e9 93 f1 ff ff       	jmp    801060ee <alltraps>

80106f5b <vector240>:
.globl vector240
vector240:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $240
80106f5d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f62:	e9 87 f1 ff ff       	jmp    801060ee <alltraps>

80106f67 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $241
80106f69:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f6e:	e9 7b f1 ff ff       	jmp    801060ee <alltraps>

80106f73 <vector242>:
.globl vector242
vector242:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $242
80106f75:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f7a:	e9 6f f1 ff ff       	jmp    801060ee <alltraps>

80106f7f <vector243>:
.globl vector243
vector243:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $243
80106f81:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f86:	e9 63 f1 ff ff       	jmp    801060ee <alltraps>

80106f8b <vector244>:
.globl vector244
vector244:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $244
80106f8d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f92:	e9 57 f1 ff ff       	jmp    801060ee <alltraps>

80106f97 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $245
80106f99:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f9e:	e9 4b f1 ff ff       	jmp    801060ee <alltraps>

80106fa3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $246
80106fa5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106faa:	e9 3f f1 ff ff       	jmp    801060ee <alltraps>

80106faf <vector247>:
.globl vector247
vector247:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $247
80106fb1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fb6:	e9 33 f1 ff ff       	jmp    801060ee <alltraps>

80106fbb <vector248>:
.globl vector248
vector248:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $248
80106fbd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106fc2:	e9 27 f1 ff ff       	jmp    801060ee <alltraps>

80106fc7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $249
80106fc9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106fce:	e9 1b f1 ff ff       	jmp    801060ee <alltraps>

80106fd3 <vector250>:
.globl vector250
vector250:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $250
80106fd5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106fda:	e9 0f f1 ff ff       	jmp    801060ee <alltraps>

80106fdf <vector251>:
.globl vector251
vector251:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $251
80106fe1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fe6:	e9 03 f1 ff ff       	jmp    801060ee <alltraps>

80106feb <vector252>:
.globl vector252
vector252:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $252
80106fed:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106ff2:	e9 f7 f0 ff ff       	jmp    801060ee <alltraps>

80106ff7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $253
80106ff9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106ffe:	e9 eb f0 ff ff       	jmp    801060ee <alltraps>

80107003 <vector254>:
.globl vector254
vector254:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $254
80107005:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010700a:	e9 df f0 ff ff       	jmp    801060ee <alltraps>

8010700f <vector255>:
.globl vector255
vector255:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $255
80107011:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107016:	e9 d3 f0 ff ff       	jmp    801060ee <alltraps>
8010701b:	66 90                	xchg   %ax,%ax
8010701d:	66 90                	xchg   %ax,%ax
8010701f:	90                   	nop

80107020 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107027:	c1 ea 16             	shr    $0x16,%edx
{
8010702a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010702b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010702e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107031:	8b 1f                	mov    (%edi),%ebx
80107033:	f6 c3 01             	test   $0x1,%bl
80107036:	74 28                	je     80107060 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107038:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010703e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107044:	89 f0                	mov    %esi,%eax
}
80107046:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107049:	c1 e8 0a             	shr    $0xa,%eax
8010704c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107051:	01 d8                	add    %ebx,%eax
}
80107053:	5b                   	pop    %ebx
80107054:	5e                   	pop    %esi
80107055:	5f                   	pop    %edi
80107056:	5d                   	pop    %ebp
80107057:	c3                   	ret    
80107058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107060:	85 c9                	test   %ecx,%ecx
80107062:	74 2c                	je     80107090 <walkpgdir+0x70>
80107064:	e8 47 be ff ff       	call   80102eb0 <kalloc>
80107069:	89 c3                	mov    %eax,%ebx
8010706b:	85 c0                	test   %eax,%eax
8010706d:	74 21                	je     80107090 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010706f:	83 ec 04             	sub    $0x4,%esp
80107072:	68 00 10 00 00       	push   $0x1000
80107077:	6a 00                	push   $0x0
80107079:	50                   	push   %eax
8010707a:	e8 71 de ff ff       	call   80104ef0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010707f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107085:	83 c4 10             	add    $0x10,%esp
80107088:	83 c8 07             	or     $0x7,%eax
8010708b:	89 07                	mov    %eax,(%edi)
8010708d:	eb b5                	jmp    80107044 <walkpgdir+0x24>
8010708f:	90                   	nop
}
80107090:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107093:	31 c0                	xor    %eax,%eax
}
80107095:	5b                   	pop    %ebx
80107096:	5e                   	pop    %esi
80107097:	5f                   	pop    %edi
80107098:	5d                   	pop    %ebp
80107099:	c3                   	ret    
8010709a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070a6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801070aa:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801070b0:	89 d6                	mov    %edx,%esi
{
801070b2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801070b3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801070b9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070bf:	8b 45 08             	mov    0x8(%ebp),%eax
801070c2:	29 f0                	sub    %esi,%eax
801070c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070c7:	eb 1f                	jmp    801070e8 <mappages+0x48>
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801070d0:	f6 00 01             	testb  $0x1,(%eax)
801070d3:	75 45                	jne    8010711a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801070d5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801070d8:	83 cb 01             	or     $0x1,%ebx
801070db:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801070dd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801070e0:	74 2e                	je     80107110 <mappages+0x70>
      break;
    a += PGSIZE;
801070e2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801070e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801070eb:	b9 01 00 00 00       	mov    $0x1,%ecx
801070f0:	89 f2                	mov    %esi,%edx
801070f2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801070f5:	89 f8                	mov    %edi,%eax
801070f7:	e8 24 ff ff ff       	call   80107020 <walkpgdir>
801070fc:	85 c0                	test   %eax,%eax
801070fe:	75 d0                	jne    801070d0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107100:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107108:	5b                   	pop    %ebx
80107109:	5e                   	pop    %esi
8010710a:	5f                   	pop    %edi
8010710b:	5d                   	pop    %ebp
8010710c:	c3                   	ret    
8010710d:	8d 76 00             	lea    0x0(%esi),%esi
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107113:	31 c0                	xor    %eax,%eax
}
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    
      panic("remap");
8010711a:	83 ec 0c             	sub    $0xc,%esp
8010711d:	68 08 82 10 80       	push   $0x80108208
80107122:	e8 69 92 ff ff       	call   80100390 <panic>
80107127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712e:	66 90                	xchg   %ax,%ax

80107130 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	89 c6                	mov    %eax,%esi
80107137:	53                   	push   %ebx
80107138:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010713a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107140:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107146:	83 ec 1c             	sub    $0x1c,%esp
80107149:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010714c:	39 da                	cmp    %ebx,%edx
8010714e:	73 5b                	jae    801071ab <deallocuvm.part.0+0x7b>
80107150:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107153:	89 d7                	mov    %edx,%edi
80107155:	eb 14                	jmp    8010716b <deallocuvm.part.0+0x3b>
80107157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715e:	66 90                	xchg   %ax,%ax
80107160:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107166:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107169:	76 40                	jbe    801071ab <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010716b:	31 c9                	xor    %ecx,%ecx
8010716d:	89 fa                	mov    %edi,%edx
8010716f:	89 f0                	mov    %esi,%eax
80107171:	e8 aa fe ff ff       	call   80107020 <walkpgdir>
80107176:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107178:	85 c0                	test   %eax,%eax
8010717a:	74 44                	je     801071c0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010717c:	8b 00                	mov    (%eax),%eax
8010717e:	a8 01                	test   $0x1,%al
80107180:	74 de                	je     80107160 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107182:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107187:	74 47                	je     801071d0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107189:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010718c:	05 00 00 00 80       	add    $0x80000000,%eax
80107191:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107197:	50                   	push   %eax
80107198:	e8 53 bb ff ff       	call   80102cf0 <kfree>
      *pte = 0;
8010719d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801071a3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801071a6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801071a9:	77 c0                	ja     8010716b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801071ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b1:	5b                   	pop    %ebx
801071b2:	5e                   	pop    %esi
801071b3:	5f                   	pop    %edi
801071b4:	5d                   	pop    %ebp
801071b5:	c3                   	ret    
801071b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071bd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801071c0:	89 fa                	mov    %edi,%edx
801071c2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801071c8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801071ce:	eb 96                	jmp    80107166 <deallocuvm.part.0+0x36>
        panic("kfree");
801071d0:	83 ec 0c             	sub    $0xc,%esp
801071d3:	68 c6 7b 10 80       	push   $0x80107bc6
801071d8:	e8 b3 91 ff ff       	call   80100390 <panic>
801071dd:	8d 76 00             	lea    0x0(%esi),%esi

801071e0 <seginit>:
{
801071e0:	f3 0f 1e fb          	endbr32 
801071e4:	55                   	push   %ebp
801071e5:	89 e5                	mov    %esp,%ebp
801071e7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801071ea:	e8 d1 cf ff ff       	call   801041c0 <cpuid>
  pd[0] = size-1;
801071ef:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071f4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801071fa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071fe:	c7 80 18 3d 11 80 ff 	movl   $0xffff,-0x7feec2e8(%eax)
80107205:	ff 00 00 
80107208:	c7 80 1c 3d 11 80 00 	movl   $0xcf9a00,-0x7feec2e4(%eax)
8010720f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107212:	c7 80 20 3d 11 80 ff 	movl   $0xffff,-0x7feec2e0(%eax)
80107219:	ff 00 00 
8010721c:	c7 80 24 3d 11 80 00 	movl   $0xcf9200,-0x7feec2dc(%eax)
80107223:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107226:	c7 80 28 3d 11 80 ff 	movl   $0xffff,-0x7feec2d8(%eax)
8010722d:	ff 00 00 
80107230:	c7 80 2c 3d 11 80 00 	movl   $0xcffa00,-0x7feec2d4(%eax)
80107237:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010723a:	c7 80 30 3d 11 80 ff 	movl   $0xffff,-0x7feec2d0(%eax)
80107241:	ff 00 00 
80107244:	c7 80 34 3d 11 80 00 	movl   $0xcff200,-0x7feec2cc(%eax)
8010724b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010724e:	05 10 3d 11 80       	add    $0x80113d10,%eax
  pd[1] = (uint)p;
80107253:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107257:	c1 e8 10             	shr    $0x10,%eax
8010725a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010725e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107261:	0f 01 10             	lgdtl  (%eax)
}
80107264:	c9                   	leave  
80107265:	c3                   	ret    
80107266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726d:	8d 76 00             	lea    0x0(%esi),%esi

80107270 <switchkvm>:
{
80107270:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107274:	a1 c4 69 11 80       	mov    0x801169c4,%eax
80107279:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010727e:	0f 22 d8             	mov    %eax,%cr3
}
80107281:	c3                   	ret    
80107282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107290 <switchuvm>:
{
80107290:	f3 0f 1e fb          	endbr32 
80107294:	55                   	push   %ebp
80107295:	89 e5                	mov    %esp,%ebp
80107297:	57                   	push   %edi
80107298:	56                   	push   %esi
80107299:	53                   	push   %ebx
8010729a:	83 ec 1c             	sub    $0x1c,%esp
8010729d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801072a0:	85 f6                	test   %esi,%esi
801072a2:	0f 84 cb 00 00 00    	je     80107373 <switchuvm+0xe3>
  if(p->kstack == 0)
801072a8:	8b 46 08             	mov    0x8(%esi),%eax
801072ab:	85 c0                	test   %eax,%eax
801072ad:	0f 84 da 00 00 00    	je     8010738d <switchuvm+0xfd>
  if(p->pgdir == 0)
801072b3:	8b 46 04             	mov    0x4(%esi),%eax
801072b6:	85 c0                	test   %eax,%eax
801072b8:	0f 84 c2 00 00 00    	je     80107380 <switchuvm+0xf0>
  pushcli();
801072be:	e8 1d da ff ff       	call   80104ce0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072c3:	e8 88 ce ff ff       	call   80104150 <mycpu>
801072c8:	89 c3                	mov    %eax,%ebx
801072ca:	e8 81 ce ff ff       	call   80104150 <mycpu>
801072cf:	89 c7                	mov    %eax,%edi
801072d1:	e8 7a ce ff ff       	call   80104150 <mycpu>
801072d6:	83 c7 08             	add    $0x8,%edi
801072d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072dc:	e8 6f ce ff ff       	call   80104150 <mycpu>
801072e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072e4:	ba 67 00 00 00       	mov    $0x67,%edx
801072e9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072f0:	83 c0 08             	add    $0x8,%eax
801072f3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072fa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072ff:	83 c1 08             	add    $0x8,%ecx
80107302:	c1 e8 18             	shr    $0x18,%eax
80107305:	c1 e9 10             	shr    $0x10,%ecx
80107308:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010730e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107314:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107319:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107320:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107325:	e8 26 ce ff ff       	call   80104150 <mycpu>
8010732a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107331:	e8 1a ce ff ff       	call   80104150 <mycpu>
80107336:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010733a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010733d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107343:	e8 08 ce ff ff       	call   80104150 <mycpu>
80107348:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010734b:	e8 00 ce ff ff       	call   80104150 <mycpu>
80107350:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107354:	b8 28 00 00 00       	mov    $0x28,%eax
80107359:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010735c:	8b 46 04             	mov    0x4(%esi),%eax
8010735f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107364:	0f 22 d8             	mov    %eax,%cr3
}
80107367:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010736a:	5b                   	pop    %ebx
8010736b:	5e                   	pop    %esi
8010736c:	5f                   	pop    %edi
8010736d:	5d                   	pop    %ebp
  popcli();
8010736e:	e9 bd d9 ff ff       	jmp    80104d30 <popcli>
    panic("switchuvm: no process");
80107373:	83 ec 0c             	sub    $0xc,%esp
80107376:	68 0e 82 10 80       	push   $0x8010820e
8010737b:	e8 10 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107380:	83 ec 0c             	sub    $0xc,%esp
80107383:	68 39 82 10 80       	push   $0x80108239
80107388:	e8 03 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010738d:	83 ec 0c             	sub    $0xc,%esp
80107390:	68 24 82 10 80       	push   $0x80108224
80107395:	e8 f6 8f ff ff       	call   80100390 <panic>
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073a0 <inituvm>:
{
801073a0:	f3 0f 1e fb          	endbr32 
801073a4:	55                   	push   %ebp
801073a5:	89 e5                	mov    %esp,%ebp
801073a7:	57                   	push   %edi
801073a8:	56                   	push   %esi
801073a9:	53                   	push   %ebx
801073aa:	83 ec 1c             	sub    $0x1c,%esp
801073ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801073b0:	8b 75 10             	mov    0x10(%ebp),%esi
801073b3:	8b 7d 08             	mov    0x8(%ebp),%edi
801073b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801073b9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073bf:	77 4b                	ja     8010740c <inituvm+0x6c>
  mem = kalloc();
801073c1:	e8 ea ba ff ff       	call   80102eb0 <kalloc>
  memset(mem, 0, PGSIZE);
801073c6:	83 ec 04             	sub    $0x4,%esp
801073c9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801073ce:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801073d0:	6a 00                	push   $0x0
801073d2:	50                   	push   %eax
801073d3:	e8 18 db ff ff       	call   80104ef0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801073d8:	58                   	pop    %eax
801073d9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073df:	5a                   	pop    %edx
801073e0:	6a 06                	push   $0x6
801073e2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073e7:	31 d2                	xor    %edx,%edx
801073e9:	50                   	push   %eax
801073ea:	89 f8                	mov    %edi,%eax
801073ec:	e8 af fc ff ff       	call   801070a0 <mappages>
  memmove(mem, init, sz);
801073f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073f4:	89 75 10             	mov    %esi,0x10(%ebp)
801073f7:	83 c4 10             	add    $0x10,%esp
801073fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801073fd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107403:	5b                   	pop    %ebx
80107404:	5e                   	pop    %esi
80107405:	5f                   	pop    %edi
80107406:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107407:	e9 84 db ff ff       	jmp    80104f90 <memmove>
    panic("inituvm: more than a page");
8010740c:	83 ec 0c             	sub    $0xc,%esp
8010740f:	68 4d 82 10 80       	push   $0x8010824d
80107414:	e8 77 8f ff ff       	call   80100390 <panic>
80107419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107420 <loaduvm>:
{
80107420:	f3 0f 1e fb          	endbr32 
80107424:	55                   	push   %ebp
80107425:	89 e5                	mov    %esp,%ebp
80107427:	57                   	push   %edi
80107428:	56                   	push   %esi
80107429:	53                   	push   %ebx
8010742a:	83 ec 1c             	sub    $0x1c,%esp
8010742d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107430:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107433:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107438:	0f 85 99 00 00 00    	jne    801074d7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010743e:	01 f0                	add    %esi,%eax
80107440:	89 f3                	mov    %esi,%ebx
80107442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107445:	8b 45 14             	mov    0x14(%ebp),%eax
80107448:	01 f0                	add    %esi,%eax
8010744a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010744d:	85 f6                	test   %esi,%esi
8010744f:	75 15                	jne    80107466 <loaduvm+0x46>
80107451:	eb 6d                	jmp    801074c0 <loaduvm+0xa0>
80107453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107457:	90                   	nop
80107458:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010745e:	89 f0                	mov    %esi,%eax
80107460:	29 d8                	sub    %ebx,%eax
80107462:	39 c6                	cmp    %eax,%esi
80107464:	76 5a                	jbe    801074c0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107466:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107469:	8b 45 08             	mov    0x8(%ebp),%eax
8010746c:	31 c9                	xor    %ecx,%ecx
8010746e:	29 da                	sub    %ebx,%edx
80107470:	e8 ab fb ff ff       	call   80107020 <walkpgdir>
80107475:	85 c0                	test   %eax,%eax
80107477:	74 51                	je     801074ca <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107479:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010747b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010747e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107483:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107488:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010748e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107491:	29 d9                	sub    %ebx,%ecx
80107493:	05 00 00 00 80       	add    $0x80000000,%eax
80107498:	57                   	push   %edi
80107499:	51                   	push   %ecx
8010749a:	50                   	push   %eax
8010749b:	ff 75 10             	pushl  0x10(%ebp)
8010749e:	e8 3d ae ff ff       	call   801022e0 <readi>
801074a3:	83 c4 10             	add    $0x10,%esp
801074a6:	39 f8                	cmp    %edi,%eax
801074a8:	74 ae                	je     80107458 <loaduvm+0x38>
}
801074aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074b2:	5b                   	pop    %ebx
801074b3:	5e                   	pop    %esi
801074b4:	5f                   	pop    %edi
801074b5:	5d                   	pop    %ebp
801074b6:	c3                   	ret    
801074b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074be:	66 90                	xchg   %ax,%ax
801074c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074c3:	31 c0                	xor    %eax,%eax
}
801074c5:	5b                   	pop    %ebx
801074c6:	5e                   	pop    %esi
801074c7:	5f                   	pop    %edi
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret    
      panic("loaduvm: address should exist");
801074ca:	83 ec 0c             	sub    $0xc,%esp
801074cd:	68 67 82 10 80       	push   $0x80108267
801074d2:	e8 b9 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801074d7:	83 ec 0c             	sub    $0xc,%esp
801074da:	68 08 83 10 80       	push   $0x80108308
801074df:	e8 ac 8e ff ff       	call   80100390 <panic>
801074e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074ef:	90                   	nop

801074f0 <allocuvm>:
{
801074f0:	f3 0f 1e fb          	endbr32 
801074f4:	55                   	push   %ebp
801074f5:	89 e5                	mov    %esp,%ebp
801074f7:	57                   	push   %edi
801074f8:	56                   	push   %esi
801074f9:	53                   	push   %ebx
801074fa:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801074fd:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107500:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107503:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107506:	85 c0                	test   %eax,%eax
80107508:	0f 88 b2 00 00 00    	js     801075c0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010750e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107511:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107514:	0f 82 96 00 00 00    	jb     801075b0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010751a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107520:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107526:	39 75 10             	cmp    %esi,0x10(%ebp)
80107529:	77 40                	ja     8010756b <allocuvm+0x7b>
8010752b:	e9 83 00 00 00       	jmp    801075b3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107530:	83 ec 04             	sub    $0x4,%esp
80107533:	68 00 10 00 00       	push   $0x1000
80107538:	6a 00                	push   $0x0
8010753a:	50                   	push   %eax
8010753b:	e8 b0 d9 ff ff       	call   80104ef0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107540:	58                   	pop    %eax
80107541:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107547:	5a                   	pop    %edx
80107548:	6a 06                	push   $0x6
8010754a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010754f:	89 f2                	mov    %esi,%edx
80107551:	50                   	push   %eax
80107552:	89 f8                	mov    %edi,%eax
80107554:	e8 47 fb ff ff       	call   801070a0 <mappages>
80107559:	83 c4 10             	add    $0x10,%esp
8010755c:	85 c0                	test   %eax,%eax
8010755e:	78 78                	js     801075d8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107560:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107566:	39 75 10             	cmp    %esi,0x10(%ebp)
80107569:	76 48                	jbe    801075b3 <allocuvm+0xc3>
    mem = kalloc();
8010756b:	e8 40 b9 ff ff       	call   80102eb0 <kalloc>
80107570:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107572:	85 c0                	test   %eax,%eax
80107574:	75 ba                	jne    80107530 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107576:	83 ec 0c             	sub    $0xc,%esp
80107579:	68 85 82 10 80       	push   $0x80108285
8010757e:	e8 cd 93 ff ff       	call   80100950 <cprintf>
  if(newsz >= oldsz)
80107583:	8b 45 0c             	mov    0xc(%ebp),%eax
80107586:	83 c4 10             	add    $0x10,%esp
80107589:	39 45 10             	cmp    %eax,0x10(%ebp)
8010758c:	74 32                	je     801075c0 <allocuvm+0xd0>
8010758e:	8b 55 10             	mov    0x10(%ebp),%edx
80107591:	89 c1                	mov    %eax,%ecx
80107593:	89 f8                	mov    %edi,%eax
80107595:	e8 96 fb ff ff       	call   80107130 <deallocuvm.part.0>
      return 0;
8010759a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075a7:	5b                   	pop    %ebx
801075a8:	5e                   	pop    %esi
801075a9:	5f                   	pop    %edi
801075aa:	5d                   	pop    %ebp
801075ab:	c3                   	ret    
801075ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801075b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801075b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075b9:	5b                   	pop    %ebx
801075ba:	5e                   	pop    %esi
801075bb:	5f                   	pop    %edi
801075bc:	5d                   	pop    %ebp
801075bd:	c3                   	ret    
801075be:	66 90                	xchg   %ax,%ax
    return 0;
801075c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075cd:	5b                   	pop    %ebx
801075ce:	5e                   	pop    %esi
801075cf:	5f                   	pop    %edi
801075d0:	5d                   	pop    %ebp
801075d1:	c3                   	ret    
801075d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801075d8:	83 ec 0c             	sub    $0xc,%esp
801075db:	68 9d 82 10 80       	push   $0x8010829d
801075e0:	e8 6b 93 ff ff       	call   80100950 <cprintf>
  if(newsz >= oldsz)
801075e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801075e8:	83 c4 10             	add    $0x10,%esp
801075eb:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ee:	74 0c                	je     801075fc <allocuvm+0x10c>
801075f0:	8b 55 10             	mov    0x10(%ebp),%edx
801075f3:	89 c1                	mov    %eax,%ecx
801075f5:	89 f8                	mov    %edi,%eax
801075f7:	e8 34 fb ff ff       	call   80107130 <deallocuvm.part.0>
      kfree(mem);
801075fc:	83 ec 0c             	sub    $0xc,%esp
801075ff:	53                   	push   %ebx
80107600:	e8 eb b6 ff ff       	call   80102cf0 <kfree>
      return 0;
80107605:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010760c:	83 c4 10             	add    $0x10,%esp
}
8010760f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107615:	5b                   	pop    %ebx
80107616:	5e                   	pop    %esi
80107617:	5f                   	pop    %edi
80107618:	5d                   	pop    %ebp
80107619:	c3                   	ret    
8010761a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107620 <deallocuvm>:
{
80107620:	f3 0f 1e fb          	endbr32 
80107624:	55                   	push   %ebp
80107625:	89 e5                	mov    %esp,%ebp
80107627:	8b 55 0c             	mov    0xc(%ebp),%edx
8010762a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010762d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107630:	39 d1                	cmp    %edx,%ecx
80107632:	73 0c                	jae    80107640 <deallocuvm+0x20>
}
80107634:	5d                   	pop    %ebp
80107635:	e9 f6 fa ff ff       	jmp    80107130 <deallocuvm.part.0>
8010763a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107640:	89 d0                	mov    %edx,%eax
80107642:	5d                   	pop    %ebp
80107643:	c3                   	ret    
80107644:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010764b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010764f:	90                   	nop

80107650 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107650:	f3 0f 1e fb          	endbr32 
80107654:	55                   	push   %ebp
80107655:	89 e5                	mov    %esp,%ebp
80107657:	57                   	push   %edi
80107658:	56                   	push   %esi
80107659:	53                   	push   %ebx
8010765a:	83 ec 0c             	sub    $0xc,%esp
8010765d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107660:	85 f6                	test   %esi,%esi
80107662:	74 55                	je     801076b9 <freevm+0x69>
  if(newsz >= oldsz)
80107664:	31 c9                	xor    %ecx,%ecx
80107666:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010766b:	89 f0                	mov    %esi,%eax
8010766d:	89 f3                	mov    %esi,%ebx
8010766f:	e8 bc fa ff ff       	call   80107130 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107674:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010767a:	eb 0b                	jmp    80107687 <freevm+0x37>
8010767c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107680:	83 c3 04             	add    $0x4,%ebx
80107683:	39 df                	cmp    %ebx,%edi
80107685:	74 23                	je     801076aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107687:	8b 03                	mov    (%ebx),%eax
80107689:	a8 01                	test   $0x1,%al
8010768b:	74 f3                	je     80107680 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010768d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107692:	83 ec 0c             	sub    $0xc,%esp
80107695:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107698:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010769d:	50                   	push   %eax
8010769e:	e8 4d b6 ff ff       	call   80102cf0 <kfree>
801076a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076a6:	39 df                	cmp    %ebx,%edi
801076a8:	75 dd                	jne    80107687 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801076aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801076ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076b0:	5b                   	pop    %ebx
801076b1:	5e                   	pop    %esi
801076b2:	5f                   	pop    %edi
801076b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801076b4:	e9 37 b6 ff ff       	jmp    80102cf0 <kfree>
    panic("freevm: no pgdir");
801076b9:	83 ec 0c             	sub    $0xc,%esp
801076bc:	68 b9 82 10 80       	push   $0x801082b9
801076c1:	e8 ca 8c ff ff       	call   80100390 <panic>
801076c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cd:	8d 76 00             	lea    0x0(%esi),%esi

801076d0 <setupkvm>:
{
801076d0:	f3 0f 1e fb          	endbr32 
801076d4:	55                   	push   %ebp
801076d5:	89 e5                	mov    %esp,%ebp
801076d7:	56                   	push   %esi
801076d8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801076d9:	e8 d2 b7 ff ff       	call   80102eb0 <kalloc>
801076de:	89 c6                	mov    %eax,%esi
801076e0:	85 c0                	test   %eax,%eax
801076e2:	74 42                	je     80107726 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801076e4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076e7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801076ec:	68 00 10 00 00       	push   $0x1000
801076f1:	6a 00                	push   $0x0
801076f3:	50                   	push   %eax
801076f4:	e8 f7 d7 ff ff       	call   80104ef0 <memset>
801076f9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801076fc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801076ff:	83 ec 08             	sub    $0x8,%esp
80107702:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107705:	ff 73 0c             	pushl  0xc(%ebx)
80107708:	8b 13                	mov    (%ebx),%edx
8010770a:	50                   	push   %eax
8010770b:	29 c1                	sub    %eax,%ecx
8010770d:	89 f0                	mov    %esi,%eax
8010770f:	e8 8c f9 ff ff       	call   801070a0 <mappages>
80107714:	83 c4 10             	add    $0x10,%esp
80107717:	85 c0                	test   %eax,%eax
80107719:	78 15                	js     80107730 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010771b:	83 c3 10             	add    $0x10,%ebx
8010771e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107724:	75 d6                	jne    801076fc <setupkvm+0x2c>
}
80107726:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107729:	89 f0                	mov    %esi,%eax
8010772b:	5b                   	pop    %ebx
8010772c:	5e                   	pop    %esi
8010772d:	5d                   	pop    %ebp
8010772e:	c3                   	ret    
8010772f:	90                   	nop
      freevm(pgdir);
80107730:	83 ec 0c             	sub    $0xc,%esp
80107733:	56                   	push   %esi
      return 0;
80107734:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107736:	e8 15 ff ff ff       	call   80107650 <freevm>
      return 0;
8010773b:	83 c4 10             	add    $0x10,%esp
}
8010773e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107741:	89 f0                	mov    %esi,%eax
80107743:	5b                   	pop    %ebx
80107744:	5e                   	pop    %esi
80107745:	5d                   	pop    %ebp
80107746:	c3                   	ret    
80107747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010774e:	66 90                	xchg   %ax,%ax

80107750 <kvmalloc>:
{
80107750:	f3 0f 1e fb          	endbr32 
80107754:	55                   	push   %ebp
80107755:	89 e5                	mov    %esp,%ebp
80107757:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010775a:	e8 71 ff ff ff       	call   801076d0 <setupkvm>
8010775f:	a3 c4 69 11 80       	mov    %eax,0x801169c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107764:	05 00 00 00 80       	add    $0x80000000,%eax
80107769:	0f 22 d8             	mov    %eax,%cr3
}
8010776c:	c9                   	leave  
8010776d:	c3                   	ret    
8010776e:	66 90                	xchg   %ax,%ax

80107770 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107770:	f3 0f 1e fb          	endbr32 
80107774:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107775:	31 c9                	xor    %ecx,%ecx
{
80107777:	89 e5                	mov    %esp,%ebp
80107779:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010777c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010777f:	8b 45 08             	mov    0x8(%ebp),%eax
80107782:	e8 99 f8 ff ff       	call   80107020 <walkpgdir>
  if(pte == 0)
80107787:	85 c0                	test   %eax,%eax
80107789:	74 05                	je     80107790 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010778b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010778e:	c9                   	leave  
8010778f:	c3                   	ret    
    panic("clearpteu");
80107790:	83 ec 0c             	sub    $0xc,%esp
80107793:	68 ca 82 10 80       	push   $0x801082ca
80107798:	e8 f3 8b ff ff       	call   80100390 <panic>
8010779d:	8d 76 00             	lea    0x0(%esi),%esi

801077a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801077a0:	f3 0f 1e fb          	endbr32 
801077a4:	55                   	push   %ebp
801077a5:	89 e5                	mov    %esp,%ebp
801077a7:	57                   	push   %edi
801077a8:	56                   	push   %esi
801077a9:	53                   	push   %ebx
801077aa:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801077ad:	e8 1e ff ff ff       	call   801076d0 <setupkvm>
801077b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077b5:	85 c0                	test   %eax,%eax
801077b7:	0f 84 9b 00 00 00    	je     80107858 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077c0:	85 c9                	test   %ecx,%ecx
801077c2:	0f 84 90 00 00 00    	je     80107858 <copyuvm+0xb8>
801077c8:	31 f6                	xor    %esi,%esi
801077ca:	eb 46                	jmp    80107812 <copyuvm+0x72>
801077cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801077d0:	83 ec 04             	sub    $0x4,%esp
801077d3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801077d9:	68 00 10 00 00       	push   $0x1000
801077de:	57                   	push   %edi
801077df:	50                   	push   %eax
801077e0:	e8 ab d7 ff ff       	call   80104f90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801077e5:	58                   	pop    %eax
801077e6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077ec:	5a                   	pop    %edx
801077ed:	ff 75 e4             	pushl  -0x1c(%ebp)
801077f0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077f5:	89 f2                	mov    %esi,%edx
801077f7:	50                   	push   %eax
801077f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077fb:	e8 a0 f8 ff ff       	call   801070a0 <mappages>
80107800:	83 c4 10             	add    $0x10,%esp
80107803:	85 c0                	test   %eax,%eax
80107805:	78 61                	js     80107868 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107807:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010780d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107810:	76 46                	jbe    80107858 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107812:	8b 45 08             	mov    0x8(%ebp),%eax
80107815:	31 c9                	xor    %ecx,%ecx
80107817:	89 f2                	mov    %esi,%edx
80107819:	e8 02 f8 ff ff       	call   80107020 <walkpgdir>
8010781e:	85 c0                	test   %eax,%eax
80107820:	74 61                	je     80107883 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107822:	8b 00                	mov    (%eax),%eax
80107824:	a8 01                	test   $0x1,%al
80107826:	74 4e                	je     80107876 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107828:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010782a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010782f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107832:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107838:	e8 73 b6 ff ff       	call   80102eb0 <kalloc>
8010783d:	89 c3                	mov    %eax,%ebx
8010783f:	85 c0                	test   %eax,%eax
80107841:	75 8d                	jne    801077d0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107843:	83 ec 0c             	sub    $0xc,%esp
80107846:	ff 75 e0             	pushl  -0x20(%ebp)
80107849:	e8 02 fe ff ff       	call   80107650 <freevm>
  return 0;
8010784e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107855:	83 c4 10             	add    $0x10,%esp
}
80107858:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010785b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010785e:	5b                   	pop    %ebx
8010785f:	5e                   	pop    %esi
80107860:	5f                   	pop    %edi
80107861:	5d                   	pop    %ebp
80107862:	c3                   	ret    
80107863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107867:	90                   	nop
      kfree(mem);
80107868:	83 ec 0c             	sub    $0xc,%esp
8010786b:	53                   	push   %ebx
8010786c:	e8 7f b4 ff ff       	call   80102cf0 <kfree>
      goto bad;
80107871:	83 c4 10             	add    $0x10,%esp
80107874:	eb cd                	jmp    80107843 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107876:	83 ec 0c             	sub    $0xc,%esp
80107879:	68 ee 82 10 80       	push   $0x801082ee
8010787e:	e8 0d 8b ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107883:	83 ec 0c             	sub    $0xc,%esp
80107886:	68 d4 82 10 80       	push   $0x801082d4
8010788b:	e8 00 8b ff ff       	call   80100390 <panic>

80107890 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107890:	f3 0f 1e fb          	endbr32 
80107894:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107895:	31 c9                	xor    %ecx,%ecx
{
80107897:	89 e5                	mov    %esp,%ebp
80107899:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010789c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010789f:	8b 45 08             	mov    0x8(%ebp),%eax
801078a2:	e8 79 f7 ff ff       	call   80107020 <walkpgdir>
  if((*pte & PTE_P) == 0)
801078a7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078a9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801078aa:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801078b1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078b4:	05 00 00 00 80       	add    $0x80000000,%eax
801078b9:	83 fa 05             	cmp    $0x5,%edx
801078bc:	ba 00 00 00 00       	mov    $0x0,%edx
801078c1:	0f 45 c2             	cmovne %edx,%eax
}
801078c4:	c3                   	ret    
801078c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801078d0:	f3 0f 1e fb          	endbr32 
801078d4:	55                   	push   %ebp
801078d5:	89 e5                	mov    %esp,%ebp
801078d7:	57                   	push   %edi
801078d8:	56                   	push   %esi
801078d9:	53                   	push   %ebx
801078da:	83 ec 0c             	sub    $0xc,%esp
801078dd:	8b 75 14             	mov    0x14(%ebp),%esi
801078e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801078e3:	85 f6                	test   %esi,%esi
801078e5:	75 3c                	jne    80107923 <copyout+0x53>
801078e7:	eb 67                	jmp    80107950 <copyout+0x80>
801078e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801078f0:	8b 55 0c             	mov    0xc(%ebp),%edx
801078f3:	89 fb                	mov    %edi,%ebx
801078f5:	29 d3                	sub    %edx,%ebx
801078f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801078fd:	39 f3                	cmp    %esi,%ebx
801078ff:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107902:	29 fa                	sub    %edi,%edx
80107904:	83 ec 04             	sub    $0x4,%esp
80107907:	01 c2                	add    %eax,%edx
80107909:	53                   	push   %ebx
8010790a:	ff 75 10             	pushl  0x10(%ebp)
8010790d:	52                   	push   %edx
8010790e:	e8 7d d6 ff ff       	call   80104f90 <memmove>
    len -= n;
    buf += n;
80107913:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107916:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010791c:	83 c4 10             	add    $0x10,%esp
8010791f:	29 de                	sub    %ebx,%esi
80107921:	74 2d                	je     80107950 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107923:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107925:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107928:	89 55 0c             	mov    %edx,0xc(%ebp)
8010792b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107931:	57                   	push   %edi
80107932:	ff 75 08             	pushl  0x8(%ebp)
80107935:	e8 56 ff ff ff       	call   80107890 <uva2ka>
    if(pa0 == 0)
8010793a:	83 c4 10             	add    $0x10,%esp
8010793d:	85 c0                	test   %eax,%eax
8010793f:	75 af                	jne    801078f0 <copyout+0x20>
  }
  return 0;
}
80107941:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107944:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107949:	5b                   	pop    %ebx
8010794a:	5e                   	pop    %esi
8010794b:	5f                   	pop    %edi
8010794c:	5d                   	pop    %ebp
8010794d:	c3                   	ret    
8010794e:	66 90                	xchg   %ax,%ax
80107950:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107953:	31 c0                	xor    %eax,%eax
}
80107955:	5b                   	pop    %ebx
80107956:	5e                   	pop    %esi
80107957:	5f                   	pop    %edi
80107958:	5d                   	pop    %ebp
80107959:	c3                   	ret    
