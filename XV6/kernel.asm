
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
8010002d:	b8 a0 38 10 80       	mov    $0x801038a0,%eax
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
80100050:	68 40 79 10 80       	push   $0x80107940
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 e1 4b 00 00       	call   80104c40 <initlock>
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
80100092:	68 47 79 10 80       	push   $0x80107947
80100097:	50                   	push   %eax
80100098:	e8 63 4a 00 00       	call   80104b00 <initsleeplock>
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
801000e8:	e8 d3 4c 00 00       	call   80104dc0 <acquire>
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
80100162:	e8 19 4d 00 00       	call   80104e80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 49 00 00       	call   80104b40 <acquiresleep>
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
8010018c:	e8 4f 29 00 00       	call   80102ae0 <iderw>
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
801001a3:	68 4e 79 10 80       	push   $0x8010794e
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
801001c2:	e8 19 4a 00 00       	call   80104be0 <holdingsleep>
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
801001d8:	e9 03 29 00 00       	jmp    80102ae0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 79 10 80       	push   $0x8010795f
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
80100203:	e8 d8 49 00 00       	call   80104be0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 88 49 00 00       	call   80104ba0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 9c 4b 00 00       	call   80104dc0 <acquire>
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
80100270:	e9 0b 4c 00 00       	jmp    80104e80 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 79 10 80       	push   $0x80107966
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
    procdump();
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
801002a5:	e8 f6 1d 00 00       	call   801020a0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801002b1:	e8 0a 4b 00 00       	call   80104dc0 <acquire>
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
801002e5:	e8 96 44 00 00       	call   80104780 <sleep>
    while (input.r == input.w)
801002ea:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if (myproc()->killed)
801002fa:	e8 c1 3e 00 00       	call   801041c0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 40 b5 10 80       	push   $0x8010b540
8010030e:	e8 6d 4b 00 00       	call   80104e80 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 a4 1c 00 00       	call   80101fc0 <ilock>
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
80100365:	e8 16 4b 00 00       	call   80104e80 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 4d 1c 00 00       	call   80101fc0 <ilock>
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
801003ad:	e8 4e 2d 00 00       	call   80103100 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 79 10 80       	push   $0x8010796d
801003bb:	e8 90 05 00 00       	call   80100950 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 87 05 00 00       	call   80100950 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 d7 82 10 80 	movl   $0x801082d7,(%esp)
801003d0:	e8 7b 05 00 00       	call   80100950 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 7f 48 00 00       	call   80104c60 <getcallerpcs>
  for (i = 0; i < 10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 79 10 80       	push   $0x80107981
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
8010042a:	e8 11 61 00 00       	call   80106540 <uartputc>
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
80100585:	e8 b6 5f 00 00       	call   80106540 <uartputc>
    uartputc(' ');
8010058a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100591:	e8 aa 5f 00 00       	call   80106540 <uartputc>
    uartputc('\b');
80100596:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010059d:	e8 9e 5f 00 00       	call   80106540 <uartputc>
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
801005ca:	e8 a1 49 00 00       	call   80104f70 <memmove>
    memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
801005cf:	b8 80 07 00 00       	mov    $0x780,%eax
801005d4:	83 c4 0c             	add    $0xc,%esp
801005d7:	29 d8                	sub    %ebx,%eax
801005d9:	01 c0                	add    %eax,%eax
801005db:	50                   	push   %eax
801005dc:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005e3:	6a 00                	push   $0x0
801005e5:	50                   	push   %eax
801005e6:	e8 e5 48 00 00       	call   80104ed0 <memset>
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
8010082b:	68 85 79 10 80       	push   $0x80107985
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
80100869:	0f b6 92 f0 79 10 80 	movzbl -0x7fef8610(%edx),%edx
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
  //evaluate_expression(buf);
  iunlock(ip);
801008ed:	ff 75 08             	pushl  0x8(%ebp)
{
801008f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
801008f3:	e8 a8 17 00 00       	call   801020a0 <iunlock>
  acquire(&cons.lock);
801008f8:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
801008ff:	e8 bc 44 00 00       	call   80104dc0 <acquire>
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
80100937:	e8 44 45 00 00       	call   80104e80 <release>
  ilock(ip);
8010093c:	58                   	pop    %eax
8010093d:	ff 75 08             	pushl  0x8(%ebp)
80100940:	e8 7b 16 00 00       	call   80101fc0 <ilock>

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
80100a1d:	bb 98 79 10 80       	mov    $0x80107998,%ebx
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
80100a5d:	e8 5e 43 00 00       	call   80104dc0 <acquire>
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
80100ac8:	e8 b3 43 00 00       	call   80104e80 <release>
80100acd:	83 c4 10             	add    $0x10,%esp
}
80100ad0:	e9 ee fe ff ff       	jmp    801009c3 <cprintf+0x73>
    panic("null fmt");
80100ad5:	83 ec 0c             	sub    $0xc,%esp
80100ad8:	68 9f 79 10 80       	push   $0x8010799f
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
80100d87:	89 45 dc             	mov    %eax,-0x24(%ebp)
  acquire(&cons.lock);
80100d8a:	e8 31 40 00 00       	call   80104dc0 <acquire>
  while ((c = getc()) >= 0)
80100d8f:	83 c4 10             	add    $0x10,%esp
80100d92:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d95:	ff d0                	call   *%eax
80100d97:	89 c6                	mov    %eax,%esi
80100d99:	85 c0                	test   %eax,%eax
80100d9b:	0f 88 72 03 00 00    	js     80101113 <consoleintr+0x3a3>
    switch (c)
80100da1:	83 fe 7f             	cmp    $0x7f,%esi
80100da4:	0f 84 25 01 00 00    	je     80100ecf <consoleintr+0x15f>
80100daa:	7f 1b                	jg     80100dc7 <consoleintr+0x57>
80100dac:	8d 46 fa             	lea    -0x6(%esi),%eax
80100daf:	83 f8 0f             	cmp    $0xf,%eax
80100db2:	0f 87 11 02 00 00    	ja     80100fc9 <consoleintr+0x259>
80100db8:	3e ff 24 85 b0 79 10 	notrack jmp *-0x7fef8650(,%eax,4)
80100dbf:	80 
80100dc0:	bb 01 00 00 00       	mov    $0x1,%ebx
80100dc5:	eb cb                	jmp    80100d92 <consoleintr+0x22>
80100dc7:	81 fe e4 00 00 00    	cmp    $0xe4,%esi
80100dcd:	0f 84 cd 01 00 00    	je     80100fa0 <consoleintr+0x230>
80100dd3:	7e 3b                	jle    80100e10 <consoleintr+0xa0>
80100dd5:	81 fe e5 00 00 00    	cmp    $0xe5,%esi
80100ddb:	0f 85 f0 01 00 00    	jne    80100fd1 <consoleintr+0x261>
      if (input.pointer != input.e)
80100de1:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
80100de6:	3b 05 c8 0f 11 80    	cmp    0x80110fc8,%eax
80100dec:	74 a4                	je     80100d92 <consoleintr+0x22>
  if (panicked)
80100dee:	8b 3d 78 b5 10 80    	mov    0x8010b578,%edi
        input.pointer++;
80100df4:	83 c0 01             	add    $0x1,%eax
80100df7:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
  if (panicked)
80100dfc:	85 ff                	test   %edi,%edi
80100dfe:	0f 84 00 03 00 00    	je     80101104 <consoleintr+0x394>
80100e04:	fa                   	cli    
    for (;;)
80100e05:	eb fe                	jmp    80100e05 <consoleintr+0x95>
80100e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e0e:	66 90                	xchg   %ax,%ax
    switch (c)
80100e10:	81 fe e2 00 00 00    	cmp    $0xe2,%esi
80100e16:	0f 84 1c 01 00 00    	je     80100f38 <consoleintr+0x1c8>
80100e1c:	81 fe e3 00 00 00    	cmp    $0xe3,%esi
80100e22:	0f 85 a9 01 00 00    	jne    80100fd1 <consoleintr+0x261>
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
80100e55:	8b 0d 6c 15 11 80    	mov    0x8011156c,%ecx
80100e5b:	85 c9                	test   %ecx,%ecx
80100e5d:	0f 85 45 03 00 00    	jne    801011a8 <consoleintr+0x438>
            cmd_buffer.movement--;
80100e63:	89 15 70 15 11 80    	mov    %edx,0x80111570
            cmd_buffer.pointer = 1;
80100e69:	c7 05 68 15 11 80 01 	movl   $0x1,0x80111568
80100e70:	00 00 00 
  if (panicked)
80100e73:	85 f6                	test   %esi,%esi
80100e75:	0f 84 7a 02 00 00    	je     801010f5 <consoleintr+0x385>
80100e7b:	fa                   	cli    
    for (;;)
80100e7c:	eb fe                	jmp    80100e7c <consoleintr+0x10c>
  if (panicked)
80100e7e:	a1 78 b5 10 80       	mov    0x8010b578,%eax
80100e83:	85 c0                	test   %eax,%eax
80100e85:	0f 84 10 02 00 00    	je     8010109b <consoleintr+0x32b>
80100e8b:	fa                   	cli    
    for (;;)
80100e8c:	eb fe                	jmp    80100e8c <consoleintr+0x11c>
      capture_start = input.e; 
80100e8e:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
      capturing = 1;
80100e93:	c7 05 24 b5 10 80 01 	movl   $0x1,0x8010b524
80100e9a:	00 00 00 
      capture_start = input.e; 
80100e9d:	a3 20 b5 10 80       	mov    %eax,0x8010b520
      break;
80100ea2:	e9 eb fe ff ff       	jmp    80100d92 <consoleintr+0x22>
      capturing = 0;
80100ea7:	c7 05 24 b5 10 80 00 	movl   $0x0,0x8010b524
80100eae:	00 00 00 
      for (int i = capture_start; i < input.e; i++) {
80100eb1:	8b 35 20 b5 10 80    	mov    0x8010b520,%esi
80100eb7:	3b 35 c8 0f 11 80    	cmp    0x80110fc8,%esi
80100ebd:	0f 83 cf fe ff ff    	jae    80100d92 <consoleintr+0x22>
  if (panicked)
80100ec3:	a1 78 b5 10 80       	mov    0x8010b578,%eax
80100ec8:	85 c0                	test   %eax,%eax
80100eca:	74 3c                	je     80100f08 <consoleintr+0x198>
80100ecc:	fa                   	cli    
    for (;;)
80100ecd:	eb fe                	jmp    80100ecd <consoleintr+0x15d>
      if (input.pointer != input.w)
80100ecf:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
80100ed4:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100eda:	0f 84 b2 fe ff ff    	je     80100d92 <consoleintr+0x22>
        if (input.e != input.pointer)
80100ee0:	8b 0d 78 b5 10 80    	mov    0x8010b578,%ecx
80100ee6:	8b 35 c8 0f 11 80    	mov    0x80110fc8,%esi
80100eec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100eef:	39 f0                	cmp    %esi,%eax
80100ef1:	0f 85 68 02 00 00    	jne    8010115f <consoleintr+0x3ef>
  if (panicked)
80100ef7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100efa:	85 c0                	test   %eax,%eax
80100efc:	0f 84 40 02 00 00    	je     80101142 <consoleintr+0x3d2>
80100f02:	fa                   	cli    
    for (;;)
80100f03:	eb fe                	jmp    80100f03 <consoleintr+0x193>
80100f05:	8d 76 00             	lea    0x0(%esi),%esi
          consputc(input.buf[i % INPUT_BUF]);
80100f08:	89 f2                	mov    %esi,%edx
80100f0a:	c1 fa 1f             	sar    $0x1f,%edx
80100f0d:	c1 ea 19             	shr    $0x19,%edx
80100f10:	8d 04 16             	lea    (%esi,%edx,1),%eax
      for (int i = capture_start; i < input.e; i++) {
80100f13:	83 c6 01             	add    $0x1,%esi
          consputc(input.buf[i % INPUT_BUF]);
80100f16:	83 e0 7f             	and    $0x7f,%eax
80100f19:	29 d0                	sub    %edx,%eax
80100f1b:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
80100f22:	e8 e9 f4 ff ff       	call   80100410 <consputc.part.0>
      for (int i = capture_start; i < input.e; i++) {
80100f27:	39 35 c8 0f 11 80    	cmp    %esi,0x80110fc8
80100f2d:	77 94                	ja     80100ec3 <consoleintr+0x153>
80100f2f:	e9 5e fe ff ff       	jmp    80100d92 <consoleintr+0x22>
80100f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (CAN_ARROW_UP && cmd_buffer.s > 0)
80100f38:	a1 6c 15 11 80       	mov    0x8011156c,%eax
80100f3d:	8b 35 70 15 11 80    	mov    0x80111570,%esi
80100f43:	85 c0                	test   %eax,%eax
80100f45:	0f 84 47 fe ff ff    	je     80100d92 <consoleintr+0x22>
80100f4b:	39 c6                	cmp    %eax,%esi
80100f4d:	0f 83 3f fe ff ff    	jae    80100d92 <consoleintr+0x22>
        input.e = input.w;
80100f53:	a1 c4 0f 11 80       	mov    0x80110fc4,%eax
        if (cmd_buffer.pointer == 0)
80100f58:	8b 0d 68 15 11 80    	mov    0x80111568,%ecx
        input.e = input.w;
80100f5e:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        input.pointer = input.w;
80100f63:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
        if (cmd_buffer.pointer == 0)
80100f68:	b8 09 00 00 00       	mov    $0x9,%eax
80100f6d:	85 c9                	test   %ecx,%ecx
80100f6f:	0f 85 a4 02 00 00    	jne    80101219 <consoleintr+0x4a9>
        cmd_buffer.movement++;
80100f75:	83 c6 01             	add    $0x1,%esi
        cmd_buffer.pointer %= CMD_BUF_SIZE;
80100f78:	a3 68 15 11 80       	mov    %eax,0x80111568
        cmd_buffer.movement++;
80100f7d:	89 35 70 15 11 80    	mov    %esi,0x80111570
        loadCommand();
80100f83:	e8 68 fd ff ff       	call   80100cf0 <loadCommand>
  if (panicked)
80100f88:	8b 35 78 b5 10 80    	mov    0x8010b578,%esi
80100f8e:	85 f6                	test   %esi,%esi
80100f90:	0f 84 74 02 00 00    	je     8010120a <consoleintr+0x49a>
80100f96:	fa                   	cli    
    for (;;)
80100f97:	eb fe                	jmp    80100f97 <consoleintr+0x227>
80100f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (input.pointer != input.w)
80100fa0:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
80100fa5:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100fab:	0f 84 e1 fd ff ff    	je     80100d92 <consoleintr+0x22>
        input.pointer--;
80100fb1:	83 e8 01             	sub    $0x1,%eax
80100fb4:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
  if (panicked)
80100fb9:	a1 78 b5 10 80       	mov    0x8010b578,%eax
80100fbe:	85 c0                	test   %eax,%eax
80100fc0:	0f 84 6d 01 00 00    	je     80101133 <consoleintr+0x3c3>
80100fc6:	fa                   	cli    
    for (;;)
80100fc7:	eb fe                	jmp    80100fc7 <consoleintr+0x257>
      if (c != 0 && input.e - input.r < INPUT_BUF)
80100fc9:	85 f6                	test   %esi,%esi
80100fcb:	0f 84 c1 fd ff ff    	je     80100d92 <consoleintr+0x22>
80100fd1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100fd6:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
80100fdc:	89 c1                	mov    %eax,%ecx
80100fde:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100fe1:	29 d1                	sub    %edx,%ecx
80100fe3:	83 f9 7f             	cmp    $0x7f,%ecx
80100fe6:	0f 87 a6 fd ff ff    	ja     80100d92 <consoleintr+0x22>
        c = (c == '\r') ? END_OF_LINE : c;
80100fec:	83 fe 0d             	cmp    $0xd,%esi
80100fef:	0f 84 75 02 00 00    	je     8010126a <consoleintr+0x4fa>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
80100ff5:	83 fe 0a             	cmp    $0xa,%esi
80100ff8:	0f 94 c1             	sete   %cl
80100ffb:	83 fe 04             	cmp    $0x4,%esi
80100ffe:	89 cf                	mov    %ecx,%edi
80101000:	0f 94 c1             	sete   %cl
80101003:	89 fa                	mov    %edi,%edx
80101005:	08 ca                	or     %cl,%dl
80101007:	88 55 e4             	mov    %dl,-0x1c(%ebp)
8010100a:	0f 85 63 02 00 00    	jne    80101273 <consoleintr+0x503>
80101010:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101013:	83 ea 80             	sub    $0xffffff80,%edx
80101016:	39 d0                	cmp    %edx,%eax
80101018:	0f 84 55 02 00 00    	je     80101273 <consoleintr+0x503>
        if (input.e != input.pointer)
8010101e:	8b 3d cc 0f 11 80    	mov    0x80110fcc,%edi
80101024:	89 c2                	mov    %eax,%edx
80101026:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101029:	39 c7                	cmp    %eax,%edi
8010102b:	0f 85 88 00 00 00    	jne    801010b9 <consoleintr+0x349>
        input.buf[input.pointer++ % INPUT_BUF] = c;
80101031:	8d 48 01             	lea    0x1(%eax),%ecx
80101034:	83 e0 7f             	and    $0x7f,%eax
        input.e++;
80101037:	83 c2 01             	add    $0x1,%edx
        input.buf[input.pointer++ % INPUT_BUF] = c;
8010103a:	89 0d cc 0f 11 80    	mov    %ecx,0x80110fcc
80101040:	89 f1                	mov    %esi,%ecx
80101042:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
  if (panicked)
80101048:	a1 78 b5 10 80       	mov    0x8010b578,%eax
        input.e++;
8010104d:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
  if (panicked)
80101053:	85 c0                	test   %eax,%eax
80101055:	0f 85 dd 01 00 00    	jne    80101238 <consoleintr+0x4c8>
8010105b:	89 f0                	mov    %esi,%eax
8010105d:	e8 ae f3 ff ff       	call   80100410 <consputc.part.0>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
80101062:	80 7d e4 00          	cmpb   $0x0,-0x1c(%ebp)
80101066:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010106b:	75 14                	jne    80101081 <consoleintr+0x311>
8010106d:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
80101072:	83 e8 80             	sub    $0xffffff80,%eax
80101075:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
8010107b:	0f 85 11 fd ff ff    	jne    80100d92 <consoleintr+0x22>
          wakeup(&input.r);
80101081:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80101084:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80101089:	68 c0 0f 11 80       	push   $0x80110fc0
8010108e:	e8 ad 38 00 00       	call   80104940 <wakeup>
80101093:	83 c4 10             	add    $0x10,%esp
80101096:	e9 f7 fc ff ff       	jmp    80100d92 <consoleintr+0x22>
8010109b:	b8 05 01 00 00       	mov    $0x105,%eax
801010a0:	e8 6b f3 ff ff       	call   80100410 <consputc.part.0>
      input.pointer = input.e = input.w;
801010a5:	a1 c4 0f 11 80       	mov    0x80110fc4,%eax
801010aa:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
801010af:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
      break;
801010b4:	e9 d9 fc ff ff       	jmp    80100d92 <consoleintr+0x22>
  for (int i = input.e; i > input.pointer; i--)
801010b9:	0f 83 81 01 00 00    	jae    80101240 <consoleintr+0x4d0>
    input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
801010bf:	89 c2                	mov    %eax,%edx
801010c1:	83 e8 01             	sub    $0x1,%eax
801010c4:	89 c7                	mov    %eax,%edi
801010c6:	c1 ff 1f             	sar    $0x1f,%edi
801010c9:	c1 ef 19             	shr    $0x19,%edi
801010cc:	8d 0c 38             	lea    (%eax,%edi,1),%ecx
801010cf:	83 e1 7f             	and    $0x7f,%ecx
801010d2:	29 f9                	sub    %edi,%ecx
801010d4:	89 d7                	mov    %edx,%edi
801010d6:	c1 ff 1f             	sar    $0x1f,%edi
801010d9:	0f b6 89 40 0f 11 80 	movzbl -0x7feef0c0(%ecx),%ecx
801010e0:	c1 ef 19             	shr    $0x19,%edi
801010e3:	01 fa                	add    %edi,%edx
801010e5:	83 e2 7f             	and    $0x7f,%edx
801010e8:	29 fa                	sub    %edi,%edx
  for (int i = input.e; i > input.pointer; i--)
801010ea:	39 45 e0             	cmp    %eax,-0x20(%ebp)
    input.buf[i % INPUT_BUF] = input.buf[(i - 1) % INPUT_BUF];
801010ed:	88 8a 40 0f 11 80    	mov    %cl,-0x7feef0c0(%edx)
  for (int i = input.e; i > input.pointer; i--)
801010f3:	eb c4                	jmp    801010b9 <consoleintr+0x349>
801010f5:	b8 05 01 00 00       	mov    $0x105,%eax
801010fa:	e8 11 f3 ff ff       	call   80100410 <consputc.part.0>
801010ff:	e9 8e fc ff ff       	jmp    80100d92 <consoleintr+0x22>
80101104:	b8 04 01 00 00       	mov    $0x104,%eax
80101109:	e8 02 f3 ff ff       	call   80100410 <consputc.part.0>
8010110e:	e9 7f fc ff ff       	jmp    80100d92 <consoleintr+0x22>
  release(&cons.lock);
80101113:	83 ec 0c             	sub    $0xc,%esp
80101116:	68 40 b5 10 80       	push   $0x8010b540
8010111b:	e8 60 3d 00 00       	call   80104e80 <release>
  if (doprocdump)
80101120:	83 c4 10             	add    $0x10,%esp
80101123:	85 db                	test   %ebx,%ebx
80101125:	0f 85 d3 00 00 00    	jne    801011fe <consoleintr+0x48e>
}
8010112b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010112e:	5b                   	pop    %ebx
8010112f:	5e                   	pop    %esi
80101130:	5f                   	pop    %edi
80101131:	5d                   	pop    %ebp
80101132:	c3                   	ret    
80101133:	b8 01 01 00 00       	mov    $0x101,%eax
80101138:	e8 d3 f2 ff ff       	call   80100410 <consputc.part.0>
8010113d:	e9 50 fc ff ff       	jmp    80100d92 <consoleintr+0x22>
80101142:	b8 00 01 00 00       	mov    $0x100,%eax
80101147:	e8 c4 f2 ff ff       	call   80100410 <consputc.part.0>
        input.e--;
8010114c:	83 2d c8 0f 11 80 01 	subl   $0x1,0x80110fc8
        input.pointer--;
80101153:	83 2d cc 0f 11 80 01 	subl   $0x1,0x80110fcc
8010115a:	e9 33 fc ff ff       	jmp    80100d92 <consoleintr+0x22>
  for (int i = input.pointer - 1; i < input.e; i++)
8010115f:	83 e8 01             	sub    $0x1,%eax
80101162:	39 c6                	cmp    %eax,%esi
80101164:	76 35                	jbe    8010119b <consoleintr+0x42b>
    input.buf[i % INPUT_BUF] = input.buf[(i + 1) % INPUT_BUF];
80101166:	89 c2                	mov    %eax,%edx
80101168:	83 c0 01             	add    $0x1,%eax
8010116b:	89 c7                	mov    %eax,%edi
8010116d:	c1 ff 1f             	sar    $0x1f,%edi
80101170:	c1 ef 19             	shr    $0x19,%edi
80101173:	8d 0c 38             	lea    (%eax,%edi,1),%ecx
80101176:	83 e1 7f             	and    $0x7f,%ecx
80101179:	29 f9                	sub    %edi,%ecx
8010117b:	89 d7                	mov    %edx,%edi
8010117d:	c1 ff 1f             	sar    $0x1f,%edi
80101180:	0f b6 89 40 0f 11 80 	movzbl -0x7feef0c0(%ecx),%ecx
80101187:	c1 ef 19             	shr    $0x19,%edi
8010118a:	01 fa                	add    %edi,%edx
8010118c:	83 e2 7f             	and    $0x7f,%edx
8010118f:	29 fa                	sub    %edi,%edx
80101191:	88 8a 40 0f 11 80    	mov    %cl,-0x7feef0c0(%edx)
  for (int i = input.pointer - 1; i < input.e; i++)
80101197:	39 f0                	cmp    %esi,%eax
80101199:	75 cb                	jne    80101166 <consoleintr+0x3f6>
  if (panicked)
8010119b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010119e:	85 c0                	test   %eax,%eax
801011a0:	74 4d                	je     801011ef <consoleintr+0x47f>
801011a2:	fa                   	cli    
    for (;;)
801011a3:	eb fe                	jmp    801011a3 <consoleintr+0x433>
801011a5:	8d 76 00             	lea    0x0(%esi),%esi
          cmd_buffer.pointer++;
801011a8:	a1 68 15 11 80       	mov    0x80111568,%eax
          cmd_buffer.movement--;
801011ad:	89 15 70 15 11 80    	mov    %edx,0x80111570
          cmd_buffer.pointer %= CMD_BUF_SIZE;
801011b3:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
          cmd_buffer.pointer++;
801011b8:	8d 48 01             	lea    0x1(%eax),%ecx
          cmd_buffer.pointer %= CMD_BUF_SIZE;
801011bb:	89 c8                	mov    %ecx,%eax
801011bd:	f7 e2                	mul    %edx
801011bf:	89 d0                	mov    %edx,%eax
801011c1:	c1 e8 03             	shr    $0x3,%eax
801011c4:	8d 04 80             	lea    (%eax,%eax,4),%eax
801011c7:	01 c0                	add    %eax,%eax
801011c9:	29 c1                	sub    %eax,%ecx
801011cb:	89 0d 68 15 11 80    	mov    %ecx,0x80111568
          loadCommand();
801011d1:	e8 1a fb ff ff       	call   80100cf0 <loadCommand>
  if (panicked)
801011d6:	85 f6                	test   %esi,%esi
801011d8:	74 06                	je     801011e0 <consoleintr+0x470>
801011da:	fa                   	cli    
    for (;;)
801011db:	eb fe                	jmp    801011db <consoleintr+0x46b>
801011dd:	8d 76 00             	lea    0x0(%esi),%esi
801011e0:	b8 e3 00 00 00       	mov    $0xe3,%eax
801011e5:	e8 26 f2 ff ff       	call   80100410 <consputc.part.0>
801011ea:	e9 a3 fb ff ff       	jmp    80100d92 <consoleintr+0x22>
801011ef:	b8 03 01 00 00       	mov    $0x103,%eax
801011f4:	e8 17 f2 ff ff       	call   80100410 <consputc.part.0>
801011f9:	e9 4e ff ff ff       	jmp    8010114c <consoleintr+0x3dc>
}
801011fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101201:	5b                   	pop    %ebx
80101202:	5e                   	pop    %esi
80101203:	5f                   	pop    %edi
80101204:	5d                   	pop    %ebp
    procdump();
80101205:	e9 26 38 00 00       	jmp    80104a30 <procdump>
8010120a:	b8 e2 00 00 00       	mov    $0xe2,%eax
8010120f:	e8 fc f1 ff ff       	call   80100410 <consputc.part.0>
80101214:	e9 79 fb ff ff       	jmp    80100d92 <consoleintr+0x22>
          cmd_buffer.pointer--;
80101219:	83 e9 01             	sub    $0x1,%ecx
8010121c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80101221:	89 c8                	mov    %ecx,%eax
80101223:	f7 e2                	mul    %edx
80101225:	89 d0                	mov    %edx,%eax
80101227:	c1 e8 03             	shr    $0x3,%eax
8010122a:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010122d:	01 c0                	add    %eax,%eax
8010122f:	29 c1                	sub    %eax,%ecx
80101231:	89 c8                	mov    %ecx,%eax
80101233:	e9 3d fd ff ff       	jmp    80100f75 <consoleintr+0x205>
80101238:	fa                   	cli    
    for (;;)
80101239:	eb fe                	jmp    80101239 <consoleintr+0x4c9>
8010123b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop
  if (panicked)
80101240:	8b 15 78 b5 10 80    	mov    0x8010b578,%edx
80101246:	85 d2                	test   %edx,%edx
80101248:	74 06                	je     80101250 <consoleintr+0x4e0>
8010124a:	fa                   	cli    
    for (;;)
8010124b:	eb fe                	jmp    8010124b <consoleintr+0x4db>
8010124d:	8d 76 00             	lea    0x0(%esi),%esi
80101250:	b8 02 01 00 00       	mov    $0x102,%eax
80101255:	e8 b6 f1 ff ff       	call   80100410 <consputc.part.0>
8010125a:	a1 cc 0f 11 80       	mov    0x80110fcc,%eax
8010125f:	8b 15 c8 0f 11 80    	mov    0x80110fc8,%edx
80101265:	e9 c7 fd ff ff       	jmp    80101031 <consoleintr+0x2c1>
        if (c == END_OF_LINE || c == C('D') || input.e == input.r + INPUT_BUF)
8010126a:	c6 45 e4 01          	movb   $0x1,-0x1c(%ebp)
        c = (c == '\r') ? END_OF_LINE : c;
8010126e:	be 0a 00 00 00       	mov    $0xa,%esi
          input.pointer = input.e;
80101273:	a3 cc 0f 11 80       	mov    %eax,0x80110fcc
          recordCommand();
80101278:	e8 43 f9 ff ff       	call   80100bc0 <recordCommand>
8010127d:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80101282:	e9 97 fd ff ff       	jmp    8010101e <consoleintr+0x2ae>
80101287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128e:	66 90                	xchg   %ax,%ax

80101290 <consoleinit>:

void consoleinit(void)
{
80101290:	f3 0f 1e fb          	endbr32 
80101294:	55                   	push   %ebp
80101295:	89 e5                	mov    %esp,%ebp
80101297:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
8010129a:	68 a8 79 10 80       	push   $0x801079a8
8010129f:	68 40 b5 10 80       	push   $0x8010b540
801012a4:	e8 97 39 00 00       	call   80104c40 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801012a9:	58                   	pop    %eax
801012aa:	5a                   	pop    %edx
801012ab:	6a 00                	push   $0x0
801012ad:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801012af:	c7 05 2c 1f 11 80 e0 	movl   $0x801008e0,0x80111f2c
801012b6:	08 10 80 
  devsw[CONSOLE].read = consoleread;
801012b9:	c7 05 28 1f 11 80 90 	movl   $0x80100290,0x80111f28
801012c0:	02 10 80 
  cons.locking = 1;
801012c3:	c7 05 74 b5 10 80 01 	movl   $0x1,0x8010b574
801012ca:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801012cd:	e8 be 19 00 00       	call   80102c90 <ioapicenable>
801012d2:	83 c4 10             	add    $0x10,%esp
801012d5:	c9                   	leave  
801012d6:	c3                   	ret    
801012d7:	66 90                	xchg   %ax,%ax
801012d9:	66 90                	xchg   %ax,%ax
801012db:	66 90                	xchg   %ax,%ax
801012dd:	66 90                	xchg   %ax,%ax
801012df:	90                   	nop

801012e0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801012e0:	f3 0f 1e fb          	endbr32 
801012e4:	55                   	push   %ebp
801012e5:	89 e5                	mov    %esp,%ebp
801012e7:	57                   	push   %edi
801012e8:	56                   	push   %esi
801012e9:	53                   	push   %ebx
801012ea:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801012f0:	e8 cb 2e 00 00       	call   801041c0 <myproc>
801012f5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801012fb:	e8 90 22 00 00       	call   80103590 <begin_op>

  if((ip = namei(path)) == 0){
80101300:	83 ec 0c             	sub    $0xc,%esp
80101303:	ff 75 08             	pushl  0x8(%ebp)
80101306:	e8 85 15 00 00       	call   80102890 <namei>
8010130b:	83 c4 10             	add    $0x10,%esp
8010130e:	85 c0                	test   %eax,%eax
80101310:	0f 84 fe 02 00 00    	je     80101614 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80101316:	83 ec 0c             	sub    $0xc,%esp
80101319:	89 c3                	mov    %eax,%ebx
8010131b:	50                   	push   %eax
8010131c:	e8 9f 0c 00 00       	call   80101fc0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80101321:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80101327:	6a 34                	push   $0x34
80101329:	6a 00                	push   $0x0
8010132b:	50                   	push   %eax
8010132c:	53                   	push   %ebx
8010132d:	e8 8e 0f 00 00       	call   801022c0 <readi>
80101332:	83 c4 20             	add    $0x20,%esp
80101335:	83 f8 34             	cmp    $0x34,%eax
80101338:	74 26                	je     80101360 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
8010133a:	83 ec 0c             	sub    $0xc,%esp
8010133d:	53                   	push   %ebx
8010133e:	e8 1d 0f 00 00       	call   80102260 <iunlockput>
    end_op();
80101343:	e8 b8 22 00 00       	call   80103600 <end_op>
80101348:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010134b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101350:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101353:	5b                   	pop    %ebx
80101354:	5e                   	pop    %esi
80101355:	5f                   	pop    %edi
80101356:	5d                   	pop    %ebp
80101357:	c3                   	ret    
80101358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80101360:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101367:	45 4c 46 
8010136a:	75 ce                	jne    8010133a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
8010136c:	e8 3f 63 00 00       	call   801076b0 <setupkvm>
80101371:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101377:	85 c0                	test   %eax,%eax
80101379:	74 bf                	je     8010133a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010137b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101382:	00 
80101383:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101389:	0f 84 a4 02 00 00    	je     80101633 <exec+0x353>
  sz = 0;
8010138f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101396:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101399:	31 ff                	xor    %edi,%edi
8010139b:	e9 86 00 00 00       	jmp    80101426 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
801013a0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801013a7:	75 6c                	jne    80101415 <exec+0x135>
    if(ph.memsz < ph.filesz)
801013a9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801013af:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801013b5:	0f 82 87 00 00 00    	jb     80101442 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801013bb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801013c1:	72 7f                	jb     80101442 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801013c3:	83 ec 04             	sub    $0x4,%esp
801013c6:	50                   	push   %eax
801013c7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801013cd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801013d3:	e8 f8 60 00 00       	call   801074d0 <allocuvm>
801013d8:	83 c4 10             	add    $0x10,%esp
801013db:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801013e1:	85 c0                	test   %eax,%eax
801013e3:	74 5d                	je     80101442 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
801013e5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801013eb:	a9 ff 0f 00 00       	test   $0xfff,%eax
801013f0:	75 50                	jne    80101442 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801013f2:	83 ec 0c             	sub    $0xc,%esp
801013f5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
801013fb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101401:	53                   	push   %ebx
80101402:	50                   	push   %eax
80101403:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101409:	e8 f2 5f 00 00       	call   80107400 <loaduvm>
8010140e:	83 c4 20             	add    $0x20,%esp
80101411:	85 c0                	test   %eax,%eax
80101413:	78 2d                	js     80101442 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101415:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010141c:	83 c7 01             	add    $0x1,%edi
8010141f:	83 c6 20             	add    $0x20,%esi
80101422:	39 f8                	cmp    %edi,%eax
80101424:	7e 3a                	jle    80101460 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101426:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010142c:	6a 20                	push   $0x20
8010142e:	56                   	push   %esi
8010142f:	50                   	push   %eax
80101430:	53                   	push   %ebx
80101431:	e8 8a 0e 00 00       	call   801022c0 <readi>
80101436:	83 c4 10             	add    $0x10,%esp
80101439:	83 f8 20             	cmp    $0x20,%eax
8010143c:	0f 84 5e ff ff ff    	je     801013a0 <exec+0xc0>
    freevm(pgdir);
80101442:	83 ec 0c             	sub    $0xc,%esp
80101445:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010144b:	e8 e0 61 00 00       	call   80107630 <freevm>
  if(ip){
80101450:	83 c4 10             	add    $0x10,%esp
80101453:	e9 e2 fe ff ff       	jmp    8010133a <exec+0x5a>
80101458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010145f:	90                   	nop
80101460:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80101466:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010146c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80101472:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80101478:	83 ec 0c             	sub    $0xc,%esp
8010147b:	53                   	push   %ebx
8010147c:	e8 df 0d 00 00       	call   80102260 <iunlockput>
  end_op();
80101481:	e8 7a 21 00 00       	call   80103600 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80101486:	83 c4 0c             	add    $0xc,%esp
80101489:	56                   	push   %esi
8010148a:	57                   	push   %edi
8010148b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101491:	57                   	push   %edi
80101492:	e8 39 60 00 00       	call   801074d0 <allocuvm>
80101497:	83 c4 10             	add    $0x10,%esp
8010149a:	89 c6                	mov    %eax,%esi
8010149c:	85 c0                	test   %eax,%eax
8010149e:	0f 84 94 00 00 00    	je     80101538 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801014a4:	83 ec 08             	sub    $0x8,%esp
801014a7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
801014ad:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801014af:	50                   	push   %eax
801014b0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
801014b1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
801014b3:	e8 98 62 00 00       	call   80107750 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
801014b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801014bb:	83 c4 10             	add    $0x10,%esp
801014be:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801014c4:	8b 00                	mov    (%eax),%eax
801014c6:	85 c0                	test   %eax,%eax
801014c8:	0f 84 8b 00 00 00    	je     80101559 <exec+0x279>
801014ce:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
801014d4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801014da:	eb 23                	jmp    801014ff <exec+0x21f>
801014dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801014e3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801014ea:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801014ed:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801014f3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801014f6:	85 c0                	test   %eax,%eax
801014f8:	74 59                	je     80101553 <exec+0x273>
    if(argc >= MAXARG)
801014fa:	83 ff 20             	cmp    $0x20,%edi
801014fd:	74 39                	je     80101538 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801014ff:	83 ec 0c             	sub    $0xc,%esp
80101502:	50                   	push   %eax
80101503:	e8 c8 3b 00 00       	call   801050d0 <strlen>
80101508:	f7 d0                	not    %eax
8010150a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010150c:	58                   	pop    %eax
8010150d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101510:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101513:	ff 34 b8             	pushl  (%eax,%edi,4)
80101516:	e8 b5 3b 00 00       	call   801050d0 <strlen>
8010151b:	83 c0 01             	add    $0x1,%eax
8010151e:	50                   	push   %eax
8010151f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101522:	ff 34 b8             	pushl  (%eax,%edi,4)
80101525:	53                   	push   %ebx
80101526:	56                   	push   %esi
80101527:	e8 84 63 00 00       	call   801078b0 <copyout>
8010152c:	83 c4 20             	add    $0x20,%esp
8010152f:	85 c0                	test   %eax,%eax
80101531:	79 ad                	jns    801014e0 <exec+0x200>
80101533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101537:	90                   	nop
    freevm(pgdir);
80101538:	83 ec 0c             	sub    $0xc,%esp
8010153b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101541:	e8 ea 60 00 00       	call   80107630 <freevm>
80101546:	83 c4 10             	add    $0x10,%esp
  return -1;
80101549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010154e:	e9 fd fd ff ff       	jmp    80101350 <exec+0x70>
80101553:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101559:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101560:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101562:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80101569:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010156d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
8010156f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101572:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80101578:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010157a:	50                   	push   %eax
8010157b:	52                   	push   %edx
8010157c:	53                   	push   %ebx
8010157d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101583:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010158a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010158d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101593:	e8 18 63 00 00       	call   801078b0 <copyout>
80101598:	83 c4 10             	add    $0x10,%esp
8010159b:	85 c0                	test   %eax,%eax
8010159d:	78 99                	js     80101538 <exec+0x258>
  for(last=s=path; *s; s++)
8010159f:	8b 45 08             	mov    0x8(%ebp),%eax
801015a2:	8b 55 08             	mov    0x8(%ebp),%edx
801015a5:	0f b6 00             	movzbl (%eax),%eax
801015a8:	84 c0                	test   %al,%al
801015aa:	74 13                	je     801015bf <exec+0x2df>
801015ac:	89 d1                	mov    %edx,%ecx
801015ae:	66 90                	xchg   %ax,%ax
    if(*s == '/')
801015b0:	83 c1 01             	add    $0x1,%ecx
801015b3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801015b5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
801015b8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
801015bb:	84 c0                	test   %al,%al
801015bd:	75 f1                	jne    801015b0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801015bf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
801015c5:	83 ec 04             	sub    $0x4,%esp
801015c8:	6a 10                	push   $0x10
801015ca:	89 f8                	mov    %edi,%eax
801015cc:	52                   	push   %edx
801015cd:	83 c0 6c             	add    $0x6c,%eax
801015d0:	50                   	push   %eax
801015d1:	e8 ba 3a 00 00       	call   80105090 <safestrcpy>
  curproc->pgdir = pgdir;
801015d6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
801015dc:	89 f8                	mov    %edi,%eax
801015de:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
801015e1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
801015e3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
801015e6:	89 c1                	mov    %eax,%ecx
801015e8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801015ee:	8b 40 18             	mov    0x18(%eax),%eax
801015f1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801015f4:	8b 41 18             	mov    0x18(%ecx),%eax
801015f7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801015fa:	89 0c 24             	mov    %ecx,(%esp)
801015fd:	e8 6e 5c 00 00       	call   80107270 <switchuvm>
  freevm(oldpgdir);
80101602:	89 3c 24             	mov    %edi,(%esp)
80101605:	e8 26 60 00 00       	call   80107630 <freevm>
  return 0;
8010160a:	83 c4 10             	add    $0x10,%esp
8010160d:	31 c0                	xor    %eax,%eax
8010160f:	e9 3c fd ff ff       	jmp    80101350 <exec+0x70>
    end_op();
80101614:	e8 e7 1f 00 00       	call   80103600 <end_op>
    cprintf("exec: fail\n");
80101619:	83 ec 0c             	sub    $0xc,%esp
8010161c:	68 01 7a 10 80       	push   $0x80107a01
80101621:	e8 2a f3 ff ff       	call   80100950 <cprintf>
    return -1;
80101626:	83 c4 10             	add    $0x10,%esp
80101629:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010162e:	e9 1d fd ff ff       	jmp    80101350 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101633:	31 ff                	xor    %edi,%edi
80101635:	be 00 20 00 00       	mov    $0x2000,%esi
8010163a:	e9 39 fe ff ff       	jmp    80101478 <exec+0x198>
8010163f:	90                   	nop

80101640 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101640:	f3 0f 1e fb          	endbr32 
80101644:	55                   	push   %ebp
80101645:	89 e5                	mov    %esp,%ebp
80101647:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010164a:	68 0d 7a 10 80       	push   $0x80107a0d
8010164f:	68 80 15 11 80       	push   $0x80111580
80101654:	e8 e7 35 00 00       	call   80104c40 <initlock>
}
80101659:	83 c4 10             	add    $0x10,%esp
8010165c:	c9                   	leave  
8010165d:	c3                   	ret    
8010165e:	66 90                	xchg   %ax,%ax

80101660 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101660:	f3 0f 1e fb          	endbr32 
80101664:	55                   	push   %ebp
80101665:	89 e5                	mov    %esp,%ebp
80101667:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101668:	bb b4 15 11 80       	mov    $0x801115b4,%ebx
{
8010166d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101670:	68 80 15 11 80       	push   $0x80111580
80101675:	e8 46 37 00 00       	call   80104dc0 <acquire>
8010167a:	83 c4 10             	add    $0x10,%esp
8010167d:	eb 0c                	jmp    8010168b <filealloc+0x2b>
8010167f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101680:	83 c3 18             	add    $0x18,%ebx
80101683:	81 fb 14 1f 11 80    	cmp    $0x80111f14,%ebx
80101689:	74 25                	je     801016b0 <filealloc+0x50>
    if(f->ref == 0){
8010168b:	8b 43 04             	mov    0x4(%ebx),%eax
8010168e:	85 c0                	test   %eax,%eax
80101690:	75 ee                	jne    80101680 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101692:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101695:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010169c:	68 80 15 11 80       	push   $0x80111580
801016a1:	e8 da 37 00 00       	call   80104e80 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801016a6:	89 d8                	mov    %ebx,%eax
      return f;
801016a8:	83 c4 10             	add    $0x10,%esp
}
801016ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016ae:	c9                   	leave  
801016af:	c3                   	ret    
  release(&ftable.lock);
801016b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801016b3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801016b5:	68 80 15 11 80       	push   $0x80111580
801016ba:	e8 c1 37 00 00       	call   80104e80 <release>
}
801016bf:	89 d8                	mov    %ebx,%eax
  return 0;
801016c1:	83 c4 10             	add    $0x10,%esp
}
801016c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016c7:	c9                   	leave  
801016c8:	c3                   	ret    
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801016d0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801016d0:	f3 0f 1e fb          	endbr32 
801016d4:	55                   	push   %ebp
801016d5:	89 e5                	mov    %esp,%ebp
801016d7:	53                   	push   %ebx
801016d8:	83 ec 10             	sub    $0x10,%esp
801016db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801016de:	68 80 15 11 80       	push   $0x80111580
801016e3:	e8 d8 36 00 00       	call   80104dc0 <acquire>
  if(f->ref < 1)
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	83 c4 10             	add    $0x10,%esp
801016ee:	85 c0                	test   %eax,%eax
801016f0:	7e 1a                	jle    8010170c <filedup+0x3c>
    panic("filedup");
  f->ref++;
801016f2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801016f5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801016f8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801016fb:	68 80 15 11 80       	push   $0x80111580
80101700:	e8 7b 37 00 00       	call   80104e80 <release>
  return f;
}
80101705:	89 d8                	mov    %ebx,%eax
80101707:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010170a:	c9                   	leave  
8010170b:	c3                   	ret    
    panic("filedup");
8010170c:	83 ec 0c             	sub    $0xc,%esp
8010170f:	68 14 7a 10 80       	push   $0x80107a14
80101714:	e8 77 ec ff ff       	call   80100390 <panic>
80101719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101720 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101720:	f3 0f 1e fb          	endbr32 
80101724:	55                   	push   %ebp
80101725:	89 e5                	mov    %esp,%ebp
80101727:	57                   	push   %edi
80101728:	56                   	push   %esi
80101729:	53                   	push   %ebx
8010172a:	83 ec 28             	sub    $0x28,%esp
8010172d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101730:	68 80 15 11 80       	push   $0x80111580
80101735:	e8 86 36 00 00       	call   80104dc0 <acquire>
  if(f->ref < 1)
8010173a:	8b 53 04             	mov    0x4(%ebx),%edx
8010173d:	83 c4 10             	add    $0x10,%esp
80101740:	85 d2                	test   %edx,%edx
80101742:	0f 8e a1 00 00 00    	jle    801017e9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101748:	83 ea 01             	sub    $0x1,%edx
8010174b:	89 53 04             	mov    %edx,0x4(%ebx)
8010174e:	75 40                	jne    80101790 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101750:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101754:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101757:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101759:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010175f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101762:	88 45 e7             	mov    %al,-0x19(%ebp)
80101765:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101768:	68 80 15 11 80       	push   $0x80111580
  ff = *f;
8010176d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101770:	e8 0b 37 00 00       	call   80104e80 <release>

  if(ff.type == FD_PIPE)
80101775:	83 c4 10             	add    $0x10,%esp
80101778:	83 ff 01             	cmp    $0x1,%edi
8010177b:	74 53                	je     801017d0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010177d:	83 ff 02             	cmp    $0x2,%edi
80101780:	74 26                	je     801017a8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101782:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101785:	5b                   	pop    %ebx
80101786:	5e                   	pop    %esi
80101787:	5f                   	pop    %edi
80101788:	5d                   	pop    %ebp
80101789:	c3                   	ret    
8010178a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101790:	c7 45 08 80 15 11 80 	movl   $0x80111580,0x8(%ebp)
}
80101797:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010179a:	5b                   	pop    %ebx
8010179b:	5e                   	pop    %esi
8010179c:	5f                   	pop    %edi
8010179d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010179e:	e9 dd 36 00 00       	jmp    80104e80 <release>
801017a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017a7:	90                   	nop
    begin_op();
801017a8:	e8 e3 1d 00 00       	call   80103590 <begin_op>
    iput(ff.ip);
801017ad:	83 ec 0c             	sub    $0xc,%esp
801017b0:	ff 75 e0             	pushl  -0x20(%ebp)
801017b3:	e8 38 09 00 00       	call   801020f0 <iput>
    end_op();
801017b8:	83 c4 10             	add    $0x10,%esp
}
801017bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017be:	5b                   	pop    %ebx
801017bf:	5e                   	pop    %esi
801017c0:	5f                   	pop    %edi
801017c1:	5d                   	pop    %ebp
    end_op();
801017c2:	e9 39 1e 00 00       	jmp    80103600 <end_op>
801017c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017ce:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801017d0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801017d4:	83 ec 08             	sub    $0x8,%esp
801017d7:	53                   	push   %ebx
801017d8:	56                   	push   %esi
801017d9:	e8 82 25 00 00       	call   80103d60 <pipeclose>
801017de:	83 c4 10             	add    $0x10,%esp
}
801017e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017e4:	5b                   	pop    %ebx
801017e5:	5e                   	pop    %esi
801017e6:	5f                   	pop    %edi
801017e7:	5d                   	pop    %ebp
801017e8:	c3                   	ret    
    panic("fileclose");
801017e9:	83 ec 0c             	sub    $0xc,%esp
801017ec:	68 1c 7a 10 80       	push   $0x80107a1c
801017f1:	e8 9a eb ff ff       	call   80100390 <panic>
801017f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017fd:	8d 76 00             	lea    0x0(%esi),%esi

80101800 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101800:	f3 0f 1e fb          	endbr32 
80101804:	55                   	push   %ebp
80101805:	89 e5                	mov    %esp,%ebp
80101807:	53                   	push   %ebx
80101808:	83 ec 04             	sub    $0x4,%esp
8010180b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010180e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101811:	75 2d                	jne    80101840 <filestat+0x40>
    ilock(f->ip);
80101813:	83 ec 0c             	sub    $0xc,%esp
80101816:	ff 73 10             	pushl  0x10(%ebx)
80101819:	e8 a2 07 00 00       	call   80101fc0 <ilock>
    stati(f->ip, st);
8010181e:	58                   	pop    %eax
8010181f:	5a                   	pop    %edx
80101820:	ff 75 0c             	pushl  0xc(%ebp)
80101823:	ff 73 10             	pushl  0x10(%ebx)
80101826:	e8 65 0a 00 00       	call   80102290 <stati>
    iunlock(f->ip);
8010182b:	59                   	pop    %ecx
8010182c:	ff 73 10             	pushl  0x10(%ebx)
8010182f:	e8 6c 08 00 00       	call   801020a0 <iunlock>
    return 0;
  }
  return -1;
}
80101834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101837:	83 c4 10             	add    $0x10,%esp
8010183a:	31 c0                	xor    %eax,%eax
}
8010183c:	c9                   	leave  
8010183d:	c3                   	ret    
8010183e:	66 90                	xchg   %ax,%ax
80101840:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101848:	c9                   	leave  
80101849:	c3                   	ret    
8010184a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101850 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	57                   	push   %edi
80101858:	56                   	push   %esi
80101859:	53                   	push   %ebx
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101860:	8b 75 0c             	mov    0xc(%ebp),%esi
80101863:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101866:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010186a:	74 64                	je     801018d0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010186c:	8b 03                	mov    (%ebx),%eax
8010186e:	83 f8 01             	cmp    $0x1,%eax
80101871:	74 45                	je     801018b8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101873:	83 f8 02             	cmp    $0x2,%eax
80101876:	75 5f                	jne    801018d7 <fileread+0x87>
    ilock(f->ip);
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	ff 73 10             	pushl  0x10(%ebx)
8010187e:	e8 3d 07 00 00       	call   80101fc0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101883:	57                   	push   %edi
80101884:	ff 73 14             	pushl  0x14(%ebx)
80101887:	56                   	push   %esi
80101888:	ff 73 10             	pushl  0x10(%ebx)
8010188b:	e8 30 0a 00 00       	call   801022c0 <readi>
80101890:	83 c4 20             	add    $0x20,%esp
80101893:	89 c6                	mov    %eax,%esi
80101895:	85 c0                	test   %eax,%eax
80101897:	7e 03                	jle    8010189c <fileread+0x4c>
      f->off += r;
80101899:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010189c:	83 ec 0c             	sub    $0xc,%esp
8010189f:	ff 73 10             	pushl  0x10(%ebx)
801018a2:	e8 f9 07 00 00       	call   801020a0 <iunlock>
    return r;
801018a7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801018aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ad:	89 f0                	mov    %esi,%eax
801018af:	5b                   	pop    %ebx
801018b0:	5e                   	pop    %esi
801018b1:	5f                   	pop    %edi
801018b2:	5d                   	pop    %ebp
801018b3:	c3                   	ret    
801018b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801018b8:	8b 43 0c             	mov    0xc(%ebx),%eax
801018bb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801018be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018c1:	5b                   	pop    %ebx
801018c2:	5e                   	pop    %esi
801018c3:	5f                   	pop    %edi
801018c4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801018c5:	e9 36 26 00 00       	jmp    80103f00 <piperead>
801018ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801018d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801018d5:	eb d3                	jmp    801018aa <fileread+0x5a>
  panic("fileread");
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	68 26 7a 10 80       	push   $0x80107a26
801018df:	e8 ac ea ff ff       	call   80100390 <panic>
801018e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018ef:	90                   	nop

801018f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801018f0:	f3 0f 1e fb          	endbr32 
801018f4:	55                   	push   %ebp
801018f5:	89 e5                	mov    %esp,%ebp
801018f7:	57                   	push   %edi
801018f8:	56                   	push   %esi
801018f9:	53                   	push   %ebx
801018fa:	83 ec 1c             	sub    $0x1c,%esp
801018fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101900:	8b 75 08             	mov    0x8(%ebp),%esi
80101903:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101906:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101909:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010190d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101910:	0f 84 c1 00 00 00    	je     801019d7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101916:	8b 06                	mov    (%esi),%eax
80101918:	83 f8 01             	cmp    $0x1,%eax
8010191b:	0f 84 c3 00 00 00    	je     801019e4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101921:	83 f8 02             	cmp    $0x2,%eax
80101924:	0f 85 cc 00 00 00    	jne    801019f6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010192a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010192d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010192f:	85 c0                	test   %eax,%eax
80101931:	7f 34                	jg     80101967 <filewrite+0x77>
80101933:	e9 98 00 00 00       	jmp    801019d0 <filewrite+0xe0>
80101938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010193f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101940:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101943:	83 ec 0c             	sub    $0xc,%esp
80101946:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101949:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010194c:	e8 4f 07 00 00       	call   801020a0 <iunlock>
      end_op();
80101951:	e8 aa 1c 00 00       	call   80103600 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101956:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101959:	83 c4 10             	add    $0x10,%esp
8010195c:	39 c3                	cmp    %eax,%ebx
8010195e:	75 60                	jne    801019c0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101960:	01 df                	add    %ebx,%edi
    while(i < n){
80101962:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101965:	7e 69                	jle    801019d0 <filewrite+0xe0>
      int n1 = n - i;
80101967:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010196a:	b8 00 06 00 00       	mov    $0x600,%eax
8010196f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101971:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101977:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010197a:	e8 11 1c 00 00       	call   80103590 <begin_op>
      ilock(f->ip);
8010197f:	83 ec 0c             	sub    $0xc,%esp
80101982:	ff 76 10             	pushl  0x10(%esi)
80101985:	e8 36 06 00 00       	call   80101fc0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010198a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010198d:	53                   	push   %ebx
8010198e:	ff 76 14             	pushl  0x14(%esi)
80101991:	01 f8                	add    %edi,%eax
80101993:	50                   	push   %eax
80101994:	ff 76 10             	pushl  0x10(%esi)
80101997:	e8 24 0a 00 00       	call   801023c0 <writei>
8010199c:	83 c4 20             	add    $0x20,%esp
8010199f:	85 c0                	test   %eax,%eax
801019a1:	7f 9d                	jg     80101940 <filewrite+0x50>
      iunlock(f->ip);
801019a3:	83 ec 0c             	sub    $0xc,%esp
801019a6:	ff 76 10             	pushl  0x10(%esi)
801019a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801019ac:	e8 ef 06 00 00       	call   801020a0 <iunlock>
      end_op();
801019b1:	e8 4a 1c 00 00       	call   80103600 <end_op>
      if(r < 0)
801019b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019b9:	83 c4 10             	add    $0x10,%esp
801019bc:	85 c0                	test   %eax,%eax
801019be:	75 17                	jne    801019d7 <filewrite+0xe7>
        panic("short filewrite");
801019c0:	83 ec 0c             	sub    $0xc,%esp
801019c3:	68 2f 7a 10 80       	push   $0x80107a2f
801019c8:	e8 c3 e9 ff ff       	call   80100390 <panic>
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801019d0:	89 f8                	mov    %edi,%eax
801019d2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801019d5:	74 05                	je     801019dc <filewrite+0xec>
801019d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801019dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019df:	5b                   	pop    %ebx
801019e0:	5e                   	pop    %esi
801019e1:	5f                   	pop    %edi
801019e2:	5d                   	pop    %ebp
801019e3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801019e4:	8b 46 0c             	mov    0xc(%esi),%eax
801019e7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801019ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ed:	5b                   	pop    %ebx
801019ee:	5e                   	pop    %esi
801019ef:	5f                   	pop    %edi
801019f0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801019f1:	e9 0a 24 00 00       	jmp    80103e00 <pipewrite>
  panic("filewrite");
801019f6:	83 ec 0c             	sub    $0xc,%esp
801019f9:	68 35 7a 10 80       	push   $0x80107a35
801019fe:	e8 8d e9 ff ff       	call   80100390 <panic>
80101a03:	66 90                	xchg   %ax,%ax
80101a05:	66 90                	xchg   %ax,%ax
80101a07:	66 90                	xchg   %ax,%ax
80101a09:	66 90                	xchg   %ax,%ax
80101a0b:	66 90                	xchg   %ax,%ax
80101a0d:	66 90                	xchg   %ax,%ax
80101a0f:	90                   	nop

80101a10 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101a10:	55                   	push   %ebp
80101a11:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101a13:	89 d0                	mov    %edx,%eax
80101a15:	c1 e8 0c             	shr    $0xc,%eax
80101a18:	03 05 98 1f 11 80    	add    0x80111f98,%eax
{
80101a1e:	89 e5                	mov    %esp,%ebp
80101a20:	56                   	push   %esi
80101a21:	53                   	push   %ebx
80101a22:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101a24:	83 ec 08             	sub    $0x8,%esp
80101a27:	50                   	push   %eax
80101a28:	51                   	push   %ecx
80101a29:	e8 a2 e6 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101a2e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101a30:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101a33:	ba 01 00 00 00       	mov    $0x1,%edx
80101a38:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101a3b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101a41:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101a44:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101a46:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101a4b:	85 d1                	test   %edx,%ecx
80101a4d:	74 25                	je     80101a74 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101a4f:	f7 d2                	not    %edx
  log_write(bp);
80101a51:	83 ec 0c             	sub    $0xc,%esp
80101a54:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101a56:	21 ca                	and    %ecx,%edx
80101a58:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
80101a5c:	50                   	push   %eax
80101a5d:	e8 0e 1d 00 00       	call   80103770 <log_write>
  brelse(bp);
80101a62:	89 34 24             	mov    %esi,(%esp)
80101a65:	e8 86 e7 ff ff       	call   801001f0 <brelse>
}
80101a6a:	83 c4 10             	add    $0x10,%esp
80101a6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a70:	5b                   	pop    %ebx
80101a71:	5e                   	pop    %esi
80101a72:	5d                   	pop    %ebp
80101a73:	c3                   	ret    
    panic("freeing free block");
80101a74:	83 ec 0c             	sub    $0xc,%esp
80101a77:	68 3f 7a 10 80       	push   $0x80107a3f
80101a7c:	e8 0f e9 ff ff       	call   80100390 <panic>
80101a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <balloc>:
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101a99:	8b 0d 80 1f 11 80    	mov    0x80111f80,%ecx
{
80101a9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101aa2:	85 c9                	test   %ecx,%ecx
80101aa4:	0f 84 87 00 00 00    	je     80101b31 <balloc+0xa1>
80101aaa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101ab1:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101ab4:	83 ec 08             	sub    $0x8,%esp
80101ab7:	89 f0                	mov    %esi,%eax
80101ab9:	c1 f8 0c             	sar    $0xc,%eax
80101abc:	03 05 98 1f 11 80    	add    0x80111f98,%eax
80101ac2:	50                   	push   %eax
80101ac3:	ff 75 d8             	pushl  -0x28(%ebp)
80101ac6:	e8 05 e6 ff ff       	call   801000d0 <bread>
80101acb:	83 c4 10             	add    $0x10,%esp
80101ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101ad1:	a1 80 1f 11 80       	mov    0x80111f80,%eax
80101ad6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101ad9:	31 c0                	xor    %eax,%eax
80101adb:	eb 2f                	jmp    80101b0c <balloc+0x7c>
80101add:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101ae0:	89 c1                	mov    %eax,%ecx
80101ae2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101ae7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101aea:	83 e1 07             	and    $0x7,%ecx
80101aed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101aef:	89 c1                	mov    %eax,%ecx
80101af1:	c1 f9 03             	sar    $0x3,%ecx
80101af4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101af9:	89 fa                	mov    %edi,%edx
80101afb:	85 df                	test   %ebx,%edi
80101afd:	74 41                	je     80101b40 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101aff:	83 c0 01             	add    $0x1,%eax
80101b02:	83 c6 01             	add    $0x1,%esi
80101b05:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101b0a:	74 05                	je     80101b11 <balloc+0x81>
80101b0c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101b0f:	77 cf                	ja     80101ae0 <balloc+0x50>
    brelse(bp);
80101b11:	83 ec 0c             	sub    $0xc,%esp
80101b14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b17:	e8 d4 e6 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101b1c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101b23:	83 c4 10             	add    $0x10,%esp
80101b26:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b29:	39 05 80 1f 11 80    	cmp    %eax,0x80111f80
80101b2f:	77 80                	ja     80101ab1 <balloc+0x21>
  panic("balloc: out of blocks");
80101b31:	83 ec 0c             	sub    $0xc,%esp
80101b34:	68 52 7a 10 80       	push   $0x80107a52
80101b39:	e8 52 e8 ff ff       	call   80100390 <panic>
80101b3e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101b40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101b43:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101b46:	09 da                	or     %ebx,%edx
80101b48:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101b4c:	57                   	push   %edi
80101b4d:	e8 1e 1c 00 00       	call   80103770 <log_write>
        brelse(bp);
80101b52:	89 3c 24             	mov    %edi,(%esp)
80101b55:	e8 96 e6 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101b5a:	58                   	pop    %eax
80101b5b:	5a                   	pop    %edx
80101b5c:	56                   	push   %esi
80101b5d:	ff 75 d8             	pushl  -0x28(%ebp)
80101b60:	e8 6b e5 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101b65:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101b68:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101b6a:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b6d:	68 00 02 00 00       	push   $0x200
80101b72:	6a 00                	push   $0x0
80101b74:	50                   	push   %eax
80101b75:	e8 56 33 00 00       	call   80104ed0 <memset>
  log_write(bp);
80101b7a:	89 1c 24             	mov    %ebx,(%esp)
80101b7d:	e8 ee 1b 00 00       	call   80103770 <log_write>
  brelse(bp);
80101b82:	89 1c 24             	mov    %ebx,(%esp)
80101b85:	e8 66 e6 ff ff       	call   801001f0 <brelse>
}
80101b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8d:	89 f0                	mov    %esi,%eax
80101b8f:	5b                   	pop    %ebx
80101b90:	5e                   	pop    %esi
80101b91:	5f                   	pop    %edi
80101b92:	5d                   	pop    %ebp
80101b93:	c3                   	ret    
80101b94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	89 c7                	mov    %eax,%edi
80101ba6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101ba7:	31 f6                	xor    %esi,%esi
{
80101ba9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101baa:	bb d4 1f 11 80       	mov    $0x80111fd4,%ebx
{
80101baf:	83 ec 28             	sub    $0x28,%esp
80101bb2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101bb5:	68 a0 1f 11 80       	push   $0x80111fa0
80101bba:	e8 01 32 00 00       	call   80104dc0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bbf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101bc2:	83 c4 10             	add    $0x10,%esp
80101bc5:	eb 1b                	jmp    80101be2 <iget+0x42>
80101bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101bd0:	39 3b                	cmp    %edi,(%ebx)
80101bd2:	74 6c                	je     80101c40 <iget+0xa0>
80101bd4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bda:	81 fb f4 3b 11 80    	cmp    $0x80113bf4,%ebx
80101be0:	73 26                	jae    80101c08 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101be2:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101be5:	85 c9                	test   %ecx,%ecx
80101be7:	7f e7                	jg     80101bd0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101be9:	85 f6                	test   %esi,%esi
80101beb:	75 e7                	jne    80101bd4 <iget+0x34>
80101bed:	89 d8                	mov    %ebx,%eax
80101bef:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101bf5:	85 c9                	test   %ecx,%ecx
80101bf7:	75 6e                	jne    80101c67 <iget+0xc7>
80101bf9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101bfb:	81 fb f4 3b 11 80    	cmp    $0x80113bf4,%ebx
80101c01:	72 df                	jb     80101be2 <iget+0x42>
80101c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c07:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101c08:	85 f6                	test   %esi,%esi
80101c0a:	74 73                	je     80101c7f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101c0c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101c0f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101c11:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101c14:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101c1b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101c22:	68 a0 1f 11 80       	push   $0x80111fa0
80101c27:	e8 54 32 00 00       	call   80104e80 <release>

  return ip;
80101c2c:	83 c4 10             	add    $0x10,%esp
}
80101c2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c32:	89 f0                	mov    %esi,%eax
80101c34:	5b                   	pop    %ebx
80101c35:	5e                   	pop    %esi
80101c36:	5f                   	pop    %edi
80101c37:	5d                   	pop    %ebp
80101c38:	c3                   	ret    
80101c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c40:	39 53 04             	cmp    %edx,0x4(%ebx)
80101c43:	75 8f                	jne    80101bd4 <iget+0x34>
      release(&icache.lock);
80101c45:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101c48:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101c4b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101c4d:	68 a0 1f 11 80       	push   $0x80111fa0
      ip->ref++;
80101c52:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101c55:	e8 26 32 00 00       	call   80104e80 <release>
      return ip;
80101c5a:	83 c4 10             	add    $0x10,%esp
}
80101c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c60:	89 f0                	mov    %esi,%eax
80101c62:	5b                   	pop    %ebx
80101c63:	5e                   	pop    %esi
80101c64:	5f                   	pop    %edi
80101c65:	5d                   	pop    %ebp
80101c66:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101c67:	81 fb f4 3b 11 80    	cmp    $0x80113bf4,%ebx
80101c6d:	73 10                	jae    80101c7f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101c6f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101c72:	85 c9                	test   %ecx,%ecx
80101c74:	0f 8f 56 ff ff ff    	jg     80101bd0 <iget+0x30>
80101c7a:	e9 6e ff ff ff       	jmp    80101bed <iget+0x4d>
    panic("iget: no inodes");
80101c7f:	83 ec 0c             	sub    $0xc,%esp
80101c82:	68 68 7a 10 80       	push   $0x80107a68
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c90 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	89 c6                	mov    %eax,%esi
80101c97:	53                   	push   %ebx
80101c98:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c9b:	83 fa 0b             	cmp    $0xb,%edx
80101c9e:	0f 86 84 00 00 00    	jbe    80101d28 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101ca4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101ca7:	83 fb 7f             	cmp    $0x7f,%ebx
80101caa:	0f 87 98 00 00 00    	ja     80101d48 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cb0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cb6:	8b 16                	mov    (%esi),%edx
80101cb8:	85 c0                	test   %eax,%eax
80101cba:	74 54                	je     80101d10 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101cbc:	83 ec 08             	sub    $0x8,%esp
80101cbf:	50                   	push   %eax
80101cc0:	52                   	push   %edx
80101cc1:	e8 0a e4 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101cc6:	83 c4 10             	add    $0x10,%esp
80101cc9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
80101ccd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101ccf:	8b 1a                	mov    (%edx),%ebx
80101cd1:	85 db                	test   %ebx,%ebx
80101cd3:	74 1b                	je     80101cf0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101cd5:	83 ec 0c             	sub    $0xc,%esp
80101cd8:	57                   	push   %edi
80101cd9:	e8 12 e5 ff ff       	call   801001f0 <brelse>
    return addr;
80101cde:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce4:	89 d8                	mov    %ebx,%eax
80101ce6:	5b                   	pop    %ebx
80101ce7:	5e                   	pop    %esi
80101ce8:	5f                   	pop    %edi
80101ce9:	5d                   	pop    %ebp
80101cea:	c3                   	ret    
80101ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cef:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101cf0:	8b 06                	mov    (%esi),%eax
80101cf2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf5:	e8 96 fd ff ff       	call   80101a90 <balloc>
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101cfd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101d00:	89 c3                	mov    %eax,%ebx
80101d02:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d04:	57                   	push   %edi
80101d05:	e8 66 1a 00 00       	call   80103770 <log_write>
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	eb c6                	jmp    80101cd5 <bmap+0x45>
80101d0f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d10:	89 d0                	mov    %edx,%eax
80101d12:	e8 79 fd ff ff       	call   80101a90 <balloc>
80101d17:	8b 16                	mov    (%esi),%edx
80101d19:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101d1f:	eb 9b                	jmp    80101cbc <bmap+0x2c>
80101d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101d28:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101d2b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101d2e:	85 db                	test   %ebx,%ebx
80101d30:	75 af                	jne    80101ce1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d32:	8b 00                	mov    (%eax),%eax
80101d34:	e8 57 fd ff ff       	call   80101a90 <balloc>
80101d39:	89 47 5c             	mov    %eax,0x5c(%edi)
80101d3c:	89 c3                	mov    %eax,%ebx
}
80101d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d41:	89 d8                	mov    %ebx,%eax
80101d43:	5b                   	pop    %ebx
80101d44:	5e                   	pop    %esi
80101d45:	5f                   	pop    %edi
80101d46:	5d                   	pop    %ebp
80101d47:	c3                   	ret    
  panic("bmap: out of range");
80101d48:	83 ec 0c             	sub    $0xc,%esp
80101d4b:	68 78 7a 10 80       	push   $0x80107a78
80101d50:	e8 3b e6 ff ff       	call   80100390 <panic>
80101d55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d60 <readsb>:
{
80101d60:	f3 0f 1e fb          	endbr32 
80101d64:	55                   	push   %ebp
80101d65:	89 e5                	mov    %esp,%ebp
80101d67:	56                   	push   %esi
80101d68:	53                   	push   %ebx
80101d69:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101d6c:	83 ec 08             	sub    $0x8,%esp
80101d6f:	6a 01                	push   $0x1
80101d71:	ff 75 08             	pushl  0x8(%ebp)
80101d74:	e8 57 e3 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101d79:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101d7c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101d7e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101d81:	6a 1c                	push   $0x1c
80101d83:	50                   	push   %eax
80101d84:	56                   	push   %esi
80101d85:	e8 e6 31 00 00       	call   80104f70 <memmove>
  brelse(bp);
80101d8a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d8d:	83 c4 10             	add    $0x10,%esp
}
80101d90:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d93:	5b                   	pop    %ebx
80101d94:	5e                   	pop    %esi
80101d95:	5d                   	pop    %ebp
  brelse(bp);
80101d96:	e9 55 e4 ff ff       	jmp    801001f0 <brelse>
80101d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d9f:	90                   	nop

80101da0 <iinit>:
{
80101da0:	f3 0f 1e fb          	endbr32 
80101da4:	55                   	push   %ebp
80101da5:	89 e5                	mov    %esp,%ebp
80101da7:	53                   	push   %ebx
80101da8:	bb e0 1f 11 80       	mov    $0x80111fe0,%ebx
80101dad:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101db0:	68 8b 7a 10 80       	push   $0x80107a8b
80101db5:	68 a0 1f 11 80       	push   $0x80111fa0
80101dba:	e8 81 2e 00 00       	call   80104c40 <initlock>
  for(i = 0; i < NINODE; i++) {
80101dbf:	83 c4 10             	add    $0x10,%esp
80101dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101dc8:	83 ec 08             	sub    $0x8,%esp
80101dcb:	68 92 7a 10 80       	push   $0x80107a92
80101dd0:	53                   	push   %ebx
80101dd1:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101dd7:	e8 24 2d 00 00       	call   80104b00 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101ddc:	83 c4 10             	add    $0x10,%esp
80101ddf:	81 fb 00 3c 11 80    	cmp    $0x80113c00,%ebx
80101de5:	75 e1                	jne    80101dc8 <iinit+0x28>
  readsb(dev, &sb);
80101de7:	83 ec 08             	sub    $0x8,%esp
80101dea:	68 80 1f 11 80       	push   $0x80111f80
80101def:	ff 75 08             	pushl  0x8(%ebp)
80101df2:	e8 69 ff ff ff       	call   80101d60 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101df7:	ff 35 98 1f 11 80    	pushl  0x80111f98
80101dfd:	ff 35 94 1f 11 80    	pushl  0x80111f94
80101e03:	ff 35 90 1f 11 80    	pushl  0x80111f90
80101e09:	ff 35 8c 1f 11 80    	pushl  0x80111f8c
80101e0f:	ff 35 88 1f 11 80    	pushl  0x80111f88
80101e15:	ff 35 84 1f 11 80    	pushl  0x80111f84
80101e1b:	ff 35 80 1f 11 80    	pushl  0x80111f80
80101e21:	68 f8 7a 10 80       	push   $0x80107af8
80101e26:	e8 25 eb ff ff       	call   80100950 <cprintf>
}
80101e2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e2e:	83 c4 30             	add    $0x30,%esp
80101e31:	c9                   	leave  
80101e32:	c3                   	ret    
80101e33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101e40 <ialloc>:
{
80101e40:	f3 0f 1e fb          	endbr32 
80101e44:	55                   	push   %ebp
80101e45:	89 e5                	mov    %esp,%ebp
80101e47:	57                   	push   %edi
80101e48:	56                   	push   %esi
80101e49:	53                   	push   %ebx
80101e4a:	83 ec 1c             	sub    $0x1c,%esp
80101e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101e50:	83 3d 88 1f 11 80 01 	cmpl   $0x1,0x80111f88
{
80101e57:	8b 75 08             	mov    0x8(%ebp),%esi
80101e5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101e5d:	0f 86 8d 00 00 00    	jbe    80101ef0 <ialloc+0xb0>
80101e63:	bf 01 00 00 00       	mov    $0x1,%edi
80101e68:	eb 1d                	jmp    80101e87 <ialloc+0x47>
80101e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101e70:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101e73:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101e76:	53                   	push   %ebx
80101e77:	e8 74 e3 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101e7c:	83 c4 10             	add    $0x10,%esp
80101e7f:	3b 3d 88 1f 11 80    	cmp    0x80111f88,%edi
80101e85:	73 69                	jae    80101ef0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101e87:	89 f8                	mov    %edi,%eax
80101e89:	83 ec 08             	sub    $0x8,%esp
80101e8c:	c1 e8 03             	shr    $0x3,%eax
80101e8f:	03 05 94 1f 11 80    	add    0x80111f94,%eax
80101e95:	50                   	push   %eax
80101e96:	56                   	push   %esi
80101e97:	e8 34 e2 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101e9c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101e9f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101ea1:	89 f8                	mov    %edi,%eax
80101ea3:	83 e0 07             	and    $0x7,%eax
80101ea6:	c1 e0 06             	shl    $0x6,%eax
80101ea9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101ead:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101eb1:	75 bd                	jne    80101e70 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101eb3:	83 ec 04             	sub    $0x4,%esp
80101eb6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101eb9:	6a 40                	push   $0x40
80101ebb:	6a 00                	push   $0x0
80101ebd:	51                   	push   %ecx
80101ebe:	e8 0d 30 00 00       	call   80104ed0 <memset>
      dip->type = type;
80101ec3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101ec7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101ecd:	89 1c 24             	mov    %ebx,(%esp)
80101ed0:	e8 9b 18 00 00       	call   80103770 <log_write>
      brelse(bp);
80101ed5:	89 1c 24             	mov    %ebx,(%esp)
80101ed8:	e8 13 e3 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101edd:	83 c4 10             	add    $0x10,%esp
}
80101ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101ee3:	89 fa                	mov    %edi,%edx
}
80101ee5:	5b                   	pop    %ebx
      return iget(dev, inum);
80101ee6:	89 f0                	mov    %esi,%eax
}
80101ee8:	5e                   	pop    %esi
80101ee9:	5f                   	pop    %edi
80101eea:	5d                   	pop    %ebp
      return iget(dev, inum);
80101eeb:	e9 b0 fc ff ff       	jmp    80101ba0 <iget>
  panic("ialloc: no inodes");
80101ef0:	83 ec 0c             	sub    $0xc,%esp
80101ef3:	68 98 7a 10 80       	push   $0x80107a98
80101ef8:	e8 93 e4 ff ff       	call   80100390 <panic>
80101efd:	8d 76 00             	lea    0x0(%esi),%esi

80101f00 <iupdate>:
{
80101f00:	f3 0f 1e fb          	endbr32 
80101f04:	55                   	push   %ebp
80101f05:	89 e5                	mov    %esp,%ebp
80101f07:	56                   	push   %esi
80101f08:	53                   	push   %ebx
80101f09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f0c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f0f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f12:	83 ec 08             	sub    $0x8,%esp
80101f15:	c1 e8 03             	shr    $0x3,%eax
80101f18:	03 05 94 1f 11 80    	add    0x80111f94,%eax
80101f1e:	50                   	push   %eax
80101f1f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101f22:	e8 a9 e1 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101f27:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f2b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101f2e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101f30:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101f33:	83 e0 07             	and    $0x7,%eax
80101f36:	c1 e0 06             	shl    $0x6,%eax
80101f39:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101f3d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101f40:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f44:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101f47:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101f4b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101f4f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101f53:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101f57:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101f5b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101f5e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101f61:	6a 34                	push   $0x34
80101f63:	53                   	push   %ebx
80101f64:	50                   	push   %eax
80101f65:	e8 06 30 00 00       	call   80104f70 <memmove>
  log_write(bp);
80101f6a:	89 34 24             	mov    %esi,(%esp)
80101f6d:	e8 fe 17 00 00       	call   80103770 <log_write>
  brelse(bp);
80101f72:	89 75 08             	mov    %esi,0x8(%ebp)
80101f75:	83 c4 10             	add    $0x10,%esp
}
80101f78:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f7b:	5b                   	pop    %ebx
80101f7c:	5e                   	pop    %esi
80101f7d:	5d                   	pop    %ebp
  brelse(bp);
80101f7e:	e9 6d e2 ff ff       	jmp    801001f0 <brelse>
80101f83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f90 <idup>:
{
80101f90:	f3 0f 1e fb          	endbr32 
80101f94:	55                   	push   %ebp
80101f95:	89 e5                	mov    %esp,%ebp
80101f97:	53                   	push   %ebx
80101f98:	83 ec 10             	sub    $0x10,%esp
80101f9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101f9e:	68 a0 1f 11 80       	push   $0x80111fa0
80101fa3:	e8 18 2e 00 00       	call   80104dc0 <acquire>
  ip->ref++;
80101fa8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101fac:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
80101fb3:	e8 c8 2e 00 00       	call   80104e80 <release>
}
80101fb8:	89 d8                	mov    %ebx,%eax
80101fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fbd:	c9                   	leave  
80101fbe:	c3                   	ret    
80101fbf:	90                   	nop

80101fc0 <ilock>:
{
80101fc0:	f3 0f 1e fb          	endbr32 
80101fc4:	55                   	push   %ebp
80101fc5:	89 e5                	mov    %esp,%ebp
80101fc7:	56                   	push   %esi
80101fc8:	53                   	push   %ebx
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101fcc:	85 db                	test   %ebx,%ebx
80101fce:	0f 84 b3 00 00 00    	je     80102087 <ilock+0xc7>
80101fd4:	8b 53 08             	mov    0x8(%ebx),%edx
80101fd7:	85 d2                	test   %edx,%edx
80101fd9:	0f 8e a8 00 00 00    	jle    80102087 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101fdf:	83 ec 0c             	sub    $0xc,%esp
80101fe2:	8d 43 0c             	lea    0xc(%ebx),%eax
80101fe5:	50                   	push   %eax
80101fe6:	e8 55 2b 00 00       	call   80104b40 <acquiresleep>
  if(ip->valid == 0){
80101feb:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101fee:	83 c4 10             	add    $0x10,%esp
80101ff1:	85 c0                	test   %eax,%eax
80101ff3:	74 0b                	je     80102000 <ilock+0x40>
}
80101ff5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5d                   	pop    %ebp
80101ffb:	c3                   	ret    
80101ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102000:	8b 43 04             	mov    0x4(%ebx),%eax
80102003:	83 ec 08             	sub    $0x8,%esp
80102006:	c1 e8 03             	shr    $0x3,%eax
80102009:	03 05 94 1f 11 80    	add    0x80111f94,%eax
8010200f:	50                   	push   %eax
80102010:	ff 33                	pushl  (%ebx)
80102012:	e8 b9 e0 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102017:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010201a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010201c:	8b 43 04             	mov    0x4(%ebx),%eax
8010201f:	83 e0 07             	and    $0x7,%eax
80102022:	c1 e0 06             	shl    $0x6,%eax
80102025:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80102029:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010202c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010202f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80102033:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80102037:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010203b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010203f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80102043:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80102047:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010204b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010204e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80102051:	6a 34                	push   $0x34
80102053:	50                   	push   %eax
80102054:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102057:	50                   	push   %eax
80102058:	e8 13 2f 00 00       	call   80104f70 <memmove>
    brelse(bp);
8010205d:	89 34 24             	mov    %esi,(%esp)
80102060:	e8 8b e1 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010206d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80102074:	0f 85 7b ff ff ff    	jne    80101ff5 <ilock+0x35>
      panic("ilock: no type");
8010207a:	83 ec 0c             	sub    $0xc,%esp
8010207d:	68 b0 7a 10 80       	push   $0x80107ab0
80102082:	e8 09 e3 ff ff       	call   80100390 <panic>
    panic("ilock");
80102087:	83 ec 0c             	sub    $0xc,%esp
8010208a:	68 aa 7a 10 80       	push   $0x80107aaa
8010208f:	e8 fc e2 ff ff       	call   80100390 <panic>
80102094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010209f:	90                   	nop

801020a0 <iunlock>:
{
801020a0:	f3 0f 1e fb          	endbr32 
801020a4:	55                   	push   %ebp
801020a5:	89 e5                	mov    %esp,%ebp
801020a7:	56                   	push   %esi
801020a8:	53                   	push   %ebx
801020a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 28                	je     801020d8 <iunlock+0x38>
801020b0:	83 ec 0c             	sub    $0xc,%esp
801020b3:	8d 73 0c             	lea    0xc(%ebx),%esi
801020b6:	56                   	push   %esi
801020b7:	e8 24 2b 00 00       	call   80104be0 <holdingsleep>
801020bc:	83 c4 10             	add    $0x10,%esp
801020bf:	85 c0                	test   %eax,%eax
801020c1:	74 15                	je     801020d8 <iunlock+0x38>
801020c3:	8b 43 08             	mov    0x8(%ebx),%eax
801020c6:	85 c0                	test   %eax,%eax
801020c8:	7e 0e                	jle    801020d8 <iunlock+0x38>
  releasesleep(&ip->lock);
801020ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801020cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020d0:	5b                   	pop    %ebx
801020d1:	5e                   	pop    %esi
801020d2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801020d3:	e9 c8 2a 00 00       	jmp    80104ba0 <releasesleep>
    panic("iunlock");
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 bf 7a 10 80       	push   $0x80107abf
801020e0:	e8 ab e2 ff ff       	call   80100390 <panic>
801020e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020f0 <iput>:
{
801020f0:	f3 0f 1e fb          	endbr32 
801020f4:	55                   	push   %ebp
801020f5:	89 e5                	mov    %esp,%ebp
801020f7:	57                   	push   %edi
801020f8:	56                   	push   %esi
801020f9:	53                   	push   %ebx
801020fa:	83 ec 28             	sub    $0x28,%esp
801020fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80102100:	8d 7b 0c             	lea    0xc(%ebx),%edi
80102103:	57                   	push   %edi
80102104:	e8 37 2a 00 00       	call   80104b40 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80102109:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010210c:	83 c4 10             	add    $0x10,%esp
8010210f:	85 d2                	test   %edx,%edx
80102111:	74 07                	je     8010211a <iput+0x2a>
80102113:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102118:	74 36                	je     80102150 <iput+0x60>
  releasesleep(&ip->lock);
8010211a:	83 ec 0c             	sub    $0xc,%esp
8010211d:	57                   	push   %edi
8010211e:	e8 7d 2a 00 00       	call   80104ba0 <releasesleep>
  acquire(&icache.lock);
80102123:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
8010212a:	e8 91 2c 00 00       	call   80104dc0 <acquire>
  ip->ref--;
8010212f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	c7 45 08 a0 1f 11 80 	movl   $0x80111fa0,0x8(%ebp)
}
8010213d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102140:	5b                   	pop    %ebx
80102141:	5e                   	pop    %esi
80102142:	5f                   	pop    %edi
80102143:	5d                   	pop    %ebp
  release(&icache.lock);
80102144:	e9 37 2d 00 00       	jmp    80104e80 <release>
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80102150:	83 ec 0c             	sub    $0xc,%esp
80102153:	68 a0 1f 11 80       	push   $0x80111fa0
80102158:	e8 63 2c 00 00       	call   80104dc0 <acquire>
    int r = ip->ref;
8010215d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80102160:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
80102167:	e8 14 2d 00 00       	call   80104e80 <release>
    if(r == 1){
8010216c:	83 c4 10             	add    $0x10,%esp
8010216f:	83 fe 01             	cmp    $0x1,%esi
80102172:	75 a6                	jne    8010211a <iput+0x2a>
80102174:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010217a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010217d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102180:	89 cf                	mov    %ecx,%edi
80102182:	eb 0b                	jmp    8010218f <iput+0x9f>
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80102188:	83 c6 04             	add    $0x4,%esi
8010218b:	39 fe                	cmp    %edi,%esi
8010218d:	74 19                	je     801021a8 <iput+0xb8>
    if(ip->addrs[i]){
8010218f:	8b 16                	mov    (%esi),%edx
80102191:	85 d2                	test   %edx,%edx
80102193:	74 f3                	je     80102188 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80102195:	8b 03                	mov    (%ebx),%eax
80102197:	e8 74 f8 ff ff       	call   80101a10 <bfree>
      ip->addrs[i] = 0;
8010219c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801021a2:	eb e4                	jmp    80102188 <iput+0x98>
801021a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801021a8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801021ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801021b1:	85 c0                	test   %eax,%eax
801021b3:	75 33                	jne    801021e8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801021b5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801021b8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801021bf:	53                   	push   %ebx
801021c0:	e8 3b fd ff ff       	call   80101f00 <iupdate>
      ip->type = 0;
801021c5:	31 c0                	xor    %eax,%eax
801021c7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801021cb:	89 1c 24             	mov    %ebx,(%esp)
801021ce:	e8 2d fd ff ff       	call   80101f00 <iupdate>
      ip->valid = 0;
801021d3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801021da:	83 c4 10             	add    $0x10,%esp
801021dd:	e9 38 ff ff ff       	jmp    8010211a <iput+0x2a>
801021e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801021e8:	83 ec 08             	sub    $0x8,%esp
801021eb:	50                   	push   %eax
801021ec:	ff 33                	pushl  (%ebx)
801021ee:	e8 dd de ff ff       	call   801000d0 <bread>
801021f3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801021f6:	83 c4 10             	add    $0x10,%esp
801021f9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801021ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102202:	8d 70 5c             	lea    0x5c(%eax),%esi
80102205:	89 cf                	mov    %ecx,%edi
80102207:	eb 0e                	jmp    80102217 <iput+0x127>
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102210:	83 c6 04             	add    $0x4,%esi
80102213:	39 f7                	cmp    %esi,%edi
80102215:	74 19                	je     80102230 <iput+0x140>
      if(a[j])
80102217:	8b 16                	mov    (%esi),%edx
80102219:	85 d2                	test   %edx,%edx
8010221b:	74 f3                	je     80102210 <iput+0x120>
        bfree(ip->dev, a[j]);
8010221d:	8b 03                	mov    (%ebx),%eax
8010221f:	e8 ec f7 ff ff       	call   80101a10 <bfree>
80102224:	eb ea                	jmp    80102210 <iput+0x120>
80102226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010222d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80102230:	83 ec 0c             	sub    $0xc,%esp
80102233:	ff 75 e4             	pushl  -0x1c(%ebp)
80102236:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102239:	e8 b2 df ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010223e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80102244:	8b 03                	mov    (%ebx),%eax
80102246:	e8 c5 f7 ff ff       	call   80101a10 <bfree>
    ip->addrs[NDIRECT] = 0;
8010224b:	83 c4 10             	add    $0x10,%esp
8010224e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80102255:	00 00 00 
80102258:	e9 58 ff ff ff       	jmp    801021b5 <iput+0xc5>
8010225d:	8d 76 00             	lea    0x0(%esi),%esi

80102260 <iunlockput>:
{
80102260:	f3 0f 1e fb          	endbr32 
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	53                   	push   %ebx
80102268:	83 ec 10             	sub    $0x10,%esp
8010226b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010226e:	53                   	push   %ebx
8010226f:	e8 2c fe ff ff       	call   801020a0 <iunlock>
  iput(ip);
80102274:	89 5d 08             	mov    %ebx,0x8(%ebp)
80102277:	83 c4 10             	add    $0x10,%esp
}
8010227a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010227d:	c9                   	leave  
  iput(ip);
8010227e:	e9 6d fe ff ff       	jmp    801020f0 <iput>
80102283:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102290 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80102290:	f3 0f 1e fb          	endbr32 
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	8b 55 08             	mov    0x8(%ebp),%edx
8010229a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
8010229d:	8b 0a                	mov    (%edx),%ecx
8010229f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801022a2:	8b 4a 04             	mov    0x4(%edx),%ecx
801022a5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801022a8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801022ac:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801022af:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801022b3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801022b7:	8b 52 58             	mov    0x58(%edx),%edx
801022ba:	89 50 10             	mov    %edx,0x10(%eax)
}
801022bd:	5d                   	pop    %ebp
801022be:	c3                   	ret    
801022bf:	90                   	nop

801022c0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801022c0:	f3 0f 1e fb          	endbr32 
801022c4:	55                   	push   %ebp
801022c5:	89 e5                	mov    %esp,%ebp
801022c7:	57                   	push   %edi
801022c8:	56                   	push   %esi
801022c9:	53                   	push   %ebx
801022ca:	83 ec 1c             	sub    $0x1c,%esp
801022cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
801022d0:	8b 45 08             	mov    0x8(%ebp),%eax
801022d3:	8b 75 10             	mov    0x10(%ebp),%esi
801022d6:	89 7d e0             	mov    %edi,-0x20(%ebp)
801022d9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801022dc:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801022e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
801022e4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801022e7:	0f 84 a3 00 00 00    	je     80102390 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801022ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
801022f0:	8b 40 58             	mov    0x58(%eax),%eax
801022f3:	39 c6                	cmp    %eax,%esi
801022f5:	0f 87 b6 00 00 00    	ja     801023b1 <readi+0xf1>
801022fb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801022fe:	31 c9                	xor    %ecx,%ecx
80102300:	89 da                	mov    %ebx,%edx
80102302:	01 f2                	add    %esi,%edx
80102304:	0f 92 c1             	setb   %cl
80102307:	89 cf                	mov    %ecx,%edi
80102309:	0f 82 a2 00 00 00    	jb     801023b1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010230f:	89 c1                	mov    %eax,%ecx
80102311:	29 f1                	sub    %esi,%ecx
80102313:	39 d0                	cmp    %edx,%eax
80102315:	0f 43 cb             	cmovae %ebx,%ecx
80102318:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010231b:	85 c9                	test   %ecx,%ecx
8010231d:	74 63                	je     80102382 <readi+0xc2>
8010231f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102320:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102323:	89 f2                	mov    %esi,%edx
80102325:	c1 ea 09             	shr    $0x9,%edx
80102328:	89 d8                	mov    %ebx,%eax
8010232a:	e8 61 f9 ff ff       	call   80101c90 <bmap>
8010232f:	83 ec 08             	sub    $0x8,%esp
80102332:	50                   	push   %eax
80102333:	ff 33                	pushl  (%ebx)
80102335:	e8 96 dd ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010233a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010233d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102342:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102345:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102347:	89 f0                	mov    %esi,%eax
80102349:	25 ff 01 00 00       	and    $0x1ff,%eax
8010234e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102350:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102353:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102355:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102359:	39 d9                	cmp    %ebx,%ecx
8010235b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010235e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010235f:	01 df                	add    %ebx,%edi
80102361:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102363:	50                   	push   %eax
80102364:	ff 75 e0             	pushl  -0x20(%ebp)
80102367:	e8 04 2c 00 00       	call   80104f70 <memmove>
    brelse(bp);
8010236c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010236f:	89 14 24             	mov    %edx,(%esp)
80102372:	e8 79 de ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102377:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010237a:	83 c4 10             	add    $0x10,%esp
8010237d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102380:	77 9e                	ja     80102320 <readi+0x60>
  }
  return n;
80102382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102385:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102388:	5b                   	pop    %ebx
80102389:	5e                   	pop    %esi
8010238a:	5f                   	pop    %edi
8010238b:	5d                   	pop    %ebp
8010238c:	c3                   	ret    
8010238d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102390:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102394:	66 83 f8 09          	cmp    $0x9,%ax
80102398:	77 17                	ja     801023b1 <readi+0xf1>
8010239a:	8b 04 c5 20 1f 11 80 	mov    -0x7feee0e0(,%eax,8),%eax
801023a1:	85 c0                	test   %eax,%eax
801023a3:	74 0c                	je     801023b1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801023a5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801023a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ab:	5b                   	pop    %ebx
801023ac:	5e                   	pop    %esi
801023ad:	5f                   	pop    %edi
801023ae:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801023af:	ff e0                	jmp    *%eax
      return -1;
801023b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023b6:	eb cd                	jmp    80102385 <readi+0xc5>
801023b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023bf:	90                   	nop

801023c0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801023c0:	f3 0f 1e fb          	endbr32 
801023c4:	55                   	push   %ebp
801023c5:	89 e5                	mov    %esp,%ebp
801023c7:	57                   	push   %edi
801023c8:	56                   	push   %esi
801023c9:	53                   	push   %ebx
801023ca:	83 ec 1c             	sub    $0x1c,%esp
801023cd:	8b 45 08             	mov    0x8(%ebp),%eax
801023d0:	8b 75 0c             	mov    0xc(%ebp),%esi
801023d3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801023d6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801023db:	89 75 dc             	mov    %esi,-0x24(%ebp)
801023de:	89 45 d8             	mov    %eax,-0x28(%ebp)
801023e1:	8b 75 10             	mov    0x10(%ebp),%esi
801023e4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
801023e7:	0f 84 b3 00 00 00    	je     801024a0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801023ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
801023f0:	39 70 58             	cmp    %esi,0x58(%eax)
801023f3:	0f 82 e3 00 00 00    	jb     801024dc <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801023f9:	8b 7d e0             	mov    -0x20(%ebp),%edi
801023fc:	89 f8                	mov    %edi,%eax
801023fe:	01 f0                	add    %esi,%eax
80102400:	0f 82 d6 00 00 00    	jb     801024dc <writei+0x11c>
80102406:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010240b:	0f 87 cb 00 00 00    	ja     801024dc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102411:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102418:	85 ff                	test   %edi,%edi
8010241a:	74 75                	je     80102491 <writei+0xd1>
8010241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102420:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102423:	89 f2                	mov    %esi,%edx
80102425:	c1 ea 09             	shr    $0x9,%edx
80102428:	89 f8                	mov    %edi,%eax
8010242a:	e8 61 f8 ff ff       	call   80101c90 <bmap>
8010242f:	83 ec 08             	sub    $0x8,%esp
80102432:	50                   	push   %eax
80102433:	ff 37                	pushl  (%edi)
80102435:	e8 96 dc ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010243a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010243f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102442:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102445:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102447:	89 f0                	mov    %esi,%eax
80102449:	83 c4 0c             	add    $0xc,%esp
8010244c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102451:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102453:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102457:	39 d9                	cmp    %ebx,%ecx
80102459:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010245c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010245d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010245f:	ff 75 dc             	pushl  -0x24(%ebp)
80102462:	50                   	push   %eax
80102463:	e8 08 2b 00 00       	call   80104f70 <memmove>
    log_write(bp);
80102468:	89 3c 24             	mov    %edi,(%esp)
8010246b:	e8 00 13 00 00       	call   80103770 <log_write>
    brelse(bp);
80102470:	89 3c 24             	mov    %edi,(%esp)
80102473:	e8 78 dd ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102478:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010247b:	83 c4 10             	add    $0x10,%esp
8010247e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102481:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102484:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102487:	77 97                	ja     80102420 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102489:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010248c:	3b 70 58             	cmp    0x58(%eax),%esi
8010248f:	77 37                	ja     801024c8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102491:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102494:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102497:	5b                   	pop    %ebx
80102498:	5e                   	pop    %esi
80102499:	5f                   	pop    %edi
8010249a:	5d                   	pop    %ebp
8010249b:	c3                   	ret    
8010249c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801024a0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801024a4:	66 83 f8 09          	cmp    $0x9,%ax
801024a8:	77 32                	ja     801024dc <writei+0x11c>
801024aa:	8b 04 c5 24 1f 11 80 	mov    -0x7feee0dc(,%eax,8),%eax
801024b1:	85 c0                	test   %eax,%eax
801024b3:	74 27                	je     801024dc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801024b5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801024b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024bb:	5b                   	pop    %ebx
801024bc:	5e                   	pop    %esi
801024bd:	5f                   	pop    %edi
801024be:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801024bf:	ff e0                	jmp    *%eax
801024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801024c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801024cb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801024ce:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801024d1:	50                   	push   %eax
801024d2:	e8 29 fa ff ff       	call   80101f00 <iupdate>
801024d7:	83 c4 10             	add    $0x10,%esp
801024da:	eb b5                	jmp    80102491 <writei+0xd1>
      return -1;
801024dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024e1:	eb b1                	jmp    80102494 <writei+0xd4>
801024e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801024f0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801024f0:	f3 0f 1e fb          	endbr32 
801024f4:	55                   	push   %ebp
801024f5:	89 e5                	mov    %esp,%ebp
801024f7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801024fa:	6a 0e                	push   $0xe
801024fc:	ff 75 0c             	pushl  0xc(%ebp)
801024ff:	ff 75 08             	pushl  0x8(%ebp)
80102502:	e8 d9 2a 00 00       	call   80104fe0 <strncmp>
}
80102507:	c9                   	leave  
80102508:	c3                   	ret    
80102509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102510 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	57                   	push   %edi
80102518:	56                   	push   %esi
80102519:	53                   	push   %ebx
8010251a:	83 ec 1c             	sub    $0x1c,%esp
8010251d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102520:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102525:	0f 85 89 00 00 00    	jne    801025b4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010252b:	8b 53 58             	mov    0x58(%ebx),%edx
8010252e:	31 ff                	xor    %edi,%edi
80102530:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102533:	85 d2                	test   %edx,%edx
80102535:	74 42                	je     80102579 <dirlookup+0x69>
80102537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102540:	6a 10                	push   $0x10
80102542:	57                   	push   %edi
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
80102545:	e8 76 fd ff ff       	call   801022c0 <readi>
8010254a:	83 c4 10             	add    $0x10,%esp
8010254d:	83 f8 10             	cmp    $0x10,%eax
80102550:	75 55                	jne    801025a7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102552:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102557:	74 18                	je     80102571 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102559:	83 ec 04             	sub    $0x4,%esp
8010255c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010255f:	6a 0e                	push   $0xe
80102561:	50                   	push   %eax
80102562:	ff 75 0c             	pushl  0xc(%ebp)
80102565:	e8 76 2a 00 00       	call   80104fe0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010256a:	83 c4 10             	add    $0x10,%esp
8010256d:	85 c0                	test   %eax,%eax
8010256f:	74 17                	je     80102588 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102571:	83 c7 10             	add    $0x10,%edi
80102574:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102577:	72 c7                	jb     80102540 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102579:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010257c:	31 c0                	xor    %eax,%eax
}
8010257e:	5b                   	pop    %ebx
8010257f:	5e                   	pop    %esi
80102580:	5f                   	pop    %edi
80102581:	5d                   	pop    %ebp
80102582:	c3                   	ret    
80102583:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102587:	90                   	nop
      if(poff)
80102588:	8b 45 10             	mov    0x10(%ebp),%eax
8010258b:	85 c0                	test   %eax,%eax
8010258d:	74 05                	je     80102594 <dirlookup+0x84>
        *poff = off;
8010258f:	8b 45 10             	mov    0x10(%ebp),%eax
80102592:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102594:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102598:	8b 03                	mov    (%ebx),%eax
8010259a:	e8 01 f6 ff ff       	call   80101ba0 <iget>
}
8010259f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025a2:	5b                   	pop    %ebx
801025a3:	5e                   	pop    %esi
801025a4:	5f                   	pop    %edi
801025a5:	5d                   	pop    %ebp
801025a6:	c3                   	ret    
      panic("dirlookup read");
801025a7:	83 ec 0c             	sub    $0xc,%esp
801025aa:	68 d9 7a 10 80       	push   $0x80107ad9
801025af:	e8 dc dd ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
801025b4:	83 ec 0c             	sub    $0xc,%esp
801025b7:	68 c7 7a 10 80       	push   $0x80107ac7
801025bc:	e8 cf dd ff ff       	call   80100390 <panic>
801025c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	57                   	push   %edi
801025d4:	56                   	push   %esi
801025d5:	53                   	push   %ebx
801025d6:	89 c3                	mov    %eax,%ebx
801025d8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801025db:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801025de:	89 55 e0             	mov    %edx,-0x20(%ebp)
801025e1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801025e4:	0f 84 86 01 00 00    	je     80102770 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801025ea:	e8 d1 1b 00 00       	call   801041c0 <myproc>
  acquire(&icache.lock);
801025ef:	83 ec 0c             	sub    $0xc,%esp
801025f2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
801025f4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801025f7:	68 a0 1f 11 80       	push   $0x80111fa0
801025fc:	e8 bf 27 00 00       	call   80104dc0 <acquire>
  ip->ref++;
80102601:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102605:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
8010260c:	e8 6f 28 00 00       	call   80104e80 <release>
80102611:	83 c4 10             	add    $0x10,%esp
80102614:	eb 0d                	jmp    80102623 <namex+0x53>
80102616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010261d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102620:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102623:	0f b6 07             	movzbl (%edi),%eax
80102626:	3c 2f                	cmp    $0x2f,%al
80102628:	74 f6                	je     80102620 <namex+0x50>
  if(*path == 0)
8010262a:	84 c0                	test   %al,%al
8010262c:	0f 84 ee 00 00 00    	je     80102720 <namex+0x150>
  while(*path != '/' && *path != 0)
80102632:	0f b6 07             	movzbl (%edi),%eax
80102635:	84 c0                	test   %al,%al
80102637:	0f 84 fb 00 00 00    	je     80102738 <namex+0x168>
8010263d:	89 fb                	mov    %edi,%ebx
8010263f:	3c 2f                	cmp    $0x2f,%al
80102641:	0f 84 f1 00 00 00    	je     80102738 <namex+0x168>
80102647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264e:	66 90                	xchg   %ax,%ax
80102650:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102654:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102657:	3c 2f                	cmp    $0x2f,%al
80102659:	74 04                	je     8010265f <namex+0x8f>
8010265b:	84 c0                	test   %al,%al
8010265d:	75 f1                	jne    80102650 <namex+0x80>
  len = path - s;
8010265f:	89 d8                	mov    %ebx,%eax
80102661:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102663:	83 f8 0d             	cmp    $0xd,%eax
80102666:	0f 8e 84 00 00 00    	jle    801026f0 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010266c:	83 ec 04             	sub    $0x4,%esp
8010266f:	6a 0e                	push   $0xe
80102671:	57                   	push   %edi
    path++;
80102672:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102674:	ff 75 e4             	pushl  -0x1c(%ebp)
80102677:	e8 f4 28 00 00       	call   80104f70 <memmove>
8010267c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010267f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102682:	75 0c                	jne    80102690 <namex+0xc0>
80102684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102688:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010268b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010268e:	74 f8                	je     80102688 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	56                   	push   %esi
80102694:	e8 27 f9 ff ff       	call   80101fc0 <ilock>
    if(ip->type != T_DIR){
80102699:	83 c4 10             	add    $0x10,%esp
8010269c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801026a1:	0f 85 a1 00 00 00    	jne    80102748 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801026a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801026aa:	85 d2                	test   %edx,%edx
801026ac:	74 09                	je     801026b7 <namex+0xe7>
801026ae:	80 3f 00             	cmpb   $0x0,(%edi)
801026b1:	0f 84 d9 00 00 00    	je     80102790 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801026b7:	83 ec 04             	sub    $0x4,%esp
801026ba:	6a 00                	push   $0x0
801026bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801026bf:	56                   	push   %esi
801026c0:	e8 4b fe ff ff       	call   80102510 <dirlookup>
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	89 c3                	mov    %eax,%ebx
801026ca:	85 c0                	test   %eax,%eax
801026cc:	74 7a                	je     80102748 <namex+0x178>
  iunlock(ip);
801026ce:	83 ec 0c             	sub    $0xc,%esp
801026d1:	56                   	push   %esi
801026d2:	e8 c9 f9 ff ff       	call   801020a0 <iunlock>
  iput(ip);
801026d7:	89 34 24             	mov    %esi,(%esp)
801026da:	89 de                	mov    %ebx,%esi
801026dc:	e8 0f fa ff ff       	call   801020f0 <iput>
801026e1:	83 c4 10             	add    $0x10,%esp
801026e4:	e9 3a ff ff ff       	jmp    80102623 <namex+0x53>
801026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801026f3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801026f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
801026f9:	83 ec 04             	sub    $0x4,%esp
801026fc:	50                   	push   %eax
801026fd:	57                   	push   %edi
    name[len] = 0;
801026fe:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102700:	ff 75 e4             	pushl  -0x1c(%ebp)
80102703:	e8 68 28 00 00       	call   80104f70 <memmove>
    name[len] = 0;
80102708:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010270b:	83 c4 10             	add    $0x10,%esp
8010270e:	c6 00 00             	movb   $0x0,(%eax)
80102711:	e9 69 ff ff ff       	jmp    8010267f <namex+0xaf>
80102716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102720:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102723:	85 c0                	test   %eax,%eax
80102725:	0f 85 85 00 00 00    	jne    801027b0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010272b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010272e:	89 f0                	mov    %esi,%eax
80102730:	5b                   	pop    %ebx
80102731:	5e                   	pop    %esi
80102732:	5f                   	pop    %edi
80102733:	5d                   	pop    %ebp
80102734:	c3                   	ret    
80102735:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010273b:	89 fb                	mov    %edi,%ebx
8010273d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102740:	31 c0                	xor    %eax,%eax
80102742:	eb b5                	jmp    801026f9 <namex+0x129>
80102744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102748:	83 ec 0c             	sub    $0xc,%esp
8010274b:	56                   	push   %esi
8010274c:	e8 4f f9 ff ff       	call   801020a0 <iunlock>
  iput(ip);
80102751:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102754:	31 f6                	xor    %esi,%esi
  iput(ip);
80102756:	e8 95 f9 ff ff       	call   801020f0 <iput>
      return 0;
8010275b:	83 c4 10             	add    $0x10,%esp
}
8010275e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102761:	89 f0                	mov    %esi,%eax
80102763:	5b                   	pop    %ebx
80102764:	5e                   	pop    %esi
80102765:	5f                   	pop    %edi
80102766:	5d                   	pop    %ebp
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102770:	ba 01 00 00 00       	mov    $0x1,%edx
80102775:	b8 01 00 00 00       	mov    $0x1,%eax
8010277a:	89 df                	mov    %ebx,%edi
8010277c:	e8 1f f4 ff ff       	call   80101ba0 <iget>
80102781:	89 c6                	mov    %eax,%esi
80102783:	e9 9b fe ff ff       	jmp    80102623 <namex+0x53>
80102788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop
      iunlock(ip);
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	56                   	push   %esi
80102794:	e8 07 f9 ff ff       	call   801020a0 <iunlock>
      return ip;
80102799:	83 c4 10             	add    $0x10,%esp
}
8010279c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010279f:	89 f0                	mov    %esi,%eax
801027a1:	5b                   	pop    %ebx
801027a2:	5e                   	pop    %esi
801027a3:	5f                   	pop    %edi
801027a4:	5d                   	pop    %ebp
801027a5:	c3                   	ret    
801027a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ad:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801027b0:	83 ec 0c             	sub    $0xc,%esp
801027b3:	56                   	push   %esi
    return 0;
801027b4:	31 f6                	xor    %esi,%esi
    iput(ip);
801027b6:	e8 35 f9 ff ff       	call   801020f0 <iput>
    return 0;
801027bb:	83 c4 10             	add    $0x10,%esp
801027be:	e9 68 ff ff ff       	jmp    8010272b <namex+0x15b>
801027c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027d0 <dirlink>:
{
801027d0:	f3 0f 1e fb          	endbr32 
801027d4:	55                   	push   %ebp
801027d5:	89 e5                	mov    %esp,%ebp
801027d7:	57                   	push   %edi
801027d8:	56                   	push   %esi
801027d9:	53                   	push   %ebx
801027da:	83 ec 20             	sub    $0x20,%esp
801027dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801027e0:	6a 00                	push   $0x0
801027e2:	ff 75 0c             	pushl  0xc(%ebp)
801027e5:	53                   	push   %ebx
801027e6:	e8 25 fd ff ff       	call   80102510 <dirlookup>
801027eb:	83 c4 10             	add    $0x10,%esp
801027ee:	85 c0                	test   %eax,%eax
801027f0:	75 6b                	jne    8010285d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801027f2:	8b 7b 58             	mov    0x58(%ebx),%edi
801027f5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801027f8:	85 ff                	test   %edi,%edi
801027fa:	74 2d                	je     80102829 <dirlink+0x59>
801027fc:	31 ff                	xor    %edi,%edi
801027fe:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102801:	eb 0d                	jmp    80102810 <dirlink+0x40>
80102803:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102807:	90                   	nop
80102808:	83 c7 10             	add    $0x10,%edi
8010280b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010280e:	73 19                	jae    80102829 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102810:	6a 10                	push   $0x10
80102812:	57                   	push   %edi
80102813:	56                   	push   %esi
80102814:	53                   	push   %ebx
80102815:	e8 a6 fa ff ff       	call   801022c0 <readi>
8010281a:	83 c4 10             	add    $0x10,%esp
8010281d:	83 f8 10             	cmp    $0x10,%eax
80102820:	75 4e                	jne    80102870 <dirlink+0xa0>
    if(de.inum == 0)
80102822:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102827:	75 df                	jne    80102808 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102829:	83 ec 04             	sub    $0x4,%esp
8010282c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010282f:	6a 0e                	push   $0xe
80102831:	ff 75 0c             	pushl  0xc(%ebp)
80102834:	50                   	push   %eax
80102835:	e8 f6 27 00 00       	call   80105030 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010283a:	6a 10                	push   $0x10
  de.inum = inum;
8010283c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010283f:	57                   	push   %edi
80102840:	56                   	push   %esi
80102841:	53                   	push   %ebx
  de.inum = inum;
80102842:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102846:	e8 75 fb ff ff       	call   801023c0 <writei>
8010284b:	83 c4 20             	add    $0x20,%esp
8010284e:	83 f8 10             	cmp    $0x10,%eax
80102851:	75 2a                	jne    8010287d <dirlink+0xad>
  return 0;
80102853:	31 c0                	xor    %eax,%eax
}
80102855:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102858:	5b                   	pop    %ebx
80102859:	5e                   	pop    %esi
8010285a:	5f                   	pop    %edi
8010285b:	5d                   	pop    %ebp
8010285c:	c3                   	ret    
    iput(ip);
8010285d:	83 ec 0c             	sub    $0xc,%esp
80102860:	50                   	push   %eax
80102861:	e8 8a f8 ff ff       	call   801020f0 <iput>
    return -1;
80102866:	83 c4 10             	add    $0x10,%esp
80102869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010286e:	eb e5                	jmp    80102855 <dirlink+0x85>
      panic("dirlink read");
80102870:	83 ec 0c             	sub    $0xc,%esp
80102873:	68 e8 7a 10 80       	push   $0x80107ae8
80102878:	e8 13 db ff ff       	call   80100390 <panic>
    panic("dirlink");
8010287d:	83 ec 0c             	sub    $0xc,%esp
80102880:	68 be 80 10 80       	push   $0x801080be
80102885:	e8 06 db ff ff       	call   80100390 <panic>
8010288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102890 <namei>:

struct inode*
namei(char *path)
{
80102890:	f3 0f 1e fb          	endbr32 
80102894:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102895:	31 d2                	xor    %edx,%edx
{
80102897:	89 e5                	mov    %esp,%ebp
80102899:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010289c:	8b 45 08             	mov    0x8(%ebp),%eax
8010289f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801028a2:	e8 29 fd ff ff       	call   801025d0 <namex>
}
801028a7:	c9                   	leave  
801028a8:	c3                   	ret    
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801028b0:	f3 0f 1e fb          	endbr32 
801028b4:	55                   	push   %ebp
  return namex(path, 1, name);
801028b5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801028ba:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801028bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801028c2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801028c3:	e9 08 fd ff ff       	jmp    801025d0 <namex>
801028c8:	66 90                	xchg   %ax,%ax
801028ca:	66 90                	xchg   %ax,%ax
801028cc:	66 90                	xchg   %ax,%ax
801028ce:	66 90                	xchg   %ax,%ax

801028d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801028d0:	55                   	push   %ebp
801028d1:	89 e5                	mov    %esp,%ebp
801028d3:	57                   	push   %edi
801028d4:	56                   	push   %esi
801028d5:	53                   	push   %ebx
801028d6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801028d9:	85 c0                	test   %eax,%eax
801028db:	0f 84 b4 00 00 00    	je     80102995 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801028e1:	8b 70 08             	mov    0x8(%eax),%esi
801028e4:	89 c3                	mov    %eax,%ebx
801028e6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801028ec:	0f 87 96 00 00 00    	ja     80102988 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801028f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fe:	66 90                	xchg   %ax,%ax
80102900:	89 ca                	mov    %ecx,%edx
80102902:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102903:	83 e0 c0             	and    $0xffffffc0,%eax
80102906:	3c 40                	cmp    $0x40,%al
80102908:	75 f6                	jne    80102900 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010290a:	31 ff                	xor    %edi,%edi
8010290c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102911:	89 f8                	mov    %edi,%eax
80102913:	ee                   	out    %al,(%dx)
80102914:	b8 01 00 00 00       	mov    $0x1,%eax
80102919:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010291e:	ee                   	out    %al,(%dx)
8010291f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102924:	89 f0                	mov    %esi,%eax
80102926:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102927:	89 f0                	mov    %esi,%eax
80102929:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010292e:	c1 f8 08             	sar    $0x8,%eax
80102931:	ee                   	out    %al,(%dx)
80102932:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102937:	89 f8                	mov    %edi,%eax
80102939:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010293a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010293e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102943:	c1 e0 04             	shl    $0x4,%eax
80102946:	83 e0 10             	and    $0x10,%eax
80102949:	83 c8 e0             	or     $0xffffffe0,%eax
8010294c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010294d:	f6 03 04             	testb  $0x4,(%ebx)
80102950:	75 16                	jne    80102968 <idestart+0x98>
80102952:	b8 20 00 00 00       	mov    $0x20,%eax
80102957:	89 ca                	mov    %ecx,%edx
80102959:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010295a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010295d:	5b                   	pop    %ebx
8010295e:	5e                   	pop    %esi
8010295f:	5f                   	pop    %edi
80102960:	5d                   	pop    %ebp
80102961:	c3                   	ret    
80102962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102968:	b8 30 00 00 00       	mov    $0x30,%eax
8010296d:	89 ca                	mov    %ecx,%edx
8010296f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102970:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102975:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102978:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010297d:	fc                   	cld    
8010297e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102980:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102983:	5b                   	pop    %ebx
80102984:	5e                   	pop    %esi
80102985:	5f                   	pop    %edi
80102986:	5d                   	pop    %ebp
80102987:	c3                   	ret    
    panic("incorrect blockno");
80102988:	83 ec 0c             	sub    $0xc,%esp
8010298b:	68 54 7b 10 80       	push   $0x80107b54
80102990:	e8 fb d9 ff ff       	call   80100390 <panic>
    panic("idestart");
80102995:	83 ec 0c             	sub    $0xc,%esp
80102998:	68 4b 7b 10 80       	push   $0x80107b4b
8010299d:	e8 ee d9 ff ff       	call   80100390 <panic>
801029a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029b0 <ideinit>:
{
801029b0:	f3 0f 1e fb          	endbr32 
801029b4:	55                   	push   %ebp
801029b5:	89 e5                	mov    %esp,%ebp
801029b7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801029ba:	68 66 7b 10 80       	push   $0x80107b66
801029bf:	68 a0 b5 10 80       	push   $0x8010b5a0
801029c4:	e8 77 22 00 00       	call   80104c40 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801029c9:	58                   	pop    %eax
801029ca:	a1 c0 42 11 80       	mov    0x801142c0,%eax
801029cf:	5a                   	pop    %edx
801029d0:	83 e8 01             	sub    $0x1,%eax
801029d3:	50                   	push   %eax
801029d4:	6a 0e                	push   $0xe
801029d6:	e8 b5 02 00 00       	call   80102c90 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801029db:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029de:	ba f7 01 00 00       	mov    $0x1f7,%edx
801029e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029e7:	90                   	nop
801029e8:	ec                   	in     (%dx),%al
801029e9:	83 e0 c0             	and    $0xffffffc0,%eax
801029ec:	3c 40                	cmp    $0x40,%al
801029ee:	75 f8                	jne    801029e8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801029f5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801029fa:	ee                   	out    %al,(%dx)
801029fb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a00:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a05:	eb 0e                	jmp    80102a15 <ideinit+0x65>
80102a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102a10:	83 e9 01             	sub    $0x1,%ecx
80102a13:	74 0f                	je     80102a24 <ideinit+0x74>
80102a15:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102a16:	84 c0                	test   %al,%al
80102a18:	74 f6                	je     80102a10 <ideinit+0x60>
      havedisk1 = 1;
80102a1a:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
80102a21:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102a29:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a2e:	ee                   	out    %al,(%dx)
}
80102a2f:	c9                   	leave  
80102a30:	c3                   	ret    
80102a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3f:	90                   	nop

80102a40 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102a40:	f3 0f 1e fb          	endbr32 
80102a44:	55                   	push   %ebp
80102a45:	89 e5                	mov    %esp,%ebp
80102a47:	57                   	push   %edi
80102a48:	56                   	push   %esi
80102a49:	53                   	push   %ebx
80102a4a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102a4d:	68 a0 b5 10 80       	push   $0x8010b5a0
80102a52:	e8 69 23 00 00       	call   80104dc0 <acquire>

  if((b = idequeue) == 0){
80102a57:	8b 1d 84 b5 10 80    	mov    0x8010b584,%ebx
80102a5d:	83 c4 10             	add    $0x10,%esp
80102a60:	85 db                	test   %ebx,%ebx
80102a62:	74 5f                	je     80102ac3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102a64:	8b 43 58             	mov    0x58(%ebx),%eax
80102a67:	a3 84 b5 10 80       	mov    %eax,0x8010b584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a6c:	8b 33                	mov    (%ebx),%esi
80102a6e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102a74:	75 2b                	jne    80102aa1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a7f:	90                   	nop
80102a80:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102a81:	89 c1                	mov    %eax,%ecx
80102a83:	83 e1 c0             	and    $0xffffffc0,%ecx
80102a86:	80 f9 40             	cmp    $0x40,%cl
80102a89:	75 f5                	jne    80102a80 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102a8b:	a8 21                	test   $0x21,%al
80102a8d:	75 12                	jne    80102aa1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102a8f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102a92:	b9 80 00 00 00       	mov    $0x80,%ecx
80102a97:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102a9c:	fc                   	cld    
80102a9d:	f3 6d                	rep insl (%dx),%es:(%edi)
80102a9f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102aa1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102aa4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102aa7:	83 ce 02             	or     $0x2,%esi
80102aaa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102aac:	53                   	push   %ebx
80102aad:	e8 8e 1e 00 00       	call   80104940 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102ab2:	a1 84 b5 10 80       	mov    0x8010b584,%eax
80102ab7:	83 c4 10             	add    $0x10,%esp
80102aba:	85 c0                	test   %eax,%eax
80102abc:	74 05                	je     80102ac3 <ideintr+0x83>
    idestart(idequeue);
80102abe:	e8 0d fe ff ff       	call   801028d0 <idestart>
    release(&idelock);
80102ac3:	83 ec 0c             	sub    $0xc,%esp
80102ac6:	68 a0 b5 10 80       	push   $0x8010b5a0
80102acb:	e8 b0 23 00 00       	call   80104e80 <release>

  release(&idelock);
}
80102ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ad3:	5b                   	pop    %ebx
80102ad4:	5e                   	pop    %esi
80102ad5:	5f                   	pop    %edi
80102ad6:	5d                   	pop    %ebp
80102ad7:	c3                   	ret    
80102ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102adf:	90                   	nop

80102ae0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102ae0:	f3 0f 1e fb          	endbr32 
80102ae4:	55                   	push   %ebp
80102ae5:	89 e5                	mov    %esp,%ebp
80102ae7:	53                   	push   %ebx
80102ae8:	83 ec 10             	sub    $0x10,%esp
80102aeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102aee:	8d 43 0c             	lea    0xc(%ebx),%eax
80102af1:	50                   	push   %eax
80102af2:	e8 e9 20 00 00       	call   80104be0 <holdingsleep>
80102af7:	83 c4 10             	add    $0x10,%esp
80102afa:	85 c0                	test   %eax,%eax
80102afc:	0f 84 cf 00 00 00    	je     80102bd1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102b02:	8b 03                	mov    (%ebx),%eax
80102b04:	83 e0 06             	and    $0x6,%eax
80102b07:	83 f8 02             	cmp    $0x2,%eax
80102b0a:	0f 84 b4 00 00 00    	je     80102bc4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102b10:	8b 53 04             	mov    0x4(%ebx),%edx
80102b13:	85 d2                	test   %edx,%edx
80102b15:	74 0d                	je     80102b24 <iderw+0x44>
80102b17:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80102b1c:	85 c0                	test   %eax,%eax
80102b1e:	0f 84 93 00 00 00    	je     80102bb7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102b24:	83 ec 0c             	sub    $0xc,%esp
80102b27:	68 a0 b5 10 80       	push   $0x8010b5a0
80102b2c:	e8 8f 22 00 00       	call   80104dc0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b31:	a1 84 b5 10 80       	mov    0x8010b584,%eax
  b->qnext = 0;
80102b36:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102b3d:	83 c4 10             	add    $0x10,%esp
80102b40:	85 c0                	test   %eax,%eax
80102b42:	74 6c                	je     80102bb0 <iderw+0xd0>
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	8b 40 58             	mov    0x58(%eax),%eax
80102b4d:	85 c0                	test   %eax,%eax
80102b4f:	75 f7                	jne    80102b48 <iderw+0x68>
80102b51:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102b54:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102b56:	39 1d 84 b5 10 80    	cmp    %ebx,0x8010b584
80102b5c:	74 42                	je     80102ba0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b5e:	8b 03                	mov    (%ebx),%eax
80102b60:	83 e0 06             	and    $0x6,%eax
80102b63:	83 f8 02             	cmp    $0x2,%eax
80102b66:	74 23                	je     80102b8b <iderw+0xab>
80102b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b6f:	90                   	nop
    sleep(b, &idelock);
80102b70:	83 ec 08             	sub    $0x8,%esp
80102b73:	68 a0 b5 10 80       	push   $0x8010b5a0
80102b78:	53                   	push   %ebx
80102b79:	e8 02 1c 00 00       	call   80104780 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b7e:	8b 03                	mov    (%ebx),%eax
80102b80:	83 c4 10             	add    $0x10,%esp
80102b83:	83 e0 06             	and    $0x6,%eax
80102b86:	83 f8 02             	cmp    $0x2,%eax
80102b89:	75 e5                	jne    80102b70 <iderw+0x90>
  }


  release(&idelock);
80102b8b:	c7 45 08 a0 b5 10 80 	movl   $0x8010b5a0,0x8(%ebp)
}
80102b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b95:	c9                   	leave  
  release(&idelock);
80102b96:	e9 e5 22 00 00       	jmp    80104e80 <release>
80102b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b9f:	90                   	nop
    idestart(b);
80102ba0:	89 d8                	mov    %ebx,%eax
80102ba2:	e8 29 fd ff ff       	call   801028d0 <idestart>
80102ba7:	eb b5                	jmp    80102b5e <iderw+0x7e>
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102bb0:	ba 84 b5 10 80       	mov    $0x8010b584,%edx
80102bb5:	eb 9d                	jmp    80102b54 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102bb7:	83 ec 0c             	sub    $0xc,%esp
80102bba:	68 95 7b 10 80       	push   $0x80107b95
80102bbf:	e8 cc d7 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102bc4:	83 ec 0c             	sub    $0xc,%esp
80102bc7:	68 80 7b 10 80       	push   $0x80107b80
80102bcc:	e8 bf d7 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102bd1:	83 ec 0c             	sub    $0xc,%esp
80102bd4:	68 6a 7b 10 80       	push   $0x80107b6a
80102bd9:	e8 b2 d7 ff ff       	call   80100390 <panic>
80102bde:	66 90                	xchg   %ax,%ax

80102be0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102be0:	f3 0f 1e fb          	endbr32 
80102be4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102be5:	c7 05 f4 3b 11 80 00 	movl   $0xfec00000,0x80113bf4
80102bec:	00 c0 fe 
{
80102bef:	89 e5                	mov    %esp,%ebp
80102bf1:	56                   	push   %esi
80102bf2:	53                   	push   %ebx
  ioapic->reg = reg;
80102bf3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102bfa:	00 00 00 
  return ioapic->data;
80102bfd:	8b 15 f4 3b 11 80    	mov    0x80113bf4,%edx
80102c03:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102c06:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102c0c:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102c12:	0f b6 15 20 3d 11 80 	movzbl 0x80113d20,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102c19:	c1 ee 10             	shr    $0x10,%esi
80102c1c:	89 f0                	mov    %esi,%eax
80102c1e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102c21:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102c24:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102c27:	39 c2                	cmp    %eax,%edx
80102c29:	74 16                	je     80102c41 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102c2b:	83 ec 0c             	sub    $0xc,%esp
80102c2e:	68 b4 7b 10 80       	push   $0x80107bb4
80102c33:	e8 18 dd ff ff       	call   80100950 <cprintf>
80102c38:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
80102c3e:	83 c4 10             	add    $0x10,%esp
80102c41:	83 c6 21             	add    $0x21,%esi
{
80102c44:	ba 10 00 00 00       	mov    $0x10,%edx
80102c49:	b8 20 00 00 00       	mov    $0x20,%eax
80102c4e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102c50:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c52:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102c54:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
80102c5a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c5d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102c63:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102c66:	8d 5a 01             	lea    0x1(%edx),%ebx
80102c69:	83 c2 02             	add    $0x2,%edx
80102c6c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102c6e:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
80102c74:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102c7b:	39 f0                	cmp    %esi,%eax
80102c7d:	75 d1                	jne    80102c50 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102c7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c82:	5b                   	pop    %ebx
80102c83:	5e                   	pop    %esi
80102c84:	5d                   	pop    %ebp
80102c85:	c3                   	ret    
80102c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c8d:	8d 76 00             	lea    0x0(%esi),%esi

80102c90 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
  ioapic->reg = reg;
80102c95:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
{
80102c9b:	89 e5                	mov    %esp,%ebp
80102c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ca0:	8d 50 20             	lea    0x20(%eax),%edx
80102ca3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102ca7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ca9:	8b 0d f4 3b 11 80    	mov    0x80113bf4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102caf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102cb2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102cb8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102cba:	a1 f4 3b 11 80       	mov    0x80113bf4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102cbf:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102cc2:	89 50 10             	mov    %edx,0x10(%eax)
}
80102cc5:	5d                   	pop    %ebp
80102cc6:	c3                   	ret    
80102cc7:	66 90                	xchg   %ax,%ax
80102cc9:	66 90                	xchg   %ax,%ax
80102ccb:	66 90                	xchg   %ax,%ax
80102ccd:	66 90                	xchg   %ax,%ax
80102ccf:	90                   	nop

80102cd0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102cd0:	f3 0f 1e fb          	endbr32 
80102cd4:	55                   	push   %ebp
80102cd5:	89 e5                	mov    %esp,%ebp
80102cd7:	53                   	push   %ebx
80102cd8:	83 ec 04             	sub    $0x4,%esp
80102cdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102cde:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102ce4:	75 7a                	jne    80102d60 <kfree+0x90>
80102ce6:	81 fb 68 6a 11 80    	cmp    $0x80116a68,%ebx
80102cec:	72 72                	jb     80102d60 <kfree+0x90>
80102cee:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102cf4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102cf9:	77 65                	ja     80102d60 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102cfb:	83 ec 04             	sub    $0x4,%esp
80102cfe:	68 00 10 00 00       	push   $0x1000
80102d03:	6a 01                	push   $0x1
80102d05:	53                   	push   %ebx
80102d06:	e8 c5 21 00 00       	call   80104ed0 <memset>

  if(kmem.use_lock)
80102d0b:	8b 15 34 3c 11 80    	mov    0x80113c34,%edx
80102d11:	83 c4 10             	add    $0x10,%esp
80102d14:	85 d2                	test   %edx,%edx
80102d16:	75 20                	jne    80102d38 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102d18:	a1 38 3c 11 80       	mov    0x80113c38,%eax
80102d1d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102d1f:	a1 34 3c 11 80       	mov    0x80113c34,%eax
  kmem.freelist = r;
80102d24:	89 1d 38 3c 11 80    	mov    %ebx,0x80113c38
  if(kmem.use_lock)
80102d2a:	85 c0                	test   %eax,%eax
80102d2c:	75 22                	jne    80102d50 <kfree+0x80>
    release(&kmem.lock);
}
80102d2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d31:	c9                   	leave  
80102d32:	c3                   	ret    
80102d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d37:	90                   	nop
    acquire(&kmem.lock);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 00 3c 11 80       	push   $0x80113c00
80102d40:	e8 7b 20 00 00       	call   80104dc0 <acquire>
80102d45:	83 c4 10             	add    $0x10,%esp
80102d48:	eb ce                	jmp    80102d18 <kfree+0x48>
80102d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102d50:	c7 45 08 00 3c 11 80 	movl   $0x80113c00,0x8(%ebp)
}
80102d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d5a:	c9                   	leave  
    release(&kmem.lock);
80102d5b:	e9 20 21 00 00       	jmp    80104e80 <release>
    panic("kfree");
80102d60:	83 ec 0c             	sub    $0xc,%esp
80102d63:	68 e6 7b 10 80       	push   $0x80107be6
80102d68:	e8 23 d6 ff ff       	call   80100390 <panic>
80102d6d:	8d 76 00             	lea    0x0(%esi),%esi

80102d70 <freerange>:
{
80102d70:	f3 0f 1e fb          	endbr32 
80102d74:	55                   	push   %ebp
80102d75:	89 e5                	mov    %esp,%ebp
80102d77:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102d78:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102d7b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102d7e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102d7f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102d85:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d8b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102d91:	39 de                	cmp    %ebx,%esi
80102d93:	72 1f                	jb     80102db4 <freerange+0x44>
80102d95:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102d98:	83 ec 0c             	sub    $0xc,%esp
80102d9b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102da1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102da7:	50                   	push   %eax
80102da8:	e8 23 ff ff ff       	call   80102cd0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dad:	83 c4 10             	add    $0x10,%esp
80102db0:	39 f3                	cmp    %esi,%ebx
80102db2:	76 e4                	jbe    80102d98 <freerange+0x28>
}
80102db4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102db7:	5b                   	pop    %ebx
80102db8:	5e                   	pop    %esi
80102db9:	5d                   	pop    %ebp
80102dba:	c3                   	ret    
80102dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dbf:	90                   	nop

80102dc0 <kinit1>:
{
80102dc0:	f3 0f 1e fb          	endbr32 
80102dc4:	55                   	push   %ebp
80102dc5:	89 e5                	mov    %esp,%ebp
80102dc7:	56                   	push   %esi
80102dc8:	53                   	push   %ebx
80102dc9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102dcc:	83 ec 08             	sub    $0x8,%esp
80102dcf:	68 ec 7b 10 80       	push   $0x80107bec
80102dd4:	68 00 3c 11 80       	push   $0x80113c00
80102dd9:	e8 62 1e 00 00       	call   80104c40 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102dde:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102de1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102de4:	c7 05 34 3c 11 80 00 	movl   $0x0,0x80113c34
80102deb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102dee:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102df4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102dfa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e00:	39 de                	cmp    %ebx,%esi
80102e02:	72 20                	jb     80102e24 <kinit1+0x64>
80102e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102e08:	83 ec 0c             	sub    $0xc,%esp
80102e0b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e17:	50                   	push   %eax
80102e18:	e8 b3 fe ff ff       	call   80102cd0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e1d:	83 c4 10             	add    $0x10,%esp
80102e20:	39 de                	cmp    %ebx,%esi
80102e22:	73 e4                	jae    80102e08 <kinit1+0x48>
}
80102e24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e27:	5b                   	pop    %ebx
80102e28:	5e                   	pop    %esi
80102e29:	5d                   	pop    %ebp
80102e2a:	c3                   	ret    
80102e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e2f:	90                   	nop

80102e30 <kinit2>:
{
80102e30:	f3 0f 1e fb          	endbr32 
80102e34:	55                   	push   %ebp
80102e35:	89 e5                	mov    %esp,%ebp
80102e37:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102e38:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102e3b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102e3e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102e3f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e45:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e51:	39 de                	cmp    %ebx,%esi
80102e53:	72 1f                	jb     80102e74 <kinit2+0x44>
80102e55:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102e58:	83 ec 0c             	sub    $0xc,%esp
80102e5b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102e67:	50                   	push   %eax
80102e68:	e8 63 fe ff ff       	call   80102cd0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e6d:	83 c4 10             	add    $0x10,%esp
80102e70:	39 de                	cmp    %ebx,%esi
80102e72:	73 e4                	jae    80102e58 <kinit2+0x28>
  kmem.use_lock = 1;
80102e74:	c7 05 34 3c 11 80 01 	movl   $0x1,0x80113c34
80102e7b:	00 00 00 
}
80102e7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e81:	5b                   	pop    %ebx
80102e82:	5e                   	pop    %esi
80102e83:	5d                   	pop    %ebp
80102e84:	c3                   	ret    
80102e85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e90 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102e90:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102e94:	a1 34 3c 11 80       	mov    0x80113c34,%eax
80102e99:	85 c0                	test   %eax,%eax
80102e9b:	75 1b                	jne    80102eb8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102e9d:	a1 38 3c 11 80       	mov    0x80113c38,%eax
  if(r)
80102ea2:	85 c0                	test   %eax,%eax
80102ea4:	74 0a                	je     80102eb0 <kalloc+0x20>
    kmem.freelist = r->next;
80102ea6:	8b 10                	mov    (%eax),%edx
80102ea8:	89 15 38 3c 11 80    	mov    %edx,0x80113c38
  if(kmem.use_lock)
80102eae:	c3                   	ret    
80102eaf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102eb0:	c3                   	ret    
80102eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102eb8:	55                   	push   %ebp
80102eb9:	89 e5                	mov    %esp,%ebp
80102ebb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102ebe:	68 00 3c 11 80       	push   $0x80113c00
80102ec3:	e8 f8 1e 00 00       	call   80104dc0 <acquire>
  r = kmem.freelist;
80102ec8:	a1 38 3c 11 80       	mov    0x80113c38,%eax
  if(r)
80102ecd:	8b 15 34 3c 11 80    	mov    0x80113c34,%edx
80102ed3:	83 c4 10             	add    $0x10,%esp
80102ed6:	85 c0                	test   %eax,%eax
80102ed8:	74 08                	je     80102ee2 <kalloc+0x52>
    kmem.freelist = r->next;
80102eda:	8b 08                	mov    (%eax),%ecx
80102edc:	89 0d 38 3c 11 80    	mov    %ecx,0x80113c38
  if(kmem.use_lock)
80102ee2:	85 d2                	test   %edx,%edx
80102ee4:	74 16                	je     80102efc <kalloc+0x6c>
    release(&kmem.lock);
80102ee6:	83 ec 0c             	sub    $0xc,%esp
80102ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102eec:	68 00 3c 11 80       	push   $0x80113c00
80102ef1:	e8 8a 1f 00 00       	call   80104e80 <release>
  return (char*)r;
80102ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	c9                   	leave  
80102efd:	c3                   	ret    
80102efe:	66 90                	xchg   %ax,%ax

80102f00 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102f00:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f04:	ba 64 00 00 00       	mov    $0x64,%edx
80102f09:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102f0a:	a8 01                	test   $0x1,%al
80102f0c:	0f 84 be 00 00 00    	je     80102fd0 <kbdgetc+0xd0>
{
80102f12:	55                   	push   %ebp
80102f13:	ba 60 00 00 00       	mov    $0x60,%edx
80102f18:	89 e5                	mov    %esp,%ebp
80102f1a:	53                   	push   %ebx
80102f1b:	ec                   	in     (%dx),%al
  return data;
80102f1c:	8b 1d d4 b5 10 80    	mov    0x8010b5d4,%ebx
    return -1;
  data = inb(KBDATAP);
80102f22:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102f25:	3c e0                	cmp    $0xe0,%al
80102f27:	74 57                	je     80102f80 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102f29:	89 d9                	mov    %ebx,%ecx
80102f2b:	83 e1 40             	and    $0x40,%ecx
80102f2e:	84 c0                	test   %al,%al
80102f30:	78 5e                	js     80102f90 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f32:	85 c9                	test   %ecx,%ecx
80102f34:	74 09                	je     80102f3f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f36:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f39:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102f3c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102f3f:	0f b6 8a 20 7d 10 80 	movzbl -0x7fef82e0(%edx),%ecx
  shift ^= togglecode[data];
80102f46:	0f b6 82 20 7c 10 80 	movzbl -0x7fef83e0(%edx),%eax
  shift |= shiftcode[data];
80102f4d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102f4f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f51:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102f53:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102f59:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102f5c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f5f:	8b 04 85 00 7c 10 80 	mov    -0x7fef8400(,%eax,4),%eax
80102f66:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102f6a:	74 0b                	je     80102f77 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102f6c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102f6f:	83 fa 19             	cmp    $0x19,%edx
80102f72:	77 44                	ja     80102fb8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102f74:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102f77:	5b                   	pop    %ebx
80102f78:	5d                   	pop    %ebp
80102f79:	c3                   	ret    
80102f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102f80:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102f83:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102f85:	89 1d d4 b5 10 80    	mov    %ebx,0x8010b5d4
}
80102f8b:	5b                   	pop    %ebx
80102f8c:	5d                   	pop    %ebp
80102f8d:	c3                   	ret    
80102f8e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102f90:	83 e0 7f             	and    $0x7f,%eax
80102f93:	85 c9                	test   %ecx,%ecx
80102f95:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102f98:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102f9a:	0f b6 8a 20 7d 10 80 	movzbl -0x7fef82e0(%edx),%ecx
80102fa1:	83 c9 40             	or     $0x40,%ecx
80102fa4:	0f b6 c9             	movzbl %cl,%ecx
80102fa7:	f7 d1                	not    %ecx
80102fa9:	21 d9                	and    %ebx,%ecx
}
80102fab:	5b                   	pop    %ebx
80102fac:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102fad:	89 0d d4 b5 10 80    	mov    %ecx,0x8010b5d4
}
80102fb3:	c3                   	ret    
80102fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102fb8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102fbb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102fbe:	5b                   	pop    %ebx
80102fbf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102fc0:	83 f9 1a             	cmp    $0x1a,%ecx
80102fc3:	0f 42 c2             	cmovb  %edx,%eax
}
80102fc6:	c3                   	ret    
80102fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fce:	66 90                	xchg   %ax,%ax
    return -1;
80102fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102fd5:	c3                   	ret    
80102fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fdd:	8d 76 00             	lea    0x0(%esi),%esi

80102fe0 <kbdintr>:

void
kbdintr(void)
{
80102fe0:	f3 0f 1e fb          	endbr32 
80102fe4:	55                   	push   %ebp
80102fe5:	89 e5                	mov    %esp,%ebp
80102fe7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102fea:	68 00 2f 10 80       	push   $0x80102f00
80102fef:	e8 7c dd ff ff       	call   80100d70 <consoleintr>
}
80102ff4:	83 c4 10             	add    $0x10,%esp
80102ff7:	c9                   	leave  
80102ff8:	c3                   	ret    
80102ff9:	66 90                	xchg   %ax,%ax
80102ffb:	66 90                	xchg   %ax,%ax
80102ffd:	66 90                	xchg   %ax,%ax
80102fff:	90                   	nop

80103000 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80103000:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80103004:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103009:	85 c0                	test   %eax,%eax
8010300b:	0f 84 c7 00 00 00    	je     801030d8 <lapicinit+0xd8>
  lapic[index] = value;
80103011:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103018:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010301b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010301e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103025:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103028:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010302b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103032:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103035:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103038:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010303f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103042:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103045:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010304c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010304f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103052:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103059:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010305c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010305f:	8b 50 30             	mov    0x30(%eax),%edx
80103062:	c1 ea 10             	shr    $0x10,%edx
80103065:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010306b:	75 73                	jne    801030e0 <lapicinit+0xe0>
  lapic[index] = value;
8010306d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103074:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103077:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010307a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80103081:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103084:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103087:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010308e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103091:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103094:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010309b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010309e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030a1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801030a8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030ae:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801030b5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801030b8:	8b 50 20             	mov    0x20(%eax),%edx
801030bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030bf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801030c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801030c6:	80 e6 10             	and    $0x10,%dh
801030c9:	75 f5                	jne    801030c0 <lapicinit+0xc0>
  lapic[index] = value;
801030cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801030d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801030d8:	c3                   	ret    
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801030e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801030e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801030ed:	e9 7b ff ff ff       	jmp    8010306d <lapicinit+0x6d>
801030f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103100 <lapicid>:

int
lapicid(void)
{
80103100:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103104:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103109:	85 c0                	test   %eax,%eax
8010310b:	74 0b                	je     80103118 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010310d:	8b 40 20             	mov    0x20(%eax),%eax
80103110:	c1 e8 18             	shr    $0x18,%eax
80103113:	c3                   	ret    
80103114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103118:	31 c0                	xor    %eax,%eax
}
8010311a:	c3                   	ret    
8010311b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010311f:	90                   	nop

80103120 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103120:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103124:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103129:	85 c0                	test   %eax,%eax
8010312b:	74 0d                	je     8010313a <lapiceoi+0x1a>
  lapic[index] = value;
8010312d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103134:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103137:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010313a:	c3                   	ret    
8010313b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010313f:	90                   	nop

80103140 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103140:	f3 0f 1e fb          	endbr32 
}
80103144:	c3                   	ret    
80103145:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010314c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103150 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103150:	f3 0f 1e fb          	endbr32 
80103154:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103155:	b8 0f 00 00 00       	mov    $0xf,%eax
8010315a:	ba 70 00 00 00       	mov    $0x70,%edx
8010315f:	89 e5                	mov    %esp,%ebp
80103161:	53                   	push   %ebx
80103162:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103165:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103168:	ee                   	out    %al,(%dx)
80103169:	b8 0a 00 00 00       	mov    $0xa,%eax
8010316e:	ba 71 00 00 00       	mov    $0x71,%edx
80103173:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103174:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103176:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103179:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010317f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103181:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103184:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103186:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103189:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010318c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103192:	a1 3c 3c 11 80       	mov    0x80113c3c,%eax
80103197:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010319d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031a0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801031a7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031aa:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031ad:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801031b4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031b7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031ba:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031c0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031c3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031cc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031d2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031d5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801031db:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801031dc:	8b 40 20             	mov    0x20(%eax),%eax
}
801031df:	5d                   	pop    %ebp
801031e0:	c3                   	ret    
801031e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop

801031f0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801031f0:	f3 0f 1e fb          	endbr32 
801031f4:	55                   	push   %ebp
801031f5:	b8 0b 00 00 00       	mov    $0xb,%eax
801031fa:	ba 70 00 00 00       	mov    $0x70,%edx
801031ff:	89 e5                	mov    %esp,%ebp
80103201:	57                   	push   %edi
80103202:	56                   	push   %esi
80103203:	53                   	push   %ebx
80103204:	83 ec 4c             	sub    $0x4c,%esp
80103207:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103208:	ba 71 00 00 00       	mov    $0x71,%edx
8010320d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010320e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103211:	bb 70 00 00 00       	mov    $0x70,%ebx
80103216:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103220:	31 c0                	xor    %eax,%eax
80103222:	89 da                	mov    %ebx,%edx
80103224:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103225:	b9 71 00 00 00       	mov    $0x71,%ecx
8010322a:	89 ca                	mov    %ecx,%edx
8010322c:	ec                   	in     (%dx),%al
8010322d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103230:	89 da                	mov    %ebx,%edx
80103232:	b8 02 00 00 00       	mov    $0x2,%eax
80103237:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103238:	89 ca                	mov    %ecx,%edx
8010323a:	ec                   	in     (%dx),%al
8010323b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010323e:	89 da                	mov    %ebx,%edx
80103240:	b8 04 00 00 00       	mov    $0x4,%eax
80103245:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103246:	89 ca                	mov    %ecx,%edx
80103248:	ec                   	in     (%dx),%al
80103249:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010324c:	89 da                	mov    %ebx,%edx
8010324e:	b8 07 00 00 00       	mov    $0x7,%eax
80103253:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103254:	89 ca                	mov    %ecx,%edx
80103256:	ec                   	in     (%dx),%al
80103257:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010325a:	89 da                	mov    %ebx,%edx
8010325c:	b8 08 00 00 00       	mov    $0x8,%eax
80103261:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103262:	89 ca                	mov    %ecx,%edx
80103264:	ec                   	in     (%dx),%al
80103265:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103267:	89 da                	mov    %ebx,%edx
80103269:	b8 09 00 00 00       	mov    $0x9,%eax
8010326e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010326f:	89 ca                	mov    %ecx,%edx
80103271:	ec                   	in     (%dx),%al
80103272:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103274:	89 da                	mov    %ebx,%edx
80103276:	b8 0a 00 00 00       	mov    $0xa,%eax
8010327b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010327c:	89 ca                	mov    %ecx,%edx
8010327e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010327f:	84 c0                	test   %al,%al
80103281:	78 9d                	js     80103220 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103283:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103287:	89 fa                	mov    %edi,%edx
80103289:	0f b6 fa             	movzbl %dl,%edi
8010328c:	89 f2                	mov    %esi,%edx
8010328e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103291:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103295:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103298:	89 da                	mov    %ebx,%edx
8010329a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010329d:	89 45 bc             	mov    %eax,-0x44(%ebp)
801032a0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801032a4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801032a7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801032aa:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801032ae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801032b1:	31 c0                	xor    %eax,%eax
801032b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032b4:	89 ca                	mov    %ecx,%edx
801032b6:	ec                   	in     (%dx),%al
801032b7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ba:	89 da                	mov    %ebx,%edx
801032bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
801032bf:	b8 02 00 00 00       	mov    $0x2,%eax
801032c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032c5:	89 ca                	mov    %ecx,%edx
801032c7:	ec                   	in     (%dx),%al
801032c8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032cb:	89 da                	mov    %ebx,%edx
801032cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801032d0:	b8 04 00 00 00       	mov    $0x4,%eax
801032d5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d6:	89 ca                	mov    %ecx,%edx
801032d8:	ec                   	in     (%dx),%al
801032d9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032dc:	89 da                	mov    %ebx,%edx
801032de:	89 45 d8             	mov    %eax,-0x28(%ebp)
801032e1:	b8 07 00 00 00       	mov    $0x7,%eax
801032e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032e7:	89 ca                	mov    %ecx,%edx
801032e9:	ec                   	in     (%dx),%al
801032ea:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ed:	89 da                	mov    %ebx,%edx
801032ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
801032f2:	b8 08 00 00 00       	mov    $0x8,%eax
801032f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032f8:	89 ca                	mov    %ecx,%edx
801032fa:	ec                   	in     (%dx),%al
801032fb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fe:	89 da                	mov    %ebx,%edx
80103300:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103303:	b8 09 00 00 00       	mov    $0x9,%eax
80103308:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103309:	89 ca                	mov    %ecx,%edx
8010330b:	ec                   	in     (%dx),%al
8010330c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010330f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103312:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103315:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103318:	6a 18                	push   $0x18
8010331a:	50                   	push   %eax
8010331b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010331e:	50                   	push   %eax
8010331f:	e8 fc 1b 00 00       	call   80104f20 <memcmp>
80103324:	83 c4 10             	add    $0x10,%esp
80103327:	85 c0                	test   %eax,%eax
80103329:	0f 85 f1 fe ff ff    	jne    80103220 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010332f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103333:	75 78                	jne    801033ad <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103335:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103338:	89 c2                	mov    %eax,%edx
8010333a:	83 e0 0f             	and    $0xf,%eax
8010333d:	c1 ea 04             	shr    $0x4,%edx
80103340:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103343:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103346:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103349:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010334c:	89 c2                	mov    %eax,%edx
8010334e:	83 e0 0f             	and    $0xf,%eax
80103351:	c1 ea 04             	shr    $0x4,%edx
80103354:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103357:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010335a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010335d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103360:	89 c2                	mov    %eax,%edx
80103362:	83 e0 0f             	and    $0xf,%eax
80103365:	c1 ea 04             	shr    $0x4,%edx
80103368:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010336b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010336e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103371:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103374:	89 c2                	mov    %eax,%edx
80103376:	83 e0 0f             	and    $0xf,%eax
80103379:	c1 ea 04             	shr    $0x4,%edx
8010337c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010337f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103382:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103385:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103388:	89 c2                	mov    %eax,%edx
8010338a:	83 e0 0f             	and    $0xf,%eax
8010338d:	c1 ea 04             	shr    $0x4,%edx
80103390:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103393:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103396:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103399:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010339c:	89 c2                	mov    %eax,%edx
8010339e:	83 e0 0f             	and    $0xf,%eax
801033a1:	c1 ea 04             	shr    $0x4,%edx
801033a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801033a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801033ad:	8b 75 08             	mov    0x8(%ebp),%esi
801033b0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033b3:	89 06                	mov    %eax,(%esi)
801033b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033b8:	89 46 04             	mov    %eax,0x4(%esi)
801033bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033be:	89 46 08             	mov    %eax,0x8(%esi)
801033c1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801033c4:	89 46 0c             	mov    %eax,0xc(%esi)
801033c7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033ca:	89 46 10             	mov    %eax,0x10(%esi)
801033cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033d0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801033d3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801033da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033dd:	5b                   	pop    %ebx
801033de:	5e                   	pop    %esi
801033df:	5f                   	pop    %edi
801033e0:	5d                   	pop    %ebp
801033e1:	c3                   	ret    
801033e2:	66 90                	xchg   %ax,%ax
801033e4:	66 90                	xchg   %ax,%ax
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033f0:	8b 0d 88 3c 11 80    	mov    0x80113c88,%ecx
801033f6:	85 c9                	test   %ecx,%ecx
801033f8:	0f 8e 8a 00 00 00    	jle    80103488 <install_trans+0x98>
{
801033fe:	55                   	push   %ebp
801033ff:	89 e5                	mov    %esp,%ebp
80103401:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103402:	31 ff                	xor    %edi,%edi
{
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 0c             	sub    $0xc,%esp
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103410:	a1 74 3c 11 80       	mov    0x80113c74,%eax
80103415:	83 ec 08             	sub    $0x8,%esp
80103418:	01 f8                	add    %edi,%eax
8010341a:	83 c0 01             	add    $0x1,%eax
8010341d:	50                   	push   %eax
8010341e:	ff 35 84 3c 11 80    	pushl  0x80113c84
80103424:	e8 a7 cc ff ff       	call   801000d0 <bread>
80103429:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010342b:	58                   	pop    %eax
8010342c:	5a                   	pop    %edx
8010342d:	ff 34 bd 8c 3c 11 80 	pushl  -0x7feec374(,%edi,4)
80103434:	ff 35 84 3c 11 80    	pushl  0x80113c84
  for (tail = 0; tail < log.lh.n; tail++) {
8010343a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010343d:	e8 8e cc ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103442:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103445:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103447:	8d 46 5c             	lea    0x5c(%esi),%eax
8010344a:	68 00 02 00 00       	push   $0x200
8010344f:	50                   	push   %eax
80103450:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103453:	50                   	push   %eax
80103454:	e8 17 1b 00 00       	call   80104f70 <memmove>
    bwrite(dbuf);  // write dst to disk
80103459:	89 1c 24             	mov    %ebx,(%esp)
8010345c:	e8 4f cd ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103461:	89 34 24             	mov    %esi,(%esp)
80103464:	e8 87 cd ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103469:	89 1c 24             	mov    %ebx,(%esp)
8010346c:	e8 7f cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103471:	83 c4 10             	add    $0x10,%esp
80103474:	39 3d 88 3c 11 80    	cmp    %edi,0x80113c88
8010347a:	7f 94                	jg     80103410 <install_trans+0x20>
  }
}
8010347c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010347f:	5b                   	pop    %ebx
80103480:	5e                   	pop    %esi
80103481:	5f                   	pop    %edi
80103482:	5d                   	pop    %ebp
80103483:	c3                   	ret    
80103484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103488:	c3                   	ret    
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103490 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	53                   	push   %ebx
80103494:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103497:	ff 35 74 3c 11 80    	pushl  0x80113c74
8010349d:	ff 35 84 3c 11 80    	pushl  0x80113c84
801034a3:	e8 28 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034a8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801034ab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801034ad:	a1 88 3c 11 80       	mov    0x80113c88,%eax
801034b2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801034b5:	85 c0                	test   %eax,%eax
801034b7:	7e 19                	jle    801034d2 <write_head+0x42>
801034b9:	31 d2                	xor    %edx,%edx
801034bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034bf:	90                   	nop
    hb->block[i] = log.lh.block[i];
801034c0:	8b 0c 95 8c 3c 11 80 	mov    -0x7feec374(,%edx,4),%ecx
801034c7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034cb:	83 c2 01             	add    $0x1,%edx
801034ce:	39 d0                	cmp    %edx,%eax
801034d0:	75 ee                	jne    801034c0 <write_head+0x30>
  }
  bwrite(buf);
801034d2:	83 ec 0c             	sub    $0xc,%esp
801034d5:	53                   	push   %ebx
801034d6:	e8 d5 cc ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801034db:	89 1c 24             	mov    %ebx,(%esp)
801034de:	e8 0d cd ff ff       	call   801001f0 <brelse>
}
801034e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034e6:	83 c4 10             	add    $0x10,%esp
801034e9:	c9                   	leave  
801034ea:	c3                   	ret    
801034eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034ef:	90                   	nop

801034f0 <initlog>:
{
801034f0:	f3 0f 1e fb          	endbr32 
801034f4:	55                   	push   %ebp
801034f5:	89 e5                	mov    %esp,%ebp
801034f7:	53                   	push   %ebx
801034f8:	83 ec 2c             	sub    $0x2c,%esp
801034fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801034fe:	68 20 7e 10 80       	push   $0x80107e20
80103503:	68 40 3c 11 80       	push   $0x80113c40
80103508:	e8 33 17 00 00       	call   80104c40 <initlock>
  readsb(dev, &sb);
8010350d:	58                   	pop    %eax
8010350e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103511:	5a                   	pop    %edx
80103512:	50                   	push   %eax
80103513:	53                   	push   %ebx
80103514:	e8 47 e8 ff ff       	call   80101d60 <readsb>
  log.start = sb.logstart;
80103519:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010351c:	59                   	pop    %ecx
  log.dev = dev;
8010351d:	89 1d 84 3c 11 80    	mov    %ebx,0x80113c84
  log.size = sb.nlog;
80103523:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103526:	a3 74 3c 11 80       	mov    %eax,0x80113c74
  log.size = sb.nlog;
8010352b:	89 15 78 3c 11 80    	mov    %edx,0x80113c78
  struct buf *buf = bread(log.dev, log.start);
80103531:	5a                   	pop    %edx
80103532:	50                   	push   %eax
80103533:	53                   	push   %ebx
80103534:	e8 97 cb ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103539:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010353c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010353f:	89 0d 88 3c 11 80    	mov    %ecx,0x80113c88
  for (i = 0; i < log.lh.n; i++) {
80103545:	85 c9                	test   %ecx,%ecx
80103547:	7e 19                	jle    80103562 <initlog+0x72>
80103549:	31 d2                	xor    %edx,%edx
8010354b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103550:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103554:	89 1c 95 8c 3c 11 80 	mov    %ebx,-0x7feec374(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010355b:	83 c2 01             	add    $0x1,%edx
8010355e:	39 d1                	cmp    %edx,%ecx
80103560:	75 ee                	jne    80103550 <initlog+0x60>
  brelse(buf);
80103562:	83 ec 0c             	sub    $0xc,%esp
80103565:	50                   	push   %eax
80103566:	e8 85 cc ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010356b:	e8 80 fe ff ff       	call   801033f0 <install_trans>
  log.lh.n = 0;
80103570:	c7 05 88 3c 11 80 00 	movl   $0x0,0x80113c88
80103577:	00 00 00 
  write_head(); // clear the log
8010357a:	e8 11 ff ff ff       	call   80103490 <write_head>
}
8010357f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103582:	83 c4 10             	add    $0x10,%esp
80103585:	c9                   	leave  
80103586:	c3                   	ret    
80103587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010358e:	66 90                	xchg   %ax,%ax

80103590 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103590:	f3 0f 1e fb          	endbr32 
80103594:	55                   	push   %ebp
80103595:	89 e5                	mov    %esp,%ebp
80103597:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010359a:	68 40 3c 11 80       	push   $0x80113c40
8010359f:	e8 1c 18 00 00       	call   80104dc0 <acquire>
801035a4:	83 c4 10             	add    $0x10,%esp
801035a7:	eb 1c                	jmp    801035c5 <begin_op+0x35>
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801035b0:	83 ec 08             	sub    $0x8,%esp
801035b3:	68 40 3c 11 80       	push   $0x80113c40
801035b8:	68 40 3c 11 80       	push   $0x80113c40
801035bd:	e8 be 11 00 00       	call   80104780 <sleep>
801035c2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801035c5:	a1 80 3c 11 80       	mov    0x80113c80,%eax
801035ca:	85 c0                	test   %eax,%eax
801035cc:	75 e2                	jne    801035b0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035ce:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
801035d3:	8b 15 88 3c 11 80    	mov    0x80113c88,%edx
801035d9:	83 c0 01             	add    $0x1,%eax
801035dc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801035df:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801035e2:	83 fa 1e             	cmp    $0x1e,%edx
801035e5:	7f c9                	jg     801035b0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801035e7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801035ea:	a3 7c 3c 11 80       	mov    %eax,0x80113c7c
      release(&log.lock);
801035ef:	68 40 3c 11 80       	push   $0x80113c40
801035f4:	e8 87 18 00 00       	call   80104e80 <release>
      break;
    }
  }
}
801035f9:	83 c4 10             	add    $0x10,%esp
801035fc:	c9                   	leave  
801035fd:	c3                   	ret    
801035fe:	66 90                	xchg   %ax,%ax

80103600 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103600:	f3 0f 1e fb          	endbr32 
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	57                   	push   %edi
80103608:	56                   	push   %esi
80103609:	53                   	push   %ebx
8010360a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010360d:	68 40 3c 11 80       	push   $0x80113c40
80103612:	e8 a9 17 00 00       	call   80104dc0 <acquire>
  log.outstanding -= 1;
80103617:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
  if(log.committing)
8010361c:	8b 35 80 3c 11 80    	mov    0x80113c80,%esi
80103622:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103625:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103628:	89 1d 7c 3c 11 80    	mov    %ebx,0x80113c7c
  if(log.committing)
8010362e:	85 f6                	test   %esi,%esi
80103630:	0f 85 1e 01 00 00    	jne    80103754 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103636:	85 db                	test   %ebx,%ebx
80103638:	0f 85 f2 00 00 00    	jne    80103730 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010363e:	c7 05 80 3c 11 80 01 	movl   $0x1,0x80113c80
80103645:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	68 40 3c 11 80       	push   $0x80113c40
80103650:	e8 2b 18 00 00       	call   80104e80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103655:	8b 0d 88 3c 11 80    	mov    0x80113c88,%ecx
8010365b:	83 c4 10             	add    $0x10,%esp
8010365e:	85 c9                	test   %ecx,%ecx
80103660:	7f 3e                	jg     801036a0 <end_op+0xa0>
    acquire(&log.lock);
80103662:	83 ec 0c             	sub    $0xc,%esp
80103665:	68 40 3c 11 80       	push   $0x80113c40
8010366a:	e8 51 17 00 00       	call   80104dc0 <acquire>
    wakeup(&log);
8010366f:	c7 04 24 40 3c 11 80 	movl   $0x80113c40,(%esp)
    log.committing = 0;
80103676:	c7 05 80 3c 11 80 00 	movl   $0x0,0x80113c80
8010367d:	00 00 00 
    wakeup(&log);
80103680:	e8 bb 12 00 00       	call   80104940 <wakeup>
    release(&log.lock);
80103685:	c7 04 24 40 3c 11 80 	movl   $0x80113c40,(%esp)
8010368c:	e8 ef 17 00 00       	call   80104e80 <release>
80103691:	83 c4 10             	add    $0x10,%esp
}
80103694:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103697:	5b                   	pop    %ebx
80103698:	5e                   	pop    %esi
80103699:	5f                   	pop    %edi
8010369a:	5d                   	pop    %ebp
8010369b:	c3                   	ret    
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036a0:	a1 74 3c 11 80       	mov    0x80113c74,%eax
801036a5:	83 ec 08             	sub    $0x8,%esp
801036a8:	01 d8                	add    %ebx,%eax
801036aa:	83 c0 01             	add    $0x1,%eax
801036ad:	50                   	push   %eax
801036ae:	ff 35 84 3c 11 80    	pushl  0x80113c84
801036b4:	e8 17 ca ff ff       	call   801000d0 <bread>
801036b9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036bb:	58                   	pop    %eax
801036bc:	5a                   	pop    %edx
801036bd:	ff 34 9d 8c 3c 11 80 	pushl  -0x7feec374(,%ebx,4)
801036c4:	ff 35 84 3c 11 80    	pushl  0x80113c84
  for (tail = 0; tail < log.lh.n; tail++) {
801036ca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036cd:	e8 fe c9 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801036d2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036d5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801036d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801036da:	68 00 02 00 00       	push   $0x200
801036df:	50                   	push   %eax
801036e0:	8d 46 5c             	lea    0x5c(%esi),%eax
801036e3:	50                   	push   %eax
801036e4:	e8 87 18 00 00       	call   80104f70 <memmove>
    bwrite(to);  // write the log
801036e9:	89 34 24             	mov    %esi,(%esp)
801036ec:	e8 bf ca ff ff       	call   801001b0 <bwrite>
    brelse(from);
801036f1:	89 3c 24             	mov    %edi,(%esp)
801036f4:	e8 f7 ca ff ff       	call   801001f0 <brelse>
    brelse(to);
801036f9:	89 34 24             	mov    %esi,(%esp)
801036fc:	e8 ef ca ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103701:	83 c4 10             	add    $0x10,%esp
80103704:	3b 1d 88 3c 11 80    	cmp    0x80113c88,%ebx
8010370a:	7c 94                	jl     801036a0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010370c:	e8 7f fd ff ff       	call   80103490 <write_head>
    install_trans(); // Now install writes to home locations
80103711:	e8 da fc ff ff       	call   801033f0 <install_trans>
    log.lh.n = 0;
80103716:	c7 05 88 3c 11 80 00 	movl   $0x0,0x80113c88
8010371d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103720:	e8 6b fd ff ff       	call   80103490 <write_head>
80103725:	e9 38 ff ff ff       	jmp    80103662 <end_op+0x62>
8010372a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	68 40 3c 11 80       	push   $0x80113c40
80103738:	e8 03 12 00 00       	call   80104940 <wakeup>
  release(&log.lock);
8010373d:	c7 04 24 40 3c 11 80 	movl   $0x80113c40,(%esp)
80103744:	e8 37 17 00 00       	call   80104e80 <release>
80103749:	83 c4 10             	add    $0x10,%esp
}
8010374c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010374f:	5b                   	pop    %ebx
80103750:	5e                   	pop    %esi
80103751:	5f                   	pop    %edi
80103752:	5d                   	pop    %ebp
80103753:	c3                   	ret    
    panic("log.committing");
80103754:	83 ec 0c             	sub    $0xc,%esp
80103757:	68 24 7e 10 80       	push   $0x80107e24
8010375c:	e8 2f cc ff ff       	call   80100390 <panic>
80103761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010376f:	90                   	nop

80103770 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103770:	f3 0f 1e fb          	endbr32 
80103774:	55                   	push   %ebp
80103775:	89 e5                	mov    %esp,%ebp
80103777:	53                   	push   %ebx
80103778:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010377b:	8b 15 88 3c 11 80    	mov    0x80113c88,%edx
{
80103781:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103784:	83 fa 1d             	cmp    $0x1d,%edx
80103787:	0f 8f 91 00 00 00    	jg     8010381e <log_write+0xae>
8010378d:	a1 78 3c 11 80       	mov    0x80113c78,%eax
80103792:	83 e8 01             	sub    $0x1,%eax
80103795:	39 c2                	cmp    %eax,%edx
80103797:	0f 8d 81 00 00 00    	jge    8010381e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010379d:	a1 7c 3c 11 80       	mov    0x80113c7c,%eax
801037a2:	85 c0                	test   %eax,%eax
801037a4:	0f 8e 81 00 00 00    	jle    8010382b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801037aa:	83 ec 0c             	sub    $0xc,%esp
801037ad:	68 40 3c 11 80       	push   $0x80113c40
801037b2:	e8 09 16 00 00       	call   80104dc0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801037b7:	8b 15 88 3c 11 80    	mov    0x80113c88,%edx
801037bd:	83 c4 10             	add    $0x10,%esp
801037c0:	85 d2                	test   %edx,%edx
801037c2:	7e 4e                	jle    80103812 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037c4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801037c7:	31 c0                	xor    %eax,%eax
801037c9:	eb 0c                	jmp    801037d7 <log_write+0x67>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
801037d0:	83 c0 01             	add    $0x1,%eax
801037d3:	39 c2                	cmp    %eax,%edx
801037d5:	74 29                	je     80103800 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037d7:	39 0c 85 8c 3c 11 80 	cmp    %ecx,-0x7feec374(,%eax,4)
801037de:	75 f0                	jne    801037d0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801037e0:	89 0c 85 8c 3c 11 80 	mov    %ecx,-0x7feec374(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801037e7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801037ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801037ed:	c7 45 08 40 3c 11 80 	movl   $0x80113c40,0x8(%ebp)
}
801037f4:	c9                   	leave  
  release(&log.lock);
801037f5:	e9 86 16 00 00       	jmp    80104e80 <release>
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103800:	89 0c 95 8c 3c 11 80 	mov    %ecx,-0x7feec374(,%edx,4)
    log.lh.n++;
80103807:	83 c2 01             	add    $0x1,%edx
8010380a:	89 15 88 3c 11 80    	mov    %edx,0x80113c88
80103810:	eb d5                	jmp    801037e7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103812:	8b 43 08             	mov    0x8(%ebx),%eax
80103815:	a3 8c 3c 11 80       	mov    %eax,0x80113c8c
  if (i == log.lh.n)
8010381a:	75 cb                	jne    801037e7 <log_write+0x77>
8010381c:	eb e9                	jmp    80103807 <log_write+0x97>
    panic("too big a transaction");
8010381e:	83 ec 0c             	sub    $0xc,%esp
80103821:	68 33 7e 10 80       	push   $0x80107e33
80103826:	e8 65 cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010382b:	83 ec 0c             	sub    $0xc,%esp
8010382e:	68 49 7e 10 80       	push   $0x80107e49
80103833:	e8 58 cb ff ff       	call   80100390 <panic>
80103838:	66 90                	xchg   %ax,%ax
8010383a:	66 90                	xchg   %ax,%ax
8010383c:	66 90                	xchg   %ax,%ax
8010383e:	66 90                	xchg   %ax,%ax

80103840 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	53                   	push   %ebx
80103844:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103847:	e8 54 09 00 00       	call   801041a0 <cpuid>
8010384c:	89 c3                	mov    %eax,%ebx
8010384e:	e8 4d 09 00 00       	call   801041a0 <cpuid>
80103853:	83 ec 04             	sub    $0x4,%esp
80103856:	53                   	push   %ebx
80103857:	50                   	push   %eax
80103858:	68 64 7e 10 80       	push   $0x80107e64
8010385d:	e8 ee d0 ff ff       	call   80100950 <cprintf>
  idtinit();       // load idt register
80103862:	e8 19 29 00 00       	call   80106180 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103867:	e8 c4 08 00 00       	call   80104130 <mycpu>
8010386c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010386e:	b8 01 00 00 00       	mov    $0x1,%eax
80103873:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010387a:	e8 11 0c 00 00       	call   80104490 <scheduler>
8010387f:	90                   	nop

80103880 <mpenter>:
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010388a:	e8 c1 39 00 00       	call   80107250 <switchkvm>
  seginit();
8010388f:	e8 2c 39 00 00       	call   801071c0 <seginit>
  lapicinit();
80103894:	e8 67 f7 ff ff       	call   80103000 <lapicinit>
  mpmain();
80103899:	e8 a2 ff ff ff       	call   80103840 <mpmain>
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <main>:
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038a8:	83 e4 f0             	and    $0xfffffff0,%esp
801038ab:	ff 71 fc             	pushl  -0x4(%ecx)
801038ae:	55                   	push   %ebp
801038af:	89 e5                	mov    %esp,%ebp
801038b1:	53                   	push   %ebx
801038b2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038b3:	83 ec 08             	sub    $0x8,%esp
801038b6:	68 00 00 40 80       	push   $0x80400000
801038bb:	68 68 6a 11 80       	push   $0x80116a68
801038c0:	e8 fb f4 ff ff       	call   80102dc0 <kinit1>
  kvmalloc();      // kernel page table
801038c5:	e8 66 3e 00 00       	call   80107730 <kvmalloc>
  mpinit();        // detect other processors
801038ca:	e8 81 01 00 00       	call   80103a50 <mpinit>
  lapicinit();     // interrupt controller
801038cf:	e8 2c f7 ff ff       	call   80103000 <lapicinit>
  seginit();       // segment descriptors
801038d4:	e8 e7 38 00 00       	call   801071c0 <seginit>
  picinit();       // disable pic
801038d9:	e8 52 03 00 00       	call   80103c30 <picinit>
  ioapicinit();    // another interrupt controller
801038de:	e8 fd f2 ff ff       	call   80102be0 <ioapicinit>
  consoleinit();   // console hardware
801038e3:	e8 a8 d9 ff ff       	call   80101290 <consoleinit>
  uartinit();      // serial port
801038e8:	e8 93 2b 00 00       	call   80106480 <uartinit>
  pinit();         // process table
801038ed:	e8 1e 08 00 00       	call   80104110 <pinit>
  tvinit();        // trap vectors
801038f2:	e8 09 28 00 00       	call   80106100 <tvinit>
  binit();         // buffer cache
801038f7:	e8 44 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801038fc:	e8 3f dd ff ff       	call   80101640 <fileinit>
  ideinit();       // disk 
80103901:	e8 aa f0 ff ff       	call   801029b0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103906:	83 c4 0c             	add    $0xc,%esp
80103909:	68 8a 00 00 00       	push   $0x8a
8010390e:	68 8c b4 10 80       	push   $0x8010b48c
80103913:	68 00 70 00 80       	push   $0x80007000
80103918:	e8 53 16 00 00       	call   80104f70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010391d:	83 c4 10             	add    $0x10,%esp
80103920:	69 05 c0 42 11 80 b0 	imul   $0xb0,0x801142c0,%eax
80103927:	00 00 00 
8010392a:	05 40 3d 11 80       	add    $0x80113d40,%eax
8010392f:	3d 40 3d 11 80       	cmp    $0x80113d40,%eax
80103934:	76 7a                	jbe    801039b0 <main+0x110>
80103936:	bb 40 3d 11 80       	mov    $0x80113d40,%ebx
8010393b:	eb 1c                	jmp    80103959 <main+0xb9>
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
80103940:	69 05 c0 42 11 80 b0 	imul   $0xb0,0x801142c0,%eax
80103947:	00 00 00 
8010394a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103950:	05 40 3d 11 80       	add    $0x80113d40,%eax
80103955:	39 c3                	cmp    %eax,%ebx
80103957:	73 57                	jae    801039b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103959:	e8 d2 07 00 00       	call   80104130 <mycpu>
8010395e:	39 c3                	cmp    %eax,%ebx
80103960:	74 de                	je     80103940 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103962:	e8 29 f5 ff ff       	call   80102e90 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103967:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010396a:	c7 05 f8 6f 00 80 80 	movl   $0x80103880,0x80006ff8
80103971:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103974:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010397b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010397e:	05 00 10 00 00       	add    $0x1000,%eax
80103983:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103988:	0f b6 03             	movzbl (%ebx),%eax
8010398b:	68 00 70 00 00       	push   $0x7000
80103990:	50                   	push   %eax
80103991:	e8 ba f7 ff ff       	call   80103150 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801039a6:	85 c0                	test   %eax,%eax
801039a8:	74 f6                	je     801039a0 <main+0x100>
801039aa:	eb 94                	jmp    80103940 <main+0xa0>
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039b0:	83 ec 08             	sub    $0x8,%esp
801039b3:	68 00 00 00 8e       	push   $0x8e000000
801039b8:	68 00 00 40 80       	push   $0x80400000
801039bd:	e8 6e f4 ff ff       	call   80102e30 <kinit2>
  userinit();      // first user process
801039c2:	e8 29 08 00 00       	call   801041f0 <userinit>
  mpmain();        // finish this processor's setup
801039c7:	e8 74 fe ff ff       	call   80103840 <mpmain>
801039cc:	66 90                	xchg   %ax,%ax
801039ce:	66 90                	xchg   %ax,%ax

801039d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	57                   	push   %edi
801039d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801039d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801039db:	53                   	push   %ebx
  e = addr+len;
801039dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801039df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801039e2:	39 de                	cmp    %ebx,%esi
801039e4:	72 10                	jb     801039f6 <mpsearch1+0x26>
801039e6:	eb 50                	jmp    80103a38 <mpsearch1+0x68>
801039e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ef:	90                   	nop
801039f0:	89 fe                	mov    %edi,%esi
801039f2:	39 fb                	cmp    %edi,%ebx
801039f4:	76 42                	jbe    80103a38 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039f6:	83 ec 04             	sub    $0x4,%esp
801039f9:	8d 7e 10             	lea    0x10(%esi),%edi
801039fc:	6a 04                	push   $0x4
801039fe:	68 78 7e 10 80       	push   $0x80107e78
80103a03:	56                   	push   %esi
80103a04:	e8 17 15 00 00       	call   80104f20 <memcmp>
80103a09:	83 c4 10             	add    $0x10,%esp
80103a0c:	85 c0                	test   %eax,%eax
80103a0e:	75 e0                	jne    801039f0 <mpsearch1+0x20>
80103a10:	89 f2                	mov    %esi,%edx
80103a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103a18:	0f b6 0a             	movzbl (%edx),%ecx
80103a1b:	83 c2 01             	add    $0x1,%edx
80103a1e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103a20:	39 fa                	cmp    %edi,%edx
80103a22:	75 f4                	jne    80103a18 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a24:	84 c0                	test   %al,%al
80103a26:	75 c8                	jne    801039f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a2b:	89 f0                	mov    %esi,%eax
80103a2d:	5b                   	pop    %ebx
80103a2e:	5e                   	pop    %esi
80103a2f:	5f                   	pop    %edi
80103a30:	5d                   	pop    %ebp
80103a31:	c3                   	ret    
80103a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103a3b:	31 f6                	xor    %esi,%esi
}
80103a3d:	5b                   	pop    %ebx
80103a3e:	89 f0                	mov    %esi,%eax
80103a40:	5e                   	pop    %esi
80103a41:	5f                   	pop    %edi
80103a42:	5d                   	pop    %ebp
80103a43:	c3                   	ret    
80103a44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a4f:	90                   	nop

80103a50 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103a50:	f3 0f 1e fb          	endbr32 
80103a54:	55                   	push   %ebp
80103a55:	89 e5                	mov    %esp,%ebp
80103a57:	57                   	push   %edi
80103a58:	56                   	push   %esi
80103a59:	53                   	push   %ebx
80103a5a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a5d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103a64:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103a6b:	c1 e0 08             	shl    $0x8,%eax
80103a6e:	09 d0                	or     %edx,%eax
80103a70:	c1 e0 04             	shl    $0x4,%eax
80103a73:	75 1b                	jne    80103a90 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a75:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103a7c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103a83:	c1 e0 08             	shl    $0x8,%eax
80103a86:	09 d0                	or     %edx,%eax
80103a88:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103a8b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103a90:	ba 00 04 00 00       	mov    $0x400,%edx
80103a95:	e8 36 ff ff ff       	call   801039d0 <mpsearch1>
80103a9a:	89 c6                	mov    %eax,%esi
80103a9c:	85 c0                	test   %eax,%eax
80103a9e:	0f 84 4c 01 00 00    	je     80103bf0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103aa4:	8b 5e 04             	mov    0x4(%esi),%ebx
80103aa7:	85 db                	test   %ebx,%ebx
80103aa9:	0f 84 61 01 00 00    	je     80103c10 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103aaf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ab2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103ab8:	6a 04                	push   $0x4
80103aba:	68 7d 7e 10 80       	push   $0x80107e7d
80103abf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ac3:	e8 58 14 00 00       	call   80104f20 <memcmp>
80103ac8:	83 c4 10             	add    $0x10,%esp
80103acb:	85 c0                	test   %eax,%eax
80103acd:	0f 85 3d 01 00 00    	jne    80103c10 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103ad3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103ada:	3c 01                	cmp    $0x1,%al
80103adc:	74 08                	je     80103ae6 <mpinit+0x96>
80103ade:	3c 04                	cmp    $0x4,%al
80103ae0:	0f 85 2a 01 00 00    	jne    80103c10 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103ae6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103aed:	66 85 d2             	test   %dx,%dx
80103af0:	74 26                	je     80103b18 <mpinit+0xc8>
80103af2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103af5:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103af7:	31 d2                	xor    %edx,%edx
80103af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103b00:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103b07:	83 c0 01             	add    $0x1,%eax
80103b0a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103b0c:	39 f8                	cmp    %edi,%eax
80103b0e:	75 f0                	jne    80103b00 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103b10:	84 d2                	test   %dl,%dl
80103b12:	0f 85 f8 00 00 00    	jne    80103c10 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103b18:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103b1e:	a3 3c 3c 11 80       	mov    %eax,0x80113c3c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b23:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103b29:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103b30:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b35:	03 55 e4             	add    -0x1c(%ebp),%edx
80103b38:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b3f:	90                   	nop
80103b40:	39 c2                	cmp    %eax,%edx
80103b42:	76 15                	jbe    80103b59 <mpinit+0x109>
    switch(*p){
80103b44:	0f b6 08             	movzbl (%eax),%ecx
80103b47:	80 f9 02             	cmp    $0x2,%cl
80103b4a:	74 5c                	je     80103ba8 <mpinit+0x158>
80103b4c:	77 42                	ja     80103b90 <mpinit+0x140>
80103b4e:	84 c9                	test   %cl,%cl
80103b50:	74 6e                	je     80103bc0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103b52:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b55:	39 c2                	cmp    %eax,%edx
80103b57:	77 eb                	ja     80103b44 <mpinit+0xf4>
80103b59:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103b5c:	85 db                	test   %ebx,%ebx
80103b5e:	0f 84 b9 00 00 00    	je     80103c1d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103b64:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103b68:	74 15                	je     80103b7f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b6a:	b8 70 00 00 00       	mov    $0x70,%eax
80103b6f:	ba 22 00 00 00       	mov    $0x22,%edx
80103b74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b75:	ba 23 00 00 00       	mov    $0x23,%edx
80103b7a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b7b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b7e:	ee                   	out    %al,(%dx)
  }
}
80103b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b82:	5b                   	pop    %ebx
80103b83:	5e                   	pop    %esi
80103b84:	5f                   	pop    %edi
80103b85:	5d                   	pop    %ebp
80103b86:	c3                   	ret    
80103b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103b90:	83 e9 03             	sub    $0x3,%ecx
80103b93:	80 f9 01             	cmp    $0x1,%cl
80103b96:	76 ba                	jbe    80103b52 <mpinit+0x102>
80103b98:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103b9f:	eb 9f                	jmp    80103b40 <mpinit+0xf0>
80103ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103ba8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103bac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103baf:	88 0d 20 3d 11 80    	mov    %cl,0x80113d20
      continue;
80103bb5:	eb 89                	jmp    80103b40 <mpinit+0xf0>
80103bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bbe:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103bc0:	8b 0d c0 42 11 80    	mov    0x801142c0,%ecx
80103bc6:	83 f9 07             	cmp    $0x7,%ecx
80103bc9:	7f 19                	jg     80103be4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103bcb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103bd1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103bd5:	83 c1 01             	add    $0x1,%ecx
80103bd8:	89 0d c0 42 11 80    	mov    %ecx,0x801142c0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103bde:	88 9f 40 3d 11 80    	mov    %bl,-0x7feec2c0(%edi)
      p += sizeof(struct mpproc);
80103be4:	83 c0 14             	add    $0x14,%eax
      continue;
80103be7:	e9 54 ff ff ff       	jmp    80103b40 <mpinit+0xf0>
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103bf0:	ba 00 00 01 00       	mov    $0x10000,%edx
80103bf5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103bfa:	e8 d1 fd ff ff       	call   801039d0 <mpsearch1>
80103bff:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c01:	85 c0                	test   %eax,%eax
80103c03:	0f 85 9b fe ff ff    	jne    80103aa4 <mpinit+0x54>
80103c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	68 82 7e 10 80       	push   $0x80107e82
80103c18:	e8 73 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103c1d:	83 ec 0c             	sub    $0xc,%esp
80103c20:	68 9c 7e 10 80       	push   $0x80107e9c
80103c25:	e8 66 c7 ff ff       	call   80100390 <panic>
80103c2a:	66 90                	xchg   %ax,%ax
80103c2c:	66 90                	xchg   %ax,%ax
80103c2e:	66 90                	xchg   %ax,%ax

80103c30 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103c30:	f3 0f 1e fb          	endbr32 
80103c34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c39:	ba 21 00 00 00       	mov    $0x21,%edx
80103c3e:	ee                   	out    %al,(%dx)
80103c3f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103c44:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103c45:	c3                   	ret    
80103c46:	66 90                	xchg   %ax,%ax
80103c48:	66 90                	xchg   %ax,%ax
80103c4a:	66 90                	xchg   %ax,%ax
80103c4c:	66 90                	xchg   %ax,%ax
80103c4e:	66 90                	xchg   %ax,%ax

80103c50 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	57                   	push   %edi
80103c58:	56                   	push   %esi
80103c59:	53                   	push   %ebx
80103c5a:	83 ec 0c             	sub    $0xc,%esp
80103c5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c60:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103c63:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103c69:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c6f:	e8 ec d9 ff ff       	call   80101660 <filealloc>
80103c74:	89 03                	mov    %eax,(%ebx)
80103c76:	85 c0                	test   %eax,%eax
80103c78:	0f 84 ac 00 00 00    	je     80103d2a <pipealloc+0xda>
80103c7e:	e8 dd d9 ff ff       	call   80101660 <filealloc>
80103c83:	89 06                	mov    %eax,(%esi)
80103c85:	85 c0                	test   %eax,%eax
80103c87:	0f 84 8b 00 00 00    	je     80103d18 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c8d:	e8 fe f1 ff ff       	call   80102e90 <kalloc>
80103c92:	89 c7                	mov    %eax,%edi
80103c94:	85 c0                	test   %eax,%eax
80103c96:	0f 84 b4 00 00 00    	je     80103d50 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103c9c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ca3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103ca6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103ca9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103cb0:	00 00 00 
  p->nwrite = 0;
80103cb3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cba:	00 00 00 
  p->nread = 0;
80103cbd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103cc4:	00 00 00 
  initlock(&p->lock, "pipe");
80103cc7:	68 bb 7e 10 80       	push   $0x80107ebb
80103ccc:	50                   	push   %eax
80103ccd:	e8 6e 0f 00 00       	call   80104c40 <initlock>
  (*f0)->type = FD_PIPE;
80103cd2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103cd4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103cd7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cdd:	8b 03                	mov    (%ebx),%eax
80103cdf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ce3:	8b 03                	mov    (%ebx),%eax
80103ce5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103ce9:	8b 03                	mov    (%ebx),%eax
80103ceb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cee:	8b 06                	mov    (%esi),%eax
80103cf0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cf6:	8b 06                	mov    (%esi),%eax
80103cf8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cfc:	8b 06                	mov    (%esi),%eax
80103cfe:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d02:	8b 06                	mov    (%esi),%eax
80103d04:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103d0a:	31 c0                	xor    %eax,%eax
}
80103d0c:	5b                   	pop    %ebx
80103d0d:	5e                   	pop    %esi
80103d0e:	5f                   	pop    %edi
80103d0f:	5d                   	pop    %ebp
80103d10:	c3                   	ret    
80103d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103d18:	8b 03                	mov    (%ebx),%eax
80103d1a:	85 c0                	test   %eax,%eax
80103d1c:	74 1e                	je     80103d3c <pipealloc+0xec>
    fileclose(*f0);
80103d1e:	83 ec 0c             	sub    $0xc,%esp
80103d21:	50                   	push   %eax
80103d22:	e8 f9 d9 ff ff       	call   80101720 <fileclose>
80103d27:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103d2a:	8b 06                	mov    (%esi),%eax
80103d2c:	85 c0                	test   %eax,%eax
80103d2e:	74 0c                	je     80103d3c <pipealloc+0xec>
    fileclose(*f1);
80103d30:	83 ec 0c             	sub    $0xc,%esp
80103d33:	50                   	push   %eax
80103d34:	e8 e7 d9 ff ff       	call   80101720 <fileclose>
80103d39:	83 c4 10             	add    $0x10,%esp
}
80103d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103d3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d44:	5b                   	pop    %ebx
80103d45:	5e                   	pop    %esi
80103d46:	5f                   	pop    %edi
80103d47:	5d                   	pop    %ebp
80103d48:	c3                   	ret    
80103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103d50:	8b 03                	mov    (%ebx),%eax
80103d52:	85 c0                	test   %eax,%eax
80103d54:	75 c8                	jne    80103d1e <pipealloc+0xce>
80103d56:	eb d2                	jmp    80103d2a <pipealloc+0xda>
80103d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d5f:	90                   	nop

80103d60 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d60:	f3 0f 1e fb          	endbr32 
80103d64:	55                   	push   %ebp
80103d65:	89 e5                	mov    %esp,%ebp
80103d67:	56                   	push   %esi
80103d68:	53                   	push   %ebx
80103d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103d6f:	83 ec 0c             	sub    $0xc,%esp
80103d72:	53                   	push   %ebx
80103d73:	e8 48 10 00 00       	call   80104dc0 <acquire>
  if(writable){
80103d78:	83 c4 10             	add    $0x10,%esp
80103d7b:	85 f6                	test   %esi,%esi
80103d7d:	74 41                	je     80103dc0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103d7f:	83 ec 0c             	sub    $0xc,%esp
80103d82:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103d88:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103d8f:	00 00 00 
    wakeup(&p->nread);
80103d92:	50                   	push   %eax
80103d93:	e8 a8 0b 00 00       	call   80104940 <wakeup>
80103d98:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d9b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103da1:	85 d2                	test   %edx,%edx
80103da3:	75 0a                	jne    80103daf <pipeclose+0x4f>
80103da5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103dab:	85 c0                	test   %eax,%eax
80103dad:	74 31                	je     80103de0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103daf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db5:	5b                   	pop    %ebx
80103db6:	5e                   	pop    %esi
80103db7:	5d                   	pop    %ebp
    release(&p->lock);
80103db8:	e9 c3 10 00 00       	jmp    80104e80 <release>
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103dc0:	83 ec 0c             	sub    $0xc,%esp
80103dc3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103dc9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103dd0:	00 00 00 
    wakeup(&p->nwrite);
80103dd3:	50                   	push   %eax
80103dd4:	e8 67 0b 00 00       	call   80104940 <wakeup>
80103dd9:	83 c4 10             	add    $0x10,%esp
80103ddc:	eb bd                	jmp    80103d9b <pipeclose+0x3b>
80103dde:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103de0:	83 ec 0c             	sub    $0xc,%esp
80103de3:	53                   	push   %ebx
80103de4:	e8 97 10 00 00       	call   80104e80 <release>
    kfree((char*)p);
80103de9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103dec:	83 c4 10             	add    $0x10,%esp
}
80103def:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103df2:	5b                   	pop    %ebx
80103df3:	5e                   	pop    %esi
80103df4:	5d                   	pop    %ebp
    kfree((char*)p);
80103df5:	e9 d6 ee ff ff       	jmp    80102cd0 <kfree>
80103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e00 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e00:	f3 0f 1e fb          	endbr32 
80103e04:	55                   	push   %ebp
80103e05:	89 e5                	mov    %esp,%ebp
80103e07:	57                   	push   %edi
80103e08:	56                   	push   %esi
80103e09:	53                   	push   %ebx
80103e0a:	83 ec 28             	sub    $0x28,%esp
80103e0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103e10:	53                   	push   %ebx
80103e11:	e8 aa 0f 00 00       	call   80104dc0 <acquire>
  for(i = 0; i < n; i++){
80103e16:	8b 45 10             	mov    0x10(%ebp),%eax
80103e19:	83 c4 10             	add    $0x10,%esp
80103e1c:	85 c0                	test   %eax,%eax
80103e1e:	0f 8e bc 00 00 00    	jle    80103ee0 <pipewrite+0xe0>
80103e24:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e27:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103e2d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103e33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e36:	03 45 10             	add    0x10(%ebp),%eax
80103e39:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e3c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e42:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e48:	89 ca                	mov    %ecx,%edx
80103e4a:	05 00 02 00 00       	add    $0x200,%eax
80103e4f:	39 c1                	cmp    %eax,%ecx
80103e51:	74 3b                	je     80103e8e <pipewrite+0x8e>
80103e53:	eb 63                	jmp    80103eb8 <pipewrite+0xb8>
80103e55:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103e58:	e8 63 03 00 00       	call   801041c0 <myproc>
80103e5d:	8b 48 24             	mov    0x24(%eax),%ecx
80103e60:	85 c9                	test   %ecx,%ecx
80103e62:	75 34                	jne    80103e98 <pipewrite+0x98>
      wakeup(&p->nread);
80103e64:	83 ec 0c             	sub    $0xc,%esp
80103e67:	57                   	push   %edi
80103e68:	e8 d3 0a 00 00       	call   80104940 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e6d:	58                   	pop    %eax
80103e6e:	5a                   	pop    %edx
80103e6f:	53                   	push   %ebx
80103e70:	56                   	push   %esi
80103e71:	e8 0a 09 00 00       	call   80104780 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e76:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103e7c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103e82:	83 c4 10             	add    $0x10,%esp
80103e85:	05 00 02 00 00       	add    $0x200,%eax
80103e8a:	39 c2                	cmp    %eax,%edx
80103e8c:	75 2a                	jne    80103eb8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103e8e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103e94:	85 c0                	test   %eax,%eax
80103e96:	75 c0                	jne    80103e58 <pipewrite+0x58>
        release(&p->lock);
80103e98:	83 ec 0c             	sub    $0xc,%esp
80103e9b:	53                   	push   %ebx
80103e9c:	e8 df 0f 00 00       	call   80104e80 <release>
        return -1;
80103ea1:	83 c4 10             	add    $0x10,%esp
80103ea4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103ea9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eac:	5b                   	pop    %ebx
80103ead:	5e                   	pop    %esi
80103eae:	5f                   	pop    %edi
80103eaf:	5d                   	pop    %ebp
80103eb0:	c3                   	ret    
80103eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103eb8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103ebb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103ebe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103ec4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103eca:	0f b6 06             	movzbl (%esi),%eax
80103ecd:	83 c6 01             	add    $0x1,%esi
80103ed0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103ed3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103ed7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103eda:	0f 85 5c ff ff ff    	jne    80103e3c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ee0:	83 ec 0c             	sub    $0xc,%esp
80103ee3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103ee9:	50                   	push   %eax
80103eea:	e8 51 0a 00 00       	call   80104940 <wakeup>
  release(&p->lock);
80103eef:	89 1c 24             	mov    %ebx,(%esp)
80103ef2:	e8 89 0f 00 00       	call   80104e80 <release>
  return n;
80103ef7:	8b 45 10             	mov    0x10(%ebp),%eax
80103efa:	83 c4 10             	add    $0x10,%esp
80103efd:	eb aa                	jmp    80103ea9 <pipewrite+0xa9>
80103eff:	90                   	nop

80103f00 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f00:	f3 0f 1e fb          	endbr32 
80103f04:	55                   	push   %ebp
80103f05:	89 e5                	mov    %esp,%ebp
80103f07:	57                   	push   %edi
80103f08:	56                   	push   %esi
80103f09:	53                   	push   %ebx
80103f0a:	83 ec 18             	sub    $0x18,%esp
80103f0d:	8b 75 08             	mov    0x8(%ebp),%esi
80103f10:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103f13:	56                   	push   %esi
80103f14:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103f1a:	e8 a1 0e 00 00       	call   80104dc0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f1f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103f25:	83 c4 10             	add    $0x10,%esp
80103f28:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103f2e:	74 33                	je     80103f63 <piperead+0x63>
80103f30:	eb 3b                	jmp    80103f6d <piperead+0x6d>
80103f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103f38:	e8 83 02 00 00       	call   801041c0 <myproc>
80103f3d:	8b 48 24             	mov    0x24(%eax),%ecx
80103f40:	85 c9                	test   %ecx,%ecx
80103f42:	0f 85 88 00 00 00    	jne    80103fd0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f48:	83 ec 08             	sub    $0x8,%esp
80103f4b:	56                   	push   %esi
80103f4c:	53                   	push   %ebx
80103f4d:	e8 2e 08 00 00       	call   80104780 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f52:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103f58:	83 c4 10             	add    $0x10,%esp
80103f5b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103f61:	75 0a                	jne    80103f6d <piperead+0x6d>
80103f63:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103f69:	85 c0                	test   %eax,%eax
80103f6b:	75 cb                	jne    80103f38 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f6d:	8b 55 10             	mov    0x10(%ebp),%edx
80103f70:	31 db                	xor    %ebx,%ebx
80103f72:	85 d2                	test   %edx,%edx
80103f74:	7f 28                	jg     80103f9e <piperead+0x9e>
80103f76:	eb 34                	jmp    80103fac <piperead+0xac>
80103f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f80:	8d 48 01             	lea    0x1(%eax),%ecx
80103f83:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f88:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103f8e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103f93:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f96:	83 c3 01             	add    $0x1,%ebx
80103f99:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103f9c:	74 0e                	je     80103fac <piperead+0xac>
    if(p->nread == p->nwrite)
80103f9e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103fa4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103faa:	75 d4                	jne    80103f80 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103fb5:	50                   	push   %eax
80103fb6:	e8 85 09 00 00       	call   80104940 <wakeup>
  release(&p->lock);
80103fbb:	89 34 24             	mov    %esi,(%esp)
80103fbe:	e8 bd 0e 00 00       	call   80104e80 <release>
  return i;
80103fc3:	83 c4 10             	add    $0x10,%esp
}
80103fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fc9:	89 d8                	mov    %ebx,%eax
80103fcb:	5b                   	pop    %ebx
80103fcc:	5e                   	pop    %esi
80103fcd:	5f                   	pop    %edi
80103fce:	5d                   	pop    %ebp
80103fcf:	c3                   	ret    
      release(&p->lock);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103fd8:	56                   	push   %esi
80103fd9:	e8 a2 0e 00 00       	call   80104e80 <release>
      return -1;
80103fde:	83 c4 10             	add    $0x10,%esp
}
80103fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe4:	89 d8                	mov    %ebx,%eax
80103fe6:	5b                   	pop    %ebx
80103fe7:	5e                   	pop    %esi
80103fe8:	5f                   	pop    %edi
80103fe9:	5d                   	pop    %ebp
80103fea:	c3                   	ret    
80103feb:	66 90                	xchg   %ax,%ax
80103fed:	66 90                	xchg   %ax,%ax
80103fef:	90                   	nop

80103ff0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff4:	bb 14 43 11 80       	mov    $0x80114314,%ebx
{
80103ff9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103ffc:	68 e0 42 11 80       	push   $0x801142e0
80104001:	e8 ba 0d 00 00       	call   80104dc0 <acquire>
80104006:	83 c4 10             	add    $0x10,%esp
80104009:	eb 10                	jmp    8010401b <allocproc+0x2b>
8010400b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104010:	83 c3 7c             	add    $0x7c,%ebx
80104013:	81 fb 14 62 11 80    	cmp    $0x80116214,%ebx
80104019:	74 75                	je     80104090 <allocproc+0xa0>
    if(p->state == UNUSED)
8010401b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010401e:	85 c0                	test   %eax,%eax
80104020:	75 ee                	jne    80104010 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104022:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104027:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010402a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104031:	89 43 10             	mov    %eax,0x10(%ebx)
80104034:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104037:	68 e0 42 11 80       	push   $0x801142e0
  p->pid = nextpid++;
8010403c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104042:	e8 39 0e 00 00       	call   80104e80 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104047:	e8 44 ee ff ff       	call   80102e90 <kalloc>
8010404c:	83 c4 10             	add    $0x10,%esp
8010404f:	89 43 08             	mov    %eax,0x8(%ebx)
80104052:	85 c0                	test   %eax,%eax
80104054:	74 53                	je     801040a9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104056:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010405c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010405f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80104064:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104067:	c7 40 14 e6 60 10 80 	movl   $0x801060e6,0x14(%eax)
  p->context = (struct context*)sp;
8010406e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80104071:	6a 14                	push   $0x14
80104073:	6a 00                	push   $0x0
80104075:	50                   	push   %eax
80104076:	e8 55 0e 00 00       	call   80104ed0 <memset>
  p->context->eip = (uint)forkret;
8010407b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010407e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104081:	c7 40 10 c0 40 10 80 	movl   $0x801040c0,0x10(%eax)
}
80104088:	89 d8                	mov    %ebx,%eax
8010408a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010408d:	c9                   	leave  
8010408e:	c3                   	ret    
8010408f:	90                   	nop
  release(&ptable.lock);
80104090:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104093:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104095:	68 e0 42 11 80       	push   $0x801142e0
8010409a:	e8 e1 0d 00 00       	call   80104e80 <release>
}
8010409f:	89 d8                	mov    %ebx,%eax
  return 0;
801040a1:	83 c4 10             	add    $0x10,%esp
}
801040a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a7:	c9                   	leave  
801040a8:	c3                   	ret    
    p->state = UNUSED;
801040a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801040b0:	31 db                	xor    %ebx,%ebx
}
801040b2:	89 d8                	mov    %ebx,%eax
801040b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b7:	c9                   	leave  
801040b8:	c3                   	ret    
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801040c0:	f3 0f 1e fb          	endbr32 
801040c4:	55                   	push   %ebp
801040c5:	89 e5                	mov    %esp,%ebp
801040c7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801040ca:	68 e0 42 11 80       	push   $0x801142e0
801040cf:	e8 ac 0d 00 00       	call   80104e80 <release>

  if (first) {
801040d4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801040d9:	83 c4 10             	add    $0x10,%esp
801040dc:	85 c0                	test   %eax,%eax
801040de:	75 08                	jne    801040e8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801040e0:	c9                   	leave  
801040e1:	c3                   	ret    
801040e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801040e8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801040ef:	00 00 00 
    iinit(ROOTDEV);
801040f2:	83 ec 0c             	sub    $0xc,%esp
801040f5:	6a 01                	push   $0x1
801040f7:	e8 a4 dc ff ff       	call   80101da0 <iinit>
    initlog(ROOTDEV);
801040fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104103:	e8 e8 f3 ff ff       	call   801034f0 <initlog>
}
80104108:	83 c4 10             	add    $0x10,%esp
8010410b:	c9                   	leave  
8010410c:	c3                   	ret    
8010410d:	8d 76 00             	lea    0x0(%esi),%esi

80104110 <pinit>:
{
80104110:	f3 0f 1e fb          	endbr32 
80104114:	55                   	push   %ebp
80104115:	89 e5                	mov    %esp,%ebp
80104117:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010411a:	68 c0 7e 10 80       	push   $0x80107ec0
8010411f:	68 e0 42 11 80       	push   $0x801142e0
80104124:	e8 17 0b 00 00       	call   80104c40 <initlock>
}
80104129:	83 c4 10             	add    $0x10,%esp
8010412c:	c9                   	leave  
8010412d:	c3                   	ret    
8010412e:	66 90                	xchg   %ax,%ax

80104130 <mycpu>:
{
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
80104137:	56                   	push   %esi
80104138:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104139:	9c                   	pushf  
8010413a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010413b:	f6 c4 02             	test   $0x2,%ah
8010413e:	75 4a                	jne    8010418a <mycpu+0x5a>
  apicid = lapicid();
80104140:	e8 bb ef ff ff       	call   80103100 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104145:	8b 35 c0 42 11 80    	mov    0x801142c0,%esi
  apicid = lapicid();
8010414b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010414d:	85 f6                	test   %esi,%esi
8010414f:	7e 2c                	jle    8010417d <mycpu+0x4d>
80104151:	31 d2                	xor    %edx,%edx
80104153:	eb 0a                	jmp    8010415f <mycpu+0x2f>
80104155:	8d 76 00             	lea    0x0(%esi),%esi
80104158:	83 c2 01             	add    $0x1,%edx
8010415b:	39 f2                	cmp    %esi,%edx
8010415d:	74 1e                	je     8010417d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010415f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104165:	0f b6 81 40 3d 11 80 	movzbl -0x7feec2c0(%ecx),%eax
8010416c:	39 d8                	cmp    %ebx,%eax
8010416e:	75 e8                	jne    80104158 <mycpu+0x28>
}
80104170:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104173:	8d 81 40 3d 11 80    	lea    -0x7feec2c0(%ecx),%eax
}
80104179:	5b                   	pop    %ebx
8010417a:	5e                   	pop    %esi
8010417b:	5d                   	pop    %ebp
8010417c:	c3                   	ret    
  panic("unknown apicid\n");
8010417d:	83 ec 0c             	sub    $0xc,%esp
80104180:	68 c7 7e 10 80       	push   $0x80107ec7
80104185:	e8 06 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010418a:	83 ec 0c             	sub    $0xc,%esp
8010418d:	68 a4 7f 10 80       	push   $0x80107fa4
80104192:	e8 f9 c1 ff ff       	call   80100390 <panic>
80104197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419e:	66 90                	xchg   %ax,%ax

801041a0 <cpuid>:
cpuid() {
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801041aa:	e8 81 ff ff ff       	call   80104130 <mycpu>
}
801041af:	c9                   	leave  
  return mycpu()-cpus;
801041b0:	2d 40 3d 11 80       	sub    $0x80113d40,%eax
801041b5:	c1 f8 04             	sar    $0x4,%eax
801041b8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801041be:	c3                   	ret    
801041bf:	90                   	nop

801041c0 <myproc>:
myproc(void) {
801041c0:	f3 0f 1e fb          	endbr32 
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	53                   	push   %ebx
801041c8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801041cb:	e8 f0 0a 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
801041d0:	e8 5b ff ff ff       	call   80104130 <mycpu>
  p = c->proc;
801041d5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041db:	e8 30 0b 00 00       	call   80104d10 <popcli>
}
801041e0:	83 c4 04             	add    $0x4,%esp
801041e3:	89 d8                	mov    %ebx,%eax
801041e5:	5b                   	pop    %ebx
801041e6:	5d                   	pop    %ebp
801041e7:	c3                   	ret    
801041e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ef:	90                   	nop

801041f0 <userinit>:
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	53                   	push   %ebx
801041f8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801041fb:	e8 f0 fd ff ff       	call   80103ff0 <allocproc>
80104200:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104202:	a3 d8 b5 10 80       	mov    %eax,0x8010b5d8
  if((p->pgdir = setupkvm()) == 0)
80104207:	e8 a4 34 00 00       	call   801076b0 <setupkvm>
8010420c:	89 43 04             	mov    %eax,0x4(%ebx)
8010420f:	85 c0                	test   %eax,%eax
80104211:	0f 84 bd 00 00 00    	je     801042d4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104217:	83 ec 04             	sub    $0x4,%esp
8010421a:	68 2c 00 00 00       	push   $0x2c
8010421f:	68 60 b4 10 80       	push   $0x8010b460
80104224:	50                   	push   %eax
80104225:	e8 56 31 00 00       	call   80107380 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010422a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010422d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104233:	6a 4c                	push   $0x4c
80104235:	6a 00                	push   $0x0
80104237:	ff 73 18             	pushl  0x18(%ebx)
8010423a:	e8 91 0c 00 00       	call   80104ed0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010423f:	8b 43 18             	mov    0x18(%ebx),%eax
80104242:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104247:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010424a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010424f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104253:	8b 43 18             	mov    0x18(%ebx),%eax
80104256:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010425a:	8b 43 18             	mov    0x18(%ebx),%eax
8010425d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104261:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104265:	8b 43 18             	mov    0x18(%ebx),%eax
80104268:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010426c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104270:	8b 43 18             	mov    0x18(%ebx),%eax
80104273:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010427a:	8b 43 18             	mov    0x18(%ebx),%eax
8010427d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104284:	8b 43 18             	mov    0x18(%ebx),%eax
80104287:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010428e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104291:	6a 10                	push   $0x10
80104293:	68 f0 7e 10 80       	push   $0x80107ef0
80104298:	50                   	push   %eax
80104299:	e8 f2 0d 00 00       	call   80105090 <safestrcpy>
  p->cwd = namei("/");
8010429e:	c7 04 24 f9 7e 10 80 	movl   $0x80107ef9,(%esp)
801042a5:	e8 e6 e5 ff ff       	call   80102890 <namei>
801042aa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801042ad:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
801042b4:	e8 07 0b 00 00       	call   80104dc0 <acquire>
  p->state = RUNNABLE;
801042b9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801042c0:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
801042c7:	e8 b4 0b 00 00       	call   80104e80 <release>
}
801042cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042cf:	83 c4 10             	add    $0x10,%esp
801042d2:	c9                   	leave  
801042d3:	c3                   	ret    
    panic("userinit: out of memory?");
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	68 d7 7e 10 80       	push   $0x80107ed7
801042dc:	e8 af c0 ff ff       	call   80100390 <panic>
801042e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ef:	90                   	nop

801042f0 <growproc>:
{
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	56                   	push   %esi
801042f8:	53                   	push   %ebx
801042f9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801042fc:	e8 bf 09 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
80104301:	e8 2a fe ff ff       	call   80104130 <mycpu>
  p = c->proc;
80104306:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010430c:	e8 ff 09 00 00       	call   80104d10 <popcli>
  sz = curproc->sz;
80104311:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104313:	85 f6                	test   %esi,%esi
80104315:	7f 19                	jg     80104330 <growproc+0x40>
  } else if(n < 0){
80104317:	75 37                	jne    80104350 <growproc+0x60>
  switchuvm(curproc);
80104319:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010431c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010431e:	53                   	push   %ebx
8010431f:	e8 4c 2f 00 00       	call   80107270 <switchuvm>
  return 0;
80104324:	83 c4 10             	add    $0x10,%esp
80104327:	31 c0                	xor    %eax,%eax
}
80104329:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010432c:	5b                   	pop    %ebx
8010432d:	5e                   	pop    %esi
8010432e:	5d                   	pop    %ebp
8010432f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104330:	83 ec 04             	sub    $0x4,%esp
80104333:	01 c6                	add    %eax,%esi
80104335:	56                   	push   %esi
80104336:	50                   	push   %eax
80104337:	ff 73 04             	pushl  0x4(%ebx)
8010433a:	e8 91 31 00 00       	call   801074d0 <allocuvm>
8010433f:	83 c4 10             	add    $0x10,%esp
80104342:	85 c0                	test   %eax,%eax
80104344:	75 d3                	jne    80104319 <growproc+0x29>
      return -1;
80104346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010434b:	eb dc                	jmp    80104329 <growproc+0x39>
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104350:	83 ec 04             	sub    $0x4,%esp
80104353:	01 c6                	add    %eax,%esi
80104355:	56                   	push   %esi
80104356:	50                   	push   %eax
80104357:	ff 73 04             	pushl  0x4(%ebx)
8010435a:	e8 a1 32 00 00       	call   80107600 <deallocuvm>
8010435f:	83 c4 10             	add    $0x10,%esp
80104362:	85 c0                	test   %eax,%eax
80104364:	75 b3                	jne    80104319 <growproc+0x29>
80104366:	eb de                	jmp    80104346 <growproc+0x56>
80104368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436f:	90                   	nop

80104370 <fork>:
{
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	57                   	push   %edi
80104378:	56                   	push   %esi
80104379:	53                   	push   %ebx
8010437a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010437d:	e8 3e 09 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
80104382:	e8 a9 fd ff ff       	call   80104130 <mycpu>
  p = c->proc;
80104387:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010438d:	e8 7e 09 00 00       	call   80104d10 <popcli>
  if((np = allocproc()) == 0){
80104392:	e8 59 fc ff ff       	call   80103ff0 <allocproc>
80104397:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010439a:	85 c0                	test   %eax,%eax
8010439c:	0f 84 bb 00 00 00    	je     8010445d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801043a2:	83 ec 08             	sub    $0x8,%esp
801043a5:	ff 33                	pushl  (%ebx)
801043a7:	89 c7                	mov    %eax,%edi
801043a9:	ff 73 04             	pushl  0x4(%ebx)
801043ac:	e8 cf 33 00 00       	call   80107780 <copyuvm>
801043b1:	83 c4 10             	add    $0x10,%esp
801043b4:	89 47 04             	mov    %eax,0x4(%edi)
801043b7:	85 c0                	test   %eax,%eax
801043b9:	0f 84 a5 00 00 00    	je     80104464 <fork+0xf4>
  np->sz = curproc->sz;
801043bf:	8b 03                	mov    (%ebx),%eax
801043c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043c4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801043c6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801043c9:	89 c8                	mov    %ecx,%eax
801043cb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801043ce:	b9 13 00 00 00       	mov    $0x13,%ecx
801043d3:	8b 73 18             	mov    0x18(%ebx),%esi
801043d6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801043d8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801043da:	8b 40 18             	mov    0x18(%eax),%eax
801043dd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801043e8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801043ec:	85 c0                	test   %eax,%eax
801043ee:	74 13                	je     80104403 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	50                   	push   %eax
801043f4:	e8 d7 d2 ff ff       	call   801016d0 <filedup>
801043f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043fc:	83 c4 10             	add    $0x10,%esp
801043ff:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104403:	83 c6 01             	add    $0x1,%esi
80104406:	83 fe 10             	cmp    $0x10,%esi
80104409:	75 dd                	jne    801043e8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010440b:	83 ec 0c             	sub    $0xc,%esp
8010440e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104411:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104414:	e8 77 db ff ff       	call   80101f90 <idup>
80104419:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010441c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010441f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104422:	8d 47 6c             	lea    0x6c(%edi),%eax
80104425:	6a 10                	push   $0x10
80104427:	53                   	push   %ebx
80104428:	50                   	push   %eax
80104429:	e8 62 0c 00 00       	call   80105090 <safestrcpy>
  pid = np->pid;
8010442e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104431:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
80104438:	e8 83 09 00 00       	call   80104dc0 <acquire>
  np->state = RUNNABLE;
8010443d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104444:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
8010444b:	e8 30 0a 00 00       	call   80104e80 <release>
  return pid;
80104450:	83 c4 10             	add    $0x10,%esp
}
80104453:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104456:	89 d8                	mov    %ebx,%eax
80104458:	5b                   	pop    %ebx
80104459:	5e                   	pop    %esi
8010445a:	5f                   	pop    %edi
8010445b:	5d                   	pop    %ebp
8010445c:	c3                   	ret    
    return -1;
8010445d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104462:	eb ef                	jmp    80104453 <fork+0xe3>
    kfree(np->kstack);
80104464:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104467:	83 ec 0c             	sub    $0xc,%esp
8010446a:	ff 73 08             	pushl  0x8(%ebx)
8010446d:	e8 5e e8 ff ff       	call   80102cd0 <kfree>
    np->kstack = 0;
80104472:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104479:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010447c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104483:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104488:	eb c9                	jmp    80104453 <fork+0xe3>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <scheduler>:
{
80104490:	f3 0f 1e fb          	endbr32 
80104494:	55                   	push   %ebp
80104495:	89 e5                	mov    %esp,%ebp
80104497:	57                   	push   %edi
80104498:	56                   	push   %esi
80104499:	53                   	push   %ebx
8010449a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010449d:	e8 8e fc ff ff       	call   80104130 <mycpu>
  c->proc = 0;
801044a2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801044a9:	00 00 00 
  struct cpu *c = mycpu();
801044ac:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801044ae:	8d 78 04             	lea    0x4(%eax),%edi
801044b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801044b8:	fb                   	sti    
    acquire(&ptable.lock);
801044b9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044bc:	bb 14 43 11 80       	mov    $0x80114314,%ebx
    acquire(&ptable.lock);
801044c1:	68 e0 42 11 80       	push   $0x801142e0
801044c6:	e8 f5 08 00 00       	call   80104dc0 <acquire>
801044cb:	83 c4 10             	add    $0x10,%esp
801044ce:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
801044d0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801044d4:	75 33                	jne    80104509 <scheduler+0x79>
      switchuvm(p);
801044d6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801044d9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801044df:	53                   	push   %ebx
801044e0:	e8 8b 2d 00 00       	call   80107270 <switchuvm>
      swtch(&(c->scheduler), p->context);
801044e5:	58                   	pop    %eax
801044e6:	5a                   	pop    %edx
801044e7:	ff 73 1c             	pushl  0x1c(%ebx)
801044ea:	57                   	push   %edi
      p->state = RUNNING;
801044eb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801044f2:	e8 fc 0b 00 00       	call   801050f3 <swtch>
      switchkvm();
801044f7:	e8 54 2d 00 00       	call   80107250 <switchkvm>
      c->proc = 0;
801044fc:	83 c4 10             	add    $0x10,%esp
801044ff:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104506:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104509:	83 c3 7c             	add    $0x7c,%ebx
8010450c:	81 fb 14 62 11 80    	cmp    $0x80116214,%ebx
80104512:	75 bc                	jne    801044d0 <scheduler+0x40>
    release(&ptable.lock);
80104514:	83 ec 0c             	sub    $0xc,%esp
80104517:	68 e0 42 11 80       	push   $0x801142e0
8010451c:	e8 5f 09 00 00       	call   80104e80 <release>
    sti();
80104521:	83 c4 10             	add    $0x10,%esp
80104524:	eb 92                	jmp    801044b8 <scheduler+0x28>
80104526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452d:	8d 76 00             	lea    0x0(%esi),%esi

80104530 <sched>:
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	56                   	push   %esi
80104538:	53                   	push   %ebx
  pushcli();
80104539:	e8 82 07 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
8010453e:	e8 ed fb ff ff       	call   80104130 <mycpu>
  p = c->proc;
80104543:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104549:	e8 c2 07 00 00       	call   80104d10 <popcli>
  if(!holding(&ptable.lock))
8010454e:	83 ec 0c             	sub    $0xc,%esp
80104551:	68 e0 42 11 80       	push   $0x801142e0
80104556:	e8 15 08 00 00       	call   80104d70 <holding>
8010455b:	83 c4 10             	add    $0x10,%esp
8010455e:	85 c0                	test   %eax,%eax
80104560:	74 4f                	je     801045b1 <sched+0x81>
  if(mycpu()->ncli != 1)
80104562:	e8 c9 fb ff ff       	call   80104130 <mycpu>
80104567:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010456e:	75 68                	jne    801045d8 <sched+0xa8>
  if(p->state == RUNNING)
80104570:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104574:	74 55                	je     801045cb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104576:	9c                   	pushf  
80104577:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104578:	f6 c4 02             	test   $0x2,%ah
8010457b:	75 41                	jne    801045be <sched+0x8e>
  intena = mycpu()->intena;
8010457d:	e8 ae fb ff ff       	call   80104130 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104582:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104585:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010458b:	e8 a0 fb ff ff       	call   80104130 <mycpu>
80104590:	83 ec 08             	sub    $0x8,%esp
80104593:	ff 70 04             	pushl  0x4(%eax)
80104596:	53                   	push   %ebx
80104597:	e8 57 0b 00 00       	call   801050f3 <swtch>
  mycpu()->intena = intena;
8010459c:	e8 8f fb ff ff       	call   80104130 <mycpu>
}
801045a1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801045a4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801045aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045ad:	5b                   	pop    %ebx
801045ae:	5e                   	pop    %esi
801045af:	5d                   	pop    %ebp
801045b0:	c3                   	ret    
    panic("sched ptable.lock");
801045b1:	83 ec 0c             	sub    $0xc,%esp
801045b4:	68 fb 7e 10 80       	push   $0x80107efb
801045b9:	e8 d2 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801045be:	83 ec 0c             	sub    $0xc,%esp
801045c1:	68 27 7f 10 80       	push   $0x80107f27
801045c6:	e8 c5 bd ff ff       	call   80100390 <panic>
    panic("sched running");
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	68 19 7f 10 80       	push   $0x80107f19
801045d3:	e8 b8 bd ff ff       	call   80100390 <panic>
    panic("sched locks");
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	68 0d 7f 10 80       	push   $0x80107f0d
801045e0:	e8 ab bd ff ff       	call   80100390 <panic>
801045e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045f0 <exit>:
{
801045f0:	f3 0f 1e fb          	endbr32 
801045f4:	55                   	push   %ebp
801045f5:	89 e5                	mov    %esp,%ebp
801045f7:	57                   	push   %edi
801045f8:	56                   	push   %esi
801045f9:	53                   	push   %ebx
801045fa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801045fd:	e8 be 06 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
80104602:	e8 29 fb ff ff       	call   80104130 <mycpu>
  p = c->proc;
80104607:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010460d:	e8 fe 06 00 00       	call   80104d10 <popcli>
  if(curproc == initproc)
80104612:	8d 5e 28             	lea    0x28(%esi),%ebx
80104615:	8d 7e 68             	lea    0x68(%esi),%edi
80104618:	39 35 d8 b5 10 80    	cmp    %esi,0x8010b5d8
8010461e:	0f 84 f3 00 00 00    	je     80104717 <exit+0x127>
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104628:	8b 03                	mov    (%ebx),%eax
8010462a:	85 c0                	test   %eax,%eax
8010462c:	74 12                	je     80104640 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010462e:	83 ec 0c             	sub    $0xc,%esp
80104631:	50                   	push   %eax
80104632:	e8 e9 d0 ff ff       	call   80101720 <fileclose>
      curproc->ofile[fd] = 0;
80104637:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010463d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104640:	83 c3 04             	add    $0x4,%ebx
80104643:	39 df                	cmp    %ebx,%edi
80104645:	75 e1                	jne    80104628 <exit+0x38>
  begin_op();
80104647:	e8 44 ef ff ff       	call   80103590 <begin_op>
  iput(curproc->cwd);
8010464c:	83 ec 0c             	sub    $0xc,%esp
8010464f:	ff 76 68             	pushl  0x68(%esi)
80104652:	e8 99 da ff ff       	call   801020f0 <iput>
  end_op();
80104657:	e8 a4 ef ff ff       	call   80103600 <end_op>
  curproc->cwd = 0;
8010465c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104663:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
8010466a:	e8 51 07 00 00       	call   80104dc0 <acquire>
  wakeup1(curproc->parent);
8010466f:	8b 56 14             	mov    0x14(%esi),%edx
80104672:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104675:	b8 14 43 11 80       	mov    $0x80114314,%eax
8010467a:	eb 0e                	jmp    8010468a <exit+0x9a>
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104680:	83 c0 7c             	add    $0x7c,%eax
80104683:	3d 14 62 11 80       	cmp    $0x80116214,%eax
80104688:	74 1c                	je     801046a6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
8010468a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010468e:	75 f0                	jne    80104680 <exit+0x90>
80104690:	3b 50 20             	cmp    0x20(%eax),%edx
80104693:	75 eb                	jne    80104680 <exit+0x90>
      p->state = RUNNABLE;
80104695:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010469c:	83 c0 7c             	add    $0x7c,%eax
8010469f:	3d 14 62 11 80       	cmp    $0x80116214,%eax
801046a4:	75 e4                	jne    8010468a <exit+0x9a>
      p->parent = initproc;
801046a6:	8b 0d d8 b5 10 80    	mov    0x8010b5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ac:	ba 14 43 11 80       	mov    $0x80114314,%edx
801046b1:	eb 10                	jmp    801046c3 <exit+0xd3>
801046b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b7:	90                   	nop
801046b8:	83 c2 7c             	add    $0x7c,%edx
801046bb:	81 fa 14 62 11 80    	cmp    $0x80116214,%edx
801046c1:	74 3b                	je     801046fe <exit+0x10e>
    if(p->parent == curproc){
801046c3:	39 72 14             	cmp    %esi,0x14(%edx)
801046c6:	75 f0                	jne    801046b8 <exit+0xc8>
      if(p->state == ZOMBIE)
801046c8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801046cc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801046cf:	75 e7                	jne    801046b8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046d1:	b8 14 43 11 80       	mov    $0x80114314,%eax
801046d6:	eb 12                	jmp    801046ea <exit+0xfa>
801046d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop
801046e0:	83 c0 7c             	add    $0x7c,%eax
801046e3:	3d 14 62 11 80       	cmp    $0x80116214,%eax
801046e8:	74 ce                	je     801046b8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
801046ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046ee:	75 f0                	jne    801046e0 <exit+0xf0>
801046f0:	3b 48 20             	cmp    0x20(%eax),%ecx
801046f3:	75 eb                	jne    801046e0 <exit+0xf0>
      p->state = RUNNABLE;
801046f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046fc:	eb e2                	jmp    801046e0 <exit+0xf0>
  curproc->state = ZOMBIE;
801046fe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104705:	e8 26 fe ff ff       	call   80104530 <sched>
  panic("zombie exit");
8010470a:	83 ec 0c             	sub    $0xc,%esp
8010470d:	68 48 7f 10 80       	push   $0x80107f48
80104712:	e8 79 bc ff ff       	call   80100390 <panic>
    panic("init exiting");
80104717:	83 ec 0c             	sub    $0xc,%esp
8010471a:	68 3b 7f 10 80       	push   $0x80107f3b
8010471f:	e8 6c bc ff ff       	call   80100390 <panic>
80104724:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010472f:	90                   	nop

80104730 <yield>:
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	53                   	push   %ebx
80104738:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010473b:	68 e0 42 11 80       	push   $0x801142e0
80104740:	e8 7b 06 00 00       	call   80104dc0 <acquire>
  pushcli();
80104745:	e8 76 05 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
8010474a:	e8 e1 f9 ff ff       	call   80104130 <mycpu>
  p = c->proc;
8010474f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104755:	e8 b6 05 00 00       	call   80104d10 <popcli>
  myproc()->state = RUNNABLE;
8010475a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104761:	e8 ca fd ff ff       	call   80104530 <sched>
  release(&ptable.lock);
80104766:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
8010476d:	e8 0e 07 00 00       	call   80104e80 <release>
}
80104772:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104775:	83 c4 10             	add    $0x10,%esp
80104778:	c9                   	leave  
80104779:	c3                   	ret    
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <sleep>:
{
80104780:	f3 0f 1e fb          	endbr32 
80104784:	55                   	push   %ebp
80104785:	89 e5                	mov    %esp,%ebp
80104787:	57                   	push   %edi
80104788:	56                   	push   %esi
80104789:	53                   	push   %ebx
8010478a:	83 ec 0c             	sub    $0xc,%esp
8010478d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104790:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104793:	e8 28 05 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
80104798:	e8 93 f9 ff ff       	call   80104130 <mycpu>
  p = c->proc;
8010479d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047a3:	e8 68 05 00 00       	call   80104d10 <popcli>
  if(p == 0)
801047a8:	85 db                	test   %ebx,%ebx
801047aa:	0f 84 83 00 00 00    	je     80104833 <sleep+0xb3>
  if(lk == 0)
801047b0:	85 f6                	test   %esi,%esi
801047b2:	74 72                	je     80104826 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801047b4:	81 fe e0 42 11 80    	cmp    $0x801142e0,%esi
801047ba:	74 4c                	je     80104808 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801047bc:	83 ec 0c             	sub    $0xc,%esp
801047bf:	68 e0 42 11 80       	push   $0x801142e0
801047c4:	e8 f7 05 00 00       	call   80104dc0 <acquire>
    release(lk);
801047c9:	89 34 24             	mov    %esi,(%esp)
801047cc:	e8 af 06 00 00       	call   80104e80 <release>
  p->chan = chan;
801047d1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047d4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047db:	e8 50 fd ff ff       	call   80104530 <sched>
  p->chan = 0;
801047e0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801047e7:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
801047ee:	e8 8d 06 00 00       	call   80104e80 <release>
    acquire(lk);
801047f3:	89 75 08             	mov    %esi,0x8(%ebp)
801047f6:	83 c4 10             	add    $0x10,%esp
}
801047f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047fc:	5b                   	pop    %ebx
801047fd:	5e                   	pop    %esi
801047fe:	5f                   	pop    %edi
801047ff:	5d                   	pop    %ebp
    acquire(lk);
80104800:	e9 bb 05 00 00       	jmp    80104dc0 <acquire>
80104805:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104808:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010480b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104812:	e8 19 fd ff ff       	call   80104530 <sched>
  p->chan = 0;
80104817:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010481e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104821:	5b                   	pop    %ebx
80104822:	5e                   	pop    %esi
80104823:	5f                   	pop    %edi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
    panic("sleep without lk");
80104826:	83 ec 0c             	sub    $0xc,%esp
80104829:	68 5a 7f 10 80       	push   $0x80107f5a
8010482e:	e8 5d bb ff ff       	call   80100390 <panic>
    panic("sleep");
80104833:	83 ec 0c             	sub    $0xc,%esp
80104836:	68 54 7f 10 80       	push   $0x80107f54
8010483b:	e8 50 bb ff ff       	call   80100390 <panic>

80104840 <wait>:
{
80104840:	f3 0f 1e fb          	endbr32 
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	56                   	push   %esi
80104848:	53                   	push   %ebx
  pushcli();
80104849:	e8 72 04 00 00       	call   80104cc0 <pushcli>
  c = mycpu();
8010484e:	e8 dd f8 ff ff       	call   80104130 <mycpu>
  p = c->proc;
80104853:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104859:	e8 b2 04 00 00       	call   80104d10 <popcli>
  acquire(&ptable.lock);
8010485e:	83 ec 0c             	sub    $0xc,%esp
80104861:	68 e0 42 11 80       	push   $0x801142e0
80104866:	e8 55 05 00 00       	call   80104dc0 <acquire>
8010486b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010486e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104870:	bb 14 43 11 80       	mov    $0x80114314,%ebx
80104875:	eb 14                	jmp    8010488b <wait+0x4b>
80104877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010487e:	66 90                	xchg   %ax,%ax
80104880:	83 c3 7c             	add    $0x7c,%ebx
80104883:	81 fb 14 62 11 80    	cmp    $0x80116214,%ebx
80104889:	74 1b                	je     801048a6 <wait+0x66>
      if(p->parent != curproc)
8010488b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010488e:	75 f0                	jne    80104880 <wait+0x40>
      if(p->state == ZOMBIE){
80104890:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104894:	74 32                	je     801048c8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104896:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104899:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010489e:	81 fb 14 62 11 80    	cmp    $0x80116214,%ebx
801048a4:	75 e5                	jne    8010488b <wait+0x4b>
    if(!havekids || curproc->killed){
801048a6:	85 c0                	test   %eax,%eax
801048a8:	74 74                	je     8010491e <wait+0xde>
801048aa:	8b 46 24             	mov    0x24(%esi),%eax
801048ad:	85 c0                	test   %eax,%eax
801048af:	75 6d                	jne    8010491e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801048b1:	83 ec 08             	sub    $0x8,%esp
801048b4:	68 e0 42 11 80       	push   $0x801142e0
801048b9:	56                   	push   %esi
801048ba:	e8 c1 fe ff ff       	call   80104780 <sleep>
    havekids = 0;
801048bf:	83 c4 10             	add    $0x10,%esp
801048c2:	eb aa                	jmp    8010486e <wait+0x2e>
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801048c8:	83 ec 0c             	sub    $0xc,%esp
801048cb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801048ce:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801048d1:	e8 fa e3 ff ff       	call   80102cd0 <kfree>
        freevm(p->pgdir);
801048d6:	5a                   	pop    %edx
801048d7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801048da:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801048e1:	e8 4a 2d 00 00       	call   80107630 <freevm>
        release(&ptable.lock);
801048e6:	c7 04 24 e0 42 11 80 	movl   $0x801142e0,(%esp)
        p->pid = 0;
801048ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801048f4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801048fb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801048ff:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104906:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010490d:	e8 6e 05 00 00       	call   80104e80 <release>
        return pid;
80104912:	83 c4 10             	add    $0x10,%esp
}
80104915:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104918:	89 f0                	mov    %esi,%eax
8010491a:	5b                   	pop    %ebx
8010491b:	5e                   	pop    %esi
8010491c:	5d                   	pop    %ebp
8010491d:	c3                   	ret    
      release(&ptable.lock);
8010491e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104921:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104926:	68 e0 42 11 80       	push   $0x801142e0
8010492b:	e8 50 05 00 00       	call   80104e80 <release>
      return -1;
80104930:	83 c4 10             	add    $0x10,%esp
80104933:	eb e0                	jmp    80104915 <wait+0xd5>
80104935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104940 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
80104945:	89 e5                	mov    %esp,%ebp
80104947:	53                   	push   %ebx
80104948:	83 ec 10             	sub    $0x10,%esp
8010494b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010494e:	68 e0 42 11 80       	push   $0x801142e0
80104953:	e8 68 04 00 00       	call   80104dc0 <acquire>
80104958:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010495b:	b8 14 43 11 80       	mov    $0x80114314,%eax
80104960:	eb 10                	jmp    80104972 <wakeup+0x32>
80104962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104968:	83 c0 7c             	add    $0x7c,%eax
8010496b:	3d 14 62 11 80       	cmp    $0x80116214,%eax
80104970:	74 1c                	je     8010498e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104972:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104976:	75 f0                	jne    80104968 <wakeup+0x28>
80104978:	3b 58 20             	cmp    0x20(%eax),%ebx
8010497b:	75 eb                	jne    80104968 <wakeup+0x28>
      p->state = RUNNABLE;
8010497d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104984:	83 c0 7c             	add    $0x7c,%eax
80104987:	3d 14 62 11 80       	cmp    $0x80116214,%eax
8010498c:	75 e4                	jne    80104972 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010498e:	c7 45 08 e0 42 11 80 	movl   $0x801142e0,0x8(%ebp)
}
80104995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104998:	c9                   	leave  
  release(&ptable.lock);
80104999:	e9 e2 04 00 00       	jmp    80104e80 <release>
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	53                   	push   %ebx
801049a8:	83 ec 10             	sub    $0x10,%esp
801049ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801049ae:	68 e0 42 11 80       	push   $0x801142e0
801049b3:	e8 08 04 00 00       	call   80104dc0 <acquire>
801049b8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049bb:	b8 14 43 11 80       	mov    $0x80114314,%eax
801049c0:	eb 10                	jmp    801049d2 <kill+0x32>
801049c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049c8:	83 c0 7c             	add    $0x7c,%eax
801049cb:	3d 14 62 11 80       	cmp    $0x80116214,%eax
801049d0:	74 36                	je     80104a08 <kill+0x68>
    if(p->pid == pid){
801049d2:	39 58 10             	cmp    %ebx,0x10(%eax)
801049d5:	75 f1                	jne    801049c8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801049d7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801049db:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801049e2:	75 07                	jne    801049eb <kill+0x4b>
        p->state = RUNNABLE;
801049e4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801049eb:	83 ec 0c             	sub    $0xc,%esp
801049ee:	68 e0 42 11 80       	push   $0x801142e0
801049f3:	e8 88 04 00 00       	call   80104e80 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801049f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801049fb:	83 c4 10             	add    $0x10,%esp
801049fe:	31 c0                	xor    %eax,%eax
}
80104a00:	c9                   	leave  
80104a01:	c3                   	ret    
80104a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	68 e0 42 11 80       	push   $0x801142e0
80104a10:	e8 6b 04 00 00       	call   80104e80 <release>
}
80104a15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104a18:	83 c4 10             	add    $0x10,%esp
80104a1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a20:	c9                   	leave  
80104a21:	c3                   	ret    
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a30 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a30:	f3 0f 1e fb          	endbr32 
80104a34:	55                   	push   %ebp
80104a35:	89 e5                	mov    %esp,%ebp
80104a37:	57                   	push   %edi
80104a38:	56                   	push   %esi
80104a39:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104a3c:	53                   	push   %ebx
80104a3d:	bb 80 43 11 80       	mov    $0x80114380,%ebx
80104a42:	83 ec 3c             	sub    $0x3c,%esp
80104a45:	eb 28                	jmp    80104a6f <procdump+0x3f>
80104a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a50:	83 ec 0c             	sub    $0xc,%esp
80104a53:	68 d7 82 10 80       	push   $0x801082d7
80104a58:	e8 f3 be ff ff       	call   80100950 <cprintf>
80104a5d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a60:	83 c3 7c             	add    $0x7c,%ebx
80104a63:	81 fb 80 62 11 80    	cmp    $0x80116280,%ebx
80104a69:	0f 84 81 00 00 00    	je     80104af0 <procdump+0xc0>
    if(p->state == UNUSED)
80104a6f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104a72:	85 c0                	test   %eax,%eax
80104a74:	74 ea                	je     80104a60 <procdump+0x30>
      state = "???";
80104a76:	ba 6b 7f 10 80       	mov    $0x80107f6b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a7b:	83 f8 05             	cmp    $0x5,%eax
80104a7e:	77 11                	ja     80104a91 <procdump+0x61>
80104a80:	8b 14 85 cc 7f 10 80 	mov    -0x7fef8034(,%eax,4),%edx
      state = "???";
80104a87:	b8 6b 7f 10 80       	mov    $0x80107f6b,%eax
80104a8c:	85 d2                	test   %edx,%edx
80104a8e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104a91:	53                   	push   %ebx
80104a92:	52                   	push   %edx
80104a93:	ff 73 a4             	pushl  -0x5c(%ebx)
80104a96:	68 6f 7f 10 80       	push   $0x80107f6f
80104a9b:	e8 b0 be ff ff       	call   80100950 <cprintf>
    if(p->state == SLEEPING){
80104aa0:	83 c4 10             	add    $0x10,%esp
80104aa3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104aa7:	75 a7                	jne    80104a50 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104aa9:	83 ec 08             	sub    $0x8,%esp
80104aac:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104aaf:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104ab2:	50                   	push   %eax
80104ab3:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104ab6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ab9:	83 c0 08             	add    $0x8,%eax
80104abc:	50                   	push   %eax
80104abd:	e8 9e 01 00 00       	call   80104c60 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ac2:	83 c4 10             	add    $0x10,%esp
80104ac5:	8d 76 00             	lea    0x0(%esi),%esi
80104ac8:	8b 17                	mov    (%edi),%edx
80104aca:	85 d2                	test   %edx,%edx
80104acc:	74 82                	je     80104a50 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104ace:	83 ec 08             	sub    $0x8,%esp
80104ad1:	83 c7 04             	add    $0x4,%edi
80104ad4:	52                   	push   %edx
80104ad5:	68 81 79 10 80       	push   $0x80107981
80104ada:	e8 71 be ff ff       	call   80100950 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104adf:	83 c4 10             	add    $0x10,%esp
80104ae2:	39 fe                	cmp    %edi,%esi
80104ae4:	75 e2                	jne    80104ac8 <procdump+0x98>
80104ae6:	e9 65 ff ff ff       	jmp    80104a50 <procdump+0x20>
80104aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aef:	90                   	nop
  }
}
80104af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104af3:	5b                   	pop    %ebx
80104af4:	5e                   	pop    %esi
80104af5:	5f                   	pop    %edi
80104af6:	5d                   	pop    %ebp
80104af7:	c3                   	ret    
80104af8:	66 90                	xchg   %ax,%ax
80104afa:	66 90                	xchg   %ax,%ax
80104afc:	66 90                	xchg   %ax,%ax
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	53                   	push   %ebx
80104b08:	83 ec 0c             	sub    $0xc,%esp
80104b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b0e:	68 e4 7f 10 80       	push   $0x80107fe4
80104b13:	8d 43 04             	lea    0x4(%ebx),%eax
80104b16:	50                   	push   %eax
80104b17:	e8 24 01 00 00       	call   80104c40 <initlock>
  lk->name = name;
80104b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b1f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b25:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b28:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b2f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b35:	c9                   	leave  
80104b36:	c3                   	ret    
80104b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b40:	f3 0f 1e fb          	endbr32 
80104b44:	55                   	push   %ebp
80104b45:	89 e5                	mov    %esp,%ebp
80104b47:	56                   	push   %esi
80104b48:	53                   	push   %ebx
80104b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b4c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b4f:	83 ec 0c             	sub    $0xc,%esp
80104b52:	56                   	push   %esi
80104b53:	e8 68 02 00 00       	call   80104dc0 <acquire>
  while (lk->locked) {
80104b58:	8b 13                	mov    (%ebx),%edx
80104b5a:	83 c4 10             	add    $0x10,%esp
80104b5d:	85 d2                	test   %edx,%edx
80104b5f:	74 1a                	je     80104b7b <acquiresleep+0x3b>
80104b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104b68:	83 ec 08             	sub    $0x8,%esp
80104b6b:	56                   	push   %esi
80104b6c:	53                   	push   %ebx
80104b6d:	e8 0e fc ff ff       	call   80104780 <sleep>
  while (lk->locked) {
80104b72:	8b 03                	mov    (%ebx),%eax
80104b74:	83 c4 10             	add    $0x10,%esp
80104b77:	85 c0                	test   %eax,%eax
80104b79:	75 ed                	jne    80104b68 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104b7b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b81:	e8 3a f6 ff ff       	call   801041c0 <myproc>
80104b86:	8b 40 10             	mov    0x10(%eax),%eax
80104b89:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b8c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b92:	5b                   	pop    %ebx
80104b93:	5e                   	pop    %esi
80104b94:	5d                   	pop    %ebp
  release(&lk->lk);
80104b95:	e9 e6 02 00 00       	jmp    80104e80 <release>
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ba0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
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
80104bb3:	e8 08 02 00 00       	call   80104dc0 <acquire>
  lk->locked = 0;
80104bb8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104bbe:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104bc5:	89 1c 24             	mov    %ebx,(%esp)
80104bc8:	e8 73 fd ff ff       	call   80104940 <wakeup>
  release(&lk->lk);
80104bcd:	89 75 08             	mov    %esi,0x8(%ebp)
80104bd0:	83 c4 10             	add    $0x10,%esp
}
80104bd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bd6:	5b                   	pop    %ebx
80104bd7:	5e                   	pop    %esi
80104bd8:	5d                   	pop    %ebp
  release(&lk->lk);
80104bd9:	e9 a2 02 00 00       	jmp    80104e80 <release>
80104bde:	66 90                	xchg   %ax,%ax

80104be0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104be0:	f3 0f 1e fb          	endbr32 
80104be4:	55                   	push   %ebp
80104be5:	89 e5                	mov    %esp,%ebp
80104be7:	57                   	push   %edi
80104be8:	31 ff                	xor    %edi,%edi
80104bea:	56                   	push   %esi
80104beb:	53                   	push   %ebx
80104bec:	83 ec 18             	sub    $0x18,%esp
80104bef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104bf2:	8d 73 04             	lea    0x4(%ebx),%esi
80104bf5:	56                   	push   %esi
80104bf6:	e8 c5 01 00 00       	call   80104dc0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104bfb:	8b 03                	mov    (%ebx),%eax
80104bfd:	83 c4 10             	add    $0x10,%esp
80104c00:	85 c0                	test   %eax,%eax
80104c02:	75 1c                	jne    80104c20 <holdingsleep+0x40>
  release(&lk->lk);
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	56                   	push   %esi
80104c08:	e8 73 02 00 00       	call   80104e80 <release>
  return r;
}
80104c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c10:	89 f8                	mov    %edi,%eax
80104c12:	5b                   	pop    %ebx
80104c13:	5e                   	pop    %esi
80104c14:	5f                   	pop    %edi
80104c15:	5d                   	pop    %ebp
80104c16:	c3                   	ret    
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104c20:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c23:	e8 98 f5 ff ff       	call   801041c0 <myproc>
80104c28:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c2b:	0f 94 c0             	sete   %al
80104c2e:	0f b6 c0             	movzbl %al,%eax
80104c31:	89 c7                	mov    %eax,%edi
80104c33:	eb cf                	jmp    80104c04 <holdingsleep+0x24>
80104c35:	66 90                	xchg   %ax,%ax
80104c37:	66 90                	xchg   %ax,%ax
80104c39:	66 90                	xchg   %ax,%ax
80104c3b:	66 90                	xchg   %ax,%ax
80104c3d:	66 90                	xchg   %ax,%ax
80104c3f:	90                   	nop

80104c40 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c53:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c5d:	5d                   	pop    %ebp
80104c5e:	c3                   	ret    
80104c5f:	90                   	nop

80104c60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c60:	f3 0f 1e fb          	endbr32 
80104c64:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c65:	31 d2                	xor    %edx,%edx
{
80104c67:	89 e5                	mov    %esp,%ebp
80104c69:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c6a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c70:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c77:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c78:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c7e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c84:	77 1a                	ja     80104ca0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c86:	8b 58 04             	mov    0x4(%eax),%ebx
80104c89:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c8c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c8f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c91:	83 fa 0a             	cmp    $0xa,%edx
80104c94:	75 e2                	jne    80104c78 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c96:	5b                   	pop    %ebx
80104c97:	5d                   	pop    %ebp
80104c98:	c3                   	ret    
80104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104ca0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104ca3:	8d 51 28             	lea    0x28(%ecx),%edx
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104cb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104cb6:	83 c0 04             	add    $0x4,%eax
80104cb9:	39 d0                	cmp    %edx,%eax
80104cbb:	75 f3                	jne    80104cb0 <getcallerpcs+0x50>
}
80104cbd:	5b                   	pop    %ebx
80104cbe:	5d                   	pop    %ebp
80104cbf:	c3                   	ret    

80104cc0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	53                   	push   %ebx
80104cc8:	83 ec 04             	sub    $0x4,%esp
80104ccb:	9c                   	pushf  
80104ccc:	5b                   	pop    %ebx
  asm volatile("cli");
80104ccd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104cce:	e8 5d f4 ff ff       	call   80104130 <mycpu>
80104cd3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104cd9:	85 c0                	test   %eax,%eax
80104cdb:	74 13                	je     80104cf0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104cdd:	e8 4e f4 ff ff       	call   80104130 <mycpu>
80104ce2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ce9:	83 c4 04             	add    $0x4,%esp
80104cec:	5b                   	pop    %ebx
80104ced:	5d                   	pop    %ebp
80104cee:	c3                   	ret    
80104cef:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104cf0:	e8 3b f4 ff ff       	call   80104130 <mycpu>
80104cf5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104cfb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d01:	eb da                	jmp    80104cdd <pushcli+0x1d>
80104d03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d10 <popcli>:

void
popcli(void)
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d1a:	9c                   	pushf  
80104d1b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d1c:	f6 c4 02             	test   $0x2,%ah
80104d1f:	75 31                	jne    80104d52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d21:	e8 0a f4 ff ff       	call   80104130 <mycpu>
80104d26:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d2d:	78 30                	js     80104d5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d2f:	e8 fc f3 ff ff       	call   80104130 <mycpu>
80104d34:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d3a:	85 d2                	test   %edx,%edx
80104d3c:	74 02                	je     80104d40 <popcli+0x30>
    sti();
}
80104d3e:	c9                   	leave  
80104d3f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d40:	e8 eb f3 ff ff       	call   80104130 <mycpu>
80104d45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d4b:	85 c0                	test   %eax,%eax
80104d4d:	74 ef                	je     80104d3e <popcli+0x2e>
  asm volatile("sti");
80104d4f:	fb                   	sti    
}
80104d50:	c9                   	leave  
80104d51:	c3                   	ret    
    panic("popcli - interruptible");
80104d52:	83 ec 0c             	sub    $0xc,%esp
80104d55:	68 ef 7f 10 80       	push   $0x80107fef
80104d5a:	e8 31 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d5f:	83 ec 0c             	sub    $0xc,%esp
80104d62:	68 06 80 10 80       	push   $0x80108006
80104d67:	e8 24 b6 ff ff       	call   80100390 <panic>
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d70 <holding>:
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	56                   	push   %esi
80104d78:	53                   	push   %ebx
80104d79:	8b 75 08             	mov    0x8(%ebp),%esi
80104d7c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d7e:	e8 3d ff ff ff       	call   80104cc0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d83:	8b 06                	mov    (%esi),%eax
80104d85:	85 c0                	test   %eax,%eax
80104d87:	75 0f                	jne    80104d98 <holding+0x28>
  popcli();
80104d89:	e8 82 ff ff ff       	call   80104d10 <popcli>
}
80104d8e:	89 d8                	mov    %ebx,%eax
80104d90:	5b                   	pop    %ebx
80104d91:	5e                   	pop    %esi
80104d92:	5d                   	pop    %ebp
80104d93:	c3                   	ret    
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d98:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d9b:	e8 90 f3 ff ff       	call   80104130 <mycpu>
80104da0:	39 c3                	cmp    %eax,%ebx
80104da2:	0f 94 c3             	sete   %bl
  popcli();
80104da5:	e8 66 ff ff ff       	call   80104d10 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104daa:	0f b6 db             	movzbl %bl,%ebx
}
80104dad:	89 d8                	mov    %ebx,%eax
80104daf:	5b                   	pop    %ebx
80104db0:	5e                   	pop    %esi
80104db1:	5d                   	pop    %ebp
80104db2:	c3                   	ret    
80104db3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dc0 <acquire>:
{
80104dc0:	f3 0f 1e fb          	endbr32 
80104dc4:	55                   	push   %ebp
80104dc5:	89 e5                	mov    %esp,%ebp
80104dc7:	56                   	push   %esi
80104dc8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104dc9:	e8 f2 fe ff ff       	call   80104cc0 <pushcli>
  if(holding(lk))
80104dce:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dd1:	83 ec 0c             	sub    $0xc,%esp
80104dd4:	53                   	push   %ebx
80104dd5:	e8 96 ff ff ff       	call   80104d70 <holding>
80104dda:	83 c4 10             	add    $0x10,%esp
80104ddd:	85 c0                	test   %eax,%eax
80104ddf:	0f 85 7f 00 00 00    	jne    80104e64 <acquire+0xa4>
80104de5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104de7:	ba 01 00 00 00       	mov    $0x1,%edx
80104dec:	eb 05                	jmp    80104df3 <acquire+0x33>
80104dee:	66 90                	xchg   %ax,%ax
80104df0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104df3:	89 d0                	mov    %edx,%eax
80104df5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104df8:	85 c0                	test   %eax,%eax
80104dfa:	75 f4                	jne    80104df0 <acquire+0x30>
  __sync_synchronize();
80104dfc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e04:	e8 27 f3 ff ff       	call   80104130 <mycpu>
80104e09:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e0c:	89 e8                	mov    %ebp,%eax
80104e0e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e10:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104e16:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104e1c:	77 22                	ja     80104e40 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e1e:	8b 50 04             	mov    0x4(%eax),%edx
80104e21:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104e25:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e28:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e2a:	83 fe 0a             	cmp    $0xa,%esi
80104e2d:	75 e1                	jne    80104e10 <acquire+0x50>
}
80104e2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e32:	5b                   	pop    %ebx
80104e33:	5e                   	pop    %esi
80104e34:	5d                   	pop    %ebp
80104e35:	c3                   	ret    
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104e40:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104e44:	83 c3 34             	add    $0x34,%ebx
80104e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e56:	83 c0 04             	add    $0x4,%eax
80104e59:	39 d8                	cmp    %ebx,%eax
80104e5b:	75 f3                	jne    80104e50 <acquire+0x90>
}
80104e5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e60:	5b                   	pop    %ebx
80104e61:	5e                   	pop    %esi
80104e62:	5d                   	pop    %ebp
80104e63:	c3                   	ret    
    panic("acquire");
80104e64:	83 ec 0c             	sub    $0xc,%esp
80104e67:	68 0d 80 10 80       	push   $0x8010800d
80104e6c:	e8 1f b5 ff ff       	call   80100390 <panic>
80104e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7f:	90                   	nop

80104e80 <release>:
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	53                   	push   %ebx
80104e88:	83 ec 10             	sub    $0x10,%esp
80104e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104e8e:	53                   	push   %ebx
80104e8f:	e8 dc fe ff ff       	call   80104d70 <holding>
80104e94:	83 c4 10             	add    $0x10,%esp
80104e97:	85 c0                	test   %eax,%eax
80104e99:	74 22                	je     80104ebd <release+0x3d>
  lk->pcs[0] = 0;
80104e9b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ea2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ea9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104eae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eb7:	c9                   	leave  
  popcli();
80104eb8:	e9 53 fe ff ff       	jmp    80104d10 <popcli>
    panic("release");
80104ebd:	83 ec 0c             	sub    $0xc,%esp
80104ec0:	68 15 80 10 80       	push   $0x80108015
80104ec5:	e8 c6 b4 ff ff       	call   80100390 <panic>
80104eca:	66 90                	xchg   %ax,%ax
80104ecc:	66 90                	xchg   %ax,%ax
80104ece:	66 90                	xchg   %ax,%ax

80104ed0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
80104ed5:	89 e5                	mov    %esp,%ebp
80104ed7:	57                   	push   %edi
80104ed8:	8b 55 08             	mov    0x8(%ebp),%edx
80104edb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ede:	53                   	push   %ebx
80104edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104ee2:	89 d7                	mov    %edx,%edi
80104ee4:	09 cf                	or     %ecx,%edi
80104ee6:	83 e7 03             	and    $0x3,%edi
80104ee9:	75 25                	jne    80104f10 <memset+0x40>
    c &= 0xFF;
80104eeb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104eee:	c1 e0 18             	shl    $0x18,%eax
80104ef1:	89 fb                	mov    %edi,%ebx
80104ef3:	c1 e9 02             	shr    $0x2,%ecx
80104ef6:	c1 e3 10             	shl    $0x10,%ebx
80104ef9:	09 d8                	or     %ebx,%eax
80104efb:	09 f8                	or     %edi,%eax
80104efd:	c1 e7 08             	shl    $0x8,%edi
80104f00:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f02:	89 d7                	mov    %edx,%edi
80104f04:	fc                   	cld    
80104f05:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f07:	5b                   	pop    %ebx
80104f08:	89 d0                	mov    %edx,%eax
80104f0a:	5f                   	pop    %edi
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104f10:	89 d7                	mov    %edx,%edi
80104f12:	fc                   	cld    
80104f13:	f3 aa                	rep stos %al,%es:(%edi)
80104f15:	5b                   	pop    %ebx
80104f16:	89 d0                	mov    %edx,%eax
80104f18:	5f                   	pop    %edi
80104f19:	5d                   	pop    %ebp
80104f1a:	c3                   	ret    
80104f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f1f:	90                   	nop

80104f20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	56                   	push   %esi
80104f28:	8b 75 10             	mov    0x10(%ebp),%esi
80104f2b:	8b 55 08             	mov    0x8(%ebp),%edx
80104f2e:	53                   	push   %ebx
80104f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f32:	85 f6                	test   %esi,%esi
80104f34:	74 2a                	je     80104f60 <memcmp+0x40>
80104f36:	01 c6                	add    %eax,%esi
80104f38:	eb 10                	jmp    80104f4a <memcmp+0x2a>
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f40:	83 c0 01             	add    $0x1,%eax
80104f43:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f46:	39 f0                	cmp    %esi,%eax
80104f48:	74 16                	je     80104f60 <memcmp+0x40>
    if(*s1 != *s2)
80104f4a:	0f b6 0a             	movzbl (%edx),%ecx
80104f4d:	0f b6 18             	movzbl (%eax),%ebx
80104f50:	38 d9                	cmp    %bl,%cl
80104f52:	74 ec                	je     80104f40 <memcmp+0x20>
      return *s1 - *s2;
80104f54:	0f b6 c1             	movzbl %cl,%eax
80104f57:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f59:	5b                   	pop    %ebx
80104f5a:	5e                   	pop    %esi
80104f5b:	5d                   	pop    %ebp
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
80104f60:	5b                   	pop    %ebx
  return 0;
80104f61:	31 c0                	xor    %eax,%eax
}
80104f63:	5e                   	pop    %esi
80104f64:	5d                   	pop    %ebp
80104f65:	c3                   	ret    
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi

80104f70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f70:	f3 0f 1e fb          	endbr32 
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	57                   	push   %edi
80104f78:	8b 55 08             	mov    0x8(%ebp),%edx
80104f7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f7e:	56                   	push   %esi
80104f7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f82:	39 d6                	cmp    %edx,%esi
80104f84:	73 2a                	jae    80104fb0 <memmove+0x40>
80104f86:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f89:	39 fa                	cmp    %edi,%edx
80104f8b:	73 23                	jae    80104fb0 <memmove+0x40>
80104f8d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f90:	85 c9                	test   %ecx,%ecx
80104f92:	74 13                	je     80104fa7 <memmove+0x37>
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104f98:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f9c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f9f:	83 e8 01             	sub    $0x1,%eax
80104fa2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104fa5:	75 f1                	jne    80104f98 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104fa7:	5e                   	pop    %esi
80104fa8:	89 d0                	mov    %edx,%eax
80104faa:	5f                   	pop    %edi
80104fab:	5d                   	pop    %ebp
80104fac:	c3                   	ret    
80104fad:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104fb0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104fb3:	89 d7                	mov    %edx,%edi
80104fb5:	85 c9                	test   %ecx,%ecx
80104fb7:	74 ee                	je     80104fa7 <memmove+0x37>
80104fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104fc0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104fc1:	39 f0                	cmp    %esi,%eax
80104fc3:	75 fb                	jne    80104fc0 <memmove+0x50>
}
80104fc5:	5e                   	pop    %esi
80104fc6:	89 d0                	mov    %edx,%eax
80104fc8:	5f                   	pop    %edi
80104fc9:	5d                   	pop    %ebp
80104fca:	c3                   	ret    
80104fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fcf:	90                   	nop

80104fd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104fd0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104fd4:	eb 9a                	jmp    80104f70 <memmove>
80104fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi

80104fe0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104fe0:	f3 0f 1e fb          	endbr32 
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	56                   	push   %esi
80104fe8:	8b 75 10             	mov    0x10(%ebp),%esi
80104feb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fee:	53                   	push   %ebx
80104fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104ff2:	85 f6                	test   %esi,%esi
80104ff4:	74 32                	je     80105028 <strncmp+0x48>
80104ff6:	01 c6                	add    %eax,%esi
80104ff8:	eb 14                	jmp    8010500e <strncmp+0x2e>
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105000:	38 da                	cmp    %bl,%dl
80105002:	75 14                	jne    80105018 <strncmp+0x38>
    n--, p++, q++;
80105004:	83 c0 01             	add    $0x1,%eax
80105007:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010500a:	39 f0                	cmp    %esi,%eax
8010500c:	74 1a                	je     80105028 <strncmp+0x48>
8010500e:	0f b6 11             	movzbl (%ecx),%edx
80105011:	0f b6 18             	movzbl (%eax),%ebx
80105014:	84 d2                	test   %dl,%dl
80105016:	75 e8                	jne    80105000 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105018:	0f b6 c2             	movzbl %dl,%eax
8010501b:	29 d8                	sub    %ebx,%eax
}
8010501d:	5b                   	pop    %ebx
8010501e:	5e                   	pop    %esi
8010501f:	5d                   	pop    %ebp
80105020:	c3                   	ret    
80105021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105028:	5b                   	pop    %ebx
    return 0;
80105029:	31 c0                	xor    %eax,%eax
}
8010502b:	5e                   	pop    %esi
8010502c:	5d                   	pop    %ebp
8010502d:	c3                   	ret    
8010502e:	66 90                	xchg   %ax,%ax

80105030 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
80105035:	89 e5                	mov    %esp,%ebp
80105037:	57                   	push   %edi
80105038:	56                   	push   %esi
80105039:	8b 75 08             	mov    0x8(%ebp),%esi
8010503c:	53                   	push   %ebx
8010503d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105040:	89 f2                	mov    %esi,%edx
80105042:	eb 1b                	jmp    8010505f <strncpy+0x2f>
80105044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105048:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010504c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010504f:	83 c2 01             	add    $0x1,%edx
80105052:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105056:	89 f9                	mov    %edi,%ecx
80105058:	88 4a ff             	mov    %cl,-0x1(%edx)
8010505b:	84 c9                	test   %cl,%cl
8010505d:	74 09                	je     80105068 <strncpy+0x38>
8010505f:	89 c3                	mov    %eax,%ebx
80105061:	83 e8 01             	sub    $0x1,%eax
80105064:	85 db                	test   %ebx,%ebx
80105066:	7f e0                	jg     80105048 <strncpy+0x18>
    ;
  while(n-- > 0)
80105068:	89 d1                	mov    %edx,%ecx
8010506a:	85 c0                	test   %eax,%eax
8010506c:	7e 15                	jle    80105083 <strncpy+0x53>
8010506e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105070:	83 c1 01             	add    $0x1,%ecx
80105073:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105077:	89 c8                	mov    %ecx,%eax
80105079:	f7 d0                	not    %eax
8010507b:	01 d0                	add    %edx,%eax
8010507d:	01 d8                	add    %ebx,%eax
8010507f:	85 c0                	test   %eax,%eax
80105081:	7f ed                	jg     80105070 <strncpy+0x40>
  return os;
}
80105083:	5b                   	pop    %ebx
80105084:	89 f0                	mov    %esi,%eax
80105086:	5e                   	pop    %esi
80105087:	5f                   	pop    %edi
80105088:	5d                   	pop    %ebp
80105089:	c3                   	ret    
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105090 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	56                   	push   %esi
80105098:	8b 55 10             	mov    0x10(%ebp),%edx
8010509b:	8b 75 08             	mov    0x8(%ebp),%esi
8010509e:	53                   	push   %ebx
8010509f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801050a2:	85 d2                	test   %edx,%edx
801050a4:	7e 21                	jle    801050c7 <safestrcpy+0x37>
801050a6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801050aa:	89 f2                	mov    %esi,%edx
801050ac:	eb 12                	jmp    801050c0 <safestrcpy+0x30>
801050ae:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801050b0:	0f b6 08             	movzbl (%eax),%ecx
801050b3:	83 c0 01             	add    $0x1,%eax
801050b6:	83 c2 01             	add    $0x1,%edx
801050b9:	88 4a ff             	mov    %cl,-0x1(%edx)
801050bc:	84 c9                	test   %cl,%cl
801050be:	74 04                	je     801050c4 <safestrcpy+0x34>
801050c0:	39 d8                	cmp    %ebx,%eax
801050c2:	75 ec                	jne    801050b0 <safestrcpy+0x20>
    ;
  *s = 0;
801050c4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801050c7:	89 f0                	mov    %esi,%eax
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5d                   	pop    %ebp
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi

801050d0 <strlen>:

int
strlen(const char *s)
{
801050d0:	f3 0f 1e fb          	endbr32 
801050d4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801050d5:	31 c0                	xor    %eax,%eax
{
801050d7:	89 e5                	mov    %esp,%ebp
801050d9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801050dc:	80 3a 00             	cmpb   $0x0,(%edx)
801050df:	74 10                	je     801050f1 <strlen+0x21>
801050e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050e8:	83 c0 01             	add    $0x1,%eax
801050eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801050ef:	75 f7                	jne    801050e8 <strlen+0x18>
    ;
  return n;
}
801050f1:	5d                   	pop    %ebp
801050f2:	c3                   	ret    

801050f3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050f7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801050fb:	55                   	push   %ebp
  pushl %ebx
801050fc:	53                   	push   %ebx
  pushl %esi
801050fd:	56                   	push   %esi
  pushl %edi
801050fe:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050ff:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105101:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105103:	5f                   	pop    %edi
  popl %esi
80105104:	5e                   	pop    %esi
  popl %ebx
80105105:	5b                   	pop    %ebx
  popl %ebp
80105106:	5d                   	pop    %ebp
  ret
80105107:	c3                   	ret    
80105108:	66 90                	xchg   %ax,%ax
8010510a:	66 90                	xchg   %ax,%ax
8010510c:	66 90                	xchg   %ax,%ax
8010510e:	66 90                	xchg   %ax,%ax

80105110 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105110:	f3 0f 1e fb          	endbr32 
80105114:	55                   	push   %ebp
80105115:	89 e5                	mov    %esp,%ebp
80105117:	53                   	push   %ebx
80105118:	83 ec 04             	sub    $0x4,%esp
8010511b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010511e:	e8 9d f0 ff ff       	call   801041c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105123:	8b 00                	mov    (%eax),%eax
80105125:	39 d8                	cmp    %ebx,%eax
80105127:	76 17                	jbe    80105140 <fetchint+0x30>
80105129:	8d 53 04             	lea    0x4(%ebx),%edx
8010512c:	39 d0                	cmp    %edx,%eax
8010512e:	72 10                	jb     80105140 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105130:	8b 45 0c             	mov    0xc(%ebp),%eax
80105133:	8b 13                	mov    (%ebx),%edx
80105135:	89 10                	mov    %edx,(%eax)
  return 0;
80105137:	31 c0                	xor    %eax,%eax
}
80105139:	83 c4 04             	add    $0x4,%esp
8010513c:	5b                   	pop    %ebx
8010513d:	5d                   	pop    %ebp
8010513e:	c3                   	ret    
8010513f:	90                   	nop
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105145:	eb f2                	jmp    80105139 <fetchint+0x29>
80105147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514e:	66 90                	xchg   %ax,%ax

80105150 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105150:	f3 0f 1e fb          	endbr32 
80105154:	55                   	push   %ebp
80105155:	89 e5                	mov    %esp,%ebp
80105157:	53                   	push   %ebx
80105158:	83 ec 04             	sub    $0x4,%esp
8010515b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010515e:	e8 5d f0 ff ff       	call   801041c0 <myproc>

  if(addr >= curproc->sz)
80105163:	39 18                	cmp    %ebx,(%eax)
80105165:	76 31                	jbe    80105198 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105167:	8b 55 0c             	mov    0xc(%ebp),%edx
8010516a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010516c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010516e:	39 d3                	cmp    %edx,%ebx
80105170:	73 26                	jae    80105198 <fetchstr+0x48>
80105172:	89 d8                	mov    %ebx,%eax
80105174:	eb 11                	jmp    80105187 <fetchstr+0x37>
80105176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
80105180:	83 c0 01             	add    $0x1,%eax
80105183:	39 c2                	cmp    %eax,%edx
80105185:	76 11                	jbe    80105198 <fetchstr+0x48>
    if(*s == 0)
80105187:	80 38 00             	cmpb   $0x0,(%eax)
8010518a:	75 f4                	jne    80105180 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010518c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010518f:	29 d8                	sub    %ebx,%eax
}
80105191:	5b                   	pop    %ebx
80105192:	5d                   	pop    %ebp
80105193:	c3                   	ret    
80105194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105198:	83 c4 04             	add    $0x4,%esp
    return -1;
8010519b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051a0:	5b                   	pop    %ebx
801051a1:	5d                   	pop    %ebp
801051a2:	c3                   	ret    
801051a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	56                   	push   %esi
801051b8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051b9:	e8 02 f0 ff ff       	call   801041c0 <myproc>
801051be:	8b 55 08             	mov    0x8(%ebp),%edx
801051c1:	8b 40 18             	mov    0x18(%eax),%eax
801051c4:	8b 40 44             	mov    0x44(%eax),%eax
801051c7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051ca:	e8 f1 ef ff ff       	call   801041c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051cf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051d2:	8b 00                	mov    (%eax),%eax
801051d4:	39 c6                	cmp    %eax,%esi
801051d6:	73 18                	jae    801051f0 <argint+0x40>
801051d8:	8d 53 08             	lea    0x8(%ebx),%edx
801051db:	39 d0                	cmp    %edx,%eax
801051dd:	72 11                	jb     801051f0 <argint+0x40>
  *ip = *(int*)(addr);
801051df:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e2:	8b 53 04             	mov    0x4(%ebx),%edx
801051e5:	89 10                	mov    %edx,(%eax)
  return 0;
801051e7:	31 c0                	xor    %eax,%eax
}
801051e9:	5b                   	pop    %ebx
801051ea:	5e                   	pop    %esi
801051eb:	5d                   	pop    %ebp
801051ec:	c3                   	ret    
801051ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051f5:	eb f2                	jmp    801051e9 <argint+0x39>
801051f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fe:	66 90                	xchg   %ax,%ax

80105200 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	56                   	push   %esi
80105208:	53                   	push   %ebx
80105209:	83 ec 10             	sub    $0x10,%esp
8010520c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010520f:	e8 ac ef ff ff       	call   801041c0 <myproc>
 
  if(argint(n, &i) < 0)
80105214:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105217:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105219:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521c:	50                   	push   %eax
8010521d:	ff 75 08             	pushl  0x8(%ebp)
80105220:	e8 8b ff ff ff       	call   801051b0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	85 c0                	test   %eax,%eax
8010522a:	78 24                	js     80105250 <argptr+0x50>
8010522c:	85 db                	test   %ebx,%ebx
8010522e:	78 20                	js     80105250 <argptr+0x50>
80105230:	8b 16                	mov    (%esi),%edx
80105232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105235:	39 c2                	cmp    %eax,%edx
80105237:	76 17                	jbe    80105250 <argptr+0x50>
80105239:	01 c3                	add    %eax,%ebx
8010523b:	39 da                	cmp    %ebx,%edx
8010523d:	72 11                	jb     80105250 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010523f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105242:	89 02                	mov    %eax,(%edx)
  return 0;
80105244:	31 c0                	xor    %eax,%eax
}
80105246:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105249:	5b                   	pop    %ebx
8010524a:	5e                   	pop    %esi
8010524b:	5d                   	pop    %ebp
8010524c:	c3                   	ret    
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105255:	eb ef                	jmp    80105246 <argptr+0x46>
80105257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525e:	66 90                	xchg   %ax,%ax

80105260 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105260:	f3 0f 1e fb          	endbr32 
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010526a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010526d:	50                   	push   %eax
8010526e:	ff 75 08             	pushl  0x8(%ebp)
80105271:	e8 3a ff ff ff       	call   801051b0 <argint>
80105276:	83 c4 10             	add    $0x10,%esp
80105279:	85 c0                	test   %eax,%eax
8010527b:	78 13                	js     80105290 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010527d:	83 ec 08             	sub    $0x8,%esp
80105280:	ff 75 0c             	pushl  0xc(%ebp)
80105283:	ff 75 f4             	pushl  -0xc(%ebp)
80105286:	e8 c5 fe ff ff       	call   80105150 <fetchstr>
8010528b:	83 c4 10             	add    $0x10,%esp
}
8010528e:	c9                   	leave  
8010528f:	c3                   	ret    
80105290:	c9                   	leave  
    return -1;
80105291:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105296:	c3                   	ret    
80105297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529e:	66 90                	xchg   %ax,%ax

801052a0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801052a0:	f3 0f 1e fb          	endbr32 
801052a4:	55                   	push   %ebp
801052a5:	89 e5                	mov    %esp,%ebp
801052a7:	53                   	push   %ebx
801052a8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801052ab:	e8 10 ef ff ff       	call   801041c0 <myproc>
801052b0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801052b2:	8b 40 18             	mov    0x18(%eax),%eax
801052b5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052b8:	8d 50 ff             	lea    -0x1(%eax),%edx
801052bb:	83 fa 14             	cmp    $0x14,%edx
801052be:	77 20                	ja     801052e0 <syscall+0x40>
801052c0:	8b 14 85 40 80 10 80 	mov    -0x7fef7fc0(,%eax,4),%edx
801052c7:	85 d2                	test   %edx,%edx
801052c9:	74 15                	je     801052e0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801052cb:	ff d2                	call   *%edx
801052cd:	89 c2                	mov    %eax,%edx
801052cf:	8b 43 18             	mov    0x18(%ebx),%eax
801052d2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801052d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052d8:	c9                   	leave  
801052d9:	c3                   	ret    
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801052e0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801052e1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801052e4:	50                   	push   %eax
801052e5:	ff 73 10             	pushl  0x10(%ebx)
801052e8:	68 1d 80 10 80       	push   $0x8010801d
801052ed:	e8 5e b6 ff ff       	call   80100950 <cprintf>
    curproc->tf->eax = -1;
801052f2:	8b 43 18             	mov    0x18(%ebx),%eax
801052f5:	83 c4 10             	add    $0x10,%esp
801052f8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105302:	c9                   	leave  
80105303:	c3                   	ret    
80105304:	66 90                	xchg   %ax,%ax
80105306:	66 90                	xchg   %ax,%ax
80105308:	66 90                	xchg   %ax,%ax
8010530a:	66 90                	xchg   %ax,%ax
8010530c:	66 90                	xchg   %ax,%ax
8010530e:	66 90                	xchg   %ax,%ax

80105310 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105315:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105318:	53                   	push   %ebx
80105319:	83 ec 34             	sub    $0x34,%esp
8010531c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010531f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105322:	57                   	push   %edi
80105323:	50                   	push   %eax
{
80105324:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105327:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010532a:	e8 81 d5 ff ff       	call   801028b0 <nameiparent>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	85 c0                	test   %eax,%eax
80105334:	0f 84 46 01 00 00    	je     80105480 <create+0x170>
    return 0;
  ilock(dp);
8010533a:	83 ec 0c             	sub    $0xc,%esp
8010533d:	89 c3                	mov    %eax,%ebx
8010533f:	50                   	push   %eax
80105340:	e8 7b cc ff ff       	call   80101fc0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105345:	83 c4 0c             	add    $0xc,%esp
80105348:	6a 00                	push   $0x0
8010534a:	57                   	push   %edi
8010534b:	53                   	push   %ebx
8010534c:	e8 bf d1 ff ff       	call   80102510 <dirlookup>
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	89 c6                	mov    %eax,%esi
80105356:	85 c0                	test   %eax,%eax
80105358:	74 56                	je     801053b0 <create+0xa0>
    iunlockput(dp);
8010535a:	83 ec 0c             	sub    $0xc,%esp
8010535d:	53                   	push   %ebx
8010535e:	e8 fd ce ff ff       	call   80102260 <iunlockput>
    ilock(ip);
80105363:	89 34 24             	mov    %esi,(%esp)
80105366:	e8 55 cc ff ff       	call   80101fc0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010536b:	83 c4 10             	add    $0x10,%esp
8010536e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105373:	75 1b                	jne    80105390 <create+0x80>
80105375:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010537a:	75 14                	jne    80105390 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010537c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537f:	89 f0                	mov    %esi,%eax
80105381:	5b                   	pop    %ebx
80105382:	5e                   	pop    %esi
80105383:	5f                   	pop    %edi
80105384:	5d                   	pop    %ebp
80105385:	c3                   	ret    
80105386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	56                   	push   %esi
    return 0;
80105394:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105396:	e8 c5 ce ff ff       	call   80102260 <iunlockput>
    return 0;
8010539b:	83 c4 10             	add    $0x10,%esp
}
8010539e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a1:	89 f0                	mov    %esi,%eax
801053a3:	5b                   	pop    %ebx
801053a4:	5e                   	pop    %esi
801053a5:	5f                   	pop    %edi
801053a6:	5d                   	pop    %ebp
801053a7:	c3                   	ret    
801053a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053af:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801053b0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801053b4:	83 ec 08             	sub    $0x8,%esp
801053b7:	50                   	push   %eax
801053b8:	ff 33                	pushl  (%ebx)
801053ba:	e8 81 ca ff ff       	call   80101e40 <ialloc>
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	89 c6                	mov    %eax,%esi
801053c4:	85 c0                	test   %eax,%eax
801053c6:	0f 84 cd 00 00 00    	je     80105499 <create+0x189>
  ilock(ip);
801053cc:	83 ec 0c             	sub    $0xc,%esp
801053cf:	50                   	push   %eax
801053d0:	e8 eb cb ff ff       	call   80101fc0 <ilock>
  ip->major = major;
801053d5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801053d9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801053dd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801053e1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801053e5:	b8 01 00 00 00       	mov    $0x1,%eax
801053ea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801053ee:	89 34 24             	mov    %esi,(%esp)
801053f1:	e8 0a cb ff ff       	call   80101f00 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053fe:	74 30                	je     80105430 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105400:	83 ec 04             	sub    $0x4,%esp
80105403:	ff 76 04             	pushl  0x4(%esi)
80105406:	57                   	push   %edi
80105407:	53                   	push   %ebx
80105408:	e8 c3 d3 ff ff       	call   801027d0 <dirlink>
8010540d:	83 c4 10             	add    $0x10,%esp
80105410:	85 c0                	test   %eax,%eax
80105412:	78 78                	js     8010548c <create+0x17c>
  iunlockput(dp);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	53                   	push   %ebx
80105418:	e8 43 ce ff ff       	call   80102260 <iunlockput>
  return ip;
8010541d:	83 c4 10             	add    $0x10,%esp
}
80105420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105423:	89 f0                	mov    %esi,%eax
80105425:	5b                   	pop    %ebx
80105426:	5e                   	pop    %esi
80105427:	5f                   	pop    %edi
80105428:	5d                   	pop    %ebp
80105429:	c3                   	ret    
8010542a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105433:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105438:	53                   	push   %ebx
80105439:	e8 c2 ca ff ff       	call   80101f00 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010543e:	83 c4 0c             	add    $0xc,%esp
80105441:	ff 76 04             	pushl  0x4(%esi)
80105444:	68 b4 80 10 80       	push   $0x801080b4
80105449:	56                   	push   %esi
8010544a:	e8 81 d3 ff ff       	call   801027d0 <dirlink>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	85 c0                	test   %eax,%eax
80105454:	78 18                	js     8010546e <create+0x15e>
80105456:	83 ec 04             	sub    $0x4,%esp
80105459:	ff 73 04             	pushl  0x4(%ebx)
8010545c:	68 b3 80 10 80       	push   $0x801080b3
80105461:	56                   	push   %esi
80105462:	e8 69 d3 ff ff       	call   801027d0 <dirlink>
80105467:	83 c4 10             	add    $0x10,%esp
8010546a:	85 c0                	test   %eax,%eax
8010546c:	79 92                	jns    80105400 <create+0xf0>
      panic("create dots");
8010546e:	83 ec 0c             	sub    $0xc,%esp
80105471:	68 a7 80 10 80       	push   $0x801080a7
80105476:	e8 15 af ff ff       	call   80100390 <panic>
8010547b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010547f:	90                   	nop
}
80105480:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105483:	31 f6                	xor    %esi,%esi
}
80105485:	5b                   	pop    %ebx
80105486:	89 f0                	mov    %esi,%eax
80105488:	5e                   	pop    %esi
80105489:	5f                   	pop    %edi
8010548a:	5d                   	pop    %ebp
8010548b:	c3                   	ret    
    panic("create: dirlink");
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 b6 80 10 80       	push   $0x801080b6
80105494:	e8 f7 ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	68 98 80 10 80       	push   $0x80108098
801054a1:	e8 ea ae ff ff       	call   80100390 <panic>
801054a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ad:	8d 76 00             	lea    0x0(%esi),%esi

801054b0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	89 d6                	mov    %edx,%esi
801054b6:	53                   	push   %ebx
801054b7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801054b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801054bc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054bf:	50                   	push   %eax
801054c0:	6a 00                	push   $0x0
801054c2:	e8 e9 fc ff ff       	call   801051b0 <argint>
801054c7:	83 c4 10             	add    $0x10,%esp
801054ca:	85 c0                	test   %eax,%eax
801054cc:	78 2a                	js     801054f8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054d2:	77 24                	ja     801054f8 <argfd.constprop.0+0x48>
801054d4:	e8 e7 ec ff ff       	call   801041c0 <myproc>
801054d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054dc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801054e0:	85 c0                	test   %eax,%eax
801054e2:	74 14                	je     801054f8 <argfd.constprop.0+0x48>
  if(pfd)
801054e4:	85 db                	test   %ebx,%ebx
801054e6:	74 02                	je     801054ea <argfd.constprop.0+0x3a>
    *pfd = fd;
801054e8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801054ea:	89 06                	mov    %eax,(%esi)
  return 0;
801054ec:	31 c0                	xor    %eax,%eax
}
801054ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054f1:	5b                   	pop    %ebx
801054f2:	5e                   	pop    %esi
801054f3:	5d                   	pop    %ebp
801054f4:	c3                   	ret    
801054f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fd:	eb ef                	jmp    801054ee <argfd.constprop.0+0x3e>
801054ff:	90                   	nop

80105500 <sys_dup>:
{
80105500:	f3 0f 1e fb          	endbr32 
80105504:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105505:	31 c0                	xor    %eax,%eax
{
80105507:	89 e5                	mov    %esp,%ebp
80105509:	56                   	push   %esi
8010550a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010550b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010550e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105511:	e8 9a ff ff ff       	call   801054b0 <argfd.constprop.0>
80105516:	85 c0                	test   %eax,%eax
80105518:	78 1e                	js     80105538 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010551a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010551d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010551f:	e8 9c ec ff ff       	call   801041c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105528:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010552c:	85 d2                	test   %edx,%edx
8010552e:	74 20                	je     80105550 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105530:	83 c3 01             	add    $0x1,%ebx
80105533:	83 fb 10             	cmp    $0x10,%ebx
80105536:	75 f0                	jne    80105528 <sys_dup+0x28>
}
80105538:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010553b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105540:	89 d8                	mov    %ebx,%eax
80105542:	5b                   	pop    %ebx
80105543:	5e                   	pop    %esi
80105544:	5d                   	pop    %ebp
80105545:	c3                   	ret    
80105546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105550:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	ff 75 f4             	pushl  -0xc(%ebp)
8010555a:	e8 71 c1 ff ff       	call   801016d0 <filedup>
  return fd;
8010555f:	83 c4 10             	add    $0x10,%esp
}
80105562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105565:	89 d8                	mov    %ebx,%eax
80105567:	5b                   	pop    %ebx
80105568:	5e                   	pop    %esi
80105569:	5d                   	pop    %ebp
8010556a:	c3                   	ret    
8010556b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010556f:	90                   	nop

80105570 <sys_read>:
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105575:	31 c0                	xor    %eax,%eax
{
80105577:	89 e5                	mov    %esp,%ebp
80105579:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010557c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010557f:	e8 2c ff ff ff       	call   801054b0 <argfd.constprop.0>
80105584:	85 c0                	test   %eax,%eax
80105586:	78 48                	js     801055d0 <sys_read+0x60>
80105588:	83 ec 08             	sub    $0x8,%esp
8010558b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010558e:	50                   	push   %eax
8010558f:	6a 02                	push   $0x2
80105591:	e8 1a fc ff ff       	call   801051b0 <argint>
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	85 c0                	test   %eax,%eax
8010559b:	78 33                	js     801055d0 <sys_read+0x60>
8010559d:	83 ec 04             	sub    $0x4,%esp
801055a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055a3:	ff 75 f0             	pushl  -0x10(%ebp)
801055a6:	50                   	push   %eax
801055a7:	6a 01                	push   $0x1
801055a9:	e8 52 fc ff ff       	call   80105200 <argptr>
801055ae:	83 c4 10             	add    $0x10,%esp
801055b1:	85 c0                	test   %eax,%eax
801055b3:	78 1b                	js     801055d0 <sys_read+0x60>
  return fileread(f, p, n);
801055b5:	83 ec 04             	sub    $0x4,%esp
801055b8:	ff 75 f0             	pushl  -0x10(%ebp)
801055bb:	ff 75 f4             	pushl  -0xc(%ebp)
801055be:	ff 75 ec             	pushl  -0x14(%ebp)
801055c1:	e8 8a c2 ff ff       	call   80101850 <fileread>
801055c6:	83 c4 10             	add    $0x10,%esp
}
801055c9:	c9                   	leave  
801055ca:	c3                   	ret    
801055cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055cf:	90                   	nop
801055d0:	c9                   	leave  
    return -1;
801055d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d6:	c3                   	ret    
801055d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055de:	66 90                	xchg   %ax,%ax

801055e0 <sys_write>:
{
801055e0:	f3 0f 1e fb          	endbr32 
801055e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055e5:	31 c0                	xor    %eax,%eax
{
801055e7:	89 e5                	mov    %esp,%ebp
801055e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055ec:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055ef:	e8 bc fe ff ff       	call   801054b0 <argfd.constprop.0>
801055f4:	85 c0                	test   %eax,%eax
801055f6:	78 48                	js     80105640 <sys_write+0x60>
801055f8:	83 ec 08             	sub    $0x8,%esp
801055fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055fe:	50                   	push   %eax
801055ff:	6a 02                	push   $0x2
80105601:	e8 aa fb ff ff       	call   801051b0 <argint>
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	85 c0                	test   %eax,%eax
8010560b:	78 33                	js     80105640 <sys_write+0x60>
8010560d:	83 ec 04             	sub    $0x4,%esp
80105610:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105613:	ff 75 f0             	pushl  -0x10(%ebp)
80105616:	50                   	push   %eax
80105617:	6a 01                	push   $0x1
80105619:	e8 e2 fb ff ff       	call   80105200 <argptr>
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	85 c0                	test   %eax,%eax
80105623:	78 1b                	js     80105640 <sys_write+0x60>
  return filewrite(f, p, n);
80105625:	83 ec 04             	sub    $0x4,%esp
80105628:	ff 75 f0             	pushl  -0x10(%ebp)
8010562b:	ff 75 f4             	pushl  -0xc(%ebp)
8010562e:	ff 75 ec             	pushl  -0x14(%ebp)
80105631:	e8 ba c2 ff ff       	call   801018f0 <filewrite>
80105636:	83 c4 10             	add    $0x10,%esp
}
80105639:	c9                   	leave  
8010563a:	c3                   	ret    
8010563b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop
80105640:	c9                   	leave  
    return -1;
80105641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105646:	c3                   	ret    
80105647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564e:	66 90                	xchg   %ax,%ax

80105650 <sys_close>:
{
80105650:	f3 0f 1e fb          	endbr32 
80105654:	55                   	push   %ebp
80105655:	89 e5                	mov    %esp,%ebp
80105657:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010565a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010565d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105660:	e8 4b fe ff ff       	call   801054b0 <argfd.constprop.0>
80105665:	85 c0                	test   %eax,%eax
80105667:	78 27                	js     80105690 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105669:	e8 52 eb ff ff       	call   801041c0 <myproc>
8010566e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105671:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105674:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010567b:	00 
  fileclose(f);
8010567c:	ff 75 f4             	pushl  -0xc(%ebp)
8010567f:	e8 9c c0 ff ff       	call   80101720 <fileclose>
  return 0;
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	31 c0                	xor    %eax,%eax
}
80105689:	c9                   	leave  
8010568a:	c3                   	ret    
8010568b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010568f:	90                   	nop
80105690:	c9                   	leave  
    return -1;
80105691:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105696:	c3                   	ret    
80105697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <sys_fstat>:
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056a5:	31 c0                	xor    %eax,%eax
{
801056a7:	89 e5                	mov    %esp,%ebp
801056a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056ac:	8d 55 f0             	lea    -0x10(%ebp),%edx
801056af:	e8 fc fd ff ff       	call   801054b0 <argfd.constprop.0>
801056b4:	85 c0                	test   %eax,%eax
801056b6:	78 30                	js     801056e8 <sys_fstat+0x48>
801056b8:	83 ec 04             	sub    $0x4,%esp
801056bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056be:	6a 14                	push   $0x14
801056c0:	50                   	push   %eax
801056c1:	6a 01                	push   $0x1
801056c3:	e8 38 fb ff ff       	call   80105200 <argptr>
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	85 c0                	test   %eax,%eax
801056cd:	78 19                	js     801056e8 <sys_fstat+0x48>
  return filestat(f, st);
801056cf:	83 ec 08             	sub    $0x8,%esp
801056d2:	ff 75 f4             	pushl  -0xc(%ebp)
801056d5:	ff 75 f0             	pushl  -0x10(%ebp)
801056d8:	e8 23 c1 ff ff       	call   80101800 <filestat>
801056dd:	83 c4 10             	add    $0x10,%esp
}
801056e0:	c9                   	leave  
801056e1:	c3                   	ret    
801056e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056e8:	c9                   	leave  
    return -1;
801056e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ee:	c3                   	ret    
801056ef:	90                   	nop

801056f0 <sys_link>:
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
801056f5:	89 e5                	mov    %esp,%ebp
801056f7:	57                   	push   %edi
801056f8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056f9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056fc:	53                   	push   %ebx
801056fd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105700:	50                   	push   %eax
80105701:	6a 00                	push   $0x0
80105703:	e8 58 fb ff ff       	call   80105260 <argstr>
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	85 c0                	test   %eax,%eax
8010570d:	0f 88 ff 00 00 00    	js     80105812 <sys_link+0x122>
80105713:	83 ec 08             	sub    $0x8,%esp
80105716:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105719:	50                   	push   %eax
8010571a:	6a 01                	push   $0x1
8010571c:	e8 3f fb ff ff       	call   80105260 <argstr>
80105721:	83 c4 10             	add    $0x10,%esp
80105724:	85 c0                	test   %eax,%eax
80105726:	0f 88 e6 00 00 00    	js     80105812 <sys_link+0x122>
  begin_op();
8010572c:	e8 5f de ff ff       	call   80103590 <begin_op>
  if((ip = namei(old)) == 0){
80105731:	83 ec 0c             	sub    $0xc,%esp
80105734:	ff 75 d4             	pushl  -0x2c(%ebp)
80105737:	e8 54 d1 ff ff       	call   80102890 <namei>
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	89 c3                	mov    %eax,%ebx
80105741:	85 c0                	test   %eax,%eax
80105743:	0f 84 e8 00 00 00    	je     80105831 <sys_link+0x141>
  ilock(ip);
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	50                   	push   %eax
8010574d:	e8 6e c8 ff ff       	call   80101fc0 <ilock>
  if(ip->type == T_DIR){
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010575a:	0f 84 b9 00 00 00    	je     80105819 <sys_link+0x129>
  iupdate(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105763:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105768:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010576b:	53                   	push   %ebx
8010576c:	e8 8f c7 ff ff       	call   80101f00 <iupdate>
  iunlock(ip);
80105771:	89 1c 24             	mov    %ebx,(%esp)
80105774:	e8 27 c9 ff ff       	call   801020a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105779:	58                   	pop    %eax
8010577a:	5a                   	pop    %edx
8010577b:	57                   	push   %edi
8010577c:	ff 75 d0             	pushl  -0x30(%ebp)
8010577f:	e8 2c d1 ff ff       	call   801028b0 <nameiparent>
80105784:	83 c4 10             	add    $0x10,%esp
80105787:	89 c6                	mov    %eax,%esi
80105789:	85 c0                	test   %eax,%eax
8010578b:	74 5f                	je     801057ec <sys_link+0xfc>
  ilock(dp);
8010578d:	83 ec 0c             	sub    $0xc,%esp
80105790:	50                   	push   %eax
80105791:	e8 2a c8 ff ff       	call   80101fc0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105796:	8b 03                	mov    (%ebx),%eax
80105798:	83 c4 10             	add    $0x10,%esp
8010579b:	39 06                	cmp    %eax,(%esi)
8010579d:	75 41                	jne    801057e0 <sys_link+0xf0>
8010579f:	83 ec 04             	sub    $0x4,%esp
801057a2:	ff 73 04             	pushl  0x4(%ebx)
801057a5:	57                   	push   %edi
801057a6:	56                   	push   %esi
801057a7:	e8 24 d0 ff ff       	call   801027d0 <dirlink>
801057ac:	83 c4 10             	add    $0x10,%esp
801057af:	85 c0                	test   %eax,%eax
801057b1:	78 2d                	js     801057e0 <sys_link+0xf0>
  iunlockput(dp);
801057b3:	83 ec 0c             	sub    $0xc,%esp
801057b6:	56                   	push   %esi
801057b7:	e8 a4 ca ff ff       	call   80102260 <iunlockput>
  iput(ip);
801057bc:	89 1c 24             	mov    %ebx,(%esp)
801057bf:	e8 2c c9 ff ff       	call   801020f0 <iput>
  end_op();
801057c4:	e8 37 de ff ff       	call   80103600 <end_op>
  return 0;
801057c9:	83 c4 10             	add    $0x10,%esp
801057cc:	31 c0                	xor    %eax,%eax
}
801057ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d1:	5b                   	pop    %ebx
801057d2:	5e                   	pop    %esi
801057d3:	5f                   	pop    %edi
801057d4:	5d                   	pop    %ebp
801057d5:	c3                   	ret    
801057d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801057e0:	83 ec 0c             	sub    $0xc,%esp
801057e3:	56                   	push   %esi
801057e4:	e8 77 ca ff ff       	call   80102260 <iunlockput>
    goto bad;
801057e9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057ec:	83 ec 0c             	sub    $0xc,%esp
801057ef:	53                   	push   %ebx
801057f0:	e8 cb c7 ff ff       	call   80101fc0 <ilock>
  ip->nlink--;
801057f5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057fa:	89 1c 24             	mov    %ebx,(%esp)
801057fd:	e8 fe c6 ff ff       	call   80101f00 <iupdate>
  iunlockput(ip);
80105802:	89 1c 24             	mov    %ebx,(%esp)
80105805:	e8 56 ca ff ff       	call   80102260 <iunlockput>
  end_op();
8010580a:	e8 f1 dd ff ff       	call   80103600 <end_op>
  return -1;
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105817:	eb b5                	jmp    801057ce <sys_link+0xde>
    iunlockput(ip);
80105819:	83 ec 0c             	sub    $0xc,%esp
8010581c:	53                   	push   %ebx
8010581d:	e8 3e ca ff ff       	call   80102260 <iunlockput>
    end_op();
80105822:	e8 d9 dd ff ff       	call   80103600 <end_op>
    return -1;
80105827:	83 c4 10             	add    $0x10,%esp
8010582a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582f:	eb 9d                	jmp    801057ce <sys_link+0xde>
    end_op();
80105831:	e8 ca dd ff ff       	call   80103600 <end_op>
    return -1;
80105836:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583b:	eb 91                	jmp    801057ce <sys_link+0xde>
8010583d:	8d 76 00             	lea    0x0(%esi),%esi

80105840 <sys_unlink>:
{
80105840:	f3 0f 1e fb          	endbr32 
80105844:	55                   	push   %ebp
80105845:	89 e5                	mov    %esp,%ebp
80105847:	57                   	push   %edi
80105848:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105849:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010584c:	53                   	push   %ebx
8010584d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105850:	50                   	push   %eax
80105851:	6a 00                	push   $0x0
80105853:	e8 08 fa ff ff       	call   80105260 <argstr>
80105858:	83 c4 10             	add    $0x10,%esp
8010585b:	85 c0                	test   %eax,%eax
8010585d:	0f 88 7d 01 00 00    	js     801059e0 <sys_unlink+0x1a0>
  begin_op();
80105863:	e8 28 dd ff ff       	call   80103590 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105868:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010586b:	83 ec 08             	sub    $0x8,%esp
8010586e:	53                   	push   %ebx
8010586f:	ff 75 c0             	pushl  -0x40(%ebp)
80105872:	e8 39 d0 ff ff       	call   801028b0 <nameiparent>
80105877:	83 c4 10             	add    $0x10,%esp
8010587a:	89 c6                	mov    %eax,%esi
8010587c:	85 c0                	test   %eax,%eax
8010587e:	0f 84 66 01 00 00    	je     801059ea <sys_unlink+0x1aa>
  ilock(dp);
80105884:	83 ec 0c             	sub    $0xc,%esp
80105887:	50                   	push   %eax
80105888:	e8 33 c7 ff ff       	call   80101fc0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010588d:	58                   	pop    %eax
8010588e:	5a                   	pop    %edx
8010588f:	68 b4 80 10 80       	push   $0x801080b4
80105894:	53                   	push   %ebx
80105895:	e8 56 cc ff ff       	call   801024f0 <namecmp>
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	85 c0                	test   %eax,%eax
8010589f:	0f 84 03 01 00 00    	je     801059a8 <sys_unlink+0x168>
801058a5:	83 ec 08             	sub    $0x8,%esp
801058a8:	68 b3 80 10 80       	push   $0x801080b3
801058ad:	53                   	push   %ebx
801058ae:	e8 3d cc ff ff       	call   801024f0 <namecmp>
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	85 c0                	test   %eax,%eax
801058b8:	0f 84 ea 00 00 00    	je     801059a8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801058be:	83 ec 04             	sub    $0x4,%esp
801058c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058c4:	50                   	push   %eax
801058c5:	53                   	push   %ebx
801058c6:	56                   	push   %esi
801058c7:	e8 44 cc ff ff       	call   80102510 <dirlookup>
801058cc:	83 c4 10             	add    $0x10,%esp
801058cf:	89 c3                	mov    %eax,%ebx
801058d1:	85 c0                	test   %eax,%eax
801058d3:	0f 84 cf 00 00 00    	je     801059a8 <sys_unlink+0x168>
  ilock(ip);
801058d9:	83 ec 0c             	sub    $0xc,%esp
801058dc:	50                   	push   %eax
801058dd:	e8 de c6 ff ff       	call   80101fc0 <ilock>
  if(ip->nlink < 1)
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058ea:	0f 8e 23 01 00 00    	jle    80105a13 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058f8:	74 66                	je     80105960 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058fa:	83 ec 04             	sub    $0x4,%esp
801058fd:	6a 10                	push   $0x10
801058ff:	6a 00                	push   $0x0
80105901:	57                   	push   %edi
80105902:	e8 c9 f5 ff ff       	call   80104ed0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105907:	6a 10                	push   $0x10
80105909:	ff 75 c4             	pushl  -0x3c(%ebp)
8010590c:	57                   	push   %edi
8010590d:	56                   	push   %esi
8010590e:	e8 ad ca ff ff       	call   801023c0 <writei>
80105913:	83 c4 20             	add    $0x20,%esp
80105916:	83 f8 10             	cmp    $0x10,%eax
80105919:	0f 85 e7 00 00 00    	jne    80105a06 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010591f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105924:	0f 84 96 00 00 00    	je     801059c0 <sys_unlink+0x180>
  iunlockput(dp);
8010592a:	83 ec 0c             	sub    $0xc,%esp
8010592d:	56                   	push   %esi
8010592e:	e8 2d c9 ff ff       	call   80102260 <iunlockput>
  ip->nlink--;
80105933:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105938:	89 1c 24             	mov    %ebx,(%esp)
8010593b:	e8 c0 c5 ff ff       	call   80101f00 <iupdate>
  iunlockput(ip);
80105940:	89 1c 24             	mov    %ebx,(%esp)
80105943:	e8 18 c9 ff ff       	call   80102260 <iunlockput>
  end_op();
80105948:	e8 b3 dc ff ff       	call   80103600 <end_op>
  return 0;
8010594d:	83 c4 10             	add    $0x10,%esp
80105950:	31 c0                	xor    %eax,%eax
}
80105952:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105955:	5b                   	pop    %ebx
80105956:	5e                   	pop    %esi
80105957:	5f                   	pop    %edi
80105958:	5d                   	pop    %ebp
80105959:	c3                   	ret    
8010595a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105960:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105964:	76 94                	jbe    801058fa <sys_unlink+0xba>
80105966:	ba 20 00 00 00       	mov    $0x20,%edx
8010596b:	eb 0b                	jmp    80105978 <sys_unlink+0x138>
8010596d:	8d 76 00             	lea    0x0(%esi),%esi
80105970:	83 c2 10             	add    $0x10,%edx
80105973:	39 53 58             	cmp    %edx,0x58(%ebx)
80105976:	76 82                	jbe    801058fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105978:	6a 10                	push   $0x10
8010597a:	52                   	push   %edx
8010597b:	57                   	push   %edi
8010597c:	53                   	push   %ebx
8010597d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105980:	e8 3b c9 ff ff       	call   801022c0 <readi>
80105985:	83 c4 10             	add    $0x10,%esp
80105988:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010598b:	83 f8 10             	cmp    $0x10,%eax
8010598e:	75 69                	jne    801059f9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105990:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105995:	74 d9                	je     80105970 <sys_unlink+0x130>
    iunlockput(ip);
80105997:	83 ec 0c             	sub    $0xc,%esp
8010599a:	53                   	push   %ebx
8010599b:	e8 c0 c8 ff ff       	call   80102260 <iunlockput>
    goto bad;
801059a0:	83 c4 10             	add    $0x10,%esp
801059a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059a7:	90                   	nop
  iunlockput(dp);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	56                   	push   %esi
801059ac:	e8 af c8 ff ff       	call   80102260 <iunlockput>
  end_op();
801059b1:	e8 4a dc ff ff       	call   80103600 <end_op>
  return -1;
801059b6:	83 c4 10             	add    $0x10,%esp
801059b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059be:	eb 92                	jmp    80105952 <sys_unlink+0x112>
    iupdate(dp);
801059c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059c3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801059c8:	56                   	push   %esi
801059c9:	e8 32 c5 ff ff       	call   80101f00 <iupdate>
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	e9 54 ff ff ff       	jmp    8010592a <sys_unlink+0xea>
801059d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801059e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e5:	e9 68 ff ff ff       	jmp    80105952 <sys_unlink+0x112>
    end_op();
801059ea:	e8 11 dc ff ff       	call   80103600 <end_op>
    return -1;
801059ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f4:	e9 59 ff ff ff       	jmp    80105952 <sys_unlink+0x112>
      panic("isdirempty: readi");
801059f9:	83 ec 0c             	sub    $0xc,%esp
801059fc:	68 d8 80 10 80       	push   $0x801080d8
80105a01:	e8 8a a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a06:	83 ec 0c             	sub    $0xc,%esp
80105a09:	68 ea 80 10 80       	push   $0x801080ea
80105a0e:	e8 7d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a13:	83 ec 0c             	sub    $0xc,%esp
80105a16:	68 c6 80 10 80       	push   $0x801080c6
80105a1b:	e8 70 a9 ff ff       	call   80100390 <panic>

80105a20 <sys_open>:

int
sys_open(void)
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	57                   	push   %edi
80105a28:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a29:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a2c:	53                   	push   %ebx
80105a2d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a30:	50                   	push   %eax
80105a31:	6a 00                	push   $0x0
80105a33:	e8 28 f8 ff ff       	call   80105260 <argstr>
80105a38:	83 c4 10             	add    $0x10,%esp
80105a3b:	85 c0                	test   %eax,%eax
80105a3d:	0f 88 8a 00 00 00    	js     80105acd <sys_open+0xad>
80105a43:	83 ec 08             	sub    $0x8,%esp
80105a46:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a49:	50                   	push   %eax
80105a4a:	6a 01                	push   $0x1
80105a4c:	e8 5f f7 ff ff       	call   801051b0 <argint>
80105a51:	83 c4 10             	add    $0x10,%esp
80105a54:	85 c0                	test   %eax,%eax
80105a56:	78 75                	js     80105acd <sys_open+0xad>
    return -1;

  begin_op();
80105a58:	e8 33 db ff ff       	call   80103590 <begin_op>

  if(omode & O_CREATE){
80105a5d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a61:	75 75                	jne    80105ad8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a63:	83 ec 0c             	sub    $0xc,%esp
80105a66:	ff 75 e0             	pushl  -0x20(%ebp)
80105a69:	e8 22 ce ff ff       	call   80102890 <namei>
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	89 c6                	mov    %eax,%esi
80105a73:	85 c0                	test   %eax,%eax
80105a75:	74 7e                	je     80105af5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a77:	83 ec 0c             	sub    $0xc,%esp
80105a7a:	50                   	push   %eax
80105a7b:	e8 40 c5 ff ff       	call   80101fc0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a80:	83 c4 10             	add    $0x10,%esp
80105a83:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a88:	0f 84 c2 00 00 00    	je     80105b50 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a8e:	e8 cd bb ff ff       	call   80101660 <filealloc>
80105a93:	89 c7                	mov    %eax,%edi
80105a95:	85 c0                	test   %eax,%eax
80105a97:	74 23                	je     80105abc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a99:	e8 22 e7 ff ff       	call   801041c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a9e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105aa0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105aa4:	85 d2                	test   %edx,%edx
80105aa6:	74 60                	je     80105b08 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105aa8:	83 c3 01             	add    $0x1,%ebx
80105aab:	83 fb 10             	cmp    $0x10,%ebx
80105aae:	75 f0                	jne    80105aa0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	57                   	push   %edi
80105ab4:	e8 67 bc ff ff       	call   80101720 <fileclose>
80105ab9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105abc:	83 ec 0c             	sub    $0xc,%esp
80105abf:	56                   	push   %esi
80105ac0:	e8 9b c7 ff ff       	call   80102260 <iunlockput>
    end_op();
80105ac5:	e8 36 db ff ff       	call   80103600 <end_op>
    return -1;
80105aca:	83 c4 10             	add    $0x10,%esp
80105acd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ad2:	eb 6d                	jmp    80105b41 <sys_open+0x121>
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ade:	31 c9                	xor    %ecx,%ecx
80105ae0:	ba 02 00 00 00       	mov    $0x2,%edx
80105ae5:	6a 00                	push   $0x0
80105ae7:	e8 24 f8 ff ff       	call   80105310 <create>
    if(ip == 0){
80105aec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105aef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105af1:	85 c0                	test   %eax,%eax
80105af3:	75 99                	jne    80105a8e <sys_open+0x6e>
      end_op();
80105af5:	e8 06 db ff ff       	call   80103600 <end_op>
      return -1;
80105afa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105aff:	eb 40                	jmp    80105b41 <sys_open+0x121>
80105b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b08:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b0b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b0f:	56                   	push   %esi
80105b10:	e8 8b c5 ff ff       	call   801020a0 <iunlock>
  end_op();
80105b15:	e8 e6 da ff ff       	call   80103600 <end_op>

  f->type = FD_INODE;
80105b1a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b23:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b26:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b29:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b2b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b32:	f7 d0                	not    %eax
80105b34:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b37:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b3a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b3d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b44:	89 d8                	mov    %ebx,%eax
80105b46:	5b                   	pop    %ebx
80105b47:	5e                   	pop    %esi
80105b48:	5f                   	pop    %edi
80105b49:	5d                   	pop    %ebp
80105b4a:	c3                   	ret    
80105b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b4f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b50:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b53:	85 c9                	test   %ecx,%ecx
80105b55:	0f 84 33 ff ff ff    	je     80105a8e <sys_open+0x6e>
80105b5b:	e9 5c ff ff ff       	jmp    80105abc <sys_open+0x9c>

80105b60 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b60:	f3 0f 1e fb          	endbr32 
80105b64:	55                   	push   %ebp
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b6a:	e8 21 da ff ff       	call   80103590 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b6f:	83 ec 08             	sub    $0x8,%esp
80105b72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b75:	50                   	push   %eax
80105b76:	6a 00                	push   $0x0
80105b78:	e8 e3 f6 ff ff       	call   80105260 <argstr>
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	85 c0                	test   %eax,%eax
80105b82:	78 34                	js     80105bb8 <sys_mkdir+0x58>
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8a:	31 c9                	xor    %ecx,%ecx
80105b8c:	ba 01 00 00 00       	mov    $0x1,%edx
80105b91:	6a 00                	push   $0x0
80105b93:	e8 78 f7 ff ff       	call   80105310 <create>
80105b98:	83 c4 10             	add    $0x10,%esp
80105b9b:	85 c0                	test   %eax,%eax
80105b9d:	74 19                	je     80105bb8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b9f:	83 ec 0c             	sub    $0xc,%esp
80105ba2:	50                   	push   %eax
80105ba3:	e8 b8 c6 ff ff       	call   80102260 <iunlockput>
  end_op();
80105ba8:	e8 53 da ff ff       	call   80103600 <end_op>
  return 0;
80105bad:	83 c4 10             	add    $0x10,%esp
80105bb0:	31 c0                	xor    %eax,%eax
}
80105bb2:	c9                   	leave  
80105bb3:	c3                   	ret    
80105bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105bb8:	e8 43 da ff ff       	call   80103600 <end_op>
    return -1;
80105bbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bc2:	c9                   	leave  
80105bc3:	c3                   	ret    
80105bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop

80105bd0 <sys_mknod>:

int
sys_mknod(void)
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bda:	e8 b1 d9 ff ff       	call   80103590 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105bdf:	83 ec 08             	sub    $0x8,%esp
80105be2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105be5:	50                   	push   %eax
80105be6:	6a 00                	push   $0x0
80105be8:	e8 73 f6 ff ff       	call   80105260 <argstr>
80105bed:	83 c4 10             	add    $0x10,%esp
80105bf0:	85 c0                	test   %eax,%eax
80105bf2:	78 64                	js     80105c58 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105bf4:	83 ec 08             	sub    $0x8,%esp
80105bf7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bfa:	50                   	push   %eax
80105bfb:	6a 01                	push   $0x1
80105bfd:	e8 ae f5 ff ff       	call   801051b0 <argint>
  if((argstr(0, &path)) < 0 ||
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	85 c0                	test   %eax,%eax
80105c07:	78 4f                	js     80105c58 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105c09:	83 ec 08             	sub    $0x8,%esp
80105c0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0f:	50                   	push   %eax
80105c10:	6a 02                	push   $0x2
80105c12:	e8 99 f5 ff ff       	call   801051b0 <argint>
     argint(1, &major) < 0 ||
80105c17:	83 c4 10             	add    $0x10,%esp
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	78 3a                	js     80105c58 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c1e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c22:	83 ec 0c             	sub    $0xc,%esp
80105c25:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c29:	ba 03 00 00 00       	mov    $0x3,%edx
80105c2e:	50                   	push   %eax
80105c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c32:	e8 d9 f6 ff ff       	call   80105310 <create>
     argint(2, &minor) < 0 ||
80105c37:	83 c4 10             	add    $0x10,%esp
80105c3a:	85 c0                	test   %eax,%eax
80105c3c:	74 1a                	je     80105c58 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c3e:	83 ec 0c             	sub    $0xc,%esp
80105c41:	50                   	push   %eax
80105c42:	e8 19 c6 ff ff       	call   80102260 <iunlockput>
  end_op();
80105c47:	e8 b4 d9 ff ff       	call   80103600 <end_op>
  return 0;
80105c4c:	83 c4 10             	add    $0x10,%esp
80105c4f:	31 c0                	xor    %eax,%eax
}
80105c51:	c9                   	leave  
80105c52:	c3                   	ret    
80105c53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c57:	90                   	nop
    end_op();
80105c58:	e8 a3 d9 ff ff       	call   80103600 <end_op>
    return -1;
80105c5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c62:	c9                   	leave  
80105c63:	c3                   	ret    
80105c64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c6f:	90                   	nop

80105c70 <sys_chdir>:

int
sys_chdir(void)
{
80105c70:	f3 0f 1e fb          	endbr32 
80105c74:	55                   	push   %ebp
80105c75:	89 e5                	mov    %esp,%ebp
80105c77:	56                   	push   %esi
80105c78:	53                   	push   %ebx
80105c79:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c7c:	e8 3f e5 ff ff       	call   801041c0 <myproc>
80105c81:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c83:	e8 08 d9 ff ff       	call   80103590 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c88:	83 ec 08             	sub    $0x8,%esp
80105c8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c8e:	50                   	push   %eax
80105c8f:	6a 00                	push   $0x0
80105c91:	e8 ca f5 ff ff       	call   80105260 <argstr>
80105c96:	83 c4 10             	add    $0x10,%esp
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	78 73                	js     80105d10 <sys_chdir+0xa0>
80105c9d:	83 ec 0c             	sub    $0xc,%esp
80105ca0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ca3:	e8 e8 cb ff ff       	call   80102890 <namei>
80105ca8:	83 c4 10             	add    $0x10,%esp
80105cab:	89 c3                	mov    %eax,%ebx
80105cad:	85 c0                	test   %eax,%eax
80105caf:	74 5f                	je     80105d10 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105cb1:	83 ec 0c             	sub    $0xc,%esp
80105cb4:	50                   	push   %eax
80105cb5:	e8 06 c3 ff ff       	call   80101fc0 <ilock>
  if(ip->type != T_DIR){
80105cba:	83 c4 10             	add    $0x10,%esp
80105cbd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cc2:	75 2c                	jne    80105cf0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105cc4:	83 ec 0c             	sub    $0xc,%esp
80105cc7:	53                   	push   %ebx
80105cc8:	e8 d3 c3 ff ff       	call   801020a0 <iunlock>
  iput(curproc->cwd);
80105ccd:	58                   	pop    %eax
80105cce:	ff 76 68             	pushl  0x68(%esi)
80105cd1:	e8 1a c4 ff ff       	call   801020f0 <iput>
  end_op();
80105cd6:	e8 25 d9 ff ff       	call   80103600 <end_op>
  curproc->cwd = ip;
80105cdb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cde:	83 c4 10             	add    $0x10,%esp
80105ce1:	31 c0                	xor    %eax,%eax
}
80105ce3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ce6:	5b                   	pop    %ebx
80105ce7:	5e                   	pop    %esi
80105ce8:	5d                   	pop    %ebp
80105ce9:	c3                   	ret    
80105cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	53                   	push   %ebx
80105cf4:	e8 67 c5 ff ff       	call   80102260 <iunlockput>
    end_op();
80105cf9:	e8 02 d9 ff ff       	call   80103600 <end_op>
    return -1;
80105cfe:	83 c4 10             	add    $0x10,%esp
80105d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d06:	eb db                	jmp    80105ce3 <sys_chdir+0x73>
80105d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop
    end_op();
80105d10:	e8 eb d8 ff ff       	call   80103600 <end_op>
    return -1;
80105d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d1a:	eb c7                	jmp    80105ce3 <sys_chdir+0x73>
80105d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d20 <sys_exec>:

int
sys_exec(void)
{
80105d20:	f3 0f 1e fb          	endbr32 
80105d24:	55                   	push   %ebp
80105d25:	89 e5                	mov    %esp,%ebp
80105d27:	57                   	push   %edi
80105d28:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d29:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d2f:	53                   	push   %ebx
80105d30:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d36:	50                   	push   %eax
80105d37:	6a 00                	push   $0x0
80105d39:	e8 22 f5 ff ff       	call   80105260 <argstr>
80105d3e:	83 c4 10             	add    $0x10,%esp
80105d41:	85 c0                	test   %eax,%eax
80105d43:	0f 88 8b 00 00 00    	js     80105dd4 <sys_exec+0xb4>
80105d49:	83 ec 08             	sub    $0x8,%esp
80105d4c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d52:	50                   	push   %eax
80105d53:	6a 01                	push   $0x1
80105d55:	e8 56 f4 ff ff       	call   801051b0 <argint>
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	85 c0                	test   %eax,%eax
80105d5f:	78 73                	js     80105dd4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d61:	83 ec 04             	sub    $0x4,%esp
80105d64:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105d6a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d6c:	68 80 00 00 00       	push   $0x80
80105d71:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d77:	6a 00                	push   $0x0
80105d79:	50                   	push   %eax
80105d7a:	e8 51 f1 ff ff       	call   80104ed0 <memset>
80105d7f:	83 c4 10             	add    $0x10,%esp
80105d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d88:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d8e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d95:	83 ec 08             	sub    $0x8,%esp
80105d98:	57                   	push   %edi
80105d99:	01 f0                	add    %esi,%eax
80105d9b:	50                   	push   %eax
80105d9c:	e8 6f f3 ff ff       	call   80105110 <fetchint>
80105da1:	83 c4 10             	add    $0x10,%esp
80105da4:	85 c0                	test   %eax,%eax
80105da6:	78 2c                	js     80105dd4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105da8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105dae:	85 c0                	test   %eax,%eax
80105db0:	74 36                	je     80105de8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105db2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105db8:	83 ec 08             	sub    $0x8,%esp
80105dbb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105dbe:	52                   	push   %edx
80105dbf:	50                   	push   %eax
80105dc0:	e8 8b f3 ff ff       	call   80105150 <fetchstr>
80105dc5:	83 c4 10             	add    $0x10,%esp
80105dc8:	85 c0                	test   %eax,%eax
80105dca:	78 08                	js     80105dd4 <sys_exec+0xb4>
  for(i=0;; i++){
80105dcc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105dcf:	83 fb 20             	cmp    $0x20,%ebx
80105dd2:	75 b4                	jne    80105d88 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ddc:	5b                   	pop    %ebx
80105ddd:	5e                   	pop    %esi
80105dde:	5f                   	pop    %edi
80105ddf:	5d                   	pop    %ebp
80105de0:	c3                   	ret    
80105de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105de8:	83 ec 08             	sub    $0x8,%esp
80105deb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105df1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105df8:	00 00 00 00 
  return exec(path, argv);
80105dfc:	50                   	push   %eax
80105dfd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e03:	e8 d8 b4 ff ff       	call   801012e0 <exec>
80105e08:	83 c4 10             	add    $0x10,%esp
}
80105e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e0e:	5b                   	pop    %ebx
80105e0f:	5e                   	pop    %esi
80105e10:	5f                   	pop    %edi
80105e11:	5d                   	pop    %ebp
80105e12:	c3                   	ret    
80105e13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e20 <sys_pipe>:

int
sys_pipe(void)
{
80105e20:	f3 0f 1e fb          	endbr32 
80105e24:	55                   	push   %ebp
80105e25:	89 e5                	mov    %esp,%ebp
80105e27:	57                   	push   %edi
80105e28:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e29:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e2c:	53                   	push   %ebx
80105e2d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e30:	6a 08                	push   $0x8
80105e32:	50                   	push   %eax
80105e33:	6a 00                	push   $0x0
80105e35:	e8 c6 f3 ff ff       	call   80105200 <argptr>
80105e3a:	83 c4 10             	add    $0x10,%esp
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	78 4e                	js     80105e8f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e41:	83 ec 08             	sub    $0x8,%esp
80105e44:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e47:	50                   	push   %eax
80105e48:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e4b:	50                   	push   %eax
80105e4c:	e8 ff dd ff ff       	call   80103c50 <pipealloc>
80105e51:	83 c4 10             	add    $0x10,%esp
80105e54:	85 c0                	test   %eax,%eax
80105e56:	78 37                	js     80105e8f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e58:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e5b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e5d:	e8 5e e3 ff ff       	call   801041c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105e68:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e6c:	85 f6                	test   %esi,%esi
80105e6e:	74 30                	je     80105ea0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105e70:	83 c3 01             	add    $0x1,%ebx
80105e73:	83 fb 10             	cmp    $0x10,%ebx
80105e76:	75 f0                	jne    80105e68 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e78:	83 ec 0c             	sub    $0xc,%esp
80105e7b:	ff 75 e0             	pushl  -0x20(%ebp)
80105e7e:	e8 9d b8 ff ff       	call   80101720 <fileclose>
    fileclose(wf);
80105e83:	58                   	pop    %eax
80105e84:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e87:	e8 94 b8 ff ff       	call   80101720 <fileclose>
    return -1;
80105e8c:	83 c4 10             	add    $0x10,%esp
80105e8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e94:	eb 5b                	jmp    80105ef1 <sys_pipe+0xd1>
80105e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105ea0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ea3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ea7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105eaa:	e8 11 e3 ff ff       	call   801041c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105eaf:	31 d2                	xor    %edx,%edx
80105eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105eb8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ebc:	85 c9                	test   %ecx,%ecx
80105ebe:	74 20                	je     80105ee0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105ec0:	83 c2 01             	add    $0x1,%edx
80105ec3:	83 fa 10             	cmp    $0x10,%edx
80105ec6:	75 f0                	jne    80105eb8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105ec8:	e8 f3 e2 ff ff       	call   801041c0 <myproc>
80105ecd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ed4:	00 
80105ed5:	eb a1                	jmp    80105e78 <sys_pipe+0x58>
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ee0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105ee4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ee7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ee9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105eec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105eef:	31 c0                	xor    %eax,%eax
}
80105ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ef4:	5b                   	pop    %ebx
80105ef5:	5e                   	pop    %esi
80105ef6:	5f                   	pop    %edi
80105ef7:	5d                   	pop    %ebp
80105ef8:	c3                   	ret    
80105ef9:	66 90                	xchg   %ax,%ax
80105efb:	66 90                	xchg   %ax,%ax
80105efd:	66 90                	xchg   %ax,%ax
80105eff:	90                   	nop

80105f00 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f00:	f3 0f 1e fb          	endbr32 
  return fork();
80105f04:	e9 67 e4 ff ff       	jmp    80104370 <fork>
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f10 <sys_exit>:
}

int
sys_exit(void)
{
80105f10:	f3 0f 1e fb          	endbr32 
80105f14:	55                   	push   %ebp
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f1a:	e8 d1 e6 ff ff       	call   801045f0 <exit>
  return 0;  // not reached
}
80105f1f:	31 c0                	xor    %eax,%eax
80105f21:	c9                   	leave  
80105f22:	c3                   	ret    
80105f23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f30 <sys_wait>:

int
sys_wait(void)
{
80105f30:	f3 0f 1e fb          	endbr32 
  return wait();
80105f34:	e9 07 e9 ff ff       	jmp    80104840 <wait>
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f40 <sys_kill>:
}

int
sys_kill(void)
{
80105f40:	f3 0f 1e fb          	endbr32 
80105f44:	55                   	push   %ebp
80105f45:	89 e5                	mov    %esp,%ebp
80105f47:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f4d:	50                   	push   %eax
80105f4e:	6a 00                	push   $0x0
80105f50:	e8 5b f2 ff ff       	call   801051b0 <argint>
80105f55:	83 c4 10             	add    $0x10,%esp
80105f58:	85 c0                	test   %eax,%eax
80105f5a:	78 14                	js     80105f70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f5c:	83 ec 0c             	sub    $0xc,%esp
80105f5f:	ff 75 f4             	pushl  -0xc(%ebp)
80105f62:	e8 39 ea ff ff       	call   801049a0 <kill>
80105f67:	83 c4 10             	add    $0x10,%esp
}
80105f6a:	c9                   	leave  
80105f6b:	c3                   	ret    
80105f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f70:	c9                   	leave  
    return -1;
80105f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f76:	c3                   	ret    
80105f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7e:	66 90                	xchg   %ax,%ax

80105f80 <sys_getpid>:

int
sys_getpid(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f8a:	e8 31 e2 ff ff       	call   801041c0 <myproc>
80105f8f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f92:	c9                   	leave  
80105f93:	c3                   	ret    
80105f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f9f:	90                   	nop

80105fa0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105fa0:	f3 0f 1e fb          	endbr32 
80105fa4:	55                   	push   %ebp
80105fa5:	89 e5                	mov    %esp,%ebp
80105fa7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105fa8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fab:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fae:	50                   	push   %eax
80105faf:	6a 00                	push   $0x0
80105fb1:	e8 fa f1 ff ff       	call   801051b0 <argint>
80105fb6:	83 c4 10             	add    $0x10,%esp
80105fb9:	85 c0                	test   %eax,%eax
80105fbb:	78 23                	js     80105fe0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105fbd:	e8 fe e1 ff ff       	call   801041c0 <myproc>
  if(growproc(n) < 0)
80105fc2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105fc5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105fc7:	ff 75 f4             	pushl  -0xc(%ebp)
80105fca:	e8 21 e3 ff ff       	call   801042f0 <growproc>
80105fcf:	83 c4 10             	add    $0x10,%esp
80105fd2:	85 c0                	test   %eax,%eax
80105fd4:	78 0a                	js     80105fe0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105fd6:	89 d8                	mov    %ebx,%eax
80105fd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fdb:	c9                   	leave  
80105fdc:	c3                   	ret    
80105fdd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fe0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fe5:	eb ef                	jmp    80105fd6 <sys_sbrk+0x36>
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_sleep>:

int
sys_sleep(void)
{
80105ff0:	f3 0f 1e fb          	endbr32 
80105ff4:	55                   	push   %ebp
80105ff5:	89 e5                	mov    %esp,%ebp
80105ff7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ff8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ffb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105ffe:	50                   	push   %eax
80105fff:	6a 00                	push   $0x0
80106001:	e8 aa f1 ff ff       	call   801051b0 <argint>
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	85 c0                	test   %eax,%eax
8010600b:	0f 88 86 00 00 00    	js     80106097 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106011:	83 ec 0c             	sub    $0xc,%esp
80106014:	68 20 62 11 80       	push   $0x80116220
80106019:	e8 a2 ed ff ff       	call   80104dc0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010601e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106021:	8b 1d 60 6a 11 80    	mov    0x80116a60,%ebx
  while(ticks - ticks0 < n){
80106027:	83 c4 10             	add    $0x10,%esp
8010602a:	85 d2                	test   %edx,%edx
8010602c:	75 23                	jne    80106051 <sys_sleep+0x61>
8010602e:	eb 50                	jmp    80106080 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106030:	83 ec 08             	sub    $0x8,%esp
80106033:	68 20 62 11 80       	push   $0x80116220
80106038:	68 60 6a 11 80       	push   $0x80116a60
8010603d:	e8 3e e7 ff ff       	call   80104780 <sleep>
  while(ticks - ticks0 < n){
80106042:	a1 60 6a 11 80       	mov    0x80116a60,%eax
80106047:	83 c4 10             	add    $0x10,%esp
8010604a:	29 d8                	sub    %ebx,%eax
8010604c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010604f:	73 2f                	jae    80106080 <sys_sleep+0x90>
    if(myproc()->killed){
80106051:	e8 6a e1 ff ff       	call   801041c0 <myproc>
80106056:	8b 40 24             	mov    0x24(%eax),%eax
80106059:	85 c0                	test   %eax,%eax
8010605b:	74 d3                	je     80106030 <sys_sleep+0x40>
      release(&tickslock);
8010605d:	83 ec 0c             	sub    $0xc,%esp
80106060:	68 20 62 11 80       	push   $0x80116220
80106065:	e8 16 ee ff ff       	call   80104e80 <release>
  }
  release(&tickslock);
  return 0;
}
8010606a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010606d:	83 c4 10             	add    $0x10,%esp
80106070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106075:	c9                   	leave  
80106076:	c3                   	ret    
80106077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	68 20 62 11 80       	push   $0x80116220
80106088:	e8 f3 ed ff ff       	call   80104e80 <release>
  return 0;
8010608d:	83 c4 10             	add    $0x10,%esp
80106090:	31 c0                	xor    %eax,%eax
}
80106092:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106095:	c9                   	leave  
80106096:	c3                   	ret    
    return -1;
80106097:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609c:	eb f4                	jmp    80106092 <sys_sleep+0xa2>
8010609e:	66 90                	xchg   %ax,%ax

801060a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060a0:	f3 0f 1e fb          	endbr32 
801060a4:	55                   	push   %ebp
801060a5:	89 e5                	mov    %esp,%ebp
801060a7:	53                   	push   %ebx
801060a8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060ab:	68 20 62 11 80       	push   $0x80116220
801060b0:	e8 0b ed ff ff       	call   80104dc0 <acquire>
  xticks = ticks;
801060b5:	8b 1d 60 6a 11 80    	mov    0x80116a60,%ebx
  release(&tickslock);
801060bb:	c7 04 24 20 62 11 80 	movl   $0x80116220,(%esp)
801060c2:	e8 b9 ed ff ff       	call   80104e80 <release>
  return xticks;
}
801060c7:	89 d8                	mov    %ebx,%eax
801060c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060cc:	c9                   	leave  
801060cd:	c3                   	ret    

801060ce <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801060ce:	1e                   	push   %ds
  pushl %es
801060cf:	06                   	push   %es
  pushl %fs
801060d0:	0f a0                	push   %fs
  pushl %gs
801060d2:	0f a8                	push   %gs
  pushal
801060d4:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801060d5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801060d9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801060db:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801060dd:	54                   	push   %esp
  call trap
801060de:	e8 cd 00 00 00       	call   801061b0 <trap>
  addl $4, %esp
801060e3:	83 c4 04             	add    $0x4,%esp

801060e6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801060e6:	61                   	popa   
  popl %gs
801060e7:	0f a9                	pop    %gs
  popl %fs
801060e9:	0f a1                	pop    %fs
  popl %es
801060eb:	07                   	pop    %es
  popl %ds
801060ec:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801060ed:	83 c4 08             	add    $0x8,%esp
  iret
801060f0:	cf                   	iret   
801060f1:	66 90                	xchg   %ax,%ax
801060f3:	66 90                	xchg   %ax,%ax
801060f5:	66 90                	xchg   %ax,%ax
801060f7:	66 90                	xchg   %ax,%ax
801060f9:	66 90                	xchg   %ax,%ax
801060fb:	66 90                	xchg   %ax,%ax
801060fd:	66 90                	xchg   %ax,%ax
801060ff:	90                   	nop

80106100 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106100:	f3 0f 1e fb          	endbr32 
80106104:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106105:	31 c0                	xor    %eax,%eax
{
80106107:	89 e5                	mov    %esp,%ebp
80106109:	83 ec 08             	sub    $0x8,%esp
8010610c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106110:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106117:	c7 04 c5 62 62 11 80 	movl   $0x8e000008,-0x7fee9d9e(,%eax,8)
8010611e:	08 00 00 8e 
80106122:	66 89 14 c5 60 62 11 	mov    %dx,-0x7fee9da0(,%eax,8)
80106129:	80 
8010612a:	c1 ea 10             	shr    $0x10,%edx
8010612d:	66 89 14 c5 66 62 11 	mov    %dx,-0x7fee9d9a(,%eax,8)
80106134:	80 
  for(i = 0; i < 256; i++)
80106135:	83 c0 01             	add    $0x1,%eax
80106138:	3d 00 01 00 00       	cmp    $0x100,%eax
8010613d:	75 d1                	jne    80106110 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010613f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106142:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106147:	c7 05 62 64 11 80 08 	movl   $0xef000008,0x80116462
8010614e:	00 00 ef 
  initlock(&tickslock, "time");
80106151:	68 f9 80 10 80       	push   $0x801080f9
80106156:	68 20 62 11 80       	push   $0x80116220
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010615b:	66 a3 60 64 11 80    	mov    %ax,0x80116460
80106161:	c1 e8 10             	shr    $0x10,%eax
80106164:	66 a3 66 64 11 80    	mov    %ax,0x80116466
  initlock(&tickslock, "time");
8010616a:	e8 d1 ea ff ff       	call   80104c40 <initlock>
}
8010616f:	83 c4 10             	add    $0x10,%esp
80106172:	c9                   	leave  
80106173:	c3                   	ret    
80106174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010617f:	90                   	nop

80106180 <idtinit>:

void
idtinit(void)
{
80106180:	f3 0f 1e fb          	endbr32 
80106184:	55                   	push   %ebp
  pd[0] = size-1;
80106185:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010618a:	89 e5                	mov    %esp,%ebp
8010618c:	83 ec 10             	sub    $0x10,%esp
8010618f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106193:	b8 60 62 11 80       	mov    $0x80116260,%eax
80106198:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010619c:	c1 e8 10             	shr    $0x10,%eax
8010619f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061a3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061a6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061a9:	c9                   	leave  
801061aa:	c3                   	ret    
801061ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061af:	90                   	nop

801061b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061b0:	f3 0f 1e fb          	endbr32 
801061b4:	55                   	push   %ebp
801061b5:	89 e5                	mov    %esp,%ebp
801061b7:	57                   	push   %edi
801061b8:	56                   	push   %esi
801061b9:	53                   	push   %ebx
801061ba:	83 ec 1c             	sub    $0x1c,%esp
801061bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801061c0:	8b 43 30             	mov    0x30(%ebx),%eax
801061c3:	83 f8 40             	cmp    $0x40,%eax
801061c6:	0f 84 bc 01 00 00    	je     80106388 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801061cc:	83 e8 20             	sub    $0x20,%eax
801061cf:	83 f8 1f             	cmp    $0x1f,%eax
801061d2:	77 08                	ja     801061dc <trap+0x2c>
801061d4:	3e ff 24 85 a0 81 10 	notrack jmp *-0x7fef7e60(,%eax,4)
801061db:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801061dc:	e8 df df ff ff       	call   801041c0 <myproc>
801061e1:	8b 7b 38             	mov    0x38(%ebx),%edi
801061e4:	85 c0                	test   %eax,%eax
801061e6:	0f 84 eb 01 00 00    	je     801063d7 <trap+0x227>
801061ec:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801061f0:	0f 84 e1 01 00 00    	je     801063d7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801061f6:	0f 20 d1             	mov    %cr2,%ecx
801061f9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061fc:	e8 9f df ff ff       	call   801041a0 <cpuid>
80106201:	8b 73 30             	mov    0x30(%ebx),%esi
80106204:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106207:	8b 43 34             	mov    0x34(%ebx),%eax
8010620a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010620d:	e8 ae df ff ff       	call   801041c0 <myproc>
80106212:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106215:	e8 a6 df ff ff       	call   801041c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010621a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010621d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106220:	51                   	push   %ecx
80106221:	57                   	push   %edi
80106222:	52                   	push   %edx
80106223:	ff 75 e4             	pushl  -0x1c(%ebp)
80106226:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106227:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010622a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010622d:	56                   	push   %esi
8010622e:	ff 70 10             	pushl  0x10(%eax)
80106231:	68 5c 81 10 80       	push   $0x8010815c
80106236:	e8 15 a7 ff ff       	call   80100950 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010623b:	83 c4 20             	add    $0x20,%esp
8010623e:	e8 7d df ff ff       	call   801041c0 <myproc>
80106243:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010624a:	e8 71 df ff ff       	call   801041c0 <myproc>
8010624f:	85 c0                	test   %eax,%eax
80106251:	74 1d                	je     80106270 <trap+0xc0>
80106253:	e8 68 df ff ff       	call   801041c0 <myproc>
80106258:	8b 50 24             	mov    0x24(%eax),%edx
8010625b:	85 d2                	test   %edx,%edx
8010625d:	74 11                	je     80106270 <trap+0xc0>
8010625f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106263:	83 e0 03             	and    $0x3,%eax
80106266:	66 83 f8 03          	cmp    $0x3,%ax
8010626a:	0f 84 50 01 00 00    	je     801063c0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106270:	e8 4b df ff ff       	call   801041c0 <myproc>
80106275:	85 c0                	test   %eax,%eax
80106277:	74 0f                	je     80106288 <trap+0xd8>
80106279:	e8 42 df ff ff       	call   801041c0 <myproc>
8010627e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106282:	0f 84 e8 00 00 00    	je     80106370 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106288:	e8 33 df ff ff       	call   801041c0 <myproc>
8010628d:	85 c0                	test   %eax,%eax
8010628f:	74 1d                	je     801062ae <trap+0xfe>
80106291:	e8 2a df ff ff       	call   801041c0 <myproc>
80106296:	8b 40 24             	mov    0x24(%eax),%eax
80106299:	85 c0                	test   %eax,%eax
8010629b:	74 11                	je     801062ae <trap+0xfe>
8010629d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062a1:	83 e0 03             	and    $0x3,%eax
801062a4:	66 83 f8 03          	cmp    $0x3,%ax
801062a8:	0f 84 03 01 00 00    	je     801063b1 <trap+0x201>
    exit();
}
801062ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062b1:	5b                   	pop    %ebx
801062b2:	5e                   	pop    %esi
801062b3:	5f                   	pop    %edi
801062b4:	5d                   	pop    %ebp
801062b5:	c3                   	ret    
    ideintr();
801062b6:	e8 85 c7 ff ff       	call   80102a40 <ideintr>
    lapiceoi();
801062bb:	e8 60 ce ff ff       	call   80103120 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062c0:	e8 fb de ff ff       	call   801041c0 <myproc>
801062c5:	85 c0                	test   %eax,%eax
801062c7:	75 8a                	jne    80106253 <trap+0xa3>
801062c9:	eb a5                	jmp    80106270 <trap+0xc0>
    if(cpuid() == 0){
801062cb:	e8 d0 de ff ff       	call   801041a0 <cpuid>
801062d0:	85 c0                	test   %eax,%eax
801062d2:	75 e7                	jne    801062bb <trap+0x10b>
      acquire(&tickslock);
801062d4:	83 ec 0c             	sub    $0xc,%esp
801062d7:	68 20 62 11 80       	push   $0x80116220
801062dc:	e8 df ea ff ff       	call   80104dc0 <acquire>
      wakeup(&ticks);
801062e1:	c7 04 24 60 6a 11 80 	movl   $0x80116a60,(%esp)
      ticks++;
801062e8:	83 05 60 6a 11 80 01 	addl   $0x1,0x80116a60
      wakeup(&ticks);
801062ef:	e8 4c e6 ff ff       	call   80104940 <wakeup>
      release(&tickslock);
801062f4:	c7 04 24 20 62 11 80 	movl   $0x80116220,(%esp)
801062fb:	e8 80 eb ff ff       	call   80104e80 <release>
80106300:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106303:	eb b6                	jmp    801062bb <trap+0x10b>
    kbdintr();
80106305:	e8 d6 cc ff ff       	call   80102fe0 <kbdintr>
    lapiceoi();
8010630a:	e8 11 ce ff ff       	call   80103120 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010630f:	e8 ac de ff ff       	call   801041c0 <myproc>
80106314:	85 c0                	test   %eax,%eax
80106316:	0f 85 37 ff ff ff    	jne    80106253 <trap+0xa3>
8010631c:	e9 4f ff ff ff       	jmp    80106270 <trap+0xc0>
    uartintr();
80106321:	e8 4a 02 00 00       	call   80106570 <uartintr>
    lapiceoi();
80106326:	e8 f5 cd ff ff       	call   80103120 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010632b:	e8 90 de ff ff       	call   801041c0 <myproc>
80106330:	85 c0                	test   %eax,%eax
80106332:	0f 85 1b ff ff ff    	jne    80106253 <trap+0xa3>
80106338:	e9 33 ff ff ff       	jmp    80106270 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010633d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106340:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106344:	e8 57 de ff ff       	call   801041a0 <cpuid>
80106349:	57                   	push   %edi
8010634a:	56                   	push   %esi
8010634b:	50                   	push   %eax
8010634c:	68 04 81 10 80       	push   $0x80108104
80106351:	e8 fa a5 ff ff       	call   80100950 <cprintf>
    lapiceoi();
80106356:	e8 c5 cd ff ff       	call   80103120 <lapiceoi>
    break;
8010635b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010635e:	e8 5d de ff ff       	call   801041c0 <myproc>
80106363:	85 c0                	test   %eax,%eax
80106365:	0f 85 e8 fe ff ff    	jne    80106253 <trap+0xa3>
8010636b:	e9 00 ff ff ff       	jmp    80106270 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106370:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106374:	0f 85 0e ff ff ff    	jne    80106288 <trap+0xd8>
    yield();
8010637a:	e8 b1 e3 ff ff       	call   80104730 <yield>
8010637f:	e9 04 ff ff ff       	jmp    80106288 <trap+0xd8>
80106384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106388:	e8 33 de ff ff       	call   801041c0 <myproc>
8010638d:	8b 70 24             	mov    0x24(%eax),%esi
80106390:	85 f6                	test   %esi,%esi
80106392:	75 3c                	jne    801063d0 <trap+0x220>
    myproc()->tf = tf;
80106394:	e8 27 de ff ff       	call   801041c0 <myproc>
80106399:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010639c:	e8 ff ee ff ff       	call   801052a0 <syscall>
    if(myproc()->killed)
801063a1:	e8 1a de ff ff       	call   801041c0 <myproc>
801063a6:	8b 48 24             	mov    0x24(%eax),%ecx
801063a9:	85 c9                	test   %ecx,%ecx
801063ab:	0f 84 fd fe ff ff    	je     801062ae <trap+0xfe>
}
801063b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063b4:	5b                   	pop    %ebx
801063b5:	5e                   	pop    %esi
801063b6:	5f                   	pop    %edi
801063b7:	5d                   	pop    %ebp
      exit();
801063b8:	e9 33 e2 ff ff       	jmp    801045f0 <exit>
801063bd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801063c0:	e8 2b e2 ff ff       	call   801045f0 <exit>
801063c5:	e9 a6 fe ff ff       	jmp    80106270 <trap+0xc0>
801063ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801063d0:	e8 1b e2 ff ff       	call   801045f0 <exit>
801063d5:	eb bd                	jmp    80106394 <trap+0x1e4>
801063d7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063da:	e8 c1 dd ff ff       	call   801041a0 <cpuid>
801063df:	83 ec 0c             	sub    $0xc,%esp
801063e2:	56                   	push   %esi
801063e3:	57                   	push   %edi
801063e4:	50                   	push   %eax
801063e5:	ff 73 30             	pushl  0x30(%ebx)
801063e8:	68 28 81 10 80       	push   $0x80108128
801063ed:	e8 5e a5 ff ff       	call   80100950 <cprintf>
      panic("trap");
801063f2:	83 c4 14             	add    $0x14,%esp
801063f5:	68 fe 80 10 80       	push   $0x801080fe
801063fa:	e8 91 9f ff ff       	call   80100390 <panic>
801063ff:	90                   	nop

80106400 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106400:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106404:	a1 dc b5 10 80       	mov    0x8010b5dc,%eax
80106409:	85 c0                	test   %eax,%eax
8010640b:	74 1b                	je     80106428 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010640d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106412:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106413:	a8 01                	test   $0x1,%al
80106415:	74 11                	je     80106428 <uartgetc+0x28>
80106417:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010641c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010641d:	0f b6 c0             	movzbl %al,%eax
80106420:	c3                   	ret    
80106421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010642d:	c3                   	ret    
8010642e:	66 90                	xchg   %ax,%ax

80106430 <uartputc.part.0>:
uartputc(int c)
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	57                   	push   %edi
80106434:	89 c7                	mov    %eax,%edi
80106436:	56                   	push   %esi
80106437:	be fd 03 00 00       	mov    $0x3fd,%esi
8010643c:	53                   	push   %ebx
8010643d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106442:	83 ec 0c             	sub    $0xc,%esp
80106445:	eb 1b                	jmp    80106462 <uartputc.part.0+0x32>
80106447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010644e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106450:	83 ec 0c             	sub    $0xc,%esp
80106453:	6a 0a                	push   $0xa
80106455:	e8 e6 cc ff ff       	call   80103140 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010645a:	83 c4 10             	add    $0x10,%esp
8010645d:	83 eb 01             	sub    $0x1,%ebx
80106460:	74 07                	je     80106469 <uartputc.part.0+0x39>
80106462:	89 f2                	mov    %esi,%edx
80106464:	ec                   	in     (%dx),%al
80106465:	a8 20                	test   $0x20,%al
80106467:	74 e7                	je     80106450 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106469:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010646e:	89 f8                	mov    %edi,%eax
80106470:	ee                   	out    %al,(%dx)
}
80106471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106474:	5b                   	pop    %ebx
80106475:	5e                   	pop    %esi
80106476:	5f                   	pop    %edi
80106477:	5d                   	pop    %ebp
80106478:	c3                   	ret    
80106479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106480 <uartinit>:
{
80106480:	f3 0f 1e fb          	endbr32 
80106484:	55                   	push   %ebp
80106485:	31 c9                	xor    %ecx,%ecx
80106487:	89 c8                	mov    %ecx,%eax
80106489:	89 e5                	mov    %esp,%ebp
8010648b:	57                   	push   %edi
8010648c:	56                   	push   %esi
8010648d:	53                   	push   %ebx
8010648e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106493:	89 da                	mov    %ebx,%edx
80106495:	83 ec 0c             	sub    $0xc,%esp
80106498:	ee                   	out    %al,(%dx)
80106499:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010649e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064a3:	89 fa                	mov    %edi,%edx
801064a5:	ee                   	out    %al,(%dx)
801064a6:	b8 0c 00 00 00       	mov    $0xc,%eax
801064ab:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064b0:	ee                   	out    %al,(%dx)
801064b1:	be f9 03 00 00       	mov    $0x3f9,%esi
801064b6:	89 c8                	mov    %ecx,%eax
801064b8:	89 f2                	mov    %esi,%edx
801064ba:	ee                   	out    %al,(%dx)
801064bb:	b8 03 00 00 00       	mov    $0x3,%eax
801064c0:	89 fa                	mov    %edi,%edx
801064c2:	ee                   	out    %al,(%dx)
801064c3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064c8:	89 c8                	mov    %ecx,%eax
801064ca:	ee                   	out    %al,(%dx)
801064cb:	b8 01 00 00 00       	mov    $0x1,%eax
801064d0:	89 f2                	mov    %esi,%edx
801064d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064d3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064d8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064d9:	3c ff                	cmp    $0xff,%al
801064db:	74 52                	je     8010652f <uartinit+0xaf>
  uart = 1;
801064dd:	c7 05 dc b5 10 80 01 	movl   $0x1,0x8010b5dc
801064e4:	00 00 00 
801064e7:	89 da                	mov    %ebx,%edx
801064e9:	ec                   	in     (%dx),%al
801064ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064f0:	83 ec 08             	sub    $0x8,%esp
801064f3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801064f8:	bb 20 82 10 80       	mov    $0x80108220,%ebx
  ioapicenable(IRQ_COM1, 0);
801064fd:	6a 00                	push   $0x0
801064ff:	6a 04                	push   $0x4
80106501:	e8 8a c7 ff ff       	call   80102c90 <ioapicenable>
80106506:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106509:	b8 78 00 00 00       	mov    $0x78,%eax
8010650e:	eb 04                	jmp    80106514 <uartinit+0x94>
80106510:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106514:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
8010651a:	85 d2                	test   %edx,%edx
8010651c:	74 08                	je     80106526 <uartinit+0xa6>
    uartputc(*p);
8010651e:	0f be c0             	movsbl %al,%eax
80106521:	e8 0a ff ff ff       	call   80106430 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106526:	89 f0                	mov    %esi,%eax
80106528:	83 c3 01             	add    $0x1,%ebx
8010652b:	84 c0                	test   %al,%al
8010652d:	75 e1                	jne    80106510 <uartinit+0x90>
}
8010652f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106532:	5b                   	pop    %ebx
80106533:	5e                   	pop    %esi
80106534:	5f                   	pop    %edi
80106535:	5d                   	pop    %ebp
80106536:	c3                   	ret    
80106537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010653e:	66 90                	xchg   %ax,%ax

80106540 <uartputc>:
{
80106540:	f3 0f 1e fb          	endbr32 
80106544:	55                   	push   %ebp
  if(!uart)
80106545:	8b 15 dc b5 10 80    	mov    0x8010b5dc,%edx
{
8010654b:	89 e5                	mov    %esp,%ebp
8010654d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106550:	85 d2                	test   %edx,%edx
80106552:	74 0c                	je     80106560 <uartputc+0x20>
}
80106554:	5d                   	pop    %ebp
80106555:	e9 d6 fe ff ff       	jmp    80106430 <uartputc.part.0>
8010655a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106560:	5d                   	pop    %ebp
80106561:	c3                   	ret    
80106562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106570 <uartintr>:

void
uartintr(void)
{
80106570:	f3 0f 1e fb          	endbr32 
80106574:	55                   	push   %ebp
80106575:	89 e5                	mov    %esp,%ebp
80106577:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010657a:	68 00 64 10 80       	push   $0x80106400
8010657f:	e8 ec a7 ff ff       	call   80100d70 <consoleintr>
}
80106584:	83 c4 10             	add    $0x10,%esp
80106587:	c9                   	leave  
80106588:	c3                   	ret    

80106589 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $0
8010658b:	6a 00                	push   $0x0
  jmp alltraps
8010658d:	e9 3c fb ff ff       	jmp    801060ce <alltraps>

80106592 <vector1>:
.globl vector1
vector1:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $1
80106594:	6a 01                	push   $0x1
  jmp alltraps
80106596:	e9 33 fb ff ff       	jmp    801060ce <alltraps>

8010659b <vector2>:
.globl vector2
vector2:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $2
8010659d:	6a 02                	push   $0x2
  jmp alltraps
8010659f:	e9 2a fb ff ff       	jmp    801060ce <alltraps>

801065a4 <vector3>:
.globl vector3
vector3:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $3
801065a6:	6a 03                	push   $0x3
  jmp alltraps
801065a8:	e9 21 fb ff ff       	jmp    801060ce <alltraps>

801065ad <vector4>:
.globl vector4
vector4:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $4
801065af:	6a 04                	push   $0x4
  jmp alltraps
801065b1:	e9 18 fb ff ff       	jmp    801060ce <alltraps>

801065b6 <vector5>:
.globl vector5
vector5:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $5
801065b8:	6a 05                	push   $0x5
  jmp alltraps
801065ba:	e9 0f fb ff ff       	jmp    801060ce <alltraps>

801065bf <vector6>:
.globl vector6
vector6:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $6
801065c1:	6a 06                	push   $0x6
  jmp alltraps
801065c3:	e9 06 fb ff ff       	jmp    801060ce <alltraps>

801065c8 <vector7>:
.globl vector7
vector7:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $7
801065ca:	6a 07                	push   $0x7
  jmp alltraps
801065cc:	e9 fd fa ff ff       	jmp    801060ce <alltraps>

801065d1 <vector8>:
.globl vector8
vector8:
  pushl $8
801065d1:	6a 08                	push   $0x8
  jmp alltraps
801065d3:	e9 f6 fa ff ff       	jmp    801060ce <alltraps>

801065d8 <vector9>:
.globl vector9
vector9:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $9
801065da:	6a 09                	push   $0x9
  jmp alltraps
801065dc:	e9 ed fa ff ff       	jmp    801060ce <alltraps>

801065e1 <vector10>:
.globl vector10
vector10:
  pushl $10
801065e1:	6a 0a                	push   $0xa
  jmp alltraps
801065e3:	e9 e6 fa ff ff       	jmp    801060ce <alltraps>

801065e8 <vector11>:
.globl vector11
vector11:
  pushl $11
801065e8:	6a 0b                	push   $0xb
  jmp alltraps
801065ea:	e9 df fa ff ff       	jmp    801060ce <alltraps>

801065ef <vector12>:
.globl vector12
vector12:
  pushl $12
801065ef:	6a 0c                	push   $0xc
  jmp alltraps
801065f1:	e9 d8 fa ff ff       	jmp    801060ce <alltraps>

801065f6 <vector13>:
.globl vector13
vector13:
  pushl $13
801065f6:	6a 0d                	push   $0xd
  jmp alltraps
801065f8:	e9 d1 fa ff ff       	jmp    801060ce <alltraps>

801065fd <vector14>:
.globl vector14
vector14:
  pushl $14
801065fd:	6a 0e                	push   $0xe
  jmp alltraps
801065ff:	e9 ca fa ff ff       	jmp    801060ce <alltraps>

80106604 <vector15>:
.globl vector15
vector15:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $15
80106606:	6a 0f                	push   $0xf
  jmp alltraps
80106608:	e9 c1 fa ff ff       	jmp    801060ce <alltraps>

8010660d <vector16>:
.globl vector16
vector16:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $16
8010660f:	6a 10                	push   $0x10
  jmp alltraps
80106611:	e9 b8 fa ff ff       	jmp    801060ce <alltraps>

80106616 <vector17>:
.globl vector17
vector17:
  pushl $17
80106616:	6a 11                	push   $0x11
  jmp alltraps
80106618:	e9 b1 fa ff ff       	jmp    801060ce <alltraps>

8010661d <vector18>:
.globl vector18
vector18:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $18
8010661f:	6a 12                	push   $0x12
  jmp alltraps
80106621:	e9 a8 fa ff ff       	jmp    801060ce <alltraps>

80106626 <vector19>:
.globl vector19
vector19:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $19
80106628:	6a 13                	push   $0x13
  jmp alltraps
8010662a:	e9 9f fa ff ff       	jmp    801060ce <alltraps>

8010662f <vector20>:
.globl vector20
vector20:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $20
80106631:	6a 14                	push   $0x14
  jmp alltraps
80106633:	e9 96 fa ff ff       	jmp    801060ce <alltraps>

80106638 <vector21>:
.globl vector21
vector21:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $21
8010663a:	6a 15                	push   $0x15
  jmp alltraps
8010663c:	e9 8d fa ff ff       	jmp    801060ce <alltraps>

80106641 <vector22>:
.globl vector22
vector22:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $22
80106643:	6a 16                	push   $0x16
  jmp alltraps
80106645:	e9 84 fa ff ff       	jmp    801060ce <alltraps>

8010664a <vector23>:
.globl vector23
vector23:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $23
8010664c:	6a 17                	push   $0x17
  jmp alltraps
8010664e:	e9 7b fa ff ff       	jmp    801060ce <alltraps>

80106653 <vector24>:
.globl vector24
vector24:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $24
80106655:	6a 18                	push   $0x18
  jmp alltraps
80106657:	e9 72 fa ff ff       	jmp    801060ce <alltraps>

8010665c <vector25>:
.globl vector25
vector25:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $25
8010665e:	6a 19                	push   $0x19
  jmp alltraps
80106660:	e9 69 fa ff ff       	jmp    801060ce <alltraps>

80106665 <vector26>:
.globl vector26
vector26:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $26
80106667:	6a 1a                	push   $0x1a
  jmp alltraps
80106669:	e9 60 fa ff ff       	jmp    801060ce <alltraps>

8010666e <vector27>:
.globl vector27
vector27:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $27
80106670:	6a 1b                	push   $0x1b
  jmp alltraps
80106672:	e9 57 fa ff ff       	jmp    801060ce <alltraps>

80106677 <vector28>:
.globl vector28
vector28:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $28
80106679:	6a 1c                	push   $0x1c
  jmp alltraps
8010667b:	e9 4e fa ff ff       	jmp    801060ce <alltraps>

80106680 <vector29>:
.globl vector29
vector29:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $29
80106682:	6a 1d                	push   $0x1d
  jmp alltraps
80106684:	e9 45 fa ff ff       	jmp    801060ce <alltraps>

80106689 <vector30>:
.globl vector30
vector30:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $30
8010668b:	6a 1e                	push   $0x1e
  jmp alltraps
8010668d:	e9 3c fa ff ff       	jmp    801060ce <alltraps>

80106692 <vector31>:
.globl vector31
vector31:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $31
80106694:	6a 1f                	push   $0x1f
  jmp alltraps
80106696:	e9 33 fa ff ff       	jmp    801060ce <alltraps>

8010669b <vector32>:
.globl vector32
vector32:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $32
8010669d:	6a 20                	push   $0x20
  jmp alltraps
8010669f:	e9 2a fa ff ff       	jmp    801060ce <alltraps>

801066a4 <vector33>:
.globl vector33
vector33:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $33
801066a6:	6a 21                	push   $0x21
  jmp alltraps
801066a8:	e9 21 fa ff ff       	jmp    801060ce <alltraps>

801066ad <vector34>:
.globl vector34
vector34:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $34
801066af:	6a 22                	push   $0x22
  jmp alltraps
801066b1:	e9 18 fa ff ff       	jmp    801060ce <alltraps>

801066b6 <vector35>:
.globl vector35
vector35:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $35
801066b8:	6a 23                	push   $0x23
  jmp alltraps
801066ba:	e9 0f fa ff ff       	jmp    801060ce <alltraps>

801066bf <vector36>:
.globl vector36
vector36:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $36
801066c1:	6a 24                	push   $0x24
  jmp alltraps
801066c3:	e9 06 fa ff ff       	jmp    801060ce <alltraps>

801066c8 <vector37>:
.globl vector37
vector37:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $37
801066ca:	6a 25                	push   $0x25
  jmp alltraps
801066cc:	e9 fd f9 ff ff       	jmp    801060ce <alltraps>

801066d1 <vector38>:
.globl vector38
vector38:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $38
801066d3:	6a 26                	push   $0x26
  jmp alltraps
801066d5:	e9 f4 f9 ff ff       	jmp    801060ce <alltraps>

801066da <vector39>:
.globl vector39
vector39:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $39
801066dc:	6a 27                	push   $0x27
  jmp alltraps
801066de:	e9 eb f9 ff ff       	jmp    801060ce <alltraps>

801066e3 <vector40>:
.globl vector40
vector40:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $40
801066e5:	6a 28                	push   $0x28
  jmp alltraps
801066e7:	e9 e2 f9 ff ff       	jmp    801060ce <alltraps>

801066ec <vector41>:
.globl vector41
vector41:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $41
801066ee:	6a 29                	push   $0x29
  jmp alltraps
801066f0:	e9 d9 f9 ff ff       	jmp    801060ce <alltraps>

801066f5 <vector42>:
.globl vector42
vector42:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $42
801066f7:	6a 2a                	push   $0x2a
  jmp alltraps
801066f9:	e9 d0 f9 ff ff       	jmp    801060ce <alltraps>

801066fe <vector43>:
.globl vector43
vector43:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $43
80106700:	6a 2b                	push   $0x2b
  jmp alltraps
80106702:	e9 c7 f9 ff ff       	jmp    801060ce <alltraps>

80106707 <vector44>:
.globl vector44
vector44:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $44
80106709:	6a 2c                	push   $0x2c
  jmp alltraps
8010670b:	e9 be f9 ff ff       	jmp    801060ce <alltraps>

80106710 <vector45>:
.globl vector45
vector45:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $45
80106712:	6a 2d                	push   $0x2d
  jmp alltraps
80106714:	e9 b5 f9 ff ff       	jmp    801060ce <alltraps>

80106719 <vector46>:
.globl vector46
vector46:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $46
8010671b:	6a 2e                	push   $0x2e
  jmp alltraps
8010671d:	e9 ac f9 ff ff       	jmp    801060ce <alltraps>

80106722 <vector47>:
.globl vector47
vector47:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $47
80106724:	6a 2f                	push   $0x2f
  jmp alltraps
80106726:	e9 a3 f9 ff ff       	jmp    801060ce <alltraps>

8010672b <vector48>:
.globl vector48
vector48:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $48
8010672d:	6a 30                	push   $0x30
  jmp alltraps
8010672f:	e9 9a f9 ff ff       	jmp    801060ce <alltraps>

80106734 <vector49>:
.globl vector49
vector49:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $49
80106736:	6a 31                	push   $0x31
  jmp alltraps
80106738:	e9 91 f9 ff ff       	jmp    801060ce <alltraps>

8010673d <vector50>:
.globl vector50
vector50:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $50
8010673f:	6a 32                	push   $0x32
  jmp alltraps
80106741:	e9 88 f9 ff ff       	jmp    801060ce <alltraps>

80106746 <vector51>:
.globl vector51
vector51:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $51
80106748:	6a 33                	push   $0x33
  jmp alltraps
8010674a:	e9 7f f9 ff ff       	jmp    801060ce <alltraps>

8010674f <vector52>:
.globl vector52
vector52:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $52
80106751:	6a 34                	push   $0x34
  jmp alltraps
80106753:	e9 76 f9 ff ff       	jmp    801060ce <alltraps>

80106758 <vector53>:
.globl vector53
vector53:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $53
8010675a:	6a 35                	push   $0x35
  jmp alltraps
8010675c:	e9 6d f9 ff ff       	jmp    801060ce <alltraps>

80106761 <vector54>:
.globl vector54
vector54:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $54
80106763:	6a 36                	push   $0x36
  jmp alltraps
80106765:	e9 64 f9 ff ff       	jmp    801060ce <alltraps>

8010676a <vector55>:
.globl vector55
vector55:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $55
8010676c:	6a 37                	push   $0x37
  jmp alltraps
8010676e:	e9 5b f9 ff ff       	jmp    801060ce <alltraps>

80106773 <vector56>:
.globl vector56
vector56:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $56
80106775:	6a 38                	push   $0x38
  jmp alltraps
80106777:	e9 52 f9 ff ff       	jmp    801060ce <alltraps>

8010677c <vector57>:
.globl vector57
vector57:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $57
8010677e:	6a 39                	push   $0x39
  jmp alltraps
80106780:	e9 49 f9 ff ff       	jmp    801060ce <alltraps>

80106785 <vector58>:
.globl vector58
vector58:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $58
80106787:	6a 3a                	push   $0x3a
  jmp alltraps
80106789:	e9 40 f9 ff ff       	jmp    801060ce <alltraps>

8010678e <vector59>:
.globl vector59
vector59:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $59
80106790:	6a 3b                	push   $0x3b
  jmp alltraps
80106792:	e9 37 f9 ff ff       	jmp    801060ce <alltraps>

80106797 <vector60>:
.globl vector60
vector60:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $60
80106799:	6a 3c                	push   $0x3c
  jmp alltraps
8010679b:	e9 2e f9 ff ff       	jmp    801060ce <alltraps>

801067a0 <vector61>:
.globl vector61
vector61:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $61
801067a2:	6a 3d                	push   $0x3d
  jmp alltraps
801067a4:	e9 25 f9 ff ff       	jmp    801060ce <alltraps>

801067a9 <vector62>:
.globl vector62
vector62:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $62
801067ab:	6a 3e                	push   $0x3e
  jmp alltraps
801067ad:	e9 1c f9 ff ff       	jmp    801060ce <alltraps>

801067b2 <vector63>:
.globl vector63
vector63:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $63
801067b4:	6a 3f                	push   $0x3f
  jmp alltraps
801067b6:	e9 13 f9 ff ff       	jmp    801060ce <alltraps>

801067bb <vector64>:
.globl vector64
vector64:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $64
801067bd:	6a 40                	push   $0x40
  jmp alltraps
801067bf:	e9 0a f9 ff ff       	jmp    801060ce <alltraps>

801067c4 <vector65>:
.globl vector65
vector65:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $65
801067c6:	6a 41                	push   $0x41
  jmp alltraps
801067c8:	e9 01 f9 ff ff       	jmp    801060ce <alltraps>

801067cd <vector66>:
.globl vector66
vector66:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $66
801067cf:	6a 42                	push   $0x42
  jmp alltraps
801067d1:	e9 f8 f8 ff ff       	jmp    801060ce <alltraps>

801067d6 <vector67>:
.globl vector67
vector67:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $67
801067d8:	6a 43                	push   $0x43
  jmp alltraps
801067da:	e9 ef f8 ff ff       	jmp    801060ce <alltraps>

801067df <vector68>:
.globl vector68
vector68:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $68
801067e1:	6a 44                	push   $0x44
  jmp alltraps
801067e3:	e9 e6 f8 ff ff       	jmp    801060ce <alltraps>

801067e8 <vector69>:
.globl vector69
vector69:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $69
801067ea:	6a 45                	push   $0x45
  jmp alltraps
801067ec:	e9 dd f8 ff ff       	jmp    801060ce <alltraps>

801067f1 <vector70>:
.globl vector70
vector70:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $70
801067f3:	6a 46                	push   $0x46
  jmp alltraps
801067f5:	e9 d4 f8 ff ff       	jmp    801060ce <alltraps>

801067fa <vector71>:
.globl vector71
vector71:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $71
801067fc:	6a 47                	push   $0x47
  jmp alltraps
801067fe:	e9 cb f8 ff ff       	jmp    801060ce <alltraps>

80106803 <vector72>:
.globl vector72
vector72:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $72
80106805:	6a 48                	push   $0x48
  jmp alltraps
80106807:	e9 c2 f8 ff ff       	jmp    801060ce <alltraps>

8010680c <vector73>:
.globl vector73
vector73:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $73
8010680e:	6a 49                	push   $0x49
  jmp alltraps
80106810:	e9 b9 f8 ff ff       	jmp    801060ce <alltraps>

80106815 <vector74>:
.globl vector74
vector74:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $74
80106817:	6a 4a                	push   $0x4a
  jmp alltraps
80106819:	e9 b0 f8 ff ff       	jmp    801060ce <alltraps>

8010681e <vector75>:
.globl vector75
vector75:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $75
80106820:	6a 4b                	push   $0x4b
  jmp alltraps
80106822:	e9 a7 f8 ff ff       	jmp    801060ce <alltraps>

80106827 <vector76>:
.globl vector76
vector76:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $76
80106829:	6a 4c                	push   $0x4c
  jmp alltraps
8010682b:	e9 9e f8 ff ff       	jmp    801060ce <alltraps>

80106830 <vector77>:
.globl vector77
vector77:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $77
80106832:	6a 4d                	push   $0x4d
  jmp alltraps
80106834:	e9 95 f8 ff ff       	jmp    801060ce <alltraps>

80106839 <vector78>:
.globl vector78
vector78:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $78
8010683b:	6a 4e                	push   $0x4e
  jmp alltraps
8010683d:	e9 8c f8 ff ff       	jmp    801060ce <alltraps>

80106842 <vector79>:
.globl vector79
vector79:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $79
80106844:	6a 4f                	push   $0x4f
  jmp alltraps
80106846:	e9 83 f8 ff ff       	jmp    801060ce <alltraps>

8010684b <vector80>:
.globl vector80
vector80:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $80
8010684d:	6a 50                	push   $0x50
  jmp alltraps
8010684f:	e9 7a f8 ff ff       	jmp    801060ce <alltraps>

80106854 <vector81>:
.globl vector81
vector81:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $81
80106856:	6a 51                	push   $0x51
  jmp alltraps
80106858:	e9 71 f8 ff ff       	jmp    801060ce <alltraps>

8010685d <vector82>:
.globl vector82
vector82:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $82
8010685f:	6a 52                	push   $0x52
  jmp alltraps
80106861:	e9 68 f8 ff ff       	jmp    801060ce <alltraps>

80106866 <vector83>:
.globl vector83
vector83:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $83
80106868:	6a 53                	push   $0x53
  jmp alltraps
8010686a:	e9 5f f8 ff ff       	jmp    801060ce <alltraps>

8010686f <vector84>:
.globl vector84
vector84:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $84
80106871:	6a 54                	push   $0x54
  jmp alltraps
80106873:	e9 56 f8 ff ff       	jmp    801060ce <alltraps>

80106878 <vector85>:
.globl vector85
vector85:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $85
8010687a:	6a 55                	push   $0x55
  jmp alltraps
8010687c:	e9 4d f8 ff ff       	jmp    801060ce <alltraps>

80106881 <vector86>:
.globl vector86
vector86:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $86
80106883:	6a 56                	push   $0x56
  jmp alltraps
80106885:	e9 44 f8 ff ff       	jmp    801060ce <alltraps>

8010688a <vector87>:
.globl vector87
vector87:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $87
8010688c:	6a 57                	push   $0x57
  jmp alltraps
8010688e:	e9 3b f8 ff ff       	jmp    801060ce <alltraps>

80106893 <vector88>:
.globl vector88
vector88:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $88
80106895:	6a 58                	push   $0x58
  jmp alltraps
80106897:	e9 32 f8 ff ff       	jmp    801060ce <alltraps>

8010689c <vector89>:
.globl vector89
vector89:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $89
8010689e:	6a 59                	push   $0x59
  jmp alltraps
801068a0:	e9 29 f8 ff ff       	jmp    801060ce <alltraps>

801068a5 <vector90>:
.globl vector90
vector90:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $90
801068a7:	6a 5a                	push   $0x5a
  jmp alltraps
801068a9:	e9 20 f8 ff ff       	jmp    801060ce <alltraps>

801068ae <vector91>:
.globl vector91
vector91:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $91
801068b0:	6a 5b                	push   $0x5b
  jmp alltraps
801068b2:	e9 17 f8 ff ff       	jmp    801060ce <alltraps>

801068b7 <vector92>:
.globl vector92
vector92:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $92
801068b9:	6a 5c                	push   $0x5c
  jmp alltraps
801068bb:	e9 0e f8 ff ff       	jmp    801060ce <alltraps>

801068c0 <vector93>:
.globl vector93
vector93:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $93
801068c2:	6a 5d                	push   $0x5d
  jmp alltraps
801068c4:	e9 05 f8 ff ff       	jmp    801060ce <alltraps>

801068c9 <vector94>:
.globl vector94
vector94:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $94
801068cb:	6a 5e                	push   $0x5e
  jmp alltraps
801068cd:	e9 fc f7 ff ff       	jmp    801060ce <alltraps>

801068d2 <vector95>:
.globl vector95
vector95:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $95
801068d4:	6a 5f                	push   $0x5f
  jmp alltraps
801068d6:	e9 f3 f7 ff ff       	jmp    801060ce <alltraps>

801068db <vector96>:
.globl vector96
vector96:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $96
801068dd:	6a 60                	push   $0x60
  jmp alltraps
801068df:	e9 ea f7 ff ff       	jmp    801060ce <alltraps>

801068e4 <vector97>:
.globl vector97
vector97:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $97
801068e6:	6a 61                	push   $0x61
  jmp alltraps
801068e8:	e9 e1 f7 ff ff       	jmp    801060ce <alltraps>

801068ed <vector98>:
.globl vector98
vector98:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $98
801068ef:	6a 62                	push   $0x62
  jmp alltraps
801068f1:	e9 d8 f7 ff ff       	jmp    801060ce <alltraps>

801068f6 <vector99>:
.globl vector99
vector99:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $99
801068f8:	6a 63                	push   $0x63
  jmp alltraps
801068fa:	e9 cf f7 ff ff       	jmp    801060ce <alltraps>

801068ff <vector100>:
.globl vector100
vector100:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $100
80106901:	6a 64                	push   $0x64
  jmp alltraps
80106903:	e9 c6 f7 ff ff       	jmp    801060ce <alltraps>

80106908 <vector101>:
.globl vector101
vector101:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $101
8010690a:	6a 65                	push   $0x65
  jmp alltraps
8010690c:	e9 bd f7 ff ff       	jmp    801060ce <alltraps>

80106911 <vector102>:
.globl vector102
vector102:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $102
80106913:	6a 66                	push   $0x66
  jmp alltraps
80106915:	e9 b4 f7 ff ff       	jmp    801060ce <alltraps>

8010691a <vector103>:
.globl vector103
vector103:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $103
8010691c:	6a 67                	push   $0x67
  jmp alltraps
8010691e:	e9 ab f7 ff ff       	jmp    801060ce <alltraps>

80106923 <vector104>:
.globl vector104
vector104:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $104
80106925:	6a 68                	push   $0x68
  jmp alltraps
80106927:	e9 a2 f7 ff ff       	jmp    801060ce <alltraps>

8010692c <vector105>:
.globl vector105
vector105:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $105
8010692e:	6a 69                	push   $0x69
  jmp alltraps
80106930:	e9 99 f7 ff ff       	jmp    801060ce <alltraps>

80106935 <vector106>:
.globl vector106
vector106:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $106
80106937:	6a 6a                	push   $0x6a
  jmp alltraps
80106939:	e9 90 f7 ff ff       	jmp    801060ce <alltraps>

8010693e <vector107>:
.globl vector107
vector107:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $107
80106940:	6a 6b                	push   $0x6b
  jmp alltraps
80106942:	e9 87 f7 ff ff       	jmp    801060ce <alltraps>

80106947 <vector108>:
.globl vector108
vector108:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $108
80106949:	6a 6c                	push   $0x6c
  jmp alltraps
8010694b:	e9 7e f7 ff ff       	jmp    801060ce <alltraps>

80106950 <vector109>:
.globl vector109
vector109:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $109
80106952:	6a 6d                	push   $0x6d
  jmp alltraps
80106954:	e9 75 f7 ff ff       	jmp    801060ce <alltraps>

80106959 <vector110>:
.globl vector110
vector110:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $110
8010695b:	6a 6e                	push   $0x6e
  jmp alltraps
8010695d:	e9 6c f7 ff ff       	jmp    801060ce <alltraps>

80106962 <vector111>:
.globl vector111
vector111:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $111
80106964:	6a 6f                	push   $0x6f
  jmp alltraps
80106966:	e9 63 f7 ff ff       	jmp    801060ce <alltraps>

8010696b <vector112>:
.globl vector112
vector112:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $112
8010696d:	6a 70                	push   $0x70
  jmp alltraps
8010696f:	e9 5a f7 ff ff       	jmp    801060ce <alltraps>

80106974 <vector113>:
.globl vector113
vector113:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $113
80106976:	6a 71                	push   $0x71
  jmp alltraps
80106978:	e9 51 f7 ff ff       	jmp    801060ce <alltraps>

8010697d <vector114>:
.globl vector114
vector114:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $114
8010697f:	6a 72                	push   $0x72
  jmp alltraps
80106981:	e9 48 f7 ff ff       	jmp    801060ce <alltraps>

80106986 <vector115>:
.globl vector115
vector115:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $115
80106988:	6a 73                	push   $0x73
  jmp alltraps
8010698a:	e9 3f f7 ff ff       	jmp    801060ce <alltraps>

8010698f <vector116>:
.globl vector116
vector116:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $116
80106991:	6a 74                	push   $0x74
  jmp alltraps
80106993:	e9 36 f7 ff ff       	jmp    801060ce <alltraps>

80106998 <vector117>:
.globl vector117
vector117:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $117
8010699a:	6a 75                	push   $0x75
  jmp alltraps
8010699c:	e9 2d f7 ff ff       	jmp    801060ce <alltraps>

801069a1 <vector118>:
.globl vector118
vector118:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $118
801069a3:	6a 76                	push   $0x76
  jmp alltraps
801069a5:	e9 24 f7 ff ff       	jmp    801060ce <alltraps>

801069aa <vector119>:
.globl vector119
vector119:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $119
801069ac:	6a 77                	push   $0x77
  jmp alltraps
801069ae:	e9 1b f7 ff ff       	jmp    801060ce <alltraps>

801069b3 <vector120>:
.globl vector120
vector120:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $120
801069b5:	6a 78                	push   $0x78
  jmp alltraps
801069b7:	e9 12 f7 ff ff       	jmp    801060ce <alltraps>

801069bc <vector121>:
.globl vector121
vector121:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $121
801069be:	6a 79                	push   $0x79
  jmp alltraps
801069c0:	e9 09 f7 ff ff       	jmp    801060ce <alltraps>

801069c5 <vector122>:
.globl vector122
vector122:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $122
801069c7:	6a 7a                	push   $0x7a
  jmp alltraps
801069c9:	e9 00 f7 ff ff       	jmp    801060ce <alltraps>

801069ce <vector123>:
.globl vector123
vector123:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $123
801069d0:	6a 7b                	push   $0x7b
  jmp alltraps
801069d2:	e9 f7 f6 ff ff       	jmp    801060ce <alltraps>

801069d7 <vector124>:
.globl vector124
vector124:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $124
801069d9:	6a 7c                	push   $0x7c
  jmp alltraps
801069db:	e9 ee f6 ff ff       	jmp    801060ce <alltraps>

801069e0 <vector125>:
.globl vector125
vector125:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $125
801069e2:	6a 7d                	push   $0x7d
  jmp alltraps
801069e4:	e9 e5 f6 ff ff       	jmp    801060ce <alltraps>

801069e9 <vector126>:
.globl vector126
vector126:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $126
801069eb:	6a 7e                	push   $0x7e
  jmp alltraps
801069ed:	e9 dc f6 ff ff       	jmp    801060ce <alltraps>

801069f2 <vector127>:
.globl vector127
vector127:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $127
801069f4:	6a 7f                	push   $0x7f
  jmp alltraps
801069f6:	e9 d3 f6 ff ff       	jmp    801060ce <alltraps>

801069fb <vector128>:
.globl vector128
vector128:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $128
801069fd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a02:	e9 c7 f6 ff ff       	jmp    801060ce <alltraps>

80106a07 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $129
80106a09:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a0e:	e9 bb f6 ff ff       	jmp    801060ce <alltraps>

80106a13 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $130
80106a15:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a1a:	e9 af f6 ff ff       	jmp    801060ce <alltraps>

80106a1f <vector131>:
.globl vector131
vector131:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $131
80106a21:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a26:	e9 a3 f6 ff ff       	jmp    801060ce <alltraps>

80106a2b <vector132>:
.globl vector132
vector132:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $132
80106a2d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a32:	e9 97 f6 ff ff       	jmp    801060ce <alltraps>

80106a37 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $133
80106a39:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a3e:	e9 8b f6 ff ff       	jmp    801060ce <alltraps>

80106a43 <vector134>:
.globl vector134
vector134:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $134
80106a45:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a4a:	e9 7f f6 ff ff       	jmp    801060ce <alltraps>

80106a4f <vector135>:
.globl vector135
vector135:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $135
80106a51:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a56:	e9 73 f6 ff ff       	jmp    801060ce <alltraps>

80106a5b <vector136>:
.globl vector136
vector136:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $136
80106a5d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a62:	e9 67 f6 ff ff       	jmp    801060ce <alltraps>

80106a67 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $137
80106a69:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a6e:	e9 5b f6 ff ff       	jmp    801060ce <alltraps>

80106a73 <vector138>:
.globl vector138
vector138:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $138
80106a75:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a7a:	e9 4f f6 ff ff       	jmp    801060ce <alltraps>

80106a7f <vector139>:
.globl vector139
vector139:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $139
80106a81:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a86:	e9 43 f6 ff ff       	jmp    801060ce <alltraps>

80106a8b <vector140>:
.globl vector140
vector140:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $140
80106a8d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a92:	e9 37 f6 ff ff       	jmp    801060ce <alltraps>

80106a97 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $141
80106a99:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a9e:	e9 2b f6 ff ff       	jmp    801060ce <alltraps>

80106aa3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $142
80106aa5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106aaa:	e9 1f f6 ff ff       	jmp    801060ce <alltraps>

80106aaf <vector143>:
.globl vector143
vector143:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $143
80106ab1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ab6:	e9 13 f6 ff ff       	jmp    801060ce <alltraps>

80106abb <vector144>:
.globl vector144
vector144:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $144
80106abd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ac2:	e9 07 f6 ff ff       	jmp    801060ce <alltraps>

80106ac7 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $145
80106ac9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106ace:	e9 fb f5 ff ff       	jmp    801060ce <alltraps>

80106ad3 <vector146>:
.globl vector146
vector146:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $146
80106ad5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ada:	e9 ef f5 ff ff       	jmp    801060ce <alltraps>

80106adf <vector147>:
.globl vector147
vector147:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $147
80106ae1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ae6:	e9 e3 f5 ff ff       	jmp    801060ce <alltraps>

80106aeb <vector148>:
.globl vector148
vector148:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $148
80106aed:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106af2:	e9 d7 f5 ff ff       	jmp    801060ce <alltraps>

80106af7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $149
80106af9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106afe:	e9 cb f5 ff ff       	jmp    801060ce <alltraps>

80106b03 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $150
80106b05:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b0a:	e9 bf f5 ff ff       	jmp    801060ce <alltraps>

80106b0f <vector151>:
.globl vector151
vector151:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $151
80106b11:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b16:	e9 b3 f5 ff ff       	jmp    801060ce <alltraps>

80106b1b <vector152>:
.globl vector152
vector152:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $152
80106b1d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b22:	e9 a7 f5 ff ff       	jmp    801060ce <alltraps>

80106b27 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $153
80106b29:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b2e:	e9 9b f5 ff ff       	jmp    801060ce <alltraps>

80106b33 <vector154>:
.globl vector154
vector154:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $154
80106b35:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b3a:	e9 8f f5 ff ff       	jmp    801060ce <alltraps>

80106b3f <vector155>:
.globl vector155
vector155:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $155
80106b41:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b46:	e9 83 f5 ff ff       	jmp    801060ce <alltraps>

80106b4b <vector156>:
.globl vector156
vector156:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $156
80106b4d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b52:	e9 77 f5 ff ff       	jmp    801060ce <alltraps>

80106b57 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $157
80106b59:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b5e:	e9 6b f5 ff ff       	jmp    801060ce <alltraps>

80106b63 <vector158>:
.globl vector158
vector158:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $158
80106b65:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b6a:	e9 5f f5 ff ff       	jmp    801060ce <alltraps>

80106b6f <vector159>:
.globl vector159
vector159:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $159
80106b71:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b76:	e9 53 f5 ff ff       	jmp    801060ce <alltraps>

80106b7b <vector160>:
.globl vector160
vector160:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $160
80106b7d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b82:	e9 47 f5 ff ff       	jmp    801060ce <alltraps>

80106b87 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $161
80106b89:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b8e:	e9 3b f5 ff ff       	jmp    801060ce <alltraps>

80106b93 <vector162>:
.globl vector162
vector162:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $162
80106b95:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b9a:	e9 2f f5 ff ff       	jmp    801060ce <alltraps>

80106b9f <vector163>:
.globl vector163
vector163:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $163
80106ba1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ba6:	e9 23 f5 ff ff       	jmp    801060ce <alltraps>

80106bab <vector164>:
.globl vector164
vector164:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $164
80106bad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bb2:	e9 17 f5 ff ff       	jmp    801060ce <alltraps>

80106bb7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $165
80106bb9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106bbe:	e9 0b f5 ff ff       	jmp    801060ce <alltraps>

80106bc3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $166
80106bc5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106bca:	e9 ff f4 ff ff       	jmp    801060ce <alltraps>

80106bcf <vector167>:
.globl vector167
vector167:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $167
80106bd1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106bd6:	e9 f3 f4 ff ff       	jmp    801060ce <alltraps>

80106bdb <vector168>:
.globl vector168
vector168:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $168
80106bdd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106be2:	e9 e7 f4 ff ff       	jmp    801060ce <alltraps>

80106be7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $169
80106be9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106bee:	e9 db f4 ff ff       	jmp    801060ce <alltraps>

80106bf3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $170
80106bf5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106bfa:	e9 cf f4 ff ff       	jmp    801060ce <alltraps>

80106bff <vector171>:
.globl vector171
vector171:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $171
80106c01:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c06:	e9 c3 f4 ff ff       	jmp    801060ce <alltraps>

80106c0b <vector172>:
.globl vector172
vector172:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $172
80106c0d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c12:	e9 b7 f4 ff ff       	jmp    801060ce <alltraps>

80106c17 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $173
80106c19:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c1e:	e9 ab f4 ff ff       	jmp    801060ce <alltraps>

80106c23 <vector174>:
.globl vector174
vector174:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $174
80106c25:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c2a:	e9 9f f4 ff ff       	jmp    801060ce <alltraps>

80106c2f <vector175>:
.globl vector175
vector175:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $175
80106c31:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c36:	e9 93 f4 ff ff       	jmp    801060ce <alltraps>

80106c3b <vector176>:
.globl vector176
vector176:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $176
80106c3d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c42:	e9 87 f4 ff ff       	jmp    801060ce <alltraps>

80106c47 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $177
80106c49:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c4e:	e9 7b f4 ff ff       	jmp    801060ce <alltraps>

80106c53 <vector178>:
.globl vector178
vector178:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $178
80106c55:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c5a:	e9 6f f4 ff ff       	jmp    801060ce <alltraps>

80106c5f <vector179>:
.globl vector179
vector179:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $179
80106c61:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c66:	e9 63 f4 ff ff       	jmp    801060ce <alltraps>

80106c6b <vector180>:
.globl vector180
vector180:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $180
80106c6d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c72:	e9 57 f4 ff ff       	jmp    801060ce <alltraps>

80106c77 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $181
80106c79:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c7e:	e9 4b f4 ff ff       	jmp    801060ce <alltraps>

80106c83 <vector182>:
.globl vector182
vector182:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $182
80106c85:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c8a:	e9 3f f4 ff ff       	jmp    801060ce <alltraps>

80106c8f <vector183>:
.globl vector183
vector183:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $183
80106c91:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c96:	e9 33 f4 ff ff       	jmp    801060ce <alltraps>

80106c9b <vector184>:
.globl vector184
vector184:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $184
80106c9d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ca2:	e9 27 f4 ff ff       	jmp    801060ce <alltraps>

80106ca7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $185
80106ca9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cae:	e9 1b f4 ff ff       	jmp    801060ce <alltraps>

80106cb3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $186
80106cb5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106cba:	e9 0f f4 ff ff       	jmp    801060ce <alltraps>

80106cbf <vector187>:
.globl vector187
vector187:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $187
80106cc1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106cc6:	e9 03 f4 ff ff       	jmp    801060ce <alltraps>

80106ccb <vector188>:
.globl vector188
vector188:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $188
80106ccd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cd2:	e9 f7 f3 ff ff       	jmp    801060ce <alltraps>

80106cd7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $189
80106cd9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cde:	e9 eb f3 ff ff       	jmp    801060ce <alltraps>

80106ce3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $190
80106ce5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106cea:	e9 df f3 ff ff       	jmp    801060ce <alltraps>

80106cef <vector191>:
.globl vector191
vector191:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $191
80106cf1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106cf6:	e9 d3 f3 ff ff       	jmp    801060ce <alltraps>

80106cfb <vector192>:
.globl vector192
vector192:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $192
80106cfd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d02:	e9 c7 f3 ff ff       	jmp    801060ce <alltraps>

80106d07 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $193
80106d09:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d0e:	e9 bb f3 ff ff       	jmp    801060ce <alltraps>

80106d13 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $194
80106d15:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d1a:	e9 af f3 ff ff       	jmp    801060ce <alltraps>

80106d1f <vector195>:
.globl vector195
vector195:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $195
80106d21:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d26:	e9 a3 f3 ff ff       	jmp    801060ce <alltraps>

80106d2b <vector196>:
.globl vector196
vector196:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $196
80106d2d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d32:	e9 97 f3 ff ff       	jmp    801060ce <alltraps>

80106d37 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $197
80106d39:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d3e:	e9 8b f3 ff ff       	jmp    801060ce <alltraps>

80106d43 <vector198>:
.globl vector198
vector198:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $198
80106d45:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d4a:	e9 7f f3 ff ff       	jmp    801060ce <alltraps>

80106d4f <vector199>:
.globl vector199
vector199:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $199
80106d51:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d56:	e9 73 f3 ff ff       	jmp    801060ce <alltraps>

80106d5b <vector200>:
.globl vector200
vector200:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $200
80106d5d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d62:	e9 67 f3 ff ff       	jmp    801060ce <alltraps>

80106d67 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $201
80106d69:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d6e:	e9 5b f3 ff ff       	jmp    801060ce <alltraps>

80106d73 <vector202>:
.globl vector202
vector202:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $202
80106d75:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d7a:	e9 4f f3 ff ff       	jmp    801060ce <alltraps>

80106d7f <vector203>:
.globl vector203
vector203:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $203
80106d81:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d86:	e9 43 f3 ff ff       	jmp    801060ce <alltraps>

80106d8b <vector204>:
.globl vector204
vector204:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $204
80106d8d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d92:	e9 37 f3 ff ff       	jmp    801060ce <alltraps>

80106d97 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $205
80106d99:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d9e:	e9 2b f3 ff ff       	jmp    801060ce <alltraps>

80106da3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $206
80106da5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106daa:	e9 1f f3 ff ff       	jmp    801060ce <alltraps>

80106daf <vector207>:
.globl vector207
vector207:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $207
80106db1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106db6:	e9 13 f3 ff ff       	jmp    801060ce <alltraps>

80106dbb <vector208>:
.globl vector208
vector208:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $208
80106dbd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106dc2:	e9 07 f3 ff ff       	jmp    801060ce <alltraps>

80106dc7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $209
80106dc9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106dce:	e9 fb f2 ff ff       	jmp    801060ce <alltraps>

80106dd3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $210
80106dd5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106dda:	e9 ef f2 ff ff       	jmp    801060ce <alltraps>

80106ddf <vector211>:
.globl vector211
vector211:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $211
80106de1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106de6:	e9 e3 f2 ff ff       	jmp    801060ce <alltraps>

80106deb <vector212>:
.globl vector212
vector212:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $212
80106ded:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106df2:	e9 d7 f2 ff ff       	jmp    801060ce <alltraps>

80106df7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $213
80106df9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106dfe:	e9 cb f2 ff ff       	jmp    801060ce <alltraps>

80106e03 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $214
80106e05:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e0a:	e9 bf f2 ff ff       	jmp    801060ce <alltraps>

80106e0f <vector215>:
.globl vector215
vector215:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $215
80106e11:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e16:	e9 b3 f2 ff ff       	jmp    801060ce <alltraps>

80106e1b <vector216>:
.globl vector216
vector216:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $216
80106e1d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e22:	e9 a7 f2 ff ff       	jmp    801060ce <alltraps>

80106e27 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $217
80106e29:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e2e:	e9 9b f2 ff ff       	jmp    801060ce <alltraps>

80106e33 <vector218>:
.globl vector218
vector218:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $218
80106e35:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e3a:	e9 8f f2 ff ff       	jmp    801060ce <alltraps>

80106e3f <vector219>:
.globl vector219
vector219:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $219
80106e41:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e46:	e9 83 f2 ff ff       	jmp    801060ce <alltraps>

80106e4b <vector220>:
.globl vector220
vector220:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $220
80106e4d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e52:	e9 77 f2 ff ff       	jmp    801060ce <alltraps>

80106e57 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $221
80106e59:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e5e:	e9 6b f2 ff ff       	jmp    801060ce <alltraps>

80106e63 <vector222>:
.globl vector222
vector222:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $222
80106e65:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e6a:	e9 5f f2 ff ff       	jmp    801060ce <alltraps>

80106e6f <vector223>:
.globl vector223
vector223:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $223
80106e71:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e76:	e9 53 f2 ff ff       	jmp    801060ce <alltraps>

80106e7b <vector224>:
.globl vector224
vector224:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $224
80106e7d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e82:	e9 47 f2 ff ff       	jmp    801060ce <alltraps>

80106e87 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $225
80106e89:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e8e:	e9 3b f2 ff ff       	jmp    801060ce <alltraps>

80106e93 <vector226>:
.globl vector226
vector226:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $226
80106e95:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e9a:	e9 2f f2 ff ff       	jmp    801060ce <alltraps>

80106e9f <vector227>:
.globl vector227
vector227:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $227
80106ea1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ea6:	e9 23 f2 ff ff       	jmp    801060ce <alltraps>

80106eab <vector228>:
.globl vector228
vector228:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $228
80106ead:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106eb2:	e9 17 f2 ff ff       	jmp    801060ce <alltraps>

80106eb7 <vector229>:
.globl vector229
vector229:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $229
80106eb9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106ebe:	e9 0b f2 ff ff       	jmp    801060ce <alltraps>

80106ec3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $230
80106ec5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106eca:	e9 ff f1 ff ff       	jmp    801060ce <alltraps>

80106ecf <vector231>:
.globl vector231
vector231:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $231
80106ed1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ed6:	e9 f3 f1 ff ff       	jmp    801060ce <alltraps>

80106edb <vector232>:
.globl vector232
vector232:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $232
80106edd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ee2:	e9 e7 f1 ff ff       	jmp    801060ce <alltraps>

80106ee7 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $233
80106ee9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106eee:	e9 db f1 ff ff       	jmp    801060ce <alltraps>

80106ef3 <vector234>:
.globl vector234
vector234:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $234
80106ef5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106efa:	e9 cf f1 ff ff       	jmp    801060ce <alltraps>

80106eff <vector235>:
.globl vector235
vector235:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $235
80106f01:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f06:	e9 c3 f1 ff ff       	jmp    801060ce <alltraps>

80106f0b <vector236>:
.globl vector236
vector236:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $236
80106f0d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f12:	e9 b7 f1 ff ff       	jmp    801060ce <alltraps>

80106f17 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $237
80106f19:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f1e:	e9 ab f1 ff ff       	jmp    801060ce <alltraps>

80106f23 <vector238>:
.globl vector238
vector238:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $238
80106f25:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f2a:	e9 9f f1 ff ff       	jmp    801060ce <alltraps>

80106f2f <vector239>:
.globl vector239
vector239:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $239
80106f31:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f36:	e9 93 f1 ff ff       	jmp    801060ce <alltraps>

80106f3b <vector240>:
.globl vector240
vector240:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $240
80106f3d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f42:	e9 87 f1 ff ff       	jmp    801060ce <alltraps>

80106f47 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $241
80106f49:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f4e:	e9 7b f1 ff ff       	jmp    801060ce <alltraps>

80106f53 <vector242>:
.globl vector242
vector242:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $242
80106f55:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f5a:	e9 6f f1 ff ff       	jmp    801060ce <alltraps>

80106f5f <vector243>:
.globl vector243
vector243:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $243
80106f61:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f66:	e9 63 f1 ff ff       	jmp    801060ce <alltraps>

80106f6b <vector244>:
.globl vector244
vector244:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $244
80106f6d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f72:	e9 57 f1 ff ff       	jmp    801060ce <alltraps>

80106f77 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $245
80106f79:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f7e:	e9 4b f1 ff ff       	jmp    801060ce <alltraps>

80106f83 <vector246>:
.globl vector246
vector246:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $246
80106f85:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f8a:	e9 3f f1 ff ff       	jmp    801060ce <alltraps>

80106f8f <vector247>:
.globl vector247
vector247:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $247
80106f91:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f96:	e9 33 f1 ff ff       	jmp    801060ce <alltraps>

80106f9b <vector248>:
.globl vector248
vector248:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $248
80106f9d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106fa2:	e9 27 f1 ff ff       	jmp    801060ce <alltraps>

80106fa7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $249
80106fa9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106fae:	e9 1b f1 ff ff       	jmp    801060ce <alltraps>

80106fb3 <vector250>:
.globl vector250
vector250:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $250
80106fb5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106fba:	e9 0f f1 ff ff       	jmp    801060ce <alltraps>

80106fbf <vector251>:
.globl vector251
vector251:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $251
80106fc1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fc6:	e9 03 f1 ff ff       	jmp    801060ce <alltraps>

80106fcb <vector252>:
.globl vector252
vector252:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $252
80106fcd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106fd2:	e9 f7 f0 ff ff       	jmp    801060ce <alltraps>

80106fd7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $253
80106fd9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106fde:	e9 eb f0 ff ff       	jmp    801060ce <alltraps>

80106fe3 <vector254>:
.globl vector254
vector254:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $254
80106fe5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106fea:	e9 df f0 ff ff       	jmp    801060ce <alltraps>

80106fef <vector255>:
.globl vector255
vector255:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $255
80106ff1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ff6:	e9 d3 f0 ff ff       	jmp    801060ce <alltraps>
80106ffb:	66 90                	xchg   %ax,%ax
80106ffd:	66 90                	xchg   %ax,%ax
80106fff:	90                   	nop

80107000 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107007:	c1 ea 16             	shr    $0x16,%edx
{
8010700a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010700b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010700e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107011:	8b 1f                	mov    (%edi),%ebx
80107013:	f6 c3 01             	test   $0x1,%bl
80107016:	74 28                	je     80107040 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107018:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010701e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107024:	89 f0                	mov    %esi,%eax
}
80107026:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107029:	c1 e8 0a             	shr    $0xa,%eax
8010702c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107031:	01 d8                	add    %ebx,%eax
}
80107033:	5b                   	pop    %ebx
80107034:	5e                   	pop    %esi
80107035:	5f                   	pop    %edi
80107036:	5d                   	pop    %ebp
80107037:	c3                   	ret    
80107038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010703f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107040:	85 c9                	test   %ecx,%ecx
80107042:	74 2c                	je     80107070 <walkpgdir+0x70>
80107044:	e8 47 be ff ff       	call   80102e90 <kalloc>
80107049:	89 c3                	mov    %eax,%ebx
8010704b:	85 c0                	test   %eax,%eax
8010704d:	74 21                	je     80107070 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010704f:	83 ec 04             	sub    $0x4,%esp
80107052:	68 00 10 00 00       	push   $0x1000
80107057:	6a 00                	push   $0x0
80107059:	50                   	push   %eax
8010705a:	e8 71 de ff ff       	call   80104ed0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010705f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107065:	83 c4 10             	add    $0x10,%esp
80107068:	83 c8 07             	or     $0x7,%eax
8010706b:	89 07                	mov    %eax,(%edi)
8010706d:	eb b5                	jmp    80107024 <walkpgdir+0x24>
8010706f:	90                   	nop
}
80107070:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107073:	31 c0                	xor    %eax,%eax
}
80107075:	5b                   	pop    %ebx
80107076:	5e                   	pop    %esi
80107077:	5f                   	pop    %edi
80107078:	5d                   	pop    %ebp
80107079:	c3                   	ret    
8010707a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107080 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107086:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010708a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010708b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107090:	89 d6                	mov    %edx,%esi
{
80107092:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107093:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107099:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010709c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010709f:	8b 45 08             	mov    0x8(%ebp),%eax
801070a2:	29 f0                	sub    %esi,%eax
801070a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070a7:	eb 1f                	jmp    801070c8 <mappages+0x48>
801070a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801070b0:	f6 00 01             	testb  $0x1,(%eax)
801070b3:	75 45                	jne    801070fa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801070b5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801070b8:	83 cb 01             	or     $0x1,%ebx
801070bb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801070bd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801070c0:	74 2e                	je     801070f0 <mappages+0x70>
      break;
    a += PGSIZE;
801070c2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801070c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801070cb:	b9 01 00 00 00       	mov    $0x1,%ecx
801070d0:	89 f2                	mov    %esi,%edx
801070d2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801070d5:	89 f8                	mov    %edi,%eax
801070d7:	e8 24 ff ff ff       	call   80107000 <walkpgdir>
801070dc:	85 c0                	test   %eax,%eax
801070de:	75 d0                	jne    801070b0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801070e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070e8:	5b                   	pop    %ebx
801070e9:	5e                   	pop    %esi
801070ea:	5f                   	pop    %edi
801070eb:	5d                   	pop    %ebp
801070ec:	c3                   	ret    
801070ed:	8d 76 00             	lea    0x0(%esi),%esi
801070f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070f3:	31 c0                	xor    %eax,%eax
}
801070f5:	5b                   	pop    %ebx
801070f6:	5e                   	pop    %esi
801070f7:	5f                   	pop    %edi
801070f8:	5d                   	pop    %ebp
801070f9:	c3                   	ret    
      panic("remap");
801070fa:	83 ec 0c             	sub    $0xc,%esp
801070fd:	68 28 82 10 80       	push   $0x80108228
80107102:	e8 89 92 ff ff       	call   80100390 <panic>
80107107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710e:	66 90                	xchg   %ax,%ax

80107110 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	89 c6                	mov    %eax,%esi
80107117:	53                   	push   %ebx
80107118:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010711a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107120:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107126:	83 ec 1c             	sub    $0x1c,%esp
80107129:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010712c:	39 da                	cmp    %ebx,%edx
8010712e:	73 5b                	jae    8010718b <deallocuvm.part.0+0x7b>
80107130:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107133:	89 d7                	mov    %edx,%edi
80107135:	eb 14                	jmp    8010714b <deallocuvm.part.0+0x3b>
80107137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713e:	66 90                	xchg   %ax,%ax
80107140:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107146:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107149:	76 40                	jbe    8010718b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010714b:	31 c9                	xor    %ecx,%ecx
8010714d:	89 fa                	mov    %edi,%edx
8010714f:	89 f0                	mov    %esi,%eax
80107151:	e8 aa fe ff ff       	call   80107000 <walkpgdir>
80107156:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107158:	85 c0                	test   %eax,%eax
8010715a:	74 44                	je     801071a0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010715c:	8b 00                	mov    (%eax),%eax
8010715e:	a8 01                	test   $0x1,%al
80107160:	74 de                	je     80107140 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107167:	74 47                	je     801071b0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107169:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010716c:	05 00 00 00 80       	add    $0x80000000,%eax
80107171:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107177:	50                   	push   %eax
80107178:	e8 53 bb ff ff       	call   80102cd0 <kfree>
      *pte = 0;
8010717d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107183:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107186:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107189:	77 c0                	ja     8010714b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010718b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010718e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107191:	5b                   	pop    %ebx
80107192:	5e                   	pop    %esi
80107193:	5f                   	pop    %edi
80107194:	5d                   	pop    %ebp
80107195:	c3                   	ret    
80107196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010719d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801071a0:	89 fa                	mov    %edi,%edx
801071a2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801071a8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801071ae:	eb 96                	jmp    80107146 <deallocuvm.part.0+0x36>
        panic("kfree");
801071b0:	83 ec 0c             	sub    $0xc,%esp
801071b3:	68 e6 7b 10 80       	push   $0x80107be6
801071b8:	e8 d3 91 ff ff       	call   80100390 <panic>
801071bd:	8d 76 00             	lea    0x0(%esi),%esi

801071c0 <seginit>:
{
801071c0:	f3 0f 1e fb          	endbr32 
801071c4:	55                   	push   %ebp
801071c5:	89 e5                	mov    %esp,%ebp
801071c7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801071ca:	e8 d1 cf ff ff       	call   801041a0 <cpuid>
  pd[0] = size-1;
801071cf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071d4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801071da:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071de:	c7 80 b8 3d 11 80 ff 	movl   $0xffff,-0x7feec248(%eax)
801071e5:	ff 00 00 
801071e8:	c7 80 bc 3d 11 80 00 	movl   $0xcf9a00,-0x7feec244(%eax)
801071ef:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071f2:	c7 80 c0 3d 11 80 ff 	movl   $0xffff,-0x7feec240(%eax)
801071f9:	ff 00 00 
801071fc:	c7 80 c4 3d 11 80 00 	movl   $0xcf9200,-0x7feec23c(%eax)
80107203:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107206:	c7 80 c8 3d 11 80 ff 	movl   $0xffff,-0x7feec238(%eax)
8010720d:	ff 00 00 
80107210:	c7 80 cc 3d 11 80 00 	movl   $0xcffa00,-0x7feec234(%eax)
80107217:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010721a:	c7 80 d0 3d 11 80 ff 	movl   $0xffff,-0x7feec230(%eax)
80107221:	ff 00 00 
80107224:	c7 80 d4 3d 11 80 00 	movl   $0xcff200,-0x7feec22c(%eax)
8010722b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010722e:	05 b0 3d 11 80       	add    $0x80113db0,%eax
  pd[1] = (uint)p;
80107233:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107237:	c1 e8 10             	shr    $0x10,%eax
8010723a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010723e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107241:	0f 01 10             	lgdtl  (%eax)
}
80107244:	c9                   	leave  
80107245:	c3                   	ret    
80107246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724d:	8d 76 00             	lea    0x0(%esi),%esi

80107250 <switchkvm>:
{
80107250:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107254:	a1 64 6a 11 80       	mov    0x80116a64,%eax
80107259:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010725e:	0f 22 d8             	mov    %eax,%cr3
}
80107261:	c3                   	ret    
80107262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107270 <switchuvm>:
{
80107270:	f3 0f 1e fb          	endbr32 
80107274:	55                   	push   %ebp
80107275:	89 e5                	mov    %esp,%ebp
80107277:	57                   	push   %edi
80107278:	56                   	push   %esi
80107279:	53                   	push   %ebx
8010727a:	83 ec 1c             	sub    $0x1c,%esp
8010727d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107280:	85 f6                	test   %esi,%esi
80107282:	0f 84 cb 00 00 00    	je     80107353 <switchuvm+0xe3>
  if(p->kstack == 0)
80107288:	8b 46 08             	mov    0x8(%esi),%eax
8010728b:	85 c0                	test   %eax,%eax
8010728d:	0f 84 da 00 00 00    	je     8010736d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107293:	8b 46 04             	mov    0x4(%esi),%eax
80107296:	85 c0                	test   %eax,%eax
80107298:	0f 84 c2 00 00 00    	je     80107360 <switchuvm+0xf0>
  pushcli();
8010729e:	e8 1d da ff ff       	call   80104cc0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072a3:	e8 88 ce ff ff       	call   80104130 <mycpu>
801072a8:	89 c3                	mov    %eax,%ebx
801072aa:	e8 81 ce ff ff       	call   80104130 <mycpu>
801072af:	89 c7                	mov    %eax,%edi
801072b1:	e8 7a ce ff ff       	call   80104130 <mycpu>
801072b6:	83 c7 08             	add    $0x8,%edi
801072b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072bc:	e8 6f ce ff ff       	call   80104130 <mycpu>
801072c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072c4:	ba 67 00 00 00       	mov    $0x67,%edx
801072c9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072d0:	83 c0 08             	add    $0x8,%eax
801072d3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072da:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072df:	83 c1 08             	add    $0x8,%ecx
801072e2:	c1 e8 18             	shr    $0x18,%eax
801072e5:	c1 e9 10             	shr    $0x10,%ecx
801072e8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072ee:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072f4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072f9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107300:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107305:	e8 26 ce ff ff       	call   80104130 <mycpu>
8010730a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107311:	e8 1a ce ff ff       	call   80104130 <mycpu>
80107316:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010731a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010731d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107323:	e8 08 ce ff ff       	call   80104130 <mycpu>
80107328:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010732b:	e8 00 ce ff ff       	call   80104130 <mycpu>
80107330:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107334:	b8 28 00 00 00       	mov    $0x28,%eax
80107339:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010733c:	8b 46 04             	mov    0x4(%esi),%eax
8010733f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107344:	0f 22 d8             	mov    %eax,%cr3
}
80107347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010734a:	5b                   	pop    %ebx
8010734b:	5e                   	pop    %esi
8010734c:	5f                   	pop    %edi
8010734d:	5d                   	pop    %ebp
  popcli();
8010734e:	e9 bd d9 ff ff       	jmp    80104d10 <popcli>
    panic("switchuvm: no process");
80107353:	83 ec 0c             	sub    $0xc,%esp
80107356:	68 2e 82 10 80       	push   $0x8010822e
8010735b:	e8 30 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107360:	83 ec 0c             	sub    $0xc,%esp
80107363:	68 59 82 10 80       	push   $0x80108259
80107368:	e8 23 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010736d:	83 ec 0c             	sub    $0xc,%esp
80107370:	68 44 82 10 80       	push   $0x80108244
80107375:	e8 16 90 ff ff       	call   80100390 <panic>
8010737a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107380 <inituvm>:
{
80107380:	f3 0f 1e fb          	endbr32 
80107384:	55                   	push   %ebp
80107385:	89 e5                	mov    %esp,%ebp
80107387:	57                   	push   %edi
80107388:	56                   	push   %esi
80107389:	53                   	push   %ebx
8010738a:	83 ec 1c             	sub    $0x1c,%esp
8010738d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107390:	8b 75 10             	mov    0x10(%ebp),%esi
80107393:	8b 7d 08             	mov    0x8(%ebp),%edi
80107396:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107399:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010739f:	77 4b                	ja     801073ec <inituvm+0x6c>
  mem = kalloc();
801073a1:	e8 ea ba ff ff       	call   80102e90 <kalloc>
  memset(mem, 0, PGSIZE);
801073a6:	83 ec 04             	sub    $0x4,%esp
801073a9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801073ae:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801073b0:	6a 00                	push   $0x0
801073b2:	50                   	push   %eax
801073b3:	e8 18 db ff ff       	call   80104ed0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801073b8:	58                   	pop    %eax
801073b9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073bf:	5a                   	pop    %edx
801073c0:	6a 06                	push   $0x6
801073c2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073c7:	31 d2                	xor    %edx,%edx
801073c9:	50                   	push   %eax
801073ca:	89 f8                	mov    %edi,%eax
801073cc:	e8 af fc ff ff       	call   80107080 <mappages>
  memmove(mem, init, sz);
801073d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073d4:	89 75 10             	mov    %esi,0x10(%ebp)
801073d7:	83 c4 10             	add    $0x10,%esp
801073da:	89 5d 08             	mov    %ebx,0x8(%ebp)
801073dd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801073e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073e3:	5b                   	pop    %ebx
801073e4:	5e                   	pop    %esi
801073e5:	5f                   	pop    %edi
801073e6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073e7:	e9 84 db ff ff       	jmp    80104f70 <memmove>
    panic("inituvm: more than a page");
801073ec:	83 ec 0c             	sub    $0xc,%esp
801073ef:	68 6d 82 10 80       	push   $0x8010826d
801073f4:	e8 97 8f ff ff       	call   80100390 <panic>
801073f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107400 <loaduvm>:
{
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	57                   	push   %edi
80107408:	56                   	push   %esi
80107409:	53                   	push   %ebx
8010740a:	83 ec 1c             	sub    $0x1c,%esp
8010740d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107410:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107413:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107418:	0f 85 99 00 00 00    	jne    801074b7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010741e:	01 f0                	add    %esi,%eax
80107420:	89 f3                	mov    %esi,%ebx
80107422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107425:	8b 45 14             	mov    0x14(%ebp),%eax
80107428:	01 f0                	add    %esi,%eax
8010742a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010742d:	85 f6                	test   %esi,%esi
8010742f:	75 15                	jne    80107446 <loaduvm+0x46>
80107431:	eb 6d                	jmp    801074a0 <loaduvm+0xa0>
80107433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107437:	90                   	nop
80107438:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010743e:	89 f0                	mov    %esi,%eax
80107440:	29 d8                	sub    %ebx,%eax
80107442:	39 c6                	cmp    %eax,%esi
80107444:	76 5a                	jbe    801074a0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107446:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107449:	8b 45 08             	mov    0x8(%ebp),%eax
8010744c:	31 c9                	xor    %ecx,%ecx
8010744e:	29 da                	sub    %ebx,%edx
80107450:	e8 ab fb ff ff       	call   80107000 <walkpgdir>
80107455:	85 c0                	test   %eax,%eax
80107457:	74 51                	je     801074aa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107459:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010745b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010745e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107463:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107468:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010746e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107471:	29 d9                	sub    %ebx,%ecx
80107473:	05 00 00 00 80       	add    $0x80000000,%eax
80107478:	57                   	push   %edi
80107479:	51                   	push   %ecx
8010747a:	50                   	push   %eax
8010747b:	ff 75 10             	pushl  0x10(%ebp)
8010747e:	e8 3d ae ff ff       	call   801022c0 <readi>
80107483:	83 c4 10             	add    $0x10,%esp
80107486:	39 f8                	cmp    %edi,%eax
80107488:	74 ae                	je     80107438 <loaduvm+0x38>
}
8010748a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010748d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107492:	5b                   	pop    %ebx
80107493:	5e                   	pop    %esi
80107494:	5f                   	pop    %edi
80107495:	5d                   	pop    %ebp
80107496:	c3                   	ret    
80107497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749e:	66 90                	xchg   %ax,%ax
801074a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074a3:	31 c0                	xor    %eax,%eax
}
801074a5:	5b                   	pop    %ebx
801074a6:	5e                   	pop    %esi
801074a7:	5f                   	pop    %edi
801074a8:	5d                   	pop    %ebp
801074a9:	c3                   	ret    
      panic("loaduvm: address should exist");
801074aa:	83 ec 0c             	sub    $0xc,%esp
801074ad:	68 87 82 10 80       	push   $0x80108287
801074b2:	e8 d9 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801074b7:	83 ec 0c             	sub    $0xc,%esp
801074ba:	68 28 83 10 80       	push   $0x80108328
801074bf:	e8 cc 8e ff ff       	call   80100390 <panic>
801074c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074cf:	90                   	nop

801074d0 <allocuvm>:
{
801074d0:	f3 0f 1e fb          	endbr32 
801074d4:	55                   	push   %ebp
801074d5:	89 e5                	mov    %esp,%ebp
801074d7:	57                   	push   %edi
801074d8:	56                   	push   %esi
801074d9:	53                   	push   %ebx
801074da:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801074dd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801074e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801074e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074e6:	85 c0                	test   %eax,%eax
801074e8:	0f 88 b2 00 00 00    	js     801075a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801074ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801074f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801074f4:	0f 82 96 00 00 00    	jb     80107590 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801074fa:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107500:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107506:	39 75 10             	cmp    %esi,0x10(%ebp)
80107509:	77 40                	ja     8010754b <allocuvm+0x7b>
8010750b:	e9 83 00 00 00       	jmp    80107593 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107510:	83 ec 04             	sub    $0x4,%esp
80107513:	68 00 10 00 00       	push   $0x1000
80107518:	6a 00                	push   $0x0
8010751a:	50                   	push   %eax
8010751b:	e8 b0 d9 ff ff       	call   80104ed0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107520:	58                   	pop    %eax
80107521:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107527:	5a                   	pop    %edx
80107528:	6a 06                	push   $0x6
8010752a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010752f:	89 f2                	mov    %esi,%edx
80107531:	50                   	push   %eax
80107532:	89 f8                	mov    %edi,%eax
80107534:	e8 47 fb ff ff       	call   80107080 <mappages>
80107539:	83 c4 10             	add    $0x10,%esp
8010753c:	85 c0                	test   %eax,%eax
8010753e:	78 78                	js     801075b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107540:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107546:	39 75 10             	cmp    %esi,0x10(%ebp)
80107549:	76 48                	jbe    80107593 <allocuvm+0xc3>
    mem = kalloc();
8010754b:	e8 40 b9 ff ff       	call   80102e90 <kalloc>
80107550:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107552:	85 c0                	test   %eax,%eax
80107554:	75 ba                	jne    80107510 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107556:	83 ec 0c             	sub    $0xc,%esp
80107559:	68 a5 82 10 80       	push   $0x801082a5
8010755e:	e8 ed 93 ff ff       	call   80100950 <cprintf>
  if(newsz >= oldsz)
80107563:	8b 45 0c             	mov    0xc(%ebp),%eax
80107566:	83 c4 10             	add    $0x10,%esp
80107569:	39 45 10             	cmp    %eax,0x10(%ebp)
8010756c:	74 32                	je     801075a0 <allocuvm+0xd0>
8010756e:	8b 55 10             	mov    0x10(%ebp),%edx
80107571:	89 c1                	mov    %eax,%ecx
80107573:	89 f8                	mov    %edi,%eax
80107575:	e8 96 fb ff ff       	call   80107110 <deallocuvm.part.0>
      return 0;
8010757a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107584:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107587:	5b                   	pop    %ebx
80107588:	5e                   	pop    %esi
80107589:	5f                   	pop    %edi
8010758a:	5d                   	pop    %ebp
8010758b:	c3                   	ret    
8010758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107599:	5b                   	pop    %ebx
8010759a:	5e                   	pop    %esi
8010759b:	5f                   	pop    %edi
8010759c:	5d                   	pop    %ebp
8010759d:	c3                   	ret    
8010759e:	66 90                	xchg   %ax,%ax
    return 0;
801075a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ad:	5b                   	pop    %ebx
801075ae:	5e                   	pop    %esi
801075af:	5f                   	pop    %edi
801075b0:	5d                   	pop    %ebp
801075b1:	c3                   	ret    
801075b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801075b8:	83 ec 0c             	sub    $0xc,%esp
801075bb:	68 bd 82 10 80       	push   $0x801082bd
801075c0:	e8 8b 93 ff ff       	call   80100950 <cprintf>
  if(newsz >= oldsz)
801075c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801075c8:	83 c4 10             	add    $0x10,%esp
801075cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ce:	74 0c                	je     801075dc <allocuvm+0x10c>
801075d0:	8b 55 10             	mov    0x10(%ebp),%edx
801075d3:	89 c1                	mov    %eax,%ecx
801075d5:	89 f8                	mov    %edi,%eax
801075d7:	e8 34 fb ff ff       	call   80107110 <deallocuvm.part.0>
      kfree(mem);
801075dc:	83 ec 0c             	sub    $0xc,%esp
801075df:	53                   	push   %ebx
801075e0:	e8 eb b6 ff ff       	call   80102cd0 <kfree>
      return 0;
801075e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801075ec:	83 c4 10             	add    $0x10,%esp
}
801075ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075f5:	5b                   	pop    %ebx
801075f6:	5e                   	pop    %esi
801075f7:	5f                   	pop    %edi
801075f8:	5d                   	pop    %ebp
801075f9:	c3                   	ret    
801075fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107600 <deallocuvm>:
{
80107600:	f3 0f 1e fb          	endbr32 
80107604:	55                   	push   %ebp
80107605:	89 e5                	mov    %esp,%ebp
80107607:	8b 55 0c             	mov    0xc(%ebp),%edx
8010760a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010760d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107610:	39 d1                	cmp    %edx,%ecx
80107612:	73 0c                	jae    80107620 <deallocuvm+0x20>
}
80107614:	5d                   	pop    %ebp
80107615:	e9 f6 fa ff ff       	jmp    80107110 <deallocuvm.part.0>
8010761a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107620:	89 d0                	mov    %edx,%eax
80107622:	5d                   	pop    %ebp
80107623:	c3                   	ret    
80107624:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010762f:	90                   	nop

80107630 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107630:	f3 0f 1e fb          	endbr32 
80107634:	55                   	push   %ebp
80107635:	89 e5                	mov    %esp,%ebp
80107637:	57                   	push   %edi
80107638:	56                   	push   %esi
80107639:	53                   	push   %ebx
8010763a:	83 ec 0c             	sub    $0xc,%esp
8010763d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107640:	85 f6                	test   %esi,%esi
80107642:	74 55                	je     80107699 <freevm+0x69>
  if(newsz >= oldsz)
80107644:	31 c9                	xor    %ecx,%ecx
80107646:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010764b:	89 f0                	mov    %esi,%eax
8010764d:	89 f3                	mov    %esi,%ebx
8010764f:	e8 bc fa ff ff       	call   80107110 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107654:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010765a:	eb 0b                	jmp    80107667 <freevm+0x37>
8010765c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107660:	83 c3 04             	add    $0x4,%ebx
80107663:	39 df                	cmp    %ebx,%edi
80107665:	74 23                	je     8010768a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107667:	8b 03                	mov    (%ebx),%eax
80107669:	a8 01                	test   $0x1,%al
8010766b:	74 f3                	je     80107660 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010766d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107672:	83 ec 0c             	sub    $0xc,%esp
80107675:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107678:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010767d:	50                   	push   %eax
8010767e:	e8 4d b6 ff ff       	call   80102cd0 <kfree>
80107683:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107686:	39 df                	cmp    %ebx,%edi
80107688:	75 dd                	jne    80107667 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010768a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010768d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107690:	5b                   	pop    %ebx
80107691:	5e                   	pop    %esi
80107692:	5f                   	pop    %edi
80107693:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107694:	e9 37 b6 ff ff       	jmp    80102cd0 <kfree>
    panic("freevm: no pgdir");
80107699:	83 ec 0c             	sub    $0xc,%esp
8010769c:	68 d9 82 10 80       	push   $0x801082d9
801076a1:	e8 ea 8c ff ff       	call   80100390 <panic>
801076a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ad:	8d 76 00             	lea    0x0(%esi),%esi

801076b0 <setupkvm>:
{
801076b0:	f3 0f 1e fb          	endbr32 
801076b4:	55                   	push   %ebp
801076b5:	89 e5                	mov    %esp,%ebp
801076b7:	56                   	push   %esi
801076b8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801076b9:	e8 d2 b7 ff ff       	call   80102e90 <kalloc>
801076be:	89 c6                	mov    %eax,%esi
801076c0:	85 c0                	test   %eax,%eax
801076c2:	74 42                	je     80107706 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801076c4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076c7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801076cc:	68 00 10 00 00       	push   $0x1000
801076d1:	6a 00                	push   $0x0
801076d3:	50                   	push   %eax
801076d4:	e8 f7 d7 ff ff       	call   80104ed0 <memset>
801076d9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801076dc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801076df:	83 ec 08             	sub    $0x8,%esp
801076e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801076e5:	ff 73 0c             	pushl  0xc(%ebx)
801076e8:	8b 13                	mov    (%ebx),%edx
801076ea:	50                   	push   %eax
801076eb:	29 c1                	sub    %eax,%ecx
801076ed:	89 f0                	mov    %esi,%eax
801076ef:	e8 8c f9 ff ff       	call   80107080 <mappages>
801076f4:	83 c4 10             	add    $0x10,%esp
801076f7:	85 c0                	test   %eax,%eax
801076f9:	78 15                	js     80107710 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076fb:	83 c3 10             	add    $0x10,%ebx
801076fe:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107704:	75 d6                	jne    801076dc <setupkvm+0x2c>
}
80107706:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107709:	89 f0                	mov    %esi,%eax
8010770b:	5b                   	pop    %ebx
8010770c:	5e                   	pop    %esi
8010770d:	5d                   	pop    %ebp
8010770e:	c3                   	ret    
8010770f:	90                   	nop
      freevm(pgdir);
80107710:	83 ec 0c             	sub    $0xc,%esp
80107713:	56                   	push   %esi
      return 0;
80107714:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107716:	e8 15 ff ff ff       	call   80107630 <freevm>
      return 0;
8010771b:	83 c4 10             	add    $0x10,%esp
}
8010771e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107721:	89 f0                	mov    %esi,%eax
80107723:	5b                   	pop    %ebx
80107724:	5e                   	pop    %esi
80107725:	5d                   	pop    %ebp
80107726:	c3                   	ret    
80107727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772e:	66 90                	xchg   %ax,%ax

80107730 <kvmalloc>:
{
80107730:	f3 0f 1e fb          	endbr32 
80107734:	55                   	push   %ebp
80107735:	89 e5                	mov    %esp,%ebp
80107737:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010773a:	e8 71 ff ff ff       	call   801076b0 <setupkvm>
8010773f:	a3 64 6a 11 80       	mov    %eax,0x80116a64
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107744:	05 00 00 00 80       	add    $0x80000000,%eax
80107749:	0f 22 d8             	mov    %eax,%cr3
}
8010774c:	c9                   	leave  
8010774d:	c3                   	ret    
8010774e:	66 90                	xchg   %ax,%ax

80107750 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107750:	f3 0f 1e fb          	endbr32 
80107754:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107755:	31 c9                	xor    %ecx,%ecx
{
80107757:	89 e5                	mov    %esp,%ebp
80107759:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010775c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010775f:	8b 45 08             	mov    0x8(%ebp),%eax
80107762:	e8 99 f8 ff ff       	call   80107000 <walkpgdir>
  if(pte == 0)
80107767:	85 c0                	test   %eax,%eax
80107769:	74 05                	je     80107770 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010776b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010776e:	c9                   	leave  
8010776f:	c3                   	ret    
    panic("clearpteu");
80107770:	83 ec 0c             	sub    $0xc,%esp
80107773:	68 ea 82 10 80       	push   $0x801082ea
80107778:	e8 13 8c ff ff       	call   80100390 <panic>
8010777d:	8d 76 00             	lea    0x0(%esi),%esi

80107780 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107780:	f3 0f 1e fb          	endbr32 
80107784:	55                   	push   %ebp
80107785:	89 e5                	mov    %esp,%ebp
80107787:	57                   	push   %edi
80107788:	56                   	push   %esi
80107789:	53                   	push   %ebx
8010778a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010778d:	e8 1e ff ff ff       	call   801076b0 <setupkvm>
80107792:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107795:	85 c0                	test   %eax,%eax
80107797:	0f 84 9b 00 00 00    	je     80107838 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010779d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077a0:	85 c9                	test   %ecx,%ecx
801077a2:	0f 84 90 00 00 00    	je     80107838 <copyuvm+0xb8>
801077a8:	31 f6                	xor    %esi,%esi
801077aa:	eb 46                	jmp    801077f2 <copyuvm+0x72>
801077ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801077b0:	83 ec 04             	sub    $0x4,%esp
801077b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801077b9:	68 00 10 00 00       	push   $0x1000
801077be:	57                   	push   %edi
801077bf:	50                   	push   %eax
801077c0:	e8 ab d7 ff ff       	call   80104f70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801077c5:	58                   	pop    %eax
801077c6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077cc:	5a                   	pop    %edx
801077cd:	ff 75 e4             	pushl  -0x1c(%ebp)
801077d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077d5:	89 f2                	mov    %esi,%edx
801077d7:	50                   	push   %eax
801077d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077db:	e8 a0 f8 ff ff       	call   80107080 <mappages>
801077e0:	83 c4 10             	add    $0x10,%esp
801077e3:	85 c0                	test   %eax,%eax
801077e5:	78 61                	js     80107848 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801077e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801077ed:	39 75 0c             	cmp    %esi,0xc(%ebp)
801077f0:	76 46                	jbe    80107838 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077f2:	8b 45 08             	mov    0x8(%ebp),%eax
801077f5:	31 c9                	xor    %ecx,%ecx
801077f7:	89 f2                	mov    %esi,%edx
801077f9:	e8 02 f8 ff ff       	call   80107000 <walkpgdir>
801077fe:	85 c0                	test   %eax,%eax
80107800:	74 61                	je     80107863 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107802:	8b 00                	mov    (%eax),%eax
80107804:	a8 01                	test   $0x1,%al
80107806:	74 4e                	je     80107856 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107808:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010780a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010780f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107812:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107818:	e8 73 b6 ff ff       	call   80102e90 <kalloc>
8010781d:	89 c3                	mov    %eax,%ebx
8010781f:	85 c0                	test   %eax,%eax
80107821:	75 8d                	jne    801077b0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107823:	83 ec 0c             	sub    $0xc,%esp
80107826:	ff 75 e0             	pushl  -0x20(%ebp)
80107829:	e8 02 fe ff ff       	call   80107630 <freevm>
  return 0;
8010782e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107835:	83 c4 10             	add    $0x10,%esp
}
80107838:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010783b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010783e:	5b                   	pop    %ebx
8010783f:	5e                   	pop    %esi
80107840:	5f                   	pop    %edi
80107841:	5d                   	pop    %ebp
80107842:	c3                   	ret    
80107843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107847:	90                   	nop
      kfree(mem);
80107848:	83 ec 0c             	sub    $0xc,%esp
8010784b:	53                   	push   %ebx
8010784c:	e8 7f b4 ff ff       	call   80102cd0 <kfree>
      goto bad;
80107851:	83 c4 10             	add    $0x10,%esp
80107854:	eb cd                	jmp    80107823 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107856:	83 ec 0c             	sub    $0xc,%esp
80107859:	68 0e 83 10 80       	push   $0x8010830e
8010785e:	e8 2d 8b ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107863:	83 ec 0c             	sub    $0xc,%esp
80107866:	68 f4 82 10 80       	push   $0x801082f4
8010786b:	e8 20 8b ff ff       	call   80100390 <panic>

80107870 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107870:	f3 0f 1e fb          	endbr32 
80107874:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107875:	31 c9                	xor    %ecx,%ecx
{
80107877:	89 e5                	mov    %esp,%ebp
80107879:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010787c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010787f:	8b 45 08             	mov    0x8(%ebp),%eax
80107882:	e8 79 f7 ff ff       	call   80107000 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107887:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107889:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010788a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010788c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107891:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107894:	05 00 00 00 80       	add    $0x80000000,%eax
80107899:	83 fa 05             	cmp    $0x5,%edx
8010789c:	ba 00 00 00 00       	mov    $0x0,%edx
801078a1:	0f 45 c2             	cmovne %edx,%eax
}
801078a4:	c3                   	ret    
801078a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801078b0:	f3 0f 1e fb          	endbr32 
801078b4:	55                   	push   %ebp
801078b5:	89 e5                	mov    %esp,%ebp
801078b7:	57                   	push   %edi
801078b8:	56                   	push   %esi
801078b9:	53                   	push   %ebx
801078ba:	83 ec 0c             	sub    $0xc,%esp
801078bd:	8b 75 14             	mov    0x14(%ebp),%esi
801078c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801078c3:	85 f6                	test   %esi,%esi
801078c5:	75 3c                	jne    80107903 <copyout+0x53>
801078c7:	eb 67                	jmp    80107930 <copyout+0x80>
801078c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801078d0:	8b 55 0c             	mov    0xc(%ebp),%edx
801078d3:	89 fb                	mov    %edi,%ebx
801078d5:	29 d3                	sub    %edx,%ebx
801078d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801078dd:	39 f3                	cmp    %esi,%ebx
801078df:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801078e2:	29 fa                	sub    %edi,%edx
801078e4:	83 ec 04             	sub    $0x4,%esp
801078e7:	01 c2                	add    %eax,%edx
801078e9:	53                   	push   %ebx
801078ea:	ff 75 10             	pushl  0x10(%ebp)
801078ed:	52                   	push   %edx
801078ee:	e8 7d d6 ff ff       	call   80104f70 <memmove>
    len -= n;
    buf += n;
801078f3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801078f6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801078fc:	83 c4 10             	add    $0x10,%esp
801078ff:	29 de                	sub    %ebx,%esi
80107901:	74 2d                	je     80107930 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107903:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107905:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107908:	89 55 0c             	mov    %edx,0xc(%ebp)
8010790b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107911:	57                   	push   %edi
80107912:	ff 75 08             	pushl  0x8(%ebp)
80107915:	e8 56 ff ff ff       	call   80107870 <uva2ka>
    if(pa0 == 0)
8010791a:	83 c4 10             	add    $0x10,%esp
8010791d:	85 c0                	test   %eax,%eax
8010791f:	75 af                	jne    801078d0 <copyout+0x20>
  }
  return 0;
}
80107921:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107924:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107929:	5b                   	pop    %ebx
8010792a:	5e                   	pop    %esi
8010792b:	5f                   	pop    %edi
8010792c:	5d                   	pop    %ebp
8010792d:	c3                   	ret    
8010792e:	66 90                	xchg   %ax,%ax
80107930:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107933:	31 c0                	xor    %eax,%eax
}
80107935:	5b                   	pop    %ebx
80107936:	5e                   	pop    %esi
80107937:	5f                   	pop    %edi
80107938:	5d                   	pop    %ebp
80107939:	c3                   	ret    
