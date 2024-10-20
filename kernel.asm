
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
80100028:	bc e0 c5 10 80       	mov    $0x8010c5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 39 10 80       	mov    $0x80103900,%eax
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
80100048:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 a0 79 10 80       	push   $0x801079a0
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 41 4c 00 00       	call   80104ca0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 0c 11 80       	mov    $0x80110cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
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
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 79 10 80       	push   $0x801079a7
80100097:	50                   	push   %eax
80100098:	e8 c3 4a 00 00       	call   80104b60 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 0a 11 80    	cmp    $0x80110a80,%ebx
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
801000e3:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e8:	e8 33 4d 00 00       	call   80104e20 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 79 4d 00 00       	call   80104ee0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 4a 00 00       	call   80104ba0 <acquiresleep>
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
8010018c:	e8 af 29 00 00       	call   80102b40 <iderw>
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
801001a3:	68 ae 79 10 80       	push   $0x801079ae
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
801001c2:	e8 79 4a 00 00       	call   80104c40 <holdingsleep>
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
801001d8:	e9 63 29 00 00       	jmp    80102b40 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 79 10 80       	push   $0x801079bf
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
80100203:	e8 38 4a 00 00       	call   80104c40 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 e8 49 00 00       	call   80104c00 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 fc 4b 00 00       	call   80104e20 <acquire>
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
80100246:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 0d 11 80       	mov    0x80110d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 6b 4c 00 00       	jmp    80104ee0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 79 10 80       	push   $0x801079c6
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
801002a5:	e8 56 1e 00 00       	call   80102100 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801002b1:	e8 6a 4b 00 00       	call   80104e20 <acquire>
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
801002c6:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002cb:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 40 b5 10 80       	push   $0x8010b540
801002e0:	68 c0 0f 11 80       	push   $0x80110fc0
801002e5:	e8 f6 44 00 00       	call   801047e0 <sleep>
    while (input.r == input.w)
801002ea:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if (myproc()->killed)
801002fa:	e8 21 3f 00 00       	call   80104220 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 b5 10 80       	push   $0x8010b540
8010030e:	e8 cd 4b 00 00       	call   80104ee0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 04 1d 00 00       	call   80102020 <ilock>
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
80100333:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 0f 11 80 	movsbl -0x7feef0c0(%edx),%ecx
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
80100360:	68 40 b5 10 80       	push   $0x8010b540
80100365:	e8 76 4b 00 00       	call   80104ee0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ad 1c 00 00       	call   80102020 <ilock>
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
80100386:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
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
8010039d:	c7 05 74 b5 10 80 00 	movl   $0x0,0x8010b574
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ae 2d 00 00       	call   80103160 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 79 10 80       	push   $0x801079cd
801003bb:	e8 90 05 00 00       	call   80100950 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 87 05 00 00       	call   80100950 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 77 83 10 80 	movl   $0x80108377,(%esp)
801003d0:	e8 7b 05 00 00       	call   80100950 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 df 48 00 00       	call   80104cc0 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 79 10 80       	push   $0x801079e1
801003f1:	e8 5a 05 00 00       	call   80100950 <cprintf>
  for (i = 0; i < 10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 78 b5 10 80 01 	movl   $0x1,0x8010b578
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
8010042a:	e8 71 61 00 00       	call   801065a0 <uartputc>
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
8010055b:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
80100560:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
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
80100585:	e8 16 60 00 00       	call   801065a0 <uartputc>
    uartputc(' ');
8010058a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100591:	e8 0a 60 00 00       	call   801065a0 <uartputc>
    uartputc('\b');
80100596:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010059d:	e8 fe 5f 00 00       	call   801065a0 <uartputc>
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
801005ca:	e8 01 4a 00 00       	call   80104fd0 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
801005cf:	b8 80 07 00 00       	mov    $0x780,%eax
801005d4:	83 c4 0c             	add    $0xc,%esp
801005d7:	29 d8                	sub    %ebx,%eax
801005d9:	01 c0                	add    %eax,%eax
801005db:	50                   	push   %eax
801005dc:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005e3:	6a 00                	push   $0x0
801005e5:	50                   	push   %eax
801005e6:	e8 45 49 00 00       	call   80104f30 <memset>
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
80100670:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100675:	89 d9                	mov    %ebx,%ecx
80100677:	01 d8                	add    %ebx,%eax
80100679:	2b 05 cc 0f 11 80    	sub    0x80110fcc,%eax
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
801006b0:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801006b5:	8d 7b ff             	lea    -0x1(%ebx),%edi
801006b8:	89 f9                	mov    %edi,%ecx
801006ba:	01 d8                	add    %ebx,%eax
801006bc:	2b 05 cc 0f 11 80    	sub    0x80110fcc,%eax
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
801006dd:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801006e2:	01 d8                	add    %ebx,%eax
801006e4:	2b 05 cc 0f 11 80    	sub    0x80110fcc,%eax
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
80100708:	8b 0d c8 0f 11 80    	mov    0x80110fc8,%ecx
    while (pos % 80 != 2)
8010070e:	ba 67 66 66 66       	mov    $0x66666667,%edx
    pos += input.e - input.pointer;
80100713:	01 d9                	add    %ebx,%ecx
80100715:	2b 0d cc 0f 11 80    	sub    0x80110fcc,%ecx
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
801007cf:	a1 c4 0f 11 80       	mov    0x80110fc4,%eax
801007d4:	8b 15 c8 0f 11 80    	mov    0x80110fc8,%edx
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
801007f8:	0f b6 80 40 0f 11 80 	movzbl -0x7feef0c0(%eax),%eax
801007ff:	80 cc 07             	or     $0x7,%ah
80100802:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100809:	80 
    for (int i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
8010080a:	a1 c4 0f 11 80       	mov    0x80110fc4,%eax
      pos++;
8010080f:	83 c3 01             	add    $0x1,%ebx
    for (int i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
80100812:	8b 15 c8 0f 11 80    	mov    0x80110fc8,%edx
80100818:	29 c2                	sub    %eax,%edx
8010081a:	83 e2 7f             	and    $0x7f,%edx
8010081d:	39 d1                	cmp    %edx,%ecx
8010081f:	72 cf                	jb     801007f0 <consputc.part.0+0x3e0>
80100821:	89 d9                	mov    %ebx,%ecx
80100823:	e9 ef fc ff ff       	jmp    80100517 <consputc.part.0+0x107>
    panic("pos under/overflow");
80100828:	83 ec 0c             	sub    $0xc,%esp
8010082b:	68 e5 79 10 80       	push   $0x801079e5
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
80100869:	0f b6 92 8c 7a 10 80 	movzbl -0x7fef8574(%edx),%edx
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
801008a3:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
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
801008f3:	e8 08 18 00 00       	call   80102100 <iunlock>
  acquire(&cons.lock);
801008f8:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801008ff:	e8 1c 45 00 00       	call   80104e20 <acquire>
  for (i = 0; i < n; i++)
80100904:	83 c4 10             	add    $0x10,%esp
80100907:	85 db                	test   %ebx,%ebx
80100909:	7e 24                	jle    8010092f <consolewrite+0x4f>
8010090b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010090e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if (panicked)
80100911:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
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
80100932:	68 40 b5 10 80       	push   $0x8010b540
80100937:	e8 a4 45 00 00       	call   80104ee0 <release>
  ilock(ip);
8010093c:	58                   	pop    %eax
8010093d:	ff 75 08             	pushl  0x8(%ebp)
80100940:	e8 db 16 00 00       	call   80102020 <ilock>

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
8010095d:	a1 74 b5 10 80       	mov    0x8010b574,%eax
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
8010098c:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
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
80100a1d:	bb f8 79 10 80       	mov    $0x801079f8,%ebx
      for (; *s; s++)
80100a22:	b8 28 00 00 00       	mov    $0x28,%eax
  if (panicked)
80100a27:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
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
80100a58:	68 40 b5 10 80       	push   $0x8010b540
80100a5d:	e8 be 43 00 00       	call   80104e20 <acquire>
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
80100a80:	8b 3d 78 b5 10 80    	mov    0x8010b578,%edi
80100a86:	85 ff                	test   %edi,%edi
80100a88:	0f 84 12 ff ff ff    	je     801009a0 <cprintf+0x50>
80100a8e:	fa                   	cli    
    for (;;)
80100a8f:	eb fe                	jmp    80100a8f <cprintf+0x13f>
80100a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (panicked)
80100a98:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100a9e:	85 c9                	test   %ecx,%ecx
80100aa0:	74 06                	je     80100aa8 <cprintf+0x158>
80100aa2:	fa                   	cli    
    for (;;)
80100aa3:	eb fe                	jmp    80100aa3 <cprintf+0x153>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	b8 25 00 00 00       	mov    $0x25,%eax
80100aad:	e8 5e f9 ff ff       	call   80100410 <consputc.part.0>
  if (panicked)
80100ab2:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80100ab8:	85 d2                	test   %edx,%edx
80100aba:	74 2c                	je     80100ae8 <cprintf+0x198>
80100abc:	fa                   	cli    
    for (;;)
80100abd:	eb fe                	jmp    80100abd <cprintf+0x16d>
80100abf:	90                   	nop
    release(&cons.lock);
80100ac0:	83 ec 0c             	sub    $0xc,%esp
80100ac3:	68 40 b5 10 80       	push   $0x8010b540
80100ac8:	e8 13 44 00 00       	call   80104ee0 <release>
80100acd:	83 c4 10             	add    $0x10,%esp
}
80100ad0:	e9 ee fe ff ff       	jmp    801009c3 <cprintf+0x73>
    panic("null fmt");
80100ad5:	83 ec 0c             	sub    $0xc,%esp
80100ad8:	68 ff 79 10 80       	push   $0x801079ff
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
80100b05:	8b 15 c8 0f 11 80    	mov    0x80110fc8,%edx
{
80100b0b:	89 e5                	mov    %esp,%ebp
80100b0d:	56                   	push   %esi
80100b0e:	53                   	push   %ebx
  for (int i = input.e; i > input.pointer; i--)
80100b0f:	8b 1d cc 0f 11 80    	mov    0x80110fcc,%ebx
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
80100b3a:	0f b6 89 40 0f 11 80 	movzbl -0x7feef0c0(%ecx),%ecx
80100b41:	c1 ee 19             	shr    $0x19,%esi
80100b44:	01 f0                	add    %esi,%eax
80100b46:	83 e0 7f             	and    $0x7f,%eax
80100b49:	29 f0                	sub    %esi,%eax
80100b4b:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
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
80100b65:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
80100b6a:	8d 50 ff             	lea    -0x1(%eax),%edx
{
80100b6d:	89 e5                	mov    %esp,%ebp
80100b6f:	56                   	push   %esi
80100b70:	53                   	push   %ebx
  for (int i = input.pointer - 1; i < input.e; i++)
80100b71:	8b 1d c8 0f 11 80    	mov    0x80110fc8,%ebx
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
80100b9a:	0f b6 89 40 0f 11 80 	movzbl -0x7feef0c0(%ecx),%ecx
80100ba1:	c1 ee 19             	shr    $0x19,%esi
80100ba4:	01 f0                	add    %esi,%eax
80100ba6:	83 e0 7f             	and    $0x7f,%eax
80100ba9:	29 f0                	sub    %esi,%eax
80100bab:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
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
80100bcd:	8b 15 c4 0f 11 80    	mov    0x80110fc4,%edx
80100bd3:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
  if (cmd_buffer.s != CMD_BUF_SIZE)
80100bd8:	8b 3d 6c 15 11 80    	mov    0x8011156c,%edi
80100bde:	8b 1d 64 15 11 80    	mov    0x80111564,%ebx
80100be4:	29 d0                	sub    %edx,%eax
80100be6:	83 e0 7f             	and    $0x7f,%eax
80100be9:	83 ff 0a             	cmp    $0xa,%edi
80100bec:	0f 84 86 00 00 00    	je     80100c78 <recordCommand+0xb8>
    for (i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
80100bf2:	85 c0                	test   %eax,%eax
80100bf4:	0f 84 ee 00 00 00    	je     80100ce8 <recordCommand+0x128>
80100bfa:	89 d9                	mov    %ebx,%ecx
80100bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100bff:	81 c2 40 0f 11 80    	add    $0x80110f40,%edx
80100c05:	c1 e1 07             	shl    $0x7,%ecx
80100c08:	8d 34 02             	lea    (%edx,%eax,1),%esi
80100c0b:	81 c1 60 10 11 80    	add    $0x80111060,%ecx
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
80100c33:	89 3d 6c 15 11 80    	mov    %edi,0x8011156c
    cmd_buffer.buf[cmd_buffer.w][i] = END_OF_ARRAY;
80100c39:	c6 84 10 60 10 11 80 	movb   $0x0,-0x7feeefa0(%eax,%edx,1)
80100c40:	00 
  cmd_buffer.w++;
80100c41:	83 c3 01             	add    $0x1,%ebx
  cmd_buffer.w %= 10;
80100c44:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  cmd_buffer.movement = 0;
80100c49:	c7 05 70 15 11 80 00 	movl   $0x0,0x80111570
80100c50:	00 00 00 
  cmd_buffer.w %= 10;
80100c53:	89 d8                	mov    %ebx,%eax
80100c55:	f7 e2                	mul    %edx
80100c57:	c1 ea 03             	shr    $0x3,%edx
80100c5a:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100c5d:	01 c0                	add    %eax,%eax
80100c5f:	29 c3                	sub    %eax,%ebx
80100c61:	89 1d 64 15 11 80    	mov    %ebx,0x80111564
  cmd_buffer.pointer = cmd_buffer.w;
80100c67:	89 1d 68 15 11 80    	mov    %ebx,0x80111568
}
80100c6d:	83 c4 04             	add    $0x4,%esp
80100c70:	5b                   	pop    %ebx
80100c71:	5e                   	pop    %esi
80100c72:	5f                   	pop    %edi
80100c73:	5d                   	pop    %ebp
80100c74:	c3                   	ret    
80100c75:	8d 76 00             	lea    0x0(%esi),%esi
    for (i = 0; i < (input.e - input.w) % INPUT_BUF; i++)
80100c78:	8b 3d 60 15 11 80    	mov    0x80111560,%edi
80100c7e:	85 c0                	test   %eax,%eax
80100c80:	74 31                	je     80100cb3 <recordCommand+0xf3>
80100c82:	89 f9                	mov    %edi,%ecx
80100c84:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100c87:	81 c2 40 0f 11 80    	add    $0x80110f40,%edx
80100c8d:	c1 e1 07             	shl    $0x7,%ecx
80100c90:	8d 34 02             	lea    (%edx,%eax,1),%esi
80100c93:	81 c1 60 10 11 80    	add    $0x80111060,%ecx
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
80100cbb:	c6 84 10 60 10 11 80 	movb   $0x0,-0x7feeefa0(%eax,%edx,1)
80100cc2:	00 
    cmd_buffer.r %= 10;
80100cc3:	89 f8                	mov    %edi,%eax
80100cc5:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100cca:	f7 e2                	mul    %edx
80100ccc:	c1 ea 03             	shr    $0x3,%edx
80100ccf:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100cd2:	01 c0                	add    %eax,%eax
80100cd4:	29 c7                	sub    %eax,%edi
80100cd6:	89 3d 60 15 11 80    	mov    %edi,0x80111560
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
80100cf4:	8b 15 cc 0f 11 80    	mov    0x80110fcc,%edx
80100cfa:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
{
80100cff:	55                   	push   %ebp
80100d00:	89 e5                	mov    %esp,%ebp
80100d02:	57                   	push   %edi
    input.pointer++;
80100d03:	89 d7                	mov    %edx,%edi
{
80100d05:	56                   	push   %esi
    input.buf[(input.w + i) % INPUT_BUF] = cmd_buffer.buf[cmd_buffer.pointer][i];
80100d06:	8b 35 c4 0f 11 80    	mov    0x80110fc4,%esi
    input.pointer++;
80100d0c:	29 c7                	sub    %eax,%edi
{
80100d0e:	53                   	push   %ebx
    if (cmd_buffer.buf[cmd_buffer.pointer][i] == END_OF_ARRAY)
80100d0f:	8b 1d 68 15 11 80    	mov    0x80111568,%ebx
    input.buf[(input.w + i) % INPUT_BUF] = cmd_buffer.buf[cmd_buffer.pointer][i];
80100d15:	29 c6                	sub    %eax,%esi
    if (cmd_buffer.buf[cmd_buffer.pointer][i] == END_OF_ARRAY)
80100d17:	c1 e3 07             	shl    $0x7,%ebx
80100d1a:	0f b6 8b 60 10 11 80 	movzbl -0x7feeefa0(%ebx),%ecx
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
80100d39:	88 8a 40 0f 11 80    	mov    %cl,-0x7feef0c0(%edx)
    if (cmd_buffer.buf[cmd_buffer.pointer][i] == END_OF_ARRAY)
80100d3f:	0f b6 8c 03 60 10 11 	movzbl -0x7feeefa0(%ebx,%eax,1),%ecx
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
80100d56:	89 15 cc 0f 11 80    	mov    %edx,0x80110fcc
}
80100d5c:	5f                   	pop    %edi
      input.e %= INPUT_BUF;
80100d5d:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
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
  int c, doprocdump = 0;
80100d7a:	31 db                	xor    %ebx,%ebx
{
80100d7c:	83 ec 28             	sub    $0x28,%esp
80100d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100d82:	68 40 b5 10 80       	push   $0x8010b540
{
80100d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
  acquire(&cons.lock);
80100d8a:	e8 91 40 00 00       	call   80104e20 <acquire>
  while ((c = getc()) >= 0)
80100d8f:	83 c4 10             	add    $0x10,%esp
80100d92:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d95:	ff d0                	call   *%eax
80100d97:	89 c6                	mov    %eax,%esi
80100d99:	85 c0                	test   %eax,%eax
80100d9b:	0f 88 1b 04 00 00    	js     801011bc <consoleintr+0x44c>
    switch (c)
80100da1:	83 fe 7f             	cmp    $0x7f,%esi
80100da4:	0f 84 6b 01 00 00    	je     80100f15 <consoleintr+0x1a5>
80100daa:	7f 1b                	jg     80100dc7 <consoleintr+0x57>
80100dac:	8d 46 fa             	lea    -0x6(%esi),%eax
80100daf:	83 f8 0f             	cmp    $0xf,%eax
80100db2:	0f 87 93 01 00 00    	ja     80100f4b <consoleintr+0x1db>
80100db8:	3e ff 24 85 4c 7a 10 	notrack jmp *-0x7fef85b4(,%eax,4)
80100dbf:	80 
80100dc0:	bb 01 00 00 00       	mov    $0x1,%ebx
80100dc5:	eb cb                	jmp    80100d92 <consoleintr+0x22>
80100dc7:	81 fe e4 00 00 00    	cmp    $0xe4,%esi
80100dcd:	0f 84 0d 03 00 00    	je     801010e0 <consoleintr+0x370>
80100dd3:	7e 3b                	jle    80100e10 <consoleintr+0xa0>
80100dd5:	81 fe e5 00 00 00    	cmp    $0xe5,%esi
80100ddb:	0f 85 72 01 00 00    	jne    80100f53 <consoleintr+0x1e3>
      if (input.pointer != input.e)
80100de1:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
80100de6:	3b 05 c8 0f 11 80    	cmp    0x80110fc8,%eax
80100dec:	74 a4                	je     80100d92 <consoleintr+0x22>
        input.pointer++;
80100dee:	83 c0 01             	add    $0x1,%eax
80100df1:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
  if (panicked)
80100df6:	a1 78 b5 10 80       	mov    0x8010b578,%eax
80100dfb:	85 c0                	test   %eax,%eax
80100dfd:	0f 84 32 03 00 00    	je     80101135 <consoleintr+0x3c5>
80100e03:	fa                   	cli    
    for (;;)
80100e04:	eb fe                	jmp    80100e04 <consoleintr+0x94>
80100e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e0d:	8d 76 00             	lea    0x0(%esi),%esi
    switch (c)
80100e10:	81 fe e2 00 00 00    	cmp    $0xe2,%esi
80100e16:	0f 84 44 02 00 00    	je     80101060 <consoleintr+0x2f0>
80100e1c:	81 fe e3 00 00 00    	cmp    $0xe3,%esi
80100e22:	0f 85 2b 01 00 00    	jne    80100f53 <consoleintr+0x1e3>
      if (cmd_buffer.movement != 0)
80100e28:	a1 70 15 11 80       	mov    0x80111570,%eax
80100e2d:	85 c0                	test   %eax,%eax
80100e2f:	0f 84 5d ff ff ff    	je     80100d92 <consoleintr+0x22>
        input.e = input.w;
80100e35:	8b 15 c4 0f 11 80    	mov    0x80110fc4,%edx
80100e3b:	8b 35 78 b5 10 80    	mov    0x8010b578,%esi
80100e41:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        input.pointer = input.w;
80100e47:	89 15 cc 0f 11 80    	mov    %edx,0x80110fcc
        if (CAN_ARROW_DOWN && cmd_buffer.s > 0)
80100e4d:	8d 50 ff             	lea    -0x1(%eax),%edx
80100e50:	83 f8 01             	cmp    $0x1,%eax
80100e53:	76 0e                	jbe    80100e63 <consoleintr+0xf3>
80100e55:	8b 3d 6c 15 11 80    	mov    0x8011156c,%edi
80100e5b:	85 ff                	test   %edi,%edi
80100e5d:	0f 85 44 04 00 00    	jne    801012a7 <consoleintr+0x537>
            cmd_buffer.movement--;
80100e63:	89 15 70 15 11 80    	mov    %edx,0x80111570
            cmd_buffer.pointer = 1;
80100e69:	c7 05 68 15 11 80 01 	movl   $0x1,0x80111568
80100e70:	00 00 00 
  if (panicked)
80100e73:	85 f6                	test   %esi,%esi
80100e75:	0f 84 32 03 00 00    	je     801011ad <consoleintr+0x43d>
80100e7b:	fa                   	cli    
    for (;;)
80100e7c:	eb fe                	jmp    80100e7c <consoleintr+0x10c>
  if (panicked)
80100e7e:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100e84:	85 c9                	test   %ecx,%ecx
80100e86:	0f 84 7c 02 00 00    	je     80101108 <consoleintr+0x398>
80100e8c:	fa                   	cli    
    for (;;)
80100e8d:	eb fe                	jmp    80100e8d <consoleintr+0x11d>
      capturing = 1; // Start capturing
80100e8f:	c7 05 20 b5 10 80 01 	movl   $0x1,0x8010b520
80100e96:	00 00 00 
      cprintf("Capturing input... (type your input)\n");
80100e99:	83 ec 0c             	sub    $0xc,%esp
80100e9c:	68 24 7a 10 80       	push   $0x80107a24
      input_index = 0; // Reset index
80100ea1:	c7 05 24 b5 10 80 00 	movl   $0x0,0x8010b524
80100ea8:	00 00 00 
      cprintf("Capturing input... (type your input)\n");
80100eab:	e8 a0 fa ff ff       	call   80100950 <cprintf>
      break;
80100eb0:	83 c4 10             	add    $0x10,%esp
80100eb3:	e9 da fe ff ff       	jmp    80100d92 <consoleintr+0x22>
      capturing = 0; // Stop capturing
80100eb8:	c7 05 20 b5 10 80 00 	movl   $0x0,0x8010b520
80100ebf:	00 00 00 
      cprintf("\nPasted input: ");
80100ec2:	83 ec 0c             	sub    $0xc,%esp
      for (int i = 0; i < input_index; i++) {
80100ec5:	31 f6                	xor    %esi,%esi
      cprintf("\nPasted input: ");
80100ec7:	68 08 7a 10 80       	push   $0x80107a08
80100ecc:	e8 7f fa ff ff       	call   80100950 <cprintf>
      for (int i = 0; i < input_index; i++) {
80100ed1:	a1 24 b5 10 80       	mov    0x8010b524,%eax
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	85 c0                	test   %eax,%eax
80100edb:	7e 23                	jle    80100f00 <consoleintr+0x190>
          cprintf("%c", input_buffer[i]); // Print captured input
80100edd:	0f be 86 e0 0f 11 80 	movsbl -0x7feef020(%esi),%eax
80100ee4:	83 ec 08             	sub    $0x8,%esp
      for (int i = 0; i < input_index; i++) {
80100ee7:	83 c6 01             	add    $0x1,%esi
          cprintf("%c", input_buffer[i]); // Print captured input
80100eea:	50                   	push   %eax
80100eeb:	68 18 7a 10 80       	push   $0x80107a18
80100ef0:	e8 5b fa ff ff       	call   80100950 <cprintf>
      for (int i = 0; i < input_index; i++) {
80100ef5:	83 c4 10             	add    $0x10,%esp
80100ef8:	39 35 24 b5 10 80    	cmp    %esi,0x8010b524
80100efe:	7f dd                	jg     80100edd <consoleintr+0x16d>
      cprintf("\n");
80100f00:	83 ec 0c             	sub    $0xc,%esp
80100f03:	68 77 83 10 80       	push   $0x80108377
80100f08:	e8 43 fa ff ff       	call   80100950 <cprintf>
    break;
80100f0d:	83 c4 10             	add    $0x10,%esp
80100f10:	e9 7d fe ff ff       	jmp    80100d92 <consoleintr+0x22>
      if (input.pointer != input.w)
80100f15:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
80100f1a:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100f20:	0f 84 6c fe ff ff    	je     80100d92 <consoleintr+0x22>
        if (input.e != input.pointer)
80100f26:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100f2c:	8b 35 c8 0f 11 80    	mov    0x80110fc8,%esi
80100f32:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100f35:	39 f0                	cmp    %esi,%eax
80100f37:	0f 85 07 02 00 00    	jne    80101144 <consoleintr+0x3d4>
  if (panicked)
80100f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f40:	85 c0                	test   %eax,%eax
80100f42:	0f 84 94 02 00 00    	je     801011dc <consoleintr+0x46c>
80100f48:	fa                   	cli    
    for (;;)
80100f49:	eb fe                	jmp    80100f49 <consoleintr+0x1d9>
      if (c != 0 && input.e - input.r < INPUT_BUF)
80100f4b:	85 f6                	test   %esi,%esi
80100f4d:	0f 84 3f fe ff ff    	je     80100d92 <consoleintr+0x22>
80100f53:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100f58:	89 c2                	mov    %eax,%edx
80100f5a:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
80100f60:	83 fa 7f             	cmp    $0x7f,%edx
80100f63:	0f 87 29 fe ff ff    	ja     80100d92 <consoleintr+0x22>
          if (capturing) {
80100f69:	8b 0d 20 b5 10 80    	mov    0x8010b520,%ecx
80100f6f:	85 c9                	test   %ecx,%ecx
80100f71:	74 3a                	je     80100fad <consoleintr+0x23d>
          if (input_index < MAX_INPUT_SIZE - 1) { // Avoid overflow
80100f73:	a1 24 b5 10 80       	mov    0x8010b524,%eax
80100f78:	83 f8 62             	cmp    $0x62,%eax
80100f7b:	7f 11                	jg     80100f8e <consoleintr+0x21e>
              input_buffer[input_index++] = c; // Store character
80100f7d:	8d 50 01             	lea    0x1(%eax),%edx
80100f80:	89 f1                	mov    %esi,%ecx
80100f82:	89 15 24 b5 10 80    	mov    %edx,0x8010b524
80100f88:	88 88 e0 0f 11 80    	mov    %cl,-0x7feef020(%eax)
          if (c != '\n') { // Don't echo newline
80100f8e:	83 fe 0a             	cmp    $0xa,%esi
80100f91:	0f 84 e9 02 00 00    	je     80101280 <consoleintr+0x510>
              cprintf("%c", c); // Echo back the character
80100f97:	83 ec 08             	sub    $0x8,%esp
80100f9a:	56                   	push   %esi
80100f9b:	68 18 7a 10 80       	push   $0x80107a18
80100fa0:	e8 ab f9 ff ff       	call   80100950 <cprintf>
80100fa5:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100faa:	83 c4 10             	add    $0x10,%esp
        c = (c == '\r') ? END_OF_LINE : c;
80100fad:	83 fe 0d             	cmp    $0xd,%esi
80100fb0:	0f 84 79 02 00 00    	je     8010122f <consoleintr+0x4bf>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
80100fb6:	83 fe 0a             	cmp    $0xa,%esi
80100fb9:	0f 94 c1             	sete   %cl
80100fbc:	83 fe 04             	cmp    $0x4,%esi
80100fbf:	0f 94 c2             	sete   %dl
80100fc2:	08 d1                	or     %dl,%cl
80100fc4:	88 4d e4             	mov    %cl,-0x1c(%ebp)
80100fc7:	0f 85 6b 02 00 00    	jne    80101238 <consoleintr+0x4c8>
80100fcd:	8b 0d c0 0f 11 80    	mov    0x80110fc0,%ecx
80100fd3:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
80100fd9:	39 c2                	cmp    %eax,%edx
80100fdb:	0f 84 57 02 00 00    	je     80101238 <consoleintr+0x4c8>
        if (input.e != input.pointer)
80100fe1:	8b 3d cc 0f 11 80    	mov    0x80110fcc,%edi
80100fe7:	89 c2                	mov    %eax,%edx
80100fe9:	89 7d dc             	mov    %edi,-0x24(%ebp)
80100fec:	39 c7                	cmp    %eax,%edi
80100fee:	0f 85 03 02 00 00    	jne    801011f7 <consoleintr+0x487>
        input.buf[input.pointer++ % INPUT_BUF] = c;
80100ff4:	8d 48 01             	lea    0x1(%eax),%ecx
80100ff7:	83 e0 7f             	and    $0x7f,%eax
        input.e++;
80100ffa:	83 c2 01             	add    $0x1,%edx
        input.buf[input.pointer++ % INPUT_BUF] = c;
80100ffd:	89 0d cc 0f 11 80    	mov    %ecx,0x80110fcc
80101003:	89 f1                	mov    %esi,%ecx
80101005:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
  if (panicked)
8010100b:	a1 78 b5 10 80       	mov    0x8010b578,%eax
        input.e++;
80101010:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
  if (panicked)
80101016:	85 c0                	test   %eax,%eax
80101018:	0f 85 5c 02 00 00    	jne    8010127a <consoleintr+0x50a>
8010101e:	89 f0                	mov    %esi,%eax
80101020:	e8 eb f3 ff ff       	call   80100410 <consputc.part.0>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
80101025:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
80101029:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010102e:	75 14                	jne    80101044 <consoleintr+0x2d4>
80101030:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
80101035:	83 e8 80             	sub    $0xffffff80,%eax
80101038:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
8010103e:	0f 85 4e fd ff ff    	jne    80100d92 <consoleintr+0x22>
          wakeup(&input.r);
80101044:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101047:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
8010104c:	68 c0 0f 11 80       	push   $0x80110fc0
80101051:	e8 4a 39 00 00       	call   801049a0 <wakeup>
80101056:	83 c4 10             	add    $0x10,%esp
80101059:	e9 34 fd ff ff       	jmp    80100d92 <consoleintr+0x22>
8010105e:	66 90                	xchg   %ax,%ax
      if (CAN_ARROW_UP && cmd_buffer.s > 0)
80101060:	a1 6c 15 11 80       	mov    0x8011156c,%eax
80101065:	8b 35 70 15 11 80    	mov    0x80111570,%esi
8010106b:	85 c0                	test   %eax,%eax
8010106d:	0f 84 1f fd ff ff    	je     80100d92 <consoleintr+0x22>
80101073:	39 c6                	cmp    %eax,%esi
80101075:	0f 83 17 fd ff ff    	jae    80100d92 <consoleintr+0x22>
        input.e = input.w;
8010107b:	a1 c4 0f 11 80       	mov    0x80110fc4,%eax
        if (cmd_buffer.pointer == 0)
80101080:	8b 0d 68 15 11 80    	mov    0x80111568,%ecx
        input.e = input.w;
80101086:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        input.pointer = input.w;
8010108b:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
        if (cmd_buffer.pointer == 0)
80101090:	b8 09 00 00 00       	mov    $0x9,%eax
80101095:	85 c9                	test   %ecx,%ecx
80101097:	74 1a                	je     801010b3 <consoleintr+0x343>
          cmd_buffer.pointer--;
80101099:	83 e9 01             	sub    $0x1,%ecx
8010109c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801010a1:	89 c8                	mov    %ecx,%eax
801010a3:	f7 e2                	mul    %edx
801010a5:	89 d0                	mov    %edx,%eax
801010a7:	c1 e8 03             	shr    $0x3,%eax
801010aa:	8d 04 80             	lea    (%eax,%eax,4),%eax
801010ad:	01 c0                	add    %eax,%eax
801010af:	29 c1                	sub    %eax,%ecx
801010b1:	89 c8                	mov    %ecx,%eax
        cmd_buffer.movement++;
801010b3:	83 c6 01             	add    $0x1,%esi
        cmd_buffer.pointer %= CMD_BUF_SIZE;
801010b6:	a3 68 15 11 80       	mov    %eax,0x80111568
        cmd_buffer.movement++;
801010bb:	89 35 70 15 11 80    	mov    %esi,0x80111570
        loadCommand();
801010c1:	e8 2a fc ff ff       	call   80100cf0 <loadCommand>
  if (panicked)
801010c6:	a1 78 b5 10 80       	mov    0x8010b578,%eax
801010cb:	85 c0                	test   %eax,%eax
801010cd:	0f 84 15 01 00 00    	je     801011e8 <consoleintr+0x478>
801010d3:	fa                   	cli    
    for (;;)
801010d4:	eb fe                	jmp    801010d4 <consoleintr+0x364>
801010d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010dd:	8d 76 00             	lea    0x0(%esi),%esi
      if (input.pointer != input.w)
801010e0:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
801010e5:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801010eb:	0f 84 a1 fc ff ff    	je     80100d92 <consoleintr+0x22>
        input.pointer--;
801010f1:	83 e8 01             	sub    $0x1,%eax
801010f4:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
  if (panicked)
801010f9:	a1 78 b5 10 80       	mov    0x8010b578,%eax
801010fe:	85 c0                	test   %eax,%eax
80101100:	74 24                	je     80101126 <consoleintr+0x3b6>
80101102:	fa                   	cli    
    for (;;)
80101103:	eb fe                	jmp    80101103 <consoleintr+0x393>
80101105:	8d 76 00             	lea    0x0(%esi),%esi
80101108:	b8 05 01 00 00       	mov    $0x105,%eax
8010110d:	e8 fe f2 ff ff       	call   80100410 <consputc.part.0>
      input.pointer = input.e = input.w;
80101112:	a1 c4 0f 11 80       	mov    0x80110fc4,%eax
80101117:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
8010111c:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
      break;
80101121:	e9 6c fc ff ff       	jmp    80100d92 <consoleintr+0x22>
80101126:	b8 01 01 00 00       	mov    $0x101,%eax
8010112b:	e8 e0 f2 ff ff       	call   80100410 <consputc.part.0>
80101130:	e9 5d fc ff ff       	jmp    80100d92 <consoleintr+0x22>
80101135:	b8 04 01 00 00       	mov    $0x104,%eax
8010113a:	e8 d1 f2 ff ff       	call   80100410 <consputc.part.0>
8010113f:	e9 4e fc ff ff       	jmp    80100d92 <consoleintr+0x22>
  for (int i = input.pointer - 1; i < input.e; i++)
80101144:	83 e8 01             	sub    $0x1,%eax
80101147:	39 c6                	cmp    %eax,%esi
80101149:	76 35                	jbe    80101180 <consoleintr+0x410>
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
8010114b:	89 c2                	mov    %eax,%edx
8010114d:	83 c0 01             	add    $0x1,%eax
80101150:	89 c7                	mov    %eax,%edi
80101152:	c1 ff 1f             	sar    $0x1f,%edi
80101155:	c1 ef 19             	shr    $0x19,%edi
80101158:	8d 0c 38             	lea    (%eax,%edi,1),%ecx
8010115b:	83 e1 7f             	and    $0x7f,%ecx
8010115e:	29 f9                	sub    %edi,%ecx
80101160:	89 d7                	mov    %edx,%edi
80101162:	c1 ff 1f             	sar    $0x1f,%edi
80101165:	0f b6 89 40 0f 11 80 	movzbl -0x7feef0c0(%ecx),%ecx
8010116c:	c1 ef 19             	shr    $0x19,%edi
8010116f:	01 fa                	add    %edi,%edx
80101171:	83 e2 7f             	and    $0x7f,%edx
80101174:	29 fa                	sub    %edi,%edx
80101176:	88 8a 40 0f 11 80    	mov    %cl,-0x7feef0c0(%edx)
  for (int i = input.pointer - 1; i < input.e; i++)
8010117c:	39 f0                	cmp    %esi,%eax
8010117e:	75 cb                	jne    8010114b <consoleintr+0x3db>
  if (panicked)
80101180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101183:	85 d2                	test   %edx,%edx
80101185:	74 09                	je     80101190 <consoleintr+0x420>
80101187:	fa                   	cli    
    for (;;)
80101188:	eb fe                	jmp    80101188 <consoleintr+0x418>
8010118a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101190:	b8 03 01 00 00       	mov    $0x103,%eax
80101195:	e8 76 f2 ff ff       	call   80100410 <consputc.part.0>
        input.e--;
8010119a:	83 2d c8 0f 11 80 01 	subl   $0x1,0x80110fc8
        input.pointer--;
801011a1:	83 2d cc 0f 11 80 01 	subl   $0x1,0x80110fcc
801011a8:	e9 e5 fb ff ff       	jmp    80100d92 <consoleintr+0x22>
801011ad:	b8 05 01 00 00       	mov    $0x105,%eax
801011b2:	e8 59 f2 ff ff       	call   80100410 <consputc.part.0>
801011b7:	e9 d6 fb ff ff       	jmp    80100d92 <consoleintr+0x22>
  release(&cons.lock);
801011bc:	83 ec 0c             	sub    $0xc,%esp
801011bf:	68 40 b5 10 80       	push   $0x8010b540
801011c4:	e8 17 3d 00 00       	call   80104ee0 <release>
  if (doprocdump)
801011c9:	83 c4 10             	add    $0x10,%esp
801011cc:	85 db                	test   %ebx,%ebx
801011ce:	0f 85 c7 00 00 00    	jne    8010129b <consoleintr+0x52b>
}
801011d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011d7:	5b                   	pop    %ebx
801011d8:	5e                   	pop    %esi
801011d9:	5f                   	pop    %edi
801011da:	5d                   	pop    %ebp
801011db:	c3                   	ret    
801011dc:	b8 00 01 00 00       	mov    $0x100,%eax
801011e1:	e8 2a f2 ff ff       	call   80100410 <consputc.part.0>
801011e6:	eb b2                	jmp    8010119a <consoleintr+0x42a>
801011e8:	b8 e2 00 00 00       	mov    $0xe2,%eax
801011ed:	e8 1e f2 ff ff       	call   80100410 <consputc.part.0>
801011f2:	e9 9b fb ff ff       	jmp    80100d92 <consoleintr+0x22>
  for (int i = input.e; i > input.pointer; i--)
801011f7:	73 53                	jae    8010124c <consoleintr+0x4dc>
    input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
801011f9:	89 c2                	mov    %eax,%edx
801011fb:	83 e8 01             	sub    $0x1,%eax
801011fe:	89 c7                	mov    %eax,%edi
80101200:	c1 ff 1f             	sar    $0x1f,%edi
80101203:	c1 ef 19             	shr    $0x19,%edi
80101206:	8d 0c 38             	lea    (%eax,%edi,1),%ecx
80101209:	83 e1 7f             	and    $0x7f,%ecx
8010120c:	29 f9                	sub    %edi,%ecx
8010120e:	89 d7                	mov    %edx,%edi
80101210:	c1 ff 1f             	sar    $0x1f,%edi
80101213:	0f b6 89 40 0f 11 80 	movzbl -0x7feef0c0(%ecx),%ecx
8010121a:	c1 ef 19             	shr    $0x19,%edi
8010121d:	01 fa                	add    %edi,%edx
8010121f:	83 e2 7f             	and    $0x7f,%edx
80101222:	29 fa                	sub    %edi,%edx
  for (int i = input.e; i > input.pointer; i--)
80101224:	39 45 dc             	cmp    %eax,-0x24(%ebp)
    input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
80101227:	88 8a 40 0f 11 80    	mov    %cl,-0x7feef0c0(%edx)
  for (int i = input.e; i > input.pointer; i--)
8010122d:	eb c8                	jmp    801011f7 <consoleintr+0x487>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
8010122f:	c6 45 e4 01          	movb   $0x1,-0x1c(%ebp)
        c = (c == '\r') ? END_OF_LINE : c;
80101233:	be 0a 00 00 00       	mov    $0xa,%esi
          input.pointer = input.e;
80101238:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
          recordCommand();
8010123d:	e8 7e f9 ff ff       	call   80100bc0 <recordCommand>
80101242:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80101247:	e9 95 fd ff ff       	jmp    80100fe1 <consoleintr+0x271>
  if (panicked)
8010124c:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80101252:	85 d2                	test   %edx,%edx
80101254:	74 0a                	je     80101260 <consoleintr+0x4f0>
80101256:	fa                   	cli    
    for (;;)
80101257:	eb fe                	jmp    80101257 <consoleintr+0x4e7>
80101259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101260:	b8 02 01 00 00       	mov    $0x102,%eax
80101265:	e8 a6 f1 ff ff       	call   80100410 <consputc.part.0>
8010126a:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
8010126f:	8b 15 c8 0f 11 80    	mov    0x80110fc8,%edx
80101275:	e9 7a fd ff ff       	jmp    80100ff4 <consoleintr+0x284>
8010127a:	fa                   	cli    
8010127b:	eb fe                	jmp    8010127b <consoleintr+0x50b>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
              cprintf("\n"); // Handle newline
80101280:	83 ec 0c             	sub    $0xc,%esp
80101283:	68 77 83 10 80       	push   $0x80108377
80101288:	e8 c3 f6 ff ff       	call   80100950 <cprintf>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
8010128d:	c6 45 e4 01          	movb   $0x1,-0x1c(%ebp)
80101291:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80101296:	83 c4 10             	add    $0x10,%esp
80101299:	eb 9d                	jmp    80101238 <consoleintr+0x4c8>
}
8010129b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010129e:	5b                   	pop    %ebx
8010129f:	5e                   	pop    %esi
801012a0:	5f                   	pop    %edi
801012a1:	5d                   	pop    %ebp
    procdump(); // now call procdump() wo. cons.lock held
801012a2:	e9 e9 37 00 00       	jmp    80104a90 <procdump>
          cmd_buffer.pointer++;
801012a7:	a1 68 15 11 80       	mov    0x80111568,%eax
          cmd_buffer.movement--;
801012ac:	89 15 70 15 11 80    	mov    %edx,0x80111570
          cmd_buffer.pointer %= CMD_BUF_SIZE;
801012b2:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
          cmd_buffer.pointer++;
801012b7:	8d 48 01             	lea    0x1(%eax),%ecx
          cmd_buffer.pointer %= CMD_BUF_SIZE;
801012ba:	89 c8                	mov    %ecx,%eax
801012bc:	f7 e2                	mul    %edx
801012be:	89 d0                	mov    %edx,%eax
801012c0:	c1 e8 03             	shr    $0x3,%eax
801012c3:	8d 04 80             	lea    (%eax,%eax,4),%eax
801012c6:	01 c0                	add    %eax,%eax
801012c8:	29 c1                	sub    %eax,%ecx
801012ca:	89 0d 68 15 11 80    	mov    %ecx,0x80111568
          loadCommand();
801012d0:	e8 1b fa ff ff       	call   80100cf0 <loadCommand>
  if (panicked)
801012d5:	85 f6                	test   %esi,%esi
801012d7:	74 07                	je     801012e0 <consoleintr+0x570>
801012d9:	fa                   	cli    
    for (;;)
801012da:	eb fe                	jmp    801012da <consoleintr+0x56a>
801012dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012e0:	b8 e3 00 00 00       	mov    $0xe3,%eax
801012e5:	e8 26 f1 ff ff       	call   80100410 <consputc.part.0>
801012ea:	e9 a3 fa ff ff       	jmp    80100d92 <consoleintr+0x22>
801012ef:	90                   	nop

801012f0 <consoleinit>:

void consoleinit(void)
{
801012f0:	f3 0f 1e fb          	endbr32 
801012f4:	55                   	push   %ebp
801012f5:	89 e5                	mov    %esp,%ebp
801012f7:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801012fa:	68 1b 7a 10 80       	push   $0x80107a1b
801012ff:	68 40 b5 10 80       	push   $0x8010b540
80101304:	e8 97 39 00 00       	call   80104ca0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80101309:	58                   	pop    %eax
8010130a:	5a                   	pop    %edx
8010130b:	6a 00                	push   $0x0
8010130d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
8010130f:	c7 05 2c 1f 11 80 e0 	movl   $0x801008e0,0x80111f2c
80101316:	08 10 80 
  devsw[CONSOLE].read = consoleread;
80101319:	c7 05 28 1f 11 80 90 	movl   $0x80100290,0x80111f28
80101320:	02 10 80 
  cons.locking = 1;
80101323:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
8010132a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
8010132d:	e8 be 19 00 00       	call   80102cf0 <ioapicenable>
80101332:	83 c4 10             	add    $0x10,%esp
80101335:	c9                   	leave  
80101336:	c3                   	ret    
80101337:	66 90                	xchg   %ax,%ax
80101339:	66 90                	xchg   %ax,%ax
8010133b:	66 90                	xchg   %ax,%ax
8010133d:	66 90                	xchg   %ax,%ax
8010133f:	90                   	nop

80101340 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80101340:	f3 0f 1e fb          	endbr32 
80101344:	55                   	push   %ebp
80101345:	89 e5                	mov    %esp,%ebp
80101347:	57                   	push   %edi
80101348:	56                   	push   %esi
80101349:	53                   	push   %ebx
8010134a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80101350:	e8 cb 2e 00 00       	call   80104220 <myproc>
80101355:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
8010135b:	e8 90 22 00 00       	call   801035f0 <begin_op>

  if((ip = namei(path)) == 0){
80101360:	83 ec 0c             	sub    $0xc,%esp
80101363:	ff 75 08             	pushl  0x8(%ebp)
80101366:	e8 85 15 00 00       	call   801028f0 <namei>
8010136b:	83 c4 10             	add    $0x10,%esp
8010136e:	85 c0                	test   %eax,%eax
80101370:	0f 84 fe 02 00 00    	je     80101674 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101376:	83 ec 0c             	sub    $0xc,%esp
80101379:	89 c3                	mov    %eax,%ebx
8010137b:	50                   	push   %eax
8010137c:	e8 9f 0c 00 00       	call   80102020 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101381:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101387:	6a 34                	push   $0x34
80101389:	6a 00                	push   $0x0
8010138b:	50                   	push   %eax
8010138c:	53                   	push   %ebx
8010138d:	e8 8e 0f 00 00       	call   80102320 <readi>
80101392:	83 c4 20             	add    $0x20,%esp
80101395:	83 f8 34             	cmp    $0x34,%eax
80101398:	74 26                	je     801013c0 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
8010139a:	83 ec 0c             	sub    $0xc,%esp
8010139d:	53                   	push   %ebx
8010139e:	e8 1d 0f 00 00       	call   801022c0 <iunlockput>
    end_op();
801013a3:	e8 b8 22 00 00       	call   80103660 <end_op>
801013a8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
801013ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801013b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b3:	5b                   	pop    %ebx
801013b4:	5e                   	pop    %esi
801013b5:	5f                   	pop    %edi
801013b6:	5d                   	pop    %ebp
801013b7:	c3                   	ret    
801013b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013bf:	90                   	nop
  if(elf.magic != ELF_MAGIC)
801013c0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801013c7:	45 4c 46 
801013ca:	75 ce                	jne    8010139a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
801013cc:	e8 3f 63 00 00       	call   80107710 <setupkvm>
801013d1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801013d7:	85 c0                	test   %eax,%eax
801013d9:	74 bf                	je     8010139a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801013db:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801013e2:	00 
801013e3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
801013e9:	0f 84 a4 02 00 00    	je     80101693 <exec+0x353>
  sz = 0;
801013ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801013f6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801013f9:	31 ff                	xor    %edi,%edi
801013fb:	e9 86 00 00 00       	jmp    80101486 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80101400:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101407:	75 6c                	jne    80101475 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101409:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010140f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101415:	0f 82 87 00 00 00    	jb     801014a2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010141b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101421:	72 7f                	jb     801014a2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101423:	83 ec 04             	sub    $0x4,%esp
80101426:	50                   	push   %eax
80101427:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010142d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101433:	e8 f8 60 00 00       	call   80107530 <allocuvm>
80101438:	83 c4 10             	add    $0x10,%esp
8010143b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101441:	85 c0                	test   %eax,%eax
80101443:	74 5d                	je     801014a2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101445:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010144b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101450:	75 50                	jne    801014a2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101452:	83 ec 0c             	sub    $0xc,%esp
80101455:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
8010145b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101461:	53                   	push   %ebx
80101462:	50                   	push   %eax
80101463:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101469:	e8 f2 5f 00 00       	call   80107460 <loaduvm>
8010146e:	83 c4 20             	add    $0x20,%esp
80101471:	85 c0                	test   %eax,%eax
80101473:	78 2d                	js     801014a2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101475:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010147c:	83 c7 01             	add    $0x1,%edi
8010147f:	83 c6 20             	add    $0x20,%esi
80101482:	39 f8                	cmp    %edi,%eax
80101484:	7e 3a                	jle    801014c0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101486:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010148c:	6a 20                	push   $0x20
8010148e:	56                   	push   %esi
8010148f:	50                   	push   %eax
80101490:	53                   	push   %ebx
80101491:	e8 8a 0e 00 00       	call   80102320 <readi>
80101496:	83 c4 10             	add    $0x10,%esp
80101499:	83 f8 20             	cmp    $0x20,%eax
8010149c:	0f 84 5e ff ff ff    	je     80101400 <exec+0xc0>
    freevm(pgdir);
801014a2:	83 ec 0c             	sub    $0xc,%esp
801014a5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801014ab:	e8 e0 61 00 00       	call   80107690 <freevm>
  if(ip){
801014b0:	83 c4 10             	add    $0x10,%esp
801014b3:	e9 e2 fe ff ff       	jmp    8010139a <exec+0x5a>
801014b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014bf:	90                   	nop
801014c0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801014c6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801014cc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
801014d2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801014d8:	83 ec 0c             	sub    $0xc,%esp
801014db:	53                   	push   %ebx
801014dc:	e8 df 0d 00 00       	call   801022c0 <iunlockput>
  end_op();
801014e1:	e8 7a 21 00 00       	call   80103660 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801014e6:	83 c4 0c             	add    $0xc,%esp
801014e9:	56                   	push   %esi
801014ea:	57                   	push   %edi
801014eb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801014f1:	57                   	push   %edi
801014f2:	e8 39 60 00 00       	call   80107530 <allocuvm>
801014f7:	83 c4 10             	add    $0x10,%esp
801014fa:	89 c6                	mov    %eax,%esi
801014fc:	85 c0                	test   %eax,%eax
801014fe:	0f 84 94 00 00 00    	je     80101598 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101504:	83 ec 08             	sub    $0x8,%esp
80101507:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010150d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010150f:	50                   	push   %eax
80101510:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101511:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101513:	e8 98 62 00 00       	call   801077b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101518:	8b 45 0c             	mov    0xc(%ebp),%eax
8010151b:	83 c4 10             	add    $0x10,%esp
8010151e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101524:	8b 00                	mov    (%eax),%eax
80101526:	85 c0                	test   %eax,%eax
80101528:	0f 84 8b 00 00 00    	je     801015b9 <exec+0x279>
8010152e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101534:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010153a:	eb 23                	jmp    8010155f <exec+0x21f>
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101540:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101543:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010154a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010154d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101553:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101556:	85 c0                	test   %eax,%eax
80101558:	74 59                	je     801015b3 <exec+0x273>
    if(argc >= MAXARG)
8010155a:	83 ff 20             	cmp    $0x20,%edi
8010155d:	74 39                	je     80101598 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010155f:	83 ec 0c             	sub    $0xc,%esp
80101562:	50                   	push   %eax
80101563:	e8 c8 3b 00 00       	call   80105130 <strlen>
80101568:	f7 d0                	not    %eax
8010156a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010156c:	58                   	pop    %eax
8010156d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101570:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101573:	ff 34 b8             	pushl  (%eax,%edi,4)
80101576:	e8 b5 3b 00 00       	call   80105130 <strlen>
8010157b:	83 c0 01             	add    $0x1,%eax
8010157e:	50                   	push   %eax
8010157f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101582:	ff 34 b8             	pushl  (%eax,%edi,4)
80101585:	53                   	push   %ebx
80101586:	56                   	push   %esi
80101587:	e8 84 63 00 00       	call   80107910 <copyout>
8010158c:	83 c4 20             	add    $0x20,%esp
8010158f:	85 c0                	test   %eax,%eax
80101591:	79 ad                	jns    80101540 <exec+0x200>
80101593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101597:	90                   	nop
    freevm(pgdir);
80101598:	83 ec 0c             	sub    $0xc,%esp
8010159b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801015a1:	e8 ea 60 00 00       	call   80107690 <freevm>
801015a6:	83 c4 10             	add    $0x10,%esp
  return -1;
801015a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801015ae:	e9 fd fd ff ff       	jmp    801013b0 <exec+0x70>
801015b3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801015b9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801015c0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801015c2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801015c9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801015cd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801015cf:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801015d2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801015d8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801015da:	50                   	push   %eax
801015db:	52                   	push   %edx
801015dc:	53                   	push   %ebx
801015dd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801015e3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801015ea:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801015ed:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801015f3:	e8 18 63 00 00       	call   80107910 <copyout>
801015f8:	83 c4 10             	add    $0x10,%esp
801015fb:	85 c0                	test   %eax,%eax
801015fd:	78 99                	js     80101598 <exec+0x258>
  for(last=s=path; *s; s++)
801015ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101602:	8b 55 08             	mov    0x8(%ebp),%edx
80101605:	0f b6 00             	movzbl (%eax),%eax
80101608:	84 c0                	test   %al,%al
8010160a:	74 13                	je     8010161f <exec+0x2df>
8010160c:	89 d1                	mov    %edx,%ecx
8010160e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80101610:	83 c1 01             	add    $0x1,%ecx
80101613:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101615:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80101618:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010161b:	84 c0                	test   %al,%al
8010161d:	75 f1                	jne    80101610 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010161f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101625:	83 ec 04             	sub    $0x4,%esp
80101628:	6a 10                	push   $0x10
8010162a:	89 f8                	mov    %edi,%eax
8010162c:	52                   	push   %edx
8010162d:	83 c0 6c             	add    $0x6c,%eax
80101630:	50                   	push   %eax
80101631:	e8 ba 3a 00 00       	call   801050f0 <safestrcpy>
  curproc->pgdir = pgdir;
80101636:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010163c:	89 f8                	mov    %edi,%eax
8010163e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101641:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101643:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101646:	89 c1                	mov    %eax,%ecx
80101648:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010164e:	8b 40 18             	mov    0x18(%eax),%eax
80101651:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101654:	8b 41 18             	mov    0x18(%ecx),%eax
80101657:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010165a:	89 0c 24             	mov    %ecx,(%esp)
8010165d:	e8 6e 5c 00 00       	call   801072d0 <switchuvm>
  freevm(oldpgdir);
80101662:	89 3c 24             	mov    %edi,(%esp)
80101665:	e8 26 60 00 00       	call   80107690 <freevm>
  return 0;
8010166a:	83 c4 10             	add    $0x10,%esp
8010166d:	31 c0                	xor    %eax,%eax
8010166f:	e9 3c fd ff ff       	jmp    801013b0 <exec+0x70>
    end_op();
80101674:	e8 e7 1f 00 00       	call   80103660 <end_op>
    cprintf("exec: fail\n");
80101679:	83 ec 0c             	sub    $0xc,%esp
8010167c:	68 9d 7a 10 80       	push   $0x80107a9d
80101681:	e8 ca f2 ff ff       	call   80100950 <cprintf>
    return -1;
80101686:	83 c4 10             	add    $0x10,%esp
80101689:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010168e:	e9 1d fd ff ff       	jmp    801013b0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101693:	31 ff                	xor    %edi,%edi
80101695:	be 00 20 00 00       	mov    $0x2000,%esi
8010169a:	e9 39 fe ff ff       	jmp    801014d8 <exec+0x198>
8010169f:	90                   	nop

801016a0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801016aa:	68 a9 7a 10 80       	push   $0x80107aa9
801016af:	68 80 15 11 80       	push   $0x80111580
801016b4:	e8 e7 35 00 00       	call   80104ca0 <initlock>
}
801016b9:	83 c4 10             	add    $0x10,%esp
801016bc:	c9                   	leave  
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801016c0:	f3 0f 1e fb          	endbr32 
801016c4:	55                   	push   %ebp
801016c5:	89 e5                	mov    %esp,%ebp
801016c7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801016c8:	bb b4 15 11 80       	mov    $0x801115b4,%ebx
{
801016cd:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801016d0:	68 80 15 11 80       	push   $0x80111580
801016d5:	e8 46 37 00 00       	call   80104e20 <acquire>
801016da:	83 c4 10             	add    $0x10,%esp
801016dd:	eb 0c                	jmp    801016eb <filealloc+0x2b>
801016df:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801016e0:	83 c3 18             	add    $0x18,%ebx
801016e3:	81 fb 14 1f 11 80    	cmp    $0x80111f14,%ebx
801016e9:	74 25                	je     80101710 <filealloc+0x50>
    if(f->ref == 0){
801016eb:	8b 43 04             	mov    0x4(%ebx),%eax
801016ee:	85 c0                	test   %eax,%eax
801016f0:	75 ee                	jne    801016e0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801016f2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801016f5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801016fc:	68 80 15 11 80       	push   $0x80111580
80101701:	e8 da 37 00 00       	call   80104ee0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101706:	89 d8                	mov    %ebx,%eax
      return f;
80101708:	83 c4 10             	add    $0x10,%esp
}
8010170b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010170e:	c9                   	leave  
8010170f:	c3                   	ret    
  release(&ftable.lock);
80101710:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101713:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101715:	68 80 15 11 80       	push   $0x80111580
8010171a:	e8 c1 37 00 00       	call   80104ee0 <release>
}
8010171f:	89 d8                	mov    %ebx,%eax
  return 0;
80101721:	83 c4 10             	add    $0x10,%esp
}
80101724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101727:	c9                   	leave  
80101728:	c3                   	ret    
80101729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101730 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010173e:	68 80 15 11 80       	push   $0x80111580
80101743:	e8 d8 36 00 00       	call   80104e20 <acquire>
  if(f->ref < 1)
80101748:	8b 43 04             	mov    0x4(%ebx),%eax
8010174b:	83 c4 10             	add    $0x10,%esp
8010174e:	85 c0                	test   %eax,%eax
80101750:	7e 1a                	jle    8010176c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101752:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101755:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101758:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010175b:	68 80 15 11 80       	push   $0x80111580
80101760:	e8 7b 37 00 00       	call   80104ee0 <release>
  return f;
}
80101765:	89 d8                	mov    %ebx,%eax
80101767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176a:	c9                   	leave  
8010176b:	c3                   	ret    
    panic("filedup");
8010176c:	83 ec 0c             	sub    $0xc,%esp
8010176f:	68 b0 7a 10 80       	push   $0x80107ab0
80101774:	e8 17 ec ff ff       	call   80100390 <panic>
80101779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101780 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101780:	f3 0f 1e fb          	endbr32 
80101784:	55                   	push   %ebp
80101785:	89 e5                	mov    %esp,%ebp
80101787:	57                   	push   %edi
80101788:	56                   	push   %esi
80101789:	53                   	push   %ebx
8010178a:	83 ec 28             	sub    $0x28,%esp
8010178d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101790:	68 80 15 11 80       	push   $0x80111580
80101795:	e8 86 36 00 00       	call   80104e20 <acquire>
  if(f->ref < 1)
8010179a:	8b 53 04             	mov    0x4(%ebx),%edx
8010179d:	83 c4 10             	add    $0x10,%esp
801017a0:	85 d2                	test   %edx,%edx
801017a2:	0f 8e a1 00 00 00    	jle    80101849 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801017a8:	83 ea 01             	sub    $0x1,%edx
801017ab:	89 53 04             	mov    %edx,0x4(%ebx)
801017ae:	75 40                	jne    801017f0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801017b0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801017b4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801017b7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801017b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801017bf:	8b 73 0c             	mov    0xc(%ebx),%esi
801017c2:	88 45 e7             	mov    %al,-0x19(%ebp)
801017c5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801017c8:	68 80 15 11 80       	push   $0x80111580
  ff = *f;
801017cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801017d0:	e8 0b 37 00 00       	call   80104ee0 <release>

  if(ff.type == FD_PIPE)
801017d5:	83 c4 10             	add    $0x10,%esp
801017d8:	83 ff 01             	cmp    $0x1,%edi
801017db:	74 53                	je     80101830 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801017dd:	83 ff 02             	cmp    $0x2,%edi
801017e0:	74 26                	je     80101808 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801017e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017e5:	5b                   	pop    %ebx
801017e6:	5e                   	pop    %esi
801017e7:	5f                   	pop    %edi
801017e8:	5d                   	pop    %ebp
801017e9:	c3                   	ret    
801017ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801017f0:	c7 45 08 80 15 11 80 	movl   $0x80111580,0x8(%ebp)
}
801017f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fa:	5b                   	pop    %ebx
801017fb:	5e                   	pop    %esi
801017fc:	5f                   	pop    %edi
801017fd:	5d                   	pop    %ebp
    release(&ftable.lock);
801017fe:	e9 dd 36 00 00       	jmp    80104ee0 <release>
80101803:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101807:	90                   	nop
    begin_op();
80101808:	e8 e3 1d 00 00       	call   801035f0 <begin_op>
    iput(ff.ip);
8010180d:	83 ec 0c             	sub    $0xc,%esp
80101810:	ff 75 e0             	pushl  -0x20(%ebp)
80101813:	e8 38 09 00 00       	call   80102150 <iput>
    end_op();
80101818:	83 c4 10             	add    $0x10,%esp
}
8010181b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010181e:	5b                   	pop    %ebx
8010181f:	5e                   	pop    %esi
80101820:	5f                   	pop    %edi
80101821:	5d                   	pop    %ebp
    end_op();
80101822:	e9 39 1e 00 00       	jmp    80103660 <end_op>
80101827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010182e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101830:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101834:	83 ec 08             	sub    $0x8,%esp
80101837:	53                   	push   %ebx
80101838:	56                   	push   %esi
80101839:	e8 82 25 00 00       	call   80103dc0 <pipeclose>
8010183e:	83 c4 10             	add    $0x10,%esp
}
80101841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101844:	5b                   	pop    %ebx
80101845:	5e                   	pop    %esi
80101846:	5f                   	pop    %edi
80101847:	5d                   	pop    %ebp
80101848:	c3                   	ret    
    panic("fileclose");
80101849:	83 ec 0c             	sub    $0xc,%esp
8010184c:	68 b8 7a 10 80       	push   $0x80107ab8
80101851:	e8 3a eb ff ff       	call   80100390 <panic>
80101856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185d:	8d 76 00             	lea    0x0(%esi),%esi

80101860 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101860:	f3 0f 1e fb          	endbr32 
80101864:	55                   	push   %ebp
80101865:	89 e5                	mov    %esp,%ebp
80101867:	53                   	push   %ebx
80101868:	83 ec 04             	sub    $0x4,%esp
8010186b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010186e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101871:	75 2d                	jne    801018a0 <filestat+0x40>
    ilock(f->ip);
80101873:	83 ec 0c             	sub    $0xc,%esp
80101876:	ff 73 10             	pushl  0x10(%ebx)
80101879:	e8 a2 07 00 00       	call   80102020 <ilock>
    stati(f->ip, st);
8010187e:	58                   	pop    %eax
8010187f:	5a                   	pop    %edx
80101880:	ff 75 0c             	pushl  0xc(%ebp)
80101883:	ff 73 10             	pushl  0x10(%ebx)
80101886:	e8 65 0a 00 00       	call   801022f0 <stati>
    iunlock(f->ip);
8010188b:	59                   	pop    %ecx
8010188c:	ff 73 10             	pushl  0x10(%ebx)
8010188f:	e8 6c 08 00 00       	call   80102100 <iunlock>
    return 0;
  }
  return -1;
}
80101894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101897:	83 c4 10             	add    $0x10,%esp
8010189a:	31 c0                	xor    %eax,%eax
}
8010189c:	c9                   	leave  
8010189d:	c3                   	ret    
8010189e:	66 90                	xchg   %ax,%ax
801018a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801018a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801018a8:	c9                   	leave  
801018a9:	c3                   	ret    
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801018b0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801018b0:	f3 0f 1e fb          	endbr32 
801018b4:	55                   	push   %ebp
801018b5:	89 e5                	mov    %esp,%ebp
801018b7:	57                   	push   %edi
801018b8:	56                   	push   %esi
801018b9:	53                   	push   %ebx
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801018c0:	8b 75 0c             	mov    0xc(%ebp),%esi
801018c3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801018c6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801018ca:	74 64                	je     80101930 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801018cc:	8b 03                	mov    (%ebx),%eax
801018ce:	83 f8 01             	cmp    $0x1,%eax
801018d1:	74 45                	je     80101918 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801018d3:	83 f8 02             	cmp    $0x2,%eax
801018d6:	75 5f                	jne    80101937 <fileread+0x87>
    ilock(f->ip);
801018d8:	83 ec 0c             	sub    $0xc,%esp
801018db:	ff 73 10             	pushl  0x10(%ebx)
801018de:	e8 3d 07 00 00       	call   80102020 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801018e3:	57                   	push   %edi
801018e4:	ff 73 14             	pushl  0x14(%ebx)
801018e7:	56                   	push   %esi
801018e8:	ff 73 10             	pushl  0x10(%ebx)
801018eb:	e8 30 0a 00 00       	call   80102320 <readi>
801018f0:	83 c4 20             	add    $0x20,%esp
801018f3:	89 c6                	mov    %eax,%esi
801018f5:	85 c0                	test   %eax,%eax
801018f7:	7e 03                	jle    801018fc <fileread+0x4c>
      f->off += r;
801018f9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801018fc:	83 ec 0c             	sub    $0xc,%esp
801018ff:	ff 73 10             	pushl  0x10(%ebx)
80101902:	e8 f9 07 00 00       	call   80102100 <iunlock>
    return r;
80101907:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010190a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010190d:	89 f0                	mov    %esi,%eax
8010190f:	5b                   	pop    %ebx
80101910:	5e                   	pop    %esi
80101911:	5f                   	pop    %edi
80101912:	5d                   	pop    %ebp
80101913:	c3                   	ret    
80101914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101918:	8b 43 0c             	mov    0xc(%ebx),%eax
8010191b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010191e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101921:	5b                   	pop    %ebx
80101922:	5e                   	pop    %esi
80101923:	5f                   	pop    %edi
80101924:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101925:	e9 36 26 00 00       	jmp    80103f60 <piperead>
8010192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101930:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101935:	eb d3                	jmp    8010190a <fileread+0x5a>
  panic("fileread");
80101937:	83 ec 0c             	sub    $0xc,%esp
8010193a:	68 c2 7a 10 80       	push   $0x80107ac2
8010193f:	e8 4c ea ff ff       	call   80100390 <panic>
80101944:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010194b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010194f:	90                   	nop

80101950 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101950:	f3 0f 1e fb          	endbr32 
80101954:	55                   	push   %ebp
80101955:	89 e5                	mov    %esp,%ebp
80101957:	57                   	push   %edi
80101958:	56                   	push   %esi
80101959:	53                   	push   %ebx
8010195a:	83 ec 1c             	sub    $0x1c,%esp
8010195d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101960:	8b 75 08             	mov    0x8(%ebp),%esi
80101963:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101966:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101969:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010196d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101970:	0f 84 c1 00 00 00    	je     80101a37 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101976:	8b 06                	mov    (%esi),%eax
80101978:	83 f8 01             	cmp    $0x1,%eax
8010197b:	0f 84 c3 00 00 00    	je     80101a44 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101981:	83 f8 02             	cmp    $0x2,%eax
80101984:	0f 85 cc 00 00 00    	jne    80101a56 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010198a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010198d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010198f:	85 c0                	test   %eax,%eax
80101991:	7f 34                	jg     801019c7 <filewrite+0x77>
80101993:	e9 98 00 00 00       	jmp    80101a30 <filewrite+0xe0>
80101998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010199f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801019a0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801019a3:	83 ec 0c             	sub    $0xc,%esp
801019a6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801019a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801019ac:	e8 4f 07 00 00       	call   80102100 <iunlock>
      end_op();
801019b1:	e8 aa 1c 00 00       	call   80103660 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801019b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019b9:	83 c4 10             	add    $0x10,%esp
801019bc:	39 c3                	cmp    %eax,%ebx
801019be:	75 60                	jne    80101a20 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801019c0:	01 df                	add    %ebx,%edi
    while(i < n){
801019c2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019c5:	7e 69                	jle    80101a30 <filewrite+0xe0>
      int n1 = n - i;
801019c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019ca:	b8 00 06 00 00       	mov    $0x600,%eax
801019cf:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801019d1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801019d7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801019da:	e8 11 1c 00 00       	call   801035f0 <begin_op>
      ilock(f->ip);
801019df:	83 ec 0c             	sub    $0xc,%esp
801019e2:	ff 76 10             	pushl  0x10(%esi)
801019e5:	e8 36 06 00 00       	call   80102020 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801019ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
801019ed:	53                   	push   %ebx
801019ee:	ff 76 14             	pushl  0x14(%esi)
801019f1:	01 f8                	add    %edi,%eax
801019f3:	50                   	push   %eax
801019f4:	ff 76 10             	pushl  0x10(%esi)
801019f7:	e8 24 0a 00 00       	call   80102420 <writei>
801019fc:	83 c4 20             	add    $0x20,%esp
801019ff:	85 c0                	test   %eax,%eax
80101a01:	7f 9d                	jg     801019a0 <filewrite+0x50>
      iunlock(f->ip);
80101a03:	83 ec 0c             	sub    $0xc,%esp
80101a06:	ff 76 10             	pushl  0x10(%esi)
80101a09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101a0c:	e8 ef 06 00 00       	call   80102100 <iunlock>
      end_op();
80101a11:	e8 4a 1c 00 00       	call   80103660 <end_op>
      if(r < 0)
80101a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a19:	83 c4 10             	add    $0x10,%esp
80101a1c:	85 c0                	test   %eax,%eax
80101a1e:	75 17                	jne    80101a37 <filewrite+0xe7>
        panic("short filewrite");
80101a20:	83 ec 0c             	sub    $0xc,%esp
80101a23:	68 cb 7a 10 80       	push   $0x80107acb
80101a28:	e8 63 e9 ff ff       	call   80100390 <panic>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101a30:	89 f8                	mov    %edi,%eax
80101a32:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101a35:	74 05                	je     80101a3c <filewrite+0xec>
80101a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3f:	5b                   	pop    %ebx
80101a40:	5e                   	pop    %esi
80101a41:	5f                   	pop    %edi
80101a42:	5d                   	pop    %ebp
80101a43:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101a44:	8b 46 0c             	mov    0xc(%esi),%eax
80101a47:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4d:	5b                   	pop    %ebx
80101a4e:	5e                   	pop    %esi
80101a4f:	5f                   	pop    %edi
80101a50:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101a51:	e9 0a 24 00 00       	jmp    80103e60 <pipewrite>
  panic("filewrite");
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	68 d1 7a 10 80       	push   $0x80107ad1
80101a5e:	e8 2d e9 ff ff       	call   80100390 <panic>
80101a63:	66 90                	xchg   %ax,%ax
80101a65:	66 90                	xchg   %ax,%ax
80101a67:	66 90                	xchg   %ax,%ax
80101a69:	66 90                	xchg   %ax,%ax
80101a6b:	66 90                	xchg   %ax,%ax
80101a6d:	66 90                	xchg   %ax,%ax
80101a6f:	90                   	nop

80101a70 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101a70:	55                   	push   %ebp
80101a71:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101a73:	89 d0                	mov    %edx,%eax
80101a75:	c1 e8 0c             	shr    $0xc,%eax
80101a78:	03 05 98 1f 11 80    	add    0x80111f98,%eax
{
80101a7e:	89 e5                	mov    %esp,%ebp
80101a80:	56                   	push   %esi
80101a81:	53                   	push   %ebx
80101a82:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101a84:	83 ec 08             	sub    $0x8,%esp
80101a87:	50                   	push   %eax
80101a88:	51                   	push   %ecx
80101a89:	e8 42 e6 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101a8e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101a90:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101a93:	ba 01 00 00 00       	mov    $0x1,%edx
80101a98:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101a9b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101aa1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101aa4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101aa6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101aab:	85 d1                	test   %edx,%ecx
80101aad:	74 25                	je     80101ad4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101aaf:	f7 d2                	not    %edx
  log_write(bp);
80101ab1:	83 ec 0c             	sub    $0xc,%esp
80101ab4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101ab6:	21 ca                	and    %ecx,%edx
80101ab8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101abc:	50                   	push   %eax
80101abd:	e8 0e 1d 00 00       	call   801037d0 <log_write>
  brelse(bp);
80101ac2:	89 34 24             	mov    %esi,(%esp)
80101ac5:	e8 26 e7 ff ff       	call   801001f0 <brelse>
}
80101aca:	83 c4 10             	add    $0x10,%esp
80101acd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ad0:	5b                   	pop    %ebx
80101ad1:	5e                   	pop    %esi
80101ad2:	5d                   	pop    %ebp
80101ad3:	c3                   	ret    
    panic("freeing free block");
80101ad4:	83 ec 0c             	sub    $0xc,%esp
80101ad7:	68 db 7a 10 80       	push   $0x80107adb
80101adc:	e8 af e8 ff ff       	call   80100390 <panic>
80101ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop

80101af0 <balloc>:
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101af9:	8b 0d 80 1f 11 80    	mov    0x80111f80,%ecx
{
80101aff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101b02:	85 c9                	test   %ecx,%ecx
80101b04:	0f 84 87 00 00 00    	je     80101b91 <balloc+0xa1>
80101b0a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101b11:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101b14:	83 ec 08             	sub    $0x8,%esp
80101b17:	89 f0                	mov    %esi,%eax
80101b19:	c1 f8 0c             	sar    $0xc,%eax
80101b1c:	03 05 98 1f 11 80    	add    0x80111f98,%eax
80101b22:	50                   	push   %eax
80101b23:	ff 75 d8             	pushl  -0x28(%ebp)
80101b26:	e8 a5 e5 ff ff       	call   801000d0 <bread>
80101b2b:	83 c4 10             	add    $0x10,%esp
80101b2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101b31:	a1 80 1f 11 80       	mov    0x80111f80,%eax
80101b36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b39:	31 c0                	xor    %eax,%eax
80101b3b:	eb 2f                	jmp    80101b6c <balloc+0x7c>
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101b40:	89 c1                	mov    %eax,%ecx
80101b42:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101b47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101b4a:	83 e1 07             	and    $0x7,%ecx
80101b4d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101b4f:	89 c1                	mov    %eax,%ecx
80101b51:	c1 f9 03             	sar    $0x3,%ecx
80101b54:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101b59:	89 fa                	mov    %edi,%edx
80101b5b:	85 df                	test   %ebx,%edi
80101b5d:	74 41                	je     80101ba0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101b5f:	83 c0 01             	add    $0x1,%eax
80101b62:	83 c6 01             	add    $0x1,%esi
80101b65:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101b6a:	74 05                	je     80101b71 <balloc+0x81>
80101b6c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101b6f:	77 cf                	ja     80101b40 <balloc+0x50>
    brelse(bp);
80101b71:	83 ec 0c             	sub    $0xc,%esp
80101b74:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b77:	e8 74 e6 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101b7c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101b83:	83 c4 10             	add    $0x10,%esp
80101b86:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b89:	39 05 80 1f 11 80    	cmp    %eax,0x80111f80
80101b8f:	77 80                	ja     80101b11 <balloc+0x21>
  panic("balloc: out of blocks");
80101b91:	83 ec 0c             	sub    $0xc,%esp
80101b94:	68 ee 7a 10 80       	push   $0x80107aee
80101b99:	e8 f2 e7 ff ff       	call   80100390 <panic>
80101b9e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101ba0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101ba3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101ba6:	09 da                	or     %ebx,%edx
80101ba8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101bac:	57                   	push   %edi
80101bad:	e8 1e 1c 00 00       	call   801037d0 <log_write>
        brelse(bp);
80101bb2:	89 3c 24             	mov    %edi,(%esp)
80101bb5:	e8 36 e6 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101bba:	58                   	pop    %eax
80101bbb:	5a                   	pop    %edx
80101bbc:	56                   	push   %esi
80101bbd:	ff 75 d8             	pushl  -0x28(%ebp)
80101bc0:	e8 0b e5 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101bc5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101bc8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101bca:	8d 40 5c             	lea    0x5c(%eax),%eax
80101bcd:	68 00 02 00 00       	push   $0x200
80101bd2:	6a 00                	push   $0x0
80101bd4:	50                   	push   %eax
80101bd5:	e8 56 33 00 00       	call   80104f30 <memset>
  log_write(bp);
80101bda:	89 1c 24             	mov    %ebx,(%esp)
80101bdd:	e8 ee 1b 00 00       	call   801037d0 <log_write>
  brelse(bp);
80101be2:	89 1c 24             	mov    %ebx,(%esp)
80101be5:	e8 06 e6 ff ff       	call   801001f0 <brelse>
}
80101bea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bed:	89 f0                	mov    %esi,%eax
80101bef:	5b                   	pop    %ebx
80101bf0:	5e                   	pop    %esi
80101bf1:	5f                   	pop    %edi
80101bf2:	5d                   	pop    %ebp
80101bf3:	c3                   	ret    
80101bf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop

80101c00 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	89 c7                	mov    %eax,%edi
80101c06:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101c07:	31 f6                	xor    %esi,%esi
{
80101c09:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c0a:	bb d4 1f 11 80       	mov    $0x80111fd4,%ebx
{
80101c0f:	83 ec 28             	sub    $0x28,%esp
80101c12:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101c15:	68 a0 1f 11 80       	push   $0x80111fa0
80101c1a:	e8 01 32 00 00       	call   80104e20 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	eb 1b                	jmp    80101c42 <iget+0x42>
80101c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c2e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c30:	39 3b                	cmp    %edi,(%ebx)
80101c32:	74 6c                	je     80101ca0 <iget+0xa0>
80101c34:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c3a:	81 fb f4 3b 11 80    	cmp    $0x80113bf4,%ebx
80101c40:	73 26                	jae    80101c68 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c42:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101c45:	85 c9                	test   %ecx,%ecx
80101c47:	7f e7                	jg     80101c30 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101c49:	85 f6                	test   %esi,%esi
80101c4b:	75 e7                	jne    80101c34 <iget+0x34>
80101c4d:	89 d8                	mov    %ebx,%eax
80101c4f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101c55:	85 c9                	test   %ecx,%ecx
80101c57:	75 6e                	jne    80101cc7 <iget+0xc7>
80101c59:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c5b:	81 fb f4 3b 11 80    	cmp    $0x80113bf4,%ebx
80101c61:	72 df                	jb     80101c42 <iget+0x42>
80101c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c67:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101c68:	85 f6                	test   %esi,%esi
80101c6a:	74 73                	je     80101cdf <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101c6c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101c6f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101c71:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101c74:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101c7b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101c82:	68 a0 1f 11 80       	push   $0x80111fa0
80101c87:	e8 54 32 00 00       	call   80104ee0 <release>

  return ip;
80101c8c:	83 c4 10             	add    $0x10,%esp
}
80101c8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c92:	89 f0                	mov    %esi,%eax
80101c94:	5b                   	pop    %ebx
80101c95:	5e                   	pop    %esi
80101c96:	5f                   	pop    %edi
80101c97:	5d                   	pop    %ebp
80101c98:	c3                   	ret    
80101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101ca0:	39 53 04             	cmp    %edx,0x4(%ebx)
80101ca3:	75 8f                	jne    80101c34 <iget+0x34>
      release(&icache.lock);
80101ca5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101ca8:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101cab:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101cad:	68 a0 1f 11 80       	push   $0x80111fa0
      ip->ref++;
80101cb2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101cb5:	e8 26 32 00 00       	call   80104ee0 <release>
      return ip;
80101cba:	83 c4 10             	add    $0x10,%esp
}
80101cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc0:	89 f0                	mov    %esi,%eax
80101cc2:	5b                   	pop    %ebx
80101cc3:	5e                   	pop    %esi
80101cc4:	5f                   	pop    %edi
80101cc5:	5d                   	pop    %ebp
80101cc6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101cc7:	81 fb f4 3b 11 80    	cmp    $0x80113bf4,%ebx
80101ccd:	73 10                	jae    80101cdf <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101ccf:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101cd2:	85 c9                	test   %ecx,%ecx
80101cd4:	0f 8f 56 ff ff ff    	jg     80101c30 <iget+0x30>
80101cda:	e9 6e ff ff ff       	jmp    80101c4d <iget+0x4d>
    panic("iget: no inodes");
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	68 04 7b 10 80       	push   $0x80107b04
80101ce7:	e8 a4 e6 ff ff       	call   80100390 <panic>
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	89 c6                	mov    %eax,%esi
80101cf7:	53                   	push   %ebx
80101cf8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cfb:	83 fa 0b             	cmp    $0xb,%edx
80101cfe:	0f 86 84 00 00 00    	jbe    80101d88 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101d04:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101d07:	83 fb 7f             	cmp    $0x7f,%ebx
80101d0a:	0f 87 98 00 00 00    	ja     80101da8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d10:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101d16:	8b 16                	mov    (%esi),%edx
80101d18:	85 c0                	test   %eax,%eax
80101d1a:	74 54                	je     80101d70 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101d1c:	83 ec 08             	sub    $0x8,%esp
80101d1f:	50                   	push   %eax
80101d20:	52                   	push   %edx
80101d21:	e8 aa e3 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101d26:	83 c4 10             	add    $0x10,%esp
80101d29:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
80101d2d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101d2f:	8b 1a                	mov    (%edx),%ebx
80101d31:	85 db                	test   %ebx,%ebx
80101d33:	74 1b                	je     80101d50 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101d35:	83 ec 0c             	sub    $0xc,%esp
80101d38:	57                   	push   %edi
80101d39:	e8 b2 e4 ff ff       	call   801001f0 <brelse>
    return addr;
80101d3e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d44:	89 d8                	mov    %ebx,%eax
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101d50:	8b 06                	mov    (%esi),%eax
80101d52:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d55:	e8 96 fd ff ff       	call   80101af0 <balloc>
80101d5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101d5d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101d60:	89 c3                	mov    %eax,%ebx
80101d62:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d64:	57                   	push   %edi
80101d65:	e8 66 1a 00 00       	call   801037d0 <log_write>
80101d6a:	83 c4 10             	add    $0x10,%esp
80101d6d:	eb c6                	jmp    80101d35 <bmap+0x45>
80101d6f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d70:	89 d0                	mov    %edx,%eax
80101d72:	e8 79 fd ff ff       	call   80101af0 <balloc>
80101d77:	8b 16                	mov    (%esi),%edx
80101d79:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101d7f:	eb 9b                	jmp    80101d1c <bmap+0x2c>
80101d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101d88:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101d8b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101d8e:	85 db                	test   %ebx,%ebx
80101d90:	75 af                	jne    80101d41 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d92:	8b 00                	mov    (%eax),%eax
80101d94:	e8 57 fd ff ff       	call   80101af0 <balloc>
80101d99:	89 47 5c             	mov    %eax,0x5c(%edi)
80101d9c:	89 c3                	mov    %eax,%ebx
}
80101d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101da1:	89 d8                	mov    %ebx,%eax
80101da3:	5b                   	pop    %ebx
80101da4:	5e                   	pop    %esi
80101da5:	5f                   	pop    %edi
80101da6:	5d                   	pop    %ebp
80101da7:	c3                   	ret    
  panic("bmap: out of range");
80101da8:	83 ec 0c             	sub    $0xc,%esp
80101dab:	68 14 7b 10 80       	push   $0x80107b14
80101db0:	e8 db e5 ff ff       	call   80100390 <panic>
80101db5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101dc0 <readsb>:
{
80101dc0:	f3 0f 1e fb          	endbr32 
80101dc4:	55                   	push   %ebp
80101dc5:	89 e5                	mov    %esp,%ebp
80101dc7:	56                   	push   %esi
80101dc8:	53                   	push   %ebx
80101dc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101dcc:	83 ec 08             	sub    $0x8,%esp
80101dcf:	6a 01                	push   $0x1
80101dd1:	ff 75 08             	pushl  0x8(%ebp)
80101dd4:	e8 f7 e2 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101dd9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101ddc:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101dde:	8d 40 5c             	lea    0x5c(%eax),%eax
80101de1:	6a 1c                	push   $0x1c
80101de3:	50                   	push   %eax
80101de4:	56                   	push   %esi
80101de5:	e8 e6 31 00 00       	call   80104fd0 <memmove>
  brelse(bp);
80101dea:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ded:	83 c4 10             	add    $0x10,%esp
}
80101df0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101df3:	5b                   	pop    %ebx
80101df4:	5e                   	pop    %esi
80101df5:	5d                   	pop    %ebp
  brelse(bp);
80101df6:	e9 f5 e3 ff ff       	jmp    801001f0 <brelse>
80101dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dff:	90                   	nop

80101e00 <iinit>:
{
80101e00:	f3 0f 1e fb          	endbr32 
80101e04:	55                   	push   %ebp
80101e05:	89 e5                	mov    %esp,%ebp
80101e07:	53                   	push   %ebx
80101e08:	bb e0 1f 11 80       	mov    $0x80111fe0,%ebx
80101e0d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101e10:	68 27 7b 10 80       	push   $0x80107b27
80101e15:	68 a0 1f 11 80       	push   $0x80111fa0
80101e1a:	e8 81 2e 00 00       	call   80104ca0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101e1f:	83 c4 10             	add    $0x10,%esp
80101e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101e28:	83 ec 08             	sub    $0x8,%esp
80101e2b:	68 2e 7b 10 80       	push   $0x80107b2e
80101e30:	53                   	push   %ebx
80101e31:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101e37:	e8 24 2d 00 00       	call   80104b60 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101e3c:	83 c4 10             	add    $0x10,%esp
80101e3f:	81 fb 00 3c 11 80    	cmp    $0x80113c00,%ebx
80101e45:	75 e1                	jne    80101e28 <iinit+0x28>
  readsb(dev, &sb);
80101e47:	83 ec 08             	sub    $0x8,%esp
80101e4a:	68 80 1f 11 80       	push   $0x80111f80
80101e4f:	ff 75 08             	pushl  0x8(%ebp)
80101e52:	e8 69 ff ff ff       	call   80101dc0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101e57:	ff 35 98 1f 11 80    	pushl  0x80111f98
80101e5d:	ff 35 94 1f 11 80    	pushl  0x80111f94
80101e63:	ff 35 90 1f 11 80    	pushl  0x80111f90
80101e69:	ff 35 8c 1f 11 80    	pushl  0x80111f8c
80101e6f:	ff 35 88 1f 11 80    	pushl  0x80111f88
80101e75:	ff 35 84 1f 11 80    	pushl  0x80111f84
80101e7b:	ff 35 80 1f 11 80    	pushl  0x80111f80
80101e81:	68 94 7b 10 80       	push   $0x80107b94
80101e86:	e8 c5 ea ff ff       	call   80100950 <cprintf>
}
80101e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e8e:	83 c4 30             	add    $0x30,%esp
80101e91:	c9                   	leave  
80101e92:	c3                   	ret    
80101e93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ea0 <ialloc>:
{
80101ea0:	f3 0f 1e fb          	endbr32 
80101ea4:	55                   	push   %ebp
80101ea5:	89 e5                	mov    %esp,%ebp
80101ea7:	57                   	push   %edi
80101ea8:	56                   	push   %esi
80101ea9:	53                   	push   %ebx
80101eaa:	83 ec 1c             	sub    $0x1c,%esp
80101ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101eb0:	83 3d 88 1f 11 80 01 	cmpl   $0x1,0x80111f88
{
80101eb7:	8b 75 08             	mov    0x8(%ebp),%esi
80101eba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101ebd:	0f 86 8d 00 00 00    	jbe    80101f50 <ialloc+0xb0>
80101ec3:	bf 01 00 00 00       	mov    $0x1,%edi
80101ec8:	eb 1d                	jmp    80101ee7 <ialloc+0x47>
80101eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101ed0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101ed3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101ed6:	53                   	push   %ebx
80101ed7:	e8 14 e3 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101edc:	83 c4 10             	add    $0x10,%esp
80101edf:	3b 3d 88 1f 11 80    	cmp    0x80111f88,%edi
80101ee5:	73 69                	jae    80101f50 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101ee7:	89 f8                	mov    %edi,%eax
80101ee9:	83 ec 08             	sub    $0x8,%esp
80101eec:	c1 e8 03             	shr    $0x3,%eax
80101eef:	03 05 94 1f 11 80    	add    0x80111f94,%eax
80101ef5:	50                   	push   %eax
80101ef6:	56                   	push   %esi
80101ef7:	e8 d4 e1 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101efc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101eff:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101f01:	89 f8                	mov    %edi,%eax
80101f03:	83 e0 07             	and    $0x7,%eax
80101f06:	c1 e0 06             	shl    $0x6,%eax
80101f09:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101f0d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101f11:	75 bd                	jne    80101ed0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101f13:	83 ec 04             	sub    $0x4,%esp
80101f16:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f19:	6a 40                	push   $0x40
80101f1b:	6a 00                	push   $0x0
80101f1d:	51                   	push   %ecx
80101f1e:	e8 0d 30 00 00       	call   80104f30 <memset>
      dip->type = type;
80101f23:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101f27:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f2a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101f2d:	89 1c 24             	mov    %ebx,(%esp)
80101f30:	e8 9b 18 00 00       	call   801037d0 <log_write>
      brelse(bp);
80101f35:	89 1c 24             	mov    %ebx,(%esp)
80101f38:	e8 b3 e2 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101f3d:	83 c4 10             	add    $0x10,%esp
}
80101f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101f43:	89 fa                	mov    %edi,%edx
}
80101f45:	5b                   	pop    %ebx
      return iget(dev, inum);
80101f46:	89 f0                	mov    %esi,%eax
}
80101f48:	5e                   	pop    %esi
80101f49:	5f                   	pop    %edi
80101f4a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101f4b:	e9 b0 fc ff ff       	jmp    80101c00 <iget>
  panic("ialloc: no inodes");
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	68 34 7b 10 80       	push   $0x80107b34
80101f58:	e8 33 e4 ff ff       	call   80100390 <panic>
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi

80101f60 <iupdate>:
{
80101f60:	f3 0f 1e fb          	endbr32 
80101f64:	55                   	push   %ebp
80101f65:	89 e5                	mov    %esp,%ebp
80101f67:	56                   	push   %esi
80101f68:	53                   	push   %ebx
80101f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f6c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f6f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f72:	83 ec 08             	sub    $0x8,%esp
80101f75:	c1 e8 03             	shr    $0x3,%eax
80101f78:	03 05 94 1f 11 80    	add    0x80111f94,%eax
80101f7e:	50                   	push   %eax
80101f7f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101f82:	e8 49 e1 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101f87:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f8b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f8e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101f90:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101f93:	83 e0 07             	and    $0x7,%eax
80101f96:	c1 e0 06             	shl    $0x6,%eax
80101f99:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101f9d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101fa0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101fa4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101fa7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101fab:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101faf:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101fb3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101fb7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101fbb:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101fbe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101fc1:	6a 34                	push   $0x34
80101fc3:	53                   	push   %ebx
80101fc4:	50                   	push   %eax
80101fc5:	e8 06 30 00 00       	call   80104fd0 <memmove>
  log_write(bp);
80101fca:	89 34 24             	mov    %esi,(%esp)
80101fcd:	e8 fe 17 00 00       	call   801037d0 <log_write>
  brelse(bp);
80101fd2:	89 75 08             	mov    %esi,0x8(%ebp)
80101fd5:	83 c4 10             	add    $0x10,%esp
}
80101fd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
  brelse(bp);
80101fde:	e9 0d e2 ff ff       	jmp    801001f0 <brelse>
80101fe3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ff0 <idup>:
{
80101ff0:	f3 0f 1e fb          	endbr32 
80101ff4:	55                   	push   %ebp
80101ff5:	89 e5                	mov    %esp,%ebp
80101ff7:	53                   	push   %ebx
80101ff8:	83 ec 10             	sub    $0x10,%esp
80101ffb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101ffe:	68 a0 1f 11 80       	push   $0x80111fa0
80102003:	e8 18 2e 00 00       	call   80104e20 <acquire>
  ip->ref++;
80102008:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010200c:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
80102013:	e8 c8 2e 00 00       	call   80104ee0 <release>
}
80102018:	89 d8                	mov    %ebx,%eax
8010201a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010201d:	c9                   	leave  
8010201e:	c3                   	ret    
8010201f:	90                   	nop

80102020 <ilock>:
{
80102020:	f3 0f 1e fb          	endbr32 
80102024:	55                   	push   %ebp
80102025:	89 e5                	mov    %esp,%ebp
80102027:	56                   	push   %esi
80102028:	53                   	push   %ebx
80102029:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010202c:	85 db                	test   %ebx,%ebx
8010202e:	0f 84 b3 00 00 00    	je     801020e7 <ilock+0xc7>
80102034:	8b 53 08             	mov    0x8(%ebx),%edx
80102037:	85 d2                	test   %edx,%edx
80102039:	0f 8e a8 00 00 00    	jle    801020e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010203f:	83 ec 0c             	sub    $0xc,%esp
80102042:	8d 43 0c             	lea    0xc(%ebx),%eax
80102045:	50                   	push   %eax
80102046:	e8 55 2b 00 00       	call   80104ba0 <acquiresleep>
  if(ip->valid == 0){
8010204b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	85 c0                	test   %eax,%eax
80102053:	74 0b                	je     80102060 <ilock+0x40>
}
80102055:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102058:	5b                   	pop    %ebx
80102059:	5e                   	pop    %esi
8010205a:	5d                   	pop    %ebp
8010205b:	c3                   	ret    
8010205c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102060:	8b 43 04             	mov    0x4(%ebx),%eax
80102063:	83 ec 08             	sub    $0x8,%esp
80102066:	c1 e8 03             	shr    $0x3,%eax
80102069:	03 05 94 1f 11 80    	add    0x80111f94,%eax
8010206f:	50                   	push   %eax
80102070:	ff 33                	pushl  (%ebx)
80102072:	e8 59 e0 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102077:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010207a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010207c:	8b 43 04             	mov    0x4(%ebx),%eax
8010207f:	83 e0 07             	and    $0x7,%eax
80102082:	c1 e0 06             	shl    $0x6,%eax
80102085:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102089:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010208c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010208f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102093:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102097:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010209b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010209f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801020a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801020a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801020ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801020ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801020b1:	6a 34                	push   $0x34
801020b3:	50                   	push   %eax
801020b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801020b7:	50                   	push   %eax
801020b8:	e8 13 2f 00 00       	call   80104fd0 <memmove>
    brelse(bp);
801020bd:	89 34 24             	mov    %esi,(%esp)
801020c0:	e8 2b e1 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801020c5:	83 c4 10             	add    $0x10,%esp
801020c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801020cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801020d4:	0f 85 7b ff ff ff    	jne    80102055 <ilock+0x35>
      panic("ilock: no type");
801020da:	83 ec 0c             	sub    $0xc,%esp
801020dd:	68 4c 7b 10 80       	push   $0x80107b4c
801020e2:	e8 a9 e2 ff ff       	call   80100390 <panic>
    panic("ilock");
801020e7:	83 ec 0c             	sub    $0xc,%esp
801020ea:	68 46 7b 10 80       	push   $0x80107b46
801020ef:	e8 9c e2 ff ff       	call   80100390 <panic>
801020f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020ff:	90                   	nop

80102100 <iunlock>:
{
80102100:	f3 0f 1e fb          	endbr32 
80102104:	55                   	push   %ebp
80102105:	89 e5                	mov    %esp,%ebp
80102107:	56                   	push   %esi
80102108:	53                   	push   %ebx
80102109:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010210c:	85 db                	test   %ebx,%ebx
8010210e:	74 28                	je     80102138 <iunlock+0x38>
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	8d 73 0c             	lea    0xc(%ebx),%esi
80102116:	56                   	push   %esi
80102117:	e8 24 2b 00 00       	call   80104c40 <holdingsleep>
8010211c:	83 c4 10             	add    $0x10,%esp
8010211f:	85 c0                	test   %eax,%eax
80102121:	74 15                	je     80102138 <iunlock+0x38>
80102123:	8b 43 08             	mov    0x8(%ebx),%eax
80102126:	85 c0                	test   %eax,%eax
80102128:	7e 0e                	jle    80102138 <iunlock+0x38>
  releasesleep(&ip->lock);
8010212a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010212d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102130:	5b                   	pop    %ebx
80102131:	5e                   	pop    %esi
80102132:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80102133:	e9 c8 2a 00 00       	jmp    80104c00 <releasesleep>
    panic("iunlock");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 5b 7b 10 80       	push   $0x80107b5b
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
80102145:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102150 <iput>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	57                   	push   %edi
80102158:	56                   	push   %esi
80102159:	53                   	push   %ebx
8010215a:	83 ec 28             	sub    $0x28,%esp
8010215d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102160:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102163:	57                   	push   %edi
80102164:	e8 37 2a 00 00       	call   80104ba0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102169:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010216c:	83 c4 10             	add    $0x10,%esp
8010216f:	85 d2                	test   %edx,%edx
80102171:	74 07                	je     8010217a <iput+0x2a>
80102173:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102178:	74 36                	je     801021b0 <iput+0x60>
  releasesleep(&ip->lock);
8010217a:	83 ec 0c             	sub    $0xc,%esp
8010217d:	57                   	push   %edi
8010217e:	e8 7d 2a 00 00       	call   80104c00 <releasesleep>
  acquire(&icache.lock);
80102183:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
8010218a:	e8 91 2c 00 00       	call   80104e20 <acquire>
  ip->ref--;
8010218f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102193:	83 c4 10             	add    $0x10,%esp
80102196:	c7 45 08 a0 1f 11 80 	movl   $0x80111fa0,0x8(%ebp)
}
8010219d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a0:	5b                   	pop    %ebx
801021a1:	5e                   	pop    %esi
801021a2:	5f                   	pop    %edi
801021a3:	5d                   	pop    %ebp
  release(&icache.lock);
801021a4:	e9 37 2d 00 00       	jmp    80104ee0 <release>
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801021b0:	83 ec 0c             	sub    $0xc,%esp
801021b3:	68 a0 1f 11 80       	push   $0x80111fa0
801021b8:	e8 63 2c 00 00       	call   80104e20 <acquire>
    int r = ip->ref;
801021bd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801021c0:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
801021c7:	e8 14 2d 00 00       	call   80104ee0 <release>
    if(r == 1){
801021cc:	83 c4 10             	add    $0x10,%esp
801021cf:	83 fe 01             	cmp    $0x1,%esi
801021d2:	75 a6                	jne    8010217a <iput+0x2a>
801021d4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801021da:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801021dd:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021e0:	89 cf                	mov    %ecx,%edi
801021e2:	eb 0b                	jmp    801021ef <iput+0x9f>
801021e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801021e8:	83 c6 04             	add    $0x4,%esi
801021eb:	39 fe                	cmp    %edi,%esi
801021ed:	74 19                	je     80102208 <iput+0xb8>
    if(ip->addrs[i]){
801021ef:	8b 16                	mov    (%esi),%edx
801021f1:	85 d2                	test   %edx,%edx
801021f3:	74 f3                	je     801021e8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
801021f5:	8b 03                	mov    (%ebx),%eax
801021f7:	e8 74 f8 ff ff       	call   80101a70 <bfree>
      ip->addrs[i] = 0;
801021fc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102202:	eb e4                	jmp    801021e8 <iput+0x98>
80102204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80102208:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010220e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102211:	85 c0                	test   %eax,%eax
80102213:	75 33                	jne    80102248 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80102215:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80102218:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010221f:	53                   	push   %ebx
80102220:	e8 3b fd ff ff       	call   80101f60 <iupdate>
      ip->type = 0;
80102225:	31 c0                	xor    %eax,%eax
80102227:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010222b:	89 1c 24             	mov    %ebx,(%esp)
8010222e:	e8 2d fd ff ff       	call   80101f60 <iupdate>
      ip->valid = 0;
80102233:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	e9 38 ff ff ff       	jmp    8010217a <iput+0x2a>
80102242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102248:	83 ec 08             	sub    $0x8,%esp
8010224b:	50                   	push   %eax
8010224c:	ff 33                	pushl  (%ebx)
8010224e:	e8 7d de ff ff       	call   801000d0 <bread>
80102253:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102256:	83 c4 10             	add    $0x10,%esp
80102259:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010225f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102262:	8d 70 5c             	lea    0x5c(%eax),%esi
80102265:	89 cf                	mov    %ecx,%edi
80102267:	eb 0e                	jmp    80102277 <iput+0x127>
80102269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102270:	83 c6 04             	add    $0x4,%esi
80102273:	39 f7                	cmp    %esi,%edi
80102275:	74 19                	je     80102290 <iput+0x140>
      if(a[j])
80102277:	8b 16                	mov    (%esi),%edx
80102279:	85 d2                	test   %edx,%edx
8010227b:	74 f3                	je     80102270 <iput+0x120>
        bfree(ip->dev, a[j]);
8010227d:	8b 03                	mov    (%ebx),%eax
8010227f:	e8 ec f7 ff ff       	call   80101a70 <bfree>
80102284:	eb ea                	jmp    80102270 <iput+0x120>
80102286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102290:	83 ec 0c             	sub    $0xc,%esp
80102293:	ff 75 e4             	pushl  -0x1c(%ebp)
80102296:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102299:	e8 52 df ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010229e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801022a4:	8b 03                	mov    (%ebx),%eax
801022a6:	e8 c5 f7 ff ff       	call   80101a70 <bfree>
    ip->addrs[NDIRECT] = 0;
801022ab:	83 c4 10             	add    $0x10,%esp
801022ae:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801022b5:	00 00 00 
801022b8:	e9 58 ff ff ff       	jmp    80102215 <iput+0xc5>
801022bd:	8d 76 00             	lea    0x0(%esi),%esi

801022c0 <iunlockput>:
{
801022c0:	f3 0f 1e fb          	endbr32 
801022c4:	55                   	push   %ebp
801022c5:	89 e5                	mov    %esp,%ebp
801022c7:	53                   	push   %ebx
801022c8:	83 ec 10             	sub    $0x10,%esp
801022cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801022ce:	53                   	push   %ebx
801022cf:	e8 2c fe ff ff       	call   80102100 <iunlock>
  iput(ip);
801022d4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801022d7:	83 c4 10             	add    $0x10,%esp
}
801022da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022dd:	c9                   	leave  
  iput(ip);
801022de:	e9 6d fe ff ff       	jmp    80102150 <iput>
801022e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022f0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801022f0:	f3 0f 1e fb          	endbr32 
801022f4:	55                   	push   %ebp
801022f5:	89 e5                	mov    %esp,%ebp
801022f7:	8b 55 08             	mov    0x8(%ebp),%edx
801022fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801022fd:	8b 0a                	mov    (%edx),%ecx
801022ff:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80102302:	8b 4a 04             	mov    0x4(%edx),%ecx
80102305:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80102308:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
8010230c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010230f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80102313:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80102317:	8b 52 58             	mov    0x58(%edx),%edx
8010231a:	89 50 10             	mov    %edx,0x10(%eax)
}
8010231d:	5d                   	pop    %ebp
8010231e:	c3                   	ret    
8010231f:	90                   	nop

80102320 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102320:	f3 0f 1e fb          	endbr32 
80102324:	55                   	push   %ebp
80102325:	89 e5                	mov    %esp,%ebp
80102327:	57                   	push   %edi
80102328:	56                   	push   %esi
80102329:	53                   	push   %ebx
8010232a:	83 ec 1c             	sub    $0x1c,%esp
8010232d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102330:	8b 45 08             	mov    0x8(%ebp),%eax
80102333:	8b 75 10             	mov    0x10(%ebp),%esi
80102336:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102339:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010233c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102341:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102344:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80102347:	0f 84 a3 00 00 00    	je     801023f0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
8010234d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102350:	8b 40 58             	mov    0x58(%eax),%eax
80102353:	39 c6                	cmp    %eax,%esi
80102355:	0f 87 b6 00 00 00    	ja     80102411 <readi+0xf1>
8010235b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010235e:	31 c9                	xor    %ecx,%ecx
80102360:	89 da                	mov    %ebx,%edx
80102362:	01 f2                	add    %esi,%edx
80102364:	0f 92 c1             	setb   %cl
80102367:	89 cf                	mov    %ecx,%edi
80102369:	0f 82 a2 00 00 00    	jb     80102411 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010236f:	89 c1                	mov    %eax,%ecx
80102371:	29 f1                	sub    %esi,%ecx
80102373:	39 d0                	cmp    %edx,%eax
80102375:	0f 43 cb             	cmovae %ebx,%ecx
80102378:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010237b:	85 c9                	test   %ecx,%ecx
8010237d:	74 63                	je     801023e2 <readi+0xc2>
8010237f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102380:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102383:	89 f2                	mov    %esi,%edx
80102385:	c1 ea 09             	shr    $0x9,%edx
80102388:	89 d8                	mov    %ebx,%eax
8010238a:	e8 61 f9 ff ff       	call   80101cf0 <bmap>
8010238f:	83 ec 08             	sub    $0x8,%esp
80102392:	50                   	push   %eax
80102393:	ff 33                	pushl  (%ebx)
80102395:	e8 36 dd ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010239a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010239d:	b9 00 02 00 00       	mov    $0x200,%ecx
801023a2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801023a5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801023a7:	89 f0                	mov    %esi,%eax
801023a9:	25 ff 01 00 00       	and    $0x1ff,%eax
801023ae:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801023b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801023b3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
801023b5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801023b9:	39 d9                	cmp    %ebx,%ecx
801023bb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801023be:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801023bf:	01 df                	add    %ebx,%edi
801023c1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
801023c3:	50                   	push   %eax
801023c4:	ff 75 e0             	pushl  -0x20(%ebp)
801023c7:	e8 04 2c 00 00       	call   80104fd0 <memmove>
    brelse(bp);
801023cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801023cf:	89 14 24             	mov    %edx,(%esp)
801023d2:	e8 19 de ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801023d7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801023da:	83 c4 10             	add    $0x10,%esp
801023dd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801023e0:	77 9e                	ja     80102380 <readi+0x60>
  }
  return n;
801023e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801023e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023e8:	5b                   	pop    %ebx
801023e9:	5e                   	pop    %esi
801023ea:	5f                   	pop    %edi
801023eb:	5d                   	pop    %ebp
801023ec:	c3                   	ret    
801023ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801023f0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801023f4:	66 83 f8 09          	cmp    $0x9,%ax
801023f8:	77 17                	ja     80102411 <readi+0xf1>
801023fa:	8b 04 c5 20 1f 11 80 	mov    -0x7feee0e0(,%eax,8),%eax
80102401:	85 c0                	test   %eax,%eax
80102403:	74 0c                	je     80102411 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102405:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102408:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010240b:	5b                   	pop    %ebx
8010240c:	5e                   	pop    %esi
8010240d:	5f                   	pop    %edi
8010240e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010240f:	ff e0                	jmp    *%eax
      return -1;
80102411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102416:	eb cd                	jmp    801023e5 <readi+0xc5>
80102418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop

80102420 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102420:	f3 0f 1e fb          	endbr32 
80102424:	55                   	push   %ebp
80102425:	89 e5                	mov    %esp,%ebp
80102427:	57                   	push   %edi
80102428:	56                   	push   %esi
80102429:	53                   	push   %ebx
8010242a:	83 ec 1c             	sub    $0x1c,%esp
8010242d:	8b 45 08             	mov    0x8(%ebp),%eax
80102430:	8b 75 0c             	mov    0xc(%ebp),%esi
80102433:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102436:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010243b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010243e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102441:	8b 75 10             	mov    0x10(%ebp),%esi
80102444:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80102447:	0f 84 b3 00 00 00    	je     80102500 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
8010244d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102450:	39 70 58             	cmp    %esi,0x58(%eax)
80102453:	0f 82 e3 00 00 00    	jb     8010253c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102459:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010245c:	89 f8                	mov    %edi,%eax
8010245e:	01 f0                	add    %esi,%eax
80102460:	0f 82 d6 00 00 00    	jb     8010253c <writei+0x11c>
80102466:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010246b:	0f 87 cb 00 00 00    	ja     8010253c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102471:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102478:	85 ff                	test   %edi,%edi
8010247a:	74 75                	je     801024f1 <writei+0xd1>
8010247c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102480:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102483:	89 f2                	mov    %esi,%edx
80102485:	c1 ea 09             	shr    $0x9,%edx
80102488:	89 f8                	mov    %edi,%eax
8010248a:	e8 61 f8 ff ff       	call   80101cf0 <bmap>
8010248f:	83 ec 08             	sub    $0x8,%esp
80102492:	50                   	push   %eax
80102493:	ff 37                	pushl  (%edi)
80102495:	e8 36 dc ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010249a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010249f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801024a2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801024a5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801024a7:	89 f0                	mov    %esi,%eax
801024a9:	83 c4 0c             	add    $0xc,%esp
801024ac:	25 ff 01 00 00       	and    $0x1ff,%eax
801024b1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801024b3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801024b7:	39 d9                	cmp    %ebx,%ecx
801024b9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801024bc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801024bd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801024bf:	ff 75 dc             	pushl  -0x24(%ebp)
801024c2:	50                   	push   %eax
801024c3:	e8 08 2b 00 00       	call   80104fd0 <memmove>
    log_write(bp);
801024c8:	89 3c 24             	mov    %edi,(%esp)
801024cb:	e8 00 13 00 00       	call   801037d0 <log_write>
    brelse(bp);
801024d0:	89 3c 24             	mov    %edi,(%esp)
801024d3:	e8 18 dd ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801024d8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801024db:	83 c4 10             	add    $0x10,%esp
801024de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801024e1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801024e4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801024e7:	77 97                	ja     80102480 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801024e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801024ec:	3b 70 58             	cmp    0x58(%eax),%esi
801024ef:	77 37                	ja     80102528 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801024f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801024f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024f7:	5b                   	pop    %ebx
801024f8:	5e                   	pop    %esi
801024f9:	5f                   	pop    %edi
801024fa:	5d                   	pop    %ebp
801024fb:	c3                   	ret    
801024fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102500:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102504:	66 83 f8 09          	cmp    $0x9,%ax
80102508:	77 32                	ja     8010253c <writei+0x11c>
8010250a:	8b 04 c5 24 1f 11 80 	mov    -0x7feee0dc(,%eax,8),%eax
80102511:	85 c0                	test   %eax,%eax
80102513:	74 27                	je     8010253c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102515:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010251b:	5b                   	pop    %ebx
8010251c:	5e                   	pop    %esi
8010251d:	5f                   	pop    %edi
8010251e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010251f:	ff e0                	jmp    *%eax
80102521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102528:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010252b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010252e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102531:	50                   	push   %eax
80102532:	e8 29 fa ff ff       	call   80101f60 <iupdate>
80102537:	83 c4 10             	add    $0x10,%esp
8010253a:	eb b5                	jmp    801024f1 <writei+0xd1>
      return -1;
8010253c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102541:	eb b1                	jmp    801024f4 <writei+0xd4>
80102543:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102550 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102550:	f3 0f 1e fb          	endbr32 
80102554:	55                   	push   %ebp
80102555:	89 e5                	mov    %esp,%ebp
80102557:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010255a:	6a 0e                	push   $0xe
8010255c:	ff 75 0c             	pushl  0xc(%ebp)
8010255f:	ff 75 08             	pushl  0x8(%ebp)
80102562:	e8 d9 2a 00 00       	call   80105040 <strncmp>
}
80102567:	c9                   	leave  
80102568:	c3                   	ret    
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102570 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	57                   	push   %edi
80102578:	56                   	push   %esi
80102579:	53                   	push   %ebx
8010257a:	83 ec 1c             	sub    $0x1c,%esp
8010257d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102580:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102585:	0f 85 89 00 00 00    	jne    80102614 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010258b:	8b 53 58             	mov    0x58(%ebx),%edx
8010258e:	31 ff                	xor    %edi,%edi
80102590:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102593:	85 d2                	test   %edx,%edx
80102595:	74 42                	je     801025d9 <dirlookup+0x69>
80102597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025a0:	6a 10                	push   $0x10
801025a2:	57                   	push   %edi
801025a3:	56                   	push   %esi
801025a4:	53                   	push   %ebx
801025a5:	e8 76 fd ff ff       	call   80102320 <readi>
801025aa:	83 c4 10             	add    $0x10,%esp
801025ad:	83 f8 10             	cmp    $0x10,%eax
801025b0:	75 55                	jne    80102607 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
801025b2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801025b7:	74 18                	je     801025d1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
801025b9:	83 ec 04             	sub    $0x4,%esp
801025bc:	8d 45 da             	lea    -0x26(%ebp),%eax
801025bf:	6a 0e                	push   $0xe
801025c1:	50                   	push   %eax
801025c2:	ff 75 0c             	pushl  0xc(%ebp)
801025c5:	e8 76 2a 00 00       	call   80105040 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801025ca:	83 c4 10             	add    $0x10,%esp
801025cd:	85 c0                	test   %eax,%eax
801025cf:	74 17                	je     801025e8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801025d1:	83 c7 10             	add    $0x10,%edi
801025d4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801025d7:	72 c7                	jb     801025a0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801025d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801025dc:	31 c0                	xor    %eax,%eax
}
801025de:	5b                   	pop    %ebx
801025df:	5e                   	pop    %esi
801025e0:	5f                   	pop    %edi
801025e1:	5d                   	pop    %ebp
801025e2:	c3                   	ret    
801025e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025e7:	90                   	nop
      if(poff)
801025e8:	8b 45 10             	mov    0x10(%ebp),%eax
801025eb:	85 c0                	test   %eax,%eax
801025ed:	74 05                	je     801025f4 <dirlookup+0x84>
        *poff = off;
801025ef:	8b 45 10             	mov    0x10(%ebp),%eax
801025f2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801025f4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801025f8:	8b 03                	mov    (%ebx),%eax
801025fa:	e8 01 f6 ff ff       	call   80101c00 <iget>
}
801025ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102602:	5b                   	pop    %ebx
80102603:	5e                   	pop    %esi
80102604:	5f                   	pop    %edi
80102605:	5d                   	pop    %ebp
80102606:	c3                   	ret    
      panic("dirlookup read");
80102607:	83 ec 0c             	sub    $0xc,%esp
8010260a:	68 75 7b 10 80       	push   $0x80107b75
8010260f:	e8 7c dd ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102614:	83 ec 0c             	sub    $0xc,%esp
80102617:	68 63 7b 10 80       	push   $0x80107b63
8010261c:	e8 6f dd ff ff       	call   80100390 <panic>
80102621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262f:	90                   	nop

80102630 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	57                   	push   %edi
80102634:	56                   	push   %esi
80102635:	53                   	push   %ebx
80102636:	89 c3                	mov    %eax,%ebx
80102638:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010263b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010263e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102641:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102644:	0f 84 86 01 00 00    	je     801027d0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010264a:	e8 d1 1b 00 00       	call   80104220 <myproc>
  acquire(&icache.lock);
8010264f:	83 ec 0c             	sub    $0xc,%esp
80102652:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102654:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102657:	68 a0 1f 11 80       	push   $0x80111fa0
8010265c:	e8 bf 27 00 00       	call   80104e20 <acquire>
  ip->ref++;
80102661:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102665:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
8010266c:	e8 6f 28 00 00       	call   80104ee0 <release>
80102671:	83 c4 10             	add    $0x10,%esp
80102674:	eb 0d                	jmp    80102683 <namex+0x53>
80102676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102680:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102683:	0f b6 07             	movzbl (%edi),%eax
80102686:	3c 2f                	cmp    $0x2f,%al
80102688:	74 f6                	je     80102680 <namex+0x50>
  if(*path == 0)
8010268a:	84 c0                	test   %al,%al
8010268c:	0f 84 ee 00 00 00    	je     80102780 <namex+0x150>
  while(*path != '/' && *path != 0)
80102692:	0f b6 07             	movzbl (%edi),%eax
80102695:	84 c0                	test   %al,%al
80102697:	0f 84 fb 00 00 00    	je     80102798 <namex+0x168>
8010269d:	89 fb                	mov    %edi,%ebx
8010269f:	3c 2f                	cmp    $0x2f,%al
801026a1:	0f 84 f1 00 00 00    	je     80102798 <namex+0x168>
801026a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ae:	66 90                	xchg   %ax,%ax
801026b0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
801026b4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801026b7:	3c 2f                	cmp    $0x2f,%al
801026b9:	74 04                	je     801026bf <namex+0x8f>
801026bb:	84 c0                	test   %al,%al
801026bd:	75 f1                	jne    801026b0 <namex+0x80>
  len = path - s;
801026bf:	89 d8                	mov    %ebx,%eax
801026c1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801026c3:	83 f8 0d             	cmp    $0xd,%eax
801026c6:	0f 8e 84 00 00 00    	jle    80102750 <namex+0x120>
    memmove(name, s, DIRSIZ);
801026cc:	83 ec 04             	sub    $0x4,%esp
801026cf:	6a 0e                	push   $0xe
801026d1:	57                   	push   %edi
    path++;
801026d2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801026d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801026d7:	e8 f4 28 00 00       	call   80104fd0 <memmove>
801026dc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801026df:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801026e2:	75 0c                	jne    801026f0 <namex+0xc0>
801026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801026e8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801026eb:	80 3f 2f             	cmpb   $0x2f,(%edi)
801026ee:	74 f8                	je     801026e8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	56                   	push   %esi
801026f4:	e8 27 f9 ff ff       	call   80102020 <ilock>
    if(ip->type != T_DIR){
801026f9:	83 c4 10             	add    $0x10,%esp
801026fc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102701:	0f 85 a1 00 00 00    	jne    801027a8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102707:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010270a:	85 d2                	test   %edx,%edx
8010270c:	74 09                	je     80102717 <namex+0xe7>
8010270e:	80 3f 00             	cmpb   $0x0,(%edi)
80102711:	0f 84 d9 00 00 00    	je     801027f0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102717:	83 ec 04             	sub    $0x4,%esp
8010271a:	6a 00                	push   $0x0
8010271c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010271f:	56                   	push   %esi
80102720:	e8 4b fe ff ff       	call   80102570 <dirlookup>
80102725:	83 c4 10             	add    $0x10,%esp
80102728:	89 c3                	mov    %eax,%ebx
8010272a:	85 c0                	test   %eax,%eax
8010272c:	74 7a                	je     801027a8 <namex+0x178>
  iunlock(ip);
8010272e:	83 ec 0c             	sub    $0xc,%esp
80102731:	56                   	push   %esi
80102732:	e8 c9 f9 ff ff       	call   80102100 <iunlock>
  iput(ip);
80102737:	89 34 24             	mov    %esi,(%esp)
8010273a:	89 de                	mov    %ebx,%esi
8010273c:	e8 0f fa ff ff       	call   80102150 <iput>
80102741:	83 c4 10             	add    $0x10,%esp
80102744:	e9 3a ff ff ff       	jmp    80102683 <namex+0x53>
80102749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102750:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102753:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102756:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102759:	83 ec 04             	sub    $0x4,%esp
8010275c:	50                   	push   %eax
8010275d:	57                   	push   %edi
    name[len] = 0;
8010275e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102760:	ff 75 e4             	pushl  -0x1c(%ebp)
80102763:	e8 68 28 00 00       	call   80104fd0 <memmove>
    name[len] = 0;
80102768:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010276b:	83 c4 10             	add    $0x10,%esp
8010276e:	c6 00 00             	movb   $0x0,(%eax)
80102771:	e9 69 ff ff ff       	jmp    801026df <namex+0xaf>
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102780:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102783:	85 c0                	test   %eax,%eax
80102785:	0f 85 85 00 00 00    	jne    80102810 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010278b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010278e:	89 f0                	mov    %esi,%eax
80102790:	5b                   	pop    %ebx
80102791:	5e                   	pop    %esi
80102792:	5f                   	pop    %edi
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010279b:	89 fb                	mov    %edi,%ebx
8010279d:	89 45 dc             	mov    %eax,-0x24(%ebp)
801027a0:	31 c0                	xor    %eax,%eax
801027a2:	eb b5                	jmp    80102759 <namex+0x129>
801027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801027a8:	83 ec 0c             	sub    $0xc,%esp
801027ab:	56                   	push   %esi
801027ac:	e8 4f f9 ff ff       	call   80102100 <iunlock>
  iput(ip);
801027b1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801027b4:	31 f6                	xor    %esi,%esi
  iput(ip);
801027b6:	e8 95 f9 ff ff       	call   80102150 <iput>
      return 0;
801027bb:	83 c4 10             	add    $0x10,%esp
}
801027be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027c1:	89 f0                	mov    %esi,%eax
801027c3:	5b                   	pop    %ebx
801027c4:	5e                   	pop    %esi
801027c5:	5f                   	pop    %edi
801027c6:	5d                   	pop    %ebp
801027c7:	c3                   	ret    
801027c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cf:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801027d0:	ba 01 00 00 00       	mov    $0x1,%edx
801027d5:	b8 01 00 00 00       	mov    $0x1,%eax
801027da:	89 df                	mov    %ebx,%edi
801027dc:	e8 1f f4 ff ff       	call   80101c00 <iget>
801027e1:	89 c6                	mov    %eax,%esi
801027e3:	e9 9b fe ff ff       	jmp    80102683 <namex+0x53>
801027e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ef:	90                   	nop
      iunlock(ip);
801027f0:	83 ec 0c             	sub    $0xc,%esp
801027f3:	56                   	push   %esi
801027f4:	e8 07 f9 ff ff       	call   80102100 <iunlock>
      return ip;
801027f9:	83 c4 10             	add    $0x10,%esp
}
801027fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027ff:	89 f0                	mov    %esi,%eax
80102801:	5b                   	pop    %ebx
80102802:	5e                   	pop    %esi
80102803:	5f                   	pop    %edi
80102804:	5d                   	pop    %ebp
80102805:	c3                   	ret    
80102806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010280d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102810:	83 ec 0c             	sub    $0xc,%esp
80102813:	56                   	push   %esi
    return 0;
80102814:	31 f6                	xor    %esi,%esi
    iput(ip);
80102816:	e8 35 f9 ff ff       	call   80102150 <iput>
    return 0;
8010281b:	83 c4 10             	add    $0x10,%esp
8010281e:	e9 68 ff ff ff       	jmp    8010278b <namex+0x15b>
80102823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102830 <dirlink>:
{
80102830:	f3 0f 1e fb          	endbr32 
80102834:	55                   	push   %ebp
80102835:	89 e5                	mov    %esp,%ebp
80102837:	57                   	push   %edi
80102838:	56                   	push   %esi
80102839:	53                   	push   %ebx
8010283a:	83 ec 20             	sub    $0x20,%esp
8010283d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102840:	6a 00                	push   $0x0
80102842:	ff 75 0c             	pushl  0xc(%ebp)
80102845:	53                   	push   %ebx
80102846:	e8 25 fd ff ff       	call   80102570 <dirlookup>
8010284b:	83 c4 10             	add    $0x10,%esp
8010284e:	85 c0                	test   %eax,%eax
80102850:	75 6b                	jne    801028bd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102852:	8b 7b 58             	mov    0x58(%ebx),%edi
80102855:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102858:	85 ff                	test   %edi,%edi
8010285a:	74 2d                	je     80102889 <dirlink+0x59>
8010285c:	31 ff                	xor    %edi,%edi
8010285e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102861:	eb 0d                	jmp    80102870 <dirlink+0x40>
80102863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102867:	90                   	nop
80102868:	83 c7 10             	add    $0x10,%edi
8010286b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010286e:	73 19                	jae    80102889 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102870:	6a 10                	push   $0x10
80102872:	57                   	push   %edi
80102873:	56                   	push   %esi
80102874:	53                   	push   %ebx
80102875:	e8 a6 fa ff ff       	call   80102320 <readi>
8010287a:	83 c4 10             	add    $0x10,%esp
8010287d:	83 f8 10             	cmp    $0x10,%eax
80102880:	75 4e                	jne    801028d0 <dirlink+0xa0>
    if(de.inum == 0)
80102882:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102887:	75 df                	jne    80102868 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102889:	83 ec 04             	sub    $0x4,%esp
8010288c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010288f:	6a 0e                	push   $0xe
80102891:	ff 75 0c             	pushl  0xc(%ebp)
80102894:	50                   	push   %eax
80102895:	e8 f6 27 00 00       	call   80105090 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010289a:	6a 10                	push   $0x10
  de.inum = inum;
8010289c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010289f:	57                   	push   %edi
801028a0:	56                   	push   %esi
801028a1:	53                   	push   %ebx
  de.inum = inum;
801028a2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801028a6:	e8 75 fb ff ff       	call   80102420 <writei>
801028ab:	83 c4 20             	add    $0x20,%esp
801028ae:	83 f8 10             	cmp    $0x10,%eax
801028b1:	75 2a                	jne    801028dd <dirlink+0xad>
  return 0;
801028b3:	31 c0                	xor    %eax,%eax
}
801028b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028b8:	5b                   	pop    %ebx
801028b9:	5e                   	pop    %esi
801028ba:	5f                   	pop    %edi
801028bb:	5d                   	pop    %ebp
801028bc:	c3                   	ret    
    iput(ip);
801028bd:	83 ec 0c             	sub    $0xc,%esp
801028c0:	50                   	push   %eax
801028c1:	e8 8a f8 ff ff       	call   80102150 <iput>
    return -1;
801028c6:	83 c4 10             	add    $0x10,%esp
801028c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801028ce:	eb e5                	jmp    801028b5 <dirlink+0x85>
      panic("dirlink read");
801028d0:	83 ec 0c             	sub    $0xc,%esp
801028d3:	68 84 7b 10 80       	push   $0x80107b84
801028d8:	e8 b3 da ff ff       	call   80100390 <panic>
    panic("dirlink");
801028dd:	83 ec 0c             	sub    $0xc,%esp
801028e0:	68 5e 81 10 80       	push   $0x8010815e
801028e5:	e8 a6 da ff ff       	call   80100390 <panic>
801028ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028f0 <namei>:

struct inode*
namei(char *path)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801028f5:	31 d2                	xor    %edx,%edx
{
801028f7:	89 e5                	mov    %esp,%ebp
801028f9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801028fc:	8b 45 08             	mov    0x8(%ebp),%eax
801028ff:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102902:	e8 29 fd ff ff       	call   80102630 <namex>
}
80102907:	c9                   	leave  
80102908:	c3                   	ret    
80102909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102910 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102910:	f3 0f 1e fb          	endbr32 
80102914:	55                   	push   %ebp
  return namex(path, 1, name);
80102915:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010291a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010291c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010291f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102922:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102923:	e9 08 fd ff ff       	jmp    80102630 <namex>
80102928:	66 90                	xchg   %ax,%ax
8010292a:	66 90                	xchg   %ax,%ax
8010292c:	66 90                	xchg   %ax,%ax
8010292e:	66 90                	xchg   %ax,%ax

80102930 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
80102933:	57                   	push   %edi
80102934:	56                   	push   %esi
80102935:	53                   	push   %ebx
80102936:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102939:	85 c0                	test   %eax,%eax
8010293b:	0f 84 b4 00 00 00    	je     801029f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102941:	8b 70 08             	mov    0x8(%eax),%esi
80102944:	89 c3                	mov    %eax,%ebx
80102946:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010294c:	0f 87 96 00 00 00    	ja     801029e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102952:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295e:	66 90                	xchg   %ax,%ax
80102960:	89 ca                	mov    %ecx,%edx
80102962:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102963:	83 e0 c0             	and    $0xffffffc0,%eax
80102966:	3c 40                	cmp    $0x40,%al
80102968:	75 f6                	jne    80102960 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010296a:	31 ff                	xor    %edi,%edi
8010296c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102971:	89 f8                	mov    %edi,%eax
80102973:	ee                   	out    %al,(%dx)
80102974:	b8 01 00 00 00       	mov    $0x1,%eax
80102979:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010297e:	ee                   	out    %al,(%dx)
8010297f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102984:	89 f0                	mov    %esi,%eax
80102986:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102987:	89 f0                	mov    %esi,%eax
80102989:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010298e:	c1 f8 08             	sar    $0x8,%eax
80102991:	ee                   	out    %al,(%dx)
80102992:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102997:	89 f8                	mov    %edi,%eax
80102999:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010299a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010299e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801029a3:	c1 e0 04             	shl    $0x4,%eax
801029a6:	83 e0 10             	and    $0x10,%eax
801029a9:	83 c8 e0             	or     $0xffffffe0,%eax
801029ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801029ad:	f6 03 04             	testb  $0x4,(%ebx)
801029b0:	75 16                	jne    801029c8 <idestart+0x98>
801029b2:	b8 20 00 00 00       	mov    $0x20,%eax
801029b7:	89 ca                	mov    %ecx,%edx
801029b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801029ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029bd:	5b                   	pop    %ebx
801029be:	5e                   	pop    %esi
801029bf:	5f                   	pop    %edi
801029c0:	5d                   	pop    %ebp
801029c1:	c3                   	ret    
801029c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029c8:	b8 30 00 00 00       	mov    $0x30,%eax
801029cd:	89 ca                	mov    %ecx,%edx
801029cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801029d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801029d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801029d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801029dd:	fc                   	cld    
801029de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801029e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029e3:	5b                   	pop    %ebx
801029e4:	5e                   	pop    %esi
801029e5:	5f                   	pop    %edi
801029e6:	5d                   	pop    %ebp
801029e7:	c3                   	ret    
    panic("incorrect blockno");
801029e8:	83 ec 0c             	sub    $0xc,%esp
801029eb:	68 f0 7b 10 80       	push   $0x80107bf0
801029f0:	e8 9b d9 ff ff       	call   80100390 <panic>
    panic("idestart");
801029f5:	83 ec 0c             	sub    $0xc,%esp
801029f8:	68 e7 7b 10 80       	push   $0x80107be7
801029fd:	e8 8e d9 ff ff       	call   80100390 <panic>
80102a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a10 <ideinit>:
{
80102a10:	f3 0f 1e fb          	endbr32 
80102a14:	55                   	push   %ebp
80102a15:	89 e5                	mov    %esp,%ebp
80102a17:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102a1a:	68 02 7c 10 80       	push   $0x80107c02
80102a1f:	68 a0 b5 10 80       	push   $0x8010b5a0
80102a24:	e8 77 22 00 00       	call   80104ca0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102a29:	58                   	pop    %eax
80102a2a:	a1 c0 42 11 80       	mov    0x801142c0,%eax
80102a2f:	5a                   	pop    %edx
80102a30:	83 e8 01             	sub    $0x1,%eax
80102a33:	50                   	push   %eax
80102a34:	6a 0e                	push   $0xe
80102a36:	e8 b5 02 00 00       	call   80102cf0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102a3b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a47:	90                   	nop
80102a48:	ec                   	in     (%dx),%al
80102a49:	83 e0 c0             	and    $0xffffffc0,%eax
80102a4c:	3c 40                	cmp    $0x40,%al
80102a4e:	75 f8                	jne    80102a48 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a50:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102a55:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a5a:	ee                   	out    %al,(%dx)
80102a5b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a60:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a65:	eb 0e                	jmp    80102a75 <ideinit+0x65>
80102a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a6e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102a70:	83 e9 01             	sub    $0x1,%ecx
80102a73:	74 0f                	je     80102a84 <ideinit+0x74>
80102a75:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102a76:	84 c0                	test   %al,%al
80102a78:	74 f6                	je     80102a70 <ideinit+0x60>
      havedisk1 = 1;
80102a7a:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80102a81:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a84:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102a89:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a8e:	ee                   	out    %al,(%dx)
}
80102a8f:	c9                   	leave  
80102a90:	c3                   	ret    
80102a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop

80102aa0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102aa0:	f3 0f 1e fb          	endbr32 
80102aa4:	55                   	push   %ebp
80102aa5:	89 e5                	mov    %esp,%ebp
80102aa7:	57                   	push   %edi
80102aa8:	56                   	push   %esi
80102aa9:	53                   	push   %ebx
80102aaa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102aad:	68 a0 b5 10 80       	push   $0x8010b5a0
80102ab2:	e8 69 23 00 00       	call   80104e20 <acquire>

  if((b = idequeue) == 0){
80102ab7:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
80102abd:	83 c4 10             	add    $0x10,%esp
80102ac0:	85 db                	test   %ebx,%ebx
80102ac2:	74 5f                	je     80102b23 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102ac4:	8b 43 58             	mov    0x58(%ebx),%eax
80102ac7:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102acc:	8b 33                	mov    (%ebx),%esi
80102ace:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102ad4:	75 2b                	jne    80102b01 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102adf:	90                   	nop
80102ae0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102ae1:	89 c1                	mov    %eax,%ecx
80102ae3:	83 e1 c0             	and    $0xffffffc0,%ecx
80102ae6:	80 f9 40             	cmp    $0x40,%cl
80102ae9:	75 f5                	jne    80102ae0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102aeb:	a8 21                	test   $0x21,%al
80102aed:	75 12                	jne    80102b01 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102aef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102af2:	b9 80 00 00 00       	mov    $0x80,%ecx
80102af7:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102afc:	fc                   	cld    
80102afd:	f3 6d                	rep insl (%dx),%es:(%edi)
80102aff:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102b01:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102b04:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102b07:	83 ce 02             	or     $0x2,%esi
80102b0a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102b0c:	53                   	push   %ebx
80102b0d:	e8 8e 1e 00 00       	call   801049a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102b12:	a1 84 b5 10 80       	mov    0x8010b584,%eax
80102b17:	83 c4 10             	add    $0x10,%esp
80102b1a:	85 c0                	test   %eax,%eax
80102b1c:	74 05                	je     80102b23 <ideintr+0x83>
    idestart(idequeue);
80102b1e:	e8 0d fe ff ff       	call   80102930 <idestart>
    release(&idelock);
80102b23:	83 ec 0c             	sub    $0xc,%esp
80102b26:	68 a0 b5 10 80       	push   $0x8010b5a0
80102b2b:	e8 b0 23 00 00       	call   80104ee0 <release>

  release(&idelock);
}
80102b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b33:	5b                   	pop    %ebx
80102b34:	5e                   	pop    %esi
80102b35:	5f                   	pop    %edi
80102b36:	5d                   	pop    %ebp
80102b37:	c3                   	ret    
80102b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3f:	90                   	nop

80102b40 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102b40:	f3 0f 1e fb          	endbr32 
80102b44:	55                   	push   %ebp
80102b45:	89 e5                	mov    %esp,%ebp
80102b47:	53                   	push   %ebx
80102b48:	83 ec 10             	sub    $0x10,%esp
80102b4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102b4e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102b51:	50                   	push   %eax
80102b52:	e8 e9 20 00 00       	call   80104c40 <holdingsleep>
80102b57:	83 c4 10             	add    $0x10,%esp
80102b5a:	85 c0                	test   %eax,%eax
80102b5c:	0f 84 cf 00 00 00    	je     80102c31 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102b62:	8b 03                	mov    (%ebx),%eax
80102b64:	83 e0 06             	and    $0x6,%eax
80102b67:	83 f8 02             	cmp    $0x2,%eax
80102b6a:	0f 84 b4 00 00 00    	je     80102c24 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102b70:	8b 53 04             	mov    0x4(%ebx),%edx
80102b73:	85 d2                	test   %edx,%edx
80102b75:	74 0d                	je     80102b84 <iderw+0x44>
80102b77:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80102b7c:	85 c0                	test   %eax,%eax
80102b7e:	0f 84 93 00 00 00    	je     80102c17 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102b84:	83 ec 0c             	sub    $0xc,%esp
80102b87:	68 a0 b5 10 80       	push   $0x8010b5a0
80102b8c:	e8 8f 22 00 00       	call   80104e20 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b91:	a1 84 b5 10 80       	mov    0x8010b584,%eax
  b->qnext = 0;
80102b96:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b9d:	83 c4 10             	add    $0x10,%esp
80102ba0:	85 c0                	test   %eax,%eax
80102ba2:	74 6c                	je     80102c10 <iderw+0xd0>
80102ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ba8:	89 c2                	mov    %eax,%edx
80102baa:	8b 40 58             	mov    0x58(%eax),%eax
80102bad:	85 c0                	test   %eax,%eax
80102baf:	75 f7                	jne    80102ba8 <iderw+0x68>
80102bb1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102bb4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102bb6:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
80102bbc:	74 42                	je     80102c00 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102bbe:	8b 03                	mov    (%ebx),%eax
80102bc0:	83 e0 06             	and    $0x6,%eax
80102bc3:	83 f8 02             	cmp    $0x2,%eax
80102bc6:	74 23                	je     80102beb <iderw+0xab>
80102bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bcf:	90                   	nop
    sleep(b, &idelock);
80102bd0:	83 ec 08             	sub    $0x8,%esp
80102bd3:	68 a0 b5 10 80       	push   $0x8010b5a0
80102bd8:	53                   	push   %ebx
80102bd9:	e8 02 1c 00 00       	call   801047e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102bde:	8b 03                	mov    (%ebx),%eax
80102be0:	83 c4 10             	add    $0x10,%esp
80102be3:	83 e0 06             	and    $0x6,%eax
80102be6:	83 f8 02             	cmp    $0x2,%eax
80102be9:	75 e5                	jne    80102bd0 <iderw+0x90>
  }


  release(&idelock);
80102beb:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
80102bf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bf5:	c9                   	leave  
  release(&idelock);
80102bf6:	e9 e5 22 00 00       	jmp    80104ee0 <release>
80102bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bff:	90                   	nop
    idestart(b);
80102c00:	89 d8                	mov    %ebx,%eax
80102c02:	e8 29 fd ff ff       	call   80102930 <idestart>
80102c07:	eb b5                	jmp    80102bbe <iderw+0x7e>
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c10:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
80102c15:	eb 9d                	jmp    80102bb4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102c17:	83 ec 0c             	sub    $0xc,%esp
80102c1a:	68 31 7c 10 80       	push   $0x80107c31
80102c1f:	e8 6c d7 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102c24:	83 ec 0c             	sub    $0xc,%esp
80102c27:	68 1c 7c 10 80       	push   $0x80107c1c
80102c2c:	e8 5f d7 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102c31:	83 ec 0c             	sub    $0xc,%esp
80102c34:	68 06 7c 10 80       	push   $0x80107c06
80102c39:	e8 52 d7 ff ff       	call   80100390 <panic>
80102c3e:	66 90                	xchg   %ax,%ax

80102c40 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102c40:	f3 0f 1e fb          	endbr32 
80102c44:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102c45:	c7 05 f4 3b 11 80 00 	movl   $0xfec00000,0x80113bf4
80102c4c:	00 c0 fe 
{
80102c4f:	89 e5                	mov    %esp,%ebp
80102c51:	56                   	push   %esi
80102c52:	53                   	push   %ebx
  ioapic->reg = reg;
80102c53:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102c5a:	00 00 00 
  return ioapic->data;
80102c5d:	8b 15 f4 3b 11 80    	mov    0x80113bf4,%edx
80102c63:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102c66:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102c6c:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102c72:	0f b6 15 20 3d 11 80 	movzbl 0x80113d20,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102c79:	c1 ee 10             	shr    $0x10,%esi
80102c7c:	89 f0                	mov    %esi,%eax
80102c7e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102c81:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102c84:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102c87:	39 c2                	cmp    %eax,%edx
80102c89:	74 16                	je     80102ca1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c8b:	83 ec 0c             	sub    $0xc,%esp
80102c8e:	68 50 7c 10 80       	push   $0x80107c50
80102c93:	e8 b8 dc ff ff       	call   80100950 <cprintf>
80102c98:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
80102c9e:	83 c4 10             	add    $0x10,%esp
80102ca1:	83 c6 21             	add    $0x21,%esi
{
80102ca4:	ba 10 00 00 00       	mov    $0x10,%edx
80102ca9:	b8 20 00 00 00       	mov    $0x20,%eax
80102cae:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102cb0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102cb2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102cb4:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
80102cba:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102cbd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102cc3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102cc6:	8d 5a 01             	lea    0x1(%edx),%ebx
80102cc9:	83 c2 02             	add    $0x2,%edx
80102ccc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102cce:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
80102cd4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102cdb:	39 f0                	cmp    %esi,%eax
80102cdd:	75 d1                	jne    80102cb0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102cdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ce2:	5b                   	pop    %ebx
80102ce3:	5e                   	pop    %esi
80102ce4:	5d                   	pop    %ebp
80102ce5:	c3                   	ret    
80102ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ced:	8d 76 00             	lea    0x0(%esi),%esi

80102cf0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102cf0:	f3 0f 1e fb          	endbr32 
80102cf4:	55                   	push   %ebp
  ioapic->reg = reg;
80102cf5:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
{
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102d00:	8d 50 20             	lea    0x20(%eax),%edx
80102d03:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102d07:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102d09:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d0f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102d12:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102d18:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102d1a:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102d1f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102d22:	89 50 10             	mov    %edx,0x10(%eax)
}
80102d25:	5d                   	pop    %ebp
80102d26:	c3                   	ret    
80102d27:	66 90                	xchg   %ax,%ax
80102d29:	66 90                	xchg   %ax,%ax
80102d2b:	66 90                	xchg   %ax,%ax
80102d2d:	66 90                	xchg   %ax,%ax
80102d2f:	90                   	nop

80102d30 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	53                   	push   %ebx
80102d38:	83 ec 04             	sub    $0x4,%esp
80102d3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102d3e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102d44:	75 7a                	jne    80102dc0 <kfree+0x90>
80102d46:	81 fb 68 6a 11 80    	cmp    $0x80116a68,%ebx
80102d4c:	72 72                	jb     80102dc0 <kfree+0x90>
80102d4e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102d54:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d59:	77 65                	ja     80102dc0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d5b:	83 ec 04             	sub    $0x4,%esp
80102d5e:	68 00 10 00 00       	push   $0x1000
80102d63:	6a 01                	push   $0x1
80102d65:	53                   	push   %ebx
80102d66:	e8 c5 21 00 00       	call   80104f30 <memset>

  if(kmem.use_lock)
80102d6b:	8b 15 34 3c 11 80    	mov    0x80113c34,%edx
80102d71:	83 c4 10             	add    $0x10,%esp
80102d74:	85 d2                	test   %edx,%edx
80102d76:	75 20                	jne    80102d98 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102d78:	a1 38 3c 11 80       	mov    0x80113c38,%eax
80102d7d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102d7f:	a1 34 3c 11 80       	mov    0x80113c34,%eax
  kmem.freelist = r;
80102d84:	89 1d 38 3c 11 80    	mov    %ebx,0x80113c38
  if(kmem.use_lock)
80102d8a:	85 c0                	test   %eax,%eax
80102d8c:	75 22                	jne    80102db0 <kfree+0x80>
    release(&kmem.lock);
}
80102d8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d91:	c9                   	leave  
80102d92:	c3                   	ret    
80102d93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d97:	90                   	nop
    acquire(&kmem.lock);
80102d98:	83 ec 0c             	sub    $0xc,%esp
80102d9b:	68 00 3c 11 80       	push   $0x80113c00
80102da0:	e8 7b 20 00 00       	call   80104e20 <acquire>
80102da5:	83 c4 10             	add    $0x10,%esp
80102da8:	eb ce                	jmp    80102d78 <kfree+0x48>
80102daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102db0:	c7 45 08 00 3c 11 80 	movl   $0x80113c00,0x8(%ebp)
}
80102db7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dba:	c9                   	leave  
    release(&kmem.lock);
80102dbb:	e9 20 21 00 00       	jmp    80104ee0 <release>
    panic("kfree");
80102dc0:	83 ec 0c             	sub    $0xc,%esp
80102dc3:	68 82 7c 10 80       	push   $0x80107c82
80102dc8:	e8 c3 d5 ff ff       	call   80100390 <panic>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <freerange>:
{
80102dd0:	f3 0f 1e fb          	endbr32 
80102dd4:	55                   	push   %ebp
80102dd5:	89 e5                	mov    %esp,%ebp
80102dd7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102dd8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102ddb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102dde:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102ddf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102de5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102deb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102df1:	39 de                	cmp    %ebx,%esi
80102df3:	72 1f                	jb     80102e14 <freerange+0x44>
80102df5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e07:	50                   	push   %eax
80102e08:	e8 23 ff ff ff       	call   80102d30 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e0d:	83 c4 10             	add    $0x10,%esp
80102e10:	39 f3                	cmp    %esi,%ebx
80102e12:	76 e4                	jbe    80102df8 <freerange+0x28>
}
80102e14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e17:	5b                   	pop    %ebx
80102e18:	5e                   	pop    %esi
80102e19:	5d                   	pop    %ebp
80102e1a:	c3                   	ret    
80102e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e1f:	90                   	nop

80102e20 <kinit1>:
{
80102e20:	f3 0f 1e fb          	endbr32 
80102e24:	55                   	push   %ebp
80102e25:	89 e5                	mov    %esp,%ebp
80102e27:	56                   	push   %esi
80102e28:	53                   	push   %ebx
80102e29:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102e2c:	83 ec 08             	sub    $0x8,%esp
80102e2f:	68 88 7c 10 80       	push   $0x80107c88
80102e34:	68 00 3c 11 80       	push   $0x80113c00
80102e39:	e8 62 1e 00 00       	call   80104ca0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e41:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e44:	c7 05 34 3c 11 80 00 	movl   $0x0,0x80113c34
80102e4b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102e4e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e54:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e60:	39 de                	cmp    %ebx,%esi
80102e62:	72 20                	jb     80102e84 <kinit1+0x64>
80102e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102e68:	83 ec 0c             	sub    $0xc,%esp
80102e6b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e71:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e77:	50                   	push   %eax
80102e78:	e8 b3 fe ff ff       	call   80102d30 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e7d:	83 c4 10             	add    $0x10,%esp
80102e80:	39 de                	cmp    %ebx,%esi
80102e82:	73 e4                	jae    80102e68 <kinit1+0x48>
}
80102e84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e87:	5b                   	pop    %ebx
80102e88:	5e                   	pop    %esi
80102e89:	5d                   	pop    %ebp
80102e8a:	c3                   	ret    
80102e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e8f:	90                   	nop

80102e90 <kinit2>:
{
80102e90:	f3 0f 1e fb          	endbr32 
80102e94:	55                   	push   %ebp
80102e95:	89 e5                	mov    %esp,%ebp
80102e97:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102e98:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102e9b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102e9e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102e9f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ea5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102eab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102eb1:	39 de                	cmp    %ebx,%esi
80102eb3:	72 1f                	jb     80102ed4 <kinit2+0x44>
80102eb5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102eb8:	83 ec 0c             	sub    $0xc,%esp
80102ebb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ec1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ec7:	50                   	push   %eax
80102ec8:	e8 63 fe ff ff       	call   80102d30 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ecd:	83 c4 10             	add    $0x10,%esp
80102ed0:	39 de                	cmp    %ebx,%esi
80102ed2:	73 e4                	jae    80102eb8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ed4:	c7 05 34 3c 11 80 01 	movl   $0x1,0x80113c34
80102edb:	00 00 00 
}
80102ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ee1:	5b                   	pop    %ebx
80102ee2:	5e                   	pop    %esi
80102ee3:	5d                   	pop    %ebp
80102ee4:	c3                   	ret    
80102ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ef0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ef0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102ef4:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80102ef9:	85 c0                	test   %eax,%eax
80102efb:	75 1b                	jne    80102f18 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102efd:	a1 38 3c 11 80       	mov    0x80113c38,%eax
  if(r)
80102f02:	85 c0                	test   %eax,%eax
80102f04:	74 0a                	je     80102f10 <kalloc+0x20>
    kmem.freelist = r->next;
80102f06:	8b 10                	mov    (%eax),%edx
80102f08:	89 15 38 3c 11 80    	mov    %edx,0x80113c38
  if(kmem.use_lock)
80102f0e:	c3                   	ret    
80102f0f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102f10:	c3                   	ret    
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102f18:	55                   	push   %ebp
80102f19:	89 e5                	mov    %esp,%ebp
80102f1b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102f1e:	68 00 3c 11 80       	push   $0x80113c00
80102f23:	e8 f8 1e 00 00       	call   80104e20 <acquire>
  r = kmem.freelist;
80102f28:	a1 38 3c 11 80       	mov    0x80113c38,%eax
  if(r)
80102f2d:	8b 15 34 3c 11 80    	mov    0x80113c34,%edx
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	85 c0                	test   %eax,%eax
80102f38:	74 08                	je     80102f42 <kalloc+0x52>
    kmem.freelist = r->next;
80102f3a:	8b 08                	mov    (%eax),%ecx
80102f3c:	89 0d 38 3c 11 80    	mov    %ecx,0x80113c38
  if(kmem.use_lock)
80102f42:	85 d2                	test   %edx,%edx
80102f44:	74 16                	je     80102f5c <kalloc+0x6c>
    release(&kmem.lock);
80102f46:	83 ec 0c             	sub    $0xc,%esp
80102f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102f4c:	68 00 3c 11 80       	push   $0x80113c00
80102f51:	e8 8a 1f 00 00       	call   80104ee0 <release>
  return (char*)r;
80102f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102f59:	83 c4 10             	add    $0x10,%esp
}
80102f5c:	c9                   	leave  
80102f5d:	c3                   	ret    
80102f5e:	66 90                	xchg   %ax,%ax

80102f60 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102f60:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f64:	ba 64 00 00 00       	mov    $0x64,%edx
80102f69:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102f6a:	a8 01                	test   $0x1,%al
80102f6c:	0f 84 be 00 00 00    	je     80103030 <kbdgetc+0xd0>
{
80102f72:	55                   	push   %ebp
80102f73:	ba 60 00 00 00       	mov    $0x60,%edx
80102f78:	89 e5                	mov    %esp,%ebp
80102f7a:	53                   	push   %ebx
80102f7b:	ec                   	in     (%dx),%al
  return data;
80102f7c:	8b 1d d4 b5 10 80    	mov    0x8010b5d4,%ebx
    return -1;
  data = inb(KBDATAP);
80102f82:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102f85:	3c e0                	cmp    $0xe0,%al
80102f87:	74 57                	je     80102fe0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102f89:	89 d9                	mov    %ebx,%ecx
80102f8b:	83 e1 40             	and    $0x40,%ecx
80102f8e:	84 c0                	test   %al,%al
80102f90:	78 5e                	js     80102ff0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f92:	85 c9                	test   %ecx,%ecx
80102f94:	74 09                	je     80102f9f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f96:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f99:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102f9c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102f9f:	0f b6 8a c0 7d 10 80 	movzbl -0x7fef8240(%edx),%ecx
  shift ^= togglecode[data];
80102fa6:	0f b6 82 c0 7c 10 80 	movzbl -0x7fef8340(%edx),%eax
  shift |= shiftcode[data];
80102fad:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102faf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102fb1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102fb3:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102fb9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102fbc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102fbf:	8b 04 85 a0 7c 10 80 	mov    -0x7fef8360(,%eax,4),%eax
80102fc6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102fca:	74 0b                	je     80102fd7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102fcc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102fcf:	83 fa 19             	cmp    $0x19,%edx
80102fd2:	77 44                	ja     80103018 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102fd4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102fd7:	5b                   	pop    %ebx
80102fd8:	5d                   	pop    %ebp
80102fd9:	c3                   	ret    
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102fe0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102fe3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102fe5:	89 1d d4 b5 10 80    	mov    %ebx,0x8010b5d4
}
80102feb:	5b                   	pop    %ebx
80102fec:	5d                   	pop    %ebp
80102fed:	c3                   	ret    
80102fee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102ff0:	83 e0 7f             	and    $0x7f,%eax
80102ff3:	85 c9                	test   %ecx,%ecx
80102ff5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102ff8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102ffa:	0f b6 8a c0 7d 10 80 	movzbl -0x7fef8240(%edx),%ecx
80103001:	83 c9 40             	or     $0x40,%ecx
80103004:	0f b6 c9             	movzbl %cl,%ecx
80103007:	f7 d1                	not    %ecx
80103009:	21 d9                	and    %ebx,%ecx
}
8010300b:	5b                   	pop    %ebx
8010300c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010300d:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
80103013:	c3                   	ret    
80103014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80103018:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010301b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010301e:	5b                   	pop    %ebx
8010301f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80103020:	83 f9 1a             	cmp    $0x1a,%ecx
80103023:	0f 42 c2             	cmovb  %edx,%eax
}
80103026:	c3                   	ret    
80103027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010302e:	66 90                	xchg   %ax,%ax
    return -1;
80103030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103035:	c3                   	ret    
80103036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010303d:	8d 76 00             	lea    0x0(%esi),%esi

80103040 <kbdintr>:

void
kbdintr(void)
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	55                   	push   %ebp
80103045:	89 e5                	mov    %esp,%ebp
80103047:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010304a:	68 60 2f 10 80       	push   $0x80102f60
8010304f:	e8 1c dd ff ff       	call   80100d70 <consoleintr>
}
80103054:	83 c4 10             	add    $0x10,%esp
80103057:	c9                   	leave  
80103058:	c3                   	ret    
80103059:	66 90                	xchg   %ax,%ax
8010305b:	66 90                	xchg   %ax,%ax
8010305d:	66 90                	xchg   %ax,%ax
8010305f:	90                   	nop

80103060 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80103060:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80103064:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103069:	85 c0                	test   %eax,%eax
8010306b:	0f 84 c7 00 00 00    	je     80103138 <lapicinit+0xd8>
  lapic[index] = value;
80103071:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103078:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010307b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010307e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103085:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103088:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010308b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103092:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103095:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103098:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010309f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801030a2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030a5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801030ac:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030af:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030b2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801030b9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030bc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801030bf:	8b 50 30             	mov    0x30(%eax),%edx
801030c2:	c1 ea 10             	shr    $0x10,%edx
801030c5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801030cb:	75 73                	jne    80103140 <lapicinit+0xe0>
  lapic[index] = value;
801030cd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801030d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030da:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030e1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030e7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801030ee:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030f4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801030fb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103101:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103108:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010310b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010310e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103115:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103118:	8b 50 20             	mov    0x20(%eax),%edx
8010311b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010311f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103120:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103126:	80 e6 10             	and    $0x10,%dh
80103129:	75 f5                	jne    80103120 <lapicinit+0xc0>
  lapic[index] = value;
8010312b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103132:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103135:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103138:	c3                   	ret    
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103140:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103147:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010314a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010314d:	e9 7b ff ff ff       	jmp    801030cd <lapicinit+0x6d>
80103152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103160 <lapicid>:

int
lapicid(void)
{
80103160:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103164:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103169:	85 c0                	test   %eax,%eax
8010316b:	74 0b                	je     80103178 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010316d:	8b 40 20             	mov    0x20(%eax),%eax
80103170:	c1 e8 18             	shr    $0x18,%eax
80103173:	c3                   	ret    
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103178:	31 c0                	xor    %eax,%eax
}
8010317a:	c3                   	ret    
8010317b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop

80103180 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103180:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103184:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103189:	85 c0                	test   %eax,%eax
8010318b:	74 0d                	je     8010319a <lapiceoi+0x1a>
  lapic[index] = value;
8010318d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103194:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103197:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010319a:	c3                   	ret    
8010319b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop

801031a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801031a0:	f3 0f 1e fb          	endbr32 
}
801031a4:	c3                   	ret    
801031a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801031b0:	f3 0f 1e fb          	endbr32 
801031b4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b5:	b8 0f 00 00 00       	mov    $0xf,%eax
801031ba:	ba 70 00 00 00       	mov    $0x70,%edx
801031bf:	89 e5                	mov    %esp,%ebp
801031c1:	53                   	push   %ebx
801031c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801031c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801031c8:	ee                   	out    %al,(%dx)
801031c9:	b8 0a 00 00 00       	mov    $0xa,%eax
801031ce:	ba 71 00 00 00       	mov    $0x71,%edx
801031d3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801031d4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801031d6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801031d9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801031df:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801031e1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801031e4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801031e6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801031e9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801031ec:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801031f2:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
801031f7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031fd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103200:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103207:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010320a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010320d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103214:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103217:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010321a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103220:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103223:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103229:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010322c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103232:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103235:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010323b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010323c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010323f:	5d                   	pop    %ebp
80103240:	c3                   	ret    
80103241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010324f:	90                   	nop

80103250 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103250:	f3 0f 1e fb          	endbr32 
80103254:	55                   	push   %ebp
80103255:	b8 0b 00 00 00       	mov    $0xb,%eax
8010325a:	ba 70 00 00 00       	mov    $0x70,%edx
8010325f:	89 e5                	mov    %esp,%ebp
80103261:	57                   	push   %edi
80103262:	56                   	push   %esi
80103263:	53                   	push   %ebx
80103264:	83 ec 4c             	sub    $0x4c,%esp
80103267:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103268:	ba 71 00 00 00       	mov    $0x71,%edx
8010326d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010326e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103271:	bb 70 00 00 00       	mov    $0x70,%ebx
80103276:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103280:	31 c0                	xor    %eax,%eax
80103282:	89 da                	mov    %ebx,%edx
80103284:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103285:	b9 71 00 00 00       	mov    $0x71,%ecx
8010328a:	89 ca                	mov    %ecx,%edx
8010328c:	ec                   	in     (%dx),%al
8010328d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103290:	89 da                	mov    %ebx,%edx
80103292:	b8 02 00 00 00       	mov    $0x2,%eax
80103297:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103298:	89 ca                	mov    %ecx,%edx
8010329a:	ec                   	in     (%dx),%al
8010329b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010329e:	89 da                	mov    %ebx,%edx
801032a0:	b8 04 00 00 00       	mov    $0x4,%eax
801032a5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032a6:	89 ca                	mov    %ecx,%edx
801032a8:	ec                   	in     (%dx),%al
801032a9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ac:	89 da                	mov    %ebx,%edx
801032ae:	b8 07 00 00 00       	mov    $0x7,%eax
801032b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032b4:	89 ca                	mov    %ecx,%edx
801032b6:	ec                   	in     (%dx),%al
801032b7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ba:	89 da                	mov    %ebx,%edx
801032bc:	b8 08 00 00 00       	mov    $0x8,%eax
801032c1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032c2:	89 ca                	mov    %ecx,%edx
801032c4:	ec                   	in     (%dx),%al
801032c5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c7:	89 da                	mov    %ebx,%edx
801032c9:	b8 09 00 00 00       	mov    $0x9,%eax
801032ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032cf:	89 ca                	mov    %ecx,%edx
801032d1:	ec                   	in     (%dx),%al
801032d2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d4:	89 da                	mov    %ebx,%edx
801032d6:	b8 0a 00 00 00       	mov    $0xa,%eax
801032db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032dc:	89 ca                	mov    %ecx,%edx
801032de:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801032df:	84 c0                	test   %al,%al
801032e1:	78 9d                	js     80103280 <cmostime+0x30>
  return inb(CMOS_RETURN);
801032e3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801032e7:	89 fa                	mov    %edi,%edx
801032e9:	0f b6 fa             	movzbl %dl,%edi
801032ec:	89 f2                	mov    %esi,%edx
801032ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
801032f1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801032f5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032f8:	89 da                	mov    %ebx,%edx
801032fa:	89 7d c8             	mov    %edi,-0x38(%ebp)
801032fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103300:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103304:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103307:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010330a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010330e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103311:	31 c0                	xor    %eax,%eax
80103313:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103314:	89 ca                	mov    %ecx,%edx
80103316:	ec                   	in     (%dx),%al
80103317:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	89 da                	mov    %ebx,%edx
8010331c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010331f:	b8 02 00 00 00       	mov    $0x2,%eax
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	89 ca                	mov    %ecx,%edx
80103327:	ec                   	in     (%dx),%al
80103328:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332b:	89 da                	mov    %ebx,%edx
8010332d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103330:	b8 04 00 00 00       	mov    $0x4,%eax
80103335:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103336:	89 ca                	mov    %ecx,%edx
80103338:	ec                   	in     (%dx),%al
80103339:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010333c:	89 da                	mov    %ebx,%edx
8010333e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103341:	b8 07 00 00 00       	mov    $0x7,%eax
80103346:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103347:	89 ca                	mov    %ecx,%edx
80103349:	ec                   	in     (%dx),%al
8010334a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010334d:	89 da                	mov    %ebx,%edx
8010334f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103352:	b8 08 00 00 00       	mov    $0x8,%eax
80103357:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103358:	89 ca                	mov    %ecx,%edx
8010335a:	ec                   	in     (%dx),%al
8010335b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010335e:	89 da                	mov    %ebx,%edx
80103360:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103363:	b8 09 00 00 00       	mov    $0x9,%eax
80103368:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103369:	89 ca                	mov    %ecx,%edx
8010336b:	ec                   	in     (%dx),%al
8010336c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010336f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103372:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103375:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103378:	6a 18                	push   $0x18
8010337a:	50                   	push   %eax
8010337b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010337e:	50                   	push   %eax
8010337f:	e8 fc 1b 00 00       	call   80104f80 <memcmp>
80103384:	83 c4 10             	add    $0x10,%esp
80103387:	85 c0                	test   %eax,%eax
80103389:	0f 85 f1 fe ff ff    	jne    80103280 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010338f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103393:	75 78                	jne    8010340d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103395:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103398:	89 c2                	mov    %eax,%edx
8010339a:	83 e0 0f             	and    $0xf,%eax
8010339d:	c1 ea 04             	shr    $0x4,%edx
801033a0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033a3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033a6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801033a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033ac:	89 c2                	mov    %eax,%edx
801033ae:	83 e0 0f             	and    $0xf,%eax
801033b1:	c1 ea 04             	shr    $0x4,%edx
801033b4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033b7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ba:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801033bd:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033c0:	89 c2                	mov    %eax,%edx
801033c2:	83 e0 0f             	and    $0xf,%eax
801033c5:	c1 ea 04             	shr    $0x4,%edx
801033c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801033d1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801033d4:	89 c2                	mov    %eax,%edx
801033d6:	83 e0 0f             	and    $0xf,%eax
801033d9:	c1 ea 04             	shr    $0x4,%edx
801033dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033e2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801033e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033e8:	89 c2                	mov    %eax,%edx
801033ea:	83 e0 0f             	and    $0xf,%eax
801033ed:	c1 ea 04             	shr    $0x4,%edx
801033f0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033f3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801033f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033fc:	89 c2                	mov    %eax,%edx
801033fe:	83 e0 0f             	and    $0xf,%eax
80103401:	c1 ea 04             	shr    $0x4,%edx
80103404:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103407:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010340a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010340d:	8b 75 08             	mov    0x8(%ebp),%esi
80103410:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103413:	89 06                	mov    %eax,(%esi)
80103415:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103418:	89 46 04             	mov    %eax,0x4(%esi)
8010341b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010341e:	89 46 08             	mov    %eax,0x8(%esi)
80103421:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103424:	89 46 0c             	mov    %eax,0xc(%esi)
80103427:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010342a:	89 46 10             	mov    %eax,0x10(%esi)
8010342d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103430:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103433:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010343a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010343d:	5b                   	pop    %ebx
8010343e:	5e                   	pop    %esi
8010343f:	5f                   	pop    %edi
80103440:	5d                   	pop    %ebp
80103441:	c3                   	ret    
80103442:	66 90                	xchg   %ax,%ax
80103444:	66 90                	xchg   %ax,%ax
80103446:	66 90                	xchg   %ax,%ax
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103450:	8b 0d 88 3c 11 80    	mov    0x80113c88,%ecx
80103456:	85 c9                	test   %ecx,%ecx
80103458:	0f 8e 8a 00 00 00    	jle    801034e8 <install_trans+0x98>
{
8010345e:	55                   	push   %ebp
8010345f:	89 e5                	mov    %esp,%ebp
80103461:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103462:	31 ff                	xor    %edi,%edi
{
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103470:	a1 74 3c 11 80       	mov    0x80113c74,%eax
80103475:	83 ec 08             	sub    $0x8,%esp
80103478:	01 f8                	add    %edi,%eax
8010347a:	83 c0 01             	add    $0x1,%eax
8010347d:	50                   	push   %eax
8010347e:	ff 35 84 3c 11 80    	pushl  0x80113c84
80103484:	e8 47 cc ff ff       	call   801000d0 <bread>
80103489:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010348b:	58                   	pop    %eax
8010348c:	5a                   	pop    %edx
8010348d:	ff 34 bd 8c 3c 11 80 	pushl  -0x7feec374(,%edi,4)
80103494:	ff 35 84 3c 11 80    	pushl  0x80113c84
  for (tail = 0; tail < log.lh.n; tail++) {
8010349a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010349d:	e8 2e cc ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034a2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801034a5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801034a7:	8d 46 5c             	lea    0x5c(%esi),%eax
801034aa:	68 00 02 00 00       	push   $0x200
801034af:	50                   	push   %eax
801034b0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801034b3:	50                   	push   %eax
801034b4:	e8 17 1b 00 00       	call   80104fd0 <memmove>
    bwrite(dbuf);  // write dst to disk
801034b9:	89 1c 24             	mov    %ebx,(%esp)
801034bc:	e8 ef cc ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801034c1:	89 34 24             	mov    %esi,(%esp)
801034c4:	e8 27 cd ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801034c9:	89 1c 24             	mov    %ebx,(%esp)
801034cc:	e8 1f cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801034d1:	83 c4 10             	add    $0x10,%esp
801034d4:	39 3d 88 3c 11 80    	cmp    %edi,0x80113c88
801034da:	7f 94                	jg     80103470 <install_trans+0x20>
  }
}
801034dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034df:	5b                   	pop    %ebx
801034e0:	5e                   	pop    %esi
801034e1:	5f                   	pop    %edi
801034e2:	5d                   	pop    %ebp
801034e3:	c3                   	ret    
801034e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034e8:	c3                   	ret    
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801034f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	53                   	push   %ebx
801034f4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801034f7:	ff 35 74 3c 11 80    	pushl  0x80113c74
801034fd:	ff 35 84 3c 11 80    	pushl  0x80113c84
80103503:	e8 c8 cb ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103508:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010350b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010350d:	a1 88 3c 11 80       	mov    0x80113c88,%eax
80103512:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103515:	85 c0                	test   %eax,%eax
80103517:	7e 19                	jle    80103532 <write_head+0x42>
80103519:	31 d2                	xor    %edx,%edx
8010351b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010351f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103520:	8b 0c 95 8c 3c 11 80 	mov    -0x7feec374(,%edx,4),%ecx
80103527:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010352b:	83 c2 01             	add    $0x1,%edx
8010352e:	39 d0                	cmp    %edx,%eax
80103530:	75 ee                	jne    80103520 <write_head+0x30>
  }
  bwrite(buf);
80103532:	83 ec 0c             	sub    $0xc,%esp
80103535:	53                   	push   %ebx
80103536:	e8 75 cc ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010353b:	89 1c 24             	mov    %ebx,(%esp)
8010353e:	e8 ad cc ff ff       	call   801001f0 <brelse>
}
80103543:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103546:	83 c4 10             	add    $0x10,%esp
80103549:	c9                   	leave  
8010354a:	c3                   	ret    
8010354b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop

80103550 <initlog>:
{
80103550:	f3 0f 1e fb          	endbr32 
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	53                   	push   %ebx
80103558:	83 ec 2c             	sub    $0x2c,%esp
8010355b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010355e:	68 c0 7e 10 80       	push   $0x80107ec0
80103563:	68 40 3c 11 80       	push   $0x80113c40
80103568:	e8 33 17 00 00       	call   80104ca0 <initlock>
  readsb(dev, &sb);
8010356d:	58                   	pop    %eax
8010356e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103571:	5a                   	pop    %edx
80103572:	50                   	push   %eax
80103573:	53                   	push   %ebx
80103574:	e8 47 e8 ff ff       	call   80101dc0 <readsb>
  log.start = sb.logstart;
80103579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010357c:	59                   	pop    %ecx
  log.dev = dev;
8010357d:	89 1d 84 3c 11 80    	mov    %ebx,0x80113c84
  log.size = sb.nlog;
80103583:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103586:	a3 74 3c 11 80       	mov    %eax,0x80113c74
  log.size = sb.nlog;
8010358b:	89 15 78 3c 11 80    	mov    %edx,0x80113c78
  struct buf *buf = bread(log.dev, log.start);
80103591:	5a                   	pop    %edx
80103592:	50                   	push   %eax
80103593:	53                   	push   %ebx
80103594:	e8 37 cb ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103599:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010359c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010359f:	89 0d 88 3c 11 80    	mov    %ecx,0x80113c88
  for (i = 0; i < log.lh.n; i++) {
801035a5:	85 c9                	test   %ecx,%ecx
801035a7:	7e 19                	jle    801035c2 <initlog+0x72>
801035a9:	31 d2                	xor    %edx,%edx
801035ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035af:	90                   	nop
    log.lh.block[i] = lh->block[i];
801035b0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801035b4:	89 1c 95 8c 3c 11 80 	mov    %ebx,-0x7feec374(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801035bb:	83 c2 01             	add    $0x1,%edx
801035be:	39 d1                	cmp    %edx,%ecx
801035c0:	75 ee                	jne    801035b0 <initlog+0x60>
  brelse(buf);
801035c2:	83 ec 0c             	sub    $0xc,%esp
801035c5:	50                   	push   %eax
801035c6:	e8 25 cc ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801035cb:	e8 80 fe ff ff       	call   80103450 <install_trans>
  log.lh.n = 0;
801035d0:	c7 05 88 3c 11 80 00 	movl   $0x0,0x80113c88
801035d7:	00 00 00 
  write_head(); // clear the log
801035da:	e8 11 ff ff ff       	call   801034f0 <write_head>
}
801035df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035e2:	83 c4 10             	add    $0x10,%esp
801035e5:	c9                   	leave  
801035e6:	c3                   	ret    
801035e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801035f0:	f3 0f 1e fb          	endbr32 
801035f4:	55                   	push   %ebp
801035f5:	89 e5                	mov    %esp,%ebp
801035f7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801035fa:	68 40 3c 11 80       	push   $0x80113c40
801035ff:	e8 1c 18 00 00       	call   80104e20 <acquire>
80103604:	83 c4 10             	add    $0x10,%esp
80103607:	eb 1c                	jmp    80103625 <begin_op+0x35>
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103610:	83 ec 08             	sub    $0x8,%esp
80103613:	68 40 3c 11 80       	push   $0x80113c40
80103618:	68 40 3c 11 80       	push   $0x80113c40
8010361d:	e8 be 11 00 00       	call   801047e0 <sleep>
80103622:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103625:	a1 80 3c 11 80       	mov    0x80113c80,%eax
8010362a:	85 c0                	test   %eax,%eax
8010362c:	75 e2                	jne    80103610 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010362e:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
80103633:	8b 15 88 3c 11 80    	mov    0x80113c88,%edx
80103639:	83 c0 01             	add    $0x1,%eax
8010363c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010363f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103642:	83 fa 1e             	cmp    $0x1e,%edx
80103645:	7f c9                	jg     80103610 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103647:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010364a:	a3 7c 3c 11 80       	mov    %eax,0x80113c7c
      release(&log.lock);
8010364f:	68 40 3c 11 80       	push   $0x80113c40
80103654:	e8 87 18 00 00       	call   80104ee0 <release>
      break;
    }
  }
}
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	c9                   	leave  
8010365d:	c3                   	ret    
8010365e:	66 90                	xchg   %ax,%ax

80103660 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103660:	f3 0f 1e fb          	endbr32 
80103664:	55                   	push   %ebp
80103665:	89 e5                	mov    %esp,%ebp
80103667:	57                   	push   %edi
80103668:	56                   	push   %esi
80103669:	53                   	push   %ebx
8010366a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010366d:	68 40 3c 11 80       	push   $0x80113c40
80103672:	e8 a9 17 00 00       	call   80104e20 <acquire>
  log.outstanding -= 1;
80103677:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
  if(log.committing)
8010367c:	8b 35 80 3c 11 80    	mov    0x80113c80,%esi
80103682:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103685:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103688:	89 1d 7c 3c 11 80    	mov    %ebx,0x80113c7c
  if(log.committing)
8010368e:	85 f6                	test   %esi,%esi
80103690:	0f 85 1e 01 00 00    	jne    801037b4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103696:	85 db                	test   %ebx,%ebx
80103698:	0f 85 f2 00 00 00    	jne    80103790 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010369e:	c7 05 80 3c 11 80 01 	movl   $0x1,0x80113c80
801036a5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801036a8:	83 ec 0c             	sub    $0xc,%esp
801036ab:	68 40 3c 11 80       	push   $0x80113c40
801036b0:	e8 2b 18 00 00       	call   80104ee0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801036b5:	8b 0d 88 3c 11 80    	mov    0x80113c88,%ecx
801036bb:	83 c4 10             	add    $0x10,%esp
801036be:	85 c9                	test   %ecx,%ecx
801036c0:	7f 3e                	jg     80103700 <end_op+0xa0>
    acquire(&log.lock);
801036c2:	83 ec 0c             	sub    $0xc,%esp
801036c5:	68 40 3c 11 80       	push   $0x80113c40
801036ca:	e8 51 17 00 00       	call   80104e20 <acquire>
    wakeup(&log);
801036cf:	c7 04 24 40 3c 11 80 	movl   $0x80113c40,(%esp)
    log.committing = 0;
801036d6:	c7 05 80 3c 11 80 00 	movl   $0x0,0x80113c80
801036dd:	00 00 00 
    wakeup(&log);
801036e0:	e8 bb 12 00 00       	call   801049a0 <wakeup>
    release(&log.lock);
801036e5:	c7 04 24 40 3c 11 80 	movl   $0x80113c40,(%esp)
801036ec:	e8 ef 17 00 00       	call   80104ee0 <release>
801036f1:	83 c4 10             	add    $0x10,%esp
}
801036f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036f7:	5b                   	pop    %ebx
801036f8:	5e                   	pop    %esi
801036f9:	5f                   	pop    %edi
801036fa:	5d                   	pop    %ebp
801036fb:	c3                   	ret    
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103700:	a1 74 3c 11 80       	mov    0x80113c74,%eax
80103705:	83 ec 08             	sub    $0x8,%esp
80103708:	01 d8                	add    %ebx,%eax
8010370a:	83 c0 01             	add    $0x1,%eax
8010370d:	50                   	push   %eax
8010370e:	ff 35 84 3c 11 80    	pushl  0x80113c84
80103714:	e8 b7 c9 ff ff       	call   801000d0 <bread>
80103719:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010371b:	58                   	pop    %eax
8010371c:	5a                   	pop    %edx
8010371d:	ff 34 9d 8c 3c 11 80 	pushl  -0x7feec374(,%ebx,4)
80103724:	ff 35 84 3c 11 80    	pushl  0x80113c84
  for (tail = 0; tail < log.lh.n; tail++) {
8010372a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010372d:	e8 9e c9 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103732:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103735:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103737:	8d 40 5c             	lea    0x5c(%eax),%eax
8010373a:	68 00 02 00 00       	push   $0x200
8010373f:	50                   	push   %eax
80103740:	8d 46 5c             	lea    0x5c(%esi),%eax
80103743:	50                   	push   %eax
80103744:	e8 87 18 00 00       	call   80104fd0 <memmove>
    bwrite(to);  // write the log
80103749:	89 34 24             	mov    %esi,(%esp)
8010374c:	e8 5f ca ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103751:	89 3c 24             	mov    %edi,(%esp)
80103754:	e8 97 ca ff ff       	call   801001f0 <brelse>
    brelse(to);
80103759:	89 34 24             	mov    %esi,(%esp)
8010375c:	e8 8f ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103761:	83 c4 10             	add    $0x10,%esp
80103764:	3b 1d 88 3c 11 80    	cmp    0x80113c88,%ebx
8010376a:	7c 94                	jl     80103700 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010376c:	e8 7f fd ff ff       	call   801034f0 <write_head>
    install_trans(); // Now install writes to home locations
80103771:	e8 da fc ff ff       	call   80103450 <install_trans>
    log.lh.n = 0;
80103776:	c7 05 88 3c 11 80 00 	movl   $0x0,0x80113c88
8010377d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103780:	e8 6b fd ff ff       	call   801034f0 <write_head>
80103785:	e9 38 ff ff ff       	jmp    801036c2 <end_op+0x62>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	68 40 3c 11 80       	push   $0x80113c40
80103798:	e8 03 12 00 00       	call   801049a0 <wakeup>
  release(&log.lock);
8010379d:	c7 04 24 40 3c 11 80 	movl   $0x80113c40,(%esp)
801037a4:	e8 37 17 00 00       	call   80104ee0 <release>
801037a9:	83 c4 10             	add    $0x10,%esp
}
801037ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037af:	5b                   	pop    %ebx
801037b0:	5e                   	pop    %esi
801037b1:	5f                   	pop    %edi
801037b2:	5d                   	pop    %ebp
801037b3:	c3                   	ret    
    panic("log.committing");
801037b4:	83 ec 0c             	sub    $0xc,%esp
801037b7:	68 c4 7e 10 80       	push   $0x80107ec4
801037bc:	e8 cf cb ff ff       	call   80100390 <panic>
801037c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop

801037d0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037d0:	f3 0f 1e fb          	endbr32 
801037d4:	55                   	push   %ebp
801037d5:	89 e5                	mov    %esp,%ebp
801037d7:	53                   	push   %ebx
801037d8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037db:	8b 15 88 3c 11 80    	mov    0x80113c88,%edx
{
801037e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037e4:	83 fa 1d             	cmp    $0x1d,%edx
801037e7:	0f 8f 91 00 00 00    	jg     8010387e <log_write+0xae>
801037ed:	a1 78 3c 11 80       	mov    0x80113c78,%eax
801037f2:	83 e8 01             	sub    $0x1,%eax
801037f5:	39 c2                	cmp    %eax,%edx
801037f7:	0f 8d 81 00 00 00    	jge    8010387e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801037fd:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
80103802:	85 c0                	test   %eax,%eax
80103804:	0f 8e 81 00 00 00    	jle    8010388b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010380a:	83 ec 0c             	sub    $0xc,%esp
8010380d:	68 40 3c 11 80       	push   $0x80113c40
80103812:	e8 09 16 00 00       	call   80104e20 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103817:	8b 15 88 3c 11 80    	mov    0x80113c88,%edx
8010381d:	83 c4 10             	add    $0x10,%esp
80103820:	85 d2                	test   %edx,%edx
80103822:	7e 4e                	jle    80103872 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103824:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103827:	31 c0                	xor    %eax,%eax
80103829:	eb 0c                	jmp    80103837 <log_write+0x67>
8010382b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop
80103830:	83 c0 01             	add    $0x1,%eax
80103833:	39 c2                	cmp    %eax,%edx
80103835:	74 29                	je     80103860 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103837:	39 0c 85 8c 3c 11 80 	cmp    %ecx,-0x7feec374(,%eax,4)
8010383e:	75 f0                	jne    80103830 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103840:	89 0c 85 8c 3c 11 80 	mov    %ecx,-0x7feec374(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103847:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010384a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010384d:	c7 45 08 40 3c 11 80 	movl   $0x80113c40,0x8(%ebp)
}
80103854:	c9                   	leave  
  release(&log.lock);
80103855:	e9 86 16 00 00       	jmp    80104ee0 <release>
8010385a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103860:	89 0c 95 8c 3c 11 80 	mov    %ecx,-0x7feec374(,%edx,4)
    log.lh.n++;
80103867:	83 c2 01             	add    $0x1,%edx
8010386a:	89 15 88 3c 11 80    	mov    %edx,0x80113c88
80103870:	eb d5                	jmp    80103847 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103872:	8b 43 08             	mov    0x8(%ebx),%eax
80103875:	a3 8c 3c 11 80       	mov    %eax,0x80113c8c
  if (i == log.lh.n)
8010387a:	75 cb                	jne    80103847 <log_write+0x77>
8010387c:	eb e9                	jmp    80103867 <log_write+0x97>
    panic("too big a transaction");
8010387e:	83 ec 0c             	sub    $0xc,%esp
80103881:	68 d3 7e 10 80       	push   $0x80107ed3
80103886:	e8 05 cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010388b:	83 ec 0c             	sub    $0xc,%esp
8010388e:	68 e9 7e 10 80       	push   $0x80107ee9
80103893:	e8 f8 ca ff ff       	call   80100390 <panic>
80103898:	66 90                	xchg   %ax,%ax
8010389a:	66 90                	xchg   %ax,%ax
8010389c:	66 90                	xchg   %ax,%ax
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801038a7:	e8 54 09 00 00       	call   80104200 <cpuid>
801038ac:	89 c3                	mov    %eax,%ebx
801038ae:	e8 4d 09 00 00       	call   80104200 <cpuid>
801038b3:	83 ec 04             	sub    $0x4,%esp
801038b6:	53                   	push   %ebx
801038b7:	50                   	push   %eax
801038b8:	68 04 7f 10 80       	push   $0x80107f04
801038bd:	e8 8e d0 ff ff       	call   80100950 <cprintf>
  idtinit();       // load idt register
801038c2:	e8 19 29 00 00       	call   801061e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801038c7:	e8 c4 08 00 00       	call   80104190 <mycpu>
801038cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038ce:	b8 01 00 00 00       	mov    $0x1,%eax
801038d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801038da:	e8 11 0c 00 00       	call   801044f0 <scheduler>
801038df:	90                   	nop

801038e0 <mpenter>:
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801038ea:	e8 c1 39 00 00       	call   801072b0 <switchkvm>
  seginit();
801038ef:	e8 2c 39 00 00       	call   80107220 <seginit>
  lapicinit();
801038f4:	e8 67 f7 ff ff       	call   80103060 <lapicinit>
  mpmain();
801038f9:	e8 a2 ff ff ff       	call   801038a0 <mpmain>
801038fe:	66 90                	xchg   %ax,%ax

80103900 <main>:
{
80103900:	f3 0f 1e fb          	endbr32 
80103904:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103908:	83 e4 f0             	and    $0xfffffff0,%esp
8010390b:	ff 71 fc             	pushl  -0x4(%ecx)
8010390e:	55                   	push   %ebp
8010390f:	89 e5                	mov    %esp,%ebp
80103911:	53                   	push   %ebx
80103912:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103913:	83 ec 08             	sub    $0x8,%esp
80103916:	68 00 00 40 80       	push   $0x80400000
8010391b:	68 68 6a 11 80       	push   $0x80116a68
80103920:	e8 fb f4 ff ff       	call   80102e20 <kinit1>
  kvmalloc();      // kernel page table
80103925:	e8 66 3e 00 00       	call   80107790 <kvmalloc>
  mpinit();        // detect other processors
8010392a:	e8 81 01 00 00       	call   80103ab0 <mpinit>
  lapicinit();     // interrupt controller
8010392f:	e8 2c f7 ff ff       	call   80103060 <lapicinit>
  seginit();       // segment descriptors
80103934:	e8 e7 38 00 00       	call   80107220 <seginit>
  picinit();       // disable pic
80103939:	e8 52 03 00 00       	call   80103c90 <picinit>
  ioapicinit();    // another interrupt controller
8010393e:	e8 fd f2 ff ff       	call   80102c40 <ioapicinit>
  consoleinit();   // console hardware
80103943:	e8 a8 d9 ff ff       	call   801012f0 <consoleinit>
  uartinit();      // serial port
80103948:	e8 93 2b 00 00       	call   801064e0 <uartinit>
  pinit();         // process table
8010394d:	e8 1e 08 00 00       	call   80104170 <pinit>
  tvinit();        // trap vectors
80103952:	e8 09 28 00 00       	call   80106160 <tvinit>
  binit();         // buffer cache
80103957:	e8 e4 c6 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010395c:	e8 3f dd ff ff       	call   801016a0 <fileinit>
  ideinit();       // disk 
80103961:	e8 aa f0 ff ff       	call   80102a10 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103966:	83 c4 0c             	add    $0xc,%esp
80103969:	68 8a 00 00 00       	push   $0x8a
8010396e:	68 8c b4 10 80       	push   $0x8010b48c
80103973:	68 00 70 00 80       	push   $0x80007000
80103978:	e8 53 16 00 00       	call   80104fd0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010397d:	83 c4 10             	add    $0x10,%esp
80103980:	69 05 c0 42 11 80 b0 	imul   $0xb0,0x801142c0,%eax
80103987:	00 00 00 
8010398a:	05 40 3d 11 80       	add    $0x80113d40,%eax
8010398f:	3d 40 3d 11 80       	cmp    $0x80113d40,%eax
80103994:	76 7a                	jbe    80103a10 <main+0x110>
80103996:	bb 40 3d 11 80       	mov    $0x80113d40,%ebx
8010399b:	eb 1c                	jmp    801039b9 <main+0xb9>
8010399d:	8d 76 00             	lea    0x0(%esi),%esi
801039a0:	69 05 c0 42 11 80 b0 	imul   $0xb0,0x801142c0,%eax
801039a7:	00 00 00 
801039aa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801039b0:	05 40 3d 11 80       	add    $0x80113d40,%eax
801039b5:	39 c3                	cmp    %eax,%ebx
801039b7:	73 57                	jae    80103a10 <main+0x110>
    if(c == mycpu())  // We've started already.
801039b9:	e8 d2 07 00 00       	call   80104190 <mycpu>
801039be:	39 c3                	cmp    %eax,%ebx
801039c0:	74 de                	je     801039a0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801039c2:	e8 29 f5 ff ff       	call   80102ef0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801039c7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801039ca:	c7 05 f8 6f 00 80 e0 	movl   $0x801038e0,0x80006ff8
801039d1:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801039d4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801039db:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801039de:	05 00 10 00 00       	add    $0x1000,%eax
801039e3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801039e8:	0f b6 03             	movzbl (%ebx),%eax
801039eb:	68 00 70 00 00       	push   $0x7000
801039f0:	50                   	push   %eax
801039f1:	e8 ba f7 ff ff       	call   801031b0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039f6:	83 c4 10             	add    $0x10,%esp
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a00:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103a06:	85 c0                	test   %eax,%eax
80103a08:	74 f6                	je     80103a00 <main+0x100>
80103a0a:	eb 94                	jmp    801039a0 <main+0xa0>
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a10:	83 ec 08             	sub    $0x8,%esp
80103a13:	68 00 00 00 8e       	push   $0x8e000000
80103a18:	68 00 00 40 80       	push   $0x80400000
80103a1d:	e8 6e f4 ff ff       	call   80102e90 <kinit2>
  userinit();      // first user process
80103a22:	e8 29 08 00 00       	call   80104250 <userinit>
  mpmain();        // finish this processor's setup
80103a27:	e8 74 fe ff ff       	call   801038a0 <mpmain>
80103a2c:	66 90                	xchg   %ax,%ax
80103a2e:	66 90                	xchg   %ax,%ax

80103a30 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	57                   	push   %edi
80103a34:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103a35:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103a3b:	53                   	push   %ebx
  e = addr+len;
80103a3c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103a3f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103a42:	39 de                	cmp    %ebx,%esi
80103a44:	72 10                	jb     80103a56 <mpsearch1+0x26>
80103a46:	eb 50                	jmp    80103a98 <mpsearch1+0x68>
80103a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4f:	90                   	nop
80103a50:	89 fe                	mov    %edi,%esi
80103a52:	39 fb                	cmp    %edi,%ebx
80103a54:	76 42                	jbe    80103a98 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a56:	83 ec 04             	sub    $0x4,%esp
80103a59:	8d 7e 10             	lea    0x10(%esi),%edi
80103a5c:	6a 04                	push   $0x4
80103a5e:	68 18 7f 10 80       	push   $0x80107f18
80103a63:	56                   	push   %esi
80103a64:	e8 17 15 00 00       	call   80104f80 <memcmp>
80103a69:	83 c4 10             	add    $0x10,%esp
80103a6c:	85 c0                	test   %eax,%eax
80103a6e:	75 e0                	jne    80103a50 <mpsearch1+0x20>
80103a70:	89 f2                	mov    %esi,%edx
80103a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103a78:	0f b6 0a             	movzbl (%edx),%ecx
80103a7b:	83 c2 01             	add    $0x1,%edx
80103a7e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103a80:	39 fa                	cmp    %edi,%edx
80103a82:	75 f4                	jne    80103a78 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a84:	84 c0                	test   %al,%al
80103a86:	75 c8                	jne    80103a50 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a8b:	89 f0                	mov    %esi,%eax
80103a8d:	5b                   	pop    %ebx
80103a8e:	5e                   	pop    %esi
80103a8f:	5f                   	pop    %edi
80103a90:	5d                   	pop    %ebp
80103a91:	c3                   	ret    
80103a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103a9b:	31 f6                	xor    %esi,%esi
}
80103a9d:	5b                   	pop    %ebx
80103a9e:	89 f0                	mov    %esi,%eax
80103aa0:	5e                   	pop    %esi
80103aa1:	5f                   	pop    %edi
80103aa2:	5d                   	pop    %ebp
80103aa3:	c3                   	ret    
80103aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	57                   	push   %edi
80103ab8:	56                   	push   %esi
80103ab9:	53                   	push   %ebx
80103aba:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103abd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103ac4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103acb:	c1 e0 08             	shl    $0x8,%eax
80103ace:	09 d0                	or     %edx,%eax
80103ad0:	c1 e0 04             	shl    $0x4,%eax
80103ad3:	75 1b                	jne    80103af0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ad5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103adc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103ae3:	c1 e0 08             	shl    $0x8,%eax
80103ae6:	09 d0                	or     %edx,%eax
80103ae8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103aeb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103af0:	ba 00 04 00 00       	mov    $0x400,%edx
80103af5:	e8 36 ff ff ff       	call   80103a30 <mpsearch1>
80103afa:	89 c6                	mov    %eax,%esi
80103afc:	85 c0                	test   %eax,%eax
80103afe:	0f 84 4c 01 00 00    	je     80103c50 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b04:	8b 5e 04             	mov    0x4(%esi),%ebx
80103b07:	85 db                	test   %ebx,%ebx
80103b09:	0f 84 61 01 00 00    	je     80103c70 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103b0f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b12:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103b18:	6a 04                	push   $0x4
80103b1a:	68 1d 7f 10 80       	push   $0x80107f1d
80103b1f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b23:	e8 58 14 00 00       	call   80104f80 <memcmp>
80103b28:	83 c4 10             	add    $0x10,%esp
80103b2b:	85 c0                	test   %eax,%eax
80103b2d:	0f 85 3d 01 00 00    	jne    80103c70 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103b33:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103b3a:	3c 01                	cmp    $0x1,%al
80103b3c:	74 08                	je     80103b46 <mpinit+0x96>
80103b3e:	3c 04                	cmp    $0x4,%al
80103b40:	0f 85 2a 01 00 00    	jne    80103c70 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b46:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103b4d:	66 85 d2             	test   %dx,%dx
80103b50:	74 26                	je     80103b78 <mpinit+0xc8>
80103b52:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103b55:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103b57:	31 d2                	xor    %edx,%edx
80103b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103b60:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103b67:	83 c0 01             	add    $0x1,%eax
80103b6a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103b6c:	39 f8                	cmp    %edi,%eax
80103b6e:	75 f0                	jne    80103b60 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b70:	84 d2                	test   %dl,%dl
80103b72:	0f 85 f8 00 00 00    	jne    80103c70 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103b78:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103b7e:	a3 3c 3c 11 80       	mov    %eax,0x80113c3c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b83:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103b89:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103b90:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b95:	03 55 e4             	add    -0x1c(%ebp),%edx
80103b98:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b9f:	90                   	nop
80103ba0:	39 c2                	cmp    %eax,%edx
80103ba2:	76 15                	jbe    80103bb9 <mpinit+0x109>
    switch(*p){
80103ba4:	0f b6 08             	movzbl (%eax),%ecx
80103ba7:	80 f9 02             	cmp    $0x2,%cl
80103baa:	74 5c                	je     80103c08 <mpinit+0x158>
80103bac:	77 42                	ja     80103bf0 <mpinit+0x140>
80103bae:	84 c9                	test   %cl,%cl
80103bb0:	74 6e                	je     80103c20 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103bb2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bb5:	39 c2                	cmp    %eax,%edx
80103bb7:	77 eb                	ja     80103ba4 <mpinit+0xf4>
80103bb9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103bbc:	85 db                	test   %ebx,%ebx
80103bbe:	0f 84 b9 00 00 00    	je     80103c7d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103bc4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103bc8:	74 15                	je     80103bdf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bca:	b8 70 00 00 00       	mov    $0x70,%eax
80103bcf:	ba 22 00 00 00       	mov    $0x22,%edx
80103bd4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103bd5:	ba 23 00 00 00       	mov    $0x23,%edx
80103bda:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103bdb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103bde:	ee                   	out    %al,(%dx)
  }
}
80103bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103be2:	5b                   	pop    %ebx
80103be3:	5e                   	pop    %esi
80103be4:	5f                   	pop    %edi
80103be5:	5d                   	pop    %ebp
80103be6:	c3                   	ret    
80103be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bee:	66 90                	xchg   %ax,%ax
    switch(*p){
80103bf0:	83 e9 03             	sub    $0x3,%ecx
80103bf3:	80 f9 01             	cmp    $0x1,%cl
80103bf6:	76 ba                	jbe    80103bb2 <mpinit+0x102>
80103bf8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103bff:	eb 9f                	jmp    80103ba0 <mpinit+0xf0>
80103c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103c08:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103c0c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103c0f:	88 0d 20 3d 11 80    	mov    %cl,0x80113d20
      continue;
80103c15:	eb 89                	jmp    80103ba0 <mpinit+0xf0>
80103c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c1e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103c20:	8b 0d c0 42 11 80    	mov    0x801142c0,%ecx
80103c26:	83 f9 07             	cmp    $0x7,%ecx
80103c29:	7f 19                	jg     80103c44 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c2b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103c31:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103c35:	83 c1 01             	add    $0x1,%ecx
80103c38:	89 0d c0 42 11 80    	mov    %ecx,0x801142c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c3e:	88 9f 40 3d 11 80    	mov    %bl,-0x7feec2c0(%edi)
      p += sizeof(struct mpproc);
80103c44:	83 c0 14             	add    $0x14,%eax
      continue;
80103c47:	e9 54 ff ff ff       	jmp    80103ba0 <mpinit+0xf0>
80103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103c50:	ba 00 00 01 00       	mov    $0x10000,%edx
80103c55:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103c5a:	e8 d1 fd ff ff       	call   80103a30 <mpsearch1>
80103c5f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c61:	85 c0                	test   %eax,%eax
80103c63:	0f 85 9b fe ff ff    	jne    80103b04 <mpinit+0x54>
80103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103c70:	83 ec 0c             	sub    $0xc,%esp
80103c73:	68 22 7f 10 80       	push   $0x80107f22
80103c78:	e8 13 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103c7d:	83 ec 0c             	sub    $0xc,%esp
80103c80:	68 3c 7f 10 80       	push   $0x80107f3c
80103c85:	e8 06 c7 ff ff       	call   80100390 <panic>
80103c8a:	66 90                	xchg   %ax,%ax
80103c8c:	66 90                	xchg   %ax,%ax
80103c8e:	66 90                	xchg   %ax,%ax

80103c90 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c99:	ba 21 00 00 00       	mov    $0x21,%edx
80103c9e:	ee                   	out    %al,(%dx)
80103c9f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103ca4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103ca5:	c3                   	ret    
80103ca6:	66 90                	xchg   %ax,%ax
80103ca8:	66 90                	xchg   %ax,%ax
80103caa:	66 90                	xchg   %ax,%ax
80103cac:	66 90                	xchg   %ax,%ax
80103cae:	66 90                	xchg   %ax,%ax

80103cb0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	57                   	push   %edi
80103cb8:	56                   	push   %esi
80103cb9:	53                   	push   %ebx
80103cba:	83 ec 0c             	sub    $0xc,%esp
80103cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103cc3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103cc9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103ccf:	e8 ec d9 ff ff       	call   801016c0 <filealloc>
80103cd4:	89 03                	mov    %eax,(%ebx)
80103cd6:	85 c0                	test   %eax,%eax
80103cd8:	0f 84 ac 00 00 00    	je     80103d8a <pipealloc+0xda>
80103cde:	e8 dd d9 ff ff       	call   801016c0 <filealloc>
80103ce3:	89 06                	mov    %eax,(%esi)
80103ce5:	85 c0                	test   %eax,%eax
80103ce7:	0f 84 8b 00 00 00    	je     80103d78 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ced:	e8 fe f1 ff ff       	call   80102ef0 <kalloc>
80103cf2:	89 c7                	mov    %eax,%edi
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	0f 84 b4 00 00 00    	je     80103db0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103cfc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d03:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103d06:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103d09:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d10:	00 00 00 
  p->nwrite = 0;
80103d13:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d1a:	00 00 00 
  p->nread = 0;
80103d1d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d24:	00 00 00 
  initlock(&p->lock, "pipe");
80103d27:	68 5b 7f 10 80       	push   $0x80107f5b
80103d2c:	50                   	push   %eax
80103d2d:	e8 6e 0f 00 00       	call   80104ca0 <initlock>
  (*f0)->type = FD_PIPE;
80103d32:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103d34:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103d37:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d3d:	8b 03                	mov    (%ebx),%eax
80103d3f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d43:	8b 03                	mov    (%ebx),%eax
80103d45:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d49:	8b 03                	mov    (%ebx),%eax
80103d4b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d4e:	8b 06                	mov    (%esi),%eax
80103d50:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d56:	8b 06                	mov    (%esi),%eax
80103d58:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d5c:	8b 06                	mov    (%esi),%eax
80103d5e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d62:	8b 06                	mov    (%esi),%eax
80103d64:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103d6a:	31 c0                	xor    %eax,%eax
}
80103d6c:	5b                   	pop    %ebx
80103d6d:	5e                   	pop    %esi
80103d6e:	5f                   	pop    %edi
80103d6f:	5d                   	pop    %ebp
80103d70:	c3                   	ret    
80103d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103d78:	8b 03                	mov    (%ebx),%eax
80103d7a:	85 c0                	test   %eax,%eax
80103d7c:	74 1e                	je     80103d9c <pipealloc+0xec>
    fileclose(*f0);
80103d7e:	83 ec 0c             	sub    $0xc,%esp
80103d81:	50                   	push   %eax
80103d82:	e8 f9 d9 ff ff       	call   80101780 <fileclose>
80103d87:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103d8a:	8b 06                	mov    (%esi),%eax
80103d8c:	85 c0                	test   %eax,%eax
80103d8e:	74 0c                	je     80103d9c <pipealloc+0xec>
    fileclose(*f1);
80103d90:	83 ec 0c             	sub    $0xc,%esp
80103d93:	50                   	push   %eax
80103d94:	e8 e7 d9 ff ff       	call   80101780 <fileclose>
80103d99:	83 c4 10             	add    $0x10,%esp
}
80103d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103d9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103da4:	5b                   	pop    %ebx
80103da5:	5e                   	pop    %esi
80103da6:	5f                   	pop    %edi
80103da7:	5d                   	pop    %ebp
80103da8:	c3                   	ret    
80103da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103db0:	8b 03                	mov    (%ebx),%eax
80103db2:	85 c0                	test   %eax,%eax
80103db4:	75 c8                	jne    80103d7e <pipealloc+0xce>
80103db6:	eb d2                	jmp    80103d8a <pipealloc+0xda>
80103db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbf:	90                   	nop

80103dc0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103dc0:	f3 0f 1e fb          	endbr32 
80103dc4:	55                   	push   %ebp
80103dc5:	89 e5                	mov    %esp,%ebp
80103dc7:	56                   	push   %esi
80103dc8:	53                   	push   %ebx
80103dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103dcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103dcf:	83 ec 0c             	sub    $0xc,%esp
80103dd2:	53                   	push   %ebx
80103dd3:	e8 48 10 00 00       	call   80104e20 <acquire>
  if(writable){
80103dd8:	83 c4 10             	add    $0x10,%esp
80103ddb:	85 f6                	test   %esi,%esi
80103ddd:	74 41                	je     80103e20 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103ddf:	83 ec 0c             	sub    $0xc,%esp
80103de2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103de8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103def:	00 00 00 
    wakeup(&p->nread);
80103df2:	50                   	push   %eax
80103df3:	e8 a8 0b 00 00       	call   801049a0 <wakeup>
80103df8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dfb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103e01:	85 d2                	test   %edx,%edx
80103e03:	75 0a                	jne    80103e0f <pipeclose+0x4f>
80103e05:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103e0b:	85 c0                	test   %eax,%eax
80103e0d:	74 31                	je     80103e40 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103e0f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e15:	5b                   	pop    %ebx
80103e16:	5e                   	pop    %esi
80103e17:	5d                   	pop    %ebp
    release(&p->lock);
80103e18:	e9 c3 10 00 00       	jmp    80104ee0 <release>
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103e20:	83 ec 0c             	sub    $0xc,%esp
80103e23:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103e29:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103e30:	00 00 00 
    wakeup(&p->nwrite);
80103e33:	50                   	push   %eax
80103e34:	e8 67 0b 00 00       	call   801049a0 <wakeup>
80103e39:	83 c4 10             	add    $0x10,%esp
80103e3c:	eb bd                	jmp    80103dfb <pipeclose+0x3b>
80103e3e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	53                   	push   %ebx
80103e44:	e8 97 10 00 00       	call   80104ee0 <release>
    kfree((char*)p);
80103e49:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103e4c:	83 c4 10             	add    $0x10,%esp
}
80103e4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e52:	5b                   	pop    %ebx
80103e53:	5e                   	pop    %esi
80103e54:	5d                   	pop    %ebp
    kfree((char*)p);
80103e55:	e9 d6 ee ff ff       	jmp    80102d30 <kfree>
80103e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e60 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e60:	f3 0f 1e fb          	endbr32 
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
80103e67:	57                   	push   %edi
80103e68:	56                   	push   %esi
80103e69:	53                   	push   %ebx
80103e6a:	83 ec 28             	sub    $0x28,%esp
80103e6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103e70:	53                   	push   %ebx
80103e71:	e8 aa 0f 00 00       	call   80104e20 <acquire>
  for(i = 0; i < n; i++){
80103e76:	8b 45 10             	mov    0x10(%ebp),%eax
80103e79:	83 c4 10             	add    $0x10,%esp
80103e7c:	85 c0                	test   %eax,%eax
80103e7e:	0f 8e bc 00 00 00    	jle    80103f40 <pipewrite+0xe0>
80103e84:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e87:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103e8d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103e93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e96:	03 45 10             	add    0x10(%ebp),%eax
80103e99:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e9c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ea2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ea8:	89 ca                	mov    %ecx,%edx
80103eaa:	05 00 02 00 00       	add    $0x200,%eax
80103eaf:	39 c1                	cmp    %eax,%ecx
80103eb1:	74 3b                	je     80103eee <pipewrite+0x8e>
80103eb3:	eb 63                	jmp    80103f18 <pipewrite+0xb8>
80103eb5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103eb8:	e8 63 03 00 00       	call   80104220 <myproc>
80103ebd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ec0:	85 c9                	test   %ecx,%ecx
80103ec2:	75 34                	jne    80103ef8 <pipewrite+0x98>
      wakeup(&p->nread);
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	57                   	push   %edi
80103ec8:	e8 d3 0a 00 00       	call   801049a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ecd:	58                   	pop    %eax
80103ece:	5a                   	pop    %edx
80103ecf:	53                   	push   %ebx
80103ed0:	56                   	push   %esi
80103ed1:	e8 0a 09 00 00       	call   801047e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ed6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103edc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103ee2:	83 c4 10             	add    $0x10,%esp
80103ee5:	05 00 02 00 00       	add    $0x200,%eax
80103eea:	39 c2                	cmp    %eax,%edx
80103eec:	75 2a                	jne    80103f18 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103eee:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ef4:	85 c0                	test   %eax,%eax
80103ef6:	75 c0                	jne    80103eb8 <pipewrite+0x58>
        release(&p->lock);
80103ef8:	83 ec 0c             	sub    $0xc,%esp
80103efb:	53                   	push   %ebx
80103efc:	e8 df 0f 00 00       	call   80104ee0 <release>
        return -1;
80103f01:	83 c4 10             	add    $0x10,%esp
80103f04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103f09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f0c:	5b                   	pop    %ebx
80103f0d:	5e                   	pop    %esi
80103f0e:	5f                   	pop    %edi
80103f0f:	5d                   	pop    %ebp
80103f10:	c3                   	ret    
80103f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f18:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103f1b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103f1e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103f24:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103f2a:	0f b6 06             	movzbl (%esi),%eax
80103f2d:	83 c6 01             	add    $0x1,%esi
80103f30:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103f33:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103f37:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103f3a:	0f 85 5c ff ff ff    	jne    80103e9c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103f49:	50                   	push   %eax
80103f4a:	e8 51 0a 00 00       	call   801049a0 <wakeup>
  release(&p->lock);
80103f4f:	89 1c 24             	mov    %ebx,(%esp)
80103f52:	e8 89 0f 00 00       	call   80104ee0 <release>
  return n;
80103f57:	8b 45 10             	mov    0x10(%ebp),%eax
80103f5a:	83 c4 10             	add    $0x10,%esp
80103f5d:	eb aa                	jmp    80103f09 <pipewrite+0xa9>
80103f5f:	90                   	nop

80103f60 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	57                   	push   %edi
80103f68:	56                   	push   %esi
80103f69:	53                   	push   %ebx
80103f6a:	83 ec 18             	sub    $0x18,%esp
80103f6d:	8b 75 08             	mov    0x8(%ebp),%esi
80103f70:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103f73:	56                   	push   %esi
80103f74:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103f7a:	e8 a1 0e 00 00       	call   80104e20 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f7f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103f85:	83 c4 10             	add    $0x10,%esp
80103f88:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103f8e:	74 33                	je     80103fc3 <piperead+0x63>
80103f90:	eb 3b                	jmp    80103fcd <piperead+0x6d>
80103f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103f98:	e8 83 02 00 00       	call   80104220 <myproc>
80103f9d:	8b 48 24             	mov    0x24(%eax),%ecx
80103fa0:	85 c9                	test   %ecx,%ecx
80103fa2:	0f 85 88 00 00 00    	jne    80104030 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fa8:	83 ec 08             	sub    $0x8,%esp
80103fab:	56                   	push   %esi
80103fac:	53                   	push   %ebx
80103fad:	e8 2e 08 00 00       	call   801047e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fb2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103fb8:	83 c4 10             	add    $0x10,%esp
80103fbb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103fc1:	75 0a                	jne    80103fcd <piperead+0x6d>
80103fc3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103fc9:	85 c0                	test   %eax,%eax
80103fcb:	75 cb                	jne    80103f98 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fcd:	8b 55 10             	mov    0x10(%ebp),%edx
80103fd0:	31 db                	xor    %ebx,%ebx
80103fd2:	85 d2                	test   %edx,%edx
80103fd4:	7f 28                	jg     80103ffe <piperead+0x9e>
80103fd6:	eb 34                	jmp    8010400c <piperead+0xac>
80103fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdf:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103fe0:	8d 48 01             	lea    0x1(%eax),%ecx
80103fe3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103fe8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103fee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103ff3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ff6:	83 c3 01             	add    $0x1,%ebx
80103ff9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103ffc:	74 0e                	je     8010400c <piperead+0xac>
    if(p->nread == p->nwrite)
80103ffe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104004:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010400a:	75 d4                	jne    80103fe0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010400c:	83 ec 0c             	sub    $0xc,%esp
8010400f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80104015:	50                   	push   %eax
80104016:	e8 85 09 00 00       	call   801049a0 <wakeup>
  release(&p->lock);
8010401b:	89 34 24             	mov    %esi,(%esp)
8010401e:	e8 bd 0e 00 00       	call   80104ee0 <release>
  return i;
80104023:	83 c4 10             	add    $0x10,%esp
}
80104026:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104029:	89 d8                	mov    %ebx,%eax
8010402b:	5b                   	pop    %ebx
8010402c:	5e                   	pop    %esi
8010402d:	5f                   	pop    %edi
8010402e:	5d                   	pop    %ebp
8010402f:	c3                   	ret    
      release(&p->lock);
80104030:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104033:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104038:	56                   	push   %esi
80104039:	e8 a2 0e 00 00       	call   80104ee0 <release>
      return -1;
8010403e:	83 c4 10             	add    $0x10,%esp
}
80104041:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104044:	89 d8                	mov    %ebx,%eax
80104046:	5b                   	pop    %ebx
80104047:	5e                   	pop    %esi
80104048:	5f                   	pop    %edi
80104049:	5d                   	pop    %ebp
8010404a:	c3                   	ret    
8010404b:	66 90                	xchg   %ax,%ax
8010404d:	66 90                	xchg   %ax,%ax
8010404f:	90                   	nop

80104050 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104054:	bb 14 43 11 80       	mov    $0x80114314,%ebx
{
80104059:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010405c:	68 e0 42 11 80       	push   $0x801142e0
80104061:	e8 ba 0d 00 00       	call   80104e20 <acquire>
80104066:	83 c4 10             	add    $0x10,%esp
80104069:	eb 10                	jmp    8010407b <allocproc+0x2b>
8010406b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010406f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104070:	83 c3 7c             	add    $0x7c,%ebx
80104073:	81 fb 14 62 11 80    	cmp    $0x80116214,%ebx
80104079:	74 75                	je     801040f0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010407b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010407e:	85 c0                	test   %eax,%eax
80104080:	75 ee                	jne    80104070 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104082:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104087:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010408a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104091:	89 43 10             	mov    %eax,0x10(%ebx)
80104094:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104097:	68 e0 42 11 80       	push   $0x801142e0
  p->pid = nextpid++;
8010409c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801040a2:	e8 39 0e 00 00       	call   80104ee0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801040a7:	e8 44 ee ff ff       	call   80102ef0 <kalloc>
801040ac:	83 c4 10             	add    $0x10,%esp
801040af:	89 43 08             	mov    %eax,0x8(%ebx)
801040b2:	85 c0                	test   %eax,%eax
801040b4:	74 53                	je     80104109 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801040b6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801040bc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801040bf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801040c4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801040c7:	c7 40 14 46 61 10 80 	movl   $0x80106146,0x14(%eax)
  p->context = (struct context*)sp;
801040ce:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801040d1:	6a 14                	push   $0x14
801040d3:	6a 00                	push   $0x0
801040d5:	50                   	push   %eax
801040d6:	e8 55 0e 00 00       	call   80104f30 <memset>
  p->context->eip = (uint)forkret;
801040db:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801040de:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801040e1:	c7 40 10 20 41 10 80 	movl   $0x80104120,0x10(%eax)
}
801040e8:	89 d8                	mov    %ebx,%eax
801040ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040ed:	c9                   	leave  
801040ee:	c3                   	ret    
801040ef:	90                   	nop
  release(&ptable.lock);
801040f0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801040f3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801040f5:	68 e0 42 11 80       	push   $0x801142e0
801040fa:	e8 e1 0d 00 00       	call   80104ee0 <release>
}
801040ff:	89 d8                	mov    %ebx,%eax
  return 0;
80104101:	83 c4 10             	add    $0x10,%esp
}
80104104:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104107:	c9                   	leave  
80104108:	c3                   	ret    
    p->state = UNUSED;
80104109:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104110:	31 db                	xor    %ebx,%ebx
}
80104112:	89 d8                	mov    %ebx,%eax
80104114:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104117:	c9                   	leave  
80104118:	c3                   	ret    
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104120:	f3 0f 1e fb          	endbr32 
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010412a:	68 e0 42 11 80       	push   $0x801142e0
8010412f:	e8 ac 0d 00 00       	call   80104ee0 <release>

  if (first) {
80104134:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104139:	83 c4 10             	add    $0x10,%esp
8010413c:	85 c0                	test   %eax,%eax
8010413e:	75 08                	jne    80104148 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104140:	c9                   	leave  
80104141:	c3                   	ret    
80104142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104148:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010414f:	00 00 00 
    iinit(ROOTDEV);
80104152:	83 ec 0c             	sub    $0xc,%esp
80104155:	6a 01                	push   $0x1
80104157:	e8 a4 dc ff ff       	call   80101e00 <iinit>
    initlog(ROOTDEV);
8010415c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104163:	e8 e8 f3 ff ff       	call   80103550 <initlog>
}
80104168:	83 c4 10             	add    $0x10,%esp
8010416b:	c9                   	leave  
8010416c:	c3                   	ret    
8010416d:	8d 76 00             	lea    0x0(%esi),%esi

80104170 <pinit>:
{
80104170:	f3 0f 1e fb          	endbr32 
80104174:	55                   	push   %ebp
80104175:	89 e5                	mov    %esp,%ebp
80104177:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010417a:	68 60 7f 10 80       	push   $0x80107f60
8010417f:	68 e0 42 11 80       	push   $0x801142e0
80104184:	e8 17 0b 00 00       	call   80104ca0 <initlock>
}
80104189:	83 c4 10             	add    $0x10,%esp
8010418c:	c9                   	leave  
8010418d:	c3                   	ret    
8010418e:	66 90                	xchg   %ax,%ax

80104190 <mycpu>:
{
80104190:	f3 0f 1e fb          	endbr32 
80104194:	55                   	push   %ebp
80104195:	89 e5                	mov    %esp,%ebp
80104197:	56                   	push   %esi
80104198:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104199:	9c                   	pushf  
8010419a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010419b:	f6 c4 02             	test   $0x2,%ah
8010419e:	75 4a                	jne    801041ea <mycpu+0x5a>
  apicid = lapicid();
801041a0:	e8 bb ef ff ff       	call   80103160 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801041a5:	8b 35 c0 42 11 80    	mov    0x801142c0,%esi
  apicid = lapicid();
801041ab:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801041ad:	85 f6                	test   %esi,%esi
801041af:	7e 2c                	jle    801041dd <mycpu+0x4d>
801041b1:	31 d2                	xor    %edx,%edx
801041b3:	eb 0a                	jmp    801041bf <mycpu+0x2f>
801041b5:	8d 76 00             	lea    0x0(%esi),%esi
801041b8:	83 c2 01             	add    $0x1,%edx
801041bb:	39 f2                	cmp    %esi,%edx
801041bd:	74 1e                	je     801041dd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801041bf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801041c5:	0f b6 81 40 3d 11 80 	movzbl -0x7feec2c0(%ecx),%eax
801041cc:	39 d8                	cmp    %ebx,%eax
801041ce:	75 e8                	jne    801041b8 <mycpu+0x28>
}
801041d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801041d3:	8d 81 40 3d 11 80    	lea    -0x7feec2c0(%ecx),%eax
}
801041d9:	5b                   	pop    %ebx
801041da:	5e                   	pop    %esi
801041db:	5d                   	pop    %ebp
801041dc:	c3                   	ret    
  panic("unknown apicid\n");
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	68 67 7f 10 80       	push   $0x80107f67
801041e5:	e8 a6 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801041ea:	83 ec 0c             	sub    $0xc,%esp
801041ed:	68 44 80 10 80       	push   $0x80108044
801041f2:	e8 99 c1 ff ff       	call   80100390 <panic>
801041f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041fe:	66 90                	xchg   %ax,%ax

80104200 <cpuid>:
cpuid() {
80104200:	f3 0f 1e fb          	endbr32 
80104204:	55                   	push   %ebp
80104205:	89 e5                	mov    %esp,%ebp
80104207:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010420a:	e8 81 ff ff ff       	call   80104190 <mycpu>
}
8010420f:	c9                   	leave  
  return mycpu()-cpus;
80104210:	2d 40 3d 11 80       	sub    $0x80113d40,%eax
80104215:	c1 f8 04             	sar    $0x4,%eax
80104218:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010421e:	c3                   	ret    
8010421f:	90                   	nop

80104220 <myproc>:
myproc(void) {
80104220:	f3 0f 1e fb          	endbr32 
80104224:	55                   	push   %ebp
80104225:	89 e5                	mov    %esp,%ebp
80104227:	53                   	push   %ebx
80104228:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010422b:	e8 f0 0a 00 00       	call   80104d20 <pushcli>
  c = mycpu();
80104230:	e8 5b ff ff ff       	call   80104190 <mycpu>
  p = c->proc;
80104235:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010423b:	e8 30 0b 00 00       	call   80104d70 <popcli>
}
80104240:	83 c4 04             	add    $0x4,%esp
80104243:	89 d8                	mov    %ebx,%eax
80104245:	5b                   	pop    %ebx
80104246:	5d                   	pop    %ebp
80104247:	c3                   	ret    
80104248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424f:	90                   	nop

80104250 <userinit>:
{
80104250:	f3 0f 1e fb          	endbr32 
80104254:	55                   	push   %ebp
80104255:	89 e5                	mov    %esp,%ebp
80104257:	53                   	push   %ebx
80104258:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010425b:	e8 f0 fd ff ff       	call   80104050 <allocproc>
80104260:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104262:	a3 d8 b5 10 80       	mov    %eax,0x8010b5d8
  if((p->pgdir = setupkvm()) == 0)
80104267:	e8 a4 34 00 00       	call   80107710 <setupkvm>
8010426c:	89 43 04             	mov    %eax,0x4(%ebx)
8010426f:	85 c0                	test   %eax,%eax
80104271:	0f 84 bd 00 00 00    	je     80104334 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104277:	83 ec 04             	sub    $0x4,%esp
8010427a:	68 2c 00 00 00       	push   $0x2c
8010427f:	68 60 b4 10 80       	push   $0x8010b460
80104284:	50                   	push   %eax
80104285:	e8 56 31 00 00       	call   801073e0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010428a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010428d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104293:	6a 4c                	push   $0x4c
80104295:	6a 00                	push   $0x0
80104297:	ff 73 18             	pushl  0x18(%ebx)
8010429a:	e8 91 0c 00 00       	call   80104f30 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010429f:	8b 43 18             	mov    0x18(%ebx),%eax
801042a2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042a7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042aa:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042af:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042b3:	8b 43 18             	mov    0x18(%ebx),%eax
801042b6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042ba:	8b 43 18             	mov    0x18(%ebx),%eax
801042bd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042c1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801042c5:	8b 43 18             	mov    0x18(%ebx),%eax
801042c8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801042cc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801042d0:	8b 43 18             	mov    0x18(%ebx),%eax
801042d3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801042da:	8b 43 18             	mov    0x18(%ebx),%eax
801042dd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801042e4:	8b 43 18             	mov    0x18(%ebx),%eax
801042e7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801042ee:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042f1:	6a 10                	push   $0x10
801042f3:	68 90 7f 10 80       	push   $0x80107f90
801042f8:	50                   	push   %eax
801042f9:	e8 f2 0d 00 00       	call   801050f0 <safestrcpy>
  p->cwd = namei("/");
801042fe:	c7 04 24 99 7f 10 80 	movl   $0x80107f99,(%esp)
80104305:	e8 e6 e5 ff ff       	call   801028f0 <namei>
8010430a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010430d:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
80104314:	e8 07 0b 00 00       	call   80104e20 <acquire>
  p->state = RUNNABLE;
80104319:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104320:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
80104327:	e8 b4 0b 00 00       	call   80104ee0 <release>
}
8010432c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010432f:	83 c4 10             	add    $0x10,%esp
80104332:	c9                   	leave  
80104333:	c3                   	ret    
    panic("userinit: out of memory?");
80104334:	83 ec 0c             	sub    $0xc,%esp
80104337:	68 77 7f 10 80       	push   $0x80107f77
8010433c:	e8 4f c0 ff ff       	call   80100390 <panic>
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434f:	90                   	nop

80104350 <growproc>:
{
80104350:	f3 0f 1e fb          	endbr32 
80104354:	55                   	push   %ebp
80104355:	89 e5                	mov    %esp,%ebp
80104357:	56                   	push   %esi
80104358:	53                   	push   %ebx
80104359:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010435c:	e8 bf 09 00 00       	call   80104d20 <pushcli>
  c = mycpu();
80104361:	e8 2a fe ff ff       	call   80104190 <mycpu>
  p = c->proc;
80104366:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010436c:	e8 ff 09 00 00       	call   80104d70 <popcli>
  sz = curproc->sz;
80104371:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104373:	85 f6                	test   %esi,%esi
80104375:	7f 19                	jg     80104390 <growproc+0x40>
  } else if(n < 0){
80104377:	75 37                	jne    801043b0 <growproc+0x60>
  switchuvm(curproc);
80104379:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010437c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010437e:	53                   	push   %ebx
8010437f:	e8 4c 2f 00 00       	call   801072d0 <switchuvm>
  return 0;
80104384:	83 c4 10             	add    $0x10,%esp
80104387:	31 c0                	xor    %eax,%eax
}
80104389:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010438c:	5b                   	pop    %ebx
8010438d:	5e                   	pop    %esi
8010438e:	5d                   	pop    %ebp
8010438f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104390:	83 ec 04             	sub    $0x4,%esp
80104393:	01 c6                	add    %eax,%esi
80104395:	56                   	push   %esi
80104396:	50                   	push   %eax
80104397:	ff 73 04             	pushl  0x4(%ebx)
8010439a:	e8 91 31 00 00       	call   80107530 <allocuvm>
8010439f:	83 c4 10             	add    $0x10,%esp
801043a2:	85 c0                	test   %eax,%eax
801043a4:	75 d3                	jne    80104379 <growproc+0x29>
      return -1;
801043a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043ab:	eb dc                	jmp    80104389 <growproc+0x39>
801043ad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043b0:	83 ec 04             	sub    $0x4,%esp
801043b3:	01 c6                	add    %eax,%esi
801043b5:	56                   	push   %esi
801043b6:	50                   	push   %eax
801043b7:	ff 73 04             	pushl  0x4(%ebx)
801043ba:	e8 a1 32 00 00       	call   80107660 <deallocuvm>
801043bf:	83 c4 10             	add    $0x10,%esp
801043c2:	85 c0                	test   %eax,%eax
801043c4:	75 b3                	jne    80104379 <growproc+0x29>
801043c6:	eb de                	jmp    801043a6 <growproc+0x56>
801043c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043cf:	90                   	nop

801043d0 <fork>:
{
801043d0:	f3 0f 1e fb          	endbr32 
801043d4:	55                   	push   %ebp
801043d5:	89 e5                	mov    %esp,%ebp
801043d7:	57                   	push   %edi
801043d8:	56                   	push   %esi
801043d9:	53                   	push   %ebx
801043da:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801043dd:	e8 3e 09 00 00       	call   80104d20 <pushcli>
  c = mycpu();
801043e2:	e8 a9 fd ff ff       	call   80104190 <mycpu>
  p = c->proc;
801043e7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043ed:	e8 7e 09 00 00       	call   80104d70 <popcli>
  if((np = allocproc()) == 0){
801043f2:	e8 59 fc ff ff       	call   80104050 <allocproc>
801043f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801043fa:	85 c0                	test   %eax,%eax
801043fc:	0f 84 bb 00 00 00    	je     801044bd <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104402:	83 ec 08             	sub    $0x8,%esp
80104405:	ff 33                	pushl  (%ebx)
80104407:	89 c7                	mov    %eax,%edi
80104409:	ff 73 04             	pushl  0x4(%ebx)
8010440c:	e8 cf 33 00 00       	call   801077e0 <copyuvm>
80104411:	83 c4 10             	add    $0x10,%esp
80104414:	89 47 04             	mov    %eax,0x4(%edi)
80104417:	85 c0                	test   %eax,%eax
80104419:	0f 84 a5 00 00 00    	je     801044c4 <fork+0xf4>
  np->sz = curproc->sz;
8010441f:	8b 03                	mov    (%ebx),%eax
80104421:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104424:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104426:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104429:	89 c8                	mov    %ecx,%eax
8010442b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010442e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104433:	8b 73 18             	mov    0x18(%ebx),%esi
80104436:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104438:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010443a:	8b 40 18             	mov    0x18(%eax),%eax
8010443d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104448:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010444c:	85 c0                	test   %eax,%eax
8010444e:	74 13                	je     80104463 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	50                   	push   %eax
80104454:	e8 d7 d2 ff ff       	call   80101730 <filedup>
80104459:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010445c:	83 c4 10             	add    $0x10,%esp
8010445f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104463:	83 c6 01             	add    $0x1,%esi
80104466:	83 fe 10             	cmp    $0x10,%esi
80104469:	75 dd                	jne    80104448 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010446b:	83 ec 0c             	sub    $0xc,%esp
8010446e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104471:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104474:	e8 77 db ff ff       	call   80101ff0 <idup>
80104479:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010447c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010447f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104482:	8d 47 6c             	lea    0x6c(%edi),%eax
80104485:	6a 10                	push   $0x10
80104487:	53                   	push   %ebx
80104488:	50                   	push   %eax
80104489:	e8 62 0c 00 00       	call   801050f0 <safestrcpy>
  pid = np->pid;
8010448e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104491:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
80104498:	e8 83 09 00 00       	call   80104e20 <acquire>
  np->state = RUNNABLE;
8010449d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801044a4:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
801044ab:	e8 30 0a 00 00       	call   80104ee0 <release>
  return pid;
801044b0:	83 c4 10             	add    $0x10,%esp
}
801044b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044b6:	89 d8                	mov    %ebx,%eax
801044b8:	5b                   	pop    %ebx
801044b9:	5e                   	pop    %esi
801044ba:	5f                   	pop    %edi
801044bb:	5d                   	pop    %ebp
801044bc:	c3                   	ret    
    return -1;
801044bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044c2:	eb ef                	jmp    801044b3 <fork+0xe3>
    kfree(np->kstack);
801044c4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801044c7:	83 ec 0c             	sub    $0xc,%esp
801044ca:	ff 73 08             	pushl  0x8(%ebx)
801044cd:	e8 5e e8 ff ff       	call   80102d30 <kfree>
    np->kstack = 0;
801044d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801044d9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801044dc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801044e3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044e8:	eb c9                	jmp    801044b3 <fork+0xe3>
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044f0 <scheduler>:
{
801044f0:	f3 0f 1e fb          	endbr32 
801044f4:	55                   	push   %ebp
801044f5:	89 e5                	mov    %esp,%ebp
801044f7:	57                   	push   %edi
801044f8:	56                   	push   %esi
801044f9:	53                   	push   %ebx
801044fa:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801044fd:	e8 8e fc ff ff       	call   80104190 <mycpu>
  c->proc = 0;
80104502:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104509:	00 00 00 
  struct cpu *c = mycpu();
8010450c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010450e:	8d 78 04             	lea    0x4(%eax),%edi
80104511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104518:	fb                   	sti    
    acquire(&ptable.lock);
80104519:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010451c:	bb 14 43 11 80       	mov    $0x80114314,%ebx
    acquire(&ptable.lock);
80104521:	68 e0 42 11 80       	push   $0x801142e0
80104526:	e8 f5 08 00 00       	call   80104e20 <acquire>
8010452b:	83 c4 10             	add    $0x10,%esp
8010452e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104530:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104534:	75 33                	jne    80104569 <scheduler+0x79>
      switchuvm(p);
80104536:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104539:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010453f:	53                   	push   %ebx
80104540:	e8 8b 2d 00 00       	call   801072d0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104545:	58                   	pop    %eax
80104546:	5a                   	pop    %edx
80104547:	ff 73 1c             	pushl  0x1c(%ebx)
8010454a:	57                   	push   %edi
      p->state = RUNNING;
8010454b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104552:	e8 fc 0b 00 00       	call   80105153 <swtch>
      switchkvm();
80104557:	e8 54 2d 00 00       	call   801072b0 <switchkvm>
      c->proc = 0;
8010455c:	83 c4 10             	add    $0x10,%esp
8010455f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104566:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104569:	83 c3 7c             	add    $0x7c,%ebx
8010456c:	81 fb 14 62 11 80    	cmp    $0x80116214,%ebx
80104572:	75 bc                	jne    80104530 <scheduler+0x40>
    release(&ptable.lock);
80104574:	83 ec 0c             	sub    $0xc,%esp
80104577:	68 e0 42 11 80       	push   $0x801142e0
8010457c:	e8 5f 09 00 00       	call   80104ee0 <release>
    sti();
80104581:	83 c4 10             	add    $0x10,%esp
80104584:	eb 92                	jmp    80104518 <scheduler+0x28>
80104586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458d:	8d 76 00             	lea    0x0(%esi),%esi

80104590 <sched>:
{
80104590:	f3 0f 1e fb          	endbr32 
80104594:	55                   	push   %ebp
80104595:	89 e5                	mov    %esp,%ebp
80104597:	56                   	push   %esi
80104598:	53                   	push   %ebx
  pushcli();
80104599:	e8 82 07 00 00       	call   80104d20 <pushcli>
  c = mycpu();
8010459e:	e8 ed fb ff ff       	call   80104190 <mycpu>
  p = c->proc;
801045a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045a9:	e8 c2 07 00 00       	call   80104d70 <popcli>
  if(!holding(&ptable.lock))
801045ae:	83 ec 0c             	sub    $0xc,%esp
801045b1:	68 e0 42 11 80       	push   $0x801142e0
801045b6:	e8 15 08 00 00       	call   80104dd0 <holding>
801045bb:	83 c4 10             	add    $0x10,%esp
801045be:	85 c0                	test   %eax,%eax
801045c0:	74 4f                	je     80104611 <sched+0x81>
  if(mycpu()->ncli != 1)
801045c2:	e8 c9 fb ff ff       	call   80104190 <mycpu>
801045c7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801045ce:	75 68                	jne    80104638 <sched+0xa8>
  if(p->state == RUNNING)
801045d0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801045d4:	74 55                	je     8010462b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045d6:	9c                   	pushf  
801045d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045d8:	f6 c4 02             	test   $0x2,%ah
801045db:	75 41                	jne    8010461e <sched+0x8e>
  intena = mycpu()->intena;
801045dd:	e8 ae fb ff ff       	call   80104190 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801045e2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801045e5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801045eb:	e8 a0 fb ff ff       	call   80104190 <mycpu>
801045f0:	83 ec 08             	sub    $0x8,%esp
801045f3:	ff 70 04             	pushl  0x4(%eax)
801045f6:	53                   	push   %ebx
801045f7:	e8 57 0b 00 00       	call   80105153 <swtch>
  mycpu()->intena = intena;
801045fc:	e8 8f fb ff ff       	call   80104190 <mycpu>
}
80104601:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104604:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010460a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010460d:	5b                   	pop    %ebx
8010460e:	5e                   	pop    %esi
8010460f:	5d                   	pop    %ebp
80104610:	c3                   	ret    
    panic("sched ptable.lock");
80104611:	83 ec 0c             	sub    $0xc,%esp
80104614:	68 9b 7f 10 80       	push   $0x80107f9b
80104619:	e8 72 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010461e:	83 ec 0c             	sub    $0xc,%esp
80104621:	68 c7 7f 10 80       	push   $0x80107fc7
80104626:	e8 65 bd ff ff       	call   80100390 <panic>
    panic("sched running");
8010462b:	83 ec 0c             	sub    $0xc,%esp
8010462e:	68 b9 7f 10 80       	push   $0x80107fb9
80104633:	e8 58 bd ff ff       	call   80100390 <panic>
    panic("sched locks");
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	68 ad 7f 10 80       	push   $0x80107fad
80104640:	e8 4b bd ff ff       	call   80100390 <panic>
80104645:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104650 <exit>:
{
80104650:	f3 0f 1e fb          	endbr32 
80104654:	55                   	push   %ebp
80104655:	89 e5                	mov    %esp,%ebp
80104657:	57                   	push   %edi
80104658:	56                   	push   %esi
80104659:	53                   	push   %ebx
8010465a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010465d:	e8 be 06 00 00       	call   80104d20 <pushcli>
  c = mycpu();
80104662:	e8 29 fb ff ff       	call   80104190 <mycpu>
  p = c->proc;
80104667:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010466d:	e8 fe 06 00 00       	call   80104d70 <popcli>
  if(curproc == initproc)
80104672:	8d 5e 28             	lea    0x28(%esi),%ebx
80104675:	8d 7e 68             	lea    0x68(%esi),%edi
80104678:	39 35 d8 b5 10 80    	cmp    %esi,0x8010b5d8
8010467e:	0f 84 f3 00 00 00    	je     80104777 <exit+0x127>
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104688:	8b 03                	mov    (%ebx),%eax
8010468a:	85 c0                	test   %eax,%eax
8010468c:	74 12                	je     801046a0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010468e:	83 ec 0c             	sub    $0xc,%esp
80104691:	50                   	push   %eax
80104692:	e8 e9 d0 ff ff       	call   80101780 <fileclose>
      curproc->ofile[fd] = 0;
80104697:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010469d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801046a0:	83 c3 04             	add    $0x4,%ebx
801046a3:	39 df                	cmp    %ebx,%edi
801046a5:	75 e1                	jne    80104688 <exit+0x38>
  begin_op();
801046a7:	e8 44 ef ff ff       	call   801035f0 <begin_op>
  iput(curproc->cwd);
801046ac:	83 ec 0c             	sub    $0xc,%esp
801046af:	ff 76 68             	pushl  0x68(%esi)
801046b2:	e8 99 da ff ff       	call   80102150 <iput>
  end_op();
801046b7:	e8 a4 ef ff ff       	call   80103660 <end_op>
  curproc->cwd = 0;
801046bc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801046c3:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
801046ca:	e8 51 07 00 00       	call   80104e20 <acquire>
  wakeup1(curproc->parent);
801046cf:	8b 56 14             	mov    0x14(%esi),%edx
801046d2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046d5:	b8 14 43 11 80       	mov    $0x80114314,%eax
801046da:	eb 0e                	jmp    801046ea <exit+0x9a>
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e0:	83 c0 7c             	add    $0x7c,%eax
801046e3:	3d 14 62 11 80       	cmp    $0x80116214,%eax
801046e8:	74 1c                	je     80104706 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
801046ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046ee:	75 f0                	jne    801046e0 <exit+0x90>
801046f0:	3b 50 20             	cmp    0x20(%eax),%edx
801046f3:	75 eb                	jne    801046e0 <exit+0x90>
      p->state = RUNNABLE;
801046f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046fc:	83 c0 7c             	add    $0x7c,%eax
801046ff:	3d 14 62 11 80       	cmp    $0x80116214,%eax
80104704:	75 e4                	jne    801046ea <exit+0x9a>
      p->parent = initproc;
80104706:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010470c:	ba 14 43 11 80       	mov    $0x80114314,%edx
80104711:	eb 10                	jmp    80104723 <exit+0xd3>
80104713:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104717:	90                   	nop
80104718:	83 c2 7c             	add    $0x7c,%edx
8010471b:	81 fa 14 62 11 80    	cmp    $0x80116214,%edx
80104721:	74 3b                	je     8010475e <exit+0x10e>
    if(p->parent == curproc){
80104723:	39 72 14             	cmp    %esi,0x14(%edx)
80104726:	75 f0                	jne    80104718 <exit+0xc8>
      if(p->state == ZOMBIE)
80104728:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010472c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010472f:	75 e7                	jne    80104718 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104731:	b8 14 43 11 80       	mov    $0x80114314,%eax
80104736:	eb 12                	jmp    8010474a <exit+0xfa>
80104738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop
80104740:	83 c0 7c             	add    $0x7c,%eax
80104743:	3d 14 62 11 80       	cmp    $0x80116214,%eax
80104748:	74 ce                	je     80104718 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010474a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010474e:	75 f0                	jne    80104740 <exit+0xf0>
80104750:	3b 48 20             	cmp    0x20(%eax),%ecx
80104753:	75 eb                	jne    80104740 <exit+0xf0>
      p->state = RUNNABLE;
80104755:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010475c:	eb e2                	jmp    80104740 <exit+0xf0>
  curproc->state = ZOMBIE;
8010475e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104765:	e8 26 fe ff ff       	call   80104590 <sched>
  panic("zombie exit");
8010476a:	83 ec 0c             	sub    $0xc,%esp
8010476d:	68 e8 7f 10 80       	push   $0x80107fe8
80104772:	e8 19 bc ff ff       	call   80100390 <panic>
    panic("init exiting");
80104777:	83 ec 0c             	sub    $0xc,%esp
8010477a:	68 db 7f 10 80       	push   $0x80107fdb
8010477f:	e8 0c bc ff ff       	call   80100390 <panic>
80104784:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <yield>:
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	53                   	push   %ebx
80104798:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010479b:	68 e0 42 11 80       	push   $0x801142e0
801047a0:	e8 7b 06 00 00       	call   80104e20 <acquire>
  pushcli();
801047a5:	e8 76 05 00 00       	call   80104d20 <pushcli>
  c = mycpu();
801047aa:	e8 e1 f9 ff ff       	call   80104190 <mycpu>
  p = c->proc;
801047af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047b5:	e8 b6 05 00 00       	call   80104d70 <popcli>
  myproc()->state = RUNNABLE;
801047ba:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801047c1:	e8 ca fd ff ff       	call   80104590 <sched>
  release(&ptable.lock);
801047c6:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
801047cd:	e8 0e 07 00 00       	call   80104ee0 <release>
}
801047d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d5:	83 c4 10             	add    $0x10,%esp
801047d8:	c9                   	leave  
801047d9:	c3                   	ret    
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047e0 <sleep>:
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	57                   	push   %edi
801047e8:	56                   	push   %esi
801047e9:	53                   	push   %ebx
801047ea:	83 ec 0c             	sub    $0xc,%esp
801047ed:	8b 7d 08             	mov    0x8(%ebp),%edi
801047f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801047f3:	e8 28 05 00 00       	call   80104d20 <pushcli>
  c = mycpu();
801047f8:	e8 93 f9 ff ff       	call   80104190 <mycpu>
  p = c->proc;
801047fd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104803:	e8 68 05 00 00       	call   80104d70 <popcli>
  if(p == 0)
80104808:	85 db                	test   %ebx,%ebx
8010480a:	0f 84 83 00 00 00    	je     80104893 <sleep+0xb3>
  if(lk == 0)
80104810:	85 f6                	test   %esi,%esi
80104812:	74 72                	je     80104886 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104814:	81 fe e0 42 11 80    	cmp    $0x801142e0,%esi
8010481a:	74 4c                	je     80104868 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010481c:	83 ec 0c             	sub    $0xc,%esp
8010481f:	68 e0 42 11 80       	push   $0x801142e0
80104824:	e8 f7 05 00 00       	call   80104e20 <acquire>
    release(lk);
80104829:	89 34 24             	mov    %esi,(%esp)
8010482c:	e8 af 06 00 00       	call   80104ee0 <release>
  p->chan = chan;
80104831:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104834:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010483b:	e8 50 fd ff ff       	call   80104590 <sched>
  p->chan = 0;
80104840:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104847:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
8010484e:	e8 8d 06 00 00       	call   80104ee0 <release>
    acquire(lk);
80104853:	89 75 08             	mov    %esi,0x8(%ebp)
80104856:	83 c4 10             	add    $0x10,%esp
}
80104859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485c:	5b                   	pop    %ebx
8010485d:	5e                   	pop    %esi
8010485e:	5f                   	pop    %edi
8010485f:	5d                   	pop    %ebp
    acquire(lk);
80104860:	e9 bb 05 00 00       	jmp    80104e20 <acquire>
80104865:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104868:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010486b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104872:	e8 19 fd ff ff       	call   80104590 <sched>
  p->chan = 0;
80104877:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010487e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104881:	5b                   	pop    %ebx
80104882:	5e                   	pop    %esi
80104883:	5f                   	pop    %edi
80104884:	5d                   	pop    %ebp
80104885:	c3                   	ret    
    panic("sleep without lk");
80104886:	83 ec 0c             	sub    $0xc,%esp
80104889:	68 fa 7f 10 80       	push   $0x80107ffa
8010488e:	e8 fd ba ff ff       	call   80100390 <panic>
    panic("sleep");
80104893:	83 ec 0c             	sub    $0xc,%esp
80104896:	68 f4 7f 10 80       	push   $0x80107ff4
8010489b:	e8 f0 ba ff ff       	call   80100390 <panic>

801048a0 <wait>:
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	53                   	push   %ebx
  pushcli();
801048a9:	e8 72 04 00 00       	call   80104d20 <pushcli>
  c = mycpu();
801048ae:	e8 dd f8 ff ff       	call   80104190 <mycpu>
  p = c->proc;
801048b3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801048b9:	e8 b2 04 00 00       	call   80104d70 <popcli>
  acquire(&ptable.lock);
801048be:	83 ec 0c             	sub    $0xc,%esp
801048c1:	68 e0 42 11 80       	push   $0x801142e0
801048c6:	e8 55 05 00 00       	call   80104e20 <acquire>
801048cb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801048ce:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048d0:	bb 14 43 11 80       	mov    $0x80114314,%ebx
801048d5:	eb 14                	jmp    801048eb <wait+0x4b>
801048d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048de:	66 90                	xchg   %ax,%ax
801048e0:	83 c3 7c             	add    $0x7c,%ebx
801048e3:	81 fb 14 62 11 80    	cmp    $0x80116214,%ebx
801048e9:	74 1b                	je     80104906 <wait+0x66>
      if(p->parent != curproc)
801048eb:	39 73 14             	cmp    %esi,0x14(%ebx)
801048ee:	75 f0                	jne    801048e0 <wait+0x40>
      if(p->state == ZOMBIE){
801048f0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801048f4:	74 32                	je     80104928 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048f6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801048f9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048fe:	81 fb 14 62 11 80    	cmp    $0x80116214,%ebx
80104904:	75 e5                	jne    801048eb <wait+0x4b>
    if(!havekids || curproc->killed){
80104906:	85 c0                	test   %eax,%eax
80104908:	74 74                	je     8010497e <wait+0xde>
8010490a:	8b 46 24             	mov    0x24(%esi),%eax
8010490d:	85 c0                	test   %eax,%eax
8010490f:	75 6d                	jne    8010497e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104911:	83 ec 08             	sub    $0x8,%esp
80104914:	68 e0 42 11 80       	push   $0x801142e0
80104919:	56                   	push   %esi
8010491a:	e8 c1 fe ff ff       	call   801047e0 <sleep>
    havekids = 0;
8010491f:	83 c4 10             	add    $0x10,%esp
80104922:	eb aa                	jmp    801048ce <wait+0x2e>
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104928:	83 ec 0c             	sub    $0xc,%esp
8010492b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010492e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104931:	e8 fa e3 ff ff       	call   80102d30 <kfree>
        freevm(p->pgdir);
80104936:	5a                   	pop    %edx
80104937:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010493a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104941:	e8 4a 2d 00 00       	call   80107690 <freevm>
        release(&ptable.lock);
80104946:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
        p->pid = 0;
8010494d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104954:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010495b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010495f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104966:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010496d:	e8 6e 05 00 00       	call   80104ee0 <release>
        return pid;
80104972:	83 c4 10             	add    $0x10,%esp
}
80104975:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104978:	89 f0                	mov    %esi,%eax
8010497a:	5b                   	pop    %ebx
8010497b:	5e                   	pop    %esi
8010497c:	5d                   	pop    %ebp
8010497d:	c3                   	ret    
      release(&ptable.lock);
8010497e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104981:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104986:	68 e0 42 11 80       	push   $0x801142e0
8010498b:	e8 50 05 00 00       	call   80104ee0 <release>
      return -1;
80104990:	83 c4 10             	add    $0x10,%esp
80104993:	eb e0                	jmp    80104975 <wait+0xd5>
80104995:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	53                   	push   %ebx
801049a8:	83 ec 10             	sub    $0x10,%esp
801049ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801049ae:	68 e0 42 11 80       	push   $0x801142e0
801049b3:	e8 68 04 00 00       	call   80104e20 <acquire>
801049b8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049bb:	b8 14 43 11 80       	mov    $0x80114314,%eax
801049c0:	eb 10                	jmp    801049d2 <wakeup+0x32>
801049c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049c8:	83 c0 7c             	add    $0x7c,%eax
801049cb:	3d 14 62 11 80       	cmp    $0x80116214,%eax
801049d0:	74 1c                	je     801049ee <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
801049d2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049d6:	75 f0                	jne    801049c8 <wakeup+0x28>
801049d8:	3b 58 20             	cmp    0x20(%eax),%ebx
801049db:	75 eb                	jne    801049c8 <wakeup+0x28>
      p->state = RUNNABLE;
801049dd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049e4:	83 c0 7c             	add    $0x7c,%eax
801049e7:	3d 14 62 11 80       	cmp    $0x80116214,%eax
801049ec:	75 e4                	jne    801049d2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801049ee:	c7 45 08 e0 42 11 80 	movl   $0x801142e0,0x8(%ebp)
}
801049f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f8:	c9                   	leave  
  release(&ptable.lock);
801049f9:	e9 e2 04 00 00       	jmp    80104ee0 <release>
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	53                   	push   %ebx
80104a08:	83 ec 10             	sub    $0x10,%esp
80104a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104a0e:	68 e0 42 11 80       	push   $0x801142e0
80104a13:	e8 08 04 00 00       	call   80104e20 <acquire>
80104a18:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a1b:	b8 14 43 11 80       	mov    $0x80114314,%eax
80104a20:	eb 10                	jmp    80104a32 <kill+0x32>
80104a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a28:	83 c0 7c             	add    $0x7c,%eax
80104a2b:	3d 14 62 11 80       	cmp    $0x80116214,%eax
80104a30:	74 36                	je     80104a68 <kill+0x68>
    if(p->pid == pid){
80104a32:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a35:	75 f1                	jne    80104a28 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104a37:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104a3b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104a42:	75 07                	jne    80104a4b <kill+0x4b>
        p->state = RUNNABLE;
80104a44:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a4b:	83 ec 0c             	sub    $0xc,%esp
80104a4e:	68 e0 42 11 80       	push   $0x801142e0
80104a53:	e8 88 04 00 00       	call   80104ee0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104a58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104a5b:	83 c4 10             	add    $0x10,%esp
80104a5e:	31 c0                	xor    %eax,%eax
}
80104a60:	c9                   	leave  
80104a61:	c3                   	ret    
80104a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104a68:	83 ec 0c             	sub    $0xc,%esp
80104a6b:	68 e0 42 11 80       	push   $0x801142e0
80104a70:	e8 6b 04 00 00       	call   80104ee0 <release>
}
80104a75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104a78:	83 c4 10             	add    $0x10,%esp
80104a7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a80:	c9                   	leave  
80104a81:	c3                   	ret    
80104a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a90:	f3 0f 1e fb          	endbr32 
80104a94:	55                   	push   %ebp
80104a95:	89 e5                	mov    %esp,%ebp
80104a97:	57                   	push   %edi
80104a98:	56                   	push   %esi
80104a99:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104a9c:	53                   	push   %ebx
80104a9d:	bb 80 43 11 80       	mov    $0x80114380,%ebx
80104aa2:	83 ec 3c             	sub    $0x3c,%esp
80104aa5:	eb 28                	jmp    80104acf <procdump+0x3f>
80104aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aae:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ab0:	83 ec 0c             	sub    $0xc,%esp
80104ab3:	68 77 83 10 80       	push   $0x80108377
80104ab8:	e8 93 be ff ff       	call   80100950 <cprintf>
80104abd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ac0:	83 c3 7c             	add    $0x7c,%ebx
80104ac3:	81 fb 80 62 11 80    	cmp    $0x80116280,%ebx
80104ac9:	0f 84 81 00 00 00    	je     80104b50 <procdump+0xc0>
    if(p->state == UNUSED)
80104acf:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	74 ea                	je     80104ac0 <procdump+0x30>
      state = "???";
80104ad6:	ba 0b 80 10 80       	mov    $0x8010800b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104adb:	83 f8 05             	cmp    $0x5,%eax
80104ade:	77 11                	ja     80104af1 <procdump+0x61>
80104ae0:	8b 14 85 6c 80 10 80 	mov    -0x7fef7f94(,%eax,4),%edx
      state = "???";
80104ae7:	b8 0b 80 10 80       	mov    $0x8010800b,%eax
80104aec:	85 d2                	test   %edx,%edx
80104aee:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104af1:	53                   	push   %ebx
80104af2:	52                   	push   %edx
80104af3:	ff 73 a4             	pushl  -0x5c(%ebx)
80104af6:	68 0f 80 10 80       	push   $0x8010800f
80104afb:	e8 50 be ff ff       	call   80100950 <cprintf>
    if(p->state == SLEEPING){
80104b00:	83 c4 10             	add    $0x10,%esp
80104b03:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104b07:	75 a7                	jne    80104ab0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b09:	83 ec 08             	sub    $0x8,%esp
80104b0c:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b0f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b12:	50                   	push   %eax
80104b13:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104b16:	8b 40 0c             	mov    0xc(%eax),%eax
80104b19:	83 c0 08             	add    $0x8,%eax
80104b1c:	50                   	push   %eax
80104b1d:	e8 9e 01 00 00       	call   80104cc0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b22:	83 c4 10             	add    $0x10,%esp
80104b25:	8d 76 00             	lea    0x0(%esi),%esi
80104b28:	8b 17                	mov    (%edi),%edx
80104b2a:	85 d2                	test   %edx,%edx
80104b2c:	74 82                	je     80104ab0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104b2e:	83 ec 08             	sub    $0x8,%esp
80104b31:	83 c7 04             	add    $0x4,%edi
80104b34:	52                   	push   %edx
80104b35:	68 e1 79 10 80       	push   $0x801079e1
80104b3a:	e8 11 be ff ff       	call   80100950 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b3f:	83 c4 10             	add    $0x10,%esp
80104b42:	39 fe                	cmp    %edi,%esi
80104b44:	75 e2                	jne    80104b28 <procdump+0x98>
80104b46:	e9 65 ff ff ff       	jmp    80104ab0 <procdump+0x20>
80104b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b4f:	90                   	nop
  }
}
80104b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b53:	5b                   	pop    %ebx
80104b54:	5e                   	pop    %esi
80104b55:	5f                   	pop    %edi
80104b56:	5d                   	pop    %ebp
80104b57:	c3                   	ret    
80104b58:	66 90                	xchg   %ax,%ax
80104b5a:	66 90                	xchg   %ax,%ax
80104b5c:	66 90                	xchg   %ax,%ax
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	53                   	push   %ebx
80104b68:	83 ec 0c             	sub    $0xc,%esp
80104b6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b6e:	68 84 80 10 80       	push   $0x80108084
80104b73:	8d 43 04             	lea    0x4(%ebx),%eax
80104b76:	50                   	push   %eax
80104b77:	e8 24 01 00 00       	call   80104ca0 <initlock>
  lk->name = name;
80104b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b7f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b85:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b88:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b8f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b95:	c9                   	leave  
80104b96:	c3                   	ret    
80104b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9e:	66 90                	xchg   %ax,%ax

80104ba0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ba0:	f3 0f 1e fb          	endbr32 
80104ba4:	55                   	push   %ebp
80104ba5:	89 e5                	mov    %esp,%ebp
80104ba7:	56                   	push   %esi
80104ba8:	53                   	push   %ebx
80104ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bac:	8d 73 04             	lea    0x4(%ebx),%esi
80104baf:	83 ec 0c             	sub    $0xc,%esp
80104bb2:	56                   	push   %esi
80104bb3:	e8 68 02 00 00       	call   80104e20 <acquire>
  while (lk->locked) {
80104bb8:	8b 13                	mov    (%ebx),%edx
80104bba:	83 c4 10             	add    $0x10,%esp
80104bbd:	85 d2                	test   %edx,%edx
80104bbf:	74 1a                	je     80104bdb <acquiresleep+0x3b>
80104bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104bc8:	83 ec 08             	sub    $0x8,%esp
80104bcb:	56                   	push   %esi
80104bcc:	53                   	push   %ebx
80104bcd:	e8 0e fc ff ff       	call   801047e0 <sleep>
  while (lk->locked) {
80104bd2:	8b 03                	mov    (%ebx),%eax
80104bd4:	83 c4 10             	add    $0x10,%esp
80104bd7:	85 c0                	test   %eax,%eax
80104bd9:	75 ed                	jne    80104bc8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104bdb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104be1:	e8 3a f6 ff ff       	call   80104220 <myproc>
80104be6:	8b 40 10             	mov    0x10(%eax),%eax
80104be9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104bec:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bf2:	5b                   	pop    %ebx
80104bf3:	5e                   	pop    %esi
80104bf4:	5d                   	pop    %ebp
  release(&lk->lk);
80104bf5:	e9 e6 02 00 00       	jmp    80104ee0 <release>
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c00 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c00:	f3 0f 1e fb          	endbr32 
80104c04:	55                   	push   %ebp
80104c05:	89 e5                	mov    %esp,%ebp
80104c07:	56                   	push   %esi
80104c08:	53                   	push   %ebx
80104c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c0c:	8d 73 04             	lea    0x4(%ebx),%esi
80104c0f:	83 ec 0c             	sub    $0xc,%esp
80104c12:	56                   	push   %esi
80104c13:	e8 08 02 00 00       	call   80104e20 <acquire>
  lk->locked = 0;
80104c18:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c1e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c25:	89 1c 24             	mov    %ebx,(%esp)
80104c28:	e8 73 fd ff ff       	call   801049a0 <wakeup>
  release(&lk->lk);
80104c2d:	89 75 08             	mov    %esi,0x8(%ebp)
80104c30:	83 c4 10             	add    $0x10,%esp
}
80104c33:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c36:	5b                   	pop    %ebx
80104c37:	5e                   	pop    %esi
80104c38:	5d                   	pop    %ebp
  release(&lk->lk);
80104c39:	e9 a2 02 00 00       	jmp    80104ee0 <release>
80104c3e:	66 90                	xchg   %ax,%ax

80104c40 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	57                   	push   %edi
80104c48:	31 ff                	xor    %edi,%edi
80104c4a:	56                   	push   %esi
80104c4b:	53                   	push   %ebx
80104c4c:	83 ec 18             	sub    $0x18,%esp
80104c4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c52:	8d 73 04             	lea    0x4(%ebx),%esi
80104c55:	56                   	push   %esi
80104c56:	e8 c5 01 00 00       	call   80104e20 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c5b:	8b 03                	mov    (%ebx),%eax
80104c5d:	83 c4 10             	add    $0x10,%esp
80104c60:	85 c0                	test   %eax,%eax
80104c62:	75 1c                	jne    80104c80 <holdingsleep+0x40>
  release(&lk->lk);
80104c64:	83 ec 0c             	sub    $0xc,%esp
80104c67:	56                   	push   %esi
80104c68:	e8 73 02 00 00       	call   80104ee0 <release>
  return r;
}
80104c6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c70:	89 f8                	mov    %edi,%eax
80104c72:	5b                   	pop    %ebx
80104c73:	5e                   	pop    %esi
80104c74:	5f                   	pop    %edi
80104c75:	5d                   	pop    %ebp
80104c76:	c3                   	ret    
80104c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104c80:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c83:	e8 98 f5 ff ff       	call   80104220 <myproc>
80104c88:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c8b:	0f 94 c0             	sete   %al
80104c8e:	0f b6 c0             	movzbl %al,%eax
80104c91:	89 c7                	mov    %eax,%edi
80104c93:	eb cf                	jmp    80104c64 <holdingsleep+0x24>
80104c95:	66 90                	xchg   %ax,%ax
80104c97:	66 90                	xchg   %ax,%ax
80104c99:	66 90                	xchg   %ax,%ax
80104c9b:	66 90                	xchg   %ax,%ax
80104c9d:	66 90                	xchg   %ax,%ax
80104c9f:	90                   	nop

80104ca0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ca0:	f3 0f 1e fb          	endbr32 
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104cad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104cb3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104cb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cbd:	5d                   	pop    %ebp
80104cbe:	c3                   	ret    
80104cbf:	90                   	nop

80104cc0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cc5:	31 d2                	xor    %edx,%edx
{
80104cc7:	89 e5                	mov    %esp,%ebp
80104cc9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104cca:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ccd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104cd0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cd7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cd8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cde:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ce4:	77 1a                	ja     80104d00 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ce6:	8b 58 04             	mov    0x4(%eax),%ebx
80104ce9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104cec:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104cef:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cf1:	83 fa 0a             	cmp    $0xa,%edx
80104cf4:	75 e2                	jne    80104cd8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104cf6:	5b                   	pop    %ebx
80104cf7:	5d                   	pop    %ebp
80104cf8:	c3                   	ret    
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104d00:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d03:	8d 51 28             	lea    0x28(%ecx),%edx
80104d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d16:	83 c0 04             	add    $0x4,%eax
80104d19:	39 d0                	cmp    %edx,%eax
80104d1b:	75 f3                	jne    80104d10 <getcallerpcs+0x50>
}
80104d1d:	5b                   	pop    %ebx
80104d1e:	5d                   	pop    %ebp
80104d1f:	c3                   	ret    

80104d20 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	53                   	push   %ebx
80104d28:	83 ec 04             	sub    $0x4,%esp
80104d2b:	9c                   	pushf  
80104d2c:	5b                   	pop    %ebx
  asm volatile("cli");
80104d2d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d2e:	e8 5d f4 ff ff       	call   80104190 <mycpu>
80104d33:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d39:	85 c0                	test   %eax,%eax
80104d3b:	74 13                	je     80104d50 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d3d:	e8 4e f4 ff ff       	call   80104190 <mycpu>
80104d42:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d49:	83 c4 04             	add    $0x4,%esp
80104d4c:	5b                   	pop    %ebx
80104d4d:	5d                   	pop    %ebp
80104d4e:	c3                   	ret    
80104d4f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104d50:	e8 3b f4 ff ff       	call   80104190 <mycpu>
80104d55:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d5b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d61:	eb da                	jmp    80104d3d <pushcli+0x1d>
80104d63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d70 <popcli>:

void
popcli(void)
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d7a:	9c                   	pushf  
80104d7b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d7c:	f6 c4 02             	test   $0x2,%ah
80104d7f:	75 31                	jne    80104db2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d81:	e8 0a f4 ff ff       	call   80104190 <mycpu>
80104d86:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d8d:	78 30                	js     80104dbf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d8f:	e8 fc f3 ff ff       	call   80104190 <mycpu>
80104d94:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d9a:	85 d2                	test   %edx,%edx
80104d9c:	74 02                	je     80104da0 <popcli+0x30>
    sti();
}
80104d9e:	c9                   	leave  
80104d9f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104da0:	e8 eb f3 ff ff       	call   80104190 <mycpu>
80104da5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104dab:	85 c0                	test   %eax,%eax
80104dad:	74 ef                	je     80104d9e <popcli+0x2e>
  asm volatile("sti");
80104daf:	fb                   	sti    
}
80104db0:	c9                   	leave  
80104db1:	c3                   	ret    
    panic("popcli - interruptible");
80104db2:	83 ec 0c             	sub    $0xc,%esp
80104db5:	68 8f 80 10 80       	push   $0x8010808f
80104dba:	e8 d1 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104dbf:	83 ec 0c             	sub    $0xc,%esp
80104dc2:	68 a6 80 10 80       	push   $0x801080a6
80104dc7:	e8 c4 b5 ff ff       	call   80100390 <panic>
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <holding>:
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	56                   	push   %esi
80104dd8:	53                   	push   %ebx
80104dd9:	8b 75 08             	mov    0x8(%ebp),%esi
80104ddc:	31 db                	xor    %ebx,%ebx
  pushcli();
80104dde:	e8 3d ff ff ff       	call   80104d20 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104de3:	8b 06                	mov    (%esi),%eax
80104de5:	85 c0                	test   %eax,%eax
80104de7:	75 0f                	jne    80104df8 <holding+0x28>
  popcli();
80104de9:	e8 82 ff ff ff       	call   80104d70 <popcli>
}
80104dee:	89 d8                	mov    %ebx,%eax
80104df0:	5b                   	pop    %ebx
80104df1:	5e                   	pop    %esi
80104df2:	5d                   	pop    %ebp
80104df3:	c3                   	ret    
80104df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104df8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104dfb:	e8 90 f3 ff ff       	call   80104190 <mycpu>
80104e00:	39 c3                	cmp    %eax,%ebx
80104e02:	0f 94 c3             	sete   %bl
  popcli();
80104e05:	e8 66 ff ff ff       	call   80104d70 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104e0a:	0f b6 db             	movzbl %bl,%ebx
}
80104e0d:	89 d8                	mov    %ebx,%eax
80104e0f:	5b                   	pop    %ebx
80104e10:	5e                   	pop    %esi
80104e11:	5d                   	pop    %ebp
80104e12:	c3                   	ret    
80104e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e20 <acquire>:
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	56                   	push   %esi
80104e28:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e29:	e8 f2 fe ff ff       	call   80104d20 <pushcli>
  if(holding(lk))
80104e2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e31:	83 ec 0c             	sub    $0xc,%esp
80104e34:	53                   	push   %ebx
80104e35:	e8 96 ff ff ff       	call   80104dd0 <holding>
80104e3a:	83 c4 10             	add    $0x10,%esp
80104e3d:	85 c0                	test   %eax,%eax
80104e3f:	0f 85 7f 00 00 00    	jne    80104ec4 <acquire+0xa4>
80104e45:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e47:	ba 01 00 00 00       	mov    $0x1,%edx
80104e4c:	eb 05                	jmp    80104e53 <acquire+0x33>
80104e4e:	66 90                	xchg   %ax,%ax
80104e50:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e53:	89 d0                	mov    %edx,%eax
80104e55:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e58:	85 c0                	test   %eax,%eax
80104e5a:	75 f4                	jne    80104e50 <acquire+0x30>
  __sync_synchronize();
80104e5c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e64:	e8 27 f3 ff ff       	call   80104190 <mycpu>
80104e69:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e6c:	89 e8                	mov    %ebp,%eax
80104e6e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e70:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104e76:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104e7c:	77 22                	ja     80104ea0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e7e:	8b 50 04             	mov    0x4(%eax),%edx
80104e81:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104e85:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e88:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e8a:	83 fe 0a             	cmp    $0xa,%esi
80104e8d:	75 e1                	jne    80104e70 <acquire+0x50>
}
80104e8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e92:	5b                   	pop    %ebx
80104e93:	5e                   	pop    %esi
80104e94:	5d                   	pop    %ebp
80104e95:	c3                   	ret    
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104ea0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104ea4:	83 c3 34             	add    $0x34,%ebx
80104ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104eb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104eb6:	83 c0 04             	add    $0x4,%eax
80104eb9:	39 d8                	cmp    %ebx,%eax
80104ebb:	75 f3                	jne    80104eb0 <acquire+0x90>
}
80104ebd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec0:	5b                   	pop    %ebx
80104ec1:	5e                   	pop    %esi
80104ec2:	5d                   	pop    %ebp
80104ec3:	c3                   	ret    
    panic("acquire");
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	68 ad 80 10 80       	push   $0x801080ad
80104ecc:	e8 bf b4 ff ff       	call   80100390 <panic>
80104ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edf:	90                   	nop

80104ee0 <release>:
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	53                   	push   %ebx
80104ee8:	83 ec 10             	sub    $0x10,%esp
80104eeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104eee:	53                   	push   %ebx
80104eef:	e8 dc fe ff ff       	call   80104dd0 <holding>
80104ef4:	83 c4 10             	add    $0x10,%esp
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	74 22                	je     80104f1d <release+0x3d>
  lk->pcs[0] = 0;
80104efb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f02:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f09:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f0e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f17:	c9                   	leave  
  popcli();
80104f18:	e9 53 fe ff ff       	jmp    80104d70 <popcli>
    panic("release");
80104f1d:	83 ec 0c             	sub    $0xc,%esp
80104f20:	68 b5 80 10 80       	push   $0x801080b5
80104f25:	e8 66 b4 ff ff       	call   80100390 <panic>
80104f2a:	66 90                	xchg   %ax,%ax
80104f2c:	66 90                	xchg   %ax,%ax
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	57                   	push   %edi
80104f38:	8b 55 08             	mov    0x8(%ebp),%edx
80104f3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f3e:	53                   	push   %ebx
80104f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f42:	89 d7                	mov    %edx,%edi
80104f44:	09 cf                	or     %ecx,%edi
80104f46:	83 e7 03             	and    $0x3,%edi
80104f49:	75 25                	jne    80104f70 <memset+0x40>
    c &= 0xFF;
80104f4b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f4e:	c1 e0 18             	shl    $0x18,%eax
80104f51:	89 fb                	mov    %edi,%ebx
80104f53:	c1 e9 02             	shr    $0x2,%ecx
80104f56:	c1 e3 10             	shl    $0x10,%ebx
80104f59:	09 d8                	or     %ebx,%eax
80104f5b:	09 f8                	or     %edi,%eax
80104f5d:	c1 e7 08             	shl    $0x8,%edi
80104f60:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f62:	89 d7                	mov    %edx,%edi
80104f64:	fc                   	cld    
80104f65:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f67:	5b                   	pop    %ebx
80104f68:	89 d0                	mov    %edx,%eax
80104f6a:	5f                   	pop    %edi
80104f6b:	5d                   	pop    %ebp
80104f6c:	c3                   	ret    
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104f70:	89 d7                	mov    %edx,%edi
80104f72:	fc                   	cld    
80104f73:	f3 aa                	rep stos %al,%es:(%edi)
80104f75:	5b                   	pop    %ebx
80104f76:	89 d0                	mov    %edx,%eax
80104f78:	5f                   	pop    %edi
80104f79:	5d                   	pop    %ebp
80104f7a:	c3                   	ret    
80104f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f7f:	90                   	nop

80104f80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	56                   	push   %esi
80104f88:	8b 75 10             	mov    0x10(%ebp),%esi
80104f8b:	8b 55 08             	mov    0x8(%ebp),%edx
80104f8e:	53                   	push   %ebx
80104f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f92:	85 f6                	test   %esi,%esi
80104f94:	74 2a                	je     80104fc0 <memcmp+0x40>
80104f96:	01 c6                	add    %eax,%esi
80104f98:	eb 10                	jmp    80104faa <memcmp+0x2a>
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104fa0:	83 c0 01             	add    $0x1,%eax
80104fa3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104fa6:	39 f0                	cmp    %esi,%eax
80104fa8:	74 16                	je     80104fc0 <memcmp+0x40>
    if(*s1 != *s2)
80104faa:	0f b6 0a             	movzbl (%edx),%ecx
80104fad:	0f b6 18             	movzbl (%eax),%ebx
80104fb0:	38 d9                	cmp    %bl,%cl
80104fb2:	74 ec                	je     80104fa0 <memcmp+0x20>
      return *s1 - *s2;
80104fb4:	0f b6 c1             	movzbl %cl,%eax
80104fb7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104fb9:	5b                   	pop    %ebx
80104fba:	5e                   	pop    %esi
80104fbb:	5d                   	pop    %ebp
80104fbc:	c3                   	ret    
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi
80104fc0:	5b                   	pop    %ebx
  return 0;
80104fc1:	31 c0                	xor    %eax,%eax
}
80104fc3:	5e                   	pop    %esi
80104fc4:	5d                   	pop    %ebp
80104fc5:	c3                   	ret    
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi

80104fd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	57                   	push   %edi
80104fd8:	8b 55 08             	mov    0x8(%ebp),%edx
80104fdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fde:	56                   	push   %esi
80104fdf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fe2:	39 d6                	cmp    %edx,%esi
80104fe4:	73 2a                	jae    80105010 <memmove+0x40>
80104fe6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104fe9:	39 fa                	cmp    %edi,%edx
80104feb:	73 23                	jae    80105010 <memmove+0x40>
80104fed:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104ff0:	85 c9                	test   %ecx,%ecx
80104ff2:	74 13                	je     80105007 <memmove+0x37>
80104ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104ff8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104ffc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104fff:	83 e8 01             	sub    $0x1,%eax
80105002:	83 f8 ff             	cmp    $0xffffffff,%eax
80105005:	75 f1                	jne    80104ff8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105007:	5e                   	pop    %esi
80105008:	89 d0                	mov    %edx,%eax
8010500a:	5f                   	pop    %edi
8010500b:	5d                   	pop    %ebp
8010500c:	c3                   	ret    
8010500d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105010:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105013:	89 d7                	mov    %edx,%edi
80105015:	85 c9                	test   %ecx,%ecx
80105017:	74 ee                	je     80105007 <memmove+0x37>
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105020:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105021:	39 f0                	cmp    %esi,%eax
80105023:	75 fb                	jne    80105020 <memmove+0x50>
}
80105025:	5e                   	pop    %esi
80105026:	89 d0                	mov    %edx,%eax
80105028:	5f                   	pop    %edi
80105029:	5d                   	pop    %ebp
8010502a:	c3                   	ret    
8010502b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010502f:	90                   	nop

80105030 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105030:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105034:	eb 9a                	jmp    80104fd0 <memmove>
80105036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503d:	8d 76 00             	lea    0x0(%esi),%esi

80105040 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	56                   	push   %esi
80105048:	8b 75 10             	mov    0x10(%ebp),%esi
8010504b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010504e:	53                   	push   %ebx
8010504f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105052:	85 f6                	test   %esi,%esi
80105054:	74 32                	je     80105088 <strncmp+0x48>
80105056:	01 c6                	add    %eax,%esi
80105058:	eb 14                	jmp    8010506e <strncmp+0x2e>
8010505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105060:	38 da                	cmp    %bl,%dl
80105062:	75 14                	jne    80105078 <strncmp+0x38>
    n--, p++, q++;
80105064:	83 c0 01             	add    $0x1,%eax
80105067:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010506a:	39 f0                	cmp    %esi,%eax
8010506c:	74 1a                	je     80105088 <strncmp+0x48>
8010506e:	0f b6 11             	movzbl (%ecx),%edx
80105071:	0f b6 18             	movzbl (%eax),%ebx
80105074:	84 d2                	test   %dl,%dl
80105076:	75 e8                	jne    80105060 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105078:	0f b6 c2             	movzbl %dl,%eax
8010507b:	29 d8                	sub    %ebx,%eax
}
8010507d:	5b                   	pop    %ebx
8010507e:	5e                   	pop    %esi
8010507f:	5d                   	pop    %ebp
80105080:	c3                   	ret    
80105081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105088:	5b                   	pop    %ebx
    return 0;
80105089:	31 c0                	xor    %eax,%eax
}
8010508b:	5e                   	pop    %esi
8010508c:	5d                   	pop    %ebp
8010508d:	c3                   	ret    
8010508e:	66 90                	xchg   %ax,%ax

80105090 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	57                   	push   %edi
80105098:	56                   	push   %esi
80105099:	8b 75 08             	mov    0x8(%ebp),%esi
8010509c:	53                   	push   %ebx
8010509d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050a0:	89 f2                	mov    %esi,%edx
801050a2:	eb 1b                	jmp    801050bf <strncpy+0x2f>
801050a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050a8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801050ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
801050af:	83 c2 01             	add    $0x1,%edx
801050b2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801050b6:	89 f9                	mov    %edi,%ecx
801050b8:	88 4a ff             	mov    %cl,-0x1(%edx)
801050bb:	84 c9                	test   %cl,%cl
801050bd:	74 09                	je     801050c8 <strncpy+0x38>
801050bf:	89 c3                	mov    %eax,%ebx
801050c1:	83 e8 01             	sub    $0x1,%eax
801050c4:	85 db                	test   %ebx,%ebx
801050c6:	7f e0                	jg     801050a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801050c8:	89 d1                	mov    %edx,%ecx
801050ca:	85 c0                	test   %eax,%eax
801050cc:	7e 15                	jle    801050e3 <strncpy+0x53>
801050ce:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801050d0:	83 c1 01             	add    $0x1,%ecx
801050d3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801050d7:	89 c8                	mov    %ecx,%eax
801050d9:	f7 d0                	not    %eax
801050db:	01 d0                	add    %edx,%eax
801050dd:	01 d8                	add    %ebx,%eax
801050df:	85 c0                	test   %eax,%eax
801050e1:	7f ed                	jg     801050d0 <strncpy+0x40>
  return os;
}
801050e3:	5b                   	pop    %ebx
801050e4:	89 f0                	mov    %esi,%eax
801050e6:	5e                   	pop    %esi
801050e7:	5f                   	pop    %edi
801050e8:	5d                   	pop    %ebp
801050e9:	c3                   	ret    
801050ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050f0:	f3 0f 1e fb          	endbr32 
801050f4:	55                   	push   %ebp
801050f5:	89 e5                	mov    %esp,%ebp
801050f7:	56                   	push   %esi
801050f8:	8b 55 10             	mov    0x10(%ebp),%edx
801050fb:	8b 75 08             	mov    0x8(%ebp),%esi
801050fe:	53                   	push   %ebx
801050ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105102:	85 d2                	test   %edx,%edx
80105104:	7e 21                	jle    80105127 <safestrcpy+0x37>
80105106:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010510a:	89 f2                	mov    %esi,%edx
8010510c:	eb 12                	jmp    80105120 <safestrcpy+0x30>
8010510e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105110:	0f b6 08             	movzbl (%eax),%ecx
80105113:	83 c0 01             	add    $0x1,%eax
80105116:	83 c2 01             	add    $0x1,%edx
80105119:	88 4a ff             	mov    %cl,-0x1(%edx)
8010511c:	84 c9                	test   %cl,%cl
8010511e:	74 04                	je     80105124 <safestrcpy+0x34>
80105120:	39 d8                	cmp    %ebx,%eax
80105122:	75 ec                	jne    80105110 <safestrcpy+0x20>
    ;
  *s = 0;
80105124:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105127:	89 f0                	mov    %esi,%eax
80105129:	5b                   	pop    %ebx
8010512a:	5e                   	pop    %esi
8010512b:	5d                   	pop    %ebp
8010512c:	c3                   	ret    
8010512d:	8d 76 00             	lea    0x0(%esi),%esi

80105130 <strlen>:

int
strlen(const char *s)
{
80105130:	f3 0f 1e fb          	endbr32 
80105134:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105135:	31 c0                	xor    %eax,%eax
{
80105137:	89 e5                	mov    %esp,%ebp
80105139:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010513c:	80 3a 00             	cmpb   $0x0,(%edx)
8010513f:	74 10                	je     80105151 <strlen+0x21>
80105141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105148:	83 c0 01             	add    $0x1,%eax
8010514b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010514f:	75 f7                	jne    80105148 <strlen+0x18>
    ;
  return n;
}
80105151:	5d                   	pop    %ebp
80105152:	c3                   	ret    

80105153 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105153:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105157:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010515b:	55                   	push   %ebp
  pushl %ebx
8010515c:	53                   	push   %ebx
  pushl %esi
8010515d:	56                   	push   %esi
  pushl %edi
8010515e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010515f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105161:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105163:	5f                   	pop    %edi
  popl %esi
80105164:	5e                   	pop    %esi
  popl %ebx
80105165:	5b                   	pop    %ebx
  popl %ebp
80105166:	5d                   	pop    %ebp
  ret
80105167:	c3                   	ret    
80105168:	66 90                	xchg   %ax,%ax
8010516a:	66 90                	xchg   %ax,%ax
8010516c:	66 90                	xchg   %ax,%ax
8010516e:	66 90                	xchg   %ax,%ax

80105170 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105170:	f3 0f 1e fb          	endbr32 
80105174:	55                   	push   %ebp
80105175:	89 e5                	mov    %esp,%ebp
80105177:	53                   	push   %ebx
80105178:	83 ec 04             	sub    $0x4,%esp
8010517b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010517e:	e8 9d f0 ff ff       	call   80104220 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105183:	8b 00                	mov    (%eax),%eax
80105185:	39 d8                	cmp    %ebx,%eax
80105187:	76 17                	jbe    801051a0 <fetchint+0x30>
80105189:	8d 53 04             	lea    0x4(%ebx),%edx
8010518c:	39 d0                	cmp    %edx,%eax
8010518e:	72 10                	jb     801051a0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105190:	8b 45 0c             	mov    0xc(%ebp),%eax
80105193:	8b 13                	mov    (%ebx),%edx
80105195:	89 10                	mov    %edx,(%eax)
  return 0;
80105197:	31 c0                	xor    %eax,%eax
}
80105199:	83 c4 04             	add    $0x4,%esp
8010519c:	5b                   	pop    %ebx
8010519d:	5d                   	pop    %ebp
8010519e:	c3                   	ret    
8010519f:	90                   	nop
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a5:	eb f2                	jmp    80105199 <fetchint+0x29>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	53                   	push   %ebx
801051b8:	83 ec 04             	sub    $0x4,%esp
801051bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801051be:	e8 5d f0 ff ff       	call   80104220 <myproc>

  if(addr >= curproc->sz)
801051c3:	39 18                	cmp    %ebx,(%eax)
801051c5:	76 31                	jbe    801051f8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801051c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801051ca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801051cc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801051ce:	39 d3                	cmp    %edx,%ebx
801051d0:	73 26                	jae    801051f8 <fetchstr+0x48>
801051d2:	89 d8                	mov    %ebx,%eax
801051d4:	eb 11                	jmp    801051e7 <fetchstr+0x37>
801051d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
801051e0:	83 c0 01             	add    $0x1,%eax
801051e3:	39 c2                	cmp    %eax,%edx
801051e5:	76 11                	jbe    801051f8 <fetchstr+0x48>
    if(*s == 0)
801051e7:	80 38 00             	cmpb   $0x0,(%eax)
801051ea:	75 f4                	jne    801051e0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801051ec:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801051ef:	29 d8                	sub    %ebx,%eax
}
801051f1:	5b                   	pop    %ebx
801051f2:	5d                   	pop    %ebp
801051f3:	c3                   	ret    
801051f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051f8:	83 c4 04             	add    $0x4,%esp
    return -1;
801051fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105200:	5b                   	pop    %ebx
80105201:	5d                   	pop    %ebp
80105202:	c3                   	ret    
80105203:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105210 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	56                   	push   %esi
80105218:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105219:	e8 02 f0 ff ff       	call   80104220 <myproc>
8010521e:	8b 55 08             	mov    0x8(%ebp),%edx
80105221:	8b 40 18             	mov    0x18(%eax),%eax
80105224:	8b 40 44             	mov    0x44(%eax),%eax
80105227:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010522a:	e8 f1 ef ff ff       	call   80104220 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010522f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105232:	8b 00                	mov    (%eax),%eax
80105234:	39 c6                	cmp    %eax,%esi
80105236:	73 18                	jae    80105250 <argint+0x40>
80105238:	8d 53 08             	lea    0x8(%ebx),%edx
8010523b:	39 d0                	cmp    %edx,%eax
8010523d:	72 11                	jb     80105250 <argint+0x40>
  *ip = *(int*)(addr);
8010523f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105242:	8b 53 04             	mov    0x4(%ebx),%edx
80105245:	89 10                	mov    %edx,(%eax)
  return 0;
80105247:	31 c0                	xor    %eax,%eax
}
80105249:	5b                   	pop    %ebx
8010524a:	5e                   	pop    %esi
8010524b:	5d                   	pop    %ebp
8010524c:	c3                   	ret    
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105255:	eb f2                	jmp    80105249 <argint+0x39>
80105257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525e:	66 90                	xchg   %ax,%ax

80105260 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105260:	f3 0f 1e fb          	endbr32 
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	56                   	push   %esi
80105268:	53                   	push   %ebx
80105269:	83 ec 10             	sub    $0x10,%esp
8010526c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010526f:	e8 ac ef ff ff       	call   80104220 <myproc>
 
  if(argint(n, &i) < 0)
80105274:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105277:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105279:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010527c:	50                   	push   %eax
8010527d:	ff 75 08             	pushl  0x8(%ebp)
80105280:	e8 8b ff ff ff       	call   80105210 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105285:	83 c4 10             	add    $0x10,%esp
80105288:	85 c0                	test   %eax,%eax
8010528a:	78 24                	js     801052b0 <argptr+0x50>
8010528c:	85 db                	test   %ebx,%ebx
8010528e:	78 20                	js     801052b0 <argptr+0x50>
80105290:	8b 16                	mov    (%esi),%edx
80105292:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105295:	39 c2                	cmp    %eax,%edx
80105297:	76 17                	jbe    801052b0 <argptr+0x50>
80105299:	01 c3                	add    %eax,%ebx
8010529b:	39 da                	cmp    %ebx,%edx
8010529d:	72 11                	jb     801052b0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010529f:	8b 55 0c             	mov    0xc(%ebp),%edx
801052a2:	89 02                	mov    %eax,(%edx)
  return 0;
801052a4:	31 c0                	xor    %eax,%eax
}
801052a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a9:	5b                   	pop    %ebx
801052aa:	5e                   	pop    %esi
801052ab:	5d                   	pop    %ebp
801052ac:	c3                   	ret    
801052ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b5:	eb ef                	jmp    801052a6 <argptr+0x46>
801052b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052be:	66 90                	xchg   %ax,%ax

801052c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052cd:	50                   	push   %eax
801052ce:	ff 75 08             	pushl  0x8(%ebp)
801052d1:	e8 3a ff ff ff       	call   80105210 <argint>
801052d6:	83 c4 10             	add    $0x10,%esp
801052d9:	85 c0                	test   %eax,%eax
801052db:	78 13                	js     801052f0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801052dd:	83 ec 08             	sub    $0x8,%esp
801052e0:	ff 75 0c             	pushl  0xc(%ebp)
801052e3:	ff 75 f4             	pushl  -0xc(%ebp)
801052e6:	e8 c5 fe ff ff       	call   801051b0 <fetchstr>
801052eb:	83 c4 10             	add    $0x10,%esp
}
801052ee:	c9                   	leave  
801052ef:	c3                   	ret    
801052f0:	c9                   	leave  
    return -1;
801052f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f6:	c3                   	ret    
801052f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052fe:	66 90                	xchg   %ax,%ax

80105300 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105300:	f3 0f 1e fb          	endbr32 
80105304:	55                   	push   %ebp
80105305:	89 e5                	mov    %esp,%ebp
80105307:	53                   	push   %ebx
80105308:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010530b:	e8 10 ef ff ff       	call   80104220 <myproc>
80105310:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105312:	8b 40 18             	mov    0x18(%eax),%eax
80105315:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105318:	8d 50 ff             	lea    -0x1(%eax),%edx
8010531b:	83 fa 14             	cmp    $0x14,%edx
8010531e:	77 20                	ja     80105340 <syscall+0x40>
80105320:	8b 14 85 e0 80 10 80 	mov    -0x7fef7f20(,%eax,4),%edx
80105327:	85 d2                	test   %edx,%edx
80105329:	74 15                	je     80105340 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010532b:	ff d2                	call   *%edx
8010532d:	89 c2                	mov    %eax,%edx
8010532f:	8b 43 18             	mov    0x18(%ebx),%eax
80105332:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105338:	c9                   	leave  
80105339:	c3                   	ret    
8010533a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105340:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105341:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105344:	50                   	push   %eax
80105345:	ff 73 10             	pushl  0x10(%ebx)
80105348:	68 bd 80 10 80       	push   $0x801080bd
8010534d:	e8 fe b5 ff ff       	call   80100950 <cprintf>
    curproc->tf->eax = -1;
80105352:	8b 43 18             	mov    0x18(%ebx),%eax
80105355:	83 c4 10             	add    $0x10,%esp
80105358:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010535f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105362:	c9                   	leave  
80105363:	c3                   	ret    
80105364:	66 90                	xchg   %ax,%ax
80105366:	66 90                	xchg   %ax,%ax
80105368:	66 90                	xchg   %ax,%ax
8010536a:	66 90                	xchg   %ax,%ax
8010536c:	66 90                	xchg   %ax,%ax
8010536e:	66 90                	xchg   %ax,%ax

80105370 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105375:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105378:	53                   	push   %ebx
80105379:	83 ec 34             	sub    $0x34,%esp
8010537c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010537f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105382:	57                   	push   %edi
80105383:	50                   	push   %eax
{
80105384:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105387:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010538a:	e8 81 d5 ff ff       	call   80102910 <nameiparent>
8010538f:	83 c4 10             	add    $0x10,%esp
80105392:	85 c0                	test   %eax,%eax
80105394:	0f 84 46 01 00 00    	je     801054e0 <create+0x170>
    return 0;
  ilock(dp);
8010539a:	83 ec 0c             	sub    $0xc,%esp
8010539d:	89 c3                	mov    %eax,%ebx
8010539f:	50                   	push   %eax
801053a0:	e8 7b cc ff ff       	call   80102020 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801053a5:	83 c4 0c             	add    $0xc,%esp
801053a8:	6a 00                	push   $0x0
801053aa:	57                   	push   %edi
801053ab:	53                   	push   %ebx
801053ac:	e8 bf d1 ff ff       	call   80102570 <dirlookup>
801053b1:	83 c4 10             	add    $0x10,%esp
801053b4:	89 c6                	mov    %eax,%esi
801053b6:	85 c0                	test   %eax,%eax
801053b8:	74 56                	je     80105410 <create+0xa0>
    iunlockput(dp);
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	53                   	push   %ebx
801053be:	e8 fd ce ff ff       	call   801022c0 <iunlockput>
    ilock(ip);
801053c3:	89 34 24             	mov    %esi,(%esp)
801053c6:	e8 55 cc ff ff       	call   80102020 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053cb:	83 c4 10             	add    $0x10,%esp
801053ce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801053d3:	75 1b                	jne    801053f0 <create+0x80>
801053d5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801053da:	75 14                	jne    801053f0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053df:	89 f0                	mov    %esi,%eax
801053e1:	5b                   	pop    %ebx
801053e2:	5e                   	pop    %esi
801053e3:	5f                   	pop    %edi
801053e4:	5d                   	pop    %ebp
801053e5:	c3                   	ret    
801053e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	56                   	push   %esi
    return 0;
801053f4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801053f6:	e8 c5 ce ff ff       	call   801022c0 <iunlockput>
    return 0;
801053fb:	83 c4 10             	add    $0x10,%esp
}
801053fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105401:	89 f0                	mov    %esi,%eax
80105403:	5b                   	pop    %ebx
80105404:	5e                   	pop    %esi
80105405:	5f                   	pop    %edi
80105406:	5d                   	pop    %ebp
80105407:	c3                   	ret    
80105408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105410:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105414:	83 ec 08             	sub    $0x8,%esp
80105417:	50                   	push   %eax
80105418:	ff 33                	pushl  (%ebx)
8010541a:	e8 81 ca ff ff       	call   80101ea0 <ialloc>
8010541f:	83 c4 10             	add    $0x10,%esp
80105422:	89 c6                	mov    %eax,%esi
80105424:	85 c0                	test   %eax,%eax
80105426:	0f 84 cd 00 00 00    	je     801054f9 <create+0x189>
  ilock(ip);
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	50                   	push   %eax
80105430:	e8 eb cb ff ff       	call   80102020 <ilock>
  ip->major = major;
80105435:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105439:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010543d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105441:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105445:	b8 01 00 00 00       	mov    $0x1,%eax
8010544a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010544e:	89 34 24             	mov    %esi,(%esp)
80105451:	e8 0a cb ff ff       	call   80101f60 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010545e:	74 30                	je     80105490 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105460:	83 ec 04             	sub    $0x4,%esp
80105463:	ff 76 04             	pushl  0x4(%esi)
80105466:	57                   	push   %edi
80105467:	53                   	push   %ebx
80105468:	e8 c3 d3 ff ff       	call   80102830 <dirlink>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	78 78                	js     801054ec <create+0x17c>
  iunlockput(dp);
80105474:	83 ec 0c             	sub    $0xc,%esp
80105477:	53                   	push   %ebx
80105478:	e8 43 ce ff ff       	call   801022c0 <iunlockput>
  return ip;
8010547d:	83 c4 10             	add    $0x10,%esp
}
80105480:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105483:	89 f0                	mov    %esi,%eax
80105485:	5b                   	pop    %ebx
80105486:	5e                   	pop    %esi
80105487:	5f                   	pop    %edi
80105488:	5d                   	pop    %ebp
80105489:	c3                   	ret    
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105490:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105493:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105498:	53                   	push   %ebx
80105499:	e8 c2 ca ff ff       	call   80101f60 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010549e:	83 c4 0c             	add    $0xc,%esp
801054a1:	ff 76 04             	pushl  0x4(%esi)
801054a4:	68 54 81 10 80       	push   $0x80108154
801054a9:	56                   	push   %esi
801054aa:	e8 81 d3 ff ff       	call   80102830 <dirlink>
801054af:	83 c4 10             	add    $0x10,%esp
801054b2:	85 c0                	test   %eax,%eax
801054b4:	78 18                	js     801054ce <create+0x15e>
801054b6:	83 ec 04             	sub    $0x4,%esp
801054b9:	ff 73 04             	pushl  0x4(%ebx)
801054bc:	68 53 81 10 80       	push   $0x80108153
801054c1:	56                   	push   %esi
801054c2:	e8 69 d3 ff ff       	call   80102830 <dirlink>
801054c7:	83 c4 10             	add    $0x10,%esp
801054ca:	85 c0                	test   %eax,%eax
801054cc:	79 92                	jns    80105460 <create+0xf0>
      panic("create dots");
801054ce:	83 ec 0c             	sub    $0xc,%esp
801054d1:	68 47 81 10 80       	push   $0x80108147
801054d6:	e8 b5 ae ff ff       	call   80100390 <panic>
801054db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop
}
801054e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801054e3:	31 f6                	xor    %esi,%esi
}
801054e5:	5b                   	pop    %ebx
801054e6:	89 f0                	mov    %esi,%eax
801054e8:	5e                   	pop    %esi
801054e9:	5f                   	pop    %edi
801054ea:	5d                   	pop    %ebp
801054eb:	c3                   	ret    
    panic("create: dirlink");
801054ec:	83 ec 0c             	sub    $0xc,%esp
801054ef:	68 56 81 10 80       	push   $0x80108156
801054f4:	e8 97 ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801054f9:	83 ec 0c             	sub    $0xc,%esp
801054fc:	68 38 81 10 80       	push   $0x80108138
80105501:	e8 8a ae ff ff       	call   80100390 <panic>
80105506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550d:	8d 76 00             	lea    0x0(%esi),%esi

80105510 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	56                   	push   %esi
80105514:	89 d6                	mov    %edx,%esi
80105516:	53                   	push   %ebx
80105517:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105519:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010551c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010551f:	50                   	push   %eax
80105520:	6a 00                	push   $0x0
80105522:	e8 e9 fc ff ff       	call   80105210 <argint>
80105527:	83 c4 10             	add    $0x10,%esp
8010552a:	85 c0                	test   %eax,%eax
8010552c:	78 2a                	js     80105558 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010552e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105532:	77 24                	ja     80105558 <argfd.constprop.0+0x48>
80105534:	e8 e7 ec ff ff       	call   80104220 <myproc>
80105539:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010553c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105540:	85 c0                	test   %eax,%eax
80105542:	74 14                	je     80105558 <argfd.constprop.0+0x48>
  if(pfd)
80105544:	85 db                	test   %ebx,%ebx
80105546:	74 02                	je     8010554a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105548:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010554a:	89 06                	mov    %eax,(%esi)
  return 0;
8010554c:	31 c0                	xor    %eax,%eax
}
8010554e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105551:	5b                   	pop    %ebx
80105552:	5e                   	pop    %esi
80105553:	5d                   	pop    %ebp
80105554:	c3                   	ret    
80105555:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555d:	eb ef                	jmp    8010554e <argfd.constprop.0+0x3e>
8010555f:	90                   	nop

80105560 <sys_dup>:
{
80105560:	f3 0f 1e fb          	endbr32 
80105564:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105565:	31 c0                	xor    %eax,%eax
{
80105567:	89 e5                	mov    %esp,%ebp
80105569:	56                   	push   %esi
8010556a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010556b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010556e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105571:	e8 9a ff ff ff       	call   80105510 <argfd.constprop.0>
80105576:	85 c0                	test   %eax,%eax
80105578:	78 1e                	js     80105598 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010557a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010557d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010557f:	e8 9c ec ff ff       	call   80104220 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105588:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010558c:	85 d2                	test   %edx,%edx
8010558e:	74 20                	je     801055b0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105590:	83 c3 01             	add    $0x1,%ebx
80105593:	83 fb 10             	cmp    $0x10,%ebx
80105596:	75 f0                	jne    80105588 <sys_dup+0x28>
}
80105598:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010559b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801055a0:	89 d8                	mov    %ebx,%eax
801055a2:	5b                   	pop    %ebx
801055a3:	5e                   	pop    %esi
801055a4:	5d                   	pop    %ebp
801055a5:	c3                   	ret    
801055a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ad:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801055b0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801055b4:	83 ec 0c             	sub    $0xc,%esp
801055b7:	ff 75 f4             	pushl  -0xc(%ebp)
801055ba:	e8 71 c1 ff ff       	call   80101730 <filedup>
  return fd;
801055bf:	83 c4 10             	add    $0x10,%esp
}
801055c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055c5:	89 d8                	mov    %ebx,%eax
801055c7:	5b                   	pop    %ebx
801055c8:	5e                   	pop    %esi
801055c9:	5d                   	pop    %ebp
801055ca:	c3                   	ret    
801055cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055cf:	90                   	nop

801055d0 <sys_read>:
{
801055d0:	f3 0f 1e fb          	endbr32 
801055d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055d5:	31 c0                	xor    %eax,%eax
{
801055d7:	89 e5                	mov    %esp,%ebp
801055d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055dc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055df:	e8 2c ff ff ff       	call   80105510 <argfd.constprop.0>
801055e4:	85 c0                	test   %eax,%eax
801055e6:	78 48                	js     80105630 <sys_read+0x60>
801055e8:	83 ec 08             	sub    $0x8,%esp
801055eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055ee:	50                   	push   %eax
801055ef:	6a 02                	push   $0x2
801055f1:	e8 1a fc ff ff       	call   80105210 <argint>
801055f6:	83 c4 10             	add    $0x10,%esp
801055f9:	85 c0                	test   %eax,%eax
801055fb:	78 33                	js     80105630 <sys_read+0x60>
801055fd:	83 ec 04             	sub    $0x4,%esp
80105600:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105603:	ff 75 f0             	pushl  -0x10(%ebp)
80105606:	50                   	push   %eax
80105607:	6a 01                	push   $0x1
80105609:	e8 52 fc ff ff       	call   80105260 <argptr>
8010560e:	83 c4 10             	add    $0x10,%esp
80105611:	85 c0                	test   %eax,%eax
80105613:	78 1b                	js     80105630 <sys_read+0x60>
  return fileread(f, p, n);
80105615:	83 ec 04             	sub    $0x4,%esp
80105618:	ff 75 f0             	pushl  -0x10(%ebp)
8010561b:	ff 75 f4             	pushl  -0xc(%ebp)
8010561e:	ff 75 ec             	pushl  -0x14(%ebp)
80105621:	e8 8a c2 ff ff       	call   801018b0 <fileread>
80105626:	83 c4 10             	add    $0x10,%esp
}
80105629:	c9                   	leave  
8010562a:	c3                   	ret    
8010562b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010562f:	90                   	nop
80105630:	c9                   	leave  
    return -1;
80105631:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105636:	c3                   	ret    
80105637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563e:	66 90                	xchg   %ax,%ax

80105640 <sys_write>:
{
80105640:	f3 0f 1e fb          	endbr32 
80105644:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105645:	31 c0                	xor    %eax,%eax
{
80105647:	89 e5                	mov    %esp,%ebp
80105649:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010564c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010564f:	e8 bc fe ff ff       	call   80105510 <argfd.constprop.0>
80105654:	85 c0                	test   %eax,%eax
80105656:	78 48                	js     801056a0 <sys_write+0x60>
80105658:	83 ec 08             	sub    $0x8,%esp
8010565b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010565e:	50                   	push   %eax
8010565f:	6a 02                	push   $0x2
80105661:	e8 aa fb ff ff       	call   80105210 <argint>
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	85 c0                	test   %eax,%eax
8010566b:	78 33                	js     801056a0 <sys_write+0x60>
8010566d:	83 ec 04             	sub    $0x4,%esp
80105670:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105673:	ff 75 f0             	pushl  -0x10(%ebp)
80105676:	50                   	push   %eax
80105677:	6a 01                	push   $0x1
80105679:	e8 e2 fb ff ff       	call   80105260 <argptr>
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	85 c0                	test   %eax,%eax
80105683:	78 1b                	js     801056a0 <sys_write+0x60>
  return filewrite(f, p, n);
80105685:	83 ec 04             	sub    $0x4,%esp
80105688:	ff 75 f0             	pushl  -0x10(%ebp)
8010568b:	ff 75 f4             	pushl  -0xc(%ebp)
8010568e:	ff 75 ec             	pushl  -0x14(%ebp)
80105691:	e8 ba c2 ff ff       	call   80101950 <filewrite>
80105696:	83 c4 10             	add    $0x10,%esp
}
80105699:	c9                   	leave  
8010569a:	c3                   	ret    
8010569b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop
801056a0:	c9                   	leave  
    return -1;
801056a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056a6:	c3                   	ret    
801056a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <sys_close>:
{
801056b0:	f3 0f 1e fb          	endbr32 
801056b4:	55                   	push   %ebp
801056b5:	89 e5                	mov    %esp,%ebp
801056b7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801056ba:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056c0:	e8 4b fe ff ff       	call   80105510 <argfd.constprop.0>
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 27                	js     801056f0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801056c9:	e8 52 eb ff ff       	call   80104220 <myproc>
801056ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801056d1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801056d4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801056db:	00 
  fileclose(f);
801056dc:	ff 75 f4             	pushl  -0xc(%ebp)
801056df:	e8 9c c0 ff ff       	call   80101780 <fileclose>
  return 0;
801056e4:	83 c4 10             	add    $0x10,%esp
801056e7:	31 c0                	xor    %eax,%eax
}
801056e9:	c9                   	leave  
801056ea:	c3                   	ret    
801056eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop
801056f0:	c9                   	leave  
    return -1;
801056f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f6:	c3                   	ret    
801056f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fe:	66 90                	xchg   %ax,%ax

80105700 <sys_fstat>:
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105705:	31 c0                	xor    %eax,%eax
{
80105707:	89 e5                	mov    %esp,%ebp
80105709:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010570c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010570f:	e8 fc fd ff ff       	call   80105510 <argfd.constprop.0>
80105714:	85 c0                	test   %eax,%eax
80105716:	78 30                	js     80105748 <sys_fstat+0x48>
80105718:	83 ec 04             	sub    $0x4,%esp
8010571b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010571e:	6a 14                	push   $0x14
80105720:	50                   	push   %eax
80105721:	6a 01                	push   $0x1
80105723:	e8 38 fb ff ff       	call   80105260 <argptr>
80105728:	83 c4 10             	add    $0x10,%esp
8010572b:	85 c0                	test   %eax,%eax
8010572d:	78 19                	js     80105748 <sys_fstat+0x48>
  return filestat(f, st);
8010572f:	83 ec 08             	sub    $0x8,%esp
80105732:	ff 75 f4             	pushl  -0xc(%ebp)
80105735:	ff 75 f0             	pushl  -0x10(%ebp)
80105738:	e8 23 c1 ff ff       	call   80101860 <filestat>
8010573d:	83 c4 10             	add    $0x10,%esp
}
80105740:	c9                   	leave  
80105741:	c3                   	ret    
80105742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105748:	c9                   	leave  
    return -1;
80105749:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010574e:	c3                   	ret    
8010574f:	90                   	nop

80105750 <sys_link>:
{
80105750:	f3 0f 1e fb          	endbr32 
80105754:	55                   	push   %ebp
80105755:	89 e5                	mov    %esp,%ebp
80105757:	57                   	push   %edi
80105758:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105759:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010575c:	53                   	push   %ebx
8010575d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105760:	50                   	push   %eax
80105761:	6a 00                	push   $0x0
80105763:	e8 58 fb ff ff       	call   801052c0 <argstr>
80105768:	83 c4 10             	add    $0x10,%esp
8010576b:	85 c0                	test   %eax,%eax
8010576d:	0f 88 ff 00 00 00    	js     80105872 <sys_link+0x122>
80105773:	83 ec 08             	sub    $0x8,%esp
80105776:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105779:	50                   	push   %eax
8010577a:	6a 01                	push   $0x1
8010577c:	e8 3f fb ff ff       	call   801052c0 <argstr>
80105781:	83 c4 10             	add    $0x10,%esp
80105784:	85 c0                	test   %eax,%eax
80105786:	0f 88 e6 00 00 00    	js     80105872 <sys_link+0x122>
  begin_op();
8010578c:	e8 5f de ff ff       	call   801035f0 <begin_op>
  if((ip = namei(old)) == 0){
80105791:	83 ec 0c             	sub    $0xc,%esp
80105794:	ff 75 d4             	pushl  -0x2c(%ebp)
80105797:	e8 54 d1 ff ff       	call   801028f0 <namei>
8010579c:	83 c4 10             	add    $0x10,%esp
8010579f:	89 c3                	mov    %eax,%ebx
801057a1:	85 c0                	test   %eax,%eax
801057a3:	0f 84 e8 00 00 00    	je     80105891 <sys_link+0x141>
  ilock(ip);
801057a9:	83 ec 0c             	sub    $0xc,%esp
801057ac:	50                   	push   %eax
801057ad:	e8 6e c8 ff ff       	call   80102020 <ilock>
  if(ip->type == T_DIR){
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057ba:	0f 84 b9 00 00 00    	je     80105879 <sys_link+0x129>
  iupdate(ip);
801057c0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801057c3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801057c8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801057cb:	53                   	push   %ebx
801057cc:	e8 8f c7 ff ff       	call   80101f60 <iupdate>
  iunlock(ip);
801057d1:	89 1c 24             	mov    %ebx,(%esp)
801057d4:	e8 27 c9 ff ff       	call   80102100 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801057d9:	58                   	pop    %eax
801057da:	5a                   	pop    %edx
801057db:	57                   	push   %edi
801057dc:	ff 75 d0             	pushl  -0x30(%ebp)
801057df:	e8 2c d1 ff ff       	call   80102910 <nameiparent>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	89 c6                	mov    %eax,%esi
801057e9:	85 c0                	test   %eax,%eax
801057eb:	74 5f                	je     8010584c <sys_link+0xfc>
  ilock(dp);
801057ed:	83 ec 0c             	sub    $0xc,%esp
801057f0:	50                   	push   %eax
801057f1:	e8 2a c8 ff ff       	call   80102020 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057f6:	8b 03                	mov    (%ebx),%eax
801057f8:	83 c4 10             	add    $0x10,%esp
801057fb:	39 06                	cmp    %eax,(%esi)
801057fd:	75 41                	jne    80105840 <sys_link+0xf0>
801057ff:	83 ec 04             	sub    $0x4,%esp
80105802:	ff 73 04             	pushl  0x4(%ebx)
80105805:	57                   	push   %edi
80105806:	56                   	push   %esi
80105807:	e8 24 d0 ff ff       	call   80102830 <dirlink>
8010580c:	83 c4 10             	add    $0x10,%esp
8010580f:	85 c0                	test   %eax,%eax
80105811:	78 2d                	js     80105840 <sys_link+0xf0>
  iunlockput(dp);
80105813:	83 ec 0c             	sub    $0xc,%esp
80105816:	56                   	push   %esi
80105817:	e8 a4 ca ff ff       	call   801022c0 <iunlockput>
  iput(ip);
8010581c:	89 1c 24             	mov    %ebx,(%esp)
8010581f:	e8 2c c9 ff ff       	call   80102150 <iput>
  end_op();
80105824:	e8 37 de ff ff       	call   80103660 <end_op>
  return 0;
80105829:	83 c4 10             	add    $0x10,%esp
8010582c:	31 c0                	xor    %eax,%eax
}
8010582e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105831:	5b                   	pop    %ebx
80105832:	5e                   	pop    %esi
80105833:	5f                   	pop    %edi
80105834:	5d                   	pop    %ebp
80105835:	c3                   	ret    
80105836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	56                   	push   %esi
80105844:	e8 77 ca ff ff       	call   801022c0 <iunlockput>
    goto bad;
80105849:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010584c:	83 ec 0c             	sub    $0xc,%esp
8010584f:	53                   	push   %ebx
80105850:	e8 cb c7 ff ff       	call   80102020 <ilock>
  ip->nlink--;
80105855:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010585a:	89 1c 24             	mov    %ebx,(%esp)
8010585d:	e8 fe c6 ff ff       	call   80101f60 <iupdate>
  iunlockput(ip);
80105862:	89 1c 24             	mov    %ebx,(%esp)
80105865:	e8 56 ca ff ff       	call   801022c0 <iunlockput>
  end_op();
8010586a:	e8 f1 dd ff ff       	call   80103660 <end_op>
  return -1;
8010586f:	83 c4 10             	add    $0x10,%esp
80105872:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105877:	eb b5                	jmp    8010582e <sys_link+0xde>
    iunlockput(ip);
80105879:	83 ec 0c             	sub    $0xc,%esp
8010587c:	53                   	push   %ebx
8010587d:	e8 3e ca ff ff       	call   801022c0 <iunlockput>
    end_op();
80105882:	e8 d9 dd ff ff       	call   80103660 <end_op>
    return -1;
80105887:	83 c4 10             	add    $0x10,%esp
8010588a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588f:	eb 9d                	jmp    8010582e <sys_link+0xde>
    end_op();
80105891:	e8 ca dd ff ff       	call   80103660 <end_op>
    return -1;
80105896:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589b:	eb 91                	jmp    8010582e <sys_link+0xde>
8010589d:	8d 76 00             	lea    0x0(%esi),%esi

801058a0 <sys_unlink>:
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	57                   	push   %edi
801058a8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801058a9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801058ac:	53                   	push   %ebx
801058ad:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801058b0:	50                   	push   %eax
801058b1:	6a 00                	push   $0x0
801058b3:	e8 08 fa ff ff       	call   801052c0 <argstr>
801058b8:	83 c4 10             	add    $0x10,%esp
801058bb:	85 c0                	test   %eax,%eax
801058bd:	0f 88 7d 01 00 00    	js     80105a40 <sys_unlink+0x1a0>
  begin_op();
801058c3:	e8 28 dd ff ff       	call   801035f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058c8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801058cb:	83 ec 08             	sub    $0x8,%esp
801058ce:	53                   	push   %ebx
801058cf:	ff 75 c0             	pushl  -0x40(%ebp)
801058d2:	e8 39 d0 ff ff       	call   80102910 <nameiparent>
801058d7:	83 c4 10             	add    $0x10,%esp
801058da:	89 c6                	mov    %eax,%esi
801058dc:	85 c0                	test   %eax,%eax
801058de:	0f 84 66 01 00 00    	je     80105a4a <sys_unlink+0x1aa>
  ilock(dp);
801058e4:	83 ec 0c             	sub    $0xc,%esp
801058e7:	50                   	push   %eax
801058e8:	e8 33 c7 ff ff       	call   80102020 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058ed:	58                   	pop    %eax
801058ee:	5a                   	pop    %edx
801058ef:	68 54 81 10 80       	push   $0x80108154
801058f4:	53                   	push   %ebx
801058f5:	e8 56 cc ff ff       	call   80102550 <namecmp>
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	85 c0                	test   %eax,%eax
801058ff:	0f 84 03 01 00 00    	je     80105a08 <sys_unlink+0x168>
80105905:	83 ec 08             	sub    $0x8,%esp
80105908:	68 53 81 10 80       	push   $0x80108153
8010590d:	53                   	push   %ebx
8010590e:	e8 3d cc ff ff       	call   80102550 <namecmp>
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	85 c0                	test   %eax,%eax
80105918:	0f 84 ea 00 00 00    	je     80105a08 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010591e:	83 ec 04             	sub    $0x4,%esp
80105921:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105924:	50                   	push   %eax
80105925:	53                   	push   %ebx
80105926:	56                   	push   %esi
80105927:	e8 44 cc ff ff       	call   80102570 <dirlookup>
8010592c:	83 c4 10             	add    $0x10,%esp
8010592f:	89 c3                	mov    %eax,%ebx
80105931:	85 c0                	test   %eax,%eax
80105933:	0f 84 cf 00 00 00    	je     80105a08 <sys_unlink+0x168>
  ilock(ip);
80105939:	83 ec 0c             	sub    $0xc,%esp
8010593c:	50                   	push   %eax
8010593d:	e8 de c6 ff ff       	call   80102020 <ilock>
  if(ip->nlink < 1)
80105942:	83 c4 10             	add    $0x10,%esp
80105945:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010594a:	0f 8e 23 01 00 00    	jle    80105a73 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105950:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105955:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105958:	74 66                	je     801059c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010595a:	83 ec 04             	sub    $0x4,%esp
8010595d:	6a 10                	push   $0x10
8010595f:	6a 00                	push   $0x0
80105961:	57                   	push   %edi
80105962:	e8 c9 f5 ff ff       	call   80104f30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105967:	6a 10                	push   $0x10
80105969:	ff 75 c4             	pushl  -0x3c(%ebp)
8010596c:	57                   	push   %edi
8010596d:	56                   	push   %esi
8010596e:	e8 ad ca ff ff       	call   80102420 <writei>
80105973:	83 c4 20             	add    $0x20,%esp
80105976:	83 f8 10             	cmp    $0x10,%eax
80105979:	0f 85 e7 00 00 00    	jne    80105a66 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010597f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105984:	0f 84 96 00 00 00    	je     80105a20 <sys_unlink+0x180>
  iunlockput(dp);
8010598a:	83 ec 0c             	sub    $0xc,%esp
8010598d:	56                   	push   %esi
8010598e:	e8 2d c9 ff ff       	call   801022c0 <iunlockput>
  ip->nlink--;
80105993:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105998:	89 1c 24             	mov    %ebx,(%esp)
8010599b:	e8 c0 c5 ff ff       	call   80101f60 <iupdate>
  iunlockput(ip);
801059a0:	89 1c 24             	mov    %ebx,(%esp)
801059a3:	e8 18 c9 ff ff       	call   801022c0 <iunlockput>
  end_op();
801059a8:	e8 b3 dc ff ff       	call   80103660 <end_op>
  return 0;
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	31 c0                	xor    %eax,%eax
}
801059b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b5:	5b                   	pop    %ebx
801059b6:	5e                   	pop    %esi
801059b7:	5f                   	pop    %edi
801059b8:	5d                   	pop    %ebp
801059b9:	c3                   	ret    
801059ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801059c4:	76 94                	jbe    8010595a <sys_unlink+0xba>
801059c6:	ba 20 00 00 00       	mov    $0x20,%edx
801059cb:	eb 0b                	jmp    801059d8 <sys_unlink+0x138>
801059cd:	8d 76 00             	lea    0x0(%esi),%esi
801059d0:	83 c2 10             	add    $0x10,%edx
801059d3:	39 53 58             	cmp    %edx,0x58(%ebx)
801059d6:	76 82                	jbe    8010595a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059d8:	6a 10                	push   $0x10
801059da:	52                   	push   %edx
801059db:	57                   	push   %edi
801059dc:	53                   	push   %ebx
801059dd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801059e0:	e8 3b c9 ff ff       	call   80102320 <readi>
801059e5:	83 c4 10             	add    $0x10,%esp
801059e8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801059eb:	83 f8 10             	cmp    $0x10,%eax
801059ee:	75 69                	jne    80105a59 <sys_unlink+0x1b9>
    if(de.inum != 0)
801059f0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801059f5:	74 d9                	je     801059d0 <sys_unlink+0x130>
    iunlockput(ip);
801059f7:	83 ec 0c             	sub    $0xc,%esp
801059fa:	53                   	push   %ebx
801059fb:	e8 c0 c8 ff ff       	call   801022c0 <iunlockput>
    goto bad;
80105a00:	83 c4 10             	add    $0x10,%esp
80105a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a07:	90                   	nop
  iunlockput(dp);
80105a08:	83 ec 0c             	sub    $0xc,%esp
80105a0b:	56                   	push   %esi
80105a0c:	e8 af c8 ff ff       	call   801022c0 <iunlockput>
  end_op();
80105a11:	e8 4a dc ff ff       	call   80103660 <end_op>
  return -1;
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1e:	eb 92                	jmp    801059b2 <sys_unlink+0x112>
    iupdate(dp);
80105a20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105a23:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105a28:	56                   	push   %esi
80105a29:	e8 32 c5 ff ff       	call   80101f60 <iupdate>
80105a2e:	83 c4 10             	add    $0x10,%esp
80105a31:	e9 54 ff ff ff       	jmp    8010598a <sys_unlink+0xea>
80105a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a45:	e9 68 ff ff ff       	jmp    801059b2 <sys_unlink+0x112>
    end_op();
80105a4a:	e8 11 dc ff ff       	call   80103660 <end_op>
    return -1;
80105a4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a54:	e9 59 ff ff ff       	jmp    801059b2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105a59:	83 ec 0c             	sub    $0xc,%esp
80105a5c:	68 78 81 10 80       	push   $0x80108178
80105a61:	e8 2a a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a66:	83 ec 0c             	sub    $0xc,%esp
80105a69:	68 8a 81 10 80       	push   $0x8010818a
80105a6e:	e8 1d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a73:	83 ec 0c             	sub    $0xc,%esp
80105a76:	68 66 81 10 80       	push   $0x80108166
80105a7b:	e8 10 a9 ff ff       	call   80100390 <panic>

80105a80 <sys_open>:

int
sys_open(void)
{
80105a80:	f3 0f 1e fb          	endbr32 
80105a84:	55                   	push   %ebp
80105a85:	89 e5                	mov    %esp,%ebp
80105a87:	57                   	push   %edi
80105a88:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a89:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a8c:	53                   	push   %ebx
80105a8d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a90:	50                   	push   %eax
80105a91:	6a 00                	push   $0x0
80105a93:	e8 28 f8 ff ff       	call   801052c0 <argstr>
80105a98:	83 c4 10             	add    $0x10,%esp
80105a9b:	85 c0                	test   %eax,%eax
80105a9d:	0f 88 8a 00 00 00    	js     80105b2d <sys_open+0xad>
80105aa3:	83 ec 08             	sub    $0x8,%esp
80105aa6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105aa9:	50                   	push   %eax
80105aaa:	6a 01                	push   $0x1
80105aac:	e8 5f f7 ff ff       	call   80105210 <argint>
80105ab1:	83 c4 10             	add    $0x10,%esp
80105ab4:	85 c0                	test   %eax,%eax
80105ab6:	78 75                	js     80105b2d <sys_open+0xad>
    return -1;

  begin_op();
80105ab8:	e8 33 db ff ff       	call   801035f0 <begin_op>

  if(omode & O_CREATE){
80105abd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ac1:	75 75                	jne    80105b38 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ac3:	83 ec 0c             	sub    $0xc,%esp
80105ac6:	ff 75 e0             	pushl  -0x20(%ebp)
80105ac9:	e8 22 ce ff ff       	call   801028f0 <namei>
80105ace:	83 c4 10             	add    $0x10,%esp
80105ad1:	89 c6                	mov    %eax,%esi
80105ad3:	85 c0                	test   %eax,%eax
80105ad5:	74 7e                	je     80105b55 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105ad7:	83 ec 0c             	sub    $0xc,%esp
80105ada:	50                   	push   %eax
80105adb:	e8 40 c5 ff ff       	call   80102020 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ae0:	83 c4 10             	add    $0x10,%esp
80105ae3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ae8:	0f 84 c2 00 00 00    	je     80105bb0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105aee:	e8 cd bb ff ff       	call   801016c0 <filealloc>
80105af3:	89 c7                	mov    %eax,%edi
80105af5:	85 c0                	test   %eax,%eax
80105af7:	74 23                	je     80105b1c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105af9:	e8 22 e7 ff ff       	call   80104220 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105afe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105b00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b04:	85 d2                	test   %edx,%edx
80105b06:	74 60                	je     80105b68 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105b08:	83 c3 01             	add    $0x1,%ebx
80105b0b:	83 fb 10             	cmp    $0x10,%ebx
80105b0e:	75 f0                	jne    80105b00 <sys_open+0x80>
    if(f)
      fileclose(f);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	57                   	push   %edi
80105b14:	e8 67 bc ff ff       	call   80101780 <fileclose>
80105b19:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b1c:	83 ec 0c             	sub    $0xc,%esp
80105b1f:	56                   	push   %esi
80105b20:	e8 9b c7 ff ff       	call   801022c0 <iunlockput>
    end_op();
80105b25:	e8 36 db ff ff       	call   80103660 <end_op>
    return -1;
80105b2a:	83 c4 10             	add    $0x10,%esp
80105b2d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b32:	eb 6d                	jmp    80105ba1 <sys_open+0x121>
80105b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b38:	83 ec 0c             	sub    $0xc,%esp
80105b3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b3e:	31 c9                	xor    %ecx,%ecx
80105b40:	ba 02 00 00 00       	mov    $0x2,%edx
80105b45:	6a 00                	push   $0x0
80105b47:	e8 24 f8 ff ff       	call   80105370 <create>
    if(ip == 0){
80105b4c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b4f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b51:	85 c0                	test   %eax,%eax
80105b53:	75 99                	jne    80105aee <sys_open+0x6e>
      end_op();
80105b55:	e8 06 db ff ff       	call   80103660 <end_op>
      return -1;
80105b5a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b5f:	eb 40                	jmp    80105ba1 <sys_open+0x121>
80105b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b68:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b6b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b6f:	56                   	push   %esi
80105b70:	e8 8b c5 ff ff       	call   80102100 <iunlock>
  end_op();
80105b75:	e8 e6 da ff ff       	call   80103660 <end_op>

  f->type = FD_INODE;
80105b7a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b83:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b86:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b89:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b8b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b92:	f7 d0                	not    %eax
80105b94:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b97:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b9a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b9d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba4:	89 d8                	mov    %ebx,%eax
80105ba6:	5b                   	pop    %ebx
80105ba7:	5e                   	pop    %esi
80105ba8:	5f                   	pop    %edi
80105ba9:	5d                   	pop    %ebp
80105baa:	c3                   	ret    
80105bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105baf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bb0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105bb3:	85 c9                	test   %ecx,%ecx
80105bb5:	0f 84 33 ff ff ff    	je     80105aee <sys_open+0x6e>
80105bbb:	e9 5c ff ff ff       	jmp    80105b1c <sys_open+0x9c>

80105bc0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105bc0:	f3 0f 1e fb          	endbr32 
80105bc4:	55                   	push   %ebp
80105bc5:	89 e5                	mov    %esp,%ebp
80105bc7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105bca:	e8 21 da ff ff       	call   801035f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bcf:	83 ec 08             	sub    $0x8,%esp
80105bd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bd5:	50                   	push   %eax
80105bd6:	6a 00                	push   $0x0
80105bd8:	e8 e3 f6 ff ff       	call   801052c0 <argstr>
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	85 c0                	test   %eax,%eax
80105be2:	78 34                	js     80105c18 <sys_mkdir+0x58>
80105be4:	83 ec 0c             	sub    $0xc,%esp
80105be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bea:	31 c9                	xor    %ecx,%ecx
80105bec:	ba 01 00 00 00       	mov    $0x1,%edx
80105bf1:	6a 00                	push   $0x0
80105bf3:	e8 78 f7 ff ff       	call   80105370 <create>
80105bf8:	83 c4 10             	add    $0x10,%esp
80105bfb:	85 c0                	test   %eax,%eax
80105bfd:	74 19                	je     80105c18 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bff:	83 ec 0c             	sub    $0xc,%esp
80105c02:	50                   	push   %eax
80105c03:	e8 b8 c6 ff ff       	call   801022c0 <iunlockput>
  end_op();
80105c08:	e8 53 da ff ff       	call   80103660 <end_op>
  return 0;
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	31 c0                	xor    %eax,%eax
}
80105c12:	c9                   	leave  
80105c13:	c3                   	ret    
80105c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105c18:	e8 43 da ff ff       	call   80103660 <end_op>
    return -1;
80105c1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c22:	c9                   	leave  
80105c23:	c3                   	ret    
80105c24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop

80105c30 <sys_mknod>:

int
sys_mknod(void)
{
80105c30:	f3 0f 1e fb          	endbr32 
80105c34:	55                   	push   %ebp
80105c35:	89 e5                	mov    %esp,%ebp
80105c37:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c3a:	e8 b1 d9 ff ff       	call   801035f0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c3f:	83 ec 08             	sub    $0x8,%esp
80105c42:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c45:	50                   	push   %eax
80105c46:	6a 00                	push   $0x0
80105c48:	e8 73 f6 ff ff       	call   801052c0 <argstr>
80105c4d:	83 c4 10             	add    $0x10,%esp
80105c50:	85 c0                	test   %eax,%eax
80105c52:	78 64                	js     80105cb8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105c54:	83 ec 08             	sub    $0x8,%esp
80105c57:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c5a:	50                   	push   %eax
80105c5b:	6a 01                	push   $0x1
80105c5d:	e8 ae f5 ff ff       	call   80105210 <argint>
  if((argstr(0, &path)) < 0 ||
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	85 c0                	test   %eax,%eax
80105c67:	78 4f                	js     80105cb8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105c69:	83 ec 08             	sub    $0x8,%esp
80105c6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c6f:	50                   	push   %eax
80105c70:	6a 02                	push   $0x2
80105c72:	e8 99 f5 ff ff       	call   80105210 <argint>
     argint(1, &major) < 0 ||
80105c77:	83 c4 10             	add    $0x10,%esp
80105c7a:	85 c0                	test   %eax,%eax
80105c7c:	78 3a                	js     80105cb8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c7e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c82:	83 ec 0c             	sub    $0xc,%esp
80105c85:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c89:	ba 03 00 00 00       	mov    $0x3,%edx
80105c8e:	50                   	push   %eax
80105c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c92:	e8 d9 f6 ff ff       	call   80105370 <create>
     argint(2, &minor) < 0 ||
80105c97:	83 c4 10             	add    $0x10,%esp
80105c9a:	85 c0                	test   %eax,%eax
80105c9c:	74 1a                	je     80105cb8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c9e:	83 ec 0c             	sub    $0xc,%esp
80105ca1:	50                   	push   %eax
80105ca2:	e8 19 c6 ff ff       	call   801022c0 <iunlockput>
  end_op();
80105ca7:	e8 b4 d9 ff ff       	call   80103660 <end_op>
  return 0;
80105cac:	83 c4 10             	add    $0x10,%esp
80105caf:	31 c0                	xor    %eax,%eax
}
80105cb1:	c9                   	leave  
80105cb2:	c3                   	ret    
80105cb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cb7:	90                   	nop
    end_op();
80105cb8:	e8 a3 d9 ff ff       	call   80103660 <end_op>
    return -1;
80105cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc2:	c9                   	leave  
80105cc3:	c3                   	ret    
80105cc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ccf:	90                   	nop

80105cd0 <sys_chdir>:

int
sys_chdir(void)
{
80105cd0:	f3 0f 1e fb          	endbr32 
80105cd4:	55                   	push   %ebp
80105cd5:	89 e5                	mov    %esp,%ebp
80105cd7:	56                   	push   %esi
80105cd8:	53                   	push   %ebx
80105cd9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105cdc:	e8 3f e5 ff ff       	call   80104220 <myproc>
80105ce1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105ce3:	e8 08 d9 ff ff       	call   801035f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ce8:	83 ec 08             	sub    $0x8,%esp
80105ceb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cee:	50                   	push   %eax
80105cef:	6a 00                	push   $0x0
80105cf1:	e8 ca f5 ff ff       	call   801052c0 <argstr>
80105cf6:	83 c4 10             	add    $0x10,%esp
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	78 73                	js     80105d70 <sys_chdir+0xa0>
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	ff 75 f4             	pushl  -0xc(%ebp)
80105d03:	e8 e8 cb ff ff       	call   801028f0 <namei>
80105d08:	83 c4 10             	add    $0x10,%esp
80105d0b:	89 c3                	mov    %eax,%ebx
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	74 5f                	je     80105d70 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d11:	83 ec 0c             	sub    $0xc,%esp
80105d14:	50                   	push   %eax
80105d15:	e8 06 c3 ff ff       	call   80102020 <ilock>
  if(ip->type != T_DIR){
80105d1a:	83 c4 10             	add    $0x10,%esp
80105d1d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d22:	75 2c                	jne    80105d50 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d24:	83 ec 0c             	sub    $0xc,%esp
80105d27:	53                   	push   %ebx
80105d28:	e8 d3 c3 ff ff       	call   80102100 <iunlock>
  iput(curproc->cwd);
80105d2d:	58                   	pop    %eax
80105d2e:	ff 76 68             	pushl  0x68(%esi)
80105d31:	e8 1a c4 ff ff       	call   80102150 <iput>
  end_op();
80105d36:	e8 25 d9 ff ff       	call   80103660 <end_op>
  curproc->cwd = ip;
80105d3b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d3e:	83 c4 10             	add    $0x10,%esp
80105d41:	31 c0                	xor    %eax,%eax
}
80105d43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d46:	5b                   	pop    %ebx
80105d47:	5e                   	pop    %esi
80105d48:	5d                   	pop    %ebp
80105d49:	c3                   	ret    
80105d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d50:	83 ec 0c             	sub    $0xc,%esp
80105d53:	53                   	push   %ebx
80105d54:	e8 67 c5 ff ff       	call   801022c0 <iunlockput>
    end_op();
80105d59:	e8 02 d9 ff ff       	call   80103660 <end_op>
    return -1;
80105d5e:	83 c4 10             	add    $0x10,%esp
80105d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d66:	eb db                	jmp    80105d43 <sys_chdir+0x73>
80105d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop
    end_op();
80105d70:	e8 eb d8 ff ff       	call   80103660 <end_op>
    return -1;
80105d75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7a:	eb c7                	jmp    80105d43 <sys_chdir+0x73>
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d80 <sys_exec>:

int
sys_exec(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
80105d84:	55                   	push   %ebp
80105d85:	89 e5                	mov    %esp,%ebp
80105d87:	57                   	push   %edi
80105d88:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d89:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d8f:	53                   	push   %ebx
80105d90:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d96:	50                   	push   %eax
80105d97:	6a 00                	push   $0x0
80105d99:	e8 22 f5 ff ff       	call   801052c0 <argstr>
80105d9e:	83 c4 10             	add    $0x10,%esp
80105da1:	85 c0                	test   %eax,%eax
80105da3:	0f 88 8b 00 00 00    	js     80105e34 <sys_exec+0xb4>
80105da9:	83 ec 08             	sub    $0x8,%esp
80105dac:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105db2:	50                   	push   %eax
80105db3:	6a 01                	push   $0x1
80105db5:	e8 56 f4 ff ff       	call   80105210 <argint>
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	85 c0                	test   %eax,%eax
80105dbf:	78 73                	js     80105e34 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105dc1:	83 ec 04             	sub    $0x4,%esp
80105dc4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105dca:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105dcc:	68 80 00 00 00       	push   $0x80
80105dd1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105dd7:	6a 00                	push   $0x0
80105dd9:	50                   	push   %eax
80105dda:	e8 51 f1 ff ff       	call   80104f30 <memset>
80105ddf:	83 c4 10             	add    $0x10,%esp
80105de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105de8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105dee:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105df5:	83 ec 08             	sub    $0x8,%esp
80105df8:	57                   	push   %edi
80105df9:	01 f0                	add    %esi,%eax
80105dfb:	50                   	push   %eax
80105dfc:	e8 6f f3 ff ff       	call   80105170 <fetchint>
80105e01:	83 c4 10             	add    $0x10,%esp
80105e04:	85 c0                	test   %eax,%eax
80105e06:	78 2c                	js     80105e34 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105e08:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e0e:	85 c0                	test   %eax,%eax
80105e10:	74 36                	je     80105e48 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e12:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e18:	83 ec 08             	sub    $0x8,%esp
80105e1b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e1e:	52                   	push   %edx
80105e1f:	50                   	push   %eax
80105e20:	e8 8b f3 ff ff       	call   801051b0 <fetchstr>
80105e25:	83 c4 10             	add    $0x10,%esp
80105e28:	85 c0                	test   %eax,%eax
80105e2a:	78 08                	js     80105e34 <sys_exec+0xb4>
  for(i=0;; i++){
80105e2c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e2f:	83 fb 20             	cmp    $0x20,%ebx
80105e32:	75 b4                	jne    80105de8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e3c:	5b                   	pop    %ebx
80105e3d:	5e                   	pop    %esi
80105e3e:	5f                   	pop    %edi
80105e3f:	5d                   	pop    %ebp
80105e40:	c3                   	ret    
80105e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e48:	83 ec 08             	sub    $0x8,%esp
80105e4b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105e51:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e58:	00 00 00 00 
  return exec(path, argv);
80105e5c:	50                   	push   %eax
80105e5d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e63:	e8 d8 b4 ff ff       	call   80101340 <exec>
80105e68:	83 c4 10             	add    $0x10,%esp
}
80105e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e6e:	5b                   	pop    %ebx
80105e6f:	5e                   	pop    %esi
80105e70:	5f                   	pop    %edi
80105e71:	5d                   	pop    %ebp
80105e72:	c3                   	ret    
80105e73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e80 <sys_pipe>:

int
sys_pipe(void)
{
80105e80:	f3 0f 1e fb          	endbr32 
80105e84:	55                   	push   %ebp
80105e85:	89 e5                	mov    %esp,%ebp
80105e87:	57                   	push   %edi
80105e88:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e89:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e8c:	53                   	push   %ebx
80105e8d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e90:	6a 08                	push   $0x8
80105e92:	50                   	push   %eax
80105e93:	6a 00                	push   $0x0
80105e95:	e8 c6 f3 ff ff       	call   80105260 <argptr>
80105e9a:	83 c4 10             	add    $0x10,%esp
80105e9d:	85 c0                	test   %eax,%eax
80105e9f:	78 4e                	js     80105eef <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ea1:	83 ec 08             	sub    $0x8,%esp
80105ea4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ea7:	50                   	push   %eax
80105ea8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105eab:	50                   	push   %eax
80105eac:	e8 ff dd ff ff       	call   80103cb0 <pipealloc>
80105eb1:	83 c4 10             	add    $0x10,%esp
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	78 37                	js     80105eef <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105eb8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105ebb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ebd:	e8 5e e3 ff ff       	call   80104220 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ec8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ecc:	85 f6                	test   %esi,%esi
80105ece:	74 30                	je     80105f00 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105ed0:	83 c3 01             	add    $0x1,%ebx
80105ed3:	83 fb 10             	cmp    $0x10,%ebx
80105ed6:	75 f0                	jne    80105ec8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105ed8:	83 ec 0c             	sub    $0xc,%esp
80105edb:	ff 75 e0             	pushl  -0x20(%ebp)
80105ede:	e8 9d b8 ff ff       	call   80101780 <fileclose>
    fileclose(wf);
80105ee3:	58                   	pop    %eax
80105ee4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ee7:	e8 94 b8 ff ff       	call   80101780 <fileclose>
    return -1;
80105eec:	83 c4 10             	add    $0x10,%esp
80105eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef4:	eb 5b                	jmp    80105f51 <sys_pipe+0xd1>
80105ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105f00:	8d 73 08             	lea    0x8(%ebx),%esi
80105f03:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f0a:	e8 11 e3 ff ff       	call   80104220 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f0f:	31 d2                	xor    %edx,%edx
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105f18:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f1c:	85 c9                	test   %ecx,%ecx
80105f1e:	74 20                	je     80105f40 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105f20:	83 c2 01             	add    $0x1,%edx
80105f23:	83 fa 10             	cmp    $0x10,%edx
80105f26:	75 f0                	jne    80105f18 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105f28:	e8 f3 e2 ff ff       	call   80104220 <myproc>
80105f2d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f34:	00 
80105f35:	eb a1                	jmp    80105ed8 <sys_pipe+0x58>
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f40:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f44:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f47:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f49:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f4c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f4f:	31 c0                	xor    %eax,%eax
}
80105f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f54:	5b                   	pop    %ebx
80105f55:	5e                   	pop    %esi
80105f56:	5f                   	pop    %edi
80105f57:	5d                   	pop    %ebp
80105f58:	c3                   	ret    
80105f59:	66 90                	xchg   %ax,%ax
80105f5b:	66 90                	xchg   %ax,%ax
80105f5d:	66 90                	xchg   %ax,%ax
80105f5f:	90                   	nop

80105f60 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
  return fork();
80105f64:	e9 67 e4 ff ff       	jmp    801043d0 <fork>
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f70 <sys_exit>:
}

int
sys_exit(void)
{
80105f70:	f3 0f 1e fb          	endbr32 
80105f74:	55                   	push   %ebp
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f7a:	e8 d1 e6 ff ff       	call   80104650 <exit>
  return 0;  // not reached
}
80105f7f:	31 c0                	xor    %eax,%eax
80105f81:	c9                   	leave  
80105f82:	c3                   	ret    
80105f83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f90 <sys_wait>:

int
sys_wait(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
  return wait();
80105f94:	e9 07 e9 ff ff       	jmp    801048a0 <wait>
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fa0 <sys_kill>:
}

int
sys_kill(void)
{
80105fa0:	f3 0f 1e fb          	endbr32 
80105fa4:	55                   	push   %ebp
80105fa5:	89 e5                	mov    %esp,%ebp
80105fa7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105faa:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fad:	50                   	push   %eax
80105fae:	6a 00                	push   $0x0
80105fb0:	e8 5b f2 ff ff       	call   80105210 <argint>
80105fb5:	83 c4 10             	add    $0x10,%esp
80105fb8:	85 c0                	test   %eax,%eax
80105fba:	78 14                	js     80105fd0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fbc:	83 ec 0c             	sub    $0xc,%esp
80105fbf:	ff 75 f4             	pushl  -0xc(%ebp)
80105fc2:	e8 39 ea ff ff       	call   80104a00 <kill>
80105fc7:	83 c4 10             	add    $0x10,%esp
}
80105fca:	c9                   	leave  
80105fcb:	c3                   	ret    
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fd0:	c9                   	leave  
    return -1;
80105fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd6:	c3                   	ret    
80105fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fde:	66 90                	xchg   %ax,%ax

80105fe0 <sys_getpid>:

int
sys_getpid(void)
{
80105fe0:	f3 0f 1e fb          	endbr32 
80105fe4:	55                   	push   %ebp
80105fe5:	89 e5                	mov    %esp,%ebp
80105fe7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fea:	e8 31 e2 ff ff       	call   80104220 <myproc>
80105fef:	8b 40 10             	mov    0x10(%eax),%eax
}
80105ff2:	c9                   	leave  
80105ff3:	c3                   	ret    
80105ff4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fff:	90                   	nop

80106000 <sys_sbrk>:

int
sys_sbrk(void)
{
80106000:	f3 0f 1e fb          	endbr32 
80106004:	55                   	push   %ebp
80106005:	89 e5                	mov    %esp,%ebp
80106007:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106008:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010600b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010600e:	50                   	push   %eax
8010600f:	6a 00                	push   $0x0
80106011:	e8 fa f1 ff ff       	call   80105210 <argint>
80106016:	83 c4 10             	add    $0x10,%esp
80106019:	85 c0                	test   %eax,%eax
8010601b:	78 23                	js     80106040 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010601d:	e8 fe e1 ff ff       	call   80104220 <myproc>
  if(growproc(n) < 0)
80106022:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106025:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106027:	ff 75 f4             	pushl  -0xc(%ebp)
8010602a:	e8 21 e3 ff ff       	call   80104350 <growproc>
8010602f:	83 c4 10             	add    $0x10,%esp
80106032:	85 c0                	test   %eax,%eax
80106034:	78 0a                	js     80106040 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106036:	89 d8                	mov    %ebx,%eax
80106038:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010603b:	c9                   	leave  
8010603c:	c3                   	ret    
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106040:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106045:	eb ef                	jmp    80106036 <sys_sbrk+0x36>
80106047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604e:	66 90                	xchg   %ax,%ax

80106050 <sys_sleep>:

int
sys_sleep(void)
{
80106050:	f3 0f 1e fb          	endbr32 
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106058:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010605b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010605e:	50                   	push   %eax
8010605f:	6a 00                	push   $0x0
80106061:	e8 aa f1 ff ff       	call   80105210 <argint>
80106066:	83 c4 10             	add    $0x10,%esp
80106069:	85 c0                	test   %eax,%eax
8010606b:	0f 88 86 00 00 00    	js     801060f7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106071:	83 ec 0c             	sub    $0xc,%esp
80106074:	68 20 62 11 80       	push   $0x80116220
80106079:	e8 a2 ed ff ff       	call   80104e20 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010607e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106081:	8b 1d 60 6a 11 80    	mov    0x80116a60,%ebx
  while(ticks - ticks0 < n){
80106087:	83 c4 10             	add    $0x10,%esp
8010608a:	85 d2                	test   %edx,%edx
8010608c:	75 23                	jne    801060b1 <sys_sleep+0x61>
8010608e:	eb 50                	jmp    801060e0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106090:	83 ec 08             	sub    $0x8,%esp
80106093:	68 20 62 11 80       	push   $0x80116220
80106098:	68 60 6a 11 80       	push   $0x80116a60
8010609d:	e8 3e e7 ff ff       	call   801047e0 <sleep>
  while(ticks - ticks0 < n){
801060a2:	a1 60 6a 11 80       	mov    0x80116a60,%eax
801060a7:	83 c4 10             	add    $0x10,%esp
801060aa:	29 d8                	sub    %ebx,%eax
801060ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801060af:	73 2f                	jae    801060e0 <sys_sleep+0x90>
    if(myproc()->killed){
801060b1:	e8 6a e1 ff ff       	call   80104220 <myproc>
801060b6:	8b 40 24             	mov    0x24(%eax),%eax
801060b9:	85 c0                	test   %eax,%eax
801060bb:	74 d3                	je     80106090 <sys_sleep+0x40>
      release(&tickslock);
801060bd:	83 ec 0c             	sub    $0xc,%esp
801060c0:	68 20 62 11 80       	push   $0x80116220
801060c5:	e8 16 ee ff ff       	call   80104ee0 <release>
  }
  release(&tickslock);
  return 0;
}
801060ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801060cd:	83 c4 10             	add    $0x10,%esp
801060d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060d5:	c9                   	leave  
801060d6:	c3                   	ret    
801060d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060de:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801060e0:	83 ec 0c             	sub    $0xc,%esp
801060e3:	68 20 62 11 80       	push   $0x80116220
801060e8:	e8 f3 ed ff ff       	call   80104ee0 <release>
  return 0;
801060ed:	83 c4 10             	add    $0x10,%esp
801060f0:	31 c0                	xor    %eax,%eax
}
801060f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060f5:	c9                   	leave  
801060f6:	c3                   	ret    
    return -1;
801060f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060fc:	eb f4                	jmp    801060f2 <sys_sleep+0xa2>
801060fe:	66 90                	xchg   %ax,%ax

80106100 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106100:	f3 0f 1e fb          	endbr32 
80106104:	55                   	push   %ebp
80106105:	89 e5                	mov    %esp,%ebp
80106107:	53                   	push   %ebx
80106108:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010610b:	68 20 62 11 80       	push   $0x80116220
80106110:	e8 0b ed ff ff       	call   80104e20 <acquire>
  xticks = ticks;
80106115:	8b 1d 60 6a 11 80    	mov    0x80116a60,%ebx
  release(&tickslock);
8010611b:	c7 04 24 20 62 11 80 	movl   $0x80116220,(%esp)
80106122:	e8 b9 ed ff ff       	call   80104ee0 <release>
  return xticks;
}
80106127:	89 d8                	mov    %ebx,%eax
80106129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010612c:	c9                   	leave  
8010612d:	c3                   	ret    

8010612e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010612e:	1e                   	push   %ds
  pushl %es
8010612f:	06                   	push   %es
  pushl %fs
80106130:	0f a0                	push   %fs
  pushl %gs
80106132:	0f a8                	push   %gs
  pushal
80106134:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106135:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106139:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010613b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010613d:	54                   	push   %esp
  call trap
8010613e:	e8 cd 00 00 00       	call   80106210 <trap>
  addl $4, %esp
80106143:	83 c4 04             	add    $0x4,%esp

80106146 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106146:	61                   	popa   
  popl %gs
80106147:	0f a9                	pop    %gs
  popl %fs
80106149:	0f a1                	pop    %fs
  popl %es
8010614b:	07                   	pop    %es
  popl %ds
8010614c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010614d:	83 c4 08             	add    $0x8,%esp
  iret
80106150:	cf                   	iret   
80106151:	66 90                	xchg   %ax,%ax
80106153:	66 90                	xchg   %ax,%ax
80106155:	66 90                	xchg   %ax,%ax
80106157:	66 90                	xchg   %ax,%ax
80106159:	66 90                	xchg   %ax,%ax
8010615b:	66 90                	xchg   %ax,%ax
8010615d:	66 90                	xchg   %ax,%ax
8010615f:	90                   	nop

80106160 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106160:	f3 0f 1e fb          	endbr32 
80106164:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106165:	31 c0                	xor    %eax,%eax
{
80106167:	89 e5                	mov    %esp,%ebp
80106169:	83 ec 08             	sub    $0x8,%esp
8010616c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106170:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106177:	c7 04 c5 62 62 11 80 	movl   $0x8e000008,-0x7fee9d9e(,%eax,8)
8010617e:	08 00 00 8e 
80106182:	66 89 14 c5 60 62 11 	mov    %dx,-0x7fee9da0(,%eax,8)
80106189:	80 
8010618a:	c1 ea 10             	shr    $0x10,%edx
8010618d:	66 89 14 c5 66 62 11 	mov    %dx,-0x7fee9d9a(,%eax,8)
80106194:	80 
  for(i = 0; i < 256; i++)
80106195:	83 c0 01             	add    $0x1,%eax
80106198:	3d 00 01 00 00       	cmp    $0x100,%eax
8010619d:	75 d1                	jne    80106170 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010619f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061a2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801061a7:	c7 05 62 64 11 80 08 	movl   $0xef000008,0x80116462
801061ae:	00 00 ef 
  initlock(&tickslock, "time");
801061b1:	68 99 81 10 80       	push   $0x80108199
801061b6:	68 20 62 11 80       	push   $0x80116220
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061bb:	66 a3 60 64 11 80    	mov    %ax,0x80116460
801061c1:	c1 e8 10             	shr    $0x10,%eax
801061c4:	66 a3 66 64 11 80    	mov    %ax,0x80116466
  initlock(&tickslock, "time");
801061ca:	e8 d1 ea ff ff       	call   80104ca0 <initlock>
}
801061cf:	83 c4 10             	add    $0x10,%esp
801061d2:	c9                   	leave  
801061d3:	c3                   	ret    
801061d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061df:	90                   	nop

801061e0 <idtinit>:

void
idtinit(void)
{
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
  pd[0] = size-1;
801061e5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061ea:	89 e5                	mov    %esp,%ebp
801061ec:	83 ec 10             	sub    $0x10,%esp
801061ef:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061f3:	b8 60 62 11 80       	mov    $0x80116260,%eax
801061f8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061fc:	c1 e8 10             	shr    $0x10,%eax
801061ff:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106203:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106206:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106209:	c9                   	leave  
8010620a:	c3                   	ret    
8010620b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop

80106210 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106210:	f3 0f 1e fb          	endbr32 
80106214:	55                   	push   %ebp
80106215:	89 e5                	mov    %esp,%ebp
80106217:	57                   	push   %edi
80106218:	56                   	push   %esi
80106219:	53                   	push   %ebx
8010621a:	83 ec 1c             	sub    $0x1c,%esp
8010621d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106220:	8b 43 30             	mov    0x30(%ebx),%eax
80106223:	83 f8 40             	cmp    $0x40,%eax
80106226:	0f 84 bc 01 00 00    	je     801063e8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010622c:	83 e8 20             	sub    $0x20,%eax
8010622f:	83 f8 1f             	cmp    $0x1f,%eax
80106232:	77 08                	ja     8010623c <trap+0x2c>
80106234:	3e ff 24 85 40 82 10 	notrack jmp *-0x7fef7dc0(,%eax,4)
8010623b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010623c:	e8 df df ff ff       	call   80104220 <myproc>
80106241:	8b 7b 38             	mov    0x38(%ebx),%edi
80106244:	85 c0                	test   %eax,%eax
80106246:	0f 84 eb 01 00 00    	je     80106437 <trap+0x227>
8010624c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106250:	0f 84 e1 01 00 00    	je     80106437 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106256:	0f 20 d1             	mov    %cr2,%ecx
80106259:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010625c:	e8 9f df ff ff       	call   80104200 <cpuid>
80106261:	8b 73 30             	mov    0x30(%ebx),%esi
80106264:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106267:	8b 43 34             	mov    0x34(%ebx),%eax
8010626a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010626d:	e8 ae df ff ff       	call   80104220 <myproc>
80106272:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106275:	e8 a6 df ff ff       	call   80104220 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010627a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010627d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106280:	51                   	push   %ecx
80106281:	57                   	push   %edi
80106282:	52                   	push   %edx
80106283:	ff 75 e4             	pushl  -0x1c(%ebp)
80106286:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106287:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010628a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010628d:	56                   	push   %esi
8010628e:	ff 70 10             	pushl  0x10(%eax)
80106291:	68 fc 81 10 80       	push   $0x801081fc
80106296:	e8 b5 a6 ff ff       	call   80100950 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010629b:	83 c4 20             	add    $0x20,%esp
8010629e:	e8 7d df ff ff       	call   80104220 <myproc>
801062a3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062aa:	e8 71 df ff ff       	call   80104220 <myproc>
801062af:	85 c0                	test   %eax,%eax
801062b1:	74 1d                	je     801062d0 <trap+0xc0>
801062b3:	e8 68 df ff ff       	call   80104220 <myproc>
801062b8:	8b 50 24             	mov    0x24(%eax),%edx
801062bb:	85 d2                	test   %edx,%edx
801062bd:	74 11                	je     801062d0 <trap+0xc0>
801062bf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062c3:	83 e0 03             	and    $0x3,%eax
801062c6:	66 83 f8 03          	cmp    $0x3,%ax
801062ca:	0f 84 50 01 00 00    	je     80106420 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062d0:	e8 4b df ff ff       	call   80104220 <myproc>
801062d5:	85 c0                	test   %eax,%eax
801062d7:	74 0f                	je     801062e8 <trap+0xd8>
801062d9:	e8 42 df ff ff       	call   80104220 <myproc>
801062de:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062e2:	0f 84 e8 00 00 00    	je     801063d0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062e8:	e8 33 df ff ff       	call   80104220 <myproc>
801062ed:	85 c0                	test   %eax,%eax
801062ef:	74 1d                	je     8010630e <trap+0xfe>
801062f1:	e8 2a df ff ff       	call   80104220 <myproc>
801062f6:	8b 40 24             	mov    0x24(%eax),%eax
801062f9:	85 c0                	test   %eax,%eax
801062fb:	74 11                	je     8010630e <trap+0xfe>
801062fd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106301:	83 e0 03             	and    $0x3,%eax
80106304:	66 83 f8 03          	cmp    $0x3,%ax
80106308:	0f 84 03 01 00 00    	je     80106411 <trap+0x201>
    exit();
}
8010630e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106311:	5b                   	pop    %ebx
80106312:	5e                   	pop    %esi
80106313:	5f                   	pop    %edi
80106314:	5d                   	pop    %ebp
80106315:	c3                   	ret    
    ideintr();
80106316:	e8 85 c7 ff ff       	call   80102aa0 <ideintr>
    lapiceoi();
8010631b:	e8 60 ce ff ff       	call   80103180 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106320:	e8 fb de ff ff       	call   80104220 <myproc>
80106325:	85 c0                	test   %eax,%eax
80106327:	75 8a                	jne    801062b3 <trap+0xa3>
80106329:	eb a5                	jmp    801062d0 <trap+0xc0>
    if(cpuid() == 0){
8010632b:	e8 d0 de ff ff       	call   80104200 <cpuid>
80106330:	85 c0                	test   %eax,%eax
80106332:	75 e7                	jne    8010631b <trap+0x10b>
      acquire(&tickslock);
80106334:	83 ec 0c             	sub    $0xc,%esp
80106337:	68 20 62 11 80       	push   $0x80116220
8010633c:	e8 df ea ff ff       	call   80104e20 <acquire>
      wakeup(&ticks);
80106341:	c7 04 24 60 6a 11 80 	movl   $0x80116a60,(%esp)
      ticks++;
80106348:	83 05 60 6a 11 80 01 	addl   $0x1,0x80116a60
      wakeup(&ticks);
8010634f:	e8 4c e6 ff ff       	call   801049a0 <wakeup>
      release(&tickslock);
80106354:	c7 04 24 20 62 11 80 	movl   $0x80116220,(%esp)
8010635b:	e8 80 eb ff ff       	call   80104ee0 <release>
80106360:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106363:	eb b6                	jmp    8010631b <trap+0x10b>
    kbdintr();
80106365:	e8 d6 cc ff ff       	call   80103040 <kbdintr>
    lapiceoi();
8010636a:	e8 11 ce ff ff       	call   80103180 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010636f:	e8 ac de ff ff       	call   80104220 <myproc>
80106374:	85 c0                	test   %eax,%eax
80106376:	0f 85 37 ff ff ff    	jne    801062b3 <trap+0xa3>
8010637c:	e9 4f ff ff ff       	jmp    801062d0 <trap+0xc0>
    uartintr();
80106381:	e8 4a 02 00 00       	call   801065d0 <uartintr>
    lapiceoi();
80106386:	e8 f5 cd ff ff       	call   80103180 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010638b:	e8 90 de ff ff       	call   80104220 <myproc>
80106390:	85 c0                	test   %eax,%eax
80106392:	0f 85 1b ff ff ff    	jne    801062b3 <trap+0xa3>
80106398:	e9 33 ff ff ff       	jmp    801062d0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010639d:	8b 7b 38             	mov    0x38(%ebx),%edi
801063a0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801063a4:	e8 57 de ff ff       	call   80104200 <cpuid>
801063a9:	57                   	push   %edi
801063aa:	56                   	push   %esi
801063ab:	50                   	push   %eax
801063ac:	68 a4 81 10 80       	push   $0x801081a4
801063b1:	e8 9a a5 ff ff       	call   80100950 <cprintf>
    lapiceoi();
801063b6:	e8 c5 cd ff ff       	call   80103180 <lapiceoi>
    break;
801063bb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063be:	e8 5d de ff ff       	call   80104220 <myproc>
801063c3:	85 c0                	test   %eax,%eax
801063c5:	0f 85 e8 fe ff ff    	jne    801062b3 <trap+0xa3>
801063cb:	e9 00 ff ff ff       	jmp    801062d0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801063d0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801063d4:	0f 85 0e ff ff ff    	jne    801062e8 <trap+0xd8>
    yield();
801063da:	e8 b1 e3 ff ff       	call   80104790 <yield>
801063df:	e9 04 ff ff ff       	jmp    801062e8 <trap+0xd8>
801063e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801063e8:	e8 33 de ff ff       	call   80104220 <myproc>
801063ed:	8b 70 24             	mov    0x24(%eax),%esi
801063f0:	85 f6                	test   %esi,%esi
801063f2:	75 3c                	jne    80106430 <trap+0x220>
    myproc()->tf = tf;
801063f4:	e8 27 de ff ff       	call   80104220 <myproc>
801063f9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801063fc:	e8 ff ee ff ff       	call   80105300 <syscall>
    if(myproc()->killed)
80106401:	e8 1a de ff ff       	call   80104220 <myproc>
80106406:	8b 48 24             	mov    0x24(%eax),%ecx
80106409:	85 c9                	test   %ecx,%ecx
8010640b:	0f 84 fd fe ff ff    	je     8010630e <trap+0xfe>
}
80106411:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106414:	5b                   	pop    %ebx
80106415:	5e                   	pop    %esi
80106416:	5f                   	pop    %edi
80106417:	5d                   	pop    %ebp
      exit();
80106418:	e9 33 e2 ff ff       	jmp    80104650 <exit>
8010641d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106420:	e8 2b e2 ff ff       	call   80104650 <exit>
80106425:	e9 a6 fe ff ff       	jmp    801062d0 <trap+0xc0>
8010642a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106430:	e8 1b e2 ff ff       	call   80104650 <exit>
80106435:	eb bd                	jmp    801063f4 <trap+0x1e4>
80106437:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010643a:	e8 c1 dd ff ff       	call   80104200 <cpuid>
8010643f:	83 ec 0c             	sub    $0xc,%esp
80106442:	56                   	push   %esi
80106443:	57                   	push   %edi
80106444:	50                   	push   %eax
80106445:	ff 73 30             	pushl  0x30(%ebx)
80106448:	68 c8 81 10 80       	push   $0x801081c8
8010644d:	e8 fe a4 ff ff       	call   80100950 <cprintf>
      panic("trap");
80106452:	83 c4 14             	add    $0x14,%esp
80106455:	68 9e 81 10 80       	push   $0x8010819e
8010645a:	e8 31 9f ff ff       	call   80100390 <panic>
8010645f:	90                   	nop

80106460 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106460:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106464:	a1 dc b5 10 80       	mov    0x8010b5dc,%eax
80106469:	85 c0                	test   %eax,%eax
8010646b:	74 1b                	je     80106488 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010646d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106472:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106473:	a8 01                	test   $0x1,%al
80106475:	74 11                	je     80106488 <uartgetc+0x28>
80106477:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010647c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010647d:	0f b6 c0             	movzbl %al,%eax
80106480:	c3                   	ret    
80106481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010648d:	c3                   	ret    
8010648e:	66 90                	xchg   %ax,%ax

80106490 <uartputc.part.0>:
uartputc(int c)
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	57                   	push   %edi
80106494:	89 c7                	mov    %eax,%edi
80106496:	56                   	push   %esi
80106497:	be fd 03 00 00       	mov    $0x3fd,%esi
8010649c:	53                   	push   %ebx
8010649d:	bb 80 00 00 00       	mov    $0x80,%ebx
801064a2:	83 ec 0c             	sub    $0xc,%esp
801064a5:	eb 1b                	jmp    801064c2 <uartputc.part.0+0x32>
801064a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ae:	66 90                	xchg   %ax,%ax
    microdelay(10);
801064b0:	83 ec 0c             	sub    $0xc,%esp
801064b3:	6a 0a                	push   $0xa
801064b5:	e8 e6 cc ff ff       	call   801031a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064ba:	83 c4 10             	add    $0x10,%esp
801064bd:	83 eb 01             	sub    $0x1,%ebx
801064c0:	74 07                	je     801064c9 <uartputc.part.0+0x39>
801064c2:	89 f2                	mov    %esi,%edx
801064c4:	ec                   	in     (%dx),%al
801064c5:	a8 20                	test   $0x20,%al
801064c7:	74 e7                	je     801064b0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064c9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ce:	89 f8                	mov    %edi,%eax
801064d0:	ee                   	out    %al,(%dx)
}
801064d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064d4:	5b                   	pop    %ebx
801064d5:	5e                   	pop    %esi
801064d6:	5f                   	pop    %edi
801064d7:	5d                   	pop    %ebp
801064d8:	c3                   	ret    
801064d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064e0 <uartinit>:
{
801064e0:	f3 0f 1e fb          	endbr32 
801064e4:	55                   	push   %ebp
801064e5:	31 c9                	xor    %ecx,%ecx
801064e7:	89 c8                	mov    %ecx,%eax
801064e9:	89 e5                	mov    %esp,%ebp
801064eb:	57                   	push   %edi
801064ec:	56                   	push   %esi
801064ed:	53                   	push   %ebx
801064ee:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801064f3:	89 da                	mov    %ebx,%edx
801064f5:	83 ec 0c             	sub    $0xc,%esp
801064f8:	ee                   	out    %al,(%dx)
801064f9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801064fe:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106503:	89 fa                	mov    %edi,%edx
80106505:	ee                   	out    %al,(%dx)
80106506:	b8 0c 00 00 00       	mov    $0xc,%eax
8010650b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106510:	ee                   	out    %al,(%dx)
80106511:	be f9 03 00 00       	mov    $0x3f9,%esi
80106516:	89 c8                	mov    %ecx,%eax
80106518:	89 f2                	mov    %esi,%edx
8010651a:	ee                   	out    %al,(%dx)
8010651b:	b8 03 00 00 00       	mov    $0x3,%eax
80106520:	89 fa                	mov    %edi,%edx
80106522:	ee                   	out    %al,(%dx)
80106523:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106528:	89 c8                	mov    %ecx,%eax
8010652a:	ee                   	out    %al,(%dx)
8010652b:	b8 01 00 00 00       	mov    $0x1,%eax
80106530:	89 f2                	mov    %esi,%edx
80106532:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106533:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106538:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106539:	3c ff                	cmp    $0xff,%al
8010653b:	74 52                	je     8010658f <uartinit+0xaf>
  uart = 1;
8010653d:	c7 05 dc b5 10 80 01 	movl   $0x1,0x8010b5dc
80106544:	00 00 00 
80106547:	89 da                	mov    %ebx,%edx
80106549:	ec                   	in     (%dx),%al
8010654a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010654f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106550:	83 ec 08             	sub    $0x8,%esp
80106553:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106558:	bb c0 82 10 80       	mov    $0x801082c0,%ebx
  ioapicenable(IRQ_COM1, 0);
8010655d:	6a 00                	push   $0x0
8010655f:	6a 04                	push   $0x4
80106561:	e8 8a c7 ff ff       	call   80102cf0 <ioapicenable>
80106566:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106569:	b8 78 00 00 00       	mov    $0x78,%eax
8010656e:	eb 04                	jmp    80106574 <uartinit+0x94>
80106570:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106574:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
8010657a:	85 d2                	test   %edx,%edx
8010657c:	74 08                	je     80106586 <uartinit+0xa6>
    uartputc(*p);
8010657e:	0f be c0             	movsbl %al,%eax
80106581:	e8 0a ff ff ff       	call   80106490 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106586:	89 f0                	mov    %esi,%eax
80106588:	83 c3 01             	add    $0x1,%ebx
8010658b:	84 c0                	test   %al,%al
8010658d:	75 e1                	jne    80106570 <uartinit+0x90>
}
8010658f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106592:	5b                   	pop    %ebx
80106593:	5e                   	pop    %esi
80106594:	5f                   	pop    %edi
80106595:	5d                   	pop    %ebp
80106596:	c3                   	ret    
80106597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010659e:	66 90                	xchg   %ax,%ax

801065a0 <uartputc>:
{
801065a0:	f3 0f 1e fb          	endbr32 
801065a4:	55                   	push   %ebp
  if(!uart)
801065a5:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
{
801065ab:	89 e5                	mov    %esp,%ebp
801065ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065b0:	85 d2                	test   %edx,%edx
801065b2:	74 0c                	je     801065c0 <uartputc+0x20>
}
801065b4:	5d                   	pop    %ebp
801065b5:	e9 d6 fe ff ff       	jmp    80106490 <uartputc.part.0>
801065ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065c0:	5d                   	pop    %ebp
801065c1:	c3                   	ret    
801065c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065d0 <uartintr>:

void
uartintr(void)
{
801065d0:	f3 0f 1e fb          	endbr32 
801065d4:	55                   	push   %ebp
801065d5:	89 e5                	mov    %esp,%ebp
801065d7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065da:	68 60 64 10 80       	push   $0x80106460
801065df:	e8 8c a7 ff ff       	call   80100d70 <consoleintr>
}
801065e4:	83 c4 10             	add    $0x10,%esp
801065e7:	c9                   	leave  
801065e8:	c3                   	ret    

801065e9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $0
801065eb:	6a 00                	push   $0x0
  jmp alltraps
801065ed:	e9 3c fb ff ff       	jmp    8010612e <alltraps>

801065f2 <vector1>:
.globl vector1
vector1:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $1
801065f4:	6a 01                	push   $0x1
  jmp alltraps
801065f6:	e9 33 fb ff ff       	jmp    8010612e <alltraps>

801065fb <vector2>:
.globl vector2
vector2:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $2
801065fd:	6a 02                	push   $0x2
  jmp alltraps
801065ff:	e9 2a fb ff ff       	jmp    8010612e <alltraps>

80106604 <vector3>:
.globl vector3
vector3:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $3
80106606:	6a 03                	push   $0x3
  jmp alltraps
80106608:	e9 21 fb ff ff       	jmp    8010612e <alltraps>

8010660d <vector4>:
.globl vector4
vector4:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $4
8010660f:	6a 04                	push   $0x4
  jmp alltraps
80106611:	e9 18 fb ff ff       	jmp    8010612e <alltraps>

80106616 <vector5>:
.globl vector5
vector5:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $5
80106618:	6a 05                	push   $0x5
  jmp alltraps
8010661a:	e9 0f fb ff ff       	jmp    8010612e <alltraps>

8010661f <vector6>:
.globl vector6
vector6:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $6
80106621:	6a 06                	push   $0x6
  jmp alltraps
80106623:	e9 06 fb ff ff       	jmp    8010612e <alltraps>

80106628 <vector7>:
.globl vector7
vector7:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $7
8010662a:	6a 07                	push   $0x7
  jmp alltraps
8010662c:	e9 fd fa ff ff       	jmp    8010612e <alltraps>

80106631 <vector8>:
.globl vector8
vector8:
  pushl $8
80106631:	6a 08                	push   $0x8
  jmp alltraps
80106633:	e9 f6 fa ff ff       	jmp    8010612e <alltraps>

80106638 <vector9>:
.globl vector9
vector9:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $9
8010663a:	6a 09                	push   $0x9
  jmp alltraps
8010663c:	e9 ed fa ff ff       	jmp    8010612e <alltraps>

80106641 <vector10>:
.globl vector10
vector10:
  pushl $10
80106641:	6a 0a                	push   $0xa
  jmp alltraps
80106643:	e9 e6 fa ff ff       	jmp    8010612e <alltraps>

80106648 <vector11>:
.globl vector11
vector11:
  pushl $11
80106648:	6a 0b                	push   $0xb
  jmp alltraps
8010664a:	e9 df fa ff ff       	jmp    8010612e <alltraps>

8010664f <vector12>:
.globl vector12
vector12:
  pushl $12
8010664f:	6a 0c                	push   $0xc
  jmp alltraps
80106651:	e9 d8 fa ff ff       	jmp    8010612e <alltraps>

80106656 <vector13>:
.globl vector13
vector13:
  pushl $13
80106656:	6a 0d                	push   $0xd
  jmp alltraps
80106658:	e9 d1 fa ff ff       	jmp    8010612e <alltraps>

8010665d <vector14>:
.globl vector14
vector14:
  pushl $14
8010665d:	6a 0e                	push   $0xe
  jmp alltraps
8010665f:	e9 ca fa ff ff       	jmp    8010612e <alltraps>

80106664 <vector15>:
.globl vector15
vector15:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $15
80106666:	6a 0f                	push   $0xf
  jmp alltraps
80106668:	e9 c1 fa ff ff       	jmp    8010612e <alltraps>

8010666d <vector16>:
.globl vector16
vector16:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $16
8010666f:	6a 10                	push   $0x10
  jmp alltraps
80106671:	e9 b8 fa ff ff       	jmp    8010612e <alltraps>

80106676 <vector17>:
.globl vector17
vector17:
  pushl $17
80106676:	6a 11                	push   $0x11
  jmp alltraps
80106678:	e9 b1 fa ff ff       	jmp    8010612e <alltraps>

8010667d <vector18>:
.globl vector18
vector18:
  pushl $0
8010667d:	6a 00                	push   $0x0
  pushl $18
8010667f:	6a 12                	push   $0x12
  jmp alltraps
80106681:	e9 a8 fa ff ff       	jmp    8010612e <alltraps>

80106686 <vector19>:
.globl vector19
vector19:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $19
80106688:	6a 13                	push   $0x13
  jmp alltraps
8010668a:	e9 9f fa ff ff       	jmp    8010612e <alltraps>

8010668f <vector20>:
.globl vector20
vector20:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $20
80106691:	6a 14                	push   $0x14
  jmp alltraps
80106693:	e9 96 fa ff ff       	jmp    8010612e <alltraps>

80106698 <vector21>:
.globl vector21
vector21:
  pushl $0
80106698:	6a 00                	push   $0x0
  pushl $21
8010669a:	6a 15                	push   $0x15
  jmp alltraps
8010669c:	e9 8d fa ff ff       	jmp    8010612e <alltraps>

801066a1 <vector22>:
.globl vector22
vector22:
  pushl $0
801066a1:	6a 00                	push   $0x0
  pushl $22
801066a3:	6a 16                	push   $0x16
  jmp alltraps
801066a5:	e9 84 fa ff ff       	jmp    8010612e <alltraps>

801066aa <vector23>:
.globl vector23
vector23:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $23
801066ac:	6a 17                	push   $0x17
  jmp alltraps
801066ae:	e9 7b fa ff ff       	jmp    8010612e <alltraps>

801066b3 <vector24>:
.globl vector24
vector24:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $24
801066b5:	6a 18                	push   $0x18
  jmp alltraps
801066b7:	e9 72 fa ff ff       	jmp    8010612e <alltraps>

801066bc <vector25>:
.globl vector25
vector25:
  pushl $0
801066bc:	6a 00                	push   $0x0
  pushl $25
801066be:	6a 19                	push   $0x19
  jmp alltraps
801066c0:	e9 69 fa ff ff       	jmp    8010612e <alltraps>

801066c5 <vector26>:
.globl vector26
vector26:
  pushl $0
801066c5:	6a 00                	push   $0x0
  pushl $26
801066c7:	6a 1a                	push   $0x1a
  jmp alltraps
801066c9:	e9 60 fa ff ff       	jmp    8010612e <alltraps>

801066ce <vector27>:
.globl vector27
vector27:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $27
801066d0:	6a 1b                	push   $0x1b
  jmp alltraps
801066d2:	e9 57 fa ff ff       	jmp    8010612e <alltraps>

801066d7 <vector28>:
.globl vector28
vector28:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $28
801066d9:	6a 1c                	push   $0x1c
  jmp alltraps
801066db:	e9 4e fa ff ff       	jmp    8010612e <alltraps>

801066e0 <vector29>:
.globl vector29
vector29:
  pushl $0
801066e0:	6a 00                	push   $0x0
  pushl $29
801066e2:	6a 1d                	push   $0x1d
  jmp alltraps
801066e4:	e9 45 fa ff ff       	jmp    8010612e <alltraps>

801066e9 <vector30>:
.globl vector30
vector30:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $30
801066eb:	6a 1e                	push   $0x1e
  jmp alltraps
801066ed:	e9 3c fa ff ff       	jmp    8010612e <alltraps>

801066f2 <vector31>:
.globl vector31
vector31:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $31
801066f4:	6a 1f                	push   $0x1f
  jmp alltraps
801066f6:	e9 33 fa ff ff       	jmp    8010612e <alltraps>

801066fb <vector32>:
.globl vector32
vector32:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $32
801066fd:	6a 20                	push   $0x20
  jmp alltraps
801066ff:	e9 2a fa ff ff       	jmp    8010612e <alltraps>

80106704 <vector33>:
.globl vector33
vector33:
  pushl $0
80106704:	6a 00                	push   $0x0
  pushl $33
80106706:	6a 21                	push   $0x21
  jmp alltraps
80106708:	e9 21 fa ff ff       	jmp    8010612e <alltraps>

8010670d <vector34>:
.globl vector34
vector34:
  pushl $0
8010670d:	6a 00                	push   $0x0
  pushl $34
8010670f:	6a 22                	push   $0x22
  jmp alltraps
80106711:	e9 18 fa ff ff       	jmp    8010612e <alltraps>

80106716 <vector35>:
.globl vector35
vector35:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $35
80106718:	6a 23                	push   $0x23
  jmp alltraps
8010671a:	e9 0f fa ff ff       	jmp    8010612e <alltraps>

8010671f <vector36>:
.globl vector36
vector36:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $36
80106721:	6a 24                	push   $0x24
  jmp alltraps
80106723:	e9 06 fa ff ff       	jmp    8010612e <alltraps>

80106728 <vector37>:
.globl vector37
vector37:
  pushl $0
80106728:	6a 00                	push   $0x0
  pushl $37
8010672a:	6a 25                	push   $0x25
  jmp alltraps
8010672c:	e9 fd f9 ff ff       	jmp    8010612e <alltraps>

80106731 <vector38>:
.globl vector38
vector38:
  pushl $0
80106731:	6a 00                	push   $0x0
  pushl $38
80106733:	6a 26                	push   $0x26
  jmp alltraps
80106735:	e9 f4 f9 ff ff       	jmp    8010612e <alltraps>

8010673a <vector39>:
.globl vector39
vector39:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $39
8010673c:	6a 27                	push   $0x27
  jmp alltraps
8010673e:	e9 eb f9 ff ff       	jmp    8010612e <alltraps>

80106743 <vector40>:
.globl vector40
vector40:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $40
80106745:	6a 28                	push   $0x28
  jmp alltraps
80106747:	e9 e2 f9 ff ff       	jmp    8010612e <alltraps>

8010674c <vector41>:
.globl vector41
vector41:
  pushl $0
8010674c:	6a 00                	push   $0x0
  pushl $41
8010674e:	6a 29                	push   $0x29
  jmp alltraps
80106750:	e9 d9 f9 ff ff       	jmp    8010612e <alltraps>

80106755 <vector42>:
.globl vector42
vector42:
  pushl $0
80106755:	6a 00                	push   $0x0
  pushl $42
80106757:	6a 2a                	push   $0x2a
  jmp alltraps
80106759:	e9 d0 f9 ff ff       	jmp    8010612e <alltraps>

8010675e <vector43>:
.globl vector43
vector43:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $43
80106760:	6a 2b                	push   $0x2b
  jmp alltraps
80106762:	e9 c7 f9 ff ff       	jmp    8010612e <alltraps>

80106767 <vector44>:
.globl vector44
vector44:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $44
80106769:	6a 2c                	push   $0x2c
  jmp alltraps
8010676b:	e9 be f9 ff ff       	jmp    8010612e <alltraps>

80106770 <vector45>:
.globl vector45
vector45:
  pushl $0
80106770:	6a 00                	push   $0x0
  pushl $45
80106772:	6a 2d                	push   $0x2d
  jmp alltraps
80106774:	e9 b5 f9 ff ff       	jmp    8010612e <alltraps>

80106779 <vector46>:
.globl vector46
vector46:
  pushl $0
80106779:	6a 00                	push   $0x0
  pushl $46
8010677b:	6a 2e                	push   $0x2e
  jmp alltraps
8010677d:	e9 ac f9 ff ff       	jmp    8010612e <alltraps>

80106782 <vector47>:
.globl vector47
vector47:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $47
80106784:	6a 2f                	push   $0x2f
  jmp alltraps
80106786:	e9 a3 f9 ff ff       	jmp    8010612e <alltraps>

8010678b <vector48>:
.globl vector48
vector48:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $48
8010678d:	6a 30                	push   $0x30
  jmp alltraps
8010678f:	e9 9a f9 ff ff       	jmp    8010612e <alltraps>

80106794 <vector49>:
.globl vector49
vector49:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $49
80106796:	6a 31                	push   $0x31
  jmp alltraps
80106798:	e9 91 f9 ff ff       	jmp    8010612e <alltraps>

8010679d <vector50>:
.globl vector50
vector50:
  pushl $0
8010679d:	6a 00                	push   $0x0
  pushl $50
8010679f:	6a 32                	push   $0x32
  jmp alltraps
801067a1:	e9 88 f9 ff ff       	jmp    8010612e <alltraps>

801067a6 <vector51>:
.globl vector51
vector51:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $51
801067a8:	6a 33                	push   $0x33
  jmp alltraps
801067aa:	e9 7f f9 ff ff       	jmp    8010612e <alltraps>

801067af <vector52>:
.globl vector52
vector52:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $52
801067b1:	6a 34                	push   $0x34
  jmp alltraps
801067b3:	e9 76 f9 ff ff       	jmp    8010612e <alltraps>

801067b8 <vector53>:
.globl vector53
vector53:
  pushl $0
801067b8:	6a 00                	push   $0x0
  pushl $53
801067ba:	6a 35                	push   $0x35
  jmp alltraps
801067bc:	e9 6d f9 ff ff       	jmp    8010612e <alltraps>

801067c1 <vector54>:
.globl vector54
vector54:
  pushl $0
801067c1:	6a 00                	push   $0x0
  pushl $54
801067c3:	6a 36                	push   $0x36
  jmp alltraps
801067c5:	e9 64 f9 ff ff       	jmp    8010612e <alltraps>

801067ca <vector55>:
.globl vector55
vector55:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $55
801067cc:	6a 37                	push   $0x37
  jmp alltraps
801067ce:	e9 5b f9 ff ff       	jmp    8010612e <alltraps>

801067d3 <vector56>:
.globl vector56
vector56:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $56
801067d5:	6a 38                	push   $0x38
  jmp alltraps
801067d7:	e9 52 f9 ff ff       	jmp    8010612e <alltraps>

801067dc <vector57>:
.globl vector57
vector57:
  pushl $0
801067dc:	6a 00                	push   $0x0
  pushl $57
801067de:	6a 39                	push   $0x39
  jmp alltraps
801067e0:	e9 49 f9 ff ff       	jmp    8010612e <alltraps>

801067e5 <vector58>:
.globl vector58
vector58:
  pushl $0
801067e5:	6a 00                	push   $0x0
  pushl $58
801067e7:	6a 3a                	push   $0x3a
  jmp alltraps
801067e9:	e9 40 f9 ff ff       	jmp    8010612e <alltraps>

801067ee <vector59>:
.globl vector59
vector59:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $59
801067f0:	6a 3b                	push   $0x3b
  jmp alltraps
801067f2:	e9 37 f9 ff ff       	jmp    8010612e <alltraps>

801067f7 <vector60>:
.globl vector60
vector60:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $60
801067f9:	6a 3c                	push   $0x3c
  jmp alltraps
801067fb:	e9 2e f9 ff ff       	jmp    8010612e <alltraps>

80106800 <vector61>:
.globl vector61
vector61:
  pushl $0
80106800:	6a 00                	push   $0x0
  pushl $61
80106802:	6a 3d                	push   $0x3d
  jmp alltraps
80106804:	e9 25 f9 ff ff       	jmp    8010612e <alltraps>

80106809 <vector62>:
.globl vector62
vector62:
  pushl $0
80106809:	6a 00                	push   $0x0
  pushl $62
8010680b:	6a 3e                	push   $0x3e
  jmp alltraps
8010680d:	e9 1c f9 ff ff       	jmp    8010612e <alltraps>

80106812 <vector63>:
.globl vector63
vector63:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $63
80106814:	6a 3f                	push   $0x3f
  jmp alltraps
80106816:	e9 13 f9 ff ff       	jmp    8010612e <alltraps>

8010681b <vector64>:
.globl vector64
vector64:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $64
8010681d:	6a 40                	push   $0x40
  jmp alltraps
8010681f:	e9 0a f9 ff ff       	jmp    8010612e <alltraps>

80106824 <vector65>:
.globl vector65
vector65:
  pushl $0
80106824:	6a 00                	push   $0x0
  pushl $65
80106826:	6a 41                	push   $0x41
  jmp alltraps
80106828:	e9 01 f9 ff ff       	jmp    8010612e <alltraps>

8010682d <vector66>:
.globl vector66
vector66:
  pushl $0
8010682d:	6a 00                	push   $0x0
  pushl $66
8010682f:	6a 42                	push   $0x42
  jmp alltraps
80106831:	e9 f8 f8 ff ff       	jmp    8010612e <alltraps>

80106836 <vector67>:
.globl vector67
vector67:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $67
80106838:	6a 43                	push   $0x43
  jmp alltraps
8010683a:	e9 ef f8 ff ff       	jmp    8010612e <alltraps>

8010683f <vector68>:
.globl vector68
vector68:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $68
80106841:	6a 44                	push   $0x44
  jmp alltraps
80106843:	e9 e6 f8 ff ff       	jmp    8010612e <alltraps>

80106848 <vector69>:
.globl vector69
vector69:
  pushl $0
80106848:	6a 00                	push   $0x0
  pushl $69
8010684a:	6a 45                	push   $0x45
  jmp alltraps
8010684c:	e9 dd f8 ff ff       	jmp    8010612e <alltraps>

80106851 <vector70>:
.globl vector70
vector70:
  pushl $0
80106851:	6a 00                	push   $0x0
  pushl $70
80106853:	6a 46                	push   $0x46
  jmp alltraps
80106855:	e9 d4 f8 ff ff       	jmp    8010612e <alltraps>

8010685a <vector71>:
.globl vector71
vector71:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $71
8010685c:	6a 47                	push   $0x47
  jmp alltraps
8010685e:	e9 cb f8 ff ff       	jmp    8010612e <alltraps>

80106863 <vector72>:
.globl vector72
vector72:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $72
80106865:	6a 48                	push   $0x48
  jmp alltraps
80106867:	e9 c2 f8 ff ff       	jmp    8010612e <alltraps>

8010686c <vector73>:
.globl vector73
vector73:
  pushl $0
8010686c:	6a 00                	push   $0x0
  pushl $73
8010686e:	6a 49                	push   $0x49
  jmp alltraps
80106870:	e9 b9 f8 ff ff       	jmp    8010612e <alltraps>

80106875 <vector74>:
.globl vector74
vector74:
  pushl $0
80106875:	6a 00                	push   $0x0
  pushl $74
80106877:	6a 4a                	push   $0x4a
  jmp alltraps
80106879:	e9 b0 f8 ff ff       	jmp    8010612e <alltraps>

8010687e <vector75>:
.globl vector75
vector75:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $75
80106880:	6a 4b                	push   $0x4b
  jmp alltraps
80106882:	e9 a7 f8 ff ff       	jmp    8010612e <alltraps>

80106887 <vector76>:
.globl vector76
vector76:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $76
80106889:	6a 4c                	push   $0x4c
  jmp alltraps
8010688b:	e9 9e f8 ff ff       	jmp    8010612e <alltraps>

80106890 <vector77>:
.globl vector77
vector77:
  pushl $0
80106890:	6a 00                	push   $0x0
  pushl $77
80106892:	6a 4d                	push   $0x4d
  jmp alltraps
80106894:	e9 95 f8 ff ff       	jmp    8010612e <alltraps>

80106899 <vector78>:
.globl vector78
vector78:
  pushl $0
80106899:	6a 00                	push   $0x0
  pushl $78
8010689b:	6a 4e                	push   $0x4e
  jmp alltraps
8010689d:	e9 8c f8 ff ff       	jmp    8010612e <alltraps>

801068a2 <vector79>:
.globl vector79
vector79:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $79
801068a4:	6a 4f                	push   $0x4f
  jmp alltraps
801068a6:	e9 83 f8 ff ff       	jmp    8010612e <alltraps>

801068ab <vector80>:
.globl vector80
vector80:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $80
801068ad:	6a 50                	push   $0x50
  jmp alltraps
801068af:	e9 7a f8 ff ff       	jmp    8010612e <alltraps>

801068b4 <vector81>:
.globl vector81
vector81:
  pushl $0
801068b4:	6a 00                	push   $0x0
  pushl $81
801068b6:	6a 51                	push   $0x51
  jmp alltraps
801068b8:	e9 71 f8 ff ff       	jmp    8010612e <alltraps>

801068bd <vector82>:
.globl vector82
vector82:
  pushl $0
801068bd:	6a 00                	push   $0x0
  pushl $82
801068bf:	6a 52                	push   $0x52
  jmp alltraps
801068c1:	e9 68 f8 ff ff       	jmp    8010612e <alltraps>

801068c6 <vector83>:
.globl vector83
vector83:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $83
801068c8:	6a 53                	push   $0x53
  jmp alltraps
801068ca:	e9 5f f8 ff ff       	jmp    8010612e <alltraps>

801068cf <vector84>:
.globl vector84
vector84:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $84
801068d1:	6a 54                	push   $0x54
  jmp alltraps
801068d3:	e9 56 f8 ff ff       	jmp    8010612e <alltraps>

801068d8 <vector85>:
.globl vector85
vector85:
  pushl $0
801068d8:	6a 00                	push   $0x0
  pushl $85
801068da:	6a 55                	push   $0x55
  jmp alltraps
801068dc:	e9 4d f8 ff ff       	jmp    8010612e <alltraps>

801068e1 <vector86>:
.globl vector86
vector86:
  pushl $0
801068e1:	6a 00                	push   $0x0
  pushl $86
801068e3:	6a 56                	push   $0x56
  jmp alltraps
801068e5:	e9 44 f8 ff ff       	jmp    8010612e <alltraps>

801068ea <vector87>:
.globl vector87
vector87:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $87
801068ec:	6a 57                	push   $0x57
  jmp alltraps
801068ee:	e9 3b f8 ff ff       	jmp    8010612e <alltraps>

801068f3 <vector88>:
.globl vector88
vector88:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $88
801068f5:	6a 58                	push   $0x58
  jmp alltraps
801068f7:	e9 32 f8 ff ff       	jmp    8010612e <alltraps>

801068fc <vector89>:
.globl vector89
vector89:
  pushl $0
801068fc:	6a 00                	push   $0x0
  pushl $89
801068fe:	6a 59                	push   $0x59
  jmp alltraps
80106900:	e9 29 f8 ff ff       	jmp    8010612e <alltraps>

80106905 <vector90>:
.globl vector90
vector90:
  pushl $0
80106905:	6a 00                	push   $0x0
  pushl $90
80106907:	6a 5a                	push   $0x5a
  jmp alltraps
80106909:	e9 20 f8 ff ff       	jmp    8010612e <alltraps>

8010690e <vector91>:
.globl vector91
vector91:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $91
80106910:	6a 5b                	push   $0x5b
  jmp alltraps
80106912:	e9 17 f8 ff ff       	jmp    8010612e <alltraps>

80106917 <vector92>:
.globl vector92
vector92:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $92
80106919:	6a 5c                	push   $0x5c
  jmp alltraps
8010691b:	e9 0e f8 ff ff       	jmp    8010612e <alltraps>

80106920 <vector93>:
.globl vector93
vector93:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $93
80106922:	6a 5d                	push   $0x5d
  jmp alltraps
80106924:	e9 05 f8 ff ff       	jmp    8010612e <alltraps>

80106929 <vector94>:
.globl vector94
vector94:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $94
8010692b:	6a 5e                	push   $0x5e
  jmp alltraps
8010692d:	e9 fc f7 ff ff       	jmp    8010612e <alltraps>

80106932 <vector95>:
.globl vector95
vector95:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $95
80106934:	6a 5f                	push   $0x5f
  jmp alltraps
80106936:	e9 f3 f7 ff ff       	jmp    8010612e <alltraps>

8010693b <vector96>:
.globl vector96
vector96:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $96
8010693d:	6a 60                	push   $0x60
  jmp alltraps
8010693f:	e9 ea f7 ff ff       	jmp    8010612e <alltraps>

80106944 <vector97>:
.globl vector97
vector97:
  pushl $0
80106944:	6a 00                	push   $0x0
  pushl $97
80106946:	6a 61                	push   $0x61
  jmp alltraps
80106948:	e9 e1 f7 ff ff       	jmp    8010612e <alltraps>

8010694d <vector98>:
.globl vector98
vector98:
  pushl $0
8010694d:	6a 00                	push   $0x0
  pushl $98
8010694f:	6a 62                	push   $0x62
  jmp alltraps
80106951:	e9 d8 f7 ff ff       	jmp    8010612e <alltraps>

80106956 <vector99>:
.globl vector99
vector99:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $99
80106958:	6a 63                	push   $0x63
  jmp alltraps
8010695a:	e9 cf f7 ff ff       	jmp    8010612e <alltraps>

8010695f <vector100>:
.globl vector100
vector100:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $100
80106961:	6a 64                	push   $0x64
  jmp alltraps
80106963:	e9 c6 f7 ff ff       	jmp    8010612e <alltraps>

80106968 <vector101>:
.globl vector101
vector101:
  pushl $0
80106968:	6a 00                	push   $0x0
  pushl $101
8010696a:	6a 65                	push   $0x65
  jmp alltraps
8010696c:	e9 bd f7 ff ff       	jmp    8010612e <alltraps>

80106971 <vector102>:
.globl vector102
vector102:
  pushl $0
80106971:	6a 00                	push   $0x0
  pushl $102
80106973:	6a 66                	push   $0x66
  jmp alltraps
80106975:	e9 b4 f7 ff ff       	jmp    8010612e <alltraps>

8010697a <vector103>:
.globl vector103
vector103:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $103
8010697c:	6a 67                	push   $0x67
  jmp alltraps
8010697e:	e9 ab f7 ff ff       	jmp    8010612e <alltraps>

80106983 <vector104>:
.globl vector104
vector104:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $104
80106985:	6a 68                	push   $0x68
  jmp alltraps
80106987:	e9 a2 f7 ff ff       	jmp    8010612e <alltraps>

8010698c <vector105>:
.globl vector105
vector105:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $105
8010698e:	6a 69                	push   $0x69
  jmp alltraps
80106990:	e9 99 f7 ff ff       	jmp    8010612e <alltraps>

80106995 <vector106>:
.globl vector106
vector106:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $106
80106997:	6a 6a                	push   $0x6a
  jmp alltraps
80106999:	e9 90 f7 ff ff       	jmp    8010612e <alltraps>

8010699e <vector107>:
.globl vector107
vector107:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $107
801069a0:	6a 6b                	push   $0x6b
  jmp alltraps
801069a2:	e9 87 f7 ff ff       	jmp    8010612e <alltraps>

801069a7 <vector108>:
.globl vector108
vector108:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $108
801069a9:	6a 6c                	push   $0x6c
  jmp alltraps
801069ab:	e9 7e f7 ff ff       	jmp    8010612e <alltraps>

801069b0 <vector109>:
.globl vector109
vector109:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $109
801069b2:	6a 6d                	push   $0x6d
  jmp alltraps
801069b4:	e9 75 f7 ff ff       	jmp    8010612e <alltraps>

801069b9 <vector110>:
.globl vector110
vector110:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $110
801069bb:	6a 6e                	push   $0x6e
  jmp alltraps
801069bd:	e9 6c f7 ff ff       	jmp    8010612e <alltraps>

801069c2 <vector111>:
.globl vector111
vector111:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $111
801069c4:	6a 6f                	push   $0x6f
  jmp alltraps
801069c6:	e9 63 f7 ff ff       	jmp    8010612e <alltraps>

801069cb <vector112>:
.globl vector112
vector112:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $112
801069cd:	6a 70                	push   $0x70
  jmp alltraps
801069cf:	e9 5a f7 ff ff       	jmp    8010612e <alltraps>

801069d4 <vector113>:
.globl vector113
vector113:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $113
801069d6:	6a 71                	push   $0x71
  jmp alltraps
801069d8:	e9 51 f7 ff ff       	jmp    8010612e <alltraps>

801069dd <vector114>:
.globl vector114
vector114:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $114
801069df:	6a 72                	push   $0x72
  jmp alltraps
801069e1:	e9 48 f7 ff ff       	jmp    8010612e <alltraps>

801069e6 <vector115>:
.globl vector115
vector115:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $115
801069e8:	6a 73                	push   $0x73
  jmp alltraps
801069ea:	e9 3f f7 ff ff       	jmp    8010612e <alltraps>

801069ef <vector116>:
.globl vector116
vector116:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $116
801069f1:	6a 74                	push   $0x74
  jmp alltraps
801069f3:	e9 36 f7 ff ff       	jmp    8010612e <alltraps>

801069f8 <vector117>:
.globl vector117
vector117:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $117
801069fa:	6a 75                	push   $0x75
  jmp alltraps
801069fc:	e9 2d f7 ff ff       	jmp    8010612e <alltraps>

80106a01 <vector118>:
.globl vector118
vector118:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $118
80106a03:	6a 76                	push   $0x76
  jmp alltraps
80106a05:	e9 24 f7 ff ff       	jmp    8010612e <alltraps>

80106a0a <vector119>:
.globl vector119
vector119:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $119
80106a0c:	6a 77                	push   $0x77
  jmp alltraps
80106a0e:	e9 1b f7 ff ff       	jmp    8010612e <alltraps>

80106a13 <vector120>:
.globl vector120
vector120:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $120
80106a15:	6a 78                	push   $0x78
  jmp alltraps
80106a17:	e9 12 f7 ff ff       	jmp    8010612e <alltraps>

80106a1c <vector121>:
.globl vector121
vector121:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $121
80106a1e:	6a 79                	push   $0x79
  jmp alltraps
80106a20:	e9 09 f7 ff ff       	jmp    8010612e <alltraps>

80106a25 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $122
80106a27:	6a 7a                	push   $0x7a
  jmp alltraps
80106a29:	e9 00 f7 ff ff       	jmp    8010612e <alltraps>

80106a2e <vector123>:
.globl vector123
vector123:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $123
80106a30:	6a 7b                	push   $0x7b
  jmp alltraps
80106a32:	e9 f7 f6 ff ff       	jmp    8010612e <alltraps>

80106a37 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $124
80106a39:	6a 7c                	push   $0x7c
  jmp alltraps
80106a3b:	e9 ee f6 ff ff       	jmp    8010612e <alltraps>

80106a40 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $125
80106a42:	6a 7d                	push   $0x7d
  jmp alltraps
80106a44:	e9 e5 f6 ff ff       	jmp    8010612e <alltraps>

80106a49 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $126
80106a4b:	6a 7e                	push   $0x7e
  jmp alltraps
80106a4d:	e9 dc f6 ff ff       	jmp    8010612e <alltraps>

80106a52 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $127
80106a54:	6a 7f                	push   $0x7f
  jmp alltraps
80106a56:	e9 d3 f6 ff ff       	jmp    8010612e <alltraps>

80106a5b <vector128>:
.globl vector128
vector128:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $128
80106a5d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a62:	e9 c7 f6 ff ff       	jmp    8010612e <alltraps>

80106a67 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $129
80106a69:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a6e:	e9 bb f6 ff ff       	jmp    8010612e <alltraps>

80106a73 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $130
80106a75:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a7a:	e9 af f6 ff ff       	jmp    8010612e <alltraps>

80106a7f <vector131>:
.globl vector131
vector131:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $131
80106a81:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a86:	e9 a3 f6 ff ff       	jmp    8010612e <alltraps>

80106a8b <vector132>:
.globl vector132
vector132:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $132
80106a8d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a92:	e9 97 f6 ff ff       	jmp    8010612e <alltraps>

80106a97 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $133
80106a99:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a9e:	e9 8b f6 ff ff       	jmp    8010612e <alltraps>

80106aa3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $134
80106aa5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106aaa:	e9 7f f6 ff ff       	jmp    8010612e <alltraps>

80106aaf <vector135>:
.globl vector135
vector135:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $135
80106ab1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ab6:	e9 73 f6 ff ff       	jmp    8010612e <alltraps>

80106abb <vector136>:
.globl vector136
vector136:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $136
80106abd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ac2:	e9 67 f6 ff ff       	jmp    8010612e <alltraps>

80106ac7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $137
80106ac9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106ace:	e9 5b f6 ff ff       	jmp    8010612e <alltraps>

80106ad3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $138
80106ad5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ada:	e9 4f f6 ff ff       	jmp    8010612e <alltraps>

80106adf <vector139>:
.globl vector139
vector139:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $139
80106ae1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ae6:	e9 43 f6 ff ff       	jmp    8010612e <alltraps>

80106aeb <vector140>:
.globl vector140
vector140:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $140
80106aed:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106af2:	e9 37 f6 ff ff       	jmp    8010612e <alltraps>

80106af7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $141
80106af9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106afe:	e9 2b f6 ff ff       	jmp    8010612e <alltraps>

80106b03 <vector142>:
.globl vector142
vector142:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $142
80106b05:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b0a:	e9 1f f6 ff ff       	jmp    8010612e <alltraps>

80106b0f <vector143>:
.globl vector143
vector143:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $143
80106b11:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b16:	e9 13 f6 ff ff       	jmp    8010612e <alltraps>

80106b1b <vector144>:
.globl vector144
vector144:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $144
80106b1d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b22:	e9 07 f6 ff ff       	jmp    8010612e <alltraps>

80106b27 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $145
80106b29:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b2e:	e9 fb f5 ff ff       	jmp    8010612e <alltraps>

80106b33 <vector146>:
.globl vector146
vector146:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $146
80106b35:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b3a:	e9 ef f5 ff ff       	jmp    8010612e <alltraps>

80106b3f <vector147>:
.globl vector147
vector147:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $147
80106b41:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b46:	e9 e3 f5 ff ff       	jmp    8010612e <alltraps>

80106b4b <vector148>:
.globl vector148
vector148:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $148
80106b4d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b52:	e9 d7 f5 ff ff       	jmp    8010612e <alltraps>

80106b57 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $149
80106b59:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b5e:	e9 cb f5 ff ff       	jmp    8010612e <alltraps>

80106b63 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $150
80106b65:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b6a:	e9 bf f5 ff ff       	jmp    8010612e <alltraps>

80106b6f <vector151>:
.globl vector151
vector151:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $151
80106b71:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b76:	e9 b3 f5 ff ff       	jmp    8010612e <alltraps>

80106b7b <vector152>:
.globl vector152
vector152:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $152
80106b7d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b82:	e9 a7 f5 ff ff       	jmp    8010612e <alltraps>

80106b87 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $153
80106b89:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b8e:	e9 9b f5 ff ff       	jmp    8010612e <alltraps>

80106b93 <vector154>:
.globl vector154
vector154:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $154
80106b95:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b9a:	e9 8f f5 ff ff       	jmp    8010612e <alltraps>

80106b9f <vector155>:
.globl vector155
vector155:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $155
80106ba1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ba6:	e9 83 f5 ff ff       	jmp    8010612e <alltraps>

80106bab <vector156>:
.globl vector156
vector156:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $156
80106bad:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bb2:	e9 77 f5 ff ff       	jmp    8010612e <alltraps>

80106bb7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $157
80106bb9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bbe:	e9 6b f5 ff ff       	jmp    8010612e <alltraps>

80106bc3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $158
80106bc5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bca:	e9 5f f5 ff ff       	jmp    8010612e <alltraps>

80106bcf <vector159>:
.globl vector159
vector159:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $159
80106bd1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bd6:	e9 53 f5 ff ff       	jmp    8010612e <alltraps>

80106bdb <vector160>:
.globl vector160
vector160:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $160
80106bdd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106be2:	e9 47 f5 ff ff       	jmp    8010612e <alltraps>

80106be7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $161
80106be9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bee:	e9 3b f5 ff ff       	jmp    8010612e <alltraps>

80106bf3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $162
80106bf5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bfa:	e9 2f f5 ff ff       	jmp    8010612e <alltraps>

80106bff <vector163>:
.globl vector163
vector163:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $163
80106c01:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c06:	e9 23 f5 ff ff       	jmp    8010612e <alltraps>

80106c0b <vector164>:
.globl vector164
vector164:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $164
80106c0d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c12:	e9 17 f5 ff ff       	jmp    8010612e <alltraps>

80106c17 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $165
80106c19:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c1e:	e9 0b f5 ff ff       	jmp    8010612e <alltraps>

80106c23 <vector166>:
.globl vector166
vector166:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $166
80106c25:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c2a:	e9 ff f4 ff ff       	jmp    8010612e <alltraps>

80106c2f <vector167>:
.globl vector167
vector167:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $167
80106c31:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c36:	e9 f3 f4 ff ff       	jmp    8010612e <alltraps>

80106c3b <vector168>:
.globl vector168
vector168:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $168
80106c3d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c42:	e9 e7 f4 ff ff       	jmp    8010612e <alltraps>

80106c47 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $169
80106c49:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c4e:	e9 db f4 ff ff       	jmp    8010612e <alltraps>

80106c53 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $170
80106c55:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c5a:	e9 cf f4 ff ff       	jmp    8010612e <alltraps>

80106c5f <vector171>:
.globl vector171
vector171:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $171
80106c61:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c66:	e9 c3 f4 ff ff       	jmp    8010612e <alltraps>

80106c6b <vector172>:
.globl vector172
vector172:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $172
80106c6d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c72:	e9 b7 f4 ff ff       	jmp    8010612e <alltraps>

80106c77 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $173
80106c79:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c7e:	e9 ab f4 ff ff       	jmp    8010612e <alltraps>

80106c83 <vector174>:
.globl vector174
vector174:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $174
80106c85:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c8a:	e9 9f f4 ff ff       	jmp    8010612e <alltraps>

80106c8f <vector175>:
.globl vector175
vector175:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $175
80106c91:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c96:	e9 93 f4 ff ff       	jmp    8010612e <alltraps>

80106c9b <vector176>:
.globl vector176
vector176:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $176
80106c9d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ca2:	e9 87 f4 ff ff       	jmp    8010612e <alltraps>

80106ca7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $177
80106ca9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cae:	e9 7b f4 ff ff       	jmp    8010612e <alltraps>

80106cb3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $178
80106cb5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cba:	e9 6f f4 ff ff       	jmp    8010612e <alltraps>

80106cbf <vector179>:
.globl vector179
vector179:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $179
80106cc1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cc6:	e9 63 f4 ff ff       	jmp    8010612e <alltraps>

80106ccb <vector180>:
.globl vector180
vector180:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $180
80106ccd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cd2:	e9 57 f4 ff ff       	jmp    8010612e <alltraps>

80106cd7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $181
80106cd9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cde:	e9 4b f4 ff ff       	jmp    8010612e <alltraps>

80106ce3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $182
80106ce5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cea:	e9 3f f4 ff ff       	jmp    8010612e <alltraps>

80106cef <vector183>:
.globl vector183
vector183:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $183
80106cf1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106cf6:	e9 33 f4 ff ff       	jmp    8010612e <alltraps>

80106cfb <vector184>:
.globl vector184
vector184:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $184
80106cfd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d02:	e9 27 f4 ff ff       	jmp    8010612e <alltraps>

80106d07 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $185
80106d09:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d0e:	e9 1b f4 ff ff       	jmp    8010612e <alltraps>

80106d13 <vector186>:
.globl vector186
vector186:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $186
80106d15:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d1a:	e9 0f f4 ff ff       	jmp    8010612e <alltraps>

80106d1f <vector187>:
.globl vector187
vector187:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $187
80106d21:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d26:	e9 03 f4 ff ff       	jmp    8010612e <alltraps>

80106d2b <vector188>:
.globl vector188
vector188:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $188
80106d2d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d32:	e9 f7 f3 ff ff       	jmp    8010612e <alltraps>

80106d37 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $189
80106d39:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d3e:	e9 eb f3 ff ff       	jmp    8010612e <alltraps>

80106d43 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $190
80106d45:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d4a:	e9 df f3 ff ff       	jmp    8010612e <alltraps>

80106d4f <vector191>:
.globl vector191
vector191:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $191
80106d51:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d56:	e9 d3 f3 ff ff       	jmp    8010612e <alltraps>

80106d5b <vector192>:
.globl vector192
vector192:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $192
80106d5d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d62:	e9 c7 f3 ff ff       	jmp    8010612e <alltraps>

80106d67 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $193
80106d69:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d6e:	e9 bb f3 ff ff       	jmp    8010612e <alltraps>

80106d73 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $194
80106d75:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d7a:	e9 af f3 ff ff       	jmp    8010612e <alltraps>

80106d7f <vector195>:
.globl vector195
vector195:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $195
80106d81:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d86:	e9 a3 f3 ff ff       	jmp    8010612e <alltraps>

80106d8b <vector196>:
.globl vector196
vector196:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $196
80106d8d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d92:	e9 97 f3 ff ff       	jmp    8010612e <alltraps>

80106d97 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $197
80106d99:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d9e:	e9 8b f3 ff ff       	jmp    8010612e <alltraps>

80106da3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $198
80106da5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106daa:	e9 7f f3 ff ff       	jmp    8010612e <alltraps>

80106daf <vector199>:
.globl vector199
vector199:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $199
80106db1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106db6:	e9 73 f3 ff ff       	jmp    8010612e <alltraps>

80106dbb <vector200>:
.globl vector200
vector200:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $200
80106dbd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dc2:	e9 67 f3 ff ff       	jmp    8010612e <alltraps>

80106dc7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $201
80106dc9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dce:	e9 5b f3 ff ff       	jmp    8010612e <alltraps>

80106dd3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $202
80106dd5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dda:	e9 4f f3 ff ff       	jmp    8010612e <alltraps>

80106ddf <vector203>:
.globl vector203
vector203:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $203
80106de1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106de6:	e9 43 f3 ff ff       	jmp    8010612e <alltraps>

80106deb <vector204>:
.globl vector204
vector204:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $204
80106ded:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106df2:	e9 37 f3 ff ff       	jmp    8010612e <alltraps>

80106df7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $205
80106df9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dfe:	e9 2b f3 ff ff       	jmp    8010612e <alltraps>

80106e03 <vector206>:
.globl vector206
vector206:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $206
80106e05:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e0a:	e9 1f f3 ff ff       	jmp    8010612e <alltraps>

80106e0f <vector207>:
.globl vector207
vector207:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $207
80106e11:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e16:	e9 13 f3 ff ff       	jmp    8010612e <alltraps>

80106e1b <vector208>:
.globl vector208
vector208:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $208
80106e1d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e22:	e9 07 f3 ff ff       	jmp    8010612e <alltraps>

80106e27 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $209
80106e29:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e2e:	e9 fb f2 ff ff       	jmp    8010612e <alltraps>

80106e33 <vector210>:
.globl vector210
vector210:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $210
80106e35:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e3a:	e9 ef f2 ff ff       	jmp    8010612e <alltraps>

80106e3f <vector211>:
.globl vector211
vector211:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $211
80106e41:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e46:	e9 e3 f2 ff ff       	jmp    8010612e <alltraps>

80106e4b <vector212>:
.globl vector212
vector212:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $212
80106e4d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e52:	e9 d7 f2 ff ff       	jmp    8010612e <alltraps>

80106e57 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $213
80106e59:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e5e:	e9 cb f2 ff ff       	jmp    8010612e <alltraps>

80106e63 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $214
80106e65:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e6a:	e9 bf f2 ff ff       	jmp    8010612e <alltraps>

80106e6f <vector215>:
.globl vector215
vector215:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $215
80106e71:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e76:	e9 b3 f2 ff ff       	jmp    8010612e <alltraps>

80106e7b <vector216>:
.globl vector216
vector216:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $216
80106e7d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e82:	e9 a7 f2 ff ff       	jmp    8010612e <alltraps>

80106e87 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $217
80106e89:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e8e:	e9 9b f2 ff ff       	jmp    8010612e <alltraps>

80106e93 <vector218>:
.globl vector218
vector218:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $218
80106e95:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e9a:	e9 8f f2 ff ff       	jmp    8010612e <alltraps>

80106e9f <vector219>:
.globl vector219
vector219:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $219
80106ea1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ea6:	e9 83 f2 ff ff       	jmp    8010612e <alltraps>

80106eab <vector220>:
.globl vector220
vector220:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $220
80106ead:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106eb2:	e9 77 f2 ff ff       	jmp    8010612e <alltraps>

80106eb7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $221
80106eb9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ebe:	e9 6b f2 ff ff       	jmp    8010612e <alltraps>

80106ec3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $222
80106ec5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eca:	e9 5f f2 ff ff       	jmp    8010612e <alltraps>

80106ecf <vector223>:
.globl vector223
vector223:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $223
80106ed1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ed6:	e9 53 f2 ff ff       	jmp    8010612e <alltraps>

80106edb <vector224>:
.globl vector224
vector224:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $224
80106edd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ee2:	e9 47 f2 ff ff       	jmp    8010612e <alltraps>

80106ee7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $225
80106ee9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106eee:	e9 3b f2 ff ff       	jmp    8010612e <alltraps>

80106ef3 <vector226>:
.globl vector226
vector226:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $226
80106ef5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106efa:	e9 2f f2 ff ff       	jmp    8010612e <alltraps>

80106eff <vector227>:
.globl vector227
vector227:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $227
80106f01:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f06:	e9 23 f2 ff ff       	jmp    8010612e <alltraps>

80106f0b <vector228>:
.globl vector228
vector228:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $228
80106f0d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f12:	e9 17 f2 ff ff       	jmp    8010612e <alltraps>

80106f17 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $229
80106f19:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f1e:	e9 0b f2 ff ff       	jmp    8010612e <alltraps>

80106f23 <vector230>:
.globl vector230
vector230:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $230
80106f25:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f2a:	e9 ff f1 ff ff       	jmp    8010612e <alltraps>

80106f2f <vector231>:
.globl vector231
vector231:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $231
80106f31:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f36:	e9 f3 f1 ff ff       	jmp    8010612e <alltraps>

80106f3b <vector232>:
.globl vector232
vector232:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $232
80106f3d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f42:	e9 e7 f1 ff ff       	jmp    8010612e <alltraps>

80106f47 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $233
80106f49:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f4e:	e9 db f1 ff ff       	jmp    8010612e <alltraps>

80106f53 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $234
80106f55:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f5a:	e9 cf f1 ff ff       	jmp    8010612e <alltraps>

80106f5f <vector235>:
.globl vector235
vector235:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $235
80106f61:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f66:	e9 c3 f1 ff ff       	jmp    8010612e <alltraps>

80106f6b <vector236>:
.globl vector236
vector236:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $236
80106f6d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f72:	e9 b7 f1 ff ff       	jmp    8010612e <alltraps>

80106f77 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $237
80106f79:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f7e:	e9 ab f1 ff ff       	jmp    8010612e <alltraps>

80106f83 <vector238>:
.globl vector238
vector238:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $238
80106f85:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f8a:	e9 9f f1 ff ff       	jmp    8010612e <alltraps>

80106f8f <vector239>:
.globl vector239
vector239:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $239
80106f91:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f96:	e9 93 f1 ff ff       	jmp    8010612e <alltraps>

80106f9b <vector240>:
.globl vector240
vector240:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $240
80106f9d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fa2:	e9 87 f1 ff ff       	jmp    8010612e <alltraps>

80106fa7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $241
80106fa9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fae:	e9 7b f1 ff ff       	jmp    8010612e <alltraps>

80106fb3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $242
80106fb5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fba:	e9 6f f1 ff ff       	jmp    8010612e <alltraps>

80106fbf <vector243>:
.globl vector243
vector243:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $243
80106fc1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fc6:	e9 63 f1 ff ff       	jmp    8010612e <alltraps>

80106fcb <vector244>:
.globl vector244
vector244:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $244
80106fcd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fd2:	e9 57 f1 ff ff       	jmp    8010612e <alltraps>

80106fd7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $245
80106fd9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fde:	e9 4b f1 ff ff       	jmp    8010612e <alltraps>

80106fe3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $246
80106fe5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fea:	e9 3f f1 ff ff       	jmp    8010612e <alltraps>

80106fef <vector247>:
.globl vector247
vector247:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $247
80106ff1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ff6:	e9 33 f1 ff ff       	jmp    8010612e <alltraps>

80106ffb <vector248>:
.globl vector248
vector248:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $248
80106ffd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107002:	e9 27 f1 ff ff       	jmp    8010612e <alltraps>

80107007 <vector249>:
.globl vector249
vector249:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $249
80107009:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010700e:	e9 1b f1 ff ff       	jmp    8010612e <alltraps>

80107013 <vector250>:
.globl vector250
vector250:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $250
80107015:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010701a:	e9 0f f1 ff ff       	jmp    8010612e <alltraps>

8010701f <vector251>:
.globl vector251
vector251:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $251
80107021:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107026:	e9 03 f1 ff ff       	jmp    8010612e <alltraps>

8010702b <vector252>:
.globl vector252
vector252:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $252
8010702d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107032:	e9 f7 f0 ff ff       	jmp    8010612e <alltraps>

80107037 <vector253>:
.globl vector253
vector253:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $253
80107039:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010703e:	e9 eb f0 ff ff       	jmp    8010612e <alltraps>

80107043 <vector254>:
.globl vector254
vector254:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $254
80107045:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010704a:	e9 df f0 ff ff       	jmp    8010612e <alltraps>

8010704f <vector255>:
.globl vector255
vector255:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $255
80107051:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107056:	e9 d3 f0 ff ff       	jmp    8010612e <alltraps>
8010705b:	66 90                	xchg   %ax,%ax
8010705d:	66 90                	xchg   %ax,%ax
8010705f:	90                   	nop

80107060 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107067:	c1 ea 16             	shr    $0x16,%edx
{
8010706a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010706b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010706e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107071:	8b 1f                	mov    (%edi),%ebx
80107073:	f6 c3 01             	test   $0x1,%bl
80107076:	74 28                	je     801070a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107078:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010707e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107084:	89 f0                	mov    %esi,%eax
}
80107086:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107089:	c1 e8 0a             	shr    $0xa,%eax
8010708c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107091:	01 d8                	add    %ebx,%eax
}
80107093:	5b                   	pop    %ebx
80107094:	5e                   	pop    %esi
80107095:	5f                   	pop    %edi
80107096:	5d                   	pop    %ebp
80107097:	c3                   	ret    
80107098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070a0:	85 c9                	test   %ecx,%ecx
801070a2:	74 2c                	je     801070d0 <walkpgdir+0x70>
801070a4:	e8 47 be ff ff       	call   80102ef0 <kalloc>
801070a9:	89 c3                	mov    %eax,%ebx
801070ab:	85 c0                	test   %eax,%eax
801070ad:	74 21                	je     801070d0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801070af:	83 ec 04             	sub    $0x4,%esp
801070b2:	68 00 10 00 00       	push   $0x1000
801070b7:	6a 00                	push   $0x0
801070b9:	50                   	push   %eax
801070ba:	e8 71 de ff ff       	call   80104f30 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070c5:	83 c4 10             	add    $0x10,%esp
801070c8:	83 c8 07             	or     $0x7,%eax
801070cb:	89 07                	mov    %eax,(%edi)
801070cd:	eb b5                	jmp    80107084 <walkpgdir+0x24>
801070cf:	90                   	nop
}
801070d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801070d3:	31 c0                	xor    %eax,%eax
}
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070e6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801070ea:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801070f0:	89 d6                	mov    %edx,%esi
{
801070f2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801070f3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801070f9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107102:	29 f0                	sub    %esi,%eax
80107104:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107107:	eb 1f                	jmp    80107128 <mappages+0x48>
80107109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107110:	f6 00 01             	testb  $0x1,(%eax)
80107113:	75 45                	jne    8010715a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107115:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107118:	83 cb 01             	or     $0x1,%ebx
8010711b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010711d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107120:	74 2e                	je     80107150 <mappages+0x70>
      break;
    a += PGSIZE;
80107122:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010712b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107130:	89 f2                	mov    %esi,%edx
80107132:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107135:	89 f8                	mov    %edi,%eax
80107137:	e8 24 ff ff ff       	call   80107060 <walkpgdir>
8010713c:	85 c0                	test   %eax,%eax
8010713e:	75 d0                	jne    80107110 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107140:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107143:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107148:	5b                   	pop    %ebx
80107149:	5e                   	pop    %esi
8010714a:	5f                   	pop    %edi
8010714b:	5d                   	pop    %ebp
8010714c:	c3                   	ret    
8010714d:	8d 76 00             	lea    0x0(%esi),%esi
80107150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107153:	31 c0                	xor    %eax,%eax
}
80107155:	5b                   	pop    %ebx
80107156:	5e                   	pop    %esi
80107157:	5f                   	pop    %edi
80107158:	5d                   	pop    %ebp
80107159:	c3                   	ret    
      panic("remap");
8010715a:	83 ec 0c             	sub    $0xc,%esp
8010715d:	68 c8 82 10 80       	push   $0x801082c8
80107162:	e8 29 92 ff ff       	call   80100390 <panic>
80107167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010716e:	66 90                	xchg   %ax,%ax

80107170 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	89 c6                	mov    %eax,%esi
80107177:	53                   	push   %ebx
80107178:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010717a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107180:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107186:	83 ec 1c             	sub    $0x1c,%esp
80107189:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010718c:	39 da                	cmp    %ebx,%edx
8010718e:	73 5b                	jae    801071eb <deallocuvm.part.0+0x7b>
80107190:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107193:	89 d7                	mov    %edx,%edi
80107195:	eb 14                	jmp    801071ab <deallocuvm.part.0+0x3b>
80107197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010719e:	66 90                	xchg   %ax,%ax
801071a0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071a6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801071a9:	76 40                	jbe    801071eb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071ab:	31 c9                	xor    %ecx,%ecx
801071ad:	89 fa                	mov    %edi,%edx
801071af:	89 f0                	mov    %esi,%eax
801071b1:	e8 aa fe ff ff       	call   80107060 <walkpgdir>
801071b6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801071b8:	85 c0                	test   %eax,%eax
801071ba:	74 44                	je     80107200 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801071bc:	8b 00                	mov    (%eax),%eax
801071be:	a8 01                	test   $0x1,%al
801071c0:	74 de                	je     801071a0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801071c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071c7:	74 47                	je     80107210 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801071c9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801071cc:	05 00 00 00 80       	add    $0x80000000,%eax
801071d1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801071d7:	50                   	push   %eax
801071d8:	e8 53 bb ff ff       	call   80102d30 <kfree>
      *pte = 0;
801071dd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801071e3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801071e6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801071e9:	77 c0                	ja     801071ab <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801071eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f1:	5b                   	pop    %ebx
801071f2:	5e                   	pop    %esi
801071f3:	5f                   	pop    %edi
801071f4:	5d                   	pop    %ebp
801071f5:	c3                   	ret    
801071f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071fd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107200:	89 fa                	mov    %edi,%edx
80107202:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107208:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010720e:	eb 96                	jmp    801071a6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107210:	83 ec 0c             	sub    $0xc,%esp
80107213:	68 82 7c 10 80       	push   $0x80107c82
80107218:	e8 73 91 ff ff       	call   80100390 <panic>
8010721d:	8d 76 00             	lea    0x0(%esi),%esi

80107220 <seginit>:
{
80107220:	f3 0f 1e fb          	endbr32 
80107224:	55                   	push   %ebp
80107225:	89 e5                	mov    %esp,%ebp
80107227:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010722a:	e8 d1 cf ff ff       	call   80104200 <cpuid>
  pd[0] = size-1;
8010722f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107234:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010723a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010723e:	c7 80 b8 3d 11 80 ff 	movl   $0xffff,-0x7feec248(%eax)
80107245:	ff 00 00 
80107248:	c7 80 bc 3d 11 80 00 	movl   $0xcf9a00,-0x7feec244(%eax)
8010724f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107252:	c7 80 c0 3d 11 80 ff 	movl   $0xffff,-0x7feec240(%eax)
80107259:	ff 00 00 
8010725c:	c7 80 c4 3d 11 80 00 	movl   $0xcf9200,-0x7feec23c(%eax)
80107263:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107266:	c7 80 c8 3d 11 80 ff 	movl   $0xffff,-0x7feec238(%eax)
8010726d:	ff 00 00 
80107270:	c7 80 cc 3d 11 80 00 	movl   $0xcffa00,-0x7feec234(%eax)
80107277:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010727a:	c7 80 d0 3d 11 80 ff 	movl   $0xffff,-0x7feec230(%eax)
80107281:	ff 00 00 
80107284:	c7 80 d4 3d 11 80 00 	movl   $0xcff200,-0x7feec22c(%eax)
8010728b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010728e:	05 b0 3d 11 80       	add    $0x80113db0,%eax
  pd[1] = (uint)p;
80107293:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107297:	c1 e8 10             	shr    $0x10,%eax
8010729a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010729e:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072a1:	0f 01 10             	lgdtl  (%eax)
}
801072a4:	c9                   	leave  
801072a5:	c3                   	ret    
801072a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ad:	8d 76 00             	lea    0x0(%esi),%esi

801072b0 <switchkvm>:
{
801072b0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072b4:	a1 64 6a 11 80       	mov    0x80116a64,%eax
801072b9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072be:	0f 22 d8             	mov    %eax,%cr3
}
801072c1:	c3                   	ret    
801072c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072d0 <switchuvm>:
{
801072d0:	f3 0f 1e fb          	endbr32 
801072d4:	55                   	push   %ebp
801072d5:	89 e5                	mov    %esp,%ebp
801072d7:	57                   	push   %edi
801072d8:	56                   	push   %esi
801072d9:	53                   	push   %ebx
801072da:	83 ec 1c             	sub    $0x1c,%esp
801072dd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801072e0:	85 f6                	test   %esi,%esi
801072e2:	0f 84 cb 00 00 00    	je     801073b3 <switchuvm+0xe3>
  if(p->kstack == 0)
801072e8:	8b 46 08             	mov    0x8(%esi),%eax
801072eb:	85 c0                	test   %eax,%eax
801072ed:	0f 84 da 00 00 00    	je     801073cd <switchuvm+0xfd>
  if(p->pgdir == 0)
801072f3:	8b 46 04             	mov    0x4(%esi),%eax
801072f6:	85 c0                	test   %eax,%eax
801072f8:	0f 84 c2 00 00 00    	je     801073c0 <switchuvm+0xf0>
  pushcli();
801072fe:	e8 1d da ff ff       	call   80104d20 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107303:	e8 88 ce ff ff       	call   80104190 <mycpu>
80107308:	89 c3                	mov    %eax,%ebx
8010730a:	e8 81 ce ff ff       	call   80104190 <mycpu>
8010730f:	89 c7                	mov    %eax,%edi
80107311:	e8 7a ce ff ff       	call   80104190 <mycpu>
80107316:	83 c7 08             	add    $0x8,%edi
80107319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010731c:	e8 6f ce ff ff       	call   80104190 <mycpu>
80107321:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107324:	ba 67 00 00 00       	mov    $0x67,%edx
80107329:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107330:	83 c0 08             	add    $0x8,%eax
80107333:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010733a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010733f:	83 c1 08             	add    $0x8,%ecx
80107342:	c1 e8 18             	shr    $0x18,%eax
80107345:	c1 e9 10             	shr    $0x10,%ecx
80107348:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010734e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107354:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107359:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107360:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107365:	e8 26 ce ff ff       	call   80104190 <mycpu>
8010736a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107371:	e8 1a ce ff ff       	call   80104190 <mycpu>
80107376:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010737a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010737d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107383:	e8 08 ce ff ff       	call   80104190 <mycpu>
80107388:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010738b:	e8 00 ce ff ff       	call   80104190 <mycpu>
80107390:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107394:	b8 28 00 00 00       	mov    $0x28,%eax
80107399:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010739c:	8b 46 04             	mov    0x4(%esi),%eax
8010739f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073a4:	0f 22 d8             	mov    %eax,%cr3
}
801073a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073aa:	5b                   	pop    %ebx
801073ab:	5e                   	pop    %esi
801073ac:	5f                   	pop    %edi
801073ad:	5d                   	pop    %ebp
  popcli();
801073ae:	e9 bd d9 ff ff       	jmp    80104d70 <popcli>
    panic("switchuvm: no process");
801073b3:	83 ec 0c             	sub    $0xc,%esp
801073b6:	68 ce 82 10 80       	push   $0x801082ce
801073bb:	e8 d0 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801073c0:	83 ec 0c             	sub    $0xc,%esp
801073c3:	68 f9 82 10 80       	push   $0x801082f9
801073c8:	e8 c3 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801073cd:	83 ec 0c             	sub    $0xc,%esp
801073d0:	68 e4 82 10 80       	push   $0x801082e4
801073d5:	e8 b6 8f ff ff       	call   80100390 <panic>
801073da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073e0 <inituvm>:
{
801073e0:	f3 0f 1e fb          	endbr32 
801073e4:	55                   	push   %ebp
801073e5:	89 e5                	mov    %esp,%ebp
801073e7:	57                   	push   %edi
801073e8:	56                   	push   %esi
801073e9:	53                   	push   %ebx
801073ea:	83 ec 1c             	sub    $0x1c,%esp
801073ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f0:	8b 75 10             	mov    0x10(%ebp),%esi
801073f3:	8b 7d 08             	mov    0x8(%ebp),%edi
801073f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801073f9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073ff:	77 4b                	ja     8010744c <inituvm+0x6c>
  mem = kalloc();
80107401:	e8 ea ba ff ff       	call   80102ef0 <kalloc>
  memset(mem, 0, PGSIZE);
80107406:	83 ec 04             	sub    $0x4,%esp
80107409:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010740e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107410:	6a 00                	push   $0x0
80107412:	50                   	push   %eax
80107413:	e8 18 db ff ff       	call   80104f30 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107418:	58                   	pop    %eax
80107419:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010741f:	5a                   	pop    %edx
80107420:	6a 06                	push   $0x6
80107422:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107427:	31 d2                	xor    %edx,%edx
80107429:	50                   	push   %eax
8010742a:	89 f8                	mov    %edi,%eax
8010742c:	e8 af fc ff ff       	call   801070e0 <mappages>
  memmove(mem, init, sz);
80107431:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107434:	89 75 10             	mov    %esi,0x10(%ebp)
80107437:	83 c4 10             	add    $0x10,%esp
8010743a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010743d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107440:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107443:	5b                   	pop    %ebx
80107444:	5e                   	pop    %esi
80107445:	5f                   	pop    %edi
80107446:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107447:	e9 84 db ff ff       	jmp    80104fd0 <memmove>
    panic("inituvm: more than a page");
8010744c:	83 ec 0c             	sub    $0xc,%esp
8010744f:	68 0d 83 10 80       	push   $0x8010830d
80107454:	e8 37 8f ff ff       	call   80100390 <panic>
80107459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107460 <loaduvm>:
{
80107460:	f3 0f 1e fb          	endbr32 
80107464:	55                   	push   %ebp
80107465:	89 e5                	mov    %esp,%ebp
80107467:	57                   	push   %edi
80107468:	56                   	push   %esi
80107469:	53                   	push   %ebx
8010746a:	83 ec 1c             	sub    $0x1c,%esp
8010746d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107470:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107473:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107478:	0f 85 99 00 00 00    	jne    80107517 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010747e:	01 f0                	add    %esi,%eax
80107480:	89 f3                	mov    %esi,%ebx
80107482:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107485:	8b 45 14             	mov    0x14(%ebp),%eax
80107488:	01 f0                	add    %esi,%eax
8010748a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010748d:	85 f6                	test   %esi,%esi
8010748f:	75 15                	jne    801074a6 <loaduvm+0x46>
80107491:	eb 6d                	jmp    80107500 <loaduvm+0xa0>
80107493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107497:	90                   	nop
80107498:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010749e:	89 f0                	mov    %esi,%eax
801074a0:	29 d8                	sub    %ebx,%eax
801074a2:	39 c6                	cmp    %eax,%esi
801074a4:	76 5a                	jbe    80107500 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074a9:	8b 45 08             	mov    0x8(%ebp),%eax
801074ac:	31 c9                	xor    %ecx,%ecx
801074ae:	29 da                	sub    %ebx,%edx
801074b0:	e8 ab fb ff ff       	call   80107060 <walkpgdir>
801074b5:	85 c0                	test   %eax,%eax
801074b7:	74 51                	je     8010750a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801074b9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801074be:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801074c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801074c8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801074ce:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074d1:	29 d9                	sub    %ebx,%ecx
801074d3:	05 00 00 00 80       	add    $0x80000000,%eax
801074d8:	57                   	push   %edi
801074d9:	51                   	push   %ecx
801074da:	50                   	push   %eax
801074db:	ff 75 10             	pushl  0x10(%ebp)
801074de:	e8 3d ae ff ff       	call   80102320 <readi>
801074e3:	83 c4 10             	add    $0x10,%esp
801074e6:	39 f8                	cmp    %edi,%eax
801074e8:	74 ae                	je     80107498 <loaduvm+0x38>
}
801074ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074f2:	5b                   	pop    %ebx
801074f3:	5e                   	pop    %esi
801074f4:	5f                   	pop    %edi
801074f5:	5d                   	pop    %ebp
801074f6:	c3                   	ret    
801074f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074fe:	66 90                	xchg   %ax,%ax
80107500:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107503:	31 c0                	xor    %eax,%eax
}
80107505:	5b                   	pop    %ebx
80107506:	5e                   	pop    %esi
80107507:	5f                   	pop    %edi
80107508:	5d                   	pop    %ebp
80107509:	c3                   	ret    
      panic("loaduvm: address should exist");
8010750a:	83 ec 0c             	sub    $0xc,%esp
8010750d:	68 27 83 10 80       	push   $0x80108327
80107512:	e8 79 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107517:	83 ec 0c             	sub    $0xc,%esp
8010751a:	68 c8 83 10 80       	push   $0x801083c8
8010751f:	e8 6c 8e ff ff       	call   80100390 <panic>
80107524:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010752f:	90                   	nop

80107530 <allocuvm>:
{
80107530:	f3 0f 1e fb          	endbr32 
80107534:	55                   	push   %ebp
80107535:	89 e5                	mov    %esp,%ebp
80107537:	57                   	push   %edi
80107538:	56                   	push   %esi
80107539:	53                   	push   %ebx
8010753a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010753d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107540:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107546:	85 c0                	test   %eax,%eax
80107548:	0f 88 b2 00 00 00    	js     80107600 <allocuvm+0xd0>
  if(newsz < oldsz)
8010754e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107551:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107554:	0f 82 96 00 00 00    	jb     801075f0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010755a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107560:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107566:	39 75 10             	cmp    %esi,0x10(%ebp)
80107569:	77 40                	ja     801075ab <allocuvm+0x7b>
8010756b:	e9 83 00 00 00       	jmp    801075f3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107570:	83 ec 04             	sub    $0x4,%esp
80107573:	68 00 10 00 00       	push   $0x1000
80107578:	6a 00                	push   $0x0
8010757a:	50                   	push   %eax
8010757b:	e8 b0 d9 ff ff       	call   80104f30 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107580:	58                   	pop    %eax
80107581:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107587:	5a                   	pop    %edx
80107588:	6a 06                	push   $0x6
8010758a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010758f:	89 f2                	mov    %esi,%edx
80107591:	50                   	push   %eax
80107592:	89 f8                	mov    %edi,%eax
80107594:	e8 47 fb ff ff       	call   801070e0 <mappages>
80107599:	83 c4 10             	add    $0x10,%esp
8010759c:	85 c0                	test   %eax,%eax
8010759e:	78 78                	js     80107618 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801075a0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075a9:	76 48                	jbe    801075f3 <allocuvm+0xc3>
    mem = kalloc();
801075ab:	e8 40 b9 ff ff       	call   80102ef0 <kalloc>
801075b0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801075b2:	85 c0                	test   %eax,%eax
801075b4:	75 ba                	jne    80107570 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801075b6:	83 ec 0c             	sub    $0xc,%esp
801075b9:	68 45 83 10 80       	push   $0x80108345
801075be:	e8 8d 93 ff ff       	call   80100950 <cprintf>
  if(newsz >= oldsz)
801075c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801075c6:	83 c4 10             	add    $0x10,%esp
801075c9:	39 45 10             	cmp    %eax,0x10(%ebp)
801075cc:	74 32                	je     80107600 <allocuvm+0xd0>
801075ce:	8b 55 10             	mov    0x10(%ebp),%edx
801075d1:	89 c1                	mov    %eax,%ecx
801075d3:	89 f8                	mov    %edi,%eax
801075d5:	e8 96 fb ff ff       	call   80107170 <deallocuvm.part.0>
      return 0;
801075da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075e7:	5b                   	pop    %ebx
801075e8:	5e                   	pop    %esi
801075e9:	5f                   	pop    %edi
801075ea:	5d                   	pop    %ebp
801075eb:	c3                   	ret    
801075ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801075f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801075f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075f9:	5b                   	pop    %ebx
801075fa:	5e                   	pop    %esi
801075fb:	5f                   	pop    %edi
801075fc:	5d                   	pop    %ebp
801075fd:	c3                   	ret    
801075fe:	66 90                	xchg   %ax,%ax
    return 0;
80107600:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010760a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010760d:	5b                   	pop    %ebx
8010760e:	5e                   	pop    %esi
8010760f:	5f                   	pop    %edi
80107610:	5d                   	pop    %ebp
80107611:	c3                   	ret    
80107612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107618:	83 ec 0c             	sub    $0xc,%esp
8010761b:	68 5d 83 10 80       	push   $0x8010835d
80107620:	e8 2b 93 ff ff       	call   80100950 <cprintf>
  if(newsz >= oldsz)
80107625:	8b 45 0c             	mov    0xc(%ebp),%eax
80107628:	83 c4 10             	add    $0x10,%esp
8010762b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010762e:	74 0c                	je     8010763c <allocuvm+0x10c>
80107630:	8b 55 10             	mov    0x10(%ebp),%edx
80107633:	89 c1                	mov    %eax,%ecx
80107635:	89 f8                	mov    %edi,%eax
80107637:	e8 34 fb ff ff       	call   80107170 <deallocuvm.part.0>
      kfree(mem);
8010763c:	83 ec 0c             	sub    $0xc,%esp
8010763f:	53                   	push   %ebx
80107640:	e8 eb b6 ff ff       	call   80102d30 <kfree>
      return 0;
80107645:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010764c:	83 c4 10             	add    $0x10,%esp
}
8010764f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107652:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107655:	5b                   	pop    %ebx
80107656:	5e                   	pop    %esi
80107657:	5f                   	pop    %edi
80107658:	5d                   	pop    %ebp
80107659:	c3                   	ret    
8010765a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107660 <deallocuvm>:
{
80107660:	f3 0f 1e fb          	endbr32 
80107664:	55                   	push   %ebp
80107665:	89 e5                	mov    %esp,%ebp
80107667:	8b 55 0c             	mov    0xc(%ebp),%edx
8010766a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010766d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107670:	39 d1                	cmp    %edx,%ecx
80107672:	73 0c                	jae    80107680 <deallocuvm+0x20>
}
80107674:	5d                   	pop    %ebp
80107675:	e9 f6 fa ff ff       	jmp    80107170 <deallocuvm.part.0>
8010767a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107680:	89 d0                	mov    %edx,%eax
80107682:	5d                   	pop    %ebp
80107683:	c3                   	ret    
80107684:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010768f:	90                   	nop

80107690 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107690:	f3 0f 1e fb          	endbr32 
80107694:	55                   	push   %ebp
80107695:	89 e5                	mov    %esp,%ebp
80107697:	57                   	push   %edi
80107698:	56                   	push   %esi
80107699:	53                   	push   %ebx
8010769a:	83 ec 0c             	sub    $0xc,%esp
8010769d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076a0:	85 f6                	test   %esi,%esi
801076a2:	74 55                	je     801076f9 <freevm+0x69>
  if(newsz >= oldsz)
801076a4:	31 c9                	xor    %ecx,%ecx
801076a6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076ab:	89 f0                	mov    %esi,%eax
801076ad:	89 f3                	mov    %esi,%ebx
801076af:	e8 bc fa ff ff       	call   80107170 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076b4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076ba:	eb 0b                	jmp    801076c7 <freevm+0x37>
801076bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076c0:	83 c3 04             	add    $0x4,%ebx
801076c3:	39 df                	cmp    %ebx,%edi
801076c5:	74 23                	je     801076ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076c7:	8b 03                	mov    (%ebx),%eax
801076c9:	a8 01                	test   $0x1,%al
801076cb:	74 f3                	je     801076c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076d2:	83 ec 0c             	sub    $0xc,%esp
801076d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076dd:	50                   	push   %eax
801076de:	e8 4d b6 ff ff       	call   80102d30 <kfree>
801076e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076e6:	39 df                	cmp    %ebx,%edi
801076e8:	75 dd                	jne    801076c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801076ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801076ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076f0:	5b                   	pop    %ebx
801076f1:	5e                   	pop    %esi
801076f2:	5f                   	pop    %edi
801076f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801076f4:	e9 37 b6 ff ff       	jmp    80102d30 <kfree>
    panic("freevm: no pgdir");
801076f9:	83 ec 0c             	sub    $0xc,%esp
801076fc:	68 79 83 10 80       	push   $0x80108379
80107701:	e8 8a 8c ff ff       	call   80100390 <panic>
80107706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770d:	8d 76 00             	lea    0x0(%esi),%esi

80107710 <setupkvm>:
{
80107710:	f3 0f 1e fb          	endbr32 
80107714:	55                   	push   %ebp
80107715:	89 e5                	mov    %esp,%ebp
80107717:	56                   	push   %esi
80107718:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107719:	e8 d2 b7 ff ff       	call   80102ef0 <kalloc>
8010771e:	89 c6                	mov    %eax,%esi
80107720:	85 c0                	test   %eax,%eax
80107722:	74 42                	je     80107766 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107724:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107727:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010772c:	68 00 10 00 00       	push   $0x1000
80107731:	6a 00                	push   $0x0
80107733:	50                   	push   %eax
80107734:	e8 f7 d7 ff ff       	call   80104f30 <memset>
80107739:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010773c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010773f:	83 ec 08             	sub    $0x8,%esp
80107742:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107745:	ff 73 0c             	pushl  0xc(%ebx)
80107748:	8b 13                	mov    (%ebx),%edx
8010774a:	50                   	push   %eax
8010774b:	29 c1                	sub    %eax,%ecx
8010774d:	89 f0                	mov    %esi,%eax
8010774f:	e8 8c f9 ff ff       	call   801070e0 <mappages>
80107754:	83 c4 10             	add    $0x10,%esp
80107757:	85 c0                	test   %eax,%eax
80107759:	78 15                	js     80107770 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010775b:	83 c3 10             	add    $0x10,%ebx
8010775e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107764:	75 d6                	jne    8010773c <setupkvm+0x2c>
}
80107766:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107769:	89 f0                	mov    %esi,%eax
8010776b:	5b                   	pop    %ebx
8010776c:	5e                   	pop    %esi
8010776d:	5d                   	pop    %ebp
8010776e:	c3                   	ret    
8010776f:	90                   	nop
      freevm(pgdir);
80107770:	83 ec 0c             	sub    $0xc,%esp
80107773:	56                   	push   %esi
      return 0;
80107774:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107776:	e8 15 ff ff ff       	call   80107690 <freevm>
      return 0;
8010777b:	83 c4 10             	add    $0x10,%esp
}
8010777e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107781:	89 f0                	mov    %esi,%eax
80107783:	5b                   	pop    %ebx
80107784:	5e                   	pop    %esi
80107785:	5d                   	pop    %ebp
80107786:	c3                   	ret    
80107787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778e:	66 90                	xchg   %ax,%ax

80107790 <kvmalloc>:
{
80107790:	f3 0f 1e fb          	endbr32 
80107794:	55                   	push   %ebp
80107795:	89 e5                	mov    %esp,%ebp
80107797:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010779a:	e8 71 ff ff ff       	call   80107710 <setupkvm>
8010779f:	a3 64 6a 11 80       	mov    %eax,0x80116a64
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077a4:	05 00 00 00 80       	add    $0x80000000,%eax
801077a9:	0f 22 d8             	mov    %eax,%cr3
}
801077ac:	c9                   	leave  
801077ad:	c3                   	ret    
801077ae:	66 90                	xchg   %ax,%ax

801077b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077b0:	f3 0f 1e fb          	endbr32 
801077b4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077b5:	31 c9                	xor    %ecx,%ecx
{
801077b7:	89 e5                	mov    %esp,%ebp
801077b9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801077bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801077bf:	8b 45 08             	mov    0x8(%ebp),%eax
801077c2:	e8 99 f8 ff ff       	call   80107060 <walkpgdir>
  if(pte == 0)
801077c7:	85 c0                	test   %eax,%eax
801077c9:	74 05                	je     801077d0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801077cb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077ce:	c9                   	leave  
801077cf:	c3                   	ret    
    panic("clearpteu");
801077d0:	83 ec 0c             	sub    $0xc,%esp
801077d3:	68 8a 83 10 80       	push   $0x8010838a
801077d8:	e8 b3 8b ff ff       	call   80100390 <panic>
801077dd:	8d 76 00             	lea    0x0(%esi),%esi

801077e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801077e0:	f3 0f 1e fb          	endbr32 
801077e4:	55                   	push   %ebp
801077e5:	89 e5                	mov    %esp,%ebp
801077e7:	57                   	push   %edi
801077e8:	56                   	push   %esi
801077e9:	53                   	push   %ebx
801077ea:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801077ed:	e8 1e ff ff ff       	call   80107710 <setupkvm>
801077f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077f5:	85 c0                	test   %eax,%eax
801077f7:	0f 84 9b 00 00 00    	je     80107898 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107800:	85 c9                	test   %ecx,%ecx
80107802:	0f 84 90 00 00 00    	je     80107898 <copyuvm+0xb8>
80107808:	31 f6                	xor    %esi,%esi
8010780a:	eb 46                	jmp    80107852 <copyuvm+0x72>
8010780c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107810:	83 ec 04             	sub    $0x4,%esp
80107813:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107819:	68 00 10 00 00       	push   $0x1000
8010781e:	57                   	push   %edi
8010781f:	50                   	push   %eax
80107820:	e8 ab d7 ff ff       	call   80104fd0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107825:	58                   	pop    %eax
80107826:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010782c:	5a                   	pop    %edx
8010782d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107830:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107835:	89 f2                	mov    %esi,%edx
80107837:	50                   	push   %eax
80107838:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010783b:	e8 a0 f8 ff ff       	call   801070e0 <mappages>
80107840:	83 c4 10             	add    $0x10,%esp
80107843:	85 c0                	test   %eax,%eax
80107845:	78 61                	js     801078a8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107847:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010784d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107850:	76 46                	jbe    80107898 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107852:	8b 45 08             	mov    0x8(%ebp),%eax
80107855:	31 c9                	xor    %ecx,%ecx
80107857:	89 f2                	mov    %esi,%edx
80107859:	e8 02 f8 ff ff       	call   80107060 <walkpgdir>
8010785e:	85 c0                	test   %eax,%eax
80107860:	74 61                	je     801078c3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107862:	8b 00                	mov    (%eax),%eax
80107864:	a8 01                	test   $0x1,%al
80107866:	74 4e                	je     801078b6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107868:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010786a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010786f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107872:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107878:	e8 73 b6 ff ff       	call   80102ef0 <kalloc>
8010787d:	89 c3                	mov    %eax,%ebx
8010787f:	85 c0                	test   %eax,%eax
80107881:	75 8d                	jne    80107810 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107883:	83 ec 0c             	sub    $0xc,%esp
80107886:	ff 75 e0             	pushl  -0x20(%ebp)
80107889:	e8 02 fe ff ff       	call   80107690 <freevm>
  return 0;
8010788e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107895:	83 c4 10             	add    $0x10,%esp
}
80107898:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010789b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010789e:	5b                   	pop    %ebx
8010789f:	5e                   	pop    %esi
801078a0:	5f                   	pop    %edi
801078a1:	5d                   	pop    %ebp
801078a2:	c3                   	ret    
801078a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078a7:	90                   	nop
      kfree(mem);
801078a8:	83 ec 0c             	sub    $0xc,%esp
801078ab:	53                   	push   %ebx
801078ac:	e8 7f b4 ff ff       	call   80102d30 <kfree>
      goto bad;
801078b1:	83 c4 10             	add    $0x10,%esp
801078b4:	eb cd                	jmp    80107883 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801078b6:	83 ec 0c             	sub    $0xc,%esp
801078b9:	68 ae 83 10 80       	push   $0x801083ae
801078be:	e8 cd 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801078c3:	83 ec 0c             	sub    $0xc,%esp
801078c6:	68 94 83 10 80       	push   $0x80108394
801078cb:	e8 c0 8a ff ff       	call   80100390 <panic>

801078d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078d0:	f3 0f 1e fb          	endbr32 
801078d4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078d5:	31 c9                	xor    %ecx,%ecx
{
801078d7:	89 e5                	mov    %esp,%ebp
801078d9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801078df:	8b 45 08             	mov    0x8(%ebp),%eax
801078e2:	e8 79 f7 ff ff       	call   80107060 <walkpgdir>
  if((*pte & PTE_P) == 0)
801078e7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078e9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801078ea:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801078f1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078f4:	05 00 00 00 80       	add    $0x80000000,%eax
801078f9:	83 fa 05             	cmp    $0x5,%edx
801078fc:	ba 00 00 00 00       	mov    $0x0,%edx
80107901:	0f 45 c2             	cmovne %edx,%eax
}
80107904:	c3                   	ret    
80107905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010790c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107910 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107910:	f3 0f 1e fb          	endbr32 
80107914:	55                   	push   %ebp
80107915:	89 e5                	mov    %esp,%ebp
80107917:	57                   	push   %edi
80107918:	56                   	push   %esi
80107919:	53                   	push   %ebx
8010791a:	83 ec 0c             	sub    $0xc,%esp
8010791d:	8b 75 14             	mov    0x14(%ebp),%esi
80107920:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107923:	85 f6                	test   %esi,%esi
80107925:	75 3c                	jne    80107963 <copyout+0x53>
80107927:	eb 67                	jmp    80107990 <copyout+0x80>
80107929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107930:	8b 55 0c             	mov    0xc(%ebp),%edx
80107933:	89 fb                	mov    %edi,%ebx
80107935:	29 d3                	sub    %edx,%ebx
80107937:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010793d:	39 f3                	cmp    %esi,%ebx
8010793f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107942:	29 fa                	sub    %edi,%edx
80107944:	83 ec 04             	sub    $0x4,%esp
80107947:	01 c2                	add    %eax,%edx
80107949:	53                   	push   %ebx
8010794a:	ff 75 10             	pushl  0x10(%ebp)
8010794d:	52                   	push   %edx
8010794e:	e8 7d d6 ff ff       	call   80104fd0 <memmove>
    len -= n;
    buf += n;
80107953:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107956:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010795c:	83 c4 10             	add    $0x10,%esp
8010795f:	29 de                	sub    %ebx,%esi
80107961:	74 2d                	je     80107990 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107963:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107965:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107968:	89 55 0c             	mov    %edx,0xc(%ebp)
8010796b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107971:	57                   	push   %edi
80107972:	ff 75 08             	pushl  0x8(%ebp)
80107975:	e8 56 ff ff ff       	call   801078d0 <uva2ka>
    if(pa0 == 0)
8010797a:	83 c4 10             	add    $0x10,%esp
8010797d:	85 c0                	test   %eax,%eax
8010797f:	75 af                	jne    80107930 <copyout+0x20>
  }
  return 0;
}
80107981:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107984:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107989:	5b                   	pop    %ebx
8010798a:	5e                   	pop    %esi
8010798b:	5f                   	pop    %edi
8010798c:	5d                   	pop    %ebp
8010798d:	c3                   	ret    
8010798e:	66 90                	xchg   %ax,%ax
80107990:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107993:	31 c0                	xor    %eax,%eax
}
80107995:	5b                   	pop    %ebx
80107996:	5e                   	pop    %esi
80107997:	5f                   	pop    %edi
80107998:	5d                   	pop    %ebp
80107999:	c3                   	ret    
